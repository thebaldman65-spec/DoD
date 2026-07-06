# Main menu: New Game, Continue (when a save exists), Relics, Settings, Exit.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
# Placeholder art until a dedicated menu background lands in imported files.
const BG_PATH := "res://assets/backgrounds/main_menu.png"
const BG_FALLBACK := "res://assets/backgrounds/node_background_forest.png"


func _ready() -> void:
	Settings.apply()
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.06, 0.05, 0.08)
	add_child(bg)
	var art_path := BG_PATH if ResourceLoader.exists(BG_PATH) else BG_FALLBACK
	var art := TextureRect.new()
	art.texture = load(art_path)
	art.size = Vector2(1280, 720)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(art)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0.03, 0.02, 0.05, 0.45)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	var title := Label.new()
	title.text = "DAWN OF DECAY"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 72)
	title.add_theme_color_override("font_color", Color(0.88, 0.8, 0.62))
	title.add_theme_constant_override("outline_size", 8)
	title.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.08))
	title.position = Vector2(0, 90)
	title.size = Vector2(1280, 90)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var entries: Array = [
		["New Game", _on_new_game, true],
		["Continue", _on_continue, Run.has_save()],
		["Relics", _on_relics, true],
		["Settings", _on_settings, true],
		["Exit", _on_exit, true],
	]
	for i in entries.size():
		var btn := Button.new()
		btn.text = entries[i][0]
		btn.custom_minimum_size = Vector2(300, 54)
		btn.position = Vector2(490, 250 + i * 74)
		btn.add_theme_font_size_override("font_size", 22)
		btn.disabled = not entries[i][2]
		btn.pressed.connect(entries[i][1])
		add_child(btn)


func _on_new_game() -> void:
	Run.active = false
	get_tree().change_scene_to_file("res://scenes/draft.tscn")


func _on_continue() -> void:
	if Run.load_run():
		get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_relics() -> void:
	get_tree().change_scene_to_file("res://scenes/relics_screen.tscn")


func _on_settings() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")


func _on_exit() -> void:
	get_tree().quit()
