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
	"frozen": ["Frozen", "Fz", Color(0.65, 0.88, 1.0), "Frozen solid: skips their turns until\nthe ice thaws."],
	"burn": ["Burn", "F", Color(1.0, 0.55, 0.2), "Burning: takes damage at the start of each\nturn (6% of the applier's Attack).\nReapplying Burn extends the duration."],
	"bleed": ["Bleed", "Bl", Color(0.85, 0.25, 0.25), "Bleed builds with wounding attacks;\nat 100 the target bleeds out for 20% max HP.\nBleed damage ignores armor."],
	"sunder": ["Sunder", "D", Color(0.7, 0.7, 0.7), "-35% armor."],
	"ward": ["Ward", "W", Color(1.0, 0.85, 0.4), "Takes 50% less Break damage."],
	"fortify": ["Fortify", "+D", Color(0.55, 0.8, 0.9), "+10% armor."],
	"barrier": ["Barrier", "Ba", Color(0.40, 0.85, 0.95), "Absorbs incoming damage."],
	"focus": ["Focus", "Fo", Color(0.35, 0.60, 1.0), "Restores 10 Mana each turn."],
	"renewal": ["Renewal", "R+", Color(0.45, 0.90, 0.50), "Restores HP at the start of each\nturn (15% of the caster's max\nhealth, set when cast)."],
	"surge": ["Surge", "A+", Color(0.80, 0.50, 1.0), "+20% attack."],
	"mocked": ["Mocked", "M!", Color(0.95, 0.5, 0.3), "Must attack the taunter."],
	"poison": ["Poison", "P", Color(0.45, 0.8, 0.3), "Takes 3 nature damage per stack at the\nstart of each turn; new stacks refresh\nthe timer."],
	"quickdraw": ["Quick Draw", "QD", Color(0.55, 0.85, 0.40), "All abilities act 50% faster;\nturns arrive sooner."],
	"parry_up": ["Parry Up", "P+", Color(0.4, 0.9, 1.0), "+15% parry chance."],
	"mana_shield": ["Mana Shield", "MS", Color(0.35, 0.6, 1.0), "50% of damage taken converts\ninto Mana."],
	"rampage": ["Rampage", "Rp", Color(0.9, 0.3, 0.3), "+1% damage per 10 Bleed buildup\non the enemy party (at cast time)."],
	"unity": ["Unity", "Un", Color(0.95, 0.85, 0.4), "Souls bound: all damage received is\nsplit evenly among the party."],
	"bewitch": ["Bewitched", "Bw", Color(0.75, 0.35, 0.85), "Charmed: basic-attacks its own\nallies, Dazing them with every\nstrike."],
	"psychosis": ["Psychosis", "Py", Color(0.82, 0.42, 0.92), "Madness: 50% each turn to turn on\nits own — attacking a fellow, or\ncasting its helpful magic on the\nenemy side."],
	"decay": ["Decay", "Dc", Color(0.62, 0.52, 0.35), "Rotting: takes 10 Break damage at\nthe start of each turn."],
	"ruin": ["Ruin", "R1", Color(0.72, 0.32, 0.82), "Marked by the Old Gods: takes 2%\nmore damage per stack; heroes\nstriking this unit heal. At 5\nstacks Ruin detonates."],
	"ruin_primed": ["Ruin (primed)", "R!", Color(0.9, 0.3, 0.9), "The Old Gods reach through: Ruin\ndetonates when this unit next\nacts."],
	"hysteria": ["Mass Hysteria", "MH", Color(0.9, 0.5, 0.9), "Next turn: strikes a fellow with\nDOUBLE Break damage, Sundering\nthem."],
	"invig": ["Invigoration", "Iv", Color(0.45, 0.6, 0.95), "Restores Mana at the start of\neach turn (Dark Pact talent)."],
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
	"blood_price": ["Blood Price", "BP", Color(0.85, 0.25, 0.25), "Paid in his own blood:\n+25% damage dealt."],
	"scent": ["Scent of Blood", "SB", Color(0.85, 0.3, 0.3), "Fed by bleedouts: bonus damage for\neach enemy bled out this battle."],
	"deathwish": ["Deathwish", "DW", Color(0.9, 0.3, 0.3), "Below 35% health: bonus damage —\nnothing left to lose."],
	"undying_rage": ["Undying Rage", "UR", Color(0.95, 0.25, 0.2), "Below 25% health: cannot die and\n+50% damage. The hit that would have\nkilled him ends it at 1 HP\n(once per battle)."],
	"shield_charges": ["Shieldwall", "SW", Color(0.65, 0.72, 0.85), "The next attacks against this unit\nare BLOCKED (one charge each)."],
	"high_guard": ["High Guard", "HG", Color(0.55, 0.80, 0.95), "Takes 25% less damage."],
	"tempo": ["Tempo", "T+", Color(0.4, 0.9, 1.0), "The pivot's momentum: bonus damage\nfor one turn (granted by switching\nstance)."],
	"killing_edge": ["Killing Edge", "KE", Color(0.95, 0.5, 0.35), "The Aggressive guard hunts the\nopening: bonus critical chance while\nthe stance holds."],
	"bracing": ["Bracing", "Br", Color(0.55, 0.80, 0.95), "The raised guard is harder to Break:\nbonus Constitution while the Defensive\nstance holds."],
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
	"roar": ["Guardian's Roar", "GR", Color(0.85, 0.60, 0.30), "The bear stands firm: takes 25%\nless damage."],
	"loyalty": ["Loyalty", "L", Color(0.95, 0.75, 0.30), "Devotion to the Beastmaster: +5%\nstrike damage per stack, plus this\nbeast's own gift. At 5 the Pack Bond\nboon is DOUBLED. Lost on death."],
	"blind": ["Blind", "Bd", Color(0.55, 0.55, 0.65), "Attacks are 50% more likely\nto miss."],
	"elusive": ["Elusiveness", "El", Color(0.55, 0.85, 0.75), "Hard to pin down: enemies are 25%\nmore likely to miss this beast."],
	"instinct": ["Hunter's Instinct", "HI", Color(0.85, 0.75, 0.35), "The next Quick Shots deal +10% of\nthe hunter's Attack and mend the\ncompanion for 15% of its max health."],
	"bestial": ["Bestial Wrath", "BW", Color(0.95, 0.40, 0.25), "The beast is unleashed — Ursus:\ndoubled health and +50% armor;\nCanis: +50% damage, +10 Bleed;\nAguila: +25% damage, strikes Blind."],
	"spirit_heal": ["Spirit Bond", "SB", Color(0.45, 0.90, 0.70), "The bond mends: heals 10% of max\nhealth at the next turn start."],
	"spirit_mana": ["Spirit Flow", "SM", Color(0.40, 0.65, 0.95), "The bond restores 5% max Mana at\neach turn start."],
	"vigor": ["Vigor", "Vg", Color(0.60, 0.90, 0.45), "Spirit Bond perfected: +10% max\nhealth while it lasts."],
	"keen_eyes": ["Eagle Eyes", "EE", Color(0.65, 0.85, 0.95), "Aguila watches over the party:\nincreased crit chance."],
	"primal_surge": ["Primal Surge", "PS", Color(0.95, 0.60, 0.25), "The spent Loyalty burns on:\n+10% damage dealt."],
	"hunt_mark": ["Marked", "Mk", Color(0.90, 0.50, 0.20), "Marked by the hunt: the Beastmaster\nand their beast deal +25% damage to\nthis enemy, and their strikes on it\nrestore the hunter's Mana."],
	"vengeance": ["Vengeance", "Vn", Color(0.85, 0.35, 0.30), "The fallen beast's boon lives on in\nthe hunter: +30% damage, and the\nPack Bond holds."],
	"held_breath": ["Held Breath", "HB", Color(0.70, 0.90, 0.60), "The next attack is a GUARANTEED\ncritical and ignores all armor."],
	"snared": ["Snared", "Sn", Color(0.75, 0.65, 0.30), "A trap waits underfoot: the next\ntime this enemy acts it is STUNNED\nfor 1 turn and Poisoned."],
	"caught": ["Caught Fast", "Cf", Color(0.75, 0.55, 0.25), "The trap's teeth hold the wound\nopen: cannot be healed."],
	"venom_coat": ["Venom Coating", "VC", Color(0.45, 0.80, 0.30), "Coated arrows: every attack applies\nPoison and refreshes its timer."],
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
# Full-run harness (Batch S): DOD_SIM_RUN=N plays N complete runs with
# progression on both sides — RunSim owns run setup, the map walk between
# battles, and the final report; this scene just fights the battles.
var run_sim := false
var debug_prints := false
var debug_enemies_off := false  # debug toggle: enemies skip their turns
var debug_locked_hero: BattleUnit = null  # debug: every turn goes to this hero
var debug_cooldowns_off := false  # debug toggle: abilities never cool down
var _rime_echoing := false  # guards Rime chill-echoes from chaining
var _bitter_echoing := false  # guards Bitter Cold freezes from cascading forever
var empower_armed := false  # Mercy: the next heal cast spends +1 stack
var _debug_popup: PopupMenu

# Accumulated across scene reloads within one simulation run.
static var sim_stats := {}
static var sim_done := 0
static var sim_started_ms := 0

# Difficulty sweep (DOD_SIM_SWEEP=1, sim.sh --sweep): run sim_target battles
# at EACH budget on the ladder and print a win-rate table — a curve where the
# single-budget report can only show one dot. sweep_stats banks each finished
# stage's sim_stats dict, in SWEEP_BUDGETS order.
const SWEEP_BUDGETS := [3, 6, 9, 12]
static var sweep_stats := []
var sweep := false
# Field-size proxy (Batch S): enemies still standing when round 3 opens
# (timeline t >= 200) — how long a wide field stays wide, which is what
# AoE actually feeds on. Recorded once per battle; battles that end
# before round 3 record their end-state count (a win records 0).
var _r3_recorded := false

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
	run_sim = int(OS.get_environment("DOD_SIM_RUN")) > 0
	sim = sim_target > 0 or run_sim
	sweep = sim_target > 0 and OS.get_environment("DOD_SIM_SWEEP") == "1"
	if run_sim and not RunSim.active:
		RunSim.begin(Run, int(OS.get_environment("DOD_SIM_RUN")))
	# DOD_SIM_RELICS="dragonbone,whetstone" arms a relic loadout for
	# standalone sims (the loadout-spread harness; relic hooks read
	# Run.active_relics regardless of Run.active). Run-sim mode arms its
	# relics at the draft instead — overriding here every battle would
	# clobber relics granted mid-run by events.
	if OS.get_environment("DOD_SIM_RELICS") != "" and not run_sim:
		Run.active_relics = OS.get_environment("DOD_SIM_RELICS").split(",")
	# DOD_SIM_GRANT_ALL=1: full-kit sims (every talent/trophy ability
	# pre-granted) — the default measures real gated progression.
	if OS.get_environment("DOD_SIM_GRANT_ALL") == "1":
		Run.debug_grant_all = true
	autoplay = sim or OS.get_environment("DOD_AUTOPLAY") == "1"
	# DOD_ENEMIES_OFF=1 arms the "Enemy attacks OFF" debug toggle from the
	# environment so headless tests can exercise the skip path.
	if OS.get_environment("DOD_ENEMIES_OFF") == "1":
		debug_enemies_off = true
	# DOD_SIM_DEBUG=1 echoes every combat-log line even in sim mode — the
	# tail of a hung run names the exact action that never resolved.
	debug_prints = (autoplay and not sim) \
		or OS.get_environment("DOD_SIM_DEBUG") == "1"
	if sim:
		Engine.max_fps = 0
		if sim_started_ms == 0:
			sim_started_ms = Time.get_ticks_msec()
	_init_items()
	_build_arena()
	_build_ui()
	_build_sfx_pool()
	_spawn_units()
	if run_sim:
		# Measure both sides as spawned — talents, scaling and slot
		# multiplier live (the run report's power table).
		RunSim.note_battle_start(Run, heroes, enemies, sim_stats)
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


# Enemy configs live in data/enemies.json (Batch 34) — this wrapper only
# resolves the zone-dependent "boss" slot, then hands off to Enemies.
# Enemy roles set base Attack like hero archetypes (Damage 100 / Tank 75 /
# Support 50); ability damage is a % of it.
func _enemy_config(kind: String) -> Dictionary:
	if kind == "boss":
		# The zone def owns its boss (rotation-safe — never keyed on slot).
		kind = Run.boss_kind() if Run.active else "withered_warden"
	return Enemies.config(kind)


