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
	"slow": ["Slowed", "Sl", Color(0.55, 0.65, 0.9), "-25% speed; turns arrive later."],
	"chilled": ["Chilled", "Ch", Color(0.5, 0.75, 1.0), "-25% speed; turns arrive later.\nThe Cryomancer's signature frost."],
	"burn": ["Burn", "F", Color(1.0, 0.55, 0.2), "Takes 6 damage at the start of each turn."],
	"bleed": ["Bleed", "Bl", Color(0.85, 0.25, 0.25), "Bleed builds with wounding attacks;\nat 100 the target bleeds out for 20% max HP.\nBleed damage ignores armor."],
	"sunder": ["Sunder", "D", Color(0.7, 0.7, 0.7), "-35% armor."],
	"ward": ["Ward", "W", Color(1.0, 0.85, 0.4), "Takes 50% less Pressure."],
	"fortify": ["Fortify", "+D", Color(0.55, 0.8, 0.9), "+10% armor."],
	"barrier": ["Barrier", "Ba", Color(0.40, 0.85, 0.95), "Absorbs incoming damage."],
	"focus": ["Focus", "Fo", Color(0.35, 0.60, 1.0), "Restores 10 Mana each turn."],
	"renewal": ["Renewal", "R+", Color(0.45, 0.90, 0.50), "Restores 8 HP each turn."],
	"surge": ["Surge", "A+", Color(0.80, 0.50, 1.0), "+20% attack."],
	"mocked": ["Mocked", "M!", Color(0.95, 0.5, 0.3), "Must attack the Warrior who mocked them."],
	"poison": ["Poison", "P", Color(0.45, 0.8, 0.3), "Takes 3 nature damage per stack at the\nstart of each turn; new stacks refresh\nthe timer."],
	"quickdraw": ["Quick Draw", "QD", Color(0.55, 0.85, 0.40), "All abilities act 50% faster;\nturns arrive sooner."],
	"parry_up": ["Parry Up", "P+", Color(0.4, 0.9, 1.0), "+15% parry chance."],
	"mana_shield": ["Mana Shield", "MS", Color(0.35, 0.6, 1.0), "50% of damage taken converts\ninto Mana."],
	"rampage": ["Rampage", "Rp", Color(0.9, 0.3, 0.3), "+1% damage per 10 Bleed buildup\non the enemy party (at cast time)."],
	"unity": ["Unity", "Un", Color(0.95, 0.85, 0.4), "Souls bound: all damage received is\nsplit evenly among the party."],
	"mindflay": ["Mind Flay", "MF", Color(0.75, 0.35, 0.85), "Maddened: attacks its own allies\nwith bonus Break damage."],
	"devotion": ["Devotion Aura", "DA", Color(0.95, 0.8, 0.45), "The Devout's presence: takes 15%\nless Pressure."],
	"tripwire": ["Tripwire", "TW", Color(0.8, 0.65, 0.35), "Retaliates against every attacking\nmelee enemy for 75% of their damage."],
	"stunned": ["Stunned", "St", Color(0.95, 0.9, 0.4), "Loses their next turn."],
	"shieldwall": ["Shieldwall", "SW", Color(0.6, 0.7, 0.9), "Takes 25% less damage."],
	"empower": ["Empower", "+A", Color(0.95, 0.45, 0.35), "+25% damage dealt."],
	"exposed": ["Exposed", "E", Color(0.95, 0.9, 0.4), "Takes 15% more damage."],
	"cripple": ["Cripple", "C", Color(0.5, 0.4, 0.55), "-25% damage dealt."],
	"retaliate": ["Retaliation", "R!", Color(0.95, 0.6, 0.25), "Counters attackers with a basic strike."],
	"dazed": ["Dazed", "Dz", Color(0.95, 0.7, 0.35), "Attacks are 20% more likely to miss."],
	"shielded": ["Shielded", "Sh", Color(0.95, 0.65, 0.25), "Takes 25% less damage\n(a Shieldmaster's ward)."],
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
	"bow_attack": preload("res://assets/sfx/bow_attack.wav"),
	"bow_blocked": preload("res://assets/sfx/bow_blocked.wav"),
	"bow_impact": preload("res://assets/sfx/bow_impact.wav"),
	"strike": preload("res://assets/sfx/strike.wav"),
	"wildstrikes": preload("res://assets/sfx/wildstrikes.wav"),
	"hack_slash": preload("res://assets/sfx/hack_slash.wav"),
	"potion": preload("res://assets/sfx/potion.wav"),
}

# Damage-over-time statuses ticked at the start of the afflicted unit's turn.
# Poison is per-stack (stacks handled at the tick site).
const DOT_STATUSES := {"burn": 6, "poison": 3}

var heroes: Array = []
var enemies: Array = []
var companions: Array = []  # Beastmaster summons: hero-side, but no turns
var battle_over := false
var current_hero: BattleUnit

# Shared party inventory built from Run.ITEM_INFO: id -> [label, count, tooltip]
var items := {}
var item_used := false  # one item per character per turn

var ui: CanvasLayer
var cam: Camera2D
var turn_bar: HBoxContainer
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
var debug_enemies_off := false  # debug toggle: enemies skip their turns

# Accumulated across scene reloads within one simulation run.
static var sim_stats := {}
static var sim_done := 0
static var sim_started_ms := 0

var history: RichTextLabel

var sc_root: Control
var sc_cursor: ColorRect
var sc_result: Label
var sc_cancel: Button
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
	if Run.debug_enabled() and not autoplay:
		_build_debug_panel()
	if not sim:
		# Boss fights open with the entry tune, capped so the battle track
		# doesn't keep the fight waiting.
		if Run.active and Run.encounter.get("type", "") == "boss":
			Music.play_intro_then("boss_intro", "battle", 4.0)
		else:
			Music.play("battle")
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
	# Battle background art per zone, scaled uniformly to cover the view.
	var bg_by_zone := {
		"Forest of Old": "res://assets/backgrounds/battle_background_1.png",
		"The Scarlands": "res://assets/backgrounds/battle_background_scarlands.png",
	}
	var zone: String = Run.zone_name if Run.active else "Forest of Old"
	var tex: Texture2D = load(bg_by_zone.get(zone, bg_by_zone["Forest of Old"]))
	var art := Sprite2D.new()
	art.texture = tex
	var cover := maxf(1680.0 / tex.get_width(), 920.0 / tex.get_height())
	art.scale = Vector2(cover, cover)
	art.position = Vector2(640, 360)
	add_child(art)
	# Camera at 1:1 so the whole battle scene is visible (sprites are scaled
	# up to compensate; UI is on a CanvasLayer and unaffected).
	cam = Camera2D.new()
	cam.position = Vector2(640, 360)
	cam.zoom = Vector2(1.0, 1.0)
	add_child(cam)
	cam.make_current()


# Kept high enough that the bottom row's bars and status chips stay on screen.
const HERO_SLOTS := [Vector2(430, 350), Vector2(240, 435), Vector2(430, 520), Vector2(240, 605)]
const ENEMY_LAYOUTS := {
	1: [Vector2(1000, 470)],
	2: [Vector2(920, 400), Vector2(1000, 560)],
	3: [Vector2(900, 380), Vector2(1050, 480), Vector2(940, 585)],
	4: [Vector2(880, 360), Vector2(1060, 440), Vector2(880, 520), Vector2(1060, 600)],
	5: [Vector2(880, 350), Vector2(1060, 415), Vector2(880, 480), Vector2(1060, 545),
		Vector2(950, 610)],
}


func _enemy_config(kind: String) -> Dictionary:
	var orc := "res://assets/sprites/orc"
	match kind:
		"chief":
			return {"unit_name": "Orc Chief", "is_hero": false, "sheet_dir": orc,
				"max_hp": 242, "armor": 0.20, "speed": 80.0, "stability": 100,
				"constitution": 130,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 3.9,
				"tint": Color(1.0, 0.75, 0.7),
				"resists": {"physical": 0.15}}
		"boss":
			# Zone 1's Withered Warden has its own kit; later bosses are still
			# Chief stand-ins until their unique kits and art exist.
			if (Run.zone_idx if Run.active else 0) == 0:
				return {"unit_name": "Withered Warden", "is_hero": false,
					"sheet_dir": orc, "max_hp": 500, "armor": 0.35, "speed": 80.0,
					"stability": 100, "constitution": 150, "is_boss": true,
					"abilities": _withered_warden_kit(), "sprite_scale": 4.4,
					"tint": Color(0.7, 1.0, 0.7), "resists": {"nature": 0.75}}
			return {"unit_name": "Ash-Wrought Tyrant", "is_hero": false, "sheet_dir": orc,
				"max_hp": 368, "armor": 0.22, "speed": 85.0, "stability": 100,
				"constitution": 160, "is_boss": true,
				"resource_name": "Rage", "resource": 20, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 4.4,
				"tint": Color(1.0, 0.55, 0.35),
				"resists": {"fire": 0.50, "physical": 0.10, "frost": -0.25}}
		"shieldmaster":
			return {"unit_name": "Orc Shieldmaster", "is_hero": false, "sheet_dir": orc,
				"max_hp": 150, "armor": 0.25, "speed": 85.0, "stability": 100,
				"constitution": 120,
				"abilities": _orc_shieldmaster_kit(), "tint": Color(1.0, 0.62, 0.2),
				"resists": {}}
		"shaman":
			return {"unit_name": "Orc Shaman", "is_hero": false, "sheet_dir": orc,
				"max_hp": 110, "armor": 0.01, "speed": 100.0, "stability": 100,
				"constitution": 80,
				"is_ranged": true,
				"abilities": _orc_shaman_kit(), "tint": Color(0.4, 0.55, 1.0),
				"resists": {}}
		"archer":
			return {"unit_name": "Orc Archer", "is_hero": false, "sheet_dir": orc,
				"max_hp": 104, "armor": 0.10, "speed": 100.0, "stability": 100,
				"constitution": 85,
				"is_ranged": true,
				"abilities": _orc_archer_kit(), "tint": Color(1.0, 0.35, 0.35),
				"resists": {"physical": 0.05}}
		_:
			return {"unit_name": "Orc Raider", "is_hero": false, "sheet_dir": orc,
				"max_hp": 132, "armor": 0.15, "speed": 90.0, "stability": 100,
				"constitution": 100,
				"abilities": _orc_raider_kit(), "tint": Color.WHITE,
				"resists": {"physical": 0.10}}


