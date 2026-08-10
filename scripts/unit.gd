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
# {ability display_name: [upgrade names]} — the mini-boss upgrades that landed
# on this hero's kit at spawn. Read by the ability tooltip alone; the upgrades
# themselves are already baked into the Ability objects.
var ability_upgrades := {}
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
var beasts: Array = []      # the Beastmaster's active summons (on the hunter;
							# one element normally, two under The Pack)
var pack_master: BattleUnit  # the hunter this companion belongs to (on the beast)
var loyalty := {}           # Beastmaster: per-beast Loyalty stacks (on the hunter)
var bestial_hp_bonus := 0    # Bestial Wrath (Ursus): doubled health, reverted on expiry
var bestial_armor_bonus := 0.0
var vigor_hp_bonus := 0      # Spirit Bond perfect: +10% max health, reverted on expiry
# ---- Beastmaster lane-tree talents (Batch 30; re-specced by BATCH AY) ----
# EVERY COUNTER BELOW IS ADDITIVE (the AR/AS/AT/AV/AW/AX form): the payload
# holds the MAGNITUDE in the units its read site sums, and the read site
# applies no step of its own. The two named `_step` hold the INCREASE on a
# base the kit already pays without the node (AV's `guardian_step` precedent).
var wild_communion_step := 0.0  # +% on the passive's own 5% strike step per
                             # stack. A FLOAT, and deliberately NOT in
                             # Runes.STAT_INT_KEYS: the Rune of the Deep Bond
                             # pays 1.5 and an int coercion would round it to 1
                             # with nothing crashing (AT's `conduit_step`).
var unbroken_watch := 0      # Loyalty gained on a turn the beast took no damage
var absolute_step := 0.0     # +% on the Pack Bond boon's own 20% step per
                             # stack. A FLOAT for the same reason.
var devoted_fury := 0        # Bestial Wrath: +N turns per Loyalty stack
var steadfast_bond := 0      # % of a dead beast's Loyalty that endures
var ancient_pact := 0        # the boon step DOUBLES; the beast is unhealable
var lone_bond := 0           # one beast per fight — AND the Loyalty it arrives
                             # at (the gate and the magnitude in one field,
                             # AW's `judgement` / AX's `avatar_ruin` precedent)
var quick_whistle_ranks := 0 # turns shaved off the shared Swap cooldown
var momentum_ranks := 0      # +% companion dmg per distinct beast fielded
var shared_devotion := 0     # Loyalty every OTHER beast gains on summon/swap
var herald := 0              # ADDITIONAL targets an arrival effect strikes
var menagerie := 0           # % of the boon an absent summoned beast keeps
var no_beast_left := 0       # free summons armed by a beast's death
var no_beast_left_loyalty := 0  # Loyalty a free-summoned beast arrives at
var wild_rotation := 0       # swap has no cooldown — AND the Loyalty cap it
                             # imposes as its cost (gate and magnitude in one)
var masters_aim_ranks := 0   # Quick Shot +% of Attack
var companion_hp_pct := 0.0  # Beast Within: +% companion max health
var deep_reserves_ranks := 0 # Spirit Bond +% max Mana
var instinctive := 0         # Quick Shots Hunter's Instinct empowers (total)
var symbiosis := 0           # % max Mana restored per companion strike
var vengeance := 0           # beast death -> inherit its boon for the BATTLE
var vengeance_dmg := 0       # ... and +% damage for as long as it holds
var lone_hunter := 0         # no companion: % less cost (gate AND magnitude)
var lone_hunter_dmg := 0     # ... and +% damage
var one_soul := 0            # capstone: shared health pool, double Loyalty
var apex := 0                # capstone: extra Quick Shot strike, KC resets
var the_pack := 0            # capstone: two beasts active at once
var vengeance_kind := ""     # which boon Vengeance carries while it lasts
var kinds_summoned := {}     # beasts fielded this fight (Feral Momentum et al)
var beast_committed := false # Lone Bond: a REAL summon has been spent (Call
                             # of the Wild writes kinds_summoned but never this)
var free_summons := 0        # No Beast Left: how many summons are still free
var no_heals := false        # Ancient Pact: this beast rejects all healing
# ---- Batch AN §3: the battle modifier ----
# A modifier binds BOTH parties for one battle, so it is stamped on every
# unit at spawn rather than checked per-unit at a read site. Each field has
# exactly ONE read site, named beside it — which is what lets a modifier be
# authored as a stamp rather than as six conditionals scattered through the
# damage pipeline. Defaults are the no-modifier values, so a battle with no
# modifier runs the pre-AN code path byte for byte.
var mod_ignore_armor := false  # Brittle    — read in effective_armor()
var mod_speed_mult := 1.0      # Frenzied   — read in effective_speed()
var mod_no_heals := false      # Bloodless  — read in heal_amount()
var mod_cost_mult := 1.0       # Warded     — read in battle._eff_cost()
# Batch AQ's six, same rule: one field, one read site, default = no modifier.
# mod_bd_mult is an INTEGER PERCENT (100 = unchanged) so the Break block can
# stay integer arithmetic end to end — see the hold_bd cut it sits beside for
# why that matters there.
var mod_bd_mult := 100         # Muffled    — read in take_hit()'s Break block
var mod_status_turns := 0      # Fleeting   — read in add_status()
var mod_no_break := false      # Deadened   — read in take_hit()'s Break block
var mod_no_regen := false      # Thin Air   — read in battle._player_turn()
var mod_bleed_add := 0         # Bloodletting — read at battle's on-hit bleed
var mod_recoil := 0.0          # Mirrorbound  — read at battle's recoil site
# One Soul: EVERY member of the bond, self included — the hunter and each of
# his living beasts. BATCH AY §1 made it an Array because The Pack fields two
# beasts, so the bond spans THREE bodies and a single partner pointer could
# only ever hold the newest (the older beast kept a stale link the hunter no
# longer answered). Empty = no bond. battle._sync_soul_bond is the ONE writer.
var soul_bond: Array = []
var _soul_guard := false     # re-entry guard while splitting
var damaged_since_turn := false  # Unbroken Watch bookkeeping
# ---- Sharpshooter Focus + lane talents (Batch 32, RE-AUTHORED BY BATCH AZ) ----
# EVERY COUNTER BELOW HOLDS ITS OWN MAGNITUDE IN THE UNITS ITS READ SITE SUMS
# (the AR/AS/AT/AV/AW/AX/AY form). §6 named three that had to be converted;
# every other node whose §3 magnitude is a NUMBER took the same treatment, which
# is reported rather than silently generalised (the AW/AX call). The four that
# are still honest FLAGS are marked as such — they buy a rule, not an amount.
var last_attack_target: BattleUnit = null  # Focus: the enemy worked last turn
var same_target_turns := 0   # Unwavering: consecutive turns on that same enemy
var lethal_eye_ranks := 0    # Executioner's Eye: percentage POINTS of crit mult
var consistent_aim := 0      # Consistent Aim: percentage POINTS SUBTRACTED from it
var deep_focus := 0          # Deep Focus: points the CONVERSION POINT drops
var unwavering := 0          # Unwavering: extra Focus per consecutive turn (ramp)
var perfect_form := 0        # Perfect Form: Focus granted by a crit
var tunnel_vision := 0       # Tunnel Vision: percentage POINTS of crit chance, ±
var bonecracker_ranks := 0   # Bonecracker: percentage points of damage vs Broken
var opp_aim_step := 0.0      # Opportunist's Aim: the INCREASE on Powershot's own
                             # 2% per full Break point (a `_step`, and a FLOAT —
                             # it must stay OUT of Runes.STAT_INT_KEYS)
var sundering_shot := 0      # Sundering Shot: Break damage applied by a crit
var exposed_nerve := 0       # Exposed Nerve: gate AND magnitude — crits apply
                             # Exposed, and he deals +N% to Exposed enemies
var no_cover := 0            # FLAG: attacks cannot be made to miss (a bypass)
var overkill := 0            # FLAG: kill overflow carries, and keeps Focus whole
var muscle_memory_ranks := 0 # Muscle Memory: Focus added to each attack's gain
var opening_volley := 0      # Opening Volley: the Focus he opens a fight holding
var follow_through := 0      # Follow-Through: cooldown turns a crit ticks off
var second_nature := 0       # Second Nature: TOTAL held-breath shots (base 1)
var snap_shot := 0           # Snap Shot: how many free abilities each fight
var snap_used := 0           # how many of them have been spent
var spray := 0               # Spray of Arrows: extra random enemies struck
var one_shot := 0            # capstone: the Focus THRESHOLD One Shot fires at —
                             # gate and magnitude in one field (AW's `judgement`)
var through_and_through := 0 # FLAG: ignore ALL armor; crits refund Mana
var rapid_fire := 0          # capstone: % chance an ability skips its cooldown
# ---- Survivalist lane talents + trap state (Batch 33, RE-AUTHORED BY BA) ----
# EVERY COUNTER IS ADDITIVE: it writes its own magnitude in the units its read
# site sums, so a node and a rune each pay what they advertise, alone and
# stacked. FLAGS (a bare 1) are RULES, not amounts — they are named as such.
var potent_ranks := 0        # Potent Toxins: FLAT poison damage per stack (8)
var coated_blades := 0       # FLAG: basic attacks apply Poison 2t + Cripple 2t
var virulence_ranks := 0     # Distillate: EXTRA poison stacks per application (2)
var slow_acting := 0         # FLAG: half tick, double turns, sticky, +Slowed 3t
var creeping_death := 0      # FLAG: any status on a Poisoned enemy refreshes it
var necrosis := 0            # Poisoned enemies take +N% from ALL sources (35)
var quartermaster := 0       # FLAG: allies' basic attacks apply HIS Poison
                             # (the id sv_plague carries it; PLAGUE BEARER, and
                             # the concept, are GONE — see the Batch BA block)
