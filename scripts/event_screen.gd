# The event screen: presents Run.pending_event, greys out choices whose
# requirements fail, applies the chosen effects through the Events
# dispatch table, then shows the outcome + effect summary and returns to
# the map. All UI built in code like every other screen.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var _resolved := false


func _ready() -> void:
	if not Run.active or Run.pending_event == "":
		get_tree().change_scene_to_file.call_deferred("res://scenes/map.tscn")
		return
	Music.play("map")
	_draw_screen()


func _draw_screen() -> void:
	var cfg := Events.config(Run.pending_event)

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)
	var zone_backgrounds := {
		"Forest of Old": "res://assets/backgrounds/node_background_forest.png",
		"The Scarlands": "res://assets/backgrounds/node_background_scarlands.png",
	}
	var art := TextureRect.new()
	art.texture = load(zone_backgrounds.get(Run.zone_name,
		"res://assets/backgrounds/node_background_forest.png"))
	art.size = Vector2(1280, 720)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(art)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0.05, 0.04, 0.08, 0.72)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	var title := Label.new()
	title.text = String(cfg.get("title", "A Strange Encounter"))
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 90)
	title.size = Vector2(1280, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var panel := PanelContainer.new()
	panel.position = Vector2(340, 180)
	panel.custom_minimum_size = Vector2(600, 0)
	add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	panel.add_child(vbox)

	var text := Label.new()
	text.text = String(cfg.get("text", ""))
	text.add_theme_font_size_override("font_size", 17)
	text.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(text)

	for choice in cfg.get("choices", []):
		var btn := Button.new()
		btn.text = String(choice["label"])
		btn.custom_minimum_size = Vector2(560, 46)
		var req: Dictionary = choice.get("requires", {})
		var fail := Events.failed_reason(Run, req)
		if fail != "":
			btn.disabled = true
			btn.tooltip_text = fail
		else:
			btn.pressed.connect(Music.click)
			btn.pressed.connect(_choose.bind(choice))
		vbox.add_child(btn)

	var status := Label.new()
	status.text = "Gold: %d" % Run.gold
	status.add_theme_font_size_override("font_size", 14)
	status.add_theme_color_override("font_color", Color(0.75, 0.72, 0.65))
	status.position = Vector2(0, 690)
	status.size = Vector2(1280, 20)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status)


func _choose(choice: Dictionary) -> void:
	if _resolved:
		return
	_resolved = true
	var lines := PackedStringArray()
	for fx in choice.get("effects", []):
		var line := Events.apply(Run, fx)
		if line != "":
			lines.append(line)
	Run.pending_event = ""
	Run.save_run()
	_show_outcome(String(choice.get("outcome", "")), lines)


func _show_outcome(outcome: String, lines: PackedStringArray) -> void:
	for child in get_children():
		child.queue_free()
	_resolved = false
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	center.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)
	var text := Label.new()
	text.text = outcome
	text.add_theme_font_size_override("font_size", 19)
	text.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(text)
	if not lines.is_empty():
		var fx_label := Label.new()
		fx_label.text = "\n".join(lines)
		fx_label.add_theme_font_size_override("font_size", 16)
		fx_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.6))
		fx_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(fx_label)
	var btn := Button.new()
	btn.text = "Continue"
	btn.custom_minimum_size = Vector2(240, 44)
	btn.pressed.connect(Music.click)
	# Batch AN: a fight can queue a merchant AND an event behind it, so
	# leaving asks the run where to go rather than assuming the map.
	btn.pressed.connect(func():
		var next := Run.next_after_scene()
		Run.save_run()
		get_tree().change_scene_to_file(next))
	vbox.add_child(btn)
