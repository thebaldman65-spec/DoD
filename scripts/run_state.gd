# Run-level state (autoload "Run"): the party, shared inventory, and the
# Spire-style node map. Persists across scene switches within one run.
extends Node

# Zone structure rules: the player interacts with 10 nodes before the boss.
# 10 tiers × 3 nodes = 30 interconnected nodes, plus the boss tier on top.
const FLOORS := 11  # 10 pickable tiers + the boss tier
const NODES_PER_TIER := 3
# Fixed node composition per zone: 17 fights / 5 rest / 5 shop / 3 event.
# Events replaced one rest, one shop and one fight; the ~1 talent point
# per run that the lost fight cost comes back through point-granting
# events (Blood Altar, Training Grounds, Warden's Echo).
const FIGHT_NODES := 17
const REST_NODES := 5
const SHOP_NODES := 5
const EVENT_NODES := 3

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
# Node scaling: combat victories this run. Heroes gain +2% of base Attack
# and HP per win (linear; applied at battle spawn; never touches armor/
# resists/speed/constitution/crit/block/parry).
var combat_wins := 0

const SAVE_PATH := "user://run_save.bin"

# Zone rotation (Batch 37): a run is SLOT_COUNT zone slots and each
# slot draws ONE zone from its authored candidate pool — zones are
# designed FOR a position (openers are not finales), so pools are
# per-slot, never flat. Every zone runs the same FLOORS tiers: the
# talent economy (~35 points/run) assumes 3 zones x 11 tiers, so a new
# zone keeps 11 tiers or the cost curve gets revisited. A zone def
# carries its display name (art + save key), its boss kind, and a
# roster id per slot it can host — roster ids are what the "zones"
# tags in enemies.json actually mean. The Forest of Old hosts slots 1
# AND 3: roster 1 as the opener, the tougher roster 3 as the finale.
# Random draws stay behind DOD_ZONE_ROTATION=1 (fixed first-candidate
# order otherwise) until each pool holds ~2 candidates; with today's
# single-candidate pools both modes draw identically.
# Adding a zone = ZONE_DEFS entry + SLOT_POOLS candidacy + roster tags
# in enemies.json + zone_name keys in the battle/map background dicts.
const SLOT_COUNT := 3
const ZONE_DEFS := {
	"forest": {"name": "Forest of Old", "boss": "withered_warden",
		"rosters": {1: 1, 3: 3}},
	"scarlands": {"name": "The Scarlands", "boss": "ash_tyrant",
		"rosters": {2: 2}},
}
const SLOT_POOLS := [["forest"], ["scarlands"], ["forest"]]
var active_relics: Array = []  # up to 3 relic ids chosen at the draft
var zone_idx := 0
var zone_name := "Forest of Old"
var zone_draw: Array = []  # this run's drawn zone ids, one per slot
var party: Array = []      # [{key, hp, max_hp}] snapshots between battles
var items := {}            # item id -> count (shared inventory)
var map: Array = []        # map[floor] = [{type, links: [next-floor idx], visited}]
var floor_idx := -1        # -1 = run not started; player picks from floor 0
var node_idx := -1
var encounter := {}        # {"type": ..., "enemies": ["raider", ...]} for the next battle
var seen_events: Array = []  # event ids drawn this run (non-repeating pool)
# Debug (map burger): pre-grant every talent/trophy ability at battle
# spawn. Session-scoped, never saved; DOD_SIM_GRANT_ALL=1 arms it for
# headless full-kit runs. Default OFF so tests measure gated kits.
var debug_grant_all := false
var pending_event := ""    # event id the event screen resolves (not saved:
                           # quitting mid-event forfeits it, node stays spent)


const HERO_BASE := {
	"warrior": {"hp": 154, "mana": 0},
	"mage": {"hp": 99, "mana": 100},
	"cleric": {"hp": 121, "mana": 100},
	"hunter": {"hp": 110, "mana": 100},
}


# Debug tooling is always available in dev (unexported) builds; exported
# builds need DOD_DEBUG=1 explicitly.
func debug_enabled() -> bool:
	return OS.is_debug_build() or OS.get_environment("DOD_DEBUG") == "1"


func relic_active(id: String) -> bool:
	return active_relics.has(id)


