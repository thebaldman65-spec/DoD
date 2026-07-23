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

# Ability hotkeys, mapped to ability slots in kit order (shown on the buttons).
const ABILITY_KEYS: Array = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_A, KEY_S, KEY_D, KEY_F]
const ABILITY_KEY_NAMES := ["Q", "W", "E", "R", "A", "S", "D", "F"]

# Visual identity of each status effect: [label, chip tag, color, tooltip]
const STATUS_INFO := {
	"slow": ["Slowed", "Sl", Color(0.55, 0.65, 0.9), "-25% speed; turns arrive later."],
	"chilled": ["Chilled", "Ch", Color(0.5, 0.75, 1.0), "Stacking frost: 1 = -25% speed,\n2 = -50%, 3 = also -15% damage;\n4 stacks FREEZE the victim."],
	"frozen": ["Frozen", "Fz", Color(0.65, 0.88, 1.0), "Frozen solid: loses their next turn."],
	"burn": ["Burn", "F", Color(1.0, 0.55, 0.2), "Burning: takes damage at the start of each\nturn (6% of the applier's Attack).\nReapplying Burn extends the duration."],
	"bleed": ["Bleed", "Bl", Color(0.85, 0.25, 0.25), "Bleed builds with wounding attacks;\nat 100 the target bleeds out for 20% max HP.\nBleed damage ignores armor."],
	"sunder": ["Sunder", "D", Color(0.7, 0.7, 0.7), "-35% armor."],
	"ward": ["Ward", "W", Color(1.0, 0.85, 0.4), "Takes 50% less Break damage."],
	"fortify": ["Fortify", "+D", Color(0.55, 0.8, 0.9), "+10% armor."],
	"barrier": ["Barrier", "Ba", Color(0.40, 0.85, 0.95), "Absorbs incoming damage."],
	"focus": ["Focus", "Fo", Color(0.35, 0.60, 1.0), "Restores 10 Mana each turn."],
	"renewal": ["Renewal", "R+", Color(0.45, 0.90, 0.50), "Restores HP at the start of each\nturn (15% of the caster's max\nhealth, set when cast)."],
	"surge": ["Surge", "A+", Color(0.80, 0.50, 1.0), "+20% attack."],
	"mocked": ["Mocked", "M!", Color(0.95, 0.5, 0.3), "Must attack the Warrior who mocked them."],
	"poison": ["Poison", "P", Color(0.45, 0.8, 0.3), "Takes 3 nature damage per stack at the\nstart of each turn; new stacks refresh\nthe timer."],
	"quickdraw": ["Quick Draw", "QD", Color(0.55, 0.85, 0.40), "All abilities act 50% faster;\nturns arrive sooner."],
	"parry_up": ["Parry Up", "P+", Color(0.4, 0.9, 1.0), "+15% parry chance."],
	"mana_shield": ["Mana Shield", "MS", Color(0.35, 0.6, 1.0), "50% of damage taken converts\ninto Mana."],
	"rampage": ["Rampage", "Rp", Color(0.9, 0.3, 0.3), "+1% damage per 10 Bleed buildup\non the enemy party (at cast time)."],
	"unity": ["Unity", "Un", Color(0.95, 0.85, 0.4), "Souls bound: all damage received is\nsplit evenly among the party."],
	"mindflay": ["Mind Flay", "MF", Color(0.75, 0.35, 0.85), "Maddened: attacks its own allies\nwith bonus Break damage."],
	"devotion": ["Devotion Aura", "DA", Color(0.95, 0.8, 0.45), "The Devout's presence: takes 15%\nless Break damage."],
	"tripwire": ["Tripwire", "TW", Color(0.8, 0.65, 0.35), "Retaliates against every attacking\nmelee enemy for 75% of their damage."],
	"stunned": ["Stunned", "St", Color(0.95, 0.9, 0.4), "Loses their next turn."],
	"shieldwall": ["Shieldwall", "SW", Color(0.6, 0.7, 0.9), "Takes 25% less damage."],
	"empower": ["Empower", "+A", Color(0.95, 0.45, 0.35), "+25% damage dealt."],
	"exposed": ["Exposed", "E", Color(0.95, 0.9, 0.4), "Takes 15% more damage."],
	"cripple": ["Cripple", "C", Color(0.5, 0.4, 0.55), "-25% damage dealt."],
	"retaliate": ["Retaliation", "R!", Color(0.95, 0.6, 0.25), "Counters attackers with a basic strike."],
	"dazed": ["Dazed", "Dz", Color(0.95, 0.7, 0.35), "Attacks are 20% more likely to miss."],
	"shielded": ["Shielded", "Sh", Color(0.95, 0.65, 0.25), "Takes 25% less damage\n(a Shieldmaster's ward)."],
	"wrath": ["Divine Wrath", "DW", Color(1.0, 0.85, 0.35), "+15% damage dealt and +15% speed."],
	"umbral_sigil": ["Umbral Sigil", "US", Color(0.55, 0.30, 0.70), "Branded: half of all attack damage\nthis unit takes echoes to its\nwhole party."],
	"battle_shout": ["Battle Shout", "BS", Color(0.95, 0.45, 0.30), "+1% damage per 20 blood buildup\non the enemy party (at cast time)."],
	"shield_charges": ["Shieldwall", "SW", Color(0.65, 0.72, 0.85), "The next attacks against this unit\nare BLOCKED (one charge each)."],
	"high_guard": ["High Guard", "HG", Color(0.55, 0.80, 0.95), "Takes 25% less damage."],
	"elem_weak": ["Elemental Weakness", "EW", Color(0.40, 0.80, 0.75), "Elemental resistances reduced."],
	"hold_bd": ["Hold the Line", "HL", Color(0.95, 0.82, 0.45), "Takes 50% less Break damage."],
	"undying": ["Undying", "UD", Color(1.0, 0.95, 0.75), "Cannot drop below 1 HP."],
	"rally_heal": ["Rallied", "R+", Color(0.95, 0.75, 0.45), "+15% healing received\n(the Warden's Rally)."],
	"flame_shield": ["Flame Shield", "FS", Color(1.0, 0.55, 0.25), "Takes 50% less damage; attackers\nare set Burning (3 turns)."],
	"seeding": ["Seeding Embers", "SE", Color(1.0, 0.65, 0.3), "Empowered by a burning death:\nbonus damage on the next turn."],
	"rime": ["Rime", "Ri", Color(0.75, 0.9, 1.0), "Rimed: every stack of Chilled this\nenemy gains also chills one other\nrandom enemy."],
	"frostbite": ["Frostbite", "Fb", Color(0.45, 0.70, 0.95), "Frostbitten: healing received\nreduced by 50%."],
	"stabilized": ["Stabilized", "St+", Color(0.55, 0.68, 0.95), "Grounded resonance: takes less\ndamage (10% per stack consumed)."],
	"overcharged": ["Overcharged", "OC", Color(0.8, 0.5, 1.0), "Maximum Resonance raised to 8;\nstacks beyond 5 give extra Resonance\nbonus (damage, crit, damage taken)."],
	"unlimited": ["Unlimited Power", "UP", Color(0.85, 0.55, 1.0), "Resonance overflow: bonus damage\nand maximum Mana, all battle."],
	"sanctified": ["Hallowed", "Hw", Color(0.98, 0.88, 0.55), "Warded by the light: immune to\nnew debuffs."],
	"capacitor": ["Holy Capacitor", "HC", Color(0.95, 0.9, 0.6), "Stored overhealing, released by\nthe next Heal."],
	"faith": ["Faith", "F1", Color(0.98, 0.85, 0.45), "Conviction: Divine Shield absorbs\nbuild Faith — 3% mitigation and +2%\ndamage per stack; at 5 the bearer\nis healed and the Faith resets."],
	"cons_ground": ["Consecrated Ground", "CG", Color(0.9, 0.82, 0.5), "Standing on holy ground: takes 15%\nless damage and reflects 10% of\ndamage taken."],
	"zeal": ["Blessing of Zeal", "Z+", Color(1.0, 0.78, 0.35), "+15% damage dealt; Faith gain\nis doubled."],
	"bulwark": ["Bulwark of Fortitude", "BF", Color(0.85, 0.9, 1.0), "The unbreakable stand: NO Break\ndamage taken, armor increased by\n50%, and 10% max health regained\neach turn."],
}

# Buff/Debuff keyword registry (DEBUFF_IDS) lives in unit.gd so chips can
# count debuffs live; battle code reaches it as BattleUnit.DEBUFF_IDS.

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
# Values are the PERCENT of the applier's Attack dealt per tick (snapshotted
# when the status lands); Poison is per-stack (stacks handled at the tick
# site). The raw number doubles as the legacy fallback for tickless statuses.
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
var active_unit: BattleUnit  # acting unit — its nameplate glows gold

# Autoplay: heroes act automatically with a simple policy (no skill check UI).
#   DOD_AUTOPLAY=1 godot --headless          -> one battle with debug prints
#   DOD_SIM=200  godot --headless            -> 200 max-speed battles + stats report
var autoplay := false
var sim := false
var sim_target := 0
var debug_prints := false
var debug_enemies_off := false  # debug toggle: enemies skip their turns
var debug_locked_hero: BattleUnit = null  # debug: every turn goes to this hero
var debug_cooldowns_off := false  # debug toggle: abilities never cool down
var _rime_echoing := false  # guards Rime chill-echoes from chaining
var empower_armed := false  # Mercy: the next heal cast spends +1 stack
var _debug_popup: PopupMenu

# Accumulated across scene reloads within one simulation run.
static var sim_stats := {}
static var sim_done := 0
static var sim_started_ms := 0

var history: RichTextLabel
var history_panel: PanelContainer
var _log_toggle: Button

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
	# DOD_ENEMIES_OFF=1 arms the "Enemy attacks OFF" debug toggle from the
	# environment so headless tests can exercise the skip path.
	if OS.get_environment("DOD_ENEMIES_OFF") == "1":
		debug_enemies_off = true
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
	# Zoomed out as far as the screen allows: the smallest scale that still
	# fills the 1280x720 view (plus the ±8px screen-shake margin). Any
	# smaller would show void at the edges. The real fix for oversized
	# scenery is background art authored to the Berserker resolution template.
	var cover := maxf(1296.0 / tex.get_width(), 736.0 / tex.get_height())
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


# Parties are grouped tight; names/bars/chips live on nameplate stacks at the
# screen edges (heroes left, enemies right), leaving the field to the sprites.
const HERO_SLOTS := [Vector2(430, 380), Vector2(350, 455), Vector2(430, 530), Vector2(350, 605)]
const ENEMY_LAYOUTS := {
	1: [Vector2(940, 470)],
	2: [Vector2(920, 410), Vector2(980, 540)],
	3: [Vector2(910, 390), Vector2(990, 480), Vector2(920, 575)],
	4: [Vector2(910, 380), Vector2(990, 450), Vector2(910, 520), Vector2(990, 590)],
	5: [Vector2(905, 370), Vector2(985, 425), Vector2(905, 480), Vector2(985, 535),
		Vector2(945, 595)],
	6: [Vector2(905, 355), Vector2(985, 405), Vector2(905, 455), Vector2(985, 505),
		Vector2(905, 555), Vector2(985, 600)],
}
# Nameplate stacks: plate i belongs to party slot i (companion = 5th hero slot).
const HERO_PLATE_X := 8.0
const ENEMY_PLATE_X := 1128.0  # 1280 - 8 - plate width (144)
const PLATE_TOP := 210.0
const PLATE_STEP := 82.0

# Specs with their own battle art (everyone else shares the Soldier sheet +
# slot tint). Values are config overrides; own-art heroes render untinted.
# The Pyromancer is a SIZE TEST: native 236px frame at 1:1 — intentionally
# larger than the Berserker template so the two can be compared in-game.
const SPEC_ART := {
	"berserker": {"sheet_dir": "res://assets/sprites/berserker", "frame_size": 124,
		"sprite_scale": 1.25,
		"portrait_path": "res://assets/sprites/berserker/Berserker_Portrait.png",
		"walks_to_target": true},
	"pyromancer": {"sheet_dir": "res://assets/sprites/pyromancer", "frame_size": 236,
		"sprite_scale": 1.0},
}


# Enemy roles set base Attack like hero archetypes do (Damage 100 / Tank 75 /
# Support 50); ability damage is a % of it. Health pools are multiples of 10.
func _enemy_config(kind: String) -> Dictionary:
	var orc := "res://assets/sprites/orc"
	match kind:
		"chief":
			return {"unit_name": "Orc Chief", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "damage",
				"max_hp": 250, "attack": 100, "armor": 0.20, "speed": 80.0,
				"stability": 100, "constitution": 130,
				"resource_name": "Rage", "resource": 0, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 3.9,
				"tint": Color(1.0, 0.75, 0.7),
				"resists": {"physical": 0.15}}
		"boss":
			# Zone 1's Withered Warden has its own kit; later bosses are still
			# Chief stand-ins until their unique kits and art exist.
			if (Run.zone_idx if Run.active else 0) == 0:
				return {"unit_name": "Withered Warden", "is_hero": false, "enemy_role": "tank",
					"sheet_dir": orc, "max_hp": 500, "attack": 100, "armor": 0.35,
					"speed": 80.0,
					"stability": 100, "constitution": 150, "is_boss": true,
					"abilities": _withered_warden_kit(), "sprite_scale": 4.4,
					"tint": Color(0.7, 1.0, 0.7), "resists": {"nature": 0.75}}
			return {"unit_name": "Ash-Wrought Tyrant", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "damage",
				"max_hp": 370, "attack": 100, "armor": 0.22, "speed": 85.0,
				"stability": 100, "constitution": 160, "is_boss": true,
				"resource_name": "Rage", "resource": 20, "max_resource": 100,
				"abilities": _orc_chief_kit(), "sprite_scale": 4.4,
				"tint": Color(1.0, 0.55, 0.35),
				"resists": {"fire": 0.50, "physical": 0.10}, "weak": ["frost"]}
		"shieldmaster":
			return {"unit_name": "Orc Shieldmaster", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "tank",
				"max_hp": 150, "attack": 75, "armor": 0.25, "speed": 85.0,
				"stability": 100, "constitution": 120, "block_chance": 0.05,
				"abilities": _orc_shieldmaster_kit(), "tint": Color(1.0, 0.62, 0.2),
				"resists": {}}
		"shaman":
			return {"unit_name": "Orc Shaman", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "support",
				"max_hp": 110, "attack": 50, "armor": 0.01, "speed": 100.0,
				"stability": 100, "constitution": 80,
				"is_ranged": true,
				"abilities": _orc_shaman_kit(), "tint": Color(0.4, 0.55, 1.0),
				"resists": {"fire": 0.25, "frost": 0.25, "nature": 0.50}}
		"archer":
			return {"unit_name": "Orc Archer", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "damage",
				"max_hp": 110, "attack": 100, "armor": 0.10, "speed": 100.0,
				"stability": 100, "constitution": 85,
				"is_ranged": true,
				"abilities": _orc_archer_kit(), "tint": Color(1.0, 0.35, 0.35),
				"resists": {"physical": 0.05}}
		_:
			return {"unit_name": "Orc Raider", "is_hero": false, "sheet_dir": orc,
				"enemy_role": "damage",
				"max_hp": 140, "attack": 100, "armor": 0.15, "speed": 90.0,
				"stability": 100, "constitution": 100,
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
		var base_hp: int = cfg["max_hp"]  # node scaling works off the base
		cfg["hero_key"] = hero_keys[i]
		var spec := ""
		if Run.active and i < Run.party.size():
			spec = Run.party[i].get("spec", "")
		elif autoplay:
			spec = sim_specs[i]
		if spec != "":
			cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
			cfg["passive_id"] = Classes.SPEC_INFO[spec]["passive"]
			# Once awakened, the hero goes by their spec, not their class.
			cfg["unit_name"] = Classes.SPEC_INFO[spec]["name"]
			# Role-based break resistance replaces the class base once specced.
			cfg["constitution"] = Classes.SPEC_INFO[spec].get("constitution",
				cfg.get("constitution", 100))
			# Spec stat block: Attack by role (Tank 75 / Damage 100 / Support
			# 50 until per-spec values land) and innate resistances.
			cfg["attack"] = Classes.spec_attack(spec)
			cfg["resists"] = Classes.spec_resists(spec).duplicate()
			# Arcane Resonance is the Arcanist's passive mechanic alone.
			if spec == "arcanist":
				cfg["second_resource_name"] = "Resonance"
				cfg["second_resource"] = 0
				cfg["second_max"] = 5
			# Mercy is the Holy Cleric's passive mechanic alone.
			if spec == "holy":
				cfg["second_resource_name"] = "Mercy"
				cfg["second_resource"] = 0
				cfg["second_max"] = 5
			# Specs with their own battle art override the shared Soldier sheet.
			if SPEC_ART.has(spec):
				for art_key in SPEC_ART[spec]:
					cfg[art_key] = SPEC_ART[spec][art_key]
			Classes.apply_kit_overrides(cfg, spec)
			Classes.apply_passive(cfg, spec)
			if Run.active and i < Run.party.size():
				Talents.apply_from_tree(cfg, Run.party[i].get("tree", []),
					Run.party[i].get("talents", {}))
			elif autoplay:
				# DOD_SIM_TALENTS="bz_bloodcraze:3,wd_toughness:2" force-learns
				# talents on bot heroes whose spec tree holds the id (test hook).
				var env_talents := OS.get_environment("DOD_SIM_TALENTS")
				if env_talents != "":
					var t_tree := Talents.generate_tree(spec, hero_keys[i])
					var t_learned := {}
					for pair in env_talents.split(","):
						var bits: PackedStringArray = pair.split(":")
						if not Talents.node_in_tree(t_tree, bits[0]).is_empty():
							t_learned[bits[0]] = int(bits[1]) if bits.size() > 1 else 1
					if not t_learned.is_empty():
						Talents.apply_from_tree(cfg, t_tree, t_learned)
				# DOD_SIM_ABILITIES="Resurrection,Divine Plea" appends pending
				# talent abilities (defs in Classes) to the bot hero whose spec
				# will own them — a test hook for talent-gated kit pieces whose
				# tree isn't designed yet (Holy only, for now).
				var env_abs := OS.get_environment("DOD_SIM_ABILITIES")
				if env_abs != "" and spec == "holy":
					for ab_name in env_abs.split(","):
						var pending := Classes.pending_talent_ability(ab_name.strip_edges())
						if pending != null:
							cfg["abilities"] = cfg["abilities"] + [pending]
		# Class passives (every spec of the class, and before awakening).
		match hero_keys[i]:
			"cleric":
				cfg["healing_received_mult"] = 1.15  # Holy Conduit
			"mage":
				cfg["mana_regen_bonus"] = 10          # Evocation
		# (Warrior: Threatening Presence lives in enemy targeting;
		#  Hunter: Tracker sets his opening initiative below.)
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
		# Toughness (Warden talent): Constitution grows with bulk.
		if cfg.get("toughness_ranks", 0) > 0:
			cfg["constitution"] = int(cfg.get("constitution", 100)
				+ 0.05 * cfg["toughness_ranks"] * cfg["max_hp"])
		# Node scaling: +2% of BASE Attack and HP per combat node won this
		# run (linear). Armor/resists/speed/constitution/crit/block/parry
		# never scale (Toughness above reads the unscaled HP for the same
		# reason).
		if Run.active and Run.combat_wins > 0:
			cfg["attack"] = int(round(int(cfg.get("attack", 100))
				* (1.0 + 0.02 * Run.combat_wins)))
			cfg["max_hp"] = int(cfg["max_hp"]) \
				+ int(round(base_hp * 0.02 * Run.combat_wins))
		# Heroes with their own art keep original colors — no slot tint.
		var hero_tint: Color = Classes.HERO_TINTS[i]
		if SPEC_ART.has(spec):
			hero_tint = Color.WHITE
		var u := _make_unit(cfg, HERO_SLOTS[i], hero_tint, _hero_plate_pos(i))
		u.crit_bonus = cfg.get("crit_bonus", 0.0)
		u.parry_bonus = cfg.get("parry_bonus", 0.0)
		u.below_half_cb = _on_hero_below_half
		if spec != "":
			u.add_status("spec_passive", Classes.SPEC_INFO[spec]["name"], "★",
				Color(0.9, 0.78, 0.4), -1, Classes.SPEC_INFO[spec]["passive_desc"])
		var class_passive: Dictionary = Classes.CLASS_PASSIVES[hero_keys[i]]
		u.add_status("class_passive", class_passive["name"], "◆",
			Color(0.65, 0.75, 0.9), -1, class_passive["desc"])
		# Always-on talent buffs carry permanent chips with live counters
		# (Iron Will refreshes in unit.gd, Crushing Blows in _update_talent_chips).
		if u.iron_will_ranks > 0:
			u.add_status("iron_will", "Iron Will", "+0%",
				Color(0.82, 0.58, 0.36), -1, "")
		if u.crushing_blows_ranks > 0:
			u.add_status("crushing_blows", "Crushing Blows", "+0%",
				Color(0.86, 0.44, 0.30), -1, "")
		if Run.active and i < Run.party.size():
			u.hp = clampi(Run.party[i]["hp"], 1, u.max_hp)
			if u.resource_name == "Mana":
				u.resource = clampi(Run.party[i].get("mana", u.resource), 0, u.max_resource)
			u.refresh_bars()
		heroes.append(u)

	# Devoutness (Devout talent, ex-Devotion Aura): the whole party takes
	# less Break damage — a battle-long status whose power carries the %.
	var dvn_ranks := 0
	for h in heroes:
		dvn_ranks = maxi(dvn_ranks, h.devoutness_ranks)
	if dvn_ranks > 0:
		for h in heroes:
			_apply_status(h, "devotion", -1, 5 * dvn_ranks)
			h.update_status("devotion", "DA",
				"Devoutness: takes %d%% less\nBreak damage." % (5 * dvn_ranks),
				5 * dvn_ranks)
	# Conviction (Devout passive): Divine Shield absorbs build Faith, and
	# lethal saves reward — both hook back into the battle scene.
	if heroes.any(func(h): return h.passive_id == "conviction"):
		for h in heroes:
			h.lethal_saved_cb = _on_lethal_saved
			h.shield_absorbed_cb = _on_shield_absorbed

	# Guardian Angel raises the Mercy-earning threshold and Last Hope deepens
	# healing on the nearly-dead — both are the Holy's talents, but the checks
	# run on WHOEVER is hit/healed, so the ranks are stamped party-wide.
	var ga_ranks := 0
	var lh_ranks := 0
	for h in heroes:
		ga_ranks = maxi(ga_ranks, h.guardian_ranks)
		lh_ranks = maxi(lh_ranks, h.last_hope_ranks)
	if ga_ranks > 0 or lh_ranks > 0:
		for h in heroes:
			h.mercy_threshold = 0.5 + 0.03 * ga_ranks
			h.last_hope_bonus = lh_ranks

	var composition: Array = ["raider", "chief", "archer", "archer"]
	# DOD_SIM_ENEMIES="boss,shieldmaster,shaman" forces the enemy lineup in
	# autoplay/sim/standalone battles (testing hook, like DOD_SIM_SPECS).
	var env_comp := OS.get_environment("DOD_SIM_ENEMIES")
	if env_comp != "":
		composition = env_comp.split(",")
	elif Run.active and Run.encounter.has("enemies"):
		composition = Run.encounter["enemies"]
	var layout: Array = ENEMY_LAYOUTS[clampi(composition.size(), 1, 6)]
	# Enemies scale linearly per node tier, counted across the whole game
	# (zone 2's first tier = global tier 11): +4% of base Attack and +5% of
	# base HP per tier. Health pools stay multiples of 10 (rounded UP).
	var tier := 0
	if Run.active:
		tier = Run.zone_idx * Run.FLOORS + maxi(Run.floor_idx, 0)
	for i in composition.size():
		var cfg := _enemy_config(composition[i])
		var tint: Color = cfg["tint"]
		cfg.erase("tint")
		if tier > 0:
			cfg["max_hp"] = int(ceil(cfg["max_hp"] * (1.0 + 0.05 * tier) / 10.0) * 10.0)
			cfg["attack"] = int(round(cfg["attack"] * (1.0 + 0.04 * tier)))
		if Run.active and Run.zone_idx > 0:
			# Deeper zones keep their scorched warpaint.
			tint = tint.lerp(Color(1.0, 0.6, 0.45), 0.35)
		enemies.append(_make_unit(cfg, layout[i], tint,
			Vector2(ENEMY_PLATE_X, PLATE_TOP + i * PLATE_STEP)))

	for u in heroes + enemies:
		u.next_time = (100.0 / u.speed) * randf_range(0.0, 1.0)
	# Tracker (Hunter class passive): always attacks first in every fight.
	for u in heroes:
		if u.hero_key == "hunter":
			u.next_time = -0.01


func _make_unit(config: Dictionary, pos: Vector2, tint: Color,
		plate_pos: Vector2) -> BattleUnit:
	var u := BattleUnit.new()
	u.position = pos
	add_child(u)
	u.setup(config)
	u.log_proc = _log  # unit-side talent procs reach the combat log
	# The nameplate is a sibling (not a child) so lunges/knockback never move it.
	var plate := Node2D.new()
	plate.position = plate_pos
	add_child(plate)
	u.build_plate(plate)
	u.set_tint(tint)
	u.clicked.connect(func(): _target_picked.emit(u))
	u.refresh_bars()
	return u


func _hero_plate_pos(slot: int) -> Vector2:
	return Vector2(HERO_PLATE_X, PLATE_TOP + slot * PLATE_STEP)


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
		Ability.make({"display_name": "Poison Arrow", "dmg_type": "nature",
			"damage": 16, "pressure": 14,
			"delay": 2.5, "anim": "attack02",
			"applies_status": {"id": "poison", "turns": 3}, "status_chance": 0.7}),
	]


