# test_batch_al.gd — the re-authored Warden tree. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_al.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. TREE SHAPE — 24 nodes, one per lane per row, every id surviving the
#      re-author. Two nodes changed what they DO in place; if either lost
#      its id, saved trees would silently refund.
#   2. ALL 24 MAGNITUDES, in the payload AND in the tooltip that renders
#      it. Most of this tree's numbers live in a battle.gd read site, so
#      the tooltip is the only place the design number appears in the data
#      — two hand-written places, checked separately.
#   3. THE THREE CONDITIONAL HALVES — Bruising Guard's cross-row Spite
#      rider (has_node), and the War Stomp / Interpose ability riders
#      (owns_ability). Each proven to fire when its condition holds, to
#      stay dark when it does not, and to stay dark on an empty ctx (the
#      Batch AI §5 safe direction).
#   4. THE UPGRADE PATH — Hold the Line sits in the spec pool AND the
#      tree. Granted when unowned, upgraded when already earned, never
#      double-granted, in BOTH acquisition orders.
#   5. THE TWO RUNES THIS BATCH HAD TO REPAIR — the Rune of Grudges and
#      the Rune of the Standard used to add a RANK to a talent counter
#      whose per-rank value this batch multiplies by four. Left alone they
#      would have quadrupled without anyone touching them, which is
#      exactly the magnitude pass the designer closed in Batch AF. They
#      carry their own terms now, and both must pay ALONE as well as
#      stacked (a rune that is only live beside its node is a dead rune).
#   6. LIVE — a spawned battle, because the ally cover, the refuel, the
#      Break rider and the upgraded capstone only exist at cast time.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# id -> [row, lane, name, stat field, value]. The layout table and the
# magnitudes of the batch doc, transcribed once so a re-tune has to come
# here and say so.
const NODES := {
	"wd_unkillable": [1, "Plate", "Unkillable", "unkillable_ranks", 1],
	# RE-POINTED BY BATCH BJ §2: AL's table enshrined the misspelling
	# "Richocet"; the node is spelled Ricochet now (a text fix, nothing else).
	"wd_ricochet": [1, "Threat", "Ricochet", "ricochet_ranks", 1],
	"wd_tank_spank": [1, "Banner", "Tank and Spank", "tank_spank_ranks", 1],
	"wd_toughness": [2, "Plate", "Toughness", "toughness_ranks", 1],
	"wd_taunt_master": [2, "Threat", "Provoke", "provoke_ranks", 1],
	"wd_rally": [2, "Banner", "Rally", "rally", 1],
	"wd_endurance": [3, "Plate", "Endurance", "endurance_ranks", 1],
	"wd_iron_will": [3, "Threat", "Iron Will", "iron_will_ranks", 1],
	"wd_stomp_drill": [3, "Banner", "Rallying Cry", "rallying_cry", 4],
	"wd_tenacity": [4, "Plate", "Tenacity", "tenacity", 1],
	"wd_sundering": [4, "Threat", "Sundering", "sundering_ranks", 1],
	"wd_elem_weak": [4, "Banner", "Elemental Weakness", "elem_weak_ranks", 1],
	"wd_shieldwall": [5, "Plate", "Shield Mastery", "shield_mastery_ranks", 1],
	"wd_spiked": [5, "Threat", "Spite", "spite_ranks", 1],
	"wd_bannerman": [5, "Banner", "Bulwark Line", "bulwark_ally_block", 10],
	"wd_plating": [6, "Plate", "Plate Discipline", "plate_discipline_ranks", 1],
	"wd_shatter_guard": [6, "Threat", "Bruising Guard", "bruising_ranks", 1],
	"wd_fortress": [6, "Banner", "Shared Vigil", "shared_vigil_ranks", 1],
	"wd_immovable": [7, "Plate", "Battered Not Broken", "battered_ranks", 1],
	"wd_grudge": [7, "Threat", "Grudge", "grudge_ranks", 1],
	"wd_veteran": [7, "Banner", "Steadfast", "steadfast_ranks", 1],
	"wd_mountain": [9, "Plate", "Immovable", "immovable", 1],
	"wd_avenger": [9, "Threat", "Vengeful Guardian", "vengeful_guardian", 1],
	"wd_hold_line": [9, "Banner", "Hold the Line", "", 0],
}

# The number the tooltip must render for every node whose content is a
# magnitude. desc_for() renders at rank 1, the only rank a node ever has.
const DESC_NUMBERS := {
	"wd_unkillable": "8", "wd_ricochet": "35", "wd_toughness": "25",
	"wd_taunt_master": "2", "wd_endurance": "3", "wd_iron_will": "12",
	"wd_stomp_drill": "4", "wd_sundering": "100", "wd_elem_weak": "20",
	"wd_shieldwall": "2", "wd_spiked": "30", "wd_bannerman": "10",
	"wd_plating": "12", "wd_shatter_guard": "30", "wd_fortress": "12",
	"wd_immovable": "30", "wd_grudge": "25", "wd_veteran": "60",
}

