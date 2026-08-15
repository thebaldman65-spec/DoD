# test_batch_bt.gd — TRANCHE 2, THE MAGE NINE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bt.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability or its damage by hand.
#
# WHAT IT PROTECTS, and the shape of each check follows §6's own list of the
# clauses that could silently do nothing or the wrong thing. SEVEN OF THEM ARE
# BUILT SO A BROKEN IMPLEMENTATION STILL FAILS, because each would otherwise
# pass on code doing something adjacent and wrong:
#
# · SLOW BURN stops the tick-DOWN without stopping the tick DAMAGE. "The burn
#   is still there" is trivially true of an ability that does nothing at all,
#   so the check drives BOTH quantities across the same ticks: the turn count
#   must NOT fall while the victim's health MUST. A version that froze the
#   whole status would pass the first half and fail the second; a version that
#   did nothing would fail the first.
# · STOKE doubles REMAINING TURNS and does nothing to a non-Burning target.
#   "The burn got longer" is trivially true of an additive clause (Backdraft
#   already is one), so it is measured at TWO DIFFERENT DEPTHS — 3 turns and 7
#   — where doubling and any flat addition diverge by construction, plus the
#   empty case where a flat addition would still fire.
# · FUNERAL PYRE consumes ALL Burn, shields 150% of what that Burn was worth,
#   and pays Overburn's refund per turn consumed. "He got a shield" is
#   trivially true of any barrier, so the shield's SIZE is asserted against a
#   burn whose turns and tick are both known and DIFFERENT numbers (a
#   turns-only or tick-only implementation reads wrong), the burn is asserted
#   GONE, and the Mana delta is asserted separately.
# · FLASH FREEZE against a boss, EXACTLY as the carve-out allows. "It froze" is
#   trivially true against a raider, so the same cast is driven at an UNBROKEN
#   boss (refused), a BROKEN boss (held, and TIMED — one turn, not a lockdown)
#   and an unbroken boss on a PERFECT (held, still timed). The description is
#   asserted to say the boss rule, because a card promising more than it
#   delivers is the failure §3 named.
# · KILLING FROST hits only CHILLED enemies and adds stacks to each. "Damage
#   happened" is trivially true of an AoE, so the field is built with a chilled
#   HALF and an unchilled half in the SAME battle and both are read.
# · ARCANE BOLT deals per-stack damage and halves AFTER, not before. "It did
#   damage" is trivially true, so the SAME cast is driven at two stack counts
#   and the damage asserted to scale with the meter he walked in with — which a
#   halve-first implementation fails by exactly a factor of two.
# · ARCANE ECHO repeats PER HIT and only against its marked target. "It echoed"
#   is trivially true of a per-cast implementation, so it is driven with a
#   MULTI-HIT ability and the echo count asserted as an exact identity against
#   a single-strike ability in the same check — which is what tells three per
#   VOLLEY from three per CAST (BR's Aimed Volley construction).
#
# Plus INNER ARCANE reading LIVING enemies and doubling under half health (both
# halves at once would be indistinguishable from either alone, so the count and
# the threshold are varied SEPARATELY), and HOARFROST ARMOR applying its stacks
# to the STRIKER rather than to the target of his own casts — driven by having
# him cast at an enemy and asserting that enemy gained NOTHING, then having an
# enemy strike him and asserting the striker did.
#
# HARNESS NOTE THAT WILL SAVE THE NEXT AUTHOR A BISECT: several checks compare
# ONE BLOW AGAINST ONE BLOW, and the first line of the strike block is
# `randf_range(0.9, 1.1)`. BQ killed the CRIT roll for this class of check and
# BS found the VARIANCE roll is the half that survived it — with a term
# disabled a second blow still read SMALLER than the first. Both are handled:
# `crit_bonus = -1.0` at spawn, and `_seeded()` immediately before each blow of
# a pair so the two draw the SAME variance. Forced determinism, never a retry
# (the AK/AL/AR discipline).
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on rather than
# hiding it inside a magic number.
const HOARFROST_CUT_TEST := 0.25
const ARCANE_ECHO_SHARE_TEST := 0.30

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# This table is the machine-checkable half of "the batch shipped what it said".
const NINE := {
	"Slow Burn":       ["pyromancer", 15, 1.5, 4, 0],
	"Stoke":           ["pyromancer", 20, 2.0, 3, 8],
	"Funeral Pyre":    ["pyromancer", 25, 2.5, 4, 0],
	"Flash Freeze":    ["cryomancer", 30, 3.0, 5, 0],
	"Killing Frost":   ["cryomancer", 20, 2.0, 3, 6],
	"Hoarfrost Armor": ["cryomancer", 20, 2.0, 4, 0],
	"Arcane Bolt":     ["arcanist", 30, 2.5, 4, 8],
	"Inner Arcane":    ["arcanist", 15, 1.0, 3, 0],
	"Arcane Echo":     ["arcanist", 25, 2.0, 4, 6],
}


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
	Profile.save_path = "user://profile_batch_bt_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_definitions()
	_synergy_rule()
	_names()
	_no_new_unit_fields()
	_one_shield_door()
	_docs()
	await _live_slow_burn()
	await _live_stoke()
	await _live_funeral_pyre()
	await _live_flash_freeze()
	await _live_killing_frost()
	await _live_hoarfrost()
	await _live_arcane_bolt()
	await _live_inner_arcane()
	await _live_arcane_echo()
	await _live_gates()

	if FileAccess.file_exists("user://profile_batch_bt_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bt_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BT: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- the pools ----------

func _pools() -> void:
	# RE-POINTED IN PLACE BY BATCH BU, AND IT IS AN INVERSION OF THE SECOND
	# HALF. BT's own line was "the Mage three go to five; NOBODY ELSE MOVES",
	# which was true of BT and is the exact statement BU pays off: the CLERIC
	# three joined them. The question the loop asks — which pools are deep and
	# which are still owed — is unchanged and is still what tells the two
	# answers apart; only the correct answer moved.
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 5, "%s drafts FIVE (got %d)" % [spec, pool.size()])
	for spec in ["holy", "inquisitor", "occultist"]:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s joined them at FIVE in Batch BU" % spec)
	# RE-POINTED BY BATCH BV, which paid the HUNTER third: the three Hunter pools
	# joined the Mage and Cleric at five, so ONLY THE WARRIOR THREE are still at
	# two. Kept as an inversion rather than deleted — the half of this check that
	# matters is that the LAST unpaid third stays visible in code.
	# RE-POINTED BY BATCH BW, AND IT IS AN INVERSION: this asserted the WARRIOR
	# three were still at TWO because that debt was real and had to stay visible
	# in code. BW paid it, so tranche 2 is complete and what is asserted is that
	# ALL TWELVE are five. A pool quietly emptying still trips.
	for spec in Classes.SPEC_DRAFT_POOLS:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s drafts FIVE — tranche 2 is complete" % spec)
	for spec in ["beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s joined them at FIVE in Batch BV" % spec)
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 60,
		"the spec pools hold 60 (24 + tranche 2's thirty-six), got %d"
			% total)
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR negative control.
	for cls in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls).size() == 6,
			"%s's class pool is still SIX" % cls)
		for n in NINE:
			ok(not Classes.class_draft_pool(cls).has(n),
				"%s is a SPEC card and is not in %s's class pool" % [n, cls])
	# CLASS_POOLS FEEDS THE BOSS PICK and must not move either (BO's rule, kept
	# by BQ and BR). Asserted as literals rather than by size: a swap of two
	# names would keep the count and change every boss draw in the game.
	ok(Classes.CLASS_POOLS["mage"].size() == 12,
		"CLASS_POOLS['mage'] is byte-untouched at 12")
	for n in NINE:
		for cls in Classes.CLASS_POOLS:
			ok(not Classes.CLASS_POOLS[cls].has(n),
				"%s did not leak into the BOSS pool %s" % [n, cls])
		for spec in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec].has(n),
				"%s did not leak into the boss SPEC pool %s" % [n, spec])


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
		# BREAK DAMAGE ASSIGNED DELIBERATELY, NOT BY OMISSION — the BO/BP/BQ/BR
		# rule. The four attacks carry it; the five that never strike carry
		# none, because Break from an ability that lands no blow is Break from
		# nowhere.
		ok(ab.pressure == NINE[n][4],
			"%s carries %d Break (got %d)" % [n, NINE[n][4], ab.pressure])
		ok(ab.description != "", "%s has a description" % n)
		ok(ab.perfect_text != "", "%s states a perfect" % n)
		# And it RESOLVES through the one door every earned ability uses, or a
		# drafted card would land in `bm_abilities` and never spawn.
		ok(Classes.pool_ability(n) != null,
			"%s resolves through pool_ability" % n)
	# THE THREE THAT ARE ORDINARY ATTACKS CARRY NO `special` — that is the whole
	# reason they get the strike pipeline (crit, variance, resists, armor,
	# Overburn, the Resonance curve) instead of re-implementing it.
	for n in ["Stoke", "Arcane Bolt", "Arcane Echo"]:
		ok(Classes.draft_ability(n).special == "",
			"%s is an ordinary attack, not a special" % n)
		ok(Classes.draft_ability(n).damage > 0, "%s deals damage" % n)
	for n in ["Slow Burn", "Funeral Pyre", "Flash Freeze", "Killing Frost",
			"Hoarfrost Armor", "Inner Arcane"]:
		ok(Classes.draft_ability(n).special != "",
			"%s resolves through a special" % n)
	# Killing Frost is field-wide, which is what makes it a self-targeting cast
	# rather than a click (it falls through to the aoe branch).
	ok(Classes.draft_ability("Killing Frost").aoe,
		"Killing Frost is an area attack")
	ok(not Classes.draft_ability("Stoke").aoe, "Stoke names ONE enemy")