# The Shieldmaster guards its warband: one ally at a time carries its ward.
# 37% of its Tank-role 75 Attack ≈ the old flat 28.
func _orc_shieldmaster_kit() -> Array:
	return [
		Ability.make({"display_name": "Strike", "damage": 37, "pressure": 20,
			"delay": 2.0, "anim": "attack01"}),
		Ability.make({"display_name": "Shielding", "special": "enemy_shield",
			"delay": 2.5, "anim": "attack02", "target": Ability.Target.ALLY,
			"description": "Wards an ally: 25% less damage taken for 3 turns."}),
	]


# Support-role caster (50 Attack). VAULTED — Lightning Bolt (removed
# 07-16, kept for future return): {"display_name": "Lightning Bolt",
#   "damage": 70, "pressure": 20, "delay": 2.0, "anim": "attack01",
#   "dmg_type": "nature"}
func _orc_shaman_kit() -> Array:
	return [
		Ability.make({"display_name": "Chain Lightning", "damage": 30, "pressure": 15,
			"delay": 3.0, "anim": "attack02", "dmg_type": "nature", "aoe": true}),
		Ability.make({"display_name": "Healing Wave", "special": "healing_wave",
			"delay": 2.5, "anim": "attack02", "target": Ability.Target.ALLY,
			"description": "Mends the most wounded ally under 40%\nhealth for 25% of their max HP\n(tanks and healers first)."}),
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
	# (All battle UI runs ~20% smaller than the first draft by design.)
	var burger := MenuButton.new()
	burger.text = "☰"
	burger.custom_minimum_size = Vector2(37, 34)
	burger.position = Vector2(12, 10)
	burger.flat = false
	var bpop := burger.get_popup()
	bpop.add_item("Restart Run", 0)
	bpop.add_item("Settings", 1)
	bpop.add_item("Exit to Main Menu", 2)
	bpop.id_pressed.connect(_on_burger)
	ui.add_child(burger)

	var bar_panel := PanelContainer.new()
	bar_panel.position = Vector2(56, 10)
	ui.add_child(bar_panel)
	turn_bar = HBoxContainer.new()
	turn_bar.add_theme_constant_override("separation", 3)
	bar_panel.add_child(turn_bar)

	var bottom_center := CenterContainer.new()
	bottom_center.position = Vector2(0, 668)
	bottom_center.size = Vector2(1280, 44)
	bottom_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(bottom_center)
	action_panel = PanelContainer.new()
	bottom_center.add_child(action_panel)
	action_box = HBoxContainer.new()
	action_box.add_theme_constant_override("separation", 10)
	action_panel.add_child(action_box)
	action_panel.visible = false

	history_panel = PanelContainer.new()
	history_panel.position = Vector2(1028, 8)
	history_panel.self_modulate = Color(1, 1, 1, 0.85)
	ui.add_child(history_panel)
	history = RichTextLabel.new()
	history.bbcode_enabled = true
	history.scroll_following = true
	history.custom_minimum_size = Vector2(240, 152)
	history.add_theme_font_size_override("normal_font_size", 10)
	history_panel.add_child(history)
	# The log can be tucked away; the little button stays to bring it back.
	_log_toggle = Button.new()
	_log_toggle.text = "–"
	_log_toggle.custom_minimum_size = Vector2(24, 20)
	_log_toggle.position = Vector2(1246, 9)
	_log_toggle.tooltip_text = "Hide / show the combat log"
	_log_toggle.pressed.connect(_toggle_log)
	ui.add_child(_log_toggle)


	_build_skill_check_ui()


const SC_TRACK_W := 336.0  # skill check track width (bar UI at -20%)


func _build_skill_check_ui() -> void:
	sc_root = Control.new()
	sc_root.position = Vector2(464, 486)
	sc_root.visible = false
	ui.add_child(sc_root)

	var bg := Panel.new()
	bg.size = Vector2(352, 59)
	sc_root.add_child(bg)

	var hint := Label.new()
	hint.text = "SPACE or CLICK!"
	hint.position = Vector2(0, 3)
	hint.size = Vector2(352, 14)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 11)
	sc_root.add_child(hint)

	var track := ColorRect.new()
	track.position = Vector2(8, 27)
	track.size = Vector2(SC_TRACK_W, 16)
	track.color = Color(0.15, 0.12, 0.18)
	sc_root.add_child(track)

	var good_zone := ColorRect.new()
	good_zone.position = Vector2(8 + (0.5 - GOOD_HALF) * SC_TRACK_W, 27)
	good_zone.size = Vector2(GOOD_HALF * 2 * SC_TRACK_W, 16)
	good_zone.color = Color(0.35, 0.5, 0.3)
	sc_root.add_child(good_zone)

	var perfect_zone := ColorRect.new()
	perfect_zone.position = Vector2(8 + (0.5 - PERFECT_HALF) * SC_TRACK_W, 27)
	perfect_zone.size = Vector2(PERFECT_HALF * 2 * SC_TRACK_W, 16)
	perfect_zone.color = Color(0.9, 0.8, 0.3)
	sc_root.add_child(perfect_zone)

	sc_cursor = ColorRect.new()
	sc_cursor.size = Vector2(4, 22)
	sc_cursor.position = Vector2(8, 24)
	sc_cursor.color = Color.WHITE
	sc_root.add_child(sc_cursor)

	sc_result = Label.new()
	sc_result.position = Vector2(0, 44)
	sc_result.size = Vector2(352, 14)
	sc_result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sc_result.add_theme_font_size_override("font_size", 12)
	sc_root.add_child(sc_result)


# Testing menu (dev builds): a compact DEBUG dropdown bottom-right so it
# stays clear of the nameplate stacks. Turn lock: pick a hero and every HERO
# turn is theirs until unlocked — enemies keep fighting on their own turns
# (silence them with "Enemy attacks OFF").
func _build_debug_panel() -> void:
	var menu := MenuButton.new()
	menu.text = "DEBUG ▾"
	menu.flat = false
	menu.custom_minimum_size = Vector2(88, 32)
	menu.position = Vector2(1180, 678)
	menu.self_modulate = Color(1.0, 0.85, 0.65)
	ui.add_child(menu)
	_debug_popup = menu.get_popup()
	_debug_popup.add_item("Full Restore", 0)
	_debug_popup.add_check_item("Cooldowns OFF", 2)
	_debug_popup.add_check_item("Enemy attacks OFF", 1)
	_debug_popup.add_separator("Turn lock — all hero turns")
	for i in heroes.size():
		_debug_popup.add_radio_check_item("Lock → %s" % heroes[i].unit_name, 10 + i)
	_debug_popup.id_pressed.connect(_on_debug_menu)


func _on_debug_menu(id: int) -> void:
	if id == 0:
		_debug_full_restore()
		return
	if id == 2:
		var cd_idx := _debug_popup.get_item_index(2)
		_debug_popup.set_item_checked(cd_idx, not _debug_popup.is_item_checked(cd_idx))
		debug_cooldowns_off = _debug_popup.is_item_checked(cd_idx)
		if debug_cooldowns_off:
			for u2 in heroes + companions + enemies:
				u2.cooldowns.clear()
				u2.unrelenting_cd = 0
		_log("DEBUG: cooldowns %s" % ("OFF" if debug_cooldowns_off else "back on"),
			"#e0a050")
		if current_hero != null and not current_hero.dead and action_panel.visible:
			_show_actions(current_hero)
		return
	if id == 1:
		var check_idx := _debug_popup.get_item_index(1)
		_debug_popup.set_item_checked(check_idx, not _debug_popup.is_item_checked(check_idx))
		_debug_toggle_enemies(_debug_popup.is_item_checked(check_idx))
		return
	# Turn lock radio: clicking the active hero again unlocks.
	var hero: BattleUnit = heroes[id - 10]
	debug_locked_hero = null if debug_locked_hero == hero else hero
	for i in heroes.size():
		_debug_popup.set_item_checked(_debug_popup.get_item_index(10 + i),
			heroes[i] == debug_locked_hero)
	if debug_locked_hero != null:
		_log("DEBUG: every hero turn goes to %s — enemies still act (re-select to unlock)"
			% hero.unit_name, "#e0a050")
	else:
		_log("DEBUG: turn lock released", "#e0a050")


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


# Appends one line to the battle history panel (echoed to stdout in
# autoplay debug runs so headless tests can grep the combat log).
func _log(text: String, color := "#d8d2c4") -> void:
	history.append_text("[color=%s]%s[/color]\n" % [color, text])
	if debug_prints:
		print("[LOG] %s" % text)


func _toggle_log() -> void:
	history_panel.visible = not history_panel.visible
	_log_toggle.text = "–" if history_panel.visible else "Log"
	_log_toggle.custom_minimum_size = Vector2(24 if history_panel.visible else 44, 20)
	_log_toggle.position = Vector2(1246 if history_panel.visible else 1226, 9)


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
		portrait.custom_minimum_size = Vector2(38, 53)
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
		stripe.custom_minimum_size = Vector2(38, 3)
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
	# The warband's theme opens the log — the composition isn't random.
	if Run.active and String(Run.encounter.get("theme", "")) != "":
		_log("Enemy warband: %s" % Run.encounter["theme"], "#c8b880")
	await _wait(0.8)
	while not battle_over:
		_update_talent_chips()
		_rebuild_turn_bar()
		var u := _next_unit()
		if u == null:
			break
		# Debug turn lock: every HERO turn goes to the locked hero — enemies
		# still act on their own turns. The displaced hero's clock advances
		# as if they had taken a basic action, so the timeline keeps flowing.
		if debug_locked_hero != null and not debug_locked_hero.dead \
				and u.is_hero and u != debug_locked_hero:
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			u = debug_locked_hero
		# Turn indicator: the acting unit's nameplate glows gold.
		if active_unit != null and is_instance_valid(active_unit):
			active_unit.set_plate_active(false)
		active_unit = u
		u.set_plate_active(true)
		for dot_id in DOT_STATUSES:
			if u.has_status(dot_id) and not u.dead:
				# Poison never ticks on the turn it was applied.
				if dot_id == "poison":
					var pstatus: Dictionary = u.get_status("poison")
					if pstatus.get("fresh", false):
						pstatus["fresh"] = false
						continue
				# Tick strength was snapshotted from the applier's Attack.
				var dot_dmg: int = int(u.get_status(dot_id).get("tick", 0))
				if dot_dmg <= 0:
					dot_dmg = DOT_STATUSES[dot_id]
				var stack_tag := ""
				if dot_id == "poison":
					var stacks := maxi(u.status_stacks("poison"), 1)
					dot_dmg *= stacks
					stack_tag = " (x%d stacks)" % stacks if stacks > 1 else ""
					# Poison counts as nature damage: nature resists apply.
					var nat_resist := float(u.resists.get("nature", 0.0))
					if nat_resist != 0.0:
						dot_dmg = maxi(int(round(dot_dmg * (1.0 - nat_resist))), 0)
						stack_tag += " (resisted)" if nat_resist > 0.0 else " (WEAK!)"
				var info: Array = STATUS_INFO[dot_id]
				_sfx("hit", -14.0, 0.8)
				var dot_died: bool = u.take_tick_damage(dot_dmg, "-%d %s" % [dot_dmg, info[0]], info[2])
				_log("%s takes %d %s damage%s" % [u.unit_name, dot_dmg, info[0],
					stack_tag], "#e08850")
				# Pyromancer burn-tick talents: mana sipped from the flames,
				# armor melting off the victim (shown as a chip).
				if dot_id == "burn" and not u.is_hero:
					for h in heroes:
						if h.dead:
							continue
						if h.invigorating_ranks > 0 and h.resource_name == "Mana" \
								and randf() < 0.05 * h.invigorating_ranks:
							var ash_mana := maxi(int(h.max_resource * 0.02), 1)
							h.resource = mini(h.resource + ash_mana, h.max_resource)
							h.refresh_bars()
							h.float_text("+%d Mana" % ash_mana, Color(0.5, 0.7, 1.0))
							_log("   → Talent: Invigorating Ashes — %s sips %d Mana" % [
								h.unit_name, ash_mana], "#b0a8e0")
						if h.melt_ranks > 0 and not u.dead:
							u.melted += 0.01 * h.melt_ranks
							var melt_pct := int(round(u.melted * 100))
							var melt_desc := "Melt Armor: %d%% armor burned away\nfor the rest of the battle." % melt_pct
							if not u.update_status("melted", "-%d%%" % melt_pct, melt_desc):
								u.add_status("melted", "Melt Armor", "-%d%%" % melt_pct,
									Color(1.0, 0.5, 0.2), -1, melt_desc)
				await _wait(0.5)
				if dot_died:
					_message("%s succumbs to %s!" % [u.unit_name, info[0]])
					_log("† %s dies" % u.unit_name, "#e05050")
		if u.dead:
			_check_end()
			continue
		# Turn-start regeneration effects.
		if u.has_status("renewal"):
			# The tick was snapshotted at cast: 15% of the caster's max HP.
			var ren_stat := u.get_status("renewal")
			var ren_amt := maxi(int(ren_stat.get("tick", 15)), 1)
			var ren_got := u.heal_amount(ren_amt, true)
			u.float_text("+%d" % ren_got, Color(0.45, 0.9, 0.5))
			_log("%s regenerates %d HP (Renewal)" % [u.unit_name, ren_got], "#70d878")
			# On the Mend (talent, snapshotted on the status): the tick can
			# wash one harmful effect away.
			var mend_ranks := int(ren_stat.get("mend", 0))
			if mend_ranks > 0 and randf() < 0.05 * mend_ranks:
				var mended := u.dispel_one_debuff()
				if mended != "":
					u.float_text("Mended: %s" % mended, Color(0.5, 0.95, 0.6))
					_log("   → Talent: On the Mend — Renewal washes the %s off %s" % [
						mended, u.unit_name], "#b0a8e0")
		# Bulwark of Fortitude: the stand knits flesh every turn.
		if u.has_status("bulwark"):
			var bw_amt := maxi(int(round(u.max_hp * 0.10)), 1)
			var bw_tick := u.heal_amount(bw_amt, true)
			u.float_text("+%d" % bw_tick, Color(0.55, 0.75, 0.95))
			_log("%s stands fortified — regains %d HP (Bulwark)" % [
				u.unit_name, bw_tick], "#8c9cc8")
		# Sacred Resolve riders: Healing Pulse drips, Cleansing Waters wash.
		if u.has_status("unity"):
			var ustat := u.get_status("unity")
			var pulse_amt := int(ustat.get("pulse", 0))
			if pulse_amt > 0 and not u.is_companion:
				var pulse_got := u.heal_amount(pulse_amt, true)
				u.float_text("+%d" % pulse_got, Color(0.4, 0.9, 0.45))
				_log("   → Talent: Healing Pulse — %s mends %d" % [
					u.unit_name, pulse_got], "#b0a8e0")
			var waters := int(ustat.get("cleanse", 0))
			if waters > 0 and randf() < 0.15 * waters:
				var washed := u.dispel_one_debuff()
				if washed != "":
					u.float_text("Cleansed: %s" % washed, Color(0.5, 0.95, 0.6))
					_log("   → Talent: Cleansing Waters — the %s washes off %s" % [
						washed, u.unit_name], "#b0a8e0")
		if u.has_status("focus") and u.resource_name == "Mana":
			u.resource = mini(u.resource + 10, u.max_resource)
			u.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
			u.refresh_bars()
		if u.has_status("stunned"):
			u.remove_status("stunned")
			u.float_text("STUNNED", Color(0.95, 0.9, 0.4))
			_log("%s is stunned and loses their turn" % u.unit_name, "#e0d060")
			# A lost turn still counts: other status timers and cooldowns tick.
			u.tick_statuses()
			u.tick_cooldowns()
			await _wait(0.8)
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			continue
		if u.has_status("frozen"):
			u.remove_status("frozen")
			u.float_text("FROZEN", Color(0.65, 0.88, 1.0))
			_log("%s is frozen solid and loses their turn" % u.unit_name, "#7cc8f0")
			# A lost turn still counts: other status timers and cooldowns tick.
			u.tick_statuses()
			u.tick_cooldowns()
			await _wait(0.8)
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			continue
		u.tick_statuses()
		u.tick_cooldowns()
		# Mindfulness (Arcanist talent): a settled mind recovers sooner —
		# every Nth turn, all active cooldowns tick down 1 extra.
		if u.mindfulness_ranks > 0:
			u.mindfulness_counter += 1
			if u.mindfulness_counter >= 7 - u.mindfulness_ranks:
				u.mindfulness_counter = 0
				var mind_hit := false
				for ab_name in u.cooldowns.keys():
					if int(u.cooldowns[ab_name]) > 0:
						u.cooldowns[ab_name] = int(u.cooldowns[ab_name]) - 1
						mind_hit = true
				if mind_hit:
					u.float_text("Mindfulness", Color(0.7, 0.8, 1.0))
					_log("   → Talent: Mindfulness — %s's cooldowns tick an extra turn" % \
						u.unit_name, "#b0a8e0")
		# Endurance (Warden talent): armor stacks while unhealed by others,
		# shown as a buff chip that tracks the current bonus.
		if u.endurance_ranks > 0:
			if u.healed_externally:
				u.endurance_stacks = 0
				u.remove_status("endurance")
				_log("   → Talent: Endurance resets (%s was healed)" % u.unit_name,
					"#b0a8e0")
			else:
				u.endurance_stacks += 1
				var e_pct := 1 * u.endurance_ranks * u.endurance_stacks
				var e_desc := "Endurance: +%d%% armor for every turn\nwithout an external heal.\nCurrently +%d%% armor (%d-turn streak)." % [
					u.endurance_ranks, e_pct, u.endurance_stacks]
				if not u.update_status("endurance", "+%d%%" % e_pct, e_desc):
					u.add_status("endurance", "Endurance", "+%d%%" % e_pct,
						Color(0.76, 0.68, 0.48), -1, e_desc)
				_log("   → Talent: Endurance — %s hardens (+%d%% armor)" % [
					u.unit_name, e_pct], "#b0a8e0")
			u.healed_externally = false
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
	if active_unit != null and is_instance_valid(active_unit):
		active_unit.set_plate_active(false)


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


