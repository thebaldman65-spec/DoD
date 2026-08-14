# test_batch_az.gd — THE SHARPSHOOTER: PATIENCE. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_az.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 FOCUS HAS NO CEILING and its payoff CONVERTS at 100: past 100, 200 and
#      400 with the CHANCE stopping at the split and the MULTIPLIER taking over;
#      Deep Focus moving the split to 60; Spray of Arrows as the one node that
#      still hands the meter a number.
#   §1 COUP DE GRACE READS NO MORE THAN 200 FOCUS, however deep the meter runs,
#      and ONE SHOT fires at 200 and resets to 0.
#   §2 UNWAVERING CHANGED SIDES: the ramp rises by 10 to a cap of 50 and RESETS
#      on a switch — and no path halves Focus on a switch any more.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the node
#      that owes it, every counter ADDITIVE at its read site.
#   §4 EXECUTIONER'S EYE <-> CONSISTENT AIM IS DISSOLVED (rows 4 and 5 of ONE
#      lane) and the two held together resolve to x2.0; TUNNEL VISION <-> SPRAY
#      OF ARROWS SURVIVES because row exclusivity enforces it.
#   §5 THE TROPHY-POOL COLLISION CANNOT ARISE: no Sharpshooter node grants an
#      ability, so he owes no AU §1 fallback in either direction.
#   §6 the four spec runes re-pointed onto live counters in the new units, the
#      three Hunter class-wide runes touching none of them, and Long Draw
#      resolved against Opening Volley's 150.
#   §7 THE BOT: it never switches while its mark lives, and Coup waits for the
#      reading cap.
#   NEGATIVE CONTROLS for the four that would fail silently: Focus past the
#      split still buying chance, Consistent Aim SETTING the multiplier instead
#      of subtracting, Unwavering surviving a target switch, and Coup reading
#      the whole meter.
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
	Profile.save_path = "user://profile_batch_az_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_conversion_math()
	_no_ability_grants()
	_rune_audit()
	_bot_policy_source()
	_exclusive_pairs()
	_docs()
	_negative_control_source()

	await _live_uncapped()
	await _live_conversion()
	await _live_deep_focus()
	await _live_crit_mult_pair()
	await _live_unwavering_ramp()
	await _live_overkill_keeps_focus()
	await _live_coup_cap()
	await _live_one_shot()
	await _live_opening_volley()
	await _live_spray_cap()

	if FileAccess.file_exists("user://profile_batch_az_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_az_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_az: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("sharpshooter", "hunter")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _hero(scene: Node, idx: int) -> BattleUnit:
	var hs: Array = scene.get("heroes")
	return hs[idx] if idx < hs.size() else null


# The Sharpshooter sits in the HUNTER slot (index 3).
func _spawn(learned: Dictionary, lineup := ["raider", "raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "inquisitor", "sharpshooter"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 3 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT/AU/AV/AW/AX/AY
	# discipline). A driven _resolve still rolls miss, parry AND crit.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


# ---------- §3 the tree's shape ----------

const IDS := ["ss_steady", "ss_perfect_form", "ss_deep_focus", "ss_exec_eye",
	"ss_consistent", "ss_unwavering", "ss_tunnel",
	"ss_piercer", "ss_sundering", "ss_bonecracker", "ss_opp_aim",
	"ss_exposed_nerve", "ss_no_cover", "ss_overkill",
	"ss_fletcher", "ss_snap", "ss_muscle", "ss_volley", "ss_follow",
	"ss_second_nature", "ss_spray",
	"ss_one_shot", "ss_tnt", "ss_rapid"]


func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 27, "the Sharpshooter tree holds 24 nodes (got %d)" % tree.size())
	var by_lane := {"Precision": 0, "Penetration": 0, "Tempo": 0}
	var caps := 0
	var seen := {}
	for t in tree:
		var id := String(t["id"])
		ok(not seen.has(id), "id %s appears once" % id)
		seen[id] = true
		ok(int(t.get("ranks", 0)) == 1, "%s holds a single rank" % id)
		var row := int(t.get("row", 0))
		ok(row >= 1 and row <= Talents.CAPSTONE_ROW, "%s sits in a real row 1-9 (got %d)" % [id, row])
		if bool(t.get("capstone", false)):
			caps += 1
			ok(row == Talents.CAPSTONE_ROW, "capstone %s is on the capstone shelf" % id)
		else:
			by_lane[String(t["lane"])] = by_lane[String(t["lane"])] + 1
		# Batch AI's structure: exclusive references are by ROW, so no node may
		# carry a stale `exclusive_with` pointing at an id that has moved.
		ok(not t.has("exclusive_with"),
			"%s carries no stale exclusive_with — rows do the barring" % id)
	ok(caps == 3, "three capstones (got %d)" % caps)
	for lane in by_lane:
		ok(by_lane[lane] == Talents.ROWS, "lane %s holds 8 rows (got %d)" % [lane, by_lane[lane]])
	# EVERY ID SURVIVES: §9's whole promise, and the reason no save moves.
	for id in IDS:
		ok(not _node(id).is_empty(), "id %s survives and re-specs in place" % id)
		# BATCH BM RE-POINTED THIS IN PLACE. `IDS` is THIS BATCH'S RECORD OF ITS OWN
	# 24 NODES and stays that; BM added a row-8 node to every lane, so the live
	# tree is 27. What the check exists to prove — that every one of the 24
	# SURVIVES, which is what lets a saved tree migrate — is the loop above and
	# is untouched. The count below allows exactly the three BM added.
	ok(seen.size() == IDS.size() + 3,
		"the 24 survive and BM added exactly 3 (tree %d, table %d)" % [seen.size(), IDS.size()])
	# One node per lane per row, or the picker's "choose one" band is a lie.
	var slots := {}
	for t in tree:
		var key := "%s:%d" % [t["lane"], int(t["row"])]
		ok(not slots.has(key), "one node in %s" % key)
		slots[key] = true
	# THE LANE NAMES AND THESES ALL STAND — nothing was renamed, unlike AS's
	# Shatterpoint or AT's Control.
	ok(String(_node("ss_steady")["lane"]) == "Precision"
		and String(_node("ss_piercer")["lane"]) == "Penetration"
		and String(_node("ss_fletcher")["lane"]) == "Tempo",
		"the three lane names are unchanged: Precision / Penetration / Tempo")


# ---------- §3 the magnitudes, final ----------

func _magnitudes() -> void:
	# PRECISION
	ok(abs(float(_stat_of("ss_steady", "crit_bonus")) - 0.15) < 0.001,
		"Steady Hands: +15% critical chance")
	ok(_stat_of("ss_perfect_form", "perfect_form") == 40,
		"Perfect Form: crits grant +40 Focus")
	ok(_stat_of("ss_deep_focus", "deep_focus") == 40,
		"Deep Focus: the conversion point drops 40 (100 -> 60)")
	ok(_stat_of("ss_exec_eye", "lethal_eye_ranks") == 50,
		"Executioner's Eye: +0.50 of critical multiplier (x2.5)")
	ok(_stat_of("ss_consistent", "consistent_aim") == 50,
		"Consistent Aim: -0.50 of critical multiplier — SUBTRACTED, not set")
	ok(abs(float(_stat_of("ss_consistent", "crit_bonus")) - 0.60) < 0.001,
		"...in exchange for +60% critical chance")
	ok(_stat_of("ss_unwavering", "unwavering") == 10,
		"Unwavering: +10 Focus per consecutive turn on one mark")
	ok(_stat_of("ss_tunnel", "tunnel_vision") == 100,
		"Tunnel Vision: +/-100% critical chance")
	# PENETRATION
	ok(abs(float(_stat_of("ss_piercer", "pierce_bonus")) - 0.30) < 0.001,
		"Armor Piercer: 30% of armor ignored")
	ok(_stat_of("ss_sundering", "sundering_shot") == 45,
		"Sundering Shot: 45 Break damage on a crit")
	ok(_stat_of("ss_bonecracker", "bonecracker_ranks") == 40,
		"Bonecracker: +40% against Broken enemies")
	ok(abs(float(_stat_of("ss_opp_aim", "opp_aim_step")) - 4.0) < 0.001,
		"Opportunist's Aim: +4 on Powershot's own 2%/point — a TRIPLING")
	ok(_stat_of("ss_exposed_nerve", "exposed_nerve") == 15,
		"Exposed Nerve: +15% against Exposed enemies (gate and magnitude in one)")
	ok(_stat_of("ss_no_cover", "no_cover") == 1,
		"No Cover is a BYPASS — a flag, with nothing to reprice")
	ok(_stat_of("ss_overkill", "overkill") == 1,
		"Overkill is a flag too — its second clause is a rule, not an amount")
	ok(String(_node("ss_overkill")["desc"]).to_lower().contains("keeps your focus in full"),
		"...and its text says the carry keeps the Focus whole")
	# TEMPO
	ok(abs(float(_stat_of("ss_fletcher", "speed")) - 18.0) < 0.001,
		"Fletcher's Speed: +18 Speed")
	ok(_stat_of("ss_snap", "snap_shot") == 2,
		"Snap Shot: the first TWO abilities are free")
	ok(_stat_of("ss_muscle", "muscle_memory_ranks") == 30,
		"Muscle Memory: +30 Focus per attack")
	ok(_stat_of("ss_volley", "opening_volley") == 150,
		"Opening Volley: he opens holding 150 — past the conversion point")
	ok(_stat_of("ss_follow", "follow_through") == 2,
		"Follow-Through: crits tick every cooldown by 2")
	ok(_stat_of("ss_second_nature", "second_nature") == 4,
		"Second Nature: the held breath covers FOUR attacks")
	ok(_stat_of("ss_spray", "spray") == 2,
		"Spray of Arrows: TWO additional enemies")
	# CAPSTONES
	ok(_stat_of("ss_one_shot", "one_shot") == 200,
		"One Shot: the threshold is 200 Focus, replacing 'at maximum Focus'")
	ok(_stat_of("ss_tnt", "through_and_through") == 1,
		"Through and Through is unchanged — a flag")
	ok(_stat_of("ss_rapid", "rapid_fire") == 50,
		"Rapid Fire: 50% of casts skip their cooldown, up from 35%")
	for cap_id in ["ss_one_shot", "ss_tnt", "ss_rapid"]:
		ok(bool(_node(cap_id).get("capstone", false)), "%s is a capstone" % cap_id)
	# NO NODE STILL DESCRIBES A CEILING §1 removed.
	for t in _tree():
		var d := String(t.get("desc", "")).to_lower()
		ok(not d.contains("focus cap"),
			"%s does not describe a Focus cap" % t["id"])
		ok(not d.contains("at maximum focus"),
			"%s does not say 'at maximum Focus'" % t["id"])
	# Every rendered tooltip must show the design value, not a stale one, and
	# a node with a `scale` must actually consume it.
	for id in IDS:
		var n := _node(id)
		if not n.has("scale"):
			continue
		var shown := Talents.desc_for(n, 1)
		ok(not shown.contains("{v}"), "%s renders its {v}" % id)
	ok(Talents.desc_for(_node("ss_deep_focus"), 1).contains("to 60"),
		"Deep Focus's tooltip renders the conversion point as 60")
	ok(Talents.desc_for(_node("ss_exec_eye"), 1).contains("x2.5"),
		"Executioner's Eye's tooltip renders x2.5")


# ---------- §6 the counters are ADDITIVE at their read sites ----------

func _additive_units() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# The magnitude lives in the payload; the read site applies no step.
	var pairs := {
		"0.01 * attacker.bonecracker_ranks": "Bonecracker",
		"0.01 * attacker.exposed_nerve": "Exposed Nerve",
		"0.01 * attacker.tunnel_vision": "Tunnel Vision",
		"0.01 * attacker.rapid_fire": "Rapid Fire",
		"2.0 + attacker.opp_aim_step": "Opportunist's Aim",
		"20 + attacker.muscle_memory_ranks": "Muscle Memory",
		"_gain_focus(attacker, attacker.perfect_form)": "Perfect Form",
		"take_hit(0, attacker.sundering_shot)": "Sundering Shot",
		# RE-POINTED IN PLACE BY BATCH BQ, and the question is unchanged: does
		# Follow-Through's counter reach the read site as the MAGNITUDE, with
		# no step applied on the way? BQ extracted the four hand-written
		# cooldown walks into one `_tick_cooldowns(u, turns, skip)`, so the
		# counter is now the `turns` ARGUMENT rather than a subtraction spelled
		# out inline. A step would have to appear in this call to break it,
		# which is exactly what this fragment still refuses.
		"_tick_cooldowns(attacker, attacker.follow_through)": "Follow-Through",
		"u.snap_shot > u.snap_used": "Snap Shot",
		"for _sp_i in attacker.spray:": "Spray of Arrows",
		"attacker.second_resource >= attacker.one_shot": "One Shot",
	}
	for frag in pairs:
		ok(src.contains(frag),
			"%s reads its counter additively (`%s`)" % [pairs[frag], frag])
	# The old ranked/flag forms must be GONE, or a magnitude silently changes.
	var dead := {
		"0.12 * attacker.bonecracker_ranks": "Bonecracker's per-rank step",
		"20 + 10 * attacker.muscle_memory_ranks": "Muscle Memory's per-rank step",
		"2.0 + 0.1 * attacker.lethal_eye_ranks": "Executioner's Eye's per-rank step",
		"4.0 if attacker.opp_aim > 0": "Opportunist's Aim as a flag",
		"attacker.rapid_fire > 0 and ab.cooldown > 0 and randf() < 0.35":
			"Rapid Fire's hard-coded 35%",
		"_focus_cap(attacker)": "One Shot reading a cap that no longer exists",
		"2 if attacker.second_nature > 0": "Second Nature's hard-coded 2",
	}
	for frag in dead:
		ok(not src.contains(frag), "the old form of %s is gone (`%s`)" % [dead[frag], frag])
	# `opp_aim_step` is a FLOAT and must stay OUT of STAT_INT_KEYS, or a rune
	# writing 4.0 would round with nothing crashing (AT's `conduit_step`,
	# AY's `wild_communion_step`). The three int magnitudes must stay IN it.
	ok(not Runes.STAT_INT_KEYS.has("opp_aim_step"),
		"opp_aim_step is NOT coerced to int — it is a float")
	for f in ["deep_focus", "perfect_form", "opening_volley"]:
		ok(Runes.STAT_INT_KEYS.has(f),
			"%s stays in STAT_INT_KEYS — an int magnitude needs it as much as a flag did" % f)
	var u := BattleUnit.new()
	ok(typeof(u.get("opp_aim_step")) == TYPE_FLOAT,
		"opp_aim_step is declared a float")
	ok(u.get("opp_aim") == null,
		"the old `opp_aim` flag is deleted, not left unreachable")
	ok(typeof(u.get("snap_used")) == TYPE_INT,
		"snap_used counts rather than flags")
	ok(typeof(u.get("same_target_turns")) == TYPE_INT,
		"the Unwavering streak has its own counter")
	u.free()


# ---------- §1 the conversion, as pure math on BattleUnit ----------

func _conversion_math() -> void:
	var u := BattleUnit.new()
	u.second_resource_name = "Focus"
	ok(BattleUnit.FOCUS_CONVERT == 100, "the conversion point is a fixed 100")
	ok(abs(BattleUnit.FOCUS_STEP - 0.005) < 0.0001,
		"one point of Focus buys 0.5%, either side of the split")
	# THE TABLE §1 NAMES: chance stops at the split, the multiplier takes over.
	for row in [[0, 0.0, 2.0], [50, 0.25, 2.0], [100, 0.50, 2.0],
			[200, 0.50, 2.5], [300, 0.50, 3.0], [400, 0.50, 3.5]]:
		u.second_resource = int(row[0])
		ok(abs(u.focus_crit_chance() - float(row[1])) < 0.0001,
			"%d Focus buys +%.0f%% critical CHANCE" % [int(row[0]), float(row[1]) * 100.0])
		ok(abs(u.lethal_crit_mult() - float(row[2])) < 0.0001,
			"%d Focus reads a multiplier of x%.1f (got x%.2f)" % [
				int(row[0]), float(row[2]), u.lethal_crit_mult()])
	# DEEP FOCUS MOVES THE SPLIT TO 60 — and it is a DROP, so the rune adds.
	u.deep_focus = 40
	ok(u.focus_convert() == 60, "Deep Focus moves the conversion point to 60")
	u.second_resource = 100
	ok(abs(u.focus_crit_chance() - 0.30) < 0.0001,
		"...so 100 Focus buys only +30% chance under it")
	ok(abs(u.lethal_crit_mult() - 2.20) < 0.0001,
		"...and the other 40 points are already force (x2.2)")
	u.deep_focus = 48  # node 40 + the Rune of the Deep Sight's 8
	ok(u.focus_convert() == 52,
		"node and rune SUM: 40 + 8 drops the split to 52")
	u.deep_focus = 500
	ok(u.focus_convert() == 1,
		"the conversion point is floored at 1 — it can never reach zero")
	u.free()
	_report.append("CONVERSION: 100 Focus = +50% chance / x2.0; 200 = x2.5; 300 = x3.0; 400 = x3.5")


# ---------- §5 the trophy-pool collision cannot arise ----------

func _no_ability_grants() -> void:
	# AU §1's rule runs BOTH ways: a tree node granting an owned ability falls
	# back, and a boss offering a tree-granted one is filtered. HIS TREE GRANTS
	# NOTHING — Aimed Shot, Powershot and Hold Breath are base kit, and Quick
	# Draw / Triple Shot / Coup de Grace / Pinning Shot / Called Shot are all
	# boss-trophy pool. So the collision cannot arise, and this RECORDS it
	# rather than leaving a reader to wonder whether his shelf was skipped.
	for t in _tree():
		var p: Dictionary = t.get("payload", {})
		ok(not p.has("grant_ability"), "%s grants no ability" % t["id"])
		ok(not p.has("new_ability"), "%s introduces no new ability" % t["id"])
		ok(not p.has("upgrade"),
			"%s owes no authored fallback (it grants nothing to collide)" % t["id"])
	# The other half: every trophy the pool offers him is absent from the tree.
	var tree_names := Talents.ability_names({"spec": "sharpshooter",
		"key": "hunter", "talents": _learn_all()})
	for trophy in Classes.SPEC_POOLS["sharpshooter"]:
		ok(not tree_names.has(trophy),
			"the trophy %s is not also a tree grant" % trophy)
	# ...and the tree ADDS nothing to the list the action bar builds: fully
	# learned, it names exactly what an unlearned one does.
	var bare := Talents.ability_names({"spec": "sharpshooter", "key": "hunter",
		"talents": {}})
	ok(tree_names.size() == bare.size(),
		"a fully-learned tree adds NO ability to the bar (%d vs %d)" % [
			tree_names.size(), bare.size()])
	for n in tree_names:
		ok(bare.has(n), "%s comes from the kit, not from a node" % n)


func _learn_all() -> Dictionary:
	var all := {}
	for id in IDS:
		all[id] = 1
	return all


# ---------- §6 the rune audit ----------

func _rune_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var pool := {}
	for rid in Runes.ids():
		pool[rid] = Runes.config(rid)
	var ss_runes := ["deep_sight", "narrow_gap", "long_draw", "level_aim"]
	for id in ss_runes:
		ok(pool.has(id), "the rune %s is still in the pool" % id)
		var stats: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in stats:
			# Every counter a rune writes must have a LIVE read site, or a later
			# batch that retires a node has to say so out loud (the AW rule).
			ok(src.contains(f) or usrc.contains(f) or f == "speed",
				"the rune %s writes %s, which is still read" % [id, f])
	# THE DEEP SIGHT IS THE ONE THAT COULD NOT PAY WHAT IT PAID (the AY Deep
	# Bond / AX Hollow Chalice situation): "Focus climbs to 150" has no
	# equivalent value once there is no ceiling. RE-POINTED, NOT DELETED — it
	# keeps the RELATIONSHIP, at a fifth of the node, exactly AY's ratio.
	var deep: Dictionary = pool["deep_sight"]["payload"]["stat"]
	ok(int(deep["deep_focus"]) == 8,
		"the Deep Sight drops the conversion point 8 — a fifth of Deep Focus's 40")
	ok(int(deep["perfect_form"]) == 20,
		"...and its second clause is untouched: crits still grant +20 Focus")
	ok(not String(pool["deep_sight"]["desc"]).contains("150"),
		"...and its desc was rewritten to the new units rather than left lying")
	var narrow: Dictionary = pool["narrow_gap"]["payload"]["stat"]
	ok(abs(float(narrow["pierce_bonus"]) - 0.08) < 0.001,
		"the Narrow Gap still ignores 8% more armor")
	ok(int(narrow["bonecracker_ranks"]) == 12,
		"...and still bites 12% deeper into Broken enemies (1 rank x 12 -> 12)")
	var draw: Dictionary = pool["long_draw"]["payload"]["stat"]
	ok(int(draw["opening_volley"]) == 60,
		"the Long Draw still opens him on 60 Focus")
	ok(int(draw["muscle_memory_ranks"]) == 10,
		"...and still gathers 10 more per attack (1 rank x 10 -> 10)")
	ok(abs(float(draw["speed"]) + 10.0) < 0.001 and bool(pool["long_draw"].get("scarred", false)),
		"...and it is still SCARRED — the -10 Speed survives")
	var level: Dictionary = pool["level_aim"]["payload"]["stat"]
	ok(abs(float(level["pierce_bonus"]) - 0.04) < 0.001
		and int(level["muscle_memory_ranks"]) == 10
		and int(level["bonecracker_ranks"]) == 12,
		"the Level Aim still pays 4% armor, +10 Focus and +12% vs Broken")
	# THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO SHARPSHOOTER COUNTER.
	var ss_fields := {}
	for t in _tree():
		for f in t.get("payload", {}).get("stat", {}):
			ss_fields[f] = true
	for id in pool:
		if String(pool[id].get("scope", "")) != "class:hunter":
			continue
		for f in pool[id].get("payload", {}).get("stat", {}):
			ok(not ss_fields.has(f),
				"the class-wide rune %s does not write the Sharpshooter counter %s" % [id, f])
	# No lane tag went stale: his lanes did not rename (the AS Honed Lance
	# lesson, checked even though nothing moved).
	var lanes := {"Precision": true, "Penetration": true, "Tempo": true}
	for id in ss_runes:
		var lane := String(pool[id].get("lane", ""))
		ok(lane == "" or lanes.has(lane),
			"the rune %s carries a live lane tag (%s)" % [id, lane])


# ---------- §7 the bot's rules, at the source ----------

func _bot_policy_source() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("func _focus_mark"),
		"BOT: the marksman's target is decided in ONE place")
	ok(src.contains("target_foe = _focus_mark(u, target_foe)"),
		"BOT: ...and it is applied at the TOP of the hunter branch, so every pick inherits it")
	ok(src.contains("u.second_resource >= COUP_FOCUS_CAP"),
		"BOT: Coup waits for the reading cap, not for 80")
	ok(not src.contains("u.second_resource >= 80"),
		"BOT: the old 80-Focus threshold is gone")
	# The mark must be chosen BEFORE any pick that points at an enemy, or a
	# class-pool ability quietly switches him off the meter he is made of.
	var hunter_at := src.find("\t\t\"hunter\":")
	var mark_at := src.find("target_foe = _focus_mark(u, target_foe)", hunter_at)
	var first_pick := src.find("var snare := _find_ability(u, \"Snare Trap\")", hunter_at)
	ok(hunter_at > 0 and mark_at > hunter_at and mark_at < first_pick,
		"BOT: the mark is decided before any enemy-pointed pick in the branch")


# ---------- §4 the exclusive pairs ----------

func _exclusive_pairs() -> void:
	# EXECUTIONER'S EYE <-> CONSISTENT AIM IS DEAD. Batch 32 authored it as a
	# fork; Batch AI's row exclusivity destroyed it — rows 4 and 5 of ONE lane,
	# so a player holds both. §3's `-0.5` rewording is what makes that coherent.
	ok(int(_node("ss_exec_eye")["row"]) == 4
		and String(_node("ss_exec_eye")["lane"]) == "Precision",
		"Executioner's Eye sits in Precision row 4")
	ok(int(_node("ss_consistent")["row"]) == 5
		and String(_node("ss_consistent")["lane"]) == "Precision",
		"Consistent Aim sits in Precision row 5 — a player can hold both")
	# TUNNEL VISION <-> SPRAY OF ARROWS SURVIVES, and it survives because ROW
	# EXCLUSIVITY enforces it: both sit in row 7. Stated so a later batch does
	# not "fix" a pair already being enforced correctly.
	ok(int(_node("ss_tunnel")["row"]) == 7 and int(_node("ss_spray")["row"]) == 7,
		"Tunnel Vision and Spray of Arrows share row 7 — the pair is enforced by the row")
	ok(String(_node("ss_tunnel")["lane"]) != String(_node("ss_spray")["lane"]),
		"...and they are in different lanes, which is what makes the row bar them")
	# ...and no prose list still claims the dissolved one.
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not claude.contains("ss_exec_eye↔"),
		"CLAUDE.md's exclusive-pair prose no longer lists ss_exec_eye as a fork")