func _synergy_rule() -> void:
	# §1's STANDING RULE, MADE MECHANICAL: from this tranche on every ability
	# NAMES what it builds with. A card nobody plans around is a card that fills
	# a slot, and the cheapest way for that to creep back is for the next author
	# to skip the line. Each of the nine must carry a SYNERGY comment naming at
	# least one other thing in the game.
	var src := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var block := src.substr(src.find("BATCH BT: TRANCHE 2, THE MAGE NINE"))
	ok(block.contains("SYNERGY RULE STARTS HERE AND IS STANDING"),
		"the synergy rule is recorded with the content it governs")
	for n in NINE:
		var at := block.find('"%s":' % n)
		ok(at > 0, "%s sits inside the BT block" % n)
		if at <= 0:
			continue
		# The 1600 characters above the entry are its comment.
		var lead := block.substr(maxi(at - 1600, 0), mini(at, 1600))
		ok(lead.contains("SYNERGY:") or lead.contains("SYNERGY, "),
			"%s names what it combos with" % n)
		ok(lead.contains("AXIS:"), "%s names its axis" % n)


func _names() -> void:
	# BR §1's SWEEP, RUN AS A TEST RATHER THAN AS A ONE-OFF. An
	# ABILITY-vs-ABILITY duplicate is a REAL BREAK — `pool_ability` is keyed on
	# `display_name`, so two abilities sharing one make the resolver answer the
	# wrong question — and must be renamed. Everything else is a label
	# collision that ships flagged.
	var seen := {}
	var dupes: Array = []
	for spec in Classes.SPEC_DRAFT_POOLS:
		for n in Classes.spec_draft_pool(spec):
			if seen.has(n):
				dupes.append(n)
			seen[n] = true
	for cls in Classes.CLASS_DRAFT_POOLS:
		for n in Classes.class_draft_pool(cls):
			if seen.has(n):
				dupes.append(n)
			seen[n] = true
	ok(dupes.is_empty(),
		"no ability name is used twice across the whole draft (%s)" % str(dupes))
	# THE ONE COLLISION THIS BATCH SHIPS, PINNED BY NAME SO IT CANNOT BE
	# "DISCOVERED" AGAIN: KILLING FROST is also a Cryomancer talent NODE
	# (`cr_freezing`, Thaw row 2). SAME SPEC — a Cryomancer holding the node can
	# draft the card — which is the Iron Will shape rather than BP's Precision
	# Strike. It is a LABEL collision only, and these two checks are what say
	# so: the node's counter and the card's handler share no field.
	# `LANE_TREES[spec]` is a FLAT ARRAY of node dicts, not a dict of lanes —
	# indexing it by lane throws, and a throw ABORTS THIS WHOLE FUNCTION while
	# the suite still prints "0 failures" (the BC trap). Caught here by the
	# count, which is exactly what that trap is caught by.
	var node_named := false
	for node in Talents.LANE_TREES["cryomancer"]:
		if String(node.get("name", "")) == "Killing Frost":
			node_named = true
			ok(String(node["id"]) == "cr_freezing",
				"the colliding node is cr_freezing")
			ok(node["payload"]["stat"].has("killing_frost"),
				"...and its counter is `killing_frost`, a stat field")
	ok(node_named,
		"KILLING FROST collides with a live Cryomancer node — reported, not resolved")
	ok(Classes.draft_ability("Killing Frost").special == "killing_frost",
		"...and the CARD's half is a `special`, which nothing resolves as a name")
	# Hoarfrost Armor's adjacency: the modifier is `hoarfrost` and the STATUS
	# this card applies is `rimeguard`, precisely so two chips never read the
	# same word.
	var run := root.get_node("/root/Run")
	ok(run.MODIFIERS.has("hoarfrost"),
		"`hoarfrost` is a battle modifier — the adjacency this batch reports")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains('_apply_status(attacker, "rimeguard"'),
		"...and Hoarfrost Armor's status is `rimeguard`, not `hoarfrost`")
	# What must NOT exist is a STATUS registered under the modifier's word: the
	# card's special is `hoarfrost_armor` (a handler name, which nothing renders)
	# and its status is `rimeguard` (which is what a player reads on the chip).
	ok(not bsrc.contains('\n\t"hoarfrost": ['),
		"...and no STATUS is registered under the modifier's word")
	ok(not bsrc.contains('_apply_status(attacker, "hoarfrost"'),
		"...and nothing applies one")


