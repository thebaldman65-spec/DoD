# test_run_harness.gd — the 3 correctness gates (recreated for Batch T; the
# original scratchpad copy died with its session):
#   DOD_GATE=1  hero win scaling, plus the Batch T awakening HP sync
#   DOD_GATE=2  talent conservation — a run earns nothing, and what it WEARS
#               is legal (BATCH BM's subject; BATCH CA made it run)
#   DOD_GATE=3  enemy tier x slot scaling at the battle spawn site
# Run one gate per process:
#   DOD_GATE=2 godot --headless --path . --script test_run_harness.gd
# Scene-spawning gates take one Godot process each and quit() before ever
# yielding a frame — the parked _run_battle timers never fire, so freed-object
# noise can't pollute a SCRIPT ERROR grep.
#
# ============================================================================
# BATCH CA — THREE STANDING RULES FOR EVERY GATE IN THIS FILE, PRESENT AND
# FUTURE. THEY EXIST BECAUSE GATE 2 PRINTED `GATE 2 PASS` ON ZERO ASSERTIONS
# FOR TWELVE BATCHES AND NOTHING LOOKED WRONG.
#
#   1. A GATE REPORTS ITS CHECK COUNT, NOT A VERDICT. `GATE 2 PASS (165
#      checks)`, never a bare `GATE 2 PASS`. A test that reports a QUANTITY is
#      auditable at a glance; a test that reports a VERDICT is only auditable
#      by reading it, and that is precisely why this one outlived the `ah` and
#      `an` cases — those printed counts.
#      CORRECTED BY BATCH CD, AND THE CORRECTION MATTERS MORE THAN THE RULE:
#      CA's next clause read "those printed counts that LOOKED WRONG", and they
#      did not. `ah` and `an` printed counts that were low by 125 and 2,434
#      checks and nobody saw it for twelve batches; three more suites were
#      doing the same thing. A QUANTITY IS ONLY AUDITABLE AT A GLANCE IF
#      SOMETHING IS COMPARING IT TO WHAT IT SHOULD BE. Until CD nothing was.
#      A COUNT THAT NOBODY DIFFS IS A WORD — test_batch_cd §1 is what diffs
#      them. IT WATCHED FIVE SUITES OUT OF FORTY-FIVE UNTIL BATCH DD, which is
#      why repairing five suites at DC did not move it by one line; it carries
#      every suite the battery runs now, as a BAND on the check count AND on the
#      failure count. An instrument's scope is part of its reading.
#   2. A GATE THAT RUNS ZERO CHECKS MUST FAIL. An empty gate is a broken gate,
#      and it is the one case where silence has to be loud. A gate printing a
#      count of zero is VISIBLY broken; the same gate printing PASS is not.
#   3. A GATE MUST REACH ITS OWN END. Every gate's last statement is
#      `_finish()`, and `_go` fails a gate that never got there. RULES 1 AND 2
#      DO NOT COVER THIS CASE ON THEIR OWN and that is why it is here: an abort
#      BELOW a gate's first check leaves a non-zero count, so it would print
#      `PASS (40 checks)` — visible to a reader who knows the number, but not
#      caught. Rule 3 is what makes the shape impossible rather than merely
#      legible, which is the whole point of the exercise.
#
# All three live in `_check` / `_check_range` / `_go` plus one call at the foot
# of each gate, so they bind every gate at once and a gate added later inherits
# 1 and 2 by doing nothing. THE SHAPE THEY CLOSE: a deleted function called
# ANYWHERE in a gate aborts the rest of it, and before Batch CA that was
# indistinguishable from a pass.
# ============================================================================
extends SceneTree

const SPECS := ["berserker", "cryomancer", "inquisitor", "beastmaster"]

# Gate 2 drives the META talent ledger, which lives on `Profile`. It is
# redirected to a scratch file for the duration and restored afterwards
# (`Profile.save_path` is a var for exactly this) — a gate that wrote the
# player's ledger would be a gate nobody could afford to run.
const SCRATCH_PROFILE := "user://gate2_profile.json"

var fails := 0
var checks := 0
# Set by `_finish()`, which is the LAST statement of every gate. An aborted
# gate never reaches it — see rule 3 in the header.
var finished := false


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) —
	# park everything on the first process_frame (the CLAUDE.md gotcha).
	process_frame.connect(_go, CONNECT_ONE_SHOT)


