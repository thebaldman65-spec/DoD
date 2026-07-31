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

# Buff/Debuff keywords: a DEBUFF is any negative status, a BUFF any positive
# one. This registry backs talents that count debuffs (Dominant Presence,
# Iron Will — its chip updates live in _refresh_chips) and future dispels.
const DEBUFF_IDS := ["slow", "chilled", "frozen", "frostbite", "burn", "poison",
	"bleed", "sunder", "mocked", "stunned", "exposed", "cripple", "dazed",
	"bewitch", "psychosis", "decay", "ruin", "hysteria",
	"umbral_sigil", "elem_weak", "melted", "blind", "snared", "caught", "broken"]

var frame_size := 100      # square frame edge of this unit's sprite strips
var portrait_path := ""    # dedicated portrait art (falls back to a sheet crop)
var hero_key := ""         # class id ("warrior"...) — display name may be the spec
var walks_to_target := false  # real locomotion: walk to melee range and back
var counter_attacks := 0      # Counter Attack: answers a parry with a basic attack
var unit_name := ""
var is_hero := true
var max_hp := 100
var hp := 100
var attack := 100          # ability damage = ability % × this (scales per node)
var armor := 0.15          # fraction of damage blocked (0.25 = 25%)
var speed := 100.0         # 100 = average; higher acts more often
var stability := 100       # Break meter size (universal 0-100 scale)
var constitution := 100    # resistance to Break: incoming Pressure × 100/constitution
var pressure := 0
var resource_name := ""    # "Rage" or "Mana" (heroes only)
var resource := 0
var max_resource := 100
# Secondary class resource: Holy Cleric Mercy (0-5), Mage Arcane Resonance
# (0-5; 0-8 while Overcharge is active).
var second_resource_name := ""
var second_resource := 0
var second_max := 100
var passive_id := ""       # specialization passive hook (see battle.gd)
var crit_bonus := 0.0      # from talents
var parry_bonus := 0.0     # from talents
var parry_chance := -1.0   # spec stat-block base; -1 = role baseline (battle.gd)
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
var broken_extra_turns := 0 # Overpower holds the Broken window open longer
var dead := false
var next_time := 0.0        # position on the initiative timeline
var is_ranged := false      # ranged units can't be parried; Tripwire skips them
var is_boss := false        # bosses cannot be Stunned unless Broken
var enemy_role := ""        # "tank"/"support"/"damage" — heal-AI priorities
var is_companion := false   # Beastmaster summon: no turns, fights alongside
var companion_kind := ""    # "ursus" / "canis" / "aguila"
var companion: BattleUnit   # the Beastmaster's active summon (on the hunter)
var pack_master: BattleUnit  # the hunter this companion belongs to (on the beast)
var loyalty := {}           # Beastmaster: per-beast Loyalty stacks (on the hunter)
var bestial_hp_bonus := 0    # Bestial Wrath (Ursus): doubled health, reverted on expiry
var bestial_armor_bonus := 0.0
var vigor_hp_bonus := 0      # Spirit Bond perfect: +10% max health, reverted on expiry
# ---- Beastmaster lane-tree talents (Batch 30; set via cfg by setup()) ----
var wild_communion_ranks := 0  # Wild Communion: Loyalty step 5% -> +1.5%/rank
var unbroken_watch := 0      # +1 Loyalty on turns the beast took no damage
var loyalty_cap_bonus := 0   # Absolute Devotion: ceiling 5 -> 7
var devoted_fury := 0        # Bestial Wrath +1 turn per 2 Loyalty
var steadfast_bond := 0      # death halves Loyalty instead of zeroing
var ancient_pact := 0        # boon TRIPLED at 5; the beast is unhealable
var lone_bond := 0           # one beast per fight; starts 3, caps 8
var quick_whistle_ranks := 0 # swap cooldown -1/rank
var momentum_ranks := 0      # +8%/rank companion dmg per distinct beast fielded
var shared_devotion := 0     # summon/swap Loyalty goes to every beast
var herald := 0              # arrival effects strike an extra target
var menagerie := 0           # absent summoned beasts keep half their boon
var no_beast_left := 0       # beast death -> next summon free, no cooldown
var wild_rotation := 0       # swap has no cooldown; Loyalty caps at 2
var masters_aim_ranks := 0   # Quick Shot +6%/rank of Attack
var companion_hp_pct := 0.0  # Beast Within: +10%/rank companion max health
var deep_reserves_ranks := 0 # Spirit Bond +8%/rank max Mana
var instinctive := 0         # Hunter's Instinct empowers 5 shots
var symbiosis := 0           # companion strikes restore 2% max Mana
var vengeance := 0           # beast death -> inherit boon + 30% dmg, 5 turns
var lone_hunter := 0         # no companion: costs -40%, damage +25%
var one_soul := 0            # capstone: shared health pool, double Loyalty
var apex := 0                # capstone: extra Quick Shot strike, KC resets
var the_pack := 0            # capstone: deferred (coming soon)
var vengeance_kind := ""     # which boon Vengeance carries while it lasts
var kinds_summoned := {}     # beasts fielded this fight (Feral Momentum et al)
var free_summon := false     # No Beast Left: the next summon is free
var no_heals := false        # Ancient Pact: this beast rejects all healing
var soul_partner: BattleUnit = null  # One Soul: damage is split with them
var _soul_guard := false     # re-entry guard while splitting
var damaged_since_turn := false  # Unbroken Watch bookkeeping
# ---- Sharpshooter Focus + lane talents (Batch 32) ----
var last_attack_target: BattleUnit = null  # Focus: the enemy worked last turn
var lethal_eye_ranks := 0    # Executioner's Eye: crit mult 2.0 -> +0.1/rank
var consistent_aim := 0      # crits x1.5 again, +30% crit chance
var deep_focus := 0          # Focus cap 100 -> 150
var unwavering := 0          # switching targets halves Focus instead of zeroing
var perfect_form := 0        # crits grant +20 Focus
var tunnel_vision := 0       # +50% crit vs the worked target, -50% vs others
var bonecracker_ranks := 0   # +12%/rank damage vs Broken enemies
var opp_aim := 0             # Powershot Break scaling doubles
var sundering_shot := 0      # crits apply 15 Break damage
var exposed_nerve := 0       # crits apply Exposed 3t
var no_cover := 0            # attacks cannot be made to miss (bypass, not modifier)
var overkill := 0            # kill overflow carries to another enemy
var muscle_memory_ranks := 0 # Focus gain +10/rank
var opening_volley := 0      # start fights at 60 Focus
var follow_through := 0      # crits tick all cooldowns by 1
var second_nature := 0       # Hold Breath covers the next TWO attacks
var snap_shot := 0           # first ability each fight: free, no cooldown
var snap_used := false
var spray := 0               # single-target attacks echo to a random enemy at 50%
var one_shot := 0            # capstone: max-Focus Aimed Shot executes below 40%
var through_and_through := 0 # capstone: ignore ALL armor; crits refund Mana
var rapid_fire := 0          # capstone: 35% chance abilities skip their cooldown
# ---- Survivalist lane talents + trap state (Batch 33) ----
var potent_ranks := 0        # Potent Toxins: poison +1/rank per stack
var coated_blades := 0       # basic attacks apply Poison 2t
var virulence_ranks := 0     # poison applications add +1 stack/rank
var slow_acting := 0         # poison half tick, double turns, uncleansable
var creeping_death := 0      # poisoned deaths pass their stacks onward
var necrosis := 0            # poisoned enemies take +20% from ALL sources
var plague_bearer := 0       # turn start: a poisoned enemy spreads 3 stacks
var wire_ranks := 0          # Reinforced Wire: tripwire +10%/rank of Attack
var quick_rigging := 0       # Snare Trap cd -1 (payload) + snares Cripple
var cruel_ranks := 0         # traps deal +15%/rank damage
var snap_shut := 0           # tripwire also bites ranged attackers
var caught_fast := 0         # trap victims cannot be healed 3t
var bone_breaker := 0        # traps apply 30 Break damage
var deadfall_network := 0    # two traps may be active at once
var hit_and_run := 0         # applying a status grants Elusive 1t
var scavenger_ranks := 0     # +8%/rank max Mana on enemy death
var field_medic := 0         # turn start: cleanse 1 debuff from a random ally
var vulture := 0             # +30% vs enemies with 3+ different statuses
var ghillie := 0             # 40% less likely to be targeted while allies live
var improvised := 0          # first ability each fight starts no cooldown
var improvised_used := false
var epidemic := 0            # capstone: all enemies permanently Poisoned
var whole_forest := 0        # capstone: tripwire never expires, bites everything
var force_of_nature := 0     # capstone: Trapper bonus 20%/status, party-wide
var deadfall_armed := 0      # armed untargeted traps waiting to spring
var companion_hp_bonus := 0   # talents: extra HP for summoned companions
var companion_power := 0      # talents: extra damage on companion attacks
# Fixed-tree talent stats (0/0.0 = not learned). See talents.gd for sources.
var bleed_bonus := 0          # Savagery: extra Bleed on bleed-building abilities
var bloodrage_step_bonus := 0.0  # Unstoppable: adds to Blood Frenzy's 2%/step
var frenzy_floor := 0.0  # Blood Frenzy v2: half the peak bonus this battle
                         # (fraction; ratchets up, never resets mid-battle —
                         # units are built fresh each battle)