func _spawn_units() -> void:
	var hero_keys := ["warrior", "mage", "cleric", "hunter"]
	if Run.active:
		hero_keys = []
		for member in Run.party:
			hero_keys.append(member["key"])
	# DOD_SIM_SPECS="berserker,cryomancer,inquisitor,beastmaster" overrides the
	# specs used by autoplay/sim battles (order: warrior, mage, cleric, hunter).
	var default_specs := ["swordmaster", "pyromancer", "holy", "sharpshooter"]
	var sim_specs := default_specs
	var env_specs := OS.get_environment("DOD_SIM_SPECS")
	if env_specs != "":
		sim_specs = Array(env_specs.split(","))
		# A short list used to index past the end at spawn — _spawn_units
		# aborted mid-loop and the enemy-less battle counted as a hollow
		# 0.2s "victory". Pad with the defaults and say so instead.
		while sim_specs.size() < hero_keys.size():
			var pad: String = default_specs[mini(sim_specs.size(), 3)]
			push_warning("DOD_SIM_SPECS: %d entries for %d heroes — slot %d padded with %s"
				% [sim_specs.size(), hero_keys.size(), sim_specs.size() + 1, pad])
			sim_specs.append(pad)
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
		# TESTING AID (Batch 31, user-requested): pre-grant every ability that
		# would normally be unlocked by talents or boss trophies, so the
		# reworked trees can be reviewed without spending points. Flip this
		# const to false to restore gated unlocks.
		if spec != "":
			cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
			cfg["passive_id"] = Classes.SPEC_INFO[spec]["passive"]
			# Once awakened, the hero goes by their spec, not their class.
			cfg["unit_name"] = Classes.SPEC_INFO[spec]["name"]
			# Spec stat block (constitution/Attack/resists, plus max_hp and
			# armor once a spec declares them) — the party sheet calls the
			# SAME helper, so the two can never drift.
			Classes.apply_spec_stats(cfg, spec)
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
			# Spec stat blocks may override max_hp (Berserker 175): re-read
			# the scaling baseline AFTER the spec block so node scaling
			# (+2% of base per win) compounds off the spec's base, not the
			# class's 154 — the ordering trap from the batch doc.
			base_hp = cfg["max_hp"]
			if Run.active and i < Run.party.size():
				Talents.apply_from_tree(cfg, Run.party[i].get("tree", []),
					Run.party[i].get("talents", {}))
				# Boss trophies: abilities picked at zone bosses (any spec pool).
				for bm_name in Run.party[i].get("bm_abilities", []):
					var bm_ab := Classes.spec_pool_ability(spec, bm_name)
					if bm_ab != null and not cfg["abilities"].any(
							func(a): return a.display_name == bm_ab.display_name):
						cfg["abilities"] = cfg["abilities"] + [bm_ab]
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
				# The same hook feeds any spec's boss-trophy pool.
				if env_abs != "" and not Classes.spec_pool(spec).is_empty():
					for ab_name in env_abs.split(","):
						var bm_pending := Classes.spec_pool_ability(spec, ab_name.strip_edges())
						if bm_pending != null and not cfg["abilities"].any(
								func(a): return a.display_name == bm_pending.display_name):
							cfg["abilities"] = cfg["abilities"] + [bm_pending]
		# Review aid: pre-grant unlockable abilities when the map-burger
		# DEBUG toggle is armed. Dedupe keys on display_name, so
		# talent-learned copies never double up.
		if Run.debug_grant_all and spec != "":
			for tn in Talents.generate_tree(spec, hero_keys[i]):
				var tn_pay: Dictionary = tn.get("payload", {})
				var tn_grant: Ability = null
				if tn_pay.has("new_ability"):
					tn_grant = Ability.make(tn_pay["new_ability"])
				elif tn_pay.has("grant_ability"):
					tn_grant = Classes.pending_talent_ability(tn_pay["grant_ability"])
				if tn_grant != null \
						and not cfg["abilities"].any(func(a): return a.display_name == tn_grant.display_name):
					cfg["abilities"] = cfg["abilities"] + [tn_grant]
			for pool_name in Classes.spec_pool(spec):
				var pool_ab := Classes.spec_pool_ability(spec, pool_name)
				if pool_ab != null \
						and not cfg["abilities"].any(func(a): return a.display_name == pool_ab.display_name):
					cfg["abilities"] = cfg["abilities"] + [pool_ab]
		# Resonance talents move the ceiling — re-read AFTER talents so
		# Resonant Core / Singularity are visible in cfg (the Mercy pattern
		# below). Singularity: no maximum (99 is "never reached in practice";
		# Backlash Ward / Unlimited Power overflow simply never fires).
		if spec == "arcanist":
			cfg["second_max"] = 5 + int(cfg.get("resonant_core_ranks", 0))
			if int(cfg.get("singularity", 0)) > 0:
				cfg["second_max"] = 99
		# Mercy talents move the ceiling and the starting line — re-read
		# them AFTER talents so Martyr's Vigor / Zealous Light are visible
		# in cfg (the Sharpshooter Focus pattern below).
		if spec == "holy":
			cfg["second_max"] = 5 + int(cfg.get("mercy_cap_bonus", 0))
			cfg["second_resource"] = mini(int(cfg.get("zealous_mercy", 0)),
				int(cfg["second_max"]))
		# Focus is the Sharpshooter's second resource (0-100; talents move
		# the ceiling and the starting line). Set AFTER talents so Deep
		# Focus / Spray of Arrows / Opening Volley are visible in cfg.
		if spec == "sharpshooter":
			cfg["second_resource_name"] = "Focus"
			cfg["second_max"] = (50 if cfg.get("spray", 0) > 0 \
				else (150 if cfg.get("deep_focus", 0) > 0 else 100))
			cfg["second_resource"] = 60 if cfg.get("opening_volley", 0) > 0 else 0
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
		# Relic hooks (see the audit atop relics.gd): numeric boons
		# aggregate across the run's relics. Outside the Run.active gate so
		# DOD_SIM_RELICS loadouts drive the same code in standalone sims.
		if not Run.active_relics.is_empty():
			cfg["dmg_bonus"] = cfg.get("dmg_bonus", 0.0) \
				+ Run.relic_add("hero_attack_mult")
			var relic_types := Run.relic_dict("dmg_type_mult")
			if not relic_types.is_empty():
				var bonuses: Dictionary = cfg.get("type_dmg_bonus", {})
				for dtype in relic_types:
					bonuses[dtype] = float(bonuses.get(dtype, 0.0)) + relic_types[dtype]
				cfg["type_dmg_bonus"] = bonuses
			cfg["max_hp_pct"] = cfg.get("max_hp_pct", 0.0) \
				+ Run.relic_add("hero_max_hp_mult")
			cfg["armor"] = float(cfg.get("armor", 0.0)) + Run.relic_add("hero_armor_add")
			cfg["speed"] = float(cfg.get("speed", 100.0)) + Run.relic_add("hero_speed_add")
			cfg["crit_bonus"] = cfg.get("crit_bonus", 0.0) + Run.relic_add("hero_crit_add")
			cfg["constitution"] = int(cfg.get("constitution", 100)
				+ Run.relic_add("hero_con_add"))
			var relic_resists := Run.relic_dict("hero_resist_add")
			if not relic_resists.is_empty():
				var res: Dictionary = cfg.get("resists", {})
				for dtype in relic_resists:
					res[dtype] = float(res.get(dtype, 0.0)) + relic_resists[dtype]
				cfg["resists"] = res
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
		# Event boons/curses: attack_pct effects bank a permanent-for-run
		# multiplier on the party member (Events "attack_pct" verb).
		if Run.active and i < Run.party.size():
			var ev_atk: float = Run.party[i].get("event_attack_pct", 0.0)
			if ev_atk != 0.0:
				cfg["attack"] = int(round(int(cfg["attack"]) * (1.0 + ev_atk)))
		# Heroes with their own art keep original colors — no slot tint.
		var hero_tint: Color = Classes.HERO_TINTS[i]
		if SPEC_ART.has(spec):
			hero_tint = Color.WHITE
		var u := _make_unit(cfg, HERO_SLOTS[i], hero_tint, _hero_plate_pos(i))
		u.crit_bonus = cfg.get("crit_bonus", 0.0)
		u.parry_bonus = cfg.get("parry_bonus", 0.0)
		u.parry_chance = cfg.get("parry_chance", -1.0)
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
			u.add_status("iron_will", "Iron Will", "-0%",
				Color(0.82, 0.58, 0.36), -1, "")
		if u.crushing_blows_ranks > 0:
			u.add_status("crushing_blows", "Crushing Blows", "+0%",
				Color(0.86, 0.44, 0.30), -1, "")
		if Run.active and i < Run.party.size():
			u.hp = clampi(Run.party[i]["hp"], 1, u.max_hp)
			if u.resource_name == "Mana":
				u.resource = clampi(Run.party[i].get("mana", u.resource), 0, u.max_resource)
			u.refresh_bars()
		# Bottled Storm: battles open with a floor under the resource tank
		# (Rage included — the warrior walks in already angry). After the
		# member-mana sync so the floor never gets overwritten.
		var res_floor := Run.relic_add("resource_floor_pct")
		if res_floor > 0.0 and u.max_resource > 0:
			u.resource = maxi(u.resource, int(res_floor * u.max_resource))
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

	# Serenity (Holy talent): the whole party carries one banked lethal
	# save — stamped like the rest, spent for everyone via the callback.
	if heroes.any(func(h): return h.serenity > 0):
		for h in heroes:
			h.serenity_guard = true
			h.serenity_cb = _on_serenity_save

	var composition: Array = ["raider", "chief", "archer", "archer"]
	# DOD_SIM_ENEMIES="boss,shieldmaster,shaman" forces the enemy lineup in
	# autoplay/sim/standalone battles (testing hook, like DOD_SIM_SPECS).
	var env_comp := OS.get_environment("DOD_SIM_ENEMIES")
	var env_theme := OS.get_environment("DOD_SIM_THEME")
	if env_comp != "":
		composition = env_comp.split(",")
	elif sweep:
		# DOD_SIM_SWEEP=1: this battle belongs to stage sim_done/sim_target —
		# roll a fresh warband at that stage's budget every battle.
		# DOD_SIM_THEME narrows the roll to one theme; otherwise any
		# fight-node theme, mirroring the real map draw. DOD_SIM_ZONE picks
		# the roster (default 1). Enemy stats stay UNSCALED here (tier 0),
		# so the sweep isolates the composition axis alone.
		var sw_stage := int(sim_done / float(sim_target))
		var sw_budget: int = SWEEP_BUDGETS[mini(sw_stage, SWEEP_BUDGETS.size() - 1)]
		var sw_zone := 1
		if OS.get_environment("DOD_SIM_ZONE") != "":
			sw_zone = maxi(int(OS.get_environment("DOD_SIM_ZONE")), 1)
		var sw_band: Array = []
		if env_theme != "":
			sw_band = Run.compose_test(env_theme, sw_budget, sw_zone)
		else:
			sw_band = Run.compose_budget(sw_budget, sw_zone)
		if sw_band.is_empty():
			push_error("DOD_SIM_SWEEP: no warband fits budget %d in zone %d" % [
				sw_budget, sw_zone])
		else:
			composition = sw_band
	elif env_theme != "":
		# DOD_SIM_THEME="Cursed Company" rolls a fresh warband of that theme
		# for EVERY sim battle (DOD_SIM_BUDGET, default 6, sets the exact
		# power spend; DOD_SIM_ZONE, default 1, picks the ROSTER id) — the
		# resist-matrix harness samples a theme's whole combo space.
		var t_budget := 6
		if OS.get_environment("DOD_SIM_BUDGET") != "":
			t_budget = maxi(int(OS.get_environment("DOD_SIM_BUDGET")), 1)
		var t_zone := 1
		if OS.get_environment("DOD_SIM_ZONE") != "":
			t_zone = maxi(int(OS.get_environment("DOD_SIM_ZONE")), 1)
		var themed: Array = Run.compose_test(env_theme, t_budget, t_zone)
		if themed.is_empty():
			push_error("DOD_SIM_THEME: no %s warband fits budget %d in zone %d" % [
				env_theme, t_budget, t_zone])
		else:
			composition = themed
	elif Run.active and Run.encounter.has("enemies"):
		composition = Run.encounter["enemies"]
	var layout: Array = ENEMY_LAYOUTS[clampi(composition.size(), 1, 6)]
	# Scaling rebase (Batch 36): each zone runs its OWN 1..11 tier ladder
	# (+4% Attack / +5% HP of base per tier), and the zone's SLOT in the
	# run applies a flat base multiplier on top (1st zone x1.0, 2nd x1.5,
	# 3rd x2.2 — Run.zone_base_mult, position not identity). Health pools
	# stay multiples of 10 (rounded UP). Standalone battles stay unscaled.
	var zone_tier := 0
	var slot_mult := 1.0
	if Run.active:
		zone_tier = clampi(Run.floor_idx + 1, 1, Run.FLOORS)
		slot_mult = Run.zone_base_mult(Run.zone_idx + 1)
	for i in composition.size():
		var cfg := _enemy_config(composition[i])
		var tint: Color = cfg["tint"]
		cfg.erase("tint")
		if zone_tier > 0:
			cfg["max_hp"] = int(ceil(cfg["max_hp"] * slot_mult
				* (1.0 + 0.05 * zone_tier) / 10.0) * 10.0)
			cfg["attack"] = int(round(cfg["attack"] * slot_mult
				* (1.0 + 0.04 * zone_tier)))
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
	u.status_expired_cb = _on_status_expired  # Lingering Torment listens
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
	_stat("enemy_count", enemies.size())
	await _wait(0.6)
	_message("The Decay stirs...")
	# The warband's theme opens the log — the composition isn't random.
	if Run.active and String(Run.encounter.get("theme", "")) != "":
		_log("Enemy warband: %s" % Run.encounter["theme"], "#c8b880")
	# Zealous Light / Martyr's Vigor (Holy talents): the Cleric opens the
	# battle with Mercy already in hand, and a deeper well to keep it in.
	for zl_h in heroes:
		if zl_h.dead or zl_h.second_resource_name != "Mercy":
			continue
		if zl_h.mercy_cap_bonus > 0:
			_log("Talent: Martyr's Vigor — %s's Mercy ceiling rises to %d" % [
				zl_h.unit_name, zl_h.second_max], "#b0a8e0")
		if zl_h.zealous_mercy > 0 and zl_h.second_resource > 0:
			_log("Talent: Zealous Light — %s opens with %d Mercy" % [
				zl_h.unit_name, zl_h.second_resource], "#b0a8e0")
	# Epidemic (Survivalist capstone): the rot is already in every vein.
	for ep_h in heroes:
		if not ep_h.dead and ep_h.epidemic > 0:
			for ep_e in enemies:
				if not ep_e.dead:
					_apply_poison(ep_h, ep_e, -1)
			_log("Epidemic: every enemy is already rotting", "#70d878")
			break
	await _wait(0.8)
	while not battle_over:
		_update_talent_chips()
		_rebuild_turn_bar()
		var u := _next_unit()
		if u == null:
			break
		# Field-size proxy: count the enemies still standing as round 3 opens
		# (every unit at speed 100 acts once per 100 timeline ticks).
		if sim and not _r3_recorded and u.next_time >= 200.0:
			_r3_recorded = true
			_stat("enemies_alive_r3",
				enemies.filter(func(e): return not e.dead).size())
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
				if dot_id == "burn":
					# Burn is fire damage: fire resists shrug the tick the same
					# way nature resists shrug poison (fire-proof stays true —
					# unless the Avatar of Flame stands; weaknesses still count).
					var fire_resist := float(u.resists.get("fire", 0.0))
					if fire_resist > 0.0 and not u.is_hero \
							and _living_hero_with("avatar_flame") != null:
						fire_resist = 0.0
					if fire_resist != 0.0:
						dot_dmg = maxi(int(round(dot_dmg * (1.0 - fire_resist))), 0)
						stack_tag += " (resisted)" if fire_resist > 0.0 else " (WEAK!)"
				# Sim bookkeeping: tick damage credits the spec that owns the
				# lane (heroes never poison/burn each other, so the status
				# names its owner: poison = Survivalist, burn = Pyromancer).
				if sim and not u.is_hero and dot_dmg > 0:
					var dot_owner := "Survivalist" if dot_id == "poison" else "Pyromancer"
					for dh in heroes:
						if dh.unit_name == dot_owner:
							_stat("dmg_hero_" + dot_owner, dot_dmg)
							break
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
		# Decay: rot gnaws at the Break meter every turn.
		if u.has_status("decay") and not u.broken:
			var decay_result: Dictionary = u.take_hit(0, 10)
			u.float_text("+%d BD" % decay_result.get("bd", 0), Color(0.62, 0.52, 0.35))
			_log("%s decays — +%d Break damage" % [u.unit_name,
				decay_result.get("bd", 0)], "#a09060")
			if decay_result.broke:
				_sfx("break", -4.0)
				_message("%s BREAKS!" % u.unit_name)
				_log("!! %s BREAKS (Decay)" % u.unit_name, "#c070e0")
		# Entropy (talent): any Ruin at all grinds the Break meter on its
		# own — 5 Break damage per rank at the bearer's every turn.
		if not u.is_hero and not u.broken and u.has_status("ruin"):
			var ent_occ := _living_occultist()
			if ent_occ != null and ent_occ.entropy_ranks > 0:
				var ent_result: Dictionary = u.take_hit(0, 5 * ent_occ.entropy_ranks)
				u.float_text("+%d BD" % ent_result.get("bd", 0), Color(0.62, 0.52, 0.35))
				_log("   → Talent: Entropy — Ruin grinds %s (+%d Break damage)" % [
					u.unit_name, ent_result.get("bd", 0)], "#b0a8e0")
				if ent_result.broke:
					_sfx("break", -4.0)
					_message("%s BREAKS!" % u.unit_name)
					_log("!! %s BREAKS (Entropy)" % u.unit_name, "#c070e0")
		# Wrath of the Old Gods: a primed Ruin detonates as its bearer stirs.
		if not u.is_hero and u.has_status("ruin_primed"):
			_detonate_ruin(u)
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
			# Living Sanctum (snapshotted on the status): the Cleric's
			# Renewal ticks echo to the party while she stands.
			if ren_stat.get("sanctum", false) and ren_got > 0:
				var sn_c := _living_hero_with("living_sanctum")
				if sn_c != null:
					_sanctum_echo(sn_c, ren_got)
		# Bulwark of Fortitude: the stand knits flesh every turn.
		if u.has_status("bulwark"):
			var bw_amt := maxi(int(round(u.max_hp * 0.10)), 1)
			var bw_tick := u.heal_amount(bw_amt, true)
			u.float_text("+%d" % bw_tick, Color(0.55, 0.75, 0.95))
			_log("%s stands fortified — regains %d HP (Bulwark)" % [
				u.unit_name, bw_tick], "#8c9cc8")
		# Zeal-lane riders (Batch K): Healing Pulse drips and Cleansing
		# Waters wash while EITHER banner — Sacred Resolve or Consecrated
		# Ground — holds. Ranks read live off the living Devout, so his
		# fall silences them (the Conviction rule).
		if u.has_status("unity") or u.has_status("cons_ground"):
			var zl_dv := _living_devout()
			if zl_dv != null:
				if zl_dv.pulse_ranks > 0 and not u.is_companion:
					var pulse_amt := maxi(int(round(
						zl_dv.max_hp * 0.02 * zl_dv.pulse_ranks)), 1)
					var pulse_got := u.heal_amount(pulse_amt, u != zl_dv)
					u.float_text("+%d" % pulse_got, Color(0.4, 0.9, 0.45))
					_log("   → Talent: Healing Pulse — %s mends %d" % [
						u.unit_name, pulse_got], "#b0a8e0")
				if zl_dv.waters_ranks > 0 and randf() < 0.15 * zl_dv.waters_ranks:
					var washed := u.dispel_one_debuff()
					if washed != "":
						u.float_text("Cleansed: %s" % washed, Color(0.5, 0.95, 0.6))
						_log("   → Talent: Cleansing Waters — the %s washes off %s" % [
							washed, u.unit_name], "#b0a8e0")
		# Fervor: the consecrated ground kindles the standing party's
		# Faith — Conviction's second source, and its only party-wide one.
		if u.is_hero and not u.is_companion and u.has_status("cons_ground"):
			var fv_dv := _living_devout()
			if fv_dv != null and fv_dv.fervor_ranks > 0:
				_log("   → Talent: Fervor — the holy ground kindles %s (+%d Faith)" % [
					u.unit_name, fv_dv.fervor_ranks], "#b0a8e0")
				_gain_faith(u, fv_dv.fervor_ranks)
		if u.has_status("focus") and u.resource_name == "Mana":
			u.resource = mini(u.resource + 10, u.max_resource)
			u.float_text("+10 Mana", Color(0.5, 0.7, 1.0))
			u.refresh_bars()
		# Invigoration (Dark Pact talent): the pact drips Mana back.
		if u.has_status("invig") and u.resource_name == "Mana":
			var iv_amt := maxi(u.status_power("invig"), 1)
			u.resource = mini(u.resource + iv_amt, u.max_resource)
			u.float_text("+%d Mana" % iv_amt, Color(0.45, 0.6, 0.95))
			u.refresh_bars()
		# Spirit Bond: the delayed mending and the mana drip.
		if u.has_status("spirit_heal"):
			var sph_got: int = u.heal_amount(maxi(u.status_power("spirit_heal"), 1))
			u.float_text("+%d" % sph_got, Color(0.4, 0.9, 0.45))
			u.refresh_bars()
			_log("   → Spirit Bond mends %s for %d" % [u.unit_name, sph_got],
				"#70d878")
		if u.has_status("spirit_mana") and u.resource_name == "Mana":
			var spm := maxi(u.status_power("spirit_mana"), 1)
			u.resource = mini(u.resource + spm, u.max_resource)
			u.float_text("+%d Mana" % spm, Color(0.45, 0.6, 0.95))
			u.refresh_bars()
		# Living Flame: a field of 3+ fires feeds the Pyromancer's reserves.
		if u.is_hero and not u.dead and u.living_flame_ranks > 0 \
				and u.resource_name == "Mana":
			var lf_n := 0
			for lf_e in enemies:
				if not lf_e.dead and lf_e.has_status("burn"):
					lf_n += 1
			if lf_n >= 3:
				var lf_mana := maxi(int(u.max_resource * 0.03 * u.living_flame_ranks), 1)
				u.resource = mini(u.resource + lf_mana, u.max_resource)
				u.float_text("+%d Mana" % lf_mana, Color(0.5, 0.7, 1.0))
				u.refresh_bars()
				_log("   → Talent: Living Flame — the blaze feeds %s (+%d Mana)" % [
					u.unit_name, lf_mana], "#b0a8e0")
		# Cryomancer upkeep (Batch O): the winter advances on its own.
		# Eternal Winter chills EVERYONE first; Winter's Grasp then deepens
		# the cold on those already caught.
		if u.is_hero and not u.dead and u.eternal_winter > 0:
			var ew_pool: Array = enemies.filter(func(e): return not e.dead)
			if not ew_pool.is_empty():
				_log("   → Capstone: Eternal Winter — the cold claims the field",
					"#7cc8f0")
				for ew_e in ew_pool:
					if not ew_e.dead:
						_apply_status(ew_e, "chilled", 3, 0, 0, u)
		if u.is_hero and not u.dead and u.grasp_ranks > 0:
			var wg_pool: Array = enemies.filter(
				func(e): return not e.dead and e.has_status("chilled"))
			wg_pool.shuffle()
			var wg_n := mini(u.grasp_ranks, wg_pool.size())
			for wg_i in wg_n:
				var wg_e: BattleUnit = wg_pool[wg_i]
				if not wg_e.dead:
					_log("   → Talent: Winter's Grasp — the cold sinks deeper into %s" % \
						wg_e.unit_name, "#b0a8e0")
					_apply_status(wg_e, "chilled", 3, 0, 0, u)
		# Survivalist upkeep: Plague Bearer spreads the rot, the Field
		# Medic tends a random ally.
		if u.is_hero and not u.dead and u.plague_bearer > 0:
			var pb_src: Array = enemies.filter(
				func(e): return not e.dead and e.has_status("poison"))
			if not pb_src.is_empty():
				var pb_from: BattleUnit = pb_src.pick_random()
				var pb_pool: Array = enemies.filter(
					func(e): return not e.dead and e != pb_from)
				if not pb_pool.is_empty():
					var pb_to: BattleUnit = pb_pool.pick_random()
					var pb_tick: int = int(pb_from.get_status("poison").get("tick", 3))
					for _pb in 3:
						_apply_status(pb_to, "poison", 5, 0, pb_tick)
					_log("   → Plague Bearer: the rot leaps from %s to %s" % [
						pb_from.unit_name, pb_to.unit_name], "#70d878")
		if u.is_hero and not u.dead and u.field_medic > 0:
			var fm_pool: Array = heroes.filter(
				func(h): return not h.dead and _status_count(h) > 0)
			if not fm_pool.is_empty():
				var fm_ally: BattleUnit = fm_pool.pick_random()
				var fm_washed: String = fm_ally.dispel_one_debuff()
				if fm_washed != "":
					fm_ally.float_text("Cleansed: %s" % fm_washed,
						Color(0.5, 0.95, 0.6))
					_log("   → Field Medic: %s washes %s off %s" % [
						u.unit_name, fm_washed, fm_ally.unit_name], "#70d878")
		# Avatar of Mercy (Holy capstone): the well refills on its own.
		if u.is_hero and not u.dead and u.avatar_of_mercy > 0 \
				and u.second_resource_name == "Mercy" \
				and u.second_resource < u.second_max:
			u.second_resource += 1
			u.float_text("+1 Mercy", Color(0.95, 0.8, 0.3))
			u.refresh_bars()
			_log("   → Capstone: Avatar of Mercy — the well rises (%d/%d)" % [
				u.second_resource, u.second_max], "#e8c860")
		# Beacon (Holy talent): as the Cleric's turn begins, her light
		# reaches everyone at death's door — no cast spent.
		if u.is_hero and not u.dead and u.beacon_ranks > 0:
			for bc_h in heroes.filter(
					func(h): return not h.dead and not h.is_companion and h.hp < h.max_hp * 0.25):
				var bc_amt := maxi(int(round(bc_h.max_hp * 0.05 * u.beacon_ranks
					* _healing_done_mult(u))), 1)
				var bc_got: int = bc_h.heal_amount(bc_amt, bc_h != u)
				bc_h.float_text("+%d" % bc_got, Color(0.95, 0.9, 0.6))
				_stat("healing", bc_got)
				_log("   → Talent: Beacon — the light finds %s (+%d)" % [
					bc_h.unit_name, bc_got], "#b0a8e0")
		# Survivalist traps spring the moment their victim moves: the snare
		# on this enemy first, then any armed deadfall (whoever acts first).
		if not u.is_hero and not u.dead and u.has_status("snared"):
			var sn_idx := u.status_power("snared")
			var sn_perfect: bool = u.get_status("snared").get("perfect", false)
			u.remove_status("snared")
			if sn_idx >= 0 and sn_idx < heroes.size() and not heroes[sn_idx].dead:
				_message("The snare springs on %s!" % u.unit_name)
				_log("%s's snare springs on %s" % [heroes[sn_idx].unit_name,
					u.unit_name], "#c8a860")
				_spring_trap(heroes[sn_idx], u, 0.0)
				_apply_poison(heroes[sn_idx], u, 6 if sn_perfect else 4)
		if not u.is_hero and not u.dead:
			for df_h in heroes:
				if not df_h.dead and df_h.deadfall_armed > 0:
					df_h.deadfall_armed -= 1
					if df_h.deadfall_armed <= 0:
						df_h.remove_status("deadfall")
					else:
						df_h.update_status("deadfall", "DF%d" % df_h.deadfall_armed,
							"Deadfall armed: the next enemy to act\nsprings it.", df_h.deadfall_armed)
					_message("The deadfall springs on %s!" % u.unit_name)
					_log("%s's deadfall springs on %s" % [df_h.unit_name,
						u.unit_name], "#c8a860")
					_spring_trap(df_h, u, 0.35 * df_h.attack)
					break
		if u.dead:
			continue
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
			u.float_text("FROZEN", Color(0.65, 0.88, 1.0))
			_log("%s is frozen solid and loses their turn" % u.unit_name, "#7cc8f0")
			# A lost turn still counts: status timers and cooldowns tick — the
			# freeze itself thaws one step here too (Cold Snap freezes hold
			# for extra turns, so the ice may outlast this loss).
			u.tick_statuses()
			u.tick_cooldowns()
			# Absolute Zero: a thaw at 4 held stacks refreezes on the spot.
			if not u.has_status("frozen") and u.status_stacks("chilled") >= 4 \
					and _living_hero_with("absolute_zero") != null:
				_log("   → Capstone: Absolute Zero — %s cannot thaw" % u.unit_name,
					"#7cc8f0")
				_apply_status(u, "frozen", 1 + _max_hero_rank("cold_snap_ranks"))
			await _wait(0.8)
			u.next_time += BASIC_DELAY * 100.0 / u.effective_speed()
			continue
		u.tick_statuses()
		u.tick_cooldowns()
		# Vigor (Spirit Bond perfect) fading: the borrowed health leaves.
		if not u.has_status("vigor") and u.vigor_hp_bonus > 0:
			u.max_hp -= u.vigor_hp_bonus
			u.hp = clampi(u.hp, 1, u.max_hp)
			u.vigor_hp_bonus = 0
			u.refresh_bars()
			_log("%s's Vigor fades" % u.unit_name, "#909090")
		# Vengeance's inherited bond leaves with the status.
		if u.vengeance_kind != "" and not u.has_status("vengeance"):
			u.vengeance_kind = ""
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
		# Vengeful Guardian (Warden capstone): the answer re-arms each of
		# his turns — one free Crushing Blow per turn, never per block.
		if u.vengeful_guardian > 0:
			u.vengeful_ready = true
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
			if u.broken_extra_turns > 0:
				# Overpower held the wound open — the window runs on.
				u.broken_extra_turns -= 1
				u.broken_pending = true
				_log("%s stays Broken (held by Overpower)" % u.unit_name, "#c070e0")
			else:
				u.recover_from_break()
				# Guard Breaker (capstone): the guard never truly returns —
				# a recovering enemy's meter refills to 50 instead of 0.
				if not u.is_hero and _living_hero_with("guard_breaker") != null:
					u.pressure = 50
					u.refresh_bars()
					u.float_text("BREAK 50", Color(0.8, 0.4, 1.0))
					_log("   → Capstone: Guard Breaker — %s's meter refills to 50" % \
						u.unit_name, "#c070e0")
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
	# Pack Bond (Aguila): the party-wide crit boon shows as a live buff chip.
	var ee_bonus := _party_crit_bonus()
	for h in heroes:
		if h.dead or h.is_companion:
			continue
		if ee_bonus > 0.0:
			var ee_pct := int(round(ee_bonus * 100))
			var ee_desc := "Eagle Eyes: Aguila's bond watches over\nthe party — +%d%% crit chance." % ee_pct
			if not h.update_status("keen_eyes", "+%d%%" % ee_pct, ee_desc, ee_pct):
				var ee_info: Array = STATUS_INFO["keen_eyes"]
				h.add_status("keen_eyes", ee_info[0], "+%d%%" % ee_pct,
					ee_info[2], -1, ee_desc, ee_pct)
		elif h.has_status("keen_eyes"):
			h.remove_status("keen_eyes")
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
		var inf_cap: int = 5 + h.heat_haze_ranks
		var inf_n: int = burning if h.avatar_flame > 0 else mini(burning, inf_cap)
		var inf_pct: int = inf_n * inf_step
		var inf_cap_txt := ("no cap — Avatar of Flame" if h.avatar_flame > 0 \
			else "up to +%d%%" % (inf_step * inf_cap))
		h.update_status("spec_passive", "+%d%%" % inf_pct,
			"Inferno Master: +%d%% damage for each burning\nenemy (%s).\nCurrently +%d%% (%d burning)." % [
				inf_step, inf_cap_txt, inf_pct, burning])
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
	# Ember Wind: a burning death releases its flame to a new host (the
	# corpse-scan pattern Seeding proved — it catches DoT deaths too).
	for foe in enemies:
		if not foe.dead or foe.ember_consumed or foe.burn_at_death <= 0:
			continue
		foe.ember_consumed = true
		if _living_hero_with("ember_wind") == null:
			continue
		var ew_pool: Array = enemies.filter(func(e): return not e.dead)
		if ew_pool.is_empty():
			continue
		var ew_t: BattleUnit = ew_pool.pick_random()
		_apply_status(ew_t, "burn", foe.burn_at_death, 0,
			maxi(foe.burn_tick_at_death, 0))
		_log("   → Talent: Ember Wind — %s's flame leaps to %s (%d turns)" % [
			foe.unit_name, ew_t.unit_name, foe.burn_at_death], "#b0a8e0")
	# Scent of Blood: the ramp chip counts the battle's bleedouts.
	for h in heroes:
		if h.dead or h.scent_ranks == 0 or h.bleedouts_this_battle == 0:
			continue
		var sc_pct: int = 3 * h.scent_ranks * h.bleedouts_this_battle
		var sc_desc := "Scent of Blood: +%d%% damage per enemy\nbled out this battle. Currently +%d%%\n(%d bleedouts)." % [
			3 * h.scent_ranks, sc_pct, h.bleedouts_this_battle]
		if not h.update_status("scent", "+%d%%" % sc_pct, sc_desc, sc_pct):
			var sc_info: Array = STATUS_INFO["scent"]
			h.add_status("scent", sc_info[0], "+%d%%" % sc_pct, sc_info[2], -1,
				sc_desc, sc_pct)
	# Deathwish / Undying Rage: edge-state chips that light while the
	# Berserker rides low health.
	for h in heroes:
		if h.dead or h.is_companion:
			continue
		if h.deathwish_ranks > 0:
			if h.hp < h.max_hp * 0.35:
				var dw_pct: int = 6 * h.deathwish_ranks
				var dw_desc := "Deathwish: +%d%% damage while below\n35%% health." % dw_pct
				if not h.update_status("deathwish", "+%d%%" % dw_pct, dw_desc, dw_pct):
					var dw_info: Array = STATUS_INFO["deathwish"]
					h.add_status("deathwish", dw_info[0], "+%d%%" % dw_pct,
						dw_info[2], -1, dw_desc, dw_pct)
			elif h.has_status("deathwish"):
				h.remove_status("deathwish")
		if h.undying_rage > 0:
			if not h.undying_rage_used and h.hp < h.max_hp * 0.25:
				if not h.has_status("undying_rage"):
					var ur_info: Array = STATUS_INFO["undying_rage"]
					h.add_status("undying_rage", ur_info[0], "UNDYING", ur_info[2],
						-1, ur_info[3])
			elif h.has_status("undying_rage"):
				h.remove_status("undying_rage")
		# Killing Edge / Bracing: stance-keyed chips that follow the
		# Swordmaster's guard (the add logs once per lighting).
		if h.killing_edge_ranks > 0:
			if h.stance == "aggressive":
				if not h.has_status("killing_edge"):
					var ke_pct: int = 4 * h.killing_edge_ranks
					var ke_info: Array = STATUS_INFO["killing_edge"]
					h.add_status("killing_edge", ke_info[0], "+%d%%" % ke_pct,
						ke_info[2], -1, ke_info[3])
					_log("   → Talent: Killing Edge — +%d%% crit while the Aggressive guard holds" % \
						ke_pct, "#b0a8e0")
			elif h.has_status("killing_edge"):
				h.remove_status("killing_edge")
		if h.bracing_ranks > 0:
			if h.stance == "defensive":
				if not h.has_status("bracing"):
					var br_con: int = 8 * h.bracing_ranks
					var br_info: Array = STATUS_INFO["bracing"]
					h.add_status("bracing", br_info[0], "+%d" % br_con,
						br_info[2], -1, br_info[3])
					_log("   → Talent: Bracing — +%d Constitution while the guard holds" % \
						br_con, "#b0a8e0")
			elif h.has_status("bracing"):
				h.remove_status("bracing")


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
	# recover) with their master. Standing at the hunter's side earns Loyalty.
	for tick_b in _beasts(u):
		_gain_loyalty(u, tick_b.companion_kind)
		# Unbroken Watch: an unbloodied beast grows more devoted.
		if u.unbroken_watch > 0 and not tick_b.damaged_since_turn:
			_gain_loyalty(u, tick_b.companion_kind)
		tick_b.damaged_since_turn = false
		# Spirit Bond's delayed mending lands before the timers tick away.
		if tick_b.has_status("spirit_heal"):
			var csb: int = tick_b.heal_amount(
				maxi(tick_b.status_power("spirit_heal"), 1))
			tick_b.float_text("+%d" % csb, Color(0.4, 0.9, 0.45))
			_log("   → Spirit Bond mends %s for %d" % [tick_b.unit_name,
				csb], "#70d878")
		tick_b.tick_statuses()
		# Bestial Wrath / Vigor fading: the borrowed bulk leaves the beast.
		if not tick_b.has_status("bestial") \
				and (tick_b.bestial_hp_bonus > 0 \
				or tick_b.bestial_armor_bonus > 0.0):
			tick_b.max_hp -= tick_b.bestial_hp_bonus
			tick_b.hp = clampi(tick_b.hp, 1, tick_b.max_hp)
			tick_b.armor -= tick_b.bestial_armor_bonus
			tick_b.bestial_hp_bonus = 0
			tick_b.bestial_armor_bonus = 0.0
			tick_b.refresh_bars()
			_log("%s's Bestial Wrath subsides" % tick_b.unit_name, "#909090")
		if not tick_b.has_status("vigor") and tick_b.vigor_hp_bonus > 0:
			tick_b.max_hp -= tick_b.vigor_hp_bonus
			tick_b.hp = clampi(tick_b.hp, 1, tick_b.max_hp)
			tick_b.vigor_hp_bonus = 0
			tick_b.refresh_bars()
		if tick_b.broken:
			tick_b.broken_pending = false
			tick_b.recover_from_break()
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
				"phoenix", "hymn", "retaliate", "unity", "tripwire",
				"mana_shield", "divine_wrath", "shield_block", "hold_the_line",
				"battle_shout", "blood_price", "flame_shield", "stabilize",
				"overcharge", "cons_ground", "bulwark", "dark_pact", "hysteria",
				"instinct", "bestial", "spirit_bond", "hold_breath",
				"venom_coat", "deadfall", "guard_change", "interpose"]:
			target = u  # self/party effects need no target choice
		elif ab.special == "summon" and not ab.display_name.ends_with("Aguila"):
			# Summons are self-casts — except the eagle, whose arrival dive
			# wants a chosen enemy (falls through to normal targeting).
			target = u
		elif ab.special == "resurrection":
			# Resurrection targets the FALLEN (the usable gate guarantees one).
			var fallen := heroes.filter(func(h): return h.dead)
			if autoplay and not fallen.is_empty():
				# The bot cannot click the picker — with 2+ fallen it would
				# await a target forever and hang the whole sim run.
				target = fallen[0]
			elif fallen.size() == 1:
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
		# Dual/triple-choice abilities pick extra, different enemies (the bot
		# skips the clicks and lets _resolve pick its extras randomly).
		# Aguila's Kill Command strikes two chosen targets.
		var kc_two := ab.special == "kill_command" \
			and _beasts(u).any(func(b): return b.companion_kind == "aguila")
		second_target = null
		third_target = null
		if target != null and (ab.choose_two or ab.choose_three or kc_two) \
				and not autoplay:
			var pool2: Array = enemies.filter(func(e): return not e.dead and e != target)
			if pool2.size() == 1:
				second_target = pool2[0]
			elif pool2.size() > 1:
				used_targeting = true
				second_target = await _pick_target(pool2)
				if second_target == null:
					target = null  # cancelled: back to the action bar
		if target != null and ab.choose_three and second_target != null:
			var pool3: Array = enemies.filter(
				func(e): return not e.dead and e != target and e != second_target)
			if pool3.size() == 1:
				third_target = pool3[0]
			elif pool3.size() > 1:
				used_targeting = true
				third_target = await _pick_target(pool3)
				if third_target == null:
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
		if autoplay:
			# The bot has no action bar to return to — a null target here is
			# a targeting bug; fall back to the basic attack on the first
			# living enemy so a sim NEVER hangs awaiting a click.
			push_warning("autoplay: null target for %s — basic-attack fallback"
				% ab.display_name)
			ab = u.abilities[0]
			auto_target = enemies.filter(func(e): return not e.dead).front()
			continue
		_preview_locked = false
		_rebuild_turn_bar()
		_show_actions(u)
		ab = await _ability_picked
		_preview_locked = true
		_rebuild_turn_bar(u, ab)
		action_panel.visible = false
	await _resolve(u, ab, target, grade)
	# Pleasure from Pain (Occultist talent): every unique affliction on the
	# enemy team feeds the party as the Occultist's turn ends.
	if u.pleasure_ranks > 0 and not u.dead and not battle_over:
		var pp_uniques := _unique_enemy_debuffs()
		if pp_uniques > 0:
			var pp_amt := maxi(int(round(u.max_hp * 0.005 * u.pleasure_ranks
				* pp_uniques)), 1)
			for pp_h in heroes.filter(func(h): return not h.dead and not h.is_companion):
				var pp_got: int = pp_h.heal_amount(pp_amt, pp_h != u)
				pp_h.float_text("+%d" % pp_got, Color(0.7, 0.4, 0.9))
				_stat("healing", pp_got)
			_log("   → Talent: Pleasure from Pain — %d unique debuff%s feed the party (%d each)" % [
				pp_uniques, "" if pp_uniques == 1 else "s", pp_amt], "#b0a8e0")
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
			# Berserker rotation (deterministic — the generic warrior policy
			# below never casts his kit, so sims would call an untested kit
			# "balanced"): Blood Price to throttle the Frenzy while healthy,
			# sweep wide, then grind single targets.
			if u.passive_id == "bloodrage":
				var bprice := _find_ability(u, "Blood Price")
				if bprice != null and u.ability_ready(bprice) \
						and u.resource < 60 and u.hp > u.max_hp * 0.4:
					return [bprice, u]
				var wild := _find_ability(u, "Wildstrikes")
				if wild != null and u.resource >= wild.cost and u.ability_ready(wild) \
						and foes.size() >= 3:
					return [wild, target_foe]
				var ramp := _find_ability(u, "Rampage")
				if ramp != null and u.resource >= ramp.cost and u.ability_ready(ramp):
					return [ramp, target_foe]
				var bz_hack := _find_ability(u, "Hack and Slash")
				if bz_hack != null and u.resource >= bz_hack.cost and u.ability_ready(bz_hack):
					return [bz_hack, target_foe]
				var blust := _find_ability(u, "Bloodlust")
				if blust != null and u.resource >= blust.cost and u.ability_ready(blust) \
						and u.hp < u.max_hp * 0.5:
					return [blust, target_foe]
				return [u.abilities[0], target_foe]  # Strike
			# Swordmaster rotation (deterministic): keep the right guard up,
			# then run the Bruiser loop — Shatterpoint timed to land the
			# Break (55+ on the meter) is how the sim proves the
			# Break-into-free-Overpower chain fires; Overpower spends the
			# meter and holds Broken targets down.
			if u.passive_id == "seasoned":
				var gchange := _find_ability(u, "Guard Change")
				var sm_want := "defensive" if u.hp < u.max_hp * 0.45 else "aggressive"
				# Tempo makes the swap itself profitable: a healthy Tempo
				# build pivots on cooldown for the buff and swaps right back.
				if gchange != null and u.ability_ready(gchange) \
						and (u.stance != sm_want \
						or (u.tempo_ranks > 0 and u.hp > u.max_hp * 0.6)):
					return [gchange, u]
				var sm_exec := _find_ability(u, "Execute")
				if sm_exec != null and u.resource >= sm_exec.cost \
						and _ability_usable(u, sm_exec):
					var sm_prey := foes.filter(func(e): return e.hp < e.max_hp * 0.2 or e.broken)
					if not sm_prey.is_empty():
						return [sm_exec, _lowest_hp(sm_prey)]
				var sm_shatter := _find_ability(u, "Shatterpoint")
				if sm_shatter != null and u.resource >= sm_shatter.cost \
						and u.ability_ready(sm_shatter) and not target_foe.broken \
						and target_foe.pressure >= 55:
					return [sm_shatter, target_foe]
				var sm_pommel := _find_ability(u, "Pommel Strike")
				if sm_pommel != null and u.resource >= sm_pommel.cost \
						and u.ability_ready(sm_pommel) \
						and not (target_foe.is_boss and not target_foe.broken):
					return [sm_pommel, target_foe]
				var sm_over := _find_ability(u, "Overpower")
				if sm_over != null and u.resource >= sm_over.cost \
						and u.ability_ready(sm_over) \
						and (target_foe.pressure >= 40 or target_foe.broken):
					return [sm_over, target_foe]
				var sm_lunge := _find_ability(u, "Lunge")
				if sm_lunge != null and u.resource >= sm_lunge.cost \
						and u.ability_ready(sm_lunge):
					return [sm_lunge, target_foe]
				var sm_sweep := _find_ability(u, "Sweeping Strikes")
				if sm_sweep != null and u.resource >= sm_sweep.cost \
						and u.ability_ready(sm_sweep) and foes.size() >= 3:
					return [sm_sweep, target_foe]
				return [u.abilities[0], target_foe]  # Strike
			# Warden rotation (deterministic): cover the party when it bleeds,
			# wall up under pressure, keep the taunt and Sunder live, refuel
			# the line, grind. Mocking Blow is free and builds 10 Rage — his
			# engine — so it is never skipped once its taunt has lapsed.
			if u.passive_id == "heavy_plating":
				var wd_idx := heroes.find(u)
				var wd_inter := _find_ability(u, "Interpose")
				if wd_inter != null and u.resource >= wd_inter.cost \
						and u.ability_ready(wd_inter) \
						and allies.filter(func(h): return not h.is_companion \
						and h != u and h.hp < h.max_hp * 0.6).size() >= 2:
					return [wd_inter, u]
				var wd_wall := _find_ability(u, "Shieldwall")
				if wd_wall != null and u.resource >= wd_wall.cost \
						and u.ability_ready(wd_wall) \
						and (u.hp < u.max_hp * 0.5 or foes.size() >= 3):
					return [wd_wall, u]
				var wd_mock := _find_ability(u, "Mocking Blow")
				if wd_mock != null and u.ability_ready(wd_mock) \
						and not foes.any(func(e): return e.has_status("mocked") \
						and e.status_power("mocked") == wd_idx):
					return [wd_mock, target_foe]
				var wd_crush := _find_ability(u, "Crushing Blow")
				if wd_crush != null and u.resource >= wd_crush.cost \
						and u.ability_ready(wd_crush) \
						and not target_foe.has_status("sunder"):
					return [wd_crush, target_foe]
				var wd_stomp := _find_ability(u, "War Stomp")
				if wd_stomp != null and u.resource >= wd_stomp.cost \
						and u.ability_ready(wd_stomp) \
						and allies.filter(func(h): return h != u \
						and h.resource_name != "" \
						and h.resource < h.max_resource * 0.7).size() >= 2:
					return [wd_stomp, target_foe]
				return [u.abilities[0], target_foe]  # Strike
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
			# Pyromancer (Batch N loop): Flamewave builds the fire, Wildfire
			# copies a grown burn to the field, Detonation cashes in whoever
			# holds the MOST — that targeting is the point of the loop.
			var burning_foes := foes.filter(func(e): return e.has_status("burn"))
			var unburnt: int = foes.size() - burning_foes.size()
			var ripest: BattleUnit = null
			var ripest_turns := 0
			for bf in burning_foes:
				var bf_turns := int(bf.get_status("burn").get("turns", 0))
				if bf_turns > ripest_turns:
					ripest_turns = bf_turns
					ripest = bf
			var fshield := _find_ability(u, "Flame Shield")
			if fshield != null and u.resource >= fshield.cost and u.ability_ready(fshield) \
					and not u.has_status("flame_shield") and u.hp < u.max_hp * 0.7:
				return [fshield, u]
			var fwave := _find_ability(u, "Flamewave")
			if fwave != null and u.resource >= fwave.cost and u.ability_ready(fwave) \
					and unburnt >= 2:
				return [fwave, target_foe]
			var wfire := _find_ability(u, "Wildfire")
			if wfire != null and u.resource >= wfire.cost and u.ability_ready(wfire) \
					and ripest_turns >= 4 and unburnt >= 2:
				return [wfire, ripest]
			var det := _find_ability(u, "Detonation")
			if det != null and u.resource >= det.cost and u.ability_ready(det) \
					and ripest_turns >= 3:
				return [det, ripest]
			var fstorm := _find_ability(u, "Firestorm")
			if fstorm != null and u.resource >= fstorm.cost and u.ability_ready(fstorm):
				return [fstorm, target_foe]
			# Arcanist: ride the Resonance engine — big spenders first.
			var wrath := _find_ability(u, "Magi's Wrath")
			if wrath != null and u.resource >= wrath.cost and u.ability_ready(wrath) \
					and foes.size() >= 3 and u.second_resource >= 3:
				return [wrath, target_foe]
			var ocharge := _find_ability(u, "Overcharge")
			if ocharge != null and u.resource >= ocharge.cost and u.ability_ready(ocharge) \
					and not u.overcharged and u.second_resource >= 4:
				return [ocharge, u]
			# Stabilize is a valve now, not a reset — vent early and often
			# (Batch P; _ability_usable covers the Still Mind floor).
			var stab := _find_ability(u, "Stabilize")
			if stab != null and u.ability_ready(stab) \
					and u.second_resource >= 4 \
					and u.hp < u.max_hp * 0.8 \
					and _ability_usable(u, stab):
				return [stab, u]
			var cannon := _find_ability(u, "Arcane Cannon")
			if cannon != null and u.resource >= cannon.cost and u.ability_ready(cannon) \
					and u.second_resource >= 2:
				return [cannon, target_foe]
			var barrage := _find_ability(u, "Arcane Barrage")
			if barrage != null and u.resource >= barrage.cost and u.ability_ready(barrage) and foes.size() >= 2:
				return [barrage, target_foe]
			# Cryomancer (Batch O): CONCENTRATE — razor the chilled toward 4,
			# lance the frozen, and let the default bolt keep feeding the
			# deepest pile instead of spreading thin.
			var most_chilled: BattleUnit = null
			for e in foes:
				if e.has_status("chilled") and (most_chilled == null \
						or e.status_stacks("chilled") > most_chilled.status_stacks("chilled")):
					most_chilled = e
			var razor := _find_ability(u, "Razor Ice")
			if razor != null and u.resource >= razor.cost and u.ability_ready(razor) \
					and most_chilled != null:
				return [razor, most_chilled]
			var lance := _find_ability(u, "Ice Lance")
			if lance != null and u.resource >= lance.cost and u.ability_ready(lance):
				var frozen_foes := foes.filter(func(e): return e.has_status("frozen"))
				if not frozen_foes.is_empty():
					return [lance, frozen_foes[0]]
				if most_chilled != null and most_chilled.status_stacks("chilled") >= 3:
					return [lance, most_chilled]
			var bliz := _find_ability(u, "Blizzard")
			if bliz != null and u.resource >= bliz.cost and u.ability_ready(bliz) \
					and foes.filter(func(e): return e.status_stacks("chilled") < 2).size() >= 3:
				return [bliz, target_foe]
			var rime_ab := _find_ability(u, "Rime")
			if rime_ab != null and u.resource >= rime_ab.cost and u.ability_ready(rime_ab):
				var rime_t: BattleUnit = most_chilled if most_chilled != null else target_foe
				if not rime_t.has_status("rime"):
					return [rime_ab, rime_t]
			var shat := _find_ability(u, "Shatter")
			if shat != null and u.resource >= shat.cost and u.ability_ready(shat) \
					and foes.filter(func(e): return e.has_status("chilled")).size() >= 2:
				return [shat, target_foe]
			if u.passive_id == "permafrost" and most_chilled != null:
				return [u.abilities[0], most_chilled]    # Frostbolt the deepest pile
			return [u.abilities[0], target_foe]          # basic bolt
		"hunter":
			# Fill every free beast slot (The Pack fields two: wolf, then
			# eagle; the bear when a preferred call is down).
			var bot_beasts: Array = _beasts(u)
			if bot_beasts.size() < _beast_cap(u):
				for want in ["canis", "aguila", "ursus"]:
					if bot_beasts.any(func(b): return b.companion_kind == want):
						continue
					var summon := _find_ability(u, "Summon " + want.capitalize())
					if summon != null and _ability_usable(u, summon):
						return [summon, u]
			# Spirit Bond when the pack is hurting.
			var sbond := _find_ability(u, "Spirit Bond")
			if sbond != null and u.resource >= sbond.cost and u.ability_ready(sbond) \
					and not bot_beasts.is_empty() \
					and (u.hp < u.max_hp * 0.6 \
					or bot_beasts.any(func(b): return b.hp < b.max_hp * 0.5)):
				return [sbond, u]
			# Unleash the beasts, then give the big order.
			var bw := _find_ability(u, "Bestial Wrath")
			if bw != null and u.resource >= bw.cost and u.ability_ready(bw) \
					and bot_beasts.any(func(b): return not b.has_status("bestial")):
				return [bw, u]
			var kill_cmd := _find_ability(u, "Kill Command")
			if kill_cmd != null and u.resource >= kill_cmd.cost and u.ability_ready(kill_cmd) \
					and not bot_beasts.is_empty():
				return [kill_cmd, target_foe]
			# Boss trophies, when owned: surge a deep bond, call the pack
			# into a crowd, keep a mark burning.
			var ps := _find_ability(u, "Primal Surge")
			if ps != null and _ability_usable(u, ps) \
					and bot_beasts.any(func(b): \
					return int(u.loyalty.get(b.companion_kind, 0)) >= 4):
				return [ps, target_foe]
			var cotw := _find_ability(u, "Call of the Wild")
			if cotw != null and _ability_usable(u, cotw) \
					and enemies.filter(func(e): return not e.dead).size() >= 3:
				return [cotw, target_foe]
			var mk := _find_ability(u, "Mark of the Hunt")
			if mk != null and _ability_usable(u, mk) \
					and not target_foe.has_status("hunt_mark"):
				return [mk, target_foe]
			# Hunter's Instinct: keep the empowered shots rolling.
			var hi := _find_ability(u, "Hunter's Instinct")
			if hi != null and u.resource >= hi.cost and u.ability_ready(hi) \
					and not u.has_status("instinct"):
				return [hi, u]
			# Sharpshooter: work one target — hold the breath, then spend it.
			var ss_t: BattleUnit = target_foe
			if u.last_attack_target != null and not u.last_attack_target.dead:
				ss_t = u.last_attack_target
			var hbreath := _find_ability(u, "Hold Breath")
			if hbreath != null and u.resource >= _eff_cost(u, hbreath) \
					and u.ability_ready(hbreath) and not u.has_status("held_breath"):
				return [hbreath, u]
			var coup := _find_ability(u, "Coup de Grâce")
			if coup != null and u.second_resource_name == "Focus" \
					and u.second_resource >= 80 and u.resource >= _eff_cost(u, coup) \
					and u.ability_ready(coup) and ss_t.hp < ss_t.max_hp * 0.6:
				return [coup, ss_t]
			var triple := _find_ability(u, "Triple Shot")
			if triple != null and u.second_resource >= 60 \
					and u.resource >= _eff_cost(u, triple) and u.ability_ready(triple):
				return [triple, ss_t]
			var called := _find_ability(u, "Called Shot")
			if called != null and u.resource >= _eff_cost(u, called) \
					and u.ability_ready(called):
				called_mode = "sunder" if ss_t.armor > 0.05 else "exposed"
				return [called, ss_t]
			var aimed := _find_ability(u, "Aimed Shot")
			if aimed != null and u.resource >= _eff_cost(u, aimed) \
					and u.ability_ready(aimed):
				return [aimed, ss_t]
			var parrow := _find_ability(u, "Poisoned Arrow")
			if parrow != null and u.resource >= parrow.cost and u.ability_ready(parrow) and randf() < 0.4 \
					and not target_foe.has_status("poison"):
				return [parrow, target_foe]
			var shrapnel := _find_ability(u, "Shrapnel Charge")
			if shrapnel != null and u.resource >= shrapnel.cost and u.ability_ready(shrapnel) and foes.size() >= 2:
				return [shrapnel, target_foe]
			# Survivalist: rig, poison broadly, then reap the board.
			var snare := _find_ability(u, "Snare Trap")
			if snare != null and u.resource >= _eff_cost(u, snare) \
					and _ability_usable(u, snare):
				return [snare, target_foe]
			var vcoat := _find_ability(u, "Venom Coating")
			if vcoat != null and u.resource >= _eff_cost(u, vcoat) \
					and u.ability_ready(vcoat) and not u.has_status("venom_coat"):
				return [vcoat, u]
			var ham := _find_ability(u, "Hamstring")
			if ham != null and u.resource >= _eff_cost(u, ham) and u.ability_ready(ham):
				return [ham, target_foe]
			var harv := _find_ability(u, "Harvest")
			if harv != null and u.resource >= _eff_cost(u, harv) \
					and u.ability_ready(harv) and _status_count(target_foe) >= 4:
				return [harv, target_foe]
			var dfall := _find_ability(u, "Deadfall")
			if dfall != null and u.resource >= _eff_cost(u, dfall) \
					and _ability_usable(u, dfall):
				return [dfall, u]
			return [u.abilities[0], ss_t]          # Quick Shot works the target
		"cleric":
			# Holy triage first (Mercy spenders), then Devout/Occultist casts.
			var res_ab := _find_ability(u, "Resurrection")
			if res_ab != null and u.second_resource >= res_ab.faith_cost \
					and u.ability_ready(res_ab):
				var fallen := heroes.filter(func(h): return h.dead)
				if not fallen.is_empty():
					empower_armed = u.avatar_of_mercy > 0 \
						or u.second_resource >= res_ab.faith_cost + 1
					return [res_ab, fallen[0]]
			var dplea := _find_ability(u, "Divine Plea")
			if dplea != null and u.second_resource >= dplea.faith_cost \
					and u.ability_ready(dplea) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.35:
				empower_armed = (u.avatar_of_mercy > 0 \
					or u.second_resource >= dplea.faith_cost + 1) \
					and weakest_ally.count_debuffs() > 0
				return [dplea, weakest_ally]
			var hymn := _find_ability(u, "Hymn of Hope")
			if hymn != null and u.second_resource >= hymn.faith_cost and u.ability_ready(hymn) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.6:
				empower_armed = u.avatar_of_mercy > 0 \
					or u.second_resource >= hymn.faith_cost + 2
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
				# Kindle whoever holds a Divine Shield — doubled Faith gain
				# is worthless without absorbs to double (the old bot sent
				# the shield to the weakest and the zeal to the hardest
				# hitter, so the two never met). Highest Attack fallback.
				var zeal_t: BattleUnit = null
				for zh in allies:
					if zh.has_status("barrier") \
							and zh.get_status("barrier").get("divine", false):
						zeal_t = zh
						break
				if zeal_t == null:
					for zh in allies:
						if zeal_t == null or zh.attack > zeal_t.attack:
							zeal_t = zh
				if not zeal_t.has_status("zeal"):
					return [zeal_ab, zeal_t]
			# Occultist: the Old Gods' toolkit.
			var pact := _find_ability(u, "Dark Pact")
			if pact != null and u.resource >= pact.cost and u.ability_ready(pact) \
					and u.hp > u.max_hp * 0.5 \
					and allies.filter(func(h): return h.hp < h.max_hp * 0.6).size() >= 2:
				return [pact, u]
			var hyst := _find_ability(u, "Mass Hysteria")
			if hyst != null and u.resource >= hyst.cost and u.ability_ready(hyst) \
					and foes.size() >= 3:
				return [hyst, u]
			var mflay := _find_ability(u, "Mind Flay")
			if mflay != null and u.resource >= mflay.cost and u.ability_ready(mflay) \
					and foes.size() >= 2:
				return [mflay, target_foe]
			var bwitch := _find_ability(u, "Bewitch")
			if bwitch != null and u.resource >= bwitch.cost and u.ability_ready(bwitch) \
					and foes.size() >= 2 and not target_foe.has_status("bewitch") \
					and not target_foe.is_boss:
				return [bwitch, target_foe]
			var hex := _find_ability(u, "Hex of Ruin")
			if hex != null and u.resource >= hex.cost and u.ability_ready(hex):
				return [hex, target_foe]
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
	# Call of the Wild lives inside the summon group, not on its own slot.
	var summons: Array = []
	for i in range(1, u.abilities.size()):
		if u.abilities[i].special in ["summon", "call_wild"]:
			summons.append(u.abilities[i])
	if not summons.is_empty():
		_menu_entries.append({"summons": summons})
	for i in range(1, u.abilities.size()):
		if u.abilities[i].special not in ["summon", "call_wild"]:
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
			# With a beast already out it becomes the Swap (10 Mana, shared 2cd).
			var swapping := _beasts(u).size() >= _beast_cap(u)
			var group_btn := Button.new()
			group_btn.text = "[%s] %s Companion ▸" % [ABILITY_KEY_NAMES[e_idx],
				"Swap" if swapping else "Summon"]
			group_btn.custom_minimum_size = Vector2(184, 30)
			group_btn.add_theme_font_size_override("font_size", 13)
			group_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			if swapping:
				group_btn.tooltip_text = "Swap the active beast (10 %s, 1.0 int,\nshared 2-turn cooldown). The newcomer\narrives with its swap effect and\n+1 Loyalty." % u.resource_name
				if u.the_pack > 0:
					group_btn.tooltip_text += "\nThe newcomer replaces the beast\nwith lower Loyalty."
				if u.cooldowns.get("Swap Companion", 0) > 0:
					group_btn.tooltip_text += "\n(Swap recovering: %d turn(s))" % \
						u.cooldowns["Swap Companion"]
			else:
				group_btn.tooltip_text = "Choose which beast answers the call.\n" \
					+ "Tab cycles the options, Space summons.\n" \
					+ ("The Pack: two beasts run at once." if u.the_pack > 0 \
					else "Only one companion at a time.")
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
		emp_btn.disabled = u.second_resource < 1 and u.avatar_of_mercy <= 0
		emp_btn.tooltip_text = "Spend +1 Mercy to Empower the next\nHeal / Renewal / Hymn / Resurrection /\nDivine Plea. Empowered casts forgo\ntheir perfect bonus. C toggles."
		emp_btn.toggled.connect(func(on: bool): empower_armed = on)
		action_box.add_child(emp_btn)
	action_panel.visible = true