func _spawn_units() -> void:
	var hero_keys := ["warrior", "mage", "cleric", "hunter"]
	if Run.active:
		hero_keys = []
		for member in Run.party:
			hero_keys.append(member["key"])
	# DOD_SIM_SPECS="berserker,cryomancer,inquisitor,beastmaster" overrides the
	# specs used by autoplay/sim battles (order: warrior, mage, cleric, hunter).
	var sim_specs := ["swordmaster", "pyromancer", "holy", "sharpshooter"]
	var env_specs := OS.get_environment("DOD_SIM_SPECS")
	if env_specs != "":
		sim_specs = env_specs.split(",")
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
			# Role-based break resistance replaces the class base once specced.
			cfg["constitution"] = Classes.SPEC_INFO[spec].get("constitution",
				cfg.get("constitution", 100))
			# Arcane Resonance is the Arcanist's passive mechanic alone.
			if spec == "arcanist":
				cfg["second_resource_name"] = "Resonance"
				cfg["second_resource"] = 0
				cfg["second_max"] = 5
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
			if Run.relic_active("dragonbone"):
				cfg["dmg_bonus"] = cfg.get("dmg_bonus", 0.0) + 0.10
			if Run.relic_active("emberheart"):
				var bonuses: Dictionary = cfg.get("type_dmg_bonus", {})
				bonuses["fire"] = bonuses.get("fire", 0.0) + 0.20
				bonuses["holy"] = bonuses.get("holy", 0.0) + 0.20
				cfg["type_dmg_bonus"] = bonuses
		# Percentage HP talents (Vitality) apply after every flat bonus.
		cfg["max_hp"] = int(round(cfg["max_hp"] * (1.0 + cfg.get("max_hp_pct", 0.0))))
		var u := _make_unit(cfg, HERO_SLOTS[i], Classes.HERO_TINTS[i])
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

	# Devotion Aura (Devout): the whole party takes less Pressure, shown as a
	# battle-long status on everyone.
	if heroes.any(func(h): return h.passive_id == "devotion"):
		for h in heroes:
			_apply_status(h, "devotion", -1)

	var composition: Array = ["raider", "chief", "archer", "archer"]
	# DOD_SIM_ENEMIES="boss,shieldmaster,shaman" forces the enemy lineup in
	# autoplay/sim/standalone battles (testing hook, like DOD_SIM_SPECS).
	var env_comp := OS.get_environment("DOD_SIM_ENEMIES")
	if env_comp != "":
		composition = env_comp.split(",")
	elif Run.active and Run.encounter.has("enemies"):
		composition = Run.encounter["enemies"]
	var layout: Array = ENEMY_LAYOUTS[clampi(composition.size(), 1, 5)]
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
		Ability.make({"display_name": "Slash", "damage": 34, "pressure": 26,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Sundering Strike", "damage": 23, "pressure": 22,
			"delay": 2.5, "anim": "attack02",
			"applies_status": {"id": "sunder", "turns": 2}, "status_chance": 0.6}),
	]


func _orc_archer_kit() -> Array:
	return [
		Ability.make({"display_name": "Arrow Shot", "damage": 21, "pressure": 16,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Poison Arrow", "damage": 16, "pressure": 14,
			"delay": 2.5, "anim": "attack02",
			"applies_status": {"id": "poison", "turns": 3}, "status_chance": 0.7}),
	]


# The Shieldmaster guards its warband: one ally at a time carries its ward.
func _orc_shieldmaster_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "damage": 28, "pressure": 20,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Shielding", "special": "enemy_shield",
			"delay": 2.5, "anim": "attack02", "target": Ability.Target.ALLY,
			"description": "Wards an ally: 25% less damage taken for 3 turns."}),
	]


func _orc_shaman_kit() -> Array:
	return [
		Ability.make({"display_name": "Lightning Bolt", "damage": 35, "pressure": 20,
			"delay": 2.0, "anim": "attack01", "dmg_type": "nature"}),
		Ability.make({"display_name": "Chain Lightning", "damage": 15, "pressure": 15,
			"delay": 3.0, "anim": "attack02", "dmg_type": "nature", "aoe": true}),
	]


# Zone 1 boss: a nature bruiser that dazes, poisons, and tends its escorts.
func _withered_warden_kit() -> Array:
	return [
		Ability.make({"display_name": "Timber Slam", "damage": 60, "pressure": 30,
			"delay": 3.0, "anim": "attack01", "dmg_type": "nature",
			"applies_status": {"id": "dazed", "turns": 3}}),
		Ability.make({"display_name": "Roots of Wrath", "damage": 25, "pressure": 20,
			"delay": 3.5, "anim": "attack02", "dmg_type": "nature", "aoe": true,
			"applies_status": {"id": "poison", "turns": 3}}),
		Ability.make({"display_name": "Wild Growth", "special": "wild_growth",
			"delay": 2.5, "anim": "attack02", "target": Ability.Target.ALLY,
			"description": "Heals an ally for 20% of their max health."}),
	]


# The Chief fights like a weaker Warrior: builds Rage, spends it on heavy hits.
func _orc_chief_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "damage": 28, "pressure": 26,
			"resource_gain": 15, "delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Heavy Strike", "cost": 30, "damage": 54,
			"pressure": 40, "delay": 4.0, "anim": "attack02"}),
		Ability.make({"display_name": "Crushing Blow", "cost": 20, "damage": 34,
			"pressure": 56, "delay": 4.0, "anim": "attack02"}),
	]


# ---------- UI ----------

func _build_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)

	# Burger menu: run controls without leaving the battle scene.
	var burger := MenuButton.new()
	burger.text = "☰"
	burger.custom_minimum_size = Vector2(46, 42)
	burger.position = Vector2(16, 12)
	burger.flat = false
	var bpop := burger.get_popup()
	bpop.add_item("Restart Run", 0)
	bpop.add_item("Settings", 1)
	bpop.add_item("Exit to Main Menu", 2)
	bpop.id_pressed.connect(_on_burger)
	ui.add_child(burger)

	var bar_panel := PanelContainer.new()
	bar_panel.position = Vector2(70, 12)
	ui.add_child(bar_panel)
	turn_bar = HBoxContainer.new()
	turn_bar.add_theme_constant_override("separation", 4)
	bar_panel.add_child(turn_bar)

	var bottom_center := CenterContainer.new()
	bottom_center.position = Vector2(0, 660)
	bottom_center.size = Vector2(1280, 56)
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
	hint.text = "SPACE or CLICK!"
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


# Testing panel (DOD_DEBUG=1): jump the turn order and refill the party.
func _build_debug_panel() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(968, 206)
	panel.self_modulate = Color(1, 1, 1, 0.85)
	ui.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	panel.add_child(box)
	var title := Label.new()
	title.text = "DEBUG"
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(1.0, 0.6, 0.3))
	box.add_child(title)
	var restore := Button.new()
	restore.text = "Full Restore"
	restore.add_theme_font_size_override("font_size", 12)
	restore.pressed.connect(_debug_full_restore)
	box.add_child(restore)
	var hero_turn := Button.new()
	hero_turn.text = "Hero Turn Now"
	hero_turn.add_theme_font_size_override("font_size", 12)
	hero_turn.tooltip_text = "The next turn goes to a hero,\nwhatever the timeline says."
	hero_turn.pressed.connect(_debug_hero_turn)
	box.add_child(hero_turn)
	var no_enemies := CheckBox.new()
	no_enemies.text = "Enemy attacks OFF"
	no_enemies.add_theme_font_size_override("font_size", 12)
	no_enemies.tooltip_text = "While checked, enemies skip their turns."
	no_enemies.toggled.connect(_debug_toggle_enemies)
	box.add_child(no_enemies)


func _debug_full_restore() -> void:
	for u in heroes + companions:
		if u.dead:
			continue
		u.hp = u.max_hp
		u.resource = u.max_resource
		if u.second_resource_name != "":
			u.second_resource = u.second_max
		u.refresh_bars()
	_log("DEBUG: party fully restored", "#e0a050")


# Force the next turn to a hero (the one due soonest), whatever the order says.
func _debug_hero_turn() -> void:
	var living: Array = heroes.filter(func(h): return not h.dead)
	if living.is_empty():
		return
	var soonest: BattleUnit = living[0]
	for h in living:
		if h.next_time < soonest.next_time:
			soonest = h
	var best := _next_unit()
	if best != null and not best.is_hero:
		soonest.next_time = best.next_time - 0.01
	_rebuild_turn_bar()
	_log("DEBUG: %s acts next" % soonest.unit_name, "#e0a050")


func _debug_toggle_enemies(off: bool) -> void:
	debug_enemies_off = off
	_log("DEBUG: enemy attacks %s" % ("OFF" if off else "back on"), "#e0a050")


func _on_burger(id: int) -> void:
	match id:
		0:  # Restart Run: abandon this run and head back to the draft.
			Run.clear_save()
			Run.active = false
			get_tree().change_scene_to_file("res://scenes/draft.tscn")
		1:
			_open_settings_overlay()
		2:  # The run resumes from the last saved map node.
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# In-battle settings: a small overlay so the fight isn't lost to a scene change.
func _open_settings_overlay() -> void:
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.55)
	ui.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(440, 220)
	panel.custom_minimum_size = Vector2(400, 240)
	ui.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "Settings"
	title.add_theme_font_size_override("font_size", 24)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var vol_label := Label.new()
	vol_label.text = "Master Volume"
	vbox.add_child(vol_label)
	var vol := HSlider.new()
	vol.min_value = 0.0
	vol.max_value = 1.0
	vol.step = 0.05
	vol.value = Settings.volume
	vol.custom_minimum_size = Vector2(360, 30)
	vol.value_changed.connect(_on_overlay_volume)
	vbox.add_child(vol)
	var fs := CheckBox.new()
	fs.text = "Fullscreen"
	fs.button_pressed = Settings.fullscreen
	fs.toggled.connect(_on_overlay_fullscreen)
	vbox.add_child(fs)
	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(160, 40)
	close.pressed.connect(_close_settings_overlay.bind(dim, panel))
	vbox.add_child(close)


