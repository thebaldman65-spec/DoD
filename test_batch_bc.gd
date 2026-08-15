# test_batch_bc.gd — DECOMPOSING THE DEVOUT'S FAITH ROW. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bc.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# THIS BATCH SHIPS NO GAMEPLAY CHANGE, so there are no new gameplay tests. What
# is pinned is the INSTRUMENT — and the instrument is the whole deliverable, so
# a broken one would read as a finding.
#
# What it pins:
#   §0 THE HARNESS IS PER-HERO AND THE FLAG STRING IS WHAT WAS ONE-SPEC.
#      `DOD_SIM_TALENTS` walks every hero and keeps the ids present in that
#      hero's OWN tree; all 324 node ids across the twelve trees are disjoint,
#      so a one-spec flag string builds exactly one hero. Both halves are
#      asserted, because the FINDING is the pair: nothing is wrong with the
#      harness, and every historical lane row is still a fully-built hero
#      measured against three unbuilt ones.
#   §1 THE REPORT LINE. `faith_report_line` returns "" when no Devout stood;
#      every term it prints has a WRITER (the AZ `focus_deepest` precedent — a
#      line banked in the wrong place printed nothing at all on a legal build);
#      and every term is booked at the site that COMPUTES it, through the one
#      `_devout_heal` / `_devout_prev` door, so the parts can never disagree
#      with the total.
#      THE THREE GAPS BC CLOSED, each driven live: Blessed Barrier's conversion
#      and Afterglow's mend were credited to NOBODY, and Devoutness's Break
#      reduction was counted NOWHERE AT ALL.
#      And the two separations that make the decomposition mean anything: a
#      Divine Shield absorb is distinguished from every other barrier in the
#      game, and Break points are kept out of the damage-prevented total.
#   §2 THE GRID'S PREMISE. The FAITH lane is exactly the eight nodes the
#      leave-one-out table names, in row order — so a later re-spec trips the
#      table rather than silently invalidating it.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# The eight FAITH nodes, in row order. THE LEAVE-ONE-OUT TABLE IS KEYED ON
# THIS LIST, so it lives here rather than in a comment.
const FAITH_LANE := ["dv_communion", "dv_unwavering", "dv_devoutness",
	"dv_faithful", "dv_covenant", "dv_fervor", "dv_oath", "dv_apostle"]

# Every heal term `faith_report_line` prints, and the site that must write it.
const HEAL_TERMS := ["release", "growth", "blessed", "afterglow", "pulse",
	"covenant", "lifewell", "bulwark"]
const PREV_TERMS := ["shield", "ground", "stacks"]

var checks := 0
var fails: Array = []
# A live check that throws mid-way aborts its own function while the suite
# still prints "0 failures" — the CLAUDE.md trap that fakes a clean pass. Every
# live function bumps this on its LAST line, and the count is asserted.
var _live_ran := 0
const LIVE_CHECKS := 8
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
	Profile.save_path = "user://profile_batch_bc_test.json"
	Profile.loaded = false
	Profile.data = {}

	_ids_are_disjoint()
	_harness_is_per_hero()
	_faith_lane_shape()
	_report_line_empty()
	_report_line_terms()
	_one_booking_door()
	_terms_read_at_their_sites()
	_break_is_not_damage()
	_report_line_is_shared()

	await _live_flag_string_builds_one_hero()
	await _live_release_banks_count_and_heal()
	await _live_blessed_barrier_is_credited()
	await _live_afterglow_is_credited()
	await _live_devoutness_break_is_counted()
	await _live_divine_shield_absorbs_are_split_out()
	await _live_faith_stack_mitigation_is_split_out()
	await _live_the_terms_sum_to_the_total()
	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bc_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bc_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bc: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------


# Argument lists wrapped across lines read as `foo,\n\t\t\t"bar"`. Collapsing a
# comma-plus-newline-plus-tabs to a plain `, ` lets a source-level needle name
# an argument without also having to know the file's line width.
func _joined(src: String) -> String:
	var out := src
	while out.contains(",\n"):
		out = out.replace(",\n", ", ")
	while out.contains(",  "):
		out = out.replace(",  ", ", ")
	while out.contains(", \t"):
		out = out.replace(", \t", ", ")
	return out

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


