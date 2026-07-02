# Battle manager: builds the arena, runs the initiative loop, and owns all combat UI.
# Phase 1 prototype: 3 heroes vs 3 orcs, Pressure/Break, timing skill checks.
extends Node2D

signal _ability_picked(ability)
signal _target_picked(unit)
signal _skill_done(grade)

const BASIC_DELAY := 2.0

# Skill check zones (half-widths around the bar's center, 0..1 scale).
const PERFECT_HALF := 0.045
const GOOD_HALF := 0.16

# Visual identity of each status effect: [label, chip tag, color]
const STATUS_INFO := {
	"slow": ["Slow", "S", Color(0.5, 0.75, 1.0)],
	"burn": ["Burn", "F", Color(1.0, 0.55, 0.2)],
	"sunder": ["Sunder", "D", Color(0.7, 0.7, 0.7)],
	"ward": ["Ward", "W", Color(1.0, 0.85, 0.4)],
}

var heroes: Array = []
var enemies: Array = []
var battle_over := false

var ui: CanvasLayer
var turn_bar: HBoxContainer
var message_label: Label
var action_panel: PanelContainer
var action_box: HBoxContainer
var active_marker: Label
var target_buttons: Array = []

var sc_root: Control
var sc_cursor: ColorRect
var sc_result: Label
var sc_active := false
var sc_pos := 0.0
var sc_dir := 1.0


func _ready() -> void:
	_build_arena()
	_build_ui()
	_spawn_units()
	_run_battle()


# ---------- setup ----------

func _build_arena() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.09, 0.07, 0.11)
	add_child(bg)
	var floor_rect := ColorRect.new()
	floor_rect.position = Vector2(0, 340)
	floor_rect.size = Vector2(1280, 380)
	floor_rect.color = Color(0.13, 0.10, 0.14)
	add_child(floor_rect)


func _spawn_units() -> void:
	var soldier := "res://assets/sprites/soldier"
	var orc := "res://assets/sprites/orc"

	heroes.append(_make_unit({
		"unit_name": "Warrior", "is_hero": true, "sheet_dir": soldier,
		"max_hp": 140, "armor": 0.25, "speed": 95.0, "stability": 60,
		"resource_name": "Rage", "resource": 0, "max_resource": 100,
		"abilities": _warrior_kit(),
	}, Vector2(340, 400), Color.WHITE))
	heroes.append(_make_unit({
		"unit_name": "Mage", "is_hero": true, "sheet_dir": soldier,
		"max_hp": 90, "armor": 0.10, "speed": 110.0, "stability": 40,
		"resource_name": "Mana", "resource": 100, "max_resource": 100,
		"abilities": _mage_kit(),
	}, Vector2(230, 520), Color(0.65, 0.75, 1.0)))
	heroes.append(_make_unit({
		"unit_name": "Cleric", "is_hero": true, "sheet_dir": soldier,
		"max_hp": 110, "armor": 0.15, "speed": 100.0, "stability": 50,
		"resource_name": "Mana", "resource": 100, "max_resource": 100,
		"abilities": _cleric_kit(),
	}, Vector2(150, 630), Color(1.0, 0.9, 0.6)))

	enemies.append(_make_unit({
		"unit_name": "Orc Raider", "is_hero": false, "sheet_dir": orc,
		"max_hp": 110, "armor": 0.15, "speed": 90.0, "stability": 50,
		"abilities": _orc_kit(17, 26),
	}, Vector2(900, 400), Color.WHITE))
	enemies.append(_make_unit({
		"unit_name": "Orc Chief", "is_hero": false, "sheet_dir": orc,
		"max_hp": 190, "armor": 0.20, "speed": 80.0, "stability": 70,
		"abilities": _orc_kit(24, 34), "sprite_scale": 2.8,
	}, Vector2(1050, 510), Color(1.0, 0.75, 0.7)))
	enemies.append(_make_unit({
		"unit_name": "Orc Raider", "is_hero": false, "sheet_dir": orc,
		"max_hp": 110, "armor": 0.15, "speed": 90.0, "stability": 50,
		"abilities": _orc_kit(17, 26),
	}, Vector2(940, 630), Color.WHITE))

	for u in heroes + enemies:
		u.next_time = (100.0 / u.speed) * randf_range(0.0, 1.0)


