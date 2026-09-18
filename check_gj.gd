# BATCH GJ — THE END BOSS'S BUTTON IS PRESSED, AND WHAT ITS FIGHT ENDS IN IS READ.
#
#   §1  THE ROAD — a whole run on the real screens, every step onto a node a
#       press on that node's own lattice button, to the final board: every map
#       it reads draws a pressable button for each node the party can step to,
#       and the mini-boss reads MINI-BOSS on its button and on its bargain
#   §2  THE BUTTON — the final board's seventeenth column: END BOSS, its
#       tooltip, the readout naming the Crown, and the press that opens its fight
#   §3  THE SCALE — the Crown that press fields takes no discount from rung 1,
#       and rungs 2 and 3 field it as they did
#   §4  THE VICTORY — the card, the gold as the purse moved, the relic, the
#       talent tier, the profile's write, the run save gone, Continue greyed
#   §5  THE DEFEAT — an end boss lost: the wipe card names the Crown once, a
#       wipe is booked, no tier opens and no relic unlocks, the save is gone
#   §6  THE PLAYER'S FILES — as this gate found them
#
# ── WHY IT EXISTS ────────────────────────────────────────────────────────────
# The end boss had no button from BK to GI and nothing in the battery could see
# it: `check_fh` reaches the end boss by calling the node handler, and the
# map-screen gates draw zone 1 or a zone-1 board relabelled as the third. GI's
# proof was two runs played by hand. This plays one every battery, and it never
# calls `_on_node_pressed` itself — a node the map drew no button for is a node
# no player can step onto, and the drive stops there and says so.
#
# ── THE ENEMY'S ATTACKS ARE OFF, AND THAT IS WHAT MAKES IT A GATE ────────────
# `DOD_ENEMIES_OFF=1` is the switch `gate_fixture.spawn` sets for every battle a
# gate builds. Every fight here is fought and won by the real battle scene on
# autoplay, and none can be lost. WHETHER the bot can beat the end boss is a
# balance fact — the sim has measured it on every `--run` since GJ — and a gate
# that went red on it would go red on ordinary design work (`check_fh` §1's
# reasoning). So the defeat §5 reads is constructed, down GH's own path: the
# last fall on the save, and the main menu's real Continue.
#
# ── THE PLAYER'S FILES ───────────────────────────────────────────────────────
# `Run` writes its harness path under `--script` (FI). `Profile.save_path` and
# `Relics.save_path` (GJ) are pointed at scratch files of this gate's own before
# a step is taken, because the victory WRITES both: a talent tier and an
# unlocked relic are two of the things it is asserted to pay. §6 reads the
# player's three files byte for byte, both arms unconditional (FH §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gj.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SPECS := ["berserker", "cryomancer", "inquisitor", "sharpshooter"]
const SCRATCH_PROFILE := "user://gj_profile.json"
const SCRATCH_RELICS := "user://gj_relics.json"
const ROAD_SEED := 20260915
# A run is 49 steps onto nodes, about as many battles and cards, and the screens
# between them; a stall is a softlock, and a gate that waits on one forever
# reports nothing (FR §5a), so both loops are bounded.
const MAX_STEPS := 900
const FRAME_CAP := 30000

var _g := Gate.new()
var _run: Node = null
# path -> [existed, bytes], read before a byte moves.
var _player := {}

# What the road met, asserted once it has been walked.
var _maps_read := 0
var _maps_short: Array = []
var _warden_seen := 0
var _mini_labels: Array = []
var _mini_openers: Array = []
var _zone_cards := 0
var _battles := 0
var _dead: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GJ — THE END BOSS'S BUTTON, PRESSED, AND WHAT ITS FIGHT ENDS IN")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Engine.max_fps = 0

	_fresh_meta()
	var arrived: bool = await _s1_the_road()
	if arrived:
		await _s2_to_s4_the_end_boss()
	_fresh_meta()
	await _s5_the_defeat()

	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── THE SCRATCH META FILES ───────────────────────────────────────────────────

