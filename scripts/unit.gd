# One combatant on the battlefield: sprite, animations, stats, HP/Pressure bars,
# and status effects (buffs/debuffs). Built in code from the 100x100 sprite sheets.
class_name BattleUnit
extends Node2D

signal clicked

const FRAME_SIZE := 100
const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

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

# Active statuses: {id, label, short, color, turns}
var statuses: Array = []

var sprite: AnimatedSprite2D
var _hp_fill: ColorRect
var _pressure_fill: ColorRect
var _chips_root: Node2D
var _info_label: Label
var _idle_texture: Texture2D
var _target_btn: Button
var _target_marker: Label
var _base_tint := Color.WHITE


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
	var bar_y := 48.0
	add_child(_make_bar_bg(Vector2(-36, bar_y), Vector2(72, 8)))
	_hp_fill = _make_fill(Vector2(-35, bar_y + 1), Vector2(70, 6), Color(0.30, 0.78, 0.32))
	add_child(_hp_fill)
	add_child(_make_bar_bg(Vector2(-36, bar_y + 10), Vector2(72, 7)))
	_pressure_fill = _make_fill(Vector2(-35, bar_y + 11), Vector2(70, 5), Color(0.80, 0.35, 1.0))
	add_child(_pressure_fill)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.add_theme_font_override("font", NAME_FONT)
	name_label.add_theme_font_size_override("font_size", 17)
	name_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
	name_label.add_theme_constant_override("outline_size", 4)
	name_label.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.08, 0.9))
	name_label.position = Vector2(-50, -62)
	name_label.size = Vector2(100, 18)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(name_label)

	_chips_root = Node2D.new()
	_chips_root.position = Vector2(0, 70)
	add_child(_chips_root)

	_info_label = Label.new()
	_info_label.add_theme_font_size_override("font_size", 12)
	_info_label.add_theme_color_override("font_color", Color(0.95, 0.92, 0.8))
	_info_label.add_theme_constant_override("outline_size", 3)
	_info_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	_info_label.position = Vector2(-60, 90)
	_info_label.size = Vector2(120, 32)
	_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_info_label)

	_build_target_zone()


# Invisible click zone over the sprite, shown only while picking a target.
func _build_target_zone() -> void:
	_target_btn = Button.new()
	_target_btn.position = Vector2(-60, -95)
	_target_btn.size = Vector2(120, 190)
	_target_btn.focus_mode = Control.FOCUS_NONE
	var empty := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		_target_btn.add_theme_stylebox_override(state, empty)
	_target_btn.pressed.connect(func(): clicked.emit())
	_target_btn.mouse_entered.connect(func(): sprite.self_modulate = _base_tint.lightened(0.45))
	_target_btn.mouse_exited.connect(func(): sprite.self_modulate = _base_tint)
	_target_btn.visible = false
	add_child(_target_btn)

	_target_marker = Label.new()
	_target_marker.text = "▼"
	_target_marker.add_theme_font_size_override("font_size", 22)
	_target_marker.add_theme_color_override("font_color", Color(1.0, 0.75, 0.25))
	_target_marker.add_theme_constant_override("outline_size", 4)
	_target_marker.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	_target_marker.position = Vector2(-10, -90)
	_target_marker.visible = false
	add_child(_target_marker)


func set_tint(tint: Color) -> void:
	_base_tint = tint
	sprite.self_modulate = tint


func set_targetable(on: bool) -> void:
	_target_btn.visible = on
	_target_marker.visible = on
	if not on:
		sprite.self_modulate = _base_tint


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
	_hp_fill.size.x = 70.0 * clampf(hp / float(max_hp), 0.0, 1.0)
	var pressure_ratio := clampf(pressure / float(stability), 0.0, 1.0)
	_pressure_fill.size.x = 70.0 * pressure_ratio
	# Shifts toward hot pink as the unit gets close to Breaking.
	_pressure_fill.color = Color(0.80, 0.35, 1.0).lerp(Color(1.0, 0.25, 0.55), pressure_ratio)
	if _info_label.text != "":
		show_info()


# ---------- status effects ----------