# ---------- §8 the documentation agrees with the code ----------

func _docs() -> void:
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	ok(not doc.contains("cap rises from 100 to 150"),
		"master.html no longer documents the Focus cap Deep Focus used to raise")
	ok(not doc.contains("0&ndash;100 as Sharpshooter"),
		"master.html no longer calls Focus a 0-100 meter")
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(gloss.contains("no ceiling") or gloss.contains("NO ceiling"),
		"the glossary's Focus entry says the meter has no ceiling")
	ok(not gloss.contains("base cap 100"),
		"...and no longer names a base cap of 100")
	# The passive the player reads on the awakening screen and the hero sheet.
	var pd := String(Classes.SPEC_INFO["sharpshooter"]["passive_desc"])
	ok(pd.contains("NO CEILING"), "the in-game passive text says Focus has no ceiling")
	ok(pd.contains("CRITICAL MULTIPLIER"),
		"...and names the converted half by what it buys")


# ---------- NEGATIVE CONTROLS, at the source ----------

func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	# (1) Focus past the split still buying CHANCE — the whole of §1 undone,
	# and it would look exactly like the old code working.
	ok(not bsrc.contains("crit_chance += attacker.second_resource * 0.005"),
		"NEGATIVE CONTROL: no path buys chance off the RAW Focus count")
	ok(bsrc.contains("crit_chance += attacker.focus_crit_chance()"),
		"NEGATIVE CONTROL: the chance half reads the SPLIT, in one place")
	# (2) Consistent Aim SETTING the multiplier instead of subtracting — it
	# reads identically alone and only diverges in the build §4 legalised.
	ok(not bsrc.contains("1.5 if attacker.consistent_aim > 0"),
		"NEGATIVE CONTROL: Consistent Aim no longer SETS the multiplier")
	ok(usrc.contains("2.0 + 0.01 * (lethal_eye_ranks - consistent_aim)"),
		"NEGATIVE CONTROL: it SUBTRACTS points, so the two nodes compose")
	# (3) Unwavering surviving a target switch — the node's old job, and the
	# one this batch exists to take away from it.
	ok(not bsrc.contains("if attacker.unwavering > 0 else 0"),
		"NEGATIVE CONTROL: nothing halves Focus on a switch any more")
	ok(bsrc.contains("attacker.same_target_turns += 1"),
		"NEGATIVE CONTROL: Unwavering counts consecutive turns instead")
	# (4) Coup reading the WHOLE meter.
	ok(bsrc.contains("var cdg := mini(cdg_held, COUP_FOCUS_CAP)"),
		"NEGATIVE CONTROL: Coup's reading is capped where the spend is not")
	# (5) The ceiling must be a SENTINEL, not a big number a batch can reach.
	ok(bsrc.contains("const FOCUS_UNCAPPED := -1"),
		"NEGATIVE CONTROL: 'no cap' is a sentinel, not a large ceiling")
	ok(bsrc.contains("if u.spray > 0:\n\t\treturn 50"),
		"NEGATIVE CONTROL: exactly one node still hands _focus_cap a number")


