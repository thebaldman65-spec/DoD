# Run-level state (autoload "Run"): the party, shared inventory, and the
# run's generated zone map. Persists across scene switches within one run.
extends Node

# BATCH BK: A RUN IS A BRANCHING MAP AGAIN — 3 zones x 16 slots = 48
# encounters, the third zone's boss being the end boss. (§1 says 49; 3 x 16
# is 48, and the brief's own "was 36" was 3 x 12 by the same construction, so
# the slip is in the brief and the figure everywhere here is 48.)
# Batch AN deleted the OLD
# branching generator and put a LINE in its place; this is not that generator
# coming back. What AN deleted guaranteed routes (`_ensure_key_route` /
# `_route_satisfied` / `_guarantee_inbound`) and carried an edge-column
# adjacency rule whose comment said 70% and whose code did 53% — it needed
# deleting, not fixing. The mechanism here is the opposite one: NOTHING is
# guaranteed on a route, and commitment comes from SPARSE NON-CROSSING
# GEOMETRY rather than from a rule. A step down a row forecloses the corridor
# above it for two to four columns because no edge climbs back fast enough.
#
# THE SHAPE (§1): slots 1-7 branch three wide, slot 8 is the mini-boss and
# every path converges on it, slots 9-15 branch again, slot 16 is the zone
# boss. 14 branching columns x 3 rows = 42 node positions; pruning takes a
# few of them out, so a column is 2 or 3 wide and the real mean is ~39.7.
const SLOTS_PER_ZONE := 16
const ROWS := 3
const MINI_SLOT := 7        # 0-based: the mini-boss, where the first half converges
const BOSS_SLOT := SLOTS_PER_ZONE - 1
const BRANCH_COLUMNS := 14  # 1-based columns 1..14; the mini-boss sits between 7 and 8

# BATCH BM §6 — THE FOURTH BOSS. Three ZONE bosses pay a meta talent point
# each; the END BOSS pays a relic and gates the meta tree's row tiers. It is
# ONE EXTRA SLOT appended to the FINAL zone only, index SLOTS_PER_ZONE, so
# the run is 3 x 16 + 1 = 49 encounters (BK settled on 48).
# It is FIXED, not drawn from a pool, so it can be learned.
const END_BOSS_SLOT := SLOTS_PER_ZONE
const END_BOSS_KIND := "hollow_crown"

# HOW MANY OF EACH TYPE A ZONE HOLDS (§1). Fights are not listed because
# they are the FILLER: every position no other type claimed is a fight, so
# the four counts below plus the surviving-position count fix the map. A
# route walks 14 of them, which is where §1's expected-walked column comes
# from — 6 elites over 14 columns, one per column, at a mean column width of
# ~2.8, is 6/2.8 = 2.1 elites on a route that does not steer.
const NODE_COPIES := {"elite": 6, "blacksmith": 6, "merchant": 5, "event": 5}

# THE TWO GENERATION WEIGHTS, and they are the whole feel of the map.
# Every legal edge-set for a column is enumerated (see _edge_candidates) and
# drawn WEIGHTED — never rejected and re-rolled, because a retry budget is a
# thing that quietly starts failing when the table's shape changes (Batch AN's
# severity floor made the same call). FULL_COVER_WEIGHT favours a step that
# strands no row, so most columns stay 3 wide; BRANCH_WEIGHT favours a step
# with more edges, which is what puts a second option under the player's
# cursor. Raising either one flattens foreclosure — measured at 2.25 columns
# with these, against §2's "two to four".
const FULL_COVER_WEIGHT := 3.0
const BRANCH_WEIGHT := 1.5
# No draw may leave the next column below this. A one-node column is a step
# with no decision on it, and the headline this batch exists to move is
# decisions per run. Guaranteed BY CONSTRUCTION: candidates that would strand
# a column at one node are never in the bag, rather than being rolled and
# thrown back.
const MIN_COLUMN := 2

# All item metadata lives here; battle and map both read it.
#
# BATCH CT §6 — THE FLAT NUMBERS ARE GONE FROM THE THREE THAT HAD THEM. The
# free healing scaled and the paid healing did not: clearing a slot heals
# SLOT_HEAL_PCT (15%) of maximum and heroes gain +2% base HP per win, so a
# flat 40 decayed against the party carrying it while the shop kept charging
# 30 gold. Health and Mana are percentages now and the Bomb rides the same
# +2%-per-win rate the heroes do. Revive (50%) and Defense (+10% armor) were
# already percentages and are UNTOUCHED.
#
# THIS TABLE IS THE ONLY PLACE THESE NUMBERS ARE WRITTEN. Battle and map both
# read it, and both read the constants below rather than repeating a literal,
# so the two can never drift.
const HEALTH_POTION_PCT := 0.20   # of the target's MAXIMUM health
# FLAGGED (§6 asked for the figure to be flagged): 40% of a base 100
# max_resource is the current flat 40 exactly, so a run opens unchanged on
# this one. Every hero starts at max_resource 100 (BattleUnit.max_resource),
# which is what makes the match exact rather than approximate.
const MANA_POTION_PCT := 0.40     # of the target's MAXIMUM resource
const BOMB_BASE_DAMAGE := 50      # unchanged at zero wins, scaled by the rate below
const BOMB_WIN_SCALE := 0.02      # +2% per combat win — the heroes' own rate

const ITEM_IDS := ["health", "mana", "bomb", "revive", "defense",
	"cleanse", "visage", "hourglass"]
const ITEM_INFO := {
	"health": ["Health Potion", "Restores 20% of one ally's maximum health."],
	"mana": ["Mana Potion", "Restores 40% of one ally's maximum Mana (or Rage)."],
	"bomb": ["Bomb", "Deals 50 damage to all enemies, +2% per victory this run."],
	"revive": ["Revive Potion", "Revives a fallen ally at 50% HP."],
	"defense": ["Defense Potion", "+10% armor to every living hero for 3 turns."],
	# BATCH CT §4 — the three new ones. All BATTLE ONLY: on the map they sit
	# in the pouch with a disabled button that says why, which is the BOMB's
	# idiom (`_usable_on_map`), not the Defense Potion's (that one is enabled
	# and refuses with a toast on press). The brief called those one pattern;
	# they are two, and the Bomb's is the one that actually reads.
	"cleanse": ["Cleansing Draught",
		"Removes every debuff from one chosen hero. Battle only."],
	"visage": ["Cursed Visage",
		"Hexes every living enemy for the rest of the battle (-15% damage dealt). Battle only."],
	"hourglass": ["Resonating Hourglass",
		"One chosen hero acts next, ahead of the whole queue. Battle only."],
}
# Potions drop more often than the heavy items. BATCH CT §7: `cleanse` joins
# at a LIGHT weight (one entry against the potions' two). The Cursed Visage
# and the Resonating Hourglass are deliberately absent — shop-only, so what
# they cost is what they are worth.
const LOOT_POOL := ["health", "health", "mana", "mana", "bomb", "revive",
	"defense", "cleanse"]
# Batch AN §6: six of each item type, and that is the whole stack. A
# purchase or a drop above the cap is REFUSED with a message rather than
# swallowed — a reward that silently evaporates reads as a bug, and the
# shop must be able to grey the button rather than take the gold.
# BATCH CT keeps this as the DEFAULT and adds per-type exceptions below.
const ITEM_CAP := 6
# BATCH CT §4: the heavy new items carry their own, smaller stack caps.
# Anything absent uses ITEM_CAP.
const ITEM_STACK_CAPS := {"cleanse": 4, "visage": 2, "hourglass": 2}

# ---------- BATCH CT: THE PRICES LIVE HERE, WITH THE REST OF THE ITEM TABLE ----------
#
# They were a `const` in `shop_screen.gd` with a HAND-COPIED MIRROR in
# `run_sim.gd`, and the mirror indexes itself by `ITEM_IDS` — so the day §4
# added three ids the sim became a missing-key crash, which no parse gate can
# see. §6 says this table is the single place the item numbers are written, and
# a price is an item number.
#
# **IT MUST LIVE HERE AND NOT BE `preload`ed FROM `shop_screen.gd`.** That was
# tried and it broke the entire run harness: `shop_screen.gd` names the `Run`
# AUTOLOAD at compile time, autoloads are not registered when a `--script`
# SceneTree compiles its dependency chain, and `run_sim.gd` preloading it took
# `test_run_harness.gd` down with it ("Identifier not found: Run"). Reading a
# const off the autoload's OWN script has no such problem: every consumer
# already holds the run node and reads it at RUNTIME.
#
# The five original prices are unchanged (§7); the three new ones are listings.
const ITEM_PRICES := {"health": 30, "mana": 30, "bomb": 45, "revive": 80,
	"defense": 40, "cleanse": 35, "visage": 100, "hourglass": 90}

# BATCH CT §2 — SELL BACK, AND IT MUST BE A LOSS. An even trade would make the
# shop a free locker: buy everything, park the overflow with the merchant,
# collect it next visit, and the slot cap stops meaning anything at all. Two
# fifths is enough that a wasted purchase is recoverable and not enough that
# round-tripping is a strategy.
const SELL_FRACTION := 0.4

