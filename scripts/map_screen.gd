# Spire-style run map: pick a node on the next floor to travel there.
# Combat nodes jump straight into battle; rest/treasure resolve in place.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const NODE_LABELS := {
	"fight": "Fight", "elite": "ELITE", "rest": "Rest",
	"treasure": "Loot", "boss": "BOSS", "shop": "Shop",
	"event": "???",
}
const NODE_COLORS := {
	"fight": Color(0.75, 0.72, 0.65), "elite": Color(0.95, 0.55, 0.3),
	"rest": Color(0.5, 0.85, 0.55), "treasure": Color(0.95, 0.85, 0.4),
	"boss": Color(0.9, 0.3, 0.35), "shop": Color(0.5, 0.8, 0.95),
	"event": Color(0.78, 0.55, 0.95),
}


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	Music.play("map")
	_draw_screen()


func _node_pos(f: int, i: int) -> Vector2:
	# 11 rows (10 tiers + boss) stacked from y=620 up to y=100.
	var row_size: int = Run.map[f].size()
	var x := 640.0 + (i - (row_size - 1) / 2.0) * 220.0
	var y := 620.0 - f * 52.0
	return Vector2(x, y)


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)
	# Zone art behind the map, dimmed so nodes stay readable.
	var zone_backgrounds := {
		"Forest of Old": "res://assets/backgrounds/node_background_forest.png",
		"The Scarlands": "res://assets/backgrounds/node_background_scarlands.png",
	}
	var art_tex: Texture2D = load(zone_backgrounds.get(Run.zone_name,
		"res://assets/backgrounds/node_background_forest.png"))
	var art := TextureRect.new()
	art.texture = art_tex
	art.size = Vector2(1280, 720)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(art)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0.05, 0.04, 0.08, 0.55)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	var title := Label.new()
	title.text = Run.zone_name
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 14)
	title.size = Vector2(1280, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# The ladder readout (Batch Y): a tester should never count rows to
	# know how far in they are — or what waits at the top.
	var boss_name: String = Enemies.unit_name(Run.boss_kind())
	var subtitle := Label.new()
	if Run.floor_idx < 0:
		subtitle.text = "10 tiers stand between you and the %s" % boss_name
	else:
		subtitle.text = "Tier %d of 10 — the %s waits" % [
			mini(Run.floor_idx + 1, 10), boss_name]
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.72, 0.64, 0.52))
	subtitle.position = Vector2(0, 62)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var party_parts := PackedStringArray()
	for member in Run.party:
		var part := "%s %d/%d" % [member["key"].capitalize(), member["hp"], member["max_hp"]]
		if member["key"] != "warrior":
			part += " (%d MP)" % member["mana"]
		party_parts.append(part)
	var status := Label.new()
	status.text = "Gold: %d      %s" % [Run.gold, "   ".join(party_parts)]
	status.add_theme_font_size_override("font_size", 14)
	status.add_theme_color_override("font_color", Color(0.75, 0.72, 0.65))
	status.position = Vector2(0, 690)
	status.size = Vector2(1280, 20)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status)

	# Top tabs: Party (own screen) and Inventory (dropdown).
	var party_btn := Button.new()
	var unspent := 0
	for member in Run.party:
		unspent += member.get("talent_points", 0)
	party_btn.text = "Party" if unspent == 0 else "Party  (%d pts!)" % unspent
	if unspent > 0:
		party_btn.modulate = Color(1.0, 0.9, 0.45)
	party_btn.custom_minimum_size = Vector2(150, 42)
	party_btn.position = Vector2(20, 16)
	party_btn.pressed.connect(Music.click)
	party_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/party.tscn"))
	add_child(party_btn)

	var burger := MenuButton.new()
	burger.text = "☰"
	burger.custom_minimum_size = Vector2(52, 42)
	burger.position = Vector2(180, 16)
	burger.flat = false
	var bpop := burger.get_popup()
	bpop.add_item("Restart Run", 0)
	bpop.add_item("Quit to Main Menu", 1)
	bpop.add_item("Quit to Desktop", 2)
	# Testing shortcuts (always on in dev builds).
	if Run.debug_enabled():
		bpop.add_separator("DEBUG")
		bpop.add_item("+200 Gold", 10)
		bpop.add_item("+200 Talent Points (all)", 11)
		bpop.add_item("Full Heal Party", 12)
		bpop.add_item("Jump to Boss Tier", 13)
		bpop.add_item("Advance to Next Zone", 14)
		bpop.add_item("Reroll Specs", 15)
		# Review aid: battles spawn with every talent/trophy ability
		# pre-granted while checked (session-scoped, never saved).
		bpop.add_check_item("All Spec Abilities Unlocked", 16)
		bpop.set_item_checked(bpop.get_item_index(16), Run.debug_grant_all)
	bpop.id_pressed.connect(_on_burger)
	add_child(burger)

	var inv := MenuButton.new()
	inv.text = "Inventory ▾"
	inv.custom_minimum_size = Vector2(140, 42)
	inv.position = Vector2(1120, 16)
	inv.flat = false
	var popup := inv.get_popup()
	for i in Run.ITEM_IDS.size():
		var id: String = Run.ITEM_IDS[i]
		popup.add_item("%s  x%d" % [Run.ITEM_INFO[id][0], Run.items.get(id, 0)], i)
		popup.set_item_tooltip(i, Run.ITEM_INFO[id][1])
		popup.set_item_disabled(i, true)  # display only; items are used in battle
	add_child(inv)

	# Path lines first so nodes draw over them. The roads out of the
	# party's current node glow — "these are my options" should be the
	# first read of the screen, not a deduction.
	for f in Run.FLOORS - 1:
		for i in Run.map[f].size():
			var from_here: bool = f == Run.floor_idx and i == Run.node_idx
			for j in Run.map[f][i]["links"]:
				var line := Line2D.new()
				line.add_point(_node_pos(f, i))
				line.add_point(_node_pos(f + 1, j))
				line.width = 5.0 if from_here else 3.0
				line.default_color = Color(0.85, 0.72, 0.35, 0.9) if from_here \
					else Color(0.32, 0.28, 0.38, 0.5)
				add_child(line)

	var next_floor := Run.floor_idx + 1
	var reachable := Run.reachable()
	for f in Run.FLOORS:
		for i in Run.map[f].size():
			var node: Dictionary = Run.map[f][i]
			var btn := Button.new()
			btn.text = NODE_LABELS[node["type"]]
			btn.custom_minimum_size = Vector2(92, 36)
			btn.position = _node_pos(f, i) - Vector2(46, 18)
			var is_reachable: bool = f == next_floor and reachable.has(i)
			btn.disabled = not is_reachable
			# Three states, three clearly separate reads (Batch Y): visited
			# is history (dim green), reachable is an option (full node
			# colour, bigger), everything else recedes into the dark.
			if node["visited"]:
				btn.modulate = Color(0.48, 0.66, 0.48)
			elif is_reachable:
				btn.modulate = NODE_COLORS[node["type"]]
				btn.add_theme_font_size_override("font_size", 17)
			else:
				btn.modulate = Color(0.42, 0.40, 0.47)
			btn.pressed.connect(Music.click)
			btn.pressed.connect(_on_node_pressed.bind(f, i))
			# Scouting hover: combat nodes reveal their warband and what it
			# resists / crumples to; non-combat nodes state what they do
			# (Batch Y) — the event alone stays a deliberate mystery, and
			# says so instead of saying nothing.
			if node.has("enemies"):
				btn.tooltip_text = _warband_tooltip(node)
			else:
				match String(node["type"]):
					"rest":
						btn.tooltip_text = ("Waystone: the party rests, " +
							"recovering %d%% HP and Mana.") % int(round(
							(0.3 + Run.relic_add("rest_heal_add")) * 100))
					"shop":
						btn.tooltip_text = ("The Peddler: consumables, and " +
							"a rune offer for each hero.")
					"event":
						btn.tooltip_text = ("No scout returns with the same " +
							"story. What waits here is unknown.")
			add_child(btn)


