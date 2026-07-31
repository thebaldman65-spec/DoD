# FIXED talent trees only (designed in the RPG Skill Tree Generator; source
# JSONs live in data/talent-tree-*.json — this file is their hand-tuned
# conversion). Specs without a designed tree show "coming soon" on the party
# screen. Learned talents: {id: ranks}. Ranks are ADDITIVE: every extra point
# adds the same stated amount again. Tooltips never say "per rank" — descs
# hold a "{v}" placeholder and a "scale" {base, step}; desc_for() renders the
# value at the invested ranks (rank-1 preview when unlearned).
#
# Gating: rows unlock cumulatively (row 1 needs 5 pts, row 2 needs 10,
# row 3 — the capstone — needs 15), PLUS explicit per-node prerequisites
# ("requires" id at "requires_ranks" points).
class_name Talents

const ROW_REQ := {0: 0, 1: 5, 2: 10, 3: 15}

const FIXED_TREES := {
	"arcanist": [
		# --- row 0 ---
		{"id": "ar_mindfulness", "name": "Mindfulness", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every {v} of your turns, ALL of your cooldowns tick down 1 extra turn.",
			"scale": {"base": 7, "step": -1},
			"payload": {"stat": {"mindfulness_ranks": 1}}},
		{"id": "ar_mastery", "name": "Arcane Mastery", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Each stack of Arcane Resonance grants {v}% extra critical strike chance (on top of the base 3%).",
			"scale": {"step": 1},
			"payload": {"stat": {"arcane_mastery_ranks": 1}}},
		{"id": "ar_attunement", "name": "Mana Attunement", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Restore {v}% of your maximum Mana every time you gain a stack of Resonance.",
			"scale": {"step": 2},
			"payload": {"stat": {"mana_attune_ranks": 1}}},
		# --- row 1 ---
		{"id": "ar_temporal", "name": "Temporal Rift", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Critical strikes have a {v}% chance to echo for 25% of their damage against a random enemy.",
			"scale": {"step": 3},
			"payload": {"stat": {"temporal_ranks": 1}}},
		{"id": "ar_on_edge", "name": "On the Edge", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Surviving an attack below {v}% health grants 1 stack of Resonance.",
			"scale": {"base": 20, "step": 5},
			"payload": {"stat": {"on_edge_ranks": 1}}},
		{"id": "ar_overcharge", "name": "Overcharge", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Overcharge — raise your maximum Resonance to 8; stacks beyond 5 give 1.5x their normal Resonance bonus (20 Mana, 2.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Overcharge", "cost": 20,
				"special": "overcharge", "delay": 2.0, "anim": "attack02", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Stacks beyond 5 give 1.65x instead",
				"description": "Push past the limit: maximum\nResonance becomes 8; stacks beyond\n5 give 1.5x their normal Resonance\nbonus (damage, crit, damage taken)."}}},
		{"id": "ar_conversion", "name": "Conversion", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "{v}% of damage taken is lost as Mana instead of health.",
			"scale": {"step": 10},
			"payload": {"stat": {"conversion_ranks": 1}}},
		{"id": "ar_critical_mass", "name": "Critical Mass", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every 3rd critical strike deals {v}% more damage and restores half as much of your maximum Mana.",
			"scale": {"step": 20},
			"payload": {"stat": {"critical_mass_ranks": 1}}},
		# --- row 2 ---
		{"id": "ar_suppressing", "name": "Suppressing Fire", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Each bolt of Arcane Barrage deals {v}% of Attack more than the previous one.",
			"scale": {"step": 0.25},
			"payload": {"stat": {"suppressing_ranks": 1}}},
		{"id": "ar_unlimited", "name": "Unlimited Power", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Gaining Resonance while already at maximum stacks instead grants +{v}% damage and +{v}% maximum Mana (stacks all battle).",
			"scale": {"step": 2},
			"payload": {"stat": {"unlimited_ranks": 1}}},
		{"id": "ar_stable", "name": "Stable Alignment", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "You cannot lose more than {v}% of your maximum health to a single attack.",
			"scale": {"base": 40, "step": -5},
			"payload": {"stat": {"stable_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "ar_wrath", "name": "Magi's Wrath", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Magi's Wrath — 15% of Attack as arcane to ALL enemies, +4% per Resonance stack; BD = 2.5 x stacks; recoil 15% of damage dealt, -3% per enemy hit (30 Mana, 4.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Magi's Wrath", "cost": 30,
				"dmg_type": "arcane", "damage": 15, "pressure": 0, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 4, "recoil_base": 0.15,
				"perfect_id": "", "perfect_text": "Costs 3.5 initiative instead",
				"description": "The storm unchained: rakes the whole\nenemy team, +4% damage per Resonance\nstack; BD = 2.5 x stacks. Recoil 15%\nof damage dealt, -3% per enemy hit."}}},
	],
}


# ---------- LANE TREES (Batch 30 framework pilot: Beastmaster) ----------
# Lanes are playstyles, not beasts. A lane opens its own next tier on points
# spent IN THAT LANE (tier 1 at 3, tier 2 at 6); capstones need 8 in their
# lane and only ONE capstone may ever be taken. Node pricing: the Nth
# DISTINCT node you buy costs ceil(N/3) — 1,1,1,2,2,2,3... — while extra
# ranks in an open node always cost 1. "exclusive_with" pairs bar each
# other but stay visible (the player must see the door they closed).
const LANE_TIER_REQ := {0: 0, 1: 3, 2: 6}
const CAPSTONE_REQ := 8
# Node-gated trees (Sharpshooter pilot, Batch 32): tiers open on NODES
# BOUGHT in the lane instead of points spent — stable against the
# escalating cost curve. Marked by "node_gated" on the tree's first node.
const NODE_TIER_REQ := {0: 0, 1: 2, 2: 4}
const NODE_CAPSTONE_REQ := 6
const LANE_NAMES := {"devotion": "Devotion", "pack": "The Pack", "handler": "Handler"}