# ---------- BATCH CT §1: THE POUCH IS SLOTTED ----------
#
# A SLOT HOLDS ONE ITEM TYPE AND ITS WHOLE STACK — six Health Potions are one
# slot, not six. The cap is the design and not a limitation: items cost no
# turn, so until now the shop only ever asked "can you afford it", and the
# answer was yes to everything in reach. A slot cap turns that into WHAT DO
# YOU MAKE ROOM FOR.
#
# THE BRIEF'S NAMED PRECEDENT DOES NOT EXIST. §1 says to follow the rune
# equip-slot ladder "exactly — it already grows 2 -> 3 -> 4 by zone and
# announces each new slot on the zone-victory screen". It does not: Batch AN
# §9 DELETED that ladder and `rune_slots()` has returned a flat 3 ever since,
# with the reason written above it — a growth ladder means a run that dies in
# zone 2 never owns the last slot. There was no announcement to copy either,
# so this batch WRITES one (see battle.gd `_resolve_boss`).
#
# The ladder is still right HERE, and for the opposite reason it was wrong for
# runes: rune slots growing was dilution, because an empty slot is dead weight
# you cannot fill on demand. A pouch slot is filled the moment you reach a
# merchant, so growth is the tradeoff LOOSENING as the party's income does —
# which is the arc, not a dilution of it.
const ITEM_SLOTS_BY_ZONE := [4, 5, 6]

# A STACK FALLING TO ZERO DOES NOT FREE ITS SLOT. The key stays in `items`
# until the type is DISCARDED or SOLD (§2). Otherwise the cap stops binding
# the moment a stack empties — which is exactly when it should be biting —
# and the tradeoff evaporates. This is why every count-of-slots question below
# reads `items.size()` and never "how many types hold a positive count".

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
# Batch BK: the lattice. map[slot] is an ARRAY of node dicts — 2 or 3 of them
# on a branching slot, exactly one on the mini-boss and the boss. A node is
# {type, visited, row, next, enemies, theme}, where `next` holds INDICES INTO
# map[slot + 1] (not row numbers: rows get pruned, indices do not shift under
# you). The party's position is the pair (slot_idx, node_idx).
var map: Array = []
var slot_idx := -1         # -1 = zone not entered; 0..15 = standing on that slot
var node_idx := 0          # which node of map[slot_idx] the party stands on
var encounter := {}        # {"type": ..., "enemies": ["raider", ...]} for the next battle
var seen_events: Array = []  # event ids drawn this run (non-repeating pool)
# The modifier the player accepted at the offer screen, live for exactly
# one battle (§3). Cleared when that battle resolves. Not saved: quitting
# between the offer and the fight forfeits the offer, and the slot is
# re-offered — the same shape as pending_event.
var pending_modifier := ""
var pending_reward := {}   # the reward the accepted option pays on victory
# BATCH CT §3 — DROPS THAT HAVE NO SLOT, WAITING FOR THE MAP TO ASK.
# A drop, an elite cache or an event can hand the party a type it has no slot
# for. That is NOT the refusal a full stack gets: it is a CHOICE, offered as
# "take it and give up a stack, or decline". The grant happens in BATTLE (the
# victory screen) or in an EVENT, and neither of those is a place to put a
# five-button overlay, so the offer QUEUES here and the MAP resolves it — the
# same shape `rune_picks_owed` and the draft picks already use, which is the
# pattern map_screen.gd's header calls "an owed pick opens its own overlay".
#
# THE BRIEF NAMED A DIFFERENT PATTERN AND IT IS NOT THE RIGHT ONE. §3 says to
# reuse "the elite cache and rune offer pattern". There is no elite cache —
# the elite spoils call it a RUNE CACHE, and that IS the owed-pick overlay
# used here. The "rune offer" is the merchant's rune column, and the OFFER
# SCREEN (offer_screen.gd) is the pre-fight bargain, which says in its own
# header "There is NO decline" — so it cannot be the model for an interaction
# whose §3 requires a decline button. The owed-pick overlay can, and is.
#
# SAVED WITH THE RUN: an offer is a reward already earned, and quitting
# between the victory screen and the map must not eat it.
var pending_item_offers: Array = []  # item ids awaiting a swap-or-decline
# Which hero the sheet opens onto (Batch AN: the map cards ARE the party
# list, so the sheet is always entered for a specific hero). Session-scoped
# — a resumed run opens the map, never a sheet.
var hero_screen_idx := 0
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


# BATCH BL §2 — THE BOUND, and it is a real one rather than a comment. An
# unbounded (hero x ability) map is fine today — a hero owns a handful of
# abilities and meets a handful of enemy kinds — but it is a map keyed on
# AUTHORED CONTENT that goes into the save file, and a later ability draft with
# 150 entries would grow every save quietly and forever. Past the bound, further
# distinct keys fold into one "(other)" row rather than being dropped: the
# per-hero TOTAL stays exact and only the breakdown gets coarser, which is the
# right way round when the panel reports a top 5.
const TALLY_KEYS_PER_HERO := 24
const TALLY_KILLS_MAX := 12
const TALLY_OTHER := "(other)"


func reset_tally() -> void:
	# `dealt`/`taken` are hero -> key -> amount; `taken_total` is the exact
	# per-hero sum (never folded, so the "(other)" row can never make the
	# breakdown disagree with the total); `kills` is the killing-blow list; and
	# `final` holds the LAST battle's own copy of all four. Overwriting `final`
	# every battle is what makes it the FINAL battle when the run ends.
	tally = {"damage": {}, "gold_earned": 0, "gold_spent": 0,
		"elites": 0, "battles": 0,
		"dealt": {}, "taken": {}, "taken_total": {}, "kills": [],
		"final": {"dealt": {}, "taken": {}, "taken_total": {}, "kills": []}}


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


# BATCH BL §2 — THE ONE BOUNDED WRITER, shared by the dealt map and the taken
# map so the cap cannot be honoured by one and forgotten by the other. `book` is
# hero -> key -> amount; a key already present always lands on its own row, so
# the bound bites only on the (N+1)th DISTINCT key a hero ever sees.
func _tally_book(book: Dictionary, hero_name: String, key: String,
		amount: float) -> void:
	var rows: Dictionary = book.get(hero_name, {})
	# The bound counts the "(other)" row itself, so a hero's map NEVER holds
	# more than TALLY_KEYS_PER_HERO entries — "at most 24 rows" rather than
	# "24 rows plus one more".
	if not rows.has(key) and rows.size() >= TALLY_KEYS_PER_HERO - 1:
		key = TALLY_OTHER
	rows[key] = float(rows.get(key, 0.0)) + amount
	book[hero_name] = rows


# Damage a hero DEALT, split by the ability that dealt it (Batch BL §2). The
# whole-run `damage` total above is written separately and stays authoritative:
# these rows answer "with what", never "how much".
func tally_dealt(hero_name: String, ability: String, amount: float) -> void:
	if debug_summon or amount <= 0.0:
		return
	if tally.is_empty():
		reset_tally()
	_tally_book(tally.get("dealt", {}), hero_name, ability, amount)


# Damage a hero TOOK, keyed by "<source> / <ability>" — the source being an
# enemy KIND (three Shieldmasters aggregate into one row) or the hero themself
# for a self-inflicted cost. `taken_total` is kept beside it and is never folded
# into "(other)", so the total is exact whatever the bound does to the rows.
func tally_taken(hero_name: String, source_key: String, amount: float) -> void:
	if debug_summon or amount <= 0.0:
		return
	if tally.is_empty():
		reset_tally()
	_tally_book(tally.get("taken", {}), hero_name, source_key, amount)
	var totals: Dictionary = tally.get("taken_total", {})
	totals[hero_name] = float(totals.get(hero_name, 0.0)) + amount
	tally["taken_total"] = totals


# One killing blow: who fell, to what, from whom, for how much, and the health
# it landed against. Bounded like everything else here — a run cannot record
# more than TALLY_KILLS_MAX of them, and the oldest is the one kept because the
# first death in a run is the one that explains the rest.
func tally_kill(record: Dictionary) -> void:
	if debug_summon:
		return
	if tally.is_empty():
		reset_tally()
	var kills: Array = tally.get("kills", [])
	if kills.size() < TALLY_KILLS_MAX:
		kills.append(record)
	tally["kills"] = kills


# The battle that just ended, banked whole so the recap can report it on its
# own. Overwritten each time: when the run ends, this holds the final battle.
func tally_bank_final(dealt: Dictionary, taken: Dictionary,
		taken_total: Dictionary, kills: Array) -> void:
	if debug_summon:
		return
	if tally.is_empty():
		reset_tally()
	tally["final"] = {"dealt": dealt.duplicate(true), "taken": taken.duplicate(true),
		"taken_total": taken_total.duplicate(true), "kills": kills.duplicate(true)}


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


# Aggregated relic hooks (see the vocabulary audit atop relics.gd):
# scalar hooks sum, dict hooks merge, across this run's active relics.
func relic_add(hook: String) -> float:
	return Relics.hook_add(active_relics, hook)


func relic_dict(hook: String) -> Dictionary:
	return Relics.hook_dict(active_relics, hook)


