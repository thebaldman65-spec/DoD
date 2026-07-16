# One combatant on the battlefield: sprite, animations, stats, HP/Pressure bars,
# and status effects (buffs/debuffs). Built in code from horizontal strip
# sprite sheets (square frames; 100px for the stock sheets, per-unit sizes ok).
class_name BattleUnit
extends Node2D

signal clicked

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
const OUTLINE_SHADER := preload("res://shaders/outline.gdshader")

# Weakness mechanic: a unit WEAK to a damage type takes 25% extra damage
# from it (stored as a negative resist, so resists and weaknesses stack).
const WEAKNESS_EXTRA := 0.25

var frame_size := 100      # square frame edge of this unit's sprite strips
var portrait_path := ""    # dedicated portrait art (falls back to a sheet crop)
var hero_key := ""         # class id ("warrior"...) — display name may be the spec
var walks_to_target := false  # real locomotion: walk to melee range and back
var counter_attacks := 0      # Counter Attack: answers a parry with a basic attack
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
var block_chance := 0.0    # Block: fully negates an incoming attack (pure tanks)
var dmg_bonus := 0.0       # global damage multiplier bonus (relics)
var type_dmg_bonus := {}   # dmg_type -> bonus fraction (relics)
var bleed_buildup := 0     # bleeds out at 100
var resists := {}          # dmg_type -> fraction reduced (negative = vulnerable)
var abilities: Array = []
var cooldowns := {}        # ability display_name -> turns until usable again
var mana_regen_bonus := 0        # class passive: Mage Evocation
var healing_received_mult := 1.0 # class passive: Cleric Holy Conduit

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
# Fixed-tree talent stats (0/0.0 = not learned). See talents.gd for sources.
var bleed_bonus := 0          # Savagery: extra Bleed on bleed-building abilities
var bloodrage_step_bonus := 0.0  # Unstoppable: adds to Blood Frenzy's 2%/step
var pierce_bonus := 0.0       # flat armor penetration from talents
var dmg_taken_bonus := 0.0    # Reckless Fury: takes more damage
var enraged_ranks := 0        # Enraged: stacks when dropping below 50% HP
var enraged_stacks := 0       # current Enraged stacks (max 3)
var enraged_timer := 0        # turns left on the Enraged buff
var below_half_last := false  # edge detection for Enraged triggers
var bloodcraze := 0           # Bloodcraze ranks: heal % max HP on enemy bleedout
var unrelenting_ranks := 0    # Unrelenting Assault: +con when dropping below 25%
var unrelenting_cd := 0
var hemorrhage_ranks := 0     # Hemorrhage: cripple at high bleed buildup
var crushing_blows_ranks := 0 # Crushing Blows: armor pen per enemy-party bleed
var precision_ranks := 0      # Precision Strikes: crit vs dazed/crippled/exposed
var opportunist := 0          # Opportunist: counter enemy misses with Overpower
var blade_crit_ranks := 0     # Seasoned Fighter node: crit for Lunge/Overpower
var pommel_parry_bonus := 0.0 # Swordsmanship: bigger perfect-Pommel parry buff
var high_guard := 0           # High Guard: -25% damage 1 turn after parrying
var dominant_ranks := 0       # Dominant Presence: armor per debuff applied
var debuffs_applied := 0
var unkillable_ranks := 0     # Unkillable: heal on block
var elem_weak_ranks := 0      # Elemental Weakness: Crushing Blow resist shred
var tank_spank_ranks := 0     # Tank and Spank: Mocking Blow empowers an ally
var ricochet_ranks := 0       # Richocet: chance to stun on block
var endurance_ranks := 0      # Endurance: armor per unhealed turn
var endurance_stacks := 0
var healed_externally := false
var iron_will_ranks := 0      # Iron Will: damage per own debuff
var sundering_ranks := 0      # Sundering: Crushing Blow BD splash
var tenacity := 0             # PENDING the Hardiness mechanic
var rally := 0                # PENDING the Hardiness mechanic
var seasoned_def_bonus := 0.0 # Defensive Stance: deeper under-half reduction
var seasoned_off_bonus := 0.0 # Aggressive Stance: bigger over-half bonus

# Active statuses: {id, label, short, color, turns}
var statuses: Array = []