var wire_ranks := 0          # Reinforced Wire: tripwire +N% of Attack (35)
var quick_rigging := 0       # Snare Trap cooldown reduction (2) + snares Cripple
var cruel_ranks := 0         # traps deal +N% damage (50)
var snap_shut := 0           # FLAG: tripwire also bites ranged attackers
var caught_fast := 0         # trap victims cannot be healed for N turns (5)
var bone_breaker := 0        # traps apply N Break damage (90)
var deadfall_network := 0    # the trap CAP it installs (3) — gate AND magnitude
var hit_and_run := 0         # applying a status grants Elusive for N turns (2)
var scavenger_ranks := 0     # +N% max Mana on enemy death (25)
var field_medic := 0         # turn start: cleanse N debuffs from random allies (2)
var vulture := 0             # +N% vs enemies with 3+ different statuses (60)
var ghillie := 0             # N% less likely to be targeted while allies live (65)
var improvised := 0          # how many opening abilities start no cooldown (2)
var improvised_used := 0     # how many of them have been spent (AZ's `snap_used`)
var perfected_toxin := 0     # capstone: his Poison is sticky, never expires, and
                             # its tick RISES by N each turn it persists (2).
                             # The id sv_epidemic carries it; EPIDEMIC's
                             # field-wide infection is GONE (reserved space)
var whole_forest := 0        # capstone: tripwire never expires, bites everything
var force_of_nature := 0     # capstone: Trapper's bonus as a percentage (20),
                             # and it applies to the WHOLE party
# BATCH BD — SAME FIELD, DIFFERENT UNIT, which is the class of change that
# fails silently: this counted ARMED TRAPS and now counts CHARGES REMAINING on
# the ONE deadfall a cast places (3, or 4 on a perfect rig). Every read site
# moved with it — the spring decrements it, and the trap cap counts a deadfall
# with charges left as exactly ONE occupant rather than as three traps.
var deadfall_armed := 0      # charges left on the placed deadfall (0 = none out)
var deadfall_dormant := 0    # turns it must rest before it can spring again (2)
# `deadfall_aims` IS DELETED, not left unreachable (the BA precedent): the
# perfect no longer names a victim, so the array could never be non-empty and a
# later batch could otherwise write one.
var companion_hp_bonus := 0   # talents: extra HP for summoned companions
var companion_power := 0      # talents: extra damage on companion attacks
# Fixed-tree talent stats (0/0.0 = not learned). See talents.gd for sources.
var bleed_bonus := 0          # Savagery: extra Bleed on bleed-building abilities
var bloodrage_step_bonus := 0.0  # Unstoppable: adds to Blood Frenzy's 2%/step
var frenzy_floor := 0.0  # Blood Frenzy v2: half the peak bonus this battle
                         # (fraction; ratchets up, never resets mid-battle —
                         # units are built fresh each battle)
var scar_tissue_ranks := 0    # Scar Tissue: floor keeps 85% of the peak; 2 =
                              # Unstoppable was taken too, so it keeps 100%
var scent_ranks := 0          # Scent of Blood: +10% damage per bleedout
var blood_tithe_ranks := 0    # Blood Tithe: 45 Rage per enemy bleedout
var arterial_ranks := 0       # Arterial Spray: full buildup transfer
var deathwish_ranks := 0      # Deathwish: +25% damage below 35% health
var bloodied_momentum_ranks := 0  # Bloodied Momentum: 40 Rage per kill
var second_wind := 0          # Second Wind: first drop below 25% grants 60 Rage
                              # and clears every cooldown
var second_wind_used := false
# Batch AJ fields — each read at exactly ONE site, the discipline the rune
# fields above follow (the changelog names the sites):
var opening_rage := 0         # First Blood: Rage in the tank at battle start
var overkill_reset := 0       # Overkill (Berserker): a kill clears Hack and
                              # Slash and Wildstrikes cooldowns. NOT `overkill`
                              # — the Sharpshooter's talent of the same name
                              # has owned that field since Batch 32, and the
                              # two do entirely different things
var measured_cancels_reckless := 0  # Measured Rage + Reckless Fury: the
                              # damage-taken term is cancelled outright
var battle_shout_node := 0    # Battle Shout node: 1 = granted here, 2 =
                              # upgraded onto an already-earned copy
var rampage_upgraded := 0     # Rampage capstone onto an earned copy: the
                              # kill-recast may chain twice a turn, not once
var rampage_chains := 0       # runtime: chains used this turn (reset each turn)
# Batch X authored-rune fields — each read at exactly ONE battle.gd site
# (the relics hook-audit discipline; the changelog lists the sites):
var blood_pact := 0           # Exsanguination rune: NEGATIVE threshold shift —
                              # enemy bleedouts pop at 100+pact and pay 15%
var rune_lifesteal := 0.0     # Vampiric Rune: attacks heal this fraction of damage dealt
var rune_execute_bonus := 0.0 # Reaper rune: bonus damage vs targets under 35% HP
var rune_bd_bonus := 0.0      # Breaker runes: Break-damage multiplier bonus
# Batch AA authored-rune field, same discipline:
var rune_resist_pierce := 0.0 # White Flame rune: thins a target's POSITIVE
                              # resistance to the attacker's damage type; a
                              # weakness (negative resist) is left alone
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
var opportunist := 0          # Opportunist: counter enemy misses AND parries with Overpower
var blade_crit_ranks := 0     # Seasoned Fighter node: crit for Lunge/Overpower
var swordsmanship_parry := 0.0 # Swordsmanship: the perfect Guard Change parry spike
var high_guard := 0           # High Guard: -40% damage 2 turns after parrying
var dominant_ranks := 0       # Dominant Presence: armor per debuff applied
var debuffs_applied := 0
var unkillable_ranks := 0     # Unkillable: heal on block
var elem_weak_ranks := 0      # Elemental Weakness: Crushing Blow resist shred
var tank_spank_ranks := 0     # Tank and Spank: Mocking Blow always empowers an ally
var ricochet_ranks := 0       # Richocet: chance to stun on block
var endurance_ranks := 0      # Endurance: +3%/rank armor per unhealed turn
var endurance_stacks := 0
var healed_externally := false
var iron_will_ranks := 0      # Iron Will: -12%/rank damage taken per own debuff
var sundering_ranks := 0      # Sundering: Crushing Blow BD splash to Adjacent
var tenacity := 0             # Tenacity: +15 max HP per Heavy Plating block
var tenacity_hp_gained := 0   # battle-long gains (excluded from the run save)
var rally := 0                # Rally: party +30% healing for 3t per HP block
var shield_mastery_ranks := 0 # Shield Mastery: Shieldwall's stance +2 turns/rank
var plating_bonus := 0.0      # Heavy Plating v2: +8% Block per unblocked hit
                              # (cap +40%; any Block resets it; fresh per battle
                              # like frenzy_floor — units are built each battle)
