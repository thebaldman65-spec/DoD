# Relics: permanent account-wide unlocks (the meta-progression layer).
# Earned one per boss kill, the end boss's included; the DRAFT screen
# assigns up to 3 of the unlocked collection to a run (Run.active_relics),
# and events can slot a run-scoped extra via the relic_grant verb.
# BATCH KD — A RELIC BELONGS TO ONE HERO (CX's ruling; JY's ruling 12, answered
# at JZ): a relic on a HOLDER hook (below) pays only the hero it is handed to,
# on the map after the classes are chosen (`Run.hand_relic`, the one door;
# `Run.relic_holders`); every other hook pays every hero, as it always has.
# Persisted to user://relics.json across sessions.
#
# THE HOOK VOCABULARY (Batch 39 audit — what a relic can attach to
# without new plumbing; each row names where its hook is read, and some are
# read at more than one site — gold_find_mult (award_gold, claim_reward),
# victory_heal_pct (victory_heal_pct, fallen_heal_pct) and fallen_recover
# (fallen_heal_pct, clearing_heal_note) at two, shop_discount at five price
# functions, one of them the sim's; the sim reads the victory and spoils hooks
# again (`run_sim.gd`). FOUND AT FW, closed at KD):
#   start_gold            new_run             flat gold at run start
#   start_items {id: n}   new_run             consumables at run start
#   hero_attack_mult      battle spawn        the holder's damage dealt (+frac,
#                                             via the dmg_bonus field)
#   dmg_type_mult {t: f}  battle spawn        typed damage (type_dmg_bonus)
#   hero_max_hp_mult      battle spawn        max HP (+frac, max_hp_pct)
#   hero_armor_add        battle spawn        flat armor fraction
#   hero_speed_add        battle spawn        flat Speed
#   hero_crit_add         battle spawn        flat crit chance
#   hero_con_add          battle spawn        flat Constitution (Break)
#   hero_resist_add {t:f} battle spawn        the holder's resistances
#   resource_floor_pct    battle spawn        open battles with at least
#                                             this fraction of resource
#   victory_heal_pct      victory screen      party heal per victory
#   victory_mana_pct      victory screen      party mana per victory
#   victory_gold          victory screen      flat gold per victory
#   gold_find_mult        award_gold          all node gold (+frac)
#   fallen_recover        fallen_heal_pct, _note  a hero left down takes the base clearing heal too
#   shop_discount         shop prices         prices x (1 - frac)
#   loot_extra            elite spoils        extra consumable drops
# NEEDS PLUMBING (declared out for now): on-kill/per-turn procs,
# revive-on-death, enemy-side auras, DoT tick and Break-damage mults.
#
# The eight battle-spawn STAT hooks above (hero_attack_mult to hero_resist_add)
# are HOLDER hooks since KD: read per hero at the spawn (`Run.hero_relic_add`),
# never party-wide. Bottled Storm's resource_floor_pct is read at the spawn too
# and stays every hero's with the victory heal and Mana and fallen_recover
# (JY's ruling 12's four); the six that set up the run (start_gold, start_items,
# gold_find_mult, shop_discount, loot_extra, victory_gold) pay every hero too.
# Scalar hooks SUM across the run's relics; dict hooks merge by summing
# per key. Tiers feed the events' relic_grant pools: common | rare.
class_name Relics

const SAVE_PATH := "user://relics.json"

# BATCH KD — THE HOOKS THAT PAY ONLY A RELIC's HOLDER (CX's ruling, JY's ruling 12). The battle-spawn stat hooks, which
# CX found already ran once per hero: a relic on any of them is HELD (`is_held`) and is handed to one hero on the map.
# No relic carries a holder hook beside an every-hero hook (`check_kd` §1).
const HOLDER_HOOKS := ["hero_attack_mult", "dmg_type_mult", "hero_max_hp_mult", "hero_armor_add",
	"hero_speed_add", "hero_crit_add", "hero_con_add", "hero_resist_add"]

