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

# THE HONESTY FLAG (Batch AC). Batch Z built the run summary so a tester
# can paste a wipe report straight back as feedback. The moment a run has
# had +200 gold poured into it or has teleported to a shop, that summary
# is not a data point — and nothing on it would say so. Saved with the
# run (v5); once true it never clears, because a run that was
# debug-touched stays debug-touched. Written in exactly TWO places, both
# at the top of a debug dispatch: map_screen._on_burger and
# battle._on_debug_menu. Sims can never set it (RunSim loads neither
# scene, and the menus do not exist off the scene tree).
var debug_used := false

# Free Travel (Batch AC, map burger check item): while on, every node on
# the board is clickable, ignoring links and position. Session-scoped,
# never saved. The click still runs the normal path, so the run advances
# honestly — debug_used above is what marks the run, not a fake board.
var debug_free_travel := false

# Node summoning (Batch AC): set for the duration of a summoned node and
# cleared when it resolves. A summoned node is entered IN PLACE and runs
# for real, but it must not corrupt the two records testers and sims
# read — so this flag switches OFF the run ledger (tally_add /
# tally_damage below) and the one Profile booking a summoned node can
# reach (battle.gd's wipe branch). Never saved.
var debug_summon := false
var pending_event := ""    # event id the event screen resolves (not saved:
                           # quitting mid-event forfeits it, node stays spent)
# RunSim harness (Batch S): simulated runs live entirely in memory — while
# set, save_run/clear_save are no-ops so a sim can never touch (or delete)
# the player's real save file.
var sim_run := false

# The run ledger (Batch Z): everything the end-of-run summary reports,
# accumulated across battles and map nodes. It lives here because the
# battle scene reloads between fights — anything scene-local dies with
# the fight. Keys are created on demand (tally_add) so pre-Z saves load
# clean. RunSim never reads it, and under sim_run it can only ever be an
# in-memory scratch (save_run is a no-op there), so sim purity holds.
var tally := {}


func reset_tally() -> void:
	tally = {"damage": {}, "gold_earned": 0, "gold_spent": 0,
		"elites": 0, "rests": 0, "battles": 0}


func tally_add(key: String, amount := 1) -> void:
	# Batch AC: a debug-summoned node never happened as far as the ledger
	# is concerned. Its gold, rests, battles and elites stay out, so a
	# summoned shop cannot silently inflate the economy line of a summary
	# a tester pastes back as feedback.
	if debug_summon:
		return
	if tally.is_empty():
		reset_tally()
	tally[key] = int(tally.get(key, 0)) + amount


# Per-hero damage across the whole run, keyed by battle unit_name (the
# spec display name once awakened) — the same naming space the sim
# reports use, banked once per battle from the battle scene.
func tally_damage(hero_name: String, amount: float) -> void:
	if debug_summon:
		return
	if tally.is_empty():
		reset_tally()
	var dmg: Dictionary = tally.get("damage", {})
	dmg[hero_name] = float(dmg.get(hero_name, 0.0)) + amount
	tally["damage"] = dmg


const HERO_BASE := {
	"warrior": {"hp": 154, "mana": 0},
	"mage": {"hp": 99, "mana": 100},
	"cleric": {"hp": 121, "mana": 100},
	"hunter": {"hp": 110, "mana": 100},
}


# Debug tooling is always available in dev (unexported) builds; exported
# builds need DOD_DEBUG=1 explicitly. DOD_DEBUG=0 forces the gate SHUT in
# a dev build (Batch AC) — the only way a headless test can stand where
# an exported build stands and prove every debug entry is unreachable.
func debug_enabled() -> bool:
	var env := OS.get_environment("DOD_DEBUG")
	if env == "0":
		return false
	return OS.is_debug_build() or env == "1"


func relic_active(id: String) -> bool:
	return active_relics.has(id)


# Aggregated relic hooks (see the vocabulary audit atop relics.gd):
# scalar hooks sum, dict hooks merge, across this run's active relics.
func relic_add(hook: String) -> float:
	return Relics.hook_add(active_relics, hook)


func relic_dict(hook: String) -> Dictionary:
	return Relics.hook_dict(active_relics, hook)


