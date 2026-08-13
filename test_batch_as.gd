# test_batch_as.gd — the Cryomancer re-authored around GLACIAL HOLD. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_as.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, one node per
#      lane per row, single ranks. (test_batch_ai asserts this generically for
#      all twelve trees; it is repeated here because AS moved TEN ids between
#      lanes and a shape break would otherwise only surface there.)
#   2. ALL 24 IDS — id, row, lane, name. EVERY id survives and re-specs in
#      place, which is the whole migration promise: saved picks resolve and no
#      save version moves. A dropped or renamed id silently voids a saved tree.
#   3. THE MAGNITUDES, ADDITIVE — both halves: the payload the node applies AND
#      the number its tooltip renders. Under the old `1 x step` form a rune
#      writing the same field inherited the node's multiplier, and four
#      Cryomancer spec runes ride these counters.
#   4. §0 — THE INITIATIVE AUDIT. The reschedule has ALWAYS read
#      effective_speed(); the OPENING ROLL had not. Both halves are asserted
#      against the source, because a seed is one random draw and a single
#      sample cannot tell two divisors apart.
#   5. GLACIAL HOLD'S THREE CLAUSES at their read sites, live: the permanence,
#      the indefinite hold with its NAMED releases, and the +15% window. Plus
#      the two rules a player will test first — ALLY DAMAGE DOES NOT RELEASE A
#      HOLD, and a HELD BOSS RELEASES AFTER ONE TURN.
#   6. THE RUNE AUDIT (§5) — every counter the four Cryomancer runes and the
#      three Mage runes ride is either written by a node or still has a live
#      read site. numbing_ranks has no node and is asserted RUNE-ONLY AND
#      LIVE, so "kept, not deleted" is a fact in the test rather than a note
#      in a changelog nobody re-reads.
#   7. §4 — a held enemy is off the turn bar, off the timeline, and wears a
#      HELD marker that names what releases it.
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

# id -> [row, lane, name]. BATCH_AS.md §3's three tables, transcribed once.
# The ids are the OLD ones by design — §9's mapping lives in the changelog,
# and this is the machine-checkable half of it.
const NODES := {
	"cr_hungering": [1, "Winter", "Hungering Cold"],
	"cr_emp_frostbolt": [2, "Winter", "Deep Chill"],
	"cr_grasp": [3, "Winter", "Winter's Grasp"],
	"cr_rime": [4, "Winter", "Rime"],
	"cr_icy_resolve": [5, "Winter", "Icy Resolve"],
	"cr_whiteout": [6, "Winter", "Whiteout"],
	"cr_splinter": [7, "Winter", "Splintering Shards"],
	"cr_frostbite": [1, "Deep Freeze", "Brittle Ice"],
	"cr_bitter": [2, "Deep Freeze", "Bitter Cold"],
	"cr_frigid": [3, "Deep Freeze", "Frigid Grip"],
	"cr_numbing": [4, "Deep Freeze", "Glacial Prison"],
	"cr_frost_ward": [5, "Deep Freeze", "Second Prison"],
	"cr_cold_snap": [6, "Deep Freeze", "Cold Snap"],
	"cr_glacial": [7, "Deep Freeze", "Glacial Economy"],
	"cr_hypothermia": [1, "Thaw", "Hypothermia"],
	"cr_freezing": [2, "Thaw", "Killing Frost"],
	"cr_crystal": [3, "Thaw", "Crystal Edge"],
	"cr_lance_focus": [4, "Thaw", "Cryoclasm"],
	"cr_piercing": [5, "Thaw", "Piercing Ice"],
	"cr_razor_hone": [6, "Thaw", "Honed Shards"],
	"cr_icy_veins": [7, "Thaw", "Shattered Tempo"],
	"cr_eternal": [9, "Winter", "Eternal Winter"],
	"cr_absolute": [9, "Deep Freeze", "Absolute Zero"],
	"cr_shatter": [9, "Thaw", "Shatter"],
}

# id -> [stat field, the value the PAYLOAD writes]. ADDITIVE units: each is
# the design number in the units its read site sums, never a bare 1 standing
# in for a multiplier.
const PAYLOADS := {
	"cr_hungering": ["hungering_ranks", 3],
	"cr_emp_frostbolt": ["deep_chill_ranks", 1],
	"cr_grasp": ["grasp_ranks", 2],
	"cr_icy_resolve": ["icy_resolve_ranks", 2],
	"cr_whiteout": ["whiteout_ranks", 3],
	"cr_splinter": ["splinter_ranks", 1],
	"cr_frostbite": ["frostbite_ranks", 6],
	"cr_bitter": ["bitter_cold_ranks", 2],
	"cr_frigid": ["frigid_ranks", 10],
	"cr_frost_ward": ["second_prison", 1],
	"cr_cold_snap": ["cold_snap_ranks", 15],
	"cr_glacial": ["glacial_ranks", 15],
	"cr_hypothermia": ["hypothermia_ranks", 3],
	"cr_freezing": ["killing_frost", 15],
	"cr_crystal": ["crystal_edge_ranks", 15],
	"cr_piercing": ["piercing_ice_ranks", 30],
	"cr_absolute": ["absolute_zero", 1],
	"cr_eternal": ["eternal_winter", 1],
}