# ---------- §1 live: the meter has no ceiling ----------

func _live_uncapped() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	ok(h != null and h.passive_id == "lethal_aim", "the Sharpshooter spawned")
	ok(h.second_resource_name == "Focus", "...on Focus")
	ok(scene.call("_focus_cap", h) == scene.get("FOCUS_UNCAPPED"),
		"a plain Sharpshooter has NO Focus ceiling")
	ok(h.second_max < 0, "...and the nameplate is told so by the sentinel")
	for _i in 40:
		scene.call("_gain_focus", h, 20)
	ok(h.second_resource >= 800,
		"forty gains reach %d Focus — nothing capped it" % h.second_resource)
	# §0's new number is banked at the gain site.
	ok(int(scene.get("sim_stats").get("focus_deepest", 0)) >= 800,
		"the deepest-Focus instrument banked it (%d)" % \
			int(scene.get("sim_stats").get("focus_deepest", 0)))
	ok(float(scene.get("sim_stats").get("focus_deepest_mult", 0.0)) > 5.0,
		"...with the multiplier it was paying there (x%.2f)" % \
			float(scene.get("sim_stats").get("focus_deepest_mult", 0.0)))
	ok(String(scene.call("focus_report_line", scene.get("sim_stats"))).begins_with(
			"Focus: deepest reached"),
		"...and the shared report line prints it")
	ok(String(scene.call("focus_report_line", {})) == "",
		"...and prints NOTHING when no Sharpshooter stood")
	await _kill(scene)


