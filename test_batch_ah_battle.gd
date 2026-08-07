# Batch AH in a LIVE battle. The data harness (test_batch_ah.gd) proves the
# pools and the map are well formed; this proves the three things only a
# spawned battle can show:
#   1. an earned ability actually reaches the hero's kit — including one
#      taken from another spec of the same class — and a talent that
#      MODIFIES it still finds it (the spawn-ordering fix);
#   2. the action bar hands slots 10+ their Shift hotkeys;
#   3. the two Perfect conversions that buy their way past a rule really do
#      (the boss Stun immunity), and the mini-boss really wears boss health.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ah_battle.gd
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


func _initialize() -> void:
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
	Profile.save_path = "user://profile_batch_ah_test.json"
	Profile.loaded = false
	Profile.data = {}

	await _test_earned_kit()
	await _test_action_bar()
	await _test_boss_stun()
	await _test_miniboss_health()
	await _test_party_sheet()
	await _test_save_round_trip()
	await _test_owed_badges()
	await _test_deadfall_aim()

	if FileAccess.file_exists("user://profile_batch_ah_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ah_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("test_batch_ah_battle: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# Arms a run with the given specs and spawns one battle scene. Returns the
# scene; the caller frees it.
func _spawn(specs: Array, lineup: Array, node_type := "fight",
		prep := Callable()) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	if prep.is_valid():
		prep.call(run)
	run.encounter = {"type": node_type, "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 12:
		await process_frame
	return scene


func _hero(scene: Node, spec_passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == spec_passive:
			return h
	return null


func _names(u: BattleUnit) -> Array:
	var out: Array = []
	for a in u.abilities:
		out.append(a.display_name)
	return out


# ---------- 1. earned abilities reach the kit ----------

func _test_earned_kit() -> void:
	# The Berserker earns Battle Shout (its OWN pool) and Crushing Blow (the
	# Warden's kit, via the warrior class pool), and buys the Battle Shout
	# TALENT NODE. If the pool copy went on AFTER the tree, the node would
	# not see it and would grant a second copy instead of upgrading.
	#
	# BATCH AJ re-pointed this probe IN PLACE. It used to buy Deafening Cry
	# and check that the -1 cooldown found the pool-bought Shout; AJ
	# re-specced that node into Overkill (it existed only to modify a node
	# in its own exclusive row), so the probe now rides bz_battle_shout's
	# own upgrade path. It is the SAME question — did the tree run against a
	# kit that already held the earned copy — asked of the mechanism that is
	# actually load-bearing today.
	var shout_id := ""
	var tree: Array = Talents.generate_tree("berserker", "warrior")
	for node in tree:
		var np: Dictionary = node.get("payload", {})
		if np.has("new_ability") \
				and String(np["new_ability"]["display_name"]) == "Battle Shout":
			shout_id = String(node["id"])
	ok(shout_id != "", "the Berserker tree still holds the Battle Shout node")
	var prep := func(run):
		run.party[0]["bm_abilities"] = ["Battle Shout", "Crushing Blow"]
		run.party[0]["talents"] = {shout_id: 1}
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		["raider", "archer", "raider"], "fight", prep)
	var bz := _hero(scene, "bloodrage")
	ok(bz != null, "the Berserker spawned")
	if bz != null:
		var names := _names(bz)
		ok(names.has("Battle Shout"), "an earned SPEC-pool ability is in the kit")
		ok(names.has("Crushing Blow"), "an earned CLASS-pool ability is in the kit")
		ok(names.count("Battle Shout") == 1, "and it is not double-granted")
		# THE ORDERING PROOF: the index reads 2 only if the node found the
		# pool copy already in the kit. A 1 means the tree ran first and
		# granted its own — the exact regression this ordering fix exists
		# to prevent.
		ok(int(bz.battle_shout_node) == 2,
			"the Battle Shout node UPGRADED the POOL-bought copy (index %d, want 2)" % [
				bz.battle_shout_node])
		for a in bz.abilities:
			if a.display_name == "Battle Shout":
				ok(String(a.description).contains("18%"),
					"...and the kit carries the upgraded description")
		# The trimmed three are gone unless earned.
		ok(not names.has("Blood Price"),
			"a trimmed ability stays out of the kit until it is earned")
		ok(names.size() == 1 + 3 + 2,
			"core + 3 spec + 2 earned = %d abilities (got %d)" % [6, names.size()])
	scene.free()


# ---------- 2. the action bar past nine ----------

func _test_action_bar() -> void:
	# A Berserker holding eight abilities it does NOT already start with —
	# two past the six a run can actually award, so the Shift bindings are
	# stressed rather than merely touched. (A real run tops out at
	# core + 3 + 6 = 10, which is exactly one Shift slot: ⇧Q.)
	var starting: Array = []
	for a in Classes.spec_abilities("berserker"):
		starting.append(a.display_name)
	var earned: Array = []
	for n in Classes.class_pool("warrior"):
		if earned.size() < 8 and not starting.has(n):
			earned.append(n)
	ok(earned.size() == 8, "the warrior class pool can supply 8 new abilities")
	var prep := func(run):
		run.party[0]["bm_abilities"] = earned
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		["raider", "archer", "raider"], "fight", prep)
	var bz := _hero(scene, "bloodrage")
	ok(bz != null, "the Berserker spawned")
	if bz != null:
		ok(bz.abilities.size() >= 10,
			"the hero holds %d abilities, no cap in sight" % bz.abilities.size())
		scene._show_actions(bz)
		var entries: Array = scene.get("_menu_entries")
		ok(entries.size() == bz.abilities.size(),
			"every ability got a menu slot (%d of %d)" % [
				entries.size(), bz.abilities.size()])
		ok(entries.size() > 9, "and the list runs past the nine plain keys")
		# Slot 10 is Shift+Q, and every slot up to 18 has a key.
		ok(scene._hotkey_name(9) == "⇧Q", "slot 10 is Shift+Q in a live bar")
		for i in mini(entries.size(), 18):
			ok(scene._hotkey_name(i) != "",
				"menu slot %d has a hotkey" % (i + 1))
	scene.free()


# ---------- 3. the two perfects that buy past the boss immunity ----------

func _test_boss_stun() -> void:
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["withered_warden", "raider"], "boss")
	var boss: BattleUnit = null
	for e in scene.get("enemies"):
		if e.is_boss:
			boss = e
	ok(boss != null, "a boss is on the field")
	if boss != null:
		ok(not boss.broken, "and it is unbroken")
		# The rule, unchanged: an ordinary Stun bounces.
		scene._apply_status(boss, "stunned", 1)
		ok(not boss.has_status("stunned"),
			"an unbroken boss still shrugs off an ordinary Stun")
		# The Batch AH perfects, and ONLY them, get through.
		scene._apply_status(boss, "stunned", 1, 0, 0, null, true)
		ok(boss.has_status("stunned"), "a forced Stun lands on an unbroken boss")
		boss.remove_status("stunned")
		# Snare Trap's perfect routes through _spring_trap.
		var sv := _hero(scene, "trapper")
		ok(sv != null, "the Survivalist spawned")
		if sv != null:
			scene._spring_trap(sv, boss, 0.0, false)
			ok(not boss.has_status("stunned"),
				"an ordinary snare does not hold a boss")
			scene._spring_trap(sv, boss, 0.0, true)
			ok(boss.has_status("stunned"),
				"a PERFECTLY rigged snare holds an unbroken boss")
			boss.remove_status("stunned")
		# The other immune ids are untouched by the new argument's default.
		scene._apply_status(boss, "frozen", 2)
		ok(not boss.has_status("frozen"),
			"Freeze immunity is unchanged (the flag defaults off)")
	scene.free()


