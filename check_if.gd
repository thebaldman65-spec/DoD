# BATCH IF — THE READOUT, A CARD, AND TWO PANELS.
#
#   §1a THE READOUT IS THE PLAYER'S: `Readout.wanted` read both ways — on in the player's own game unless asked off,
#       off in every harness unless asked on — and this process (a `--script` one) is not the player's.
#   §1b ONE FIGHT, THE READOUT OFF, ON AND OFF AGAIN, BYTE FOR BYTE — the batch's pass condition, kept: the same
#       seeded fight fought by the bot to its end three times; the combat log, every unit's figures, the run, the
#       save the run writes and the next die read the same with the readout on as with it off (and the two off
#       arms agree, which is what shows the harness itself repeats). The on arm wrote one file and the off arms none.
#   §1c THE FILE: a header (the party's classes, lineages, core and ordinary runes, nodes; the relics; the rung)
#       and one line for the fight — its frame and every hero's resource as a human's play can be read.
#   §1d THE LONGEST CASE IN ONE FILE: a Rupture formed and ticked, a Boil Over poured, a vow that refused a blow
#       and added to a heal, a Hierophant's Sanctity — each read off the line the real doors wrote.
#   §1e THE READOUT IS A READ, SWEPT: its source spends no die and writes nothing the game reads; every hook in
#       `battle.gd` stands behind `if _readout != null`; the save names no key of it.
#   §2  SMOULDER: in the Mage's one pool with no `ENGINE_READ` row, offered to a Mage holding no engine; a fire
#       card cheaper than every other fire card a Mage can hold, Fireball's cooldown, a longer Burn than
#       Fireball's and less damage; driven — a cold enemy lit, a lit one extended and nothing consumed, Emberkeep
#       doubling it and Downwind carrying it (the status door), a chilled body made a Rupture.
#   §3a THE LOADOUT PANEL IN FOUR SECTIONS — CORE, ENABLERS, CARRIED, BENCHED: every row in the section its state
#       names, no ✦ on a card, no state word in a row; Bench moves a card down; the emptiest panel's notes.
#   §3b THE CREST PANEL SPLIT — THE CREST (the worn crest rune, its slot drawn when empty) and IN THE BAG (every
#       rune the bag holds, a crest rune with Equip or Swap beside its Drop): each rune once, no ✦, no *(in the
#       bag)*; Equip moves it up; the emptiest panel.
#   §3c NO PANEL STATES A ROW'S STATE TWICE: the rune panel (IA), the loadout panel and the crest panel, swept.
#   §4  THE CRACKED HOURGLASS REACHES EVERY MANA HERO: through the real victory door, the Hunter recovers as the
#       Mage and the Cleric do, the Warrior's Rage is not touched, and a bar above the member's cap is not cut.
#   §9  The player's files, and the player's own readout folder, are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** The five rulings the readout exists for are the designer's play; this
# asserts the instrument is a read, writes what it says, and is off everywhere but his game. Smoulder's reach —
# Burn standing on most of a reader-draft's turns — is a sim measurement in the report (IF §2). `Run` is fetched off
# the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_if.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://if_profile.json"
const SCRATCH_RELICS := "user://if_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SPECS := ["berserker", "cryomancer", "holy", "mystic"]
const SEED := 20261014
const FRAME_CAP := 30000
const STAR := "✦"
const READOUT_DIR := "user://readout_harness"
const PLAYER_READOUT_DIR := "user://readout"
const ENC := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _player_readout := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IF — THE READOUT, A CARD, AND TWO PANELS")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_player_readout = _listing(PLAYER_READOUT_DIR)
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_clear_harness_readout()
	_s1a_the_decision()
	await _s1b_on_and_off()
	await _s1d_the_longest_case()
	_s1e_the_sweep()
	await _s2_smoulder()
	await _s3a_the_loadout_panel()
	await _s3b_the_crest_panel()
	await _s3c_no_row_twice()
	await _s4_the_hourglass()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	OS.set_environment("DOD_READOUT", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


# Every file in a folder and its bytes — the player's readout folder is compared whole, before and after.
func _listing(dir_path: String) -> Dictionary:
	var out := {}
	if not DirAccess.dir_exists_absolute(dir_path):
		return out
	for f in DirAccess.get_files_at(dir_path):
		out[String(f)] = FileAccess.get_file_as_bytes(dir_path.path_join(String(f)))
	return out


# The harness's own readout folder: emptied, then gone — this gate is the only thing that writes it.
func _clear_harness_readout() -> void:
	if not DirAccess.dir_exists_absolute(READOUT_DIR):
		return
	for f in DirAccess.get_files_at(READOUT_DIR):
		_remove(READOUT_DIR.path_join(String(f)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(READOUT_DIR))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string(JSON.stringify([]))
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	return current_scene


func _board(specs: Array, over: Dictionary = {}) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	await Gate.frames(self, 3)


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == key:
			return h
	return null


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _wipe(u: BattleUnit) -> void:
	u.statuses = []
	u.broken = false
	u.broken_pending = false
	u.pressure = 0
	u.max_hp = maxi(u.max_hp, 100000)
	u.hp = u.max_hp
	u._refresh_chips()


func _rune(id: String, worn: bool) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = worn
	return r


func _ability(u: BattleUnit, name: String) -> Ability:
	for ab in u.abilities:
		if ab != null and String(ab.display_name) == name:
			return ab
	return null


# The fight's end, as `_check_end` reads it: the warband down. The combat is not the subject here.
func _end_fight(s: Node) -> void:
	for e in s.get("enemies"):
		(e as BattleUnit).hp = 0
		(e as BattleUnit).dead = true
	s.call("_check_end")


func _read_lines(path: String) -> Array:
	var out: Array = []
	if path == "" or not FileAccess.file_exists(path):
		return out
	for ln in FileAccess.get_file_as_string(path).split("\n"):
		if String(ln).strip_edges() == "":
			continue
		var v: Variant = JSON.parse_string(String(ln))
		out.append(v if v is Dictionary else {"unparsed": String(ln)})
	return out


func _scroller(n: Node) -> ScrollContainer:
	if n == null:
		return null
	for c in n.get_children():
		if c is ScrollContainer:
			return c
		var x := _scroller(c)
		if x != null:
			return x
	return null


# A panel's list read in order: a label its text, a separator `<sep>`, a row `row:` + EVERY label it holds, in
# order and joined by ` ¦ ` (so a state column standing beside the name is read, not skipped — a row reads its last
# label alone only when it has one), and `|` + the texts of its buttons. What a section holds is read off this,
# never off the run's own lists.
func _sequence(ov: Node) -> Array:
	var out: Array = []
	var sc := _scroller(ov)
	if sc == null or sc.get_child_count() != 1:
		return out
	for c in (sc.get_child(0) as Node).get_children():
		if c.is_queued_for_deletion():
			continue
		if c is HSeparator:
			out.append("<sep>")
		elif c is Label:
			out.append(String((c as Label).text))
		elif c is HBoxContainer:
			var labels: Array = []
			var btns: Array = []
			for k in c.get_children():
				if k is Label:
					labels.append(String((k as Label).text))
				elif k is Button:
					btns.append(String((k as Button).text))
			out.append("row:%s|%s" % [" ¦ ".join(PackedStringArray(labels)), ",".join(PackedStringArray(btns))])
	return out


# The rows between a head (by its prefix) and the next separator, each as [label, buttons].
func _section(seq: Array, head_prefix: String) -> Dictionary:
	var rows: Array = []
	var notes: Array = []
	var inside := false
	var found := false
	for e in seq:
		var s := String(e)
		if not inside and s.begins_with(head_prefix):
			inside = true
			found = true
			continue
		if inside and s == "<sep>":
			break
		if inside and s.begins_with("row:"):
			var body := s.substr(4)
			rows.append([body.get_slice("|", 0), body.get_slice("|", 1)])
		elif inside:
			notes.append(s)
	return {"found": found, "rows": rows, "notes": notes}


# Every Label under a node, in tree order (BATCH IG §3: the Kit panel's words read whole, the note above the sections too).
func _labels(n: Node) -> Array:
	var out: Array = []
	if n == null:
		return out
	for c in n.get_children():
		if c is Label and not c.is_queued_for_deletion():
			out.append(c)
		out.append_array(_labels(c))
	return out


func _row_names(sec: Dictionary) -> Array:
	return (sec["rows"] as Array).map(func(r): return String(r[0]).get_slice(" — ", 0).get_slice("  (", 0))


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and (c as Control).z_index == 60:
			c.queue_free()
	mp.set("_loadout_panel_for", -1)
	mp.set("_bag_panel_open", false)


# ── §1a — THE DECISION ───────────────────────────────────────────────────────────

func _s1a_the_decision() -> void:
	print("\n§1a — the readout is on in the player's own game and off in every harness, each unless asked")
	var R: GDScript = load("res://scripts/readout.gd")
	# env, an active run, the player's process -> wanted
	var table := [
		["", true, true, true], ["", true, false, false], ["", false, true, false],
		["0", true, true, false], ["0", true, false, false],
		["1", true, false, true], ["1", true, true, true], ["1", false, false, false],
	]
	var wrong: Array = []
	for row in table:
		if bool(R.wanted(String(row[0]), bool(row[1]), bool(row[2]))) != bool(row[3]):
			wrong.append(row)
	ok(wrong.is_empty(), "§1a: the readout's decision is wrong for %s (env, active, player, wanted)" % [wrong])
	ok(not bool(_run.readout_is_player()), "§1a: a `--script` process reads as the player's own game")
	_new_run()
	OS.set_environment("DOD_READOUT", "")
	ok(not bool(_run.readout_wanted()), "§1a: the readout is on in a harness that did not ask for it")
	OS.set_environment("DOD_READOUT", "1")
	ok(bool(_run.readout_wanted()), "§1a: a harness that asks (DOD_READOUT=1) does not get the readout")
	OS.set_environment("DOD_READOUT", "")


# ── §1b — ONE FIGHT, OFF / ON / OFF ─────────────────────────────────────────────

func _fight_arm(readout: String) -> Dictionary:
	_fresh_meta()
	seed(SEED)
	_new_run()
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["engines"] = Runes.engine_pouch_for_spec(String(SPECS[i]))
		_run.sync_spec_hp(i)
	OS.set_environment("DOD_READOUT", readout)
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Gate.enter_battle(self, ENC.duplicate(true))
	await Gate.frames(self, 2)
	var s: Node = current_scene
	var guard := 0
	while s != null and is_instance_valid(s) and not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_READOUT", "")
	var out := {"ended": guard < FRAME_CAP and s != null and bool(s.get("battle_over"))}
	if not bool(out["ended"]):
		return out
	await Gate.frames(self, 4)
	out["die"] = randi()
	out["log"] = String((s.get("history") as RichTextLabel).get_parsed_text())
	var units: Array = []
	for u in (s.get("heroes") as Array) + (s.get("enemies") as Array):
		var bu := u as BattleUnit
		var st: Array = []
		for e in bu.statuses:
			st.append("%s:%d:%d" % [String(e.get("id", "")), int(e.get("turns", 0)), int(e.get("stacks", 1))])
		units.append([bu.unit_name, bu.hp, bu.max_hp, bu.resource, bu.dead, st])
	out["units"] = var_to_str(units)
	out["run"] = var_to_bytes([_run.party, _run.items, _run.gold, _run.combat_wins, _run.tally, _run.rune_bag,
		_run.pending_rune_drops, _run.encounter, _run.pending_reward]).hex_encode().md5_text()
	_run.save_run()
	out["save"] = FileAccess.get_file_as_bytes(String(_run.save_path)).hex_encode().md5_text()
	out["readout"] = (_run.readout as Dictionary).duplicate(true)
	out["log_lines"] = String(out["log"]).count("\n")
	return out


func _s1b_on_and_off() -> void:
	print("\n§1b — one seeded fight fought to its end three times: the readout off, on, and off again")
	var off1 := await _fight_arm("")
	var on := await _fight_arm("1")
	var off2 := await _fight_arm("")
	ok(bool(off1.get("ended", false)) and bool(on.get("ended", false)) and bool(off2.get("ended", false)),
		"§1b: the premise — each arm's fight ended inside %d frames (%s %s %s)" % [FRAME_CAP,
			off1.get("ended", false), on.get("ended", false), off2.get("ended", false)])
	if not (bool(off1.get("ended", false)) and bool(on.get("ended", false)) and bool(off2.get("ended", false))):
		return
	print("    the log %d lines a fight; the next die %d / %d / %d" % [int(off1["log_lines"]), int(off1["die"]),
		int(on["die"]), int(off2["die"])])
	ok(int(off1["log_lines"]) > 10, "§1b: the premise — the fight wrote a combat log (%d lines)" % int(off1["log_lines"]))
	# THE CONTROL: the harness repeats itself, readout off both times.
	for k in ["log", "units", "run", "save", "die"]:
		ok(str(off1[k]) == str(off2[k]), "§1b: the two OFF arms disagree on %s — the seeded fight does not repeat, so the comparison below proves nothing" % k)
	# THE PASS CONDITION.
	for k in ["log", "units", "run", "save", "die"]:
		ok(str(on[k]) == str(off1[k]), "§1b: the readout ON moved %s — it is not a read" % k)
	ok(String((off1["readout"] as Dictionary).get("path", "")) == "" and String((off2["readout"] as Dictionary).get("path", "")) == "",
		"§1b: an OFF arm wrote a readout file")
	var path := String((on["readout"] as Dictionary).get("path", ""))
	ok(path.begins_with(READOUT_DIR + "/") and FileAccess.file_exists(path),
		"§1b: the ON arm wrote no file in the harness's folder ('%s')" % path)
	_s1c_the_file(path)
	_clear_harness_readout()
	ok(_listing(READOUT_DIR).is_empty(), "§1b: the harness's readout folder outlived the gate's clean-up")


func _s1c_the_file(path: String) -> void:
	print("\n§1c — the file: a header, then one line for the fight")
	var lines := _read_lines(path)
	var bytes := FileAccess.get_file_as_bytes(path).size() if FileAccess.file_exists(path) else 0
	print("    %s — %d lines, %d bytes" % [path.get_file(), lines.size(), bytes])
	ok(lines.size() == 2, "§1c: the file holds %d lines — want the header and one fight" % lines.size())
	if lines.size() < 2:
		return
	var h: Dictionary = lines[0]
	var f: Dictionary = lines[1]
	ok(String(h.get("kind", "")) == "run" and int(h.get("readout", 0)) >= 1 and h.has("rung") and h.has("relics")
			and h.has("crest") and (h.get("party", []) as Array).size() == 4,
		"§1c: the header is not the run's: %s" % [str(h).left(300)])
	var shapes: Array = []
	for row in h.get("party", []):
		var r: Dictionary = row
		if not (r.has("class") and r.has("lineage") and r.has("core") and r.has("runes") and r.has("nodes")):
			shapes.append(r)
	ok(shapes.is_empty() and String((h["party"] as Array)[0].get("lineage", "")) == SPECS[0],
		"§1c: a header row does not carry the class, lineage, core and ordinary runes and nodes: %s" % [shapes])
	ok(String(f.get("kind", "")) == "fight" and int(f.get("n", 0)) == 1
			and String(f.get("encounter", "")) == String(ENC["type"]) and f.get("enemies", []) == ENC["enemies"]
			and String(f.get("outcome", "")) in ["victory", "defeat", "stalemate"] and f.has("zone") and f.has("rounds")
			and (f.get("heroes", []) as Array).size() == 4 and f.has("conjunctions") and f.has("boil_over") and f.has("fell"),
		"§1c: the fight line is not the fight's frame: %s" % [str(f).left(300)])
	var bad: Array = []
	var turns := 0
	for row2 in f.get("heroes", []):
		var r2: Dictionary = row2
		turns += int(r2.get("turns", 0))
		var t := int(r2.get("turns", -1))
		var ct := int(r2.get("costed_turns", -1))
		var sd := int(r2.get("soft_dry", -1))
		var hd := int(r2.get("hard_dry", -1))
		var of := int(r2.get("opened_full", -1))
		var lw := float(r2.get("low_water", -1.0))
		if t < 1 or ct < 0 or ct > t or sd > ct or hd > sd or hd < 0 or of < 0 or of > t or lw < 0.0 or lw > 1.0 \
				or String(r2.get("resource", "")) == "" or int(r2.get("max", 0)) <= 0:
			bad.append("%s %s" % [r2.get("name", "?"), [t, of, ct, sd, hd, lw]])
	ok(bad.is_empty(), "§1c: a hero's resource is not read as a human's play can be (turns, opened full, costed, soft, hard, low): %s" % [bad])
	ok(turns == int(f.get("hero_turns", -1)) and turns > 0,
		"§1c: the heroes' turns (%d) are not the fight's hero turns (%d)" % [turns, int(f.get("hero_turns", -1))])
	ok(bytes > 0 and bytes < int((load("res://scripts/readout.gd") as GDScript).get_script_constant_map()["MAX_BYTES"]),
		"§1c: the file is not inside its bound (%d bytes)" % bytes)


# ── §1d — THE LONGEST CASE ───────────────────────────────────────────────────────

func _s1d_the_longest_case() -> void:
	print("\n§1d — a Rupture, a Boil Over, a vow and a Hierophant's Sanctity in one fight's line")
	_fresh_meta()
	_clear_harness_readout()
	var sanct: Dictionary = _rune(Runes.engine_rune_id("sanctity"), true)
	var over := {
		0: {"bm_abilities": ["Boil Over"], "bm_equipped": ["Boil Over"]},
		1: {"bm_abilities": ["Smoulder"], "bm_equipped": ["Smoulder"]},
		2: {"runes": [_rune("vow_of_silence", true)], "engines": Runes.engine_pouch_for_spec("holy") + [sanct]},
	}
	OS.set_environment("DOD_READOUT", "1")
	var s: Node = await _board(SPECS, over)
	OS.set_environment("DOD_READOUT", "")
	var war := _hero(s, "warrior")
	var mage := _hero(s, "mage")
	var cl := _hero(s, "cleric")
	var foes := _foes(s)
	var boil: Ability = _ability(war, "Boil Over") if war != null else null
	var smoulder: Ability = _ability(mage, "Smoulder") if mage != null else null
	var heal: Ability = Classes.pool_ability("Heal")
	ok(war != null and mage != null and cl != null and foes.size() >= 2 and boil != null and smoulder != null
			and s.get("_readout") != null and float(cl.rune_vow_of_silence) > 0.0 and bool(cl.sanctity_active),
		"§1d: the premise — a Berserker with Boil Over, a Cryomancer with Smoulder, a vowed Hierophant Cleric, two enemies and the readout on")
	if war == null or mage == null or cl == null or foes.size() < 2 or boil == null or smoulder == null or s.get("_readout") == null:
		await _clear(s)
		return
	for f in foes:
		_wipe(f)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, Classes.pool_ability("Frostbolt"), a, "good")
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, smoulder, a, "good")
	ok(a.has_status("rupture"), "§1d: the premise — Frostbolt then Smoulder on one body made no Rupture")
	await s.call("_dot_pass", a)
	war.resource = war.max_resource
	await s.call("_resolve", war, boil, b, "good")
	cl.resource = cl.max_resource
	await s.call("_resolve", cl, cl.abilities[0], b, "good")
	mage.hp = maxi(mage.max_hp / 3, 1)
	cl.resource = cl.max_resource
	await s.call("_resolve", cl, heal, mage, "good")
	var path := String((_run.readout as Dictionary).get("path", ""))
	_end_fight(s)
	await Gate.frames(self, 2)
	path = String((_run.readout as Dictionary).get("path", ""))
	var lines := _read_lines(path)
	ok(lines.size() == 2, "§1d: the file holds %d lines — want the header and the fight" % lines.size())
	if lines.size() < 2:
		await _clear(s)
		_clear_harness_readout()
		return
	var f2: Dictionary = lines[1]
	var cj: Array = f2.get("conjunctions", [])
	print("    conjunctions %s" % [str(cj).left(240)])
	ok(cj.size() >= 1 and String(cj[0].get("name", "")) == String(s.get("STATUS_INFO")["rupture"][0])
			and String(cj[0].get("degree", "")) == "second" and (cj[0].get("ingredients", []) as Array).size() == 2
			and int(cj[0].get("ticks", 0)) >= 1 and int(cj[0].get("break", 0)) >= int(s.get("RUPTURE_BREAK_PER_TICK"))
			and String(cj[0].get("on", "")) == a.unit_name,
		"§1d: the Rupture is not on the line by its name, degree, ingredients, its tick and the Break it ground out")
	var bo: Array = f2.get("boil_over", [])
	print("    boil over %s" % [str(bo).left(200)])
	ok(bo.size() == 1 and int(bo[0].get("rage", 0)) >= Classes.rage_dump_min(war.max_resource)
			and int(bo[0].get("damage", 0)) > 0 and bool(bo[0].get("core_on", false)) and bo[0].has("best_ordinary_turn"),
		"§1d: the Boil Over is not on the line with its Rage, its damage, the core and the best ordinary turn")
	var clr: Dictionary = {}
	for row in f2.get("heroes", []):
		if String((row as Dictionary).get("class", "")) == "cleric":
			clr = row
	var vow: Dictionary = clr.get("vow", {})
	print("    the vow %s; Sanctity %s" % [vow, clr.get("sanctity", {})])
	ok(int(vow.get("damage_refused", 0)) > 0 and int(vow.get("blows_refused", 0)) >= 1 and int(vow.get("heal_added", 0)) > 0,
		"§1d: the vow is not on the line with the blow it refused and the healing it added: %s" % [vow])
	var sc: Dictionary = clr.get("sanctity", {})
	ok(sc.has("events") and sc.has("steps") and int(sc.get("events", -1)) == int(BattleUnit.sanctity_events),
		"§1d: a Hierophant's Sanctity is not on the line as the ledger stood: %s" % [sc])
	var others: Array = []
	for r3 in f2.get("heroes", []):
		var rd: Dictionary = r3
		if String(rd.get("class", "")) != "cleric" and (rd.has("vow") or rd.has("sanctity")):
			others.append(rd.get("name", "?"))
	ok(others.is_empty(), "§1d: a hero with no vow and no Sanctity carries their lines: %s" % [others])
	await _clear(s)
	_clear_harness_readout()


