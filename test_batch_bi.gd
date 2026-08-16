# test_batch_bi.gd — THE TWO FAITH AXES STOP FIGHTING EACH OTHER. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bi.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# WHAT THE BATCH IS. BH gave the Faith lane a second axis to break its
# compounding, and the second axis was ANTAGONISTIC to the first because both
# read one meter: releases want the meter EMPTY, held value wants it FULL. §1
# decouples them — the held half reads `faith_peak`, the highest Faith an ally
# has held THIS BATTLE, so a release stops erasing the benefit it just spent.
# §2 decomposes Faith's sources before touching a rate, and then moves ONE rate.
#
# THE FOUR NEGATIVE CONTROLS, all of which would fail SILENTLY — every source
# level check in the project passes either way and the sim prints a plausible
# row:
#   · THE HELD VALUE READING THE CURRENT COUNT AGAIN. That is the whole batch
#     undone, and it looks like a smaller number rather than a bug.
#   · THE PEAK SURVIVING A BATTLE BOUNDARY. A peak is the one Faith term that
#     never falls on its own, so a missed reset follows a hero out of the fight
#     that raised it — the `rot` / `conviction_hp_gained` leak in a new field.
#   · FERVOR AND APOSTLE MULTIPLYING. `m *= 2` is the obvious edit and reaches
#     x4, which is the compounding fault this arc exists to remove rebuilt on
#     the new axis. A PRODUCT PASSES EVERY OTHER TEST IN THIS FILE.
#   · A PEAK RAISED BY THE DEVOUT'S OWN STACKS PAYING HIS ALLIES. BG's
#     carrier-keyed assertion, re-pointed at the new field rather than assumed
#     to transfer — which §1 asks for by name.
#
# Rates are MEASURED end to end (total damage over many casts) rather than read
# off the expression: a test that re-derives the formula it checks proves
# nothing. Damage carries a uniform ±10% roll, so every rate is a SUM over
# `HITS` casts — CLAUDE.md's standing trap is that one cast passes a wrong curve
# even with crit suppressed.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# §1's design numbers, in one place — battle.gd's two constants and the three
# values its multiplier can take.
const BASE_MITIGATION := 2.0    # % per peak stack
const BASE_DAMAGE := 1.5        # % per peak stack
const APOSTLE_MULT := 2         # base 1x + Apostle's 1x
const FERVOR_MULT := 2          # base 1x + Fervor's 1x
const BOTH_MULT := 3            # ADDITIVE — never 4
const STACKS := 4               # the deepest an ally can CARRY; five releases
# §2's one rate change.
const PER_ABSORB := 2
# Casts per measured rate. Damage rolls uniform ±10% (SD 5.8% of the mean), so
# a 400-cast sum has an SE of 0.29% and a ratio of two sums 0.41%; the ±2-point
# bands below are ~5 sigma and cannot flap.
const HITS := 400

var checks := 0
var fails: Array = []
# A live check that THROWS aborts its own function while the suite still prints
# "0 failures" (the BC trap). Every live function bumps this on its LAST line
# and the total is asserted.
var _live_ran := 0
const LIVE_CHECKS := 12
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
	Profile.save_path = "user://profile_batch_bi_test.json"
	Profile.loaded = false
	Profile.data = {}

	# ---- §1: source-level ----
	_the_field_exists_and_has_one_ratchet()
	_both_read_sites_read_the_peak()
	_the_multiplier_is_a_sum_not_a_product()
	_the_two_texts_state_the_peak_rule()
	# ---- §2: source-level ----
	_every_gain_names_its_source()
	_the_report_prints_the_table_and_its_denominators()

	# ---- §1: live ----
	await _live_the_peak_rises_with_the_stacks()
	await _live_the_peak_survives_a_release()
	await _live_mitigation_is_paid_from_the_peak_after_a_release()
	await _live_damage_is_paid_from_the_peak_after_a_release()
	await _live_the_peak_resets_at_battle_start()
	await _live_the_peak_follows_the_carrier()
	await _live_fervor_and_apostle_are_additive()
	await _live_the_new_per_stack_rates()
	# ---- §2: live ----
	await _live_conviction_pays_two_per_absorb()
	await _live_the_sources_sum_to_the_total()
	await _live_the_ground_and_absorb_denominators()
	await _live_the_devout_split_is_banked()

	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bi_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bi_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bi: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(Talents.LANE_TREES["inquisitor"], id)


