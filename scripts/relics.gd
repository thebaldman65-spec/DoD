# Relics: permanent account-wide unlocks (the meta-progression layer).
# Earned one per zone-boss kill; the DRAFT screen assigns up to 3 of the
# unlocked collection to a run (Run.active_relics), and events can slot
# a run-scoped extra via the relic_grant verb. Persisted to
# user://relics.json across sessions.
#
# THE HOOK VOCABULARY (Batch 39 audit — what a relic can attach to
# without new plumbing; every entry below is read at exactly one site):
#   start_gold            new_run             flat gold at run start
#   start_items {id: n}   new_run             consumables at run start
#   hero_attack_mult      battle spawn        party damage dealt (+frac,
#                                             via the dmg_bonus field)
#   dmg_type_mult {t: f}  battle spawn        typed damage (type_dmg_bonus)
#   hero_max_hp_mult      battle spawn        max HP (+frac, max_hp_pct)
#   hero_armor_add        battle spawn        flat armor fraction
#   hero_speed_add        battle spawn        flat Speed
#   hero_crit_add         battle spawn        flat crit chance
#   hero_con_add          battle spawn        flat Constitution (Break)
#   hero_resist_add {t:f} battle spawn        party resistances
#   resource_floor_pct    battle spawn        open battles with at least
#                                             this fraction of resource
#   victory_heal_pct      victory screen      party heal per victory
#   victory_mana_pct      victory screen      party mana per victory
#   victory_gold          victory screen      flat gold per victory
#   gold_find_mult        award_gold          all node gold (+frac)
#   rest_heal_add         rest nodes          added to the 30% waystone
#   shop_discount         shop prices         prices x (1 - frac)
#   loot_extra            elite spoils        extra consumable drops
# NEEDS PLUMBING (declared out for now): on-kill/per-turn procs,
# revive-on-death, enemy-side auras, DoT tick and Break-damage mults.
#
# Scalar hooks SUM across the run's relics; dict hooks merge by summing
# per key. Tiers feed the events' relic_grant pools: common | rare.
class_name Relics

const SAVE_PATH := "user://relics.json"