func _on_node_pressed(f: int, i: int) -> void:
	var node: Dictionary = Run.map[f][i]
	Run.advance(f, i)
	match node["type"]:
		"rest":
			# Cairnmoss Poultice and kin deepen the waystone's rest.
			var rest_pct := 0.3 + Run.relic_add("rest_heal_add")
			Run.heal_party(rest_pct)
			Run.restore_mana(rest_pct)
			Run.save_run()
			_draw_screen()
			_toast("The party rests by the waystone (+%d%% HP & Mana)"
				% int(round(rest_pct * 100)))
		"treasure":
			var id := Run.random_loot()
			Run.items[id] = Run.items.get(id, 0) + 1
			Run.save_run()
			_draw_screen()
			_toast("Scavenged a %s!" % Run.ITEM_INFO[id][0])
		"shop":
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/shop.tscn")
		"event":
			# Events are drawn at the door, never pre-rolled — "???" nodes
			# stay a mystery on the map (unlike scoutable warbands).
			Run.pending_event = Events.pick(Run)
			if Run.pending_event == "":
				Run.save_run()
				_draw_screen()
				_toast("The road is quiet. Nothing happens.")
			else:
				Run.seen_events.append(Run.pending_event)
				Profile.note_event(Run.pending_event)
				Run.save_run()
				get_tree().change_scene_to_file("res://scenes/event.tscn")
		_:
			# Pre-rolled at map birth; saves from before that compose here.
			var warband: Array = node.get("enemies", [])
			if warband.is_empty():
				warband = Run.compose(node["type"])
				node["theme"] = Run.last_theme
			Run.encounter = {"type": node["type"], "enemies": warband,
				"theme": node.get("theme", "Warband")}
			get_tree().change_scene_to_file("res://scenes/battle.tscn")