# Aggregated relic hooks (see the vocabulary audit atop relics.gd):
# scalar hooks sum, dict hooks merge, across this run's active relics.
func relic_add(hook: String) -> float:
	return Relics.hook_add(active_relics, hook)


func relic_dict(hook: String) -> Dictionary:
	return Relics.hook_dict(active_relics, hook)


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
			"talent_points": int(relic_add("start_talent_points")),
			"talents": {}, "runes": []})
	items = {"health": 2, "mana": 1, "bomb": 1, "revive": 1, "defense": 1}
	for id in relic_dict("start_items"):
		items[id] = int(items.get(id, 0)) + int(relic_dict("start_items")[id])
	gold = 60 + int(relic_add("start_gold"))
	combat_wins = 0
	zone_idx = 0
	draw_zones()
	_enter_zone()
	floor_idx = -1
	node_idx = -1
	encounter = {}
	seen_events = []
	pending_event = ""
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
	for i in EVENT_NODES:
		deck.append("event")
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
	# Warbands are pre-rolled at map birth: every combat node carries its
	# enemies + theme, so the map can show what resists what BEFORE the
	# player commits (scouting resists is counterplay, not a spoiler).
	# The click handler still composes on the spot for pre-change saves.
	for f in FLOORS:
		for node in map[f]:
			if node["type"] in ["fight", "elite", "boss"]:
				node["enemies"] = compose(node["type"], f + 1)
				node["theme"] = last_theme


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


# ---------- themed encounter generation (the budget system) ----------

# Every enemy carries a power value; every battle rolls a power budget and
# SPENDS IT EXACTLY. Generation is two-step: pick a THEME (a cohesive
# warband, not a random mob), then fill its roles until the budget is gone.
# The field holds at most 6 enemies. CHIEFS ONLY APPEAR IN ELITE FIGHTS.
const MAX_FIELD := 6

# THEMES ARE ROLE-BASED (Batch 34): pool keys are ROLES — any enemy tagged
# with the role (and legal in the current zone) is eligible, so a new
# enemy joins every theme that wants its role automatically. pool: role ->
# max units drawn from it. mins: role -> required units. Optional checks:
# min_units / max_units, min_kinds (distinct KINDS), min_weak (units of
# power <= 1 — fixed from the old "Raiders + Archers" wording), majority
# (that role fills at least half the slots). nodes: node types the theme
# can appear on. Role vocabulary: skirmisher (cheap melee), sniper
# (ranged damage), bulwark (tank/warder), mender (healer), hexer
# (debuff caster), brute (heavy power-3 muscle), elite (chief tier),
# boss.
const THEMES := {
	"Warband": {"pool": {"skirmisher": 3, "sniper": 3, "bulwark": 2, "mender": 2},
		"min_kinds": 3, "nodes": ["fight"]},
	"Swarm": {"pool": {"skirmisher": 5, "sniper": 5, "bulwark": 2, "mender": 2},
		"min_weak": 3, "min_units": 3, "nodes": ["fight"]},
	"Monster Den": {"pool": {"brute": 2, "skirmisher": 2, "hexer": 1, "mender": 1},
		"mins": {"brute": 1}, "nodes": ["fight"]},
	"Cursed Company": {"pool": {"hexer": 3, "bulwark": 2, "skirmisher": 2, "sniper": 2},
		"mins": {"hexer": 2}, "nodes": ["fight"]},
	"Honor Guard": {"pool": {"elite": 1, "bulwark": 3, "skirmisher": 2, "sniper": 2},
		"mins": {"elite": 1, "bulwark": 2}, "nodes": ["elite"]},
	"Ritual": {"pool": {"mender": 3, "hexer": 2, "bulwark": 3, "skirmisher": 2},
		"mins": {"mender": 2, "bulwark": 1}, "nodes": ["fight"]},
	"Poison Volley": {"pool": {"sniper": 4, "hexer": 2, "skirmisher": 1, "bulwark": 2,
		"mender": 1}, "mins": {"sniper": 3}, "majority": "sniper", "nodes": ["fight"]},
	"Lightning Storm": {"pool": {"mender": 4, "hexer": 2, "bulwark": 2, "skirmisher": 2,
		"sniper": 2}, "mins": {"mender": 2}, "nodes": ["fight"]},
	"Rage Company": {"pool": {"elite": 2, "brute": 2, "skirmisher": 4, "sniper": 2},
		"mins": {"elite": 1, "skirmisher": 2}, "nodes": ["elite"]},
	"Guardian Circle": {"pool": {"bulwark": 5, "mender": 1, "skirmisher": 2, "sniper": 2},
		"mins": {"bulwark": 3}, "nodes": ["fight"]},
	"Elite Patrol": {"pool": {"elite": 2, "bulwark": 2, "mender": 2, "brute": 1,
		"skirmisher": 1, "sniper": 1},
		"mins": {"elite": 1, "bulwark": 1, "mender": 1},
		"max_units": 4, "nodes": ["elite"]},
	"Boss Escort": {"pool": {"boss": 1, "bulwark": 2, "mender": 2, "brute": 2,
		"skirmisher": 2, "sniper": 2}, "mins": {"boss": 1}, "nodes": ["boss"]},
}