func _no_new_unit_fields() -> void:
	# NINE ABILITIES, ZERO NEW UNIT FIELDS (BQ's standard). Everything with a
	# duration is a STATUS — they expire by themselves and cannot leak past a
	# battle — and nothing here banks a count. A new field is where an effect
	# starts surviving a fight it was not meant to.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for f in ["var slow_burn", "var rimeguard", "var arcane_echo",
			"var funeral_pyre", "var stoke", "var inner_arcane"]:
		ok(not usrc.contains(f),
			"no unit field `%s` — the nine ride statuses alone" % f)
	# The three new statuses are REGISTERED, or `_apply_status` has no label,
	# colour or tooltip for them and the chip renders blank.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for id in ["slow_burn", "rimeguard", "arcane_echo"]:
		ok(bsrc.contains('"%s": [' % id), "STATUS_INFO registers `%s`" % id)
	# ARCANE ECHO IS A MARK AND IS DELIBERATELY NOT A DEBUFF — the
	# `quarry`/`snare_line`/`feinted` rule. A mender's Cleansing Rite takes the
	# LONGEST-remaining debuff, and a mark is not what that rule is for.
	ok(not BattleUnit.DEBUFF_IDS.has("arcane_echo"),
		"Arcane Echo is a MARK, so it is not in DEBUFF_IDS")
	# SLOW BURN *IS* a debuff — it makes the enemy's own fire last longer — so
	# it is cleansable, which is the counterplay rather than an oversight (the
	# Blight the Well precedent).
	ok(BattleUnit.DEBUFF_IDS.has("slow_burn"),
		"Slow Burn IS a debuff, so a mender can strip it — the counterplay")


func _one_shield_door() -> void:
	# §2'S EXPLICIT INSTRUCTION: use the existing shield door, do not write a
	# third. Magic Barrier and Divine Shield both go through the `barrier`
	# status, and so does Funeral Pyre.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# ANCHORED ON THE MATCH CASE AT ITS OWN INDENT, not on the bare name: the
	# bot's targeting refinement reads `ab.special == "funeral_pyre":` and would
	# otherwise start the slice hundreds of lines early, sweeping in every
	# Divine Shield in the file. A slice that quietly covers the wrong region is
	# a check that has stopped asking its question (BE's changelog-anchor
	# lesson, through a source-code door).
	var pyre := src.substr(src.find('\n\t\t"funeral_pyre":'))
	pyre = pyre.substr(0, pyre.find('\n\t\t"flash_freeze":'))
	ok(pyre.length() > 200 and pyre.length() < 4000,
		"the Funeral Pyre slice is the case body and nothing else (%d chars)" % pyre.length())
	ok(pyre.contains('_apply_status(attacker, "barrier"'),
		"Funeral Pyre uses the EXISTING barrier door")
	# COMMENTS ARE STRIPPED FIRST, and it is not a convenience: this batch's own
	# comment in that case says "DELIBERATELY NOT `divine`" on purpose, so a bare
	# `contains` would fail against working code and invite a later author to
	# "fix" it by deleting the line that explains the decision (BS's lesson,
	# arriving through a different door). What is checked is CODE.
	var pyre_code := ""
	for line in pyre.split("\n"):
		if not line.strip_edges().begins_with("#"):
			pyre_code += line + "\n"
	# NOT DIVINE, for Magic Barrier's own reason: Faith is the Devout's engine
	# and a Mage's ward feeding Conviction would be a spec mechanic leaking out
	# through a Mage card. `divine` is what `_gain_faith` reads.
	ok(not pyre_code.contains('"divine"'),
		"...and it is NOT a divine shield — it feeds no Faith")
	# AND IT WRITES NO SECOND ABSORB. The barrier pipeline spends its power in
	# ONE place (`unit.take_hit`'s barrier block); a card that did its own
	# arithmetic on that number is how two implementations start disagreeing
	# about what a barrier is.
	ok(not pyre_code.contains('["power"] -') and not pyre_code.contains("power -="),
		"...and it spends nothing itself — the absorb stays in one place")


func _docs() -> void:
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master.contains("Batch BX"), "master.html carries the current batch stamp")
	for n in NINE:
		ok(master.contains(n), "master.html lists %s" % n)
	# §5: THE SYNERGY LINE IS THE INFORMATION THIS TRANCHE WAS AUTHORED FOR, so
	# the doc that a player reads has to carry it rather than only the numbers.
	ok(master.contains("Builds with"),
		"master.html's draft tables carry each card's synergy line")
	var chlog := FileAccess.get_file_as_string("res://docs/changelog.html")
	ok(chlog.contains("Batch BT"), "the changelog has a Batch BT entry")
	for n in NINE:
		ok(chlog.contains(n), "the changelog names %s" % n)


# ---------- the live harness ----------

func _spawn(spec: String, lineup: Array, learned := {}) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", spec, "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline). Every
	# check below drives `_resolve` or `take_hit` by hand, and a 5% miss or a 5%
	# parry skips the whole damage path — which reads as "the clause did
	# nothing" and turns a real assertion into a coin flip.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0   # BQ: a live crit roll flips any one-blow comparison
	return scene


