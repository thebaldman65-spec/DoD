# test_batch_bm.gd — TALENTS BECOME META PROGRESSION. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bm.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite spawns no battle scene, so it needs neither --fixed-fps
# 12 (BL's trick) nor a parked process_frame.
#
# WHAT IT DRIVES, and the ONE distinction it exists to protect: BUYING A CELL
# UNLOCKS AN OPTION, IT DOES NOT EQUIP IT. Six of the checks below would fail
# SILENTLY without being written down — a purchased cell that auto-equips
# still produces a working hero, points that transfer between specs still
# spend, a row unlock that lands on one spec still unlocks something, an elite
# still awards SOMETHING, and a row-8 node that is a row-4 node with a bigger
# number is still a node. Each is built as broken state and the checker is
# proven to reject it.
#
# THE PROFILE IS REDIRECTED TO A SCRATCH FILE (`Profile.save_path` is a var
# for exactly this) and the real one is never opened. `Run` is an AUTOLOAD and
# does NOT resolve in a --script SceneTree, so every check here reads Talents,
# Profile and Classes — the three statics — and the Run-side rules (the end
# boss slot, the difficulty ladder, the deleted award sites) are asserted
# against the SOURCE, which is where a rule with no reachable gate can be
# checked at all.
extends SceneTree

const SCRATCH := "user://test_bm_profile.json"

var checks := 0
var fails: Array = []
var sections := 0


func _check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		fails.append(label)


func _fresh() -> void:
	Profile.save_path = SCRATCH
	Profile.data = {}
	Profile.loaded = false
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))
	Profile.respec("berserker")  # forces a load + save against the scratch file


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


func _initialize() -> void:
	_fresh()
	_structure()
	_earning()
	_spending()
	_gating()
	_persistence()
	_end_boss_and_ladder()
	_award_sites_deleted()
	_negative_controls()
	print("\n=== BATCH BM ===")
	print("sections: %d   checks: %d   failures: %d" % [sections, checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))
	quit()


# ---------- §9 STRUCTURE ----------

func _structure() -> void:
	_check(Talents.ROWS == 8, "ROWS is 8")
	_check(Talents.CAPSTONE_ROW == 9, "the capstone shelf is row 9")
	_check(Talents.LANES == 3, "three lanes")
	_check(Talents.CELLS_PER_SPEC == 27, "27 cells per spec")
	_check(Talents.full_spec_cost() == 54, "54 points fills a spec")
	var all_ids := {}
	for spec in Classes.all_specs():
		var tree: Array = Talents.generate_tree(String(spec), "")
		_check(tree.size() == 27, "%s has 27 nodes" % spec)
		# every row x lane cell present exactly once
		var seen := {}
		var lanes := {}
		for t in tree:
			var key := "%d/%s" % [int(t["row"]), String(t["lane"])]
			_check(not seen.has(key), "%s: one node at %s" % [spec, key])
			seen[key] = true
			lanes[String(t["lane"])] = true
			_check(not all_ids.has(String(t["id"])),
				"id %s is unique across all twelve trees" % t["id"])
			all_ids[String(t["id"])] = spec
			_check(int(t.get("ranks", 0)) == 1, "%s: %s holds one rank" % [spec, t["id"]])
		_check(lanes.size() == 3, "%s has exactly three lanes" % spec)
		_check(seen.size() == 27, "%s fills every row x lane cell" % spec)
		# row 9 is the capstone shelf and nothing else is
		for t in tree:
			var cap := bool(t.get("capstone", false))
			_check(cap == (int(t["row"]) == Talents.CAPSTONE_ROW),
				"%s: %s is a capstone iff it is row 9" % [spec, t["id"]])
		# NO ROW-8 NODE DUPLICATES AN EFFECT ABOVE IT IN ITS OWN LANE. The
		# instrument is the PAYLOAD's stat fields: a node that writes a field
		# an earlier node in the same lane already writes is, by construction,
		# that node with a different number.
		for t in tree:
			if int(t["row"]) != 8:
				continue
			var mine := (t.get("payload", {}).get("stat", {}) as Dictionary).keys()
			for other in tree:
				if String(other.get("lane", "")) != String(t["lane"]):
					continue
				if int(other["row"]) >= 8:
					continue
				for f in (other.get("payload", {}).get("stat", {}) as Dictionary):
					_check(not mine.has(f),
						"%s row 8 (%s) does not re-write %s's %s" % [
							spec, t["id"], other["id"], f])
		# valid exclusive/condition references throughout
		var ids := {}
		for t in tree:
			ids[String(t["id"])] = true
		for t in tree:
			var pay: Dictionary = t.get("payload", {})
			for extra in pay.get("also", []):
				var cond: Dictionary = extra.get("condition", {})
				if cond.has("has_node"):
					_check(ids.has(String(cond["has_node"])),
						"%s: %s references a live node" % [spec, t["id"]])
	_check(all_ids.size() == 27 * 12, "324 distinct node ids across the roster")
	# tier costs and their gate come from ONE place and agree
	for row in range(1, 10):
		var tier := Talents.tier_of_row(row)
		_check(tier == int(ceil(row / 3.0)), "row %d sits at tier %d" % [row, tier])
		_check(Talents.cell_cost(row) == tier, "row %d costs %d" % [row, tier])
	_check(Talents.rows_unlocked(0) == 0, "a fresh profile unlocks no rows")
	_check(Talents.rows_unlocked(1) == 3, "difficulty 1 opens rows 1-3")
	_check(Talents.rows_unlocked(2) == 6, "difficulty 2 opens rows 4-6")
	_check(Talents.rows_unlocked(3) == 9, "difficulty 3 opens rows 7-9")
	sections += 1


