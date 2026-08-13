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
		run.equip_spec_talents(i)  # BATCH BM: the awakening equips, it does not pay
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

	await _check("res://scenes/map.tscn", "map (nothing entered)")
	# Batch BK: advance() takes a NODE index within the next slot, and a
	# node's warband lives on the node rather than on the slot.
	run.advance(int(run.reachable()[0]))
	var here: Dictionary = run.current_node()
	run.encounter = {"type": String(here["type"]),
		"enemies": here.get("enemies", []),
		"theme": here.get("theme", "Warband")}
	await _check("res://scenes/map.tscn", "map (column 1)")
	# Halfway: far enough in that foreclosure is drawn and the lattice has
	# scrolled, which is the state the old line could not produce.
	for _s in 7:
		var reach: Array = run.reachable()
		if reach.is_empty():
			break
		run.advance(int(reach[reach.size() - 1]))
	await _check("res://scenes/map.tscn", "map (past the mini-boss)")
	await _check("res://scenes/offer.tscn", "offer")
	await _check("res://scenes/party.tscn", "hero sheet")
	await _check("res://scenes/shop.tscn", "shop")
	# The blacksmith needs something on its counter, which means kits: the
	# specs above are already awakened, so the offer rolls.
	await _check("res://scenes/blacksmith.tscn", "blacksmith")
	run.pending_event = Events.pick(run)
	await _check("res://scenes/event.tscn", "event")
	# The boss slot's card, and the end-boss zone.
	run.zone_idx = 2
	while run.slot_idx < run.BOSS_SLOT:
		var reach2: Array = run.reachable()
		if reach2.is_empty():
			break
		run.advance(int(reach2[0]))
	await _check("res://scenes/map.tscn", "map (zone 3, boss cleared)")
	# BATCH BM: the build screen, in BOTH its states — a run in flight (it
	# must draw and lock) and no run (it must draw and be spendable).
	await _check("res://scenes/talents.tscn", "talents (run in flight, locked)")
	run.active = false
	await _check("res://scenes/talents.tscn", "talents (between runs)")
	run.active = true
	print("check_flow: %d failures" % bad)
	quit(1 if bad > 0 else 0)


func _check(path: String, label: String) -> void:
	print("  ... ", label)
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