const POOL := {
	# ---------- common ----------
	# BATCH BM re-specced this in place: talent points became a META currency
	# banked on Profile, so a per-run grant of them had nothing to buy. Same
	# id, same tier, same "you start ahead" role — a different opening purse.
	"waystone": {"name": "Waystone Shard", "tier": "common",
		"desc": "Begin each run with +{=@hooks.start_items.health} Health Potion,\n+{=@hooks.start_items.mana} Mana Potion and +{=@hooks.start_items.bomb} Bomb.",
		"hooks": {"start_items": {"health": 1, "mana": 1, "bomb": 1}}},
	"coin": {"name": "Gravewrought Coin", "tier": "common",
		"desc": "Begin each run with +{=@hooks.start_gold} gold.",
		"hooks": {"start_gold": 80}},
	"chalice": {"name": "Chalice of Dawn", "tier": "common",
		"desc": "Every hero heals {=@hooks.victory_heal_pct*100}% after every victory.",
		"hooks": {"victory_heal_pct": 0.10}},
	"emberheart": {"name": "Emberheart", "tier": "common",
		"desc": "Fire and Holy strike damage +{=@hooks.dmg_type_mult.fire*100}%.",
		"hooks": {"dmg_type_mult": {"fire": 0.20, "holy": 0.20}}},
	"frostsigil": {"name": "Frostbound Sigil", "tier": "common",
		"desc": "Frost and Arcane strike damage +{=@hooks.dmg_type_mult.frost*100}%.",
		"hooks": {"dmg_type_mult": {"frost": 0.20, "arcane": 0.20}}},
	"nightbloom": {"name": "Nightbloom Charm", "tier": "common",
		"desc": "Shadow and Nature strike damage +{=@hooks.dmg_type_mult.shadow*100}%.",
		"hooks": {"dmg_type_mult": {"shadow": 0.20, "nature": 0.20}}},
	"packcharm": {"name": "Packmother's Satchel", "tier": "common",
		"desc": "Begin each run with {=@hooks.start_items.health} extra Health Potions\nand {=@hooks.start_items.mana} extra Mana Potion.",
		"hooks": {"start_items": {"health": 2, "mana": 1}}},
	"lodestone": {"name": "Peddler's Lodestone", "tier": "common",
		"desc": "Shop prices reduced {=@hooks.shop_discount*100}%.",
		"hooks": {"shop_discount": 0.20}},
	# BATCH IK §6 — SUSPENDED, NOT DELETED: its one hook was the rest node's, and rest nodes left the
	# map at AN §6, so it paid nothing. `is_suspended` keeps it out of every draw and every list a player
	# picks from; its entry, its words and the player's unlock stay, for the re-cut that brings it back.
	"cairnmoss": {"name": "Cairnmoss Poultice", "tier": "common",
		"desc": "Rest nodes restore 45% instead of 30%.",
		"hooks": {"rest_heal_add": 0.15},
		"suspended": "IK §6: its whole effect was the rest node's (rest_heal_add), and rest nodes were deleted at AN §6, so it pays nothing. It returns when its re-cut ships: it rides the post-fight recovery, at a number set by the ruling on whether a fallen hero stays down between fights."},
	"lantern": {"name": "Gravelight Lantern", "tier": "common",
		"desc": "Elite spoils include one extra consumable.",
		"hooks": {"loot_extra": 1}},
	"tithe": {"name": "Tithing Scales", "tier": "common",
		"desc": "Gold won in battles and bargains +{=@hooks.gold_find_mult*100}%.",
		"hooks": {"gold_find_mult": 0.25}},
	"whetstone": {"name": "Ancestral Whetstone", "tier": "common",
		"desc": "All heroes: +{=@hooks.hero_crit_add*100}% critical chance.",
		"hooks": {"hero_crit_add": 0.05}},
	"ironbark": {"name": "Ironbark Ward", "tier": "common",
		"desc": "All heroes: +{=@hooks.hero_armor_add*100}% armor.",
		"hooks": {"hero_armor_add": 0.05}},
	"fleetstep": {"name": "Fleetstep Talisman", "tier": "common",
		"desc": "All heroes: +{=@hooks.hero_speed_add} Speed.",
		"hooks": {"hero_speed_add": 5}},
	"oxheart": {"name": "Oxheart Fetish", "tier": "common",
		"desc": "All heroes: +{=@hooks.hero_max_hp_mult*100}% max Health.",
		"hooks": {"hero_max_hp_mult": 0.10}},
	"stormflask": {"name": "Bottled Storm", "tier": "common",
		"desc": "Heroes open every battle with at least\n{=@hooks.resource_floor_pct*100}% of their resource.",
		"hooks": {"resource_floor_pct": 0.35}},
	"drumskin": {"name": "Wardrums of the Old Horde", "tier": "common",
		"desc": "All heroes: +{=@hooks.hero_con_add} Constitution (Break resistance).",
		"hooks": {"hero_con_add": 15}},
	# ---------- rare ----------
	"dragonbone": {"name": "Dragonbone Idol", "tier": "rare",
		"desc": "All heroes deal +{=@hooks.hero_attack_mult*100}% strike damage.",
		"hooks": {"hero_attack_mult": 0.10}},
	"runedplate": {"name": "Runed Bulwark", "tier": "rare",
		"desc": "All heroes: {=@hooks.hero_resist_add.physical*100}% physical resistance.",
		"hooks": {"hero_resist_add": {"physical": 0.10}}},
	"prismveil": {"name": "Prism Veil", "tier": "rare",
		"desc": "All heroes: {=@hooks.hero_resist_add.fire*100}% resistance to every element.",
		"hooks": {"hero_resist_add": {"fire": 0.10, "frost": 0.10,
			"nature": 0.10, "shadow": 0.10, "holy": 0.10, "arcane": 0.10}}},
	"hourglass": {"name": "Cracked Hourglass", "tier": "rare",
		"desc": "After every victory: every hero recovers\n{=@hooks.victory_mana_pct*100}% Mana and heals {=@hooks.victory_heal_pct*100}%.",
		"hooks": {"victory_mana_pct": 0.30, "victory_heal_pct": 0.05}},
	"kingsledger": {"name": "The King's Ledger", "tier": "rare",
		"desc": "+{=@hooks.start_gold} gold at run start; battle and bargain gold +{=@hooks.gold_find_mult*100}%.",
		"hooks": {"start_gold": 40, "gold_find_mult": 0.40}},
	# BATCH BM: same re-spec, same reason. Its damage clause is untouched and
	# the vacated half became more of it.
	"warhorn": {"name": "Horn of the First War", "tier": "rare",
		"desc": "Every hero deals +{=@hooks.hero_attack_mult*100}% strike damage.",
		"hooks": {"hero_attack_mult": 0.12}},
	"martyrbone": {"name": "Martyr's Knucklebone", "tier": "rare",
		"desc": "Every hero heals {=@hooks.victory_heal_pct*100}% after every victory.",
		"hooks": {"victory_heal_pct": 0.15, "rest_heal_add": 0.10}},
	"tollbell": {"name": "Tollkeeper's Bell", "tier": "rare",
		"desc": "+{=@hooks.victory_gold} gold after every victory.",
		"hooks": {"victory_gold": 20}},
}