func _run_obj():
	return root.get_node("/root/Run")


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


func _spawn(learned := {}) -> Node:
	var run = _run_obj()
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 2 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.combat_wins = 0
	run.pending_modifier = ""
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
		u.healing_received_mult = 1.0
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	scene.get("_b_slice").clear()
	scene.get("_b_bd_slice").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	await process_frame
	await process_frame


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


# Everything that could differ between the two arms of a ratio, reset before
# every cast — INCLUDING THE PEAK, which is the field this batch adds and the
# only Faith term that never falls on its own. An arm that left it set would
# carry its stacks into the next arm's control and the ratio would read 1.0.
func _neutral(scene: Node) -> void:
	for u in scene.get("heroes") + scene.get("enemies"):
		u.hp = u.max_hp
		u.second_resource = 0
		u.faith_stacks = 0
		u.faith_peak = 0
		u.remove_status("faith")
		u.remove_status("cons_ground")
		u.purge_debuffs()


func _ground(u: BattleUnit) -> void:
	u.add_status("cons_ground", "Consecrated Ground", "CG",
		Color(0.9, 0.85, 0.5), 5, "")


# Total damage the carrier LANDS over HITS casts at a PEAK of `peak`. `held` is
# what the count reads while doing it — the pair is what makes "the peak pays,
# not the count" measurable rather than assertable.
func _damage_dealt(scene: Node, carrier: BattleUnit, peak: int,
		held := -1, ground := false) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9_000_000
	var key := "dmg_hero_" + carrier.unit_name
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		if ground:
			_ground(carrier)
		foe.hp = foe.max_hp
		carrier.faith_stacks = peak if held < 0 else held
		carrier.faith_peak = peak
		await scene.call("_resolve", carrier, carrier.abilities[0], foe, "good")
	return _stat_of(scene, key)


# Total damage the carrier TAKES over HITS enemy casts, same pair.
func _damage_taken(scene: Node, carrier: BattleUnit, peak: int,
		held := -1, ground := false) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	var ab = scene.call("_cheapest_attack", foe)
	carrier.max_hp = 9_000_000
	var total := 0.0
	for _i in HITS:
		_neutral(scene)
		if ground:
			_ground(carrier)
		carrier.hp = carrier.max_hp
		carrier.faith_stacks = peak if held < 0 else held
		carrier.faith_peak = peak
		await scene.call("_resolve", foe, ab, carrier, "good")
		total += float(carrier.max_hp - carrier.hp)
	return total


# ---------- §1: source-level ----------

# ONE FIELD, ONE RATCHET, ONE RESET. A second writer is how the peak and the
# count drift apart, and drift here is invisible — every number stays plausible.
func _the_field_exists_and_has_one_ratchet() -> void:
	var usrc := _src("res://scripts/unit.gd")
	ok(usrc.contains("var faith_peak := 0"),
		"§1: unit.gd carries `faith_peak`")
	var bsrc := _src("res://scripts/battle.gd")
	# RE-POINTED BY BATCH CE AND AGAIN BY BATCH CG, AND THE QUESTION IT ASKS IS
	# THE SAME ONE THROUGHOUT. §1's rule is that the peak FOLLOWING THE COUNT has
	# exactly one site, so the two can never drift apart — and drift here is
	# invisible, because every number stays plausible. CE's ELEVATION wrote the
	# peak WITHOUT the count on purpose, so a bare count of the assignment read
	# two; CG §2 made that card a plain Faith grant and DELETED `_raise_faith_
	# peak` with it, so the peak-only writer is pinned ABSENT rather than pinned
	# to one, and the assignment count is back to ONE.
	ok(bsrc.count("u.faith_peak = maxi(u.faith_peak, u.faith_stacks)") == 1,
		"§1: exactly ONE site raises the peak FROM the count")
	ok(not bsrc.contains("func _raise_faith_peak("),
		"§1: ...and CG deleted the peak-only writer rather than leaving it dead")
	ok(bsrc.count("u.faith_peak = maxi(") == 1,
		"§1: the peak is RAISED in exactly ONE place (found %d)"
			% bsrc.count("u.faith_peak = maxi("))
	# BATCH CG §2 — AND EXACTLY ONE SITE LOWERS ONE, WHICH IS NEW. Blessing of
	# the Faithful drops his high-water mark to match the count it spends, and
	# that is a DELIBERATE EXCEPTION to §1 rather than a reversal of it: the
	# surrender is named on the card and paid once by one cast, where BI's repair
	# was that a RELEASE must not silently cost held value. The release branch
	# still leaves every peak standing, and this pins that only one site does it.
	ok(bsrc.count("attacker.faith_peak = 0") == 1,
		"§1: exactly ONE site LOWERS a peak, and it is the card that names it")
	ok(bsrc.contains("func _reset_faith_meters() -> void:"),
		"§1: the reset is its own function, drivable headlessly")
	ok(bsrc.count("_reset_faith_meters()") == 2,
		"§1: ...with one definition and one caller (found %d)"
			% bsrc.count("_reset_faith_meters()"))
	# It must reset the two TOGETHER — a reset that cleared one is the drift.
	var i := bsrc.find("func _reset_faith_meters()")
	var body := bsrc.substr(i, 300)
	ok(body.contains("h.faith_stacks = 0") and body.contains("h.faith_peak = 0"),
		"§1: ...and it zeroes the count and the peak together")
	# The reset runs BEFORE the opening oath, which GRANTS Faith.
	var r := bsrc.find("\t_reset_faith_meters()")
	var o := bsrc.find("\t_swear_opening_oath()")
	ok(r > 0 and o > r,
		"§1: the reset runs before the opening oath, which grants Faith")