func new_run(keys := ["warrior", "mage", "cleric", "hunter"], relics: Array = [],
		diff := "standard") -> void:
	active = true
	specs_chosen = false
	difficulty = diff if DIFFICULTY_MULTS.has(diff) else "standard"
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
	# A fresh run starts clean, and starts un-summoned and un-travelled.
	debug_used = false
	debug_summon = false
	debug_free_travel = false
	reset_tally()
	_generate_map()


# Map generation mode (Batch Y): "new" = guaranteed-adjacent links + the
# structured deal below. DOD_SIM_MAP=old keeps the pre-Y generator (70%
# link roll, blind deal) so every pre-Y baseline row stays reproducible —
# DOD_SIM_ROUTE=greedy reproduces the Batch S floor ONLY at DOD_SIM_MAP=old.
func map_mode() -> String:
	return "old" if OS.get_environment("DOD_SIM_MAP") == "old" else "new"


# Validator counters (Batch Y), cumulative across every map this session:
# deal reshuffles, decks that needed the swap repair, and links the route
# guarantee had to add. A high repair rate means the deal constraints are
# over-tight and want loosening, not more retries.
var map_deal_retries := 0
var map_deal_repairs := 0
var map_route_links_added := 0


func _generate_map() -> void:
	if map_mode() == "old":
		_generate_map_old()
	else:
		_generate_map_new()
	# Warbands are pre-rolled at map birth: every combat node carries its
	# enemies + theme, so the map can show what resists what BEFORE the
	# player commits (scouting resists is counterplay, not a spoiler).
	# The click handler still composes on the spot for pre-change saves.
	for f in FLOORS:
		for node in map[f]:
			if node["type"] in ["fight", "elite", "boss"]:
				node["enemies"] = compose(node["type"], f + 1)
				node["theme"] = last_theme


# The pre-Batch-Y generator, kept verbatim behind DOD_SIM_MAP=old: the
# blind 30-card deal and the 70% adjacent-link roll (30% of nodes reached
# exactly one node — the corridor Batch Y exists to remove).
func _generate_map_old() -> void:
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
		_guarantee_inbound(f)


# Batch Y generation: the deck stays 17/5/5/3 but the deal is structured
# (no three-of-a-kind tier, recovery spread across both halves, a shop in
# the boss run-up), every node keeps a real choice ahead, at least one
# elite sits on the board, and a single legal route can always touch
# 2 rests + a shop + an elite.
func _generate_map_new() -> void:
	var deck := _deal_deck()
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
	# Elite floor: elites still roll at 25% on tiers 6+, but a zone whose
	# rolls all came up empty silently removes the snowball engine and the
	# rune-cache source — upgrade one deep fight when that happens.
	var has_elite := false
	for f in FLOORS - 1:
		for node in map[f]:
			if String(node["type"]) == "elite":
				has_elite = true
	if not has_elite:
		var deep_fights: Array = []  # [floor, idx] on tiers 6+
		for f in range(5, FLOORS - 1):
			for i in map[f].size():
				if String(map[f][i]["type"]) == "fight":
					deep_fights.append([f, i])
		if not deep_fights.is_empty():
			var pick: Array = deep_fights.pick_random()
			map[pick[0]][pick[1]]["type"] = "elite"
	# Links: own column plus AT LEAST one adjacent, guaranteed (the 70%
	# roll is gone — it made 30% of nodes a corridor). A middle column
	# with two neighbours links to both 25% of the time. The boss tier
	# still collapses to a single node: the pre-boss funnel is correct
	# and stays.
	for f in FLOORS - 1:
		var a: int = map[f].size()
		var b: int = map[f + 1].size()
		for i in a:
			var base := 0 if a == 1 else int(round(i * float(b - 1) / float(maxi(a - 1, 1))))
			var links: Array = [base]
			var adjacents: Array = []
			for extra in [base - 1, base + 1]:
				if extra >= 0 and extra < b:
					adjacents.append(extra)
			if not adjacents.is_empty():
				adjacents.shuffle()
				links.append(adjacents[0])
				if adjacents.size() > 1 and randf() < 0.25:
					links.append(adjacents[1])
			links.sort()
			map[f][i]["links"] = links
		_guarantee_inbound(f)
	_ensure_key_route()