const POOL := {
	# ---------- common ----------
	# BATCH KD — THE TWELVE ON A HOLDER HOOK PAY THEIR HOLDER ALONE, AT TWICE THE FIGURE THEY PAID EVERY HERO (the designer's
	# balance ruling at KD: "Double them"); the thirteen others pay every hero as they did.
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
		"desc": "Every hero heals {=@hooks.victory_heal_pct*100}% of maximum\nhealth after every victory.",
		"hooks": {"victory_heal_pct": 0.10}},
	"emberheart": {"name": "Emberheart", "tier": "common",
		"desc": "The hero holding it: Fire and Holy\nstrike damage +{=@hooks.dmg_type_mult.fire*100}%.",
		"hooks": {"dmg_type_mult": {"fire": 0.40, "holy": 0.40}}},
	"frostsigil": {"name": "Frostbound Sigil", "tier": "common",
		"desc": "The hero holding it: Frost and Arcane\nstrike damage +{=@hooks.dmg_type_mult.frost*100}%.",
		"hooks": {"dmg_type_mult": {"frost": 0.40, "arcane": 0.40}}},
	"nightbloom": {"name": "Nightbloom Charm", "tier": "common",
		"desc": "The hero holding it: Shadow and Nature\nstrike damage +{=@hooks.dmg_type_mult.shadow*100}%.",
		"hooks": {"dmg_type_mult": {"shadow": 0.40, "nature": 0.40}}},
	"packcharm": {"name": "Packmother's Satchel", "tier": "common",
		"desc": "Begin each run with {=@hooks.start_items.health} extra Health Potions\nand {=@hooks.start_items.mana} extra Mana Potion.",
		"hooks": {"start_items": {"health": 2, "mana": 1}}},
	"lodestone": {"name": "Peddler's Lodestone", "tier": "common",
		"desc": "Shop prices reduced {=@hooks.shop_discount*100}%.",
		"hooks": {"shop_discount": 0.20}},
	# BATCH JD §4 — RE-CUT ONTO THE RETURN, AND IT IS THE RULING'S COUNTER (JD §0.2, the designer's). IK §6 suspended
	# it when the rest node's hook paid nothing; with it a hero left down takes the clearing heal like everyone
	# (`Run.clearing_heal`). The relics on `victory_heal_pct` reach him (JE §0.1); this one buys back the base, a fixed
	# figure, and adds none of its own.
	"cairnmoss": {"name": "Cairnmoss Poultice", "tier": "common",
		"desc": "A hero who falls recovers with the rest.",
		"hooks": {"fallen_recover": 1}},
	"lantern": {"name": "Gravelight Lantern", "tier": "common",
		"desc": "Elite spoils include one extra consumable.",
		"hooks": {"loot_extra": 1}},
	"tithe": {"name": "Tithing Scales", "tier": "common",
		"desc": "Gold won in battles and bargains +{=@hooks.gold_find_mult*100}%.",
		"hooks": {"gold_find_mult": 0.25}},
	"whetstone": {"name": "Ancestral Whetstone", "tier": "common",
		"desc": "The hero holding it: +{=@hooks.hero_crit_add*100}% critical chance.",
		"hooks": {"hero_crit_add": 0.10}},
	"ironbark": {"name": "Ironbark Ward", "tier": "common",
		"desc": "The hero holding it: +{=@hooks.hero_armor_add*100}% armor.",
		"hooks": {"hero_armor_add": 0.10}},
	"fleetstep": {"name": "Fleetstep Talisman", "tier": "common",
		"desc": "The hero holding it: +{=@hooks.hero_speed_add} Speed.",
		"hooks": {"hero_speed_add": 10}},
	"oxheart": {"name": "Oxheart Fetish", "tier": "common",
		"desc": "The hero holding it: +{=@hooks.hero_max_hp_mult*100}% max Health.",
		"hooks": {"hero_max_hp_mult": 0.20}},
	"stormflask": {"name": "Bottled Storm", "tier": "common",
		"desc": "Heroes open every battle with at least\n{=@hooks.resource_floor_pct*100}% of their resource.",
		"hooks": {"resource_floor_pct": 0.35}},
	"drumskin": {"name": "Wardrums of the Old Horde", "tier": "common",
		"desc": "The hero holding it: +{=@hooks.hero_con_add} Constitution\n(Break resistance).",
		"hooks": {"hero_con_add": 30}},
	# ---------- rare ----------
	"dragonbone": {"name": "Dragonbone Idol", "tier": "rare",
		"desc": "The hero holding it deals +{=@hooks.hero_attack_mult*100}% strike damage.",
		"hooks": {"hero_attack_mult": 0.20}},
	"runedplate": {"name": "Runed Bulwark", "tier": "rare",
		"desc": "The hero holding it: {=@hooks.hero_resist_add.physical*100}% physical resistance.",
		"hooks": {"hero_resist_add": {"physical": 0.20}}},
	"prismveil": {"name": "Prism Veil", "tier": "rare",
		"desc": "The hero holding it: {=@hooks.hero_resist_add.fire*100}% resistance\nto every element.",
		"hooks": {"hero_resist_add": {"fire": 0.20, "frost": 0.20,
			"nature": 0.20, "shadow": 0.20, "holy": 0.20, "arcane": 0.20}}},
	"hourglass": {"name": "Cracked Hourglass", "tier": "rare",
		"desc": "After every victory: every hero with Mana\nrecovers {=@hooks.victory_mana_pct*100}% of maximum Mana, and every\nhero heals {=@hooks.victory_heal_pct*100}% of maximum health.",
		"hooks": {"victory_mana_pct": 0.30, "victory_heal_pct": 0.05}},
	"kingsledger": {"name": "The King's Ledger", "tier": "rare",
		"desc": "+{=@hooks.start_gold} gold at run start; battle and bargain gold +{=@hooks.gold_find_mult*100}%.",
		"hooks": {"start_gold": 40, "gold_find_mult": 0.40}},
	# BATCH BM: same re-spec, same reason. Its damage clause is untouched and
	# the vacated half became more of it.
	"warhorn": {"name": "Horn of the First War", "tier": "rare",
		"desc": "The hero holding it deals +{=@hooks.hero_attack_mult*100}% strike damage.",
		"hooks": {"hero_attack_mult": 0.24}},
	"martyrbone": {"name": "Martyr's Knucklebone", "tier": "rare",
		"desc": "Every hero heals {=@hooks.victory_heal_pct*100}% of maximum\nhealth after every victory.",
		"hooks": {"victory_heal_pct": 0.15}},
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
#
# BATCH JD §4: Cairnmoss Poultice was the one relic it held, and it is back. The door stands, holding nothing.
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


# BATCH KD — A RELIC IS HELD WHEN ANY OF ITS HOOKS PAYS ONLY ITS HOLDER: it is handed to one hero on the map
# (`Run.relics_owed`, `Run.hand_relic`), and a relic that is not held pays every hero and is handed to nobody.
static func is_held(id: String) -> bool:
	for hook in (POOL.get(id, {}).get("hooks", {}) as Dictionary):
		if HOLDER_HOOKS.has(hook):
			return true
	return false


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
