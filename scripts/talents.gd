# Talent trees: one per specialization, six talents each (2 per tier).
# Tier 2 unlocks after 2 picks in the tree, tier 3 after 4. Combat nodes
# award every hero points (fight 1, elite 2, boss 3).
class_name Talents

# id -> {name, desc, tier, payload}. Payload kinds:
#   {"stat": {field: delta}}                      permanent stat bonus
#   {"ability": name, "add"/"set": {field: x}}    alteration to a known ability
#   {"new_ability": {...}}                        extra ability (Ability.make dict)
const TREES := {
	"berserker": [
		{"id": "b1", "tier": 1, "name": "Thick Blood", "desc": "+25 max HP.",
			"payload": {"stat": {"max_hp": 25}}},
		{"id": "b2", "tier": 1, "name": "Sharpened Rage", "desc": "Strike deals +6 damage.",
			"payload": {"ability": "Strike", "add": {"damage": 6}}},
		{"id": "b3", "tier": 2, "name": "Deep Wounds", "desc": "Wildstrikes' Bleed lasts 5 turns.",
			"payload": {"ability": "Wildstrikes", "status_turns": 5}},
		{"id": "b4", "tier": 2, "name": "Iron Fury", "desc": "+15 Stability.",
			"payload": {"stat": {"stability": 15}}},
		{"id": "b5", "tier": 3, "name": "Rampage", "desc": "New ability: brutal 40-damage strike (30 Rage).",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 30, "damage": 40,
				"pressure": 12, "delay": 4.0, "anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "A reckless, devastating blow."}}},
		{"id": "b6", "tier": 3, "name": "Deeper Thirst", "desc": "Bloodlust heals 45% of missing HP.",
			"payload": {"ability": "Bloodlust", "set": {"heal_missing": 0.45}}},
	],
	"warden": [
		{"id": "w1", "tier": 1, "name": "Iron Skin", "desc": "+5% armor.",
			"payload": {"stat": {"armor": 0.05}}},
		{"id": "w2", "tier": 1, "name": "Immovable", "desc": "+20 Stability.",
			"payload": {"stat": {"stability": 20}}},
		{"id": "w3", "tier": 2, "name": "Quick Challenge", "desc": "Taunt costs less initiative.",
			"payload": {"ability": "Taunt", "add": {"delay": -1.0}}},
		{"id": "w4", "tier": 2, "name": "Broad Wall", "desc": "Shieldwall costs 10 less Rage.",
			"payload": {"ability": "Shieldwall", "add": {"cost": -10}}},
		{"id": "w5", "tier": 3, "name": "Bulwark Slam", "desc": "New ability: 26-damage shield bash with heavy Pressure (20 Rage).",
			"payload": {"new_ability": {"display_name": "Bulwark Slam", "cost": 20, "damage": 26,
				"pressure": 15, "delay": 3.0, "anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "Slam with the shield's full weight."}}},
		{"id": "w6", "tier": 3, "name": "Thick Hide", "desc": "+25 max HP.",
			"payload": {"stat": {"max_hp": 25}}},
	],
	"swordmaster": [
		{"id": "s1", "tier": 1, "name": "Keen Edge", "desc": "+5% crit chance.",
			"payload": {"stat": {"crit_bonus": 0.05}}},
		{"id": "s2", "tier": 1, "name": "Efficient Cuts", "desc": "Overpower costs 5 less Rage.",
			"payload": {"ability": "Overpower", "add": {"cost": -5}}},
		{"id": "s3", "tier": 2, "name": "Heavier Blows", "desc": "Crushing Blow deals +6 damage.",
			"payload": {"ability": "Crushing Blow", "add": {"damage": 6}}},
		{"id": "s4", "tier": 2, "name": "Fleet Footwork", "desc": "+10 Speed.",
			"payload": {"stat": {"speed": 10}}},
		{"id": "s5", "tier": 3, "name": "Flurry", "desc": "New ability: 3 quick strikes at random enemies (25 Rage).",
			"payload": {"new_ability": {"display_name": "Flurry", "cost": 25, "damage": 12,
				"pressure": 5, "delay": 3.5, "anim": "attack01", "random_hits": 3,
				"perfect_id": "", "perfect_text": "4 strikes instead of 3",
				"description": "A blinding sequence of cuts."}}},
		{"id": "s6", "tier": 3, "name": "Honed Basics", "desc": "Strike deals +6 damage.",
			"payload": {"ability": "Strike", "add": {"damage": 6}}},
	],
	"pyromancer": [
		{"id": "p1", "tier": 1, "name": "Ember Mind", "desc": "+20 max Mana.",
			"payload": {"stat": {"max_resource": 20}}},
		{"id": "p2", "tier": 1, "name": "Wildfire", "desc": "Flame Surge deals +8 damage.",
			"payload": {"ability": "Flame Surge", "add": {"damage": 8}}},
		{"id": "p3", "tier": 2, "name": "Hot Bolts", "desc": "Magic Bolt deals +5 damage.",
			"payload": {"ability": "Magic Bolt", "add": {"damage": 5}}},
		{"id": "p4", "tier": 2, "name": "Ashen Guard", "desc": "+15 max HP.",
			"payload": {"stat": {"max_hp": 15}}},
		{"id": "p5", "tier": 3, "name": "Inferno", "desc": "New ability: engulf ALL enemies for 24 damage + Burn (35 Mana).",
			"payload": {"new_ability": {"display_name": "Inferno", "cost": 35, "damage": 24,
				"pressure": 6, "delay": 4.5, "anim": "attack03", "aoe": true,
				"applies_status": {"id": "burn", "turns": 3},
				"perfect_id": "", "perfect_text": "+50% Pressure on every target",
				"description": "The battlefield becomes a furnace."}}},
		{"id": "p6", "tier": 3, "name": "Swift Rebirth", "desc": "Phoenix Rebirth costs less initiative.",
			"payload": {"ability": "Phoenix Rebirth", "add": {"delay": -1.0}}},
	],
	"cryomancer": [
		{"id": "c1", "tier": 1, "name": "Shard Storm", "desc": "Razor Ice throws an extra shard.",
			"payload": {"ability": "Razor Ice", "add": {"random_hits": 1}}},
		{"id": "c2", "tier": 1, "name": "Biting Cold", "desc": "Blizzard deals +6 damage.",
			"payload": {"ability": "Blizzard", "add": {"damage": 6}}},
		{"id": "c3", "tier": 2, "name": "Frost Armor", "desc": "+5% armor.",
			"payload": {"stat": {"armor": 0.05}}},
		{"id": "c4", "tier": 2, "name": "Sharper Ice", "desc": "Razor Ice deals +5 damage per shard.",
			"payload": {"ability": "Razor Ice", "add": {"damage": 5}}},
		{"id": "c5", "tier": 3, "name": "Absolute Zero", "desc": "New ability: 20 damage and shoves the target far down the initiative order (30 Mana).",
			"payload": {"new_ability": {"display_name": "Absolute Zero", "cost": 30, "damage": 20,
				"pressure": 8, "delay": 3.5, "anim": "attack02", "delay_push": 6.0,
				"applies_status": {"id": "slow", "turns": 3},
				"perfect_id": "", "perfect_text": "Also +50% Pressure",
				"description": "Entomb them in ice and time."}}},
		{"id": "c6", "tier": 3, "name": "Glacier Mind", "desc": "+20 max Mana.",
			"payload": {"stat": {"max_resource": 20}}},
	],
	"arcanist": [
		{"id": "a1", "tier": 1, "name": "Stable Cannon", "desc": "Arcane Cannon recoil reduced to 3% per stack step.",
			"payload": {"ability": "Arcane Cannon", "set": {"recoil_base": 0.03}}},
		{"id": "a2", "tier": 1, "name": "Wider Rift", "desc": "Arcane Rift deals +8 damage.",
			"payload": {"ability": "Arcane Rift", "add": {"damage": 8}}},
		{"id": "a3", "tier": 2, "name": "Deep Reserves", "desc": "+20 max Mana.",
			"payload": {"stat": {"max_resource": 20}}},
		{"id": "a4", "tier": 2, "name": "Cheap Fracture", "desc": "Reality Fracture costs 5 less Mana.",
			"payload": {"ability": "Reality Fracture", "add": {"cost": -5}}},
		{"id": "a5", "tier": 3, "name": "Singularity", "desc": "New ability: 55-damage collapse that ignores 30% armor (40 Mana).",
			"payload": {"new_ability": {"display_name": "Singularity", "cost": 40, "damage": 55,
				"pressure": 10, "delay": 5.0, "anim": "attack03", "armor_pierce": 0.3,
				"perfect_id": "", "perfect_text": "Ignores ALL armor",
				"description": "Fold space onto a single point."}}},
		{"id": "a6", "tier": 3, "name": "Warded Flesh", "desc": "+15 max HP.",
			"payload": {"stat": {"max_hp": 15}}},
	],
	"holy": [
		{"id": "h1", "tier": 1, "name": "Clarity", "desc": "Mend Wounds costs 5 less Mana.",
			"payload": {"ability": "Mend Wounds", "add": {"cost": -5}}},
		{"id": "h2", "tier": 1, "name": "Deeper Mending", "desc": "Mend Wounds heals +10.",
			"payload": {"ability": "Mend Wounds", "add": {"heal": 10}}},
		{"id": "h3", "tier": 2, "name": "Devotion", "desc": "+15 max HP.",
			"payload": {"stat": {"max_hp": 15}}},
		{"id": "h4", "tier": 2, "name": "Resonant Hymn", "desc": "Hymn of Hope costs 45 Faith.",
			"payload": {"ability": "Hymn of Hope", "set": {"faith_cost": 45}}},
		{"id": "h5", "tier": 3, "name": "Sanctuary", "desc": "New MIRACLE: party heals 12% and gains Shieldwall (40 Faith).",
			"payload": {"new_ability": {"display_name": "Sanctuary", "cost": 0, "faith_cost": 40,
				"special": "sanctuary", "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Heals 18% instead",
				"description": "Hallowed ground: heal the party 12%\nand halve incoming damage."}}},
		{"id": "h6", "tier": 3, "name": "Light Feet", "desc": "+10 Speed.",
			"payload": {"stat": {"speed": 10}}},
	],
	"inquisitor": [
		{"id": "i1", "tier": 1, "name": "Righteous Fury", "desc": "Smite deals +6 damage.",
			"payload": {"ability": "Smite", "add": {"damage": 6}}},
		{"id": "i2", "tier": 1, "name": "Burning Zeal", "desc": "Burning Verdict costs 30 Faith.",
			"payload": {"ability": "Burning Verdict", "set": {"faith_cost": 30}}},
		{"id": "i3", "tier": 2, "name": "Wider Censure", "desc": "Condemn deals +6 damage.",
			"payload": {"ability": "Condemn", "add": {"damage": 6}}},
		{"id": "i4", "tier": 2, "name": "Hardened Faith", "desc": "+15 max HP.",
			"payload": {"stat": {"max_hp": 15}}},
		{"id": "i5", "tier": 3, "name": "Excommunicate", "desc": "New MIRACLE: 55-damage execution (50 Faith).",
			"payload": {"new_ability": {"display_name": "Excommunicate", "cost": 0, "faith_cost": 50,
				"damage": 55, "pressure": 12, "delay": 4.0, "anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "Cast them out of the light entirely."}}},
		{"id": "i6", "tier": 3, "name": "Executioner's Eye", "desc": "+5% crit chance.",
			"payload": {"stat": {"crit_bonus": 0.05}}},
	],
	"occultist": [
		{"id": "o1", "tier": 1, "name": "Dark Vigor", "desc": "+15 max HP.",
			"payload": {"stat": {"max_hp": 15}}},
		{"id": "o2", "tier": 1, "name": "Vicious Hex", "desc": "Hex of Ruin deals +6 damage.",
			"payload": {"ability": "Hex of Ruin", "add": {"damage": 6}}},
		{"id": "o3", "tier": 2, "name": "Cheap Blood", "desc": "Dark Benediction costs 30 Faith.",
			"payload": {"ability": "Dark Benediction", "set": {"faith_cost": 30}}},
		{"id": "o4", "tier": 2, "name": "Occult Reserves", "desc": "+20 max Mana.",
			"payload": {"stat": {"max_resource": 20}}},
		{"id": "o5", "tier": 3, "name": "Soul Leech", "desc": "New ability: 24 damage, heals the Cleric for all damage dealt (30 Mana).",
			"payload": {"new_ability": {"display_name": "Soul Leech", "cost": 30, "damage": 24,
				"pressure": 7, "delay": 3.0, "anim": "attack02", "lifesteal": 1.0,
				"perfect_id": "", "perfect_text": "+50% healing from the drain",
				"description": "Drink their essence."}}},
		{"id": "o6", "tier": 3, "name": "Bone Ward", "desc": "+10 Stability.",
			"payload": {"stat": {"stability": 10}}},
	],
}


static func tree(spec: String) -> Array:
	return TREES.get(spec, [])


static func picks_in_tree(spec: String, learned: Array) -> int:
	var count := 0
	for t in tree(spec):
		if learned.has(t["id"]):
			count += 1
	return count


static func tier_unlocked(spec: String, tier: int, learned: Array) -> bool:
	var picks := picks_in_tree(spec, learned)
	return picks >= (tier - 1) * 2


# Applies learned talents for the ACTIVE spec onto a hero config
# (stats, ability alterations, extra abilities).
static func apply(cfg: Dictionary, spec: String, learned: Array) -> void:
	for t in tree(spec):
		if not learned.has(t["id"]):
			continue
		var payload: Dictionary = t["payload"]
		if payload.has("stat"):
			for field in payload["stat"]:
				if field == "crit_bonus":
					cfg["crit_bonus"] = cfg.get("crit_bonus", 0.0) + payload["stat"][field]
				else:
					cfg[field] = cfg[field] + payload["stat"][field]
		elif payload.has("new_ability"):
			cfg["abilities"] = cfg["abilities"] + [Ability.make(payload["new_ability"])]
		elif payload.has("ability"):
			for ab in cfg["abilities"]:
				if ab.display_name == payload["ability"]:
					for field in payload.get("add", {}):
						ab.set(field, ab.get(field) + payload["add"][field])
					for field in payload.get("set", {}):
						ab.set(field, payload["set"][field])
					if payload.has("status_turns") and not ab.applies_status.is_empty():
						ab.applies_status["turns"] = payload["status_turns"]