# A fresh scratch profile, at talent tier 0, and a scratch relic file with every
# relic locked. Both statics are told to read again: a `loaded` flag left true
# would keep the player's data in memory and write it into the scratch file.
func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	_write_text(SCRATCH_RELICS, "[]")
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()
	ok(int(_profile_on_disk().get("talent_tier", -1)) == 0,
		"§0: the scratch profile does not open at talent tier 0 — the tier a victory opens cannot be read")
	ok(_relics_on_disk().is_empty() and Relics.unlocked.is_empty(),
		"§0: the scratch relic file does not open with every relic locked — the one a victory unlocks cannot be read")


func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _write_text(path: String, text: String) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	f.store_string(text)
	f.close()


func _json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	return JSON.parse_string(FileAccess.get_file_as_string(path))


func _profile_on_disk() -> Dictionary:
	var d: Variant = _json(SCRATCH_PROFILE)
	return d if d is Dictionary else {}


func _relics_on_disk() -> Array:
	var a: Variant = _json(SCRATCH_RELICS)
	var out: Array = []
	if a is Array:
		for x in a:
			out.append(String(x))
	out.sort()
	return out


func _disk() -> Dictionary:
	var p: String = _run.save_path
	if not FileAccess.file_exists(p):
		return {}
	var f := FileAccess.open(p, FileAccess.READ)
	var d: Variant = f.get_var(true)
	f.close()
	return d if d is Dictionary else {}


func _write_disk(d: Dictionary) -> void:
	var f := FileAccess.open(String(_run.save_path), FileAccess.WRITE)
	f.store_var(d, true)
	f.close()


# ── THE RUN, AND THE SCREENS ITS ROAD PUTS IN FRONT OF THE PLAYER ────────────