var sprite: AnimatedSprite2D
var _plate_root: Node2D    # nameplate container owned by the battle scene
var _plate_panel: Panel
var _plate_style: StyleBoxFlat
var _plate_active := false # gold border: it's this unit's turn
var _plate_hover := false  # light border: hovered / targeted
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
	# Weaknesses: listed damage types hit this unit 25% harder.
	for weak_type in config.get("weak", []):
		resists[weak_type] = float(resists.get(weak_type, 0.0)) - WEAKNESS_EXTRA
	hp = max_hp
	# Default scale sized for the 1:1 full-scene camera.
	_build_sprite(config["sheet_dir"], config.get("sprite_scale", 3.2))
	_build_target_zone()
	# Bars/name/chips live on an off-sprite nameplate: the battle scene calls
	# build_plate() with a root it positions in the party's plate stack.


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
		"attack03": ["Attack03", 12, false],
		"hurt": ["Hurt", 12, false],
		"death": ["Death", 10, false],
	}
	for anim_name in anims:
		var info: Array = anims[anim_name]
		var path := "%s/%s_%s.png" % [sheet_dir, prefix, info[0]]
		if not FileAccess.file_exists(path):
			continue
		var tex: Texture2D = load(path)
		if tex == null:
			continue
		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, info[1])
		frames.set_animation_loop(anim_name, info[2])
		var count := int(tex.get_width() / float(frame_size))
		for i in count:
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = Rect2(i * frame_size, 0, frame_size, frame_size)
			frames.add_frame(anim_name, atlas)
		if anim_name == "idle":
			_idle_texture = frames.get_frame_texture("idle", 0)
	# Partial sheets (test art) borrow the closest available look: missing
	# attack variants replay Attack01; missing Hurt/Death hold the idle frame
	# (the death pause + dark modulate still read as a corpse).
	for attack_variant in ["attack02", "attack03"]:
		if not frames.has_animation(attack_variant) and frames.has_animation("attack01"):
			frames.add_animation(attack_variant)
			frames.set_animation_speed(attack_variant, 12)
			frames.set_animation_loop(attack_variant, false)
			for i in frames.get_frame_count("attack01"):
				frames.add_frame(attack_variant, frames.get_frame_texture("attack01", i))
	for still_anim in ["hurt", "death"]:
		if not frames.has_animation(still_anim) and _idle_texture != null:
			frames.add_animation(still_anim)
			frames.set_animation_speed(still_anim, 10)
			frames.set_animation_loop(still_anim, false)
			frames.add_frame(still_anim, _idle_texture)
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


# Nameplate dimensions (plain styling until final UI assets arrive).
const PLATE_W := 144.0
const PLATE_BAR_W := 96.0
const PLATE_BAR_X := 42.0  # bars sit right of the 34px portrait column