func _go() -> void:
	var gate := OS.get_environment("DOD_GATE")
	var known := gate in ["1", "2", "3"]
	match gate:
		"1":
			_gate_win_scaling()
		"2":
			_gate_talent_conservation()
		"3":
			_gate_enemy_scaling()
		_:
			# Routed through _check so an unknown gate is a FAILED CHECK rather
			# than a bare failure — otherwise it would trip the zero-check rule
			# below as well and report one problem twice.
			_check("DOD_GATE names a gate", gate, "1|2|3")
	# BATCH CA rules 3 and 2, in that order and deliberately EXCLUSIVE — a gate
	# that aborted above its first check satisfies both, and one problem should
	# be reported once.
	if known and not finished:
		fails += 1
		print("  FAIL GATE %s ABORTED before its end — %d checks ran, the rest never did"
			% [gate, checks])
	elif checks == 0:
		fails += 1
		print("  FAIL GATE %s ran ZERO checks — an empty gate is a broken gate" % gate)
	# BATCH CA rule 1: report the count, never a bare verdict.
	print("GATE %s %s (%d checks)" % [gate, "PASS" if fails == 0 else "FAIL", checks])
	quit(0 if fails == 0 else 1)


func _check(label: String, got, want) -> void:
	checks += 1
	if got == want:
		print("  ok   %s (%s)" % [label, str(got)])
	else:
		fails += 1
		print("  FAIL %s: got %s, want %s" % [label, str(got), str(want)])


# Batch BK: a branching map turns several of this file's constants into
# ranges. A range check states BOTH ends so it still fails on a real drift —
# a bare "is it plausible" would be the check quietly giving up.
func _check_range(label: String, got: float, lo: float, hi: float) -> void:
	checks += 1
	if got >= lo and got <= hi:
		print("  ok   %s (%s in [%s, %s])" % [label, str(got), str(lo), str(hi)])
	else:
		fails += 1
		print("  FAIL %s: got %s, want [%s, %s]" % [label, str(got), str(lo), str(hi)])


# THE LAST STATEMENT OF EVERY GATE. Do not move it, do not make it
# conditional, and do not add an early `return` above it — a gate that can
# leave without reaching this line is a gate that can abort silently again.
func _finish() -> void:
	finished = true


# ---------- gate 2's ledger scaffolding ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


# Every point banked by every spec. A total rather than a per-spec read, so
# "the walk banked nothing" cannot be satisfied by looking at the wrong spec.
func _purse_total() -> int:
	var total := 0
	for spec in Classes.all_specs():
		total += Profile.talent_points_earned(String(spec))
	return total


func _profile_scratch() -> void:
	Profile.save_path = SCRATCH_PROFILE
	Profile.data = {}
	Profile.loaded = false
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))


func _profile_restore() -> void:
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.save_path = "user://profile.json"
	Profile.data = {}
	Profile.loaded = false


func _setup_run(run: Node) -> void:
	run.sim_run = true  # save/clear are no-ops — never touch the real save
	# BATCH BM: `new_run`'s default rung is 1 (x0.70) now, and gate 3 pins the
	# ZONE SLOT multiplier at the values the enemy ladder was fitted against.
	# Arm rung 2 explicitly — it IS the pre-BM balance, byte for byte — so the
	# gate keeps measuring the same ladder rather than the new default.
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "warden")
	for i in run.party.size():
		run.party[i]["spec"] = SPECS[i]
		run.party[i]["tree"] = []  # no talents: the scaling asserts stay pure
		run.sync_spec_hp(i)
	run.specs_chosen = true


# ---------- gate 1: hero win scaling (+ awakening HP sync) ----------

