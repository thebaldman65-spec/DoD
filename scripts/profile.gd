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
#
# BATCH FX §4 — VERSION 3 IS THE MERGED TALENT LEDGER, AND IT IS THE BATCH FQ
# BUILT THIS GUARD FOR. The tree keys to the CLASS now, so the ledger does:
# FOUR purses (one per class) where v2 held twelve (one per spec), a class's
# owned cells in the one twenty-seven-node tree, and NO equipped loadout —
# nothing in the tree is exclusive, so a cell bought is a cell worn. A v2
# profile is FOLDED on load (`_migrate`, below); the file is not touched until
# the next `_save()`, which writes it at v3.
const VERSION := 3

# BATCH FQ §1 — THE FLOOR. The oldest profile this build will read.
# FQ set it to 1 and called it **the line the merge moves**, and FX moved it:
# **the floor is the oldest version this build carries a written migration
# for**, and FX's is ONE STEP — v2 to v3, the purse fold. A v1 profile predates
# the meta ledger entirely; reading one would mean re-deriving BM's tolerant
# v1-to-v2 merge and then folding what it produced, a two-step path nothing has
# ever driven. It is REFUSED instead, which keeps the file intact for a build
# that reads it — the refusal never writes.
#
# A PROFILE WITH NO VERSION KEY READS 0 AND IS REFUSED. `run_state.load_run()`
# treats a missing version exactly the same way (`int(data.get("version", 0))`
# against a floor), and a JSON dictionary this build never wrote is not a
# profile just because it parses.
const MIN_VERSION := 2

# BATCH FQ §1 — THE CEILING, WHICH IS THE HALF THAT IS LIVE TODAY.
# A profile written at version 99 loads CLEAN under the code this replaces, is
# stamped back down to 2, and is re-saved at 2 — measured in a driven probe,
# not reasoned about. **FQ §2 puts the merge on its own branch with `main`
# staying playable**, so the designer will be switching between a build that
# writes vN and a build that writes vN+1 against ONE `user://profile.json`.
# The forward case stops being hypothetical the day the merge bumps VERSION,
# and it is the branch itself that makes it routine.
# **FX BUMPED IT, SO THIS IS NOW THE CASE IT DESCRIBES**: once this build has
# saved a folded profile at v3, `main`'s build (v2) meets a version above its
# own and refuses it — without deleting it — until the merge lands there.
#
# Set when `_load()` REFUSED the file on disk. Two things follow and both
# matter: **`_save()` becomes a NO-OP**, so the refused file is never
# overwritten; and **the main menu says so**, because a profile that reads as
# a fresh start is exactly the silent zero this guard exists to prevent.
static var refused := false
static var refused_reason := ""
static var refused_version := 0

# BATCH FX §4 — WHAT THE FOLD DID, when this session's load folded a v2 file.
# `migrated_from` is the version that was read (0 when nothing was folded) and
# `fold_report` is {class: {"specs": {spec: points}, "purse": points}} — the
# twelve purses in and the four out, so a gate can drive the fold on a copy
# and read exactly what it decided without re-deriving it.
static var migrated_from := 0
static var fold_report := {}


static func _load() -> Dictionary:
	if not loaded:
		loaded = true
		# Re-evaluated on every fresh load, because the harness redirects
		# `save_path` and resets `loaded`/`data` between sections, and a
		# refusal that outlived its file would refuse the next one too.
		refused = false
		refused_reason = ""
		refused_version = 0
		migrated_from = 0
		fold_report = {}
		data = {"version": VERSION, "runs_started": {}, "runs_completed": {},
			"wipes": {}, "forfeits": {}, "bosses_killed": {}, "events_seen": {},
			"zones_cleared": 0, "flags": {},
			# --- the meta talent ledger (Batch BM §4, keyed to the CLASS at FX) ---
			"talent_points": {},    # class -> points EARNED, ever
			"talent_cells": {},     # class -> {node id: true} — owned, and so worn
			"talent_tier": 0}       # global end-boss rung beaten, 0-3
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
			# BATCH FX §4 — THE FOURTH REFUSAL, AND IT IS THE FOLD'S. An older
			# version in range is MIGRATED before a single key is merged, and a
			# file the migration cannot place is refused exactly like the three
			# above: nothing merged, nothing written.
			if found < VERSION:
				var why := _migrate(read as Dictionary, found)
				if why != "":
					_refuse(found, why)
					return data
			for key in read:
				data[key] = read[key]
			# Only reached on an ACCEPTED load, and it is an upgrade rather
			# than a coercion: a migrated v2 profile merged over v3 defaults
			# genuinely IS a v3 profile. A refused version never gets here,
			# which is the whole of "no silent coercion".
			data["version"] = VERSION
	return data


