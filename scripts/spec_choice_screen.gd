# After the first combat victory: each hero must choose a specialization.
# The choice is permanent for the run.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")


func _ready() -> void:
	_draw_screen()


func _next_unspecced() -> int:
	for i in Run.party.size():
		if Run.party[i].get("spec", "") == "":
			return i
	return -1


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var idx := _next_unspecced()
	if idx == -1:
		Run.specs_chosen = true
		get_tree().change_scene_to_file("res://scenes/map.tscn")
		return

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var member: Dictionary = Run.party[idx]
	var title := Label.new()
	title.text = "The %s Awakens" % member["key"].capitalize()
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 30)
	title.size = Vector2(1280, 52)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Choose their path — this choice is permanent for the run (hero %d of %d)" % [
		idx + 1, Run.party.size()]
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	subtitle.position = Vector2(0, 86)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var back := Button.new()
	back.text = "< Back to Draft"
	back.custom_minimum_size = Vector2(150, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(func():
		Run.active = false
		get_tree().change_scene_to_file("res://scenes/draft.tscn"))
	add_child(back)

	var spec_ids: Array = Classes.SPEC_IDS[member["key"]]
	for i in spec_ids.size():
		var spec_id: String = spec_ids[i]
		var info: Dictionary = Classes.SPEC_INFO[spec_id]
		var panel := PanelContainer.new()
		panel.position = Vector2(90 + i * 380, 140)
		panel.custom_minimum_size = Vector2(340, 420)
		add_child(panel)
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 10)
		panel.add_child(vbox)
		var name_label := Label.new()
		name_label.text = info["name"]
		name_label.add_theme_font_override("font", NAME_FONT)
		name_label.add_theme_font_size_override("font_size", 28)
		name_label.add_theme_color_override("font_color", Color(0.9, 0.82, 0.6))
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(name_label)
		var body := Label.new()
		var ability_lines := PackedStringArray()
		for ab in Classes.spec_abilities(spec_id):
			var line: String = "• %s" % ab.display_name
			if ab.damage > 0:
				line += " — %d–%d %s dmg" % [int(ab.damage * 0.9),
					int(round(ab.damage * 1.1)), ab.dmg_type.capitalize()]
			ability_lines.append(line)
			ability_lines.append("   %s" % ab.description.replace("\n", " "))
		var arch: String = info.get("archetype", "")
		body.text = "%s\n\nArchetype: %s — %s\n\nPassive: %s\n\n%s" % [info["blurb"],
			arch, Classes.ARCHETYPE_DESC.get(arch, ""), info["passive_desc"],
			"\n".join(ability_lines)]
		body.add_theme_font_size_override("font_size", 13)
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.custom_minimum_size = Vector2(316, 300)
		vbox.add_child(body)
		var choose := Button.new()
		choose.text = "Walk this path"
		choose.custom_minimum_size = Vector2(200, 44)
		choose.pressed.connect(_choose.bind(idx, spec_id))
		vbox.add_child(choose)


func _choose(idx: int, spec_id: String) -> void:
	Run.party[idx]["spec"] = spec_id
	Run.party[idx]["tree"] = Talents.generate_tree(spec_id, Run.party[idx]["key"])
	_draw_screen()