# id -> the number its tooltip must render at one rank. The tooltip is the
# only place several of these design numbers appear in the DATA — every one
# of their read sites lives in battle.gd.
const TOOLTIPS := {
	"cr_hungering": "3", "cr_emp_frostbolt": "2", "cr_grasp": "2",
	"cr_icy_resolve": "2", "cr_whiteout": "3", "cr_frostbite": "6",
	"cr_bitter": "2", "cr_frigid": "10", "cr_cold_snap": "15",
	"cr_glacial": "15", "cr_hypothermia": "3", "cr_freezing": "30",
	"cr_crystal": "15", "cr_piercing": "30", "cr_razor_hone": "3",
	"cr_icy_veins": "2",
}

# id -> [ability name, cost, delay, cooldown] for the four ability nodes.
const ABILITY_NODES := {
	"cr_rime": ["Rime", 25, 3.0, 3],
	"cr_numbing": ["Glacial Prison", 25, 2.5, 4],
	"cr_lance_focus": ["Cryoclasm", 20, 2.0, 3],
	"cr_shatter": ["Shatter", 30, 4.0, 5],
}


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
	Profile.save_path = "user://profile_batch_as_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	_magnitudes()
	_ability_nodes()
	_initiative_audit()
	_rune_audit()
	_dissolved_pair()
	await _live_permanence()
	await _live_hold()
	await _live_no_accidental_thaw()
	await _live_window()
	await _live_limit()
	await _live_boss()
	await _live_turn_bar()
	await _live_tree_nodes()
	await _live_releases()

	if FileAccess.file_exists("user://profile_batch_as_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_as_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("test_batch_as: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- 1. the shape ----------

func _tree_shape() -> void:
	var tree: Array = Talents.LANE_TREES["cryomancer"]
	ok(tree.size() == 27, "the tree holds 24 nodes (got %d)" % tree.size())
	var per_lane := {}
	var rows := {}
	var capstones := 0
	for n in tree:
		var lane := String(n["lane"])
		var row := int(n["row"])
		per_lane[lane] = int(per_lane.get(lane, 0)) + 1
		rows["%s:%d" % [lane, row]] = int(rows.get("%s:%d" % [lane, row], 0)) + 1
		if n.get("capstone", false):
			capstones += 1
		ok(int(n["ranks"]) == 1, "%s is a single rank" % n["id"])
		ok(not n.has("exclusive_with"),
			"%s carries no authored exclusive pair (Batch AI made rows do that)" % n["id"])
	ok(capstones == 3, "exactly 3 capstones (got %d)" % capstones)
	ok(per_lane.size() == 3, "exactly 3 lanes (got %d)" % per_lane.size())
	for lane in ["Winter", "Deep Freeze", "Thaw"]:
		ok(int(per_lane.get(lane, 0)) == Talents.CAPSTONE_ROW,
			"lane %s holds 8 rows + a capstone (got %d)" % [lane, per_lane.get(lane, 0)])
	for key in rows:
		ok(int(rows[key]) == 1, "one node in %s" % key)
	# SHATTERPOINT is the only lane name that changed, and it must be gone —
	# the Rune of the Honed Lance is tagged by lane and would go homeless.
	ok(not per_lane.has("Shatterpoint"),
		"SHATTERPOINT is gone: the lane that was lying about its job is THAW")


# ---------- 2. every id survives ----------

func _node_table() -> void:
	var tree: Array = Talents.LANE_TREES["cryomancer"]
	var by_id := {}
	for n in tree:
		by_id[String(n["id"])] = n
	for id in NODES:
		var want: Array = NODES[id]
		ok(by_id.has(id), "id %s survives (a lost id voids every saved tree)" % id)
		if not by_id.has(id):
			continue
		var n: Dictionary = by_id[id]
		ok(int(n["row"]) == want[0],
			"%s sits in row %d (got %d)" % [id, want[0], n["row"]])
		ok(String(n["lane"]) == want[1],
			"%s sits in lane %s (got %s)" % [id, want[1], n["lane"]])
		ok(String(n["name"]) == want[2],
			"%s is named %s (got %s)" % [id, want[2], n["name"]])
	for id in by_id:
		# BATCH BM: skip row 8 — this batch's table is ITS OWN record of ITS OWN
		# 24 nodes, and BM added a row-8 node to every lane. The check exists to
		# prove the twenty-four survive unchanged, not that nothing else exists.
		if int(by_id[id]["row"]) == 8:
			continue
		ok(NODES.has(id), "no node was ADDED: %s is not in the table" % id)


# ---------- 3. additive magnitudes, payload and tooltip ----------

func _magnitudes() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["cryomancer"]:
		by_id[String(n["id"])] = n
	for id in PAYLOADS:
		if not by_id.has(id):
			continue
		var want: Array = PAYLOADS[id]
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, by_id[id]["payload"], 1, {})
		ok(int(cfg.get(want[0], 0)) == want[1],
			"%s writes %s = %d (got %s)" % [id, want[0], want[1], cfg.get(want[0], "nothing")])
	# The two counters that are not ints.
	var st_cfg := {"abilities": []}
	Talents.apply_payload(st_cfg, by_id["cr_icy_veins"]["payload"], 1, {})
	ok(abs(float(st_cfg.get("shattered_tempo", 0.0)) - 2.0) < 0.001,
		"Shattered Tempo writes 2.0 of initiative push")
	var hs_cfg := {"abilities": []}
	Talents.apply_payload(hs_cfg, by_id["cr_razor_hone"]["payload"], 1, {})
	ok(int(hs_cfg.get("honed_shards_ranks", 0)) == 3,
		"Honed Shards writes 3 stacks")
	for id in TOOLTIPS:
		if not by_id.has(id):
			continue
		var shown := Talents.desc_for(by_id[id], 1)
		ok(shown.contains(TOOLTIPS[id]),
			"%s's tooltip renders %s (got: %s)" % [id, TOOLTIPS[id], shown])
		ok(not shown.contains("{v}"), "%s's tooltip resolved its placeholder" % id)
	# Splintering Shards has no {v} left, deliberately: ALWAYS is not a number.
	var sp := Talents.desc_for(by_id["cr_splinter"], 1)
	ok(sp.contains("ALWAYS"), "Splintering Shards is certain, not a roll")