# Warden lanes (Batch H; magnitudes re-authored in Batch AL, where a node
# became a whole exclusive row instead of one of three ranks). See talents.gd
# for the node text.
var plate_discipline_ranks := 0  # Plate Discipline: the plating climbs +12%/rank faster
var battered_ranks := 0       # Battered Not Broken: blocks shed 30/rank own Break
var provoke_ranks := 0        # Provoke: Mocking Blow taunts +2 foes/rank
var spite_ranks := 0          # Spite: attackers take 30%/rank of dealt damage back
var bruising_ranks := 0       # Bruising Guard: blocks deal 30/rank BD to the attacker
var spite_break := 0          # …and its cross-row half: Spite's reflect builds Break too
var grudge_ranks := 0         # Grudge: +25%/rank damage vs enemies he taunts
var rune_grudge_bonus := 0.0  # the Rune of Grudges' own, smaller share of the same term
var rallying_cry := 0         # Rallying Cry: allies regain N% resource at his turn
var rallying_stomp_ranks := 0 # …and its War Stomp rider: the stomp refuels +20%/rank more
var bulwark_ally_block := 0   # Bulwark Line: Shieldwall grants allies +N% Block chance
var bulwark_line_ranks := 0   # …and its Interpose rider: +1 charge/rank per ally
var shared_vigil_ranks := 0   # Shared Vigil: allies -12%/rank damage while he's >50% HP
var rune_vigil_bonus := 0.0   # the Rune of the Standard's own, smaller share of it
var steadfast_ranks := 0      # Steadfast: absorbs 60%/rank of a blow felling an ally
var immovable := 0            # Immovable (capstone): cannot be Broken
var immovable_noted := false  # one proc log per battle, not one per hit
var hold_line_upgraded := 0   # Hold the Line capstone landing on an earned copy
var vengeful_guardian := 0    # Vengeful Guardian (capstone): first block each turn
var vengeful_ready := true    # answers with Crushing Blow; re-arms at his turn
var seasoned_def_bonus := 0.0 # Defensive Stance: deeper damage-taken cut
var seasoned_off_bonus := 0.0 # Aggressive Stance: bigger damage-dealt bonus
var stance := "aggressive"    # Swordmaster guard (aggressive|defensive), fresh each battle
# Swordmaster lanes (Batch F; magnitudes re-authored in Batch AK, where a
# node became a whole exclusive row instead of one of three ranks). See
# talents.gd for the node text.
var killing_edge_ranks := 0   # Killing Edge: +15% crit while Aggressive
var overwhelm_ranks := 0      # Overwhelm: +8% damage per debuff on the target
var tempo_ranks := 0          # Tempo: stance switch grants +30% damage 1 turn
var bracing_ranks := 0        # Bracing: +30 Constitution while Defensive
var deflection := 0           # Deflection: parry works against ranged attacks
var pressure_point_ranks := 0 # Pressure Point: Pommel Strike +30 BD
var guard_change_bd := 0      # Sunder Guard: Guard Change's BD, to EVERY enemy
var sunder_guard_bd := 0      # Sunder Guard: +BD on Shatterpoint, if he owns it
var no_quarter_ranks := 0     # No Quarter: Breaking an enemy grants 45 Rage
var punishment_ranks := 0     # Punishment: Overpower +60% vs Broken
var off_balance_ranks := 0    # Off Balance: all damage +20% vs Broken
var off_balance_wide := 0     # Off Balance + Punishment: Exposed/Crippled count too
var lunge_upgraded := 0       # Lunge node on an earned Lunge: both debuffs, any stance
var execute_upgraded := 0     # Execute capstone on an earned Execute: 35%, free vs Broken
var untouchable := 0          # Untouchable: Defensive parries negate + Pommel counter
var guard_breaker := 0        # Guard Breaker: Broken recovery refills the meter to 50
# Pyromancer tree (Batch AR — the Overburn re-author). All 24 ids survived
# and re-specced in place; these are the fields the new nodes read. Several
# are ADDITIVE MAGNITUDES rather than rank counts, so a node and a rune can
# both feed one and each still pays exactly its advertised number: the node
# writes 4 into accelerant_ranks and the Rune of the Long Burn writes 1, and
# the read site adds percentage points. See talents.gd for the node text.
var accelerant_ranks := 0     # Accelerant: Burn ticks +N points of Attack
var cinder_trail_ranks := 0   # Cinder Trail: Fireball's Burn lasts +N turns
var conflagration_ranks := 0  # Conflagration: Flamewave applies +N turns
var explosive_ranks := 0      # Explosive Force: a fire crit extends Burn +N turns
var wildfire_spread := 0      # Wildfire Spread: Wildfire lights the unburnt first
var ember_wind := 0           # Chain Ignition: a burning death splits its Burn
var ember_consumed := false   # Chain Ignition already released this corpse
var burn_at_death := 0        # Burn turns left when this unit died
var burn_tick_at_death := 0   # tick snapshot for the Chain Ignition transfer
var fire_walker := 0          # Fire Walker: Overburn's drain is 25% lighter
var invigorating_ranks := 0   # Invigorating Ashes: N% chance of Mana per Burn tick
var heat_haze_ranks := 0      # Heat Shimmer: Overburn's damage cap +N points
var kiln_forged := 0          # Kiln-Forged: +20% fire resist, drain floors at 10 Mana
var ash_lung := 0             # Ash Lung: +15% damage while the drain outruns regen
var cauterise := 0            # Cauterise: the drain bills health, and no cap under 20
var focused_flame := 0        # Focused Flame: Detonation's Burn bonus 250% -> 325%
var pressure_cooker := 0      # Pressure Cooker: +25 Break damage on a Burning target
var aftershock := 0           # Aftershock: Detonation re-lights what it consumed
var crucible := 0             # Crucible: consumed Burn refunds 2 Mana a turn, not 1
var total_commitment := 0     # Total Commitment: the neighbours' Burn goes in too
var cataclysm := 0            # capstone: Detonation eats the WHOLE field's Burn
# --- Pyromancer machinery with NO NODE behind it since Batch AR. ---
# The first four are RUNE-ONLY content now and keep their read sites, because
# a rune whose node is gone wants re-authoring, not silent death (AR §4): the
# Rune of the Blast Radius and the Rune of the Long Burn feed supernova_ranks,
# the Long Burn also feeds molten_ranks, the Blast Radius feeds
# blast_radius_ranks, and the Rune of the Cinder Trail was RE-POINTED onto
# rune_cinder_ember when the node took cinder_trail_ranks for a new meaning.
# pyromaniac_ranks is the one counter with no read site left — Inferno Master's
# per-turn step does not exist under Overburn, and inventing one would be the
# guess AR §4 forbids, so the White Flame's middle clause is FLAGGED as inert.
# The rest is unreachable machinery, kept the way the vault keeps an ability.
var supernova_ranks := 0      # RUNE-ONLY: Detonation crit chance
var molten_ranks := 0         # RUNE-ONLY: burning enemies bite softer
var blast_radius_ranks := 0   # RUNE-ONLY: Detonation consumes 25%/point more Burn
var rune_cinder_ember := 0    # RUNE-ONLY: Fireball embers a second enemy
var pyromaniac_ranks := 0     # INERT: the White Flame writes it, nothing reads it
var seeding_ranks := 0        # no node: Seeding Embers
var seeding_consumed := false
var melt_ranks := 0           # no node: Melt Armor
var melted := 0.0             # armor shredded off THIS unit by Melt Armor
# ASHES OF AL'AR (Batch BB §6). It was a Pyromancer talent until AR removed
# every defensive option from that spec, and its field sat here with NO WRITER
# AT ALL — kept, gated `> 0`, waiting for a home. It has one now: the ability of
# the same name in `CLASS_POOLS["mage"]`, earnable by any Mage from a boss.
# `ashes_return` HOLDS A REAL MAGNITUDE (the percentage of maximum health handed
# back) rather than the old rank count behind a `randf() < 0.11 * ranks` roll —
# the additive form every batch since AR has used, and the roll had no business
# sitting behind a cast that costs a turn and a boss pick.
var ashes_return := 0         # Ashes of Al'ar: % of max HP the phoenix returns at
var ashes_used := false       # the phoenix rises once per battle
var scorched_ranks := 0       # no node: Scorched Earth
var living_flame_ranks := 0   # no node: Living Flame
var implosion_ranks := 0      # no node: Implosion
var chain_reaction_ranks := 0 # no node: Chain Reaction
var fuse_ranks := 0           # no node: Fuse
var white_heat_ranks := 0     # no node: White Heat
var avatar_flame := 0         # no node: Avatar of Flame
var was_frozen := false       # has been Frozen this battle
# Cryomancer tree (Batch AS lanes: Winter / Deep Freeze / Thaw).
# EVERY COUNTER BELOW IS ADDITIVE, not ranked: the node writes its own
# magnitude in the units the read site sums, so a rune writing the same field
# pays its advertised number alone AND stacked. Under the old `1 x step` form
# a rune's value silently inherited the node's multiplier.
var hungering_ranks := 0      # Hungering Cold: -N% damage per Chilled stack
var hold_turns := 0           # Batch AT: turns this enemy has spent HELD. Written
                              # ONLY by battle._hold_sync (walking `_holds`) and
                              # zeroed at _hold_freeze; Shatter's damage reads it.
var frostbite_ranks := 0      # Brittle Ice: +N% crit chance against a HELD enemy
var piercing_ice_ranks := 0   # Piercing Ice: Ice Lance +N% critical damage
var hypothermia_ranks := 0    # Hypothermia: +N% damage taken per Chilled stack
var frigid_ranks := 0         # Frigid Grip: every Chilled stack slows N% harder
var frigid_bonus := 0.0       # ...stamped on the VICTIM when Chilled lands
var deep_chill_ranks := 0     # Deep Chill: Frostbolt applies +N stacks of Chilled
var splinter_ranks := 0       # Splintering Shards: Razor Ice ALWAYS strikes a 4th time
var whiteout_ranks := 0       # Whiteout: Blizzard applies N stacks to every enemy
var killing_frost := 0        # Killing Frost: +N points on the held-enemy window
var cold_snap_ranks := 0      # Cold Snap: a held enemy's Break fills N per turn
var bitter_cold_ranks := 0    # Bitter Cold: a freeze chills every OTHER enemy N times
var glacial_ranks := 0        # Glacial Economy: N% of max Mana back per freeze
var crystal_edge_ranks := 0   # Crystal Edge: Ice Lance +N% of Attack per Chilled stack
var honed_shards_ranks := 0   # Honed Shards: a release leaves N stacks of Chilled
var icy_resolve_ranks := 0    # Icy Resolve: Rime lasts N additional turns
var grasp_ranks := 0          # Winter's Grasp: N random Chilled enemies gain a stack
var second_prison := 0        # Second Prison: he can hold TWO enemies at once
var shattered_tempo := 0.0    # Shattered Tempo: a release pushes every OTHER enemy back
var absolute_zero := 0        # capstone: NO limit on how many enemies he holds
var eternal_winter := 0       # capstone: every enemy gains a stack each of his turns
# RUNE-ONLY (Batch AS §5). Numbing Veil's node became Glacial Prison; the
# read site is KEPT because the Rune of the Killing Cold still writes it.
var numbing_ranks := 0        # Chilled enemies miss N% more often
# UNREACHABLE BUT KEPT (the AR vault pattern — no node writes these and no
# rune does either, so each is gated `> 0` and can never be non-zero. Listed
# in the changelog so a later batch can re-node or delete them deliberately
# rather than rediscovering them.)
var icy_veins_ranks := 0      # no node: Icy Veins
var icy_veins_charge := 0.0   # no node: Icy Veins' armed bonus
var emp_frostbolt_ranks := 0  # no node: Empowered Frostbolt
var freezing_ranks := 0       # no node: Freezing Advance
var freezing_adv_mark := false # no node: Freezing Advance's victim mark
var frost_ward_ranks := 0     # no node: Frost Ward
# Arcanist rework + tree (07-20). See talents.gd for the node text.
var overcharge_uses := 0      # Overcharge casts spent this battle
# BATCH AU: Overcharge's AUTHORED FALLBACK. When the ar_overcharge node lands on
# an Overcharge he already earned from the spec pool, the node buys a SECOND use
# instead of doing nothing. The allowance is decided in exactly one place —
# `overcharge_ready()` below — so the gate, the tooltip and the bot agree.
var overcharge_extra := 0     # extra uses per battle (the node's fallback)
var overcharge_mult := 0.5    # fraction of current stacks it grants (1.0 perfect)
var crit_streak := 0          # crits since the last Critical Mass proc
var res_cast_this_turn := false  # Resonant Core: has he cast yet this turn?
# Arcanist tree, RE-AUTHORED IN BATCH AT around escalation. Every counter is
# ADDITIVE — it writes its own magnitude in the units its read site sums.
var harmonics_ranks := 0      # Harmonics: extra Resonance from Arcane Explosion
var attunement_crit := 0      # Attunement: extra Resonance from a crit
var charged_bolts_ranks := 0  # Charged Bolts: % max Mana per cast, per 4 stacks
var resonant_core_ranks := 0  # Resonant Core: extra Resonance, first cast of a turn
var critical_mass_stacks := 0 # Critical Mass: Resonance on every 3rd crit
var cascade_stacks := 0       # Cascade: extra Resonance per cast at 10+ stacks
var conduit_step := 0.0       # Conduit: POINTS on the damage curve's step (FLOAT —
                              # never name this "_ranks" or Runes coerces 0.5 to 0)