var scar_tissue_ranks := 0    # Scar Tissue: floor keeps 60/70/75% of the peak
var scent_ranks := 0          # Scent of Blood: +3%/rank damage per bleedout
var blood_tithe_ranks := 0    # Blood Tithe: 15/rank Rage per enemy bleedout
var arterial_ranks := 0       # Arterial Spray: 25%/rank buildup transfer
var deathwish_ranks := 0      # Deathwish: +6%/rank damage below 35% health
var bloodied_momentum_ranks := 0  # Bloodied Momentum: 15/rank Rage per kill
var second_wind := 0          # Second Wind: first drop below 25% grants 40 Rage
var second_wind_used := false
var exsanguination := 0       # capstone: 35% bleedouts, full buildup chains on
var undying_rage := 0         # capstone: below 25% cannot die, +50% damage
var undying_rage_used := false
var bleedouts_this_battle := 0  # enemies bled out so far (Scent of Blood)
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
var endurance_ranks := 0      # Endurance: +1%/rank armor per unhealed turn
var endurance_stacks := 0
var healed_externally := false
var iron_will_ranks := 0      # Iron Will: -4%/rank damage taken per own debuff
var sundering_ranks := 0      # Sundering: Crushing Blow BD splash to Adjacent
var tenacity := 0             # Tenacity: +5 max HP per Heavy Plating block
var tenacity_hp_gained := 0   # battle-long gains (excluded from the run save)
var rally := 0                # Rally: party +15% healing for 2t per HP block
var shield_mastery_ranks := 0 # Shield Mastery: Shieldwall grants +1 charge/rank
var plating_bonus := 0.0      # Heavy Plating v2: +8% Block per unblocked hit
                              # (cap +40%; any Block resets it; fresh per battle
                              # like frenzy_floor — units are built each battle)
