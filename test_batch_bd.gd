# test_batch_bd.gd — DEADFALL BECOMES A PLACED HAZARD. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bd.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# One ability. What is pinned:
#   §0 THE FINDING THAT CAUSED THE BATCH — Deadfall and Snare Trap were the
#      same ability. The table's five identical rows are asserted to have STOPPED
#      being identical, so a later re-tune that quietly collapses them again
#      trips here rather than being noticed by a player reading two tooltips.
#   §1 THE SPEC: 25 Mana, 2.0, 5cd, 20% of Attack per spring, three springs,
#      four on a perfect, two turns dormant between them.
#   §2 THE FIELD WITH A NEW UNIT. `deadfall_armed` counts CHARGES now, not
#      traps — the class of change that fails silently — so every read site is
#      driven: the spring decrements it, the cap counts a charged deadfall as
#      exactly ONE occupant, and the slot frees when the last charge is spent.
#      `deadfall_aims` is asserted ABSENT rather than empty.
#   §2 THE THREE NODES THAT NOW PAY PER SPRING, each measured at its site.
#   §3 THE BOT'S NEW POSITION, asserted against source ORDER (the rotation is
#      inside `_player_turn`'s policy and a live check cannot see the ordering).
#
# THE SPRING IS DRIVEN THROUGH `_deadfall_tick`, which is why that clause was
# extracted from `_run_battle` at all: the loop cannot be driven headlessly (the
# AR trap), so a rule left inside it can only ever be checked by a grep and its
# negative controls could never fail.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
# A live check that THROWS mid-way aborts its own function while the suite still
# prints "0 failures" — the CLAUDE.md trap that fakes a clean pass. Every live
# function bumps this on its LAST line, and the count is asserted.
var _live_ran := 0
const LIVE_CHECKS := 8
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
var _report: Array = []


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
	Profile.save_path = "user://profile_batch_bd_test.json"
	Profile.loaded = false
	Profile.data = {}

	_the_spec()
	_no_longer_snare_trap()
	_aims_is_gone()
	_one_writer_for_the_chip()
	_tick_is_its_own_function()
	_bot_position()

	await _live_three_springs_then_nothing()
	await _live_dormancy_blocks_then_allows()
	await _live_perfect_gives_four()
	await _live_boss_shrugs_unless_broken()
	await _live_nodes_pay_per_spring()
	await _live_cap_counts_a_deadfall_as_one()
	await _live_slot_frees_on_the_last_charge()
	await _live_chip_shows_charges_and_rest()
	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bd_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bd_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bd: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _spawn(learned := {}, lineup := ["raider", "archer"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 3 else {}
		run.party[i]["bm_abilities"] = ["Deadfall", "Snare Trap"] if i == 3 else []
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.combat_wins = 0
	run.pending_modifier = ""
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/../BC discipline).
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.healing_received_mult = 1.0
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	await process_frame
	await process_frame


func _sv(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if h.hero_key == "hunter":
			return h
	return null


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


# One cast, resolved through the real special so the charges are written by the
# code the player's button reaches.
func _arm(scene: Node, sv: BattleUnit, grade := "good") -> void:
	var ab: Ability = Classes.pool_ability("Deadfall")
	await scene._resolve_special(sv, ab, sv, grade, 1.0)


# ---------- §1: the spec ----------

func _the_spec() -> void:
	var ab: Ability = Classes.pool_ability("Deadfall")
	ok(ab != null, "§1: Deadfall still resolves out of the spec pool")
	if ab == null:
		return
	ok(ab.cost == 25, "§1: 25 Mana (reads %d)" % ab.cost)
	ok(abs(ab.delay - 2.0) < 0.001, "§1: 2.0 initiative (reads %s)" % str(ab.delay))
	ok(ab.cooldown == 5, "§1: 5 turn cooldown (reads %d)" % ab.cooldown)
	ok(ab.special == "deadfall", "§1: it is still the deadfall special")
	# BATCH CQ §5 — RE-POINTED AND INVERTED. AH gave Deadfall a check; CN's
	# parameteric criterion took it away again, and this line went on reading
	# the explicit opt-out flag (never set) and reporting the bar as present.
	# The flag is deleted; `runs_skill_check()` is the single source.
	ok(not ab.runs_skill_check(), "§1: CN's criterion removed its skill check")
	# BATCH CQ §3 — CN §3 FOLDED THE FOURTH SPRING INTO THE BASE and cleared
	# the text with it, because a card that runs no bar must not advertise a
	# bonus nothing can fire. The fourth spring is asserted as the BASE count
	# below; what is pinned here is that the advertisement is gone.
	ok(ab.perfect_text == "",
		"§1: the perfect text is CLEARED — the fourth spring is base now (reads '%s')" % \
			ab.perfect_text)
	ok(not ab.perfect_text.to_lower().contains("choose") \
		and not ab.perfect_text.to_lower().contains("name"),
		"§1: and the old clause is gone from the text, not merely reworded")
	ok(ab.perfect_id == "", "§1: it carries no magnitude perfect_id")
	var battle_script: GDScript = load("res://scripts/battle.gd")
	var cmap := battle_script.get_script_constant_map()
	ok(int(cmap["DEADFALL_CHARGES"]) == 3, "§1: three springs from one cast")
	ok(int(cmap["DEADFALL_DORMANCY"]) == 2, "§1: two turns dormant between them")
	ok(abs(float(cmap["DEADFALL_SPRING_PCT"]) - 0.20) < 0.0001,
		"§1: 20%% of Attack per spring, down from 35%% for one")


# §0 — THE FINDING, AS AN ASSERTION. Read side by side the two abilities had the
# same cost, initiative, cooldown and effect, both against the same cap, and the
# ONLY distinction (you don't pick the victim) was handed back by Deadfall's
# perfect. Three of those five rows have to differ now or the re-spec did not
# happen; the perfect is checked above.
func _no_longer_snare_trap() -> void:
	var df: Ability = Classes.pool_ability("Deadfall")
	var sn: Ability = Classes.pool_ability("Snare Trap")
	ok(sn != null, "§0: Snare Trap is readable for the comparison")
	if df == null or sn == null:
		return
	ok(df.cost != sn.cost, "§0: the costs differ (%d vs %d)" % [df.cost, sn.cost])
	ok(df.cooldown != sn.cooldown,
		"§0: the cooldowns differ (%d vs %d)" % [df.cooldown, sn.cooldown])
	# Snare Trap is UNTOUCHED by this batch — it is the thing being differed
	# FROM, so a drift in it would silently re-close the gap.
	ok(sn.cost == 20 and sn.cooldown == 3 and abs(sn.delay - 2.0) < 0.001,
		"§0: Snare Trap is untouched (20 Mana, 3cd, 2.0)")
	_report.append("§0: Deadfall %d Mana/%dcd against Snare Trap %d/%d" % [
		df.cost, df.cooldown, sn.cost, sn.cooldown])


# THE BA PRECEDENT: a field nothing can write GOES, so a later batch cannot
# write one. Asserted ABSENT rather than empty — an empty array is exactly what
# a half-done deletion leaves behind.
func _aims_is_gone() -> void:
	var u := BattleUnit.new()
	var names := PackedStringArray()
	for prop in u.get_property_list():
		names.append(String(prop["name"]))
	ok(not names.has("deadfall_aims"),
		"§2: `deadfall_aims` does not exist as a field")
	ok(names.has("deadfall_armed") and names.has("deadfall_dormant"),
		"§2: the charge count and the dormancy both do")
	u.free()
	for path in ["res://scripts/battle.gd", "res://scripts/unit.gd"]:
		var src := _src(path)
		# The name may survive in a comment saying it was deleted; it may not
		# survive as code.
		for line in src.split("\n"):
			if line.contains("deadfall_aims") and not line.strip_edges().begins_with("#"):
				ok(false, "%s still USES deadfall_aims: %s" % [path, line])
	ok(true, "§2: no live code reads or writes it")


# The chip is written in one place by three callers (the cast, the rest, the
# spring), so the three can never disagree about what the trap is doing.
func _one_writer_for_the_chip() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("func _stamp_deadfall_chip(h: BattleUnit) -> void:"),
		"§2: one writer for the chip")
	# BATCH BM: Set and Forget (Survivalist, Snares row 8) puts the trap back
	# out at his turn start, so there is a FOURTH caller. The property the
	# check exists for — ONE writer, everybody else calls it — is unchanged.
	ok(src.count("_stamp_deadfall_chip(") == 5,
		"§2: ...and four callers besides the definition (reads %d)" % \
			src.count("_stamp_deadfall_chip("))
	ok(not src.contains('"DF%d" % attacker.deadfall_armed'),
		"§2: the cast no longer writes the chip by hand")


# THE REASON THE CLAUSE WAS EXTRACTED AT ALL, asserted so a later batch does not
# inline it back into a loop no test can drive.
func _tick_is_its_own_function() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("func _deadfall_tick(u: BattleUnit) -> void:"),
		"§2: the rest-and-spring rule is its own function")
	ok(src.count("_deadfall_tick(u)") == 1,
		"§2: with exactly one caller in the turn loop")
	# POSITION IS LOAD-BEARING: it must run ABOVE the stunned branch, or the stun
	# it lands would cost the victim a LATER turn instead of this one.
	var call_at := src.find("\t\t_deadfall_tick(u)")
	var stun_at := src.find('_cancel_charge(u, "STUNNED")')
	ok(call_at > 0 and stun_at > call_at,
		"§2: it runs before the stunned branch, so the spring costs THIS turn")


