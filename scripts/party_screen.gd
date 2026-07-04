# Party overview: pick a hero from the list, then one compact page shows
# their stats, class explanation, abilities, and their spec's talent tree.
# Specs are permanent once chosen (after the first victory).
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var selected := -1  # party index; -1 = list view


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/draft.tscn")
		return
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

	if selected < 0:
		_draw_list()
	else:
		_draw_detail()


func _on_back() -> void:
	if selected < 0:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		selected = -1
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
		var spec: String = member.get("spec", "")
		var spec_name: String = Classes.SPEC_INFO[spec]["name"] if spec != "" else "Unawakened"
		var btn := Button.new()
		var line := "%s — %s\nHP %d/%d" % [key.capitalize(), spec_name,
			member["hp"], member["max_hp"]]
		if key != "warrior":
			line += "    Mana %d/%d" % [member["mana"], member["max_mana"]]
		var pts: int = member.get("talent_points", 0)
		if pts > 0:
			line += "    ● %d POINTS TO SPEND" % pts
			btn.modulate = Color(1.0, 0.92, 0.55)
		btn.text = line
		btn.custom_minimum_size = Vector2(460, 96)
		btn.position = Vector2(410, 140 + i * 130)
		btn.add_theme_font_size_override("font_size", 18)
		btn.tooltip_text = Classes.CLASS_BLURBS[key]
		btn.pressed.connect(_select_hero.bind(i))
		add_child(btn)


func _select_hero(idx: int) -> void:
	selected = idx
	_draw_screen()


