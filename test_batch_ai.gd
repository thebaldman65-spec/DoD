# test_batch_ai.gd — the Batch AI structure gates. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ai.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. SHAPE — every tree is 3 lanes x 7 rows + a capstone row, one node per
#      lane per row, single rank, no leftover tier/exclusive_with. The four
#      class batches re-author all 252 nodes; this is the mould they pour into.
#   2. GATING — row 1 open, row N needs row N-1, capstones need 7/7 and take
#      one, any lane.
#   3. THE ELITE CRACK (§6) — a second node in a picked row costs a FLEX
#      point, and the third is never reachable.
#   4. HOOKS (§5) — has_node / owns_ability / payload.condition, including
#      that owns_ability reads the same list the action bar does.
#   5. THE ECONOMY — a 3-zone run pays exactly 8 normal points, which is
#      exactly one complete tree.
#   6. MIGRATION — a pre-AI save is wiped and re-issued on the new schedule.
extends SceneTree

var passed := 0
var failed := 0


func ok(cond: bool, msg: String) -> void:
	if cond:
		passed += 1
	else:
		failed += 1
		print("  FAIL: ", msg)


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	process_frame.connect(_go, CONNECT_ONE_SHOT)


func _go() -> void:
	var run: Node = root.get_node("Run")
	run.sim_run = true
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")

	_shape()
	_gating()
	_elite_crack()
	_hooks(run)
	_conditions()
	_economy(run)
	_migration(run)

	print("BATCH AI: %d passed, %d FAILED" % [passed, failed])
	quit(1 if failed > 0 else 0)


# ---------- 1. shape ----------

func _shape() -> void:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var tree: Array = Talents.generate_tree(spec, key)
			ok(tree.size() == 24, "%s: %d nodes, want 24 (7 rows x 3 + 3 capstones)" % [
				spec, tree.size()])
			var seen_rows := {}
			for row in range(1, Talents.CAPSTONE_ROW + 1):
				var nodes: Array = Talents.row_nodes(tree, row)
				ok(nodes.size() == 3, "%s row %d holds %d nodes, want 3" % [
					spec, row, nodes.size()])
				var lanes := {}
				for t in nodes:
					seen_rows[String(t["id"])] = true
					lanes[String(t.get("lane", ""))] = true
					ok(int(t["ranks"]) == 1, "%s/%s: ranks %d, want 1" % [
						spec, t["id"], int(t["ranks"])])
					ok(not t.has("tier"),
						"%s/%s still carries the retired 'tier'" % [spec, t["id"]])
					ok(not t.has("exclusive_with"),
						"%s/%s still carries the retired 'exclusive_with'" % [spec, t["id"]])
					ok(not t.has("node_gated"),
						"%s/%s still carries the retired 'node_gated'" % [spec, t["id"]])
					ok(t.has("desc") and String(t["desc"]) != "",
						"%s/%s has no desc" % [spec, t["id"]])
					# capstone flag and row 8 must agree, or the shelf layout
					# and the gate disagree about what a capstone is.
					ok((row == Talents.CAPSTONE_ROW) == bool(t.get("capstone", false)),
						"%s/%s: capstone flag disagrees with row %d" % [spec, t["id"], row])
				ok(lanes.size() == 3,
					"%s row %d spans %d lanes, want 3 (one per lane)" % [
						spec, row, lanes.size()])
			ok(seen_rows.size() == 24,
				"%s: %d nodes carry a row 1-8 — some node is off the grid" % [
					spec, seen_rows.size()])


# ---------- 2. gating ----------

func _gating() -> void:
	var tree: Array = Talents.generate_tree("berserker", "warrior")
	var learned := {}
	var caps: Array = Talents.row_nodes(tree, Talents.CAPSTONE_ROW)
	ok(Talents.open_row(tree, learned) == 1, "the frontier starts at row 1")
	ok(Talents.can_learn(tree, "bz_savagery", learned)["ok"], "row 1 is open from the start")
	for row in range(2, Talents.CAPSTONE_ROW):
		var probe: String = String(Talents.row_nodes(tree, row)[0]["id"])
		var c := Talents.can_learn(tree, probe, learned)
		ok(not c["ok"] and String(c["why"]).begins_with("Locked"),
			"row %d is shut before row 1 is picked (%s)" % [row, c["why"]])
	ok(not Talents.can_learn(tree, String(caps[0]["id"]), learned)["ok"],
		"the capstone shelf is shut at 0/7")

	# A pure Bloodletting walk: one node a row, seven rows, then a capstone.
	for row in range(1, Talents.CAPSTONE_ROW):
		var pick := ""
		for t in Talents.row_nodes(tree, row):
			if String(t["lane"]) == "Bloodletting":
				pick = String(t["id"])
		ok(pick != "", "Bloodletting has a node in row %d" % row)
		var c := Talents.can_learn(tree, pick, learned)
		ok(c["ok"] and c["pool"] == "points",
			"row %d takes a NORMAL point (%s/%s)" % [row, c["ok"], c["pool"]])
		learned[pick] = 1
		ok(Talents.open_row(tree, learned) == row + 1,
			"picking row %d moves the frontier to %d" % [row, row + 1])

	var cap_check := Talents.can_learn(tree, String(caps[0]["id"]), learned)
	ok(cap_check["ok"] and cap_check["pool"] == "points",
		"the shelf opens at 7/7 for a normal point")
	# No lane purity: the walk above was all Bloodletting, so take a capstone
	# from a DIFFERENT lane and it must still be legal.
	var off_lane := ""
	for t in caps:
		if String(t["lane"]) != "Bloodletting":
			off_lane = String(t["id"])
	ok(off_lane != "", "the shelf holds an off-lane capstone to test with")
	ok(Talents.can_learn(tree, off_lane, learned)["ok"],
		"a capstone in an untouched lane is legal — no purity requirement")
	learned[off_lane] = 1
	for t in caps:
		if String(t["id"]) == off_lane:
			continue
		var c := Talents.can_learn(tree, String(t["id"]), learned)
		ok(not c["ok"] and String(c["why"]).begins_with("Barred"),
			"only ONE capstone, ever (%s)" % c["why"])
	ok(Talents.points_spent(learned) == 8,
		"a complete tree is 8 nodes, counted %d" % Talents.points_spent(learned))
	ok(Talents.has_capstone(tree, learned), "has_capstone sees the shelf pick")


