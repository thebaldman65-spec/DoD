# Run-level state (autoload "Run"): the party, shared inventory, and the
# run's fixed line of slots. Persists across scene switches within one run.
extends Node

# Batch AN: A RUN IS A LINE, not a branching map. 3 zones x 12 slots = 36,
# and every zone has the IDENTICAL shape — so the player always knows what
# is coming and the run's decisions live in the offer screen (§3) rather
# than in route planning. Nothing is dealt, nothing is rolled: the shape
# below IS the zone.
#
# RETIRED WITH THE BRANCHING MAP (Batch Y/AH machinery, all deleted rather
# than left unreachable): FLOORS, NODES_PER_TIER, the deck composition
# constants FIGHT_NODES/REST_NODES/SHOP_NODES/EVENT_NODES, both
# DECK_FALLBACK tables, MINIBOSS_TIER, the rejection-sampling deal and its
# swap repair, the link graph, the edge-column adjacency rule (and with it
# the documented-70%/actual-53% bug — it needed no fix, it needed deleting),
# the inbound guarantee, and the forward-DP key-route check. ALL REST NODES
# go too; attrition is answered by the per-slot victory heal in §6 instead.
const SLOTS_PER_ZONE := 12
const ZONE_SHAPE := ["fight", "fight", "elite", "fight", "fight", "miniboss",
	"fight", "fight", "elite", "fight", "fight", "boss"]
# The boss of the LAST zone is the end boss: the run ends on its death.
const BOSS_SLOT := SLOTS_PER_ZONE - 1

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
# Batch AN §6: six of each item type, and that is the whole stack. A
# purchase or a drop above the cap is REFUSED with a message rather than
# swallowed — a reward that silently evaporates reads as a bug, and the
# shop must be able to grey the button rather than take the gold.
const ITEM_CAP := 6

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
# Batch AN: the line. map[slot] = {type, visited, enemies, theme} for the
# 12 slots of the CURRENT zone — one dict per slot, no columns and no
# links, because there is only ever one way forward.
var map: Array = []
var slot_idx := -1         # -1 = zone not entered; 0..11 = standing on that slot
var encounter := {}        # {"type": ..., "enemies": ["raider", ...]} for the next battle
var seen_events: Array = []  # event ids drawn this run (non-repeating pool)
# Batch AN §5: the merchant is scheduled, not always available. 40% after
# any cleared fight or elite slot, with a FLOOR — four cleared slots
# without a merchant and the next one is guaranteed. The counter is what
# makes the floor a property of the run rather than of a lucky streak, so
# it is saved.
var slots_since_merchant := 0
# The modifier the player accepted at the offer screen, live for exactly
# one battle (§3). Cleared when that battle resolves. Not saved: quitting
# between the offer and the fight forfeits the offer, and the slot is
# re-offered — the same shape as pending_event.
var pending_modifier := ""
var pending_reward := {}   # the reward the accepted option pays on victory
# Which hero the sheet opens onto (Batch AN: the map cards ARE the party
# list, so the sheet is always entered for a specific hero). Session-scoped
# — a resumed run opens the map, never a sheet.
var hero_screen_idx := 0
# §5/§7: what a cleared fight queued behind it — "shop" and/or "event", in
# the order they resolve. Rolled ONCE on the victory screen and popped by
# the screens, so a redraw can never re-roll the merchant and the four-slot
# drought floor stays meaningful. Saved: the queue is earned state, and a
# player who quits on the victory screen should still meet the merchant.
var pending_after: Array = []
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
			"talent_flex": 0, "talents": {}, "runes": []})
	items = {"health": 2, "mana": 1, "bomb": 1, "revive": 1, "defense": 1}
	for id in relic_dict("start_items"):
		items[id] = int(items.get(id, 0)) + int(relic_dict("start_items")[id])
	# Relic start_items can push a stack past the cap on its own.
	for id in items:
		items[id] = mini(int(items[id]), ITEM_CAP)
	gold = 60 + int(relic_add("start_gold"))
	combat_wins = 0
	zone_idx = 0
	draw_zones()
	_enter_zone()
	slot_idx = -1
	slots_since_merchant = 0
	encounter = {}
	seen_events = []
	pending_event = ""
	pending_modifier = ""
	pending_reward = {}
	pending_after = []
	# A fresh run starts clean, and starts un-summoned and un-travelled.
	debug_used = false
	debug_summon = false
	debug_free_travel = false
	reset_tally()
	_generate_map()


# ---------- the line (Batch AN) ----------

# One zone = the authored shape, in order. There is no deal, no shuffle, no
# rejection sampling and no fallback table, because there is nothing left to
# fail: every zone is the same twelve slots, and a slot's only variable is
# the warband standing on it.
func _generate_map() -> void:
	map = []
	for s in SLOTS_PER_ZONE:
		var slot := {"type": String(ZONE_SHAPE[s]), "visited": false}
		# Warbands are pre-rolled at map birth, exactly as the branching map
		# did it: every slot carries its enemies + theme, so hovering a dot can
		# show what resists what BEFORE the player commits. Scouting resists is
		# counterplay, not a spoiler.
		slot["enemies"] = compose(String(slot["type"]), s + 1)
		slot["theme"] = last_theme
		map.append(slot)


# The slot the player may enter next: always exactly one, and none once the
# boss is behind them. Still an Array, because that is the shape the map
# screen and the sim already iterate — a line is a graph with one edge.
func reachable() -> Array:
	if slot_idx + 1 >= SLOTS_PER_ZONE:
		return []
	return [slot_idx + 1]


func advance(slot: int) -> void:
	slot_idx = slot
	map[slot]["visited"] = true


func slot_type(slot: int) -> String:
	if slot < 0 or slot >= map.size():
		return ""
	return String(map[slot]["type"])


# Where the party stands in the WHOLE run, 1-36 — the readout the zone
# header and the run summary both want. 0 before the first slot is entered.
func run_slot_number() -> int:
	if slot_idx < 0:
		return zone_idx * SLOTS_PER_ZONE
	return zone_idx * SLOTS_PER_ZONE + slot_idx + 1