func _gate_win_scaling() -> void:
	var run: Node = root.get_node("Run")
	_setup_run(run)
	# Awakening HP sync (Batch T stage 1): the spec stat block's max HP
	# raise must reach CURRENT hp too, or the party fights at ~75% health.
	for i in run.party.size():
		var spec_hp: int = int(Classes.SPEC_INFO[SPECS[i]]["max_hp"])
		_check("sync max_hp %s" % SPECS[i], int(run.party[i]["max_hp"]), spec_hp)
		_check("sync hp %s" % SPECS[i], int(run.party[i]["hp"]), spec_hp)
	# The raise matches the delta, never heals to full: damage carries over.
	run.party[0]["max_hp"] = 154
	run.party[0]["hp"] = 100  # 54 damage on the class chassis
	run.sync_spec_hp(0)
	_check("sync preserves damage", int(run.party[0]["hp"]),
		int(Classes.SPEC_INFO["berserker"]["max_hp"]) - 54)
	run.party[0]["hp"] = int(run.party[0]["max_hp"])
	# Win scaling: +2% of the SPEC base Attack/HP per combat win, linear,
	# compounding off the spec stat block (the Batch T ordering trap).
	var wins := 10
	run.combat_wins = wins
	run.slot_idx = 0
	run.encounter = {"type": "fight", "enemies": ["raider", "archer"],
		"theme": "Warband"}
	var battle: Node = (load("res://scenes/battle.tscn") as PackedScene).instantiate()
	root.add_child(battle)  # _ready spawns units, then parks on its first await
	_check("hero count", battle.heroes.size(), 4)
	for i in battle.heroes.size():
		var spec: String = SPECS[i]
		var base_atk: int = Classes.spec_attack(spec)
		var spec_hp: int = int(Classes.SPEC_INFO[spec]["max_hp"])
		var u = battle.heroes[i]
		_check("win-scaled attack %s" % spec, int(u.attack),
			int(round(base_atk * (1.0 + 0.02 * wins))))
		_check("win-scaled max_hp %s" % spec, int(u.max_hp),
			spec_hp + int(round(spec_hp * 0.02 * wins)))
		_check("member hp carried %s" % spec, int(u.hp), int(run.party[i]["hp"]))
	_finish()


# ---------- gate 2's seed ----------
#
# BATCH DX §2 — THE SECOND UNSEEDED FLAKE, AND IT IS SEEDED AT THE SITE THAT
# GENERATES THE BOARD RATHER THAN AT THE TOP OF THE FILE.
#
# Gate 2 walks a randomly GENERATED map by taking `reachable()[0]` at every
# step and then asserts each of six node types was crossed at least once. An
# unsteered greedy route can miss the rarest, and DW's acceptance battery is
# where it finally did — on *"the walk crossed a event"*, with `seed()` called
# zero times in this file.
#
# **DW's CHARACTERISATION OF THE FAILURE WAS TOO NARROW IN BOTH HALVES, AND
# THE MEASUREMENT IS WHY THE SEED GOES WHERE IT DOES.** Over 400 unseeded
# walks: the walk length is 49 EVERY time, `fight` never fell below 9, `elite`
# below 2 or `miniboss` below 3 — but **`blacksmith` reached ZERO once**, and
# `merchant` and `event` each came within one of it. So the at-risk population
# is THREE of the six types and not the one that happened to fail, and the rate
# is well under DW's estimated 3% (2 observed in ~474 readings, counting DW's
# own and 40 clean standalone re-runs at HEAD).
#
# **THE ASSERTION IS NOT WIDENED, AND THAT IS THE RULING RATHER THAN A DETAIL.**
# The six types being present is the QUESTION — a walk that met no elite proves
# nothing about elites, which is what the loop's own comment above says — so
# relaxing it to five would delete the check instead of repairing it. DD's
# method: force determinism AT THE SITE UNDER TEST.
#
# **AND IT IS SEEDED BEFORE EVERY GENERATION, NOT ONCE BEFORE THE WALK.** Both
# shapes were measured and both are exactly repeatable; this one is repeatable
# for a reason that cannot be broken from a distance. Seeding once would leave
# zones 1 and 2 drawing off whatever the loop consumed before them, so a later
# batch adding one RNG draw inside the walk would silently re-roll two of the
# three boards and could re-flake this gate with nothing in the diff to
# explain it. That is `bo`'s per-pair seed one layer out: the guarantee is
# per-BOARD, not per-suite. The three boards are still DIFFERENT from one
# another — `_generate_map` reads `zone_idx` — so this buys determinism
# without buying a degenerate map walked three times.
func _seeded() -> void:
	seed(20260829)