# ── §1e — THE SWEEP ──────────────────────────────────────────────────────────────

func _s1e_the_sweep() -> void:
	print("\n§1e — the readout's source spends no die and writes nothing the game reads")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/readout.gd"))
	var banned := ["randf", "randi", "rand_range", "seed(", "shuffle(", "pick_random(", "add_status(", "update_status(",
		"remove_status(", "_apply_status(", "float_text(", "_log(", "_stat(", "take_hit(", "heal_amount(",
		"take_tick_damage(", "save_run(", "refresh_bars(", ".set(", "emit_signal("]
	var hits: Array = banned.filter(func(n): return src.contains(n))
	ok(hits.is_empty(), "§1e: the readout's source spends a die or writes the game: %s" % [hits])
	# No unit or run field is assigned: a write to `u.`, `body.`, `src.` or `_run.`/`_battle.` is the bug.
	var assign := RegEx.create_from_string("\\b(u|body|src|h|ab|_run|_battle|run|battle)\\.[A-Za-z_]+\\s*(\\+|-|\\*|/)?=(?!=)")
	var writes: Array = []
	for m in assign.search_all(src):
		writes.append(m.get_string())
	ok(writes.is_empty(), "§1e: the readout assigns a field of the game: %s" % [writes])
	ok(src.contains("FileAccess.open(") and src.contains("store_line("),
		"§1e: the positive arm — the sweep reads the file that writes the readout")
	# Every hook in battle.gd stands behind its null test, alone.
	var lines := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")).split("\n")
	var calls := 0
	var bare: Array = []
	for i in lines.size():
		var t := String(lines[i]).strip_edges()
		if not t.begins_with("_readout.") and not t.contains(" _readout."):
			continue
		if t.begins_with("_readout = ") or t.begins_with("var _readout"):
			continue
		calls += 1
		var j := i - 1
		while j >= 0 and String(lines[j]).strip_edges() == "":
			j -= 1
		var prev := String(lines[j]).strip_edges() if j >= 0 else ""
		if not (prev == "if _readout != null:" or prev.begins_with("if _readout != null and ")
				or prev.begins_with("_readout = load(")):
			bare.append(t)
	print("    %d hook calls in battle.gd" % calls)
	ok(calls >= 12 and bare.is_empty(), "§1e: a readout hook in battle.gd does not stand behind its null test: %s (%d calls)" % [bare, calls])
	var rs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	var at := rs.find("func save_run()")
	var body := rs.substr(at, rs.find("\nfunc ", at + 10) - at) if at >= 0 else ""
	ok(body.contains("file.store_var(") and not body.contains("readout"),
		"§1e: the save names the readout, or the sweep did not find `save_run`'s keys")


