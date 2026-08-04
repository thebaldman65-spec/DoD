# The in-game glossary (Batch Z). The tooltip culture explains NUMBERS;
# nothing in the build explained a SYSTEM — a tester who doesn't know what
# Pressure does is playing a different game than the one being tested.
# data/glossary.json follows the Enemies/Events/Relics/Runes pattern:
# adding an entry is a JSON edit. Entries describe the CODE's behaviour,
# not the design doc's intent — where the two disagreed, the doc was
# fixed (Batch Z changelog carries the drift list).
class_name Glossary

const DATA_PATH := "res://data/glossary.json"

# Category keys in panel display order, with their headings.
const CATEGORIES := [
	["combat", "Combat Flow"],
	["statuses", "Statuses"],
	["damage", "Damage Types"],
	["resources", "Resources"],
	["progression", "Progression"],
	["gear", "Items & Gear"],
	["run", "The Run"],
]

static var _entries: Array = []
static var _by_id := {}


static func _load() -> void:
	if not _entries.is_empty():
		return
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("glossary: cannot open %s" % DATA_PATH)
		return
	var data: Variant = JSON.parse_string(file.get_as_text())
	if data is Array:
		_entries = data
		for e in _entries:
			_by_id[String(e["id"])] = e
	else:
		push_error("glossary: %s did not parse to an Array" % DATA_PATH)


static func entries() -> Array:
	_load()
	return _entries


static func entry(id: String) -> Dictionary:
	_load()
	return _by_id.get(id, {})


static func in_category(cat: String) -> Array:
	_load()
	return _entries.filter(func(e): return String(e["category"]) == cat)


# The contextual hook (status chips): a battle status id's one-line
# explanation, "" when the glossary has no entry for it.
static func status_short(status_id: String) -> String:
	return String(entry("status_" + status_id).get("short", ""))
