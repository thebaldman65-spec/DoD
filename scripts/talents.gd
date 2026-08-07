# Talent trees. Every spec is 3 lanes x 7 ROWS plus a capstone row (Batch
# AI). Learned talents: {id: ranks} — but ranks are always 1 now, so the
# dict is really a set; the shape stays because every read site in the game
# speaks it. Tooltips never say "per rank" — descs hold a "{v}" placeholder
# and a "scale" {base, step}; desc_for() renders the value at rank 1, which
# since Batch AI is the only value a node ever has.
#
# THE RULES, all of them:
#   - A row holds one node per lane and the player picks EXACTLY ONE. The
#     other two are shut for good (visible and greyed — the player must see
#     the door they closed).
#   - Row 1 is open from the start; row N opens when row N-1 has been picked.
#   - Row 8 is the capstone shelf: it opens when all 7 rows are picked, take
#     one, and there is NO lane-purity requirement.
#   - Every node costs 1 point and holds a single rank. No exceptions.
#   - ELITE points (Run.talent_flex) are the one crack in row exclusivity:
#     they cannot open a new row, only buy a SECOND node in a row already
#     picked. The third node in that row stays shut forever.
# A complete tree is 8 nodes, and a 3-zone run guarantees exactly 8 points.
class_name Talents

const LANE_NAMES := {"devotion": "Devotion", "pack": "The Pack", "handler": "Handler"}

# Rows 1-7 are the lanes; row 8 is the capstone shelf.
const ROWS := 7
const CAPSTONE_ROW := 8
# Second node in an already-picked row (bought with an elite point). The
# third is never reachable — one crack per row, not an open door.
const MAX_PER_ROW := 2