# One spawn for every live check. `specs` is warrior/mage/cleric/hunter order;
# `learned` lands on the hero named by `learner` (2 = the Cleric slot, which is
# where the Devout stands).
func _spawn(specs: Array, learned := {}, learner := 2,
		lineup := ["raider", "raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = String(specs[i])
		run.party[i]["tree"] = Talents.generate_tree(String(specs[i]),
			run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == learner else {}
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
	# Determinism FORCED, not retried (the AK/AL/AR/../BB discipline). A driven
	# _resolve still rolls miss, parry AND crit.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		# A test that reads an exact HEAL must zero this, or the Cleric class
		# passive silently inflates every number it reads.
		u.healing_received_mult = 1.0
	# `_stat` only banks into sim_stats while `sim` is true.
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


# ---------- §0: what the harness force-learns, and for whom ----------

# THE HALF THAT MAKES THE OTHER HALF MATTER. The harness keeps only the ids
# present in each hero's own tree; that rule is only equivalent to "one hero"
# because no two trees share an id. If a later batch ever gave two specs a
# node id in common, a one-spec flag string would quietly build two heroes.
func _ids_are_disjoint() -> void:
	var owner_of := {}
	var collisions: Array = []
	var total := 0
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			var id := String(n["id"])
			total += 1
			if owner_of.has(id):
				collisions.append(id)
			owner_of[id] = spec
	# BATCH BM: 27 nodes a tree, so 324. The PROPERTY the check exists for —
	# that every id is disjoint, which is what makes a one-spec DOD_SIM_TALENTS
	# string build exactly one hero — is unchanged.
	ok(total == 324, "§0: twelve trees of 27 nodes = 324 ids (read %d)" % total)
	ok(collisions.is_empty(),
		"§0: no node id appears in two trees (%s)" % ", ".join(collisions))
	_report.append("§0: %d node ids across twelve trees, %d collisions" % [
		total, collisions.size()])


# THE HARNESS ITSELF IS NOT ONE-HERO — it walks every hero. Asserted against
# the source, because the distinction is the whole §0 finding: there is nothing
# to FIX here, the flag strings were what named one spec.
func _harness_is_per_hero() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("var env_talents := OS.get_environment(\"DOD_SIM_TALENTS\")"),
		"§0: the harness reads DOD_SIM_TALENTS")
	# It sits INSIDE `for i in hero_keys.size()`, and the id filter is the tree
	# of the hero being built — `t_tree`, generated from THIS hero's spec.
	ok(src.contains("var t_tree := Talents.generate_tree(spec, hero_keys[i])"),
		"§0: the filter tree is the hero being built, not the measured one")
	ok(src.contains("if not Talents.node_in_tree(t_tree, bits[0]).is_empty():"),
		"§0: an id lands only where that hero's own tree holds it")
	var head := src.substr(0, src.find("var env_talents"))
	ok(head.rfind("for i in hero_keys.size():") > head.rfind("heroes.append(u)"),
		"§0: the force-learn is inside the per-hero spawn loop")


func _faith_lane_shape() -> void:
	var tree: Array = Talents.LANE_TREES["inquisitor"]
	var lane: Array = []
	for n in tree:
		if String(n.get("lane", "")) == "Faith":
			lane.append(String(n["id"]))
	# BATCH BM RE-POINTED THIS IN PLACE: the grid is keyed on the EIGHT nodes
	# that existed when it was measured, and BM added a ninth (Creed, row 8).
	# The check asserts the eight are still there IN ORDER — which is what
	# makes every historical cell comparable — rather than that the lane holds
	# nothing else.
	var kept: Array = []
	for id in lane:
		if FAITH_LANE.has(id):
			kept.append(id)
	ok(kept == FAITH_LANE,
		"§2: the FAITH lane still holds the eight nodes the table names, in order")
	# The table is a leave-ONE-out grid: eight rows, eight nodes.
	# BATCH BM added a row-8 node to every lane, so FAITH is NINE now (the
	# eight the grid was keyed on, plus Creed). The leave-one-out table below
	# is keyed on the ORIGINAL EIGHT and stays comparable for that reason.
	ok(lane.size() == 9, "§2: nine FAITH nodes = eight rows plus the shelf")


# ---------- §1: the report line ----------

func _report_line_empty() -> void:
	var battle_script: GDScript = load("res://scripts/battle.gd")
	ok(String(battle_script.faith_report_line({})) == "",
		"§1: the line is empty on an empty ledger")
	# A party with NO Devout banks no `conviction_battles`, so the line stays
	# quiet even when other heroes healed — a zero would read as a broken
	# instrument rather than a finding.
	ok(String(battle_script.faith_report_line({
			"faith_heal_release": 900.0, "battles": 40.0})) == "",
		"§1: the line is empty when no Devout stood, whatever else happened")
	ok(String(battle_script.faith_report_line({"conviction_battles": 1.0})) != "",
		"§1: one battle with a Devout is enough to print")


# EVERY TERM THE LINE PRINTS MUST HAVE A WRITER. This is the AZ `focus_deepest`
# lesson inverted: there, a real term was banked where nothing could reach it
# and the line printed nothing; here, the failure to guard against is a term
# that prints a confident 0 forever because no site ever writes its key.
func _report_line_terms() -> void:
	var battle_script: GDScript = load("res://scripts/battle.gd")
	var src := _src("res://scripts/battle.gd")
	var stats := {"conviction_battles": 1.0}
	var expect: Array = []
	var v := 101.0
	for t in HEAL_TERMS:
		stats["faith_heal_" + t] = v
		expect.append(v)
		v += 1.0
	for t in PREV_TERMS:
		stats["faith_prev_" + t] = v
		expect.append(v)
		v += 1.0
	stats["faith_releases"] = 4.0
	stats["faith_break_cut"] = 77.0
	var line := String(battle_script.faith_report_line(stats))
	for i in expect.size():
		ok(line.contains("%d" % int(expect[i])),
			"§1: the line prints term %d's value" % i)
	ok(line.contains("77"), "§1: the line prints the Break points removed")
	ok(line.contains("releases/battle 4.00"), "§1: releases are per battle")
	# healing per release = release healing / releases, not / battles.
	ok(line.contains("healing per release %d" % int(101.0 / 4.0)),
		"§1: healing per release divides by RELEASES, not by battles")
	# ...AND EVERY TERM MUST HAVE A LIVE WRITER. A column that prints a
	# confident 0 forever because nothing banks its key is the failure this
	# guards: `_devout_heal`'s third argument IS the term, so the set of terms
	# the line reads and the set the code writes have to match.
	# RE-POINTED IN PLACE BY BATCH BU, AND THE QUESTION IS UNCHANGED: does
	# something actually WRITE each term the report line reads. The old needle
	# ended in `")`, i.e. it required the term to be the LAST argument — and BU
	# gave `_devout_heal` a fourth (the healed unit, for Reprisal's ledger), so
	# every one of these fragments vanished from working code. Anchored on the
	# term AS AN ARGUMENT now (`, "release"`), which is a strictly better
	# anchor: it survives another argument being added and still refuses a term
	# that appears only in a comment. The AZ Follow-Through / BQ Ghillie
	# precedent exactly.
	# ONE MORE THING THE RE-POINT NEEDS: an argument list WRAPPED across lines
	# puts a newline and tabs between the comma and the term (Afterglow's call
	# is the one that does), so the needle is searched against a copy with
	# post-comma line breaks collapsed. Without it this check reads "nothing
	# writes faith_heal_afterglow" against working code — a false alarm caused
	# purely by line width.
	var both := _joined(src + _src("res://scripts/unit.gd"))
	for t in HEAL_TERMS:
		var needle := ", \"" + String(t) + "\""
		ok(both.contains(needle), "§1: something writes faith_heal_%s" % t)
	for t in PREV_TERMS:
		var pneedle := "faith_prev_shield" if t == "shield" \
			else ", \"" + String(t) + "\""
		ok(both.contains(pneedle), "§1: something writes faith_prev_%s" % t)


# ONE DOOR. Two batches aimed a fix at a term inside an aggregate; the reason
# they could not see the terms is that seven sites each banked their own heal
# (or, three of them, banked nothing). A single booking function is what stops
# the parts from ever disagreeing with the total.
func _one_booking_door() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.count("func _devout_heal(") == 1,
		"§1: `_devout_heal` has exactly ONE implementation")
	ok(src.count("func _devout_prev(") == 1,
		"§1: `_devout_prev` has exactly ONE implementation")
	# Every named term goes through it — the door, not around it.
	# RE-POINTED BY BATCH BU with the fourth argument threaded through: the
	# question — does the Devout door FEED the Batch W ledger rather than
	# replace it — is unchanged.
	ok(src.contains("_stat_heal(owner, amount, healed)"),
		"§1: `_devout_heal` still feeds the Batch W ledger, it does not replace it")
	ok(src.contains("_prev(owner, cut)"),
		"§1: `_devout_prev` still feeds the Batch W ledger")
	# No Devout heal may bypass the door: the old bare `_stat_heal(devout, ...)`
	# calls are gone from every site the decomposition names.
	for gone in ["_stat_heal(devout, f_got)", "_stat_heal(devout, grow_got)",
			"_stat_heal(devout, cov_got)", "_stat_heal(cg_dv, well_got)"]:
		ok(not src.contains(gone),
			"§1: `%s` goes through the door now" % gone)


# THE §6 REQUIREMENT IN ONE FUNCTION: the terms are read from the sites that
# compute them rather than recomputed. Each assertion pins the booking call
# NEXT TO the expression that produced the number, using that site's own local.
# RE-POINTED IN PLACE BY BATCH BU. Each pin below names the booking call NEXT
# TO the expression that produced the number, and BU added a fourth argument to
# `_devout_heal` (the healed unit, so Reprisal's ledger can subtract overheal).
# The fragments moved; the question — is the term read at the site that computed
# it, or recomputed somewhere else — is byte-for-byte the same one.
func _terms_read_at_their_sites() -> void:
	var src := _src("res://scripts/battle.gd")
	var usrc := _src("res://scripts/unit.gd")
	ok(src.contains("_devout_heal(devout, f_got, \"release\", u)"),
		"§1: the release term reads the release's own `f_got`")
	ok(src.contains("_stat(\"faith_releases\")"),
		"§1: the release COUNT is banked at the release")
	ok(src.contains("_devout_heal(devout, grow_got, \"growth\", devout)"),
		"§1: growth reads `_conviction_growth`'s own `grow_got`")
	ok(src.contains("_devout_heal(devout, cov_got, \"covenant\", saved)"),
		"§1: Sacred Covenant reads its own `cov_got`")
	ok(src.contains("_devout_heal(cg_dv, well_got, \"lifewell\", wh)"),
		"§1: Lifewell reads its own `well_got`")
	# Healing Pulse and Bulwark of Fortitude live inside `_run_battle`, which
	# cannot be driven headlessly (the AR trap), so they are pinned against the
	# source at their own sites instead of driven.
	ok(src.contains("_devout_heal(zl_dv, pulse_got, \"pulse\", u)"),
		"§1: Healing Pulse reads its own `pulse_got`")
	ok(src.contains("_devout_heal(_living_devout(), bw_tick, \"bulwark\", u)"),
		"§1: Bulwark of Fortitude reads its own `bw_tick`")
	# The two unit.gd heals bank what LANDED, not what was asked for: Blessed
	# Barrier was discarding heal_amount's return entirely.
	ok(usrc.contains("var bb_got := heal_amount(bb_heal)"),
		"§1: Blessed Barrier captures what the heal actually landed")
	# RE-POINTED BY BATCH BU: `credit_cb` gained a fourth argument (the healed
	# unit), so the caller grew a `, self`. The question is unchanged — is the
	# credit stamped with the barrier's OWNER rather than with its wearer.
	ok(usrc.contains("credit_cb.call(String(s.get(\"src\", \"\")), bb_got, \"blessed\", self)"),
		"§1: Blessed Barrier credits the caster stamped on the barrier")
	ok(usrc.contains("credit_cb.call(String(s.get(\"src\", \"\")), glow_got,"),
		"§1: Afterglow credits the same caster, with its own `glow_got`")
	# One callback, one handler.
	ok(usrc.count("var credit_cb := Callable()") == 1,
		"§1: unit.gd's ledger door is one field")
	ok(src.count("func _on_unit_credit(") == 1,
		"§1: one handler answers it")


# BREAK POINTS ARE NOT DAMAGE. Folding Devoutness's cut into `prev_hero_` would
# have inflated the contribution share — which sums damage + healing +
# prevented — with a quantity in different units, and the number this batch
# exists to explain is that share.
func _break_is_not_damage() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("_stat(\"faith_break_cut\", float(amount))"),
		"§1: the Break cut has its own counter")
	var handler := src.substr(src.find("func _on_unit_credit("), 500)
	ok(handler.contains("return"),
		"§1: the Break term returns before the heal path")
	ok(not handler.contains("_prev(") ,
		"§1: the Break term never reaches `_prev`")
	# The divine flag is what separates a Divine Shield from Holy's ward.
	ok(src.contains("if divine:\n\t\t_stat(\"faith_prev_shield\""),
		"§1: only a DIVINE barrier's absorbs count as Divine Shield's")
	ok(_src("res://scripts/unit.gd").contains(
			"bool(s.get(\"divine\", false))"),
		"§1: the flag is read off the same status the Faith trigger reads")