# §3 — the rotation is decided inside `_player_turn`'s policy, which cannot be
# driven headlessly, so its SHAPE is asserted against the source in order.
func _bot_position() -> void:
	var src := _src("res://scripts/battle.gd")
	var snare := src.find('var snare := _find_ability(u, "Snare Trap")')
	var dfall := src.find('var dfall := _find_ability(u, "Deadfall")')
	var harv := src.find('var harv := _find_ability(u, "Harvest")')
	ok(snare > 0 and dfall > 0 and harv > 0,
		"§3: all three rotation entries are present")
	ok(dfall > snare, "§3: Deadfall sits BELOW Snare Trap")
	ok(dfall < harv, "§3: ...and ABOVE Harvest (it used to sit last of all)")
	ok(src.contains("if dfall != null and u.deadfall_armed <= 0 \\"),
		"§3: and it is gated on there being no deadfall already out")


# ---------- live ----------

# THREE SPRINGS FROM ONE CAST, THEN NOTHING. The dormancy is stepped past
# deliberately rather than waited out — this check is about the CHARGES.
func _live_three_springs_then_nothing() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(sv != null, "the Survivalist stands")
	if sv != null:
		await _arm(scene, sv)
		ok(sv.deadfall_armed == 4, "one cast arms FOUR springs since CN's fold (reads %d)" % \
			sv.deadfall_armed)
		var sprung := 0
		for _i in 12:
			foe.hp = foe.max_hp
			foe.remove_status("stunned")
			sv.deadfall_dormant = 0      # step past the rest; §6's own check owns it
			var before := _stat_of(scene, "deadfall_springs")
			scene.call("_deadfall_tick", foe)
			if _stat_of(scene, "deadfall_springs") > before:
				sprung += 1
		ok(sprung == 4, "exactly four springs, then nothing (read %d)" % sprung)
		ok(sv.deadfall_armed == 0, "the charges are spent")
		ok(not sv.has_status("deadfall"), "and the chip is gone with them")
		_report.append("springs from one ordinary cast: %d" % sprung)
	await _kill(scene)
	_live_ran += 1