# THE FIRST NEGATIVE CONTROL, AT THE SOURCE: neither damage site may read the
# current count. Reading `faith_stacks` again is the whole batch undone and it
# reads as a smaller number rather than as a fault.
func _both_read_sites_read_the_peak() -> void:
	var src := _src("res://scripts/battle.gd")
	# BATCH BM RE-POINTED THESE THREE IN PLACE. BI's rule is UNCHANGED and is
	# what the check still asks: the held half reads a PEAK, never the current
	# count. What moved is that CREED (Devout, Faith row 8) made "whose peak"
	# a question with two answers — his own, or the party's highest — so both
	# sites go through `_faith_paid_peak`, ONE function, exactly so the damage
	# half and the mitigation half cannot disagree. The negative control below
	# is untouched and is the half that matters.
	ok(src.contains("_faith_stack_mult(fd_dv, attacker) * _faith_paid_peak(attacker)"),
		"§1: the damage site is paid from a PEAK, through the one function")
	ok(src.contains("_faith_stack_mult(fp_dv, strike_target) * _faith_paid_peak(strike_target)"),
		"§1: the mitigation site is paid from a PEAK, through the same one")
	ok(not src.contains("* attacker.faith_stacks")
			and not src.contains("* strike_target.faith_stacks"),
		"§1: NEGATIVE CONTROL — neither site multiplies by the CURRENT count")
	ok(src.contains("if attacker.is_hero and _faith_paid_peak(attacker) > 0:")
			and src.contains("if strike_target.is_hero and _faith_paid_peak(strike_target) > 0:"),
		"§1: ...and both gates are the peak too, so a released ally still pays")


# THE NEGATIVE CONTROL THE BATCH MOST NEEDS, half of it at the source. A product
# passes every live rate check that does not measure BOTH nodes at once, so the
# shape of the expression is asserted as well as its result.
func _the_multiplier_is_a_sum_not_a_product() -> void:
	var src := _src("res://scripts/battle.gd")
	var i := src.find("func _faith_stack_mult(")
	ok(i > 0, "§1: the multiplier has one home")
	var body := src.substr(i, src.find("func _faith_pct_text(") - i)
	ok(body.contains("m += 1") and not body.contains("m *= 2"),
		"§1: NEGATIVE CONTROL — the multiplier ADDS its bonuses; it does not multiply")
	ok(body.count("m += 1") == 2,
		"§1: ...one addend for Apostle and one for Fervor (found %d)"
			% body.count("m += 1"))
	ok(body.contains("var m := 1"),
		"§1: ...on a base of 1, so neither node alone is worth more than double")
	# The two magnitudes are constants and are the new ones.
	ok(src.contains("const FAITH_MITIGATION_PCT := 2.0")
			and src.contains("const FAITH_DAMAGE_PCT := 1.5"),
		"§1: the two per-stack rates came down with the peak-reading")