# ── §2 — SMOULDER ────────────────────────────────────────────────────────────────

func _s2_smoulder() -> void:
	print("\n§2 — Smoulder: the Mage's light that buys the Burn, not the hit")
	var sm: Ability = Classes.pool_ability("Smoulder")
	var fb: Ability = Classes.pool_ability("Fireball")
	ok(sm != null and fb != null, "§2: the premise — Smoulder and Fireball resolve")
	if sm == null or fb == null:
		return
	ok(Classes.draft_pool("mage").has("Smoulder") and not Classes.ENGINE_READ.has("Smoulder")
			and Classes.offerable(Classes.draft_pool("mage"), []).has("Smoulder"),
		"§2: Smoulder is not in the Mage's one pool, offered to a Mage holding no engine")
	ok(Classes.CARD_TAGS.has("Smoulder"), "§2: Smoulder has no tag row")
	var sm_turns := int(sm.applies_status.get("turns", 0))
	var fb_turns := int(fb.applies_status.get("turns", 0))
	ok(sm.dmg_type == "fire" and String(sm.applies_status.get("id", "")) == "burn" and sm_turns > fb_turns
			and sm.cooldown == fb.cooldown and sm.damage > 0 and sm.damage < fb.damage and sm.cost > 0,
		"§2: Smoulder is not a fire card laying a longer Burn than Fireball's, on Fireball's cooldown, for less damage")
	# The price: below every other fire card a Mage can hold (IE §3a's census) — the figure the designer set.
	var dearer: Array = []
	for n in Classes.draft_pool("mage"):
		var ab: Ability = Classes.pool_ability(String(n))
		if ab != null and String(n) != "Smoulder" and ab.dmg_type == "fire" and ab.cost > 0 and ab.cost <= sm.cost:
			dearer.append("%s %d" % [n, ab.cost])
	ok(dearer.is_empty(), "§2: a fire card costs no more than Smoulder: %s" % [dearer])
	print("    Smoulder %d Mana, cooldown %d, %d%% of Attack, Burn %d turns — Fireball %d, %d, %d%%, %d" % [sm.cost,
		sm.cooldown, sm.damage, sm_turns, fb.cost, fb.cooldown, fb.damage, fb_turns])
	var s: Node = await _board(["warden", "cryomancer", "holy", "mystic"])
	var mage := _hero(s, "mage")
	var hunter := _hero(s, "hunter")
	var foes := _foes(s)
	if mage == null or hunter == null or foes.size() < 3:
		ok(false, "§2: the board seats a Mage, a Hunter and three enemies")
		await _clear(s)
		return
	for f in foes:
		_wipe(f)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	# A COLD ENEMY LIT.
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == sm_turns,
		"§2: Smoulder did not set a cold enemy Burning for its %d turns (got %d)" % [sm_turns, int(a.get_status("burn").get("turns", 0))])
	# A LIT ONE EXTENDED, NOTHING CONSUMED.
	s.call("_apply_status", b, "burn", 3, 0, 6, mage)
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, b, "good")
	ok(int(b.get_status("burn").get("turns", 0)) == 3 + sm_turns,
		"§2: Smoulder on a burning enemy did not add its turns to the Burn that stands (3 -> %d)" % int(b.get_status("burn").get("turns", 0)))
	# THROUGH THE STATUS DOOR: Emberkeep doubles it, and Downwind carries it to a second enemy.
	for f in foes:
		_wipe(f)
	s.call("_apply_status", mage, "emberkeep", 5, 0, 0, mage)
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == sm_turns * 2,
		"§2: Emberkeep did not double Smoulder's Burn — it is laid around the status door (read %d)" % int(a.get_status("burn").get("turns", 0)))
	mage.remove_status("emberkeep")
	for f in foes:
		_wipe(f)
	s.call("_apply_status", hunter, "downwind", 4, 0, 0, hunter)
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, a, "good")
	var carried := [b, c].filter(func(e): return (e as BattleUnit).has_status("burn"))
	ok(a.has_status("burn") and carried.size() == 1, "§2: Downwind did not carry Smoulder's Burn to a second enemy (%d carried)" % carried.size())
	hunter.remove_status("downwind")
	# A CHILLED BODY LIT IS A RUPTURE.
	for f in foes:
		_wipe(f)
	s.call("_apply_status", c, "chilled", 3, 0, 0, mage)
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, c, "good")
	ok(c.has_status("rupture"), "§2: a chilled enemy lit by Smoulder did not become a Rupture")
	await _clear(s)


