# test_batch_bv.gd — TRANCHE 2, THE HUNTER NINE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bv.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §6 names eight clauses that could silently do nothing or the
# wrong thing, plus Hunt's distinct-count. EVERY ONE IS BUILT SO A BROKEN
# IMPLEMENTATION STILL FAILS, which for most of them means the obvious assertion
# is not the one that discriminates:
#
# · BLOODBOND holds until it FIRES. "The status is there" is trivially true of a
#   3-turn version on the turn it was cast, so the guard is aged past any
#   plausible duration before the blow arrives. The redirect is asserted as an
#   EXACT half against a beast left on EXACTLY 1 — a version that redirected the
#   whole blow, or that refused it without billing, passes "the beast lived" and
#   fails both of these. It is then driven a second time at low hunter health to
#   assert the half CAN KILL HIM, and a third with no guard at all, where the
#   beast must die (the negative control: a guard that fires unconditionally
#   would pass every check above).
# · SAVAGE SWEEP picks the THREE LOWEST. "Three enemies were hit" is trivially
#   true of a random spread, so five enemies are seated at five separated health
#   FRACTIONS and the three victims are asserted BY IDENTITY — and the two
#   healthiest asserted untouched. Under The Pack it is then driven with TWO
#   beasts standing and the count asserted STILL THREE, which is the ordered-
#   action rule, and the Loyalty asserted onto the DEEPER bond by name.
# · GHOSTPACK includes companions NO LONGER STANDING. "It dealt damage" is
#   trivially true while a beast is out, so the discriminating construction is a
#   summoned beast that is then KILLED: the field is empty, `beasts` is empty,
#   and the strike must still land. The hunter's damage credit is asserted in
#   the same breath (BB §4's repair — an uncredited second bodiless striker
#   would undo it and nothing would crash).
# · CROSSFIRE splashes ONLY on a crit. "Other enemies took damage" is trivially
#   true of an unconditional version, so the SAME cast is driven twice — once
#   with the crit roll dead (`crit_bonus = -1.0`) and once with it forced — and
#   the no-crit case must land NOTHING on the other bodies. The count is
#   asserted at exactly 2 on a five-enemy field, which is what tells "2 others"
#   from "all others".
# · CALIBRATING SHOT reads MISSING health. A fresh enemy is the discriminating
#   case and it is subtle: the shot itself wounds the target, so a version
#   reading the board AFTER the strike pays a few Focus and looks right. The
#   check therefore asserts the full-health cast pays EXACTLY the ordinary
#   engine's gain and not one point more, measured against a control cast.
# · TROPHY SHOT preserves Focus ONLY on a kill. "He kept his Focus" is trivially
#   true of a version that never clamps, so the same hero at the same 200 Focus
#   is driven three ways: Trophy Shot that KILLS (keeps all), Trophy Shot that
#   does NOT kill and then a switch (ordinary rules), and a DIFFERENT ability
#   that kills (clamped to 50). Overkill is held at zero throughout, or its own
#   carry would keep the meter whole and hide everything.
# · LOADED SHOT resets to FULL. "The duration went up" is trivially true, so a
#   status is aged DOWN and asserted back at its exact original, a PERMANENT one
#   (turns -1) is asserted still permanent rather than converted to a number,
#   and a re-applied Burn standing LONGER than it started is asserted NOT
#   shortened — the one way a maintenance card can be a nerf.
# · PREPARATION grants ONE extra turn AFTER the next, and REFUSES to be cast
#   while one is pending. The refusal is the negative control that matters and
#   it is driven at `_ability_usable` directly. The counter is stepped one tick
#   at a time with the clock asserted UNMOVED on the first — a version that
#   fired immediately passes "he acted again" and fails here.
# · HUNT counts DISTINCT effects. "It scaled" is trivially true, so five stacks
#   of one Poison plus one other affliction is driven against two DIFFERENT
#   afflictions and the two blows asserted EQUAL — a stack-counting version
#   reads 6 against 2 and cannot pass an equality.
#
# HARNESS NOTE: several checks compare one blow against one blow, and the first
# line of the strike block is `randf_range(0.9, 1.1)`. `crit_bonus = -1.0` at
# spawn kills the crit roll (BQ) and `_seeded()` before a pair makes both draw
# the same variance (BS). Forced determinism, never a retry. BS's other half
# holds too: where a comparison could be swallowed by that variance the check
# asserts a RATIO with open ground rather than a bare `<`.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on.
const CROSSFIRE_SHARE_TEST := 0.40
const GHOSTPACK_SHARE_TEST := 0.40
const FOCUS_KILL_RETAIN_TEST := 50

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# The machine-checkable half of "the batch shipped what it said".
const NINE := {
	"Bloodbond":        ["beastmaster", 20, 2.0, 4, 0],
	"Savage Sweep":     ["beastmaster", 25, 2.5, 4, 0],
	"Ghostpack":        ["beastmaster", 25, 2.5, 5, 0],
	"Crossfire":        ["sharpshooter", 25, 2.5, 4, 10],
	"Calibrating Shot": ["sharpshooter", 20, 1.5, 3, 8],
	"Trophy Shot":      ["sharpshooter", 25, 2.5, 4, 12],
	"Loaded Shot":      ["mystic", 20, 2.0, 4, 8],
	"Hunt":             ["mystic", 25, 2.5, 4, 10],
	"Preparation":      ["mystic", 25, 2.0, 5, 0],
}

# The four that resolve through a `special`, and the five that deliberately do
# NOT — see the header in `Classes.draft_ability`. The split is asserted both
# ways round, because either half getting it wrong is silent: a `special` on a
# damage card sends it down `_resolve_special` and it quietly stops critting,
# and a missing one on an effect card makes the cast do nothing at all.
const SPECIALS := {
	"Bloodbond": "bloodbond", "Savage Sweep": "savage_sweep",
	"Ghostpack": "ghostpack", "Preparation": "preparation",
}
const NO_SPECIAL := ["Crossfire", "Calibrating Shot", "Trophy Shot",
	"Loaded Shot", "Hunt"]


func _initialize() -> void:
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bv_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_definitions()
	_synergy_rule()
	_names()
	_status_registry()
	_unit_state()
	_source_rules()
	_docs()
	await _live_bloodbond()
	await _live_savage_sweep()
	await _live_ghostpack()
	await _live_crossfire()
	await _live_calibrating_shot()
	await _live_trophy_shot()
	await _live_loaded_shot()
	await _live_hunt()
	await _live_preparation()
	await _live_gates()

	if FileAccess.file_exists("user://profile_batch_bv_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bv_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BV: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- the pools ----------

func _pools() -> void:
	# THE HUNTER THREE JOIN THE MAGE AND CLERIC AT FIVE; THE WARRIOR THREE DO
	# NOT MOVE. A batch that widens three pools is exactly where a fourth gets
	# widened by accident, and the Warrior debt has to stay visible IN CODE
	# rather than only in prose — it is the last third of tranche 2.
	# RE-POINTED BY BATCH CB, THE FOURTH INVERSION: the three MAGE pools went
	# to EIGHT when tranche 3's first third landed, so the Hunter three this
	# suite shipped are no longer level with them. What still has to stay
	# visible in code is which thirds are owed.
	# RE-POINTED BY BATCH CE, AND IT IS THE FIFTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, and now that asymmetry HALVED
	# — the CLERIC three joined the Mage three at EIGHT when tranche 3's second
	# third landed, so six pools are eight deep and six are five. The question is
	# unchanged and is still what tells the two answers apart; what is owed now
	# is the HUNTER and WARRIOR thirds, and it has to stay visible in code.
	var five := ["beastmaster", "sharpshooter", "mystic"]
	for spec in five:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 5, "%s drafts FIVE (got %d)" % [spec, pool.size()])
	for spec in ["pyromancer", "cryomancer", "arcanist",
			"holy", "inquisitor", "occultist"]:
		ok(Classes.spec_draft_pool(spec).size() == 8,
			"%s drafts EIGHT since Batch CB/CE (got %d)"
				% [spec, Classes.spec_draft_pool(spec).size()])
	# RE-POINTED BY BATCH BW, AND IT IS AN INVERSION: this asserted the WARRIOR
	# three were still at TWO because that debt was real and had to stay visible
	# in code. BW paid it, so tranche 2 is complete and what is asserted is that
	# ALL TWELVE are five. A pool quietly emptying still trips.
	var still_two := ["berserker", "warden", "swordmaster"]
	for spec in still_two:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s drafts FIVE since Batch BW — the WARRIOR third is PAID (got %d)"
				% [spec, Classes.spec_draft_pool(spec).size()])
	# And nothing else exists: twelve specs, nine at five and three at two.
	ok(Classes.SPEC_DRAFT_POOLS.size() == 12, "there are twelve spec pools")
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 78, "the spec pools hold 78 (60 + CB's Mage nine + CE's Cleric nine), got %d" % total)
	var draft_total := total
	for cls in Classes.CLASS_DRAFT_POOLS:
		draft_total += Classes.class_draft_pool(cls).size()
	ok(draft_total == 102,
		"the whole draft is 102 of a target 120 (got %d)" % draft_total)
	# TRANCHE 1's ENTRIES ARE STILL THE FIRST TWO OF EACH HUNTER POOL. A later
	# tranche APPENDS; it does not rewrite. Pinned as literals because a swap of
	# two names would keep every count and change what the draft offers.
	ok(Classes.spec_draft_pool("beastmaster")[0] == "Twin Hunt"
		and Classes.spec_draft_pool("beastmaster")[1] == "Call the Wilds",
		"the Beastmaster's tranche-1 pair still leads his pool")
	ok(Classes.spec_draft_pool("sharpshooter")[0] == "Called Volley"
		and Classes.spec_draft_pool("sharpshooter")[1] == "Quarry's Mark",
		"the Sharpshooter's tranche-1 pair still leads his pool")
	ok(Classes.spec_draft_pool("mystic")[0] == "Choking Smoke"
		and Classes.spec_draft_pool("mystic")[1] == "Snare Line",
		"the Survivalist's tranche-1 pair still leads his pool")
	# THE MAGE AND CLERIC SIX ARE BYTE-UNTOUCHED, asserted by their leading
	# names rather than by size — a swap would keep the count.
	ok(Classes.spec_draft_pool("pyromancer")[0] == "Cinderfall"
		and Classes.spec_draft_pool("holy")[0] == "Second Wind",
		"BT's and BU's pools still lead with their own tranche-1 entries")
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR/BU negative control.
	for cls in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls).size() == 6,
			"%s's class pool is still SIX" % cls)
		for n in NINE:
			ok(not Classes.class_draft_pool(cls).has(n),
				"%s is a SPEC card and is not in %s's class pool" % [n, cls])
	# CLASS_POOLS AND SPEC_POOLS FEED THE BOSS PICK and must not move (BO's
	# rule): dropping nine names in there would silently re-weight every boss
	# offer in the game as a side effect of a draft change.
	for n in NINE:
		for cls in Classes.CLASS_POOLS:
			ok(not Classes.CLASS_POOLS[cls].has(n),
				"%s did not leak into the BOSS pool %s" % [n, cls])
		for spec in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec].has(n),
				"%s did not leak into the boss SPEC pool %s" % [n, spec])
	# THE PROTECTED CORES DID NOT MOVE. A drafted card is EARNED and droppable;
	# an enabler becoming draftable is the silent failure `PROTECTED_CORES`
	# exists to prevent, and this batch touches the Beastmaster — whose enablers
	# are all three summons — so it is exactly the batch to check it in.
	for spec in ["beastmaster", "sharpshooter", "mystic"]:
		for enabler in Classes.core_enablers(spec):
			ok(not Classes.spec_draft_pool(spec).has(enabler),
				"%s's enabler %s is not draftable" % [spec, enabler])
	ok(Classes.core_enablers("beastmaster").size() == 3,
		"the Beastmaster's three summons are still his protected core")
	ok(Classes.core_slots("beastmaster") == 3,
		"and they still occupy THREE slots, not five (the AH bar rule)")


