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

# Visual identity of each status effect: [label, chip tag, color, tooltip]
const STATUS_INFO := {
	"slow": ["Slow", "S", Color(0.5, 0.75, 1.0), "-25% speed; turns arrive later."],
	"burn": ["Burn", "F", Color(1.0, 0.55, 0.2), "Takes 6 damage at the start of each turn."],
	"bleed": ["Bleed", "Bl", Color(0.85, 0.25, 0.25), "Bleed builds with wounding attacks;\nat 100 the target bleeds out for 20% max HP."],
	"sunder": ["Sunder", "D", Color(0.7, 0.7, 0.7), "-35% armor."],
	"ward": ["Ward", "W", Color(1.0, 0.85, 0.4), "Takes 50% less Pressure."],
	"fortify": ["Fortify", "+D", Color(0.55, 0.8, 0.9), "+10% armor."],
	"barrier": ["Barrier", "Ba", Color(0.40, 0.85, 0.95), "Absorbs incoming damage."],
	"focus": ["Focus", "Fo", Color(0.35, 0.60, 1.0), "Restores 10 Mana each turn."],
	"renewal": ["Renewal", "R+", Color(0.45, 0.90, 0.50), "Restores 8 HP each turn."],
	"surge": ["Surge", "A+", Color(0.80, 0.50, 1.0), "+20% attack."],
	"guard": ["Guard", "G", Color(0.55, 0.65, 0.85), "-40% damage and -50% Pressure taken\nuntil this unit's next turn."],
	"mocked": ["Mocked", "M!", Color(0.95, 0.5, 0.3), "Must attack the Warrior who mocked them."],
	"poison": ["Poison", "P", Color(0.45, 0.8, 0.3), "Takes 6 damage at the start of each turn."],
	"marked": ["Marked", "Mk", Color(0.95, 0.8, 0.35), "+15% crit chance against this unit."],
	"camo": ["Camouflage", "Cm", Color(0.55, 0.7, 0.55), "Harder to hit; their next attack\ndeals +20% damage."],
	"shieldwall": ["Shieldwall", "SW", Color(0.6, 0.7, 0.9), "Takes 50% less damage."],
	"empower": ["Empower", "+A", Color(0.95, 0.45, 0.35), "+25% damage dealt."],
	"exposed": ["Exposed", "E", Color(0.95, 0.9, 0.4), "Takes 15% more damage."],
	"cripple": ["Cripple", "C", Color(0.5, 0.4, 0.55), "-15% damage dealt."],
	"retaliate": ["Retaliation", "R!", Color(0.95, 0.6, 0.25), "Counters attackers with a basic strike."],
}

# Placeholder SFX (procedurally generated, see repo history; replace with
# licensed audio later).
const SFX := {
	"hit": preload("res://assets/sfx/hit.wav"),
	"crit": preload("res://assets/sfx/crit.wav"),
	"break": preload("res://assets/sfx/break.wav"),
	"heal": preload("res://assets/sfx/heal.wav"),
	"miss": preload("res://assets/sfx/miss.wav"),
	"parry": preload("res://assets/sfx/parry.wav"),
	"click": preload("res://assets/sfx/click.wav"),
	"perfect": preload("res://assets/sfx/perfect.wav"),
	"death": preload("res://assets/sfx/death.wav"),
	"bomb": preload("res://assets/sfx/bomb.wav"),
	"victory": preload("res://assets/sfx/victory.wav"),
	"defeat": preload("res://assets/sfx/defeat.wav"),
}

# Damage-over-time statuses ticked at the start of the afflicted unit's turn.
const DOT_STATUSES := {"burn": 6, "poison": 6}

var heroes: Array = []
var enemies: Array = []
var battle_over := false
var current_hero: BattleUnit

# Shared party inventory built from Run.ITEM_INFO: id -> [label, count, tooltip]
var items := {}
var item_used := false  # one item per character per turn

# Guard: universal defensive action available to every hero.
var guard_ability: Ability = Ability.make({"display_name": "Guard", "cost": 0,
	"special": "guard", "delay": 1.5, "anim": "idle",
	"perfect_id": "", "perfect_text": "Also sheds 10 Pressure immediately",
	"description": "Brace: take 40% less damage and 50% less\nPressure until your next turn. Quick action.\nMage: venting releases all Resonance."})

var ui: CanvasLayer
var cam: Camera2D
var turn_bar: HBoxContainer
var message_label: Label
var action_panel: PanelContainer
var action_box: HBoxContainer
var active_marker: Label

# Autoplay: heroes act automatically with a simple policy (no skill check UI).
#   DOD_AUTOPLAY=1 godot --headless          -> one battle with debug prints
#   DOD_SIM=200  godot --headless            -> 200 max-speed battles + stats report
var autoplay := false
var sim := false
var sim_target := 0
var debug_prints := false

# Accumulated across scene reloads within one simulation run.
static var sim_stats := {}
static var sim_done := 0
static var sim_started_ms := 0

var history: RichTextLabel

var sc_root: Control
var sc_cursor: ColorRect
var sc_result: Label
var sc_active := false
var sc_pos := 0.0
var sc_dir := 1.0


func _ready() -> void:
	sim_target = int(OS.get_environment("DOD_SIM"))
	sim = sim_target > 0
	autoplay = sim or OS.get_environment("DOD_AUTOPLAY") == "1"
	debug_prints = autoplay and not sim
	if sim:
		Engine.max_fps = 0
		if sim_started_ms == 0:
			sim_started_ms = Time.get_ticks_msec()
	_init_items()
	_build_arena()
	_build_ui()
	_build_sfx_pool()
	_spawn_units()
	_run_battle()


# ---------- setup ----------

func _init_items() -> void:
	var defaults := {"health": 2, "mana": 1, "bomb": 1, "revive": 1, "defense": 1}
	for id in Run.ITEM_IDS:
		var count: int = Run.items.get(id, 0) if Run.active else defaults[id]
		items[id] = [Run.ITEM_INFO[id][0], count, Run.ITEM_INFO[id][1]]


func _build_arena() -> void:
	var bg := ColorRect.new()
	bg.position = Vector2(-200, -100)
	bg.size = Vector2(1680, 920)
	bg.color = Color(0.09, 0.07, 0.11)
	add_child(bg)
	# Battle background art, scaled uniformly to cover the camera's view.
	var tex: Texture2D = load("res://assets/backgrounds/battle_background_1.png")
	var art := Sprite2D.new()
	art.texture = tex
	var cover := maxf(1680.0 / tex.get_width(), 920.0 / tex.get_height())
	art.scale = Vector2(cover, cover)
	art.position = Vector2(640, 360)
	add_child(art)
	# Zoomed camera so the combatants fill more of the screen (UI is on a
	# CanvasLayer and unaffected).
	cam = Camera2D.new()
	cam.position = Vector2(615, 450)
	cam.zoom = Vector2(1.2, 1.2)
	add_child(cam)
	cam.make_current()


const HERO_SLOTS := [Vector2(430, 380), Vector2(240, 470), Vector2(430, 560), Vector2(240, 650)]
const HERO_TINTS := [Color.WHITE, Color(0.65, 0.75, 1.0), Color(1.0, 0.9, 0.6), Color(0.7, 1.0, 0.75)]
const ENEMY_LAYOUTS := {
	1: [Vector2(1000, 500)],
	2: [Vector2(920, 420), Vector2(1000, 600)],
	3: [Vector2(900, 400), Vector2(1050, 510), Vector2(940, 630)],
	4: [Vector2(880, 380), Vector2(1060, 470), Vector2(880, 560), Vector2(1060, 650)],
}


