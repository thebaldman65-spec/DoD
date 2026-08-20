# Event nodes (Batch 38): every event lives in data/events.json — title,
# flavor text, selection weight, requirement conditions, and choices
# whose effects are verbs from the dispatch table below. Adding an event
# is a JSON edit; adding a VERB is one handler here. The run object is
# passed in explicitly (never read as an autoload) so headless tests can
# drive events against a bare run_state instance.
#
# BATCH BK §4 — EVENTS ARE RESOURCE CONVERSIONS NOW, in three kinds, and
# every entry carries its `kind`:
#   tradeoff (60%)  two or three conversions plus a DECLINE that is always
#                   available. Health for a rune, gold for maximum health,
#                   health for talent points — a rate offered, taken or not.
#   boon     (25%)  a straight benefit, no cost.
#   bane     (15%)  a straight detriment, and ONE choice: a bane the player
#                   could not have avoided is only fair if it costs a
#                   RESOURCE, never a run.
# THE THREE SHARE ONE ICON ON THE MAP AND ONE COLOUR. A node that announced
# itself as a bane would simply never be walked onto — it would be a wall
# with extra steps rather than a gamble. `kind` is read HERE, by the draw,
# and nowhere the player can see.
#
# NO BANE MAY REDUCE A HERO BELOW 1 HP, and that is a property of the verbs
# rather than of the authoring: `damage_pct` floors at 1 and `max_hp_pct`
# floors max HP at 10 and re-clamps HP into [1, max]. test_batch_bk drives
# every bane against a 1-HP party as the negative control.
#
# THE EFFECT VOCABULARY (the load-bearing part — 15 events is nothing,
# the schema is everything):
#   gold          {amount}                 +/- flat gold (floors at 0)
#   gold_pct      {amount}                 +/- fraction of current gold
#   heal_pct      {amount, target}         heal % of max HP (living only)
#   damage_pct    {amount, target}         lose % of max HP (never kills:
#                                          floors at 1 HP)
#   mana_pct      {amount, target}         +/- % of max Mana
#   max_hp_pct    {amount, target}         permanent-for-run max HP shift
#                                          (floors at 10; HP re-clamped)
#   attack_pct    {amount, target}         permanent-for-run Attack shift
#                                          (member event_attack_pct, read
#                                          at battle spawn)
#   item          {id, count}              grant/remove a consumable
#   random_item   {count}                  LOOT_POOL rolls
#   revive_pct    {amount}                 all fallen return at % max HP
#   relic_grant   {}                       random inactive relic joins the
#                                          run (slots full = 40g instead)
#
# TARGET SELECTORS: "party" (default) | "random" | "lowest_hp"
#   | "class:<warrior|mage|cleric|hunter>" — living members only, except
#   revive_pct which exists for the dead.
#
# REQUIREMENT CONDITIONS (event-level gates selection, choice-level
# greys the button): min_gold, max_gold, zone_slot [slots], has_item
# {id}, spec_in_party [spec ids], fallen_hero (bool).
class_name Events

const DATA_PATH := "res://data/events.json"

const VERBS := ["gold", "gold_pct", "heal_pct", "damage_pct", "mana_pct",
	"max_hp_pct", "attack_pct", "item", "random_item",
	"revive_pct", "relic_grant", "rune_grant", "ability_draft"]

# §4's own worked example — "health for a rune" — needs a rune the event can
# hand over, and nothing in the vocabulary could hand one over. ONE new verb,
# routed through Run.grant_rune (the same door the elite cache and the rich
# arm already use), so an event rune is generated, priced and scoped exactly
# like every other rune. Equipped on arrival when a slot is free, pouched
# when it is not: an event must not be the one source that can overfill.
#
# NOT WRITTEN, and the reason is worth keeping: §4 also suggests "a held rune
# for two of lower rarity". That needs a rune to be SURRENDERED, and nothing
# in the project has ever removed a rune from a hero — `equipped` is written
# in one place and the pouch only ever grows. Building the removal path for
# one event would put a second, untested writer next to the one careful one.
const KIND_WEIGHTS := {"tradeoff": 60, "boon": 25, "bane": 15}

static var _data := {}


static func _load() -> Dictionary:
	if _data.is_empty():
		var f := FileAccess.open(DATA_PATH, FileAccess.READ)
		_data = JSON.parse_string(f.get_as_text())
	return _data


static func ids() -> Array:
	return _load().keys()


static func config(id: String) -> Dictionary:
	return _load().get(id, {})