# Warden lanes (Batch H). See talents.gd for the node text.
var plate_discipline_ranks := 0  # Plate Discipline: the plating climbs +3%/rank faster
var battered_ranks := 0       # Battered Not Broken: blocks shed 8/rank own Break
var provoke_ranks := 0        # Provoke: Mocking Blow taunts +1 foe/rank
var spite_ranks := 0          # Spite: attackers take 8%/rank of dealt damage back
var bruising_ranks := 0       # Bruising Guard: blocks deal 10/rank BD to the attacker
var grudge_ranks := 0         # Grudge: +6%/rank damage vs enemies he taunts
var rallying_stomp_ranks := 0 # Rallying Stomp: War Stomp refuels +5%/rank more
var bulwark_line_ranks := 0   # Bulwark Line: Interpose grants +1 charge/rank
var shared_vigil_ranks := 0   # Shared Vigil: allies -3%/rank damage while he's >50% HP
var steadfast_ranks := 0      # Steadfast: absorbs 15%/rank of a blow felling an ally
var immovable := 0            # Immovable (capstone): cannot be Broken
var immovable_noted := false  # one proc log per battle, not one per hit
var vengeful_guardian := 0    # Vengeful Guardian (capstone): first block each turn
var vengeful_ready := true    # answers with Crushing Blow; re-arms at his turn
var seasoned_def_bonus := 0.0 # Defensive Stance: deeper damage-taken cut
var seasoned_off_bonus := 0.0 # Aggressive Stance: bigger damage-dealt bonus
var stance := "aggressive"    # Swordmaster guard (aggressive|defensive), fresh each battle
# Swordmaster lanes (Batch F). See talents.gd for the node text.
var killing_edge_ranks := 0   # Killing Edge: +4%/rank crit while Aggressive
var overwhelm_ranks := 0      # Overwhelm: +3%/rank damage per debuff on the target
var tempo_ranks := 0          # Tempo: stance switch grants +10%/rank damage 1 turn
var bracing_ranks := 0        # Bracing: +8/rank Constitution while Defensive
var deflection := 0           # Deflection: parry works against ranged attacks
var pressure_point_ranks := 0 # Pressure Point: Pommel Strike +8/rank BD
var sunder_guard_ranks := 0   # Sunder Guard: Shatterpoint +8/rank BD
var no_quarter_ranks := 0     # No Quarter: Breaking an enemy grants 15/rank Rage
var punishment_ranks := 0     # Punishment: Overpower +15%/rank vs Broken
var off_balance_ranks := 0    # Off Balance: all damage +5%/rank vs Broken
var untouchable := 0          # Untouchable: Defensive parries negate + Pommel counter
var guard_breaker := 0        # Guard Breaker: Broken recovery refills the meter to 50
# Pyromancer tree (07-18). See talents.gd for the node text.
var accelerant_ranks := 0     # Accelerant: +1%/rank Burn tick strength
var pyromaniac_ranks := 0     # Pyromaniac: +1%/rank Inferno Master step
var supernova_ranks := 0      # Super Nova: +3%/rank Detonation crit
var invigorating_ranks := 0   # Invigorating Ashes: mana back on Burn ticks
var molten_ranks := 0         # Molten Core: less damage from burning enemies
var explosive_ranks := 0      # Explosive Force: fire crits extend Burn
var seeding_ranks := 0        # Seeding Embers: damage from burning deaths
var melt_ranks := 0           # Melt Armor: Burn ticks shred armor
var ashes_ranks := 0          # Ashes of Al'ar: chance to self-revive
var ashes_used := false       # the phoenix rises once per battle
var implosion_ranks := 0      # Implosion: Detonation can strike twice
var melted := 0.0             # armor shredded off THIS unit by Melt Armor
var burn_at_death := 0        # Burn turns left when this unit died (Seeding)
var seeding_consumed := false # Seeding Embers already harvested this corpse
var was_frozen := false       # has been Frozen this battle
# Cryomancer tree (07-20). See talents.gd for the node text.
var hungering_ranks := 0      # Hungering Cold: chilled enemies hit softer
var frostbite_ranks := 0      # Frostbite: crits land easier on Frozen
var piercing_ice_ranks := 0   # Piercing Ice: Ice Lance crit damage
var hypothermia_ranks := 0    # Hypothermia: chilled enemies take more
var frigid_ranks := 0         # Frigid Grip: deeper slow per stack
var frigid_bonus := 0.0       # stamped on VICTIMS when Chilled lands
var icy_veins_ranks := 0      # Icy Veins: Ice Lance kills empower the next
var icy_veins_charge := 0.0   # the armed bonus for the next Ice Lance
var splinter_ranks := 0       # Splintering Shards: Razor Ice extra target
var whiteout_ranks := 0       # Whiteout: Blizzard can Daze
var freezing_ranks := 0       # Freezing Advance: Rime spreads sting
var emp_frostbolt_ranks := 0  # Empowered Frostbolt: bigger basic bolt
# Arcanist rework + tree (07-20). See talents.gd for the node text.
var overcharged := false      # Overcharge is active (max Resonance 8)
var overcharge_mult := 1.5    # weight of stacks 6-8 (1.65 on a perfect cast)
var mindfulness_ranks := 0    # Mindfulness: periodic extra cooldown tick
var mindfulness_counter := 0
var arcane_mastery_ranks := 0 # Arcane Mastery: +1%/rank crit per stack
var mana_attune_ranks := 0    # Mana Attunement: mana per stack gained
var on_edge_ranks := 0        # On the Edge: stacks from surviving low hits
var conversion_ranks := 0     # Conversion: damage partly paid in Mana
var critical_mass_ranks := 0  # Critical Mass: every 3rd crit hits harder
var crit_streak := 0          # crits since the last Critical Mass proc
var temporal_ranks := 0       # Temporal Rift: crits can echo
var suppressing_ranks := 0    # Suppressing Fire: Barrage bolts ramp
var stable_ranks := 0         # Stable Alignment: single-hit damage cap
var unlimited_ranks := 0      # Unlimited Power: overflow → dmg + max Mana
var unlimited_surges := 0     # overflow procs banked this battle
# Holy tree (07-22). See talents.gd for the node text.
var triage_ranks := 0         # Triage: instant heals can crit, +3%/rank healing
var heavenly_ranks := 0       # Heavenly Aura: deeper Mercy stack bonus
var holy_light_ranks := 0     # Holy Light: mana back on perfect casts
var guardian_ranks := 0       # Guardian Angel: wider Mercy window
var mercy_threshold := 0.5    # party-wide stamp (Guardian Angel raises it)
var divine_presence_ranks := 0 # Divine Presence: end-of-turn drip heal
var last_hope_ranks := 0      # Last Hope: the nearly-dead heal deeper
var last_hope_bonus := 0      # party-wide stamp (receiver side of Last Hope)
var capacitor_ranks := 0      # Holy Capacitor: overheal banks for next Heal
var stored_overheal := 0      # the banked amount (released by Heal)
var last_overheal := 0        # overheal of the most recent heal_amount call
var on_mend_ranks := 0        # On the Mend: Renewal ticks can dispel
var sanctified_ranks := 0     # Sanctified: Mercy spends can refund
# Holy tree v2 (Batch J, 07-30). See talents.gd for the node text.
var cascade_ranks := 0        # Radiant Cascade: crit heals splash onward
var overflow_ranks := 0       # Overflow: overhealing spills onward
var zealous_mercy := 0        # Zealous Light: battle-opening Mercy
var ardor_ranks := 0          # Ardor: held Mercy makes Empower free
var mercy_cap_bonus := 0      # Martyr's Vigor: Mercy ceiling 5 -> 6 -> 7
var vestments_ranks := 0      # Blessed Vestments: Renewal bearers take less
var beacon_ranks := 0         # Beacon: turn-start pulse on the nearly-dead
var serenity := 0             # Serenity: the Cleric's rank (spawn stamps it)
var serenity_guard := false   # party-wide stamp: one lethal save is banked
var avatar_of_mercy := 0      # capstone: Mercy per turn, Empower free
var living_sanctum := 0       # capstone: single-ally heals echo party-wide
# Devout Conviction + tree (07-23). See talents.gd for the node text.
var faith_stacks := 0         # Conviction: per-ALLY Faith (0-5)
var communion_ranks := 0      # Communion: 5-stack procs can spread
var faithful_ranks := 0       # Blessed are the Faithful: bigger 5-stack heal
var devoutness_ranks := 0     # Devoutness: party-wide BD cut (ex-passive)
var afterglow_ranks := 0      # Afterglow: heal when Divine Shield breaks
var covenant_ranks := 0       # Sacred Covenant: lethal-save heal + Faith
var aegis_ranks := 0          # Radient Aegis: Divine Shield can echo
var blessed_barrier_ranks := 0 # Blessed Barrier: absorbs convert to healing
var waters_ranks := 0         # Cleansing Waters: Resolve can cleanse
var pulse_ranks := 0          # Healing Pulse: Resolve drips party healing