# The Mana an ability actually costs this unit right now: Lone Hunter
# hunts cheap without a beast; No Beast Left arms one free summon.
func _eff_cost(u: BattleUnit, ab: Ability) -> int:
	if ab.special == "summon" and u.free_summon:
		return 0
	# Snap Shot: the first ability of the fight costs nothing.
	if u.snap_shot > 0 and not u.snap_used and ab.cost > 0:
		return 0
	var c := ab.cost
	if u.lone_hunter > 0 and _beasts(u).is_empty():
		c = int(round(c * 0.6))
	return c


# One place decides "can this ability be picked right now" so the buttons
# and the hotkeys can never disagree.
func _ability_usable(u: BattleUnit, ab: Ability) -> bool:
	if _eff_cost(u, ab) > u.resource or ab.faith_cost > u.second_resource:
		return false
	if not u.ability_ready(ab) \
			and not (ab.special == "summon" and u.free_summon):
		return false
	if ab.special in ["kill_command", "bestial", "spirit_bond"] \
			and _beasts(u).is_empty():
		return false
	# Primal Surge needs a beast with Loyalty to spend.
	if ab.special == "primal_surge":
		if not _beasts(u).any(func(b): \
				return int(u.loyalty.get(b.companion_kind, 0)) >= 1):
			return false
	# Lone Bond: one beast per fight — no swaps, no second call.
	if ab.special == "summon" and u.lone_bond > 0 and not u.kinds_summoned.is_empty():
		return false
	# Traps: one active at a time (two under Deadfall Network).
	if ab.special in ["snare_trap", "deadfall"]:
		var trap_count := u.deadfall_armed
		var u_idx := heroes.find(u)
		for e in enemies:
			if not e.dead and e.has_status("snared") \
					and e.status_power("snared") == u_idx:
				trap_count += 1
		if trap_count >= (2 if u.deadfall_network > 0 else 1):
			return false
	# Never a second beast of a kind already fielded (Loyalty keys on kind).
	if ab.special == "summon" and _beasts(u).any(func(b): \
			return b.companion_kind == ab.display_name.get_slice(" ", 1).to_lower()):
		return false
	# Swap Companion: shared cooldown (waived by Wild Rotation), and only
	# with a beast out to replace.
	if ab.special == "summon" and ab.display_name.begins_with("Swap"):
		if _beasts(u).is_empty():
			return false
		if u.cooldowns.get("Swap Companion", 0) > 0 and u.wild_rotation == 0:
			return false
	if ab.special == "resurrection" and not heroes.any(func(h): return h.dead):
		return false
	# Execute: needs an enemy below 20% health — or a Broken one; the
	# Bruiser's own loop sets up his finisher.
	if ab.display_name == "Execute" \
			and not enemies.any(func(e): return not e.dead \
			and (e.hp < e.max_hp * 0.2 or e.broken)):
		return false
	# Shatter: needs someone Chilled to detonate.
	if ab.display_name == "Shatter" \
			and not enemies.any(func(e): return not e.dead and e.has_status("chilled")):
		return false
	# Stabilize: nothing to vent unless stacks sit above the floor (2, plus
	# Still Mind ranks).
	if ab.special == "stabilize" and u.second_resource <= 2 + u.still_mind_ranks:
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
	if ab.special in ["kill_command", "bestial", "spirit_bond"] \
			and _beasts(u).is_empty():
		ab_btn.tooltip_text += "\n(No living companion)"
	if ab.special == "resurrection" and not heroes.any(func(h): return h.dead):
		ab_btn.tooltip_text += "\n(No fallen allies)"
	if ab.special == "stabilize" and u.second_resource <= 2 + u.still_mind_ranks:
		ab_btn.tooltip_text += "\n(Requires more than %d Resonance)" % (2 + u.still_mind_ranks)
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
	# At beast capacity the picker offers SWAPS instead: cheap, quick
	# clones that share one "Swap Companion" cooldown (set in _do_summon).
	var swapping := _beasts(u).size() >= _beast_cap(u)
	if swapping:
		_summon_opts = []
		for a in u.abilities:
			if a.special != "summon":
				continue
			var beast: String = a.display_name.get_slice(" ", 1)
			var swap_desc := "Swap the pack: %s arrives with its\nswap effect and +1 Loyalty.\nShared cooldown: 2 turns." % beast
			if u.the_pack > 0:
				swap_desc += "\nReplaces the beast with lower Loyalty."
			_summon_opts.append(Ability.make({"display_name": "Swap " + beast,
				"cooldown": 0, "cost": 10, "special": "summon", "delay": 1.0,
				"anim": "attack01", "no_skill_check": true,
				"perfect_id": "", "perfect_text": "",
				"description": swap_desc}))
	else:
		_summon_opts = u.abilities.filter(func(a): return a.special == "summon")
	# Call of the Wild (boss trophy) rides in the group in both modes.
	for a in u.abilities:
		if a.special == "call_wild":
			_summon_opts.append(a)
	if _summon_opts.is_empty():
		return
	_summon_picker = PanelContainer.new()
	_summon_picker.position = Vector2(480, 420)
	ui.add_child(_summon_picker)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	_summon_picker.add_child(box)
	var title := Label.new()
	title.text = ("SWAP —  Tab cycles · Space swaps · X closes" if swapping \
		else "SUMMON —  Tab cycles · Space summons · X closes")
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
var called_mode := ""  # Called Shot's chosen spot ("sunder"/"break"/"exposed")
var third_target: BattleUnit = null   # choose_three abilities (Hex of Ruin)
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
	# Called Shot picks its spot BEFORE targeting (bot auto-picks).
	if ab.display_name == "Called Shot" and called_mode == "" and not autoplay:
		_open_called_picker(ab)
		return
	_ability_picked.emit(ab)


# ---------- Called Shot spot picker (Tab cycles, Space picks, X closes) ----------

var _called_picker: PanelContainer = null


func _open_called_picker(ab: Ability) -> void:
	_close_called_picker()
	_called_picker = PanelContainer.new()
	_called_picker.position = Vector2(480, 430)
	ui.add_child(_called_picker)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	_called_picker.add_child(box)
	var title := Label.new()
	title.text = "CALLED SHOT — pick your spot"
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color(0.85, 0.80, 0.68))
	box.add_child(title)
	var modes := [["sunder", "Armor — Sunder (-35%, 2 turns)"],
		["break", "Break — +30 Break damage"],
		["exposed", "Flesh — Exposed (3 turns)"]]
	for m in modes:
		var b := Button.new()
		b.text = m[1]
		b.custom_minimum_size = Vector2(256, 30)
		b.add_theme_font_size_override("font_size", 13)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(_confirm_called.bind(str(m[0]), ab))
		box.add_child(b)


func _confirm_called(mode: String, ab: Ability) -> void:
	called_mode = mode
	_close_called_picker()
	_ability_picked.emit(ab)


func _close_called_picker() -> void:
	if _called_picker != null and is_instance_valid(_called_picker):
		_called_picker.queue_free()
	_called_picker = null


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
			buff_mult *= 1.0 + (0.15 + 0.02 * u.conduit_ranks) * _resonance_power(u)
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
	# Mass Hysteria: the maddened strike a fellow with doubled Break damage,
	# Sundering them (the status holds until they act).
	if u.has_status("hysteria"):
		u.remove_status("hysteria")
		# Acting IS the hysteria's expiry — Lingering Torment listens here
		# too (natural tick-outs go through unit.tick_statuses instead).
		_on_status_expired(u, "hysteria")
		var hys_fellows := enemies.filter(func(e): return not e.dead and e != u)
		var hys_basic := _cheapest_attack(u)
		if not hys_fellows.is_empty() and hys_basic != null:
			var hys_target: BattleUnit = hys_fellows.pick_random()
			var hys_copy: Ability = Ability.make({"display_name": hys_basic.display_name,
				"damage": hys_basic.damage, "pressure": hys_basic.pressure * 2,
				"dmg_type": hys_basic.dmg_type, "anim": hys_basic.anim,
				"applies_status": {"id": "sunder", "turns": 3}, "status_chance": 1.0})
			_message("%s lashes out in hysteria!" % u.unit_name)
			_log("%s is hysterical — turns on %s!" % [u.unit_name,
				hys_target.unit_name], "#c070e0")
			await _wait(0.4)
			await _resolve(u, hys_copy, hys_target, "good")
			return
	# Bewitch: the charmed basic-attack their own, Dazing them (the Daze is
	# the Occultist's work — it feeds Ruin).
	if u.has_status("bewitch"):
		if await _bewitched_strike(u):
			return
	# Psychosis: 50% each turn the madness takes the wheel — supports aid
	# the heroes; the rest maul their own. Spread of Madness is contagious.
	if u.has_status("psychosis"):
		var spread_r := _max_hero_rank("spread_ranks")
		if spread_r > 0 and randf() < 0.15 * spread_r:
			var sane := enemies.filter(func(e): return not e.dead and e != u and not e.has_status("psychosis") and (not e.is_boss or e.broken))
			if not sane.is_empty():
				var infected: BattleUnit = sane.pick_random()
				_log("   → Talent: Spread of Madness — the psychosis leaps to %s" % \
					infected.unit_name, "#b0a8e0")
				_apply_status(infected, "psychosis", 3)
				_gain_ruin(infected, 1)
		# Whispers (talent): the madness speaks louder — 50% base, +10%/rank.
		var psy_occ := _living_occultist()
		var psy_chance := 0.5 + ((0.10 * psy_occ.whispers_ranks) if psy_occ != null else 0.0)
		if randf() < psy_chance:
			if psy_occ != null and psy_occ.whispers_ranks > 0:
				_log("   → Talent: Whispers — the madness needs no coaxing (%d%% seized)" % \
					int(round(psy_chance * 100)), "#b0a8e0")
			var psy_support := _psychotic_support(u)
			if not psy_support.is_empty():
				_message("%s aids the enemy in its madness!" % u.unit_name)
				_log("%s is psychotic — its magic serves the heroes!" % u.unit_name,
					"#c070e0")
				await _wait(0.4)
				await _resolve(u, psy_support[0], psy_support[1], "good")
				return
			var psy_fellows := enemies.filter(func(e): return not e.dead and e != u)
			var psy_basic := _cheapest_attack(u)
			if not psy_fellows.is_empty() and psy_basic != null:
				var psy_target: BattleUnit = psy_fellows.pick_random()
				_message("%s turns on its allies!" % u.unit_name)
				_log("%s is psychotic — attacks %s!" % [u.unit_name,
					psy_target.unit_name], "#c070e0")
				await _wait(0.4)
				await _resolve(u, psy_basic, psy_target, "good")
				return
	var living := _hero_side()
	if living.is_empty():
		return
	var is_mocked := false
	if u.has_status("mocked"):
		var mocker_idx := u.status_power("mocked")
		# 100+ encodes a COMPANION taunt: the beast of heroes[idx - 100].
		# The pull prefers the bear (it does the roaring); any living
		# beast answers otherwise.
		if mocker_idx >= 100:
			var taunt_master_idx := mocker_idx - 100
			if taunt_master_idx < heroes.size():
				var tm_beasts: Array = _beasts(heroes[taunt_master_idx])
				var puller: BattleUnit = null
				for tb in tm_beasts:
					if tb.companion_kind == "ursus":
						puller = tb
				if puller == null and not tm_beasts.is_empty():
					puller = tm_beasts[0]
				if puller != null:
					living = [puller]
					is_mocked = true
		elif mocker_idx >= 0 and mocker_idx < heroes.size() and not heroes[mocker_idx].dead:
			living = [heroes[mocker_idx]]
			is_mocked = true
	# Support behaviors (Shielding, Wild Growth) — a taunt forces attacking instead.
	if not is_mocked:
		var support := _enemy_support_action(u)
		if not support.is_empty():
			await _resolve(u, support[0], support[1], "good")
			_forest_bite(u)
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
		# Savage Presence (Ursus): the LIVE bear draws 15% of attacks its
		# way, scaled by the bond tier (30% doubled, 45% under the Pact).
		for sp_c in companions:
			if not sp_c.dead and sp_c.companion_kind == "ursus" \
					and sp_c.pack_master != null and not sp_c.pack_master.dead \
					and target != sp_c:
				var sp_pull := 0.15 * _bond_mult(sp_c.pack_master, "ursus")
				if randf() < sp_pull:
					target = sp_c
					_log("   → Savage Presence: %s draws %s's attack" % [
						sp_c.unit_name, u.unit_name], "#d8b880")
				break
		# Ghillie Suit: the Survivalist fades into the brush while any
		# other ally still stands.
		if target != null and target.is_hero and not target.is_companion \
				and target.ghillie > 0 and randf() < 0.40:
			var gh_others: Array = living.filter(func(t): return t != target)
			if not gh_others.is_empty():
				target = gh_others.pick_random()
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
	# Bog Troll: knits its own flesh back together when bloodied (same
	# healing-wave machinery, self-targeted).
	var regen := _find_ability(u, "Regenerate")
	if regen != null and u.hp < u.max_hp * 0.5:
		return [regen, u]
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
# (The grant-all review aid lives on Run.debug_grant_all — toggled from
# the MAP burger, where it can still shape the next spawn.)

const MISS_CHANCE := 0.05
const PARRY_CHANCE := 0.05        # hero baseline
const ENEMY_PARRY_CHANCE := 0.025 # enemy baseline (half the hero rate)
const CRIT_CHANCE := 0.10


func _miss_chance(attacker: BattleUnit, defender: BattleUnit = null) -> float:
	# No Cover (Sharpshooter): a BYPASS, not a modifier — these attacks
	# cannot be made to miss by any current or future source.
	if attacker.no_cover > 0:
		return 0.0
	var chance := MISS_CHANCE + (0.20 if attacker.has_status("dazed") else 0.0) \
		+ (0.50 if attacker.has_status("blind") else 0.0)
	# Numbing Veil (Cryomancer talent): chilled fingers fumble the blow.
	if not attacker.is_hero and attacker.has_status("chilled"):
		chance += 0.05 * _max_hero_rank("numbing_ranks")
	# Elusiveness: the wolf and the eagle are hard to pin down.
	if defender != null and defender.has_status("elusive"):
		chance += 0.25
	return chance


