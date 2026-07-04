# Party overview reached from the map's Party tab. List view shows the three
# Untouched; selecting one details their stats, abilities, and (future)
# specializations. Back returns to the list, then to the map.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var selected := ""  # "" = list view, otherwise a hero key


func _ready() -> void:
	if not Run.active:
		Run.new_run()
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(110, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(_on_back)
	add_child(back)

	if selected == "":
		_draw_list()
	else:
		_draw_detail()


func _on_back() -> void:
	if selected == "":
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		selected = ""
		_draw_screen()


func _title(text: String, y: float, size: int = 40) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_override("font", NAME_FONT)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	label.position = Vector2(0, y)
	label.size = Vector2(1280, size + 10)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)


func _draw_list() -> void:
	_title("The Untouched", 30)
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		var key: String = member["key"]
		var btn := Button.new()
		var line := "%s\nHP %d/%d" % [key.capitalize(), member["hp"], member["max_hp"]]
		if key != "warrior":
			line += "    Mana %d/%d" % [member["mana"], member["max_mana"]]
		btn.text = line
		btn.custom_minimum_size = Vector2(420, 96)
		btn.position = Vector2(430, 140 + i * 130)
		btn.add_theme_font_size_override("font_size", 20)
		btn.pressed.connect(_select_hero.bind(key))
		add_child(btn)


func _select_hero(key: String) -> void:
	selected = key
	_draw_screen()


func _draw_detail() -> void:
	var cfg := Classes.hero_config(selected)
	var member := {}
	for m in Run.party:
		if m["key"] == selected:
			member = m
	_title(cfg["unit_name"], 24)

	var blurb := Label.new()
	blurb.text = Classes.CLASS_BLURBS[selected]
	blurb.add_theme_font_size_override("font_size", 15)
	blurb.add_theme_color_override("font_color", Color(0.65, 0.6, 0.55))
	blurb.position = Vector2(0, 78)
	blurb.size = Vector2(1280, 40)
	blurb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(blurb)

	# Stats column (left).
	var stats := Label.new()
	var resource_line := "%s %d/%d" % [cfg["resource_name"],
		member.get("mana", 0) if cfg["resource_name"] == "Mana" else 0, cfg["max_resource"]]
	var lines := PackedStringArray([
		"STATS",
		"",
		"HP: %d / %d" % [member.get("hp", cfg["max_hp"]), cfg["max_hp"]],
		resource_line,
		"Armor: %d%%" % int(cfg["armor"] * 100),
		"Speed: %d" % int(cfg["speed"]),
		"Stability: %d" % cfg["stability"],
	])
	if cfg.has("second_resource_name"):
		lines.append("Secondary: %s" % cfg["second_resource_name"])
	stats.text = "\n".join(lines)
	stats.add_theme_font_size_override("font_size", 17)
	stats.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	stats.position = Vector2(80, 150)
	stats.size = Vector2(260, 400)
	add_child(stats)

	# Abilities column (center).
	var ability_header := Label.new()
	ability_header.text = "ABILITIES"
	ability_header.add_theme_font_size_override("font_size", 17)
	ability_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	ability_header.position = Vector2(370, 150)
	add_child(ability_header)
	var abilities: Array = cfg["abilities"]
	for i in abilities.size():
		var ab: Ability = abilities[i]
		var panel := PanelContainer.new()
		panel.position = Vector2(370, 185 + i * 118)
		panel.custom_minimum_size = Vector2(460, 106)
		add_child(panel)
		var label := Label.new()
		var cost := "Free" if ab.cost == 0 else "%d %s" % [ab.cost, cfg["resource_name"]]
		var text := "%s  (%s)" % [ab.display_name, cost]
		if ab.damage > 0:
			text += "   %d–%d dmg, %d Pressure" % [int(ab.damage * 0.9),
				int(round(ab.damage * 1.1)), ab.pressure]
		if ab.heal > 0:
			text += "   heals %d" % ab.heal
		text += "\n%s" % ab.description.replace("\n", " ")
		if ab.perfect_text != "":
			text += "\nPerfect: %s" % ab.perfect_text
		label.text = text
		label.add_theme_font_size_override("font_size", 13)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		panel.add_child(label)

	# Specializations column (right) — flavor until the talent phase.
	var spec_header := Label.new()
	spec_header.text = "SPECIALIZATIONS"
	spec_header.add_theme_font_size_override("font_size", 17)
	spec_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	spec_header.position = Vector2(890, 150)
	add_child(spec_header)
	var specs: Array = Classes.SPECS[selected]
	for i in specs.size():
		var panel := PanelContainer.new()
		panel.position = Vector2(890, 185 + i * 118)
		panel.custom_minimum_size = Vector2(330, 106)
		add_child(panel)
		var label := Label.new()
		label.text = "%s\n%s\n(locked — coming soon)" % [specs[i][0], specs[i][1]]
		label.add_theme_font_size_override("font_size", 13)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		panel.add_child(label)
