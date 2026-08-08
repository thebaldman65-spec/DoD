# Runes (Batch X): every authored rune lives in data/runes.json — name,
# rarity, scope, price, desc, and a payload in the Talents.apply_payload
# vocabulary (stat / ability / grant_ability / new_ability). Adding a rune
# is a JSON edit; there is NO new payload machinery here.
#
# RARITY MEANS KIND, not magnitude:
#   common — flat stat adds. The six generated TEMPLATES survive as the
#            filler family and the exhaustion floor.
#   rare   — alters an existing ability's numbers, or grants a talent-like
#            effect (talent counter fields STACK with the talent — intended).
#   epic   — grants an ability, changes a damage type, or inverts a rule.
# "scarred" is a BOOLEAN FLAG, not a rarity: a larger upside bought with a
# real cost (every scarred payload carries a negative term), priced BELOW
# its clean rarity peer so the trade shows in the shop as well as the
# tooltip. Scarred runes wear their own prefix and colour.
#
# ELIGIBILITY (the load-bearing part): "scope" is universal | class:<key>
# | spec:<id> — spec runes only roll for a matching hero, so the awakening
# shapes the loot table. Ability-payload runes MUST carry
# "requires_ability": Talents.apply_payload matches on display_name and a
# rune naming an ability the hero does not own applies silently and does
# NOTHING. The derivable kit checked here: core kit + spec abilities +
# apply_kit_overrides renames + the member's bm_abilities (boss trophies).
class_name Runes

const DATA_PATH := "res://data/runes.json"

const RARITIES := {
	"common": {"label": "Common", "prefix": "Cracked", "price": 50, "mult": 1,
		"color": Color(0.8, 0.8, 0.8)},
	"rare": {"label": "Rare", "prefix": "Polished", "price": 100, "mult": 2,
		"color": Color(0.45, 0.65, 1.0)},
	"epic": {"label": "Epic", "prefix": "Radiant", "price": 160, "mult": 3,
		"color": Color(0.75, 0.45, 1.0)},
}
const SCARRED_PREFIX := "Scarred"
const SCARRED_COLOR := Color(0.9, 0.35, 0.3)

# Rarity weights (common/rare/epic) keyed by zone SLOT; past the authored
# slots the pull keeps drifting epic-ward formulaically, like
# ZONE_BASE_MULTS — a 4th zone is data work, never formula work.
const RARITY_WEIGHTS := {1: [60, 30, 10], 2: [40, 40, 20], 3: [25, 45, 30]}

# The pre-Batch-X generated family: flat stat sticks, the Common floor.
const TEMPLATES := [
	{"noun": "Vitality", "stat": "max_hp", "base": 10, "fmt": "+%d max HP"},
	{"noun": "Warding", "stat": "armor", "base": 0.02, "fmt": "+%d%% armor"},
	{"noun": "Swiftness", "stat": "speed", "base": 4, "fmt": "+%d Speed"},
	{"noun": "Poise", "stat": "constitution", "base": 12, "fmt": "+%d Constitution"},
	{"noun": "Precision", "stat": "crit_bonus", "base": 0.02, "fmt": "+%d%% crit chance"},
	{"noun": "Springs", "stat": "max_resource", "base": 8, "fmt": "+%d max Mana"},
]

# JSON parses every number as a float, and typed set() on Ability chokes
# on floats (the Enemies.AB_INT_KEYS lesson) — restore ints on load.
const AB_INT_KEYS := ["damage", "pressure", "cost", "cooldown", "resource_gain",
	"multi_hits", "random_hits", "faith_cost", "bleed_build"]
const STAT_INT_KEYS := ["max_hp", "attack", "constitution", "max_resource",
	"resource", "bleed_bonus", "mana_regen_bonus", "blood_pact",
	# Batch AA: int counters that do NOT end in "_ranks" and so would slip
	# through as floats — BattleUnit.setup() pushes cfg straight into typed
	# vars, and a float into an int var is a runtime error, not a rounding.
	"zealous_mercy", "mercy_cap_bonus",
	# Batch AB: the Hunter trees are full of these — flag talents whose
	# payload is a bare 1. Same trap, same list.
	"loyalty_cap_bonus", "deep_focus", "perfect_form", "opening_volley",
	"coated_blades", "vulture",
	# Batch AR: the Rune of the Cinder Trail was re-pointed onto its own term
	# when the node took cinder_trail_ranks for a new meaning. Same trap, same
	# list — it is a bare 1 that does not end in "_ranks".
	"rune_cinder_ember"]

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