# ---------- §1 live: the conversion, at the damage site ----------

func _live_conversion() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	var aimed: Ability = scene.call("_find_ability", h, "Aimed Shot")
	ok(aimed != null, "Aimed Shot is in the opening kit")
	# At 100 Focus the chance is +50% and the multiplier is still x2.
	h.second_resource = 100
	ok(abs(h.focus_crit_chance() - 0.50) < 0.0001
		and abs(h.lethal_crit_mult() - 2.0) < 0.0001,
		"LIVE: 100 Focus is +50% chance at x2.0")
	# Drive a real crit at 300 Focus and read the damage back. Crit is FORCED
	# through Hold Breath's guarantee rather than by hoping for the roll — the
	# AR discipline: force determinism, never retry until it passes.
	h.second_resource = 300
	ok(abs(h.lethal_crit_mult() - 3.0) < 0.0001,
		"LIVE: 300 Focus reads x3.0 at the same site the damage block uses")
	h.attack = 100.0
	foe.armor = 0.0
	foe.resists = {}
	foe.max_hp = 100000
	foe.hp = 100000
	var before := foe.hp
	scene.call("_apply_status", h, "held_breath", -1)
	h.update_status("held_breath", "HB1", "", 1)
	await scene._resolve(h, aimed, foe, "good")
	var dealt := before - foe.hp
	# 45% of 100 Attack, x3.0, with the 0.9-1.1 spread: 121-149.
	ok(dealt >= 110 and dealt <= 160,
		"LIVE: a crit at 300 Focus lands %d — the x3.0 multiplier is real" % dealt)
	_report.append("LIVE CRIT at 300 Focus: %d damage off a 45%%-of-100 shot (x3.0)" % dealt)
	await _kill(scene)