func _on_overlay_volume(v: float) -> void:
	Settings.volume = v
	Settings.apply()
	Settings.save()


func _on_overlay_fullscreen(on: bool) -> void:
	Settings.fullscreen = on
	Settings.apply()
	Settings.save()


func _close_settings_overlay(dim: ColorRect, panel: PanelContainer) -> void:
	dim.queue_free()
	panel.queue_free()


# Announcer banner removed by design: battle info lives in the combat log
# and floating text. Kept as a stub so resolve code stays readable.
func _message(_text: String) -> void:
	pass


# Appends one line to the battle history panel.
func _log(text: String, color := "#d8d2c4") -> void:
	history.append_text("[color=%s]%s[/color]\n" % [color, text])


func _rebuild_turn_bar(preview_unit: BattleUnit = null, preview_ability: Ability = null) -> void:
	for child in turn_bar.get_children():
		child.queue_free()
	var alive := (heroes + enemies).filter(func(u): return not u.dead)
	if alive.is_empty():
		return
	var sim: Array = alive.map(func(u): return {"unit": u, "t": u.next_time})
	if preview_unit != null and preview_ability != null:
		for entry in sim:
			if entry.unit == preview_unit:
				entry.t += preview_ability.delay * 100.0 / preview_unit.effective_speed()
	for i in 14:
		var best: Dictionary = sim[0]
		for entry in sim:
			if entry.t < best.t:
				best = entry
		var u: BattleUnit = best.unit
		var is_ghost: bool = preview_unit != null and u == preview_unit \
			and not best.get("ghost_shown", false)
		if is_ghost:
			best["ghost_shown"] = true
		var slot := VBoxContainer.new()
		var portrait := TextureRect.new()
		portrait.texture = u.portrait()
		portrait.custom_minimum_size = Vector2(48, 66)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.flip_h = not u.is_hero
		portrait.mouse_filter = Control.MOUSE_FILTER_STOP
		portrait.tooltip_text = u.unit_name
		portrait.mouse_entered.connect(u.set_highlight.bind(true))
		portrait.mouse_exited.connect(u.set_highlight.bind(false))
		if is_ghost:
			portrait.modulate = Color(1.0, 0.9, 0.45, 0.7)
			portrait.tooltip_text += " (your next turn if you cast this)"
		slot.add_child(portrait)
		var stripe := ColorRect.new()
		stripe.custom_minimum_size = Vector2(48, 4)
		stripe.color = Color(0.35, 0.8, 0.4) if u.is_hero else Color(0.85, 0.3, 0.3)
		if is_ghost:
			stripe.color = Color(1.0, 0.85, 0.3)
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
		active_marker.position = u.position + Vector2(-11, -150)
		for dot_id in DOT_STATUSES:
			if u.has_status(dot_id) and not u.dead:
				# Poison never ticks on the turn it was applied.
				if dot_id == "poison":
					var pstatus: Dictionary = u.get_status("poison")
					if pstatus.get("fresh", false):
						pstatus["fresh"] = false
						continue
				var dot_dmg: int = DOT_STATUSES[dot_id]
				var stack_tag := ""
				if dot_id == "poison":
					var stacks := maxi(u.status_stacks("poison"), 1)
					dot_dmg *= stacks
					stack_tag = " (x%d stacks)" % stacks if stacks > 1 else ""
					# Poison counts as nature damage: nature resists apply.
					var nat_resist := float(u.resists.get("nature", 0.0))
					if nat_resist != 0.0:
						dot_dmg = maxi(int(round(dot_dmg * (1.0 - nat_resist))), 0)
						stack_tag += " (resisted)" if nat_resist > 0.0 else " (vulnerable!)"
				var info: Array = STATUS_INFO[dot_id]
				_sfx("hit", -14.0, 0.8)
				var dot_died: bool = u.take_tick_damage(dot_dmg, "-%d %s" % [dot_dmg, info[0]], info[2])
				_log("%s takes %d %s damage%s" % [u.unit_name, dot_dmg, info[0],
					stack_tag], "#e08850")
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
		if u.has_status("stunned"):
			u.remove_status("stunned")
			u.float_text("STUNNED", Color(0.95, 0.9, 0.4))
			_log("%s is stunned and loses their turn" % u.unit_name, "#e0d060")
			await _wait(0.8)
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			continue
		u.tick_statuses()
		if u.enraged_ranks > 0:
			u.turns_since_damaged += 1
			if u.turns_since_damaged > 2 and u.enraged_stacks > 0:
				u.enraged_stacks = 0
				u.float_text("Enraged fades", Color(0.7, 0.5, 0.4))
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


# Everything enemies can target / allies can help: heroes plus living companions.
func _hero_side() -> Array:
	var side: Array = heroes.filter(func(h): return not h.dead)
	for c in companions:
		if not c.dead:
			side.append(c)
	return side


func _player_turn(u: BattleUnit) -> void:
	if enemies.all(func(e): return e.dead):
		return  # a companion or DoT already ended it; the loop will notice
	current_hero = u
	item_used = false
	if u.resource_name == "Mana":
		u.resource = mini(u.resource + 12, u.max_resource)
		u.refresh_bars()
	elif u.resource_name == "Focus":
		u.resource = mini(u.resource + 15, u.max_resource)
		u.refresh_bars()
	elif u.resource_name == "Rage":
		u.resource = mini(u.resource + 5, u.max_resource)
		u.refresh_bars()
	# Companions have no turns of their own: their statuses tick (and Breaks
	# recover) with their master.
	if u.companion != null and not u.companion.dead:
		u.companion.tick_statuses()
		if u.companion.broken:
			u.companion.broken_pending = false
			u.companion.recover_from_break()
	_show_actions(u)
	var ab: Ability
	var auto_target: BattleUnit = null
	if autoplay:
		var pick := _autoplay_pick(u)
		ab = pick[0]
		auto_target = pick[1]
	else:
		ab = await _ability_picked
		_preview_locked = true
		_rebuild_turn_bar(u, ab)
	action_panel.visible = false

	var target: BattleUnit = null
	var grade := "good"
	while true:
		var used_targeting := false
		if ab.special in ["rally", "focus", "surge", "shieldwall", "quickdraw",
				"phoenix", "hymn", "retaliate", "unity", "tripwire", "summon",
				"mana_shield"]:
			target = u  # self/party effects need no target choice
		elif ab.aoe or ab.random_hits > 0:
			var foes := enemies.filter(func(e): return not e.dead)
			target = foes[0]  # resolve picks the real targets
		elif autoplay:
			target = auto_target
		else:
			var pool: Array
			if ab.target == Ability.Target.ALLY:
				pool = _hero_side()
			else:
				pool = enemies.filter(func(e): return not e.dead)
			if pool.size() == 1:
				target = pool[0]
			else:
				used_targeting = true
				target = await _pick_target(pool)
		# Dual-choice abilities pick a second, different enemy (the bot skips
		# the click and lets _resolve pick its second target randomly).
		second_target = null
		if target != null and ab.choose_two and not autoplay:
			var pool2: Array = enemies.filter(func(e): return not e.dead and e != target)
			if pool2.size() == 1:
				second_target = pool2[0]
			elif pool2.size() > 1:
				used_targeting = true
				second_target = await _pick_target(pool2)
				if second_target == null:
					target = null  # cancelled: back to the action bar
		if target != null:
			if autoplay:
				var roll := randf()
				grade = "perfect" if roll < 0.20 else ("fail" if roll > 0.85 else "good")
				break
			if ab.no_skill_check:
				grade = "good"
				break
			# Auto-cast abilities (no target click) can cancel during the skill check.
			grade = await _run_skill_check(true)
			if grade != "cancel":
				break
		# Cancelled: back to the action bar to pick something else.
		_preview_locked = false
		_rebuild_turn_bar()
		_show_actions(u)
		ab = await _ability_picked
		_preview_locked = true
		_rebuild_turn_bar(u, ab)
		action_panel.visible = false
	await _resolve(u, ab, target, grade)
	_preview_locked = false
	current_hero = null