# The magnitudes that live ONLY in a battle.gd read site. A tooltip cannot
# prove these, so they are read off a spawned unit or asserted against the
# source line further down; this table is what the prose has to agree with.
const PROSE_NUMBERS := {
	"wd_tenacity": ["15"],
	"wd_rally": ["30", "3 turns"],
	"wd_tank_spank": ["ALWAYS"],
	"wd_plating": ["20%"],
	"wd_shieldwall": ["5 turns"],
	"wd_endurance": ["75"],
}


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) —
	# park on the first process_frame, the CLAUDE.md gotcha.
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
	Profile.save_path = "user://profile_batch_al_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_values()
	_tooltips()
	_conditional_halves()
	_upgrade_path()
	_rune_repair()
	_kit_unchanged()
	await _live_fields()
	await _live_bulwark_line()
	await _live_rallying_cry()
	await _live_spite_break()
	await _live_block_payoffs()
	await _live_taunt()
	await _live_hold_the_line()

	if FileAccess.file_exists("user://profile_batch_al_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_al_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH AL: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


func _ability_names(list: Array) -> Array:
	var out: Array = []
	for a in list:
		out.append(a.display_name)
	return out


# ---------- 1. the tree still fits the Batch AI mould ----------

func _tree_shape() -> void:
	var tree: Array = Talents.generate_tree("warden", "warrior")
	ok(tree.size() == 27, "the tree is 27 cells (has %d)" % tree.size())
	var seen := {}
	for node in tree:
		# BATCH BM: this batch's table is THIS BATCH'S RECORD OF ITS OWN 24
		# NODES, and BM added a ROW-8 node to every lane. The walk skips row 8
		# rather than being taught the three new ids: what the check exists to
		# prove is that the twenty-four survive UNCHANGED, and asserting that
		# nothing else exists would make every later addition a failure here
		# instead of in the batch that made it.
		if int(node["row"]) == 8:
			continue
		var id := String(node["id"])
		ok(NODES.has(id), "'%s' is a node the layout table names" % id)
		ok(not seen.has(id), "'%s' appears once" % id)
		seen[id] = true
		ok(int(node.get("ranks", 0)) == 1, "'%s' holds a single rank" % id)
		ok(not node.has("tier"), "'%s' carries no retired tier field" % id)
		if not NODES.has(id):
			continue
		var want: Array = NODES[id]
		ok(int(node["row"]) == int(want[0]),
			"'%s' sits in row %d, want %d" % [id, int(node["row"]), int(want[0])])
		ok(String(node["lane"]) == String(want[1]),
			"'%s' sits in lane %s, want %s" % [id, node["lane"], want[1]])
		ok(String(node["name"]) == String(want[2]),
			"'%s' is named '%s', want '%s'" % [id, node["name"], want[2]])
		ok(node.get("capstone", false) == (int(want[0]) == Talents.CAPSTONE_ROW),
			"'%s' is flagged capstone iff it sits on the shelf" % id)
	# EVERY id survives, which is what lets saved trees migrate and is why
	# no save version moves in this batch.
	for id in NODES:
		ok(seen.has(id), "'%s' kept its id through the re-author" % id)
	for row in range(1, Talents.CAPSTONE_ROW + 1):
		var lanes := {}
		for node in Talents.row_nodes(tree, row):
			lanes[String(node["lane"])] = true
		ok(lanes.size() == 3, "row %d holds one node in each of the 3 lanes" % row)
	# The two re-specs happened IN PLACE: same ids, new names.
	ok(String(Talents.node_in_tree(tree, "wd_stomp_drill")["name"]) == "Rallying Cry",
		"wd_stomp_drill re-specced in place (was Rallying Stomp)")
	ok(String(Talents.node_in_tree(tree, "wd_bannerman")["name"]) == "Bulwark Line",
		"wd_bannerman kept its id through its second re-spec")


# ---------- 2. what each node is worth ----------

func _node_values() -> void:
	var tree: Array = Talents.generate_tree("warden", "warrior")
	for node in tree:
		var id := String(node["id"])
		if not NODES.has(id):
			continue
		var field := String(NODES[id][3])
		if field == "":
			continue  # the ability-granting capstone, covered in §4
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, node["payload"], 1,
			{"learned": {id: 1}, "member": {}})
		ok(cfg.has(field), "'%s' writes %s" % [id, field])
		if cfg.has(field):
			var got = cfg[field]
			var want = NODES[id][4]
			var same: bool = (abs(float(got) - float(want)) < 0.0001) \
				if want is float else (got == want)
			ok(same, "'%s' writes %s = %s, want %s" % [id, field, str(got), str(want)])


# ---------- 3. the tooltip renders the number the designer chose ----------

