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

# Ability hotkeys, mapped to ability slots in kit order (shown on the
# buttons). Batch AH: there is no cap on how many abilities a hero holds,
# so slot 10 onward binds to SHIFT + the same key in the same order.
const ABILITY_KEYS: Array = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_A, KEY_S, KEY_D,
	KEY_F, KEY_G]
const ABILITY_KEY_NAMES := ["Q", "W", "E", "R", "A", "S", "D", "F", "G"]

# Batch AH: the mini-boss node is an elite warband wearing a boss's health.
const MINIBOSS_HP_MULT := 1.5

# Visual identity of each status effect: [label, chip tag, color, tooltip]
const STATUS_INFO := {
	"slow": ["Slowed", "Sl", Color(0.55, 0.65, 0.9), "-25% speed; turns arrive later."],
	"chilled": ["Chilled", "Ch", Color(0.5, 0.75, 1.0), "Stacking frost: 1 = -25% speed,\n2 = -50%, 3 = also -15% damage;\n4 stacks FREEZE the victim."],  # 4 = a HOLD when he applied them
	"frozen": ["Frozen", "Fz", Color(0.65, 0.88, 1.0), "Frozen solid: skips their turns until\nthe ice thaws. A Cryomancer's freeze is a\nHOLD — it never thaws on its own."],
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
	"ruin": ["Ruin", "R1", Color(0.72, 0.32, 0.82), "Marked by the Old Gods: takes 2%\nmore damage per stack; heroes\nstriking this unit heal. No ceiling,\nnever clears; detonates every 10th\nstack."],
	"ruin_primed": ["Ruin (primed)", "R!", Color(0.9, 0.3, 0.9), "The Old Gods reach through: Ruin\ndetonates when this unit next\nacts — and the stacks REMAIN."],
	"hysteria": ["Mass Hysteria", "MH", Color(0.9, 0.5, 0.9), "Next turn: strikes a fellow with\nDOUBLE Break damage, Sundering\nthem."],
	"invig": ["Invigoration", "Iv", Color(0.45, 0.6, 0.95), "Restores Mana at the start of\neach turn (Dark Pact talent)."],
	"devotion": ["Devotion Aura", "DA", Color(0.95, 0.8, 0.45), "The Devout's presence: takes 15%\nless Break damage."],
	"tripwire": ["Tripwire", "TW", Color(0.8, 0.65, 0.35), "Retaliates against every attacking\nmelee enemy for 75% of their damage."],
	"stunned": ["Stunned", "St", Color(0.95, 0.9, 0.4), "Loses their next turn."],
	# Batch AB: the Warden's stance. The old percentage ward of the same id
	# (Shieldwall v1, "-25% damage") was a fossil and is gone — this is the
	# live ability: it raises the Block ROLL rather than bypassing it, so
	# the blocks it buys are Heavy Plating blocks and feed Tenacity/Rally.
	"shieldwall": ["Shieldwall", "SW", Color(0.6, 0.7, 0.9),
		"Braced: bonus Block chance while\nthe stance holds."],
	"empower": ["Empower", "+A", Color(0.95, 0.45, 0.35), "+25% damage dealt."],
	"exposed": ["Exposed", "E", Color(0.95, 0.9, 0.4), "Takes 15% more damage."],
	"cripple": ["Cripple", "C", Color(0.5, 0.4, 0.55), "-25% damage dealt."],
	"retaliate": ["Retaliation", "R!", Color(0.95, 0.6, 0.25), "Counters attackers with a basic strike."],
	"dazed": ["Dazed", "Dz", Color(0.95, 0.7, 0.35), "Attacks are 20% more likely to miss."],
	"shielded": ["Shielded", "Sh", Color(0.95, 0.65, 0.25), "Takes 25% less damage\n(a Shieldmaster's ward)."],
	"wrath": ["Divine Wrath", "DW", Color(1.0, 0.85, 0.35), "+15% damage dealt and +15% speed."],
	"umbral_sigil": ["Umbral Sigil", "US", Color(0.55, 0.30, 0.70), "Branded: half of all attack damage\nthis unit takes echoes to its\nwhole party."],
	"battle_shout": ["Battle Shout", "BS", Color(0.95, 0.45, 0.30), "+8% damage, plus 1% per 20 blood\nbuildup on the enemy party (at cast time)."],
	"blood_price": ["Blood Price", "BP", Color(0.85, 0.25, 0.25), "Paid in his own blood:\n+25% damage dealt."],
	"scent": ["Scent of Blood", "SB", Color(0.85, 0.3, 0.3), "Fed by bleedouts: bonus damage for\neach enemy bled out this battle."],
	"deathwish": ["Deathwish", "DW", Color(0.9, 0.3, 0.3), "Below 35% health: bonus damage —\nnothing left to lose."],
	"undying_rage": ["Undying Rage", "UR", Color(0.95, 0.25, 0.2), "Below 25% health: cannot die and\n+50% damage. The hit that would have\nkilled him ends it at 1 HP\n(once per battle)."],
	# Interpose is the only source of guaranteed charges since Batch AB, so
	# the label follows the charges rather than the ability that stopped
	# granting them — the block log names this as its source.
	"shield_charges": ["Interpose", "IP", Color(0.65, 0.72, 0.85), "The next attacks against this unit\nare BLOCKED (one charge each)."],
	"high_guard": ["High Guard", "HG", Color(0.55, 0.80, 0.95), "Takes 40% less damage."],
	"tempo": ["Tempo", "T+", Color(0.4, 0.9, 1.0), "The pivot's momentum: bonus damage\nfor one turn (granted by switching\nstance)."],
	"killing_edge": ["Killing Edge", "KE", Color(0.95, 0.5, 0.35), "The Aggressive guard hunts the\nopening: bonus critical chance while\nthe stance holds."],
	"bracing": ["Bracing", "Br", Color(0.55, 0.80, 0.95), "The raised guard is harder to Break:\nbonus Constitution while the Defensive\nstance holds."],
	"elem_weak": ["Elemental Weakness", "EW", Color(0.40, 0.80, 0.75), "Elemental resistances reduced."],
	"hold_bd": ["Hold the Line", "HL", Color(0.95, 0.82, 0.45), "Takes 50% less Break damage."],
	"undying": ["Undying", "UD", Color(1.0, 0.95, 0.75), "Cannot drop below 1 HP."],
	"intercession": ["Intercession", "IC", Color(0.98, 0.92, 0.60),
		"The next lethal blow against any hero\nis refused — they survive at 1 HP and\nthe Cleric loses 1 Mercy. She must be\nholding one when it lands."],
	# Bulwark Line (Batch AL): the Warden's Shieldwall covers the line. The
	# grant rides the same Heavy Plating slice of the block roll his own
	# stance does, so what it buys is real Block, not a separate ward.
	"bulwark_line": ["Bulwark Line", "BL", Color(0.72, 0.8, 0.95),
		"+10% Block chance (the Warden's Shieldwall)."],
	"rally_heal": ["Rallied", "R+", Color(0.95, 0.75, 0.45), "+30% healing received\n(the Warden's Rally)."],
	"immolate": ["Immolate", "IM", Color(1.0, 0.55, 0.25), "Overburn has NO damage cap and its\nMana drain is DOUBLED; attackers\nare set Burning (3 turns)."],
	"seeding": ["Seeding Embers", "SE", Color(1.0, 0.65, 0.3), "Empowered by a burning death:\nbonus damage on the next turn."],
	"rime": ["Rime", "Ri", Color(0.75, 0.9, 1.0), "Rimed: every stack of Chilled this\nenemy gains also chills one other\nrandom enemy."],
	"frostbite": ["Frostbite", "Fb", Color(0.45, 0.70, 0.95), "Frostbitten: healing received\nreduced by 50%."],
	"stabilized": ["Stabilized", "St+", Color(0.55, 0.68, 0.95), "Grounded resonance: takes less\ndamage (10% per stack consumed)."],
	"overcharged": ["Overcharged", "OC", Color(0.8, 0.5, 1.0), "Overcharge is spent for this\nbattle — the storm has no feeding\nleft in it."],
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
# GLACIAL HOLD's ledger (Batch AS §1) — the enemies the Cryomancer is holding,
# OLDEST FIRST. See the block above _apply_status for the three clauses.
var _holds: Array[BattleUnit] = []
var _clock := 0.0  # the acting unit's position on the timeline, this turn
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
# Stalemate guard (Batch W, sims only): a fight neither side can finish —
# see the guard in _run_battle. ~12 rounds is a long real battle; 10 units
# x 60 rounds is far past anything legitimate.
const STALEMATE_TURNS := 600
var stalemate := false
# Shieldwall (Batch AB): the Block chance the Warden's stance adds, in
# percent. It rides the Heavy Plating slice of the block roll on purpose —
# see the "shield_block" special and the roll itself.
const SHIELDWALL_BLOCK := 25
# Batch W: this battle's dmg/heal/prevented per hero — banked into the
# per-spec share pools at battle end (rotation needs "share of the battles
# this spec was IN", which the stage totals can't give).
var _b_slice := {}
# Batch Z: this battle's per-hero damage in REAL play, banked into the run
# ledger (Run.tally) at battle end so the run summary can show a whole-run
# damage share. Written only when `sim` is false — RunSim keeps its own
# stats path and must never double-count.
var _run_slice := {}

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
	if _debug_allowed():
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
	# Batch W (DOD_SIM_ROTATE=1): cycle the spec in each class slot across
	# successive battles so all twelve specs get measured. Standalone/sweep
	# battles only — run sims rotate per RUN in RunSim.start_run (a mid-run
	# spec change would be a different game). Overrides DOD_SIM_SPECS.
	if not Run.active and OS.get_environment("DOD_SIM_ROTATE") == "1":
		sim_specs = Classes.rotated_specs(sim_done)
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
				# Earned abilities (mini-boss and boss picks) go on BEFORE the
				# tree: several talents MODIFY an ability rather than grant
				# it, and every `upgrade` path (Batch AK's Lunge and Execute,
				# Batch AJ's Battle Shout and Rampage) asks whether the copy
				# was ALREADY in the kit — a question only this ordering can
				# answer. apply_from_tree refuses to double-grant either way.
				for bm_name in Run.party[i].get("bm_abilities", []):
					var bm_ab := Classes.spec_pool_ability(spec, bm_name)
					if bm_ab != null and not cfg["abilities"].any(
							func(a): return a.display_name == bm_ab.display_name):
						cfg["abilities"] = cfg["abilities"] + [bm_ab]
				Talents.apply_from_tree(cfg, Run.party[i].get("tree", []),
					Run.party[i].get("talents", {}), Run.party[i])
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
				# The same hook feeds either earnable pool, by name.
				if env_abs != "":
					for ab_name in env_abs.split(","):
						var bm_pending := Classes.spec_pool_ability(spec, ab_name.strip_edges())
						if bm_pending != null and not cfg["abilities"].any(
								func(a): return a.display_name == bm_pending.display_name):
							cfg["abilities"] = cfg["abilities"] + [bm_pending]
		# Review aid: pre-grant unlockable abilities when the map-burger
		# DEBUG toggle is armed. Dedupe keys on display_name, so
		# talent-learned copies never double up.
		#
		# BATCH AU §5 — SCOPED TO THE HERO'S OWN SPEC. It used to pre-grant
		# every talent-granted and boss-trophy ability the CLASS could reach,
		# which meant testing the Arcanist put Pyromancer abilities in his
		# hands. Now: this spec's tree grants, this spec's capstones, and
		# `SPEC_POOLS[spec]`. Nothing from another spec.
		# `CLASS_POOLS` IS EXCLUDED, AND THAT IS THE TRADE-OFF: the sibling
		# abilities showing up ARE the class pool's contents (Flamewave and
		# Firestorm are in CLASS_POOLS["mage"]), so excluding it is what fixes
		# the complaint. The cost is that a legitimately earnable class-pool
		# ability is no longer covered by the toggle — the node summoner and a
		# real boss reward still reach them. DO NOT BUILD A SECOND TOGGLE.
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
					Talents.apply_payload(cfg, rune["payload"], 1,
						{"learned": Run.party[i].get("talents", {}), "member": Run.party[i]})
					# Batch AA roll call: most spec runes ride an EXISTING
					# talent counter, so their effect surfaces on that
					# talent's proc line rather than one of their own. One
					# grep-stable "Rune:" line at spawn means every equipped
					# rune is still visible in a log a tester pastes back.
					_rune_roll_call.append("%s: %s" % [cfg["unit_name"], rune["name"]])
			# Mini-boss ability upgrades (Batch AP) — the FIRST thing that reads
			# `upgrades`, which Batch AN recorded and nothing acted on. It runs
			# LAST of everything that touches an ability, and that is the point:
			# several talents (and a rune or two) SET a field rather than add to
			# it — the Resonant Hymn node sets Hymn of Hope's cost to 25 — so an
			# Effortless applied earlier would be silently overwritten. The
			# return names what actually landed; the ability tooltip reads it.
			# Batch AU §1: the third argument is every ability whose TREE NODE
			# collided with an already-owned copy. The node owes an upgrade,
			# and this is the position that owes it — last, after everything
			# that could overwrite it.
			cfg["ability_upgrades"] = Run.apply_upgrades(Run.party[i], cfg["abilities"],
				cfg.get(Talents.FALLBACK_KEY, []))
		# SECOND-RESOURCE CEILINGS — derived LAST, from whatever cfg holds by
		# now. Batch AA moved this block down from above the class passives:
		# it used to run before runes applied, so a rune writing
		# resonant_core_ranks / mercy_cap_bonus / zealous_mercy (or the
		# Sharpshooter's Focus flags) was read too early and did NOTHING —
		# exactly the silent dud the rune schema exists to prevent. Talent
		# behaviour is unchanged: talents already applied further up.
		# RUNAWAY RESONANCE HAS NO CEILING AT ALL (Batch AT) — not a talent-
		# raised one, not a capstone-removed one. 99 is "never reached in
		# practice"; the nameplate bar reads against BattleUnit's
		# RESONANCE_BAR_REF instead, because a bar with no maximum has nothing
		# to fill. resonant_core_ranks no longer touches this: the node buys
		# an extra stack on the first cast of each turn now.
		if spec == "arcanist":
			cfg["second_max"] = 99
		# Mercy: Martyr's Vigor moves the ceiling, Zealous Light the start.
		if spec == "holy":
			cfg["second_max"] = 5 + int(cfg.get("mercy_cap_bonus", 0))
			cfg["second_resource"] = mini(int(cfg.get("zealous_mercy", 0)),
				int(cfg["second_max"]))
		# Focus is the Sharpshooter's second resource (0-100; Deep Focus /
		# Spray of Arrows move the ceiling, Opening Volley the start).
		if spec == "sharpshooter":
			cfg["second_resource_name"] = "Focus"
			cfg["second_max"] = (50 if cfg.get("spray", 0) > 0 \
				else (150 if cfg.get("deep_focus", 0) > 0 else 100))
			cfg["second_resource"] = 60 if cfg.get("opening_volley", 0) > 0 else 0
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
		# Kiln-Forged (Pyromancer, Batch AR): its OTHER half is the drain
		# floor in _player_turn; the resistance is a dict entry, and payloads
		# only write scalars, so it lands here — the same site and the same
		# shape as the relic resist block above, OUTSIDE the Run.active gate
		# so a standalone sim sees it too.
		if int(cfg.get("kiln_forged", 0)) > 0:
			var kiln_res: Dictionary = cfg.get("resists", {})
			kiln_res["fire"] = float(kiln_res.get("fire", 0.0)) + 0.20
			cfg["resists"] = kiln_res
		# Percentage HP talents (Inner Faith, Unwavering Faith) apply after
		# every flat bonus.
		cfg["max_hp"] = int(round(cfg["max_hp"] * (1.0 + cfg.get("max_hp_pct", 0.0))))
		# Toughness (Warden talent): Constitution grows with bulk.
		if cfg.get("toughness_ranks", 0) > 0:
			cfg["constitution"] = int(cfg.get("constitution", 100)
				+ 0.25 * cfg["toughness_ranks"] * cfg["max_hp"])
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
		# First Blood (Batch AJ): THE ONE read site for `opening_rage`. It
		# sits beside Bottled Storm because that is where the battle's
		# opening resource is settled — after the member-mana sync, so a
		# resumed run cannot overwrite it. A FLOOR, not an addition: the
		# node promises he opens at 40, and stacking it on top of a relic
		# floor would make two "you start with" effects multiply.
		if u.opening_rage > 0 and u.max_resource > 0:
			u.resource = maxi(u.resource, mini(u.opening_rage, u.max_resource))
			u.refresh_bars()
		heroes.append(u)

	# Devoutness (Devout talent, ex-Devotion Aura): the whole party takes
	# less Break damage — a battle-long status whose power carries the %.
	var dvn_pct := 0
	for h in heroes:
		dvn_pct = maxi(dvn_pct, h.devoutness_ranks)
	if dvn_pct > 0:
		for h in heroes:
			_apply_status(h, "devotion", -1, dvn_pct)
			h.update_status("devotion", "DA",
				"Devoutness: takes %d%% less\nBreak damage." % dvn_pct,
				dvn_pct)
	# Conviction (Devout passive): Divine Shield absorbs build Faith, and
	# lethal saves reward — both hook back into the battle scene.
	if heroes.any(func(h): return h.passive_id == "conviction"):
		for h in heroes:
			h.lethal_saved_cb = _on_lethal_saved
			h.shield_absorbed_cb = _on_shield_absorbed
	# Batch W: barrier absorbs feed the contribution ledger (the handler
	# banks only in sim mode, so real play pays nothing for the wire).
	for h in heroes:
		h.prevented_cb = _on_barrier_prevented

	# Guardian Angel raises the Mercy-earning threshold and Last Hope deepens
	# healing on the nearly-dead — both are the Holy's talents, but the checks
	# run on WHOEVER is hit/healed, so the magnitudes are stamped party-wide.
	# ADDITIVE units (Batch AV): both counters are percentage POINTS, and
	# Guardian Angel's is the INCREASE on the passive's own 50% window.
	var ga_step := 0
	var lh_pct := 0
	for h in heroes:
		ga_step = maxi(ga_step, h.guardian_step)
		lh_pct = maxi(lh_pct, h.last_hope_pct)
	if ga_step > 0 or lh_pct > 0:
		for h in heroes:
			h.mercy_threshold = 0.5 + 0.01 * ga_step
			h.last_hope_bonus = lh_pct

	# Intercession and Martyrdom (Batch AV): the party carries the Cleric's
	# reversals, because the check runs on WHOEVER takes the lethal blow.
	# Intercession's window is a STATUS the cast applies, so only the hook
	# is stamped here; Martyrdom's latch is armed for the whole battle.
	if heroes.any(func(h): return h.second_resource_name == "Mercy"):
		for h in heroes:
			h.intercession_cb = _on_intercession_save
	if heroes.any(func(h): return h.martyrdom > 0):
		for h in heroes:
			h.martyrdom_guard = true
			h.martyrdom_cb = _on_martyrdom_return

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
	# Scaling rebase (Batch 36, rates halved in Batch T): each zone runs its
	# OWN 1..11 tier ladder (+2% Attack / +2.5% HP of base per tier), and
	# the zone's SLOT in the run applies a flat base multiplier on top (1st
	# zone x1.0, 2nd x1.5, 3rd x2.2 — Run.zone_base_mult, position not
	# identity). The slot multiplier carries between-zone escalation; the
	# tier rate compounds on the budget ramp WITHIN a zone, and at +4%/+5%
	# those two multiplicative sources outran the party's one additive one.
	# Health pools stay multiples of 10 (rounded UP). Standalone unscaled.
	var zone_tier := 0
	var slot_mult := 1.0
	if Run.active:
		zone_tier = clampi(Run.slot_idx + 1, 1, Run.SLOTS_PER_ZONE)
		slot_mult = Run.zone_base_mult(Run.zone_idx + 1)
	for i in composition.size():
		var cfg := _enemy_config(composition[i])
		var tint: Color = cfg["tint"]
		cfg.erase("tint")
		# The mini-boss (Batch AH): an elite warband with a BOSS-TIER health
		# pool and nothing else changed. x1.5 puts a chief's 250 at 375, in
		# among the two authored bosses (370 / 500), so the node reads as
		# "between an elite and a boss" the way it is meant to — a longer
		# fight, not a harder-hitting one.
		var mb_hp := MINIBOSS_HP_MULT \
			if Run.active and Run.encounter.get("type", "") == "miniboss" else 1.0
		if zone_tier > 0:
			cfg["max_hp"] = int(ceil(cfg["max_hp"] * slot_mult * mb_hp
				* (1.0 + 0.025 * zone_tier) / 10.0) * 10.0)
			cfg["attack"] = int(round(cfg["attack"] * slot_mult
				* (1.0 + 0.02 * zone_tier)))
		elif mb_hp > 1.0:
			cfg["max_hp"] = int(ceil(cfg["max_hp"] * mb_hp / 10.0) * 10.0)
		if Run.active and Run.zone_idx > 0:
			# Deeper zones keep their scorched warpaint.
			tint = tint.lerp(Color(1.0, 0.6, 0.45), 0.35)
		enemies.append(_make_unit(cfg, layout[i], tint,
			Vector2(ENEMY_PLATE_X, PLATE_TOP + i * PLATE_STEP)))

	_apply_battle_modifier()
	# Batch AS §0: the opening roll seeds off EFFECTIVE speed, not the raw
	# stat. Every reschedule site in this file has always divided by
	# effective_speed() — so Chilled, Slowed and Quick Draw have always bent
	# the timeline — but this one line read `u.speed`, which meant the two
	# modifiers stamped immediately above it (Frenzied's mod_speed_mult and
	# Hoarfrost's three stacks of Chilled) did nothing to the FIRST turn
	# order, exactly what the comment on _apply_battle_modifier promised they
	# would. The divisor is floored because a modifier is allowed to stack
	# with a deep chill and 100.0 / 0.0 is not a turn order.
	for u in heroes + enemies:
		u.next_time = (100.0 / maxf(u.effective_speed(), 0.1)) * randf_range(0.0, 1.0)
	# Tracker (Hunter class passive): always attacks first in every fight.
	for u in heroes:
		if u.hero_key == "hunter":
			u.next_time = -0.01


# ---------- Batch AN §3 / Batch AQ §3: the battle modifier ----------
#
# The bargain the player accepted at the offer screen, stamped onto every
# combatant on BOTH sides once they all exist. Each modifier is one field
# write (or one stat nudge) and nothing else — no per-modifier branch in the
# damage pipeline — because every unit-side field has exactly one read site
# and the stat-side ones use hooks that already existed.
#
# Applied AFTER spawn and BEFORE the opening initiative roll: Frenzied has
# to be on the board before `next_time` is seeded off effective speed, or the
# first turn order would be the unmodified one. That claim was FALSE from AN
# until Batch AS — the roll read the raw `speed` stat, so neither Frenzied
# (mod_speed_mult) nor Hoarfrost (Chilled) reached it. Both live in
# effective_speed(), which the seed now calls.
func _apply_battle_modifier() -> void:
	var mod_id := _active_modifier()
	if mod_id == "":
		return
	for u in heroes + enemies:
		_stamp_modifier(u, mod_id)
	var cfg: Dictionary = Run.MODIFIERS[mod_id]
	_log("[b]%s[/b] — %s" % [String(cfg["name"]).to_upper(), String(cfg["desc"])],
		"#d0a0e0")


# The modifier this battle is being fought under, or "" for none. One place
# answers it, so the spawn pass and the summon site (§4) cannot disagree.
func _active_modifier() -> String:
	if not Run.active or Run.pending_modifier == "":
		return ""
	var mod_id := String(Run.pending_modifier)
	return mod_id if Run.MODIFIERS.has(mod_id) else ""


# ONE list of nineteen, one branch each. `inherited` is true for a companion
# summoned mid-battle (§4): it arrives carrying its hunter's Attack and crit
# ALREADY modified, so the two branches that write those must not fire again.
# Everything else has to be stamped or the beast is the one unit on the field
# the bargain does not bind.
func _stamp_modifier(u: BattleUnit, mod_id: String, inherited := false) -> void:
	match mod_id:
		"overgrown":
			# BOTH parties begin at 70% health. Heroes are clamped to
			# their CURRENT hp as well, so an already-wounded party is
			# never healed up to 70% by a modifier that only ever takes.
			u.hp = maxi(mini(u.hp, int(round(u.max_hp * 0.7))), 1)
			u.refresh_bars()
		"tinderbox":
			# The existing typed-damage hook the Emberheart relic uses.
			u.type_dmg_bonus["fire"] = \
				float(u.type_dmg_bonus.get("fire", 0.0)) + 0.25
		"frenzied":
			u.mod_speed_mult = 1.3
		"brittle":
			u.mod_ignore_armor = true
		"warded":
			u.mod_cost_mult = 1.25
		"bloodless":
			u.mod_no_heals = true
		"parched":
			# Overgrown's lesson, applied to the other tank: clamp to the
			# CURRENT value too, so a mage who walks in on fumes is never
			# topped UP by a modifier that only ever takes.
			u.resource = mini(u.resource, u.max_resource / 2)
			if u.second_resource_name != "":
				u.second_resource = mini(u.second_resource, u.second_max / 2)
			u.refresh_bars()
		"slick":
			for ab in u.abilities:
				ab.delay += 0.5
		"dulledge":
			# Floored so a unit's TOTAL crit chance (CRIT_CHANCE + bonus)
			# can never go under zero — several read sites add the two.
			if not inherited:
				u.crit_bonus = maxf(u.crit_bonus - 0.05, -CRIT_CHANCE)
		"muffled":
			u.mod_bd_mult = 75
		"hoarfrost":
			# Through the normal status door, so Frigid Grip and the rest of
			# Chilled's riders behave exactly as they always do. The plate
			# already exists at this point, so the chip renders.
			_apply_status(u, "chilled", 3)
		"fleeting":
			u.mod_status_turns = -1
		"feverish":
			if not inherited:
				u.attack = int(round(u.attack * 1.25))
		"deadened":
			u.mod_no_break = true
		"miasma":
			# The mild rung of the ladder Bloodless tops, on the hook Holy
			# Conduit already uses.
			u.healing_received_mult *= 0.5
		"thinair":
			u.mod_no_regen = true
		"encumbered":
			# NEVER ADD TO A ZERO — Warded's discipline on a different field,
			# and it is what makes "basic attacks are unaffected" true rather
			# than aspirational.
			for ab in u.abilities:
				if ab.cooldown > 0:
					ab.cooldown += 2
		"bloodletting":
			u.mod_bleed_add = 15
		"mirrorbound":
			u.mod_recoil = 0.25


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
	# Batch AA: the tester's exit from a fight that will not end. Real play
	# only — the entry is never even BUILT under sim/autoplay, so no code
	# path can reach a forfeit from the harness (same guard discipline as
	# Batch Z's orientation cards; _do_forfeit re-checks anyway).
	if _forfeit_allowed():
		bpop.add_item("Forfeit Run", 4)
	bpop.add_item("Glossary", 3)
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

	# Batch AA: the stalemate nudge. A plain label with input ignored — it can
	# never take a click from a live skill check, and it does NOT gate
	# _modal_open(). Hidden until the fight has run absurdly long.
	_forfeit_nudge = Label.new()
	_forfeit_nudge.position = Vector2(56, 52)
	_forfeit_nudge.size = Vector2(700, 20)
	_forfeit_nudge.visible = false
	_forfeit_nudge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_forfeit_nudge.add_theme_font_size_override("font_size", 13)
	_forfeit_nudge.add_theme_color_override("font_color", Color(0.85, 0.7, 0.4))
	_forfeit_nudge.text = "This fight is not resolving — Forfeit Run is in the ☰ menu."
	ui.add_child(_forfeit_nudge)


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
	_debug_popup.add_item("Kill All Enemies", 3)
	_debug_popup.add_check_item("Cooldowns OFF", 2)
	_debug_popup.add_check_item("Enemy attacks OFF", 1)
	_debug_popup.add_separator("Turn lock — all hero turns")
	for i in heroes.size():
		_debug_popup.add_radio_check_item("Lock → %s" % heroes[i].unit_name, 10 + i)
	_debug_popup.id_pressed.connect(_on_debug_menu)


# A dev build, real play, and nothing the harness drives (Batch AC —
# mirrors _forfeit_allowed). Checked when the DEBUG menu is BUILT and
# again when an item fires, so an id sent straight into the dispatch
# fails the same way the missing menu does.
func _debug_allowed() -> bool:
	return Run.debug_enabled() and not Run.sim_run and not sim and not autoplay


func _on_debug_menu(id: int) -> void:
	if not _debug_allowed():
		return
	# The second and last honesty write site (the other is the map burger
	# dispatch): every battle debug item trips the flag from here, so the
	# run summary can never claim a debug-touched run is clean data.
	Run.debug_used = true
	if id == 0:
		_debug_full_restore()
		return
	if id == 3:
		_debug_kill_enemies()
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


# Batch AO §3: reach the victory screen on demand. It is a SWITCH, not a hit
# — the enemies are set dead directly rather than routed through take_hit, so
# there is no damage event, no on-hit or overkill proc, and no floating
# number. The deliberate consequence: on-death talent procs that read a
# killing blow (Seeding Embers and friends) do not fire on a nuked kill.
# Everything AFTER the kills is the real victory path — _check_end books the
# gold, the talent points, the 15% heal, claim_reward, elite spoils and the
# summary, which is exactly what a tester needs to see.
func _debug_kill_enemies() -> void:
	if battle_over:
		return
	for e in enemies:
		if e.dead:
			continue
		e.hp = 0
		e._die()
		e.refresh_bars()
	_log("DEBUG: every enemy struck down", "#e0a050")
	# A turn parked on `await _ability_picked` would otherwise leave live
	# buttons sitting under the victory panel.
	action_panel.visible = false
	_check_end()


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
		3:
			_open_glossary()
		4:
			_open_forfeit_confirm()


# ---------- Batch AA: Forfeit Run (the alpha escape hatch) ----------
#
# THIS IS NOT A FIX FOR THE STALEMATE. The last-hero-standing-vs-healing-
# warband state (08-02) is a balance question the designer has deliberately
# left open, and the STALEMATE_TURNS guard that handles it is SIMS ONLY.
# Real play had no resolution mechanism at all: at the measured ~0.9% of
# battles a tester doing five runs lands in an unendable fight about a
# third of the time, and their only exit was force-quitting — which loses
# the run and gets reported as a freeze rather than as an opinion.
# Forfeiting ends the run EXACTLY as a wipe does, so it can never be
# exploited and needs no balance thought: it is strictly worse than winning.
const FORFEIT_REASONS := [
	["stuck", "This fight will not end"],
	["hard", "Too hard"],
	["bored", "Not enjoying it"],
	["bug", "Something broke"],
	["stop", "Just stopping"],
]

var _rune_roll_call: Array = []  # "hero: rune name" per equipped rune, logged at battle open
var _forfeit_panel: Control = null
var _forfeit_nudge: Label = null
var _forfeit_nudged := false

# The nudge fires at the same order of magnitude as the sim's force-end, but
# it is a DIFFERENT thing: the guard ends a sim battle, this ends nothing.
const FORFEIT_NUDGE_TURNS := STALEMATE_TURNS


# One line, once, real play only. It ends nothing, touches no HP and alters
# no outcome — it only tells a tester that the exit exists.
func _maybe_nudge_forfeit(turns_taken: int) -> void:
	if _forfeit_nudged or turns_taken < FORFEIT_NUDGE_TURNS:
		return
	if not _forfeit_allowed():
		return
	_forfeit_nudged = true
	if _forfeit_nudge != null and is_instance_valid(_forfeit_nudge):
		_forfeit_nudge.visible = true
	_log("This fight is not resolving. Forfeit Run waits in the ☰ menu.", "#d9b168")


# Real play, inside a live run, and nothing the harness drives. Checked when
# the menu entry is BUILT and again when the forfeit actually fires.
func _forfeit_allowed() -> bool:
	return Run.active and not Run.sim_run and not sim and not autoplay


func _open_forfeit_confirm() -> void:
	if not _forfeit_allowed() or battle_over:
		return
	if _forfeit_panel != null and is_instance_valid(_forfeit_panel):
		return
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.7)
	overlay.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	center.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "FORFEIT THIS RUN?"
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(0.9, 0.45, 0.45))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var body := Label.new()
	body.text = "The run ends here, exactly as a wipe would.\nThis cannot be undone.\n\nWhy are you stopping? (it goes in the summary)"
	body.add_theme_font_size_override("font_size", 14)
	body.add_theme_color_override("font_color", Color(0.78, 0.74, 0.66))
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(body)
	for pair in FORFEIT_REASONS:
		var btn := Button.new()
		btn.text = String(pair[1])
		btn.custom_minimum_size = Vector2(360, 38)
		btn.pressed.connect(_do_forfeit.bind(String(pair[0]), String(pair[1])))
		vbox.add_child(btn)
	var cancel := Button.new()
	cancel.text = "Keep fighting"
	cancel.custom_minimum_size = Vector2(360, 42)
	cancel.pressed.connect(_close_forfeit_confirm)
	vbox.add_child(cancel)
	ui.add_child(overlay)
	_forfeit_panel = overlay


func _close_forfeit_confirm() -> void:
	if _forfeit_panel != null and is_instance_valid(_forfeit_panel):
		_forfeit_panel.queue_free()
	_forfeit_panel = null


# Ends the run down the SAME path a wipe takes (snapshot -> Run.active
# false -> clear_save -> summary), with two differences that keep the data
# honest: the Profile books a forfeit rather than a wipe, and the summary's
# outcome line reads "forfeited", never "wiped".
func _do_forfeit(reason_id: String, reason_label: String) -> void:
	if not _forfeit_allowed() or battle_over:
		return
	_close_forfeit_confirm()
	battle_over = true
	Profile.note_forfeit(Run.party.map(func(m): return m.get("spec", "")))
	# Snapshot BEFORE the clear — the Batch Z rule, unchanged.
	var snap := _run_snapshot("forfeit", "")
	snap["forfeit_reason"] = reason_label
	snap["forfeit_reason_id"] = reason_id
	Run.active = false
	Run.clear_save()
	_show_run_summary(snap)


# Batch Z: the glossary in battle. The panel itself is inert Control UI —
# the only battle-specific work is gating this scene's raw _input while it
# is open (clicks are handled in _input here, so without the gate a click
# on the panel could grade a live skill check underneath it).
var _glossary: GlossaryPanel = null


