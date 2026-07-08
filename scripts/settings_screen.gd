# Settings: master volume and fullscreen, persisted to user://settings.cfg.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")


func _ready() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var title := Label.new()
	title.text = "Settings"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 60)
	title.size = Vector2(1280, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var vol_label := Label.new()
	vol_label.text = "Master Volume"
	vol_label.add_theme_font_size_override("font_size", 18)
	vol_label.position = Vector2(440, 220)
	add_child(vol_label)
	var vol := HSlider.new()
	vol.min_value = 0.0
	vol.max_value = 1.0
	vol.step = 0.05
	vol.value = Settings.volume
	vol.custom_minimum_size = Vector2(400, 30)
	vol.position = Vector2(440, 254)
	vol.value_changed.connect(_on_volume)
	add_child(vol)

	var fs := CheckBox.new()
	fs.text = "Fullscreen"
	fs.button_pressed = Settings.fullscreen
	fs.add_theme_font_size_override("font_size", 18)
	fs.position = Vector2(440, 320)
	fs.toggled.connect(_on_fullscreen)
	add_child(fs)

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(160, 46)
	back.position = Vector2(560, 600)
	back.pressed.connect(Music.click)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	add_child(back)


func _on_volume(v: float) -> void:
	Settings.volume = v
	Settings.apply()
	Settings.save()


func _on_fullscreen(on: bool) -> void:
	Settings.fullscreen = on
	Settings.apply()
	Settings.save()
