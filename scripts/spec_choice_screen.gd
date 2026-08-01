# After the first combat victory: each hero must choose a specialization.
# The choice is permanent for the run.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")


func _ready() -> void:
	# The awakening is still part of party setup — keep the menu track rolling.
	Music.play("menu")
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
		_finish_and_fade()
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

	# The class passive rides along on every path this class can take.
	var class_p: Dictionary = Classes.CLASS_PASSIVES[member["key"]]
	var passive_line := Label.new()
	passive_line.text = "Class Passive — %s: %s" % [class_p["name"],
		class_p["desc"].replace("\n", " ")]
	passive_line.add_theme_font_size_override("font_size", 14)
	passive_line.add_theme_color_override("font_color", Color(0.82, 0.74, 0.55))
	passive_line.position = Vector2(0, 110)
	passive_line.size = Vector2(1280, 20)
	passive_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(passive_line)

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
		# Archetype: bold name only; the explanation lives in the tooltip.
		var arch: String = info.get("archetype", "")
		var arch_label := Label.new()
		arch_label.text = arch
		var bold := FontVariation.new()
		bold.base_font = ThemeDB.fallback_font
		bold.variation_embolden = 0.9
		arch_label.add_theme_font_override("font", bold)
		arch_label.add_theme_font_size_override("font_size", 16)
		arch_label.add_theme_color_override("font_color", Color(0.82, 0.75, 0.6))
		arch_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		arch_label.mouse_filter = Control.MOUSE_FILTER_STOP
		arch_label.tooltip_text = Classes.ARCHETYPE_DESC.get(arch, "")
		vbox.add_child(arch_label)
		# Long kits (Beastmaster!) scroll instead of pushing the button off
		# screen: the text lives in a fixed-height ScrollContainer.
		var scroll := ScrollContainer.new()
		scroll.custom_minimum_size = Vector2(316, 320)
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		vbox.add_child(scroll)
		var body := Label.new()
		var ability_lines := PackedStringArray()
		var spec_atk := Classes.spec_attack(spec_id)
		for ab in Classes.spec_abilities(spec_id):
			var line: String = "• %s" % ab.display_name
			if ab.damage > 0:
				# Numbers from the spec's base Attack (damage is % of Attack).
				var hit: float = ab.damage * 0.01 * spec_atk
				line += " — %d–%d %s dmg (%d%% Atk)" % [int(hit * 0.9),
					int(round(hit * 1.1)), ab.dmg_type.capitalize(), ab.damage]
			ability_lines.append(line)
			ability_lines.append("   %s" % ab.description.replace("\n", " "))
		body.text = "%s\n\nPassive: %s\n\n%s" % [info["blurb"], info["passive_desc"],
			"\n".join(ability_lines)]
		body.add_theme_font_size_override("font_size", 12)
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.custom_minimum_size = Vector2(298, 0)
		body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.add_child(body)
		var choose := Button.new()
		choose.text = "Walk this path"
		choose.custom_minimum_size = Vector2(200, 44)
		choose.pressed.connect(_choose.bind(idx, spec_id))
		vbox.add_child(choose)
	# (choose buttons play the click inside _choose)


func _choose(idx: int, spec_id: String) -> void:
	Music.click()
	Run.party[idx]["spec"] = spec_id
	Run.party[idx]["tree"] = Talents.generate_tree(spec_id, Run.party[idx]["key"])
	Run.sync_spec_hp(idx)
	_draw_screen()


# All specs confirmed: the boss-entry tune plays over a fade to black, then the
# node map appears (map music waits for the tune to finish).
func _finish_and_fade() -> void:
	Run.specs_chosen = true
	# Persist immediately: without this, quitting before the next node made
	# Continue resurrect the old specs and talent trees.
	Run.save_run()
	# The persistent profile counts the run from the moment specs lock in.
	Profile.note_run_started(Run.party.map(func(m): return m.get("spec", "")))
	Music.play_intro_then("boss_intro", "map")
	var fade := ColorRect.new()
	fade.size = Vector2(1280, 720)
	fade.color = Color(0, 0, 0, 0.0)
	add_child(fade)
	var tween := create_tween()
	tween.tween_property(fade, "color:a", 1.0, 1.3)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/map.tscn")