# Simple hero policy for automated battles: heal when hurt, spend when able,
# focus the weakest (preferring Broken) enemy.
func _autoplay_pick(u: BattleUnit) -> Array:
	var foes := enemies.filter(func(e): return not e.dead)
	if foes.is_empty():
		return [u.abilities[0], u]  # battle is over; the loop ends it
	var allies := heroes.filter(func(h): return not h.dead)
	var broken_foes := foes.filter(func(e): return e.broken)
	var target_foe: BattleUnit = _lowest_hp(broken_foes) if not broken_foes.is_empty() \
		else _lowest_hp(foes)
	var weakest_ally := _lowest_hp(allies)
	match u.unit_name:
		"Warrior":
			var pommel := _find_ability(u, "Pommel Strike")
			if pommel != null and u.resource >= pommel.cost and randf() < 0.35:
				return [pommel, target_foe]
			var hack := _find_ability(u, "Hack and Slash")
			if hack != null and u.resource >= hack.cost and randf() < 0.4:
				return [hack, target_foe]
			var crushing := _find_ability(u, "Crushing Blow")
			if crushing != null and u.resource >= crushing.cost \
					and not target_foe.has_status("sunder"):
				return [crushing, target_foe]
			var overpower := _find_ability(u, "Overpower")
			if overpower != null and u.resource >= overpower.cost:
				return [overpower, target_foe]
			return [u.abilities[0], target_foe]          # Strike
		"Mage":
			var mshield := _find_ability(u, "Mana Shield")
			if mshield != null and u.resource >= mshield.cost \
					and not u.has_status("mana_shield") and u.resource < 40:
				return [mshield, u]
			var flame := _find_ability(u, "Flame Surge")
			if flame != null and u.resource >= flame.cost and foes.size() >= 2:
				return [flame, target_foe]
			var dray := _find_ability(u, "Death Ray")
			if dray != null and u.second_resource >= 5:
				return [dray, target_foe]
			var barrage := _find_ability(u, "Arcane Barrage")
			if barrage != null and u.resource >= barrage.cost and foes.size() >= 2:
				return [barrage, target_foe]
			var fbolt := _find_ability(u, "Frost Bolt")
			if fbolt != null and u.resource >= fbolt.cost:
				return [fbolt, target_foe]
			return [u.abilities[0], target_foe]          # Magic Bolt
		"Hunter":
			var summon := _find_ability(u, "Summon Canis")
			if summon != null and u.resource >= summon.cost \
					and (u.companion == null or u.companion.dead):
				return [summon, u]
			var kill_cmd := _find_ability(u, "Kill Command")
			if kill_cmd != null and u.resource >= kill_cmd.cost \
					and u.companion != null and not u.companion.dead:
				return [kill_cmd, target_foe]
			var parrow := _find_ability(u, "Poisoned Arrow")
			if parrow != null and u.resource >= parrow.cost and randf() < 0.4 \
					and not target_foe.has_status("poison"):
				return [parrow, target_foe]
			var shrapnel := _find_ability(u, "Shrapnel Charge")
			if shrapnel != null and u.resource >= shrapnel.cost and foes.size() >= 2:
				return [shrapnel, target_foe]
			var aimed := _find_ability(u, "Aimed Shot")
			if aimed != null and u.resource >= aimed.cost:
				return [aimed, target_foe]
			return [u.abilities[0], target_foe]          # Quick Shot
		"Cleric":
			var hymn := _find_ability(u, "Hymn of Hope")
			if hymn != null and u.second_resource >= hymn.faith_cost \
					and weakest_ally.hp < weakest_ally.max_hp * 0.6:
				return [hymn, u]
			var unity_ab := _find_ability(u, "Unity")
			if unity_ab != null and u.second_resource >= unity_ab.faith_cost \
					and weakest_ally.hp < weakest_ally.max_hp * 0.7:
				return [unity_ab, u]
			var flay := _find_ability(u, "Mind Flay")
			if flay != null and u.second_resource >= flay.faith_cost and foes.size() >= 2:
				return [flay, target_foe]
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
# Cancelled a targeted item: give it back and reopen the action bar.
func _refund_item(item_id: String) -> void:
	items[item_id][1] += 1
	item_used = false
	if current_hero != null and not current_hero.dead:
		_show_actions(current_hero)


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
				heal_target = await _pick_target(living)
			if heal_target == null:
				_refund_item(item_id)
				return
			heal_target.heal_amount(40)
			_sfx("potion", -6.0)
			heal_target.float_text("+40", Color(0.4, 0.9, 0.45))
			_message("%s drinks a Health Potion" % heal_target.unit_name)
			_log("Item: Health Potion — %s +40 HP" % heal_target.unit_name, "#e0c060")
			await _wait(0.5)
		"mana":
			var drinkers := heroes.filter(func(h): return not h.dead)
			var mana_target: BattleUnit = drinkers[0]
			if drinkers.size() > 1:
				mana_target = await _pick_target(drinkers)
			if mana_target == null:
				_refund_item(item_id)
				return
			mana_target.resource = mini(mana_target.resource + 40, mana_target.max_resource)
			mana_target.refresh_bars()
			_sfx("potion", -8.0, 1.2)
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
				target = await _pick_target(fallen)
			if target == null:
				_refund_item(item_id)
				return
			target.revive(0.5)
			_sfx("potion", -5.0, 0.8)
			target.float_text("REVIVED", Color(0.5, 1.0, 0.6))
			if current_hero != null:
				target.next_time = current_hero.next_time + BASIC_DELAY * 100.0 / target.effective_speed()
			_message("%s returns to the fight!" % target.unit_name)
			_log("Item: Revive Potion — %s revived at 50%% HP" % target.unit_name, "#e0c060")
			_rebuild_turn_bar()
			await _wait(0.6)
		"defense":
			_sfx("potion", -6.0, 0.9)
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
	basic_btn.custom_minimum_size = Vector2(105, 40)
	basic_btn.tooltip_text = _ability_tooltip(u, basic)
	basic_btn.pressed.connect(_on_ability_button.bind(basic))
	basic_btn.mouse_entered.connect(_preview_delay.bind(u, basic))
	basic_btn.mouse_exited.connect(_clear_delay_preview)
	action_box.add_child(basic_btn)
	# Everything else lives in the Abilities dropdown. Built from real Buttons
	# (not a PopupMenu) so hovering each entry previews its initiative cost —
	# PopupMenu only reports focus from keyboard navigation, not the mouse.
	var menu_btn := Button.new()
	menu_btn.text = "Abilities ▾"
	menu_btn.custom_minimum_size = Vector2(112, 40)
	var popup := PopupPanel.new()
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 4)
	popup.add_child(list)
	var summons: Array = []
	for i in range(1, u.abilities.size()):
		var ab: Ability = u.abilities[i]
		# The Beastmaster's summons collapse into one submenu entry.
		if ab.special == "summon":
			summons.append(ab)
			continue
		list.add_child(_ability_popup_button(u, ab, popup))
	if not summons.is_empty():
		var sub := PopupPanel.new()
		var sub_list := VBoxContainer.new()
		sub_list.add_theme_constant_override("separation", 4)
		sub.add_child(sub_list)
		for ab in summons:
			var s_btn := _ability_popup_button(u, ab, popup)
			s_btn.pressed.connect(sub.hide)
			sub_list.add_child(s_btn)
		var summon_btn := Button.new()
		summon_btn.text = "Summon Companion ▸"
		summon_btn.custom_minimum_size = Vector2(230, 38)
		summon_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		summon_btn.tooltip_text = "Choose which beast answers the call.\nOnly one companion at a time."
		summon_btn.add_child(sub)
		summon_btn.pressed.connect(_open_summon_popup.bind(sub, popup))
		list.add_child(summon_btn)
	popup.popup_hide.connect(_clear_delay_preview)
	menu_btn.add_child(popup)
	menu_btn.pressed.connect(_open_ability_popup.bind(popup, menu_btn))
	action_box.add_child(menu_btn)
	action_box.add_child(_build_items_menu())
	action_panel.visible = true


# One entry in the abilities popup: label with cost, tooltip, hover preview.
func _ability_popup_button(u: BattleUnit, ab: Ability, popup: PopupPanel) -> Button:
	var label: String = ab.display_name
	if ab.cost > 0:
		label += "   %d %s" % [ab.cost, u.resource_name]
	elif ab.faith_cost > 0:
		label += "   %d %s" % [ab.faith_cost, u.second_resource_name]
	var ab_btn := Button.new()
	ab_btn.text = label
	ab_btn.custom_minimum_size = Vector2(230, 38)
	ab_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	ab_btn.tooltip_text = _ability_tooltip(u, ab)
	var unusable: bool = ab.cost > u.resource or ab.faith_cost > u.second_resource
	if ab.special == "kill_command" and (u.companion == null or u.companion.dead):
		unusable = true
		ab_btn.tooltip_text += "\n(No living companion)"
	if ab.display_name == "Death Ray" and u.second_resource < 5:
		unusable = true
		ab_btn.tooltip_text += "\n(Requires 5 Arcane Resonance)"
	ab_btn.disabled = unusable
	ab_btn.pressed.connect(_on_popup_ability.bind(popup, ab))
	ab_btn.mouse_entered.connect(_preview_delay.bind(u, ab))
	ab_btn.mouse_exited.connect(_clear_delay_preview)
	return ab_btn


# Opens the ability list just above its anchor button.
func _open_ability_popup(popup: PopupPanel, anchor: Button) -> void:
	popup.popup()
	popup.position = Vector2i(int(anchor.global_position.x),
		int(anchor.global_position.y) - popup.size.y - 6)


# Opens the summon submenu beside the main abilities popup.
func _open_summon_popup(sub: PopupPanel, parent: PopupPanel) -> void:
	sub.popup()
	sub.position = Vector2i(parent.position.x + parent.size.x + 4,
		parent.position.y)


var _preview_locked := false
var second_target: BattleUnit = null  # choose_two abilities (Shrapnel)


func _preview_delay(u: BattleUnit, ab: Ability) -> void:
	if not _preview_locked:
		_rebuild_turn_bar(u, ab)


func _clear_delay_preview() -> void:
	if not _preview_locked:
		_rebuild_turn_bar()


func _on_ability_button(ab: Ability) -> void:
	_sfx("click", -12.0)
	_ability_picked.emit(ab)


func _on_popup_ability(popup: PopupPanel, ab: Ability) -> void:
	popup.hide()
	_on_ability_button(ab)


# Tooltip with live damage ranges (includes the unit's current buffs).
func _ability_tooltip(u: BattleUnit, ab: Ability) -> String:
	var tip := ab.description
	if ab.damage > 0:
		var buff_mult := 1.0
		if u.second_resource_name == "Resonance" and ab.display_name != "Death Ray":
			buff_mult *= 1.0 + 0.15 * u.second_resource
		if u.has_status("surge"):
			buff_mult *= 1.2
		if u.has_status("empower"):
			buff_mult *= 1.25
		tip += "\nDamage: %d–%d (%s)    BD: %d" % [
			int(ab.damage * 0.9 * buff_mult), int(round(ab.damage * 1.1 * buff_mult)),
			ab.dmg_type.capitalize(), ab.pressure]
		if ab.random_hits > 0 or ab.multi_hits > 0:
			tip += "   × %d hits" % maxi(ab.random_hits, ab.multi_hits)
	if ab.heal > 0:
		tip += "\nHeals: %d" % ab.heal
	tip += "\nInitiative cost: %.1f" % ab.delay
	if ab.perfect_text != "":
		tip += "\nPerfect: %s" % ab.perfect_text
	return tip