# Barrier-lethal hook (set by the battle scene): fires when a Divine
# Shield absorbs a hit that would otherwise have killed this unit.
var lethal_saved_cb := Callable()
# Conviction hook: fires whenever a Divine Shield barrier absorbs damage
# for this unit (the only source of Faith).
var shield_absorbed_cb := Callable()

# Occultist tree (07-24). See talents.gd for the node text.
var emp_hex_ranks := 0        # Empowered Hex: Hex can apply Decay
var soul_leech_ranks := 0     # Soul Leech: deeper Ruin lifesteal
var pleasure_ranks := 0       # Pleasure from Pain: heals per unique debuff
var channeling_ranks := 0     # Corrupted Channeling: crippled attackers feed
var murderous_ranks := 0      # Murderous Intent: bewitched kills heal
var invigoration_ranks := 0   # Invigoration: Dark Pact mana regen
var spread_ranks := 0         # Spread of Madness: Psychosis is contagious
var infusion_ranks := 0       # Dark Infusion: attack per unique debuff
var mirror_ranks := 0         # Umbral Mirror: enemy debuffs can reflect
var broken_will_ranks := 0    # Broken Will: more Break damage dealt

# Active statuses: {id, label, short, color, turns}
var statuses: Array = []

# Battle-log hook (set by the battle scene) so talent procs that happen
# inside this unit (Enraged, Unrelenting Assault) reach the combat log.
var log_proc := Callable()

# Mercy hook (set by the battle scene on heroes): fires when this unit
# crosses below 50% health, from any damage source.
var below_half_cb := Callable()
# Serenity hook (set by the battle scene alongside serenity_guard): fires
# when the guard saves this unit, so the battle can spend it party-wide.
var serenity_cb := Callable()


# The threshold is 50% by default; Guardian Angel stamps a higher one on
# the whole party at spawn.
func _check_below_half(was_above: bool) -> void:
	if is_hero and not is_companion and was_above \
			and hp <= max_hp * mercy_threshold and below_half_cb.is_valid():
		below_half_cb.call(self)


func _proc_log(text: String) -> void:
	if log_proc.is_valid():
		log_proc.call(text, "#b0a8e0")