func _enemy_config(kind: String) -> Dictionary:
	var orc := "res://assets/sprites/orc"
	match kind:
		"chief":
			return {"unit_name": "Orc Chief", "is_hero": false, "sheet_dir": orc,
				"max_hp": 210, "armor": 0.20, "speed": 80.0, "stability": 70,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 3.2,
				"tint": Color(1.0, 0.75, 0.7),
				"resists": {"physical": 0.15}}
		"boss":
			# Zone boss stand-ins until real boss art and unique kits exist.
			var boss_defs := [
				{"unit_name": "Withered Warden", "tint": Color(0.7, 1.0, 0.7),
					"resists": {"nature": 0.50, "physical": 0.10, "fire": -0.25}},
				{"unit_name": "Ash-Wrought Tyrant", "tint": Color(1.0, 0.55, 0.35),
					"resists": {"fire": 0.50, "physical": 0.10, "frost": -0.25}},
			]
			var bd: Dictionary = boss_defs[clampi(Run.zone_idx if Run.active else 0, 0, boss_defs.size() - 1)]
			return {"unit_name": bd["unit_name"], "is_hero": false, "sheet_dir": orc,
				"max_hp": 320, "armor": 0.22, "speed": 85.0, "stability": 90,
				"resource_name": "Rage", "resource": 20, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 3.6,
				"tint": bd["tint"], "resists": bd["resists"]}
		"archer":
			return {"unit_name": "Orc Archer", "is_hero": false, "sheet_dir": orc,
				"max_hp": 90, "armor": 0.10, "speed": 100.0, "stability": 42,
				"abilities": _orc_archer_kit(), "tint": Color(1.0, 0.35, 0.35),
				"resists": {"physical": 0.05}}
		_:
			return {"unit_name": "Orc Raider", "is_hero": false, "sheet_dir": orc,
				"max_hp": 115, "armor": 0.15, "speed": 90.0, "stability": 50,
				"abilities": _orc_raider_kit(), "tint": Color.WHITE,
				"resists": {"physical": 0.10}}


func _spawn_units() -> void:
	var hero_keys := ["warrior", "mage", "cleric", "hunter"]
	if Run.active:
		hero_keys = []
		for member in Run.party:
			hero_keys.append(member["key"])
	var sim_specs := ["swordmaster", "pyromancer", "holy", "sharpshooter"]
	var name_counts := {}
	for i in hero_keys.size():
		var cfg := Classes.hero_config(hero_keys[i])
		var spec := ""
		if Run.active and i < Run.party.size():
			spec = Run.party[i].get("spec", "")
		elif autoplay:
			spec = sim_specs[i]
		if spec != "":
			cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
			cfg["passive_id"] = Classes.SPEC_INFO[spec]["passive"]
			Classes.apply_passive(cfg, spec)
			if Run.active and i < Run.party.size():
				Talents.apply_from_tree(cfg, Run.party[i].get("tree", []),
					Run.party[i].get("talents", {}))
		name_counts[cfg["unit_name"]] = name_counts.get(cfg["unit_name"], 0) + 1
		if hero_keys.count(hero_keys[i]) > 1:
			cfg["unit_name"] = "%s %d" % [cfg["unit_name"], name_counts[cfg["unit_name"]]]
		if Run.active and i < Run.party.size():
			for rune in Run.party[i].get("runes", []):
				if rune.get("equipped", false):
					Talents.apply_payload(cfg, rune["payload"], 1)
			if Relics.has("dragonbone"):
				cfg["dmg_bonus"] = cfg.get("dmg_bonus", 0.0) + 0.10
			if Relics.has("emberheart"):
				var bonuses: Dictionary = cfg.get("type_dmg_bonus", {})
				bonuses["fire"] = bonuses.get("fire", 0.0) + 0.20
				bonuses["holy"] = bonuses.get("holy", 0.0) + 0.20
				cfg["type_dmg_bonus"] = bonuses
			if Relics.has("eidolon") and cfg["resource_name"] == "Rage":
				cfg["resource"] = 25
		var u := _make_unit(cfg, HERO_SLOTS[i], HERO_TINTS[i])
		u.crit_bonus = cfg.get("crit_bonus", 0.0)
		u.parry_bonus = cfg.get("parry_bonus", 0.0)
		if spec != "":
			u.add_status("spec_passive", Classes.SPEC_INFO[spec]["name"], "★",
				Color(0.9, 0.78, 0.4), -1, Classes.SPEC_INFO[spec]["passive_desc"])
		if Run.active and i < Run.party.size():
			u.hp = clampi(Run.party[i]["hp"], 1, u.max_hp)
			if u.resource_name == "Mana":
				u.resource = clampi(Run.party[i].get("mana", u.resource), 0, u.max_resource)
			u.refresh_bars()
		heroes.append(u)

	var composition: Array = ["raider", "chief", "archer", "archer"]
	if Run.active and Run.encounter.has("enemies"):
		composition = Run.encounter["enemies"]
	var layout: Array = ENEMY_LAYOUTS[clampi(composition.size(), 1, 3)]
	# Later zones field tougher versions of the same foes.
	var zone_mult := (1.0 + 0.35 * Run.zone_idx) if Run.active else 1.0
	for i in composition.size():
		var cfg := _enemy_config(composition[i])
		var tint: Color = cfg["tint"]
		cfg.erase("tint")
		if zone_mult > 1.0:
			cfg["max_hp"] = int(cfg["max_hp"] * zone_mult)
			for ab in cfg["abilities"]:
				ab.damage = int(ab.damage * zone_mult)
			tint = tint.lerp(Color(1.0, 0.6, 0.45), 0.35)
		enemies.append(_make_unit(cfg, layout[i], tint))

	for u in heroes + enemies:
		u.next_time = (100.0 / u.speed) * randf_range(0.0, 1.0)


func _make_unit(config: Dictionary, pos: Vector2, tint: Color) -> BattleUnit:
	var u := BattleUnit.new()
	u.position = pos
	add_child(u)
	u.setup(config)
	u.set_tint(tint)
	u.clicked.connect(func(): _target_picked.emit(u))
	u.refresh_bars()
	return u


func _orc_raider_kit() -> Array:
	return [
		Ability.make({"display_name": "Slash", "damage": 34, "pressure": 13,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Sundering Strike", "damage": 23, "pressure": 11,
			"delay": 2.5, "anim": "attack02",
			"applies_status": {"id": "sunder", "turns": 2}, "status_chance": 0.6}),
	]


func _orc_archer_kit() -> Array:
	return [
		Ability.make({"display_name": "Arrow Shot", "damage": 21, "pressure": 8,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Poison Arrow", "damage": 16, "pressure": 7,
			"delay": 2.5, "anim": "attack02",
			"applies_status": {"id": "poison", "turns": 3}, "status_chance": 0.7}),
	]


# The Chief fights like a weaker Warrior: builds Rage, spends it on heavy hits.
func _orc_chief_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "damage": 28, "pressure": 13,
			"resource_gain": 15, "delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Heavy Strike", "cost": 30, "damage": 54,
			"pressure": 20, "delay": 4.0, "anim": "attack02"}),
		Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 34,
			"pressure": 28, "delay": 4.0, "anim": "attack02"}),
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

	var bottom_center := CenterContainer.new()
	bottom_center.position = Vector2(0, 640)
	bottom_center.size = Vector2(1280, 76)
	bottom_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(bottom_center)
	action_panel = PanelContainer.new()
	bottom_center.add_child(action_panel)
	action_box = HBoxContainer.new()
	action_box.add_theme_constant_override("separation", 10)
	action_panel.add_child(action_box)
	action_panel.visible = false

	var history_panel := PanelContainer.new()
	history_panel.position = Vector2(968, 8)
	history_panel.self_modulate = Color(1, 1, 1, 0.85)
	ui.add_child(history_panel)
	history = RichTextLabel.new()
	history.bbcode_enabled = true
	history.scroll_following = true
	history.custom_minimum_size = Vector2(300, 190)
	history.add_theme_font_size_override("normal_font_size", 12)
	history_panel.add_child(history)

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


