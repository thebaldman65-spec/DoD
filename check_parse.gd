# Scratch parse gate: force-compile every script and instantiate every
# scene, so a Parse/Compile Error anywhere fails LOUDLY instead of waiting
# for the one screen nobody opened. Run headless:
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
extends SceneTree


func _initialize() -> void:
	var bad := 0
	for dir_path in ["res://scripts", "res://scenes"]:
		var d := DirAccess.open(dir_path)
		if d == null:
			print("MISSING DIR ", dir_path)
			bad += 1
			continue
		for f in d.get_files():
			if not (f.ends_with(".gd") or f.ends_with(".tscn")):
				continue
			var path := "%s/%s" % [dir_path, f]
			var res: Resource = load(path)
			if res == null:
				print("LOAD FAILED: ", path)
				bad += 1
			elif res is GDScript and not (res as GDScript).can_instantiate():
				# The case the null check missed: parsed badly, returned anyway.
				print("PARSE FAILED: ", path)
				bad += 1
	print("check_parse: %d failures" % bad)
	quit(1 if bad > 0 else 0)
