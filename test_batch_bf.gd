# test_batch_bf.gd — THE INSTRUMENT LEARNS TO SEE BREAK, AND COMMUNION STOPS
# ROLLING FOR ALLIES WHO ARE ALREADY AT THE PAYOUT. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bf.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# TWO CHANGES, AND ONE OF THEM CHANGES NO GAMEPLAY AT ALL:
#
# §1 is a MEASUREMENT change. Two new columns — Break dealt as a share, Break
# prevented per battle — and the control that makes them readable is that the
# OLD share does not move by a point. Every check below that looks redundant is
# there for that reason: the interesting failure is not "the new column is
# wrong", it is "the new column quietly moved the old one".
#
# §2 is one condition on one node: Communion no longer rolls for an ally
# already at five Faith. The two rates that bracket it (60% at four, 0% at
# five) are MEASURED over driven releases rather than read off the expression —
# a test that re-derives the formula it checks proves nothing.
#
# THE NEGATIVE CONTROLS THIS SUITE IS BUILT TO CATCH, both of which would fail
# silently in a sim report:
#   · Break folded into the damage-healing-prevented share (it would simply
#     read higher, and nothing would crash);
#   · Communion still rolling for a parked ally (the row would land outside its
#     bracket and look like a mis-tune rather than a missing condition).
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# §2's design numbers, in one place. The chance is (15 x the recipient's own
# stacks)%, so four stacks is 60% — and five is now nothing at all.
const COMMUNION := 15
const RATE_AT_FOUR := 0.60
# Trials per measured rate. At p=0.60 the 3-sigma band is +/-4.2 points against
# the +/-5 asserted below, so the band cannot flap.
const TRIALS := 1200

var checks := 0
var fails: Array = []
# A live check that THROWS mid-way aborts its own function while the suite
# still prints "0 failures" — the CLAUDE.md trap that fakes a clean pass. Every
# live function bumps this on its LAST line, and the count is asserted.
var _live_ran := 0
const LIVE_CHECKS := 6
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
var _report: Array = []


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
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
	Profile.save_path = "user://profile_batch_bf_test.json"
	Profile.loaded = false
	Profile.data = {}

	# §1 — the instrument
	_one_door_for_break_prevented()
	_break_stays_out_of_the_old_share()
	_the_share_is_labelled_for_what_it_is()
	_the_break_share_sums_to_one()
	_every_reducer_has_a_term()
	# §2 — the condition
	_the_condition_is_at_the_gate()
	_the_tooltip_states_the_cliff()

	await _live_bulwark_reaches_the_prevented_door()
	await _live_break_never_enters_the_contribution_slice()
	await _live_break_dealt_pools_apart_from_damage()
	await _live_rate_at_four_stacks()
	await _live_never_rolls_at_five()
	await _live_guard_is_still_a_reentrancy_lock()
	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bf_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bf_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bf: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(Talents.LANE_TREES["inquisitor"], id)


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


# One spawn for every live check. `learned` lands on the Cleric slot, which is
# where the Devout stands.
func _spawn(learned := {}) -> Node:
	var run := root.get_node("/root/Run")
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
		u.healing_received_mult = 1.0
	# `_stat` only banks into sim_stats while `sim` is true.
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	scene.get("_b_slice").clear()
	scene.get("_b_bd_slice").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


# EXACTLY ONE ally may be eligible for the roll, or a measured rate is the rate
# of "at least one of several fired". The Devout is zeroed too — he is in
# `heroes` and Communion walks all of them.
func _isolate(scene: Node, target: BattleUnit, stacks: int) -> void:
	for h in scene.get("heroes"):
		h.faith_stacks = 0
		h.remove_status("faith")
		h.hp = h.max_hp
	target.faith_stacks = stacks


# ---------- §1: the instrument ----------