# ---------- §9 EARNING ----------

func _earning() -> void:
	_fresh()
	var party := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	Profile.award_zone_boss_points(party)
	for spec in party:
		_check(Profile.talent_points_earned(spec) == 1,
			"%s banks 1 point for a zone boss" % spec)
	# A SPEC ABSENT FROM THE PARTY BANKS NOTHING.
	_check(Profile.talent_points_earned("holy") == 0,
		"a spec that did not play banks 0")
	# A ZONE-2 WIPE HAS ALREADY BANKED 2 — partial credit is the mechanism.
	Profile.award_zone_boss_points(party)
	_check(Profile.talent_points_earned("berserker") == 2,
		"two zone bosses bank 2 (a zone-2 wipe keeps them)")
	# A completed run is three: 3 points per spec per run, so 18 completions
	# fills one spec at 54.
	Profile.award_zone_boss_points(party)
	_check(Profile.talent_points_earned("berserker") == 3,
		"a completed run banks 3 per spec")
	_check(Talents.full_spec_cost() / 3 == 18,
		"18 completions per spec fills one tree")
	# An empty spec string banks nothing (an un-awakened hero).
	Profile.award_zone_boss_points(["", ""])
	_check(Profile.talent_points_earned("") == 0, "an un-awakened hero banks nothing")
	# THE END BOSS BANKS NONE — asserted against the source, because it is a
	# rule about what _resolve_boss does NOT call.
	var bs := _src("res://scripts/battle.gd")
	var idx := bs.find("func _resolve_boss")
	var body := bs.substr(idx, 2400)
	var end_half := body.substr(body.find("# The end boss."))
	_check(not end_half.contains("bank_zone_boss_points"),
		"the end boss banks no talent points")
	_check(end_half.contains("Relics.unlock_random") or body.contains("Relics.unlock_random"),
		"the end boss awards a relic")
	sections += 1


# ---------- §9 SPENDING ----------