# THE DORMANCY, DRIVEN. A spring rests the trap for two turns: the next enemy
# turn is blocked, the one after that is blocked, and the third springs. The
# ability text is what settles it — "lies dormant for 2 turns" is two turns on
# which it will not fire. (§6's phrasing "allowing it two turns later" reads one
# turn shorter than the ability's own text; the text wins, and the discrepancy
# is reported rather than quietly resolved.)
func _live_dormancy_blocks_then_allows() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	if sv != null:
		await _arm(scene, sv)
		var seq := PackedStringArray()
		for _i in 4:
			foe.hp = foe.max_hp
			foe.remove_status("stunned")
			var before := _stat_of(scene, "deadfall_springs")
			scene.call("_deadfall_tick", foe)
			seq.append("spring" if _stat_of(scene, "deadfall_springs") > before \
				else "rest(%d)" % sv.deadfall_dormant)
		ok(seq[0] == "spring", "turn 1: it springs")
		ok(seq[1].begins_with("rest"), "turn 2: the dormancy blocks it")
		ok(seq[2].begins_with("rest"), "turn 3: still resting — the rest is TWO turns")
		ok(seq[3] == "spring", "turn 4: it re-arms and springs again")
		ok(sv.deadfall_armed == 2, "two of four charges are spent")
		_report.append("dormancy sequence over four enemy turns: %s" % \
			", ".join(seq))
	await _kill(scene)
	_live_ran += 1