func _open_glossary() -> void:
	if _glossary != null and is_instance_valid(_glossary):
		return
	_glossary = GlossaryPanel.open(ui)


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
# SIMS SKIP THE PANEL (Batch W): nothing can read it headlessly, and every
# appended line allocates TextServer RIDs that a long verbose battle
# exhausts — past the limit each _log call spews an 8-line engine
# backtrace, which turned a 13-minute sweep into hours and a 500 MB log.
# DOD_SIM_DEBUG=1 still prints, so the deadlock-vs-throttle discriminator
# is unaffected.
func _log(text: String, color := "#d8d2c4") -> void:
	if not sim:
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
	# Batch AS §4: A HELD ENEMY IS REMOVED FROM THE BAR ENTIRELY, because it
	# is not going to act. That single line of UI is the whole spec made
	# visible — an enemy disappearing from the turn order is the control
	# fantasy in a way no damage number can be.
	var alive := (heroes + enemies).filter(
		func(u): return not u.dead and not _is_held(u))
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
	for carried in _rune_roll_call:
		_log("Rune: %s" % carried, "#b0a8e0")
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
	var _turns_taken := 0
	while not battle_over:
		# STALEMATE GUARD (Batch W, SIMS ONLY — real play is untouched).
		# Some kits carry unbounded battle-long accumulators (the Warden's
		# Endurance stacks armor 1%/rank per unhealed turn with NO cap, and
		# Tenacity grows max HP per block), so a fight he cannot lose and
		# cannot win runs forever: one run sat at 97,521% armor for 90
		# minutes. A sim must never hang on that. NOT a balance fix — the
		# underlying kit bug is the designer's call; this only stops the
		# harness from wedging, and every trip is COUNTED and REPORTED so
		# the cap can never pass silently.
		if sim and _turns_taken >= STALEMATE_TURNS:
			_stat("stalemates")
			_log("STALEMATE: battle exceeded %d unit turns — force-ended" % \
				STALEMATE_TURNS, "#e05050")
			# Scored as a NON-win without touching anyone's HP: marking a side
			# dead would either inflate hero_deaths or hand out a free victory.
			# The party failed to resolve the fight, so the run ends here — the
			# conservative read, and the stalemate count says how many outcomes
			# were manufactured this way.
			stalemate = true
			_check_end()
			return
		# Batch AA: real play gets a NUDGE at the same depth, never a
		# force-end. The balance question stays open; the tester stops
		# being trapped by it.
		_maybe_nudge_forfeit(_turns_taken)
		_turns_taken += 1
		# The hold ledger is read by the turn bar rebuilt on the very next
		# line, so it is trued up FIRST.
		_hold_sync()
		_update_talent_chips()
		_rebuild_turn_bar()
		var u := _next_unit()
		if u == null:
			break
		_clock = u.next_time  # where "now" is, for anything rejoining the timeline
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
								and randf() < 0.01 * h.invigorating_ranks:
							var ash_mana := maxi(int(h.max_resource * 0.03), 1)
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
			_stat_bd(String(u.get_status("decay").get("src_name", "")), 10)
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
				var ent_result: Dictionary = u.take_hit(0, ent_occ.entropy_ranks)
				_stat_bd(ent_occ, ent_occ.entropy_ranks)
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
			# Batch W: ticks are the caster's healing too (src stamped at
			# cast; pre-W the "healing" line never counted ticks at all).
			_stat_heal(String(ren_stat.get("src_name", "")), ren_got)
			# On the Mend (talent, snapshotted on the status): the tick can
			# wash one harmful effect away.
			var mend_pct := int(ren_stat.get("mend", 0))
			if mend_pct > 0 and randf() < 0.01 * mend_pct:
				var mended := u.dispel_one_debuff()
				if mended != "":
					u.float_text("Mended: %s" % mended, Color(0.5, 0.95, 0.6))
					_log("   → Talent: On the Mend — Renewal washes the %s off %s" % [
						mended, u.unit_name], "#b0a8e0")
			# Blessed Vestments (snapshotted on the status, Batch AV): the
			# tick leaves cloth-of-light behind, exactly as her casts do.
			var ward_pct := int(ren_stat.get("ward", 0))
			if ward_pct > 0 and ren_got > 0:
				var wd_c := _living_hero_with("vestments_pct")
				if wd_c != null:
					_vestments_ward(wd_c, u, ren_got)
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
						zl_dv.max_hp * 0.01 * zl_dv.pulse_ranks)), 1)
					var pulse_got := u.heal_amount(pulse_amt, u != zl_dv)
					u.float_text("+%d" % pulse_got, Color(0.4, 0.9, 0.45))
					_log("   → Talent: Healing Pulse — %s mends %d" % [
						u.unit_name, pulse_got], "#b0a8e0")
				if zl_dv.waters_ranks > 0 and randf() < 0.01 * zl_dv.waters_ranks:
					var washed := u.dispel_one_debuff()
					if washed != "":
						u.float_text("Cleansed: %s" % washed, Color(0.5, 0.95, 0.6))
						_log("   → Talent: Cleansing Waters — the %s washes off %s" % [
							washed, u.unit_name], "#b0a8e0")
		# Batch AW §2: the holy ground is a Faith engine in the BASE KIT now.
		_ground_faith_tick(u)
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
				func(e): return not e.dead and e.has_status("chilled") \
					and not _is_held(e))
			wg_pool.shuffle()
			var wg_n := mini(u.grasp_ranks, wg_pool.size())
			for wg_i in wg_n:
				var wg_e: BattleUnit = wg_pool[wg_i]
				if not wg_e.dead:
					_log("   → Talent: Winter's Grasp — the cold sinks deeper into %s" % \
						wg_e.unit_name, "#b0a8e0")
					_apply_status(wg_e, "chilled", 3, 0, 0, u)
		# Cold Snap: the hold is not idle time. Pressure accumulates on a
		# helpless target, so denial converts into the PARTY's Break — the
		# reason the node was re-specced rather than repriced (it used to
		# extend Frozen's duration, which an indefinite hold makes meaningless).
		if u.is_hero and not u.dead and u.cold_snap_ranks > 0:
			for cs_e in _holds.duplicate():
				if not cs_e.dead:
					_log("   → Talent: Cold Snap — the ice presses on %s (+%d BD)" % [
						cs_e.unit_name, u.cold_snap_ranks], "#b0a8e0")
					cs_e.take_hit(0, u.cold_snap_ranks)
					_stat_bd(u, u.cold_snap_ranks)
					cs_e.refresh_bars()
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
		# Beacon: as the Cleric's turn begins, her light reaches everyone at
		# death's door — no cast spent. RUNE-ONLY SINCE BATCH AV (the node
		# became Hour of Need): the Rune of the Sleepless Vigil is the last
		# writer, so the read site is KEPT and gated, never silently deleted.
		if u.is_hero and not u.dead and u.beacon_ranks > 0:
			for bc_h in heroes.filter(
					func(h): return not h.dead and not h.is_companion and h.hp < h.max_hp * 0.25):
				var bc_amt := maxi(int(round(bc_h.max_hp * 0.05 * u.beacon_ranks
					* _healing_done_mult(u))), 1)
				var bc_got: int = bc_h.heal_amount(bc_amt, bc_h != u)
				bc_h.float_text("+%d" % bc_got, Color(0.95, 0.9, 0.6))
				_stat_heal(u, bc_got)
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
				# A perfectly rigged snare holds a boss (Batch AH); the Poison is
				# a flat 4 turns either way now.
				_spring_trap(heroes[sn_idx], u, 0.0, sn_perfect)
				_apply_poison(heroes[sn_idx], u, 4)
		if not u.is_hero and not u.dead:
			for df_h in heroes:
				if not df_h.dead and df_h.deadfall_armed > 0:
					# Batch AH: an AIMED deadfall (a perfect rig) waits for the
					# one it was set for. An aim whose victim is already dead is
					# released rather than wasted, so a perfect can never be
					# worth LESS than an ordinary rig.
					df_h.deadfall_aims = df_h.deadfall_aims.filter(
						func(ix): return ix >= 0 and ix < enemies.size() \
							and not enemies[ix].dead)
					var df_here := enemies.find(u)
					if df_h.deadfall_aims.has(df_here):
						df_h.deadfall_aims.erase(df_here)
					elif df_h.deadfall_aims.size() >= df_h.deadfall_armed:
						continue  # every armed trap is spoken for, and not for you
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
		# Wind-up cancel (Batch V): a charger who loses this turn loses the
		# blow with it — Broken, Frozen, and Stunned all drop the stone.
		if u.has_status("charging"):
			if u.has_status("stunned"):
				_cancel_charge(u, "STUNNED")
			elif u.has_status("frozen"):
				_cancel_charge(u, "FROZEN")
			elif u.broken_pending:
				_cancel_charge(u, "BROKEN")
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
			# A lost turn still counts: status timers and cooldowns tick, and
			# the freeze thaws one step here.
			#
			# A CRYOMANCER'S HOLD NEVER REACHES THIS BRANCH — a held enemy is
			# off the timeline entirely (next_time = INF), which is exactly
			# what §4's missing slot in the turn bar is showing. What DOES
			# reach here is the boss carve-out (one turn of ice, then it acts
			# again — _hold_sync closes the hold on the next pass) and any
			# freeze reached with no Cryomancer standing.
			u.tick_statuses()
			u.tick_cooldowns()
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
		# Rallying Cry (Batch AL): THE one read site for `rallying_cry`. The
		# banner refuels the line on its own now, every one of his turns —
		# it used to be a rider on War Stomp, which Batch AH made earnable,
		# so on a Warden who never drew the stomp the node did nothing at
		# all. War Stomp still deepens it, at its own cast site.
		if u.rallying_cry > 0 and u.is_hero and not u.is_companion:
			var rc_fed := 0
			for rc_h in heroes:
				if rc_h.dead or rc_h == u or rc_h.resource_name == "" \
						or rc_h.max_resource <= 0:
					continue
				var rc_gain := maxi(int(rc_h.max_resource * 0.01 * u.rallying_cry), 1)
				rc_h.resource = mini(rc_h.resource + rc_gain, rc_h.max_resource)
				rc_h.float_text("+%d %s" % [rc_gain, rc_h.resource_name],
					Color(0.5, 0.8, 1.0))
				rc_h.refresh_bars()
				rc_fed += 1
			if rc_fed > 0:
				_log("   → Talent: Rallying Cry — the banner refuels the line (+%d%%)" % \
					u.rallying_cry, "#b0a8e0")
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
				# Capped at +75% to match effective_armor() — the chip must
				# never advertise a bonus the damage path cannot grant.
				var e_pct := mini(3 * u.endurance_ranks * u.endurance_stacks, 75)
				var e_desc := "Endurance: +%d%% armor for every turn\nwithout an external heal (cap +75%%).\nCurrently +%d%% armor (%d-turn streak)." % [
					3 * u.endurance_ranks, e_pct, u.endurance_stacks]
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
	# Heavy Plating's live-total chip lives in refresh_bars, which only HP
	# changes drive — Shieldwall's stance moves that total on its own clock,
	# so re-read it on the same cadence as every other live chip.
	for wd in heroes:
		if not wd.dead and wd.passive_id == "heavy_plating":
			wd.refresh_bars()
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
		var cb_step := _crushing_step(h)
		var pen: int = 9 * int(party_bleed / float(cb_step))
		h.update_status("crushing_blows", "+%d%%" % pen,
			"Crushing Blows: +9%% armor penetration for\nevery %d bloodloss on the enemy team.\nCurrently +%d%% (%d total bloodloss)." % [
				cb_step, pen, party_bleed])
	# OVERBURN's live chip. It shows BOTH numbers, because the spec is a
	# trade and half of it is invisible otherwise: the bonus it is paying him
	# right now, and the Mana it will cost him at the start of his next turn.
	# The chip is also where the asymmetry becomes legible — the bonus stops
	# at the cap and the drain keeps climbing past it.
	var burn_turns := _total_burn_turns()
	for h in heroes:
		if h.dead or h.passive_id != "overburn":
			continue
		var ob_pct := int(round((_overburn_mult(h, burn_turns) - 1.0) * 100.0))
		var ob_bill := _overburn_drain(h, burn_turns)
		var ob_cap_txt := ("no cap" if not _overburn_capped(h) \
			else "up to +%d%%" % int(round(OVERBURN_CAP + h.heat_haze_ranks)))
		h.update_status("spec_passive", "+%d%% / -%d" % [ob_pct, ob_bill],
			"Overburn: +%d%% damage for every turn of Burn\non the enemy team (%s), and 1 Mana a turn\nfor each of them — WHICH HAS NO CAP.\nCurrently +%d%% and -%d Mana a turn (%d Burn turns).\nEvery turn of Burn you CONSUME refunds Mana." % [
				int(OVERBURN_STEP), ob_cap_txt, ob_pct, ob_bill, burn_turns])
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
	# Chain Ignition: a burning death does not waste its fuel — the turns
	# it still held are SPLIT among the survivors (the corpse-scan pattern
	# Seeding proved, so it catches DoT deaths too). Splitting rather than
	# handing the whole stack to one enemy is what keeps it a SPREAD: it
	# widens the field he is drained for without deepening any one fire.
	for foe in enemies:
		if not foe.dead or foe.ember_consumed or foe.burn_at_death <= 0:
			continue
		foe.ember_consumed = true
		if _living_hero_with("ember_wind") == null:
			continue
		var ew_pool: Array = enemies.filter(func(e): return not e.dead)
		if ew_pool.is_empty():
			continue
		var ew_tick: int = maxi(foe.burn_tick_at_death, 0)
		# Whole turns only, and none lost: 5 turns across 2 survivors is 3
		# and 2, never 2.5 apiece and never a rounded-away turn.
		var ew_each: int = foe.burn_at_death / ew_pool.size()
		var ew_rem: int = foe.burn_at_death % ew_pool.size()
		for ew_i in ew_pool.size():
			var ew_share: int = ew_each + (1 if ew_i < ew_rem else 0)
			if ew_share <= 0:
				continue
			var ew_t: BattleUnit = ew_pool[ew_i]
			_apply_status(ew_t, "burn", ew_share, 0, ew_tick)
			_log("   → Talent: Chain Ignition — %d turn%s of %s's flame passes to %s" % [
				ew_share, "" if ew_share == 1 else "s", foe.unit_name,
				ew_t.unit_name], "#b0a8e0")
	# Scent of Blood: the ramp chip counts the battle's bleedouts.
	for h in heroes:
		if h.dead or h.scent_ranks == 0 or h.bleedouts_this_battle == 0:
			continue
		var sc_pct: int = 10 * h.scent_ranks * h.bleedouts_this_battle
		var sc_desc := "Scent of Blood: +%d%% damage per enemy\nbled out this battle. Currently +%d%%\n(%d bleedouts)." % [
			10 * h.scent_ranks, sc_pct, h.bleedouts_this_battle]
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
				var dw_pct: int = 25 * h.deathwish_ranks
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
					var ke_pct: int = 15 * h.killing_edge_ranks
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
					var br_con: int = 30 * h.bracing_ranks
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
	u.rampage_chains = 0   # the capstone's kill-recast budget is per turn
	u.res_cast_this_turn = false  # Resonant Core pays the FIRST cast of a turn
	# Thin Air (Batch AQ): THE one read site for mod_no_regen. It stops the
	# DRIP and nothing else — attacks that BUILD resource are untouched, which
	# is why a Rage hero survives it better than a Mage. That asymmetry is the
	# modifier, not a hole in it.
	if not u.mod_no_regen:
		if u.resource_name == "Mana":
			# Evocation (Mage class passive) adds mana_regen_bonus.
			u.resource = mini(u.resource + _mana_regen(u), u.max_resource)
			u.refresh_bars()
		elif u.resource_name == "Focus":
			u.resource = mini(u.resource + 15, u.max_resource)
			u.refresh_bars()
		elif u.resource_name == "Rage":
			u.resource = mini(u.resource + 5, u.max_resource)
			u.refresh_bars()
	# OVERBURN, CLAUSE 1 — the bill. It is charged AFTER the regen drip on
	# purpose, and the ORDER IS THE DESIGN: a Mage regenerates 22 a turn, so a
	# field holding 20 burn-turns leaves him treading water and unable to bank
	# Detonation's 25, and a field holding 24 puts him underwater. That squeeze
	# is the spec's characteristic failure and it must stay reachable in
	# ordinary play. A lethal drain (Cauterise only) ends the turn here.
	if _overburn_tick(u):
		return
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
	# Batch U drink policy: a hero opening a turn below 35% HP drinks a
	# carried Health Potion before any other action — nothing cleverer, so
	# the effect stays attributable. Run sims only (RunSim.items_on):
	# standalone and sweep battles stay dry to keep the R/S baselines.
	if autoplay and RunSim.active and RunSim.items_on and not u.is_companion \
			and u.hp < u.max_hp * 0.35 and int(items["health"][1]) > 0:
		items["health"][1] -= 1
		item_used = true
		var drank: int = u.heal_amount(40, true)
		u.float_text("+%d" % drank, Color(0.4, 0.9, 0.45))
		_log("Item: Health Potion — %s +%d HP (bot)" % [u.unit_name, drank],
			"#e0c060")
		RunSim.items_used += 1
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
		if ab.special in ["rally", "focus", "surge", "quickdraw",
				"phoenix", "hymn", "retaliate", "unity", "tripwire",
				"mana_shield", "divine_wrath", "shield_block", "hold_the_line",
				"battle_shout", "blood_price", "immolate", "stabilize",
				"overcharge", "cons_ground", "bulwark", "dark_pact", "hysteria",
				"instinct", "bestial", "spirit_bond", "hold_breath",
				"venom_coat", "deadfall", "guard_change", "interpose",
				"wildfire", "backdraft", "intercession"]:
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
				# Upgraded Execute he cannot actually pay for: the button is
				# lit by the FREE cast, so the pick narrows to the targets
				# that discount covers (Batch AK). Without this the two
				# checks could disagree and quietly zero his Rage.
				if ab.display_name == "Execute" and u.execute_upgraded > 0 \
						and ab.cost > u.resource:
					pool = pool.filter(func(e): return e.broken)
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
	if u.pleasure_pct > 0.0 and not u.dead and not battle_over:
		var pp_uniques := _unique_enemy_debuffs()
		if pp_uniques > 0:
			var pp_amt := maxi(int(round(u.max_hp * 0.01 * u.pleasure_pct
				* pp_uniques)), 1)
			for pp_h in heroes.filter(func(h): return not h.dead and not h.is_companion):
				var pp_got: int = pp_h.heal_amount(pp_amt, pp_h != u)
				pp_h.float_text("+%d" % pp_got, Color(0.7, 0.4, 0.9))
				_stat_heal(u, pp_got)
			_log("   → Talent: Pleasure from Pain — %d unique debuff%s feed the party (%d each)" % [
				pp_uniques, "" if pp_uniques == 1 else "s", pp_amt], "#b0a8e0")
	# Divine Presence (Holy talent): the light settles on the most wounded
	# as the Cleric's turn ends.
	if u.divine_presence_pct > 0 and not u.dead and not battle_over:
		var dp_pool := heroes.filter(func(h): return not h.dead and not h.is_companion)
		if not dp_pool.is_empty():
			var dp_t := _lowest_hp(dp_pool)
			if dp_t.hp < dp_t.max_hp:
				var dp_amt := maxi(int(round(dp_t.max_hp * 0.01
					* u.divine_presence_pct * _healing_done_mult(u))), 1)
				var dp_got: int = dp_t.heal_amount(dp_amt, dp_t != u)
				dp_t.float_text("+%d" % dp_got, Color(0.4, 0.9, 0.45))
				_stat_heal(u, dp_got)
				_vestments_ward(u, dp_t, dp_got)
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
				# Sunder Guard does the same for a different reason — the
				# pivot IS his party-wide Break blow, free and on a 1cd, so
				# it is worth pressing while anyone still has a guard up.
				var sm_sunder: bool = u.guard_change_bd > 0 \
					and foes.any(func(e): return not e.broken)
				if gchange != null and u.ability_ready(gchange) \
						and (u.stance != sm_want or sm_sunder \
						or (u.tempo_ranks > 0 and u.hp > u.max_hp * 0.6)):
					return [gchange, u]
				var sm_exec := _find_ability(u, "Execute")
				if sm_exec != null and _ability_usable(u, sm_exec):
					# _ability_usable already priced the cast (the upgraded
					# copy is free against a Broken target) and checked the
					# threshold, so the bot only picks a legal victim — a
					# Broken one when full price is out of reach.
					var sm_thr := 0.35 if u.execute_upgraded > 0 else 0.2
					var sm_prey: Array = (foes.filter(func(e): return e.broken) \
						if u.resource < sm_exec.cost \
						else foes.filter(func(e): return e.broken \
							or e.hp < e.max_hp * sm_thr))
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
			# Pyromancer (Batch N loop, Batch AG rework, Batch AR's ONE RULE).
			# The loop is still build-then-spend, but under Overburn a bot that
			# never spends measures a spec no player would recognise: the fire it
			# lit bills it 1 Mana a turn per burn-turn, forever, and only
			# CONSUMING the fire refunds any of it. So the rule that comes first
			# is CONSUME WHEN THE DRAIN EXCEEDS THE REGEN — Detonation onto the
			# largest stack, Wildfire when Detonation is cooling. This is
			# instrument honesty, not tuning.
			var burning_foes := foes.filter(func(e): return e.has_status("burn"))
			var unburnt: int = foes.size() - burning_foes.size()
			var ripest: BattleUnit = null
			var ripest_turns := 0
			for bf in burning_foes:
				var bf_turns := int(bf.get_status("burn").get("turns", 0))
				if bf_turns > ripest_turns:
					ripest_turns = bf_turns
					ripest = bf
			var det := _find_ability(u, "Detonation")
			var wfire := _find_ability(u, "Wildfire")
			var underwater: bool = u.passive_id == "overburn" \
				and _overburn_drain(u, _total_burn_turns()) > _mana_regen(u)
			if underwater and det != null and ripest != null \
					and u.resource >= det.cost and u.ability_ready(det):
				return [det, ripest]
			if underwater and wfire != null and not burning_foes.is_empty() \
					and u.resource >= wfire.cost and u.ability_ready(wfire):
				return [wfire, u]
			var immolate := _find_ability(u, "Immolate")
			if immolate != null and u.resource >= immolate.cost \
					and u.ability_ready(immolate) and not u.has_status("immolate") \
					and not underwater and burning_foes.size() >= 2:
				return [immolate, u]
			var fwave := _find_ability(u, "Flamewave")
			if fwave != null and u.resource >= fwave.cost and u.ability_ready(fwave) \
					and unburnt >= 2:
				return [fwave, target_foe]
			# Wildfire is the wide payoff: it wants a line already alight, not one
			# deep fire to copy. Held to 3+ so Detonation still gets its
			# single-target cash-out when he is not being squeezed.
			if wfire != null and u.resource >= wfire.cost and u.ability_ready(wfire) \
					and burning_foes.size() >= 3:
				return [wfire, u]
			if det != null and u.resource >= det.cost and u.ability_ready(det) \
					and ripest_turns >= 3:
				return [det, ripest]
			var pblast := _find_ability(u, "Pyroblast")
			if pblast != null and u.resource >= pblast.cost and u.ability_ready(pblast) \
					and target_foe.has_status("burn"):
				return [pblast, target_foe]
			var backdraft := _find_ability(u, "Backdraft")
			if backdraft != null and u.resource >= backdraft.cost \
					and u.ability_ready(backdraft) and not underwater \
					and burning_foes.size() >= 2:
				return [backdraft, u]
			var fstorm := _find_ability(u, "Firestorm")
			if fstorm != null and u.resource >= fstorm.cost and u.ability_ready(fstorm):
				return [fstorm, target_foe]
			# ARCANIST (Batch AT §6): the rotation is built on one rule —
			# **NEVER COME DOWN.** The old policy vented at 4+ stacks below 80%
			# health, which is the exact opposite of the spec that shipped (and
			# Stabilize is not even in the opening three any more). Death Ray
			# the moment the gate opens, because it consumes nothing and there
			# is no reason on earth to save it; Overcharge as LATE as it can
			# still be spent, because it compounds what he is already holding.
			# Instrument honesty, not tuning: NO DIFFICULTY MEASUREMENT BELONGS
			# IN THIS BATCH — a single-spec re-author has no honest control row,
			# which AJ, AK, AL, AR and AS each recorded.
			var dray := _find_ability(u, "Death Ray")
			if dray != null and u.resource >= dray.cost and u.ability_ready(dray) \
					and u.second_resource >= DEATH_RAY_STACKS:
				return [dray, target_foe]
			var wrath := _find_ability(u, "Magi's Wrath")
			if wrath != null and u.resource >= wrath.cost and u.ability_ready(wrath) \
					and foes.size() >= 3:
				return [wrath, target_foe]
			# Overcharge pays HALF of what he holds, so spending it early throws
			# the button away. The bot holds it until the ramp is deep enough
			# that it is worth a turn, then spends it once.
			var ocharge := _find_ability(u, "Overcharge")
			if ocharge != null and u.resource >= ocharge.cost and u.ability_ready(ocharge) \
					and u.overcharge_ready() and u.second_resource >= OVERCHARGE_BOT_STACKS:
				return [ocharge, u]
			var cannon := _find_ability(u, "Arcane Cannon")
			if cannon != null and u.resource >= cannon.cost and u.ability_ready(cannon):
				return [cannon, target_foe]
			var barrage := _find_ability(u, "Arcane Barrage")
			if barrage != null and u.resource >= barrage.cost and u.ability_ready(barrage) and foes.size() >= 2:
				return [barrage, target_foe]
			# NOTE THE ABSENCE, and do not "fix" it: Stabilize is deliberately
			# NOT in this rotation. If a player earns it out of the spec pool it
			# is theirs to press; the bot measuring the spec must never vent,
			# because venting is what the whole batch removed.
			# CRYOMANCER (Batch AS §7): the policy has to know what a HOLD is,
			# or a sim measures a spec that is not the one that shipped.
			# BUILD stacks on the highest-Attack enemy, FREEZE it, LEAVE IT
			# HELD, and release with Ice Lance only when a second freeze is
			# ready or it is the last enemy standing. Instrument honesty, not
			# tuning: NO DIFFICULTY MEASUREMENT BELONGS IN THIS BATCH — a
			# single-spec re-author has no honest control row, which is what
			# AJ, AK, AL and AR each recorded.
			var unheld: Array = foes.filter(func(e): return not _is_held(e))
			# The mark: the biggest threat he is not already holding.
			var cryo_mark: BattleUnit = null
			for e in unheld:
				if cryo_mark == null or e.attack > cryo_mark.attack:
					cryo_mark = e
			var most_chilled: BattleUnit = null
			for e in unheld:
				if e.has_status("chilled") and (most_chilled == null \
						or e.status_stacks("chilled") > most_chilled.status_stacks("chilled")):
					most_chilled = e
			# Glacial Prison on cooldown, against the highest-Attack UNHELD
			# enemy — it needs no build, so it never waits on one.
			var prison := _find_ability(u, "Glacial Prison")
			if prison != null and u.resource >= prison.cost \
					and u.ability_ready(prison) and cryo_mark != null:
				return [prison, cryo_mark]
			var lance := _find_ability(u, "Ice Lance")
			var lance_up: bool = lance != null and u.resource >= lance.cost \
				and u.ability_ready(lance)
			# SHATTER, AND IT COMES BEFORE THE LANCE (Batch AT §8). It used to sit
			# below the Lance behind a `_holds.size() >= 2` gate, which is why
			# AS's smoke never cast it once: a Shatter build cannot take Absolute
			# Zero, so it rarely holds two. Now that it charges on TURNS, the
			# honest question is whether the oldest prison has cooked long
			# enough — below the crossover the Lance is still the better button,
			# above it the Lance can never catch up.
			var shat := _find_ability(u, "Shatter")
			if shat != null and u.resource >= shat.cost and u.ability_ready(shat) \
					and _ability_usable(u, shat) \
					and _holds.any(func(e): return e.hold_turns >= SHATTER_BOT_TURNS):
				return [shat, _holds[0]]
			# THE RELEASE IS A DECISION, not a reflex — and HOLD LONGER is the
			# new default: with Shatter owned he leaves a charging prison alone
			# until it is worth breaking, because the Lance spends the charge for
			# nothing. He spends a hold on the Lance only when he can immediately
			# replace it, or when the held enemy is the last thing standing and
			# the fight cannot end otherwise.
			if lance_up and shat != null and not _holds.is_empty() \
					and not unheld.is_empty() \
					and _holds[0].hold_turns < SHATTER_BOT_TURNS:
				lance_up = false
			if lance_up and not _holds.is_empty():
				var replaceable: bool = (prison != null and u.ability_ready(prison) \
					and u.resource >= prison.cost + lance.cost and cryo_mark != null) \
					or (most_chilled != null and most_chilled.status_stacks("chilled") >= 3)
				if unheld.is_empty() or replaceable:
					return [lance, _holds[0]]
			var razor := _find_ability(u, "Razor Ice")
			if razor != null and u.resource >= razor.cost and u.ability_ready(razor) \
					and cryo_mark != null:
				return [razor, cryo_mark]
			if lance_up and most_chilled != null \
					and most_chilled.status_stacks("chilled") >= 3:
				return [lance, most_chilled]
			var bliz := _find_ability(u, "Blizzard")
			if bliz != null and u.resource >= bliz.cost and u.ability_ready(bliz) \
					and unheld.filter(func(e): return e.status_stacks("chilled") < 2).size() >= 3:
				return [bliz, target_foe]
			var rime_ab := _find_ability(u, "Rime")
			if rime_ab != null and u.resource >= rime_ab.cost and u.ability_ready(rime_ab):
				var rime_t: BattleUnit = most_chilled if most_chilled != null else cryo_mark
				if rime_t != null and not rime_t.has_status("rime"):
					return [rime_ab, rime_t]
			# Cryoclasm moves the lockdown onto whatever became the bigger
			# problem while he was holding the old one.
			var clasp := _find_ability(u, "Cryoclasm")
			if clasp != null and u.resource >= clasp.cost and u.ability_ready(clasp) \
					and _ability_usable(u, clasp) and cryo_mark != null \
					and not _holds.is_empty() and cryo_mark.attack > _holds[0].attack:
				return [clasp, cryo_mark]
			if u.passive_id == "permafrost" and cryo_mark != null:
				return [u.abilities[0], cryo_mark]       # Frostbolt the mark
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
			# BATCH AV — THE HOLY POLICY, rewritten so a sim measures the real
			# spec rather than a spec missing its identity piece. Resurrection
			# is in her OPENING KIT now, so it leads the rotation from turn one
			# instead of being a talent she might not have drawn.
			# RAISE THE FALLEN FIRST, ALWAYS, whenever she can pay for it.
			var res_ab := _find_ability(u, "Resurrection")
			if res_ab != null and u.second_resource >= res_ab.faith_cost \
					and u.resource >= _eff_cost(u, res_ab) and u.ability_ready(res_ab):
				var fallen := heroes.filter(func(h): return h.dead and not h.is_companion)
				if not fallen.is_empty():
					empower_armed = _holy_empower_ok(u, res_ab)
					return [res_ab, fallen[0]]
			# Intercession: arm the refusal while someone is genuinely close to
			# dying AND she can pay the trigger — the price lands later, so a
			# window opened on an empty hand is a wasted turn. Never doubled up
			# on a window that is already open.
			var icept := _find_ability(u, "Intercession")
			if icept != null and u.resource >= _eff_cost(u, icept) \
					and u.ability_ready(icept) and u.second_resource >= 1 \
					and not u.has_status("intercession") \
					and _any_hero_below(HOLY_VIGIL_AT):
				return [icept, u]
			var dplea := _find_ability(u, "Divine Plea")
			if dplea != null and u.second_resource >= dplea.faith_cost \
					and u.ability_ready(dplea) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.30:
				empower_armed = _holy_empower_ok(u, dplea) \
					and weakest_ally.count_debuffs() > 0
				return [dplea, weakest_ally]
			# Hymn is the party button: it wants TWO wounded, not one.
			var hymn := _find_ability(u, "Hymn of Hope")
			if hymn != null and u.second_resource >= hymn.faith_cost and u.ability_ready(hymn) \
					and _heroes_below(0.70) >= 2:
				empower_armed = _holy_empower_ok(u, hymn)
				return [hymn, u]
			# Renewal is NOT in §6's minimum and is here deliberately: On the
			# Mend and the Renewal half of her throughput are unmeasurable if
			# the bot never casts it. Reported, not silently added.
			var renew := _find_ability(u, "Renewal")
			if renew != null and u.resource >= _eff_cost(u, renew) and u.ability_ready(renew) \
					and weakest_ally.hp < weakest_ally.max_hp * 0.8 \
					and not weakest_ally.has_status("renewal"):
				return [renew, weakest_ally]
			# Heal otherwise — the fallback, so a hurt party is always mended.
			var hheal := _find_ability(u, "Heal")
			if hheal != null and u.resource >= _eff_cost(u, hheal) and u.ability_ready(hheal) \
					and weakest_ally.hp < weakest_ally.max_hp:
				return [hheal, weakest_ally]
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
			# BATCH AW §7 — CONSECRATED GROUND IS THE FAITH ENGINE NOW, so it
			# comes FIRST and goes up whenever it is off cooldown. The old
			# policy treated it as a mitigation button and only laid it at
			# three or more foes, which meant a sim measured a spec whose
			# party-wide Faith source was mostly absent.
			var ground_ab := _find_ability(u, "Consecrated Ground")
			if ground_ab != null and u.resource >= _eff_cost(u, ground_ab) \
					and u.ability_ready(ground_ab) \
					and not u.has_status("cons_ground"):
				return [ground_ab, u]
			# Divine Shield is the other Faith engine: keep it rolling, and
			# put it on whoever is LIKELIEST TO BE HIT NEXT rather than
			# round-robin — a shield that never gets struck builds no Faith.
			# Lowest health is the fallback when nothing is drawing fire.
			var shield_ab := _find_ability(u, "Divine Shield")
			if shield_ab != null and u.resource >= _eff_cost(u, shield_ab) \
					and u.ability_ready(shield_ab):
				var shield_t := _likeliest_target(allies)
				if shield_t == null or shield_t.has_status("barrier"):
					shield_t = weakest_ally
				if not shield_t.has_status("barrier"):
					return [shield_ab, shield_t]
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
			# Occultist: the Old Gods' toolkit. BATCH AX §6 — two rules, or a
			# sim measures a spec nobody plays.
			#
			# (1) FOCUS RUIN RATHER THAN SPREADING IT. Ten-stack thresholds
			# reward working ONE target; a bot that debuffs whatever is
			# convenient never detonates at all. _ruin_focus overrides the
			# generic lowest-HP pick for everything he aims.
			# (2) AGAINST A BOSS, PRIORITISE BREAK — Shadowrend and Hex on the
			# boss, and HOLD the madness casts until it is Broken, since they
			# are refused outright before that (§2). Spending a turn on one is
			# spending the turn on nothing.
			var oc_t := _ruin_focus(foes, target_foe)
			var oc_gated: bool = oc_t.is_boss and not oc_t.broken
			var pact := _find_ability(u, "Dark Pact")
			if pact != null and u.resource >= pact.cost and u.ability_ready(pact) \
					and u.hp > u.max_hp * 0.5 \
					and allies.filter(func(h): return h.hp < h.max_hp * 0.6).size() >= 2:
				return [pact, u]
			var hyst := _find_ability(u, "Mass Hysteria")
			if hyst != null and u.resource >= hyst.cost and u.ability_ready(hyst) \
					and foes.size() >= 3 and not oc_gated:
				return [hyst, u]
			var mflay := _find_ability(u, "Mind Flay")
			if mflay != null and u.resource >= mflay.cost and u.ability_ready(mflay) \
					and foes.size() >= 2 and not oc_gated:
				return [mflay, oc_t]
			var bwitch := _find_ability(u, "Bewitch")
			if bwitch != null and u.resource >= bwitch.cost and u.ability_ready(bwitch) \
					and foes.size() >= 2 and not oc_t.has_status("bewitch") \
					and not oc_gated:
				return [bwitch, oc_t]
			var hex := _find_ability(u, "Hex of Ruin")
			if hex != null and u.resource >= hex.cost and u.ability_ready(hex):
				return [hex, oc_t]
			return [u.abilities[0], oc_t]                # Smite / Shadowrend
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
	_mark_upgraded(basic_btn, u, basic)
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
			group_btn.text = "[%s] %s Companion ▸" % [_hotkey_name(e_idx),
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
		if u.avatar_of_mercy > 0:
			emp_btn.tooltip_text += "\nAvatar of Mercy: it costs nothing and\nGRANTS a stack instead."
		emp_btn.toggled.connect(func(on: bool): empower_armed = on)
		action_box.add_child(emp_btn)
	action_panel.visible = true


# The Mana an ability actually costs this unit right now: Lone Hunter
# hunts cheap without a beast; No Beast Left arms one free summon.
func _eff_cost(u: BattleUnit, ab: Ability, target: BattleUnit = null) -> int:
	if ab.special == "summon" and u.free_summon:
		return 0
	# Snap Shot: the first ability of the fight costs nothing.
	if u.snap_shot > 0 and not u.snap_used and ab.cost > 0:
		return 0
	# Execute, upgraded by its own capstone landing on an earned Execute:
	# free against a Broken target. With no target in hand — the button's
	# own affordability question — a living Broken enemy is enough to light
	# it, and _player_turn narrows the pick to exactly those (Batch AK).
	if ab.display_name == "Execute" and u.execute_upgraded > 0:
		if target != null:
			if target.broken:
				return 0
		elif enemies.any(func(e): return not e.dead and e.broken):
			return 0
	var c := ab.cost
	if u.lone_hunter > 0 and _beasts(u).is_empty():
		c = int(round(c * 0.6))
	# Warded (Batch AN): abilities cost more, basic attacks stay free. The
	# multiplier lands on the FINAL cost, after every discount, so a Lone
	# Hunter's 60% and the ward compose instead of racing. Nothing is added
	# to a zero: Strike and its kin are cost 0 already, which is the whole of
	# "basic attacks are free" — the clause describes the kit rather than
	# changing it, and this is the line that keeps it true.
	if c > 0 and not is_equal_approx(u.mod_cost_mult, 1.0):
		c = maxi(int(round(c * u.mod_cost_mult)), 1)
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
	if ab.special == "summon" and u.lone_bond > 0 and u.beast_committed:
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
	# Bruiser's own loop sets up his finisher. The upgraded copy raises the
	# threshold to 35%.
	var exec_thr := 0.35 if u.execute_upgraded > 0 else 0.2
	if ab.display_name == "Execute" \
			and not enemies.any(func(e): return not e.dead \
			and (e.hp < e.max_hp * exec_thr or e.broken)):
		return false
	# Shatter (Batch AS): it is the MASS RELEASE now, so it needs a hold to
	# break, not merely someone chilled. Cryoclasm needs one for the same
	# reason — it moves a prison, and there has to be a prison.
	if ab.display_name == "Shatter" and _holds.filter(
			func(e): return not e.dead).is_empty():
		return false
	if ab.special == "cryoclasm" and _holds.filter(
			func(e): return not e.dead).is_empty():
		return false
	# Wildfire: there has to be fire to drag (same rule as Shatter). Wildfire
	# Spread lights the unburnt on its way through, so with that node taken a
	# living enemy is enough. Backdraft only DEEPENS existing fires, so it
	# keeps the strict rule with no exception.
	if ab.special == "wildfire" and u.wildfire_spread == 0 \
			and not enemies.any(func(e): return not e.dead and e.has_status("burn")):
		return false
	if ab.special == "backdraft" \
			and not enemies.any(func(e): return not e.dead and e.has_status("burn")):
		return false
	# Stabilize: nothing to vent unless stacks sit above the floor (2, plus
	# Still Mind ranks).
	if ab.special == "stabilize" and u.second_resource <= 2 + u.still_mind_ranks:
		return false
	# Overcharge: the storm only feeds on itself once per battle — twice once
	# the tree node has landed on an already-earned copy (Batch AU §1).
	if ab.special == "overcharge" and not u.overcharge_ready():
		return false
	# DEATH RAY: THE RESONANCE GATE (8 since Batch AU). Dark until the ramp is
	# genuinely deep and then the only thing he wants to press — escalation
	# expressed as an action rather than as a passive drift. It consumes
	# NOTHING, so the gate is the only thing that stands between him and it.
	if ab.display_name == "Death Ray" and u.second_resource < DEATH_RAY_STACKS:
		return false
	return true


# One entry in the abilities popup: hotkey + label with cost, tooltip, preview.
# `key_idx` is the entry's position in _menu_entries (= its hotkey slot).
func _ability_popup_button(u: BattleUnit, ab: Ability, popup: PopupPanel,
		key_idx := -1) -> Button:
	var label: String = ab.display_name
	var hk := _hotkey_name(key_idx)
	if hk != "":
		label = "[%s] %s" % [hk, label]
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
	if ab.special == "overcharge" and not u.overcharge_ready():
		ab_btn.tooltip_text += "\n(Already Overcharged %s this battle)" % (
			"twice" if u.overcharge_extra > 0 else "once")
	# Death Ray's gate has to SAY so, and say the LIVE number, or a button dark
	# for most of a fight reads as a bug rather than as the ramp it measures.
	if ab.display_name == "Death Ray" and u.second_resource < DEATH_RAY_STACKS:
		ab_btn.tooltip_text += "\n(Requires %d Resonance — you have %d)" % [
			DEATH_RAY_STACKS, u.second_resource]
	_mark_upgraded(ab_btn, u, ab)
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
		_mark_upgraded(b, u, ab)
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
			buff_mult *= _resonance_dmg_mult(u)
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
	# Mini-boss upgrades on this ability (Batch AP §4): NAMES ONLY. Every
	# number above already reflects them — the upgrade was baked into the
	# Ability at spawn — so repeating the magnitudes here would be a second
	# copy of a number that has already moved once.
	var ups: Array = u.ability_upgrades.get(ab.display_name, [])
	if not ups.is_empty():
		tip += "\n%s" % " · ".join(PackedStringArray(ups))
	return tip


# Batch AQ §5A. AP put the upgrade names on the tooltip and NOWHERE ELSE — a
# full run awards three upgrades to every hero, twelve across the party, all
# of them discoverable only by hovering forty buttons mid-fight. An upgraded
# ability wears a ◆ now, in the gold the map card's unspent-pick badges use.
# It reads `ability_upgrades`, which is fed from apply_upgrades' RETURN, so it
# can only ever mark an upgrade that really applied.
const UPGRADE_GOLD := Color(1.0, 0.9, 0.5)


func _mark_upgraded(btn: Button, u: BattleUnit, ab: Ability) -> void:
	if (u.ability_upgrades.get(ab.display_name, []) as Array).is_empty():
		return
	btn.text = "◆ " + btn.text
	btn.add_theme_color_override("font_color", UPGRADE_GOLD)
	btn.add_theme_color_override("font_hover_color", UPGRADE_GOLD)
	btn.add_theme_color_override("font_pressed_color", UPGRADE_GOLD)


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
	# Wind-up landing (Batch V): the hoisted blow comes down — resolved as a
	# plain attack copy (the Hysteria pattern), and the landing IS this
	# turn's whole action. Cancels never reach here: the turn loop drops the
	# charge before a Broken, Frozen, or Stunned charger gets a turn.
	if u.has_status("charging"):
		var ch_name := str(u.get_status("charging").get("ability", ""))
		u.remove_status("charging")
		var ch_stored := _find_ability(u, ch_name)
		var ch_pool := _hero_side()
		if ch_stored != null and not ch_pool.is_empty():
			var ch_copy: Ability = Ability.make({"display_name": ch_stored.display_name,
				"damage": ch_stored.damage, "pressure": ch_stored.pressure,
				"dmg_type": ch_stored.dmg_type, "anim": ch_stored.anim,
				"delay": ch_stored.delay, "aoe": ch_stored.aoe})
			_message("%s's %s comes down!" % [u.unit_name, ch_stored.display_name])
			_log("%s unleashes the charged %s!" % [u.unit_name,
				ch_stored.display_name], "#e08850")
			await _wait(0.4)
			await _resolve(u, ch_copy, ch_pool.pick_random(), "good")
		return
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
		if spread_r > 0 and randf() < 0.01 * spread_r:
			var sane := enemies.filter(func(e): return not e.dead and e != u and not e.has_status("psychosis") and (not e.is_boss or e.broken))
			if not sane.is_empty():
				var infected: BattleUnit = sane.pick_random()
				_log("   → Talent: Spread of Madness — the psychosis leaps to %s" % \
					infected.unit_name, "#b0a8e0")
				_apply_status(infected, "psychosis", 3)
				_gain_ruin(infected, _max_hero_rank("spread_ruin"))
		# Whispers (talent): the madness speaks louder — 50% base, +10%/rank.
		var psy_occ := _living_occultist()
		var psy_chance := 0.5 + ((0.01 * psy_occ.whispers_step) if psy_occ != null else 0.0)
		if randf() < psy_chance:
			if psy_occ != null and psy_occ.whispers_step > 0:
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
	# Ritual Chanter: sweeps the warband's afflictions whenever any ally
	# carries one worth stripping (sticky poisons and meters don't count).
	var rite := _find_ability(u, "Cleansing Rite")
	if rite != null and allies.any(func(a): return not _cleansable_debuffs(a).is_empty()):
		return [rite, u]
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
	# Grave Totem: pulses while the chip damage adds up — two or more
	# wounded bodies make the vigil worth the turn.
	var vigil := _find_ability(u, "Dark Vigil")
	if vigil != null:
		var nicked: Array = allies.filter(func(a): return a.hp < a.max_hp)
		if nicked.size() >= 2:
			return [vigil, u]
	return []


# The wind-up dies with the lost turn: the stored blow never lands. Loud
# on purpose — cancelling the charge is the counterplay the Ash Hurler
# exists to teach (Batch V).
func _cancel_charge(u: BattleUnit, cause: String) -> void:
	var pending := str(u.get_status("charging").get("ability", "the blow"))
	u.remove_status("charging")
	u.float_text("CHARGE LOST", Color(1.0, 0.62, 0.3))
	_message("%s's %s is cancelled!" % [u.unit_name, pending])
	_log("!! %s is %s mid-charge — the %s slips from its grasp (CANCELLED)" % [
		u.unit_name, cause, pending], "#e08850")


# Everything a Cleansing Rite may strip: harmful, not a meter state
# (Broken and the Bleed buildup stay), never sticky (Slow Acting /
# Epidemic poison refuse every cleanse, this one included).
func _cleansable_debuffs(u: BattleUnit) -> Array:
	var out: Array = []
	for s in u.statuses:
		# A GLACIAL HOLD IS NOT CLEANSABLE (Batch AS). §1 says nothing else
		# thaws it, and a Cleansing Rite is very much something else — worse,
		# a battle-long freeze reads as 999 turns remaining, so the rite's
		# longest-first pick would take the hold EVERY time and the indefinite
		# prison would be worth strictly less than the old one-turn freeze
		# against any mender warband. Reported, not hidden: this removes the
		# enemy's only answer to a hold, which is what the hold limit and the
		# boss carve-out are the price for.
		if s.id == "frozen" and _is_held(u):
			continue
		if BattleUnit.DEBUFF_IDS.has(s.id) and not (s.id in ["broken", "bleed"]) \
				and not s.get("sticky", false):
			out.append(s)
	return out


# Remaining turns for "longest-remaining" comparisons: battle-long
# statuses (turns < 0 — Permafrost chill, Ruin) outlast everything.
func _turns_left(s: Dictionary) -> int:
	var t := int(s.get("turns", 0))
	return 999 if t < 0 else t


# Dominant Presence bookkeeping: the Swordmaster's armor feeds on the
# debuffs he lands.
func _note_debuff_applied(source: BattleUnit, status_id: String) -> void:
	if source != null and source.dominant_ranks > 0 \
			and BattleUnit.DEBUFF_IDS.has(status_id):
		source.debuffs_applied += 1
		_log("   → Talent: Dominant Presence — %s's armor +%d%% (%d debuff%s landed)" % [
			source.unit_name, 15 * source.dominant_ranks * source.debuffs_applied,
			source.debuffs_applied, "" if source.debuffs_applied == 1 else "s"],
			"#b0a8e0")


func _lowest_hp(pool: Array) -> BattleUnit:
	var best: BattleUnit = pool[0]
	for h in pool:
		if h.hp / float(h.max_hp) < best.hp / float(best.max_hp):
			best = h
	return best


# BATCH AW §7 — WHICH ALLY IS LIKELIEST TO BE HIT NEXT, or null when nothing
# in the board state says. Used by the Devout's bot to aim Divine Shield: a
# shield that never gets struck builds no Faith, so "whoever is drawing fire"
# beats "whoever is hurt" as an opening question.
#
# THE ONLY HONEST SIGNAL ON THIS BOARD IS A TAUNT, and it is a certainty rather
# than a lean: `_enemy_turn` narrows a mocked enemy's whole target list to the
# taunter. Everything else an enemy does is a 40/60 roll between lowest health
# and `_threat_pick`, and lowest health is what the caller already falls back
# to — so guessing past the taunt would be inventing policy, not reading it.
# Companion taunts (mocked power 100+) are deliberately skipped: the beast
# eats the hit, and it cannot hold Faith.
func _likeliest_target(pool: Array) -> BattleUnit:
	for e in enemies:
		if e.dead or not e.has_status("mocked"):
			continue
		var m_idx: int = e.status_power("mocked")
		if m_idx < 0 or m_idx >= heroes.size() or m_idx >= 100:
			continue
		var taunter: BattleUnit = heroes[m_idx]
		if not taunter.dead and pool.has(taunter):
			return taunter
	return null


# The living hero carrying a passive, or null (Batch W: attribution for
# passive-driven mitigation like the Chilled swing malus).
func _living_hero_passive(pid: String) -> BattleUnit:
	for h in heroes:
		if not h.dead and h.passive_id == pid:
			return h
	return null


# Highest rank of a talent stat among LIVING heroes (party-wide talents
# like Hypothermia, Brittle Ice, Hungering Cold, Frigid Grip).
func _max_hero_rank(field: String) -> int:
	var best := 0
	for h in heroes:
		if not h.dead:
			best = maxi(best, int(h.get(field)))
	return best


# Crushing Blows' step: how much enemy-party bloodloss buys one 9% slice of
# armor penetration. The counter is an INDEX, not a rank — Batch AJ's
# cross-row condition adds a second point when Savagery was taken too, and
# the wounds pay out a third faster. Shared by the damage calc and the chip
# so the readout can never disagree with the number it describes.
func _crushing_step(u: BattleUnit) -> int:
	return 15 if u.crushing_blows_ranks >= 2 else 20


# ADJACENT (keyword): the enemies DIRECTLY beside the target in formation
# order. A dead neighbor NEGATES the adjacent bonus on that side — the
# effect never jumps past a corpse to the next living enemy. Used by
# splash effects (Sundering).
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
# Death Ray's gate — THE one place the line is decided, read by
# `_ability_usable`, its tooltip affordance and the bot's rotation.
# BATCH AU RAISED IT 5 -> 8. At twelve stacks the ability lands 325% of Attack
# in one hit, and a genuinely LATE button is more on-theme than a turn-five one.
# Terminal Velocity's 15-stack threshold still sits clear above it.
const DEATH_RAY_STACKS := 8
# Where the bot decides Overcharge is finally worth a turn. A BOT POLICY NUMBER,
# not a design one — Overcharge itself has no threshold.
const OVERCHARGE_BOT_STACKS := 8
# Where the bot stops preferring Ice Lance and starts preferring Shatter. ALSO A
# BOT POLICY NUMBER: it sits just past the crossover (three turns held is worth
# less than the Lance's 35% plus its stack bonus; five is worth more).
const SHATTER_BOT_TURNS := 5
# Hour of Need (Holy, Batch AV; renamed by AW §9): how low ANY hero has to be
# for the party to close ranks. THE one place the line is decided — the damage
# block and the node text read the same number.
const HOLY_VIGIL_AT := 0.30


# Is any living hero (companions excluded) under this fraction of their
# maximum health? A named method rather than an inline lambda: a multiline
# lambda in a call argument is the GDScript trap CLAUDE.md records.
func _any_hero_below(frac: float) -> bool:
	return _heroes_below(frac) > 0


# …and how many. Shared Vigil asks the first question, the bot's Hymn gate
# asks the second, and both must count the same bodies.
func _heroes_below(frac: float) -> int:
	var n := 0
	for h in heroes:
		if not h.dead and not h.is_companion and h.hp < h.max_hp * frac:
			n += 1
	return n


# THE EMPOWER RULE FOR THE BOT (Batch AV §6), asked the same way by every
# Holy cast so the policy lives in one place:
#   * Avatar of Mercy makes it unconditional — it now GRANTS a stack.
#   * If ARDOR is learned, bank to its threshold first and Empower freely
#     above it. Below the threshold the surcharge is a real spend, and the
#     rhythm the node exists for is "bank, then spend".
#   * NEVER Empower down past a Resurrection she could otherwise cast. Her
#     identity is the raise; a prettier Hymn is not worth losing it.
func _holy_empower_ok(u: BattleUnit, ab: Ability) -> bool:
	if u.second_resource_name != "Mercy":
		return false
	if u.avatar_of_mercy > 0:
		return true
	if u.ardor_at > 0 and u.second_resource < u.ardor_at:
		return false
	var free_empower: bool = u.ardor_at > 0 and u.second_resource >= u.ardor_at
	var surcharge := 0 if free_empower else 1
	if u.second_resource < ab.faith_cost + surcharge:
		return false
	var res_ab := _find_ability(u, "Resurrection")
	if res_ab != null \
			and u.second_resource - ab.faith_cost - surcharge < res_ab.faith_cost:
		return false
	return true


func _miss_chance(attacker: BattleUnit, defender: BattleUnit = null) -> float:
	# No Cover (Sharpshooter): a BYPASS, not a modifier — these attacks
	# cannot be made to miss by any current or future source.
	if attacker.no_cover > 0:
		return 0.0
	var chance := MISS_CHANCE + (0.20 if attacker.has_status("dazed") else 0.0) \
		+ (0.50 if attacker.has_status("blind") else 0.0)
	# Numbing Veil: chilled fingers fumble the blow. THE NODE IS GONE (Batch AS
	# gave its id to Glacial Prison) — this read site is KEPT because the Rune
	# of the Killing Cold still writes the counter. ADDITIVE: percentage points.
	if not attacker.is_hero and attacker.has_status("chilled"):
		chance += 0.01 * _max_hero_rank("numbing_ranks")
	# Elusiveness: the wolf and the eagle are hard to pin down.
	if defender != null and defender.has_status("elusive"):
		chance += 0.25
	return chance


# One parry roll, attributed to the slice it landed in so the log can name
# the source: base reflexes, the Sword Mastery talent, or the Parry Up buff.
# "" = no parry. A spec stat block can replace the baseline outright
# (Swordmaster 12%); Parry Up's power carries its whole % (0 = the classic
# 15; a perfect Guard Change grants 10, or 25 with Swordsmanship — Batch AK
# moved that node's magnitude INTO the granted power, so the chip's live
# number and the roll can never disagree).
func _roll_parry(defender: BattleUnit) -> String:
	var base := defender.parry_chance if defender.parry_chance >= 0.0 \
		else (PARRY_CHANCE if defender.is_hero else ENEMY_PARRY_CHANCE)
	var talent := defender.parry_bonus
	var buff := 0.0
	if defender.has_status("parry_up"):
		var pw := defender.status_power("parry_up")
		buff = (pw if pw > 0 else 15) / 100.0
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
	attacker.resource = clampi(attacker.resource - _eff_cost(attacker, ab, target) \
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
		# TERMINAL VELOCITY (Batch AT): deep enough into Runaway Resonance, the
		# payoff nuke stops having a cooldown at all. The Overload lane's answer
		# to "what does the late game look like" — he just keeps pressing it.
		elif ab.display_name == "Death Ray" and attacker.terminal_velocity > 0 \
				and attacker.second_resource >= attacker.terminal_velocity:
			_log("   → Talent: Terminal Velocity — Death Ray has no cooldown", "#b0a8e0")
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
		if _sanctified_refund(attacker):
			_log("   → Talent: Sanctified — the Mercy is not consumed", "#b0a8e0")
		else:
			attacker.second_resource = maxi(attacker.second_resource - ab.faith_cost, 0)
		attacker.refresh_bars()
	# Holy Light (talent): every perfect cast drips Mana back.
	if grade == "perfect" and attacker.holy_light_pct > 0 \
			and attacker.resource_name == "Mana":
		var hl_mana := maxi(int(round(attacker.max_resource
			* 0.01 * attacker.holy_light_pct)), 1)
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
		_stat_heal(attacker, amount)
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
			# Shatter only detonates what he is HOLDING (Batch AS): the
			# capstone is the mass release, so its victims are the prisons.
			if ab.display_name == "Shatter":
				strike_targets = strike_targets.filter(func(t): return _is_held(t))
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
		# Firestorm: 6-8 bolts from the sky. The perfect no longer adds a
		# bolt (Batch AH) — it aims the ones you already have.
		if ab.display_name == "Firestorm":
			total_hits = randi_range(6, 8)
		# Splintering Shards: Razor Ice ALWAYS finds a fourth victim, so one
		# cast is four stacks and four stacks is a freeze. The roll is gone
		# deliberately — a node that decides whether the spec's win condition
		# happens this turn must not be a coin flip.
		if ab.display_name == "Razor Ice" and attacker.splinter_ranks > 0:
			total_hits += 1
			_log("Talent: Splintering Shards — Razor Ice splinters again!", "#b0a8e0")
		var total_dealt := 0
		var enemies_struck := 0  # landed strikes (Magi's Wrath recoil fades per hit)
		var struck_before: BattleUnit = null  # last random-hit victim (Explosion)
		# Batch AH: victims already hit by THIS cast, for the two scatter
		# perfects that spread instead of adding a bolt. Per cast, so a
		# second Barrage next turn starts from a clean board.
		var _spread_struck := {}
		var any_crit := false
		# Critical Mass's third-crit trips, counted here and PAID AFTER the
		# strike loop (Batch AT). It must not pay inside the loop: granting
		# Resonance mid-cast would let the compounding curve read the new stack
		# count on the very hit that earned it — the ordering trap AG fixed for
		# Detonation and AR for Pressure Cooker, arriving through a third door.
		var crit_mass_trips := 0
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
				# Batch AH — the two scatter perfects buy AIM, not volume:
				# Firestorm spreads its bolts evenly across the living, and
				# Arcane Barrage never strikes the same enemy twice while an
				# unstruck one still stands. One mechanic, two framings: deal
				# the pool round-robin, refilling only once it empties.
				if is_perfect and not is_counter \
						and ab.display_name in ["Firestorm", "Arcane Barrage"]:
					var fresh: Array = live_pool.filter(
						func(t): return not _spread_struck.has(t))
					if fresh.is_empty():
						_spread_struck.clear()
						fresh = live_pool
					live_pool = fresh
				# Arcane Explosion: the two blasts land on DISTINCT enemies
				# whenever two still stand.
				if ab.display_name == "Arcane Explosion" and hit_i > 0 \
						and live_pool.size() > 1 and struck_before != null:
					live_pool = live_pool.filter(func(t): return t != struck_before)
				strike_target = live_pool.pick_random()
				_spread_struck[strike_target] = true
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
			# effects. Sources (logged): Interpose charges (guaranteed), the
			# base Block stat, or Heavy Plating. Broken units cannot Block.
			if not is_counter and not strike_target.broken and not strike_target.dead \
					and not strike_target.is_companion:
				var block_source := ""
				var charges := strike_target.get_status("shield_charges")
				if not charges.is_empty() and int(charges.get("power", 0)) > 0:
					block_source = "Interpose"
					charges["power"] = int(charges["power"]) - 1
					var charges_left := int(charges["power"])
					if charges_left <= 0:
						strike_target.remove_status("shield_charges")
					else:
						# The chip counts down the blocks still owed.
						strike_target.update_status("shield_charges",
							"IP%d" % charges_left,
							"Interpose: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % charges_left)
				else:
					# One roll, attributed to whichever slice it landed in.
					# Heavy Plating v2: the passive's 15% plus the pity ramp —
					# +8% per unblocked hit, so blocks arrive on a cadence
					# instead of whenever the dice feel like it.
					var plating := (0.15 + strike_target.plating_bonus) \
						if strike_target.passive_id == "heavy_plating" else 0.0
					var plate_label := "Heavy Plating"
					# Shieldwall (Batch AB) rides the SAME slice on purpose: the
					# stance raises the Block roll instead of bypassing it, so
					# the blocks it buys are Heavy Plating blocks and DO feed
					# Tenacity and Rally. That trade is the whole ability.
					if strike_target.has_status("shieldwall"):
						plating += 0.01 * maxi(
							strike_target.status_power("shieldwall"), 0)
					# Bulwark Line (Batch AL): the same stance, thrown over the
					# rest of the party. Heavy Plating is the Warden's own
					# passive, so on an ALLY this slice is the only thing in
					# it — hence its own label, which also keeps Tenacity and
					# Rally (they test for "Heavy Plating") from firing off a
					# teammate's block.
					if strike_target.has_status("bulwark_line"):
						plating += 0.01 * maxi(
							strike_target.status_power("bulwark_line"), 0)
						if strike_target.passive_id != "heavy_plating":
							plate_label = "Bulwark Line"
					var block_roll := randf()
					if block_roll < strike_target.block_chance:
						block_source = "base Block"
					elif block_roll < strike_target.block_chance + plating:
						block_source = plate_label
				if block_source != "":
					_stat("attacks")
					_stat("attack_block")
					# Batch W: what the blocked swing would have carried — the
					# nominal hit through the blocker's armor (variance, crits
					# and riders can't be known for a hit never rolled).
					# Interpose charges credit their stamped caster, so a
					# covered ally's block is the Warden's work. Batch AB:
					# Shieldwall is no longer its own mitigation site — the
					# stance's blocks land in this roll and are credited to
					# the blocker below. Counted once, never lost.
					if strike_target.is_hero and ab.damage > 0:
						var pv_owner := ""
						if block_source == "Interpose":
							pv_owner = String(charges.get("src_name", ""))
						if pv_owner == "":
							pv_owner = strike_target.unit_name
						_prev(pv_owner, ab.damage * 0.01 * attacker.attack
							* (1.0 - strike_target.effective_armor()))
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
					# Unkillable: blocking mends the Warden — 8%/rank of the
					# pool he brought INTO the battle, not the one Tenacity
					# grows during it. Both talents trigger on the same Heavy
					# Plating block, so reading live max_hp made every block
					# enlarge the pool the next block healed from: a runaway
					# that reached ~127,000 max HP and 7,607 per mend, and a
					# battle neither side could ever end (Batch W, 08-02).
					# Same "true max" idiom the end-of-battle save sync uses.
					if strike_target.unkillable_ranks > 0:
						var unkill_base: int = strike_target.max_hp \
							- strike_target.tenacity_hp_gained
						var mend := maxi(int(unkill_base * 0.08
							* strike_target.unkillable_ranks), 1)
						strike_target.heal_amount(mend)
						strike_target.float_text("+%d" % mend, Color(0.4, 0.9, 0.45))
						_log("   → Talent: Unkillable — %s mends %d" % [
							strike_target.unit_name, mend], "#b0a8e0")
					# Richocet: the shield answer can ring the attacker's skull.
					if strike_target.ricochet_ranks > 0 and not attacker.dead \
							and randf() < 0.35 * strike_target.ricochet_ranks:
						_log("   → Talent: Richocet — the block staggers %s" % \
							attacker.unit_name, "#b0a8e0")
						_apply_status(attacker, "stunned", 1)
					# Battered Not Broken: a Broken unit cannot Block at all,
					# so blocking works to hold that fate off.
					if strike_target.battered_ranks > 0 and strike_target.pressure > 0:
						var bnb := mini(30 * strike_target.battered_ranks,
							strike_target.pressure)
						strike_target.pressure -= bnb
						strike_target.refresh_bars()
						_log("   → Talent: Battered Not Broken — the block shrugs off %d Break" % bnb,
							"#b0a8e0")
					# Bruising Guard: the shield answers in Break damage — on
					# the most-attacked hero, a quiet party-wide Break engine.
					if strike_target.bruising_ranks > 0 and not attacker.dead \
							and not attacker.is_hero:
						var bg_bd := 30 * strike_target.bruising_ranks
						attacker.take_hit(0, bg_bd)
						_stat_bd(strike_target, bg_bd)
						attacker.float_text("+%d BD" % bg_bd, Color(0.8, 0.5, 1.0))
						_log("   → Talent: Bruising Guard — the block deals %d Break damage to %s" % [
							bg_bd, attacker.unit_name], "#b0a8e0")
					# Tenacity / Rally feed on Heavy Plating blocks alone.
					if block_source == "Heavy Plating":
						if strike_target.tenacity > 0:
							strike_target.max_hp += 15
							strike_target.tenacity_hp_gained += 15
							strike_target.refresh_bars()
							strike_target.float_text("+15 Max HP", Color(0.55, 0.9, 0.6))
							_log("   → Talent: Tenacity — %s toughens (+15 max HP)" % \
								strike_target.unit_name, "#b0a8e0")
						if strike_target.rally > 0:
							var rinfo: Array = STATUS_INFO["rally_heal"]
							for h in heroes:
								if not h.dead:
									h.add_status("rally_heal", rinfo[0], rinfo[1],
										rinfo[2], 3, rinfo[3])
							_log("   → Talent: Rally — the party is Rallied (+30% healing, 3 turns)",
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
					# Plate Discipline steepens the climb (+12%/rank), taking
					# the ramp to its +40% cap in two unblocked hits rather
					# than five.
					var wd_climb := 0.08 \
						+ 0.12 * strike_target.plate_discipline_ranks
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
					_apply_status(strike_target, "high_guard", 3)
			# Pommel Strike carries its own keen 25% crit base.
			var crit_chance := (0.25 if ab.display_name == "Pommel Strike" else CRIT_CHANCE) \
				+ (0.25 if strike_target.broken else 0.0)
			# RUNAWAY RESONANCE, CLAUSE 3: +1% crit per stack, LINEAR and
			# deliberately so — one stable term a player can hold in their head
			# beside two that compound. The Rune of the Wide Current is the only
			# thing that deepens it now (arcane_mastery_ranks is rune-only).
			if attacker.second_resource_name == "Resonance":
				crit_chance += (0.01 + 0.01 * attacker.arcane_mastery_ranks) \
					* attacker.second_resource
			crit_chance += attacker.crit_bonus
			# Pack Bond (Aguila): the eagle's eyes serve the whole party
			# (+10% crit, scaled by the bond tier — doubled/tripled/half).
			if attacker.is_hero and not attacker.is_companion:
				crit_chance += _party_crit_bonus()
			# Precision Strikes: exploits Dazed / Crippled / Exposed targets.
			if attacker.precision_ranks > 0 and (strike_target.has_status("dazed")
					or strike_target.has_status("cripple")
					or strike_target.has_status("exposed")):
				crit_chance += 0.20 * attacker.precision_ranks
			# Seasoned Fighter (talent node): sharpens Lunge and Overpower.
			if attacker.blade_crit_ranks > 0 \
					and ab.display_name in ["Lunge", "Overpower"]:
				crit_chance += 0.15 * attacker.blade_crit_ranks
			# Killing Edge: the Aggressive guard hunts the opening.
			if attacker.killing_edge_ranks > 0 and attacker.stance == "aggressive":
				crit_chance += 0.15 * attacker.killing_edge_ranks
			# Super Nova: Detonation crits harder into the ash.
			if attacker.supernova_ranks > 0 and ab.display_name == "Detonation":
				crit_chance += 0.03 * attacker.supernova_ranks
			# Brittle Ice (talent): a HELD target is easier to strike true, and
			# it is party-wide. ADDITIVE — percentage points.
			if _is_held(strike_target):
				crit_chance += 0.01 * _max_hero_rank("frostbite_ranks")
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
			# Triple Shot perfect (Batch AH): the crit lottery still rolls,
			# but one arrow is paid up front — the LAST one, so a crit the
			# volley already rolled is never spent covering the guarantee.
			if is_perfect and ab.display_name == "Triple Shot" \
					and hit_i == total_hits - 1 and not any_crit:
				is_crit = true
			# Held Breath: the promised shot cannot glance either.
			if attacker.has_status("held_breath") and ab.damage > 0 and not is_counter:
				is_crit = true
			any_crit = any_crit or is_crit
			# Ability damage is a PERCENT of the attacker's current Attack.
			var raw := ab.damage * 0.01 * attacker.attack * randf_range(0.9, 1.1) * dmg_mult
			if parried:
				var pv_was := raw
				raw *= 0.0 if wall_parry else 0.25
				if strike_target.is_hero:
					_prev(strike_target, pv_was - raw)
			if is_crit:
				# Lethal Aim x2 base; Executioner's Eye deepens it, Consistent
				# Aim trades it back to x1.5 for +30% chance.
				var crit_mult := 1.5
				if attacker.passive_id == "lethal_aim":
					crit_mult = 1.5 if attacker.consistent_aim > 0 \
						else 2.0 + 0.1 * attacker.lethal_eye_ranks
				# Piercing Ice: the lance drives deeper on a crit. ADDITIVE —
				# the counter is percentage POINTS of critical damage.
				if ab.display_name == "Ice Lance":
					crit_mult += 0.01 * attacker.piercing_ice_ranks
				raw *= crit_mult
				# CRITICAL MASS — TWO CLAUSES, ONE STREAK. The NODE builds
				# Resonance on every third crit (critical_mass_stacks, Batch
				# AT); the RUNE of the Wide Current still pays the OLD clause,
				# +20% damage and Mana (critical_mass_ranks, rune-only now, read
				# site deliberately kept per §4). Both ride the same counter, so
				# a hero holding both gets ONE third-crit proc paying both
				# halves rather than two counters drifting apart.
				if attacker.critical_mass_ranks > 0 \
						or attacker.critical_mass_stacks > 0:
					attacker.crit_streak += 1
					if attacker.crit_streak >= 3:
						attacker.crit_streak = 0
						crit_mass_trips += 1
						if attacker.critical_mass_ranks > 0:
							raw *= 1.0 + 0.20 * attacker.critical_mass_ranks
							var cm_mana := int(round(attacker.max_resource
								* 0.10 * attacker.critical_mass_ranks))
							attacker.resource = mini(attacker.resource + cm_mana,
								attacker.max_resource)
							attacker.float_text("+%d Mana" % cm_mana, Color(0.5, 0.7, 1.0))
							attacker.refresh_bars()
							_log("   → Rune: Critical Mass — +%d%% damage, +%d Mana" % [
								20 * attacker.critical_mass_ranks, cm_mana], "#b0a8e0")
			# RUNAWAY RESONANCE, CLAUSE 2 (attacker side): the COMPOUNDING
			# damage curve. Conduit and Singularity move its step; nothing caps
			# it. See BattleUnit.resonance_curve for the arithmetic.
			if attacker.second_resource_name == "Resonance":
				raw *= _resonance_dmg_mult(attacker)
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
			# THE PER-STACK TERMS ON ARCANE CANNON AND MAGI'S WRATH ARE GONE
			# (Batch AT §2), AND THIS IS THE TRAP THE BATCH EXISTS AROUND: the
			# passive compounds now, so an ability-side "+x% per stack" would
			# multiply a curve by a slope and SQUARE the escalation. Cannon
			# keeps BD = 5 x stacks (Break is a different axis, see the
			# pressure block) and its 15% recoil; Wrath keeps 2.5 x stacks.
			# DO NOT re-add a per-stack damage term to either one.
			#
			# Volatility: the Cannon alone now, and it is a bigger bill as well
			# as a bigger blow — the recoil SET lands in the recoil block.
			if attacker.volatility_ranks > 0 and ab.display_name == "Arcane Cannon":
				raw *= 1.0 + 0.01 * attacker.volatility_ranks
			# Suppressing Fire: every Barrage bolt bites harder than the last.
			# ADDITIVE — the counter is percentage POINTS of Attack per bolt.
			if ab.display_name == "Arcane Barrage" and attacker.suppressing_ranks > 0 \
					and hit_i > 0:
				raw += 0.01 * attacker.suppressing_ranks * hit_i * attacker.attack
			# Frostbolt / Razor Ice perfects: flat 25% of Attack instead.
			if is_perfect and ab.display_name in ["Frostbolt", "Razor Ice"]:
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Hunter's Instinct: empowered Quick Shots bite deeper.
			if ab.display_name == "Quick Shot" and attacker.has_status("instinct"):
				raw += 0.10 * attacker.attack
			# Master's Aim: the basic shot is the craft.
			if ab.display_name == "Quick Shot" and attacker.masters_aim_ranks > 0:
				raw += 0.06 * attacker.masters_aim_ranks * attacker.attack
			# Empowered Frostbolt — NO NODE AND NO RUNE writes this (Batch AS):
			# unreachable but kept, the AR vault pattern.
			if ab.display_name == "Frostbolt" and attacker.emp_frostbolt_ranks > 0:
				raw += 0.02 * attacker.emp_frostbolt_ranks * attacker.attack
			# SHATTER: 10% of Attack PER TURN THE HELD ENEMY SPENT HELD, capped
			# at 12 (Batch AT §8 — it used to read Chilled stacks, which under an
			# indefinite hold are pinned at 4 for everyone and so made Shatter a
			# more expensive Ice Lance). `ab.damage` is the 10, so this multiplies
			# by the charge. The release still runs AFTER the whole strike loop
			# for the same reason it always did: releasing first would zero the
			# very counter the capstone is paid on (the ordering trap AG fixed for
			# Detonation, arriving through a third door).
			if ab.display_name == "Shatter":
				raw *= float(clampi(strike_target.hold_turns, 1, SHATTER_TURN_CAP))
			# Ice Lance: the stored cold detonates — +5% of Attack per Chilled
			# stack on the target, and Crystal Edge deepens the take. ADDITIVE:
			# the counter is percentage POINTS on top of the base 5.
			if ab.display_name == "Ice Lance" \
					and strike_target.status_stacks("chilled") > 0:
				raw += (0.05 + 0.01 * attacker.crystal_edge_ranks) \
					* strike_target.status_stacks("chilled") * attacker.attack
			# Icy Veins — NO NODE AND NO RUNE writes this (Batch AS): kept, gated
			# and reported rather than deleted, the AR vault pattern.
			if ab.display_name == "Ice Lance" and attacker.icy_veins_charge > 0.0:
				raw *= 1.0 + attacker.icy_veins_charge
			# Freezing Advance — same: unreachable but kept.
			if attacker.freezing_ranks > 0 and strike_target.freezing_adv_mark \
					and ab.damage > 0:
				raw *= 1.0 + 0.10 * attacker.freezing_ranks
			if is_perfect and ab.display_name == "Explosive Shot":
				raw = 0.12 * attacker.attack * randf_range(0.9, 1.1)
			# Fireball perfect: the bolt hits at 25% of Attack instead of 20%.
			if is_perfect and ab.display_name == "Fireball":
				raw = 0.25 * attacker.attack * randf_range(0.9, 1.1)
			# Pyroblast (out of the vault, Batch AR): half again into a target
			# that is already alight. It consumes nothing — it just asks you
			# to have lit the fire first.
			if ab.display_name == "Pyroblast" and strike_target.has_status("burn"):
				raw *= 1.5
				_log("   → Pyroblast lands on burning flesh (+50%%)", "#e08850")
			# Overburn reads the field as it stands BEFORE this strike eats any
			# of it — Detonation's own consumption must not shrink the bonus
			# the consuming cast is paid (Batch AG).
			var inferno_turns := _total_burn_turns()
			# DETONATION, the win condition (Batch AR): it consumes Burn and
			# adds 250% of its remaining damage (tick × turns left × 2.5) to
			# this hit before mitigation. Focused Flame takes that to 325%;
			# the Rune of the Blast Radius still carries its OWN +25% term, so
			# node and rune each pay their advertised number alone and stacked.
			# WHICH banks it empties widens with the tree: the target alone,
			# plus its two neighbours under Total Commitment, or every burning
			# enemy on the field under Cataclysm.
			var detonated := 0
			var det_turns := 0
			# Whether the STRUCK target's own Burn went in — captured here
			# because Pressure Cooker is read AFTER the consumption, and by
			# then has_status("burn") is false on the very target it means.
			# Same ordering trap Batch AG fixed for the passive.
			var det_target_burned := false
			if ab.display_name == "Detonation":
				var det_pool: Array = [strike_target]
				if attacker.cataclysm > 0:
					det_pool = enemies.filter(func(e): return not e.dead)
				elif attacker.total_commitment > 0:
					det_pool = [strike_target] + _adjacent_enemies(strike_target)
				var det_mult: float = (2.5 + 0.75 * attacker.focused_flame) \
					* (1.0 + 0.25 * attacker.blast_radius_ranks)
				for det_t in det_pool:
					var det: Dictionary = det_t.get_status("burn")
					if det.is_empty():
						continue
					var det_left: int = maxi(int(det.turns), 0)
					if det_left <= 0:
						continue
					detonated += int(round(int(det.get("tick", 6)) \
						* det_left * det_mult))
					det_turns += det_left
					if det_t == strike_target:
						det_target_burned = true
					det_t.remove_status("burn")
				raw += detonated
				if det_pool.size() > 1 and det_turns > 0:
					_log("   → %s — the Burn of %d enemies goes into one hit" % [
						"Capstone: Cataclysm" if attacker.cataclysm > 0 \
							else "Talent: Total Commitment", det_pool.size()],
						"#b0a8e0")
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
			# Overburn: the Pyromancer feeds on every TURN of fire still
			# standing on the enemy team — capped, unlike the drain he pays
			# for the same fire (see _overburn_mult).
			raw *= _overburn_mult(attacker, inferno_turns)
			# Ash Lung: he is only paid for standing in it while the fire is
			# genuinely costing him more than the turn gives back.
			if attacker.ash_lung > 0 \
					and _overburn_drain(attacker, inferno_turns) \
						> _mana_regen(attacker):
				raw *= 1.15
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
			var pv_chill := raw
			if atk_chill >= 3:
				raw *= 0.85
			if atk_chill > 0:
				raw *= 1.0 - 0.01 * _max_hero_rank("hungering_ranks") * atk_chill
			if not attacker.is_hero and strike_target.is_hero and pv_chill > raw:
				_prev(_living_hero_passive("permafrost"), pv_chill - raw)
			# Frost Ward — NO NODE AND NO RUNE writes this (Batch AS): kept and
			# gated rather than deleted, the AR vault pattern.
			if not attacker.is_hero and atk_chill > 0 \
					and strike_target.frost_ward_ranks > 0:
				var pv_was := raw
				raw *= 1.0 - 0.04 * strike_target.frost_ward_ranks
				_prev(strike_target, pv_was - raw)
			# Blood Frenzy v2: +2% (plus Unstoppable) per 5% missing, never
			# below the ratcheting floor (half this battle's peak bonus) —
			# the unit-side helper ratchets and returns in one motion.
			if attacker.passive_id == "bloodrage":
				raw *= 1.0 + attacker.frenzy_bonus()
			# Enraged (talent): stacks from dropping below half HP.
			if attacker.enraged_stacks > 0 and attacker.enraged_ranks > 0:
				raw *= 1.0 + 0.12 * attacker.enraged_ranks * attacker.enraged_stacks
			# Battle Shout: fury fed by the enemy party's open wounds (at cast).
			if attacker.has_status("battle_shout"):
				raw *= 1.0 + attacker.status_power("battle_shout") / 100.0
			# Blood Price: strength bought with his own blood.
			if attacker.has_status("blood_price"):
				raw *= 1.25
			# Scent of Blood: every bleedout this battle feeds the fury.
			if attacker.scent_ranks > 0 and attacker.bleedouts_this_battle > 0:
				raw *= 1.0 + 0.10 * attacker.scent_ranks * attacker.bleedouts_this_battle
			# Deathwish: nothing left to lose below 35% health.
			if attacker.deathwish_ranks > 0 and attacker.hp < attacker.max_hp * 0.35:
				raw *= 1.0 + 0.25 * attacker.deathwish_ranks
			# Undying Rage: the refusal burns while he rides below a quarter.
			if attacker.undying_rage > 0 and not attacker.undying_rage_used \
					and attacker.hp < attacker.max_hp * 0.25:
				raw *= 1.5
			# Grudge: the damage the Warden does keep is aimed at whoever
			# he is holding — +25%/rank against targets HIS taunt binds.
			# The Rune of Grudges keeps its own advertised +6% in a SEPARATE
			# term (Batch AL): it used to add a rank to this counter, and
			# re-pricing the node from 6% to 25% would have quadrupled the
			# rune's number without anyone touching the rune.
			var grudge_cut := 0.25 * attacker.grudge_ranks \
				+ attacker.rune_grudge_bonus
			if grudge_cut > 0.0 and strike_target.has_status("mocked") \
					and strike_target.status_power("mocked") == heroes.find(attacker):
				raw *= 1.0 + grudge_cut
				_log("   → Talent: Grudge — +%d%% against his taunted mark" % \
					int(round(grudge_cut * 100.0)), "#b0a8e0")
			# Rune of the Reaper (rune_execute_bonus, its only read site):
			# wounded prey — targets below 35% health — takes extra.
			if attacker.rune_execute_bonus > 0.0 \
					and strike_target.hp < strike_target.max_hp * 0.35:
				raw *= 1.0 + attacker.rune_execute_bonus
				_log("   → Rune: the Reaper takes the wounded (+%d%%)" % int(round(
					attacker.rune_execute_bonus * 100)), "#b0a8e0")
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
					var ow_pct := 8 * attacker.overwhelm_ranks * ow_n
					raw *= 1.0 + 0.01 * ow_pct
					_log("   → Talent: Overwhelm — +%d%% (%d debuffs)" % [
						ow_pct, ow_n], "#b0a8e0")
			# Tempo: the pivot's momentum rides the next cut.
			if attacker.has_status("tempo"):
				raw *= 1.0 + attacker.status_power("tempo") / 100.0
			# Punishment: the narrow, big half of the Broken window — all of
			# it through Overpower.
			if strike_target.broken and attacker.punishment_ranks > 0 \
					and ab.display_name == "Overpower":
				raw *= 1.0 + 0.60 * attacker.punishment_ranks
				_log("   → Talent: Punishment — Overpower +%d%% vs Broken" % (
					60 * attacker.punishment_ranks), "#b0a8e0")
			# Off Balance: the broad half — the whole kit, but smaller. The
			# two stopped being an exclusive pair in Batch AK (different
			# rows), so with Punishment ALSO taken this widens what counts
			# as a window instead of stacking a second number onto Broken:
			# Exposed and Crippled targets pay out too.
			if attacker.off_balance_ranks > 0:
				var ob_word := ""
				if strike_target.broken:
					ob_word = "Broken"
				elif attacker.off_balance_wide > 0:
					if strike_target.has_status("exposed"):
						ob_word = "Exposed"
					elif strike_target.has_status("cripple"):
						ob_word = "Crippled"
				if ob_word != "":
					raw *= 1.0 + 0.20 * attacker.off_balance_ranks
					_log("   → Talent: Off Balance — +%d%% vs %s" % [
						20 * attacker.off_balance_ranks, ob_word], "#b0a8e0")
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
			# RUNAWAY RESONANCE, CLAUSE 2 (target side): the same compounding
			# curve at half the step, and NOTHING SOFTENS IT — Arcane Ward is
			# gone and Singularity no longer caps it. That is the whole bargain:
			# at five stacks he is WEAKER than he used to be, and by twelve he
			# has roughly doubled while taking +59%.
			if strike_target.second_resource_name == "Resonance":
				raw *= _resonance_taken_mult(strike_target)
			# Savage Presence (Ursus): the bear stands between the hunter and
			# harm — 10% less damage taken, scaled by the bond tier.
			if strike_target.is_hero and strike_target.passive_id == "pack":
				var sp_ursus := _bond_mult(strike_target, "ursus")
				if sp_ursus > 0.0:
					var pv_was := raw
					raw *= 1.0 - 0.10 * sp_ursus
					_prev(strike_target, pv_was - raw)
			# Stabilized: grounded resonance blunts incoming blows.
			if strike_target.has_status("stabilized"):
				var pv_was := raw
				raw *= 1.0 - strike_target.status_power("stabilized") / 100.0
				if strike_target.is_hero:
					_prev(strike_target, pv_was - raw)
			# Consecrated Ground: holy footing blunts the blow.
			if strike_target.has_status("cons_ground"):
				var pv_was := raw
				raw *= 0.85
				if strike_target.is_hero:
					_prev(_living_devout(), pv_was - raw)
			# Conviction: each Faith stack turns the blade (3%) — while the
			# Devout stands.
			if strike_target.is_hero and strike_target.faith_stacks > 0 \
					and _living_devout() != null:
				var pv_was := raw
				raw *= 1.0 - 0.03 * strike_target.faith_stacks
				_prev(_living_devout(), pv_was - raw)
			# Iron Will: adversity hardens the Warden — 12%/rank less damage
			# taken per debuff on him (the chip tracks the live total; the
			# floor is a sanity clamp for absurd debuff piles).
			if strike_target.iron_will_ranks > 0:
				var iw_n := strike_target.count_debuffs()
				if iw_n > 0:
					var iw_pct := 12 * strike_target.iron_will_ranks * iw_n
					var pv_was := raw
					raw *= maxf(1.0 - 0.01 * iw_pct, 0.1)
					_prev(strike_target, pv_was - raw)
					_log("   → Talent: Iron Will — -%d%% (%d debuffs)" % [
						iw_pct, iw_n], "#b0a8e0")
			# Shared Vigil (WARDEN, Banner row 6): the line holds while he
			# stands tall — allies take less while he is above half health.
			# NAME COLLISION, FLAGGED NOT SILENT: Batch AV gave the Holy
			# Cleric a Vigil row-5 node of the SAME NAME and the opposite
			# trigger (below, holy_vigil_pct). They are separate counters on
			# separate specs and stack cleanly; only the label is shared, and
			# renaming one is the designer's call, not the batch's.
			# The Rune of the Standard carries its own advertised 3% in a
			# SEPARATE term (Batch AL, same reason as Grudge above), so the
			# search cannot use _living_hero_with — that helper reads its
			# field as an int, and a rune-only Warden would be invisible to
			# it. Scanned here so EITHER half finds him.
			if strike_target.is_hero and not strike_target.is_companion:
				var sv_w: BattleUnit = null
				for sv_h in heroes:
					if not sv_h.dead and not sv_h.is_companion \
							and (sv_h.shared_vigil_ranks > 0
							or sv_h.rune_vigil_bonus > 0.0):
						sv_w = sv_h
						break
				if sv_w != null and sv_w != strike_target \
						and sv_w.hp > sv_w.max_hp * 0.5:
					var sv_cut := 0.12 * sv_w.shared_vigil_ranks \
						+ sv_w.rune_vigil_bonus
					var pv_was := raw
					raw *= 1.0 - sv_cut
					_prev(sv_w, pv_was - raw)
					_log("   → Talent: Shared Vigil — %s is covered (-%d%%)" % [
						strike_target.unit_name,
						int(round(sv_cut * 100.0))], "#b0a8e0")
			# HOUR OF NEED (HOLY, Vigil row 5, Batch AV; RENAMED FROM SHARED
			# VIGIL BY BATCH AW §9 — the Warden above had the name first and
			# his trigger fits it, so hers moved. Label only: the counter
			# `holy_vigil_pct` and this read site are unchanged): the party
			# closes ranks while ANYONE is at death's door — the mirror image
			# of the Warden's above. Deliberately NOT gated on the Cleric's own
			# health: she is the one keeping the party out of the window it
			# reads. The struck hero counts as "any hero", so a lone
			# survivor below the line still gets it.
			if strike_target.is_hero and not strike_target.is_companion:
				var hv_c := _living_hero_with("holy_vigil_pct")
				if hv_c != null and _any_hero_below(HOLY_VIGIL_AT):
					var pv_was := raw
					raw *= 1.0 - 0.01 * hv_c.holy_vigil_pct
					_prev(hv_c, pv_was - raw)
					_log("   → Talent: Hour of Need — the party closes ranks around %s (-%d%%)" % [
						strike_target.unit_name, hv_c.holy_vigil_pct], "#b0a8e0")
			# Ruin: the Old Gods' mark cracks the target open (+2%/stack;
			# Deeper Hex widens every crack to 5%).
			#
			# LEFT UNCAPPED DELIBERATELY (Batch AX §1). Against stacks that no
			# longer clear this is a multiplier on a number with no ceiling —
			# at twenty stacks Deeper Hex is +100% damage taken — and that IS
			# the intended payoff of a long boss fight. It is the first thing
			# to check if a boss row comes back absurd.
			if not strike_target.is_hero and strike_target.has_status("ruin"):
				var ruin_occ := _living_occultist()
				if ruin_occ != null:
					raw *= 1.0 + 0.01 * (2 + ruin_occ.deep_hex_step) \
						* strike_target.status_stacks("ruin")
			# Shielded: the Orc Shieldmaster's single-ally ward.
			if strike_target.has_status("shielded"):
				raw *= 0.75
			if strike_target.has_status("exposed"):
				raw *= 1.15
			# High Guard: hardened stance after a parry.
			if strike_target.has_status("high_guard"):
				var pv_was := raw
				raw *= 0.60
				if strike_target.is_hero:
					_prev(strike_target, pv_was - raw)
			# Guardian's Roar: the bear weathers the storm.
			if strike_target.has_status("roar"):
				var pv_was := raw
				raw *= 0.75
				if strike_target.is_hero:
					_prev(strike_target, pv_was - raw)
			# Reckless Fury raises this, Measured Rage lowers it. THE ONE read
			# site for measured_cancels_reckless: taking both nodes has to
			# land on exactly zero, not on the sum of one node's -20% and the
			# other's +15%, so the flag zeroes the term outright rather than
			# adding a third number to it.
			# (The guard here used to be `> 0.0`, which silently ate every
			# negative value — Measured Rage has been inert since Batch AI
			# gave it a payload of its own. Fixed in the batch that
			# re-authors the node.)
			var dtb := strike_target.dmg_taken_bonus
			if strike_target.measured_cancels_reckless > 0:
				dtb = 0.0
			if dtb != 0.0:
				var dtb_was := raw
				raw *= 1.0 + dtb
				if raw < dtb_was and strike_target.is_hero:
					_prev(strike_target, dtb_was - raw)
			# Seasoned Fighter: the guard decides what gets through — Defensive
			# turns blows aside (talent-deepened), Aggressive leaves openings.
			if strike_target.passive_id == "seasoned":
				var pv_was := raw
				raw *= 1.10 if strike_target.stance == "aggressive" \
					else (0.85 - strike_target.seasoned_def_bonus)
				if raw < pv_was:
					_prev(strike_target, pv_was - raw)
			# Molten Core: burning attackers bite softer on the Pyromancer.
			if strike_target.molten_ranks > 0 and attacker.has_status("burn"):
				var pv_was := raw
				raw *= 1.0 - 0.02 * strike_target.molten_ranks
				_prev(strike_target, pv_was - raw)
			# GLACIAL HOLD, CLAUSE 3 — THE WINDOW. A held enemy takes +15%
			# damage from ALL sources (+30% with Killing Frost). This is the
			# clause that makes his denial a party resource: everyone wants to
			# pile onto the target he is holding.
			if _is_held(strike_target):
				raw *= _hold_window_mult()
			# Hypothermia (talent): the cold opens wounds wider. ADDITIVE — the
			# counter is percentage POINTS per stack.
			if not strike_target.is_hero and strike_target.has_status("chilled"):
				raw *= 1.0 + 0.01 * _max_hero_rank("hypothermia_ranks") \
					* strike_target.status_stacks("chilled")
			if debug_prints and attacker.second_resource_name == "Resonance":
				print("[DBG] %s attacks @%d stacks: base %d -> raw %.1f" % [
					attacker.unit_name, attacker.second_resource, ab.damage, raw])
			var resist := float(strike_target.resists.get(ab.dmg_type, 0.0))
			# Avatar of Flame: the Pyromancer's fire ignores fire RESISTANCE
			# (weaknesses — negative resists — still count in full).
			if ab.dmg_type == "fire" and attacker.avatar_flame > 0 and resist > 0.0:
				resist = 0.0
			# Rune of the White Flame (rune_resist_pierce, its ONLY read site):
			# a POSITIVE resistance is thinned by this fraction. Weaknesses are
			# untouched — the rune never shrinks a vulnerability.
			if attacker.rune_resist_pierce > 0.0 and resist > 0.0:
				resist = maxf(resist * (1.0 - attacker.rune_resist_pierce), 0.0)
				_log("   → Rune: the flame bites through resistance (-%d%% of it)" % \
					int(round(attacker.rune_resist_pierce * 100)), "#b0a8e0")
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
				pen += 0.09 * int(party_bleed / float(_crushing_step(attacker)))
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
			# (5 / 2.5 BD per stack, in place of a flat pressure value). THIS IS
			# THE AXIS THE PER-STACK DAMAGE TERMS LEFT INTACT — Cannoneer moves
			# Cannon's rate 5 -> 9 and is ADDITIVE (the counter is the increase).
			if ab.display_name == "Arcane Cannon":
				pr = int(round((5.0 + attacker.cannoneer_ranks) \
					* attacker.second_resource * pr_mult \
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
			# Pressure Point: the Breaker lane loads his opening Break blow.
			if attacker.pressure_point_ranks > 0 \
					and ab.display_name == "Pommel Strike":
				pr += 30 * attacker.pressure_point_ranks
				_log("   → Talent: Pressure Point — +%d BD" % (
					30 * attacker.pressure_point_ranks), "#b0a8e0")
			# Sunder Guard's ability hook: the node is pointed at Guard
			# Change (see the guard_change handler), and pays this second
			# time only if he also drew Shatterpoint from a pool.
			if attacker.sunder_guard_bd > 0 \
					and ab.display_name == "Shatterpoint":
				pr += attacker.sunder_guard_bd
				_log("   → Talent: Sunder Guard — +%d BD" % \
					attacker.sunder_guard_bd, "#b0a8e0")
			# Pressure Cooker: the trigger cracks the guard as well as the
			# flesh. It reads the CAPTURED flag, not the status, because
			# Detonation has already eaten the Burn by the time this runs.
			if det_target_burned and attacker.pressure_cooker > 0:
				pr += 25
				_log("   → Talent: Pressure Cooker — +25 BD", "#b0a8e0")
			# Broken Will: the Occultist grinds stability down harder.
			if attacker.broken_will_ranks > 0:
				pr = int(round(pr * (1.0 + 0.01 * attacker.broken_will_ranks)))
			# Breaker runes (rune_bd_bonus, its only read site): every blow
			# lands heavier on the meter.
			if attacker.rune_bd_bonus > 0.0 and pr > 0:
				pr = int(round(pr * (1.0 + attacker.rune_bd_bonus)))
				_log("   → Rune: +%d%% Break damage" % int(round(
					attacker.rune_bd_bonus * 100)), "#b0a8e0")
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
			# deep. BATCH AX §1 — THE DRAUGHT IS PER STACK (2% each, replacing
			# the flat 10%-while-any-Ruin), so it finally rewards the depth the
			# passive was ignoring. Soul Leech and Gluttony are its two dials.
			#
			# AND IT IS CAPPED AT 40% OF THE DAMAGE DEALT, whatever the stacks
			# and whatever the talents. The amplification above is allowed to
			# run away; this is not — per-stack lifesteal against stacks with
			# no ceiling would let the party heal more than it deals.
			if attacker.is_hero and not strike_target.is_hero and final > 0 \
					and strike_target.has_status("ruin") and not attacker.dead:
				var occ_leech := _living_occultist()
				if occ_leech != null:
					var leech_pct: float = minf(0.01
						* (2 + occ_leech.soul_leech_step + occ_leech.gluttony_ranks)
						* strike_target.status_stacks("ruin"), RUIN_LEECH_CAP)
					var rl_heal := maxi(int(round(final * leech_pct)), 1)
					var rl_got: int = attacker.heal_amount(rl_heal)
					attacker.float_text("+%d" % rl_got, Color(0.7, 0.4, 0.9))
					_stat_heal(occ_leech, rl_got)
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
							_stat_heal(occ_leech, sg_got)
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
						var ck_amt := maxi(int(round(final * 0.01 * mad_occ.cackling_ranks)), 1)
						for ck_h in heroes.filter(func(he): return not he.dead and not he.is_companion):
							var ck_got: int = ck_h.heal_amount(ck_amt, ck_h != mad_occ)
							ck_h.float_text("+%d" % ck_got, Color(0.7, 0.4, 0.9))
							_stat_heal(mad_occ, ck_got)
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
			# himself — 60%/rank of a blow that would leave them below 20%
			# health is absorbed instead (Pressure still lands on the struck
			# hero alone, like Unity). The mini(..., final - 1) below is what
			# keeps the struck hero taking at least 1: at 60% the absorb is
			# now large enough that the clamp does real work.
			if final > 1 and strike_target.is_hero \
					and not strike_target.is_companion:
				var sf_w := _living_hero_with("steadfast_ranks")
				if sf_w != null and sf_w != strike_target \
						and strike_target.hp - final < int(strike_target.max_hp * 0.20):
					var sf_part := mini(maxi(int(round(
						final * 0.60 * sf_w.steadfast_ranks)), 1), final - 1)
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
			if attacker.is_hero and not strike_target.is_hero and pr > 0:
				_stat_bd(attacker, pr)
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
					_stat_bd(attacker, 15)
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
			# BACKLASH (Batch AT): the Entropy lane's engine — being hit IS a
			# build action. It fires before On the Edge so a hit that crosses
			# the brink pays both, which is the lane working as designed.
			if strike_target.is_hero and not result.died \
					and strike_target.backlash_stacks > 0 \
					and strike_target.second_resource_name == "Resonance":
				_log("   → Talent: Backlash — %s turns the blow into Resonance" % \
					strike_target.unit_name, "#b0a8e0")
				_gain_resonance(strike_target, strike_target.backlash_stacks)
			# ON THE EDGE, and the ONE place the node and the rune are reconciled.
			# The node writes on_edge_threshold (a health PERCENTAGE, 35) and
			# on_edge_stacks (the payout, 4). The Rune of the Wide Current keeps
			# its own term `rune_on_edge_ranks` and reproduces the OLD formula
			# exactly — threshold 20 + 5/rank, one stack per rank — because a
			# threshold cannot be summed the way a magnitude can (35 + 25 = 60%
			# is not "both effects", it is a third effect neither one asked for).
			# THE THRESHOLD TAKES THE MAX; THE PAYOUT SUMS, so each half pays its
			# advertised number alone AND stacked (the AK/AL repair rule).
			var oe_rune_thr := (20.0 + 5.0 * strike_target.rune_on_edge_ranks) \
				if strike_target.rune_on_edge_ranks > 0 else 0.0
			var oe_thr := maxf(strike_target.on_edge_threshold, oe_rune_thr)
			var oe_gain := strike_target.on_edge_stacks + strike_target.rune_on_edge_ranks
			if strike_target.is_hero and not result.died and oe_gain > 0 \
					and strike_target.hp < strike_target.max_hp * 0.01 * oe_thr:
				_log("   → Talent: On the Edge — %s draws power from the brink" % \
					strike_target.unit_name, "#b0a8e0")
				_gain_resonance(strike_target, oe_gain)
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
				if cg_dv != null and cg_dv.righteous_step > 0:
					cg_pct += 0.01 * cg_dv.righteous_step
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
					var well := maxi(int(round(reflect * 0.01 * cg_dv.lifewell_ranks)), 1)
					for wh in heroes:
						if wh.dead or wh.is_companion:
							continue
						var well_got: int = wh.heal_amount(well, wh != cg_dv)
						wh.float_text("+%d" % well_got, Color(0.4, 0.9, 0.45))
						_stat_heal(cg_dv, well_got)
					_log("   → Talent: Lifewell — the reflected pain mends the party for %d" % \
						well, "#b0a8e0")
				# Judgement: the ground passes sentence on the attacker.
				if cg_dv != null and cg_dv.judgement > 0 and not attacker.dead:
					_apply_status(attacker, "sunder", 2)
					var jd_bd := maxi(int(round(final * 0.01 * cg_dv.judgement)), 1)
					var jd_result: Dictionary = attacker.take_hit(0, jd_bd)
					_stat_bd(cg_dv, jd_bd)
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
			# BATCH AT MADE IT CERTAIN, not a roll: temporal_ranks is the echo's
			# PERCENTAGE of the crit now, and the chance clause is gone. A coin
			# flip on top of a crit is variance stacked on variance, and the one
			# thing a compounding spec must not be is random.
			if is_crit and attacker.is_hero and attacker.temporal_ranks > 0:
				var rift_pool := enemies.filter(func(e): return not e.dead)
				if not rift_pool.is_empty():
					var rift_t: BattleUnit = rift_pool.pick_random()
					var rift_dmg := maxi(int(round(final * 0.01
						* attacker.temporal_ranks)), 1)
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
				# Cinder Trail (Batch AR): the free bolt carries more fire —
				# and more drain. It lengthens FIREBALL'S OWN Burn now; the
				# old "embers onto a second enemy" reading survives on the
				# Rune of the Cinder Trail, below.
				if ab.display_name == "Fireball" and attacker.cinder_trail_ranks > 0:
					turns += attacker.cinder_trail_ranks
				var status_meta := 0
				if ab.applies_status["id"] == "burn":
					status_meta = int(round((CRIT_CHANCE + attacker.crit_bonus) * 100))
				# Umbral Mirror: an enemy's debuff can rebound onto itself
				# (and the reflection is the Occultist's work — it feeds Ruin).
				var mirror_r := _max_hero_rank("mirror_ranks")
				if not attacker.is_hero and strike_target.is_hero and mirror_r > 0 \
						and BattleUnit.DEBUFF_IDS.has(ab.applies_status["id"]) \
						and randf() < 0.01 * mirror_r:
					_log("   → Talent: Umbral Mirror — the %s rebounds onto %s" % [
						ab.applies_status["id"].capitalize(), attacker.unit_name],
						"#b0a8e0")
					_apply_status(attacker, ab.applies_status["id"], turns, status_meta,
						_dot_tick(ab.applies_status["id"], attacker))
					_gain_ruin(attacker, 1)
				else:
					# Pommel Strike's perfect (Batch AH) is the Stun landing on an
					# unbroken boss — reliability where it was a parry buff.
					_apply_status(strike_target, ab.applies_status["id"], turns, status_meta,
						_dot_tick(ab.applies_status["id"], attacker), attacker,
						is_perfect and ab.display_name == "Pommel Strike")
					_note_debuff_applied(attacker, ab.applies_status["id"])
					# Deep Chill (Batch AS): Frostbolt lays TWO stacks, not one —
					# the free pump doubles, so the build is two casts instead of
					# four. The extra goes through the same door as the first, so
					# Rime, Frigid Grip and the freeze cascade all behave.
					if ab.display_name == "Frostbolt" and attacker.deep_chill_ranks > 0 \
							and not strike_target.dead:
						for _dc_i in attacker.deep_chill_ranks:
							if not strike_target.dead:
								_apply_status(strike_target, "chilled", 3, 0, 0, attacker)
					# Wrath of the Old Gods: the Occultist's debuffs mark Ruin.
					if attacker.passive_id == "old_gods" and not strike_target.is_hero \
							and BattleUnit.DEBUFF_IDS.has(ab.applies_status["id"]):
						_gain_ruin(strike_target, 1)
				# Empowered Hex: the curse can set the rot in.
				if ab.display_name == "Hex of Ruin" and attacker.emp_hex_ranks > 0 \
						and not strike_target.dead \
						and randf() < 0.01 * attacker.emp_hex_ranks:
					_apply_status(strike_target, "decay", 3)
					_gain_ruin(strike_target, 1)
					_log("   → Talent: Empowered Hex — Decay takes root in %s" % \
						strike_target.unit_name, "#b0a8e0")
			# Lunge: the stance decides the wound — Aggressive Exposes,
			# Defensive Cripples; Guard Change is how the player picks.
			# UPGRADED (the sm_lunge node landing on a Lunge he already
			# earned): both wounds, whatever guard he holds.
			if ab.display_name == "Lunge" and not strike_target.dead:
				var lunge_hits: Array = ["exposed", "cripple"] \
					if attacker.lunge_upgraded > 0 \
					else ["exposed" if attacker.stance == "aggressive" else "cripple"]
				for lunge_status in lunge_hits:
					_apply_status(strike_target, lunge_status, 3)
					_note_debuff_applied(attacker, lunge_status)
			# Crushing Blow (Warden talents): resist shred + BD splash.
			if ab.display_name == "Crushing Blow" and not strike_target.dead \
					and attacker.elem_weak_ranks > 0:
				var shred := 20 * attacker.elem_weak_ranks
				_apply_status(strike_target, "elem_weak", 3, shred)
				# The chip carries the talent-scaled number.
				strike_target.update_status("elem_weak", "-%d%%" % shred,
					"Elemental Weakness: all non-physical\nresistances reduced by %d%%." % shred,
					shred)
				_note_debuff_applied(attacker, "elem_weak")
			if ab.display_name == "Crushing Blow" and attacker.sundering_ranks > 0 \
					and attacker.is_hero:
				var splash_bd := int(round(pr * 1.00 * attacker.sundering_ranks))
				if splash_bd > 0:
					var neighbors := _adjacent_enemies(strike_target)
					for foe in neighbors:
						foe.take_hit(0, splash_bd)
						_stat_bd(attacker, splash_bd)
						foe.float_text("+%d BD" % splash_bd, Color(0.8, 0.5, 1.0))
					if not neighbors.is_empty():
						_log("   → Talent: Sundering — %d BD to the %d foe%s Adjacent to %s" % [
							splash_bd, neighbors.size(),
							"" if neighbors.size() == 1 else "s",
							strike_target.unit_name], "#b0a8e0")
			# A bleed spec's perfect pays in RELIABILITY, not magnitude: the
			# 50% roll is waived for the cast. Wildstrikes since Batch AG (all
			# four targets take the full 35), Hack and Slash since AH (all
			# three strikes land their 25 instead of buying a fourth strike).
			var bleed_roll := ab.bleed_chance
			if is_perfect and ab.display_name in ["Wildstrikes", "Hack and Slash"]:
				bleed_roll = 1.0
			# The dead-target check STAYS OUTSIDE the roll. It guarded the
			# `randf()` before Batch AQ split this block, and a draw taken one
			# extra time shifts every later roll in the battle — the cheapest
			# possible way to make an unrelated probabilistic test flap.
			if not strike_target.dead:
				var bleed_amount := 0
				if ab.bleed_build > 0 and randf() <= bleed_roll:
					bleed_amount = ab.bleed_build + attacker.bleed_bonus
				# Bloodletting (Batch AQ): THE one read site for mod_bleed_add.
				# Every hit opens a wound, so it does NOT ride the ability's
				# own bleed roll — it is added alongside whatever that roll
				# gave. Gated on `damage`, because a hit that lands none is not
				# a wound. Bleedout still triggers at 100 by the existing rule,
				# inside _add_bleed_with_burst.
				if ab.damage > 0:
					bleed_amount += attacker.mod_bleed_add
				if bleed_amount > 0:
					_add_bleed_with_burst(strike_target, bleed_amount)
			if ab.display_name == "Mocking Blow" and not strike_target.dead:
				var mocker_idx := heroes.find(attacker)
				if mocker_idx >= 0:
					var taunt_turns := 5 if is_perfect else 4
					_apply_status(strike_target, "mocked", taunt_turns, mocker_idx)
					_note_debuff_applied(attacker, "mocked")
					# Provoke widens the net: +2 taunted foes per rank on top
					# of the one the base ability already drags in.
					var others := enemies.filter(
						func(e): return not e.dead and e != strike_target)
					others.shuffle()
					var taunt_extra := mini(1 + 2 * attacker.provoke_ranks,
						others.size())
					for oi in taunt_extra:
						_apply_status(others[oi], "mocked", taunt_turns, mocker_idx)
					if attacker.provoke_ranks > 0 and taunt_extra > 1:
						_log("   → Talent: Provoke — the taunt drags in %d more foes" % \
							taunt_extra, "#b0a8e0")
				# Tank and Spank: the taunt Empowers a random ally — ALWAYS
				# since Batch AL. Mocking Blow is free and on his rotation
				# constantly, so a chance roll here read as noise rather than
				# tension; nothing was ever planned around it.
				if attacker.tank_spank_ranks > 0:
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
			# Immolate: whoever strikes the burning Pyromancer ignites — and
			# that fresh Burn feeds his own engine, drain and all.
			if strike_target.has_status("immolate") and not attacker.is_hero \
					and not attacker.dead:
				_apply_status(attacker, "burn", 3,
					int(round((CRIT_CHANCE + strike_target.crit_bonus) * 100)),
					_dot_tick("burn", strike_target))
			# Spite (Warden talent): laying hands on him costs — attackers
			# take 30%/rank of the damage they dealt straight back.
			# CROSS-ROW (Batch AL): Spite and Bruising Guard used to be an
			# exclusive fork. In separate rows both are reachable, and taking
			# the second welds them into ONE Break engine — the reflect
			# carries Break equal to half its damage. `spite_break` is the
			# rider's only read site.
			if strike_target.spite_ranks > 0 and final > 0 \
					and not attacker.is_hero and not attacker.dead \
					and attacker != strike_target:
				var spite_dmg := maxi(int(round(
					final * 0.30 * strike_target.spite_ranks)), 1)
				var spite_bd := 0
				if strike_target.spite_break > 0:
					spite_bd = maxi(int(round(spite_dmg * 0.5)), 1)
				var spite_res: Dictionary = attacker.take_hit(spite_dmg, spite_bd)
				attacker.float_text("-%d Spite" % spite_dmg, Color(0.9, 0.55, 0.4))
				_log("   → Talent: Spite — %s takes %d damage back" % [
					attacker.unit_name, spite_dmg], "#b0a8e0")
				if spite_bd > 0:
					_stat_bd(strike_target, spite_bd)
					attacker.float_text("+%d BD" % spite_bd, Color(0.8, 0.5, 1.0))
					_log("   → Talent: Bruising Guard — the spite carries %d Break damage" % \
						spite_bd, "#b0a8e0")
				if spite_res.died:
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % attacker.unit_name)
					_log("† %s dies" % attacker.unit_name, "#e05050")
					_on_enemy_death(attacker)
			# Pyromancer fire package (Batch N kit, re-authored by AR).
			if detonated > 0:
				_log("   → Detonation consumes %d turn%s of Burn (+%d bonus damage)" % [
					det_turns, "" if det_turns == 1 else "s", detonated],
					"#e08850")
			# THE REFUND. It belongs to Overburn, not to Detonation — the same
			# helper Wildfire calls — so anything the tree later teaches to eat
			# Burn inherits it without a second implementation.
			if det_turns > 0:
				_overburn_refund(attacker, det_turns)
			if is_perfect and ab.display_name == "Detonation" and not strike_target.dead:
				_apply_status(strike_target, "burn", 2,
					int(round((CRIT_CHANCE + attacker.crit_bonus) * 100)),
					_dot_tick("burn", attacker))
			# Aftershock: the trigger re-lights what it just emptied — and the
			# refund is what pays for the fire it starts again.
			if ab.display_name == "Detonation" and attacker.aftershock > 0 \
					and not strike_target.dead:
				_apply_status(strike_target, "burn", attacker.aftershock, 0,
					_dot_tick("burn", attacker))
				_log("   → Talent: Aftershock — the fire relights (%d turns)" % \
					attacker.aftershock, "#b0a8e0")
			if ab.display_name == "Flamewave" and not strike_target.dead:
				# Batch N ignite clause: the wave STARTS fires now — 2 turns
				# (3 perfect), and those already Burning gain the same as an
				# extension. Conflagration adds its turns to either path, and
				# the Rune of the Cinder Trail adds its own on top — the field
				# is an ADDITIVE TURN COUNT, so each pays what it advertises.
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
			# RUNE-ONLY since Batch AR: the Rune of the Cinder Trail was
			# RE-POINTED off cinder_trail_ranks (which the node took for a new
			# meaning) onto its own term, so it still pays the effect it
			# advertises — embers scattered onto a second victim — instead of
			# silently doing something else.
			if ab.display_name == "Fireball" and attacker.is_hero \
					and attacker.rune_cinder_ember > 0:
				var ct_pool: Array = enemies.filter(
					func(e): return not e.dead and e != strike_target)
				if not ct_pool.is_empty():
					var ct_t: BattleUnit = ct_pool.pick_random()
					_log("   → Rune: the Cinder Trail — embers drift onto %s" % \
						ct_t.unit_name, "#b0a8e0")
					_apply_status(ct_t, "burn", attacker.rune_cinder_ember, 0,
						_dot_tick("burn", attacker))
			# Blizzard: 1-2 stacks of Chilled settle on each victim.
			if ab.display_name == "Blizzard" and not strike_target.dead:
				# The perfect buys RELIABILITY, not magnitude (Batch AH): the
				# 1-2 roll is waived and every enemy takes the full 2.
				# Whiteout (Batch AS) replaces the 1-2 roll outright: the storm
				# lays a FLAT 3 on everything, which is three quarters of a freeze
				# across the whole field in one cast.
				var bliz_stacks: int = attacker.whiteout_ranks if attacker.whiteout_ranks > 0 \
					else (2 if is_perfect else randi_range(1, 2))
				for chill_i in bliz_stacks:
					if not strike_target.dead:
						_apply_status(strike_target, "chilled", 3, 0, 0, attacker)
				_note_debuff_applied(attacker, "chilled")
			# Icy Veins — NO NODE AND NO RUNE writes this (Batch AS): kept, gated
			# and reported. The charge is still cleared on every Lance so a stale
			# value could never linger if a later batch re-nodes it.
			if ab.display_name == "Ice Lance" and attacker.is_hero:
				attacker.icy_veins_charge = 0.0
				if result.died and attacker.icy_veins_ranks > 0:
					attacker.icy_veins_charge = 0.15 * attacker.icy_veins_ranks
					_log("   → Talent: Icy Veins — the next Ice Lance hits +%d%%" % \
						int(attacker.icy_veins_charge * 100), "#b0a8e0")
			# Honed Shards moved (Batch AS): it rides the RELEASE now, not the
			# crit, and fires from _hold_release — one implementation, so Shatter
			# and an evicted prison inherit it with no second copy.
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
					var nq_gain := 45 * attacker.no_quarter_ranks
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
			# is also a stun. Batch AK: Riposte answers with a free
			# OVERPOWER instead of a basic Strike, riding the recast
			# machinery Opportunist already used — and Opportunist now
			# answers a parry as well as a whiff. They are the SAME answer
			# bought from two different lanes, so a parry fires ONE
			# counter; the log names the node that paid for it.
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
				elif strike_target.counter_attacks or strike_target.opportunist > 0:
					var rp_over := _find_ability(strike_target, "Overpower")
					if rp_over != null:
						_log("Talent: %s — %s answers the parry with Overpower!" % [
							"Riposte" if strike_target.counter_attacks \
							else "Opportunist", strike_target.unit_name], "#50c8e0")
						await _wait(0.4)
						await _resolve(strike_target, _free_copy(rp_over), attacker,
							"good", true)
						if attacker.dead:
							break
			if (ab.random_hits > 0 or ab.multi_hits > 0) and total_hits > 1:
				await _wait(0.45)  # sequential strikes land distinctly
		# ---- GLACIAL HOLD: the NAMED RELEASES (Batch AS §1/§2) ----
		# Both sit AFTER the strike loop so every hit is paid on the pile the
		# hold was carrying. Ice Lance keeps its damage, its Break and its
		# always-crit against Frozen — which finally means something, because
		# the release is now a deliberate act with a payoff attached rather
		# than a spell that happens to like frozen targets.
		if ab.display_name == "Ice Lance" and attacker.is_hero and _is_held(target):
			_hold_release(target, "Ice Lance")
		if ab.display_name == "Shatter" and attacker.is_hero:
			for sh_t in _holds.duplicate():
				_hold_release(sh_t, "Shatter")
		# War Stomp: the tremor rallies the line — allies regain 10% resource
		# (20% on a perfect cast; the damage is a 75-Attack tank's, the
		# party refuel is the real payload).
		if ab.display_name == "War Stomp" and attacker.is_hero and not attacker.dead:
			# Rallying Cry's ABILITY RIDER (Batch AL): the node's body fires
			# at his turn now, and this is the extra it pays a Warden who
			# also owns the stomp.
			var stomp_pct := (0.20 if is_perfect else 0.10) \
				+ 0.20 * attacker.rallying_stomp_ranks
			if attacker.rallying_stomp_ranks > 0:
				_log("   → Talent: Rallying Cry — War Stomp's refuel deepens (+%d%%)" % (
					20 * attacker.rallying_stomp_ranks), "#b0a8e0")
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
		# Volatility: escalation's bill. It is a SET, not an add — the node says
		# Cannon's recoil "rises to 25%", so volatility_recoil IS the new
		# percentage and Cannon is the only ability it touches (Batch AT).
		if attacker.volatility_recoil > 0 and ab.display_name == "Arcane Cannon":
			recoil_pct = 0.01 * attacker.volatility_recoil
		# Magi's Wrath: spreading the storm dissipates its backlash.
		if ab.display_name == "Magi's Wrath":
			recoil_pct = maxf(recoil_pct - 0.03 * enemies_struck, 0.0)
		# Mirrorbound (Batch AQ): THE one read site for mod_recoil. It is added
		# AFTER Magi's Wrath's per-hit fade so the modifier's quarter is never
		# dissipated by an ability's own rule — the bargain says a quarter comes
		# back, and a quarter comes back. The backlash is paid through
		# take_tick_damage below, which is not a strike, so RECOIL CANNOT ITSELF
		# RECOIL; and a lethal one still passes through Ashes of Al'ar's guard
		# inside take_tick_damage exactly as a native recoil does.
		recoil_pct += attacker.mod_recoil
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
			# ADDITIVE — the counter is percentage POINTS of the recoil.
			# PERFECT CONVERSION (capstone) takes ALL of it: his self-harm stops
			# being harm, which is the natural end of the Entropy lane. It is
			# folded in here rather than given its own block so there is exactly
			# ONE place the recoil-into-Mana rate is decided.
			var fb_pct := 0.01 * attacker.feedback_ranks
			if attacker.perfect_conversion > 0:
				fb_pct = 1.0
			if fb_pct > 0.0 and attacker.resource_name == "Mana":
				var fb_mana := mini(int(round(recoil * fb_pct)),
					mini(attacker.resource, recoil))
				if fb_mana > 0:
					attacker.resource -= fb_mana
					recoil -= fb_mana
					attacker.float_text("-%d Mana" % fb_mana, Color(0.5, 0.7, 1.0))
					_log("   → Talent: %s — %d of the recoil paid as Mana" % [
						"Perfect Conversion" if attacker.perfect_conversion > 0 \
							else "Feedback Loop", fb_mana], "#b0a8e0")
			var recoil_died := attacker.take_tick_damage(recoil, "-%d Recoil" % recoil,
				Color(1.0, 0.4, 0.5))
			_log("   → %s recoils for %d" % [attacker.unit_name, recoil], "#e08850")
			if recoil_died:
				_stat("hero_deaths")
				_sfx("death", -4.0)
				_message("%s is consumed by their own power!" % attacker.unit_name)
				_log("† %s dies" % attacker.unit_name, "#e05050")
		# SIPHON (Batch AT): the Entropy lane's Mana income, and the reason
		# losing Stabilize does not starve him — he drinks Mana out of the
		# damage he deals instead of out of stacks he vents. ADDITIVE, the
		# counter is percentage POINTS of the damage dealt.
		if attacker.siphon_ranks > 0 and total_dealt > 0 \
				and attacker.resource_name == "Mana" and not attacker.dead:
			var sip := maxi(int(round(total_dealt * 0.01 * attacker.siphon_ranks)), 1)
			var sip_was := attacker.resource
			attacker.resource = mini(attacker.resource + sip, attacker.max_resource)
			var sip_got := attacker.resource - sip_was
			if sip_got > 0:
				attacker.float_text("+%d Mana" % sip_got, Color(0.5, 0.7, 1.0))
				attacker.refresh_bars()
				_log("   → Talent: Siphon — %s draws %d Mana from the wound" % [
					attacker.unit_name, sip_got], "#b0a8e0")
		if ab.lifesteal > 0.0 and total_dealt > 0 and not attacker.dead:
			var leech := int(total_dealt * ab.lifesteal * (1.5 if is_perfect else 1.0))
			attacker.heal_amount(leech)
			attacker.float_text("+%d" % leech, Color(0.4, 0.9, 0.45))
			_log("   → %s leeches %d HP" % [attacker.unit_name, leech], "#70d878")
		# Vampiric Rune (rune_lifesteal, its only read site): every damaging
		# strike drinks, on top of any ability lifesteal.
		if attacker.rune_lifesteal > 0.0 and total_dealt > 0 and not attacker.dead:
			var rl_leech := maxi(int(total_dealt * attacker.rune_lifesteal), 1)
			attacker.heal_amount(rl_leech)
			attacker.float_text("+%d" % rl_leech, Color(0.4, 0.9, 0.45))
			_log("   → Rune: %s drinks %d HP" % [attacker.unit_name, rl_leech], "#70d878")
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
						_stat_bd(attacker, 30)
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
					_stat_bd(trapper, 30)
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
			var leech_heal := maxi(int(round(total_dealt * 0.01 * chan_r)), 1)
			var chan_got: int = blessed.heal_amount(leech_heal)
			blessed.float_text("+%d" % chan_got, Color(0.7, 0.4, 0.9))
			_stat_heal(_living_hero_with("channeling_ranks"), chan_got)
			_log("   → Talent: Corrupted Channeling — %s heals %d" % [blessed.unit_name,
				chan_got], "#b0a8e0")
		# Resonance builds only on the Mage's own casts — parry counters don't
		# count (they made the Mage "start" battles with a stack).
		if not is_counter:
			# Charged Bolts (talent): there is no ceiling to sit at any more, so
			# it pays for the stacks he is HOLDING — 5% of max Mana per 4 stacks
			# (Batch AT). Checked BEFORE this cast's gain lands, so the number is
			# what he was carrying when he pressed the button.
			if attacker.second_resource_name == "Resonance" \
					and attacker.charged_bolts_ranks > 0 \
					and attacker.second_resource >= 4:
				var cb_mana := maxi(int(round(attacker.max_resource * 0.01
					* attacker.charged_bolts_ranks
					* float(attacker.second_resource / 4))), 1)
				attacker.resource = mini(attacker.resource + cb_mana,
					attacker.max_resource)
				attacker.float_text("+%d Mana" % cb_mana, Color(0.5, 0.7, 1.0))
				_log("   → Talent: Charged Bolts — %s recovers %d Mana" % [
					attacker.unit_name, cb_mana], "#b0a8e0")
			# THE BUILD RATE, and every Resonance-lane node that moves it. Base
			# is 1 per damaging cast, 2 on a crit; Attunement raises the crit
			# figure, Harmonics the free basic, Resonant Core the first cast of
			# each turn, Cascade every cast once he is 10 deep, and Critical
			# Mass pays out its third-crit trips HERE rather than mid-loop.
			#
			# CRIT BUILDING IS ADDITIVE AND THIS IS ITS ONLY READ SITE (Batch
			# AU §4): base 2, Attunement +1 = 3, Singularity +2 = 5 with both.
			# NOT the higher of the two, and never summed at a second site.
			var res_gain := (2 + attacker.attunement_crit
				+ attacker.singularity_crit_build) if any_crit else 1
			if ab.display_name == "Arcane Explosion" and attacker.harmonics_ranks > 0:
				res_gain += attacker.harmonics_ranks
			if attacker.resonant_core_ranks > 0 and not attacker.res_cast_this_turn:
				res_gain += attacker.resonant_core_ranks
			# CASCADE — the Resonance lane's thesis: the curve gets steeper the
			# higher it already is.
			if attacker.cascade_stacks > 0 and attacker.second_resource >= 10:
				res_gain += attacker.cascade_stacks
			if crit_mass_trips > 0 and attacker.critical_mass_stacks > 0:
				res_gain += crit_mass_trips * attacker.critical_mass_stacks
				_log("   → Talent: Critical Mass — the third crit detonates into Resonance",
					"#b0a8e0")
			if attacker.second_resource_name == "Resonance":
				attacker.res_cast_this_turn = true
			_gain_resonance(attacker, res_gain)
		# Rampage: a kill lets it surge onward — an immediate free recast on
		# another enemy. Batch AJ put a CAP on it: once per turn, or twice if
		# the capstone landed on an already-earned Rampage. It used to chain
		# for as long as the kills kept coming, which is a capstone with no
		# ceiling and nothing left for the upgrade path to buy.
		if ab.display_name == "Rampage" and attacker.is_hero and not attacker.dead \
				and target != null and target.dead and not battle_over \
				and attacker.rampage_chains < 1 + attacker.rampage_upgraded:
			attacker.rampage_chains += 1
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


# ---------- GLACIAL HOLD (Batch AS §1) — the Cryomancer's spine ----------
#
# ONE mechanic in three clauses, each with exactly one place that decides it.
#
#   PERMAFROST — Chilled stacks HE applies never expire. That clause lives in
#     _apply_status below (eff_turns = -1) and is unchanged since Batch O.
#   THE HOLD   — a Frozen enemy stays Frozen INDEFINITELY. It is released only
#     when he chooses to release it: Ice Lance, Shatter, or a freeze past his
#     hold limit (which evicts the OLDEST). NOTHING ELSE THAWS IT — not ally
#     damage, not his own Blizzard, not time. A released enemy comes back on 1
#     stack of Chilled, so the engine stays warm.
#   THE WINDOW — a held enemy takes +15% damage from ALL sources (+30% with
#     Killing Frost). Clauses 2 and 3 together are the design: the hold is
#     simultaneously denial and a party-wide damage window he opens and
#     closes, so his control is a team resource rather than a solo trick.
#
# A NAMED RELEASE WITH NO ACCIDENTAL THAWS IS A DELIBERATE CHOICE over the
# alternative (any single-target hit from him breaks it). The alternative is
# more physical and much less legible, and it makes his own Blizzard a
# liability. "The only way that enemy acts again is if the Cryomancer lets
# it" is the sentence this section exists to make true.
#
# THE SPINE CARRIES NO COST CLAUSE, unlike Overburn, and that is deliberate.
# His cost is tempo: every turn spent building stacks is a turn not spent
# killing, and he can hold ONE enemy. Control should not be self-harm. If the
# hold proves too cheap the lever is stack-build rate, not a tax bolted on.
#
# BOSSES KEEP THEIR CARVE-OUT AND GET ONE MORE: they resist Frozen until
# Broken (the guard at the top of _apply_status), and a held boss releases on
# its own after one turn — it keeps its place on the timeline and spends that
# turn in the ice. A boss removed from the fight indefinitely is not a control
# fantasy, it is a softlock.
#
# `_holds` is the ONE answer to "is this enemy held", so the initiative bar,
# the damage window, Brittle Ice, Cold Snap, Cryoclasm and the bot all read
# the same list and cannot disagree.
const HOLD_WINDOW := 15         # +% damage a held enemy takes, from all sources
const HOLD_RELEASE_STACKS := 1  # what a released enemy comes back on
# SHATTER SCALES ON TIME HELD, NOT STACKS HELD (Batch AT §8). AS reported it
# never firing and correctly called that a design tension rather than a bot bug:
# Shatter (Thaw) and Absolute Zero (Deep Freeze) are both capstones and only one
# is takeable, so at a hold limit of one Shatter and Ice Lance did the same job
# and the Lance was cheaper. Charging on TURNS resolves it without touching
# either capstone — at three turns held it is worth less than Ice Lance's 35%
# plus its stack bonus, the crossover sits around turn four or five, and past
# that the Lance can never match it. THE HOLD STOPS BEING A BINARY STATE AND
# BECOMES A CHARGE, which is right for a spec whose currency is time.
const SHATTER_PER_TURN := 10    # % of Attack per turn a released enemy spent held
const SHATTER_TURN_CAP := 12    # and the ceiling on that count
# THE COUNTER BELONGS TO THE HELD ENEMY (BattleUnit.hold_turns) AND IS ADVANCED
# IN EXACTLY ONE PLACE — `_hold_sync`, walking `_holds`. It is deliberately NOT a
# dictionary parked beside `_holds`: that would be a second answer to "is this
# held" and the two could disagree. Because only `_hold_sync` writes it, and it
# only ever walks the ledger, a counter can never advance on an enemy that is not
# in a prison — and it advances ONCE PER TURN, not once per unit per turn.


func _is_held(u: BattleUnit) -> bool:
	return _holds.has(u)


# What the HELD chip says. Written from the rules rather than restating them,
# so a rule change that forgets this line shows up as a lie on screen.
func _hold_tooltip(timed: bool) -> String:
	var out := "HELD by Glacial Hold: off the turn order entirely,\n"
	out += "and takes +%d%% damage from EVERY source.\n" % (
		HOLD_WINDOW + _max_hero_rank("killing_frost"))
	if timed:
		out += "A boss shrugs the ice off after one turn."
	else:
		out += "It thaws only when the Cryomancer lets it:\n"
		out += "Ice Lance, Shatter, or a new freeze past his limit.\n"
		out += "Ally damage, his own Blizzard and time do NOTHING.\n"
		# Batch AT §8: the chip counts, so the tooltip has to say what the
		# count BUYS — otherwise the number on the nameplate is decoration.
		out += "The number is TURNS HELD: Shatter pays %d%% of\n" % SHATTER_PER_TURN
		out += "Attack per turn on release (max %d)." % SHATTER_TURN_CAP
	return out


# ONE enemy, TWO with Second Prison, ANY number under Absolute Zero.
func _hold_limit() -> int:
	if _living_hero_with("absolute_zero") != null:
		return 99
	return 2 if _living_hero_with("second_prison") != null else 1


# Clause 3, and the ONE place the window's size is decided.
func _hold_window_mult() -> float:
	return 1.0 + (HOLD_WINDOW + _max_hero_rank("killing_frost")) * 0.01


# THE ONE PLACE A HOLD BEGINS. Two callers: the Chilled-4 branch of
# _apply_status, and Glacial Prison (which skips straight to it).
func _hold_freeze(target: BattleUnit, src: BattleUnit) -> void:
	if target.dead or target.has_status("frozen"):
		return
	# No Cryomancer standing — or the victim is a HERO, which Hoarfrost plus
	# an enemy chill can reach — means an ORDINARY freeze, not a hold. A held
	# hero would be a softlock wearing the spec's clothes.
	var cryo := _living_hero_passive("permafrost")
	var holding := cryo != null and not target.is_hero
	# The boss carve-out: one turn of ice, then it acts again on its own.
	var timed := target.is_boss or not holding
	_apply_status(target, "frozen", 1 if timed else -1)
	if not target.has_status("frozen"):
		return                      # boss immunity bounced it; the stacks sit
	target.was_frozen = true
	if not holding:
		target.set_chilled_stacks(1)
		_log("   → %s FREEZES SOLID (4 stacks of Chilled)" % target.unit_name,
			"#7cc8f0")
		return
	_holds.append(target)
	# A fresh prison starts on a fresh charge (Batch AT §8) — an enemy released
	# and re-frozen has not been held for the sum of both stints.
	target.hold_turns = 0
	# The pile stays MAXED while he holds it — the ember belongs to the
	# release, not to the freeze (Absolute Zero's old "keeps all 4" clause is
	# redundant under an indefinite hold, which is why it was re-specced).
	target.set_chilled_stacks(4)
	if not timed:
		# Off the timeline entirely: it is not going to act, and §4's empty
		# slot in the turn bar is this line made visible.
		target.next_time = INF
	_log("   → %s is HELD in the ice — only the Cryomancer can release it" % \
		target.unit_name, "#7cc8f0")
	target.float_text("HELD", Color(0.65, 0.88, 1.0))
	# §4's other half: the nameplate says HELD, not "Fz", and the tooltip
	# names every door out. A player who cannot see why an enemy stopped
	# taking turns is being shown a bug, not a mechanic.
	var hold_st := target.get_status("frozen")
	if not hold_st.is_empty():
		hold_st["label"] = "HELD"
	target.update_status("frozen", "HELD", _hold_tooltip(timed))
	_hold_freeze_riders(target, cryo)
	# Over the limit: the OLDEST prison gives out. This is a RELEASE, so it
	# pays out through _hold_release like every other one — Shattered Tempo
	# and Honed Shards fire on it too.
	while _holds.size() > _hold_limit():
		_hold_release(_holds[0], "the oldest prison gives out")


# What rides a freeze: the Mana it pays back and the cold it rolls outward.
func _hold_freeze_riders(target: BattleUnit, cryo: BattleUnit) -> void:
	# Glacial Economy: every freeze pays its caster back in Mana.
	var gl_h := _living_hero_with("glacial_ranks")
	if gl_h != null and gl_h.resource_name == "Mana":
		var gl_mana := maxi(int(round(gl_h.max_resource * 0.01 * gl_h.glacial_ranks)), 1)
		gl_h.resource = mini(gl_h.resource + gl_mana, gl_h.max_resource)
		gl_h.float_text("+%d Mana" % gl_mana, Color(0.5, 0.7, 1.0))
		gl_h.refresh_bars()
		_log("   → Talent: Glacial Economy — the freeze returns %d Mana" % gl_mana,
			"#b0a8e0")
	# Bitter Cold: the freeze rolls outward — every OTHER enemy catches
	# stacks. One cascade at a time: a freeze the spread itself causes never
	# re-spreads (that way lies the ice age).
	var bc_h := _living_hero_with("bitter_cold_ranks")
	if bc_h != null and not _bitter_echoing:
		_bitter_echoing = true
		var bc_pool := enemies.filter(func(e): return not e.dead and e != target)
		if not bc_pool.is_empty():
			_log("   → Talent: Bitter Cold — the freeze rolls across the field",
				"#b0a8e0")
			for bc_e in bc_pool:
				for _bc_i in bc_h.bitter_cold_ranks:
					if not bc_e.dead:
						_apply_status(bc_e, "chilled", 3, 0, 0, bc_h)
		_bitter_echoing = false


# THE ONE PLACE A HOLD ENDS. Every caller names its reason in the log, because
# "why is that enemy moving again" must always have an answer on screen.
func _hold_release(target: BattleUnit, reason: String) -> void:
	if not _holds.has(target):
		return
	_holds.erase(target)
	target.remove_status("frozen")
	_log("   → %s is released from the ice — %s" % [target.unit_name, reason],
		"#7cc8f0")
	if target.dead:
		return
	target.set_chilled_stacks(HOLD_RELEASE_STACKS)
	if is_inf(target.next_time):
		# Back onto the timeline a full basic action from NOW — never
		# instantly, and never at the stale clock it was frozen on.
		target.next_time = _clock + BASIC_DELAY * 100.0 \
			/ maxf(target.effective_speed(), 0.1)
	# Shattered Tempo: the release is paid out in TIME rather than damage —
	# the purest thing in the tree. Same arithmetic as Ability.delay_push.
	var st := _hero_shattered_tempo()
	if st > 0.0:
		_log("   → Talent: Shattered Tempo — the shockwave sets the field back",
			"#b0a8e0")
		for e in enemies:
			if not e.dead and e != target and not _is_held(e):
				e.next_time += st * 100.0 / maxf(e.effective_speed(), 0.1)
	# Honed Shards LAST, because it can re-freeze the enemy it just thawed:
	# the release leaves the thawed target already deep in the cold.
	var hs := _max_hero_rank("honed_shards_ranks")
	if hs > 0 and not target.dead:
		var hs_h := _living_hero_with("honed_shards_ranks")
		_log("   → Talent: Honed Shards — the thaw leaves %d fresh stacks" % hs,
			"#b0a8e0")
		for _hs_i in hs:
			if not target.dead:
				_apply_status(target, "chilled", 3, 0, 0, hs_h)


# Shattered Tempo is the tree's only FLOAT counter, so it needs its own
# scanner: _max_hero_rank reads ints.
func _hero_shattered_tempo() -> float:
	var best := 0.0
	for h in heroes:
		if not h.dead:
			best = maxf(best, h.shattered_tempo)
	return best


# The ledger is authoritative, so it has to stay true. Called at the top of
# every turn, before anything reads it.
func _hold_sync() -> void:
	# The grip is his: if no Cryomancer stands, every prison opens. Nothing in
	# §1 says so, because §1 never contemplates him dying — but a dead hero
	# holding an enemy out of the fight forever is the softlock the boss
	# carve-out exists to refuse, arriving through a different door.
	if _living_hero_passive("permafrost") == null:
		for u in _holds.duplicate():
			_hold_release(u, "the Cryomancer's grip is gone")
		return
	for u in _holds.duplicate():
		if u.dead:
			_holds.erase(u)
		elif not u.has_status("frozen"):
			# The boss carve-out landing, or an enemy Cleansing Rite (which
			# cannot reach a hold — see _cleansable_debuffs — but a later
			# batch might add a door this catches).
			_hold_release(u, "the ice runs out")
		else:
			# THE CHARGE (Batch AT §8). One increment per turn per prison, at
			# the top of the turn, on the one pass that already walks the ledger.
			# The chip is rewritten with it, because a charge the player cannot
			# see is a decision they cannot make.
			u.hold_turns = mini(u.hold_turns + 1, SHATTER_TURN_CAP)
			u.update_status("frozen", "HELD %d" % u.hold_turns,
				_hold_tooltip(u.is_boss))


# `force` is the ONE way past the boss immunity, and it exists for exactly
# two callers: the Pommel Strike and Snare Trap perfects, whose whole
# payoff since Batch AH is that the Stun lands on an unbroken boss. It is
# an explicit argument rather than a name check inside here, so the
# exception stays visible at the call site that bought it.
func _apply_status(target: BattleUnit, id: String, turns: int, power := 0,
		tick := 0, src: BattleUnit = null, force := false) -> void:
	# Bosses shrug off Stuns, Freezes, and mind magic until Broken.
	if not force and id in ["stunned", "frozen", "psychosis", "bewitch", "hysteria"] \
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
	# Batch W: the debuffer's ledger — statuses a hero lands on OTHERS
	# (only sites that pass src are counted; the changelog owns the list).
	# The src name also rides the status so mitigation it later performs
	# (Interpose charges, barrier absorbs) can credit its caster.
	if src != null:
		if src.is_hero and target != src:
			var st_name := _contrib_name(src)
			if st_name != "" and st_name != "(unattributed)":
				_stat("st_hero_" + st_name)
		var st_stamp := target.get_status(id)
		if not st_stamp.is_empty():
			st_stamp["src_name"] = src.unit_name
	if id == "chilled":
		# Frigid Grip rides every stack: stamp the deeper slow on the victim.
		# ADDITIVE units — the counter is percentage POINTS, so the node's 10
		# and a rune's 3 each pay what they advertise, alone and stacked.
		target.frigid_bonus = 0.01 * _max_hero_rank("frigid_ranks")
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
		# them (a boss just keeps sitting on its stacks until Broken). What
		# the freeze BECOMES is _hold_freeze's decision, not this branch's.
		if target.status_stacks("chilled") >= 4 and not target.has_status("frozen"):
			_hold_freeze(target, src)
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


# Overburn's fuel (Batch AG, kept by AR): the TOTAL turns of Burn standing on
# the enemy team, not the number of enemies alight. One enemy burning for six
# turns feeds the passive exactly as hard as six burning for one.
func _total_burn_turns() -> int:
	var total := 0
	for foe in enemies:
		if foe.dead:
			continue
		var b: Dictionary = foe.get_status("burn")
		if not b.is_empty():
			total += maxi(int(b.get("turns", 0)), 0)
	return total


# OVERBURN, CLAUSE 2 — the reward, and THE ONE PLACE ITS CAP IS DECIDED.
# +2% damage per remaining Burn turn on the enemy team, capped at +40%.
#
# THE ASYMMETRY IS THE DESIGN: this caps and _overburn_drain() does not. Past
# 20 burn-turns the cost keeps climbing and the bonus stops, so over-lighting
# the field is how the Pyromancer loses. Nothing here may be made to scale
# with the drain and nothing there may be given a ceiling.
#
# Heat Shimmer lifts the cap to +60%; Immolate and Cauterise (under 20 Mana)
# LIFT IT ENTIRELY.
# Abilities that CONSUME Burn (Detonation, Wildfire, Cataclysm) pass the total
# they measured BEFORE their own consumption — the consuming cast is still
# paid for the field it emptied, and only later turns see the ash.
const OVERBURN_STEP := 2.0
const OVERBURN_CAP := 40.0


# The turn-start Mana drip, in ONE place — the drip itself reads it, and so
# does Ash Lung, whose whole condition is "the drain outruns the regen".
# Two sites asking the same question must not each carry their own 12.
func _mana_regen(u: BattleUnit) -> int:
	return 12 + u.mana_regen_bonus


func _overburn_capped(u: BattleUnit) -> bool:
	if u.has_status("immolate"):
		return false
	if u.cauterise > 0 and u.resource < 20:
		return false
	return true


func _overburn_mult(u: BattleUnit, burn_turns: int) -> float:
	if u == null or u.passive_id != "overburn":
		return 1.0
	var pct := burn_turns * OVERBURN_STEP
	if _overburn_capped(u):
		pct = minf(pct, OVERBURN_CAP + u.heat_haze_ranks)
	return 1.0 + 0.01 * pct


# OVERBURN, CLAUSE 1 — the cost, and THE ONE PLACE ITS SIZE IS DECIDED.
# 1 Mana per remaining Burn turn on the field, UNCAPPED. Fire Walker takes a
# quarter off it; Immolate doubles it.
func _overburn_drain(u: BattleUnit, burn_turns: int) -> int:
	if u == null or u.passive_id != "overburn":
		return 0
	var cost := float(maxi(burn_turns, 0))
	if u.fire_walker > 0:
		cost *= 0.75
	if u.has_status("immolate"):
		cost *= 2.0
	return int(round(cost))


# OVERBURN, CLAUSE 1 AT ITS READ SITE — the turn-start bill, called from
# _player_turn immediately after the regen drip. Returns true if the drain was
# LETHAL, which only Cauterise can make it. It lives here rather than inline so
# the clause has one name, one home, and something a test can drive without
# awaiting a player's ability pick.
#
# Kiln-Forged floors the bill at 10 Mana left and the rest simply evaporates;
# Cauterise instead bills whatever the pool could not cover to HEALTH, 1 HP per
# Mana. Taking BOTH is legal (same lane, different rows) and THE FLOOR WINS — a
# Pyromancer who paid for "the drain can never take me below 10" does not then
# get billed in blood for the same drain.
func _overburn_tick(u: BattleUnit) -> bool:
	if u == null or u.passive_id != "overburn":
		return false
	var turns := _total_burn_turns()
	var cost := _overburn_drain(u, turns)
	if cost <= 0:
		return false
	var floor_at: int = 10 if u.kiln_forged > 0 else 0
	var paid: int = mini(cost, maxi(u.resource - floor_at, 0))
	var unpaid: int = cost - paid
	u.resource -= paid
	u.refresh_bars()
	u.float_text("-%d Mana" % paid, Color(0.55, 0.6, 0.85))
	_log("%s: Overburn — %d turn%s of Burn drains %d Mana" % [
		u.unit_name, turns, "" if turns == 1 else "s", paid], "#e08850")
	# Cauterise: the health risk, put back ONCE as an opt-in. Only the part
	# the Mana pool could not cover is billed, and it goes through
	# take_tick_damage so a lethal drain is handled like any other tick.
	if unpaid > 0 and u.cauterise > 0 and u.kiln_forged == 0:
		_log("   → Talent: Cauterise — %d Mana of drain is paid in blood" % unpaid,
			"#b0a8e0")
		if u.take_tick_damage(unpaid, "-%d" % unpaid, Color(1.0, 0.4, 0.4)):
			_message("%s burns away!" % u.unit_name)
			_log("† %s falls to their own fire" % u.unit_name, "#e05050")
			return true
	return false


# OVERBURN, CLAUSE 3 — the refund, and THE ONE PLACE IT IS PAID. It is a
# property of the PASSIVE, not of any ability, so Detonation, Wildfire,
# Cataclysm and anything the tree adds later inherit it from this single
# implementation. Crucible doubles the rate.
func _overburn_refund(u: BattleUnit, turns_consumed: int) -> void:
	if u == null or u.passive_id != "overburn" or turns_consumed <= 0:
		return
	var rate := 2 if u.crucible > 0 else 1
	var back: int = mini(turns_consumed * rate, u.max_resource - u.resource)
	if back <= 0:
		return
	u.resource += back
	u.refresh_bars()
	u.float_text("+%d Mana" % back, Color(0.5, 0.7, 1.0))
	_log("   → Overburn: %d turn%s of Burn consumed refunds %d Mana" % [
		turns_consumed, "" if turns_consumed == 1 else "s", back], "#70a0e0")


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


# RUNAWAY RESONANCE (Batch AT), CLAUSE 1: NO CEILING, and nothing removes it.
# It builds 1 per damaging cast and 2 on a crit, it persists to the end of the
# battle, and `second_max` is a sentinel 99 nothing is meant to reach.
#
# DELETED WITH THEIR PREMISE, not left unreachable: UNLIMITED POWER (overflow AT
# a cap) and BACKLASH WARD (+15 Mana on every gain at the cap). Both existed
# only to answer "what happens when the ramp runs out of room", and the answer
# now is that it never does. The one thing that still takes stacks away is an
# EARNED Stabilize — a deliberate exception a player buys out of the spec pool.
func _gain_resonance(caster: BattleUnit, stacks: int) -> void:
	if caster.second_resource_name != "Resonance":
		return
	var before := caster.second_resource
	caster.second_resource = mini(caster.second_resource + stacks, caster.second_max)
	var gained := caster.second_resource - before
	if gained > 0:
		caster.float_text("+%d Resonance" % gained, Color(0.8, 0.5, 1.0))
		# Mana Attunement — NO NODE AND NO RUNE writes this (Batch AT): Siphon
		# took its lane slot. Kept, gated and reported rather than deleted, the
		# AR vault pattern, so a later batch can re-node or remove it on purpose.
		if caster.mana_attune_ranks > 0:
			var att_mana := int(round(caster.max_resource * 0.02
				* caster.mana_attune_ranks * gained))
			if att_mana > 0:
				caster.resource = mini(caster.resource + att_mana, caster.max_resource)
				caster.float_text("+%d Mana" % att_mana, Color(0.5, 0.7, 1.0))
				_log("   → Talent: Mana Attunement — %s sips %d Mana" % [
					caster.unit_name, att_mana], "#b0a8e0")
	caster.refresh_bars()


# THE TWO READ SITES OF THE COMPOUNDING CURVE. Both delegate to BattleUnit so
# the nameplate, the ability tooltip and the damage path can never disagree —
# there is exactly one implementation of N(N+1)/2 in the codebase.
func _resonance_dmg_mult(u: BattleUnit) -> float:
	return 1.0 + u.resonance_dmg_bonus()


func _resonance_taken_mult(u: BattleUnit) -> float:
	return 1.0 + u.resonance_taken_bonus()


# Mercy (Holy passive): +5% healing done per stack currently held. UNTOUCHED
# BY BATCH AV BY DESIGNER DECISION — Heavenly Aura writes the INCREASE on that
# 5 (7 makes it 12), Triage adds a flat percentage, and Sanctum a flat 60%.
# Costs are paid before the cast resolves, so a spender heals with what
# remains. ADDITIVE THROUGHOUT: every term below is percentage POINTS.
func _healing_done_mult(caster: BattleUnit) -> float:
	var m := 1.0
	if caster.second_resource_name == "Mercy":
		m += 0.01 * (5 + caster.heavenly_step) * caster.second_resource
	m += 0.01 * caster.triage_heal
	if caster.sanctum > 0:
		m += 0.60
	return m


# Triage: instant heals can CRIT (x1.5) off the Cleric's crit chance. A
# non-zero Triage term is what unlocks the crit — one counter, one gate, so a
# rune paying the healing half can never hand out crits the node did not.
func _heal_crit_mult(caster: BattleUnit) -> float:
	if caster.triage_heal > 0 and randf() < CRIT_CHANCE + caster.crit_bonus:
		return 1.5
	return 1.0


# THE ONE PLACE THE OVERFLOW SHARE IS DECIDED. Sanctum spills ALL of it, so
# the capstone and the Overflow node cannot disagree about the number and
# taking both is not a double spill.
func _overflow_share(caster: BattleUnit) -> int:
	if caster.sanctum > 0:
		return 100
	return caster.overflow_pct


# Holy Capacitor: bank a share of the overheal the last heal spilled; the
# next Heal releases the whole battery. RUNE-ONLY SINCE BATCH AV — the node
# became Martyrdom, and the Rune of the Triage Ward is the last writer. The
# read site is KEPT and gated (the AR vault pattern), never silently deleted,
# and it is FLAGGED FOR RE-AUTHORING.
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
	if caster.cascade_pct <= 0 or healed <= 0:
		return
	var cc_pool: Array = heroes.filter(
		func(h): return not h.dead and not h.is_companion and h != primary)
	if cc_pool.is_empty():
		return
	var cc_t: BattleUnit = _lowest_hp(cc_pool)
	if cc_t.hp >= cc_t.max_hp:
		return
	var cc_amt := int(round(healed * 0.01 * caster.cascade_pct))
	if cc_amt <= 0:
		return
	var cc_got: int = cc_t.heal_amount(cc_amt, cc_t != caster)
	cc_t.float_text("+%d" % cc_got, Color(0.95, 0.9, 0.6))
	_stat_heal(caster, cc_got)
	_vestments_ward(caster, cc_t, cc_got)
	_log("   → Talent: Radiant Cascade — the crit splashes %d onto %s" % [
		cc_got, cc_t.unit_name], "#b0a8e0")


# Overflow: a share of the overheal spills onto the lowest-health OTHER
# ally at once. Reads the same overheal Holy Capacitor banks from, at the
# same three sites (Heal, Hymn voices, Renewal's perfect burst).
func _overflow_spill(caster: BattleUnit, target: BattleUnit) -> void:
	if _overflow_share(caster) <= 0 or target.last_overheal <= 0:
		return
	var ov_pool: Array = heroes.filter(
		func(h): return not h.dead and not h.is_companion and h != target)
	if ov_pool.is_empty():
		return
	var ov_t: BattleUnit = _lowest_hp(ov_pool)
	if ov_t.hp >= ov_t.max_hp:
		return
	var ov_amt := int(round(target.last_overheal * 0.01 * _overflow_share(caster)))
	if ov_amt <= 0:
		return
	var ov_got: int = ov_t.heal_amount(ov_amt, ov_t != caster)
	ov_t.float_text("+%d" % ov_got, Color(0.95, 0.9, 0.6))
	_stat_heal(caster, ov_got)
	_vestments_ward(caster, ov_t, ov_got)
	_log("   → Talent: Overflow — %d overhealing spills onto %s" % [
		ov_got, ov_t.unit_name], "#b0a8e0")


# Blessed Vestments (Batch AV re-spec): her healing leaves cloth-of-light
# behind — a 2-turn barrier worth a share of what landed. Called from every
# site that credits HER with healing, so the ward follows the heal rather
# than one named ability. `barrier` power takes the MAX on re-application
# (unit.add_status), so a Renewal tick can never downgrade a Hymn's ward.
func _vestments_ward(caster: BattleUnit, target: BattleUnit, healed: int) -> void:
	if caster == null or target == null or caster.vestments_pct <= 0 or healed <= 0:
		return
	var bv_power := int(round(healed * 0.01 * caster.vestments_pct))
	if bv_power <= 0:
		return
	_apply_status(target, "barrier", 2, bv_power)
	var bv_stat := target.get_status("barrier")
	if not bv_stat.is_empty():
		bv_stat["src"] = caster.unit_name  # Batch W: absorbs credit the caster


# Grace (Batch AV): at maximum Mercy an ally's brush with death paid her
# nothing — the one place her reactive economy wasted what it earned. Now
# the stack she cannot hold becomes healing on the ally who earned it.
func _grace_spill(cleric: BattleUnit, low_ally: BattleUnit) -> void:
	if cleric.grace_pct <= 0 or low_ally == null or low_ally.dead:
		return
	var gr_amt := maxi(int(round(cleric.max_hp * 0.01 * cleric.grace_pct
		* _healing_done_mult(cleric))), 1)
	var gr_got: int = low_ally.heal_amount(gr_amt, low_ally != cleric)
	low_ally.float_text("+%d" % gr_got, Color(0.95, 0.9, 0.6))
	_stat_heal(cleric, gr_got)
	_vestments_ward(cleric, low_ally, gr_got)
	_log("   → Talent: Grace — the Mercy she cannot hold mends %s (+%d)" % [
		low_ally.unit_name, gr_got], "#b0a8e0")


# Intercession (Batch AV): THE ONE PLACE THE REFUSAL IS DECIDED. Asked by
# BattleUnit._holy_reversal and answered with a bool, because the price is
# paid ON TRIGGER, not on cast — a Cleric holding nothing gets nothing, and
# that has to be decided at the moment the blow lands rather than when the
# button was pressed. Spending it clears the window for the WHOLE party.
func _on_intercession_save(saved: BattleUnit) -> bool:
	var cleric := _mercy_holder()
	if cleric == null or cleric.second_resource < 1:
		_log("   → Intercession: the refusal goes unpaid — no Mercy in hand", "#909090")
		return false
	if not _sanctified_refund(cleric):
		cleric.second_resource -= 1
	cleric.refresh_bars()
	for h in heroes:
		h.remove_status("intercession")
	_log("   → Talent: Intercession — death is refused; %s survives at 1 HP (%s spends 1 Mercy)" % [
		saved.unit_name, cleric.unit_name], "#b0a8e0")
	return true


# Martyrdom (Batch AV capstone): the once-per-battle latch, spent for the
# whole party the moment it catches someone. The unit side has already put
# them back on their feet — this only reports and disarms.
func _on_martyrdom_return(saved: BattleUnit) -> void:
	for h in heroes:
		h.martyrdom_guard = false
	_log("   → Capstone: Martyrdom — %s is returned at %d%% health" % [
		saved.unit_name, int(round(BattleUnit.MARTYRDOM_RETURN * 100))], "#b0a8e0")


# The living hero whose second resource IS Mercy — the Holy Cleric. Her
# reversals are stamped party-wide, so every one of them has to be able to
# find her again from whoever the blow landed on.
func _mercy_holder() -> BattleUnit:
	for h in heroes:
		if not h.dead and not h.is_companion and h.second_resource_name == "Mercy":
			return h
	return null


# THE ONE PLACE THE SANCTIFIED ROLL HAPPENS. Three things spend Mercy — an
# ability's faith_cost, the Empower surcharge and an Intercession trigger —
# and before Batch AV the roll was written out twice with the third missing.
# Returns true when the stack is preserved.
func _sanctified_refund(cleric: BattleUnit) -> bool:
	if cleric.sanctified_pct <= 0 or randf() >= 0.01 * cleric.sanctified_pct:
		return false
	cleric.float_text("Mercy preserved", Color(0.95, 0.8, 0.3))
	return true


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
	bstat["src"] = devout.unit_name  # Batch W: absorbs credit the caster
	bstat["blessed_pct"] = 0.01 * devout.blessed_barrier_ranks
	bstat["afterglow"] = int(round(devout.max_hp * 0.01 * devout.afterglow_ranks))
	bstat["warded"] = 0.01 * devout.warded_ranks
	# Re-applying merges to the bigger power (add_status maxes), so the
	# re-form baseline is the pool as it stands, not this cast's power.
	bstat["original"] = int(bstat.get("power", power))
	bstat["unyielding_pct"] = 0.01 * devout.unyielding_ranks
	if devout.warded_ranks > 0:
		_log("   → Talent: Warded Robes — the shield hardens %s (+%d%% armor while it holds)" % [
			target.unit_name, devout.warded_ranks], "#b0a8e0")


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
				var mi_heal := maxi(int(round(occ.max_hp * 0.01 * mi_ranks)), 1)
				var mi_got: int = mi_t.heal_amount(mi_heal, mi_t != occ)
				mi_t.float_text("+%d" % mi_got, Color(0.7, 0.4, 0.9))
				_stat_heal(occ, mi_got)
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
			"healing_wave", "wild_growth", "totem_pulse", "cleanse_allies":
				return [a, _lowest_hp(living)]
			"enemy_shield":
				return [a, living.pick_random()]
	return []


# BATCH AX §6 — THE BOT WORKS ONE TARGET. Ruin detonates on multiples of ten
# and the stacks live on the enemy, so spreading the mark across a warband is
# how a build never sees its own payoff. The deepest mark wins; a field with no
# mark on it yet falls back to the generic pick, and an UNBROKEN BOSS outranks
# both, because Break is the gate on the other half of his kit.
func _ruin_focus(foes: Array, fallback: BattleUnit) -> BattleUnit:
	if foes.is_empty():
		return fallback
	for e in foes:
		if e.is_boss and not e.broken:
			return e
	var best: BattleUnit = fallback
	var best_r := 0
	for e in foes:
		var r: int = e.status_stacks("ruin")
		if r > best_r:
			best_r = r
			best = e
	return best


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
	var torment_turns := occ.torment_ranks
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


# BATCH AX §1 — RUIN HAS NO MAXIMUM AND NEVER CLEARS, and it detonates on
# EVERY TENTH STACK rather than at the fifth. The threshold is what Avatar of
# Ruin moves (to 5), so it lives in one function both the arming site and the
# chip text read.
const RUIN_THRESHOLD := 10

# §1's runaway guard. The per-stack lifesteal reads uncapped stacks, so without
# this the party would out-heal its own damage on a long boss. Soul Leech,
# Gluttony and Soul Glut all sit UNDER it.
const RUIN_LEECH_CAP := 0.40


func _ruin_threshold() -> int:
	var occ := _living_occultist()
	# `avatar_ruin` is the GATE AND THE MAGNITUDE in one field (AW's `judgement`
	# precedent): it holds the threshold the capstone installs.
	if occ != null and occ.avatar_ruin > 0:
		return occ.avatar_ruin
	return RUIN_THRESHOLD


# Wrath of the Old Gods: every Occultist-applied debuff marks its victim.
#
# THE ARMING TEST IS "DID A STACK LAND ON A MULTIPLE OF THE THRESHOLD", NOT
# "== 5". Stacks survive their detonations now, so an equality would arm once
# and never again — and a `>=` would arm on every stack after the first
# threshold. The modulo is the whole rule: 10, 20, 30 arm; 11 does not. Stacks
# are added ONE AT A TIME so a multi-stack gain can never step over a
# threshold without touching it.
func _gain_ruin(target: BattleUnit, n: int = 1) -> void:
	var occ := _living_occultist()
	if occ == null or target.is_hero or target.dead:
		return
	var step := _ruin_threshold()
	for i in n:
		_apply_status(target, "ruin", -1, 0, 0, occ)
		# `> 0` is load-bearing: _apply_status can REFUSE the mark (Hallowed
		# bounces every debuff), and 0 % anything is 0 — a refused stack would
		# otherwise arm the bomb.
		var st := target.status_stacks("ruin")
		if st > 0 and st % step == 0 and not target.has_status("ruin_primed"):
			_apply_status(target, "ruin_primed", 1)
			_log("   → The Old Gods take notice — %s's Ruin is PRIMED (%d stacks)" % [
				target.unit_name, st], "#c060d0")
	_stamp_ruin_chip(target)
	# BATCH AX §0 — THE SECOND NEW NUMBER: how deep the mark actually gets now
	# that it has no ceiling. Banked at the gain site rather than at battle end
	# because a target that DIES holding twenty stacks still measured twenty.
	if sim:
		var mk := "ruin_max_boss" if _boss_fight() else "ruin_max_trash"
		sim_stats[mk] = maxf(sim_stats.get(mk, 0.0),
			float(target.status_stacks("ruin")))


# Is this a boss fight? Read off the field rather than the encounter, so a
# mini-boss lineup and a zone boss both count and a driven test can set it.
func _boss_fight() -> bool:
	for e in enemies:
		if e.is_boss:
			return true
	return false


# The Ruin chip's own text. It lives here rather than in unit.add_status
# because every number in it moves with the Occultist's talents: Deeper Hex
# widens the per-stack bite and Avatar of Ruin halves the threshold.
func _stamp_ruin_chip(target: BattleUnit) -> void:
	var occ := _living_occultist()
	if occ == null or not target.has_status("ruin"):
		return
	var stacks := target.status_stacks("ruin")
	var step := _ruin_threshold()
	target.update_status("ruin", "R%d" % stacks,
		"Marked by the Old Gods: takes %d%% more\ndamage (%d%% per stack, never clears);\nheroes striking this unit heal. Ruin\ndetonates at %d stacks." % [
			(2 + occ.deep_hex_step) * stacks, 2 + occ.deep_hex_step,
			(int(stacks / step) + 1) * step])


# The primed Ruin detonates: shadow damage off the Occultist's Attack and
# a wave of stolen vitality for the party. Grim Focus deepens the blast and
# Unraveling seeds the mark in every other enemy.
#
# BATCH AX §1 — THE STACKS SURVIVE. Only the primer is consumed; the mark
# itself never washes off, so the +2%-per-stack amplification climbs for the
# whole battle and the next detonation waits for the next multiple of the
# threshold. It is bigger than it was (50% -> 90% of Attack, 15% -> 25% party
# heal) because it costs twice as long to earn — not quite double, because the
# persisting stacks are themselves new value.
func _detonate_ruin(target: BattleUnit) -> void:
	var occ := _living_occultist()
	target.remove_status("ruin_primed")
	if occ == null or target.dead:
		return
	var det_raw := 0.90 * occ.attack * randf_range(0.9, 1.1)
	# Grim Focus: the detonation strikes 80% harder.
	det_raw *= 1.0 + 0.01 * occ.grim_ranks
	var resist := float(target.resists.get("shadow", 0.0))
	var det_dmg := maxi(int(round(det_raw * (1.0 - resist))), 1)
	# BATCH AX §0 — THE FIRST OF TWO NEW NUMBERS, and §1 says to report it
	# rather than assume it: moving the threshold from the 5th stack to the 10th
	# largely takes his signature payoff OUT of ordinary fights, by construction.
	# Split trash vs boss because that split IS the design.
	_stat("ruin_detonations_boss" if _boss_fight() else "ruin_detonations_trash")
	_message("RUIN consumes %s!" % target.unit_name)
	var det_died := target.take_tick_damage(det_dmg, "-%d RUIN" % det_dmg,
		Color(0.8, 0.3, 0.9))
	_stat("dmg_hero_" + occ.unit_name, det_dmg)
	_log("%s: Wrath of the Old Gods — Ruin detonates on %s for %d shadow" % [
		occ.unit_name, target.unit_name, det_dmg], "#c060d0")
	for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
		var rw_heal := maxi(int(round(occ.max_hp * 0.25)), 1)
		var rw_got: int = h.heal_amount(rw_heal, h != occ)
		h.float_text("+%d" % rw_got, Color(0.7, 0.4, 0.9))
		_stat_heal(occ, rw_got)
	_log("   → the party feasts on the ruin (25% of the Occultist's health each)",
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
	# The mark endures. It is NOT re-primed here: the next blast waits for the
	# next multiple of the threshold, which is what _gain_ruin's modulo decides.
	if not target.dead:
		_stamp_ruin_chip(target)
		_log("   → the mark endures — %s still bears %d Ruin" % [target.unit_name,
			target.status_stacks("ruin")], "#b070d0")
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
			15 + devout.faithful_step]
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
			keep, 3 * keep, 2 * keep, 15 + devout.faithful_step]
		if not u.update_status("faith", "F%d" % keep, k_desc):
			u.add_status("faith", "Faith", "F%d" % keep,
				Color(0.98, 0.85, 0.45), -1, k_desc)
	else:
		u.remove_status("faith")
	var f_heal := maxi(int(round(u.max_hp * (0.15 + 0.01 * devout.faithful_step))), 1)
	var f_got: int = u.heal_amount(f_heal, u != devout)
	u.float_text("FAITH +%d" % f_got, Color(0.98, 0.85, 0.45))
	_stat_heal(devout, f_got)
	var d_mana := maxi(int(round(devout.max_resource * 0.03)), 1)
	devout.resource = mini(devout.resource + d_mana, devout.max_resource)
	devout.refresh_bars()
	_log("   → Conviction: %s's Faith overflows — healed %d; %s recovers %d Mana" % [
		u.unit_name, f_got, devout.unit_name, d_mana], "#e8c860")
	# Batch AW §1 — THE THIRD CLAUSE: the returns increase the principal. He
	# lends out his own bulk and collects a dividend on every release.
	_conviction_growth(devout)
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
			if randf() < 0.01 * devout.communion_ranks * h.faith_stacks:
				_log("   → Talent: Communion — %s's fervor spreads to %s" % [
					u.unit_name, h.unit_name], "#b0a8e0")
				_gain_faith(h, 1)
		_communion_chain = false


# BATCH AW §1 — CONVICTION'S THIRD CLAUSE, AND THE ONE PLACE THE DEVOUT'S
# MAXIMUM GROWS. Every Faith release raises it by 3% of his BASE maximum and
# heals him for the same amount, so the dividend arrives as usable health
# rather than an empty bar.
#
# "3% OF BASE" IS LOAD-BEARING AND IS NOT 3% OF CURRENT. The base is captured
# once, on the first release, and never re-read — so the growth is LINEAR
# (3% x N releases), never `1.03^N`. The loop still compounds THROUGH THE KIT
# (bigger maximum -> bigger shield -> more absorbs -> more Faith -> more
# releases), which is the design; what must not compound is the clause against
# itself, because Apostle turns releases into a stream.
#
# THE LANDMINE, AND IT IS EXACTLY WHY `rot` WAS DROPPED FROM BATCH AQ: the
# battle-end save sync writes each unit's max_hp straight back onto the party
# member, so a one-fight change would follow the party out of it and the Devout
# would grow permanently enormous one battle at a time with nothing crashing to
# announce it. `conviction_hp_gained` accumulates every point granted and BOTH
# victory syncs (battle.gd's own and RunSim's) subtract it before writing
# max_hp back, beside `tenacity_hp_gained`, with hp clamped under the restored
# maximum in the same step. DO NOT MERGE THE TWO FIELDS — but not for the
# reason the batch brief gives (it calls Tenacity's growth permanent; it has
# been excluded from the save sync since Batch W, exactly like this one). The
# real reason is that tenacity_hp_gained has a SECOND consumer: Unkillable's
# mend reads `max_hp - tenacity_hp_gained` as "the pool he brought into the
# battle", and that must mean TENACITY'S growth alone.
const CONVICTION_GROWTH_PCT := 0.03


func _conviction_growth(devout: BattleUnit) -> void:
	if devout.conviction_base_hp <= 0:
		devout.conviction_base_hp = devout.max_hp - devout.conviction_hp_gained
	var step := maxi(int(round(devout.conviction_base_hp * CONVICTION_GROWTH_PCT)), 1)
	devout.max_hp += step
	devout.conviction_hp_gained += step
	var grow_got: int = devout.heal_amount(step)
	devout.float_text("+%d MAX" % step, Color(0.98, 0.85, 0.45))
	devout.refresh_bars()
	_stat_heal(devout, grow_got)
	_log("   → Conviction: the principal grows — %s's maximum health rises %d (now %d)" % [
		devout.unit_name, step, devout.max_hp], "#e8c860")


# BATCH AW §2 — THE HOLY GROUND IS A FAITH SOURCE IN THE BASE KIT, and this is
# the whole of it. Faith had ONE real source and it sat on a 2-turn cooldown:
# one shield, one target, while Conviction's description promised a party-wide
# system. Fervor's effect MOVED HERE — every ally gains 1 Faith at the start of
# their turn while Consecrated Ground holds, WITH NO NODE REQUIRED — and the
# Fervor node now DEEPENS it instead (fervor_step = +1, so 2 per ally per turn).
#
# It is its own function rather than an inline block because the turn-start
# upkeep lives inside `_run_battle`, which cannot be driven headlessly (the AR
# trap: awaiting a turn awaits an ability pick that never arrives). A clause
# with a real gate in it has to be reachable by a test, or the negative control
# "Fervor is still required" can only ever be a grep.
func _ground_faith_tick(u: BattleUnit) -> void:
	if not u.is_hero or u.is_companion or u.dead:
		return
	if not u.has_status("cons_ground"):
		return
	var devout := _living_devout()
	if devout == null:
		return
	var gain := 1 + devout.fervor_step
	_log("   → Consecrated Ground kindles %s (+%d Faith)%s" % [
		u.unit_name, gain,
		" (Fervor)" if devout.fervor_step > 0 else ""], "#c8b880")
	_gain_faith(u, gain)


# Conviction: a Divine Shield soaking a hit steels its holder.
func _on_shield_absorbed(holder: BattleUnit) -> void:
	_gain_faith(holder, 1)


# Sacred Covenant: a Divine Shield that saved a life rewards its holder.
func _on_lethal_saved(saved: BattleUnit) -> void:
	var devout := _living_devout()
	if devout == null or devout.covenant_heal <= 0:
		return
	var cov_heal := maxi(int(round(saved.max_hp * 0.01 * devout.covenant_heal)), 1)
	var cov_got: int = saved.heal_amount(cov_heal, saved != devout)
	saved.float_text("+%d" % cov_got, Color(0.95, 0.9, 0.6))
	_stat_heal(devout, cov_got)
	_log("   → Talent: Sacred Covenant — the shield held the line; %s heals %d and keeps the Faith" % [
		saved.unit_name, cov_got], "#b0a8e0")
	_gain_faith(saved, maxi(devout.covenant_faith, 1))


# Mercy (Holy passive): an ally's brush with death steels the healer.
# Fired by unit.below_half_cb whenever a party member crosses below 50%
# (Guardian Angel widens the window to 65%). THE GENERATOR ITSELF IS
# UNTOUCHED BY BATCH AV — only the dead end at the ceiling is closed: Grace
# turns the stack she cannot hold into healing for the ally who earned it.
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
		else:
			_grace_spill(h, low_ally)


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
	# BATCH AV: Avatar of Mercy now GRANTS a stack instead of merely waiving
	# one, so an Empowered cast pays for itself and then some — the payoff for
	# a whole lane spent on the resource. Ardor's threshold is the counter
	# ITSELF now (3), not 5-minus-a-rank.
	if attacker.avatar_of_mercy > 0:
		if attacker.second_resource < attacker.second_max:
			attacker.second_resource += 1
			attacker.float_text("+1 Mercy", Color(0.95, 0.8, 0.3))
		_log("   → Capstone: Avatar of Mercy — the Empowerment costs nothing and GRANTS a stack (%d/%d)" % [
			attacker.second_resource, attacker.second_max], "#b0a8e0")
	elif attacker.ardor_at > 0 and attacker.second_resource >= attacker.ardor_at:
		attacker.float_text("Mercy preserved", Color(0.95, 0.8, 0.3))
		_log("   → Talent: Ardor — held Mercy carries the Empowerment; no stack is consumed", "#b0a8e0")
	# Sanctified (talent): the surcharge can be refunded too.
	elif _sanctified_refund(attacker):
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
# a free Overpower. The PARRY half of the node lives in _resolve's counter
# block instead, beside Riposte and Untouchable — a parried hit still lands,
# so its answer has to wait until the strike has fully resolved.
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
			# Batch W: absorbs credit the caster in the contribution ledger.
			var ab_stat := target.get_status("barrier")
			if not ab_stat.is_empty():
				ab_stat["src"] = attacker.unit_name
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
			var ds_pct := (0.35 if is_perfect else 0.30) + 0.01 * attacker.stalwart_step
			var shield := int(round(attacker.max_hp * ds_pct))
			_sfx("parry", -6.0, 0.6)
			_grant_divine_shield(attacker, target, shield)
			_message("%s shields %s (%d)" % [attacker.unit_name, target.unit_name, shield])
			_log("%s: Divine Shield on %s — absorbs %d (%d%% of the Devout's health%s)" % [
				attacker.unit_name, target.unit_name, shield,
				int(round(ds_pct * 100)),
				", Stalwart" if attacker.stalwart_step > 0 else ""], "#70d878")
			# Radient Aegis: the shield can echo onto another ally.
			if attacker.aegis_ranks > 0 and randf() < 0.01 * attacker.aegis_ranks:
				var aegis_pool := heroes.filter(
					func(h): return not h.dead and h != target and not h.is_companion)
				if not aegis_pool.is_empty():
					var aegis_t: BattleUnit = aegis_pool.pick_random()
					_grant_divine_shield(attacker, aegis_t, shield)
					aegis_t.float_text("Radient Aegis", Color(0.95, 0.9, 0.6))
					_log("   → Talent: Radient Aegis — the shield echoes onto %s" % \
						aegis_t.unit_name, "#b0a8e0")
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
			# NO EMPOWER (Batch AR). The vaulted def granted it, but since the
			# Holy Cleric's rework Empower is a SPECIFIC NAMED MECHANIC of her
			# Mercy system — an ability from another class handing it out was
			# a name collision, not a design. The clause is dropped, not
			# renamed: under Overburn a full Mana pool is already the relief
			# the drain denies him, and that is the whole ability.
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
			_stat_heal(attacker, base)
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
				_stat_heal(attacker, got)
				_bank_overheal(attacker, h)
				_overflow_spill(attacker, h)
				_vestments_ward(attacker, h, got)
				if h_crit > 1.0:
					_radiant_cascade(attacker, got, h)
			_message("%s sings the Hymn of Hope!" % attacker.unit_name)
			_log("%s: Hymn of Hope — party heals %d%%%s" % [attacker.unit_name,
				int(round(pct * 100)), " (Empowered)" if empowered else ""], "#70d878")
		"sanctuary":
			# VAULTED ability's machinery (kept): Mercy-scaled like all heals.
			# Batch AB: it used to hand out a Shieldwall v1 ward as well; that
			# status is gone with the fossil, so the vault keeps the heal only.
			var sanct_pct := (0.18 if is_perfect else 0.12) * _healing_done_mult(attacker)
			_sfx("heal", -4.0, 0.8)
			for h in heroes.filter(func(he): return not he.dead):
				var amt := int(h.max_hp * sanct_pct)
				h.heal_amount(amt, h != attacker)
				h.float_text("+%d" % amt, Color(0.4, 0.9, 0.45))
				_stat_heal(attacker, amt)
			_message("Sanctuary!")
			_log("%s: Sanctuary — party healed" % attacker.unit_name, "#70d878")
		"unity":
			# Sacred Resolve (talent ability). Healing Pulse and Cleansing
			# Waters are no longer snapshotted here — they read the living
			# Devout at the turn-start block, and key off EITHER banner
			# (this or Consecrated Ground) since Batch K.
			_sfx("heal", -5.0, 0.7)
			# Batch AW §5: the authored fallback for a hero who already EARNED
			# Sacred Resolve — its node pays a longer split instead of a
			# grant it cannot make (resolve_extra_turns, +2).
			var res_turns := (4 if is_perfect else 3) + attacker.resolve_extra_turns
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "unity", res_turns)
			_message("%s binds the party as one!" % attacker.unit_name)
			_log("%s: Sacred Resolve — the party's souls are bound (%d turns)" % [
				attacker.unit_name, res_turns], "#70d878")
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
					attacker.max_hp * 0.01 * attacker.purity_ranks)), 1)
				_grant_divine_shield(attacker, target, purity_pow)
				target.float_text("Purity %d" % purity_pow, Color(0.95, 0.9, 0.6))
				_log("   → Talent: Purity — the blessing carries a shield (%d)" % \
					purity_pow, "#b0a8e0")
		"bulwark":
			_sfx("parry", -5.0, 0.5)
			# Batch AW §5: the first CLERIC capstone that grants an ability and
			# therefore owes a fallback (Holy's three granted none; eight other
			# capstones across the roster already did — see talents.gd) —
			# already owned, it pays +1 turn instead.
			var bw_turns := 3 + attacker.bulwark_extra_turns
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				_apply_status(h, "bulwark", bw_turns)
				if is_perfect:
					var bw_heal := maxi(int(round(h.max_hp * 0.05)), 1)
					var bw_got: int = h.heal_amount(bw_heal, h != attacker)
					h.float_text("+%d" % bw_got, Color(0.4, 0.9, 0.45))
					_stat_heal(attacker, bw_got)
			_message("%s raises the BULWARK OF FORTITUDE!" % attacker.unit_name)
			_log("%s: Bulwark of Fortitude — no Break damage, armor +50%%, 10%% healing per turn (%d turns)" % [
				attacker.unit_name, bw_turns], "#8c9cc8")
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
			var pact_pct := maxf(0.20 - 0.01 * attacker.pact_flesh_ranks, 0.0)
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
			var pact_heal_pct := 0.15 + 0.01 * attacker.barter_step
			for h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				if h == attacker:
					continue
				var dp_amt := maxi(int(round(h.max_hp * pact_heal_pct)), 1)
				var dp_hgot: int = h.heal_amount(dp_amt, true)
				h.float_text("+%d" % dp_hgot, Color(0.7, 0.4, 0.9))
				_stat_heal(attacker, dp_hgot)
			if attacker.barter_step > 0:
				_log("   → Talent: Dark Barter — the party drinks %d%% (up from 15%%)" % \
					int(round(pact_heal_pct * 100)), "#b0a8e0")
			# The Occultist knits back together over 3 turns (10%/turn).
			var pact_tick := maxi(int(round(attacker.max_hp * 0.10)), 1)
			_apply_status(attacker, "renewal", 3, 0, pact_tick, attacker)
			attacker.update_status("renewal", "R+",
				"Dark Pact: restores %d HP at the start\nof each turn (10%% of max health)." % pact_tick)
			# Invigoration (talent): the pact also drips Mana back.
			if attacker.invigoration_ranks > 0:
				var invig_tick := maxi(int(round(attacker.max_resource
					* 0.01 * attacker.invigoration_ranks)), 1)
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
			# Batch AH: Deadfall gained a skill check, and its perfect buys
			# the one thing the trap never gave you — a say in WHO it takes.
			# The pick happens after the check, because "you got a perfect,
			# now choose" is the whole point; cancelling just leaves the
			# trap untargeted, which is its ordinary behaviour anyway.
			if is_perfect and not autoplay:
				var df_pool := enemies.filter(func(e): return not e.dead)
				var df_aim: BattleUnit = null
				if df_pool.size() == 1:
					df_aim = df_pool[0]
				elif df_pool.size() > 1:
					_message("Name the one the deadfall takes")
					df_aim = await _pick_target(df_pool)
				if df_aim != null:
					attacker.deadfall_aims.append(enemies.find(df_aim))
					df_aim.float_text("MARKED", Color(0.75, 0.65, 0.30))
					_log("   → the deadfall is rigged for %s alone" % \
						df_aim.unit_name, "#c8a860")
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
			# Batch AG: a real warcry — a flat base for the WHOLE party, with
			# the enemy party's bloodloss on top. Companions don't hear it.
			# THE ONE read site for `battle_shout_node` (Batch AJ): 0 = he
			# earned the shout from a pick and never took the node, 1 = the
			# node granted it, 2 = the node upgraded an earned copy.
			var shout_base: int = [8, 12, 18][clampi(attacker.battle_shout_node, 0, 2)]
			var shout_turns: int = [2, 3, 4][clampi(attacker.battle_shout_node, 0, 2)]
			var shout_bleed := 0
			for e in enemies:
				if not e.dead:
					shout_bleed += e.bleed_buildup
			var shout_pct := shout_base + int(shout_bleed / 20.0)
			_sfx("crit", -8.0, 0.7)
			# The chip shows the damage gained at the moment of the shout.
			var shout_desc := "Battle Shout: +%d%% damage for %d turns\n(+%d%% base, plus 1%% per 20 of the %d\nblood buildup on the enemy party at\nthe time of the shout)." % [
				shout_pct, shout_turns, shout_base, shout_bleed]
			var shout_n := 0
			for h in heroes:
				if h.dead:
					continue
				_apply_status(h, "battle_shout", shout_turns, shout_pct)
				h.update_status("battle_shout", "+%d%%" % shout_pct, shout_desc,
					shout_pct)
				shout_n += 1
			if is_perfect:
				attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
				attacker.float_text("+5 Rage", Color(1.0, 0.5, 0.4))
				attacker.refresh_bars()
			_message("%s roars with bloodlust!" % attacker.unit_name)
			_log("%s: Battle Shout — +%d%% damage for %d turns to %d %s" % [
				attacker.unit_name, shout_pct, shout_turns, shout_n,
				"hero" if shout_n == 1 else "heroes"], "#70d878")
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
				var tp_pct := 30 * attacker.tempo_ranks
				_apply_status(attacker, "tempo", 2, tp_pct)
				attacker.update_status("tempo", "+%d%%" % tp_pct,
					"Tempo: +%d%% damage for one turn\n(granted by switching stance)." % tp_pct,
					tp_pct)
				_log("   → Talent: Tempo — +%d%% damage for a turn" % tp_pct,
					"#b0a8e0")
			# The pivot presses the opening he already made: 15 BD to the
			# un-Broken enemy nearest to Breaking (auto-picked — the ability
			# takes no target, keeping autoplay await-free). SUNDER GUARD
			# re-points that node at THIS site (Batch AK): 40 BD, and to
			# EVERY living enemy rather than the single mark.
			var gc_wide := attacker.guard_change_bd > 0
			var gc_bd: int = attacker.guard_change_bd if gc_wide else 15
			var gc_marks: Array = []
			if gc_wide:
				gc_marks = enemies.filter(func(e): return not e.dead)
				if not gc_marks.is_empty():
					_log("   → Talent: Sunder Guard — the pivot sunders every guard (%d BD)" % \
						gc_bd, "#b0a8e0")
			else:
				var gc_mark: BattleUnit = null
				for e in enemies:
					if not e.dead and not e.broken \
							and (gc_mark == null or e.pressure > gc_mark.pressure):
						gc_mark = e
				if gc_mark != null:
					gc_marks = [gc_mark]
			var gc_bd_txt := ""
			for gc_hit in gc_marks:
				var gc_res: Dictionary = gc_hit.take_hit(0, gc_bd)
				_stat_bd(attacker, gc_bd)
				gc_hit.float_text("+%d BD" % int(gc_res["bd"]), Color(0.8, 0.35, 1.0))
				gc_bd_txt += "%s %d BD to %s" % [";" if gc_bd_txt == "" else ",",
					int(gc_res["bd"]), gc_hit.unit_name]
				if gc_res["broke"]:
					_stat("breaks_on_enemies")
					_sfx("break", -3.0)
					_message("%s BREAKS!" % gc_hit.unit_name)
					_log("!! %s BREAKS" % gc_hit.unit_name, "#c070e0")
					await _break_impact()
					# No Quarter pays on this Break too — the swap that lands
					# the final Break refunds its own Overpower.
					if attacker.no_quarter_ranks > 0:
						var gc_nq := 45 * attacker.no_quarter_ranks
						attacker.resource = mini(attacker.resource + gc_nq,
							attacker.max_resource)
						attacker.refresh_bars()
						attacker.float_text("+%d Rage" % gc_nq, Color(1.0, 0.5, 0.4))
						_log("   → Talent: No Quarter — the Break grants %s +%d Rage" % [
							attacker.unit_name, gc_nq], "#b0a8e0")
			# The perfect's parry spike. SWORDSMANSHIP (and the Still Wrist
			# rune, which pays into the same field) raises the GRANT itself
			# rather than adding a second number at the roll, so the chip's
			# live counter is exactly what _roll_parry reads.
			var gc_parry := 10 + int(round(attacker.swordsmanship_parry * 100.0))
			if is_perfect:
				if attacker.swordsmanship_parry > 0.0:
					_log("   → Talent: Swordsmanship — the perfect pivot buys +%d%% parry for 2 turns" % \
						gc_parry, "#b0a8e0")
				_apply_status(attacker, "parry_up", 2, gc_parry)
				attacker.update_status("parry_up", "+%d%%" % gc_parry,
					"+%d%% parry chance." % gc_parry, gc_parry)
			_message("%s shifts his guard — %s!" % [attacker.unit_name, gc_label])
			_log("%s: Guard Change — %s stance%s%s" % [attacker.unit_name,
				gc_label, gc_bd_txt,
				(" [PERFECT: +%d%% parry, 2 turns]" % gc_parry) if is_perfect \
				else ""], "#70d878")
		"shield_block":
			# Batch AB — Shieldwall is a STANCE, not a charge grant: it raises
			# his Block chance instead of bypassing the roll. He guarantees
			# safety for the line (Interpose) and gambles for himself. The
			# bonus rides the Heavy Plating slice of the roll, so the blocks
			# it buys wake Tenacity and Rally — the trade the ability is for.
			# Shield Mastery (the re-specced wd_shieldwall node) now buys
			# DURATION, the perfect cast included — 2 turns per rank.
			var wall_turns := (3 if is_perfect else 2) \
				+ 2 * attacker.shield_mastery_ranks
			_sfx("parry", -6.0, 0.5)
			_apply_status(attacker, "shieldwall", wall_turns, SHIELDWALL_BLOCK,
				0, attacker)
			# Live-total chip, in Heavy Plating's house style.
			attacker.update_status("shieldwall", "+%d%% Block" % SHIELDWALL_BLOCK,
				"Shieldwall: +%d%% Block chance for %d more turn(s).\nThese count as Heavy Plating blocks." % [
					SHIELDWALL_BLOCK, wall_turns], SHIELDWALL_BLOCK)
			attacker.refresh_bars()
			_message("%s sets the wall!" % attacker.unit_name)
			_log("%s: Shieldwall — +%d%% Block chance for %d turns" % [
				attacker.unit_name, SHIELDWALL_BLOCK, wall_turns], "#8c9cc8")
			# Bulwark Line (Batch AL): the stance covers the LINE as well.
			# The grant rides the same Heavy Plating slice of the block roll
			# the Warden's own stance does, and holds exactly as long — so
			# Shield Mastery lengthens the party's cover for free. He is
			# excluded: his own +25% is already up, and stacking a second
			# slice on the caster would make the node a self-buff.
			if attacker.bulwark_ally_block > 0:
				var bl_pct: int = attacker.bulwark_ally_block
				var bl_covered := 0
				for h in heroes:
					if h.dead or h.is_companion or h == attacker:
						continue
					_apply_status(h, "bulwark_line", wall_turns, bl_pct, 0, attacker)
					h.update_status("bulwark_line", "+%d%% Block" % bl_pct,
						"Bulwark Line: +%d%% Block chance for %d more turn(s)\n(the Warden's Shieldwall)." % [
							bl_pct, wall_turns], bl_pct)
					h.float_text("COVERED", Color(0.75, 0.8, 0.95))
					h.refresh_bars()
					bl_covered += 1
				if bl_covered > 0:
					_log("   → Talent: Bulwark Line — the wall covers %d all%s (+%d%% Block)" % [
						bl_covered, "y" if bl_covered == 1 else "ies", bl_pct],
						"#b0a8e0")
		"interpose":
			# The tank verb the kit was missing: cover the whole line. Rides
			# the existing shield_charges status — it already counts down,
			# renders a chip, and outranks the block roll. Charges ADD to any
			# the ally is holding. Since Batch AB this is the ONLY source of
			# guaranteed charges, which is why the block log names it.
			_sfx("parry", -6.0, 0.5)
			# Bulwark Line's ABILITY RIDER thickens the cover: +1 charge per
			# ally, and only when the hero actually owns Interpose (Batch AL
			# — the node's main body moved to Shieldwall, which he always
			# has; this half is the bonus for having drawn Interpose too).
			var sw_grant := 1 + attacker.bulwark_line_ranks
			for h in heroes:
				if h.dead or h.is_companion:
					continue
				if h == attacker and not is_perfect:
					continue
				var sw_held := maxi(h.status_power("shield_charges"), 0) \
					if h.has_status("shield_charges") else 0
				var sw_total := sw_held + sw_grant
				_apply_status(h, "shield_charges", -1, sw_total, 0, attacker)
				h.update_status("shield_charges", "IP%d" % sw_total,
					"Interpose: the next %d attack(s) against\nthis unit are BLOCKED (one charge each)." % sw_total,
					sw_total)
				h.float_text("COVERED", Color(0.75, 0.8, 0.95))
			if attacker.bulwark_line_ranks > 0:
				_log("   → Talent: Bulwark Line — each ally gains %d charges" % \
					sw_grant, "#b0a8e0")
			_message("%s covers the line!" % attacker.unit_name)
			_log("%s: Interpose — every ally gains a shield charge%s" % [
				attacker.unit_name,
				" [PERFECT: the Warden too]" if is_perfect else ""], "#8c9cc8")
		"hold_the_line":
			# UPGRADED (Batch AL — the wd_hold_line capstone landing on a
			# Hold the Line he already earned from a pool pick): the Break
			# cut rises 50% -> 80% and the no-death window doubles. The cut
			# rides the status' power so unit.gd keeps ONE read site; the
			# undying turns carry the usual hero-turn tick offset, so "one
			# turn" is 2 and "two turns" is 3.
			var hl_up := attacker.hold_line_upgraded > 0
			var hl_cut := 80 if hl_up else 50
			var hl_undying := 3 if hl_up else 2
			_sfx("heal", -5.0, 0.6)
			for h in heroes.filter(func(he): return not he.dead):
				_apply_status(h, "hold_bd", 2, hl_cut)
				h.update_status("hold_bd", "HL",
					"Takes %d%% less Break damage." % hl_cut, hl_cut)
				_apply_status(h, "undying", hl_undying)
			if is_perfect:
				attacker.resource = mini(attacker.resource + 5, attacker.max_resource)
				attacker.float_text("+5 Rage", Color(1.0, 0.5, 0.4))
				attacker.refresh_bars()
			_message("%s HOLDS THE LINE!" % attacker.unit_name)
			_log("%s: Hold the Line — party takes %d%% less BD and cannot die%s" % [
				attacker.unit_name, hl_cut,
				" for two turns [UPGRADED]" if hl_up else ""], "#70d878")
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
					_apply_status(target, "renewal", 5, 0, rez_tick, attacker)
					if target.has_status("renewal"):
						target.get_status("renewal")["mend"] = attacker.on_mend_pct
						target.get_status("renewal")["ward"] = attacker.vestments_pct
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
		"cleanse_allies":
			# Ritual Chanter (Batch V): strips the LONGEST-remaining debuff
			# from each living ally. Chilled loses a single stack, never the
			# pile — one cast must not erase four turns of Cryomancer work.
			# The side follows the TARGET so a psychotic chanter aids heroes.
			_sfx("heal", -8.0, 1.2)
			var rite_side: Array = heroes if target.is_hero else enemies
			var rite_hits := 0
			_message("%s intones a Cleansing Rite!" % attacker.unit_name)
			for cl_a in rite_side:
				if cl_a.dead:
					continue
				var cl_opts := _cleansable_debuffs(cl_a)
				if cl_opts.is_empty():
					continue
				var cl_pick: Dictionary = cl_opts[0]
				for cl_s in cl_opts:
					if _turns_left(cl_s) > _turns_left(cl_pick):
						cl_pick = cl_s
				rite_hits += 1
				cl_a.float_text("Cleansed", Color(0.95, 0.9, 0.55))
				if cl_pick.id == "chilled" and int(cl_pick.get("stacks", 1)) > 1:
					cl_a.set_chilled_stacks(int(cl_pick.get("stacks", 1)) - 1)
					_log("   → Cleansing Rite thaws one stack of Chilled on %s (x%d remains)" % [
						cl_a.unit_name, cl_a.status_stacks("chilled")], "#e8d090")
				else:
					cl_a.remove_status(cl_pick.id)
					# Ruin and its primer travel together — the rite averts
					# the detonation, not just the mark.
					if cl_pick.id == "ruin":
						cl_a.remove_status("ruin_primed")
					_log("   → Cleansing Rite strips %s from %s" % [cl_pick.label,
						cl_a.unit_name], "#e8d090")
			if rite_hits == 0:
				_log("%s: Cleansing Rite finds nothing to strip" % attacker.unit_name,
					"#909090")
		"windup":
			# Ash Hurler (Batch V): the blow is TELEGRAPHED — nothing lands
			# now. The stored ability resolves at this unit's next turn;
			# Break, Freeze, or Stun the charger and it never lands at all
			# (the turn loop owns both the landing and the cancel).
			_sfx("break", -10.0, 0.5)
			attacker.add_status("charging", "Charging", "!!", Color(1.0, 0.62, 0.3), -1,
				"%s lands at this unit's next turn:\nheavy damage to the whole party.\nBreak, Freeze, or Stun the charger\nto cancel the blow." % ab.display_name)
			var wu := attacker.get_status("charging")
			if not wu.is_empty():
				wu["ability"] = ab.display_name
			_message("%s hoists a massive blow!" % attacker.unit_name)
			_log("%s is charging %s — it lands next turn! (Break, Freeze, or Stun cancels it)" % [
				attacker.unit_name, ab.display_name], "#e08850")
		"blood_tribute":
			# Orc Bloodcaller (Batch V): every fallen ally feeds the rite —
			# +25% damage and Break damage per corpse. Resolved as a plain
			# attack copy (the Hysteria pattern) so armor, resists, and
			# crits all apply normally.
			var bt_fallen := enemies.filter(func(e): return e.dead).size()
			var bt_mult := 1.0 + 0.25 * bt_fallen
			if bt_fallen > 0:
				_log("%s: Blood Tribute — %d fallen feed the rite (+%d%% damage and Break)" % [
					attacker.unit_name, bt_fallen, 25 * bt_fallen], "#c04868")
			var bt_copy: Ability = Ability.make({"display_name": ab.display_name,
				"damage": int(round(ab.damage * bt_mult)),
				"pressure": int(round(ab.pressure * bt_mult)),
				"dmg_type": ab.dmg_type, "anim": ab.anim, "delay": ab.delay})
			await _resolve(attacker, bt_copy, target, grade)
		"totem_pulse":
			# Grave Totem (Batch V): every living ally knits back 6% of its
			# OWN maximum — weak per body, real across a full field. The
			# side follows the TARGET (psychosis turns it on the heroes).
			_sfx("heal", -7.0, 0.65)
			var tp_side: Array = heroes if target.is_hero else enemies
			var tp_total := 0
			for tp_a in tp_side:
				if tp_a.dead:
					continue
				var tp_amt := maxi(int(round(tp_a.max_hp * 0.06)), 1)
				var tp_got: int = tp_a.heal_amount(tp_amt, tp_a != attacker)
				tp_total += tp_got
				if tp_got > 0:
					tp_a.float_text("+%d" % tp_got, Color(0.55, 0.5, 0.75))
			_message("%s pulses with dark vigil..." % attacker.unit_name)
			_log("%s: Dark Vigil — every ally regains 6%% of its own health (%d in all)" % [
				attacker.unit_name, tp_total], "#70d878")
		"wildfire":
			# Batch AG: the wide payoff, and Batch AR's WIDE RELEASE VALVE —
			# Detonation empties one bank, this one skims them all. Every
			# burning enemy loses a turn of Burn (two on a perfect) and eats
			# 18% of Attack in fire for each turn taken; one with a single turn
			# left simply loses its Burn. The Overburn read is taken BEFORE any
			# of it is spent, so the cast that empties the field is still paid
			# for the field it emptied — only later turns see the ash.
			var wf_inferno := _overburn_mult(attacker, _total_burn_turns())
			var wf_take := 2 if is_perfect else 1
			var wf_binfo: Array = STATUS_INFO["burn"]
			# Wildfire Spread: the unburnt catch BEFORE the drag begins, so
			# their fresh turn is in the field on this same cast — it starts
			# costing drain immediately and pays back only when something
			# eats it. That is the node, not a rounding of it.
			if attacker.wildfire_spread > 0:
				var wf_lit := 0
				for foe in enemies:
					if foe.dead or foe.has_status("burn"):
						continue
					_apply_status(foe, "burn", attacker.wildfire_spread, 0,
						_dot_tick("burn", attacker))
					wf_lit += 1
				if wf_lit > 0:
					_log("   → Talent: Wildfire Spread — %d fresh %s catches" % [
						wf_lit, "fire" if wf_lit == 1 else "fires"], "#b0a8e0")
			var wf_struck := 0
			var wf_total := 0
			var wf_turns := 0
			for foe in enemies:
				if foe.dead or not foe.has_status("burn"):
					continue
				var wf_st: Dictionary = foe.get_status("burn")
				var wf_left: int = maxi(int(wf_st.get("turns", 0)), 0)
				if wf_left <= 0:
					continue
				var wf_spent: int = mini(wf_take, wf_left)
				# Spend the fire first so the chip agrees with the hit.
				if wf_left - wf_spent <= 0:
					foe.remove_status("burn")
				else:
					foe.update_status("burn", wf_binfo[1], wf_binfo[3], -1,
						wf_left - wf_spent)
				var wf_raw := 0.18 * wf_spent * attacker.attack * mult \
					* wf_inferno * randf_range(0.9, 1.1)
				# Avatar of Flame burns through fire resistance here too.
				var wf_res := float(foe.resists.get("fire", 0.0))
				if attacker.avatar_flame > 0:
					wf_res = 0.0
				wf_raw *= 1.0 - wf_res
				var wf_final := maxi(int(round(wf_raw \
					* (1.0 - foe.effective_armor()))), 1)
				var wf_hit: Dictionary = foe.take_hit(wf_final, ab.pressure)
				_stat("dmg_hero_" + attacker.unit_name, wf_final)
				_stat_bd(attacker, ab.pressure)
				wf_struck += 1
				wf_total += wf_final
				wf_turns += wf_spent
				foe.float_text("%d Wildfire" % wf_final, Color(1.0, 0.55, 0.2))
				if wf_hit.died:
					_stat("enemy_deaths")
					_sfx("death", -4.0)
					_message("%s falls!" % foe.unit_name)
					_log("† %s dies" % foe.unit_name, "#e05050")
					_on_enemy_death(foe)
			if wf_struck == 0:
				_log("%s: Wildfire — nothing on the field is burning" % \
					attacker.unit_name, "#909090")
			else:
				_sfx("bomb", -8.0, 1.1)
				_message("%s drags the fire through them!" % attacker.unit_name)
				_log("%s: Wildfire — %d turn%s of Burn torn from %d %s for %d damage%s" % [
					attacker.unit_name, wf_turns, "" if wf_turns == 1 else "s",
					wf_struck, "enemy" if wf_struck == 1 else "enemies",
					wf_total, " [PERFECT]" if is_perfect else ""], "#e08850")
			# Overburn's refund, from the SAME helper Detonation calls: the
			# rule is a property of the PASSIVE, so neither ability carries
			# its own copy of it.
			_overburn_refund(attacker, wf_turns)
		"immolate":
			# The re-specced Flame Shield (Batch AR). Every clause pushes the
			# SAME way — no cap on Overburn's reward, DOUBLE its drain, and a
			# retaliation burn that feeds the very engine now costing more to
			# run. There is deliberately no defensive half left in it.
			_sfx("parry", -7.0, 1.1)
			_apply_status(attacker, "immolate", 3 if is_perfect else 2)
			_message("%s opens the furnace!" % attacker.unit_name)
			_log("%s: Immolate — Overburn uncapped, drain DOUBLED; attackers ignite (%d turns)" % [
				attacker.unit_name, 3 if is_perfect else 2], "#e08850")
		"backdraft":
			# Lights nothing new: it only deepens what is already alight, which
			# is what makes it a commitment rather than a spreader. The usable
			# gate keeps it dark with an empty field.
			var bd_turns := 3 if is_perfect else 2
			var bd_binfo: Array = STATUS_INFO["burn"]
			var bd_hit := 0
			for foe in enemies:
				if foe.dead or not foe.has_status("burn"):
					continue
				var bd_st: Dictionary = foe.get_status("burn")
				foe.update_status("burn", bd_binfo[1], bd_binfo[3], -1,
					maxi(int(bd_st.get("turns", 0)), 0) + bd_turns)
				foe.float_text("Burn +%d turns" % bd_turns, bd_binfo[2])
				bd_hit += 1
			_sfx("bomb", -8.0, 0.9)
			_message("%s feeds the fire air!" % attacker.unit_name)
			_log("%s: Backdraft — +%d turns of Burn on %d burning %s%s" % [
				attacker.unit_name, bd_turns, bd_hit,
				"enemy" if bd_hit == 1 else "enemies",
				" [PERFECT]" if is_perfect else ""], "#e08850")
		"rime":
			_sfx("break", -9.0, 1.4)
			# Icy Resolve (talent): the hoarfrost roots deeper.
			var rime_turns := (4 if is_perfect else 3) + attacker.icy_resolve_ranks
			_apply_status(target, "rime", rime_turns)
			_apply_status(target, "frostbite", 2)
			_message("%s rimes %s!" % [attacker.unit_name, target.unit_name])
			_log("%s: Rime on %s — its chills will spread (%d turns)" % [
				attacker.unit_name, target.unit_name, rime_turns], "#7cc8f0")
		"glacial_prison":
			# Deep Freeze row 4: the hold WITHOUT the build. It skips the four
			# stacks entirely, which is what makes the lane's opening move a
			# choice rather than a countdown. Everything after the freeze —
			# Glacial Economy, Bitter Cold, the limit eviction, the boss
			# carve-out — comes free, because it goes through _hold_freeze like
			# every other freeze in the game.
			_sfx("break", -9.0, 0.8)
			_message("%s seals %s in ice!" % [attacker.unit_name, target.unit_name])
			_log("%s: Glacial Prison closes on %s" % [attacker.unit_name,
				target.unit_name], "#7cc8f0")
			if not target.has_status("chilled"):
				_apply_status(target, "chilled", 3, 0, 0, attacker)
				_note_debuff_applied(attacker, "chilled")
			_hold_freeze(target, attacker)
		"cryoclasm":
			# Thaw row 4: CONTROL AS A VERB — the lockdown relocates without
			# being spent. Deliberately NOT routed through _hold_release: a move
			# is not a release, so Shattered Tempo and Honed Shards do not fire
			# and the hold he is paying for is still the hold he has.
			var cc_from: BattleUnit = null
			for cc_h in _holds:
				if not cc_h.dead:
					cc_from = cc_h      # the OLDEST living prison moves
					break
			if cc_from == null or cc_from == target or target.dead:
				_log("%s: Cryoclasm finds nothing to move" % attacker.unit_name, "#909090")
			else:
				var cc_stacks := cc_from.status_stacks("chilled")
				_sfx("break", -9.0, 1.1)
				_message("%s hurls the ice from %s onto %s!" % [attacker.unit_name,
					cc_from.unit_name, target.unit_name])
				_log("%s: Cryoclasm — the prison moves to %s (x%d Chilled travels)" % [
					attacker.unit_name, target.unit_name, cc_stacks], "#7cc8f0")
				_holds.erase(cc_from)
				cc_from.remove_status("frozen")
				cc_from.set_chilled_stacks(HOLD_RELEASE_STACKS)
				if is_inf(cc_from.next_time):
					cc_from.next_time = _clock + BASIC_DELAY * 100.0 \
						/ maxf(cc_from.effective_speed(), 0.1)
				if not target.has_status("chilled"):
					_apply_status(target, "chilled", 3, 0, 0, attacker)
					_note_debuff_applied(attacker, "chilled")
				target.set_chilled_stacks(cc_stacks)
				_hold_freeze(target, attacker)
		"stabilize":
			# Vents the Resonance stacks ABOVE the floor (2, raised by Still
			# Mind): Mana back and a damage-reduction ward per stack consumed.
			# A tactical valve, not a reset — the engine keeps running (Batch P).
			# Batch AT: MASTER OF MOMENTS IS GONE — free venting was the most
			# anti-escalation node in the game, and its id carries Perfect
			# Conversion now. Stabilize ALWAYS consumes, which is what makes
			# earning it a real decision rather than a free button.
			var st_floor := 2 + attacker.still_mind_ranks
			var st_stacks := attacker.second_resource - st_floor
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
			_log("%s: Stabilize — %d stacks vented (%d remain): +%d Mana, -%d%% damage taken (2 turns)" % [
				attacker.unit_name, st_stacks, attacker.second_resource,
				st_mana, st_dr], "#b085e0")
		"overcharge":
			# RE-SPECCED (Batch AT): raising a cap to 8 is meaningless once
			# there is no cap, so it COMPOUNDS THE RAMP instead — gain Resonance
			# equal to half the stacks he already holds (all of them on a
			# perfect). At ten stacks that is five; at twenty it is ten. Once
			# per battle — TWICE once the tree node has landed on an Overcharge
			# he already earned (Batch AU §1's authored fallback), which is why
			# this counts uses rather than setting a spent flag.
			attacker.overcharge_uses += 1
			attacker.overcharge_mult = 1.0 if is_perfect else 0.5
			var oc_gain := int(floor(attacker.second_resource * attacker.overcharge_mult))
			_sfx("perfect", -6.0, 0.8)
			# The chip means "no feeding left", not "has fed once" — with the
			# node's second use still owed it would otherwise be a lying chip.
			if not attacker.overcharge_ready():
				_apply_status(attacker, "overcharged", -1)
			if oc_gain > 0:
				_gain_resonance(attacker, oc_gain)
			attacker.refresh_bars()
			_message("%s OVERCHARGES!" % attacker.unit_name)
			_log("%s: Overcharge — the storm feeds on itself: +%d Resonance (now %d)%s" % [
				attacker.unit_name, oc_gain, attacker.second_resource,
				" [PERFECT]" if is_perfect else ""], "#b085e0")
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
			_stat_heal(attacker, hh_got)
			_bank_overheal(attacker, target)
			_overflow_spill(attacker, target)
			if hh_crit > 1.0:
				_radiant_cascade(attacker, hh_got, target)
			_vestments_ward(attacker, target, hh_got)
			var hh_note := ""
			if empowered:
				var purged := target.purge_debuffs()
				hh_note = " — cleansed %d harmful effect%s (Empowered)" % [
					purged, "" if purged == 1 else "s"]
			elif is_perfect:
				var hh_self := maxi(int(round(attacker.max_hp * 0.05)), 1)
				var self_got: int = attacker.heal_amount(hh_self)
				attacker.float_text("+%d" % self_got, Color(0.4, 0.9, 0.45))
				_stat_heal(attacker, self_got)
			_message("%s mends %s" % [attacker.unit_name, target.unit_name])
			_log("%s: Heal — %s recovers %d%s (40%% of the Cleric's health)%s" % [
				attacker.unit_name, target.unit_name, hh_got,
				" CRIT" if hh_crit > 1.0 else "", hh_note], "#70d878")
		"intercession":
			# BATCH AV — THE REVERSAL BUTTON. It arms a window, it does not pay
			# for one: the stack leaves her hand only when a blow actually
			# lands (`_on_intercession_save`). The STATUS is the one answer to
			# "is the refusal live", so it expires on its own clock and the
			# guard cannot outlive its window. Applied to every living hero
			# because the check runs on WHOEVER takes the blow.
			var ic_turns := 2 + attacker.intercession_long + (1 if is_perfect else 0)
			_sfx("heal", -6.0, 0.55)
			for ic_h in heroes.filter(func(he): return not he.dead and not he.is_companion):
				_apply_status(ic_h, "intercession", ic_turns)
			_message("%s intercedes!" % attacker.unit_name)
			_log("%s: Intercession — for %d turns the next lethal blow on any hero is refused (1 Mercy, on trigger)%s" % [
				attacker.unit_name, ic_turns,
				" [PERFECT]" if is_perfect else ""], "#70d878")
		"divine_plea":
			# Spend 2 Mercy: a full heal; Empowered also cleanses and wards.
			_sfx("heal", -4.0, 0.7)
			var dp_got: int = target.heal_amount(target.max_hp, target != attacker)
			target.float_text("+%d" % dp_got, Color(0.4, 0.9, 0.45))
			_stat_heal(attacker, dp_got)
			_vestments_ward(attacker, target, dp_got)
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
			_apply_status(target, "renewal", 5, 0, ren_tick, attacker)
			target.update_status("renewal", "R+",
				"Renewal: restores %d HP at the start\nof each turn (15%% of the caster's\nmax health)." % ren_tick)
			# On the Mend and Living Sanctum ride the status (snapshotted):
			# ticks can dispel, and can echo to the party.
			if target.has_status("renewal"):
				target.get_status("renewal")["mend"] = attacker.on_mend_pct
				target.get_status("renewal")["ward"] = attacker.vestments_pct
			if empowered and target != attacker:
				_apply_status(attacker, "renewal", 5, 0, ren_tick, attacker)
				attacker.update_status("renewal", "R+",
					"Renewal: restores %d HP at the start\nof each turn (15%% of the caster's\nmax health)." % ren_tick)
				if attacker.has_status("renewal"):
					attacker.get_status("renewal")["mend"] = attacker.on_mend_pct
					attacker.get_status("renewal")["ward"] = attacker.vestments_pct
			if is_perfect:
				# Triage: the burst can crit (captured so Radiant Cascade
				# knows to splash).
				var rb_crit := _heal_crit_mult(attacker)
				var ren_burst := maxi(int(round(attacker.max_hp * 0.05 * rb_crit)), 1)
				var burst_got: int = target.heal_amount(ren_burst, target != attacker)
				target.float_text("+%d" % burst_got, Color(0.4, 0.9, 0.45))
				_stat_heal(attacker, burst_got)
				_bank_overheal(attacker, target)
				_overflow_spill(attacker, target)
				if rb_crit > 1.0:
					_radiant_cascade(attacker, burst_got, target)
				_vestments_ward(attacker, target, burst_got)
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
	# Batch AQ §4: the beast joins a fight that is ALREADY under a bargain.
	# _apply_battle_modifier walks heroes + enemies at spawn, and a companion
	# exists at neither moment — so before this line a summoned beast was the
	# only unit on the field the modifier did not bind. It sits beside the
	# armor / Stability / crit copies above because those are the existing
	# precedent for "inherit the state of the fight". `inherited` is true: the
	# Attack and crit it just copied off the hunter already carry Feverish and
	# Dull Edge, and stamping those twice would double them.
	var comp_mod := _active_modifier()
	if comp_mod != "":
		_stamp_modifier(comp, comp_mod, true)
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
	# Lone Bond's gate: only a REAL summon spends the one beast. Call of the
	# Wild writes kinds_summoned for the talents above but never comes
	# through here, so it can no longer lock the hunter out of summoning.
	hunter.beast_committed = true
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
		if pr > 0:
			_stat_bd(comp_credit, pr)
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
func _spring_trap(placer: BattleUnit, victim: BattleUnit, dmg: float,
		force_stun := false) -> void:
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
	_apply_status(victim, "stunned", 1, 0, 0, null, force_stun)
	if placer.quick_rigging > 0:
		_apply_status(victim, "cripple", 3)
	if placer.bone_breaker > 0:
		victim.take_hit(0, 30)
		_stat_bd(placer, 30)
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
	# Overkill (Batch AJ): a kill resets the two abilities the archetype is
	# built on. THE ONE read site for `overkill_reset` — the existing kill
	# hook, which is also where Bloodied Momentum and Apex Predator live.
	for ok_h in heroes:
		if ok_h.dead or ok_h.overkill_reset == 0:
			continue
		var ok_cleared := PackedStringArray()
		for ok_name in ["Hack and Slash", "Wildstrikes"]:
			if ok_h.cooldowns.get(ok_name, 0) > 0:
				ok_h.cooldowns.erase(ok_name)
				ok_cleared.append(ok_name)
		if not ok_cleared.is_empty():
			_log("   → Overkill: %s is ready again (%s)" % [ok_h.unit_name,
				" and ".join(ok_cleared)], "#b0a8e0")
	# SINGULARITY (Batch AU): the Resonance capstone's second clause — every
	# enemy killed builds Resonance. It rides THIS hook, the one place a death
	# is booked, so it can only ever fire once per death (a negative control
	# that also pays it from the strike loop trips the test).
	for sg_h in heroes:
		if sg_h.dead or sg_h.singularity_kill_build <= 0:
			continue
		if sg_h.second_resource_name != "Resonance":
			continue
		_gain_resonance(sg_h, sg_h.singularity_kill_build)
		_log("   → Talent: Singularity — the collapse feeds on the kill (+%d Resonance)" % \
			sg_h.singularity_kill_build, "#b0a8e0")
	# Bloodied Momentum: every kill feeds the Berserker's swing.
	for mo_h in heroes:
		if not mo_h.dead and mo_h.bloodied_momentum_ranks > 0:
			var mo_rage := 40 * int(mo_h.bloodied_momentum_ranks)
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
	# Rune of Exsanguination (blood_pact, a NEGATIVE threshold shift; its
	# only battle.gd read site): enemy veins open early — the meter pops at
	# 100+pact, and the bleedout pays 15% of max HP instead of 20%.
	# (_living_hero_with wants positives, so scan for the negative here.)
	var pact := 0
	if not victim.is_hero:
		for pact_h in heroes:
			if not pact_h.dead and not pact_h.is_companion and pact_h.blood_pact < 0:
				pact = pact_h.blood_pact
				break
	# Forced only when the rune actually matters — a meter that would top
	# 100 on its own pops the normal way (still at the pact's 15%).
	var forced: bool = pact < 0 and victim.bleed_buildup + amount >= 100 + pact \
		and victim.bleed_buildup + amount < 100
	if forced:
		_log("   → Rune: Exsanguination opens the vein early (bleedout at %d)" % (
			100 + pact), "#b0a8e0")
	if victim.add_bleed((100 - victim.bleed_buildup) if forced else amount):
		# Exsanguination (capstone): enemy bleedouts hit for 35% instead.
		var exsang := not victim.is_hero \
			and _living_hero_with("exsanguination") != null
		var pact_pct := 0.35 if exsang else (0.15 if pact < 0 else 0.20)
		var bleed_dmg := maxi(int(victim.max_hp * pact_pct), 1)
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
					var craze := maxi(int(feaster.max_hp * 0.12 * feaster.bloodcraze), 1)
					feaster.heal_amount(craze)
					feaster.float_text("+%d Bloodcraze" % craze, Color(0.85, 0.3, 0.3))
					_log("   → Bloodcraze: %s feasts (+%d HP)" % [feaster.unit_name,
						craze], "#b0a8e0")
			# Blood Tithe: the bleedout pays its toll in Rage.
			for bt_h in heroes:
				if not bt_h.dead and bt_h.blood_tithe_ranks > 0:
					var tithe := 45 * int(bt_h.blood_tithe_ranks)
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
						10 * sc_h.scent_ranks * sc_h.bleedouts_this_battle,
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
			# Batch AJ: Arterial Spray is a FULL transfer now — the node is a
			# row, so it reads as all-or-nothing rather than a quarter a rank.
			var t_pct := (1.0 if (exsang or _max_hero_rank("arterial_ranks") > 0) \
				else 0.0)
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
		# Hemorrhage (talent): enough open wounds leave the enemy Crippled.
		# Batch AJ made the threshold a flat 60 — one node, one number.
		var hem := 0
		for h in heroes:
			if not h.dead:
				hem = maxi(hem, h.hemorrhage_ranks)
		if hem > 0 and not victim.is_hero and not victim.has_status("cripple") \
				and victim.bleed_buildup >= 60:
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