var volatility_ranks := 0     # Volatility: % damage on Arcane Cannon
var volatility_recoil := 0    # Volatility: Cannon's recoil %, as a SET not an add
var temporal_ranks := 0       # Temporal Rift: % of a crit echoed at a random enemy
var suppressing_ranks := 0    # Suppressing Fire: % of Attack each Barrage bolt gains
var cannoneer_ranks := 0      # Cannoneer: extra Break damage per stack on Cannon
var terminal_velocity := 0    # Terminal Velocity: stacks above which Death Ray is free
var conversion_ranks := 0     # Conversion: % of damage taken paid as Mana
var on_edge_threshold := 0.0  # On the Edge: health % below which surviving pays
var on_edge_stacks := 0       # On the Edge: Resonance it pays
var feedback_ranks := 0       # Feedback Loop: % of recoil paid as Mana
var stable_ranks := 0         # Stable Alignment: single-hit cap, % of max health
var backlash_stacks := 0      # Backlash: Resonance per hit received
var siphon_ranks := 0         # Siphon: % of damage dealt restored as Mana
var event_horizon := 0        # Event Horizon: stacks above which he cannot be killed
# THE TWO CAPSTONES SWAPPED LANES IN BATCH AU. The step-doubling was
# Singularity's (Resonance) and the plain AoE was Magi's Wrath's (Overload) —
# crossed, because doubling the STEP is the Overload lane's entire thesis.
# Uncrossed now: Magi's Wrath carries the step, Singularity carries build rate.
var wrath_step_double := 0    # Magi's Wrath capstone: the damage curve's step doubles
var singularity_crit_build := 0 # Singularity capstone: extra Resonance per crit
var singularity_kill_build := 0 # Singularity capstone: Resonance per enemy killed
var perfect_conversion := 0   # capstone: ALL self-inflicted damage paid as Mana
# UNREACHABLE BUT KEPT (the AR vault pattern — gated `> 0`, reported rather
# than silently deleted, so a later batch can re-node or remove them
# deliberately). mindfulness_ranks, arcane_mastery_ranks and
# critical_mass_ranks are RUNE-ONLY: the Runes of the Unquiet Mind and the
# Wide Current still pay them and their read sites are kept on purpose.
# mana_attune_ranks and still_mind_ranks have no writer at all — the first
# because Siphon replaced it, the second because Still Mind's whole subject
# (Stabilize's floor) left the opening three, though Stabilize itself is
# earnable and still reads the floor.
var mindfulness_ranks := 0    # RUNE-ONLY: periodic extra cooldown tick
var mindfulness_counter := 0
var arcane_mastery_ranks := 0 # RUNE-ONLY: +1%/rank crit per stack, on top of 1%
var critical_mass_ranks := 0  # RUNE-ONLY: every 3rd crit hits harder + Mana
var mana_attune_ranks := 0    # no writer: Mana per stack gained
var still_mind_ranks := 0     # no writer: Stabilize leaves extra stacks
# The Rune of the Wide Current's OWN On the Edge term (the AR Cinder Trail
# pattern): the node took on_edge_* for new units, so the rune keeps its old
# formula on its own field rather than being silently re-tuned by the node's.
var rune_on_edge_ranks := 0


# ---------- RUNAWAY RESONANCE (Batch AT) ----------
#
# THE ONE PLACE THE CURVE IS DECIDED. battle.gd reads it through
# `_resonance_dmg_mult` / `_resonance_taken_mult` and the nameplate below reads
# it directly, so a change here can never leave one of them behind.
#
# T(N) = N(N+1)/2 — the triangular number, and the whole design. A linear
# per-stack term is a SLOPE; this is a CURVE, which is the difference between
# a ramp and an escalation. Both ends are uncapped and nothing removes stacks.
#   5 stacks  +22% dmg / +11% taken      8 stacks  +54% / +27%
#  12 stacks +117% dmg / +59% taken     16 stacks +204% / +102%
const RESONANCE_BAR_REF := 15.0     # what the second-resource bar fills toward:
                                    # the depth Terminal Velocity and Event
                                    # Horizon both switch on at
const RESONANCE_DMG_STEP := 1.5     # % damage per point of curve
const RESONANCE_TAKEN_STEP := 0.75  # % damage TAKEN per point — nothing modifies
                                    # this, deliberately: Conduit and Singularity
                                    # name the damage curve only


func resonance_curve() -> float:
	var n := float(second_resource)
	return n * (n + 1.0) * 0.5


# THE ONE PLACE Overcharge's per-battle allowance is decided (Batch AU). One
# cast, or two once the ar_overcharge node has landed on an already-earned copy.
func overcharge_ready() -> bool:
	return overcharge_uses < 1 + overcharge_extra


# Conduit adds 0.5 points; MAGI'S WRATH adds another 1.5 (the additive reading of
# "the step doubles, 1.5% -> 3%", which is the form this tree uses throughout).
#
# BATCH AU MOVED THE DOUBLING FROM SINGULARITY TO MAGI'S WRATH and nothing else
# may write this term — Singularity pays build rate now, which is quadratic in
# the payout where the step is only linear (AT's measured finding). A negative
# control putting the doubling back on Singularity has to trip the test.
func resonance_dmg_step() -> float:
	var step := RESONANCE_DMG_STEP + conduit_step
	if wrath_step_double > 0:
		step += RESONANCE_DMG_STEP
	return step


func resonance_dmg_bonus() -> float:
	return 0.01 * resonance_dmg_step() * resonance_curve()


func resonance_taken_bonus() -> float:
	return 0.01 * RESONANCE_TAKEN_STEP * resonance_curve()


# ---------- LETHAL AIM: FOCUS CONVERTS (Batch AZ) ----------
#
# THE ONE PLACE THE SPLIT IS DECIDED. battle.gd reads it through its crit-chance
# block and its crit-multiplier block, the nameplate below reads it directly,
# and the sim instrument reads it too — so a change here can never leave one of
# them behind. (The AT Resonance discipline, arriving through the Hunter's door.)
#
# FOCUS HAS NO CEILING. The first FOCUS_CONVERT points each buy +0.5% CRITICAL
# CHANCE; every point past it buys +0.5% of CRITICAL MULTIPLIER instead, and
# that half never stops paying. Patience buys certainty first, then force.
#
# THE THRESHOLD IS A FIXED NUMBER, NOT "whenever chance reaches 100%". A built
# marksman (Steady Hands + Consistent Aim + Tunnel Vision) passes 100% chance at
# very low Focus, which would make the chance half of his own passive vestigial
# and make the conversion depend on what else he had stacked. A fixed threshold
# is legible in a tooltip — the first hundred is your aim, everything past it is
# your force — and it keeps those three nodes meaningful, because they are what
# buy reliable crits while Focus is still shallow.
#   100 Focus  +50% chance / x2.0     200 Focus  +50% / x2.5
#   300 Focus  +50% / x3.0            400 Focus  +50% / x3.5
const FOCUS_CONVERT := 100      # where chance stops and multiplier starts
const FOCUS_STEP := 0.005       # what one point of Focus buys, either side
const FOCUS_BAR_REF := 200.0    # what the second-resource bar fills toward when
                                # the meter is uncapped: One Shot's threshold and
                                # Coup de Grâce's reading cap, which are the two
                                # depths that mean anything


# Deep Focus does not raise a ceiling any more (there is none) — it moves the
# CONVERSION POINT DOWN, so his patience turns into force sooner. The counter
# holds the DROP, which is what makes it additive: the node pays 40 and the Rune
# of the Deep Sight pays 8 on top.
func focus_convert() -> int:
	return maxi(FOCUS_CONVERT - deep_focus, 1)


func focus_crit_chance() -> float:
	if second_resource_name != "Focus":
		return 0.0
	return mini(second_resource, focus_convert()) * FOCUS_STEP


func focus_crit_mult() -> float:
	if second_resource_name != "Focus":
		return 0.0
	return maxi(second_resource - focus_convert(), 0) * FOCUS_STEP


# Lethal Aim's multiplier, whole: the base x2, Executioner's Eye's percentage
# POINTS on top, Consistent Aim's points taken back off, and the converted half
# of Focus. Written as +/- POINTS rather than as a `set` deliberately — Batch AZ
# §4 dissolved the Executioner's Eye <-> Consistent Aim fork (they sit in rows 4
# and 5 of ONE lane, so row exclusivity lets a player hold both), and the old
# wording SET the multiplier to 1.5, which contradicts the other node outright.
# Held together they resolve to x2.0, which is the whole point of the rewording.
func lethal_crit_mult() -> float:
	return 2.0 + 0.01 * (lethal_eye_ranks - consistent_aim) + focus_crit_mult()


# Holy tree — RE-AUTHORED IN BATCH AV. Every counter is ADDITIVE: it holds
# its own magnitude in the units its read site sums (percentage POINTS unless
# said otherwise), never a rank the read site multiplies. See talents.gd.
var triage_heal := 0          # Triage: +N% healing, and heals may CRIT at all
var heavenly_step := 0        # Heavenly Aura: the INCREASE on Mercy's base 5%/stack
var holy_light_pct := 0       # Holy Light: N% of max Mana back on a perfect cast
var guardian_step := 0        # Guardian Angel: the INCREASE on the 50% Mercy window
var mercy_threshold := 0.5    # party-wide stamp (Guardian Angel raises it)
var divine_presence_pct := 0  # Divine Presence: end-of-turn drip heal, N% of max HP
var last_hope_pct := 0        # Last Hope: the nearly-dead heal N% deeper
var last_hope_bonus := 0      # party-wide stamp (receiver side of Last Hope)
var last_overheal := 0        # overheal of the most recent heal_amount call
var on_mend_pct := 0          # On the Mend: N% chance a Renewal tick dispels
var sanctified_pct := 0       # Sanctified: N% chance a Mercy spend refunds
var cascade_pct := 0          # Radiant Cascade: crit heals splash N% onward
var overflow_pct := 0         # Overflow: N% of overhealing spills onward
var zealous_mercy := 0        # Zealous Light: battle-opening Mercy (a COUNT)
var grace_pct := 0            # Grace: a wasted stack heals the ally N% of her max HP
var ardor_at := 0             # Ardor: hold this many Mercy and Empower is free
var mercy_cap_bonus := 0      # Martyr's Vigor: the INCREASE on the base cap of 5
var holy_vigil_pct := 0       # Shared Vigil: party takes N% less while anyone is low
var vestments_pct := 0        # Blessed Vestments: her heals leave an N%-value shield
var intercession_long := 0    # authored fallback: the refusal window lasts a turn more
var martyrdom := 0            # capstone: the first hero to fall returns at 30%
var sanctum := 0              # capstone: +60% healing, ALL overheal spills
var avatar_of_mercy := 0      # capstone: Empower is free and GRANTS a stack
# Party-wide stamps for the two reversal effects. `intercession` is a STATUS
# (the one answer to "is the refusal live", so it expires by itself); the
# callback returns FALSE when the Cleric cannot pay, and only then does the
# hero die. Martyrdom is once per battle and free, so a plain latch is enough.
var intercession_cb := Callable()
var martyrdom_guard := false
var martyrdom_cb := Callable()
# RUNE-ONLY, READ SITES KEPT ON PURPOSE (the AR vault pattern): Batch AV
# retired the Holy Capacitor and Beacon NODES, but the Rune of the Triage Ward
# and the Rune of the Sleepless Vigil still write these. Flagged for
# re-authoring — never silently deleted.
var capacitor_ranks := 0      # Holy Capacitor: overheal banks for next Heal
var stored_overheal := 0      # the banked amount (released by Heal)
var beacon_ranks := 0         # Beacon: turn-start pulse on the nearly-dead
# Devout Conviction + tree (07-23; magnitudes and units re-authored in Batch
# AW). EVERY COUNTER BELOW IS ADDITIVE — it holds its own magnitude in the
# units its read site sums, so a node and a rune each pay what they advertise
# alone AND stacked. FOUR of them hold the INCREASE on a base the kit already
# pays without the node (stalwart_step on Divine Shield's 30%, righteous_step
# on the ground's 10%, faithful_step on the release's 15%); those are named
# `_step` for that reason, AV's `guardian_step` precedent. (A fourth,
# `fervor_step`, went with Batch BH §2's re-spec.) See talents.gd for the
# node text.
# BATCH BH §2 — FAITH IS NO LONGER ONLY AN ALLY'S. The Devout carries stacks of
# his own, and HIS NEVER RELEASE: they hold, paying him the same mitigation and
# damage they pay everyone else. That is a change to what the resource IS rather
# than to one node, which is why it is written here and in the passive text
# rather than only in Binding Oath's tooltip. THE BRIEF'S PREMISE FOR IT WAS
# STALE and is corrected toward the code: it says "Faith has only ever existed
# on allies — the Devout has no meter of his own anywhere in his kit", but
# `_gain_faith` has never excluded him (he is a hero), so Consecrated Ground has
# been dripping Faith onto its own caster since Batch AW §2 and he has been
# releasing at five like anybody else. THAT release was a frequency source
# nobody had counted, and closing it is part of §2's job, not a side effect.
var faith_stacks := 0         # Conviction: Faith (0-5). Allies release at 5;
                              # THE DEVOUT'S OWN HOLD THERE (Batch BH §2).