# ── §3a — THE LOADOUT PANEL ───────────────────────────────────────────────────────

func _s3a_the_loadout_panel() -> void:
	print("\n§3a — the loadout panel: STARTING KIT, ENABLERS, CARRIED, BENCHED — the sections are the state")
	_fresh_meta()
	_new_run()
	# The Mage holds his class's first engine; a card that sits out without the Cryomancer's engine is carried too.
	var seat := 1
	var m: Dictionary = _run.party[seat]
	var held: Array = Runes.held_engines(m)
	var on := ""
	var off := ""
	var sit := ""
	for n in Classes.draft_pool("mage"):
		var nm := String(n)
		if _run.owned_ability_names(m).has(nm):
			continue
		if sit == "" and Classes.sits_out(nm, held):
			sit = nm
		elif Classes.offerable([nm], held).size() == 1 and not Classes.sits_out(nm, held):
			if on == "":
				on = nm
			elif off == "":
				off = nm
	ok(on != "" and off != "" and sit != "", "§3a: the premise — a card to carry, one to bench and one that sits out (%s, %s, %s)" % [on, off, sit])
	_run.hold_ability(m, on, true)
	_run.hold_ability(m, off, false)
	_run.hold_ability(m, sit, true)
	var card_pick := "carried %s and benched %s, the first two offerable cards not sitting out in Classes.draft_pool(\"mage\") order, and %s, its first that sits out under %s" % [
		on, off, sit, str(held)]
	var mp: Node = await _to_map()
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp.call("_open_loadout_panel", seat)
	await Gate.frames(self, 3)
	var seq := _sequence(Gate.overlay(mp, 60))
	var heads: Array = []
	for e5 in seq:
		var t5 := String(e5)
		# BATCH IG §3 — the kit's head is STARTING KIT (IF's ruling 4): CORE names a core rune.
		if t5.begins_with("STARTING KIT —") or t5.begins_with("ENABLERS —") or t5.begins_with("CARRIED —") or t5.begins_with("BENCHED —"):
			heads.append(t5.get_slice(" —", 0))
	print("    heads %s, separators %d" % [heads, seq.count("<sep>")])
	ok(heads == ["STARTING KIT", "ENABLERS", "CARRIED", "BENCHED"] and seq.count("<sep>") == 3,
		"§3a: the panel's sections are not STARTING KIT, ENABLERS, CARRIED and BENCHED in that order, each separated: %s" % [seq])
	var enablers: Array = []
	for pid in held:
		enablers.append_array(Classes.engine_enablers(String(pid)))
	var kit: Array = _run.opening_kit_names(m)
	var core_want: Array = kit.filter(func(n): return not enablers.has(n))
	var en_want: Array = kit.filter(func(n): return enablers.has(n))
	var core := _section(seq, "STARTING KIT —")
	var ens := _section(seq, "ENABLERS —")
	var carried := _section(seq, "CARRIED —")
	var benched := _section(seq, "BENCHED —")
	ok(_row_names(core) == core_want and _row_names(ens) == en_want,
		"§3a: STARTING KIT holds %s and ENABLERS %s — want the kit %s and its enablers %s" % [_row_names(core), _row_names(ens), core_want, en_want])
	ok(_row_names(carried) == [on, sit] and _row_names(benched) == [off],
		("§3a: CARRIED holds %s and BENCHED %s — want [%s, %s] and [%s]" % [_row_names(carried), _row_names(benched), on, sit, off]) + " — %s" % card_pick)
	var bench_btns: Array = (carried["rows"] as Array).map(func(r): return String(r[1]))
	var carry_btns: Array = (benched["rows"] as Array).map(func(r): return String(r[1]))
	ok(bench_btns == ["Bench", "Bench"] and carry_btns == ["Carry"],
		("§3a: a carried row does not offer Bench, or a benched one Carry (%s, %s)" % [bench_btns, carry_btns]) + " — %s" % card_pick)
	var sit_row: Array = (carried["rows"] as Array).filter(func(r): return String(r[0]).begins_with(sit + " — "))
	ok(sit_row.size() == 1 and String(sit_row[0][0]).contains("Sits out"),
		("§3a: the card that sits out does not say so under CARRIED: %s" % [sit_row]) + " — %s" % card_pick)
	var marked: Array = []
	for r4 in (core["rows"] as Array) + (ens["rows"] as Array) + (carried["rows"] as Array) + (benched["rows"] as Array):
		var t := String(r4[0])
		if t.contains(STAR) or t.begins_with("CORE") or t.begins_with("STARTING KIT") or t.begins_with("ENABLER") or t.contains("(carried)") or t.contains("(benched)"):
			marked.append(t)
	ok(marked.is_empty(), ("§3a: a row states its state again beside its section's head: %s" % [marked]) + " — %s" % card_pick)
	# BENCH MOVES IT DOWN, read off the panel the press re-opens.
	var btn: Button = Gate.bound_button(mp, "_toggle_loadout", [seat, on, Gate.overlay(mp, 60)])
	ok(btn != null and btn.text == "Bench", "§3a: the carried card's Bench is not bound to `_toggle_loadout`" + " — %s" % card_pick)
	if btn != null:
		btn.emit_signal("pressed")
		await Gate.frames(self, 3)
		var seq2 := _sequence(Gate.overlay(mp, 60))
		ok(_row_names(_section(seq2, "BENCHED —")).has(on) and not _row_names(_section(seq2, "CARRIED —")).has(on),
			("§3a: Bench did not move %s from CARRIED to BENCHED: %s" % [on, seq2]) + " — %s" % card_pick)
	_close_overlays(mp)
	await Gate.frames(self, 2)
	# THE EMPTIEST PANEL: nothing earned — every section drawn, the two earned ones with their notes and no rows.
	var bare := 3
	mp.call("_open_loadout_panel", bare)
	await Gate.frames(self, 3)
	var seq3 := _sequence(Gate.overlay(mp, 60))
	var c3 := _section(seq3, "CARRIED —")
	var b3 := _section(seq3, "BENCHED —")
	ok(bool(c3["found"]) and bool(b3["found"]) and (c3["rows"] as Array).is_empty() and (b3["rows"] as Array).is_empty()
			and (c3["notes"] as Array).size() == 1 and String(c3["notes"][0]).begins_with("Nothing earned yet.")
			and b3["notes"] == ["Nothing benched."],
		"§3a: the emptiest panel does not draw CARRIED and BENCHED empty, each with its line: %s" % [seq3])
	_close_overlays(mp)
	await Gate.frames(self, 2)