# ---------- skill check ----------

func _run_skill_check(cancellable := false) -> String:
	# First-run orientation (Batch Z): the design's own framing is that the
	# player's execution matters as much as the build — a tester who never
	# notices the timing window is playing a materially worse game. One
	# card, once ever (Profile flag). Real play only: sims and autoplay
	# roll their grades and never reach this function's UI path, and the
	# guard keeps standalone test battles from writing the profile.
	if not sim and not autoplay and Run.active and not Run.sim_run \
			and not Profile.flag("skill_check_taught"):
		await _show_skill_check_hint()
		Profile.set_flag("skill_check_taught")
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


# The one-time pointer at the timing bar. Modal on purpose: the check has
# not started sweeping yet (sc_active is still false, so clicks and Space
# grade nothing), and the card holds the turn until the player dismisses
# it — nothing about the timeline moves while it waits.
signal _hint_done

var _hint_active := false


func _show_skill_check_hint() -> void:
	_hint_active = true
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.6)
	ui.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(400, 250)
	ui.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "YOUR HAND MATTERS"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 0.45))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var body := Label.new()
	body.text = ("Every action runs a timing check: a marker sweeps the bar\n" +
		"below — press SPACE or CLICK to stop it.\n\n" +
		"    Gold center  =  PERFECT: +15% damage, +25% Break, bonus effects\n" +
		"    Green band   =  Good: full effect\n" +
		"    Outside      =  Sloppy: only 60% damage, half Break\n\n" +
		"Your timing decides as much as your build does.")
	body.add_theme_font_size_override("font_size", 15)
	vbox.add_child(body)
	var btn := Button.new()
	btn.text = "Got it — try me"
	btn.custom_minimum_size = Vector2(200, 42)
	btn.pressed.connect(func(): _hint_done.emit())
	vbox.add_child(btn)
	await _hint_done
	_hint_active = false
	dim.queue_free()
	panel.queue_free()


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
	# A modal is up (glossary panel or the one-time skill-check card): it
	# owns all input — its own buttons work through normal GUI — and
	# nothing here may fire, or a click could grade a check or pick a
	# target through the overlay.
	if _modal_open():
		return
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
		_try_ability_hotkey(event.keycode, event.shift_pressed)
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
			_try_ability_hotkey(event.keycode, event.shift_pressed)


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


