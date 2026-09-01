# THE PARSE FLOOR: force-load everything that has to load, so a Parse/Compile
# Error anywhere fails LOUDLY instead of waiting for the one screen nobody
# opened — or, worse, for the twenty-third gate that preloads a broken fixture.
# Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_parse.gd
#
# BATCH CN — THIS GATE USED TO LIE, AND THE FIX IS THE `bad` COUNT BELOW.
# It counted `load(path) == null` and reported "0 failures" on a tree with a
# real Parse Error in it, because **Godot returns a NON-NULL GDScript for a
# file whose parse failed** — the engine prints the error and hands back the
# resource anyway. A broken `battle.gd` passed this gate mid-batch while the
# engine was printing `Parse Error` on the line above the summary.
#
# `can_instantiate()` is the question `load() != null` was being asked to
# answer: a GDScript that failed to compile cannot be instantiated, so it is
# false exactly when the parse is broken. Scenes keep the null check, which is
# accurate for them.
#
# **BELT AND BRACES: STILL GREP THE STREAM.** A gate that can only pass is a
# gap (BQ's rule), and the engine's stderr is the authority here, not this
# tally. The honest one-liner, which needs no script at all:
#   ... --script check_parse.gd 2>&1 | grep -cE "Parse Error|SCRIPT ERROR"
#
# ---------------------------------------------------------------------------
# BATCH EI — THIS GATE HAS NOW BEEN FOUND SHORT THREE TIMES, AND ALL THREE
# TIMES THE CAUSE WAS THE SAME SENTENCE: `for dir_path in [...]`.
#
# CP repaired the TALLY after it returned zero on genuinely broken files. DE
# found it did not cover the SUITES. EH broke `gate_fixture.gd` — a duplicate
# `var` in one scope — and **the floor procedure every implement-only batch
# since CG runs, `grep stderr for Parse Error`, came back CLEAN while 23 gates
# could not load.** The repo ROOT was outside the walk, and the root is where
# both fixtures, all 39 gates and all 47 suites live.
#
# **A DIRECTORY LIST IS THE DEFECT.** It is a hand-written claim about where
# things that must load live, it goes stale the first time somebody puts one
# somewhere else, and nothing goes red when it does. So the population is
# DERIVED now, in four layers, and no layer is a directory:
#
#   A. BATTERY — every target `run_battery.sh` actually spawns, read out of
#      that script: its `SUITES` and `GATES` arrays, every literal `--script
#      X.gd`, every `run_one X`, and every `res://X.tscn` scene run. A target
#      added to the battery is covered the same day, without editing this file.
#   B. REACHED — the transitive closure of A and of `project.godot`'s three
#      autoloads and main scene, over four kinds of edge: `preload`/`load`,
#      a scene's `ext_resource` paths, and `change_scene_to_file`. This is how
#      `gate_fixture.gd` and `suite_fixture.gd` arrive: nothing names them,
#      60 files depend on them. It is also how most of `scripts/` and all of
#      `scenes/` arrive, which used to be the whole of this gate.
#   C. GAME TREE — whatever is left in `scripts/` and `scenes/`. These are the
#      twelve `class_name` globals and their neighbours, reached by IDENTIFIER
#      rather than by path, and no textual closure can follow that edge. This
#      layer is the old gate, kept for exactly the files it was right about.
#   D. DATA — `res://data/*.json`, which reach the game through a `DATA_PATH`
#      string constant rather than a preload, so no closure can find them.
#
# Anything left over after all four is NAMED IN THE OUTPUT EVERY RUN. It is
# loaded like everything else, but it is loaded as a residue rather than as a
# dependency, and the difference is the whole point of this batch: the fourth
# instance of this gate being short will be a file sitting in that list.
#
# **THIS FILE PRELOADS NOTHING, AND THAT IS DELIBERATE.** A floor that
# `preload`s `gate_fixture.gd` cannot report that `gate_fixture.gd` is broken —
# it fails to load itself, prints a Parse Error, runs not one line and exits 0,
# which is exactly the fault DB documented. The gate that checks the fixtures
# must not be one of the files that depends on them.
#
# **AND A GATE THAT CAN ONLY PASS IS A GAP**, so three things here are hard
# failures rather than quiet skips: `run_battery.sh` unreadable, either battery
# array parsing to nothing, and a name in `run_battery.sh` with no file behind
# it. Each one would otherwise shrink the population to zero and print success.
extends SceneTree