func _spending() -> void:
	_fresh()
	var spec := "berserker"
	var tree: Array = Talents.generate_tree(spec, "")
	var row1 := Talents.row_nodes(tree, 1)
	var row4 := Talents.row_nodes(tree, 4)
	var row7 := Talents.row_nodes(tree, 7)
	# A LOCKED ROW REJECTS A PURCHASE even with points in hand.
	for i in 20:
		Profile.award_zone_boss_points([spec])
	_check(Profile.talent_points_earned(spec) == 20, "20 banked")
	_check(not Profile.buy_cell(spec, String(row1[0]["id"])),
		"tier 0: even row 1 refuses")
	Profile.note_end_boss(1)
	_check(Profile.buy_cell(spec, String(row1[0]["id"])), "row 1 buys at tier 1")
	_check(Profile.talent_points_available(spec) == 19, "a tier-1 cell costs 1")
	_check(not Profile.buy_cell(spec, String(row4[0]["id"])),
		"row 4 refuses at tier 1")
	Profile.note_end_boss(2)
	_check(Profile.buy_cell(spec, String(row4[0]["id"])), "row 4 buys at tier 2")
	_check(Profile.talent_points_available(spec) == 17, "a tier-2 cell costs 2")
	_check(not Profile.buy_cell(spec, String(row7[0]["id"])), "row 7 refuses at tier 2")
	Profile.note_end_boss(3)
	_check(Profile.buy_cell(spec, String(row7[0]["id"])), "row 7 buys at tier 3")
	_check(Profile.talent_points_available(spec) == 14, "a tier-3 cell costs 3")
	# A TIER ARRIVES FULLY UNLOCKED — all nine cells of rows 4-6 at once.
	var ok_all := true
	for row in [4, 5, 6]:
		for t in Talents.row_nodes(tree, row):
			if not Talents.row_unlocked(int(t["row"]), 2):
				ok_all = false
	_check(ok_all, "difficulty 2 opens all nine cells of rows 4-6 at once")
	# BUYING A CELL DOES NOT EQUIP IT — the load-bearing one.
	_check(Profile.owns_cell(spec, String(row1[0]["id"])), "the cell is owned")
	_check(Profile.equipped_talents(spec).is_empty(),
		"BUYING DOES NOT EQUIP — nothing is worn yet")
	_check(Profile.equip_cell(spec, String(row1[0]["id"])), "an owned cell equips")
	_check(Profile.equipped_talents(spec).has(String(row1[0]["id"])),
		"the equipped cell is what a run wears")
	_check(Profile.talent_points_available(spec) == 14,
		"equipping costs nothing")
	# EXACTLY ONE NODE EQUIPPABLE PER ROW: equipping a sibling replaces.
	Profile.buy_cell(spec, String(row1[1]["id"]))
	Profile.equip_cell(spec, String(row1[1]["id"]))
	var worn := Profile.equipped_talents(spec)
	_check(worn.has(String(row1[1]["id"])) and not worn.has(String(row1[0]["id"])),
		"a row holds exactly one equipped node")
	# AN UNOWNED CELL CANNOT BE EQUIPPED.
	_check(not Profile.equip_cell(spec, String(row1[2]["id"])),
		"an unowned cell cannot be equipped")
	# A FULL RESPEC RETURNS EVERY POINT AND RE-SPENDS IT.
	var before := Profile.talent_points_earned(spec)
	Profile.respec(spec)
	_check(Profile.talent_points_available(spec) == before,
		"a respec returns every point")
	_check(Profile.equipped_talents(spec).is_empty(), "a respec clears the loadout")
	_check(Profile.talent_cells(spec).is_empty(), "a respec clears every cell")
	_check(Profile.buy_cell(spec, String(row1[2]["id"])),
		"the points re-spend on a different cell")
	# A SINGLE refund gives back exactly the cell's price and un-equips it.
	Profile.equip_cell(spec, String(row1[2]["id"]))
	var avail := Profile.talent_points_available(spec)
	_check(Profile.refund_cell(spec, String(row1[2]["id"])), "a cell refunds")
	_check(Profile.talent_points_available(spec) == avail + 1,
		"the refund is the cell's price")
	_check(Profile.equipped_talents(spec).is_empty(),
		"refunding a cell takes it off too")
	sections += 1