# The label a menu slot wears, "" when the slot is past every hotkey.
# Batch AH: heroes hold as many abilities as they earn, so slots 10-18 bind
# to SHIFT + the same nine keys in the same order — ability 10 is Shift+Q.
# The ⇧ rides the button label because a hotkey nobody can see is not one.
func _hotkey_name(key_idx: int) -> String:
	if key_idx < 0:
		return ""
	var n := ABILITY_KEY_NAMES.size()
	if key_idx < n:
		return String(ABILITY_KEY_NAMES[key_idx])
	if key_idx < n * 2:
		return "⇧%s" % ABILITY_KEY_NAMES[key_idx - n]
	return ""


# Q/W/E/R/A/S/D/F/G pick menu entries by slot while the action bar is open,
# and SHIFT + the same key picks slots 10-18. The summon group (W on the
# Beastmaster) opens the beast picker. Gating is unchanged: the entry still
# has to pass _ability_usable, and both call sites are already fenced off
# during a skill check, an open picker, and autoplay.
func _try_ability_hotkey(keycode: Key, shifted := false) -> void:
	if current_hero == null or not action_panel.visible:
		return
	var idx := ABILITY_KEYS.find(keycode)
	if idx < 0:
		return
	if shifted:
		idx += ABILITY_KEYS.size()
	if idx >= _menu_entries.size():
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
	if _modal_open():
		return
	if sc_active and event.is_action_pressed("ui_accept"):
		_grade_skill_check()