# A PLAYER MEETS THE RULE BEFORE ANY NUMBER. The held benefit persisting past
# the release that spent it is a change to what the RESOURCE IS, so the status
# chip default, the passive block, the two nodes and the glossary all say so.
func _the_two_texts_state_the_peak_rule() -> void:
	var bsrc := _src("res://scripts/battle.gd")
	var i := bsrc.find("\"faith\": [\"Faith\"")
	ok(i > 0, "§1: the Faith status default is findable")
	ok(bsrc.substr(i, 400).contains("HIGHEST count held this battle"),
		"§1: the status default states the peak rule")
	var csrc := _src("res://scripts/classes.gd")
	var j := csrc.find("\"passive_desc\": \"Conviction:")
	ok(j > 0 and csrc.substr(j, 700).contains("HIGHEST COUNT HELD THIS BATTLE"),
		"§1: ...and so does Conviction's passive block")
	ok(csrc.substr(j, 700).contains("2 a hit"),
		"§1: ...which also states §2's new absorb rate")
	# The two doubling nodes must not promise a quadruple any more.
	var fd := Talents.desc_for(_node("dv_fervor"), 1)
	var ad := Talents.desc_for(_node("dv_apostle"), 1)
	ok(fd.to_lower().contains("triple") and not fd.to_lower().contains("quadruple"),
		"§1: Fervor's text says TRIPLE and never quadruple")
	ok(fd.contains("%d%%" % (BASE_MITIGATION * FERVOR_MULT))
			and fd.contains("+%d%%" % (BASE_DAMAGE * FERVOR_MULT)),
		"§1: ...and states its own doubled pair at the new rates")
	ok(ad.contains("%d%%" % (BASE_MITIGATION * APOSTLE_MULT))
			and ad.contains("+%d%%" % (BASE_DAMAGE * APOSTLE_MULT)),
		"§1: Apostle's text states its doubled pair at the new rates")
	ok(ad.to_lower().contains("highest count held"),
		"§1: ...and that a release never takes the value away")
	var glossary := _src("res://data/glossary.json")
	ok(glossary.contains("faith_peak") or glossary.to_lower().contains("highest"),
		"§1: the glossary's Faith entry carries the peak rule")


# ---------- §2: source-level ----------

# EVERY CALLER NAMES ITS SOURCE, AND THE PARAMETER HAS NO DEFAULT. A default is
# how a later Faith generator lands silently in the wrong bucket — the table
# would still sum, and it would still be wrong.
func _every_gain_names_its_source() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("func _gain_faith(u: BattleUnit, n: int, source: String) -> void:"),
		"§2: `_gain_faith` takes a source and does not default it")
	for pair in [["_gain_faith(u, 1, \"ground\")", "the ground's drip"],
			["_gain_faith(holder, FAITH_PER_ABSORB, \"absorb\")", "Conviction's absorbs"],
			["_gain_faith(h, 1, \"communion\")", "Communion"],
			["_gain_faith(saved, maxi(devout.covenant_faith, 1), \"covenant\")", "Sacred Covenant"],
			["_gain_faith(devout, devout.oath_faith, \"oath\")", "Binding Oath"],
			["_gain_faith(devout, devout.oath_opening, \"opening\")", "the opening rune"]]:
		ok(src.contains(String(pair[0])),
			"§2: %s names itself" % String(pair[1]))
	# The total and the term are written by ONE call, so they cannot disagree.
	var i := src.find("func _faith_gained(")
	ok(i > 0, "§2: Faith is booked through one door")
	var body := src.substr(i, 700)
	ok(body.contains("_stat(\"faith_gained_total\"") \
			and body.contains("_stat(\"faith_gained_\" + source"),
		"§2: ...which writes the total and the named term together")
	ok(src.contains("const FAITH_PER_ABSORB := %d" % PER_ABSORB),
		"§2: an absorbed hit pays %d Faith" % PER_ABSORB)


# THE DELIVERABLE IS THE TABLE. A decomposition that is computed and not printed
# is a decomposition nobody reads.
func _the_report_prints_the_table_and_its_denominators() -> void:
	var src := _src("res://scripts/battle.gd")
	var i := src.find("static func faith_report_line(")
	ok(i > 0, "§2: the report line is findable")
	var body := src.substr(i, src.find("# Sweep report") - i)
	for term in ["absorb", "ground", "communion", "covenant", "oath", "opening"]:
		ok(body.contains("[\"%s\", " % term),
			"§2: the table prints the %s term" % term)
	ok(body.contains("faith_absorb_hits") and body.contains("faith_ground_turns")
			and body.contains("faith_hero_turns"),
		"§2: ...and the two denominators that make the terms readable")
	ok(body.contains("faith_gained_devout"),
		"§2: ...and the share that lands on the Devout's own non-releasing meter")