func count_debuffs() -> int:
	var n := 0
	for s in statuses:
		if DEBUFF_IDS.has(s.id):
			n += 1
	return n

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
	# Hovering the plate also answers "what hurts this thing": the unit's
	# resist/vulnerability card (static snapshot — live shreds like
	# Elemental Weakness stay on their status chips).
	_plate_panel.tooltip_text = resist_summary()
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
		var res2_color := Color(0.95, 0.80, 0.30) if second_resource_name == "Mercy" \
			else (Color(0.55, 0.85, 0.40) if second_resource_name == "Focus" \
			else Color(0.75, 0.40, 0.95))
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
# The hover card: what this unit shrugs off and what cuts deep. Reads the
# final resists dict (weaknesses already folded in as negative values).
func resist_summary() -> String:
	var hard := PackedStringArray()
	var soft := PackedStringArray()
	for dtype in resists:
		var v := float(resists[dtype])
		if v > 0.005:
			hard.append("%s %d%%" % [String(dtype).capitalize(), int(round(v * 100.0))])
		elif v < -0.005:
			soft.append("%s +%d%%" % [String(dtype).capitalize(), int(round(-v * 100.0))])
	if hard.is_empty() and soft.is_empty():
		return "%s\nNo resistances." % unit_name
	var text := unit_name
	if not hard.is_empty():
		text += "\nResists: %s" % ", ".join(hard)
	if not soft.is_empty():
		text += "\nVulnerable: %s damage taken" % ", ".join(soft)
	return text


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
	# While picking a target, hovering a body shows its resist card too.
	_target_btn.tooltip_text = resist_summary()
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
			# Overcharge weights stacks 6-8 harder — show the true bonus.
			var eff := float(second_resource)
			if overcharged and second_resource > 5:
				eff = 5.0 + (second_resource - 5.0) * overcharge_mult
			_res2_text.text = "%d/%d (+%d%% dmg)" % [second_resource, second_max,
				int(round(eff * 15.0))]
		else:
			_res2_text.text = "%s %d/%d" % [second_resource_name, second_resource, second_max]
	if passive_id == "bloodrage":
		for s in statuses:
			if s.id == "spec_passive":
				var step := 2.0 + bloodrage_step_bonus
				var live := frenzy_bonus() * 100.0
				var floor_pct := frenzy_floor * 100.0
				# Scar Tissue rewrites how much of the peak the floor keeps.
				var keep_pct: int = [50, 60, 70, 75][clampi(scar_tissue_ranks, 0, 3)]
				s.short = "+%d%% (floor %d%%)" % [int(round(live)),
					int(round(floor_pct))]
				s.desc = "Blood Frenzy: +%.1f%% damage per 5%% HP missing.\nCurrently +%.1f%%. The floor — %d%% of the highest\nbonus reached this battle — is +%.1f%%\nand never falls." % [
					step, live, keep_pct, floor_pct]
				_refresh_chips()
				break
	# Heavy Plating chip shows the LIVE total Block chance — the whole value
	# of the pity ramp is the player watching it climb toward the next Block.
	if passive_id == "heavy_plating":
		for s in statuses:
			if s.id == "spec_passive":
				var total := (block_chance + 0.15 + plating_bonus) * 100.0
				s.short = "Block %d%%" % int(round(total))
				s.desc = "Heavy Plating: +15%% Block chance on top of the\n%d%% base. Every unblocked attack adds +8%% for the\nrest of the battle (now +%d%%, cap +40%%); Blocking\nresets the bonus. Total Block chance: %d%%." % [
					int(round(block_chance * 100.0)),
					int(round(plating_bonus * 100.0)), int(round(total))]
				_refresh_chips()
				break
	# Seasoned Fighter chip shows which guard is live; the tooltip carries
	# both stances' numbers so the swap is an informed choice.
	if passive_id == "seasoned":
		for s in statuses:
			if s.id == "spec_passive":
				var aggressive := stance == "aggressive"
				var off_pct := int(round((0.15 + seasoned_off_bonus) * 100))
				var def_pct := int(round((0.15 + seasoned_def_bonus) * 100))
				s.short = "AGG" if aggressive else "DEF"
				s.desc = "Seasoned Fighter — current stance: %s.\nAGGRESSIVE: +%d%% damage dealt, +10%% damage taken.\nDEFENSIVE: %d%% less damage taken, -10%% damage dealt.\nGuard Change swaps (battles open Aggressive)." % [
					"AGGRESSIVE" if aggressive else "DEFENSIVE", off_pct, def_pct]
				_refresh_chips()
				break
	var pressure_ratio := clampf(pressure / float(stability), 0.0, 1.0)
	_pressure_fill.size.x = PLATE_BAR_W * pressure_ratio
	_pressure_text.text = "Break %d/%d" % [pressure, stability]
	# Shifts toward hot pink as the unit gets close to Breaking.
	_pressure_fill.color = Color(0.80, 0.35, 1.0).lerp(Color(1.0, 0.25, 0.55), pressure_ratio)


# ---------- status effects ----------

# Adds (or refreshes) a status. `short` is the 1-2 char tag shown on the chip.
# `tick` = damage per turn for DoTs, snapshotted from the applier's Attack.
func add_status(id: String, label: String, short: String, color: Color, turns: int,
		desc := "", power := 0, tick := 0) -> void:
	for s in statuses:
		if s.id == id:
			# Poison stacks additively (each stack ticks again) and every
			# new application refreshes the timer (and the tick snapshot).
			if id == "poison":
				s.stacks = int(s.get("stacks", 1)) + 1
				s.turns = turns
				if tick > 0:
					s["tick"] = tick
				s.short = "P%d" % s.stacks
				s.desc = "Takes %d nature damage at the start of each\nturn (%d per stack); new stacks refresh the timer." % [
					int(s.get("tick", 3)) * s.stacks, int(s.get("tick", 3))]
				float_text("%s x%d" % [label, s.stacks], color)
			elif id == "chilled":
				# Chilled STACKS (max 4): each application adds a stack and
				# RESETS the clock; 4 stacks = Frozen (handled by battle.gd).
				s.stacks = mini(int(s.get("stacks", 1)) + 1, 4)
				s.turns = turns
				s.short = "C%d" % s.stacks
				s.desc = _chilled_desc(int(s.stacks))
				float_text("Chilled x%d" % s.stacks, color)
			elif id == "ruin":
				# Ruin STACKS (max 5, battle-long): the Old Gods' mark deepens.
				s.stacks = mini(int(s.get("stacks", 1)) + 1, 5)
				s.short = "R%d" % s.stacks
				s.desc = "Marked by the Old Gods: takes %d%% more\ndamage; heroes striking this unit heal.\nAt 5 stacks Ruin detonates on this\nunit's next turn." % (2 * int(s.stacks))
				float_text("Ruin x%d" % s.stacks, color)
			elif id == "burn":
				# Reapplied Burn burns LONGER: the fresh application's turns
				# are ADDED to the running timer.
				s.turns += maxi(turns, 0)
				s.power = maxi(s.power, power)
				if tick > 0:
					s["tick"] = tick
				float_text("Burn +%d turns" % turns, color)
			else:
				s.turns = maxi(s.turns, turns)
				s.power = maxi(s.power, power)
				if tick > 0:
					s["tick"] = tick
			_refresh_chips()
			return
	var entry := {"id": id, "label": label, "short": short, "color": color,
		"turns": turns, "desc": desc, "power": power, "stacks": 1, "tick": tick}
	if id == "poison":
		entry["fresh"] = true  # no tick on the turn it lands
	if id == "chilled":
		entry["short"] = "C1"
		entry["desc"] = _chilled_desc(1)
	statuses.append(entry)
	float_text(label, color)
	_refresh_chips()


static func _chilled_desc(stacks: int) -> String:
	var effect := "-25% speed"
	if stacks == 2:
		effect = "-50% speed"
	elif stacks >= 3:
		effect = "-50% speed, -15% damage dealt"
	return "Chilled x%d: %s.\nEach stack resets the 3-turn clock;\nat 4 stacks the victim FREEZES solid." % [
		stacks, effect]


func remove_status(id: String) -> void:
	statuses = statuses.filter(func(s): return s.id != id)
	_refresh_chips()