var last_theme := ""  # theme of the most recently composed encounter


# Test hook (DOD_SIM_THEME): one warband of the named theme at an exact
# budget and roster, ignoring run state. Empty array when nothing fits.
func compose_test(theme_name: String, budget: int, roster := 1) -> Array:
	if not THEMES.has(theme_name):
		return []
	var combos := _theme_combos(THEMES[theme_name], budget, roster)
	if combos.is_empty():
		return []
	last_theme = theme_name
	var warband: Array = combos.pick_random()
	warband.shuffle()
	return warband


# Sweep hook (DOD_SIM_SWEEP): one warband at an EXACT budget, drawn from a
# random fight-node theme — the real map's draw minus the budget roll.
# Ignores run state. Empty array when no fight theme can spend the budget.
func compose_budget(budget: int, roster := 1) -> Array:
	var candidates: Array = []
	for theme_name in THEMES:
		if THEMES[theme_name]["nodes"].has("fight"):
			candidates.append(theme_name)
	candidates.shuffle()
	for theme_name in candidates:
		var combos := _theme_combos(THEMES[theme_name], budget, roster)
		if combos.is_empty():
			continue  # theme can't spend this budget — try another
		last_theme = theme_name
		var warband: Array = combos.pick_random()
		warband.shuffle()
		return warband
	return []


# The budget scales across EACH ZONE (tier = the floor within the zone,
# 1-11 with the boss on 11): tiers 1-3 roll 3-6, tiers 4-7 roll 6-9,
# tiers 8-11 roll 10-12. Later zones restart the ladder with a tougher
# roster carrying higher base stats (Forest of Old is the focus for now).
# Enemy stat scaling is zone-local (Batch 36): every zone replays the
# 1..11 tier ladder and its position in the run applies a flat base
# multiplier. Keyed by SLOT, not zone identity — the Forest of Old is
# x1.0 as the opener and x2.2 when revisited as the finale — and slots
# past the authored list continue the ~x1.5 step, so adding a 4th zone
# is data work, never formula work.
const ZONE_BASE_MULTS := [1.0, 1.5, 2.2]


func zone_base_mult(slot: int) -> float:
	if slot <= ZONE_BASE_MULTS.size():
		return ZONE_BASE_MULTS[maxi(slot, 1) - 1]
	return ZONE_BASE_MULTS[ZONE_BASE_MULTS.size() - 1] \
		* pow(1.5, slot - ZONE_BASE_MULTS.size())


func battle_budget(tier := -1) -> int:
	if tier <= 0:
		tier = floor_idx + 1
	tier = clampi(tier, 1, FLOORS)
	if tier <= 3:
		return randi_range(3, 6)
	if tier <= 7:
		return randi_range(6, 9)
	return randi_range(10, 12)


func compose(node_type: String, tier := -1) -> Array:
	var budget := battle_budget(tier)
	var candidates: Array = []
	for theme_name in THEMES:
		if THEMES[theme_name]["nodes"].has(node_type):
			candidates.append(theme_name)
	candidates.shuffle()
	for theme_name in candidates:
		var combos := _theme_combos(THEMES[theme_name], budget)
		if combos.is_empty():
			continue  # theme can't spend this budget — try another
		last_theme = theme_name
		var warband: Array = combos.pick_random()
		warband.shuffle()
		return warband
	# Nothing fit — plain mob fallback (kept as a safety net).
	last_theme = "Warband"
	var fb_kinds := Enemies.kinds_for_roster(active_roster() if active else 1) \
		.filter(func(k): return Enemies.power(k) <= 2)
	if fb_kinds.is_empty():
		fb_kinds = ["raider"]
	var fallback: Array = []
	for i in clampi(budget / 2, 2, 5):
		fallback.append(fb_kinds.pick_random())
	return fallback


