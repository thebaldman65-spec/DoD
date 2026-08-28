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


# BATCH BM RE-POINTED THIS FILE IN PLACE. Three of its sections described the
# IN-RUN talent economy — the frontier row, the elite "flex" crack, and the
# 8-points-against-an-8-node-tree arithmetic — and BM deleted all three with
# the purse they governed: talents are META now, bought per spec on Profile
# and equipped between runs. `_gating`, `_elite_crack` and `_economy` are
# REPLACED BY test_batch_bm's own spending and gating sections rather than
# being half-repaired here, because the question they asked no longer exists.
# WHAT SURVIVES IS EVERYTHING THAT IS STILL TRUE: the tree's SHAPE (re-pointed
# to 9 rows), the payload hooks, the conditions, and the save migration.
func _go() -> void:
	var run: Node = root.get_node("Run")
	run.sim_run = true
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")

	_shape()
	_hooks(run)
	_conditions()
	_migration(run)

	print("BATCH AI: %d passed, %d FAILED" % [passed, failed])
	quit(1 if failed > 0 else 0)


# ---------- 1. shape ----------

func _shape() -> void:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var tree: Array = Talents.generate_tree(spec, key)
			# BATCH BM: 8 lane rows + the capstone shelf at row 9.
			ok(tree.size() == 27, "%s: %d nodes, want 27 (8 rows x 3 + 3 capstones)" % [
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
			ok(seen_rows.size() == 27,
				"%s: %d nodes carry a row 1-9 — some node is off the grid" % [
					spec, seen_rows.size()])


# ---------- 2. gating ----------

func _hooks(run: Node) -> void:
	var m := {"key": "warrior", "spec": "berserker", "talents": {},
		"tree": Talents.generate_tree("berserker", "warrior")}
	ok(not Talents.has_node(m["talents"], "bz_battle_shout"), "has_node: false when untaken")
	ok(not Talents.owns_ability(m, "Battle Shout"), "owns_ability: false for an unowned card")
	m["talents"] = {"bz_battle_shout": 1}
	ok(Talents.has_node(m["talents"], "bz_battle_shout"), "has_node: true when taken")
	# BATCH DO — RE-POINTED TO THE OTHER DOOR, BECAUSE THE FIRST ONE IS SHUT.
	# `owns_ability` used to be reachable two ways: the kit held the card, or a
	# TALENT granted it. No talent grants anything now, so buying the node can
	# no longer make this true — and the EARNED path is the one that still
	# matters, because it is the only one a payload condition could ever read.
	ok(not Talents.owns_ability(m, "Battle Shout"),
		"owns_ability: still false — buying a node grants nothing (DO's charter)")
	m["bm_abilities"] = ["Battle Shout"]
	ok(Talents.owns_ability(m, "Battle Shout"),
		"owns_ability: TRUE once the card is actually earned")
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
	# BATCH DO — the CONDITION KIND is still live machinery and is exercised
	# here, but it has NO PAYLOAD USER IN THE TREES any more: the three
	# `owns_ability` riders (Sunder Guard's Shatterpoint, Rallying Cry's War
	# Stomp, Bulwark Line's Interpose) were the only ones and all three were
	# clause-cuts. It is kept and tested rather than deleted — deleting a
	# condition kind is a design change, and it is the natural mechanism for a
	# rune. The member has to EARN the card for the condition to read true.
	m["bm_abilities"] = ["Battle Shout"]
	Talents.apply_payload(cfg, {"condition": {"owns_ability": "Battle Shout"},
		"stat": {"p3": 3}}, 1, ctx)
	ok(int(cfg.get("p3", 0)) == 3, "condition owns_ability MET: the payload applies")
	var owns_users := 0
	for spec2 in Talents.LANE_TREES:
		for n2 in Talents.LANE_TREES[spec2]:
			if JSON.stringify(n2.get("payload", {})).contains("owns_ability"):
				owns_users += 1
	ok(owns_users == 0,
		"...and no talent payload reads it any more (%d do)" % owns_users)
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

func _migration(run: Node) -> void:
	# BATCH AN REPLACED THIS TEST'S SUBJECT. AI's migration wiped a pre-AI
	# tree and re-issued its purse; AN changed the BOARD as well, and a party
	# standing at tier 7 column 2 cannot be placed on a line with no columns.
	# So a pre-v7 save is REFUSED and cleared rather than migrated, and what
	# is left to pin is that _migrate_trees still swaps a saved tree snapshot
	# for the live definition (so balance edits reach an in-flight run).
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	run.specs_chosen = true
	run.zone_idx = 2
	run.slot_idx = 6
	# A current save keeps its picks: migration must never eat live state.
	for m in run.party:
		m["spec"] = "berserker"
		m["talents"] = {"bz_savagery": 1}
	run._migrate_trees()
	for m in run.party:
		ok(m["talents"].has("bz_savagery"), "a live save keeps its picks")
		ok(not m["tree"].is_empty(), "...on a live tree")
	# BATCH BM RE-POINTED THE SECOND HALF: a dead node used to REFUND into the
	# member's purse, and there is no in-run purse to refund into any more —
	# the meta ledger already gave the cell's price back when the tree changed
	# under it. What still has to hold, and is the real hazard, is that a
	# member never carries a node the live tree does not define.
	for m in run.party:
		m["talents"] = {"bz_savagery": 1, "no_such_node": 1}
	run._migrate_trees()
	for m in run.party:
		ok(not m["talents"].has("no_such_node"), "a dead node is dropped")
		ok(not m.has("talent_points"), "...and no purse is invented to refund it")
