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


# BATCH BM: version 2 adds the META TALENT LEDGER — per-spec points earned,
# per-spec cells unlocked, per-spec equipped loadout, and the GLOBAL row
# tier. THE LOAD IS TOLERANT and always has been (keys are merged over the
# defaults), so a v1 profile arrives with zero points, zero cells and tier
# 0 — which is exactly the right state for a save that has never completed
# a run under this system. Nothing migrates because nothing could: in-run
# talent points were per-RUN and are deleted.
const VERSION := 2


static func _load() -> Dictionary:
	if not loaded:
		loaded = true
		data = {"version": VERSION, "runs_started": {}, "runs_completed": {},
			"wipes": {}, "forfeits": {}, "bosses_killed": {}, "events_seen": {},
			"zones_cleared": 0, "flags": {},
			# --- the meta talent ledger (Batch BM §4) ---
			"talent_points": {},    # spec -> points EARNED, ever
			"talent_cells": {},     # spec -> {node id: true}
			"talent_equipped": {},  # spec -> {row (as String): node id}
			"talent_tier": 0}       # global rows unlocked, 0-3
		if FileAccess.file_exists(save_path):
			var file := FileAccess.open(save_path, FileAccess.READ)
			var read: Variant = JSON.parse_string(file.get_as_text())
			if read is Dictionary:
				for key in read:
					data[key] = read[key]
		data["version"] = VERSION
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


# Batch AA: a forfeit is NOT a defeat. It books its own bucket so the
# chronicle stays honest the moment testers start using the escape hatch —
# folding forfeits into wipes would make every alpha wipe-rate unreadable.
static func note_forfeit(specs: Array) -> void:
	for spec in specs:
		if String(spec) != "":
			_bump("forfeits", String(spec))


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


static func forfeits_total() -> int:
	var total := 0
	for spec in _load().get("forfeits", {}):
		total += int(_load()["forfeits"][spec])
	return total / 4


static func distinct_events_seen() -> int:
	return _load()["events_seen"].size()


# ---------- BATCH BM §4: the meta talent ledger ----------
#
# THE ONE DISTINCTION THIS WHOLE SECTION EXISTS TO KEEP: a CELL is bought
# once and forever; EQUIPPING is a separate act and it is what a run reads.
# Buying never equips. `Talents` owns the rules (costs, tiers, what may be
# bought or equipped); this owns the ledger and nothing else.
#
# JSON keys are strings, so the equipped map is keyed on String(row) — every
# accessor here converts, and no caller outside this file ever sees it.

# ---- earning ----

# 1 point per spec per ZONE BOSS defeated, and only for specs that played.
# A run that dies in zone 2 has already banked 1 or 2: that partial credit
# is the mechanism, not a separate rule. The END boss awards none.
static func award_zone_boss_points(specs: Array) -> void:
	var purse: Dictionary = _load()["talent_points"]
	var paid := false
	for spec in specs:
		var key := String(spec)
		if key == "":
			continue
		purse[key] = int(purse.get(key, 0)) + 1
		paid = true
	if paid:
		_save()


static func talent_points_earned(spec: String) -> int:
	return int(_load()["talent_points"].get(spec, 0))


# ---- the row tier (GLOBAL — points are per spec, rows are not) ----

static func talent_tier() -> int:
	return clampi(int(_load().get("talent_tier", 0)), 0, Talents.MAX_TIER)


# Beating the end boss on difficulty N opens tier N for EVERY spec at once.
# It never falls: clearing difficulty 1 after difficulty 3 changes nothing.
static func note_end_boss(difficulty_tier: int) -> void:
	var want := clampi(difficulty_tier, 0, Talents.MAX_TIER)
	if want <= talent_tier():
		return
	_load()["talent_tier"] = want
	_save()


# ---- cells: the permanent unlock ledger ----

static func talent_cells(spec: String) -> Dictionary:
	var all: Dictionary = _load()["talent_cells"]
	return all.get(spec, {})


static func owns_cell(spec: String, id: String) -> bool:
	return bool(talent_cells(spec).get(id, false))