# Talent chips whose value depends on battle-wide state (Crushing Blows reads
# the whole enemy party's bloodloss). Called every loop tick and after bleed
# changes; Iron Will keeps itself fresh inside unit._refresh_chips instead.
func _update_talent_chips() -> void:
	var party_bleed := 0
	for foe in enemies:
		if not foe.dead:
			party_bleed += foe.bleed_buildup
	for h in heroes:
		if h.dead or h.crushing_blows_ranks == 0:
			continue
		var pen: int = 3 * h.crushing_blows_ranks * int(party_bleed / 20.0)
		h.update_status("crushing_blows", "+%d%%" % pen,
			"Crushing Blows: +3%% armor penetration per\nrank for every 20 bloodloss on the enemy\nteam. Currently +%d%% (%d total bloodloss)." % [
				pen, party_bleed])
	# Inferno Master: the Pyromancer's passive chip tracks burning enemies
	# (Pyromaniac raises the per-enemy step).
	var burning := 0
	for foe in enemies:
		if not foe.dead and foe.has_status("burn"):
			burning += 1
	for h in heroes:
		if h.dead or h.passive_id != "inferno":
			continue
		var inf_step: int = 5 + h.pyromaniac_ranks
		var inf_pct: int = mini(burning, 5) * inf_step
		h.update_status("spec_passive", "+%d%%" % inf_pct,
			"Inferno Master: +%d%% damage for each burning\nenemy (up to +%d%%).\nCurrently +%d%% (%d burning)." % [
				inf_step, inf_step * 5, inf_pct, burning])
	# Seeding Embers: harvest burning deaths (once per corpse).
	for foe in enemies:
		if not foe.dead or foe.seeding_consumed or foe.burn_at_death <= 0:
			continue
		foe.seeding_consumed = true
		for h in heroes:
			if h.dead or h.seeding_ranks == 0:
				continue
			var prev: int = maxi(h.status_power("seeding"), 0) \
				if h.has_status("seeding") else 0
			var seed_pct: int = prev + h.seeding_ranks * foe.burn_at_death
			var sinfo: Array = STATUS_INFO["seeding"]
			var seed_desc := "Seeding Embers: +%d%% damage for the\nnext turn (harvested from a death with\n%d Burn turns left)." % [
				seed_pct, foe.burn_at_death]
			if not h.update_status("seeding", "+%d%%" % seed_pct, seed_desc,
					seed_pct, 2):
				h.add_status("seeding", sinfo[0], "+%d%%" % seed_pct, sinfo[2],
					2, seed_desc, seed_pct)
			_log("   → Talent: Seeding Embers — %s gains +%d%% damage for a turn" % [
				h.unit_name, seed_pct], "#b0a8e0")


func _player_turn(u: BattleUnit) -> void:
	if enemies.all(func(e): return e.dead):
		return  # a companion or DoT already ended it; the loop will notice
	current_hero = u
	item_used = false
	empower_armed = false  # Mercy Empowerment never carries between turns
	if u.resource_name == "Mana":
		# Evocation (Mage class passive) adds mana_regen_bonus.
		u.resource = mini(u.resource + 12 + u.mana_regen_bonus, u.max_resource)
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
				"mana_shield", "divine_wrath", "shield_block", "hold_the_line",
				"battle_shout", "flame_shield", "stabilize", "overcharge",
				"cons_ground", "bulwark"]:
			target = u  # self/party effects need no target choice
		elif ab.special == "resurrection":
			# Resurrection targets the FALLEN (the usable gate guarantees one).
			var fallen := heroes.filter(func(h): return h.dead)
			if fallen.size() == 1:
				target = fallen[0]
			elif fallen.size() > 1:
				used_targeting = true
				target = await _pick_target(fallen)
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
	# Divine Presence (Holy talent): the light settles on the most wounded
	# as the Cleric's turn ends.
	if u.divine_presence_ranks > 0 and not u.dead and not battle_over:
		var dp_pool := heroes.filter(func(h): return not h.dead and not h.is_companion)
		if not dp_pool.is_empty():
			var dp_t := _lowest_hp(dp_pool)
			if dp_t.hp < dp_t.max_hp:
				var dp_amt := maxi(int(round(dp_t.max_hp * 0.01
					* u.divine_presence_ranks * _healing_done_mult(u))), 1)
				var dp_got: int = dp_t.heal_amount(dp_amt, dp_t != u)
				dp_t.float_text("+%d" % dp_got, Color(0.4, 0.9, 0.45))
				_stat("healing", dp_got)
				_log("   → Talent: Divine Presence — %s mends %d" % [
					dp_t.unit_name, dp_got], "#b0a8e0")
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
	match u.hero_key:
		"warrior":
			var pommel := _find_ability(u, "Pommel Strike")
			if pommel != null and u.resource >= pommel.cost and u.ability_ready(pommel) and randf() < 0.35:
				return [pommel, target_foe]
			var hack := _find_ability(u, "Hack and Slash")
			if hack != null and u.resource >= hack.cost and u.ability_ready(hack) and randf() < 0.4:
				return [hack, target_foe]
			var stomp := _find_ability(u, "War Stomp")
			if stomp != null and u.resource >= stomp.cost and u.ability_ready(stomp) \
					and foes.size() >= 2 and randf() < 0.35:
				return [stomp, target_foe]
			var crushing := _find_ability(u, "Crushing Blow")
			if crushing != null and u.resource >= crushing.cost and u.ability_ready(crushing) \
					and not target_foe.has_status("sunder"):
				return [crushing, target_foe]
			var overpower := _find_ability(u, "Overpower")
			if overpower != null and u.resource >= overpower.cost and u.ability_ready(overpower):
				return [overpower, target_foe]
			return [u.abilities[0], target_foe]          # Strike
		"mage":
			# Pyromancer: keep fires lit, detonate ripe burns, wave wide.
			var burning_foes := foes.filter(func(e): return e.has_status("burn"))
			var fstorm := _find_ability(u, "Firestorm")
			if fstorm != null and u.resource >= fstorm.cost and u.ability_ready(fstorm) \
					and foes.size() >= 3:
				return [fstorm, target_foe]
			var fshield := _find_ability(u, "Flame Shield")
			if fshield != null and u.resource >= fshield.cost and u.ability_ready(fshield) \
					and not u.has_status("flame_shield") and u.hp < u.max_hp * 0.7:
				return [fshield, u]
			var fwave := _find_ability(u, "Flamewave")
			if fwave != null and u.resource >= fwave.cost and u.ability_ready(fwave) \
					and burning_foes.size() >= 2:
				return [fwave, target_foe]
			var det := _find_ability(u, "Detonation")
			if det != null and u.resource >= det.cost and u.ability_ready(det) \
					and target_foe.has_status("burn") \
					and int(target_foe.get_status("burn").get("turns", 0)) >= 3:
				return [det, target_foe]
			var wfire := _find_ability(u, "Wildfire")
			if wfire != null and u.resource >= wfire.cost and u.ability_ready(wfire) \
					and foes.size() >= 2 and target_foe.has_status("burn"):
				return [wfire, target_foe]
			# Arcanist: ride the Resonance engine — big spenders first.
			var wrath := _find_ability(u, "Magi's Wrath")
			if wrath != null and u.resource >= wrath.cost and u.ability_ready(wrath) \
					and foes.size() >= 3 and u.second_resource >= 3:
				return [wrath, target_foe]
			var ocharge := _find_ability(u, "Overcharge")
			if ocharge != null and u.resource >= ocharge.cost and u.ability_ready(ocharge) \
					and not u.overcharged and u.second_resource >= 4:
				return [ocharge, u]
			var stab := _find_ability(u, "Stabilize")
			if stab != null and u.ability_ready(stab) \
					and u.second_resource >= u.second_max \
					and u.hp < u.max_hp * 0.7:
				return [stab, u]
			var cannon := _find_ability(u, "Arcane Cannon")
			if cannon != null and u.resource >= cannon.cost and u.ability_ready(cannon) \
					and u.second_resource >= 2:
				return [cannon, target_foe]
			var barrage := _find_ability(u, "Arcane Barrage")
			if barrage != null and u.resource >= barrage.cost and u.ability_ready(barrage) and foes.size() >= 2:
				return [barrage, target_foe]
			# Cryomancer: shatter ripe stacks, rime spreaders, lance the frozen.
			var shat := _find_ability(u, "Shatter")
			if shat != null and u.resource >= shat.cost and u.ability_ready(shat):
				var chill_total := 0
				for e in foes:
					chill_total += e.status_stacks("chilled") if e.has_status("chilled") else 0
				if chill_total >= 4:
					return [shat, target_foe]
			var rime_ab := _find_ability(u, "Rime")
			if rime_ab != null and u.resource >= rime_ab.cost and u.ability_ready(rime_ab) \
					and foes.size() >= 2 and not target_foe.has_status("rime"):
				return [rime_ab, target_foe]
			var lance := _find_ability(u, "Ice Lance")
			if lance != null and u.resource >= lance.cost and u.ability_ready(lance):
				var frozen_foes := foes.filter(func(e): return e.has_status("frozen"))
				if not frozen_foes.is_empty():
					return [lance, frozen_foes[0]]
			var bliz := _find_ability(u, "Blizzard")
			if bliz != null and u.resource >= bliz.cost and u.ability_ready(bliz) \
					and foes.size() >= 2:
				return [bliz, target_foe]
			var razor := _find_ability(u, "Razor Ice")
			if razor != null and u.resource >= razor.cost and u.ability_ready(razor) \
					and foes.size() >= 2:
				return [razor, target_foe]
			return [u.abilities[0], target_foe]          # basic bolt
		"hunter":
			var summon := _find_ability(u, "Summon Canis")
			if summon != null and u.resource >= summon.cost and u.ability_ready(summon) \
					and (u.companion == null or u.companion.dead):
				return [summon, u]
			var kill_cmd := _find_ability(u, "Kill Command")
			if kill_cmd != null and u.resource >= kill_cmd.cost and u.ability_ready(kill_cmd) \
					and u.companion != null and not u.companion.dead:
				return [kill_cmd, target_foe]
			var parrow := _find_ability(u, "Poisoned Arrow")
			if parrow != null and u.resource >= parrow.cost and u.ability_ready(parrow) and randf() < 0.4 \
					and not target_foe.has_status("poison"):
				return [parrow, target_foe]
			var shrapnel := _find_ability(u, "Shrapnel Charge")
			if shrapnel != null and u.resource >= shrapnel.cost and u.ability_ready(shrapnel) and foes.size() >= 2:
				return [shrapnel, target_foe]
			var aimed := _find_ability(u, "Aimed Shot")
			if aimed != null and u.resource >= aimed.cost and u.ability_ready(aimed):
				return [aimed, target_foe]
			return [u.abilities[0], target_foe]          # Quick Shot
		"cleric":
			# Holy triage first (Mercy spenders), then Devout/Occultist casts.
			var res_ab := _find_ability(u, "Resurrection")
			if res_ab != null and u.second_resource >= res_ab.faith_cost \
					and u.ability_ready(res_ab):
				var fallen := heroes.filter(func(h): return h.dead)
				if not fallen.is_empty():
					empower_armed = u.second_resource >= res_ab.faith_cost + 1
					return [res_ab, fallen[0]]
			var dplea := _find_ability(u, "Divine Plea")
			if dplea != null and u.second_resource >= dplea.faith_cost \
					and u.ability_ready(dplea) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.35:
				empower_armed = u.second_resource >= dplea.faith_cost + 1 \
					and weakest_ally.count_debuffs() > 0
				return [dplea, weakest_ally]
			var hymn := _find_ability(u, "Hymn of Hope")
			if hymn != null and u.second_resource >= hymn.faith_cost and u.ability_ready(hymn) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.6:
				empower_armed = u.second_resource >= hymn.faith_cost + 2
				return [hymn, u]
			var hheal := _find_ability(u, "Heal")
			if hheal != null and u.resource >= hheal.cost and u.ability_ready(hheal) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.55:
				return [hheal, weakest_ally]
			var renew := _find_ability(u, "Renewal")
			if renew != null and u.resource >= renew.cost and u.ability_ready(renew) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.8 \
					and not weakest_ally.has_status("renewal"):
				return [renew, weakest_ally]
			# Devout: the Conviction toolkit.
			var bulwark_ab := _find_ability(u, "Bulwark of Fortitude")
			if bulwark_ab != null and u.resource >= bulwark_ab.cost \
					and u.ability_ready(bulwark_ab) \
					and allies.filter(func(h): return h.hp < h.max_hp * 0.7).size() >= 2:
				return [bulwark_ab, u]
			var resolve_ab := _find_ability(u, "Sacred Resolve")
			if resolve_ab != null and u.resource >= resolve_ab.cost \
					and u.ability_ready(resolve_ab) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.7:
				return [resolve_ab, u]
			# Divine Shield is the Faith engine: keep it rolling.
			var shield_ab := _find_ability(u, "Divine Shield")
			if shield_ab != null and u.resource >= shield_ab.cost \
					and u.ability_ready(shield_ab) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.8 \
					and not weakest_ally.has_status("barrier"):
				return [shield_ab, weakest_ally]
			var ground_ab := _find_ability(u, "Consecrated Ground")
			if ground_ab != null and u.resource >= ground_ab.cost \
					and u.ability_ready(ground_ab) and foes.size() >= 3 \
					and not u.has_status("cons_ground"):
				return [ground_ab, u]
			var zeal_ab := _find_ability(u, "Blessing of Zeal")
			if zeal_ab != null and u.resource >= zeal_ab.cost and u.ability_ready(zeal_ab):
				var zeal_t: BattleUnit = allies[0]
				for zh in allies:
					if zh.attack > zeal_t.attack:
						zeal_t = zh
				if not zeal_t.has_status("zeal"):
					return [zeal_ab, zeal_t]
			var flay := _find_ability(u, "Mind Flay")
			if flay != null and u.resource >= flay.cost and u.ability_ready(flay) and foes.size() >= 2:
				return [flay, target_foe]
			return [u.abilities[0], target_foe]          # Smite / Shadowrend
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
			heal_target.heal_amount(40, true)
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
	_open_popups.clear()
	_close_summon_picker()
	_close_item_picker()
	# Hotkeys map to menu entries, not raw ability slots: the basic attack is
	# always Q, "Summon Companion" (when the hero has summons) owns W, and the
	# remaining abilities take the following keys in kit order.
	var basic: Ability = u.abilities[0]
	_menu_entries = [{"ability": basic}]
	var summons: Array = []
	for i in range(1, u.abilities.size()):
		if u.abilities[i].special == "summon":
			summons.append(u.abilities[i])
	if not summons.is_empty():
		_menu_entries.append({"summons": summons})
	for i in range(1, u.abilities.size()):
		if u.abilities[i].special != "summon":
			_menu_entries.append({"ability": u.abilities[i]})
	# Basic attack: always its own button.
	var basic_btn := Button.new()
	basic_btn.text = "[%s] %s" % [ABILITY_KEY_NAMES[0], basic.display_name]
	basic_btn.custom_minimum_size = Vector2(84, 32)
	basic_btn.add_theme_font_size_override("font_size", 13)
	basic_btn.tooltip_text = _ability_tooltip(u, basic)
	basic_btn.disabled = not _ability_usable(u, basic)
	basic_btn.pressed.connect(_on_ability_button.bind(basic))
	basic_btn.mouse_entered.connect(_preview_delay.bind(u, basic))
	basic_btn.mouse_exited.connect(_clear_delay_preview)
	action_box.add_child(basic_btn)
	# Everything else lives in the Abilities dropdown. Built from real Buttons
	# (not a PopupMenu) so hovering each entry previews its initiative cost —
	# PopupMenu only reports focus from keyboard navigation, not the mouse.
	var menu_btn := Button.new()
	menu_btn.text = "Abilities ▾"
	menu_btn.custom_minimum_size = Vector2(90, 32)
	menu_btn.add_theme_font_size_override("font_size", 13)
	var popup := PopupPanel.new()
	_open_popups.append(popup)
	popup.window_input.connect(_on_popup_window_input)
	_main_popup = popup
	_main_popup_anchor = menu_btn
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 4)
	popup.add_child(list)
	for e_idx in range(1, _menu_entries.size()):
		var entry: Dictionary = _menu_entries[e_idx]
		if entry.has("summons"):
			# Top of the list: opens the beast picker (Tab cycles, Space picks).
			var group_btn := Button.new()
			group_btn.text = "[%s] Summon Companion ▸" % ABILITY_KEY_NAMES[e_idx]
			group_btn.custom_minimum_size = Vector2(184, 30)
			group_btn.add_theme_font_size_override("font_size", 13)
			group_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			group_btn.tooltip_text = "Choose which beast answers the call.\n" \
				+ "Tab cycles the options, Space summons.\nOnly one companion at a time."
			group_btn.pressed.connect(_on_summon_group_pressed.bind(popup))
			list.add_child(group_btn)
		else:
			list.add_child(_ability_popup_button(u, entry["ability"], popup, e_idx))
	popup.popup_hide.connect(_clear_delay_preview)
	menu_btn.add_child(popup)
	menu_btn.pressed.connect(_open_ability_popup.bind(popup, menu_btn))
	action_box.add_child(menu_btn)
	action_box.add_child(_build_items_menu())
	# Mercy (Holy Cleric): the Empower toggle arms the next supporting cast
	# for +1 stack. Empowered casts forgo their perfect bonus.
	if u.second_resource_name == "Mercy":
		var emp_btn := Button.new()
		emp_btn.toggle_mode = true
		emp_btn.button_pressed = empower_armed
		emp_btn.text = "✦ Empower (C)"
		emp_btn.custom_minimum_size = Vector2(112, 32)
		emp_btn.add_theme_font_size_override("font_size", 13)
		emp_btn.disabled = u.second_resource < 1
		emp_btn.tooltip_text = "Spend +1 Mercy to Empower the next\nHeal / Renewal / Hymn / Resurrection /\nDivine Plea. Empowered casts forgo\ntheir perfect bonus. C toggles."
		emp_btn.toggled.connect(func(on: bool): empower_armed = on)
		action_box.add_child(emp_btn)
	action_panel.visible = true


# One place decides "can this ability be picked right now" so the buttons
# and the hotkeys can never disagree.
func _ability_usable(u: BattleUnit, ab: Ability) -> bool:
	if ab.cost > u.resource or ab.faith_cost > u.second_resource:
		return false
	if not u.ability_ready(ab):
		return false
	if ab.special == "kill_command" and (u.companion == null or u.companion.dead):
		return false
	if ab.special == "resurrection" and not heroes.any(func(h): return h.dead):
		return false
	# Execute: only usable while an enemy is below 20% health.
	if ab.display_name == "Execute" \
			and not enemies.any(func(e): return not e.dead and e.hp < e.max_hp * 0.2):
		return false
	# Shatter: needs someone Chilled to detonate.
	if ab.display_name == "Shatter" \
			and not enemies.any(func(e): return not e.dead and e.has_status("chilled")):
		return false
	# Stabilize: nothing to consume without a stack banked.
	if ab.special == "stabilize" and u.second_resource < 1:
		return false
	# Overcharge: the limit only breaks once per battle.
	if ab.special == "overcharge" and u.overcharged:
		return false
	return true