# Batch AW §1 — CONVICTION'S THIRD CLAUSE: every Faith release raises the
# Devout's maximum by 3% of the maximum he brought to the fight. Linear on
# base, never on current. `conviction_hp_gained` is the LEAK GUARD: the
# victory sync subtracts it before writing max_hp back onto the party member,
# beside tenacity_hp_gained.
# CORRECTION TO THE BATCH BRIEF, recorded rather than glossed: it says the two
# fields "do opposite things at the same site" because Tenacity's growth is
# permanent. IT IS NOT — tenacity_hp_gained has been excluded from the save
# sync since Batch W (the ~127,000 max-HP runaway), exactly like this one, and
# the line above has said so all along. The instruction NOT TO MERGE THEM
# stands anyway, for a better reason: tenacity_hp_gained has a SECOND consumer,
# the Unkillable mend at battle.gd's block site, which reads "the pool he
# brought into the battle" and must mean TENACITY'S growth alone. Folding
# Conviction's growth into it would change what a Warden's Unkillable heals for
# whenever a Devout stands beside him.
var conviction_hp_gained := 0 # battle-long growth (excluded from the run save)
var conviction_base_hp := 0   # the base the 3% reads, captured at first release
# BATCH BB §5 — ROT'S LEAK GUARD, AND THE SIGN IS THE OPPOSITE OF THE TWO ABOVE.
# The severity-4 bargain HALVES maximum health for both parties; without a guard
# the victory sync would write the halved maximum onto the party member and a
# one-fight bargain would cost half the party's HP for the rest of the run —
# exactly why Batch AQ authored `rot`, implemented it, and dropped it.
#
# THREE FIELDS NOW MEET AT THAT ONE SITE AND THEIR SIGNS DIFFER. The sync ADDS
# this one back and SUBTRACTS the other two; `tenacity_hp_gained` is subtracted
# and additionally has the second consumer named above. Do not fold any of the
# three into another — see the block at battle.gd's victory branch.
var rot_hp_lost := 0          # Rot: max HP taken for one fight (added back at the sync)
var communion_ranks := 0      # Communion: (N x their own stacks)% to spread
var faithful_step := 0        # Blessed are the Faithful: +N pts on the 15% heal
var devoutness_ranks := 0     # Devoutness: party-wide BD cut, percentage POINTS
var afterglow_ranks := 0      # Afterglow: heal N% of Devout max on shield break
var covenant_heal := 0        # Sacred Covenant: lethal-save heal, % of max
var covenant_faith := 0       # Sacred Covenant: Faith granted by that save
var aegis_ranks := 0          # Radient Aegis: N% chance Divine Shield echoes
var blessed_barrier_ranks := 0 # Blessed Barrier: N% of absorbs become healing
var waters_ranks := 0         # Cleansing Waters: N% chance/turn to be cleansed
var pulse_ranks := 0          # Healing Pulse: N% of Devout max healed per turn
# Devout Batch K lanes (07-30): the purpose-designed tree's new hooks.
# BATCH BH §2 — TWO FIELDS WERE DELETED HERE RATHER THAN RE-POINTED IN PLACE,
# BECAUSE BOTH NODES CHANGED WHAT THEY MEAN AND NOT ONLY WHAT THEY PAY. That is
# the harder failure (the BA precedent: `plague_bearer` and `epidemic` went with
# their read sites so a later batch could not write one, and BD's `deadfall_armed`
# is the counter-example — same field, new unit, silently). Gone:
#   · `fervor_step`, the +N on Consecrated Ground's 1 Faith/turn drip. Fervor is
#     not a drip node any more, so the field has no meaning, no writer and no
#     reader. The BASE drip of 1 stays exactly as Batch AW §2 shipped it.
#   · `oath_ranks`, the remnant a release left standing. THAT REMNANT WAS ONE OF
#     THE THREE FREQUENCY MULTIPLIERS §2 EXISTS TO REMOVE — keeping 3 of 5 means
#     the next release costs two stacks instead of five — so it is deleted, not
#     re-priced. A release resets to zero again, as it did before Batch K.
var fervor := 0               # Fervor: a GATE. While Consecrated Ground holds,
                              # every ally's Faith stacks are worth double. It
                              # multiplies the HELD half and adds no releases at
                              # all; stacks with Apostle for quadruple. Shaped
                              # like `apostle` deliberately — one multiplier, one
                              # gate, one read site (`_faith_stack_mult`).
var oath_faith := 0           # Binding Oath: the Devout gains N Faith of HIS OWN
                              # whenever an ally's Faith releases.
var oath_opening := 0         # Rune-only (the Rune of the Binding Oath): N Faith
                              # the Devout opens the battle already holding. The
                              # rune's old clause bought a release remnant, which
                              # the re-spec deleted; this keeps the RELATIONSHIP
                              # — Faith that persists — through the door that
                              # still exists (the AZ Deep Sight / AY Deep Bond
                              # precedent). It is in `Runes.STAT_INT_KEYS`
                              # because a rune writes it and it does not end
                              # "_ranks" (the AA float-into-int trap).
var warded_ranks := 0         # Warded Robes: +N% armor while the shield holds
var stalwart_step := 0        # Stalwart: +N pts on Divine Shield's 30% absorb
var unyielding_ranks := 0     # Unyielding Aegis: re-forms at N% of strength
var righteous_step := 0       # Righteous Fire: +N pts on the ground's 10%
var crusade_ranks := 0        # Crusader's Tempo: Zeal ticks N extra cooldown
var purity_ranks := 0         # Purity: Zeal carries a shield of N% Devout max
var lifewell_ranks := 0       # Lifewell: reflected damage heals N% of itself
var apostle := 0              # capstone: each held Faith stack is worth
                              # DOUBLE (Batch BG §2 — it no longer touches
                              # what a release consumes; see _faith_stack_mult)
var judgement := 0            # capstone: Cons. Ground BD, % of damage dealt
                              # (the gate AND the magnitude — one field)
# Batch AW §5 — the two authored talent fallbacks (AU §1). Each is the extra
# a node pays when the hero already earned the ability it would have granted.
var resolve_extra_turns := 0  # Sacred Resolve owned: its split lasts +N turns
var bulwark_extra_turns := 0  # Bulwark of Fortitude owned: +N turns of effect

# Barrier-lethal hook (set by the battle scene): fires when a Divine
# Shield absorbs a hit that would otherwise have killed this unit.
var lethal_saved_cb := Callable()
# Conviction hook: fires whenever a Divine Shield barrier absorbs damage
# for this unit (the only source of Faith).
var shield_absorbed_cb := Callable()
var prevented_cb := Callable()  # Batch W sim ledger: barrier absorbs → (src_name, absorbed, holder, divine)
# BATCH BC §1 — the sim ledger's door out of unit.gd, for effects computed
# HERE that the battle scene cannot see. Three ride it, and none of the three
# had ever been credited to anybody: Blessed Barrier's conversion, Afterglow's
# mend and Devoutness's Break reduction. Fires as (src_name, amount, term) —
# THE TERM IS NAMED AT THE SITE THAT COMPUTES THE NUMBER, so the ledger prints
# terms rather than a pool and a later effect added here has to say which term
# it belongs to instead of silently vanishing the way these three did.
var credit_cb := Callable()

# Occultist tree (07-24; lanes re-specced Batch L 07-30; every counter went
# ADDITIVE in Batch AX — the field holds the MAGNITUDE, not a rank, and the
# read site applies no step of its own). See talents.gd for the node text.
#
# THREE HOLD THE INCREASE ON A BASE THE KIT ALREADY PAYS and are named `_step`
# for it (AV's `guardian_step` precedent, AW's four): `deep_hex_step` on the
# passive's 2%-per-stack, `soul_leech_step` on its 2%-per-stack lifesteal,
# `whispers_step` on Psychosis's own 50%. A FOURTH has the same shape and takes
# the same treatment — `barter_step` on Dark Pact's base 15% — reported in the
# changelog rather than silently generalised.
var emp_hex_ranks := 0        # Empowered Hex: % chance Hex applies Decay (100 = always)
var soul_leech_step := 0      # Soul Leech: +% per Ruin stack on the base 2%
var pleasure_pct := 0.0       # Pleasure from Pain: % max HP per unique debuff (FRACTIONAL
                              # — must NOT end in "_ranks" or STAT_INT_KEYS coerces it)