# On the Mend: strip ONE random harmful status (Broken excluded).
# Returns the removed status label, or "" if nothing was dispellable.
func dispel_one_debuff() -> String:
	var candidates: Array = []
	for s in statuses:
		if s.id != "broken" and DEBUFF_IDS.has(s.id):
			candidates.append(s)
	if candidates.is_empty():
		return ""
	var pick: Dictionary = candidates.pick_random()
	remove_status(pick.id)
	return pick.label


# Cleanse: strip every harmful status. Broken stays — it's a Break-meter
# state, not a dispellable status. Returns how many were removed.
func purge_debuffs() -> int:
	# Sticky statuses (Slow Acting / Epidemic poison) refuse every cleanse.
	var before := statuses.size()
	statuses = statuses.filter(
		func(s): return s.id == "broken" or s.get("sticky", false) \
			or not DEBUFF_IDS.has(s.id))
	_refresh_chips()
	return before - statuses.size()


# Updates a live status chip's tag and tooltip (and optionally its power /
# remaining turns) without re-announcing it — for chips that show a counter,
# like Shieldwall charges or Battle Shout's damage bonus.
# Returns false if the status isn't active.
func update_status(id: String, short: String, desc: String, power := -1,
		turns := 0) -> bool:
	for s in statuses:
		if s.id == id:
			s.short = short
			s.desc = desc
			if power >= 0:
				s.power = power
			if turns > 0:
				s.turns = turns
			_refresh_chips()
			return true
	return false


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
	# Unrelenting Assault: the borrowed Constitution fades with the buff.
	for s in statuses:
		if s.id == "unrelenting" and s.turns == 0:
			constitution -= int(s.get("power", 0))
			float_text("Unrelenting fades", Color(0.6, 0.65, 0.8))
	# Expiries reach the combat log so timers are auditable at a glance.
	for s in statuses:
		if s.turns == 0 and s.id != "broken":
			_proc_log("   → %s fades from %s" % [s.label, unit_name])
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
			remove_status("enraged")
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
	var s := speed * (0.75 if has_status("slow") else 1.0)
	# Chilled deepens with stacks: 1 = -25% speed, 2+ = -50% (Frigid Grip
	# stamps its extra slow on the victim when the stack lands).
	var chill := status_stacks("chilled") if has_status("chilled") else 0
	if chill == 1:
		s *= 0.75 - frigid_bonus
	elif chill >= 2:
		s *= maxf(0.5 - frigid_bonus, 0.1)
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
	# Endurance: +1%/rank armor per turn without an external heal.
	a += 0.01 * endurance_ranks * endurance_stacks
	# Melt Armor: Burn ticks have eaten this much off for the battle.
	a = maxf(a - melted, 0.0)
	if has_status("fortify"):
		a += 0.10
	# Bulwark of Fortitude: the unbreakable stand (+50% of current armor).
	if has_status("bulwark"):
		a *= 1.5
	if broken:
		a *= 0.7
	if has_status("sunder"):
		a *= 0.65
	return minf(a, 0.85)


func _refresh_chips() -> void:
	# Iron Will's chip tracks the live debuff count (this runs on every
	# status change, so the readout can never go stale).
	if iron_will_ranks > 0:
		for s in statuses:
			if s.id == "iron_will":
				var n := count_debuffs()
				var pct := 4 * iron_will_ranks * n
				s.short = "-%d%%" % pct
				s.desc = "Iron Will: takes 4%% less damage per rank\nfor every debuff on the Warden.\nCurrently -%d%% (%d debuff%s)." % [
					pct, n, "" if n == 1 else "s"]
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
# Blood Frenzy v2 (Berserker passive): +step per full 5% of health
# missing, with a RATCHETING FLOOR — half the highest bonus reached
# this battle; the live bonus never drops below it. Returns the bonus
# as a fraction (0.14 = +14%) and ratchets as a side effect: called
# where damage is read AND after every hit taken, so a dive that gets
# healed away before his next attack still banks its floor.
func frenzy_bonus() -> float:
	var step := (2.0 + bloodrage_step_bonus) / 100.0
	var current := int((1.0 - hp / float(max_hp)) * 100.0 / 5.0) * step
	# Scar Tissue: the floor keeps 60/70/75% of the peak instead of half.
	var keep: float = [0.5, 0.6, 0.7, 0.75][clampi(scar_tissue_ranks, 0, 3)]
	if current * keep > frenzy_floor:
		frenzy_floor = current * keep
		if scar_tissue_ranks > 0:
			_proc_log("Talent: Scar Tissue — %s's Frenzy floor scars in at +%d%%" % [
				unit_name, int(round(frenzy_floor * 100.0))])
	return maxf(current, frenzy_floor)