# Points still available: earned minus what the owned cells cost. There is
# no second accounting anywhere, so a refund cannot disagree with a spend.
static func talent_points_available(spec: String) -> int:
	var tree := Talents.generate_tree(spec, "")
	return talent_points_earned(spec) \
		- Talents.cells_spent(tree, talent_cells(spec))


# Buy a cell. Returns true when it landed. Refuses politely — the build
# screen greys on `Talents.can_buy` and this re-checks it, so the two can
# never disagree the way two read sites of one question always eventually do.
static func buy_cell(spec: String, id: String) -> bool:
	var tree := Talents.generate_tree(spec, "")
	var cells := talent_cells(spec)
	var check := Talents.can_buy(tree, id, cells, talent_points_available(spec),
		talent_tier())
	if not bool(check["ok"]):
		return false
	cells[id] = true
	_load()["talent_cells"][spec] = cells
	_save()
	return true


# Pull a point back out. A spent point can be reassigned at no cost, any
# time OUTSIDE a run — the caller owns that gate, because only it knows
# whether a run is in flight. Un-owning a cell also un-equips it.
static func refund_cell(spec: String, id: String) -> bool:
	var cells := talent_cells(spec)
	if not bool(cells.get(id, false)):
		return false
	cells.erase(id)
	_load()["talent_cells"][spec] = cells
	var equipped := talent_equipped(spec)
	for row in equipped.keys():
		if String(equipped[row]) == id:
			equipped.erase(row)
	_load()["talent_equipped"][spec] = equipped
	_save()
	return true


# A full respec: every point back, every cell and every equip cleared.
static func respec(spec: String) -> void:
	_load()["talent_cells"][spec] = {}
	_load()["talent_equipped"][spec] = {}
	_save()


# ---- equipping: one node per row, and a run reads exactly this ----

static func talent_equipped(spec: String) -> Dictionary:
	var all: Dictionary = _load()["talent_equipped"]
	return all.get(spec, {})


static func equip_cell(spec: String, id: String) -> bool:
	var tree := Talents.generate_tree(spec, "")
	var equipped := _row_keyed(talent_equipped(spec))
	var check := Talents.can_equip(tree, id, talent_cells(spec), equipped)
	if not bool(check["ok"]):
		return false
	var row := int(Talents.node_in_tree(tree, id).get("row", 1))
	var store := talent_equipped(spec)
	store[str(row)] = id
	_load()["talent_equipped"][spec] = store
	_save()
	return true


static func unequip_row(spec: String, row: int) -> void:
	var store := talent_equipped(spec)
	if not store.has(str(row)):
		return
	store.erase(str(row))
	_load()["talent_equipped"][spec] = store
	_save()


# THE HANDOFF INTO A RUN. Returns the {id: 1} set every read site already
# speaks, built from the loadout the player configured between runs. A cell
# that is equipped but no longer owned (a refund, a tree edit) is dropped
# here rather than carried, so the run can never wear something unpaid for.
static func equipped_talents(spec: String) -> Dictionary:
	if spec == "" or not Talents.has_tree(spec):
		return {}
	var tree := Talents.generate_tree(spec, "")
	var cells := talent_cells(spec)
	var out := {}
	for row_key in talent_equipped(spec):
		var id := String(talent_equipped(spec)[row_key])
		if id == "" or not bool(cells.get(id, false)):
			continue
		if not Talents.node_in_tree(tree, id).is_empty():
			out[id] = 1
	return out


# The map burger's debug grant (Batch BM, replacing "+200 talent points"):
# 60 points to every spec — past the 54 a full tree costs — and every row
# tier open. Gated by `Run.debug_enabled()` at the ONE dispatch site, which
# is also the one place `Run.debug_used` is written, so a run that used it
# still says so in its summary.
static func debug_grant_meta() -> void:
	var purse: Dictionary = _load()["talent_points"]
	for spec in Classes.all_specs():
		purse[String(spec)] = maxi(int(purse.get(String(spec), 0)), 60)
	_load()["talent_tier"] = Talents.MAX_TIER
	_save()


# The equipped map with INT row keys, which is what Talents.can_equip reads.
static func _row_keyed(store: Dictionary) -> Dictionary:
	var out := {}
	for k in store:
		out[int(k)] = String(store[k])
	return out