# Appends one line to the battle history panel.
func _log(text: String, color := "#d8d2c4") -> void:
	history.append_text("[color=%s]%s[/color]\n" % [color, text])


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
		portrait.custom_minimum_size = Vector2(66, 90)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.flip_h = not u.is_hero
		portrait.mouse_filter = Control.MOUSE_FILTER_STOP
		portrait.tooltip_text = u.unit_name
		portrait.mouse_entered.connect(u.set_highlight.bind(true))
		portrait.mouse_exited.connect(u.set_highlight.bind(false))
		slot.add_child(portrait)
		var stripe := ColorRect.new()
		stripe.custom_minimum_size = Vector2(66, 4)
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
		for dot_id in DOT_STATUSES:
			if u.has_status(dot_id) and not u.dead:
				var dot_dmg: int = DOT_STATUSES[dot_id]
				var info: Array = STATUS_INFO[dot_id]
				_sfx("hit", -14.0, 0.8)
				var dot_died: bool = u.take_tick_damage(dot_dmg, "-%d %s" % [dot_dmg, info[0]], info[2])
				_log("%s takes %d %s damage" % [u.unit_name, dot_dmg, info[0]], "#e08850")
				await _wait(0.5)
				if dot_died:
					_message("%s succumbs to %s!" % [u.unit_name, info[0]])
					_log("† %s dies" % u.unit_name, "#e05050")
		if u.dead:
			_check_end()
			continue
		# Turn-start regeneration effects.
		if u.has_status("renewal"):
			u.heal_amount(8)
			u.float_text("+8", Color(0.45, 0.9, 0.5))
			_log("%s regenerates 8 HP (Renewal)" % u.unit_name, "#70d878")
		if u.has_status("focus") and u.resource_name == "Mana":
			u.resource = mini(u.resource + 10, u.max_resource)
			u.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
			u.refresh_bars()
		u.tick_statuses()
		if u.broken_pending:
			u.broken_pending = false
			_message("%s is Broken and loses their turn!" % u.unit_name)
			_log("%s loses their turn (Broken)" % u.unit_name, "#c070e0")
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
	current_hero = u
	item_used = false
	if u.resource_name == "Mana":
		u.resource = mini(u.resource + 12, u.max_resource)
		u.refresh_bars()
	_message("%s's turn — choose an ability" % u.unit_name)
	_show_actions(u)
	var ab: Ability
	var auto_target: BattleUnit = null
	if autoplay:
		var pick := _autoplay_pick(u)
		ab = pick[0]
		auto_target = pick[1]
	else:
		ab = await _ability_picked
	action_panel.visible = false

	var target: BattleUnit = null
	var grade := "good"
	while true:
		var used_targeting := false
		if ab.special in ["rally", "focus", "surge", "guard", "shieldwall", "camo",
				"phoenix", "hymn", "benediction", "retaliate"]:
			target = u  # self/party effects need no target choice
		elif ab.aoe or ab.random_hits > 0:
			var foes := enemies.filter(func(e): return not e.dead)
			target = foes[0]  # resolve picks the real targets
		elif autoplay:
			target = auto_target
		else:
			var pool: Array
			if ab.target == Ability.Target.ALLY:
				pool = heroes.filter(func(h): return not h.dead)
			else:
				pool = enemies.filter(func(e): return not e.dead)
			if pool.size() == 1:
				target = pool[0]
			else:
				used_targeting = true
				_message("Choose a target")
				target = await _pick_target(pool)
		if target != null:
			if autoplay:
				var roll := randf()
				grade = "perfect" if roll < 0.20 else ("fail" if roll > 0.85 else "good")
				break
			# Auto-cast abilities (no target click) can cancel during the skill check.
			grade = await _run_skill_check(not used_targeting)
			if grade != "cancel":
				break
		# Cancelled: back to the action bar to pick something else.
		_message("%s's turn — choose an ability" % u.unit_name)
		_show_actions(u)
		ab = await _ability_picked
		action_panel.visible = false
	await _resolve(u, ab, target, grade)
	current_hero = null


# Simple hero policy for automated battles: heal when hurt, spend when able,
# focus the weakest (preferring Broken) enemy.
func _autoplay_pick(u: BattleUnit) -> Array:
	var foes := enemies.filter(func(e): return not e.dead)
	var allies := heroes.filter(func(h): return not h.dead)
	var broken_foes := foes.filter(func(e): return e.broken)
	var target_foe: BattleUnit = _lowest_hp(broken_foes) if not broken_foes.is_empty() \
		else _lowest_hp(foes)
	var weakest_ally := _lowest_hp(allies)
	match u.unit_name:
		"Warrior":
			var crushing := _find_ability(u, "Crushing Blow")
			if crushing != null and u.resource >= crushing.cost \
					and not target_foe.has_status("sunder"):
				return [crushing, target_foe]
			var overpower := _find_ability(u, "Overpower")
			if overpower != null and u.resource >= overpower.cost:
				return [overpower, target_foe]
			return [u.abilities[0], target_foe]          # Strike
		"Mage":
			var surge_ab := _find_ability(u, "Arcane Surge")
			if surge_ab != null and u.resource >= surge_ab.cost \
					and u.second_resource < u.second_max and randf() < 0.25:
				return [surge_ab, u]
			var flame := _find_ability(u, "Flame Surge")
			if flame != null and u.resource >= flame.cost and foes.size() >= 2:
				return [flame, target_foe]
			return [u.abilities[0], target_foe]          # Magic Bolt
		"Hunter":
			var aimed := _find_ability(u, "Aimed Shot")
			if aimed != null and u.resource >= aimed.cost:
				return [aimed, target_foe]
			return [u.abilities[0], target_foe]          # Quick Shot
		"Cleric":
			var hymn := _find_ability(u, "Hymn of Hope")
			if hymn != null and u.second_resource >= hymn.faith_cost \
					and weakest_ally.hp < weakest_ally.max_hp * 0.6:
				return [hymn, u]
			if weakest_ally.hp < weakest_ally.max_hp * 0.5 and u.resource >= 25:
				return [u.abilities[1], weakest_ally]    # Mend Wounds
			return [u.abilities[0], target_foe]          # Smite
	return [u.abilities[0], target_foe]


func _find_ability(u: BattleUnit, ability_name: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == ability_name:
			return ab
	return null


# Items are shared by the party and never consume the turn: the action
# panel comes right back after the effect resolves. Limit: one item per
# character per turn.
func _use_item(item_id: String) -> void:
	if items[item_id][1] <= 0 or item_used:
		return
	item_used = true
	action_panel.visible = false
	items[item_id][1] -= 1
	match item_id:
		"bomb":
			_message("Bomb thrown!")
			_log("Item: Bomb — 50 dmg to all enemies", "#e0c060")
			_sfx("bomb", -2.0)
			_shake()
			for e in enemies.filter(func(en): return not en.dead):
				var result: Dictionary = e.take_hit(50, 0)
				e.float_text("50", Color(1.0, 0.8, 0.4))
				if result.died:
					_message("%s falls!" % e.unit_name)
					_log("† %s dies" % e.unit_name, "#e05050")
			await _wait(0.8)
			_rebuild_turn_bar()
			_check_end()
		"health":
			var living := heroes.filter(func(h): return not h.dead)
			var heal_target: BattleUnit = living[0]
			if living.size() > 1:
				_message("Choose an ally to heal")
				heal_target = await _pick_target(living)
			heal_target.heal_amount(40)
			_sfx("heal", -6.0)
			heal_target.float_text("+40", Color(0.4, 0.9, 0.45))
			_message("%s drinks a Health Potion" % heal_target.unit_name)
			_log("Item: Health Potion — %s +40 HP" % heal_target.unit_name, "#e0c060")
			await _wait(0.5)
		"mana":
			var drinkers := heroes.filter(func(h): return not h.dead)
			var mana_target: BattleUnit = drinkers[0]
			if drinkers.size() > 1:
				_message("Choose an ally")
				mana_target = await _pick_target(drinkers)
			mana_target.resource = mini(mana_target.resource + 40, mana_target.max_resource)
			mana_target.refresh_bars()
			_sfx("heal", -8.0, 1.2)
			mana_target.float_text("+40 %s" % mana_target.resource_name, Color(0.5, 0.7, 1.0))
			_message("%s drinks a Mana Potion" % mana_target.unit_name)
			_log("Item: Mana Potion — %s +40 %s" % [mana_target.unit_name,
				mana_target.resource_name], "#e0c060")
			await _wait(0.5)
		"revive":
			var fallen := heroes.filter(func(h): return h.dead)
			if fallen.is_empty():
				items[item_id][1] += 1
				item_used = false
				return
			var target: BattleUnit
			if fallen.size() == 1:
				target = fallen[0]
			else:
				_message("Choose an ally to revive")
				target = await _pick_target(fallen)
			target.revive(0.5)
			_sfx("heal", -5.0, 0.8)
			target.float_text("REVIVED", Color(0.5, 1.0, 0.6))
			if current_hero != null:
				target.next_time = current_hero.next_time + BASIC_DELAY * 100.0 / target.effective_speed()
			_message("%s returns to the fight!" % target.unit_name)
			_log("Item: Revive Potion — %s revived at 50%% HP" % target.unit_name, "#e0c060")
			_rebuild_turn_bar()
			await _wait(0.6)
		"defense":
			_message("The party braces!")
			_log("Item: Defense Potion — party gains Fortify", "#e0c060")
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "fortify", 3)
			await _wait(0.6)
	if not battle_over and current_hero != null and not current_hero.dead:
		_show_actions(current_hero)