# ---------- the four ability nodes ----------

func _ability_nodes() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["cryomancer"]:
		by_id[String(n["id"])] = n
	for id in ABILITY_NODES:
		if not by_id.has(id):
			continue
		var want: Array = ABILITY_NODES[id]
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, by_id[id]["payload"], 1, {})
		var abs_list: Array = cfg["abilities"]
		ok(abs_list.size() == 1, "%s grants exactly one ability" % id)
		if abs_list.is_empty():
			continue
		var ab: Ability = abs_list[0]
		ok(ab.display_name == want[0], "%s grants %s (got %s)" % [id, want[0], ab.display_name])
		ok(ab.cost == want[1], "%s costs %d (got %d)" % [want[0], want[1], ab.cost])
		ok(abs(ab.delay - want[2]) < 0.001,
			"%s costs %.1f initiative (got %.1f)" % [want[0], want[2], ab.delay])
		ok(ab.cooldown == want[3],
			"%s cools down in %d (got %d)" % [want[0], want[3], ab.cooldown])
	# The two NEW abilities carry their specials; nothing else claims them.
	var gp := {"abilities": []}
	Talents.apply_payload(gp, by_id["cr_numbing"]["payload"], 1, {})
	ok(gp["abilities"][0].special == "glacial_prison", "Glacial Prison carries its special")
	var cc := {"abilities": []}
	Talents.apply_payload(cc, by_id["cr_lance_focus"]["payload"], 1, {})
	ok(cc["abilities"][0].special == "cryoclasm", "Cryoclasm carries its special")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.count('"glacial_prison":') == 1, "exactly one glacial_prison handler")
	ok(src.count('"cryoclasm":') == 1, "exactly one cryoclasm handler")


# ---------- 4. §0: the initiative audit ----------

func _initiative_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# THE HOLE, CLOSED. The opening roll seeds off effective speed now.
	ok(src.contains("u.next_time = (100.0 / maxf(u.effective_speed(), 0.1))"),
		"§0: the opening initiative roll seeds off effective_speed()")
	ok(not src.contains("(100.0 / u.speed)"),
		"§0: nothing seeds the timeline off the RAW speed stat any more")
	# THE FINDING, PINNED. Every line in battle.gd that advances a unit's
	# place on the timeline divides by effective_speed() — that was already
	# true before Batch AS, and it is the reason Chilled has always slowed.
	# Asserted against the source because a scheduler cannot be driven
	# headlessly and a single seed is one random draw.
	var bad := 0
	var seeds := 0
	for line in src.split("\n"):
		if not ("next_time" in line and "/" in line):
			continue
		if "//" in line:
			continue
		seeds += 1
		if not ("effective_speed()" in line):
			bad += 1
	ok(seeds >= 8, "found the timeline arithmetic to audit (%d lines)" % seeds)
	ok(bad == 0, "§0: every next_time divisor is effective_speed() (%d are not)" % bad)
	# Frigid Grip is the node §0 exists for, so its arithmetic is pinned too:
	# PER STACK, and floored so a deep pile can never produce a zero divisor.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(usrc.contains("maxf(0.5 - frigid_bonus * chill, 0.1)"),
		"Frigid Grip slows PER STACK, floored")
	# A bare BattleUnit has no nameplate, so the status list is built by hand
	# rather than through add_status (which refreshes chips that do not exist).
	var u := BattleUnit.new()
	u.speed = 100.0
	ok(abs(u.effective_speed() - 100.0) < 0.01, "an unchilled unit runs at its speed")
	u.statuses.append({"id": "chilled", "stacks": 1, "turns": -1})
	ok(abs(u.effective_speed() - 75.0) < 0.01, "one stack of Chilled is -25%")
	u.frigid_bonus = 0.10
	ok(abs(u.effective_speed() - 65.0) < 0.01, "...-35% with Frigid Grip")
	u.statuses[0]["stacks"] = 2
	ok(abs(u.effective_speed() - 30.0) < 0.01,
		"two stacks is -50%, and Frigid Grip's 10 points ride EACH of them")
	u.statuses[0]["stacks"] = 3
	ok(abs(u.effective_speed() - 20.0) < 0.01, "...and three is -80%")
	u.free()


