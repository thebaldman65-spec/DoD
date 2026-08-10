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
		# Purpose-designed lanes (Batch N, 07-31), re-cut into 7 exclusive rows
		# plus a capstone row by Batch AI, and RE-AUTHORED AROUND OVERBURN by
		# Batch AR. Every one of the 24 ids survives and re-specs in place, so
		# saved picks migrate and NO SAVE VERSION MOVES; the changelog carries
		# the full old-name -> new-name mapping table.
		#
		# The spine is COMMITMENT. Overburn pays +2% damage per turn of Burn
		# standing on the enemy team and charges 1 Mana a turn for each of them
		# — the reward caps at +40% and THE COST DOES NOT. Every lane answers
		# the same question a different way: KINDLING lights more fires,
		# INFERNO stands in them longer, DETONATION cashes them in. Each row
		# asks one question — 1 the spark / 2 the spread / 3 what the heat
		# gives / 4 the tool / 5 what compounds / 6 what you accept / 7 the
		# trigger / 8 the capstone.
		#
		# MAGNITUDES ARE ADDITIVE, NOT RANKED. Several fields are fed by a rune
		# as well as by a node (accelerant_ranks, conflagration_ranks), so each
		# node writes its own magnitude in the units its read site adds up —
		# the node pays its number, the rune pays its number, and stacked they
		# pay the sum. That is the Batch AL repair rule applied up front.
		# --- Lane A: KINDLING — how fast you light up. ---
		{"id": "py_kindling", "name": "Cinder Trail", "ranks": 1, "lane": "Kindling", "row": 1,
			"desc": "Fireball's Burn lasts {v} turn longer — 4 turns instead of 3.",
			"scale": {"step": 1},
			"payload": {"stat": {"cinder_trail_ranks": 1}}},
		{"id": "py_accelerant", "name": "Accelerant", "ranks": 1, "lane": "Kindling", "row": 2,
			"desc": "Your Burn ticks deal +{v}% of Attack, on top of the base 6%.",
			"scale": {"step": 4},
			"payload": {"stat": {"accelerant_ranks": 4}}},
		{"id": "py_arson", "name": "Conflagration", "ranks": 1, "lane": "Kindling", "row": 3,
			"desc": "Flamewave applies +{v} turns of Burn, fresh fires and extensions alike.",
			"scale": {"step": 2},
			"payload": {"stat": {"conflagration_ranks": 2}}},
		# Backdraft lights NOTHING new — it only deepens what already burns,
		# which is what makes it a commitment button rather than a spreader.
		{"id": "py_melt", "name": "Backdraft", "ranks": 1, "lane": "Kindling", "row": 4,
			"desc": "New ability: Backdraft — add 2 turns of Burn to every burning enemy (20 Mana, 2.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Backdraft", "cost": 20,
				"special": "backdraft", "delay": 2.0, "anim": "attack03", "cooldown": 3,
				"perfect_id": "", "perfect_text": "3 turns each instead",
				"description": "Feed the fire air: every burning enemy\ngains 2 more turns of Burn. It starts\nno fires — it only deepens the ones\nalready lit, drain and all."}}},
		{"id": "py_ashes", "name": "Wildfire Spread", "ranks": 1, "lane": "Kindling", "row": 5,
			"desc": "Wildfire applies {v} turn of Burn to non-burning enemies before it consumes.",
			"scale": {"step": 1},
			"payload": {"stat": {"wildfire_spread": 1}}},
		{"id": "py_explosive", "name": "Explosive Force", "ranks": 1, "lane": "Kindling", "row": 6,
			"desc": "Critical hits with fire abilities extend the target's Burn by {v} turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"explosive_ranks": 2}}},
		{"id": "py_spreading", "name": "Chain Ignition", "ranks": 1, "lane": "Kindling", "row": 7,
			"desc": "An enemy that dies Burning splits its remaining Burn turns among the survivors.",
			"payload": {"stat": {"ember_wind": 1}}},
		# --- Lane B: INFERNO — how much heat you can stand. ---
		{"id": "py_pyromaniac", "name": "Fire Walker", "ranks": 1, "lane": "Inferno", "row": 1,
			"desc": "Overburn's Mana drain is reduced by {v}%.",
			"scale": {"step": 25},
			"payload": {"stat": {"fire_walker": 1}}},
		{"id": "py_invigorating", "name": "Invigorating Ashes", "ranks": 1, "lane": "Inferno", "row": 2,
			"desc": "Every Burn tick has a {v}% chance to restore 3% of max Mana.",
			"scale": {"step": 20},
			"payload": {"stat": {"invigorating_ranks": 20}}},
		{"id": "py_firebrand", "name": "Heat Shimmer", "ranks": 1, "lane": "Inferno", "row": 3,
			"desc": "Overburn's damage cap rises from +40% to +{v}%.",
			"scale": {"base": 40, "step": 20},
			"payload": {"stat": {"heat_haze_ranks": 20}}},
		# The re-specced Flame Shield. Every clause pushes the SAME way —
		# there is no defensive half left in it, and the retaliation burn
		# feeds the engine that is now costing him more to run.
		{"id": "py_flame_shield", "name": "Immolate", "ranks": 1, "lane": "Inferno", "row": 4,
			"desc": "New ability: Immolate — for 2 turns Overburn's damage cap is lifted entirely, its drain doubles, and anyone who strikes you is set Burning 3 turns (15 Mana, 1.5 int, 2cd).",
			"payload": {"new_ability": {"display_name": "Immolate", "cost": 15,
				"special": "immolate", "delay": 1.5, "anim": "attack03", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Holds a 3rd turn",
				"description": "Open the furnace: for 2 turns Overburn\nhas NO damage cap and its Mana drain\nDOUBLES, and whoever strikes you is\nset Burning (3 turns)."}}},
		{"id": "py_molten", "name": "Kiln-Forged", "ranks": 1, "lane": "Inferno", "row": 5,
			"desc": "+{v}% fire resistance, and Overburn's drain can never take you below 10 Mana.",
			"scale": {"step": 20},
			"payload": {"stat": {"kiln_forged": 1}}},
		{"id": "py_undying_flame", "name": "Ash Lung", "ranks": 1, "lane": "Inferno", "row": 6,
			"desc": "While Overburn's drain exceeds your Mana regeneration, you deal +{v}% damage.",
			"scale": {"step": 15},
			"payload": {"stat": {"ash_lung": 1}}},
		# Cauterise is the health risk put back, ONCE, as an opt-in. The drain
		# sits on Mana precisely so it is not a clock he carries; this node
		# lets a player choose to carry it anyway, which is a decision rather
		# than a tax — and the sharpest thing in the tree.
		{"id": "py_cauterize", "name": "Cauterise", "ranks": 1, "lane": "Inferno", "row": 7,
			"desc": "Drain that would take you below 0 Mana takes health instead, 1 HP per Mana — and your damage cap is removed while you are under 20 Mana.",
			"payload": {"stat": {"cauterise": 1}}},
		# --- Lane C: DETONATION — how big the trigger is. ---
		{"id": "py_shockwave", "name": "Focused Flame", "ranks": 1, "lane": "Detonation", "row": 1,
			"desc": "Detonation's Burn bonus rises from 250% to {v}%.",
			"scale": {"base": 250, "step": 75},
			"payload": {"stat": {"focused_flame": 1}}},
		{"id": "py_supernova", "name": "Pressure Cooker", "ranks": 1, "lane": "Detonation", "row": 2,
			"desc": "Detonation deals +{v} Break damage to a Burning target.",
			"scale": {"step": 25},
			"payload": {"stat": {"pressure_cooker": 1}}},
		{"id": "py_implosion", "name": "Aftershock", "ranks": 1, "lane": "Detonation", "row": 3,
			"desc": "Detonation re-applies {v} turns of Burn to the target after consuming.",
			"scale": {"step": 2},
			"payload": {"stat": {"aftershock": 2}}},
		# Out of the vault (Batch AR). No cooldown by design: 45 Mana under a
		# drain, arriving 6.0 down the initiative bar, is the whole limiter.
		{"id": "py_focused", "name": "Pyroblast", "ranks": 1, "lane": "Detonation", "row": 4,
			"desc": "New ability: Pyroblast — a slow, enormous bolt for 55% of Attack, +50% against a Burning target (45 Mana, 6.0 int).",
			"payload": {"new_ability": {"display_name": "Pyroblast", "cost": 45,
				"dmg_type": "fire", "damage": 55, "pressure": 25, "delay": 6.0,
				"anim": "attack03", "cooldown": 0,
				"perfect_id": "", "perfect_text": "",
				"description": "The long cast: 55% of Attack in fire,\nand HALF AGAIN against a target that\nis already Burning. It consumes\nnothing — it simply asks you to have\nlit the fire first."}}},
		{"id": "py_seeding", "name": "Crucible", "ranks": 1, "lane": "Detonation", "row": 5,
			"desc": "Consuming Burn refunds {v} Mana per turn instead of 1.",
			"scale": {"base": 1, "step": 1},
			"payload": {"stat": {"crucible": 1}}},
		# No field and no read site: it SETS the ability's own cooldown, the
		# way Relentless sets Hack and Slash's bleed_chance. Ability upgrades
		# run after the tree, so a Quickened Detonation still gets its cut.
		{"id": "py_rekindle", "name": "Twin Detonation", "ranks": 1, "lane": "Detonation", "row": 6,
			"desc": "Detonation's cooldown drops to {v}.",
			"scale": {"step": 1},
			"payload": {"ability": "Detonation", "set": {"cooldown": 1}}},
		{"id": "py_warm_glow", "name": "Total Commitment", "ranks": 1, "lane": "Detonation", "row": 7,
			"desc": "Detonation consumes Burn from the target and the two enemies adjacent to it.",
			"payload": {"stat": {"total_commitment": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "py_firestorm", "name": "Firestorm", "ranks": 1, "lane": "Kindling", "row": 8,
			"capstone": true,
			"desc": "New ability: Firestorm — rain fire on 6-8 random enemies for 12% of Attack each, applying Burn (30 Mana, 3.5 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Firestorm", "cost": 30,
				"dmg_type": "fire", "damage": 12, "pressure": 8, "random_hits": 6,
				"perfect_extra_hit": false, "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"applies_status": {"id": "burn", "turns": 2},
				"perfect_id": "", "perfect_text": "Every enemy takes an even share.",
				"description": "The sky ignites: 6-8 bolts rake random\nenemies for 12% of Attack, each one\nsetting its victim Burning (2 turns\nper bolt — repeats stack). Twelve to\nsixteen turns of drain in one cast."}}},
		# Out of the vault (Batch AR), minus its Empower clause — Empower is a
		# named mechanic belonging to the Holy Cleric's Mercy system, and this
		# ability never should have granted it.
		{"id": "py_rebirth", "name": "Phoenix Rebirth", "ranks": 1, "lane": "Inferno", "row": 8,
			"capstone": true,
			"desc": "New ability: Phoenix Rebirth — sacrifice 25% of current health and your Mana returns to full (2.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Phoenix Rebirth", "cost": 0,
				"special": "phoenix", "delay": 2.0, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "Costs 15% of health instead",
				"description": "Burn your own life for fuel: pay 25%\nof current health and your Mana\nreturns to FULL. Under Overburn a full\npool is exactly the relief the drain\ndenies you — and the price is a choice\nyou make, not a clock you carry."}}},
		{"id": "py_hellfire", "name": "Cataclysm", "ranks": 1, "lane": "Detonation", "row": 8,
			"capstone": true,
			"desc": "Detonation consumes the Burn from EVERY burning enemy and adds all of it to the hit.",
			"payload": {"stat": {"cataclysm": 1}}},
	],
	"cryomancer": [
		# BATCH AS — re-authored around GLACIAL HOLD: control is deciding WHEN
		# the enemy acts, not how hard it hits. SHATTERPOINT is renamed THAW,
		# because a control spec whose payoff lane was burst (four crit dials)
		# was a damage spec wearing a coat. Winter and Deep Freeze keep theirs.
		#
		# EVERY ONE OF THE 24 IDS SURVIVES AND RE-SPECS IN PLACE, so saved picks
		# migrate and NO SAVE VERSION MOVES. Ten ids changed lane — legal, and
		# the full old->new mapping table is in the changelog.
		#
		# EACH ROW ASKS ONE QUESTION: 1 the opening / 2 the spread / 3 what the
		# slow is worth / 4 the tool / 5 the hold / 6 the price / 7 the release /
		# 8 the capstone.
		#
		# MAGNITUDES ARE ADDITIVE, NOT RANKED (Batch AS §5): every counter below
		# writes its own magnitude in the units its read site sums. Under the old
		# `1 x step` form a rune writing the same field silently inherited the
		# node's multiplier — four Cryomancer spec runes ride these counters.
		# --- Lane WINTER — buy more time. ---
		{"id": "cr_hungering", "name": "Hungering Cold", "ranks": 1, "lane": "Winter", "row": 1,
			"desc": "Chilled enemies deal {v}% less damage per stack of Chilled.",
			"scale": {"step": 3},
			"payload": {"stat": {"hungering_ranks": 3}}},
		# Re-spec (was Empowered Frostbolt, a flat damage add on the same
		# ability): the free pump doubles instead of hitting harder.
		{"id": "cr_emp_frostbolt", "name": "Deep Chill", "ranks": 1, "lane": "Winter", "row": 2,
			"desc": "Frostbolt applies {v} stacks of Chilled instead of 1.",
			"scale": {"base": 1, "step": 1},
			"payload": {"stat": {"deep_chill_ranks": 1}}},
		{"id": "cr_grasp", "name": "Winter's Grasp", "ranks": 1, "lane": "Winter", "row": 3,
			"desc": "At the start of each of his turns, {v} random Chilled enemies gain a stack.",
			"scale": {"step": 2},
			"payload": {"stat": {"grasp_ranks": 2}}},
		{"id": "cr_rime", "name": "Rime", "ranks": 1, "lane": "Winter", "row": 4,
			"desc": "New ability: Rime — inflicts Frostbite (-50% healing received, 2 turns); for 3 turns, every stack of Chilled the target gains also chills one other random enemy (25 Mana, 3.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Rime", "cost": 25,
				"special": "rime", "delay": 3.0, "anim": "attack02", "cooldown": 3,
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Hoarfrost takes root: Frostbites the\ntarget (-50% healing received, 2 turns);\nfor 3 turns, every stack of Chilled\nthis enemy gains also chills one\nother random enemy."}}},
		{"id": "cr_icy_resolve", "name": "Icy Resolve", "ranks": 1, "lane": "Winter", "row": 5,
			"desc": "Rime lasts {v} additional turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"icy_resolve_ranks": 2}}},
		# Re-spec (was a Daze roll on Blizzard, in the wrong lane): the storm
		# stops being a chance at a status and becomes three quarters of a hold
		# across the WHOLE field.
		{"id": "cr_whiteout", "name": "Whiteout", "ranks": 1, "lane": "Winter", "row": 6,
			"desc": "Blizzard applies {v} stacks of Chilled to every enemy instead of 1-2.",
			"scale": {"step": 3},
			"payload": {"stat": {"whiteout_ranks": 3}}},
		# The roll is GONE, deliberately: a node that decides whether the spec's
		# win condition happens this turn must not be a coin flip.
		{"id": "cr_splinter", "name": "Splintering Shards", "ranks": 1, "lane": "Winter", "row": 7,
			"desc": "Razor Ice ALWAYS strikes a fourth time — one cast is a freeze.",
			"payload": {"stat": {"splinter_ranks": 1}}},
		# --- Lane DEEP FREEZE — spend it on denial. ---
		{"id": "cr_frostbite", "name": "Brittle Ice", "ranks": 1, "lane": "Deep Freeze", "row": 1,
			"desc": "Held enemies are {v}% likelier to be struck by a critical hit, party-wide.",
			"scale": {"step": 6},
			"payload": {"stat": {"frostbite_ranks": 6}}},
		{"id": "cr_bitter", "name": "Bitter Cold", "ranks": 1, "lane": "Deep Freeze", "row": 2,
			"desc": "Freezing an enemy applies {v} stacks of Chilled to every other enemy.",
			"scale": {"step": 2},
			"payload": {"stat": {"bitter_cold_ranks": 2}}},
		# THE NODE §0 EXISTS FOR: at 10 points a stack this is what makes the
		# initiative bar visibly move, and it only works because the reschedule
		# reads effective_speed() (audited in Batch AS — it always has).
		{"id": "cr_frigid", "name": "Frigid Grip", "ranks": 1, "lane": "Deep Freeze", "row": 3,
			"desc": "Every stack of Chilled slows {v}% harder.",
			"scale": {"step": 10},
			"payload": {"stat": {"frigid_ranks": 10}}},
		# Re-spec (was Numbing Veil, a miss chance on Chilled enemies — denial
		# by attrition; this is denial by decision). The counter it used to
		# write is RUNE-ONLY now and its read site is kept.
		{"id": "cr_numbing", "name": "Glacial Prison", "ranks": 1, "lane": "Deep Freeze", "row": 4,
			"desc": "New ability: Glacial Prison — Freeze the target outright, whatever its stacks (25 Mana, 2.5 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Glacial Prison", "cost": 25,
				"special": "glacial_prison", "delay": 2.5, "anim": "attack03", "cooldown": 4,
				"perfect_id": "", "perfect_text": "",
				"description": "The air closes like a fist: the target\nis Frozen OUTRIGHT, whatever its\nChilled stacks, and joins the Glacial\nHold. Bosses still resist until Broken."}}},
		# FORCED ASSIGNMENT, reported not hidden (Batch AS §9): Second Prison
		# has no ancestor in this tree. cr_frost_ward held a damage reduction
		# against Chilled attackers — the closest thing to "fewer enemies get to
		# swing at you", and a slot had to hold it.
		{"id": "cr_frost_ward", "name": "Second Prison", "ranks": 1, "lane": "Deep Freeze", "row": 5,
			"desc": "He can hold TWO enemies at once instead of one.",
			"payload": {"stat": {"second_prison": 1}}},
		# Re-spec, NOT a reprice: it used to extend Frozen's duration, which an
		# indefinite hold makes meaningless. Now the hold DOES something while
		# it lasts — denial converts into the party's Break.
		{"id": "cr_cold_snap", "name": "Cold Snap", "ranks": 1, "lane": "Deep Freeze", "row": 6,
			"desc": "A held enemy's Break meter fills {v} at the start of each of his turns.",
			"scale": {"step": 15},
			"payload": {"stat": {"cold_snap_ranks": 15}}},
		{"id": "cr_glacial", "name": "Glacial Economy", "ranks": 1, "lane": "Deep Freeze", "row": 7,
			"desc": "Freezing an enemy restores {v}% of his maximum Mana.",
			"scale": {"step": 15},
			"payload": {"stat": {"glacial_ranks": 15}}},
		# --- Lane THAW — spend it on the window. ---
		{"id": "cr_hypothermia", "name": "Hypothermia", "ranks": 1, "lane": "Thaw", "row": 1,
			"desc": "Enemies take {v}% more damage per stack of Chilled.",
			"scale": {"step": 3},
			"payload": {"stat": {"hypothermia_ranks": 3}}},
		# Re-spec (was Freezing Advance, "+damage on the enemy you just froze"):
		# the same question asked of the hold instead of the moment.
		{"id": "cr_freezing", "name": "Killing Frost", "ranks": 1, "lane": "Thaw", "row": 2,
			"desc": "The held-enemy damage bonus rises from +15% to +{v}%.",
			"scale": {"base": 15, "step": 15},
			"payload": {"stat": {"killing_frost": 15}}},
		{"id": "cr_crystal", "name": "Crystal Edge", "ranks": 1, "lane": "Thaw", "row": 3,
			"desc": "Ice Lance deals an extra {v}% of Attack per Chilled stack (on top of the base 5%).",
			"scale": {"step": 15},
			"payload": {"stat": {"crystal_edge_ranks": 15}}},
		# Re-spec (was Lance Focus, a Mana discount on Ice Lance — the closest
		# remaining Ice Lance node, and a forced-ish assignment reported as one).
		{"id": "cr_lance_focus", "name": "Cryoclasm", "ranks": 1, "lane": "Thaw", "row": 4,
			"desc": "New ability: Cryoclasm — move the hold and its remaining stacks onto a different enemy (20 Mana, 2.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Cryoclasm", "cost": 20,
				"special": "cryoclasm", "delay": 2.0, "anim": "attack02", "cooldown": 3,
				"perfect_id": "", "perfect_text": "",
				"description": "Control as a verb: the prison and the\ncold inside it are torn loose and\ndriven onto a DIFFERENT enemy. The\nlockdown relocates without being\nspent, so no release payoff fires."}}},
		{"id": "cr_piercing", "name": "Piercing Ice", "ranks": 1, "lane": "Thaw", "row": 5,
			"desc": "Ice Lance gains {v}% critical strike damage.",
			"scale": {"step": 30},
			"payload": {"stat": {"piercing_ice_ranks": 30}}},
		# Re-spec in place: it rode Ice Lance CRITS, it rides Ice Lance's
		# RELEASE now — and because it lives in _hold_release, Shatter and an
		# evicted prison inherit it with no second implementation.
		{"id": "cr_razor_hone", "name": "Honed Shards", "ranks": 1, "lane": "Thaw", "row": 6,
			"desc": "A release applies {v} stacks of Chilled to the thawed enemy.",
			"scale": {"step": 3},
			"payload": {"stat": {"honed_shards_ranks": 3}}},
		# Re-spec (was Icy Veins, "an Ice Lance kill empowers the next lance" —
		# the Lance's payoff paying forward, which is what this does too). The
		# purest thing in the tree: the release is paid out in TIME.
		{"id": "cr_icy_veins", "name": "Shattered Tempo", "ranks": 1, "lane": "Thaw", "row": 7,
			"desc": "Releasing a hold pushes every OTHER enemy back {v} on the initiative timeline.",
			"scale": {"step": 2},
			"payload": {"stat": {"shattered_tempo": 2.0}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# Re-specced into the MASS RELEASE (Batch AS): it used to detonate the
		# Chilled; it breaks every prison at once now. BATCH AT RE-SPECCED WHAT
		# IT SCALES ON — TIME HELD, NOT STACKS HELD. Under an indefinite hold
		# every prison sits pinned at 4 stacks, so the old reading made Shatter a
		# dearer Ice Lance and AS's smoke never cast it once. Charging on turns
		# resolves that without touching either capstone, and it turns the hold
		# from a binary state into a CHARGE the player decides when to spend.
		{"id": "cr_shatter", "name": "Shatter", "ranks": 1, "lane": "Thaw", "row": 8,
			"capstone": true,
			"desc": "New ability: Shatter — release EVERY hold at once for 10% of Attack per TURN it spent held, capped at 12 turns (30 Mana, 4.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Shatter", "cost": 30,
				"dmg_type": "frost", "damage": 10, "pressure": 10, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Cooldown becomes 4 instead",
				"description": "Every prison breaks at once: each held\nenemy takes 10% of Attack PER TURN it\nspent frozen (max 12), and is\nreleased. Release now for a modest\nhit, or hold longer and hit harder."}}},
		# Re-specced (Batch AS): "freezing no longer reduces stacks" is
		# redundant under an indefinite hold, so the capstone buys CAPACITY.
		{"id": "cr_absolute", "name": "Absolute Zero", "ranks": 1, "lane": "Deep Freeze", "row": 8,
			"capstone": true,
			"desc": "No limit on how many enemies he can hold at once.",
			"payload": {"stat": {"absolute_zero": 1}}},
		{"id": "cr_eternal", "name": "Eternal Winter", "ranks": 1, "lane": "Winter", "row": 8,
			"capstone": true,
			"desc": "EVERY enemy gains 1 stack of Chilled at the start of each of his turns.",
			"payload": {"stat": {"eternal_winter": 1}}},
	],
	"arcanist": [
		# Purpose-designed lanes (Batch P, 07-31); Batch AI cut them into 7
		# exclusive rows + a capstone row; BATCH AT re-authored all 24 at row
		# pricing around ESCALATION — nothing early, everything late. EVERY ID
		# SURVIVES and re-specs in place, so saved picks migrate and no save
		# version moves. The full old->new mapping is in the changelog.
		# THE LANE FORMERLY CALLED CONTROL IS **ENTROPY**: after Batch AS,
		# "Control" is the Cryomancer's identity word, and the lane was never
		# about control anyway — it turns his own danger into fuel.
		# MAGNITUDES ARE ADDITIVE, NOT RANKED: every counter writes its own
		# magnitude in the units its read site sums (AR/AS's form).
		# --- Lane RESONANCE — build higher, sooner. ---
		# Re-spec in place: it already WAS Harmonics, and Arcane Explosion is
		# the free build engine, so the lane opens on the button he presses
		# when he has nothing better to do.
		{"id": "ar_harmonics", "name": "Harmonics", "ranks": 1, "lane": "Resonance", "row": 1,
			"desc": "Arcane Explosion builds {v} Resonance instead of 1.",
			"scale": {"base": 1, "step": 1},
			"payload": {"stat": {"harmonics_ranks": 1}}},
		# Re-spec (was Arcane Mastery, +1%/rank crit per stack — which the
		# passive now pays as a flat 1% per stack all by itself). The node that
		# owned "crit x Resonance" owns it still: a crit BUILDS more now.
		{"id": "ar_mastery", "name": "Attunement", "ranks": 1, "lane": "Resonance", "row": 2,
			"desc": "A critical hit builds {v} Resonance instead of 2.",
			"scale": {"base": 2, "step": 1},
			"payload": {"stat": {"attunement_crit": 1}}},
		# Re-spec in place: it paid Mana AT the ceiling, and there is no
		# ceiling — so it pays for the stacks he is HOLDING instead.
		{"id": "ar_charged", "name": "Charged Bolts", "ranks": 1, "lane": "Resonance", "row": 3,
			"desc": "Every damaging cast restores {v}% of maximum Mana per 4 stacks held.",
			"scale": {"step": 5},
			"payload": {"stat": {"charged_bolts_ranks": 5}}},
		# RE-SPECCED, NOT REPRICED. Raising a cap to 8 is meaningless once
		# there is no cap; compounding the ramp is the escalation version of
		# the same button. At ten stacks it grants five.
		# AUTHORED FALLBACK (Batch AU §1): Overcharge is in SPEC_POOLS, so a zone
		# boss can hand it over before this node is reached. Taking the node on
		# an Overcharge he already owns buys a SECOND use per battle rather
		# than doing nothing — the node still answers its own question ("how
		# much more storm can I feed on?"), just in the other currency.
		{"id": "ar_overcharge", "name": "Overcharge", "ranks": 1, "lane": "Resonance", "row": 4,
			"desc": "New ability: Overcharge — once per battle, immediately gain Resonance equal to HALF your current stacks (20 Mana, 1.5 int, 5cd). If you already have it, it becomes usable TWICE per battle.",
			"payload": {"new_ability": {"display_name": "Overcharge", "cost": 20,
				"special": "overcharge", "delay": 1.5, "anim": "attack02", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Gain your FULL current stacks instead",
				"description": "Feed the storm on itself: gain\nResonance equal to half the stacks you\nalready hold. Once per battle — the\nhigher you are, the more it pays."},
				"upgrade": [{"stat": {"overcharge_extra": 1}}]}},
		# Re-spec (was +1 maximum Resonance — a ceiling that no longer exists).
		# Straightforward runway, paid on the turn rather than the cast.
		{"id": "ar_core", "name": "Resonant Core", "ranks": 1, "lane": "Resonance", "row": 5,
			"desc": "The first damaging cast of each of his turns builds {v} additional Resonance.",
			"scale": {"step": 1},
			"payload": {"stat": {"resonant_core_ranks": 1}}},
		# Re-spec in place: every third crit used to hit harder, it BUILDS now.
		# The old counter (critical_mass_ranks) is RUNE-ONLY and its read site
		# is kept — the Rune of the Wide Current still pays the old clause.
		{"id": "ar_critical_mass", "name": "Critical Mass", "ranks": 1, "lane": "Resonance", "row": 6,
			"desc": "Every third critical hit builds {v} Resonance.",
			"scale": {"step": 4},
			"payload": {"stat": {"critical_mass_stacks": 4}}},
		# THE LANE'S THESIS, and re-specced from Unlimited Power (whose whole
		# premise was overflow AT a cap): the curve gets steeper the higher it
		# already is.
		{"id": "ar_unlimited", "name": "Cascade", "ranks": 1, "lane": "Resonance", "row": 7,
			"desc": "At 10 or more stacks, every damaging cast builds {v} additional Resonance.",
			"scale": {"step": 1},
			"payload": {"stat": {"cascade_stacks": 1}}},
		# --- Lane OVERLOAD — each stack worth more, for a bigger bill. ---
		# Re-spec in place: it deepened a LINEAR per-stack term; it deepens the
		# COMPOUNDING step now. NOTE the units — conduit_step is percentage
		# POINTS on the curve's step, and it is a FLOAT, so it must never be
		# named "_ranks" (Runes.STAT_INT_KEYS would coerce 0.5 to 0).
		{"id": "ar_conduit", "name": "Conduit", "ranks": 1, "lane": "Overload", "row": 1,
			"desc": "The damage curve's step rises from 1.5% to {v}% per stack.",
			"scale": {"base": 1.5, "step": 0.5},
			"payload": {"stat": {"conduit_step": 0.5}}},
		# Re-spec in place (it was Cannon AND Wrath, +5%/rank each way): the
		# Cannon alone now, and the bill is a SET not an add — 15% -> 25%.
		{"id": "ar_volatility", "name": "Volatility", "ranks": 1, "lane": "Overload", "row": 2,
			"desc": "Arcane Cannon deals +{v}% damage, and its recoil rises from 15% to 25%.",
			"scale": {"step": 30},
			"payload": {"stat": {"volatility_ranks": 30, "volatility_recoil": 25}}},
		# Re-spec in place: it was a CHANCE to echo for 25%; it is a certain
		# echo for 40% now. A coin flip on a crit is variance on variance.
		{"id": "ar_temporal", "name": "Temporal Rift", "ranks": 1, "lane": "Overload", "row": 3,
			"desc": "A critical hit echoes for {v}% of its damage against a random enemy.",
			"scale": {"step": 40},
			"payload": {"stat": {"temporal_ranks": 40}}},
		{"id": "ar_suppressing", "name": "Suppressing Fire", "ranks": 1, "lane": "Overload", "row": 4,
			"desc": "Each bolt of Arcane Barrage deals {v}% of Attack more than the previous one.",
			"scale": {"step": 2},
			"payload": {"stat": {"suppressing_ranks": 2}}},
		# Re-spec in place: it deepened Cannon's per-stack DAMAGE, which §2
		# takes off the ability entirely (the passive does that now). Break is
		# a different axis, so the node moves onto the axis that survives.
		{"id": "ar_cannoneer", "name": "Cannoneer", "ranks": 1, "lane": "Overload", "row": 5,
			"desc": "Arcane Cannon's Break damage rises from 5 to {v} per Resonance stack.",
			"scale": {"base": 5, "step": 4},
			"payload": {"stat": {"cannoneer_ranks": 4}}},
		{"id": "ar_barrister", "name": "Barrage Master", "ranks": 1, "lane": "Overload", "row": 6,
			"desc": "Arcane Barrage fires {v} additional bolts.",
			"scale": {"step": 3},
			"payload": {"ability": "Arcane Barrage", "add": {"random_hits": 3}}},
		# FORCED-ISH ASSIGNMENT, reported not hidden (Batch AT §9): the node
		# was Mindfulness ("all your cooldowns tick down 1 extra turn every N
		# turns"), and cooldown acceleration is the closest surviving intent to
		# "the payoff nuke stops having a cooldown". It crosses Control ->
		# Overload, which is legal. mindfulness_ranks is RUNE-ONLY now and its
		# read site is kept (the Rune of the Unquiet Mind still pays it).
		{"id": "ar_mindfulness", "name": "Terminal Velocity", "ranks": 1, "lane": "Overload", "row": 7,
			"desc": "At {v} or more Resonance, Death Ray has no cooldown.",
			"scale": {"step": 15},
			"payload": {"stat": {"terminal_velocity": 15}}},
		# --- Lane ENTROPY — turn the danger into fuel. Losing Stabilize cost
		# him his Mana valve as well as his defence, and that is intended: his
		# Mana comes from being hurt now, so the more dangerous his own build
		# gets, the more it feeds itself. ---
		{"id": "ar_conversion", "name": "Conversion", "ranks": 1, "lane": "Entropy", "row": 1,
			"desc": "{v}% of damage taken is paid as Mana instead of health.",
			"scale": {"step": 30},
			"payload": {"stat": {"conversion_ranks": 30}}},
		# Re-spec in place: the threshold is fixed at 35% now (it used to RISE
		# with ranks off a base of 20) and the payout is 4 stacks, not 1.
		{"id": "ar_on_edge", "name": "On the Edge", "ranks": 1, "lane": "Entropy", "row": 2,
			"desc": "Surviving an attack below {v}% health builds 4 Resonance.",
			"scale": {"step": 35},
			"payload": {"stat": {"on_edge_threshold": 35.0, "on_edge_stacks": 4}}},
		{"id": "ar_meltdown", "name": "Feedback Loop", "ranks": 1, "lane": "Entropy", "row": 3,
			"desc": "{v}% of recoil damage is paid as Mana instead of health.",
			"scale": {"step": 30},
			"payload": {"stat": {"feedback_ranks": 30}}},
		# KEPT DELIBERATELY, where Arcane Ward and Still Mind were not: a cap
		# on any single hit is what makes a COMPOUNDING death curve survivable
		# enough to be interesting rather than random.
		{"id": "ar_stable", "name": "Stable Alignment", "ranks": 1, "lane": "Entropy", "row": 4,
			"desc": "No single attack can take more than {v}% of your maximum health.",
			"scale": {"step": 25},
			"payload": {"stat": {"stable_ranks": 25}}},
		# FORCED ASSIGNMENT, reported not hidden (Batch AT §9): Backlash has no
		# ancestor in this tree. ar_still held Still Mind, whose entire subject
		# (Stabilize's floor) left the opening three — a slot had to hold it,
		# and this is the one whose old design died most completely.
		{"id": "ar_still", "name": "Backlash", "ranks": 1, "lane": "Entropy", "row": 5,
			"desc": "Resonance also builds when he takes damage: {v} stack per hit received.",
			"scale": {"step": 1},
			"payload": {"stat": {"backlash_stacks": 1}}},
		# Re-spec (was Mana Attunement, "Mana every time you gain a stack"):
		# the same passive Mana income, paid on the damage he deals instead of
		# the stacks he banks — because he can no longer vent for Mana.
		{"id": "ar_attunement", "name": "Siphon", "ranks": 1, "lane": "Entropy", "row": 6,
			"desc": "{v}% of all damage he deals is restored as Mana.",
			"scale": {"step": 20},
			"payload": {"stat": {"siphon_ranks": 20}}},
		# THE LANE'S THESIS, re-specced from Arcane Ward (which softened the
		# per-stack penalty): the reward for escalating is that escalating
		# stops killing you — and it only switches on once he is deep enough
		# to need it.
		{"id": "ar_ward", "name": "Event Horizon", "ranks": 1, "lane": "Entropy", "row": 7,
			"desc": "While at {v} or more Resonance, no single attack can reduce him below 1 health.",
			"scale": {"step": 15},
			"payload": {"stat": {"event_horizon": 15}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# BATCH AU §4 — THE TWO CAPSTONES WERE IN THE WRONG LANES AND ARE
		# UNCROSSED HERE. Doubling the damage STEP is the Overload lane's entire
		# thesis, so it went to Magi's Wrath; this one takes BUILD RATE, which
		# is the Resonance lane's.
		# WHY THE NUMBERS LOOK SMALL, AND WHY SMALL IS CORRECT: damage is
		# step x N(N+1)/2, so it is QUADRATIC in the stack count and only
		# LINEAR in the step (AT measured it). Doubling the build rate roughly
		# QUADRUPLES the payout while doubling the step merely doubles it — a
		# capstone that doubled the build rate would be twice the capstone
		# sitting beside it on the same shelf. It is also deliberately
		# SELF-SCALING: the passive grants +1% crit per stack, so crits rise
		# with the curve and the build rate feeds itself LATE without
		# compounding from turn one.
		# CRIT BUILDING IS ADDITIVE: Attunement (row 2) sets it to 3, this adds
		# 2 on top for 5. Not the higher of the two, and summed at exactly one
		# read site in battle.gd.
		{"id": "ar_singularity", "name": "Singularity", "ranks": 1, "lane": "Resonance", "row": 8,
			"capstone": true,
			"desc": "Critical hits build 2 ADDITIONAL Resonance, and every enemy killed builds 3.",
			"payload": {"stat": {"singularity_crit_build": 2, "singularity_kill_build": 3}}},
		# The existing granted ability, per Batch AT §2's per-stack removal: its
		# +4% per stack is GONE (the passive does that now, and leaving it on
		# would square the compounding). BD = 2.5 x stacks and the recoil stay,
		# and IT STILL GETS NO PER-STACK DAMAGE TERM BACK — that is the squaring
		# trap AT exists around.
		# BATCH AU §4: IT ALSO DOUBLES THE DAMAGE CURVE'S STEP, 1.5% -> 3%. That
		# clause used to be Singularity's, in the Resonance lane, which is
		# backwards — "each stack worth more" is what the Overload lane sells.
		# The doubling rides `also`, so it lands whether the ability is granted
		# here or was already earned.
		# NO FALLBACK, DELIBERATELY (Batch AU §1): the passive half is why. A
		# hero who already owns Magi's Wrath still gets the step-doubling out
		# of this node, so it is not dead and owes nothing extra.
		{"id": "ar_wrath", "name": "Magi's Wrath", "ranks": 1, "lane": "Overload", "row": 8,
			"capstone": true,
			"desc": "New ability: Magi's Wrath — 15% of Attack as arcane to ALL enemies; BD = 2.5 x stacks; recoil 15% of damage dealt, -3% per enemy hit (30 Mana, 4.0 int, 4cd). ALSO doubles the damage curve's step: 1.5% to 3% per stack.",
			"payload": {"new_ability": {"display_name": "Magi's Wrath", "cost": 30,
				"dmg_type": "arcane", "damage": 15, "pressure": 0, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 4, "recoil_base": 0.15,
				"perfect_id": "", "perfect_text": "Costs 3.5 initiative instead",
				"description": "The storm unchained: rakes the whole\nenemy team for 15% of Attack.\nBD = 2.5 x stacks. Recoil 15% of\ndamage dealt, -3% per enemy hit."},
				"no_fallback": true,
				"also": [{"stat": {"wrath_step_double": 1}}]}},
		# RE-SPECCED FROM MASTER OF MOMENTS, whose free venting died with
		# Stabilize — it was the most anti-escalation node in the game. The id
		# is kept; the name had to change because it no longer described
		# anything. The natural end of the lane: his self-harm stops being harm.
		{"id": "ar_timelord", "name": "Perfect Conversion", "ranks": 1, "lane": "Entropy", "row": 8,
			"capstone": true,
			"desc": "ALL recoil and ALL self-inflicted damage is paid as Mana instead of health.",
			"payload": {"stat": {"perfect_conversion": 1}}},
	],
	"holy": [
		# BATCH AV — HOLY: REVERSAL. Purpose-designed lanes (Batch J, 07-30),
		# re-cut into 7 exclusive rows + a capstone row by Batch AI, and now
		# RE-AUTHORED around one spine: NOTHING IS FINAL, NO LOSS PERMANENT.
		# EVERY ONE OF THE 24 IDS SURVIVES AND RE-SPECS IN PLACE — no new ids,
		# none deleted, NO SAVE VERSION MOVE (still v7). The old->new mapping
		# table is in the changelog.
		#
		# THE REPRICING IS THE POINT. Her magnitudes were the worst-priced of
		# the twelve: a 5% dispel chance, 1% of maximum Mana, 1% of an ally's
		# health, a threshold moved 50 -> 53. Those were rank-1 values in a
		# three-rank tree, and as whole ROWS costing two other options they
		# were not decisions. Where the Mage trees needed 3x, hers needed 4-5x.
		# MERCY ITSELF IS UNTOUCHED BY DESIGNER DECISION — the generator, the
		# +5%/stack, the spend costs, the Empower surcharge and the
		# perfect-forgo all stand exactly as they were. The tree moves around it.
		#
		# MAGNITUDES ARE ADDITIVE, NOT RANKED (AR/AS/AT's form): every counter
		# writes its own magnitude in the units its read site sums, so a node's
		# 15 and a rune's 3 each pay what they advertise, alone and stacked.
		# Two counters are the INCREASE on a base the passive already pays
		# (`heavenly_step` on Mercy's 5%, `guardian_step` on the 50% window) —
		# AT's `cannoneer_ranks` precedent, and the only honest additive form
		# when the base exists without the node.
		#
		# --- Lane A: RADIANCE — throughput: bigger heals, cheaper heals,
		# less waste. ---
		{"id": "hl_triage", "name": "Triage", "ranks": 1, "lane": "Radiance", "row": 1,
			"desc": "Instant heals can CRIT (x1.5, using your critical strike chance), and all your healing is increased by 15%.",
			"payload": {"stat": {"triage_heal": 15}}},
		# Re-priced AND widened: 5 Mana off Renewal alone was a rounding error
		# on a 20-Mana cast. Both of her Mana casts now, 10 each.
		{"id": "hl_soothe", "name": "Soothing Touch", "ranks": 1, "lane": "Radiance", "row": 2,
			"desc": "Heal and Renewal each cost 10 less Mana.",
			"payload": {"ability": "Heal", "add": {"cost": -10},
				"also": [{"ability": "Renewal", "add": {"cost": -10}}]}},
		{"id": "hl_on_mend", "name": "On the Mend", "ranks": 1, "lane": "Radiance", "row": 3,
			"desc": "Renewal ticks have a 35% chance to dispel one harmful effect from the bearer.",
			"payload": {"stat": {"on_mend_pct": 35}}},
		# HOMED HERE from the capstone shelf (id hl_divine_plea, same lane).
		# AUTHORED FALLBACK (AU §1): she can earn Divine Plea from a boss, and
		# a node granting what she already holds must not be dead — it makes
		# the cast cost 1 Mercy instead of 2.
		{"id": "hl_divine_plea", "name": "Divine Plea", "ranks": 1, "lane": "Radiance", "row": 4,
			"desc": "New ability: Divine Plea — spend 2 Mercy to FULLY heal an ally; Empower (+1 Mercy): also cleanse all debuffs and Hallow them against new ones for 3 turns (3.0 int, 2cd). If Divine Plea was already earned, it costs 1 Mercy instead of 2.",
			"payload": {"grant_ability": "Divine Plea",
				"upgrade": [{"ability": "Divine Plea", "set": {"faith_cost": 1}}]}},
		# Re-priced: -1 turn on a 1-turn cooldown was the whole cooldown, said
		# small. Say it plainly, and give the Hymn the turn as well.
		{"id": "hl_swift", "name": "Swift Mending", "ranks": 1, "lane": "Radiance", "row": 5,
			"desc": "Heal has no cooldown at all, and Hymn of Hope's drops by 1.",
			"payload": {"ability": "Heal", "set": {"cooldown": 0},
				"also": [{"ability": "Hymn of Hope", "add": {"cooldown": -1}}]}},
		# One half of the wasted-healing fork: crit investment pays out
		# sideways — it needs Triage to fire at all.
		{"id": "hl_brilliance", "name": "Radiant Cascade", "ranks": 1, "lane": "Radiance", "row": 6,
			"desc": "A CRITICAL heal also splashes 75% of its value onto the lowest-health other ally.",
			"payload": {"stat": {"cascade_pct": 75}}},
		# The other half: raw output spills over instead of being wasted.
		{"id": "hl_overflow", "name": "Overflow", "ranks": 1, "lane": "Radiance", "row": 7,
			"desc": "60% of any overhealing spills onto the lowest-health other ally immediately.",
			"payload": {"stat": {"overflow_pct": 60}}},
		# --- Lane B: MERCY — the resource economy: earning stacks, holding
		# them, spending them, and Empower. ---
		{"id": "hl_heavenly", "name": "Heavenly Aura", "ranks": 1, "lane": "Mercy", "row": 1,
			"desc": "Each stack of Mercy grants 12% healing done, up from the base 5%.",
			"payload": {"stat": {"heavenly_step": 7}}},
		{"id": "hl_holy_light", "name": "Holy Light", "ranks": 1, "lane": "Mercy", "row": 2,
			"desc": "Perfect casts restore 8% of your maximum Mana.",
			"payload": {"stat": {"holy_light_pct": 8}}},
		{"id": "hl_zealous", "name": "Zealous Light", "ranks": 1, "lane": "Mercy", "row": 3,
			"desc": "The Cleric begins each battle with 2 Mercy.",
			"payload": {"stat": {"zealous_mercy": 2}}},
		{"id": "hl_sanctified", "name": "Sanctified", "ranks": 1, "lane": "Mercy", "row": 4,
			"desc": "Spending Mercy has a 35% chance to consume no stacks.",
			"payload": {"stat": {"sanctified_pct": 35}}},
		# RE-SPEC — the slot Resurrection vacated when it joined the opening
		# kit. The id is kept (§8's instruction) and carries GRACE, which
		# closes a real dead end: at maximum stacks every further crossing
		# paid her nothing, the one place her reactive economy wasted what it
		# earned.
		{"id": "hl_resurrection", "name": "Grace", "ranks": 1, "lane": "Mercy", "row": 5,
			"desc": "When an ally would earn you a stack of Mercy while you are at maximum, the stack instead heals that ally for 20% of your maximum health.",
			"payload": {"stat": {"grace_pct": 20}}},
		# A rhythm rather than a discount — bank to the threshold, then
		# Empower freely until you drop below it. Re-priced 4 -> 3: at 4 of a
		# base 5 the window was one stack wide.
		{"id": "hl_ardor", "name": "Ardor", "ranks": 1, "lane": "Mercy", "row": 6,
			"desc": "While the Cleric holds 3 or more Mercy, Empowering consumes no stack.",
			"payload": {"stat": {"ardor_at": 3}}},
		# The lane's payoff: a bigger cap is more held bonus AND more banked
		# spenders at once. 5 -> 8 (the counter is the increase on the base 5).
		{"id": "hl_martyr", "name": "Martyr's Vigor", "ranks": 1, "lane": "Mercy", "row": 7,
			"desc": "Mercy's maximum rises to 8.",
			"payload": {"stat": {"mercy_cap_bonus": 3}}},
		# --- Lane C: VIGIL — the fallen and the nearly-fallen. RENAMED FROM
		# SANCTUARY: "Radiance is heal bigger, Sanctuary is stop people dying"
		# was one axis with two names. Radiance keeps throughput, Mercy keeps
		# the economy, and this lane takes REVERSAL — which is what gives her
		# three real questions instead of two. ---
		{"id": "hl_guardian", "name": "Guardian Angel", "ranks": 1, "lane": "Vigil", "row": 1,
			"desc": "Allies falling below 65% health earn you a stack of Mercy, up from 50%.",
			"payload": {"stat": {"guardian_step": 15}}},
		{"id": "hl_presence", "name": "Divine Presence", "ranks": 1, "lane": "Vigil", "row": 2,
			"desc": "At the end of your turn, the lowest-health ally is healed for 8% of their maximum health.",
			"payload": {"stat": {"divine_presence_pct": 8}}},
		{"id": "hl_last_hope", "name": "Last Hope", "ranks": 1, "lane": "Vigil", "row": 3,
			"desc": "Allies under 25% of their maximum health receive 40% more healing.",
			"payload": {"stat": {"last_hope_pct": 40}}},
		# RE-SPEC of hl_inner_faith (+5% max health), a FORCED ASSIGNMENT
		# reported rather than hidden: Intercession has no ancestor, and this
		# id held the same row of the same lane. AUTHORED FALLBACK (AU §1):
		# already owned -> the window lasts 3 turns instead of 2.
		{"id": "hl_inner_faith", "name": "Intercession", "ranks": 1, "lane": "Vigil", "row": 4,
			"desc": "New ability: Intercession — for 2 turns the next lethal blow against any hero is refused: they survive at 1 health and you lose 1 Mercy (25 Mana, 2.0 int, 4cd). If Intercession was already earned, its window lasts 3 turns instead.",
			"payload": {"grant_ability": "Intercession",
				"upgrade": [{"stat": {"intercession_long": 1}}]}},
		# RE-SPEC of hl_beacon (turn-start pulse on the nearly-dead) — the
		# nearest surviving intent: something automatic that fires because a
		# hero is at death's door, without a cast.
		# BATCH AW §9 — RENAMED "Hour of Need". Batch AV shipped it as SHARED
		# VIGIL and FLAGGED the collision rather than hiding it: the Warden's
		# Banner row-6 node has carried that name since Batch AL. His triggers
		# on him standing strong, hers on a hero being near death, so HIS keeps
		# the name that fits it. THIS IS A LABEL ONLY — the counter
		# `holy_vigil_pct` and every read site are untouched.
		{"id": "hl_beacon", "name": "Hour of Need", "ranks": 1, "lane": "Vigil", "row": 5,
			"desc": "While any hero is below 30% health, the whole party takes 15% less damage.",
			"payload": {"stat": {"holy_vigil_pct": 15}}},
		# Re-spec: the ward stops riding Renewal and rides the HEALING, so
		# every cast leaves something behind.
		{"id": "hl_vestments", "name": "Blessed Vestments", "ranks": 1, "lane": "Vigil", "row": 6,
			"desc": "Your healing also grants the recipient a shield worth 25% of the heal's value for 2 turns.",
			"payload": {"stat": {"vestments_pct": 25}}},
		# THE ROW-7 STATEMENT: reversal stops being a once-a-fight miracle.
		# It deliberately does NOT touch the health the ally returns at —
		# that is Empower's job, and stepping on it would make Empower
		# pointless. Written as an ability payload for exactly that reason:
		# there is no field here that COULD reach the return health.
		{"id": "hl_serenity", "name": "Serenity", "ranks": 1, "lane": "Vigil", "row": 7,
			"desc": "Resurrection costs no Mercy, and its cooldown drops to 1.",
			"payload": {"ability": "Resurrection",
				"set": {"faith_cost": 0, "cooldown": 1}}},
		# --- Capstones (row 8): take ONE, no lane requirement, ever ---
		# RE-SPEC of hl_sanctum (Living Sanctum, whose party-echo premise is
		# gone). The Radiance capstone now: everything bigger, and nothing
		# wasted at all.
		{"id": "hl_sanctum", "name": "Sanctum", "ranks": 1, "lane": "Radiance", "row": 8,
			"capstone": true,
			"desc": "Your healing is increased by 60%, and ALL of your overhealing spills onto the lowest-health other ally.",
			"payload": {"stat": {"sanctum": 1}}},
		# Empower goes unconditional AND becomes a generator — the payoff for
		# a lane built on the resource. Supersedes Ardor rather than stacking
		# with it (the free-Empower checks are either/or, never a double
		# refund). The old per-turn +1 Mercy is GONE: it made the resource a
		# clock rather than something the party earned her.
		{"id": "hl_avatar", "name": "Avatar of Mercy", "ranks": 1, "lane": "Mercy", "row": 8,
			"capstone": true,
			"desc": "Empowering never consumes a stack, and every Empowered cast GRANTS 1 Mercy instead.",
			"payload": {"stat": {"avatar_of_mercy": 1}}},
		# RE-SPEC of hl_capacitor (Holy Capacitor) — the batch's one FULLY
		# FORCED assignment, reported not hidden: Martyrdom has no ancestor
		# anywhere in the old tree, and Capacitor's overheal battery was the
		# design with no successor. The Vigil capstone: reversal on tap.
		{"id": "hl_capacitor", "name": "Martyrdom", "ranks": 1, "lane": "Vigil", "row": 8,
			"capstone": true,
			"desc": "Resurrection has no cooldown and costs no Mercy, and the first hero to fall each battle is returned automatically at 30% health.",
			"payload": {"ability": "Resurrection",
				"set": {"faith_cost": 0, "cooldown": 0},
				"also": [{"stat": {"martyrdom": 1}}]}},
	],
	"inquisitor": [
		# THE DEVOUT (spec id is legacy) — purpose-designed lanes (Batch K,
		# 07-30), re-cut into 7 exclusive rows + a capstone row by Batch AI, and
		# RE-AUTHORED AT ROW PRICING BY BATCH AW. The spine: HE LENDS OUT HIS OWN
		# BULK AND COLLECTS DIVIDENDS — Conviction's third clause (battle.gd
		# `_conviction_growth`) raises his maximum on every Faith release, and his
		# whole kit already reads that maximum, so one clause makes it all
		# escalate off OTHER PEOPLE'S survival rather than his own casting.
		# EVERY ID SURVIVES AND RE-SPECS IN PLACE; no save version moves.
		# MAGNITUDES ARE 4-5x, not the Mage trees' 3x, for the same reason
		# Holy's were: these were rank-1 values on a support whose numbers were
		# the smallest in the game. EVERY COUNTER IS ADDITIVE — it writes its own
		# magnitude in the units its read site sums. FOUR hold the INCREASE on a
		# base the kit pays WITHOUT the node and are named `_step` for it
		# (Stalwart on Divine Shield's 30%, Righteous Fire on the ground's
		# 10%, Blessed are the Faithful on the release's 15%, Fervor on the
		# ground's base 1 Faith) — AV's `guardian_step` precedent.
		# --- Lane BULWARK — THE LOAN ITSELF: invest deeply in one ally. Faith
		# comes FROM absorbs, so this lane is the engine block of the whole
		# Conviction system. ---
		{"id": "dv_barrier", "name": "Blessed Barrier", "ranks": 1, "lane": "Bulwark", "row": 1,
			"desc": "Divine Shield converts {v}% of the damage it absorbs into healing for its holder.",
			"scale": {"step": 20},
			"payload": {"stat": {"blessed_barrier_ranks": 20}}},
		{"id": "dv_aegis", "name": "Radient Aegis", "ranks": 1, "lane": "Bulwark", "row": 2,
			"desc": "Casting Divine Shield has a {v}% chance to cast it again on another ally.",
			"scale": {"step": 60},
			"payload": {"stat": {"aegis_ranks": 60}}},
		{"id": "dv_afterglow", "name": "Afterglow", "ranks": 1, "lane": "Bulwark", "row": 3,
			"desc": "When Divine Shield breaks, its holder is healed for {v}% of the Devout's max health.",
			"scale": {"step": 20},
			"payload": {"stat": {"afterglow_ranks": 20}}},
		{"id": "dv_warded", "name": "Warded Robes", "ranks": 1, "lane": "Bulwark", "row": 4,
			"desc": "While Divine Shield holds, its holder has +{v}% armor.",
			"scale": {"step": 25},
			"payload": {"stat": {"warded_ranks": 25}}},
		# The counter holds the INCREASE on the 30% the ability pays without it.
		{"id": "dv_stalwart", "name": "Stalwart", "ranks": 1, "lane": "Bulwark", "row": 5,
			"desc": "Divine Shield absorbs {v}% of the Devout's max health (up from the base 30%).",
			"scale": {"base": 30, "step": 20},
			"payload": {"stat": {"stalwart_step": 20}}},
		# BASTION GOING TO ZERO IS THE LANE'S STATEMENT and the direct answer to
		# the other half of §2's problem: a shield every turn is a Faith engine.
		# The strongest node in the tree.
		{"id": "dv_bastion", "name": "Bastion", "ranks": 1, "lane": "Bulwark", "row": 6,
			"desc": "Divine Shield has no cooldown at all.",
			"payload": {"ability": "Divine Shield", "set": {"cooldown": 0}}},
		{"id": "dv_unyielding", "name": "Unyielding Aegis", "ranks": 1, "lane": "Bulwark", "row": 7,
			"desc": "When Divine Shield breaks, it immediately re-forms at {v}% of its original strength (once per cast).",
			"scale": {"step": 90},
			"payload": {"stat": {"unyielding_ranks": 90}}},
		# --- Lane FAITH — WHAT THE RETURNS PAY: invest in the dividend itself.
		# Earn the stacks faster, keep them longer, spend them deeper. ---
		# BATCH BE §1 — 40 -> 15, AND THE NUMBER BEHIND IT: BC's leave-one-out grid
		# read this one row-1 node at 80% contribution against 47% withheld
		# (healing 2255 against 444). At 40 an ally holding three or more stacks
		# advanced with CERTAINTY, so a release deterministically produced further
		# releases; at 15 nothing is ever guaranteed (15% at one stack, 45% at
		# three, 60% at four) and the chain decays instead of sustaining. The
		# counter keeps its meaning and its units — AW's reprice took it 20 -> 40
		# and this takes it below where it started.
		{"id": "dv_communion", "name": "Communion", "ranks": 1, "lane": "Faith", "row": 1,
			"desc": "When a party member reaches 5 Faith, every other member has a ({v} x their own Faith stacks)% chance to gain 1 stack.",
			"scale": {"step": 15},
			"payload": {"stat": {"communion_ranks": 15}}},
		# THE MOST INVESTMENT-SHAPED NODE IN THE GAME with Conviction's third
		# clause: it raises the base that every payout in his kit — and every
		# growth increment — scales from.
		{"id": "dv_unwavering", "name": "Unwavering Faith", "ranks": 1, "lane": "Faith", "row": 2,
			"desc": "Increases the Devout's maximum health by {v}%.",
			"scale": {"step": 20},
			"payload": {"stat": {"max_hp_pct": 0.20}}},
		{"id": "dv_devoutness", "name": "Devoutness", "ranks": 1, "lane": "Faith", "row": 3,
			"desc": "The entire party takes {v}% less Break damage.",
			"scale": {"step": 20},
			"payload": {"stat": {"devoutness_ranks": 20}}},
		# The counter holds the INCREASE on the release's base 15%.
		{"id": "dv_faithful", "name": "Blessed are the Faithful", "ranks": 1, "lane": "Faith", "row": 4,
			"desc": "The heal at 5 stacks of Faith restores {v}% max health (up from the base 15%).",
			"scale": {"base": 15, "step": 20},
			"payload": {"stat": {"faithful_step": 20}}},
		# Two magnitudes, two fields: the heal is a percentage, the Faith is a
		# stack count, and one counter cannot honestly hold both.
		{"id": "dv_covenant", "name": "Sacred Covenant", "ranks": 1, "lane": "Faith", "row": 5,
			"desc": "Should Divine Shield prevent lethal damage, its holder is healed for {v}% max health and gains 2 Faith stacks.",
			"scale": {"step": 25},
			"payload": {"stat": {"covenant_heal": 25, "covenant_faith": 2}}},
		# RE-SPECCED RATHER THAN REPRICED: Batch AW §2 took Fervor's subject
		# into the base kit (Consecrated Ground drips 1 Faith per ally per turn
		# with no node at all), so the node keeps its id and its subject and goes
		# ONE STEP DEEPER instead.
		{"id": "dv_fervor", "name": "Fervor", "ranks": 1, "lane": "Faith", "row": 6,
			"desc": "Consecrated Ground's Faith drip becomes {v} per ally per turn instead of 1.",
			"scale": {"base": 1, "step": 1},
			"payload": {"stat": {"fervor_step": 1}}},
		{"id": "dv_oath", "name": "Binding Oath", "ranks": 1, "lane": "Faith", "row": 7,
			"desc": "When an ally's Faith releases at 5 stacks, they keep {v} instead of resetting to zero.",
			"scale": {"step": 3},
			"payload": {"stat": {"oath_ranks": 3}}},
		# --- Lane ZEAL — EVERYONE, SHALLOWLY: invest a little in the whole
		# party. (Its old thesis was "everything else he casts", which is the
		# fault Holy's Sanctuary had — a lane named after the leftovers.) ---
		{"id": "dv_waters", "name": "Cleansing Waters", "ranks": 1, "lane": "Zeal", "row": 1,
			"desc": "While Consecrated Ground or Sacred Resolve holds, each party member has a {v}% chance each turn to be cleansed of one harmful effect.",
			"scale": {"step": 50},
			"payload": {"stat": {"waters_ranks": 50}}},
		# The counter holds the INCREASE on the ground's base 10% reflect.
		{"id": "dv_righteous", "name": "Righteous Fire", "ranks": 1, "lane": "Zeal", "row": 2,
			"desc": "Consecrated Ground reflects {v}% of damage taken (up from the base 10%).",
			"scale": {"base": 10, "step": 25},
			"payload": {"stat": {"righteous_step": 25}}},
		# §5: the authored fallback for a hero who already EARNED Sacred Resolve
		# — the node pays a longer split instead of a grant it cannot make.
		{"id": "dv_resolve", "name": "Sacred Resolve", "ranks": 1, "lane": "Zeal", "row": 3,
			"desc": "New ability: Sacred Resolve — all damage received is split evenly among living heroes for 3 turns; Break damage still lands on the struck hero (25 Mana, 2.5 int, 5cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Sacred Resolve",
				"upgrade": [{"stat": {"resolve_extra_turns": 2}}]}},
		{"id": "dv_pulse", "name": "Healing Pulse", "ranks": 1, "lane": "Zeal", "row": 4,
			"desc": "While Consecrated Ground or Sacred Resolve holds, the party heals {v}% of the Devout's max health each turn.",
			"scale": {"step": 8},
			"payload": {"stat": {"pulse_ranks": 8}}},
		{"id": "dv_crusade", "name": "Crusader's Tempo", "ranks": 1, "lane": "Zeal", "row": 5,
			"desc": "Blessing of Zeal ticks its target's cooldowns down {v} additional turn(s) on cast.",
			"scale": {"step": 3},
			"payload": {"stat": {"crusade_ranks": 3}}},
		# A THIRD FAITH SOURCE, AND THAT IS WHY IT EARNS A ROW: a shield inside
		# the blessing feeds Conviction, and the blessing already doubles Faith
		# gain — so the doubling finally travels WITH a source.
		{"id": "dv_purity", "name": "Purity", "ranks": 1, "lane": "Zeal", "row": 6,
			"desc": "Blessing of Zeal also grants its target a Divine Shield absorbing {v}% of the Devout's max health.",
			"scale": {"step": 35},
			"payload": {"stat": {"purity_ranks": 35}}},
		{"id": "dv_lifewell", "name": "Lifewell", "ranks": 1, "lane": "Zeal", "row": 7,
			"desc": "Damage reflected by Consecrated Ground heals the party for {v}% of the amount reflected.",
			"scale": {"step": 80},
			"payload": {"stat": {"lifewell_ranks": 80}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# §5: the batch calls this "the first capstone in the game that grants
		# an ability". IT IS NOT — nine do (bz_rampage, sm_execute, wd_hold_line,
		# py_firestorm, py_rebirth, cr_shatter, ar_wrath, oc_hysteria and this
		# one), and eight predate Batch AW. The half that IS true is the reason
		# the brief gives: Holy's three granted none, so this is the first
		# CLERIC capstone to owe a fallback at all. Corrected toward the code.
		{"id": "dv_bulwark", "name": "Bulwark of Fortitude", "ranks": 1, "lane": "Bulwark", "row": 8,
			"capstone": true,
			"desc": "New ability: Bulwark of Fortitude — for 3 turns the party takes NO Break damage, has its armor increased by 50%, and heals 10% of max health each turn (30 Mana, 3.0 int, 3cd; Perfect: the party instantly heals 5%).",
			"payload": {"grant_ability": "Bulwark of Fortitude",
				"upgrade": [{"stat": {"bulwark_extra_turns": 1}}]}},
		# UNCHANGED, and with Conviction's third clause it is THE INTERACTION TO
		# MEASURE: releases stop consuming stacks, so every further Faith gain
		# re-triggers one — and every release now grows him. The Communion
		# chain-guard that already stops release cascades recursing stays exactly
		# as it is.
		{"id": "dv_apostle", "name": "Apostle", "ranks": 1, "lane": "Faith", "row": 8,
			"capstone": true,
			"desc": "Faith releases no longer consume stacks: an ally at 5 Faith stays at 5, and every further Faith gain triggers the release again.",
			"payload": {"stat": {"apostle": 1}}},
		# The counter is the gate AND the magnitude — one field, one read site.
		{"id": "dv_judgement", "name": "Judgement", "ranks": 1, "lane": "Zeal", "row": 8,
			"capstone": true,
			"desc": "While Consecrated Ground holds, every enemy that damages a hero is Sundered for 2 turns and takes Break damage equal to 40% of the damage it dealt.",
			"payload": {"stat": {"judgement": 40}}},
	],
	"mystic": [
		# Survivalist — 7 exclusive rows + a capstone row (Batch AI). RE-AUTHORED
		# BY BATCH BA (08-09), the LAST of the twelve, around a spine that was
		# already half-written: ATTRITION — BREADTH OF AFFLICTION, NOT DEPTH OF
		# ONE. EVERY ID SURVIVES AND RE-SPECS IN PLACE, so saved picks migrate and
		# no save version moves.
		#
		# THE ONE TREE IN THE GAME WHOSE CEILING IS CORRECT AND STAYS: Trapper
		# pays +8% per DIFFERENT status, and breadth is bounded by how many
		# distinct debuffs exist — a design constant, not a dial. Overburn,
		# Loyalty, Focus, Resonance and Ruin all lost their ceilings; this one
		# keeps its.
		#
		# LANE NAMES AND THESES ALL STAND, re-aimed only in what VENOM's nodes DO:
		# the affliction that ticks · the affliction that stops · the affliction
		# that adds up. Each Venom node now hangs a DIFFERENT affliction off the
		# poison, so the lane named for his signature damage stops fighting his
		# own passive (a poison build earned +8% where a five-affliction build
		# earned +40%).
		#
		# THE CONTAGION SPACE IS RESERVED FOR A FUTURE SPEC — see CLAUDE.md's
		# standing design rule. Poison is his and stays his; anything that SPREADS
		# ON ITS OWN (enemy to enemy, corpse to living, field-wide infection) is
		# off-limits to this tree. Four nodes were re-specced off it.
		#
		# MAGNITUDES ARE ADDITIVE, NOT RANKED: every counter writes its own
		# magnitude in the units its read site sums (AR/AS/AT/AV/AW/AX/AY/AZ).
		# --- Lane A: Venom — the affliction that TICKS ---
		# Deliberately FLAT damage rather than a percentage of Attack: converting
		# it would change `_apply_poison`'s units and every rune riding
		# `potent_ranks` with it, for a gain the reprice already delivers. 8x the
		# value, same units, no read-site change — so the two runes that pay into
		# it still pay exactly what their text advertises.
		{"id": "sv_potent", "name": "Potent Toxins", "ranks": 1, "lane": "Venom", "row": 1,
			"desc": "Your Poison deals +{v} damage per stack.", "scale": {"step": 8},
			"payload": {"stat": {"potent_ranks": 8}}},
		{"id": "sv_coated", "name": "Coated Blades", "ranks": 1, "lane": "Venom", "row": 2,
			"desc": "Your basic attack applies Poison for 2 turns and Cripple for 2 turns.",
			"payload": {"stat": {"coated_blades": 1}}},
		# RENAMED from Virulence — a pathogen term the reserved spec wants back.
		# The id survives, the mechanic survives, only the name goes.
		{"id": "sv_virulence", "name": "Distillate", "ranks": 1, "lane": "Venom", "row": 3,
			"desc": "Your Poison applications add +{v} extra stacks and apply Exposed for 3 turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"virulence_ranks": 2}}},
		{"id": "sv_slow_acting", "name": "Slow Acting", "ranks": 1, "lane": "Venom", "row": 4,
			"desc": "Your Poison deals HALF damage but lasts TWICE as long, cannot be cleansed, and applies Slowed for 3 turns.",
			"payload": {"stat": {"slow_acting": 1}}},
		# RE-SPECCED — the corpse transfer is gone (contagion). Keeping the wound
		# open is craft: it reads the status-application path, not a death.
		# BATCH BB §2 gave it its second clause: Perfected Toxin leaves no clock
		# to refresh, so against a permanent poison the node deepens instead.
		{"id": "sv_creeping", "name": "Creeping Death", "ranks": 1, "lane": "Venom", "row": 5,
			"desc": "Applying any status to a Poisoned enemy refreshes its Poison to full duration — or, if that Poison is permanent, adds a stack instead (once per enemy per turn).",
			"payload": {"stat": {"creeping_death": 1}}},
		# The only node in the lane that was already pointed at BREADTH rather
		# than depth, and tissue death from venom is what venomous bites do — so
		# it keeps its name as well as its job.
		{"id": "sv_necrosis", "name": "Necrosis", "ranks": 1, "lane": "Venom", "row": 6,
			"desc": "Poisoned enemies take +{v}% damage from ALL sources, not just yours.",
			"scale": {"step": 35},
			"payload": {"stat": {"necrosis": 35}}},
		# REPLACES Plague Bearer (transmission). Party-wide craft with nothing
		# self-propagating — he oils their blades. The closest thing to Plague
		# Bearer's REACH that stays out of the reserved space.
		{"id": "sv_plague", "name": "Quartermaster", "ranks": 1, "lane": "Venom", "row": 7,
			"desc": "Your allies' basic attacks also apply your Poison.",
			"payload": {"stat": {"quartermaster": 1}}},
		# --- Lane B: Snares — the affliction that STOPS ---
		{"id": "sv_wire", "name": "Reinforced Wire", "ranks": 1, "lane": "Snares", "row": 1,
			"desc": "Tripwire's retaliation deals +{v}% of your Attack.", "scale": {"step": 35},
			"payload": {"stat": {"wire_ranks": 35}}},
		{"id": "sv_rigging", "name": "Quick Rigging", "ranks": 1, "lane": "Snares", "row": 2,
			"desc": "Snare Trap's cooldown is reduced by {v}, and its spring also applies Cripple.",
			"scale": {"step": 2},
			# TWO HALVES, TWO PAYLOADS. `apply_payload` is an if/elif chain, so a
			# node carrying `stat` AND `ability` would silently drop the second —
			# which is EXACTLY what had happened here: the cooldown clause has had
			# no implementation at all since Batch 33 (unit.gd's own comment said
			# "(payload)" and no payload existed). The `also` key is the one
			# sanctioned way to hang a second half off a node (Batch AK).
			"payload": {"stat": {"quick_rigging": 2},
				"also": [{"ability": "Snare Trap", "add": {"cooldown": -2}}]}},
		{"id": "sv_cruel", "name": "Cruel Devices", "ranks": 1, "lane": "Snares", "row": 3,
			"desc": "Your traps deal +{v}% damage.", "scale": {"step": 50},
			"payload": {"stat": {"cruel_ranks": 50}}},
		# A BYPASS, NOT A MAGNITUDE: nothing here to reprice — the same call AZ
		# made for No Cover.
		{"id": "sv_snap_shut", "name": "Snap Shut", "ranks": 1, "lane": "Snares", "row": 4,
			"desc": "Tripwire also retaliates against RANGED attackers, not only melee.",
			"payload": {"stat": {"snap_shut": 1}}},
		{"id": "sv_caught", "name": "Caught Fast", "ranks": 1, "lane": "Snares", "row": 5,
			"desc": "Enemies caught by your traps cannot be healed for {v} turns.",
			"scale": {"step": 5},
			"payload": {"stat": {"caught_fast": 5}}},
		{"id": "sv_bone", "name": "Bone Breaker", "ranks": 1, "lane": "Snares", "row": 6,
			"desc": "Your traps apply {v} Break damage when they spring.",
			"scale": {"step": 90},
			"payload": {"stat": {"bone_breaker": 90}}},
		# THE COUNTER IS THE GATE AND THE MAGNITUDE IN ONE FIELD (AW's
		# `judgement`): it holds the trap CAP it installs, so `_ability_usable`
		# reads the number rather than carrying a hardcoded 2 beside it.
		{"id": "sv_network", "name": "Deadfall Network", "ranks": 1, "lane": "Snares", "row": 7,
			"desc": "You may have THREE traps active at once.",
			"payload": {"stat": {"deadfall_network": 3}}},
		# --- Lane C: Guerilla — the affliction that ADDS UP ---
		{"id": "sv_woodcraft", "name": "Woodcraft", "ranks": 1, "lane": "Guerilla", "row": 1,
			"desc": "+{v}% maximum Health.", "scale": {"step": 20},
			"payload": {"stat": {"max_hp_pct": 0.20}}},
		{"id": "sv_hitrun", "name": "Hit and Run", "ranks": 1, "lane": "Guerilla", "row": 2,
			"desc": "Whenever you apply a status to an enemy, you gain Elusive for {v} turns.",
			"scale": {"step": 2},
			"payload": {"stat": {"hit_and_run": 2}}},
		{"id": "sv_scavenger", "name": "Scavenger", "ranks": 1, "lane": "Guerilla", "row": 3,
			"desc": "Restore {v}% maximum Mana whenever an enemy dies.", "scale": {"step": 25},
			"payload": {"stat": {"scavenger_ranks": 25}}},
		{"id": "sv_medic", "name": "Field Medic", "ranks": 1, "lane": "Guerilla", "row": 4,
			"desc": "At the start of your turn, cleanse {v} debuffs from random allies.",
			"scale": {"step": 2},
			"payload": {"stat": {"field_medic": 2}}},
		{"id": "sv_vulture", "name": "Vulture", "ranks": 1, "lane": "Guerilla", "row": 5,
			"desc": "+{v}% damage against enemies afflicted by 3 or more different statuses.",
			"scale": {"step": 60},
			"payload": {"stat": {"vulture": 60}}},
		{"id": "sv_ghillie", "name": "Ghillie Suit", "ranks": 1, "lane": "Guerilla", "row": 6,
			"desc": "Enemies are {v}% less likely to target you while another ally lives.",
			"scale": {"step": 65},
			"payload": {"stat": {"ghillie": 65}}},
		{"id": "sv_improvised", "name": "Improvised", "ranks": 1, "lane": "Guerilla", "row": 7,
			"desc": "The first {v} abilities you use each fight do not start their cooldowns.",
			"scale": {"step": 2},
			"payload": {"stat": {"improvised": 2}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# REPLACES Epidemic (a pandemic — field-wide infection, reserved). It
		# keeps the UNCLEANSABLE identity that made Epidemic a capstone and drops
		# the contagion; the `sticky` flag it needs already exists in
		# `unit.purge_debuffs` and the dispel path, so this is a re-point rather
		# than new machinery. The counter is the gate AND the per-turn rise.
		{"id": "sv_epidemic", "name": "Perfected Toxin", "ranks": 1, "lane": "Venom", "row": 8,
			"capstone": true,
			"desc": "Your Poison cannot be cleansed, never expires, and its tick rises by {v} each turn it persists.",
			"scale": {"step": 2},
			"payload": {"stat": {"perfected_toxin": 2}}},
		{"id": "sv_forest", "name": "The Whole Forest", "ranks": 1, "lane": "Snares", "row": 8,
			"capstone": true,
			"desc": "Tripwire never expires and bites on EVERY enemy action — melee, ranged, or spellwork.",
			"payload": {"stat": {"whole_forest": 1}}},
		# UNCHANGED IN DESIGN — already 2.5x the base and already the breadth
		# capstone. The counter carries the percentage now (additive), so the
		# read site reads a number rather than deriving one from a flag.
		{"id": "sv_force", "name": "Force of Nature", "ranks": 1, "lane": "Guerilla", "row": 8,
			"capstone": true,
			"desc": "Trapper's bonus rises to +{v}% per different status — and applies to your ENTIRE party's damage.",
			"scale": {"step": 20},
			"payload": {"stat": {"force_of_nature": 20}}},
	],
	"sharpshooter": [
		# Batch AI re-cut this tree's tiers into 7 exclusive rows + a capstone
		# row; every node costs 1 point and holds a single rank. RE-AUTHORED BY
		# BATCH AZ (08-08) around a spine: PATIENCE — his power is in not looking
		# away. EVERY ID SURVIVES AND RE-SPECS IN PLACE, so saved picks migrate
		# and no save version moves.
		#
		# THE LANE NAMES AND THESES ALL STAND — Precision, Penetration and Tempo
		# were never lying about their jobs, so unlike the Cryomancer's
		# Shatterpoint or the Arcanist's Control nothing needed re-aiming.
		#
		# MAGNITUDES ARE ADDITIVE, NOT RANKED: every counter writes its own
		# magnitude in the units its read site sums (percentage POINTS unless
		# said otherwise), so a node and a rune each pay their advertised number
		# alone AND stacked. Repricing is 3-4x, not the Cleric three's 4-5x —
		# his numbers were never the smallest in the game.
		# --- Lane A: Precision — Focus, crit chance, crit damage ---
		{"id": "ss_steady", "name": "Steady Hands", "ranks": 1, "lane": "Precision", "row": 1,
			"desc": "+{v}% critical chance.", "scale": {"step": 15},
			"payload": {"stat": {"crit_bonus": 0.15}}},
		{"id": "ss_perfect_form", "name": "Perfect Form", "ranks": 1, "lane": "Precision", "row": 2,
			"desc": "Critical hits grant +{v} Focus.", "scale": {"step": 40},
			"payload": {"stat": {"perfect_form": 40}}},
		# RE-SPECCED (was "the Focus cap rises from 100 to 150"): §1 took the
		# ceiling away, so the old node had no premise left. It is the cleanest
		# re-spec available — same name, same lane, and it becomes a DIAL on the
		# new mechanic rather than a dead ceiling raise. The counter holds the
		# DROP so it stays additive (the Rune of the Deep Sight adds 8 more).
		{"id": "ss_deep_focus", "name": "Deep Focus", "ranks": 1, "lane": "Precision", "row": 3,
			"desc": "Focus turns into force sooner: the conversion point falls from 100 Focus to {v}.",
			"scale": {"base": 100, "step": -40},
			"payload": {"stat": {"deep_focus": 40}}},
		{"id": "ss_exec_eye", "name": "Executioner's Eye", "ranks": 1, "lane": "Precision", "row": 4,
			"desc": "Lethal Aim's critical multiplier rises to x{v}.",
			"scale": {"base": 2.0, "step": 0.5},
			"payload": {"stat": {"lethal_eye_ranks": 50}}},
		# The wording change is LOAD-BEARING, not cosmetic. It used to SET the
		# multiplier to 1.5, which was coherent only while it was exclusive with
		# Executioner's Eye — and §4 shows that pair is dead (rows 4 and 5 of one
		# lane, so row exclusivity lets a player hold both). Written as -0.5 it
		# COMPOSES: x1.5 alone, x2.0 with Executioner's Eye, and the trade
		# survives in both builds.
		{"id": "ss_consistent", "name": "Consistent Aim", "ranks": 1, "lane": "Precision", "row": 5,
			"desc": "Your critical multiplier is reduced by 0.5 — but you gain +60% critical chance.",
			"payload": {"stat": {"consistent_aim": 50, "crit_bonus": 0.60}}},
		# RE-SPECCED (was "switching targets HALVES your Focus"): a spec about
		# not looking away must not sell a discount on looking away, least of all
		# in the spine's own lane — the same shape as Flame Shield and Stabilize.
		# It rewards STAYING now. Spray of Arrows remains the honest way out.
		{"id": "ss_unwavering", "name": "Unwavering", "ranks": 1, "lane": "Precision", "row": 6,
			"desc": "Each consecutive turn attacking the same enemy grants +{v} additional Focus, rising by {v} again each turn to a maximum of +50. Switching resets it.",
			"scale": {"step": 10},
			"payload": {"stat": {"unwavering": 10}}},
		{"id": "ss_tunnel", "name": "Tunnel Vision", "ranks": 1, "lane": "Precision", "row": 7,
			"desc": "+{v}% critical chance against the enemy you attacked last turn; -{v}% against every other enemy.",
			"scale": {"step": 100},
			"payload": {"stat": {"tunnel_vision": 100}}},
		# --- Lane B: Penetration — armor, Break, finishing the party's work ---
		{"id": "ss_piercer", "name": "Armor Piercer", "ranks": 1, "lane": "Penetration", "row": 1,
			"desc": "Your attacks ignore {v}% of the target's armor.", "scale": {"step": 30},
			"payload": {"stat": {"pierce_bonus": 0.30}}},
		{"id": "ss_sundering", "name": "Sundering Shot", "ranks": 1, "lane": "Penetration", "row": 2,
			"desc": "Critical hits apply {v} Break damage.", "scale": {"step": 45},
			"payload": {"stat": {"sundering_shot": 45}}},
		{"id": "ss_bonecracker", "name": "Bonecracker", "ranks": 1, "lane": "Penetration", "row": 3,
			"desc": "+{v}% damage against Broken enemies.", "scale": {"step": 40},
			"payload": {"stat": {"bonecracker_ranks": 40}}},
		# `opp_aim_step` is the INCREASE on the 2% the kit pays WITHOUT the node
		# (AV's `guardian_step` form), so tripling the scaling is written as 4.
		# It is a FLOAT and must stay OUT of Runes.STAT_INT_KEYS.
		{"id": "ss_opp_aim", "name": "Opportunist's Aim", "ranks": 1, "lane": "Penetration", "row": 4,
			"desc": "Powershot's Break scaling TRIPLES: +6% damage per full point instead of +2%.",
			"payload": {"stat": {"opp_aim_step": 4.0}}},
		{"id": "ss_exposed_nerve", "name": "Exposed Nerve", "ranks": 1, "lane": "Penetration", "row": 5,
			"desc": "Critical hits apply Exposed for 3 turns, and you deal +{v}% damage to Exposed enemies.",
			"scale": {"step": 15},
			"payload": {"stat": {"exposed_nerve": 15}}},
		# A BYPASS, NOT A MAGNITUDE: there is nothing here to reprice, so it is
		# the one node in the tree that is byte-unchanged.
		{"id": "ss_no_cover", "name": "No Cover", "ranks": 1, "lane": "Penetration", "row": 6,
			"desc": "Your attacks cannot be made to miss: Blind and Dazed do not affect you, and Elusive does not protect against you.",
			"payload": {"stat": {"no_cover": 1}}},
		# The second clause ties the lane to the spine: a kill-chain is the one
		# time switching targets is not disloyalty, so it does not cost the bond.
		{"id": "ss_overkill", "name": "Overkill", "ranks": 1, "lane": "Penetration", "row": 7,
			"desc": "Excess damage from a killing blow carries to another enemy at full value — and the carry keeps your Focus in FULL rather than dropping it to the usual 50.",
			"payload": {"stat": {"overkill": 1}}},
		# --- Lane C: Tempo — speed, cooldowns, Focus acceleration ---
		{"id": "ss_fletcher", "name": "Fletcher's Speed", "ranks": 1, "lane": "Tempo", "row": 1,
			"desc": "+{v} Speed.", "scale": {"step": 18},
			"payload": {"stat": {"speed": 18.0}}},
		{"id": "ss_snap", "name": "Snap Shot", "ranks": 1, "lane": "Tempo", "row": 2,
			"desc": "The first {v} abilities you use each fight cost no Mana and do not start their cooldowns.",
			"scale": {"step": 2},
			"payload": {"stat": {"snap_shot": 2}}},
		{"id": "ss_muscle", "name": "Muscle Memory", "ranks": 1, "lane": "Tempo", "row": 3,
			"desc": "Focus gain per attack increases by {v}.", "scale": {"step": 30},
			"payload": {"stat": {"muscle_memory_ranks": 30}}},
		# 150 OPENS HIM PAST THE CONVERSION POINT, which is the Tempo lane's whole
		# argument in one node: he arrives already converting rather than earning
		# his way there.
		{"id": "ss_volley", "name": "Opening Volley", "ranks": 1, "lane": "Tempo", "row": 4,
			"desc": "You begin every fight with {v} Focus.", "scale": {"step": 150},
			"payload": {"stat": {"opening_volley": 150}}},
		{"id": "ss_follow", "name": "Follow-Through", "ranks": 1, "lane": "Tempo", "row": 5,
			"desc": "Critical hits reduce ALL your cooldowns by {v}.", "scale": {"step": 2},
			"payload": {"stat": {"follow_through": 2}}},
		{"id": "ss_second_nature", "name": "Second Nature", "ranks": 1, "lane": "Tempo", "row": 6,
			"desc": "Hold Breath's guaranteed critical applies to your next {v} attacks.",
			"scale": {"step": 4},
			"payload": {"stat": {"second_nature": 4}}},
		{"id": "ss_spray", "name": "Spray of Arrows", "ranks": 1, "lane": "Tempo", "row": 7,
			"desc": "Your single-target attacks strike {v} additional random enemies for 50% damage — but Focus can never exceed 50.",
			"scale": {"step": 2},
			"payload": {"stat": {"spray": 2}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# THE THRESHOLD REPLACES "at maximum Focus", which §1 made meaningless.
		# The field is the gate AND the magnitude (AW's `judgement` precedent).
		{"id": "ss_one_shot", "name": "One Shot", "ranks": 1, "lane": "Precision", "row": 8,
			"capstone": true,
			"desc": "At {v} or more Focus, Aimed Shot EXECUTES any non-boss enemy below 35% health outright (elites included); otherwise it deals double damage. Either way, Focus resets to 0.",
			"scale": {"step": 200},
			"payload": {"stat": {"one_shot": 200}}},
		{"id": "ss_tnt", "name": "Through and Through", "ranks": 1, "lane": "Penetration", "row": 8,
			"capstone": true,
			"desc": "Your attacks ignore ALL armor, and every critical hit refunds its Mana cost.",
			"payload": {"stat": {"through_and_through": 1}}},
		{"id": "ss_rapid", "name": "Rapid Fire", "ranks": 1, "lane": "Tempo", "row": 8,
			"capstone": true,
			"desc": "Each ability you use has a {v}% chance not to consume its cooldown.",
			"scale": {"step": 50},
			"payload": {"stat": {"rapid_fire": 50}}},
	],
	"beastmaster": [
		# Purpose-designed lanes (Batch 30, 07-25), re-cut into 7 exclusive rows
		# + a capstone row by Batch AI, and RE-AUTHORED BY BATCH AY (08-08)
		# around a spine: PARTNERSHIP — his power lives in another body, and it
		# is the only resource in the game that can die. EVERY ID SURVIVES AND
		# RE-SPECS IN PLACE, so saved picks migrate and no save version moves.
		#
		# THE LANE THESES SHARPENED WITHOUT RENAMING: DEVOTION is partnership in
		# DEPTH (one beast, further); THE PACK is partnership in BREADTH (many
		# beasts, rotated); HANDLER is what he does when the partnership is not
		# the answer.
		#
		# EVERY COUNTER IS ADDITIVE (the AR/AS/AT/AV/AW/AX form): the payload
		# holds the MAGNITUDE and the read site applies no step of its own. TWO
		# hold the INCREASE on a base the kit already pays without the node and
		# are named `_step` for it (AV's `guardian_step` precedent) —
		# `wild_communion_step` on the passive's own 5%, `absolute_step` on the
		# Pack Bond boon's own 20%. BOTH ARE IN `Runes.STAT_INT_KEYS`: neither
		# ends in "_ranks" and both are written by runes, so without that entry
		# JSON's float slides into a typed int var and the hero fails to spawn.
		#
		# WATCH THE ONE NAME TRAP: `wild_communion_step` IS NOT `communion_ranks`
		# — that is the Devout's, and Batch 29 crossed the two once already.
		# --- Lane DEVOTION: one beast, deeper ---
		{"id": "bm_communion", "name": "Wild Communion", "ranks": 1, "lane": "devotion", "row": 1,
			"desc": "Companion strike damage per Loyalty stack rises to {v}% (from the base 5%).",
			"scale": {"base": 5, "step": 7},
			"payload": {"stat": {"wild_communion_step": 7}}},
		{"id": "bm_unbroken", "name": "Unbroken Watch", "ranks": 1, "lane": "devotion", "row": 2,
			"desc": "The active beast gains +{v} additional Loyalty on any turn it took no damage.",
			"scale": {"step": 2},
			"payload": {"stat": {"unbroken_watch": 2}}},
		# RE-SPECCED, NOT REPRICED: it used to raise a ceiling, and Batch AY §2
		# removed the ceiling. It is the lane's thesis now — the dial on the
		# curve itself, and Ancient Pact stacks on top of it (+70% a stack).
		{"id": "bm_absolute", "name": "Absolute Devotion", "ranks": 1, "lane": "devotion", "row": 3,
			"desc": "The Pack Bond boon grows {v}% per Loyalty stack instead of the base 20%.",
			"scale": {"base": 20, "step": 15},
			"payload": {"stat": {"absolute_step": 15}}},
		{"id": "bm_devoted_fury", "name": "Devoted Fury", "ranks": 1, "lane": "devotion", "row": 4,
			"desc": "Bestial Wrath lasts {v} turn(s) longer per Loyalty stack, rather than per two.",
			"scale": {"step": 1},
			"payload": {"stat": {"devoted_fury": 1}}},
		{"id": "bm_steadfast", "name": "Steadfast Bond", "ranks": 1, "lane": "devotion", "row": 5,
			"desc": "A beast's death returns {v}% of its Loyalty rather than halving it — the meter survives it whole.",
			"scale": {"step": 100},
			"payload": {"stat": {"steadfast_bond": 100}}},
		# RE-SPECCED, NOT REPRICED: tripling AT a threshold is meaningless once
		# the threshold is a curve. It doubles the STEP now, whatever Absolute
		# Devotion made it — the deep-partnership build, terrifying and fragile
		# in equal measure.
		{"id": "bm_ancient_pact", "name": "Ancient Pact", "ranks": 1, "lane": "devotion", "row": 6,
			"desc": "The Pack Bond boon's growth per Loyalty stack DOUBLES — but the beast can no longer be healed by ANY source, Spirit Bond and Hunter's Instinct included.",
			"payload": {"stat": {"ancient_pact": 1}}},
		# RE-SPECCED PAYOFF: a higher ceiling was its reward and there is no
		# ceiling. It arrives deep and grows twice as fast instead. THE FIELD IS
		# THE GATE AND THE MAGNITUDE IN ONE (AW's `judgement` precedent): 6 is
		# the Loyalty it seats the beast at, and `> 0` is "Lone Bond is taken".
		# IT ALSO HOLDS THE BEAST CAP AT ONE, which is what makes it and The
		# Pack impossible to hold together — see battle._beast_cap.
		{"id": "bm_lone_bond", "name": "Lone Bond", "ranks": 1, "lane": "devotion", "row": 7,
			"desc": "One beast per fight: it cannot be swapped and cannot be re-summoned if it dies — but it arrives at {v} Loyalty and gains DOUBLE thereafter. It also closes The Pack: you can never field two.",
			"scale": {"step": 6},
			"payload": {"stat": {"lone_bond": 6}}},
		# --- Lane THE PACK: many beasts, rotated ---
		{"id": "bm_whistle", "name": "Quick Whistle", "ranks": 1, "lane": "pack", "row": 1,
			"desc": "Swap Companion has NO cooldown (it shaves {v} turns off the shared 3).",
			"scale": {"step": 3},
			"payload": {"stat": {"quick_whistle_ranks": 3}}},
		{"id": "bm_momentum", "name": "Feral Momentum", "ranks": 1, "lane": "pack", "row": 2,
			"desc": "+{v}% companion damage for each DIFFERENT beast summoned this fight.",
			"scale": {"step": 25},
			"payload": {"stat": {"momentum_ranks": 25}}},
		{"id": "bm_shared", "name": "Shared Devotion", "ranks": 1, "lane": "pack", "row": 3,
			"desc": "Summoning or swapping grants +{v} Loyalty to EVERY beast, not only the arriving one.",
			"scale": {"step": 2},
			"payload": {"stat": {"shared_devotion": 2}}},
		{"id": "bm_herald", "name": "Herald", "ranks": 1, "lane": "pack", "row": 4,
			"desc": "Arrival effects strike {v} ADDITIONAL targets: Guardian's Roar taunts three, Aguila dives three, and Bloodhowl doubles its Bleed on the two bloodiest enemies.",
			"scale": {"step": 2},
			"payload": {"stat": {"herald": 2}}},
		# MAGNITUDE DELIBERATELY UNCHANGED. Batch AY §1 gave it a new job rather
		# than a bigger number: with The Pack it now carries a THIRD (absent)
		# beast's boon rather than a first's, and it must stay meaningfully
		# different from the two at full strength beside it.
		{"id": "bm_menagerie", "name": "Menagerie", "ranks": 1, "lane": "pack", "row": 5,
			"desc": "Every beast summoned this fight keeps its Pack Bond boon at {v}% strength while it is away.",
			"scale": {"step": 50},
			"payload": {"stat": {"menagerie": 50}}},
		# Two magnitudes, two fields — one counter cannot honestly hold a call
		# count and a Loyalty total (AW's `covenant` precedent).
		{"id": "bm_no_beast_left", "name": "No Beast Left", "ranks": 1, "lane": "pack", "row": 6,
			"desc": "A beast's death makes your next {v} summons cost no Mana and ignore their cooldown, and each arriving beast enters at 5 Loyalty.",
			"scale": {"step": 2},
			"payload": {"stat": {"no_beast_left": 2, "no_beast_left_loyalty": 5}}},
		# THE FIELD IS THE GATE AND THE MAGNITUDE IN ONE: 3 is the Loyalty cap
		# it imposes, and that cap IS its cost — the one node in the game that
		# still hands `_loyalty_cap` a number.
		{"id": "bm_wild_rotation", "name": "Wild Rotation", "ranks": 1, "lane": "pack", "row": 7,
			"desc": "Swap Companion has no cooldown and arrival effects ALWAYS fire. Loyalty caps at {v}.",
			"scale": {"step": 3},
			"payload": {"stat": {"wild_rotation": 3}}},
		# --- Lane HANDLER: when the partnership is not the answer ---
		{"id": "bm_masters_aim", "name": "Master's Aim", "ranks": 1, "lane": "handler", "row": 1,
			"desc": "Quick Shot deals +{v}% of your Attack.",
			"scale": {"step": 25},
			"payload": {"stat": {"masters_aim_ranks": 25}}},
		{"id": "bm_beast_within", "name": "Beast Within", "ranks": 1, "lane": "handler", "row": 2,
			"desc": "+{v}% companion maximum health.",
			"scale": {"step": 40},
			"payload": {"stat": {"companion_hp_pct": 0.40}}},
		{"id": "bm_reserves", "name": "Deep Reserves", "ranks": 1, "lane": "handler", "row": 3,
			"desc": "Spirit Bond restores +{v}% more maximum Mana.",
			"scale": {"step": 30},
			"payload": {"stat": {"deep_reserves_ranks": 30}}},
		{"id": "bm_instinctive", "name": "Instinctive", "ranks": 1, "lane": "handler", "row": 4,
			"desc": "Hunter's Instinct empowers {v} Quick Shots instead of 3.",
			"scale": {"step": 8},
			"payload": {"stat": {"instinctive": 8}}},
		{"id": "bm_symbiosis", "name": "Symbiosis", "ranks": 1, "lane": "handler", "row": 5,
			"desc": "Whenever your companion strikes, you restore {v}% maximum Mana.",
			"scale": {"step": 6},
			"payload": {"stat": {"symbiosis": 6}}},
		{"id": "bm_vengeance", "name": "Vengeance", "ranks": 1, "lane": "handler", "row": 6,
			"desc": "When a beast dies you take its Pack Bond boon at FULL strength for the rest of the battle, rather than for a few turns — and deal +{v}% damage while it holds.",
			"scale": {"step": 30},
			"payload": {"stat": {"vengeance": 1, "vengeance_dmg": 30}}},
		{"id": "bm_lone_hunter", "name": "Lone Hunter", "ranks": 1, "lane": "handler", "row": 7,
			"desc": "While no beast stands, your abilities cost {v}% less and you deal +30% damage.",
			"scale": {"step": 50},
			"payload": {"stat": {"lone_hunter": 50, "lone_hunter_dmg": 30}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		{"id": "bm_one_soul", "name": "One Soul", "ranks": 1, "lane": "devotion", "row": 8,
			"capstone": true,
			"desc": "You and every beast you field share one health pool — all damage to any of you divides evenly between you. Loyalty gain is doubled.",
			"payload": {"stat": {"one_soul": 1}}},
		# BUILT BY BATCH AY §1. It had read "coming soon" in the shelf since
		# Batch 30; most of the machinery was already here (`unit.beasts` is an
		# Array, `unit.loyalty` is keyed by kind, `_bond_mult` is one site), so
		# this was an unfinished switch rather than unbuilt machinery.
		{"id": "bm_the_pack", "name": "The Pack", "ranks": 1, "lane": "pack", "row": 8,
			"capstone": true,
			"desc": "TWO beasts may be active at once: both strike when you attack, each keeps its own Loyalty meter, and BOTH Pack Bond boons apply at FULL strength. Swapping replaces whichever of the two holds LESS Loyalty — the deeper bond always keeps its place. Lone Bond closes this door.",
			"payload": {"stat": {"the_pack": 1}}},
		{"id": "bm_apex", "name": "Apex Predator", "ranks": 1, "lane": "handler", "row": 8,
			"capstone": true,
			"desc": "Quick Shot triggers an ADDITIONAL free companion strike, and Kill Command's cooldown resets whenever an enemy dies.",
			"payload": {"stat": {"apex": 1}}},
	],
	"occultist": [
		# Purpose-designed lanes (Batch L, 07-30), re-priced by Batch AX
		# (08-08). Batch AI re-cut the tiers into 7 exclusive rows + a capstone
		# row; Batch L's cross-lane plumbing is intact and was the reason this
		# tree needed the LEAST structural work of the Cleric three — Ruin /
		# Madness / Leech are genuinely distinct axes and no lane is lying about
		# its job. AX gave it the same 4-5x repricing Holy and the Devout took,
		# and a spine: CORRUPTION — his power is not in him at all, it is in
		# what he has done to them. EVERY ID SURVIVES AND RE-SPECS IN PLACE, so
		# saved picks migrate and no save version moves.
		#
		# EVERY COUNTER IS ADDITIVE (the AR/AS/AT/AV/AW form): the payload holds
		# the MAGNITUDE and the read site applies no step of its own.
		# --- Lane RUIN — the mark: stack it, blow it, chain it. Batch AX
		# repriced the lane around §1's new corruption: the stacks never wash
		# off, so every per-stack node here is a dial on a number with no
		# ceiling. Broken Will and Entropy are ALSO §2's two-step plan — the
		# Break that unlocks the Madness lane against a boss — and they are
		# priced with that job in mind, not just as damage dials. ---
		# The chance IS the counter now (100 = always), so a rune adding to it
		# cannot overflow into nonsense.
		{"id": "oc_emp_hex", "name": "Empowered Hex", "ranks": 1, "lane": "Ruin", "row": 1,
			"desc": "Hex of Ruin ALWAYS applies Decay to each target it curses (10 Break damage per turn, 3 turns).",
			"payload": {"stat": {"emp_hex_ranks": 100}}},
		# THE MOST DANGEROUS NODE IN THE GAME and it wants watching: against
		# uncapped stacks this is a multiplier on a number with no ceiling. At
		# twenty stacks it is +100% damage taken. That is the intended shape of a
		# long boss fight, and it is the first thing to check if a boss row comes
		# back absurd. The counter holds the INCREASE on the passive's own 2%.
		{"id": "oc_deep_hex", "name": "Deeper Hex", "ranks": 1, "lane": "Ruin", "row": 2,
			"desc": "Each stack of Ruin makes its bearer take {v}% more damage (up from the base 2%).",
			"scale": {"base": 2, "step": 3},
			"payload": {"stat": {"deep_hex_step": 3}}},
		{"id": "oc_channeling", "name": "Corrupted Channeling", "ranks": 1, "lane": "Ruin", "row": 3,
			"desc": "Whenever a Crippled enemy attacks, a random hero heals for {v}% of the damage it dealt.",
			"scale": {"step": 60},
			"payload": {"stat": {"channeling_ranks": 60}}},
		{"id": "oc_broken_will", "name": "Broken Will", "ranks": 1, "lane": "Ruin", "row": 4,
			"desc": "The Occultist deals {v}% more Break damage.",
			"scale": {"step": 25},
			"payload": {"stat": {"broken_will_ranks": 25}}},
		{"id": "oc_grim", "name": "Grim Focus", "ranks": 1, "lane": "Ruin", "row": 5,
			"desc": "Ruin detonations deal {v}% more damage.",
			"scale": {"step": 80},
			"payload": {"stat": {"grim_ranks": 80}}},
		{"id": "oc_entropy", "name": "Entropy", "ranks": 1, "lane": "Ruin", "row": 6,
			"desc": "Enemies bearing any Ruin take {v} Break damage at the start of each of their turns.",
			"scale": {"step": 20},
			"payload": {"stat": {"entropy_ranks": 20}}},
		# One propagation per detonation (battle.gd enforces it): a seeded enemy
		# is only ARMED here, and armed Ruin fires at its own turn start.
		{"id": "oc_unravel", "name": "Unraveling", "ranks": 1, "lane": "Ruin", "row": 7,
			"desc": "When Ruin detonates, every other enemy gains {v} Ruin.",
			"scale": {"step": 4},
			"payload": {"stat": {"unravel_ranks": 4}}},
		# --- Lane MADNESS — enemies turned on each other. §2: EVERY EFFECT IN
		# THIS LANE IS REFUSED BY A BOSS UNTIL IT IS BROKEN. That is not a hole,
		# it is a task, and the task is the Ruin lane's job (Broken Will,
		# Entropy). The fix Batch AX shipped was LEGIBILITY, not a workaround:
		# the rule is stated here, in the glossary and in the tooltips. ---
		# Two magnitudes, two fields: a chance and a stack count, and one counter
		# cannot honestly hold both (AW's `covenant` precedent).
		{"id": "oc_spread", "name": "Spread of Madness", "ranks": 1, "lane": "Madness", "row": 1,
			"desc": "Psychosis has a {v}% chance each turn to leap to a fellow minion — the newly maddened gain 2 Ruin. Bosses resist until Broken.",
			"scale": {"step": 60},
			"payload": {"stat": {"spread_ranks": 60, "spread_ruin": 2}}},
		# The counter holds the INCREASE on Psychosis's own 50%.
		{"id": "oc_whispers", "name": "Whispers", "ranks": 1, "lane": "Madness", "row": 2,
			"desc": "Psychosis seizes its victim {v}% of the time (up from the base 50%). Bosses resist Psychosis until Broken.",
			"scale": {"base": 50, "step": 45},
			"payload": {"stat": {"whispers_step": 45}}},
		# §4's authored fallback (AU §1): a hero who already EARNED Mind Flay
		# gets a THIRD mind instead of a grant it cannot make.
		{"id": "oc_mind_flay", "name": "Mind Flay", "ranks": 1, "lane": "Madness", "row": 3,
			"desc": "New ability: Mind Flay — 30% of Attack in shadow to TWO chosen minions, inflicting Psychosis for 3 turns (25 Mana, 3.0 int, 2cd; Perfect: 4 turns). Bosses resist until Broken.",
			"payload": {"grant_ability": "Mind Flay",
				"upgrade": [{"ability": "Mind Flay",
					"set": {"choose_two": false, "choose_three": true,
						"description": "Flay THREE chosen minds: 30% of\nAttack in shadow each and Psychosis\nfor 3 turns — madness that turns\nthem on their own."}}]}},
		{"id": "oc_mirror", "name": "Umbral Mirror", "ranks": 1, "lane": "Madness", "row": 4,
			"desc": "When an enemy would debuff a hero, there is a {v}% chance the debuff rebounds onto the attacker instead (and counts toward Ruin).",
			"scale": {"step": 45},
			"payload": {"stat": {"mirror_ranks": 45}}},
		# THE cross-lane node — every maddened strike builds toward a detonation.
		{"id": "oc_delirium", "name": "Delirium", "ranks": 1, "lane": "Madness", "row": 5,
			"desc": "When a Psychotic, Bewitched or Hysterical enemy strikes a fellow, the victim is marked with {v} Ruin.",
			"scale": {"step": 3},
			"payload": {"stat": {"delirium_ranks": 3}}},
		{"id": "oc_cackling", "name": "Cackling Mirror", "ranks": 1, "lane": "Madness", "row": 6,
			"desc": "When an enemy strikes a fellow, the party heals {v}% of the damage dealt.",
			"scale": {"step": 15},
			"payload": {"stat": {"cackling_ranks": 15}}},
		{"id": "oc_torment", "name": "Lingering Torment", "ranks": 1, "lane": "Madness", "row": 7,
			"desc": "An expiring madness effect leaves Decay behind for {v} turns (10 Break damage per turn).",
			"scale": {"step": 5},
			"payload": {"stat": {"torment_ranks": 5}}},
		# --- Lane LEECH — suffering into sustain. Holy restores, the Devout
		# prevents, the Occultist siphons. The passive's draught is PER STACK
		# since Batch AX (2% each, replacing the flat 10%-while-any-Ruin), so
		# these two dials finally reward the depth the passive was ignoring —
		# and ALL OF IT sits under §1's 40%-of-damage-dealt cap. ---
		# The counter holds the INCREASE on the passive's own 2% per stack.
		{"id": "oc_soul_leech", "name": "Soul Leech", "ranks": 1, "lane": "Leech", "row": 1,
			"desc": "The Ruin lifesteal rises to {v}% per stack (up from the base 2%). Capped at 40% of the damage dealt.",
			"scale": {"base": 2, "step": 3},
			"payload": {"stat": {"soul_leech_step": 3}}},
		{"id": "oc_invigoration", "name": "Invigoration", "ranks": 1, "lane": "Leech", "row": 2,
			"desc": "Dark Pact also restores {v}% of the Occultist's maximum Mana each turn for 3 turns.",
			"scale": {"step": 8},
			"payload": {"stat": {"invigoration_ranks": 8}}},
		{"id": "oc_gluttony", "name": "Gluttony", "ranks": 1, "lane": "Leech", "row": 3,
			"desc": "The Ruin lifesteal drinks another {v}% per stack. Capped at 40% of the damage dealt.",
			"scale": {"step": 3},
			"payload": {"stat": {"gluttony_ranks": 3}}},
		# A FRACTIONAL magnitude, so the field must NOT end in "_ranks" —
		# Runes.STAT_INT_KEYS coerces anything with that suffix to an int.
		{"id": "oc_pleasure", "name": "Pleasure from Pain", "ranks": 1, "lane": "Leech", "row": 4,
			"desc": "At the end of the Occultist's turn, the party heals {v}% of his maximum health for every UNIQUE debuff on the enemy team.",
			"scale": {"step": 2.5},
			"payload": {"stat": {"pleasure_pct": 2.5}}},
		{"id": "oc_murderous", "name": "Murderous Intent", "ranks": 1, "lane": "Leech", "row": 5,
			"desc": "When a Bewitched enemy kills one of its fellows, the lowest-health party member heals {v}% of the Occultist's maximum health.",
			"scale": {"step": 35},
			"payload": {"stat": {"murderous_ranks": 35}}},
		# The in-lane fork: one ability, pay less or get more. Dark Pact is the
		# one place he trades his own body for the party's. The counter is
		# percentage POINTS off the base cost of 20%.
		{"id": "oc_pact_flesh", "name": "Pact of Flesh", "ranks": 1, "lane": "Leech", "row": 6,
			"desc": "Dark Pact bleeds {v}% less of the Occultist's maximum health — a cost of 5% rather than 20%.",
			"scale": {"step": 15},
			"payload": {"stat": {"pact_flesh_ranks": 15}}},
		# The other jaw of the fork. A FOURTH counter holding the INCREASE on a
		# base the kit already pays (Dark Pact's 15%), so it takes the `_step`
		# name the other three do — §5 named three; this one has the same shape.
		{"id": "oc_barter", "name": "Dark Barter", "ranks": 1, "lane": "Leech", "row": 7,
			"desc": "Dark Pact heals every other ally {v}% of their maximum health (up from the base 15%).",
			"scale": {"base": 15, "step": 20},
			"payload": {"stat": {"barter_step": 20}}},
		# --- Capstones (row 8): take ONE, no lane requirement ---
		# RE-SPECCED, because keeping the stacks is the DEFAULT now (Batch AX
		# §1). Its old job — "detonations no longer consume their stacks" — is
		# what the passive does without it, so the capstone moves the THRESHOLD
		# instead: it doubles his detonation rate, and it is the answer for a
		# player who wants the payoff back in ordinary fights. The counter is the
		# GATE AND THE MAGNITUDE in one field (AW's `judgement` precedent): it
		# holds the threshold it installs.
		{"id": "oc_avatar_ruin", "name": "Avatar of Ruin", "ranks": 1, "lane": "Ruin", "row": 8,
			"capstone": true,
			"desc": "Ruin detonates every 5th stack instead of every 10th.",
			"payload": {"stat": {"avatar_ruin": 5}}},
		# §4's second authored fallback: a hero who already EARNED Mass Hysteria
		# gets it back twice as often instead of a grant it cannot make.
		{"id": "oc_hysteria", "name": "Mass Hysteria", "ranks": 1, "lane": "Madness", "row": 8,
			"capstone": true,
			"desc": "New ability: Mass Hysteria — next turn every minion strikes a fellow with DOUBLE Break damage, Sundering them for 3 turns (30 Mana, 4.0 int, 4cd; Perfect: 3cd). Bosses resist until Broken.",
			"payload": {"grant_ability": "Mass Hysteria",
				"upgrade": [{"ability": "Mass Hysteria", "set": {"cooldown": 2}}]}},
		{"id": "oc_soul_glut", "name": "Soul Glut", "ranks": 1, "lane": "Leech", "row": 8,
			"capstone": true,
			"desc": "Whenever a hero heals by striking a Ruined target, the whole party heals for the same amount. Still under the 40% cap.",
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
		# Two decimals, then the dead ones trimmed: a whole number reads "25"
		# rather than "25.00" (every tooltip in all twelve trees said the
		# latter until Batch AP) and a genuine 2.5 still reads "2.5".
		var txt := String.num(val, 2)
		if txt.contains("."):
			txt = txt.rstrip("0").rstrip(".")
		desc = desc.replace("{v}", txt)
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
#   "flex"   — a SECOND node in a row already picked, and only ever a second
#              (never a third).
#
# BATCH AN CHANGED WHO CAN PAY FOR A "flex" PICK, not which picks are flex.
# Batch AI had 8 points against an 8-node tree, so a normal point had to be
# BARRED from second nodes or the tree could be climbed faster than the
# schedule intended. At AN's 12 against 8 the shape does the barring by
# itself — rows are mutually exclusive and there are only eight of them, so
# a purse can open at most 8 rows and any surplus has nowhere to go BUT
# second nodes. The flex purse survives and is spent FIRST when it holds
# anything (old saves, and any future relic granting flexibility without
# granting climb); normal points cover it when it is empty. See
# `purse_for` — every call site asks it rather than reading `pool` raw.
#
# "why" prefixes matter to the hero screen's greying: Locked / Closed /
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
	# One sibling taken: the door is shut, but a surplus point forces it.
	var sib := node_in_tree(tree_nodes, String(picks[0]))
	return {"ok": true, "pool": "flex",
		"why": "Closed by %s — a surplus point forces it open" % \
			sib.get("name", picks[0])}


# WHICH PURSE ACTUALLY PAYS, given what the member is carrying. One place
# decides it so the hero screen's greying, its tooltip and the spend itself
# can never disagree — the bug shape that hid Measured Rage for two batches
# was exactly two read sites answering one question.
# Returns "" when nothing in the member's purses can cover the pick.
static func purse_for(member: Dictionary, check: Dictionary) -> String:
	if not bool(check.get("ok", false)):
		return ""
	if String(check.get("pool", "")) == "flex":
		# Flex is spent first while it lasts; normal points cover it after.
		if int(member.get("talent_flex", 0)) > 0:
			return "talent_flex"
		return "talent_points" if int(member.get("talent_points", 0)) > 0 else ""
	return "talent_points" if int(member.get("talent_points", 0)) > 0 else ""


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
#
# BATCH AU §1 — AN EARNED ABILITY NO LONGER KILLS ITS OWN TREE NODE. The rule
# ran ONE DIRECTION ONLY: a talent that had already granted an ability stopped
# the boss offering it, but taking Magi's Wrath from a zone boss left its
# capstone node granting something the hero already owned, and that row
# silently dropped to two live options. Filtering the boss pool is NOT the fix
# — SPEC_POOLS entries ARE tree nodes across the roster, so filtering would
# empty pools. THE NODE UPGRADES THE ABILITY INSTEAD OF GRANTING IT:
#   * an authored `upgrade` list wins where a class batch has written one;
#   * otherwise the node owes its GENERIC fallback — the highest-priority
#     eligible ABILITY_UPGRADES entry the ability does not already carry.
# The generic is RESOLVED IN `Run.apply_upgrades`, not here, for two reasons.
# The table and its eligibility rules live on Run (an autoload identifier does
# not resolve inside a class_name script), and more importantly AP's ordering
# rule is load-bearing: several talents and runes SET an ability field, so an
# upgrade applied mid-tree would be silently overwritten. Upgrades go LAST.
# This records WHICH abilities owe one; apply_upgrades decides WHAT they get.
#
# `no_fallback: true` opts a node out — the authored answer is "nothing extra
# is needed". Magi's Wrath is the only one today: its capstone carries the
# step-doubling as a passive since Batch AU §4, so owning the ability already
# does not make the node dead.
const FALLBACK_KEY := "talent_upgrade_fallbacks"


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
			_collided(cfg, payload, nab.display_name, ranks, ctx)
	elif payload.has("grant_ability"):
		# The ability def lives in Classes (single source shared with the
		# DOD_SIM_ABILITIES hook), not inline in the node.
		var granted := Classes.pending_talent_ability(payload["grant_ability"])
		if granted != null:
			if not cfg["abilities"].any(func(a): return a.display_name == granted.display_name):
				cfg["abilities"] = cfg["abilities"] + [granted]
			else:
				_collided(cfg, payload, granted.display_name, ranks, ctx)
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


# THE COLLISION SITE (Batch AU §1) — reached when an ability-granting node
# finds the hero already holding what it grants. Exactly one rule, so no
# ability-granting node in the game can be silently dead:
#   1. an AUTHORED fallback (`upgrade`) wins where a class batch wrote one;
#   2. `no_fallback: true` means the authored answer is deliberately nothing;
#   3. otherwise the node OWES ITS GENERIC — recorded on the cfg by ability
#      name and resolved by `Run.apply_upgrades`, which runs last.
static func _collided(cfg: Dictionary, payload: Dictionary, display_name: String,
		ranks: int, ctx: Dictionary) -> void:
	var authored: Array = payload.get("upgrade", [])
	if not authored.is_empty():
		for up in authored:
			apply_payload(cfg, up, ranks, ctx)
		return
	if bool(payload.get("no_fallback", false)):
		return
	cfg[FALLBACK_KEY] = cfg.get(FALLBACK_KEY, []) + [display_name]


# Does this node's payload grant an ability, and if so which? "" when it does
# not. The hero screen asks it to decide whether a node's tooltip needs the
# collision line at all — one answer, so the tooltip cannot claim a fallback
# for a node that has nothing to fall back from.
static func granted_name(payload: Dictionary) -> String:
	if payload.has("new_ability"):
		return String(payload["new_ability"].get("display_name", ""))
	if payload.has("grant_ability"):
		return String(payload["grant_ability"])
	return ""


# What a node does when its grant collides, for the tooltip: "authored" (a
# class batch wrote one), "none" (deliberately nothing) or "generic".
static func collision_kind(payload: Dictionary) -> String:
	if not (payload.get("upgrade", []) as Array).is_empty():
		return "authored"
	if bool(payload.get("no_fallback", false)):
		return "none"
	return "generic"
