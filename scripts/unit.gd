# One combatant on the battlefield: sprite, animations, stats, HP/Pressure bars,
# and status effects (buffs/debuffs). Built in code from the 100x100 sprite sheets.
class_name BattleUnit
extends Node2D

signal clicked

const FRAME_SIZE := 100
const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
const OUTLINE_SHADER := preload("res://shaders/outline.gdshader")

var unit_name := ""
var is_hero := true
var max_hp := 100
var hp := 100
var armor := 0.15          # fraction of damage blocked (0.25 = 25%)
var speed := 100.0         # 100 = average; higher acts more often
var stability := 100       # Break meter size (universal 0-100 scale)
var constitution := 100    # resistance to Break: incoming Pressure × 100/constitution
var pressure := 0
var resource_name := ""    # "Rage" or "Mana" (heroes only)
var resource := 0
var max_resource := 100
# Secondary class resource: Cleric Faith (0-100), Mage Arcane Resonance (0-5).
var second_resource_name := ""
var second_resource := 0
var second_max := 100
var passive_id := ""       # specialization passive hook (see battle.gd)
var crit_bonus := 0.0      # from talents
var parry_bonus := 0.0     # from talents
var dmg_bonus := 0.0       # global damage multiplier bonus (relics)
var type_dmg_bonus := {}   # dmg_type -> bonus fraction (relics)
var bleed_buildup := 0     # bleeds out at 100
var resists := {}          # dmg_type -> fraction reduced (negative = vulnerable)
var abilities: Array = []

var broken := false         # Broken: defenses down, crit vulnerable
var broken_pending := false # will lose its next turn
var dead := false
var next_time := 0.0        # position on the initiative timeline
var is_ranged := false      # melee/ranged split (Tripwire only punishes melee)
var is_boss := false        # bosses cannot be Stunned unless Broken
var is_companion := false   # Beastmaster summon: no turns, fights alongside
var companion_kind := ""    # "ursus" / "canis" / "aguila"
var companion: BattleUnit   # the Beastmaster's active summon (on the hunter)
var companion_hp_bonus := 0   # talents: extra HP for summoned companions
var companion_power := 0      # talents: extra damage on companion attacks
# Berserker fixed-tree talent stats.
var bleed_bonus := 0          # Savagery: extra Bleed on bleed-building abilities
var bloodrage_bonus := 0.0    # Bloodthirsty: widens Blood Frenzy's max bonus
var pierce_bonus := 0.0       # Crushing Force: attacks ignore extra armor
var dmg_taken_bonus := 0.0    # Reckless Fury: takes more damage
var enraged_ranks := 0        # Enraged: +1%/rank damage per hit taken
var enraged_stacks := 0       # current Enraged bonus (%); resets when unhurt
var turns_since_damaged := 0
var bloodcraze := 0           # heals 30 when an enemy bleeds out

# Active statuses: {id, label, short, color, turns}
var statuses: Array = []

var sprite: AnimatedSprite2D
var _hp_fill: ColorRect
var _hp_text: Label
var _res_fill: ColorRect
var _res_text: Label
var _res2_fill: ColorRect
var _res2_text: Label
var _pressure_fill: ColorRect
var _pressure_text: Label
var _chips_root: Node2D
var _idle_texture: Texture2D
var _target_btn: Button
var _target_marker: Label
var _base_tint := Color.WHITE
var _base_scale := 2.6


func setup(config: Dictionary) -> void:
	for key in config:
		if key != "sheet_dir" and key != "sprite_scale":
			set(key, config[key])
	hp = max_hp
	# Default scale sized for the 1:1 full-scene camera.
	_build_sprite(config["sheet_dir"], config.get("sprite_scale", 3.2))
	_build_bars()


func _build_sprite(sheet_dir: String, sprite_scale: float) -> void:
	# Companions use a procedurally drawn sphere until real beast art exists;
	# a single white circle frame backs every animation so the rest of the
	# unit machinery (tint, highlight, hit flash) works unchanged.
	if sheet_dir == "sphere":
		_build_sphere_sprite(sprite_scale)
		return
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
	var outline_mat := ShaderMaterial.new()
	outline_mat.shader = OUTLINE_SHADER
	sprite.material = outline_mat
	_base_scale = sprite_scale
	sprite.scale = Vector2(sprite_scale, sprite_scale)
	sprite.flip_h = not is_hero
	add_child(sprite)
	sprite.animation_finished.connect(_on_anim_finished)
	sprite.play("idle")