func take_hit(amount: int, pressure_add: int) -> Dictionary:
	if amount > 0:
		damaged_since_turn = true  # Unbroken Watch bookkeeping
	# One Soul (Beastmaster capstone): all damage to either half of the
	# bond is split evenly between hunter and beast.
	if amount > 1 and not _soul_guard and soul_partner != null \
			and is_instance_valid(soul_partner) and not soul_partner.dead \
			and not dead:
		var shared: int = amount / 2
		amount -= shared
		soul_partner._soul_guard = true
		soul_partner.take_hit(shared, 0)
		soul_partner._soul_guard = false
		float_text("Soul-split", Color(0.75, 0.6, 0.95))
		_proc_log("One Soul: %s shares %d of the wound with %s" % [
			unit_name, shared, soul_partner.unit_name])
	# Barrier absorbs damage (not Pressure) before HP is touched. Divine
	# Shield barriers carry talent riders: Blessed Barrier (absorbs heal),
	# Sacred Covenant (lethal saves reward), Afterglow (heal on break).
	for s in statuses:
		if s.id == "barrier" and s.power > 0:
			var would_have_died := amount >= hp
			var absorbed: int = mini(s.power, amount)
			amount -= absorbed
			s.power -= absorbed
			float_text("Absorbed %d" % absorbed, Color(0.4, 0.85, 0.95))
			var bb_pct := float(s.get("blessed_pct", 0.0))
			if bb_pct > 0.0 and absorbed > 0:
				var bb_heal := maxi(int(round(absorbed * bb_pct)), 1)
				heal_amount(bb_heal)
				float_text("+%d" % bb_heal, Color(0.4, 0.9, 0.45))
				_proc_log("Talent: Blessed Barrier — %s converts %d absorbed into healing" % [
					unit_name, bb_heal])
			# Conviction: only Divine Shield absorbs build Faith.
			if absorbed > 0 and s.get("divine", false) \
					and shield_absorbed_cb.is_valid():
				shield_absorbed_cb.call(self)
			if would_have_died and amount < hp and lethal_saved_cb.is_valid():
				lethal_saved_cb.call(self)
			if s.power <= 0:
				var glow := int(s.get("afterglow", 0))
				remove_status("barrier")
				if glow > 0:
					var glow_got := heal_amount(glow)
					float_text("+%d" % glow_got, Color(0.95, 0.9, 0.6))
					_proc_log("Talent: Afterglow — the breaking shield mends %s for %d" % [
						unit_name, glow_got])
			break
	# Conversion (Arcanist talent): part of the pain bleeds off as Mana.
	if conversion_ranks > 0 and resource_name == "Mana" and amount > 0:
		var converted := mini(int(round(amount * 0.10 * conversion_ranks)), resource)
		if converted > 0:
			amount -= converted
			resource -= converted
			float_text("-%d Mana" % converted, Color(0.5, 0.7, 1.0))
			_proc_log("Talent: Conversion — %s pays %d of the hit in Mana" % [
				unit_name, converted])
	# Stable Alignment (Arcanist talent): one attack can only cut so deep.
	if stable_ranks > 0 and amount > 0:
		var stable_cap := maxi(int(round(max_hp * (0.40 - 0.05 * stable_ranks))), 1)
		if amount > stable_cap:
			float_text("ALIGNED -%d" % (amount - stable_cap), Color(0.75, 0.7, 0.95))
			_proc_log("Talent: Stable Alignment — the hit is capped at %d (%d%% max HP)" % [
				stable_cap, 40 - 5 * stable_ranks])
			amount = stable_cap
	var was_above_half := hp > max_hp * 0.5
	var was_above_quarter := hp > max_hp * 0.25
	var was_below_deathwish := hp < max_hp * 0.35
	var was_above_mercy := hp > max_hp * mercy_threshold
	hp = maxi(hp - amount, 0)
	_check_below_half(was_above_mercy)
	# Hold the Line: the party cannot die while the blessing holds.
	if hp == 0 and has_status("undying"):
		hp = 1
		float_text("HELD THE LINE", Color(0.95, 0.85, 0.4))
	# Undying Rage (capstone): once per battle, death itself is refused —
	# the killing hit ends the rage at 1 HP.
	if hp == 0 and undying_rage > 0 and not undying_rage_used:
		undying_rage_used = true
		hp = 1
		float_text("UNDYING RAGE", Color(0.95, 0.25, 0.2), true)
		_proc_log("Capstone: Undying Rage — %s refuses to die (1 HP; the rage ends)" % unit_name)
	# Ashes of Al'ar: the phoenix may refuse the grave (once per battle).
	if hp == 0 and ashes_ranks > 0 and not ashes_used \
			and randf() < 0.11 * ashes_ranks:
		ashes_used = true
		hp = maxi(int(max_hp * 0.25), 1)
		float_text("REBORN IN ASH", Color(1.0, 0.6, 0.2), true)
		_proc_log("Talent: Ashes of Al'ar — %s rises from the ashes (25%% HP)" % unit_name)
	# Serenity (Holy talent): the party's last net, after a unit's own
	# saves — once per battle, the first lethal blow lands at 1 HP. The
	# battle scene spends the guard party-wide via the callback.
	if hp == 0 and serenity_guard and serenity_cb.is_valid():
		hp = 1
		float_text("SERENITY", Color(0.95, 0.9, 0.55), true)
		serenity_cb.call(self)
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	# Enraged (talent): dropping below half HP grants a stacking damage buff,
	# shown as a chip that tracks the current bonus.
	if enraged_ranks > 0 and was_above_half and hp <= max_hp * 0.5 and hp > 0:
		enraged_stacks = mini(enraged_stacks + 1, 3)
		enraged_timer = 5
		var enr_pct := 3 * enraged_ranks * enraged_stacks
		var enr_desc := "Enraged: +3%% damage per rank per stack,\ngained by dropping below half health\n(max 3 stacks). Currently +%d%% (x%d)." % [
			enr_pct, enraged_stacks]
		if update_status("enraged", "+%d%%" % enr_pct, enr_desc, -1, 5):
			float_text("ENRAGED x%d" % enraged_stacks, Color(0.9, 0.35, 0.3))
		else:
			add_status("enraged", "Enraged", "+%d%%" % enr_pct,
				Color(0.9, 0.35, 0.3), 5, enr_desc)
		_proc_log("Talent: Enraged — %s rages (+%d%% damage, stack %d)" % [
			unit_name, enr_pct, enraged_stacks])
	# Unrelenting Assault (talent): dropping below 25% HP grants Constitution
	# for 3 turns (at most once every 5 turns).
	if unrelenting_ranks > 0 and was_above_quarter and hp <= max_hp * 0.25 \
			and hp > 0 and unrelenting_cd == 0:
		var con_gain := 10 * unrelenting_ranks
		constitution += con_gain
		unrelenting_cd = 5
		add_status("unrelenting", "Unrelenting Assault", "+%d" % con_gain,
			Color(0.7, 0.8, 0.95), 3,
			"Unrelenting Assault: +%d Constitution for\n3 turns (gained by dropping below 25%%\nhealth; at most once every 5 turns)." % con_gain,
			con_gain)
		float_text("+%d Constitution" % con_gain, Color(0.7, 0.8, 0.95))
		_proc_log("Talent: Unrelenting Assault — %s gains +%d Constitution (3 turns)" % [
			unit_name, con_gain])
	# Second Wind (talent): the first dive below 25% each battle becomes
	# a turn, not just a scare.
	if second_wind > 0 and not second_wind_used and was_above_quarter \
			and hp <= max_hp * 0.25 and hp > 0:
		second_wind_used = true
		resource = mini(resource + 40, max_resource)
		float_text("SECOND WIND +40 Rage", Color(1.0, 0.5, 0.4))
		_proc_log("Talent: Second Wind — %s surges back (+40 Rage)" % unit_name)
	# Deathwish (talent): crossing under 35% health, the edge sharpens.
	if deathwish_ranks > 0 and not was_below_deathwish \
			and hp < max_hp * 0.35 and hp > 0:
		float_text("DEATHWISH +%d%%" % (6 * deathwish_ranks), Color(0.9, 0.3, 0.3))
		_proc_log("Talent: Deathwish — %s deals +%d%% damage below 35%% health" % [
			unit_name, 6 * deathwish_ranks])
	# Mana Shield: half the pain flows back as Mana.
	if has_status("mana_shield") and resource_name == "Mana" and amount > 0:
		var converted := maxi(int(amount * 0.5), 1)
		resource = mini(resource + converted, max_resource)
		float_text("+%d Mana" % converted, Color(0.5, 0.7, 1.0))
	# Constitution: break resistance (100 = neutral; higher takes less Pressure).
	# Bracing (Swordmaster talent): the raised guard is harder to Break.
	var eff_con := constitution + ((8 * bracing_ranks) if stance == "defensive" else 0)
	pressure_add = int(round(pressure_add * 100.0 / maxf(eff_con, 1.0)))
	if has_status("ward"):
		pressure_add = int(pressure_add * 0.5)
	# Devoutness (talent, ex-Devotion Aura): power carries the % cut.
	if has_status("devotion"):
		pressure_add = int(pressure_add * (1.0 - status_power("devotion") / 100.0))
	if has_status("hold_bd"):
		pressure_add = int(pressure_add * 0.5)
	# Bulwark of Fortitude: NO Break damage while the stand holds.
	if has_status("bulwark"):
		pressure_add = 0
	# Immovable (Warden capstone): he cannot be Broken, ever.
	if immovable > 0 and pressure_add > 0:
		if not immovable_noted:
			immovable_noted = true
			_proc_log("Capstone: Immovable — %s cannot be Broken" % unit_name)
		pressure_add = 0
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
	# Blood Frenzy v2: every hit taken banks its floor immediately.
	if passive_id == "bloodrage" and not dead:
		frenzy_bonus()
	refresh_bars()
	return {"died": dead, "broke": just_broke, "bd": applied_bd}