# Builds this unit's nameplate (portrait, name, HP/resource/Break bars,
# status chips) into `root` — a node the battle scene positions in the
# party's plate stack, NOT a child of the unit (sprites move; plates don't).
func build_plate(root: Node2D) -> void:
	_plate_root = root
	_plate_style = StyleBoxFlat.new()
	_plate_style.bg_color = Color(0.08, 0.06, 0.10, 0.88)
	_plate_style.border_color = Color(0.32, 0.30, 0.38)
	_plate_style.set_border_width_all(1)
	_plate_style.set_corner_radius_all(4)
	_plate_panel = Panel.new()
	_plate_panel.add_theme_stylebox_override("panel", _plate_style)
	# Hovering a plate highlights its unit on the field (and vice versa is
	# unnecessary — the plate is always in the same stack slot).
	_plate_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_plate_panel.mouse_entered.connect(set_highlight.bind(true))
	_plate_panel.mouse_exited.connect(set_highlight.bind(false))
	root.add_child(_plate_panel)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.add_theme_font_override("font", NAME_FONT)
	name_label.add_theme_font_size_override("font_size", 11)
	name_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
	name_label.position = Vector2(5, 1)
	name_label.size = Vector2(PLATE_W - 10, 14)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_plate_panel.add_child(name_label)

	var face := TextureRect.new()
	face.texture = portrait()
	face.position = Vector2(3, 16)
	face.custom_minimum_size = Vector2(34, 34)
	face.size = Vector2(34, 34)
	face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	face.flip_h = not is_hero
	face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_plate_panel.add_child(face)

	var y := 17.0
	_plate_panel.add_child(_make_bar_bg(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 10)))
	_hp_fill = _make_fill(Vector2(PLATE_BAR_X + 1, y + 1), Vector2(PLATE_BAR_W, 8),
		Color(0.30, 0.78, 0.32))
	_plate_panel.add_child(_hp_fill)
	_hp_text = _make_bar_text(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 10), 8)
	_plate_panel.add_child(_hp_text)
	y += 12.0
	if resource_name != "":
		_plate_panel.add_child(_make_bar_bg(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9)))
		var res_color := Color(0.85, 0.30, 0.25) if resource_name == "Rage" else \
			(Color(0.55, 0.85, 0.40) if resource_name == "Focus" else Color(0.30, 0.50, 0.90))
		_res_fill = _make_fill(Vector2(PLATE_BAR_X + 1, y + 1), Vector2(PLATE_BAR_W, 7), res_color)
		_plate_panel.add_child(_res_fill)
		_res_text = _make_bar_text(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9), 8)
		_plate_panel.add_child(_res_text)
		y += 11.0
	if second_resource_name != "":
		_plate_panel.add_child(_make_bar_bg(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9)))
		var res2_color := Color(0.95, 0.80, 0.30) if second_resource_name == "Faith" \
			else Color(0.75, 0.40, 0.95)
		_res2_fill = _make_fill(Vector2(PLATE_BAR_X + 1, y + 1), Vector2(PLATE_BAR_W, 7), res2_color)
		_plate_panel.add_child(_res2_fill)
		_res2_text = _make_bar_text(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9), 8)
		_plate_panel.add_child(_res2_text)
		y += 11.0
	_plate_panel.add_child(_make_bar_bg(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9)))
	_pressure_fill = _make_fill(Vector2(PLATE_BAR_X + 1, y + 1), Vector2(PLATE_BAR_W, 7),
		Color(0.80, 0.35, 1.0))
	_plate_panel.add_child(_pressure_fill)
	_pressure_text = _make_bar_text(Vector2(PLATE_BAR_X, y), Vector2(PLATE_BAR_W + 2, 9), 8)
	_plate_panel.add_child(_pressure_text)
	y += 11.0

	# Chips run full width under the portrait + bars.
	var chips_y := maxf(y, 52.0)
	_chips_root = Node2D.new()
	_chips_root.position = Vector2(5, chips_y + 2.0)
	_plate_panel.add_child(_chips_root)
	_plate_panel.size = Vector2(PLATE_W, chips_y + 17.0)


# Border states: gold = this unit's turn; light = hovered/targeted.
func set_plate_active(on: bool) -> void:
	_plate_active = on
	_update_plate_border()


func _set_plate_hover(on: bool) -> void:
	_plate_hover = on
	_update_plate_border()


func _update_plate_border() -> void:
	if _plate_style == null:
		return
	if _plate_active:
		_plate_style.border_color = Color(0.95, 0.80, 0.30)
		_plate_style.set_border_width_all(2)
		_plate_style.bg_color = Color(0.13, 0.10, 0.14, 0.92)
	elif _plate_hover:
		_plate_style.border_color = Color(0.80, 0.82, 0.90)
		_plate_style.set_border_width_all(2)
		_plate_style.bg_color = Color(0.08, 0.06, 0.10, 0.88)
	else:
		_plate_style.border_color = Color(0.32, 0.30, 0.38)
		_plate_style.set_border_width_all(1)
		_plate_style.bg_color = Color(0.08, 0.06, 0.10, 0.88)


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
	_target_btn.mouse_entered.connect(_on_target_hover.bind(true))
	_target_btn.mouse_exited.connect(_on_target_hover.bind(false))
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


# Battlefield highlight driven by hovering the initiative bar, a nameplate,
# or Tab-targeting: grow the sprite, draw a white outline, light the plate.
func set_highlight(on: bool) -> void:
	var factor := 1.3 if on else 1.0
	sprite.scale = Vector2(_base_scale * factor, _base_scale * factor)
	sprite.material.set_shader_parameter("outline_on", on)
	_target_marker.visible = on or _target_btn.visible
	_set_plate_hover(on)


# Hovering a targetable unit lightens the sprite and lights its nameplate.
func _on_target_hover(on: bool) -> void:
	sprite.self_modulate = _base_tint.lightened(0.45) if on else _base_tint
	_set_plate_hover(on)