var channeling_ranks := 0     # Corrupted Channeling: crippled attackers feed
var murderous_ranks := 0      # Murderous Intent: bewitched kills heal
var invigoration_ranks := 0   # Invigoration: Dark Pact mana regen
var spread_ranks := 0         # Spread of Madness: % chance Psychosis leaps
var spread_ruin := 0          # Spread of Madness: Ruin the newly maddened take
var infusion_ranks := 0       # Dark Infusion: attack per unique debuff
var mirror_ranks := 0         # Umbral Mirror: % chance enemy debuffs reflect
var broken_will_ranks := 0    # Broken Will: +% Break damage dealt
var deep_hex_step := 0        # Deeper Hex: +% damage per Ruin stack on the base 2%
var grim_ranks := 0           # Grim Focus: +% detonation damage
var entropy_ranks := 0        # Entropy: Break damage any Ruin grinds each turn
var unravel_ranks := 0        # Unraveling: Ruin a detonation seeds in others
var whispers_step := 0        # Whispers: +% seize chance on Psychosis's base 50%
var delirium_ranks := 0       # Delirium: Ruin a maddened strike marks
var cackling_ranks := 0       # Cackling Mirror: % of a fellow-strike healed
var torment_ranks := 0        # Lingering Torment: Decay turns expired madness leaves
var gluttony_ranks := 0       # Gluttony: +% per Ruin stack (its own dial)
var pact_flesh_ranks := 0     # Pact of Flesh: percentage POINTS off Dark Pact's 20%
var barter_step := 0          # Dark Barter: +% on Dark Pact's base 15% party heal
var avatar_ruin := 0          # capstone: the Ruin threshold it installs (5), gate AND
                              # magnitude in one field (AW's `judgement` precedent)
var soul_glut := 0            # capstone: the Ruin lifesteal feeds everyone

# Active statuses: {id, label, short, color, turns}
var statuses: Array = []

# Battle-log hook (set by the battle scene) so talent procs that happen
# inside this unit (Enraged, Unrelenting Assault) reach the combat log.
var log_proc := Callable()

# Status-expiry hook (set by the battle scene): fires once per status
# that ticks out naturally, AFTER the expired entries are filtered away —
# so a handler may safely apply new statuses (Lingering Torment).
var status_expired_cb := Callable()

# Mercy hook (set by the battle scene on heroes): fires when this unit
# crosses below 50% health, from any damage source.
var below_half_cb := Callable()
# The two Holy reversal hooks (Batch AV) are declared with the rest of her
# state above: `intercession_cb` (asked whether the refusal can be PAID, so it
# returns a bool) and `martyrdom_cb` (reports a spent latch).


# The threshold is 50% by default; Guardian Angel stamps a higher one on
# the whole party at spawn.
func _check_below_half(was_above: bool) -> void:
	if is_hero and not is_companion and was_above \
			and hp <= max_hp * mercy_threshold and below_half_cb.is_valid():
		below_half_cb.call(self)


# The health Martyrdom hands back — named so the test can read the number the
# capstone text promises rather than a literal buried in a branch.
const MARTYRDOM_RETURN := 0.30


# THE ONE PLACE THE HOLY CLERIC'S TWO REVERSALS ANSWER A LETHAL BLOW (Batch
# AV). Called from take_hit AND take_tick_damage, so a tick death is refused
# exactly as an attack death is, and it sits AFTER a unit's own saves
# (Undying, Undying Rage, Ashes of Al'ar) — her net is the party's last one.
# THE ORDER IS DELIBERATE: Intercession is a cast with a two-turn window and
# a price, so it goes first. Letting a paid, expiring refusal lapse while a
# permanent capstone sat unused is the worse failure.
func _holy_reversal() -> void:
	if hp != 0:
		return
	# Intercession: the STATUS is the one answer to "is the refusal live", so
	# the window expires by itself and nothing has to remember to clear a
	# flag. The callback decides whether the Cleric can PAY the stack — it
	# returns false when she holds none, and then the hero simply dies.
	if has_status("intercession") and intercession_cb.is_valid() \
			and bool(intercession_cb.call(self)):
		hp = 1
		float_text("INTERCESSION", Color(0.95, 0.9, 0.55), true)
		return
	# Martyrdom (capstone): the first hero to fall each battle is returned at
	# 30%. A refusal-and-restore, not a death followed by a revive — the same
	# machinery Undying Rage and Ashes of Al'ar use, so the hero never leaves
	# the initiative order and no death is booked against the party.
	if martyrdom_guard and martyrdom_cb.is_valid():
		hp = maxi(int(max_hp * MARTYRDOM_RETURN), 1)
		float_text("MARTYRDOM", Color(0.95, 0.9, 0.55), true)
		martyrdom_cb.call(self)


# ASHES OF AL'AR — the phoenix refuses the grave, once per battle. ONE
# IMPLEMENTATION, TWO CALLERS (take_hit and take_tick_damage), so a tick death
# is refused exactly as an attack death is. It was written out twice before
# Batch BB gave the ability a home; the duplication is what let the two copies
# be re-pointed independently, so they share a function now.
#
# IT SITS ABOVE `_holy_reversal` AT BOTH CALLERS AND THAT ORDER IS AV'S: a
# unit's OWN saves answer first, and the Holy Cleric's net is the party's last.
func _ashes_guard() -> void:
	if hp != 0 or ashes_return <= 0 or ashes_used:
		return
	ashes_used = true
	hp = maxi(int(max_hp * 0.01 * ashes_return), 1)
	float_text("REBORN IN ASH", Color(1.0, 0.6, 0.2), true)
	_proc_log("Ashes of Al'ar — %s rises from the ashes (%d%% HP)" % [
		unit_name, ashes_return])


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


# Frees the sibling nameplate along with the unit — companion cleanup:
# a replaced beast must give its plate slot back (queue_free alone leaves
# the plate behind, because it is NOT a child of the unit).
func free_plate() -> void:
	if _plate_root != null and is_instance_valid(_plate_root):
		_plate_root.queue_free()
	_plate_root = null


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
		# Resonance has NO MAXIMUM (Batch AT), so the bar cannot read against
		# one: it fills toward RESONANCE_BAR_REF and pins there. The number
		# beside it is the honest readout — the raw stack count and what the
		# compounding curve is currently paying, both ways.
		# Focus has no ceiling either (Batch AZ) unless Spray of Arrows imposes
		# one, and `second_max` carries -1 to say so. Same treatment as
		# Resonance: fill toward a REFERENCE depth and pin there, and let the
		# number beside the bar be the honest readout — how much chance the
		# first half has bought, and what the converted half is paying.
		var uncapped := second_max < 0
		var res2_ref := RESONANCE_BAR_REF if second_resource_name == "Resonance" \
			else (FOCUS_BAR_REF if uncapped else float(second_max))
		_res2_fill.size.x = PLATE_BAR_W * clampf(second_resource / res2_ref, 0.0, 1.0)
		if second_resource_name == "Resonance":
			_res2_text.text = "%d (+%d%% dmg / +%d%% taken)" % [second_resource,
				int(round(resonance_dmg_bonus() * 100.0)),
				int(round(resonance_taken_bonus() * 100.0))]
		elif second_resource_name == "Focus" and uncapped:
			_res2_text.text = "Focus %d (+%d%% crit / x%s)" % [second_resource,
				int(round(focus_crit_chance() * 100.0)),
				String.num(lethal_crit_mult(), 2)]
		else:
			_res2_text.text = "%s %d/%d" % [second_resource_name, second_resource, second_max]
	if passive_id == "bloodrage":
		for s in statuses:
			if s.id == "spec_passive":
				var step := 2.0 + bloodrage_step_bonus
				var live := frenzy_bonus() * 100.0
				var floor_pct := frenzy_floor * 100.0
				# Scar Tissue rewrites how much of the peak the floor keeps
				# (2 = Unstoppable was taken as well — it keeps all of it).
				var keep_pct: int = [50, 85, 100][clampi(scar_tissue_ranks, 0, 2)]
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
				# Shieldwall's stance rides the same slice of the roll, so the
				# live total has to carry it or the readout lies while it holds.
				var wall := 0.0
				if has_status("shieldwall"):
					wall = 0.01 * maxi(status_power("shieldwall"), 0)
				var wall_line := ""
				if wall > 0.0:
					wall_line = "\nShieldwall's stance adds +%d%% while it holds." % \
						int(round(wall * 100.0))
				var total := (block_chance + 0.15 + plating_bonus + wall) * 100.0
				s.short = "Block %d%%" % int(round(total))
				s.desc = "Heavy Plating: +15%% Block chance on top of the\n%d%% base. Every unblocked attack adds +8%% for the\nrest of the battle (now +%d%%, cap +40%%); Blocking\nresets the bonus.%s\nTotal Block chance: %d%%." % [
					int(round(block_chance * 100.0)),
					int(round(plating_bonus * 100.0)), wall_line,
					int(round(total))]
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
	# Fleeting (Batch AQ): every status applied lasts one turn less, floored at
	# one. THE ONE read site for mod_status_turns, and it sits here rather than
	# in battle._apply_status because plenty of statuses (spec chips, Bracing,
	# Elusive, the beast's own marks) are added directly. BATTLE-LONG STATUSES
	# ARE EXEMPT: a negative turn count is a permanence flag, not a duration,
	# and shortening it would turn a permanent status into a 1-turn one.
	if turns > 0:
		turns = maxi(turns + mod_status_turns, 1)
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
				# Permafrost applications arrive with turns -1: the pile stops
				# thawing the moment the Cryomancer touches it.
				s.stacks = mini(int(s.get("stacks", 1)) + 1, 4)
				s.turns = turns
				s.short = "C%d" % s.stacks
				s.desc = _chilled_desc(int(s.stacks), turns < 0)
				float_text("Chilled x%d" % s.stacks, color)
			elif id == "ruin":
				# Ruin STACKS battle-long, and since Batch AX it has NO MAXIMUM
				# and NEVER CLEARS: corruption that resets is not corruption. A
				# detonation takes the PRIMER, never the mark. The chip's text is
				# re-stamped by battle._gain_ruin, the only site that can see the
				# Occultist's talents (per-stack bite AND threshold both move).
				s.stacks = int(s.get("stacks", 1)) + 1
				s.short = "R%d" % s.stacks
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
		entry["desc"] = _chilled_desc(1, turns < 0)
	statuses.append(entry)
	float_text(label, color)
	_refresh_chips()