# One entry in the abilities popup: hotkey + label with cost, tooltip, preview.
# `key_idx` is the entry's position in _menu_entries (= its hotkey slot).
func _ability_popup_button(u: BattleUnit, ab: Ability, popup: PopupPanel,
		key_idx := -1) -> Button:
	var label: String = ab.display_name
	if key_idx >= 0 and key_idx < ABILITY_KEY_NAMES.size():
		label = "[%s] %s" % [ABILITY_KEY_NAMES[key_idx], label]
	if ab.cost > 0:
		label += "   %d %s" % [ab.cost, u.resource_name]
	elif ab.faith_cost > 0:
		label += "   %d %s" % [ab.faith_cost, u.second_resource_name]
	if u.cooldown_left(ab) > 0:
		label += "   (CD %d)" % u.cooldown_left(ab)
	var ab_btn := Button.new()
	ab_btn.text = label
	ab_btn.custom_minimum_size = Vector2(184, 30)
	ab_btn.add_theme_font_size_override("font_size", 13)
	ab_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	ab_btn.tooltip_text = _ability_tooltip(u, ab)
	if ab.special == "kill_command" and (u.companion == null or u.companion.dead):
		ab_btn.tooltip_text += "\n(No living companion)"
	if ab.special == "resurrection" and not heroes.any(func(h): return h.dead):
		ab_btn.tooltip_text += "\n(No fallen allies)"
	if ab.special == "stabilize" and u.second_resource < 1:
		ab_btn.tooltip_text += "\n(Requires at least 1 Resonance)"
	if ab.special == "overcharge" and u.overcharged:
		ab_btn.tooltip_text += "\n(Already Overcharged)"
	ab_btn.disabled = not _ability_usable(u, ab)
	ab_btn.pressed.connect(_on_popup_ability.bind(popup, ab))
	ab_btn.mouse_entered.connect(_preview_delay.bind(u, ab))
	ab_btn.mouse_exited.connect(_clear_delay_preview)
	return ab_btn


# Opens the ability list just above its anchor button.
func _open_ability_popup(popup: PopupPanel, anchor: Button) -> void:
	popup.popup()
	popup.position = Vector2i(int(anchor.global_position.x),
		int(anchor.global_position.y) - popup.size.y - 6)


# ---------- summon picker (Tab cycles, Space summons, X closes) ----------

var _summon_picker: PanelContainer = null
var _summon_opts: Array = []
var _summon_btns: Array = []
var _summon_idx := -1


func _on_summon_group_pressed(popup: PopupPanel) -> void:
	popup.hide()
	if current_hero != null:
		_open_summon_picker(current_hero)


func _open_summon_picker(u: BattleUnit) -> void:
	_close_summon_picker()
	_summon_opts = u.abilities.filter(func(a): return a.special == "summon")
	if _summon_opts.is_empty():
		return
	_summon_picker = PanelContainer.new()
	_summon_picker.position = Vector2(480, 420)
	ui.add_child(_summon_picker)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	_summon_picker.add_child(box)
	var title := Label.new()
	title.text = "SUMMON —  Tab cycles · Space summons · X closes"
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(0.85, 0.80, 0.68))
	box.add_child(title)
	_summon_btns = []
	for i in _summon_opts.size():
		var ab: Ability = _summon_opts[i]
		var b := Button.new()
		b.text = "%s   %d %s" % [ab.display_name, ab.cost, u.resource_name]
		b.custom_minimum_size = Vector2(256, 32)
		b.add_theme_font_size_override("font_size", 13)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.tooltip_text = _ability_tooltip(u, ab)
		b.disabled = not _ability_usable(u, ab)
		b.focus_mode = Control.FOCUS_NONE  # highlight is drawn, not focus-based
		b.pressed.connect(_confirm_summon.bind(i))
		b.mouse_entered.connect(_preview_delay.bind(u, ab))
		b.mouse_exited.connect(_clear_delay_preview)
		box.add_child(b)
		_summon_btns.append(b)
	_summon_idx = -1
	_cycle_summon()  # land on the first affordable beast


func _close_summon_picker() -> void:
	if _summon_picker != null and is_instance_valid(_summon_picker):
		_summon_picker.queue_free()
	_summon_picker = null
	_summon_opts = []
	_summon_btns = []
	_summon_idx = -1


func _cycle_summon() -> void:
	if _summon_btns.is_empty():
		return
	for step in _summon_btns.size():
		_summon_idx = (_summon_idx + 1) % _summon_btns.size()
		if not _summon_btns[_summon_idx].disabled:
			break
	for i in _summon_btns.size():
		_summon_btns[i].modulate = Color(1.0, 0.92, 0.55) if i == _summon_idx \
			else Color(1, 1, 1)
	if current_hero != null and _summon_idx >= 0:
		_preview_delay(current_hero, _summon_opts[_summon_idx])


func _confirm_summon(i: int) -> void:
	if i < 0 or i >= _summon_opts.size() or current_hero == null:
		return
	var ab: Ability = _summon_opts[i]
	if not _ability_usable(current_hero, ab):
		return
	_on_ability_button(ab)  # closes the picker via the shared pick funnel


var _preview_locked := false
var second_target: BattleUnit = null  # choose_two abilities (Shrapnel)
var _open_popups: Array = []  # ability popups to close when a hotkey fires
var _main_popup: PopupPanel   # the Abilities list (Tab toggles it)
var _main_popup_anchor: Button
# Hotkey slots for the current hero: {"ability": Ability} or {"summons": [...]}.
var _menu_entries: Array = []
# Keyboard targeting: Tab cycles the candidates, Space/Enter confirms.
var _kb_pool: Array = []
var _kb_idx := -1


func _preview_delay(u: BattleUnit, ab: Ability) -> void:
	if not _preview_locked:
		_rebuild_turn_bar(u, ab)


func _clear_delay_preview() -> void:
	if not _preview_locked:
		_rebuild_turn_bar()


func _on_ability_button(ab: Ability) -> void:
	_close_summon_picker()
	_close_item_picker()
	_sfx("click", -12.0)
	_ability_picked.emit(ab)


func _on_popup_ability(popup: PopupPanel, ab: Ability) -> void:
	popup.hide()
	_on_ability_button(ab)


# Tooltip with live damage ranges (includes the unit's current buffs).
func _ability_tooltip(u: BattleUnit, ab: Ability) -> String:
	var tip := ab.description
	if ab.cooldown > 0:
		tip += "\nCooldown: %d turns" % ab.cooldown
		var left := u.cooldown_left(ab)
		if left > 0:
			tip += "  (ready in %d)" % left
	if ab.damage > 0:
		var buff_mult := 1.0
		if u.second_resource_name == "Resonance":
			buff_mult *= 1.0 + 0.15 * _resonance_power(u)
		if u.has_status("surge"):
			buff_mult *= 1.2
		if u.has_status("empower"):
			buff_mult *= 1.25
		# Live numbers: the ability's % of this unit's current Attack.
		var base_hit := ab.damage * 0.01 * u.attack
		tip += "\nDamage: %d–%d (%s)    BD: %d" % [
			int(base_hit * 0.9 * buff_mult), int(round(base_hit * 1.1 * buff_mult)),
			ab.dmg_type.capitalize(), ab.pressure]
		if ab.random_hits > 0 or ab.multi_hits > 0:
			tip += "   × %d hits" % maxi(ab.random_hits, ab.multi_hits)
	if ab.heal > 0:
		tip += "\nHeals: %d" % ab.heal
	tip += "\nInitiative cost: %.1f" % ab.delay
	if ab.perfect_text != "":
		tip += "\nPerfect: %s" % ab.perfect_text
	return tip


# The Items button opens the same picker Alt does (one item per hero per turn).
func _build_items_menu() -> Button:
	var btn := Button.new()
	btn.text = "[Alt] Items"
	btn.custom_minimum_size = Vector2(76, 32)
	btn.add_theme_font_size_override("font_size", 13)
	btn.disabled = item_used
	btn.tooltip_text = "Already used an item this turn." if item_used \
		else "Shared party inventory.\nAlt opens · Tab cycles · Space uses · X closes."
	btn.pressed.connect(_open_item_picker)
	return btn


# ---------- item picker (Alt opens, Tab cycles, Space uses, X closes) ----------

var _item_picker: PanelContainer = null
var _item_btns: Array = []
var _item_ids: Array = []
var _item_idx := -1


func _open_item_picker() -> void:
	if current_hero == null or not action_panel.visible or item_used:
		return
	_close_summon_picker()
	_close_item_picker()
	_item_picker = PanelContainer.new()
	_item_picker.position = Vector2(500, 430)
	ui.add_child(_item_picker)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	_item_picker.add_child(box)
	var title := Label.new()
	title.text = "ITEMS —  Tab cycles · Space uses · X closes"
	title.add_theme_font_size_override("font_size", 10)
	title.add_theme_color_override("font_color", Color(0.85, 0.80, 0.68))
	box.add_child(title)
	_item_btns = []
	_item_ids = []
	for id in Run.ITEM_IDS:
		var entry: Array = items[id]
		var b := Button.new()
		b.text = "%s  x%d" % [entry[0], entry[1]]
		b.custom_minimum_size = Vector2(232, 30)
		b.add_theme_font_size_override("font_size", 12)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.tooltip_text = "%s\nDoes not consume the turn." % entry[2]
		var usable: bool = entry[1] > 0
		if id == "revive":
			usable = usable and heroes.any(func(h): return h.dead)
		b.disabled = not usable
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(_confirm_item.bind(_item_ids.size()))
		box.add_child(b)
		_item_btns.append(b)
		_item_ids.append(id)
	_item_idx = -1
	_cycle_item()


func _close_item_picker() -> void:
	if _item_picker != null and is_instance_valid(_item_picker):
		_item_picker.queue_free()
	_item_picker = null
	_item_btns = []
	_item_ids = []
	_item_idx = -1


func _cycle_item() -> void:
	if _item_btns.is_empty() or _item_btns.all(func(b): return b.disabled):
		return
	for step in _item_btns.size():
		_item_idx = (_item_idx + 1) % _item_btns.size()
		if not _item_btns[_item_idx].disabled:
			break
	for i in _item_btns.size():
		_item_btns[i].modulate = Color(1.0, 0.92, 0.55) if i == _item_idx \
			else Color(1, 1, 1)


func _confirm_item(i: int) -> void:
	if i < 0 or i >= _item_ids.size() or _item_btns[i].disabled:
		return
	var id: String = _item_ids[i]
	_close_item_picker()
	_use_item(id)


func _pick_target(pool: Array) -> BattleUnit:
	for t in pool:
		t.set_targetable(true)
	# Tab cycles through the pool, Space/Enter confirms (see _input).
	_kb_pool = pool
	_kb_idx = -1
	var cancel := Button.new()
	cancel.text = "✕ Cancel (X)"
	cancel.custom_minimum_size = Vector2(104, 32)
	cancel.add_theme_font_size_override("font_size", 12)
	cancel.position = Vector2(588, 568)
	cancel.pressed.connect(func(): _target_picked.emit(null))
	ui.add_child(cancel)
	var chosen: BattleUnit = await _target_picked
	_kb_pool = []
	_kb_idx = -1
	for t in pool:
		t.set_targetable(false)
		t.set_highlight(false)
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
		# Maddened units ATTACK their allies — support abilities stay sheathed.
		var mf_options: Array = u.abilities.filter(
			func(a): return a.cost <= u.resource and a.damage > 0)
		if not fellows.is_empty() and not mf_options.is_empty():
			var mf_target: BattleUnit = fellows.pick_random()
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
	# Only damaging, off-cooldown abilities count as attacks; support casts
	# are chosen above.
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
		# Threatening Presence: Warriors draw 20% more of the random picks.
		target = _lowest_hp(living) if randf() < 0.40 else _threat_pick(living)
		ab = affordable.pick_random()
	await _resolve(u, ab, target, "good")


# Weighted random target: Warriors weigh 1.2, everyone else 1.0.
func _threat_pick(pool: Array) -> BattleUnit:
	var total := 0.0
	for t in pool:
		total += 1.2 if t.hero_key == "warrior" else 1.0
	var roll := randf() * total
	for t in pool:
		roll -= 1.2 if t.hero_key == "warrior" else 1.0
		if roll <= 0.0:
			return t
	return pool.back()


# Non-attack decisions for enemies with support abilities. Returns
# [ability, ally_target], or [] to fall through to a normal attack.
func _enemy_support_action(u: BattleUnit) -> Array:
	var allies: Array = enemies.filter(func(e): return not e.dead)
	# (Enemies don't use cooldowns — their support casts are gated by the
	# conditions below and by resources alone.)
	# Shaman: Healing Wave the most wounded ally under 40% health —
	# friendly tanks and healers first.
	var wave := _find_ability(u, "Healing Wave")
	if wave != null:
		var hurt: Array = allies.filter(func(a): return a.hp < a.max_hp * 0.40)
		if not hurt.is_empty():
			var prio: Array = hurt.filter(
				func(a): return a.enemy_role in ["tank", "support"])
			return [wave, _lowest_hp(prio if not prio.is_empty() else hurt)]
	# Shieldmaster: always keeps exactly one ally Shielded (lowest HP first).
	var shield_ab := _find_ability(u, "Shielding")
	if shield_ab != null \
			and not allies.any(func(a): return a.has_status("shielded")):
		return [shield_ab, _lowest_hp(allies)]
	# Withered Warden: tends the most wounded of its warband (itself included).
	var growth := _find_ability(u, "Wild Growth")
	if growth != null:
		var wounded: Array = allies.filter(func(a): return a.hp < a.max_hp * 0.7)
		if not wounded.is_empty() and randf() < 0.6:
			return [growth, _lowest_hp(wounded)]
	return []


# Dominant Presence bookkeeping: the Swordmaster's armor feeds on the
# debuffs he lands.
func _note_debuff_applied(source: BattleUnit, status_id: String) -> void:
	if source != null and source.dominant_ranks > 0 \
			and BattleUnit.DEBUFF_IDS.has(status_id):
		source.debuffs_applied += 1
		_log("   → Talent: Dominant Presence — %s's armor +%d%% (%d debuff%s landed)" % [
			source.unit_name, 5 * source.dominant_ranks * source.debuffs_applied,
			source.debuffs_applied, "" if source.debuffs_applied == 1 else "s"],
			"#b0a8e0")


func _lowest_hp(pool: Array) -> BattleUnit:
	var best: BattleUnit = pool[0]
	for h in pool:
		if h.hp / float(h.max_hp) < best.hp / float(best.max_hp):
			best = h
	return best


# Highest rank of a talent stat among LIVING heroes (party-wide talents
# like Hypothermia, Brittle Ice, Hungering Cold, Frigid Grip).
func _max_hero_rank(field: String) -> int:
	var best := 0
	for h in heroes:
		if not h.dead:
			best = maxi(best, int(h.get(field)))
	return best


# ADJACENT (keyword): the enemies DIRECTLY beside the target in formation
# order. A dead neighbor NEGATES the adjacent bonus on that side — the
# effect never jumps past a corpse to the next living enemy. Used by
# splash effects (Sundering, Wildfire).
func _adjacent_enemies(target: BattleUnit) -> Array:
	var idx := enemies.find(target)
	if idx < 0:
		return []
	var adjacent: Array = []
	if idx > 0 and not enemies[idx - 1].dead:
		adjacent.append(enemies[idx - 1])
	if idx + 1 < enemies.size() and not enemies[idx + 1].dead:
		adjacent.append(enemies[idx + 1])
	return adjacent


# Base chances for the attack rolls. Many things will modify these later.
const MISS_CHANCE := 0.05
const PARRY_CHANCE := 0.05        # hero baseline
const ENEMY_PARRY_CHANCE := 0.025 # enemy baseline (half the hero rate)
const CRIT_CHANCE := 0.10


func _miss_chance(attacker: BattleUnit) -> float:
	return MISS_CHANCE + (0.20 if attacker.has_status("dazed") else 0.0)


# One parry roll, attributed to the slice it landed in so the log can name
# the source: base reflexes, the Sword Mastery talent, or the perfect-Pommel
# Parry Up buff (deepened by Swordsmanship). "" = no parry.
func _roll_parry(defender: BattleUnit) -> String:
	var base := PARRY_CHANCE if defender.is_hero else ENEMY_PARRY_CHANCE
	var talent := defender.parry_bonus
	var buff := ((0.15 + defender.pommel_parry_bonus)
		if defender.has_status("parry_up") else 0.0)
	var roll := randf()
	if roll < base:
		return "reflexes"
	if roll < base + talent:
		return "Sword Mastery"
	if roll < base + talent + buff:
		return "Parry Up"
	return ""