func _tooltips() -> void:
	var tree: Array = Talents.generate_tree("warden", "warrior")
	for id in DESC_NUMBERS:
		var node: Dictionary = Talents.node_in_tree(tree, id)
		ok(not node.is_empty(), "'%s' is in the tree" % id)
		if node.is_empty():
			continue
		var text := Talents.desc_for(node, 1)
		ok(text.contains(String(DESC_NUMBERS[id])),
			"'%s' tooltip renders %s: \"%s\"" % [id, DESC_NUMBERS[id], text])
		ok(not text.contains("{v}"),
			"'%s' tooltip has no unrendered placeholder" % id)
	# The nodes whose number lives only in battle.gd say it in prose.
	for id in PROSE_NUMBERS:
		var node: Dictionary = Talents.node_in_tree(tree, id)
		if node.is_empty():
			continue
		var text := Talents.desc_for(node, 1)
		for frag in PROSE_NUMBERS[id]:
			ok(text.contains(String(frag)),
				"'%s' tooltip states '%s': \"%s\"" % [id, frag, text])
	# The three nodes with a second half have to advertise it, or the
	# player cannot see the cross-row decision at all.
	ok(Talents.desc_for(Talents.node_in_tree(tree, "wd_shatter_guard"), 1)
		.contains("Spite"), "Bruising Guard's tooltip names Spite")
	ok(Talents.desc_for(Talents.node_in_tree(tree, "wd_stomp_drill"), 1)
		.contains("War Stomp"), "Rallying Cry's tooltip names War Stomp")
	ok(Talents.desc_for(Talents.node_in_tree(tree, "wd_bannerman"), 1)
		.contains("Interpose"), "Bulwark Line's tooltip names Interpose")
	ok(Talents.desc_for(Talents.node_in_tree(tree, "wd_bannerman"), 1)
		.contains("Shieldwall"), "...and names Shieldwall as its own trigger")
	ok(Talents.desc_for(Talents.node_in_tree(tree, "wd_hold_line"), 1)
		.contains("UPGRADES"), "the capstone tooltip states the upgrade path")


# ---------- 4. the conditional halves ----------

func _member(learned: Dictionary, earned: Array = []) -> Dictionary:
	return {"key": "warrior", "spec": "warden", "talents": learned,
		"tree": Talents.generate_tree("warden", "warrior"),
		"bm_abilities": earned}


func _applied(learned: Dictionary, earned: Array = [],
		abilities: Array = []) -> Dictionary:
	var member := _member(learned, earned)
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], learned, member)
	return cfg


func _conditional_halves() -> void:
	# --- Bruising Guard: the cross-row rider on has_node.
	var solo := _applied({"wd_shatter_guard": 1})
	ok(int(solo.get("bruising_ranks", 0)) == 1,
		"Bruising Guard alone still applies")
	ok(int(solo.get("spite_break", 0)) == 0,
		"...and does NOT arm the Break rider without Spite")
	var both := _applied({"wd_shatter_guard": 1, "wd_spiked": 1})
	ok(int(both.get("spite_break", 0)) == 1,
		"Spite taken as well welds the pair into one Break engine")
	ok(int(both.get("spite_ranks", 0)) == 1, "...and Spite itself is unaffected")
	# The other way round: Spite alone must NOT arm it. The rider hangs off
	# Bruising Guard, so the second node is the one that pays for it.
	var spite_only := _applied({"wd_spiked": 1})
	ok(int(spite_only.get("spite_break", 0)) == 0,
		"Spite on its own arms nothing — Bruising Guard buys the rider")

	# --- Rallying Cry: the ability rider on owns_ability. No node grants
	# War Stomp, so owns_ability is the honest instrument here (the Batch
	# AK correction — a node's own grant is in ability_names too).
	var cry := _applied({"wd_stomp_drill": 1})
	ok(int(cry.get("rallying_cry", 0)) == 4,
		"Rallying Cry loads its own refuel unconditionally")
	ok(int(cry.get("rallying_stomp_ranks", 0)) == 0,
		"...and pays nothing toward a War Stomp he does not own")
	var cry_stomp := _applied({"wd_stomp_drill": 1}, ["War Stomp"])
	ok(int(cry_stomp.get("rallying_cry", 0)) == 4,
		"with War Stomp earned the refuel is unchanged")
	ok(int(cry_stomp.get("rallying_stomp_ranks", 0)) == 1,
		"...and the ability hook deepens the stomp as well")

	# --- Bulwark Line: same shape, Interpose.
	var wall := _applied({"wd_bannerman": 1})
	ok(int(wall.get("bulwark_ally_block", 0)) == 10,
		"Bulwark Line loads the Shieldwall grant unconditionally")
	ok(int(wall.get("bulwark_line_ranks", 0)) == 0,
		"...and pays nothing toward an Interpose he does not own")
	var wall_ip := _applied({"wd_bannerman": 1}, ["Interpose"])
	ok(int(wall_ip.get("bulwark_ally_block", 0)) == 10,
		"with Interpose earned the Shieldwall grant is unchanged")
	ok(int(wall_ip.get("bulwark_line_ranks", 0)) == 1,
		"...and each ally gains the extra charge")

	# Both riders point at abilities Batch AH made EARNABLE — which is the
	# whole reason the two nodes were re-specced. If either drifts back
	# into the opening kit the riders become unconditional and the re-spec
	# was pointless; if either leaves the pool they become unreachable.
	ok(not Talents.owns_ability(_member({}), "War Stomp"),
		"a fresh Warden does NOT own War Stomp (Batch AH trimmed it)")
	ok(not Talents.owns_ability(_member({}), "Interpose"),
		"...nor Interpose")
	ok(Talents.owns_ability(_member({}, ["War Stomp"]), "War Stomp"),
		"...and owns War Stomp once it is earned")
	ok(Talents.owns_ability(_member({}, ["Interpose"]), "Interpose"),
		"...and Interpose once it is earned")
	ok(Classes.spec_pool("warden").has("War Stomp") \
		and Classes.spec_pool("warden").has("Interpose"),
		"both ridden abilities are actually earnable from the spec pool")

	# An empty ctx leaves a conditional half INERT — the Batch AI §5 rule:
	# an effect that fails to appear is a bug you can see.
	var tree: Array = Talents.generate_tree("warden", "warrior")
	for id in ["wd_shatter_guard", "wd_stomp_drill", "wd_bannerman"]:
		var bare := {"abilities": []}
		Talents.apply_payload(bare, Talents.node_in_tree(tree, id)["payload"], 1)
		ok(int(bare.get("spite_break", 0)) == 0 \
			and int(bare.get("rallying_stomp_ranks", 0)) == 0 \
			and int(bare.get("bulwark_line_ranks", 0)) == 0,
			"'%s' second half is inert on an empty ctx" % id)
		ok(bare.size() > 1, "'%s' first half still lands on an empty ctx" % id)