static func _chilled_desc(stacks: int, permanent := false) -> String:
	var effect := "-25% speed"
	if stacks == 2:
		effect = "-50% speed"
	elif stacks >= 3:
		effect = "-50% speed, -15% damage dealt"
	var clock := "Permafrost: this chill never thaws" if permanent \
		else "Each stack resets the 3-turn clock"
	return "Chilled x%d: %s.\n%s;\nat 4 stacks the victim FREEZES solid." % [
		stacks, effect, clock]


func remove_status(id: String) -> void:
	statuses = statuses.filter(func(s): return s.id != id)
	_refresh_chips()


# Batch O: a Freeze no longer wipes the Chilled pile — battle.gd sets the
# surviving stack count directly (chip and tooltip follow along).
func set_chilled_stacks(n: int) -> void:
	for s in statuses:
		if s.id == "chilled":
			s.stacks = clampi(n, 1, 4)
			s.short = "C%d" % s.stacks
			s.desc = _chilled_desc(int(s.stacks), int(s.turns) < 0)
			_refresh_chips()
			return


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
	# Sticky statuses (Slow Acting / Perfected Toxin poison) refuse every
	# cleanse. Batch BA leans on this: Harvest is now paid for what the purge
	# actually TOOK, so what survives here is what it is not billed for.
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
	var expired: Array = []
	for s in statuses:
		if s.turns == 0 and s.id != "broken":
			_proc_log("   → %s fades from %s" % [s.label, unit_name])
			expired.append(s.id)
	statuses = statuses.filter(func(s): return s.id == "broken" or s.turns != 0)
	_refresh_chips()
	# The hook runs last: the list is already clean, so handlers can
	# apply fresh statuses without racing the filter above.
	if status_expired_cb.is_valid():
		for expired_id in expired:
			status_expired_cb.call(self, expired_id)


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
	# Frenzied (Batch AN): everyone acts faster. It multiplies the SPEED, not
	# the cooldowns — cooldowns tick in the unit's own turns, so a faster
	# unit reaches its next turn sooner but has not shortened anything, which
	# is exactly what "cooldowns unchanged" asks for.
	var s := speed * mod_speed_mult * (0.75 if has_status("slow") else 1.0)
	# Chilled deepens with stacks: 1 = -25% speed, 2+ = -50%. Frigid Grip
	# stamps its extra slow on the victim when the stack lands, and it is PER
	# STACK (Batch AS): at 10 points a stack, one stack is -35%, two is -70%,
	# three is -80%. That is the node §0 exists for — it is what makes the
	# initiative bar visibly move — and the 0.1 floor is what stops a deep
	# pile turning the divisor into zero.
	var chill := status_stacks("chilled") if has_status("chilled") else 0
	if chill == 1:
		s *= maxf(0.75 - frigid_bonus, 0.1)
	elif chill >= 2:
		s *= maxf(0.5 - frigid_bonus * chill, 0.1)
	if has_status("quickdraw"):
		s *= 1.5
	if has_status("wrath"):
		s *= 1.15
	return s