# ── §3b — THE CREST PANEL ─────────────────────────────────────────────────────────

func _crest_ids() -> Array:
	var out: Array = []
	for id in Runes._load().keys():
		if Runes.is_party_rune(Runes.config(String(id))) and not Runes.is_retired(String(id)):
			out.append(String(id))
	out.sort()
	return out


func _s3b_the_crest_panel() -> void:
	print("\n§3b — the crest panel: THE CREST, then IN THE BAG — each rune once, no ✦ and no (in the bag)")
	_fresh_meta()
	_new_run()
	var ids := _crest_ids()
	ok(ids.size() >= 2, "§3b: the premise — two crest runes to deal (%s)" % [ids])
	if ids.size() < 2:
		return
	var x: Dictionary = _rune(ids[0], true)
	var y: Dictionary = _rune(ids[1], false)
	_run.party_runes = [x]
	_run.rune_bag = [y]
	var mp: Node = await _to_map()
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp.call("_open_bag_panel")
	await Gate.frames(self, 3)
	var seq := _sequence(Gate.overlay(mp, 60))
	var crest := _section(seq, "THE CREST —")
	var bag := _section(seq, "IN THE BAG")
	print("    THE CREST %s | IN THE BAG %s" % [_row_names(crest), _row_names(bag)])
	ok(_row_names(crest) == [String(x["name"])] and (crest["rows"] as Array)[0][1] == "Unequip" and (crest["notes"] as Array).is_empty(),
		"§3b: THE CREST does not hold its one worn rune with Unequip, and no empty slot: %s" % [crest])
	ok(_row_names(bag) == [String(y["name"])] and String((bag["rows"] as Array)[0][1]) == "Swap,Drop",
		"§3b: IN THE BAG does not hold the bagged crest rune with Swap (the crest filled) beside its Drop: %s" % [bag])
	var rows_all: Array = seq.filter(func(e): return String(e).begins_with("row:"))
	var y_rows := rows_all.filter(func(e): return String(e).substr(4).begins_with(String(y["name"])))
	var marked := rows_all.filter(func(e): return String(e).contains(STAR) or String(e).contains("(in the bag)"))
	ok(y_rows.size() == 1 and marked.is_empty(), "§3b: a rune is listed twice (%d) or a row marks its state: %s" % [y_rows.size(), marked])
	_close_overlays(mp)
	await Gate.frames(self, 2)
	# EQUIP MOVES IT UP: the crest empty, the bagged rune's Equip pressed by its binding.
	_run.party_runes = []
	_run.rune_bag = [y]
	mp.call("_open_bag_panel")
	await Gate.frames(self, 3)
	var seq2 := _sequence(Gate.overlay(mp, 60))
	var crest2 := _section(seq2, "THE CREST —")
	var bag2 := _section(seq2, "IN THE BAG")
	ok(crest2["notes"] == ["— empty —"] and (crest2["rows"] as Array).is_empty()
			and String((bag2["rows"] as Array)[0][1]) == "Equip,Drop" if not (bag2["rows"] as Array).is_empty() else false,
		"§3b: an empty crest does not draw its slot, or the bagged rune does not offer Equip beside Drop: %s" % [seq2])
	var eb: Button = Gate.bound_button(mp, "_toggle_party_rune", [0, Gate.overlay(mp, 60)])
	ok(eb != null and eb.text == "Equip", "§3b: the bagged crest rune's Equip is not bound to `_toggle_party_rune`")
	if eb != null:
		eb.emit_signal("pressed")
		await Gate.frames(self, 3)
		var seq3 := _sequence(Gate.overlay(mp, 60))
		ok(_row_names(_section(seq3, "THE CREST —")) == [String(y["name"])] and _row_names(_section(seq3, "IN THE BAG")).is_empty(),
			"§3b: Equip did not move the rune from IN THE BAG to THE CREST: %s" % [seq3])
	_close_overlays(mp)
	await Gate.frames(self, 2)
	# THE EMPTIEST PANEL: no crest rune anywhere.
	_run.party_runes = []
	_run.rune_bag = []
	mp.call("_open_bag_panel")
	await Gate.frames(self, 3)
	var seq4 := _sequence(Gate.overlay(mp, 60))
	var c4 := _section(seq4, "THE CREST —")
	var b4 := _section(seq4, "IN THE BAG")
	ok((c4["rows"] as Array).is_empty() and (c4["notes"] as Array).size() == 2 and String(c4["notes"][0]) == "— empty —"
			and String(c4["notes"][1]).begins_with("No crest rune held.") and (b4["rows"] as Array).is_empty()
			and (b4["notes"] as Array).size() == 1 and String(b4["notes"][0]).begins_with("The bag is empty."),
		"§3b: the emptiest crest panel does not draw the empty slot, its line and the empty bag's: %s" % [seq4])
	_close_overlays(mp)
	await Gate.frames(self, 2)


