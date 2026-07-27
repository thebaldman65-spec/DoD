# Enemy roster (Batch 34): every kind lives in data/enemies.json — power,
# role tags, zone slots, stats, resists, tint, and kit — consumed here the
# way Talents/Relics wrap their data. Adding an enemy is a JSON edit, not
# a code change; role tags enroll it in every theme that wants that role.
# NOTE: all enemies still share the orc sheet (tint + scale only), so new
# kinds READ as tinted orcs until per-kind art lands — a known limit.
class_name Enemies

const DATA_PATH := "res://data/enemies.json"
const SHEET := "res://assets/sprites/orc"

# JSON numbers arrive as floats; these ability fields must stay ints.
const AB_INT_KEYS := ["damage", "pressure", "cost", "cooldown", "resource_gain",
	"multi_hits", "random_hits", "faith_cost"]
const CFG_INT_KEYS := ["max_hp", "attack", "stability", "constitution",
	"resource", "max_resource", "power"]

static var _data := {}


static func _load() -> Dictionary:
	if _data.is_empty():
		var f := FileAccess.open(DATA_PATH, FileAccess.READ)
		_data = JSON.parse_string(f.get_as_text())
	return _data


static func kinds() -> Array:
	return _load().keys()


static func power(kind: String) -> int:
	return int(_load().get(kind, {}).get("power", 1))


static func roles(kind: String) -> Array:
	return _load().get(kind, {}).get("roles", [])


static func unit_name(kind: String) -> String:
	return str(_load().get(kind, {}).get("unit_name", kind.capitalize()))


# Resist profile straight from the data (dmg_type -> fraction; negative =
# vulnerable). The map screen reads this to preview a warband's identity.
static func resists_for(kind: String) -> Dictionary:
	return _load().get(kind, {}).get("resists", {})


# Kinds belonging to a ROSTER (the JSON "zones" tags are roster ids —
# a zone def in run_state maps each slot it can host to one of these,
# so rosters travel with zone identity, never with run position).
static func kinds_for_roster(roster: int) -> Array:
	var out: Array = []
	for kind in _load():
		if _load()[kind].get("zones", []).has(float(roster)) \
				or _load()[kind].get("zones", []).has(roster):
			out.append(kind)
	return out


# A battle-ready config: ints restored, tint array -> Color, ability
# dicts -> Ability objects ("target": "ally" -> the enum).
static func config(kind: String) -> Dictionary:
	var src: Dictionary = _load().get(kind, _load()["raider"])
	var cfg: Dictionary = src.duplicate(true)
	cfg["is_hero"] = false
	cfg["sheet_dir"] = SHEET
	for key in CFG_INT_KEYS:
		if cfg.has(key):
			cfg[key] = int(cfg[key])
	var t: Array = cfg.get("tint", [1.0, 1.0, 1.0])
	cfg["tint"] = Color(float(t[0]), float(t[1]), float(t[2]))
	cfg.erase("power")
	cfg.erase("roles")
	cfg.erase("zones")
	var abs_out: Array = []
	for ad in cfg.get("abilities", []):
		var d: Dictionary = ad.duplicate(true)
		for key in AB_INT_KEYS:
			if d.has(key):
				d[key] = int(d[key])
		if d.has("applies_status") and d["applies_status"].has("turns"):
			d["applies_status"]["turns"] = int(d["applies_status"]["turns"])
		if str(d.get("target", "")) == "ally":
			d["target"] = Ability.Target.ALLY
		abs_out.append(Ability.make(d))
	cfg["abilities"] = abs_out
	return cfg