func _report_line_is_shared() -> void:
	var src := _src("res://scripts/battle.gd")
	var rsrc := _src("res://scripts/run_sim.gd")
	ok(src.contains("static func faith_report_line("),
		"§1: the line is static, so RunSim can call it (the ruin pattern)")
	ok(src.contains("var dx := faith_report_line(sim_stats)"),
		"§1: the standalone report prints it")
	ok(rsrc.contains("battle.faith_report_line(battle.sim_stats)"),
		"§1: RunSim's report prints the same one")


# ---------- live ----------

# §0, DRIVEN RATHER THAN REASONED: a FAITH-lane flag string against the default
# party builds the Devout and nobody else. THIS IS THE FINDING, so it is pinned
# — if a later batch changes the harness, the historical rows stop meaning what
# this batch says they mean and the test says so.
func _live_flag_string_builds_one_hero() -> void:
	var party := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	var keys := ["warrior", "mage", "cleric", "hunter"]
	var built := 0
	for i in party.size():
		var tree := Talents.generate_tree(party[i], keys[i])
		var n := 0
		for id in FAITH_LANE:
			if not Talents.node_in_tree(tree, id).is_empty():
				n += 1
		if n > 0:
			built += 1
		if party[i] == "inquisitor":
			ok(n == 8, "§0: the Devout learns all eight FAITH nodes")
		else:
			ok(n == 0, "§0: %s learns nothing from a FAITH flag string" % party[i])
	ok(built == 1, "§0: ONE hero of four is built by a one-spec flag string")
	# And the repair is a FLAGS change, not a harness change: name every lane
	# and every hero builds.
	var four_lanes: Array = FAITH_LANE.duplicate()
	for id in ["bz_savagery", "bz_hemorrhage", "bz_crushing_blows"]:
		four_lanes.append(id)
	for id in ["cr_hypothermia", "cr_freezing", "cr_crystal"]:
		four_lanes.append(id)
	for id in ["bm_communion", "bm_unbroken", "bm_absolute"]:
		four_lanes.append(id)
	var built4 := 0
	for i in party.size():
		var tree := Talents.generate_tree(party[i], keys[i])
		for id in four_lanes:
			if not Talents.node_in_tree(tree, String(id)).is_empty():
				built4 += 1
				break
	ok(built4 == 4, "§0: a four-lane flag string builds all four heroes")
	_live_ran += 1


