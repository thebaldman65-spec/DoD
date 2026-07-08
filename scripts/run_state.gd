# Run-level state (autoload "Run"): the party, shared inventory, and the
# Spire-style node map. Persists across scene switches within one run.
extends Node

# Zone structure rules: the player interacts with 10 nodes before the boss.
# 10 tiers × 3 nodes = 30 interconnected nodes, plus the boss tier on top.
const FLOORS := 11  # 10 pickable tiers + the boss tier
const NODES_PER_TIER := 3
# Fixed node composition per zone: 60% fights, 20% rest, 20% shops.
const FIGHT_NODES := 18
const REST_NODES := 6
const SHOP_NODES := 6

# All item metadata lives here; battle and map both read it.
const ITEM_IDS := ["health", "mana", "bomb", "revive", "defense"]
const ITEM_INFO := {
	"health": ["Health Potion", "Restores 40 HP to one ally."],
	"mana": ["Mana Potion", "Restores 40 Mana (or Rage) to one ally."],
	"bomb": ["Bomb", "Deals 50 damage to all enemies."],
	"revive": ["Revive Potion", "Revives a fallen ally at 50% HP."],
	"defense": ["Defense Potion", "+10% armor to all living party members for 3 turns."],
}
# Potions drop more often than the heavy items.
const LOOT_POOL := ["health", "health", "mana", "mana", "bomb", "revive", "defense"]

var active := false
var specs_chosen := false  # locked in during the pre-run awakening
var gold := 0

const SAVE_PATH := "user://run_save.bin"

const ZONES := ["Forest of Old", "The Scarlands"]
var active_relics: Array = []  # up to 3 relic ids chosen at the draft
var zone_idx := 0
var zone_name := "Forest of Old"
var party: Array = []      # [{key, hp, max_hp}] snapshots between battles
var items := {}            # item id -> count (shared inventory)
var map: Array = []        # map[floor] = [{type, links: [next-floor idx], visited}]
var floor_idx := -1        # -1 = run not started; player picks from floor 0
var node_idx := -1
var encounter := {}        # {"type": ..., "enemies": ["raider", ...]} for the next battle


const HERO_BASE := {
	"warrior": {"hp": 154, "mana": 0},
	"mage": {"hp": 99, "mana": 100},
	"cleric": {"hp": 121, "mana": 100},
	"hunter": {"hp": 110, "mana": 0},
}


func relic_active(id: String) -> bool:
	return active_relics.has(id)


func new_run(keys := ["warrior", "mage", "cleric", "hunter"], relics: Array = []) -> void:
	active = true
	specs_chosen = false
	active_relics = relics.slice(0, 3)
	clear_save()
	party = []
	for key in keys:
		var base: Dictionary = HERO_BASE[key]
		party.append({"key": key, "hp": base["hp"], "max_hp": base["hp"],
			"mana": base["mana"], "max_mana": 100, "spec": "",
			"talent_points": 1 if relic_active("waystone") else 0,
			"talents": {}, "runes": []})
	items = {"health": 2, "mana": 1, "bomb": 1, "revive": 1, "defense": 1}
	gold = 60 + (80 if relic_active("coin") else 0)
	zone_idx = 0
	zone_name = ZONES[0]
	zone_idx = 0
	zone_name = ZONES[0]
	floor_idx = -1
	node_idx = -1
	encounter = {}
	_generate_map()