# Every next-floor node needs at least one inbound path (shared by both
# generators, kept exactly as the pre-Y pass).
func _guarantee_inbound(f: int) -> void:
	var a: int = map[f].size()
	var b: int = map[f + 1].size()
	for j in b:
		var has_inbound := false
		for i in a:
			if map[f][i]["links"].has(j):
				has_inbound = true
				break
		if not has_inbound:
			var nearest := 0 if b == 1 else int(round(j * float(a - 1) / float(maxi(b - 1, 1))))
			map[f][nearest]["links"].append(j)


# ---------- the structured deal (Batch Y) ----------

# The canonical legal arrangement, used only when sampling AND the swap
# repair both fail (the validator shows this is ~never) — generation must
# never fail, so the floor is authored. Composition is the same 17/5/5/3.
const DECK_FALLBACK := [
	"fight", "fight", "shop",
	"fight", "rest", "fight",
	"fight", "fight", "event",
	"fight", "shop", "fight",
	"fight", "rest", "fight",
	"fight", "event", "fight",
	"fight", "shop", "rest",
	"fight", "fight", "shop",
	"fight", "rest", "event",
	"shop", "rest", "fight",
]


# Deal by rejection sampling with a bounded retry budget, then targeted
# swaps — never a failure, never an unbounded loop.
func _deal_deck() -> Array:
	var deck: Array = []
	for i in FIGHT_NODES:
		deck.append("fight")
	for i in REST_NODES:
		deck.append("rest")
	for i in SHOP_NODES:
		deck.append("shop")
	for i in EVENT_NODES:
		deck.append("event")
	for attempt in 40:
		deck.shuffle()
		if _deck_violations(deck) == 0:
			return deck
		map_deal_retries += 1
	_repair_deck(deck)
	map_deal_repairs += 1
	return deck


# The stage-2 constraints, counted so the repair can hill-climb:
# 1. tier 1 opens with combat (the pre-Y rule, folded in);
# 2. no tier deals three of a kind — every tier is a real choice;
# 3. recovery is spread: a rest in tiers 2-5 AND one in tiers 6-10;
# 4. a shop in tiers 7-10 — boss gold and deep rarity weights need a
#    place to land.
func _deck_violations(deck: Array) -> int:
	var n := NODES_PER_TIER
	var v := 0
	if not deck.slice(0, n).has("fight"):
		v += 1
	for t in FLOORS - 1:
		if String(deck[t * n]) == String(deck[t * n + 1]) \
				and String(deck[t * n + 1]) == String(deck[t * n + 2]):
			v += 1
	if not deck.slice(n, 5 * n).has("rest"):
		v += 1
	if not deck.slice(5 * n, deck.size()).has("rest"):
		v += 1
	if not deck.slice(6 * n, deck.size()).has("shop"):
		v += 1
	return v


# Targeted swap repair: greedily apply any single swap that strictly
# lowers the violation count. The count is bounded and strictly falls, so
# this terminates; if no single swap helps (never seen — belt and braces)
# the authored fallback arrangement lands as-is.
func _repair_deck(deck: Array) -> void:
	var v := _deck_violations(deck)
	while v > 0:
		var improved := false
		for i in deck.size():
			if improved:
				break
			for j in range(i + 1, deck.size()):
				if String(deck[i]) == String(deck[j]):
					continue
				var tmp: String = deck[i]
				deck[i] = deck[j]
				deck[j] = tmp
				var nv := _deck_violations(deck)
				if nv < v:
					v = nv
					improved = true
					break
				deck[j] = deck[i]
				deck[i] = tmp
		if not improved:
			for i in deck.size():
				deck[i] = DECK_FALLBACK[i]
			return


# ---------- the key-route guarantee (Batch Y) ----------