# ONE DOOR, on BC's `_devout_prev` pattern: the per-hero total and the per-term
# breakdown are written by the SAME call, so the parts can never disagree with
# the total. The failure this prevents is a site that banks one and forgets the
# other, which is how `faith_break_cut` came to be the only Break number in the
# game while five other effects paid in the same currency.
func _one_door_for_break_prevented() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.count("func _prev_bd(") == 1, "§1: there is exactly one Break door")
	var door := src.find("func _prev_bd(")
	var body := src.substr(door, 420)
	ok(body.contains("_stat(\"bdprev_hero_\" + nm, cut)"),
		"§1: it banks the per-hero total")
	ok(body.contains("_stat(\"bdprev_\" + term, cut)"),
		"§1: ...and the named term, in the same call")
	# Nothing else in the game may write either key.
	ok(src.count("\"bdprev_hero_\"") == 2,
		"§1: `bdprev_hero_` is written at the door and read at the table, nowhere else")
	ok(src.count("_stat(\"bdprev_") == 2,
		"§1: no site banks a Break-prevented key behind the door's back")
	# unit.gd's side of it: one helper, and the `bd_` prefix is the routing rule.
	var usrc := _src("res://scripts/unit.gd")
	ok(usrc.count("func _credit_bd(") == 1,
		"§1: unit.gd credits Break through one helper")
	ok(src.contains("if term.begins_with(\"bd_\"):"),
		"§1: the `bd_` prefix routes a term to the Break door")


# THE CONTROL THAT MAKES THE NEW COLUMNS READABLE. Break points and hit points
# are different units; folding them together needs an exchange rate nobody can
# defend, and the old share must be provably untouched or every number measured
# after this batch is uncomparable with every number measured before it.
func _break_stays_out_of_the_old_share() -> void:
	var src := _src("res://scripts/battle.gd")
	# The share itself, unchanged: damage + healing + damage-prevented over the
	# same three pooled.
	ok(src.contains("100.0 * (dmg + heal + prev) / apool])"),
		"§1: the old share is still (dmg + heal + prev) / the same three, pooled")
	# The pool still accumulates exactly three prefixes...
	ok(src.contains("if key.begins_with(\"dmg_hero_\") or key.begins_with(\"heal_hero_\") \\"),
		"§1: the share pool takes damage, healing and prevented")
	ok(src.contains("or key.begins_with(\"prev_hero_\"):"),
		"§1: ...three keys, and no Break key is one of them")
	# ...and the Break slice is a SEPARATE dict, so `b_all_total`'s wholesale
	# `for k in _b_slice` loop cannot rake Break into the pool by accident.
	ok(src.contains("var _b_bd_slice := {}"),
		"§1: Break dealt banks into its own battle slice")
	ok(src.contains("elif key.begins_with(\"bd_hero_\"):"),
		"§1: ...on its own branch, beneath the three-prefix branch")
	# The naming rule that keeps the two apart under `begins_with`.
	ok(not "bdprev_hero_".begins_with("prev_hero_"),
		"§1: `bdprev_hero_` cannot be mistaken for `prev_hero_` by a prefix test")


# At least one number in this project's history was read as "share of the
# party's work". It never was one. The header says so now, wherever it prints.
func _the_share_is_labelled_for_what_it_is() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("d+h+p%"), "§1: the column is named for its three terms")
	ok(not src.contains("st/b  contrib%"),
		"§1: and `contrib%` no longer heads it")
	ok(src.contains("It is NOT a share of the party's work"),
		"§1: the table says outright what it is not")
	# One table, three reports — so the label reaches all of them and cannot be
	# added to one and forgotten in another.
	ok(src.count("_contrib_table(") == 3,
		"§1: the standalone report and the sweep both print the one table")
	ok(_src("res://scripts/run_sim.gd").contains("battle._contrib_table("),
		"§1: ...and so does RunSim's")
	# The Break audit line reaches the same three.
	ok(src.count("break_prevented_line(") == 3,
		"§1: the Break-prevented audit prints in the standalone report and the sweep")
	ok(_src("res://scripts/run_sim.gd").contains("battle.break_prevented_line("),
		"§1: ...and in RunSim's")


