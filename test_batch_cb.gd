# test_batch_cb.gd — TRANCHE 3, THE MAGE NINE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_cb.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability or its damage by hand.
#
# WHAT IT PROTECTS. §7 named eight clauses that could silently do nothing or the
# wrong thing, plus Threshold's refusal. EVERY ONE IS DRIVEN LIVE, and for most
# of them THE OBVIOUS ASSERTION IS NOT THE DISCRIMINATING ONE — a broken
# implementation would pass it while doing something adjacent and wrong:
#
# · FIREDRAW takes UP TO 4 from each OTHER enemy. "The target's Burn got
#   deeper" is trivially true of any transfer, and — the trap that cost this
#   suite its first draft — THE TRANSFER IS CONSERVATIVE, so a version that
#   wrongly drew from the target too lands on the SAME total and passes every
#   obvious check. The field is therefore built with a source holding LESS than
#   the cap (2) and one holding MORE (10), which tells "up to 4" from both "4 or
#   nothing" and "all of it"; and the target-exclusion is driven UNDER AN
#   EMBERKEEP WINDOW, where the doubling breaks the conservation and the two
#   readings diverge loudly (22 against 26).
# · PYRE WAKE produces one fire and one hit PER TURN CONSUMED. "It did damage"
#   is trivially true of a per-cast implementation, so it is driven on a
#   SINGLE-ENEMY field where every scattered fire lands back on the same body:
#   five turns consumed must leave exactly five turns of fresh Burn standing,
#   where a per-cast version leaves one.
# · EMBERKEEP doubles at APPLICATION. "The burn is longer" would be true of a
#   retroactive version too, so a fire is laid BEFORE the window and asserted
#   UNCHANGED in the same check as one laid inside it, and a SECOND applier's
#   fire is asserted undoubled — which is what tells "his Burn" from "all Burn".
# · DEEP WINTER reads HALF the held enemy's stacks. "Everyone got Chilled" is
#   trivially true of a copy-all version, so the hold is built at FOUR and the
#   field asserted at TWO, and the no-hold case is asserted to change nothing.
# · COLD IRON doubles against a Frozen target AND DOES NOT RELEASE THE HOLD.
#   The second half is the negative control that matters, and it is driven
#   beside ICE LANCE in the same battle — the Lance releases, this must not.
# · FROSTBIND mirrors at 40% WITHOUT THE MIRROR MIRRORING. "The partner took
#   damage" is trivially true of a recursing version, so the FIRST victim's own
#   loss is asserted EXACT: a mirror that mirrored back would add 16% to it.
#   The pair is also driven to the freeze threshold together, which is where
#   BN's guard has to hold.
# · RESONANT FIELD reads his bonus LIVE. "The ally hit harder" is trivially true
#   of a cast-time snapshot, so the SAME ally's blow is measured at two
#   different Arcanist stack counts with the field opened ONCE — a snapshot
#   returns the same number twice.
# · UNMAKING ignores resistance AND armor. Either alone would pass a check that
#   only gave the enemy one of them, so the discriminating case is an enemy
#   carrying BOTH, measured against a naked control taking the identical blow.
#
# HARNESS NOTE THAT WILL SAVE THE NEXT AUTHOR A BISECT: several checks compare
# ONE BLOW AGAINST ONE BLOW, and the first line of the strike block is
# `randf_range(0.9, 1.1)`. BQ killed the CRIT roll for this class of check and
# BS found the VARIANCE roll is the half that survived it. Both are handled:
# `crit_bonus = -1.0` at spawn, and `_seeded()` immediately before each blow of
# a pair so the two draw the SAME variance. Forced determinism, never a retry
# (the AK/AL/AR discipline).
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on rather than
# hiding it inside a magic number.
const FROSTBIND_SHARE_TEST := 0.40
const THRESHOLD_STACKS_TEST := 15
const EMBERKEEP_MULT_TEST := 2

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# This table is the machine-checkable half of "the batch shipped what it said".
const NINE := {
	"Firedraw":       ["pyromancer", 25, 2.5, 4, 0],
	"Pyre Wake":      ["pyromancer", 25, 2.5, 4, 0],
	"Emberkeep":      ["pyromancer", 20, 1.5, 4, 0],
	"Deep Winter":    ["cryomancer", 25, 2.5, 4, 0],
	"Cold Iron":      ["cryomancer", 20, 2.0, 3, 6],
	"Frostbind":      ["cryomancer", 25, 2.5, 4, 0],
	"Resonant Field": ["arcanist", 25, 2.0, 4, 0],
	"Threshold":      ["arcanist", 20, 1.5, 5, 0],
	"Unmaking":       ["arcanist", 30, 3.0, 5, 8],
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
	Profile.save_path = "user://profile_batch_cb_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_definitions()
	_synergy_rule()
	_names()
	_backdraft_collision()
	_status_lists()
	_one_refund_door()
	_two_bypass_doors()
	_docs()

	await _live_firedraw()
	await _live_pyre_wake()
	await _live_emberkeep()
	await _live_deep_winter()
	await _live_cold_iron()
	await _live_frostbind()
	await _live_resonant_field()
	await _live_threshold()
	await _live_unmaking()

	if FileAccess.file_exists("user://profile_batch_cb_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_cb_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH CB: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- the pools ----------

func _pools() -> void:
	# THE ASYMMETRY IS BACK AND IT POINTS THE OTHER WAY. BW's suites assert the
	# FLATNESS tranche 2 achieved; this batch breaks it deliberately by paying
	# tranche 3's first third, so what has to stay visible in code is which
	# thirds are still owed.
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
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 8, "%s drafts EIGHT (got %d)" % [spec, pool.size()])
	# RE-POINTED BY BATCH CH, AND IT IS THE SIXTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, then that asymmetry HALVED at
	# CE, and now QUARTERED — the HUNTER three joined the Mage and Cleric at
	# EIGHT when tranche 3's third third landed, so NINE pools are eight deep and
	# only the WARRIOR THREE are still at five. The question is unchanged and is
	# still what tells the two answers apart; what is owed is the Warrior third,
	# and it is the LAST of the debt, so it has to stay visible in code.
	for spec in ["berserker", "warden", "swordmaster"]:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s is still at FIVE — its third of tranche 3 is owed" % spec)
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 87, "the spec pools hold 78 (60 + this batch's nine + CE's Cleric nine), got %d"
		% total)
	var draft_total := total
	for cls in Classes.CLASS_DRAFT_POOLS:
		draft_total += Classes.class_draft_pool(cls).size()
	ok(draft_total == 111, "the draft holds 111 of a target 120 (got %d)"
		% draft_total)
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR/BT negative control.
	for cls in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls).size() == 6,
			"%s's class pool is still SIX" % cls)
		for n in NINE:
			ok(not Classes.class_draft_pool(cls).has(n),
				"%s is a SPEC card and is not in %s's class pool" % [n, cls])
	# CLASS_POOLS AND SPEC_POOLS FEED THE BOSS PICK and must not move (BO's
	# rule, kept by BQ, BR, BT, BU, BV and BW).
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
		# BREAK DAMAGE ASSIGNED DELIBERATELY, NOT BY OMISSION — the standing rule
		# since BO. TWO of the nine are attacks and carry it; the other seven
		# land no blow, so Break would be Break from nowhere. PYRE WAKE is the
		# interesting one: it DOES deal damage and still carries none, because
		# its hit count is unbounded (a twelve-turn stack is twelve hits) and a
		# per-hit Break term on an uncapped count is the squaring trap.
		ok(ab.pressure == NINE[n][4],
			"%s carries %d Break (got %d)" % [n, NINE[n][4], ab.pressure])
		ok(ab.description != "", "%s has a description" % n)
		ok(ab.perfect_text != "", "%s states a perfect" % n)
		ok(Classes.pool_ability(n) != null,
			"%s resolves through pool_ability" % n)
	# THE TWO THAT ARE ORDINARY ATTACKS CARRY NO `special`, WHICH IS THE WHOLE
	# REASON THEY GET THE STRIKE PIPELINE (crit, variance, resists, armor, Break,
	# the parry roll and the compounding Resonance curve). ASSERTED BOTH WAYS,
	# because either half getting it wrong is silent (BV's rule).
	for n in ["Cold Iron", "Unmaking"]:
		ok(Classes.draft_ability(n).special == "",
			"%s is an ordinary attack, not a special" % n)
		ok(Classes.draft_ability(n).damage > 0, "%s deals damage" % n)
	for n in ["Firedraw", "Pyre Wake", "Emberkeep", "Deep Winter", "Frostbind",
			"Resonant Field", "Threshold"]:
		ok(Classes.draft_ability(n).special != "",
			"%s resolves through a special" % n)
	# FROSTBIND IS THE ONLY ONE THAT NAMES TWO ENEMIES, and it uses the EXISTING
	# picker rather than a new one — §3's conditional was false and this is the
	# assertion that records it.
	ok(Classes.draft_ability("Frostbind").choose_two,
		"Frostbind uses the existing two-target picker (choose_two)")
	for n in NINE:
		if n == "Frostbind":
			continue
		ok(not Classes.draft_ability(n).choose_two,
			"%s names at most one enemy" % n)
	# None of the nine is an area attack, so none auto-targets the field.
	for n in NINE:
		ok(not Classes.draft_ability(n).aoe, "%s is not an area attack" % n)