func new_run(keys := ["warrior", "mage", "cleric", "hunter"], relics: Array = [],
		diff := "wanderer") -> void:
	active = true
	specs_chosen = false
	difficulty = difficulty_id(diff)
	active_relics = relics.slice(0, 3)
	clear_save()
	party = []
	for key in keys:
		var base: Dictionary = HERO_BASE[key]
		# BATCH BM: no in-run talent purse. `talents` is the EQUIPPED loadout,
		# copied off Profile the moment a spec is confirmed and locked for the
		# rest of the run (equip_spec_talents).
		party.append({"key": key, "hp": base["hp"], "max_hp": base["hp"],
			"mana": base["mana"], "max_mana": 100, "spec": "",
			"talents": {}, "runes": []})
	# ZONE FIRST, THEN THE POUCH. `add_item` reads `item_slots()`, which reads
	# `zone_idx` — and this used to be assigned forty lines further down, so a
	# SECOND run started in the same session would have sized the opening pouch
	# off the PREVIOUS run's zone (six slots deep into a zone-3 death, not four).
	# Nothing read the slot count before this batch, so the stale read was
	# harmless until now. It is not harmless now.
	zone_idx = 0
	# BATCH CT §1 — THE RESOLUTION, WRITTEN DOWN AS THE BRIEF REQUIRED.
	# Five starting TYPES against four slots at zone 1 does not fit, and §1
	# gave two ways out: drop the opening to four types, or make the player
	# pick four before the first map. **THE OPENING DROPS TO FOUR TYPES**, and
	# the type dropped is the DEFENSE POTION.
	#
	# Why that one and why not the picker: a choose-four screen before the run
	# has begun asks the player to price five items they have never used, which
	# is a decision with no information in it — the shop asks the same question
	# later, with a run's worth of context behind it. And of the five, Defense
	# is the one whose absence costs least: it is the only one that is purely a
	# hedge (+10% armor for 3 turns), where Health, Mana and Revive answer
	# states a party cannot otherwise leave and the Bomb is the pouch's only
	# offense. It is still sold at every merchant from the first one.
	#
	# NOTHING STARTS OVER CAPACITY, and that is checked rather than assumed —
	# see the loop below.
	items = {"health": 2, "mana": 1, "bomb": 1, "revive": 1}
	# Relic start_items go through `add_item` now, which enforces BOTH walls:
	# the per-type stack cap AND the slot cap. §7 flagged that a relic can push
	# the opening pouch over its slot cap and asked that it resolve through §3's
	# offer rather than silently — but §3's offer is a MAP overlay and there is
	# no map yet at `new_run`, so the honest resolution here is that a relic
	# cannot overflow the opening in the first place.
	#
	# WITH TODAY'S TWO RELICS IT CANNOT: Waystone Shard grants health/mana/bomb
	# and Packmother's Satchel grants health/mana — every one of those types is
	# already in the opening four, so neither needs a slot and neither is
	# refused. The guard is here for the relic that is not written yet, and if
	# one ever is, this is the line that will refuse it (visibly, in the count)
	# rather than the pouch silently going five wide at zone 1.
	for id in relic_dict("start_items"):
		add_item(id, int(relic_dict("start_items")[id]))
	gold = 60 + int(relic_add("start_gold"))
	combat_wins = 0
	# zone_idx is set above, before the pouch is filled — see the note there.
	draw_zones()
	_enter_zone()
	slot_idx = -1
	node_idx = 0
	encounter = {}
	seen_events = []
	pending_event = ""
	pending_modifier = ""
	pending_reward = {}
	pending_item_offers = []
	pending_shop = false
	# A fresh run starts clean, and starts un-summoned and un-travelled.
	debug_used = false
	debug_summon = false
	debug_free_travel = false
	reset_tally()
	_generate_map()


# ---------- the branching map (Batch BK) ----------

# The branching slots, in walking order. 7 and 15 are missing on purpose:
# those are the mini-boss and the boss, one node each, and every path
# converges on them.
const BRANCH_SLOTS := [0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14]
# The pairs an edge draw runs between. 6 -> 7 and 14 -> 15 are absent because
# they converge, and 7 -> 8 is absent because the mini-boss fans out to
# everything: the second half is a fresh entry, which is what makes 8 the
# other column whose whole width is choosable.
const EDGE_PAIRS := [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6],
	[8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14]]


# The slot a 1-based column number lives on. Columns run 1..14 straight
# through the mini-boss, which is why an elite in column 7 forbids one in
# column 8: elite -> MINI-BOSS -> elite is three hard fights back to back,
# and the adjacency rule exists to stop exactly that.
func column_slot(column: int) -> int:
	return column - 1 if column <= 7 else column


# THE GENERATOR. Edges first, types onto whatever positions survive — never
# the other way round, because a type placed before pruning can be pruned.
func _generate_map() -> void:
	var alive := {}    # slot -> Array of surviving row numbers
	var out_rows := {} # slot -> {row: Array of target rows in the next branch slot}
	for s in BRANCH_SLOTS:
		alive[s] = [0, 1, 2]
		out_rows[s] = {}
	for pair in EDGE_PAIRS:
		_draw_edges(int(pair[0]), int(pair[1]), alive, out_rows)
	_prune(alive, out_rows)
	_build_lattice(alive, out_rows)
	_assign_node_types()
	_compose_warbands()


# One column's edges. Every legal assignment is enumerated and ONE is drawn
# weighted — see FULL_COVER_WEIGHT / BRANCH_WEIGHT. Rows that nothing points
# at are dropped from the next column right here; the prune below only has
# the knock-on effects left to chase.
func _draw_edges(from_slot: int, to_slot: int, alive: Dictionary,
		out_rows: Dictionary) -> void:
	var rows: Array = alive[from_slot]
	var cands := _edge_candidates(rows)
	var total := 0.0
	for c in cands:
		total += float(c["w"])
	var roll := randf() * total
	var picked: Array = cands[cands.size() - 1]["iv"]
	for c in cands:
		roll -= float(c["w"])
		if roll <= 0.0:
			picked = c["iv"]
			break
	var covered := {}
	for k in rows.size():
		var iv: Array = picked[k]
		var targets: Array = []
		for r in range(int(iv[0]), int(iv[1]) + 1):
			targets.append(r)
			covered[r] = true
		out_rows[from_slot][int(rows[k])] = targets
	var kept: Array = []
	for r in alive[to_slot]:
		if covered.has(int(r)):
			kept.append(int(r))
	alive[to_slot] = kept


# EVERY legal edge assignment for one column, as {iv, w}. `iv[k]` is the
# INTERVAL [lo, hi] of target rows the k-th surviving source row reaches.
#
# THE THREE RULES, all enforced here rather than checked afterwards:
#   adjacency   an interval lives inside [row - 1, row + 1]
#   no crossing lo of one row is at or above hi of the row above it — that
#               IS §2's "if row i reaches row j and row i+1 reaches row k
#               then k >= j", written as the constraint that generates it
#   min width   an assignment covering fewer than MIN_COLUMN target rows is
#               never in the bag
# Out-degree is hi - lo + 1, so 1..3 falls out of the interval shape; in-degree
# is how many intervals contain a row, which is at most one per source row.
func _edge_candidates(rows: Array) -> Array:
	var out: Array = []
	_extend_candidates(rows, 0, [], out)
	return out


func _extend_candidates(rows: Array, k: int, chosen: Array, out: Array) -> void:
	if k >= rows.size():
		var covered := {}
		var extra := 0
		for iv in chosen:
			for r in range(int(iv[0]), int(iv[1]) + 1):
				covered[r] = true
			extra += int(iv[1]) - int(iv[0])
		if covered.size() < MIN_COLUMN:
			return
		var w: float = pow(BRANCH_WEIGHT, extra)
		if covered.size() == ROWS:
			w *= FULL_COVER_WEIGHT
		out.append({"iv": chosen.duplicate(true), "w": w})
		return
	var row := int(rows[k])
	var lo_min := maxi(0, row - 1)
	var hi_max := mini(ROWS - 1, row + 1)
	if k > 0:
		lo_min = maxi(lo_min, int(chosen[k - 1][1]))  # no crossing
	for lo in range(lo_min, hi_max + 1):
		for hi in range(lo, hi_max + 1):
			chosen.append([lo, hi])
			_extend_candidates(rows, k + 1, chosen, out)
			chosen.pop_back()


# Nodes with no way in or no way out are REMOVED, to a fixpoint — killing one
# can strand its neighbours in either direction. Slots 0 and 8 are exempt from
# the way-in rule (0 is the zone entry, 8 is fed by the mini-boss) and slots 6
# and 14 from the way-out rule (they converge on the mini-boss and the boss).
func _prune(alive: Dictionary, out_rows: Dictionary) -> void:
	var changed := true
	while changed:
		changed = false
		for i in range(EDGE_PAIRS.size() - 1, -1, -1):
			var from_slot := int(EDGE_PAIRS[i][0])
			var to_slot := int(EDGE_PAIRS[i][1])
			var kept: Array = []
			for r in alive[from_slot]:
				var live: Array = []
				for t in out_rows[from_slot].get(int(r), []):
					if alive[to_slot].has(int(t)):
						live.append(int(t))
				if live.is_empty():
					out_rows[from_slot].erase(int(r))
					changed = true
				else:
					out_rows[from_slot][int(r)] = live
					kept.append(int(r))
			alive[from_slot] = kept
		for pair in EDGE_PAIRS:
			var from_slot := int(pair[0])
			var to_slot := int(pair[1])
			var inbound := {}
			for r in alive[from_slot]:
				for t in out_rows[from_slot].get(int(r), []):
					inbound[int(t)] = true
			var kept2: Array = []
			for r in alive[to_slot]:
				if inbound.has(int(r)):
					kept2.append(int(r))
				else:
					out_rows[to_slot].erase(int(r))
					changed = true
			alive[to_slot] = kept2