# ---------- §1: live ----------

# The ratchet itself: it follows the count up and does not follow it down.
func _live_the_peak_rises_with_the_stacks() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	for i in 4:
		scene.call("_gain_faith", ally, 1, "absorb")
		ok(ally.faith_peak == i + 1,
			"§1: %d gain(s) put the peak at %d (reads %d)"
				% [i + 1, i + 1, ally.faith_peak])
	# A gain that the cap throws away must not raise the peak past five.
	ally.faith_stacks = 0
	ally.faith_peak = 5
	scene.call("_gain_faith", ally, 3, "absorb")
	ok(ally.faith_peak == 5,
		"§1: the peak is capped at five with the count (reads %d)" % ally.faith_peak)
	await _kill(scene)
	_live_ran += 1


# THE LINE THE WHOLE BATCH TURNS ON: a release resets the count and leaves the
# peak standing. Before this, the release erased the held benefit it paid for —
# which is why the lane's two axes were fighting.
func _live_the_peak_survives_a_release() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	ally.faith_stacks = 4
	ally.faith_peak = 4
	scene.get("sim_stats").clear()
	scene.call("_gain_faith", ally, 1, "absorb")
	ok(_stat_of(scene, "faith_releases") == 1.0,
		"§1: the fifth stack released (%d)" % int(_stat_of(scene, "faith_releases")))
	ok(ally.faith_stacks == 0,
		"§1: ...the COUNT resets to zero (left at %d)" % ally.faith_stacks)
	ok(ally.faith_peak == 5,
		"§1: ...and the PEAK does not fall with it (reads %d)" % ally.faith_peak)
	ok(ally.has_status("faith"),
		"§1: ...and the chip stays up, because the peak still pays")
	_report.append("release: count %d, peak %d" % [ally.faith_stacks, ally.faith_peak])
	await _kill(scene)
	_live_ran += 1


# ...and the benefit itself, MEASURED, at a count of zero. This is the check the
# first negative control fails: read the current count and this arm reads 0%.
func _live_mitigation_is_paid_from_the_peak_after_a_release() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(_devout(scene) != null, "§1: the Devout stands (Faith pays nothing if not)")
	var bare := await _damage_taken(scene, ally, 0)
	# peak five, count ZERO — exactly the state a release leaves behind.
	var released := await _damage_taken(scene, ally, 5, 0)
	var cut := 100.0 * (1.0 - released / maxf(bare, 1.0))
	var want := BASE_MITIGATION * 5.0
	_report.append("§1 mitigation on a peak of 5 at a count of 0: %.1f%% (want %.0f)"
		% [cut, want])
	ok(absf(cut - want) < 2.0,
		"§1: a released ally still mitigates %.0f%% off a peak of five (measured %.1f%%)"
			% [want, cut])
	ok(cut > 2.0,
		"§1: NEGATIVE CONTROL — reading the CURRENT count would pay nothing here (%.1f%%)"
			% cut)
	await _kill(scene)
	_live_ran += 1


func _live_damage_is_paid_from_the_peak_after_a_release() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	var bare := await _damage_dealt(scene, ally, 0)
	var released := await _damage_dealt(scene, ally, 5, 0)
	var up := 100.0 * (released / maxf(bare, 1.0) - 1.0)
	var want := BASE_DAMAGE * 5.0
	_report.append("§1 damage dealt on a peak of 5 at a count of 0: +%.1f%% (want +%.1f)"
		% [up, want])
	ok(absf(up - want) < 2.0,
		"§1: a released ally still deals +%.1f%% off a peak of five (measured +%.1f%%)"
			% [want, up])
	ok(up > 2.0,
		"§1: NEGATIVE CONTROL — reading the CURRENT count would pay nothing here (+%.1f%%)"
			% up)
	await _kill(scene)
	_live_ran += 1