# True while an overlay owns input (see _input).
func _modal_open() -> bool:
	return _hint_active or (_glossary != null and is_instance_valid(_glossary)) \
		or (_forfeit_panel != null and is_instance_valid(_forfeit_panel))


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
	var victory := enemies.all(func(e): return e.dead) and not stalemate
	var defeat := heroes.all(func(h): return h.dead) or stalemate
	if not victory and not defeat:
		return
	battle_over = true
	if sim:
		sim_done += 1
		_stat("battles")
		# Batch AX §0: the denominators for the two Ruin numbers. A run is mostly
		# trash, so averaging detonations over ALL battles would bury the boss
		# half — which is the half the design is aimed at.
		if heroes.any(func(h): return h.passive_id == "old_gods"):
			_stat("ruin_boss_battles" if _boss_fight() else "ruin_trash_battles")
		# BATCH AW §0 — THE ONE NEW NUMBER, and it is the whole batch in one
		# figure: how much maximum health Conviction lent the Devout over the
		# course of this fight. Banked here rather than at the growth site so
		# it is a PER-BATTLE total, and the maximum observed is tracked
		# alongside because §1 ships 3% uncapped as a deliberate trial and the
		# Apostle row is what decides whether it needs a ceiling.
		for cg_h in heroes:
			if cg_h.passive_id != "conviction":
				continue
			_stat("conviction_growth", float(cg_h.conviction_hp_gained))
			_stat("conviction_battles")
			if cg_h.conviction_base_hp > 0:
				_stat("conviction_growth_pct", 100.0 * cg_h.conviction_hp_gained
					/ float(cg_h.conviction_base_hp))
			sim_stats["conviction_growth_max"] = maxf(
				sim_stats.get("conviction_growth_max", 0.0),
				float(cg_h.conviction_hp_gained))
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
		# Batch W: per-spec sample counts + share pools. A rotated report
		# needs "this spec's slice of the battles it was IN"; for a fixed
		# party the pool equals the stage total, so old shares reproduce.
		var b_dmg_total := 0.0
		var b_all_total := 0.0
		for k in _b_slice:
			b_all_total += _b_slice[k]
			if String(k).begins_with("dmg_hero_"):
				b_dmg_total += _b_slice[k]
		for h in heroes:
			if h.is_companion:
				continue
			_stat("n_hero_" + h.unit_name)
			_stat("pool_dmg_hero_" + h.unit_name, b_dmg_total)
			_stat("pool_all_hero_" + h.unit_name, b_all_total)
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
	# Batch Z: bank this battle's hero damage into the run ledger while the
	# battle scene still exists — the scene reloads between fights, so
	# anything not banked here dies with it.
	Run.tally_add("battles")
	for key in _run_slice:
		Run.tally_damage(String(key).trim_prefix("dmg_hero_"), _run_slice[key])
	if victory:
		# Node scaling: every combat victory grows the party (+2% of base
		# Attack and HP at the next spawn).
		Run.combat_wins += 1
		for i in heroes.size():
			# Keep the saved max in sync with talents/runes/scaling so full
			# heals reach the true maximum — but battle-long gains stay in the
			# battle. TWO SEPARATE LOANS COME OFF HERE (Batch AW): Tenacity's,
			# and now Conviction's growth — each is a ONE-FIGHT loan, and hp is
			# clamped under the restored maximum in the same step (the clampi
			# below). Without the second one the Devout leaves every battle
			# permanently larger with nothing crashing to announce it — the
			# exact failure that got `rot` dropped from Batch AQ. THE FIELDS
			# STAY SEPARATE: Unkillable also reads tenacity_hp_gained, as "the
			# pool he brought into the battle", and must not see this one.
			var save_max: int = heroes[i].max_hp - heroes[i].tenacity_hp_gained \
				- heroes[i].conviction_hp_gained
			# The Untouched refuse to stay down: the fallen return at 20% HP.
			Run.party[i]["hp"] = clampi(maxi(heroes[i].hp, int(save_max * 0.2)),
				1, save_max)
			Run.party[i]["max_hp"] = save_max
			if heroes[i].resource_name == "Mana":
				Run.party[i]["mana"] = heroes[i].resource
		var node_type := String(Run.encounter.get("type", "fight"))
		# Batch AN §8: 1 point for an elite, a mini-boss or a boss — including
		# the END boss, which used to pay nothing. Ordinary fights pay none. One
		# purse now; the flex purse is no longer fed (see award_talent_points
		# for why the arithmetic closes without it).
		var pts := Run.award_talent_points(node_type)
		var gold_gain := Run.award_gold(node_type)
		# §6: clearing ANY slot heals the party. This is the whole of the
		# rest-node replacement, and it rides the SAME relic hook the Chalice of
		# Dawn already used, so the relic\'s 10% stacks on top of the base 15%.
		Run.heal_party(Run.victory_heal_pct())
		var v_mana := Run.relic_add("victory_mana_pct")
		if v_mana > 0.0:
			Run.restore_mana(v_mana)
		var v_gold := int(Run.relic_add("victory_gold"))
		if v_gold > 0:
			Run.gold += v_gold
		# §3: the accepted bargain pays out. claim_reward CLEARS the pending
		# modifier as well, which is why it is called on the victory path even
		# when there is nothing to pay — nothing may leak into the next battle.
		var bargain := Run.claim_reward()
		var reward_text := String(bargain.get("text", ""))
		var merchant_owed: bool = bool(bargain.get("shop", false))
		var spoils := ""
		if reward_text != "":
			spoils += "\n\nTHE BARGAIN\n%s" % reward_text
		# Elite spoils: a rune for a random hero + a consumable on top of the
		# bigger gold purse — the snowball reward for hunting elites.
		if node_type == "elite":
			Run.tally_add("elites")
			var looter: Dictionary = Run.party.pick_random()
			spoils += "\n\nELITE SPOILS"
			spoils += _drop_item_line(Run.random_loot())
			# Rune pick-of-3 (Batch X): candidates rolled NOW and stored on the
			# member (never rerolled), chosen on the hero card. Empty = runes
			# off — the spoils keep the item.
			var candidates: Array = Run.roll_rune_candidates(looter)
			if not candidates.is_empty():
				looter["rune_candidates"] = looter.get("rune_candidates", []) + [candidates]
				looter["rune_picks_owed"] = int(looter.get("rune_picks_owed", 0)) + 1
				spoils += "\nRUNE CACHE: the %s may choose one of three\non their card." % \
					String(looter["key"]).capitalize()
			# Gravelight Lantern: the spoils pile runs deeper.
			for extra_i in int(Run.relic_add("loot_extra")):
				spoils += "%s (Gravelight Lantern)" % _drop_item_line(Run.random_loot())
		# §4: the mini-boss awards a GENERIC ABILITY UPGRADE chosen from three,
		# not an ability. No consumable, no rune cache.
		if node_type == "miniboss":
			Run.tally_add("elites")
			var mb_names := PackedStringArray()
			for member in Run.party:
				if Run.award_upgrade_pick(member):
					mb_names.append(_hero_label(member))
			# APPEND, never assign. A mini-boss carries no bargain today (§3
			# offers precede fights and elites only), so `spoils` is empty
			# here — but assigning would silently swallow the bargain line the
			# moment that changes, and a reward that vanishes without a word
			# is the exact failure the item cap's refusal message exists to
			# avoid.
			spoils += "\n\nTHE WAY IS OPEN"
			if not mb_names.is_empty():
				spoils += "\nABILITY UPGRADE: %s may choose one of three\non their card." % \
					" and ".join(mb_names)
		Run.save_run()
		_sfx("victory", -4.0)
		if node_type == "boss":
			_resolve_boss(gold_gain, pts)
		else:
			# Ordinary fights pay no points at all — say what WAS won rather
			# than "+0 talent points".
			var win_text := "+%d gold. The party recovers %d%%." % [
				gold_gain, int(round(Run.victory_heal_pct() * 100))]
			if pts > 0:
				win_text += "\nEach hero gains %d talent point%s." % [
					pts, "" if pts == 1 else "s"]
			# §5 and §7: what follows a cleared fight or elite. Both are rolled
			# HERE, once, and queued on the run — rolling them from the map
			# would re-roll on every redraw, and the merchant FLOOR would never
			# mean anything.
			var after: Array = []
			if merchant_owed or Run.roll_merchant(node_type):
				after.append("shop")
			if Run.roll_event(node_type):
				after.append("event")
			var buttons: Array = [["Continue", _to_map]]
			if not after.is_empty():
				Run.pending_after = after
				spoils += "\n\n%s" % ("A merchant waits on the road ahead."
					if String(after[0]) == "shop"
					else "Something waits on the road ahead.")
				buttons = [["Continue", _to_after]]
			Run.save_run()
			_show_end("VICTORY", win_text + spoils, buttons, true)
	else:
		# Wipes count toward the profile only for real runs (sims never
		# carry Run.active). Batch AC: nor does dying in a DEBUG-SUMMONED
		# fight — the run really is over, but "cycles lost to the Decay"
		# should not count a fight the tester conjured out of a menu. This
		# is the one Profile booking a summoned node can reach.
		if Run.active and not Run.debug_summon:
			Profile.note_wipe(Run.party.map(func(m): return m.get("spec", "")))
		# Batch Z: snapshot BEFORE the clear (see the completion branch).
		var wipe_snap := _run_snapshot("wipe", "")
		Run.active = false
		Run.clear_save()
		_sfx("defeat", -4.0)
		_show_run_summary(wipe_snap)