# Stage 2's promise is only real if a single legal ROUTE can touch the
# recovery, the shop, and the elite — nodes merely existing on the board
# is a suggestion, not a plan. When no route satisfies everything, widen
# the graph by adding missing adjacent links (nearest tier first) until
# one does: link additions only ever increase choice, so this converges
# and never degrades the map.
func _ensure_key_route() -> void:
	if _route_satisfied():
		return
	for f in FLOORS - 1:
		var a: int = map[f].size()
		var b: int = map[f + 1].size()
		for i in a:
			var base := 0 if a == 1 else int(round(i * float(b - 1) / float(maxi(a - 1, 1))))
			for extra in [base - 1, base + 1]:
				if extra >= 0 and extra < b and not map[f][i]["links"].has(extra):
					map[f][i]["links"].append(extra)
					map[f][i]["links"].sort()
					map_route_links_added += 1
					if _route_satisfied():
						return
	# Even the fully linked graph lacks a satisfying route — with rests
	# spread across both halves this should be unreachable; the validator
	# greps for it.
	push_warning("map: no single route reaches 2 rests + shop + elite fully linked")


# Requirement coverage as a bitmask: bit 0/1 = first and second rest,
# bit 2 = shop, bit 3 = elite. 15 = a route the player could plan for.
func _route_mask_after(kind: String, mask: int) -> int:
	match kind:
		"rest":
			if mask & 1 == 0:
				return mask | 1
			return mask | 2
		"shop":
			return mask | 4
		"elite":
			return mask | 8
	return mask


# Forward DP over the link graph: per node, the set of coverage masks any
# route from tier 1 can arrive with (at most 16 masks x 3 nodes a tier).
func _route_satisfied() -> bool:
	var cur := {}  # node idx on the current floor -> {mask: true}
	for i in map[0].size():
		var m := _route_mask_after(String(map[0][i]["type"]), 0)
		cur[i] = {m: true}
	for f in FLOORS - 1:
		var next := {}
		for i in cur:
			for j in map[f][int(i)]["links"]:
				var kind := String(map[f + 1][j]["type"])
				if not next.has(j):
					next[j] = {}
				for m in cur[i]:
					next[j][_route_mask_after(kind, int(m))] = true
		cur = next
	for i in cur:
		for m in cur[i]:
			if int(m) == 15:
				return true
	return false


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
# 1-11 with the boss on 11) as a continuous ramp (Batch T): the old three
# bands (3-6 / 6-9 / 10-12) put a cliff exactly at tier 4, and 40 of 50
# simulated wipes landed on it. Later zones restart the ladder with a
# tougher roster carrying higher base stats.
# Enemy stat scaling is zone-local (Batch 36): every zone replays the
# 1..11 tier ladder and its position in the run applies a flat base
# multiplier. Keyed by SLOT, not zone identity — the Forest of Old is
# x1.0 as the opener and x2.2 when revisited as the finale — and slots
# past the authored list continue the ~x1.5 step, so adding a 4th zone
# is data work, never formula work.
const ZONE_BASE_MULTS := [1.0, 1.5, 2.2]

# Alpha difficulty affordance (Batch Y): a TESTING lever, not a balance
# decision — Batch T still owns the numbers and nothing else in the game
# bends to accommodate this. "wanderer" exists so a competent tester can
# see all three zones and the finale; at standard numbers most alpha
# feedback would describe one third of the content. ONE multiplier folded
# into zone_base_mult — the single site battle spawn reads — so it is
# trivially removable when difficulty is actually decided. Chosen at the
# draft, saved with the run; sims arm it via DOD_SIM_DIFFICULTY (default
# standard) so it can never contaminate a baseline row.
const DIFFICULTY_MULTS := {"standard": 1.0, "wanderer": 0.7}
var difficulty := "standard"


func difficulty_mult() -> float:
	return float(DIFFICULTY_MULTS.get(difficulty, 1.0))


func zone_base_mult(slot: int) -> float:
	if slot <= ZONE_BASE_MULTS.size():
		return ZONE_BASE_MULTS[maxi(slot, 1) - 1] * difficulty_mult()
	return ZONE_BASE_MULTS[ZONE_BASE_MULTS.size() - 1] \
		* pow(1.5, slot - ZONE_BASE_MULTS.size()) * difficulty_mult()