const LANE_TREES := {
	"berserker": [
		# Purpose-designed lanes (Batch C, 07-27); Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row; BATCH AJ re-authored all
		# 24 nodes for that structure. Every id survives and re-specs in
		# place, so saved picks migrate.
		#
		# BATCH AJ, the shape of the re-author. A node is a ROW now, not one
		# of three ranks, so every magnitude below is priced against the two
		# doors it closes rather than against its own old rank 1 — which came
		# out 2-3x across the board. The rows are THEMED: each one asks a
		# question and each lane answers it its own way (1 the opening, 2 the
		# wound, 3 what the wound pays, 4 the edge, 5 what compounds,
		# 6 refusal, 7 the finish, 8 the capstone).
		#
		# TWO NODES CHANGED WHAT THEY DO, both re-specced in place:
		#   - bz_vitality was Vitality (+5% max HP) and is now FIRST BLOOD.
		#     A flat health dial is not an opening; 40 Rage at the bell is.
		#   - bz_warcry was Deafening Cry (Battle Shout's cooldown) and is
		#     now OVERKILL. Batch AI's mechanical row assignment had put it
		#     in the same row as Battle Shout itself, and two exclusive
		#     nodes where one exists only to modify the other is a row with
		#     a dead option in it.
		#     (The batch doc calls this id `bz_deafening`. The live id has
		#     been `bz_warcry` since Batch AG, which the doc itself records
		#     — the doc's own rule, "every node keeps its existing id so
		#     saved trees migrate", is what settles it. Same for `bz_scar` /
		#     `bz_flurry` / `bz_momentum` / `bz_second_wind`, whose live ids
		#     are bz_frenzied_edge / bz_bloodlust_node / bz_thick_skin /
		#     bz_bloodied_hide. The doc's ids are the tidy version of names
		#     the nodes already carry.)
		#
		# TWO CROSS-ROW CONDITIONS (payload `condition` + has_node, Batch AI
		# §5) — Crushing Blows reads Savagery, Scar Tissue reads Unstoppable.
		# Neither needed a new field: both already read their counter as an
		# INDEX, so the conditional half simply adds a second point to it and
		# the read site knows 2 means "and the partner node too". A third,
		# Measured Rage's, could not be written that way and carries the one
		# flag field it needs.
		# --- Lane A: Bloodletting — wounds as an engine: keep bleed high,
		# or burst it. Bleedout is no longer just a meter reset. ---
		{"id": "bz_savagery", "name": "Savagery", "ranks": 1, "lane": "Bloodletting", "row": 1,
			"desc": "All bleed-building Berserker abilities build +{v} more Bleed.",
			"scale": {"step": 15},
			"payload": {"stat": {"bleed_bonus": 15}}},
		{"id": "bz_hemorrhage", "name": "Hemorrhage", "ranks": 1, "lane": "Bloodletting", "row": 2,
			"desc": "Enemies at {v} or more bloodloss are Crippled.",
			"scale": {"base": 60},
			"payload": {"stat": {"hemorrhage_ranks": 1}}},
		# The conditional half adds a SECOND point to the same counter, and
		# battle.gd reads 2 as "Savagery too" — 15 points of bloodloss per
		# step instead of 20. See the header note on cross-row conditions.
		{"id": "bz_crushing_blows", "name": "Crushing Blows", "ranks": 1, "lane": "Bloodletting", "row": 3,
			"desc": "For every 20 points of bloodloss on the enemy team, gain {v}% armor penetration. With Savagery, every 15 points instead.",
			"scale": {"step": 9},
			"payload": {"stat": {"crushing_blows_ranks": 1},
				"also": [
					{"condition": {"has_node": "bz_savagery"},
						"stat": {"crushing_blows_ranks": 1}},
				]}},
		# Re-spec (was Arterial Rhythm, +4 BD on Hack and Slash).
		{"id": "bz_arterial", "name": "Arterial Spray", "ranks": 1, "lane": "Bloodletting", "row": 4,
			"desc": "When an enemy bleeds out, {v}% of its blood buildup transfers to another living enemy.",
			"scale": {"step": 100},
			"payload": {"stat": {"arterial_ranks": 1}}},
		# Re-spec (was Gushing Wounds, a Savagery duplicate; same id, so
		# saved ranks carry — the cr_frostbite "Brittle Ice" trick). The
		# compounding ramp the archetype was missing.
		{"id": "bz_gushing", "name": "Scent of Blood", "ranks": 1, "lane": "Bloodletting", "row": 5,
			"desc": "+{v}% damage for each enemy that has bled out this battle.",
			"scale": {"step": 10},
			"payload": {"stat": {"scent_ranks": 1}}},
		{"id": "bz_bloodcraze", "name": "Bloodcraze", "ranks": 1, "lane": "Bloodletting", "row": 6,
			"desc": "When an enemy bleeds out, the Berserker heals {v}% of max HP.",
			"scale": {"step": 12},
			"payload": {"stat": {"bloodcraze": 1}}},
		# Re-spec (was Feast of Ruin, a Bloodcraze duplicate). The first
		# node that ties Bleed to Rage — those systems never touched.
		{"id": "bz_feast", "name": "Blood Tithe", "ranks": 1, "lane": "Bloodletting", "row": 7,
			"desc": "An enemy bleeding out grants the Berserker {v} Rage.",
			"scale": {"step": 45},
			"payload": {"stat": {"blood_tithe_ranks": 1}}},
		# --- Lane B: Fury — the risk dial: how far over the edge? ---
		{"id": "bz_unstoppable", "name": "Unstoppable", "ranks": 1, "lane": "Fury", "row": 1,
			"desc": "Blood Frenzy grants {v}% damage for every 5% of health missing (up from the base 2%).",
			"scale": {"base": 2.0, "step": 1.5},
			"payload": {"stat": {"bloodrage_step_bonus": 1.5}}},
		# The two numbers differ now, so they are written out rather than
		# rendered from one {v}.
		{"id": "bz_reckless", "name": "Reckless Fury", "ranks": 1, "lane": "Fury", "row": 2,
			"desc": "+20% damage dealt AND +15% damage taken.",
			"payload": {"stat": {"dmg_bonus": 0.20, "dmg_taken_bonus": 0.15}}},
		# Stays in Fury: a Rage-spent buff. Its bleed scaling is deliberate
		# cross-lane synergy — splashing into Bloodletting makes it better.
		#
		# Battle Shout also sits in the Berserker spec pool (Batch AH), so
		# this node GRANTS it when unowned and UPGRADES it when the hero
		# earned it from a pick — the AK pattern. `battle_shout_node` counts
		# which happened: 1 = granted here, 2 = upgraded. The `also` half
		# fires on BOTH paths (apply_payload runs it outside the branch), so
		# the upgrade path lands on 2 and battle.gd reads the one field.
		{"id": "bz_battle_shout", "name": "Battle Shout", "ranks": 1, "lane": "Fury", "row": 3,
			"desc": "New ability: Battle Shout — the whole party gains +12% damage, plus 1% for every 20 points of blood buildup on the enemy party, for 3 turns (15 Rage, 2cd). If Battle Shout was already earned, this UPGRADES it instead: +18% base and 4 turns.",
			"payload": {"new_ability": {"display_name": "Battle Shout", "cost": 15,
				"special": "battle_shout", "delay": 1.5, "anim": "attack03", "cooldown": 2,
				"perfect_id": "rage5", "perfect_text": "Also grants 5 Rage",
				"description": "A roar the whole party answers: +12%\ndamage, plus 1% per 20 blood buildup\non the enemy party. Lasts 3 turns."},
				"upgrade": [
					{"stat": {"battle_shout_node": 1}},
					{"ability": "Battle Shout", "set": {
						"description": "A roar the whole party answers: +18%\ndamage, plus 1% per 20 blood buildup\non the enemy party. Lasts 4 turns."}},
				],
				"also": [
					{"stat": {"battle_shout_node": 1}},
				]}},
		# Re-spec (was a flat +4% damage dial): same name, now conditional.
		{"id": "bz_deathwish", "name": "Deathwish", "ranks": 1, "lane": "Fury", "row": 4,
			"desc": "+{v}% damage dealt while below 35% health.",
			"scale": {"step": 25},
			"payload": {"stat": {"deathwish_ranks": 1}}},
		# Re-spec (was Frenzied Edge, +2% crit): deepens the Blood Frenzy
		# floor directly — the lane's signature. Second point = Unstoppable
		# was taken too, and the floor stops falling entirely.
		{"id": "bz_frenzied_edge", "name": "Scar Tissue", "ranks": 1, "lane": "Fury", "row": 5,
			"desc": "The Blood Frenzy floor holds 85% of your peak bonus (instead of 50%). With Unstoppable, it holds 100% and never falls at all.",
			"payload": {"stat": {"scar_tissue_ranks": 1},
				"also": [
					{"condition": {"has_node": "bz_unstoppable"},
						"stat": {"scar_tissue_ranks": 1}},
				]}},
		# Moved from Warpath: its exclusive partner lives here — the player
		# should see both doors in one column.
		#
		# The cross-row half is the one that could NOT be folded into a
		# counter: taking both nodes has to leave the damage-taken term at
		# exactly zero, not at some sum of -0.20 and +0.15. So the flag says
		# "cancelled" and the single read site zeroes the term outright —
		# which also means a later re-tune of either number cannot silently
		# break the promise.
		{"id": "bz_measured", "name": "Measured Rage", "ranks": 1, "lane": "Fury", "row": 6,
			"desc": "Take 20% less damage. With Reckless Fury, it cancels that node's +15% damage taken entirely instead — leaving the +20% dealt clean.",
			"payload": {"stat": {"dmg_taken_bonus": -0.20},
				"also": [
					{"condition": {"has_node": "bz_reckless"},
						"stat": {"measured_cancels_reckless": 1}},
				]}},
		{"id": "bz_enraged", "name": "Enraged", "ranks": 1, "lane": "Fury", "row": 7,
			"desc": "Dropping below 50% health grants a +{v}% damage buff for 5 turns (stacks up to 3 times).",
			"scale": {"step": 12},
			"payload": {"stat": {"enraged_ranks": 1}}},
		# --- Lane C: Warpath — momentum: keep swinging, or survive to
		# keep swinging. ---
		# Re-spec (was Vitality, +5% max HP; same id, so saved picks carry).
		{"id": "bz_vitality", "name": "First Blood", "ranks": 1, "lane": "Warpath", "row": 1,
			"desc": "The Berserker begins every battle with {v} Rage.",
			"scale": {"step": 40},
			"payload": {"stat": {"opening_rage": 40}}},
		# "Flurry" since 07-27 — the ability Bloodlust kept the name; the id
		# stays bz_bloodlust_node so saved ranks survive (the cr_frostbite →
		# "Brittle Ice" trick).
		{"id": "bz_bloodlust_node", "name": "Flurry", "ranks": 1, "lane": "Warpath", "row": 2,
			"desc": "Hack and Slash strikes 2 additional times (5 in total).",
			"payload": {"ability": "Hack and Slash", "add": {"multi_hits": 2}}},
		# Re-spec (was Thick Skin, flat -3% damage taken).
		{"id": "bz_thick_skin", "name": "Bloodied Momentum", "ranks": 1, "lane": "Warpath", "row": 3,
			"desc": "When an enemy is slain, the Berserker gains {v} Rage.",
			"scale": {"step": 40},
			"payload": {"stat": {"bloodied_momentum_ranks": 1}}},
		# The reliability half is bought PERMANENTLY here rather than earned
		# per cast (the Batch AG rule): `set` writes the ability's own
		# bleed_chance to 1.0, so no new field and no second read site — the
		# roll at the strike loop simply always passes.
		{"id": "bz_relentless", "name": "Relentless", "ranks": 1, "lane": "Warpath", "row": 4,
			"desc": "Hack and Slash costs {v} less Rage, and its bleed rolls ALWAYS land.",
			"scale": {"step": 15},
			"payload": {"ability": "Hack and Slash", "add": {"cost": -15},
				"set": {"bleed_chance": 1.0}}},
		# Re-spec (was Bloodied Hide, +3% armor): the near-death moment
		# becomes a whole turn instead of just a scare.
		{"id": "bz_bloodied_hide", "name": "Second Wind", "ranks": 1, "lane": "Warpath", "row": 5,
			"desc": "The first time you drop below 25% health each battle, immediately gain 60 Rage and clear every cooldown.",
			"payload": {"stat": {"second_wind": 1}}},
		{"id": "bz_unrelenting", "name": "Unrelenting Assault", "ranks": 1, "lane": "Warpath", "row": 6,
			"desc": "Dropping below 25% health grants +{v} Constitution for 3 turns (at most once every 5 turns).",
			"scale": {"step": 40},
			"payload": {"stat": {"unrelenting_ranks": 1}}},
		# Re-spec (was Deafening Cry, -1 turn on Battle Shout's cooldown;
		# same id, so saved picks carry). See the header note: a node whose
		# only job was to modify a node in its own exclusive row.
		# NOTE for the designer: the Sharpshooter's Precision lane already has
		# a talent called Overkill (a kill's overflow damage carries to
		# another enemy). Different trees, different ids, so nothing breaks —
		# but two nodes share a name in the glossary and the tooltips now.
		{"id": "bz_warcry", "name": "Overkill", "ranks": 1, "lane": "Warpath", "row": 7,
			"desc": "Killing an enemy clears the cooldowns of Hack and Slash and Wildstrikes.",
			"payload": {"stat": {"overkill_reset": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Re-spec (was a passive stat pile: +10 Bleed, Hemorrhage one step).
		{"id": "bz_exsanguinate", "name": "Exsanguination", "ranks": 1, "lane": "Bloodletting", "row": 8,
			"capstone": true,
			"desc": "Bleedout deals 35% of max HP (up from 20%), and the victim's full blood buildup surges to another living enemy — chaining across the field.",
			"payload": {"stat": {"exsanguination": 1}}},
		# Re-spec (was +12% HP / -5% damage taken) and moved from Warpath:
		# the risk capstone belongs to Fury.
		{"id": "bz_undying", "name": "Undying Rage", "ranks": 1, "lane": "Fury", "row": 8,
			"capstone": true,
			"desc": "While below 25% health the Berserker cannot die and deals +50% damage. The hit that would have killed him ends the rage at 1 HP (once per battle).",
			"payload": {"stat": {"undying_rage": 1}}},
		# Moved from Fury: chain-on-kill is momentum's payoff.
		#
		# Batch AJ: Rampage also sits in the Berserker spec pool, so the
		# capstone UPGRADES an already-earned copy instead of granting a
		# second one — the AK pattern, same as Battle Shout above. The
		# upgrade buys a second chain per turn; the grant path is capped at
		# one, which is the cap this batch introduces (the recast used to
		# chain without any bound at all).
		{"id": "bz_rampage", "name": "Rampage", "ranks": 1, "lane": "Warpath", "row": 8,
			"capstone": true,
			"desc": "New ability: Rampage — strike 3 times for damage and bloodloss; if the target dies, immediately recast on another enemy (40 Rage, 4.0 int, 4cd). If Rampage was already earned, this UPGRADES it instead: the free recast may chain TWICE per turn rather than once.",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 40,
				"damage": 20, "pressure": 10, "multi_hits": 3, "bleed_build": 10,
				"delay": 4.0, "anim": "attack01", "cooldown": 4,
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "",
				"description": "Three brutal strikes, each building\n10 bloodloss. If the target dies, Rampage\nimmediately recasts on another enemy."},
				"upgrade": [
					{"stat": {"rampage_upgraded": 1}},
					{"ability": "Rampage", "set": {
						"description": "Three brutal strikes, each building\n10 bloodloss. If the target dies, Rampage\nrecasts on another enemy — twice a turn."}},
				]}},
	],
	"swordmaster": [
		# Purpose-designed lanes (Batch F, 07-30); Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row; BATCH AK re-authored all
		# 24 nodes for that structure. Every id survives and re-specs in
		# place, so saved ranks migrate. Duelist and Poise were the same
		# lane twice (all parry and defence), while NOTHING in the tree
		# touched Break — the kit's engine since Batch E. So all parry
		# lives in Poise now, and Duelist became BREAKER: Break generation
		# and Broken-window exploitation.
		#
		# BATCH AK, the shape of the re-author. The rows are exclusive, so
		# a number that was one of three ranks is now the whole node and
		# has to be worth a row; every magnitude below is priced against
		# the two doors it closes, not against its own old rank 1. Three
		# nodes changed what they DO rather than how much:
		#   - Sunder Guard pointed at Shatterpoint, an ability §1 makes
		#     earnable, so it now points at the Guard Change §1 guarantees
		#     him — and pays extra if he draws Shatterpoint anyway.
		#   - Swordsmanship was a flat number he owned; it is now a spike
		#     he earns on the skill check.
		#   - Punishment and Off Balance used to be an exclusive pair in
		#     one lane. Split across rows 6 and 7 they are both reachable,
		#     and two "damage versus Broken" nodes stacking would be
		#     redundant rather than interesting — so the second one widens
		#     what counts as a window instead of adding to the same number.
		# --- Lane A: Blade — damage, crit, and the Aggressive stance. ---
		{"id": "sm_agg_stance", "name": "Aggressive Stance", "ranks": 1, "lane": "Blade", "row": 1,
			"desc": "The Aggressive stance grants an additional {v}% damage dealt.",
			"scale": {"step": 12},
			"payload": {"stat": {"seasoned_off_bonus": 0.12}}},
		# Batch AK: the grant is unchanged, but Lunge also sits in the spec
		# pool — so a hero who earned it there gets the node's UPGRADE
		# instead of a second copy of the same button.
		{"id": "sm_lunge", "name": "Lunge", "ranks": 1, "lane": "Blade", "row": 2,
			"desc": "New ability: Lunge — 35 damage; applies Exposed in Aggressive stance, Cripple in Defensive (25 Rage, 3.5 int). If Lunge was already earned, this UPGRADES it instead: 15 Rage, and it applies BOTH Exposed and Crippled whatever the guard.",
			"payload": {"new_ability": {"display_name": "Lunge", "cost": 25,
				"damage": 35, "pressure": 20, "delay": 3.5, "anim": "attack02",
				"resource_gain": 10,
				"perfect_id": "", "perfect_text": "Initiative cost 3.0 instead",
				"description": "A committed thrust. In Aggressive\nstance it Exposes the target; in\nDefensive it Cripples them (3 turns).\nBuilds 10 Rage."},
				"upgrade": [
					{"stat": {"lunge_upgraded": 1}},
					{"ability": "Lunge", "set": {"cost": 15,
						"description": "A committed thrust that Exposes AND\nCripples the target for 3 turns —\nwhatever guard he holds.\nBuilds 10 Rage."}},
				]}},
		# Re-spec (was Keen Edge, flat +2% crit; same id, so saved ranks
		# carry): keyed to the stance — Aggressive gets an identity past
		# its flat +15%.
		{"id": "sm_keen_edge", "name": "Killing Edge", "ranks": 1, "lane": "Blade", "row": 3,
			"desc": "+{v}% critical strike chance while in the Aggressive stance.",
			"scale": {"step": 15},
			"payload": {"stat": {"killing_edge_ranks": 1}}},
		{"id": "sm_precision", "name": "Precision Strikes", "ranks": 1, "lane": "Blade", "row": 4,
			"desc": "+{v}% critical strike chance against Dazed, Crippled, and Exposed targets.",
			"scale": {"step": 20},
			"payload": {"stat": {"precision_ranks": 1}}},
		# The Lunge half is an ability hook resolved at the CAST site, not
		# at apply time: Lunge is both this lane's row-2 node and a spec
		# pool entry, so a Lunge earned AFTER this node was taken has to
		# benefit too — which a stat written once at spawn could not do.
		{"id": "sm_seasoned_node", "name": "Seasoned Fighter", "ranks": 1, "lane": "Blade", "row": 5,
			"desc": "Overpower gains +{v}% critical strike chance — and Lunge too, if he has it.",
			"scale": {"step": 15},
			"payload": {"stat": {"blade_crit_ranks": 1}}},
		# Re-spec (was Momentum, a flat +3% damage dial): pairs with
		# Precision Strikes — one crits into debuffs, this damages into
		# them.
		{"id": "sm_momentum_sm", "name": "Overwhelm", "ranks": 1, "lane": "Blade", "row": 6,
			"desc": "+{v}% damage for every debuff on the target.",
			"scale": {"step": 8},
			"payload": {"stat": {"overwhelm_ranks": 1}}},
		# Re-spec (was Deep Thrust, +5 Pommel damage): pays for pressing
		# the button the whole spec turns on.
		{"id": "sm_deep_thrust", "name": "Tempo", "ranks": 1, "lane": "Blade", "row": 7,
			"desc": "Switching stance grants +{v}% damage for 1 turn.",
			"scale": {"step": 30},
			"payload": {"stat": {"tempo_ranks": 1}}},
		# --- Lane B: Poise — the defensive half, and ALL the parry
		# (Swordsmanship, Sword Mastery and Riposte move in from Duelist:
		# everything that answers being hit lives here). ---
		{"id": "sm_def_stance", "name": "Defensive Stance", "ranks": 1, "lane": "Poise", "row": 1,
			"desc": "The Defensive stance blocks an additional {v}% damage taken.",
			"scale": {"step": 12},
			"payload": {"stat": {"seasoned_def_bonus": 0.12}}},
		# Moved from Duelist: parry belongs with the guard.
		{"id": "sm_sword_mastery", "name": "Sword Mastery", "ranks": 1, "lane": "Poise", "row": 2,
			"desc": "+{v}% parry chance.",
			"scale": {"step": 12},
			"payload": {"stat": {"parry_bonus": 0.12}}},
		# Re-spec (was Footwork, +3% armor): Defensive stance comes to mean
		# "hard to Break", not just "takes less damage".
		{"id": "sm_footwork", "name": "Bracing", "ranks": 1, "lane": "Poise", "row": 3,
			"desc": "+{v} Constitution while in the Defensive stance.",
			"scale": {"step": 30},
			"payload": {"stat": {"bracing_ranks": 1}}},
		# Re-spec (Batch AK; the id and the Guard Change site both survive
		# from Batch AH, only the shape of the reward changed): a flat
		# parry number he owned becomes a spike he earns on the skill
		# check. Same total parry over a fight only if he keeps hitting
		# perfects — which is the point.
		# `swordsmanship_parry` is ADDITIVE on top of the perfect's own 10%,
		# which is what the scale's base/step spell out: 10 from the ability,
		# 15 from this node, 25 rendered. It is additive rather than a
		# replacement because the Rune of the Still Wrist pays into the same
		# field — a max() would leave that rune silently inert on its own.
		{"id": "sm_swordsmanship", "name": "Swordsmanship", "ranks": 1, "lane": "Poise", "row": 4,
			"desc": "A PERFECT Guard Change grants +{v}% parry chance for 2 turns, instead of the usual 10%.",
			"scale": {"base": 10, "step": 15},
			"payload": {"stat": {"swordsmanship_parry": 0.15}}},
		{"id": "sm_high_guard", "name": "High Guard", "ranks": 1, "lane": "Poise", "row": 5,
			"desc": "Take 40% less damage for 2 turns after parrying an attack.",
			"payload": {"stat": {"high_guard": 1}}},
		# Moved from Duelist: the parry payoff sits behind the parry lane.
		# Batch AK upgraded the counter from a basic Strike to a free
		# Overpower — it reuses Opportunist's recast machinery, so the two
		# parry answers in this tree finally speak the same language.
		{"id": "sm_riposte", "name": "Riposte", "ranks": 1, "lane": "Poise", "row": 6,
			"desc": "Counter Attack: immediately answer every parry with a free Overpower.",
			"payload": {"stat": {"counter_attacks": 1}}},
		# Re-spec (was Composure, flat -4% damage taken): the node that
		# makes a parry build viable — without it the whole cluster is dead
		# weight against archers and casters. Unchanged in Batch AK: it is
		# binary and already large.
		{"id": "sm_composure", "name": "Deflection", "ranks": 1, "lane": "Poise", "row": 7,
			"desc": "The Swordmaster's parry works against RANGED attacks too — arrows and spells alike.",
			"payload": {"stat": {"deflection": 1}}},
		# --- Lane C: Breaker (was Duelist) — fill their meter, then live
		# in the window. This lane did not exist before. ---
		# Re-spec (was Flourish, -5 Sweeping Strikes cost).
		{"id": "sm_flourish", "name": "Pressure Point", "ranks": 1, "lane": "Breaker", "row": 1,
			"desc": "Pommel Strike deals +{v} Break damage.",
			"scale": {"step": 30},
			"payload": {"stat": {"pressure_point_ranks": 1}}},
		# Re-spec (Batch AK; was "Shatterpoint +8 Break damage"). The old
		# node pointed at an ability he may never draw. This one points at
		# the ability the kit correction GUARANTEES him, and the `also`
		# half pays extra if he draws the other anyway.
		{"id": "sm_blade_dance", "name": "Sunder Guard", "ranks": 1, "lane": "Breaker", "row": 2,
			"desc": "Guard Change deals {v} Break damage to EVERY enemy (up from 15 to one). If he also owns Shatterpoint, that deals +40 Break damage as well.",
			"scale": {"step": 40},
			"payload": {"stat": {"guard_change_bd": 40},
				"also": [
					{"condition": {"owns_ability": "Shatterpoint"},
						"stat": {"sunder_guard_bd": 40}},
				]}},
		# Moved from Poise: debuff-fed armor is pressure bookkeeping.
		{"id": "sm_dominant", "name": "Dominant Presence", "ranks": 1, "lane": "Breaker", "row": 3,
			"desc": "Armor value is increased by {v}% for every debuff the Swordmaster has applied this battle.",
			"scale": {"step": 15},
			"payload": {"stat": {"dominant_ranks": 1}}},
		# Moved from Duelist. Batch AK widened the trigger: a parried blow
		# is as much an opening as a whiffed one, and it makes the node
		# live in the Defensive guard the rest of the tree keeps selling.
		{"id": "sm_opportunist", "name": "Opportunist", "ranks": 1, "lane": "Breaker", "row": 4,
			"desc": "When an enemy attack MISSES the Swordmaster or is PARRIED, he counter attacks with Overpower (free).",
			"payload": {"stat": {"opportunist": 1}}},
		# Re-spec (was Perfect Form, a Swordsmanship duplicate): closes the
		# loop — the Break refunds Rage toward the Overpower you want to
		# spend inside the window you just opened.
		{"id": "sm_perfect_form", "name": "No Quarter", "ranks": 1, "lane": "Breaker", "row": 5,
			"desc": "Breaking an enemy grants the Swordmaster {v} Rage.",
			"scale": {"step": 45},
			"payload": {"stat": {"no_quarter_ranks": 1}}},
		# Re-spec (was +6 Overpower damage). No longer exclusive with Off
		# Balance — they sit in different rows now, and taking both widens
		# the window instead of doubling the number.
		{"id": "sm_punish", "name": "Punishment", "ranks": 1, "lane": "Breaker", "row": 6,
			"desc": "Overpower deals +{v}% damage against Broken targets.",
			"scale": {"step": 60},
			"payload": {"stat": {"punishment_ranks": 1}}},
		# Re-spec (was Guarded Frame, +5% max health): the broad half. The
		# `also` half is the cross-row condition — with Punishment taken it
		# widens what counts as a window rather than stacking onto the same
		# "versus Broken" number.
		{"id": "sm_guarded", "name": "Off Balance", "ranks": 1, "lane": "Breaker", "row": 7,
			"desc": "All the Swordmaster's damage is increased by {v}% against Broken targets. If Punishment was taken, it applies against Exposed and Crippled targets too.",
			"scale": {"step": 20},
			"payload": {"stat": {"off_balance_ranks": 1},
				"also": [
					{"condition": {"has_node": "sm_punish"},
						"stat": {"off_balance_wide": 1}},
				]}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Batch AK: Execute also sits in the spec pool, so a hero who
		# earned it there gets the UPGRADE instead of a second copy.
		{"id": "sm_execute", "name": "Execute", "ranks": 1, "lane": "Blade", "row": 8,
			"capstone": true,
			"desc": "New ability: Execute — 55 damage / 50 BD; usable against targets below 20% health or Broken; a perfect guarantees a crit (30 Rage, 2.0 int, 3cd). If Execute was already earned, this UPGRADES it instead: the threshold rises to 35% health, and it costs NO Rage against a Broken target.",
			"payload": {"new_ability": {"display_name": "Execute", "cost": 30,
				"damage": 55, "pressure": 50, "delay": 2.0, "anim": "attack03",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "Guaranteed critical strike",
				"description": "End them. Only usable against targets\nbelow 20% health — or Broken ones."},
				"upgrade": [
					{"stat": {"execute_upgraded": 1}},
					{"ability": "Execute", "set": {
						"description": "End them. Usable against targets below\n35% health — or Broken ones, and\nagainst a Broken target it is FREE."}},
				]}},
		# Re-spec (was +5% parry / -5% damage taken): the Defensive stance
		# becomes a genuine wall against melee — and every parry a stun.
		{"id": "sm_untouchable", "name": "Untouchable", "ranks": 1, "lane": "Poise", "row": 8,
			"capstone": true,
			"desc": "While in the Defensive stance, parried attacks deal NO damage instead of 25%, and every parry is answered with a free Pommel Strike.",
			"payload": {"stat": {"untouchable": 1}}},
		# Re-spec (was En Garde, +4% crit / +4% parry): the lane's thesis
		# as a win condition — they never get their guard back.
		{"id": "sm_en_garde", "name": "Guard Breaker", "ranks": 1, "lane": "Breaker", "row": 8,
			"capstone": true,
			"desc": "When a Broken enemy recovers, its Break meter refills to 50 instead of resetting to 0.",
			"payload": {"stat": {"guard_breaker": 1}}},
	],
	"warden": [
		# Purpose-designed lanes (Batch H, 07-30). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. Every id
		# survives and re-specs in place, so saved ranks migrate (no new
		# rank cap is below its old one — nobody gets a refund). Half the
		# old tree was damage dials on a 75-Attack tank, so the offensive
		# payloads convert into currencies he actually spends: mitigation,
		# Break pressure, threat, and party protection.
		#
		# BATCH AL (08-06) re-authored all 24 for row exclusivity, the same
		# pass AK and AJ ran on the Swordmaster and the Berserker. A node is
		# a ROW now, not one of three ranks, so it is priced against the two
		# doors it closes — roughly 3-4x the old rank-1 values.
		#
		# ROWS ARE THEMED, not merely exclusive: 1 who your defence pays /
		# 2 how much you hold / 3 attrition / 4 what compounds / 5 active
		# defence / 6 the engine running / 7 the last stand / 8 capstone.
		# Row 1 is the model for the whole tree — one trigger (a Block, a
		# taunt), three beneficiaries: him, them, the party.
		#
		# TWO RE-SPECS IN PLACE, both for the same reason: AH moved the
		# ability they modified into the earnable spec pool, so each was
		# dead on a Warden who never drew it. wd_stomp_drill (War Stomp's
		# refuel) and wd_bannerman (Interpose's charges) now key to
		# something he always has, and the old ability rides on top as an
		# `owns_ability` rider.
		#
		# ONE CROSS-ROW CONDITION: Spite and Bruising Guard used to be an
		# exclusive fork (reflect the damage, or convert the blocks into
		# Break). Split across rows 5 and 6 both are reachable, so the
		# second one welds the pair into one Break engine — `spite_break`.
		# --- Lane A: Plate — mitigation and the block payoffs.
		# Everything that answers being hit. ---
		{"id": "wd_unkillable", "name": "Unkillable", "ranks": 1, "lane": "Plate", "row": 1,
			"desc": "Every time you Block an attack, heal for {v}% of the health you brought into the battle.",
			"scale": {"step": 8},
			"payload": {"stat": {"unkillable_ranks": 1}}},
		{"id": "wd_toughness", "name": "Toughness", "ranks": 1, "lane": "Plate", "row": 2,
			"desc": "Constitution is increased by {v}% of maximum HP.",
			"scale": {"step": 25},
			"payload": {"stat": {"toughness_ranks": 1}}},
		{"id": "wd_endurance", "name": "Endurance", "ranks": 1, "lane": "Plate", "row": 3,
			"desc": "+{v}% armor for every turn the Warden is not healed by an external source (resets when healed, capped at +75%).",
			"scale": {"step": 3},
			"payload": {"stat": {"endurance_ranks": 1}}},
		{"id": "wd_tenacity", "name": "Tenacity", "ranks": 1, "lane": "Plate", "row": 4,
			"desc": "Every attack Blocked by Heavy Plating increases maximum health by 15 for the rest of the battle.",
			"payload": {"stat": {"tenacity": 1}}},
		# Re-spec (Batch AB, same id so saved ranks migrate and nobody is
		# refunded): Shieldwall stopped granting charges, so "+1 charge/rank"
		# stopped meaning anything. The stance's length is the dial now.
		{"id": "wd_shieldwall", "name": "Shield Mastery", "ranks": 1, "lane": "Plate", "row": 5,
			"desc": "Shieldwall's stance holds {v} turns longer — 4 turns, or 5 on a perfect cast.",
			"scale": {"step": 2},
			"payload": {"stat": {"shield_mastery_ranks": 1}}},
		# Re-spec (was Layered Plating, a flat armor dial; same id, so saved
		# ranks carry): the lane's signature — tightens the cadence of the
		# Batch G pity ramp, so the cap arrives in two unblocked hits instead
		# of five and every on-Block talent fires far more often.
		{"id": "wd_plating", "name": "Plate Discipline", "ranks": 1, "lane": "Plate", "row": 6,
			"desc": "Heavy Plating's climbing Block bonus grows +{v}% faster per unblocked hit (8% becomes 20%, so it caps in two hits rather than five).",
			"scale": {"step": 12},
			"payload": {"stat": {"plate_discipline_ranks": 1}}},
		# Re-spec (was Immovable, a flat damage-taken dial — that NAME moved
		# to the Plate capstone): a Broken unit cannot Block at all, so
		# getting Broken switches his identity off. Blocking holds that off.
		{"id": "wd_immovable", "name": "Battered Not Broken", "ranks": 1, "lane": "Plate", "row": 7,
			"desc": "Blocking an attack removes {v} Break from the Warden's own meter.",
			"scale": {"step": 30},
			"payload": {"stat": {"battered_ranks": 1}}},
		# --- Lane B: Threat — he wants to be hit. This lane is what
		# happens to whoever obliges. ---
		{"id": "wd_ricochet", "name": "Richocet", "ranks": 1, "lane": "Threat", "row": 1,
			"desc": "Blocking an attack has a {v}% chance to Stun the attacker.",
			"scale": {"step": 35},
			"payload": {"stat": {"ricochet_ranks": 1}}},
		# Re-spec (was Taunt Master, -1 Mocking cooldown; ranks 1 → 2): the
		# taunt engine widens — more of the room swings at the wall. The
		# base ability already drags in one extra foe; this is on top.
		{"id": "wd_taunt_master", "name": "Provoke", "ranks": 1, "lane": "Threat", "row": 2,
			"desc": "Mocking Blow taunts {v} additional foes.",
			"scale": {"step": 2},
			"payload": {"stat": {"provoke_ranks": 1}}},
		# Re-spec IN MEANING (same id, same name, same idea — adversity
		# makes him stronger — converted into the currency a tank banks):
		# was +5%/rank DAMAGE per debuff, ~14 damage at full stack on a
		# 75-Attack character.
		{"id": "wd_iron_will", "name": "Iron Will", "ranks": 1, "lane": "Threat", "row": 3,
			"desc": "The Warden takes {v}% less damage for every debuff currently on him.",
			"scale": {"step": 12},
			"payload": {"stat": {"iron_will_ranks": 1}}},
		{"id": "wd_sundering", "name": "Sundering", "ranks": 1, "lane": "Threat", "row": 4,
			"desc": "Crushing Blow deals {v}% of its Break damage to enemies Adjacent to the target (dead neighbors block the splash on their side).",
			"scale": {"step": 100},
			"payload": {"stat": {"sundering_ranks": 1}}},
		# Re-spec (was Spiked Bulwark, a Richocet deepener). Used to be an
		# EXCLUSIVE fork with Bruising Guard; Batch AL put them in different
		# rows, so both are reachable and Bruising Guard's `also` half welds
		# them together instead (see there).
		{"id": "wd_spiked", "name": "Spite", "ranks": 1, "lane": "Threat", "row": 5,
			"desc": "Attackers that damage the Warden take {v}% of that damage back.",
			"scale": {"step": 30},
			"payload": {"stat": {"spite_ranks": 1}}},
		# Re-spec (was Shattering Blow, +5 Crushing damage): the more
		# interesting half of the old fork — on a character who blocks
		# constantly and is attacked more than anyone, this quietly makes
		# him a Break engine for the whole party.
		#
		# The cross-row half needed its OWN field rather than a second point
		# on the counter: `bruising_ranks` sets a flat Break number on the
		# block, while the rider adds Break to a completely different event
		# (Spite's reflect, at the damage site). Two events, two fields.
		{"id": "wd_shatter_guard", "name": "Bruising Guard", "ranks": 1, "lane": "Threat", "row": 6,
			"desc": "Blocking an attack deals {v} Break damage to the attacker. If Spite was taken, its reflected damage builds Break equal to 50% of its value as well.",
			"scale": {"step": 30},
			"payload": {"stat": {"bruising_ranks": 1},
				"also": [
					{"condition": {"has_node": "wd_spiked"},
						"stat": {"spite_break": 1}},
				]}},
		# Re-spec (same name, was a flat +3% damage dial): the damage he
		# does keep is aimed at whoever he's holding.
		{"id": "wd_grudge", "name": "Grudge", "ranks": 1, "lane": "Threat", "row": 7,
			"desc": "+{v}% damage against enemies currently taunted by the Warden.",
			"scale": {"step": 25},
			"payload": {"stat": {"grudge_ranks": 1}}},
		# --- Lane C: Banner — the half that protects other people. ---
		# Batch AL made the Empower CERTAIN. Mocking Blow is free and sits on
		# his rotation constantly, so a chance roll there is noise rather
		# than tension — you cannot plan around it and you barely notice it
		# fire. No {v}: the node has no number left to render.
		{"id": "wd_tank_spank", "name": "Tank and Spank", "ranks": 1, "lane": "Banner", "row": 1,
			"desc": "Mocking Blow ALWAYS Empowers a random ally (2 turns).",
			"payload": {"stat": {"tank_spank_ranks": 1}}},
		{"id": "wd_rally", "name": "Rally", "ranks": 1, "lane": "Banner", "row": 2,
			"desc": "Every attack Blocked by Heavy Plating grants the party +30% healing received for 3 turns.",
			"payload": {"stat": {"rally": 1}}},
		# RE-SPEC (Batch AL; was Rallying Stomp, "War Stomp restores +5% more
		# resource" — and before that Stomp Drill, -5 cost). Same id, so
		# saved picks migrate. Batch AH made War Stomp EARNABLE rather than
		# part of the opening kit, which left this node dead on a Warden who
		# never drew it. The party refuel is Banner's real cargo, so it now
		# happens on its own, at his turn, and War Stomp deepens it if he
		# has it. `owns_ability` is the honest instrument here because NO
		# node grants War Stomp — the only question is whether the kit holds
		# it (the AK correction).
		{"id": "wd_stomp_drill", "name": "Rallying Cry", "ranks": 1, "lane": "Banner", "row": 3,
			"desc": "At the start of each of the Warden's turns, every ally regains {v}% of their maximum resource. If he owns War Stomp, it restores 20% more resource as well.",
			"scale": {"step": 4},
			"payload": {"stat": {"rallying_cry": 4},
				"also": [
					{"condition": {"owns_ability": "War Stomp"},
						"stat": {"rallying_stomp_ranks": 1}},
				]}},
		{"id": "wd_elem_weak", "name": "Elemental Weakness", "ranks": 1, "lane": "Banner", "row": 4,
			"desc": "Crushing Blow also reduces all elemental resistances of the target by {v}% (3 turns).",
			"scale": {"step": 20},
			"payload": {"stat": {"elem_weak_ranks": 1}}},
		# RE-SPEC (Batch AL; was "Interpose grants each ally +1 shield
		# charge", and before that Bannerman, a flat max-HP dial). Same id,
		# same fix as Rallying Cry above: AH made Interpose earnable, so the
		# node keys to SHIELDWALL — which he has always had since Batch G
		# promoted it into the base kit — and Interpose rides on top.
		#
		# The ally grant rides the same Heavy Plating slice of the block roll
		# that Shieldwall's own stance does, so the cover is real Block, not
		# a separate mitigation site.
		{"id": "wd_bannerman", "name": "Bulwark Line", "ranks": 1, "lane": "Banner", "row": 5,
			"desc": "Shieldwall also grants every ally +{v}% Block chance for its duration. If he owns Interpose, each ally gains 1 additional shield charge from it as well.",
			"scale": {"step": 10},
			"payload": {"stat": {"bulwark_ally_block": 10},
				"also": [
					{"condition": {"owns_ability": "Interpose"},
						"stat": {"bulwark_line_ranks": 1}},
				]}},
		# Re-spec (was Fortress, a flat max-HP dial): conditional on the
		# Warden being healthy — the party's mitigation depends on keeping
		# him standing, so healing him is protecting everyone.
		{"id": "wd_fortress", "name": "Shared Vigil", "ranks": 1, "lane": "Banner", "row": 6,
			"desc": "Allies take {v}% less damage while the Warden is above 50% health.",
			"scale": {"step": 12},
			"payload": {"stat": {"shared_vigil_ranks": 1}}},
		# Re-spec (was Veteran's Will, an Iron Will deepener): the lane's
		# thesis in one node — he eats what would have killed you.
		{"id": "wd_veteran", "name": "Steadfast", "ranks": 1, "lane": "Banner", "row": 7,
			"desc": "When damage would drop an ally below 20% health, the Warden absorbs {v}% of it instead.",
			"scale": {"step": 60},
			"payload": {"stat": {"steadfast_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Re-spec (was The Mountain, a stat pile; the name comes from the
		# old wd_immovable filler): being Broken is the one thing that
		# turns a block build off — this removes it. Precedent: the
		# Devout's Bulwark of Fortitude.
		{"id": "wd_mountain", "name": "Immovable", "ranks": 1, "lane": "Plate", "row": 8,
			"capstone": true,
			"desc": "The Warden cannot be Broken, and his Block chance is increased by 20%.",
			"payload": {"stat": {"immovable": 1, "block_chance": 0.20}}},
		# Re-spec (was Avenger, a Richocet/Sundering stat pile). Once per
		# TURN, not per block — at his block rate against a full field,
		# per-block would be absurd.
		{"id": "wd_avenger", "name": "Vengeful Guardian", "ranks": 1, "lane": "Threat", "row": 8,
			"capstone": true,
			"desc": "The first attack the Warden Blocks each turn is answered with a free Crushing Blow.",
			"payload": {"stat": {"vengeful_guardian": 1}}},
		# Batch AL: Hold the Line also sits in the Warden spec pool (Batch
		# AH), so the capstone GRANTS it when unowned and UPGRADES it when
		# the hero already earned it from a pick — the AK pattern, exactly
		# as Battle Shout and Rampage do in the Berserker tree. A capstone
		# that hands you a second copy of an ability you already cast is the
		# worst pick in the row; this makes drawing it early a reason to
		# take the capstone rather than a reason to avoid it.
		{"id": "wd_hold_line", "name": "Hold the Line", "ranks": 1, "lane": "Banner", "row": 8,
			"capstone": true,
			"desc": "New ability: Hold the Line — the party takes 50% less Break damage for 2 turns and cannot die for a turn (30 Rage, 3.0 int, 6cd). If Hold the Line was already earned, this UPGRADES it instead: 80% less Break damage, and the no-death window lasts 2 turns.",
			"payload": {"new_ability": {"display_name": "Hold the Line", "cost": 30,
				"special": "hold_the_line", "delay": 3.0, "anim": "attack03",
				"cooldown": 6,
				"perfect_id": "", "perfect_text": "Refunds 5 Rage",
				"description": "Embolden the party: 50% less Break\ndamage for 2 turns, and no one can die\nfor a turn."},
				"upgrade": [
					{"stat": {"hold_line_upgraded": 1}},
					{"ability": "Hold the Line", "set": {
						"description": "Embolden the party: 80% less Break\ndamage for 2 turns, and no one can die\nfor two turns."}},
				]}},
	],
	"pyromancer": [
		# Purpose-designed lanes (Batch N, 07-31). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. Every id
		# survives and re-specs in place, so saved ranks migrate. The old
		# conversion named its lanes after kit pieces; these are named for
		# the burn loop itself: KINDLING builds the fire, INFERNO profits
		# while it burns, DETONATION cashes it in — on one target, hard.
		# --- Lane A: Kindling — spreading the fire. ---
		{"id": "py_accelerant", "name": "Accelerant", "ranks": 1, "lane": "Kindling", "row": 1,
			"desc": "Your Burn ticks deal +{v}% of Attack (on top of the base 6%).",
			"scale": {"step": 1},
			"payload": {"stat": {"accelerant_ranks": 1}}},
		{"id": "py_explosive", "name": "Explosive Force", "ranks": 1, "lane": "Kindling", "row": 2,
			"desc": "Critical hits with fire abilities extend the target's Burn by {v} turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"explosive_ranks": 1}}},
		{"id": "py_invigorating", "name": "Invigorating Ashes", "ranks": 1, "lane": "Kindling", "row": 3,
			"desc": "Every Burn tick has a {v}% chance to restore 2% of the Pyromancer's max Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"invigorating_ranks": 1}}},
		{"id": "py_flame_shield", "name": "Flame Shield", "ranks": 1, "lane": "Kindling", "row": 4,
			"desc": "New ability: Flame Shield — take 50% less damage for 2 turns and attackers are set Burning for 3 turns (15 Mana, 1.5 int, 2cd).",
			"payload": {"new_ability": {"display_name": "Flame Shield", "cost": 15,
				"special": "flame_shield", "delay": 1.5, "anim": "attack03", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Also triggers a Burn tick on every burning enemy",
				"description": "A barrier of living flame: take 50%\nless damage for 2 turns, and whoever\nstrikes the Pyromancer is set Burning\n(3 turns)."}}},
		# Conflagration: the build button builds harder.
		{"id": "py_arson", "name": "Conflagration", "ranks": 1, "lane": "Kindling", "row": 5,
			"desc": "Flamewave applies +{v} turn(s) of Burn (fresh fires and extensions alike).",
			"scale": {"step": 1},
			"payload": {"stat": {"conflagration_ranks": 1}}},
		# Cinder Trail: the free basic becomes a spreader — it matters most
		# in the opening turns before Flamewave is up.
		{"id": "py_kindling", "name": "Cinder Trail", "ranks": 1, "lane": "Kindling", "row": 6,
			"desc": "Fireball also applies {v} turn(s) of Burn to one random other enemy.",
			"scale": {"step": 1},
			"payload": {"stat": {"cinder_trail_ranks": 1}}},
		{"id": "py_spreading", "name": "Ember Wind", "ranks": 1, "lane": "Kindling", "row": 7,
			"desc": "When an enemy dies Burning, its remaining Burn transfers to a random living enemy.",
			"payload": {"stat": {"ember_wind": 1}}},
		# --- Lane B: Inferno — profiting while it burns. ---
		{"id": "py_pyromaniac", "name": "Pyromaniac", "ranks": 1, "lane": "Inferno", "row": 1,
			"desc": "Inferno Master grants +0.2% damage per turn of Burn on the enemy team, and its cap rises to match.",
			"payload": {"stat": {"pyromaniac_ranks": 1}}},
		{"id": "py_molten", "name": "Molten Core", "ranks": 1, "lane": "Inferno", "row": 2,
			"desc": "Take {v}% less damage from burning enemies.",
			"scale": {"step": 2},
			"payload": {"stat": {"molten_ranks": 1}}},
		{"id": "py_melt", "name": "Melt Armor", "ranks": 1, "lane": "Inferno", "row": 3,
			"desc": "Every Burn tick melts the victim's armor by {v}% for the rest of the battle.",
			"scale": {"step": 1},
			"payload": {"stat": {"melt_ranks": 1}}},
		# The exclusive pair: the same burning field read two ways — as a
		# damage multiplier, or as a smother on the enemy's output.
		{"id": "py_firebrand", "name": "Heat Haze", "ranks": 1, "lane": "Inferno", "row": 4,
			"desc": "Inferno Master's cap rises by 10%.",
			"payload": {"stat": {"heat_haze_ranks": 1}}},
		{"id": "py_cauterize", "name": "Scorched Earth", "ranks": 1, "lane": "Inferno", "row": 5,
			"desc": "Burning enemies deal {v}% less damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"scorched_ranks": 1}}},
		{"id": "py_ashes", "name": "Ashes of Al'ar", "ranks": 1, "lane": "Inferno", "row": 6,
			"desc": "Upon death: {v}% chance to revive with 25% health (once per battle).",
			"scale": {"step": 11},
			"payload": {"stat": {"ashes_ranks": 1}}},
		{"id": "py_undying_flame", "name": "Living Flame", "ranks": 1, "lane": "Inferno", "row": 7,
			"desc": "While 3 or more enemies burn, regain {v}% of max Mana each turn.",
			"scale": {"step": 3},
			"payload": {"stat": {"living_flame_ranks": 1}}},
		# --- Lane C: Detonation — cashing it in. Every node is a different
		# answer to "how do I get more out of one Detonation": chain it,
		# repeat it, reset it, or guarantee the crit. ---
		{"id": "py_supernova", "name": "Super Nova", "ranks": 1, "lane": "Detonation", "row": 1,
			"desc": "Detonation gains +{v}% critical strike chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"supernova_ranks": 1}}},
		{"id": "py_implosion", "name": "Implosion", "ranks": 1, "lane": "Detonation", "row": 2,
			"desc": "Detonation has a {v}% chance to strike twice.",
			"scale": {"step": 3},
			"payload": {"stat": {"implosion_ranks": 1}}},
		{"id": "py_seeding", "name": "Seeding Embers", "ranks": 1, "lane": "Detonation", "row": 3,
			"desc": "When an enemy dies while Burning, gain {v}% damage per Burn turn it had left, for your next turn.",
			"scale": {"step": 1},
			"payload": {"stat": {"seeding_ranks": 1}}},
		# Chain Reaction: the lane's only field-wide effect, and it costs
		# three ranks in a tier-1 slot to get there.
		{"id": "py_warm_glow", "name": "Chain Reaction", "ranks": 1, "lane": "Detonation", "row": 4,
			"desc": "Detonation splashes {v}% of its damage to every other burning enemy.",
			"scale": {"step": 20},
			"payload": {"stat": {"chain_reaction_ranks": 1}}},
		{"id": "py_rekindle", "name": "Fuse", "ranks": 1, "lane": "Detonation", "row": 5,
			"desc": "Detonation has a {v}% chance to reset its own cooldown.",
			"scale": {"step": 15},
			"payload": {"stat": {"fuse_ranks": 1}}},
		{"id": "py_shockwave", "name": "Blast Radius", "ranks": 1, "lane": "Detonation", "row": 6,
			"desc": "Detonation consumes {v}% more of the target's remaining Burn damage.",
			"scale": {"step": 25},
			"payload": {"stat": {"blast_radius_ranks": 1}}},
		# White Heat: the guaranteed crit, gated behind setup — you must
		# have GROWN the burn first. Stacks naturally with Super Nova,
		# which covers the targets that haven't been stacked that high.
		{"id": "py_focused", "name": "White Heat", "ranks": 1, "lane": "Detonation", "row": 7,
			"desc": "Detonation always critically strikes a target with 5+ turns of Burn (4+ at rank 2).",
			"payload": {"stat": {"white_heat_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "py_firestorm", "name": "Firestorm", "ranks": 1, "lane": "Kindling", "row": 8,
			"capstone": true,
			"desc": "New ability: Firestorm — rain fire on 6-8 random enemies for 12% of Attack each, applying Burn (30 Mana, 3.5 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Firestorm", "cost": 30,
				"dmg_type": "fire", "damage": 12, "pressure": 8, "random_hits": 6,
				"perfect_extra_hit": false, "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"applies_status": {"id": "burn", "turns": 2},
				"perfect_id": "", "perfect_text": "Every enemy takes an even share.",
				"description": "The sky ignites: 6-8 bolts rake random\nenemies for 12% of Attack, each one\nsetting its victim Burning (2 turns\nper bolt — repeats stack)."}}},
		{"id": "py_rebirth", "name": "Avatar of Flame", "ranks": 1, "lane": "Inferno", "row": 8,
			"capstone": true,
			"desc": "Inferno Master has no cap — every turn of Burn on the enemy team grants its full bonus — and the Pyromancer's fire damage ignores enemy fire resistance.",
			"payload": {"stat": {"avatar_flame": 1}}},
		# Cataclysm: the "detonate them all" fantasy as something earned —
		# and it still rewards a good first target, since the chain walks
		# down from there.
		{"id": "py_hellfire", "name": "Cataclysm", "ranks": 1, "lane": "Detonation", "row": 8,
			"capstone": true,
			"desc": "After Detonation resolves, it fires again at the burning enemy with the most Burn remaining for 60% of its damage, chaining up to 3 additional times (each 60% of the one before).",
			"payload": {"stat": {"cataclysm": 1}}},
	],
	"cryomancer": [
		# Purpose-designed lanes (Batch O, 07-31). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. Every id
		# survives and re-specs in place, so saved ranks migrate. With
		# Permafrost v2 the stacks stop expiring, and the lanes read clean:
		# DEEP FREEZE reaches and holds Frozen, SHATTERPOINT is the burst
		# payoff, WINTER is the field aura that profits from every stack.
		# --- Lane A: Deep Freeze — reaching and holding Frozen. ---
		{"id": "cr_frostbite", "name": "Brittle Ice", "ranks": 1, "lane": "Deep Freeze", "row": 1,
			"desc": "Frozen enemies are {v}% more likely to be struck by a critical hit (party-wide).",
			"scale": {"step": 2},
			"payload": {"stat": {"frostbite_ranks": 1}}},
		{"id": "cr_frigid", "name": "Frigid Grip", "ranks": 1, "lane": "Deep Freeze", "row": 2,
			"desc": "Every stack of Chilled slows {v}% harder.",
			"scale": {"step": 3},
			"payload": {"stat": {"frigid_ranks": 1}}},
		{"id": "cr_whiteout", "name": "Whiteout", "ranks": 1, "lane": "Deep Freeze", "row": 3,
			"desc": "Enemies hit by Blizzard have a {v}% chance to become Dazed (2 turns).",
			"scale": {"step": 15},
			"payload": {"stat": {"whiteout_ranks": 1}}},
		# Re-spec (was a Rime rider, which sat in the wrong lane): the freeze
		# opens a window, and his next strike takes it.
		{"id": "cr_freezing", "name": "Freezing Advance", "ranks": 1, "lane": "Deep Freeze", "row": 4,
			"desc": "When an enemy Freezes, the Cryomancer's next attack against it deals +{v}% damage.",
			"scale": {"step": 10},
			"payload": {"stat": {"freezing_ranks": 1}}},
		# Re-spec (was a flat Frostbolt damage dial). The exclusive pair:
		# depth or breadth — hold ONE enemy under far longer, or turn every
		# freeze into a field-wide chill that cascades toward the next one.
		{"id": "cr_cold_snap", "name": "Cold Snap", "ranks": 1, "lane": "Deep Freeze", "row": 5,
			"desc": "Frozen lasts {v} additional turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"cold_snap_ranks": 1}}},
		# Re-spec (was a flat +damage dial, exclusive with Numbing Veil).
		{"id": "cr_bitter", "name": "Bitter Cold", "ranks": 1, "lane": "Deep Freeze", "row": 6,
			"desc": "Freezing an enemy applies {v} stack(s) of Chilled to every other enemy.",
			"scale": {"step": 1},
			"payload": {"stat": {"bitter_cold_ranks": 1}}},
		# Re-spec (was a Blizzard Mana discount): the engine pays for itself.
		{"id": "cr_glacial", "name": "Glacial Economy", "ranks": 1, "lane": "Deep Freeze", "row": 7,
			"desc": "Freezing an enemy restores {v}% of the Cryomancer's maximum Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"glacial_ranks": 1}}},
		# --- Lane B: Shatterpoint — the burst payoff. ---
		{"id": "cr_piercing", "name": "Piercing Ice", "ranks": 1, "lane": "Shatterpoint", "row": 1,
			"desc": "Ice Lance gains {v}% critical strike damage.",
			"scale": {"step": 10},
			"payload": {"stat": {"piercing_ice_ranks": 1}}},
		{"id": "cr_emp_frostbolt", "name": "Empowered Frostbolt", "ranks": 1, "lane": "Shatterpoint", "row": 2,
			"desc": "Frostbolt deals an extra {v}% of Attack.",
			"scale": {"step": 2},
			"payload": {"stat": {"emp_frostbolt_ranks": 1}}},
		{"id": "cr_icy_veins", "name": "Icy Veins", "ranks": 1, "lane": "Shatterpoint", "row": 3,
			"desc": "Killing an enemy with Ice Lance empowers your next Ice Lance by {v}%.",
			"scale": {"step": 15},
			"payload": {"stat": {"icy_veins_ranks": 1}}},
		# Re-spec (was an extra RANDOM target — a talent that fought the
		# spec's own win condition): now the fourth-stack node, a 60% shot
		# at rank 3 to Freeze straight out of a single Razor Ice.
		{"id": "cr_splinter", "name": "Splintering Shards", "ranks": 1, "lane": "Shatterpoint", "row": 4,
			"desc": "Razor Ice has a {v}% chance to strike a fourth time.",
			"scale": {"step": 20},
			"payload": {"stat": {"splinter_ranks": 1}}},
		{"id": "cr_lance_focus", "name": "Lance Focus", "ranks": 1, "lane": "Shatterpoint", "row": 5,
			"desc": "Ice Lance costs {v} less Mana.",
			"scale": {"step": 5},
			"payload": {"ability": "Ice Lance", "add": {"cost": -5}}},
		# Re-spec (was a flat crit dial): deepens the Lance's new per-stack
		# scaling instead.
		{"id": "cr_crystal", "name": "Crystal Edge", "ranks": 1, "lane": "Shatterpoint", "row": 6,
			"desc": "Ice Lance deals an extra {v}% of Attack per Chilled stack (on top of the base 10%).",
			"scale": {"step": 5},
			"payload": {"stat": {"crystal_edge_ranks": 1}}},
		# Re-spec (was a Razor Ice damage dial): the payoff hit feeds the
		# next build.
		{"id": "cr_razor_hone", "name": "Honed Shards", "ranks": 1, "lane": "Shatterpoint", "row": 7,
			"desc": "Critical hits with Ice Lance apply {v} stack(s) of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"honed_shards_ranks": 1}}},
		# --- Lane C: Winter — the field aura. ---
		{"id": "cr_hungering", "name": "Hungering Cold", "ranks": 1, "lane": "Winter", "row": 1,
			"desc": "Chilled enemies deal {v}% less damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hungering_ranks": 1}}},
		{"id": "cr_hypothermia", "name": "Hypothermia", "ranks": 1, "lane": "Winter", "row": 2,
			"desc": "Enemies take {v}% more damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hypothermia_ranks": 1}}},
		{"id": "cr_rime", "name": "Rime", "ranks": 1, "lane": "Winter", "row": 3,
			"desc": "New ability: Rime — inflicts Frostbite (-50% healing received, 2 turns); for 3 turns, every stack of Chilled the target gains also chills one other random enemy (25 Mana, 3.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Rime", "cost": 25,
				"special": "rime", "delay": 3.0, "anim": "attack02", "cooldown": 3,
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Hoarfrost takes root: Frostbites the\ntarget (-50% healing received, 2 turns);\nfor 3 turns, every stack of Chilled\nthis enemy gains also chills one\nother random enemy."}}},
		# Re-spec (was a flat armor dial): the aura lane shields its caster.
		{"id": "cr_frost_ward", "name": "Frost Ward", "ranks": 1, "lane": "Winter", "row": 4,
			"desc": "The Cryomancer takes {v}% less damage from Chilled enemies.",
			"scale": {"step": 4},
			"payload": {"stat": {"frost_ward_ranks": 1}}},
		# Re-spec (was a flat max-health dial): feeds the ability instead.
		{"id": "cr_icy_resolve", "name": "Icy Resolve", "ranks": 1, "lane": "Winter", "row": 5,
			"desc": "Rime lasts {v} additional turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"icy_resolve_ranks": 1}}},
		# Re-spec (was a Frigid Grip dial): with permanent stacks the field
		# drifts toward Frozen while he spends his turns elsewhere.
		{"id": "cr_grasp", "name": "Winter's Grasp", "ranks": 1, "lane": "Winter", "row": 6,
			"desc": "At the start of each of the Cryomancer's turns, {v} random Chilled enemy(ies) gain a stack.",
			"scale": {"step": 1},
			"payload": {"stat": {"grasp_ranks": 1}}},
		# Re-spec (was a flat damage-taken dial): the whole warband fumbles.
		{"id": "cr_numbing", "name": "Numbing Veil", "ranks": 1, "lane": "Winter", "row": 7,
			"desc": "Chilled enemies have a {v}% chance to miss.",
			"scale": {"step": 5},
			"payload": {"stat": {"numbing_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "cr_shatter", "name": "Shatter", "ranks": 1, "lane": "Shatterpoint", "row": 8,
			"capstone": true,
			"desc": "New ability: Shatter — deal 10% of Attack × their Chilled stacks to EVERY Chilled enemy (30 Mana, 4.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Shatter", "cost": 30,
				"dmg_type": "frost", "damage": 10, "pressure": 10, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Cooldown becomes 4 instead",
				"description": "The cold detonates: every Chilled\nenemy takes 10% of Attack PER STACK\nof Chilled on it."}}},
		# Absolute Zero: total lockdown on a chosen target — and every
		# per-stack aura stays permanently maxed against it.
		{"id": "cr_absolute", "name": "Absolute Zero", "ranks": 1, "lane": "Deep Freeze", "row": 8,
			"capstone": true,
			"desc": "Freezing an enemy no longer reduces its Chilled stacks — they hold at 4, and the target refreezes the moment its freeze ends.",
			"payload": {"stat": {"absolute_zero": 1}}},
		# Eternal Winter: inevitability — with permanent stacks the entire
		# field freezes whether he acts or not.
		{"id": "cr_eternal", "name": "Eternal Winter", "ranks": 1, "lane": "Winter", "row": 8,
			"capstone": true,
			"desc": "EVERY enemy gains 1 stack of Chilled at the start of each of the Cryomancer's turns.",
			"payload": {"stat": {"eternal_winter": 1}}},
	],
	"arcanist": [
		# Purpose-designed lanes (Batch P, 07-31). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. Every id
		# survives: the 12 originals keep their payloads verbatim
		# (ar_suppressing and ar_temporal move Control → Overload, where a
		# Barrage ramp and a crit echo belong) and the Batch 31 fillers
		# re-spec IN PLACE (same ids, new effects), so saved ranks migrate
		# and nobody gets a refund.
		# --- Lane A: Resonance — the stack engine: ramp faster, cap
		# higher, and keep getting paid at the ceiling. ---
		{"id": "ar_mastery", "name": "Arcane Mastery", "ranks": 1, "lane": "Resonance", "row": 1,
			"desc": "Each stack of Arcane Resonance grants {v}% extra critical strike chance (on top of the base 3%).",
			"scale": {"step": 1},
			"payload": {"stat": {"arcane_mastery_ranks": 1}}},
		{"id": "ar_attunement", "name": "Mana Attunement", "ranks": 1, "lane": "Resonance", "row": 2,
			"desc": "Restore {v}% of your maximum Mana every time you gain a stack of Resonance.",
			"scale": {"step": 2},
			"payload": {"stat": {"mana_attune_ranks": 1}}},
		# Re-spec (was an Arcane Mastery duplicate; same id, so saved ranks
		# carry). Ramps him off the FREE basic — the weak opening turns
		# shorten without spending Mana.
		{"id": "ar_harmonics", "name": "Harmonics", "ranks": 1, "lane": "Resonance", "row": 3,
			"desc": "Arcane Explosion grants {v} additional Resonance.",
			"scale": {"step": 1},
			"payload": {"stat": {"harmonics_ranks": 1}}},
		# Re-spec (was a Mana Attunement echo): the passive's core dial.
		{"id": "ar_conduit", "name": "Conduit", "ranks": 1, "lane": "Resonance", "row": 4,
			"desc": "Each Resonance stack grants +{v}% damage (on top of the base 15%).",
			"scale": {"step": 2},
			"payload": {"stat": {"conduit_ranks": 1}}},
		# Re-spec (was +4% max health): straightforward runway — more
		# ceiling to climb (Overcharge's raised cap climbs with it).
		{"id": "ar_core", "name": "Resonant Core", "ranks": 1, "lane": "Resonance", "row": 5,
			"desc": "Maximum Resonance rises by {v} (Overcharge's raised cap climbs the same amount).",
			"scale": {"step": 1},
			"payload": {"stat": {"resonant_core_ranks": 1}}},
		{"id": "ar_unlimited", "name": "Unlimited Power", "ranks": 1, "lane": "Resonance", "row": 6,
			"desc": "Gaining Resonance while already at maximum stacks instead grants +{v}% damage and +{v}% maximum Mana (stacks all battle).",
			"scale": {"step": 2},
			"payload": {"stat": {"unlimited_ranks": 1}}},
		# Re-spec (was flat Explosion damage): pay for staying hot.
		{"id": "ar_charged", "name": "Charged Bolts", "ranks": 1, "lane": "Resonance", "row": 7,
			"desc": "While at maximum Resonance, damaging casts restore {v}% of your maximum Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"charged_bolts_ranks": 1}}},
		# --- Lane B: Overload — the risk half: crits, echoes, and the
		# big spenders escalating with the bill attached. ---
		{"id": "ar_critical_mass", "name": "Critical Mass", "ranks": 1, "lane": "Overload", "row": 1,
			"desc": "Every 3rd critical strike deals {v}% more damage and restores half as much of your maximum Mana.",
			"scale": {"step": 20},
			"payload": {"stat": {"critical_mass_ranks": 1}}},
		# Moved from Control: a crit echo is pure offence.
		{"id": "ar_temporal", "name": "Temporal Rift", "ranks": 1, "lane": "Overload", "row": 2,
			"desc": "Critical strikes have a {v}% chance to echo for 25% of their damage against a random enemy.",
			"scale": {"step": 3},
			"payload": {"stat": {"temporal_ranks": 1}}},
		{"id": "ar_overcharge", "name": "Overcharge", "ranks": 1, "lane": "Overload", "row": 3,
			"desc": "New ability: Overcharge — raise your maximum Resonance to 8; stacks beyond 5 give 1.5x their normal Resonance bonus (20 Mana, 1.5 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Overcharge", "cost": 20,
				"special": "overcharge", "delay": 1.5, "anim": "attack02", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Stacks beyond 5 give 1.65x instead",
				"description": "Push past the limit: maximum\nResonance becomes 8; stacks beyond\n5 give 1.5x their normal Resonance\nbonus (damage, crit, damage taken)."}}},
		# Moved from Control: an offensive Barrage ramp belongs here.
		{"id": "ar_suppressing", "name": "Suppressing Fire", "ranks": 1, "lane": "Overload", "row": 4,
			"desc": "Each bolt of Arcane Barrage deals {v}% of Attack more than the previous one.",
			"scale": {"step": 0.25},
			"payload": {"stat": {"suppressing_ranks": 1}}},
		# Re-spec (was flat Cannon damage): the per-stack term instead.
		{"id": "ar_cannoneer", "name": "Cannoneer", "ranks": 1, "lane": "Overload", "row": 5,
			"desc": "Arcane Cannon deals +{v}% damage per Resonance stack (on top of the base 7.5%).",
			"scale": {"step": 2.5},
			"payload": {"stat": {"cannoneer_ranks": 1}}},
		# Re-spec (was a Barrage Mana discount): more bolts instead.
		{"id": "ar_barrister", "name": "Barrage Master", "ranks": 1, "lane": "Overload", "row": 6,
			"desc": "Arcane Barrage fires {v} additional bolt(s).",
			"scale": {"step": 1},
			"payload": {"ability": "Arcane Barrage", "add": {"random_hits": 1}}},
		# Re-spec (was flat crit; its old cross-lane exclusive is retired —
		# the fork lives in Control now): the lane's thesis in one node —
		# pure escalation with the bill attached.
		{"id": "ar_volatility", "name": "Volatility", "ranks": 1, "lane": "Overload", "row": 7,
			"desc": "Arcane Cannon and Magi's Wrath deal +{v}% damage, and their recoil rises +{v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"volatility_ranks": 1}}},
		# --- Lane C: Control — surviving what you built. The risk answer
		# is a fork: run hot forever, or vent constantly. ---
		{"id": "ar_mindfulness", "name": "Mindfulness", "ranks": 1, "lane": "Control", "row": 1,
			"desc": "Every {v} of your turns, ALL of your cooldowns tick down 1 extra turn.",
			"scale": {"base": 7, "step": -1},
			"payload": {"stat": {"mindfulness_ranks": 1}}},
		{"id": "ar_conversion", "name": "Conversion", "ranks": 1, "lane": "Control", "row": 2,
			"desc": "{v}% of damage taken is lost as Mana instead of health.",
			"scale": {"step": 10},
			"payload": {"stat": {"conversion_ranks": 1}}},
		{"id": "ar_on_edge", "name": "On the Edge", "ranks": 1, "lane": "Control", "row": 3,
			"desc": "Surviving an attack below {v}% health grants 1 stack of Resonance.",
			"scale": {"base": 20, "step": 5},
			"payload": {"stat": {"on_edge_ranks": 1}}},
		{"id": "ar_stable", "name": "Stable Alignment", "ranks": 1, "lane": "Control", "row": 4,
			"desc": "You cannot lose more than {v}% of your maximum health to a single attack.",
			"scale": {"base": 40, "step": -5},
			"payload": {"stat": {"stable_ranks": 1}}},
		# Re-spec (was +3% armor). One side of the sharpest fork the spec
		# can offer: run permanently hot — the penalty barely bites...
		{"id": "ar_ward", "name": "Arcane Ward", "ranks": 1, "lane": "Control", "row": 5,
			"desc": "The Resonance damage-taken penalty falls {v}% per stack (from the base 5%).",
			"scale": {"step": 1},
			"payload": {"stat": {"arcane_ward_ranks": 1}}},
		# Re-spec (was flat damage reduction). ...or vent often and
		# cheaply, because venting no longer erases you.
		{"id": "ar_still", "name": "Still Mind", "ranks": 1, "lane": "Control", "row": 6,
			"desc": "Stabilize leaves {v} additional stacks standing (on top of its floor of 2).",
			"scale": {"step": 1},
			"payload": {"stat": {"still_mind_ranks": 1}}},
		# Re-spec (was Meltdown, a +dmg/+taken dial; same id, so saved
		# ranks carry). Pairs with Conversion: a committed Control build
		# turns nearly all self-inflicted damage into fuel.
		{"id": "ar_meltdown", "name": "Feedback Loop", "ranks": 1, "lane": "Control", "row": 7,
			"desc": "{v}% of recoil damage is paid as Mana instead of health.",
			"scale": {"step": 10},
			"payload": {"stat": {"feedback_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Re-spec (was a stat pile): the natural end of a lane about the
		# resource itself — unlimited scaling, risk capped where it
		# already hurts. (Overflow payouts never fire: there is no max.)
		{"id": "ar_singularity", "name": "Singularity", "ranks": 1, "lane": "Resonance", "row": 8,
			"capstone": true,
			"desc": "Resonance has NO maximum. The damage-taken penalty stops rising past 5 stacks.",
			"payload": {"stat": {"singularity": 1}}},
		{"id": "ar_wrath", "name": "Magi's Wrath", "ranks": 1, "lane": "Overload", "row": 8,
			"capstone": true,
			"desc": "New ability: Magi's Wrath — 15% of Attack as arcane to ALL enemies, +4% per Resonance stack; BD = 2.5 x stacks; recoil 15% of damage dealt, -3% per enemy hit (30 Mana, 4.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Magi's Wrath", "cost": 30,
				"dmg_type": "arcane", "damage": 15, "pressure": 0, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 4, "recoil_base": 0.15,
				"perfect_id": "", "perfect_text": "Costs 3.5 initiative instead",
				"description": "The storm unchained: rakes the whole\nenemy team, +4% damage per Resonance\nstack; BD = 2.5 x stacks. Recoil 15%\nof damage dealt, -3% per enemy hit."}}},
		# Re-spec (was a Temporal Rift / Mindfulness bundle): removes the
		# Stabilize trade entirely — full defensive value, full offensive
		# value, every three turns.
		{"id": "ar_timelord", "name": "Master of Moments", "ranks": 1, "lane": "Control", "row": 8,
			"capstone": true,
			"desc": "Stabilize consumes no stacks at all — it grants its Mana and damage reduction from your current stacks and leaves them intact.",
			"payload": {"stat": {"master_moments": 1}}},
	],
	"holy": [
		# Purpose-designed lanes (Batch J, 07-30). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. Every id
		# survives and re-specs in place, so saved ranks migrate (only
		# hl_serenity's cap shrank 2 → 1 — the loader refunds the extra
		# rank). Six of the old 24 nodes were "deepen another node" and two
		# of the three capstones were +2 ranks of something already owned;
		# worse, NOTHING touched Empower — the most interesting decision in
		# the kit. The Mercy lane now runs the resource economy end to end:
		# earning stacks, holding them, spending them, and Empower itself.
		# --- Lane A: Radiance — throughput: bigger heals, cheaper heals,
		# less waste. ---
		{"id": "hl_triage", "name": "Triage", "ranks": 1, "lane": "Radiance", "row": 1,
			"desc": "Instant heals can CRIT (x1.5, using your critical strike chance), and all your healing is increased by {v}%.",
			"scale": {"step": 3},
			"payload": {"stat": {"triage_ranks": 1}}},
		{"id": "hl_soothe", "name": "Soothing Touch", "ranks": 1, "lane": "Radiance", "row": 2,
			"desc": "Renewal costs {v} less Mana.", "scale": {"step": 5},
			"payload": {"ability": "Renewal", "add": {"cost": -5}}},
		{"id": "hl_on_mend", "name": "On the Mend", "ranks": 1, "lane": "Radiance", "row": 3,
			"desc": "Renewal ticks have a {v}% chance to dispel one harmful effect from the bearer.",
			"scale": {"step": 5},
			"payload": {"stat": {"on_mend_ranks": 1}}},
		{"id": "hl_capacitor", "name": "Holy Capacitor", "ranks": 1, "lane": "Radiance", "row": 4,
			"desc": "{v}% of your overhealing is stored and released by your next Heal.",
			"scale": {"step": 5},
			"payload": {"stat": {"capacitor_ranks": 1}}},
		{"id": "hl_swift", "name": "Swift Mending", "ranks": 1, "lane": "Radiance", "row": 5,
			"desc": "Heal's cooldown is reduced by 1 turn.",
			"payload": {"ability": "Heal", "add": {"cooldown": -1}}},
		# Re-spec (was Brilliance, a Triage deepener; same id, so saved
		# ranks carry). One half of the wasted-healing fork: crit
		# investment pays out sideways — it needs Triage to fire at all.
		{"id": "hl_brilliance", "name": "Radiant Cascade", "ranks": 1, "lane": "Radiance", "row": 6,
			"desc": "A CRITICAL heal also splashes {v}% of its value onto the lowest-health other ally.",
			"scale": {"step": 25},
			"payload": {"stat": {"cascade_ranks": 1}}},
		# Re-spec (was a Holy Capacitor deepener): the other half of the
		# fork — raw output spills over instead of banking. Pairs with
		# Capacitor, which drinks from the same overheal.
		{"id": "hl_overflow", "name": "Overflow", "ranks": 1, "lane": "Radiance", "row": 7,
			"desc": "{v}% of any overhealing spills onto the lowest-health other ally immediately.",
			"scale": {"step": 15},
			"payload": {"stat": {"overflow_ranks": 1}}},
		# --- Lane B: Mercy — the resource economy: earning stacks,
		# spending stacks, and Empower. The lane that didn't exist. ---
		{"id": "hl_heavenly", "name": "Heavenly Aura", "ranks": 1, "lane": "Mercy", "row": 1,
			"desc": "Each stack of Mercy grants {v}% healing done (up from the base 5%).",
			"scale": {"base": 5, "step": 5},
			"payload": {"stat": {"heavenly_ranks": 1}}},
		{"id": "hl_holy_light", "name": "Holy Light", "ranks": 1, "lane": "Mercy", "row": 2,
			"desc": "Perfect casts restore {v}% of your maximum Mana.",
			"scale": {"step": 1},
			"payload": {"stat": {"holy_light_ranks": 1}}},
		# Re-spec (was +4% damage on a 50-Attack healer, and half of a
		# cross-lane exclusive that read as a bug): Mercy is purely
		# reactive — she started every fight at zero, Hymn uncastable on
		# turn one. Now she opens with a working kit.
		{"id": "hl_zealous", "name": "Zealous Light", "ranks": 1, "lane": "Mercy", "row": 3,
			"desc": "The Cleric begins each battle with {v} Mercy.",
			"scale": {"step": 1},
			"payload": {"stat": {"zealous_mercy": 1}}},
		{"id": "hl_sanctified", "name": "Sanctified", "ranks": 1, "lane": "Mercy", "row": 4,
			"desc": "Spending Mercy has a {v}% chance to consume no stacks.",
			"scale": {"step": 10},
			"payload": {"stat": {"sanctified_ranks": 1}}},
		{"id": "hl_resurrection", "name": "Resurrection", "ranks": 1, "lane": "Mercy", "row": 5,
			"desc": "New ability: Resurrection — spend 1 Mercy to return a fallen ally to life with 20% health and resource; Empower (+1 Mercy): full health and resource plus 5 turns of Renewal (4.0 int, 3cd).",
			"payload": {"grant_ability": "Resurrection"}},
		# Re-spec (was a Heavenly Aura deepener): the Empower support the
		# tree never had, and a rhythm rather than a discount — bank to
		# the threshold, then Empower freely until you drop below it.
		# Holding Mercy is already rewarded by the healing bonus, so this
		# deepens a decision that is genuinely live.
		{"id": "hl_ardor", "name": "Ardor", "ranks": 1, "lane": "Mercy", "row": 6,
			"desc": "While the Cleric holds {v} or more Mercy, Empowering consumes no stack.",
			"scale": {"base": 5, "step": -1},
			"payload": {"stat": {"ardor_ranks": 1}}},
		# Re-spec (was an Inner Faith duplicate — both wrote max_hp_pct):
		# the lane's payoff. A bigger cap is more held bonus AND more
		# banked spenders at once.
		{"id": "hl_martyr", "name": "Martyr's Vigor", "ranks": 1, "lane": "Mercy", "row": 7,
			"desc": "Mercy's maximum rises to {v}.",
			"scale": {"base": 5, "step": 1},
			"payload": {"stat": {"mercy_cap_bonus": 1}}},
		# --- Lane C: Sanctuary — the safety net: keeping people from
		# dying, rather than healing them after. ---
		{"id": "hl_guardian", "name": "Guardian Angel", "ranks": 1, "lane": "Sanctuary", "row": 1,
			"desc": "Allies falling below {v}% health earn you a stack of Mercy (up from 50%).",
			"scale": {"base": 50, "step": 3},
			"payload": {"stat": {"guardian_ranks": 1}}},
		{"id": "hl_presence", "name": "Divine Presence", "ranks": 1, "lane": "Sanctuary", "row": 2,
			"desc": "At the end of your turn, the lowest-health ally is healed for {v}% of their maximum health.",
			"scale": {"step": 1},
			"payload": {"stat": {"divine_presence_ranks": 1}}},
		{"id": "hl_last_hope", "name": "Last Hope", "ranks": 1, "lane": "Sanctuary", "row": 3,
			"desc": "Allies under 25% of their max health receive {v}% more healing.",
			"scale": {"step": 5},
			"payload": {"stat": {"last_hope_ranks": 1}}},
		{"id": "hl_inner_faith", "name": "Inner Faith", "ranks": 1, "lane": "Sanctuary", "row": 4,
			"desc": "Increases your maximum health by {v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# Re-spec (was +3% armor): Renewal becomes a protective tool as
		# well as a heal — and the Radiance lane gains a reason to splash.
		{"id": "hl_vestments", "name": "Blessed Vestments", "ranks": 1, "lane": "Sanctuary", "row": 5,
			"desc": "Allies with Renewal on them take {v}% less damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"vestments_ranks": 1}}},
		# Re-spec (was a Divine Presence deepener): triage that happens
		# without spending a turn.
		{"id": "hl_beacon", "name": "Beacon", "ranks": 1, "lane": "Sanctuary", "row": 6,
			"desc": "At the start of each of the Cleric's turns, every ally below 25% health heals {v}% of their maximum health.",
			"scale": {"step": 5},
			"payload": {"stat": {"beacon_ranks": 1}}},
		# Re-spec (was flat -4% damage taken, and the other half of the
		# cross-lane exclusive; ranks 2 → 1 — the loader refunds the
		# over-cap rank): the safety net's signature moment.
		{"id": "hl_serenity", "name": "Serenity", "ranks": 1, "lane": "Sanctuary", "row": 7,
			"desc": "Once per battle, the first ally to take lethal damage survives at 1 HP instead.",
			"payload": {"stat": {"serenity": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "hl_divine_plea", "name": "Divine Plea", "ranks": 1, "lane": "Radiance", "row": 8,
			"capstone": true,
			"desc": "New ability: Divine Plea — spend 2 Mercy to FULLY heal an ally; Empower (+1 Mercy): also cleanse all debuffs and Consecrate them against new ones for 3 turns (3.0 int, 2cd).",
			"payload": {"grant_ability": "Divine Plea"}},
		# Re-spec (was +2 Heavenly Aura steps): Mercy turns from a
		# reactive trickle into an engine, and Empower goes unconditional
		# — the payoff for a lane built on the resource. Supersedes Ardor
		# rather than stacking with it (the free-Empower checks are
		# either/or, never a double refund).
		{"id": "hl_avatar", "name": "Avatar of Mercy", "ranks": 1, "lane": "Mercy", "row": 8,
			"capstone": true,
			"desc": "The Cleric gains 1 Mercy at the start of each of her turns, and Empower costs no stack.",
			"payload": {"stat": {"avatar_of_mercy": 1}}},
		# Re-spec (was +2 Guardian Angel steps): every heal she grants a
		# single ally becomes a party heal — the fantasy the lane name
		# was always promising. (Hymn is already the whole party, so it
		# does not echo itself.)
		{"id": "hl_sanctum", "name": "Living Sanctum", "ranks": 1, "lane": "Sanctuary", "row": 8,
			"capstone": true,
			"desc": "All the healing the Cleric grants a single ally — Heal, Renewal and its ticks, Divine Plea — also heals the whole party for 25% of its value.",
			"payload": {"stat": {"living_sanctum": 1}}},
	],
	"inquisitor": [
		# Devout (spec id is legacy) — purpose-designed lanes (Batch K,
		# 07-30). Batch AI re-cut the tiers into 7 exclusive rows + a
		# capstone row. The 12 original nodes keep their ids and payloads
		# verbatim; the Batch 31 conversion fillers were re-specced IN
		# PLACE (same ids, new effects).
		# --- Lane A: Bulwark — the shield itself: bigger, harder, more
		# often. Faith comes FROM absorbs, so this lane is the engine
		# block of the whole Conviction system. ---
		{"id": "dv_barrier", "name": "Blessed Barrier", "ranks": 1, "lane": "Bulwark", "row": 1,
			"desc": "Divine Shield converts {v}% of the damage it absorbs into healing for its holder.",
			"scale": {"step": 4},
			"payload": {"stat": {"blessed_barrier_ranks": 1}}},
		{"id": "dv_aegis", "name": "Radient Aegis", "ranks": 1, "lane": "Bulwark", "row": 2,
			"desc": "Casting Divine Shield has a {v}% chance to cast it again on another ally.",
			"scale": {"step": 15},
			"payload": {"stat": {"aegis_ranks": 1}}},
		{"id": "dv_afterglow", "name": "Afterglow", "ranks": 1, "lane": "Bulwark", "row": 3,
			"desc": "When Divine Shield breaks, its holder is healed for {v}% of the Devout's max health.",
			"scale": {"step": 5},
			"payload": {"stat": {"afterglow_ranks": 1}}},
		# Re-spec (was a flat +3% armor dial): the armor now lives on the
		# shield itself — Divine Shield is the lane's only subject.
		{"id": "dv_warded", "name": "Warded Robes", "ranks": 1, "lane": "Bulwark", "row": 4,
			"desc": "While Divine Shield holds, its holder has +{v}% armor.",
			"scale": {"step": 10},
			"payload": {"stat": {"warded_ranks": 1}}},
		# Re-spec (was -4% damage taken, exclusive with Righteous Fire
		# CROSS-LANE — that pair is gone). The new fork is in-lane and is
		# the shield lane's real question: a bigger shield, or a more
		# frequent one? Bastion also attacks the one-Faith-source-on-a-2cd
		# problem head on.
		{"id": "dv_stalwart", "name": "Stalwart", "ranks": 1, "lane": "Bulwark", "row": 5,
			"desc": "Divine Shield absorbs {v}% of the Devout's max health (up from the base 30%).",
			"scale": {"base": 30, "step": 5},
			"payload": {"stat": {"stalwart_ranks": 1}}},
		# Re-spec (was a second Blessed Barrier step; ranks 2 -> 1 — the
		# loader refunds any over-cap saved rank).
		{"id": "dv_bastion", "name": "Bastion", "ranks": 1, "lane": "Bulwark", "row": 6,
			"desc": "Divine Shield's cooldown is reduced by 1 turn.",
			"payload": {"ability": "Divine Shield", "add": {"cooldown": -1}}},
		# Re-spec (was a second Radient Aegis step): the breaking shield
		# gets a second life instead of a second copy.
		{"id": "dv_unyielding", "name": "Unyielding Aegis", "ranks": 1, "lane": "Bulwark", "row": 7,
			"desc": "When Divine Shield breaks, it immediately re-forms at {v}% of its original strength (once per cast).",
			"scale": {"step": 30},
			"payload": {"stat": {"unyielding_ranks": 1}}},
		# --- Lane B: Faith — the stack economy: earn it faster, keep it
		# longer, spend it deeper. ---
		{"id": "dv_communion", "name": "Communion", "ranks": 1, "lane": "Faith", "row": 1,
			"desc": "When a party member reaches 5 Faith, every other member has a ({v} x their own Faith stacks)% chance to gain 1 stack.",
			"scale": {"step": 20},
			"payload": {"stat": {"communion_ranks": 1}}},
		{"id": "dv_unwavering", "name": "Unwavering Faith", "ranks": 1, "lane": "Faith", "row": 2,
			"desc": "Increases the Devout's maximum health by {v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		{"id": "dv_devoutness", "name": "Devoutness", "ranks": 1, "lane": "Faith", "row": 3,
			"desc": "The entire party takes {v}% less Break damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"devoutness_ranks": 1}}},
		{"id": "dv_faithful", "name": "Blessed are the Faithful", "ranks": 1, "lane": "Faith", "row": 4,
			"desc": "The heal at 5 stacks of Faith restores {v}% max health (up from the base 15%).",
			"scale": {"base": 15, "step": 5},
			"payload": {"stat": {"faithful_ranks": 1}}},
		{"id": "dv_covenant", "name": "Sacred Covenant", "ranks": 1, "lane": "Faith", "row": 5,
			"desc": "Should Divine Shield prevent lethal damage, its holder is healed for {v}% max health and gains 1 Faith stack.",
			"scale": {"step": 5},
			"payload": {"stat": {"covenant_ranks": 1}}},
		# Re-spec (was a second Blessed-are-the-Faithful step). THE node of
		# the batch: Faith's second source — party-wide, and riding a
		# base-kit cast instead of a talent. Conviction finally behaves
		# like the party-wide system its description promises.
		{"id": "dv_fervor", "name": "Fervor", "ranks": 1, "lane": "Faith", "row": 6,
			"desc": "While Consecrated Ground holds, every ally gains {v} Faith at the start of their turn.",
			"scale": {"step": 1},
			"payload": {"stat": {"fervor_ranks": 1}}},
		# Re-spec (was a second Sacred Covenant step): shortens the re-ramp
		# after a release — allies live in the useful 3-5 band.
		{"id": "dv_oath", "name": "Binding Oath", "ranks": 1, "lane": "Faith", "row": 7,
			"desc": "When an ally's Faith releases at 5 stacks, they keep {v} instead of resetting to zero.",
			"scale": {"step": 1},
			"payload": {"stat": {"oath_ranks": 1}}},
		# --- Lane C: Zeal — everything else he casts: the ground, the
		# blessing, the resolve. ---
		# Re-spec: keys off EITHER banner now (was Resolve only), so
		# skipping Sacred Resolve no longer strands the node.
		{"id": "dv_waters", "name": "Cleansing Waters", "ranks": 1, "lane": "Zeal", "row": 1,
			"desc": "While Consecrated Ground or Sacred Resolve holds, each party member has a {v}% chance each turn to be cleansed of one harmful effect.",
			"scale": {"step": 15},
			"payload": {"stat": {"waters_ranks": 1}}},
		# Re-spec (was a flat +3% damage dial, exclusive with Stalwart
		# cross-lane): now it deepens Consecrated Ground's bite.
		{"id": "dv_righteous", "name": "Righteous Fire", "ranks": 1, "lane": "Zeal", "row": 2,
			"desc": "Consecrated Ground reflects {v}% of damage taken (up from the base 10%).",
			"scale": {"base": 10, "step": 5},
			"payload": {"stat": {"righteous_ranks": 1}}},
		{"id": "dv_resolve", "name": "Sacred Resolve", "ranks": 1, "lane": "Zeal", "row": 3,
			"desc": "New ability: Sacred Resolve — all damage received is split evenly among living heroes for 3 turns; Break damage still lands on the struck hero (25 Mana, 2.5 int, 5cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Sacred Resolve"}},
		# Re-spec: either banner keeps the pulse beating (was Resolve only).
		{"id": "dv_pulse", "name": "Healing Pulse", "ranks": 1, "lane": "Zeal", "row": 4,
			"desc": "While Consecrated Ground or Sacred Resolve holds, the party heals {v}% of the Devout's max health each turn.",
			"scale": {"step": 2},
			"payload": {"stat": {"pulse_ranks": 1}}},
		# Re-spec (was Blessing of Zeal cooldown -1; ranks 1 -> 2): the
		# blessing's own cast-time cooldown tick deepens instead.
		{"id": "dv_crusade", "name": "Crusader's Tempo", "ranks": 1, "lane": "Zeal", "row": 5,
			"desc": "Blessing of Zeal ticks its target's cooldowns down {v} additional turn(s) on cast.",
			"scale": {"step": 1},
			"payload": {"stat": {"crusade_ranks": 1}}},
		# Re-spec (was a second Cleansing Waters step): Blessing of Zeal
		# doubles Faith gain, so it now CARRIES a Faith source — the shield
		# is a true Divine Shield (flagged divine) and feeds Conviction.
		{"id": "dv_purity", "name": "Purity", "ranks": 1, "lane": "Zeal", "row": 6,
			"desc": "Blessing of Zeal also grants its target a Divine Shield absorbing {v}% of the Devout's max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"purity_ranks": 1}}},
		# Re-spec (was a second Healing Pulse step; ranks 2 -> 3): pairs
		# with Righteous Fire — together the ground is a healing engine.
		{"id": "dv_lifewell", "name": "Lifewell", "ranks": 1, "lane": "Zeal", "row": 7,
			"desc": "Damage reflected by Consecrated Ground heals the party for {v}% of the amount reflected.",
			"scale": {"step": 20},
			"payload": {"stat": {"lifewell_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "dv_bulwark", "name": "Bulwark of Fortitude", "ranks": 1, "lane": "Bulwark", "row": 8,
			"capstone": true,
			"desc": "New ability: Bulwark of Fortitude — for 3 turns the party takes NO Break damage, has its armor increased by 50%, and heals 10% of max health each turn (30 Mana, 3.0 int, 3cd; Perfect: the party instantly heals 5%).",
			"payload": {"grant_ability": "Bulwark of Fortitude"}},
		# Re-spec (was two Faithful steps + a Covenant step): the Faith
		# lane as a win condition — the party parks at max mitigation and
		# damage, and every absorb becomes a heal.
		{"id": "dv_apostle", "name": "Apostle", "ranks": 1, "lane": "Faith", "row": 8,
			"capstone": true,
			"desc": "Faith releases no longer consume stacks: an ally at 5 Faith stays at 5, and every further Faith gain triggers the release again.",
			"payload": {"stat": {"apostle": 1}}},
		# Re-spec (was +8% damage + a Pulse step): a party role that is
		# neither healing nor damage — a Break-pressure engine that plays
		# straight into the Swordmaster's Break loop.
		{"id": "dv_judgement", "name": "Judgement", "ranks": 1, "lane": "Zeal", "row": 8,
			"capstone": true,
			"desc": "While Consecrated Ground holds, every enemy that damages a hero is Sundered for 2 turns and takes Break damage equal to 20% of the damage it dealt.",
			"payload": {"stat": {"judgement": 1}}},
	],
	"mystic": [
		# Survivalist — 7 exclusive rows + a capstone row (Batch AI).
		# Lanes: Venom / Snares / Guerilla.
		# --- Lane A: Venom — poison as a damage engine ---
		{"id": "sv_potent", "name": "Potent Toxins", "ranks": 1, "lane": "Venom", "row": 1,
			"desc": "Your Poison deals +{v} damage per stack.", "scale": {"step": 1},
			"payload": {"stat": {"potent_ranks": 1}}},
		{"id": "sv_coated", "name": "Coated Blades", "ranks": 1, "lane": "Venom", "row": 2,
			"desc": "Your basic attack applies Poison for 2 turns.",
			"payload": {"stat": {"coated_blades": 1}}},
		{"id": "sv_virulence", "name": "Virulence", "ranks": 1, "lane": "Venom", "row": 3,
			"desc": "Your Poison applications add +{v} extra stack(s).", "scale": {"step": 1},
			"payload": {"stat": {"virulence_ranks": 1}}},
		{"id": "sv_slow_acting", "name": "Slow Acting", "ranks": 1, "lane": "Venom", "row": 4,
			"desc": "Your Poison deals HALF damage but lasts TWICE as long and cannot be cleansed.",
			"payload": {"stat": {"slow_acting": 1}}},
		{"id": "sv_creeping", "name": "Creeping Death", "ranks": 1, "lane": "Venom", "row": 5,
			"desc": "When a Poisoned enemy dies, its Poison stacks transfer to another enemy.",
			"payload": {"stat": {"creeping_death": 1}}},
		{"id": "sv_necrosis", "name": "Necrosis", "ranks": 1, "lane": "Venom", "row": 6,
			"desc": "Poisoned enemies take +20% damage from ALL sources, not just yours.",
			"payload": {"stat": {"necrosis": 1}}},
		{"id": "sv_plague", "name": "Plague Bearer", "ranks": 1, "lane": "Venom", "row": 7,
			"desc": "At the start of your turn, one Poisoned enemy spreads 3 Poison stacks to another.",
			"payload": {"stat": {"plague_bearer": 1}}},
		# --- Lane B: Snares — traps, retaliation, denial ---
		{"id": "sv_wire", "name": "Reinforced Wire", "ranks": 1, "lane": "Snares", "row": 1,
			"desc": "Tripwire's retaliation deals +{v}% of your Attack.", "scale": {"step": 10},
			"payload": {"stat": {"wire_ranks": 1}}},
		{"id": "sv_rigging", "name": "Quick Rigging", "ranks": 1, "lane": "Snares", "row": 2,
			"desc": "Snare Trap's cooldown is reduced by 1, and its spring also applies Cripple.",
			"payload": {"stat": {"quick_rigging": 1}}},
		{"id": "sv_cruel", "name": "Cruel Devices", "ranks": 1, "lane": "Snares", "row": 3,
			"desc": "Your traps deal +{v}% damage.", "scale": {"step": 15},
			"payload": {"stat": {"cruel_ranks": 1}}},
		{"id": "sv_snap_shut", "name": "Snap Shut", "ranks": 1, "lane": "Snares", "row": 4,
			"desc": "Tripwire also retaliates against RANGED attackers, not only melee.",
			"payload": {"stat": {"snap_shut": 1}}},
		{"id": "sv_caught", "name": "Caught Fast", "ranks": 1, "lane": "Snares", "row": 5,
			"desc": "Enemies caught by your traps cannot be healed for 3 turns.",
			"payload": {"stat": {"caught_fast": 1}}},
		{"id": "sv_bone", "name": "Bone Breaker", "ranks": 1, "lane": "Snares", "row": 6,
			"desc": "Your traps apply 30 Break damage when they spring.",
			"payload": {"stat": {"bone_breaker": 1}}},
		{"id": "sv_network", "name": "Deadfall Network", "ranks": 1, "lane": "Snares", "row": 7,
			"desc": "You may have TWO traps active at once.",
			"payload": {"stat": {"deadfall_network": 1}}},
		# --- Lane C: Guerilla — survival, mobility, party utility ---
		{"id": "sv_woodcraft", "name": "Woodcraft", "ranks": 1, "lane": "Guerilla", "row": 1,
			"desc": "+{v}% max Health.", "scale": {"step": 6},
			"payload": {"stat": {"max_hp_pct": 0.06}}},
		{"id": "sv_hitrun", "name": "Hit and Run", "ranks": 1, "lane": "Guerilla", "row": 2,
			"desc": "Whenever you apply a status to an enemy, you gain Elusive for 1 turn.",
			"payload": {"stat": {"hit_and_run": 1}}},
		{"id": "sv_scavenger", "name": "Scavenger", "ranks": 1, "lane": "Guerilla", "row": 3,
			"desc": "Restore {v}% max Mana whenever an enemy dies.", "scale": {"step": 8},
			"payload": {"stat": {"scavenger_ranks": 1}}},
		{"id": "sv_medic", "name": "Field Medic", "ranks": 1, "lane": "Guerilla", "row": 4,
			"desc": "At the start of your turn, cleanse one debuff from a random ally.",
			"payload": {"stat": {"field_medic": 1}}},
		{"id": "sv_vulture", "name": "Vulture", "ranks": 1, "lane": "Guerilla", "row": 5,
			"desc": "+30% damage against enemies afflicted by 3 or more different statuses.",
			"payload": {"stat": {"vulture": 1}}},
		{"id": "sv_ghillie", "name": "Ghillie Suit", "ranks": 1, "lane": "Guerilla", "row": 6,
			"desc": "Enemies are 40% less likely to target you while another ally lives.",
			"payload": {"stat": {"ghillie": 1}}},
		{"id": "sv_improvised", "name": "Improvised", "ranks": 1, "lane": "Guerilla", "row": 7,
			"desc": "The first ability you use each fight does not start its cooldown.",
			"payload": {"stat": {"improvised": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "sv_epidemic", "name": "Epidemic", "ranks": 1, "lane": "Venom", "row": 8,
			"capstone": true,
			"desc": "Every enemy is PERMANENTLY Poisoned, and your Poison cannot be cleansed or expire.",
			"payload": {"stat": {"epidemic": 1}}},
		{"id": "sv_forest", "name": "The Whole Forest", "ranks": 1, "lane": "Snares", "row": 8,
			"capstone": true,
			"desc": "Tripwire never expires and bites on EVERY enemy action — melee, ranged, or spellwork.",
			"payload": {"stat": {"whole_forest": 1}}},
		{"id": "sv_force", "name": "Force of Nature", "ranks": 1, "lane": "Guerilla", "row": 8,
			"capstone": true,
			"desc": "Trapper's bonus rises to +20% per different status — and applies to your ENTIRE party's damage.",
			"payload": {"stat": {"force_of_nature": 1}}},
	],
	"sharpshooter": [
		# Batch AI re-cut this tree's tiers into 7 exclusive rows + a
		# capstone row; every node costs 1 point and holds a single rank.
		# --- Lane A: Precision — Focus, crit chance, crit damage ---
		{"id": "ss_steady", "name": "Steady Hands", "ranks": 1, "lane": "Precision", "row": 1,
			"desc": "+{v}% critical chance.", "scale": {"step": 4},
			"payload": {"stat": {"crit_bonus": 0.04}}},
		{"id": "ss_perfect_form", "name": "Perfect Form", "ranks": 1, "lane": "Precision", "row": 2,
			"desc": "Critical hits grant +20 Focus.",
			"payload": {"stat": {"perfect_form": 1}}},
		{"id": "ss_deep_focus", "name": "Deep Focus", "ranks": 1, "lane": "Precision", "row": 3,
			"desc": "The Focus cap rises from 100 to 150.",
			"payload": {"stat": {"deep_focus": 1}}},
		{"id": "ss_exec_eye", "name": "Executioner's Eye", "ranks": 1, "lane": "Precision", "row": 4,
			"desc": "Lethal Aim's critical multiplier rises to x{v}.",
			"scale": {"base": 2.0, "step": 0.1},
			"payload": {"stat": {"lethal_eye_ranks": 1}}},
		{"id": "ss_consistent", "name": "Consistent Aim", "ranks": 1, "lane": "Precision", "row": 5,
			"desc": "Critical hits deal x1.5 again — but you gain +30% critical chance.",
			"payload": {"stat": {"consistent_aim": 1, "crit_bonus": 0.30}}},
		{"id": "ss_unwavering", "name": "Unwavering", "ranks": 1, "lane": "Precision", "row": 6,
			"desc": "Switching targets HALVES your Focus instead of clearing it.",
			"payload": {"stat": {"unwavering": 1}}},
		{"id": "ss_tunnel", "name": "Tunnel Vision", "ranks": 1, "lane": "Precision", "row": 7,
			"desc": "+50% critical chance against the enemy you attacked last turn; -50% against every other enemy.",
			"payload": {"stat": {"tunnel_vision": 1}}},
		# --- Lane B: Penetration — armor, Break, finishing the party's work ---
		{"id": "ss_piercer", "name": "Armor Piercer", "ranks": 1, "lane": "Penetration", "row": 1,
			"desc": "Your attacks ignore {v}% of the target's armor.", "scale": {"step": 8},
			"payload": {"stat": {"pierce_bonus": 0.08}}},
		{"id": "ss_sundering", "name": "Sundering Shot", "ranks": 1, "lane": "Penetration", "row": 2,
			"desc": "Critical hits apply 15 Break damage.",
			"payload": {"stat": {"sundering_shot": 1}}},
		{"id": "ss_bonecracker", "name": "Bonecracker", "ranks": 1, "lane": "Penetration", "row": 3,
			"desc": "+{v}% damage against Broken enemies.", "scale": {"step": 12},
			"payload": {"stat": {"bonecracker_ranks": 1}}},
		{"id": "ss_opp_aim", "name": "Opportunist's Aim", "ranks": 1, "lane": "Penetration", "row": 4,
			"desc": "Powershot's Break scaling doubles: +4% damage per full point instead of +2%.",
			"payload": {"stat": {"opp_aim": 1}}},
		{"id": "ss_exposed_nerve", "name": "Exposed Nerve", "ranks": 1, "lane": "Penetration", "row": 5,
			"desc": "Critical hits apply Exposed for 3 turns.",
			"payload": {"stat": {"exposed_nerve": 1}}},
		{"id": "ss_no_cover", "name": "No Cover", "ranks": 1, "lane": "Penetration", "row": 6,
			"desc": "Your attacks cannot be made to miss: Blind and Dazed do not affect you, and Elusive does not protect against you.",
			"payload": {"stat": {"no_cover": 1}}},
		{"id": "ss_overkill", "name": "Overkill", "ranks": 1, "lane": "Penetration", "row": 7,
			"desc": "Excess damage from a killing blow carries to another enemy at full value.",
			"payload": {"stat": {"overkill": 1}}},
		# --- Lane C: Tempo — speed, cooldowns, Focus acceleration ---
		{"id": "ss_fletcher", "name": "Fletcher's Speed", "ranks": 1, "lane": "Tempo", "row": 1,
			"desc": "+{v} Speed.", "scale": {"step": 5},
			"payload": {"stat": {"speed": 5.0}}},
		{"id": "ss_snap", "name": "Snap Shot", "ranks": 1, "lane": "Tempo", "row": 2,
			"desc": "The first ability you use each fight costs no Mana and does not start its cooldown.",
			"payload": {"stat": {"snap_shot": 1}}},
		{"id": "ss_muscle", "name": "Muscle Memory", "ranks": 1, "lane": "Tempo", "row": 3,
			"desc": "Focus gain per attack increases by {v}.", "scale": {"step": 10},
			"payload": {"stat": {"muscle_memory_ranks": 1}}},
		{"id": "ss_volley", "name": "Opening Volley", "ranks": 1, "lane": "Tempo", "row": 4,
			"desc": "You begin every fight with 60 Focus.",
			"payload": {"stat": {"opening_volley": 1}}},
		{"id": "ss_follow", "name": "Follow-Through", "ranks": 1, "lane": "Tempo", "row": 5,
			"desc": "Critical hits reduce ALL your cooldowns by 1.",
			"payload": {"stat": {"follow_through": 1}}},
		{"id": "ss_second_nature", "name": "Second Nature", "ranks": 1, "lane": "Tempo", "row": 6,
			"desc": "Hold Breath's guaranteed critical applies to your next TWO attacks.",
			"payload": {"stat": {"second_nature": 1}}},
		{"id": "ss_spray", "name": "Spray of Arrows", "ranks": 1, "lane": "Tempo", "row": 7,
			"desc": "Your single-target attacks strike one additional random enemy for 50% damage — but Focus can never exceed 50.",
			"payload": {"stat": {"spray": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "ss_one_shot", "name": "One Shot", "ranks": 1, "lane": "Precision", "row": 8,
			"capstone": true,
			"desc": "At maximum Focus, Aimed Shot EXECUTES any non-boss enemy below 35% health outright (elites included); otherwise it deals double damage. Either way, Focus resets to 0.",
			"payload": {"stat": {"one_shot": 1}}},
		{"id": "ss_tnt", "name": "Through and Through", "ranks": 1, "lane": "Penetration", "row": 8,
			"capstone": true,
			"desc": "Your attacks ignore ALL armor, and every critical hit refunds its Mana cost.",
			"payload": {"stat": {"through_and_through": 1}}},
		{"id": "ss_rapid", "name": "Rapid Fire", "ranks": 1, "lane": "Tempo", "row": 8,
			"capstone": true,
			"desc": "Each ability you use has a 35% chance not to consume its cooldown.",
			"payload": {"stat": {"rapid_fire": 1}}},
	],
	"beastmaster": [
		# --- Lane A: Devotion — stay with one beast, steepen the ramp ---
		{"id": "bm_communion", "name": "Wild Communion", "ranks": 1, "lane": "devotion", "row": 1,
			"desc": "Companion strike damage per Loyalty stack rises to {v}% (from the base 5%).",
			"scale": {"base": 5.0, "step": 1.5},
			"payload": {"stat": {"wild_communion_ranks": 1}}},
		{"id": "bm_unbroken", "name": "Unbroken Watch", "ranks": 1, "lane": "devotion", "row": 2,
			"desc": "The active beast gains +1 additional Loyalty on any turn it took no damage.",
			"payload": {"stat": {"unbroken_watch": 1}}},
		{"id": "bm_absolute", "name": "Absolute Devotion", "ranks": 1, "lane": "devotion", "row": 3,
			"desc": "Loyalty ceiling rises from 5 to 7. The doubled Pack Bond still triggers at 5; stacks 6-7 add strike damage and the beast's gift only.",
			"payload": {"stat": {"loyalty_cap_bonus": 2}}},
		{"id": "bm_devoted_fury", "name": "Devoted Fury", "ranks": 1, "lane": "devotion", "row": 4,
			"desc": "Bestial Wrath lasts 1 turn longer per 2 Loyalty stacks on the active beast.",
			"payload": {"stat": {"devoted_fury": 1}}},
		{"id": "bm_steadfast", "name": "Steadfast Bond", "ranks": 1, "lane": "devotion", "row": 5,
			"desc": "When a beast dies, its Loyalty returns at half rather than resetting to 0.",
			"payload": {"stat": {"steadfast_bond": 1}}},
		{"id": "bm_ancient_pact", "name": "Ancient Pact", "ranks": 1, "lane": "devotion", "row": 6,
			"desc": "At 5 Loyalty the Pack Bond boon is TRIPLED instead of doubled — but the beast can no longer be healed by ANY source (Spirit Bond and Hunter's Instinct included).",
			"payload": {"stat": {"ancient_pact": 1}}},
		{"id": "bm_lone_bond", "name": "Lone Bond", "ranks": 1, "lane": "devotion", "row": 7,
			"desc": "You may summon only ONE beast per fight: it cannot be swapped, and cannot be re-summoned if it dies. Its Loyalty starts at 3 and caps at 8.",
			"payload": {"stat": {"lone_bond": 1}}},
		# --- Lane B: The Pack — rotate; swapping becomes the engine ---
		{"id": "bm_whistle", "name": "Quick Whistle", "ranks": 1, "lane": "pack", "row": 1,
			"desc": "Swap Companion's cooldown is reduced by {v} turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"quick_whistle_ranks": 1}}},
		{"id": "bm_momentum", "name": "Feral Momentum", "ranks": 1, "lane": "pack", "row": 2,
			"desc": "+{v}% companion damage for each DIFFERENT beast summoned this fight.",
			"scale": {"step": 8},
			"payload": {"stat": {"momentum_ranks": 1}}},
		{"id": "bm_shared", "name": "Shared Devotion", "ranks": 1, "lane": "pack", "row": 3,
			"desc": "Summoning or swapping grants +1 Loyalty to EVERY beast, not only the arriving one.",
			"payload": {"stat": {"shared_devotion": 1}}},
		{"id": "bm_herald", "name": "Herald", "ranks": 1, "lane": "pack", "row": 4,
			"desc": "Arrival effects strike an additional target: Guardian's Roar taunts TWO enemies, Aguila's dive hits TWO, and Bloodhowl doubles its Bleed on the bloodiest enemy.",
			"payload": {"stat": {"herald": 1}}},
		{"id": "bm_menagerie", "name": "Menagerie", "ranks": 1, "lane": "pack", "row": 5,
			"desc": "The Pack Bond boon of every beast summoned this fight stays active at HALF strength while that beast is away.",
			"payload": {"stat": {"menagerie": 1}}},
		{"id": "bm_no_beast_left", "name": "No Beast Left", "ranks": 1, "lane": "pack", "row": 6,
			"desc": "When a beast dies, your next summon this fight costs no Mana and ignores its cooldown.",
			"payload": {"stat": {"no_beast_left": 1}}},
		{"id": "bm_wild_rotation", "name": "Wild Rotation", "ranks": 1, "lane": "pack", "row": 7,
			"desc": "Swap Companion has no cooldown and arrival effects always fire. Loyalty caps at 2.",
			"payload": {"stat": {"wild_rotation": 1}}},
		# --- Lane C: Handler — your own game: Quick Shot, Mana, loss ---
		{"id": "bm_masters_aim", "name": "Master's Aim", "ranks": 1, "lane": "handler", "row": 1,
			"desc": "Quick Shot deals +{v}% of your Attack.",
			"scale": {"step": 6},
			"payload": {"stat": {"masters_aim_ranks": 1}}},
		{"id": "bm_beast_within", "name": "Beast Within", "ranks": 1, "lane": "handler", "row": 2,
			"desc": "+{v}% companion max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"companion_hp_pct": 0.10}}},
		{"id": "bm_reserves", "name": "Deep Reserves", "ranks": 1, "lane": "handler", "row": 3,
			"desc": "Spirit Bond restores +{v}% more max Mana.",
			"scale": {"step": 8},
			"payload": {"stat": {"deep_reserves_ranks": 1}}},
		{"id": "bm_instinctive", "name": "Instinctive", "ranks": 1, "lane": "handler", "row": 4,
			"desc": "Hunter's Instinct empowers 5 Quick Shots instead of 3.",
			"payload": {"stat": {"instinctive": 1}}},
		{"id": "bm_symbiosis", "name": "Symbiosis", "ranks": 1, "lane": "handler", "row": 5,
			"desc": "Whenever your companion strikes, you restore 2% max Mana.",
			"payload": {"stat": {"symbiosis": 1}}},
		{"id": "bm_vengeance", "name": "Vengeance", "ranks": 1, "lane": "handler", "row": 6,
			"desc": "When your beast dies you inherit its Pack Bond boon and gain +30% damage, for 5 turns.",
			"payload": {"stat": {"vengeance": 1}}},
		{"id": "bm_lone_hunter", "name": "Lone Hunter", "ranks": 1, "lane": "handler", "row": 7,
			"desc": "While you have no companion, your abilities cost 40% less Mana and you deal +25% damage.",
			"payload": {"stat": {"lone_hunter": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "bm_one_soul", "name": "One Soul", "ranks": 1, "lane": "devotion", "row": 8,
			"capstone": true,
			"desc": "You and the active beast share a health pool — all damage to either is split evenly between you. Loyalty gain is doubled.",
			"payload": {"stat": {"one_soul": 1}}},
		{"id": "bm_the_pack", "name": "The Pack", "ranks": 1, "lane": "pack", "row": 8,
			"capstone": true,
			"desc": "TWO beasts may be active at once: both strike when you attack, and each keeps its own Loyalty meter and grants its own Pack Bond boon. Summoning a third replaces whichever active beast has lower Loyalty.",
			"payload": {"stat": {"the_pack": 1}}},
		{"id": "bm_apex", "name": "Apex Predator", "ranks": 1, "lane": "handler", "row": 8,
			"capstone": true,
			"desc": "Quick Shot triggers an ADDITIONAL free companion strike, and Kill Command's cooldown resets whenever an enemy dies.",
			"payload": {"stat": {"apex": 1}}},
	],
	"occultist": [
		# Purpose-designed lanes (Batch L, 07-30). Batch AI re-cut the tiers
		# into 7 exclusive rows + a capstone row. The 11 mapped
		# original nodes keep their ids and payloads verbatim (Dark Infusion
		# was already dropped by the Batch 31 conversion and stays out); the
		# conversion fillers were re-specced IN PLACE (same ids, new
		# effects), so saved ranks migrate. The deliberate bias: CROSS-LANE
		# PLUMBING — the three lanes never fed one another, so Delirium
		# makes Madness generate Ruin, and Cackling Mirror / Soul Glut make
		# both generate healing. Three lanes running one loop.
		# --- Lane A: Ruin — the detonation engine: stack the mark, blow
		# it, chain it. Entropy is the Pressure archetype made literal. ---
		{"id": "oc_emp_hex", "name": "Empowered Hex", "ranks": 1, "lane": "Ruin", "row": 1,
			"desc": "Hex of Ruin has a {v}% chance per target to also apply Decay (10 Break damage per turn, 3 turns).",
			"scale": {"step": 25},
			"payload": {"stat": {"emp_hex_ranks": 1}}},
		# Re-spec (was a second Empowered Hex step; ranks 2 -> 3): each
		# stack of the mark now cracks its bearer wider — the meter does
		# damage work while it fills.
		{"id": "oc_deep_hex", "name": "Deeper Hex", "ranks": 1, "lane": "Ruin", "row": 2,
			"desc": "Each stack of Ruin makes its bearer take {v}% more damage (up from the base 2%).",
			"scale": {"base": 2, "step": 1},
			"payload": {"stat": {"deep_hex_ranks": 1}}},
		{"id": "oc_channeling", "name": "Corrupted Channeling", "ranks": 1, "lane": "Ruin", "row": 3,
			"desc": "Whenever a Crippled enemy attacks, a random hero heals for {v}% of the damage it dealt.",
			"scale": {"step": 25},
			"payload": {"stat": {"channeling_ranks": 1}}},
		{"id": "oc_broken_will", "name": "Broken Will", "ranks": 1, "lane": "Ruin", "row": 4,
			"desc": "The Occultist deals {v}% more Break damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"broken_will_ranks": 1}}},
		# Re-spec (was a flat +3% damage dial, exclusive with Pact of Flesh
		# CROSS-LANE — that pair is gone; ranks 3 -> 2): the detonation is
		# the lane's payoff, so the damage dial lives on it now.
		{"id": "oc_grim", "name": "Grim Focus", "ranks": 1, "lane": "Ruin", "row": 5,
			"desc": "Ruin detonations deal {v}% more damage.",
			"scale": {"step": 25},
			"payload": {"stat": {"grim_ranks": 1}}},
		# Re-spec (was a second Broken Will step; ranks 2 -> 3): any Ruin at
		# all now grinds the Break meter on its own — and feeds the
		# Swordmaster's Broken-window loop across the party.
		{"id": "oc_entropy", "name": "Entropy", "ranks": 1, "lane": "Ruin", "row": 6,
			"desc": "Enemies bearing any Ruin take {v} Break damage at the start of each of their turns.",
			"scale": {"step": 5},
			"payload": {"stat": {"entropy_ranks": 1}}},
		# Re-spec (was Hex of Ruin -5 Mana; ranks 2 -> 3): a detonation now
		# seeds the mark in every other enemy — the next meter is already
		# filling. One propagation per detonation (battle.gd enforces it).
		{"id": "oc_unravel", "name": "Unraveling", "ranks": 1, "lane": "Ruin", "row": 7,
			"desc": "When Ruin detonates, every other enemy gains {v} Ruin.",
			"scale": {"step": 1},
			"payload": {"stat": {"unravel_ranks": 1}}},
		# --- Lane B: Madness — enemies turned on each other, and the
		# betrayal now has somewhere to go: Delirium turns it into Ruin,
		# Cackling Mirror turns it into healing. ---
		{"id": "oc_spread", "name": "Spread of Madness", "ranks": 1, "lane": "Madness", "row": 1,
			"desc": "Psychosis has a {v}% chance per turn to spread to a fellow minion — the newly maddened gain a stack of Ruin.",
			"scale": {"step": 15},
			"payload": {"stat": {"spread_ranks": 1}}},
		# Re-spec (was Bewitch -5 Mana; ranks 2 -> 3): at 50%, half of
		# every Psychosis is a wasted turn and the lane feels unreliable.
		# At 80% it's a plan.
		{"id": "oc_whispers", "name": "Whispers", "ranks": 1, "lane": "Madness", "row": 2,
			"desc": "Psychosis takes the wheel {v}% of the time (up from the base 50%).",
			"scale": {"base": 50, "step": 10},
			"payload": {"stat": {"whispers_ranks": 1}}},
		{"id": "oc_mind_flay", "name": "Mind Flay", "ranks": 1, "lane": "Madness", "row": 3,
			"desc": "New ability: Mind Flay — 30% of Attack in shadow to TWO chosen minions, inflicting Psychosis for 3 turns (25 Mana, 3.0 int, 2cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Mind Flay"}},
		{"id": "oc_mirror", "name": "Umbral Mirror", "ranks": 1, "lane": "Madness", "row": 4,
			"desc": "When an enemy would debuff a hero, there is a {v}% chance the debuff reflects back onto it instead (and counts toward Ruin).",
			"scale": {"step": 10},
			"payload": {"stat": {"mirror_ranks": 1}}},
		# Re-spec (was a second Spread of Madness step): THE cross-lane
		# node — every maddened strike now builds toward a detonation.
		# Madness generates Ruin.
		{"id": "oc_delirium", "name": "Delirium", "ranks": 1, "lane": "Madness", "row": 5,
			"desc": "When a Psychotic, Bewitched or Hysterical enemy strikes a fellow, the victim gains {v} Ruin.",
			"scale": {"step": 1},
			"payload": {"stat": {"delirium_ranks": 1}}},
		# Re-spec (was a second Umbral Mirror step): the other half of the
		# plumbing — Madness generates healing, in his own siphoning voice.
		{"id": "oc_cackling", "name": "Cackling Mirror", "ranks": 1, "lane": "Madness", "row": 6,
			"desc": "When an enemy strikes a fellow, the party heals {v}% of the damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"cackling_ranks": 1}}},
		# Re-spec (was Bewitch cooldown -1; ranks 1 -> 2): madness never
		# just ends any more — it curdles into the rot.
		{"id": "oc_torment", "name": "Lingering Torment", "ranks": 1, "lane": "Madness", "row": 7,
			"desc": "When a madness effect expires, it leaves Decay behind for {v} turns (10 Break damage per turn).",
			"scale": {"step": 2},
			"payload": {"stat": {"torment_ranks": 1}}},
		# --- Lane C: Leech — suffering into sustain. Holy restores, the
		# Devout prevents, the Occultist siphons. ---
		{"id": "oc_soul_leech", "name": "Soul Leech", "ranks": 1, "lane": "Leech", "row": 1,
			"desc": "Heroes striking a Ruined target heal {v}% of the damage dealt (up from the base 10%).",
			"scale": {"base": 10, "step": 5},
			"payload": {"stat": {"soul_leech_ranks": 1}}},
		{"id": "oc_invigoration", "name": "Invigoration", "ranks": 1, "lane": "Leech", "row": 2,
			"desc": "Dark Pact also restores {v}% of the Cleric's max Mana each turn for 3 turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"invigoration_ranks": 1}}},
		# Re-spec (was a second Soul Leech step; ranks 2 -> 3): its own
		# cheaper dial on the same draught.
		{"id": "oc_gluttony", "name": "Gluttony", "ranks": 1, "lane": "Leech", "row": 3,
			"desc": "The Ruin lifesteal drinks another {v}% of the damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"gluttony_ranks": 1}}},
		{"id": "oc_pleasure", "name": "Pleasure from Pain", "ranks": 1, "lane": "Leech", "row": 4,
			"desc": "At the end of the Occultist's turn, the party heals {v}% of the Occultist's max health for every UNIQUE debuff on the enemy team.",
			"scale": {"step": 0.5},
			"payload": {"stat": {"pleasure_ranks": 1}}},
		{"id": "oc_murderous", "name": "Murderous Intent", "ranks": 1, "lane": "Leech", "row": 5,
			"desc": "When a Bewitched enemy kills one of its fellows, the lowest-health party member heals {v}% of the Occultist's max health.",
			"scale": {"step": 10},
			"payload": {"stat": {"murderous_ranks": 1}}},
		# Re-spec (was +4% max health, exclusive with Grim Focus CROSS-LANE
		# — that pair is gone; ranks 3 -> 2). The new fork is in-lane and
		# the cleanest possible: one ability, pay less or get more. Dark
		# Pact is the one place he trades his own body for the party's.
		{"id": "oc_pact_flesh", "name": "Pact of Flesh", "ranks": 1, "lane": "Leech", "row": 6,
			"desc": "Dark Pact bleeds {v}% less of the Occultist's max health (from its base cost of 20%).",
			"scale": {"step": 10},
			"payload": {"stat": {"pact_flesh_ranks": 1}}},
		# Re-spec (was Dark Pact cooldown -1; ranks 1 -> 2): the other jaw
		# of the fork — the party drinks deeper from the same wound.
		{"id": "oc_barter", "name": "Dark Barter", "ranks": 1, "lane": "Leech", "row": 7,
			"desc": "Dark Pact heals the party for {v}% of each member's max health (up from the base 15%).",
			"scale": {"base": 15, "step": 10},
			"payload": {"stat": {"barter_ranks": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Re-spec (was an Emp Hex / Channeling stat bundle): the natural
		# end state of a lane built on filling a meter — a maxed target is
		# a recurring bomb.
		{"id": "oc_avatar_ruin", "name": "Avatar of Ruin", "ranks": 1, "lane": "Ruin", "row": 8,
			"capstone": true,
			"desc": "Ruin detonations no longer consume their stacks: a target held at 5 Ruin detonates again at the start of each of its turns.",
			"payload": {"stat": {"avatar_ruin": 1}}},
		{"id": "oc_hysteria", "name": "Mass Hysteria", "ranks": 1, "lane": "Madness", "row": 8,
			"capstone": true,
			"desc": "New ability: Mass Hysteria — next turn every minion strikes a fellow with DOUBLE Break damage, Sundering them for 3 turns (30 Mana, 4.0 int, 4cd; Perfect: 3cd).",
			"payload": {"grant_ability": "Mass Hysteria"}},
		# Re-spec (was a Soul Leech / max-health stat bundle): the "lesser
		# healer" becomes a real one through his own mechanic — every
		# hero's attack into a Ruined enemy is party-wide sustain.
		{"id": "oc_soul_glut", "name": "Soul Glut", "ranks": 1, "lane": "Leech", "row": 8,
			"capstone": true,
			"desc": "Whenever a hero heals by striking a Ruined target, the whole party heals for the same amount.",
			"payload": {"stat": {"soul_glut": 1}}},
	],
}


# ---------- the tree's shape, read off the data ----------

# Every node in a row, across all three lanes, in lane order. Row 8 is the
# capstone shelf.
static func row_nodes(tree_nodes: Array, row: int) -> Array:
	var out: Array = []
	for t in tree_nodes:
		if int(t.get("row", 0)) == row:
			out.append(t)
	return out


# The ids the player has taken in a row. Rows hold one pick normally, two
# when an elite point forced the row open.
static func row_picks(tree_nodes: Array, learned: Dictionary, row: int) -> Array:
	var out: Array = []
	for t in row_nodes(tree_nodes, row):
		if int(learned.get(t["id"], 0)) > 0:
			out.append(String(t["id"]))
	return out


static func row_picked(tree_nodes: Array, learned: Dictionary, row: int) -> bool:
	return not row_picks(tree_nodes, learned, row).is_empty()


# The lowest row still waiting on its pick — the frontier the player is
# standing at. ROWS + 1 (= CAPSTONE_ROW) means all seven are done and the
# capstone shelf is open.
static func open_row(tree_nodes: Array, learned: Dictionary) -> int:
	for row in range(1, ROWS + 1):
		if not row_picked(tree_nodes, learned, row):
			return row
	return CAPSTONE_ROW


static func has_capstone(tree_nodes: Array, learned: Dictionary) -> bool:
	return row_picked(tree_nodes, learned, CAPSTONE_ROW)


# ---------- hooks the class batches author against (Batch AI §5) ----------

# Was this node taken? The condition every "if you also picked X" payload
# reads, and the one battle.gd calls at resolve time.
static func has_node(learned: Dictionary, id: String) -> bool:
	return int(learned.get(id, 0)) > 0


# THE list of every ability display name a hero can cast: core kit + spec
# kit + kit-override renames + earned picks (Runes.kit_names, which is what
# the action bar is built from), PLUS anything a LEARNED talent node grants.
# Run.owned_ability_names forwards to this, so the ability-offer roller, the
# rune "requires_ability" filter and a node's condition all read one list
# and can never disagree with what the player sees on their own bar.
# (Lives here rather than on Run: autoload identifiers do not resolve inside
# a class_name script — the same reason RunSim takes Run injected.)
static func ability_names(member: Dictionary) -> Array:
	var names: Array = Runes.kit_names(member)
	var learned: Dictionary = member.get("talents", {})
	for node in member.get("tree", []):
		if int(learned.get(String(node.get("id", "")), 0)) < 1:
			continue
		var pay: Dictionary = node.get("payload", {})
		if pay.has("new_ability"):
			names.append(String(pay["new_ability"]["display_name"]))
		elif pay.has("grant_ability"):
			names.append(String(pay["grant_ability"]))
	return names


# Does this hero currently have the ability, from ANY source — starting kit,
# kit override, mini-boss/boss pick, or a talent grant?
static func owns_ability(member: Dictionary, display_name: String) -> bool:
	if member.is_empty() or display_name == "":
		return false
	return ability_names(member).has(display_name)


# A payload's optional "condition": {"has_node": id} / {"owns_ability": name},
# or both (ALL must hold). ctx carries {learned, member} — an empty ctx makes
# a conditional payload inert rather than silently unconditional, which is the
# safe direction: an effect that fails to appear is a bug you can see.
static func condition_met(cond: Dictionary, ctx: Dictionary) -> bool:
	if cond.is_empty():
		return true
	if cond.has("has_node") \
			and not has_node(ctx.get("learned", {}), String(cond["has_node"])):
		return false
	if cond.has("owns_ability") \
			and not owns_ability(ctx.get("member", {}), String(cond["owns_ability"])):
		return false
	return true


# ---------- tree build ----------

# Every ability a talent NODE grants, by display name — the single source
# the earnable pools read, so a pool copy can never drift from the copy a
# talent purchase hands out.
static func granted_ability(display_name: String) -> Ability:
	for spec_key in LANE_TREES:
		for node in LANE_TREES[spec_key]:
			var pay: Dictionary = node.get("payload", {})
			if pay.has("new_ability") \
					and String(pay["new_ability"]["display_name"]) == display_name:
				return Ability.make(pay["new_ability"])
			if pay.has("grant_ability") and String(pay["grant_ability"]) == display_name:
				return Classes.pending_talent_ability(display_name)
	return null


static func has_tree(spec: String) -> bool:
	return LANE_TREES.has(spec)


static func generate_tree(spec: String, _class_key: String) -> Array:
	# Trees are FIXED definitions in code. Specs without one get "coming
	# soon" (there are none today — all 12 are authored).
	if LANE_TREES.has(spec):
		return LANE_TREES[spec].duplicate(true)
	return []


static func node_in_tree(tree_nodes: Array, id: String) -> Dictionary:
	for t in tree_nodes:
		if t["id"] == id:
			return t
	return {}


# Tooltip text for a node: "{v}" in the desc becomes scale.base +
# scale.step. Since Batch AI every node is a single rank, so this renders
# the one value the node will ever have — learned or not.
static func desc_for(node: Dictionary, ranks: int) -> String:
	var desc: String = node["desc"]
	if node.has("scale"):
		var sc: Dictionary = node["scale"]
		var val := float(sc.get("base", 0.0)) \
			+ float(sc.get("step", 0.0)) * maxi(ranks, 1)
		desc = desc.replace("{v}", String.num(val, 2))
	return desc


# Nodes taken = points spent, at 1 point apiece.
static func points_spent(learned: Dictionary) -> int:
	var total := 0
	for id in learned:
		if int(learned[id]) > 0:
			total += 1
	return total


# ---------- can this node be taken ----------

# Returns {ok, why, pool}. "pool" names which purse pays:
#   "points" — a normal pick: the frontier row, or the capstone shelf.
#   "flex"   — a SECOND node in a row already picked. Only elite points buy
#              these, and only ever a second (never a third).
# "why" prefixes matter to the party screen's greying: Locked / Closed /
# Barred / Maxed.
static func can_learn(tree_nodes: Array, id: String, learned: Dictionary) -> Dictionary:
	var t := node_in_tree(tree_nodes, id)
	if t.is_empty():
		return {"ok": false, "why": "Unknown", "pool": ""}
	if int(learned.get(id, 0)) >= int(t["ranks"]):
		return {"ok": false, "why": "Maxed", "pool": ""}
	if t.has("locked_note"):
		return {"ok": false, "why": str(t["locked_note"]), "pool": ""}
	var row := int(t.get("row", 0))
	# Row 8, the capstone shelf: all seven rows picked, take exactly one,
	# any lane.
	if row == CAPSTONE_ROW:
		if has_capstone(tree_nodes, learned):
			var mine: Array = row_picks(tree_nodes, learned, CAPSTONE_ROW)
			var taken := node_in_tree(tree_nodes, String(mine[0]))
			return {"ok": false, "pool": "",
				"why": "Barred: %s is your capstone" % taken.get("name", mine[0])}
		var done := open_row(tree_nodes, learned)
		if done < CAPSTONE_ROW:
			return {"ok": false, "pool": "",
				"why": "Locked: pick row %d first (capstones open at 7/7)" % done}
		return {"ok": true, "why": "", "pool": "points"}
	# Rows 1-7. The frontier is the lowest unpicked row; nothing past it is
	# reachable, and nothing before it is reachable a second time except
	# with an elite point.
	var picks: Array = row_picks(tree_nodes, learned, row)
	if picks.is_empty():
		var frontier := open_row(tree_nodes, learned)
		if row > frontier:
			return {"ok": false, "pool": "",
				"why": "Locked: pick row %d first" % frontier}
		return {"ok": true, "why": "", "pool": "points"}
	if picks.size() >= MAX_PER_ROW:
		var others := PackedStringArray()
		for pid in picks:
			others.append(String(node_in_tree(tree_nodes, pid).get("name", pid)))
		return {"ok": false, "pool": "",
			"why": "Closed: row %d already holds %s" % [row, " and ".join(others)]}
	# One sibling taken: the door is shut, but an elite point forces it.
	var sib := node_in_tree(tree_nodes, String(picks[0]))
	return {"ok": true, "pool": "flex",
		"why": "Closed by %s — an elite point forces it open" % \
			sib.get("name", picks[0])}


# ---------- applying a tree ----------

# Applies a tree's learned talents onto a hero config. `member` is the run
# party entry the tree belongs to — it feeds payload conditions that ask
# what the hero can already cast; pass it whenever you have it.
static func apply_from_tree(cfg: Dictionary, tree_nodes: Array,
		learned: Dictionary, member: Dictionary = {}) -> void:
	var ctx := {"learned": learned, "member": member}
	for t in tree_nodes:
		var ranks := int(learned.get(t["id"], 0))
		if ranks < 1:
			continue
		apply_payload(cfg, t["payload"], ranks, ctx)


# Shared payload applicator (talents and shop runes). Stats missing from the
# config (e.g. talent counters) default to 0. `ranks` is 1 for every talent
# node since Batch AI; the parameter stays because runes pass it too.
#
# "condition" is THE one read site for payload gating (Batch AI §5): a
# payload that names a condition does nothing at all unless it holds.
#
# Batch AK added two sub-payload lists, because a node can have two halves
# that answer different questions:
#   "also"    — extra payloads applied alongside this one, each carrying its
#               OWN condition. That is how a node says "and if you took X
#               as well, this widens" without a second node id.
#   "upgrade" — extra payloads applied INSTEAD of granting, when the hero
#               already owns the new_ability from an earned pick. It cannot
#               be written as an `also` + owns_ability condition, because a
#               learned node's own grant is itself in ability_names() — the
#               only honest question is "was it already in the kit when the
#               tree ran", and the abilities list is what knows that. Both
#               call sites apply earned picks BEFORE the tree, deliberately.
static func apply_payload(cfg: Dictionary, payload: Dictionary, ranks: int,
		ctx: Dictionary = {}) -> void:
	if not condition_met(payload.get("condition", {}), ctx):
		return
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
		else:
			for up in payload.get("upgrade", []):
				apply_payload(cfg, up, ranks, ctx)
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
	# The node's second half, if it has one. Each entry is a full payload
	# and re-enters at the top, so its own `condition` is read at the same
	# single site — no second gate anywhere.
	for extra in payload.get("also", []):
		apply_payload(cfg, extra, ranks, ctx)