# ---------- 4. the mini-boss wears boss health ----------

func _test_miniboss_health() -> void:
	var lineup := ["chief", "raider", "archer"]
	var elite := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		lineup, "elite")
	var elite_hp := {}
	for e in elite.get("enemies"):
		elite_hp[e.unit_name] = e.max_hp
	elite.free()
	var mb := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		lineup, "miniboss")
	var mult: float = load("res://scripts/battle.gd").MINIBOSS_HP_MULT
	var compared := 0
	for e in mb.get("enemies"):
		if not elite_hp.has(e.unit_name):
			continue
		compared += 1
		var want: int = int(ceil(float(elite_hp[e.unit_name]) * mult / 10.0) * 10.0)
		# Rounding to tens is applied once over the combined multiplier, so
		# allow the one-step slack that introduces.
		ok(absi(e.max_hp - want) <= 10,
			"%s carries a boss-tier pool at the mini-boss (%d vs elite %d, want ~%d)" % [
				e.unit_name, e.max_hp, elite_hp[e.unit_name], want])
		ok(e.max_hp > elite_hp[e.unit_name],
			"%s is tougher than its elite self" % e.unit_name)
	ok(compared == lineup.size(), "compared every enemy in the lineup")
	# Attack is NOT touched — "elite stats with a boss-tier health pool".
	mb.free()