# ---------- 6. the rune audit ----------

func _rune_audit() -> void:
	var pool := {}
	for id in Runes.ids():
		pool[id] = Runes.config(id)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var cryo := []
	var mage := []
	for id in pool:
		var r: Dictionary = pool[id]
		if String(r.get("scope", "")) == "spec:cryomancer":
			cryo.append(id)
		elif String(r.get("scope", "")) == "class:mage":
			mage.append(id)
	ok(cryo.size() == 4, "four Cryomancer spec runes (got %d)" % cryo.size())
	ok(mage.size() == 3, "three Mage class-wide runes (got %d)" % mage.size())
	# Every lane tag must name a lane that EXISTS — the Honed Lance was tagged
	# Shatterpoint, which stopped being a lane.
	var lanes := []
	for n in Talents.LANE_TREES["cryomancer"]:
		if not lanes.has(String(n["lane"])):
			lanes.append(String(n["lane"]))
	for id in cryo:
		var lane := String(pool[id].get("lane", ""))
		if lane != "":
			ok(lanes.has(lane), "the rune %s is tagged with a live lane (%s)" % [id, lane])
	# The re-pointed magnitudes, in the units their read sites now sum.
	ok(int(pool["bitter_grip"]["payload"]["stat"]["frigid_ranks"]) == 3,
		"the Bitter Grip pays its advertised 3 points of Frigid Grip")
	ok(int(pool["bitter_grip"]["payload"]["stat"]["frostbite_ranks"]) == 2,
		"...and its advertised 2 points of Brittle Ice")
	ok(int(pool["long_winter"]["payload"]["stat"]["frigid_ranks"]) == 3,
		"the Long Winter pays 3 points of Frigid Grip")
	ok(int(pool["long_winter"]["payload"]["stat"]["crystal_edge_ranks"]) == 5,
		"...and 5 points of Crystal Edge")
	ok(int(pool["long_winter"]["payload"]["stat"]["hungering_ranks"]) == 1,
		"...and 1 point of Hungering Cold, which did not move")
	ok(int(pool["killing_cold"]["payload"]["stat"]["numbing_ranks"]) == 5,
		"the Killing Cold pays its advertised 5 points of Numbing Veil")
	ok(int(pool["killing_cold"]["payload"]["stat"]["hypothermia_ranks"]) == 2,
		"...and 2 points of Hypothermia, which did not move")
	# NUMBING VEIL HAS NO NODE AND THE READ SITE IS KEPT. That is §5's rule
	# made a fact: a rune whose node is gone is flagged for re-authoring, not
	# silently deleted. If a later batch re-nodes it, this check comes down.
	var node_fields := []
	for n in Talents.LANE_TREES["cryomancer"]:
		for f in n["payload"].get("stat", {}):
			node_fields.append(String(f))
	ok(not node_fields.has("numbing_ranks"),
		"no node writes numbing_ranks any more (Glacial Prison took the id)")
	ok(bsrc.contains('chance += 0.01 * _max_hero_rank("numbing_ranks")'),
		"...and its read site is KEPT and LIVE, in the units the rune writes")
	# Every counter a Cryomancer rune writes must still be read SOMEWHERE.
	for id in cryo:
		for f in pool[id].get("payload", {}).get("stat", {}):
			if String(f) == "healing_received_mult":
				continue  # a generic unit field, not a talent counter
			ok(bsrc.contains(String(f)) or f == "frigid_ranks",
				"the counter %s (rune %s) still has a read site" % [f, id])
	# No Mage class-wide rune touches a Cryomancer counter — asserted so a
	# future re-tune of one cannot silently re-tune the other.
	for id in mage:
		for f in pool[id].get("payload", {}).get("stat", {}):
			ok(not node_fields.has(String(f)),
				"the Mage rune %s does not write a Cryomancer node counter (%s)" % [id, f])


# ---------- §6: the dissolved pair ----------

func _dissolved_pair() -> void:
	# cold_snap <-> bitter_cold was an authored exclusive pair. Both sit in
	# the SAME lane now (Deep Freeze rows 6 and 2), so a player can hold both
	# and a rune writing either counter is legal.
	var by_id := {}
	for n in Talents.LANE_TREES["cryomancer"]:
		by_id[String(n["id"])] = n
	ok(String(by_id["cr_cold_snap"]["lane"]) == String(by_id["cr_bitter"]["lane"]),
		"cold_snap and bitter_cold share a lane, so they are not exclusive")
	ok(int(by_id["cr_cold_snap"]["row"]) != int(by_id["cr_bitter"]["row"]),
		"...and different rows, so BOTH are reachable")
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not claude.contains("(heat_haze/scorched, cold_snap/"),
		"CLAUDE.md's exclusive-pair LIST no longer names the dissolved pair")
	ok(claude.contains("cold_snap/bitter_cold DISSOLVED"),
		"...and it says so, rather than the entry quietly vanishing")
	ok(claude.contains("heat_haze/scorched")
			and claude.contains("arcane_ward/still_mind")
			and claude.contains("cascade/overflow")
			and claude.contains("stalwart/bastion")
			and claude.contains("pact_flesh/barter"),
		"...and the other five pairs are left alone")