# Damage from DoT effects (Burn). No Pressure, no hurt animation. Returns true on death.
func take_tick_damage(amount: int, label: String, color: Color) -> bool:
	var tick_was_above := hp > max_hp * mercy_threshold
	hp = maxi(hp - amount, 0)
	_check_below_half(tick_was_above)
	if hp == 0 and has_status("undying"):
		hp = 1
		float_text("HELD THE LINE", Color(0.95, 0.85, 0.4))
	if hp == 0 and undying_rage > 0 and not undying_rage_used:
		undying_rage_used = true
		hp = 1
		float_text("UNDYING RAGE", Color(0.95, 0.25, 0.2), true)
		_proc_log("Capstone: Undying Rage — %s refuses to die (1 HP; the rage ends)" % unit_name)
	if hp == 0 and ashes_ranks > 0 and not ashes_used \
			and randf() < 0.11 * ashes_ranks:
		ashes_used = true
		hp = maxi(int(max_hp * 0.25), 1)
		float_text("REBORN IN ASH", Color(1.0, 0.6, 0.2), true)
		_proc_log("Talent: Ashes of Al'ar — %s rises from the ashes (25%% HP)" % unit_name)
	# Serenity (Holy talent): the net catches tick deaths too.
	if hp == 0 and serenity_guard and serenity_cb.is_valid():
		hp = 1
		float_text("SERENITY", Color(0.95, 0.9, 0.55), true)
		serenity_cb.call(self)
	# Blood Frenzy v2: tick-driven dives bank their floor too.
	if passive_id == "bloodrage" and not dead:
		frenzy_bonus()
	float_text(label, color)
	if hp <= 0:
		_die()
	refresh_bars()
	return dead


func _die() -> void:
	dead = true
	broken = false
	broken_pending = false
	broken_extra_turns = 0
	# Unrelenting's borrowed Constitution can't outlive its buff (revives).
	var ua := get_status("unrelenting")
	if not ua.is_empty():
		constitution -= int(ua.get("power", 0))
	# Seeding Embers reads the Burn this unit died with (harvested later).
	var burn_stat := get_status("burn")
	if not burn_stat.is_empty():
		burn_at_death = maxi(int(burn_stat.get("turns", 0)), 0)
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
	broken_extra_turns = 0
	pressure = 0
	modulate = Color.WHITE
	remove_status("broken")
	refresh_bars()


# Heals respect Holy Conduit (healing_received_mult), the Rally blessing
# (+15% while Rallied), and Frostbite (-50%). `external` marks heals from
# another unit or an item — the Warden's Endurance talent resets on them.
# Returns the healing that actually landed (after multipliers).
func heal_amount(amount: int, external := false) -> int:
	# Ancient Pact: the beast has forsaken all mending.
	if no_heals:
		if amount > 0:
			float_text("PACT", Color(0.6, 0.45, 0.7))
		return 0
	# Caught Fast: the trap's teeth keep every wound open.
	if has_status("caught"):
		if amount > 0:
			float_text("CAUGHT", Color(0.75, 0.6, 0.3))
		return 0
	var mult := healing_received_mult
	if has_status("rally_heal"):
		mult *= 1.15
	if has_status("frostbite"):
		mult *= 0.5
	# Last Hope (Holy talent, party-wide stamp): the nearly-dead heal deeper.
	if last_hope_bonus > 0 and hp < max_hp * 0.25:
		mult *= 1.0 + 0.05 * last_hope_bonus
	var final := int(round(amount * mult))
	last_overheal = maxi(final - (max_hp - hp), 0)
	hp = mini(hp + final, max_hp)
	if external and final > 0:
		healed_externally = true
	refresh_bars()
	return final


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