# Dropdown menu for the shared party inventory (one item per character per turn).
func _build_items_menu() -> MenuButton:
	var menu := MenuButton.new()
	menu.text = "Items ▾"
	menu.custom_minimum_size = Vector2(84, 40)
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
	if debug_enemies_off:
		u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
		_log("DEBUG: %s skips its turn (enemy attacks off)" % u.unit_name, "#e0a050")
		await _wait(0.25)
		return
	await _wait(0.7)
	# Mind Flay: the maddened enemy turns on its own allies with bonus Break
	# damage (falls through to normal behavior if it stands alone).
	if u.has_status("mindflay"):
		var fellows := enemies.filter(func(e): return not e.dead and e != u)
		if not fellows.is_empty():
			var mf_target: BattleUnit = fellows.pick_random()
			# Maddened units ATTACK their allies — support abilities stay sheathed.
			var mf_options: Array = u.abilities.filter(
				func(a): return a.cost <= u.resource and a.damage > 0)
			_message("%s turns on its allies!" % u.unit_name)
			_log("%s is maddened — attacks %s!" % [u.unit_name, mf_target.unit_name], "#c070e0")
			await _wait(0.4)
			await _resolve(u, mf_options.pick_random(), mf_target, "good")
			return
	var living := _hero_side()
	if living.is_empty():
		return
	var is_mocked := false
	if u.has_status("mocked"):
		var mocker_idx := u.status_power("mocked")
		if mocker_idx >= 0 and mocker_idx < heroes.size() and not heroes[mocker_idx].dead:
			living = [heroes[mocker_idx]]
			is_mocked = true
	# Support behaviors (Shielding, Wild Growth) — a taunt forces attacking instead.
	if not is_mocked:
		var support := _enemy_support_action(u)
		if not support.is_empty():
			await _resolve(u, support[0], support[1], "good")
			return
	var target: BattleUnit
	var ab: Ability
	# Only damaging abilities count as attacks; support casts are chosen above.
	var affordable: Array = u.abilities.filter(
		func(a): return a.cost <= u.resource and a.damage > 0)
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
		target = _lowest_hp(living) if randf() < 0.40 else living.pick_random()
		ab = affordable.pick_random()
	await _resolve(u, ab, target, "good")


# Non-attack decisions for enemies with support abilities. Returns
# [ability, ally_target], or [] to fall through to a normal attack.
func _enemy_support_action(u: BattleUnit) -> Array:
	var allies: Array = enemies.filter(func(e): return not e.dead)
	# Shieldmaster: always keeps exactly one ally Shielded (lowest HP first).
	var shield_ab := _find_ability(u, "Shielding")
	if shield_ab != null and not allies.any(func(a): return a.has_status("shielded")):
		return [shield_ab, _lowest_hp(allies)]
	# Withered Warden: tends the most wounded of its warband (itself included).
	var growth := _find_ability(u, "Wild Growth")
	if growth != null:
		var wounded: Array = allies.filter(func(a): return a.hp < a.max_hp * 0.7)
		if not wounded.is_empty() and randf() < 0.6:
			return [growth, _lowest_hp(wounded)]
	return []


func _lowest_hp(pool: Array) -> BattleUnit:
	var best: BattleUnit = pool[0]
	for h in pool:
		if h.hp / float(h.max_hp) < best.hp / float(best.max_hp):
			best = h
	return best


# Base chances for the attack rolls. Many things will modify these later.
const MISS_CHANCE := 0.05
const PARRY_CHANCE := 0.05        # hero baseline
const ENEMY_PARRY_CHANCE := 0.025 # enemy baseline (half the hero rate)
const CRIT_CHANCE := 0.10


func _miss_chance(attacker: BattleUnit) -> float:
	return MISS_CHANCE + (0.20 if attacker.has_status("dazed") else 0.0)


func _parry_chance(defender: BattleUnit) -> float:
	var base := PARRY_CHANCE if defender.is_hero else ENEMY_PARRY_CHANCE
	return base + defender.parry_bonus \
		+ (0.15 if defender.has_status("parry_up") else 0.0)


# Bow users get dedicated attack/impact/blocked sounds.
func _uses_bow(u: BattleUnit) -> bool:
	return u.unit_name.begins_with("Hunter") or u.unit_name.begins_with("Orc Archer")