func _live_release_banks_count_and_heal() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"])
	var dv := _devout(scene)
	var mage: BattleUnit = scene.get("heroes")[1]
	ok(dv != null, "§1: a Devout stands")
	if dv != null:
		mage.hp = 1  # or the release heals into a full bar and reads 0
		var want := maxi(int(round(mage.max_hp * 0.15)), 1)
		scene.call("_gain_faith", mage, 5, "absorb")
		ok(_stat_of(scene, "faith_releases") == 1.0,
			"§1: one release banks one release")
		ok(_stat_of(scene, "faith_heal_release") == float(want),
			"§1: the release term is the release heal alone (%d, read %.0f)" % [
				want, _stat_of(scene, "faith_heal_release")])
		# The growth clause fired on the same release and is a DIFFERENT term.
		ok(_stat_of(scene, "faith_heal_growth") > 0.0,
			"§1: growth is banked separately from the release heal")
		_report.append("release heal on a %d-HP ally: %.0f" % [
			mage.max_hp, _stat_of(scene, "faith_heal_release")])
	await _kill(scene)
	_live_ran += 1


func _live_blessed_barrier_is_credited() -> void:
	# dv_barrier = Blessed Barrier (Bulwark row 1): 20% of what the shield
	# absorbs becomes healing. Before this batch that heal reached NO ledger.
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"], {"dv_barrier": 1})
	var dv := _devout(scene)
	var mage: BattleUnit = scene.get("heroes")[1]
	if dv != null:
		ok(dv.blessed_barrier_ranks == 20, "§1: Blessed Barrier is learned")
		mage.hp = maxi(mage.max_hp / 2, 1)
		scene.call("_grant_divine_shield", dv, mage, 100)
		mage.take_hit(50, 0)
		var got := _stat_of(scene, "faith_heal_blessed")
		ok(got > 0.0, "§1: Blessed Barrier's conversion is banked (read %.0f)" % got)
		ok(_stat_of(scene, "heal_hero_" + dv.unit_name) >= got,
			"§1: and it is credited to the Devout, not to nobody")
		_report.append("Blessed Barrier on a 50-damage absorb: %.0f healing" % got)
	await _kill(scene)
	_live_ran += 1