func battle_budget(tier := -1) -> int:
	if tier <= 0:
		tier = floor_idx + 1
	tier = clampi(tier, 1, FLOORS)
	if tier >= FLOORS:
		# The boss node keeps its band: the Escort composition (boss 7 +
		# power 3-5 of company) is authored content, not the fight ladder.
		return randi_range(10, 12)
	var lo := 3 + int(floor((tier - 1) * 0.5))  # t1:3  t4:4  t7:6  t10:7
	return randi_range(lo, lo + 2)              # t1:3-5  t4:4-6  t10:7-9


func compose(node_type: String, tier := -1) -> Array:
	var budget := battle_budget(tier)
	# The ramp's tier-6 roll can dip to 5, but the cheapest elite theme
	# (Rage Company) needs 6 in every roster — below that an elite node
	# would silently degrade to the plain-mob fallback while still paying
	# elite rewards. Floor it; elite means elite.
	if node_type == "elite":
		budget = maxi(budget, 6)
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
	# Healers stack into walls (Batch V): cap mender-TAGGED kinds at 2 per
	# warband no matter which pool claimed them — a Grave Totem drawn
	# through a hexer pool still heals, and two heals plus a cleanse is a
	# wall rather than a question.
	var menders := 0
	for kind in picked:
		if Enemies.roles(kind).has("mender"):
			menders += 1
	if menders > 2:
		return false
	return true


func heal_party(pct: float) -> void:
	for member in party:
		if member["hp"] > 0:
			member["hp"] = mini(member["hp"] + int(member["max_hp"] * pct), member["max_hp"])


# Awakening HP sync (Batch T): spec stat blocks raise max HP, but the
# member snapshot keeps the class base until the first victory sync — the
# party entered its first specced fight at ~75% health. Raise current HP
# by the same amount as the max (never to full: matching the raise
# preserves any damage already taken). Both awakening paths call this —
# the spec-choice screen and the run sim's direct assignment.
func sync_spec_hp(idx: int) -> void:
	var member: Dictionary = party[idx]
	var spec := String(member.get("spec", ""))
	if spec == "" or not Classes.SPEC_INFO.has(spec):
		return
	var info: Dictionary = Classes.SPEC_INFO[spec]
	if not info.has("max_hp"):
		return
	var delta := int(info["max_hp"]) - int(member["max_hp"])
	if delta > 0 and int(member["hp"]) > 0:
		member["max_hp"] = int(info["max_hp"])
		member["hp"] = int(member["hp"]) + delta


# Resting restores spirit as well as flesh (Mage/Cleric mana pools).
func restore_mana(pct: float) -> void:
	for member in party:
		if member["key"] == "mage" or member["key"] == "cleric":
			member["mana"] = mini(member["mana"] + int(member["max_mana"] * pct), member["max_mana"])


func random_loot() -> String:
	return LOOT_POOL.pick_random()


# ---------- rune generation (shared by the Peddler and elite drops) ----------

# ---------- Batch AD: the two experiment arms (MEASUREMENT ONLY) ----------
#
# Three batches authored the rune pool and twice the measurement came back
# "the authored pool at current power does not move completions beyond
# noise". Two hypotheses were named and never separated: the entries are
# too WEAK, or they never ARRIVE (acquisition is ~0.55-0.7 runes per hero
# per run, out of the four written for that spec). These two flags move one
# variable each so the next measurement can tell them apart.
#
# NEITHER SHIPS AS A DEFAULT, and both are gated on `sim_run` as well as on
# the env var — that gate is the load-bearing half. DOD_SIM_RUNES and the
# other harness flags read the environment unconditionally, so a player
# with a stale export in their shell would silently be in an experiment
# arm; these two cannot be, because a real run never sets sim_run. Asserted
# in test_runes.gd, not just intended.
const RICH_SLOTS := 4  # DOD_SIM_RUNE_ECON=rich: every slot open from tier 1


# "rich" = acquisition raised, authored content untouched.
func rune_econ() -> String:
	if not sim_run:
		return "normal"
	return "rich" if OS.get_environment("DOD_SIM_RUNE_ECON") == "rich" else "normal"