# THE BREAK-DEALT SHARE, AS ARITHMETIC: it must sum to 1.0 across the party and
# it must agree with the `BD/b` column beside it, which is the same number over
# a different divisor. Driven through the real table on a synthetic dict, so
# the check is of the formatter rather than of a battle's luck.
func _the_break_share_sums_to_one() -> void:
	var battle_script := load("res://scripts/battle.gd")
	var scene: Node = battle_script.new()
	var stats := {}
	var names := ["Alpha", "Beta", "Gamma", "Delta"]
	var bd := [400.0, 300.0, 200.0, 100.0]
	var pool: float = 0.0
	for v in bd:
		pool += v
	for i in names.size():
		stats["n_hero_" + names[i]] = 4.0
		stats["bd_hero_" + names[i]] = bd[i]
		stats["pool_bd_hero_" + names[i]] = pool
		stats["pool_dmg_hero_" + names[i]] = 1.0
		stats["pool_all_hero_" + names[i]] = 1.0
	var table: String = scene.call("_contrib_table", stats)
	var pct_sum := 0
	var seen := 0
	for line in table.split("\n"):
		for i in names.size():
			if not line.begins_with("  " + names[i] + " "):
				continue
			seen += 1
			var cells := line.split(" ", false)
			# hero n dmg/b dmg% heal/b prev/b BD/b BD% BDprev/b st/b d+h+p%
			var bd_per_battle := float(cells[6])
			var bd_pct := int(String(cells[7]).trim_suffix("%"))
			pct_sum += bd_pct
			ok(absf(bd_per_battle - bd[i] / 4.0) < 0.5,
				"§1: %s's BD/b is its Break over its battles (%s)" % [names[i], cells[6]])
			ok(bd_pct == int(round(100.0 * bd[i] / pool)),
				"§1: %s's BD%% is that same Break over the party's (%d)" % [
					names[i], bd_pct])
	ok(seen == names.size(), "§1: all four rows printed (%d did)" % seen)
	ok(pct_sum == 100, "§1: the Break-dealt shares sum to 100%% (read %d%%)" % pct_sum)
	_report.append("BD share on a 400/300/200/100 party: sums to %d%%" % pct_sum)
	scene.free()


# THE AUDIT, AS AN ASSERTION. Six effects in the game reduce or refuse incoming
# Break. Before this batch exactly one was booked; a seventh added later must
# come here, name itself, and appear in the report line — otherwise it measures
# zero and the zero gets read as a dead node, which is the whole lesson.
func _every_reducer_has_a_term() -> void:
	var usrc := _src("res://scripts/unit.gd")
	var terms := ["devoutness_break", "bd_bulwark", "bd_hold_line", "bd_ward",
		"bd_immovable", "bd_bracing"]
	for t in terms:
		ok(usrc.contains("\"%s\"" % t), "§1: `%s` is credited at its site" % t)
	# Every `_credit_bd` call in unit.gd is one of the six — a call with a term
	# the report line does not know about would bank into a bucket nobody prints.
	ok(usrc.count("_credit_bd(") == 7,
		"§1: six reducers credit, plus the helper's own definition")
	var src := _src("res://scripts/battle.gd")
	for t in ["devoutness", "bulwark", "hold_line", "ward", "immovable", "bracing"]:
		ok(src.contains("[\"%s\", " % t),
			"§1: `%s` is one of the terms the audit line prints" % t)
	# The two deliberate EXCLUSIONS, pinned so a later batch cannot quietly
	# reverse them: base Constitution is a stat block, and the run modifiers
	# are not anybody's work.
	ok(not usrc.contains("\"bd_constitution\""),
		"§1: base Constitution is NOT booked — a stat block is not a contribution")
	ok(not usrc.contains("\"bd_muffled\"") and not usrc.contains("\"bd_deadened\""),
		"§1: the run modifiers are NOT booked — a ledger that credits the weather is worthless")


# ---------- §2: the condition ----------

func _the_condition_is_at_the_gate() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("or h.faith_stacks >= 5:"),
		"§2: an ally at five stacks is skipped by the Communion walk")
	# It sits on the EXISTING gate rather than beside it, so there is still one
	# place the walk decides who is eligible.
	ok(src.contains("if h == u or h.dead or h.is_companion or h.faith_stacks <= 0 \\"),
		"§2: ...on the same `continue` that already held the other three tests")
	# The roll itself is untouched — this batch changes WHO is rolled for, not
	# what the chance is.
	ok(src.contains("if randf() < 0.01 * devout.communion_ranks * h.faith_stacks:"),
		"§2: the chance expression is unchanged — this is a condition, not a reprice")
	var n := _node("dv_communion")
	ok(not n.is_empty() and int(n["payload"]["stat"]["communion_ranks"]) == COMMUNION,
		"§2: and the node still pays %d" % COMMUNION)