func _live_afterglow_is_credited() -> void:
	# dv_afterglow (Bulwark row 3): the breaking shield mends its holder for
	# 20% of the Devout's maximum. Same gap, same fix.
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"], {"dv_afterglow": 1})
	var dv := _devout(scene)
	var mage: BattleUnit = scene.get("heroes")[1]
	if dv != null:
		ok(dv.afterglow_ranks == 20, "§1: Afterglow is learned")
		mage.hp = maxi(mage.max_hp / 4, 1)
		scene.call("_grant_divine_shield", dv, mage, 20)
		mage.take_hit(40, 0)  # breaks the shield outright
		var got := _stat_of(scene, "faith_heal_afterglow")
		ok(got > 0.0, "§1: Afterglow's mend is banked (read %.0f)" % got)
		ok(_stat_of(scene, "faith_heal_blessed") == 0.0,
			"§1: and it is NOT pooled with Blessed Barrier")
		_report.append("Afterglow on a broken shield: %.0f healing" % got)
	await _kill(scene)
	_live_ran += 1


func _live_devoutness_break_is_counted() -> void:
	# dv_devoutness (Faith row 3): the party takes 20% less Break damage. It
	# was counted NOWHERE — not in `prev_hero_`, correctly, and not anywhere
	# else, which is the gap.
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"], {"dv_devoutness": 1})
	var dv := _devout(scene)
	var war: BattleUnit = scene.get("heroes")[0]
	if dv != null:
		ok(war.has_status("devotion"), "§1: Devoutness blankets the party")
		var prev_before := _stat_of(scene, "prev_hero_" + dv.unit_name)
		war.take_hit(0, 100)
		var cut := _stat_of(scene, "faith_break_cut")
		ok(cut > 0.0, "§1: the Break points removed are counted (read %.0f)" % cut)
		ok(_stat_of(scene, "prev_hero_" + dv.unit_name) == prev_before,
			"§1: and they stay OUT of the damage-prevented total")
		_report.append("Devoutness on 100 raw Break: %.0f points removed" % cut)
	await _kill(scene)
	_live_ran += 1