# ---------- §3 live: Deep Focus moves the split ----------

func _live_deep_focus() -> void:
	var scene := await _spawn({"ss_deep_focus": 1})
	var h := _hero(scene, 3)
	ok(h.deep_focus == 40, "Deep Focus applied from the tree (got %d)" % h.deep_focus)
	ok(h.focus_convert() == 60, "LIVE: the conversion point is 60")
	h.second_resource = 60
	ok(abs(h.focus_crit_chance() - 0.30) < 0.0001,
		"LIVE: the chance half tops out at +30% under it")
	h.second_resource = 260
	ok(abs(h.lethal_crit_mult() - 3.0) < 0.0001,
		"LIVE: and 260 Focus already reads x3.0 — 40 sooner than without it")
	await _kill(scene)


# ---------- §4 live: the dissolved pair resolves to x2.0 ----------

func _live_crit_mult_pair() -> void:
	var scene := await _spawn({"ss_exec_eye": 1, "ss_consistent": 1})
	var h := _hero(scene, 3)
	ok(h.lethal_eye_ranks == 50 and h.consistent_aim == 50,
		"both halves of the dissolved fork applied")
	ok(abs(h.lethal_crit_mult() - 2.0) < 0.0001,
		"LIVE: Executioner's Eye + Consistent Aim resolve to x2.0 (got x%.2f)" % \
			h.lethal_crit_mult())
	ok(h.crit_bonus >= 0.59,
		"...and he keeps Consistent Aim's +60%% chance (got %.2f)" % h.crit_bonus)
	await _kill(scene)
	# Each alone, so the composition is proven rather than inferred.
	var s2 := await _spawn({"ss_consistent": 1})
	var h2 := _hero(s2, 3)
	ok(abs(h2.lethal_crit_mult() - 1.5) < 0.0001,
		"LIVE: Consistent Aim ALONE is x1.5 (got x%.2f)" % h2.lethal_crit_mult())
	await _kill(s2)
	var s3 := await _spawn({"ss_exec_eye": 1})
	var h3 := _hero(s3, 3)
	ok(abs(h3.lethal_crit_mult() - 2.5) < 0.0001,
		"LIVE: Executioner's Eye ALONE is x2.5 (got x%.2f)" % h3.lethal_crit_mult())
	await _kill(s3)


