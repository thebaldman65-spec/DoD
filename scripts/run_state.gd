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
var specs_chosen := false  # locked in after the first combat victory
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
}


func new_run(keys := ["warrior", "mage", "cleric"]) -> void:
	active = true
	specs_chosen = false
	party = []
	for key in keys:
		var base: Dictionary = HERO_BASE[key]
		party.append({"key": key, "hp": base["hp"], "max_hp": base["hp"],
			"mana": base["mana"], "max_mana": 100, "spec": "",
			"talent_points": 0, "talents": {}})
	items = {"health": 2, "mana": 1, "bomb": 1, "revive": 1, "defense": 1}
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


func _roll_node_type(f: int) -> String:
	if f == FLOORS - 1:
		return "boss"
	if f == 0:
		return "fight"
	var roll := randf()
	if roll < 0.55:
		return "fight"
	elif roll < 0.72 and f >= 2:
		return "elite"
	elif roll < 0.88:
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
			return ["chief", "raider"]
		"boss":
			return ["boss", "raider", "raider"]
		_:
			return ["raider", "raider"] if randf() < 0.5 else ["raider", "raider", "raider"]


func heal_party(pct: float) -> void:
	for member in party:
		if member["hp"] > 0:
			member["hp"] = mini(member["hp"] + int(member["max_hp"] * pct), member["max_hp"])


# Resting restores spirit as well as flesh (Mage/Cleric mana pools).
func restore_mana(pct: float) -> void:
	for member in party:
		if member["key"] != "warrior":
			member["mana"] = mini(member["mana"] + int(member["max_mana"] * pct), member["max_mana"])


func random_loot() -> String:
	return LOOT_POOL.pick_random()


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