# ---------- §9 GATING ----------

func _gating() -> void:
	_fresh()
	_check(Profile.talent_tier() == 0, "a fresh profile has no rows")
	for spec in Classes.all_specs():
		_check(Profile.talent_points_earned(String(spec)) == 0,
			"a fresh profile has no points for %s" % spec)
		_check(Profile.equipped_talents(String(spec)).is_empty(),
			"a fresh profile equips nothing for %s" % spec)
	# DIFFICULTY 1 OPENS ROWS 1-3 FOR EVERY SPEC — rows are global.
	Profile.note_end_boss(1)
	for spec in Classes.all_specs():
		var tree: Array = Talents.generate_tree(String(spec), "")
		for row in [1, 2, 3]:
			for t in Talents.row_nodes(tree, row):
				var chk := Talents.can_buy(tree, String(t["id"]), {}, 99,
					Profile.talent_tier())
				_check(bool(chk["ok"]),
					"%s row %d is open to every spec at tier 1" % [spec, row])
	# ROW 9 IS UNREACHABLE UNTIL DIFFICULTY 3 — and specifically not at 2.
	_check(not Talents.row_unlocked(9, 1), "row 9 is shut at difficulty 1")
	_check(not Talents.row_unlocked(9, 2), "row 9 is shut at difficulty 2")
	_check(Talents.row_unlocked(9, 3), "row 9 opens at difficulty 3")
	Profile.note_end_boss(2)
	_check(Profile.talent_tier() == 2, "difficulty 2 raises the tier")
	# The tier never falls: clearing an easier rung afterwards changes nothing.
	Profile.note_end_boss(1)
	_check(Profile.talent_tier() == 2, "an easier clear does not lower the tier")
	sections += 1


# ---------- §9 PERSISTENCE ----------

func _persistence() -> void:
	_fresh()
	var spec := "pyromancer"
	Profile.note_end_boss(2)
	for i in 8:
		Profile.award_zone_boss_points([spec])
	var tree: Array = Talents.generate_tree(spec, "")
	var pick := String(Talents.row_nodes(tree, 2)[1]["id"])
	Profile.buy_cell(spec, pick)
	Profile.equip_cell(spec, pick)
	# Round-trip: drop the in-memory copy and read the file back.
	Profile.data = {}
	Profile.loaded = false
	_check(Profile.talent_points_earned(spec) == 8, "points survive a restart")
	_check(Profile.owns_cell(spec, pick), "cells survive a restart")
	_check(Profile.equipped_talents(spec).has(pick), "the loadout survives a restart")
	_check(Profile.talent_tier() == 2, "the row tier survives a restart")
	# AN EXISTING PRE-BM PROFILE LOADS WITH ZEROS. Write a v1 file by hand.
	var f := FileAccess.open(SCRATCH, FileAccess.WRITE)
	f.store_string(JSON.stringify({"version": 1, "runs_started": {"holy": 4},
		"runs_completed": {}, "wipes": {}, "forfeits": {}, "bosses_killed": {},
		"events_seen": {}, "zones_cleared": 3, "flags": {"framing": true}}))
	f = null
	Profile.data = {}
	Profile.loaded = false
	_check(Profile.talent_tier() == 0, "a pre-BM profile loads at tier 0")
	_check(Profile.talent_points_earned("holy") == 0, "…and with no points")
	_check(Profile.talent_cells("holy").is_empty(), "…and no cells")
	_check(Profile.flag("framing"), "…while its OTHER buckets survive intact")
	_check(int(Profile.data.get("version", 0)) == Profile.VERSION,
		"…and it is written back at the new version")
	# THE RUN SAVE RECORDS THE EQUIPPED NODE PER ROW: asserted against the
	# source, because Run is an autoload and does not resolve in a --script
	# SceneTree. `party` carries `talents`, and the version moved.
	var rs := _src("res://scripts/run_state.gd")
	# BATCH CT re-pointed this IN PLACE, on BK §6's precedent. It pinned the
	# literal 10 and broke when CT's slotted pouch raised it to 11. **BM's
	# invariant is that the party — and its equipped talents — is IN the save,
	# and that a pre-v10 save is refused**, neither of which is a claim about the
	# newest version number. Asserted as "10 or later" so the next bump does not
	# fail a talents test either.
	var bm_ver := -1
	var bm_vpos := rs.find('"version": ')
	if bm_vpos >= 0:
		bm_ver = int(rs.substr(bm_vpos + 11, 3).strip_edges().split(",")[0])
	_check(bm_ver >= 10, "the run save is v10 or later (found %d)" % bm_ver)
	_check(rs.contains("if save_version < 10:"), "a pre-v10 save is refused")
	_check(rs.contains('"party": party'), "the party — and its talents — is saved")
	sections += 1