# Turn surviving rows + row-edges into the saved shape: an Array per slot,
# each node carrying its row (for drawing) and `next` as INDICES into the
# following slot's array.
func _build_lattice(alive: Dictionary, out_rows: Dictionary) -> void:
	map = []
	for s in SLOTS_PER_ZONE:
		map.append([])
	for s in BRANCH_SLOTS:
		for r in alive[s]:
			map[s].append({"type": "fight", "visited": false, "row": int(r),
				"next": []})
	map[MINI_SLOT].append({"type": "miniboss", "visited": false, "row": 1,
		"next": []})
	map[BOSS_SLOT].append({"type": "boss", "visited": false, "row": 1,
		"next": []})
	for pair in EDGE_PAIRS:
		var from_slot := int(pair[0])
		var to_slot := int(pair[1])
		for node in map[from_slot]:
			var links: Array = []
			for t in out_rows[from_slot].get(int(node["row"]), []):
				for j in map[to_slot].size():
					if int(map[to_slot][j]["row"]) == int(t):
						links.append(j)
			node["next"] = links
	# The three converging edges. Column 7 and column 14 have one way on;
	# the mini-boss opens the whole of column 8.
	for node in map[MINI_SLOT - 1]:
		node["next"] = [0]
	for node in map[BOSS_SLOT - 1]:
		node["next"] = [0]
	var after_mini: Array = []
	for j in map[MINI_SLOT + 1].size():
		after_mini.append(j)
	map[MINI_SLOT][0]["next"] = after_mini
	# BATCH BM §6: the final zone carries ONE MORE SLOT after its boss — the
	# end boss. Appended LAST, after every edge above is wired, because the
	# converging-edge block writes `next` on the boss slot's neighbours and a
	# link set before it would be overwritten.
	if not has_next_zone():
		map.append([{"type": "endboss", "visited": false, "row": 1, "next": []}])
		map[BOSS_SLOT][0]["next"] = [0]


# Types onto the surviving positions. CONSTRUCTIVE, not sampled-and-checked:
# every constraint below is a restriction on what the draw may pick from.
#
#   elites      6 columns out of 2..14 with no two adjacent. Drawn through
#               the standard bijection — pick 6 distinct from {2..9}, sort,
#               add the index — so an illegal spread is not merely rejected,
#               it cannot be named. That is also what caps a greedy route: 6
#               elites in 6 non-adjacent columns, one node each, is 3.4
#               walked at the greediest policy rather than 6.
#   the rest    one blacksmith / merchant / event per column at most, into
#               columns that still have a free position, roomiest first.
#   fights      everything left. Never counted, always the remainder.
func _assign_node_types() -> void:
	var free := {}       # column -> Array of free node indices
	var used := {}       # column -> Dictionary of types already placed there
	for c in range(1, BRANCH_COLUMNS + 1):
		var s := column_slot(c)
		var idxs: Array = []
		for j in map[s].size():
			idxs.append(j)
		free[c] = idxs
		used[c] = {}
	var base: Array = [2, 3, 4, 5, 6, 7, 8, 9]
	base.shuffle()
	base = base.slice(0, int(NODE_COPIES["elite"]))
	base.sort()
	for k in base.size():
		_place_type(int(base[k]) + k, "elite", free, used)
	for ty in ["blacksmith", "merchant", "event"]:
		var cols: Array = []
		for c in range(1, BRANCH_COLUMNS + 1):
			if not used[c].has(ty) and not free[c].is_empty():
				cols.append(c)
		# Roomiest column first, so the deal can never paint itself into a
		# corner: 22 non-fight nodes against a floor of 28 positions.
		cols.sort_custom(func(a, b): return free[a].size() > free[b].size())
		var want := int(NODE_COPIES[ty])
		for i in mini(want, cols.size()):
			_place_type(int(cols[i]), ty, free, used)


func _place_type(column: int, ty: String, free: Dictionary,
		used: Dictionary) -> void:
	var idxs: Array = free[column]
	if idxs.is_empty():
		return
	var pick := int(idxs[randi() % idxs.size()])
	map[column_slot(column)][pick]["type"] = ty
	idxs.erase(pick)
	used[column][ty] = true


# Warbands are pre-rolled at map birth, exactly as Batch AN's line did it:
# every combat node carries its enemies + theme, so hovering a node can show
# what resists what BEFORE the player commits. Scouting resists is
# counterplay, not a spoiler. Non-combat nodes carry no warband at all.
func _compose_warbands() -> void:
	for s in map.size():
		for node in map[s]:
			var ty := String(node["type"])
			if not ty in ["fight", "elite", "miniboss", "boss", "endboss"]:
				continue
			# BATCH BM §6: the end boss is FIXED, not composed — a single
			# authored encounter, so it can be learned. It is the one node on
			# the board whose lineup does not come out of the budget system.
			if ty == "endboss":
				node["enemies"] = [END_BOSS_KIND]
				node["theme"] = "The Hollow Crown"
				continue
			node["enemies"] = compose(ty, s + 1)
			node["theme"] = last_theme


# The nodes the player may enter next, as INDICES into map[slot_idx + 1].
# Before the first step that is the whole of column 1; on the mini-boss it is
# the whole of column 8; everywhere else it is the current node's own edges.
# Empty once the boss is behind them.
func reachable() -> Array:
	if slot_idx < 0:
		var entry: Array = []
		for j in map[0].size():
			entry.append(j)
		return entry
	# BATCH BM §6: the boss slot leads on to the END BOSS in the final zone,
	# and nowhere at all in every other. Reading `next` covers both, because
	# only the final zone's boss has a link out.
	if slot_idx >= map.size() - 1:
		return []
	return Array(current_node().get("next", []))


# ONE argument still, and it is the NODE index within the next slot — the
# slot is never a choice, only which of its nodes.
func advance(node: int) -> void:
	slot_idx += 1
	node_idx = clampi(node, 0, maxi(map[slot_idx].size() - 1, 0))
	map[slot_idx][node_idx]["visited"] = true


func current_node() -> Dictionary:
	if slot_idx < 0 or slot_idx >= map.size() or map[slot_idx].is_empty():
		return {}
	return map[slot_idx][clampi(node_idx, 0, map[slot_idx].size() - 1)]


# Where the party stands in the WHOLE run, 1-49 — the readout the zone
# header and the run summary both want. 0 before the first slot is entered.
# BATCH BM: 49, not 48. The final zone carries a seventeenth slot.
func run_slot_number() -> int:
	if slot_idx < 0:
		return zone_idx * SLOTS_PER_ZONE
	return zone_idx * SLOTS_PER_ZONE + slot_idx + 1


func total_slots() -> int:
	return SLOT_COUNT * SLOTS_PER_ZONE + 1


# BATCH BM §6: the end boss is its OWN slot after the final zone's boss, not
# the final zone's boss itself. A zone boss — including the third — opens
# what follows it; only this one ends the run.
func is_end_boss_slot(slot: int) -> bool:
	return slot == END_BOSS_SLOT and not has_next_zone()


# Every node reachable from (slot, node), as a Dictionary of "slot,index"
# keys. The map screen greys what a step has closed off, the sim measures
# foreclosure with it, and the test asserts the entry guarantee against it.
func reachable_from(slot: int, node: int) -> Dictionary:
	var seen := {}
	var frontier: Array = [[slot, node]]
	while not frontier.is_empty():
		var cur: Array = frontier.pop_back()
		var s := int(cur[0])
		var j := int(cur[1])
		var key := "%d,%d" % [s, j]
		if seen.has(key) or s < 0 or s >= map.size() or j >= map[s].size():
			continue
		seen[key] = true
		for t in map[s][j].get("next", []):
			frontier.append([s + 1, int(t)])
	return seen


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
# 1..16 tier ladder and its position in the run applies a flat base
# multiplier. Keyed by SLOT, not zone identity — the Forest of Old is
# x1.0 as the opener and x2.2 when revisited as the finale — and slots
# past the authored list continue the ~x1.5 step, so adding a 4th zone
# is data work, never formula work.
const ZONE_BASE_MULTS := [1.0, 1.5, 2.2]

