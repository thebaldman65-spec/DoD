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
	"berserker": [
		# --- row 0 ---
		{"id": "bz_bloodcraze", "name": "Bloodcraze", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When an enemy bleeds out, the Berserker heals {v}% of max HP.",
			"scale": {"step": 3},
			"payload": {"stat": {"bloodcraze": 1}}},
		{"id": "bz_unstoppable", "name": "Unstoppable", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Blood Frenzy grants {v}% damage for every 5% of health missing (up from the base 2%).",
			"scale": {"base": 2.0, "step": 0.5},
			"payload": {"stat": {"bloodrage_step_bonus": 0.5}}},
		{"id": "bz_enraged", "name": "Enraged", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Dropping below 50% health grants a +{v}% damage buff for 5 turns (stacks up to 3 times).",
			"scale": {"step": 3},
			"payload": {"stat": {"enraged_ranks": 1}}},
		# --- row 1 ---
		{"id": "bz_crushing_blows", "name": "Crushing Blows", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "For every 20 points of bloodloss on the enemy team, gain {v}% armor penetration.",
			"scale": {"step": 3},
			"payload": {"stat": {"crushing_blows_ranks": 1}}},
		{"id": "bz_savagery", "name": "Savagery", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "bz_unstoppable", "requires_ranks": 1,
			"desc": "All bleed-building Berserker abilities build +{v} more Bleed.",
			"scale": {"step": 5},
			"payload": {"stat": {"bleed_bonus": 5}}},
		{"id": "bz_battle_shout", "name": "Battle Shout", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Battle Shout — +1% damage for every 20 points of blood buildup on the enemy party, for 2 turns (15 Rage, 2cd).",
			"payload": {"new_ability": {"display_name": "Battle Shout", "cost": 15,
				"special": "battle_shout", "delay": 2.0, "anim": "attack03", "cooldown": 2,
				"perfect_id": "rage5", "perfect_text": "Also grants 5 Rage",
				"description": "A roar fed by open wounds: +1% damage\nper 20 blood buildup on the enemy party.\nLasts 2 turns."}}},
		{"id": "bz_reckless", "name": "Reckless Fury", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "bz_unstoppable", "requires_ranks": 1,
			"desc": "+{v}% damage dealt AND +{v}% damage taken.",
			"scale": {"step": 5},
			"payload": {"stat": {"dmg_bonus": 0.05, "dmg_taken_bonus": 0.05}}},
		{"id": "bz_unrelenting", "name": "Unrelenting Assault", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Dropping below 25% health grants +{v} Constitution for 3 turns (at most once every 5 turns).",
			"scale": {"step": 10},
			"payload": {"stat": {"unrelenting_ranks": 1}}},
		# --- row 2 ---
		{"id": "bz_hemorrhage", "name": "Hemorrhage", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Enemies at {v} or more bloodloss are Crippled.",
			"scale": {"base": 90, "step": -10},
			"payload": {"stat": {"hemorrhage_ranks": 1}}},
		{"id": "bz_bloodlust_node", "name": "Bloodlust", "ranks": 1, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Hack and Slash strikes an extra time.",
			"payload": {"ability": "Hack and Slash", "add": {"multi_hits": 1}}},
		{"id": "bz_vitality", "name": "Vitality", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+{v}% max HP.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# --- row 3 (capstone) ---
		{"id": "bz_rampage", "name": "Rampage", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Rampage — strike 3 times for damage and bloodloss; if the target dies, immediately recast on another enemy (40 Rage, 4.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 40,
				"damage": 20, "pressure": 10, "multi_hits": 3, "bleed_build": 10,
				"delay": 4.0, "anim": "attack01", "cooldown": 4,
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "",
				"description": "Three brutal strikes, each building\n10 bloodloss. If the target dies, Rampage\nimmediately recasts on another enemy."}}},
	],
	"swordmaster": [
		# --- row 0 ---
		{"id": "sm_def_stance", "name": "Defensive Stance", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Seasoned Fighter reduces damage taken while under 50% health by an additional {v}%.",
			"scale": {"step": 3},
			"payload": {"stat": {"seasoned_def_bonus": 0.03}}},
		{"id": "sm_swordsmanship", "name": "Swordsmanship", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "A perfect Pommel Strike grants +{v}% more parry chance.",
			"scale": {"step": 5},
			"payload": {"stat": {"pommel_parry_bonus": 0.05}}},
		{"id": "sm_agg_stance", "name": "Aggressive Stance", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Seasoned Fighter increases damage dealt above 50% health by an additional {v}%.",
			"scale": {"step": 3},
			"payload": {"stat": {"seasoned_off_bonus": 0.03}}},
		# --- row 1 ---
		{"id": "sm_dominant", "name": "Dominant Presence", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Armor value is increased by {v}% for every debuff the Swordmaster applies this battle.",
			"scale": {"step": 5},
			"payload": {"stat": {"dominant_ranks": 1}}},
		{"id": "sm_high_guard", "name": "High Guard", "ranks": 1, "row": 1, "col": 1,
			"gate": "row", "requires": "sm_swordsmanship", "requires_ranks": 1,
			"desc": "Take 25% less damage for 1 turn after parrying an attack.",
			"payload": {"stat": {"high_guard": 1}}},
		{"id": "sm_lunge", "name": "Lunge", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Lunge — 35 damage; applies Exposed while above 50% health, Cripple while below (25 Rage, 3.5 int).",
			"payload": {"new_ability": {"display_name": "Lunge", "cost": 25,
				"damage": 35, "pressure": 20, "delay": 3.5, "anim": "attack02",
				"resource_gain": 10,
				"perfect_id": "", "perfect_text": "Initiative cost 3.0 instead",
				"description": "A committed thrust. Above 50% HP it\nExposes the target; below, it Cripples\nthem (3 turns). Builds 10 Rage."}}},
		{"id": "sm_riposte", "name": "Riposte", "ranks": 1, "row": 1, "col": 3,
			"gate": "row", "requires": "sm_swordsmanship", "requires_ranks": 1,
			"desc": "Counter Attack: immediately answer every parry with a Strike.",
			"payload": {"stat": {"counter_attacks": 1}}},
		{"id": "sm_precision", "name": "Precision Strikes", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+{v}% critical strike chance against Dazed, Crippled, and Exposed targets.",
			"scale": {"step": 5},
			"payload": {"stat": {"precision_ranks": 1}}},
		# --- row 2 ---
		{"id": "sm_seasoned_node", "name": "Seasoned Fighter", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Lunge and Overpower gain +{v}% critical strike chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"blade_crit_ranks": 1}}},
		{"id": "sm_opportunist", "name": "Opportunist", "ranks": 1, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When an enemy attack misses the Swordmaster, he counter attacks with Overpower (free).",
			"payload": {"stat": {"opportunist": 1}}},
		{"id": "sm_sword_mastery", "name": "Sword Mastery", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+{v}% parry chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"parry_bonus": 0.03}}},
		# --- row 3 (capstone) ---
		{"id": "sm_execute", "name": "Execute", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Execute — 55 damage / 50 BD; only usable against targets below 20% health; a perfect guarantees a crit (30 Rage, 2.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Execute", "cost": 30,
				"damage": 55, "pressure": 50, "delay": 2.0, "anim": "attack03",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "Guaranteed critical strike",
				"description": "End them. Only usable against targets\nbelow 20% health."}}},
	],
	"cryomancer": [
		# --- row 0 ---
		{"id": "cr_hungering", "name": "Hungering Cold", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Chilled enemies deal {v}% less damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hungering_ranks": 1}}},
		# Renamed from "Frostbite" 07-20 — that name now belongs to the healing-
		# cut status (Rime / Permafrost). Same id, so saved ranks carry over.
		{"id": "cr_frostbite", "name": "Brittle Ice", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Frozen enemies are {v}% more likely to be struck by a critical hit.",
			"scale": {"step": 2},
			"payload": {"stat": {"frostbite_ranks": 1}}},
		{"id": "cr_piercing", "name": "Piercing Ice", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Ice Lance gains {v}% critical strike damage.",
			"scale": {"step": 10},
			"payload": {"stat": {"piercing_ice_ranks": 1}}},
		# --- row 1 ---
		{"id": "cr_hypothermia", "name": "Hypothermia", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Enemies take {v}% more damage per stack of Chilled.",
			"scale": {"step": 1},
			"payload": {"stat": {"hypothermia_ranks": 1}}},
		{"id": "cr_frigid", "name": "Frigid Grip", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every stack of Chilled slows {v}% harder.",
			"scale": {"step": 3},
			"payload": {"stat": {"frigid_ranks": 1}}},
		{"id": "cr_rime", "name": "Rime", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Rime — inflicts Frostbite (-50% healing received, 2 turns); for 3 turns, every stack of Chilled the target gains also chills one other random enemy (25 Mana, 3.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Rime", "cost": 25,
				"special": "rime", "delay": 3.0, "anim": "attack02", "cooldown": 3,
				"perfect_id": "", "perfect_text": "Lasts 4 turns",
				"description": "Hoarfrost takes root: Frostbites the\ntarget (-50% healing received, 2 turns);\nfor 3 turns, every stack of Chilled\nthis enemy gains also chills one\nother random enemy."}}},
		{"id": "cr_icy_veins", "name": "Icy Veins", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Killing an enemy with Ice Lance empowers your next Ice Lance by {v}%.",
			"scale": {"step": 15},
			"payload": {"stat": {"icy_veins_ranks": 1}}},
		{"id": "cr_splinter", "name": "Splintering Shards", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Razor Ice has a {v}% chance to strike an additional target.",
			"scale": {"step": 20},
			"payload": {"stat": {"splinter_ranks": 1}}},
		# --- row 2 ---
		{"id": "cr_whiteout", "name": "Whiteout", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Enemies hit by Blizzard have a {v}% chance to become Dazed (2 turns).",
			"scale": {"step": 15},
			"payload": {"stat": {"whiteout_ranks": 1}}},
		{"id": "cr_freezing", "name": "Freezing Advance", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Whenever Rime spreads Chilled to an enemy, that enemy takes {v}% of your Attack as frost damage.",
			"scale": {"step": 2},
			"payload": {"stat": {"freezing_ranks": 1}}},
		{"id": "cr_emp_frostbolt", "name": "Empowered Frostbolt", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Frostbolt deals an extra {v}% of Attack.",
			"scale": {"step": 2},
			"payload": {"stat": {"emp_frostbolt_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "cr_shatter", "name": "Shatter", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Shatter — deal 10% of Attack × their Chilled stacks to EVERY Chilled enemy (30 Mana, 4.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Shatter", "cost": 30,
				"dmg_type": "frost", "damage": 10, "pressure": 10, "aoe": true,
				"delay": 4.0, "anim": "attack03", "cooldown": 5,
				"perfect_id": "", "perfect_text": "Cooldown becomes 4 instead",
				"description": "The cold detonates: every Chilled\nenemy takes 10% of Attack PER STACK\nof Chilled on it."}}},
	],
	"holy": [
		# --- row 0 ---
		{"id": "hl_triage", "name": "Triage", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Instant heals can CRIT (x1.5, using your critical strike chance), and all your healing is increased by {v}%.",
			"scale": {"step": 3},
			"payload": {"stat": {"triage_ranks": 1}}},
		{"id": "hl_heavenly", "name": "Heavenly Aura", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Each stack of Mercy grants {v}% healing done (up from the base 5%).",
			"scale": {"base": 5, "step": 5},
			"payload": {"stat": {"heavenly_ranks": 1}}},
		{"id": "hl_holy_light", "name": "Holy Light", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Perfect casts restore {v}% of your maximum Mana.",
			"scale": {"step": 1},
			"payload": {"stat": {"holy_light_ranks": 1}}},
		# --- row 1 ---
		{"id": "hl_guardian", "name": "Guardian Angel", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Allies falling below {v}% health earn you a stack of Mercy (up from 50%).",
			"scale": {"base": 50, "step": 3},
			"payload": {"stat": {"guardian_ranks": 1}}},
		{"id": "hl_presence", "name": "Divine Presence", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "At the end of your turn, the lowest-health ally is healed for {v}% of their maximum health.",
			"scale": {"step": 1},
			"payload": {"stat": {"divine_presence_ranks": 1}}},
		{"id": "hl_resurrection", "name": "Resurrection", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Resurrection — spend 3 Mercy to return a fallen ally to life with 20% health and resource; Empower (+1 Mercy): full health and resource plus 5 turns of Renewal (4.0 int, 3cd).",
			"payload": {"grant_ability": "Resurrection"}},
		{"id": "hl_last_hope", "name": "Last Hope", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Allies under 25% of their max health receive {v}% more healing.",
			"scale": {"step": 5},
			"payload": {"stat": {"last_hope_ranks": 1}}},
		{"id": "hl_inner_faith", "name": "Inner Faith", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Increases your maximum health by {v}%.",
			"scale": {"step": 5},
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# --- row 2 ---
		{"id": "hl_capacitor", "name": "Holy Capacitor", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "{v}% of your overhealing is stored and released by your next Heal.",
			"scale": {"step": 5},
			"payload": {"stat": {"capacitor_ranks": 1}}},
		{"id": "hl_on_mend", "name": "On the Mend", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Renewal ticks have a {v}% chance to dispel one harmful effect from the bearer.",
			"scale": {"step": 5},
			"payload": {"stat": {"on_mend_ranks": 1}}},
		{"id": "hl_sanctified", "name": "Sanctified", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Spending Mercy has a {v}% chance to consume no stacks.",
			"scale": {"step": 10},
			"payload": {"stat": {"sanctified_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "hl_divine_plea", "name": "Divine Plea", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Divine Plea — spend 2 Mercy to FULLY heal an ally; Empower (+1 Mercy): also cleanse all debuffs and Consecrate them against new ones for 3 turns (3.0 int, 2cd).",
			"payload": {"grant_ability": "Divine Plea"}},
	],
	"inquisitor": [
		# --- row 0 ---
		{"id": "dv_communion", "name": "Communion", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When a party member reaches 5 Faith, every other member has a ({v} x their own Faith stacks)% chance to gain 1 stack.",
			"scale": {"step": 20},
			"payload": {"stat": {"communion_ranks": 1}}},
		{"id": "dv_unwavering", "name": "Unwavering Faith", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Each stack of Faith grants an additional {v}% damage mitigation and damage increase.",
			"scale": {"step": 0.5},
			"payload": {"stat": {"unwavering_ranks": 1}}},
		{"id": "dv_faithful", "name": "Blessed are the Faithful", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "The heal at 5 stacks of Faith restores {v}% max health (up from the base 15%).",
			"scale": {"base": 15, "step": 5},
			"payload": {"stat": {"faithful_ranks": 1}}},
		# --- row 1 ---
		{"id": "dv_devoutness", "name": "Devoutness", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "The entire party takes {v}% less Break damage.",
			"scale": {"step": 5},
			"payload": {"stat": {"devoutness_ranks": 1}}},
		{"id": "dv_afterglow", "name": "Afterglow", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When Divine Shield breaks, its holder is healed for {v}% of the Devout's max health.",
			"scale": {"step": 5},
			"payload": {"stat": {"afterglow_ranks": 1}}},
		{"id": "dv_resolve", "name": "Sacred Resolve", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Sacred Resolve — all damage received is split evenly among living heroes for 3 turns; Break damage still lands on the struck hero (25 Mana, 3.0 int, 5cd; Perfect: 4 turns).",
			"payload": {"grant_ability": "Sacred Resolve"}},
		{"id": "dv_covenant", "name": "Sacred Covenant", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Should Divine Shield prevent lethal damage, its holder is healed for {v}% max health and gains that many Faith stacks (1 per rank).",
			"scale": {"step": 5},
			"payload": {"stat": {"covenant_ranks": 1}}},
		{"id": "dv_aegis", "name": "Radient Aegis", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Casting Divine Shield has a {v}% chance to cast it again on another ally.",
			"scale": {"step": 15},
			"payload": {"stat": {"aegis_ranks": 1}}},
		# --- row 2 ---
		{"id": "dv_barrier", "name": "Blessed Barrier", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Divine Shield converts {v}% of the damage it absorbs into healing for its holder.",
			"scale": {"step": 3},
			"payload": {"stat": {"blessed_barrier_ranks": 1}}},
		{"id": "dv_waters", "name": "Cleansing Waters", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "While Sacred Resolve holds, each party member has a {v}% chance each turn to be cleansed of one harmful effect.",
			"scale": {"step": 15},
			"payload": {"stat": {"waters_ranks": 1}}},
		{"id": "dv_pulse", "name": "Healing Pulse", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "While Sacred Resolve holds, the party heals {v}% of the Devout's max health each turn.",
			"scale": {"step": 2},
			"payload": {"stat": {"pulse_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "dv_bulwark", "name": "Bulwark of Fortitude", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Bulwark of Fortitude — for 3 turns the party takes NO Break damage, gains +50% armor, and heals 10% of max health each turn (30 Mana, 3.5 int, 3cd; Perfect: the party instantly heals 5%).",
			"payload": {"grant_ability": "Bulwark of Fortitude"}},
	],
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
	"pyromancer": [
		# --- row 0 ---
		{"id": "py_accelerant", "name": "Accelerant", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Your Burn ticks deal +{v}% of Attack (on top of the base 6%).",
			"scale": {"step": 1},
			"payload": {"stat": {"accelerant_ranks": 1}}},
		{"id": "py_pyromaniac", "name": "Pyromaniac", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Inferno Master grants {v}% damage per burning enemy (up from the base 5%).",
			"scale": {"base": 5, "step": 1},
			"payload": {"stat": {"pyromaniac_ranks": 1}}},
		{"id": "py_supernova", "name": "Super Nova", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Detonation gains +{v}% critical strike chance.",
			"scale": {"step": 3},
			"payload": {"stat": {"supernova_ranks": 1}}},
		# --- row 1 ---
		{"id": "py_invigorating", "name": "Invigorating Ashes", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every Burn tick has a {v}% chance to restore 2% of the Pyromancer's max Mana.",
			"scale": {"step": 5},
			"payload": {"stat": {"invigorating_ranks": 1}}},
		{"id": "py_molten", "name": "Molten Core", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Take {v}% less damage from burning enemies.",
			"scale": {"step": 2},
			"payload": {"stat": {"molten_ranks": 1}}},
		{"id": "py_flame_shield", "name": "Flame Shield", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Flame Shield — take 50% less damage for 2 turns and attackers are set Burning for 3 turns (15 Mana, 2.0 int, 2cd).",
			"payload": {"new_ability": {"display_name": "Flame Shield", "cost": 15,
				"special": "flame_shield", "delay": 2.0, "anim": "attack03", "cooldown": 2,
				"perfect_id": "", "perfect_text": "Also triggers a Burn tick on every burning enemy",
				"description": "A barrier of living flame: take 50%\nless damage for 2 turns, and whoever\nstrikes the Pyromancer is set Burning\n(3 turns)."}}},
		{"id": "py_explosive", "name": "Explosive Force", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Critical hits with fire abilities extend the target's Burn by {v} turn(s).",
			"scale": {"step": 1},
			"payload": {"stat": {"explosive_ranks": 1}}},
		{"id": "py_seeding", "name": "Seeding Embers", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When an enemy dies while Burning, gain {v}% damage per Burn turn it had left, for your next turn.",
			"scale": {"step": 1},
			"payload": {"stat": {"seeding_ranks": 1}}},
		# --- row 2 ---
		{"id": "py_melt", "name": "Melt Armor", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every Burn tick melts the victim's armor by {v}% for the rest of the battle.",
			"scale": {"step": 1},
			"payload": {"stat": {"melt_ranks": 1}}},
		{"id": "py_ashes", "name": "Ashes of Al'ar", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Upon death: {v}% chance to revive with 25% health (once per battle).",
			"scale": {"step": 11},
			"payload": {"stat": {"ashes_ranks": 1}}},
		{"id": "py_implosion", "name": "Implosion", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Detonation has a {v}% chance to strike twice.",
			"scale": {"step": 3},
			"payload": {"stat": {"implosion_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "py_firestorm", "name": "Firestorm", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Firestorm — rain fire on 6-8 random enemies for 12% of Attack each, applying Burn (30 Mana, 3.5 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Firestorm", "cost": 30,
				"dmg_type": "fire", "damage": 12, "pressure": 8, "random_hits": 6,
				"perfect_extra_hit": false, "delay": 3.5, "anim": "attack03", "cooldown": 4,
				"applies_status": {"id": "burn", "turns": 2},
				"perfect_id": "", "perfect_text": "Hits 7-9 times instead",
				"description": "The sky ignites: 6-8 bolts rake random\nenemies for 12% of Attack, each one\nsetting its victim Burning (2 turns\nper bolt — repeats stack)."}}},
	],
	"warden": [
		# --- row 0 ---
		{"id": "wd_tank_spank", "name": "Tank and Spank", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Mocking Blow has a {v}% chance to Empower a random ally (2 turns).",
			"scale": {"step": 15},
			"payload": {"stat": {"tank_spank_ranks": 1}}},
		{"id": "wd_unkillable", "name": "Unkillable", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every time you Block an attack, heal for {v}% of maximum health.",
			"scale": {"step": 2},
			"payload": {"stat": {"unkillable_ranks": 1}}},
		{"id": "wd_elem_weak", "name": "Elemental Weakness", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Crushing Blow also reduces all elemental resistances of the target by {v}% (3 turns).",
			"scale": {"step": 5},
			"payload": {"stat": {"elem_weak_ranks": 1}}},
		# --- row 1 ---
		{"id": "wd_toughness", "name": "Toughness", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Constitution is increased by {v}% of maximum HP.",
			"scale": {"step": 5},
			"payload": {"stat": {"toughness_ranks": 1}}},
		{"id": "wd_tenacity", "name": "Tenacity", "ranks": 1, "row": 1, "col": 1,
			"gate": "row", "requires": "wd_unkillable", "requires_ranks": 1,
			"desc": "Every attack Blocked by Heavy Plating increases maximum health by 5 for the rest of the battle.",
			"payload": {"stat": {"tenacity": 1}}},
		{"id": "wd_shieldwall", "name": "Shieldwall", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Shieldwall — raise your shield and Block the next 3 attacks; a perfect blocks 5 (25 Rage, 2.0 int, 2cd).",
			"payload": {"new_ability": {"display_name": "Shieldwall", "cost": 25,
				"special": "shield_block", "delay": 2.0, "anim": "attack01",
				"cooldown": 2,
				"perfect_id": "", "perfect_text": "Blocks 5 attacks instead",
				"description": "Raise the shield: the next 3 attacks\nagainst the Warden are BLOCKED."}}},
		{"id": "wd_rally", "name": "Rally", "ranks": 1, "row": 1, "col": 3,
			"gate": "row", "requires": "wd_unkillable", "requires_ranks": 1,
			"desc": "Every attack Blocked by Heavy Plating grants the party +15% healing received for 2 turns.",
			"payload": {"stat": {"rally": 1}}},
		{"id": "wd_iron_will", "name": "Iron Will", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+{v}% damage for every debuff currently on the Warden.",
			"scale": {"step": 5},
			"payload": {"stat": {"iron_will_ranks": 1}}},
		# --- row 2 ---
		{"id": "wd_ricochet", "name": "Richocet", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Blocking an attack has a {v}% chance to Stun the attacker.",
			"scale": {"step": 5},
			"payload": {"stat": {"ricochet_ranks": 1}}},
		{"id": "wd_endurance", "name": "Endurance", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+{v}% armor for every turn the Warden is not healed by an external source (resets when healed).",
			"scale": {"step": 1},
			"payload": {"stat": {"endurance_ranks": 1}}},
		{"id": "wd_sundering", "name": "Sundering", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Crushing Blow deals {v}% of its Break damage to enemies Adjacent to the target (dead neighbors block the splash on their side).",
			"scale": {"step": 25},
			"payload": {"stat": {"sundering_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "wd_hold_line", "name": "Hold the Line", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Hold the Line — the party takes 50% less Break damage for 2 turns and cannot die for a turn (30 Rage, 3.5 int, 6cd).",
			"payload": {"new_ability": {"display_name": "Hold the Line", "cost": 30,
				"special": "hold_the_line", "delay": 3.5, "anim": "attack03",
				"cooldown": 6,
				"perfect_id": "", "perfect_text": "Refunds 5 Rage",
				"description": "Embolden the party: 50% less Break\ndamage for 2 turns, and no one can die\nfor a turn."}}},
	],
}


static func has_tree(spec: String) -> bool:
	return FIXED_TREES.has(spec)


static func generate_tree(spec: String, _class_key: String) -> Array:
	# Fixed trees only; specs without one get an empty tree ("coming soon").
	if FIXED_TREES.has(spec):
		return FIXED_TREES[spec].duplicate(true)
	return []


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


static func can_learn(tree_nodes: Array, id: String, learned: Dictionary) -> Dictionary:
	var t := node_in_tree(tree_nodes, id)
	if t.is_empty():
		return {"ok": false, "why": "Unknown"}
	if int(learned.get(id, 0)) >= int(t["ranks"]):
		return {"ok": false, "why": "Maxed"}
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
		cfg["abilities"] = cfg["abilities"] + [Ability.make(payload["new_ability"])]
	elif payload.has("grant_ability"):
		# The ability def lives in Classes (single source shared with the
		# DOD_SIM_ABILITIES hook), not inline in the node.
		var granted := Classes.pending_talent_ability(payload["grant_ability"])
		if granted != null:
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