# Per-ability impact sounds; falls back to bow/generic hits.
func _impact_sfx(attacker: BattleUnit, ab: Ability) -> String:
	if ab.display_name == "Hack and Slash":
		return "hack_slash"
	if ab.display_name == "Wildstrikes":
		return "wildstrikes"
	if ab.display_name == "Strike" and attacker.is_hero:
		return "strike"
	if _uses_bow(attacker):
		return "bow_impact"
	return "hit"


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
	if _uses_bow(attacker) and ab.damage > 0:
		_sfx("bow_attack", -8.0)
	await _wait(0.3)
	if attacker.is_hero:
		_stat("hero_actions")
		_stat("use_" + ab.display_name)

	if ab.faith_cost > 0:
		attacker.second_resource = maxi(attacker.second_resource - ab.faith_cost, 0)
	# Faith builds from every Cleric action.
	if attacker.second_resource_name == "Faith":
		attacker.second_resource = mini(attacker.second_resource + 10, attacker.second_max)
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
	elif not is_counter and not ab.aoe and ab.multi_hits == 0 and ab.random_hits == 0 \
			and not ab.choose_two and randf() < _miss_chance(attacker):
		_stat("attacks")
		_stat("attack_miss")
		_sfx("miss")
		target.float_text("MISS", Color(0.75, 0.75, 0.75))
		_message("%s misses!" % attacker.unit_name)
		_log("%s: %s on %s — MISS" % [attacker.unit_name, ab.display_name,
			target.unit_name], "#909090")
		await _wait(0.35)
	elif not is_counter and not ab.aoe and ab.multi_hits == 0 and ab.random_hits == 0 \
			and not ab.choose_two \
			and not target.broken and not target.dead and not target.is_companion \
			and randf() < _parry_chance(target):
		# Parry negates the hit; the defender immediately counters with
		# their basic attack (a free action — no rolls, no initiative cost).
		_stat("attacks")
		_stat("attack_parry")
		_sfx("bow_blocked" if _uses_bow(attacker) else "parry", -4.0)
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
			strike_targets = enemies.filter(func(t): return not t.dead) \
				if attacker.is_hero else _hero_side()
		elif ab.choose_two:
			var second: BattleUnit = second_target
			if second == null or second.dead or second == target:
				# Autoplay (or a lone survivor): fall back to another live foe.
				var others := enemies.filter(func(e): return not e.dead and e != target)
				second = null if others.is_empty() else others.pick_random()
			if second != null:
				strike_targets = [target, second]
		var total_hits := strike_targets.size()
		if ab.random_hits > 0:
			total_hits = ab.random_hits + (1 if is_perfect and ab.perfect_extra_hit else 0)
		elif ab.multi_hits > 0:
			total_hits = ab.multi_hits + (1 if is_perfect and ab.perfect_extra_hit else 0)
		var total_dealt := 0
		var any_crit := false
		for hit_i in total_hits:
			var strike_target: BattleUnit
			if ab.random_hits > 0:
				# Each shard picks a fresh living target at launch time.
				var live_pool: Array = enemies.filter(func(t): return not t.dead) \
					if attacker.is_hero else _hero_side()
				if live_pool.is_empty():
					break
				strike_target = live_pool.pick_random()
			elif ab.multi_hits > 0:
				# Repeated strikes on the chosen target; stop if it falls.
				strike_target = target
				if strike_target.dead:
					break
			else:
				strike_target = strike_targets[hit_i]
				if strike_target.dead:
					continue
			# Multi-hit attacks roll miss/parry per strike: a blocked or missed
			# hit never stops the follow-up strikes.
			if not is_counter and (ab.multi_hits > 0 or ab.random_hits > 0 or ab.choose_two):
				if randf() < _miss_chance(attacker):
					_stat("attacks")
					_stat("attack_miss")
					_sfx("miss")
					strike_target.float_text("MISS", Color(0.75, 0.75, 0.75))
					_log("%s: %s on %s — MISS" % [attacker.unit_name, ab.display_name,
						strike_target.unit_name], "#909090")
					await _wait(0.45)
					continue
				if not strike_target.broken and not strike_target.is_companion \
						and randf() < _parry_chance(strike_target):
					_stat("attacks")
					_stat("attack_parry")
					_sfx("bow_blocked" if _uses_bow(attacker) else "parry", -4.0)
					strike_target.float_text("PARRY", Color(0.4, 0.9, 1.0))
					_log("%s parries %s — counter attack!" % [strike_target.unit_name,
						attacker.unit_name], "#50c8e0")
					await _wait(0.5)
					await _resolve(strike_target, strike_target.abilities[0], attacker,
						"good", true)
					if attacker.dead:
						break
					continue
			var crit_chance := CRIT_CHANCE + (0.25 if strike_target.broken else 0.0)
			# Resonant Mind: +3% crit per Resonance stack.
			if attacker.second_resource_name == "Resonance":
				crit_chance += 0.03 * attacker.second_resource
			crit_chance += attacker.crit_bonus
			# Pack Bond (Aguila): the eagle sharpens the hunter's eye.
			if attacker.passive_id == "pack" and attacker.companion != null \
					and not attacker.companion.dead \
					and attacker.companion.companion_kind == "aguila":
				crit_chance += 0.15
			if is_perfect and ab.display_name == "Frost Bolt":
				crit_chance += 0.05
			if is_perfect and ab.display_name == "Aimed Shot":
				crit_chance += 0.25
			var is_crit := randf() < crit_chance
			# Razor Ice always crits against Slowed (chilled) targets.
			if ab.display_name == "Razor Ice" and strike_target.has_status("chilled"):
				is_crit = true
			any_crit = any_crit or is_crit
			var raw := ab.damage * randf_range(0.9, 1.1) * dmg_mult
			if is_crit:
				raw *= 2.0 if attacker.passive_id == "lethal_aim" else 1.5
			# Attacker-side modifiers.
			if attacker.second_resource_name == "Resonance" \
					and ab.display_name != "Death Ray":
				raw *= 1.0 + 0.15 * attacker.second_resource
			if attacker.has_status("surge"):
				raw *= 1.2
			# Arcane Cannon: the damage (not the recoil) grows with Resonance.
			if ab.display_name == "Arcane Cannon":
				raw *= 1.0 + 0.075 * attacker.second_resource
			# Flame Surge perfect: burns feed the fire.
			if is_perfect and ab.display_name == "Flame Surge" \
					and strike_target.has_status("burn"):
				raw += 15.0
			# Frost Bolt: 50% chance to deal DOUBLE damage to unchilled targets.
			if ab.display_name == "Frost Bolt" and not strike_target.has_status("chilled") \
					and randf() < 0.5:
				raw *= 2.0
				strike_target.float_text("SHATTER x2", Color(0.5, 0.85, 1.0))
			if is_perfect and ab.display_name == "Explosive Shot":
				raw = 12.0 * randf_range(0.9, 1.1)
			# Powershot: +2% damage per 1% of the target's Break bar still EMPTY —
			# the Rush opener, strongest against untouched foes.
			if ab.display_name == "Powershot":
				raw *= 1.0 + 2.0 * (1.0 - clampf(
					strike_target.pressure / float(strike_target.stability), 0.0, 1.0))
			# Overpower: exploits instability — +0.5 damage per point of Break.
			if ab.display_name == "Overpower":
				raw += 0.5 * strike_target.pressure
			if ab.display_name == "Pyroblast" and strike_target.has_status("burn"):
				raw *= 1.25
			if attacker.has_status("empower"):
				raw *= 1.25
			if attacker.has_status("cripple"):
				raw *= 0.75
			if attacker.passive_id == "bloodrage":
				raw *= 1.0 + (0.4 + attacker.bloodrage_bonus) \
					* (1.0 - attacker.hp / float(attacker.max_hp))
			if attacker.enraged_stacks > 0:
				raw *= 1.0 + attacker.enraged_stacks / 100.0
			# Rampage: fury drawn from every open wound on the enemy party.
			if attacker.has_status("rampage"):
				raw *= 1.0 + attacker.status_power("rampage") / 100.0
			# Seasoned Fighter: the offensive stance above half HP.
			if attacker.passive_id == "seasoned" and attacker.hp > attacker.max_hp * 0.5:
				raw *= 1.15
			raw *= 1.0 + attacker.dmg_bonus + float(attacker.type_dmg_bonus.get(ab.dmg_type, 0.0))
			# Target-side modifiers.
			if strike_target.second_resource_name == "Resonance":
				raw *= 1.0 + 0.10 * strike_target.second_resource
			if strike_target.has_status("shieldwall"):
				raw *= 0.75
			# Shielded: the Orc Shieldmaster's single-ally ward.
			if strike_target.has_status("shielded"):
				raw *= 0.75
			if strike_target.has_status("exposed"):
				raw *= 1.15
			if strike_target.dmg_taken_bonus > 0.0:
				raw *= 1.0 + strike_target.dmg_taken_bonus
			# Seasoned Fighter: the defensive stance at or below half HP.
			if strike_target.passive_id == "seasoned" \
					and strike_target.hp <= strike_target.max_hp * 0.5:
				raw *= 0.85
			if debug_prints and attacker.second_resource_name == "Resonance":
				print("[DBG] %s attacks @%d stacks: base %d -> raw %.1f" % [
					attacker.unit_name, attacker.second_resource, ab.damage, raw])
			var resist := float(strike_target.resists.get(ab.dmg_type, 0.0))
			if resist != 0.0:
				raw *= 1.0 - resist
			var effective_armor := strike_target.effective_armor() \
				* (1.0 - clampf(ab.armor_pierce + attacker.pierce_bonus, 0.0, 1.0))
			if is_perfect and ab.display_name == "Arcane Rift":
				effective_armor = 0.0
			var final := maxi(int(round(raw * (1.0 - effective_armor))), 1)
			var resonance_boosted: bool = attacker.second_resource_name == "Resonance" \
				and attacker.second_resource > 0
			var pr := int(round(ab.pressure * pr_mult * (1.5 if is_crit else 1.0)))
			if is_perfect and (ab.perfect_id == "pressure" or ab.aoe):
				pr = int(pr * 1.5)
			if is_perfect and ab.display_name == "Crushing Blow":
				pr += 5
			if is_perfect and ab.display_name == "Arcane Cannon":
				pr += 5
			# Pack Bond (Ursus): the bear's weight behind every hit.
			if attacker.passive_id == "pack" and attacker.companion != null \
					and not attacker.companion.dead \
					and attacker.companion.companion_kind == "ursus":
				pr = int(pr * 1.25)
			# Mind Flay: maddened attacks batter their own allies' stability.
			if attacker.has_status("mindflay"):
				pr = int(pr * (1.0 + attacker.status_power("mindflay") / 100.0))
			_stat("attacks")
			_stat("attack_landed")
			if is_crit:
				_stat("attack_crit")
			if attacker.is_hero:
				_stat("dmg_hero_" + attacker.unit_name, final)
			else:
				_stat("dmg_enemy", final)
			total_dealt += final
			# Unity: the bound party splits incoming damage evenly (Pressure
			# still lands on the struck hero alone).
			if strike_target.is_hero and not strike_target.is_companion \
					and strike_target.has_status("unity"):
				var bound := heroes.filter(func(h): return not h.dead)
				if bound.size() > 1:
					var share := maxi(int(round(final / float(bound.size()))), 1)
					_log("   → Unity splits %d damage: %d to each of %d souls" % [
						final, share, bound.size()], "#e0d060")
					for h in bound:
						if h == strike_target:
							continue
						var shared: Dictionary = h.take_hit(share, 0)
						h.float_text("-%d Unity" % share, Color(0.95, 0.85, 0.4))
						if shared.died:
							_stat("hero_deaths")
							_sfx("death", -4.0)
							_message("%s falls!" % h.unit_name)
							_log("† %s dies" % h.unit_name, "#e05050")
					final = share
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
				_sfx(_impact_sfx(attacker, ab))
				strike_target.float_text("%d" % final, Color(0.95, 0.85, 0.75))
			var resist_tag := ""
			if resist > 0.0:
				resist_tag = " (resisted)"
			elif resist < 0.0:
				resist_tag = " (vulnerable!)"
			_log("%s: %s on %s — %d %s dmg%s%s, +%d BD%s" % [attacker.unit_name,
				ab.display_name, strike_target.unit_name, final, ab.dmg_type,
				" CRIT" if is_crit else "", resist_tag, result.get("bd", pr), grade_tag],
				"#d8d2c4" if attacker.is_hero else "#e0a0a0")
			# VAULTED — Echo passive (kept for future return):
			# if attacker.passive_id == "echo" and not result.died and randf() < 0.20:
			#     echo_dmg = max(int(final * 0.25), 1); strike again + "ECHO!" fanfare.
			if ab.delay_push > 0.0:
				strike_target.next_time += ab.delay_push * 100.0 / strike_target.effective_speed()
			var status_chance := ab.status_chance
			# Pommel Strike: a crit rings harder — 75% stun instead of 50%.
			if ab.display_name == "Pommel Strike" and is_crit:
				status_chance = 0.75
			if not result.died and not ab.applies_status.is_empty() \
					and randf() <= status_chance:
				var turns: int = ab.applies_status["turns"]
				if is_perfect and ab.perfect_id == "status_plus":
					turns = 4
				var status_meta := 0
				if ab.applies_status["id"] == "burn":
					status_meta = int(round((CRIT_CHANCE + attacker.crit_bonus) * 100))
				_apply_status(strike_target, ab.applies_status["id"], turns, status_meta)
			if ab.bleed_build > 0 and not strike_target.dead and randf() <= ab.bleed_chance:
				_add_bleed_with_burst(strike_target, ab.bleed_build + attacker.bleed_bonus)
			if ab.display_name == "Mocking Blow" and not strike_target.dead:
				var mocker_idx := heroes.find(attacker)
				if mocker_idx >= 0:
					var taunt_turns := 5 if is_perfect else 4
					_apply_status(strike_target, "mocked", taunt_turns, mocker_idx)
					var others := enemies.filter(
						func(e): return not e.dead and e != strike_target)
					if not others.is_empty():
						_apply_status(others.pick_random(), "mocked", taunt_turns, mocker_idx)
			# Shrapnel: the second debuff (Cripple rides applies_status above).
			if ab.display_name == "Shrapnel" and not strike_target.dead:
				_apply_status(strike_target, "slow", 4 if is_perfect else 3)
			# Poisoned Arrow: layers several stacks at once.
			if ab.display_name == "Poisoned Arrow" and not strike_target.dead:
				for stack_i in (4 if is_perfect else 3):
					_apply_status(strike_target, "poison", 5)
			# Specialization on-hit passives.
			if not strike_target.dead:
				if attacker.passive_id == "ignite" and randf() < 0.5:
					_apply_status(strike_target, "burn", 3,
						int(round((CRIT_CHANCE + attacker.crit_bonus) * 100)))
				elif attacker.passive_id == "chill" and randf() < 0.5:
					_apply_status(strike_target, "chilled", 3)
				# Pack Bond (Canis): the wolf worries every wound open.
				if attacker.passive_id == "pack" and attacker.companion != null \
						and not attacker.companion.dead \
						and attacker.companion.companion_kind == "canis":
					_add_bleed_with_burst(strike_target, 15)
			# Trapper: striking the Survivalist risks a poisoned barb.
			if strike_target.passive_id == "trapper" and not attacker.is_hero \
					and not attacker.dead and randf() < 0.25:
				_apply_status(attacker, "poison", 5)
			if is_perfect and ab.display_name == "Pyroblast" and not strike_target.dead:
				_apply_status(strike_target, "burn", 3,
					int(round((CRIT_CHANCE + attacker.crit_bonus) * 100)))
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
			if (ab.random_hits > 0 or ab.multi_hits > 0) and total_hits > 1:
				await _wait(0.45)  # sequential strikes land distinctly
		# Post-strike attacker effects (skipped if a counter felled the attacker).
		if ab.recoil_base > 0.0 and not attacker.dead:
			var recoil_pct := ab.recoil_base
			var recoil := maxi(int(round(total_dealt * recoil_pct)), 1)
			# Unity binds recoil too: the backlash splits across the party.
			if attacker.has_status("unity"):
				var bound := heroes.filter(func(h): return not h.dead)
				if bound.size() > 1:
					recoil = maxi(int(round(recoil / float(bound.size()))), 1)
					for h in bound:
						if h == attacker:
							continue
						if h.take_tick_damage(recoil, "-%d Unity" % recoil,
								Color(0.95, 0.85, 0.4)):
							_stat("hero_deaths")
							_sfx("death", -4.0)
							_log("† %s dies" % h.unit_name, "#e05050")
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
		# The Beastmaster's companion strikes alongside the hunter.
		if attacker.is_hero and attacker.passive_id == "pack" and ab.damage > 0 \
				and not is_counter and attacker.companion != null \
				and not attacker.companion.dead:
			var comp_target: BattleUnit = target
			if comp_target == null or comp_target.is_hero or comp_target.dead:
				var foes := enemies.filter(func(e): return not e.dead)
				comp_target = null if foes.is_empty() else _lowest_hp(foes)
			if comp_target != null:
				await _companion_strike(attacker.companion, comp_target, 1.0, false)
		# Tripwire: rigged ground bites every attacking melee enemy.
		if not attacker.is_hero and not attacker.is_ranged and not is_counter \
				and total_dealt > 0:
			for trapper in heroes:
				if trapper.dead or not trapper.has_status("tripwire") or attacker.dead:
					continue
				var ret := maxi(int(total_dealt * 0.75), 1)
				var ret_result: Dictionary = attacker.take_hit(ret, 0)
				attacker.float_text("%d Tripwire" % ret, Color(0.8, 0.65, 0.35))
				_log("   → %s's tripwire rips %s for %d" % [trapper.unit_name,
					attacker.unit_name, ret], "#50c8e0")
				if ret_result.died:
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
		# Corrupted Channeling: a Crippled enemy's violence feeds the party.
		if not attacker.is_hero and attacker.has_status("cripple") and total_dealt > 0 \
				and heroes.any(func(h): return not h.dead and h.passive_id == "corrupt"):
			var blessed: BattleUnit = heroes.filter(func(h): return not h.dead).pick_random()
			var leech_heal := maxi(int(total_dealt / 2.0), 1)
			blessed.heal_amount(leech_heal)
			blessed.float_text("+%d" % leech_heal, Color(0.7, 0.4, 0.9))
			_log("   → Corrupted Channeling: %s heals %d" % [blessed.unit_name,
				leech_heal], "#b0a8e0")
		# Death Ray: the payoff — every Resonance stack is consumed.
		if ab.display_name == "Death Ray" and attacker.second_resource_name == "Resonance" \
				and attacker.second_resource > 0:
			attacker.second_resource = 0
			attacker.refresh_bars()
			attacker.float_text("Resonance consumed", Color(0.6, 0.45, 0.75))
			_log("   → %s consumes every Resonance stack" % attacker.unit_name, "#b0a8e0")
		# Resonance builds only on the Mage's own casts — parry counters don't
		# count (they made the Mage "start" battles with a stack).
		if not is_counter:
			_gain_resonance(attacker, 2 if any_crit else 1)
	if not sim and attacker.position != lunge_origin:
		var back := create_tween()
		back.tween_property(attacker, "position", lunge_origin, 0.18) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await _wait(0.45)
	attacker.return_to_idle()
	if not is_counter:
		var eff_delay := ab.delay
		if grade == "perfect" and ab.display_name == "Mana Shield":
			eff_delay = 1.5
		attacker.next_time += eff_delay * 100.0 / attacker.effective_speed()