func _live_perfect_gives_four() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	if sv != null:
		await _arm(scene, sv, "perfect")
		# BATCH CQ §3 — THIS PASSED FOR THE WRONG REASON AFTER CN'S FOLD: four
		# is now what EVERY rig arms, so the grade decides nothing here.
		ok(sv.deadfall_armed == 4, "a perfect rig arms four — as every rig does (reads %d)" % \
			sv.deadfall_armed)
		# It SETS rather than adds: a second cast does not stack a second trap.
		await _arm(scene, sv, "good")
		ok(sv.deadfall_armed == 4,
			"a further cast REPLACES the trap rather than stacking (reads %d)" % \
				sv.deadfall_armed)
	await _kill(scene)
	_live_ran += 1


# The ordinary boss rule, inherited rather than re-implemented — the spring
# passes no `force_stun`, so a boss shrugs it until Broken.
# BATCH CR §1 — AND SNARE TRAP IS THE SAME RULE NOW. This comment used to
# distinguish the deadfall from Snare Trap's perfect, which bought past the
# carve-out; CN orphaned that perfect and CR deleted it, so both traps ask the
# one Broken question. The distinction is gone, and its absence is the ruling.
func _live_boss_shrugs_unless_broken() -> void:
	var scene := await _spawn({}, ["boss"])
	var sv := _sv(scene)
	var boss: BattleUnit = scene.get("enemies")[0]
	ok(boss != null and boss.is_boss, "a boss stands")
	if sv != null and boss != null:
		scene.call("_spring_trap", sv, boss, 0.20 * sv.attack)
		ok(not boss.has_status("stunned"),
			"an unbroken boss shrugs the deadfall's stun")
		boss.broken = true
		scene.call("_spring_trap", sv, boss, 0.20 * sv.attack)
		ok(boss.has_status("stunned"), "a BROKEN boss does not")
		_report.append("boss: stun refused unbroken, lands once Broken")
	await _kill(scene)
	_live_ran += 1