func _generate_map() -> void:
	# Shuffle a fixed deck of 30 node types, deal 3 per tier, boss on top.
	var deck: Array = []
	for i in FIGHT_NODES:
		deck.append("fight")
	for i in REST_NODES:
		deck.append("rest")
	for i in SHOP_NODES:
		deck.append("shop")
	deck.shuffle()
	# The run should open with combat: tier 1 holds at least one fight.
	if not deck.slice(0, NODES_PER_TIER).has("fight"):
		for j in range(NODES_PER_TIER, deck.size()):
			if deck[j] == "fight":
				var tmp: String = deck[0]
				deck[0] = deck[j]
				deck[j] = tmp
				break
	map = []
	for f in FLOORS - 1:
		var row: Array = []
		for i in NODES_PER_TIER:
			var kind: String = deck[f * NODES_PER_TIER + i]
			# Deeper fights can spawn as elites (still fights, tougher + richer).
			if kind == "fight" and f >= 5 and randf() < 0.25:
				kind = "elite"
			row.append({"type": kind, "links": [], "visited": false})
		map.append(row)
	map.append([{"type": "boss", "links": [], "visited": false}])
	# Link each node to 1-2 nodes on the next floor: its own column, plus a
	# 70% chance of ONE adjacent column. Never all three — the player gets a
	# choice most tiers but can only drift one column per step, so reaching a
	# specific elite or shop takes route planning.
	for f in FLOORS - 1:
		var a: int = map[f].size()
		var b: int = map[f + 1].size()
		for i in a:
			var base := 0 if a == 1 else int(round(i * float(b - 1) / float(maxi(a - 1, 1))))
			var links: Array = [base]
			if randf() < 0.70:
				var extra := base + (1 if randf() < 0.5 else -1)
				if extra >= 0 and extra < b and not links.has(extra):
					links.append(extra)
			map[f][i]["links"] = links
		# Every next-floor node needs at least one inbound path.
		for j in b:
			var has_inbound := false
			for i in a:
				if map[f][i]["links"].has(j):
					has_inbound = true
					break
			if not has_inbound:
				var nearest := 0 if b == 1 else int(round(j * float(a - 1) / float(maxi(b - 1, 1))))
				map[f][nearest]["links"].append(j)


# Node indices on the next floor the player may move to.
func reachable() -> Array:
	if floor_idx < 0:
		var all := []
		for i in map[0].size():
			all.append(i)
		return all
	if floor_idx >= FLOORS - 1:
		return []
	return map[floor_idx][node_idx]["links"]


func advance(f: int, i: int) -> void:
	floor_idx = f
	node_idx = i
	map[f][i]["visited"] = true


# Enemy composition per node type (kinds resolved by battle.gd).
func compose(node_type: String) -> Array:
	match node_type:
		"elite":
			return ["chief", "archer", "raider"] if zone_idx == 0 \
				else ["chief", "raider", "raider", "archer", "archer"]
		"boss":
			return ["boss", "raider", "archer"] if zone_idx == 0 \
				else ["boss", "raider", "raider", "archer", "archer"]
		_:
			var pools := [["raider", "raider", "archer"], ["raider", "archer", "archer"],
				["raider", "raider", "archer", "archer"], ["raider", "raider", "raider", "archer"]]
			if zone_idx >= 1:
				pools.append(["raider", "raider", "raider", "archer", "archer"])
				pools.append(["raider", "raider", "archer", "archer", "archer"])
			return pools.pick_random()


func heal_party(pct: float) -> void:
	for member in party:
		if member["hp"] > 0:
			member["hp"] = mini(member["hp"] + int(member["max_hp"] * pct), member["max_hp"])


# Resting restores spirit as well as flesh (Mage/Cleric mana pools).
func restore_mana(pct: float) -> void:
	for member in party:
		if member["key"] == "mage" or member["key"] == "cleric":
			member["mana"] = mini(member["mana"] + int(member["max_mana"] * pct), member["max_mana"])


func random_loot() -> String:
	return LOOT_POOL.pick_random()


# ---------- rune generation (shared by the Peddler and elite drops) ----------