# ---------- 3. the elite crack (§6) ----------

func _elite_crack() -> void:
	var tree: Array = Talents.generate_tree("swordmaster", "warrior")
	var learned := {}
	var row1: Array = Talents.row_nodes(tree, 1)
	learned[String(row1[0]["id"])] = 1
	# The two siblings are shut to normal points and open to elite ones.
	for i in [1, 2]:
		var c := Talents.can_learn(tree, String(row1[i]["id"]), learned)
		ok(c["ok"] and c["pool"] == "flex",
			"a shut sibling is FLEX-only, got ok=%s pool=%s" % [c["ok"], c["pool"]])
		ok(String(c["why"]).begins_with("Closed"),
			"...and says so in the tooltip: '%s'" % c["why"])
	# Force one open. The third must stay shut forever, with either purse.
	learned[String(row1[1]["id"])] = 1
	var third := Talents.can_learn(tree, String(row1[2]["id"]), learned)
	ok(not third["ok"], "the THIRD node in a row is never reachable")
	ok(String(third["why"]).begins_with("Closed"),
		"...and reads as Closed, not Locked (%s)" % third["why"])
	ok(third["pool"] == "", "...and names no purse that could buy it")
	# A flex point cannot open a NEW row: row 2 is still gated on row 1 only,
	# and row 2's first pick is a normal-point purchase.
	var r2 := Talents.can_learn(tree, String(Talents.row_nodes(tree, 2)[0]["id"]), learned)
	ok(r2["ok"] and r2["pool"] == "points",
		"opening a new row is always a NORMAL point, never flex")


# ---------- 4. hooks (§5) ----------

func _hooks(run: Node) -> void:
	var m := {"key": "warrior", "spec": "berserker", "talents": {},
		"tree": Talents.generate_tree("berserker", "warrior")}
	ok(not Talents.has_node(m["talents"], "bz_battle_shout"), "has_node: false when untaken")
	ok(not Talents.owns_ability(m, "Battle Shout"), "owns_ability: false for an unlearned grant")
	m["talents"] = {"bz_battle_shout": 1}
	ok(Talents.has_node(m["talents"], "bz_battle_shout"), "has_node: true when taken")
	ok(Talents.owns_ability(m, "Battle Shout"), "owns_ability: true for a learned grant")
	ok(Talents.owns_ability(m, "Hack and Slash"),
		"owns_ability: true for a STARTING KIT piece (any source, not just talents)")
	ok(not Talents.owns_ability(m, "Not An Ability"), "owns_ability: false for a stranger")
	ok(not Talents.owns_ability({}, "Battle Shout"), "owns_ability: safe on an empty member")
	# An earned pool pick counts too — that is the whole point of reading the
	# action bar's own list rather than the tree.
	m["bm_abilities"] = ["Rallying Shout"]
	ok(Talents.owns_ability(m, "Rallying Shout"),
		"owns_ability: true for an EARNED pool pick")
	# ...and it must BE that list, not a second copy of it.
	ok(run.owned_ability_names(m) == Talents.ability_names(m),
		"Run.owned_ability_names and Talents.ability_names are one list")


# ---------- 4b. payload.condition, the one read site ----------