func _live_divine_shield_absorbs_are_split_out() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"])
	var dv := _devout(scene)
	var mage: BattleUnit = scene.get("heroes")[1]
	var war: BattleUnit = scene.get("heroes")[0]
	if dv != null:
		scene.call("_grant_divine_shield", dv, mage, 100)
		mage.take_hit(30, 0)
		ok(_stat_of(scene, "faith_prev_shield") == 30.0,
			"§1: a Divine Shield absorb is banked as Divine Shield's")
		# A barrier that is NOT a Divine Shield — Holy's Blessed Vestments ward
		# makes these — still counts as prevented, and must NOT count here.
		scene.call("_apply_status", war, "barrier", -1, 100)
		var b: Dictionary = war.get_status("barrier")
		b["src"] = dv.unit_name
		war.take_hit(25, 0)
		ok(_stat_of(scene, "faith_prev_shield") == 30.0,
			"§1: a non-divine barrier's absorb is NOT Divine Shield's")
		ok(_stat_of(scene, "prev_hero_" + dv.unit_name) >= 55.0,
			"§1: both still reach the Batch W prevented total")
	await _kill(scene)
	_live_ran += 1


func _live_faith_stack_mitigation_is_split_out() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"])
	var dv := _devout(scene)
	var war: BattleUnit = scene.get("heroes")[0]
	var foe: BattleUnit = scene.get("enemies")[0]
	if dv != null:
		war.faith_stacks = 3
		# BATCH BI §1: the mitigation site reads `faith_peak` — the highest count
		# held this battle — so a bare stack count no longer arms the term this
		# check is about. Set with the count, exactly as `_gain_faith` does.
		war.faith_peak = 3
		# _resolve(attacker, ability, target, grade) — argument ORDER matters
		# and a wrong one throws mid-run while the suite still reports 0
		# failures, which is the CLAUDE.md "fakes a clean pass" trap.
		await scene.call("_resolve", foe, scene.call("_cheapest_attack", foe),
			war, "good")
		ok(_stat_of(scene, "faith_prev_stacks") > 0.0,
			"§1: Conviction's per-stack mitigation is its own term")
		ok(_stat_of(scene, "faith_prev_ground") == 0.0,
			"§1: and it is not pooled with Consecrated Ground's")
	await _kill(scene)
	_live_ran += 1