# ---------- Batch AN §4: the boss slots ----------
#
# Zone 1 and zone 2 bosses award ONE ABILITY PICK for every hero, drawn from
# that hero\'s SPEC POOL ONLY (§4 dropped the class draw AH added). The END
# boss awards a relic unlock, big gold, and ends the run — deliberately NO
# ability pick, because nothing follows it and the pick would be dead value.
func _resolve_boss(gold_gain: int, pts: int) -> void:
	var relic := Relics.unlock_random()
	var boss_text := "+%d gold." % gold_gain
	if pts > 0:
		boss_text += " Each hero gains %d talent point%s." % [
			pts, "" if pts == 1 else "s"]
	if Run.has_next_zone():
		if not relic.is_empty():
			boss_text += "\n\nRELIC UNLOCKED: %s\n%s" % [relic["name"], relic["desc"]]
		var picked: Array = _award_ability_picks()
		if not picked.is_empty():
			boss_text += "\n\nNEW ABILITY: %s may choose one of three\non their card." % \
				" and ".join(picked)
			Run.save_run()
		Profile.note_boss(Run.boss_kind())
		Profile.note_zone_cleared()
		_show_end("THE ZONE IS CLEANSED", boss_text,
			[["Descend into %s" % Run.next_zone_name(), _next_zone]], true)
		return
	# The end boss. The run is over on its death.
	boss_text += "\n\nThe road ends here."
	if not relic.is_empty():
		boss_text += "\n\nRELIC UNLOCKED: %s\n%s" % [relic["name"], relic["desc"]]
	Profile.note_boss(Run.boss_kind())
	Profile.note_zone_cleared()
	Profile.note_completion(Run.party.map(func(m): return m.get("spec", "")))
	# Batch Z: the summary needs the run state clear_save destroys — snapshot
	# FIRST, never reorder the save logic (a reordering that leaves a dead run
	# resumable is the worse bug).
	var comp_snap := _run_snapshot("complete", boss_text)
	Run.active = false
	Run.clear_save()
	_show_run_summary(comp_snap)


