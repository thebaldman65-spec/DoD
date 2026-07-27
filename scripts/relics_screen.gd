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
	# The persistent profile's public face: pure chronicle, gates nothing.
	if Profile.completions_total() + Profile.wipes_total() > 0:
		hint.text += "\nCycles survived: %d   •   Cycles lost: %d   •   Events witnessed: %d of %d" % [
			Profile.completions_total(), Profile.wipes_total(),
			Profile.distinct_events_seen(), Events.ids().size()]
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	hint.position = Vector2(0, 112)
	hint.size = Vector2(1280, 20)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hint)

	Relics.load_data()
	# 25 relics need a scrolling shelf; commons first, rares (◆) after.
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(140, 150)
	scroll.custom_minimum_size = Vector2(1020, 470)
	scroll.size = Vector2(1020, 470)
	add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 14)
	scroll.add_child(grid)
	var ordered: Array = Relics.POOL.keys()
	ordered.sort_custom(func(a, b): return String(Relics.POOL[a].get("tier", "common")) \
		< String(Relics.POOL[b].get("tier", "common")))
	for id in ordered:
		var owned: bool = Relics.unlocked.has(id)
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(320, 128)
		if not owned:
			panel.modulate = Color(0.5, 0.45, 0.55)
		grid.add_child(panel)
		var label := Label.new()
		var info: Dictionary = Relics.POOL[id]
		var tier_tag := "  ◆ RARE" if String(info.get("tier", "common")) == "rare" else ""
		label.text = "%s\n\n%s" % [(info["name"] + tier_tag) if owned else "? ? ?",
			info["desc"] if owned else "A shape lost to the Decay.\nSlay a boss to recover it."]
		label.add_theme_font_size_override("font_size", 14)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		panel.add_child(label)

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(160, 46)
	back.position = Vector2(560, 640)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	add_child(back)
