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
#
# BATCH FQ §1 — AND UNTIL FQ THE SENTENCE ABOVE WAS THE WHOLE STORY, BECAUSE
# `_load()` HAD NO VERSION BRANCH AT ALL. It merged every key it found over
# the defaults and wrote `data["version"] = VERSION` unconditionally, reading
# the old value NOWHERE. FP built the collision rather than reasoning about
# it: a profile carrying six points and three bought cells, asked against a
# tree that no longer holds those ids, returns `cells_spent` 0,
# `equipped_learned` empty and `owns_cell` STILL TRUE. The points come back,
# the loadout empties, and the ledger keeps cells that now cost nothing.
#
# THE READ IS NOT THE DANGEROUS HALF. `_save()` writes the merged dictionary
# back over the file on the next point earned, so a wrong first load is not a
# bad read — it is a bad WRITE, and the twelve purses are gone the first time
# the player beats a zone boss. **Every merge batch touches talent ids**, and
# that is why this guard exists before the merge starts rather than during it.
#
# THE SHAPE IS `run_state.gd`'s AND IS DELIBERATELY NOT A SECOND PATTERN: a
# version, a refusal path for what it will not load, and no silent coercion.
# **THE ONE DIFFERENCE IS THAT THIS REFUSAL DOES NOT DELETE.** `load_run()`
# calls `clear_save()` because a refused run save is one run in flight; a
# refused profile is every run the player has ever finished, so deleting it
# would BE the destruction the guard exists to prevent. It refuses, it keeps
# its hands off the file, and it says so.
const VERSION := 2

# BATCH FQ §1 — THE FLOOR. The oldest profile this build will read.
# v1 predates the meta talent ledger and loads TOLERANTLY on purpose, for the
# reason BM's comment above gives: it arrives at zero points, zero cells and
# tier 0, which is the correct state for a save that never completed a run
# under that system. There is nothing below v1, so the floor refuses nothing
# today — **it is the line the merge moves.** The batch that renames a talent
# id raises this to its own VERSION and every older profile is refused, which
# is the honest answer, because FP measured what the tolerant read returns
# and it is a silent lie in three fields at once.
#
# A PROFILE WITH NO VERSION KEY READS 0 AND IS REFUSED. `run_state.load_run()`
# treats a missing version exactly the same way (`int(data.get("version", 0))`
# against a floor), and a JSON dictionary this build never wrote is not a
# profile just because it parses.
const MIN_VERSION := 1

# BATCH FQ §1 — THE CEILING, WHICH IS THE HALF THAT IS LIVE TODAY.
# A profile written at version 99 loads CLEAN under the code this replaces, is
# stamped back down to 2, and is re-saved at 2 — measured in a driven probe,
# not reasoned about. **FQ §2 puts the merge on its own branch with `main`
# staying playable**, so the designer will be switching between a build that
# writes vN and a build that writes vN+1 against ONE `user://profile.json`.
# The forward case stops being hypothetical the day the merge bumps VERSION,
# and it is the branch itself that makes it routine.
#
# Set when `_load()` REFUSED the file on disk. Two things follow and both
# matter: **`_save()` becomes a NO-OP**, so the refused file is never
# overwritten; and **the main menu says so**, because a profile that reads as
# a fresh start is exactly the silent zero this guard exists to prevent.
static var refused := false
static var refused_reason := ""
static var refused_version := 0


static func _load() -> Dictionary:
	if not loaded:
		loaded = true
		# Re-evaluated on every fresh load, because the harness redirects
		# `save_path` and resets `loaded`/`data` between sections, and a
		# refusal that outlived its file would refuse the next one too.
		refused = false
		refused_reason = ""
		refused_version = 0
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
			# BATCH FQ §1 — three refusals, and NOT ONE of them writes.
			# A file that does not parse as a dictionary used to fall
			# straight through to the defaults and then get overwritten by
			# the next `_save()`, which is a corrupt profile becoming a
			# DELETED one with no message in between.
			if not (read is Dictionary):
				_refuse(0, "it is not readable as a profile")
				return data
			var found := int((read as Dictionary).get("version", 0))
			if found < MIN_VERSION:
				_refuse(found, "it was written by a build older than this one")
				return data
			if found > VERSION:
				_refuse(found, "it was written by a NEWER build than this one")
				return data
			for key in read:
				data[key] = read[key]
			# Only reached on an ACCEPTED load, and it is an upgrade rather
			# than a coercion: a v1 profile merged over v2 defaults genuinely
			# IS a v2 profile. A refused version never gets here, which is
			# the whole of "no silent coercion".
			data["version"] = VERSION
	return data


static func _save() -> void:
	# BATCH FQ §1 — THE REFUSAL'S TEETH. Everything else this guard does is a
	# message; this is the line that keeps the file on disk.
	#
	# **THE ORDER IS LOAD-BEARING AND THE OBVIOUS SPELLING IS WRONG.** Reading
	# `refused` before `_load()` has run tests a flag that is still false, so
	# the very first write of a session — the one that destroys the file —
	# would sail past a guard that looks correct. `_load()` is called FIRST,
	# and its refusal is read afterwards.
	var out := _load()
	if refused:
		return
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(out))


# BATCH FQ §1 — the refusal, recorded rather than swallowed. `push_warning`
# reaches the editor and the headless log; `refusal_message()` is what the
# PLAYER reads, and the main menu shows it.
static func _refuse(found: int, why: String) -> void:
	refused = true
	refused_version = found
	refused_reason = why
	push_warning("Profile: REFUSED %s (version %d) — %s. Nothing will be written to it."
		% [save_path, found, why])


# What the player is told, in their words rather than in the format's.
# It names the FILE, because the file is the backup: the refusal exists so
# that copying it somewhere safe is still possible.
static func refusal_message() -> String:
	if not refused:
		return ""
	var stamp := "version %d" % refused_version if refused_version > 0 else "no version"
	return ("Your saved progress could not be read — %s (%s), and this build reads %d to %d.\n"
		+ "NOTHING HAS BEEN CHANGED OR DELETED. The file is left exactly as it was, and this "
		+ "session will not write to it.\nThe file is: %s") \
		% [refused_reason, stamp, MIN_VERSION, VERSION, save_path]


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
