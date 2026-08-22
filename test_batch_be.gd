# test_batch_be.gd — COMMUNION, 40 -> 15. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_be.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# THERE IS ONE NUMBER IN THIS BATCH, so there is one gameplay number to pin —
# but it is pinned THREE TIMES, at three stack counts, because the whole point
# of 40 -> 15 is that the chance stops saturating:
#
#   1 stack  -> 15%   (was 40%)
#   3 stacks -> 45%   (was 120%, i.e. CERTAIN — the saturation point)
#   5 stacks -> 75%   (was 200%, and 5 is where Apostle PARKS every ally)
#
# §2's concern is the last of those: Communion reads the recipient's CURRENT
# stacks, so in an Apostle build the roll is 75% rather than 15%. That concern
# is pinned as a MEASURED RATE here rather than left in prose, so a later batch
# that re-prices the node has to come and change a number that says what the
# interaction costs.
#
# The rates are measured by driving `_gain_faith` — the real site — over 1200
# trials apiece, not by reading the expression. A test that re-derives the
# formula it is checking proves nothing.
#
# Also pinned: the `_communion_chain` guard still bounds a release cascade at
# the new value (it is a GUARD, not a magnitude), and §4's answer about the
# contribution metric, which is a finding this batch reports and does not act
# on.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const REAL_SAVE := "user://run_save.bin"

# The design number, in one place: the tree payload, the tooltip and every
# measured rate below are all checked against THIS.
const COMMUNION := 15
# BATCH DC: `battle.FAITH_RELEASE`, ruled at CZ §2. The threshold is mirrored
# ONCE per suite so the next move costs one line rather than a dozen literals.
const RELEASE := 3
const HELD_MAX := RELEASE - 1   # the deepest an ally can HOLD; at RELEASE he releases
# Trials per measured rate. At p=0.75 the 3-sigma band is +/-3.8 points, so the
# +/-5 bands below cannot flap; at p=0.15 it is +/-3.1 against +/-4.
const TRIALS := 1200

var checks := 0
var fails: Array = []
# A live check that THROWS mid-way aborts its own function while the suite
# still prints "0 failures" — the CLAUDE.md trap that fakes a clean pass. Every
# live function bumps this on its LAST line, and the count is asserted.
var _live_ran := 0
const LIVE_CHECKS := 5
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
	Profile.save_path = "user://profile_batch_be_test.json"
	Profile.loaded = false
	Profile.data = {}

	_the_number()
	_the_tooltip_agrees()
	_one_read_site()
	_the_guard_is_not_a_magnitude()
	_contribution_cannot_see_break()

	await _live_rate_at_one_stack()
	await _live_rate_at_two_stacks()
	await _live_rate_at_five_stacks_apostle()
	await _live_chain_guard_bounds_the_cascade()
	await _live_guard_resets_between_releases()
	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_be_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_be_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_be: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _node() -> Dictionary:
	return Talents.node_in_tree(Talents.LANE_TREES["inquisitor"], "dv_communion")


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


# One spawn for every live check. `specs` is warrior/mage/cleric/hunter order;
# `learned` lands on the Cleric slot, which is where the Devout stands.
func _spawn(learned := {}) -> Node:
	# `_stat` only banks into `sim_stats` while `sim` is true.
	return await Fixture.spawn(self,
		["berserker", "cryomancer", "inquisitor", "beastmaster"],
		{"enemies": ["raider"], "talents": {2: learned.duplicate()}, "slot_idx": 0,
		"deterministic": true, "heal_mult": 1.0, "sim": true})


func _kill(scene: Node) -> void:
	await Fixture.kill(self, scene)


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


# ---------- §1: the number ----------

func _the_number() -> void:
	var n := _node()
	ok(not n.is_empty(), "§1: dv_communion is still in the Faith lane")
	if n.is_empty():
		return
	ok(int(n["payload"]["stat"]["communion_ranks"]) == COMMUNION,
		"§1: Communion pays %d, not 40 (reads %s)" % [
			COMMUNION, n["payload"]["stat"]["communion_ranks"]])
	# THE PAIR IS THE POINT: the payload is what the code pays and the scale is
	# what the tooltip renders. A reprice that moves one and not the other
	# leaves the node lying rather than mistuned, which is worse.
	ok(int(n["scale"]["step"]) == COMMUNION,
		"§1: the tooltip's scale moved with the payload (reads %s)" % \
			n["scale"]["step"])
	ok(String(n["lane"]) == "Faith" and int(n["row"]) == 1,
		"§1: it is still Faith row 1 — this is a reprice, not a re-spec")
	ok(int(n["ranks"]) == 1, "§1: still a single-rank node")


