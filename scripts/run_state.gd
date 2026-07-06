# Run-level state (autoload "Run"): the party, shared inventory, and the
# Spire-style node map. Persists across scene switches within one run.
extends Node

const FLOORS := 8

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
	"warrior": {"hp": 140, "mana": 0},
	"mage": {"hp": 90, "mana": 100},
	"cleric": {"hp": 110, "mana": 100},
	"hunter": {"hp": 100, "mana": 0},
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
	map = []
	for f in FLOORS:
		var row: Array = []
		var count := 1 if f == FLOORS - 1 else randi_range(2, 3)
		for i in count:
			row.append({"type": _roll_node_type(f), "links": [], "visited": false})
		map.append(row)
	# Link each node to 1-2 nodes on the next floor, keeping paths connected.
	for f in FLOORS - 1:
		var a: int = map[f].size()
		var b: int = map[f + 1].size()
		for i in a:
			var base := 0 if a == 1 else int(round(i * float(b - 1) / float(maxi(a - 1, 1))))
			var links: Array = [base]
			if randf() < 0.45:
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
	# Guarantee at least one shop per run.
	var has_shop := false
	for floor_row in map:
		for map_node in floor_row:
			if map_node["type"] == "shop":
				has_shop = true
	if not has_shop:
		var shop_floor := randi_range(2, 5)
		var row: Array = map[shop_floor]
		row[randi_range(0, row.size() - 1)]["type"] = "shop"


func _roll_node_type(f: int) -> String:
	if f == FLOORS - 1:
		return "boss"
	if f == 0:
		return "fight"
	var roll := randf()
	if roll < 0.50:
		return "fight"
	elif roll < 0.67 and f >= 2:
		return "elite"
	elif roll < 0.77 and f >= 1:
		return "shop"
	elif roll < 0.90:
		return "rest"
	else:
		return "treasure"


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
			amount = randi_range(55, 70)
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