func _definitions() -> void:
	for n in NINE:
		var spec: String = NINE[n][0]
		ok(Classes.spec_draft_pool(spec).has(n),
			"%s is in the %s draft pool" % [n, spec])
		var ab: Ability = Classes.draft_ability(n)
		ok(ab != null, "%s has a definition" % n)
		if ab == null:
			continue
		ok(ab.cost == NINE[n][1], "%s costs %d (got %d)" % [n, NINE[n][1], ab.cost])
		ok(is_equal_approx(ab.delay, NINE[n][2]),
			"%s arrives at %s (got %s)" % [n, NINE[n][2], ab.delay])
		ok(ab.cooldown == NINE[n][3],
			"%s cools %d (got %d)" % [n, NINE[n][3], ab.cooldown])
		# BREAK DAMAGE ASSIGNED DELIBERATELY, NOT BY OMISSION — the standing rule
		# since BO. The five that strike carry it in line with their siblings;
		# the four that land no blow carry none, because Break from an ability
		# that never hits is Break from nowhere.
		ok(ab.pressure == NINE[n][4],
			"%s carries %d Break (got %d)" % [n, NINE[n][4], ab.pressure])
		ok(ab.description != "", "%s has a description" % n)
		ok(ab.perfect_text != "", "%s states a perfect" % n)
		# And it RESOLVES through the one door every earned ability uses, or a
		# drafted card would land in `bm_abilities` and never spawn.
		ok(Classes.pool_ability(n) != null,
			"%s resolves through pool_ability" % n)
	# THE SPECIAL SPLIT, BOTH WAYS ROUND. `_resolve` sends ANY ability holding a
	# `special` down `_resolve_special`, which hand-rolls the blow and loses the
	# attack pipeline — crits, armor, resists, Break, the Focus engine. Crossfire
	# is DEFINED by a crit and Trophy Shot by the Focus engine, so a `special`
	# creeping onto either would break them silently.
	for n in SPECIALS:
		ok(Classes.draft_ability(n).special == SPECIALS[n],
			"%s resolves through the `%s` special" % [n, SPECIALS[n]])
		ok(Classes.draft_ability(n).damage == 0,
			"%s is a pure effect and carries no Attack percentage" % n)
	for n in NO_SPECIAL:
		ok(Classes.draft_ability(n).special == "",
			"%s carries NO special — it must ride the ordinary attack pipeline" % n)
		ok(Classes.draft_ability(n).damage > 0,
			"%s is an attack and carries an Attack percentage" % n)
	# NONE OF THE NINE IS AN AREA ATTACK, and that matters for two of them
	# specifically: the Focus engine is gated on `not _focus_safe(ab)`, so an
	# `aoe` flag on Calibrating Shot or Trophy Shot would silently stop the
	# meter reading them at all.
	for n in NINE:
		ok(not Classes.draft_ability(n).aoe, "%s is not an area attack" % n)
	# THE THREE SELF-CASTS SAY SO, which is what keeps them out of the ALLY
	# branch of the player's picker and the bot's pool.
	for n in ["Bloodbond", "Savage Sweep", "Ghostpack", "Preparation"]:
		ok(Classes.draft_ability(n).target != Ability.Target.ALLY,
			"%s is not an ally-facing card" % n)
	# THE TEXT CARRIES THE CLAUSES A PLAYER WOULD OTHERWISE GUESS WRONG.
	ok(Classes.draft_ability("Bloodbond").description.to_lower().contains("kill you"),
		"Bloodbond's own text says the half he takes can kill him")
	ok(Classes.draft_ability("Trophy Shot").description.to_lower().contains("not kill"),
		"Trophy Shot's text says outright what happens when it does NOT kill")
	ok(Classes.draft_ability("Hunt").description.to_lower().contains("stacks do not count"),
		"Hunt's text says stacks do not count twice")
	ok(Classes.draft_ability("Preparation").description.to_lower().contains("tick again"),
		"Preparation's text warns that his own statuses re-tick")
	ok(Classes.draft_ability("Preparation").description.to_lower().contains("only one"),
		"and that only one may be pending")
	ok(Classes.draft_ability("Calibrating Shot").description.to_lower().contains(
		"pays nothing"),
		"Calibrating Shot's text says a fresh enemy pays nothing")
	ok(Classes.draft_ability("Ghostpack").description.to_lower().contains(
		"no longer standing"),
		"Ghostpack's text says the lost ones strike too")


func _synergy_rule() -> void:
	# BT §1's STANDING RULE, MADE MECHANICAL AND CARRIED FORWARD: from tranche 2
	# on, every ability NAMES what it builds with. A card nobody plans around is
	# a card that fills a slot, and the cheapest way for that to creep back is
	# for the next author to skip the line.
	var src := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var at_block := src.find("BATCH BV: TRANCHE 2, THE HUNTER NINE")
	ok(at_block > 0, "the BV block is anchored in classes.gd")
	if at_block <= 0:
		return
	var block := src.substr(at_block)
	for n in NINE:
		var at := block.find('"%s":' % n)
		ok(at > 0, "%s sits inside the BV block" % n)
		if at <= 0:
			continue
		# The 3000 characters above the entry are its comment.
		var lead := block.substr(maxi(at - 3000, 0), mini(at, 3000))
		ok(lead.contains("SYNERGY:"), "%s names what it combos with" % n)
		ok(lead.contains("AXIS:"), "%s names its axis" % n)