func _synergy_rule() -> void:
	# BT's STANDING RULE, MADE MECHANICAL AND STILL BINDING: every ability from
	# tranche 2 onward NAMES what it builds with. A card nobody plans around is
	# a card that fills a slot, and the cheapest way for that to creep back is
	# for the next author to skip the line.
	var src := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var start := src.find("BATCH CB: TRANCHE 3, THE MAGE NINE")
	ok(start > 0, "the CB block is findable in classes.gd")
	if start < 0:
		return
	var block := src.substr(start, src.find("BATCH BU: TRANCHE 2", start) - start)
	ok(block.length() > 2000, "the CB block is a real region (%d chars)"
		% block.length())
	# ANCHORED PER ABILITY rather than per block: BW's entries are interleaved
	# with BP's and there is no single contiguous region to slice, so the habit
	# of anchoring on the CARD is the durable one.
	for n in NINE:
		var at := block.find('"%s":' % n)
		ok(at > 0, "%s's definition is inside the CB block" % n)
		if at <= 0:
			continue
		# The comment above it is the ability's own, bounded by the previous
		# definition — so a shared header cannot satisfy all nine at once.
		var prev := 0
		for m in NINE:
			if m == n:
				continue
			var pat := block.find('"%s":' % m)
			if pat >= 0 and pat < at and pat > prev:
				prev = pat
		var comment := block.substr(prev, at - prev)
		ok(comment.contains("AXIS"), "%s carries an AXIS line" % n)
		ok(comment.contains("SYNERGY"), "%s carries a SYNERGY line" % n)


func _names() -> void:
	# BR §1'S SWEEP, SHIPPED AS A TEST. An ABILITY-vs-ABILITY duplicate is a REAL
	# BREAK because `pool_ability` is keyed on `display_name`; everything else is
	# a label collision that ships flagged.
	var seen := {}
	for spec in Classes.SPEC_DRAFT_POOLS:
		for n in Classes.spec_draft_pool(spec):
			ok(not seen.has(n), "%s appears in exactly one spec draft pool" % n)
			seen[n] = spec
	for cls in Classes.CLASS_DRAFT_POOLS:
		for n in Classes.class_draft_pool(cls):
			ok(not seen.has(n), "%s is not in a spec pool as well" % n)
			seen[n] = cls
	# Against every TALENT-GRANTED ability in the game, which is the half that
	# actually bit this batch — see `_backdraft_collision` below.
	for spec in Classes.SPEC_IDS:
		var tree: Array = Talents.LANE_TREES.get(spec, [])
		for node in tree:
			var payload: Dictionary = node.get("payload", {})
			for key in ["new_ability", "grant_ability"]:
				if not payload.has(key):
					continue
				var granted = payload[key]
				var gname: String = granted if granted is String \
					else String(granted.get("display_name", ""))
				if gname == "":
					continue
				for n in NINE:
					ok(gname != n,
						"%s does not collide with the %s talent grant '%s'" % [
							n, spec, gname])
	# And against every RUNE name in the pool — the last third of BR §1's
	# sweep, read off the live data rather than from a transcription here.
	for rid in Runes.ids():
		var rname: String = String(Runes.config(rid).get("name", ""))
		for n in NINE:
			ok(rname != n, "%s is not also a rune name" % n)