# BATCH FX §4 — THE FOLD, AND IT HAPPENS ONCE. A v2 profile carries TWELVE
# purses, one per spec; v3 carries FOUR, one per class, because the tree keys
# to the class. **A MERGED PURSE TAKES THE HIGHEST OF ITS CLASS'S THREE, NOT
# THE SUM** (ruled by the designer): 3 points on each of three Warrior specs is
# 3, not 9, because the merged tree is a third the size of the three it
# replaces and a sum would hand most of it over the day the merge lands.
#
# THE CELLS AND THE LOADOUT DO NOT CARRY. Every id in a v2 ledger names a node
# of the twelve deleted trees, and nothing in this build can price or wear one.
# **Dropping them costs no POINT**: a purse is points EARNED and what is
# available is earned minus what the owned cells cost, so a folded purse
# arrives whole and unspent. `talent_tier` is global and carries unchanged.
#
# **A PURSE THIS BUILD CANNOT PLACE IS REFUSED, NEVER DROPPED.** A key that is
# not one of the twelve specs, or a value that is not a number, would otherwise
# fold into nothing — a purse silently zeroed, which is the one outcome the
# version guard exists to prevent (FQ). Refusing writes nothing, so the file
# survives for a build that can read it.
#
# **AND IT CANNOT BE ITERATED ON.** The fold is written to disk by the next
# `_save()`; after that the twelve purses exist only in a backup. A batch that
# re-rules the fold rules it for profiles not yet folded.
#
# Returns "" when the fold landed, or the reason it was refused.
static func _migrate(read: Dictionary, found: int) -> String:
	if found != 2:
		return "no migration from version %d is written" % found
	var old: Variant = read.get("talent_points", {})
	if not (old is Dictionary):
		return "its talent points are not readable"
	var folded := {}
	var report := {}
	for spec in old:
		var cls := Classes.class_of_spec(String(spec))
		if cls == "":
			return "it holds talent points for '%s', which is not a spec this build knows" % spec
		var v: Variant = (old as Dictionary)[spec]
		if not (v is int or v is float):
			return "its talent points for '%s' are not a number" % spec
		folded[cls] = maxi(int(folded.get(cls, 0)), int(v))
		if not report.has(cls):
			report[cls] = {"specs": {}, "purse": 0}
		(report[cls]["specs"] as Dictionary)[String(spec)] = int(v)
		report[cls]["purse"] = folded[cls]
	read["talent_points"] = folded
	read["talent_cells"] = {}
	read.erase("talent_equipped")
	migrated_from = found
	fold_report = report
	return ""


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


# ---------- BATCH BM §4: the meta talent ledger, KEYED TO THE CLASS AT FX ----------
#
# A CELL is bought once and forever, out of the CLASS's banked points, and —
# since FX — a cell owned is a cell worn: the tree has no rows and nothing in
# it is exclusive, so there is no second act to perform. `Talents` owns the
# rules (costs, both tier gates, what may be bought or refunded); this owns
# the ledger and nothing else.
#
# EVERY ACCESSOR BELOW TAKES A CLASS KEY ("warrior", "mage", "cleric",
# "hunter"). The specs still exist and still key the chronicle above; only the
# talent ledger merged. A caller holding a spec asks `Classes.class_of_spec`.

# ---- earning ----

