# test_batch_bw.gd — TRANCHE 2, THE WARRIOR NINE. TRANCHE 2 COMPLETES HERE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bw.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §6 names nine clauses that could silently do nothing or the
# wrong thing. EVERY ONE IS BUILT SO A BROKEN IMPLEMENTATION STILL FAILS, which
# for most of them means the obvious assertion is not the one that discriminates:
#
# · RECKLESS ABANDON scales off the Rage ACTUALLY SPENT. "It applied a buff" is
#   trivially true of a version reading `max_resource`, so the SAME cast is
#   driven at TWO different Rage levels and the two powers asserted DIFFERENT and
#   proportional — a maximum-reading version returns the same number twice and
#   fails an inequality. The zero case is then driven TWICE, once at the gate
#   (refused) and once through a forced resolution (no status at all), because
#   the gate and the arithmetic are two different promises.
# · BERSERK counts HITS, NOT CASTS. "The charges went down" is trivially true, so
#   the discriminating construction is a THREE-HIT ability: it must empty a bank
#   of three in ONE cast and land SIX blows. A cast-counting version leaves two
#   charges standing and lands four, and passes every weaker assertion. The two
#   clocks are then separated by AGEING the statuses past the 3-turn window and
#   asserting the CHARGES SURVIVE while the risk is gone.
# · BLOOD DEBT'S MARK SURVIVES THE BLEEDOUT IT PAYS FOR — the negative control
#   that matters. A one-shot version passes "he healed", so the enemy is bled out
#   TWICE (Slaughterhouse re-seeding the meter, which is the pairing the card
#   exists for) and the SECOND payout is what discriminates. The mark is asserted
#   still standing after the first.
# · SEVER is refused OUTRIGHT in Defensive, and clears its cooldown ONLY against
#   a Broken target. "The cooldown is short" is trivially true, so the same cast
#   is driven against an UNBROKEN target (cooldown must stand) and a BROKEN one
#   (must be gone) — a version clearing unconditionally passes the second alone.
# · BATTLE POISE reduces cooldowns PER PARRY. "A cooldown moved" is trivially
#   true of a per-turn version, so TWO parries are driven inside one turn and the
#   drop asserted at EXACTLY two — and it is asserted to go through
#   `_tick_cooldowns`, BQ's one door, at the source level.
# · FEIGNED GUARD satisfies the gate at `_ability_usable`, NOT merely at
#   resolution. That distinction is the whole card, so it is driven AT THE DOOR:
#   an Aggressive Swordmaster is refused Battle Poise, casts Feigned Guard, and
#   must then be ALLOWED it — while SEVER, which he could cast a moment ago,
#   must now be REFUSED. His actual stance is asserted UNMOVED in the same
#   breath, because a version that simply switched him passes both halves.
# · SHIELD SLAM reads LIVE maximum health. A snapshot passes "it dealt damage",
#   so his maximum is TRIPLED between two casts and the blows asserted as a RATIO
#   with open ground between signal (~3.0) and noise (~1.22) — BS's rule, because
#   the strike block opens with `randf_range(0.9, 1.1)`.
# · VENDETTA locks the targeting and RELEASES IF THE WARDEN FALLS. "It is taunted"
#   is trivially true, so `_choose_enemy_action` — the function that actually
#   narrows an enemy's target list — is called directly and its TARGET asserted
#   by identity, then the Warden is killed and the same call asserted to name
#   somebody else.
# · AEGIS WALL pays on a BLOCK, not on a hit taken. An unconditional version
#   passes "the party healed", so the identical blow is driven twice — once with
#   the block roll forced ON and once forced OFF — and the second must heal
#   NOTHING. The live-maximum half is exact arithmetic and is asserted as an
#   EXACT number, twice, across a changed maximum.
#
# HARNESS NOTE: several checks compare one blow against one blow, and the first
# line of the strike block is `randf_range(0.9, 1.1)`. `crit_bonus = -1.0` at
# spawn kills the crit roll (BQ) and `_seeded()` before a pair makes both draw
# the same variance (BS). Forced determinism, never a retry. BS's other half
# holds too: where a comparison could be swallowed by that variance the check
# AMPLIFIES the term under test and asserts a RATIO with open ground, with the
# SHIPPED magnitude asserted separately off the constant.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on.
const RECKLESS_PCT_PER_10_TEST := 2
# BATCH CQ §3 — FOUR SINCE CN §3'S FOLD. Berserk banked three and a Perfect
# banked a fourth; the bar came off the card, so the fourth is what every cast
# banks (`BERSERK_STRIKES + 1` at the read site).
const BERSERK_STRIKES_TEST := 4
const BERSERK_RISK_PCT_TEST := 30
const BLOOD_DEBT_HEAL_TEST := 0.25
const BATTLE_POISE_TICK_TEST := 1
const SHIELD_SLAM_PCT_TEST := 0.15
# BATCH CQ §3 — THIRTY SINCE CN §3'S FOLD (`VENDETTA_PERFECT_CUT` is what the
# handler reads now; `VENDETTA_CUT` is still declared and is the pre-fold 20).
const VENDETTA_CUT_TEST := 0.30
const AEGIS_WALL_PCT_TEST := 0.08

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# The machine-checkable half of "the batch shipped what it said".
# BATCH DF RE-POINTED THE DELAY COLUMN FOR THE PURE BUFFS IN THIS TABLE.
# CY §1 capped a pure buff at half a swing (`Ability.BUFF_DELAY_CAP` = 1.0) and
# each name changed below is in `Ability.PURE_BUFFS` with `"delay":
# Ability.BUFF_DELAY_CAP` written into its own def — so the old number was a
# pre-CY one and the code was right. The column stays a LITERAL rather than
# reading the constant: a check that reads the number it is checking has
# stopped asking its question.
# Moved here: Berserk, Battle Poise, Aegis Wall.
const NINE := {
	"Reckless Abandon": ["berserker", 0, 1.5, 4, 0],
	"Berserk":          ["berserker", 25, 1.0, 5, 0],
	"Blood Debt":       ["berserker", 20, 2.0, 4, 10],
	"Sever":            ["swordmaster", 25, 2.5, 4, 15],
	"Battle Poise":     ["swordmaster", 25, 1.0, 4, 0],
	"Feigned Guard":    ["swordmaster", 20, 1.0, 3, 0],
	"Shield Slam":      ["warden", 25, 2.5, 3, 40],
	"Vendetta":         ["warden", 20, 1.5, 4, 0],
	"Aegis Wall":       ["warden", 25, 1.0, 5, 0],
}