# THE CHECK THAT MAKES THE DECOMPOSITION A DECOMPOSITION: the named terms must
# SUM to the Devout's heal total. A term missed reads as a smaller sum; a term
# double-booked reads as a larger one, and either one would send a repair batch
# at the wrong node.
func _live_the_terms_sum_to_the_total() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor",
		"beastmaster"], {"dv_barrier": 1, "dv_covenant": 1})
	var dv := _devout(scene)
	var mage: BattleUnit = scene.get("heroes")[1]
	var war: BattleUnit = scene.get("heroes")[0]
	if dv != null:
		mage.hp = 1
		war.hp = maxi(war.max_hp / 2, 1)
		dv.hp = maxi(dv.max_hp / 2, 1)
		scene.call("_gain_faith", mage, 5, "absorb")          # release + growth
		scene.call("_grant_divine_shield", dv, war, 200)
		war.take_hit(60, 0)                          # Blessed Barrier
		war.hp = 5
		war.take_hit(80, 0)                          # Sacred Covenant (lethal save)
		var total := _stat_of(scene, "heal_hero_" + dv.unit_name)
		var summed := 0.0
		for t in HEAL_TERMS:
			summed += _stat_of(scene, "faith_heal_" + t)
		ok(total > 0.0, "§1: the Devout healed something to sum")
		ok(is_equal_approx(summed, total),
			"§1: the named terms sum to the Devout's heal total (%.0f vs %.0f)" % [
				summed, total])
		_report.append("terms %.0f vs heal_hero total %.0f" % [summed, total])
	await _kill(scene)
	_live_ran += 1