func _build_sphere_sprite(sprite_scale: float) -> void:
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for x in 64:
		for y in 64:
			if (x - 32) * (x - 32) + (y - 32) * (y - 32) <= 28 * 28:
				img.set_pixel(x, y, Color.WHITE)
	var tex := ImageTexture.create_from_image(img)
	var frames := SpriteFrames.new()
	for anim_name in ["idle", "attack01", "attack02", "attack03", "hurt", "death"]:
		frames.add_animation(anim_name)
		frames.set_animation_loop(anim_name, anim_name == "idle")
		frames.add_frame(anim_name, tex)
	frames.remove_animation("default")
	_idle_texture = tex
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	var outline_mat := ShaderMaterial.new()
	outline_mat.shader = OUTLINE_SHADER
	sprite.material = outline_mat
	_base_scale = sprite_scale
	sprite.scale = Vector2(sprite_scale, sprite_scale)
	add_child(sprite)
	sprite.animation_finished.connect(_on_anim_finished)
	sprite.play("idle")


func _build_bars() -> void:
	var bar_y := 50.0
	# Compact bars hugging the sprite so tall parties fit on screen.
	add_child(_make_bar_bg(Vector2(-36, bar_y), Vector2(72, 13)))
	_hp_fill = _make_fill(Vector2(-35, bar_y + 1), Vector2(70, 11), Color(0.30, 0.78, 0.32))
	add_child(_hp_fill)
	_hp_text = _make_bar_text(Vector2(-36, bar_y), Vector2(72, 13), 9)
	add_child(_hp_text)
	var next_y := bar_y + 15.0
	if resource_name != "":
		add_child(_make_bar_bg(Vector2(-36, next_y), Vector2(72, 12)))
		var res_color := Color(0.85, 0.30, 0.25) if resource_name == "Rage" else \
			(Color(0.55, 0.85, 0.40) if resource_name == "Focus" else Color(0.30, 0.50, 0.90))
		_res_fill = _make_fill(Vector2(-35, next_y + 1), Vector2(70, 10), res_color)
		add_child(_res_fill)
		_res_text = _make_bar_text(Vector2(-36, next_y), Vector2(72, 12), 8)
		add_child(_res_text)
		next_y += 14.0
	if second_resource_name != "":
		add_child(_make_bar_bg(Vector2(-36, next_y), Vector2(72, 11)))
		var res2_color := Color(0.95, 0.80, 0.30) if second_resource_name == "Faith" \
			else Color(0.75, 0.40, 0.95)
		_res2_fill = _make_fill(Vector2(-35, next_y + 1), Vector2(70, 9), res2_color)
		add_child(_res2_fill)
		_res2_text = _make_bar_text(Vector2(-36, next_y), Vector2(72, 11), 8)
		add_child(_res2_text)
		next_y += 13.0
	add_child(_make_bar_bg(Vector2(-36, next_y), Vector2(72, 12)))
	_pressure_fill = _make_fill(Vector2(-35, next_y + 1), Vector2(70, 10), Color(0.80, 0.35, 1.0))
	add_child(_pressure_fill)
	_pressure_text = _make_bar_text(Vector2(-36, next_y), Vector2(72, 12), 8)
	add_child(_pressure_text)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.add_theme_font_override("font", NAME_FONT)
	name_label.add_theme_font_size_override("font_size", 17)
	name_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
	name_label.add_theme_constant_override("outline_size", 4)
	name_label.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.08, 0.9))
	name_label.position = Vector2(-50, -68)
	name_label.size = Vector2(100, 18)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(name_label)

	_chips_root = Node2D.new()
	_chips_root.position = Vector2(0, next_y + 15.0)
	add_child(_chips_root)

	_build_target_zone()


