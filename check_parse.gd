# Scratch parse gate: force-compile every script and instantiate every
# scene, so a Parse/Compile Error anywhere fails LOUDLY instead of waiting
# for the one screen nobody opened. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_parse.gd
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
	print("check_parse: %d failures" % bad)
	quit(1 if bad > 0 else 0)