# BATCH BM §5 — THE DIFFICULTY LADDER. Three rungs, and the ladder is what
# rows 4-9 of the meta tree are FOR: vertical progression with nothing
# absorbing it means the game only ever gets easier.
#
# `difficulty` was Batch Y's alpha testing lever — a String var, saved with
# the run, armable from the draft and from DOD_SIM_DIFFICULTY, folded into
# ONE multiplier at zone_base_mult. THE FIELD IS REUSED, NOT SHADOWED: every
# one of those properties is what the ladder needs, so the change is to the
# TABLE it keys into, not to the plumbing. Y's two ids still resolve
# (LEGACY_DIFFICULTY below) so a saved run and every old sim script load.
#
# EVERY SCALING NUMBER HERE IS PROVISIONAL AND SAID SO. Balance is deferred
# by designer decision; the STRUCTURE is what ships.
#   rung 1 "Wanderer"  x0.50  — DELIBERATELY BELOW the present balance,
#                               because this is the rung played with ZERO
#                               talents and it is the gate the whole meta
#                               layer sits behind. BATCH BN CHOSE THIS FLOAT
#                               BY MEASUREMENT RATHER THAN BY GUESS: BM
#                               inherited Batch Y's 0.70 from the Wanderer
#                               affordance, which is a number picked for a
#                               different job, and an untalented party
#                               completed 12-13% at it — eight attempts
#                               before the first unlock, with nothing banked
#                               in between. Untalented completion, balanced
#                               route, n=100 a row:
#                                   x0.70  13%   x0.60  28%
#                                   x0.50  83%   x0.40  95%
#                               70% (a first run won in one or two attempts)
#                               is the target and 0.50 is the closest of the
#                               four. THE CURVE IS A CLIFF between 0.60 and
#                               0.50 and 70% sits inside that unsampled gap,
#                               so the honest reading is "the nearest
#                               sampled value", not "the right number to
#                               three figures" — a later playtest may move it.
#   rung 2 "Warden"    x1.00  — the present balance, byte-for-byte. BK's
#                               39.3/43.3/21.3% completions were measured
#                               here, so nothing about that row moves.
#   rung 3 "Ruin"      x1.30  — provisional.
#
# EACH RUNG ABOVE 1 ADDS A NAMED TWIST as well as scaling, on the
# ascension-ladder principle: stat inflation alone is a wall, a named twist
# is a ladder. Both twists REUSE existing machinery rather than building new.
#   severity_floor  — the guaranteed mild bargain option gets less mild:
#                     roll_offer draws its safe slot from severity <= N.
#   fixed_modifier  — the mini-boss, the zone bosses and the end boss carry
#                     a modifier, which today they never do.
const DIFFICULTIES := {
	"wanderer": {"rung": 1, "name": "Wanderer", "mult": 0.50,
		"blurb": "The Decay is thin here. No twist.",
		"severity_floor": 2, "fixed_modifier": false},
	"warden": {"rung": 2, "name": "Warden", "mult": 1.00,
		"blurb": "The guaranteed mild bargain gets less mild.",
		"severity_floor": 3, "fixed_modifier": false},
	"ruin": {"rung": 3, "name": "Ruin", "mult": 1.30,
		"blurb": "Harsher bargains, and fixed encounters carry a modifier.",
		"severity_floor": 4, "fixed_modifier": true},
}
const DIFFICULTY_ORDER := ["wanderer", "warden", "ruin"]
# Batch Y's two ids, kept resolvable so a saved run and every DOD_SIM_
# DIFFICULTY script still loads. "standard" WAS the present balance and maps
# to rung 2; "wanderer" kept its own id and its own multiplier.
const LEGACY_DIFFICULTY := {"standard": "warden"}
var difficulty := "wanderer"


func difficulty_id(raw: String) -> String:
	if DIFFICULTIES.has(raw):
		return raw
	return String(LEGACY_DIFFICULTY.get(raw, "wanderer"))


func difficulty_def() -> Dictionary:
	return DIFFICULTIES[difficulty_id(difficulty)]


# The rung number 1-3 — what the end boss unlocks on Profile, and the only
# thing outside this block that should read the ladder as a number.
func difficulty_rung() -> int:
	return int(difficulty_def()["rung"])


func difficulty_mult() -> float:
	return float(difficulty_def()["mult"])


func zone_base_mult(slot: int) -> float:
	if slot <= ZONE_BASE_MULTS.size():
		return ZONE_BASE_MULTS[maxi(slot, 1) - 1] * difficulty_mult()
	return ZONE_BASE_MULTS[ZONE_BASE_MULTS.size() - 1] \
		* pow(1.5, slot - ZONE_BASE_MULTS.size()) * difficulty_mult()


# The tier is the SLOT NUMBER (1-16). Batch T's ramp was fitted against slot
# DEPTH and Batch AN kept it byte-for-byte on a 12-slot line; BATCH BK §5
# RESCALES IT ACROSS 16 AND CHANGES NOTHING ELSE. Both ENDS are held exactly
# where AN left them — slot 1 still opens at 3-5 and the last slot before the
# boss still tops out at 8-10 — so the slope falls from 0.5 a slot to 5/14,
# and the boss band is untouched. Keeping the old SLOPE instead would have run
# the pre-boss slot to 10-12 and collided with the boss's own band, which is
# difficulty tuning wearing a rescale's clothes; §7 forbids it.
#   t1:3-5  t4:4-6  t8:5-7 (mini-boss)  t12:6-8  t15:8-10  t16:10-12 (boss)
func battle_budget(tier := -1) -> int:
	if tier <= 0:
		tier = slot_idx + 1
	tier = clampi(tier, 1, SLOTS_PER_ZONE)
	if tier >= SLOTS_PER_ZONE:
		# The boss slot keeps its band: the Escort composition (boss 7 +
		# power 3-5 of company) is authored content, not the fight ladder.
		return randi_range(10, 12)
	var lo := 3 + int(floor((tier - 1) * 5.0 / 14.0))
	return randi_range(lo, lo + 2)


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
#
# **AND BATCH DY §3 DELETED THE OTHER HALF OF THAT DRAW.** This comment used to
# end "`Classes.CLASS_POOLS` / `class_pool()` are left standing and still
# resolve ... re-opening the class draw is a one-line change if the designer
# wants it back." Both are gone. The one-line claim was true of the CODE and
# was always the smallest part of the price: the container held 61 curated
# entries against twelve specs, 56 of the 183 hero-and-entry pairs a reopened
# draw could offer duplicated something that hero can already reach, and 27 of
# those were the hero's own PROTECTED CORE. **RE-OPENING A CLASS DRAW IS A
# DESIGN DECISION WITH A CURATION BILL, NOT A ONE-LINE CHANGE**, and if it is
# ever taken it reads `Classes.CLASS_DRAFT_POOLS` — which is live and curated —
# rather than a second dict rebuilt from scratch. The award below is
# SPEC_POOLS-only and that is the standing ruling.
func award_ability_pick(member: Dictionary) -> bool:
	var offer := roll_spec_ability_offer(member)
	if offer.is_empty():
		return false
	member["bm_candidates"] = member.get("bm_candidates", []) + [offer]
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) + 1
	return true


# ---------- THE ABILITY DRAFT (Batch BO §2/§3) ----------
#
# ABILITY SLOTS CAP AT SEVEN, AND THE PROTECTED CORE COUNTS AGAINST IT — so
# most specs carry 3 protected and 4 draftable (Holy carries 4 and 3; see
# `Classes.PROTECTED_CORES` for the twelve-core table and why the Beastmaster's
# five opening abilities are three slots).
#
# EVERY DROP DECISION IS AMONG EARNED ABILITIES. Protected ones can never be
# dropped, which is what makes the cap unable to break a passive: the failure
# mode this whole section exists to prevent is a spine that stops working
# because its enabler was droppable, and that failure is SILENT.
const ABILITY_SLOT_CAP := 7


# What the hero has EARNED — boss picks and drafted cards alike, in the one
# list `bm_abilities` they have always shared. This is the drop pool, and
# nothing else in it can be dropped.
func earned_ability_names(member: Dictionary) -> Array:
	return member.get("bm_abilities", []).duplicate()


func ability_slots_used(member: Dictionary) -> int:
	var spec := String(member.get("spec", ""))
	if spec == "":
		return 0
	return Classes.core_slots(spec) + earned_ability_names(member).size()


func ability_slots_full(member: Dictionary) -> bool:
	return ability_slots_used(member) >= ABILITY_SLOT_CAP


# THE NO-RETURN LEDGER. A declined or dropped ability does not come back to
# that run's pool — otherwise the offer keeps re-presenting exactly what was
# just refused. Per hero, per run; it rides the member dict, so it is saved and
# loaded with everything else and NO SAVE VERSION MOVES (still v10).
func draft_refused(member: Dictionary) -> Array:
	return member.get("draft_refused", [])


func _refuse_draft(member: Dictionary, name: String) -> void:
	if name == "":
		return
	var refused: Array = member.get("draft_refused", [])
	if not refused.has(name):
		refused.append(name)
	member["draft_refused"] = refused


# What this hero could still be offered, split by side. Neither side may hold
# something already owned (from ANY source — kit, talent grant, boss pick or an
# earlier draft) or already refused this run.
func draft_pool_left(member: Dictionary) -> Dictionary:
	var spec := String(member.get("spec", ""))
	if spec == "":
		return {"spec": [], "class": []}
	var blocked: Array = owned_ability_names(member)
	blocked.append_array(draft_refused(member))
	var spec_left: Array = Classes.spec_draft_pool(spec).filter(
		func(n): return not blocked.has(n))
	var class_left: Array = Classes.class_draft_pool(
		Classes.class_of_spec(spec)).filter(func(n): return not blocked.has(n))
	return {"spec": spec_left, "class": class_left}


# ROUGHLY ONE CARD IN FOUR IS CLASS-WIDE. Its own function so the ratio has a
# seam a test can drive a few hundred times — with both pools empty until
# tranche 2, a check on the ROLLER could only ever measure zero, and a check
# that can only pass is a gap (the BK zero-blacksmith lesson).
func draft_card_is_class(spec_left: int, class_left: int) -> bool:
	if class_left < 1:
		return false
	if spec_left < 1:
		return true
	return randf() < Classes.CLASS_DRAFT_SHARE