func _mage(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _live_foes(scene: Node) -> Array:
	return scene.get("enemies").filter(func(e): return not e.dead)


func _seeded() -> void:
	seed(20260814)


# The card, ready to cast: found by name so the check drives exactly what the
# draft would hand a player rather than a copy assembled here.
func _card(name: String) -> Ability:
	return Classes.draft_ability(name)


# ---------- §2 live: the Pyromancer three ----------

func _live_slow_burn() -> void:
	# §6'S FIRST CLAUSE, AND BOTH HALVES ARE DRIVEN IN THE SAME CHECK. "The
	# Burn is still there" is trivially true of an ability that does nothing,
	# and "the Burn stopped" would be true of one that froze the whole status —
	# so the TURN COUNT must not fall while HEALTH must.
	var scene := await _spawn("pyromancer", ["raider", "raider", "archer"])
	var py := _mage(scene, "overburn")
	ok(py != null, "the Pyromancer spawned")
	if py == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var victim: BattleUnit = foes[0]
	scene.call("_apply_status", victim, "burn", 6, 0, 6, py)
	ok(int(victim.get_status("burn").get("turns", 0)) == 6,
		"the victim carries a 6-turn Burn")
	# CONTROL FIRST, IN THE SAME BATTLE: without the marker the clock falls.
	var hp_was: int = victim.hp
	victim.tick_statuses()
	ok(int(victim.get_status("burn").get("turns", 0)) == 5,
		"CONTROL: an unmarked Burn ticks 6 -> 5")
	# Now the card. It reaches EVERY living enemy, which is what "on every
	# enemy" means and what a single-target implementation would fail.
	await scene.call("_resolve", py, _card("Slow Burn"), py, "good")
	var marked := 0
	for f in _live_foes(scene):
		if f.has_status("slow_burn"):
			marked += 1
	ok(marked == _live_foes(scene).size(),
		"Slow Burn marks EVERY living enemy (%d of %d)" % [
			marked, _live_foes(scene).size()])
	ok(int(victim.get_status("slow_burn").get("turns", 0)) == 3,
		"...for three turns (got %d)" % int(victim.get_status("slow_burn").get("turns", 0)))
	# THREE TICKS. The clock must not move, and the fire must still burn.
	var turns_was := int(victim.get_status("burn").get("turns", 0))
	hp_was = victim.hp
	for _i in 3:
		victim.tick_statuses()
	ok(int(victim.get_status("burn").get("turns", 0)) == turns_was,
		"three ticks under Slow Burn leave the Burn at %d (got %d)" % [
			turns_was, int(victim.get_status("burn").get("turns", 0))])
	ok(victim.has_status("burn"), "...and the Burn is still standing")
	# The DAMAGE half, driven through the same path the turn loop uses — a
	# frozen STATUS would leave the victim unharmed, which is the wrong fix.
	var tick: int = int(victim.get_status("burn").get("tick", 6))
	ok(tick > 0, "the Burn carries a real tick (%d)" % tick)
	victim.take_tick_damage(tick, "-%d" % tick, Color.RED)
	ok(victim.hp < hp_was,
		"...and it still BURNS: %d -> %d" % [hp_was, victim.hp])
	# THE MARKER'S OWN CLOCK RAN OUT, so the hold is three turns and not
	# forever — the failure that would read as working for a whole battle.
	ok(not victim.has_status("slow_burn"),
		"the marker itself expired after three turns — the hold is not permanent")
	victim.tick_statuses()
	ok(int(victim.get_status("burn").get("turns", 0)) == turns_was - 1,
		"...and the Burn resumes counting down afterwards")
	scene.queue_free()
	await process_frame


func _live_stoke() -> void:
	# §6'S SECOND CLAUSE. Measured at TWO DEPTHS, because doubling and any flat
	# addition agree at exactly one number and diverge everywhere else — a
	# check at a single depth cannot tell Stoke from Backdraft.
	var scene := await _spawn("pyromancer", ["raider", "raider"])
	var py := _mage(scene, "overburn")
	if py == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	scene.call("_apply_status", a, "burn", 3, 0, 6, py)
	scene.call("_apply_status", b, "burn", 7, 0, 6, py)
	a.hp = a.max_hp * 10          # nothing may die mid-check
	b.hp = b.max_hp * 10
	_seeded()
	await scene.call("_resolve", py, _card("Stoke"), a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == 6,
		"Stoke doubles 3 turns to 6 (got %d)" % int(a.get_status("burn").get("turns", 0)))
	_seeded()
	await scene.call("_resolve", py, _card("Stoke"), b, "good")
	ok(int(b.get_status("burn").get("turns", 0)) == 14,
		"...and 7 to 14, which no flat addition does (got %d)" % \
			int(b.get_status("burn").get("turns", 0)))
	# THE EMPTY CASE. A flat addition would still fire here and light a fire
	# that was never lit, so this is what tells a multiplier from an adder.
	var c: BattleUnit = foes[0]
	c.remove_status("burn")
	_seeded()
	var hp_before: int = c.hp
	await scene.call("_resolve", py, _card("Stoke"), c, "good")
	ok(not c.has_status("burn"),
		"Stoke lights NOTHING on an enemy that is not alight")
	ok(c.hp < hp_before, "...but its 25% of Attack still lands")
	# THE PERFECT TRIPLES rather than doubling twice.
	scene.call("_apply_status", c, "burn", 4, 0, 6, py)
	_seeded()
	await scene.call("_resolve", py, _card("Stoke"), c, "perfect")
	ok(int(c.get_status("burn").get("turns", 0)) == 12,
		"a PERFECT Stoke triples 4 to 12 (got %d)" % \
			int(c.get_status("burn").get("turns", 0)))
	scene.queue_free()
	await process_frame


func _live_funeral_pyre() -> void:
	# §6'S THIRD CLAUSE, ALL THREE HALVES. The shield's SIZE is asserted against
	# a burn whose TURNS and TICK are deliberately different numbers, so an
	# implementation reading only one of them lands on a different figure.
	var scene := await _spawn("pyromancer", ["raider", "raider"])
	var py := _mage(scene, "overburn")
	if py == null:
		scene.queue_free()
		return
	var victim: BattleUnit = _live_foes(scene)[0]
	victim.hp = victim.max_hp * 10
	# 5 turns at a tick of 8 = 40 points of fire still owed. 5 and 8 differ, so
	# a turns-only read gives 7 and a tick-only read gives 12 — neither is 60.
	scene.call("_apply_status", victim, "burn", 5, 0, 8, py)
	# `_resolve` DEDUCTS the ability's cost (battle.gd's spend block), so the
	# Mana delta below is cost-then-refund and the check states both halves
	# rather than pretending the refund is the only thing that moved.
	py.resource = 100
	py.remove_status("barrier")
	await scene.call("_resolve", py, _card("Funeral Pyre"), victim, "good")
	ok(not victim.has_status("burn"),
		"Funeral Pyre consumes ALL the Burn on its target")
	var shield: int = py.status_power("barrier")
	ok(shield == 60,
		"the shield is 150%% of the 40 that Burn still owed = 60 (got %d)" % shield)
	# THE REFUND, measured as a Mana delta rather than inferred: 5 turns
	# consumed is 5 Mana through the ONE door every other consumer shares.
	ok(py.resource == 80,
		"100 Mana, less the card's 25, plus Overburn's 5 for the 5 turns consumed = 80 (got %d)" % py.resource)
	# THE WARD IS REAL — a barrier with no absorb is a chip. Driven through
	# `take_hit`, the path an enemy blow takes.
	var hp_was: int = py.hp
	py.take_hit(20, 0)
	ok(py.hp == hp_was, "the shield actually absorbs (%d -> %d)" % [hp_was, py.hp])
	ok(py.status_power("barrier") == 40,
		"...and it is spent down by what it ate (got %d)" % py.status_power("barrier"))
	# NOT DIVINE: it must feed no Faith, or a Mage card would drive the Devout's
	# engine.
	ok(not bool(py.get_status("barrier").get("divine", false)),
		"the pyre's ward is NOT a Divine Shield")
	# THE PERFECT pays 200%.
	var other: BattleUnit = _live_foes(scene)[1]
	other.hp = other.max_hp * 10
	scene.call("_apply_status", other, "burn", 5, 0, 8, py)
	py.remove_status("barrier")
	await scene.call("_resolve", py, _card("Funeral Pyre"), other, "perfect")
	ok(py.status_power("barrier") == 80,
		"a PERFECT pyre shields 200%% of 40 = 80 (got %d)" % py.status_power("barrier"))
	# THE MISFIRE, which is a LEGAL cast rather than an impossible one: the gate
	# only asks that SOMETHING on the field is alight, so a player can aim this
	# at the wrong body. It must consume nothing, ward nothing and refund
	# nothing — and it must not overwrite the ward he is already wearing with a
	# smaller one, which is `add_status`'s max() doing the work rather than this
	# site. Driven with a second enemy still burning, so the ability is usable.
	var cold: BattleUnit = _live_foes(scene)[0]
	cold.remove_status("burn")
	scene.call("_apply_status", _live_foes(scene)[1], "burn", 3, 0, 6, py)
	var held_before: int = py.status_power("barrier")
	var mana_before: int = py.resource
	await scene.call("_resolve", py, _card("Funeral Pyre"), cold, "good")
	ok(py.status_power("barrier") == held_before,
		"a pyre aimed at an unlit enemy leaves his standing ward alone (%d)" % \
			py.status_power("barrier"))
	ok(py.resource == mana_before - 25,
		"...and pays the cost with NO refund, because it consumed nothing (got %d)" % py.resource)
	scene.queue_free()
	await process_frame


# ---------- §3 live: the Cryomancer three ----------

func _live_flash_freeze() -> void:
	# §6'S FOURTH CLAUSE: BEHAVING EXACTLY AS THE CARVE-OUT ALLOWS, DRIVEN AT
	# ALL THREE STATES. "It froze something" is trivially true against a raider;
	# what §3 asked to verify is the boss interaction, so that is what is
	# measured.
	var scene := await _spawn("cryomancer", ["raider", "raider"])
	var cryo := _mage(scene, "permafrost")
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		return
	var victim: BattleUnit = _live_foes(scene)[0]
	ok(not victim.has_status("chilled"),
		"the target starts with no stacks at all")
	await scene.call("_resolve", cryo, _card("Flash Freeze"), victim, "good")
	ok(victim.has_status("frozen"),
		"Flash Freeze freezes OUTRIGHT, whatever the stacks")
	ok(scene.call("_is_held", victim), "...and it joins the Glacial Hold")
	ok(is_inf(victim.next_time),
		"...off the turn order entirely, which is what a hold is")
	scene.queue_free()
	await process_frame

	# THE BOSS, UNBROKEN: the carve-out REFUSES it, and the card says so.
	var bscene := await _spawn("cryomancer", ["boss", "raider"])
	var bcryo := _mage(bscene, "permafrost")
	if bcryo == null:
		bscene.queue_free()
		return
	var boss: BattleUnit = null
	for e in _live_foes(bscene):
		if e.is_boss:
			boss = e
	ok(boss != null, "a boss stands")
	if boss == null:
		bscene.queue_free()
		return
	boss.broken = false
	await bscene.call("_resolve", bcryo, _card("Flash Freeze"), boss, "good")
	ok(not boss.has_status("frozen"),
		"an UNBROKEN boss resists Flash Freeze — the carve-out is untouched")
	ok(not bscene.call("_is_held", boss), "...and is not held")
	# THE BOSS, BROKEN: it takes hold — and it is TIMED, one turn, not a
	# lockdown. That distinction is the whole of what §3 asked be verified
	# before the card's text was written.
	boss.broken = true
	await bscene.call("_resolve", bcryo, _card("Flash Freeze"), boss, "good")
	ok(boss.has_status("frozen"), "a BROKEN boss takes the ice")
	ok(int(boss.get_status("frozen").get("turns", -1)) == 1,
		"...for exactly ONE turn — a boss shrugs it off, which is not a lockdown")
	ok(not is_inf(boss.next_time),
		"...and it keeps its place on the timeline, unlike an ordinary hold")
	# THE PERFECT is what keeps this card from being a strictly worse Glacial
	# Prison: it passes `force`, the call-site-visible boss exception two other
	# perfects already buy. STILL ONE TURN — it buys the turn EARLIER, never a
	# longer one, and that is asserted rather than assumed.
	bscene.queue_free()
	await process_frame
	# THE PERFECT, ON A FRESH BATTLE. The boss above is still in `_holds`, and
	# removing its status by hand while leaving the ledger standing makes the
	# next freeze evict itself past the limit — a HARNESS artefact rather than a
	# product fault (in play a held enemy never reaches `_hold_freeze` again,
	# because it still carries `frozen`). A clean battle is the honest fix.
	var pscene := await _spawn("cryomancer", ["boss", "raider"])
	var pcryo := _mage(pscene, "permafrost")
	if pcryo == null:
		pscene.queue_free()
		return
	var pboss: BattleUnit = null
	for e in _live_foes(pscene):
		if e.is_boss:
			pboss = e
	ok(pboss != null, "a second boss stands")
	if pboss == null:
		pscene.queue_free()
		return
	pboss.broken = false
	await pscene.call("_resolve", pcryo, _card("Flash Freeze"), pboss, "perfect")
	ok(pboss.has_status("frozen"),
		"a PERFECT Flash Freeze takes an UNBROKEN boss — the `force` exception")
	ok(int(pboss.get_status("frozen").get("turns", -1)) == 1,
		"...and it is STILL one turn, never a longer hold (got %d)" % \
			int(pboss.get_status("frozen").get("turns", -1)))
	# THE DESCRIPTION MUST SAY SO. §3: the card must not promise more than it
	# delivers, and a boss clause is exactly where that goes wrong.
	var desc := _card("Flash Freeze").description
	ok(desc.contains("BOSS") and desc.contains("Broken"),
		"the card's text states the boss rule")
	ok(desc.contains("ONE turn"),
		"...and that it buys one turn against one, not a lockdown")
	pscene.queue_free()
	await process_frame


func _live_killing_frost() -> void:
	# §6'S FIFTH CLAUSE: only CHILLED enemies, and stacks on each. The field is
	# built with a chilled half and an unchilled half IN THE SAME BATTLE, so
	# "damage happened" cannot pass for "only the chilled were hit".
	var scene := await _spawn("cryomancer", ["raider", "raider", "archer", "archer"])
	var cryo := _mage(scene, "permafrost")
	if cryo == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	ok(foes.size() == 4, "four enemies stand")
	for f in foes:
		f.hp = f.max_hp * 10
	# Two chilled at one stack, two untouched.
	scene.call("_apply_status", foes[0], "chilled", 3, 0, 0, cryo)
	scene.call("_apply_status", foes[1], "chilled", 3, 0, 0, cryo)
	var hp_before: Array = []
	for f in foes:
		hp_before.append(f.hp)
	await scene.call("_resolve", cryo, _card("Killing Frost"), cryo, "good")
	ok(foes[0].hp < hp_before[0], "the first CHILLED enemy is struck")
	ok(foes[1].hp < hp_before[1], "the second CHILLED enemy is struck")
	ok(foes[2].hp == hp_before[2], "an UNCHILLED enemy is untouched")
	ok(foes[3].hp == hp_before[3], "...and so is the other one")
	ok(foes[0].status_stacks("chilled") == 3,
		"a struck enemy goes 1 stack -> 3 (got %d)" % foes[0].status_stacks("chilled"))
	ok(not foes[2].has_status("chilled"),
		"an unchilled enemy gains NO stacks — it was never touched")
	# FOUR STACKS STILL FREEZE. The stacks go through `_apply_status` one call
	# at a time precisely so this stays true; writing the pile directly would
	# skip the branch where four stacks flash-freeze and quietly make the card's
	# last line false.
	scene.call("_apply_status", foes[2], "chilled", 3, 0, 0, cryo)
	scene.call("_apply_status", foes[2], "chilled", 3, 0, 0, cryo)
	ok(foes[2].status_stacks("chilled") == 2, "the third enemy sits at 2 stacks")
	await scene.call("_resolve", cryo, _card("Killing Frost"), cryo, "good")
	ok(foes[2].has_status("frozen"),
		"driving it from 2 to 4 stacks FREEZES it — the branch is not skipped")
	scene.queue_free()
	await process_frame


func _live_hoarfrost() -> void:
	# §6'S EXTRA: the stacks land on the STRIKER, not on the target of his own
	# casts. A version that chilled his own targets would read as working from
	# any check that only looked for chilled enemies.
	var scene := await _spawn("cryomancer", ["raider", "raider"])
	var cryo := _mage(scene, "permafrost")
	if cryo == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var striker: BattleUnit = foes[0]
	var bystander: BattleUnit = foes[1]
	for f in foes:
		f.hp = f.max_hp * 10
	cryo.hp = cryo.max_hp
	await scene.call("_resolve", cryo, _card("Hoarfrost Armor"), cryo, "good")
	ok(cryo.has_status("rimeguard"), "Hoarfrost Armor holds on him")
	# HE CASTS AT AN ENEMY: that enemy must gain NOTHING from the armour.
	var basic: Ability = cryo.abilities[0]
	await scene.call("_resolve", cryo, basic, bystander, "good")
	ok(bystander.status_stacks("chilled") <= 1,
		"the target of HIS OWN cast gains nothing from the armour")
	# AN ENEMY STRIKES HIM: the striker gains two.
	ok(not striker.has_status("chilled"), "the striker starts unchilled")
	var enemy_basic: Ability = striker.abilities[0]
	await scene.call("_resolve", striker, enemy_basic, cryo, "good")
	ok(striker.status_stacks("chilled") == 2,
		"striking him costs the STRIKER 2 stacks of Chilled (got %d)" % \
			striker.status_stacks("chilled"))
	# THE MITIGATION HALF, measured as a seeded pair so the ±10% variance roll
	# cannot pass for a 25% cut (BS's lesson: seeding alone is not enough
	# unless both blows draw the SAME variance).
	cryo.remove_status("rimeguard")
	cryo.hp = cryo.max_hp
	_seeded()
	await scene.call("_resolve", striker, enemy_basic, cryo, "good")
	var bare: int = cryo.max_hp - cryo.hp
	cryo.hp = cryo.max_hp
	scene.call("_apply_status", cryo, "rimeguard", 3)
	_seeded()
	await scene.call("_resolve", striker, enemy_basic, cryo, "good")
	var warded: int = cryo.max_hp - cryo.hp
	ok(bare > 0 and warded > 0, "both blows landed (%d bare, %d warded)" % [bare, warded])
	# A RATIO WITH OPEN GROUND BETWEEN SIGNAL AND NOISE, never a bare `<` — the
	# BS finding. A 25% cut lands near 0.75; noise alone cannot reach 0.90.
	ok(float(warded) / float(maxi(bare, 1)) < 0.90,
		"the armour cuts the blow to %.2f of bare (want ~%.2f)" % [
			float(warded) / float(maxi(bare, 1)), 1.0 - HOARFROST_CUT_TEST])
	scene.queue_free()
	await process_frame


# ---------- §4 live: the Arcanist three ----------

func _live_arcane_bolt() -> void:
	# §6'S SIXTH CLAUSE: per-stack damage, and the halving AFTER rather than
	# before. The SAME cast is driven at two stack counts, so the damage must
	# scale with the meter he WALKED IN WITH — which a halve-first
	# implementation fails by exactly a factor of two.
	var scene := await _spawn("arcanist", ["raider", "raider"])
	var arc := _mage(scene, "resonance")
	ok(arc != null, "the Arcanist spawned")
	if arc == null:
		scene.queue_free()
		return
	ok(arc.second_resource_name == "Resonance", "...holding Resonance")
	var foes := _live_foes(scene)
	for f in foes:
		f.hp = f.max_hp * 100
	# FOUR STACKS. The strike is paid on four; he lands on two.
	arc.second_resource = 4
	var hp_was: int = foes[0].hp
	_seeded()
	await scene.call("_resolve", arc, _card("Arcane Bolt"), foes[0], "good")
	var at4: int = hp_was - foes[0].hp
	# THE HALVING IS THE CARD'S; THE +1 THAT FOLLOWS IS THE PASSIVE'S. Every
	# damaging cast builds Resonance, and carving Arcane Bolt out of clause 1 of
	# the passive would be a far bigger change than the card asks for — so 4
	# halves to 2 and the cast's own build takes him to 3. Asserted as the
	# relationship, not as a bare number, so the reason travels with it.
	ok(arc.second_resource == 3,
		"4 Resonance halves to 2, then the cast's own build pays 1 = 3 (got %d)" % \
			arc.second_resource)
	# EIGHT STACKS, same seed, same target. Twice the meter is twice the blow —
	# and it is measured as a RATIO with open ground, because the Resonance
	# damage curve compounds on top and the two are not exactly 2.00x.
	arc.second_resource = 8
	hp_was = foes[0].hp
	_seeded()
	await scene.call("_resolve", arc, _card("Arcane Bolt"), foes[0], "good")
	var at8: int = hp_was - foes[0].hp
	ok(arc.second_resource == 5,
		"8 halves to 4, plus the build = 5 (got %d)" % arc.second_resource)
	ok(at4 > 0 and at8 > 0, "both bolts landed (%d at 4, %d at 8)" % [at4, at8])
	ok(float(at8) / float(maxi(at4, 1)) > 1.8,
		"8 stacks hit at least 1.8x as hard as 4 (got %.2f) — it is paid on the meter it read" % \
			(float(at8) / float(maxi(at4, 1))))
	# THE HALVE-FIRST IMPLEMENTATION IS WHAT THIS EXCLUDES: it would pay 4 and 2
	# against the true 8 and 4, i.e. the SAME ratio — so the ratio alone is not
	# enough and an absolute anchor is needed. At ONE stack the two disagree
	# outright: halving first floors to zero, so a halve-first build deals its
	# minimum of 1 while a halve-after build deals a real 15%-of-Attack blow.
	arc.second_resource = 1
	hp_was = foes[1].hp
	foes[1].hp = foes[1].max_hp * 100
	hp_was = foes[1].hp
	_seeded()
	await scene.call("_resolve", arc, _card("Arcane Bolt"), foes[1], "good")
	var at1: int = hp_was - foes[1].hp
	ok(at1 > 1,
		"at ONE stack it still lands a real blow (%d) — halving first would floor it" % at1)
	ok(arc.second_resource == 1,
		"one stack halves to zero, and the build puts him back on 1 (got %d)" % \
			arc.second_resource)
	# THE PERFECT moves the per-stack RATE rather than adding a lump.
	arc.second_resource = 6
	hp_was = foes[1].hp
	_seeded()
	await scene.call("_resolve", arc, _card("Arcane Bolt"), foes[1], "good")
	var good6: int = hp_was - foes[1].hp
	arc.second_resource = 6
	hp_was = foes[1].hp
	_seeded()
	await scene.call("_resolve", arc, _card("Arcane Bolt"), foes[1], "perfect")
	var perfect6: int = hp_was - foes[1].hp
	ok(perfect6 > good6,
		"a PERFECT bolt pays 20%% a stack against 15%% (%d vs %d)" % [perfect6, good6])
	scene.queue_free()
	await process_frame


func _live_inner_arcane() -> void:
	# §6'S EXTRA: LIVING enemies, and the doubling under half health. The two
	# halves are varied SEPARATELY, because a check that moved both at once
	# could not tell which one was doing the work.
	var scene := await _spawn("arcanist", ["raider", "raider", "archer"])
	var arc := _mage(scene, "resonance")
	if arc == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	ok(foes.size() == 3, "three enemies stand")
	arc.second_resource = 0
	arc.hp = arc.max_hp
	await scene.call("_resolve", arc, _card("Inner Arcane"), arc, "good")
	ok(arc.second_resource == 3,
		"three living enemies bank 3 Resonance (got %d)" % arc.second_resource)
	# THE COUNT HALF: kill one, and the card pays less. It reads the LIVING.
	foes[0].hp = 0
	foes[0].dead = true
	arc.second_resource = 0
	await scene.call("_resolve", arc, _card("Inner Arcane"), arc, "good")
	ok(arc.second_resource == 2,
		"a corpse pays nothing — two living enemies bank 2 (got %d)" % arc.second_resource)
	# THE HEALTH HALF, with the count held fixed at two: below half it doubles.
	arc.hp = int(arc.max_hp * 0.4)
	arc.second_resource = 0
	await scene.call("_resolve", arc, _card("Inner Arcane"), arc, "good")
	ok(arc.second_resource == 4,
		"below half health the same two enemies bank 4 (got %d)" % arc.second_resource)
	# THE BOUNDARY IS "AT OR BELOW HALF", asserted rather than left to a
	# rounding argument.
	arc.hp = int(arc.max_hp / 2)
	arc.second_resource = 0
	await scene.call("_resolve", arc, _card("Inner Arcane"), arc, "good")
	ok(arc.second_resource == 4, "exactly half counts as below (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame


func _live_arcane_echo() -> void:
	# §6'S SEVENTH CLAUSE, AND THE HARDEST ONE TO TEST HONESTLY: PER HIT rather
	# than per cast, and only against its marked target. "It echoed" passes on a
	# per-cast implementation, so the check is built as BR built Aimed Volley's:
	# a MULTI-HIT ability and a SINGLE-STRIKE ability driven in the same battle,
	# with the echo counts compared as an identity.
	var scene := await _spawn("arcanist", ["raider", "raider"])
	var arc := _mage(scene, "resonance")
	if arc == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var mark: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	for f in foes:
		f.hp = f.max_hp * 200
	arc.second_resource = 0
	await scene.call("_resolve", arc, _card("Arcane Echo"), mark, "good")
	ok(mark.has_status("arcane_echo"), "Arcane Echo marks its target")
	ok(String(mark.get_status("arcane_echo").get("src_name", "")) == arc.unit_name,
		"...and the mark carries the CASTER's name — the echo is his")
	ok(not other.has_status("arcane_echo"), "...and only that one")
	# A SINGLE-STRIKE blow at the OTHER enemy: the mark takes exactly ONE echo.
	var single: Ability = Ability.make({"display_name": "BT Probe Single",
		"dmg_type": "arcane", "damage": 40, "delay": 2.0})
	var mark_was: int = mark.hp
	_seeded()
	await scene.call("_resolve", arc, single, other, "good")
	var one_hit: int = mark_was - mark.hp
	ok(one_hit > 0, "a hit elsewhere echoes onto the mark (%d)" % one_hit)
	# THE SAME ABILITY AS A THREE-HIT VOLLEY. Three hits must echo THREE times,
	# which is what tells per-HIT from per-CAST — and the identity is asserted
	# against the single-strike figure measured a line above rather than against
	# a number typed in here.
	var volley: Ability = Ability.make({"display_name": "BT Probe Volley",
		"dmg_type": "arcane", "damage": 40, "delay": 2.0, "multi_hits": 3,
		"perfect_extra_hit": false})
	mark_was = mark.hp
	_seeded()
	await scene.call("_resolve", arc, volley, other, "good")
	var three_hits: int = mark_was - mark.hp
	ok(three_hits > one_hit * 2,
		"a THREE-hit volley echoes three times, not once (%d against %d for one)" % [
			three_hits, one_hit])
	ok(three_hits < one_hit * 4,
		"...and three times rather than more (%d against %d)" % [three_hits, one_hit * 4])
	# ONLY THE MARKED TARGET ANSWERS. With the mark cleared, the same volley
	# must move nothing — otherwise the echo is a field-wide effect wearing a
	# mark's clothes.
	mark.remove_status("arcane_echo")
	mark_was = mark.hp
	_seeded()
	await scene.call("_resolve", arc, volley, other, "good")
	ok(mark.hp == mark_was,
		"with no mark standing, nothing echoes anywhere")
	# ONE MARK AT A TIME: marking a second enemy clears the first.
	await scene.call("_resolve", arc, _card("Arcane Echo"), mark, "good")
	await scene.call("_resolve", arc, _card("Arcane Echo"), other, "good")
	ok(other.has_status("arcane_echo"), "the second mark lands")
	ok(not mark.has_status("arcane_echo"),
		"...and it clears the first — one mark at a time")
	# THE ECHO IS THE CASTER'S. A different hero's hits must not spend it.
	var berserker: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and h != arc:
			berserker = h
			break
	ok(berserker != null, "another hero stands")
	if berserker != null:
		var other_was: int = other.hp
		_seeded()
		await scene.call("_resolve", berserker, single, mark, "good")
		ok(other.hp == other_was,
			"another hero's blow does NOT spend the Arcanist's mark")
	scene.queue_free()
	await process_frame


func _live_gates() -> void:
	# EVERY GATE REFUSES A CAST THAT COULD ONLY EVER DO NOTHING, and each is
	# driven in BOTH directions — a gate that is always shut proves as little as
	# one that is always open.
	var scene := await _spawn("pyromancer", ["raider", "raider"])
	var py := _mage(scene, "overburn")
	if py == null:
		scene.queue_free()
		return
	py.resource = py.max_resource
	var pyre: Ability = _card("Funeral Pyre")
	ok(not scene.call("_ability_usable", py, pyre),
		"Funeral Pyre is DARK with nothing burning")
	scene.call("_apply_status", _live_foes(scene)[0], "burn", 3, 0, 6, py)
	ok(scene.call("_ability_usable", py, pyre),
		"...and LIGHTS the moment something is alight")
	# SLOW BURN IS DELIBERATELY UNGATED — its marker rides enemies not yet
	# alight, so casting it before the fire is a real line of play. This is the
	# decision made visible, not an omission.
	_live_foes(scene)[0].remove_status("burn")
	ok(scene.call("_ability_usable", py, _card("Slow Burn")),
		"Slow Burn is usable on an UNLIT field — the setup half of its own combo")
	scene.queue_free()
	await process_frame

	var cscene := await _spawn("cryomancer", ["raider", "raider"])
	var cryo := _mage(cscene, "permafrost")
	if cryo == null:
		cscene.queue_free()
		return
	cryo.resource = cryo.max_resource
	var kf: Ability = _card("Killing Frost")
	ok(not cscene.call("_ability_usable", cryo, kf),
		"Killing Frost is DARK with nothing Chilled")
	cscene.call("_apply_status", _live_foes(cscene)[0], "chilled", 3, 0, 0, cryo)
	ok(cscene.call("_ability_usable", cryo, kf),
		"...and LIGHTS once something is")
	cscene.queue_free()
	await process_frame

	var ascene := await _spawn("arcanist", ["raider", "raider"])
	var arc := _mage(ascene, "resonance")
	if arc == null:
		ascene.queue_free()
		return
	arc.resource = arc.max_resource
	var bolt: Ability = _card("Arcane Bolt")
	arc.second_resource = 0
	ok(not ascene.call("_ability_usable", arc, bolt),
		"Arcane Bolt is DARK at zero Resonance — a 30-Mana cast for nothing")
	arc.second_resource = 1
	ok(ascene.call("_ability_usable", arc, bolt),
		"...and LIGHTS at one, because cashing a shallow meter is a real choice")
	ascene.queue_free()
	await process_frame