# One parry roll, attributed to the slice it landed in so the log can name
# the source: base reflexes, the Sword Mastery talent, or the Parry Up buff
# (deepened by Swordsmanship). "" = no parry. A spec stat block can replace
# the baseline outright (Swordmaster 12%); Parry Up's power carries its %
# (0 = the classic 15 from a perfect Pommel; Guard Change grants 10).
func _roll_parry(defender: BattleUnit) -> String:
	var base := defender.parry_chance if defender.parry_chance >= 0.0 \
		else (PARRY_CHANCE if defender.is_hero else ENEMY_PARRY_CHANCE)
	var talent := defender.parry_bonus
	var buff := 0.0
	if defender.has_status("parry_up"):
		var pw := defender.status_power("parry_up")
		buff = (pw if pw > 0 else 15) / 100.0 + defender.pommel_parry_bonus
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
	var was_snap := attacker.snap_shot > 0 and not attacker.snap_used \
		and ab.cost > 0 and not is_counter
	attacker.resource = clampi(attacker.resource - _eff_cost(attacker, ab) \
		+ ab.resource_gain, 0, attacker.max_resource)
	attacker.refresh_bars()
	if was_snap:
		# Snap Shot: free, and the cooldown never starts.
		attacker.snap_used = true
		_log("   → Snap Shot: no cost, no cooldown", "#b0a8e0")
	elif not is_counter and not debug_cooldowns_off:
		# Improvised (Survivalist): the first ability keeps its cooldown.
		if attacker.improvised > 0 and not attacker.improvised_used \
				and ab.cooldown > 0:
			attacker.improvised_used = true
			_log("   → Improvised: no cooldown on the opener", "#b0a8e0")
		# Rapid Fire (capstone): 35% of casts skip their cooldown.
		elif attacker.rapid_fire > 0 and ab.cooldown > 0 and randf() < 0.35:
			_log("   → Rapid Fire: the cooldown never starts", "#b0a8e0")
		# Fuse (Pyromancer talent): Detonation can reset its own cooldown.
		elif ab.display_name == "Detonation" and attacker.fuse_ranks > 0 \
				and randf() < 0.15 * attacker.fuse_ranks:
			_log("   → Talent: Fuse — Detonation's cooldown resets", "#b0a8e0")
		else:
			attacker.start_cooldown(ab)
	var dmg_mult := {"perfect": 1.15, "good": 1.0, "fail": 0.6}[grade] as float
	var pr_mult := {"perfect": 1.25, "good": 1.0, "fail": 0.5}[grade] as float
	var is_perfect := grade == "perfect"
	# Shatter perfect: the echo of the blast comes back sooner (4cd).
	if is_perfect and ab.display_name == "Shatter" and not debug_cooldowns_off:
		attacker.cooldowns[ab.display_name] = 5  # 4 + the same-turn tick
	# Hex of Ruin perfect: the curse costs no cooldown at all.
	if is_perfect and ab.display_name == "Hex of Ruin":
		attacker.cooldowns.erase(ab.display_name)
	# Mass Hysteria perfect: the madness returns sooner (3cd).
	if is_perfect and ab.display_name == "Mass Hysteria" and not debug_cooldowns_off:
		attacker.cooldowns[ab.display_name] = 4  # 3 + the same-turn tick

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
			and not ab.choose_two and randf() < _miss_chance(attacker, target):
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
		elif ab.choose_two or ab.choose_three:
			var second: BattleUnit = second_target
			if second == null or second.dead or second == target:
				# Autoplay (or a lone survivor): fall back to another live foe.
				var others := enemies.filter(func(e): return not e.dead and e != target)
				second = null if others.is_empty() else others.pick_random()
			if second != null:
				strike_targets = [target, second]
			if ab.choose_three:
				var third: BattleUnit = third_target
				if third == null or third.dead or third == target or third == second:
					var rest := enemies.filter(
						func(e): return not e.dead and e != target and e != second)
					third = null if rest.is_empty() else rest.pick_random()
				if third != null:
					strike_targets.append(third)
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
			if not is_counter and (ab.multi_hits > 0 or ab.random_hits > 0
					or ab.choose_two or ab.choose_three):
				if randf() < _miss_chance(attacker, strike_target):
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
					# Heavy Plating v2: the passive's 15% plus the pity ramp —
					# +8% per unblocked hit, so blocks arrive on a cadence
					# instead of whenever the dice feel like it.
					var plating := (0.15 + strike_target.plating_bonus) \
						if strike_target.passive_id == "heavy_plating" else 0.0
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
					# Any Block resets the Heavy Plating climb (the chip follows).
					if strike_target.passive_id == "heavy_plating" \
							and strike_target.plating_bonus > 0.0:
						strike_target.plating_bonus = 0.0
						strike_target.refresh_bars()
						_log("   → Heavy Plating: the climbing bonus resets", "#8c9cc8")
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
					# Battered Not Broken: a Broken unit cannot Block at all,
					# so blocking works to hold that fate off.
					if strike_target.battered_ranks > 0 and strike_target.pressure > 0:
						var bnb := mini(8 * strike_target.battered_ranks,
							strike_target.pressure)
						strike_target.pressure -= bnb
						strike_target.refresh_bars()
						_log("   → Talent: Battered Not Broken — the block shrugs off %d Break" % bnb,
							"#b0a8e0")
					# Bruising Guard: the shield answers in Break damage — on
					# the most-attacked hero, a quiet party-wide Break engine.
					if strike_target.bruising_ranks > 0 and not attacker.dead \
							and not attacker.is_hero:
						var bg_bd := 10 * strike_target.bruising_ranks
						attacker.take_hit(0, bg_bd)
						attacker.float_text("+%d BD" % bg_bd, Color(0.8, 0.5, 1.0))
						_log("   → Talent: Bruising Guard — the block deals %d Break damage to %s" % [
							bg_bd, attacker.unit_name], "#b0a8e0")
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
					# Vengeful Guardian (capstone): the FIRST block each turn
					# is answered with a free Crushing Blow (the full ability —
					# Sundering and Elemental Weakness riders included).
					if strike_target.vengeful_guardian > 0 \
							and strike_target.vengeful_ready \
							and not attacker.dead and not attacker.is_hero:
						var vg_cb := _find_ability(strike_target, "Crushing Blow")
						if vg_cb != null:
							strike_target.vengeful_ready = false
							strike_target.float_text("VENGEFUL GUARDIAN",
								Color(0.4, 0.9, 1.0))
							_log("Capstone: Vengeful Guardian — %s answers the block with Crushing Blow" % \
								strike_target.unit_name, "#50c8e0")
							await _wait(0.4)
							await _resolve(strike_target, _free_copy(vg_cb),
								attacker, "good", true)
							if attacker.dead:
								break
					continue
				elif strike_target.passive_id == "heavy_plating" \
						and strike_target.plating_bonus < 0.40:
					# The hit got through — the plating learns: +8% Block per
					# unblocked attack (cap +40%). Bad-luck protection, not
					# choice: the on-block talents are guaranteed to fire on a
					# dependable cadence. The chip shows the live total.
					# Plate Discipline steepens the climb (+3%/rank), pulling
					# blocks to roughly every second hit instead of every third.
					var wd_climb := 0.08 \
						+ 0.03 * strike_target.plate_discipline_ranks
					strike_target.plating_bonus = minf(
						strike_target.plating_bonus + wd_climb, 0.40)
					strike_target.refresh_bars()
					if strike_target.plate_discipline_ranks > 0:
						_log("   → Talent: Plate Discipline — the plating learns +%d%% per hit" % \
							int(round(wd_climb * 100.0)), "#b0a8e0")
					_log("   → Heavy Plating: %s's Block chance climbs to %d%%" % [
						strike_target.unit_name,
						int(round((strike_target.block_chance + 0.15
						+ strike_target.plating_bonus) * 100.0))], "#8c9cc8")
			# Parry: the strike still lands, but with 75% less damage and 75%
			# less Break damage. ONLY MELEE attacks can be parried — bows and
			# spells (is_ranged attackers) sail past the blade — unless the
			# defender knows Deflection. No automatic counter — that is the
			# separate Counter Attack effect. AoE cannot be parried; Broken
			# units cannot parry. The roll's source (reflexes / Sword
			# Mastery / Parry Up) is logged.
			var parry_source := ""
			if not is_counter and not ab.aoe \
					and (not attacker.is_ranged or strike_target.deflection > 0) \
					and not strike_target.broken \
					and not strike_target.dead and not strike_target.is_companion:
				parry_source = _roll_parry(strike_target)
			var parried := parry_source != ""
			# Untouchable: in the Defensive stance the parry is absolute —
			# the hit lands NOTHING (damage, floor-of-1, and BD all zeroed).
			var wall_parry: bool = parried and strike_target.untouchable > 0 \
				and strike_target.stance == "defensive"
			if parried:
				_stat("attack_parry")
				_sfx("parry", -4.0)
				strike_target.float_text("UNTOUCHABLE" if wall_parry else "PARRY",
					Color(0.4, 0.9, 1.0))
				# Deflection: only that talent lets a ranged attack be parried.
				if attacker.is_ranged:
					_log("   → Talent: Deflection — %s turns the shot aside" % \
						strike_target.unit_name, "#b0a8e0")
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
			# Pack Bond (Aguila): the eagle's eyes serve the whole party
			# (+10% crit, scaled by the bond tier — doubled/tripled/half).
			if attacker.is_hero and not attacker.is_companion:
				crit_chance += _party_crit_bonus()
			# Precision Strikes: exploits Dazed / Crippled / Exposed targets.
			if attacker.precision_ranks > 0 and (strike_target.has_status("dazed")
					or strike_target.has_status("cripple")
					or strike_target.has_status("exposed")):
				crit_chance += 0.05 * attacker.precision_ranks
			# Seasoned Fighter (talent node): sharpens Lunge and Overpower.
			if attacker.blade_crit_ranks > 0 \
					and ab.display_name in ["Lunge", "Overpower"]:
				crit_chance += 0.03 * attacker.blade_crit_ranks
			# Killing Edge: the Aggressive guard hunts the opening.
			if attacker.killing_edge_ranks > 0 and attacker.stance == "aggressive":
				crit_chance += 0.04 * attacker.killing_edge_ranks
			# Super Nova: Detonation crits harder into the ash.
			if attacker.supernova_ranks > 0 and ab.display_name == "Detonation":
				crit_chance += 0.03 * attacker.supernova_ranks
			# Brittle Ice (talent): Frozen targets are easier to strike true.
			if strike_target.has_status("frozen"):
				crit_chance += 0.02 * _max_hero_rank("frostbite_ranks")
			# Sweeping Strikes perfect: the second swing cuts truer.
			if is_perfect and ab.display_name == "Sweeping Strikes" and hit_i == 1:
				crit_chance += 0.25
			# Lethal Aim (Sharpshooter): Focus steadies the hand — +0.5% crit
			# per point; Tunnel Vision commits wholly to the worked target.
			if attacker.passive_id == "lethal_aim" \
					and attacker.second_resource_name == "Focus":
				crit_chance += attacker.second_resource * 0.005
				if attacker.tunnel_vision > 0:
					crit_chance += (0.50 if strike_target == attacker.last_attack_target \
						else -0.50)
			var is_crit := randf() < crit_chance
			# Ice Lance: always crits against Frozen targets.
			if ab.display_name == "Ice Lance" and strike_target.has_status("frozen"):
				is_crit = true
			# White Heat: against a Burn grown 5+ turns tall (4+ at rank 2)
			# Detonation cannot glance — the setup guarantees the payoff.
			if ab.display_name == "Detonation" and attacker.white_heat_ranks > 0 \
					and strike_target.has_status("burn") \
					and int(strike_target.get_status("burn").get("turns", 0)) \
					>= (4 if attacker.white_heat_ranks >= 2 else 5):
				is_crit = true
			# Execute perfect: the killing stroke cannot glance.
			if is_perfect and ab.display_name == "Execute":
				is_crit = true
			# Held Breath: the promised shot cannot glance either.
			if attacker.has_status("held_breath") and ab.damage > 0 and not is_counter:
				is_crit = true
			any_crit = any_crit or is_crit
			# Ability damage is a PERCENT of the attacker's current Attack.
			var raw := ab.damage * 0.01 * attacker.attack * randf_range(0.9, 1.1) * dmg_mult
			if parried:
				raw *= 0.0 if wall_parry else 0.25
			if is_crit:
				# Lethal Aim x2 base; Executioner's Eye deepens it, Consistent
				# Aim trades it back to x1.5 for +30% chance.
				var crit_mult := 1.5
				if attacker.passive_id == "lethal_aim":
					crit_mult = 1.5 if attacker.consistent_aim > 0 \
						else 2.0 + 0.1 * attacker.lethal_eye_ranks
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
			# Attacker-side modifiers (Conduit deepens the base 15%/stack).
			if attacker.second_resource_name == "Resonance":
				raw *= 1.0 + (0.15 + 0.02 * attacker.conduit_ranks) \
					* _resonance_power(attacker)
			if attacker.has_status("surge"):
				raw *= 1.2
			if attacker.has_status("wrath"):
				raw *= 1.15
			# Blessing of Zeal: kindled allies strike harder.
			if attacker.has_status("zeal"):
				raw *= 1.15
			# Conviction: each Faith stack sharpens the blade (+2%) — while
			# the Devout stands.
			if attacker.is_hero and attacker.faith_stacks > 0 \
					and _living_devout() != null:
				raw *= 1.0 + 0.02 * attacker.faith_stacks
			# Dark Infusion: the Occultist feeds on the enemy team's afflictions.
			if attacker.infusion_ranks > 0:
				raw *= 1.0 + 0.02 * attacker.infusion_ranks * _unique_enemy_debuffs()
			# Arcane Cannon: the damage (not the recoil) grows with Resonance
			# (Cannoneer deepens the base 7.5%/stack).
			if ab.display_name == "Arcane Cannon":
				raw *= 1.0 + (0.075 + 0.025 * attacker.cannoneer_ranks) \
					* attacker.second_resource
			# Magi's Wrath: the storm feeds on banked Resonance.
			if ab.display_name == "Magi's Wrath":
				raw *= 1.0 + 0.04 * attacker.second_resource
			# Volatility: the big spenders escalate — recoil rises to match
			# (the bill lands in the recoil block).
			if attacker.volatility_ranks > 0 \
					and ab.display_name in ["Arcane Cannon", "Magi's Wrath"]:
				raw *= 1.0 + 0.05 * attacker.volatility_ranks
			# Suppressing Fire: every Barrage bolt bites harder than the last.
			if ab.display_name == "Arcane Barrage" and attacker.suppressing_ranks > 0 \
					and hit_i > 0:
				raw += 0.0025 * attacker.suppressing_ranks * hit_i * attacker.attack
			# Frostbolt / Razor Ice perfects: flat 25% of Attack instead.
			if is_perfect and ab.display_name in ["Frostbolt", "Razor Ice"]:
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Hunter's Instinct: empowered Quick Shots bite deeper.
			if ab.display_name == "Quick Shot" and attacker.has_status("instinct"):
				raw += 0.10 * attacker.attack
			# Master's Aim: the basic shot is the craft.
			if ab.display_name == "Quick Shot" and attacker.masters_aim_ranks > 0:
				raw += 0.06 * attacker.masters_aim_ranks * attacker.attack
			# Empowered Frostbolt (talent): the basic bolt bites deeper.
			if ab.display_name == "Frostbolt" and attacker.emp_frostbolt_ranks > 0:
				raw += 0.02 * attacker.emp_frostbolt_ranks * attacker.attack
			# Shatter: 10% of Attack PER Chilled stack on each victim.
			if ab.display_name == "Shatter":
				raw *= maxi(strike_target.status_stacks("chilled"), 1)
			# Ice Lance (Batch O): the stored cold detonates — +10% of Attack
			# per Chilled stack on the target (Crystal Edge deepens the take).
			if ab.display_name == "Ice Lance" \
					and strike_target.status_stacks("chilled") > 0:
				raw += (0.10 + 0.05 * attacker.crystal_edge_ranks) \
					* strike_target.status_stacks("chilled") * attacker.attack
			# Icy Veins: a banked kill empowers this lance.
			if ab.display_name == "Ice Lance" and attacker.icy_veins_charge > 0.0:
				raw *= 1.0 + attacker.icy_veins_charge
			# Freezing Advance: the first strike after the freeze bites deeper
			# (the mark is spent by the strike loop's last hit).
			if attacker.freezing_ranks > 0 and strike_target.freezing_adv_mark \
					and ab.damage > 0:
				raw *= 1.0 + 0.10 * attacker.freezing_ranks
			if is_perfect and ab.display_name == "Explosive Shot":
				raw = 0.12 * attacker.attack * randf_range(0.9, 1.1)
			# Fireball perfect: the bolt hits at 25% of Attack instead of 20%.
			if is_perfect and ab.display_name == "Fireball":
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Detonation: consumes the target's Burn — 150% of its remaining
			# damage (tick × turns left × 1.5) joins this hit before
			# mitigation. Blast Radius deepens the consumption +25%/rank.
			var detonated := 0
			if ab.display_name == "Detonation":
				var det := strike_target.get_status("burn")
				if not det.is_empty():
					detonated = int(round(int(det.get("tick", 6)) \
						* maxi(int(det.turns), 0) * 1.5 \
						* (1.0 + 0.25 * attacker.blast_radius_ranks)))
					raw += detonated
					strike_target.remove_status("burn")
			# Wildfire: remember the target's Burn before the hit — the
			# spread happens even if the blast finishes them.
			var wildfire_burn := {}
			if ab.display_name == "Wildfire":
				wildfire_burn = strike_target.get_status("burn").duplicate()
			# Powershot (inverted, Batch 32): +2% damage per point of the
			# target's Break bar already FULL — the team breaks them, the
			# marksman ends them (+4% with Opportunist's Aim).
			if ab.display_name == "Powershot":
				var ps_step := 4.0 if attacker.opp_aim > 0 else 2.0
				raw *= 1.0 + ps_step * clampf(
					strike_target.pressure / float(strike_target.stability), 0.0, 1.0)
			# One Shot (capstone): at maximum Focus the perfect moment arrives —
			# Aimed Shot executes below 35% health (never bosses; elites are
			# fair game), doubles otherwise.
			var one_shot_exec := false
			if ab.display_name == "Aimed Shot" and attacker.one_shot > 0 \
					and attacker.second_resource_name == "Focus" \
					and attacker.second_resource >= _focus_cap(attacker):
				if strike_target.hp < strike_target.max_hp * 0.35 \
						and not strike_target.is_boss:
					one_shot_exec = true
					_log("%s: ONE SHOT — the moment arrives" % attacker.unit_name,
						"#e8c860")
				else:
					raw *= 2.0
					_log("%s: One Shot — double damage at full Focus" % \
						attacker.unit_name, "#e8c860")
				attacker.second_resource = 0
				attacker.refresh_bars()
			# Coup de Grâce: cash out the patience — +1% of the target's
			# MISSING health per point of Focus spent.
			if ab.display_name == "Coup de Grâce" \
					and attacker.second_resource_name == "Focus" \
					and attacker.second_resource > 0:
				var cdg := attacker.second_resource
				attacker.second_resource = 0
				attacker.refresh_bars()
				raw += (strike_target.max_hp - strike_target.hp) * 0.01 * cdg
				_log("   → Coup de Grâce: %d Focus spent" % cdg, "#e0a050")
			# Bonecracker: the broken are already lost.
			if strike_target.broken and attacker.bonecracker_ranks > 0:
				raw *= 1.0 + 0.12 * attacker.bonecracker_ranks
			# Trapper (Survivalist): breadth of control IS the damage — +8%
			# per different status on the target. Force of Nature raises it
			# to +20% and lends it to the WHOLE party.
			if attacker.is_hero and not attacker.is_companion:
				var sv_n := _status_count(strike_target)
				if sv_n > 0:
					if _living_hero_with("force_of_nature") != null:
						raw *= 1.0 + 0.20 * sv_n
					elif attacker.passive_id == "trapper":
						raw *= 1.0 + 0.08 * sv_n
				# Vulture: three open wounds is a feast.
				if attacker.vulture > 0 and sv_n >= 3:
					raw *= 1.30
			# Necrosis: the poisoned rot for everyone's blades (enemies only).
			if not strike_target.is_hero and strike_target.has_status("poison") \
					and _living_hero_with("necrosis") != null:
				raw *= 1.20
			# Overpower: exploits instability — +0.5 damage per point of Break.
			if ab.display_name == "Overpower":
				raw += 0.5 * strike_target.pressure
			if attacker.has_status("empower"):
				raw *= 1.25
			# Inferno Master: the Pyromancer feeds on every fire still burning
			# (Pyromaniac deepens the per-enemy step; Heat Haze raises the
			# cap 5 -> up to 8; Avatar of Flame removes it entirely).
			if attacker.passive_id == "inferno":
				var burning := 0
				for foe in enemies:
					if not foe.dead and foe.has_status("burn"):
						burning += 1
				var inf_n: int = burning if attacker.avatar_flame > 0 \
					else mini(burning, 5 + attacker.heat_haze_ranks)
				raw *= 1.0 + 0.01 * (5 + attacker.pyromaniac_ranks) * inf_n
			# Seeding Embers: a burning death fuels the next swing.
			if attacker.has_status("seeding"):
				raw *= 1.0 + attacker.status_power("seeding") / 100.0
			# Scorched Earth: enemies wrapped in flame swing 5%/rank softer.
			if not attacker.is_hero and attacker.has_status("burn"):
				var sc_r := _max_hero_rank("scorched_ranks")
				if sc_r > 0:
					raw *= 1.0 - 0.05 * sc_r
			if attacker.has_status("cripple"):
				raw *= 0.75
			# Chilled x3: frozen muscles swing 15% softer. Hungering Cold
			# (talent) deepens the malus per stack.
			var atk_chill := attacker.status_stacks("chilled")
			if atk_chill >= 3:
				raw *= 0.85
			if atk_chill > 0:
				raw *= 1.0 - 0.01 * _max_hero_rank("hungering_ranks") * atk_chill
			# Frost Ward: the Cryomancer reads the chilled swing coming.
			if not attacker.is_hero and atk_chill > 0 \
					and strike_target.frost_ward_ranks > 0:
				raw *= 1.0 - 0.04 * strike_target.frost_ward_ranks
			# Blood Frenzy v2: +2% (plus Unstoppable) per 5% missing, never
			# below the ratcheting floor (half this battle's peak bonus) —
			# the unit-side helper ratchets and returns in one motion.
			if attacker.passive_id == "bloodrage":
				raw *= 1.0 + attacker.frenzy_bonus()
			# Enraged (talent): stacks from dropping below half HP.
			if attacker.enraged_stacks > 0 and attacker.enraged_ranks > 0:
				raw *= 1.0 + 0.03 * attacker.enraged_ranks * attacker.enraged_stacks
			# Battle Shout: fury fed by the enemy party's open wounds (at cast).
			if attacker.has_status("battle_shout"):
				raw *= 1.0 + attacker.status_power("battle_shout") / 100.0
			# Blood Price: strength bought with his own blood.
			if attacker.has_status("blood_price"):
				raw *= 1.25
			# Scent of Blood: every bleedout this battle feeds the fury.
			if attacker.scent_ranks > 0 and attacker.bleedouts_this_battle > 0:
				raw *= 1.0 + 0.03 * attacker.scent_ranks * attacker.bleedouts_this_battle
			# Deathwish: nothing left to lose below 35% health.
			if attacker.deathwish_ranks > 0 and attacker.hp < attacker.max_hp * 0.35:
				raw *= 1.0 + 0.06 * attacker.deathwish_ranks
			# Undying Rage: the refusal burns while he rides below a quarter.
			if attacker.undying_rage > 0 and not attacker.undying_rage_used \
					and attacker.hp < attacker.max_hp * 0.25:
				raw *= 1.5
			# Grudge: the damage the Warden does keep is aimed at whoever
			# he is holding — +6%/rank against targets HIS taunt binds.
			if attacker.grudge_ranks > 0 and strike_target.has_status("mocked") \
					and strike_target.status_power("mocked") == heroes.find(attacker):
				raw *= 1.0 + 0.06 * attacker.grudge_ranks
				_log("   → Talent: Grudge — +%d%% against his taunted mark" % (
					6 * attacker.grudge_ranks), "#b0a8e0")
			# Seasoned Fighter: the chosen stance decides the blade's weight —
			# Aggressive presses (talent-deepened), Defensive pulls the cut.
			if attacker.passive_id == "seasoned":
				raw *= (1.15 + attacker.seasoned_off_bonus) \
					if attacker.stance == "aggressive" else 0.90
			# Overwhelm: every wound on the target is leverage (+3%/rank per
			# debuff — the curated DEBUFF_IDS count, Broken excluded).
			if attacker.overwhelm_ranks > 0:
				var ow_n := _status_count(strike_target)
				if ow_n > 0:
					var ow_pct := 3 * attacker.overwhelm_ranks * ow_n
					raw *= 1.0 + 0.01 * ow_pct
					_log("   → Talent: Overwhelm — +%d%% (%d debuffs)" % [
						ow_pct, ow_n], "#b0a8e0")
			# Tempo: the pivot's momentum rides the next cut.
			if attacker.has_status("tempo"):
				raw *= 1.0 + attacker.status_power("tempo") / 100.0
			# Punishment / Off Balance (exclusive pair): the Broken window
			# pays out — narrow and big through Overpower, or broad and
			# small through the whole kit.
			if strike_target.broken:
				if attacker.punishment_ranks > 0 \
						and ab.display_name == "Overpower":
					raw *= 1.0 + 0.15 * attacker.punishment_ranks
					_log("   → Talent: Punishment — Overpower +%d%% vs Broken" % (
						15 * attacker.punishment_ranks), "#b0a8e0")
				if attacker.off_balance_ranks > 0:
					raw *= 1.0 + 0.05 * attacker.off_balance_ranks
					_log("   → Talent: Off Balance — +%d%% vs Broken" % (
						5 * attacker.off_balance_ranks), "#b0a8e0")
			# Pack Bond (Canis): the hunter runs down wounded prey — +15%
			# damage per enemy under 35% health, scaled by the bond tier.
			if attacker.is_hero and attacker.passive_id == "pack":
				var bm_canis := _bond_mult(attacker, "canis")
				if bm_canis > 0.0:
					var bm_wounded := enemies.filter(func(en): return not en.dead and en.hp < en.max_hp * 0.35).size()
					if bm_wounded > 0:
						raw *= 1.0 + 0.15 * bm_canis * bm_wounded
				# The hunt's other fires: Primal Surge, Vengeance, the lone
				# hunter's focus, and the marked prey.
				if attacker.has_status("primal_surge"):
					raw *= 1.10
				if attacker.has_status("vengeance"):
					raw *= 1.30
				if attacker.lone_hunter > 0 and _beasts(attacker).is_empty():
					raw *= 1.25
				if strike_target.has_status("hunt_mark") \
						and strike_target.status_power("hunt_mark") == heroes.find(attacker):
					raw *= 1.25
			raw *= 1.0 + attacker.dmg_bonus + float(attacker.type_dmg_bonus.get(ab.dmg_type, 0.0))
			# Target-side modifiers. Arcane Ward softens the Resonance penalty
			# (5% → 2%/stack); Singularity stops it rising past 5 stacks.
			if strike_target.second_resource_name == "Resonance":
				var res_pen := _resonance_power(strike_target)
				if strike_target.singularity > 0:
					res_pen = minf(res_pen, 5.0)
				raw *= 1.0 + (0.05 - 0.01 * strike_target.arcane_ward_ranks) * res_pen
			# Savage Presence (Ursus): the bear stands between the hunter and
			# harm — 10% less damage taken, scaled by the bond tier.
			if strike_target.is_hero and strike_target.passive_id == "pack":
				var sp_ursus := _bond_mult(strike_target, "ursus")
				if sp_ursus > 0.0:
					raw *= 1.0 - 0.10 * sp_ursus
			# Stabilized: grounded resonance blunts incoming blows.
			if strike_target.has_status("stabilized"):
				raw *= 1.0 - strike_target.status_power("stabilized") / 100.0
			# Consecrated Ground: holy footing blunts the blow.
			if strike_target.has_status("cons_ground"):
				raw *= 0.85
			# Conviction: each Faith stack turns the blade (3%) — while the
			# Devout stands.
			if strike_target.is_hero and strike_target.faith_stacks > 0 \
					and _living_devout() != null:
				raw *= 1.0 - 0.03 * strike_target.faith_stacks
			# Iron Will: adversity hardens the Warden — 4%/rank less damage
			# taken per debuff on him (the chip tracks the live total; the
			# floor is a sanity clamp for absurd debuff piles).
			if strike_target.iron_will_ranks > 0:
				var iw_n := strike_target.count_debuffs()
				if iw_n > 0:
					var iw_pct := 4 * strike_target.iron_will_ranks * iw_n
					raw *= maxf(1.0 - 0.01 * iw_pct, 0.1)
					_log("   → Talent: Iron Will — -%d%% (%d debuffs)" % [
						iw_pct, iw_n], "#b0a8e0")
			# Shared Vigil: the line holds while the Warden stands tall —
			# allies take less while he is above half health.
			if strike_target.is_hero and not strike_target.is_companion:
				var sv_w := _living_hero_with("shared_vigil_ranks")
				if sv_w != null and sv_w != strike_target \
						and sv_w.hp > sv_w.max_hp * 0.5:
					raw *= 1.0 - 0.03 * sv_w.shared_vigil_ranks
					_log("   → Talent: Shared Vigil — %s is covered (-%d%%)" % [
						strike_target.unit_name,
						3 * sv_w.shared_vigil_ranks], "#b0a8e0")
			# Blessed Vestments: Renewal wraps its bearer in cloth-of-light
			# — the blessing rides the status, while the Cleric stands.
			if strike_target.is_hero and not strike_target.is_companion \
					and strike_target.has_status("renewal"):
				var bv_w := _living_hero_with("vestments_ranks")
				if bv_w != null:
					raw *= 1.0 - 0.05 * bv_w.vestments_ranks
					_log("   → Talent: Blessed Vestments — Renewal shields %s (-%d%%)" % [
						strike_target.unit_name,
						5 * bv_w.vestments_ranks], "#b0a8e0")
			# Ruin: the Old Gods' mark cracks the target open (+2%/stack;
			# Deeper Hex widens every crack by 1%/rank).
			if not strike_target.is_hero and strike_target.has_status("ruin"):
				var ruin_occ := _living_occultist()
				if ruin_occ != null:
					raw *= 1.0 + (0.02 + 0.01 * ruin_occ.deep_hex_ranks) \
						* strike_target.status_stacks("ruin")
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
			# Guardian's Roar: the bear weathers the storm.
			if strike_target.has_status("roar"):
				raw *= 0.75
			if strike_target.dmg_taken_bonus > 0.0:
				raw *= 1.0 + strike_target.dmg_taken_bonus
			# Seasoned Fighter: the guard decides what gets through — Defensive
			# turns blows aside (talent-deepened), Aggressive leaves openings.
			if strike_target.passive_id == "seasoned":
				raw *= 1.10 if strike_target.stance == "aggressive" \
					else (0.85 - strike_target.seasoned_def_bonus)
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
			# Avatar of Flame: the Pyromancer's fire ignores fire RESISTANCE
			# (weaknesses — negative resists — still count in full).
			if ab.dmg_type == "fire" and attacker.avatar_flame > 0 and resist > 0.0:
				resist = 0.0
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
			# Held Breath's promised shot and Through and Through ignore armor
			# entirely; a One Shot execution punches through everything.
			if attacker.through_and_through > 0 \
					or attacker.has_status("held_breath") or one_shot_exec:
				effective_armor = 0.0
			# The universal floor of 1 yields to Untouchable's absolute parry.
			var final := 0 if wall_parry \
				else maxi(int(round(raw * (1.0 - effective_armor))), 1)
			if one_shot_exec:
				final = maxi(strike_target.hp, final)
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
				# Untouchable's absolute parry turns the Break away too.
				pr = 0 if wall_parry else int(round(pr * 0.25))
			# Wildstrikes opts out: its perfect pays in Bleed, not BD (07-27).
			if is_perfect and (ab.perfect_id == "pressure" or ab.aoe) \
					and ab.display_name != "Wildstrikes":
				pr = int(pr * 1.5)
			if is_perfect and ab.display_name == "Crushing Blow":
				pr += 5
			if is_perfect and ab.display_name == "Shatterpoint":
				pr += 15
			if is_perfect and ab.display_name == "Ice Lance":
				pr = 20
			# Pressure Point / Sunder Guard: the Breaker lane loads his two
			# Break blows heavier.
			if attacker.pressure_point_ranks > 0 \
					and ab.display_name == "Pommel Strike":
				pr += 8 * attacker.pressure_point_ranks
				_log("   → Talent: Pressure Point — +%d BD" % (
					8 * attacker.pressure_point_ranks), "#b0a8e0")
			if attacker.sunder_guard_ranks > 0 \
					and ab.display_name == "Shatterpoint":
				pr += 8 * attacker.sunder_guard_ranks
				_log("   → Talent: Sunder Guard — +%d BD" % (
					8 * attacker.sunder_guard_ranks), "#b0a8e0")
			# Broken Will: the Occultist grinds stability down harder.
			if attacker.broken_will_ranks > 0:
				pr = int(round(pr * (1.0 + 0.05 * attacker.broken_will_ranks)))
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
			# Wrath of the Old Gods: heroes striking a Ruined target drink
			# deep (10% of damage dealt; Soul Leech and Gluttony deepen the
			# draught on separate dials).
			if attacker.is_hero and not strike_target.is_hero and final > 0 \
					and strike_target.has_status("ruin") and not attacker.dead:
				var occ_leech := _living_occultist()
				if occ_leech != null:
					var leech_pct := 0.10 + 0.05 * occ_leech.soul_leech_ranks \
						+ 0.03 * occ_leech.gluttony_ranks
					var rl_heal := maxi(int(round(final * leech_pct)), 1)
					var rl_got: int = attacker.heal_amount(rl_heal)
					attacker.float_text("+%d" % rl_got, Color(0.7, 0.4, 0.9))
					_stat("healing", rl_got)
					# The base draught stays silent (float text only); the
					# deepened one logs so the talent's work is auditable.
					if occ_leech.gluttony_ranks > 0:
						_log("   → Talent: Gluttony — %s drinks %d from the Ruined (%d%%)" % [
							attacker.unit_name, rl_got, int(round(leech_pct * 100))], "#b0a8e0")
					# Soul Glut (capstone): the siphon feeds every mouth at
					# the table — the whole party drinks the same draught.
					if occ_leech.soul_glut > 0:
						for sg_h in heroes.filter(func(he): return not he.dead and not he.is_companion):
							if sg_h == attacker:
								continue
							var sg_got: int = sg_h.heal_amount(rl_heal, sg_h != occ_leech)
							sg_h.float_text("+%d" % sg_got, Color(0.7, 0.4, 0.9))
							_stat("healing", sg_got)
						_log("   → Talent: Soul Glut — the whole party drinks (+%d each)" % \
							rl_heal, "#b0a8e0")
			# Madness plumbing (Batch L): an enemy striking its FELLOW feeds
			# the engine — the victim's wound festers into Ruin (Delirium)
			# and the party drinks a share of it (Cackling Mirror). Every
			# enemy-on-enemy strike is madness-driven (Psychosis / Bewitch /
			# Hysteria) by construction: no other enemy path attacks its own.
			if not attacker.is_hero and not strike_target.is_hero and final > 0:
				var mad_occ := _living_occultist()
				if mad_occ != null:
					if mad_occ.delirium_ranks > 0 and not strike_target.dead:
						_gain_ruin(strike_target, mad_occ.delirium_ranks)
						_log("   → Talent: Delirium — the betrayal marks %s (+%d Ruin)" % [
							strike_target.unit_name, mad_occ.delirium_ranks], "#b0a8e0")
					if mad_occ.cackling_ranks > 0:
						var ck_amt := maxi(int(round(final * 0.03 * mad_occ.cackling_ranks)), 1)
						for ck_h in heroes.filter(func(he): return not he.dead and not he.is_companion):
							var ck_got: int = ck_h.heal_amount(ck_amt, ck_h != mad_occ)
							ck_h.float_text("+%d" % ck_got, Color(0.7, 0.4, 0.9))
							_stat("healing", ck_got)
						_log("   → Talent: Cackling Mirror — the party drinks %d from the wound" % \
							ck_amt, "#b0a8e0")
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
			# Steadfast (Warden talent): what would fell an ally, he takes on
			# himself — 15%/rank of a blow that would leave them below 20%
			# health is absorbed instead (Pressure still lands on the struck
			# hero alone, like Unity).
			if final > 1 and strike_target.is_hero \
					and not strike_target.is_companion:
				var sf_w := _living_hero_with("steadfast_ranks")
				if sf_w != null and sf_w != strike_target \
						and strike_target.hp - final < int(strike_target.max_hp * 0.20):
					var sf_part := mini(maxi(int(round(
						final * 0.15 * sf_w.steadfast_ranks)), 1), final - 1)
					final -= sf_part
					var sf_res: Dictionary = sf_w.take_hit(sf_part, 0)
					sf_w.float_text("-%d Steadfast" % sf_part, Color(0.95, 0.85, 0.4))
					_log("   → Talent: Steadfast — %s absorbs %d of the blow meant for %s" % [
						sf_w.unit_name, sf_part, strike_target.unit_name], "#b0a8e0")
					if sf_res.died:
						_stat("hero_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % sf_w.unit_name)
						_log("† %s dies" % sf_w.unit_name, "#e05050")
			var hp_before := strike_target.hp
			var was_broken := strike_target.broken
			var result: Dictionary = strike_target.take_hit(final, pr)
			if not sim and not result.died:
				strike_target.hit_react((strike_target.position - attacker.position).normalized())
			# Overpower: a blow into an already-Broken guard holds the wound
			# open — the target stays Broken one turn longer (window-extender;
			# a hit that CAUSES the Break doesn't also extend it).
			if ab.display_name == "Overpower" and was_broken \
					and attacker.is_hero and not strike_target.dead:
				strike_target.broken_extra_turns += 1
				strike_target.float_text("HELD BROKEN", Color(0.8, 0.4, 1.0))
				_log("   → Overpower holds %s Broken one turn longer" % \
					strike_target.unit_name, "#c070e0")
			# Sharpshooter on-crit riders: Perfect Form, Sundering Shot,
			# Exposed Nerve, Follow-Through, Through and Through's refund.
			if is_crit and attacker.is_hero and not is_counter:
				if attacker.perfect_form > 0:
					_gain_focus(attacker, 20)
				if attacker.sundering_shot > 0 and not strike_target.dead:
					strike_target.take_hit(0, 15)
				if attacker.exposed_nerve > 0 and not strike_target.dead:
					_apply_status(strike_target, "exposed", 3)
				if attacker.follow_through > 0 and not attacker.cooldowns.is_empty():
					for cd_key in attacker.cooldowns.keys():
						attacker.cooldowns[cd_key] = maxi(
							int(attacker.cooldowns[cd_key]) - 1, 0)
					_log("   → Follow-Through: cooldowns tick", "#b0a8e0")
				if attacker.through_and_through > 0 and ab.cost > 0:
					attacker.resource = mini(attacker.resource + ab.cost,
						attacker.max_resource)
					attacker.refresh_bars()
			# Overkill: the excess of a killing blow carries onward, full value.
			if result.died and attacker.overkill > 0 and not strike_target.is_hero:
				var excess := final - hp_before
				if excess > 0:
					var ok_pool := enemies.filter(
						func(e): return not e.dead and e != strike_target)
					if not ok_pool.is_empty():
						var ok_t: BattleUnit = _lowest_hp(ok_pool)
						var ok_res: Dictionary = ok_t.take_hit(excess, 0)
						ok_t.float_text("%d Overkill" % excess, Color(0.95, 0.6, 0.3))
						_log("   → Overkill: %d carries to %s" % [excess,
							ok_t.unit_name], "#e0a050")
						if ok_res.died:
							_stat("enemy_deaths")
							_sfx("death", -4.0)
							_message("%s falls!" % ok_t.unit_name)
							_log("† %s dies" % ok_t.unit_name, "#e05050")
							_on_enemy_death(ok_t)
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
				resist_tag += " (parried — UNTOUCHABLE)" if wall_parry \
					else " (parried -75%% — %s)" % parry_source
			_log("%s: %s on %s — %d %s dmg%s%s, +%d BD%s" % [attacker.unit_name,
				ab.display_name, strike_target.unit_name, final, ab.dmg_type,
				" CRIT" if is_crit else "", resist_tag, result.get("bd", pr), grade_tag],
				"#d8d2c4" if attacker.is_hero else "#e0a0a0")
			# Consecrated Ground: the holy footing bites back. Righteous
			# Fire deepens the reflect; Lifewell turns it into party
			# healing; Judgement adds Sunder + Break pressure on top.
			if strike_target.has_status("cons_ground") and not attacker.is_hero \
					and not attacker.dead and final > 0:
				var cg_dv := _living_devout()
				var cg_pct := 0.10
				if cg_dv != null and cg_dv.righteous_ranks > 0:
					cg_pct += 0.05 * cg_dv.righteous_ranks
				var reflect := maxi(int(round(final * cg_pct)), 1)
				_log("   → Consecrated Ground reflects %d to %s%s" % [
					reflect, attacker.unit_name,
					" (Righteous Fire)" if cg_pct > 0.10 else ""], "#c8b880")
				if attacker.take_tick_damage(reflect, "-%d Reflect" % reflect,
						Color(0.9, 0.82, 0.5)):
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
				# Lifewell: the reflected pain waters the party.
				if cg_dv != null and cg_dv.lifewell_ranks > 0:
					var well := maxi(int(round(reflect * 0.20 * cg_dv.lifewell_ranks)), 1)
					for wh in heroes:
						if wh.dead or wh.is_companion:
							continue
						var well_got: int = wh.heal_amount(well, wh != cg_dv)
						wh.float_text("+%d" % well_got, Color(0.4, 0.9, 0.45))
						_stat("healing", well_got)
					_log("   → Talent: Lifewell — the reflected pain mends the party for %d" % \
						well, "#b0a8e0")
				# Judgement: the ground passes sentence on the attacker.
				if cg_dv != null and cg_dv.judgement > 0 and not attacker.dead:
					_apply_status(attacker, "sunder", 2)
					var jd_bd := maxi(int(round(final * 0.20)), 1)
					var jd_result: Dictionary = attacker.take_hit(0, jd_bd)
					_log("   → Talent: Judgement — %s is Sundered and takes %d Break damage" % [
						attacker.unit_name, jd_result.get("bd", jd_bd)], "#b0a8e0")
					if jd_result.get("broke", false):
						_sfx("break", -4.0)
						_message("%s BREAKS!" % attacker.unit_name)
						_log("!! %s BREAKS (Judgement)" % attacker.unit_name, "#c070e0")
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
			if not result.died and not ab.applies_status.is_empty() \
					and randf() <= status_chance:
				var turns: int = ab.applies_status["turns"]
				if is_perfect and ab.perfect_id == "status_plus":
					turns = 4
				var status_meta := 0
				if ab.applies_status["id"] == "burn":
					status_meta = int(round((CRIT_CHANCE + attacker.crit_bonus) * 100))
				# Umbral Mirror: an enemy's debuff can rebound onto itself
				# (and the reflection is the Occultist's work — it feeds Ruin).
				var mirror_r := _max_hero_rank("mirror_ranks")
				if not attacker.is_hero and strike_target.is_hero and mirror_r > 0 \
						and BattleUnit.DEBUFF_IDS.has(ab.applies_status["id"]) \
						and randf() < 0.10 * mirror_r:
					_log("   → Talent: Umbral Mirror — the %s rebounds onto %s" % [
						ab.applies_status["id"].capitalize(), attacker.unit_name],
						"#b0a8e0")
					_apply_status(attacker, ab.applies_status["id"], turns, status_meta,
						_dot_tick(ab.applies_status["id"], attacker))
					_gain_ruin(attacker, 1)
				else:
					_apply_status(strike_target, ab.applies_status["id"], turns, status_meta,
						_dot_tick(ab.applies_status["id"], attacker), attacker)
					_note_debuff_applied(attacker, ab.applies_status["id"])
					# Wrath of the Old Gods: the Occultist's debuffs mark Ruin.
					if attacker.passive_id == "old_gods" and not strike_target.is_hero \
							and BattleUnit.DEBUFF_IDS.has(ab.applies_status["id"]):
						_gain_ruin(strike_target, 1)
				# Empowered Hex: the curse can set the rot in.
				if ab.display_name == "Hex of Ruin" and attacker.emp_hex_ranks > 0 \
						and not strike_target.dead \
						and randf() < 0.25 * attacker.emp_hex_ranks:
					_apply_status(strike_target, "decay", 3)
					_gain_ruin(strike_target, 1)
					_log("   → Talent: Empowered Hex — Decay takes root in %s" % \
						strike_target.unit_name, "#b0a8e0")
			# Lunge: the stance decides the wound — Aggressive Exposes,
			# Defensive Cripples; Guard Change is how the player picks.
			if ab.display_name == "Lunge" and not strike_target.dead:
				var lunge_status := "exposed" if attacker.stance == "aggressive" \
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
				var bleed_amt := ab.bleed_build + attacker.bleed_bonus
				# A bleed spec's perfect pays in bleed: Wildstrikes builds
				# +50% on every target it sweeps.
				if is_perfect and ab.display_name == "Wildstrikes":
					bleed_amt = int(round(bleed_amt * 1.5))
				_add_bleed_with_burst(strike_target, bleed_amt)
			if ab.display_name == "Mocking Blow" and not strike_target.dead:
				var mocker_idx := heroes.find(attacker)
				if mocker_idx >= 0:
					var taunt_turns := 5 if is_perfect else 4
					_apply_status(strike_target, "mocked", taunt_turns, mocker_idx)
					_note_debuff_applied(attacker, "mocked")
					# Provoke widens the net: +1 taunted foe per rank on top
					# of the base one.
					var others := enemies.filter(
						func(e): return not e.dead and e != strike_target)
					others.shuffle()
					var taunt_extra := mini(1 + attacker.provoke_ranks, others.size())
					for oi in taunt_extra:
						_apply_status(others[oi], "mocked", taunt_turns, mocker_idx)
					if attacker.provoke_ranks > 0 and taunt_extra > 1:
						_log("   → Talent: Provoke — the taunt drags in %d more foes" % \
							taunt_extra, "#b0a8e0")
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
			# (Permafrost's old on-hit Frostbite clause left in Batch O — the
			# status lives on where it is CHOSEN: Rime applies it on cast.)
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
			# Spite (Warden talent): laying hands on him costs — attackers
			# take 8%/rank of the damage they dealt straight back.
			if strike_target.spite_ranks > 0 and final > 0 \
					and not attacker.is_hero and not attacker.dead \
					and attacker != strike_target:
				var spite_dmg := maxi(int(round(
					final * 0.08 * strike_target.spite_ranks)), 1)
				var spite_res: Dictionary = attacker.take_hit(spite_dmg, 0)
				attacker.float_text("-%d Spite" % spite_dmg, Color(0.9, 0.55, 0.4))
				_log("   → Talent: Spite — %s takes %d damage back" % [
					attacker.unit_name, spite_dmg], "#b0a8e0")
				if spite_res.died:
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
					_on_enemy_death(attacker)
			# Pyromancer fire package (Batch N kit).
			if detonated > 0:
				_log("   → Detonation consumes the Burn (+%d bonus damage)" % detonated,
					"#e08850")
			if is_perfect and ab.display_name == "Detonation" and not strike_target.dead:
				_apply_status(strike_target, "burn", 2,
					int(round((CRIT_CHANCE + attacker.crit_bonus) * 100)),
					_dot_tick("burn", attacker))
			# Chain Reaction: the blast front leaps to every OTHER burning
			# enemy for 20%/rank of the damage dealt (fire; resists apply).
			if ab.display_name == "Detonation" and attacker.is_hero \
					and attacker.chain_reaction_ranks > 0 and final > 0:
				var cr_struck := 0
				for cr_t in enemies:
					if cr_t.dead or cr_t == strike_target \
							or not cr_t.has_status("burn"):
						continue
					var cr_dmg := maxi(int(round(
						final * 0.20 * attacker.chain_reaction_ranks)), 1)
					var cr_res := float(cr_t.resists.get("fire", 0.0))
					if attacker.avatar_flame > 0 and cr_res > 0.0:
						cr_res = 0.0
					if cr_res != 0.0:
						cr_dmg = maxi(int(round(cr_dmg * (1.0 - cr_res))), 0)
					if cr_dmg <= 0:
						continue
					cr_struck += 1
					_stat("dmg_hero_" + attacker.unit_name, cr_dmg)
					if cr_t.take_tick_damage(cr_dmg, "-%d Chain" % cr_dmg,
							Color(1.0, 0.55, 0.2)):
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % cr_t.unit_name)
						_log("† %s dies" % cr_t.unit_name, "#e05050")
						_on_enemy_death(cr_t)
				if cr_struck > 0:
					_log("   → Talent: Chain Reaction — the blast leaps to %d burning %s" % [
						cr_struck, "enemy" if cr_struck == 1 else "enemies"],
						"#b0a8e0")
			if ab.display_name == "Wildfire" and not wildfire_burn.is_empty():
				var spread_turns := maxi(int(ceil(int(wildfire_burn.turns) / 2.0)), 1)
				var spread_to: Array = enemies.filter(
					func(e): return not e.dead and e != strike_target)
				for foe in spread_to:
					_apply_status(foe, "burn", spread_turns,
						int(wildfire_burn.get("power", 0)),
						int(wildfire_burn.get("tick", 0)))
				if not spread_to.is_empty():
					_log("   → Wildfire spreads the Burn to %d other %s (%d turns)" % [
						spread_to.size(),
						"enemy" if spread_to.size() == 1 else "enemies",
						spread_turns], "#e08850")
			if ab.display_name == "Flamewave" and not strike_target.dead:
				# Batch N ignite clause: the wave STARTS fires now — 2 turns
				# (3 perfect), and those already Burning gain the same as an
				# extension. Conflagration feeds either path +1 turn/rank.
				var fw_turns := (3 if is_perfect else 2) + attacker.conflagration_ranks
				if strike_target.has_status("burn"):
					var fw := strike_target.get_status("burn")
					var binfo: Array = STATUS_INFO["burn"]
					strike_target.update_status("burn", binfo[1], binfo[3], -1,
						int(fw.turns) + fw_turns)
					strike_target.float_text("Burn +%d turns" % fw_turns, binfo[2])
					_log("   → Flamewave stokes %s's Burn (+%d turns)" % [
						strike_target.unit_name, fw_turns], "#e08850")
				else:
					_apply_status(strike_target, "burn", fw_turns, 0,
						_dot_tick("burn", attacker))
			# Cinder Trail: the free bolt scatters embers onto a second victim
			# (1 turn of Burn per rank — the opening turns' spreader).
			if ab.display_name == "Fireball" and attacker.is_hero \
					and attacker.cinder_trail_ranks > 0:
				var ct_pool: Array = enemies.filter(
					func(e): return not e.dead and e != strike_target)
				if not ct_pool.is_empty():
					var ct_t: BattleUnit = ct_pool.pick_random()
					_log("   → Talent: Cinder Trail — embers drift onto %s" % \
						ct_t.unit_name, "#b0a8e0")
					_apply_status(ct_t, "burn", attacker.cinder_trail_ranks, 0,
						_dot_tick("burn", attacker))
			# Blizzard: 1-2 stacks of Chilled settle on each victim.
			if ab.display_name == "Blizzard" and not strike_target.dead:
				for chill_i in randi_range(1, 2):
					_apply_status(strike_target, "chilled", 3, 0, 0, attacker)
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
			# Honed Shards: a critical lance splinters into fresh cold.
			if is_crit and ab.display_name == "Ice Lance" and not strike_target.dead \
					and attacker.honed_shards_ranks > 0:
				_log("   → Talent: Honed Shards — the crit leaves its splinters", "#b0a8e0")
				for _hs_i in attacker.honed_shards_ranks:
					if not strike_target.dead:
						_apply_status(strike_target, "chilled", 3, 0, 0, attacker)
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
				# No Quarter: the Break refunds the Rage that opened it —
				# fuel for the Overpower he wants to spend in the window.
				if attacker.no_quarter_ranks > 0 and attacker.is_hero \
						and not attacker.dead and not strike_target.is_hero:
					var nq_gain := 15 * attacker.no_quarter_ranks
					attacker.resource = mini(attacker.resource + nq_gain,
						attacker.max_resource)
					attacker.refresh_bars()
					attacker.float_text("+%d Rage" % nq_gain, Color(1.0, 0.5, 0.4))
					_log("   → Talent: No Quarter — the Break grants %s +%d Rage" % [
						attacker.unit_name, nq_gain], "#b0a8e0")
			if result.died:
				_stat("hero_deaths" if strike_target.is_hero else "enemy_deaths")
				_sfx("death", -4.0)
				_message("%s falls!" % strike_target.unit_name)
				_log("† %s dies" % strike_target.unit_name, "#e05050")
				if strike_target.is_companion:
					_on_beast_death(strike_target)
				elif not strike_target.is_hero:
					_on_enemy_death(strike_target)
				await _wait(0.5)
			# Shatterpoint: a Break torn open on this very hit — the
			# Swordmaster drives straight through with a free Overpower
			# (no Rage, no cooldown; the Rampage/Implosion recast pattern).
			if ab.display_name == "Shatterpoint" and result.broke \
					and attacker.is_hero and not attacker.dead \
					and not strike_target.dead and not battle_over:
				var sp_over := _find_ability(attacker, "Overpower")
				if sp_over != null:
					strike_target.float_text("SHATTERPOINT", Color(0.8, 0.4, 1.0))
					_log("%s: Shatterpoint drives through the Break — free Overpower!" % \
						attacker.unit_name, "#c070e0")
					await _wait(0.4)
					await _resolve(attacker, _free_copy(sp_over), strike_target,
						"good", true)
			# Mark of the Hunt: every strike on the marked prey feeds the
			# hunter's Mana (3% max per hit).
			if attacker.is_hero and attacker.passive_id == "pack" \
					and not attacker.dead and strike_target.has_status("hunt_mark") \
					and strike_target.status_power("hunt_mark") == heroes.find(attacker):
				attacker.resource = mini(attacker.resource \
					+ int(attacker.max_resource * 0.03), attacker.max_resource)
				attacker.refresh_bars()
			# Implosion: Detonation can slam twice (free echo strike).
			if ab.display_name == "Detonation" and not is_counter \
					and attacker.is_hero and attacker.implosion_ranks > 0 \
					and not strike_target.dead and not attacker.dead \
					and randf() < 0.03 * attacker.implosion_ranks:
				strike_target.float_text("IMPLOSION", Color(1.0, 0.5, 0.15))
				_log("Talent: Implosion — the Detonation strikes twice!", "#b0a8e0")
				await _wait(0.35)
				await _resolve(attacker, _free_copy(ab), strike_target, "good", true)
			# Cataclysm (capstone): the Detonation chains down the burning
			# field — each link fires at the enemy with the most Burn left
			# for 60% of the link before (damage AND BD), up to 3 extra
			# hits (4 total, HARD CAP). Each link consumes its target's
			# Burn as normal, so the chain starves itself; links pass
			# is_counter so they can never re-chain or re-trigger Implosion.
			if ab.display_name == "Detonation" and not is_counter \
					and attacker.is_hero and attacker.cataclysm > 0 \
					and not attacker.dead and not battle_over:
				var cat_mult := 0.6
				for cat_i in 3:
					if attacker.dead or battle_over:
						break
					var cat_t: BattleUnit = null
					var cat_best := 0
					for cat_e in enemies:
						if cat_e.dead or not cat_e.has_status("burn"):
							continue
						var cat_turns := int(cat_e.get_status("burn").get("turns", 0))
						if cat_turns > cat_best:
							cat_best = cat_turns
							cat_t = cat_e
					if cat_t == null:
						break
					var cat_ab := _free_copy(ab)
					cat_ab.damage = maxi(int(round(ab.damage * cat_mult)), 1)
					cat_ab.pressure = maxi(int(round(ab.pressure * cat_mult)), 0)
					cat_t.float_text("CATACLYSM", Color(1.0, 0.45, 0.1))
					_log("Capstone: Cataclysm — the blast chains to %s (%d%% power)" % [
						cat_t.unit_name, int(round(cat_mult * 100))], "#e8c860")
					await _wait(0.35)
					await _resolve(attacker, cat_ab, cat_t, "good", true)
					cat_mult *= 0.6
			# Counter Attack: a parry answers back. Untouchable (Defensive
			# stance only) answers with a free Pommel Strike — every parry
			# is also a stun; otherwise Riposte answers with a basic Strike.
			if parried and not is_counter \
					and not strike_target.dead and not attacker.dead:
				var ut_pommel: Ability = _find_ability(strike_target, "Pommel Strike") \
					if (strike_target.untouchable > 0 \
					and strike_target.stance == "defensive") else null
				if ut_pommel != null:
					_log("Capstone: Untouchable — %s's wall answers with the pommel!" % \
						strike_target.unit_name, "#50c8e0")
					await _wait(0.4)
					await _resolve(strike_target, _free_copy(ut_pommel), attacker,
						"good", true)
					if attacker.dead:
						break
				elif strike_target.counter_attacks:
					_log("Talent: Riposte — %s counter attacks!" % strike_target.unit_name,
						"#50c8e0")
					await _wait(0.4)
					await _resolve(strike_target, strike_target.abilities[0], attacker,
						"good", true)
					if attacker.dead:
						break
			if (ab.random_hits > 0 or ab.multi_hits > 0) and total_hits > 1:
				await _wait(0.45)  # sequential strikes land distinctly
		# War Stomp: the tremor rallies the line — allies regain 10% resource
		# (20% on a perfect cast; the damage is a 75-Attack tank's, the
		# party refuel is the real payload).
		if ab.display_name == "War Stomp" and attacker.is_hero and not attacker.dead:
			var stomp_pct := (0.20 if is_perfect else 0.10) \
				+ 0.05 * attacker.rallying_stomp_ranks
			if attacker.rallying_stomp_ranks > 0:
				_log("   → Talent: Rallying Stomp — the refuel deepens (+%d%%)" % (
					5 * attacker.rallying_stomp_ranks), "#b0a8e0")
			for h in heroes:
				if h.dead or h == attacker or h.resource_name == "":
					continue
				var stomp_gain := maxi(int(h.max_resource * stomp_pct), 1)
				h.resource = mini(h.resource + stomp_gain, h.max_resource)
				h.float_text("+%d %s" % [stomp_gain, h.resource_name], Color(0.5, 0.8, 1.0))
				h.refresh_bars()
			_log("   → War Stomp: allies regain %d%% of their resource%s" % [
				int(round(stomp_pct * 100)),
				" [PERFECT]" if is_perfect else ""], "#70d878")
		# Post-strike attacker effects (skipped if a counter felled the attacker).
		var recoil_pct := ab.recoil_base
		# Volatility: escalation's bill — Cannon and Wrath recoil harder.
		if attacker.volatility_ranks > 0 \
				and ab.display_name in ["Arcane Cannon", "Magi's Wrath"]:
			recoil_pct += 0.05 * attacker.volatility_ranks
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
			# Feedback Loop (talent): part of the backlash is paid as Mana
			# instead of health (pairs with Conversion — self-harm into fuel).
			if attacker.feedback_ranks > 0 and attacker.resource_name == "Mana":
				var fb_mana := mini(int(round(recoil * 0.10 * attacker.feedback_ranks)),
					mini(attacker.resource, recoil))
				if fb_mana > 0:
					attacker.resource -= fb_mana
					recoil -= fb_mana
					attacker.float_text("-%d Mana" % fb_mana, Color(0.5, 0.7, 1.0))
					_log("   → Talent: Feedback Loop — %d of the recoil paid as Mana" % \
						fb_mana, "#b0a8e0")
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
		# Freezing Advance: the whole attack rode the opening — spend the mark.
		if attacker.is_hero and attacker.freezing_ranks > 0 and ab.damage > 0 \
				and not is_counter:
			for fa_t in strike_targets:
				if fa_t.freezing_adv_mark:
					fa_t.freezing_adv_mark = false
					_log("   → Talent: Freezing Advance — the opening is taken (+%d%%)" % (
						10 * attacker.freezing_ranks), "#b0a8e0")
		# Survivalist on-hit package: Shrapnel's poison (perfect adds Slowed),
		# Hamstring's trio, Coated Blades on basics, Venom Coating on all.
		if attacker.is_hero and attacker.passive_id == "trapper" \
				and ab.damage > 0 and not is_counter:
			var sv_turns := 4 if is_perfect else 3
			for sv_t in [target, second_target, third_target]:
				if sv_t == null or sv_t.dead or sv_t.is_hero:
					continue
				if ab.display_name == "Shrapnel Charge":
					_apply_poison(attacker, sv_t, sv_turns)
					if is_perfect:
						_apply_status(sv_t, "slow", sv_turns)
				if ab.display_name == "Hamstring":
					_apply_status(sv_t, "slow", sv_turns)
					_apply_status(sv_t, "exposed", sv_turns)
					_hit_and_run(attacker)
				if attacker.coated_blades > 0 and ab.cost == 0:
					_apply_poison(attacker, sv_t, 2)
				if attacker.has_status("venom_coat"):
					_apply_poison(attacker, sv_t, 5)
		# Sharpshooter: the Focus engine, the promised shot's spending, the
		# pin, the called spot, and the spray's echo.
		if attacker.is_hero and attacker.passive_id == "lethal_aim" \
				and ab.damage > 0 and not is_counter and not ab.aoe \
				and target != null and not target.is_hero:
			_sharpshooter_focus(attacker, target)
			if ab.display_name == "Pinning Shot" and not target.dead:
				_apply_status(target, "dazed", 3)
			if ab.display_name == "Called Shot" and not target.dead:
				match called_mode:
					"break":
						target.take_hit(0, 30)
						target.float_text("+30 BD", Color(0.8, 0.35, 1.0))
						_log("   → Called Shot cracks the Break meter", "#e0a050")
					"exposed":
						_apply_status(target, "exposed", 3)
					_:
						_apply_status(target, "sunder", 2)
				called_mode = ""
			if attacker.has_status("held_breath"):
				var hb_left := attacker.status_power("held_breath") - 1
				if hb_left <= 0:
					attacker.remove_status("held_breath")
					_log("   → the held breath releases", "#909090")
				else:
					var hb_info: Array = STATUS_INFO["held_breath"]
					attacker.update_status("held_breath", "HB%d" % hb_left,
						hb_info[3], hb_left)
			if attacker.spray > 0 and ab.multi_hits == 0 and ab.random_hits == 0:
				var sp_pool := enemies.filter(
					func(e): return not e.dead and e != target)
				if not sp_pool.is_empty():
					var sp_t: BattleUnit = sp_pool.pick_random()
					var sp_raw := ab.damage * 0.005 * attacker.attack \
						* randf_range(0.9, 1.1)
					sp_raw *= 1.0 - float(sp_t.resists.get("physical", 0.0))
					var sp_final := maxi(int(round(sp_raw \
						* (1.0 - sp_t.effective_armor()))), 1)
					var sp_res: Dictionary = sp_t.take_hit(sp_final, 0)
					sp_t.float_text("%d Spray" % sp_final, Color(0.9, 0.75, 0.55))
					_log("   → Spray of Arrows: %d to %s" % [sp_final,
						sp_t.unit_name], "#d8b880")
					if sp_res.died:
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % sp_t.unit_name)
						_log("† %s dies" % sp_t.unit_name, "#e05050")
						_on_enemy_death(sp_t)
		# Hunter's Instinct: each empowered shot also tends every beast.
		if ab.display_name == "Quick Shot" and not is_counter \
				and attacker.has_status("instinct"):
			for hi_b in _beasts(attacker):
				var hi_heal: int = hi_b.heal_amount(int(hi_b.max_hp * 0.15))
				hi_b.float_text("+%d" % hi_heal, Color(0.4, 0.9, 0.45))
				hi_b.refresh_bars()
				_log("   → Instinct mends %s for %d" % [
					hi_b.unit_name, hi_heal], "#70d878")
			var hi_left := attacker.status_power("instinct") - 1
			if hi_left <= 0:
				attacker.remove_status("instinct")
				_log("   → Hunter's Instinct is spent", "#909090")
			else:
				var hi_info: Array = STATUS_INFO["instinct"]
				attacker.update_status("instinct", "HI%d" % hi_left,
					hi_info[3], hi_left)
		# The Beastmaster's beasts strike alongside the hunter (The Pack:
		# both fire; a beast whose prey just fell picks the next weakest).
		if attacker.is_hero and attacker.passive_id == "pack" and ab.damage > 0 \
				and not is_counter:
			var comp_target: BattleUnit = target
			for cs_b in _beasts(attacker):
				if comp_target == null or comp_target.is_hero or comp_target.dead:
					var foes := enemies.filter(func(e): return not e.dead)
					comp_target = null if foes.is_empty() else _lowest_hp(foes)
				if comp_target == null:
					break
				await _companion_strike(cs_b, comp_target, 1.0, false)
				# Apex Predator: the basic shot looses the beast twice.
				if attacker.apex > 0 and ab.display_name == "Quick Shot" \
						and not cs_b.dead and not comp_target.dead:
					await _companion_strike(cs_b, comp_target, 1.0, false)
		# Tripwire: rigged ground bites every attacking melee enemy (Snap
		# Shut / The Whole Forest extend it to ranged; Reinforced Wire and
		# Cruel Devices sharpen it).
		if not attacker.is_hero and not is_counter and total_dealt > 0:
			for trapper in heroes:
				if trapper.dead or not trapper.has_status("tripwire") or attacker.dead:
					continue
				if attacker.is_ranged and trapper.snap_shut == 0 \
						and trapper.whole_forest == 0:
					continue
				var ret := maxi(int(total_dealt * 0.75), 1) \
					+ int(0.10 * trapper.wire_ranks * trapper.attack)
				ret = int(round(ret * (1.0 + 0.15 * trapper.cruel_ranks)))
				var ret_result: Dictionary = attacker.take_hit(ret, 0)
				_stat("dmg_hero_" + trapper.unit_name, ret)
				attacker.float_text("%d Tripwire" % ret, Color(0.8, 0.65, 0.35))
				_log("   → %s's tripwire rips %s for %d" % [trapper.unit_name,
					attacker.unit_name, ret], "#50c8e0")
				if trapper.bone_breaker > 0 and not attacker.dead:
					attacker.take_hit(0, 30)
				if trapper.caught_fast > 0 and not attacker.dead:
					_apply_status(attacker, "caught", 3)
				if ret_result.died:
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
					_on_enemy_death(attacker)
		# Corrupted Channeling (talent): a Crippled enemy's violence feeds
		# the party — 25%/rank of the damage it dealt.
		var chan_r := _max_hero_rank("channeling_ranks")
		if not attacker.is_hero and attacker.has_status("cripple") and total_dealt > 0 \
				and chan_r > 0:
			var blessed: BattleUnit = heroes.filter(func(h): return not h.dead).pick_random()
			var leech_heal := maxi(int(round(total_dealt * 0.25 * chan_r)), 1)
			var chan_got: int = blessed.heal_amount(leech_heal)
			blessed.float_text("+%d" % chan_got, Color(0.7, 0.4, 0.9))
			_stat("healing", chan_got)
			_log("   → Talent: Corrupted Channeling — %s heals %d" % [blessed.unit_name,
				chan_got], "#b0a8e0")
		# Resonance builds only on the Mage's own casts — parry counters don't
		# count (they made the Mage "start" battles with a stack).
		if not is_counter:
			# Charged Bolts (talent): a damaging cast made AT the ceiling
			# vents power as Mana (checked before the gain lands).
			if attacker.second_resource_name == "Resonance" \
					and attacker.charged_bolts_ranks > 0 \
					and attacker.second_resource >= attacker.second_max:
				var cb_mana := maxi(int(round(attacker.max_resource * 0.05
					* attacker.charged_bolts_ranks)), 1)
				attacker.resource = mini(attacker.resource + cb_mana,
					attacker.max_resource)
				attacker.float_text("+%d Mana" % cb_mana, Color(0.5, 0.7, 1.0))
				_log("   → Talent: Charged Bolts — %s recovers %d Mana" % [
					attacker.unit_name, cb_mana], "#b0a8e0")
			var res_gain := 2 if any_crit else 1
			# Harmonics (talent): the free basic ramps the engine faster.
			if ab.display_name == "Arcane Explosion" and attacker.harmonics_ranks > 0:
				res_gain += attacker.harmonics_ranks
			_gain_resonance(attacker, res_gain)
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
		tick := 0, src: BattleUnit = null) -> void:
	# Bosses shrug off Stuns, Freezes, and mind magic until Broken.
	if id in ["stunned", "frozen", "psychosis", "bewitch", "hysteria"] \
			and target.is_boss and not target.broken:
		target.float_text("IMMUNE", Color(0.75, 0.75, 0.75))
		_log("   → %s resists the %s (boss — Break them first)" % [target.unit_name,
			String(STATUS_INFO[id][0])], "#909090")
		return
	# Hallowed (Empowered Divine Plea): shrugs off every new debuff.
	if target.has_status("sanctified") and BattleUnit.DEBUFF_IDS.has(id):
		target.float_text("HALLOWED", Color(0.98, 0.88, 0.55))
		_log("   → %s is Hallowed — the %s cannot take hold" % [target.unit_name,
			String(STATUS_INFO[id][0])], "#e8c860")
		return
	var info: Array = STATUS_INFO[id]
	# Permafrost: Chilled stacks the Cryomancer applies NEVER expire (-1 =
	# battle-long). Scoped to the src — enemy-applied chill keeps the
	# 3-turn clock.
	var eff_turns := turns
	if id == "chilled" and src != null and src.is_hero \
			and src.passive_id == "permafrost":
		eff_turns = -1
	target.add_status(id, info[0], info[1], info[2], eff_turns, info[3], power, tick)
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
				_apply_status(echo_t, "chilled", 3, 0, 0, src)
				_rime_echoing = false
		# Four stacks flash-freeze the victim — unless the ice already holds
		# them (a boss just keeps sitting on its stacks until Broken).
		if target.status_stacks("chilled") >= 4 and not target.has_status("frozen"):
			_apply_status(target, "frozen", 1 + _max_hero_rank("cold_snap_ranks"))
			if target.has_status("frozen"):
				target.was_frozen = true
				# Batch O: the payoff keeps an ember — the freeze leaves 1
				# stack instead of wiping the pile (Absolute Zero holds all 4).
				var kept := 4 if _living_hero_with("absolute_zero") != null else 1
				target.set_chilled_stacks(kept)
				_log("   → %s FREEZES SOLID (4 stacks of Chilled — x%d remains)" % [
					target.unit_name, kept], "#7cc8f0")
				# Freezing Advance: the Cryomancer's next strike on this
				# victim bites deeper — arm the mark.
				if _max_hero_rank("freezing_ranks") > 0:
					target.freezing_adv_mark = true
				# Glacial Economy: every freeze pays its caster back in Mana.
				var gl_h := _living_hero_with("glacial_ranks")
				if gl_h != null and gl_h.resource_name == "Mana":
					var gl_mana := maxi(int(round(gl_h.max_resource * 0.05
						* gl_h.glacial_ranks)), 1)
					gl_h.resource = mini(gl_h.resource + gl_mana, gl_h.max_resource)
					gl_h.float_text("+%d Mana" % gl_mana, Color(0.5, 0.7, 1.0))
					gl_h.refresh_bars()
					_log("   → Talent: Glacial Economy — the freeze returns %d Mana" % \
						gl_mana, "#b0a8e0")
				# Bitter Cold: the freeze rolls outward — every OTHER enemy
				# catches stacks. One cascade at a time: a freeze the spread
				# itself causes never re-spreads (that way lies the ice age).
				var bc_h := _living_hero_with("bitter_cold_ranks")
				if bc_h != null and not _bitter_echoing:
					_bitter_echoing = true
					var bc_pool := enemies.filter(
						func(e): return not e.dead and e != target)
					if not bc_pool.is_empty():
						_log("   → Talent: Bitter Cold — the freeze rolls across the field",
							"#b0a8e0")
						for bc_e in bc_pool:
							for _bc_i in bc_h.bitter_cold_ranks:
								if not bc_e.dead:
									_apply_status(bc_e, "chilled", 3, 0, 0, bc_h)
					_bitter_echoing = false
			return
		var pile := target.get_status("chilled")
		if int(pile.get("turns", 3)) < 0:
			_log("   → Chilled on %s (x%d — Permafrost: never thaws)" % [target.unit_name,
				target.status_stacks("chilled")], "#7cc8f0")
		else:
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