func _apply_status(target: BattleUnit, id: String, turns: int, power := 0) -> void:
	# Bosses shrug off Stuns until their guard is Broken.
	if id == "stunned" and target.is_boss and not target.broken:
		target.float_text("IMMUNE", Color(0.75, 0.75, 0.75))
		_log("   → %s resists the Stun (boss — Break them first)" % target.unit_name,
			"#909090")
		return
	var info: Array = STATUS_INFO[id]
	target.add_status(id, info[0], info[1], info[2], turns, info[3], power)
	if id == "poison":
		var stacks := target.status_stacks("poison")
		_log("   → Poison on %s (x%d — %d nature dmg/turn, %d turns)" % [target.unit_name,
			stacks, 3 * stacks, turns], "#8cc843")
		return
	var span := "battle" if turns < 0 else "%d turns" % turns
	_log("   → %s on %s (%s)" % [info[0], target.unit_name, span], "#b0a8e0")


# Arcane Resonance: builds on damaging casts (2 on crit via Arcane Instability);
# hitting max stacks triggers Backlash Ward (+15 Mana). Stacks persist for the
# whole battle.
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
			var pressure_cut := 50 if is_perfect else int(30 * mult)
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
		"shieldwall":
			_sfx("parry", -7.0, 0.5)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "shieldwall", 3 if is_perfect else 2)
			_message("%s raises the shieldwall!" % attacker.unit_name)
			_log("%s: Shieldwall — party takes half damage" % attacker.unit_name, "#70d878")
		"quickdraw":
			_sfx("click", -6.0, 1.3)
			_apply_status(attacker, "quickdraw", 6 if is_perfect else 5)
			_message("%s's hands blur!" % attacker.unit_name)
			_log("%s: Quick Draw — +50%% ability speed" % attacker.unit_name, "#70d878")
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
		"unity":
			_sfx("heal", -5.0, 0.7)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "unity", 4 if is_perfect else 3)
			_message("MIRACLE — Unity!")
			_log("%s: Unity — the party's souls are bound" % attacker.unit_name, "#70d878")
		"mindflay":
			_sfx("break", -8.0, 1.4)
			_apply_status(target, "mindflay", 3, 115 if is_perfect else 100)
			_message("%s shatters %s's mind!" % [attacker.unit_name, target.unit_name])
			_log("%s: Mind Flay — %s turns on its allies" % [attacker.unit_name,
				target.unit_name], "#c070e0")
		"rampage":
			var total_bleed := 0
			for e in enemies:
				if not e.dead:
					total_bleed += e.bleed_buildup
			var pct := total_bleed / 10 + (10 if is_perfect else 0)
			_sfx("crit", -8.0, 0.7)
			_apply_status(attacker, "rampage", 2, pct)
			_message("%s scents the blood!" % attacker.unit_name)
			_log("%s: Rampage — +%d%% damage from the enemy party's wounds" % [
				attacker.unit_name, pct], "#70d878")
		"mana_shield":
			_sfx("parry", -8.0, 1.2)
			_apply_status(attacker, "mana_shield", 3)
			_message("%s weaves a shield of mana" % attacker.unit_name)
			_log("%s: Mana Shield — damage feeds Mana" % attacker.unit_name, "#70d878")
		"tripwire":
			_sfx("click", -8.0, 0.8)
			_apply_status(attacker, "tripwire", 6 if is_perfect else 5)
			_message("%s rigs the ground" % attacker.unit_name)
			_log("%s: Tripwire set" % attacker.unit_name, "#70d878")
		"summon":
			await _do_summon(attacker, ab.display_name.get_slice(" ", 1).to_lower())
		"kill_command":
			var comp: BattleUnit = attacker.companion
			if comp != null and not comp.dead and target != null and not target.dead:
				_message("%s: KILL COMMAND!" % attacker.unit_name)
				_log("%s orders %s to savage %s!" % [attacker.unit_name,
					comp.unit_name, target.unit_name], "#e0a050")
				await _companion_strike(comp, target, 3.0 if is_perfect else 2.0, true)
		"enemy_shield":
			# The Shieldmaster's ward: one ally holds it at a time.
			for a in (enemies if not attacker.is_hero else heroes):
				if a != target and a.has_status("shielded"):
					a.remove_status("shielded")
			_sfx("parry", -7.0, 0.6)
			_apply_status(target, "shielded", 3)
			_message("%s shields %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Shielding — %s takes 25%% less damage (3 turns)" % [
				attacker.unit_name, target.unit_name], "#e0a0a0")
		"wild_growth":
			var growth := maxi(int(round(target.max_hp * 0.20)), 1)
			_sfx("heal", -6.0, 0.8)
			target.heal_amount(growth)
			target.float_text("+%d" % growth, Color(0.4, 0.9, 0.45))
			_message("%s mends %s" % [attacker.unit_name, target.unit_name])
			_log("%s: Wild Growth heals %s for %d (20%% max HP)" % [attacker.unit_name,
				target.unit_name, growth], "#70d878")
		"renewal":
			_sfx("heal", -9.0, 1.1)
			_apply_status(target, "renewal", 5)
			if is_perfect:
				target.heal_amount(8)
				target.float_text("+8", Color(0.4, 0.9, 0.45))
			_message("%s blesses %s with Renewal" % [attacker.unit_name, target.unit_name])
			_log("%s: Renewal on %s — 8 HP/turn for 5 turns" % [attacker.unit_name,
				target.unit_name], "#70d878")


# ---------- Beastmaster companions ----------

# kind -> [max HP, sphere tint] (placeholder spheres until beast art exists).
const COMPANION_STATS := {
	"ursus": [80, Color(0.9, 0.3, 0.25)],
	"canis": [60, Color(0.35, 0.55, 0.95)],
	"aguila": [60, Color(0.35, 0.85, 0.4)],
}


# Summons (or replaces) the hunter's companion. It inherits the hunter's
# armor, stability, and crit chance; it has no resource and takes no turns.
func _do_summon(hunter: BattleUnit, kind: String) -> void:
	if hunter.companion != null and is_instance_valid(hunter.companion):
		companions.erase(hunter.companion)
		hunter.companion.queue_free()
		hunter.companion = null
	var stats: Array = COMPANION_STATS[kind]
	var cfg := {"unit_name": kind.capitalize(), "is_hero": true, "sheet_dir": "sphere",
		"sprite_scale": 1.4, "max_hp": stats[0] + hunter.companion_hp_bonus,
		"armor": hunter.armor, "speed": hunter.speed, "stability": hunter.stability,
		"constitution": hunter.constitution, "abilities": []}
	var comp := _make_unit(cfg, hunter.position + Vector2(110, -16), stats[1])
	comp.is_companion = true
	comp.companion_kind = kind
	comp.crit_bonus = hunter.crit_bonus
	comp.companion_power = hunter.companion_power
	comp.next_time = INF  # never drawn a turn from the timeline
	companions.append(comp)
	hunter.companion = comp
	_sfx("heal", -7.0, 0.6)
	_message("%s answers the call!" % comp.unit_name)
	_log("%s summons %s" % [hunter.unit_name, comp.unit_name], "#70d878")
	await _wait(0.5)


