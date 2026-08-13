# Run start: pick your four heroes (one of each, shown as sprites) and
# assign up to 3 relics from the earned collection.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
const ROSTER := ["warrior", "mage", "cleric", "hunter"]
const CLASS_TINTS := {
	"warrior": Color.WHITE, "mage": Color(0.65, 0.75, 1.0),
	"cleric": Color(1.0, 0.9, 0.6), "hunter": Color(0.7, 1.0, 0.75),
}

var picks: Array = []         # selection order = battle position
var relic_picks: Array = []   # up to 3 relic ids
var difficulty := "wanderer"  # BATCH BM §5: the ladder's first rung


func _ready() -> void:
	Relics.load_data()
	Music.play("menu")
	_draw_screen()


func _hero_portrait() -> Texture2D:
	var sheet: Texture2D = load("res://assets/sprites/soldier/Soldier_Idle.png")
	var crop := AtlasTexture.new()
	crop.atlas = sheet
	crop.region = Rect2(28, 18, 44, 60)
	return crop


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
	title.position = Vector2(0, 20)
	title.size = Vector2(1280, 54)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Select your four heroes (%d/4)" % picks.size()
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	subtitle.position = Vector2(0, 76)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	for c in ROSTER.size():
		var key: String = ROSTER[c]
		var picked: bool = picks.has(key)
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(200, 240)
		btn.position = Vector2(200 + c * 230, 108)
		btn.tooltip_text = Classes.CLASS_BLURBS[key]
		btn.pressed.connect(_toggle_hero.bind(key))
		if picked:
			btn.modulate = Color(0.45, 0.45, 0.45)  # greyed out once selected
		add_child(btn)
		var portrait := TextureRect.new()
		portrait.texture = _hero_portrait()
		portrait.custom_minimum_size = Vector2(140, 180)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.position = btn.position + Vector2(30, 8)
		portrait.modulate = CLASS_TINTS[key] * (Color(0.5, 0.5, 0.5) if picked else Color.WHITE)
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(portrait)
		var name_label := Label.new()
		name_label.text = key.capitalize() + ("   %d" % (picks.find(key) + 1) if picked else "")
		name_label.add_theme_font_size_override("font_size", 17)
		name_label.position = btn.position + Vector2(0, 200)
		name_label.size = Vector2(200, 24)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(name_label)
		# (Class passives show at the awakening screen and on the party
		# sheet — the draft stays clean.)

	# Relic assignment (up to 3 from the earned collection).
	var relic_header := Label.new()
	relic_header.text = ("ASSIGN RELICS  (%d/3)" % relic_picks.size()) \
		if not Relics.unlocked.is_empty() else "RELICS - none earned yet (slay zone bosses)"
	relic_header.add_theme_font_size_override("font_size", 16)
	relic_header.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	relic_header.position = Vector2(0, 386)
	relic_header.size = Vector2(1280, 22)
	relic_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(relic_header)
	# The collection grows toward 25 — the grid lives in a scroll box so a
	# full trophy shelf never spills over the Begin button.
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(160, 414)
	scroll.custom_minimum_size = Vector2(980, 200)
	scroll.size = Vector2(980, 200)
	add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 10)
	scroll.add_child(grid)
	for id in Relics.unlocked:
		var info: Dictionary = Relics.POOL[id]
		var rbtn := Button.new()
		var on: bool = relic_picks.has(id)
		var tier_tag := " ◆" if String(info.get("tier", "common")) == "rare" else ""
		rbtn.text = ("[ON]  " if on else "") + info["name"] + tier_tag
		rbtn.custom_minimum_size = Vector2(305, 40)
		rbtn.tooltip_text = "%s\n%s" % [String(info.get("tier", "common")).to_upper(),
			info["desc"]]
		if on:
			rbtn.modulate = Color(1.0, 0.9, 0.5)
		elif relic_picks.size() >= 3:
			rbtn.disabled = true
		rbtn.pressed.connect(_toggle_relic.bind(id))
		grid.add_child(rbtn)

	# BATCH BM §5 — THE DIFFICULTY LADDER, chosen here and recorded with the
	# run. Beating the END BOSS on a rung opens that tier of the meta talent
	# tree for every spec, so this is the run's most consequential choice and
	# it says what each rung's twist is rather than only how hard it is.
	var diff_label := Label.new()
	diff_label.text = "THE ROAD"
	diff_label.add_theme_font_size_override("font_size", 13)
	diff_label.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	diff_label.position = Vector2(60, 620)
	diff_label.size = Vector2(320, 18)
	add_child(diff_label)
	var dx := 60
	for key in Run.DIFFICULTY_ORDER:
		var def: Dictionary = Run.DIFFICULTIES[key]
		var dbtn := Button.new()
		dbtn.text = "%s%d — %s" % ["[*] " if difficulty == key else "",
			int(def["rung"]), def["name"]]
		dbtn.tooltip_text = "%s\nEnemies at %d%% strength.\nBeating the end boss here opens talent rows %d-%d." % [
			def["blurb"], int(round(float(def["mult"]) * 100)),
			Talents.rows_unlocked(int(def["rung"]) - 1) + 1,
			Talents.rows_unlocked(int(def["rung"]))]
		dbtn.custom_minimum_size = Vector2(140, 40)
		dbtn.position = Vector2(dx, 640)
		dbtn.add_theme_font_size_override("font_size", 13)
		if difficulty == key:
			dbtn.modulate = Color(1.0, 0.9, 0.5)
		dbtn.pressed.connect(Music.click)
		dbtn.pressed.connect(_set_difficulty.bind(key))
		add_child(dbtn)
		dx += 148

	# BATCH BM §4: the build screen is reachable from here as well as from the
	# main menu — talents are chosen between runs, and the draft IS between
	# runs. It reads what the profile holds, so it needs no run.
	var tal := Button.new()
	tal.text = "Talents"
	tal.custom_minimum_size = Vector2(150, 42)
	tal.position = Vector2(140, 16)
	tal.pressed.connect(Music.click)
	tal.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/talents.tscn"))
	add_child(tal)

	var start := Button.new()
	start.text = "Begin the Run"
	start.custom_minimum_size = Vector2(260, 56)
	start.position = Vector2(510, 630)
	start.add_theme_font_size_override("font_size", 20)
	start.disabled = picks.size() != 4
	start.pressed.connect(_start_run)
	add_child(start)

	var back := Button.new()
	back.text = "< Menu"
	back.custom_minimum_size = Vector2(110, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	add_child(back)


func _toggle_hero(key: String) -> void:
	if picks.has(key):
		picks.erase(key)
	elif picks.size() < 4:
		picks.append(key)
	_draw_screen()


func _toggle_relic(id: String) -> void:
	if relic_picks.has(id):
		relic_picks.erase(id)
	elif relic_picks.size() < 3:
		relic_picks.append(id)
	_draw_screen()


func _set_difficulty(key: String) -> void:
	difficulty = key
	_draw_screen()


func _start_run() -> void:
	Run.new_run(picks.duplicate(), relic_picks.duplicate(), difficulty)
	get_tree().change_scene_to_file("res://scenes/spec_choice.tscn")