# Text label sized exactly to its bar so centering is pixel-true.
func _make_bar_text(pos: Vector2, bar_size: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = bar_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


# Invisible click zone over the sprite, shown only while picking a target.
func _build_target_zone() -> void:
	_target_btn = Button.new()
	_target_btn.position = Vector2(-70, -110)
	_target_btn.size = Vector2(140, 220)
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
	_target_marker.position = Vector2(-10, -102)
	_target_marker.visible = false
	add_child(_target_marker)


func set_tint(tint: Color) -> void:
	_base_tint = tint
	sprite.self_modulate = tint


# Battlefield highlight driven by hovering the initiative bar: grow the
# sprite and draw a white outline around it.
func set_highlight(on: bool) -> void:
	var factor := 1.3 if on else 1.0
	sprite.scale = Vector2(_base_scale * factor, _base_scale * factor)
	sprite.material.set_shader_parameter("outline_on", on)
	_target_marker.visible = on or _target_btn.visible


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
	_hp_text.text = "%d/%d" % [hp, max_hp]
	if _res_fill != null:
		_res_fill.size.x = 70.0 * clampf(resource / float(max_resource), 0.0, 1.0)
		_res_text.text = "%d/%d" % [resource, max_resource]
	if _res2_fill != null:
		_res2_fill.size.x = 70.0 * clampf(second_resource / float(second_max), 0.0, 1.0)
		if second_resource_name == "Resonance":
			_res2_text.text = "%d/%d (+%d%% dmg)" % [second_resource, second_max,
				second_resource * 15]
		else:
			_res2_text.text = "%s %d/%d" % [second_resource_name, second_resource, second_max]
	if passive_id == "bloodrage":
		for s in statuses:
			if s.id == "spec_passive":
				var bonus := int(round(40.0 * (1.0 - hp / float(max_hp))))
				s.short = "+%d%%" % bonus
				s.desc = "Blood Frenzy: currently +%d%% damage\n(scales up to +40%% as HP falls)." % bonus
				_refresh_chips()
				break
	# Seasoned Fighter chip shows which side of the stance switch is live.
	if passive_id == "seasoned":
		for s in statuses:
			if s.id == "spec_passive":
				var offense := hp > max_hp * 0.5
				s.short = "+dmg" if offense else "-dmg"
				s.desc = "Seasoned Fighter: currently %s." % (
					"+15% damage dealt (above half HP)" if offense
					else "15% less damage taken (at or below half HP)")
				_refresh_chips()
				break
	var pressure_ratio := clampf(pressure / float(stability), 0.0, 1.0)
	_pressure_fill.size.x = 70.0 * pressure_ratio
	_pressure_text.text = "%d/%d" % [pressure, stability]
	# Shifts toward hot pink as the unit gets close to Breaking.
	_pressure_fill.color = Color(0.80, 0.35, 1.0).lerp(Color(1.0, 0.25, 0.55), pressure_ratio)


# ---------- status effects ----------

# Adds (or refreshes) a status. `short` is the 1-2 char tag shown on the chip.
func add_status(id: String, label: String, short: String, color: Color, turns: int,
		desc := "", power := 0) -> void:
	for s in statuses:
		if s.id == id:
			# Poison stacks additively (each stack +3 damage/turn) and every
			# new application refreshes the timer.
			if id == "poison":
				s.stacks = int(s.get("stacks", 1)) + 1
				s.turns = turns
				s.short = "P%d" % s.stacks
				s.desc = "Takes %d nature damage at the start of each\nturn (3 per stack); new stacks refresh the timer." % (3 * s.stacks)
				float_text("%s x%d" % [label, s.stacks], color)
			else:
				s.turns = maxi(s.turns, turns)
				s.power = maxi(s.power, power)
			_refresh_chips()
			return
	var entry := {"id": id, "label": label, "short": short, "color": color,
		"turns": turns, "desc": desc, "power": power, "stacks": 1}
	if id == "poison":
		entry["fresh"] = true  # no tick on the turn it lands
	statuses.append(entry)
	float_text(label, color)
	_refresh_chips()


func remove_status(id: String) -> void:
	statuses = statuses.filter(func(s): return s.id != id)
	_refresh_chips()


func get_status(id: String) -> Dictionary:
	for s in statuses:
		if s.id == id:
			return s
	return {}


func has_status(id: String) -> bool:
	for s in statuses:
		if s.id == id:
			return true
	return false


# Bleed is a buildup: wounding attacks add to it; at 100 the target bleeds
# out (caller applies the damage) and the meter resets. Returns true on
# bleedout.
func add_bleed(amount: int) -> bool:
	bleed_buildup = mini(bleed_buildup + amount, 100)
	var bled := bleed_buildup >= 100
	if bled:
		bleed_buildup = 0
		remove_status("bleed")
	else:
		var found := false
		for s in statuses:
			if s.id == "bleed":
				s.short = "Bl%d" % bleed_buildup
				s.desc = "Bleed buildup: %d/100.\nAt 100 the target bleeds out for\n20%% of max HP (ignores armor)." % bleed_buildup
				found = true
		if not found:
			statuses.append({"id": "bleed", "label": "Bleed", "short": "Bl%d" % bleed_buildup,
				"color": Color(0.85, 0.25, 0.25), "turns": -1,
				"desc": "Bleed buildup: %d/100.\nAt 100 the target bleeds out for\n20%% of max HP (ignores armor)." % bleed_buildup,
				"power": 0, "stacks": 1})
		float_text("Bleed %d" % bleed_buildup, Color(0.85, 0.3, 0.3))
	_refresh_chips()
	return bled


func status_power(id: String) -> int:
	for s in statuses:
		if s.id == id:
			return int(s.get("power", 0))
	return -1


func status_stacks(id: String) -> int:
	for s in statuses:
		if s.id == id:
			return int(s.get("stacks", 1))
	return 0


# Called at the start of this unit's turn. Broken is managed separately;
# negative turn counts mean "lasts the whole battle".
func tick_statuses() -> void:
	for s in statuses:
		if s.id != "broken" and s.turns > 0:
			s.turns -= 1
	statuses = statuses.filter(func(s): return s.id == "broken" or s.turns != 0)
	_refresh_chips()


func effective_speed() -> float:
	var s := speed * (0.75 if (has_status("slow") or has_status("chilled")) else 1.0)
	if has_status("quickdraw"):
		s *= 1.5
	return s


func effective_armor() -> float:
	var a := armor
	if has_status("fortify"):
		a += 0.10
	if broken:
		a *= 0.7
	if has_status("sunder"):
		a *= 0.65
	return a


func _refresh_chips() -> void:
	for child in _chips_root.get_children():
		child.queue_free()
	var count := statuses.size()
	if count == 0:
		return
	var total_w := 0.0
	for s in statuses:
		total_w += (16.0 if String(s.short).length() <= 2 else 34.0) + 2.0
	var start_x := -(total_w - 2.0) / 2.0
	var x := start_x
	for i in count:
		var s: Dictionary = statuses[i]
		var chip_w := 16.0 if String(s.short).length() <= 2 else 34.0
		var chip := ColorRect.new()
		chip.position = Vector2(x, 0)
		chip.size = Vector2(chip_w, 16)
		chip.color = s.color
		chip.mouse_filter = Control.MOUSE_FILTER_STOP
		chip.tooltip_text = "%s (%s turn%s left)\n%s" % [
			s.label, s.turns, "" if s.turns == 1 else "s", s.desc]
		if s.id == "broken" or s.turns < 0:
			chip.tooltip_text = "%s\n%s" % [s.label, s.desc]
		_chips_root.add_child(chip)
		var tag := Label.new()
		tag.text = s.short
		tag.add_theme_font_size_override("font_size", 9 if chip_w > 16.0 else 10)
		tag.add_theme_color_override("font_color", Color(0.05, 0.05, 0.08))
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.position = chip.position
		tag.size = Vector2(chip_w, 16)
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_chips_root.add_child(tag)
		x += chip_w + 2.0


# Cropped close-up of the character for the initiative bar (the raw frame
# is mostly empty space around a small figure).
func portrait() -> Texture2D:
	var src := _idle_texture as AtlasTexture
	if src == null:
		return _idle_texture
	var crop := AtlasTexture.new()
	crop.atlas = src.atlas
	crop.region = Rect2(src.region.position + Vector2(28, 18), Vector2(44, 60))
	return crop


func play_anim(anim_name: String) -> void:
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)