func _make_unit(config: Dictionary, pos: Vector2, tint: Color) -> BattleUnit:
	var u := BattleUnit.new()
	u.position = pos
	add_child(u)
	u.setup(config)
	u.sprite.self_modulate = tint
	u.refresh_bars()
	return u


func _warrior_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "cost": 0, "damage": 16, "pressure": 10,
			"resource_gain": 15, "delay": 2.0, "anim": "attack01",
			"perfect_id": "rage", "perfect_text": "+10 bonus Rage",
			"description": "Basic attack. Builds 15 Rage."}),
		Ability.make({"display_name": "Heavy Strike", "cost": 30, "damage": 34, "pressure": 18,
			"delay": 4.0, "anim": "attack02",
			"perfect_id": "pressure", "perfect_text": "+60% Pressure",
			"description": "Big single-target damage."}),
		Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 20, "pressure": 28,
			"delay": 4.0, "anim": "attack03",
			"perfect_id": "sunder", "perfect_text": "Sunders armor (-30%) for 2 turns",
			"description": "Moderate damage, huge Pressure."}),
	]


func _mage_kit() -> Array:
	return [
		Ability.make({"display_name": "Magic Bolt", "cost": 0, "damage": 14, "pressure": 8,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "mana", "perfect_text": "Restores 10 Mana",
			"description": "Basic arcane projectile."}),
		Ability.make({"display_name": "Fireball", "cost": 25, "damage": 32, "pressure": 12,
			"delay": 4.0, "anim": "attack02",
			"perfect_id": "burn", "perfect_text": "Sets the target ablaze (6 dmg/turn, 2 turns)",
			"description": "Heavy fire damage."}),
		Ability.make({"display_name": "Frost Spike", "cost": 20, "damage": 18, "pressure": 10,
			"delay": 3.0, "anim": "attack03",
			"applies_status": {"id": "slow", "turns": 2},
			"perfect_id": "slow_plus", "perfect_text": "Slow lasts 4 turns instead of 2",
			"description": "Damages and Slows the target (-25% speed)."}),
	]


func _cleric_kit() -> Array:
	return [
		Ability.make({"display_name": "Smite", "cost": 0, "damage": 12, "pressure": 10,
			"delay": 2.0, "anim": "attack01",
			"perfect_id": "self_heal", "perfect_text": "Cleric recovers 8 HP",
			"description": "Basic radiant strike."}),
		Ability.make({"display_name": "Mend Wounds", "cost": 25, "heal": 38,
			"target": Ability.Target.ALLY, "delay": 3.0, "anim": "attack02",
			"perfect_id": "ward", "perfect_text": "Grants Ward (-50% Pressure taken, 2 turns)",
			"description": "Restore HP to one ally."}),
		Ability.make({"display_name": "Radiant Burst", "cost": 20, "damage": 18, "pressure": 14,
			"delay": 3.0, "anim": "attack03",
			"perfect_id": "pressure", "perfect_text": "+60% Pressure",
			"description": "Holy damage with solid Pressure."}),
	]


func _orc_kit(light_dmg: int, heavy_dmg: int) -> Array:
	return [
		Ability.make({"display_name": "Slash", "damage": light_dmg, "pressure": 10,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Smash", "damage": heavy_dmg, "pressure": 16,
			"delay": 4.0, "anim": "attack02"}),
	]


# ---------- UI ----------

func _build_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)

	var bar_panel := PanelContainer.new()
	bar_panel.position = Vector2(16, 12)
	ui.add_child(bar_panel)
	turn_bar = HBoxContainer.new()
	turn_bar.add_theme_constant_override("separation", 6)
	bar_panel.add_child(turn_bar)

	message_label = Label.new()
	message_label.position = Vector2(340, 70)
	message_label.size = Vector2(600, 30)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 20)
	ui.add_child(message_label)

	action_panel = PanelContainer.new()
	action_panel.position = Vector2(400, 630)
	ui.add_child(action_panel)
	action_box = HBoxContainer.new()
	action_box.add_theme_constant_override("separation", 10)
	action_panel.add_child(action_box)
	action_panel.visible = false

	active_marker = Label.new()
	active_marker.text = "▼"
	active_marker.add_theme_font_size_override("font_size", 26)
	active_marker.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	active_marker.visible = false
	add_child(active_marker)

	_build_skill_check_ui()