# Pack Bond strength for a hunter and a beast kind, all talents applied:
# 0 = no boon, 1 = base, 2 = doubled (5 Loyalty), 3 = tripled (Ancient
# Pact), 0.5 = Menagerie's half-boon for absent beasts, 1 (flat) while
# Vengeance carries a dead beast's bond.
func _bond_mult(hunter: BattleUnit, kind: String) -> float:
	if hunter == null or hunter.dead or hunter.passive_id != "pack":
		return 0.0
	# The Pack: each active beast grants its own boon — this check simply
	# matches any of them.
	if _beasts(hunter).any(func(b): return b.companion_kind == kind):
		if int(hunter.loyalty.get(kind, 0)) >= 5:
			return 3.0 if hunter.ancient_pact > 0 else 2.0
		return 1.0
	if hunter.vengeance_kind == kind and hunter.has_status("vengeance"):
		return 1.0
	if hunter.menagerie > 0 and hunter.kinds_summoned.has(kind):
		return 0.5
	return 0.0


# The hunter's Loyalty ceiling, talents applied (the boon threshold is
# always 5 — Absolute Devotion's stacks 6-7 feed damage and gifts only).
func _loyalty_cap(hunter: BattleUnit) -> int:
	if hunter.wild_rotation > 0:
		return 2
	if hunter.lone_bond > 0:
		return 8
	return 5 + hunter.loyalty_cap_bonus