# ---------- §2 live: Unwavering's ramp, and its reset ----------

func _live_unwavering_ramp() -> void:
	var scene := await _spawn({"ss_unwavering": 1}, ["raider", "raider"])
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	ok(h.unwavering == 10, "Unwavering applied (got %d)" % h.unwavering)
	# Turn 1 on a fresh mark: the engine only records the target, no gain.
	scene.call("_sharpshooter_focus", h, foes[0])
	ok(h.second_resource == 0, "the first shot at a new mark grants nothing")
	# Then the ramp: 20 + 10, 20 + 20, ... capped at 20 + 50.
	var expected := [30, 40, 50, 60, 70, 70, 70]
	var running := 0
	for i in expected.size():
		scene.call("_sharpshooter_focus", h, foes[0])
		running += int(expected[i])
		ok(h.second_resource == running,
			"consecutive turn %d grants %d (meter %d, expected %d)" % [
				i + 1, int(expected[i]), h.second_resource, running])
	ok(h.same_target_turns >= 5, "the streak counter reached its cap")
	# THE RESET: a switch clears the meter AND the ramp, so the next return to
	# a mark starts from +10 again.
	scene.call("_sharpshooter_focus", h, foes[1])
	ok(h.second_resource == 0, "switching CLEARS the meter — it is never halved")
	ok(h.same_target_turns == 0, "...and resets the ramp")
	scene.call("_sharpshooter_focus", h, foes[1])
	ok(h.second_resource == 30, "...so the ramp restarts at +10 (30 total)")
	_report.append("UNWAVERING: 30/40/50/60/70/70 on consecutive turns, reset by a switch")
	await _kill(scene)