# A blanket multiplier on authored rune magnitudes, acquisition untouched.
# 1.0 = off. Junk or non-positive values fall back to 1.0 rather than
# quietly zeroing every payload in the pool.
func rune_power() -> float:
	if not sim_run:
		return 1.0
	var raw := OS.get_environment("DOD_SIM_RUNE_POWER")
	if raw == "":
		return 1.0
	var m := raw.to_float()
	return m if m > 0.0 else 1.0


# Rune slots grow with the run: 2 in the first zone, 3 in the second, 4 in
# the third. No cap — a fourth zone would give 5, matching the
# ZONE_BASE_MULTS discipline (slots past the third continue formulaically).
# Derived from zone_idx, so saves need no new field.
# The slot ladder is a structural half of dilution — a run that dies in
# zone 2 never owned a third slot — so the rich arm opens them all at once.
func rune_slots() -> int:
	if rune_econ() == "rich":
		return maxi(RICH_SLOTS, 2 + zone_idx)
	return 2 + zone_idx

# Runes mode (sim matrix flag, Batch X): full = the authored pool
# (default), stats = the generated Common family only (approximately the
# pre-Batch-X behaviour), off = no runes generated, offered, or dropped.
func runes_mode() -> String:
	var m := OS.get_environment("DOD_SIM_RUNES")
	return m if m in ["off", "stats"] else "full"


# Takes the MEMBER dict (Batch X) so eligibility can read the spec, the
# trophies, and the owned pouch. Returns {} when runes are off — every
# call site skips empties. The pool lives in data/runes.json (Runes).
func generate_rune(member: Dictionary) -> Dictionary:
	match runes_mode():
		"off":
			return {}
		"stats":
			return Runes.template_rune(String(member["key"]))
	return _apply_rune_power(Runes.generate(member, zone_idx + 1))


# The single choke point for the power arm: generate_rune is the only path
# that turns an authored entry into a rune instance a hero can wear, so
# scaling here covers the Peddler, the elite cache and the rich arm's
# grants at once. Generated stat sticks (tpl_*) are NOT authored content
# and are deliberately left alone — the hypothesis under test is about the
# authored pool, and moving the filler family too would blur the arms.
func _apply_rune_power(rune: Dictionary) -> Dictionary:
	var mult := rune_power()
	if rune.is_empty() or is_equal_approx(mult, 1.0) \
			or String(rune.get("id", "")).begins_with("tpl_"):
		return rune
	rune["payload"] = Runes.scale_payload(rune["payload"], mult)
	return rune


# DOD_SIM_RUNE_ECON=rich: the crudest probe that answers "what happens when
# the runes actually arrive" — a spec-eligible authored rune handed over
# rather than shopped for. Prefers the four written for THIS spec, because
# those are the entries the dilution question is actually about; falls back
# to the ordinary roll when the spec's set is exhausted. Honours
# DOD_SIM_RUNES (nothing under off, stat sticks under stats) so the arms
# still compose with the Batch X matrix flag.
func grant_rune(member: Dictionary) -> Dictionary:
	if runes_mode() != "full":
		return generate_rune(member)
	var owned: Array = []
	for r in member.get("runes", []):
		owned.append(String(r["name"]))
	var spec_scope := "spec:%s" % String(member.get("spec", ""))
	var spec_ids: Array = []
	for id in Runes.eligible_ids(member, "", owned):
		if String(Runes.config(id).get("scope", "")) == spec_scope:
			spec_ids.append(id)
	if spec_ids.is_empty():
		return generate_rune(member)
	return _apply_rune_power(Runes.build(String(spec_ids.pick_random())))


# Elite pick-of-3 (Batch X): the three candidates are rolled AT DROP TIME
# and stored on the member — they never reroll on a screen open, and they
# ride the party dict into the save. Empty when runes are off.
func roll_rune_candidates(member: Dictionary) -> Array:
	var out: Array = []
	for i in 3:
		var rune := generate_rune(member)
		if rune.is_empty():
			return []
		for attempt in 4:
			if not out.any(func(c): return c["name"] == rune["name"]):
				break
			rune = generate_rune(member)
		out.append(rune)
	return out