# Weighted, requirement-filtered, non-repeating draw. Every event seen
# this run is excluded until nothing is left, then the seen filter is
# dropped (a 20-entry pool against ~5 events a run makes that rare).
#
# BATCH BK §4: the KIND is drawn first, at 60/25/15, and the weight inside
# `kind` decides which entry of that kind. Drawing the kind first is what
# makes the ratio a property of the design rather than of how many events
# happen to be authored — adding a ninth boon must not make boons commoner.
# A kind with nothing eligible left falls through to the whole pool rather
# than returning nothing: a spent bane pool should not close the node.
static func pick(run: Node) -> String:
	var seen: Array = run.get("seen_events")
	var fresh := _eligible(run, seen)
	if fresh.is_empty():
		fresh = _eligible(run, [])
	if fresh.is_empty():
		return ""
	var want := _draw_kind()
	var of_kind: Array = fresh.filter(
		func(id): return String(config(String(id)).get("kind", "boon")) == want)
	return _weighted(of_kind if not of_kind.is_empty() else fresh)


static func _draw_kind() -> String:
	var total := 0
	for k in KIND_WEIGHTS:
		total += int(KIND_WEIGHTS[k])
	var roll := randi_range(1, total)
	for k in KIND_WEIGHTS:
		roll -= int(KIND_WEIGHTS[k])
		if roll <= 0:
			return String(k)
	return "tradeoff"


static func _weighted(ids: Array) -> String:
	if ids.is_empty():
		return ""
	var total := 0
	for id in ids:
		total += int(config(String(id)).get("weight", 10))
	var roll := randi_range(1, total)
	for id in ids:
		roll -= int(config(String(id)).get("weight", 10))
		if roll <= 0:
			return String(id)
	return String(ids.back())


static func kind(id: String) -> String:
	return String(config(id).get("kind", "boon"))


static func _eligible(run: Node, seen: Array) -> Array:
	var out: Array = []
	for id in _load():
		if not seen.has(id) and requires_met(run, config(id).get("requires", {})):
			out.append(id)
	return out


static func requires_met(run: Node, req: Dictionary) -> bool:
	return failed_reason(run, req) == ""


# The single implementation of the requirement check (Batch AC): returns
# "" when the requirement is met, otherwise a human sentence naming the
# FIRST condition that failed. requires_met above is this function read as
# a boolean, so the greyed-out choice tooltip on the event screen and the
# pass/fail column in the debug event picker can never disagree with the
# gate that actually filters the draw.
static func failed_reason(run: Node, req: Dictionary) -> String:
	if req.is_empty():
		return ""
	if req.has("min_gold") and int(run.get("gold")) < int(req["min_gold"]):
		return "Needs %d gold (party has %d)." % [int(req["min_gold"]),
			int(run.get("gold"))]
	if req.has("max_gold") and int(run.get("gold")) > int(req["max_gold"]):
		return "Needs %d gold or less (party has %d)." % [int(req["max_gold"]),
			int(run.get("gold"))]
	if req.has("zone_slot") and not _slot_listed(req["zone_slot"],
			int(run.get("zone_idx")) + 1):
		var slots := PackedStringArray()
		for slot in req["zone_slot"]:
			slots.append(str(int(slot)))
		return "Only in zone %s (party is in zone %d)." % [
			"/".join(slots), int(run.get("zone_idx")) + 1]
	if req.has("has_item"):
		var items: Dictionary = run.get("items")
		if int(items.get(String(req["has_item"]), 0)) <= 0:
			return "Needs a %s." % run.ITEM_INFO[String(req["has_item"])][0]
	if req.has("spec_in_party"):
		var found := false
		var names := PackedStringArray()
		for spec in req["spec_in_party"]:
			names.append(String(Classes.SPEC_INFO.get(String(spec), {}).get(
				"name", spec)))
		for member in run.get("party"):
			if req["spec_in_party"].has(String(member.get("spec", ""))):
				found = true
		if not found:
			return "Needs one of: %s, in the party." % ", ".join(names)
	if req.has("fallen_hero"):
		var any_fallen := false
		for member in run.get("party"):
			if int(member["hp"]) <= 0:
				any_fallen = true
		if bool(req["fallen_hero"]) != any_fallen:
			return "Needs a fallen hero." if bool(req["fallen_hero"]) \
				else "Needs the whole party standing."
	return ""