# The seven that resolve through a `special`, and the TWO that deliberately do
# NOT — see the header in `Classes.draft_ability`. The split is asserted both
# ways round, because either half getting it wrong is silent: a `special` on a
# damage card sends it down `_resolve_special` and it quietly stops critting,
# and a missing one on an effect card makes the cast do nothing at all.
const SPECIALS := {
	"Reckless Abandon": "reckless_abandon", "Berserk": "berserk",
	"Battle Poise": "battle_poise", "Feigned Guard": "feigned_guard",
	"Shield Slam": "shield_slam", "Vendetta": "vendetta",
	"Aegis Wall": "aegis_wall",
}
const NO_SPECIAL := ["Blood Debt", "Sever"]


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
	Profile.save_path = "user://profile_batch_bw_test.json"
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
	await _live_reckless_abandon()
	await _live_berserk()
	await _live_blood_debt()
	await _live_sever()
	await _live_battle_poise()
	await _live_feigned_guard()
	await _live_shield_slam()
	await _live_vendetta()
	await _live_aegis_wall()
	await _live_gates()

	if FileAccess.file_exists("user://profile_batch_bw_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bw_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BW: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- the pools ----------

func _pools() -> void:
	# TRANCHE 2 COMPLETES: ALL TWELVE SPECS AT FIVE. Every earlier tranche test
	# asserted an ASYMMETRY (five here, two there) because the debt was real and
	# had to stay visible in code. There is no asymmetry left to assert, so this
	# suite asserts the FLATNESS instead — and a pool quietly emptying, or a
	# thirteenth appearing, still trips.
	# RE-POINTED BY BATCH CB, AND IT IS THE FOURTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, and now a NEW asymmetry pointing the other way — the
	# three MAGE pools are EIGHT deep and the other nine are five, because CB
	# paid tranche 3's first third. The question is unchanged and is still what
	# tells the two answers apart; what is owed now is the Cleric, Hunter and
	# Warrior thirds of tranche 3, and it has to stay visible in code.
	# RE-POINTED BY BATCH CE, AND IT IS THE FIFTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, and now that asymmetry HALVED
	# — the CLERIC three joined the Mage three at EIGHT when tranche 3's second
	# third landed, so six pools are eight deep and six are five. The question is
	# unchanged and is still what tells the two answers apart; what is owed now
	# is the HUNTER and WARRIOR thirds, and it has to stay visible in code.
	for spec in ["pyromancer", "cryomancer", "arcanist",
			"holy", "inquisitor", "occultist",
			"beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.spec_draft_pool(spec).size() == 8,
			"%s drafts EIGHT (got %d)"
				% [spec, Classes.spec_draft_pool(spec).size()])
	# RE-POINTED BY BATCH CH, AND IT IS THE SIXTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, then that asymmetry HALVED at
	# CE, and now QUARTERED — the HUNTER three joined the Mage and Cleric at
	# EIGHT when tranche 3's third third landed, so NINE pools are eight deep and
	# only the WARRIOR THREE are still at five. The question is unchanged and is
	# still what tells the two answers apart; what is owed is the Warrior third,
	# and it is the LAST of the debt, so it has to stay visible in code.
	# RE-POINTED BY BATCH CI, AND IT IS THE SEVENTH AND LAST INVERSION OF THIS
	# LOOP. It has asserted, in order: each earlier tranche's own asymmetry, then
	# the FLATNESS tranche 2 achieved, then CB's new asymmetry, that asymmetry
	# HALVED at CE, QUARTERED at CH — and now GONE. The WARRIOR three joined the
	# other nine at EIGHT when tranche 3's last third landed, so ALL TWELVE specs
	# draft from eight and the draft is 120 of 120.
	#
	# **THERE IS NO DEBT LEFT TO KEEP VISIBLE, so what this loop guards from here
	# on is the FLATNESS rather than an asymmetry**: a pool that quietly EMPTIES
	# trips, where before it would have read as the old debt coming back. That is
	# the reason it inverts rather than being deleted — the question is still
	# worth asking, only the correct answer moved, and it moved for the last time.
	for spec in ["berserker", "warden", "swordmaster"]:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 8, "%s drafts EIGHT (got %d)" % [spec, pool.size()])
	ok(Classes.SPEC_DRAFT_POOLS.size() == 12, "there are twelve spec pools")
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 96, "the spec pools hold 96 (60 + tranche 3's 36: CB, CE, CH and CI), got %d" % total)
	var draft_total := total
	for cls in Classes.CLASS_DRAFT_POOLS:
		draft_total += Classes.class_draft_pool(cls).size()
	ok(draft_total == 120,
		"the whole draft is 102 of a target 120 (got %d)" % draft_total)
	# TRANCHE 1's ENTRIES ARE STILL THE FIRST TWO OF EACH WARRIOR POOL. A later
	# tranche APPENDS; it does not rewrite. Pinned as literals because a swap of
	# two names would keep every count and change what the draft offers.
	ok(Classes.spec_draft_pool("berserker")[0] == "Blood Offering"
		and Classes.spec_draft_pool("berserker")[1] == "Gut Rip",
		"the Berserker's tranche-1 pair still leads his pool")
	ok(Classes.spec_draft_pool("warden")[0] == "Covering Guard"
		and Classes.spec_draft_pool("warden")[1] == "Eye of the Storm",
		"the Warden's tranche-1 pair still leads his pool")
	ok(Classes.spec_draft_pool("swordmaster")[0] == "Precision Strike"
		and Classes.spec_draft_pool("swordmaster")[1] == "Feint",
		"the Swordmaster's tranche-1 pair still leads his pool")
	# THE MAGE, CLERIC AND HUNTER NINE ARE BYTE-UNTOUCHED, asserted by their
	# leading names rather than by size — a swap would keep the count.
	ok(Classes.spec_draft_pool("pyromancer")[0] == "Cinderfall"
		and Classes.spec_draft_pool("holy")[0] == "Second Wind"
		and Classes.spec_draft_pool("beastmaster")[0] == "Twin Hunt",
		"BT's, BU's and BV's pools still lead with their own tranche-1 entries")
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR/BU/BV negative control.
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
				"%s is not in the %s BOSS pool" % [n, cls])
		for spec in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec].has(n),
				"%s is not in the %s BOSS pool" % [n, spec])
	# AND NO PROTECTED ENABLER LEAKED INTO A DRAFT POOL (BO's own control).
	for spec in Classes.PROTECTED_CORES:
		for en in Classes.PROTECTED_CORES[spec]["enablers"]:
			ok(not Classes.spec_draft_pool(spec).has(en),
				"%s's enabler %s is not draftable" % [spec, en])


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
		# since BO. THREE of the nine strike and carry it in line with their
		# siblings; the six that land no blow carry none, because Break from an
		# ability that never hits is Break from nowhere.
		ok(ab.pressure == NINE[n][4],
			"%s carries %d Break (got %d)" % [n, NINE[n][4], ab.pressure])
		ok(ab.description != "", "%s has a description" % n)
		# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
		# perfect. As of CN that is false by design: 113 of the 211 abilities run no
		# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
		# draft card cannot advertise a bonus nothing can fire. The durable question
		# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
		# — which is strictly stronger than what was here and cannot rot as the
		# criterion catches more cards.
		ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
			"...and states a perfect exactly when it runs a check (%s)" % n)
		# And it RESOLVES through the one door every earned ability uses, or a
		# drafted card would land in `bm_abilities` and never spawn.
		ok(Classes.pool_ability(n) != null,
			"%s resolves through pool_ability" % n)
	# THE SPECIAL SPLIT, BOTH WAYS ROUND. `_resolve` sends ANY ability holding a
	# `special` down `_resolve_special`, which hand-rolls the blow and loses the
	# attack pipeline — crits, armor, resists, Break, the parry roll and every
	# talent rider that reads a strike. BLOOD DEBT and SEVER are ordinary
	# attacks and NEED that pipeline (Sever's whole clause reads `broken`, which
	# its own Break has to be able to produce), so a `special` creeping onto
	# either would break them silently.
	for n in SPECIALS:
		ok(Classes.draft_ability(n).special == SPECIALS[n],
			"%s resolves through the `%s` special" % [n, SPECIALS[n]])
	for n in NO_SPECIAL:
		ok(Classes.draft_ability(n).special == "",
			"%s carries NO special — it must ride the ordinary attack pipeline" % n)
		ok(Classes.draft_ability(n).damage > 0,
			"%s is an attack and carries an Attack percentage" % n)
	# SHIELD SLAM IS THE ONE `special` THAT DEALS DAMAGE, and it carries NO
	# Attack percentage on purpose — its damage is a share of his MAXIMUM
	# HEALTH, computed inside the special. A `damage` value here would be a
	# second, silent damage term.
	ok(Classes.draft_ability("Shield Slam").damage == 0,
		"Shield Slam carries no Attack percentage — it reads maximum health")
	for n in ["Reckless Abandon", "Berserk", "Battle Poise", "Feigned Guard",
			"Vendetta", "Aegis Wall"]:
		ok(Classes.draft_ability(n).damage == 0,
			"%s is a pure effect and carries no Attack percentage" % n)
	# NONE OF THE NINE IS AN AREA ATTACK. It matters for Berserk specifically:
	# the doubling expands `strike_targets` on the area branch, so an `aoe` flag
	# arriving on one of these later is exactly the case that needs re-reading.
	for n in NINE:
		ok(not Classes.draft_ability(n).aoe, "%s is not an area attack" % n)
	# NONE IS ALLY-FACING, which is what keeps all nine out of the ALLY branch
	# of the player's picker and of the bot's pool.
	for n in NINE:
		ok(Classes.draft_ability(n).target != Ability.Target.ALLY,
			"%s is not an ally-facing card" % n)
	# THE TEXT CARRIES THE CLAUSES A PLAYER WOULD OTHERWISE GUESS WRONG.
	var berserk_desc: String = Classes.draft_ability("Berserk").description.to_lower()
	ok(berserk_desc.contains("wait until"),
		"Berserk's text says the strikes wait until spent — they are charges")
	ok(berserk_desc.contains("30%"),
		"and it states the damage it costs him, because that is the OTHER clock")
	ok(Classes.draft_ability("Blood Debt").description.to_lower().contains(
		"survives"),
		"Blood Debt's text says the mark SURVIVES the bleedout")
	ok(Classes.draft_ability("Sever").description.to_lower().contains("requires"),
		"Sever's text states its stance requirement")
	ok(Classes.draft_ability("Battle Poise").description.to_lower().contains(
		"requires"),
		"Battle Poise's text states its stance requirement")
	ok(Classes.draft_ability("Feigned Guard").description.to_lower().contains(
		"does not switch"),
		"Feigned Guard's text says outright that it does NOT switch his guard")
	ok(Classes.draft_ability("Shield Slam").description.to_lower().contains("live"),
		"Shield Slam's text says it reads his maximum health LIVE")
	ok(Classes.draft_ability("Aegis Wall").description.to_lower().contains("block"),
		"Aegis Wall's text says it pays on a BLOCK")
	ok(Classes.draft_ability("Aegis Wall").description.to_lower().contains(
		"gets through"),
		"and that a blow which gets through pays nothing")