# The hero's derivable kit, by display name: core kit + spec abilities +
# kit-override renames + EARNED abilities (Batch AH: six a run, from either
# pool). Do NOT skip the earned list — several runes attach to abilities a
# hero only has because it picked them.
static func kit_names(member: Dictionary) -> Array:
	var cfg: Dictionary = Classes.hero_config(String(member["key"]))
	var spec := String(member.get("spec", ""))
	if spec != "":
		cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
		Classes.apply_kit_overrides(cfg, spec)
	var names: Array = []
	for ab in cfg["abilities"]:
		names.append(ab.display_name)
	for trophy in member.get("bm_abilities", []):
		names.append(String(trophy))
	return names


# The final shop/pouch name: scarred runes wear their own prefix.
static func display_name(entry: Dictionary) -> String:
	var prefix: String = SCARRED_PREFIX if entry.get("scarred", false) \
		else RARITIES[String(entry["rarity"])]["prefix"]
	return "%s %s" % [prefix, entry["name"]]


static func _scope_ok(entry: Dictionary, member: Dictionary) -> bool:
	var scope := String(entry.get("scope", "universal"))
	if scope == "universal":
		return true
	if scope.begins_with("class:"):
		return scope.trim_prefix("class:") == String(member["key"])
	if scope.begins_with("spec:"):
		return scope.trim_prefix("spec:") == String(member.get("spec", ""))
	return false


# Authored entries this member may roll at this rarity ("" = any rarity),
# excluding names already in their pouch.
static func eligible_ids(member: Dictionary, rarity_key: String,
		owned_names: Array) -> Array:
	var kit := kit_names(member)
	var out: Array = []
	var data := _load()
	for id in data:
		var e: Dictionary = data[id]
		if rarity_key != "" and String(e["rarity"]) != rarity_key:
			continue
		if not _scope_ok(e, member):
			continue
		var req := String(e.get("requires_ability", ""))
		if req != "" and not kit.has(req):
			continue
		if owned_names.has(display_name(e)):
			continue
		out.append(id)
	return out


static func rarity_weights(zone_slot: int) -> Array:
	if RARITY_WEIGHTS.has(zone_slot):
		return RARITY_WEIGHTS[zone_slot]
	var over: int = zone_slot - 3
	var c: int = maxi(25 - 10 * over, 5)
	var e: int = mini(30 + 10 * over, 70)
	return [c, 100 - c - e, e]


static func _roll_rarity(zone_slot: int) -> String:
	var w := rarity_weights(zone_slot)
	var roll := randi_range(1, int(w[0]) + int(w[1]) + int(w[2]))
	if roll <= int(w[0]):
		return "common"
	if roll <= int(w[0]) + int(w[1]):
		return "rare"
	return "epic"


# One rune for this member at this zone slot. Rarity rolls by slot weight;
# the eligible pool of that rarity is drawn from (commons include the
# generated family); an exhausted pool widens to every rarity, then falls
# back to the Common stat family — an empty offer list is a silent
# regression, not a design statement. Dedupe against the pouch is by
# final display name (call-site retry loops keep working on top).
# exclude_names (Batch AI fix): names that are unavailable for this draw
# even though the hero does not own them — in practice, the candidates
# already sitting in the triple being rolled. It rides the SAME channel as
# the owned pouch because it is the same question: a rune already in the
# offer is exactly as unavailable as one already worn. Threading it here
# makes a multi-draw roll a draw WITHOUT REPLACEMENT, which is what the
# callers always wanted; the alternative — roll and retry on a collision —
# is only probabilistically right and fails outright on a small pool.
static func generate(member: Dictionary, zone_slot: int,
		exclude_names: Array = []) -> Dictionary:
	var owned: Array = []
	for r in member.get("runes", []):
		owned.append(String(r["name"]))
	owned.append_array(exclude_names)
	var rarity := _roll_rarity(zone_slot)
	var pool := eligible_ids(member, rarity, owned)
	if rarity == "common":
		pool.append_array(_template_markers(member, owned))
	if pool.is_empty():
		pool = eligible_ids(member, "", owned)
		pool.append_array(_template_markers(member, owned))
	if pool.is_empty():
		return template_rune(String(member["key"]), "common")
	var pick: String = pool.pick_random()
	if pick.begins_with("tpl:"):
		return template_rune(String(member["key"]), "common", pick.trim_prefix("tpl:"))
	return build(pick)