# ---------- gate 2: talent conservation ----------
#
# BATCH CA — READ THIS BEFORE CHANGING ANYTHING BELOW. This gate's first
# statement used to be `run.award_spec_point(i)`, which Batch BM DELETED, and
# that call sat ABOVE every `_check` in the function. The error aborted the
# whole body: zero checks ran, zero failed, and the gate printed `GATE 2 PASS`
# on the way out — for twelve batches, with every VERIFIED block since BM
# quoting "gates 1/2/3" on the strength of it. The three structural rules in
# this file's header are what make that shape impossible; what follows is the
# re-point, and it is a re-point WITH A REASON, so it is written down.
#
# THE ORIGINAL SUBJECT was "talent spend conservation": points EARNED against
# points PAID inside one run, replayed against a price curve. BATCH BM DELETED
# THE THING BEING CONSERVED — talents are META now, bought per spec on
# `Profile` out of zone-boss income and EQUIPPED before a run begins, so there
# is no in-run purse to conserve. BM re-pointed the gate in place and the
# replacement has never executed once. It executes now, in two halves that
# match BM's own split of the old subject:
#
#   §1 INCOME. A RUN AWARDS NOTHING. The whole board is walked and pays not a
#      single point; the ONE door is `Run.bank_zone_boss_points`, it opens at
#      a ZONE boss and nowhere else, the END boss opens it never, and a SIM
#      must never open it at all.
#   §2 THE LOADOUT. What a run WEARS is legal: exactly one node per row, every
#      id real, every rank 1, and nothing bought along the way. These are BM's
#      own assertions, running for the first time.
#
# THE DIVERGENCE FROM THE BRIEF, STATED: Batch CA §3 offered the income rules
# as "a starting point and not an instruction" and asked that a different
# original intent be tested instead and recorded. Both are here. §1 is the
# brief's list; §2 is what the surviving lines below the abort actually asked,
# and it is the half this HARNESS specifically owes — gates 1 and 3 pin what a
# SIM's units are spawned with, so gate 2 pins what a SIM's heroes are BUILT
# with. Dropping §2 would have left `RunSim.install_builds` ungated.