# One companion attack. `mult` scales damage (Kill Command: x2, x3 on Perfect);
# `boosted` doubles the special effect (guaranteed procs, doubled Bleed).
func _companion_strike(comp: BattleUnit, victim: BattleUnit, mult: float,
		boosted: bool) -> void:
	if comp == null or comp.dead or victim == null or victim.dead:
		return
	var proc_chance := 1.0 if boosted else 0.5
	match comp.companion_kind:
		"ursus":
			await _companion_hit(comp, victim, 10.0 * mult, int(20 * mult))
			# The bear's sweep also mauls the enemy beside the target.
			var others := enemies.filter(func(e): return not e.dead and e != victim)
			if not others.is_empty():
				await _companion_hit(comp, others.pick_random(), 10.0 * mult, int(20 * mult))
		"canis":
			await _companion_hit(comp, victim, 20.0 * mult, 0)
			if not victim.dead and randf() < proc_chance:
				_add_bleed_with_burst(victim, 40 if boosted else 20)
		"aguila":
			await _companion_hit(comp, victim, 15.0 * mult, 0)
			if not victim.dead and randf() < proc_chance:
				_apply_status(victim, "sunder", 4 if boosted else 2)


# All beasts deal physical damage using the hunter's inherited crit chance.
func _companion_hit(comp: BattleUnit, victim: BattleUnit, dmg: float, pr: int) -> void:
	if victim == null or victim.dead:
		return
	var raw := (dmg + comp.companion_power) * randf_range(0.9, 1.1)
	var is_crit := randf() < CRIT_CHANCE + comp.crit_bonus + (0.25 if victim.broken else 0.0)
	if is_crit:
		raw *= 1.5
	raw *= 1.0 - float(victim.resists.get("physical", 0.0))
	var final := maxi(int(round(raw * (1.0 - victim.effective_armor()))), 1)
	var result: Dictionary = victim.take_hit(final, pr)
	_sfx("crit" if is_crit else "hit", -4.0 if is_crit else -7.0, 1.1)
	victim.float_text("%d%s" % [final, "!" if is_crit else ""],
		Color(1.0, 0.45, 0.15) if is_crit else Color(0.9, 0.75, 0.55), is_crit)
	if not sim and not result.died:
		victim.hit_react((victim.position - comp.position).normalized())
	_log("%s: strikes %s for %d%s" % [comp.unit_name, victim.unit_name, final,
		" CRIT" if is_crit else ""], "#d8b880")
	if result.broke:
		_stat("breaks_on_enemies" if not victim.is_hero else "breaks_on_heroes")
		_sfx("break", -3.0)
		_message("%s BREAKS!" % victim.unit_name)
		_log("!! %s BREAKS" % victim.unit_name, "#c070e0")
		await _break_impact()
		_shake()
	if result.died:
		_stat("hero_deaths" if victim.is_hero else "enemy_deaths")
		_sfx("death", -4.0)
		_message("%s falls!" % victim.unit_name)
		_log("† %s dies" % victim.unit_name, "#e05050")
	await _wait(0.35)
	# No _check_end here: the battle loop checks after the turn fully resolves
	# (ending mid-resolve reloads the scene under running code in sim mode).


# Adds bleed buildup (logged) and detonates the bleedout when the meter fills.
# Bleedout damage IGNORES armor (take_hit applies none — armor only reduces
# attack damage inside _resolve) and respects Unity's soul-binding.
func _add_bleed_with_burst(victim: BattleUnit, amount: int) -> void:
	if victim.dead:
		return
	if victim.add_bleed(amount):
		var bleed_dmg := maxi(int(victim.max_hp * 0.20), 1)
		if victim.is_hero and not victim.is_companion and victim.has_status("unity"):
			var bound := heroes.filter(func(h): return not h.dead)
			if bound.size() > 1:
				bleed_dmg = maxi(int(round(bleed_dmg / float(bound.size()))), 1)
				_log("   → Unity splits the bleedout: %d to each of %d souls" % [
					bleed_dmg, bound.size()], "#e0d060")
				for h in bound:
					if h == victim:
						continue
					if h.take_hit(bleed_dmg, 0).died:
						_stat("hero_deaths")
						_sfx("death", -4.0)
						_log("† %s dies" % h.unit_name, "#e05050")
		var bleed_result: Dictionary = victim.take_hit(bleed_dmg, 0)
		victim.float_text("BLEEDOUT %d" % bleed_dmg, Color(0.9, 0.15, 0.2), true)
		if not victim.is_hero:
			for feaster in heroes:
				if not feaster.dead and feaster.bloodcraze > 0:
					feaster.heal_amount(30)
					feaster.float_text("+30 Bloodcraze", Color(0.85, 0.3, 0.3))
					_log("   → Bloodcraze: %s feasts (+30 HP)" % feaster.unit_name, "#b0a8e0")
		_sfx("crit", -5.0, 0.8)
		_log("   → %s BLEEDS OUT for %d" % [victim.unit_name, bleed_dmg], "#e05050")
		if bleed_result.died:
			_stat("hero_deaths" if victim.is_hero else "enemy_deaths")
			_sfx("death", -4.0)
			_message("%s falls!" % victim.unit_name)
			_log("† %s dies" % victim.unit_name, "#e05050")
	else:
		_log("   → %s: +%d Bleed (%d/100)" % [victim.unit_name, amount,
			victim.bleed_buildup], "#e08850")


# Unique bonus effects for Perfect skill checks (per ability).
func _apply_perfect_bonus(attacker: BattleUnit, target: BattleUnit, ab: Ability, target_died: bool) -> void:
	match ab.perfect_id:
		"rage":
			attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+10 Rage", Color(1.0, 0.5, 0.4))
			_log("   → %s gains +10 Rage" % attacker.unit_name, "#b0a8e0")
		"mana15":
			attacker.resource = mini(attacker.resource + 15, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+15 Mana", Color(0.5, 0.7, 1.0))
			_log("   → %s restores 15 Mana" % attacker.unit_name, "#b0a8e0")
		"rage5":
			attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+5 Rage", Color(1.0, 0.5, 0.4))
			_log("   → %s gains +5 Rage" % attacker.unit_name, "#b0a8e0")
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
		"parry_up":
			_apply_status(attacker, "parry_up", 3)


# ---------- skill check ----------

func _run_skill_check(cancellable := false) -> String:
	sc_pos = 0.0
	sc_dir = 1.0
	sc_result.text = ""
	sc_root.visible = true
	sc_active = true
	sc_cancel = null
	if cancellable:
		sc_cancel = Button.new()
		sc_cancel.text = "✕ Cancel"
		sc_cancel.custom_minimum_size = Vector2(104, 34)
		sc_cancel.position = Vector2(448, 20)
		sc_cancel.pressed.connect(_cancel_skill_check)
		sc_root.add_child(sc_cancel)
	var grade: String = await _skill_done
	if sc_cancel != null:
		sc_cancel.queue_free()
		sc_cancel = null
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


# Left clicks are handled in _input because UI panels (the check bar itself,
# the log, portraits) would otherwise swallow them before _unhandled_input.
func _input(event: InputEvent) -> void:
	if not sc_active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		# Clicking the Cancel button must cancel, not grade the check.
		if sc_cancel != null and sc_cancel.get_global_rect().has_point(event.position):
			return
		_grade_skill_check()


func _unhandled_input(event: InputEvent) -> void:
	if sc_active and event.is_action_pressed("ui_accept"):
		_grade_skill_check()


func _grade_skill_check() -> void:
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
			# Keep the saved max in sync with talents/runes so full heals
			# (rest, zone transitions) reach the hero's true maximum.
			Run.party[i]["max_hp"] = heroes[i].max_hp
			if heroes[i].resource_name == "Mana":
				Run.party[i]["mana"] = heroes[i].resource
		var pts := Run.award_talent_points(Run.encounter.get("type", "fight"))
		var gold_gain := Run.award_gold(Run.encounter.get("type", "fight"))
		# Elite spoils: a rune for a random hero + a consumable on top of the
		# bigger gold purse — the snowball reward for hunting elites.
		var elite_text := ""
		if Run.encounter.get("type", "") == "elite":
			var looter: Dictionary = Run.party.pick_random()
			var rune: Dictionary = Run.generate_rune(looter["key"])
			looter["runes"] = looter.get("runes", []) + [rune]
			var drop_id: String = Run.random_loot()
			Run.items[drop_id] = Run.items.get(drop_id, 0) + 1
			elite_text = "\n\nELITE SPOILS\n%s (%s) — for the %s, equip it from the Party tab\n+1 %s" % [
				rune["name"], rune["desc"], looter["key"].capitalize(),
				Run.ITEM_INFO[drop_id][0]]
		if Run.relic_active("chalice"):
			Run.heal_party(0.10)
		Run.save_run()
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
				Run.clear_save()
				_show_end("THE DECAY RECEDES", boss_text + "\nRun complete!",
					[["New Run", _start_new_run]])
		else:
			_show_end("VICTORY", "+%d gold. Each hero gains %d talent point%s.%s" % [
				gold_gain, pts, "" if pts == 1 else "s", elite_text],
				[["Continue", _to_map]])
	else:
		Run.active = false
		Run.clear_save()
		_sfx("defeat", -4.0)
		_show_end("THE PARTY HAS FALLEN", "The Decay claims this cycle.",
			[["New Run", _start_new_run]])


func _next_zone() -> void:
	Run.advance_zone()
	Run.save_run()
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
	punch.tween_property(cam, "zoom", Vector2(1.06, 1.06), 0.08) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	punch.tween_property(cam, "zoom", Vector2(1.0, 1.0), 0.25)