# AN ABILITY WHOSE CHANCE RISES WITH STACKS AND THEN VANISHES AT THE TOP READS
# AS A BUG. The tooltip has to say the cliff out loud, and it has to frame the
# rule as an inclusion — fervor spreads to those still building — because that
# is what the mechanic actually is.
func _the_tooltip_states_the_cliff() -> void:
	var n := _node("dv_communion")
	if n.is_empty():
		return
	var txt := Talents.desc_for(n, 1)
	ok(txt.contains("still BUILDING Faith"),
		"§2: the tooltip frames it as an inclusion (reads: %s)" % txt)
	ok(txt.contains("60%"), "§2: it names the peak chance at four stacks")
	ok(txt.contains("not rolled for at all"),
		"§2: and it states the cliff at five outright")
	# The reprice BE shipped is still rendered by the same tooltip.
	ok(txt.contains("(%d x their own Faith stacks)%%" % COMMUNION),
		"§2: the %d still renders" % COMMUNION)


# ---------- live: §1 ----------

# BULWARK OF FORTITUDE GIVES THE PARTY THREE TURNS OF TAKING NO BREAK DAMAGE
# AND IT WAS COUNTED NOWHERE IN THE GAME. Driven through the real ability, so
# the src stamp, the refusal and the booking are all the shipped path.
func _live_bulwark_reaches_the_prevented_door() -> void:
	var scene := await _spawn({"dv_bulwark": 1})
	var dv := _devout(scene)
	var war: BattleUnit = scene.get("heroes")[0]
	if dv != null:
		var ab = scene.call("_find_ability", dv, "Bulwark of Fortitude")
		ok(ab != null, "§1: the capstone granted the ability")
		if ab != null:
			# NOT awaited: `_resolve_special` is a coroutine overall, but the
			# "bulwark" branch has no `await` in it, so it runs to completion
			# on the call. `await`ing an Object.call() of a coroutine is the
			# thing that does not work here.
			scene.call("_resolve_special", dv, ab, dv, "good", 1.0)
			await process_frame
			ok(war.has_status("bulwark"), "§1: the stand covers the party")
			ok(String(war.get_status("bulwark").get("src_name", "")) == dv.unit_name,
				"§1: and the caster's name rides it")
			var pressure_before := war.pressure
			var hero_before := _stat_of(scene, "bdprev_hero_" + dv.unit_name)
			war.take_hit(0, 200)
			var term: float = _stat_of(scene, "bdprev_bulwark")
			var hero: float = _stat_of(scene, "bdprev_hero_" + dv.unit_name) - hero_before
			ok(war.pressure == pressure_before,
				"§1: the Break was genuinely refused (meter %d -> %d)" % [
					pressure_before, war.pressure])
			ok(term > 0.0, "§1: the refused points reach the door (read %.0f)" % term)
			ok(absf(hero - term) < 0.01,
				"§1: the term and the hero total are the SAME call (%.0f vs %.0f)" % [
					term, hero])
			_report.append("Bulwark on 200 raw Break: %.0f points refused, booked to %s" % [
				term, dv.unit_name])
	await _kill(scene)
	_live_ran += 1


# THE CONTROL, DRIVEN. Break traffic must leave the damage-healing-prevented
# ledger byte for byte — not "about the same", identical. This is the check
# that would catch the negative control (Break folded into the share) even if
# the fold happened somewhere other than the table.
func _live_break_never_enters_the_contribution_slice() -> void:
	var scene := await _spawn({"dv_bulwark": 1, "dv_devoutness": 1})
	var dv := _devout(scene)
	var war: BattleUnit = scene.get("heroes")[0]
	if dv != null:
		var ab = scene.call("_find_ability", dv, "Bulwark of Fortitude")
		if ab != null:
			# NOT awaited: `_resolve_special` is a coroutine overall, but the
			# "bulwark" branch has no `await` in it, so it runs to completion
			# on the call. `await`ing an Object.call() of a coroutine is the
			# thing that does not work here.
			scene.call("_resolve_special", dv, ab, dv, "good", 1.0)
			await process_frame
		# Snapshot everything the old share is made of.
		var before := {}
		for k in scene.get("sim_stats"):
			var ks := String(k)
			if ks.begins_with("dmg_hero_") or ks.begins_with("heal_hero_") \
					or ks.begins_with("prev_hero_"):
				before[ks] = scene.get("sim_stats")[k]
		var slice_before: Dictionary = scene.get("_b_slice").duplicate()
		# Now drive a great deal of Break, prevented three different ways.
		for _i in 40:
			war.take_hit(0, 200)
			dv.take_hit(0, 200)
		ok(_stat_of(scene, "bdprev_bulwark") > 0.0,
			"§1: the run actually produced Break prevention")
		var after := {}
		for k in scene.get("sim_stats"):
			var ks := String(k)
			if ks.begins_with("dmg_hero_") or ks.begins_with("heal_hero_") \
					or ks.begins_with("prev_hero_"):
				after[ks] = scene.get("sim_stats")[k]
		ok(after == before,
			"§1: not one damage/healing/prevented key moved (%d keys before, %d after)" % [
				before.size(), after.size()])
		ok(scene.get("_b_slice") == slice_before,
			"§1: and the contribution slice the pool is built from is untouched")
		# The other direction: the Break keys DID move, so the check above is
		# not passing because nothing happened.
		ok(scene.get("_b_bd_slice").is_empty(),
			"§1: prevented Break is not Break DEALT either — it stays out of that slice too")
		_report.append("40 double-hits of 200 Break: %.0f points prevented, contribution keys moved by 0" % \
			_stat_of(scene, "bdprev_bulwark"))
	await _kill(scene)
	_live_ran += 1