# One consumable into the pouch, honouring the §6 cap of six per type. A
# refused drop SAYS SO — a reward that silently evaporates reads as a bug,
# which is the whole reason add_item reports what landed.
func _drop_item_line(id: String) -> String:
	if Run.add_item(id) > 0:
		return "\n+1 %s" % Run.ITEM_INFO[id][0]
	return "\n%s — the party already carries %d, and cannot hold more." % [
		Run.ITEM_INFO[id][0], Run.ITEM_CAP]


func _hero_label(member: Dictionary) -> String:
	var spec := String(member.get("spec", ""))
	if Classes.SPEC_INFO.has(spec):
		return String(Classes.SPEC_INFO[spec]["name"])
	return String(member["key"]).capitalize()


func _next_zone() -> void:
	Run.advance_zone()
	Run.save_run()
	_to_map()


func _to_map() -> void:
	# Batch AN: straight back to the map. It carries the hero cards now, so
	# there is no longer a Party screen to route through — points, runes and
	# picks are all spendable on the map itself.
	get_tree().change_scene_to_file("res://scenes/map.tscn")


# §5 / §7: a merchant and/or an event queued by the fight that just ended.
# Run.pending_after is a QUEUE the screens pop from, so a fight that rolled
# both resolves the shop, then the event, then the map — and quitting
# mid-queue simply drops what is left rather than stranding the player.
func _to_after() -> void:
	var next := Run.next_after_scene()
	Run.save_run()
	get_tree().change_scene_to_file(next)


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
	if sim_stats.get("stalemates", 0.0) > 0:
		print("STALEMATES force-ended: %d of %d battles (scored as losses)" % [
			int(sim_stats.get("stalemates", 0.0)), int(battles)])
	print("Per-hero contribution (avg per battle present):")
	print(_contrib_table(sim_stats))
	# Batch AW §0: printed only when a Devout was in the party, because a zero
	# on a party without one reads as a broken instrument rather than a line.
	var cg_n: float = sim_stats.get("conviction_battles", 0.0)
	if cg_n > 0.0:
		print("Devout max-health growth/battle: %.1f HP (+%.1f%% of base), max observed %d HP" % [
			sim_stats.get("conviction_growth", 0.0) / cg_n,
			sim_stats.get("conviction_growth_pct", 0.0) / cg_n,
			int(sim_stats.get("conviction_growth_max", 0.0))])
	var rx := ruin_report_line(sim_stats)
	if rx != "":
		print(rx)
	print("=============================================\n")