func return_to_idle() -> void:
	if not dead:
		sprite.play("idle")


# ---------- damage / healing ----------

# Applies damage + Pressure. Returns what happened so battle.gd can react.
func take_hit(amount: int, pressure_add: int) -> Dictionary:
	# Barrier absorbs damage (not Pressure) before HP is touched.
	for s in statuses:
		if s.id == "barrier" and s.power > 0:
			var absorbed: int = mini(s.power, amount)
			amount -= absorbed
			s.power -= absorbed
			float_text("Absorbed %d" % absorbed, Color(0.4, 0.85, 0.95))
			if s.power <= 0:
				remove_status("barrier")
			break
	hp = maxi(hp - amount, 0)
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	if enraged_ranks > 0 and amount > 0:
		enraged_stacks += enraged_ranks
		turns_since_damaged = 0
	# Mana Shield: half the pain flows back as Mana.
	if has_status("mana_shield") and resource_name == "Mana" and amount > 0:
		var converted := maxi(int(amount * 0.5), 1)
		resource = mini(resource + converted, max_resource)
		float_text("+%d Mana" % converted, Color(0.5, 0.7, 1.0))
	# Constitution: break resistance (100 = neutral; higher takes less Pressure).
	pressure_add = int(round(pressure_add * 100.0 / maxf(constitution, 1.0)))
	if has_status("ward"):
		pressure_add = int(pressure_add * 0.5)
	if has_status("devotion"):
		pressure_add = int(pressure_add * 0.85)
	var just_broke := false
	var applied_bd := 0
	if not broken:
		applied_bd = pressure_add
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
	return {"died": dead, "broke": just_broke, "bd": applied_bd}


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