# EVERY OFFER IS 3 CARDS. If the pool cannot fill three — likely until tranche
# 3 — IT FILLS SHORT RATHER THAN PADDING WITH REPEATS. That is AP §3's existing
# rule for upgrade offers, applied unchanged.
func roll_draft_offer(member: Dictionary) -> Array:
	var pools := draft_pool_left(member)
	var spec_left: Array = pools["spec"]
	var class_left: Array = pools["class"]
	spec_left.shuffle()
	class_left.shuffle()
	var out: Array = []
	for _card in 3:
		if spec_left.is_empty() and class_left.is_empty():
			break
		if draft_card_is_class(spec_left.size(), class_left.size()):
			out.append(class_left.pop_back())
		else:
			out.append(spec_left.pop_back())
	return out


# Queue one draft offer on a hero. The offer is ROLLED NOW and stored, so the
# cards waiting on the hero card are the cards that dropped — the same promise
# `award_ability_pick` makes for the boss pick. Returns false when there is
# nothing left to offer, which is a fact the roll knows and no caller has to
# guess at.
func award_draft_pick(member: Dictionary) -> bool:
	var offer := roll_draft_offer(member)
	if offer.is_empty():
		return false
	member["draft_candidates"] = member.get("draft_candidates", []) + [offer]
	member["draft_picks_owed"] = int(member.get("draft_picks_owed", 0)) + 1
	return true


func owed_draft_picks() -> int:
	var n := 0
	for member in party:
		n += int(member.get("draft_picks_owed", 0))
	return n


# THE ONE PLACE A DROP IS WRITTEN. Both pick paths — the boss pick and the
# draft — call it, so the no-return rule cannot be applied in one and forgotten
# in the other. It refuses anything that is not an EARNED ability, which is the
# mechanical form of "protected abilities can never be dropped": a protected
# name is simply not in this list, so there is no branch to get wrong.
func drop_earned_ability(member: Dictionary, name: String) -> bool:
	var kept := earned_ability_names(member)
	if not kept.has(name):
		return false
	kept.erase(name)
	member["bm_abilities"] = kept
	_refuse_draft(member, name)
	return true


# TAKE ONE. At the cap this is take-one-AND-DROP-ONE: the caller names the
# earned ability the incoming card replaces, and a drop that is not an EARNED
# ability is refused outright — a protected ability can never be named here.
# Returns "" on success, or the reason it was refused.
func take_draft_ability(member: Dictionary, name: String,
		drop_name := "") -> String:
	if int(member.get("draft_picks_owed", 0)) < 1:
		return "no pick is owed"
	var queue: Array = member.get("draft_candidates", [])
	if queue.is_empty() or not queue[0].has(name):
		return "that card is not in the offer"
	if owned_ability_names(member).has(name):
		return "already known"
	if ability_slots_full(member):
		if drop_name == "":
			return "the kit is full — name an ability to drop"
		if not drop_earned_ability(member, drop_name):
			return "%s cannot be dropped" % drop_name
	queue.pop_front()
	member["draft_candidates"] = queue
	member["bm_abilities"] = member.get("bm_abilities", []) + [name]
	member["draft_picks_owed"] = int(member.get("draft_picks_owed", 0)) - 1
	return ""


# DECLINING IS ALWAYS ALLOWED, at any point, full or not. A settled kit is a
# legitimate end state, and being forced to churn would make a good build worse
# as the run goes on. The WHOLE offer is refused, not just one card of it —
# otherwise the next offer keeps re-presenting exactly what was just turned
# down, which is the rule's stated reason for existing.
func decline_draft(member: Dictionary) -> bool:
	if int(member.get("draft_picks_owed", 0)) < 1:
		return false
	var queue: Array = member.get("draft_candidates", [])
	if not queue.is_empty():
		for card in queue.pop_front():
			_refuse_draft(member, String(card))
		member["draft_candidates"] = queue
	member["draft_picks_owed"] = int(member.get("draft_picks_owed", 0)) - 1
	return true


# THE MERCHANT'S PRICE, by zone — the third pick source (§3). Sits below the
# blacksmith's [150, 225, 300] on purpose: the smith buys a permanent upgrade
# to something you already hold, and BK measured it converting 41-47% of ALL
# run income. An ability is the cheaper, more frequent question.
const DRAFT_PRICES := [120, 180, 240]