func _backdraft_collision() -> void:
	# §1 ASKED FOR THE BACKDRAFT NAME TO BE CONFIRMED FREE AND IT IS NOT. This
	# check is the finding in assertion form, so a later batch cannot quietly
	# re-create the collision by "restoring" the brief's name.
	#
	# `py_melt` (Pyromancer, Kindling row 4) both CARRIES the name Backdraft and
	# GRANTS an ability whose `display_name` is Backdraft. BS renamed the INFERNO
	# row-5 node to Backblast to dodge exactly this and left the Kindling node
	# standing.
	var found_node := false
	for node in Talents.LANE_TREES.get("pyromancer", []):
		if String(node.get("id", "")) == "py_melt":
			found_node = true
			ok(String(node.get("name", "")) == "Backdraft",
				"py_melt is still NAMED Backdraft (it is: %s)"
					% String(node.get("name", "")))
			var payload: Dictionary = node.get("payload", {})
			var granted: Dictionary = payload.get("new_ability", {})
			ok(String(granted.get("display_name", "")) == "Backdraft",
				"py_melt still GRANTS an ability named Backdraft")
	ok(found_node, "the py_melt node exists to collide with")
	# So the name resolves to the TALENT's ability, and no draft card may answer
	# to it. Both halves, because either alone would pass on the wrong code.
	ok(Classes.draft_ability("Backdraft") == null,
		"no DRAFT card is named Backdraft")
	ok(Classes.pool_ability("Backdraft") != null,
		"the name still resolves — to the talent's ability, as it always has")
	for spec in Classes.SPEC_DRAFT_POOLS:
		ok(not Classes.spec_draft_pool(spec).has("Backdraft"),
			"Backdraft is in no draft pool (%s)" % spec)
	# And the card that would have carried it is in the pool under its new name.
	ok(Classes.spec_draft_pool("pyromancer").has("Firedraw"),
		"the renamed card ships as Firedraw")


func _status_lists() -> void:
	# THE SPLIT BU's SUFFERING TRAP MADE NECESSARY. The two enemy-side statuses
	# must be in DEBUFF_IDS — not for the cleanse (that is a bonus) but because
	# `_dispellable_buffs` is DERIVED from the absence, so an unlisted affliction
	# on an enemy is something a Mage's own Dispel would strip FOR the enemy.
	for sid in ["frostbind", "unmade"]:
		ok(BattleUnit.DEBUFF_IDS.has(sid),
			"%s is a listed debuff, so Dispel cannot strip it for the enemy" % sid)
	# The three hero-side ones must NOT be listed: a debuff on a hero is
	# something an enemy mender's rite would take, and these are his own buffs.
	for sid in ["emberkeep", "resonant_field", "threshold_lock"]:
		ok(not BattleUnit.DEBUFF_IDS.has(sid),
			"%s sits on a HERO and is not a debuff" % sid)
	# Every one of the five is rendered, or its chip is a blank square.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for sid in ["emberkeep", "frostbind", "unmade", "resonant_field",
			"threshold_lock"]:
		ok(src.contains('"%s": [' % sid),
			"%s has a STATUS_INFO entry" % sid)


func _one_refund_door() -> void:
	# AR'S RULE, STILL WORKING: Overburn's refund has ONE implementation and a
	# new consumer inherits it. PYRE WAKE IS THE SIXTH — the pinned count goes
	# 5 -> 6, which is BO's reason for pinning a count rather than the count
	# decaying quietly.
	var src := _strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var n := src.count("_overburn_refund(")
	# One declaration plus six call sites.
	ok(n == 7, "there is ONE refund door with SIX consumers (got %d mentions)" % n)
	ok(src.contains("func _overburn_refund("),
		"the one implementation is still a function")


func _two_bypass_doors() -> void:
	# §1 ASKED WHETHER A COMBINED RESISTANCE-AND-ARMOR BYPASS ALREADY EXISTED.
	# IT DOES NOT — there are TWO separate sites and Unmaking is the first thing
	# in the game to use both. Asserted at the source, because the failure a
	# later batch would introduce is deleting one of the two and leaving the
	# ability's description promising both.
	var src := _strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(src.contains('if ab.display_name == "Unmaking":') \
			and src.contains("resist = 0.0"),
		"Unmaking zeroes RESISTANCE at the resist block")
	ok(src.contains('or ab.display_name == "Unmaking":') \
			and src.contains("effective_armor = 0.0"),
		"Unmaking joins the ARMOR bypass arm")
	# The armor arm is shared with the four that were already there — a second
	# copy of "armor is zero" is how the two would drift.
	ok(src.count("effective_armor = 0.0") <= 2,
		"there is still ONE armor-bypass arm in the strike block")


func _strip_comments(src: String) -> String:
	# BS's RULE: this batch's own comments NAME the things being asserted (the
	# Backdraft collision, "resist = 0.0"), so a bare `contains` over raw source
	# would pass against a file that only TALKS about them.
	var out := ""
	for line in src.split("\n"):
		var t := line.strip_edges()
		if t.begins_with("#"):
			continue
		out += line + "\n"
	return out


# ---------- live harness ----------

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
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline).
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0
	return scene