# ---------- 5. the Party sheet shows what the hero actually holds ----------

func _test_party_sheet() -> void:
	# Six of a full kit's ten abilities are EARNED, so a sheet that only
	# reads the spec kit would be showing a hero the player does not have.
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var chosen := ["berserker", "cryomancer", "holy", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = chosen[i]
		run.party[i]["tree"] = Talents.generate_tree(chosen[i], run.party[i]["key"])
		run.sync_spec_hp(i)
	run.party[0]["bm_abilities"] = ["Blood Price", "Crushing Blow", "Rallying Shout"]
	run.specs_chosen = true
	run.active = true
	var scene: Node = load("res://scenes/party.tscn").instantiate()
	root.add_child(scene)
	for _i in 8:
		await process_frame
	# The screen opens on the hero LIST (Batch AE); the sheet is one click in.
	scene.selected = 0
	scene._draw_screen()
	for _i in 8:
		await process_frame
	var found := {"Blood Price": false, "Crushing Blow": false, "Rallying Shout": false}
	var walk: Array = [scene]
	while not walk.is_empty():
		var n: Node = walk.pop_back()
		for c in n.get_children():
			walk.append(c)
		if n is Label or n is Button:
			var txt := String(n.get("text"))
			for name in found:
				if txt.contains(name):
					found[name] = true
	for name in found:
		ok(found[name], "the Party sheet shows the earned %s" % name)
	scene.free()


# ---------- 6. the offer survives a save/load round trip ----------

func _test_save_round_trip() -> void:
	# bm_candidates rides inside the party dict, so the save stays v5 with no
	# migration — but "it should" is not a test.
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var chosen := ["berserker", "cryomancer", "holy", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = chosen[i]
		run.party[i]["tree"] = Talents.generate_tree(chosen[i], run.party[i]["key"])
	run.specs_chosen = true
	ok(run.award_ability_pick(run.party[0]), "an award was queued")
	var before: Array = (run.party[0]["bm_candidates"][0] as Array).duplicate()
	run.save_run()
	run.party = []
	ok(run.load_run(), "the run loads back")
	var after: Array = run.party[0].get("bm_candidates", [])
	ok(after.size() == 1, "the queued triple survived the save")
	if after.size() == 1:
		ok((after[0] as Array) == before,
			"...with the same three names in the same order")
	ok(int(run.party[0].get("bm_picks_owed", 0)) == 1, "and the pick is still owed")

	# A run saved BEFORE this batch owes picks with no triple behind them.
	# The Party screen has to roll one rather than dead-end.
	run.party[0]["bm_candidates"] = []
	run.party[0]["bm_picks_owed"] = 1
	run.active = true
	var scene: Node = load("res://scenes/party.tscn").instantiate()
	root.add_child(scene)
	for _i in 6:
		await process_frame
	scene.selected = 0
	scene._draw_screen()
	for _i in 6:
		await process_frame
	ok((run.party[0].get("bm_candidates", []) as Array).size() == 1,
		"a pre-AH save owing a pick rolls its triple on the spot")
	scene.free()


# ---------- 7. the owed-pick affordance chain ----------

func _test_owed_badges() -> void:
	# Six picks a run only land if the player finds them. Batch AE built the
	# chain for runes; this checks the ability half of it end to end.
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "cryomancer", "holy", "mystic"][i]
		run.party[i]["tree"] = Talents.generate_tree(run.party[i]["spec"],
			run.party[i]["key"])
	run.specs_chosen = true
	run.active = true
	ok(run.owed_ability_picks() == 0, "nothing owed on a fresh run")
	run.award_ability_pick(run.party[0])
	run.award_ability_pick(run.party[2])
	ok(run.owed_ability_picks() == 2, "two owed after two awards")
	# The map badge.
	var map_scene: Node = load("res://scenes/map.tscn").instantiate()
	root.add_child(map_scene)
	for _i in 6:
		await process_frame
	var badged := false
	var walk: Array = [map_scene]
	while not walk.is_empty():
		var n: Node = walk.pop_back()
		for c in n.get_children():
			walk.append(c)
		if n is Button and String(n.get("text")).contains("2 abilities!"):
			badged = true
	ok(badged, "the map's Party button badges the owed picks")
	map_scene.free()
	# The Party screen's hero list.
	var party_scene: Node = load("res://scenes/party.tscn").instantiate()
	root.add_child(party_scene)
	for _i in 6:
		await process_frame
	var rows := 0
	walk = [party_scene]
	while not walk.is_empty():
		var n2: Node = walk.pop_back()
		for c in n2.get_children():
			walk.append(c)
		if n2 is Button and String(n2.get("text")).contains("ABILITY TO CHOOSE"):
			rows += 1
	ok(rows == 2, "both owed heroes are marked in the list (got %d)" % rows)
	party_scene.free()


# ---------- 8. Deadfall's perfect: the one HUMAN-ONLY path ----------

func _test_deadfall_aim() -> void:
	# The autoplay bot never casts Deadfall and is fenced out of the pick
	# anyway (`not autoplay`), so this branch would otherwise ship with no
	# runtime coverage at all. Drive it directly: resolve the special at
	# "perfect" with autoplay off, and answer the target picker.
	var prep := func(run):
		run.party[3]["bm_abilities"] = ["Deadfall"]
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		["raider", "archer", "wolfrider"], "fight", prep)
	var sv := _hero(scene, "trapper")
	ok(sv != null, "the Survivalist spawned")
	var foes: Array = scene.get("enemies")
	ok(foes.size() >= 2, "at least two enemies to choose between")
	if sv == null or foes.size() < 2:
		scene.free()
		return
	var ab: Ability = Classes.pool_ability("Deadfall")
	ok(ab != null and not ab.no_skill_check, "Deadfall resolves and takes a check")
	var mark: BattleUnit = foes[1]
	scene.set("autoplay", false)
	_answer_picker.call_deferred(scene, mark)
	await scene._resolve_special(sv, ab, sv, "perfect", 1.0)
	scene.set("autoplay", true)
	ok(sv.deadfall_armed == 1, "the trap is armed")
	ok(sv.deadfall_aims.size() == 1, "and it is AIMED (a perfect rig)")
	if sv.deadfall_aims.size() == 1:
		ok(int(sv.deadfall_aims[0]) == foes.find(mark),
			"...at the enemy the player named")
	# An ORDINARY rig arms nothing aimed.
	await scene._resolve_special(sv, ab, sv, "good", 1.0)
	ok(sv.deadfall_armed == 2, "a second trap is armed")
	ok(sv.deadfall_aims.size() == 1, "an ordinary rig adds no aim")
	# Let the picker's own coroutine unwind before the scene goes.
	for _i in 6:
		await process_frame
	scene.free()


# _pick_target awaits a signal; answer it one frame later, as a click would.
func _answer_picker(scene: Node, who: BattleUnit) -> void:
	for _i in 3:
		await process_frame
	scene._target_picked.emit(who)