# Bow users get dedicated attack/impact/blocked sounds. Keyed on the class
# id, not the display name — specced heroes are named after their spec.
func _uses_bow(u: BattleUnit) -> bool:
	return u.hero_key == "hunter" or u.unit_name.begins_with("Orc Archer")


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
	if not is_counter and not debug_cooldowns_off:
		attacker.start_cooldown(ab)
	var dmg_mult := {"perfect": 1.15, "good": 1.0, "fail": 0.6}[grade] as float
	var pr_mult := {"perfect": 1.25, "good": 1.0, "fail": 0.5}[grade] as float
	var is_perfect := grade == "perfect"
	# Shatter perfect: the echo of the blast comes back sooner (4cd).
	if is_perfect and ab.display_name == "Shatter" and not debug_cooldowns_off:
		attacker.cooldowns[ab.display_name] = 5  # 4 + the same-turn tick

	# Move toward the target so attacks visibly connect (specials stay put):
	# units with real locomotion art WALK to melee range; the rest do the
	# short abstract lunge.
	var lunge_origin := attacker.position
	var walked := false
	if not sim and ab.special == "" and target != attacker:
		if attacker.walks_to_target and ab.heal == 0 and target != null:
			walked = true
			var stand := target.position \
				+ (attacker.position - target.position).normalized() * 95.0
			await _walk_to(attacker, stand)
		else:
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

	# faith_cost = the secondary-resource price (Mercy for the Holy Cleric).
	# Sanctified (talent): the spend can be refunded outright.
	if ab.faith_cost > 0:
		if attacker.sanctified_ranks > 0 \
				and randf() < 0.10 * attacker.sanctified_ranks:
			attacker.float_text("Mercy preserved", Color(0.95, 0.8, 0.3))
			_log("   → Talent: Sanctified — the Mercy is not consumed", "#b0a8e0")
		else:
			attacker.second_resource = maxi(attacker.second_resource - ab.faith_cost, 0)
		attacker.refresh_bars()
	# Holy Light (talent): every perfect cast drips Mana back.
	if grade == "perfect" and attacker.holy_light_ranks > 0 \
			and attacker.resource_name == "Mana":
		var hl_mana := maxi(int(round(attacker.max_resource
			* 0.01 * attacker.holy_light_ranks)), 1)
		attacker.resource = mini(attacker.resource + hl_mana, attacker.max_resource)
		attacker.float_text("+%d Mana" % hl_mana, Color(0.5, 0.7, 1.0))
		_log("   → Talent: Holy Light — %s restores %d Mana" % [
			attacker.unit_name, hl_mana], "#b0a8e0")
		attacker.refresh_bars()

	var grade_tag := {"perfect": " [PERFECT]", "good": "", "fail": " [Sloppy]"}[grade] as String
	if ab.special != "":
		await _resolve_special(attacker, ab, target, grade, dmg_mult)
	elif ab.heal > 0:
		var amount := int(ab.heal * dmg_mult)
		_stat("healing", amount)
		_sfx("heal", -8.0)
		target.heal_amount(amount, target != attacker)
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
		await _try_opportunist(target, attacker)
	else:
		var strike_targets: Array = [target]
		if ab.aoe:
			strike_targets = enemies.filter(func(t): return not t.dead) \
				if attacker.is_hero else _hero_side()
			# Shatter only detonates the Chilled.
			if ab.display_name == "Shatter":
				strike_targets = strike_targets.filter(
					func(t): return t.has_status("chilled"))
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
		# Firestorm: 6-8 bolts from the sky (7-9 on a perfect).
		if ab.display_name == "Firestorm":
			total_hits = randi_range(6, 8) + (1 if is_perfect else 0)
		# Splintering Shards: Razor Ice can find one more victim.
		if ab.display_name == "Razor Ice" and attacker.splinter_ranks > 0 \
				and randf() < 0.20 * attacker.splinter_ranks:
			total_hits += 1
			_log("Talent: Splintering Shards — Razor Ice splinters again!", "#b0a8e0")
		var total_dealt := 0
		var enemies_struck := 0  # landed strikes (Magi's Wrath recoil fades per hit)
		var struck_before: BattleUnit = null  # last random-hit victim (Explosion)
		var any_crit := false
		for hit_i in total_hits:
			var strike_target: BattleUnit
			if ab.random_hits > 0:
				# Each shard picks a fresh living target at launch time.
				var live_pool: Array = enemies.filter(func(t): return not t.dead) \
					if attacker.is_hero else _hero_side()
				if live_pool.is_empty():
					break
				# Arcane Barrage hounds the weakest: every bolt picks among the
				# (up to) 3 living enemies with the lowest health.
				if ab.display_name == "Arcane Barrage" and live_pool.size() > 3:
					live_pool.sort_custom(func(a, b): return a.hp < b.hp)
					live_pool = live_pool.slice(0, 3)
				# Arcane Explosion: the two blasts land on DISTINCT enemies
				# whenever two still stand.
				if ab.display_name == "Arcane Explosion" and hit_i > 0 \
						and live_pool.size() > 1 and struck_before != null:
					live_pool = live_pool.filter(func(t): return t != struck_before)
				strike_target = live_pool.pick_random()
				struck_before = strike_target
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
					await _try_opportunist(strike_target, attacker)
					if attacker.dead:
						break
					continue
			# Block: negates 100% of the hit — damage, Break damage, and on-hit
			# effects. Sources (logged): Shieldwall charges (guaranteed), the
			# base Block stat, or Heavy Plating. Broken units cannot Block.
			if not is_counter and not strike_target.broken and not strike_target.dead \
					and not strike_target.is_companion:
				var block_source := ""
				var charges := strike_target.get_status("shield_charges")
				if not charges.is_empty() and int(charges.get("power", 0)) > 0:
					block_source = "Shieldwall"
					charges["power"] = int(charges["power"]) - 1
					var charges_left := int(charges["power"])
					if charges_left <= 0:
						strike_target.remove_status("shield_charges")
					else:
						# The chip counts down the blocks still owed.
						strike_target.update_status("shield_charges",
							"SW%d" % charges_left,
							"Shieldwall: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % charges_left)
				else:
					# One roll, attributed to whichever slice it landed in.
					var plating := 0.15 if strike_target.passive_id == "heavy_plating" else 0.0
					var block_roll := randf()
					if block_roll < strike_target.block_chance:
						block_source = "base Block"
					elif block_roll < strike_target.block_chance + plating:
						block_source = "Heavy Plating"
				if block_source != "":
					_stat("attacks")
					_stat("attack_block")
					_sfx("parry", -4.0, 0.6)
					strike_target.float_text("BLOCK", Color(0.75, 0.8, 0.95))
					_log("%s BLOCKS %s's %s (%s)" % [strike_target.unit_name,
						attacker.unit_name, ab.display_name, block_source], "#8c9cc8")
					# Unkillable: blocking mends the Warden.
					if strike_target.unkillable_ranks > 0:
						var mend := maxi(int(strike_target.max_hp * 0.02
							* strike_target.unkillable_ranks), 1)
						strike_target.heal_amount(mend)
						strike_target.float_text("+%d" % mend, Color(0.4, 0.9, 0.45))
						_log("   → Talent: Unkillable — %s mends %d" % [
							strike_target.unit_name, mend], "#b0a8e0")
					# Richocet: the shield answer can ring the attacker's skull.
					if strike_target.ricochet_ranks > 0 and not attacker.dead \
							and randf() < 0.05 * strike_target.ricochet_ranks:
						_log("   → Talent: Richocet — the block staggers %s" % \
							attacker.unit_name, "#b0a8e0")
						_apply_status(attacker, "stunned", 1)
					# Tenacity / Rally feed on Heavy Plating blocks alone.
					if block_source == "Heavy Plating":
						if strike_target.tenacity > 0:
							strike_target.max_hp += 5
							strike_target.tenacity_hp_gained += 5
							strike_target.refresh_bars()
							strike_target.float_text("+5 Max HP", Color(0.55, 0.9, 0.6))
							_log("   → Talent: Tenacity — %s toughens (+5 max HP)" % \
								strike_target.unit_name, "#b0a8e0")
						if strike_target.rally > 0:
							var rinfo: Array = STATUS_INFO["rally_heal"]
							for h in heroes:
								if not h.dead:
									h.add_status("rally_heal", rinfo[0], rinfo[1],
										rinfo[2], 2, rinfo[3])
							_log("   → Talent: Rally — the party is Rallied (+15% healing, 2 turns)",
								"#b0a8e0")
					await _wait(0.4)
					continue
			# Parry: the strike still lands, but with 75% less damage and 75%
			# less Break damage. ONLY MELEE attacks can be parried — bows and
			# spells (is_ranged attackers) sail past the blade. No automatic
			# counter — that is the separate Counter Attack effect. AoE cannot
			# be parried; Broken units cannot parry. The roll's source
			# (reflexes / Sword Mastery / Parry Up) is logged.
			var parry_source := ""
			if not is_counter and not ab.aoe and not attacker.is_ranged \
					and not strike_target.broken \
					and not strike_target.dead and not strike_target.is_companion:
				parry_source = _roll_parry(strike_target)
			var parried := parry_source != ""
			if parried:
				_stat("attack_parry")
				_sfx("parry", -4.0)
				strike_target.float_text("PARRY", Color(0.4, 0.9, 1.0))
				# High Guard: a parry hardens the stance for a turn.
				if strike_target.high_guard > 0:
					_apply_status(strike_target, "high_guard", 2)
			# Pommel Strike carries its own keen 25% crit base.
			var crit_chance := (0.25 if ab.display_name == "Pommel Strike" else CRIT_CHANCE) \
				+ (0.25 if strike_target.broken else 0.0)
			# Resonant Mind: +3% crit per Resonance stack (Arcane Mastery
			# deepens it by +1%/rank; Overcharge weights stacks 6-8).
			if attacker.second_resource_name == "Resonance":
				crit_chance += (0.03 + 0.01 * attacker.arcane_mastery_ranks) \
					* _resonance_power(attacker)
			crit_chance += attacker.crit_bonus
			# Pack Bond (Aguila): the eagle sharpens the hunter's eye.
			if attacker.passive_id == "pack" and attacker.companion != null \
					and not attacker.companion.dead \
					and attacker.companion.companion_kind == "aguila":
				crit_chance += 0.15
			# Precision Strikes: exploits Dazed / Crippled / Exposed targets.
			if attacker.precision_ranks > 0 and (strike_target.has_status("dazed")
					or strike_target.has_status("cripple")
					or strike_target.has_status("exposed")):
				crit_chance += 0.05 * attacker.precision_ranks
			# Seasoned Fighter (talent node): sharpens Lunge and Overpower.
			if attacker.blade_crit_ranks > 0 \
					and ab.display_name in ["Lunge", "Overpower"]:
				crit_chance += 0.03 * attacker.blade_crit_ranks
			# Super Nova: Detonation crits harder into the ash.
			if attacker.supernova_ranks > 0 and ab.display_name == "Detonation":
				crit_chance += 0.03 * attacker.supernova_ranks
			# Brittle Ice (talent): Frozen targets are easier to strike true.
			if strike_target.has_status("frozen"):
				crit_chance += 0.02 * _max_hero_rank("frostbite_ranks")
			if is_perfect and ab.display_name == "Aimed Shot":
				crit_chance += 0.25
			# Sweeping Strikes perfect: the second swing cuts truer.
			if is_perfect and ab.display_name == "Sweeping Strikes" and hit_i == 1:
				crit_chance += 0.25
			var is_crit := randf() < crit_chance
			# Ice Lance: always crits against Frozen targets.
			if ab.display_name == "Ice Lance" and strike_target.has_status("frozen"):
				is_crit = true
			# Execute perfect: the killing stroke cannot glance.
			if is_perfect and ab.display_name == "Execute":
				is_crit = true
			any_crit = any_crit or is_crit
			# Ability damage is a PERCENT of the attacker's current Attack.
			var raw := ab.damage * 0.01 * attacker.attack * randf_range(0.9, 1.1) * dmg_mult
			if parried:
				raw *= 0.25
			if is_crit:
				var crit_mult := 2.0 if attacker.passive_id == "lethal_aim" else 1.5
				# Piercing Ice: the lance drives deeper on a crit.
				if ab.display_name == "Ice Lance":
					crit_mult += 0.10 * attacker.piercing_ice_ranks
				raw *= crit_mult
				# Critical Mass: every 3rd crit detonates harder and pays Mana.
				if attacker.critical_mass_ranks > 0:
					attacker.crit_streak += 1
					if attacker.crit_streak >= 3:
						attacker.crit_streak = 0
						raw *= 1.0 + 0.20 * attacker.critical_mass_ranks
						var cm_mana := int(round(attacker.max_resource
							* 0.10 * attacker.critical_mass_ranks))
						attacker.resource = mini(attacker.resource + cm_mana,
							attacker.max_resource)
						attacker.float_text("+%d Mana" % cm_mana, Color(0.5, 0.7, 1.0))
						attacker.refresh_bars()
						_log("   → Talent: Critical Mass — +%d%% damage, +%d Mana" % [
							20 * attacker.critical_mass_ranks, cm_mana], "#b0a8e0")
			# Attacker-side modifiers.
			if attacker.second_resource_name == "Resonance":
				raw *= 1.0 + 0.15 * _resonance_power(attacker)
			if attacker.has_status("surge"):
				raw *= 1.2
			if attacker.has_status("wrath"):
				raw *= 1.15
			# Blessing of Zeal: kindled allies strike harder.
			if attacker.has_status("zeal"):
				raw *= 1.15
			# Conviction: each Faith stack sharpens the blade (+2% base,
			# Unwavering Faith deepens it) — while the Devout stands.
			if attacker.is_hero and attacker.faith_stacks > 0:
				var f_dev := _living_devout()
				if f_dev != null:
					raw *= 1.0 + (0.02 + 0.005 * f_dev.unwavering_ranks) \
						* attacker.faith_stacks
			# Arcane Cannon: the damage (not the recoil) grows with Resonance.
			if ab.display_name == "Arcane Cannon":
				raw *= 1.0 + 0.075 * attacker.second_resource
			# Magi's Wrath: the storm feeds on banked Resonance.
			if ab.display_name == "Magi's Wrath":
				raw *= 1.0 + 0.04 * attacker.second_resource
			# Suppressing Fire: every Barrage bolt bites harder than the last.
			if ab.display_name == "Arcane Barrage" and attacker.suppressing_ranks > 0 \
					and hit_i > 0:
				raw += 0.0025 * attacker.suppressing_ranks * hit_i * attacker.attack
			# Frostbolt / Razor Ice perfects: flat 25% of Attack instead.
			if is_perfect and ab.display_name in ["Frostbolt", "Razor Ice"]:
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Empowered Frostbolt (talent): the basic bolt bites deeper.
			if ab.display_name == "Frostbolt" and attacker.emp_frostbolt_ranks > 0:
				raw += 0.02 * attacker.emp_frostbolt_ranks * attacker.attack
			# Shatter: 10% of Attack PER Chilled stack on each victim.
			if ab.display_name == "Shatter":
				raw *= maxi(strike_target.status_stacks("chilled"), 1)
			# Icy Veins: a banked kill empowers this lance.
			if ab.display_name == "Ice Lance" and attacker.icy_veins_charge > 0.0:
				raw *= 1.0 + attacker.icy_veins_charge
			if is_perfect and ab.display_name == "Explosive Shot":
				raw = 0.12 * attacker.attack * randf_range(0.9, 1.1)
			# Fireball perfect: the bolt hits at 25% of Attack instead of 20%.
			if is_perfect and ab.display_name == "Fireball":
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Detonation: consumes the target's Burn — its remaining damage
			# (tick × turns left) joins this hit before mitigation.
			var detonated := 0
			if ab.display_name == "Detonation":
				var det := strike_target.get_status("burn")
				if not det.is_empty():
					detonated = int(det.get("tick", 6)) * maxi(int(det.turns), 0)
					raw += detonated
					strike_target.remove_status("burn")
			# Wildfire: remember the target's Burn before the hit — the
			# spread happens even if the blast finishes them.
			var wildfire_burn := {}
			if ab.display_name == "Wildfire":
				wildfire_burn = strike_target.get_status("burn").duplicate()
			# Powershot: +2% damage per 1% of the target's Break bar still EMPTY —
			# the Rush opener, strongest against untouched foes.
			if ab.display_name == "Powershot":
				raw *= 1.0 + 2.0 * (1.0 - clampf(
					strike_target.pressure / float(strike_target.stability), 0.0, 1.0))
			# Overpower: exploits instability — +0.5 damage per point of Break.
			if ab.display_name == "Overpower":
				raw += 0.5 * strike_target.pressure
			if attacker.has_status("empower"):
				raw *= 1.25
			# Inferno Master: the Pyromancer feeds on every fire still burning
			# (Pyromaniac deepens the per-enemy step).
			if attacker.passive_id == "inferno":
				var burning := 0
				for foe in enemies:
					if not foe.dead and foe.has_status("burn"):
						burning += 1
				raw *= 1.0 + 0.01 * (5 + attacker.pyromaniac_ranks) * mini(burning, 5)
			# Seeding Embers: a burning death fuels the next swing.
			if attacker.has_status("seeding"):
				raw *= 1.0 + attacker.status_power("seeding") / 100.0
			if attacker.has_status("cripple"):
				raw *= 0.75
			# Chilled x3: frozen muscles swing 15% softer. Hungering Cold
			# (talent) deepens the malus per stack.
			var atk_chill := attacker.status_stacks("chilled")
			if atk_chill >= 3:
				raw *= 0.85
			if atk_chill > 0:
				raw *= 1.0 - 0.01 * _max_hero_rank("hungering_ranks") * atk_chill
			# Blood Frenzy: +2% damage (plus Unstoppable) per 5% of HP missing.
			if attacker.passive_id == "bloodrage":
				var frenzy_steps := int((1.0 - attacker.hp / float(attacker.max_hp)) \
					* 100.0 / 5.0)
				raw *= 1.0 + (2.0 + attacker.bloodrage_step_bonus) * frenzy_steps / 100.0
			# Enraged (talent): stacks from dropping below half HP.
			if attacker.enraged_stacks > 0 and attacker.enraged_ranks > 0:
				raw *= 1.0 + 0.03 * attacker.enraged_ranks * attacker.enraged_stacks
			# Battle Shout: fury fed by the enemy party's open wounds (at cast).
			if attacker.has_status("battle_shout"):
				raw *= 1.0 + attacker.status_power("battle_shout") / 100.0
			# Iron Will: +5%/rank damage per debuff currently on the Warden.
			if attacker.iron_will_ranks > 0:
				raw *= 1.0 + 0.05 * attacker.iron_will_ranks * attacker.count_debuffs()
			# Seasoned Fighter: the offensive stance above half HP.
			if attacker.passive_id == "seasoned" and attacker.hp > attacker.max_hp * 0.5:
				raw *= 1.15 + attacker.seasoned_off_bonus
			raw *= 1.0 + attacker.dmg_bonus + float(attacker.type_dmg_bonus.get(ab.dmg_type, 0.0))
			# Target-side modifiers.
			if strike_target.second_resource_name == "Resonance":
				raw *= 1.0 + 0.05 * _resonance_power(strike_target)
			# Stabilized: grounded resonance blunts incoming blows.
			if strike_target.has_status("stabilized"):
				raw *= 1.0 - strike_target.status_power("stabilized") / 100.0
			# Consecrated Ground: holy footing blunts the blow.
			if strike_target.has_status("cons_ground"):
				raw *= 0.85
			# Conviction: each Faith stack turns the blade (3% base,
			# Unwavering Faith deepens it) — while the Devout stands.
			if strike_target.is_hero and strike_target.faith_stacks > 0:
				var ft_dev := _living_devout()
				if ft_dev != null:
					raw *= 1.0 - minf((0.03 + 0.005 * ft_dev.unwavering_ranks) \
						* strike_target.faith_stacks, 0.9)
			if strike_target.has_status("shieldwall"):
				raw *= 0.75
			# Shielded: the Orc Shieldmaster's single-ally ward.
			if strike_target.has_status("shielded"):
				raw *= 0.75
			if strike_target.has_status("exposed"):
				raw *= 1.15
			# High Guard: hardened stance after a parry.
			if strike_target.has_status("high_guard"):
				raw *= 0.75
			if strike_target.dmg_taken_bonus > 0.0:
				raw *= 1.0 + strike_target.dmg_taken_bonus
			# Seasoned Fighter: the defensive stance at or below half HP.
			if strike_target.passive_id == "seasoned" \
					and strike_target.hp <= strike_target.max_hp * 0.5:
				raw *= 0.85 - strike_target.seasoned_def_bonus
			# Molten Core: burning attackers bite softer on the Pyromancer.
			if strike_target.molten_ranks > 0 and attacker.has_status("burn"):
				raw *= 1.0 - 0.02 * strike_target.molten_ranks
			# Permafrost: Frozen enemies take 15% more from ALL sources.
			if strike_target.has_status("frozen") and heroes.any(
					func(h): return not h.dead and h.passive_id == "permafrost"):
				raw *= 1.15
			# Hypothermia (talent): the cold opens wounds wider.
			if not strike_target.is_hero and strike_target.has_status("chilled"):
				raw *= 1.0 + 0.01 * _max_hero_rank("hypothermia_ranks") \
					* strike_target.status_stacks("chilled")
			# Flame Shield: the fire barrier halves what gets through.
			if strike_target.has_status("flame_shield"):
				raw *= 0.5
			if debug_prints and attacker.second_resource_name == "Resonance":
				print("[DBG] %s attacks @%d stacks: base %d -> raw %.1f" % [
					attacker.unit_name, attacker.second_resource, ab.damage, raw])
			var resist := float(strike_target.resists.get(ab.dmg_type, 0.0))
			# Elemental Weakness: Crushing Blow strips non-physical resists.
			if ab.dmg_type != "physical" and strike_target.has_status("elem_weak"):
				resist -= strike_target.status_power("elem_weak") / 100.0
			# Mitigation is logged with its amounts: what the resist ate
			# (negative = a Weakness ADDED damage) and what armor blocked.
			var resist_cut := 0
			if resist != 0.0:
				resist_cut = int(round(raw * resist))
				raw *= 1.0 - resist
			# Armor Penetration: each % negates a % of the target's armor.
			# Crushing Blows (talent): pen scales with the enemy party's bleed.
			var pen := ab.armor_pierce + attacker.pierce_bonus
			if attacker.crushing_blows_ranks > 0:
				var party_bleed := 0
				for foe in enemies:
					if not foe.dead:
						party_bleed += foe.bleed_buildup
				pen += 0.03 * attacker.crushing_blows_ranks * int(party_bleed / 20.0)
			var effective_armor := strike_target.effective_armor() \
				* (1.0 - clampf(pen, 0.0, 1.0))
			if is_perfect and ab.display_name == "Arcane Rift":
				effective_armor = 0.0
			var final := maxi(int(round(raw * (1.0 - effective_armor))), 1)
			# Armor's share, kept consistent with the displayed final number.
			var armor_cut := maxi(int(round(raw)) - final, 0)
			var resonance_boosted: bool = attacker.second_resource_name == "Resonance" \
				and attacker.second_resource > 0
			var pr := int(round(ab.pressure * pr_mult * (1.5 if is_crit else 1.0)))
			# Arcane Cannon / Magi's Wrath: Break damage IS the banked Resonance
			# (5 / 2.5 BD per stack, in place of a flat pressure value).
			if ab.display_name == "Arcane Cannon":
				pr = int(round(5.0 * attacker.second_resource * pr_mult \
					* (1.5 if is_crit else 1.0)))
			if ab.display_name == "Magi's Wrath":
				pr = int(round(2.5 * attacker.second_resource * pr_mult \
					* (1.5 if is_crit else 1.0)))
			if parried:
				pr = int(round(pr * 0.25))
			if is_perfect and (ab.perfect_id == "pressure" or ab.aoe):
				pr = int(pr * 1.5)
			if is_perfect and ab.display_name == "Crushing Blow":
				pr += 5
			if is_perfect and ab.display_name == "Ice Lance":
				pr = 20
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
			enemies_struck += 1
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
			# On the Edge (talent): surviving a blow at the brink feeds the storm.
			if strike_target.is_hero and not result.died \
					and strike_target.on_edge_ranks > 0 \
					and strike_target.hp < strike_target.max_hp \
					* (0.20 + 0.05 * strike_target.on_edge_ranks):
				_log("   → Talent: On the Edge — %s draws power from the brink" % \
					strike_target.unit_name, "#b0a8e0")
				_gain_resonance(strike_target, 1)
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
			# Mitigation report: exact amounts eaten by resist and armor.
			var resist_tag := ""
			if resist_cut > 0:
				resist_tag = " (%s resist -%d)" % [ab.dmg_type, resist_cut]
			elif resist_cut < 0:
				# Weakness: the hit lands 25%+ harder — call it out loudly.
				resist_tag = " (WEAK! +%d)" % -resist_cut
				strike_target.float_text("WEAK!", Color(1.0, 0.55, 0.15))
			if armor_cut > 0:
				resist_tag += " (armor -%d)" % armor_cut
			if parried:
				resist_tag += " (parried -75%% — %s)" % parry_source
			_log("%s: %s on %s — %d %s dmg%s%s, +%d BD%s" % [attacker.unit_name,
				ab.display_name, strike_target.unit_name, final, ab.dmg_type,
				" CRIT" if is_crit else "", resist_tag, result.get("bd", pr), grade_tag],
				"#d8d2c4" if attacker.is_hero else "#e0a0a0")
			# Consecrated Ground: the holy footing bites back.
			if strike_target.has_status("cons_ground") and not attacker.is_hero \
					and not attacker.dead and final > 0:
				var reflect := maxi(int(round(final * 0.10)), 1)
				_log("   → Consecrated Ground reflects %d to %s" % [
					reflect, attacker.unit_name], "#c8b880")
				if attacker.take_tick_damage(reflect, "-%d Reflect" % reflect,
						Color(0.9, 0.82, 0.5)):
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
			# VAULTED — Echo passive (kept for future return):
			# if attacker.passive_id == "echo" and not result.died and randf() < 0.20:
			#     echo_dmg = max(int(final * 0.25), 1); strike again + "ECHO!" fanfare.
			# Umbral Sigil: the branded foe's pain echoes through its warband.
			if not strike_target.is_hero and final > 0 \
					and strike_target.has_status("umbral_sigil"):
				var echo := maxi(int(round(final * 0.5)), 1)
				var echoed := false
				for fellow in enemies:
					if fellow.dead or fellow == strike_target:
						continue
					echoed = true
					var echo_result: Dictionary = fellow.take_hit(echo, 0)
					fellow.float_text("-%d Sigil" % echo, Color(0.65, 0.35, 0.80))
					if echo_result.died:
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % fellow.unit_name)
						_log("† %s dies" % fellow.unit_name, "#e05050")
				if echoed:
					_log("   → Umbral Sigil echoes %d to the warband" % echo, "#b070d0")
			# Temporal Rift (talent): the crit tears a seam — an echo lashes out.
			if is_crit and attacker.is_hero and attacker.temporal_ranks > 0 \
					and randf() < 0.03 * attacker.temporal_ranks:
				var rift_pool := enemies.filter(func(e): return not e.dead)
				if not rift_pool.is_empty():
					var rift_t: BattleUnit = rift_pool.pick_random()
					var rift_dmg := maxi(int(round(final * 0.25)), 1)
					var rift_result: Dictionary = rift_t.take_hit(rift_dmg, 0)
					rift_t.float_text("-%d Rift" % rift_dmg, Color(0.7, 0.5, 1.0))
					_log("   → Talent: Temporal Rift — the crit echoes %d into %s" % [
						rift_dmg, rift_t.unit_name], "#b0a8e0")
					if rift_result.died:
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % rift_t.unit_name)
						_log("† %s dies" % rift_t.unit_name, "#e05050")
			if ab.delay_push > 0.0:
				strike_target.next_time += ab.delay_push * 100.0 / strike_target.effective_speed()
			var status_chance := ab.status_chance
			# Pommel Strike: a critical strike GUARANTEES the stun.
			if ab.display_name == "Pommel Strike" and is_crit:
				status_chance = 1.0
			if not result.died and not ab.applies_status.is_empty() \
					and randf() <= status_chance:
				var turns: int = ab.applies_status["turns"]
				if is_perfect and ab.perfect_id == "status_plus":
					turns = 4
				var status_meta := 0
				if ab.applies_status["id"] == "burn":
					status_meta = int(round((CRIT_CHANCE + attacker.crit_bonus) * 100))
				_apply_status(strike_target, ab.applies_status["id"], turns, status_meta,
					_dot_tick(ab.applies_status["id"], attacker))
				_note_debuff_applied(attacker, ab.applies_status["id"])
			# Lunge: the stance decides the wound — Exposed high, Cripple low.
			if ab.display_name == "Lunge" and not strike_target.dead:
				var lunge_status := "exposed" if attacker.hp > attacker.max_hp * 0.5 \
					else "cripple"
				_apply_status(strike_target, lunge_status, 3)
				_note_debuff_applied(attacker, lunge_status)
			# Crushing Blow (Warden talents): resist shred + BD splash.
			if ab.display_name == "Crushing Blow" and not strike_target.dead \
					and attacker.elem_weak_ranks > 0:
				var shred := 5 * attacker.elem_weak_ranks
				_apply_status(strike_target, "elem_weak", 3, shred)
				# The chip carries the talent-scaled number.
				strike_target.update_status("elem_weak", "-%d%%" % shred,
					"Elemental Weakness: all non-physical\nresistances reduced by %d%%." % shred,
					shred)
				_note_debuff_applied(attacker, "elem_weak")
			if ab.display_name == "Crushing Blow" and attacker.sundering_ranks > 0 \
					and attacker.is_hero:
				var splash_bd := int(round(pr * 0.25 * attacker.sundering_ranks))
				if splash_bd > 0:
					var neighbors := _adjacent_enemies(strike_target)
					for foe in neighbors:
						foe.take_hit(0, splash_bd)
						foe.float_text("+%d BD" % splash_bd, Color(0.8, 0.5, 1.0))
					if not neighbors.is_empty():
						_log("   → Talent: Sundering — %d BD to the %d foe%s Adjacent to %s" % [
							splash_bd, neighbors.size(),
							"" if neighbors.size() == 1 else "s",
							strike_target.unit_name], "#b0a8e0")
			if ab.bleed_build > 0 and not strike_target.dead and randf() <= ab.bleed_chance:
				_add_bleed_with_burst(strike_target, ab.bleed_build + attacker.bleed_bonus)
			if ab.display_name == "Mocking Blow" and not strike_target.dead:
				var mocker_idx := heroes.find(attacker)
				if mocker_idx >= 0:
					var taunt_turns := 5 if is_perfect else 4
					_apply_status(strike_target, "mocked", taunt_turns, mocker_idx)
					_note_debuff_applied(attacker, "mocked")
					var others := enemies.filter(
						func(e): return not e.dead and e != strike_target)
					if not others.is_empty():
						_apply_status(others.pick_random(), "mocked", taunt_turns, mocker_idx)
				# Tank and Spank: the taunt can Empower a random ally.
				if attacker.tank_spank_ranks > 0 \
						and randf() < 0.15 * attacker.tank_spank_ranks:
					var pals := heroes.filter(func(h): return not h.dead)
					if not pals.is_empty():
						var pal: BattleUnit = pals.pick_random()
						_log("   → Talent: Tank and Spank — the taunt Empowers %s" % \
							pal.unit_name, "#b0a8e0")
						_apply_status(pal, "empower", 2)
			# Shrapnel: the second debuff (Cripple rides applies_status above).
			if ab.display_name == "Shrapnel" and not strike_target.dead:
				_apply_status(strike_target, "slow", 4 if is_perfect else 3)
			# Poisoned Arrow: layers several stacks at once.
			if ab.display_name == "Poisoned Arrow" and not strike_target.dead:
				for stack_i in (4 if is_perfect else 3):
					_apply_status(strike_target, "poison", 5, 0,
						_dot_tick("poison", attacker))
			# Specialization on-hit passives.
			if not strike_target.dead:
				# Pack Bond (Canis): the wolf worries every wound open.
				if attacker.passive_id == "pack" and attacker.companion != null \
						and not attacker.companion.dead \
						and attacker.companion.companion_kind == "canis":
					_add_bleed_with_burst(strike_target, 15)
				# Permafrost: the deep cold takes root — frost hits can Frostbite.
				if attacker.passive_id == "permafrost" and ab.dmg_type == "frost" \
						and randf() < 0.25:
					_apply_status(strike_target, "frostbite", 2)
			# Trapper: striking the Survivalist risks a poisoned barb.
			if strike_target.passive_id == "trapper" and not attacker.is_hero \
					and not attacker.dead and randf() < 0.25:
				_apply_status(attacker, "poison", 5, 0,
					_dot_tick("poison", strike_target))
			# Flame Shield: whoever strikes the shielded Pyromancer ignites.
			if strike_target.has_status("flame_shield") and not attacker.is_hero \
					and not attacker.dead:
				_apply_status(attacker, "burn", 3,
					int(round((CRIT_CHANCE + strike_target.crit_bonus) * 100)),
					_dot_tick("burn", strike_target))
			# Pyromancer fire package (07-16 kit).
			if detonated > 0:
				_log("   → Detonation consumes the Burn (+%d bonus damage)" % detonated,
					"#e08850")
			if is_perfect and ab.display_name == "Detonation" and not strike_target.dead:
				_apply_status(strike_target, "burn", 1,
					int(round((CRIT_CHANCE + attacker.crit_bonus) * 100)),
					_dot_tick("burn", attacker))
			if ab.display_name == "Wildfire" and not wildfire_burn.is_empty():
				var spread_turns := maxi(int(ceil(int(wildfire_burn.turns) / 2.0)), 1)
				var neighbors := _adjacent_enemies(strike_target)
				for foe in neighbors:
					_apply_status(foe, "burn", spread_turns,
						int(wildfire_burn.get("power", 0)),
						int(wildfire_burn.get("tick", 0)))
				if not neighbors.is_empty():
					_log("   → Wildfire spreads the Burn to %d Adjacent %s (%d turns)" % [
						neighbors.size(),
						"enemy" if neighbors.size() == 1 else "enemies",
						spread_turns], "#e08850")
			if ab.display_name == "Flamewave" and not strike_target.dead \
					and strike_target.has_status("burn"):
				var fw := strike_target.get_status("burn")
				var fw_ext := 3 if is_perfect else 2
				var binfo: Array = STATUS_INFO["burn"]
				strike_target.update_status("burn", binfo[1], binfo[3], -1,
					int(fw.turns) + fw_ext)
				strike_target.float_text("Burn +%d turns" % fw_ext, binfo[2])
				_log("   → Flamewave stokes %s's Burn (+%d turns)" % [
					strike_target.unit_name, fw_ext], "#e08850")
			# Blizzard: 1-2 stacks of Chilled settle on each victim.
			if ab.display_name == "Blizzard" and not strike_target.dead:
				for chill_i in randi_range(1, 2):
					_apply_status(strike_target, "chilled", 3)
				_note_debuff_applied(attacker, "chilled")
				# Whiteout: the storm blinds.
				if attacker.whiteout_ranks > 0 and not strike_target.dead \
						and randf() < 0.15 * attacker.whiteout_ranks:
					_log("   → Talent: Whiteout — %s is blinded by the storm" % \
						strike_target.unit_name, "#b0a8e0")
					_apply_status(strike_target, "dazed", 2)
					_note_debuff_applied(attacker, "dazed")
			# Icy Veins: an Ice Lance kill banks power for the next lance.
			if ab.display_name == "Ice Lance" and attacker.is_hero:
				attacker.icy_veins_charge = 0.0
				if result.died and attacker.icy_veins_ranks > 0:
					attacker.icy_veins_charge = 0.15 * attacker.icy_veins_ranks
					_log("   → Talent: Icy Veins — the next Ice Lance hits +%d%%" % \
						int(attacker.icy_veins_charge * 100), "#b0a8e0")
			# Razor Ice perfect: unchilled victims catch the frost.
			if is_perfect and ab.display_name == "Razor Ice" \
					and not strike_target.dead \
					and not strike_target.has_status("chilled") \
					and not strike_target.has_status("frozen"):
				_apply_status(strike_target, "chilled", 3)
				_note_debuff_applied(attacker, "chilled")
			# Explosive Force: a fire crit fans the flames longer.
			if is_crit and ab.dmg_type == "fire" and attacker.explosive_ranks > 0 \
					and not strike_target.dead and strike_target.has_status("burn"):
				var ef := strike_target.get_status("burn")
				var ef_info: Array = STATUS_INFO["burn"]
				strike_target.update_status("burn", ef_info[1], ef_info[3], -1,
					int(ef.turns) + attacker.explosive_ranks)
				_log("   → Talent: Explosive Force — the crit extends the Burn (+%d)" % \
					attacker.explosive_ranks, "#b0a8e0")
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
			# Implosion: Detonation can slam twice (free echo strike).
			if ab.display_name == "Detonation" and not is_counter \
					and attacker.is_hero and attacker.implosion_ranks > 0 \
					and not strike_target.dead and not attacker.dead \
					and randf() < 0.03 * attacker.implosion_ranks:
				strike_target.float_text("IMPLOSION", Color(1.0, 0.5, 0.15))
				_log("Talent: Implosion — the Detonation strikes twice!", "#b0a8e0")
				await _wait(0.35)
				await _resolve(attacker, _free_copy(ab), strike_target, "good", true)
			# Counter Attack: granted by specific effects — a parry answers
			# with an immediate basic attack (nothing grants it yet).
			if parried and strike_target.counter_attacks and not is_counter \
					and not strike_target.dead and not attacker.dead:
				_log("Talent: Riposte — %s counter attacks!" % strike_target.unit_name,
					"#50c8e0")
				await _wait(0.4)
				await _resolve(strike_target, strike_target.abilities[0], attacker,
					"good", true)
				if attacker.dead:
					break
			if (ab.random_hits > 0 or ab.multi_hits > 0) and total_hits > 1:
				await _wait(0.45)  # sequential strikes land distinctly
		# War Stomp: the tremor rallies the line — allies regain 10% resource.
		if ab.display_name == "War Stomp" and attacker.is_hero and not attacker.dead:
			for h in heroes:
				if h.dead or h == attacker or h.resource_name == "":
					continue
				var stomp_gain := maxi(int(h.max_resource * 0.10), 1)
				h.resource = mini(h.resource + stomp_gain, h.max_resource)
				h.float_text("+%d %s" % [stomp_gain, h.resource_name], Color(0.5, 0.8, 1.0))
				h.refresh_bars()
			_log("   → War Stomp: allies regain 10% of their resource", "#70d878")
		# Post-strike attacker effects (skipped if a counter felled the attacker).
		var recoil_pct := ab.recoil_base
		# Magi's Wrath: spreading the storm dissipates its backlash.
		if ab.display_name == "Magi's Wrath":
			recoil_pct = maxf(recoil_pct - 0.03 * enemies_struck, 0.0)
		if recoil_pct > 0.0 and not attacker.dead:
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
		# Resonance builds only on the Mage's own casts — parry counters don't
		# count (they made the Mage "start" battles with a stack).
		if not is_counter:
			_gain_resonance(attacker, 2 if any_crit else 1)
		# Rampage: a kill lets it surge onward — an immediate free recast on
		# another enemy (and it chains while the kills keep coming).
		if ab.display_name == "Rampage" and attacker.is_hero and not attacker.dead \
				and target != null and target.dead and not battle_over:
			var rampage_foes := enemies.filter(func(e): return not e.dead)
			if not rampage_foes.is_empty():
				var next_target: BattleUnit = rampage_foes.pick_random()
				_message("RAMPAGE surges onward!")
				_log("%s: Rampage surges to %s!" % [attacker.unit_name,
					next_target.unit_name], "#e05050")
				await _wait(0.5)
				await _resolve(attacker, _free_copy(ab), next_target, "good", true)
	if not sim and attacker.position != lunge_origin:
		if walked and not attacker.dead:
			await _walk_to(attacker, lunge_origin)
			attacker.sprite.flip_h = not attacker.is_hero  # restore facing
		elif not walked:
			var back := create_tween()
			back.tween_property(attacker, "position", lunge_origin, 0.18) \
				.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await _wait(0.45)
	attacker.return_to_idle()
	if not is_counter:
		var eff_delay := ab.delay
		if grade == "perfect" and ab.display_name == "Mana Shield":
			eff_delay = 1.5
		if grade == "perfect" and ab.display_name == "Lunge":
			eff_delay = 3.0
		if grade == "perfect" and ab.display_name == "Arcane Cannon":
			eff_delay = 3.0
		if grade == "perfect" and ab.display_name == "Magi's Wrath":
			eff_delay = 3.5
		attacker.next_time += eff_delay * 100.0 / attacker.effective_speed()