func _gate_talent_conservation() -> void:
	var run: Node = root.get_node("Run")
	run.sim_run = true
	# The ledger is redirected BEFORE anything can read it, and restored at the
	# end of the gate.
	_profile_scratch()
	_seeded()
	run.new_run()
	for i in run.party.size():
		run.party[i]["spec"] = SPECS[i]
		run.party[i]["tree"] = Talents.generate_tree(SPECS[i], run.party[i]["key"])
		run.sync_spec_hp(i)

	# ---- §1 income: a run awards nothing ----
	# The two verbs this gate used to call are gone, and they are pinned ABSENT
	# rather than merely unused — a later batch re-adding either would be
	# re-adding the in-run purse BM deleted.
	_check("Run.award_spec_point is gone", run.has_method("award_spec_point"), false)
	_check("Run.award_talent_points is gone",
		run.has_method("award_talent_points"), false)
	_check("the one income door exists",
		run.has_method("bank_zone_boss_points"), true)
	# BATCH BK's structure, kept and re-pointed: walk the generated MAP rather
	# than counting by hand, because a hand count and the board can drift apart
	# and a walk cannot. What it asks now is the opposite of what it asked
	# then — the board must pay NOTHING.
	var walked := 0
	var counts := {}
	for zone in run.SLOT_COUNT:
		run.zone_idx = zone
		run.slot_idx = -1
		run.node_idx = 0
		if zone > 0:
			_seeded()
			run._generate_map()
		while true:
			var reach: Array = run.reachable()
			if reach.is_empty():
				break
			run.advance(int(reach[0]))
			var ty := String(run.current_node()["type"])
			counts[ty] = int(counts.get(ty, 0)) + 1
			walked += 1
	# A walk that met no elite proves nothing about elites, so the types are
	# asserted PRESENT before the purse is asserted empty — otherwise "nothing
	# paid" is satisfied by a board nobody crossed.
	for ty in ["fight", "elite", "miniboss", "blacksmith", "merchant", "event"]:
		_check("the walk crossed a %s" % ty, int(counts.get(ty, 0)) > 0, true)
	_check("the walk is 49 encounters", walked, 49)
	_check("three ZONE bosses", int(counts.get("boss", 0)), 3)
	_check("one END boss", int(counts.get("endboss", 0)), 1)
	# An unsteered route takes what it is offered, so the ordinary-fight count
	# is a RANGE. Both ends stated, so it still fails on a real drift.
	_check_range("ordinary fights walked", float(counts.get("fight", 0)), 9.0, 33.0)
	_check("the whole walk banked NOTHING", _purse_total(), 0)

	# THE ONE DOOR. A SIM MUST NEVER OPEN IT — a simulated run that wrote the
	# player's ledger would make every baseline depend on whoever ran it, and
	# the guard is one `sim_run` check that a later batch could delete without
	# anything failing.
	run.bank_zone_boss_points()
	_check("a SIM banks nothing at a zone boss", _purse_total(), 0)
	# Off the harness rails for exactly three statements. `sim_run` is what
	# makes save/clear no-ops, so nothing between here and the re-arm below
	# may touch the run save.
	run.sim_run = false
	run.bank_zone_boss_points()
	for spec in SPECS:
		_check("a zone boss banks 1 to %s" % spec,
			Profile.talent_points_earned(spec), 1)
	_check("a spec that did not play banks 0",
		Profile.talent_points_earned("holy"), 0)
	_check("the party's specs each bank their own", _purse_total(), SPECS.size())
	# A run that dies in zone 2 keeps what the zone bosses it CLEARED paid.
	# Partial credit is the mechanism, not a rule beside it.
	run.bank_zone_boss_points()
	for spec in SPECS:
		_check("a zone-2 wipe keeps 2 for %s" % spec,
			Profile.talent_points_earned(spec), 2)
	# An un-awakened hero has no spec and banks nothing.
	var held := String(run.party[0]["spec"])
	run.party[0]["spec"] = ""
	run.bank_zone_boss_points()
	_check("an un-awakened hero banks nothing", Profile.talent_points_earned(""), 0)
	_check("the awakened three still banked", Profile.talent_points_earned(SPECS[1]), 3)
	_check("the un-awakened one did not", Profile.talent_points_earned(held), 2)
	run.party[0]["spec"] = held
	run.sim_run = true
	# THE END BOSS AWARDS NONE, and that is a rule about what `_resolve_boss`
	# does NOT call — so it is asserted against the source, which is the only
	# place a rule with no reachable gate can be checked at all (BM's idiom).
	var bs := _src("res://scripts/battle.gd")
	# **BATCH EG — THE WINDOW IS THE FUNCTION NOW, NOT 2400 CHARACTERS, AND THIS
	# IS THE SECOND COPY OF IT.** `test_batch_bm` §6 carries the same slice and
	# **both went red on the same EG comment block**, which is the copied-helper
	# rule arriving in a scan: a window duplicated between two targets inherits
	# its blind spot twice and diverges silently. ED §2's rule is the general
	# form — a scan that captures a WINDOW is blind to what the window
	# swallowed. The slice runs to the next top-level `func ` instead, which is
	# the function itself and cannot be outgrown by anything written inside it.
	#
	# **EE §4's GUARD IS WHAT SAID SO HERE TOO**, and here it matters more: the
	# ONLY assertion on this slice is a NEGATIVE one, so an empty `end_half`
	# would have satisfied it for every needle, in silence.
	var rb_at := bs.find("func _resolve_boss")
	var rb_end := bs.find("\nfunc ", rb_at + 1)
	var body := bs.substr(rb_at, (rb_end - rb_at) if rb_end > rb_at else 2400)
	# GUARDED (BATCH EE §4). The same comment anchor `test_batch_bm` reads, and
	# here the ONLY assertion on the slice is a negative one — an empty
	# `end_half` satisfies it for every needle, in silence.
	var half_at := body.find("# The end boss.")
	_check("the end-boss comment anchor resolves", half_at >= 0, true)
	var end_half := body.substr(half_at)
	_check("the end boss banks no talent points",
		end_half.contains("bank_zone_boss_points"), false)
	_check("the zone boss does", body.contains("Run.bank_zone_boss_points()"), true)

	# ---- §2 the loadout: what a run WEARS is legal ----
	# BATCH BM's replacement assertions. They needed a loadout to look at and
	# never had one — `new_run` installs nothing, so every check below would
	# have failed on the day BM wrote it had the function reached them.
	RunSim.install_builds(run)
	for i in run.party.size():
		run.equip_spec_talents(i)
	_check("the sim installed a loadout", run.sim_talents.is_empty(), false)
	for m in run.party:
		_check("no in-run purse on the member (%s)" % m["spec"],
			m.has("talent_points") or m.has("talent_flex"), false)
		_check("the member wears the installed loadout (%s)" % m["spec"],
			(m.get("talents", {}) as Dictionary).size(), RunSim.rows_built)
	for m in run.party:
		var tree: Array = m["tree"]
		var learned: Dictionary = m.get("talents", {})
		_check("no talent_order left (%s)" % m["spec"], m.has("talent_order"), false)
		for id in learned:
			_check("single rank (%s/%s)" % [m["spec"], id], int(learned[id]), 1)
			var node := Talents.node_in_tree(tree, String(id))
			_check("node is in the tree (%s/%s)" % [m["spec"], id], node.is_empty(), false)
		# BATCH BM RE-POINTED GATE 2 IN PLACE. Its subject was the IN-RUN
		# PURSE — points earned against points paid, the surplus buying second
		# nodes, and no row holding three — and BM deleted all of it: talents
		# are META now, bought per spec on Profile and EQUIPPED before a run
		# starts. There is nothing to conserve inside a run any more. What is
		# still worth gating, and is what the loop asserts now, is that THE
		# LOADOUT A RUN WEARS IS LEGAL: exactly one node per row, every id
		# real, every rank 1, and nothing bought along the way.
		var by_row := {}
		for id in learned:
			var n2 := Talents.node_in_tree(tree, String(id))
			var r := int(n2.get("row", 0))
			_check("row %d holds ONE equipped node (%s)" % [r, m["spec"]],
				by_row.has(r), false)
			by_row[r] = id
		_check("no in-run purse survives (%s)" % m["spec"],
			m.has("talent_points") or m.has("talent_flex"), false)
		# The harness equips the same depth for every hero, so the count is
		# exactly what DOD_SIM_ROWS asked for.
		_check("loadout depth (%s)" % m["spec"], learned.size(), RunSim.rows_built)
	# BATCH CA: "nothing was spent in a run" used to be `_check(replay_total, 0)`
	# against a local initialised to 0 and never touched — a check that could
	# only ever pass, which is the same gap this whole batch is about arriving
	# from the other side. It asks the question mechanically now: the verbs that
	# spent an in-run purse are GONE, so there is no spending to conserve.
	# `Talents` is a class_name script rather than an instance, so `has_method`
	# is not available on it — the absences are asserted against the SOURCE,
	# which is BM's own idiom for a rule with no reachable gate.
	var ts := _src("res://scripts/talents.gd")
	for verb in ["can_learn", "purse_for", "points_spent"]:
		_check("Talents.%s is gone" % verb, ts.contains("func %s(" % verb), false)
	_check("MAX_PER_ROW is gone", ts.contains("MAX_PER_ROW"), false)
	_check("the meta spend door exists", ts.contains("func can_buy("), true)
	_check("buying and equipping are separate questions",
		ts.contains("func can_equip("), true)
	_profile_restore()
	_finish()