func effective_armor() -> float:
	# Brittle (Batch AN): all attacks ignore armor, on both sides. Returned
	# before every armor SOURCE rather than after them, so a build that
	# stacks Dominant Presence and Endurance is levelled with everyone else
	# instead of keeping a fraction of a bonus the modifier says is gone.
	if mod_ignore_armor:
		return 0.0
	var a := armor
	# Dominant Presence: armor value grows 5%/rank per debuff applied.
	if dominant_ranks > 0 and debuffs_applied > 0:
		a *= 1.0 + 0.15 * dominant_ranks * debuffs_applied
	# Endurance: +3%/rank armor per turn without an external heal, CAPPED at
	# +75% (Batch W, 08-02). The streak itself is uncapped, so a long fight
	# used to report absurd bonuses (+97,521% was measured); the final
	# minf(a, 0.85) below always clamped the real value, so the cap mostly
	# stops the chip and the log from lying — but it also bounds the term
	# for any future armor source that reads it before the clamp. Batch AL
	# tripled the step, which is what makes the cap a real ceiling: it is
	# reached on turn 25 rather than turn 75.
	a += minf(0.03 * endurance_ranks * endurance_stacks, 0.75)
	# Melt Armor: Burn ticks have eaten this much off for the battle.
	a = maxf(a - melted, 0.0)
	if has_status("fortify"):
		a += 0.10
	# Warded Robes (a Divine Shield rider): the barrier hardens its
	# holder while it holds.
	var ward := float(get_status("barrier").get("warded", 0.0))
	if ward > 0.0:
		a += ward
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
				var pct := 12 * iron_will_ranks * n
				s.short = "-%d%%" % pct
				s.desc = "Iron Will: takes 12%% less damage\nfor every debuff on the Warden.\nCurrently -%d%% (%d debuff%s)." % [
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
		# Batch Z: a chip surfaces its glossary line when it has one and the
		# chip's own text doesn't already say the same thing — the highest-
		# value contextual door into the glossary.
		var gl_short := Glossary.status_short(String(s.id))
		if gl_short != "" and gl_short != String(s.desc):
			chip.tooltip_text += "\n— %s (see Glossary)" % gl_short
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
	# Scar Tissue: the floor keeps 85% of the peak instead of half — or ALL
	# of it at 2, which is the node plus its cross-row partner Unstoppable
	# (see the Batch AJ header in talents.gd). At 100% the floor tracks the
	# peak exactly, so the bonus never falls at all.
	var keep: float = [0.5, 0.85, 1.0][clampi(scar_tissue_ranks, 0, 2)]
	if current * keep > frenzy_floor:
		frenzy_floor = current * keep
		if scar_tissue_ranks > 0:
			_proc_log("Talent: Scar Tissue — %s's Frenzy floor scars in at +%d%%" % [
				unit_name, int(round(frenzy_floor * 100.0))])
	return maxf(current, frenzy_floor)


# BATCH BF §1 — ONE LINE PER BREAK REDUCER, and every one of them goes through
# here. `src` is whoever's work it was: a caster's name stamped on the status
# for party-wide effects, or the unit's own name for the ones a hero does to
# himself (Bracing, Immovable). An empty `src` is NOT silently swallowed — it
# reaches the ledger's "(unattributed)" bucket, because a known gap is useful
# and a silent one isn't (the `_contrib_name` rule).
#
# HERO-SIDE ONLY. Break refused on an ENEMY is not the party's work, and
# crediting it would put an enemy's Constitution in a hero's column.
func _credit_bd(cut: int, term: String, src: String) -> void:
	if cut > 0 and is_hero and credit_cb.is_valid():
		credit_cb.call(src, cut, term)


func take_hit(amount: int, pressure_add: int) -> Dictionary:
	if amount > 0:
		damaged_since_turn = true  # Unbroken Watch bookkeeping
	# One Soul (Beastmaster capstone): a wound to ANY member of the bond
	# divides across EVERY LIVING member of it. BATCH AY §1 decided this
	# explicitly rather than letting The Pack decide it by accident — with two
	# beasts the bond is three bodies and each takes a third, not a half. The
	# guard is set on the RECEIVER before the recursive call, so a mate can
	# never re-split the share it is being handed.
	if amount > 1 and not _soul_guard and not dead and not soul_bond.is_empty():
		var mates: Array = soul_bond.filter(func(m): return m != self \
			and is_instance_valid(m) and not m.dead)
		if not mates.is_empty():
			var shared: int = amount / (mates.size() + 1)
			if shared > 0:
				amount -= shared * mates.size()
				for mate in mates:
					mate._soul_guard = true
					mate.take_hit(shared, 0)
					mate._soul_guard = false
				float_text("Soul-split", Color(0.75, 0.6, 0.95))
				_proc_log("One Soul: %s shares %d of the wound with %s" % [
					unit_name, shared, ", ".join(
						mates.map(func(m): return m.unit_name))])
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
				# BATCH BC §1: the return was being DISCARDED, so a heal into a
				# full bar read the same as one into an empty one — and neither
				# reached the ledger at all. Both fixed here.
				var bb_got := heal_amount(bb_heal)
				float_text("+%d" % bb_got, Color(0.4, 0.9, 0.45))
				if bb_got > 0 and credit_cb.is_valid():
					credit_cb.call(String(s.get("src", "")), bb_got, "blessed")
				_proc_log("Talent: Blessed Barrier — %s converts %d absorbed into healing" % [
					unit_name, bb_got])
			# Conviction: only Divine Shield absorbs build Faith.
			if absorbed > 0 and s.get("divine", false) \
					and shield_absorbed_cb.is_valid():
				shield_absorbed_cb.call(self)
			# Batch W: the absorb is prevented damage — report it with the
			# caster stamped on the barrier ("" lands in the unattributed
			# bucket battle-side).
			# BATCH BC §1 carries the `divine` flag through, because "prevented"
			# pools every barrier in the game — Holy's Blessed Vestments ward
			# included — and the decomposition needs DIVINE SHIELD'S absorbs
			# alone. Read off the same flag the Faith trigger reads, one line up,
			# so the two can never disagree about what a Divine Shield is.
			if absorbed > 0 and prevented_cb.is_valid():
				prevented_cb.call(String(s.get("src", "")), absorbed, self,
					bool(s.get("divine", false)))
			if would_have_died and amount < hp and lethal_saved_cb.is_valid():
				lethal_saved_cb.call(self)
			if s.power <= 0:
				var glow := int(s.get("afterglow", 0))
				# Unyielding Aegis: the breaking shield re-forms once per
				# cast at a share of its original strength (Afterglow still
				# fires — the shield DID break).
				var reform_pct := float(s.get("unyielding_pct", 0.0))
				if reform_pct > 0.0:
					s.power = maxi(int(round(int(s.get("original", 0)) * reform_pct)), 1)
					s["unyielding_pct"] = 0.0
					float_text("Re-formed %d" % s.power, Color(0.4, 0.85, 0.95))
					_proc_log("Talent: Unyielding Aegis — %s's shield re-forms at %d" % [
						unit_name, s.power])
				else:
					remove_status("barrier")
				if glow > 0:
					var glow_got := heal_amount(glow)
					float_text("+%d" % glow_got, Color(0.95, 0.9, 0.6))
					if glow_got > 0 and credit_cb.is_valid():
						credit_cb.call(String(s.get("src", "")), glow_got,
							"afterglow")
					_proc_log("Talent: Afterglow — the breaking shield mends %s for %d" % [
						unit_name, glow_got])
			break
	# Conversion (Arcanist talent): part of the pain bleeds off as Mana.
	# ADDITIVE — the counter is percentage POINTS of the hit (Batch AT).
	if conversion_ranks > 0 and resource_name == "Mana" and amount > 0:
		var converted := mini(int(round(amount * 0.01 * conversion_ranks)), resource)
		if converted > 0:
			amount -= converted
			resource -= converted
			float_text("-%d Mana" % converted, Color(0.5, 0.7, 1.0))
			_proc_log("Talent: Conversion — %s pays %d of the hit in Mana" % [
				unit_name, converted])
	# Stable Alignment (Arcanist talent): one attack can only cut so deep.
	# ADDITIVE — the counter IS the cap as a % of max health (Batch AT).
	if stable_ranks > 0 and amount > 0:
		var stable_cap := maxi(int(round(max_hp * 0.01 * stable_ranks)), 1)
		if amount > stable_cap:
			float_text("ALIGNED -%d" % (amount - stable_cap), Color(0.75, 0.7, 0.95))
			_proc_log("Talent: Stable Alignment — the hit is capped at %d (%d%% max HP)" % [
				stable_cap, stable_ranks])
			amount = stable_cap
	# EVENT HORIZON (Arcanist capstone, Batch AT): the reward for escalating is
	# that escalating stops killing you. Deep enough into Runaway Resonance, no
	# SINGLE attack can put him down — it leaves him on 1. Deliberately sits
	# AFTER Stable Alignment (a capped hit is what it is asked to survive) and
	# before the subtraction, so nothing downstream sees a lethal number.
	if event_horizon > 0 and second_resource >= event_horizon \
			and amount > 0 and amount >= hp:
		amount = maxi(hp - 1, 0)
		float_text("EVENT HORIZON", Color(0.85, 0.55, 1.0))
		_proc_log("Talent: Event Horizon — %s cannot be reduced below 1 health" % unit_name)
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
	_ashes_guard()
	_holy_reversal()
	if resource_name == "Rage":
		resource = mini(resource + 10, max_resource)
	# Enraged (talent): dropping below half HP grants a stacking damage buff,
	# shown as a chip that tracks the current bonus.
	if enraged_ranks > 0 and was_above_half and hp <= max_hp * 0.5 and hp > 0:
		enraged_stacks = mini(enraged_stacks + 1, 3)
		enraged_timer = 5
		var enr_pct := 12 * enraged_ranks * enraged_stacks
		var enr_desc := "Enraged: +12%% damage per stack, gained\nby dropping below half health\n(max 3 stacks). Currently +%d%% (x%d)." % [
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
		var con_gain := 40 * unrelenting_ranks
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
		resource = mini(resource + 60, max_resource)
		# Batch AJ: the node buys a whole TURN back, so the cooldowns go with
		# the Rage. Clearing the dict is the same thing the debug restore
		# does — nothing else on the unit tracks a cooldown.
		var sw_cleared := cooldowns.size()
		cooldowns.clear()
		float_text("SECOND WIND +60 Rage", Color(1.0, 0.5, 0.4))
		_proc_log("Talent: Second Wind — %s surges back (+60 Rage, %d cooldown%s cleared)" % [
			unit_name, sw_cleared, "" if sw_cleared == 1 else "s"])
	# Deathwish (talent): crossing under 35% health, the edge sharpens.
	if deathwish_ranks > 0 and not was_below_deathwish \
			and hp < max_hp * 0.35 and hp > 0:
		float_text("DEATHWISH +%d%%" % (25 * deathwish_ranks), Color(0.9, 0.3, 0.3))
		_proc_log("Talent: Deathwish — %s deals +%d%% damage below 35%% health" % [
			unit_name, 25 * deathwish_ranks])
	# Mana Shield: half the pain flows back as Mana.
	if has_status("mana_shield") and resource_name == "Mana" and amount > 0:
		var converted := maxi(int(amount * 0.5), 1)
		resource = mini(resource + converted, max_resource)
		float_text("+%d Mana" % converted, Color(0.5, 0.7, 1.0))
	# Constitution: break resistance (100 = neutral; higher takes less Pressure).
	# Bracing (Swordmaster talent): the raised guard is harder to Break.
	#
	# BATCH BF §1 — EVERY LINE FROM HERE DOWN THAT LOWERS `pressure_add` NOW SAYS
	# SO, through `_credit_bd` and the single door it reaches in battle.gd. Until
	# this batch exactly ONE of them did (Devoutness), so a Warden holding the
	# line and a Devout raising the Bulwark both measured zero. THE ARITHMETIC IS
	# UNTOUCHED: every credit reads a delta either side of a line that already
	# existed. Two classes are deliberately NOT booked and the reasons differ —
	#   base Constitution: a stat block is not a contribution, the same rule that
	#     keeps base armor and resists out of `prev_hero_`. BRACING *is* booked,
	#     because a stance a talent bought is exactly what the damage side counts.
	#   `mod_bd_mult` / `mod_no_break`: run modifiers. Nobody in the party did
	#     that, and a contribution ledger that credits the weather is worthless.
	var eff_con := constitution + ((30 * bracing_ranks) if stance == "defensive" else 0)
	var bd_raw := pressure_add
	pressure_add = int(round(pressure_add * 100.0 / maxf(eff_con, 1.0)))
	if bracing_ranks > 0 and stance == "defensive":
		# What the same hit would have cost at his UNBRACED Constitution: the
		# node's whole effect is the gap between the two divisors.
		_credit_bd(int(round(bd_raw * 100.0 / maxf(constitution, 1.0))) - pressure_add,
			"bd_bracing", unit_name)
	if has_status("ward"):
		var wd_was := pressure_add
		pressure_add = int(pressure_add * 0.5)
		_credit_bd(wd_was - pressure_add, "bd_ward",
			String(get_status("ward").get("src_name", "")))
	# Devoutness (talent, ex-Devotion Aura): power carries the % cut.
	if has_status("devotion"):
		# BATCH BC §1: the Break points this removes are NOT damage, so they
		# have never belonged in `prev_hero_` and were never counted anywhere
		# at all. They get their own term and their own units.
		var dvn_was := pressure_add
		pressure_add = int(pressure_add * (1.0 - status_power("devotion") / 100.0))
		_credit_bd(dvn_was - pressure_add, "devoutness_break",
			String(get_status("devotion").get("src_name", "")))
	# Hold the Line: the status carries its own cut, so the UPGRADED cast
	# (the capstone landing on an already-earned copy) is 80% rather than
	# 50% without a second status or a second read site here. Power 0 on a
	# pre-AL save's status falls back to the base 50.
	if has_status("hold_bd"):
		# Integer arithmetic on purpose: a float 1.0 - 80/100.0 lands at
		# 0.19999999 and an 80% cut on 100 Break would read 19, not 20.
		var hl_cut := maxi(status_power("hold_bd"), 50)
		var hl_was := pressure_add
		pressure_add = pressure_add * (100 - hl_cut) / 100
		_credit_bd(hl_was - pressure_add, "bd_hold_line",
			String(get_status("hold_bd").get("src_name", "")))
	# Muffled (Batch AQ): every meter fills slowly. Integer percent, for the
	# same reason its neighbour above is — and unguarded, because x100/100 on
	# an int is the identity, so the no-modifier path stays byte for byte.
	pressure_add = pressure_add * mod_bd_mult / 100
	# Bulwark of Fortitude: NO Break damage while the stand holds.
	if has_status("bulwark"):
		_credit_bd(pressure_add, "bd_bulwark",
			String(get_status("bulwark").get("src_name", "")))
		pressure_add = 0
	# Deadened (Batch AQ): the Break meter does nothing this fight. It zeroes
	# the same number `immovable` does, one line below, but through its OWN
	# field — Immovable logs a Warden capstone proc, and a modifier claiming to
	# be somebody's capstone is a lying log.
	if mod_no_break:
		pressure_add = 0
	# Immovable (Warden capstone): he cannot be Broken, ever.
	if immovable > 0 and pressure_add > 0:
		if not immovable_noted:
			immovable_noted = true
			_proc_log("Capstone: Immovable — %s cannot be Broken" % unit_name)
		_credit_bd(pressure_add, "bd_immovable", unit_name)
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
	_ashes_guard()
	_holy_reversal()
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
	# Chain Ignition reads the Burn this unit died with — turns AND tick — so
	# it can split the flame among the survivors whole rather than re-rolling
	# a fresh one. (Seeding Embers read the same snapshot; its node is gone.)
	var burn_stat := get_status("burn")
	if not burn_stat.is_empty():
		burn_at_death = maxi(int(burn_stat.get("turns", 0)), 0)
		burn_tick_at_death = maxi(int(burn_stat.get("tick", 0)), 0)
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
	# Bloodless (Batch AN): no healing for anyone. It sits at the top of the
	# heal pipeline with the other absolute refusals — Bleed and every
	# damage-over-time run through take_hit and are untouched by it, which is
	# the whole shape of the modifier.
	if mod_no_heals:
		if amount > 0:
			float_text("BLOODLESS", Color(0.7, 0.2, 0.25))
		return 0
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
		mult *= 1.30
	if has_status("frostbite"):
		mult *= 0.5
	# Last Hope (Holy talent, party-wide stamp): the nearly-dead heal deeper.
	# ADDITIVE units (Batch AV) — the stamp is percentage POINTS, so the
	# node's 40 and the Rune of the Open Hand's 5 each pay what they say.
	if last_hope_bonus > 0 and hp < max_hp * 0.25:
		mult *= 1.0 + 0.01 * last_hope_bonus
	# Batch AA guard: healing may be reduced to nothing, never INVERTED. The
	# multiplier is a running sum of rune terms (Vampiric, Killing Cold, the
	# Hollow Chalice…) and a negative one would quietly turn every heal into
	# damage that bypasses death handling. No reachable loadout gets there
	# today — this is here so a future rune cannot open the hole silently.
	mult = maxf(mult, 0.0)
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