# Batch AF: generate() above, restricted to the entries written for THIS
# member's spec. The machinery is deliberately identical — rarity still
# rolls on the zone slot's weights and an exhausted rarity still widens to
# the whole subset — so the guaranteed candidate is an ORDINARY roll that
# happens to draw from a smaller pool, not a forced Epic.
#
# Returns {} when the spec has no eligible entry (an unmet
# requires_ability, or a member with no spec at all). That empty is the
# caller's signal to fall back to an ordinary roll of three; it NEVER
# substitutes a stat stick, because filler would satisfy the guarantee's
# letter while defeating the thing it exists for.
static func generate_spec(member: Dictionary, zone_slot: int) -> Dictionary:
	var spec := String(member.get("spec", ""))
	if spec == "":
		return {}
	var owned: Array = []
	for r in member.get("runes", []):
		owned.append(String(r["name"]))
	var scope := "spec:%s" % spec
	var pool := _scoped_ids(eligible_ids(member, _roll_rarity(zone_slot), owned), scope)
	if pool.is_empty():
		pool = _scoped_ids(eligible_ids(member, "", owned), scope)
	if pool.is_empty():
		return {}
	return build(String(pool.pick_random()))


# eligible_ids returns authored ids only (never a "tpl:" marker), so this
# filter can read each entry's scope straight off the config.
static func _scoped_ids(ids: Array, scope: String) -> Array:
	var out: Array = []
	for id in ids:
		if String(config(id).get("scope", "")) == scope:
			out.append(id)
	return out


static func _template_markers(member: Dictionary, owned_names: Array) -> Array:
	var out: Array = []
	for t in TEMPLATES:
		if t["stat"] == "max_resource" and String(member["key"]) == "warrior":
			continue
		if owned_names.has("Cracked Rune of %s" % t["noun"]):
			continue
		out.append("tpl:%s" % t["noun"])
	return out


# The generated stat family. rarity_key "" = the pre-Batch-X roll
# (60/30/10 with magnitude scaling ×1/2/3) — DOD_SIM_RUNES=stats runs on
# exactly this. A named rarity pins magnitude AND price (the Common floor
# inside full mode); noun pins the template (pool draws).
static func template_rune(class_key: String, rarity_key := "", noun := "",
		exclude_names: Array = []) -> Dictionary:
	var pool := TEMPLATES.filter(
		func(t): return not (t["stat"] == "max_resource" and class_key == "warrior"))
	var template: Dictionary
	var rk := rarity_key
	if exclude_names.is_empty():
		# The original order — pool pick, then the rarity roll — kept byte
		# for byte, because every caller but the triple roller lands here
		# and RNG ordering is what a sim baseline is made of.
		template = pool.pick_random()
		if rk == "":
			var roll := randf()
			rk = "common" if roll < 0.6 else ("rare" if roll < 0.9 else "epic")
	else:
		# Drawing without replacement: a stat stick's NAME is its rarity and
		# its noun together, so the rarity has to be rolled before the noun
		# pool can be filtered. A noun already spent at this rarity is out;
		# the same noun at another rarity is a different rune and stays in.
		if rk == "":
			var roll2 := randf()
			rk = "common" if roll2 < 0.6 else ("rare" if roll2 < 0.9 else "epic")
		var prefix: String = RARITIES[rk]["prefix"]
		var open_pool := pool.filter(func(t): return not exclude_names.has(
			"%s Rune of %s" % [prefix, t["noun"]]))
		# Every noun spent at this rarity is the exhausted case; six nouns
		# against at most two exclusions means it cannot happen today.
		template = (open_pool if not open_pool.is_empty() else pool).pick_random()
	if noun != "":
		for t in TEMPLATES:
			if t["noun"] == noun:
				template = t
	var rar: Dictionary = RARITIES[rk]
	var value = template["base"] * rar["mult"]
	var shown: int = int(value * 100) if template["base"] is float else int(value)
	return {
		"id": "tpl_%s" % String(template["noun"]).to_lower(),
		"name": "%s Rune of %s" % [rar["prefix"], template["noun"]],
		"rarity": rar["label"],
		"rarity_color": rar["color"],
		"price": rar["price"],
		"desc": template["fmt"] % shown,
		"payload": {"stat": {template["stat"]: value}},
		"scarred": false,
		"scope": "universal",
		"lane": "",
		"equipped": false,
	}


# An authored entry as a pouch-ready rune instance (payload int-restored).
static func build(id: String) -> Dictionary:
	var e: Dictionary = _load()[id]
	var rar: Dictionary = RARITIES[String(e["rarity"])]
	var scarred := bool(e.get("scarred", false))
	return {
		"id": id,
		"name": display_name(e),
		"rarity": rar["label"],
		"rarity_color": SCARRED_COLOR if scarred else rar["color"],
		"price": int(e["price"]),
		"desc": String(e["desc"]),
		"payload": _typed_payload(e["payload"]),
		"scarred": scarred,
		"scope": String(e.get("scope", "universal")),
		"lane": String(e.get("lane", "")),
		"requires_ability": String(e.get("requires_ability", "")),
		"equipped": false,
	}