const BATTERY := "res://run_battery.sh"
const PROJECT := "res://project.godot"
const DATA_DIR := "res://data"

# Extensions this gate does NOT force-load, with the reason. Everything else
# reached by a dependency edge IS loaded, fonts and sound effects included —
# a preload of a missing `.wav` is a hard break at run time and the closure
# already knows about it.
#   .gdshader — a shader's compile happens on the RENDERING server, which is
#               a stub under --headless, so `load()` here proves only that the
#               file exists. Reported as not covered rather than faked.
const SKIP_EXT := ["gdshader", "import", "uid"]

var _bad := 0
var _seen := {}


func _read(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _rx(pattern: String) -> RegEx:
	var r := RegEx.new()
	r.compile(pattern)
	return r


# Layer A. Everything `run_battery.sh` spawns, out of `run_battery.sh`.
func _battery_targets(sh: String) -> Array:
	var out: Array = []
	# The two arrays, each `NAME=(` ... `)` across as many lines as it takes.
	for arr_name in ["SUITES", "GATES"]:
		var m := _rx("%s=\\(([^)]*)\\)" % arr_name).search(sh)
		if m == null:
			print("BATTERY UNPARSED: no %s=( ... ) array in run_battery.sh" % arr_name)
			_bad += 1
			continue
		var names := m.get_string(1).split(" ", false)
		var kept := 0
		for raw in names:
			var n := raw.strip_edges()
			if n == "" or n.begins_with("#") or n.begins_with("$"):
				continue
			out.append("res://%s.gd" % n)
			kept += 1
		if kept == 0:
			# An array that parses to nothing is the shape that makes this
			# gate print success over an empty population.
			print("BATTERY EMPTY: %s parsed to zero targets" % arr_name)
			_bad += 1
	# The targets that are not in either array: the run harness, the count
	# differ, and the two scene runs.
	for m in _rx("--script ([A-Za-z0-9_]+)\\.gd").search_all(sh):
		out.append("res://%s.gd" % m.get_string(1))
	for m in _rx("run_one ([A-Za-z_][A-Za-z0-9_]*)").search_all(sh):
		out.append("res://%s.gd" % m.get_string(1))
	for m in _rx("res://([A-Za-z0-9_/]+\\.tscn)").search_all(sh):
		out.append("res://%s" % m.get_string(1))
	return out


# Layer B. The edges: what a script preloads, what a scene references.
func _deps_of(path: String, text: String) -> Array:
	var out: Array = []
	var patterns: Array = ["path=\"(res://[^\"]+)\""] if path.ends_with(".tscn") \
		else ["(?:preload|load)\\(\"(res://[^\"]+)\"\\)",
			  "change_scene_to_file\\(\"(res://[^\"]+)\"\\)"]
	for pattern in patterns:
		for m in _rx(pattern).search_all(text):
			out.append(m.get_string(1))
	return out


func _ext(path: String) -> String:
	return path.get_extension().to_lower()


# One file: load it, and say which way it failed. `bad` counts BOTH shapes,
# because CN's whole lesson is that they are different questions.
func _verify(path: String) -> void:
	if not FileAccess.file_exists(path):
		print("MISSING: ", path)
		_bad += 1
		return
	if _ext(path) in SKIP_EXT:
		return
	var res: Resource = load(path)
	if res == null:
		print("LOAD FAILED: ", path)
		_bad += 1
	elif res is GDScript and not (res as GDScript).can_instantiate():
		# The case the null check missed: parsed badly, returned anyway.
		print("PARSE FAILED: ", path)
		_bad += 1


# Walk a frontier to closure, verifying as it goes. Returns what it covered.
func _close(frontier: Array) -> Array:
	var covered: Array = []
	while not frontier.is_empty():
		var path: String = frontier.pop_back()
		if _seen.has(path):
			continue
		_seen[path] = true
		covered.append(path)
		_verify(path)
		if _ext(path) == "gd" or _ext(path) == "tscn":
			for d in _deps_of(path, _read(path)):
				if not _seen.has(d):
					frontier.append(d)
	return covered


func _files_in(dir_path: String, exts: Array) -> Array:
	var out: Array = []
	var d := DirAccess.open(dir_path)
	if d == null:
		print("MISSING DIR ", dir_path)
		_bad += 1
		return out
	for f in d.get_files():
		if _ext(f) in exts:
			out.append("%s/%s" % [dir_path.trim_suffix("/"), f])
	out.sort()
	return out


func _initialize() -> void:
	var sh := _read(BATTERY)
	if sh == "":
		# Without this the gate covers layers C and D only and still prints a
		# number, which is the third instance of this gate's own defect.
		print("BATTERY UNREADABLE: ", BATTERY)
		_bad += 1

	# A. WHAT THE BATTERY SPAWNS, out of the battery script itself.
	var battery := _battery_targets(sh)
	# A name in the battery with no file behind it is counted by `_verify` as
	# MISSING, but it is worth its own class: the battery prints `checks=?`
	# for such a target and nothing else in the tree says why.
	var a_missing := 0
	for p in battery:
		if not FileAccess.file_exists(p):
			a_missing += 1

	# B. THE CLOSURE, seeded by A and by project.godot's autoloads and main
	# scene — the four scripts the game cannot boot without, none of which any
	# battery target preloads.
	var roots := battery.duplicate()
	var proj := _read(PROJECT)
	if proj == "":
		print("PROJECT UNREADABLE: ", PROJECT)
		_bad += 1
	for m in _rx("\"\\*?(res://[^\"]+)\"").search_all(proj):
		roots.append(m.get_string(1))
	var ab_covered := _close(roots)
	var b_count := ab_covered.size() - battery.size()

	# C. THE GAME TREE the closure could not reach, because the edge is a
	# `class_name` identifier rather than a path. This is the old gate.
	var game: Array = []
	for dir_path in ["res://scripts", "res://scenes"]:
		for p in _files_in(dir_path, ["gd", "tscn"]):
			if not _seen.has(p):
				game.append(p)
	var c_covered := _close(game.duplicate())

	# D. THE DATA, which arrives through a `DATA_PATH` string constant.
	# **AND THE FAILURE GOES TO stderr NAMING ITSELF A PARSE ERROR**, because
	# the floor procedure this whole batch is about is `grep stderr for Parse
	# Error` — and a malformed `runes.json` is the one population here that
	# the engine says nothing about. Armed, it reddened the tally and left the
	# stream clean, which is a floor that is right only if you read it the way
	# the rule says not to.
	var data := _files_in(DATA_DIR, ["json"])
	for p in data:
		var j := JSON.new()
		if j.parse(_read(p)) != OK:
			printerr("Parse Error: %s:%d — %s" % [p, j.get_error_line(), j.get_error_message()])
			_bad += 1

	# THE RESIDUE. Loaded like everything else, and NAMED, because a floor
	# that is nearly complete is the one that gets trusted.
	var residue: Array = []
	for p in _files_in("res://", ["gd", "tscn"]):
		if not _seen.has(p):
			residue.append(p)
	_close(residue.duplicate())

	print("check_parse: A battery %d (%d missing) + B reached %d + C game tree %d + D data %d"
		% [battery.size(), a_missing, b_count, c_covered.size(), data.size()])
	print("check_parse: RESIDUE %d — in the tree, spawned by nothing, reached by nothing%s"
		% [residue.size(), ": " + ", ".join(residue) if not residue.is_empty() else ""])
	print("check_parse: OUTSIDE THIS GATE — .py instruments, .sh scripts, "
		+ "shaders/*.gdshader (the rendering server is a stub headless), "
		+ "and assets/ binaries no dependency edge reaches")
	# **THE COVERAGE IS A RATCHET NOW, AND THAT IS THE POINT OF PRINTING IT AS
	# `checks`.** This gate has been found short three times and each time the
	# evidence was a person noticing, because the only number it printed was
	# its own failure count — which is zero whether it walks 158 files or 41.
	# `baselines.json` pins the FLOOR, so a walk that quietly stops covering
	# something is a FALL and `check_de` reds; a batch that adds a suite is a
	# RISE, which is a notice telling the next batch to record the number.
	print("check_parse: %d checks / %d failures" % [_seen.size() + data.size(), _bad])
	quit(1 if _bad > 0 else 0)