# ---------- §6 THE END BOSS AND §5 THE LADDER ----------

func _end_boss_and_ladder() -> void:
	var rs := _src("res://scripts/run_state.gd")
	# The fourth boss is one extra slot in the final zone: 3 x 16 + 1 = 49.
	_check(rs.contains("const END_BOSS_SLOT := SLOTS_PER_ZONE"),
		"the end boss is the slot after the final zone's boss")
	_check(rs.contains("func total_slots() -> int:"), "the run knows its own length")
	_check(rs.contains("return SLOT_COUNT * SLOTS_PER_ZONE + 1"),
		"a run is 49 encounters")
	_check(rs.contains('slot == END_BOSS_SLOT and not has_next_zone()'),
		"only the end-boss slot ends the run")
	# It is FIXED, not composed.
	_check(rs.contains('node["enemies"] = [END_BOSS_KIND]'),
		"the end boss is a fixed encounter, not a budget roll")
	_check(Enemies.kinds().has(Run_end_boss_kind()),
		"the end boss kind exists in the roster")
	# …and it gains MECHANICS with difficulty.
	var ranked := 0
	for ab in Enemies._load()[Run_end_boss_kind()].get("abilities", []):
		if int(ab.get("rung", 1)) > 1:
			ranked += 1
	_check(ranked == 2, "the end boss gains two abilities across the ladder")
	_check(Enemies.config(Run_end_boss_kind(), 1)["abilities"].size() == 3,
		"rung 1 meets three of its abilities")
	_check(Enemies.config(Run_end_boss_kind(), 2)["abilities"].size() == 4,
		"rung 2 meets four")
	_check(Enemies.config(Run_end_boss_kind(), 3)["abilities"].size() == 5,
		"rung 3 meets five")
	# Every other kind reads identically at every rung — the filter is inert
	# where nothing is tagged.
	for kind in Enemies.kinds():
		if kind == Run_end_boss_kind():
			continue
		_check(Enemies.config(String(kind), 1)["abilities"].size()
			== Enemies.config(String(kind), 3)["abilities"].size(),
			"%s is unchanged by the rung" % kind)
	# THE LADDER: three rungs, rung 1 BELOW the present balance, rung 2 AT it.
	_check(rs.contains('const DIFFICULTY_ORDER := ["wanderer", "warden", "ruin"]'),
		"three rungs in order")
	# RE-POINTED IN PLACE (Batch BN §2): this pinned the literal 0.70, which BM
	# inherited from Batch Y's Wanderer affordance — a float picked for a
	# different job. BN swept untalented completion at 0.70 / 0.60 / 0.50 / 0.40
	# (13% / 28% / 83% / 95%) and shipped 0.50. THE QUESTION IS UNCHANGED AND SO
	# IS THE LABEL — rung 1 must sit BELOW the present balance — only the number
	# moved, so the check is re-pointed rather than deleted, and rungs 2 and 3
	# below it are asserted UNMOVED in the same breath.
	_check(rs.contains('"mult": 0.50'), "rung 1 is below the present balance")
	_check(rs.contains('"mult": 1.00'), "rung 2 IS the present balance")
	_check(rs.contains('"mult": 1.30'), "rung 3 is above it")
	_check(rs.contains('const LEGACY_DIFFICULTY := {"standard": "warden"}'),
		"Batch Y's 'standard' still resolves, at the rung it was tuned for")
	# Each rung above 1 carries a NAMED TWIST as well as scaling.
	_check(rs.contains('"severity_floor": 2') and rs.contains('"severity_floor": 3')
		and rs.contains('"severity_floor": 4'),
		"the severity floor rises with the rung")
	_check(rs.contains("var floor_sev := int(difficulty_def()[\"severity_floor\"])"),
		"roll_offer reads the rung's floor rather than a constant 2")
	_check(rs.contains("func arm_fixed_modifier(node_type: String) -> void:"),
		"rung 3 puts a modifier on the encounters a route cannot duck")
	_check(rs.contains('const FIXED_MODIFIER_NODES := ["miniboss", "boss", "endboss"]'),
		"…and it names which those are")
	_check(_src("res://scripts/map_screen.gd").contains("Run.arm_fixed_modifier(ty)"),
		"the map walk arms it")
	_check(_src("res://scripts/run_sim.gd").contains("run.arm_fixed_modifier(ty)"),
		"and so does the harness — it must walk the road the player walks")
	sections += 1