func _synergy_rule() -> void:
	# BT §1's STANDING RULE, MADE MECHANICAL AND CARRIED FORWARD: from tranche 2
	# on, every ability NAMES what it builds with. A card nobody plans around is
	# a card that fills a slot, and the cheapest way for that to creep back is
	# for the next author to skip the line.
	#
	# ANCHORED PER-ABILITY RATHER THAN PER-BLOCK, and that is a departure from
	# BT/BU/BV with a reason: this tranche's nine are INTERLEAVED with BP's six
	# (each spec's tranche-2 entries sit directly under its tranche-1 ones), so
	# there is no single contiguous BW region to slice.
	var src := FileAccess.get_file_as_string("res://scripts/classes.gd")
	for n in NINE:
		var at := src.find('"%s":\n' % n)
		if at <= 0:
			at = src.find('\t\t"%s":' % n)
		ok(at > 0, "%s is defined in classes.gd" % n)
		if at <= 0:
			continue
		# The 2600 characters above the entry are its comment.
		var lead := src.substr(maxi(at - 2600, 0), mini(at, 2600))
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
	# AND AGAINST EVERY OPENING KIT, which pools do not contain.
	for spec in Classes.SPEC_IDS:
		for ab in Classes.spec_abilities(spec):
			ok(not NINE.has(ab.display_name),
				"%s's kit does not already hold %s" % [spec, ab.display_name])
	# THE COLLISION THIS BATCH FOUND AND RESOLVED, PINNED IN BOTH DIRECTIONS.
	# `wd_grudge` is a WARDEN THREAT-lane talent (+25% damage against enemies his
	# taunt binds) and the Rune of Grudges pays into the same term — the same
	# spec, the same lane, one row apart from where the card would have sat. The
	# TALENT keeps the name (its id is save-migrated and its ranks travel with
	# it); the UNSHIPPED CARD moved to VENDETTA. Both halves are asserted,
	# because either one silently reverting is how the collision comes back.
	var wd_tree: Array = Talents.LANE_TREES.get("warden", [])
	var grudge_node := {}
	for node in wd_tree:
		if String(node.get("id", "")) == "wd_grudge":
			grudge_node = node
	ok(not grudge_node.is_empty(), "the wd_grudge talent still exists")
	ok(String(grudge_node.get("name", "")) == "Grudge",
		"and it KEEPS the name Grudge — the talent is the one with saved ranks")
	ok(Classes.draft_ability("Grudge") == null,
		"no ABILITY is named Grudge — the card is Vendetta")
	ok(Classes.pool_ability("Grudge") == null,
		"and nothing resolves the name Grudge as an ability")
	ok(Classes.draft_ability("Vendetta") != null, "Vendetta is the card")
	# THE OTHER EIGHT ARE CLEAN AGAINST EVERY TALENT NODE IN THE GAME. A node's
	# name is not an ability name and nothing resolves it, so this is the LABEL
	# sweep BR §1 asks for — it reports rather than breaks, and it is what
	# caught Grudge.
	var node_names: Dictionary = {}
	for spec in Classes.SPEC_IDS:
		for node in Talents.LANE_TREES.get(spec, []):
			node_names[String(node.get("name", ""))] = spec
	for n in NINE:
		ok(not node_names.has(n),
			"%s collides with no talent node (it would sit in %s)" % [
				n, node_names.get(n, "")])
	# AND AGAINST EVERY LIVE STATUS LABEL, so two chips can never read the same
	# word (BT's Hoarfrost rule).
	var battle_src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for n in NINE:
		ok(not battle_src.contains('["%s", "' % n)
			or n in ["Berserk", "Battle Poise", "Blood Debt", "Vendetta",
				"Aegis Wall", "Reckless Abandon", "Feigned Guard"],
			"%s's status label, if it has one, is its own card's" % n)


func _status_registry() -> void:
	# EIGHT NEW STATUSES. Two of them sit on an ENEMY and six on a hero, and the
	# split decides which list each belongs to.
	#
	# THE TWO MARKS ARE IN NEITHER `DEBUFF_IDS` NOR NOTHING — they are in
	# `DISPEL_NEVER`, and both halves are load-bearing. Out of DEBUFF_IDS
	# because a battle-long entry there reads as 999 turns remaining, so a
	# mender's longest-first Cleansing Rite would take it EVERY time (`feinted`'s
	# reason). In DISPEL_NEVER because `_dispellable_buffs` is DERIVED from that
	# same absence — so without the second listing a Mage's Dispel would strip
	# the party's own marks FOR the enemy carrying them (BU's trap, arriving
	# through the mark door).
	for id in ["blood_debt", "vendetta"]:
		ok(not BattleUnit.DEBUFF_IDS.has(id),
			"`%s` is a MARK and is not in DEBUFF_IDS" % id)
	var battle_src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var dn_at := battle_src.find("const DISPEL_NEVER")
	ok(dn_at > 0, "DISPEL_NEVER exists")
	# RE-POINTED BY BATCH CH, AND THE CHECK IS STRICTLY BETTER FOR IT. This read
	# a FIXED 1400-BYTE WINDOW from `const DISPEL_NEVER`, which is an accident of
	# how long the comments inside that block happened to be rather than the
	# question — CH appended `reacquire` with a reason above it and pushed
	# `vendetta` off the end, failing against CORRECT code. It slices to the
	# const's own CLOSING BRACKET now, so the window is the list itself and no
	# future comment can move it. Same shape as BW's own tail-versus-run repair
	# one section down: an assertion keyed on POSITION rather than on membership
	# stops asking its question the moment the block is edited.
	var dn_end := battle_src.find("]", dn_at)
	var dn_body := battle_src.substr(dn_at, maxi(dn_end - dn_at, 0))
	for id in ["blood_debt", "vendetta"]:
		ok(dn_body.contains('"%s"' % id),
			"`%s` is in DISPEL_NEVER — a Dispel must not strip the party's own mark"
				% id)
	# THE SIX HERO-SIDE STATUSES ARE NOT DEBUFFS EITHER — including
	# `berserk_risk`, which is a DRAWBACK he chose and the payoff half of its own
	# card. Listing it would let a mender cleanse the clause that drives him into
	# Blood Frenzy's band, i.e. cleanse the ability.
	for id in ["reckless_abandon", "berserk", "berserk_risk", "battle_poise",
			"feigned_guard", "aegis_wall"]:
		ok(not BattleUnit.DEBUFF_IDS.has(id),
			"`%s` is not in DEBUFF_IDS" % id)
	# AND ALL EIGHT ARE REGISTERED, or `_apply_status` and the chips have no
	# label to read and the effect lands invisibly.
	for id in ["reckless_abandon", "berserk", "berserk_risk", "blood_debt",
			"battle_poise", "feigned_guard", "vendetta", "aegis_wall"]:
		ok(battle_src.contains('"%s": [' % id), "`%s` has a STATUS_INFO row" % id)


func _unit_state() -> void:
	# ONE FIELD FOR NINE ABILITIES — BQ's standard held: an effect with a
	# DURATION is a status, which expires by itself and cannot leak past a
	# battle. The one exception is a CHARGE COUNT, which must not tick away.
	var u := BattleUnit.new()
	ok(u.get("berserk_strikes") != null, "the Berserk charge counter exists")
	ok(u.berserk_strikes == 0, "a fresh unit has banked no doubled strikes")
	# AND IT IS NOT FOLDED INTO EITHER PARRY BANK. One counter holding two rules
	# is how a rule goes missing (BP's own note about Feint vs Waiting Guard).
	ok(u.get("feint_guards") != null and u.get("banked_guards") != null,
		"the two parry banks still exist separately")
	u.free()