# Rarity scales both power and price. Runes are run-scoped.
const RUNE_RARITIES := [
	{"key": "common", "label": "Common", "mult": 1, "price": 50, "prefix": "Cracked",
		"color": Color(0.8, 0.8, 0.8)},
	{"key": "rare", "label": "Rare", "mult": 2, "price": 100, "prefix": "Polished",
		"color": Color(0.45, 0.65, 1.0)},
	{"key": "epic", "label": "Epic", "mult": 3, "price": 160, "prefix": "Radiant",
		"color": Color(0.75, 0.45, 1.0)},
]
const RUNE_TEMPLATES := [
	{"noun": "Vitality", "stat": "max_hp", "base": 10, "fmt": "+%d max HP"},
	{"noun": "Warding", "stat": "armor", "base": 0.02, "fmt": "+%d%% armor"},
	{"noun": "Swiftness", "stat": "speed", "base": 4, "fmt": "+%d Speed"},
	{"noun": "Poise", "stat": "stability", "base": 12, "fmt": "+%d Stability"},
	{"noun": "Precision", "stat": "crit_bonus", "base": 0.02, "fmt": "+%d%% crit chance"},
	{"noun": "Springs", "stat": "max_resource", "base": 8, "fmt": "+%d max Mana"},
]


func generate_rune(class_key: String) -> Dictionary:
	var pool := RUNE_TEMPLATES.filter(
		func(t): return not (t["stat"] == "max_resource" and class_key == "warrior"))
	var template: Dictionary = pool.pick_random()
	var roll := randf()
	var rarity: Dictionary = RUNE_RARITIES[0] if roll < 0.6 \
		else (RUNE_RARITIES[1] if roll < 0.9 else RUNE_RARITIES[2])
	var value = template["base"] * rarity["mult"]
	var shown: int = int(value * 100) if template["base"] is float else int(value)
	return {
		"name": "%s Rune of %s" % [rarity["prefix"], template["noun"]],
		"rarity": rarity["label"],
		"rarity_color": rarity["color"],
		"price": rarity["price"],
		"desc": template["fmt"] % shown,
		"payload": {"stat": {template["stat"]: value}},
		"equipped": false,
	}


func has_next_zone() -> bool:
	return zone_idx < ZONES.size() - 1


# Move to the next zone: fresh map, path reset; the party is fully
# restored as a reward for cleansing the zone.
func advance_zone() -> void:
	zone_idx += 1
	zone_name = ZONES[zone_idx]
	floor_idx = -1
	node_idx = -1
	encounter = {}
	for member in party:
		member["hp"] = member["max_hp"]
		member["mana"] = member["max_mana"]
	_generate_map()


# ---------- persistence (saved after every completed node) ----------

func save_run() -> void:
	if not active:
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({
		"version": 1, "party": party, "items": items, "gold": gold,
		"zone_idx": zone_idx, "zone_name": zone_name, "floor_idx": floor_idx,
		"node_idx": node_idx, "specs_chosen": specs_chosen,
		"active_relics": active_relics, "map": map,
	}, true)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func load_run() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data: Variant = file.get_var(true)
	if not (data is Dictionary):
		return false
	party = data["party"]
	items = data["items"]
	gold = data["gold"]
	zone_idx = data["zone_idx"]
	zone_name = data["zone_name"]
	floor_idx = data["floor_idx"]
	node_idx = data["node_idx"]
	specs_chosen = data["specs_chosen"]
	active_relics = data["active_relics"]
	map = data["map"]
	encounter = {}
	active = true
	return true


func clear_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)


func award_gold(node_type: String) -> int:
	var amount := randi_range(25, 35)
	match node_type:
		"elite":
			# Elites pay out hard — seeking them out is how skilled players snowball.
			amount = randi_range(80, 100)
		"boss":
			amount = randi_range(110, 130)
	gold += amount
	return amount


# Combat rewards: every hero gains talent points (fight 1, elite 2, boss 3).
func award_talent_points(node_type: String) -> int:
	var pts := 1
	match node_type:
		"elite":
			pts = 2
		"boss":
			pts = 3
	for member in party:
		member["talent_points"] = member.get("talent_points", 0) + pts
	return pts