# ---------- Batch AE: the starting rune ----------
#
# One pick of three per hero, dealt at SPEC CONFIRMATION rather than at the
# draft, and that is not a quibble: specs are chosen AFTER the draft, and
# the spec-scoped entries are the authored content that currently reaches
# nobody — a rune rolled before a hero has a spec cannot be one of them.
# Rolled through the ordinary roll_rune_candidates above, with its normal
# scope eligibility and rarity weights (zone slot 1 leans common, an
# appropriately modest opening gift), and resolved on the Party screen by
# the same trophy-picker the elite cache already uses. No new gear
# machinery exists in this batch.
#
# UNLIKE Batch AD's two arms this is SHIPPED CONTENT rather than an
# experiment, so it is ON by default and is NOT gated on sim_run.
# DOD_SIM_START_RUNE=off reproduces the pre-AE economy so control rows stay
# reachable; post-AE Matrix rows carry a start= field and pre-AE rows do
# not, which is the usual never-compare-across-batches rule.
func start_rune_enabled() -> bool:
	return OS.get_environment("DOD_SIM_START_RUNE") != "off"


# Deal every un-granted hero their opening pick; returns how many were
# dealt. The per-member marker is what makes "exactly once per run" a
# property of the SAVED DATA rather than of the call site — it rides inside
# the party dict, so a v5 save carries it with no version bump and no
# migration, and neither a resumed run nor the debug spec swap (which
# re-opens the spec screen) can ever deal a second one.
func grant_start_runes() -> int:
	if not start_rune_enabled():
		return 0
	var granted := 0
	for member in party:
		if bool(member.get("start_rune_granted", false)):
			continue
		var candidates: Array = roll_rune_candidates(member)
		if candidates.is_empty():
			continue  # DOD_SIM_RUNES=off — there is nothing to deal
		# The source rides on the candidates so the Party screen can name
		# the panel honestly when a start pick and an elite cache are owed
		# at the same time. It is a label, not a mechanism.
		for c in candidates:
			c["source"] = "start"
		member["start_rune_granted"] = true
		member["rune_candidates"] = member.get("rune_candidates", []) + [candidates]
		member["rune_picks_owed"] = int(member.get("rune_picks_owed", 0)) + 1
		granted += 1
	return granted


# Owed rune picks across the whole party. The map's Party button badge and
# its first-map nudge both read this — a pick sitting silently on the Party
# screen would defeat the point of choosing a front-loaded lever.
func owed_rune_picks() -> int:
	var n := 0
	for member in party:
		n += int(member.get("rune_picks_owed", 0))
	return n


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
	if not active or sim_run:
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	# v2 (Batch 38): + seen_events, zone_draw. v3 (Batch Y): + difficulty.
	# v4 (Batch Z): + tally (the run ledger). v5 (Batch AC): + debug_used
	# (the honesty flag). Loading stays tolerant of older saves via .get
	# defaults — never drop player state silently.
	# NOTE: a pre-Y save also keeps its old map (70% links, blind deal) —
	# correct, never migrated; nothing at runtime may assume the Batch Y
	# map guarantees hold on a loaded map.
	file.store_var({
		"version": 5, "party": party, "items": items, "gold": gold,
		"tally": tally, "debug_used": debug_used,
		"difficulty": difficulty,
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
	difficulty = String(data.get("difficulty", "standard"))
	if not DIFFICULTY_MULTS.has(difficulty):
		difficulty = "standard"
	seen_events = data.get("seen_events", [])
	# Pre-Z saves carry no ledger: start one mid-run rather than crash the
	# summary — its counts just begin at the load point.
	tally = data.get("tally", {})
	if tally.is_empty():
		reset_tally()
	# A pre-AC (v4) save loads with the honesty flag false — it predates
	# every tool that could have set it. The session-scoped toggles are
	# never saved, so a resumed run always resumes with them off.
	debug_used = bool(data.get("debug_used", false))
	debug_summon = false
	debug_free_travel = false
	pending_event = ""
	encounter = {}
	active = true
	return true


func clear_save() -> void:
	if sim_run:
		return
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
	tally_add("gold_earned", amount)
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