func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["tree"] = Talents.generate_tree(SPECS[i], _run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true


func _where() -> String:
	return "zone %d slot %d" % [int(_run.zone_idx) + 1, int(_run.slot_idx) + 1]


func _header(s: Node) -> String:
	for t in Gate.texts(s):
		if String(t).begins_with("Zone "):
			return String(t)
	return "<no readout>"


# Sorted: what is asserted is WHICH warband, not the order the spawn laid it out.
func _kinds(s: Node) -> Array:
	var out: Array = []
	var es: Variant = s.get("enemies") if s != null else null
	if not (es is Array):
		return out
	for e in es:
		out.append(String(e.get("enemy_kind")))
	out.sort()
	return out


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


func _won(s: Node) -> bool:
	if not _is_battle(s):
		return false
	for h in s.get("heroes"):
		if not bool(h.get("dead")):
			return true
	return false


func _fight_to_end(s: Node) -> void:
	if not _is_battle(s):
		return
	var guard := 0
	while not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	await Gate.frames(self, 8)


# One battle on the road: fought to its end by the real scene, then its card's
# own button. Returns "on" past the card, or why the road stops.
func _fight(s: Node) -> String:
	var guard := 0
	while not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	if guard >= FRAME_CAP:
		return "a battle never ended in %d frames" % FRAME_CAP
	await Gate.frames(self, 6)
	_battles += 1
	if Gate.has_text(s, "THE ZONE IS CLEANSED"):
		_zone_cards += 1
	if Gate.press(s, ["Continue", "Descend into", "Walk on", "Onward"]) != "":
		return "on"
	if Gate.has_text(s, "New Run"):
		return "the run ENDED before the end boss"
	return "the battle's card drew nothing to press"


# The draft screen, declined column by column through each column's own button
# (found by what it is bound to), then confirmed.
func _answer_the_draft(s: Node) -> void:
	for _i in 8:
		var ov: Node = Gate.overlay(s, 62)
		var btn: Button = null
		var btns: Array = []
		Gate.buttons(ov if ov != null else s, btns)
		for b in btns:
			if String((b as Button).text) != "Decline" or (b as Button).disabled:
				continue
			for c in (b as Button).pressed.get_connections():
				if (c["callable"] as Callable).get_method() == "_stage_draft_decline":
					btn = b
		if btn == null:
			break
		btn.emit_signal("pressed")
		await process_frame
	var again: Node = Gate.overlay(s, 62)
	if Gate.press(again if again != null else s, ["Confirm the draft"]) == "":
		_dead.append("the draft screen at %s would not confirm" % _where())
		s.call("_close_party_draft")
	await Gate.frames(self, 2)


# A pick owed on a hero card: the card's own CHOOSE button, then the first live
# choice on the overlay it opens.
func _answer_a_pick(s: Node, idx: int) -> void:
	var m: Dictionary = _run.party[idx]
	var choose: Button = Gate.bound_button(s, "_open_pick_overlay", [idx])
	var ov: Node = null
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
		ov = Gate.overlay(s, 60)
	var live: Array = []
	if ov != null:
		var btns: Array = []
		Gate.buttons(ov, btns)
		for b in btns:
			if String((b as Button).text) != "Not yet" and not (b as Button).disabled:
				live.append(b)
	if live.is_empty():
		_dead.append("hero %d owed a pick at %s and no live choice could be pressed" % [idx, _where()])
		for k in ["bm_picks_owed", "up_picks_owed", "rune_picks_owed"]:
			m[k] = 0
		if ov != null:
			ov.queue_free()
		await process_frame
		return
	(live[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 2)
	var still: Node = Gate.overlay(s, 60)
	if still != null:
		still.queue_free()
		await process_frame


# One press on the map: the draft and the owed picks first, as the screen chains
# them, then the reading, then the node's own button.
func _step_map(s: Node) -> String:
	if Gate.overlay(s, 62) != null:
		await _answer_the_draft(s)
		return "draft"
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		if int(m.get("bm_picks_owed", 0)) > 0 or int(m.get("up_picks_owed", 0)) > 0 \
				or int(m.get("rune_picks_owed", 0)) > 0:
			await _answer_a_pick(s, idx)
			return "pick"
	var reach: Array = _run.reachable()
	if reach.is_empty():
		return ""
	# THE READING, ON EVERY BOARD: the nodes a player can press are the nodes
	# the party can step to. GI's defect was this set coming back empty.
	_maps_read += 1
	var want: Array = reach.duplicate()
	want.sort()
	var open: Array = Gate.open_nodes(s)
	if open != want:
		_maps_short.append("%s: reachable %s, pressable %s" % [_where(), str(want), str(open)])
	for b in Gate.lattice_buttons(s):
		if String((b as Button).text) == "WARDEN":
			_warden_seen += 1
	var j := int(reach[0])
	var ty := String(_run.map[int(_run.slot_idx) + 1][j]["type"])
	var btn: Button = Gate.bound_button(s, "_on_node_pressed", [j])
	if btn == null:
		return ""
	if ty == "miniboss":
		_mini_labels.append(String(btn.text))
	btn.emit_signal("pressed")
	return ty


func _take_the_mildest(s: Node) -> String:
	var offer: Variant = s.get("offer")
	var takes: Array = []
	var btns: Array = []
	Gate.buttons(s, btns)
	for b in btns:
		if String((b as Button).text) == "Take this bargain" and not (b as Button).disabled:
			takes.append(b)
	if takes.is_empty() or not (offer is Array) or (offer as Array).size() != takes.size():
		return ""
	var best := 0
	var best_sev := 99
	for i in takes.size():
		var sev: int = int(_run.modifier_severity(String(((offer as Array)[i] as Dictionary).get("modifier", ""))))
		if sev < best_sev:
			best_sev = sev
			best = i
	(takes[best] as Button).emit_signal("pressed")
	return "Take this bargain"


func _leave(s: Node, nm: String) -> String:
	match nm:
		"Offer":
			if String(_run.encounter.get("type", "")) == "miniboss":
				# THE PAIR: the opener names the node as its button does, and
				# the word it replaced is gone from it.
				_mini_openers.append(Gate.has_text(s, "The MINI-BOSS of this zone blocks the road.")
					and not Gate.has_text(s, "The WARDEN of this zone"))
			return _take_the_mildest(s)
		"Event":
			var choice := Gate.press(s, [""])
			if choice == "":
				return ""
			await Gate.frames(self, 3)
			var on := Gate.press(s, ["Continue"])
			return choice if on == "" else on
		"Shop":
			return Gate.press(s, ["Leave the Shop"])
		"Blacksmith":
			return Gate.press(s, ["Leave the forge", "Walk on"])
	return Gate.press(s, ["Leave", "Walk on", "Onward", "Continue", "Depart"])


# The main menu's Continue, as a player finds it after a run has ended.
func _continue_state() -> String:
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 6)
	if Gate.scene_name(self) != "MainMenu":
		return "not reached (%s)" % Gate.scene_name(self)
	var btns: Array = []
	Gate.buttons(current_scene, btns)
	for b in btns:
		if String((b as Button).text) == "Continue":
			return "DISABLED" if (b as Button).disabled else "ENABLED"
	return "absent"


# ── §1 — THE ROAD ───────────────────────────────────────────────────────────

func _s1_the_road() -> bool:
	print("\n§1 — the road: a whole run, every step a press on the node's own button")
	seed(ROAD_SEED)
	_new_run()
	ok(int(_run.total_slots()) == 49, "§1: the run is %d slots, not 49" % int(_run.total_slots()))
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)
	var stalled := ""
	var arrived := false
	for _step in MAX_STEPS:
		await Gate.frames(self, 2)
		var s: Node = current_scene
		if s == null or s.is_queued_for_deletion():
			continue
		var nm := Gate.scene_name(self)
		if nm == "Map":
			if not bool(_run.active):
				stalled = "the map is up with the run closed at %s" % _where()
				break
			var nxt: int = int(_run.slot_idx) + 1
			if nxt < _run.map.size() and String(_run.map[nxt][0].get("type", "")) == "endboss":
				arrived = true
				break
			if await _step_map(s) == "":
				stalled = "nothing pressable on the map at %s" % _where()
				break
		elif nm == "Battle":
			var out := await _fight(s)
			if out != "on":
				stalled = "%s, at %s" % [out, _where()]
				break
		elif nm == "MainMenu":
			stalled = "the run bounced to the main menu at %s" % _where()
			break
		elif await _leave(s, nm) == "":
			stalled = "no way off the %s screen at %s" % [nm, _where()]
			break
	if stalled == "" and not arrived:
		stalled = "the step cap of %d ran out at %s" % [MAX_STEPS, _where()]
	print("    %d battles, %d maps read, stopped at %s" % [_battles, _maps_read, _where()])
	ok(stalled == "", "§1: the road stopped — %s" % stalled)
	ok(_maps_read >= 40,
		"§1: the road read %d maps — a run steps onto 48 nodes before the end boss, so the walk stopped short" % _maps_read)
	ok(_maps_short.is_empty(),
		"§1: a map drew no pressable button for a node the party could step to — %s" % [_maps_short])
	ok(_dead.is_empty(), "§1: a screen on the road could not be answered by a press — %s" % [_dead])
	ok(_zone_cards == 3, "§1: the road passed %d zone-boss cards, not three" % _zone_cards)
	# THE MINI-BOSS SAYS WHAT IT IS. The pair: its own button reads MINI-BOSS on
	# every zone's board, and no lattice button the road read carries the word it
	# replaced.
	ok(_mini_labels == ["MINI-BOSS", "MINI-BOSS", "MINI-BOSS"],
		"§1: the three mini-bosses' buttons read %s" % [_mini_labels])
	ok(_warden_seen == 0, "§1: %d lattice buttons on the road still read WARDEN" % _warden_seen)
	ok(_mini_openers == [true, true, true],
		"§1: the mini-bosses' bargains open %s — each should name the MINI-BOSS and not the WARDEN" % [_mini_openers])
	return arrived