# BATCH AX §0 — THE TWO NUMBERS THE BATCH IS ABOUT, split trash vs boss because
# that split IS the design: moving the threshold to every tenth stack takes his
# signature payoff largely out of ordinary fights and makes him the boss
# specialist by construction. Shared by the standalone report and RunSim's,
# since only a RUN ever meets a boss. Returns "" when no Occultist stood — a
# zero on a party without one reads as a broken instrument rather than a line.
static func ruin_report_line(stats: Dictionary) -> String:
	var rt_n: float = stats.get("ruin_trash_battles", 0.0)
	var rb_n: float = stats.get("ruin_boss_battles", 0.0)
	if rt_n <= 0.0 and rb_n <= 0.0:
		return ""
	return "Ruin detonations/battle: trash %.2f (n=%d, deepest mark %d) | boss %.2f (n=%d, deepest mark %d)" % [
		stats.get("ruin_detonations_trash", 0.0) / maxf(rt_n, 1.0), int(rt_n),
		int(stats.get("ruin_max_trash", 0.0)),
		stats.get("ruin_detonations_boss", 0.0) / maxf(rb_n, 1.0), int(rb_n),
		int(stats.get("ruin_max_boss", 0.0))]


# Sweep report (DOD_SIM_SWEEP=1): one row per budget stage. Rounds reuses
# the single-report metric (hero turns / 3) so the two stay comparable.
func _print_sweep_report() -> void:
	var elapsed := (Time.get_ticks_msec() - sim_started_ms) / 1000.0
	var zone := OS.get_environment("DOD_SIM_ZONE")
	var theme := OS.get_environment("DOD_SIM_THEME")
	print("\n===== DAWN OF DECAY — DIFFICULTY SWEEP =====")
	var sw_specs := OS.get_environment("DOD_SIM_SPECS")
	if OS.get_environment("DOD_SIM_ROTATE") == "1":
		sw_specs = "rotating all twelve (DOD_SIM_ROTATE=1)"
	print("Zone roster: %s   Themes: %s   Specs: %s" % [
		zone if zone != "" else "1",
		theme if theme != "" else "all fight themes",
		sw_specs])
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
	# Batch W: the contribution block per budget — support specs measured
	# in something other than damage, sample counts beside every row.
	var sw_stale := 0
	for st_s in sweep_stats:
		sw_stale += int(st_s.get("stalemates", 0.0))
	if sw_stale > 0:
		print("STALEMATES force-ended: %d battles total (scored as losses)" % sw_stale)
	print("Contribution per budget (avg per battle present):")
	for i in sweep_stats.size():
		print("  budget %d:" % SWEEP_BUDGETS[i])
		print(_contrib_table(sweep_stats[i]))
	print("Sim time: %.1fs" % elapsed)
	print("=============================================\n")


# "Berserker 30% | Cryomancer 45% | ..." from one banked stats dict.
# Keys are sorted so every budget row lists heroes in the same order.
# Batch W: the denominator is the spec's own pool — the party damage of
# the battles that spec was IN. For a fixed party the pool equals the
# old stage total, so pre-W shares reproduce; under rotation it is the
# only denominator that means anything, and the sample count is printed
# beside it so a thin cell is visible as thin.
func _share_line(s: Dictionary) -> String:
	var total := 0.0
	var names: Array = []
	for key in s:
		if key.begins_with("dmg_hero_"):
			total += s[key]
			names.append(key)
	names.sort()
	var rotating := OS.get_environment("DOD_SIM_ROTATE") == "1"
	var parts := PackedStringArray()
	for key in names:
		var hero: String = key.trim_prefix("dmg_hero_")
		var pool: float = s.get("pool_dmg_hero_" + hero, 0.0)
		if pool <= 0.0:
			pool = total
		var part := "%s %.0f%%" % [hero, 100.0 * s[key] / maxf(pool, 1.0)]
		if rotating:
			part += " (n=%d)" % int(s.get("n_hero_" + hero, 0.0))
		parts.append(part)
	return " | ".join(parts)


# Batch W: the per-hero contribution block. dmg%/contrib% run against
# per-spec pools (the party's output over the battles that spec was in),
# so fixed and rotated parties read on the same 4-hero basis. "prev" is
# instrumented mitigation (blocks, barriers, stances, Faith...) — base
# armor and resists are deliberately not a contribution. "st" counts
# statuses landed on others where the applier is known.
func _contrib_table(s: Dictionary) -> String:
	var names: Array = []
	for key in s:
		if key.begins_with("n_hero_"):
			names.append(key.trim_prefix("n_hero_"))
	names.sort()
	var lines := PackedStringArray()
	lines.append("  hero               n   dmg/b  dmg%  heal/b  prev/b   BD/b  st/b  contrib%")
	for hero in names:
		var n: float = maxf(s.get("n_hero_" + hero, 0.0), 1.0)
		var dmg: float = s.get("dmg_hero_" + hero, 0.0)
		var heal: float = s.get("heal_hero_" + hero, 0.0)
		var prev: float = s.get("prev_hero_" + hero, 0.0)
		var bd: float = s.get("bd_hero_" + hero, 0.0)
		var st: float = s.get("st_hero_" + hero, 0.0)
		var dpool: float = maxf(s.get("pool_dmg_hero_" + hero, 0.0), 1.0)
		var apool: float = maxf(s.get("pool_all_hero_" + hero, 0.0), 1.0)
		lines.append("  %-16s %4d %7.0f %4.0f%% %7.0f %7.0f %6.0f %5.1f %7.0f%%" % [
			hero, int(n), dmg / n, 100.0 * dmg / dpool, heal / n, prev / n,
			bd / n, st / n, 100.0 * (dmg + heal + prev) / apool])
	var un: float = s.get("prev_hero_(unattributed)", 0.0)
	if un > 0.0:
		lines.append("  prevented, unattributed: %.0f/battle" % \
			(un / maxf(s.get("battles", 0.0), 1.0)))
	return "\n".join(lines)


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


# ---------- the run summary (Batch Z) ----------

# Everything the summary screen reports, captured while it still exists:
# clear_save() destroys the run save and the draft resets the party, so
# the snapshot is taken BEFORE either. Pure data — safe to hold across
# the clear and to serialize into the copy-out text.
# Queue one ability pick on every hero and return the names that got one,
# for the victory card. A hero whose SPEC pool is exhausted is silently
# skipped — the offer is rolled here, so "nothing left" is a fact the roll
# knows and the card never has to guess at. (Batch AN: spec pool only.)
func _award_ability_picks() -> Array:
	var named: Array = []
	for member in Run.party:
		if Run.award_ability_pick(member):
			named.append(_hero_label(member))
	return named


func _run_snapshot(outcome: String, closing_text: String) -> Dictionary:
	var fallen: Array = []
	for h in heroes:
		if h.dead and not h.is_companion:
			fallen.append(h.unit_name)
	var enemy_names: Array = []
	for kind in Run.encounter.get("enemies", []):
		enemy_names.append(Enemies.unit_name(String(kind)))
	return {
		"outcome": outcome,
		"closing_text": closing_text,
		"zone_num": Run.zone_idx + 1,
		"zone_name": Run.zone_name,
		"tier": clampi(Run.slot_idx + 1, 1, Run.SLOTS_PER_ZONE),
		"boss_name": Enemies.unit_name(Run.boss_kind()),
		"encounter_type": String(Run.encounter.get("type", "fight")),
		"encounter_theme": String(Run.encounter.get("theme", "Warband")),
		"enemy_names": enemy_names,
		"fallen": fallen,
		"party": Run.party.duplicate(true),
		"gold": Run.gold,
		"difficulty": Run.difficulty,
		"relics": Run.active_relics.duplicate(),
		"events_seen": Run.seen_events.size(),
		"combat_wins": Run.combat_wins,
		"tally": Run.tally.duplicate(true),
		"debug_used": Run.debug_used,
		# Chronicle: noted AFTER Profile booked this run, so the tally the
		# tester reads includes the run they just finished.
		"cycles_survived": Profile.completions_total(),
		"cycles_lost": Profile.wipes_total(),
		"cycles_abandoned": Profile.forfeits_total(),
	}


# One text for both surfaces: the on-screen panel renders it (with bbcode
# headers added) and the Copy button puts the plain version on the
# clipboard — every wipe becomes a report a tester can paste back.
func _summary_lines(snap: Dictionary) -> Array:
	var lines: Array = []
	var tally: Dictionary = snap.get("tally", {})
	# --- outcome and depth ---
	if snap["outcome"] == "complete":
		lines.append(["h", "THE DECAY RECEDES"])
		lines.append(["p", "Run complete — all %d zones cleansed (%s difficulty)." % [
			Run.SLOT_COUNT, snap["difficulty"]]])
	else:
		var depth := ""
		if snap["encounter_type"] == "boss":
			depth = "facing the %s" % snap["boss_name"]
		else:
			depth = "Tier %d of 10" % mini(int(snap["tier"]), 10)
		# Batch AA: a forfeit is reported as a forfeit. Folding it into the
		# wipe wording would poison every alpha wipe-rate a tester pastes back.
		if snap["outcome"] == "forfeit":
			lines.append(["h", "THE RUN IS ABANDONED"])
			lines.append(["p", "Forfeited — Zone %d (%s), %s (%s difficulty)." % [
				snap["zone_num"], snap["zone_name"], depth, snap["difficulty"]]])
			lines.append(["p", "Reason given: %s." % \
				String(snap.get("forfeit_reason", "not stated"))])
		else:
			lines.append(["h", "THE PARTY HAS FALLEN"])
			lines.append(["p", "Wiped — Zone %d (%s), %s (%s difficulty)." % [
				snap["zone_num"], snap["zone_name"], depth, snap["difficulty"]]])
	# The honesty flag (Batch AC), directly under the title so it cannot be
	# missed and cannot be scrolled past — and inserted into the SAME line
	# list the Copy button serialises, which is the half that actually
	# reaches feedback.
	if bool(snap.get("debug_used", false)):
		lines.insert(1, ["w",
			"DEBUG TOOLS WERE USED IN THIS RUN — not a clean data point."])
	# --- what ended it ---
	# A forfeit reports the same block: the fight the tester walked away
	# from is the most useful thing in the whole summary.
	if snap["outcome"] != "complete":
		var kind_label: String = {"fight": "A fight", "elite": "An ELITE fight",
			"miniboss": "The zone's MINI-BOSS",
			"boss": "The zone boss"}.get(snap["encounter_type"], "A fight")
		lines.append(["s", "The final battle"])
		lines.append(["p", "%s — %s: %s." % [kind_label, snap["encounter_theme"],
			", ".join(snap["enemy_names"])]])
		if not (snap["fallen"] as Array).is_empty():
			lines.append(["p", "Fallen: %s." % ", ".join(snap["fallen"])])
	elif String(snap.get("closing_text", "")) != "":
		lines.append(["s", "The final victory"])
		lines.append(["p", String(snap["closing_text"]).replace("\n\n", "\n")])
	# --- the party as it stood ---
	lines.append(["s", "The party as it stood"])
	for member in snap["party"]:
		lines.append(["p", _member_summary(member)])
	# --- damage share ---
	var dmg: Dictionary = tally.get("damage", {})
	var total := 0.0
	for hero_name in dmg:
		total += float(dmg[hero_name])
	if total > 0.0:
		lines.append(["s", "Damage share (whole run)"])
		var names: Array = dmg.keys()
		names.sort_custom(func(a, b): return float(dmg[a]) > float(dmg[b]))
		var parts := PackedStringArray()
		for hero_name in names:
			parts.append("%s %d%%" % [hero_name,
				int(round(100.0 * float(dmg[hero_name]) / total))])
		lines.append(["p", "  |  ".join(parts)])
	# --- the run economy ---
	lines.append(["s", "The run in numbers"])
	lines.append(["p", "Battles won: %d of %d   Elites taken: %d" % [
		snap["combat_wins"], int(tally.get("battles", 0)), int(tally.get("elites", 0))]])
	lines.append(["p", "Gold: %d earned in combat, %d spent at shops, %d unspent" % [
		int(tally.get("gold_earned", 0)), int(tally.get("gold_spent", 0)), snap["gold"]]])
	lines.append(["p", "Rests taken: %d   Events seen: %d" % [
		int(tally.get("rests", 0)), snap["events_seen"]]])
	if not (snap["relics"] as Array).is_empty():
		var relic_names := PackedStringArray()
		for id in snap["relics"]:
			relic_names.append(String(Relics.POOL.get(String(id), {}).get("name", id)))
		lines.append(["p", "Relics carried: %s" % ", ".join(relic_names)])
	# --- the chronicle ---
	lines.append(["s", "The chronicle"])
	var chronicle := "Cycles survived: %d   Cycles lost to the Decay: %d" % [
		int(snap["cycles_survived"]), int(snap["cycles_lost"])]
	# Forfeits are shown only once there are any — the counter never
	# advertises the escape hatch to a tester who has not used it.
	if int(snap.get("cycles_abandoned", 0)) > 0:
		chronicle += "   Cycles abandoned: %d" % int(snap["cycles_abandoned"])
	lines.append(["p", chronicle])
	return lines


# One party member, one line: class/spec, talent lane spread, runes, trophies.
func _member_summary(member: Dictionary) -> String:
	var spec := String(member.get("spec", ""))
	var spec_name: String = Classes.SPEC_INFO[spec]["name"] \
		if Classes.SPEC_INFO.has(spec) else String(member["key"]).capitalize()
	var text := "%s (%s)" % [spec_name, String(member["key"]).capitalize()]
	# Lane spread from the member's own tree: nodes owned per lane, in the
	# tree's lane order (the same derivation the Party screen uses).
	var learned: Dictionary = member.get("talents", {})
	var lane_counts := {}
	var lane_order: Array = []
	var node_count := 0
	for node in member.get("tree", []):
		var lane := String(node.get("lane", ""))
		if lane != "" and not lane_order.has(lane):
			lane_order.append(lane)
		if learned.has(node["id"]):
			node_count += 1
			if lane != "":
				lane_counts[lane] = int(lane_counts.get(lane, 0)) + 1
	if node_count > 0:
		var lane_parts := PackedStringArray()
		for lane in lane_order:
			if int(lane_counts.get(lane, 0)) > 0:
				lane_parts.append("%s %d" % [Talents.LANE_NAMES.get(lane, lane),
					lane_counts[lane]])
		text += " — %d talent%s (%s)" % [node_count, "" if node_count == 1 else "s",
			", ".join(lane_parts)]
	else:
		text += " — no talents learned"
	var rune_names := PackedStringArray()
	for rune in member.get("runes", []):
		rune_names.append(String(rune["name"]))
	if not rune_names.is_empty():
		text += "\n    Runes: %s" % ", ".join(rune_names)
	var earned: Array = member.get("bm_abilities", [])
	if not earned.is_empty():
		text += "\n    Earned abilities: %s" % ", ".join(earned)
	return text


func _summary_plain_text(snap: Dictionary) -> String:
	var out := PackedStringArray()
	out.append("=== DAWN OF DECAY — RUN SUMMARY ===")
	for line in _summary_lines(snap):
		match String(line[0]):
			"h":
				out.append(String(line[1]))
			"s":
				out.append("")
				out.append("-- %s --" % line[1])
			_:
				out.append(String(line[1]))
	return "\n".join(out)


func _show_run_summary(snap: Dictionary) -> void:
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.72)
	ui.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(center)
	var panel := PanelContainer.new()
	center.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var lines := _summary_lines(snap)
	var title_label := Label.new()
	title_label.text = String(lines[0][1])
	title_label.add_theme_font_size_override("font_size", 34)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if snap["outcome"] == "complete":
		title_label.add_theme_color_override("font_color", Color(0.95, 0.85, 0.45))
	elif snap["outcome"] == "forfeit":
		# Its own colour: abandoning a run is not the same event as dying in one.
		title_label.add_theme_color_override("font_color", Color(0.72, 0.68, 0.6))
	else:
		title_label.add_theme_color_override("font_color", Color(0.9, 0.45, 0.45))
	vbox.add_child(title_label)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(760, 470)
	vbox.add_child(scroll)
	var body := RichTextLabel.new()
	body.bbcode_enabled = true
	body.fit_content = true
	body.custom_minimum_size = Vector2(740, 0)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bb := PackedStringArray()
	for i in range(1, lines.size()):
		match String(lines[i][0]):
			"s":
				bb.append("\n[color=#d9b168][b]%s[/b][/color]" % lines[i][1])
			"w":
				bb.append("[color=#ff5aa0][b]%s[/b][/color]" % lines[i][1])
			_:
				bb.append(String(lines[i][1]))
	body.text = "\n".join(bb)
	scroll.add_child(body)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(row)
	var copy_btn := Button.new()
	copy_btn.text = "Copy summary"
	copy_btn.custom_minimum_size = Vector2(200, 44)
	copy_btn.pressed.connect(func():
		DisplayServer.clipboard_set(_summary_plain_text(snap))
		copy_btn.text = "Copied!")
	row.add_child(copy_btn)
	var new_run := Button.new()
	new_run.text = "New Run"
	new_run.custom_minimum_size = Vector2(200, 44)
	new_run.pressed.connect(_start_new_run)
	row.add_child(new_run)

	_end_action = _start_new_run
	var hint := Label.new()
	hint.text = "— Space for a new run —"
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
		# Batch W: battle-local slice of the contribution metrics — summed
		# into the per-spec share pools when this battle ends.
		if key.begins_with("dmg_hero_") or key.begins_with("heal_hero_") \
				or key.begins_with("prev_hero_"):
			_b_slice[key] = _b_slice.get(key, 0.0) + amount
	elif key.begins_with("dmg_hero_"):
		# Batch Z: real play banks hero damage for the run summary.
		_run_slice[key] = _run_slice.get(key, 0.0) + amount


# ---------- Batch W: the contribution ledger ----------

# One name for "whose contribution was that": a BattleUnit (companions
# route to their hunter — the beast's work is the Beastmaster's), a bare
# name string, or null. "" = an enemy — the caller banks nothing;
# "(unattributed)" = a real event whose owner the site couldn't name,
# reported as its own bucket rather than dropped (a known gap is useful,
# a silent one isn't).
func _contrib_name(owner) -> String:
	if owner is BattleUnit:
		var u: BattleUnit = owner
		if u.is_companion:
			if u.pack_master == null or not is_instance_valid(u.pack_master):
				return "(unattributed)"
			u = u.pack_master
		return u.unit_name if u.is_hero else ""
	if owner is String and String(owner) != "":
		return String(owner)
	return "(unattributed)"


# Damage prevented, credited to the hero whose ability, status, or roll
# turned it away. Instrumented at the mitigation sites that already
# compute a delta — base armor and resists are deliberately NOT counted
# (a stat block isn't a contribution; blocks, barriers, stances, Faith
# and friends are).
func _prev(owner, cut: float) -> void:
	if not sim or cut <= 0.0:
		return
	var name := _contrib_name(owner)
	if name != "":
		_stat("prev_hero_" + name, cut)


# Healing done, credited to the hero whose KIT produced it — lifesteal a
# debuff grants credits the debuffer, not the striker. Always feeds the
# old aggregate "healing" stat so that line stays comparable.
func _stat_heal(owner, amount: float) -> void:
	_stat("healing", amount)
	if not sim or amount <= 0.0:
		return
	var name := _contrib_name(owner)
	if name != "":
		_stat("heal_hero_" + name, amount)


# Break damage a hero sent at the meter — the pre-Constitution BD value,
# the same units ability text speaks in.
func _stat_bd(owner, amount: float) -> void:
	if not sim or amount <= 0.0:
		return
	var name := _contrib_name(owner)
	if name != "":
		_stat("bd_hero_" + name, amount)


# Barrier absorbs report through the unit callback (unit.gd can't reach
# the stats directly): credit the caster stamped on the barrier, else the
# unattributed bucket. Only hero-side barriers are the party's ledger.
func _on_barrier_prevented(src_name: String, absorbed: int, holder: BattleUnit) -> void:
	if holder.is_hero:
		_prev(src_name, float(absorbed))


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