func _apply_status(target: BattleUnit, id: String, turns: int, power := 0,
		tick := 0) -> void:
	# Bosses shrug off Stuns (and Freezes) until their guard is Broken.
	if id in ["stunned", "frozen"] and target.is_boss and not target.broken:
		target.float_text("IMMUNE", Color(0.75, 0.75, 0.75))
		_log("   → %s resists the %s (boss — Break them first)" % [target.unit_name,
			"Stun" if id == "stunned" else "Freeze"], "#909090")
		return
	# Hallowed (Empowered Divine Plea): shrugs off every new debuff.
	if target.has_status("sanctified") and BattleUnit.DEBUFF_IDS.has(id):
		target.float_text("HALLOWED", Color(0.98, 0.88, 0.55))
		_log("   → %s is Hallowed — the %s cannot take hold" % [target.unit_name,
			String(STATUS_INFO[id][0])], "#e8c860")
		return
	var info: Array = STATUS_INFO[id]
	target.add_status(id, info[0], info[1], info[2], turns, info[3], power, tick)
	if id == "chilled":
		# Frigid Grip rides every stack: stamp the deeper slow on the victim.
		target.frigid_bonus = 0.03 * _max_hero_rank("frigid_ranks")
		# Rime: the chill leaps to one other random enemy (never chains).
		if target.has_status("rime") and not _rime_echoing:
			var others := enemies.filter(func(e): return not e.dead and e != target)
			if not others.is_empty():
				var echo_t: BattleUnit = others.pick_random()
				_rime_echoing = true
				_log("   → Rime spreads the chill to %s" % echo_t.unit_name, "#7cc8f0")
				_apply_status(echo_t, "chilled", 3)
				# Freezing Advance: the leap stings.
				var freeze_adv := _max_hero_rank("freezing_ranks")
				if freeze_adv > 0 and not echo_t.dead:
					var fa_atk := 0
					for h in heroes:
						if not h.dead and h.freezing_ranks > 0:
							fa_atk = maxi(fa_atk, h.attack)
					var fa_dmg := maxi(int(round(0.02 * freeze_adv * fa_atk)), 1)
					if echo_t.take_tick_damage(fa_dmg, "-%d Frost" % fa_dmg,
							Color(0.6, 0.85, 1.0)):
						_sfx("death", -4.0)
						_log("† %s dies" % echo_t.unit_name, "#e05050")
					_log("   → Talent: Freezing Advance — %s takes %d frost" % [
						echo_t.unit_name, fa_dmg], "#b0a8e0")
				_rime_echoing = false
		# Four stacks flash-freeze the victim (the stacks reset).
		if target.status_stacks("chilled") >= 4:
			target.remove_status("chilled")
			_log("   → %s FREEZES SOLID (4 stacks of Chilled)" % target.unit_name,
				"#7cc8f0")
			if not target.was_frozen:
				target.was_frozen = true
			_apply_status(target, "frozen", 1)
			return
		_log("   → Chilled on %s (x%d, 3-turn clock reset)" % [target.unit_name,
			target.status_stacks("chilled")], "#7cc8f0")
		return
	if id == "burn":
		# Reapplication extends duration — log the running total.
		var bstat := target.get_status("burn")
		_log("   → Burn on %s (%d turns total)" % [target.unit_name,
			int(bstat.get("turns", turns))], "#e08850")
		return
	if id == "poison":
		var pstat := target.get_status("poison")
		var stacks := int(pstat.get("stacks", 1))
		var per := int(pstat.get("tick", 0))
		if per <= 0:
			per = DOT_STATUSES["poison"]
		_log("   → Poison on %s (x%d — %d nature dmg/turn, %d turns)" % [target.unit_name,
			stacks, per * stacks, turns], "#8cc843")
		return
	var span := "battle" if turns < 0 else "%d turns" % turns
	_log("   → %s on %s (%s)" % [info[0], target.unit_name, span], "#b0a8e0")


# DoT strength snapshots the APPLIER's Attack: Burn 6%, Poison 3% per stack.
# Accelerant (Pyromancer talent) hardens Burn ticks by +1%/rank.
func _dot_tick(id: String, applier: BattleUnit) -> int:
	if applier == null or not DOT_STATUSES.has(id):
		return 0
	var pct: int = DOT_STATUSES[id]
	if id == "burn":
		pct += applier.accelerant_ranks
	return maxi(int(round(pct * 0.01 * applier.attack)), 1)