# The end boss is the last zone's boss and nothing else. Every other boss
# opens the next zone.
func is_end_boss_slot(slot: int) -> bool:
	return slot == BOSS_SLOT and not has_next_zone()


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


# The tier is the SLOT NUMBER now (1-12), not a dealt row. The continuous
# ramp Batch T fitted is kept byte-for-byte — it was fitted against slot
# DEPTH, and a line is nothing but depth — so slot 12's boss band and the
# t1:3-5 opening are exactly what they were.
func battle_budget(tier := -1) -> int:
	if tier <= 0:
		tier = slot_idx + 1
	tier = clampi(tier, 1, SLOTS_PER_ZONE)
	if tier >= SLOTS_PER_ZONE:
		# The boss slot keeps its band: the Escort composition (boss 7 +
		# power 3-5 of company) is authored content, not the fight ladder.
		return randi_range(10, 12)
	var lo := 3 + int(floor((tier - 1) * 0.5))  # t1:3  t4:4  t7:6  t11:8
	return randi_range(lo, lo + 2)              # t1:3-5  t4:4-6  t11:8-10


func compose(node_type: String, tier := -1) -> Array:
	var budget := battle_budget(tier)
	# The ramp's tier-6 roll can dip to 5, but the cheapest elite theme
	# (Rage Company) needs 6 in every roster — below that an elite node
	# would silently degrade to the plain-mob fallback while still paying
	# elite rewards. Floor it; elite means elite.
	if node_type in ["elite", "miniboss"]:
		budget = maxi(budget, 6)
	# The mini-boss draws from the ELITE themes (Batch AH: "elite stats with
	# a boss-tier health pool" — the composition is an elite's, and the
	# health multiplier that makes it a mini-boss is applied at spawn).
	var theme_key := "elite" if node_type == "miniboss" else node_type
	var candidates: Array = []
	for theme_name in THEMES:
		if THEMES[theme_name]["nodes"].has(theme_key):
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


# Batch AN §9: THREE SLOTS, FLAT, FROM RUN START. The 2/3/4 growth ladder
# is gone — it was a structural half of rune dilution (a run that died in
# zone 2 never owned a third slot), and with the line the growth is one
# fewer moving part between the player and a build they can plan. Heroes
# still begin with NO runes; the slots start empty.
func rune_slots() -> int:
	if rune_econ() == "rich":
		return RICH_SLOTS
	return 3

# Runes mode (sim matrix flag, Batch X): full = the authored pool
# (default), stats = the generated Common family only (approximately the
# pre-Batch-X behaviour), off = no runes generated, offered, or dropped.
func runes_mode() -> String:
	var m := OS.get_environment("DOD_SIM_RUNES")
	return m if m in ["off", "stats"] else "full"


# Takes the MEMBER dict (Batch X) so eligibility can read the spec, the
# trophies, and the owned pouch. Returns {} when runes are off — every
# call site skips empties. The pool lives in data/runes.json (Runes).
# exclude_names: names this draw may not return even though the hero does
# not own them — the candidates already in the triple being rolled. Empty
# for every ordinary single-rune caller (shop, elite cache), so their
# behaviour is untouched.
func generate_rune(member: Dictionary, exclude_names: Array = []) -> Dictionary:
	match runes_mode():
		"off":
			return {}
		"stats":
			return Runes.template_rune(String(member["key"]), "", "", exclude_names)
	return _apply_rune_power(Runes.generate(member, zone_idx + 1, exclude_names))


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
#
# BATCH AN deleted the `guarantee_spec` parameter along with Batch AF's
# starting rune: it had exactly one caller (the opening pick) and nothing
# else ever passed true, so with the opening pick gone the flag was a
# parameter no reachable path could set. `_generate_spec_rune`,
# `start_rune_enabled`, `spec_opening_enabled` and `grant_start_runes` went
# with it — heroes now begin with no runes and three empty slots.
func roll_rune_candidates(member: Dictionary) -> Array:
	var out: Array = []
	while out.size() < 3:
		# Draw WITHOUT REPLACEMENT: everything already in the triple is
		# excluded from the pool this draw picks out of, so a duplicate is
		# not merely unlikely, it is unreachable. (This used to roll and
		# retry four times on a collision and then append the fourth
		# result unchecked — which on a small per-rarity pool emitted the
		# same rune twice roughly one triple in a hundred.)
		var taken: Array = []
		for c in out:
			taken.append(String(c["name"]))
		var rune := generate_rune(member, taken)
		if rune.is_empty():
			return []
		out.append(rune)
	return out


# Owed rune picks across the whole party. The hero cards badge on this —
# a pick sitting silently behind a click is the failure the badge exists to
# prevent.
func owed_rune_picks() -> int:
	var n := 0
	for member in party:
		n += int(member.get("rune_picks_owed", 0))
	return n


# Ability picks (zone bosses) waiting to be chosen, across the party.
func owed_ability_picks() -> int:
	var n := 0
	for member in party:
		n += int(member.get("bm_picks_owed", 0))
	return n


# Every ability display name the hero can already cast: core kit + spec kit
# + kit-override renames + earned picks, PLUS anything a learned talent node
# grants. Without the talent half a Berserker who bought Battle Shout in the
# tree could be offered it again as a pick that does nothing.
# THE implementation lives in Talents.ability_names (Batch AI) so a node's
# `condition` can read it — autoload identifiers do not resolve inside a
# class_name script, so the list had to live on the class side of the fence.
# This stays as the name every screen already calls.
func owned_ability_names(member: Dictionary) -> Array:
	return Talents.ability_names(member)