func set_targetable(on: bool) -> void:
	_target_btn.visible = on
	_target_marker.visible = on
	if not on:
		sprite.self_modulate = _base_tint
		_set_plate_hover(false)


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
	_hp_fill.size.x = PLATE_BAR_W * clampf(hp / float(max_hp), 0.0, 1.0)
	_hp_text.text = "%d/%d" % [hp, max_hp]
	if _res_fill != null:
		_res_fill.size.x = PLATE_BAR_W * clampf(resource / float(max_resource), 0.0, 1.0)
		_res_text.text = "%s %d/%d" % [resource_name, resource, max_resource]
	if _res2_fill != null:
		_res2_fill.size.x = PLATE_BAR_W * clampf(second_resource / float(second_max), 0.0, 1.0)
		if second_resource_name == "Resonance":
			_res2_text.text = "%d/%d (+%d%% dmg)" % [second_resource, second_max,
				second_resource * 15]
		else:
			_res2_text.text = "%s %d/%d" % [second_resource_name, second_resource, second_max]
	if passive_id == "bloodrage":
		for s in statuses:
			if s.id == "spec_passive":
				var step := 2.0 + bloodrage_step_bonus
				var steps := int((1.0 - hp / float(max_hp)) * 100.0 / 5.0)
				var bonus := step * steps
				s.short = "+%d%%" % int(round(bonus))
				s.desc = "Blood Frenzy: +%.1f%% damage per 5%% HP missing.\nCurrently +%.1f%% (%d steps)." % [
					step, bonus, steps]
				_refresh_chips()
				break
	# Seasoned Fighter chip shows which side of the stance switch is live.
	if passive_id == "seasoned":
		for s in statuses:
			if s.id == "spec_passive":
				var offense := hp > max_hp * 0.5
				var off_pct := int(round((0.15 + seasoned_off_bonus) * 100))
				var def_pct := int(round((0.15 + seasoned_def_bonus) * 100))
				s.short = "+dmg" if offense else "-dmg"
				s.desc = "Seasoned Fighter: currently %s." % (
					("+%d%% damage dealt (above half HP)" % off_pct) if offense
					else ("%d%% less damage taken (at or below half HP)" % def_pct))
				_refresh_chips()
				break
	var pressure_ratio := clampf(pressure / float(stability), 0.0, 1.0)
	_pressure_fill.size.x = PLATE_BAR_W * pressure_ratio
	_pressure_text.text = "Break %d/%d" % [pressure, stability]
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


# ---------- cooldowns ----------

func tick_cooldowns() -> void:
	for ab_name in cooldowns.keys():
		cooldowns[ab_name] = maxi(int(cooldowns[ab_name]) - 1, 0)
	if unrelenting_cd > 0:
		unrelenting_cd -= 1
	if enraged_timer > 0:
		enraged_timer -= 1
		if enraged_timer == 0:
			enraged_stacks = 0
			float_text("Enraged fades", Color(0.7, 0.5, 0.4))


func ability_ready(ab: Ability) -> bool:
	return int(cooldowns.get(ab.display_name, 0)) <= 0


func cooldown_left(ab: Ability) -> int:
	return int(cooldowns.get(ab.display_name, 0))


# +1 because the counter ticks at this unit's next turn start: the ability
# stays unusable for exactly `cooldown` of its turns after use.
func start_cooldown(ab: Ability) -> void:
	if ab.cooldown > 0:
		cooldowns[ab.display_name] = ab.cooldown + 1


func effective_speed() -> float:
	var s := speed * (0.75 if (has_status("slow") or has_status("chilled")) else 1.0)
	if has_status("quickdraw"):
		s *= 1.5
	if has_status("wrath"):
		s *= 1.15
	return s


func effective_armor() -> float:
	var a := armor
	# Dominant Presence: armor value grows 5%/rank per debuff applied.
	if dominant_ranks > 0 and debuffs_applied > 0:
		a *= 1.0 + 0.05 * dominant_ranks * debuffs_applied
	# Endurance: +3%/rank armor per turn without an external heal.
	a += 0.03 * endurance_ranks * endurance_stacks
	if has_status("fortify"):
		a += 0.10
	if broken:
		a *= 0.7
	if has_status("sunder"):
		a *= 0.65
	return minf(a, 0.85)