# ── §2 / §3 / §4 — THE END BOSS ─────────────────────────────────────────────

func _s2_to_s4_the_end_boss() -> void:
	print("\n§2 — the button: the final board's seventeenth column")
	var s: Node = current_scene
	var reach: Array = _run.reachable()
	var nxt: int = int(_run.slot_idx) + 1
	ok(int(_run.map.size()) == int(_run.END_BOSS_SLOT) + 1 and nxt == int(_run.END_BOSS_SLOT),
		"§2: the final board is %d wide and the next step is slot %d — the end boss is the seventeenth" % [
			int(_run.map.size()), nxt + 1])
	ok(reach.size() == 1, "§2: the third zone's boss leads to %d nodes, not the one end boss" % reach.size())
	if reach.is_empty():
		return
	var nodes := 0
	for col in _run.map:
		nodes += (col as Array).size()
	# THE DEFECT'S OWN SHAPE: the board holds a node and the lattice draws no
	# button for it. Every node, pressable or not, gets exactly one.
	ok(Gate.lattice_buttons(s).size() == nodes,
		"§2: the final board drew %d lattice buttons for its %d nodes" % [Gate.lattice_buttons(s).size(), nodes])
	var btn: Button = Gate.bound_button(s, "_on_node_pressed", [int(reach[0])])
	ok(btn != null, "§2: the final board drew NO pressable button for the end boss — the defect GI fixed")
	if btn == null:
		return
	var crown := Enemies.name_after_the(String(_run.END_BOSS_KIND))
	ok(String(btn.text) == "END BOSS", "§2: the end boss's button reads '%s'" % btn.text)
	ok(String(btn.tooltip_text) == "The END BOSS. Nothing goes around it.\nIt is always the %s, and the road ends here." % crown,
		"§2: the end boss's tooltip reads '%s'" % String(btn.tooltip_text).replace("\n", " / "))
	# THE PAIR: the readout names what the step fights, and not the zone boss the
	# party has just killed.
	var head := _header(s)
	ok(head.ends_with("— the %s waits" % crown), "§2: the readout reads '%s'" % head)
	ok(not head.contains(Enemies.name_after_the(String(_run.boss_kind()))),
		"§2: the readout names the zone boss the party has already killed — '%s'" % head)
	# **BATCH GO — THE BELL IS HELD ON PURPOSE NOW.** GN sanctioned §4's red: the
	# card prints `Run.award_gold`'s figure and the Tollkeeper's Bell pays its +20
	# beside it. GN's seeded road took the Bell off an event; GO's deal of three
	# from six moved the road, the run held no relic, and the arm read green with
	# the defect standing. The Bell is handed to the run here, before the one
	# victory §4 reads, so the arm meets it whatever the road drew.
	if not (_run.active_relics as Array).has("tollbell"):
		_run.active_relics.append("tollbell")
	var gold_before: int = int(_run.gold)
	var relics_before: Array = _relics_on_disk()
	var prof_before: Dictionary = _profile_on_disk()
	btn.emit_signal("pressed")
	await Gate.frames(self, 6)
	var b: Node = current_scene
	ok(Gate.scene_name(self) == "Battle", "§2: pressing END BOSS opened %s, not its fight" % Gate.scene_name(self))
	ok(String(_run.encounter.get("type", "")) == "endboss",
		"§2: the press armed a `%s`, not the end boss" % String(_run.encounter.get("type", "")))
	ok(_kinds(b) == [String(_run.END_BOSS_KIND)], "§2: the fight fields %s, not the Crown alone" % [_kinds(b)])
	if not _is_battle(b) or (b.get("enemies") as Array).is_empty():
		return

	print("\n§3 — the scale: the Crown takes no discount from rung 1")
	_s3_the_scale(b)

	print("\n§4 — the victory")
	await _fight_to_end(b)
	ok(_won(b), "§4: the end boss's fight was not won — with enemy attacks off it cannot be lost, so it never finished")
	var body := "\n".join(Gate.texts(b))
	ok(body.contains("THE DECAY RECEDES"), "§4: the end boss's death drew no completion card")
	ok(body.contains("Run complete — all 3 zones cleansed (wanderer difficulty)."),
		"§4: the completion card does not say the run is complete on the rung it was walked")
	# THE PURSE: the card's figure is the gold that arrived.
	var gm := RegEx.create_from_string("\\+(\\d+) gold\\.").search(body)
	var paid := int(gm.get_string(1)) if gm != null else -1
	ok(paid > 0 and int(_run.gold) - gold_before == paid,
		"§4: the card says +%d gold and the purse moved %d" % [paid, int(_run.gold) - gold_before])
	# THE RELIC: named on the card, and the one id the unlock wrote.
	var rm := RegEx.create_from_string("RELIC UNLOCKED: ([^\\n]+)").search(body)
	var rname := rm.get_string(1).strip_edges() if rm != null else ""
	var rid := ""
	for k in Relics.POOL:
		if String((Relics.POOL[k] as Dictionary).get("name", "")) == rname:
			rid = String(k)
	var relics_after: Array = _relics_on_disk()
	ok(rid != "", "§4: the card names no relic unlocked ('%s')" % rname)
	ok(relics_after.size() == relics_before.size() + 1 and relics_after.has(rid) and not relics_before.has(rid),
		"§4: the relic file went %s -> %s for a card naming '%s'" % [str(relics_before), str(relics_after), rname])
	# THE TIER: on the card and on the disk — and the pair, the end boss pays no point.
	var prof: Dictionary = _profile_on_disk()
	ok(body.contains("TALENT TIER 1 IS OPEN — for every class."), "§4: the card does not open talent tier 1")
	ok(int(prof_before.get("talent_tier", -1)) == 0 and int(prof.get("talent_tier", -1)) == 1,
		"§4: the profile's talent tier went %d -> %d, not 0 -> 1" % [
			int(prof_before.get("talent_tier", -1)), int(prof.get("talent_tier", -1))])
	ok(prof.get("talent_points", {}) == prof_before.get("talent_points", {}),
		"§4: the end boss paid talent points (%s -> %s) — it pays none" % [
			str(prof_before.get("talent_points", {})), str(prof.get("talent_points", {}))])
	ok(int((prof.get("bosses_killed", {}) as Dictionary).get(String(_run.END_BOSS_KIND), 0)) == 1,
		"§4: the profile did not book the end boss's death (%s)" % str(prof.get("bosses_killed", {})))
	var booked := 0
	for sp in SPECS:
		if int((prof.get("runs_completed", {}) as Dictionary).get(sp, 0)) == 1:
			booked += 1
	ok(booked == SPECS.size(), "§4: the run was booked complete for %d of the four specs (%s)" % [
		booked, str(prof.get("runs_completed", {}))])
	ok(int(prof.get("zones_cleared", 0)) == 3, "§4: the profile books %d zones cleared, not 3" % int(prof.get("zones_cleared", 0)))
	ok(not bool(_run.active), "§4: the run is still active after the end boss died")
	ok(not FileAccess.file_exists(String(_run.save_path)), "§4: the run save outlived the run")
	ok(Gate.has_text(b, "New Run") and Gate.has_text(b, "Copy summary"),
		"§4: the completion card does not carry New Run and Copy summary")
	var cont := await _continue_state()
	ok(cont == "DISABLED", "§4: after the run ended the main menu's Continue is %s, not greyed" % cont)


