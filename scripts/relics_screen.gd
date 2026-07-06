# Relic collection viewer (from the main menu). Locked relics show as
# fractured silhouettes with a hint.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")


func _ready() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var title := Label.new()
	title.text = "Relics of Past Cycles"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 50)
	title.size = Vector2(1280, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var hint := Label.new()
	hint.text = "Slay zone bosses to unlock relics. Assign up to 3 when drafting a party."
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	hint.position = Vector2(0, 112)
	hint.size = Vector2(1280, 20)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hint)

	Relics.load_data()
	var i := 0
	for id in Relics.POOL:
		var owned: bool = Relics.unlocked.has(id)
		var panel := PanelContainer.new()
		panel.position = Vector2(170 + (i % 3) * 330, 160 + (i / 3) * 160)
		panel.custom_minimum_size = Vector2(300, 140)
		if not owned:
			panel.modulate = Color(0.5, 0.45, 0.55)
		add_child(panel)
		var label := Label.new()
		var info: Dictionary = Relics.POOL[id]
		label.text = "%s\n\n%s" % [info["name"] if owned else "? ? ?",
			info["desc"] if owned else "A shape lost to the Decay.\nSlay a boss to recover it."]
		label.add_theme_font_size_override("font_size", 14)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		panel.add_child(label)
		i += 1

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(160, 46)
	back.position = Vector2(560, 640)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	add_child(back)