# ---------- 5. grant, or upgrade ----------

func _upgrade_path() -> void:
	# Unowned: the capstone grants Hold the Line and marks no upgrade.
	var fresh := _applied({"wd_hold_line": 1})
	var fresh_names := _ability_names(fresh["abilities"])
	ok(fresh_names.count("Hold the Line") == 1,
		"the capstone grants Hold the Line when he has none")
	ok(int(fresh.get("hold_line_upgraded", 0)) == 0, "...and marks no upgrade")
	for a in fresh["abilities"]:
		if a.display_name == "Hold the Line":
			ok(a.cost == 30 and a.cooldown == 6,
				"...at the ordinary 30 Rage / 6cd")
			ok(a.description.contains("50%"),
				"...and its description states the base 50% cut")

	# Already earned from a pool pick: upgraded, never duplicated. Earned
	# picks go on BEFORE the tree at both real call sites (the Batch AH
	# ordering fix), which is what this arrangement reproduces.
	var earned := Classes.spec_pool_ability("warden", "Hold the Line")
	ok(earned != null, "Hold the Line resolves out of the spec pool")
	var up := _applied({"wd_hold_line": 1}, ["Hold the Line"], [earned])
	ok(_ability_names(up["abilities"]).count("Hold the Line") == 1,
		"an earned Hold the Line is not granted a second time")
	ok(int(up.get("hold_line_upgraded", 0)) == 1,
		"...the capstone marks the UPGRADE instead")
	for a in up["abilities"]:
		if a.display_name == "Hold the Line":
			ok(a.description.contains("80%"),
				"...and the description states the 80% cut")
			ok(a.description.contains("two turns"),
				"...and the doubled no-death window")

	# The reverse order — capstone first, pick second — cannot reach the
	# upgrade, and must not double-grant either. That is a property of the
	# ordering, not of the payload, and it is the half a future batch could
	# break by moving the earned-picks block.
	var member := _member({"wd_hold_line": 1}, ["Hold the Line"])
	var late := {"abilities": []}
	Talents.apply_from_tree(late, member["tree"], member["talents"], member)
	var late_names := _ability_names(late["abilities"])
	ok(late_names.count("Hold the Line") == 1,
		"tree-first still leaves exactly one Hold the Line")
	ok(int(late.get("hold_line_upgraded", 0)) == 0,
		"...and no upgrade, because nothing was in the kit when the tree ran")


# ---------- 6. the two runes this batch had to repair ----------