func _the_tooltip_agrees() -> void:
	var n := _node()
	if n.is_empty():
		return
	var txt := Talents.desc_for(n, 1)
	ok(txt.contains("(%d x their own Faith stacks)%%" % COMMUNION),
		"§1: the tooltip renders %d (reads %s)" % [COMMUNION, txt])
	ok(not txt.contains("40"), "§1: and 40 appears nowhere in it")


# The counter keeps its meaning AND its units, so there is exactly one place a
# reprice has to reach. If a second read site ever appears, this trips.
func _one_read_site() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.count("devout.communion_ranks") == 2,
		"§1: `communion_ranks` is read at one site — the gate and the roll")
	ok(src.contains("if randf() < 0.01 * devout.communion_ranks * h.faith_stacks:"),
		"§1: the roll still reads the RECIPIENT's stacks (which is §2's whole concern)")
	# Nothing else in the game may write it. A rune that did would move the
	# number this batch just measured, silently (the AL Rune of Grudges shape).
	var rn := _src("res://data/runes.json")
	ok(not rn.contains("\"communion_ranks\""),
		"§1: no rune writes communion_ranks — the reprice reaches every payer")
	# Counted off the live trees rather than off a grep, so a renamed node or a
	# second writer in any of the twelve trips it.
	var writers: Array = []
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			var pay: Dictionary = n.get("payload", {})
			if Dictionary(pay.get("stat", {})).has("communion_ranks"):
				writers.append("%s/%s" % [spec, n["id"]])
	ok(writers == ["inquisitor/dv_communion"],
		"§1: exactly one node in twelve trees writes it (%s)" % ", ".join(writers))


# THE GUARD IS NOT A MAGNITUDE. At 40 it stopped a certainty; at 15 it stops a
# decaying random walk that is still unbounded. Either way it must survive a
# reprice, so it is asserted against the source as well as driven below.
func _the_guard_is_not_a_magnitude() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("var _communion_chain := false"),
		"§6: the chain guard exists")
	ok(src.contains("if devout.communion_ranks > 0 and not _communion_chain:"),
		"§6: the roll is gated on it")
	ok(src.contains("_communion_chain = true") and \
		src.contains("_communion_chain = false"),
		"§6: it is raised and lowered around the walk")


# ---------- §4: what the contribution metric can and cannot see ----------

# BC's grid read `-Devoutness` at 80% with SLIGHTLY HIGHER healing than the
# full lane, i.e. a node that removes 20% of the party's incoming Break damage
# moved the headline by zero. §4 asks which of two things that is. IT IS THE
# INSTRUMENT, and the answer is legible at the two sites below — so it is
# pinned here rather than only written down, because the same blind spot
# reaches the Warden's THREAT lane and every Break-focused build after him.
#
# NOTHING IS CHANGED BY THIS BATCH. The check exists so that a later batch
# which DOES add a Break term to the share has to come here and say so.
#
# BATCH BF §1 CAME HERE AND SAID SO. It did NOT fold Break into the share — it
# gave Break its own two columns beside it and left this one alone, so every
# assertion below still holds and the one that reads the format string reads a
# longer one. The invariant this function protects is unchanged and is the
# control that makes BF's new columns readable: `d+h+p%` is still damage,
# healing and damage-prevented over the same three, and nothing else.
func _contribution_cannot_see_break() -> void:
	var src := _src("res://scripts/battle.gd")
	# The share itself: damage + healing + damage-prevented, over the same
	# three summed across the party. Break points appear in neither.
	ok(src.contains("100.0 * (dmg + heal + prev) / apool])"),
		"§4: the share is (damage + healing + prevented) / the same three, pooled")
	# BF's columns sit BESIDE it, over their own pool, and never inside it.
	ok(src.contains("100.0 * bd / bpool"),
		"§4: Break DEALT is its own share over its own pool (Batch BF §1)")
	ok(src.contains("var bpool: float = maxf(s.get(\"pool_bd_hero_\" + hero, 0.0), 1.0)"),
		"§4: ...and that pool is built from Break keys alone")
	# ... and the pool is built from exactly those three keys, so Break damage
	# DEALT is outside the denominator too. `bd_hero_` is printed beside the
	# share as its own column and never enters it.
	ok(src.contains("if key.begins_with(\"dmg_hero_\") or key.begins_with(\"heal_hero_\") \\"),
		"§4: the share pool accumulates only damage, healing and prevented")
	ok(src.contains("or key.begins_with(\"prev_hero_\"):"),
		"§4: ...three keys, and `bd_hero_` is not one of them")
	# Devoutness's Break reduction has a home, and that home is a dead end as
	# far as the share is concerned: `_on_unit_credit` banks it and RETURNS
	# before it can reach `_devout_heal` (and so `_stat_heal`).
	var door := src.find("if term == \"devoutness_break\":")
	# RE-POINTED BY BATCH BU: `_devout_heal` gained a fourth argument (the healed
	# unit, for Reprisal's ledger), so this fragment grew a `, healed`. The
	# question is unchanged and is still the one worth asking — is the Break
	# term branched off BEFORE the healing door, and does it return.
	var heal := src.find("_devout_heal(src_name, float(amount), term, healed)")
	ok(door > 0 and heal > door,
		"§4: the Break term is branched off before the healing door")
	ok(door > 0 and src.substr(door, heal - door).contains("return"),
		"§4: Break points removed are banked to faith_break_cut and go no further")
	_report.append("§4: contrib% = (dmg + heal + prev) / pool — Break points, " \
		+ "dealt OR prevented, are outside both numerator and denominator")


