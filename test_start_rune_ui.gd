# The starting rune, as the PLAYER meets it (Batch AE).
#
# test_start_rune.gd proves the grant is dealt once and survives a save.
# This proves the other half of the brief — "the player must not be able to
# miss it" — by reading the real scenes: the map's Party badge, the Party
# screen's picker panel, and the fact that spending the pick clears both.
# A batch whose entire deliverable is a FRONT-LOADED lever cannot leave
# that assertion to a comment.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script res://_scratch/test_start_rune_ui.gd
extends SceneTree

const REAL_SAVE := "user://run_save.bin"
const REAL_PROFILE := "user://profile.json"
const SCRATCH_PROFILE := "user://profile_ae_ui_test.json"
# The rune purple the picker panel and the badge share.
const RUNE_PURPLE := Color(0.85, 0.6, 1.0)

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


func _initialize() -> void:
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	# The profile is redirected, never written through: the framing card
	# flag has to be settable without touching the player's own record.
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.data = {}

	await _map_badge()
	await _party_picker()
	await _spending_clears_it()
	await _no_badge_without_the_grant()
	await _framing_card_defers_the_nudge()

	# Restore.
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		f.store_buffer(_save_backup)
		f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	ok(FileAccess.file_exists(REAL_PROFILE) == FileAccess.file_exists(REAL_PROFILE),
		"profile presence check")

	print("test_start_rune_ui: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# A run standing exactly where the spec screen leaves it: specs locked,
# opening picks dealt, no map node entered yet.
func _arm(grant := true) -> Node:
	var run: Node = root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "holy", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.sync_spec_hp(i)
	if grant:
		run.grant_start_runes()
	run.specs_chosen = true
	run.active = true
	run.save_run()
	return run


func _make(path: String) -> Node:
	var scene: Node = load(path).instantiate()
	root.add_child(scene)
	for _i in 4:
		await process_frame
	return scene


func _party_button(scene: Node) -> Button:
	for b in scene.find_children("*", "Button", true, false):
		if String(b.text).begins_with("Party"):
			return b
	return null


func _labels(scene: Node) -> Array:
	var out: Array = []
	for l in scene.find_children("*", "Label", true, false):
		out.append(String(l.text))
	return out


# ---------- the map badges the owed picks ----------

func _map_badge() -> void:
	Profile.set_flag("run_framing_seen")  # card already seen: isolate the badge
	var run := _arm()
	ok(run.owed_rune_picks() == 4, "arm: the run does not owe four picks")
	var scene := await _make("res://scenes/map.tscn")

	var btn := _party_button(scene)
	ok(btn != null, "map: no Party button at all")
	if btn != null:
		ok(String(btn.text).contains("4 runes!"),
			"map: the Party button does not badge the owed picks (reads %s)" % btn.text)
		# RGB only: the badge PULSES, so its alpha is mid-tween by the time
		# the assertion reads it. That the alpha is off 1.0 at all is the
		# proof the pulse is running.
		var m := btn.modulate
		ok(is_equal_approx(m.r, RUNE_PURPLE.r) and is_equal_approx(m.g, RUNE_PURPLE.g)
			and is_equal_approx(m.b, RUNE_PURPLE.b),
			"map: the badge is not the rune purple (is %s)" % m)
		ok(m.a < 1.0, "map: the badge is not pulsing (alpha pinned at %.2f)" % m.a)
	# The nudge: a one-shot toast naming the Party screen.
	var found := false
	for t in _labels(scene):
		if t.contains("rune to choose") and t.contains("Party"):
			found = true
	ok(found, "map: no first-map nudge pointing at the Party screen")
	scene.queue_free()
	await process_frame


# ---------- the Party screen offers three, and calls it an awakening ----------

func _party_picker() -> void:
	var run := _arm()
	var scene := await _make("res://scenes/party.tscn")
	# The screen opens on the hero LIST, and the picker lives one click
	# deeper — so the list row is the affordance that has to carry it.
	ok(scene.selected < 0, "party: the screen did not open on the hero list")
	var listed := 0
	for b in scene.find_children("*", "Button", true, false):
		if String(b.text).contains("RUNE TO CHOOSE"):
			listed += 1
			ok(b.modulate.is_equal_approx(RUNE_PURPLE),
				"party list: an owed row is not the rune purple (is %s)" % b.modulate)
	ok(listed == 4, "party list: %d of 4 hero rows announce an owed pick" % listed)

	scene.selected = 0
	scene._draw_screen()
	await process_frame
	var texts := _labels(scene)
	var titled := false
	for t in texts:
		if t.begins_with("AWAKENING RUNE") and t.contains("1 owed"):
			titled = true
	ok(titled, "party: no AWAKENING RUNE panel for the opening pick")
	# Three candidate buttons, and they must be the three that were rolled
	# and SAVED — a screen that rerolls on open would hand out a different
	# rune every time the player looked.
	var triple: Array = run.party[0]["rune_candidates"][0]
	var names := {}
	for c in triple:
		names[String(c["name"])] = true
	var offered := 0
	for b in scene.find_children("*", "Button", true, false):
		for n in names:
			if String(b.text).begins_with(String(n)):
				offered += 1
	ok(offered == 3, "party: %d of the 3 rolled candidates are on screen" % offered)
	scene.queue_free()
	await process_frame


# ---------- spending it clears the panel and the badge ----------

func _spending_clears_it() -> void:
	var run := _arm()
	var scene := await _make("res://scenes/party.tscn")
	scene.selected = 0
	scene._draw_screen()
	await process_frame
	# Resolve through the real handler rather than reaching into the dict.
	var chosen := String(run.party[0]["rune_candidates"][0][1]["name"])
	scene._pick_rune(1)
	await process_frame
	var m: Dictionary = run.party[0]
	ok(int(m.get("rune_picks_owed", 0)) == 0, "pick: hero 0 still owes a pick")
	ok(m.get("rune_candidates", []).is_empty(), "pick: the triple stayed in the queue")
	ok(m.get("runes", []).size() == 1, "pick: hero 0 is not carrying exactly one rune")
	if not m.get("runes", []).is_empty():
		ok(String(m["runes"][0]["name"]) == chosen,
			"pick: the hero got a different rune than the button pressed")
		ok(bool(m["runes"][0].get("equipped", false)),
			"pick: the opening rune was not auto-equipped into a free slot")
	ok(run.owed_rune_picks() == 3, "pick: party-wide owed count did not fall to 3")
	scene.queue_free()
	await process_frame

	# The map must now badge THREE, not four — the badge reads live state.
	var map_scene := await _make("res://scenes/map.tscn")
	var btn := _party_button(map_scene)
	ok(btn != null and String(btn.text).contains("3 runes!"),
		"map: the badge did not follow the spent pick")
	map_scene.queue_free()
	await process_frame

	# Spend the rest; the badge and the panel must both go away entirely.
	for i in run.party.size():
		while int(run.party[i].get("rune_picks_owed", 0)) > 0:
			var s := await _make("res://scenes/party.tscn")
			s.selected = i
			s._draw_screen()
			await process_frame
			s._pick_rune(0)
			await process_frame
			s.queue_free()
			await process_frame
	ok(run.owed_rune_picks() == 0, "the party still owes picks after spending them all")
	var clean := await _make("res://scenes/map.tscn")
	var cbtn := _party_button(clean)
	ok(cbtn != null and not String(cbtn.text).contains("runes!"),
		"map: the badge survived every pick being spent (reads %s)" % (
			cbtn.text if cbtn != null else "<none>"))
	clean.queue_free()
	await process_frame


# ---------- the control: no grant, no badge, no nudge ----------

func _no_badge_without_the_grant() -> void:
	OS.set_environment("DOD_SIM_START_RUNE", "off")
	var run := _arm()
	ok(run.owed_rune_picks() == 0, "control: the off flag still dealt picks")
	var scene := await _make("res://scenes/map.tscn")
	var btn := _party_button(scene)
	ok(btn != null and String(btn.text) == "Party",
		"control: the Party button is badged with nothing owed (reads %s)" % (
			btn.text if btn != null else "<none>"))
	var nudged := false
	for t in _labels(scene):
		if t.contains("rune to choose"):
			nudged = true
	ok(not nudged, "control: the nudge fired with no picks owed")
	scene.queue_free()
	await process_frame
	OS.set_environment("DOD_SIM_START_RUNE", "")


# ---------- the framing card and the nudge do not talk over each other ----------

func _framing_card_defers_the_nudge() -> void:
	# A brand-new profile: the Batch Z framing card is due, and it is a
	# modal. The nudge must wait behind it rather than fading out under it.
	Profile.data = {}
	Profile.loaded = true
	ok(not Profile.flag("run_framing_seen"), "setup: the framing flag did not clear")
	_arm()
	var scene := await _make("res://scenes/map.tscn")
	var early := false
	for t in _labels(scene):
		if t.contains("rune to choose"):
			early = true
	ok(not early, "the nudge fired underneath the first-run framing card")
	var climb := false
	for b in scene.find_children("*", "Button", true, false):
		if String(b.text) == "Begin the climb":
			climb = true
			b.pressed.emit()
	ok(climb, "the framing card has no dismiss button")
	await process_frame
	var late := false
	for t in _labels(scene):
		if t.contains("rune to choose"):
			late = true
	ok(late, "the nudge never arrived after the framing card was dismissed")
	scene.queue_free()
	await process_frame
	Profile.set_flag("run_framing_seen")