# JSON arrays hold floats; slots are ints — compare loosely.
static func _slot_listed(slots: Array, slot: int) -> bool:
	return slots.has(slot) or slots.has(float(slot))


# ---------- the dispatch table ----------

# Applies one effect to the run; returns the human summary line the
# event screen prints ("" = silent no-op).
static func apply(run: Node, fx: Dictionary) -> String:
	var amount := float(fx.get("amount", 0.0))
	match String(fx.get("effect", "")):
		"gold":
			run.set("gold", maxi(int(run.get("gold")) + int(amount), 0))
			return "%+d gold" % int(amount)
		"gold_pct":
			var delta := int(round(int(run.get("gold")) * amount))
			run.set("gold", maxi(int(run.get("gold")) + delta, 0))
			return "%+d gold" % delta
		"heal_pct":
			var healed := PackedStringArray()
			for m in _targets(run, fx):
				var gain := int(round(int(m["max_hp"]) * amount))
				m["hp"] = mini(int(m["hp"]) + gain, int(m["max_hp"]))
				healed.append(_who(m))
			return "%s heal%s %d%%" % [", ".join(healed),
				"s" if healed.size() == 1 else "", int(round(amount * 100))]
		"damage_pct":
			var hurt := PackedStringArray()
			for m in _targets(run, fx):
				m["hp"] = maxi(int(m["hp"])
					- int(round(int(m["max_hp"]) * amount)), 1)
				hurt.append(_who(m))
			return "%s lose%s %d%% health" % [", ".join(hurt),
				"s" if hurt.size() == 1 else "", int(round(amount * 100))]
		"mana_pct":
			for m in _targets(run, fx):
				m["mana"] = clampi(int(m["mana"])
					+ int(round(int(m["max_mana"]) * amount)), 0, int(m["max_mana"]))
			return "%+d%% Mana" % int(round(amount * 100))
		"max_hp_pct":
			for m in _targets(run, fx):
				m["max_hp"] = maxi(int(round(int(m["max_hp"]) * (1.0 + amount))), 10)
				m["hp"] = clampi(int(m["hp"]), 1, int(m["max_hp"]))
			return "%+d%% max health" % int(round(amount * 100))
		"attack_pct":
			var blessed := PackedStringArray()
			for m in _targets(run, fx):
				m["event_attack_pct"] = float(m.get("event_attack_pct", 0.0)) + amount
				blessed.append(_who(m))
			return "%s: %+d%% Attack for the run" % [", ".join(blessed),
				int(round(amount * 100))]
		"item":
			# BATCH CT §7 — BOTH ITEM VERBS GO THROUGH `Run` NOW. They wrote
			# `items[id]` directly before this batch, which meant an event grant
			# ignored the per-type stack cap entirely — Batch AN's six was already
			# reachable past by "The Cache" and its kin, silently. With a SLOT cap
			# on top of that, a direct write would also have conjured a whole new
			# slot out of nothing, so the leak is closed rather than widened.
			#
			# A NEGATIVE COUNT IS A TAKE, and it still writes directly: Spoiled
			# Stores removes a potion, no cap applies to a removal, and — the part
			# that matters — it MUST NOT free the slot. A stack falling to zero
			# keeps its slot (§1); only a discard or a sale releases one.
			var items: Dictionary = run.get("items")
			var id := String(fx.get("id", "health"))
			var count := int(fx.get("count", 1))
			if count < 0:
				if not items.has(id):
					return ""
				var was := int(items.get(id, 0))
				items[id] = maxi(was + count, 0)
				return "%+d %s" % [items[id] - was, run.ITEM_INFO[id][0]]
			if run.offer_item(id):
				return "%s — no room in the pouch; choose on the map" % run.ITEM_INFO[id][0]
			var landed: int = run.add_item(id, count)
			if landed < 1:
				return "%s — the party can carry no more" % run.ITEM_INFO[id][0]
			return "%+d %s" % [landed, run.ITEM_INFO[id][0]]
		"random_item":
			var got := PackedStringArray()
			for i in int(fx.get("count", 1)):
				var id: String = run.random_loot()
				if run.offer_item(id):
					got.append("%s (no room — choose on the map)" % run.ITEM_INFO[id][0])
					continue
				if run.add_item(id) < 1:
					got.append("%s (already at the cap)" % run.ITEM_INFO[id][0])
					continue
				got.append(run.ITEM_INFO[id][0])
			return "found: %s" % ", ".join(got)
		"revive_pct":
			var raised := PackedStringArray()
			for m in run.get("party"):
				if int(m["hp"]) <= 0:
					m["hp"] = maxi(int(round(int(m["max_hp"]) * amount)), 1)
					raised.append(_who(m))
			if raised.is_empty():
				return ""
			return "%s return%s at %d%% health" % [", ".join(raised),
				"s" if raised.size() == 1 else "", int(round(amount * 100))]
		"rune_grant":
			# Onto a hero with a free slot first — a rune that arrives worn is
			# a rune that does something. Everyone full: it goes in the pouch,
			# where the map screen's slot buttons can still reach it.
			var granted := PackedStringArray()
			for i in int(fx.get("amount", 1)):
				var open_slot: Array = []
				for m in run.get("party"):
					var worn := 0
					for r in m.get("runes", []):
						if r.get("equipped", false):
							worn += 1
					if worn < run.rune_slots():
						open_slot.append(m)
				var pool: Array = open_slot if not open_slot.is_empty() \
					else run.get("party")
				if pool.is_empty():
					break
				var taker: Dictionary = pool.pick_random()
				var rune: Dictionary = run.grant_rune(taker)
				if rune.is_empty():
					break  # runes off — say nothing rather than lie
				rune["equipped"] = not open_slot.is_empty()
				taker["runes"] = taker.get("runes", []) + [rune]
				granted.append("%s (%s)" % [String(rune["name"]), _who(taker)])
			if granted.is_empty():
				return ""
			return "RUNE: %s" % ", ".join(granted)
		"ability_draft":
			# BATCH BO §3 — SOME EVENTS OFFER A DRAFT AS A TRADE, the fourth
			# pick source. It grants the OFFER, not a named ability: three
			# cards drawn now and resolved on the hero's card by the same
			# overlay every other owed pick uses.
			#
			# The selector picks who, so an event can hand it to the party's
			# weakest, to a class, or at random — but a hero with nothing left
			# in its pool is SKIPPED rather than paid a dead pick, which is the
			# rune verb's own "say nothing rather than lie" rule. A Warrior's
			# draft pool is empty until its tranche lands, so this branch is
			# reachable today and not a theoretical guard.
			var drafted := PackedStringArray()
			for m in _targets(run, fx):
				if run.award_draft_pick(m):
					drafted.append(_who(m))
			if drafted.is_empty():
				return ""
			return "THE DRAFT: %s may choose a new ability" % ", ".join(drafted)
		"relic_grant":
			# Optional {"tier": "common"|"rare"} narrows the pool (Batch 39
			# tiering exists exactly so events can promise rarity).
			var active: Array = run.get("active_relics")
			if active.size() >= 3:
				run.set("gold", int(run.get("gold")) + 40)
				return "relic slots full — +40 gold instead"
			var want_tier := String(fx.get("tier", ""))
			var pool: Array = Relics.POOL.keys().filter(func(id): return not active.has(id) \
				and (want_tier == "" or String(Relics.POOL[id].get("tier", "common")) == want_tier))
			if pool.is_empty():
				run.set("gold", int(run.get("gold")) + 40)
				return "nothing left to unearth — +40 gold instead"
			var relic_id: String = pool.pick_random()
			active.append(relic_id)
			return "RELIC: %s" % String(Relics.POOL[relic_id].get("name", relic_id))
	push_warning("Events: unknown effect verb '%s'" % fx.get("effect", ""))
	return ""


# Living members matching the selector (revive_pct handles its own dead).
static func _targets(run: Node, fx: Dictionary) -> Array:
	var living: Array = []
	for m in run.get("party"):
		if int(m["hp"]) > 0:
			living.append(m)
	if living.is_empty():
		return []
	var sel := String(fx.get("target", "party"))
	if sel == "party":
		return living
	if sel == "random":
		return [living.pick_random()]
	if sel == "lowest_hp":
		var low: Dictionary = living[0]
		for m in living:
			if float(m["hp"]) / float(m["max_hp"]) \
					< float(low["hp"]) / float(low["max_hp"]):
				low = m
		return [low]
	if sel.begins_with("class:"):
		var key := sel.get_slice(":", 1)
		return living.filter(func(m): return String(m["key"]) == key)
	push_warning("Events: unknown target selector '%s'" % sel)
	return living


static func _who(member: Dictionary) -> String:
	var spec := String(member.get("spec", ""))
	if spec != "" and Classes.SPEC_INFO.has(spec):
		return Classes.SPEC_INFO[spec]["name"]
	return String(member["key"]).capitalize()