# Every exact-budget warband a theme can field (arrays of enemy kinds).
# Roles resolve to the kinds legal in the CURRENT zone; a kind with two
# role tags is claimed by the first pooled role that wants it, so pool
# caps never double-count.
func _theme_combos(spec: Dictionary, budget: int, roster := -1) -> Array:
	if roster <= 0:
		roster = active_roster() if active else 1
	var zone_kinds := Enemies.kinds_for_roster(roster)
	var role_kinds := {}
	var claimed := {}
	for role in spec["pool"]:
		var lst: Array = []
		for kind in zone_kinds:
			if not claimed.has(kind) and Enemies.roles(kind).has(role):
				lst.append(kind)
				claimed[kind] = true
		role_kinds[role] = lst
	var results: Array = []
	_combo_walk(spec, spec["pool"].keys(), role_kinds, 0, budget, [], {}, results)
	return results


func _combo_walk(spec: Dictionary, roles: Array, role_kinds: Dictionary,
		r_idx: int, left: int, picked: Array, role_counts: Dictionary,
		results: Array) -> void:
	if r_idx == roles.size():
		if left == 0 and _combo_ok(spec, picked, role_counts):
			results.append(picked.duplicate())
		return
	var role: String = roles[r_idx]
	_role_walk(spec, roles, role_kinds, r_idx, role_kinds[role], 0,
		int(spec["pool"][role]), left, picked, role_counts, results)


# Chooses how many of each kind fill one role's slots (the pool value caps
# the ROLE total, not each kind).
func _role_walk(spec: Dictionary, roles: Array, role_kinds: Dictionary,
		r_idx: int, kinds: Array, k_idx: int, role_left: int, left: int,
		picked: Array, role_counts: Dictionary, results: Array) -> void:
	if k_idx == kinds.size() or role_left == 0:
		_combo_walk(spec, roles, role_kinds, r_idx + 1, left, picked,
			role_counts, results)
		return
	var kind: String = kinds[k_idx]
	var role: String = roles[r_idx]
	var max_units: int = spec.get("max_units", MAX_FIELD)
	var kp := Enemies.power(kind)
	for n in range(0, role_left + 1):
		var cost: int = kp * n
		if cost > left or picked.size() + n > max_units:
			break
		var next: Array = picked.duplicate()
		for i in n:
			next.append(kind)
		var next_counts: Dictionary = role_counts.duplicate()
		next_counts[role] = int(next_counts.get(role, 0)) + n
		_role_walk(spec, roles, role_kinds, r_idx, kinds, k_idx + 1,
			role_left - n, left - cost, next, next_counts, results)


func _combo_ok(spec: Dictionary, picked: Array, role_counts: Dictionary) -> bool:
	if picked.size() < int(spec.get("min_units", 1)):
		return false
	for role in spec.get("mins", {}):
		if int(role_counts.get(role, 0)) < int(spec["mins"][role]):
			return false
	# min_weak counts units of power <= 1 (not any hardcoded kind list).
	if spec.has("min_weak"):
		var weak := 0
		for kind in picked:
			if Enemies.power(kind) <= 1:
				weak += 1
		if weak < int(spec["min_weak"]):
			return false
	if spec.has("majority") \
			and int(role_counts.get(spec["majority"], 0)) * 2 < picked.size():
		return false
	if spec.has("min_kinds"):
		var distinct := {}
		for kind in picked:
			distinct[kind] = true
		if distinct.size() < int(spec["min_kinds"]):
			return false
	return true


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
	{"noun": "Poise", "stat": "constitution", "base": 12, "fmt": "+%d Constitution"},
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


func rotation_enabled() -> bool:
	return OS.get_environment("DOD_ZONE_ROTATION") == "1"


# One zone id per slot for this run. Fixed order = each pool's first
# author; the rotation flag draws randomly within the authored pools.
func draw_zones() -> void:
	zone_draw = []
	for slot in SLOT_COUNT:
		var pool: Array = SLOT_POOLS[slot]
		zone_draw.append(pool.pick_random() if rotation_enabled() else pool[0])