# Queue one ability award on a hero: the offer is rolled NOW and stored, so
# the pick waiting on the hero card is the pick that dropped. Returns false
# when nothing is left to offer (spec pool exhausted, or no spec).
#
# BATCH AN §4 re-pointed this at the SPEC POOL ONLY — the 1-spec-plus-2-class
# draw Batch AH built is dropped, because abilities are spec-locked now.
# `Classes.CLASS_POOLS` / `class_pool()` are left standing and still resolve;
# nothing in the run reads them any more, so re-opening the class draw is a
# one-line change if the designer wants it back.
func award_ability_pick(member: Dictionary) -> bool:
	var offer := roll_spec_ability_offer(member)
	if offer.is_empty():
		return false
	member["bm_candidates"] = member.get("bm_candidates", []) + [offer]
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) + 1
	return true


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
	slot_idx = -1
	encounter = {}
	pending_modifier = ""
	pending_reward = {}
	pending_after = []
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
	# (the honesty flag). v6 (Batch AI): the ROW tree — members carry
	# talent_flex and no talent_order, and anything older has its tree wiped
	# and its points re-issued on load (_migrate_trees). Loading stays
	# tolerant of older saves via .get defaults — never drop player state
	# silently.
	# v7 (Batch AN): the LINE. `map` is a flat 12-slot array and the party's
	# position is one `slot_idx` — a pre-v7 save holds a [tier][column] board
	# with links, rest nodes and a mini-boss row, and there is no honest way
	# to place a party standing at tier 7 column 2 onto a line that no longer
	# has columns. Those saves are REFUSED and cleared on load (see
	# load_run), which is the same call Batch AI made about ranked talent
	# purchases: a wipe that says so beats a migration that invents state.
	file.store_var({
		"version": 7, "party": party, "items": items, "gold": gold,
		"tally": tally, "debug_used": debug_used,
		"difficulty": difficulty,
		"zone_idx": zone_idx, "zone_name": zone_name, "zone_draw": zone_draw,
		"slot_idx": slot_idx, "seen_events": seen_events,
		"slots_since_merchant": slots_since_merchant,
		"pending_after": pending_after,
		"specs_chosen": specs_chosen,
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
	var save_version := int(data.get("version", 0))
	# Batch AN: a pre-v7 save describes a board this build cannot render or
	# walk. Refuse it and delete it, rather than half-loading a run whose
	# every "next node" call would index a dictionary that is not there.
	if save_version < 7:
		clear_save()
		return false
	party = data["party"]
	items = data["items"]
	gold = data["gold"]
	zone_idx = data["zone_idx"]
	zone_name = data["zone_name"]
	zone_draw = data.get("zone_draw", [])
	if zone_draw.is_empty():
		# Saves from before zone rotation ran the fixed order.
		for slot in SLOT_COUNT:
			zone_draw.append(SLOT_POOLS[slot][0])
	slot_idx = int(data["slot_idx"])
	slots_since_merchant = int(data.get("slots_since_merchant", 0))
	pending_after = data.get("pending_after", [])
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
	_migrate_trees()
	# A pre-AC (v4) save loads with the honesty flag false — it predates
	# every tool that could have set it. The session-scoped toggles are
	# never saved, so a resumed run always resumes with them off.
	debug_used = bool(data.get("debug_used", false))
	debug_summon = false
	debug_free_travel = false
	pending_event = ""
	pending_modifier = ""
	pending_reward = {}
	encounter = {}
	active = true
	return true


# Trees are FIXED definitions in code: always swap the saved snapshot for
# the live tree so balance edits reach old saves.
#
# Batch AN dropped the pre-Batch-AI branch that used to live here: only v7
# saves reach this function now (load_run refuses anything older), and every
# v7 save was written by a build whose trees are already rows. Ranks carry,
# and points in nodes that shrank or vanished are refunded.
func _migrate_trees() -> void:
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


func clear_save() -> void:
	if sim_run:
		return
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)


func award_gold(node_type: String) -> int:
	# Batch AO §2: a plain fight no longer charges a modifier for its pay, so
	# the eight bargains a zone lost are covered here — deliberately BELOW the
	# old bargain payout, because the fight is now unconditional.
	var amount := randi_range(45, 60)
	match node_type:
		"elite", "miniboss":
			# Elites pay out hard — seeking them out is how skilled players snowball.
			# The mini-boss matches them: its own spoil is the ability pick.
			amount = randi_range(80, 100)
		"boss":
			amount = randi_range(110, 130)
	amount = int(round(amount * (1.0 + relic_add("gold_find_mult"))))
	gold += amount
	tally_add("gold_earned", amount)
	return amount


# Combat rewards, Batch AN §8: points come from ELITES, MINI-BOSSES and
# BOSSES only, one apiece. Regular fights award none.
#   elite       1   x2 per zone
#   mini-boss   1   x1 per zone
#   zone boss   1   x1 per zone   (the END boss pays one too — see below)
#   fight       0
# = 4 per zone, 12 per run, against an 8-node tree.
#
# ONE PURSE, and that is the change from Batch AI. AI split elite points
# into a separate `talent_flex` because 8 points against an 8-node tree left
# no room for a second node in a row — a normal point had to be barred from
# buying one or the tree could be climbed faster. At 12 against 8 the SHAPE
# does the barring instead: rows are mutually exclusive and there are only
# eight of them, so a purse of 12 can open at most 8 rows and the surplus
# has nowhere to go BUT second nodes. That is §8's "the 4 surplus buy row
# flexibility exactly as Batch AI §6 already allows", arrived at by
# arithmetic rather than by a second wallet. `talent_flex` survives as a
# purse that is spent FIRST when it holds anything (old saves, and any
# future relic that wants to grant flexibility without granting climb).
#
# NOTE FOR THE DESIGNER: the awakening's own point (award_spec_point, Batch
# AI) is UNCHANGED and still paid, so the real total is 13 and the surplus
# is 5, not 4. §8 enumerates SLOT types and the awakening is not a slot, so
# it was left standing rather than silently deleted — removing it would push
# the first talent pick from "the moment you choose a spec" out to slot 3,
# which is a live design decision this batch does not ask for.
func award_talent_points(node_type: String) -> int:
	var pts := 1 if node_type in ["elite", "miniboss", "boss"] else 0
	if pts > 0:
		for member in party:
			member["talent_points"] = member.get("talent_points", 0) + pts
	return pts


# The point the awakening pays, granted the moment a spec is confirmed —
# from BOTH paths (the spec screen and RunSim.start_run), the sync_spec_hp
# pattern. Row 1 is open from the start, so this is the point that lets the
# player act on the choice they just made.
func award_spec_point(idx: int) -> void:
	if idx < 0 or idx >= party.size():
		return
	party[idx]["talent_points"] = int(party[idx].get("talent_points", 0)) + 1


# ---------- Batch AN §6: the item cap ----------

# Every grant of a consumable goes through here. Returns how many actually
# landed, so the caller can say "refused" instead of pretending. The cap is
# per ITEM TYPE, not per pouch: six Health Potions and six Bombs is legal.
func add_item(id: String, count := 1) -> int:
	var have := int(items.get(id, 0))
	var room := maxi(ITEM_CAP - have, 0)
	var landed := mini(count, room)
	if landed > 0:
		items[id] = have + landed
	return landed


func item_full(id: String) -> bool:
	return int(items.get(id, 0)) >= ITEM_CAP


# ---------- Batch AN §3: the offer ----------
#
# Before every FIGHT and ELITE slot the player is shown three options and
# picks one. Each option is one MODIFIER plus one REWARD, both visible
# before choosing, and the reward is read off the modifier's SEVERITY —
# authoring a modifier is therefore authoring one number, not a pairing.
#
# SEVERITY IS FLAT and deliberately ignores party composition. A modifier
# that happens to be cheap for your build is a good deal you EARNED by
# building that way; a severity that read the party would quietly tax every
# build for being good at something.
#
# BATCH AQ AUTHORED THE POOL — 6 placeholders became 19, and the six
# originals are untouched (ids, severities and text all stand, so a save mid-
# run with a pending modifier still resolves).
#
# THE POOL IS WEIGHTED LOW, DELIBERATELY. Every offer's first draw comes from
# the severity 1-2 pool, so the safe slot on every card all run is served by
# that pool alone; the harsh end already rotates and the low end is what
# actually repeats. Counts: 6 / 6 / 4 / 4 across severities 1-4.
#
# SEVERITY 4 IS FOUR AGAIN (Batch BB §5). `rot` — maximum health halved for
# everyone — was authored by AQ, implemented, and DROPPED there: the battle-end
# save sync writes `heroes[i].max_hp` straight back onto the party member, so a
# HALVED maximum survived the fight that charged for it and would have cost the
# party half its health for the rest of the run. AQ recorded the fix it needed
# (one field, added back at the victory sync) and Batch AW then BUILT EXACTLY
# THAT PATTERN FOR THE OPPOSITE SIGN — `conviction_hp_gained` accumulates growth
# and the sync subtracts it. `rot_hp_lost` accumulates the reduction and the
# sync ADDS it back. Both victory syncs carry all three fields now, and the
# ordering is stated at each of them because this is the site with a five-figure
# max-HP runaway in its history (Batch W).
const MODIFIERS := {
	"overgrown": {"name": "Overgrown", "severity": 1,
		"desc": "Both parties begin the fight at 70% health."},
	"tinderbox": {"name": "Tinderbox", "severity": 2,
		"desc": "All fire damage +25%, whoever deals it."},
	"frenzied": {"name": "Frenzied", "severity": 2,
		"desc": "Everyone acts 30% faster. Cooldowns are unchanged."},
	"brittle": {"name": "Brittle", "severity": 3,
		"desc": "All attacks ignore armor, on both sides."},
	"warded": {"name": "Warded", "severity": 3,
		"desc": "All abilities cost 25% more. Basic attacks are free."},
	"bloodless": {"name": "Bloodless", "severity": 4,
		"desc": "No healing for anyone. Bleed and damage-over-time still tick."},
	# ---- severity 1 (Batch AQ) ----
	"parched": {"name": "Parched", "severity": 1,
		"desc": "Both parties begin the fight at half resource."},
	"slick": {"name": "Slick Footing", "severity": 1,
		"desc": "Every ability costs +0.5 initiative. Everyone is slower to come round again."},
	"dulledge": {"name": "Dull Edge", "severity": 1,
		"desc": "Critical chance is halved, for everyone."},
	"muffled": {"name": "Muffled", "severity": 1,
		"desc": "All Break damage is reduced 25%. Meters fill slowly."},
	"hoarfrost": {"name": "Hoarfrost", "severity": 1,
		"desc": "Everyone begins the fight Chilled."},
	# ---- severity 2 (Batch AQ) ----
	"fleeting": {"name": "Fleeting", "severity": 2,
		"desc": "Every status applied lasts one turn less (never below one)."},
	"feverish": {"name": "Feverish", "severity": 2,
		"desc": "Everyone deals 25% more damage. Fights end quickly, one way or the other."},
	"deadened": {"name": "Deadened", "severity": 2,
		"desc": "Nobody can be Broken. The Break meter does nothing this fight."},
	"miasma": {"name": "Miasma", "severity": 2,
		"desc": "All healing received is halved."},
	# ---- severity 3 (Batch AQ) ----
	"thinair": {"name": "Thin Air", "severity": 3,
		"desc": "No resource returns at the start of a turn. What you have is what you get."},
	"encumbered": {"name": "Encumbered", "severity": 3,
		"desc": "Every ability with a cooldown costs two more turns of it. Basic attacks are unaffected."},
	# ---- severity 4 (Batch AQ) ----
	"bloodletting": {"name": "Bloodletting", "severity": 4,
		"desc": "Every hit opens a wound. All attacks add 15 Bleed, on both sides."},
	"mirrorbound": {"name": "Mirrorbound", "severity": 4,
		"desc": "A quarter of the damage you deal comes back on you."},
	# ---- severity 4 (Batch BB §5, AQ's authored fourth) ----
	"rot": {"name": "Rot", "severity": 4,
		"desc": "Everyone's maximum health is halved, on both sides. It lasts the fight and no longer."},
}

# The reward table reads severity and nothing else. Each entry is the list
# of reward KINDS that severity may pay; the offer picks one at random, so
# a severity-4 option is sometimes gold and sometimes the merchant.
#   gold   {amount}      flat gold on victory
#   potion {}            one random consumable
#   rune   {}            one rune from the current pool, for a random hero
#   shop   {}            a merchant follows the fight (the §5 on-demand path)
const REWARDS := {
	1: [{"kind": "gold", "amount": 40}],
	2: [{"kind": "gold", "amount": 80}, {"kind": "potion"}],
	3: [{"kind": "gold", "amount": 140}, {"kind": "rune"}],
	4: [{"kind": "gold", "amount": 220}, {"kind": "rune"}, {"kind": "shop"}],
}


func modifier_name(id: String) -> String:
	return String(MODIFIERS.get(id, {}).get("name", ""))


func modifier_severity(id: String) -> int:
	return int(MODIFIERS.get(id, {}).get("severity", 0))


func reward_text(reward: Dictionary) -> String:
	match String(reward.get("kind", "")):
		"gold":
			return "%d gold" % int(reward.get("amount", 0))
		"potion":
			return "A random potion"
		"rune":
			return "A random rune"
		"shop":
			return "A merchant follows the fight"
	return ""


# Three distinct modifiers, each paired with one reward its severity allows.
#
# THE FLOOR IS THE POINT: every offer holds at least one option of severity
# 1 or 2, so a party down to its last few HP always has a survivable choice.
# It is enforced by CONSTRUCTION (the first draw comes from the low pool)
# rather than by rejecting rolls, so it cannot fail on an unlucky table.
#
# BATCH AQ §2: the other two slots come from the severity 3-4 pool ALONE.
# They used to draw from low + high together, which was tolerable at six
# modifiers and would not have been at nineteen — twelve of them low, so most
# offers would have come out as three cheap options paying three cheap
# rewards. The pool would have got deeper and the decision blander. Filling
# from the high pool makes every offer read the same way: ONE SAFE OPTION,
# TWO GAMBLES. The floor still guarantees the safe one, so a wounded party is
# never cornered.
func roll_offer() -> Array:
	var low: Array = []
	var rest: Array = []
	for id in MODIFIERS:
		if modifier_severity(String(id)) <= 2:
			low.append(String(id))
		else:
			rest.append(String(id))
	low.shuffle()
	rest.shuffle()
	var picked: Array = []
	if not low.is_empty():
		picked.append(low.pop_front())
	while picked.size() < 3 and not rest.is_empty():
		picked.append(rest.pop_front())
	# Only if the high pool cannot fill the card — it holds seven and needs to
	# supply two, so this is a guard, not a path. An offer short of three
	# options would be worse than a second low one.
	while picked.size() < 3 and not low.is_empty():
		picked.append(low.pop_front())
	var offer: Array = []
	for id in picked:
		var sev := modifier_severity(String(id))
		var choices: Array = REWARDS.get(sev, REWARDS[1])
		offer.append({"modifier": String(id),
			"reward": (choices.pick_random() as Dictionary).duplicate()})
	offer.shuffle()
	return offer


# The accepted option, armed for the battle about to start.
func accept_offer(option: Dictionary) -> void:
	pending_modifier = String(option.get("modifier", ""))
	pending_reward = (option.get("reward", {}) as Dictionary).duplicate()


# Pay the accepted option's reward. Called on VICTORY — the modifier is the
# price and the reward is what clearing it under that price bought, which is
# also the only reading the "a merchant follows the fight" reward supports.
# Returns the human line the victory screen prints, and whether a merchant
# is owed.
func claim_reward() -> Dictionary:
	var reward := pending_reward
	pending_reward = {}
	pending_modifier = ""
	if reward.is_empty():
		return {"text": "", "shop": false}
	match String(reward.get("kind", "")):
		"gold":
			var amount := int(round(int(reward.get("amount", 0))
				* (1.0 + relic_add("gold_find_mult"))))
			gold += amount
			tally_add("gold_earned", amount)
			return {"text": "+%d gold (the bargain)" % amount, "shop": false}
		"potion":
			var id: String = random_loot()
			if add_item(id) < 1:
				return {"text": "The bargain offered a %s — the party is already carrying six."
					% ITEM_INFO[id][0], "shop": false}
			return {"text": "+1 %s (the bargain)" % ITEM_INFO[id][0], "shop": false}
		"rune":
			var looter: Dictionary = party.pick_random()
			var candidates: Array = roll_rune_candidates(looter)
			if candidates.is_empty():
				return {"text": "", "shop": false}  # runes off
			looter["rune_candidates"] = looter.get("rune_candidates", []) + [candidates]
			looter["rune_picks_owed"] = int(looter.get("rune_picks_owed", 0)) + 1
			return {"text": "RUNE (the bargain): the %s may choose one of three."
				% String(looter["key"]).capitalize(), "shop": false}
		"shop":
			# Guaranteed on demand — and it resets the §5 drought counter,
			# because the party HAS just seen a merchant.
			slots_since_merchant = 0
			return {"text": "A merchant follows the fight.", "shop": true}
	return {"text": "", "shop": false}


# ---------- Batch AN §5 and §7: what follows a cleared slot ----------

const MERCHANT_CHANCE := 0.40
const MERCHANT_FLOOR := 4    # cleared slots without one before it is forced
const EVENT_CHANCE := 0.25


# Rolls the merchant for a just-cleared FIGHT or ELITE slot. The floor is
# checked BEFORE the roll, so four dry slots guarantee the fifth rather than
# merely improving its odds.
func roll_merchant(node_type: String) -> bool:
	if not node_type in ["fight", "elite"]:
		return false
	if slots_since_merchant >= MERCHANT_FLOOR or randf() < MERCHANT_CHANCE:
		slots_since_merchant = 0
		return true
	slots_since_merchant += 1
	return false


func roll_event(node_type: String) -> bool:
	return node_type in ["fight", "elite"] and randf() < EVENT_CHANCE


# THE one place that answers "where does the party go when this screen is
# done". Pops the next queued interstitial and returns its scene, or the map
# when the queue is empty. Shop and event both call it on leave, so a fight
# that rolled both resolves shop -> event -> map without either screen
# knowing the other exists.
func next_after_scene() -> String:
	while not pending_after.is_empty():
		var next := String(pending_after[0])
		pending_after = pending_after.slice(1)
		if next == "shop":
			return "res://scenes/shop.tscn"
		if next == "event":
			pending_event = Events.pick(self)
			if pending_event == "":
				continue  # nothing eligible right now — try the next entry
			seen_events.append(pending_event)
			Profile.note_event(pending_event)
			return "res://scenes/event.tscn"
	return "res://scenes/map.tscn"


# ---------- Batch AN §6: attrition ----------

# Clearing ANY slot heals the party this much. It rides the SAME
# `victory_heal_pct` hook the Chalice of Dawn already uses rather than a new
# one, so the relic's 10% stacks on top for 25% and there is still exactly
# one read site for "how much does a victory heal".
const SLOT_HEAL_PCT := 0.15


func victory_heal_pct() -> float:
	return SLOT_HEAL_PCT + relic_add("victory_heal_pct")


# ---------- Batch AN §4: the mini-boss ability upgrade ----------
#
# A generic upgrade attaches to ONE ability the hero already owns and makes
# it better. Upgrades STACK on the same ability (two different upgrades on
# Overpower is legal) but the SAME upgrade cannot be taken twice in a run —
# a run of "+50% damage" three times over is a number, not a decision.
#
# A POOL OF EIGHT since Batch BH (it opened at four). Stored on the
# member as `upgrades` = [{id, ability}], and READ AT BATTLE SPAWN by
# `apply_upgrades` below (Batch AP — before that the pick was recorded and
# nothing acted on it).
#
# THE OFFER NOW DRAWS THREE FROM EIGHT RATHER THAN THREE FROM FOUR, so any
# given upgrade appears about half as often. That is the point — variety
# across runs — but it also means A HERO CAN FINISH A RUN HAVING BEEN OFFERED
# A POOL THAT NEVER INCLUDED THE ONE THEIR BUILD WANTED. That is correct for a
# roguelike, not a bug, and the changelog says so.
#
# TWO DESCRIPTIONS WERE CORRECTED IN BATCH AP, because they were authored
# before anything read them and both named the wrong thing:
#   Effortless zeroes `cost` ONLY and never `faith_cost` — Mercy is the Holy
#   Cleric's identity resource and a free Resurrection is a different game.
#   Swift was written as "+2 initiative speed", but delays across the whole
#   roster run 1.5-4.0, so subtracting 2 would take most abilities to
#   near-zero. It is a 25% cut floored at 1.0 instead — the one balance
#   judgement in that batch, flagged rather than buried.
# BATCH BH §1 — THE POOL GOES FROM FOUR TO EIGHT. The recorded ceiling is
# about eight and eight is the TARGET, not a step toward twelve: a hero draws
# three upgrades a run, so a pool much past eight stops being felt as a reward.
#
# The four originals move damage, cooldown, cost and delay. The four new ones
# were chosen for axes those do not touch — Break, breadth, armor and status
# reliability — so a SECOND upgrade on the same ability is far more likely to
# mean something. Every existing rule is unchanged: AP's eligibility filter,
# the never-twice-per-run rule, the stack-on-one-ability rule, application
# AFTER `Talents.apply_from_tree`, and AU §1's use of the pool as the generic
# talent fallback.
#
# THREE CORRECTIONS TOWARD THE CODE, because the brief named fields the game
# does not have or does not use. Each is reported rather than forced:
#
#   1. THE BRIEF'S `bd` IS `pressure`. Break damage on an Ability has always
#      lived in `Ability.pressure`; there is no `bd` field. Weighted doubles
#      `pressure` and its eligibility reads it.
#
#   2. WIDENED DOES NOT ACCEPT `aoe`, AND THAT IS AP §3's OWN RULE. An `aoe`
#      ability already strikes EVERY living enemy, so there is no additional
#      target to add — Widened on Blizzard would read as a reward and do
#      nothing, which is exactly the dud the eligibility filter exists to
#      prevent. It fits `random_hits`/`multi_hits` alone.
#
#   3. NO HERO ABILITY IN THE GAME SETS `status_chance` BELOW 1.0 — the only
#      writers are enemy kits in data/enemies.json, which no upgrade can ever
#      reach. On its authored eligibility Certain would have been a pool entry
#      that could never be offered. THE RELIABILITY AXIS THE HERO ROSTER
#      ACTUALLY HAS IS `bleed_chance` (Hack and Slash and Wildstrikes both roll
#      0.5, and the Relentless talent exists to buy exactly this), so Certain
#      covers both fields: the axis the brief asked for, through the door the
#      game actually has.
#
# AND ONE REPLACEMENT, on the brief's own instruction. `up_sure` (Sure — "the
# Perfect window on its skill check is doubled") WAS NOT WRITTEN. §1 required
# the window to be verified as a readable value at its site first, and it is
# not: `PERFECT_HALF` is a bare script constant in battle.gd read at exactly
# two places — `_grade_skill_check()`, which takes no arguments and cannot see
# which ability is being cast, and the perfect-zone ColorRect built once during
# UI setup. It is a fixed fraction shared by every ability and every hero, not
# a parameter. Worse, the bot never runs the bar at all (it rolls a grade off
# hardcoded probabilities), so a widened window would be invisible to every
# instrument the project owns and its worth could never be reported. PIERCING
# takes the slot instead: armor is an axis nothing else in the pool touches,
# and "the number lands against less" composes with Honed rather than
# duplicating it.
const ABILITY_UPGRADES := {
	"up_damage": {"name": "Honed", "desc": "+50% damage."},
	"up_cooldown": {"name": "Quickened", "desc": "-2 turns cooldown (minimum 0)."},
	"up_free": {"name": "Effortless",
		"desc": "Costs no Rage / Mana / Focus (Mercy is unaffected)."},
	"up_speed": {"name": "Swift", "desc": "Arrives 25% sooner."},
	"up_break": {"name": "Weighted", "desc": "Break damage doubled."},
	"up_wide": {"name": "Widened",
		"desc": "Strikes one additional target, or lands one additional hit."},
	"up_pierce": {"name": "Piercing",
		"desc": "Ignores half the target's armor (on top of any it already pierced)."},
	"up_certain": {"name": "Certain", "desc": "Its status application always lands."},
}

# THE ORDER THE GENERIC TALENT FALLBACK PICKS IN (Batch AU §1): Honed,
# Quickened, Effortless, Swift — first one that FITS the ability and is not
# already on it. A Dictionary's key order is stable in GDScript, but the
# fallback's priority is a DESIGN decision rather than an authoring accident,
# so it is written down separately and the test asserts both lists agree.
#
# BATCH BH §1 — THE FOUR NEW ONES GO AFTER THE FOUR OLD ONES, AND THAT IS A
# COMPATIBILITY SURFACE RATHER THAN A PREFERENCE. This list is what every
# ability-granting talent node falls back on when its grant collides with an
# already-owned copy, so a node that granted Honed yesterday must grant Honed
# today. Appending keeps every existing fallback byte-identical; inserting
# anywhere else would silently re-point nine live nodes.
const UPGRADE_PRIORITY := ["up_damage", "up_cooldown", "up_free", "up_speed",
	"up_break", "up_wide", "up_pierce", "up_certain"]


# Does this upgrade have anything to change on this ability? An upgrade
# offered on an ability it cannot touch (Honed on Heal, Effortless on a
# 0-cost basic) reads as a reward and does nothing, which is the whole bug
# the wiring exists to close. Swift is the one that fits everything —
# every ability has a delay.
func upgrade_fits(id: String, ab: Ability) -> bool:
	match id:
		"up_damage":
			return ab.damage > 0
		"up_cooldown":
			return ab.cooldown > 0
		"up_free":
			return ab.cost > 0
		"up_break":
			# `pressure` IS Break damage — there is no `bd` field.
			return ab.pressure > 0
		"up_wide":
			# `aoe` is deliberately absent: it already hits every living enemy.
			return ab.random_hits > 0 or ab.multi_hits > 0
		"up_pierce":
			# Armor only matters to a hit that deals damage, and an ability
			# already piercing everything has nothing left to take.
			return ab.damage > 0 and ab.armor_pierce < 1.0
		"up_certain":
			# Either reliability roll, and NEITHER when it is already a
			# certainty — a guaranteed status offered "Certain" is the dud.
			return (not ab.applies_status.is_empty() and ab.status_chance > 0.0 \
					and ab.status_chance < 1.0) \
				or (ab.bleed_build > 0 and ab.bleed_chance < 1.0)
	return true


# Stamp every upgrade this hero has taken onto the matching ability in an
# ASSEMBLED kit, and return {ability name: [upgrade names]} of what actually
# landed — the battle tooltip names upgrades off that return, so it can only
# ever advertise an upgrade that really applied.
#
# CALLED FROM EXACTLY TWO SITES, the two that assemble a kit: the hero spawn
# in battle.gd and the sheet assembly in party_screen.gd. (RunSim reloads the
# battle scene, so it inherits the battle.gd site and needs no third call.)
#
# ORDER IS LOAD-BEARING: this runs AFTER `Talents.apply_from_tree` and after
# the equipped-rune pass, never before. Several talents SET an ability field
# rather than add to it — the Resonant Hymn node sets Hymn of Hope's cost to
# 25 — so an Effortless applied first would be silently overwritten by the
# talent. Upgrades go last, so they always win.
#
# An entry naming an ability the hero no longer holds is skipped in silence:
# it can happen across a spec reroll and is not an error.
#
# BATCH AU §1: `talent_fallbacks` is the list of ability names whose TREE NODE
# collided with an already-owned copy (recorded by Talents at the grant site,
# passed straight through from the cfg). Each one takes the highest-priority
# eligible upgrade it does not already carry. THEY ARE RESOLVED HERE, LAST,
# because AP's ordering rule is load-bearing — a talent or rune that SETS an
# ability field would otherwise silently overwrite an upgrade applied earlier.
# THEY BYPASS THE ONCE-PER-RUN RULE ON PURPOSE: that rule governs the mini-boss
# PICK POOL, and a talent-granted upgrade is not a mini-boss pick, so it must
# neither consult `has_upgrade` nor be written into `member["upgrades"]`.
func apply_upgrades(member: Dictionary, abilities: Array,
		talent_fallbacks: Array = []) -> Dictionary:
	var landed: Dictionary = {}
	# What each ability already carries, so the fallback can respect "not
	# already on this ability" without a second read of the same data.
	var carried: Dictionary = {}
	for up in member.get("upgrades", []):
		var id := String(up.get("id", ""))
		var target := String(up.get("ability", ""))
		if target == "" or not ABILITY_UPGRADES.has(id):
			continue
		for ab in abilities:
			if ab.display_name != target:
				continue
			_stamp_upgrade(id, ab)
			carried[target] = carried.get(target, []) + [id]
			landed[target] = landed.get(target, []) + [upgrade_name(id)]
	for name in talent_fallbacks:
		var fb_name := String(name)
		var fb_ab: Ability = null
		for ab2 in abilities:
			if ab2.display_name == fb_name:
				fb_ab = ab2
				break
		if fb_ab == null:
			continue  # the ability left the kit — nothing to upgrade, not an error
		var pick := fallback_upgrade_id(fb_ab, carried.get(fb_name, []))
		if pick == "":
			continue  # an honest dead end; the node's tooltip says so
		_stamp_upgrade(pick, fb_ab)
		carried[fb_name] = carried.get(fb_name, []) + [pick]
		landed[fb_name] = landed.get(fb_name, []) + [upgrade_name(pick)]
	return landed


# THE ONE PLACE AN UPGRADE'S EFFECT IS WRITTEN — both the mini-boss pick and
# the talent fallback go through it, so the two can never pay different
# amounts for the same named upgrade.
func _stamp_upgrade(id: String, ab: Ability) -> void:
	match id:
		"up_damage":
			ab.damage = int(round(ab.damage * 1.5))
		"up_cooldown":
			ab.cooldown = maxi(ab.cooldown - 2, 0)
		"up_free":
			# `cost` alone. faith_cost (Mercy) is never touched.
			ab.cost = 0
		"up_speed":
			ab.delay = maxf(ab.delay * 0.75, 1.0)
		"up_break":
			ab.pressure *= 2
		"up_wide":
			# ONE branch or the other, never both: `random_hits` and
			# `multi_hits` are alternatives at the resolve site (it reads
			# random first, then multi), so adding to both would spend the
			# upgrade on a field the cast never looks at.
			if ab.random_hits > 0:
				ab.random_hits += 1
			else:
				ab.multi_hits += 1
		"up_pierce":
			ab.armor_pierce = minf(ab.armor_pierce + 0.5, 1.0)
		"up_certain":
			# Both rolls, because eligibility admits either one — an ability
			# that only carries the bleed roll is unaffected by the first
			# line and vice versa.
			ab.status_chance = 1.0
			ab.bleed_chance = 1.0


# The generic talent fallback's choice: the first upgrade in UPGRADE_PRIORITY
# that FITS this ability (AP §3's eligibility rules, reused not re-written) and
# is not in `already`. "" when every eligible upgrade is already on it — the
# node grants nothing, and the hero screen says so rather than staying silent.
func fallback_upgrade_id(ab: Ability, already: Array = []) -> String:
	if ab == null:
		return ""
	for id in UPGRADE_PRIORITY:
		var uid := String(id)
		if already.has(uid):
			continue
		if upgrade_fits(uid, ab):
			return uid
	return ""


# What a hero's tree node would actually hand them if its grant collided right
# now, as a sentence — the hero screen's collision line. "" when the node has
# nothing to say (it does not grant an ability, or the hero does not own it).
# Reads `member["upgrades"]` for what the ability already carries, which is the
# same data apply_upgrades reads, so the tooltip cannot promise a second Honed.
func fallback_line(member: Dictionary, payload: Dictionary) -> String:
	var name := Talents.granted_name(payload)
	if name == "" or not Talents.owns_ability(member, name):
		return ""
	match Talents.collision_kind(payload):
		"none":
			return ""
		"authored":
			return "You already have %s — this node upgrades it instead." % name
	var ab: Ability = Classes.pool_ability(name)
	if ab == null:
		return ""
	var already: Array = []
	for up in member.get("upgrades", []):
		if String(up.get("ability", "")) == name:
			already.append(String(up.get("id", "")))
	var pick := fallback_upgrade_id(ab, already)
	if pick == "":
		return "You already have %s, and every upgrade it can take is already on it — this node grants NOTHING." % name
	return "You already have %s — this node makes it %s instead (%s)" % [
		name, upgrade_name(pick), upgrade_desc(pick)]


func upgrade_name(id: String) -> String:
	return String(ABILITY_UPGRADES.get(id, {}).get("name", id))


func upgrade_desc(id: String) -> String:
	return String(ABILITY_UPGRADES.get(id, {}).get("desc", ""))


# Has this hero already taken this upgrade, on any ability?
func has_upgrade(member: Dictionary, id: String) -> bool:
	for up in member.get("upgrades", []):
		if String(up.get("id", "")) == id:
			return true
	return false


# Three {id, ability} candidates: an upgrade the hero has not taken, paired
# with an ability THAT UPGRADE CAN ACTUALLY CHANGE. Fewer than three when the
# hero has taken most of the pool, or when an upgrade has nothing to land on —
# the picker shows what exists rather than padding.
#
# BATCH AP added the pairing filter. Before it, the roll took a random owned
# name, so Honed could be offered on Heal (damage 0), Effortless on Blood
# Price (cost 0) and Quickened on a basic (cooldown 0).
func roll_upgrade_offer(member: Dictionary) -> Array:
	var abilities: Array = owned_ability_names(member).filter(
		func(n): return String(n) != "Strike")
	if abilities.is_empty():
		return []
	# Resolve each owned name ONCE through the existing resolver — there is no
	# second one, deliberately. A name it cannot resolve (a class core attack,
	# a kit override) is dropped: the filter has nothing to read on it, and an
	# unfiltered pairing is exactly what this is here to stop.
	var live: Dictionary = {}
	for n in abilities:
		var ab: Ability = Classes.pool_ability(String(n))
		if ab != null:
			live[String(n)] = ab
	var ids: Array = ABILITY_UPGRADES.keys().filter(
		func(id): return not has_upgrade(member, String(id)))
	ids.shuffle()
	var offer: Array = []
	for id in ids:
		var eligible: Array = live.keys().filter(
			func(n): return upgrade_fits(String(id), live[n]))
		if eligible.is_empty():
			continue  # nothing this upgrade can touch — dropped, not paired with a dud
		offer.append({"id": String(id), "ability": String(eligible.pick_random())})
		if offer.size() == 3:
			break
	return offer


func award_upgrade_pick(member: Dictionary) -> bool:
	var offer := roll_upgrade_offer(member)
	if offer.is_empty():
		return false
	member["up_candidates"] = member.get("up_candidates", []) + [offer]
	member["up_picks_owed"] = int(member.get("up_picks_owed", 0)) + 1
	return true


func owed_upgrade_picks() -> int:
	var n := 0
	for member in party:
		n += int(member.get("up_picks_owed", 0))
	return n


# Batch AN §4: zone bosses draw from the hero's SPEC POOL ONLY — the class
# draw Batch AH added is dropped, abilities are spec-locked now. Spec pools
# are 2-5 deep, so this offers what exists and fills short rather than
# padding from somewhere the batch just closed off.
func roll_spec_ability_offer(member: Dictionary) -> Array:
	var spec := String(member.get("spec", ""))
	if spec == "":
		return []
	var owned: Array = owned_ability_names(member)
	var left: Array = Classes.spec_pool(spec).filter(
		func(n): return not owned.has(n))
	left.shuffle()
	return left.slice(0, 3)