# Arcane Resonance: builds on damaging casts (2 on crit via Arcane Instability);
# hitting max stacks triggers Backlash Ward (+15 Mana). Stacks persist until
# Stabilize consumes them. Overcharge raises the cap to 8.
func _gain_resonance(caster: BattleUnit, stacks: int) -> void:
	if caster.second_resource_name != "Resonance":
		return
	var before := caster.second_resource
	# Unlimited Power: overflow at the cap converts into permanent power.
	if before >= caster.second_max and caster.unlimited_ranks > 0:
		caster.unlimited_surges += 1
		caster.dmg_bonus += 0.02 * caster.unlimited_ranks
		var up_mana := int(round(caster.max_resource * 0.02 * caster.unlimited_ranks))
		caster.max_resource += up_mana
		var up_pct := 2 * caster.unlimited_ranks * caster.unlimited_surges
		var up_desc := "Unlimited Power: Resonance overflow —\ncurrently +%d%% damage and +%d%% maximum\nMana (all battle)." % [up_pct, up_pct]
		if not caster.update_status("unlimited", "+%d%%" % up_pct, up_desc):
			caster.add_status("unlimited", "Unlimited Power", "+%d%%" % up_pct,
				Color(0.85, 0.55, 1.0), -1, up_desc)
		caster.float_text("UNLIMITED POWER +%d%%" % (2 * caster.unlimited_ranks),
			Color(0.85, 0.55, 1.0))
		_log("   → Talent: Unlimited Power — %s overflows (+%d%% damage, +%d max Mana)" % [
			caster.unit_name, 2 * caster.unlimited_ranks, up_mana], "#b0a8e0")
		caster.refresh_bars()
		return
	caster.second_resource = mini(caster.second_resource + stacks, caster.second_max)
	var gained := caster.second_resource - before
	if gained > 0:
		caster.float_text("+%d Resonance" % gained, Color(0.8, 0.5, 1.0))
		# Mana Attunement: every stack gained drips Mana back.
		if caster.mana_attune_ranks > 0:
			var att_mana := int(round(caster.max_resource * 0.02
				* caster.mana_attune_ranks * gained))
			if att_mana > 0:
				caster.resource = mini(caster.resource + att_mana, caster.max_resource)
				caster.float_text("+%d Mana" % att_mana, Color(0.5, 0.7, 1.0))
				_log("   → Talent: Mana Attunement — %s sips %d Mana" % [
					caster.unit_name, att_mana], "#b0a8e0")
	# Backlash Ward: hitting max stacks restores Mana.
	if caster.second_resource == caster.second_max and before < caster.second_max:
		caster.resource = mini(caster.resource + 15, caster.max_resource)
		caster.float_text("Backlash Ward +15 Mana", Color(0.5, 0.7, 1.0))
		_log("   → Backlash Ward: %s restores 15 Mana" % caster.unit_name, "#b0a8e0")
	caster.refresh_bars()


# Effective Resonance weight: Overcharge makes stacks 6-8 count for 1.5x
# (1.65x on a perfect cast) toward the passive's per-stack bonuses.
func _resonance_power(u: BattleUnit) -> float:
	var stacks := float(u.second_resource)
	if u.overcharged and stacks > 5.0:
		return 5.0 + (stacks - 5.0) * u.overcharge_mult
	return stacks


# Mercy (Holy passive): +5% healing done per stack currently held (Heavenly
# Aura deepens it by +5%/rank; Triage adds a flat +3%/rank). Costs are paid
# before the cast resolves, so a spender heals with what remains.
func _healing_done_mult(caster: BattleUnit) -> float:
	var m := 1.0
	if caster.second_resource_name == "Mercy":
		m += (0.05 + 0.05 * caster.heavenly_ranks) * caster.second_resource
	m += 0.03 * caster.triage_ranks
	return m


# Triage: instant heals can CRIT (x1.5) off the Cleric's crit chance.
func _heal_crit_mult(caster: BattleUnit) -> float:
	if caster.triage_ranks > 0 and randf() < CRIT_CHANCE + caster.crit_bonus:
		return 1.5
	return 1.0


# Holy Capacitor: bank a share of the overheal the last heal spilled;
# the next Heal releases the whole battery.
func _bank_overheal(caster: BattleUnit, target: BattleUnit) -> void:
	if caster.capacitor_ranks <= 0 or target.last_overheal <= 0:
		return
	var banked := int(round(target.last_overheal * 0.05 * caster.capacitor_ranks))
	if banked <= 0:
		return
	caster.stored_overheal += banked
	var cap_desc := "Holy Capacitor: %d overhealing stored,\nreleased by the next Heal." % caster.stored_overheal
	if not caster.update_status("capacitor", "%d" % caster.stored_overheal, cap_desc):
		caster.add_status("capacitor", "Holy Capacitor", "%d" % caster.stored_overheal,
			Color(0.95, 0.9, 0.6), -1, cap_desc)
	_log("   → Talent: Holy Capacitor banks %d overhealing (%d stored)" % [
		banked, caster.stored_overheal], "#b0a8e0")


# Divine Shield: applies the barrier and stamps the tree's riders on it
# (Blessed Barrier heal share; Afterglow heal on break).
func _grant_divine_shield(devout: BattleUnit, target: BattleUnit, power: int) -> void:
	_apply_status(target, "barrier", -1, power)
	var bstat := target.get_status("barrier")
	if bstat.is_empty():
		return
	bstat["divine"] = true  # only Divine Shield absorbs build Faith
	bstat["blessed_pct"] = 0.03 * devout.blessed_barrier_ranks
	bstat["afterglow"] = int(round(devout.max_hp * 0.05 * devout.afterglow_ranks))


# Conviction (Devout passive): the living Devout, or null. Faith stacks
# only work while their shrine stands.
func _living_devout() -> BattleUnit:
	for h in heroes:
		if not h.dead and h.passive_id == "conviction":
			return h
	return null


# Conviction: a mitigated hit steels the struck ally. At 5 stacks the
# ally is healed (Blessed are the Faithful deepens it), Faith resets,
# the Devout sips Mana, and Communion may spread the fervor.
func _gain_faith(u: BattleUnit, n: int) -> void:
	var devout := _living_devout()
	if devout == null or u.dead or u.is_companion or not u.is_hero:
		return
	# Blessing of Zeal: the kindled build Faith twice as fast.
	if u.has_status("zeal"):
		n *= 2
	u.faith_stacks = mini(u.faith_stacks + n, 5)
	if u.faith_stacks < 5:
		var f_desc := "Conviction: Faith x%d — %d%% damage\nmitigation and +%d%% damage dealt.\nAt 5 stacks: healed for %d%% max\nhealth, and the Faith resets." % [
			u.faith_stacks,
			int(round((3.0 + 0.5 * devout.unwavering_ranks) * u.faith_stacks)),
			int(round((2.0 + 0.5 * devout.unwavering_ranks) * u.faith_stacks)),
			15 + 5 * devout.faithful_ranks]
		if not u.update_status("faith", "F%d" % u.faith_stacks, f_desc):
			u.add_status("faith", "Faith", "F%d" % u.faith_stacks,
				Color(0.98, 0.85, 0.45), -1, f_desc)
		return
	# The fifth stack: release.
	u.faith_stacks = 0
	u.remove_status("faith")
	var f_heal := maxi(int(round(u.max_hp * (0.15 + 0.05 * devout.faithful_ranks))), 1)
	var f_got: int = u.heal_amount(f_heal, u != devout)
	u.float_text("FAITH +%d" % f_got, Color(0.98, 0.85, 0.45))
	_stat("healing", f_got)
	var d_mana := maxi(int(round(devout.max_resource * 0.03)), 1)
	devout.resource = mini(devout.resource + d_mana, devout.max_resource)
	devout.refresh_bars()
	_log("   → Conviction: %s's Faith overflows — healed %d; %s recovers %d Mana" % [
		u.unit_name, f_got, devout.unit_name, d_mana], "#e8c860")
	# Communion: fervor is contagious (chance scales with the OTHERS' Faith).
	if devout.communion_ranks > 0:
		for h in heroes:
			if h == u or h.dead or h.is_companion or h.faith_stacks <= 0:
				continue
			if randf() < 0.20 * devout.communion_ranks * h.faith_stacks:
				_log("   → Talent: Communion — %s's fervor spreads to %s" % [
					u.unit_name, h.unit_name], "#b0a8e0")
				_gain_faith(h, 1)


# Conviction: a Divine Shield soaking a hit steels its holder.
func _on_shield_absorbed(holder: BattleUnit) -> void:
	_gain_faith(holder, 1)


# Sacred Covenant: a Divine Shield that saved a life rewards its holder.
func _on_lethal_saved(saved: BattleUnit) -> void:
	var devout := _living_devout()
	if devout == null or devout.covenant_ranks <= 0:
		return
	var cov_heal := maxi(int(round(saved.max_hp * 0.05 * devout.covenant_ranks)), 1)
	var cov_got: int = saved.heal_amount(cov_heal, saved != devout)
	saved.float_text("+%d" % cov_got, Color(0.95, 0.9, 0.6))
	_stat("healing", cov_got)
	_log("   → Talent: Sacred Covenant — the shield held the line; %s heals %d and keeps the Faith" % [
		saved.unit_name, cov_got], "#b0a8e0")
	_gain_faith(saved, devout.covenant_ranks)


# Mercy (Holy passive): an ally's brush with death steels the healer.
# Fired by unit.below_half_cb whenever a party member crosses below 50%.
func _on_hero_below_half(low_ally: BattleUnit) -> void:
	for h in heroes:
		if h.dead or h.second_resource_name != "Mercy":
			continue
		if h.second_resource < h.second_max:
			h.second_resource += 1
			h.float_text("+1 Mercy", Color(0.95, 0.8, 0.3))
			h.refresh_bars()
			_log("   → Mercy: %s steels themselves (%s falls below half health)" % [
				h.unit_name, low_ally.unit_name], "#e8c860")


# Mercy: arms and pays the Empower surcharge (+1 stack) for a supporting
# cast. Empowered casts forgo their perfect bonus by design.
func _consume_empower(attacker: BattleUnit, ab: Ability) -> bool:
	if not empower_armed:
		return false
	empower_armed = false
	if ab.special not in ["holy_heal", "renewal", "hymn", "resurrection", "divine_plea"]:
		return false
	if attacker.second_resource_name != "Mercy" or attacker.second_resource < 1:
		return false
	# Sanctified (talent): the surcharge can be refunded too.
	if attacker.sanctified_ranks > 0 and randf() < 0.10 * attacker.sanctified_ranks:
		attacker.float_text("Mercy preserved", Color(0.95, 0.8, 0.3))
		_log("   → Talent: Sanctified — the Empowerment costs nothing", "#b0a8e0")
	else:
		attacker.second_resource -= 1
	attacker.refresh_bars()
	attacker.float_text("EMPOWERED", Color(0.95, 0.8, 0.3))
	_log("   → %s spends 1 Mercy to Empower the cast" % attacker.unit_name, "#e8c860")
	return true


# A cost/cooldown-free copy of an attack for reaction casts (Opportunist,
# Rampage recasts) — _resolve always charges ab.cost, so reactions pass a
# zero-cost twin instead.
func _free_copy(ab: Ability) -> Ability:
	return Ability.make({"display_name": ab.display_name, "damage": ab.damage,
		"pressure": ab.pressure, "dmg_type": ab.dmg_type, "anim": ab.anim,
		"multi_hits": ab.multi_hits, "bleed_build": ab.bleed_build,
		"bleed_chance": ab.bleed_chance, "applies_status": ab.applies_status,
		"status_chance": ab.status_chance,
		"perfect_extra_hit": ab.perfect_extra_hit})


# Opportunist (talent): the Swordmaster answers a whiffed enemy attack with
# a free Overpower.
func _try_opportunist(defender: BattleUnit, attacker: BattleUnit) -> void:
	if defender == null or attacker == null or defender.opportunist <= 0 \
			or not defender.is_hero or attacker.is_hero \
			or defender.dead or attacker.dead:
		return
	var op := _find_ability(defender, "Overpower")
	if op == null:
		return
	defender.float_text("OPPORTUNIST", Color(0.4, 0.9, 1.0))
	_log("%s seizes the opening — Opportunist!" % defender.unit_name, "#50c8e0")
	await _wait(0.4)
	await _resolve(defender, _free_copy(op), attacker, "good", true)


# Walks a unit (walk animation, facing the way it moves) to a point.
func _walk_to(u: BattleUnit, dest: Vector2) -> void:
	u.sprite.flip_h = dest.x < u.position.x  # both sheets face right natively
	u.play_anim("walk")
	var dur := clampf(u.position.distance_to(dest) / 650.0, 0.2, 1.1)
	var tw := create_tween()
	tw.tween_property(u, "position", dest, dur) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tw.finished