# §2 — THREE TALENT NODES NOW PAY PER SPRING, AND THAT IS THREE TIMES WHAT THEY
# USED TO. None of them is changed here; what is measured is the TOTAL, so the
# next decision has the figure. Bone Breaker is the largest number in the batch.
func _live_nodes_pay_per_spring() -> void:
	var scene := await _spawn({"sv_bone": 1, "sv_cruel": 1, "sv_caught": 1})
	var sv := _sv(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	if sv != null:
		ok(sv.bone_breaker == 90, "Bone Breaker pays 90 Break (reads %d)" % \
			sv.bone_breaker)
		ok(sv.cruel_ranks == 50, "Cruel Devices pays +50%% (reads %d)" % sv.cruel_ranks)
		ok(sv.caught_fast == 5, "Caught Fast holds 5 turns (reads %d)" % sv.caught_fast)
		await _arm(scene, sv)
		var bd_total := 0.0
		var dmg_total := 0.0
		var springs := 0
		for _i in 12:
			foe.hp = foe.max_hp
			foe.remove_status("stunned")
			foe.remove_status("caught")
			sv.deadfall_dormant = 0
			var bd_before := _stat_of(scene, "bd_hero_" + sv.unit_name)
			var dm_before := _stat_of(scene, "dmg_hero_" + sv.unit_name)
			var sp_before := _stat_of(scene, "deadfall_springs")
			scene.call("_deadfall_tick", foe)
			if _stat_of(scene, "deadfall_springs") > sp_before:
				springs += 1
				bd_total += _stat_of(scene, "bd_hero_" + sv.unit_name) - bd_before
				dmg_total += _stat_of(scene, "dmg_hero_" + sv.unit_name) - dm_before
				ok(foe.has_status("caught"),
					"Caught Fast is re-applied on spring %d" % springs)
		ok(springs == 4, "four springs to pay for")
		ok(abs(bd_total - 360.0) < 0.5,
			"Bone Breaker pays 90 on EACH of four springs = 360 (read %.0f)" % bd_total)
		_report.append("§2 per-spring totals across a full deadfall: Bone Breaker %.0f Break (90 x 3) | trap damage %.0f (20%% of %d Attack, x1.5 Cruel Devices, three springs) | Caught Fast re-applied %d times for %d turns each" % [
			bd_total, dmg_total, sv.attack, springs, sv.caught_fast])
	await _kill(scene)
	_live_ran += 1


# THE SLOT RULE, BOTH HALVES. A charged deadfall is ONE occupant — not three,
# which is what the old field meaning would have made it — and it holds the slot
# until the last charge is gone.
func _live_cap_counts_a_deadfall_as_one() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	var snare: Ability = Classes.pool_ability("Snare Trap")
	var dfall: Ability = Classes.pool_ability("Deadfall")
	if sv != null:
		ok(bool(scene.call("_ability_usable", sv, snare)),
			"with nothing out, Snare Trap is allowed")
		await _arm(scene, sv)
		ok(sv.deadfall_armed == 4, "four charges are out")
		ok(not bool(scene.call("_ability_usable", sv, snare)),
			"at the base cap of ONE, an armed deadfall locks Snare Trap out")
		ok(not bool(scene.call("_ability_usable", sv, dfall)),
			"...and a second deadfall too")
		# Deadfall Network installs a cap of THREE. Three CHARGES must not read
		# as three occupants, or the node it is supposed to make valuable would
		# be spent on one trap.
		sv.deadfall_network = 3
		ok(bool(scene.call("_ability_usable", sv, snare)),
			"under Deadfall Network the three charges are ONE occupant, not three")
		# ...and the arithmetic composes: the deadfall's ONE plus real snares.
		# Three charges must not eat the cap the node exists to widen — this is
		# the half of the unit change that would fail quietly, so it is driven
		# with the other occupants present rather than in isolation.
		var idx: int = scene.get("heroes").find(sv)
		var foes: Array = scene.get("enemies")
		foes[0].add_status("snared", "Snared", "Sn", Color(0.75, 0.65, 0.30), -1,
			"", idx)
		ok(bool(scene.call("_ability_usable", sv, snare)),
			"a 3-charge deadfall plus ONE snare is 2 of 3 — a third trap is allowed")
		foes[1].add_status("snared", "Snared", "Sn", Color(0.75, 0.65, 0.30), -1,
			"", idx)
		ok(not bool(scene.call("_ability_usable", sv, snare)),
			"...plus a second snare fills the cap of three")
		foes[0].remove_status("snared")
		foes[1].remove_status("snared")
		sv.deadfall_network = 0
		_report.append("trap cap: a 4-charge deadfall counts as 1 occupant, and composes with snares")
	await _kill(scene)
	_live_ran += 1


func _live_slot_frees_on_the_last_charge() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	var snare: Ability = Classes.pool_ability("Snare Trap")
	if sv != null:
		await _arm(scene, sv)
		# BATCH CQ §3 — THE LOOP READS THE ARMED COUNT RATHER THAN A LITERAL.
		# It span three charges because that was the number CN's fold changed;
		# written this way the question ("the slot frees on the LAST charge,
		# whichever number that is") survives the next re-tune without a bump.
		var charges: int = sv.deadfall_armed
		for i in charges:
			foe.hp = foe.max_hp
			foe.remove_status("stunned")
			sv.deadfall_dormant = 0
			scene.call("_deadfall_tick", foe)
			if i < charges - 1:
				ok(not bool(scene.call("_ability_usable", sv, snare)),
					"with %d charge(s) left the slot is still held" % sv.deadfall_armed)
		ok(sv.deadfall_armed == 0, "the last charge is spent")
		ok(sv.deadfall_dormant == 0,
			"a spent trap does not sit dormant — it is gone, not resting")
		ok(bool(scene.call("_ability_usable", sv, snare)),
			"and the slot is FREE again")
	await _kill(scene)
	_live_ran += 1


# THE CHIP HAS TO SAY MORE THAN IT DID: charges remaining AND whether the trap
# is resting. A player who cannot see the deadfall is dormant for two turns
# cannot plan around it. NOTE the visible text is `short`, not `label`.
func _live_chip_shows_charges_and_rest() -> void:
	var scene := await _spawn()
	var sv := _sv(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	if sv != null:
		await _arm(scene, sv)
		var ready_txt := String(sv.get_status("deadfall").get("short", ""))
		ok(ready_txt == "DF4",
			"armed and ready reads the charge count (reads '%s')" % ready_txt)
		foe.hp = foe.max_hp
		scene.call("_deadfall_tick", foe)
		var st: Dictionary = sv.get_status("deadfall")
		var rest_txt := String(st.get("short", ""))
		# Three charges left, two turns of rest — the chip has to carry both.
		ok(rest_txt == "DF3\u00b72",
			"resting reads charges AND rest turns (reads '%s')" % rest_txt)
		ok(rest_txt != ready_txt,
			"...and it is visibly a different state from armed-and-ready")
		ok(String(st.get("desc", "")).to_upper().contains("RESTING"),
			"and the tooltip says so in words")
		_report.append("chip: ready '%s', resting '%s'" % [ready_txt, rest_txt])
	await _kill(scene)
	_live_ran += 1