static var unlocked: Array = []
static var loaded := false
# BATCH GJ — THE FILE AN UNLOCK IS WRITTEN TO IS A VAR NOW, `Profile.save_path`'s
# shape, AND ONLY A GATE MOVES IT. `SAVE_PATH` stays the const and stays the
# player's file. `check_gj` points this at a scratch file before its end boss
# dies, because it asserts the relic that death unlocks and an unlock is a
# WRITE — with any relic locked, a gate reaching `_resolve_boss` writes the file
# (FY §5b). The four gates FY §5b counted still write the default: that item is
# deferred by ruling (GA) and GJ does not touch it.
static var save_path := SAVE_PATH


static func load_data() -> void:
	if loaded:
		return
	loaded = true
	if FileAccess.file_exists(save_path):
		var file := FileAccess.open(save_path, FileAccess.READ)
		var data: Variant = JSON.parse_string(file.get_as_text())
		if data is Array:
			# Drop relics that no longer exist in the pool.
			unlocked = data.filter(func(id): return POOL.has(id))


static func save_data() -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(unlocked))


static func has(id: String) -> bool:
	load_data()
	return unlocked.has(id)


# BATCH IJ §2 — A RELIC's WORDS READ THEIR FIGURES HERE, AND EVERY SURFACE READS
# THEM HERE (`Classes.resolve_figures`): a token names the relic's own hooks
# (`{=@hooks.dmg_type_mult.fire*100}`), so the figure a player reads is the one the
# hook pays. A surface never shows the raw entry's words — they hold the tokens.
static func desc_of(id: String) -> String:
	return Classes.resolve_figures(String(POOL[id]["desc"]), POOL[id])


# BATCH IK §6 — A SUSPENDED RELIC IS KEPT AND SAID TO BE KEPT (the Melted Armor contract, EO §3): its
# entry resolves, its words stand and an unlock of it is never dropped (`load_data` keeps every POOL
# id), but no draw reaches it and no list a player picks from shows it — the boss's unlock below, an
# event's relic grant, the draft's assignment and the shelf. The string names what is lost.
static func is_suspended(id: String) -> bool:
	return String(POOL.get(id, {}).get("suspended", "")) != ""


# Unlocks one random still-locked relic; returns its info, or {} if all owned.
static func unlock_random() -> Dictionary:
	load_data()
	var locked: Array = []
	for id in POOL:
		if not unlocked.has(id) and not is_suspended(String(id)):
			locked.append(id)
	if locked.is_empty():
		return {}
	var id: String = locked.pick_random()
	unlocked.append(id)
	save_data()
	var info: Dictionary = POOL[id].duplicate()
	info["id"] = id
	# The caller shows `desc` (the victory screen's RELIC UNLOCKED line), so it
	# carries the resolved words, never the tokens.
	info["desc"] = desc_of(id)
	return info


# ---------- hook aggregation (the sites read these) ----------

# Sum of a scalar hook across the given relic ids.
static func hook_add(active: Array, hook: String) -> float:
	var total := 0.0
	for id in active:
		total += float(POOL.get(id, {}).get("hooks", {}).get(hook, 0.0))
	return total


# Per-key sum of a dict hook across the given relic ids.
static func hook_dict(active: Array, hook: String) -> Dictionary:
	var merged := {}
	for id in active:
		var part: Dictionary = POOL.get(id, {}).get("hooks", {}).get(hook, {})
		for key in part:
			merged[key] = float(merged.get(key, 0.0)) + float(part[key])
	return merged