# ── §3c — NO PANEL STATES A ROW'S STATE TWICE ────────────────────────────────────

func _s3c_no_row_twice() -> void:
	print("\n§3c — the rune panel, the loadout panel and the crest panel: no row states its state again")
	_fresh_meta()
	_new_run()
	var m: Dictionary = _run.party[0]
	var ord: Array = []
	for id in Runes.eligible_ids(m, _run.party_rune_names()):
		if not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(Runes.config(String(id))):
			ord.append(String(id))
	if ord.size() >= 2:
		m["runes"] = [_rune(ord[0], true), _rune(ord[1], false)]
	var ids := _crest_ids()
	if ids.size() >= 2:
		_run.party_runes = [_rune(ids[0], true)]
		_run.rune_bag = [_rune(ids[1], false)]
	var owned: Array = _run.owned_ability_names(m)
	var earned: Array = Classes.offerable(Classes.draft_pool("warrior"), Runes.held_engines(m)).filter(func(n): return not owned.has(n))
	if earned.size() >= 2:
		_run.hold_ability(m, String(earned[0]), true)
		_run.hold_ability(m, String(earned[1]), false)
	var mp: Node = await _to_map()
	var words := [STAR, "(held)", "(in the bag)", "(carried)", "(benched)", "(worn)"]
	var heads := ["CORE", "STARTING KIT", "ENABLER", "WORN", "HELD", "CARRIED", "BENCHED", "THE CREST", "IN THE BAG"]
	var swept := 0
	var twice: Array = []
	# BATCH IG §3 — ONE WORD, ONE KIND OF THING, ON EVERY PANEL (IF's ruling 4, the designer's). Each panel's section
	# heads are read off the real screen with the kind of thing its rows list: the rune panel and the crest's bag list
	# runes, the Kit panel lists cards. No head word may stand over runes on one panel and cards on another, CORE
	# heads a section of core runes and nothing else, and every *core* the Kit panel prints names a core rune.
	var head_kinds := {}
	var kit_core_words: Array = []
	for which in ["_open_rune_panel", "_open_loadout_panel", "_open_bag_panel"]:
		_close_overlays(mp)
		await Gate.frames(self, 2)
		if which == "_open_bag_panel":
			mp.call(which)
		else:
			mp.call(which, 0)
		await Gate.frames(self, 3)
		var kind := "card" if which == "_open_loadout_panel" else "rune"
		var ov := Gate.overlay(mp, 60)
		for e0 in _sequence(ov):
			var t0 := String(e0)
			if t0 == "<sep>" or t0.begins_with("row:"):
				continue
			var word := t0.get_slice(" —", 0).strip_edges()
			if word == word.to_upper() and word.length() >= 3 and word.to_lower() != word:
				if not head_kinds.has(word):
					head_kinds[word] = {}
				head_kinds[word]["%s:%s" % [kind, which]] = true
		if which == "_open_loadout_panel":
			for lb in _labels(ov):
				var lt := String((lb as Label).text).to_lower().replace("\n", " ")
				var at := lt.find("core")
				while at >= 0:
					if not lt.substr(at, 9).begins_with("core rune"):
						kit_core_words.append(String((lb as Label).text).left(70))
					at = lt.find("core", at + 4)
		for e in _sequence(ov):
			if not String(e).begins_with("row:"):
				continue
			swept += 1
			var t := String(e).substr(4).get_slice("|", 0)
			for w in words:
				if t.contains(w):
					twice.append("%s: %s" % [which, t.left(60)])
			for h in heads:
				if t.begins_with(h):
					twice.append("%s: %s" % [which, t.left(60)])
	_close_overlays(mp)
	await Gate.frames(self, 2)
	print("    CHECKED %d rows across the three panels" % swept)
	ok(swept >= 10, "§3c: the sweep read %d rows — the panels were not dressed" % swept)
	ok(twice.is_empty(), "§3c: a row states the state its section's head already gives: %s" % [twice])
	var two_kinds: Array = []
	for w2 in head_kinds:
		var kinds := {}
		for k2 in head_kinds[w2]:
			kinds[String(k2).get_slice(":", 0)] = true
		if kinds.size() > 1:
			two_kinds.append("%s: %s" % [w2, str(head_kinds[w2].keys())])
	print("    CHECKED %d head words across the three panels: %s" % [head_kinds.size(), str(head_kinds.keys())])
	ok(head_kinds.size() >= 6, "§3c: the head walk read %d head words — the panels were not drawn" % head_kinds.size())
	ok(two_kinds.is_empty(), "§3c: one head word names a rune on one panel and a card on another: %s" % [two_kinds])
	ok(head_kinds.has("CORE") and (head_kinds["CORE"] as Dictionary).keys() == ["rune:_open_rune_panel"],
		"§3c: CORE does not head the rune panel's core runes alone: %s" % [head_kinds.get("CORE", {})])
	ok(kit_core_words.is_empty(), "§3c: the Kit panel prints *core* for something that is not a core rune: %s" % [kit_core_words])


