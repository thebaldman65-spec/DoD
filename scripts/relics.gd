# Relics: permanent account-wide unlocks (the first meta-progression layer).
# Earned by slaying zone bosses — one random locked relic per boss kill.
# All unlocked relics are always active (slot management comes later).
# Persisted to user://relics.json across sessions.
class_name Relics

const SAVE_PATH := "user://relics.json"

const POOL := {
	"waystone": {"name": "Waystone Shard",
		"desc": "Every hero begins each run with +1 talent point."},
	"dragonbone": {"name": "Dragonbone Idol",
		"desc": "All heroes deal +10% damage."},
	"chalice": {"name": "Chalice of Dawn",
		"desc": "The party heals 10% after every victory."},
	"coin": {"name": "Gravewrought Coin",
		"desc": "Begin each run with +80 gold."},
	"eidolon": {"name": "Eidolon Mirror",
		"desc": "Warriors enter every battle with 25 Rage already burning."},
	"emberheart": {"name": "Emberheart",
		"desc": "Fire and Holy damage +20%."},
}

static var unlocked: Array = []
static var loaded := false


static func load_data() -> void:
	if loaded:
		return
	loaded = true
	if FileAccess.file_exists(SAVE_PATH):
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data: Variant = JSON.parse_string(file.get_as_text())
		if data is Array:
			unlocked = data


static func save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(unlocked))


static func has(id: String) -> bool:
	load_data()
	return unlocked.has(id)


# Unlocks one random still-locked relic; returns its info, or {} if all owned.
static func unlock_random() -> Dictionary:
	load_data()
	var locked: Array = []
	for id in POOL:
		if not unlocked.has(id):
			locked.append(id)
	if locked.is_empty():
		return {}
	var id: String = locked.pick_random()
	unlocked.append(id)
	save_data()
	var info: Dictionary = POOL[id].duplicate()
	info["id"] = id
	return info