func _names() -> void:
	# BR §1's SWEEP, RUN AS A TEST. An ABILITY-vs-ABILITY duplicate is a REAL
	# BREAK — `pool_ability` is keyed on `display_name`, so two abilities sharing
	# one make the resolver answer the wrong question.
	var seen: Dictionary = {}
	var pools: Array = []
	for spec in Classes.SPEC_DRAFT_POOLS:
		pools.append_array(Classes.spec_draft_pool(spec))
	for cls in Classes.CLASS_DRAFT_POOLS:
		pools.append_array(Classes.class_draft_pool(cls))
	for spec in Classes.SPEC_POOLS:
		pools.append_array(Classes.SPEC_POOLS[spec])
	for cls in Classes.CLASS_POOLS:
		pools.append_array(Classes.CLASS_POOLS[cls])
	for n in pools:
		seen[n] = int(seen.get(n, 0)) + 1
	for n in NINE:
		ok(int(seen.get(n, 0)) == 1,
			"%s appears in exactly ONE pool (got %d)" % [n, int(seen.get(n, 0))])
	# AND THE SWEEP THAT MATTERS: no OTHER ability in the game already carries
	# one of these names. Every opening kit is walked.
	for spec in Classes.SPEC_IDS:
		for cls_spec in Classes.SPEC_IDS[spec]:
			for ab in Classes.spec_abilities(cls_spec):
				ok(not (ab.display_name in NINE),
					"%s is not also an opening-kit ability" % ab.display_name)
	# HUNT vs TWIN HUNT vs MARK OF THE HUNT — REPORTED, NOT RESOLVED. "Hunt" is
	# a SUBSTRING of two existing ability names, one of them in the same CLASS
	# (Twin Hunt is the Beastmaster's tranche-1 card). NOTHING BREAKS, because
	# `pool_ability` is keyed on the WHOLE `display_name` and the strings differ
	# — which is precisely what these three checks pin.
	ok(Classes.pool_ability("Hunt") != null
		and Classes.pool_ability("Hunt").display_name == "Hunt",
		"Hunt resolves to ITSELF, not to Twin Hunt")
	ok(Classes.pool_ability("Twin Hunt") != null
		and Classes.pool_ability("Twin Hunt").special == "twin_hunt",
		"Twin Hunt still resolves to itself")
	ok(Classes.pool_ability("Mark of the Hunt") != null
		and Classes.pool_ability("Mark of the Hunt").display_name
			== "Mark of the Hunt",
		"Mark of the Hunt still resolves to itself")
	# GHOSTPACK vs GHOST PACK — THE CLOSEST COLLISION THE PROJECT HAS HAD, and
	# it SHIPS FLAGGED per BR §1 (a node's name is not an ability name; nothing
	# resolves it). `bm_ghost_pack` is a Beastmaster HANDLER ROW 8 node, i.e.
	# THE SAME SPEC — a Beastmaster can hold both — and the two are one space
	# apart AND mechanically adjacent. These checks pin what actually matters:
	# the node is still a node, the card is still a card, and neither resolver
	# can reach the other.
	var node_found := false
	for node in Talents.LANE_TREES.get("beastmaster", []):
		if String(node.get("id", "")) == "bm_ghost_pack":
			node_found = true
			ok(String(node.get("name", "")) == "Ghost Pack",
				"the NODE is still named 'Ghost Pack' (two words)")
	ok(node_found, "the bm_ghost_pack node is still in the Beastmaster tree")
	ok(Classes.pool_ability("Ghostpack") != null
		and Classes.pool_ability("Ghostpack").special == "ghostpack",
		"the CARD 'Ghostpack' (one word) resolves to itself")
	ok(Classes.pool_ability("Ghost Pack") == null,
		"and 'Ghost Pack' resolves to NO ability — the node is not draftable")
	# NO TALENT NODE ANYWHERE CARRIES ONE OF THE NINE NAMES EXACTLY. A node with
	# an ability's name is a label collision the project ships and flags; a node
	# with the SAME name would still not break `pool_ability`, but it is the
	# thing BR §1 asks to be swept for, so it is swept mechanically.
	for spec in Talents.LANE_TREES:
		for node in Talents.LANE_TREES[spec]:
			ok(not (String(node.get("name", "")) in NINE),
				"talent node '%s' (%s) does not carry one of the nine names"
					% [String(node.get("name", "")), spec])


func _status_registry() -> void:
	# THE THREE NEW STATUSES ARE ALL ON THE HUNTER'S OWN SIDE, so NONE of them
	# may be in DEBUFF_IDS. Listing one would be worse than an oversight: an
	# enemy Dispel would strip the hunter's own guard, and `_status_count` —
	# which Hunt and the Trapper passive both read — would start counting a
	# hero's buff as an affliction.
	for id in ["bloodbond", "ghostpack", "crossfire"]:
		ok(not BattleUnit.DEBUFF_IDS.has(id),
			"`%s` is a BUFF on the hunter and is not in DEBUFF_IDS" % id)
	# AND THEY ARE REGISTERED, or `_apply_status` and the chips have no label to
	# read and the effect lands invisibly.
	var battle_src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for id in ["bloodbond", "ghostpack", "crossfire"]:
		ok(battle_src.contains('"%s": [' % id),
			"`%s` has a STATUS_INFO row" % id)


func _unit_state() -> void:
	# ONE CALLBACK AND ONE COUNTER FOR NINE ABILITIES — BQ's standard held: an
	# effect with a DURATION is a status, which expires by itself and cannot
	# leak past a battle.
	#
	# THE FIELDS ARE READ OFF A DETACHED UNIT AND THE LEDGER IS NOT. `add_status`
	# ends in `_refresh_chips`, which walks a child node the bare constructor
	# never builds, so the ledger half is driven on a LIVE unit in
	# `_live_loaded_shot` where the chips exist. Splitting it that way is the
	# difference between a check and a crash.
	var u := BattleUnit.new()
	ok(u.get("prep_pending") != null, "the Preparation counter exists")
	ok(u.prep_pending == 0, "a fresh unit has no extra turn pending")
	ok(u.get("bloodbond_cb") != null, "the Bloodbond callback field exists")
	ok(not u.bloodbond_cb.is_valid(),
		"and it is unbound until a companion is built")
	ok(u.has_method("_note_full_turns"),
		"the full_turns ledger is written by one shared function")
	u.free()