func _show_actions(u: BattleUnit) -> void:
	for child in action_box.get_children():
		child.queue_free()
	# Basic attack: always its own button.
	var basic: Ability = u.abilities[0]
	var basic_btn := Button.new()
	basic_btn.text = basic.display_name
	basic_btn.custom_minimum_size = Vector2(130, 58)
	basic_btn.tooltip_text = _ability_tooltip(u, basic)
	basic_btn.pressed.connect(_on_ability_button.bind(basic))
	action_box.add_child(basic_btn)
	# Everything else lives in the Abilities dropdown.
	var menu := MenuButton.new()
	menu.text = "Abilities ▾"
	menu.custom_minimum_size = Vector2(140, 58)
	menu.flat = false
	var popup := menu.get_popup()
	for i in range(1, u.abilities.size()):
		var ab: Ability = u.abilities[i]
		var label: String = ab.display_name
		if ab.cost > 0:
			label += "   %d %s" % [ab.cost, u.resource_name]
		elif ab.faith_cost > 0:
			label += "   %d %s" % [ab.faith_cost, u.second_resource_name]
		popup.add_item(label, i)
		popup.set_item_tooltip(popup.item_count - 1, _ability_tooltip(u, ab))
		popup.set_item_disabled(popup.item_count - 1,
			ab.cost > u.resource or ab.faith_cost > u.second_resource)
	popup.id_pressed.connect(_on_ability_menu.bind(u))
	action_box.add_child(menu)
	# Guard and Items keep their own buttons.
	var guard_btn := Button.new()
	guard_btn.text = "Guard"
	guard_btn.custom_minimum_size = Vector2(110, 58)
	guard_btn.tooltip_text = guard_ability.description
	guard_btn.tooltip_text += "\nPerfect: %s" % guard_ability.perfect_text
	guard_btn.pressed.connect(_on_ability_button.bind(guard_ability))
	action_box.add_child(guard_btn)
	action_box.add_child(_build_items_menu())
	action_panel.visible = true


func _on_ability_button(ab: Ability) -> void:
	_sfx("click", -12.0)
	_ability_picked.emit(ab)


func _on_ability_menu(id: int, u: BattleUnit) -> void:
	_sfx("click", -12.0)
	_ability_picked.emit(u.abilities[id])


# Tooltip with live damage ranges (includes the unit's current buffs).
func _ability_tooltip(u: BattleUnit, ab: Ability) -> String:
	var tip := ab.description
	if ab.damage > 0:
		var buff_mult := 1.0
		if u.second_resource_name == "Resonance":
			buff_mult *= 1.0 + 0.15 * u.second_resource
		if u.has_status("surge"):
			buff_mult *= 1.2
		if u.has_status("empower"):
			buff_mult *= 1.25
		tip += "\nDamage: %d–%d (%s)    Pressure: %d" % [
			int(ab.damage * 0.9 * buff_mult), int(round(ab.damage * 1.1 * buff_mult)),
			ab.dmg_type.capitalize(), ab.pressure]
	if ab.heal > 0:
		tip += "\nHeals: %d" % ab.heal
	if ab.perfect_text != "":
		tip += "\nPerfect: %s" % ab.perfect_text
	return tip


# Dropdown menu for the shared party inventory (one item per character per turn).
func _build_items_menu() -> MenuButton:
	var menu := MenuButton.new()
	menu.text = "Items ▾"
	menu.custom_minimum_size = Vector2(96, 58)
	menu.flat = false
	menu.disabled = item_used
	if item_used:
		menu.tooltip_text = "Already used an item this turn."
	var popup := menu.get_popup()
	for i in Run.ITEM_IDS.size():
		var entry: Array = items[Run.ITEM_IDS[i]]
		popup.add_item("%s  x%d" % [entry[0], entry[1]], i)
		popup.set_item_tooltip(i, "%s\nDoes not consume the turn." % entry[2])
		var usable: bool = entry[1] > 0
		if Run.ITEM_IDS[i] == "revive":
			usable = usable and heroes.any(func(h): return h.dead)
		popup.set_item_disabled(i, not usable)
	popup.id_pressed.connect(func(id: int): _use_item(Run.ITEM_IDS[id]))
	return menu


func _pick_target(pool: Array) -> BattleUnit:
	for t in pool:
		t.set_targetable(true)
	var cancel := Button.new()
	cancel.text = "✕ Cancel"
	cancel.custom_minimum_size = Vector2(120, 40)
	cancel.position = Vector2(580, 560)
	cancel.pressed.connect(func(): _target_picked.emit(null))
	ui.add_child(cancel)
	var chosen: BattleUnit = await _target_picked
	for t in pool:
		t.set_targetable(false)
	cancel.queue_free()
	return chosen


func _enemy_turn(u: BattleUnit) -> void:
	_message("%s attacks!" % u.unit_name)
	await _wait(0.7)
	var living := heroes.filter(func(h): return not h.dead)
	if living.is_empty():
		return
	if u.has_status("mocked"):
		var mocker_idx := u.status_power("mocked")
		if mocker_idx >= 0 and mocker_idx < heroes.size() and not heroes[mocker_idx].dead:
			living = [heroes[mocker_idx]]
	var target: BattleUnit
	var ab: Ability
	var affordable: Array = u.abilities.filter(func(a): return a.cost <= u.resource)
	var broken_heroes := living.filter(func(h): return h.broken)
	if not broken_heroes.is_empty():
		# Exploit a Broken hero with the hardest-hitting attack they can afford.
		target = _lowest_hp(broken_heroes)
		ab = affordable[0]
		for a in affordable:
			if a.damage > ab.damage:
				ab = a
		_message("%s exploits the Break!" % u.unit_name)
		await _wait(0.4)
	else:
		# Prefer finishing off wounded heroes; sometimes spread damage.
		target = _lowest_hp(living) if randf() < 0.65 else living.pick_random()
		ab = affordable.pick_random()
	await _resolve(u, ab, target, "good")


func _lowest_hp(pool: Array) -> BattleUnit:
	var best: BattleUnit = pool[0]
	for h in pool:
		if h.hp / float(h.max_hp) < best.hp / float(best.max_hp):
			best = h
	return best


# Base chances for the attack rolls. Many things will modify these later.
const MISS_CHANCE := 0.05
const PARRY_CHANCE := 0.05
const CRIT_CHANCE := 0.10