func _s3_the_scale(b: Node) -> void:
	var crown: Node = (b.get("enemies") as Array)[0]
	var base: Dictionary = Enemies.config(String(_run.END_BOSS_KIND))
	var z: int = int(_run.zone_idx) + 1
	var ladder: float = float(_run.ZONE_BASE_MULTS[z - 1])
	var tier: int = clampi(int(_run.slot_idx) + 1, 1, int(_run.SLOTS_PER_ZONE))
	var full: float = float(_run.DIFFICULTIES["warden"]["mult"])
	var cut: float = float(_run.DIFFICULTIES["wanderer"]["mult"])
	var want_atk := int(round(int(base["attack"]) * ladder * full * (1.0 + 0.02 * tier)))
	var cut_atk := int(round(int(base["attack"]) * ladder * cut * (1.0 + 0.02 * tier)))
	var want_hp := int(ceil(int(base["max_hp"]) * ladder * full * (1.0 + 0.025 * tier) / 10.0) * 10.0)
	print("    the Crown at rung 1: Attack %d, health %d  (rung 2's %d / %d; the discount would read %d)" % [
		int(crown.get("attack")), int(crown.get("max_hp")), want_atk, want_hp, cut_atk])
	ok(String(_run.difficulty) == "wanderer", "§3: the road was walked on '%s', not rung 1 — the discount cannot be read" % String(_run.difficulty))
	# THE PAIR: rung 2's Attack, and not the discounted one.
	ok(int(crown.get("attack")) == want_atk,
		"§3: the Crown's Attack at rung 1 is %d, not the %d rung 2 fields" % [int(crown.get("attack")), want_atk])
	ok(int(crown.get("attack")) != cut_atk,
		"§3: the Crown's Attack is rung 1's discounted %d — the rung still softens it" % cut_atk)
	ok(int(crown.get("max_hp")) == want_hp,
		"§3: the Crown's health at rung 1 is %d, not the %d rung 2 fields" % [int(crown.get("max_hp")), want_hp])
	# THE DOOR THE SPAWN READS, AT EVERY RUNG. At rung 1 the end boss's multiplier
	# is the health path's and not the discounted attack path's; at rungs 2 and 3
	# it is the ordinary attack path's — they do not move.
	var was := String(_run.difficulty)
	_run.difficulty = "wanderer"
	ok(is_equal_approx(float(_run.end_boss_mult(z)), float(_run.zone_base_mult_hp(z)))
		and not is_equal_approx(float(_run.end_boss_mult(z)), float(_run.zone_base_mult(z))),
		"§3: at rung 1 the end boss's multiplier is %.3f — the ordinary attack path's %.3f, the health path's %.3f" % [
			float(_run.end_boss_mult(z)), float(_run.zone_base_mult(z)), float(_run.zone_base_mult_hp(z))])
	for rid in ["warden", "ruin"]:
		_run.difficulty = rid
		ok(is_equal_approx(float(_run.end_boss_mult(z)), float(_run.zone_base_mult(z))),
			"§3: at '%s' the end boss's multiplier is %.3f against the ordinary %.3f — rungs 2 and 3 must not move" % [
				rid, float(_run.end_boss_mult(z)), float(_run.zone_base_mult(z))])
	_run.difficulty = was