func Run_end_boss_kind() -> String:
	# Run is an autoload and does not resolve here; the constant is read off
	# the source rather than guessed.
	var rs := _src("res://scripts/run_state.gd")
	var i := rs.find('const END_BOSS_KIND := "')
	return rs.substr(i + 24, rs.find('"', i + 24) - (i + 24))


# ---------- §6 THE DELETED AWARD SITES ----------

func _award_sites_deleted() -> void:
	# DELETED, NOT ZEROED — the standing rule. Each name is pinned ABSENT so a
	# later batch that re-adds one has to read this first.
	var rs := _src("res://scripts/run_state.gd")
	var bs := _src("res://scripts/battle.gd")
	var sim := _src("res://scripts/run_sim.gd")
	var ts := _src("res://scripts/talents.gd")
	var ps := _src("res://scripts/party_screen.gd")
	var ms := _src("res://scripts/map_screen.gd")
	var sc := _src("res://scripts/spec_choice_screen.gd")
	var ev := _src("res://scripts/events.gd")
	var rl := _src("res://scripts/relics.gd")
	for pair in [["func award_talent_points", rs], ["func award_spec_point", rs],
			["award_talent_points(", bs], ["award_talent_points(", sim],
			["award_spec_point(", sim], ["award_spec_point(", sc],
			["talent_points", ps], ["talent_flex", ps],
			["talent_points", ms], ["talent_flex", ms],
			["start_talent_points", rl],
			['"talent_points"', ev],
			["func can_learn", ts], ["func purse_for", ts],
			["MAX_PER_ROW", ts], ["func points_spent", ts]]:
		_check(not String(pair[1]).contains(String(pair[0])),
			"DELETED: %s" % pair[0])
	# The events.json verb went with its handler.
	var ej := _src("res://data/events.json")
	_check(not ej.contains("talent_points"),
		"no event awards a talent point any more")
	# The two relics that granted them are re-specced, not left with a dead hook.
	_check(rl.contains('"waystone"') and rl.contains('"warhorn"'),
		"both re-specced relics survive by id")
	for id in ["waystone", "warhorn"]:
		var hooks: Dictionary = Relics.POOL[id]["hooks"]
		_check(not hooks.is_empty(), "%s still does something" % id)
		_check(not hooks.has("start_talent_points"), "%s has no dead hook" % id)
	# The superseded figures are named as superseded where they are recorded.
	_check(sim.contains("BATCH BM DELETED talent_spent"),
		"the harness says its old talent metrics are gone")
	_check(sim.contains("10.9"), "…and names BK's figure as superseded")
	# THE HANDOFF: the awakening EQUIPS rather than pays, from BOTH paths.
	_check(sc.contains("Run.equip_spec_talents(idx)"), "the spec screen equips")
	_check(sim.contains("run.equip_spec_talents(i)"), "and so does the harness")
	_check(rs.contains("func equip_spec_talents(idx: int) -> void:"),
		"one implementation of the handoff")
	# A SIM NEVER READS Profile: the loadout comes off Run.sim_talents.
	_check(rs.contains("Profile.equipped_talents(spec) if not sim_run"),
		"a real run reads Profile")
	_check(rs.contains("else sim_equipped_talents(spec)"),
		"a sim reads its own installed loadout instead")
	# A bare `contains` trips on a COMMENT naming the thing it forbids, and
	# naming it in a comment is exactly how this project asks a later batch
	# not to re-add it (the AW lesson). Look for a CALL.
	var sim_calls := 0
	for line in sim.split("\n"):
		var code := String(line).strip_edges()
		if code.begins_with("#"):
			continue
		if code.contains("Profile."):
			sim_calls += 1
	_check(sim_calls == 0, "RunSim CALLS Profile nowhere at all")
	sections += 1