func _build_skill_check_ui() -> void:
	sc_root = Control.new()
	sc_root.position = Vector2(420, 470)
	sc_root.visible = false
	ui.add_child(sc_root)

	var bg := Panel.new()
	bg.size = Vector2(440, 74)
	sc_root.add_child(bg)

	var hint := Label.new()
	hint.text = "Press SPACE!"
	hint.position = Vector2(0, 4)
	hint.size = Vector2(440, 18)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	sc_root.add_child(hint)

	var track := ColorRect.new()
	track.position = Vector2(10, 34)
	track.size = Vector2(420, 20)
	track.color = Color(0.15, 0.12, 0.18)
	sc_root.add_child(track)

	var good_zone := ColorRect.new()
	good_zone.position = Vector2(10 + (0.5 - GOOD_HALF) * 420, 34)
	good_zone.size = Vector2(GOOD_HALF * 2 * 420, 20)
	good_zone.color = Color(0.35, 0.5, 0.3)
	sc_root.add_child(good_zone)

	var perfect_zone := ColorRect.new()
	perfect_zone.position = Vector2(10 + (0.5 - PERFECT_HALF) * 420, 34)
	perfect_zone.size = Vector2(PERFECT_HALF * 2 * 420, 20)
	perfect_zone.color = Color(0.9, 0.8, 0.3)
	sc_root.add_child(perfect_zone)

	sc_cursor = ColorRect.new()
	sc_cursor.size = Vector2(5, 28)
	sc_cursor.position = Vector2(10, 30)
	sc_cursor.color = Color.WHITE
	sc_root.add_child(sc_cursor)

	sc_result = Label.new()
	sc_result.position = Vector2(0, 56)
	sc_result.size = Vector2(440, 18)
	sc_result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sc_result.add_theme_font_size_override("font_size", 15)
	sc_root.add_child(sc_result)


func _message(text: String) -> void:
	message_label.text = text


func _rebuild_turn_bar() -> void:
	for child in turn_bar.get_children():
		child.queue_free()
	var alive := (heroes + enemies).filter(func(u): return not u.dead)
	if alive.is_empty():
		return
	var sim: Array = alive.map(func(u): return {"unit": u, "t": u.next_time})
	for i in 10:
		var best: Dictionary = sim[0]
		for entry in sim:
			if entry.t < best.t:
				best = entry
		var u: BattleUnit = best.unit
		var slot := VBoxContainer.new()
		var portrait := TextureRect.new()
		portrait.texture = u.portrait()
		portrait.custom_minimum_size = Vector2(42, 42)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.flip_h = not u.is_hero
		slot.add_child(portrait)
		var stripe := ColorRect.new()
		stripe.custom_minimum_size = Vector2(42, 4)
		stripe.color = Color(0.35, 0.8, 0.4) if u.is_hero else Color(0.85, 0.3, 0.3)
		slot.add_child(stripe)
		turn_bar.add_child(slot)
		best.t += BASIC_DELAY * 100.0 / u.effective_speed()


# ---------- battle loop ----------

func _run_battle() -> void:
	await _wait(0.6)
	_message("The Decay stirs...")
	await _wait(0.8)
	while not battle_over:
		_rebuild_turn_bar()
		var u := _next_unit()
		if u == null:
			break
		active_marker.visible = true
		active_marker.position = u.position + Vector2(-11, -130)
		if u.has_status("burn"):
			var burned_out: bool = u.take_tick_damage(6, "-6 Burn", STATUS_INFO["burn"][2])
			await _wait(0.5)
			if burned_out:
				_message("%s burns away!" % u.unit_name)
				_check_end()
				continue
		u.tick_statuses()
		if u.broken_pending:
			u.broken_pending = false
			_message("%s is Broken and loses their turn!" % u.unit_name)
			await _wait(1.0)
			u.recover_from_break()
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			continue
		if u.is_hero:
			await _player_turn(u)
		else:
			await _enemy_turn(u)
		_check_end()
	active_marker.visible = false


func _next_unit() -> BattleUnit:
	var alive := (heroes + enemies).filter(func(u): return not u.dead)
	if alive.is_empty():
		return null
	var best: BattleUnit = alive[0]
	for u in alive:
		if u.next_time < best.next_time:
			best = u
	return best