const LANE_TREES := {
	"berserker": [
		# Purpose-designed lanes (Batch C, 07-27) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). The 12 original
		# nodes keep their ids and payloads verbatim; the Batch 31 conversion
		# fillers were re-specced IN PLACE (same ids, new effects), so saved
		# ranks migrate and nobody gets a refund.
		# --- Lane A: Bloodletting — wounds as an engine: keep bleed high,
		# or burst it. Bleedout is no longer just a meter reset. ---
		{"id": "bz_savagery", "name": "Savagery", "ranks": 3, "lane": "Bloodletting", "tier": 0,
			"node_gated": true,
			"desc": "All bleed-building Berserker abilities build +{v} more Bleed.",
			"scale": {"step": 5},
			"payload": {"stat": {"bleed_bonus": 5}}},
		{"id": "bz_bloodcraze", "name": "Bloodcraze", "ranks": 3, "lane": "Bloodletting", "tier": 0,
			"desc": "When an enemy bleeds out, the Berserker heals {v}% of max HP.",
			"scale": {"step": 3},
			"payload": {"stat": {"bloodcraze": 1}}},
		{"id": "bz_crushing_blows", "name": "Crushing Blows", "ranks": 3, "lane": "Bloodletting", "tier": 1,
			"desc": "For every 20 points of bloodloss on the enemy team, gain {v}% armor penetration.",
			"scale": {"step": 3},
			"payload": {"stat": {"crushing_blows_ranks": 1}}},
		{"id": "bz_hemorrhage", "name": "Hemorrhage", "ranks": 3, "lane": "Bloodletting", "tier": 1,
			"desc": "Enemies at {v} or more bloodloss are Crippled.",
			"scale": {"base": 90, "step": -10},
			"payload": {"stat": {"hemorrhage_ranks": 1}}},
		# Re-spec (was Gushing Wounds, a Savagery duplicate; same id, so
		# saved ranks carry — the cr_frostbite "Brittle Ice" trick). The
		# compounding ramp the archetype was missing.
		{"id": "bz_gushing", "name": "Scent of Blood", "ranks": 3, "lane": "Bloodletting", "tier": 1,
			"desc": "+{v}% damage for each enemy that has bled out this battle.",
			"scale": {"step": 3},
			"payload": {"stat": {"scent_ranks": 1}}},
		# Re-spec (was Arterial Rhythm, +4 BD on Hack and Slash).
		{"id": "bz_arterial", "name": "Arterial Spray", "ranks": 2, "lane": "Bloodletting", "tier": 2,
			"desc": "When an enemy bleeds out, {v}% of its blood buildup transfers to another living enemy.",
			"scale": {"step": 25},
			"payload": {"stat": {"arterial_ranks": 1}}},
		# Re-spec (was Feast of Ruin, a Bloodcraze duplicate). The first
		# node that ties Bleed to Rage — those systems never touched.
		{"id": "bz_feast", "name": "Blood Tithe", "ranks": 2, "lane": "Bloodletting", "tier": 2,
			"desc": "An enemy bleeding out grants the Berserker {v} Rage.",
			"scale": {"step": 15},
			"payload": {"stat": {"blood_tithe_ranks": 1}}},
		# --- Lane B: Fury — the risk dial: how far over the edge? ---
		{"id": "bz_unstoppable", "name": "Unstoppable", "ranks": 3, "lane": "Fury", "tier": 0,
			"desc": "Blood Frenzy grants {v}% damage for every 5% of health missing (up from the base 2%).",
			"scale": {"base": 2.0, "step": 0.5},
			"payload": {"stat": {"bloodrage_step_bonus": 0.5}}},
		# Stays in Fury: a Rage-spent buff. Its bleed scaling is deliberate
		# cross-lane synergy — splashing into Bloodletting makes it better.
		{"id": "bz_battle_shout", "name": "Battle Shout", "ranks": 1, "lane": "Fury", "tier": 0,
			"desc": "New ability: Battle Shout — +1% damage for every 20 points of blood buildup on the enemy party, for 2 turns (15 Rage, 2cd).",
			"payload": {"new_ability": {"display_name": "Battle Shout", "cost": 15,
				"special": "battle_shout", "delay": 2.0, "anim": "attack03", "cooldown": 2,
				"perfect_id": "rage5", "perfect_text": "Also grants 5 Rage",
				"description": "A roar fed by open wounds: +1% damage\nper 20 blood buildup on the enemy party.\nLasts 2 turns."}}},
		{"id": "bz_enraged", "name": "Enraged", "ranks": 3, "lane": "Fury", "tier": 1,
			"desc": "Dropping below 50% health grants a +{v}% damage buff for 5 turns (stacks up to 3 times).",
			"scale": {"step": 3},
			"payload": {"stat": {"enraged_ranks": 1}}},
		{"id": "bz_reckless", "name": "Reckless Fury", "ranks": 3, "lane": "Fury", "tier": 1,
			"exclusive_with": "bz_measured",
			"desc": "+{v}% damage dealt AND +{v}% damage taken.",
			"scale": {"step": 5},
			"payload": {"stat": {"dmg_bonus": 0.05, "dmg_taken_bonus": 0.05}}},
		# Moved from Warpath: its exclusive partner lives here — the player
		# should see both doors in one column.
		{"id": "bz_measured", "name": "Measured Rage", "ranks": 1, "lane": "Fury", "tier": 1,
			"exclusive_with": "bz_reckless",
			"desc": "Take 8% less damage. A steadier hand than Reckless Fury.",
			"payload": {"stat": {"dmg_taken_bonus": -0.08}}},
		# Re-spec (was Frenzied Edge, +2% crit): deepens the Blood Frenzy
		# floor directly — the lane's signature.
		{"id": "bz_frenzied_edge", "name": "Scar Tissue", "ranks": 3, "lane": "Fury", "tier": 2,
			"desc": "The Blood Frenzy floor holds 60/70/75% of your peak bonus (instead of 50%).",
			"payload": {"stat": {"scar_tissue_ranks": 1}}},
		# Re-spec (was a flat +4% damage dial): same name, now conditional.
		{"id": "bz_deathwish", "name": "Deathwish", "ranks": 3, "lane": "Fury", "tier": 2,
			"desc": "+{v}% damage dealt while below 35% health.",
			"scale": {"step": 6},
			"payload": {"stat": {"deathwish_ranks": 1}}},
		# --- Lane C: Warpath — momentum: keep swinging, or survive to
		# keep swinging. ---
		{"id": "bz_vitality", "name": "Vitality", "ranks": 3, "lane": "Warpath", "tier": 0,
			"desc": "+{v}% max HP.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# Moved from Fury: a cooldown node is tempo, not fury.
		{"id": "bz_warcry", "name": "Deafening Cry", "ranks": 1, "lane": "Warpath", "tier": 0,
			"desc": "Battle Shout's cooldown is reduced by 1 turn.",
			"payload": {"ability": "Battle Shout", "add": {"cooldown": -1}}},
		{"id": "bz_unrelenting", "name": "Unrelenting Assault", "ranks": 3, "lane": "Warpath", "tier": 1,
			"desc": "Dropping below 25% health grants +{v} Constitution for 3 turns (at most once every 5 turns).",
			"scale": {"step": 10},
			"payload": {"stat": {"unrelenting_ranks": 1}}},
		# "Flurry" since 07-27 — the ability Bloodlust kept the name; the id
		# stays bz_bloodlust_node so saved ranks survive (the cr_frostbite →
		# "Brittle Ice" trick).
		{"id": "bz_bloodlust_node", "name": "Flurry", "ranks": 1, "lane": "Warpath", "tier": 1,
			"desc": "Hack and Slash strikes an extra time.",
			"payload": {"ability": "Hack and Slash", "add": {"multi_hits": 1}}},
		# Re-spec (was Thick Skin, flat -3% damage taken; ranks 3 → 2 — the
		# loader refunds any over-cap saved rank).
		{"id": "bz_thick_skin", "name": "Bloodied Momentum", "ranks": 2, "lane": "Warpath", "tier": 1,
			"desc": "When an enemy is slain, the Berserker gains {v} Rage.",
			"scale": {"step": 15},
			"payload": {"stat": {"bloodied_momentum_ranks": 1}}},
		{"id": "bz_relentless", "name": "Relentless", "ranks": 2, "lane": "Warpath", "tier": 2,
			"desc": "Hack and Slash costs {v} less Rage.",
			"scale": {"step": 5},
			"payload": {"ability": "Hack and Slash", "add": {"cost": -5}}},
		# Re-spec (was Bloodied Hide, +3% armor; ranks 2 → 1): the near-death
		# moment becomes a turn instead of just a scare.
		{"id": "bz_bloodied_hide", "name": "Second Wind", "ranks": 1, "lane": "Warpath", "tier": 2,
			"desc": "The first time you drop below 25% health each battle, immediately gain 40 Rage.",
			"payload": {"stat": {"second_wind": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		# Re-spec (was a passive stat pile: +10 Bleed, Hemorrhage one step).
		{"id": "bz_exsanguinate", "name": "Exsanguination", "ranks": 1, "lane": "Bloodletting", "tier": 2,
			"capstone": true,
			"desc": "Bleedout deals 35% of max HP (up from 20%), and the victim's full blood buildup surges to another living enemy — chaining across the field.",
			"payload": {"stat": {"exsanguination": 1}}},
		# Re-spec (was +12% HP / -5% damage taken) and moved from Warpath:
		# the risk capstone belongs to Fury.
		{"id": "bz_undying", "name": "Undying Rage", "ranks": 1, "lane": "Fury", "tier": 2,
			"capstone": true,
			"desc": "While below 25% health the Berserker cannot die and deals +50% damage. The hit that would have killed him ends the rage at 1 HP (once per battle).",
			"payload": {"stat": {"undying_rage": 1}}},
		# Moved from Fury: chain-on-kill is momentum's payoff.
		{"id": "bz_rampage", "name": "Rampage", "ranks": 1, "lane": "Warpath", "tier": 2,
			"capstone": true,
			"desc": "New ability: Rampage — strike 3 times for damage and bloodloss; if the target dies, immediately recast on another enemy (40 Rage, 4.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 40,
				"damage": 20, "pressure": 10, "multi_hits": 3, "bleed_build": 10,
				"delay": 4.0, "anim": "attack01", "cooldown": 4,
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "",
				"description": "Three brutal strikes, each building\n10 bloodloss. If the target dies, Rampage\nimmediately recasts on another enemy."}}},
	],
	"swordmaster": [
		# Purpose-designed lanes (Batch F, 07-30) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). Every id
		# survives and re-specs in place, so saved ranks migrate. Duelist
		# and Poise were the same lane twice (all parry and defence), while
		# NOTHING in the tree touched Break — the kit's engine since Batch
		# E. So all parry lives in Poise now, and Duelist became BREAKER:
		# Break generation and Broken-window exploitation.
		# --- Lane A: Blade — damage, crit, and the Aggressive stance. ---
		{"id": "sm_agg_stance", "name": "Aggressive Stance", "ranks": 3, "lane": "Blade", "tier": 0,
			"node_gated": true,
			"desc": "The Aggressive stance grants an additional {v}% damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"seasoned_off_bonus": 0.03}}},
		{"id": "sm_lunge", "name": "Lunge", "ranks": 1, "lane": "Blade", "tier": 0,
			"desc": "New ability: Lunge — 35 damage; applies Exposed in Aggressive stance, Cripple in Defensive (25 Rage, 3.5 int).",
			"payload": {"new_ability": {"display_name": "Lunge", "cost": 25,
				"damage": 35, "pressure": 20, "delay": 3.5, "anim": "attack02",
				"resource_gain": 10,
				"perfect_id": "", "perfect_text": "Initiative cost 3.0 instead",
				"description": "A committed thrust. In Aggressive\nstance it Exposes the target; in\nDefensive it Cripples them (3 turns).\nBuilds 10 Rage."}}},
		# Re-spec (was Keen Edge, flat +2% crit; same id, so saved ranks
		# carry): keyed to the stance — Aggressive gets an identity past
		# its flat +15%.
		{"id": "sm_keen_edge", "name": "Killing Edge", "ranks": 3, "lane": "Blade", "tier": 0,
			"desc": "+{v}% critical strike chance while in the Aggressive stance.",
			"scale": {"step": 4},
			"payload": {"stat": {"killing_edge_ranks": 1}}},
		{"id": "sm_precision", "name": "Precision Strikes", "ranks": 3, "lane": "Blade", "tier": 1,
			"desc": "+{v}% critical strike chance against Dazed, Crippled, and Exposed targets.",
			"scale": {"step": 5},
			"payload": {"stat": {"precision_ranks": 1}}},
		{"id": "sm_seasoned_node", "name": "Seasoned Fighter", "ranks": 3, "lane": "Blade", "tier": 1,
			"desc": "Lunge and Overpower gain +{v}% critical strike chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"blade_crit_ranks": 1}}},
		# Re-spec (was Momentum, a flat +3% damage dial): pairs with
		# Precision Strikes — one crits into debuffs, this damages into
		# them.
		{"id": "sm_momentum_sm", "name": "Overwhelm", "ranks": 3, "lane": "Blade", "tier": 2,
			"desc": "+{v}% damage for every debuff on the target.",
			"scale": {"step": 3},
			"payload": {"stat": {"overwhelm_ranks": 1}}},
		# Re-spec (was Deep Thrust, +5 Pommel damage; ranks 3 → 2 — the
		# loader refunds the over-cap rank): pays for pressing the button
		# the whole spec turns on.
		{"id": "sm_deep_thrust", "name": "Tempo", "ranks": 2, "lane": "Blade", "tier": 2,
			"desc": "Switching stance grants +{v}% damage for 1 turn.",
			"scale": {"step": 10},
			"payload": {"stat": {"tempo_ranks": 1}}},
		# --- Lane B: Poise — the defensive half, and ALL the parry
		# (Swordsmanship, Sword Mastery and Riposte move in from Duelist:
		# everything that answers being hit lives here). ---
		{"id": "sm_def_stance", "name": "Defensive Stance", "ranks": 3, "lane": "Poise", "tier": 0,
			"desc": "The Defensive stance blocks an additional {v}% damage taken.",
			"scale": {"step": 3},
			"payload": {"stat": {"seasoned_def_bonus": 0.03}}},
		# Moved from Duelist: parry belongs with the guard.
		{"id": "sm_sword_mastery", "name": "Sword Mastery", "ranks": 3, "lane": "Poise", "tier": 0,
			"desc": "+{v}% parry chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"parry_bonus": 0.03}}},
		# Re-spec (was Footwork, +3% armor; ranks 2 → 3): Defensive stance
		# comes to mean "hard to Break", not just "takes less damage".
		{"id": "sm_footwork", "name": "Bracing", "ranks": 3, "lane": "Poise", "tier": 0,
			"desc": "+{v} Constitution while in the Defensive stance.",
			"scale": {"step": 8},
			"payload": {"stat": {"bracing_ranks": 1}}},
		# Moved from Duelist.
		{"id": "sm_swordsmanship", "name": "Swordsmanship", "ranks": 3, "lane": "Poise", "tier": 1,
			"desc": "A perfect Pommel Strike grants +{v}% more parry chance.",
			"scale": {"step": 5},
			"payload": {"stat": {"pommel_parry_bonus": 0.05}}},
		{"id": "sm_high_guard", "name": "High Guard", "ranks": 1, "lane": "Poise", "tier": 1,
			"desc": "Take 25% less damage for 1 turn after parrying an attack.",
			"payload": {"stat": {"high_guard": 1}}},
		# Moved from Duelist: the parry payoff sits behind the parry lane.
		{"id": "sm_riposte", "name": "Riposte", "ranks": 1, "lane": "Poise", "tier": 2,
			"desc": "Counter Attack: immediately answer every parry with a Strike.",
			"payload": {"stat": {"counter_attacks": 1}}},
		# Re-spec (was Composure, flat -4% damage taken; ranks 2 → 1): the
		# node that makes a parry build viable — without it the whole
		# cluster is dead weight against archers and casters.
		{"id": "sm_composure", "name": "Deflection", "ranks": 1, "lane": "Poise", "tier": 2,
			"desc": "The Swordmaster's parry works against RANGED attacks too — arrows and spells alike.",
			"payload": {"stat": {"deflection": 1}}},
		# --- Lane C: Breaker (was Duelist) — fill their meter, then live
		# in the window. This lane did not exist before. ---
		# Re-spec (was Flourish, -5 Sweeping Strikes cost; ranks 2 → 3).
		{"id": "sm_flourish", "name": "Pressure Point", "ranks": 3, "lane": "Breaker", "tier": 0,
			"desc": "Pommel Strike deals +{v} more Break damage.",
			"scale": {"step": 8},
			"payload": {"stat": {"pressure_point_ranks": 1}}},
		# Re-spec (was Blade Dance, +2% parry — parry's home is Poise now).
		{"id": "sm_blade_dance", "name": "Sunder Guard", "ranks": 3, "lane": "Breaker", "tier": 0,
			"desc": "Shatterpoint deals +{v} more Break damage.",
			"scale": {"step": 8},
			"payload": {"stat": {"sunder_guard_ranks": 1}}},
		# Moved from Poise: debuff-fed armor is pressure bookkeeping.
		{"id": "sm_dominant", "name": "Dominant Presence", "ranks": 3, "lane": "Breaker", "tier": 1,
			"desc": "Armor value is increased by {v}% for every debuff the Swordmaster applies this battle.",
			"scale": {"step": 5},
			"payload": {"stat": {"dominant_ranks": 1}}},
		# Moved from Duelist.
		{"id": "sm_opportunist", "name": "Opportunist", "ranks": 1, "lane": "Breaker", "tier": 1,
			"desc": "When an enemy attack misses the Swordmaster, he counter attacks with Overpower (free).",
			"payload": {"stat": {"opportunist": 1}}},
		# Re-spec (was Perfect Form, a Swordsmanship duplicate): closes the
		# loop — the Break refunds Rage toward the Overpower you want to
		# spend inside the window you just opened.
		{"id": "sm_perfect_form", "name": "No Quarter", "ranks": 2, "lane": "Breaker", "tier": 1,
			"desc": "Breaking an enemy grants the Swordmaster {v} Rage.",
			"scale": {"step": 15},
			"payload": {"stat": {"no_quarter_ranks": 1}}},
		# Re-spec (was +6 Overpower damage). Exclusive fork with Off
		# Balance: pile everything into Overpower, or spread it wide.
		{"id": "sm_punish", "name": "Punishment", "ranks": 3, "lane": "Breaker", "tier": 2,
			"exclusive_with": "sm_guarded",
			"desc": "Overpower deals +{v}% damage against Broken targets.",
			"scale": {"step": 15},
			"payload": {"stat": {"punishment_ranks": 1}}},
		# Re-spec (was Guarded Frame, +5% max health; ranks 2 → 3): the
		# broad half of the fork.
		{"id": "sm_guarded", "name": "Off Balance", "ranks": 3, "lane": "Breaker", "tier": 2,
			"exclusive_with": "sm_punish",
			"desc": "All the Swordmaster's damage is increased by {v}% against Broken targets.",
			"scale": {"step": 5},
			"payload": {"stat": {"off_balance_ranks": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		{"id": "sm_execute", "name": "Execute", "ranks": 1, "lane": "Blade", "tier": 2,
			"capstone": true,
			"desc": "New ability: Execute — 55 damage / 50 BD; usable against targets below 20% health or Broken; a perfect guarantees a crit (30 Rage, 2.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Execute", "cost": 30,
				"damage": 55, "pressure": 50, "delay": 2.0, "anim": "attack03",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "Guaranteed critical strike",
				"description": "End them. Only usable against targets\nbelow 20% health — or Broken ones."}}},
		# Re-spec (was +5% parry / -5% damage taken): the Defensive stance
		# becomes a genuine wall against melee — and every parry a stun.
		{"id": "sm_untouchable", "name": "Untouchable", "ranks": 1, "lane": "Poise", "tier": 2,
			"capstone": true,
			"desc": "While in the Defensive stance, parried attacks deal NO damage instead of 25%, and every parry is answered with a free Pommel Strike.",
			"payload": {"stat": {"untouchable": 1}}},
		# Re-spec (was En Garde, +4% crit / +4% parry): the lane's thesis
		# as a win condition — they never get their guard back.
		{"id": "sm_en_garde", "name": "Guard Breaker", "ranks": 1, "lane": "Breaker", "tier": 2,
			"capstone": true,
			"desc": "When a Broken enemy recovers, its Break meter refills to 50 instead of resetting to 0.",
			"payload": {"stat": {"guard_breaker": 1}}},
	],
	"warden": [
		# Purpose-designed lanes (Batch H, 07-30) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). Every id
		# survives and re-specs in place, so saved ranks migrate (no new
		# rank cap is below its old one — nobody gets a refund). Half the
		# old tree was damage dials on a 75-Attack tank, so the offensive
		# payloads convert into currencies he actually spends: mitigation,
		# Break pressure, threat, and party protection.
		# --- Lane A: Plate — mitigation and the block payoffs.
		# Everything that answers being hit. ---
		{"id": "wd_unkillable", "name": "Unkillable", "ranks": 3, "lane": "Plate", "tier": 0,
			"node_gated": true,
			"desc": "Every time you Block an attack, heal for {v}% of maximum health.",
			"scale": {"step": 2},
			"payload": {"stat": {"unkillable_ranks": 1}}},
		{"id": "wd_toughness", "name": "Toughness", "ranks": 3, "lane": "Plate", "tier": 0,
			"desc": "Constitution is increased by {v}% of maximum HP.",
			"scale": {"step": 5},
			"payload": {"stat": {"toughness_ranks": 1}}},
		{"id": "wd_endurance", "name": "Endurance", "ranks": 3, "lane": "Plate", "tier": 0,
			"desc": "+{v}% armor for every turn the Warden is not healed by an external source (resets when healed).",
			"scale": {"step": 1},
			"payload": {"stat": {"endurance_ranks": 1}}},
		{"id": "wd_tenacity", "name": "Tenacity", "ranks": 1, "lane": "Plate", "tier": 1,
			"desc": "Every attack Blocked by Heavy Plating increases maximum health by 5 for the rest of the battle.",
			"payload": {"stat": {"tenacity": 1}}},
		{"id": "wd_shieldwall", "name": "Shield Mastery", "ranks": 2, "lane": "Plate", "tier": 1,
			"desc": "Shieldwall Blocks {v} more attack(s) (the perfect cast included).",
			"scale": {"step": 1},
			"payload": {"stat": {"shield_mastery_ranks": 1}}},
		# Re-spec (was Layered Plating, a flat armor dial; same id, so saved
		# ranks carry): the lane's signature — tightens the cadence of the
		# Batch G pity ramp, so blocks arrive every second hit instead of
		# every third and every on-Block talent fires more often.
		{"id": "wd_plating", "name": "Plate Discipline", "ranks": 3, "lane": "Plate", "tier": 1,
			"desc": "Heavy Plating's climbing Block bonus grows +{v}% faster per unblocked hit (8% becomes 11/14/17%).",
			"scale": {"step": 3},
			"payload": {"stat": {"plate_discipline_ranks": 1}}},
		# Re-spec (was Immovable, a flat damage-taken dial — that NAME moved
		# to the Plate capstone): a Broken unit cannot Block at all, so
		# getting Broken switches his identity off. Blocking holds that off.
		{"id": "wd_immovable", "name": "Battered Not Broken", "ranks": 3, "lane": "Plate", "tier": 2,
			"desc": "Blocking an attack removes {v} Break from the Warden's own meter.",
			"scale": {"step": 8},
			"payload": {"stat": {"battered_ranks": 1}}},
		# --- Lane B: Threat — he wants to be hit. This lane is what
		# happens to whoever obliges. ---
		{"id": "wd_ricochet", "name": "Richocet", "ranks": 3, "lane": "Threat", "tier": 0,
			"desc": "Blocking an attack has a {v}% chance to Stun the attacker.",
			"scale": {"step": 5},
			"payload": {"stat": {"ricochet_ranks": 1}}},
		# Re-spec (was Taunt Master, -1 Mocking cooldown; ranks 1 → 2): the
		# taunt engine widens — more of the room swings at the wall.
		{"id": "wd_taunt_master", "name": "Provoke", "ranks": 2, "lane": "Threat", "tier": 0,
			"desc": "Mocking Blow taunts {v} additional foe(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"provoke_ranks": 1}}},
		# Re-spec IN MEANING (same id, same name, same idea — adversity
		# makes him stronger — converted into the currency a tank banks):
		# was +5%/rank DAMAGE per debuff, ~14 damage at full stack on a
		# 75-Attack character.
		{"id": "wd_iron_will", "name": "Iron Will", "ranks": 3, "lane": "Threat", "tier": 1,
			"desc": "The Warden takes {v}% less damage for every debuff currently on him.",
			"scale": {"step": 4},
			"payload": {"stat": {"iron_will_ranks": 1}}},
		{"id": "wd_sundering", "name": "Sundering", "ranks": 3, "lane": "Threat", "tier": 1,
			"desc": "Crushing Blow deals {v}% of its Break damage to enemies Adjacent to the target (dead neighbors block the splash on their side).",
			"scale": {"step": 25},
			"payload": {"stat": {"sundering_ranks": 1}}},
		# Re-spec (was Spiked Bulwark, a Richocet deepener). Exclusive fork
		# with Bruising Guard: the punishment you soak becomes damage, or
		# becomes Break pressure.
		{"id": "wd_spiked", "name": "Spite", "ranks": 3, "lane": "Threat", "tier": 1,
			"exclusive_with": "wd_shatter_guard",
			"desc": "Attackers that damage the Warden take {v}% of that damage back.",
			"scale": {"step": 8},
			"payload": {"stat": {"spite_ranks": 1}}},
		# Re-spec (was Shattering Blow, +5 Crushing damage): the more
		# interesting half of the fork — on a character who blocks
		# constantly and is attacked more than anyone, this quietly makes
		# him a Break engine for the whole party.
		{"id": "wd_shatter_guard", "name": "Bruising Guard", "ranks": 3, "lane": "Threat", "tier": 1,
			"exclusive_with": "wd_spiked",
			"desc": "Blocking an attack deals {v} Break damage to the attacker.",
			"scale": {"step": 10},
			"payload": {"stat": {"bruising_ranks": 1}}},
		# Re-spec (same name, was a flat +3% damage dial): the damage he
		# does keep is aimed at whoever he's holding.
		{"id": "wd_grudge", "name": "Grudge", "ranks": 3, "lane": "Threat", "tier": 2,
			"desc": "+{v}% damage against enemies currently taunted by the Warden.",
			"scale": {"step": 6},
			"payload": {"stat": {"grudge_ranks": 1}}},
		# --- Lane C: Banner — the half that protects other people. ---
		{"id": "wd_tank_spank", "name": "Tank and Spank", "ranks": 3, "lane": "Banner", "tier": 0,
			"desc": "Mocking Blow has a {v}% chance to Empower a random ally (2 turns).",
			"scale": {"step": 15},
			"payload": {"stat": {"tank_spank_ranks": 1}}},
		{"id": "wd_rally", "name": "Rally", "ranks": 1, "lane": "Banner", "tier": 0,
			"desc": "Every attack Blocked by Heavy Plating grants the party +15% healing received for 2 turns.",
			"payload": {"stat": {"rally": 1}}},
		# Re-spec (was Stomp Drill, -5 War Stomp cost): deepens the refuel —
		# the real cargo on a 75-Attack tank's aoe.
		{"id": "wd_stomp_drill", "name": "Rallying Stomp", "ranks": 3, "lane": "Banner", "tier": 0,
			"desc": "War Stomp restores {v}% more resource to allies.",
			"scale": {"step": 5},
			"payload": {"stat": {"rallying_stomp_ranks": 1}}},
		{"id": "wd_elem_weak", "name": "Elemental Weakness", "ranks": 3, "lane": "Banner", "tier": 1,
			"desc": "Crushing Blow also reduces all elemental resistances of the target by {v}% (3 turns).",
			"scale": {"step": 5},
			"payload": {"stat": {"elem_weak_ranks": 1}}},
		# Re-spec (was Bannerman, a flat max-HP dial): the Batch G tank verb
		# deepens — the cover he throws gets thicker.
		{"id": "wd_bannerman", "name": "Bulwark Line", "ranks": 2, "lane": "Banner", "tier": 1,
			"desc": "Interpose grants each ally {v} additional Shieldwall charge(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"bulwark_line_ranks": 1}}},
		# Re-spec (was Fortress, a flat max-HP dial): conditional on the
		# Warden being healthy — the party's mitigation depends on keeping
		# him standing, so healing him is protecting everyone.
		{"id": "wd_fortress", "name": "Shared Vigil", "ranks": 3, "lane": "Banner", "tier": 1,
			"desc": "Allies take {v}% less damage while the Warden is above 50% health.",
			"scale": {"step": 3},
			"payload": {"stat": {"shared_vigil_ranks": 1}}},
		# Re-spec (was Veteran's Will, an Iron Will deepener): the lane's
		# thesis in one node — he eats what would have killed you.
		{"id": "wd_veteran", "name": "Steadfast", "ranks": 3, "lane": "Banner", "tier": 2,
			"desc": "When damage would drop an ally below 20% health, the Warden absorbs {v}% of it instead.",
			"scale": {"step": 15},
			"payload": {"stat": {"steadfast_ranks": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		# Re-spec (was The Mountain, a stat pile; the name comes from the
		# old wd_immovable filler): being Broken is the one thing that
		# turns a block build off — this removes it. Precedent: the
		# Devout's Bulwark of Fortitude.
		{"id": "wd_mountain", "name": "Immovable", "ranks": 1, "lane": "Plate", "tier": 2,
			"capstone": true,
			"desc": "The Warden cannot be Broken, and his Block chance is increased by 20%.",
			"payload": {"stat": {"immovable": 1, "block_chance": 0.20}}},
		# Re-spec (was Avenger, a Richocet/Sundering stat pile). Once per
		# TURN, not per block — at his block rate against a full field,
		# per-block would be absurd.
		{"id": "wd_avenger", "name": "Vengeful Guardian", "ranks": 1, "lane": "Threat", "tier": 2,
			"capstone": true,
			"desc": "The first attack the Warden Blocks each turn is answered with a free Crushing Blow.",
			"payload": {"stat": {"vengeful_guardian": 1}}},
		{"id": "wd_hold_line", "name": "Hold the Line", "ranks": 1, "lane": "Banner", "tier": 2,
			"capstone": true,
			"desc": "New ability: Hold the Line — the party takes 50% less Break damage for 2 turns and cannot die for a turn (30 Rage, 3.5 int, 6cd).",
			"payload": {"new_ability": {"display_name": "Hold the Line", "cost": 30,
				"special": "hold_the_line", "delay": 3.5, "anim": "attack03",
				"cooldown": 6,
				"perfect_id": "", "perfect_text": "Refunds 5 Rage",
				"description": "Embolden the party: 50% less Break\ndamage for 2 turns, and no one can die\nfor a turn."}}},
	],
	"pyromancer": [
		# Purpose-designed lanes (Batch N, 07-31) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). Every id
		# survives and re-specs in place, so saved ranks migrate. The old
		# conversion named its lanes after kit pieces; these are named for
		# the burn loop itself: KINDLING builds the fire, INFERNO profits
		# while it burns, DETONATION cashes it in — on one target, hard.
		# --- Lane A: Kindling — spreading the fire. ---
		{"id": "py_accelerant", "name": "Accelerant", "ranks": 3, "lane": "Kindling", "tier": 0,
			"node_gated": true,
			"desc": "Your Burn ticks deal +{v}% of Attack (on top of the base 6%).",
			"scale": {"step": 1},
			"payload": {"stat": {"accelerant_ranks": 1}}},
		{"id": "py_explosive", "name": "Explosive Force", "ranks": 3, "lane": "Kindling", "tier": 0,
			"desc": "Critical hits with fire abilities extend the target's Burn by {v} turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"explosive_ranks": 1}}},
		{"id": "py_invigorating", "name": "Invigorating Ashes", "ranks": 3, "lane": "Kindling", "tier": 1,
			"desc": "Every Burn tick has a {v}% chance to restore 2% of the Pyromancer's max Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"invigorating_ranks": 1}}},
		{"id": "py_flame_shield", "name": "Flame Shield", "ranks": 1, "lane": "Kindling", "tier": 1,
			"desc": "New ability: Flame Shield — take 50% less damage for 2 turns and attackers are set Burning for 3 turns (15 Mana, 2.0 int, 2cd).",
			"payload": {"new_ability": {"display_name": "Flame Shield", "cost": 15,
				"special": "flame_shield", "delay": 2.0, "anim": "attack03", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Also triggers a Burn tick on every burning enemy",
				"description": "A barrier of living flame: take 50%\nless damage for 2 turns, and whoever\nstrikes the Pyromancer is set Burning\n(3 turns)."}}},
		# Conflagration: the build button builds harder.
		{"id": "py_arson", "name": "Conflagration", "ranks": 2, "lane": "Kindling", "tier": 1,
			"desc": "Flamewave applies +{v} turn(s) of Burn (fresh fires and extensions alike).",
			"scale": {"step": 1},
			"payload": {"stat": {"conflagration_ranks": 1}}},
		# Cinder Trail: the free basic becomes a spreader — it matters most
		# in the opening turns before Flamewave is up.
		{"id": "py_kindling", "name": "Cinder Trail", "ranks": 2, "lane": "Kindling", "tier": 2,
			"desc": "Fireball also applies {v} turn(s) of Burn to one random other enemy.",
			"scale": {"step": 1},
			"payload": {"stat": {"cinder_trail_ranks": 1}}},
		{"id": "py_spreading", "name": "Ember Wind", "ranks": 1, "lane": "Kindling", "tier": 2,
			"desc": "When an enemy dies Burning, its remaining Burn transfers to a random living enemy.",
			"payload": {"stat": {"ember_wind": 1}}},
		# --- Lane B: Inferno — profiting while it burns. ---
		{"id": "py_pyromaniac", "name": "Pyromaniac", "ranks": 3, "lane": "Inferno", "tier": 0,
			"desc": "Inferno Master grants {v}% damage per burning enemy (up from the base 5%).",
			"scale": {"base": 5, "step": 1},
			"payload": {"stat": {"pyromaniac_ranks": 1}}},
		{"id": "py_molten", "name": "Molten Core", "ranks": 3, "lane": "Inferno", "tier": 0,
			"desc": "Take {v}% less damage from burning enemies.",
			"scale": {"step": 2},
			"payload": {"stat": {"molten_ranks": 1}}},
		{"id": "py_melt", "name": "Melt Armor", "ranks": 3, "lane": "Inferno", "tier": 1,
			"desc": "Every Burn tick melts the victim's armor by {v}% for the rest of the battle.",
			"scale": {"step": 1},
			"payload": {"stat": {"melt_ranks": 1}}},
		# The exclusive pair: the same burning field read two ways — as a
		# damage multiplier, or as a smother on the enemy's output.
		{"id": "py_firebrand", "name": "Heat Haze", "ranks": 3, "lane": "Inferno", "tier": 1,
			"exclusive_with": "py_cauterize",
			"desc": "Inferno Master counts {v} additional burning enemy(ies) before capping (5 -> 8).",
			"scale": {"step": 1},
			"payload": {"stat": {"heat_haze_ranks": 1}}},
		{"id": "py_cauterize", "name": "Scorched Earth", "ranks": 3, "lane": "Inferno", "tier": 1,
			"exclusive_with": "py_firebrand",
			"desc": "Burning enemies deal {v}% less damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"scorched_ranks": 1}}},
		{"id": "py_ashes", "name": "Ashes of Al'ar", "ranks": 3, "lane": "Inferno", "tier": 2,
			"desc": "Upon death: {v}% chance to revive with 25% health (once per battle).",
			"scale": {"step": 11},
			"payload": {"stat": {"ashes_ranks": 1}}},
		{"id": "py_undying_flame", "name": "Living Flame", "ranks": 2, "lane": "Inferno", "tier": 2,
			"desc": "While 3 or more enemies burn, regain {v}% of max Mana each turn.",
			"scale": {"step": 3},
			"payload": {"stat": {"living_flame_ranks": 1}}},
		# --- Lane C: Detonation — cashing it in. Every node is a different
		# answer to "how do I get more out of one Detonation": chain it,
		# repeat it, reset it, or guarantee the crit. ---
		{"id": "py_supernova", "name": "Super Nova", "ranks": 3, "lane": "Detonation", "tier": 0,
			"desc": "Detonation gains +{v}% critical strike chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"supernova_ranks": 1}}},
		{"id": "py_implosion", "name": "Implosion", "ranks": 3, "lane": "Detonation", "tier": 0,
			"desc": "Detonation has a {v}% chance to strike twice.",
			"scale": {"step": 3},
			"payload": {"stat": {"implosion_ranks": 1}}},
		{"id": "py_seeding", "name": "Seeding Embers", "ranks": 3, "lane": "Detonation", "tier": 1,
			"desc": "When an enemy dies while Burning, gain {v}% damage per Burn turn it had left, for your next turn.",
			"scale": {"step": 1},
			"payload": {"stat": {"seeding_ranks": 1}}},
		# Chain Reaction: the lane's only field-wide effect, and it costs
		# three ranks in a tier-1 slot to get there.
		{"id": "py_warm_glow", "name": "Chain Reaction", "ranks": 3, "lane": "Detonation", "tier": 1,
			"desc": "Detonation splashes {v}% of its damage to every other burning enemy.",
			"scale": {"step": 20},
			"payload": {"stat": {"chain_reaction_ranks": 1}}},
		{"id": "py_rekindle", "name": "Fuse", "ranks": 2, "lane": "Detonation", "tier": 1,
			"desc": "Detonation has a {v}% chance to reset its own cooldown.",
			"scale": {"step": 15},
			"payload": {"stat": {"fuse_ranks": 1}}},
		{"id": "py_shockwave", "name": "Blast Radius", "ranks": 3, "lane": "Detonation", "tier": 2,
			"desc": "Detonation consumes {v}% more of the target's remaining Burn damage.",
			"scale": {"step": 25},
			"payload": {"stat": {"blast_radius_ranks": 1}}},
		# White Heat: the guaranteed crit, gated behind setup — you must
		# have GROWN the burn first. Stacks naturally with Super Nova,
		# which covers the targets that haven't been stacked that high.
		{"id": "py_focused", "name": "White Heat", "ranks": 2, "lane": "Detonation", "tier": 2,
			"desc": "Detonation always critically strikes a target with 5+ turns of Burn (4+ at rank 2).",
			"payload": {"stat": {"white_heat_ranks": 1}}},
		# --- Capstones (6 nodes deep in a lane; only ONE may be taken). ---
		{"id": "py_firestorm", "name": "Firestorm", "ranks": 1, "lane": "Kindling", "tier": 2,
			"capstone": true,
			"desc": "New ability: Firestorm — rain fire on 6-8 random enemies for 12% of Attack each, applying Burn (30 Mana, 3.5 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Firestorm", "cost": 30,
				"dmg_type": "fire", "damage": 12, "pressure": 8, "random_hits": 6,
				"perfect_extra_hit": false, "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"applies_status": {"id": "burn", "turns": 2},
				"perfect_id": "", "perfect_text": "Hits 7-9 times instead",
				"description": "The sky ignites: 6-8 bolts rake random\nenemies for 12% of Attack, each one\nsetting its victim Burning (2 turns\nper bolt — repeats stack)."}}},
		{"id": "py_rebirth", "name": "Avatar of Flame", "ranks": 1, "lane": "Inferno", "tier": 2,
			"capstone": true,
			"desc": "Inferno Master has no cap — every burning enemy grants its full bonus — and the Pyromancer's fire damage ignores enemy fire resistance.",
			"payload": {"stat": {"avatar_flame": 1}}},
		# Cataclysm: the "detonate them all" fantasy as something earned —
		# and it still rewards a good first target, since the chain walks
		# down from there.
		{"id": "py_hellfire", "name": "Cataclysm", "ranks": 1, "lane": "Detonation", "tier": 2,
			"capstone": true,
			"desc": "After Detonation resolves, it fires again at the burning enemy with the most Burn remaining for 60% of its damage, chaining up to 3 additional times (each 60% of the one before).",
			"payload": {"stat": {"cataclysm": 1}}},
	],
	"cryomancer": [
		# Purpose-designed lanes (Batch O, 07-31) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). Every id
		# survives and re-specs in place, so saved ranks migrate. With
		# Permafrost v2 the stacks stop expiring, and the lanes read clean:
		# DEEP FREEZE reaches and holds Frozen, SHATTERPOINT is the burst
		# payoff, WINTER is the field aura that profits from every stack.
		# --- Lane A: Deep Freeze — reaching and holding Frozen. ---
		{"id": "cr_frostbite", "name": "Brittle Ice", "ranks": 3, "lane": "Deep Freeze", "tier": 0,
			"node_gated": true,
			"desc": "Frozen enemies are {v}% more likely to be struck by a critical hit (party-wide).",
			"scale": {"step": 2},
			"payload": {"stat": {"frostbite_ranks": 1}}},
		{"id": "cr_frigid", "name": "Frigid Grip", "ranks": 3, "lane": "Deep Freeze", "tier": 0,
			"desc": "Every stack of Chilled slows {v}% harder.",
			"scale": {"step": 3},
			"payload": {"stat": {"frigid_ranks": 1}}},
		{"id": "cr_whiteout", "name": "Whiteout", "ranks": 3, "lane": "Deep Freeze", "tier": 1,
			"desc": "Enemies hit by Blizzard have a {v}% chance to become Dazed (2 turns).",
			"scale": {"step": 15},
			"payload": {"stat": {"whiteout_ranks": 1}}},
		# Re-spec (was a Rime rider, which sat in the wrong lane): the freeze
		# opens a window, and his next strike takes it.
		{"id": "cr_freezing", "name": "Freezing Advance", "ranks": 3, "lane": "Deep Freeze", "tier": 1,
			"desc": "When an enemy Freezes, the Cryomancer's next attack against it deals +{v}% damage.",
			"scale": {"step": 10},
			"payload": {"stat": {"freezing_ranks": 1}}},
		# Re-spec (was a flat Frostbolt damage dial). The exclusive pair:
		# depth or breadth — hold ONE enemy under far longer, or turn every
		# freeze into a field-wide chill that cascades toward the next one.
		{"id": "cr_cold_snap", "name": "Cold Snap", "ranks": 2, "lane": "Deep Freeze", "tier": 1,
			"exclusive_with": "cr_bitter",
			"desc": "Frozen lasts {v} additional turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"cold_snap_ranks": 1}}},
		# Re-spec (was a flat +damage dial, exclusive with Numbing Veil).
		{"id": "cr_bitter", "name": "Bitter Cold", "ranks": 3, "lane": "Deep Freeze", "tier": 1,
			"exclusive_with": "cr_cold_snap",
			"desc": "Freezing an enemy applies {v} stack(s) of Chilled to every other enemy.",
			"scale": {"step": 1},
			"payload": {"stat": {"bitter_cold_ranks": 1}}},
		# Re-spec (was a Blizzard Mana discount): the engine pays for itself.
		{"id": "cr_glacial", "name": "Glacial Economy", "ranks": 2, "lane": "Deep Freeze", "tier": 2,
			"desc": "Freezing an enemy restores {v}% of the Cryomancer's maximum Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"glacial_ranks": 1}}},
		# --- Lane B: Shatterpoint — the burst payoff. ---
		{"id": "cr_piercing", "name": "Piercing Ice", "ranks": 3, "lane": "Shatterpoint", "tier": 0,
			"desc": "Ice Lance gains {v}% critical strike damage.",
			"scale": {"step": 10},
			"payload": {"stat": {"piercing_ice_ranks": 1}}},
		{"id": "cr_emp_frostbolt", "name": "Empowered Frostbolt", "ranks": 3, "lane": "Shatterpoint", "tier": 0,
			"desc": "Frostbolt deals an extra {v}% of Attack.",
			"scale": {"step": 2},
			"payload": {"stat": {"emp_frostbolt_ranks": 1}}},
		{"id": "cr_icy_veins", "name": "Icy Veins", "ranks": 3, "lane": "Shatterpoint", "tier": 1,
			"desc": "Killing an enemy with Ice Lance empowers your next Ice Lance by {v}%.",
			"scale": {"step": 15},
			"payload": {"stat": {"icy_veins_ranks": 1}}},
		# Re-spec (was an extra RANDOM target — a talent that fought the
		# spec's own win condition): now the fourth-stack node, a 60% shot
		# at rank 3 to Freeze straight out of a single Razor Ice.
		{"id": "cr_splinter", "name": "Splintering Shards", "ranks": 3, "lane": "Shatterpoint", "tier": 1,
			"desc": "Razor Ice has a {v}% chance to strike a fourth time.",
			"scale": {"step": 20},
			"payload": {"stat": {"splinter_ranks": 1}}},
		{"id": "cr_lance_focus", "name": "Lance Focus", "ranks": 2, "lane": "Shatterpoint", "tier": 1,
			"desc": "Ice Lance costs {v} less Mana.",
			"scale": {"step": 5},
			"payload": {"ability": "Ice Lance", "add": {"cost": -5}}},
		# Re-spec (was a flat crit dial): deepens the Lance's new per-stack
		# scaling instead.
		{"id": "cr_crystal", "name": "Crystal Edge", "ranks": 3, "lane": "Shatterpoint", "tier": 2,
			"desc": "Ice Lance deals an extra {v}% of Attack per Chilled stack (on top of the base 10%).",
			"scale": {"step": 5},
			"payload": {"stat": {"crystal_edge_ranks": 1}}},
		# Re-spec (was a Razor Ice damage dial): the payoff hit feeds the
		# next build.
		{"id": "cr_razor_hone", "name": "Honed Shards", "ranks": 2, "lane": "Shatterpoint", "tier": 2,
			"desc": "Critical hits with Ice Lance apply {v} stack(s) of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"honed_shards_ranks": 1}}},
		# --- Lane C: Winter — the field aura. ---
		{"id": "cr_hungering", "name": "Hungering Cold", "ranks": 3, "lane": "Winter", "tier": 0,
			"desc": "Chilled enemies deal {v}% less damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hungering_ranks": 1}}},
		{"id": "cr_hypothermia", "name": "Hypothermia", "ranks": 3, "lane": "Winter", "tier": 0,
			"desc": "Enemies take {v}% more damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hypothermia_ranks": 1}}},
		{"id": "cr_rime", "name": "Rime", "ranks": 1, "lane": "Winter", "tier": 1,
			"desc": "New ability: Rime — inflicts Frostbite (-50% healing received, 2 turns); for 3 turns, every stack of Chilled the target gains also chills one other random enemy (25 Mana, 3.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Rime", "cost": 25,
				"special": "rime", "delay": 3.0, "anim": "attack02", "cooldown": 3,
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Hoarfrost takes root: Frostbites the\ntarget (-50% healing received, 2 turns);\nfor 3 turns, every stack of Chilled\nthis enemy gains also chills one\nother random enemy."}}},
		# Re-spec (was a flat armor dial): the aura lane shields its caster.
		{"id": "cr_frost_ward", "name": "Frost Ward", "ranks": 3, "lane": "Winter", "tier": 1,
			"desc": "The Cryomancer takes {v}% less damage from Chilled enemies.",
			"scale": {"step": 4},
			"payload": {"stat": {"frost_ward_ranks": 1}}},
		# Re-spec (was a flat max-health dial): feeds the ability instead.
		{"id": "cr_icy_resolve", "name": "Icy Resolve", "ranks": 2, "lane": "Winter", "tier": 1,
			"desc": "Rime lasts {v} additional turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"icy_resolve_ranks": 1}}},
		# Re-spec (was a Frigid Grip dial): with permanent stacks the field
		# drifts toward Frozen while he spends his turns elsewhere.
		{"id": "cr_grasp", "name": "Winter's Grasp", "ranks": 3, "lane": "Winter", "tier": 2,
			"desc": "At the start of each of the Cryomancer's turns, {v} random Chilled enemy(ies) gain a stack.",
			"scale": {"step": 1},
			"payload": {"stat": {"grasp_ranks": 1}}},
		# Re-spec (was a flat damage-taken dial): the whole warband fumbles.
		{"id": "cr_numbing", "name": "Numbing Veil", "ranks": 3, "lane": "Winter", "tier": 2,
			"desc": "Chilled enemies have a {v}% chance to miss.",
			"scale": {"step": 5},
			"payload": {"stat": {"numbing_ranks": 1}}},
		# --- Capstones (6 nodes deep in a lane; only ONE may be taken). ---
		{"id": "cr_shatter", "name": "Shatter", "ranks": 1, "lane": "Shatterpoint", "tier": 2,
			"capstone": true,
			"desc": "New ability: Shatter — deal 10% of Attack × their Chilled stacks to EVERY Chilled enemy (30 Mana, 4.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Shatter", "cost": 30,
				"dmg_type": "frost", "damage": 10, "pressure": 10, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Cooldown becomes 4 instead",
				"description": "The cold detonates: every Chilled\nenemy takes 10% of Attack PER STACK\nof Chilled on it."}}},
		# Absolute Zero: total lockdown on a chosen target — and every
		# per-stack aura stays permanently maxed against it.
		{"id": "cr_absolute", "name": "Absolute Zero", "ranks": 1, "lane": "Deep Freeze", "tier": 2,
			"capstone": true,
			"desc": "Freezing an enemy no longer reduces its Chilled stacks — they hold at 4, and the target refreezes the moment its freeze ends.",
			"payload": {"stat": {"absolute_zero": 1}}},
		# Eternal Winter: inevitability — with permanent stacks the entire
		# field freezes whether he acts or not.
		{"id": "cr_eternal", "name": "Eternal Winter", "ranks": 1, "lane": "Winter", "tier": 2,
			"capstone": true,
			"desc": "EVERY enemy gains 1 stack of Chilled at the start of each of the Cryomancer's turns.",
			"payload": {"stat": {"eternal_winter": 1}}},
	],
	"holy": [
		# Purpose-designed lanes (Batch J, 07-30) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). Every id
		# survives and re-specs in place, so saved ranks migrate (only
		# hl_serenity's cap shrank 2 → 1 — the loader refunds the extra
		# rank). Six of the old 24 nodes were "deepen another node" and two
		# of the three capstones were +2 ranks of something already owned;
		# worse, NOTHING touched Empower — the most interesting decision in
		# the kit. The Mercy lane now runs the resource economy end to end:
		# earning stacks, holding them, spending them, and Empower itself.
		# --- Lane A: Radiance — throughput: bigger heals, cheaper heals,
		# less waste. ---
		{"id": "hl_triage", "name": "Triage", "ranks": 3, "lane": "Radiance", "tier": 0,
			"node_gated": true,
			"desc": "Instant heals can CRIT (x1.5, using your critical strike chance), and all your healing is increased by {v}%.",
			"scale": {"step": 3},
			"payload": {"stat": {"triage_ranks": 1}}},
		{"id": "hl_soothe", "name": "Soothing Touch", "ranks": 2, "lane": "Radiance", "tier": 0,
			"desc": "Renewal costs {v} less Mana.", "scale": {"step": 5},
			"payload": {"ability": "Renewal", "add": {"cost": -5}}},
		{"id": "hl_on_mend", "name": "On the Mend", "ranks": 3, "lane": "Radiance", "tier": 1,
			"desc": "Renewal ticks have a {v}% chance to dispel one harmful effect from the bearer.",
			"scale": {"step": 5},
			"payload": {"stat": {"on_mend_ranks": 1}}},
		{"id": "hl_capacitor", "name": "Holy Capacitor", "ranks": 3, "lane": "Radiance", "tier": 1,
			"desc": "{v}% of your overhealing is stored and released by your next Heal.",
			"scale": {"step": 5},
			"payload": {"stat": {"capacitor_ranks": 1}}},
		{"id": "hl_swift", "name": "Swift Mending", "ranks": 1, "lane": "Radiance", "tier": 2,
			"desc": "Heal's cooldown is reduced by 1 turn.",
			"payload": {"ability": "Heal", "add": {"cooldown": -1}}},
		# Re-spec (was Brilliance, a Triage deepener; same id, so saved
		# ranks carry). One half of the wasted-healing fork: crit
		# investment pays out sideways — it needs Triage to fire at all.
		{"id": "hl_brilliance", "name": "Radiant Cascade", "ranks": 2, "lane": "Radiance", "tier": 2,
			"exclusive_with": "hl_overflow",
			"desc": "A CRITICAL heal also splashes {v}% of its value onto the lowest-health other ally.",
			"scale": {"step": 25},
			"payload": {"stat": {"cascade_ranks": 1}}},
		# Re-spec (was a Holy Capacitor deepener): the other half of the
		# fork — raw output spills over instead of banking. Pairs with
		# Capacitor, which drinks from the same overheal.
		{"id": "hl_overflow", "name": "Overflow", "ranks": 2, "lane": "Radiance", "tier": 2,
			"exclusive_with": "hl_brilliance",
			"desc": "{v}% of any overhealing spills onto the lowest-health other ally immediately.",
			"scale": {"step": 15},
			"payload": {"stat": {"overflow_ranks": 1}}},
		# --- Lane B: Mercy — the resource economy: earning stacks,
		# spending stacks, and Empower. The lane that didn't exist. ---
		{"id": "hl_heavenly", "name": "Heavenly Aura", "ranks": 3, "lane": "Mercy", "tier": 0,
			"desc": "Each stack of Mercy grants {v}% healing done (up from the base 5%).",
			"scale": {"base": 5, "step": 5},
			"payload": {"stat": {"heavenly_ranks": 1}}},
		{"id": "hl_holy_light", "name": "Holy Light", "ranks": 3, "lane": "Mercy", "tier": 0,
			"desc": "Perfect casts restore {v}% of your maximum Mana.",
			"scale": {"step": 1},
			"payload": {"stat": {"holy_light_ranks": 1}}},
		# Re-spec (was +4% damage on a 50-Attack healer, and half of a
		# cross-lane exclusive that read as a bug): Mercy is purely
		# reactive — she started every fight at zero, Hymn uncastable on
		# turn one. Now she opens with a working kit.
		{"id": "hl_zealous", "name": "Zealous Light", "ranks": 3, "lane": "Mercy", "tier": 0,
			"desc": "The Cleric begins each battle with {v} Mercy.",
			"scale": {"step": 1},
			"payload": {"stat": {"zealous_mercy": 1}}},
		{"id": "hl_sanctified", "name": "Sanctified", "ranks": 3, "lane": "Mercy", "tier": 1,
			"desc": "Spending Mercy has a {v}% chance to consume no stacks.",
			"scale": {"step": 10},
			"payload": {"stat": {"sanctified_ranks": 1}}},
		{"id": "hl_resurrection", "name": "Resurrection", "ranks": 1, "lane": "Mercy", "tier": 1,
			"desc": "New ability: Resurrection — spend 3 Mercy to return a fallen ally to life with 20% health and resource; Empower (+1 Mercy): full health and resource plus 5 turns of Renewal (4.0 int, 3cd).",
			"payload": {"grant_ability": "Resurrection"}},
		# Re-spec (was a Heavenly Aura deepener): the Empower support the
		# tree never had, and a rhythm rather than a discount — bank to
		# the threshold, then Empower freely until you drop below it.
		# Holding Mercy is already rewarded by the healing bonus, so this
		# deepens a decision that is genuinely live.
		{"id": "hl_ardor", "name": "Ardor", "ranks": 2, "lane": "Mercy", "tier": 1,
			"desc": "While the Cleric holds {v} or more Mercy, Empowering consumes no stack.",
			"scale": {"base": 5, "step": -1},
			"payload": {"stat": {"ardor_ranks": 1}}},
		# Re-spec (was an Inner Faith duplicate — both wrote max_hp_pct):
		# the lane's payoff. A bigger cap is more held bonus AND more
		# banked spenders at once.
		{"id": "hl_martyr", "name": "Martyr's Vigor", "ranks": 2, "lane": "Mercy", "tier": 2,
			"desc": "Mercy's maximum rises to {v}.",
			"scale": {"base": 5, "step": 1},
			"payload": {"stat": {"mercy_cap_bonus": 1}}},
		# --- Lane C: Sanctuary — the safety net: keeping people from
		# dying, rather than healing them after. ---
		{"id": "hl_guardian", "name": "Guardian Angel", "ranks": 3, "lane": "Sanctuary", "tier": 0,
			"desc": "Allies falling below {v}% health earn you a stack of Mercy (up from 50%).",
			"scale": {"base": 50, "step": 3},
			"payload": {"stat": {"guardian_ranks": 1}}},
		{"id": "hl_presence", "name": "Divine Presence", "ranks": 3, "lane": "Sanctuary", "tier": 0,
			"desc": "At the end of your turn, the lowest-health ally is healed for {v}% of their maximum health.",
			"scale": {"step": 1},
			"payload": {"stat": {"divine_presence_ranks": 1}}},
		{"id": "hl_last_hope", "name": "Last Hope", "ranks": 3, "lane": "Sanctuary", "tier": 1,
			"desc": "Allies under 25% of their max health receive {v}% more healing.",
			"scale": {"step": 5},
			"payload": {"stat": {"last_hope_ranks": 1}}},
		{"id": "hl_inner_faith", "name": "Inner Faith", "ranks": 3, "lane": "Sanctuary", "tier": 1,
			"desc": "Increases your maximum health by {v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# Re-spec (was +3% armor): Renewal becomes a protective tool as
		# well as a heal — and the Radiance lane gains a reason to splash.
		{"id": "hl_vestments", "name": "Blessed Vestments", "ranks": 2, "lane": "Sanctuary", "tier": 1,
			"desc": "Allies with Renewal on them take {v}% less damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"vestments_ranks": 1}}},
		# Re-spec (was a Divine Presence deepener): triage that happens
		# without spending a turn.
		{"id": "hl_beacon", "name": "Beacon", "ranks": 2, "lane": "Sanctuary", "tier": 2,
			"desc": "At the start of each of the Cleric's turns, every ally below 25% health heals {v}% of their maximum health.",
			"scale": {"step": 5},
			"payload": {"stat": {"beacon_ranks": 1}}},
		# Re-spec (was flat -4% damage taken, and the other half of the
		# cross-lane exclusive; ranks 2 → 1 — the loader refunds the
		# over-cap rank): the safety net's signature moment.
		{"id": "hl_serenity", "name": "Serenity", "ranks": 1, "lane": "Sanctuary", "tier": 2,
			"desc": "Once per battle, the first ally to take lethal damage survives at 1 HP instead.",
			"payload": {"stat": {"serenity": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		{"id": "hl_divine_plea", "name": "Divine Plea", "ranks": 1, "lane": "Radiance", "tier": 2,
			"capstone": true,
			"desc": "New ability: Divine Plea — spend 2 Mercy to FULLY heal an ally; Empower (+1 Mercy): also cleanse all debuffs and Consecrate them against new ones for 3 turns (3.0 int, 2cd).",
			"payload": {"grant_ability": "Divine Plea"}},
		# Re-spec (was +2 Heavenly Aura steps): Mercy turns from a
		# reactive trickle into an engine, and Empower goes unconditional
		# — the payoff for a lane built on the resource. Supersedes Ardor
		# rather than stacking with it (the free-Empower checks are
		# either/or, never a double refund).
		{"id": "hl_avatar", "name": "Avatar of Mercy", "ranks": 1, "lane": "Mercy", "tier": 2,
			"capstone": true,
			"desc": "The Cleric gains 1 Mercy at the start of each of her turns, and Empower costs no stack.",
			"payload": {"stat": {"avatar_of_mercy": 1}}},
		# Re-spec (was +2 Guardian Angel steps): every heal she grants a
		# single ally becomes a party heal — the fantasy the lane name
		# was always promising. (Hymn is already the whole party, so it
		# does not echo itself.)
		{"id": "hl_sanctum", "name": "Living Sanctum", "ranks": 1, "lane": "Sanctuary", "tier": 2,
			"capstone": true,
			"desc": "All the healing the Cleric grants a single ally — Heal, Renewal and its ticks, Divine Plea — also heals the whole party for 25% of its value.",
			"payload": {"stat": {"living_sanctum": 1}}},
	],
	"inquisitor": [
		# Devout (spec id is legacy) — purpose-designed lanes (Batch K,
		# 07-30), NODE-GATED (tiers open on nodes bought in the lane: 2/4,
		# capstone at 6). The 12 original nodes keep their ids and payloads
		# verbatim; the Batch 31 conversion fillers were re-specced IN
		# PLACE (same ids, new effects), so saved ranks migrate.
		# --- Lane A: Bulwark — the shield itself: bigger, harder, more
		# often. Faith comes FROM absorbs, so this lane is the engine
		# block of the whole Conviction system. ---
		{"id": "dv_barrier", "name": "Blessed Barrier", "ranks": 3, "lane": "Bulwark", "tier": 0,
			"node_gated": true,
			"desc": "Divine Shield converts {v}% of the damage it absorbs into healing for its holder.",
			"scale": {"step": 4},
			"payload": {"stat": {"blessed_barrier_ranks": 1}}},
		{"id": "dv_aegis", "name": "Radient Aegis", "ranks": 3, "lane": "Bulwark", "tier": 0,
			"desc": "Casting Divine Shield has a {v}% chance to cast it again on another ally.",
			"scale": {"step": 15},
			"payload": {"stat": {"aegis_ranks": 1}}},
		{"id": "dv_afterglow", "name": "Afterglow", "ranks": 3, "lane": "Bulwark", "tier": 1,
			"desc": "When Divine Shield breaks, its holder is healed for {v}% of the Devout's max health.",
			"scale": {"step": 5},
			"payload": {"stat": {"afterglow_ranks": 1}}},
		# Re-spec (was a flat +3% armor dial): the armor now lives on the
		# shield itself — Divine Shield is the lane's only subject.
		{"id": "dv_warded", "name": "Warded Robes", "ranks": 2, "lane": "Bulwark", "tier": 1,
			"desc": "While Divine Shield holds, its holder has +{v}% armor.",
			"scale": {"step": 10},
			"payload": {"stat": {"warded_ranks": 1}}},
		# Re-spec (was -4% damage taken, exclusive with Righteous Fire
		# CROSS-LANE — that pair is gone). The new fork is in-lane and is
		# the shield lane's real question: a bigger shield, or a more
		# frequent one? Bastion also attacks the one-Faith-source-on-a-2cd
		# problem head on.
		{"id": "dv_stalwart", "name": "Stalwart", "ranks": 3, "lane": "Bulwark", "tier": 1,
			"exclusive_with": "dv_bastion",
			"desc": "Divine Shield absorbs {v}% of the Devout's max health (up from the base 30%).",
			"scale": {"base": 30, "step": 5},
			"payload": {"stat": {"stalwart_ranks": 1}}},
		# Re-spec (was a second Blessed Barrier step; ranks 2 -> 1 — the
		# loader refunds any over-cap saved rank).
		{"id": "dv_bastion", "name": "Bastion", "ranks": 1, "lane": "Bulwark", "tier": 1,
			"exclusive_with": "dv_stalwart",
			"desc": "Divine Shield's cooldown is reduced by 1 turn.",
			"payload": {"ability": "Divine Shield", "add": {"cooldown": -1}}},
		# Re-spec (was a second Radient Aegis step): the breaking shield
		# gets a second life instead of a second copy.
		{"id": "dv_unyielding", "name": "Unyielding Aegis", "ranks": 2, "lane": "Bulwark", "tier": 2,
			"desc": "When Divine Shield breaks, it immediately re-forms at {v}% of its original strength (once per cast).",
			"scale": {"step": 30},
			"payload": {"stat": {"unyielding_ranks": 1}}},
		# --- Lane B: Faith — the stack economy: earn it faster, keep it
		# longer, spend it deeper. ---
		{"id": "dv_communion", "name": "Communion", "ranks": 3, "lane": "Faith", "tier": 0,
			"desc": "When a party member reaches 5 Faith, every other member has a ({v} x their own Faith stacks)% chance to gain 1 stack.",
			"scale": {"step": 20},
			"payload": {"stat": {"communion_ranks": 1}}},
		{"id": "dv_unwavering", "name": "Unwavering Faith", "ranks": 3, "lane": "Faith", "tier": 0,
			"desc": "Increases the Devout's maximum health by {v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		{"id": "dv_devoutness", "name": "Devoutness", "ranks": 3, "lane": "Faith", "tier": 0,
			"desc": "The entire party takes {v}% less Break damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"devoutness_ranks": 1}}},
		{"id": "dv_faithful", "name": "Blessed are the Faithful", "ranks": 3, "lane": "Faith", "tier": 1,
			"desc": "The heal at 5 stacks of Faith restores {v}% max health (up from the base 15%).",
			"scale": {"base": 15, "step": 5},
			"payload": {"stat": {"faithful_ranks": 1}}},
		{"id": "dv_covenant", "name": "Sacred Covenant", "ranks": 3, "lane": "Faith", "tier": 1,
			"desc": "Should Divine Shield prevent lethal damage, its holder is healed for {v}% max health and gains that many Faith stacks (1 per rank).",
			"scale": {"step": 5},
			"payload": {"stat": {"covenant_ranks": 1}}},
		# Re-spec (was a second Blessed-are-the-Faithful step). THE node of
		# the batch: Faith's second source — party-wide, and riding a
		# base-kit cast instead of a talent. Conviction finally behaves
		# like the party-wide system its description promises.
		{"id": "dv_fervor", "name": "Fervor", "ranks": 2, "lane": "Faith", "tier": 1,
			"desc": "While Consecrated Ground holds, every ally gains {v} Faith at the start of their turn.",
			"scale": {"step": 1},
			"payload": {"stat": {"fervor_ranks": 1}}},
		# Re-spec (was a second Sacred Covenant step): shortens the re-ramp
		# after a release — allies live in the useful 3-5 band.
		{"id": "dv_oath", "name": "Binding Oath", "ranks": 2, "lane": "Faith", "tier": 2,
			"desc": "When an ally's Faith releases at 5 stacks, they keep {v} instead of resetting to zero.",
			"scale": {"step": 1},
			"payload": {"stat": {"oath_ranks": 1}}},
		# --- Lane C: Zeal — everything else he casts: the ground, the
		# blessing, the resolve. ---
		# Re-spec: keys off EITHER banner now (was Resolve only), so
		# skipping Sacred Resolve no longer strands the node.
		{"id": "dv_waters", "name": "Cleansing Waters", "ranks": 3, "lane": "Zeal", "tier": 0,
			"desc": "While Consecrated Ground or Sacred Resolve holds, each party member has a {v}% chance each turn to be cleansed of one harmful effect.",
			"scale": {"step": 15},
			"payload": {"stat": {"waters_ranks": 1}}},
		# Re-spec (was a flat +3% damage dial, exclusive with Stalwart
		# cross-lane): now it deepens Consecrated Ground's bite.
		{"id": "dv_righteous", "name": "Righteous Fire", "ranks": 3, "lane": "Zeal", "tier": 0,
			"desc": "Consecrated Ground reflects {v}% of damage taken (up from the base 10%).",
			"scale": {"base": 10, "step": 5},
			"payload": {"stat": {"righteous_ranks": 1}}},
		{"id": "dv_resolve", "name": "Sacred Resolve", "ranks": 1, "lane": "Zeal", "tier": 1,
			"desc": "New ability: Sacred Resolve — all damage received is split evenly among living heroes for 3 turns; Break damage still lands on the struck hero (25 Mana, 3.0 int, 5cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Sacred Resolve"}},
		# Re-spec: either banner keeps the pulse beating (was Resolve only).
		{"id": "dv_pulse", "name": "Healing Pulse", "ranks": 3, "lane": "Zeal", "tier": 1,
			"desc": "While Consecrated Ground or Sacred Resolve holds, the party heals {v}% of the Devout's max health each turn.",
			"scale": {"step": 2},
			"payload": {"stat": {"pulse_ranks": 1}}},
		# Re-spec (was Blessing of Zeal cooldown -1; ranks 1 -> 2): the
		# blessing's own cast-time cooldown tick deepens instead.
		{"id": "dv_crusade", "name": "Crusader's Tempo", "ranks": 2, "lane": "Zeal", "tier": 1,
			"desc": "Blessing of Zeal ticks its target's cooldowns down {v} additional turn(s) on cast.",
			"scale": {"step": 1},
			"payload": {"stat": {"crusade_ranks": 1}}},
		# Re-spec (was a second Cleansing Waters step): Blessing of Zeal
		# doubles Faith gain, so it now CARRIES a Faith source — the shield
		# is a true Divine Shield (flagged divine) and feeds Conviction.
		{"id": "dv_purity", "name": "Purity", "ranks": 2, "lane": "Zeal", "tier": 1,
			"desc": "Blessing of Zeal also grants its target a Divine Shield absorbing {v}% of the Devout's max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"purity_ranks": 1}}},
		# Re-spec (was a second Healing Pulse step; ranks 2 -> 3): pairs
		# with Righteous Fire — together the ground is a healing engine.
		{"id": "dv_lifewell", "name": "Lifewell", "ranks": 3, "lane": "Zeal", "tier": 2,
			"desc": "Damage reflected by Consecrated Ground heals the party for {v}% of the amount reflected.",
			"scale": {"step": 20},
			"payload": {"stat": {"lifewell_ranks": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		{"id": "dv_bulwark", "name": "Bulwark of Fortitude", "ranks": 1, "lane": "Bulwark", "tier": 2,
			"capstone": true,
			"desc": "New ability: Bulwark of Fortitude — for 3 turns the party takes NO Break damage, has its armor increased by 50%, and heals 10% of max health each turn (30 Mana, 3.5 int, 3cd; Perfect: the party instantly heals 5%).",
			"payload": {"grant_ability": "Bulwark of Fortitude"}},
		# Re-spec (was two Faithful steps + a Covenant step): the Faith
		# lane as a win condition — the party parks at max mitigation and
		# damage, and every absorb becomes a heal.
		{"id": "dv_apostle", "name": "Apostle", "ranks": 1, "lane": "Faith", "tier": 2,
			"capstone": true,
			"desc": "Faith releases no longer consume stacks: an ally at 5 Faith stays at 5, and every further Faith gain triggers the release again.",
			"payload": {"stat": {"apostle": 1}}},
		# Re-spec (was +8% damage + a Pulse step): a party role that is
		# neither healing nor damage — a Break-pressure engine that plays
		# straight into the Swordmaster's Break loop.
		{"id": "dv_judgement", "name": "Judgement", "ranks": 1, "lane": "Zeal", "tier": 2,
			"capstone": true,
			"desc": "While Consecrated Ground holds, every enemy that damages a hero is Sundered for 2 turns and takes Break damage equal to 20% of the damage it dealt.",
			"payload": {"stat": {"judgement": 1}}},
	],
	"mystic": [
		# Survivalist — NODE-GATED (tiers open on nodes bought in the lane:
		# 2/4, capstone at 6). Lanes: Venom / Snares / Guerilla.
		# --- Lane A: Venom — poison as a damage engine ---
		{"id": "sv_potent", "name": "Potent Toxins", "ranks": 3, "lane": "Venom", "tier": 0,
			"node_gated": true,
			"desc": "Your Poison deals +{v} damage per stack.", "scale": {"step": 1},
			"payload": {"stat": {"potent_ranks": 1}}},
		{"id": "sv_coated", "name": "Coated Blades", "ranks": 1, "lane": "Venom", "tier": 0,
			"desc": "Your basic attack applies Poison for 2 turns.",
			"payload": {"stat": {"coated_blades": 1}}},
		{"id": "sv_virulence", "name": "Virulence", "ranks": 2, "lane": "Venom", "tier": 1,
			"exclusive_with": "sv_slow_acting",
			"desc": "Your Poison applications add +{v} extra stack(s).", "scale": {"step": 1},
			"payload": {"stat": {"virulence_ranks": 1}}},
		{"id": "sv_slow_acting", "name": "Slow Acting", "ranks": 1, "lane": "Venom", "tier": 1,
			"exclusive_with": "sv_virulence",
			"desc": "Your Poison deals HALF damage but lasts TWICE as long and cannot be cleansed.",
			"payload": {"stat": {"slow_acting": 1}}},
		{"id": "sv_creeping", "name": "Creeping Death", "ranks": 1, "lane": "Venom", "tier": 1,
			"desc": "When a Poisoned enemy dies, its Poison stacks transfer to another enemy.",
			"payload": {"stat": {"creeping_death": 1}}},
		{"id": "sv_necrosis", "name": "Necrosis", "ranks": 1, "lane": "Venom", "tier": 2,
			"desc": "Poisoned enemies take +20% damage from ALL sources, not just yours.",
			"payload": {"stat": {"necrosis": 1}}},
		{"id": "sv_plague", "name": "Plague Bearer", "ranks": 1, "lane": "Venom", "tier": 2,
			"exclusive_with": "sv_network",
			"desc": "At the start of your turn, one Poisoned enemy spreads 3 Poison stacks to another.",
			"payload": {"stat": {"plague_bearer": 1}}},
		# --- Lane B: Snares — traps, retaliation, denial ---
		{"id": "sv_wire", "name": "Reinforced Wire", "ranks": 3, "lane": "Snares", "tier": 0,
			"desc": "Tripwire's retaliation deals +{v}% of your Attack.", "scale": {"step": 10},
			"payload": {"stat": {"wire_ranks": 1}}},
		{"id": "sv_rigging", "name": "Quick Rigging", "ranks": 1, "lane": "Snares", "tier": 0,
			"desc": "Snare Trap's cooldown is reduced by 1, and its spring also applies Cripple.",
			"payload": {"stat": {"quick_rigging": 1}}},
		{"id": "sv_cruel", "name": "Cruel Devices", "ranks": 2, "lane": "Snares", "tier": 1,
			"desc": "Your traps deal +{v}% damage.", "scale": {"step": 15},
			"payload": {"stat": {"cruel_ranks": 1}}},
		{"id": "sv_snap_shut", "name": "Snap Shut", "ranks": 1, "lane": "Snares", "tier": 1,
			"desc": "Tripwire also retaliates against RANGED attackers, not only melee.",
			"payload": {"stat": {"snap_shut": 1}}},
		{"id": "sv_caught", "name": "Caught Fast", "ranks": 1, "lane": "Snares", "tier": 1,
			"desc": "Enemies caught by your traps cannot be healed for 3 turns.",
			"payload": {"stat": {"caught_fast": 1}}},
		{"id": "sv_bone", "name": "Bone Breaker", "ranks": 1, "lane": "Snares", "tier": 2,
			"desc": "Your traps apply 30 Break damage when they spring.",
			"payload": {"stat": {"bone_breaker": 1}}},
		{"id": "sv_network", "name": "Deadfall Network", "ranks": 1, "lane": "Snares", "tier": 2,
			"exclusive_with": "sv_plague",
			"desc": "You may have TWO traps active at once.",
			"payload": {"stat": {"deadfall_network": 1}}},
		# --- Lane C: Guerilla — survival, mobility, party utility ---
		{"id": "sv_woodcraft", "name": "Woodcraft", "ranks": 3, "lane": "Guerilla", "tier": 0,
			"desc": "+{v}% max Health.", "scale": {"step": 6},
			"payload": {"stat": {"max_hp_pct": 0.06}}},
		{"id": "sv_hitrun", "name": "Hit and Run", "ranks": 1, "lane": "Guerilla", "tier": 0,
			"desc": "Whenever you apply a status to an enemy, you gain Elusive for 1 turn.",
			"payload": {"stat": {"hit_and_run": 1}}},
		{"id": "sv_scavenger", "name": "Scavenger", "ranks": 2, "lane": "Guerilla", "tier": 1,
			"desc": "Restore {v}% max Mana whenever an enemy dies.", "scale": {"step": 8},
			"payload": {"stat": {"scavenger_ranks": 1}}},
		{"id": "sv_medic", "name": "Field Medic", "ranks": 1, "lane": "Guerilla", "tier": 1,
			"desc": "At the start of your turn, cleanse one debuff from a random ally.",
			"payload": {"stat": {"field_medic": 1}}},
		{"id": "sv_vulture", "name": "Vulture", "ranks": 1, "lane": "Guerilla", "tier": 1,
			"desc": "+30% damage against enemies afflicted by 3 or more different statuses.",
			"payload": {"stat": {"vulture": 1}}},
		{"id": "sv_ghillie", "name": "Ghillie Suit", "ranks": 1, "lane": "Guerilla", "tier": 2,
			"desc": "Enemies are 40% less likely to target you while another ally lives.",
			"payload": {"stat": {"ghillie": 1}}},
		{"id": "sv_improvised", "name": "Improvised", "ranks": 1, "lane": "Guerilla", "tier": 2,
			"desc": "The first ability you use each fight does not start its cooldown.",
			"payload": {"stat": {"improvised": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		{"id": "sv_epidemic", "name": "Epidemic", "ranks": 1, "lane": "Venom", "tier": 2,
			"capstone": true,
			"desc": "Every enemy is PERMANENTLY Poisoned, and your Poison cannot be cleansed or expire.",
			"payload": {"stat": {"epidemic": 1}}},
		{"id": "sv_forest", "name": "The Whole Forest", "ranks": 1, "lane": "Snares", "tier": 2,
			"capstone": true,
			"desc": "Tripwire never expires and bites on EVERY enemy action — melee, ranged, or spellwork.",
			"payload": {"stat": {"whole_forest": 1}}},
		{"id": "sv_force", "name": "Force of Nature", "ranks": 1, "lane": "Guerilla", "tier": 2,
			"capstone": true,
			"desc": "Trapper's bonus rises to +20% per different status — and applies to your ENTIRE party's damage.",
			"payload": {"stat": {"force_of_nature": 1}}},
	],
	"sharpshooter": [
		# NODE-GATED tree (the marker below): tiers open on NODES BOUGHT in
		# the lane (2/4; capstone at 6), not points — with the escalating
		# cost curve, node count is the stable, legible gate.
		# --- Lane A: Precision — Focus, crit chance, crit damage ---
		{"id": "ss_steady", "name": "Steady Hands", "ranks": 3, "lane": "Precision", "tier": 0,
			"node_gated": true,
			"desc": "+{v}% critical chance.", "scale": {"step": 4},
			"payload": {"stat": {"crit_bonus": 0.04}}},
		{"id": "ss_perfect_form", "name": "Perfect Form", "ranks": 1, "lane": "Precision", "tier": 0,
			"desc": "Critical hits grant +20 Focus.",
			"payload": {"stat": {"perfect_form": 1}}},
		{"id": "ss_deep_focus", "name": "Deep Focus", "ranks": 1, "lane": "Precision", "tier": 1,
			"desc": "The Focus cap rises from 100 to 150.",
			"payload": {"stat": {"deep_focus": 1}}},
		{"id": "ss_exec_eye", "name": "Executioner's Eye", "ranks": 3, "lane": "Precision", "tier": 1,
			"exclusive_with": "ss_consistent",
			"desc": "Lethal Aim's critical multiplier rises to x{v}.",
			"scale": {"base": 2.0, "step": 0.1},
			"payload": {"stat": {"lethal_eye_ranks": 1}}},
		{"id": "ss_consistent", "name": "Consistent Aim", "ranks": 1, "lane": "Precision", "tier": 1,
			"exclusive_with": "ss_exec_eye",
			"desc": "Critical hits deal x1.5 again — but you gain +30% critical chance.",
			"payload": {"stat": {"consistent_aim": 1, "crit_bonus": 0.30}}},
		{"id": "ss_unwavering", "name": "Unwavering", "ranks": 1, "lane": "Precision", "tier": 2,
			"desc": "Switching targets HALVES your Focus instead of clearing it.",
			"payload": {"stat": {"unwavering": 1}}},
		{"id": "ss_tunnel", "name": "Tunnel Vision", "ranks": 1, "lane": "Precision", "tier": 2,
			"exclusive_with": "ss_spray",
			"desc": "+50% critical chance against the enemy you attacked last turn; -50% against every other enemy.",
			"payload": {"stat": {"tunnel_vision": 1}}},
		# --- Lane B: Penetration — armor, Break, finishing the party's work ---
		{"id": "ss_piercer", "name": "Armor Piercer", "ranks": 3, "lane": "Penetration", "tier": 0,
			"desc": "Your attacks ignore {v}% of the target's armor.", "scale": {"step": 8},
			"payload": {"stat": {"pierce_bonus": 0.08}}},
		{"id": "ss_sundering", "name": "Sundering Shot", "ranks": 1, "lane": "Penetration", "tier": 0,
			"desc": "Critical hits apply 15 Break damage.",
			"payload": {"stat": {"sundering_shot": 1}}},
		{"id": "ss_bonecracker", "name": "Bonecracker", "ranks": 2, "lane": "Penetration", "tier": 1,
			"desc": "+{v}% damage against Broken enemies.", "scale": {"step": 12},
			"payload": {"stat": {"bonecracker_ranks": 1}}},
		{"id": "ss_opp_aim", "name": "Opportunist's Aim", "ranks": 1, "lane": "Penetration", "tier": 1,
			"desc": "Powershot's Break scaling doubles: +4% damage per full point instead of +2%.",
			"payload": {"stat": {"opp_aim": 1}}},
		{"id": "ss_exposed_nerve", "name": "Exposed Nerve", "ranks": 1, "lane": "Penetration", "tier": 1,
			"desc": "Critical hits apply Exposed for 3 turns.",
			"payload": {"stat": {"exposed_nerve": 1}}},
		{"id": "ss_no_cover", "name": "No Cover", "ranks": 1, "lane": "Penetration", "tier": 2,
			"desc": "Your attacks cannot be made to miss: Blind and Dazed do not affect you, and Elusive does not protect against you.",
			"payload": {"stat": {"no_cover": 1}}},
		{"id": "ss_overkill", "name": "Overkill", "ranks": 1, "lane": "Penetration", "tier": 2,
			"desc": "Excess damage from a killing blow carries to another enemy at full value.",
			"payload": {"stat": {"overkill": 1}}},
		# --- Lane C: Tempo — speed, cooldowns, Focus acceleration ---
		{"id": "ss_fletcher", "name": "Fletcher's Speed", "ranks": 3, "lane": "Tempo", "tier": 0,
			"desc": "+{v} Speed.", "scale": {"step": 5},
			"payload": {"stat": {"speed": 5.0}}},
		{"id": "ss_snap", "name": "Snap Shot", "ranks": 1, "lane": "Tempo", "tier": 0,
			"desc": "The first ability you use each fight costs no Mana and does not start its cooldown.",
			"payload": {"stat": {"snap_shot": 1}}},
		{"id": "ss_muscle", "name": "Muscle Memory", "ranks": 2, "lane": "Tempo", "tier": 1,
			"desc": "Focus gain per attack increases by {v}.", "scale": {"step": 10},
			"payload": {"stat": {"muscle_memory_ranks": 1}}},
		{"id": "ss_volley", "name": "Opening Volley", "ranks": 1, "lane": "Tempo", "tier": 1,
			"desc": "You begin every fight with 60 Focus.",
			"payload": {"stat": {"opening_volley": 1}}},
		{"id": "ss_follow", "name": "Follow-Through", "ranks": 1, "lane": "Tempo", "tier": 1,
			"desc": "Critical hits reduce ALL your cooldowns by 1.",
			"payload": {"stat": {"follow_through": 1}}},
		{"id": "ss_second_nature", "name": "Second Nature", "ranks": 1, "lane": "Tempo", "tier": 2,
			"desc": "Hold Breath's guaranteed critical applies to your next TWO attacks.",
			"payload": {"stat": {"second_nature": 1}}},
		{"id": "ss_spray", "name": "Spray of Arrows", "ranks": 1, "lane": "Tempo", "tier": 2,
			"exclusive_with": "ss_tunnel",
			"desc": "Your single-target attacks strike one additional random enemy for 50% damage — but Focus can never exceed 50.",
			"payload": {"stat": {"spray": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		{"id": "ss_one_shot", "name": "One Shot", "ranks": 1, "lane": "Precision", "tier": 2,
			"capstone": true,
			"desc": "At maximum Focus, Aimed Shot EXECUTES any non-boss enemy below 35% health outright (elites included); otherwise it deals double damage. Either way, Focus resets to 0.",
			"payload": {"stat": {"one_shot": 1}}},
		{"id": "ss_tnt", "name": "Through and Through", "ranks": 1, "lane": "Penetration", "tier": 2,
			"capstone": true,
			"desc": "Your attacks ignore ALL armor, and every critical hit refunds its Mana cost.",
			"payload": {"stat": {"through_and_through": 1}}},
		{"id": "ss_rapid", "name": "Rapid Fire", "ranks": 1, "lane": "Tempo", "tier": 2,
			"capstone": true,
			"desc": "Each ability you use has a 35% chance not to consume its cooldown.",
			"payload": {"stat": {"rapid_fire": 1}}},
	],
	"beastmaster": [
		# --- Lane A: Devotion — stay with one beast, steepen the ramp ---
		{"id": "bm_communion", "name": "Wild Communion", "ranks": 3, "lane": "devotion", "tier": 0,
			"desc": "Companion strike damage per Loyalty stack rises to {v}% (from the base 5%).",
			"scale": {"base": 5.0, "step": 1.5},
			"payload": {"stat": {"wild_communion_ranks": 1}}},
		{"id": "bm_unbroken", "name": "Unbroken Watch", "ranks": 1, "lane": "devotion", "tier": 0,
			"desc": "The active beast gains +1 additional Loyalty on any turn it took no damage.",
			"payload": {"stat": {"unbroken_watch": 1}}},
		{"id": "bm_absolute", "name": "Absolute Devotion", "ranks": 1, "lane": "devotion", "tier": 1,
			"desc": "Loyalty ceiling rises from 5 to 7. The doubled Pack Bond still triggers at 5; stacks 6-7 add strike damage and the beast's gift only.",
			"payload": {"stat": {"loyalty_cap_bonus": 2}}},
		{"id": "bm_devoted_fury", "name": "Devoted Fury", "ranks": 1, "lane": "devotion", "tier": 1,
			"desc": "Bestial Wrath lasts 1 turn longer per 2 Loyalty stacks on the active beast.",
			"payload": {"stat": {"devoted_fury": 1}}},
		{"id": "bm_steadfast", "name": "Steadfast Bond", "ranks": 1, "lane": "devotion", "tier": 1,
			"exclusive_with": "bm_vengeance",
			"desc": "When a beast dies, its Loyalty returns at half rather than resetting to 0.",
			"payload": {"stat": {"steadfast_bond": 1}}},
		{"id": "bm_ancient_pact", "name": "Ancient Pact", "ranks": 1, "lane": "devotion", "tier": 2,
			"desc": "At 5 Loyalty the Pack Bond boon is TRIPLED instead of doubled — but the beast can no longer be healed by ANY source (Spirit Bond and Hunter's Instinct included).",
			"payload": {"stat": {"ancient_pact": 1}}},
		{"id": "bm_lone_bond", "name": "Lone Bond", "ranks": 1, "lane": "devotion", "tier": 2,
			"exclusive_with": "bm_wild_rotation",
			"desc": "You may summon only ONE beast per fight: it cannot be swapped, and cannot be re-summoned if it dies. Its Loyalty starts at 3 and caps at 8.",
			"payload": {"stat": {"lone_bond": 1}}},
		# --- Lane B: The Pack — rotate; swapping becomes the engine ---
		{"id": "bm_whistle", "name": "Quick Whistle", "ranks": 2, "lane": "pack", "tier": 0,
			"desc": "Swap Companion's cooldown is reduced by {v} turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"quick_whistle_ranks": 1}}},
		{"id": "bm_momentum", "name": "Feral Momentum", "ranks": 3, "lane": "pack", "tier": 0,
			"desc": "+{v}% companion damage for each DIFFERENT beast summoned this fight.",
			"scale": {"step": 8},
			"payload": {"stat": {"momentum_ranks": 1}}},
		{"id": "bm_shared", "name": "Shared Devotion", "ranks": 1, "lane": "pack", "tier": 1,
			"desc": "Summoning or swapping grants +1 Loyalty to EVERY beast, not only the arriving one.",
			"payload": {"stat": {"shared_devotion": 1}}},
		{"id": "bm_herald", "name": "Herald", "ranks": 1, "lane": "pack", "tier": 1,
			"desc": "Arrival effects strike an additional target: Guardian's Roar taunts TWO enemies, Aguila's dive hits TWO, and Bloodhowl doubles its Bleed on the bloodiest enemy.",
			"payload": {"stat": {"herald": 1}}},
		{"id": "bm_menagerie", "name": "Menagerie", "ranks": 1, "lane": "pack", "tier": 1,
			"desc": "The Pack Bond boon of every beast summoned this fight stays active at HALF strength while that beast is away.",
			"payload": {"stat": {"menagerie": 1}}},
		{"id": "bm_no_beast_left", "name": "No Beast Left", "ranks": 1, "lane": "pack", "tier": 2,
			"desc": "When a beast dies, your next summon this fight costs no Mana and ignores its cooldown.",
			"payload": {"stat": {"no_beast_left": 1}}},
		{"id": "bm_wild_rotation", "name": "Wild Rotation", "ranks": 1, "lane": "pack", "tier": 2,
			"exclusive_with": "bm_lone_bond",
			"desc": "Swap Companion has no cooldown and arrival effects always fire. Loyalty caps at 2.",
			"payload": {"stat": {"wild_rotation": 1}}},
		# --- Lane C: Handler — your own game: Quick Shot, Mana, loss ---
		{"id": "bm_masters_aim", "name": "Master's Aim", "ranks": 3, "lane": "handler", "tier": 0,
			"desc": "Quick Shot deals +{v}% of your Attack.",
			"scale": {"step": 6},
			"payload": {"stat": {"masters_aim_ranks": 1}}},
		{"id": "bm_beast_within", "name": "Beast Within", "ranks": 3, "lane": "handler", "tier": 0,
			"desc": "+{v}% companion max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"companion_hp_pct": 0.10}}},
		{"id": "bm_reserves", "name": "Deep Reserves", "ranks": 2, "lane": "handler", "tier": 1,
			"desc": "Spirit Bond restores +{v}% more max Mana.",
			"scale": {"step": 8},
			"payload": {"stat": {"deep_reserves_ranks": 1}}},
		{"id": "bm_instinctive", "name": "Instinctive", "ranks": 1, "lane": "handler", "tier": 1,
			"desc": "Hunter's Instinct empowers 5 Quick Shots instead of 3.",
			"payload": {"stat": {"instinctive": 1}}},
		{"id": "bm_symbiosis", "name": "Symbiosis", "ranks": 1, "lane": "handler", "tier": 1,
			"desc": "Whenever your companion strikes, you restore 2% max Mana.",
			"payload": {"stat": {"symbiosis": 1}}},
		{"id": "bm_vengeance", "name": "Vengeance", "ranks": 1, "lane": "handler", "tier": 2,
			"exclusive_with": "bm_steadfast",
			"desc": "When your beast dies you inherit its Pack Bond boon and gain +30% damage, for 5 turns.",
			"payload": {"stat": {"vengeance": 1}}},
		{"id": "bm_lone_hunter", "name": "Lone Hunter", "ranks": 1, "lane": "handler", "tier": 2,
			"desc": "While you have no companion, your abilities cost 40% less Mana and you deal +25% damage.",
			"payload": {"stat": {"lone_hunter": 1}}},
		# --- Capstones: take ONE (8 points in the matching lane) ---
		{"id": "bm_one_soul", "name": "One Soul", "ranks": 1, "lane": "devotion", "tier": 2,
			"capstone": true,
			"desc": "You and the active beast share a health pool — all damage to either is split evenly between you. Loyalty gain is doubled.",
			"payload": {"stat": {"one_soul": 1}}},
		{"id": "bm_the_pack", "name": "The Pack", "ranks": 1, "lane": "pack", "tier": 2,
			"capstone": true, "locked_note": "Coming soon.",
			"desc": "Two beasts may be active at once. Both have 70% max health and their Loyalty ceilings cap at 3. (Coming in a later batch.)",
			"payload": {"stat": {"the_pack": 1}}},
		{"id": "bm_apex", "name": "Apex Predator", "ranks": 1, "lane": "handler", "tier": 2,
			"capstone": true,
			"desc": "Quick Shot triggers an ADDITIONAL free companion strike, and Kill Command's cooldown resets whenever an enemy dies.",
			"payload": {"stat": {"apex": 1}}},
	],
	"occultist": [
		# Purpose-designed lanes (Batch L, 07-30) — NODE-GATED (tiers open
		# on nodes bought in the lane: 2/4, capstone at 6). The 11 mapped
		# original nodes keep their ids and payloads verbatim (Dark Infusion
		# was already dropped by the Batch 31 conversion and stays out); the
		# conversion fillers were re-specced IN PLACE (same ids, new
		# effects), so saved ranks migrate. The deliberate bias: CROSS-LANE
		# PLUMBING — the three lanes never fed one another, so Delirium
		# makes Madness generate Ruin, and Cackling Mirror / Soul Glut make
		# both generate healing. Three lanes running one loop.
		# --- Lane A: Ruin — the detonation engine: stack the mark, blow
		# it, chain it. Entropy is the Pressure archetype made literal. ---
		{"id": "oc_emp_hex", "name": "Empowered Hex", "ranks": 3, "lane": "Ruin", "tier": 0,
			"node_gated": true,
			"desc": "Hex of Ruin has a {v}% chance per target to also apply Decay (10 Break damage per turn, 3 turns).",
			"scale": {"step": 25},
			"payload": {"stat": {"emp_hex_ranks": 1}}},
		# Re-spec (was a second Empowered Hex step; ranks 2 -> 3): each
		# stack of the mark now cracks its bearer wider — the meter does
		# damage work while it fills.
		{"id": "oc_deep_hex", "name": "Deeper Hex", "ranks": 3, "lane": "Ruin", "tier": 0,
			"desc": "Each stack of Ruin makes its bearer take {v}% more damage (up from the base 2%).",
			"scale": {"base": 2, "step": 1},
			"payload": {"stat": {"deep_hex_ranks": 1}}},
		{"id": "oc_channeling", "name": "Corrupted Channeling", "ranks": 3, "lane": "Ruin", "tier": 1,
			"desc": "Whenever a Crippled enemy attacks, a random hero heals for {v}% of the damage it dealt.",
			"scale": {"step": 25},
			"payload": {"stat": {"channeling_ranks": 1}}},
		{"id": "oc_broken_will", "name": "Broken Will", "ranks": 3, "lane": "Ruin", "tier": 1,
			"desc": "The Occultist deals {v}% more Break damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"broken_will_ranks": 1}}},
		# Re-spec (was a flat +3% damage dial, exclusive with Pact of Flesh
		# CROSS-LANE — that pair is gone; ranks 3 -> 2): the detonation is
		# the lane's payoff, so the damage dial lives on it now.
		{"id": "oc_grim", "name": "Grim Focus", "ranks": 2, "lane": "Ruin", "tier": 1,
			"desc": "Ruin detonations deal {v}% more damage.",
			"scale": {"step": 25},
			"payload": {"stat": {"grim_ranks": 1}}},
		# Re-spec (was a second Broken Will step; ranks 2 -> 3): any Ruin at
		# all now grinds the Break meter on its own — and feeds the
		# Swordmaster's Broken-window loop across the party.
		{"id": "oc_entropy", "name": "Entropy", "ranks": 3, "lane": "Ruin", "tier": 1,
			"desc": "Enemies bearing any Ruin take {v} Break damage at the start of each of their turns.",
			"scale": {"step": 5},
			"payload": {"stat": {"entropy_ranks": 1}}},
		# Re-spec (was Hex of Ruin -5 Mana; ranks 2 -> 3): a detonation now
		# seeds the mark in every other enemy — the next meter is already
		# filling. One propagation per detonation (battle.gd enforces it).
		{"id": "oc_unravel", "name": "Unraveling", "ranks": 3, "lane": "Ruin", "tier": 2,
			"desc": "When Ruin detonates, every other enemy gains {v} Ruin.",
			"scale": {"step": 1},
			"payload": {"stat": {"unravel_ranks": 1}}},
		# --- Lane B: Madness — enemies turned on each other, and the
		# betrayal now has somewhere to go: Delirium turns it into Ruin,
		# Cackling Mirror turns it into healing. ---
		{"id": "oc_spread", "name": "Spread of Madness", "ranks": 3, "lane": "Madness", "tier": 0,
			"desc": "Psychosis has a {v}% chance per turn to spread to a fellow minion — the newly maddened gain a stack of Ruin.",
			"scale": {"step": 15},
			"payload": {"stat": {"spread_ranks": 1}}},
		# Re-spec (was Bewitch -5 Mana; ranks 2 -> 3): at 50%, half of
		# every Psychosis is a wasted turn and the lane feels unreliable.
		# At 80% it's a plan.
		{"id": "oc_whispers", "name": "Whispers", "ranks": 3, "lane": "Madness", "tier": 0,
			"desc": "Psychosis takes the wheel {v}% of the time (up from the base 50%).",
			"scale": {"base": 50, "step": 10},
			"payload": {"stat": {"whispers_ranks": 1}}},
		{"id": "oc_mind_flay", "name": "Mind Flay", "ranks": 1, "lane": "Madness", "tier": 1,
			"desc": "New ability: Mind Flay — 30% of Attack in shadow to TWO chosen minions, inflicting Psychosis for 3 turns (25 Mana, 3.0 int, 2cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Mind Flay"}},
		{"id": "oc_mirror", "name": "Umbral Mirror", "ranks": 3, "lane": "Madness", "tier": 1,
			"desc": "When an enemy would debuff a hero, there is a {v}% chance the debuff reflects back onto it instead (and counts toward Ruin).",
			"scale": {"step": 10},
			"payload": {"stat": {"mirror_ranks": 1}}},
		# Re-spec (was a second Spread of Madness step): THE cross-lane
		# node — every maddened strike now builds toward a detonation.
		# Madness generates Ruin.
		{"id": "oc_delirium", "name": "Delirium", "ranks": 2, "lane": "Madness", "tier": 1,
			"desc": "When a Psychotic, Bewitched or Hysterical enemy strikes a fellow, the victim gains {v} Ruin.",
			"scale": {"step": 1},
			"payload": {"stat": {"delirium_ranks": 1}}},
		# Re-spec (was a second Umbral Mirror step): the other half of the
		# plumbing — Madness generates healing, in his own siphoning voice.
		{"id": "oc_cackling", "name": "Cackling Mirror", "ranks": 2, "lane": "Madness", "tier": 1,
			"desc": "When an enemy strikes a fellow, the party heals {v}% of the damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"cackling_ranks": 1}}},
		# Re-spec (was Bewitch cooldown -1; ranks 1 -> 2): madness never
		# just ends any more — it curdles into the rot.
		{"id": "oc_torment", "name": "Lingering Torment", "ranks": 2, "lane": "Madness", "tier": 2,
			"desc": "When a madness effect expires, it leaves Decay behind for {v} turns (10 Break damage per turn).",
			"scale": {"step": 2},
			"payload": {"stat": {"torment_ranks": 1}}},
		# --- Lane C: Leech — suffering into sustain. Holy restores, the
		# Devout prevents, the Occultist siphons. ---
		{"id": "oc_soul_leech", "name": "Soul Leech", "ranks": 3, "lane": "Leech", "tier": 0,
			"desc": "Heroes striking a Ruined target heal {v}% of the damage dealt (up from the base 10%).",
			"scale": {"base": 10, "step": 5},
			"payload": {"stat": {"soul_leech_ranks": 1}}},
		{"id": "oc_invigoration", "name": "Invigoration", "ranks": 3, "lane": "Leech", "tier": 0,
			"desc": "Dark Pact also restores {v}% of the Cleric's max Mana each turn for 3 turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"invigoration_ranks": 1}}},
		# Re-spec (was a second Soul Leech step; ranks 2 -> 3): its own
		# cheaper dial on the same draught.
		{"id": "oc_gluttony", "name": "Gluttony", "ranks": 3, "lane": "Leech", "tier": 0,
			"desc": "The Ruin lifesteal drinks another {v}% of the damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"gluttony_ranks": 1}}},
		{"id": "oc_pleasure", "name": "Pleasure from Pain", "ranks": 3, "lane": "Leech", "tier": 1,
			"desc": "At the end of the Occultist's turn, the party heals {v}% of the Occultist's max health for every UNIQUE debuff on the enemy team.",
			"scale": {"step": 0.5},
			"payload": {"stat": {"pleasure_ranks": 1}}},
		{"id": "oc_murderous", "name": "Murderous Intent", "ranks": 3, "lane": "Leech", "tier": 1,
			"desc": "When a Bewitched enemy kills one of its fellows, the lowest-health party member heals {v}% of the Occultist's max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"murderous_ranks": 1}}},
		# Re-spec (was +4% max health, exclusive with Grim Focus CROSS-LANE
		# — that pair is gone; ranks 3 -> 2). The new fork is in-lane and
		# the cleanest possible: one ability, pay less or get more. Dark
		# Pact is the one place he trades his own body for the party's.
		{"id": "oc_pact_flesh", "name": "Pact of Flesh", "ranks": 2, "lane": "Leech", "tier": 1,
			"exclusive_with": "oc_barter",
			"desc": "Dark Pact bleeds {v}% less of the Occultist's max health (from its base cost of 20%).",
			"scale": {"step": 10},
			"payload": {"stat": {"pact_flesh_ranks": 1}}},
		# Re-spec (was Dark Pact cooldown -1; ranks 1 -> 2): the other jaw
		# of the fork — the party drinks deeper from the same wound.
		{"id": "oc_barter", "name": "Dark Barter", "ranks": 2, "lane": "Leech", "tier": 1,
			"exclusive_with": "oc_pact_flesh",
			"desc": "Dark Pact heals the party for {v}% of each member's max health (up from the base 15%).",
			"scale": {"base": 15, "step": 10},
			"payload": {"stat": {"barter_ranks": 1}}},
		# --- Capstones: take ONE (6 nodes bought in the lane) ---
		# Re-spec (was an Emp Hex / Channeling stat bundle): the natural
		# end state of a lane built on filling a meter — a maxed target is
		# a recurring bomb.
		{"id": "oc_avatar_ruin", "name": "Avatar of Ruin", "ranks": 1, "lane": "Ruin", "tier": 2,
			"capstone": true,
			"desc": "Ruin detonations no longer consume their stacks: a target held at 5 Ruin detonates again at the start of each of its turns.",
			"payload": {"stat": {"avatar_ruin": 1}}},
		{"id": "oc_hysteria", "name": "Mass Hysteria", "ranks": 1, "lane": "Madness", "tier": 2,
			"capstone": true,
			"desc": "New ability: Mass Hysteria — next turn every minion strikes a fellow with DOUBLE Break damage, Sundering them for 3 turns (30 Mana, 4.0 int, 4cd; Perfect: 3cd).",
			"payload": {"grant_ability": "Mass Hysteria"}},
		# Re-spec (was a Soul Leech / max-health stat bundle): the "lesser
		# healer" becomes a real one through his own mechanic — every
		# hero's attack into a Ruined enemy is party-wide sustain.
		{"id": "oc_soul_glut", "name": "Soul Glut", "ranks": 1, "lane": "Leech", "tier": 2,
			"capstone": true,
			"desc": "Whenever a hero heals by striking a Ruined target, the whole party heals for the same amount.",
			"payload": {"stat": {"soul_glut": 1}}},
	],
}


# ---------- LANE CONVERSIONS (Batch 31: every classic tree goes lanes) ----------
# Each classic 12-node tree converts to the Beastmaster layout: 3 lanes x 7
# + 3 capstones (take one). "map" re-homes the EXISTING nodes (payloads
# untouched): id -> [lane, tier] / [lane, tier, "cap"] / [lane, tier, "",
# exclusive_id]. "new" holds the invented filler nodes — numeric dials and
# kit tweaks on existing machinery only, placed for the designer to review.
const LANE_CONVERSIONS := {
	"arcanist": {
		"map": {
			"ar_mastery": ["Resonance", 0], "ar_attunement": ["Resonance", 1],
			"ar_unlimited": ["Resonance", 1],
			"ar_overcharge": ["Overload", 0], "ar_on_edge": ["Overload", 1],
			"ar_critical_mass": ["Overload", 1],
			"ar_mindfulness": ["Control", 0], "ar_temporal": ["Control", 1],
			"ar_conversion": ["Control", 1], "ar_stable": ["Control", 1],
			"ar_suppressing": ["Control", 2],
			"ar_wrath": ["Overload", 2, "cap"],
		},
		"new": [
			{"id": "ar_harmonics", "name": "Harmonics", "ranks": 2, "lane": "Resonance", "tier": 0,
				"desc": "Arcane Mastery hums another {v}% crit per stack.", "scale": {"step": 1},
				"payload": {"stat": {"arcane_mastery_ranks": 1}}},
			{"id": "ar_conduit", "name": "Conduit", "ranks": 2, "lane": "Resonance", "tier": 1,
				"desc": "Mana Attunement returns another step on overflow.",
				"payload": {"stat": {"mana_attune_ranks": 1}}},
			{"id": "ar_core", "name": "Resonant Core", "ranks": 2, "lane": "Resonance", "tier": 2,
				"desc": "+{v}% max health.", "scale": {"step": 4},
				"payload": {"stat": {"max_hp_pct": 0.04}}},
			{"id": "ar_charged", "name": "Charged Bolts", "ranks": 3, "lane": "Resonance", "tier": 2,
				"desc": "Arcane Explosion deals {v} more damage per bolt.", "scale": {"step": 3},
				"payload": {"ability": "Arcane Explosion", "add": {"damage": 3}}},
			{"id": "ar_volatility", "name": "Volatility", "ranks": 3, "lane": "Overload", "tier": 0,
				"desc": "+{v}% crit chance.", "scale": {"step": 2},
				"payload": {"stat": {"crit_bonus": 0.02}}},
			{"id": "ar_cannoneer", "name": "Cannoneer", "ranks": 3, "lane": "Overload", "tier": 1,
				"desc": "Arcane Cannon deals {v} more damage.", "scale": {"step": 6},
				"payload": {"ability": "Arcane Cannon", "add": {"damage": 6}}},
			{"id": "ar_barrister", "name": "Barrage Master", "ranks": 2, "lane": "Overload", "tier": 2,
				"desc": "Arcane Barrage costs {v} less Mana.", "scale": {"step": 5},
				"payload": {"ability": "Arcane Barrage", "add": {"cost": -5}}},
			{"id": "ar_meltdown", "name": "Meltdown", "ranks": 2, "lane": "Overload", "tier": 2,
				"exclusive_with": "ar_still",
				"desc": "+{v}% damage dealt AND +{v}% damage taken.", "scale": {"step": 4},
				"payload": {"stat": {"dmg_bonus": 0.04, "dmg_taken_bonus": 0.04}}},
			{"id": "ar_ward", "name": "Arcane Ward", "ranks": 2, "lane": "Control", "tier": 0,
				"desc": "+{v}% armor.", "scale": {"step": 3},
				"payload": {"stat": {"armor": 0.03}}},
			{"id": "ar_still", "name": "Still Mind", "ranks": 2, "lane": "Control", "tier": 2,
				"exclusive_with": "ar_meltdown",
				"desc": "Take {v}% less damage.", "scale": {"step": 4},
				"payload": {"stat": {"dmg_taken_bonus": -0.04}}},
			{"id": "ar_singularity", "name": "Singularity", "ranks": 1, "lane": "Resonance", "tier": 2,
				"capstone": true,
				"desc": "Arcane Mastery deepens two steps and Unlimited Power one.",
				"payload": {"stat": {"arcane_mastery_ranks": 2, "unlimited_ranks": 1}}},
			{"id": "ar_timelord", "name": "Master of Moments", "ranks": 1, "lane": "Control", "tier": 2,
				"capstone": true,
				"desc": "Temporal Rift echoes two steps deeper and Mindfulness one.",
				"payload": {"stat": {"temporal_ranks": 2, "mindfulness_ranks": 1}}},
		],
	},
}


static func has_tree(spec: String) -> bool:
	return FIXED_TREES.has(spec) or LANE_TREES.has(spec)


static func generate_tree(spec: String, _class_key: String) -> Array:
	# Lane trees (new framework) first; classic trees convert to lanes at
	# build time (Batch 31) — existing node ids and payloads untouched, so
	# saves keep their ranks. Specs without a tree get "coming soon".
	if LANE_TREES.has(spec):
		return LANE_TREES[spec].duplicate(true)
	if FIXED_TREES.has(spec):
		var base: Array = FIXED_TREES[spec].duplicate(true)
		if not LANE_CONVERSIONS.has(spec):
			return base
		var conv: Dictionary = LANE_CONVERSIONS[spec]
		var out: Array = []
		for t in base:
			var m: Array = conv["map"].get(t["id"], [])
			if m.is_empty():
				continue
			t.erase("row")
			t.erase("col")
			t.erase("gate")
			t.erase("requires")
			t.erase("requires_ranks")
			t["lane"] = m[0]
			t["tier"] = m[1]
			if m.size() > 2 and str(m[2]) == "cap":
				t["capstone"] = true
			if m.size() > 3 and str(m[3]) != "":
				t["exclusive_with"] = m[3]
			out.append(t)
		out.append_array(conv["new"].duplicate(true))
		return out
	return []


static func is_lane_tree(tree_nodes: Array) -> bool:
	return not tree_nodes.is_empty() and tree_nodes[0].has("lane")


static func is_node_gated(tree_nodes: Array) -> bool:
	return not tree_nodes.is_empty() and tree_nodes[0].get("node_gated", false)


# Distinct non-capstone nodes bought in a lane (node-gated trees).
static func lane_nodes_bought(tree_nodes: Array, learned: Dictionary,
		lane: String) -> int:
	var n := 0
	for t in tree_nodes:
		if str(t.get("lane", "")) == lane and not t.get("capstone", false) \
				and int(learned.get(t["id"], 0)) > 0:
			n += 1
	return n


# The Nth DISTINCT node bought costs ceil(N/3); extra ranks cost 1.
static func next_node_cost(learned: Dictionary) -> int:
	var distinct := 0
	for node_id in learned:
		if int(learned[node_id]) > 0:
			distinct += 1
	return int(ceil((distinct + 1) / 3.0))


static func node_cost(tree_nodes: Array, learned: Dictionary, id: String) -> int:
	if not is_lane_tree(tree_nodes):
		return 1
	if int(learned.get(id, 0)) > 0:
		return 1
	return next_node_cost(learned)


# Points spent in one lane: each bought lane node contributes the price it
# cost when purchased (reconstructed from the purchase order; definition
# order is the fallback for saves without one) plus 1 per extra rank.
static func lane_points(tree_nodes: Array, learned: Dictionary, order: Array,
		lane: String) -> int:
	var buy_order: Array = order.duplicate()
	if buy_order.is_empty():
		for t in tree_nodes:
			if int(learned.get(t["id"], 0)) > 0:
				buy_order.append(t["id"])
	var total := 0
	for i in buy_order.size():
		var t := node_in_tree(tree_nodes, buy_order[i])
		if t.is_empty() or int(learned.get(t["id"], 0)) < 1:
			continue
		if str(t.get("lane", "")) == lane:
			total += int(ceil((i + 1) / 3.0)) + (int(learned[t["id"]]) - 1)
	return total


static func node_in_tree(tree_nodes: Array, id: String) -> Dictionary:
	for t in tree_nodes:
		if t["id"] == id:
			return t
	return {}


# Tooltip text for a node at the player's invested ranks: "{v}" in the desc
# becomes scale.base + scale.step × ranks (unlearned nodes preview rank 1) —
# "+3% ... +6% ... +9%" instead of "per rank" phrasing.
static func desc_for(node: Dictionary, ranks: int) -> String:
	var desc: String = node["desc"]
	if node.has("scale"):
		var sc: Dictionary = node["scale"]
		var val := float(sc.get("base", 0.0)) \
			+ float(sc.get("step", 0.0)) * maxi(ranks, 1)
		desc = desc.replace("{v}", String.num(val, 2))
	return desc


# Points spent in this run's tree = all learned ranks (one tree per hero).
static func points_spent(learned: Dictionary) -> int:
	var total := 0
	for id in learned:
		total += int(learned[id])
	return total


# Points spent in rows strictly below `row` (cumulative row gating).
static func points_below_row(tree_nodes: Array, learned: Dictionary, row: int) -> int:
	var total := 0
	for t in tree_nodes:
		if int(t.get("row", 0)) < row:
			total += int(learned.get(t["id"], 0))
	return total


static func can_learn(tree_nodes: Array, id: String, learned: Dictionary,
		order: Array = []) -> Dictionary:
	var t := node_in_tree(tree_nodes, id)
	if t.is_empty():
		return {"ok": false, "why": "Unknown"}
	if int(learned.get(id, 0)) >= int(t["ranks"]):
		return {"ok": false, "why": "Maxed"}
	# Lane trees: lane-tier gating, one-capstone rule, exclusive pairs.
	if t.has("lane"):
		if t.has("locked_note"):
			return {"ok": false, "why": str(t["locked_note"])}
		var lane := str(t["lane"])
		var node_gated := is_node_gated(tree_nodes)
		var in_lane := (lane_nodes_bought(tree_nodes, learned, lane) if node_gated \
			else lane_points(tree_nodes, learned, order, lane))
		var unit_word := "nodes in" if node_gated else "pts in"
		if t.get("capstone", false):
			for other in tree_nodes:
				if other.get("capstone", false) and other["id"] != id \
						and int(learned.get(other["id"], 0)) > 0:
					return {"ok": false, "why": "Barred: %s is your capstone" % \
						other["name"]}
			var cap_need := NODE_CAPSTONE_REQ if node_gated else CAPSTONE_REQ
			if in_lane < cap_need:
				return {"ok": false, "why": "Locked: %d %s %s (have %d)" % [
					cap_need, unit_word, LANE_NAMES.get(lane, lane), in_lane]}
		else:
			var lane_need := int((NODE_TIER_REQ if node_gated else LANE_TIER_REQ) \
				.get(int(t.get("tier", 0)), 0))
			if in_lane < lane_need:
				return {"ok": false, "why": "Locked: %d %s %s (have %d)" % [
					lane_need, unit_word, LANE_NAMES.get(lane, lane), in_lane]}
		var excl := str(t.get("exclusive_with", ""))
		if excl != "" and int(learned.get(excl, 0)) > 0:
			var excl_node := node_in_tree(tree_nodes, excl)
			return {"ok": false, "why": "Barred: %s was taken" % \
				excl_node.get("name", excl)}
		return {"ok": true, "why": ""}
	var row := int(t.get("row", 0))
	var need := int(ROW_REQ.get(row, 0))
	if points_below_row(tree_nodes, learned, row) < need:
		return {"ok": false, "why": "Locked: %d pts in earlier rows" % need}
	var req: String = t.get("requires", "")
	if req != "" and int(learned.get(req, 0)) < int(t.get("requires_ranks", 1)):
		var req_node := node_in_tree(tree_nodes, req)
		return {"ok": false, "why": "Locked: needs %s (%d)" % [
			req_node.get("name", req), int(t.get("requires_ranks", 1))]}
	return {"ok": true, "why": ""}


# Applies a tree's learned talents onto a hero config.
static func apply_from_tree(cfg: Dictionary, tree_nodes: Array, learned: Dictionary) -> void:
	for t in tree_nodes:
		var ranks := int(learned.get(t["id"], 0))
		if ranks < 1:
			continue
		apply_payload(cfg, t["payload"], ranks)


# Shared payload applicator (talents and shop runes). Stats missing from the
# config (e.g. talent counters) default to 0; ranks are additive.
static func apply_payload(cfg: Dictionary, payload: Dictionary, ranks: int) -> void:
	if payload.has("stat"):
		for field in payload["stat"]:
			var v = payload["stat"][field]
			var base = 0.0 if v is float else 0
			cfg[field] = cfg.get(field, base) + v * ranks
	elif payload.has("new_ability"):
		var nab: Ability = Ability.make(payload["new_ability"])
		# Never double-grant (the Batch 31 testing aid pre-grants these).
		if not cfg["abilities"].any(func(a): return a.display_name == nab.display_name):
			cfg["abilities"] = cfg["abilities"] + [nab]
	elif payload.has("grant_ability"):
		# The ability def lives in Classes (single source shared with the
		# DOD_SIM_ABILITIES hook), not inline in the node.
		var granted := Classes.pending_talent_ability(payload["grant_ability"])
		if granted != null \
				and not cfg["abilities"].any(func(a): return a.display_name == granted.display_name):
			cfg["abilities"] = cfg["abilities"] + [granted]
	elif payload.has("ability"):
		for ab in cfg["abilities"]:
			if ab.display_name == payload["ability"]:
				for field in payload.get("add", {}):
					ab.set(field, ab.get(field) + payload["add"][field] * ranks)
				for field in payload.get("set", {}):
					ab.set(field, payload["set"][field])
				if payload.has("status_turns") and not ab.applies_status.is_empty():
					ab.applies_status["turns"] = payload["status_turns"]
