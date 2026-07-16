# FIXED talent trees only (designed in the RPG Skill Tree Generator; source
# JSONs live in data/talent-tree-*.json — this file is their hand-tuned
# conversion). Specs without a designed tree show "coming soon" on the party
# screen. Learned talents: {id: ranks}. Ranks are ADDITIVE: every extra point
# adds the same stated amount again.
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
			"desc": "When an enemy bleeds out, the Berserker heals 3% of max HP per rank.",
			"payload": {"stat": {"bloodcraze": 1}}},
		{"id": "bz_unstoppable", "name": "Unstoppable", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Blood Frenzy grants +0.5% more damage per rank for every 5% of health missing (2% -> 2.5% / 3% / 3.5%).",
			"payload": {"stat": {"bloodrage_step_bonus": 0.5}}},
		{"id": "bz_enraged", "name": "Enraged", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Dropping below 50% health grants a +3% per rank damage buff for 5 turns (stacks up to 3 times).",
			"payload": {"stat": {"enraged_ranks": 1}}},
		# --- row 1 ---
		{"id": "bz_crushing_blows", "name": "Crushing Blows", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "For every 20 points of bloodloss on the enemy team, gain 3% armor penetration per rank.",
			"payload": {"stat": {"crushing_blows_ranks": 1}}},
		{"id": "bz_savagery", "name": "Savagery", "ranks": 3, "row": 1, "col": 1,
			"gate": "row", "requires": "bz_unstoppable", "requires_ranks": 1,
			"desc": "All bleed-building Berserker abilities build +5 more Bleed per rank.",
			"payload": {"stat": {"bleed_bonus": 5}}},
		{"id": "bz_battle_shout", "name": "Battle Shout", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Battle Shout — +1% damage for every 20 points of blood buildup on the enemy party, for 2 turns (15 Rage, 3cd).",
			"payload": {"new_ability": {"display_name": "Battle Shout", "cost": 15,
				"special": "battle_shout", "delay": 2.0, "anim": "attack03", "cooldown": 3,
				"perfect_id": "rage5", "perfect_text": "Also grants 5 Rage",
				"description": "A roar fed by open wounds: +1% damage\nper 20 blood buildup on the enemy party.\nLasts 2 turns."}}},
		{"id": "bz_reckless", "name": "Reckless Fury", "ranks": 3, "row": 1, "col": 3,
			"gate": "row", "requires": "bz_unstoppable", "requires_ranks": 1,
			"desc": "+5% damage dealt AND +5% damage taken per rank.",
			"payload": {"stat": {"dmg_bonus": 0.05, "dmg_taken_bonus": 0.05}}},
		{"id": "bz_unrelenting", "name": "Unrelenting Assault", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Dropping below 25% health grants +10 Constitution per rank (at most once every 5 turns).",
			"payload": {"stat": {"unrelenting_ranks": 1}}},
		# --- row 2 ---
		{"id": "bz_hemorrhage", "name": "Hemorrhage", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Enemies at high bloodloss are Crippled; the threshold drops 10 per rank (80 / 70 / 60 buildup).",
			"payload": {"stat": {"hemorrhage_ranks": 1}}},
		{"id": "bz_bloodlust_node", "name": "Bloodlust", "ranks": 1, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Hack and Slash strikes an extra time.",
			"payload": {"ability": "Hack and Slash", "add": {"multi_hits": 1}}},
		{"id": "bz_vitality", "name": "Vitality", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+5% max HP per rank.",
			"payload": {"stat": {"max_hp_pct": 0.05}}},
		# --- row 3 (capstone) ---
		{"id": "bz_rampage", "name": "Rampage", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Rampage — strike 3 times for damage and bloodloss; if the target dies, immediately recast on another enemy (40 Rage, 4.0 int, 5cd).",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 40,
				"damage": 20, "pressure": 10, "multi_hits": 3, "bleed_build": 10,
				"delay": 4.0, "anim": "attack01", "cooldown": 5,
				"perfect_extra_hit": false,
				"perfect_id": "", "perfect_text": "",
				"description": "Three brutal strikes, each building\n10 bloodloss. If the target dies, Rampage\nimmediately recasts on another enemy."}}},
	],
	"swordmaster": [
		# --- row 0 ---
		{"id": "sm_def_stance", "name": "Defensive Stance", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Seasoned Fighter reduces damage taken while under 50% health by an additional 3% per rank.",
			"payload": {"stat": {"seasoned_def_bonus": 0.03}}},
		{"id": "sm_swordsmanship", "name": "Swordsmanship", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "A perfect Pommel Strike grants +5% more parry chance per rank.",
			"payload": {"stat": {"pommel_parry_bonus": 0.05}}},
		{"id": "sm_agg_stance", "name": "Aggressive Stance", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Seasoned Fighter increases damage dealt above 50% health by an additional 3% per rank.",
			"payload": {"stat": {"seasoned_off_bonus": 0.03}}},
		# --- row 1 ---
		{"id": "sm_dominant", "name": "Dominant Presence", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Armor value is increased by 5% per rank for every debuff the Swordmaster applies this battle.",
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
			"desc": "+5% per rank critical strike chance against Dazed, Crippled, and Exposed targets.",
			"payload": {"stat": {"precision_ranks": 1}}},
		# --- row 2 ---
		{"id": "sm_seasoned_node", "name": "Seasoned Fighter", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Lunge and Overpower gain +3% critical strike chance per rank.",
			"payload": {"stat": {"blade_crit_ranks": 1}}},
		{"id": "sm_opportunist", "name": "Opportunist", "ranks": 1, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "When an enemy attack misses the Swordmaster, he counter attacks with Overpower (free).",
			"payload": {"stat": {"opportunist": 1}}},
		{"id": "sm_sword_mastery", "name": "Sword Mastery", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+3% parry chance per rank.",
			"payload": {"stat": {"parry_bonus": 0.03}}},
		# --- row 3 (capstone) ---
		{"id": "sm_execute", "name": "Execute", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Execute — 55 damage / 50 BD; only usable against targets below 20% health; a perfect guarantees a crit (30 Rage, 2.0 int, 4cd).",
			"payload": {"new_ability": {"display_name": "Execute", "cost": 30,
				"damage": 55, "pressure": 50, "delay": 2.0, "anim": "attack03",
				"cooldown": 4,
				"perfect_id": "", "perfect_text": "Guaranteed critical strike",
				"description": "End them. Only usable against targets\nbelow 20% health."}}},
	],
	"warden": [
		# --- row 0 ---
		{"id": "wd_tank_spank", "name": "Tank and Spank", "ranks": 3, "row": 0, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Mocking Blow has a 15% chance per rank to Empower a random ally (2 turns).",
			"payload": {"stat": {"tank_spank_ranks": 1}}},
		{"id": "wd_unkillable", "name": "Unkillable", "ranks": 3, "row": 0, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Every time you Block an attack, heal for 2% of maximum health per rank.",
			"payload": {"stat": {"unkillable_ranks": 1}}},
		{"id": "wd_elem_weak", "name": "Elemental Weakness", "ranks": 3, "row": 0, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Crushing Blow also reduces all elemental resistances of the target by 5% per rank (3 turns).",
			"payload": {"stat": {"elem_weak_ranks": 1}}},
		# --- row 1 ---
		{"id": "wd_toughness", "name": "Toughness", "ranks": 3, "row": 1, "col": 0,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Constitution is increased by 5% of maximum HP per rank.",
			"payload": {"stat": {"toughness_ranks": 1}}},
		{"id": "wd_tenacity", "name": "Tenacity", "ranks": 1, "row": 1, "col": 1,
			"gate": "row", "requires": "wd_unkillable", "requires_ranks": 1,
			"desc": "Every debuff prevented with Hardiness grants +5 max HP for the battle. (PENDING: the Hardiness mechanic is not designed yet.)",
			"payload": {"stat": {"tenacity": 1}}},
		{"id": "wd_shieldwall", "name": "Shieldwall", "ranks": 1, "row": 1, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Shieldwall — raise your shield and Block the next 3 attacks; a perfect blocks 5 (25 Rage, 2.0 int, 3cd).",
			"payload": {"new_ability": {"display_name": "Shieldwall", "cost": 25,
				"special": "shield_block", "delay": 2.0, "anim": "attack01",
				"cooldown": 3,
				"perfect_id": "", "perfect_text": "Blocks 5 attacks instead",
				"description": "Raise the shield: the next 3 attacks\nagainst the Warden are BLOCKED."}}},
		{"id": "wd_rally", "name": "Rally", "ranks": 1, "row": 1, "col": 3,
			"gate": "row", "requires": "wd_unkillable", "requires_ranks": 1,
			"desc": "Every debuff prevented with Hardiness grants the party +15% healing received for a turn. (PENDING: the Hardiness mechanic is not designed yet.)",
			"payload": {"stat": {"rally": 1}}},
		{"id": "wd_iron_will", "name": "Iron Will", "ranks": 3, "row": 1, "col": 4,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+5% damage per rank for every debuff currently on the Warden.",
			"payload": {"stat": {"iron_will_ranks": 1}}},
		# --- row 2 ---
		{"id": "wd_ricochet", "name": "Richocet", "ranks": 3, "row": 2, "col": 1,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Blocking an attack has a 5% chance per rank to Stun the attacker.",
			"payload": {"stat": {"ricochet_ranks": 1}}},
		{"id": "wd_endurance", "name": "Endurance", "ranks": 3, "row": 2, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "+3% armor per rank for every turn the Warden is not healed by an external source (resets when healed).",
			"payload": {"stat": {"endurance_ranks": 1}}},
		{"id": "wd_sundering", "name": "Sundering", "ranks": 3, "row": 2, "col": 3,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "Crushing Blow deals 25% per rank of its Break damage to all other enemies.",
			"payload": {"stat": {"sundering_ranks": 1}}},
		# --- row 3 (capstone) ---
		{"id": "wd_hold_line", "name": "Hold the Line", "ranks": 1, "row": 3, "col": 2,
			"gate": "row", "requires": "", "requires_ranks": 0,
			"desc": "New ability: Hold the Line — the party takes 50% less Break damage for 2 turns and cannot die for a turn (30 Rage, 3.5 int, 7cd).",
			"payload": {"new_ability": {"display_name": "Hold the Line", "cost": 30,
				"special": "hold_the_line", "delay": 3.5, "anim": "attack03",
				"cooldown": 7,
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
	elif payload.has("ability"):
		for ab in cfg["abilities"]:
			if ab.display_name == payload["ability"]:
				for field in payload.get("add", {}):
					ab.set(field, ab.get(field) + payload["add"][field] * ranks)
				for field in payload.get("set", {}):
					ab.set(field, payload["set"][field])
				if payload.has("status_turns") and not ab.applies_status.is_empty():
					ab.applies_status["turns"] = payload["status_turns"]