# ---------- live ----------

func _spawn(learned: Dictionary, lineup: Array, ty := "fight") -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": ty, "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline). Every
	# check below drives _resolve by hand, and a 5% miss or a 5% parry skips
	# the whole damage path — which reads as "the node did nothing" and turns
	# a real assertion into a coin flip.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _cryo(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "permafrost":
			return h
	return null


# Put `n` stacks of Chilled on a foe THROUGH THE NORMAL DOOR, so Rime, Frigid
# Grip and the freeze cascade all behave exactly as they do in play.
func _chill(scene: Node, foe: BattleUnit, src: BattleUnit, n: int) -> void:
	for _i in n:
		scene.call("_apply_status", foe, "chilled", 3, 0, 0, src)


# Clause 1 — PERMAFROST: his stacks never expire.
func _live_permanence() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	var cryo := _cryo(scene)
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	_chill(scene, foe, cryo, 1)
	ok(int(foe.get_status("chilled").get("turns", 0)) < 0,
		"CLAUSE 1: a stack the Cryomancer applies never expires")
	# An enemy-applied chill keeps its clock — the permanence is HIS.
	var hero: BattleUnit = scene.get("heroes")[0]
	scene.call("_apply_status", hero, "chilled", 3, 0, 0, foe)
	ok(int(hero.get_status("chilled").get("turns", 0)) == 3,
		"...but an enemy's chill still runs on a 3-turn clock")
	scene.queue_free()
	await process_frame


# Clause 2 — THE HOLD.
func _live_hold() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	var before := foe.next_time
	_chill(scene, foe, cryo, 4)
	ok(foe.has_status("frozen"), "four stacks freeze the victim")
	ok(scene.call("_is_held", foe), "CLAUSE 2: and the freeze is a HOLD")
	ok(int(foe.get_status("frozen").get("turns", 0)) < 0,
		"the hold is INDEFINITE — it carries no clock at all")
	ok(is_inf(foe.next_time),
		"a held enemy leaves the timeline entirely (was %.1f)" % before)
	ok(foe.status_stacks("chilled") == 4,
		"the pile stays maxed while he holds it (got %d)" % foe.status_stacks("chilled"))
	# TIME DOES NOT THAW IT. Ticking its statuses the way a lost turn would is
	# the closest thing to "waiting it out" the engine has.
	for _i in 12:
		foe.tick_statuses()
	ok(foe.has_status("frozen"), "twelve ticks later it is STILL held — time does nothing")
	# The named release.
	scene.call("_hold_release", foe, "the test")
	ok(not foe.has_status("frozen"), "the named release thaws it")
	ok(not scene.call("_is_held", foe), "...and clears the ledger")
	ok(foe.status_stacks("chilled") == 1,
		"a released enemy comes back on 1 stack, so the engine stays warm")
	ok(not is_inf(foe.next_time), "...and rejoins the timeline")
	scene.queue_free()
	await process_frame


# The rule a player will test first, and the one the spec dies without.
func _live_no_accidental_thaw() -> void:
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	_chill(scene, foe, cryo, 4)
	ok(scene.call("_is_held", foe), "the target is held")
	# ALLY DAMAGE DOES NOT RELEASE A HOLD.
	var ally: BattleUnit = scene.get("heroes")[0]
	await scene.call("_resolve", ally, ally.abilities[0], foe, "good", true)
	ok(scene.call("_is_held", foe) or foe.dead,
		"ALLY DAMAGE DOES NOT RELEASE A HOLD")
	ok(foe.dead or foe.has_status("frozen"), "...the ice is still on it")
	# HIS OWN AoE DOES NOT RELEASE IT EITHER — the reason Blizzard's
	# description says so, and the reason the release is named.
	if not foe.dead:
		var bliz: Ability = null
		for ab in cryo.abilities:
			if ab.display_name == "Blizzard":
				bliz = ab
		ok(bliz != null, "the Cryomancer holds Blizzard")
		if bliz != null:
			await scene.call("_resolve", cryo, bliz, foes[1], "good", true)
			ok(scene.call("_is_held", foe) or foe.dead,
				"HIS OWN BLIZZARD DOES NOT THAW A HOLD")
	# NOR DOES AN ENEMY CLEANSING RITE: a battle-long freeze reads as 999
	# turns remaining, so the rite's longest-first pick would take the hold
	# every single time.
	if not foe.dead:
		var cleansable: Array = scene.call("_cleansable_debuffs", foe)
		var has_freeze := false
		for s in cleansable:
			if String(s.get("id", "")) == "frozen":
				has_freeze = true
		ok(not has_freeze, "a Cleansing Rite cannot reach a hold")
	scene.queue_free()
	await process_frame


# Clause 3 — THE WINDOW.
func _live_window() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	ok(abs(float(scene.call("_hold_window_mult")) - 1.15) < 0.001,
		"CLAUSE 3: a held enemy takes +15% damage from all sources")
	scene.queue_free()
	await process_frame
	var kf := await _spawn({"cr_freezing": 1}, ["raider", "raider"])
	ok(abs(float(kf.call("_hold_window_mult")) - 1.30) < 0.001,
		"Killing Frost lifts the window to +30%")
	kf.queue_free()
	await process_frame