# Non-attack abilities (buffs, shields, party effects). Effect strength scales
# with the skill check via `mult`.
func _resolve_special(attacker: BattleUnit, ab: Ability, target: BattleUnit,
		grade: String, mult: float) -> void:
	var is_perfect := grade == "perfect"
	# Mercy Empowerment: pays +1 stack and forfeits the perfect bonus.
	var empowered := _consume_empower(attacker, ab)
	if empowered:
		is_perfect = false
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
			# Absorbs 50% (perfect 55%) of the DEVOUT's max health, carrying
			# the tree's riders (Blessed Barrier / Afterglow; Covenant fires
			# through the lethal-save hook).
			var shield := int(round(attacker.max_hp * (0.55 if is_perfect else 0.50)))
			_sfx("parry", -6.0, 0.6)
			_grant_divine_shield(attacker, target, shield)
			_message("%s shields %s (%d)" % [attacker.unit_name, target.unit_name, shield])
			_log("%s: Divine Shield on %s — absorbs %d (%d%% of the Devout's health)" % [
				attacker.unit_name, target.unit_name, shield,
				55 if is_perfect else 50], "#70d878")
			# Radient Aegis: the shield can echo onto another ally.
			if attacker.aegis_ranks > 0 and randf() < 0.15 * attacker.aegis_ranks:
				var aegis_pool := heroes.filter(
					func(h): return not h.dead and h != target and not h.is_companion)
				if not aegis_pool.is_empty():
					var aegis_t: BattleUnit = aegis_pool.pick_random()
					_grant_divine_shield(attacker, aegis_t, shield)
					aegis_t.float_text("Radient Aegis", Color(0.95, 0.9, 0.6))
					_log("   → Talent: Radient Aegis — the shield echoes onto %s" % \
						aegis_t.unit_name, "#b0a8e0")
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
			# VAULTED ability's machinery (kept): scales with Mercy like all
			# Holy healing now does.
			var base := int((55 if is_perfect else 40) * mult * _healing_done_mult(attacker))
			var missing_hp := target.max_hp - target.hp
			var applied := mini(base, missing_hp)
			target.heal_amount(applied, target != attacker)
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
			# 20% of each ally's max health; Empowered 35%; perfect 25%.
			var pct := 0.20
			if empowered:
				pct = 0.35
			elif is_perfect:
				pct = 0.25
			pct *= _healing_done_mult(attacker)
			_sfx("heal", -4.0, 0.9)
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				# Triage: every voice of the hymn rolls its own crit.
				var h_crit := _heal_crit_mult(attacker)
				var amt := int(h.max_hp * pct * h_crit)
				var got: int = h.heal_amount(amt, h != attacker)
				h.float_text("+%d%s" % [got, "!" if h_crit > 1.0 else ""],
					Color(0.4, 0.9, 0.45), h_crit > 1.0)
				_stat("healing", got)
				_bank_overheal(attacker, h)
			_message("%s sings the Hymn of Hope!" % attacker.unit_name)
			_log("%s: Hymn of Hope — party heals %d%%%s" % [attacker.unit_name,
				int(round(pct * 100)), " (Empowered)" if empowered else ""], "#70d878")
		"sanctuary":
			# VAULTED ability's machinery (kept): Mercy-scaled like all heals.
			var sanct_pct := (0.18 if is_perfect else 0.12) * _healing_done_mult(attacker)
			_sfx("heal", -4.0, 0.8)
			for h in heroes.filter(func(he): return not he.dead):
				var amt := int(h.max_hp * sanct_pct)
				h.heal_amount(amt, h != attacker)
				h.float_text("+%d" % amt, Color(0.4, 0.9, 0.45))
				_apply_status(h, "shieldwall", 1)
				_stat("healing", amt)
			_message("Sanctuary!")
			_log("%s: Sanctuary — party healed and walled" % attacker.unit_name, "#70d878")
		"unity":
			# Sacred Resolve (talent ability): Healing Pulse and Cleansing
			# Waters ride the status, snapshotted from the caster.
			_sfx("heal", -5.0, 0.7)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "unity", 4 if is_perfect else 3)
				var ustat: Dictionary = h.get_status("unity")
				if not ustat.is_empty():
					ustat["pulse"] = maxi(int(round(attacker.max_hp * 0.02
						* attacker.pulse_ranks)), 0)
					ustat["cleanse"] = attacker.waters_ranks
			_message("%s binds the party as one!" % attacker.unit_name)
			_log("%s: Sacred Resolve — the party's souls are bound (%d turns)" % [
				attacker.unit_name, 4 if is_perfect else 3], "#70d878")
		"cons_ground":
			_sfx("heal", -5.0, 0.6)
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				_apply_status(h, "cons_ground", 3 if is_perfect else 2)
			_message("%s consecrates the ground!" % attacker.unit_name)
			_log("%s: Consecrated Ground — the party takes 15%% less damage and reflects 10%% (%d turns)" % [
				attacker.unit_name, 3 if is_perfect else 2], "#c8b880")
		"zeal":
			_sfx("heal", -6.0, 1.2)
			_apply_status(target, "zeal", 4 if is_perfect else 3)
			var zeal_ticked := false
			for zeal_cd in target.cooldowns.keys():
				if int(target.cooldowns[zeal_cd]) > 0:
					target.cooldowns[zeal_cd] = int(target.cooldowns[zeal_cd]) - 1
					zeal_ticked = true
			_message("%s kindles %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Blessing of Zeal on %s — +15%% damage, Faith gain doubled (%d turns)%s" % [
				attacker.unit_name, target.unit_name, 4 if is_perfect else 3,
				"; cooldowns tick 1" if zeal_ticked else ""], "#e8b860")
		"bulwark":
			_sfx("parry", -5.0, 0.5)
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				_apply_status(h, "bulwark", 3)
				if is_perfect:
					var bw_heal := maxi(int(round(h.max_hp * 0.05)), 1)
					var bw_got: int = h.heal_amount(bw_heal, h != attacker)
					h.float_text("+%d" % bw_got, Color(0.4, 0.9, 0.45))
					_stat("healing", bw_got)
			_message("%s raises the BULWARK OF FORTITUDE!" % attacker.unit_name)
			_log("%s: Bulwark of Fortitude — no Break damage, armor +50%%, 10%% healing per turn (3 turns)" % \
				attacker.unit_name, "#8c9cc8")
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
		"battle_shout":
			var shout_bleed := 0
			for e in enemies:
				if not e.dead:
					shout_bleed += e.bleed_buildup
			var shout_pct := int(shout_bleed / 20.0)
			_sfx("crit", -8.0, 0.7)
			_apply_status(attacker, "battle_shout", 2, shout_pct)
			# The chip shows the damage gained at the moment of the shout.
			attacker.update_status("battle_shout", "+%d%%" % shout_pct,
				"Battle Shout: +%d%% damage for 2 turns\n(from %d blood buildup on the enemy\nparty at the time of the shout)." % [
					shout_pct, shout_bleed], shout_pct)
			if is_perfect:
				attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
				attacker.float_text("+5 Rage", Color(1.0, 0.5, 0.4))
				attacker.refresh_bars()
			_message("%s roars with bloodlust!" % attacker.unit_name)
			_log("%s: Battle Shout — +%d%% damage for 2 turns" % [attacker.unit_name,
				shout_pct], "#70d878")
		"shield_block":
			var blocks := 5 if is_perfect else 3
			_sfx("parry", -6.0, 0.5)
			_apply_status(attacker, "shield_charges", -1, blocks)
			# The chip counts the blocks owed (recasting resets the count).
			attacker.update_status("shield_charges", "SW%d" % blocks,
				"Shieldwall: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % blocks,
				blocks)
			_message("%s raises the shield!" % attacker.unit_name)
			_log("%s: Shieldwall — the next %d attacks will be BLOCKED" % [
				attacker.unit_name, blocks], "#8c9cc8")
		"hold_the_line":
			_sfx("heal", -5.0, 0.6)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "hold_bd", 2)
				_apply_status(h, "undying", 2)
			if is_perfect:
				attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
				attacker.float_text("+5 Rage", Color(1.0, 0.5, 0.4))
				attacker.refresh_bars()
			_message("%s HOLDS THE LINE!" % attacker.unit_name)
			_log("%s: Hold the Line — party takes 50%% less BD and cannot die" % \
				attacker.unit_name, "#70d878")
		"resurrection":
			if target != null and target.dead:
				var rez_frac := 0.25 if is_perfect else 0.2
				if empowered:
					rez_frac = 1.0
				target.revive(rez_frac)
				target.resource = int(target.max_resource * rez_frac)
				target.refresh_bars()
				if empowered:
					var rez_tick := maxi(int(round(attacker.max_hp * 0.15
						* _healing_done_mult(attacker))), 1)
					_apply_status(target, "renewal", 5, 0, rez_tick)
					if target.has_status("renewal"):
						target.get_status("renewal")["mend"] = attacker.on_mend_ranks
				_sfx("heal", -4.0, 0.65)
				target.float_text("RESURRECTED", Color(0.95, 0.9, 0.55))
				target.next_time = attacker.next_time \
					+ BASIC_DELAY * 100.0 / target.effective_speed()
				_message("%s returns to life!" % target.unit_name)
				_log("%s: Resurrection — %s returns at %d%% HP and resource%s" % [
					attacker.unit_name, target.unit_name, int(round(rez_frac * 100)),
					" with Renewal (Empowered)" if empowered else ""], "#70d878")
				_rebuild_turn_bar()
		"divine_wrath":
			_sfx("heal", -5.0, 0.85)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "wrath", 4 if is_perfect else 3)
			_message("%s calls down Divine Wrath!" % attacker.unit_name)
			_log("%s: Divine Wrath — party deals +15%% damage, +15%% speed" % \
				attacker.unit_name, "#70d878")
		"umbral_sigil":
			_sfx("break", -10.0, 0.7)
			_apply_status(target, "umbral_sigil", 4 if is_perfect else 3)
			_message("%s brands %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Umbral Sigil on %s — its party shares its pain" % [
				attacker.unit_name, target.unit_name], "#c070e0")
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
			var growth_got := target.heal_amount(growth, target != attacker)
			target.float_text("+%d" % growth_got, Color(0.4, 0.9, 0.45))
			_message("%s mends %s" % [attacker.unit_name, target.unit_name])
			_log("%s: Wild Growth heals %s for %d (20%% max HP%s)" % [attacker.unit_name,
				target.unit_name, growth_got,
				", halved by Frostbite" if target.has_status("frostbite") else ""],
				"#70d878")
		"flame_shield":
			_sfx("parry", -7.0, 1.1)
			_apply_status(attacker, "flame_shield", 2)
			_message("%s ignites the air!" % attacker.unit_name)
			_log("%s: Flame Shield — 50%% less damage taken; attackers ignite (2 turns)" % \
				attacker.unit_name, "#70d878")
			if is_perfect:
				# The ignition pulse: every burning enemy ticks RIGHT NOW.
				for foe in enemies:
					if foe.dead or not foe.has_status("burn"):
						continue
					var fs_tick := int(foe.get_status("burn").get("tick", 0))
					if fs_tick <= 0:
						fs_tick = DOT_STATUSES["burn"]
					var fs_died: bool = foe.take_tick_damage(fs_tick,
						"-%d Burn" % fs_tick, Color(1.0, 0.55, 0.2))
					_log("   → the ignition pulse burns %s for %d" % [
						foe.unit_name, fs_tick], "#e08850")
					if fs_died:
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % foe.unit_name)
						_log("† %s dies" % foe.unit_name, "#e05050")
		"rime":
			_sfx("break", -9.0, 1.4)
			_apply_status(target, "rime", 4 if is_perfect else 3)
			_apply_status(target, "frostbite", 2)
			_message("%s rimes %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Rime on %s — its chills will spread (%d turns)" % [
				attacker.unit_name, target.unit_name, 4 if is_perfect else 3], "#7cc8f0")
		"stabilize":
			# Consumes every Resonance stack: Mana back and a damage-reduction
			# ward that scales with the stacks grounded.
			var st_stacks := attacker.second_resource
			attacker.second_resource = 0
			var st_mana := 5 * st_stacks
			attacker.resource = mini(attacker.resource + st_mana, attacker.max_resource)
			var st_dr := 10 * st_stacks
			_sfx("heal", -7.0, 0.9)
			_apply_status(attacker, "stabilized", 2, st_dr)
			attacker.update_status("stabilized", "-%d%%" % st_dr,
				"Stabilized: takes %d%% less damage\n(10%% per Resonance stack consumed)." % st_dr,
				st_dr)
			attacker.float_text("+%d Mana" % st_mana, Color(0.5, 0.7, 1.0))
			if is_perfect:
				var st_heal := maxi(int(round(attacker.max_hp * 0.05)), 1)
				attacker.heal_amount(st_heal)
				attacker.float_text("+%d" % st_heal, Color(0.4, 0.9, 0.45))
			attacker.refresh_bars()
			_message("%s stabilizes!" % attacker.unit_name)
			_log("%s: Stabilize — %d stacks grounded: +%d Mana, -%d%% damage taken (2 turns)" % [
				attacker.unit_name, st_stacks, st_mana, st_dr], "#b085e0")
		"overcharge":
			attacker.overcharged = true
			attacker.overcharge_mult = 1.65 if is_perfect else 1.5
			attacker.second_max = 8
			_sfx("perfect", -6.0, 0.8)
			_apply_status(attacker, "overcharged", -1)
			attacker.refresh_bars()
			_message("%s OVERCHARGES!" % attacker.unit_name)
			_log("%s: Overcharge — max Resonance is now 8; stacks beyond 5 weigh %.2fx" % [
				attacker.unit_name, attacker.overcharge_mult], "#b085e0")
		"holy_heal":
			# 40% of the CASTER's max health, Mercy-scaled; Triage can crit;
			# Holy Capacitor releases its stored overheal here.
			var hh_crit := _heal_crit_mult(attacker)
			var hh_amt := maxi(int(round(attacker.max_hp * 0.40
				* _healing_done_mult(attacker) * hh_crit)), 1)
			if attacker.stored_overheal > 0:
				hh_amt += attacker.stored_overheal
				_log("   → Talent: Holy Capacitor releases %d stored healing" % \
					attacker.stored_overheal, "#b0a8e0")
				attacker.stored_overheal = 0
				attacker.remove_status("capacitor")
			_sfx("heal", -6.0)
			var hh_got: int = target.heal_amount(hh_amt, target != attacker)
			target.float_text("+%d%s" % [hh_got, "!" if hh_crit > 1.0 else ""],
				Color(0.4, 0.9, 0.45), hh_crit > 1.0)
			_stat("healing", hh_got)
			_bank_overheal(attacker, target)
			var hh_note := ""
			if empowered:
				var purged := target.purge_debuffs()
				hh_note = " — cleansed %d harmful effect%s (Empowered)" % [
					purged, "" if purged == 1 else "s"]
			elif is_perfect:
				var hh_self := maxi(int(round(attacker.max_hp * 0.05)), 1)
				var self_got: int = attacker.heal_amount(hh_self)
				attacker.float_text("+%d" % self_got, Color(0.4, 0.9, 0.45))
				_stat("healing", self_got)
			_message("%s mends %s" % [attacker.unit_name, target.unit_name])
			_log("%s: Heal — %s recovers %d%s (40%% of the Cleric's health)%s" % [
				attacker.unit_name, target.unit_name, hh_got,
				" CRIT" if hh_crit > 1.0 else "", hh_note], "#70d878")
		"divine_plea":
			# Spend 2 Mercy: a full heal; Empowered also cleanses and wards.
			_sfx("heal", -4.0, 0.7)
			var dp_got: int = target.heal_amount(target.max_hp, target != attacker)
			target.float_text("+%d" % dp_got, Color(0.4, 0.9, 0.45))
			_stat("healing", dp_got)
			var dp_note := ""
			if empowered:
				var dp_purged := target.purge_debuffs()
				_apply_status(target, "sanctified", 3)
				dp_note = " — cleansed %d and Hallowed 3 turns (Empowered)" % dp_purged
			elif is_perfect:
				attacker.resource = mini(attacker.resource + 10, attacker.max_resource)
				attacker.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
				attacker.refresh_bars()
			_message("%s answers with Divine Plea!" % attacker.unit_name)
			_log("%s: Divine Plea — %s is fully healed (+%d)%s" % [
				attacker.unit_name, target.unit_name, dp_got, dp_note], "#70d878")
		"healing_wave":
			var wave_heal := maxi(int(round(target.max_hp * 0.25)), 1)
			_sfx("heal", -6.0, 0.75)
			var wave_got := target.heal_amount(wave_heal, target != attacker)
			target.float_text("+%d" % wave_got, Color(0.4, 0.9, 0.45))
			_message("%s mends %s" % [attacker.unit_name, target.unit_name])
			_log("%s: Healing Wave — %s recovers %d (25%% max HP%s)" % [attacker.unit_name,
				target.unit_name, wave_got,
				", halved by Frostbite" if target.has_status("frostbite") else ""],
				"#70d878")
		"renewal":
			# Ticks snapshot the CASTER: 15% of their max health per turn,
			# Mercy-scaled at cast time.
			var ren_tick := maxi(int(round(attacker.max_hp * 0.15
				* _healing_done_mult(attacker))), 1)
			_sfx("heal", -9.0, 1.1)
			_apply_status(target, "renewal", 5, 0, ren_tick)
			target.update_status("renewal", "R+",
				"Renewal: restores %d HP at the start\nof each turn (15%% of the caster's\nmax health)." % ren_tick)
			# On the Mend rides the status: ticks can dispel (snapshotted).
			if target.has_status("renewal"):
				target.get_status("renewal")["mend"] = attacker.on_mend_ranks
			if empowered and target != attacker:
				_apply_status(attacker, "renewal", 5, 0, ren_tick)
				attacker.update_status("renewal", "R+",
					"Renewal: restores %d HP at the start\nof each turn (15%% of the caster's\nmax health)." % ren_tick)
				if attacker.has_status("renewal"):
					attacker.get_status("renewal")["mend"] = attacker.on_mend_ranks
			if is_perfect:
				var ren_burst := maxi(int(round(attacker.max_hp * 0.05
					* _heal_crit_mult(attacker))), 1)
				var burst_got: int = target.heal_amount(ren_burst, target != attacker)
				target.float_text("+%d" % burst_got, Color(0.4, 0.9, 0.45))
				_stat("healing", burst_got)
				_bank_overheal(attacker, target)
			_message("%s blesses %s with Renewal" % [attacker.unit_name, target.unit_name])
			_log("%s: Renewal on %s — %d HP/turn for 5 turns%s" % [attacker.unit_name,
				target.unit_name, ren_tick,
				" (Empowered: the Cleric too)" if empowered else ""], "#70d878")


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
		"attack": hunter.attack,  # beast blows scale with their master
		"armor": hunter.armor, "speed": hunter.speed, "stability": hunter.stability,
		"constitution": hunter.constitution, "abilities": []}
	var comp := _make_unit(cfg, hunter.position + Vector2(110, -16), stats[1],
		_hero_plate_pos(heroes.size()))
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
	# Beast blows are a % of the companion's Attack (inherited from the
	# hunter, node scaling included): Ursus 10%, Canis 20%, Aguila 15%.
	match comp.companion_kind:
		"ursus":
			await _companion_hit(comp, victim, 0.10 * comp.attack * mult, int(20 * mult))
			# The bear's sweep also mauls the enemy beside the target.
			var others := enemies.filter(func(e): return not e.dead and e != victim)
			if not others.is_empty():
				await _companion_hit(comp, others.pick_random(),
					0.10 * comp.attack * mult, int(20 * mult))
		"canis":
			await _companion_hit(comp, victim, 0.20 * comp.attack * mult, 0)
			if not victim.dead and randf() < proc_chance:
				_add_bleed_with_burst(victim, 40 if boosted else 20)
		"aguila":
			await _companion_hit(comp, victim, 0.15 * comp.attack * mult, 0)
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
					var craze := maxi(int(feaster.max_hp * 0.03 * feaster.bloodcraze), 1)
					feaster.heal_amount(craze)
					feaster.float_text("+%d Bloodcraze" % craze, Color(0.85, 0.3, 0.3))
					_log("   → Bloodcraze: %s feasts (+%d HP)" % [feaster.unit_name,
						craze], "#b0a8e0")
		_sfx("crit", -5.0, 0.8)
		_log("   → %s BLEEDS OUT for %d" % [victim.unit_name, bleed_dmg], "#e05050")
		if bleed_result.died:
			_stat("hero_deaths" if victim.is_hero else "enemy_deaths")
			_sfx("death", -4.0)
			_message("%s falls!" % victim.unit_name)
			_log("† %s dies" % victim.unit_name, "#e05050")
	else:
		# Hemorrhage (talent): enough open wounds leave the enemy Crippled
		# (threshold 80/70/60 buildup by rank).
		var hem := 0
		for h in heroes:
			if not h.dead:
				hem = maxi(hem, h.hemorrhage_ranks)
		if hem > 0 and not victim.is_hero and not victim.has_status("cripple") \
				and victim.bleed_buildup >= 90 - 10 * hem:
			_apply_status(victim, "cripple", 2)
			_log("   → Hemorrhage: %s is Crippled by blood loss" % victim.unit_name,
				"#8cc843")
		_log("   → %s: +%d Bleed (%d/100)" % [victim.unit_name, amount,
			victim.bleed_buildup], "#e08850")
	_update_talent_chips()  # Crushing Blows tracks the enemy party's bleed


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
		"mana5":
			attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
			attacker.refresh_bars()
			attacker.float_text("+5 Mana", Color(0.5, 0.7, 1.0))
			_log("   → %s recovers 5 Mana" % attacker.unit_name, "#b0a8e0")
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
			var sh_amt := maxi(int(round(attacker.max_hp * 0.05)), 1)
			var sh_got := attacker.heal_amount(sh_amt)
			attacker.float_text("+%d" % sh_got, Color(0.4, 0.9, 0.45))
			_log("   → %s recovers %d HP" % [attacker.unit_name, sh_got], "#b0a8e0")
		"sunder":
			if not target_died:
				_apply_status(target, "sunder", 2)
		"burn":
			if not target_died:
				_apply_status(target, "burn", 2, 0, _dot_tick("burn", attacker))
		"parry_up":
			_apply_status(attacker, "parry_up", 3)
			# Swordsmanship (talent): the buff parries harder — show it.
			if attacker.pommel_parry_bonus > 0.0:
				attacker.update_status("parry_up", "P+",
					"+%d%% parry chance (honed by Swordsmanship)." % \
					int(round((0.15 + attacker.pommel_parry_bonus) * 100)))


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
		sc_cancel.text = "✕ Cancel (X)"
		sc_cancel.custom_minimum_size = Vector2(94, 28)
		sc_cancel.add_theme_font_size_override("font_size", 12)
		sc_cancel.position = Vector2(358, 15)
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
		sc_cursor.position.x = 8.0 + sc_pos * SC_TRACK_W - 1.5


# Left clicks are handled in _input because UI panels (the check bar itself,
# the log, portraits) would otherwise swallow them before _unhandled_input.
# Ability hotkeys live here too so the abilities popup can't swallow them.
func _input(event: InputEvent) -> void:
	# Victory screens: Space/Enter presses the primary continue button.
	if battle_over and _end_action.is_valid() and event is InputEventKey \
			and event.pressed and not event.echo \
			and event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]:
		get_viewport().set_input_as_handled()
		var act := _end_action
		_end_action = Callable()
		act.call()
		return
	if event is InputEventKey and event.pressed and not event.echo \
			and not autoplay and not battle_over:
		# X cancels whatever cancel is on screen: a picker, a skill check,
		# or targeting.
		if event.keycode == KEY_X:
			if _item_picker != null:
				_close_item_picker()
				get_viewport().set_input_as_handled()
				return
			if _summon_picker != null:
				_close_summon_picker()
				_clear_delay_preview()
				get_viewport().set_input_as_handled()
				return
			if sc_active and sc_cancel != null:
				_cancel_skill_check()
				get_viewport().set_input_as_handled()
				return
			if not sc_active and not _kb_pool.is_empty():
				_target_picked.emit(null)
				get_viewport().set_input_as_handled()
				return
	if event is InputEventKey and event.pressed and not event.echo \
			and not sc_active and not autoplay and not battle_over:
		# Alt toggles the shared item inventory.
		if event.keycode == KEY_ALT:
			get_viewport().set_input_as_handled()
			if _item_picker != null:
				_close_item_picker()
			else:
				for p in _open_popups:
					if is_instance_valid(p) and p.visible:
						p.hide()
				_open_item_picker()
			return
		if event.keycode == KEY_TAB:
			_on_tab_pressed()
			return
		# C toggles Mercy Empowerment while the action bar is open.
		if event.keycode == KEY_C and action_panel.visible \
				and current_hero != null \
				and current_hero.second_resource_name == "Mercy" \
				and current_hero.second_resource >= 1:
			empower_armed = not empower_armed
			_show_actions(current_hero)
			get_viewport().set_input_as_handled()
			return
		if event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]:
			if _item_picker != null:
				_confirm_item(_item_idx)
				get_viewport().set_input_as_handled()
				return
			if _summon_picker != null:
				_confirm_summon(_summon_idx)
				get_viewport().set_input_as_handled()
				return
			if _kb_confirm_target():
				get_viewport().set_input_as_handled()
				return
		_try_ability_hotkey(event.keycode)
	if not sc_active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		# Clicking the Cancel button must cancel, not grade the check.
		if sc_cancel != null and sc_cancel.get_global_rect().has_point(event.position):
			return
		_grade_skill_check()


# Open ability popups are embedded Windows that swallow keys — forward theirs.
func _on_popup_window_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo \
			and not sc_active and not autoplay and not battle_over:
		if event.keycode == KEY_TAB:
			_on_tab_pressed()
		else:
			_try_ability_hotkey(event.keycode)


# Tab: cycles whichever picker is open; cycles targets while picking one;
# otherwise toggles the Abilities list during action select.
func _on_tab_pressed() -> void:
	get_viewport().set_input_as_handled()
	if _item_picker != null:
		_cycle_item()
	elif _summon_picker != null:
		_cycle_summon()
	elif not _kb_pool.is_empty():
		_cycle_kb_target()
	elif current_hero != null and action_panel.visible and _main_popup != null \
			and is_instance_valid(_main_popup):
		if _main_popup.visible:
			_main_popup.hide()
		else:
			_open_ability_popup(_main_popup, _main_popup_anchor)


func _cycle_kb_target() -> void:
	if _kb_idx >= 0 and _kb_idx < _kb_pool.size():
		_kb_pool[_kb_idx].set_highlight(false)
	_kb_idx = (_kb_idx + 1) % _kb_pool.size()
	_kb_pool[_kb_idx].set_highlight(true)


# Space/Enter confirms the Tab-selected target. False = nothing to confirm.
func _kb_confirm_target() -> bool:
	if _kb_pool.is_empty() or _kb_idx < 0:
		return false
	_target_picked.emit(_kb_pool[_kb_idx])
	return true


# Q/W/E/R/A/S/D/F pick menu entries by slot while the action bar is open.
# The summon group (W on the Beastmaster) opens the beast picker.
func _try_ability_hotkey(keycode: Key) -> void:
	if current_hero == null or not action_panel.visible:
		return
	var idx := ABILITY_KEYS.find(keycode)
	if idx < 0 or idx >= _menu_entries.size():
		return
	var entry: Dictionary = _menu_entries[idx]
	if entry.has("summons"):
		for p in _open_popups:
			if is_instance_valid(p) and p.visible:
				p.hide()
		get_viewport().set_input_as_handled()
		_open_summon_picker(current_hero)
		return
	var ab: Ability = entry["ability"]
	if not _ability_usable(current_hero, ab):
		return
	for p in _open_popups:
		if is_instance_valid(p) and p.visible:
			p.hide()
	get_viewport().set_input_as_handled()
	_on_ability_button(ab)


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
				[["Fight Again", func(): get_tree().reload_current_scene()]], true)
		else:
			_sfx("defeat", -4.0)
			_show_end("THE PARTY HAS FALLEN", "The cycle begins anew.",
				[["Fight Again", func(): get_tree().reload_current_scene()]])
		return

	# Run mode: sync state back and route through the map.
	for id in items:
		Run.items[id] = items[id][1]
	if victory:
		# Node scaling: every combat victory grows the party (+1% of base
		# Attack and HP at the next spawn).
		Run.combat_wins += 1
		for i in heroes.size():
			# Keep the saved max in sync with talents/runes/scaling so full
			# heals reach the true maximum — but battle-long Tenacity gains
			# stay in the battle.
			var save_max: int = heroes[i].max_hp - heroes[i].tenacity_hp_gained
			# The Untouched refuse to stay down: the fallen return at 20% HP.
			Run.party[i]["hp"] = clampi(maxi(heroes[i].hp, int(save_max * 0.2)),
				1, save_max)
			Run.party[i]["max_hp"] = save_max
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
					[["Descend into %s" % Run.ZONES[Run.zone_idx + 1], _next_zone]], true)
			else:
				Run.active = false
				Run.clear_save()
				_show_end("THE DECAY RECEDES", boss_text + "\nRun complete!",
					[["New Run", _start_new_run]], true)
		else:
			_show_end("VICTORY", "+%d gold. Each hero gains %d talent point%s.%s" % [
				gold_gain, pts, "" if pts == 1 else "s", elite_text],
				[["Continue", _to_map]], true)
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


var _end_action := Callable()  # victory screens: Space presses this


func _show_end(title: String, subtitle: String, buttons: Array,
		keyboard_continue := false) -> void:
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
	if keyboard_continue and not buttons.is_empty():
		_end_action = buttons[0][1]
		var hint := Label.new()
		hint.text = "— Space to continue —"
		hint.add_theme_font_size_override("font_size", 12)
		hint.add_theme_color_override("font_color", Color(0.7, 0.66, 0.58))
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(hint)


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