# The Break-DEALT slice, wired: `_stat_bd` must land in `_b_bd_slice` and
# nowhere near `_b_slice`, because `_b_slice` is summed wholesale into the
# damage-healing-prevented pool and a Break key in it folds Break into the old
# share through nothing more than a `for` loop.
func _live_break_dealt_pools_apart_from_damage() -> void:
	var scene := await _spawn()
	var heroes: Array = scene.get("heroes")
	var amounts := [400.0, 300.0, 200.0, 100.0]
	for i in heroes.size():
		scene.call("_stat_bd", heroes[i], amounts[i % amounts.size()])
	var bd_slice: Dictionary = scene.get("_b_bd_slice")
	var c_slice: Dictionary = scene.get("_b_slice")
	ok(bd_slice.size() == heroes.size(),
		"§1: every hero's Break dealt reached the Break slice (%d of %d)" % [
			bd_slice.size(), heroes.size()])
	var all_bd := true
	for k in bd_slice:
		if not String(k).begins_with("bd_hero_"):
			all_bd = false
	ok(all_bd, "§1: and the Break slice holds Break keys only")
	ok(c_slice.is_empty(),
		"§1: the contribution slice took none of it (%d keys)" % c_slice.size())
	# The pool `_check_end` builds is the sum of that slice, so the share it
	# divides by is the party's Break and nothing else.
	var pool := 0.0
	for k in bd_slice:
		pool += bd_slice[k]
	var want := 0.0
	for i in heroes.size():
		want += amounts[i % amounts.size()]
	ok(absf(pool - want) < 0.01,
		"§1: the Break pool is the party's Break dealt (%.0f, want %.0f)" % [pool, want])
	await _kill(scene)
	_live_ran += 1


# ---------- live: §2, the measured rates ----------

# One trial: reset the eligible ally to `stacks`, drive a release on the
# warrior, report whether Communion fired. Two detectors, and WHICH ONE IS
# CORRECT DEPENDS ON WHERE THE ALLY SITS — BE's suite measured 1 and 3 stacks
# and only ever needed the first:
#   below 4 — the ally's own stack count went up and stayed up;
#   at 4 or 5 — the advance takes the ally TO five, which RELEASES. Without
#     Apostle the stacks then reset to 0, so a stack-count detector reads a
#     fire as a miss; the release counter is the only honest witness there.
# `by_release` picks the second. The warrior's own release is always one of
# them, hence the >= 2.
func _measure(scene: Node, ally: BattleUnit, stacks: int, by_release: bool) -> float:
	var war: BattleUnit = scene.get("heroes")[0]
	var fired := 0
	for _i in TRIALS:
		_isolate(scene, ally, stacks)
		var before := _stat_of(scene, "faith_releases")
		war.faith_stacks = 0
		scene.call("_gain_faith", war, 5)
		if by_release:
			if _stat_of(scene, "faith_releases") - before >= 2.0:
				fired += 1
		elif ally.faith_stacks > stacks:
			fired += 1
	return float(fired) / float(TRIALS)