func _conditions() -> void:
	var m := {"key": "warrior", "spec": "berserker", "talents": {"bz_battle_shout": 1},
		"tree": Talents.generate_tree("berserker", "warrior")}
	var ctx := {"learned": m["talents"], "member": m}
	var cfg := {"abilities": []}

	Talents.apply_payload(cfg, {"condition": {"has_node": "bz_savagery"},
		"stat": {"p1": 5}}, 1, ctx)
	ok(not cfg.has("p1"), "condition has_node UNMET: the payload does nothing at all")
	Talents.apply_payload(cfg, {"condition": {"has_node": "bz_battle_shout"},
		"stat": {"p2": 5}}, 1, ctx)
	ok(int(cfg.get("p2", 0)) == 5, "condition has_node MET: the payload applies")
	Talents.apply_payload(cfg, {"condition": {"owns_ability": "Battle Shout"},
		"stat": {"p3": 3}}, 1, ctx)
	ok(int(cfg.get("p3", 0)) == 3, "condition owns_ability MET: the payload applies")
	Talents.apply_payload(cfg, {"condition": {"owns_ability": "Nope"},
		"stat": {"p4": 3}}, 1, ctx)
	ok(not cfg.has("p4"), "condition owns_ability UNMET: the payload does nothing")
	# Both forms in one condition: ALL must hold.
	Talents.apply_payload(cfg, {"condition": {"has_node": "bz_battle_shout",
		"owns_ability": "Nope"}, "stat": {"p5": 1}}, 1, ctx)
	ok(not cfg.has("p5"), "a two-part condition needs BOTH halves")
	# A conditional payload with no ctx is inert, not silently unconditional —
	# an effect that fails to appear is a bug you can see.
	Talents.apply_payload(cfg, {"condition": {"has_node": "bz_battle_shout"},
		"stat": {"p6": 1}}, 1, {})
	ok(not cfg.has("p6"), "no ctx: a conditional payload stays inert")
	# ...and an UNconditional payload is untouched by any of this.
	Talents.apply_payload(cfg, {"stat": {"p7": 1}}, 1, {})
	ok(int(cfg.get("p7", 0)) == 1, "no condition: applies exactly as before")
	# Conditions gate ability grants too, not just stats.
	Talents.apply_payload(cfg, {"condition": {"has_node": "bz_savagery"},
		"new_ability": {"display_name": "Ghost", "cost": 0}}, 1, ctx)
	ok(cfg["abilities"].is_empty(), "a gated new_ability is not granted either")


# ---------- 5. the economy ----------

func _economy(run: Node) -> void:
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var total := 0
	run.award_spec_point(0)
	total += 1
	for zone in 3:
		for f in 5:
			total += run.award_talent_points("fight")
		total += run.award_talent_points("miniboss")
		run.zone_idx = zone
		total += run.award_talent_points("boss")
	ok(total == 8, "a 3-zone run guarantees %d normal points, want 8" % total)
	ok(run.party[0]["talent_points"] == 8, "...banked on every hero (%d)" % \
		int(run.party[0]["talent_points"]))
	run.zone_idx = 0
	ok(run.award_talent_points("fight") == 0, "regular fights pay nothing")
	ok(run.award_talent_points("elite") == 0, "elites pay no NORMAL point")
	ok(run.award_talent_flex("elite") == 1, "elites pay 1 point into the flex purse")
	ok(run.award_talent_flex("miniboss") == 0, "nothing else pays flex")
	ok(run.award_talent_flex("boss") == 0, "...not even a boss")
	run.zone_idx = 2
	ok(run.award_talent_points("boss") == 0,
		"the FINAL boss pays nothing — points with nothing after them")


# ---------- 6. save migration (§7) ----------

func _migration(run: Node) -> void:
	# A hero mid-run under the OLD scheme: multi-rank purchases, a purchase
	# order, points banked at the old prices. Zone 2 (so two zone bosses and
	# two mini-bosses are behind them), standing past this zone's mini-boss.
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	run.specs_chosen = true
	run.zone_idx = 2
	run.floor_idx = run.MINIBOSS_TIER + 1
	for m in run.party:
		m["spec"] = "berserker"
		m["talents"] = {"bz_savagery": 3, "bz_bloodcraze": 2}
		m["talent_order"] = ["bz_savagery", "bz_bloodcraze"]
		m["talent_points"] = 4
	run._migrate_trees(5)  # a v5 save: everything before Batch AI
	for m in run.party:
		ok(m["talents"].is_empty(), "a pre-AI tree is WIPED, not translated")
		ok(not m.has("talent_order"), "...and the dead purchase order goes with it")
		ok(int(m["talent_flex"]) == 0, "...flex starts empty")
		# 1 spec + 2 zone bosses x2 + 2 mini-bosses behind + this zone's = 8.
		ok(int(m["talent_points"]) == 8,
			"...and the purse is re-issued on the new schedule: %d, want 8" % \
				int(m["talent_points"]))
		ok(not m["tree"].is_empty(), "...on a live tree")
	# A same-version save keeps its picks: migration must not fire twice.
	for m in run.party:
		m["talents"] = {"bz_savagery": 1}
		m["talent_points"] = 3
	run._migrate_trees(6)
	for m in run.party:
		ok(m["talents"].has("bz_savagery"), "a v6 save keeps its picks")
		ok(int(m["talent_points"]) == 3, "...and its purse")