# THE SECOND NEGATIVE CONTROL. The peak never falls inside a battle, so the only
# thing that can lower it is the boundary — and a peak that crossed one would
# follow the hero out of the fight that raised it, which is the `rot` leak in a
# new field. Driven through the real function, not asserted from the default.
func _live_the_peak_resets_at_battle_start() -> void:
	var scene := await _spawn()
	var dv := _devout(scene)
	for h in scene.get("heroes"):
		h.faith_stacks = 3
		h.faith_peak = 5
	ok(dv != null and dv.faith_peak == 5, "§1: the meters are dirty before the reset")
	scene.call("_reset_faith_meters")
	var peaks := 0
	var counts := 0
	for h in scene.get("heroes"):
		peaks += h.faith_peak
		counts += h.faith_stacks
		if h.has_status("faith"):
			peaks += 100
	ok(peaks == 0,
		"§1: NEGATIVE CONTROL — no peak survives the battle boundary (sum %d)" % peaks)
	ok(counts == 0, "§1: ...and neither does a count (sum %d)" % counts)
	await _kill(scene)
	_live_ran += 1


# THE FOURTH NEGATIVE CONTROL, AND §1 ASKS FOR IT BY NAME: BG's carrier-keyed
# assertion, re-pointed at the new field rather than assumed to transfer. An
# ally's peak pays that ally; the Devout's own peak — he holds Faith of his own
# under Binding Oath since BH — pays HIM and nobody else. The mis-write is to
# read the Devout's peak at either damage site, and it would leave every ally
# unpaid while `_faith_stack_mult`, both constants and the chip all looked right.
func _live_the_peak_follows_the_carrier() -> void:
	var scene := await _spawn({"dv_apostle": 1})
	var dv := _devout(scene)
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(dv != null and dv.apostle > 0, "§1: the Devout stands with Apostle learned")
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9_000_000
	var key := "dmg_hero_" + ally.unit_name

	var bare := await _damage_dealt(scene, ally, 0)
	# Arm 1 — the ALLY holds the peak, the Devout is empty.
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		foe.hp = foe.max_hp
		ally.faith_peak = STACKS
		dv.faith_peak = 0
		await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	var carried := _stat_of(scene, key)
	# Arm 2 — the peak is all on the DEVOUT and the ally holds none.
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		foe.hp = foe.max_hp
		ally.faith_peak = 0
		dv.faith_peak = STACKS
		await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	var lent := _stat_of(scene, key)

	var want := 1.0 + 0.01 * BASE_DAMAGE * APOSTLE_MULT * STACKS
	ok(absf(carried / maxf(bare, 1.0) - want) < 0.03,
		"§1: the ally is paid on HIS OWN peak with the Devout empty (+%.1f%%, want +%.0f%%)"
			% [100.0 * (carried / maxf(bare, 1.0) - 1.0), 100.0 * (want - 1.0)])
	ok(absf(lent / maxf(bare, 1.0) - 1.0) < 0.03,
		"§1: NEGATIVE CONTROL — a peak on the DEVOUT pays the ally nothing (%.1f%%)"
			% (100.0 * (lent / maxf(bare, 1.0) - 1.0)))
	_report.append("§1 carrier-keyed peak: ally +%.1f%% on his own four | +%.1f%% on the Devout's four (want 12 / 0)"
		% [100.0 * (carried / maxf(bare, 1.0) - 1.0),
			100.0 * (lent / maxf(bare, 1.0) - 1.0)])
	await _kill(scene)
	_live_ran += 1