# ---------- live: the measured rates ----------

# One trial: reset the eligible ally to `stacks`, drive a release on the
# warrior, report whether Communion fired. Two detectors, because a fire is
# visible in different places depending on where the ally sits:
#   below 5 — the ally's own stack count went up;
#   at 5 under Apostle — the ally RELEASED, so a second release was banked.
func _measure(scene: Node, ally: BattleUnit, stacks: int, parked: bool) -> float:
	var war: BattleUnit = scene.get("heroes")[0]
	var fired := 0
	for _i in TRIALS:
		_isolate(scene, ally, stacks)
		var before := _stat_of(scene, "faith_releases")
		war.faith_stacks = 0
		scene.call("_gain_faith", war, RELEASE, "absorb")
		if parked:
			# The warrior's own release is always one of them.
			if _stat_of(scene, "faith_releases") - before >= 2.0:
				fired += 1
		elif ally.faith_stacks > stacks:
			fired += 1
	return float(fired) / float(TRIALS)


func _live_rate_at_one_stack() -> void:
	var scene := await _spawn({"dv_communion": 1})
	var dv := _devout(scene)
	ok(dv != null and dv.communion_ranks == COMMUNION,
		"§6: the Devout has learned Communion at %d" % COMMUNION)
	if dv != null:
		var rate := _measure(scene, scene.get("heroes")[1], 1, false)
		ok(absf(rate - 0.15) < 0.05,
			"§6: an ally at ONE stack advances 15%% of the time (read %.1f%%)" % \
				(100.0 * rate))
		_report.append("Communion at 1 stack: %.1f%% over %d trials (want 15%%)" % [
			100.0 * rate, TRIALS])
	await _kill(scene)
	_live_ran += 1


# THE ROW THAT SAYS THE BATCH WORKED. Three stacks was Communion's SATURATION
# POINT at 40 — 120%, a certainty, so one release deterministically produced
# another.
#
# BATCH DC — REPOINTED TO TWO, WHICH IS WHERE THE TOP OF THE BAND NOW IS.
# CZ §2 ruled `FAITH_RELEASE` = 3, so an ally AT three is at the payout and the
# walk skips him outright: three stacks measures the CLIFF, not the peak, and
# this row read 0.0% while the node worked perfectly. Two stacks is the deepest
# an ally can hold and therefore the highest chance Communion ever rolls — 30%.
#
# AND THE DETECTOR HAD TO MOVE WITH IT, WHICH IS THE HALF THAT IS EASY TO MISS.
# At three-of-five an advance left the ally at four and the STACK COUNT saw it.
# At two-of-three an advance takes him TO the threshold, which RELEASES and
# resets him to zero — so the stack-count detector reads every single fire as a
# miss and this row printed 0.0% against a node working perfectly. The release
# counter is the only honest witness once the driven depth is HELD_MAX; BF
# recorded that rule and this is the second suite to need it.
func _live_rate_at_two_stacks() -> void:
	var scene := await _spawn({"dv_communion": 1})
	var dv := _devout(scene)
	if dv != null:
		var rate := _measure(scene, scene.get("heroes")[1], HELD_MAX, true)
		ok(absf(rate - 0.01 * COMMUNION * HELD_MAX) < 0.05,
			"§6: an ally at TWO stacks advances 30%% of the time (read %.1f%%)" % \
				(100.0 * rate))
		# The whole thesis of the reprice, as an assertion: nothing is certain
		# any more. At 40 this rate was exactly 1.0.
		ok(rate < 0.90,
			"§6: the top of the band is no longer a guarantee (read %.1f%%)" % (100.0 * rate))
		_report.append("Communion at %d stacks (the top of the band): %.1f%% over %d trials (want 30%%, was 100%% at 40)" % [
			HELD_MAX, 100.0 * rate, TRIALS])
	await _kill(scene)
	_live_ran += 1