func _mage(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _live_foes(scene: Node) -> Array:
	return scene.get("enemies").filter(func(e): return not e.dead)


func _seeded() -> void:
	seed(20260815)


func _card(name: String) -> Ability:
	return Classes.draft_ability(name)


func _burn_turns(u: BattleUnit) -> int:
	return maxi(int(u.get_status("burn").get("turns", 0)), 0)


# ---------- §2 live: the Pyromancer three ----------

func _live_firedraw() -> void:
	var scene := await _spawn("pyromancer", ["raider", "raider", "archer"])
	var py := _mage(scene, "overburn")
	ok(py != null, "the Pyromancer spawned")
	if py == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	ok(foes.size() == 3, "three enemies stand")
	var mark: BattleUnit = foes[0]
	var shallow: BattleUnit = foes[1]
	var deep: BattleUnit = foes[2]
	# THE CONSTRUCTION THAT DISCRIMINATES "UP TO 4". One source holds LESS than
	# the cap and one holds MORE, so a "4 or nothing" version and a "take it all"
	# version each land on a different, wrong number.
	scene.call("_apply_status", shallow, "burn", 2, 0, 6, py)
	scene.call("_apply_status", deep, "burn", 10, 0, 6, py)
	ok(_burn_turns(mark) == 0, "the target starts unlit")
	await scene.call("_resolve", py, _card("Firedraw"), mark, "good")
	ok(_burn_turns(shallow) == 0,
		"the shallow source gave its 2 and is out (got %d)" % _burn_turns(shallow))
	ok(_burn_turns(deep) == 6,
		"the deep source gave exactly 4 of its 10 (got %d)" % _burn_turns(deep))
	ok(_burn_turns(mark) == 6,
		"the target carries 2 + 4 = 6 (got %d)" % _burn_turns(mark))
	scene.queue_free()
	await process_frame

	# THE TARGET'S OWN BURN IS NEVER TOUCHED — and this is the half that needs a
	# construction, because THE TRANSFER IS CONSERVATIVE: a version that wrongly
	# drew from the target too would move MORE turns and give them all back, and
	# every obvious assertion would pass. Under an EMBERKEEP window the deposit
	# is DOUBLED, which breaks the conservation and separates the two readings.
	var s2 := await _spawn("pyromancer", ["raider", "raider", "archer"])
	var py2 := _mage(s2, "overburn")
	if py2 == null:
		s2.queue_free()
		return
	var f2 := _live_foes(s2)
	var mark2: BattleUnit = f2[0]
	s2.call("_apply_status", mark2, "burn", 6, 0, 6, py2)
	s2.call("_apply_status", f2[1], "burn", 4, 0, 6, py2)
	s2.call("_apply_status", f2[2], "burn", 4, 0, 6, py2)
	# Open the window WITHOUT re-applying anything (the marker only affects
	# arrivals), then draw.
	py2.add_status("emberkeep", "Emberkeep", "Ek", Color.WHITE, 3, "", 0, 0)
	ok(_burn_turns(mark2) == 6, "the target's own 6 is untouched by the window")
	await s2.call("_resolve", py2, _card("Firedraw"), mark2, "good")
	# CORRECT: 8 turns drawn from the other two, doubled to 16, onto its own 6.
	# A version that drew from the target too would move 12, leave it on 2, and
	# land on 26.
	ok(_burn_turns(mark2) == 22,
		"the target keeps its own 6 and gains a doubled 16 = 22 (got %d) — 26 would mean it drew from itself"
			% _burn_turns(mark2))
	s2.queue_free()
	await process_frame

	# WITH ONE ENEMY ON THE FIELD IT MOVES NOTHING.
	var s3 := await _spawn("pyromancer", ["raider"])
	var py3 := _mage(s3, "overburn")
	if py3 == null:
		s3.queue_free()
		return
	var lone: BattleUnit = _live_foes(s3)[0]
	s3.call("_apply_status", lone, "burn", 7, 0, 6, py3)
	await s3.call("_resolve", py3, _card("Firedraw"), lone, "good")
	ok(_burn_turns(lone) == 7,
		"with one enemy standing nothing moves (got %d)" % _burn_turns(lone))
	s3.queue_free()
	await process_frame


func _live_pyre_wake() -> void:
	# DRIVEN ON A SINGLE-ENEMY FIELD ON PURPOSE: every scattered fire lands back
	# on the same body, so "one fire PER TURN CONSUMED" becomes an exact,
	# readable number. A per-CAST implementation leaves ONE turn standing where
	# this must leave five.
	var scene := await _spawn("pyromancer", ["chief"])
	var py := _mage(scene, "overburn")
	ok(py != null, "the Pyromancer spawned for Pyre Wake")
	if py == null:
		scene.queue_free()
		return
	var mark: BattleUnit = _live_foes(scene)[0]
	mark.max_hp = 4000
	mark.hp = 4000
	# `_resolve` DEDUCTS the ability's cost (battle.gd's spend block), so the
	# Mana delta below is cost-THEN-refund and the check states both halves
	# rather than pretending the refund is the only thing that moved (BT's
	# Funeral Pyre note, one tranche later).
	py.max_resource = 100
	py.resource = 90
	scene.call("_apply_status", mark, "burn", 5, 0, 6, py)
	ok(_burn_turns(mark) == 5, "the target carries a 5-turn Burn")
	var mana_was: int = py.resource
	var hp_was: int = mark.hp
	await scene.call("_resolve", py, _card("Pyre Wake"), mark, "good")
	ok(_burn_turns(mark) == 5,
		"five turns consumed become five fresh 1-turn fires on the only body standing (got %d)"
			% _burn_turns(mark))
	ok(mark.hp < hp_was, "and every one of them landed a blow")
	# THE REFUND GOES THROUGH THE ONE DOOR: 1 Mana per turn consumed.
	var pw_cost: int = _card("Pyre Wake").cost
	ok(py.resource - mana_was == 5 - pw_cost,
		"Overburn refunds 1 Mana per turn consumed: %d spent, 5 back (want %d, got %d)"
			% [pw_cost, 5 - pw_cost, py.resource - mana_was])
	scene.queue_free()
	await process_frame

	# AND IT CONSUMES *ALL* OF IT, not a skim: a deep stack empties in one cast.
	var s2 := await _spawn("pyromancer", ["chief", "raider"])
	var py2 := _mage(s2, "overburn")
	if py2 == null:
		s2.queue_free()
		return
	var f2 := _live_foes(s2)
	var deep: BattleUnit = f2[0]
	deep.max_hp = 4000
	deep.hp = 4000
	f2[1].max_hp = 4000
	f2[1].hp = 4000
	s2.call("_apply_status", deep, "burn", 9, 0, 6, py2)
	await s2.call("_resolve", py2, _card("Pyre Wake"), deep, "good")
	# Its own 9 are gone; what it holds now is only what the scatter gave back.
	ok(_burn_turns(deep) < 9,
		"the bank is emptied rather than skimmed (got %d)" % _burn_turns(deep))
	ok(_burn_turns(deep) + _burn_turns(f2[1]) == 9,
		"and all nine turns landed again as fresh fires (got %d)" % (
			_burn_turns(deep) + _burn_turns(f2[1])))
	s2.queue_free()
	await process_frame


func _live_emberkeep() -> void:
	var scene := await _spawn("pyromancer", ["raider", "raider"])
	var py := _mage(scene, "overburn")
	ok(py != null, "the Pyromancer spawned for Emberkeep")
	if py == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var old_fire: BattleUnit = foes[0]
	var new_fire: BattleUnit = foes[1]
	# A FIRE LAID BEFORE THE WINDOW — the retroactive-implementation control.
	scene.call("_apply_status", old_fire, "burn", 3, 0, 6, py)
	ok(_burn_turns(old_fire) == 3, "a 3-turn fire stands before the cast")
	await scene.call("_resolve", py, _card("Emberkeep"), py, "good")
	ok(py.has_status("emberkeep"), "the window is open")
	ok(int(py.get_status("emberkeep").get("turns", 0)) == 3,
		"...for three turns")
	ok(_burn_turns(old_fire) == 3,
		"FIRE ALREADY ON THE BOARD IS UNTOUCHED (got %d) — that is Stoke's job"
			% _burn_turns(old_fire))
	# A FIRE LAID INSIDE THE WINDOW LANDS DOUBLED.
	scene.call("_apply_status", new_fire, "burn", 3, 0, 6, py)
	ok(_burn_turns(new_fire) == 3 * EMBERKEEP_MULT_TEST,
		"Burn applied inside the window lands at DOUBLE duration (want %d, got %d)"
			% [3 * EMBERKEEP_MULT_TEST, _burn_turns(new_fire)])
	# SCOPED TO THE SRC: a SECOND applier's fire is not his and is not doubled.
	var other := _mage(scene, "")
	if other == null:
		for h in scene.get("heroes"):
			if not h.is_companion and h != py:
				other = h
				break
	if other != null:
		var third: BattleUnit = foes[0]
		third.remove_status("burn")
		scene.call("_apply_status", third, "burn", 3, 0, 6, other)
		ok(_burn_turns(third) == 3,
			"a SECOND applier's Burn is not doubled (got %d)" % _burn_turns(third))
	# AND A BATTLE-LONG FIRE IS NOT TURNED INTO -2. A negative turn count is a
	# PERMANENCE FLAG rather than a duration (BV's `full_turns` lesson).
	var perm: BattleUnit = foes[1]
	perm.remove_status("burn")
	scene.call("_apply_status", perm, "burn", -1, 0, 6, py)
	ok(int(perm.get_status("burn").get("turns", 0)) == -1,
		"a battle-long Burn stays battle-long rather than becoming -2 (got %d)"
			% int(perm.get_status("burn").get("turns", 0)))
	scene.queue_free()
	await process_frame


# ---------- §3 live: the Cryomancer three ----------

func _live_deep_winter() -> void:
	var scene := await _spawn("cryomancer", ["raider", "raider", "archer"])
	var cr := _mage(scene, "permafrost")
	ok(cr != null, "the Cryomancer spawned")
	if cr == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	# NO HOLD: it must change nothing at all, cleanly.
	await scene.call("_resolve", cr, _card("Deep Winter"), cr, "good")
	var any_chill := 0
	for f in _live_foes(scene):
		any_chill += f.status_stacks("chilled")
	ok(any_chill == 0,
		"with no hold Deep Winter does nothing (got %d stacks on the field)"
			% any_chill)
	# BUILD A HOLD AT FOUR, then copy HALF of it.
	var prisoner: BattleUnit = foes[0]
	# A DIRECT `_hold_freeze` NEEDS THE CHILL FIRST, which is Flash Freeze's
	# own idiom rather than a harness quirk: the ordinary road into a hold is
	# the Chilled-4 branch of `_apply_status`, so a unit arriving without a
	# chilled status has no pile for `set_chilled_stacks` to write to and the
	# prison reads EMPTY. Skipping this is why the first draft of this check
	# measured a four-deep prison at zero.
	scene.call("_apply_status", prisoner, "chilled", 3, 0, 0, cr)
	scene.call("_hold_freeze", prisoner, cr, true)
	ok(scene.call("_is_held", prisoner), "the prisoner is held")
	ok(prisoner.status_stacks("chilled") == 4,
		"a held enemy sits at four stacks (got %d)"
			% prisoner.status_stacks("chilled"))
	await scene.call("_resolve", cr, _card("Deep Winter"), cr, "good")
	for f in _live_foes(scene):
		if f == prisoner:
			continue
		ok(f.status_stacks("chilled") == 2,
			"%s gains HALF the prison's four = 2 (got %d) — 4 would mean it copied the whole pile"
				% [f.unit_name, f.status_stacks("chilled")])
	scene.queue_free()
	await process_frame


func _live_cold_iron() -> void:
	var scene := await _spawn("cryomancer", ["raider", "raider"])
	var cr := _mage(scene, "permafrost")
	ok(cr != null, "the Cryomancer spawned for Cold Iron")
	if cr == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var frozen: BattleUnit = foes[0]
	var free_foe: BattleUnit = foes[1]
	for f in foes:
		f.max_hp = 4000
		f.hp = 4000
		f.armor = 0.0
	scene.call("_apply_status", frozen, "chilled", 3, 0, 0, cr)
	scene.call("_hold_freeze", frozen, cr, true)
	ok(frozen.has_status("frozen"), "one enemy is Frozen and held")
	# THE SAME BLOW, TWICE, WITH THE SAME VARIANCE DRAW. `_seeded()` before each
	# is what makes a x2 readable rather than a coin flip (BS's rule).
	_seeded()
	var free_before: int = free_foe.hp
	await scene.call("_resolve", cr, _card("Cold Iron"), free_foe, "good")
	var free_dmg: int = free_before - free_foe.hp
	_seeded()
	var frozen_before: int = frozen.hp
	await scene.call("_resolve", cr, _card("Cold Iron"), frozen, "good")
	var frozen_dmg: int = frozen_before - frozen.hp
	ok(free_dmg > 0 and frozen_dmg > 0, "both blows landed")
	# A RATIO WITH OPEN GROUND between signal (2.0) and noise (~1.0), never a
	# bare `>` — BS's twofold rule.
	ok(float(frozen_dmg) > float(free_dmg) * 1.6,
		"a Frozen target takes DOUBLE (%d against %d)" % [frozen_dmg, free_dmg])
	# THE NEGATIVE CONTROL THAT MATTERS: the hold SURVIVES the blow.
	ok(scene.call("_is_held", frozen),
		"COLD IRON DOES NOT RELEASE THE HOLD — the cell stays shut")
	ok(frozen.has_status("frozen"), "...and the target is still Frozen")
	# AND ICE LANCE, IN THE SAME BATTLE, STILL DOES — otherwise "it does not
	# release" would be trivially true of a battle where nothing releases.
	var lance: Ability = null
	for a in cr.abilities:
		if a.display_name == "Ice Lance":
			lance = a
	ok(lance != null, "the Cryomancer holds Ice Lance to compare against")
	if lance != null:
		await scene.call("_resolve", cr, lance, frozen, "good")
		ok(not scene.call("_is_held", frozen),
			"CONTROL: Ice Lance DOES release the hold")
	scene.queue_free()
	await process_frame


func _live_frostbind() -> void:
	var scene := await _spawn("cryomancer", ["raider", "raider", "archer"])
	var cr := _mage(scene, "permafrost")
	ok(cr != null, "the Cryomancer spawned for Frostbind")
	if cr == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var loose: BattleUnit = foes[2]
	for f in foes:
		f.max_hp = 4000
		f.hp = 4000
	scene.set("second_target", b)
	await scene.call("_resolve", cr, _card("Frostbind"), a, "good")
	ok(a.has_status("frostbind") and b.has_status("frostbind"),
		"both chosen enemies are bound")
	ok(not loose.has_status("frostbind"),
		"the third enemy is not — a bond is a PAIR, not a field")
	ok(scene.call("_frostbind_partner", a) == b
			and scene.call("_frostbind_partner", b) == a,
		"the bond resolves from BOTH ends")
	# THE MIRROR, AND THE CLAUSE THAT MATTERS. 100 dealt to A must put 40 on B —
	# and A's OWN loss must be EXACTLY 100. A mirror that mirrored back would add
	# 40% of 40 = 16 to A, which is the recursion §3 forbids.
	var a_was: int = a.hp
	var b_was: int = b.hp
	a.take_tick_damage(100, "-100", Color.WHITE)
	var a_lost: int = a_was - a.hp
	var b_lost: int = b_was - b.hp
	ok(a_lost == 100,
		"THE MIRROR DOES NOT MIRROR BACK: the struck enemy lost exactly 100 (got %d)"
			% a_lost)
	ok(b_lost == int(round(100 * FROSTBIND_SHARE_TEST)),
		"the partner suffers with it at 40%% (want %d, got %d)" % [
			int(round(100 * FROSTBIND_SHARE_TEST)), b_lost])
	ok(loose.hp == 4000, "and nobody outside the pair felt it")
	# CHILLED LANDING ON EITHER LANDS ON BOTH.
	var a_chill := a.status_stacks("chilled")
	var b_chill := b.status_stacks("chilled")
	scene.call("_apply_status", a, "chilled", 3, 0, 0, cr)
	ok(a.status_stacks("chilled") == a_chill + 1,
		"the struck partner gains the stack")
	ok(b.status_stacks("chilled") == b_chill + 1,
		"AND SO DOES THE OTHER (got %d, was %d)" % [
			b.status_stacks("chilled"), b_chill])
	# A CLEANSE ON ONE END BREAKS THE BOND HONESTLY rather than leaving a
	# half-bond pointing at a body that is no longer bound.
	b.remove_status("frostbind")
	ok(scene.call("_frostbind_partner", a) == null,
		"stripping ONE end breaks the bond from both directions")
	scene.queue_free()
	await process_frame

	# THE PAIR FREEZES TOGETHER, AND BN'S GUARD HOLDS WHILE IT DOES. Driving both
	# to the threshold through the bond is the exact arrangement where a freeze
	# could begin inside another freeze's release.
	var s2 := await _spawn("cryomancer", ["raider", "raider"])
	var cr2 := _mage(s2, "permafrost")
	if cr2 == null:
		s2.queue_free()
		return
	var f2 := _live_foes(s2)
	s2.set("second_target", f2[1])
	await s2.call("_resolve", cr2, _card("Frostbind"), f2[0], "good")
	for _i in 4:
		s2.call("_apply_status", f2[0], "chilled", 3, 0, 0, cr2)
	ok(f2[0].has_status("frozen") and f2[1].has_status("frozen"),
		"driving ONE partner to four freezes THE PAIR")
	# The guard is what makes that safe to write — assert it is still there and
	# still cleared, so a later batch cannot delete it for looking redundant.
	ok(not s2.get("_releasing"),
		"BN's re-entrancy guard is clear afterwards, not stuck on")
	ok(not s2.get("_frostbinding"),
		"and so is Frostbind's own Chilled-copy guard")
	ok(not s2.get("_frostbind_mirroring"),
		"and so is its damage-mirror guard")
	s2.queue_free()
	await process_frame


# ---------- §4 live: the Arcanist three ----------

func _live_resonant_field() -> void:
	var scene := await _spawn("arcanist", ["raider", "raider"])
	var arc := _mage(scene, "resonance")
	if arc == null:
		for h in scene.get("heroes"):
			if not h.is_companion and h.second_resource_name == "Resonance":
				arc = h
	ok(arc != null, "the Arcanist spawned")
	if arc == null:
		scene.queue_free()
		return
	var ally: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and h != arc:
			ally = h
			break
	ok(ally != null, "an ally stands to be armed")
	if ally == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.max_hp = 40000
	foe.hp = 40000
	foe.armor = 0.0
	arc.second_resource = 4
	await scene.call("_resolve", arc, _card("Resonant Field"), arc, "good")
	ok(ally.has_status("resonant_field"), "the ally is standing in the field")
	# ALLIES ONLY: he already deals the FULL bonus.
	ok(not arc.has_status("resonant_field"),
		"THE ARCANIST IS NOT IN HIS OWN FIELD — he already has the whole curve")
	# THE STATUS CARRIES NO NUMBER (Null Field's rule) — that is what makes the
	# live read possible at all.
	ok(int(ally.get_status("resonant_field").get("power", 0)) == 0,
		"the status carries NO stamped value")
	# THE DISCRIMINATING CHECK: the SAME ally's blow, measured at two Arcanist
	# stack counts, with the field opened ONCE. A cast-time snapshot returns the
	# same number twice.
	var basic: Ability = ally.abilities[0]
	_seeded()
	var hp0: int = foe.hp
	await scene.call("_resolve", ally, basic, foe, "good")
	var low_dmg: int = hp0 - foe.hp
	arc.second_resource = 14
	_seeded()
	var hp1: int = foe.hp
	await scene.call("_resolve", ally, basic, foe, "good")
	var high_dmg: int = hp1 - foe.hp
	ok(low_dmg > 0 and high_dmg > 0, "both ally blows landed")
	ok(float(high_dmg) > float(low_dmg) * 1.3,
		"IT READS HIS METER LIVE: the same blow grew with him (%d -> %d)" % [
			low_dmg, high_dmg])
	# A DEAD ARCANIST PAYS NOBODY.
	arc.hp = 0
	arc.dead = true
	_seeded()
	var hp2: int = foe.hp
	await scene.call("_resolve", ally, basic, foe, "good")
	var dead_dmg: int = hp2 - foe.hp
	ok(dead_dmg < high_dmg,
		"a dead Arcanist pays nobody (%d against %d)" % [dead_dmg, high_dmg])
	scene.queue_free()
	await process_frame


func _live_threshold() -> void:
	var scene := await _spawn("arcanist", ["raider"])
	var arc := _mage(scene, "resonance")
	if arc == null:
		for h in scene.get("heroes"):
			if not h.is_companion and h.second_resource_name == "Resonance":
				arc = h
	ok(arc != null, "the Arcanist spawned for Threshold")
	if arc == null:
		scene.queue_free()
		return
	# FROM BELOW: it is a huge jump.
	arc.second_resource = 3
	await scene.call("_resolve", arc, _card("Threshold"), arc, "good")
	ok(arc.second_resource == THRESHOLD_STACKS_TEST,
		"Threshold SETS the meter to exactly %d (got %d)" % [
			THRESHOLD_STACKS_TEST, arc.second_resource])
	ok(arc.has_status("threshold_lock"), "and the lockout is up")
	ok(int(arc.get_status("threshold_lock").get("turns", 0)) == 3,
		"...for three turns")
	# IT REFUSES ALL GAIN, AT THE ONE DOOR. Driven through the door itself AND
	# through two of the cards §7 names, because a gate written per-card would
	# pass the first and fail the others.
	scene.call("_gain_resonance", arc, 5)
	ok(arc.second_resource == THRESHOLD_STACKS_TEST,
		"the ONE door refuses a raw gain (got %d)" % arc.second_resource)
	await scene.call("_resolve", arc, _card("Inner Arcane"), arc, "good")
	ok(arc.second_resource == THRESHOLD_STACKS_TEST,
		"INNER ARCANE cannot raise it either (got %d)" % arc.second_resource)
	var km := _card("Kindled Mind")
	if km != null:
		await scene.call("_resolve", arc, km, _live_foes(scene)[0], "good")
		ok(arc.second_resource == THRESHOLD_STACKS_TEST,
			"NOR KINDLED MIND, nor the passive's own +1 a damaging cast (got %d)"
				% arc.second_resource)
	# AND IT LAPSES: the lockout is a window, not a permanent state.
	for _i in 4:
		arc.tick_statuses()
	ok(not arc.has_status("threshold_lock"), "the lockout expires")
	scene.call("_gain_resonance", arc, 5)
	ok(arc.second_resource > THRESHOLD_STACKS_TEST,
		"and he can build again afterwards (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame

	# FROM ABOVE IT IS A COST, AND THE CARD SAYS SO. This is the half that makes
	# "an emergency, not an opener" true rather than merely written down.
	var s2 := await _spawn("arcanist", ["raider"])
	var arc2 := _mage(s2, "resonance")
	if arc2 == null:
		for h in s2.get("heroes"):
			if not h.is_companion and h.second_resource_name == "Resonance":
				arc2 = h
	if arc2 == null:
		s2.queue_free()
		return
	arc2.second_resource = 24
	await s2.call("_resolve", arc2, _card("Threshold"), arc2, "good")
	ok(arc2.second_resource == THRESHOLD_STACKS_TEST,
		"cast above 15 it TAKES STACKS AWAY (24 -> %d)" % arc2.second_resource)
	s2.queue_free()
	await process_frame


func _live_unmaking() -> void:
	var scene := await _spawn("arcanist", ["raider", "raider"])
	var arc := _mage(scene, "resonance")
	if arc == null:
		for h in scene.get("heroes"):
			if not h.is_companion and h.second_resource_name == "Resonance":
				arc = h
	ok(arc != null, "the Arcanist spawned for Unmaking")
	if arc == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var naked: BattleUnit = foes[0]
	var warded: BattleUnit = foes[1]
	for f in foes:
		f.max_hp = 40000
		f.hp = 40000
	naked.armor = 0.0
	naked.resists = {}
	# THE DISCRIMINATING CASE: the other enemy carries BOTH a heavy armor value
	# AND a heavy arcane resistance, so an implementation that bypassed only one
	# of the two reads visibly short.
	warded.armor = 0.60
	warded.resists = {"arcane": 0.75}
	arc.second_resource = 10
	_seeded()
	var n0: int = naked.hp
	await scene.call("_resolve", arc, _card("Unmaking"), naked, "good")
	var naked_dmg: int = n0 - naked.hp
	_seeded()
	var w0: int = warded.hp
	await scene.call("_resolve", arc, _card("Unmaking"), warded, "good")
	var warded_dmg: int = w0 - warded.hp
	ok(naked_dmg > 0 and warded_dmg > 0, "both Unmakings landed")
	# A RATIO WITH OPEN GROUND, NOT AN EQUALITY. The two blows are separate
	# casts and the ±10% variance roll is not suppressible by any field (BS's
	# finding), so an exact match is a coin flip. WITHOUT the two bypasses the
	# warded body would take 0.25 x 0.40 = ONE TENTH of the naked one, so the
	# ground between signal (~1.0) and failure (~0.1) is enormous.
	ok(float(warded_dmg) > float(naked_dmg) * 0.75,
		"RESISTANCE *AND* ARMOR ARE BOTH IGNORED: 60%% armor + 75%% arcane resist barely moved it (%d against %d)"
			% [warded_dmg, naked_dmg])
	# THE CONTROL THAT PROVES THE ARMOUR AND THE RESIST WERE REAL: an ordinary
	# arcane blow into the same body is cut hard. Without it, "the two are equal"
	# is satisfied by a target whose defences were never applied at all.
	var bolt := _card("Arcane Bolt")
	if bolt != null:
		_seeded()
		var cn: int = naked.hp
		await scene.call("_resolve", arc, bolt, naked, "good")
		var control_naked: int = cn - naked.hp
		_seeded()
		var cw: int = warded.hp
		await scene.call("_resolve", arc, bolt, warded, "good")
		var control_warded: int = cw - warded.hp
		ok(control_warded * 3 < control_naked,
			"CONTROL: an ordinary arcane blow IS cut by those defences (%d against %d)"
				% [control_warded, control_naked])
	# THE HEAL LOCK.
	ok(naked.has_status("unmade"), "the target is unmade")
	ok(int(naked.get_status("unmade").get("turns", 0)) == 3,
		"...for three turns")
	naked.hp = 100
	var healed: int = naked.heal_amount(500, true)
	ok(healed == 0, "IT CANNOT BE HEALED AT ALL (got %d)" % healed)
	ok(naked.hp == 100, "and its health did not move")
	# AND THE LOCK LAPSES rather than being permanent.
	for _i in 4:
		naked.tick_statuses()
	ok(not naked.has_status("unmade"), "the lock expires")
	ok(naked.heal_amount(50, true) > 0, "and healing works again afterwards")
	# IT PAYS PER STACK: the same cast at two meters.
	var s2 := await _spawn("arcanist", ["raider"])
	var arc2 := _mage(s2, "resonance")
	if arc2 == null:
		for h in s2.get("heroes"):
			if not h.is_companion and h.second_resource_name == "Resonance":
				arc2 = h
	if arc2 == null:
		scene.queue_free()
		s2.queue_free()
		return
	var t2: BattleUnit = _live_foes(s2)[0]
	t2.max_hp = 40000
	t2.hp = 40000
	t2.armor = 0.0
	arc2.second_resource = 4
	_seeded()
	var l0: int = t2.hp
	await s2.call("_resolve", arc2, _card("Unmaking"), t2, "good")
	var low: int = l0 - t2.hp
	arc2.second_resource = 16
	_seeded()
	var h0: int = t2.hp
	await s2.call("_resolve", arc2, _card("Unmaking"), t2, "good")
	var high: int = h0 - t2.hp
	ok(high > low * 2, "it pays 10%% of Attack PER STACK (%d at 4, %d at 16)"
		% [low, high])
	scene.queue_free()
	s2.queue_free()
	await process_frame


func _docs() -> void:
	# THE CONTENT THIS BATCH IS RESPONSIBLE FOR, NOT THE STAMP. The master.html
	# stamp gate is already duplicated THIRTEEN times (ah, bb, bn, bo, bp, bq,
	# br, bs, bt, bu, bv, bw, bx) and every one of them moves whenever any batch
	# bumps the timestamp; adding a fourteenth would make the next batch's
	# housekeeping worse for no new information. What is NOT covered by those
	# thirteen is whether the nine actually reached the player-facing table, and
	# that is the question worth asking here.
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master.length() > 1000, "master.html is readable")
	for n in NINE:
		ok(master.contains(n), "master.html documents %s" % n)
	# The draft table's own count, and the claim this batch is built on.
	# RE-POINTED BY BATCH CE, and both re-points are the ordinary kind: CB's own
	# claims were true of CB and the doc has moved past them. The QUESTION is
	# unchanged — does master.html state the live count in words, and does it
	# record which classes are complete — so a doc that quietly stopped saying
	# either still trips.
	ok(master.contains("hundred and two"),
		"master.html states the new draft count in words")
	ok(master.contains("Mage and the Cleric are complete"),
		"master.html records the completed classes (the Mage was CB's, the Cleric CE's)")
	# The pool summary rows moved with the pools, or a player reads five where
	# the game offers eight.
	ok(master.contains("Funeral Pyre, <b>Firedraw</b>"),
		"the Pyromancer pool row lists the tranche-3 three")
	ok(master.contains("Hoarfrost Armor, <b>Deep Winter</b>"),
		"the Cryomancer pool row does too")
	ok(master.contains("Arcane Echo, <b>Resonant Field</b>"),
		"and so does the Arcanist's")
	# The changelog carries this batch's entry (BX's own idiom).
	var chlog := FileAccess.get_file_as_string("res://docs/changelog.html")
	ok(chlog.contains("Batch CB"), "the changelog carries a Batch CB entry")
	# AND THE GLOSSARY ENTRY THE BOND MADE NECESSARY — asserted through the
	# resolver rather than by grepping the JSON, so a malformed entry trips too.
	var bond: Dictionary = Glossary.entry("status_bound")
	ok(not bond.is_empty(), "the glossary has an entry for the bond")
	if bond.is_empty():
		return
	ok(String(bond.get("category", "")) == "statuses",
		"...filed under statuses")
	ok(String(bond.get("short", "")) != "" and String(bond.get("long", "")) != "",
		"...and it says something")
	# It must name the two rules a player cannot learn anywhere else.
	var long_text: String = String(bond.get("long", ""))
	ok(long_text.contains("DOES NOT MIRROR BACK"),
		"...including that the mirror does not mirror back")
	ok(long_text.contains("ONE of his hold slots")
			or long_text.contains("ONE of his hold"),
		"...and that a bound pair costs ONE hold slot rather than two")
	var ids := {}
	for e in Glossary.entries():
		ids[String(e["id"])] = true
	for link in bond.get("see_also", []):
		ok(ids.has(String(link)), "the bond entry links to a real entry (%s)" % link)
