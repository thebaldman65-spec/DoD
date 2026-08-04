# Persistent profile (Batch 40): account-wide bookkeeping OUTSIDE the
# run save — the substrate the roadmap's persistent-unlocks design pass
# will gate content on. THIS BATCH RECORDS AND DISPLAYS ONLY: nothing is
# gated, no content is locked, and sims never touch it (every hook site
# is inside run-only flow). Tracked per the roadmap sketch: runs
# completed per spec, bosses killed by kind, events seen — plus starts
# and wipes, which any unlock design will want and which cost nothing
# to have counted from day one.
class_name Profile

# A var (not const) so headless tests can redirect writes to a scratch
# file instead of the real profile.
static var save_path := "user://profile.json"

static var data := {}
static var loaded := false


static func _load() -> Dictionary:
	if not loaded:
		loaded = true
		data = {"version": 1, "runs_started": {}, "runs_completed": {},
			"wipes": {}, "bosses_killed": {}, "events_seen": {},
			"zones_cleared": 0, "flags": {}}
		if FileAccess.file_exists(save_path):
			var file := FileAccess.open(save_path, FileAccess.READ)
			var read: Variant = JSON.parse_string(file.get_as_text())
			if read is Dictionary:
				for key in read:
					data[key] = read[key]
	return data


static func _save() -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(_load()))


static func _bump(bucket: String, key: String) -> void:
	var d: Dictionary = _load()[bucket]
	d[key] = int(d.get(key, 0)) + 1
	_save()


static func note_run_started(specs: Array) -> void:
	for spec in specs:
		if String(spec) != "":
			_bump("runs_started", String(spec))


static func note_completion(specs: Array) -> void:
	for spec in specs:
		if String(spec) != "":
			_bump("runs_completed", String(spec))


static func note_wipe(specs: Array) -> void:
	for spec in specs:
		if String(spec) != "":
			_bump("wipes", String(spec))


static func note_boss(kind: String) -> void:
	_bump("bosses_killed", kind)


static func note_event(id: String) -> void:
	_bump("events_seen", id)


static func note_zone_cleared() -> void:
	_load()["zones_cleared"] = int(_load()["zones_cleared"]) + 1
	_save()


# One-shot flags (Batch Z): the first-run orientation gates on these so a
# returning tester is never re-taught. Write sites live in real-play-only
# UI flow — sims must never reach them (checked in test_run_summary.gd).
static func flag(name: String) -> bool:
	return bool(_load().get("flags", {}).get(name, false))


static func set_flag(name: String) -> void:
	var flags: Dictionary = _load().get("flags", {})
	flags[name] = true
	_load()["flags"] = flags
	_save()


# ---------- read side (what a future unlock gate would ask) ----------

static func completions_total() -> int:
	var total := 0
	for spec in _load()["runs_completed"]:
		total += int(_load()["runs_completed"][spec])
	# Four heroes finish together; a "run" is the party's, not a hero's.
	return total / 4


static func completions_for(spec: String) -> int:
	return int(_load()["runs_completed"].get(spec, 0))


static func wipes_total() -> int:
	var total := 0
	for spec in _load()["wipes"]:
		total += int(_load()["wipes"][spec])
	return total / 4


static func distinct_events_seen() -> int:
	return _load()["events_seen"].size()