func _refresh_chips() -> void:
	for child in _chips_root.get_children():
		child.queue_free()
	var count := statuses.size()
	if count == 0:
		return
	# Left-aligned inside the nameplate's chip row.
	var x := 0.0
	for i in count:
		var s: Dictionary = statuses[i]
		var chip_w := 12.0 if String(s.short).length() <= 2 else 26.0
		var chip := ColorRect.new()
		chip.position = Vector2(x, 0)
		chip.size = Vector2(chip_w, 12)
		chip.color = s.color
		chip.mouse_filter = Control.MOUSE_FILTER_STOP
		chip.tooltip_text = "%s (%s turn%s left)\n%s" % [
			s.label, s.turns, "" if s.turns == 1 else "s", s.desc]
		if s.id == "broken" or s.turns < 0:
			chip.tooltip_text = "%s\n%s" % [s.label, s.desc]
		_chips_root.add_child(chip)
		var tag := Label.new()
		tag.text = s.short
		tag.add_theme_font_size_override("font_size", 7 if chip_w > 12.0 else 8)
		tag.add_theme_color_override("font_color", Color(0.05, 0.05, 0.08))
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.position = chip.position
		tag.size = Vector2(chip_w, 12)
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_chips_root.add_child(tag)
		x += chip_w + 2.0


# Portrait for the initiative bar and nameplate: dedicated art when the unit
# has it, otherwise a close-up crop of the idle frame (which is mostly empty
# space around a small figure). Crop scales with frame size.
func portrait() -> Texture2D:
	if portrait_path != "" and FileAccess.file_exists(portrait_path):
		return load(portrait_path)
	var src := _idle_texture as AtlasTexture
	if src == null:
		return _idle_texture
	var crop := AtlasTexture.new()
	crop.atlas = src.atlas
	var f := float(frame_size)
	crop.region = Rect2(src.region.position + Vector2(f * 0.28, f * 0.18),
		Vector2(f * 0.44, f * 0.60))
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
	var was_above_half := hp > max_hp * 0.5
	var was_above_quarter := hp > max_hp * 0.25
	hp = maxi(hp - amount, 0)
	# Hold the Line: the party cannot die while the blessing holds.
	if hp == 0 and has_status("undying"):
		hp = 1
		float_text("HELD THE LINE", Color(0.95, 0.85, 0.4))
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	# Enraged (talent): dropping below half HP grants a stacking damage buff.
	if enraged_ranks > 0 and was_above_half and hp <= max_hp * 0.5 and hp > 0:
		enraged_stacks = mini(enraged_stacks + 1, 3)
		enraged_timer = 5
		float_text("ENRAGED x%d" % enraged_stacks, Color(0.9, 0.35, 0.3))
	# Unrelenting Assault (talent): dropping below 25% HP grants Constitution
	# (at most once every 5 turns).
	if unrelenting_ranks > 0 and was_above_quarter and hp <= max_hp * 0.25 \
			and hp > 0 and unrelenting_cd == 0:
		constitution += 10 * unrelenting_ranks
		unrelenting_cd = 5
		float_text("+%d Constitution" % (10 * unrelenting_ranks), Color(0.7, 0.8, 0.95))
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
	if has_status("hold_bd"):
		pressure_add = int(pressure_add * 0.5)
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
	if hp == 0 and has_status("undying"):
		hp = 1
		float_text("HELD THE LINE", Color(0.95, 0.85, 0.4))
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
	if _plate_root != null:
		_plate_root.modulate = Color(0.52, 0.47, 0.55)
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
	if _plate_root != null:
		_plate_root.modulate = Color.WHITE
	sprite.self_modulate = _base_tint
	sprite.play("idle")
	refresh_bars()


func recover_from_break() -> void:
	broken = false
	pressure = 0
	modulate = Color.WHITE
	remove_status("broken")
	refresh_bars()


# Heals respect Holy Conduit (healing_received_mult). `external` marks heals
# from another unit or an item — the Warden's Endurance talent resets on them.
func heal_amount(amount: int, external := false) -> void:
	var final := int(round(amount * healing_received_mult))
	hp = mini(hp + final, max_hp)
	if external and final > 0:
		healed_externally = true
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


# The plate lives outside this node's tree; take it along when freed
# (e.g. a Beastmaster companion being replaced).
func _exit_tree() -> void:
	if _plate_root != null and is_instance_valid(_plate_root):
		_plate_root.queue_free()
		_plate_root = null