# White flash + knockback nudge when struck. `dir` points away from the attacker.
func hit_react(dir: Vector2) -> void:
	sprite.self_modulate = Color(2.5, 2.5, 2.5)
	var flash := create_tween()
	flash.tween_property(sprite, "self_modulate", _base_tint, 0.25)
	var origin := position
	var nudge := create_tween()
	nudge.tween_property(self, "position", origin + dir * 10.0, 0.06)
	nudge.tween_property(self, "position", origin, 0.12)


# Brings a KO'd unit back at a fraction of max HP.
func revive(pct: float) -> void:
	dead = false
	hp = maxi(int(max_hp * pct), 1)
	pressure = 0
	modulate = Color.WHITE
	sprite.self_modulate = _base_tint
	sprite.play("idle")
	refresh_bars()


func recover_from_break() -> void:
	broken = false
	pressure = 0
	modulate = Color.WHITE
	remove_status("broken")
	refresh_bars()


func heal_amount(amount: int) -> void:
	hp = mini(hp + amount, max_hp)
	refresh_bars()


var _float_stack := 0  # staggers rapid floating texts so they don't overlap


func float_text(text: String, color: Color, big := false) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 46 if big else 22)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 8 if big else 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	label.position = Vector2(randf_range(-34, -6),
		(-96 if big else -80) - _float_stack * 20)
	label.z_index = 10
	add_child(label)
	_float_stack += 1
	if is_inside_tree():
		get_tree().create_timer(0.55).timeout.connect(
			func(): _float_stack = maxi(_float_stack - 1, 0))
	var tween := create_tween()
	if big:
		# Crit pop: number explodes onto the screen, hangs, then fades.
		label.pivot_offset = Vector2(30, 25)
		label.scale = Vector2(0.2, 0.2)
		tween.tween_property(label, "scale", Vector2(1.35, 1.35), 0.18) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.12)
		tween.tween_interval(0.35)
		tween.set_parallel(true)
		tween.tween_property(label, "position:y", label.position.y - 55, 0.6)
		tween.tween_property(label, "modulate:a", 0.0, 0.6)
		tween.chain().tween_callback(label.queue_free)
	else:
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