func _draw_detail() -> void:
	var member: Dictionary = Run.party[selected]
	var key: String = member["key"]
	var cfg := Classes.hero_config(key)
	var spec: String = member.get("spec", "")
	var spec_label: String = Classes.SPEC_INFO[spec]["name"] if spec != "" else "Unawakened"
	_title("%s — %s" % [cfg["unit_name"], spec_label], 20, 34)

	# Left column: class blurb, stats, abilities (compact chips, hover detail).
	var blurb := Label.new()
	blurb.text = Classes.CLASS_BLURBS[key]
	blurb.add_theme_font_size_override("font_size", 13)
	blurb.add_theme_color_override("font_color", Color(0.65, 0.6, 0.55))
	blurb.position = Vector2(60, 80)
	blurb.size = Vector2(400, 44)
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(blurb)

	var stats := Label.new()
	var lines := PackedStringArray([
		"HP: %d / %d" % [member["hp"], member["max_hp"]],
		"%s: %s" % [cfg["resource_name"],
			("%d / %d" % [member["mana"], member["max_mana"]]) if cfg["resource_name"] == "Mana"
			else "builds in combat"],
		"Armor: %d%%    Speed: %d    Stability: %d" % [int(cfg["armor"] * 100),
			int(cfg["speed"]), cfg["stability"]],
		"Talent Points: %d" % member.get("talent_points", 0),
	])
	if spec != "":
		lines.append("Passive: %s" % Classes.SPEC_INFO[spec]["passive_desc"])
	stats.text = "\n".join(lines)
	stats.add_theme_font_size_override("font_size", 15)
	stats.add_theme_color_override("font_color", Color(0.88, 0.85, 0.78))
	stats.position = Vector2(60, 132)
	stats.size = Vector2(400, 140)
	stats.mouse_filter = Control.MOUSE_FILTER_STOP
	stats.tooltip_text = "Armor — % of incoming damage blocked.\n" \
		+ "Speed — how quickly turns arrive (100 = average).\n" \
		+ "Stability — Pressure needed to Break this hero.\n" \
		+ "Talent points come from victories (1 fight / 2 elite / 3 boss)."
	add_child(stats)

	var ability_header := Label.new()
	ability_header.text = "ABILITIES  (hover for details)"
	ability_header.add_theme_font_size_override("font_size", 15)
	ability_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	ability_header.position = Vector2(60, 296)
	add_child(ability_header)

	var abilities: Array = cfg["abilities"]
	if spec != "":
		abilities = abilities + Classes.spec_abilities(spec)
	for i in abilities.size():
		var ab: Ability = abilities[i]
		var chip := PanelContainer.new()
		chip.position = Vector2(60 + (i % 2) * 205, 324 + (i / 2) * 46)
		chip.custom_minimum_size = Vector2(195, 38)
		var chip_label := Label.new()
		var cost_note := ""
		if ab.cost > 0:
			cost_note = "  (%d)" % ab.cost
		elif ab.faith_cost > 0:
			cost_note = "  (%dF)" % ab.faith_cost
		chip_label.text = "%s%s" % [ab.display_name, cost_note]
		chip_label.add_theme_font_size_override("font_size", 13)
		chip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		chip.add_child(chip_label)
		var tip := ab.description
		if ab.damage > 0:
			tip += "\nDamage: %d–%d (%s)   Pressure: %d" % [int(ab.damage * 0.9),
				int(round(ab.damage * 1.1)), ab.dmg_type.capitalize(), ab.pressure]
		if ab.heal > 0:
			tip += "\nHeals: %d" % ab.heal
		if ab.perfect_text != "":
			tip += "\nPerfect: %s" % ab.perfect_text
		chip.tooltip_text = tip
		add_child(chip)

	# Right side: the chosen spec's talent tree lives on this same page.
	var tree_header := Label.new()
	tree_header.add_theme_font_size_override("font_size", 15)
	tree_header.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	tree_header.position = Vector2(520, 80)
	tree_header.size = Vector2(700, 22)
	add_child(tree_header)

	if spec == "":
		tree_header.text = "TALENTS — the %s awakens after your first victory." % key.capitalize()
		return
	tree_header.text = "TALENTS — %s tree    (Points: %d)" % [
		Classes.SPEC_INFO[spec]["name"], member.get("talent_points", 0)]

	var learned: Dictionary = member.get("talents", {})
	var points: int = member.get("talent_points", 0)
	var tree: Array = Talents.tree(spec)
	var tier_counts := {}
	for talent in tree:
		var tier: int = talent["tier"]
		var idx_in_tier: int = tier_counts.get(tier, 0)
		tier_counts[tier] = idx_in_tier + 1
		var panel := PanelContainer.new()
		panel.position = Vector2(505 + idx_in_tier * 252, 110 + (tier - 1) * 196)
		panel.custom_minimum_size = Vector2(244, 184)
		add_child(panel)
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 4)
		panel.add_child(vbox)
		var ranks_have := int(learned.get(talent["id"], 0))
		var label := Label.new()
		var req_line := ""
		if talent["requires"] != "":
			req_line = "\nRequires: %s" % Talents.node(spec, talent["requires"])["name"]
		label.text = "T%d  %s   [%d/%d]\n%s%s" % [talent["tier"], talent["name"],
			ranks_have, talent["ranks"], talent["desc"], req_line]
		label.add_theme_font_size_override("font_size", 11)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.custom_minimum_size = Vector2(228, 0)
		vbox.add_child(label)
		var learn := Button.new()
		learn.custom_minimum_size = Vector2(130, 28)
		learn.add_theme_font_size_override("font_size", 12)
		var check: Dictionary = Talents.can_learn(spec, talent["id"], learned)
		if ranks_have >= int(talent["ranks"]):
			learn.text = "MAXED"
			learn.disabled = true
			panel.modulate = Color(0.75, 0.95, 0.75)
		elif not check["ok"]:
			learn.text = check["why"]
			learn.disabled = true
		elif points < 1:
			learn.text = "No points"
			learn.disabled = true
		else:
			learn.text = "Learn (1 pt)" if ranks_have == 0 else "Rank up (1 pt)"
			learn.pressed.connect(_learn_talent.bind(talent["id"]))
			if ranks_have > 0:
				panel.modulate = Color(0.85, 0.95, 0.8)
		vbox.add_child(learn)


func _learn_talent(talent_id: String) -> void:
	var member: Dictionary = Run.party[selected]
	var spec: String = member.get("spec", "")
	var learned: Dictionary = member.get("talents", {})
	if member.get("talent_points", 0) < 1 or not Talents.can_learn(spec, talent_id, learned)["ok"]:
		return
	learned[talent_id] = int(learned.get(talent_id, 0)) + 1
	member["talents"] = learned
	member["talent_points"] -= 1
	_draw_screen()