func _player_turn(u: BattleUnit) -> void:
	if u.resource_name == "Mana":
		u.resource = mini(u.resource + 12, u.max_resource)
	_message("%s's turn — choose an ability" % u.unit_name)
	u.show_info()
	_show_actions(u)
	var ab = await _ability_picked
	action_panel.visible = false

	var pool: Array
	if ab.target == Ability.Target.ALLY:
		pool = heroes.filter(func(h): return not h.dead)
	else:
		pool = enemies.filter(func(e): return not e.dead)
	var target: BattleUnit
	if pool.size() == 1:
		target = pool[0]
	else:
		_message("Choose a target")
		target = await _pick_target(pool)

	var grade: String = await _run_skill_check()
	await _resolve(u, ab, target, grade)
	u.hide_info()


func _show_actions(u: BattleUnit) -> void:
	for child in action_box.get_children():
		child.queue_free()
	for ab in u.abilities:
		var btn := Button.new()
		var cost_text: String = "Free" if ab.cost == 0 else "%d %s" % [ab.cost, u.resource_name]
		btn.text = "%s\n(%s)" % [ab.display_name, cost_text]
		btn.custom_minimum_size = Vector2(150, 58)
		btn.tooltip_text = ab.description
		if ab.perfect_text != "":
			btn.tooltip_text += "\nPerfect: %s" % ab.perfect_text
		btn.disabled = ab.cost > u.resource
		btn.pressed.connect(func(): _ability_picked.emit(ab))
		action_box.add_child(btn)
	action_panel.visible = true


func _pick_target(pool: Array) -> BattleUnit:
	for t in pool:
		var btn := Button.new()
		btn.text = "▶ %s" % t.unit_name
		btn.position = t.position + Vector2(-55, -160)
		btn.size = Vector2(110, 30)
		btn.pressed.connect(func(): _target_picked.emit(t))
		ui.add_child(btn)
		target_buttons.append(btn)
	var chosen = await _target_picked
	for btn in target_buttons:
		btn.queue_free()
	target_buttons.clear()
	return chosen


func _enemy_turn(u: BattleUnit) -> void:
	_message("%s attacks!" % u.unit_name)
	await _wait(0.7)
	var living := heroes.filter(func(h): return not h.dead)
	if living.is_empty():
		return
	var target: BattleUnit
	var ab: Ability
	var broken_heroes := living.filter(func(h): return h.broken)
	if not broken_heroes.is_empty():
		# Exploit a Broken hero with the heaviest attack available.
		target = _lowest_hp(broken_heroes)
		ab = u.abilities[1]
		_message("%s exploits the Break!" % u.unit_name)
		await _wait(0.4)
	else:
		# Prefer finishing off wounded heroes; sometimes spread damage.
		target = _lowest_hp(living) if randf() < 0.65 else living.pick_random()
		ab = u.abilities[1] if randf() < 0.35 else u.abilities[0]
	await _resolve(u, ab, target, "good")


func _lowest_hp(pool: Array) -> BattleUnit:
	var best: BattleUnit = pool[0]
	for h in pool:
		if h.hp / float(h.max_hp) < best.hp / float(best.max_hp):
			best = h
	return best


func _resolve(attacker: BattleUnit, ab: Ability, target: BattleUnit, grade: String) -> void:
	attacker.resource = clampi(attacker.resource - ab.cost + ab.resource_gain, 0, attacker.max_resource)
	var dmg_mult := {"perfect": 1.15, "good": 1.0, "fail": 0.6}[grade] as float
	var pr_mult := {"perfect": 1.25, "good": 1.0, "fail": 0.5}[grade] as float
	var is_perfect := grade == "perfect"

	attacker.play_anim(ab.anim)
	await _wait(0.3)

	if ab.heal > 0:
		var amount := int(ab.heal * dmg_mult)
		target.heal_amount(amount)
		target.float_text("+%d" % amount, Color(0.4, 0.9, 0.45))
		_message("%s heals %s for %d" % [attacker.unit_name, target.unit_name, amount])
		if is_perfect and ab.perfect_id == "ward":
			_apply_status(target, "ward", 2)
	else:
		var crit_chance := 0.10 + (0.25 if target.broken else 0.0)
		var is_crit := randf() < crit_chance
		var raw := ab.damage * randf_range(0.9, 1.1) * dmg_mult
		if is_crit:
			raw *= 1.5
		var final := maxi(int(round(raw * (1.0 - target.effective_armor()))), 1)
		var pr := int(round(ab.pressure * pr_mult * (1.5 if is_crit else 1.0)))
		if is_perfect and ab.perfect_id == "pressure":
			pr = int(pr * 1.6)
		var result: Dictionary = target.take_hit(final, pr)
		target.float_text("%d%s" % [final, "!" if is_crit else ""],
			Color(1.0, 0.5, 0.2) if is_crit else Color(0.95, 0.85, 0.75))
		if ab.delay_push > 0.0:
			target.next_time += ab.delay_push * 100.0 / target.effective_speed()
		if not result.died and not ab.applies_status.is_empty():
			var turns: int = ab.applies_status["turns"]
			if is_perfect and ab.perfect_id == "slow_plus":
				turns = 4
			_apply_status(target, ab.applies_status["id"], turns)
		if is_perfect:
			_apply_perfect_bonus(attacker, target, ab, result.died)
		if result.broke:
			_message("%s BREAKS!" % target.unit_name)
			_shake()
			await _wait(0.5)
		if result.died:
			_message("%s falls!" % target.unit_name)
			await _wait(0.5)

	await _wait(0.45)
	attacker.return_to_idle()
	attacker.next_time += ab.delay * 100.0 / attacker.effective_speed()


