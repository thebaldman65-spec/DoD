# Event nodes (Batch 38): every event lives in data/events.json — title,
# flavor text, selection weight, requirement conditions, and choices
# whose effects are verbs from the dispatch table below. Adding an event
# is a JSON edit; adding a VERB is one handler here. The run object is
# passed in explicitly (never read as an autoload) so headless tests can
# drive events against a bare run_state instance.
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
#   talent_points {amount, target}         grant talent points
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
	"max_hp_pct", "attack_pct", "talent_points", "item", "random_item",
	"revive_pct", "relic_grant"]

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
# dropped (40-event pools will make that rare).
static func pick(run: Node) -> String:
	var seen: Array = run.get("seen_events")
	var fresh := _eligible(run, seen)
	if fresh.is_empty():
		fresh = _eligible(run, [])
	if fresh.is_empty():
		return ""
	var total := 0
	for id in fresh:
		total += int(config(id).get("weight", 10))
	var roll := randi_range(1, total)
	for id in fresh:
		roll -= int(config(id).get("weight", 10))
		if roll <= 0:
			return id
	return fresh.back()


static func _eligible(run: Node, seen: Array) -> Array:
	var out: Array = []
	for id in _load():
		if not seen.has(id) and requires_met(run, config(id).get("requires", {})):
			out.append(id)
	return out


static func requires_met(run: Node, req: Dictionary) -> bool:
	if req.is_empty():
		return true
	if req.has("min_gold") and int(run.get("gold")) < int(req["min_gold"]):
		return false
	if req.has("max_gold") and int(run.get("gold")) > int(req["max_gold"]):
		return false
	if req.has("zone_slot") and not _slot_listed(req["zone_slot"],
			int(run.get("zone_idx")) + 1):
		return false
	if req.has("has_item"):
		var items: Dictionary = run.get("items")
		if int(items.get(String(req["has_item"]), 0)) <= 0:
			return false
	if req.has("spec_in_party"):
		var found := false
		for member in run.get("party"):
			if req["spec_in_party"].has(String(member.get("spec", ""))):
				found = true
		if not found:
			return false
	if req.has("fallen_hero"):
		var any_fallen := false
		for member in run.get("party"):
			if int(member["hp"]) <= 0:
				any_fallen = true
		if bool(req["fallen_hero"]) != any_fallen:
			return false
	return true


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
		"talent_points":
			var taught := PackedStringArray()
			for m in _targets(run, fx):
				m["talent_points"] = int(m.get("talent_points", 0)) + int(amount)
				taught.append(_who(m))
			return "%s: +%d talent point%s" % [", ".join(taught), int(amount),
				"" if int(amount) == 1 else "s"]
		"item":
			var items: Dictionary = run.get("items")
			var id := String(fx.get("id", "health"))
			var count := int(fx.get("count", 1))
			items[id] = maxi(int(items.get(id, 0)) + count, 0)
			return "%+d %s" % [count, run.ITEM_INFO[id][0]]
		"random_item":
			var got := PackedStringArray()
			for i in int(fx.get("count", 1)):
				var id: String = run.random_loot()
				var items: Dictionary = run.get("items")
				items[id] = int(items.get(id, 0)) + 1
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
		"relic_grant":
			var active: Array = run.get("active_relics")
			if active.size() >= 3:
				run.set("gold", int(run.get("gold")) + 40)
				return "relic slots full — +40 gold instead"
			var pool: Array = Relics.POOL.keys().filter(
				func(id): return not active.has(id))
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