func draft_price() -> int:
	var base: int = DRAFT_PRICES[clampi(zone_idx, 0, DRAFT_PRICES.size() - 1)]
	return maxi(int(round(base * (1.0 - relic_add("shop_discount")))), 1)


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
	node_idx = 0
	encounter = {}
	pending_modifier = ""
	pending_reward = {}
	pending_shop = false
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
	# v7 (Batch AN): the LINE. v8 (BATCH BK): THE LATTICE. `map[slot]` is an
	# ARRAY of nodes and the position is the PAIR (slot_idx, node_idx), so a
	# v7 save's flat 12-slot line indexes into a structure that is not there.
	# Refused and cleared on load, for the same reason AN refused pre-v7 and
	# AI refused ranked purchases: the migration would have to INVENT a row
	# the party never stood in and a set of edges they never had, on a map
	# generated after the fact. A wipe that says so beats that.
	# v9 (BATCH BL §2): the recap's new ledgers — dealt-by-ability, taken-by-
	# source, taken totals, killing blows, and the final-battle copy of all
	# four. TOLERANT, unlike the v8 refusal above: these are counters, not
	# structure, so a v8 save loads and simply starts them mid-run at zero. A
	# recap that begins counting halfway through a resumed run is a smaller lie
	# than a wiped run, which is the test v8 failed and this one passes.
	# v10 (BATCH BM): talents are META now. `party[i]["talents"]` is the
	# EQUIPPED loadout copied off Profile at the awakening and locked for the
	# run — the same {id: 1} shape, but nothing in a run writes it any more,
	# and `talent_points` / `talent_flex` are gone from the member entirely.
	# The map gained a SEVENTEENTH slot in the final zone (the end boss), so a
	# v9 save's final-zone map has no position to walk onto after its boss.
	# REFUSED AND CLEARED on load, for the same reason BK refused pre-v8: the
	# migration would have to invent a slot the party never stood in, and a
	# wipe that says so beats that.
	# v11 (BATCH CT): the pouch is SLOTTED and `items` is the slot list — a key
	# present at count 0 is a HELD, EMPTY slot, which is a state no earlier save
	# could contain. TOLERANT, not refused: a v10 save's `items` is a legal slot
	# list already (every key it holds is a type the party owns), and if it holds
	# MORE keys than the zone's slot cap allows, the pouch is simply over
	# capacity until the player discards or sells one. That is a state the UI
	# renders honestly and the player can leave, so it beats wiping the run. The
	# only genuinely new field is `pending_item_offers`, which a v10 save has
	# none of and correctly loads empty.
	file.store_var({
		"version": 11, "party": party, "items": items, "gold": gold,
		"pending_item_offers": pending_item_offers,
		"tally": tally, "debug_used": debug_used,
		"difficulty": difficulty,
		"zone_idx": zone_idx, "zone_name": zone_name, "zone_draw": zone_draw,
		"slot_idx": slot_idx, "node_idx": node_idx, "seen_events": seen_events,
		"pending_shop": pending_shop, "specs_chosen": specs_chosen,
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
	# Batch BK: a pre-v8 save describes a board this build cannot render or
	# walk. Refuse it and delete it, rather than half-loading a run whose
	# every "next node" call would index a dictionary that is not there.
	if save_version < 10:
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
	node_idx = int(data.get("node_idx", 0))
	pending_shop = bool(data.get("pending_shop", false))
	specs_chosen = data["specs_chosen"]
	active_relics = data["active_relics"]
	map = data["map"]
	combat_wins = int(data.get("combat_wins", 0))
	difficulty = difficulty_id(String(data.get("difficulty", "wanderer")))
	seen_events = data.get("seen_events", [])
	# Pre-Z saves carry no ledger: start one mid-run rather than crash the
	# summary — its counts just begin at the load point.
	tally = data.get("tally", {})
	if tally.is_empty():
		reset_tally()
	# BATCH BL §2: a v8 save carries a tally with none of the recap's new keys.
	# Seed the missing ones rather than refusing the save — every writer above
	# assumes they exist, and a resumed run should lose the recap's history, not
	# the run.
	for k in ["dealt", "taken", "taken_total"]:
		if not (tally.get(k) is Dictionary):
			tally[k] = {}
	if not (tally.get("kills") is Array):
		tally["kills"] = []
	if not (tally.get("final") is Dictionary):
		tally["final"] = {"dealt": {}, "taken": {}, "taken_total": {}, "kills": []}
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
	# BATCH CT §3: a v10 save has no offers and loads with none, which is right —
	# it was written by a build that could not create one.
	pending_item_offers = data.get("pending_item_offers", [])
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
		# BATCH BM: there is no in-run purse to refund into any more. An id
		# the live tree no longer holds is simply DROPPED — the meta ledger
		# already refunded its cell when the tree changed under it, and a
		# member carrying a node that does not exist is the only real hazard.
		var learned: Dictionary = member.get("talents", {})
		for id in learned.keys():
			if Talents.node_in_tree(live_tree, id).is_empty():
				learned.erase(id)
		member["talents"] = learned


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
		"endboss":
			# Nothing follows it, so the gold is a flourish rather than a
			# budget — the relic is the reward (Batch BM §6).
			amount = randi_range(150, 180)
	amount = int(round(amount * (1.0 + relic_add("gold_find_mult"))))
	gold += amount
	tally_add("gold_earned", amount)
	return amount


# BATCH BM §6 — THERE IS NO IN-RUN TALENT POINT. `award_talent_points` and
# `award_spec_point` ARE DELETED, not zeroed, per the standing rule that dead
# things are deleted; so are `member["talent_points"]` and `talent_flex`.
# Fights, elites and mini-bosses award what they always did MINUS the point;
# a ZONE BOSS banks a META point to Profile instead — same trigger, different
# destination — and the END BOSS awards a relic and no points at all.
#
# EVERY HISTORICAL FIGURE THOSE SITES PRODUCED IS SUPERSEDED, including BK's
# 10.9 / 10.8 / 6.0 talent points per hero per run and every "nodes owned
# entering a boss" reading. Those measured a per-run purse that no longer
# exists; do not compare any post-BM number against them.

# 1 point per spec per zone boss, to Profile, for the specs that were in the
# party. Called from BOTH victory paths (battle.gd and RunSim), and NEVER by
# a sim — a simulated run must not touch the player's ledger, so the caller
# checks `sim_run` exactly as it does for save_run.
func bank_zone_boss_points() -> void:
	if sim_run:
		return
	Profile.award_zone_boss_points(party.map(func(m): return m.get("spec", "")))


# THE HANDOFF FROM THE META LAYER INTO THE RUN, called the moment a spec is
# confirmed — from BOTH paths (the spec screen and RunSim.start_run), the
# sync_spec_hp pattern. It copies the loadout the player configured BETWEEN
# runs onto the member, and from here it is locked: nothing in a run writes
# `member["talents"]` again.
func equip_spec_talents(idx: int) -> void:
	if idx < 0 or idx >= party.size():
		return
	var spec := String(party[idx].get("spec", ""))
	party[idx]["talents"] = Profile.equipped_talents(spec) if not sim_run \
		else sim_equipped_talents(spec)


# The sim's own loadout source. A sim must never read Profile (it would make
# every baseline depend on whoever ran it), so RunSim installs the build it
# was asked for here and this returns it.
var sim_talents := {}   # spec -> {id: 1}


func sim_equipped_talents(spec: String) -> Dictionary:
	return (sim_talents.get(spec, {}) as Dictionary).duplicate()


# ---------- Batch AN §6: the item cap ----------

# Every grant of a consumable goes through here. Returns how many actually
# landed, so the caller can say "refused" instead of pretending.
#
# THERE ARE NOW TWO WALLS AND THEY MEAN DIFFERENT THINGS (BATCH CT §3):
#   * the STACK CAP is per ITEM TYPE — six Health Potions and six Bombs is
#     legal — and a grant over it is REFUSED with a message. That rule is
#     Batch AN's and it STANDS.
#   * the SLOT CAP is per POUCH, and a grant that has no slot is NOT refused:
#     it becomes a SWAP OFFER (§3). `add_item` still returns 0 for it, because
#     nothing landed — but callers must ask `needs_slot()` FIRST and route to
#     the offer instead of printing "cannot hold more". The two must never be
#     conflated: NO ROOM IS A CHOICE, A FULL STACK IS A WALL.
func add_item(id: String, count := 1) -> int:
	if not items.has(id) and slots_free() < 1:
		return 0
	var have := int(items.get(id, 0))
	var room := maxi(item_stack_cap(id) - have, 0)
	var landed := mini(count, room)
	if landed > 0:
		items[id] = have + landed
	return landed


# The stack cap for one type: the §4 exceptions, else Batch AN's six.
func item_stack_cap(id: String) -> int:
	return int(ITEM_STACK_CAPS.get(id, ITEM_CAP))


func item_full(id: String) -> bool:
	return int(items.get(id, 0)) >= item_stack_cap(id)


# ---------- BATCH CT §1/§2/§3: the slot cap ----------

# Slots grow 4 -> 5 -> 6 with the zone. Clamped at both ends so a zone index
# past the ladder (the end boss sits in the last zone) keeps the last value
# rather than reading off the end.
func item_slots() -> int:
	return int(ITEM_SLOTS_BY_ZONE[clampi(zone_idx, 0, ITEM_SLOTS_BY_ZONE.size() - 1)])


# A held type occupies its slot whether or not the stack has anything left
# in it — see the note on ITEM_SLOTS_BY_ZONE for why that is the load-bearing
# half of the whole cap.
func slots_used() -> int:
	return items.size()


func slots_free() -> int:
	return maxi(item_slots() - slots_used(), 0)


# True when this type would need a NEW slot and there is none — i.e. the §3
# swap-offer case, as distinct from a full stack.
func needs_slot(id: String) -> bool:
	return not items.has(id) and slots_free() < 1


# §2: both of these free the slot ENTIRELY. A partial stack cannot be split
# across slots, so there is no "discard three of six" — the type goes.
func discard_item(id: String) -> bool:
	if not items.has(id):
		return false
	items.erase(id)
	return true


# §3: take the offered type, giving up `drop_id` to make the room. One call so
# the erase and the add can never half-happen.
func swap_item(drop_id: String, take_id: String, count := 1) -> bool:
	if not items.has(drop_id) or items.has(take_id):
		return false
	items.erase(drop_id)
	return add_item(take_id, count) > 0


# §3: queue a grant that has no slot. Returns true when the offer was made,
# false when the type is at its STACK cap and there is nothing to offer — the
# two cases the brief insisted must not be conflated.
func offer_item(id: String) -> bool:
	if not needs_slot(id):
		return false
	pending_item_offers.append(id)
	return true


# ---------- BATCH CT §6: the item values, in one place ----------
#
# Battle and map both call these rather than repeating a literal. Every one
# is a percentage or scales with run depth, which is the standing rule this
# batch records: A FLAT NUMBER IN THE POUCH DECAYS AGAINST A PARTY THAT GROWS.

func health_potion_heal(max_hp: int) -> int:
	return maxi(int(round(max_hp * HEALTH_POTION_PCT)), 1)


func mana_potion_restore(max_resource: int) -> int:
	return maxi(int(round(max_resource * MANA_POTION_PCT)), 1)


# The Bomb rides the heroes' own +2%-per-win rate, so a run OPENS unchanged
# at 50 and keeps pace after. `combat_wins` is the same counter battle.gd
# scales hero Attack and HP off.
func bomb_damage() -> int:
	return int(round(BOMB_BASE_DAMAGE * (1.0 + BOMB_WIN_SCALE * combat_wins)))


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
# BATCH BM §5, TWIST ONE: THE SEVERITY FLOOR RISES WITH THE RUNG. The
# guaranteed mild option is still guaranteed — the floor is still enforced by
# construction rather than by rejecting rolls — but "mild" means severity <=
# 2 at rung 1, <= 3 at rung 2 and <= 4 at rung 3, so by the top rung the safe
# slot is only nominally safe. Every offer still reads ONE SAFE, TWO GAMBLES.
func roll_offer() -> Array:
	var floor_sev := int(difficulty_def()["severity_floor"])
	var low: Array = []
	var rest: Array = []
	for id in MODIFIERS:
		if modifier_severity(String(id)) <= floor_sev:
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


# BATCH BM §5, TWIST TWO: FIXED ENCOUNTERS CARRY A MODIFIER, which today
# they never do. The mini-boss, the three zone bosses and the end boss are
# the only nodes a route cannot duck, so a modifier on them is a real
# escalation the player has to build against rather than route around.
# It is NOT a bargain: there is no offer, no choice and NO REWARD — the
# modifier is the rung's, not something the player bought. Rung 3 only.
const FIXED_MODIFIER_NODES := ["miniboss", "boss", "endboss"]


func arm_fixed_modifier(node_type: String) -> void:
	if not bool(difficulty_def()["fixed_modifier"]):
		return
	if not node_type in FIXED_MODIFIER_NODES:
		return
	if pending_modifier != "":
		return  # a bargain already armed one; never stack two
	var pool: Array = []
	for id in MODIFIERS:
		if modifier_severity(String(id)) >= 3:
			pool.append(String(id))
	if pool.is_empty():
		return
	pending_modifier = String(pool.pick_random())


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
			# BATCH CT §3/§7: the bargain's potion is a grant like any other, so
			# it splits the same three ways. NO SLOT is a swap offer waiting on the
			# map; a FULL STACK is still the flat refusal Batch AN wrote — and the
			# refusal now names the type's OWN cap instead of a hardcoded "six",
			# which stopped being true the moment §4 gave three items smaller ones.
			if offer_item(id):
				return {"text": "The bargain offered a %s — no room in the pouch.\nChoose on the map." \
					% ITEM_INFO[id][0], "shop": false}
			if add_item(id) < 1:
				return {"text": "The bargain offered a %s — the heroes are already carrying %d."
					% [ITEM_INFO[id][0], item_stack_cap(id)], "shop": false}
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
			pending_shop = true
			return {"text": "A merchant follows the fight.", "shop": true}
	return {"text": "", "shop": false}


# ---------- Batch BK §3/§5: what follows a cleared slot ----------

# NOTHING ROLLS BEHIND A FIGHT ANY MORE. `roll_merchant` (40% with a
# four-slot drought floor), `roll_event` (25%), `slots_since_merchant`,
# `MERCHANT_CHANCE`/`MERCHANT_FLOOR`/`EVENT_CHANCE` and the `pending_after`
# queue are all DELETED, not left unreachable — the merchant and the event
# are map nodes now, and a node you can see coming is the whole point of
# putting them on the board. A rolled merchant and a routed merchant are two
# economies; keeping the roll would have run both.
#
# THE ONE SURVIVOR is the bargain's "a merchant follows the fight" reward,
# and it survives because it is BOUGHT rather than rolled: the player took a
# severity-4 modifier to get it. One boolean, not a queue.
var pending_shop := false


# Where a screen goes when it is done. The bought merchant is the only thing
# that can sit between a victory and the map.
func next_after_scene() -> String:
	if pending_shop:
		pending_shop = false
		return "res://scenes/shop.tscn"
	return "res://scenes/map.tscn"


# Arm the event a MERCHANT/EVENT node draws when the party steps onto it.
# Returns false when nothing is eligible (the pool is spent for this run and
# every requirement filtered) — the caller walks on rather than showing an
# empty screen.
func begin_event_node() -> bool:
	pending_event = Events.pick(self)
	if pending_event == "":
		return false
	seen_events.append(pending_event)
	if not sim_run:
		Profile.note_event(pending_event)
	return true


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
#
# BATCH CN UPDATE — THE FIRST OBJECTION IS GONE AND THE SECOND IS NOT. The
# window IS a parameter now (`battle.SC_PROFILE_DEFAULT`, handed to the check
# per cast), and the zone rect is resized from the same dictionary that grades,
# so a widened Perfect window would be graded and DRAWN correctly. `up_sure` is
# writable. IT WAS STILL NOT WRITTEN AT CN, because the harder objection stands
# untouched: **the bot never runs the bar.** It rolls a grade off hardcoded
# probabilities, so a widened window remains invisible to every sim the project
# owns, and an upgrade whose worth cannot be measured is one nobody can tune.
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
# the wiring exists to close.
#
# BATCH CZ §4 — "SWIFT FITS EVERYTHING BECAUSE EVERY ABILITY HAS A DELAY" WAS
# TRUE FOR EIGHT BATCHES AND STOPPED BEING TRUE WITHOUT A LINE CHANGING HERE.
# CY capped the pure buffs at 1.0 and Swift's floor was a literal 1.0, so on 52
# cards the reward became a no-op — the exact dud this function exists to refuse,
# arriving through the one branch that never asked. It asks now.
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
		"up_speed":
			# BATCH CZ §4 — SWIFT NO LONGER "FITS EVERYTHING". It fits every
			# ability that is not already AT the floor, which is the honest
			# version of the same claim and the one that stops the reward being
			# offered where it buys nothing. Nothing in the shipped game sits at
			# the floor today (the cheapest card is a capped buff at twice it),
			# so this changes no offer — it is what keeps the dud closed if a
			# later batch authors something cheaper.
			return ab.delay > Ability.DELAY_FLOOR
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
			# BATCH CZ §4 — THE FLOOR IS `Ability.DELAY_FLOOR`, NOT A LITERAL.
			# It WAS a literal 1.0, and CY's cap landed exactly on it: every one
			# of the 52 pure buffs came down to 1.0 and Swift stopped doing
			# anything at all on any of them, overnight and in silence. The
			# floor is written against the cap now (half of it), so the two can
			# never collide again — CR's rule, one rung further down: a value is
			# not finished when every site that COMPUTES it is updated, it is
			# finished when every site that QUOTES it is.
			ab.delay = maxf(ab.delay * 0.75, Ability.DELAY_FLOOR)
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


# Has this hero already taken this upgrade, on any ability? THIS IS AP'S
# ONCE-PER-RUN RULE and it has exactly one consumer, `roll_upgrade_offer` —
# i.e. the MINI-BOSS PICK POOL.
#
# BATCH BK: A BOUGHT UPGRADE IS SKIPPED HERE. The blacksmith writes into the
# same `member["upgrades"]` list on purpose (one list is what makes a bought
# upgrade land, wear its ◆ and hover exactly like an awarded one), and if this
# function counted those entries then buying Honed in zone 1 would quietly
# delete Honed from that hero's mini-boss offers for the rest of the run —
# a purchase eating out of the award economy, which is the subtler half of
# §9's "a blacksmith purchase must not consume a mini-boss slot". The flag is
# read HERE and nowhere else: `apply_upgrades` stamps bought and awarded
# entries identically, and the never-twice-on-one-ability check in
# `roll_blacksmith_offer` counts both, because that one is about the ABILITY
# rather than about either pool.
func has_upgrade(member: Dictionary, id: String) -> bool:
	for up in member.get("upgrades", []):
		if String(up.get("id", "")) == id and not bool(up.get("bought", false)):
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


# ---------- Batch BK §3: the blacksmith ----------

# THE GOLD SINK. Batch BJ measured 63% of every run's gold going UNSPENT, with
# 13.6 shop-rune refusals a run for no free slot against 6.8 for the reserve —
# slots are what binds, not prices, so more shop stock could never have fixed
# it. A BLACKSMITH CONSUMES NO SLOT. It sells the ability upgrade Batch AP
# already wired, filtered by AP §3's eligibility rules, marked with the same ◆
# on the same chip. This is that system with a price tag on it and no new
# machinery underneath.
#
# PRICE IS SET FROM BJ'S NUMBERS, NOT FROM A GUESS, and the arithmetic is
# written down so the next batch can argue with it rather than re-derive it:
# 2386 gold earned and 881 spent a run at 36 encounters is 1505 dead. At 48
# encounters that scales to ~2050 before the merchant's frequency change makes
# it worse. A route walks ~2 blacksmiths a zone, so 6 visits at these prices
# is 150+150+225+225+300+300 = 1350 — about two thirds of the dead gold, which
# leaves the potion economy something to breathe with. Zone-scaled so late
# gold still has somewhere to go.
const BLACKSMITH_PRICES := [150, 225, 300]


func blacksmith_price() -> int:
	var base: int = int(BLACKSMITH_PRICES[clampi(zone_idx, 0,
		BLACKSMITH_PRICES.size() - 1)])
	return maxi(int(round(base * (1.0 - relic_add("shop_discount")))), 1)


# Three {member_idx, id, ability} pairings, drawn across the WHOLE party.
#
# TWO RULES, AND THE DIFFERENCE BETWEEN THEM IS THE WHOLE POINT:
#   AP's once-per-run rule (`has_upgrade`) IS NOT CONSULTED. That rule governs
#   the MINI-BOSS PICK POOL — it exists so three mini-bosses cannot hand out
#   three Honeds — and a blacksmith is not that pool. A player may buy Honed in
#   zone 1 and again in zone 3 on a different ability, which is what makes gold
#   a real second axis into the same system.
#   Never twice on ONE ability still holds, and it is enforced here: a pairing
#   whose (ability, upgrade) the hero already carries is never offered. Buying
#   the same upgrade twice on the same ability is the dud AP §3 exists to stop.
#
# Fewer than three when the party has bought most of what fits — the counter
# shows what exists rather than padding.
func roll_blacksmith_offer() -> Array:
	var pool: Array = []
	for i in party.size():
		var member: Dictionary = party[i]
		var carried := {}
		for up in member.get("upgrades", []):
			carried["%s|%s" % [String(up.get("ability", "")),
				String(up.get("id", ""))]] = true
		for n in owned_ability_names(member):
			var name := String(n)
			if name == "Strike":
				continue
			var ab: Ability = Classes.pool_ability(name)
			if ab == null:
				continue  # unresolvable (a class core attack) — AP drops these too
			for id in ABILITY_UPGRADES:
				var uid := String(id)
				if carried.has("%s|%s" % [name, uid]):
					continue
				if not upgrade_fits(uid, ab):
					continue
				pool.append({"member_idx": i, "id": uid, "ability": name})
	pool.shuffle()
	# One pairing per hero at most, so a counter never reads as three offers
	# for the Berserker and nothing for anyone else.
	var offer: Array = []
	var seen_members := {}
	for entry in pool:
		if seen_members.has(int(entry["member_idx"])):
			continue
		seen_members[int(entry["member_idx"])] = true
		offer.append(entry)
		if offer.size() == 3:
			break
	return offer


# Take the gold and stamp the purchase onto the member's own `upgrades` list —
# the SAME list the mini-boss pick writes and the same one `apply_upgrades`
# reads, so a bought upgrade lands, shows its ◆ and hovers exactly like an
# awarded one. False when the party cannot pay.
func buy_blacksmith(pairing: Dictionary) -> bool:
	var price := blacksmith_price()
	if gold < price:
		return false
	var member: Dictionary = party[int(pairing["member_idx"])]
	gold -= price
	tally_add("gold_spent", price)
	# `bought` is read by has_upgrade ALONE — see the note there. Everything
	# else in the project treats a bought upgrade and an awarded one as the
	# same thing, which is the whole point of reusing the list.
	member["upgrades"] = member.get("upgrades", []) + [
		{"id": String(pairing["id"]), "ability": String(pairing["ability"]),
			"bought": true}]
	return true


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