# 1 point per CLASS per ZONE BOSS defeated, and only for classes that played.
# A run that dies in zone 2 has already banked 1 or 2: that partial credit
# is the mechanism, not a separate rule. The END boss awards none. Takes the
# party's SPECS because that is what a victory holds; two specs of one class
# in one list (a party never has that, a test can) still pay that class once.
static func award_zone_boss_points(specs: Array) -> void:
	var purse: Dictionary = _load()["talent_points"]
	var paid := {}
	for spec in specs:
		var cls := Classes.class_of_spec(String(spec))
		if cls == "" or paid.has(cls):
			continue
		purse[cls] = int(purse.get(cls, 0)) + 1
		paid[cls] = true
	if not paid.is_empty():
		_save()


static func talent_points_earned(class_key: String) -> int:
	return int(_load()["talent_points"].get(class_key, 0))


# ---- the row tier (GLOBAL — points are per class, tiers are not) ----

static func talent_tier() -> int:
	return clampi(int(_load().get("talent_tier", 0)), 0, Talents.MAX_TIER)


# Beating the end boss on difficulty N opens tier N for EVERY class at once.
# It never falls: clearing difficulty 1 after difficulty 3 changes nothing.
static func note_end_boss(difficulty_tier: int) -> void:
	var want := clampi(difficulty_tier, 0, Talents.MAX_TIER)
	if want <= talent_tier():
		return
	_load()["talent_tier"] = want
	_save()


# ---- cells: the permanent ledger ----

static func talent_cells(class_key: String) -> Dictionary:
	var all: Dictionary = _load()["talent_cells"]
	return all.get(class_key, {})


static func owns_cell(class_key: String, id: String) -> bool:
	return bool(talent_cells(class_key).get(id, false))


# Points still available: earned minus what the owned cells cost. There is
# no second accounting anywhere, so a refund cannot disagree with a spend.
static func talent_points_available(class_key: String) -> int:
	return talent_points_earned(class_key) \
		- Talents.cells_spent(Talents.tree(), talent_cells(class_key))


# Buy a cell. Returns true when it landed. Refuses politely — the build
# screen greys on `Talents.can_buy` and this re-checks it, so the two can
# never disagree the way two read sites of one question always eventually do.
static func buy_cell(class_key: String, id: String) -> bool:
	var tree := Talents.tree()
	var cells := talent_cells(class_key)
	var check := Talents.can_buy(tree, id, cells,
		talent_points_available(class_key), talent_tier())
	if not bool(check["ok"]):
		return false
	cells[id] = true
	_load()["talent_cells"][class_key] = cells
	_save()
	return true


# Pull a point back out. A spent point can be reassigned at no cost, any
# time OUTSIDE a run — the caller owns that gate, because only it knows
# whether a run is in flight. `Talents.can_refund` refuses a cell whose
# tier the tier above still stands on; the full respec is the way out.
static func refund_cell(class_key: String, id: String) -> bool:
	var cells := talent_cells(class_key)
	if not bool(Talents.can_refund(Talents.tree(), id, cells)["ok"]):
		return false
	cells.erase(id)
	_load()["talent_cells"][class_key] = cells
	_save()
	return true


# A full respec: every point back and every cell cleared.
static func respec(class_key: String) -> void:
	_load()["talent_cells"][class_key] = {}
	_save()


# THE HANDOFF INTO A RUN. Returns the {id: 1} set every read site already
# speaks: every cell the class owns, because a cell owned is worn. A cell
# the tree no longer holds is dropped here rather than carried, so the run
# can never wear something the tree cannot price.
static func worn_talents(class_key: String) -> Dictionary:
	if class_key == "":
		return {}
	return Talents.worn_learned(Talents.tree(), talent_cells(class_key))


# The map burger's debug grant (Batch BM, replacing "+200 talent points"):
# 60 points to every CLASS — past the 54 the whole tree costs — and every
# tier open. Gated by `Run.debug_enabled()` at the ONE dispatch site, which
# is also the one place `Run.debug_used` is written, so a run that used it
# still says so in its summary.
static func debug_grant_meta() -> void:
	var purse: Dictionary = _load()["talent_points"]
	for cls in Classes.SPEC_IDS:
		purse[String(cls)] = maxi(int(purse.get(String(cls), 0)), 60)
	_load()["talent_tier"] = Talents.MAX_TIER
	_save()
