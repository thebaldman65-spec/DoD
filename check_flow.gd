# Scratch flow gate: instantiate every screen this batch touched against a
# live run and confirm it draws without error and without an empty page.
# A parse check proves the scripts compile; this proves the screens BUILD.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_flow.gd
extends SceneTree

var bad := 0


func _initialize() -> void:
	process_frame.connect(_go, CONNECT_ONE_SHOT)


func _go() -> void:
	var run: Node = root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "pyromancer", "holy", "sharpshooter"][i]
		run.party[i]["tree"] = Talents.generate_tree(run.party[i]["spec"],
			run.party[i]["key"])
		run.sync_spec_hp(i)
		run.award_spec_point(i)
	run.specs_chosen = true
	run.active = true
	# Give the cards something to render in every state: an owed rune pick,
	# an owed ability pick, an owed upgrade, and a worn rune.
	run.award_ability_pick(run.party[0])
	run.award_upgrade_pick(run.party[1])
	var triple: Array = run.roll_rune_candidates(run.party[2])
	if not triple.is_empty():
		run.party[2]["rune_candidates"] = [triple]
		run.party[2]["rune_picks_owed"] = 1
	var worn: Dictionary = run.generate_rune(run.party[3])
	if not worn.is_empty():
		worn["equipped"] = true
		run.party[3]["runes"] = [worn]

	await _check("res://scenes/map.tscn", "map (slot -1)")
	run.advance(0)
	run.encounter = {"type": "fight", "enemies": run.map[0]["enemies"],
		"theme": run.map[0].get("theme", "Warband")}
	await _check("res://scenes/map.tscn", "map (mid-zone)")
	await _check("res://scenes/offer.tscn", "offer")
	await _check("res://scenes/party.tscn", "hero sheet")
	await _check("res://scenes/shop.tscn", "shop")
	# The boss slot's card, and the end-boss zone.
	run.zone_idx = 2
	run.advance(run.BOSS_SLOT)
	await _check("res://scenes/map.tscn", "map (zone 3, boss cleared)")
	print("check_flow: %d failures" % bad)
	quit(1 if bad > 0 else 0)


func _check(path: String, label: String) -> void:
	var scene: Node = (load(path) as PackedScene).instantiate()
	root.add_child(scene)
	for _i in 5:
		await process_frame
	var n := _count(scene)
	if n < 5:
		print("EMPTY SCREEN: %s built only %d nodes" % [label, n])
		bad += 1
	else:
		print("  ok  %-30s %d nodes" % [label, n])
	scene.free()


func _count(n: Node) -> int:
	var total := 1
	for c in n.get_children():
		total += _count(c)
	return total
