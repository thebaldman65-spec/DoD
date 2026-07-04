# Run start: draft three heroes from the roster (duplicates allowed).
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
const ROSTER := ["warrior", "mage", "cleric"]

var picks: Array = ["", "", ""]


func _ready() -> void:
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var title := Label.new()
	title.text = "Assemble the Untouched"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 24)
	title.size = Vector2(1280, 54)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Choose three heroes for this cycle (duplicates allowed)"
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	subtitle.position = Vector2(0, 80)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	for slot in 3:
		var slot_label := Label.new()
		slot_label.text = "Slot %d" % (slot + 1)
		slot_label.add_theme_font_size_override("font_size", 18)
		slot_label.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
		slot_label.position = Vector2(180, 150 + slot * 150)
		add_child(slot_label)
		for c in ROSTER.size():
			var key: String = ROSTER[c]
			var btn := Button.new()
			btn.text = key.capitalize()
			btn.custom_minimum_size = Vector2(220, 90)
			btn.position = Vector2(300 + c * 250, 130 + slot * 150)
			btn.add_theme_font_size_override("font_size", 20)
			btn.tooltip_text = Classes.CLASS_BLURBS[key]
			if picks[slot] == key:
				btn.modulate = Color(0.6, 1.0, 0.65)
			btn.pressed.connect(_pick.bind(slot, key))
			add_child(btn)

	var start := Button.new()
	start.text = "Begin the Run"
	start.custom_minimum_size = Vector2(260, 56)
	start.position = Vector2(510, 620)
	start.add_theme_font_size_override("font_size", 20)
	start.disabled = picks.has("")
	start.pressed.connect(_start_run)
	add_child(start)


func _pick(slot: int, key: String) -> void:
	picks[slot] = key
	_draw_screen()


func _start_run() -> void:
	Run.new_run(picks.duplicate())
	get_tree().change_scene_to_file("res://scenes/spec_choice.tscn")