# §2, PINNED AS A NUMBER RATHER THAN AS PROSE. Communion read the recipient's
# CURRENT stacks and Apostle parks allies at 5 instead of resetting them, so in
# an Apostle build the chance was not 15% — it was 75%, and every advance on a
# parked ally was itself a release. THAT WAS THE OPEN QUESTION BE SHIPPED WITH;
# the test stated its cost so it could not be forgotten.
#
# BATCH BF §2 TOOK THE LEVER BE RECOMMENDED, so the number this function pins
# is now ZERO and the row is kept rather than deleted: it is the direct
# before/after of the fix, at the exact construction that produced the 75%.
func _live_rate_at_five_stacks_apostle() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	ok(dv != null and dv.apostle > 0, "§2: Apostle is learned")
	if dv != null:
		var rate := _measure(scene, scene.get("heroes")[1], RELEASE, true)
		ok(rate == 0.0,
			"§2 (BF): an Apostle-parked ally AT THE THRESHOLD is NEVER rolled for — was 75%% (read %.1f%%)" % \
				(100.0 * rate))
		_report.append("Communion on an Apostle-parked ally (%d stacks, the threshold): %.1f%% over %d trials (was 75%%, want 0%% since BF)" % [
			RELEASE, 100.0 * rate, TRIALS])
	await _kill(scene)
	_live_ran += 1


# ---------- live: the guard ----------

# THREE ALLIES ONE STACK SHORT OF THE PAYOUT IS ~1.8 EXPECTED ADVANCES PER
# RELEASE at 60% apiece, and every advance takes an ally to 5, which releases
# again. Above one, the loop sustains — so the guard is load-bearing at 15
# exactly as it was at 40. One call must bank at most one release per hero: the
# caster's own, plus one apiece for the three others. Without the guard those
# inner releases roll Communion again.
#
# BATCH BF §2 MOVED WHERE THE CASCADE RISK LIVES, so this drives it from ONE
# STACK BELOW THE THRESHOLD rather than at it. At the threshold the allies are
# skipped outright and the cascade is impossible by construction — a test that
# drove it from there would pass while measuring nothing, which is the failure
# mode this project keeps finding.
#
# BATCH DC: that band was four-below-five and is now TWO-below-three. The
# literal 4 outlived CZ §2's ruling and this row read `0 of 200 spread`.
func _live_chain_guard_bounds_the_cascade() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	if dv != null:
		var worst := 0.0
		var any_spread := 0
		for _i in 200:
			for h in heroes:
				h.faith_stacks = HELD_MAX
				h.hp = h.max_hp
			scene.get("sim_stats").clear()
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], RELEASE, "absorb")
			var rel := _stat_of(scene, "faith_releases")
			worst = maxf(worst, rel)
			if rel > 1.0:
				any_spread += 1
		ok(worst >= 1.0, "§6: the driven release actually happened")
		ok(any_spread > 0,
			"§6: the cascade is still REACHABLE from two stacks (%d of 200 spread)" % \
				any_spread)
		ok(worst <= float(heroes.size()),
			"§6: one release banks at most one per hero (%d), worst seen %.0f" % [
				heroes.size(), worst])
		_report.append("chain guard: worst releases from ONE call with three allies at %d stacks: %.0f (cap %d, spread in %d/200)" % [
			HELD_MAX, worst, heroes.size(), any_spread])
	await _kill(scene)
	_live_ran += 1


# The other half, and the one a "fix" would break: the guard is a re-entrancy
# latch, not a once-per-battle limiter. Two separate releases must BOTH roll.
#
# BATCH BF §2: driven from ONE BELOW THE THRESHOLD for the same reason as the
# check above — at the threshold the ally is skipped by the new condition and
# this would read 0 while claiming the latch had jammed. BATCH DC moved the
# literal from 4 to `HELD_MAX`. The ally is re-isolated between the two calls
# so the second release faces the same draw as the first; the question is
# whether the latch re-arms, not what the first roll happened to do.
func _live_guard_resets_between_releases() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	if dv != null:
		ok(not bool(scene.get("_communion_chain")),
			"§6: the latch starts down")
		var fired_late := 0
		for _i in 60:
			_isolate(scene, heroes[1], HELD_MAX)
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], RELEASE, "absorb")
			ok_quiet(not bool(scene.get("_communion_chain")))
			_isolate(scene, heroes[1], HELD_MAX)
			var before := _stat_of(scene, "faith_releases")
			heroes[0].faith_stacks = 0
			scene.call("_gain_faith", heroes[0], RELEASE, "absorb")
			if _stat_of(scene, "faith_releases") - before >= 2.0:
				fired_late += 1
		ok(not bool(scene.get("_communion_chain")),
			"§6: the latch is down again after every call")
		ok(fired_late > 0,
			"§6: a SECOND release still rolls Communion — the latch is not a limiter")
		_report.append("second-release fires: %d of 60" % fired_late)
	await _kill(scene)
	_live_ran += 1


# 60 latch reads inside a loop would drown the count; they are only interesting
# when one fails.
func ok_quiet(cond: bool) -> void:
	if not cond:
		checks += 1
		fails.append("§6: the latch stayed UP after a call returned")