# ---------- gate 3: enemy tier x slot scaling ----------

func _gate_enemy_scaling() -> void:
	var run: Node = root.get_node("Run")
	_setup_run(run)
	# Zone slot 2 (x1.5), tier 4 — the old cliff tier, worth pinning exactly.
	run.zone_idx = 1
	run.slot_idx = 3
	var kinds := ["raider", "archer", "shaman"]
	run.encounter = {"type": "fight", "enemies": kinds, "theme": "Warband"}
	var battle: Node = (load("res://scenes/battle.tscn") as PackedScene).instantiate()
	root.add_child(battle)
	var slot_mult: float = run.zone_base_mult(2)
	_check("slot 2 multiplier", slot_mult, 1.5)
	_check("enemy count", battle.enemies.size(), kinds.size())
	var zone_tier := 4
	for i in battle.enemies.size():
		var base: Dictionary = Enemies.config(kinds[i])
		var e = battle.enemies[i]
		_check("tier-scaled hp %s" % kinds[i], int(e.max_hp),
			int(ceil(int(base["max_hp"]) * slot_mult
				* (1.0 + 0.025 * zone_tier) / 10.0) * 10.0))
		_check("tier-scaled attack %s" % kinds[i], int(e.attack),
			int(round(int(base["attack"]) * slot_mult
				* (1.0 + 0.02 * zone_tier))))
	_finish()