# ---------- §3 live: Overkill's carry keeps the Focus whole ----------

func _live_overkill_keeps_focus() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	h.second_resource = 300
	foes[0].dead = true
	scene.call("_sharpshooter_focus", h, foes[0])
	ok(h.second_resource == 50,
		"WITHOUT Overkill a kill banks 50 of the meter (got %d)" % h.second_resource)
	await _kill(scene)
	var s2 := await _spawn({"ss_overkill": 1})
	var h2 := _hero(s2, 3)
	var f2: Array = s2.get("enemies")
	ok(h2.overkill == 1, "Overkill applied")
	h2.second_resource = 300
	f2[0].dead = true
	s2.call("_sharpshooter_focus", h2, f2[0])
	ok(h2.second_resource == 300,
		"WITH Overkill the chain keeps all 300 (got %d)" % h2.second_resource)
	await _kill(s2)


# ---------- §1 live: Coup reads at most 200 ----------

func _live_coup_cap() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	var coup: Ability = Classes.spec_pool_ability("sharpshooter", "Coup de Grâce")
	ok(coup != null, "Coup de Grâce resolves out of the trophy pool")
	h.abilities = h.abilities + [coup]
	h.attack = 100.0
	h.resource = 100
	foe.armor = 0.0
	foe.resists = {}
	# The target must hold MORE than an uncapped read would deal, or take_hit
	# clamps the damage to its remaining health and the two readings look
	# identical — the check would pass whatever the code did. 100,000 missing
	# means 1% a point is 1,000 a point: a 200-point read is ~200,000 and an
	# uncapped 400-point one ~400,000, both under the 900,000 it is holding.
	foe.max_hp = 1000000
	foe.hp = 900000
	ok(scene.get("COUP_FOCUS_CAP") == 200, "the reading cap is 200")
	h.second_resource = 400
	var before := foe.hp
	await scene._resolve(h, coup, foe, "good")
	var dealt := before - foe.hp
	ok(h.second_resource == 0, "it still CONSUMES ALL FOCUS")
	ok(dealt < 300000,
		"LIVE: 400 Focus is read as 200 — %d damage, not the ~400,000 an uncapped read gives" % dealt)
	ok(dealt > 150000, "...and it really did read 200 of it (%d)" % dealt)
	_report.append("COUP AT 400 FOCUS: %d damage on 100,000 missing health — a 200-point reading, not 400" % dealt)
	await _kill(scene)