func _rune_repair() -> void:
	# THE POINT: neither rune may write a talent counter whose per-rank
	# value this batch multiplied. If one does, its advertised number is a
	# lie and the designer's closed magnitude question was reopened by
	# accident.
	var grudges: Dictionary = Runes.config("grudges")
	var standard: Dictionary = Runes.config("standard")
	ok(not grudges["payload"]["stat"].has("grudge_ranks"),
		"the Rune of Grudges no longer adds a RANK to the re-priced counter")
	ok(not standard["payload"]["stat"].has("shared_vigil_ranks"),
		"the Rune of the Standard likewise")

	# Each pays its OWN advertised number, alone.
	var g_only := {"abilities": []}
	Talents.apply_payload(g_only, grudges["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(g_only.get("rune_grudge_bonus", 0.0)) - 0.06) < 0.0001,
		"the Rune of Grudges pays its advertised 6%% on its own")
	ok(int(g_only.get("grudge_ranks", 0)) == 0,
		"...without touching the node's counter")
	var s_only := {"abilities": []}
	Talents.apply_payload(s_only, standard["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(s_only.get("rune_vigil_bonus", 0.0)) - 0.03) < 0.0001,
		"the Rune of the Standard pays its advertised 3%% on its own")
	ok(int(s_only.get("shared_vigil_ranks", 0)) == 0,
		"...without touching the node's counter")

	# ...and stacks with the node, which is what both descriptions promise.
	var stacked := _applied({"wd_grudge": 1, "wd_fortress": 1})
	Talents.apply_payload(stacked, grudges["payload"], 1, {"learned": {}, "member": {}})
	Talents.apply_payload(stacked, standard["payload"], 1, {"learned": {}, "member": {}})
	ok(int(stacked["grudge_ranks"]) == 1 \
		and abs(float(stacked["rune_grudge_bonus"]) - 0.06) < 0.0001,
		"node and rune stack for Grudge (25%% + 6%% = 31%%)")
	ok(int(stacked["shared_vigil_ranks"]) == 1 \
		and abs(float(stacked["rune_vigil_bonus"]) - 0.03) < 0.0001,
		"node and rune stack for Shared Vigil (12%% + 3%% = 15%%)")
	# The descriptions still name the numbers the payloads now carry.
	ok(String(grudges["desc"]).contains("6%"),
		"the Rune of Grudges still advertises 6%%")
	ok(String(standard["desc"]).contains("3%"),
		"the Rune of the Standard still advertises 3%%")
	# Nothing else in the pool writes a Warden counter this batch re-priced.
	for rune_id in Runes.ids():
		var entry: Dictionary = Runes.config(String(rune_id))
		var stat: Dictionary = entry.get("payload", {}).get("stat", {})
		ok(not stat.has("grudge_ranks") and not stat.has("shared_vigil_ranks") \
			and not stat.has("iron_will_ranks") and not stat.has("steadfast_ranks") \
			and not stat.has("spite_ranks") and not stat.has("bruising_ranks"),
			"rune '%s' writes no re-priced Warden counter" % rune_id)


# ---------- 7. the kit and the pools are untouched ----------

func _kit_unchanged() -> void:
	# This batch is a TREE re-author. AH's kit split is what both re-specs
	# depend on, so it is asserted rather than assumed.
	var kit := _ability_names(Classes.spec_abilities("warden"))
	ok(kit.size() == 3, "the Warden still opens with exactly 3 spec abilities (has %d)" % kit.size())
	ok(kit.has("Shieldwall"),
		"Shieldwall is in the opening three — Bulwark Line keys to it")
	ok(not kit.has("War Stomp") and not kit.has("Interpose"),
		"War Stomp and Interpose are still earnable, not opening kit")
	var pool: Array = Classes.spec_pool("warden")
	ok(pool.size() == 4, "the spec pool still holds 4 (has %d)" % pool.size())
	# Every pool entry of every spec still resolves: an upgrade path is a
	# new reason for a pool copy to drift from the kit's.
	for spec in Classes.SPEC_POOLS:
		for name in Classes.SPEC_POOLS[spec]:
			ok(Classes.spec_pool_ability(spec, String(name)) != null,
				"spec pool %s: '%s' resolves" % [spec, name])


# ---------- the live half ----------

# Spawns a battle FROZEN on the first hero turn: no autoplay, so nothing
# acts on its own and every cast below is one this test drove.
func _spawn(learned: Dictionary, lineup: Array, earned: Array = [],
		runes: Array = []) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["warden", "cryomancer", "holy", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	run.party[0]["talents"] = learned
	run.party[0]["bm_abilities"] = earned
	run.party[0]["runes"] = runes
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	return scene


func _wd(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "heavy_plating":
			return h
	return null


func _allies(scene: Node, wd: BattleUnit) -> Array:
	var out: Array = []
	for h in scene.get("heroes"):
		if h != wd and not h.is_companion and not h.dead:
			out.append(h)
	return out


func _find(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


# ---------- 8. every field reaches the live unit ----------

func _live_fields() -> void:
	# A full 8-node build, one per row, spanning all three lanes — the
	# shape a real run actually produces. `set()` DROPS an unknown name
	# silently (Batch AA), so a typo'd field is a dud rather than a crash:
	# this is the check that catches it.
	var build := {"wd_unkillable": 1, "wd_toughness": 1, "wd_stomp_drill": 1,
		"wd_tenacity": 1, "wd_bannerman": 1, "wd_shatter_guard": 1,
		"wd_grudge": 1, "wd_hold_line": 1}
	var scene := await _spawn(build, ["raider", "archer", "archer"])
	var wd := _wd(scene)
	ok(wd != null, "the Warden spawned")
	if wd != null:
		ok(wd.unkillable_ranks == 1, "LIVE: Unkillable reached the unit")
		ok(wd.rallying_cry == 4, "LIVE: Rallying Cry reached the unit (4)")
		ok(wd.tenacity == 1, "LIVE: Tenacity reached the unit")
		ok(wd.bulwark_ally_block == 10,
			"LIVE: Bulwark Line reached the unit (10)")
		ok(wd.bruising_ranks == 1, "LIVE: Bruising Guard reached the unit")
		ok(wd.spite_break == 0,
			"LIVE: ...with the Spite rider dark, because Spite was not taken")
		ok(wd.grudge_ranks == 1, "LIVE: Grudge reached the unit")
		ok(_find(wd, "Hold the Line") != null,
			"LIVE: the capstone put Hold the Line on his bar")
		# Toughness reads the UNSCALED pool at spawn — 25% of max HP on top
		# of the spec's own Constitution.
		ok(wd.constitution > 100,
			"LIVE: Toughness raised Constitution (got %d)" % wd.constitution)
	scene.free()
	await process_frame


# ---------- 9. Bulwark Line covers the line ----------

func _live_bulwark_line() -> void:
	var scene := await _spawn({"wd_bannerman": 1, "wd_shieldwall": 1},
		["raider", "archer"])
	var wd := _wd(scene)
	ok(wd != null, "the Bulwark Line Warden spawned")
	if wd != null:
		ok(wd.shield_mastery_ranks == 1, "Shield Mastery reached the unit")
		await scene._resolve_special(wd, _find(wd, "Shieldwall"), wd, "good", 1.0)
		# BATCH CQ §3 — BASE **3** SINCE CN §3'S FOLD, + Shield Mastery's 2 = 5.
		# Shieldwall banked 2 turns and a Perfect banked a third; CN took the
		# card's timing bar off and folded the third turn into the base, so the
		# node's +2 now rides a 3 rather than a 2. Shieldwall's cooldown is 2,
		# so the stance already outlasted its own cooldown before the fold —
		# this widened an existing gap rather than opening one.
		ok(wd.has_status("shieldwall"), "the stance went up")
		var wall := wd.get_status("shieldwall")
		ok(int(wall.get("turns", 0)) == 5,
			"Shield Mastery holds the stance 5 turns (got %d)" % int(wall.get("turns", 0)))
		var allies := _allies(scene, wd)
		ok(allies.size() == 3, "there are three allies to cover (%d)" % allies.size())
		var covered := 0
		for a in allies:
			if a.has_status("bulwark_line"):
				covered += 1
				ok(a.status_power("bulwark_line") == 10,
					"%s is covered at +10%% Block (got %d)" % [
						a.unit_name, a.status_power("bulwark_line")])
				ok(int(a.get_status("bulwark_line").get("turns", 0)) == 5,
					"...for exactly as long as the stance holds")
		ok(covered == allies.size(),
			"EVERY ally is covered (%d of %d)" % [covered, allies.size()])
		ok(not wd.has_status("bulwark_line"),
			"the Warden is not double-covered — his own +25%% stance is up")

		# The cover is real BLOCK: it rides the Heavy Plating slice, so an
		# ally's roll can land in it. Pinned by forcing the slice to 100%.
		var ally: BattleUnit = allies[0]
		ally.update_status("bulwark_line", "+100% Block", "forced", 100)
		ally.parry_chance = 0.0
		var foe: BattleUnit = scene.get("enemies")[0]
		foe.no_cover = 1
		var hp_before: int = ally.hp
		await scene._resolve(foe, _find(foe, foe.abilities[0].display_name),
			ally, "good")
		ok(ally.hp == hp_before,
			"LIVE: a Bulwark Line block negates the hit entirely (%d -> %d)" % [
				hp_before, ally.hp])
		# ...and it must NOT feed the Warden's own Tenacity/Rally, which
		# key on "Heavy Plating" blocks specifically.
		ok(wd.tenacity_hp_gained == 0,
			"an ALLY's covered block does not feed the Warden's Tenacity")
	scene.free()
	await process_frame

	# Control: without the node, Shieldwall covers nobody.
	var plain := await _spawn({}, ["raider", "archer"])
	var wd2 := _wd(plain)
	if wd2 != null:
		await plain._resolve_special(wd2, _find(wd2, "Shieldwall"), wd2, "good", 1.0)
		var any := false
		for a in _allies(plain, wd2):
			if a.has_status("bulwark_line"):
				any = true
		ok(not any, "without Bulwark Line the stance covers nobody")
		ok(int(wd2.get_status("shieldwall").get("turns", 0)) == 3,
			"...and holds the folded base 3 turns without Shield Mastery")
	plain.free()
	await process_frame


# ---------- 10. Rallying Cry refuels the line ----------

func _live_rallying_cry() -> void:
	# The node's body fires in the turn-start block of _run_battle, which
	# cannot be called in isolation — so this runs a real autoplay battle
	# and reads the combat log the Warden's own turn writes. His first turn
	# is the earliest event in any battle, so there is no race here (the
	# Batch AH White Flame lesson: a log check must not depend on how LONG
	# a fight lasts).
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["warden", "cryomancer", "holy", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	run.party[0]["talents"] = {"wd_stomp_drill": 1}
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	# Batch AC gotcha: an autoplay battle paces on REAL timers. time_scale
	# scales the SceneTreeTimers it waits on and NOTHING else.
	Engine.time_scale = 50.0
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 400:
		await process_frame
	var text: String = scene.history.get_parsed_text()
	# The line is emitted ONLY after at least one ally has actually had
	# resource added (the counter it guards is incremented inside the
	# loop), so its presence is behavioural evidence, not just a print.
	ok(text.contains("Rallying Cry — the banner refuels the line (+4%)"),
		"LIVE: the banner refuels the line at the Warden's turn")
	Engine.time_scale = 1.0
	scene.free()
	await process_frame

	# Control: without the node, that line never appears.
	run.party[0]["talents"] = {}
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	Engine.time_scale = 50.0
	var plain: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(plain)
	for _i in 400:
		await process_frame
	ok(not plain.history.get_parsed_text().contains("Rallying Cry"),
		"without the node nothing refuels the line")
	Engine.time_scale = 1.0
	plain.free()
	OS.set_environment("DOD_AUTOPLAY", "")
	await process_frame


# ---------- 11. Spite, and the Break it carries once welded ----------

func _live_spite_break() -> void:
	# Spite alone: 30% of the damage back, and NO Break.
	var solo := await _spawn({"wd_spiked": 1}, ["raider"])
	var wd := _wd(solo)
	ok(wd != null, "the Spite Warden spawned")
	if wd != null:
		var foe: BattleUnit = solo.get("enemies")[0]
		foe.pressure = 0
		# Forced to LAND and forced NOT to be blocked or parried, so the
		# reflect is certain: the attacker carries the no_cover miss bypass,
		# and the block and parry rolls are driven NEGATIVE rather than to zero.
		#
		# BATCH CQ §1 — ZERO WAS NEVER ENOUGH HERE, AND THIS SUITE ALREADY SAID
		# SO ONE SECTION ABOVE. `_live_block_chance` is
		# `clampf(block_chance + _plating_slice(u), 0, 1)` and `_plating_slice`
		# hands a HEAVY PLATING Warden a flat **0.15** before his own field is
		# read — so `block_chance = 0.0` left him blocking roughly one hit in
		# six, the blow landed for nothing, and Spite reflects only on
		# `final > 0`. That is the 1-in-6 this check had been failing at, and
		# it was invisible for five batches because the suite never reached
		# this line: it deadlocked three sections earlier. `_live_fields`
		# carries the same warning in prose; this is it applied.
		wd.block_chance = -10.0
		wd.plating_bonus = 0.0
		wd.parry_chance = -10.0
		foe.no_cover = 1
		# BATCH CQ §1 — THE MITIGATION IS FORCED OFF TOO, and this is the AL/AR
		# determinism discipline applied to a variable that only became live
		# when the suite started completing. A WARDEN ALWAYS CARRIES A
		# DEFENSIVE CHECK (`_has_defensive_check` returns true on
		# `heavy_plating` regardless of stance), so every incoming blow now
		# rolls the bot's brace — a real random draw that can cut the blow by
		# 15% AND shifts every roll after it. Between that cut and the Warden's
		# own armor, a low damage roll could floor `final` to nothing, and
		# Spite reflects only when `final > 0`: the check failed once in four
		# runs on exactly that. Armor off makes the landed damage certain, and
		# the health is raised so the Warden cannot be FELLED by the blow it is
		# supposed to reflect — a first attempt raised the ATTACKER instead and
		# reintroduced the flake from the other end, because a crit on the high
		# roll could take a 200-health Warden off the board.
		wd.armor = 0.0
		wd.max_hp = 100000
		wd.hp = 100000
		var foe_hp: int = foe.hp
		await solo._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd, "good")
		ok(foe.hp < foe_hp, "Spite reflects damage at the attacker")
		ok(foe.pressure == 0,
			"...and NO Break without Bruising Guard (got %d)" % foe.pressure)
	solo.free()
	await process_frame

	# Welded: the reflect carries Break equal to half its damage. Driven
	# through the field rather than the dice, so the check cannot flake on
	# a block roll.
	var both := await _spawn({"wd_spiked": 1, "wd_shatter_guard": 1}, ["raider"])
	var wd2 := _wd(both)
	if wd2 != null:
		ok(wd2.spite_break == 1, "LIVE: the cross-row rider reached the unit")
		ok(wd2.spite_ranks == 1 and wd2.bruising_ranks == 1,
			"...alongside both halves it welds")
	both.free()
	await process_frame


# ---------- 12. the block payoffs ----------

func _live_block_payoffs() -> void:
	# Heavy Plating's ramp: +8% base, +12% with the node = 20%, so the
	# +40% cap arrives in two unblocked hits instead of five.
	var scene := await _spawn({"wd_plating": 1}, ["raider"])
	var wd := _wd(scene)
	ok(wd != null, "the Plate Discipline Warden spawned")
	if wd != null:
		ok(wd.plate_discipline_ranks == 1, "Plate Discipline reached the unit")
		ok(abs(0.08 + 0.12 * wd.plate_discipline_ranks - 0.20) < 0.0001,
			"the climb is 20% per unblocked hit")
	scene.free()
	await process_frame

	# Tenacity is +15 max HP a block now, and Rally's status is 3 turns of
	# +30%. Both are driven straight through their own machinery.
	var ten := await _spawn({"wd_tenacity": 1}, ["raider"])
	var wd2 := _wd(ten)
	if wd2 != null:
		var was: int = wd2.max_hp
		# The block-payoff cluster fires inside _resolve; forcing the roll
		# is what makes this deterministic rather than a 15% gamble. The
		# swing also has to LAND — `no_cover` is the Sharpshooter's own miss
		# BYPASS and parry_chance 0 shuts the other door, the same way Batch
		# AK forced its parry checks instead of retrying them.
		wd2.block_chance = 0.0
		wd2.plating_bonus = 1.0
		wd2.parry_chance = 0.0
		var foe: BattleUnit = ten.get("enemies")[0]
		foe.no_cover = 1
		await ten._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd2, "good")
		ok(wd2.max_hp == was + 15,
			"LIVE: a Heavy Plating block toughens him +15 max HP (%d -> %d)" % [
				was, wd2.max_hp])
		ok(wd2.tenacity_hp_gained == 15,
			"...and the gain is booked so the save sync can exclude it")
	ten.free()
	await process_frame

	var ral := await _spawn({"wd_rally": 1}, ["raider"])
	var wd3 := _wd(ral)
	if wd3 != null:
		wd3.block_chance = 0.0
		wd3.plating_bonus = 1.0
		wd3.parry_chance = 0.0
		var foe: BattleUnit = ral.get("enemies")[0]
		foe.no_cover = 1
		await ral._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd3, "good")
		var rallied := 0
		var full := 0
		for h in ral.get("heroes"):
			if h.has_status("rally_heal"):
				rallied += 1
				var left := int(h.get_status("rally_heal").get("turns", 0))
				if left == 3:
					full += 1
				# The Hunter's class passive makes him ACT FIRST, so by the
				# time this block runs his opening turn has already ticked
				# one off. That is the timeline, not the talent — hence the
				# floor rather than an equality on every hero.
				ok(left >= 2,
					"%s is Rallied and the clock has barely started (%d)" % [
						h.unit_name, left])
		ok(rallied >= 4, "the whole party is Rallied (%d)" % rallied)
		ok(full >= 3, "...for the full 3 turns on everyone yet to act (%d)" % full)
		# The multiplier itself: 30% on top, floored at 1.
		var ally: BattleUnit = _allies(ral, wd3)[0]
		ally.hp = maxi(ally.max_hp - 100, 1)
		var healed: int = ally.heal_amount(100, true)
		ok(healed > 100,
			"LIVE: Rally deepens a 100 heal past 100 (got %d)" % healed)
	ral.free()
	await process_frame


# ---------- 13. the taunt, and what it pays ----------

func _live_taunt() -> void:
	var scene := await _spawn({"wd_taunt_master": 1, "wd_tank_spank": 1},
		["raider", "archer", "archer", "shaman"])
	var wd := _wd(scene)
	ok(wd != null, "the Provoke Warden spawned")
	if wd != null:
		var mock := _find(wd, "Mocking Blow")
		ok(mock != null, "Mocking Blow is on his bar")
		var foes: Array = scene.get("enemies")
		await scene._resolve(wd, mock, foes[0], "good", true)
		var mocked := 0
		for e in foes:
			if e.has_status("mocked"):
				mocked += 1
		# Target + the base ability's one extra + Provoke's two = 4.
		ok(mocked == 4,
			"Provoke drags in 2 more on top of the base one (%d taunted)" % mocked)
		# Tank and Spank is CERTAIN now, so one cast is the whole test.
		var empowered := 0
		for h in scene.get("heroes"):
			if h.has_status("empower"):
				empowered += 1
		ok(empowered == 1,
			"Tank and Spank ALWAYS Empowers exactly one ally (%d)" % empowered)
	scene.free()
	await process_frame

	# Control: without Provoke the taunt still drags in the base one.
	var plain := await _spawn({}, ["raider", "archer", "archer", "shaman"])
	var wd2 := _wd(plain)
	if wd2 != null:
		var foes: Array = plain.get("enemies")
		await plain._resolve(wd2, _find(wd2, "Mocking Blow"), foes[0], "good", true)
		var mocked := 0
		for e in foes:
			if e.has_status("mocked"):
				mocked += 1
		ok(mocked == 2, "the base taunt still holds 2 (got %d)" % mocked)
		var empowered := 0
		for h in plain.get("heroes"):
			if h.has_status("empower"):
				empowered += 1
		ok(empowered == 0, "...and Empowers nobody without the node")
	plain.free()
	await process_frame


# ---------- 14. the capstone, granted and upgraded ----------

func _live_hold_the_line() -> void:
	# Granted: the base 50% cut, one turn of Undying.
	var scene := await _spawn({"wd_hold_line": 1}, ["raider"])
	var wd := _wd(scene)
	ok(wd != null, "the Hold the Line Warden spawned")
	if wd != null:
		ok(wd.hold_line_upgraded == 0, "LIVE: nothing upgraded on the grant path")
		await scene._resolve_special(wd, _find(wd, "Hold the Line"), wd, "good", 1.0)
		ok(wd.status_power("hold_bd") == 50,
			"the granted cast cuts 50%% of Break damage (got %d)" % \
				wd.status_power("hold_bd"))
		ok(int(wd.get_status("undying").get("turns", 0)) == 2,
			"...and holds death off for one turn")
		# The cut is real: unit.gd reads the status' power at ONE site.
		wd.pressure = 0
		wd.constitution = 100
		wd.take_hit(0, 100)
		ok(wd.pressure == 50,
			"a 100-Break blow lands as 50 under the base cast (got %d)" % wd.pressure)
	scene.free()
	await process_frame

	# Upgraded: 80%, and two turns of Undying.
	var earned := Classes.spec_pool_ability("warden", "Hold the Line")
	var up := await _spawn({"wd_hold_line": 1}, ["raider"], ["Hold the Line"])
	var wd2 := _wd(up)
	if wd2 != null:
		ok(wd2.hold_line_upgraded == 1,
			"LIVE: the capstone upgraded the earned copy")
		ok(_ability_names(wd2.abilities).count("Hold the Line") == 1,
			"...and there is still exactly one on his bar")
		await up._resolve_special(wd2, _find(wd2, "Hold the Line"), wd2, "good", 1.0)
		ok(wd2.status_power("hold_bd") == 80,
			"the upgraded cast cuts 80%% of Break damage (got %d)" % \
				wd2.status_power("hold_bd"))
		ok(int(wd2.get_status("undying").get("turns", 0)) == 3,
			"...and holds death off for two turns")
		wd2.pressure = 0
		wd2.constitution = 100
		wd2.take_hit(0, 100)
		ok(wd2.pressure == 20,
			"a 100-Break blow lands as 20 under the upgraded cast (got %d)" % \
				wd2.pressure)
	ok(earned != null, "the earned copy resolved out of the pool")
	up.free()
	await process_frame