# Loyalty: each beast's devotion to the Beastmaster (0 to cap, per beast).
# +1 every hunter turn that begins with it active and on every summon/
# swap-in (+1 more on no-damage turns with Unbroken Watch; One Soul
# doubles all gains); +5% strike damage per stack (Wild Communion deepens
# it) plus a beast-specific gift; at 5 the Pack Bond boon is DOUBLED
# (TRIPLED under Ancient Pact). A beast's death resets its meter (halves
# it under Steadfast Bond).
func _gain_loyalty(hunter: BattleUnit, kind: String, amount := 1) -> void:
	if hunter == null or hunter.dead or hunter.passive_id != "pack" or kind == "":
		return
	if hunter.one_soul > 0:
		amount *= 2
	var before: int = hunter.loyalty.get(kind, 0)
	var now := mini(before + amount, _loyalty_cap(hunter))
	hunter.loyalty[kind] = now
	if now == before:
		return
	var comp: BattleUnit = null
	for gl_b in _beasts(hunter):
		if gl_b.companion_kind == kind:
			comp = gl_b
	if comp != null:
		# Ursus grows with devotion: +3% of base max health per stack.
		if kind == "ursus":
			var hp_step: int = int(round(COMPANION_STATS["ursus"][0] * 0.03)) \
				* (now - before)
			comp.max_hp += hp_step
			comp.hp += hp_step
		comp.float_text("+%d Loyalty" % (now - before), Color(0.95, 0.75, 0.30))
		_stamp_loyalty_chip(hunter, comp)
		comp.refresh_bars()
	if now >= 5 and before < 5:
		_log("   → %s's Loyalty is absolute — its Pack Bond boon DOUBLES" % \
			kind.capitalize(), "#e8c860")


# The Loyalty chip lives on the companion (permanent, live counter).
func _stamp_loyalty_chip(hunter: BattleUnit, comp: BattleUnit) -> void:
	var stacks: int = hunter.loyalty.get(comp.companion_kind, 0)
	if stacks <= 0:
		return
	var gift := ""
	match comp.companion_kind:
		"ursus":
			gift = "+%d%% max health" % (3 * stacks)
		"canis":
			gift = "+%d Bleed per strike" % (2 * stacks)
		"aguila":
			gift = "%d%% of armor ignored" % mini(20 * stacks, 100)
	var l_desc := "Loyalty %d/%d: +%d%% strike damage\nand %s." % [
		stacks, _loyalty_cap(hunter), 5 * stacks, gift]
	if stacks >= 5:
		l_desc += "\nPACK BOND BOON DOUBLED."
	else:
		l_desc += "\nAt 5 the Pack Bond boon is doubled."
	var info: Array = STATUS_INFO["loyalty"]
	if not comp.update_status("loyalty", "L%d" % stacks, l_desc, stacks):
		comp.add_status("loyalty", info[0], "L%d" % stacks, info[2], -1, l_desc, stacks)


# The party's crit bonus from Aguila's bond (best tier among pack heroes:
# live eagle, Vengeance's ghost of it, or Menagerie's half-memory).
func _party_crit_bonus() -> float:
	var best := 0.0
	for h in heroes:
		if not h.dead and not h.is_companion and h.passive_id == "pack":
			best = maxf(best, 0.10 * _bond_mult(h, "aguila"))
	return best


# Arcane Resonance: builds on damaging casts (2 on crit via Arcane Instability);
# every gain at max stacks triggers Backlash Ward (+15 Mana). Stacks persist
# until Stabilize vents the ones above its floor. Overcharge raises the cap.
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
	# Backlash Ward: EVERY gain at max stacks restores Mana (Batch P) — the
	# ramp keeps paying in a different currency once it can't pay in stacks.
	# Unlimited Power's overflow branch above still takes priority.
	if caster.second_resource == caster.second_max:
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


# Radiant Cascade: a critical heal splashes a share of its value onto the
# lowest-health OTHER ally (needs Triage — nothing else crits a heal).
func _radiant_cascade(caster: BattleUnit, healed: int, primary: BattleUnit) -> void:
	if caster.cascade_ranks <= 0 or healed <= 0:
		return
	var cc_pool: Array = heroes.filter(
		func(h): return not h.dead and not h.is_companion and h != primary)
	if cc_pool.is_empty():
		return
	var cc_t: BattleUnit = _lowest_hp(cc_pool)
	if cc_t.hp >= cc_t.max_hp:
		return
	var cc_amt := int(round(healed * 0.25 * caster.cascade_ranks))
	if cc_amt <= 0:
		return
	var cc_got: int = cc_t.heal_amount(cc_amt, cc_t != caster)
	cc_t.float_text("+%d" % cc_got, Color(0.95, 0.9, 0.6))
	_stat("healing", cc_got)
	_log("   → Talent: Radiant Cascade — the crit splashes %d onto %s" % [
		cc_got, cc_t.unit_name], "#b0a8e0")


# Overflow: a share of the overheal spills onto the lowest-health OTHER
# ally at once. Reads the same overheal Holy Capacitor banks from, at the
# same three sites (Heal, Hymn voices, Renewal's perfect burst).
func _overflow_spill(caster: BattleUnit, target: BattleUnit) -> void:
	if caster.overflow_ranks <= 0 or target.last_overheal <= 0:
		return
	var ov_pool: Array = heroes.filter(
		func(h): return not h.dead and not h.is_companion and h != target)
	if ov_pool.is_empty():
		return
	var ov_t: BattleUnit = _lowest_hp(ov_pool)
	if ov_t.hp >= ov_t.max_hp:
		return
	var ov_amt := int(round(target.last_overheal * 0.15 * caster.overflow_ranks))
	if ov_amt <= 0:
		return
	var ov_got: int = ov_t.heal_amount(ov_amt, ov_t != caster)
	ov_t.float_text("+%d" % ov_got, Color(0.95, 0.9, 0.6))
	_stat("healing", ov_got)
	_log("   → Talent: Overflow — %d overhealing spills onto %s" % [
		ov_got, ov_t.unit_name], "#b0a8e0")


# Living Sanctum (capstone): every heal the Cleric grants a single ally
# washes over the whole party at a quarter strength. Hymn is already the
# whole party, and the echo never echoes itself.
func _sanctum_echo(caster: BattleUnit, value: int) -> void:
	if caster.living_sanctum <= 0 or value <= 0:
		return
	var ls_amt := int(round(value * 0.25))
	if ls_amt <= 0:
		return
	for ls_h in heroes.filter(func(he): return not he.dead and not he.is_companion):
		var ls_got: int = ls_h.heal_amount(ls_amt, ls_h != caster)
		if ls_got > 0:
			ls_h.float_text("+%d" % ls_got, Color(0.95, 0.9, 0.6))
			_stat("healing", ls_got)
	_log("   → Capstone: Living Sanctum — the light washes over the party (%d each)" % \
		ls_amt, "#b0a8e0")


# Serenity: the banked lethal save is spent for the WHOLE party the moment
# it catches someone (the unit-side check floors the hit at 1 HP).
func _on_serenity_save(saved: BattleUnit) -> void:
	for h in heroes:
		h.serenity_guard = false
	_log("   → Talent: Serenity — %s survives the killing blow at 1 HP" % \
		saved.unit_name, "#b0a8e0")


# Divine Shield: applies the barrier and stamps the tree's riders on it
# (Blessed Barrier heal share; Afterglow heal on break; Warded Robes
# armor; Unyielding Aegis re-form). EVERY Divine Shield goes through
# here — Purity's blessing-carried shield included — so the "divine"
# flag (the Faith trigger) can never be missed.
func _grant_divine_shield(devout: BattleUnit, target: BattleUnit, power: int) -> void:
	_apply_status(target, "barrier", -1, power)
	var bstat := target.get_status("barrier")
	if bstat.is_empty():
		return
	bstat["divine"] = true  # only Divine Shield absorbs build Faith
	bstat["blessed_pct"] = 0.04 * devout.blessed_barrier_ranks
	bstat["afterglow"] = int(round(devout.max_hp * 0.05 * devout.afterglow_ranks))
	bstat["warded"] = 0.10 * devout.warded_ranks
	# Re-applying merges to the bigger power (add_status maxes), so the
	# re-form baseline is the pool as it stands, not this cast's power.
	bstat["original"] = int(bstat.get("power", power))
	bstat["unyielding_pct"] = 0.30 * devout.unyielding_ranks
	if devout.warded_ranks > 0:
		_log("   → Talent: Warded Robes — the shield hardens %s (+%d%% armor while it holds)" % [
			target.unit_name, 10 * devout.warded_ranks], "#b0a8e0")


# Conviction (Devout passive): the living Devout, or null. Faith stacks
# only work while their shrine stands.
func _living_devout() -> BattleUnit:
	for h in heroes:
		if not h.dead and h.passive_id == "conviction":
			return h
	return null


# The unit's guaranteed 0-cost attack (every enemy kit carries one).
func _cheapest_attack(u: BattleUnit) -> Ability:
	for a in u.abilities:
		if a.damage > 0 and a.cost == 0:
			return a
	return null


# Bewitch: the charmed strike a fellow with their basic attack, Dazing
# them (an Occultist-attributed debuff → Ruin). Returns true if it acted.
func _bewitched_strike(u: BattleUnit) -> bool:
	var fellows := enemies.filter(func(e): return not e.dead and e != u)
	var basic := _cheapest_attack(u)
	if fellows.is_empty() or basic == null:
		return false
	var bw_target: BattleUnit = fellows.pick_random()
	_message("%s turns on its allies!" % u.unit_name)
	_log("%s is bewitched — attacks %s!" % [u.unit_name, bw_target.unit_name],
		"#c070e0")
	await _wait(0.4)
	await _resolve(u, basic, bw_target, "good")
	if not bw_target.dead:
		_apply_status(bw_target, "dazed", 2)
		_gain_ruin(bw_target, 1)
	elif bw_target.dead:
		# Murderous Intent: a bewitched kill feeds the party's darkest hunger.
		var mi_ranks := _max_hero_rank("murderous_ranks")
		var occ := _living_occultist()
		if mi_ranks > 0 and occ != null:
			var mi_pool := heroes.filter(func(h): return not h.dead and not h.is_companion)
			if not mi_pool.is_empty():
				var mi_t := _lowest_hp(mi_pool)
				var mi_heal := maxi(int(round(occ.max_hp * 0.10 * mi_ranks)), 1)
				var mi_got: int = mi_t.heal_amount(mi_heal, mi_t != occ)
				mi_t.float_text("+%d" % mi_got, Color(0.7, 0.4, 0.9))
				_stat("healing", mi_got)
				_log("   → Talent: Murderous Intent — %s feeds on the kill (+%d)" % [
					mi_t.unit_name, mi_got], "#b0a8e0")
	return true


# Psychosis: a maddened support turns its helpful magic on the HERO side.
# Returns [ability, hero_target] or [] when the unit has no such spell.
func _psychotic_support(u: BattleUnit) -> Array:
	var living := _hero_side()
	if living.is_empty():
		return []
	for a in u.abilities:
		if a.cost > u.resource:
			continue
		match a.special:
			"healing_wave", "wild_growth":
				return [a, _lowest_hp(living)]
			"enemy_shield":
				return [a, living.pick_random()]
	return []


# Wrath of the Old Gods (Occultist passive): the living Occultist, or null.
func _living_occultist() -> BattleUnit:
	for h in heroes:
		if not h.dead and h.passive_id == "old_gods":
			return h
	return null


# Lingering Torment (talent): when a madness effect ends, the mind rots
# on — Decay takes root. Fires from unit.tick_statuses (natural expiry)
# and from the Hysteria act-consumption site in _enemy_turn.
func _on_status_expired(u: BattleUnit, id: String) -> void:
	if u.is_hero or u.dead or battle_over:
		return
	if not (id in ["psychosis", "bewitch", "hysteria"]):
		return
	var occ := _living_occultist()
	if occ == null or occ.torment_ranks == 0:
		return
	var torment_turns := 2 * occ.torment_ranks
	_apply_status(u, "decay", torment_turns)
	_log("   → Talent: Lingering Torment — the madness curdles into Decay on %s (%d turns)" % [
		u.unit_name, torment_turns], "#b0a8e0")


# Unique debuff ids across the living enemy team (Pleasure from Pain,
# Dark Infusion).
func _unique_enemy_debuffs() -> int:
	var seen := {}
	for e in enemies:
		if e.dead:
			continue
		for s in e.statuses:
			if BattleUnit.DEBUFF_IDS.has(s.id):
				seen[s.id] = true
	return seen.size()


# Wrath of the Old Gods: every Occultist-applied debuff marks its victim.
# At 5 stacks the mark is PRIMED — it detonates at the victim's next turn.
func _gain_ruin(target: BattleUnit, n: int = 1) -> void:
	var occ := _living_occultist()
	if occ == null or target.is_hero or target.dead:
		return
	for i in n:
		if target.status_stacks("ruin") >= 5:
			break
		_apply_status(target, "ruin", -1)
	if target.status_stacks("ruin") >= 5 and not target.has_status("ruin_primed"):
		_apply_status(target, "ruin_primed", 1)
		_log("   → The Old Gods take notice — %s's Ruin is PRIMED" % \
			target.unit_name, "#c060d0")


# The primed Ruin detonates: shadow damage off the Occultist's Attack and
# a wave of stolen vitality for the party. Grim Focus deepens the blast,
# Unraveling seeds the mark in every other enemy, and the Avatar of Ruin
# capstone keeps the stacks so a held target detonates again each turn.
func _detonate_ruin(target: BattleUnit) -> void:
	var occ := _living_occultist()
	# Avatar of Ruin: the stacks are never consumed — only the primer is.
	var det_avatar := occ != null and occ.avatar_ruin > 0
	if not det_avatar:
		target.remove_status("ruin")
	target.remove_status("ruin_primed")
	if occ == null or target.dead:
		return
	var det_raw := 0.50 * occ.attack * randf_range(0.9, 1.1)
	# Grim Focus: the detonation strikes 25%/rank harder.
	det_raw *= 1.0 + 0.25 * occ.grim_ranks
	var resist := float(target.resists.get("shadow", 0.0))
	var det_dmg := maxi(int(round(det_raw * (1.0 - resist))), 1)
	_message("RUIN consumes %s!" % target.unit_name)
	var det_died := target.take_tick_damage(det_dmg, "-%d RUIN" % det_dmg,
		Color(0.8, 0.3, 0.9))
	_stat("dmg_hero_" + occ.unit_name, det_dmg)
	_log("%s: Wrath of the Old Gods — Ruin detonates on %s for %d shadow" % [
		occ.unit_name, target.unit_name, det_dmg], "#c060d0")
	for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
		var rw_heal := maxi(int(round(occ.max_hp * 0.15)), 1)
		var rw_got: int = h.heal_amount(rw_heal, h != occ)
		h.float_text("+%d" % rw_got, Color(0.7, 0.4, 0.9))
		_stat("healing", rw_got)
	_log("   → the party feasts on the ruin (15% of the Occultist's health each)",
		"#b070d0")
	# Unraveling: the blast seeds Ruin in every OTHER enemy. One propagation
	# per detonation BY CONSTRUCTION: a seeded enemy only gets PRIMED here —
	# primed Ruin detonates at its bearer's own turn start, never inside
	# another detonation — so the chain can never recurse on a full field.
	if occ.unravel_ranks > 0:
		var unr_hit := 0
		for e in enemies:
			if not e.dead and e != target:
				_gain_ruin(e, occ.unravel_ranks)
				unr_hit += 1
		if unr_hit > 0:
			_log("   → Talent: Unraveling — the ruin seeps outward (+%d Ruin to %d others)" % [
				occ.unravel_ranks, unr_hit], "#b0a8e0")
	# Avatar of Ruin: a target still held at 5 is primed anew — the bomb
	# goes off again at its next turn.
	if det_avatar and not target.dead and target.status_stacks("ruin") >= 5 \
			and not target.has_status("ruin_primed"):
		_apply_status(target, "ruin_primed", 1)
		_log("   → Avatar of Ruin — the mark endures; %s will detonate again" % \
			target.unit_name, "#c060d0")
	if det_died:
		_stat("enemy_deaths")
		_sfx("death", -4.0)
		_message("%s falls!" % target.unit_name)
		_log("† %s dies" % target.unit_name, "#e05050")


# Guards Communion against release chains: a communion-granted stack may
# trigger a release (and its heal), but never rolls Communion again.
# Without this, Apostle pins allies at 5 and two of them re-trigger each
# other forever — a guaranteed infinite recursion.
var _communion_chain := false