# The limit, and what happens when he freezes past it.
func _live_limit() -> void:
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	ok(int(scene.call("_hold_limit")) == 1, "he holds ONE enemy by default")
	var foes: Array = scene.get("enemies")
	_chill(scene, foes[0], cryo, 4)
	_chill(scene, foes[1], cryo, 4)
	ok(not scene.call("_is_held", foes[0]),
		"freezing past the limit releases the OLDEST hold")
	ok(scene.call("_is_held", foes[1]), "...and the newest one holds")
	ok(foes[0].status_stacks("chilled") == 1,
		"the evicted enemy comes back on 1 stack like any other release")
	scene.queue_free()
	await process_frame
	# Second Prison, then Absolute Zero.
	var two := await _spawn({"cr_frost_ward": 1}, ["raider", "raider", "raider"])
	ok(int(two.call("_hold_limit")) == 2, "Second Prison holds TWO")
	var c2 := _cryo(two)
	var f2: Array = two.get("enemies")
	if c2 != null:
		_chill(two, f2[0], c2, 4)
		_chill(two, f2[1], c2, 4)
		ok(two.call("_is_held", f2[0]) and two.call("_is_held", f2[1]),
			"...and both prisons stand at once")
	two.queue_free()
	await process_frame
	var az := await _spawn({"cr_absolute": 1}, ["raider", "raider", "raider"])
	ok(int(az.call("_hold_limit")) >= 3,
		"Absolute Zero puts NO limit on how many he holds")
	az.queue_free()
	await process_frame


# The boss carve-out: they resist until Broken, and a held boss releases on
# its own after one turn. A boss removed from the fight indefinitely is not a
# control fantasy, it is a softlock.
func _live_boss() -> void:
	var scene := await _spawn({}, ["withered_warden", "raider"], "boss")
	var cryo := _cryo(scene)
	var boss: BattleUnit = null
	for e in scene.get("enemies"):
		if e.is_boss:
			boss = e
	ok(boss != null, "the boss spawned")
	if cryo == null or boss == null:
		scene.queue_free()
		return
	_chill(scene, boss, cryo, 4)
	ok(not boss.has_status("frozen"),
		"a boss resists the freeze until Broken — the carve-out it already had")
	ok(not scene.call("_is_held", boss), "...so it is never held")
	boss.broken = true
	_chill(scene, boss, cryo, 1)
	ok(boss.has_status("frozen"), "a BROKEN boss can be frozen")
	ok(scene.call("_is_held", boss), "...and it is held")
	ok(int(boss.get_status("frozen").get("turns", 0)) == 1,
		"A HELD BOSS CARRIES ONE TURN OF ICE, not an indefinite hold")
	ok(not is_inf(boss.next_time),
		"...and it keeps its place on the timeline, so the turn can be spent")
	# ...WHICH IS WHY THE TURN BAR'S _is_held FILTER IS LOAD-BEARING, and why
	# this assertion lives here rather than in _live_turn_bar. An ordinary
	# hold leaves the bar because its next_time is INF; a held BOSS does not
	# get that, so only the filter keeps it off. A negative control that
	# stripped the filter passed cleanly against a raider and is caught here.
	scene.call("_rebuild_turn_bar")
	await process_frame
	var boss_slots := 0
	for slot in scene.get("turn_bar").get_children():
		if slot.get_child(0).tooltip_text.begins_with(boss.unit_name):
			boss_slots += 1
	ok(boss_slots == 0,
		"§4: a held BOSS is off the turn bar too (%d slots left)" % boss_slots)
	# Spend it the way the turn loop does, then let the ledger true up.
	boss.tick_statuses()
	scene.call("_hold_sync")
	ok(not boss.has_status("frozen"), "A HELD BOSS RELEASES AFTER ONE TURN")
	ok(not scene.call("_is_held", boss), "...and leaves the ledger with it")
	scene.queue_free()
	await process_frame