# ---------- §3 live: One Shot fires at 200 and resets ----------

func _live_one_shot() -> void:
	var scene := await _spawn({"ss_one_shot": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	var aimed: Ability = scene.call("_find_ability", h, "Aimed Shot")
	ok(h.one_shot == 200, "One Shot's threshold applied as 200 (got %d)" % h.one_shot)
	h.attack = 100.0
	h.resource = 100
	foe.armor = 0.0
	foe.resists = {}
	foe.max_hp = 1000
	foe.hp = 900              # 90% — above the execute line, so it DOUBLES
	# Under the threshold: nothing happens, and the meter is not spent.
	h.second_resource = 199
	await scene._resolve(h, aimed, foe, "good")
	ok(h.second_resource == 199,
		"at 199 Focus One Shot does not fire and spends nothing")
	# At the threshold: it fires, and the meter resets either way.
	h.second_resource = 250
	foe.hp = 900
	var before := foe.hp
	await scene._resolve(h, aimed, foe, "good")
	# It resets to 0 INSIDE the damage block, and the Focus engine then runs
	# after the strike and pays the usual +20 for working the same mark — so
	# the honest post-condition is 20, not 0. Anything near 250 means the
	# capstone never fired.
	ok(h.second_resource == 20,
		"at 250 Focus it FIRES and resets the meter (20 is the engine's next gain, got %d)" % \
			h.second_resource)
	ok(before - foe.hp > 60,
		"...and the shot doubled (%d damage off a 45%%-of-100 base)" % (before - foe.hp))
	# The execute half, on a non-boss under 35%.
	h.second_resource = 200
	foe.hp = 200              # 20%
	await scene._resolve(h, aimed, foe, "good")
	ok(foe.dead or foe.hp <= 0, "LIVE: One Shot EXECUTES a non-boss under 35%")
	await _kill(scene)


# ---------- §3 live: Opening Volley opens past the split ----------

func _live_opening_volley() -> void:
	var scene := await _spawn({"ss_volley": 1})
	var h := _hero(scene, 3)
	ok(h.second_resource == 150,
		"Opening Volley opens the fight on 150 Focus (got %d)" % h.second_resource)
	ok(h.second_resource > h.focus_convert(),
		"...which is PAST the conversion point — he arrives already converting")
	ok(abs(h.lethal_crit_mult() - 2.25) < 0.0001,
		"...reading x2.25 on turn one (got x%.2f)" % h.lethal_crit_mult())
	await _kill(scene)


# ---------- §3 live: Spray of Arrows is the one remaining ceiling ----------

func _live_spray_cap() -> void:
	var scene := await _spawn({"ss_spray": 1})
	var h := _hero(scene, 3)
	ok(h.spray == 2, "Spray of Arrows applied as TWO extra enemies")
	ok(scene.call("_focus_cap", h) == 50,
		"LIVE: Spray of Arrows is the one node that still caps Focus, at 50")
	ok(h.second_max == 50, "...and the nameplate reads against that cap")
	scene.call("_gain_focus", h, 400)
	ok(h.second_resource == 50,
		"...and the meter really stops there (got %d)" % h.second_resource)
	await _kill(scene)