# ---------- §9 THE SIX NEGATIVE CONTROLS ----------
#
# Each builds the BROKEN state and proves the checker rejects it. Every one of
# the six would otherwise fail silently: the game still runs, the hero still
# fights, and only the design is gone.

func _negative_controls() -> void:
	_fresh()
	var spec := "warden"
	var tree: Array = Talents.generate_tree(spec, "")
	Profile.note_end_boss(3)
	for i in 60:
		Profile.award_zone_boss_points([spec])
	var a := String(Talents.row_nodes(tree, 1)[0]["id"])
	var b := String(Talents.row_nodes(tree, 1)[1]["id"])

	# (1) A PURCHASED CELL AUTO-EQUIPPING.
	Profile.buy_cell(spec, a)
	_check(Profile.equipped_talents(spec).is_empty(),
		"NEGATIVE 1: buying does not equip")
	Profile.buy_cell(spec, b)
	_check(Profile.equipped_talents(spec).is_empty(),
		"NEGATIVE 1: a second purchase does not equip either")

	# (2) POINTS TRANSFERRING BETWEEN SPECS.
	var other := Profile.talent_points_available("berserker")
	_check(other == 0, "NEGATIVE 2: the Warden's purse is not the Berserker's")
	_check(not Profile.buy_cell("berserker", String(
		Talents.generate_tree("berserker", "")[0]["id"])),
		"NEGATIVE 2: another spec cannot spend it")

	# (3) ROW UNLOCKS APPLYING TO ONE SPEC ONLY.
	var opened_everywhere := true
	for s2 in Classes.all_specs():
		if not Talents.row_unlocked(9, Profile.talent_tier()):
			opened_everywhere = false
	_check(opened_everywhere,
		"NEGATIVE 3: the row tier is global, not per spec")
	_check(Profile.talent_tier() == 3 and not Profile.data.has("talent_tier_berserker"),
		"NEGATIVE 3: there is no per-spec tier to disagree with it")

	# (4) A TALENT POINT STILL AWARDED BY AN ELITE. There is no in-run purse
	# at all, so the control is that the member dict has no field for one.
	var rs := _src("res://scripts/run_state.gd")
	var i := rs.find('party.append({"key": key')
	# GUARDED: an unguarded -1 makes `member_line` empty and the negative below
	# true for every needle — a check that has stopped asking its question with
	# nothing to announce it (the `test_batch_bg` shape, EC §2).
	_check(i >= 0, "NEGATIVE 4: the party-member anchor resolves, so the slice is real")
	var member_line := rs.substr(i, 300)
	_check(not member_line.contains("talent_points")
		and not member_line.contains("talent_flex"),
		"NEGATIVE 4: a party member carries no talent purse to award into")
	var bs := _src("res://scripts/battle.gd")
	var vi := bs.find('var node_type := String(Run.encounter.get("type", "fight"))')
	var victory_code := PackedStringArray()
	for line in bs.substr(vi, 1400).split("\n"):
		var code := String(line).strip_edges()
		if not code.begins_with("#"):
			victory_code.append(code)
	_check(not "\n".join(victory_code).to_lower().contains("talent"),
		"NEGATIVE 4: the victory branch awards no talent anything")

	# (5) EQUIPPED TALENTS CHANGING MID-RUN. The build screen refuses while a
	# run is active, the party sheet has no spend path at all, and nothing in
	# a run writes member["talents"] after the awakening.
	var tsx := _src("res://scripts/talents_screen.gd")
	_check(tsx.contains("func _locked() -> bool:") and tsx.contains("return Run.active"),
		"NEGATIVE 5: the build screen locks while a run is in flight")
	for guard in ["func _on_node(id: String) -> void:", "func _on_respec() -> void:"]:
		var gi := tsx.find(guard)
		_check(tsx.substr(gi, 120).contains("if _locked():"),
			"NEGATIVE 5: %s checks the lock first" % guard)
	var ps := _src("res://scripts/party_screen.gd")
	_check(not ps.contains("func _learn_talent"),
		"NEGATIVE 5: the hero sheet has no spend path")
	_check(ps.contains("LOCKED FOR THIS RUN"),
		"NEGATIVE 5: …and says so where the player reads it")
	var writers := 0
	for line in rs.split("\n"):
		var code := String(line).strip_edges()
		if code.begins_with("#"):
			continue
		if code.contains('member["talents"] =') or code.contains('party[idx]["talents"] ='):
			writers += 1
	_check(writers == 2,
		"NEGATIVE 5: EXACTLY two writers — the handoff and the tree migration")

	# (6) A ROW-8 NODE THAT IS A ROW-4 NODE WITH A BIGGER NUMBER. Built
	# directly: a fake tree whose row-8 node writes a row-4 node's own field,
	# proven to be caught by the same field-overlap rule §9's structure check
	# runs over the live trees.
	var fake: Array = [
		{"id": "x_r4", "name": "Four", "ranks": 1, "lane": "L", "row": 4,
			"payload": {"stat": {"shared_field": 10}}},
		{"id": "x_r8", "name": "Eight", "ranks": 1, "lane": "L", "row": 8,
			"payload": {"stat": {"shared_field": 40}}},
	]
	_check(_row8_duplicates(fake),
		"NEGATIVE 6: a row-8 node re-writing a row-4 field IS caught")
	var clean: Array = [
		{"id": "y_r4", "name": "Four", "ranks": 1, "lane": "L", "row": 4,
			"payload": {"stat": {"field_a": 10}}},
		{"id": "y_r8", "name": "Eight", "ranks": 1, "lane": "L", "row": 8,
			"payload": {"stat": {"field_b": 40}}},
	]
	_check(not _row8_duplicates(clean),
		"NEGATIVE 6: …and a genuinely new effect is not")
	# The live trees pass it — asserted here as well as in _structure, so the
	# control and the thing it controls sit side by side.
	for s3 in Classes.all_specs():
		_check(not _row8_duplicates(Talents.generate_tree(String(s3), "")),
			"NEGATIVE 6: %s's row 8 is not its own lane rewritten" % s3)
	sections += 1


func _row8_duplicates(tree: Array) -> bool:
	for t in tree:
		if int(t.get("row", 0)) != 8:
			continue
		var mine: Array = (t.get("payload", {}).get("stat", {}) as Dictionary).keys()
		for other in tree:
			if String(other.get("lane", "")) != String(t.get("lane", "")):
				continue
			if int(other.get("row", 0)) >= 8:
				continue
			for f in (other.get("payload", {}).get("stat", {}) as Dictionary):
				if mine.has(f):
					return true
	return false