# ---------- Batch AD: the power probe (DOD_SIM_RUNE_POWER) ----------
#
# A blanket multiplier on the numeric MAGNITUDES of an authored payload,
# for the stage-1 experiment arm only (Run.rune_power gates it on sim_run —
# nothing here reads the environment). It scales the UPSIDE and holds every
# COST at its authored value, deliberately: the arm asks "are the entries
# too weak", and a multiplier that grew the drawbacks in step would answer
# a different question. That makes the arm strictly generous to scarred
# runes, which is why it is a probe and not a design.
#
# A cost is found two ways. Usually it is a NEGATIVE value on an ordinary
# field (-10 Speed, -0.3 healing received, -8% armor). Sometimes it is a
# POSITIVE value on a field where positive IS the cost — PENALTY_FIELDS,
# which exists entirely because of the Glass Rune's dmg_taken_bonus. A
# naive `v * mult` would scale that penalty up and quietly make the rune
# worse the harder the arm pushed.
#
# NOT SCALED, each for a reason worth stating out loud rather than hiding:
#   grant_ability / new_ability — there is no magnitude to scale. Four
#     entries (Comet, Binding Souls, Last Rites, Flayed Mind) are therefore
#     identical in every arm, and the power arm cannot speak for them.
#   "set" fields — absolute assignments (a damage TYPE, a status duration),
#     not magnitudes.
#   ability "cost" / "cooldown" — INVERTED fields, where the benefit is
#     already a negative number. Scaling -5 Rage to -15 makes an ability
#     nearly free and -1 cooldown to -3 makes it negative: that measures
#     "what if abilities were free", not "what if runes were stronger". One
#     rune (Rune of the Quick Spring) is wholly unscaled as a result.
# Fields where a POSITIVE number is the rune's price: "+15% damage taken"
# is a cost even though the term reads +0.15. The Glass Rune is why this
# list exists.
const PENALTY_FIELDS := ["dmg_taken_bonus"]
# Fields that run BACKWARDS — a negative number is the rune's promise, not
# its price. blood_pact shifts the bleedout threshold DOWN from 100 (the
# Rune of Exsanguination's -15 pops enemy veins at 85), so sign alone reads
# its whole benefit as a drawback and holds it: without this list that rune
# is inert in every arm, which is how it was caught (the power arm's
# positive control failed on it).
const INVERTED_STAT_FIELDS := ["blood_pact"]
const INVERTED_AB_FIELDS := ["cost", "cooldown"]


# True when this value is the payload's price rather than its promise. Both
# named lists invert the sign test for the same reason from opposite ends —
# on either, a positive number is what the rune charges you.
static func is_cost(field: String, value: float) -> bool:
	if PENALTY_FIELDS.has(field) or INVERTED_STAT_FIELDS.has(field):
		return value > 0.0
	return value < 0.0


# Type is PRESERVED, not re-derived: by the time a payload reaches here
# _typed_payload has already restored the ints, and pushing a float into a
# typed BattleUnit var is a runtime error, not a rounding (the Batch AA
# trap). An int field therefore scales to a rounded int.
static func _scaled(v, mult: float):
	if v is int:
		return int(round(float(v) * mult))
	return float(v) * mult


static func scale_payload(payload: Dictionary, mult: float) -> Dictionary:
	if is_equal_approx(mult, 1.0):
		return payload
	var out: Dictionary = payload.duplicate(true)
	for field in out.get("stat", {}):
		var v = out["stat"][field]
		if not (v is int or v is float) or is_cost(String(field), float(v)):
			continue
		out["stat"][field] = _scaled(v, mult)
	for field in out.get("add", {}):
		var av = out["add"][field]
		if not (av is int or av is float) or INVERTED_AB_FIELDS.has(field):
			continue
		if float(av) < 0.0:
			continue  # a negative add on a normal field is a cost
		out["add"][field] = _scaled(av, mult)
	return out


static func _typed_payload(p: Dictionary) -> Dictionary:
	var out: Dictionary = p.duplicate(true)
	if out.has("stat"):
		for field in out["stat"]:
			var v = out["stat"][field]
			if v is float and (STAT_INT_KEYS.has(field)
					or String(field).ends_with("_ranks")):
				out["stat"][field] = int(v)
	if out.has("ability"):
		for part in ["add", "set"]:
			for field in out.get(part, {}):
				if AB_INT_KEYS.has(field) and out[part][field] is float:
					out[part][field] = int(out[part][field])
		if out.has("status_turns"):
			out["status_turns"] = int(out["status_turns"])
	if out.has("new_ability"):
		var d: Dictionary = out["new_ability"]
		for field in AB_INT_KEYS:
			if d.has(field):
				d[field] = int(d[field])
		if d.has("applies_status") and d["applies_status"].has("turns"):
			d["applies_status"]["turns"] = int(d["applies_status"]["turns"])
		if str(d.get("target", "")) == "ally":
			d["target"] = Ability.Target.ALLY
	return out