# THE TOP OF THE CLIFF. Four stacks is where the chance peaks, and the node has
# to keep paying there — a condition that quietly killed the whole roll would
# also read as "0% at five" and pass the check below it.
func _live_rate_at_four_stacks() -> void:
	var scene := await _spawn({"dv_communion": 1})
	var dv := _devout(scene)
	ok(dv != null and dv.communion_ranks == COMMUNION,
		"§2: the Devout has learned Communion at %d" % COMMUNION)
	if dv != null:
		# Detected by RELEASE, not by stack count: four plus one is five, which
		# releases and (with no Apostle) resets the ally to zero. A stack-count
		# detector would read every single fire as a miss and this row would
		# print 0% next to a node working perfectly.
		var rate := _measure(scene, scene.get("heroes")[1], 4, true)
		ok(absf(rate - RATE_AT_FOUR) < 0.05,
			"§2: an ally at FOUR stacks still advances %d%% of the time (read %.1f%%)" % [
				int(100.0 * RATE_AT_FOUR), 100.0 * rate])
		_report.append("Communion at 4 stacks: %.1f%% over %d trials (want 60%%)" % [
			100.0 * rate, TRIALS])
	await _kill(scene)
	_live_ran += 1


# THE BOTTOM OF IT, AND THE BATCH'S WHOLE CHANGE. Not "rarely" — never, over
# 1200 driven releases, on the exact construction that measured 75% in BE. And
# the second half, which is the point of the lever rather than a side effect:
# a parked party produces NO Communion-driven release at all, so the node can
# no longer manufacture a release out of one that already happened.
#
# BATCH BG §2 NOTE: nothing in the game parks an ally at five any more — the
# capstone moved off the release axis. The state is CONSTRUCTED here by writing
# `faith_stacks` directly, which is what these checks always did; the condition
# itself is unchanged and is what is under test. Apostle stays learned only so
# the row keeps naming the build the coupling was found in.
func _live_never_rolls_at_five() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	ok(dv != null and dv.apostle > 0, "§2: Apostle is learned")
	if dv != null:
		var rate := _measure(scene, heroes[1], 5, true)
		ok(rate == 0.0,
			"§2: an ally at FIVE is never rolled for — was 75%% (read %.1f%%)" % \
				(100.0 * rate))
		# The whole party parked, which is the state Apostle actually produces.
		var worst := 0.0
		for _i in 200:
			for h in heroes:
				h.faith_stacks = 5
				h.hp = h.max_hp
			scene.get("sim_stats").clear()
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], 5)
			worst = maxf(worst, _stat_of(scene, "faith_releases"))
		ok(worst == 1.0,
			"§2: a fully parked party banks the driven release and nothing else (worst %.0f)" % worst)
		_report.append("Apostle-parked ally at 5 stacks: %.1f%% over %d trials (was 75%%); fully parked party, worst releases from one call: %.0f" % [
			100.0 * rate, TRIALS, worst])
	await _kill(scene)
	_live_ran += 1


# THE GUARD SURVIVES THE CONDITION. It was load-bearing against a cascade
# through PARKED allies, and parked allies are now skipped — so the check moves
# to four stacks, where a chain can still form (60% apiece takes an ally to 5,
# which releases, which without the latch would roll again). A guard that has
# quietly become unreachable is a guard nobody will notice removing.
func _live_guard_is_still_a_reentrancy_lock() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	if dv != null:
		ok(not bool(scene.get("_communion_chain")), "§2: the latch starts down")
		var worst := 0.0
		var spread := 0
		for _i in 200:
			for h in heroes:
				h.faith_stacks = 4
				h.hp = h.max_hp
			scene.get("sim_stats").clear()
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], 5)
			var rel := _stat_of(scene, "faith_releases")
			worst = maxf(worst, rel)
			if rel > 1.0:
				spread += 1
		ok(spread > 0,
			"§2: a cascade is still REACHABLE from four stacks (%d of 200)" % spread)
		ok(worst <= float(heroes.size()),
			"§2: and one call still banks at most one release per hero (worst %.0f, cap %d)" % [
				worst, heroes.size()])
		ok(not bool(scene.get("_communion_chain")),
			"§2: the latch is down again after every call")
		# A latch, not a limiter: a SECOND, separate release must roll too.
		var fired_late := 0
		for _i in 60:
			_isolate(scene, heroes[1], 4)
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], 5)
			_isolate(scene, heroes[1], 4)
			var before := _stat_of(scene, "faith_releases")
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], 5)
			if _stat_of(scene, "faith_releases") - before >= 2.0:
				fired_late += 1
		ok(fired_late > 0,
			"§2: a second release still rolls — the guard is a re-entrancy lock, not a limiter")
		_report.append("guard at the new condition: cascade reachable in %d/200 from four stacks (worst %.0f of cap %d), second-release fires %d/60" % [
			spread, worst, heroes.size(), fired_late])
	await _kill(scene)
	_live_ran += 1
