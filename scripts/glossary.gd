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
	return _entries.filter(func(e): return String(e["category"]) == cat \
		and String(e.get("retired", "")) == "")


# BATCH GG — A RETIRED ENTRY LEAVES THE PANEL AND KEEPS ITS ID. An entry for
# something nothing in the game can produce is RETIRED, never annotated (ruled
# by the designer): a player reads the glossary to learn what the game does.
# It stays in data/glossary.json with its text untouched and a `retired`
# string naming what is lost; `entries()`, `entry()` and `status_short()` all
# still resolve it; and the panel neither lists it (`in_category`, above) nor
# links to it (the see-also loop asks this). The day something produces it
# again, deleting the string is the whole of bringing the entry back.
static func is_retired(id: String) -> bool:
	return String(entry(id).get("retired", "")) != ""


# The contextual hook (status chips): a battle status id's one-line
# explanation, "" when the glossary has no entry for it.
static func status_short(status_id: String) -> String:
	return String(entry("status_" + status_id).get("short", ""))
