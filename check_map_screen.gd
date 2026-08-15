# Scratch harness, run as a SCENE (autoloads only exist in a scene run): build
# the MAP SCREEN against a real in-flight run and count what it drew. The
# scene-parse gate only proves map.tscn loads — with no active run it bounces
# straight to the main menu, so the lattice draw is never executed.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless \
#       --path /Users/zipples/Documents/DoD/game --quit-after 600 \
#       res://check_map_screen.tscn
extends Node

var stage := 0
var frames := 0
var map_scene: Node = null


func _ready() -> void:
	Run.sim_run = true          # never touch the real save
	Run.new_run()
	for i in Run.party.size():
		Run.party[i]["spec"] = ["berserker", "cryomancer", "inquisitor",
			"beastmaster"][i]
	Run.specs_chosen = true
	Profile.set_flag("run_framing_seen")   # skip the orientation card


func _process(_d: float) -> void:
	frames += 1
	if frames % 4 != 0:
		return
	match stage:
		0:
			_open("fresh zone, nothing entered   ")
		1:
			_close()
			for i in 6:
				var reach: Array = Run.reachable()
				Run.advance(int(reach[reach.size() - 1]))
			_open("standing on column 6          ")
		2:
			_close()
			while Run.slot_idx < Run.BOSS_SLOT - 1:
				var reach2: Array = Run.reachable()
				if reach2.is_empty():
					break
				Run.advance(int(reach2[0]))
			for m in Run.party:
				Run.award_upgrade_pick(m)
			_open("boss next, every hero owed one")
		3:
			var before: int = _tally(map_scene)["all"]
			map_scene._open_pick_overlay(0)
			print("  pick overlay added %d nodes" % (int(_tally(map_scene)["all"]) - before))
			map_scene._open_rune_panel(1)
			print("  rune pouch opened without error")
			_close()
			# BATCH BX §2 — THE PARTY-WIDE DRAFT SCREEN, which like the lattice is
			# only ever EXECUTED here. Four columns is four times the layout, and
			# a column that overflows or a Callable that does not bind fails at
			# DRAW time, where no source-level check can see it.
			# ONE HERO AT THE CAP, so a column renders its DROP step. That
			# button and the modal it opens are drawn nowhere else, and a
			# Callable that does not bind fails at DRAW time.
			var capped: Dictionary = Run.party[0]
			var cap_pool: Array = Classes.spec_draft_pool(String(capped["spec"]))
			capped["bm_abilities"] = cap_pool.slice(0,
				Run.ABILITY_SLOT_CAP - Classes.core_slots(String(capped["spec"])))
			for m2 in Run.party:
				Run.award_draft_pick(m2)
			_open("four heroes owed a draft      ")
			var d_before: int = _tally(map_scene)["all"]
			map_scene._open_party_draft()
			var d_after: Dictionary = _tally(map_scene)
			print("  party draft added %d nodes, %d Buttons, %d columns owed" % [
				int(d_after["all"]) - d_before, int(d_after["btn"]),
				map_scene._draft_columns().size()])
			# Stage a card on every column and confirm through the real door.
			for i2 in Run.party.size():
				var q: Array = Run.party[i2].get("draft_candidates", [])
				if not q.is_empty() and not q[0].is_empty():
					map_scene._stage_draft(i2, String(q[0][0]))
			print("  hero 0 at cap, decided BEFORE naming a drop: %s"
				% str(map_scene._draft_decided(0)))
			var pre: int = _tally(map_scene)["all"]
			map_scene._open_drop_overlay(0, "draft",
				String((Run.party[0]["draft_candidates"] as Array)[0][0]),
				map_scene._stage_draft_drop.bind(0))
			print("  drop step added %d nodes" % (int(_tally(map_scene)["all"]) - pre))
			map_scene._stage_draft_drop(0,
				String((Run.party[0]["bm_abilities"] as Array)[0]))
			print("  ...decided AFTER: %s" % str(map_scene._draft_decided(0)))
			map_scene._confirm_party_draft()
			print("  confirmed; picks still owed: %d" % Run.owed_draft_picks())
			_close()
			print("check_map_screen: OK")
			get_tree().quit(0)
	stage += 1


func _open(label: String) -> void:
	map_scene = (load("res://scenes/map.tscn") as PackedScene).instantiate()
	add_child(map_scene)
	var c := _tally(map_scene)
	print("%s | %4d nodes  %3d Buttons  %3d edges  scroll %4.0f" % [
		label, int(c["all"]), int(c["btn"]), int(c["line"]), map_scene._map_scroll])


func _close() -> void:
	if map_scene != null and is_instance_valid(map_scene):
		map_scene.free()
	map_scene = null


func _tally(n: Node) -> Dictionary:
	var out := {"all": 0, "btn": 0, "line": 0}
	for c in n.get_children():
		out["all"] += 1
		if c is Button:
			out["btn"] += 1
		if c is Line2D:
			out["line"] += 1
		var sub := _tally(c)
		out["all"] += int(sub["all"])
		out["btn"] += int(sub["btn"])
		out["line"] += int(sub["line"])
	return out