func _resolve(attacker: BattleUnit, ab: Ability, target: BattleUnit, grade: String,
		is_counter := false) -> void:
	attacker.resource = clampi(attacker.resource - ab.cost + ab.resource_gain, 0, attacker.max_resource)
	attacker.refresh_bars()
	var dmg_mult := {"perfect": 1.15, "good": 1.0, "fail": 0.6}[grade] as float
	var pr_mult := {"perfect": 1.25, "good": 1.0, "fail": 0.5}[grade] as float
	var is_perfect := grade == "perfect"

	# Lunge toward the target so attacks visibly connect (specials stay put).
	var lunge_origin := attacker.position
	if not sim and ab.special == "" and target != attacker:
		var toward := (target.position - attacker.position).normalized()
		var lunge_dist := 90.0 if ab.heal == 0 else 40.0
		var lunge := create_tween()
		lunge.tween_property(attacker, "position", lunge_origin + toward * lunge_dist, 0.14) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	attacker.play_anim(ab.anim)
	await _wait(0.3)
	if attacker.is_hero:
		_stat("hero_actions")
		_stat("use_" + ab.display_name)

	if ab.faith_cost > 0:
		attacker.second_resource = maxi(attacker.second_resource - ab.faith_cost, 0)
	# Faith builds from every Cleric action (Zeal: 13).
	if attacker.second_resource_name == "Faith":
		var faith_gain := 13 if attacker.passive_id == "zeal" else 10
		attacker.second_resource = mini(attacker.second_resource + faith_gain, attacker.second_max)
		attacker.refresh_bars()

	var grade_tag := {"perfect": " [PERFECT]", "good": "", "fail": " [Sloppy]"}[grade] as String
	if ab.special != "":
		await _resolve_special(attacker, ab, target, grade, dmg_mult)
	elif ab.heal > 0:
		var amount := int(ab.heal * dmg_mult)
		_stat("healing", amount)
		_sfx("heal", -8.0)
		target.heal_amount(amount)
		target.float_text("+%d" % amount, Color(0.4, 0.9, 0.45))
		_message("%s heals %s for %d" % [attacker.unit_name, target.unit_name, amount])
		_log("%s: %s on %s heals %d%s" % [attacker.unit_name, ab.display_name,
			target.unit_name, amount, grade_tag], "#70d878")
		if is_perfect and ab.perfect_id == "ward":
			_apply_status(target, "ward", 3)
	elif not is_counter and not ab.aoe and randf() < MISS_CHANCE + (0.15 if target.has_status("camo") else 0.0):
		_stat("attacks")
		_stat("attack_miss")
		_sfx("miss")
		target.float_text("MISS", Color(0.75, 0.75, 0.75))
		_message("%s misses!" % attacker.unit_name)
		_log("%s: %s on %s — MISS" % [attacker.unit_name, ab.display_name,
			target.unit_name], "#909090")
		await _wait(0.35)
	elif not is_counter and not ab.aoe and not target.broken and not target.dead and randf() < PARRY_CHANCE + target.parry_bonus:
		# Parry negates the hit; the defender immediately counters with
		# their basic attack (a free action — no rolls, no initiative cost).
		_stat("attacks")
		_stat("attack_parry")
		_sfx("parry", -4.0)
		target.float_text("PARRY", Color(0.4, 0.9, 1.0))
		_message("%s parries and counters!" % target.unit_name)
		_log("%s parries %s — counter attack!" % [target.unit_name,
			attacker.unit_name], "#50c8e0")
		await _wait(0.5)
		attacker.return_to_idle()
		await _resolve(target, target.abilities[0], attacker, "good", true)
	else:
		var strike_targets: Array = [target]
		if ab.aoe:
			strike_targets = (enemies if attacker.is_hero else heroes).filter(
				func(t): return not t.dead)
		var total_hits := strike_targets.size()
		if ab.random_hits > 0:
			total_hits = ab.random_hits + (1 if is_perfect else 0)
		var total_dealt := 0
		var any_crit := false
		for hit_i in total_hits:
			var strike_target: BattleUnit
			if ab.random_hits > 0:
				# Each shard picks a fresh living target at launch time.
				var live_pool: Array = (enemies if attacker.is_hero else heroes).filter(
					func(t): return not t.dead)
				if live_pool.is_empty():
					break
				strike_target = live_pool.pick_random()
			else:
				strike_target = strike_targets[hit_i]
				if strike_target.dead:
					continue
			var crit_chance := CRIT_CHANCE + (0.25 if strike_target.broken else 0.0)
			# Resonant Mind: +3% crit per Resonance stack.
			if attacker.second_resource_name == "Resonance":
				crit_chance += 0.03 * attacker.second_resource
			crit_chance += attacker.crit_bonus
			if strike_target.has_status("marked"):
				crit_chance += 0.15
			if is_perfect and ab.display_name == "Overpower":
				crit_chance += 0.15
			var is_crit := randf() < crit_chance
			# Razor Ice always crits against Slowed (chilled) targets.
			if ab.display_name == "Razor Ice" and strike_target.has_status("slow"):
				is_crit = true
			if ab.display_name == "Aimed Shot" and strike_target.has_status("marked"):
				is_crit = true
			any_crit = any_crit or is_crit
			var raw := ab.damage * randf_range(0.9, 1.1) * dmg_mult
			if is_crit:
				raw *= 1.75 if attacker.passive_id == "lethal_aim" else 1.5
			if attacker.has_status("camo"):
				raw *= 1.2
				attacker.remove_status("camo")
			# Attacker-side modifiers.
			if attacker.second_resource_name == "Resonance":
				raw *= 1.0 + 0.15 * attacker.second_resource
			if attacker.has_status("surge"):
				raw *= 1.2
			if is_perfect and ab.display_name == "Arcane Cannon":
				raw *= 1.0 + 0.075 * attacker.second_resource
			if attacker.has_status("empower"):
				raw *= 1.25
			if attacker.has_status("cripple"):
				raw *= 0.85
			if attacker.passive_id == "bloodrage":
				raw *= 1.0 + 0.4 * (1.0 - attacker.hp / float(attacker.max_hp))
			if attacker.passive_id == "zeal":
				raw *= 1.15
			raw *= 1.0 + attacker.dmg_bonus + float(attacker.type_dmg_bonus.get(ab.dmg_type, 0.0))
			# Target-side modifiers.
			if strike_target.second_resource_name == "Resonance":
				raw *= 1.0 + 0.10 * strike_target.second_resource
			if strike_target.has_status("guard"):
				raw *= 0.6
			if strike_target.has_status("shieldwall"):
				raw *= 0.5
			if strike_target.has_status("exposed"):
				raw *= 1.15
			if debug_prints and attacker.second_resource_name == "Resonance":
				print("[DBG] %s attacks @%d stacks: base %d -> raw %.1f" % [
					attacker.unit_name, attacker.second_resource, ab.damage, raw])
			var resist := float(strike_target.resists.get(ab.dmg_type, 0.0))
			if resist != 0.0:
				raw *= 1.0 - resist
			var effective_armor := strike_target.effective_armor() * (1.0 - ab.armor_pierce)
			if is_perfect and ab.display_name == "Arcane Rift":
				effective_armor = 0.0
			var final := maxi(int(round(raw * (1.0 - effective_armor))), 1)
			var resonance_boosted: bool = attacker.second_resource_name == "Resonance" \
				and attacker.second_resource > 0
			var pr := int(round(ab.pressure * pr_mult * (1.5 if is_crit else 1.0)))
			if is_perfect and (ab.perfect_id == "pressure" or ab.aoe):
				pr = int(pr * 1.5)
			_stat("attacks")
			_stat("attack_landed")
			if is_crit:
				_stat("attack_crit")
			if attacker.is_hero:
				_stat("dmg_hero_" + attacker.unit_name, final)
			else:
				_stat("dmg_enemy", final)
			total_dealt += final
			var result: Dictionary = strike_target.take_hit(final, pr)
			if not sim and not result.died:
				strike_target.hit_react((strike_target.position - attacker.position).normalized())
			if is_crit:
				_sfx("crit", -3.0)
				strike_target.float_text("%d!" % final, Color(1.0, 0.45, 0.15), true)
				_shake()
			elif resonance_boosted:
				_sfx("hit", -5.0, 1.15)
				strike_target.float_text("%d" % final, Color(0.85, 0.55, 1.0))
			else:
				_sfx("hit")
				strike_target.float_text("%d" % final, Color(0.95, 0.85, 0.75))
			var resist_tag := ""
			if resist > 0.0:
				resist_tag = " (resisted)"
			elif resist < 0.0:
				resist_tag = " (vulnerable!)"
			_log("%s: %s on %s — %d %s dmg%s%s, +%d Pressure%s" % [attacker.unit_name,
				ab.display_name, strike_target.unit_name, final, ab.dmg_type,
				" CRIT" if is_crit else "", resist_tag, pr, grade_tag],
				"#d8d2c4" if attacker.is_hero else "#e0a0a0")
			if attacker.passive_id == "pack" and is_crit and not strike_target.dead:
				var pack_dmg := maxi(int(final * 0.3), 1)
				strike_target.take_hit(pack_dmg, 0)
				strike_target.float_text("%d Pack" % pack_dmg, Color(0.8, 0.6, 0.3))
				_log("   → the pack strikes for %d" % pack_dmg, "#b0a8e0")
			# Arcanist Echo: the spell strikes again at half power.
			if attacker.passive_id == "echo" and not result.died and randf() < 0.15:
				var echo_dmg := maxi(int(final * 0.5), 1)
				strike_target.take_hit(echo_dmg, 0)
				strike_target.float_text("%d Echo" % echo_dmg, Color(0.8, 0.6, 1.0))
				_log("   → Echo strikes %s for %d" % [strike_target.unit_name, echo_dmg], "#b0a8e0")
			if ab.delay_push > 0.0:
				strike_target.next_time += ab.delay_push * 100.0 / strike_target.effective_speed()
			if not result.died and not ab.applies_status.is_empty() and randf() <= ab.status_chance:
				var turns: int = ab.applies_status["turns"]
				if is_perfect and ab.perfect_id == "slow_plus":
					turns = 4
				if is_perfect and ab.display_name == "Flame Surge":
					turns += 1
				_apply_status(strike_target, ab.applies_status["id"], turns)
			if ab.bleed_build > 0 and not strike_target.dead:
				if strike_target.add_bleed(ab.bleed_build):
					var bleed_dmg := maxi(int(strike_target.max_hp * 0.20), 1)
					var bleed_result: Dictionary = strike_target.take_hit(bleed_dmg, 0)
					strike_target.float_text("BLEEDOUT %d" % bleed_dmg, Color(0.9, 0.15, 0.2), true)
					_sfx("crit", -5.0, 0.8)
					_log("   → %s BLEEDS OUT for %d" % [strike_target.unit_name, bleed_dmg], "#e05050")
					if bleed_result.died:
						_stat("hero_deaths" if strike_target.is_hero else "enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % strike_target.unit_name)
						_log("† %s dies" % strike_target.unit_name, "#e05050")
						await _wait(0.5)
			if ab.display_name == "Mocking Blow" and not strike_target.dead:
				var mocker_idx := heroes.find(attacker)
				if mocker_idx >= 0:
					_apply_status(strike_target, "mocked", 4 if is_perfect else 3, mocker_idx)
			# Specialization on-hit passives.
			if not strike_target.dead:
				if attacker.passive_id == "ignite" and randf() < 0.5:
					_apply_status(strike_target, "burn", 3)
				elif attacker.passive_id == "chill" and randf() < 0.5:
					_apply_status(strike_target, "slow", 3)
				elif attacker.passive_id == "corrupt" and randf() < 0.25:
					_apply_status(strike_target, "cripple", 3)
				if is_perfect and ab.display_name == "Hex of Ruin":
					_apply_status(strike_target, "cripple", 3)
			if is_perfect:
				_apply_perfect_bonus(attacker, strike_target, ab, result.died)
			# Retaliation stance: the victim counters with their basic attack.
			if strike_target.has_status("retaliate") and not is_counter \
					and not strike_target.dead and not attacker.dead and ab.damage > 0:
				strike_target.float_text("RETALIATE", Color(0.95, 0.6, 0.25))
				_log("%s retaliates!" % strike_target.unit_name, "#50c8e0")
				await _wait(0.4)
				await _resolve(strike_target, strike_target.abilities[0], attacker, "good", true)
			if result.broke:
				_stat("breaks_on_heroes" if strike_target.is_hero else "breaks_on_enemies")
				_sfx("break", -3.0)
				_message("%s BREAKS!" % strike_target.unit_name)
				_log("!! %s BREAKS" % strike_target.unit_name, "#c070e0")
				await _break_impact()
				_shake()
				await _wait(0.5)
			if result.died:
				_stat("hero_deaths" if strike_target.is_hero else "enemy_deaths")
				_sfx("death", -4.0)
				_message("%s falls!" % strike_target.unit_name)
				_log("† %s dies" % strike_target.unit_name, "#e05050")
				await _wait(0.5)
			if ab.random_hits > 0 and total_hits > 1:
				await _wait(0.45)  # sequential shards land distinctly
		# Post-strike attacker effects.
		if ab.recoil_base > 0.0:
			var recoil_pct := ab.recoil_base * (1.0 + attacker.second_resource)
			var recoil := maxi(int(round(total_dealt * recoil_pct)), 1)
			var recoil_died := attacker.take_tick_damage(recoil, "-%d Recoil" % recoil,
				Color(1.0, 0.4, 0.5))
			_log("   → %s recoils for %d" % [attacker.unit_name, recoil], "#e08850")
			if recoil_died:
				_stat("hero_deaths")
				_sfx("death", -4.0)
				_message("%s is consumed by their own power!" % attacker.unit_name)
				_log("† %s dies" % attacker.unit_name, "#e05050")
		if ab.lifesteal > 0.0 and total_dealt > 0 and not attacker.dead:
			var leech := int(total_dealt * ab.lifesteal * (1.5 if is_perfect else 1.0))
			attacker.heal_amount(leech)
			attacker.float_text("+%d" % leech, Color(0.4, 0.9, 0.45))
			_log("   → %s leeches %d HP" % [attacker.unit_name, leech], "#70d878")
		if ab.heal_missing > 0.0 and not attacker.dead:
			var drain_frac := 0.45 if is_perfect else ab.heal_missing
			var missing_hp := attacker.max_hp - attacker.hp
			if missing_hp > 0:
				var drained := maxi(int(missing_hp * drain_frac), 1)
				attacker.heal_amount(drained)
				attacker.float_text("+%d" % drained, Color(0.4, 0.9, 0.45))
				_log("   → %s drains %d HP" % [attacker.unit_name, drained], "#70d878")
		if attacker.passive_id == "duelist" and any_crit and attacker.resource_name == "Rage":
			var refund := 20 if ab.display_name == "Overpower" else 10
			attacker.resource = mini(attacker.resource + refund, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+%d Rage" % refund, Color(1.0, 0.5, 0.4))
		_gain_resonance(attacker, 2 if any_crit else 1)
	if not sim and attacker.position != lunge_origin:
		var back := create_tween()
		back.tween_property(attacker, "position", lunge_origin, 0.18) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await _wait(0.45)
	attacker.return_to_idle()
	if not is_counter:
		attacker.next_time += ab.delay * 100.0 / attacker.effective_speed()


func _apply_status(target: BattleUnit, id: String, turns: int, power := 0) -> void:
	var info: Array = STATUS_INFO[id]
	target.add_status(id, info[0], info[1], info[2], turns, info[3], power)
	var span := "battle" if turns < 0 else "%d turns" % turns
	_log("   → %s on %s (%s)" % [info[0], target.unit_name, span], "#b0a8e0")


# Arcane Resonance: builds on damaging casts (2 on crit via Arcane Instability);
# hitting max stacks triggers Backlash Ward (+15 Mana). Stacks persist until
# the Mage uses Guard, which vents them all.
func _gain_resonance(caster: BattleUnit, stacks: int) -> void:
	if caster.second_resource_name != "Resonance":
		return
	var before := caster.second_resource
	caster.second_resource = mini(caster.second_resource + stacks, caster.second_max)
	if caster.second_resource != before:
		caster.float_text("+%d Resonance" % (caster.second_resource - before), Color(0.8, 0.5, 1.0))
	# Backlash Ward: hitting max stacks restores Mana.
	if caster.second_resource == caster.second_max and before < caster.second_max:
		caster.resource = mini(caster.resource + 15, caster.max_resource)
		caster.float_text("Backlash Ward +15 Mana", Color(0.5, 0.7, 1.0))
		_log("   → Backlash Ward: %s restores 15 Mana" % caster.unit_name, "#b0a8e0")
	caster.refresh_bars()


# Non-attack abilities (buffs, shields, party effects). Effect strength scales
# with the skill check via `mult`.
func _resolve_special(attacker: BattleUnit, ab: Ability, target: BattleUnit,
		grade: String, mult: float) -> void:
	var is_perfect := grade == "perfect"
	match ab.special:
		"rally":
			var pressure_cut := 25 if is_perfect else int(15 * mult)
			var res_pct := 0.30 if is_perfect else 0.20
			_sfx("heal", -9.0, 0.7)
			_message("%s rallies the party!" % attacker.unit_name)
			for h in heroes.filter(func(he): return not he.dead):
				h.pressure = maxi(h.pressure - pressure_cut, 0)
				h.float_text("-%d Pressure" % pressure_cut, Color(0.8, 0.5, 1.0))
				if h != attacker:
					var gain := int(h.max_resource * res_pct)
					h.resource = mini(h.resource + gain, h.max_resource)
					h.float_text("+%d %s" % [gain, h.resource_name], Color(0.5, 0.8, 1.0))
				h.refresh_bars()
			_log("%s: Rallying Shout — party -%d Pressure, allies +%d%% resource%s" % [
				attacker.unit_name, pressure_cut, int(res_pct * 100),
				" [PERFECT]" if is_perfect else ""], "#70d878")
		"barrier":
			var power := 50 if is_perfect else int(35 * mult)
			_sfx("parry", -8.0, 0.7)
			_apply_status(target, "barrier", 3, power)
			_message("%s shields %s (%d)" % [attacker.unit_name, target.unit_name, power])
			_log("%s: Arcane Barrier on %s — absorbs %d" % [attacker.unit_name,
				target.unit_name, power], "#70d878")
		"focus":
			_apply_status(attacker, "focus", 2)
			if is_perfect:
				attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
				attacker.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
			attacker.refresh_bars()
			_message("%s focuses..." % attacker.unit_name)
			_log("%s: Focus — regenerating Mana" % attacker.unit_name, "#70d878")
		"surge":
			# Lasts through one status tick so it covers exactly the next turn's attack.
			_apply_status(attacker, "surge", 2)
			_gain_resonance(attacker, 2 if is_perfect else 1)
			_message("%s surges with power!" % attacker.unit_name)
			_log("%s: Arcane Surge — +20%% attack next turn" % attacker.unit_name, "#70d878")
		"divine_shield":
			var shield := 130 if is_perfect else 100
			_sfx("parry", -6.0, 0.6)
			_apply_status(target, "barrier", -1, shield)
			_message("%s shields %s (%d)" % [attacker.unit_name, target.unit_name, shield])
			_log("%s: Divine Shield on %s — absorbs %d" % [attacker.unit_name,
				target.unit_name, shield], "#70d878")
		"guard":
			_sfx("parry", -9.0, 0.6)
			_apply_status(attacker, "guard", 1)
			if attacker.second_resource_name == "Resonance" and attacker.second_resource > 0:
				attacker.second_resource = 0
				attacker.float_text("Resonance vented", Color(0.6, 0.45, 0.75))
				attacker.refresh_bars()
				_log("   → %s vents all Resonance" % attacker.unit_name, "#b0a8e0")
			if is_perfect:
				attacker.pressure = maxi(attacker.pressure - 10, 0)
				attacker.float_text("-10 Pressure", Color(0.8, 0.5, 1.0))
				attacker.refresh_bars()
			_message("%s braces for impact" % attacker.unit_name)
			_log("%s guards" % attacker.unit_name, "#70d878")
		"shieldwall":
			_sfx("parry", -7.0, 0.5)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "shieldwall", 1)
				if is_perfect:
					h.pressure = maxi(h.pressure - 10, 0)
					h.refresh_bars()
			_message("%s raises the shieldwall!" % attacker.unit_name)
			_log("%s: Shieldwall — party takes half damage" % attacker.unit_name, "#70d878")
		"mark":
			_sfx("click", -6.0, 1.2)
			_apply_status(target, "marked", 5 if is_perfect else 3)
			_message("%s marks %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Hunter's Mark on %s" % [attacker.unit_name, target.unit_name], "#70d878")
		"camo":
			_sfx("miss", -8.0)
			_apply_status(attacker, "camo", 2)
			if is_perfect:
				attacker.pressure = maxi(attacker.pressure - 10, 0)
				attacker.refresh_bars()
			_message("%s melts into cover" % attacker.unit_name)
			_log("%s: Camouflage" % attacker.unit_name, "#70d878")
		"retaliate":
			_sfx("parry", -7.0, 0.8)
			_apply_status(attacker, "retaliate", 4 if is_perfect else 3)
			_message("%s enters a retaliatory stance" % attacker.unit_name)
			_log("%s: Retaliation stance" % attacker.unit_name, "#70d878")
		"phoenix":
			var sacrifice := int(attacker.hp * (0.15 if is_perfect else 0.25))
			attacker.hp = maxi(attacker.hp - sacrifice, 1)
			attacker.resource = attacker.max_resource
			attacker.refresh_bars()
			attacker.float_text("-%d" % sacrifice, Color(1.0, 0.4, 0.5))
			attacker.float_text("Mana restored!", Color(0.5, 0.7, 1.0))
			_apply_status(attacker, "empower", 3)
			_sfx("heal", -6.0, 0.6)
			_message("%s burns with rebirth!" % attacker.unit_name)
			_log("%s: Phoenix Rebirth — sacrificed %d HP for full Mana" % [
				attacker.unit_name, sacrifice], "#70d878")
		"dawnbreak":
			var base := int((55 if is_perfect else 40) * mult)
			if attacker.passive_id == "grace":
				base = int(base * 1.25)
			var missing_hp := target.max_hp - target.hp
			var applied := mini(base, missing_hp)
			target.heal_amount(applied)
			target.float_text("+%d" % applied, Color(0.4, 0.9, 0.45))
			var overflow := base - applied
			if overflow > 0 and target != attacker:
				attacker.heal_amount(overflow)
				attacker.float_text("+%d" % overflow, Color(0.4, 0.9, 0.45))
			_sfx("heal", -6.0)
			_stat("healing", base)
			_message("%s calls the dawn" % attacker.unit_name)
			_log("%s: Dawnbreak heals %s for %d (overflow %d to self)" % [
				attacker.unit_name, target.unit_name, applied, overflow], "#70d878")
		"hymn":
			var pct := 0.25 if is_perfect else 0.20
			if attacker.passive_id == "grace":
				pct *= 1.25
			_sfx("heal", -4.0, 0.9)
			for h in heroes.filter(func(he): return not he.dead):
				var amt := int(h.max_hp * pct)
				h.heal_amount(amt)
				h.float_text("+%d" % amt, Color(0.4, 0.9, 0.45))
				_stat("healing", amt)
			_message("MIRACLE — Hymn of Hope!")
			_log("%s: Hymn of Hope — party heals %d%%" % [attacker.unit_name,
				int(pct * 100)], "#70d878")
		"sanctuary":
			var sanct_pct := 0.18 if is_perfect else 0.12
			if attacker.passive_id == "grace":
				sanct_pct *= 1.25
			_sfx("heal", -4.0, 0.8)
			for h in heroes.filter(func(he): return not he.dead):
				var amt := int(h.max_hp * sanct_pct)
				h.heal_amount(amt)
				h.float_text("+%d" % amt, Color(0.4, 0.9, 0.45))
				_apply_status(h, "shieldwall", 1)
				_stat("healing", amt)
			_message("MIRACLE — Sanctuary!")
			_log("%s: Sanctuary — party healed and walled" % attacker.unit_name, "#70d878")
		"benediction":
			if not is_perfect:
				var blood_cost := int(attacker.max_hp * 0.10)
				attacker.hp = maxi(attacker.hp - blood_cost, 1)
				attacker.float_text("-%d" % blood_cost, Color(1.0, 0.4, 0.5))
			_sfx("heal", -5.0, 0.7)
			for h in heroes.filter(func(he): return not he.dead):
				var amt := int(h.max_hp * 0.15 * (1.25 if attacker.passive_id == "grace" else 1.0))
				h.heal_amount(amt)
				h.float_text("+%d" % amt, Color(0.4, 0.9, 0.45))
				_apply_status(h, "empower", 3)
				_stat("healing", amt)
			attacker.refresh_bars()
			_message("MIRACLE — Dark Benediction!")
			_log("%s: Dark Benediction — blood for power" % attacker.unit_name, "#70d878")
		"renewal":
			_sfx("heal", -9.0, 1.1)
			_apply_status(target, "renewal", 5)
			if is_perfect:
				target.heal_amount(8)
				target.float_text("+8", Color(0.4, 0.9, 0.45))
			_message("%s blesses %s with Renewal" % [attacker.unit_name, target.unit_name])
			_log("%s: Renewal on %s — 8 HP/turn for 5 turns" % [attacker.unit_name,
				target.unit_name], "#70d878")


# Unique bonus effects for Perfect skill checks (per ability).
func _apply_perfect_bonus(attacker: BattleUnit, target: BattleUnit, ab: Ability, target_died: bool) -> void:
	match ab.perfect_id:
		"rage":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+10 Rage", Color(1.0, 0.5, 0.4))
			_log("   → %s gains +10 Rage" % attacker.unit_name, "#b0a8e0")
		"focus":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+10 Focus", Color(0.6, 0.9, 0.5))
			_log("   → %s gains +10 Focus" % attacker.unit_name, "#b0a8e0")
		"mana":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
			_log("   → %s restores 10 Mana" % attacker.unit_name, "#b0a8e0")
		"self_heal":
			attacker.heal_amount(8)
			attacker.float_text("+8", Color(0.4, 0.9, 0.45))
			_log("   → %s recovers 8 HP" % attacker.unit_name, "#b0a8e0")
		"sunder":
			if not target_died:
				_apply_status(target, "sunder", 2)
		"burn":
			if not target_died:
				_apply_status(target, "burn", 2)


# ---------- skill check ----------

func _run_skill_check(cancellable := false) -> String:
	sc_pos = 0.0
	sc_dir = 1.0
	sc_result.text = ""
	sc_root.visible = true
	sc_active = true
	var cancel_btn: Button = null
	if cancellable:
		cancel_btn = Button.new()
		cancel_btn.text = "✕ Cancel"
		cancel_btn.custom_minimum_size = Vector2(104, 34)
		cancel_btn.position = Vector2(448, 20)
		cancel_btn.pressed.connect(_cancel_skill_check)
		sc_root.add_child(cancel_btn)
	var grade: String = await _skill_done
	if cancel_btn != null:
		cancel_btn.queue_free()
	if grade == "cancel":
		sc_root.visible = false
		return grade
	match grade:
		"perfect":
			_sfx("perfect", -6.0)
			sc_result.text = "PERFECT!"
			sc_result.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		"good":
			_sfx("click", -8.0)
			sc_result.text = "Good"
			sc_result.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
		"fail":
			_sfx("click", -10.0, 0.6)
			sc_result.text = "Sloppy..."
			sc_result.add_theme_color_override("font_color", Color(0.8, 0.4, 0.4))
	await _wait(0.45)
	sc_root.visible = false
	return grade


func _cancel_skill_check() -> void:
	if sc_active:
		sc_active = false
		_skill_done.emit("cancel")


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
	var victory := enemies.all(func(e): return e.dead)
	var defeat := heroes.all(func(h): return h.dead)
	if not victory and not defeat:
		return
	battle_over = true
	if sim:
		sim_done += 1
		_stat("battles")
		if victory:
			_stat("wins")
		for h in heroes:
			if not h.dead:
				_stat("surviving_hero_hp_pct", h.hp / float(h.max_hp))
				_stat("surviving_heroes")
		if sim_done < sim_target:
			get_tree().reload_current_scene()
		else:
			_print_sim_report()
			get_tree().quit()
		return
	if not Run.active:
		# Standalone battle scene (testing): simple restart loop.
		if victory:
			_sfx("victory", -4.0)
			_show_end("VICTORY", "The Decay recedes... for now.",
				[["Fight Again", func(): get_tree().reload_current_scene()]])
		else:
			_sfx("defeat", -4.0)
			_show_end("THE PARTY HAS FALLEN", "The cycle begins anew.",
				[["Fight Again", func(): get_tree().reload_current_scene()]])
		return

	# Run mode: sync state back and route through the map.
	for id in items:
		Run.items[id] = items[id][1]
	if victory:
		for i in heroes.size():
			# The Untouched refuse to stay down: the fallen return at 20% HP.
			Run.party[i]["hp"] = maxi(heroes[i].hp, int(heroes[i].max_hp * 0.2))
			if heroes[i].resource_name == "Mana":
				Run.party[i]["mana"] = heroes[i].resource
		var pts := Run.award_talent_points(Run.encounter.get("type", "fight"))
		var gold_gain := Run.award_gold(Run.encounter.get("type", "fight"))
		if Relics.has("chalice"):
			Run.heal_party(0.10)
		_sfx("victory", -4.0)
		if Run.encounter.get("type", "") == "boss":
			var relic := Relics.unlock_random()
			var boss_text := "+%d gold, %d talent points each." % [gold_gain, pts]
			if not relic.is_empty():
				boss_text += "\n\nRELIC UNLOCKED: %s\n%s" % [relic["name"], relic["desc"]]
			if Run.has_next_zone():
				_show_end("THE ZONE IS CLEANSED", boss_text,
					[["Descend into %s" % Run.ZONES[Run.zone_idx + 1], _next_zone]])
			else:
				Run.active = false
				_show_end("THE DECAY RECEDES", boss_text + "\nRun complete!",
					[["New Run", _start_new_run]])
		else:
			_show_end("VICTORY", "+%d gold. Each hero gains %d talent point%s." % [
				gold_gain, pts, "" if pts == 1 else "s"],
				[["Continue", _to_map]])
	else:
		Run.active = false
		_sfx("defeat", -4.0)
		_show_end("THE PARTY HAS FALLEN", "The Decay claims this cycle.",
			[["New Run", _start_new_run]])


func _next_zone() -> void:
	Run.advance_zone()
	_to_map()


func _to_map() -> void:
	# Route through the party screen so talent points get spent before
	# picking the next node.
	get_tree().change_scene_to_file("res://scenes/party.tscn")


func _start_new_run() -> void:
	Run.active = false
	get_tree().change_scene_to_file("res://scenes/draft.tscn")


func _print_sim_report() -> void:
	var battles := maxf(sim_stats.get("battles", 0.0), 1.0)
	var attacks := maxf(sim_stats.get("attacks", 0.0), 1.0)
	var landed := maxf(sim_stats.get("attack_landed", 0.0), 1.0)
	var elapsed := (Time.get_ticks_msec() - sim_started_ms) / 1000.0
	print("\n===== DAWN OF DECAY — SIMULATION REPORT =====")
	print("Battles: %d   Wins: %d (%.0f%%)   Sim time: %.1fs" % [int(battles),
		int(sim_stats.get("wins", 0.0)), 100.0 * sim_stats.get("wins", 0.0) / battles, elapsed])
	print("Avg rounds/battle (hero turns / 3): %.1f" % [
		sim_stats.get("hero_actions", 0.0) / battles / 3.0])
	print("Hero deaths/battle: %.2f   Survivors' avg HP: %.0f%%" % [
		sim_stats.get("hero_deaths", 0.0) / battles,
		100.0 * sim_stats.get("surviving_hero_hp_pct", 0.0) / maxf(sim_stats.get("surviving_heroes", 0.0), 1.0)])
	var hero_dmg := {}
	var hero_total := 0.0
	for key in sim_stats:
		if key.begins_with("dmg_hero_"):
			hero_dmg[key.trim_prefix("dmg_hero_")] = sim_stats[key]
			hero_total += sim_stats[key]
	var share_parts := PackedStringArray()
	for hero_name in hero_dmg:
		share_parts.append("%s %.0f%% (%.0f/battle)" % [hero_name,
			100.0 * hero_dmg[hero_name] / maxf(hero_total, 1.0), hero_dmg[hero_name] / battles])
	print("Hero damage share: %s" % " | ".join(share_parts))
	print("Enemy damage dealt/battle: %.0f   Healing/battle: %.0f" % [
		sim_stats.get("dmg_enemy", 0.0) / battles, sim_stats.get("healing", 0.0) / battles])
	print("Breaks/battle: on enemies %.2f, on heroes %.2f" % [
		sim_stats.get("breaks_on_enemies", 0.0) / battles,
		sim_stats.get("breaks_on_heroes", 0.0) / battles])
	print("Rolls: miss %.1f%%, parry %.1f%%, crit %.1f%% of landed" % [
		100.0 * sim_stats.get("attack_miss", 0.0) / attacks,
		100.0 * sim_stats.get("attack_parry", 0.0) / attacks,
		100.0 * sim_stats.get("attack_crit", 0.0) / landed])
	var usage_parts := PackedStringArray()
	for key in sim_stats:
		if key.begins_with("use_"):
			usage_parts.append("%s %.1f" % [key.trim_prefix("use_"), sim_stats[key] / battles])
	print("Hero ability uses/battle: %s" % " | ".join(usage_parts))
	print("=============================================\n")


func _show_end(title: String, subtitle: String, buttons: Array) -> void:
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
	for entry in buttons:
		var btn := Button.new()
		btn.text = entry[0]
		btn.custom_minimum_size = Vector2(240, 44)
		btn.pressed.connect(entry[1])
		vbox.add_child(btn)


# ---------- helpers ----------

const PACE := 0.85  # global combat pacing multiplier (lower = faster fights)


func _wait(seconds: float) -> void:
	if sim:
		await get_tree().process_frame
	else:
		await get_tree().create_timer(seconds * PACE).timeout


# One stat counter, accumulated across all simulated battles.
func _stat(key: String, amount := 1.0) -> void:
	if sim:
		sim_stats[key] = sim_stats.get(key, 0.0) + amount


var _sfx_players: Array = []
var _sfx_idx := 0


func _build_sfx_pool() -> void:
	for i in 8:
		var player := AudioStreamPlayer.new()
		add_child(player)
		_sfx_players.append(player)


# Slight random pitch variance keeps repeated sounds from feeling robotic.
func _sfx(sound: String, volume_db := -6.0, pitch := 1.0) -> void:
	if sim:
		return
	var player: AudioStreamPlayer = _sfx_players[_sfx_idx]
	_sfx_idx = (_sfx_idx + 1) % _sfx_players.size()
	player.stream = SFX[sound]
	player.volume_db = volume_db
	player.pitch_scale = clampf(pitch + randf_range(-0.05, 0.05), 0.1, 3.0)
	player.play()


func _shake() -> void:
	var tween := create_tween()
	for i in 4:
		tween.tween_property(self, "position", Vector2(randf_range(-8, 8), randf_range(-6, 6)), 0.05)
	tween.tween_property(self, "position", Vector2.ZERO, 0.05)


# The Break payoff moment: brief hitstop freeze, purple fracture flash,
# and a camera zoom punch (per the UI design doc).
func _break_impact() -> void:
	if sim:
		return
	# Hitstop: freeze the world for ~90ms of real time.
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.09, true, false, true).timeout
	Engine.time_scale = 1.0
	# Purple fracture flash over the whole screen.
	var overlay := ColorRect.new()
	overlay.size = Vector2(1280, 720)
	overlay.color = Color(0.60, 0.20, 0.90, 0.0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(overlay)
	var flash := create_tween()
	flash.tween_property(overlay, "color:a", 0.28, 0.05)
	flash.tween_property(overlay, "color:a", 0.0, 0.35)
	flash.tween_callback(overlay.queue_free)
	# Camera zoom punch.
	var punch := create_tween()
	punch.tween_property(cam, "zoom", Vector2(1.27, 1.27), 0.08) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	punch.tween_property(cam, "zoom", Vector2(1.2, 1.2), 0.25)