func _source_rules() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# COMMENTS ARE STRIPPED FIRST (BS's rule): this batch's own comments name the
	# things it forbids on purpose, and a bare `contains` would fail against
	# working code and invite a later author to "fix" it by deleting the line
	# that explains the decision.
	var code := _strip_comments(src)
	# BATTLE POISE GOES THROUGH `_tick_cooldowns`, BQ's ONE implementation of
	# cooldown reduction. A second walk of the same dictionary is exactly what BQ
	# extracted four copies of.
	var at_bp := code.find('has_status("battle_poise")')
	ok(at_bp > 0, "the Battle Poise parry hook exists")
	var bp_body := code.substr(at_bp, 420)
	ok(bp_body.length() > 200, "and the slice around it is a real region")
	ok(bp_body.contains("_tick_cooldowns("),
		"Battle Poise reduces cooldowns through the ONE shared door")
	# FEIGNED GUARD SATISFIES THE GATE AT `_ability_usable`. That is the site
	# that makes the card true, and it is a different site from resolution — so
	# the gate is asserted to read `_eff_stance` rather than `stance`.
	# RE-POINTED BY BATCH CI, AND THE QUESTION IS BYTE-FOR-BYTE THE SAME — only
	# the fragment moved (the AZ Follow-Through / AL Ghillie Suit precedent).
	# CI's FORMLESS counts as BOTH guards at once, which `_eff_stance` cannot
	# express because it returns ONE guard, so both gates now ask
	# `_stance_satisfies` — the one answer to "does this unit count as standing
	# in guard X". That helper reads `_eff_stance` underneath, so what this check
	# protects (the gate reads the EFFECTIVE guard and not the raw one, and
	# Feigned Guard therefore genuinely opens the door) is unchanged.
	var at_gate := code.find('ab.display_name == "Sever" and not _stance_satisfies')
	ok(at_gate > 0, "Sever's gate reads the EFFECTIVE stance, not the raw one")
	var at_bpgate := code.find('ab.special == "battle_poise" and not _stance_satisfies')
	ok(at_bpgate > 0,
		"Battle Poise's gate reads the EFFECTIVE stance, not the raw one")
	# AND `_stance_satisfies` STILL GOES THROUGH `_eff_stance`, which is what
	# keeps Feigned Guard working underneath Formless rather than being shadowed
	# by it. Asserted, because a later batch could make Formless the only reader.
	var at_sat := code.find("func _stance_satisfies(")
	ok(at_sat > 0 and code.substr(at_sat, 240).contains("_eff_stance("),
		"...and `_stance_satisfies` still resolves through `_eff_stance`")
	# BOTH GATES SIT INSIDE `_ability_usable`, not somewhere that only the bot or
	# only the button reads. One door, three affordances.
	var at_usable := code.find("func _ability_usable(")
	var at_next := code.find("\nfunc ", at_usable + 10)
	ok(at_usable > 0 and at_gate > at_usable and at_gate < at_next,
		"Sever's gate is inside `_ability_usable`")
	ok(at_usable > 0 and at_bpgate > at_usable and at_bpgate < at_next,
		"Battle Poise's gate is inside `_ability_usable`")
	# FEIGNED GUARD MUST NOT SWITCH THE STANCE. A reader that flips plus a window
	# that does not is the whole distinction between the two card types, and the
	# switch is exactly what a later author would add "for consistency".
	#
	# EVERY MATCH-CASE ANCHOR BELOW IS TAKEN AT ITS OWN INDENT, and that is BU's
	# lesson learned the same way it was learned there — TWICE IN THIS SUITE'S
	# OWN FIRST DRAFT. A bare `"feigned_guard":` finds the STATUS_INFO row
	# hundreds of lines above the match case, and the "it does not switch the
	# stance" check then passes against a colour table: A SLICE THAT QUIETLY
	# COVERS THE WRONG REGION IS A CHECK THAT HAS STOPPED ASKING ITS QUESTION,
	# and it fails OPEN. Every one of these carries a length assertion beside it
	# for the same reason.
	var at_fg := code.find('\t\t"feigned_guard":')
	ok(at_fg > 0, "the Feigned Guard special exists at its own indent")
	var fg_body := code.substr(at_fg, 900)
	ok(fg_body.contains("feigned_guard"),
		"and the slice really covers the Feigned Guard case")
	ok(not fg_body.contains("_swordmaster_switch"),
		"Feigned Guard does NOT call the stance pivot")
	# AND THE TWO READERS STILL DO — the pivot is what makes them readers.
	var at_ps := code.find('\t\t"precision_strike":')
	var at_ft := code.find('\t\t"feint":')
	ok(at_ps > 0 and code.substr(at_ps, 3000).contains("_swordmaster_switch"),
		"Precision Strike still flips the stance")
	ok(at_ft > 0 and code.substr(at_ft, 3000).contains("_swordmaster_switch"),
		"Feint still flips the stance")
	# `_eff_stance` IS SCOPED TO ABILITIES. The Swordmaster's PASSIVE must keep
	# reading his real guard, or a Feigned Guard would silently hand an
	# Aggressive build Defensive mitigation and delete the card's own synergy
	# line. Asserted at the passive's own read site.
	var at_seasoned := code.find('strike_target.passive_id == "seasoned"')
	ok(at_seasoned > 0, "the Seasoned Fighter mitigation site exists")
	# RE-POINTED BY BATCH CI: THE SLICE WAS A FIXED 260-BYTE WINDOW, which is an
	# accident of how long that branch happens to be — CI's Formless and
	# Discipline terms pushed the stance read off the end and it failed against
	# CORRECT code. That is the same fault CH repaired in this file's
	# `DISPEL_NEVER` check, so it takes the same repair: the slice ends at the
	# branch's OWN last statement rather than at a byte count.
	var sf_end := code.find("_prev(strike_target, pv_was - raw)", at_seasoned)
	ok(sf_end > at_seasoned, "the mitigation branch has a readable end")
	var sf_body := code.substr(at_seasoned, sf_end - at_seasoned)
	ok(sf_body.contains("strike_target.stance"),
		"the passive reads his REAL stance, not the feigned one")
	ok(not sf_body.contains("_eff_stance"),
		"and it is deliberately NOT routed through `_eff_stance`")
	# BLOOD DEBT'S PAYOUT DOES NOT REMOVE ITS OWN MARK. This is the negative
	# control at the source level, beside the live one: a `remove_status` here
	# leaves the card working, logging, and worth a quarter of what it says.
	var at_bd := code.find('victim.has_status("blood_debt")')
	ok(at_bd > 0, "the Blood Debt payout hook exists")
	var bd_body := code.substr(at_bd, 900)
	ok(bd_body.length() > 400, "and the slice around it is a real region")
	ok(not bd_body.contains('remove_status("blood_debt")'),
		"the payout does NOT consume the mark — that is the whole card")
	ok(bd_body.contains("src_name"),
		"and it reads whose debt it is, so a second Berserker cannot collect")
	# AEGIS WALL SITS INSIDE THE BLOCK BRANCH. Being there is what makes "pays on
	# a block, not on a hit taken" true rather than a condition somebody has to
	# remember — and it is the BT/BV one-tab indentation fault's natural home.
	var at_aw := code.find('has_status("aegis_wall")')
	ok(at_aw > 0, "the Aegis Wall block hook exists")
	var at_blocksrc := code.find('if block_source != "":')
	var at_parry := code.find("var parry_source :=")
	ok(at_blocksrc > 0 and at_aw > at_blocksrc and at_aw < at_parry,
		"Aegis Wall pays INSIDE the block branch, above the parry roll")
	# VENDETTA REUSES THE TAUNT SYSTEM. A parallel targeting rule is the thing
	# §4 named, and `mocked` at -1 turns is the shape The Whole Room installs.
	var at_vd := code.find('\t\t"vendetta":')
	ok(at_vd > 0, "the Vendetta special exists at its own indent")
	var vd_body := code.substr(at_vd, 1600)
	ok(vd_body.contains('"mocked", -1'),
		"Vendetta taunts through the EXISTING system, battle-long")
	ok(not vd_body.contains("func "),
		"and the slice stops inside the case rather than sweeping the next function")
	# BERSERK COUNTS HITS. The gate is the hit loop, not the cast — asserted by
	# position, because a version that doubled `total_hits` outside the loop
	# would still read as working on a single-target ability.
	var at_bk := code.find("attacker.berserk_strikes > 0")
	ok(at_bk > 0, "the Berserk doubling hook exists")
	var bk_body := code.substr(at_bk, 900)
	ok(bk_body.contains("mini(total_hits, attacker.berserk_strikes)"),
		"it spends one charge PER HIT, capped by what he is holding")
	ok(bk_body.contains("bk_expanded"),
		"and it grows the target list with the count, so an area cast cannot run off its end")


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
	# RE-POINTED BY BATCH CN, to the durable shape Batch CK gave this same gate in
	# test_batch_br. It read `master.contains("Batch C?")`, a stamp assertion that
	# has to be hand-bumped every batch — **A CHECK THAT MUST BE EDITED EVERY BATCH
	# TO KEEP PASSING IS A CHECK THAT WILL BE RED MOST BATCHES**, which stops it
	# carrying information. It asks the durable version now: the document carries a
	# stamp, and that stamp is not older than the batch this suite belongs to. No
	# bump is ever owed again. (Two-letter batch codes sort lexically; a
	# three-letter code will need one more line.)
	var stamp_at := master.find("Last updated:")
	ok(stamp_at >= 0, "master.html carries a Last-updated stamp")
	var stamp := master.substr(stamp_at, 60)
	var code_at := stamp.find("(Batch ")
	var stamped := stamp.substr(code_at + 7, 2) if code_at >= 0 else ""
	ok(stamped >= "BW",
		"...and master.html is stamped no older than this suite's own batch (reads '%s')" % stamped)
	for n in NINE:
		ok(master.contains(n), "master.html lists %s" % n)
	ok(master.contains("120 of"), "master.html states the new draft count")
	ok(master.contains("Builds with"),
		"and the draft tables still carry the synergy line a player reads")
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch BW — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch BW")` would have gone on PASSING against the live file,
	# because later entries name the batch in their own prose — A CHECK THAT PASSES
	# WITHOUT ITS SUBJECT BEING IN THE FILE AT ALL. That is BZ's failure in
	# test_batch_bb and CD's in test_batch_bo, repaired here before it could bite.
	#
	# CD's pattern: anchor on the `<h2>` HEADING, and read the archive's path out of
	# the LIVE changelog's own header rather than hardcoding it, so the NEXT cut
	# moves this with it. See test_batch_bn for the full reasoning and the one
	# consequence — this suite now depends on a file that is NOT IN VERSION CONTROL
	# and FAILS LOUDLY without it, which is correct.
	var live_log := FileAccess.get_file_as_string("res://docs/changelog.html")
	var arch_mark := live_log.find("/changelog-archive.html</code>")
	ok(arch_mark > 0, "the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var chlog := FileAccess.get_file_as_string(arch_path)
	ok(chlog.length() > 100000,
		"the archive opens at %s (%d chars)" % [arch_path, chlog.length()])
	ok(not live_log.contains("<h2>2026-08-14 &mdash; Batch BW"),
		"CX moved this batch's entry OUT of the live changelog")
	ok(chlog.contains("<h2>2026-08-14 &mdash; Batch BW"),
		"...and the archive carries the Batch BW entry")
	# THE GLOSSARY OWES THE STANCE GATE AN ENTRY: "requires Aggressive" is a rule
	# the game has never had before, and a player meeting a greyed-out card needs
	# to know why.
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(gloss.to_lower().contains("stance-gated")
		or gloss.to_lower().contains("stance gate"),
		"the glossary explains a stance-gated ability")


# ---------- live harness ----------

func _spawn(warrior_spec: String, lineup: Array, learned := {}) -> Node:
	# `_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL SceneTreeTimer.
	# `fast` scales those timers and NOTHING the battle computes.
	return await Fixture.spawn(self, [warrior_spec, "arcanist", "holy", "sharpshooter"],
		{"enemies": lineup, "talents": {0: learned.duplicate()}, "frames": 90, "fast": true,
		"deterministic": true, "crit": -1.0})


func _warrior(scene: Node, passive: String) -> BattleUnit:
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


# ---------- §2 live: the Berserker three ----------

func _live_reckless_abandon() -> void:
	# §6's FIRST CLAUSE. THE DISCRIMINATING CONSTRUCTION IS TWO DIFFERENT RAGE
	# LEVELS: "a buff landed" is trivially true of a version reading his MAXIMUM,
	# and so is "his bar emptied". Only an inequality between two powers tells a
	# spend-reading implementation from a maximum-reading one, because the
	# maximum does not change between the two casts.
	var scene := await _spawn("berserker", ["raider", "raider"])
	var bz := _warrior(scene, "bloodrage")
	if bz == null:
		scene.queue_free()
		return
	bz.max_resource = 100
	bz.resource = 100
	await scene.call("_resolve", bz, _card("Reckless Abandon"), bz, "good")
	ok(bz.resource == 0, "Reckless Abandon spends ALL his Rage (got %d)" % bz.resource)
	var full_pct: int = bz.status_power("reckless_abandon")
	ok(full_pct == 100 / 10 * RECKLESS_PCT_PER_10_TEST,
		"a full 100-Rage bar buys +%d%% (got %d)" % [
			100 / 10 * RECKLESS_PCT_PER_10_TEST, full_pct])
	# HALF THE BAR, HALF THE BUFF. Same maximum, so a maximum-reading version
	# returns the same number and fails here and nowhere else.
	bz.remove_status("reckless_abandon")
	bz.resource = 50
	bz.cooldowns.clear()
	await scene.call("_resolve", bz, _card("Reckless Abandon"), bz, "good")
	var half_pct: int = bz.status_power("reckless_abandon")
	ok(half_pct == 50 / 10 * RECKLESS_PCT_PER_10_TEST,
		"a HALF bar buys +%d%% (got %d)" % [
			50 / 10 * RECKLESS_PCT_PER_10_TEST, half_pct])
	ok(half_pct < full_pct,
		"and it is strictly less than a full bar — it scales off what was SPENT")
	# THE BUFF IS REAL DAMAGE, not just a chip. Amplified and asserted as a ratio
	# with open ground (BS's rule) — the strike block opens with a +/-10% roll.
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.hp = 100000
	foe.max_hp = 100000
	var strike: Ability = bz.abilities[0]
	bz.remove_status("reckless_abandon")
	bz.resource = bz.max_resource
	bz.cooldowns.clear()
	_seeded()
	var before_plain: int = foe.hp
	await scene.call("_resolve", bz, strike, foe, "good")
	var plain: int = before_plain - foe.hp
	scene.call("_apply_status", bz, "reckless_abandon", 3, 200)
	bz.resource = bz.max_resource
	bz.cooldowns.clear()
	_seeded()
	var before_buffed: int = foe.hp
	await scene.call("_resolve", bz, strike, foe, "good")
	var buffed: int = before_buffed - foe.hp
	ok(plain > 0 and buffed > plain * 1.8,
		"the buff is read at the damage site (+200%% amplified: %d against %d)" % [
			buffed, plain])
	# AND THE ZERO CASE PAYS NOTHING. Driven through a FORCED resolution rather
	# than the gate, because the gate and the arithmetic are two different
	# promises and this suite drives both (the gate is in `_live_gates`).
	bz.remove_status("reckless_abandon")
	bz.resource = 0
	bz.cooldowns.clear()
	await scene.call("_resolve", bz, _card("Reckless Abandon"), bz, "good")
	ok(not bz.has_status("reckless_abandon"),
		"at ZERO Rage it applies no buff at all — it pays for what was spent")
	# AND THE SAME BELOW ONE FULL STEP. The resolution stays safe under the gate
	# because the two are different promises: a forced cast must not leave a
	# +0% chip advertising a window it never opened.
	bz.resource = 5
	bz.cooldowns.clear()
	await scene.call("_resolve", bz, _card("Reckless Abandon"), bz, "good")
	ok(not bz.has_status("reckless_abandon"),
		"and no buff below one full step either")
	ok(bz.resource == 0, "though it still spends what he had (got %d)" % bz.resource)
	scene.queue_free()
	await process_frame


func _live_berserk() -> void:
	# §6's SECOND CLAUSE, AND THE DISCRIMINATING CASE IS A MULTI-HIT ABILITY.
	# Per BR §1 the charges count HITS: Hack and Slash strikes three times, so
	# ONE cast must empty a bank of three and land SIX blows. A cast-counting
	# version leaves two charges standing and lands four — and it passes every
	# assertion of the form "the charges went down" and "it hit more than once".
	var scene := await _spawn("berserker", ["raider", "raider"])
	var bz := _warrior(scene, "bloodrage")
	if bz == null:
		scene.queue_free()
		return
	bz.resource = bz.max_resource
	await scene.call("_resolve", bz, _card("Berserk"), bz, "good")
	ok(bz.berserk_strikes == BERSERK_STRIKES_TEST,
		"Berserk banks %d strikes (got %d)" % [
			BERSERK_STRIKES_TEST, bz.berserk_strikes])
	ok(bz.has_status("berserk"),
		"and the bank wears a chip, so the player can see what is owed")
	ok(bz.status_power("berserk") == BERSERK_STRIKES_TEST,
		"the chip's power IS the count — one place writes it")
	ok(bz.has_status("berserk_risk")
		and bz.status_power("berserk_risk") == BERSERK_RISK_PCT_TEST,
		"and the 30%% risk is a SEPARATE status (got %d)" % \
			bz.status_power("berserk_risk"))
	# THE HIT COUNT. Hack and Slash is `multi_hits: 3`, so one cast spends THREE
	# charges and lands six.
	#
	# BATCH CQ §3 — IT NO LONGER EMPTIES THE BANK, and that is the fold showing
	# through rather than a fault: four are banked now, so a three-hit cast
	# leaves ONE standing and the chip stays up. The question worth asking is
	# still "one charge per hit", so it is asked that way.
	var hack := _find(bz, "Hack and Slash")
	ok(hack != null, "the Berserker holds Hack and Slash to drive the count")
	if hack != null:
		var foe: BattleUnit = _live_foes(scene)[0]
		foe.hp = 100000
		foe.max_hp = 100000
		foe.bleed_buildup = 0
		bz.resource = bz.max_resource
		bz.cooldowns.clear()
		await scene.call("_resolve", bz, hack, foe, "good")
		ok(bz.berserk_strikes == BERSERK_STRIKES_TEST - 3,
			"a THREE-HIT ability spends exactly three charges, %d -> %d (got %d)" % [
				BERSERK_STRIKES_TEST, BERSERK_STRIKES_TEST - 3, bz.berserk_strikes])
		ok(bz.has_status("berserk"),
			"and the chip stands while a charge is left")
	# THE TWO CLOCKS ARE SEPARATE. Aged past the 3-turn window, the RISK is gone
	# and any unspent CHARGES stand — a single-status version fails one of these
	# whichever way it was built.
	bz.resource = bz.max_resource
	bz.cooldowns.clear()
	await scene.call("_resolve", bz, _card("Berserk"), bz, "good")
	# BATCH CQ §3 — THE BANK IS READ RATHER THAN PREDICTED. `berserk_strikes`
	# ADDS, and the three-hit cast above now leaves one charge standing, so a
	# fresh Berserk banks four ON TOP of it. Pinning the literal made this
	# assertion depend on what the block before it happened to leave behind;
	# the question here is only whether the charges SURVIVE the ticks, so it
	# compares against the count taken the moment before ticking.
	var banked: int = bz.berserk_strikes
	for _i in 4:
		bz.tick_statuses()
	ok(not bz.has_status("berserk_risk"),
		"the 30% risk expires on its own 3-turn clock")
	ok(bz.berserk_strikes == banked and banked > 0 and bz.has_status("berserk"),
		"while the CHARGES survive the same ticks — they wait until spent (%d, still %d)"
			% [banked, bz.berserk_strikes])
	# THE RISK IS REAL DAMAGE TAKEN. Amplified, ratio with open ground.
	var raider: BattleUnit = _live_foes(scene)[0]
	var swing: Ability = raider.abilities[0]
	bz.max_hp = 100000
	bz.hp = 100000
	bz.remove_status("berserk_risk")
	_seeded()
	var before_plain: int = bz.hp
	await scene.call("_resolve", raider, swing, bz, "good")
	var plain: int = before_plain - bz.hp
	scene.call("_apply_status", bz, "berserk_risk", 3, 200)
	_seeded()
	var before_risk: int = bz.hp
	await scene.call("_resolve", raider, swing, bz, "good")
	var risked: int = before_risk - bz.hp
	ok(plain > 0 and risked > plain * 1.8,
		"the risk is read at the damage-taken site (+200%% amplified: %d against %d)"
			% [risked, plain])
	scene.queue_free()
	await process_frame


func _live_blood_debt() -> void:
	# §6's THIRD CLAUSE AND THE NEGATIVE CONTROL THAT MATTERS. "He healed" is
	# trivially true of a one-shot mark, so the enemy is bled out TWICE — which
	# is only possible because SLAUGHTERHOUSE re-seeds the meter to 50 rather
	# than 0, the exact pairing the card is written for. The SECOND payout is
	# what discriminates.
	var scene := await _spawn("berserker", ["raider", "raider"])
	var bz := _warrior(scene, "bloodrage")
	if bz == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.hp = 100000
	foe.max_hp = 100000
	foe.bleed_buildup = 0
	bz.max_hp = 200
	bz.hp = 40
	bz.resource = bz.max_resource
	await scene.call("_resolve", bz, _card("Blood Debt"), foe, "good")
	ok(foe.has_status("blood_debt"), "Blood Debt marks the enemy")
	ok(foe.status_power("blood_debt")
		== int(round(BLOOD_DEBT_HEAL_TEST * 100.0)),
		"and the mark carries the share as percentage POINTS (got %d)"
			% foe.status_power("blood_debt"))
	var debt_st: Dictionary = foe.get_status("blood_debt")
	ok(String(debt_st.get("src_name", "")) == bz.unit_name,
		"the mark names WHOSE debt it is")
	ok(int(debt_st.get("turns", 0)) < 0,
		"and it is BATTLE-LONG (turns %d)" % int(debt_st.get("turns", 0)))
	# FIRST BLEEDOUT. Slaughterhouse is armed so the meter falls to 50, not 0.
	bz.slaughterhouse = 50
	bz.hp = 40
	scene.call("_add_bleed_with_burst", foe, 100)
	var after_first: int = bz.hp
	ok(after_first > 40,
		"the first bleedout pays the debt (%d -> %d)" % [40, after_first])
	ok(after_first - 40 == maxi(int(round(200 * BLOOD_DEBT_HEAL_TEST)), 1),
		"and it pays exactly %d%% of his maximum (got %d)" % [
			int(round(BLOOD_DEBT_HEAL_TEST * 100.0)), after_first - 40])
	# THE CLAUSE THE WHOLE CARD RESTS ON.
	ok(foe.has_status("blood_debt"),
		"THE MARK SURVIVES THE BLEEDOUT IT PAID FOR")
	ok(foe.bleed_buildup == 50,
		"and Slaughterhouse left the wound at 50 (got %d)" % foe.bleed_buildup)
	# SECOND BLEEDOUT, off the re-seeded meter. A one-shot mark pays nothing
	# here and passes every check above it.
	bz.hp = 40
	scene.call("_add_bleed_with_burst", foe, 50)
	var after_second: int = bz.hp
	ok(after_second - 40 == maxi(int(round(200 * BLOOD_DEBT_HEAL_TEST)), 1),
		"a SLAUGHTERHOUSE re-bleed pays the SAME mark again (got %d)"
			% (after_second - 40))
	# AND IT IS HIS DEBT ALONE. A mark stamped with somebody else's name pays
	# nobody — the control for a second Berserker collecting on the first's.
	bz.hp = 40
	foe.get_status("blood_debt")["src_name"] = "Somebody Else"
	scene.call("_add_bleed_with_burst", foe, 50)
	ok(bz.hp == 40,
		"a mark that is not his pays him nothing (got %d)" % bz.hp)
	scene.queue_free()
	await process_frame


# ---------- §3 live: the Swordmaster three ----------

func _live_sever() -> void:
	# §6's FOURTH CLAUSE, IN BOTH DIRECTIONS. A gate stuck shut is as silent as
	# one stuck open, and the cooldown clause needs the UNBROKEN case beside the
	# Broken one — a version that cleared unconditionally passes the second alone.
	var scene := await _spawn("swordmaster", ["raider", "raider"])
	var sm := _warrior(scene, "seasoned")
	if sm == null:
		scene.queue_free()
		return
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	sm.stance = "defensive"
	ok(not bool(scene.call("_ability_usable", sm, _card("Sever"))),
		"Sever is REFUSED OUTRIGHT in the Defensive guard")
	sm.stance = "aggressive"
	ok(bool(scene.call("_ability_usable", sm, _card("Sever"))),
		"and allowed in the Aggressive one")
	# UNBROKEN: the cooldown stands.
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.hp = 100000
	foe.max_hp = 100000
	foe.broken = false
	foe.pressure = 0
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	await scene.call("_resolve", sm, _card("Sever"), foe, "good")
	ok(int(sm.cooldowns.get("Sever", 0)) > 0,
		"against an UNBROKEN target the cooldown stands (got %d)"
			% int(sm.cooldowns.get("Sever", 0)))
	# BROKEN: it is cleared outright.
	foe.broken = true
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	await scene.call("_resolve", sm, _card("Sever"), foe, "good")
	ok(int(sm.cooldowns.get("Sever", 0)) == 0,
		"against a BROKEN one it is cleared (got %d)"
			% int(sm.cooldowns.get("Sever", 0)))
	ok(bool(scene.call("_ability_usable", sm, _card("Sever"))),
		"so he can swing through the window again immediately")
	# AND IT ONLY CLEARS ITS OWN. A cleared dictionary would pass the check
	# above; this proves the erase is targeted.
	foe.broken = true
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	sm.cooldowns["Guard Change"] = 3
	await scene.call("_resolve", sm, _card("Sever"), foe, "good")
	ok(int(sm.cooldowns.get("Guard Change", 0)) == 3,
		"and it clears ONLY its own cooldown, not every cooldown he holds")
	scene.queue_free()
	await process_frame


func _live_battle_poise() -> void:
	# §6's FIFTH CLAUSE. "A cooldown moved" is trivially true of a per-TURN
	# version, so TWO parries are driven inside one turn and the drop asserted at
	# EXACTLY two.
	var scene := await _spawn("swordmaster", ["raider", "raider"])
	var sm := _warrior(scene, "seasoned")
	if sm == null:
		scene.queue_free()
		return
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	sm.stance = "aggressive"
	ok(not bool(scene.call("_ability_usable", sm, _card("Battle Poise"))),
		"Battle Poise is REFUSED OUTRIGHT in the Aggressive guard")
	sm.stance = "defensive"
	ok(bool(scene.call("_ability_usable", sm, _card("Battle Poise"))),
		"and allowed in the Defensive one")
	await scene.call("_resolve", sm, _card("Battle Poise"), sm, "good")
	ok(sm.has_status("battle_poise"), "the window opens")
	# TWO PARRIES, ONE TURN. `parry_chance = 1.0` makes the roll a certainty and
	# a RAIDER is melee, which is what the parry branch requires.
	sm.parry_chance = 1.0
	sm.max_hp = 100000
	sm.hp = 100000
	sm.cooldowns["Overpower"] = 6
	sm.cooldowns["Pommel Strike"] = 6
	var raider: BattleUnit = _live_foes(scene)[0]
	var swing: Ability = raider.abilities[0]
	await scene.call("_resolve", raider, swing, sm, "good")
	var after_one: int = int(sm.cooldowns.get("Overpower", 0))
	await scene.call("_resolve", raider, swing, sm, "good")
	var after_two: int = int(sm.cooldowns.get("Overpower", 0))
	ok(after_one == 6 - BATTLE_POISE_TICK_TEST,
		"one parry takes ONE turn off (6 -> %d)" % after_one)
	ok(after_two == 6 - 2 * BATTLE_POISE_TICK_TEST,
		"TWO parries in one turn take TWO — it pays PER PARRY (6 -> %d)"
			% after_two)
	ok(int(sm.cooldowns.get("Pommel Strike", 0)) == 6 - 2 * BATTLE_POISE_TICK_TEST,
		"and it reaches EVERY cooldown he holds, not just one")
	# IT SKIPS ITS OWN. A defensive window that shortens its own recast is a
	# different and unbounded card.
	sm.cooldowns["Battle Poise"] = 5
	await scene.call("_resolve", raider, swing, sm, "good")
	ok(int(sm.cooldowns.get("Battle Poise", 0)) == 5,
		"Battle Poise does NOT shorten its own recast (got %d)"
			% int(sm.cooldowns.get("Battle Poise", 0)))
	# NEGATIVE CONTROL: with the window gone, a parry costs nothing.
	sm.remove_status("battle_poise")
	sm.cooldowns["Overpower"] = 6
	await scene.call("_resolve", raider, swing, sm, "good")
	ok(int(sm.cooldowns.get("Overpower", 0)) == 6,
		"and with the window closed a parry moves nothing (got %d)"
			% int(sm.cooldowns.get("Overpower", 0)))
	scene.queue_free()
	await process_frame


func _live_feigned_guard() -> void:
	# §6's SIXTH CLAUSE, AND IT IS DRIVEN AT THE DOOR. The card is worth a slot
	# only if it satisfies the GATE — changing the branch taken at resolution is
	# a different, much smaller ability, and the two look identical from outside.
	var scene := await _spawn("swordmaster", ["raider", "raider"])
	var sm := _warrior(scene, "seasoned")
	if sm == null:
		scene.queue_free()
		return
	sm.stance = "aggressive"
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	ok(not bool(scene.call("_ability_usable", sm, _card("Battle Poise"))),
		"an Aggressive Swordmaster cannot cast Battle Poise")
	ok(bool(scene.call("_ability_usable", sm, _card("Sever"))),
		"and CAN cast Sever")
	await scene.call("_resolve", sm, _card("Feigned Guard"), sm, "good")
	ok(sm.has_status("feigned_guard"), "the feigned guard is up")
	# THE CLAUSE THAT MAKES THE CARD.
	ok(sm.stance == "aggressive",
		"IT DOES NOT SWITCH HIS STANCE (got %s)" % sm.stance)
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	ok(bool(scene.call("_ability_usable", sm, _card("Battle Poise"))),
		"AND HE CAN NOW CAST BATTLE POISE — the gate is satisfied, not branched")
	# THE FLIP IS SYMMETRIC, which is what proves it is a stance swap in the
	# ability's eyes rather than a blanket permission: Sever must now be REFUSED.
	ok(not bool(scene.call("_ability_usable", sm, _card("Sever"))),
		"and Sever is now REFUSED — the feign is a swap, not a free pass")
	# HIS PASSIVE STILL READS THE REAL GUARD. Amplified ratio: Seasoned Fighter
	# is x1.10 taken in Aggressive against x0.85 in Defensive, so a version that
	# routed the passive through `_eff_stance` reads ~23% lower here.
	sm.max_hp = 100000
	sm.hp = 100000
	var raider: BattleUnit = _live_foes(scene)[0]
	var swing: Ability = raider.abilities[0]
	_seeded()
	var before_feign: int = sm.hp
	await scene.call("_resolve", raider, swing, sm, "good")
	var under_feign: int = before_feign - sm.hp
	sm.remove_status("feigned_guard")
	_seeded()
	var before_plain: int = sm.hp
	await scene.call("_resolve", raider, swing, sm, "good")
	var plain: int = before_plain - sm.hp
	ok(plain > 0 and absi(under_feign - plain) <= maxi(int(plain * 0.05), 1),
		"his PASSIVE still reads the guard he is standing in (%d against %d)" % [
			under_feign, plain])
	# AND THE WINDOW EXPIRES ON ITS OWN CLOCK.
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	await scene.call("_resolve", sm, _card("Feigned Guard"), sm, "good")
	for _i in 3:
		sm.tick_statuses()
	ok(not sm.has_status("feigned_guard"), "the feign lapses after 2 turns")
	sm.resource = sm.max_resource
	sm.cooldowns.clear()
	ok(not bool(scene.call("_ability_usable", sm, _card("Battle Poise"))),
		"and Battle Poise is refused again once it has")
	scene.queue_free()
	await process_frame


# ---------- §4 live: the Warden three ----------

func _live_shield_slam() -> void:
	# §6's SEVENTH CLAUSE. A cast-time snapshot passes "it dealt damage", so the
	# maximum is TRIPLED between two casts and the blows compared as a ratio with
	# open ground — the strike block's +/-10% roll cannot reach 3.0 from 1.0.
	var scene := await _spawn("warden", ["raider", "raider"])
	var wd := _warrior(scene, "heavy_plating")
	if wd == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.hp = 10000000
	foe.max_hp = 10000000
	foe.armor = 0.0
	wd.max_hp = 200
	wd.hp = 200
	wd.resource = wd.max_resource
	_seeded()
	var before_small: int = foe.hp
	await scene.call("_resolve", wd, _card("Shield Slam"), foe, "good")
	var small: int = before_small - foe.hp
	ok(small > 0, "Shield Slam lands a blow (%d)" % small)
	# HEAVY PLATING GROWS HIS MAXIMUM MID-BATTLE — Tenacity adds +15 a block —
	# so this is the state the card has to keep pace with.
	wd.max_hp = 600
	wd.hp = 600
	wd.resource = wd.max_resource
	wd.cooldowns.clear()
	_seeded()
	var before_big: int = foe.hp
	await scene.call("_resolve", wd, _card("Shield Slam"), foe, "good")
	var big: int = before_big - foe.hp
	ok(big > small * 2.4,
		"TRIPLING his maximum triples the blow — it reads it LIVE (%d against %d)"
			% [big, small])
	# AND THE MAGNITUDE IS THE SHIPPED ONE, asserted separately from the ratio
	# so a re-price has to move a number a human can find.
	var expected := int(round(600 * SHIELD_SLAM_PCT_TEST))
	ok(big >= int(expected * 0.85) and big <= int(expected * 1.15),
		"the blow is %d%% of his maximum (%d, expected about %d)" % [
			int(round(SHIELD_SLAM_PCT_TEST * 100.0)), big, expected])
	# THE BREAK IS THE BRIEF'S OWN 40 AND IT REACHES THE METER.
	foe.pressure = 0
	foe.broken = false
	wd.resource = wd.max_resource
	wd.cooldowns.clear()
	await scene.call("_resolve", wd, _card("Shield Slam"), foe, "good")
	ok(foe.pressure > 0,
		"and its 40 Break reaches the meter (got %d)" % foe.pressure)
	scene.queue_free()
	await process_frame


func _live_vendetta() -> void:
	# §6's EIGHTH CLAUSE. "It is taunted" is trivially true, so the function that
	# actually narrows an enemy's target list is called DIRECTLY and its choice
	# asserted by identity — and then the Warden is killed and the same call
	# asserted to name somebody else.
	var scene := await _spawn("warden", ["raider", "raider"])
	var wd := _warrior(scene, "heavy_plating")
	if wd == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	wd.resource = wd.max_resource
	await scene.call("_resolve", wd, _card("Vendetta"), foe, "good")
	ok(foe.has_status("mocked"), "Vendetta taunts through the EXISTING system")
	var mocked_st: Dictionary = foe.get_status("mocked")
	ok(int(mocked_st.get("turns", 0)) < 0,
		"and the lock is battle-long (turns %d)" % int(mocked_st.get("turns", 0)))
	ok(foe.status_power("mocked") == scene.get("heroes").find(wd),
		"stamped with the Warden's own index")
	ok(foe.has_status("vendetta")
		and foe.status_power("vendetta") == int(round(VENDETTA_CUT_TEST * 100.0)),
		"and the duel's %d%% cut rides its own mark (got %d)" % [
			int(round(VENDETTA_CUT_TEST * 100.0)), foe.status_power("vendetta")])
	# THE LOCK, READ OFF THE FUNCTION THAT ENFORCES IT.
	var pick: Dictionary = scene.call("_choose_enemy_action", foe)
	ok(not pick.is_empty() and pick.get("target") == wd,
		"the enemy can choose NOBODY but the Warden")
	# THE CUT IS REAL. Amplified, ratio with open ground.
	wd.max_hp = 100000
	wd.hp = 100000
	var swing: Ability = foe.abilities[0]
	foe.remove_status("vendetta")
	_seeded()
	var before_plain: int = wd.hp
	await scene.call("_resolve", foe, swing, wd, "good")
	var plain: int = before_plain - wd.hp
	scene.call("_apply_status", foe, "vendetta", -1, 90, 0, wd)
	_seeded()
	var before_cut: int = wd.hp
	await scene.call("_resolve", foe, swing, wd, "good")
	var cut: int = before_cut - wd.hp
	ok(plain > 0 and cut < plain * 0.35,
		"the duel's cut is read at the damage site (-90%% amplified: %d against %d)"
			% [cut, plain])
	# AND A SECOND WARDEN'S DUEL SHELTERS NOBODY ELSE: the mark names its owner,
	# so an ally struck by the same enemy pays full price.
	var ally: BattleUnit = scene.get("heroes")[1]
	ally.max_hp = 100000
	ally.hp = 100000
	_seeded()
	var before_ally: int = ally.hp
	await scene.call("_resolve", foe, swing, ally, "good")
	var ally_hit: int = before_ally - ally.hp
	ok(ally_hit > plain * 0.7,
		"and it shelters the WARDEN alone, not whoever the enemy hits (%d)"
			% ally_hit)
	# THE RELEASE. `_choose_enemy_action` re-resolves the taunter live, so a
	# fallen Warden stops holding anything — asserted through the same call.
	wd.hp = 0
	wd.dead = true
	var pick_after: Dictionary = scene.call("_choose_enemy_action", foe)
	ok(pick_after.is_empty() or pick_after.get("target") != wd,
		"THE LOCK RELEASES IF THE WARDEN FALLS — it names somebody else")
	scene.queue_free()
	await process_frame


func _live_aegis_wall() -> void:
	# §6's NINTH CLAUSE. An unconditional version passes "the party healed", so
	# the IDENTICAL blow is driven twice — block forced ON, then forced OFF — and
	# the second must heal NOTHING. The arithmetic carries no RNG, so both the
	# share and the live maximum are asserted as EXACT numbers.
	var scene := await _spawn("warden", ["raider", "raider"])
	var wd := _warrior(scene, "heavy_plating")
	if wd == null:
		scene.queue_free()
		return
	wd.resource = wd.max_resource
	wd.max_hp = 500
	wd.hp = 500
	await scene.call("_resolve", wd, _card("Aegis Wall"), wd, "good")
	ok(wd.has_status("aegis_wall"), "the wall goes up")
	# THE PARTY IS WOUNDED SO A HEAL HAS SOMEWHERE TO LAND — a full bar reads
	# exactly like a heal that never fired.
	var heroes: Array = scene.get("heroes")
	for h in heroes:
		h.max_hp = maxi(h.max_hp, 500)
		h.hp = 100
	wd.max_hp = 500
	wd.hp = 100
	var raider: BattleUnit = _live_foes(scene)[0]
	var swing: Ability = raider.abilities[0]
	# BLOCK FORCED ON. Base Block, deliberately — the card says "every attack you
	# block", so a version gated on Heavy Plating's slice alone fails here.
	wd.block_chance = 1.0
	var before: Array = []
	for h in heroes:
		before.append(h.hp)
	await scene.call("_resolve", raider, swing, wd, "good")
	var expected := maxi(int(round(500 * AEGIS_WALL_PCT_TEST)), 1)
	# EVERY ALLY IS HEALED — that is the "all allies" half, and it is asserted as
	# a count rather than a sweep of exact numbers, because AN EXACT SWEEP WOULD
	# BE WRONG AND WOULD READ AS A BUG: the CLERIC CLASS PASSIVE is +15% healing
	# RECEIVED, so she correctly banks 46 where the others bank 40. The card
	# SENDS 8% of his maximum; what each ally RECEIVES is the recipient's own
	# business, and folding the two together here would pin a rule this batch
	# never wrote.
	var healed_n := 0
	for i in heroes.size():
		if heroes[i].hp > before[i]:
			healed_n += 1
	ok(healed_n == heroes.size(),
		"a BLOCK heals EVERY ally (%d of %d)" % [healed_n, heroes.size()])
	# AND THE AMOUNT SENT IS EXACT, read off the two heroes carrying no healing
	# multiplier — the Warden himself and the Arcanist.
	var wd_i: int = heroes.find(wd)
	ok(wd.hp == before[wd_i] + expected,
		"and it sends exactly %d (%d%% of his 500 maximum) — got %d on the Warden"
			% [expected, int(round(AEGIS_WALL_PCT_TEST * 100.0)),
				wd.hp - before[wd_i]])
	ok(heroes[1].hp == before[1] + expected,
		"and the same %d to an ally with no healing multiplier (got %d)" % [
			expected, heroes[1].hp - before[1]])
	# BLOCK FORCED OFF — the same blow, landing. This is the clause.
	wd.block_chance = 0.0
	wd.hp = 100
	for h in heroes:
		h.hp = 100
	var before_hit: Array = []
	for h in heroes:
		before_hit.append(h.hp)
	await scene.call("_resolve", raider, swing, wd, "good")
	var paid_on_hit := false
	for i in heroes.size():
		if heroes[i] != wd and heroes[i].hp > before_hit[i]:
			paid_on_hit = true
	ok(not paid_on_hit,
		"AND A HIT THAT GETS THROUGH PAYS NOTHING — it reads BLOCKS, not damage")
	# THE LIVE MAXIMUM. Tenacity grows it +15 a block, so the heal must grow with
	# it — a cast-time snapshot pays the old number forever.
	wd.block_chance = 1.0
	wd.max_hp = 1000
	wd.hp = 100
	for h in heroes:
		h.max_hp = maxi(h.max_hp, 1000)
		h.hp = 100
	var before_big: int = heroes[1].hp
	await scene.call("_resolve", raider, swing, wd, "good")
	var big_heal: int = heroes[1].hp - before_big
	ok(big_heal == maxi(int(round(1000 * AEGIS_WALL_PCT_TEST)), 1),
		"DOUBLING his maximum doubles the heal — it reads it LIVE (got %d)"
			% big_heal)
	# NEGATIVE CONTROL: with the wall down, a block pays nothing.
	wd.remove_status("aegis_wall")
	for h in heroes:
		h.hp = 100
	var before_nowall: int = heroes[1].hp
	await scene.call("_resolve", raider, swing, wd, "good")
	ok(heroes[1].hp == before_nowall,
		"and with the wall down a block pays nothing at all")
	scene.queue_free()
	await process_frame


func _live_gates() -> void:
	# EACH GATE REFUSES A CAST THAT COULD ONLY EVER DO NOTHING (BO's rule), and
	# each is driven in BOTH directions — a gate stuck shut is as silent as one
	# stuck open, and only the pair tells them apart.
	var scene := await _spawn("berserker", ["raider", "raider"])
	var bz := _warrior(scene, "bloodrage")
	if bz == null:
		scene.queue_free()
		return
	bz.cooldowns.clear()
	bz.resource = 0
	ok(not bool(scene.call("_ability_usable", bz, _card("Reckless Abandon"))),
		"Reckless Abandon is refused with an empty bar")
	# THE GATE IS ONE FULL STEP, NOT ZERO, and the 5-Rage case is the one that
	# discriminates: it pays per full 10, so under a step the cast spends a turn
	# and a 4-turn cooldown to buy +0%. A gate written literally at zero passes
	# the two checks around this one and lets that through.
	bz.resource = 5
	ok(not bool(scene.call("_ability_usable", bz, _card("Reckless Abandon"))),
		"and refused at 5 Rage too — under one step it can only ever buy zero")
	bz.resource = 10
	ok(bool(scene.call("_ability_usable", bz, _card("Reckless Abandon"))),
		"and opens at one full step")
	# THE OTHER TWO BERSERKER CARDS ARE DELIBERATELY UNGATED — both do their
	# work whatever the board looks like, so refusing either would refuse a
	# real play.
	bz.resource = bz.max_resource
	ok(bool(scene.call("_ability_usable", bz, _card("Berserk"))),
		"Berserk is NOT gated — banking strikes is always a real cast")
	ok(bool(scene.call("_ability_usable", bz, _card("Blood Debt"))),
		"Blood Debt is NOT gated — it is an attack before it is a mark")
	scene.queue_free()
	await process_frame

	# THE WARDEN'S THREE ARE UNGATED TOO, and the reason is worth pinning: none
	# of them reads an accumulation, so none can be cast into a state where it
	# does nothing.
	var scene2 := await _spawn("warden", ["raider", "raider"])
	var wd := _warrior(scene2, "heavy_plating")
	if wd == null:
		scene2.queue_free()
		return
	wd.resource = wd.max_resource
	wd.cooldowns.clear()
	for n in ["Shield Slam", "Vendetta", "Aegis Wall"]:
		ok(bool(scene2.call("_ability_usable", wd, _card(n))),
			"%s is NOT gated" % n)
	scene2.queue_free()
	await process_frame


func _find(u: BattleUnit, n: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == n:
			return ab
	return null