# Conviction: a mitigated hit steels the struck ally. At 5 stacks the
# ally is healed (Blessed are the Faithful deepens it), Faith resets —
# unless Binding Oath keeps a remnant or Apostle keeps it all — the
# Devout sips Mana, and Communion may spread the fervor.
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
			u.faith_stacks, 3 * u.faith_stacks, 2 * u.faith_stacks,
			15 + 5 * devout.faithful_ranks]
		if not u.update_status("faith", "F%d" % u.faith_stacks, f_desc):
			u.add_status("faith", "Faith", "F%d" % u.faith_stacks,
				Color(0.98, 0.85, 0.45), -1, f_desc)
		return
	# The fifth stack: release. Apostle keeps the ally parked at 5 (every
	# further gain re-triggers this); Binding Oath keeps a remnant.
	var keep := 0
	if devout.apostle > 0:
		keep = 5
	elif devout.oath_ranks > 0:
		keep = mini(devout.oath_ranks, 4)
	u.faith_stacks = keep
	if keep > 0:
		var k_desc := "Conviction: Faith x%d — %d%% damage\nmitigation and +%d%% damage dealt.\nAt 5 stacks: healed for %d%% max\nhealth." % [
			keep, 3 * keep, 2 * keep, 15 + 5 * devout.faithful_ranks]
		if not u.update_status("faith", "F%d" % keep, k_desc):
			u.add_status("faith", "Faith", "F%d" % keep,
				Color(0.98, 0.85, 0.45), -1, k_desc)
	else:
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
	if devout.apostle > 0:
		_log("   → Talent: Apostle — %s's Faith burns undimmed (stays at 5)" % \
			u.unit_name, "#b0a8e0")
	elif keep > 0:
		_log("   → Talent: Binding Oath — %s keeps %d Faith" % [
			u.unit_name, keep], "#b0a8e0")
	# Communion: fervor is contagious (chance scales with the OTHERS' Faith).
	if devout.communion_ranks > 0 and not _communion_chain:
		_communion_chain = true
		for h in heroes:
			if h == u or h.dead or h.is_companion or h.faith_stacks <= 0:
				continue
			if randf() < 0.20 * devout.communion_ranks * h.faith_stacks:
				_log("   → Talent: Communion — %s's fervor spreads to %s" % [
					u.unit_name, h.unit_name], "#b0a8e0")
				_gain_faith(h, 1)
		_communion_chain = false


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
	if attacker.second_resource_name != "Mercy":
		return false
	# Avatar of Mercy makes Empower unconditional — no stack even needed.
	if attacker.second_resource < 1 and attacker.avatar_of_mercy <= 0:
		return false
	# The no-cost checks are either/or — never a double refund: Avatar of
	# Mercy (unconditional) supersedes Ardor (held-Mercy threshold), and
	# Sanctified only rolls when a stack would actually be spent.
	if attacker.avatar_of_mercy > 0:
		_log("   → Capstone: Avatar of Mercy — the Empowerment costs nothing", "#b0a8e0")
	elif attacker.ardor_ranks > 0 \
			and attacker.second_resource >= 5 - attacker.ardor_ranks:
		attacker.float_text("Mercy preserved", Color(0.95, 0.8, 0.3))
		_log("   → Talent: Ardor — held Mercy carries the Empowerment; no stack is consumed", "#b0a8e0")
	# Sanctified (talent): the surcharge can be refunded too.
	elif attacker.sanctified_ranks > 0 and randf() < 0.10 * attacker.sanctified_ranks:
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
			# Absorbs 30% (perfect 35%) of the DEVOUT's max health, carrying
			# the tree's riders (Blessed Barrier / Afterglow; Covenant fires
			# through the lethal-save hook). Stalwart deepens the absorb.
			var ds_pct := (0.35 if is_perfect else 0.30) + 0.05 * attacker.stalwart_ranks
			var shield := int(round(attacker.max_hp * ds_pct))
			_sfx("parry", -6.0, 0.6)
			_grant_divine_shield(attacker, target, shield)
			_message("%s shields %s (%d)" % [attacker.unit_name, target.unit_name, shield])
			_log("%s: Divine Shield on %s — absorbs %d (%d%% of the Devout's health%s)" % [
				attacker.unit_name, target.unit_name, shield,
				int(round(ds_pct * 100)),
				", Stalwart" if attacker.stalwart_ranks > 0 else ""], "#70d878")
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
				_overflow_spill(attacker, h)
				if h_crit > 1.0:
					_radiant_cascade(attacker, got, h)
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
			# Sacred Resolve (talent ability). Healing Pulse and Cleansing
			# Waters are no longer snapshotted here — they read the living
			# Devout at the turn-start block, and key off EITHER banner
			# (this or Consecrated Ground) since Batch K.
			_sfx("heal", -5.0, 0.7)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "unity", 4 if is_perfect else 3)
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
			# Crusader's Tempo: the cast-time cooldown tick digs deeper.
			var zeal_ticks := 1 + attacker.crusade_ranks
			var zeal_ticked := false
			for zeal_cd in target.cooldowns.keys():
				if int(target.cooldowns[zeal_cd]) > 0:
					target.cooldowns[zeal_cd] = maxi(
						int(target.cooldowns[zeal_cd]) - zeal_ticks, 0)
					zeal_ticked = true
			_message("%s kindles %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Blessing of Zeal on %s — +15%% damage, Faith gain doubled (%d turns)%s" % [
				attacker.unit_name, target.unit_name, 4 if is_perfect else 3,
				("; cooldowns tick %d" % zeal_ticks) if zeal_ticked else ""], "#e8b860")
			if zeal_ticked and attacker.crusade_ranks > 0:
				_log("   → Talent: Crusader's Tempo — the blessing hastens %d turns of cooldown" % \
					zeal_ticks, "#b0a8e0")
			# Purity: the blessing carries a Divine Shield — doubled Faith
			# gain finally travels WITH a Faith source.
			if attacker.purity_ranks > 0:
				var purity_pow := maxi(int(round(
					attacker.max_hp * 0.10 * attacker.purity_ranks)), 1)
				_grant_divine_shield(attacker, target, purity_pow)
				target.float_text("Purity %d" % purity_pow, Color(0.95, 0.9, 0.6))
				_log("   → Talent: Purity — the blessing carries a shield (%d)" % \
					purity_pow, "#b0a8e0")
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
		"bewitch":
			_sfx("break", -8.0, 1.4)
			_apply_status(target, "bewitch", 3)
			_gain_ruin(target, 1)
			_message("%s bewitches %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Bewitch — %s will turn on its allies (3 turns)" % [
				attacker.unit_name, target.unit_name], "#c070e0")
			# Perfect: the charm takes hold INSTANTLY — one strike right now.
			if is_perfect and target.has_status("bewitch") and not target.dead:
				await _wait(0.4)
				await _bewitched_strike(target)
		"dark_pact":
			# Blood for blood: the Occultist bleeds so the party may live.
			# Pact of Flesh thins the toll (20% base, -10%/rank — free at 2).
			var pact_pct := maxf(0.20 - 0.10 * attacker.pact_flesh_ranks, 0.0)
			var pact_cost := 0
			if pact_pct > 0.0:
				pact_cost = maxi(int(round(attacker.max_hp * pact_pct)), 1)
				attacker.hp = maxi(attacker.hp - pact_cost, 1)
				attacker.float_text("-%d" % pact_cost, Color(1.0, 0.4, 0.5))
				attacker.refresh_bars()
			elif attacker.pact_flesh_ranks > 0:
				_log("   → Talent: Pact of Flesh — the pact costs nothing", "#b0a8e0")
			_sfx("heal", -5.0, 0.6)
			# The pact-maker bleeds; every OTHER party member drinks. Dark
			# Barter deepens the draught (15% base, +10%/rank).
			var pact_heal_pct := 0.15 + 0.10 * attacker.barter_ranks
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				if h == attacker:
					continue
				var dp_amt := maxi(int(round(h.max_hp * pact_heal_pct)), 1)
				var dp_hgot: int = h.heal_amount(dp_amt, true)
				h.float_text("+%d" % dp_hgot, Color(0.7, 0.4, 0.9))
				_stat("healing", dp_hgot)
			if attacker.barter_ranks > 0:
				_log("   → Talent: Dark Barter — the party drinks %d%% (up from 15%%)" % \
					int(round(pact_heal_pct * 100)), "#b0a8e0")
			# The Occultist knits back together over 3 turns (10%/turn).
			var pact_tick := maxi(int(round(attacker.max_hp * 0.10)), 1)
			_apply_status(attacker, "renewal", 3, 0, pact_tick)
			attacker.update_status("renewal", "R+",
				"Dark Pact: restores %d HP at the start\nof each turn (10%% of max health)." % pact_tick)
			# Invigoration (talent): the pact also drips Mana back.
			if attacker.invigoration_ranks > 0:
				var invig_tick := maxi(int(round(attacker.max_resource
					* 0.02 * attacker.invigoration_ranks)), 1)
				_apply_status(attacker, "invig", 3, invig_tick)
			if is_perfect:
				attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
				attacker.float_text("+5 Mana", Color(0.5, 0.7, 1.0))
				attacker.refresh_bars()
			_message("%s seals the Dark Pact!" % attacker.unit_name)
			_log("%s: Dark Pact — bleeds %d; the party heals %d%% of max health" % [
				attacker.unit_name, pact_cost, int(round(pact_heal_pct * 100))], "#b070d0")
		"hysteria":
			_sfx("break", -6.0, 1.2)
			for e in enemies.filter(func(en): return not en.dead):
				_apply_status(e, "hysteria", -1)
			_message("%s unleashes MASS HYSTERIA!" % attacker.unit_name)
			_log("%s: Mass Hysteria — the warband turns on itself next turn" % \
				attacker.unit_name, "#c070e0")
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
			# The Whole Forest: the wire never comes up again.
			if attacker.whole_forest > 0:
				_apply_status(attacker, "tripwire", -1)
				_log("%s: Tripwire set — the whole forest is rigged" % \
					attacker.unit_name, "#70d878")
			else:
				_apply_status(attacker, "tripwire", 6 if is_perfect else 5)
				_log("%s: Tripwire set" % attacker.unit_name, "#70d878")
			_message("%s rigs the ground" % attacker.unit_name)
		"summon":
			await _do_summon(attacker, ab.display_name.get_slice(" ", 1).to_lower(),
				target)
		"kill_command":
			# The order is the beast's own: maul, feast, or blinding dive.
			# The Pack: BOTH beasts obey; if the prey falls mid-order the
			# rest of the pack turns on the next weakest.
			var kc_beasts: Array = _beasts(attacker)
			if not kc_beasts.is_empty() and target != null and not target.dead:
				_message("%s: KILL COMMAND!" % attacker.unit_name)
				var kc_target: BattleUnit = target
				for comp in kc_beasts:
					if comp.dead:
						continue
					if kc_target == null or kc_target.dead:
						var kc_next := enemies.filter(func(e): return not e.dead)
						if kc_next.is_empty():
							break
						kc_target = _lowest_hp(kc_next)
					var kc_l: int = int(attacker.loyalty.get(comp.companion_kind, 0))
					var kc_mult := _comp_dmg_mult(comp)
					_log("%s orders %s to savage %s!" % [attacker.unit_name,
						comp.unit_name, kc_target.unit_name], "#e0a050")
					match comp.companion_kind:
						"ursus":
							await _companion_hit(comp, kc_target,
								0.45 * comp.attack * kc_mult, 40)
						"canis":
							var kc_bleed := 10 + 2 * kc_l \
								+ (10 if comp.has_status("bestial") else 0)
							for _bite in 3:
								if kc_target.dead or comp.dead:
									break
								await _companion_hit(comp, kc_target,
									0.18 * comp.attack * kc_mult, 0)
								if not kc_target.dead:
									_add_bleed_with_burst(kc_target, kc_bleed)
							if not comp.dead:
								var kc_heal: int = comp.heal_amount(
									int(comp.max_hp * 0.30))
								comp.float_text("+%d" % kc_heal, Color(0.4, 0.9, 0.45))
								comp.refresh_bars()
								_log("   → %s feasts — heals %d" % [comp.unit_name,
									kc_heal], "#70d878")
						"aguila":
							var kc_second: BattleUnit = second_target
							if kc_second == null or kc_second.dead or kc_second == kc_target:
								var kc_pool := enemies.filter(
									func(e): return not e.dead and e != kc_target)
								kc_second = (null if kc_pool.is_empty() \
									else _lowest_hp(kc_pool))
							for kc_t in [kc_target, kc_second]:
								if kc_t == null or kc_t.dead:
									continue
								await _companion_hit(comp, kc_t,
									0.25 * comp.attack * kc_mult, 0, 0.20 * kc_l)
								if not kc_t.dead:
									_apply_status(kc_t, "blind", 3)
					# A perfect order deepens the bond.
					if is_perfect:
						_gain_loyalty(attacker, comp.companion_kind)
		"snare_trap":
			if target != null and not target.dead:
				var sn_i := heroes.find(attacker)
				_apply_status(target, "snared", -1, sn_i)
				if is_perfect:
					var sn_st: Dictionary = target.get_status("snared")
					if not sn_st.is_empty():
						sn_st["perfect"] = true
				_sfx("click", -8.0, 0.8)
				_message("%s rigs a snare under %s" % [attacker.unit_name,
					target.unit_name])
				_log("%s: Snare Trap set beneath %s" % [attacker.unit_name,
					target.unit_name], "#c8a860")
				_hit_and_run(attacker)
		"deadfall":
			attacker.deadfall_armed += 1
			if not attacker.update_status("deadfall", "DF%d" % attacker.deadfall_armed,
					"Deadfall armed: the next enemy to act\nsprings it.", attacker.deadfall_armed):
				attacker.add_status("deadfall", "Deadfall", "DF%d" % attacker.deadfall_armed,
					Color(0.75, 0.65, 0.30), -1,
					"Deadfall armed: the next enemy to act\nsprings it.", attacker.deadfall_armed)
			_sfx("click", -8.0, 0.7)
			_message("%s rigs a deadfall..." % attacker.unit_name)
			_log("%s: Deadfall armed — the next enemy to act pays for it" % \
				attacker.unit_name, "#c8a860")
		"venom_coat":
			_apply_status(attacker, "venom_coat", 4)
			_sfx("heal", -9.0, 0.7)
			_message("%s coats their arrows" % attacker.unit_name)
			_log("%s: Venom Coating — every attack Poisons for 4 turns" % \
				attacker.unit_name, "#70d878")
		"harvest":
			if target != null and not target.dead:
				var hv_n := _status_count(target)
				if hv_n <= 0:
					_log("%s: Harvest — nothing on %s to reap" % [attacker.unit_name,
						target.unit_name], "#909090")
				else:
					target.purge_debuffs()
					var hv_raw := 0.12 * attacker.attack * hv_n * randf_range(0.9, 1.1)
					hv_raw *= 1.0 - float(target.resists.get("nature", 0.0))
					var hv_final := maxi(int(round(hv_raw \
						* (1.0 - target.effective_armor()))), 1)
					var hv_res: Dictionary = target.take_hit(hv_final, 0)
					target.float_text("%d Harvest" % hv_final, Color(0.45, 0.8, 0.3))
					var hv_heal: int = attacker.heal_amount(
						int(hv_final * (1.5 if is_perfect else 1.0)))
					attacker.float_text("+%d" % hv_heal, Color(0.4, 0.9, 0.45))
					_sfx("crit", -6.0, 0.7)
					_message("%s reaps the rot!" % attacker.unit_name)
					_log("%s: Harvest — %d statuses consumed, %d damage, %d healed" % [
						attacker.unit_name, hv_n, hv_final, hv_heal], "#70d878")
					attacker.refresh_bars()
					if hv_res.died:
						_stat("enemy_deaths")
						_sfx("death", -4.0)
						_message("%s falls!" % target.unit_name)
						_log("† %s dies" % target.unit_name, "#e05050")
						_on_enemy_death(target)
		"hold_breath":
			_gain_focus(attacker, 40)
			var hb_shots := 2 if attacker.second_nature > 0 else 1
			var hbi: Array = STATUS_INFO["held_breath"]
			if not attacker.update_status("held_breath", "HB%d" % hb_shots,
					hbi[3], hb_shots):
				attacker.add_status("held_breath", hbi[0], "HB%d" % hb_shots,
					hbi[2], -1, hbi[3], hb_shots)
			_sfx("heal", -8.0, 0.6)
			_message("%s holds their breath..." % attacker.unit_name)
			_log("%s: Hold Breath — +40 Focus; the next %s guaranteed critical, armor ignored" % [
				attacker.unit_name,
				"2 attacks are" if hb_shots == 2 else "attack is a"], "#70d878")
		"instinct":
			# Instinctive (talent) deepens the trance to 5 shots.
			var hi_shots := 5 if attacker.instinctive > 0 else 3
			var hi_info: Array = STATUS_INFO["instinct"]
			if not attacker.update_status("instinct", "HI%d" % hi_shots,
					hi_info[3], hi_shots):
				attacker.add_status("instinct", hi_info[0], "HI%d" % hi_shots,
					hi_info[2], -1, hi_info[3], hi_shots)
			_sfx("heal", -7.0, 0.8)
			_message("%s trusts the instinct!" % attacker.unit_name)
			_log("%s: Hunter's Instinct — the next %d Quick Shots are empowered" % [
				attacker.unit_name, hi_shots], "#70d878")
		"bestial":
			# The Pack: the wrath takes every beast at once.
			for bw_comp in _beasts(attacker):
				# Devoted Fury: deep Loyalty stretches the Wrath.
				var bw_turns := 3
				if attacker.devoted_fury > 0:
					bw_turns += int(attacker.loyalty.get(
						bw_comp.companion_kind, 0)) / 2
				_apply_status(bw_comp, "bestial", bw_turns)
				_sfx("crit", -5.0, 0.5)
				_message("%s: BESTIAL WRATH!" % bw_comp.unit_name)
				match bw_comp.companion_kind:
					"ursus":
						# The bear swells: doubled health, half again the armor,
						# and it drags three enemies onto itself.
						bw_comp.bestial_hp_bonus = bw_comp.max_hp
						bw_comp.max_hp += bw_comp.bestial_hp_bonus
						bw_comp.hp += bw_comp.bestial_hp_bonus
						bw_comp.bestial_armor_bonus = bw_comp.armor * 0.5
						bw_comp.armor += bw_comp.bestial_armor_bonus
						bw_comp.refresh_bars()
						var bw_idx := heroes.find(attacker)
						var bw_pool := enemies.filter(func(e): return not e.dead)
						bw_pool.shuffle()
						var bw_taunted := 0
						for bw_e in bw_pool:
							if bw_taunted >= 3:
								break
							if bw_idx >= 0:
								_apply_status(bw_e, "mocked", 2, 100 + bw_idx)
								bw_taunted += 1
						_log("%s: Bestial Wrath — doubled health, +50%% armor, %d enemies taunted" % [
							bw_comp.unit_name, bw_taunted], "#e0a050")
					"canis":
						_log("%s: Bestial Wrath — +50%% damage and +10 Bleed for 3 turns" % \
							bw_comp.unit_name, "#e0a050")
					"aguila":
						_log("%s: Bestial Wrath — +25%% damage and Blinding strikes for 3 turns" % \
							bw_comp.unit_name, "#e0a050")
		"spirit_bond":
			# The Pack: the bond flows through every beast (the hunter's own
			# share — heal, Mana, regen — lands once).
			var sb_beasts: Array = _beasts(attacker)
			if not sb_beasts.is_empty():
				_sfx("heal", -5.0, 0.7)
				_message("%s shares the spirit bond!" % attacker.unit_name)
				var sb_self: int = attacker.heal_amount(int(attacker.max_hp * 0.25))
				attacker.float_text("+%d" % sb_self, Color(0.4, 0.9, 0.45))
				# Deep Reserves (talent) widens the flow.
				var sb_mana := int(attacker.max_resource \
					* (0.15 + 0.08 * attacker.deep_reserves_ranks))
				attacker.resource = mini(attacker.resource + sb_mana,
					attacker.max_resource)
				_log("%s: Spirit Bond — heals %d, +%d Mana" % [
					attacker.unit_name, sb_self, sb_mana], "#70d878")
				_apply_status(attacker, "spirit_heal", 1,
					int(attacker.max_hp * 0.10))
				_apply_status(attacker, "spirit_mana", 2,
					int(attacker.max_resource * 0.05))
				for sb_comp in sb_beasts:
					var sb_beast: int = sb_comp.heal_amount(int(sb_comp.max_hp * 0.25))
					sb_comp.float_text("+%d" % sb_beast, Color(0.4, 0.9, 0.45))
					_log("   → the bond mends %s for %d" % [sb_comp.unit_name,
						sb_beast], "#70d878")
					_apply_status(sb_comp, "spirit_heal", 1,
						int(sb_comp.max_hp * 0.10))
					sb_comp.refresh_bars()
				if is_perfect:
					for sb_u in [attacker] + sb_beasts:
						if sb_u.vigor_hp_bonus > 0:
							continue  # never stack the borrowed health
						sb_u.vigor_hp_bonus = int(sb_u.max_hp * 0.10)
						sb_u.max_hp += sb_u.vigor_hp_bonus
						sb_u.hp += sb_u.vigor_hp_bonus
						_apply_status(sb_u, "vigor", 5)
						sb_u.refresh_bars()
					_log("   → Perfect: all gain +10%% max health for 5 turns",
						"#70d878")
				attacker.refresh_bars()
		"primal_surge":
			# Spend ALL Loyalty: every beast erupts, the hunter burns on
			# for the TOTAL stacks spent across the pack.
			if target != null and not target.dead:
				var ps_total := 0
				for ps_comp in _beasts(attacker):
					var ps_l: int = int(attacker.loyalty.get(ps_comp.companion_kind, 0))
					if ps_l <= 0 or target.dead:
						continue
					if ps_total == 0:
						_message("%s: PRIMAL SURGE!" % attacker.unit_name)
					ps_total += ps_l
					_log("%s: Primal Surge — %s spends %d Loyalty" % [
						attacker.unit_name, ps_comp.unit_name, ps_l], "#e0a050")
					await _companion_hit(ps_comp, target,
						0.15 * ps_l * attacker.attack * _bestial_dmg_mult(ps_comp), 0)
					# Perfect: the fire takes nothing with it.
					if not is_perfect:
						attacker.loyalty[ps_comp.companion_kind] = 0
						ps_comp.remove_status("loyalty")
					else:
						_stamp_loyalty_chip(attacker, ps_comp)
				if ps_total > 0:
					_apply_status(attacker, "primal_surge", ps_total)
					if is_perfect:
						_log("   → Perfect: the Loyalty is spent but not lost",
							"#70d878")
		"call_wild":
			# The whole pack answers: every beast strikes and announces
			# itself; the absent ones return to the wild after.
			if target != null and not target.dead:
				_message("%s: CALL OF THE WILD!" % attacker.unit_name)
				_log("%s sounds the Call of the Wild!" % attacker.unit_name,
					"#e0a050")
				var cw_beasts: Array = _beasts(attacker)
				for cw_kind in ["ursus", "canis", "aguila"]:
					attacker.kinds_summoned[cw_kind] = true
					if target.dead:
						break
					var cw_b: BattleUnit = null
					for cwb in cw_beasts:
						if cwb.companion_kind == cw_kind and not cwb.dead:
							cw_b = cwb
					if cw_b != null:
						await _companion_strike(cw_b, target, 1.0, false)
						await _arrival_for_kind(attacker, cw_kind, cw_b, target)
					else:
						await _ghost_hit(attacker, cw_kind, target,
							0.15 * attacker.attack)
						if not target.dead or cw_kind == "canis":
							await _arrival_for_kind(attacker, cw_kind, null, target)
		"mark_hunt":
			if target != null and not target.dead:
				var mk_turns := 7 if is_perfect else 5
				_apply_status(target, "hunt_mark", mk_turns, heroes.find(attacker))
				_sfx("crit", -8.0, 1.1)
				_message("%s marks %s for the hunt!" % [attacker.unit_name,
					target.unit_name])
				_log("%s: Mark of the Hunt — %s is marked (%d turns)" % [
					attacker.unit_name, target.unit_name, mk_turns], "#e0a050")
		"blood_price":
			# Blood for fury: pays 15% of CURRENT health (half on a perfect),
			# clamped so the price can never kill him. Cost scales with what
			# he has — cheap opener, real gamble when low. This is how the
			# Berserker CHOOSES when Blood Frenzy wakes instead of waiting
			# for the enemy to decide it.
			var bp_cost := maxi(int(round(attacker.hp * (0.075 if is_perfect else 0.15))), 1)
			attacker.hp = maxi(attacker.hp - bp_cost, 1)
			attacker.float_text("-%d" % bp_cost, Color(1.0, 0.4, 0.5))
			# The self-cut banks its Frenzy floor immediately, like any hit
			# taken (Batch A rule: dives count even if healed away).
			if attacker.passive_id == "bloodrage":
				attacker.frenzy_bonus()
			_sfx("crit", -8.0, 0.7)
			attacker.resource = mini(attacker.resource + 30, attacker.max_resource)
			attacker.float_text("+30 Rage", Color(1.0, 0.5, 0.4))
			_apply_status(attacker, "blood_price", 2)
			attacker.refresh_bars()
			_message("%s pays the Blood Price!" % attacker.unit_name)
			_log("%s: Blood Price — bleeds %d HP for 30 Rage and +25%% damage (2 turns)%s" % [
				attacker.unit_name, bp_cost,
				" [PERFECT: cost halved]" if is_perfect else ""], "#e05050")
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
		"guard_change":
			# The swap itself (Rage and cooldown already handled generically).
			attacker.stance = "defensive" if attacker.stance == "aggressive" \
				else "aggressive"
			var gc_label := "Aggressive" if attacker.stance == "aggressive" \
				else "Defensive"
			_sfx("parry", -6.0, 0.8)
			attacker.float_text("%s Stance" % gc_label, Color(0.4, 0.9, 1.0))
			attacker.refresh_bars()  # restamps the stance chip
			# Tempo: the pivot itself becomes an attack — momentum for a turn.
			if attacker.tempo_ranks > 0:
				var tp_pct := 10 * attacker.tempo_ranks
				_apply_status(attacker, "tempo", 2, tp_pct)
				attacker.update_status("tempo", "+%d%%" % tp_pct,
					"Tempo: +%d%% damage for one turn\n(granted by switching stance)." % tp_pct,
					tp_pct)
				_log("   → Talent: Tempo — +%d%% damage for a turn" % tp_pct,
					"#b0a8e0")
			# The pivot presses the opening he already made: 15 BD to the
			# un-Broken enemy nearest to Breaking (auto-picked — the ability
			# takes no target, keeping autoplay await-free).
			var gc_mark: BattleUnit = null
			for e in enemies:
				if not e.dead and not e.broken \
						and (gc_mark == null or e.pressure > gc_mark.pressure):
					gc_mark = e
			var gc_bd_txt := ""
			if gc_mark != null:
				var gc_res: Dictionary = gc_mark.take_hit(0, 15)
				gc_mark.float_text("+%d BD" % int(gc_res["bd"]), Color(0.8, 0.35, 1.0))
				gc_bd_txt = "; %d BD to %s" % [int(gc_res["bd"]), gc_mark.unit_name]
				if gc_res["broke"]:
					_stat("breaks_on_enemies")
					_sfx("break", -3.0)
					_message("%s BREAKS!" % gc_mark.unit_name)
					_log("!! %s BREAKS" % gc_mark.unit_name, "#c070e0")
					await _break_impact()
					# No Quarter pays on this Break too — the swap that lands
					# the final Break refunds its own Overpower.
					if attacker.no_quarter_ranks > 0:
						var gc_nq := 15 * attacker.no_quarter_ranks
						attacker.resource = mini(attacker.resource + gc_nq,
							attacker.max_resource)
						attacker.refresh_bars()
						attacker.float_text("+%d Rage" % gc_nq, Color(1.0, 0.5, 0.4))
						_log("   → Talent: No Quarter — the Break grants %s +%d Rage" % [
							attacker.unit_name, gc_nq], "#b0a8e0")
			if is_perfect:
				_apply_status(attacker, "parry_up", 2, 10)
				attacker.update_status("parry_up", "P+",
					"+%d%% parry chance." % (10
					+ int(round(attacker.pommel_parry_bonus * 100))))
			_message("%s shifts his guard — %s!" % [attacker.unit_name, gc_label])
			_log("%s: Guard Change — %s stance%s%s" % [attacker.unit_name,
				gc_label, gc_bd_txt,
				" [PERFECT: +10% parry, 2 turns]" if is_perfect else ""], "#70d878")
		"shield_block":
			# Shield Mastery (the re-specced wd_shieldwall node) deepens
			# every cast, the perfect one included.
			var blocks := (5 if is_perfect else 3) + attacker.shield_mastery_ranks
			_sfx("parry", -6.0, 0.5)
			_apply_status(attacker, "shield_charges", -1, blocks)
			# The chip counts the blocks owed (recasting resets the count).
			attacker.update_status("shield_charges", "SW%d" % blocks,
				"Shieldwall: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % blocks,
				blocks)
			_message("%s raises the shield!" % attacker.unit_name)
			_log("%s: Shieldwall — the next %d attacks will be BLOCKED" % [
				attacker.unit_name, blocks], "#8c9cc8")
		"interpose":
			# The tank verb the kit was missing: cover the whole line. Rides
			# the existing shield_charges status — it already counts down,
			# renders a chip, and outranks the block roll. Charges ADD to any
			# the ally is holding (a prior Interpose or the Warden's own wall).
			_sfx("parry", -6.0, 0.5)
			# Bulwark Line thickens the cover: +1 charge per rank per ally.
			var sw_grant := 1 + attacker.bulwark_line_ranks
			for h in heroes:
				if h.dead or h.is_companion:
					continue
				if h == attacker and not is_perfect:
					continue
				var sw_held := maxi(h.status_power("shield_charges"), 0) \
					if h.has_status("shield_charges") else 0
				var sw_total := sw_held + sw_grant
				_apply_status(h, "shield_charges", -1, sw_total)
				h.update_status("shield_charges", "SW%d" % sw_total,
					"Shieldwall: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % sw_total,
					sw_total)
				h.float_text("COVERED", Color(0.75, 0.8, 0.95))
			if attacker.bulwark_line_ranks > 0:
				_log("   → Talent: Bulwark Line — each ally gains %d charges" % \
					sw_grant, "#b0a8e0")
			_message("%s covers the line!" % attacker.unit_name)
			_log("%s: Interpose — every ally gains a Shieldwall charge%s" % [
				attacker.unit_name,
				" [PERFECT: the Warden too]" if is_perfect else ""], "#8c9cc8")
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
						target.get_status("renewal")["sanctum"] = attacker.living_sanctum > 0
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
			# Icy Resolve (talent): the hoarfrost roots deeper.
			var rime_turns := (4 if is_perfect else 3) + attacker.icy_resolve_ranks
			_apply_status(target, "rime", rime_turns)
			_apply_status(target, "frostbite", 2)
			_message("%s rimes %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Rime on %s — its chills will spread (%d turns)" % [
				attacker.unit_name, target.unit_name, rime_turns], "#7cc8f0")
		"stabilize":
			# Vents the Resonance stacks ABOVE the floor (2, raised by Still
			# Mind): Mana back and a damage-reduction ward per stack consumed.
			# A tactical valve, not a reset — the engine keeps running (Batch P).
			var st_floor := 2 + attacker.still_mind_ranks
			var st_stacks := attacker.second_resource - st_floor
			if attacker.master_moments > 0:
				# Master of Moments: full value from every stack, none consumed.
				st_stacks = attacker.second_resource
			else:
				attacker.second_resource = st_floor
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
			if attacker.master_moments > 0:
				_log("%s: Stabilize (Master of Moments) — %d stacks channelled, none consumed: +%d Mana, -%d%% damage taken (2 turns)" % [
					attacker.unit_name, st_stacks, st_mana, st_dr], "#b085e0")
			else:
				_log("%s: Stabilize — %d stacks vented (%d remain): +%d Mana, -%d%% damage taken (2 turns)" % [
					attacker.unit_name, st_stacks, attacker.second_resource,
					st_mana, st_dr], "#b085e0")
		"overcharge":
			attacker.overcharged = true
			attacker.overcharge_mult = 1.65 if is_perfect else 1.5
			# Resonant Core raises both ceilings; Singularity has none to raise.
			if attacker.singularity == 0:
				attacker.second_max = 8 + attacker.resonant_core_ranks
			_sfx("perfect", -6.0, 0.8)
			_apply_status(attacker, "overcharged", -1)
			attacker.refresh_bars()
			_message("%s OVERCHARGES!" % attacker.unit_name)
			_log("%s: Overcharge — max Resonance is now %s; stacks beyond 5 weigh %.2fx" % [
				attacker.unit_name,
				("unlimited" if attacker.singularity > 0 else str(attacker.second_max)),
				attacker.overcharge_mult], "#b085e0")
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
			_overflow_spill(attacker, target)
			if hh_crit > 1.0:
				_radiant_cascade(attacker, hh_got, target)
			_sanctum_echo(attacker, hh_got)
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
			_sanctum_echo(attacker, dp_got)
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
			# On the Mend and Living Sanctum ride the status (snapshotted):
			# ticks can dispel, and can echo to the party.
			if target.has_status("renewal"):
				target.get_status("renewal")["mend"] = attacker.on_mend_ranks
				target.get_status("renewal")["sanctum"] = attacker.living_sanctum > 0
			if empowered and target != attacker:
				_apply_status(attacker, "renewal", 5, 0, ren_tick)
				attacker.update_status("renewal", "R+",
					"Renewal: restores %d HP at the start\nof each turn (15%% of the caster's\nmax health)." % ren_tick)
				if attacker.has_status("renewal"):
					attacker.get_status("renewal")["mend"] = attacker.on_mend_ranks
					attacker.get_status("renewal")["sanctum"] = attacker.living_sanctum > 0
			if is_perfect:
				# Triage: the burst can crit (captured so Radiant Cascade
				# knows to splash).
				var rb_crit := _heal_crit_mult(attacker)
				var ren_burst := maxi(int(round(attacker.max_hp * 0.05 * rb_crit)), 1)
				var burst_got: int = target.heal_amount(ren_burst, target != attacker)
				target.float_text("+%d" % burst_got, Color(0.4, 0.9, 0.45))
				_stat("healing", burst_got)
				_bank_overheal(attacker, target)
				_overflow_spill(attacker, target)
				if rb_crit > 1.0:
					_radiant_cascade(attacker, burst_got, target)
				_sanctum_echo(attacker, burst_got)
			_message("%s blesses %s with Renewal" % [attacker.unit_name, target.unit_name])
			_log("%s: Renewal on %s — %d HP/turn for 5 turns%s" % [attacker.unit_name,
				target.unit_name, ren_tick,
				" (Empowered: the Cleric too)" if empowered else ""], "#70d878")


# ---------- Beastmaster companions ----------

# kind -> [max HP, sphere tint] (placeholder spheres until beast art exists).
const COMPANION_STATS := {
	"ursus": [110, Color(0.9, 0.3, 0.25)],
	"canis": [80, Color(0.35, 0.55, 0.95)],
	"aguila": [80, Color(0.35, 0.85, 0.4)],
}


# The hunter's LIVING beasts. Every companion site loops over this — the
# single-beast case is simply a one-element array, so the paths never fork.
func _beasts(hunter: BattleUnit) -> Array:
	if hunter == null:
		return []
	return hunter.beasts.filter(func(b): return is_instance_valid(b) and not b.dead)


# How many beasts the hunter may field at once (The Pack capstone: two).
func _beast_cap(hunter: BattleUnit) -> int:
	return 2 if hunter.the_pack > 0 else 1


# Removes a beast from the field entirely (replaced, or a corpse cleaned
# up by the next call). Its plate goes with it — a corpse's lingers only
# until then.
func _free_beast(hunter: BattleUnit, comp: BattleUnit) -> void:
	hunter.beasts.erase(comp)
	if not is_instance_valid(comp):
		return
	companions.erase(comp)
	if hunter.soul_partner == comp:
		hunter.soul_partner = null
	comp.free_plate()
	comp.queue_free()


# Summons the hunter's next beast (The Pack fields two). At capacity the
# call REPLACES the living beast with lower Loyalty. The newcomer inherits
# the hunter's armor, stability, and crit chance; it has no resource and
# takes no turns. A swap (replacing a LIVING beast) starts the shared Swap
# cooldown; the arriving beast keeps its Loyalty, gains +1, and fires its
# arrival effect.
func _do_summon(hunter: BattleUnit, kind: String, target: BattleUnit = null) -> void:
	# Fallen beasts leave the field on the next call, exactly as the
	# single-beast flow always did.
	for old in hunter.beasts.duplicate():
		if not is_instance_valid(old) or old.dead:
			_free_beast(hunter, old)
	var was_swap := false
	if _beasts(hunter).size() >= _beast_cap(hunter):
		# Replace whichever active beast holds the lower Loyalty.
		var living_b: Array = _beasts(hunter)
		var out: BattleUnit = living_b[0]
		for b in living_b:
			if int(hunter.loyalty.get(b.companion_kind, 0)) \
					< int(hunter.loyalty.get(out.companion_kind, 0)):
				out = b
		was_swap = true
		_free_beast(hunter, out)
	if was_swap and hunter.wild_rotation == 0:
		# Quick Whistle shaves the shared swap cooldown (base effective 2).
		hunter.cooldowns["Swap Companion"] = maxi(3 - hunter.quick_whistle_ranks, 1)
	# No Beast Left: the armed free call is consumed by this summon.
	if hunter.free_summon:
		hunter.free_summon = false
		_log("   → No Beast Left: the call costs nothing", "#b0a8e0")
	var stats: Array = COMPANION_STATS[kind]
	# Lone Bond: the single beast's Loyalty starts deep.
	if hunter.lone_bond > 0 and int(hunter.loyalty.get(kind, 0)) < 3:
		hunter.loyalty[kind] = 3
	# Returning beasts keep their Loyalty; Ursus carries its HP gift too.
	var prior_l: int = int(hunter.loyalty.get(kind, 0))
	# Beast Within grows the base; flat talent HP rides on top.
	var base_hp: int = int(round(stats[0] * (1.0 + hunter.companion_hp_pct))) \
		+ hunter.companion_hp_bonus
	if kind == "ursus":
		base_hp += int(round(stats[0] * 0.03)) * prior_l
	var cfg := {"unit_name": kind.capitalize(), "is_hero": true, "sheet_dir": "sphere",
		"sprite_scale": 1.4, "max_hp": base_hp,
		"attack": hunter.attack,  # beast blows scale with their master
		"armor": hunter.armor, "speed": hunter.speed, "stability": hunter.stability,
		"constitution": hunter.constitution, "abilities": []}
	# Plate slots continue the hero stack: the first free one below the party.
	var plate_slot := heroes.size()
	var used_slots: Array = hunter.beasts.map(
		func(b): return int(b.get_meta("plate_slot", -1)))
	while plate_slot in used_slots:
		plate_slot += 1
	var comp := _make_unit(cfg, hunter.position + Vector2(110, -16)
		+ Vector2(58, 52) * (plate_slot - heroes.size()), stats[1],
		_hero_plate_pos(plate_slot))
	comp.set_meta("plate_slot", plate_slot)
	comp.is_companion = true
	comp.companion_kind = kind
	comp.pack_master = hunter
	comp.crit_bonus = hunter.crit_bonus
	comp.companion_power = hunter.companion_power
	comp.next_time = INF  # never drawn a turn from the timeline
	companions.append(comp)
	hunter.beasts.append(comp)
	_sfx("heal", -7.0, 0.6)
	_message("%s answers the call!" % comp.unit_name)
	_log("%s %s %s" % [hunter.unit_name,
		"swaps in" if was_swap else "summons", comp.unit_name], "#70d878")
	# The wolf and the eagle are permanently Elusive (enemies miss them more).
	if kind in ["canis", "aguila"]:
		var el_info: Array = STATUS_INFO["elusive"]
		comp.add_status("elusive", el_info[0], el_info[1], el_info[2], -1, el_info[3])
	# Feral Momentum / Menagerie bookkeeping: this beast has been fielded.
	hunter.kinds_summoned[kind] = true
	# Ancient Pact: the beast is beyond all mending.
	if hunter.ancient_pact > 0:
		comp.no_heals = true
	# One Soul: hunter and beast share every wound.
	if hunter.one_soul > 0:
		comp.soul_partner = hunter
		hunter.soul_partner = comp
	# Lone Bond starts the beast at 3 Loyalty instead of granting arrival +1.
	if hunter.lone_bond == 0:
		_gain_loyalty(hunter, kind)
		# Shared Devotion: the whole pack feels the call.
		if hunter.shared_devotion > 0:
			for k2 in ["ursus", "canis", "aguila"]:
				if k2 != kind:
					_gain_loyalty(hunter, k2)
	_stamp_loyalty_chip(hunter, comp)
	await _wait(0.5)
	await _arrival_effect(hunter, comp, target)


# Summon-and-swap arrival effects: the beast announces itself.
func _arrival_effect(hunter: BattleUnit, comp: BattleUnit,
		target: BattleUnit) -> void:
	await _arrival_for_kind(hunter, comp.companion_kind, comp, target)