func _source_rules() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# COMMENTS ARE STRIPPED FIRST (BS's rule): this batch's own comments name the
	# things it forbids on purpose, and a bare `contains` would fail against
	# working code and invite a later author to "fix" it by deleting the line
	# that explains the decision.
	var code := _strip_comments(src)
	# GHOSTPACK RIDES `_ghost_hit`, WHICH IS WHAT CREDITS THE HUNTER (BB §4).
	# The slice is anchored at the status read and its LENGTH asserted beside
	# it — BT's lesson: a slice anchored on a bare name can quietly cover the
	# wrong region and sweep a check across half the file.
	var at_gp := code.find('has_status("ghostpack")')
	ok(at_gp > 0, "the Ghostpack strike hook exists")
	var gp_body := code.substr(at_gp, 500)
	ok(gp_body.length() > 300, "and the slice around it is a real region")
	ok(gp_body.contains("_ghost_hit("),
		"Ghostpack strikes through `_ghost_hit`, the credited door")
	ok(gp_body.contains("kinds_summoned"),
		"and it reads the EXISTING summoned-this-battle ledger")
	ok(not gp_body.contains("_companion_strike("),
		"it does NOT re-use the living-beast striker, which would need a body")
	# CROSSFIRE'S SPLASH IS INSIDE THE `is_crit` BLOCK. The discriminating
	# structural fact: the hook sits between the crit-rider block's opening and
	# the Overkill block that closes it.
	var at_crit := code.find("if is_crit and attacker.is_hero and not is_counter:")
	var at_cf := code.find('has_status("crossfire")')
	var at_ok := code.find("if result.died and attacker.overkill > 0")
	ok(at_crit > 0 and at_cf > at_crit and at_ok > at_cf,
		"Crossfire's splash sits INSIDE the on-crit rider block")
	ok(at_cf - at_crit < 1200,
		"and close enough to it to be the same block, not a later one")
	# HUNT SHARES THE TRAPPER'S OWN COUNT, which is what makes distinct-not-
	# stacks a property of one implementation rather than a second rule.
	# ANCHORED ON THE UNIQUE LINE, NOT ON THE BARE NAME (BT's finding): `if
	# ab.display_name == "Hunt":` appears THREE times — here, in the bot's
	# targeting refinement and in the usability gate — and the first match is
	# the bot's. A slice taken there would sweep the wrong region and pass or
	# fail for reasons that have nothing to do with the damage block.
	var at_hunt := code.find("var hunt_n := _status_count(strike_target)")
	ok(at_hunt > 0, "the Hunt scaling exists in the raw-damage block")
	var hunt_body := code.substr(maxi(at_hunt - 60, 0), 400)
	ok(hunt_body.contains("_status_count(strike_target)"),
		"Hunt reads `_status_count`, the Trapper passive's own function")
	ok(not hunt_body.contains("status_stacks"),
		"and never a stack count")
	# LOADED SHOT DOES NOT USE THE PURGE FILTER. `_harvest_yield` skips STICKY
	# statuses because a cleanse cannot take them; a refresh is the opposite
	# question, so borrowing that walk would silently exclude every Slow Acting
	# and Perfected Toxin poison — the exact ones the card names.
	var at_ls := code.find("func _loaded_shot_refresh")
	ok(at_ls > 0, "the Loaded Shot refresh is its own function")
	var ls_body := code.substr(at_ls, 900)
	ok(not ls_body.contains("sticky"),
		"the refresh does NOT skip sticky statuses — it names them on purpose")
	ok(ls_body.contains("full_turns"), "it reads the full_turns ledger")
	ok(ls_body.contains("DEBUFF_IDS"),
		"and only harmful effects, off the curated allowlist")
	# LOADED SHOT'S REFRESH AND CROSSFIRE'S WINDOW BELONG TO THE ABILITY, NOT TO
	# THE CASTER'S PASSIVE. Both first landed inside a passive-gated block —
	# `passive_id == "trapper"` and `passive_id == "lethal_aim"` — where they
	# worked perfectly for the one spec that can draft them and did NOTHING,
	# silently and without a log line, for anyone else. Nothing was reachable in
	# play (both cards are spec-locked), but it is the BT indentation fault in a
	# different hat, and a later batch widening either card would have inherited
	# a dead clause. These two checks pin the decoupling.
	var at_ls_hook := code.find('if ab.display_name == "Loaded Shot" and attacker.is_hero')
	ok(at_ls_hook > 0,
		"Loaded Shot's refresh is gated on the ABILITY, not on the Trapper passive")
	var at_trapper := code.find('if attacker.is_hero and attacker.passive_id == "trapper"')
	var at_qm := code.find("_living_hero_with(\"quartermaster\")")
	ok(at_trapper > 0 and at_qm > 0 and at_ls_hook > at_trapper,
		"and it sits AFTER the Survivalist package, so the turn's own work is refreshed too")
	var at_cf_arm := code.find('if ab.display_name == "Crossfire" and attacker.is_hero')
	ok(at_cf_arm > 0,
		"Crossfire's window is gated on the ABILITY, not on the Lethal Aim passive")
	var at_lethal := code.find('attacker.passive_id == "lethal_aim"')
	ok(at_lethal > 0 and at_cf_arm > at_lethal,
		"and it is outside that block rather than merely before it")
	# CALIBRATING SHOT'S GAIN *IS* PASSIVE-GATED AND MUST BE — Focus is the
	# Sharpshooter's meter and nobody else has one to pay into. The distinction
	# is the point: an effect that reads a SPEC METER belongs with the passive, an
	# effect that reads the ABILITY does not.
	var at_calib := code.find('if ab.display_name == "Calibrating Shot":')
	ok(at_calib > at_lethal,
		"Calibrating Shot's Focus gain stays inside the Lethal Aim block, where it belongs")
	# PREPARATION: THE HOOK IS AT THE END OF THE HERO'S TURN, and the refusal is
	# in the usability gate. Both are structural and both are load-bearing.
	var at_pt := code.find("func _player_turn")
	ok(at_pt > 0, "the hero turn function is anchored")
	var pt_body := code.substr(at_pt, code.find("func _autoplay_pick") - at_pt)
	ok(pt_body.contains("_preparation_tick(u)"),
		"the extra turn is granted at the END of the hero's turn")
	var at_gate := code.find('if ab.special == "preparation" and u.prep_pending > 0:')
	ok(at_gate > 0,
		"PREPARATION IS REFUSED WHILE ONE IS PENDING — the no-chain rule, in code")
	# AND THE ONE PLACE THE COUNTER DECREMENTS. Two decrement sites would make
	# the delay depend on which fired first.
	ok(code.count("prep_pending -= 1") == 1,
		"`prep_pending` decrements in exactly ONE place (got %d)"
			% code.count("prep_pending -= 1"))
	ok(code.count("prep_pending = 2") == 1,
		"and is armed in exactly ONE place")
	# BLOODBOND'S REFUSAL IS ABOVE THE SUBTRACTION, with Event Horizon and
	# Kiln-Forged, so nothing downstream ever sees a lethal number.
	var unit_code := _strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var at_th := unit_code.find("func take_hit")
	var at_bb := unit_code.find("bloodbond_cb.is_valid()")
	var at_sub := unit_code.find("hp = maxi(hp - amount, 0)")
	ok(at_th > 0 and at_bb > at_th and at_sub > at_bb,
		"the Bloodbond guard sits inside take_hit and ABOVE the subtraction")
	var at_barrier := unit_code.find('if s.id == "barrier" and s.power > 0:')
	ok(at_barrier > 0 and at_bb > at_barrier,
		"and BELOW the barrier, so it relocates what got THROUGH (the Vow rule)")


func _strip_comments(src: String) -> String:
	var out: Array = []
	for line in src.split("\n"):
		var t := String(line).strip_edges()
		if t.begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


func _docs() -> void:
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master.contains("Batch CE"), "master.html is stamped Batch CE")
	for n in NINE:
		ok(master.contains(n), "master.html lists %s" % n)
	ok(master.contains("102 of"), "master.html states the new draft count")
	ok(master.contains("Builds with"),
		"and the draft tables still carry the synergy line a player reads")
	var chlog := FileAccess.get_file_as_string("res://docs/changelog.html")
	ok(chlog.contains("Batch BV"), "the changelog carries a BV entry")
	# THE GLOSSARY OWES THE EXTRA TURN AN ENTRY: a player meets Preparation
	# before anything else in the game explains what an extra turn re-ticks.
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(gloss.to_lower().contains("extra turn"),
		"the glossary explains the extra turn")


# ---------- live harness ----------

func _spawn(hunter_spec: String, lineup: Array, learned := {}) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "arcanist", "holy", hunter_spec]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 3 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	# `_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL SceneTreeTimer.
	# `Engine.time_scale` scales those timers and NOTHING the battle computes.
	Engine.time_scale = 50.0
	for _i in 90:
		await process_frame
	Engine.time_scale = 1.0
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline).
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0
	return scene