# ── §5 — THE DEFEAT ──────────────────────────────────────────────────────────

func _s5_the_defeat() -> void:
	print("\n§5 — the end boss lost")
	# THE ROAD IS CONSTRUCTED HERE, as `check_fh` §8 constructs it — §1 walked
	# it — and the step onto the end boss is its own button again.
	seed(ROAD_SEED + 1)
	_new_run()
	while bool(_run.has_next_zone()):
		_run.advance_zone()
	_run.zone_bosses_cleared = 3
	_run.slot_idx = int(_run.BOSS_SLOT)
	_run.node_idx = 0
	_run.save_run()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)
	var reach: Array = _run.reachable()
	var btn: Button = Gate.bound_button(current_scene, "_on_node_pressed", [int(reach[0])]) \
		if not reach.is_empty() else null
	ok(btn != null and String(btn.text) == "END BOSS", "§5: the final board drew no END BOSS button to press")
	if btn == null:
		return
	var zname := String(_run.zone_name)
	btn.emit_signal("pressed")
	await Gate.frames(self, 6)
	ok(Gate.scene_name(self) == "Battle", "§5: pressing END BOSS opened %s" % Gate.scene_name(self))
	# THE LAST FALL, ON THE SAVE (GH). The battle's own Exit writes the party as
	# it stands; every hero is then written down, which is what the save holds
	# when the last blow lands and the window closes before the defeat card.
	var mb: MenuButton = Gate.menu_button(current_scene) if Gate.scene_name(self) == "Battle" else null
	ok(mb != null, "§5: the end boss's fight drew no ☰")
	if mb == null:
		return
	mb.get_popup().emit_signal("id_pressed", 2)
	await Gate.frames(self, 6)
	var d := _disk()
	ok(String((d.get("encounter", {}) as Dictionary).get("type", "")) == "endboss",
		"§5: the quit's save does not hold the end boss's fight (%s)" % str(d.get("encounter", {})))
	for m in d.get("party", []):
		(m as Dictionary)["hp"] = 0
	_write_disk(d)
	var relics_before: Array = _relics_on_disk()
	var prof_before: Dictionary = _profile_on_disk()
	var landed := "not the main menu (%s)" % Gate.scene_name(self)
	if Gate.scene_name(self) == "MainMenu":
		landed = "no Continue button"
		var btns: Array = []
		Gate.buttons(current_scene, btns)
		for c in btns:
			if String((c as Button).text) == "Continue" and not (c as Button).disabled:
				c.emit_signal("pressed")
				for _i in 60:
					await Gate.frames(self, 1)
					if Gate.scene_name(self) != "MainMenu":
						break
				await Gate.frames(self, 4)
				landed = Gate.scene_name(self)
				break
	ok(landed == "Battle", "§5: Continue opened %s, not the end boss's fight" % landed)
	var b: Node = current_scene
	await _fight_to_end(b)
	ok(_is_battle(b) and not _won(b), "§5: the resumed fight with every hero down was not a defeat")
	var body := "\n".join(Gate.texts(b))
	var crown := Enemies.name_after_the(String(_run.END_BOSS_KIND))
	var full_name := Enemies.unit_name(String(_run.END_BOSS_KIND))
	ok(body.contains("THE HEROES HAVE FALLEN"), "§5: the defeat drew no wipe card")
	ok(body.contains("Wiped — Zone 3 (%s), facing the %s (wanderer difficulty)." % [zname, crown]),
		"§5: the wipe card does not say the party fell facing the %s" % crown)
	# THE PAIR: the final battle names the Crown once, and the doubled line is gone.
	ok(body.contains("The END BOSS — %s." % full_name),
		"§5: the final battle does not read 'The END BOSS — %s.'" % full_name)
	ok(not body.contains("The END BOSS — %s: %s." % [full_name, full_name]),
		"§5: the final battle still names the Crown twice")
	var prof: Dictionary = _profile_on_disk()
	var wiped := 0
	for sp in SPECS:
		if int((prof.get("wipes", {}) as Dictionary).get(sp, 0)) \
				== int((prof_before.get("wipes", {}) as Dictionary).get(sp, 0)) + 1:
			wiped += 1
	ok(wiped == SPECS.size(), "§5: the defeat booked a wipe for %d of the four specs (%s)" % [
		wiped, str(prof.get("wipes", {}))])
	# AND WHAT IT DID NOT PAY — each the pair of an arm §4 asserted.
	ok(int(prof.get("talent_tier", -1)) == 0, "§5: a defeat opened talent tier %d" % int(prof.get("talent_tier", -1)))
	ok((prof.get("runs_completed", {}) as Dictionary).is_empty(),
		"§5: a defeat booked a completion (%s)" % str(prof.get("runs_completed", {})))
	ok(_relics_on_disk() == relics_before, "§5: a defeat unlocked a relic (%s -> %s)" % [
		str(relics_before), str(_relics_on_disk())])
	ok(not bool(_run.active) and not FileAccess.file_exists(String(_run.save_path)),
		"§5: the run outlived its defeat (active %s, save on disk %s)" % [
			str(_run.active), str(FileAccess.file_exists(String(_run.save_path)))])
	var cont := await _continue_state()
	ok(cont == "DISABLED", "§5: after the defeat the main menu's Continue is %s, not greyed" % cont)


# ── §6 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s6_the_players_files() -> void:
	print("\n§6 — the player's files")
	for p in _player:
		var had: bool = bool(_player[p][0])
		ok(FileAccess.file_exists(p) == had,
			"§6: %s is not as this gate found it (it %s)" % [p, "existed" if had else "did not exist"])
		ok(not had or FileAccess.get_file_as_bytes(p) == _player[p][1], "§6: %s came back changed" % p)