# THE THIRD NEGATIVE CONTROL, MEASURED. Both nodes double the held value; a
# PRODUCT reaches x4 and would pass every other check in this file, because
# every other check exercises at most one of them at a time.
func _live_fervor_and_apostle_are_additive() -> void:
	var scene := await _spawn({"dv_fervor": 1, "dv_apostle": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	var base_off := await _damage_taken(scene, ally, 0, -1, false)
	var base_on := await _damage_taken(scene, ally, 0, -1, true)
	var off := await _damage_taken(scene, ally, STACKS, -1, false)
	var on := await _damage_taken(scene, ally, STACKS, -1, true)
	var cut_off := 100.0 * (1.0 - off / base_off)
	var cut_on := 100.0 * (1.0 - on / base_on)
	var want_off := BASE_MITIGATION * APOSTLE_MULT * STACKS
	var want_on := BASE_MITIGATION * BOTH_MULT * STACKS
	var would_be_x4 := BASE_MITIGATION * 4 * STACKS
	_report.append("§1 Fervor + Apostle at %d stacks: Apostle alone %.1f%% (want %.0f), both %.1f%% (want %.0f — x3; a PRODUCT would read %.0f)"
		% [STACKS, cut_off, want_off, cut_on, want_on, would_be_x4])
	ok(absf(cut_off - want_off) < 2.0,
		"§1: Apostle alone doubles to %.0f%% (measured %.1f%%)" % [want_off, cut_off])
	ok(absf(cut_on - want_on) < 2.5,
		"§1: the two TRIPLE, not quadruple — %.0f%% (measured %.1f%%)"
			% [want_on, cut_on])
	ok(absf(cut_on - would_be_x4) > 2.5,
		"§1: NEGATIVE CONTROL — they do NOT multiply to x4 (%.0f%% would; measured %.1f%%)"
			% [would_be_x4, cut_on])
	ok(absf(cut_on - BASE_MITIGATION * 2 * STACKS) > 2.5,
		"§1: ...and do not take the larger of the two either")
	# Fervor alone, so the base of the sum is checked from the other side.
	await _kill(scene)
	scene = await _spawn({"dv_fervor": 1})
	ally = scene.get("heroes")[0]
	var f_base := await _damage_taken(scene, ally, 0, -1, true)
	var f_on := await _damage_taken(scene, ally, STACKS, -1, true)
	var f_cut := 100.0 * (1.0 - f_on / f_base)
	ok(absf(f_cut - BASE_MITIGATION * FERVOR_MULT * STACKS) < 2.0,
		"§1: Fervor alone doubles to %.0f%% (measured %.1f%%)"
			% [BASE_MITIGATION * FERVOR_MULT * STACKS, f_cut])
	await _kill(scene)
	_live_ran += 1


# The two magnitudes themselves, end to end and un-doubled, because §1 lowered
# them and a stale constant is the quietest possible failure.
func _live_the_new_per_stack_rates() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	var m_bare := await _damage_taken(scene, ally, 0)
	var m_held := await _damage_taken(scene, ally, STACKS)
	var d_bare := await _damage_dealt(scene, ally, 0)
	var d_held := await _damage_dealt(scene, ally, STACKS)
	var cut := 100.0 * (1.0 - m_held / maxf(m_bare, 1.0))
	var up := 100.0 * (d_held / maxf(d_bare, 1.0) - 1.0)
	_report.append("§1 base rates at %d: %.1f%% mitigation (want %.0f) | +%.1f%% damage (want +%.0f)"
		% [STACKS, cut, BASE_MITIGATION * STACKS, up, BASE_DAMAGE * STACKS])
	ok(absf(cut - BASE_MITIGATION * STACKS) < 2.0,
		"§1: a stack mitigates %.0f%% (measured %.1f%% at four)"
			% [BASE_MITIGATION, cut])
	ok(absf(up - BASE_DAMAGE * STACKS) < 2.0,
		"§1: ...and adds +%.1f%% damage (measured +%.1f%% at four)"
			% [BASE_DAMAGE, up])
	await _kill(scene)
	_live_ran += 1


# ---------- §2: live ----------

# §2's one rate change, driven through the real callback rather than the log.
func _live_conviction_pays_two_per_absorb() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	scene.get("sim_stats").clear()
	scene.call("_on_shield_absorbed", ally)
	ok(ally.faith_stacks == PER_ABSORB,
		"§2: one absorbed hit pays %d Faith (paid %d)" % [PER_ABSORB, ally.faith_stacks])
	ok(_stat_of(scene, "faith_absorb_hits") == 1.0,
		"§2: ...and the absorb denominator counted the HIT, not the Faith (%.0f)"
			% _stat_of(scene, "faith_absorb_hits"))
	# Three absorbs reach five and release — the whole point of the change.
	scene.call("_on_shield_absorbed", ally)
	ok(_stat_of(scene, "faith_releases") == 0.0,
		"§2: two absorbs are four Faith and do not release yet")
	scene.call("_on_shield_absorbed", ally)
	ok(_stat_of(scene, "faith_releases") == 1.0,
		"§2: ...and the THIRD releases, where it used to take five (%.0f)"
			% _stat_of(scene, "faith_releases"))
	_report.append("§2 absorbs to a release: 3 (was 5); Faith banked from absorbs across the three: %.0f (the third is capped at five)"
		% _stat_of(scene, "faith_gained_absorb"))
	await _kill(scene)
	_live_ran += 1


# THE CHECK THAT MAKES THE DECOMPOSITION A DECOMPOSITION, on BC's pattern: the
# named terms must SUM to the total. A term missed reads as a smaller sum and a
# term double-booked as a larger one, and either sends a repair at the wrong
# source — which is the exact failure §2 exists to stop repeating.
func _live_the_sources_sum_to_the_total() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_oath": 1, "dv_covenant": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	var ally: BattleUnit = heroes[0]
	var other: BattleUnit = heroes[1]
	ok(dv != null, "§2: the Devout stands")
	_neutral(scene)
	scene.get("sim_stats").clear()
	# Every door, driven: an absorb, the ground's tick, a release (which pays
	# Binding Oath and rolls Communion), and a lethal save.
	scene.call("_on_shield_absorbed", ally)
	_ground(other)
	scene.call("_ground_faith_tick", other)
	ally.faith_stacks = 4
	ally.faith_peak = 4
	scene.call("_gain_faith", ally, 1, "absorb")
	scene.call("_on_lethal_saved", other)
	var total := _stat_of(scene, "faith_gained_total")
	var summed := 0.0
	for t in ["absorb", "ground", "communion", "covenant", "oath", "opening"]:
		summed += _stat_of(scene, "faith_gained_" + t)
	ok(total > 0.0, "§2: some Faith was gained to sum (%.0f)" % total)
	ok(is_equal_approx(summed, total),
		"§2: the six named sources sum to the total (%.0f vs %.0f)" % [summed, total])
	_report.append("§2 source sum %.0f vs total %.0f" % [summed, total])
	await _kill(scene)
	_live_ran += 1


# The two denominators, driven at their own sites. The ground's is the one the
# brief guessed at — "up about two thirds of the time at best" — so it has to be
# a measurement rather than a claim.
func _live_the_ground_and_absorb_denominators() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	scene.get("sim_stats").clear()
	# Three turn-starts off the ground, two on it.
	for _i in 3:
		scene.call("_ground_faith_tick", ally)
	ok(_stat_of(scene, "faith_hero_turns") == 3.0,
		"§2: hero turn-starts are counted whether the ground is up or not (%.0f)"
			% _stat_of(scene, "faith_hero_turns"))
	ok(_stat_of(scene, "faith_ground_turns") == 0.0,
		"§2: ...and none of them counted as ground turns")
	ok(_stat_of(scene, "faith_gained_ground") == 0.0,
		"§2: ...and no drip was paid off the ground")
	_ground(ally)
	for _i in 2:
		scene.call("_ground_faith_tick", ally)
	ok(_stat_of(scene, "faith_hero_turns") == 5.0,
		"§2: five turn-starts in all (%.0f)" % _stat_of(scene, "faith_hero_turns"))
	ok(_stat_of(scene, "faith_ground_turns") == 2.0,
		"§2: ...two of them on the ground (%.0f)" % _stat_of(scene, "faith_ground_turns"))
	ok(_stat_of(scene, "faith_gained_ground") == 2.0,
		"§2: ...paying the flat 1 a turn AW §2 shipped (%.0f)"
			% _stat_of(scene, "faith_gained_ground"))
	await _kill(scene)
	_live_ran += 1


# Faith paid onto the DEVOUT buys held value and can never become a release
# (his count holds at five, Batch BH §2). A table that mixed the two would read
# as a healthy gain rate feeding a dry payout — which is the shape §2 is trying
# to diagnose, so it must not be able to fake it.
func _live_the_devout_split_is_banked() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var dv := _devout(scene)
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(dv != null and dv.oath_faith > 0, "§2: Binding Oath is learned")
	_neutral(scene)
	scene.get("sim_stats").clear()
	ally.faith_stacks = 4
	ally.faith_peak = 4
	scene.call("_gain_faith", ally, 1, "absorb")
	ok(_stat_of(scene, "faith_gained_oath") == 1.0,
		"§2: the release swore the Devout a stack, booked to `oath` (%.0f)"
			% _stat_of(scene, "faith_gained_oath"))
	ok(_stat_of(scene, "faith_gained_devout") == 1.0,
		"§2: ...and that stack is booked as landing on HIS meter (%.0f)"
			% _stat_of(scene, "faith_gained_devout"))
	ok(_stat_of(scene, "faith_gained_absorb") == 1.0,
		"§2: ...while the ally's own gain stays on `absorb` (%.0f)"
			% _stat_of(scene, "faith_gained_absorb"))
	await _kill(scene)
	_live_ran += 1