func _on_burger(id: int) -> void:
	match id:
		0:
			Run.clear_save()
			Run.active = false
			get_tree().change_scene_to_file("res://scenes/draft.tscn")
		1:
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		2:
			Run.save_run()
			get_tree().quit()
		10:  # DEBUG entries below
			Run.gold += 200
			_draw_screen()
		11:
			for member in Run.party:
				member["talent_points"] = member.get("talent_points", 0) + 200
			_draw_screen()
		12:
			Run.heal_party(1.0)
			Run.restore_mana(1.0)
			_draw_screen()
		13:
			# Land on the last pre-boss tier so the boss is the next pick.
			Run.advance(Run.FLOORS - 2, 0)
			_draw_screen()
		14:
			Run.advance_zone()
			Run.save_run()
			_draw_screen()
		16:
			Run.debug_grant_all = not Run.debug_grant_all
			_draw_screen()
			_toast("DEBUG: all spec abilities %s" % (
				"UNLOCKED for every battle" if Run.debug_grant_all else "gated again"))
		15:
			# Debug spec swap: refund spent points, clear specs, re-awaken.
			for member in Run.party:
				var learned: Dictionary = member.get("talents", {})
				var spent := 0
				for talent_id in learned:
					spent += int(learned[talent_id])
				member["talent_points"] = member.get("talent_points", 0) + spent
				member["spec"] = ""
				member["talents"] = {}
				member["tree"] = []
			Run.specs_chosen = false
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/spec_choice.tscn")


# The hover card for a combat node: theme, lineup, and the warband's
# damage-type identity — how many units resist a type and how many are
# vulnerable to it ("Resists: Nature x3 / Soft to: Fire x2").
func _warband_tooltip(node: Dictionary) -> String:
	var kinds: Array = node["enemies"]
	var counts := {}
	for kind in kinds:
		counts[kind] = int(counts.get(kind, 0)) + 1
	var name_parts := PackedStringArray()
	for kind in counts:
		var label: String = Enemies.unit_name(kind)
		if counts[kind] > 1:
			label = "%dx %s" % [counts[kind], label]
		name_parts.append(label)
	# Units resisting / vulnerable per damage type, counted so one odd
	# member never masquerades as the whole band's identity. Token trims
	# (the 5-15% physical hides) stay off the card — only resists that
	# change a fight plan (25%+) count; every vulnerability counts.
	var resist_units := {}
	var vuln_units := {}
	for kind in kinds:
		var res: Dictionary = Enemies.resists_for(kind)
		for dtype in res:
			if float(res[dtype]) >= 0.2:
				resist_units[dtype] = int(resist_units.get(dtype, 0)) + 1
			elif float(res[dtype]) < 0.0:
				vuln_units[dtype] = int(vuln_units.get(dtype, 0)) + 1
	var text := "%s\n%s" % [String(node.get("theme", "Warband")),
		", ".join(name_parts)]
	var hard := _type_counts_line(resist_units)
	if hard != "":
		text += "\nResists: %s" % hard
	var soft := _type_counts_line(vuln_units)
	if soft != "":
		text += "\nSoft to: %s" % soft
	return text


# "Nature x3, Shadow x2" — biggest cluster first, bare name for singles.
func _type_counts_line(units_by_type: Dictionary) -> String:
	var types: Array = units_by_type.keys()
	types.sort_custom(func(a, b): return units_by_type[a] > units_by_type[b])
	var parts := PackedStringArray()
	for dtype in types:
		var label: String = String(dtype).capitalize()
		if units_by_type[dtype] > 1:
			label += " x%d" % units_by_type[dtype]
		parts.append(label)
	return ", ".join(parts)


func _toast(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.6))
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.position = Vector2(0, 100)
	label.size = Vector2(1280, 26)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.z_index = 50
	add_child(label)
	var tween := create_tween()
	tween.tween_interval(1.4)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
