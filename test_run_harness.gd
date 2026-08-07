# test_run_harness.gd — the 3 correctness gates (recreated for Batch T; the
# original scratchpad copy died with its session):
#   DOD_GATE=1  hero win scaling, plus the Batch T awakening HP sync
#   DOD_GATE=2  talent spend conservation (RunSim ledger vs price replay)
#   DOD_GATE=3  enemy tier x slot scaling at the battle spawn site
# Run via run_harness.sh. Scene-spawning gates take one Godot process each
# and quit() before ever yielding a frame — the parked _run_battle timers
# never fire, so freed-object noise can't pollute a SCRIPT ERROR grep.
extends SceneTree

const SPECS := ["berserker", "cryomancer", "inquisitor", "beastmaster"]

var fails := 0


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) —
	# park everything on the first process_frame (the CLAUDE.md gotcha).
	process_frame.connect(_go, CONNECT_ONE_SHOT)


func _go() -> void:
	var gate := OS.get_environment("DOD_GATE")
	match gate:
		"1":
			_gate_win_scaling()
		"2":
			_gate_talent_conservation()
		"3":
			_gate_enemy_scaling()
		_:
			fails += 1
			print("  FAIL unknown DOD_GATE '%s'" % gate)
	print("GATE %s %s" % [gate, "PASS" if fails == 0 else "FAIL"])
	quit(0 if fails == 0 else 1)


func _check(label: String, got, want) -> void:
	if got == want:
		print("  ok   %s (%s)" % [label, str(got)])
	else:
		fails += 1
		print("  FAIL %s: got %s, want %s" % [label, str(got), str(want)])


func _setup_run(run: Node) -> void:
	run.sim_run = true  # save/clear are no-ops — never touch the real save
	run.new_run()
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


# ---------- gate 2: talent spend conservation ----------

func _gate_talent_conservation() -> void:
	var run: Node = root.get_node("Run")
	run.sim_run = true
	run.new_run()
	for i in run.party.size():
		run.party[i]["spec"] = SPECS[i]
		run.party[i]["tree"] = Talents.generate_tree(SPECS[i], run.party[i]["key"])
		run.sync_spec_hp(i)
	# Batch AI income: the awakening pays 1, mini-bosses 1, zone bosses 2,
	# fights nothing. A full 3-zone run is 1 + 3 + 4 = 8 per hero — exactly
	# one complete tree — so this books the whole run's supply.
	for i in run.party.size():
		run.award_spec_point(i)
	# Batch AN: walk the LINE and let it pay what it pays — one purse, 1
	# point per elite / mini-boss / boss, nothing from ordinary fights. The
	# whole point of driving the real ZONE_SHAPE here rather than a hand
	# count is that the schedule and the board can never drift apart.
	for zone in run.SLOT_COUNT:
		run.zone_idx = zone
		for ty in run.ZONE_SHAPE:
			run.award_talent_points(String(ty))
	var before := 0
	var before_flex := 0
	for m in run.party:
		before += int(m["talent_points"])
		before_flex += int(m.get("talent_flex", 0))
	# 12 from the line + 1 from the awakening, on each of four heroes.
	_check("income booked (13 x 4 heroes)", before, 52)
	_check("no flex purse is fed any more", before_flex, 0)
	RunSim._run_spent = 0
	RunSim._spend_talents(run)
	var after := 0
	var after_flex := 0
	for m in run.party:
		after += int(m["talent_points"])
		after_flex += int(m.get("talent_flex", 0))
	_check("ledger: earned - banked == spent",
		(before - after) + (before_flex - after_flex), RunSim._run_spent)
	_check("something was bought", RunSim._run_spent > 0, true)
	# Replay every purchase at the flat price: 1 point a node, no exceptions.
	# The count of learned nodes IS the points paid.
	var replay_total := 0
	for m in run.party:
		var tree: Array = m["tree"]
		var learned: Dictionary = m.get("talents", {})
		_check("no talent_order left (%s)" % m["spec"], m.has("talent_order"), false)
		for id in learned:
			_check("single rank (%s/%s)" % [m["spec"], id], int(learned[id]), 1)
			var node := Talents.node_in_tree(tree, String(id))
			_check("node is in the tree (%s/%s)" % [m["spec"], id], node.is_empty(), false)
		replay_total += Talents.points_spent(learned)
		# Batch AN: 13 points buys 13 nodes — eight of them the tree proper
		# (seven rows and a capstone) and the other five widening five of
		# those rows to two picks each. The ceiling is 15 (the capstone row
		# never takes a second), so a fully-fed hero is still short of it and
		# the surplus is a real choice rather than a formality.
		_check("complete tree (%s)" % m["spec"], learned.size(), 13)
		_check("capstone taken (%s)" % m["spec"],
			Talents.has_capstone(tree, learned), true)
		_check("bank not negative (%s)" % m["spec"],
			int(m["talent_points"]) >= 0, true)
		_check("elite purse not negative (%s)" % m["spec"],
			int(m.get("talent_flex", 0)) >= 0, true)
		# No row ever holds three.
		for row in range(1, Talents.CAPSTONE_ROW + 1):
			_check("row %d <= 2 picks (%s)" % [row, m["spec"]],
				Talents.row_picks(tree, learned, row).size() <= Talents.MAX_PER_ROW, true)
	_check("price replay == points paid", replay_total, RunSim._run_spent)


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