# Adds (or refreshes) a status. `short` is the 1-2 char tag shown on the chip.
func add_status(id: String, label: String, short: String, color: Color, turns: int, desc := "") -> void:
	for s in statuses:
		if s.id == id:
			s.turns = maxi(s.turns, turns)
			_refresh_chips()
			return
	statuses.append({"id": id, "label": label, "short": short, "color": color,
		"turns": turns, "desc": desc})
	float_text(label, color)
	_refresh_chips()


func remove_status(id: String) -> void:
	statuses = statuses.filter(func(s): return s.id != id)
	_refresh_chips()


func has_status(id: String) -> bool:
	for s in statuses:
		if s.id == id:
			return true
	return false


# Called at the start of this unit's turn. Broken is managed separately.
func tick_statuses() -> void:
	for s in statuses:
		if s.id != "broken":
			s.turns -= 1
	statuses = statuses.filter(func(s): return s.id == "broken" or s.turns > 0)
	_refresh_chips()


func effective_speed() -> float:
	return speed * (0.75 if has_status("slow") else 1.0)


func effective_armor() -> float:
	var a := armor
	if broken:
		a *= 0.7
	if has_status("sunder"):
		a *= 0.7
	return a


func _refresh_chips() -> void:
	for child in _chips_root.get_children():
		child.queue_free()
	var count := statuses.size()
	if count == 0:
		return
	var start_x := -(count * 18.0 - 2.0) / 2.0
	for i in count:
		var s: Dictionary = statuses[i]
		var chip := ColorRect.new()
		chip.position = Vector2(start_x + i * 18.0, 0)
		chip.size = Vector2(16, 16)
		chip.color = s.color
		chip.mouse_filter = Control.MOUSE_FILTER_STOP
		chip.tooltip_text = "%s (%s turn%s left)\n%s" % [
			s.label, s.turns, "" if s.turns == 1 else "s", s.desc]
		if s.id == "broken":
			chip.tooltip_text = "%s\n%s" % [s.label, s.desc]
		_chips_root.add_child(chip)
		var tag := Label.new()
		tag.text = s.short
		tag.add_theme_font_size_override("font_size", 10)
		tag.add_theme_color_override("font_color", Color(0.05, 0.05, 0.08))
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.position = chip.position
		tag.size = Vector2(16, 16)
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_chips_root.add_child(tag)


# ---------- info readout ----------

# Shows HP + class resource under the sprite while this unit is acting.
func show_info() -> void:
	_info_label.text = "HP %d/%d\n%s %d/%d" % [hp, max_hp, resource_name, resource, max_resource]


func hide_info() -> void:
	_info_label.text = ""


func portrait() -> Texture2D:
	return _idle_texture


func play_anim(anim_name: String) -> void:
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)


func return_to_idle() -> void:
	if not dead:
		sprite.play("idle")


# ---------- damage / healing ----------

# Applies damage + Pressure. Returns what happened so battle.gd can react.
func take_hit(amount: int, pressure_add: int) -> Dictionary:
	hp = maxi(hp - amount, 0)
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	if has_status("ward"):
		pressure_add = int(pressure_add * 0.5)
	var just_broke := false
	if not broken:
		pressure += pressure_add
		if pressure >= stability:
			broken = true
			broken_pending = true
			pressure = stability
			just_broke = true
			modulate = Color(0.85, 0.6, 1.0)
			add_status("broken", "BROKEN", "B", Color(0.8, 0.4, 1.0), 1,
				"Loses next turn. -30% armor, +25% crit chance against this unit.")
	if hp <= 0:
		_die()
	elif not just_broke:
		play_anim("hurt")
	refresh_bars()
	return {"died": dead, "broke": just_broke}


# Damage from DoT effects (Burn). No Pressure, no hurt animation. Returns true on death.
func take_tick_damage(amount: int, label: String, color: Color) -> bool:
	hp = maxi(hp - amount, 0)
	float_text(label, color)
	if hp <= 0:
		_die()
	refresh_bars()
	return dead


func _die() -> void:
	dead = true
	broken = false
	broken_pending = false
	statuses.clear()
	_refresh_chips()
	play_anim("death")


func recover_from_break() -> void:
	broken = false
	pressure = 0
	modulate = Color.WHITE
	remove_status("broken")
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