# ── §4 — THE CRACKED HOURGLASS ────────────────────────────────────────────────────

func _victory_with_hourglass(bars: Dictionary) -> Dictionary:
	_fresh_meta()
	var s: Node = await _board(SPECS)
	_run.active_relics = ["hourglass"]
	var heroes: Dictionary = {}
	for key in SEATS:
		heroes[key] = _hero(s, key)
	for key in bars:
		var u: BattleUnit = heroes[key]
		if u != null:
			u.max_resource = int(bars[key][1])
			u.resource = int(bars[key][0])
	_end_fight(s)
	await Gate.frames(self, 3)
	var out := {}
	for i in _run.party.size():
		out[String(_run.party[i]["key"])] = int(_run.party[i]["mana"])
	await _clear(s)
	_run.active_relics = []
	return out


func _s4_the_hourglass() -> void:
	print("\n§4 — the Cracked Hourglass: every hero who holds Mana recovers, and none is cut")
	var pct := float(Relics.POOL["hourglass"]["hooks"]["victory_mana_pct"])
	ok(pct > 0.0 and String(Relics.POOL["hourglass"]["desc"]).contains("every hero"),
		"§4: the premise — the relic restores a share of Mana and its card says every hero")
	var gain := int(100 * pct)
	var got := await _victory_with_hourglass({"mage": [20, 100], "cleric": [20, 100], "hunter": [20, 100]})
	print("    after a victory from 20 of 100: %s (the recovery %d)" % [got, gain])
	ok(int(got.get("mage", -1)) == 20 + gain and int(got.get("cleric", -1)) == 20 + gain,
		"§4: the Mage and the Cleric did not recover %d (%s)" % [gain, got])
	ok(int(got.get("hunter", -1)) == 20 + gain, "§4: the Hunter, who holds Mana, did not recover %d (%d) — the relic's card says every hero" % [gain, int(got.get("hunter", -1))])
	ok(int(got.get("warrior", -1)) == 0, "§4: the Warrior's member gained Mana he does not hold (%d)" % int(got.get("warrior", -1)))
	# BATCH IG §4 — A +20 BAR IS RESTORED AGAINST ITS OWN 120, NOT CUT AT THE MEMBER's OLD FIXED 100: the victory writes
	# the bar's true maximum onto the member before the relic reads it, so 110 of 120 rises to 120 and 70 of 120 gains
	# 30% of 120 (it read 110 → 110 and 70 → 100 while the member's maximum was a fixed 100).
	var gain2 := int(120 * pct)
	var got2 := await _victory_with_hourglass({"mage": [110, 120], "cleric": [70, 120]})
	print("    from 110 of 120 and 70 of 120: %s (the recovery %d of 120)" % [got2, gain2])
	ok(int(got2.get("mage", -1)) == mini(110 + gain2, 120), "§4: a +20 bar at 110 did not rise to its own 120 (110 -> %d)" % int(got2.get("mage", -1)))
	ok(int(got2.get("cleric", -1)) == 70 + gain2, "§4: a +20 bar at 70 did not recover %d of its own 120 (70 -> %d)" % [gain2, int(got2.get("cleric", -1))])
	# AND RECOVERING IS STILL NEVER A LOSS: a bar a door carries past the member's maximum is left where it stands.
	var mg: Dictionary = _run.party[1]
	var was_mana := int(mg["mana"])
	var was_max := int(mg["max_mana"])
	mg["max_mana"] = 120
	mg["mana"] = 130
	_run.restore_mana(pct)
	ok(int(mg["mana"]) == 130, "§4: the relic cut a bar above the member's maximum (130 -> %d) — recovering is never a loss" % int(mg["mana"]))
	mg["mana"] = was_mana
	mg["max_mana"] = was_max


# ── §9 ───────────────────────────────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files and the player's own readout folder are as this gate found them")
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
	_clear_harness_readout()
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
	ok(_listing(PLAYER_READOUT_DIR) == _player_readout, "§9: the player's readout folder moved under this gate")
