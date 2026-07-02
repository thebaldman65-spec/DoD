# One combatant on the battlefield: sprite, animations, stats, HP/Pressure bars.
# Built entirely in code from the 100x100 sprite sheets.
class_name BattleUnit
extends Node2D

const FRAME_SIZE := 100

var unit_name := ""
var is_hero := true
var max_hp := 100
var hp := 100
var armor := 0.15          # fraction of damage blocked (0.25 = 25%)
var speed := 100.0         # 100 = average; higher acts more often
var stability := 50        # Pressure needed to Break this unit
var pressure := 0
var resource_name := ""    # "Rage" or "Mana" (heroes only)
var resource := 0
var max_resource := 100
var abilities: Array = []

var broken := false         # Broken: defenses down, crit vulnerable
var broken_pending := false # will lose its next turn
var dead := false
var next_time := 0.0        # position on the initiative timeline

var sprite: AnimatedSprite2D
var _hp_fill: ColorRect
var _pressure_fill: ColorRect
var _status_label: Label
var _idle_texture: Texture2D


func setup(config: Dictionary) -> void:
	for key in config:
		if key != "sheet_dir" and key != "sprite_scale":
			set(key, config[key])
	hp = max_hp
	_build_sprite(config["sheet_dir"], config.get("sprite_scale", 2.2))
	_build_bars()


func _build_sprite(sheet_dir: String, sprite_scale: float) -> void:
	var frames := SpriteFrames.new()
	var prefix: String = sheet_dir.get_file().capitalize()
	# Animation name -> [file suffix, fps, loops]
	var anims := {
		"idle": ["Idle", 8, true],
		"walk": ["Walk", 10, true],
		"attack01": ["Attack01", 12, false],
		"attack02": ["Attack02", 12, false],
		"hurt": ["Hurt", 12, false],
		"death": ["Death", 10, false],
	}
	if FileAccess.file_exists("%s/%s_Attack03.png" % [sheet_dir, prefix]):
		anims["attack03"] = ["Attack03", 12, false]
	for anim_name in anims:
		var info: Array = anims[anim_name]
		var tex: Texture2D = load("%s/%s_%s.png" % [sheet_dir, prefix, info[0]])
		if tex == null:
			continue
		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, info[1])
		frames.set_animation_loop(anim_name, info[2])
		var count := int(tex.get_width() / float(FRAME_SIZE))
		for i in count:
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = Rect2(i * FRAME_SIZE, 0, FRAME_SIZE, FRAME_SIZE)
			frames.add_frame(anim_name, atlas)
		if anim_name == "idle":
			_idle_texture = frames.get_frame_texture("idle", 0)
	frames.remove_animation("default")
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.scale = Vector2(sprite_scale, sprite_scale)
	sprite.flip_h = not is_hero
	add_child(sprite)
	sprite.animation_finished.connect(_on_anim_finished)
	sprite.play("idle")


func _build_bars() -> void:
	var bar_y := 62.0
	add_child(_make_bar_bg(Vector2(-31, bar_y), Vector2(62, 7)))
	_hp_fill = _make_fill(Vector2(-30, bar_y + 1), Vector2(60, 5), Color(0.30, 0.78, 0.32))
	add_child(_hp_fill)
	add_child(_make_bar_bg(Vector2(-31, bar_y + 9), Vector2(62, 5)))
	_pressure_fill = _make_fill(Vector2(-30, bar_y + 10), Vector2(60, 3), Color(0.75, 0.35, 0.95))
	add_child(_pressure_fill)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.add_theme_color_override("font_color", Color(0.9, 0.88, 0.8))
	name_label.position = Vector2(-40, -92)
	name_label.size = Vector2(80, 16)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(name_label)

	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 12)
	_status_label.add_theme_color_override("font_color", Color(0.85, 0.4, 1.0))
	_status_label.position = Vector2(-40, 78)
	_status_label.size = Vector2(80, 14)
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_status_label)


func _make_bar_bg(pos: Vector2, bar_size: Vector2) -> ColorRect:
	var r := ColorRect.new()
	r.position = pos
	r.size = bar_size
	r.color = Color(0.08, 0.06, 0.1, 0.9)
	return r


func _make_fill(pos: Vector2, bar_size: Vector2, color: Color) -> ColorRect:
	var r := ColorRect.new()
	r.position = pos
	r.size = bar_size
	r.color = color
	return r


func refresh_bars() -> void:
	_hp_fill.size.x = 60.0 * clampf(hp / float(max_hp), 0.0, 1.0)
	_pressure_fill.size.x = 60.0 * clampf(pressure / float(stability), 0.0, 1.0)
	_status_label.text = "BROKEN" if broken else ""


func portrait() -> Texture2D:
	return _idle_texture


func play_anim(anim_name: String) -> void:
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)


func return_to_idle() -> void:
	if not dead:
		sprite.play("idle")


# Applies damage + Pressure. Returns what happened so battle.gd can react.
func take_hit(amount: int, pressure_add: int) -> Dictionary:
	hp = maxi(hp - amount, 0)
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	var just_broke := false
	if not broken:
		pressure += pressure_add
		if pressure >= stability:
			broken = true
			broken_pending = true
			pressure = stability
			just_broke = true
			modulate = Color(0.85, 0.6, 1.0)
	if hp <= 0:
		dead = true
		broken = false
		broken_pending = false
		play_anim("death")
	elif not just_broke:
		play_anim("hurt")
	refresh_bars()
	return {"died": dead, "broke": just_broke}


func recover_from_break() -> void:
	broken = false
	pressure = 0
	modulate = Color.WHITE
	refresh_bars()


func heal_amount(amount: int) -> void:
	hp = mini(hp + amount, max_hp)
	refresh_bars()


func float_text(text: String, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	label.position = Vector2(randf_range(-30, 10), -80)
	label.z_index = 10
	add_child(label)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 45, 0.9)
	tween.tween_property(label, "modulate:a", 0.0, 0.9).set_delay(0.3)
	tween.chain().tween_callback(label.queue_free)


func _on_anim_finished() -> void:
	if not dead and sprite.animation in ["hurt", "attack01", "attack02", "attack03"]:
		sprite.play("idle")
	if dead and sprite.animation == "death":
		sprite.pause()
		modulate = Color(0.45, 0.4, 0.5)