# §4 — the turn bar. The single most legible thing in the batch.
func _live_turn_bar() -> void:
	# DISTINCT enemy kinds on purpose: the bar's tooltip is the unit NAME, so
	# three raiders would be three identical tooltips and "the held one is
	# gone" would be unprovable. This check failed exactly that way first.
	var scene := await _spawn({}, ["raider", "archer", "shaman"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = null
	for e in scene.get("enemies"):
		if e.unit_name.contains("Archer"):
			foe = e
	ok(foe != null, "the archer spawned")
	if foe == null:
		scene.queue_free()
		return
	var bar: Node = scene.get("turn_bar")
	# A FRAME BETWEEN EACH REBUILD AND ITS COUNT. _rebuild_turn_bar opens by
	# queue_free()ing its old slots, and queue_free is DEFERRED — so counting
	# immediately after sees BOTH bars at once. That artefact read as "the
	# held enemy is still in the bar" on this check's first run, and it is a
	# harness bug that looks exactly like a product one.
	scene.call("_rebuild_turn_bar")
	await process_frame
	var before := bar.get_child_count()
	ok(before > 0, "the turn bar draws slots at all (%d)" % before)
	var seen_before := 0
	for slot in bar.get_children():
		if slot.get_child(0).tooltip_text.begins_with(foe.unit_name):
			seen_before += 1
	ok(seen_before > 0, "the enemy has slots in the bar before it is held")
	_chill(scene, foe, cryo, 4)
	scene.call("_rebuild_turn_bar")
	await process_frame
	var seen_after := 0
	for slot in bar.get_children():
		if slot.get_child(0).tooltip_text.begins_with(foe.unit_name):
			seen_after += 1
	ok(seen_after == 0,
		"§4: A HELD ENEMY IS REMOVED FROM THE TURN BAR ENTIRELY (%d slots left)" % seen_after)
	# ...and its nameplate says so, in words that name every door out.
	var st := foe.get_status("frozen")
	ok(String(st.get("label", "")) == "HELD", "the nameplate marker reads HELD")
	var tip := String(st.get("desc", ""))
	ok(tip.contains("Ice Lance") and tip.contains("Shatter"),
		"...and the tooltip names what releases it")
	ok(tip.contains("Ally damage"), "...and what does NOT")
	scene.queue_free()
	await process_frame


# The nodes whose whole existence is a battle-time read site.
func _live_tree_nodes() -> void:
	# Deep Chill: Frostbolt lays two stacks, not one.
	var dc := await _spawn({"cr_emp_frostbolt": 1}, ["raider", "raider"])
	var c1 := _cryo(dc)
	if c1 != null:
		var foe: BattleUnit = dc.get("enemies")[0]
		await dc.call("_resolve", c1, c1.abilities[0], foe, "good", true)
		ok(foe.status_stacks("chilled") == 2 or foe.dead,
			"Deep Chill: Frostbolt applies 2 stacks (got %d)" % foe.status_stacks("chilled"))
	dc.queue_free()
	await process_frame
	# Splintering Shards: Razor Ice ALWAYS strikes a fourth time, which is a
	# freeze out of a single cast.
	var sp := await _spawn({"cr_splinter": 1}, ["raider", "raider"])
	var c2 := _cryo(sp)
	if c2 != null:
		var razor: Ability = null
		for ab in c2.abilities:
			if ab.display_name == "Razor Ice":
				razor = ab
		var foe2: BattleUnit = sp.get("enemies")[0]
		if razor != null:
			await sp.call("_resolve", c2, razor, foe2, "good", true)
			ok(sp.call("_is_held", foe2) or foe2.dead,
				"Splintering Shards: ONE Razor Ice is a freeze")
	sp.queue_free()
	await process_frame
	# Whiteout: Blizzard lays a flat 3 on everything.
	var wo := await _spawn({"cr_whiteout": 1}, ["raider", "raider"])
	var c3 := _cryo(wo)
	if c3 != null:
		var bliz: Ability = null
		for ab in c3.abilities:
			if ab.display_name == "Blizzard":
				bliz = ab
		var wfoes: Array = wo.get("enemies")
		if bliz != null:
			await wo.call("_resolve", c3, bliz, wfoes[0], "good", true)
			var least := 4
			for f in wfoes:
				if not f.dead:
					least = mini(least, f.status_stacks("chilled"))
			ok(least >= 3, "Whiteout: every enemy takes 3 stacks (lowest was %d)" % least)
	wo.queue_free()
	await process_frame
	# Cold Snap: the hold is not idle time — it converts into the party's
	# Break, 15 a turn.
	var cs := await _spawn({"cr_cold_snap": 1}, ["raider", "raider"])
	var c4 := _cryo(cs)
	if c4 != null:
		var foe4: BattleUnit = cs.get("enemies")[0]
		_chill(cs, foe4, c4, 4)
		var pr_before := foe4.pressure
		foe4.take_hit(0, c4.cold_snap_ranks)
		ok(foe4.pressure > pr_before,
			"Cold Snap: a held enemy's Break meter fills while it waits")
		ok(c4.cold_snap_ranks == 15, "...by 15 (got %d)" % c4.cold_snap_ranks)
	cs.queue_free()
	await process_frame
	# Glacial Economy pays 15% of maximum Mana per freeze.
	var ge := await _spawn({"cr_glacial": 1}, ["raider", "raider"])
	var c5 := _cryo(ge)
	if c5 != null:
		c5.resource = 0
		var foe5: BattleUnit = ge.get("enemies")[0]
		_chill(ge, foe5, c5, 4)
		var want := int(round(c5.max_resource * 0.15))
		ok(c5.resource == want,
			"Glacial Economy returns 15%% of max Mana (%d, wanted %d)" % [c5.resource, want])
	ge.queue_free()
	await process_frame
	# Bitter Cold rolls two stacks across every OTHER enemy.
	var bc := await _spawn({"cr_bitter": 1}, ["raider", "raider", "raider"])
	var c6 := _cryo(bc)
	if c6 != null:
		var bfoes: Array = bc.get("enemies")
		_chill(bc, bfoes[0], c6, 4)
		ok(bfoes[1].status_stacks("chilled") == 2 and bfoes[2].status_stacks("chilled") == 2,
			"Bitter Cold: the freeze lays 2 stacks on every other enemy")
	bc.queue_free()
	await process_frame


# The releases, and the two nodes that ride them.
func _live_releases() -> void:
	# Ice Lance IS the release.
	var il := await _spawn({}, ["raider", "raider"])
	var c1 := _cryo(il)
	if c1 != null:
		var foe: BattleUnit = il.get("enemies")[0]
		foe.max_hp = 9999
		foe.hp = 9999
		_chill(il, foe, c1, 4)
		var lance: Ability = null
		for ab in c1.abilities:
			if ab.display_name == "Ice Lance":
				lance = ab
		ok(lance != null, "the Cryomancer holds Ice Lance")
		if lance != null:
			await il.call("_resolve", c1, lance, foe, "good", true)
			ok(not il.call("_is_held", foe), "ICE LANCE IS THE RELEASE")
			ok(foe.status_stacks("chilled") == 1, "...and the enemy comes back on 1 stack")
	il.queue_free()
	await process_frame
	# Honed Shards rides the RELEASE now, not the crit — and because it lives
	# in _hold_release, every release inherits it.
	var hs := await _spawn({"cr_razor_hone": 1}, ["raider", "raider"])
	var c2 := _cryo(hs)
	if c2 != null:
		var foe2: BattleUnit = hs.get("enemies")[0]
		foe2.max_hp = 9999
		foe2.hp = 9999
		_chill(hs, foe2, c2, 4)
		hs.call("_hold_release", foe2, "the test")
		ok(foe2.status_stacks("chilled") == 4,
			"Honed Shards: 1 + 3 fresh stacks (got %d)" % foe2.status_stacks("chilled"))
		ok(hs.call("_is_held", foe2),
			"...which is four again, so the release re-holds it on the spot")
	hs.queue_free()
	await process_frame
	# Shattered Tempo pays the release out in TIME rather than damage.
	var st := await _spawn({"cr_icy_veins": 1}, ["raider", "raider", "raider"])
	var c3 := _cryo(st)
	if c3 != null:
		var sfoes: Array = st.get("enemies")
		_chill(st, sfoes[0], c3, 4)
		var other_before: float = sfoes[1].next_time
		st.call("_hold_release", sfoes[0], "the test")
		ok(sfoes[1].next_time > other_before,
			"Shattered Tempo: releasing pushes every OTHER enemy back")
		var pushed: float = sfoes[1].next_time - other_before
		var want: float = 2.0 * 100.0 / maxf(sfoes[1].effective_speed(), 0.1)
		ok(abs(pushed - want) < 0.01,
			"...by 2.0 on the timeline, through the delay_push arithmetic")
	st.queue_free()
	await process_frame
	# Cryoclasm MOVES a hold without spending it — no release payoff fires.
	var cc := await _spawn({"cr_lance_focus": 1, "cr_icy_veins": 1},
		["raider", "raider", "raider"])
	var c4 := _cryo(cc)
	if c4 != null:
		var cfoes: Array = cc.get("enemies")
		_chill(cc, cfoes[0], c4, 4)
		var clasp: Ability = null
		for ab in c4.abilities:
			if ab.display_name == "Cryoclasm":
				clasp = ab
		ok(clasp != null, "Cryoclasm is in the kit")
		var untouched: float = cfoes[2].next_time
		if clasp != null:
			await cc.call("_resolve", c4, clasp, cfoes[1], "good", true)
			ok(not cc.call("_is_held", cfoes[0]), "Cryoclasm empties the old prison")
			ok(cc.call("_is_held", cfoes[1]), "...and the hold lands on the new target")
			ok(cfoes[1].status_stacks("chilled") == 4, "...carrying its stacks with it")
			ok(abs(cfoes[2].next_time - untouched) < 0.01,
				"A MOVE IS NOT A RELEASE: Shattered Tempo does not fire")
	cc.queue_free()
	await process_frame
	# Shatter is the MASS release, paid on the pile each prison carried.
	var sh := await _spawn({"cr_shatter": 1, "cr_absolute": 1},
		["raider", "raider", "raider"])
	var c5 := _cryo(sh)
	if c5 != null:
		var hfoes: Array = sh.get("enemies")
		for f in hfoes:
			f.max_hp = 9999
			f.hp = 9999
			_chill(sh, f, c5, 4)
		ok(sh.get("_holds").size() == 3, "Absolute Zero lets all three be held at once")
		var shat: Ability = null
		for ab in c5.abilities:
			if ab.display_name == "Shatter":
				shat = ab
		ok(shat != null, "Shatter is in the kit")
		if shat != null:
			ok(sh.call("_ability_usable", c5, shat), "Shatter lights with a hold to break")
			await sh.call("_resolve", c5, shat, hfoes[0], "good", true)
			ok(sh.get("_holds").is_empty(), "SHATTER RELEASES EVERY HOLD AT ONCE")
			for f in hfoes:
				ok(f.hp < 9999, "...and every held enemy took the blast")
	sh.queue_free()
	await process_frame
	# ...and it does NOT light with nothing held.
	var dry := await _spawn({"cr_shatter": 1}, ["raider", "raider"])
	var c6 := _cryo(dry)
	if c6 != null:
		for ab in c6.abilities:
			if ab.display_name == "Shatter":
				ok(not dry.call("_ability_usable", c6, ab),
					"Shatter is dark with no prison to break")
	dry.queue_free()
	await process_frame