func _apply_status(target: BattleUnit, id: String, turns: int) -> void:
	var info: Array = STATUS_INFO[id]
	target.add_status(id, info[0], info[1], info[2], turns)


# Unique bonus effects for Perfect skill checks (per ability).
func _apply_perfect_bonus(attacker: BattleUnit, target: BattleUnit, ab: Ability, target_died: bool) -> void:
	match ab.perfect_id:
		"rage":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.float_text("+10 Rage", Color(1.0, 0.5, 0.4))
		"mana":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
		"self_heal":
			attacker.heal_amount(8)
			attacker.float_text("+8", Color(0.4, 0.9, 0.45))
		"sunder":
			if not target_died:
				_apply_status(target, "sunder", 2)
		"burn":
			if not target_died:
				_apply_status(target, "burn", 2)


# ---------- skill check ----------

func _run_skill_check() -> String:
	sc_pos = 0.0
	sc_dir = 1.0
	sc_result.text = ""
	sc_root.visible = true
	sc_active = true
	var grade: String = await _skill_done
	match grade:
		"perfect":
			sc_result.text = "PERFECT!"
			sc_result.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		"good":
			sc_result.text = "Good"
			sc_result.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
		"fail":
			sc_result.text = "Miss..."
			sc_result.add_theme_color_override("font_color", Color(0.8, 0.4, 0.4))
	await _wait(0.45)
	sc_root.visible = false
	return grade


func _process(delta: float) -> void:
	if sc_active:
		sc_pos += sc_dir * delta / 0.72
		if sc_pos >= 1.0:
			sc_pos = 1.0
			sc_dir = -1.0
		elif sc_pos <= 0.0:
			sc_pos = 0.0
			sc_dir = 1.0
		sc_cursor.position.x = 10.0 + sc_pos * 420.0 - 2.0


func _unhandled_input(event: InputEvent) -> void:
	if sc_active and event.is_action_pressed("ui_accept"):
		sc_active = false
		var dist: float = absf(sc_pos - 0.5)
		var grade := "fail"
		if dist <= PERFECT_HALF:
			grade = "perfect"
		elif dist <= GOOD_HALF:
			grade = "good"
		_skill_done.emit(grade)


# ---------- end of battle ----------

func _check_end() -> void:
	if battle_over:
		return
	if enemies.all(func(e): return e.dead):
		battle_over = true
		_show_end("VICTORY", "The Decay recedes... for now.")
	elif heroes.all(func(h): return h.dead):
		battle_over = true
		_show_end("THE PARTY HAS FALLEN", "The cycle begins anew.")


func _show_end(title: String, subtitle: String) -> void:
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.55)
	ui.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(center)
	var panel := PanelContainer.new()
	center.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)
	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 36)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	var sub_label := Label.new()
	sub_label.text = subtitle
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(sub_label)
	var btn := Button.new()
	btn.text = "Fight Again"
	btn.custom_minimum_size = Vector2(180, 44)
	btn.pressed.connect(func(): get_tree().reload_current_scene())
	vbox.add_child(btn)


# ---------- helpers ----------

const PACE := 0.85  # global combat pacing multiplier (lower = faster fights)


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds * PACE).timeout


func _shake() -> void:
	var tween := create_tween()
	for i in 4:
		tween.tween_property(self, "position", Vector2(randf_range(-8, 8), randf_range(-6, 6)), 0.05)
	tween.tween_property(self, "position", Vector2.ZERO, 0.05)