# The arrival itself, per beast. `body` is the summoned unit — null when a
# spirit answers Call of the Wild (self-buffs are skipped; taunts land on
# the active companion if one stands, else on the hunter). Herald widens
# every arrival to an extra target.
func _arrival_for_kind(hunter: BattleUnit, kind: String, body: BattleUnit,
		target: BattleUnit) -> void:
	var caller_name: String = body.unit_name if body != null else kind.capitalize()
	match kind:
		"ursus":
			# Guardian's Roar: taunt the weakest enemy (preferring one not
			# already taunted); a real bear digs in for 2 turns.
			var pool := enemies.filter(func(e): return not e.dead)
			if pool.is_empty():
				return
			_sfx("break", -6.0, 0.8)
			_message("%s: GUARDIAN'S ROAR!" % caller_name)
			var taunts := 2 if hunter.herald > 0 else 1
			var h_idx := heroes.find(hunter)
			var taunted_names: Array = []
			for _t in taunts:
				var fresh := pool.filter(func(e): return not e.dead \
					and not e.has_status("mocked"))
				if fresh.is_empty():
					break
				var tgt: BattleUnit = _lowest_hp(fresh)
				if h_idx >= 0:
					# Companion taunts encode as 100 + the hunter's index; a
					# bodiless roar pulls to the active beast, else the hunter.
					if body != null or not _beasts(hunter).is_empty():
						_apply_status(tgt, "mocked", 2, 100 + h_idx)
					else:
						_apply_status(tgt, "mocked", 2, h_idx)
				taunted_names.append(tgt.unit_name)
			if body != null:
				_apply_status(body, "roar", 2)
			_log("%s: Guardian's Roar — %s taunted%s" % [caller_name,
				", ".join(taunted_names), "; the bear digs in" if body != null \
				else ""], "#e0a050")
		"canis":
			# Bloodhowl: open wounds across the whole warband (Herald doubles
			# the Bleed on the bloodiest enemy).
			_sfx("crit", -6.0, 0.6)
			_message("%s: BLOODHOWL!" % caller_name)
			_log("%s: Bloodhowl — 15 Bleed to every enemy" % caller_name,
				"#e05050")
			var bloodiest: BattleUnit = null
			if hunter.herald > 0:
				for e in enemies.filter(func(en): return not en.dead):
					if bloodiest == null or e.bleed_buildup > bloodiest.bleed_buildup:
						bloodiest = e
			for e in enemies.filter(func(en): return not en.dead):
				_add_bleed_with_burst(e, 30 if e == bloodiest else 15)
			if bloodiest != null and not bloodiest.dead:
				_log("   → Herald: the howl bleeds %s twice as deep" % \
					bloodiest.unit_name, "#e05050")
		"aguila":
			# The eagle dives a chosen enemy: 15% of the hunter's Attack,
			# Dazed (Herald: a second dive on the weakest other enemy).
			var dive: BattleUnit = target
			if dive == null or dive.dead or dive.is_hero:
				var foes := enemies.filter(func(e): return not e.dead)
				dive = null if foes.is_empty() else _lowest_hp(foes)
			if dive == null:
				return
			var dives: Array = [dive]
			if hunter.herald > 0:
				var others := enemies.filter(func(e): return not e.dead and e != dive)
				if not others.is_empty():
					dives.append(_lowest_hp(others))
			for d in dives:
				if d.dead:
					continue
				_sfx("crit", -8.0, 1.3)
				_message("%s dives %s!" % [caller_name, d.unit_name])
				if body != null:
					await _companion_hit(body, d, 0.15 * hunter.attack, 0)
				else:
					await _ghost_hit(hunter, kind, d, 0.15 * hunter.attack)
				if not d.dead:
					_apply_status(d, "dazed", 2)
					_log("   → %s is Dazed by the dive" % d.unit_name, "#e0a050")


# A bodiless beast's blow (Call of the Wild): hunter-statted, Loyalty and
# Momentum honored, Aguila's armor-piercing gift included.
func _ghost_hit(hunter: BattleUnit, kind: String, victim: BattleUnit,
		dmg: float) -> void:
	if victim == null or victim.dead:
		return
	var l: int = int(hunter.loyalty.get(kind, 0))
	var raw := dmg * (1.0 + (0.05 + 0.015 * hunter.wild_communion_ranks) * l) \
		* randf_range(0.9, 1.1)
	if hunter.momentum_ranks > 0 and hunter.kinds_summoned.size() > 0:
		raw *= 1.0 + 0.08 * hunter.momentum_ranks * hunter.kinds_summoned.size()
	var is_crit := randf() < CRIT_CHANCE + hunter.crit_bonus \
		+ (0.25 if victim.broken else 0.0)
	if is_crit:
		raw *= 1.5
	raw *= 1.0 - float(victim.resists.get("physical", 0.0))
	var pen := clampf(((0.20 * l) if kind == "aguila" else 0.0), 0.0, 1.0)
	var gh_armor := victim.effective_armor() * (1.0 - pen)
	var final := maxi(int(round(raw * (1.0 - gh_armor))), 1)
	var result: Dictionary = victim.take_hit(final, 0)
	_sfx("crit" if is_crit else "hit", -6.0, 1.2)
	victim.float_text("%d%s" % [final, "!" if is_crit else ""],
		Color(0.7, 0.85, 1.0), is_crit)
	_log("The spirit of %s strikes %s for %d%s" % [kind.capitalize(),
		victim.unit_name, final, " CRIT" if is_crit else ""], "#9ab8e0")
	if result.died:
		_stat("enemy_deaths")
		_sfx("death", -4.0)
		_message("%s falls!" % victim.unit_name)
		_log("† %s dies" % victim.unit_name, "#e05050")
		_on_enemy_death(victim)
	await _wait(0.3)


# One companion attack. `mult` scales damage (Kill Command: x2); `boosted`
# doubles the special effect (doubled Bleed, Exposed twice as long). Loyalty
# feeds every blow: +5% per stack, plus the beast's own gift.
func _companion_strike(comp: BattleUnit, victim: BattleUnit, mult: float,
		boosted: bool) -> void:
	if comp == null or comp.dead or victim == null or victim.dead:
		return
	var l: int = 0
	if comp.pack_master != null:
		l = int(comp.pack_master.loyalty.get(comp.companion_kind, 0))
	var dmg_mult := mult * _comp_dmg_mult(comp)
	# Beast blows are a % of the companion's Attack (inherited from the
	# hunter, node scaling included): Ursus 10% + adjacent, Canis 20%,
	# Aguila 20%.
	match comp.companion_kind:
		"ursus":
			await _companion_hit(comp, victim, 0.10 * comp.attack * dmg_mult, 0)
			# The bear's sweep also mauls the enemies beside the target.
			for adj in _adjacent_enemies(victim):
				if not adj.dead:
					await _companion_hit(comp, adj, 0.10 * comp.attack * dmg_mult, 0)
		"canis":
			await _companion_hit(comp, victim, 0.20 * comp.attack * dmg_mult, 0)
			# The wolf always worries the wound open (+2 Bleed per Loyalty;
			# +10 more while its Wrath rides).
			if not victim.dead:
				var wolf_bleed := (20 + 2 * l \
					+ (10 if comp.has_status("bestial") else 0)) \
					* (2 if boosted else 1)
				_add_bleed_with_burst(victim, wolf_bleed)
		"aguila":
			await _companion_hit(comp, victim, 0.20 * comp.attack * dmg_mult, 0,
				0.20 * l)
			# Every eagle strike lays the prey open — and Blinds under Wrath.
			if not victim.dead:
				_apply_status(victim, "exposed", 4 if boosted else 2)
				if comp.has_status("bestial"):
					_apply_status(victim, "blind", 2)


# All beasts deal physical damage using the hunter's inherited crit chance.
# `pen` ignores that share of the victim's armor (Aguila's Loyalty gift).
func _companion_hit(comp: BattleUnit, victim: BattleUnit, dmg: float, pr: int,
		pen := 0.0) -> void:
	if victim == null or victim.dead:
		return
	var raw := (dmg + comp.companion_power) * randf_range(0.9, 1.1)
	var is_crit := randf() < CRIT_CHANCE + comp.crit_bonus + (0.25 if victim.broken else 0.0)
	if is_crit:
		raw *= 1.5
	# Mark of the Hunt: the pack tears at the marked prey.
	var pm: BattleUnit = comp.pack_master
	if pm != null and victim.has_status("hunt_mark") \
			and victim.status_power("hunt_mark") == heroes.find(pm):
		raw *= 1.25
	# Necrosis: poisoned enemies take more from ALL sources.
	if victim.has_status("poison") and _living_hero_with("necrosis") != null:
		raw *= 1.20
	raw *= 1.0 - float(victim.resists.get("physical", 0.0))
	var comp_armor := victim.effective_armor() * (1.0 - clampf(pen, 0.0, 1.0))
	var final := maxi(int(round(raw * (1.0 - comp_armor))), 1)
	var result: Dictionary = victim.take_hit(final, pr)
	# Sim bookkeeping: the beast's damage is the hunter's damage.
	if not victim.is_hero:
		var comp_credit: BattleUnit = pm if pm != null else comp
		_stat("dmg_hero_" + comp_credit.unit_name, final)
	_sfx("crit" if is_crit else "hit", -4.0 if is_crit else -7.0, 1.1)
	victim.float_text("%d%s" % [final, "!" if is_crit else ""],
		Color(1.0, 0.45, 0.15) if is_crit else Color(0.9, 0.75, 0.55), is_crit)
	if not sim and not result.died:
		victim.hit_react((victim.position - comp.position).normalized())
	_log("%s: strikes %s for %d%s" % [comp.unit_name, victim.unit_name, final,
		" CRIT" if is_crit else ""], "#d8b880")
	# Symbiosis and the Mark: the beast's blows feed the hunter's Mana.
	if pm != null and not pm.dead:
		var fed := 0
		if pm.symbiosis > 0:
			fed += int(pm.max_resource * 0.02)
		if victim.has_status("hunt_mark") \
				and victim.status_power("hunt_mark") == heroes.find(pm):
			fed += int(pm.max_resource * 0.03)
		if fed > 0:
			pm.resource = mini(pm.resource + fed, pm.max_resource)
			pm.refresh_bars()
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
		if not victim.is_hero:
			_on_enemy_death(victim)
	await _wait(0.35)
	# No _check_end here: the battle loop checks after the turn fully resolves
	# (ending mid-resolve reloads the scene under running code in sim mode).


# Bestial Wrath sharpens the predators' blows (the bear turns tank instead).
func _bestial_dmg_mult(comp: BattleUnit) -> float:
	if comp == null or not comp.has_status("bestial"):
		return 1.0
	match comp.companion_kind:
		"canis":
			return 1.5
		"aguila":
			return 1.25
	return 1.0


# ---------- Survivalist: statuses as a resource ----------

# Distinct debuffs on a unit — the Trapper's meter lives on the enemy.
# Counts the curated DEBUFF_IDS allowlist only, so bookkeeping statuses
# never inflate it.
func _status_count(u: BattleUnit) -> int:
	var n := 0
	for id in BattleUnit.DEBUFF_IDS:
		if id != "broken" and u.has_status(id):
			n += 1
	return n


# The first living hero carrying a talent field (Necrosis, Force of
# Nature — effects that outlive the attacker's identity).
func _living_hero_with(field: String) -> BattleUnit:
	for h in heroes:
		if not h.dead and not h.is_companion and int(h.get(field)) > 0:
			return h
	return null


# Every Survivalist poison flows through here: Potent Toxins deepens the
# tick, Virulence stacks it, Slow Acting halves-and-doubles (sticky),
# Epidemic makes it permanent and uncleansable.
func _apply_poison(src: BattleUnit, victim: BattleUnit, turns: int) -> void:
	if victim == null or victim.dead:
		return
	var tick := maxi(int(round(0.03 * src.attack)), 1) + src.potent_ranks
	var p_turns := turns
	var sticky := false
	if src.slow_acting > 0:
		tick = maxi(int(ceil(tick / 2.0)), 1)
		if p_turns > 0:
			p_turns *= 2
		sticky = true
	if src.epidemic > 0:
		p_turns = -1
		sticky = true
	for _i in 1 + src.virulence_ranks:
		_apply_status(victim, "poison", p_turns, 0, tick)
	if sticky:
		var ps: Dictionary = victim.get_status("poison")
		if not ps.is_empty():
			ps["sticky"] = true
	_hit_and_run(src)


# Hit and Run: laying a status on an enemy melts the Survivalist away.
func _hit_and_run(src: BattleUnit) -> void:
	if src != null and not src.dead and src.hit_and_run > 0 \
			and not src.has_status("elusive"):
		_apply_status(src, "elusive", 1)


# The Whole Forest: even spellwork trips the wire (attacks are covered
# by the retaliation block — this catches enemy support casts).
func _forest_bite(enemy: BattleUnit) -> void:
	for trapper in heroes:
		if trapper.dead or enemy.dead or trapper.whole_forest == 0 \
				or not trapper.has_status("tripwire"):
			continue
		var fb := maxi(int(trapper.attack * (0.25 + 0.10 * trapper.wire_ranks) \
			* (1.0 + 0.15 * trapper.cruel_ranks)), 1)
		var fb_res: Dictionary = enemy.take_hit(fb, 0)
		_stat("dmg_hero_" + trapper.unit_name, fb)
		enemy.float_text("%d Tripwire" % fb, Color(0.8, 0.65, 0.35))
		_log("   → the forest bites %s for %d" % [enemy.unit_name, fb], "#50c8e0")
		if fb_res.died:
			_stat("enemy_deaths")
			_sfx("death", -4.0)
			_message("%s falls!" % enemy.unit_name)
			_log("† %s dies" % enemy.unit_name, "#e05050")
			_on_enemy_death(enemy)


# A sprung trap's payload: stun, poison, and every Snares-lane cruelty.
func _spring_trap(placer: BattleUnit, victim: BattleUnit, dmg: float) -> void:
	if victim == null or victim.dead:
		return
	if dmg > 0.0:
		var tr_raw := dmg * (1.0 + 0.15 * placer.cruel_ranks) \
			* randf_range(0.9, 1.1)
		tr_raw *= 1.0 - float(victim.resists.get("nature", 0.0))
		var tr_final := maxi(int(round(tr_raw * (1.0 - victim.effective_armor()))), 1)
		var tr_res: Dictionary = victim.take_hit(tr_final, 0)
		_stat("dmg_hero_" + placer.unit_name, tr_final)
		victim.float_text("%d Trap" % tr_final, Color(0.75, 0.65, 0.30))
		_log("   → the trap bites %s for %d" % [victim.unit_name, tr_final],
			"#c8a860")
		if tr_res.died:
			_stat("enemy_deaths")
			_sfx("death", -4.0)
			_message("%s falls!" % victim.unit_name)
			_log("† %s dies" % victim.unit_name, "#e05050")
			_on_enemy_death(victim)
			return
	_apply_status(victim, "stunned", 1)
	if placer.quick_rigging > 0:
		_apply_status(victim, "cripple", 3)
	if placer.bone_breaker > 0:
		victim.take_hit(0, 30)
		victim.float_text("+30 BD", Color(0.8, 0.35, 1.0))
	if placer.caught_fast > 0:
		_apply_status(victim, "caught", 3)
	_hit_and_run(placer)


# ---------- Sharpshooter Focus ----------

# The Focus ceiling: 100 base, 150 under Deep Focus, 50 under Spray of
# Arrows (the spread costs the patience).
func _focus_cap(u: BattleUnit) -> int:
	if u.spray > 0:
		return 50
	if u.deep_focus > 0:
		return 150
	return 100


func _gain_focus(u: BattleUnit, amount: int) -> void:
	if u.second_resource_name != "Focus":
		return
	var before := u.second_resource
	u.second_resource = clampi(u.second_resource + amount, 0, _focus_cap(u))
	if u.second_resource > before:
		u.float_text("+%d Focus" % (u.second_resource - before),
			Color(0.55, 0.85, 0.40))
	u.refresh_bars()


# The Focus engine, run after each single-target attack: +20 on working
# the same enemy as last turn (+10/rank Muscle Memory); switching clears
# it (halves under Unwavering); a kill retains up to 50.
func _sharpshooter_focus(attacker: BattleUnit, victim: BattleUnit) -> void:
	if attacker.second_resource_name != "Focus" or victim == null:
		return
	if victim.dead:
		attacker.second_resource = mini(attacker.second_resource, 50)
		attacker.last_attack_target = null
		attacker.refresh_bars()
		return
	if attacker.last_attack_target == victim:
		_gain_focus(attacker, 20 + 10 * attacker.muscle_memory_ranks)
	elif attacker.last_attack_target != null:
		var kept := (attacker.second_resource / 2) if attacker.unwavering > 0 else 0
		if attacker.second_resource > kept:
			attacker.float_text("Focus broken" if kept == 0 else "Focus halved",
				Color(0.65, 0.65, 0.65))
		attacker.second_resource = kept
		attacker.refresh_bars()
	attacker.last_attack_target = victim


# A beast has died: Loyalty breaks (or endures at half under Steadfast
# Bond), Vengeance inherits the boon, and No Beast Left arms a free call.
func _on_beast_death(comp: BattleUnit) -> void:
	var pm: BattleUnit = comp.pack_master
	if pm == null:
		return
	var kind: String = comp.companion_kind
	var had: int = int(pm.loyalty.get(kind, 0))
	if pm.steadfast_bond > 0 and had > 0:
		pm.loyalty[kind] = had / 2
		_log("   → Steadfast Bond: %s's Loyalty endures at %d" % [
			comp.unit_name, had / 2], "#c08850")
	elif had > 0:
		pm.loyalty[kind] = 0
		_log("   → %s's Loyalty is broken" % comp.unit_name, "#c08850")
	if pm.vengeance > 0 and not pm.dead:
		_apply_status(pm, "vengeance", 5)
		pm.vengeance_kind = kind
		_log("   → Vengeance: %s inherits the %s bond — +30%% damage, 5 turns" % [
			pm.unit_name, kind.capitalize()], "#e0a050")
	if pm.no_beast_left > 0 and not pm.dead:
		pm.free_summon = true
		_log("   → No Beast Left: the next summon costs nothing", "#b0a8e0")


# An enemy has died: Apex Predator re-arms Kill Command; a marked kill
# resets Mark of the Hunt.
func _on_enemy_death(victim: BattleUnit) -> void:
	for h in heroes:
		if not h.dead and not h.is_companion and h.apex > 0 \
				and h.cooldowns.get("Kill Command", 0) > 0:
			h.cooldowns.erase("Kill Command")
			_log("   → Apex Predator: Kill Command is ready again", "#b0a8e0")
	if victim.has_status("hunt_mark"):
		var mk_idx := victim.status_power("hunt_mark")
		if mk_idx >= 0 and mk_idx < heroes.size() and not heroes[mk_idx].dead \
				and heroes[mk_idx].cooldowns.get("Mark of the Hunt", 0) > 0:
			heroes[mk_idx].cooldowns.erase("Mark of the Hunt")
			_log("   → The hunt is rewarded: Mark of the Hunt resets", "#b0a8e0")
	# Bloodied Momentum: every kill feeds the Berserker's swing.
	for mo_h in heroes:
		if not mo_h.dead and mo_h.bloodied_momentum_ranks > 0:
			var mo_rage := 15 * int(mo_h.bloodied_momentum_ranks)
			mo_h.resource = mini(mo_h.resource + mo_rage, mo_h.max_resource)
			mo_h.float_text("+%d Rage" % mo_rage, Color(1.0, 0.5, 0.4))
			mo_h.refresh_bars()
			_log("   → Bloodied Momentum: %s drinks the kill (+%d Rage)" % [
				mo_h.unit_name, mo_rage], "#b0a8e0")
	# Scavenger: the Survivalist strips the corpse for supplies.
	for sc_h in heroes:
		if not sc_h.dead and sc_h.scavenger_ranks > 0:
			var scv := int(sc_h.max_resource * 0.08 * sc_h.scavenger_ranks)
			sc_h.resource = mini(sc_h.resource + scv, sc_h.max_resource)
			sc_h.float_text("+%d Mana" % scv, Color(0.45, 0.6, 0.95))
			sc_h.refresh_bars()
	# Creeping Death: the rot never dies with its host.
	if victim.has_status("poison") and _living_hero_with("creeping_death") != null:
		var cd_st: Dictionary = victim.get_status("poison")
		var cd_pool: Array = enemies.filter(
			func(e): return not e.dead and e != victim)
		if not cd_pool.is_empty():
			var cd_to: BattleUnit = cd_pool.pick_random()
			for _cd in maxi(int(cd_st.get("stacks", 1)), 1):
				_apply_status(cd_to, "poison", int(cd_st.get("turns", 5)), 0,
					int(cd_st.get("tick", 3)))
			_log("   → Creeping Death: the rot crawls to %s" % cd_to.unit_name,
				"#70d878")


# Every talent that feeds a companion's blows, in one place: Loyalty
# (Wild Communion deepens the per-stack step), Bestial Wrath, and Feral
# Momentum's count of distinct beasts fielded.
func _comp_dmg_mult(comp: BattleUnit) -> float:
	var mult := _bestial_dmg_mult(comp)
	var pm: BattleUnit = comp.pack_master
	if pm != null:
		var l: int = int(pm.loyalty.get(comp.companion_kind, 0))
		var step := 0.05 + 0.015 * pm.wild_communion_ranks
		mult *= 1.0 + step * l
		if pm.momentum_ranks > 0 and pm.kinds_summoned.size() > 0:
			mult *= 1.0 + 0.08 * pm.momentum_ranks * pm.kinds_summoned.size()
	return mult


# Adds bleed buildup (logged) and detonates the bleedout when the meter fills.
# Bleedout damage IGNORES armor (take_hit applies none — armor only reduces
# attack damage inside _resolve) and respects Unity's soul-binding.
func _add_bleed_with_burst(victim: BattleUnit, amount: int,
		chain_hops: Array = []) -> void:
	if victim.dead:
		return
	if victim.add_bleed(amount):
		# Exsanguination (capstone): enemy bleedouts hit for 35% instead.
		var exsang := not victim.is_hero \
			and _living_hero_with("exsanguination") != null
		var bleed_dmg := maxi(int(victim.max_hp * (0.35 if exsang else 0.20)), 1)
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
			# The battle's bleedout tally — every hero carries the counter
			# (Scent of Blood reads it attacker-side).
			for tally_h in heroes:
				tally_h.bleedouts_this_battle += 1
			for feaster in heroes:
				if not feaster.dead and feaster.bloodcraze > 0:
					var craze := maxi(int(feaster.max_hp * 0.03 * feaster.bloodcraze), 1)
					feaster.heal_amount(craze)
					feaster.float_text("+%d Bloodcraze" % craze, Color(0.85, 0.3, 0.3))
					_log("   → Bloodcraze: %s feasts (+%d HP)" % [feaster.unit_name,
						craze], "#b0a8e0")
			# Blood Tithe: the bleedout pays its toll in Rage.
			for bt_h in heroes:
				if not bt_h.dead and bt_h.blood_tithe_ranks > 0:
					var tithe := 15 * int(bt_h.blood_tithe_ranks)
					bt_h.resource = mini(bt_h.resource + tithe, bt_h.max_resource)
					bt_h.float_text("+%d Rage" % tithe, Color(1.0, 0.5, 0.4))
					bt_h.refresh_bars()
					_log("   → Blood Tithe: %s collects %d Rage" % [
						bt_h.unit_name, tithe], "#b0a8e0")
			# Scent of Blood: the ramp deepens with every bleedout.
			for sc_h in heroes:
				if not sc_h.dead and sc_h.scent_ranks > 0:
					_log("   → Scent of Blood: %s sharpens (+%d%% damage, %d bleedouts)" % [
						sc_h.unit_name,
						3 * sc_h.scent_ranks * sc_h.bleedouts_this_battle,
						sc_h.bleedouts_this_battle], "#b0a8e0")
		_sfx("crit", -5.0, 0.8)
		_log("   → %s BLEEDS OUT for %d" % [victim.unit_name, bleed_dmg], "#e05050")
		if bleed_result.died:
			_stat("hero_deaths" if victim.is_hero else "enemy_deaths")
			_sfx("death", -4.0)
			_message("%s falls!" % victim.unit_name)
			_log("† %s dies" % victim.unit_name, "#e05050")
			if victim.is_companion:
				_on_beast_death(victim)
			elif not victim.is_hero:
				_on_enemy_death(victim)
		# Arterial Spray / Exsanguination: the burst blood finds a new host.
		# Each chain visits an enemy at most once, so a full-buildup wave
		# sweeps the field and stops.
		if not victim.is_hero:
			var t_pct := (1.0 if exsang else 0.25 * _max_hero_rank("arterial_ranks"))
			if t_pct > 0.0:
				chain_hops.append(victim)
				var hosts: Array = enemies.filter(
					func(e): return not e.dead and e != victim and not chain_hops.has(e))
				if not hosts.is_empty():
					var host: BattleUnit = hosts.pick_random()
					var surge := int(round(100.0 * t_pct))
					_log("   → %s: %d Bleed surges to %s" % [
						("Exsanguination" if exsang else "Arterial Spray"),
						surge, host.unit_name], "#e08850")
					_add_bleed_with_burst(host, surge, chain_hops)
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
		"focus20":
			_gain_focus(attacker, 20)
			_log("   → Perfect: %s steadies — +20 Focus" % attacker.unit_name,
				"#b0a8e0")
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
			# Power carries the % so weaker sources (Guard Change's 10) never
			# overwrite this one — status refresh keeps the higher power.
			_apply_status(attacker, "parry_up", 3, 15)
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
				and (current_hero.second_resource >= 1 \
					or current_hero.avatar_of_mercy > 0):
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
		# Fights that never reached round 3 record their end state (a win
		# counts 0 standing — the field emptied before AoE could feed).
		if not _r3_recorded:
			_r3_recorded = true
			_stat("enemies_alive_r3",
				enemies.filter(func(e): return not e.dead).size())
		if victory:
			_stat("wins")
		for h in heroes:
			if not h.dead:
				_stat("surviving_hero_hp_pct", h.hp / float(h.max_hp))
				_stat("surviving_heroes")
		if run_sim:
			# RunSim replays the real victory/defeat flow (minus UI and
			# persistence), walks the map to the next fight, and reloads
			# this scene — or prints the run report and quits.
			RunSim.on_battle_end(Run, self, victory)
			return
		if sweep and sim_done % sim_target == 0:
			# Stage boundary: bank this budget's stats, start the next clean.
			var stage := int(sim_done / float(sim_target))
			print("sweep: budget %d done — %d/%d wins" % [SWEEP_BUDGETS[stage - 1],
				int(sim_stats.get("wins", 0.0)), int(sim_stats.get("battles", 0.0))])
			sweep_stats.append(sim_stats)
			sim_stats = {}
		var total_target := sim_target * (SWEEP_BUDGETS.size() if sweep else 1)
		if sim_done < total_target:
			get_tree().reload_current_scene()
		else:
			if sweep:
				_print_sweep_report()
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
		# Node scaling: every combat victory grows the party (+2% of base
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
			# Gravelight Lantern: the spoils pile runs deeper.
			for extra_i in int(Run.relic_add("loot_extra")):
				var extra_id: String = Run.random_loot()
				Run.items[extra_id] = Run.items.get(extra_id, 0) + 1
				elite_text += "\n+1 %s (Gravelight Lantern)" % Run.ITEM_INFO[extra_id][0]
		# Victory relic hooks: healing chalices, mana hourglasses, toll gold.
		var v_heal := Run.relic_add("victory_heal_pct")
		if v_heal > 0.0:
			Run.heal_party(v_heal)
		var v_mana := Run.relic_add("victory_mana_pct")
		if v_mana > 0.0:
			Run.restore_mana(v_mana)
		var v_gold := int(Run.relic_add("victory_gold"))
		if v_gold > 0:
			Run.gold += v_gold
		Run.save_run()
		_sfx("victory", -4.0)
		if Run.encounter.get("type", "") == "boss":
			var relic := Relics.unlock_random()
			# The final boss awards no points — the relic IS the reward.
			var boss_text := ("+%d gold, %d talent points each." % [gold_gain, pts]) \
				if pts > 0 else ("+%d gold — the final relic is claimed." % gold_gain)
			if not relic.is_empty():
				boss_text += "\n\nRELIC UNLOCKED: %s\n%s" % [relic["name"], relic["desc"]]
			# Boss trophies: one ability pick per zone boss for every spec with
			# a pool, chosen on the Party screen.
			var trophy_specs: Array = []
			for bm_i in Run.party.size():
				var bm_spec: String = Run.party[bm_i].get("spec", "")
				if not Classes.spec_pool(bm_spec).is_empty() \
						and Run.party[bm_i].get("bm_abilities", []).size() \
						< Classes.spec_pool(bm_spec).size():
					Run.party[bm_i]["bm_picks_owed"] = \
						int(Run.party[bm_i].get("bm_picks_owed", 0)) + 1
					trophy_specs.append(Classes.SPEC_INFO[bm_spec]["name"])
			if not trophy_specs.is_empty():
				boss_text += "\n\nBOSS TROPHY: %s may choose a new\nability on the Party screen." % \
					" and ".join(trophy_specs)
				Run.save_run()
			# Persistent profile: boss kills and zone clears always count;
			# the final boss also books a completed run for every spec.
			Profile.note_boss(Run.boss_kind())
			Profile.note_zone_cleared()
			if Run.has_next_zone():
				_show_end("THE ZONE IS CLEANSED", boss_text,
					[["Descend into %s" % Run.next_zone_name(), _next_zone]], true)
			else:
				Profile.note_completion(Run.party.map(func(m): return m.get("spec", "")))
				Run.active = false
				Run.clear_save()
				_show_end("THE DECAY RECEDES", boss_text + "\nRun complete!",
					[["New Run", _start_new_run]], true)
		else:
			_show_end("VICTORY", "+%d gold. Each hero gains %d talent point%s.%s" % [
				gold_gain, pts, "" if pts == 1 else "s", elite_text],
				[["Continue", _to_map]], true)
	else:
		# Wipes count toward the profile only for real runs (sims never
		# carry Run.active).
		if Run.active:
			Profile.note_wipe(Run.party.map(func(m): return m.get("spec", "")))
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
	if OS.get_environment("DOD_SIM_THEME") != "":
		print("Theme: %s (budget %s, zone %s)" % [OS.get_environment("DOD_SIM_THEME"),
			OS.get_environment("DOD_SIM_BUDGET"), OS.get_environment("DOD_SIM_ZONE")])
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


# Sweep report (DOD_SIM_SWEEP=1): one row per budget stage. Rounds reuses
# the single-report metric (hero turns / 3) so the two stay comparable.
func _print_sweep_report() -> void:
	var elapsed := (Time.get_ticks_msec() - sim_started_ms) / 1000.0
	var zone := OS.get_environment("DOD_SIM_ZONE")
	var theme := OS.get_environment("DOD_SIM_THEME")
	print("\n===== DAWN OF DECAY — DIFFICULTY SWEEP =====")
	print("Zone roster: %s   Themes: %s   Specs: %s" % [
		zone if zone != "" else "1",
		theme if theme != "" else "all fight themes",
		OS.get_environment("DOD_SIM_SPECS")])
	print("budget   battles   wins    win%   rounds   deaths/battle   foes   alive@r3")
	for i in sweep_stats.size():
		var s: Dictionary = sweep_stats[i]
		var b := maxf(s.get("battles", 0.0), 1.0)
		print("%4d %9d %8d %6.0f%% %8.1f %11.2f %8.1f %8.1f" % [SWEEP_BUDGETS[i], int(b),
			int(s.get("wins", 0.0)), 100.0 * s.get("wins", 0.0) / b,
			s.get("hero_actions", 0.0) / b / 3.0,
			s.get("hero_deaths", 0.0) / b,
			s.get("enemy_count", 0.0) / b,
			s.get("enemies_alive_r3", 0.0) / b])
	# The field-size confound, made visible: a hero whose share climbs with
	# enemy count is an AoE outlier (the fix is the AoE); a share that stays
	# flat across budgets is plain overtuning (the fix is the numbers).
	print("Damage share per budget:")
	for i in sweep_stats.size():
		print("%4d   %s" % [SWEEP_BUDGETS[i], _share_line(sweep_stats[i])])
	print("Sim time: %.1fs" % elapsed)
	print("=============================================\n")


# "Berserker 30% | Cryomancer 45% | ..." from one banked stats dict.
# Keys are sorted so every budget row lists heroes in the same order.
func _share_line(s: Dictionary) -> String:
	var total := 0.0
	var names: Array = []
	for key in s:
		if key.begins_with("dmg_hero_"):
			total += s[key]
			names.append(key)
	names.sort()
	var parts := PackedStringArray()
	for key in names:
		parts.append("%s %.0f%%" % [key.trim_prefix("dmg_hero_"),
			100.0 * s[key] / maxf(total, 1.0)])
	return " | ".join(parts)


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
