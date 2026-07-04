# WoW-style talent trees: one per specialization. Nodes can have multiple
# ranks (stat/numeric talents) or a single rank (ability grants/reworks), and
# may require a parent node (branching paths). Tier N unlocks after
# (N-1)*3 points spent in that tree. Learned talents: {id: ranks}.
class_name Talents

# Node: {id, tier, name, ranks, requires (id or ""), desc, payload}
# Payload values are PER RANK for "stat" and "add"; "set"/"status_turns"/
# "new_ability" are single-rank effects.
const TREES := {
	"berserker": [
		{"id": "b1", "tier": 1, "ranks": 3, "requires": "", "name": "Thick Blood",
			"desc": "+10 max HP per rank.", "payload": {"stat": {"max_hp": 10}}},
		{"id": "b2", "tier": 1, "ranks": 2, "requires": "", "name": "Sharpened Rage",
			"desc": "Strike deals +3 damage per rank.",
			"payload": {"ability": "Strike", "add": {"damage": 3}}},
		{"id": "b3", "tier": 2, "ranks": 2, "requires": "b1", "name": "Iron Fury",
			"desc": "+8 Stability per rank.", "payload": {"stat": {"stability": 8}}},
		{"id": "b4", "tier": 2, "ranks": 2, "requires": "", "name": "Frenzied Pace",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
		{"id": "b5", "tier": 2, "ranks": 2, "requires": "b2", "name": "Deep Wounds",
			"desc": "Wildstrikes builds +10 more Bleed per rank.",
			"payload": {"ability": "Wildstrikes", "add": {"bleed_build": 10}}},
		{"id": "b6", "tier": 3, "ranks": 1, "requires": "b5", "name": "Rampage",
			"desc": "New ability: brutal 40-damage strike (30 Rage).",
			"payload": {"new_ability": {"display_name": "Rampage", "cost": 30, "damage": 40,
				"pressure": 12, "delay": 4.0, "anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "A reckless, devastating blow."}}},
		{"id": "b7", "tier": 3, "ranks": 2, "requires": "", "name": "Bloodbath",
			"desc": "Wildstrikes deals +3 damage per rank.",
			"payload": {"ability": "Wildstrikes", "add": {"damage": 3}}},
		{"id": "b8", "tier": 3, "ranks": 1, "requires": "b3", "name": "Deeper Thirst",
			"desc": "Bloodlust heals 45% of missing HP.",
			"payload": {"ability": "Bloodlust", "set": {"heal_missing": 0.45}}},
	],
	"warden": [
		{"id": "w1", "tier": 1, "ranks": 3, "requires": "", "name": "Iron Skin",
			"desc": "+2% armor per rank.", "payload": {"stat": {"armor": 0.02}}},
		{"id": "w2", "tier": 1, "ranks": 2, "requires": "", "name": "Immovable",
			"desc": "+10 Stability per rank.", "payload": {"stat": {"stability": 10}}},
		{"id": "w3", "tier": 2, "ranks": 1, "requires": "w2", "name": "Quick Challenge",
			"desc": "Taunt costs less initiative.",
			"payload": {"ability": "Taunt", "add": {"delay": -1.0}}},
		{"id": "w4", "tier": 2, "ranks": 2, "requires": "", "name": "Broad Wall",
			"desc": "Shieldwall costs 5 less Rage per rank.",
			"payload": {"ability": "Shieldwall", "add": {"cost": -5}}},
		{"id": "w5", "tier": 2, "ranks": 2, "requires": "w1", "name": "Guardian's Vigor",
			"desc": "+10 max HP per rank.", "payload": {"stat": {"max_hp": 10}}},
		{"id": "w6", "tier": 3, "ranks": 1, "requires": "w4", "name": "Bulwark Slam",
			"desc": "New ability: 26-damage shield bash, heavy Pressure (20 Rage).",
			"payload": {"new_ability": {"display_name": "Bulwark Slam", "cost": 20, "damage": 26,
				"pressure": 15, "delay": 3.0, "anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "Slam with the shield's full weight."}}},
		{"id": "w7", "tier": 3, "ranks": 2, "requires": "w5", "name": "Thick Hide",
			"desc": "+10 max HP per rank.", "payload": {"stat": {"max_hp": 10}}},
		{"id": "w8", "tier": 3, "ranks": 1, "requires": "w1", "name": "Unbreakable",
			"desc": "+4% armor.", "payload": {"stat": {"armor": 0.04}}},
	],
	"swordmaster": [
		{"id": "s1", "tier": 1, "ranks": 3, "requires": "", "name": "Keen Edge",
			"desc": "+2% crit chance per rank.", "payload": {"stat": {"crit_bonus": 0.02}}},
		{"id": "s2", "tier": 1, "ranks": 2, "requires": "", "name": "Fleet Footwork",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
		{"id": "s3", "tier": 2, "ranks": 2, "requires": "s1", "name": "Riposte Training",
			"desc": "+3% parry chance per rank.", "payload": {"stat": {"parry_bonus": 0.03}}},
		{"id": "s4", "tier": 2, "ranks": 1, "requires": "", "name": "Efficient Cuts",
			"desc": "Overpower costs 5 less Rage.",
			"payload": {"ability": "Overpower", "add": {"cost": -5}}},
		{"id": "s5", "tier": 2, "ranks": 2, "requires": "", "name": "Heavier Blows",
			"desc": "Crushing Blow deals +3 damage per rank.",
			"payload": {"ability": "Crushing Blow", "add": {"damage": 3}}},
		{"id": "s6", "tier": 3, "ranks": 1, "requires": "s4", "name": "Flurry",
			"desc": "New ability: 3 quick strikes at random enemies (25 Rage).",
			"payload": {"new_ability": {"display_name": "Flurry", "cost": 25, "damage": 12,
				"pressure": 5, "delay": 3.5, "anim": "attack01", "random_hits": 3,
				"perfect_id": "", "perfect_text": "4 strikes instead of 3",
				"description": "A blinding sequence of cuts."}}},
		{"id": "s7", "tier": 3, "ranks": 2, "requires": "s5", "name": "Deathblow",
			"desc": "Overpower deals +4 damage per rank.",
			"payload": {"ability": "Overpower", "add": {"damage": 4}}},
		{"id": "s8", "tier": 3, "ranks": 1, "requires": "s3", "name": "Blade Dancer",
			"desc": "+10 Speed.", "payload": {"stat": {"speed": 10}}},
	],
	"pyromancer": [
		{"id": "p1", "tier": 1, "ranks": 2, "requires": "", "name": "Ember Mind",
			"desc": "+10 max Mana per rank.", "payload": {"stat": {"max_resource": 10}}},
		{"id": "p2", "tier": 1, "ranks": 2, "requires": "", "name": "Wildfire",
			"desc": "Flame Surge deals +4 damage per rank.",
			"payload": {"ability": "Flame Surge", "add": {"damage": 4}}},
		{"id": "p3", "tier": 2, "ranks": 2, "requires": "", "name": "Hot Bolts",
			"desc": "Magic Bolt deals +3 damage per rank.",
			"payload": {"ability": "Magic Bolt", "add": {"damage": 3}}},
		{"id": "p4", "tier": 2, "ranks": 2, "requires": "p1", "name": "Ashen Guard",
			"desc": "+8 max HP per rank.", "payload": {"stat": {"max_hp": 8}}},
		{"id": "p5", "tier": 2, "ranks": 2, "requires": "p2", "name": "Cinder Skin",
			"desc": "+2% armor per rank.", "payload": {"stat": {"armor": 0.02}}},
		{"id": "p6", "tier": 3, "ranks": 1, "requires": "p2", "name": "Inferno",
			"desc": "New ability: engulf ALL enemies, 24 fire damage + Burn (35 Mana).",
			"payload": {"new_ability": {"display_name": "Inferno", "dmg_type": "fire",
				"cost": 35, "damage": 24, "pressure": 6, "delay": 4.5, "anim": "attack03",
				"aoe": true, "applies_status": {"id": "burn", "turns": 3},
				"perfect_id": "", "perfect_text": "+50% Pressure on every target",
				"description": "The battlefield becomes a furnace."}}},
		{"id": "p7", "tier": 3, "ranks": 1, "requires": "p6", "name": "Fire Feeds Fire",
			"desc": "Inferno costs 10 less Mana.",
			"payload": {"ability": "Inferno", "add": {"cost": -10}}},
		{"id": "p8", "tier": 3, "ranks": 1, "requires": "", "name": "Swift Rebirth",
			"desc": "Phoenix Rebirth costs less initiative.",
			"payload": {"ability": "Phoenix Rebirth", "add": {"delay": -1.0}}},
	],
	"cryomancer": [
		{"id": "c1", "tier": 1, "ranks": 1, "requires": "", "name": "Shard Storm",
			"desc": "Razor Ice throws an extra shard.",
			"payload": {"ability": "Razor Ice", "add": {"random_hits": 1}}},
		{"id": "c2", "tier": 1, "ranks": 2, "requires": "", "name": "Biting Cold",
			"desc": "Blizzard deals +3 damage per rank.",
			"payload": {"ability": "Blizzard", "add": {"damage": 3}}},
		{"id": "c3", "tier": 2, "ranks": 2, "requires": "", "name": "Frost Armor",
			"desc": "+2% armor per rank.", "payload": {"stat": {"armor": 0.02}}},
		{"id": "c4", "tier": 2, "ranks": 2, "requires": "c1", "name": "Sharper Ice",
			"desc": "Razor Ice deals +3 damage per shard per rank.",
			"payload": {"ability": "Razor Ice", "add": {"damage": 3}}},
		{"id": "c5", "tier": 2, "ranks": 2, "requires": "", "name": "Numbing Cold",
			"desc": "+8 Stability per rank.", "payload": {"stat": {"stability": 8}}},
		{"id": "c6", "tier": 3, "ranks": 1, "requires": "c4", "name": "Absolute Zero",
			"desc": "New ability: 20 frost damage, shoves the target far down the initiative order (30 Mana).",
			"payload": {"new_ability": {"display_name": "Absolute Zero", "dmg_type": "frost",
				"cost": 30, "damage": 20, "pressure": 8, "delay": 3.5, "anim": "attack02",
				"delay_push": 6.0, "applies_status": {"id": "slow", "turns": 3},
				"perfect_id": "", "perfect_text": "Also +50% Pressure",
				"description": "Entomb them in ice and time."}}},
		{"id": "c7", "tier": 3, "ranks": 2, "requires": "c3", "name": "Glacier Mind",
			"desc": "+10 max Mana per rank.", "payload": {"stat": {"max_resource": 10}}},
		{"id": "c8", "tier": 3, "ranks": 2, "requires": "c5", "name": "Winter's Pace",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
	],
	"arcanist": [
		{"id": "a1", "tier": 1, "ranks": 1, "requires": "", "name": "Stable Cannon",
			"desc": "Arcane Cannon recoil reduced to 3% per stack step.",
			"payload": {"ability": "Arcane Cannon", "set": {"recoil_base": 0.03}}},
		{"id": "a2", "tier": 1, "ranks": 2, "requires": "", "name": "Focused Blast",
			"desc": "Arcane Cannon deals +4 damage per rank.",
			"payload": {"ability": "Arcane Cannon", "add": {"damage": 4}}},
		{"id": "a3", "tier": 2, "ranks": 2, "requires": "", "name": "Deep Reserves",
			"desc": "+10 max Mana per rank.", "payload": {"stat": {"max_resource": 10}}},
		{"id": "a4", "tier": 2, "ranks": 1, "requires": "a2", "name": "Cheap Fracture",
			"desc": "Reality Fracture costs 5 less Mana.",
			"payload": {"ability": "Reality Fracture", "add": {"cost": -5}}},
		{"id": "a5", "tier": 2, "ranks": 2, "requires": "", "name": "Riftwalker",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
		{"id": "a6", "tier": 3, "ranks": 1, "requires": "a4", "name": "Singularity",
			"desc": "New ability: 55-damage arcane collapse, ignores 30% armor (40 Mana).",
			"payload": {"new_ability": {"display_name": "Singularity", "dmg_type": "arcane",
				"cost": 40, "damage": 55, "pressure": 10, "delay": 5.0, "anim": "attack03",
				"armor_pierce": 0.3,
				"perfect_id": "", "perfect_text": "Ignores ALL armor",
				"description": "Fold space onto a single point."}}},
		{"id": "a7", "tier": 3, "ranks": 2, "requires": "a6", "name": "Overcharge",
			"desc": "Singularity deals +5 damage per rank.",
			"payload": {"ability": "Singularity", "add": {"damage": 5}}},
		{"id": "a8", "tier": 3, "ranks": 2, "requires": "a3", "name": "Warded Flesh",
			"desc": "+8 max HP per rank.", "payload": {"stat": {"max_hp": 8}}},
	],
	"holy": [
		{"id": "h1", "tier": 1, "ranks": 2, "requires": "", "name": "Clarity",
			"desc": "Mend Wounds costs 3 less Mana per rank.",
			"payload": {"ability": "Mend Wounds", "add": {"cost": -3}}},
		{"id": "h2", "tier": 1, "ranks": 2, "requires": "", "name": "Deeper Mending",
			"desc": "Mend Wounds heals +5 per rank.",
			"payload": {"ability": "Mend Wounds", "add": {"heal": 5}}},
		{"id": "h3", "tier": 2, "ranks": 2, "requires": "", "name": "Devotion",
			"desc": "+8 max HP per rank.", "payload": {"stat": {"max_hp": 8}}},
		{"id": "h4", "tier": 2, "ranks": 1, "requires": "h2", "name": "Resonant Hymn",
			"desc": "Hymn of Hope costs 45 Faith.",
			"payload": {"ability": "Hymn of Hope", "set": {"faith_cost": 45}}},
		{"id": "h5", "tier": 2, "ranks": 2, "requires": "", "name": "Serenity",
			"desc": "+10 max Mana per rank.", "payload": {"stat": {"max_resource": 10}}},
		{"id": "h6", "tier": 3, "ranks": 1, "requires": "h4", "name": "Sanctuary",
			"desc": "New MIRACLE: party heals 12% and gains Shieldwall (40 Faith).",
			"payload": {"new_ability": {"display_name": "Sanctuary", "cost": 0, "faith_cost": 40,
				"special": "sanctuary", "delay": 4.0, "anim": "attack03",
				"perfect_id": "", "perfect_text": "Heals 18% instead",
				"description": "Hallowed ground: heal the party 12%\nand halve incoming damage."}}},
		{"id": "h7", "tier": 3, "ranks": 2, "requires": "h3", "name": "Radiance",
			"desc": "Smite deals +3 damage per rank.",
			"payload": {"ability": "Smite", "add": {"damage": 3}}},
		{"id": "h8", "tier": 3, "ranks": 2, "requires": "h5", "name": "Light Feet",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
	],
	"inquisitor": [
		{"id": "i1", "tier": 1, "ranks": 2, "requires": "", "name": "Righteous Fury",
			"desc": "Smite deals +3 damage per rank.",
			"payload": {"ability": "Smite", "add": {"damage": 3}}},
		{"id": "i2", "tier": 1, "ranks": 2, "requires": "", "name": "Hardened Faith",
			"desc": "+8 max HP per rank.", "payload": {"stat": {"max_hp": 8}}},
		{"id": "i3", "tier": 2, "ranks": 1, "requires": "i1", "name": "Burning Zeal",
			"desc": "Burning Verdict costs 30 Faith.",
			"payload": {"ability": "Burning Verdict", "set": {"faith_cost": 30}}},
		{"id": "i4", "tier": 2, "ranks": 2, "requires": "", "name": "Wider Censure",
			"desc": "Condemn deals +3 damage per rank.",
			"payload": {"ability": "Condemn", "add": {"damage": 3}}},
		{"id": "i5", "tier": 2, "ranks": 2, "requires": "i2", "name": "Unbending",
			"desc": "+5 Stability per rank.", "payload": {"stat": {"stability": 5}}},
		{"id": "i6", "tier": 3, "ranks": 1, "requires": "i3", "name": "Excommunicate",
			"desc": "New MIRACLE: 55-damage holy execution (50 Faith).",
			"payload": {"new_ability": {"display_name": "Excommunicate", "dmg_type": "holy",
				"cost": 0, "faith_cost": 50, "damage": 55, "pressure": 12, "delay": 4.0,
				"anim": "attack02",
				"perfect_id": "pressure", "perfect_text": "+60% Pressure",
				"description": "Cast them out of the light entirely."}}},
		{"id": "i7", "tier": 3, "ranks": 3, "requires": "", "name": "Executioner's Eye",
			"desc": "+2% crit chance per rank.", "payload": {"stat": {"crit_bonus": 0.02}}},
		{"id": "i8", "tier": 3, "ranks": 1, "requires": "i6", "name": "Fanaticism",
			"desc": "Excommunicate costs 40 Faith.",
			"payload": {"ability": "Excommunicate", "set": {"faith_cost": 40}}},
	],
	"occultist": [
		{"id": "o1", "tier": 1, "ranks": 2, "requires": "", "name": "Dark Vigor",
			"desc": "+8 max HP per rank.", "payload": {"stat": {"max_hp": 8}}},
		{"id": "o2", "tier": 1, "ranks": 2, "requires": "", "name": "Vicious Hex",
			"desc": "Hex of Ruin deals +3 damage per rank.",
			"payload": {"ability": "Hex of Ruin", "add": {"damage": 3}}},
		{"id": "o3", "tier": 2, "ranks": 1, "requires": "", "name": "Cheap Blood",
			"desc": "Dark Benediction costs 30 Faith.",
			"payload": {"ability": "Dark Benediction", "set": {"faith_cost": 30}}},
		{"id": "o4", "tier": 2, "ranks": 2, "requires": "o1", "name": "Occult Reserves",
			"desc": "+10 max Mana per rank.", "payload": {"stat": {"max_resource": 10}}},
		{"id": "o5", "tier": 2, "ranks": 2, "requires": "", "name": "Shadowmeld",
			"desc": "+5 Speed per rank.", "payload": {"stat": {"speed": 5}}},
		{"id": "o6", "tier": 3, "ranks": 1, "requires": "o2", "name": "Soul Leech",
			"desc": "New ability: 24 shadow damage, heals the Cleric for all damage dealt (30 Mana).",
			"payload": {"new_ability": {"display_name": "Soul Leech", "dmg_type": "shadow",
				"cost": 30, "damage": 24, "pressure": 7, "delay": 3.0, "anim": "attack02",
				"lifesteal": 1.0,
				"perfect_id": "", "perfect_text": "+50% healing from the drain",
				"description": "Drink their essence."}}},
		{"id": "o7", "tier": 3, "ranks": 2, "requires": "o6", "name": "Gluttony",
			"desc": "Soul Leech deals +3 damage per rank.",
			"payload": {"ability": "Soul Leech", "add": {"damage": 3}}},
		{"id": "o8", "tier": 3, "ranks": 2, "requires": "o4", "name": "Bone Ward",
			"desc": "+5 Stability per rank.", "payload": {"stat": {"stability": 5}}},
	],
}


static func tree(spec: String) -> Array:
	var talents: Array = TREES.get(spec, []).duplicate()
	talents.sort_custom(func(a, b): return a["tier"] < b["tier"])
	return talents


static func node(spec: String, id: String) -> Dictionary:
	for t in TREES.get(spec, []):
		if t["id"] == id:
			return t
	return {}


# Total points spent in this tree (sum of ranks).
static func points_in_tree(spec: String, learned: Dictionary) -> int:
	var total := 0
	for t in TREES.get(spec, []):
		total += int(learned.get(t["id"], 0))
	return total


static func tier_unlocked(spec: String, tier: int, learned: Dictionary) -> bool:
	return points_in_tree(spec, learned) >= (tier - 1) * 3


# A node can rank up if its tier is unlocked, its parent (if any) has at
# least one rank, and it is not already maxed.
static func can_learn(spec: String, id: String, learned: Dictionary) -> Dictionary:
	var t := node(spec, id)
	var current := int(learned.get(id, 0))
	if current >= int(t["ranks"]):
		return {"ok": false, "why": "Maxed"}
	if not tier_unlocked(spec, int(t["tier"]), learned):
		return {"ok": false, "why": "Locked: %d pts in tree" % [(int(t["tier"]) - 1) * 3]}
	if t["requires"] != "" and int(learned.get(t["requires"], 0)) < 1:
		return {"ok": false, "why": "Requires %s" % node(spec, t["requires"])["name"]}
	return {"ok": true, "why": ""}


# Applies learned talents (with ranks) onto a hero config.
static func apply(cfg: Dictionary, spec: String, learned: Dictionary) -> void:
	for t in TREES.get(spec, []):
		var ranks := int(learned.get(t["id"], 0))
		if ranks < 1:
			continue
		apply_payload(cfg, t["payload"], ranks)


# Shared payload applicator (talents and shop runes).
static func apply_payload(cfg: Dictionary, payload: Dictionary, ranks: int) -> void:
	if payload.has("stat"):
		for field in payload["stat"]:
			if field == "crit_bonus" or field == "parry_bonus":
				cfg[field] = cfg.get(field, 0.0) + payload["stat"][field] * ranks
			else:
				cfg[field] = cfg[field] + payload["stat"][field] * ranks
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