func _hunter(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _live_foes(scene: Node) -> Array:
	return scene.get("enemies").filter(func(e): return not e.dead)


func _seeded() -> void:
	seed(20260814)


func _card(n: String) -> Ability:
	return Classes.draft_ability(n)


# ---------- §2 live: the Beastmaster three ----------

func _live_bloodbond() -> void:
	# §6's FIRST CLAUSE, IN FOUR PARTS. The construction that discriminates is
	# the AGEING: a 3-turn version passes every damage assertion below if the
	# blow arrives on the turn it was cast, so the guard is ticked well past any
	# plausible duration first.
	var scene := await _spawn("beastmaster", ["raider", "raider"])
	var bm := _hunter(scene, "pack")
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		scene.queue_free()
		return
	await scene.call("_do_summon", bm, "ursus")
	var beasts: Array = scene.call("_beasts", bm)
	ok(beasts.size() == 1, "a companion stands")
	if beasts.is_empty():
		scene.queue_free()
		return
	var beast: BattleUnit = beasts[0]
	await scene.call("_resolve", bm, _card("Bloodbond"), bm, "good")
	ok(bm.has_status("bloodbond"), "the bond is sworn")
	ok(bm.get_status("bloodbond").turns < 0,
		"and it is BATTLE-LONG — a placed guard, not a window (turns %s)"
			% bm.get_status("bloodbond").turns)
	ok(bm.status_power("bloodbond") == 50, "it will take HALF (got %d)"
		% bm.status_power("bloodbond"))
	# AGE IT. Ten ticks is past any duration this could plausibly have been
	# given, and the guard must be untouched.
	for _i in 10:
		bm.tick_statuses()
	ok(bm.has_status("bloodbond"),
		"the guard SURVIVES ten turns of ticking — it waits until it FIRES")
	# THE FIRING. A blow far larger than the beast's remaining health — and the
	# hunter is given room to SURVIVE it, because this half of the check is
	# about the arithmetic. Whether the share can kill him is asserted on its
	# own below, where it is the only thing being measured.
	bm.max_hp = 9999
	bm.hp = 9999
	beast.hp = 20
	var blow := 500
	var hunter_hp_was: int = bm.hp
	beast.take_hit(blow, 0)
	ok(not beast.dead, "the companion is not felled")
	ok(beast.hp == 1, "it is left on EXACTLY 1 (got %d)" % beast.hp)
	ok(bm.hp == hunter_hp_was - blow / 2,
		"and the hunter took EXACTLY half the blow — %d, got %d"
			% [blow / 2, hunter_hp_was - bm.hp])
	ok(not bm.has_status("bloodbond"), "the guard is SPENT once it fires")
	# THE SECOND BLOW HAS NO GUARD LEFT. This is the negative control that
	# matters: a version refusing every killing blow passes everything above.
	beast.hp = 20
	beast.take_hit(500, 0)
	ok(beast.dead, "with the guard spent, the next killing blow FELLS the beast")
	scene.queue_free()
	await process_frame

	# IT CAN KILL HIM. The description says so, and a guard that cannot cost
	# anything is not a decision — so this is asserted rather than assumed.
	var scene2 := await _spawn("beastmaster", ["raider"])
	var bm2 := _hunter(scene2, "pack")
	if bm2 == null:
		scene2.queue_free()
		return
	await scene2.call("_do_summon", bm2, "canis")
	var b2: Array = scene2.call("_beasts", bm2)
	if b2.is_empty():
		scene2.queue_free()
		return
	await scene2.call("_resolve", bm2, _card("Bloodbond"), bm2, "good")
	bm2.hp = 10
	b2[0].hp = 5
	b2[0].take_hit(400, 0)
	ok(not b2[0].dead, "the companion is still saved")
	ok(bm2.dead, "and the hunter DIES paying for it — the guard has a real cost")
	scene2.queue_free()
	await process_frame

	# THE PERFECT HALVES HIS SHARE AGAIN, and the number rides the STATUS so the
	# chip and the bill cannot disagree (Batch BP's Eye of the Storm lesson).
	var scene3 := await _spawn("beastmaster", ["raider"])
	var bm3 := _hunter(scene3, "pack")
	if bm3 == null:
		scene3.queue_free()
		return
	await scene3.call("_do_summon", bm3, "ursus")
	var b3: Array = scene3.call("_beasts", bm3)
	if b3.is_empty():
		scene3.queue_free()
		return
	await scene3.call("_resolve", bm3, _card("Bloodbond"), bm3, "perfect")
	bm3.max_hp = 9999
	bm3.hp = 9999
	ok(bm3.status_power("bloodbond") == 25,
		"a perfect bond takes a QUARTER (got %d)" % bm3.status_power("bloodbond"))
	var hp3: int = bm3.hp
	b3[0].hp = 10
	b3[0].take_hit(400, 0)
	ok(hp3 - bm3.hp == 100,
		"and bills exactly a quarter of the blow (100, got %d)" % (hp3 - bm3.hp))
	scene3.queue_free()
	await process_frame


func _live_savage_sweep() -> void:
	# §6's SECOND CLAUSE. "Three enemies were hit" is trivially true of a random
	# spread, so five enemies are seated at five SEPARATED health fractions and
	# the three victims are asserted BY IDENTITY.
	var scene := await _spawn("beastmaster",
		["raider", "raider", "raider", "raider", "raider"])
	var bm := _hunter(scene, "pack")
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		scene.queue_free()
		return
	# THE WOLF, NOT THE BEAR, AND THAT IS THE HARNESS RATHER THAN THE CARD.
	# URSUS'S OWN BLOW MAULS THE ENEMIES BESIDE ITS TARGET (`_adjacent_enemies`,
	# its kit since Batch 30), so a bear sweep legitimately touches more than
	# three bodies and no identity assertion could survive it. Canis is
	# single-target, so what this check sees is Savage Sweep's CHOICE and
	# nothing else. (Worth knowing in play: a bear Savage Sweep is very wide.)
	await scene.call("_do_summon", bm, "canis")
	if (scene.call("_beasts", bm) as Array).is_empty():
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	ok(foes.size() == 5, "five enemies stand (got %d)" % foes.size())
	if foes.size() < 5:
		scene.queue_free()
		return
	# `_lowest_hp` reads the FRACTION, so the fractions are what is separated.
	var fracs := [0.9, 0.2, 0.7, 0.1, 0.3]
	for i in 5:
		foes[i].hp = maxi(int(foes[i].max_hp * fracs[i]), 1)
	# The three lowest fractions are indices 3 (0.1), 1 (0.2), 4 (0.3).
	var expected := [foes[3], foes[1], foes[4]]
	var spared := [foes[0], foes[2]]
	var before := {}
	for f in foes:
		before[f] = f.hp
	_seeded()
	await scene.call("_resolve", bm, _card("Savage Sweep"), bm, "good")
	for f in expected:
		ok(f.hp < int(before[f]) or f.dead,
			"%s was among the three lowest and was struck" % f.unit_name)
	for f in spared:
		ok(f.hp == int(before[f]) and not f.dead,
			"%s was one of the two healthiest and was NOT struck (%d -> %d)"
				% [f.unit_name, int(before[f]), f.hp])
	scene.queue_free()
	await process_frame

	# UNDER THE PACK IT IS STILL THREE STRIKES, AND THE LOYALTY LANDS ON THE
	# DEEPER BOND. This is the decision §1 asked to be made rather than left to
	# `beasts[0]`: an ORDERED action goes to ONE companion. A version that
	# looped every beast would hit six times and pay two meters.
	var scene2 := await _spawn("beastmaster",
		["raider", "raider", "raider", "raider", "raider"])
	var bm2 := _hunter(scene2, "pack")
	if bm2 == null:
		scene2.queue_free()
		return
	bm2.the_pack = 1
	await scene2.call("_do_summon", bm2, "ursus")
	await scene2.call("_do_summon", bm2, "canis")
	var pack: Array = scene2.call("_beasts", bm2)
	ok(pack.size() == 2, "The Pack fields TWO beasts (got %d)" % pack.size())
	if pack.size() < 2:
		scene2.queue_free()
		return
	# Seat the CANIS bond deeper, then assert the sweep chose it.
	bm2.loyalty["ursus"] = 2
	bm2.loyalty["canis"] = 9
	var foes2 := _live_foes(scene2)
	for i in foes2.size():
		foes2[i].hp = maxi(int(foes2[i].max_hp * (0.2 + 0.15 * i)), 1)
	var before2 := {}
	for f in foes2:
		before2[f] = f.hp
	_seeded()
	await scene2.call("_resolve", bm2, _card("Savage Sweep"), bm2, "good")
	var struck := 0
	for f in foes2:
		if f.dead or f.hp < int(before2[f]):
			struck += 1
	ok(struck == 3,
		"under The Pack it is STILL three strikes, not six (got %d)" % struck)
	ok(int(bm2.loyalty.get("canis", 0)) == 12,
		"the 3 Loyalty went to the DEEPER bond, canis 9 -> 12 (got %d)"
			% int(bm2.loyalty.get("canis", 0)))
	ok(int(bm2.loyalty.get("ursus", 0)) == 2,
		"and the shallower bond gained nothing (got %d)"
			% int(bm2.loyalty.get("ursus", 0)))
	scene2.queue_free()
	await process_frame


func _live_ghostpack() -> void:
	# §6's THIRD CLAUSE. The discriminating construction is a summoned beast
	# that is then KILLED: `beasts` is empty, the field shows nothing, and the
	# strike must STILL land. A version reading the living pack does nothing
	# here and passes any check taken while a beast was out.
	var scene := await _spawn("beastmaster", ["raider", "raider"])
	var bm := _hunter(scene, "pack")
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		scene.queue_free()
		return
	await scene.call("_do_summon", bm, "ursus")
	var beasts: Array = scene.call("_beasts", bm)
	if beasts.is_empty():
		scene.queue_free()
		return
	# Kill it. `kinds_summoned` is the LEDGER and must survive the body.
	beasts[0].hp = 1
	beasts[0].take_hit(999, 0)
	await process_frame
	ok((scene.call("_beasts", bm) as Array).is_empty(),
		"no companion stands any more")
	ok(bm.kinds_summoned.has("ursus"),
		"but the summoned-this-battle ledger remembers it")
	# THE NODE MUST BE OFF, or Ghost Pack's own beastless strike would be
	# indistinguishable from the card's.
	ok(bm.ghost_pack == 0,
		"the Ghost Pack NODE is not learned, so any strike below is the CARD's")
	await scene.call("_resolve", bm, _card("Ghostpack"), bm, "good")
	ok(bm.has_status("ghostpack"), "the window is open")
	ok(bm.get_status("ghostpack").turns == 3, "for 3 turns (got %s)"
		% bm.get_status("ghostpack").turns)
	var foe: BattleUnit = _live_foes(scene)[0]
	var hp_was: int = foe.hp
	# `_stat` IS GATED ON `sim`, so the contribution ledger is dark in a live
	# battle and a credit check taken here would read 0 -> 0 and pass for the
	# wrong reason. It is flipped on for this measurement alone and flipped back
	# immediately — the flag suppresses animation waits and nothing the strike
	# computes.
	scene.set("sim", true)
	var credit_was: int = int(scene.get("sim_stats").get(
		"dmg_hero_" + bm.unit_name, 0))
	_seeded()
	await scene.call("_resolve", bm, bm.abilities[0], foe, "good")
	ok(foe.hp < hp_was, "the attack landed")
	var credit_now: int = int(scene.get("sim_stats").get(
		"dmg_hero_" + bm.unit_name, 0))
	ok(credit_now > credit_was,
		"and the hunter is CREDITED for it (BB §4's repair, %d -> %d)"
			% [credit_was, credit_now])
	scene.set("sim", false)
	# THE DISCRIMINATOR: turn the window off and repeat. The same attack against
	# the same board must now take strictly LESS off the body, because the ghost
	# is gone. Compared as a RATIO with open ground rather than a bare `<`, per
	# BS's finding that a one-blow-against-one-blow check cannot see a small term.
	var with_ghost := hp_was - foe.hp
	bm.remove_status("ghostpack")
	foe.hp = hp_was
	_seeded()
	await scene.call("_resolve", bm, bm.abilities[0], foe, "good")
	var without := hp_was - foe.hp
	ok(with_ghost > without,
		"the remembered companion really struck (%d with, %d without)"
			% [with_ghost, without])
	ok(float(with_ghost) > float(without) * 1.15,
		"and by a margin the ±10%% variance roll cannot manufacture (%d vs %d)"
			% [with_ghost, without])
	scene.queue_free()
	await process_frame


# ---------- §3 live: the Sharpshooter three ----------

func _live_crossfire() -> void:
	# §6's FOURTH CLAUSE. "Other enemies took damage" is trivially true of an
	# unconditional version, so the SAME cast is driven with the crit roll dead
	# and then forced, and the no-crit case must land NOTHING elsewhere.
	var scene := await _spawn("sharpshooter",
		["raider", "raider", "raider", "raider", "raider"])
	var ss := _hunter(scene, "lethal_aim")
	ok(ss != null, "the Sharpshooter spawned")
	if ss == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	if foes.size() < 5:
		scene.queue_free()
		return
	var mark: BattleUnit = foes[0]
	await scene.call("_resolve", ss, _card("Crossfire"), mark, "good")
	ok(ss.has_status("crossfire"), "the crossfire is laid")
	ok(ss.get_status("crossfire").turns == 3, "for 3 turns (got %s)"
		% ss.get_status("crossfire").turns)
	# NO CRIT: `crit_bonus = -1.0` from _spawn kills the roll outright.
	var before := {}
	for f in foes:
		before[f] = f.hp
	_seeded()
	await scene.call("_resolve", ss, ss.abilities[0], mark, "good")
	var splashed := 0
	for f in foes:
		if f != mark and (f.hp < int(before[f]) or f.dead):
			splashed += 1
	ok(splashed == 0,
		"WITHOUT a crit the window splashes NOTHING (got %d bodies)" % splashed)
	# FORCE THE CRIT. +2.0 outruns any negative term in the roll.
	ss.crit_bonus = 2.0
	for f in foes:
		f.hp = f.max_hp
		before[f] = f.hp
	_seeded()
	await scene.call("_resolve", ss, ss.abilities[0], mark, "good")
	var hit: Array = []
	for f in foes:
		if f != mark and (f.hp < int(before[f]) or f.dead):
			hit.append(f)
	ok(hit.size() == 2,
		"WITH a crit it strikes EXACTLY 2 other enemies on a five-enemy field"
			+ " (got %d)" % hit.size())
	# AND AT 40% OF THAT CRIT'S OWN DAMAGE. Asserted as a band rather than an
	# identity: armor and the ±10% roll both stand between the two numbers, so
	# the check is that the splash is a real share and nowhere near the whole.
	if hit.is_empty():
		ok(false, "the crit produced no splash at all — nothing further to measure")
		ss.crit_bonus = -1.0
		scene.queue_free()
		await process_frame
		return
	var mark_took: int = int(before[mark]) - mark.hp
	var splash_took: int = int(before[hit[0]]) - hit[0].hp
	ok(mark_took > 0 and splash_took > 0, "both the mark and the splash landed")
	ok(splash_took < mark_took,
		"the splash is a SHARE of the crit (%d of %d)" % [splash_took, mark_took])
	ok(float(splash_took) < float(mark_took) * 0.75,
		"and a share near %d%% rather than the whole blow"
			% int(CROSSFIRE_SHARE_TEST * 100))
	ss.crit_bonus = -1.0
	# THE WINDOW EXPIRES. A battle-long splash would be a different card.
	for _i in 4:
		ss.tick_statuses()
	ok(not ss.has_status("crossfire"), "and the window runs out after its turns")
	scene.queue_free()
	await process_frame


func _live_calibrating_shot() -> void:
	# §6's FIFTH CLAUSE, and the subtle one. The shot itself wounds the target,
	# so a version reading the board AFTER the strike pays a few Focus against a
	# "fresh" enemy and looks right. The check therefore drives a FULL-health
	# target and a WOUNDED one and asserts the full-health cast paid EXACTLY the
	# ordinary engine's gain and not one point more.
	var scene := await _spawn("sharpshooter", ["raider", "raider"])
	var ss := _hunter(scene, "lethal_aim")
	ok(ss != null, "the Sharpshooter spawned")
	if ss == null:
		scene.queue_free()
		return
	ok(ss.second_resource_name == "Focus", "his meter is Focus")
	var foes := _live_foes(scene)
	var fresh: BattleUnit = foes[0]
	var hurt: BattleUnit = foes[1]
	# A CONTROL CAST FIRST: the ordinary engine's gain against a fresh enemy,
	# measured with a plain attack, so the card's own contribution is isolated.
	fresh.hp = fresh.max_hp
	ss.second_resource = 0
	ss.last_attack_target = fresh
	ss.same_target_turns = 1
	_seeded()
	await scene.call("_resolve", ss, ss.abilities[0], fresh, "good")
	var plain_gain: int = ss.second_resource
	ok(plain_gain > 0, "the ordinary Focus engine pays on a repeat mark (%d)"
		% plain_gain)
	# THE CARD, AGAINST A FULL-HEALTH TARGET. It must pay the SAME.
	fresh.hp = fresh.max_hp
	ss.second_resource = 0
	ss.last_attack_target = fresh
	ss.same_target_turns = 1
	_seeded()
	await scene.call("_resolve", ss, _card("Calibrating Shot"), fresh, "good")
	ok(ss.second_resource == plain_gain,
		"a FRESH enemy pays NOTHING extra — %d, same as the plain shot's %d"
			% [ss.second_resource, plain_gain])
	# AND AGAINST A WOUNDED ONE it pays 10% of what is missing, exactly.
	hurt.hp = maxi(int(hurt.max_hp * 0.20), 1)
	var missing: int = hurt.max_hp - hurt.hp
	ss.second_resource = 0
	ss.last_attack_target = hurt
	ss.same_target_turns = 1
	_seeded()
	await scene.call("_resolve", ss, _card("Calibrating Shot"), hurt, "good")
	var expect: int = plain_gain + int(round(missing * 0.10))
	ok(ss.second_resource == expect,
		"a target missing %d pays %d Focus (plain %d + 10%% of missing), got %d"
			% [missing, expect, plain_gain, ss.second_resource])
	# THE PERFECT MOVES THE RATE.
	hurt.hp = maxi(int(hurt.max_hp * 0.20), 1)
	missing = hurt.max_hp - hurt.hp
	ss.second_resource = 0
	ss.last_attack_target = hurt
	ss.same_target_turns = 1
	_seeded()
	await scene.call("_resolve", ss, _card("Calibrating Shot"), hurt, "perfect")
	ok(ss.second_resource > expect,
		"a perfect pays 15%% rather than 10%% (got %d against %d)"
			% [ss.second_resource, expect])
	scene.queue_free()
	await process_frame


func _live_trophy_shot() -> void:
	# §6's SIXTH CLAUSE, driven THREE ways from the same 200 Focus. "He kept his
	# Focus" is trivially true of a version that never clamps, so the control is
	# a DIFFERENT ability making the same kill.
	var scene := await _spawn("sharpshooter", ["raider", "raider", "raider"])
	var ss := _hunter(scene, "lethal_aim")
	ok(ss != null, "the Sharpshooter spawned")
	if ss == null:
		scene.queue_free()
		return
	# OVERKILL MUST BE OFF, or its own carry keeps the meter whole and hides
	# everything this check is looking at.
	ss.overkill = 0
	var foes := _live_foes(scene)
	# (a) A DIFFERENT ability kills: the meter clamps to 50.
	foes[0].hp = 1
	ss.second_resource = 200
	ss.last_attack_target = foes[0]
	await scene.call("_resolve", ss, ss.abilities[0], foes[0], "good")
	ok(foes[0].dead, "the control kill landed")
	ok(ss.second_resource == FOCUS_KILL_RETAIN_TEST,
		"an ordinary kill clamps him to %d (got %d)"
			% [FOCUS_KILL_RETAIN_TEST, ss.second_resource])
	# (b) TROPHY SHOT kills: the meter is not reduced AT ALL.
	foes[1].hp = 1
	ss.second_resource = 200
	ss.last_attack_target = foes[1]
	await scene.call("_resolve", ss, _card("Trophy Shot"), foes[1], "good")
	ok(foes[1].dead, "Trophy Shot landed the kill")
	ok(ss.second_resource == 200,
		"and his Focus is NOT reduced at all (got %d)" % ss.second_resource)
	# AND IT CARRIES WHOLE TO THE NEXT ENEMY. `last_attack_target` is null after
	# a kill, so the switch must not clear him either.
	ok(ss.last_attack_target == null, "the mark is gone")
	await scene.call("_resolve", ss, ss.abilities[0], foes[2], "good")
	ok(ss.second_resource >= 200,
		"the 200 carries whole into the next enemy (got %d)" % ss.second_resource)
	# (c) A TROPHY SHOT THAT DOES NOT KILL IS AN ORDINARY SHOT. The clause is
	# kill-only, and this is what tells it from an unconditional keeper: he
	# attacks a DIFFERENT living enemy afterwards and the ordinary switch rule
	# must empty him.
	foes[2].hp = foes[2].max_hp
	ss.second_resource = 200
	ss.last_attack_target = foes[2]
	await scene.call("_resolve", ss, _card("Trophy Shot"), foes[2], "good")
	ok(not foes[2].dead, "the Trophy Shot did NOT kill this time")
	ok(ss.second_resource > 0, "so nothing was reset by the shot itself")
	var other := _live_foes(scene).filter(func(e): return e != foes[2])
	if not other.is_empty():
		await scene.call("_resolve", ss, ss.abilities[0], other[0], "good")
		ok(ss.second_resource == 0,
			"and switching away still CLEARS him — the ordinary rules apply"
				+ " (got %d)" % ss.second_resource)
	scene.queue_free()
	await process_frame


# ---------- §4 live: the Survivalist three ----------

func _live_loaded_shot() -> void:
	# §6's SEVENTH CLAUSE, in three parts, each a different way the refresh could
	# be quietly wrong.
	var scene := await _spawn("mystic", ["raider", "raider"])
	var sv := _hunter(scene, "trapper")
	ok(sv != null, "the Survivalist spawned")
	if sv == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	# THE `full_turns` LEDGER FIRST, on a live unit — it is what "full" MEANS,
	# and every assertion below is worthless if the ledger itself is wrong.
	foe.statuses.clear()
	foe.add_status("poison", "Poison", "P", Color.GREEN, 5)
	ok(int(foe.get_status("poison").get("full_turns", -99)) == 5,
		"a fresh status records its full duration (got %s)"
			% foe.get_status("poison").get("full_turns"))
	foe.add_status("poison", "Poison", "P", Color.GREEN, 3)
	ok(int(foe.get_status("poison").get("full_turns", 0)) == 5,
		"a SHORTER re-application does not lower the ledger")
	foe.add_status("poison", "Poison", "P", Color.GREEN, 7)
	ok(int(foe.get_status("poison").get("full_turns", 0)) == 7,
		"a LONGER one raises it")
	# PERMANENCE PINS AT -1 AND NEVER CLIMBS OUT. This is the one that would
	# silently un-permanent Permafrost and Perfected Toxin.
	foe.add_status("chilled", "Chilled", "C", Color.CYAN, -1)
	ok(int(foe.get_status("chilled").get("full_turns", 0)) == -1,
		"a permanent status pins its ledger at -1")
	foe.add_status("chilled", "Chilled", "C", Color.CYAN, 3)
	ok(int(foe.get_status("chilled").get("full_turns", 0)) == -1,
		"and a later timed application CANNOT raise it out of permanence")
	foe.statuses.clear()
	# (a) AN ORDINARY AFFLICTION, AGED DOWN AND PUT BACK. "The duration went up"
	# is trivially true, so the assertion is the EXACT original.
	scene.call("_apply_status", foe, "cripple", 5)
	var full: int = int(foe.get_status("cripple").turns)
	ok(full > 0, "the affliction landed with a duration (%d)" % full)
	foe.get_status("cripple").turns = 1
	# (b) A PERMANENT ONE. This is the check that would catch a refresh writing
	# a real number onto Permafrost or a Perfected Toxin and un-permanenting it.
	foe.add_status("frostbite", "Frostbite", "Fb", Color.CYAN, -1)
	ok(int(foe.get_status("frostbite").turns) == -1, "and a permanent one stands")
	# (c) A BURN STANDING LONGER THAN IT STARTED. Re-applied Burn ADDS turns, so
	# its running timer legitimately exceeds its original — a refresh must never
	# shorten it.
	scene.call("_apply_status", foe, "burn", 3)
	scene.call("_apply_status", foe, "burn", 3)
	var burn_long: int = int(foe.get_status("burn").turns)
	ok(burn_long > 3, "the re-applied Burn stands longer than its original (%d)"
		% burn_long)
	await scene.call("_resolve", sv, _card("Loaded Shot"), foe, "good")
	ok(int(foe.get_status("cripple").turns) == full,
		"the aged affliction is back at its FULL %d (got %s)"
			% [full, foe.get_status("cripple").turns])
	ok(int(foe.get_status("frostbite").turns) == -1,
		"the PERMANENT one is still permanent, not converted to a number (got %s)"
			% foe.get_status("frostbite").turns)
	ok(int(foe.get_status("burn").turns) == burn_long,
		"and the long Burn was NOT shortened (%d, got %s)"
			% [burn_long, foe.get_status("burn").turns])
	# IT IS A REAL ATTACK TOO — the card is 20% of Attack plus the refresh, and
	# a version that forgot the damage half would pass every check above.
	var hp_was: int = foe.hp
	await scene.call("_resolve", sv, _card("Loaded Shot"), foe, "good")
	ok(foe.hp < hp_was, "and Loaded Shot deals its damage as well")
	scene.queue_free()
	await process_frame


func _live_hunt() -> void:
	# §6's NINTH CLAUSE — DISTINCT, NEVER STACKS. "It scaled" is trivially true,
	# so five stacks of one Poison plus one other affliction is driven against
	# two DIFFERENT afflictions and the two blows asserted EQUAL. A stack-
	# counting version reads 6 against 2 and cannot pass an equality.
	var scene := await _spawn("mystic", ["raider", "raider"])
	var sv := _hunter(scene, "trapper")
	ok(sv != null, "the Survivalist spawned")
	if sv == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var stacked: BattleUnit = foes[0]
	var spread: BattleUnit = foes[1]
	# THE TRAPPER'S OWN BREADTH TERM READS THE SAME COUNT, so both bodies must
	# carry the same NUMBER of distinct afflictions or that term alone would
	# separate the two blows and this check would be measuring it instead.
	for _i in 5:
		scene.call("_apply_status", stacked, "poison", 6)
	scene.call("_apply_status", stacked, "cripple", 6)
	scene.call("_apply_status", spread, "poison", 6)
	scene.call("_apply_status", spread, "slow", 6)
	ok(stacked.status_stacks("poison") >= 5,
		"one body carries five POISON STACKS (got %d)"
			% stacked.status_stacks("poison"))
	ok(int(scene.call("_status_count", stacked)) == 2,
		"but only TWO distinct afflictions (got %d)"
			% int(scene.call("_status_count", stacked)))
	ok(int(scene.call("_status_count", spread)) == 2,
		"and the control body carries two as well (got %d)"
			% int(scene.call("_status_count", spread)))
	stacked.max_hp = 99999
	spread.max_hp = 99999
	stacked.hp = 99999
	spread.hp = 99999
	stacked.armor = 0.0
	spread.armor = 0.0
	_seeded()
	await scene.call("_resolve", sv, _card("Hunt"), stacked, "good")
	var on_stacked: int = 99999 - stacked.hp
	_seeded()
	await scene.call("_resolve", sv, _card("Hunt"), spread, "good")
	var on_spread: int = 99999 - spread.hp
	ok(on_stacked > 0 and on_spread > 0, "both blows landed")
	ok(on_stacked == on_spread,
		"five stacks read the SAME as one stack — distinct effects, never stacks"
			+ " (%d vs %d)" % [on_stacked, on_spread])
	# AND IT REALLY DOES SCALE. Widen one body and the blow must grow — with
	# open ground between signal and noise, per BS's finding that a bare `<`
	# cannot see a small term through the ±10% roll.
	scene.call("_apply_status", spread, "exposed", 6)
	scene.call("_apply_status", spread, "dazed", 6)
	ok(int(scene.call("_status_count", spread)) == 4,
		"the control body now carries FOUR (got %d)"
			% int(scene.call("_status_count", spread)))
	spread.hp = 99999
	_seeded()
	await scene.call("_resolve", sv, _card("Hunt"), spread, "good")
	var on_four: int = 99999 - spread.hp
	ok(float(on_four) > float(on_spread) * 1.5,
		"doubling the COUNT roughly doubles the blow (%d at two, %d at four)"
			% [on_spread, on_four])
	scene.queue_free()
	await process_frame


func _live_preparation() -> void:
	# §6's EIGHTH CLAUSE — the first extra-turn mechanic in the game, and the
	# only one whose negative control is the point of the check.
	var scene := await _spawn("mystic", ["raider", "raider"])
	var sv := _hunter(scene, "trapper")
	ok(sv != null, "the Survivalist spawned")
	if sv == null:
		scene.queue_free()
		return
	ok(sv.prep_pending == 0, "nothing is pending before the cast")
	await scene.call("_resolve", sv, _card("Preparation"), sv, "good")
	ok(sv.prep_pending == 2,
		"the cast arms TWO, which is what makes the delay exact (got %d)"
			% sv.prep_pending)
	# THE NO-CHAIN REFUSAL. This is the negative control that matters: without
	# it the ability is an unbounded loop, i.e. a hang rather than a balance
	# question. It is driven at the gate itself.
	#
	# THE COOLDOWN IS CLEARED FIRST, AND THAT LINE IS THE WHOLE CHECK. A running
	# negative control found this passing for the WRONG REASON: the cast it just
	# made started a 5-turn cooldown, so `_ability_usable` refused on the
	# cooldown and would have gone on refusing with the no-chain gate deleted.
	# The assertion only discriminates once the ONLY thing left that can refuse
	# it is `prep_pending`. (BQ's own lesson — a check that can only pass is a
	# gap — arriving from the other direction: a check that passes for a reason
	# it is not testing is the same gap.)
	sv.cooldowns.clear()
	sv.resource = sv.max_resource
	ok(not bool(scene.call("_ability_usable", sv, _card("Preparation"))),
		"PREPARATION IS REFUSED WHILE ONE IS PENDING — the no-chain rule,"
			+ " with the cooldown cleared so nothing else can be doing the refusing")
	# THE FIRST TICK IS THE TURN HE CAST ON AND MUST GRANT NOTHING. A version
	# that fired immediately passes "he acted again" and fails right here.
	var clock_was: float = sv.next_time
	scene.call("_preparation_tick", sv)
	ok(sv.prep_pending == 1,
		"the turn he CAST on burns one and grants nothing (got %d)"
			% sv.prep_pending)
	ok(is_equal_approx(sv.next_time, clock_was),
		"and his clock has not moved (%s -> %s)" % [clock_was, sv.next_time])
	sv.cooldowns.clear()
	sv.resource = sv.max_resource
	ok(not bool(scene.call("_ability_usable", sv, _card("Preparation"))),
		"and it is STILL refused a turn later, cooldown cleared again —"
			+ " the pending counter is the only thing that can be refusing it")
	# THE SECOND TICK IS HIS NEXT TURN AND MUST GRANT THE EXTRA ONE — pulled
	# ahead of EVERY other unit on the field, which is what "immediately" means.
	for e in scene.get("enemies"):
		e.next_time = 10.0
	for h in scene.get("heroes"):
		if h != sv:
			h.next_time = 10.0
	sv.next_time = 40.0
	scene.call("_preparation_tick", sv)
	ok(sv.prep_pending == 0, "the counter is spent (got %d)" % sv.prep_pending)
	ok(sv.next_time < 10.0,
		"and he is pulled AHEAD of everything on the clock (%s against 10.0)"
			% sv.next_time)
	var soonest := INF
	for u in scene.get("heroes") + scene.get("enemies"):
		if u.dead or u == sv:
			continue
		soonest = minf(soonest, u.next_time)
	ok(sv.next_time < soonest, "so `_next_unit` picks HIM next — it really is a turn")
	# AND NOW IT IS CASTABLE AGAIN. A refusal that never lifts is a different
	# bug from a chain, and just as silent.
	sv.cooldowns.clear()
	ok(bool(scene.call("_ability_usable", sv, _card("Preparation"))),
		"with nothing pending the cast is allowed again")
	# A THIRD TICK MUST DO NOTHING AT ALL — no second turn falls out of a spent
	# counter.
	var after: float = sv.next_time
	scene.call("_preparation_tick", sv)
	ok(sv.prep_pending == 0 and is_equal_approx(sv.next_time, after),
		"a spent counter grants no further turns")
	scene.queue_free()
	await process_frame

	# THE `Improvised` INTERACTION, WHICH THE BRIEF ASKED TO BE REPORTED RATHER
	# THAN PRE-TUNED — so it is MEASURED here rather than asserted from reading,
	# AND THE MEASUREMENT DISAGREED WITH THE BRIEF'S NUMBER. Improvised
	# (Survivalist, Guerilla row 7) stops the first two abilities of a fight
	# starting their cooldowns. §4 predicted "a Guerilla build opens with
	# Preparation twice. Bounded at two." TWO IS THE BOUND ON THE *FREE* CASTS
	# AND NOT ON THE OPENING: because the extra turn each cast buys is a REAL
	# turn, it ticks the cooldown too, so the third cast comes back sooner than
	# an unaccelerated build's would. The loop plays it out honestly — cast
	# whenever the gate allows, tick at the end of every turn, tick cooldowns as
	# a turn does — and reports what actually happens.
	var scene2 := await _spawn("mystic", ["raider", "raider"],
		{"sv_improvised": 1})
	var sv2 := _hunter(scene2, "trapper")
	if sv2 == null:
		scene2.queue_free()
		return
	ok(sv2.improvised == 2, "Improvised pays for TWO free openings (got %d)"
		% sv2.improvised)
	var casts := 0
	var extra_turns := 0
	var first_five := 0
	var max_pending := 0
	for turn_i in 12:
		sv2.resource = sv2.max_resource
		if bool(scene2.call("_ability_usable", sv2, _card("Preparation"))):
			await scene2.call("_resolve", sv2, _card("Preparation"), sv2, "good")
			casts += 1
			if turn_i < 5:
				first_five += 1
		max_pending = maxi(max_pending, sv2.prep_pending)
		var clock_before: float = sv2.next_time
		scene2.call("_preparation_tick", sv2)
		if not is_equal_approx(sv2.next_time, clock_before):
			extra_turns += 1
		# Every turn ticks a cooldown, exactly as a real turn would.
		scene2.call("_tick_cooldowns", sv2, 1, "")
	# THE BOUND THAT IS REAL AND IS THE ONE THAT MATTERS: exactly two casts are
	# Improvised-funded, and the counter cannot be over-spent.
	ok(sv2.improvised_used == 2,
		"exactly TWO casts were Improvised-funded (got %d)" % sv2.improvised_used)
	# THE INVARIANT THAT MAKES THE MECHANIC SAFE, which is what "bounded" should
	# have meant: ONE extra turn per cast, never two pending, no chain. This
	# holds however fast he casts, which is why it is the assertion and the
	# cadence below is a report.
	ok(casts == extra_turns,
		"every cast bought EXACTLY ONE extra turn — %d casts, %d turns" % [
			casts, extra_turns])
	ok(max_pending <= 2,
		"the counter never rises above 2, so two can never be pending at once"
			+ " (peak %d)" % max_pending)
	# AND THE REPORT: the opening is faster than §4 predicted, because each extra
	# turn is a REAL turn and ticks the cooldown with it. Pinned as a number so a
	# later batch that changes Preparation's cooldown sees this move.
	ok(first_five == 3,
		"REPORTED, NOT TUNED: a Guerilla build gets %d Preparations in its first"
			% first_five
			+ " five turns (two free, then one the shortened clock allows) —"
			+ " §4 predicted two")
	scene2.queue_free()
	await process_frame


func _live_gates() -> void:
	# EACH GATE REFUSES A CAST THAT COULD ONLY EVER DO NOTHING (BO's rule), and
	# each is driven in BOTH directions — a gate stuck shut is as silent as one
	# stuck open, and only the pair tells them apart.
	var scene := await _spawn("beastmaster", ["raider", "raider"])
	var bm := _hunter(scene, "pack")
	if bm == null:
		scene.queue_free()
		return
	bm.resource = bm.max_resource
	# SAVAGE SWEEP needs a body to give the order to.
	ok(not bool(scene.call("_ability_usable", bm, _card("Savage Sweep"))),
		"Savage Sweep is refused with no companion standing")
	# GHOSTPACK needs something summoned this battle.
	ok(not bool(scene.call("_ability_usable", bm, _card("Ghostpack"))),
		"Ghostpack is refused before the first summon")
	# BLOODBOND is NOT gated on a beast — the guard is sworn to the BOND, so
	# placing it before summoning is a real line of play.
	ok(bool(scene.call("_ability_usable", bm, _card("Bloodbond"))),
		"Bloodbond is allowed with no beast out — the guard waits for one")
	await scene.call("_do_summon", bm, "ursus")
	bm.resource = bm.max_resource
	bm.cooldowns.clear()
	ok(bool(scene.call("_ability_usable", bm, _card("Savage Sweep"))),
		"and Savage Sweep opens once a companion stands")
	ok(bool(scene.call("_ability_usable", bm, _card("Ghostpack"))),
		"and Ghostpack opens once one has been summoned")
	# BLOODBOND REFUSES A SECOND HELPING while the first still stands.
	await scene.call("_resolve", bm, _card("Bloodbond"), bm, "good")
	bm.resource = bm.max_resource
	bm.cooldowns.clear()
	ok(not bool(scene.call("_ability_usable", bm, _card("Bloodbond"))),
		"Bloodbond is refused while the bond he already swore still stands")
	scene.queue_free()
	await process_frame

	# HUNT reads the count and nothing else, so a clean field is a cast for the
	# floor of 1.
	var scene2 := await _spawn("mystic", ["raider", "raider"])
	var sv := _hunter(scene2, "trapper")
	if sv == null:
		scene2.queue_free()
		return
	sv.resource = sv.max_resource
	for e in scene2.get("enemies"):
		e.statuses.clear()
	ok(not bool(scene2.call("_ability_usable", sv, _card("Hunt"))),
		"Hunt is refused against a field carrying no afflictions")
	# LOADED SHOT IS DELIBERATELY UNGATED: it is 20% of Attack whatever the board
	# looks like, so refusing it would refuse a real attack.
	ok(bool(scene2.call("_ability_usable", sv, _card("Loaded Shot"))),
		"Loaded Shot is NOT gated — it lands its damage on any target")
	scene2.call("_apply_status", _live_foes(scene2)[0], "poison", 4)
	ok(bool(scene2.call("_ability_usable", sv, _card("Hunt"))),
		"and Hunt opens the moment anything is afflicted")
	scene2.queue_free()
	await process_frame