func current_zone_id() -> String:
	if zone_draw.is_empty():
		draw_zones()
	return zone_draw[clampi(zone_idx, 0, SLOT_COUNT - 1)]


func next_zone_name() -> String:
	if zone_idx + 1 >= SLOT_COUNT:
		return ""
	return ZONE_DEFS[zone_draw[zone_idx + 1]]["name"]


# The enemy pool this zone fields AT ITS CURRENT SLOT (the Forest is
# roster 1 as the opener, roster 3 as the finale).
func active_roster() -> int:
	var rosters: Dictionary = ZONE_DEFS[current_zone_id()]["rosters"]
	return int(rosters.get(zone_idx + 1, rosters.values().front()))


func boss_kind() -> String:
	return ZONE_DEFS[current_zone_id()]["boss"]


func _enter_zone() -> void:
	zone_name = ZONE_DEFS[current_zone_id()]["name"]


func has_next_zone() -> bool:
	return zone_idx < SLOT_COUNT - 1


# Move to the next zone: fresh map, path reset; the party is fully
# restored as a reward for cleansing the zone.
func advance_zone() -> void:
	zone_idx += 1
	_enter_zone()
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
	# v2 (Batch 38): + seen_events, zone_draw. Loading stays tolerant of
	# older saves via .get defaults — never drop player state silently.
	file.store_var({
		"version": 2, "party": party, "items": items, "gold": gold,
		"zone_idx": zone_idx, "zone_name": zone_name, "zone_draw": zone_draw,
		"floor_idx": floor_idx, "seen_events": seen_events,
		"node_idx": node_idx, "specs_chosen": specs_chosen,
		"active_relics": active_relics, "map": map,
		"combat_wins": combat_wins,
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
	# Trees are FIXED definitions in code: always swap the saved snapshot for
	# the live tree so balance edits reach old saves. Learned ranks carry
	# over; points in nodes that shrank or vanished are refunded.
	for member in party:
		var spec: String = member.get("spec", "")
		if spec == "":
			continue
		var live_tree := Talents.generate_tree(spec, member["key"])
		member["tree"] = live_tree
		var learned: Dictionary = member.get("talents", {})
		var refund := 0
		for id in learned.keys():
			var node := Talents.node_in_tree(live_tree, id)
			if node.is_empty():
				refund += int(learned[id])
				learned.erase(id)
			elif int(learned[id]) > int(node["ranks"]):
				refund += int(learned[id]) - int(node["ranks"])
				learned[id] = int(node["ranks"])
		member["talents"] = learned
		member["talent_points"] = member.get("talent_points", 0) + refund
	items = data["items"]
	gold = data["gold"]
	zone_idx = data["zone_idx"]
	zone_name = data["zone_name"]
	zone_draw = data.get("zone_draw", [])
	if zone_draw.is_empty():
		# Saves from before zone rotation ran the fixed order.
		for slot in SLOT_COUNT:
			zone_draw.append(SLOT_POOLS[slot][0])
	floor_idx = data["floor_idx"]
	node_idx = data["node_idx"]
	specs_chosen = data["specs_chosen"]
	active_relics = data["active_relics"]
	map = data["map"]
	combat_wins = int(data.get("combat_wins", 0))
	seen_events = data.get("seen_events", [])
	pending_event = ""
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
	amount = int(round(amount * (1.0 + relic_add("gold_find_mult"))))
	gold += amount
	return amount


# Combat rewards: every hero gains talent points (fight 1, elite 2, boss 3).
# Talent economy (Batch 30): 1 per fight, 2 per elite, 3 per zone boss.
# Rests and shops award none. (When a FINAL boss exists it should award no
# points — a relic instead — since points earned when nothing follows are
# unspendable; every boss today is a zone boss.)
func award_talent_points(node_type: String) -> int:
	var pts := 1
	match node_type:
		"elite":
			pts = 2
		"boss":
			# The FINAL boss awards no talent points (a relic instead) —
			# points earned when nothing follows are unspendable.
			pts = 3 if has_next_zone() else 0
	for member in party:
		member["talent_points"] = member.get("talent_points", 0) + pts
	return pts
