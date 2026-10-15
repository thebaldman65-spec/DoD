# BATCH II — THE FAMILY'S REMAINDER, AND THE FACES.
#
#   §0.3 ONE KIND OF FACE: the Berserker and the Pyromancer — the two lineages with art of their own — wear
#        their class sheet's shared crop on the battle plate, the turn strip and the map card, as the other ten
#        do (the card tinted by seat); their battle sprites are still their own; the bust is kept in the repo and
#        drawn nowhere.
#   §0.5a THE +N CHIP NAMES ALL THE REST: on a full chip row, the last chip's hover lists every chip the row did
#        not draw, each label whole, in the row's order — never a truncation of a truncation.
#   §0.5b THE FLOOR: a bar's value shrinks one size and no further (font 7); a Resonance or a Focus still wider
#        than its bar at the floor drops its parenthetical, stands at the plate's font inside the bar, and its
#        hover carries the whole line — driven to the value that first reaches it, and the value below.
#   §0.6 THE STATS ONE SIZE LARGER: every stat on the hero sheet at STAT_FONT, a row a line, no row past the
#        talent board or over another, the passive block below the last row — for every class, the Warden's
#        Block row included.
#   §1   THE THREE SITES, EACH VOWED AND UNVOWED ON ONE BOARD, EACH ASKING `_landed` UNDER ITS OWN FRAME BEFORE
#        ITS DOOR: (a) a damage-over-time tick's line (a Devout's Burn, re-laid through Returned Burden); (b) Blight
#        the Well's line and its credit (the Occultist's, whose frame did not move); (c) the bleedout burst's float
#        and line (under the Bloodletting bargain). Vowed: no figure anywhere, SILENT alone, the vow named. Unvowed:
#        the line HEAD printed, character for character.
#   §2a BLIGHT THE WELL DEALS UNDER ITS LAYER's FRAME — opened on the defect's own case, a vowed Devout who drafted
#        it without the Old Gods — against every reader the frame has: the vow's gate, Penance's mirror, Judgment,
#        the marks, the Reaver's kill credit, Siphon, the recap's ledgers.
#   §2b UMBRAL SIGIL's ECHO IS ITS CASTER's, NOT THE STRIKER's — the same readers, and the Weaver's tally: a vowed
#        caster's echo is silenced under an unvowed striker; a Reaver's kill, a Mage's Siphon and his Weaver's
#        repeat no longer collect on the echo; a penanced striker is not billed for it; it judges and marks for the
#        caster; it is booked to the caster.
#   §2c BOTH ARE REACHABLE IN A RUN PLAYED FORWARD: each card's writer, its pool, no engine row, nothing retired —
#        and each offered by its own door in seeded rolls on a fresh run.
#   §3   A TICK IS CREDITED TO ITS LAYER: a Devout's re-laid Burn to the Devout, a Mage on his class's spine to the
#        Mage, a Sharpshooter's Poison to the Sharpshooter, a Pyromancer's own Burn to him as before — and a Burn
#        that names nobody of the party to nobody.
#   §4   THE ARCHIVE PASS AND §0.7's RULES, WHERE EACH LIVES.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 and §2 set a premise by hand where the run reaches it only
# slowly — a bleed meter at 90, a Burn on the Warden laid by a raider, Penance and the judged mark through
# their own doors, the Weaver's count one short of its echo — and never the subject: every figure, line and
# credit asserted here is the site's own. §2c's offers are seeded draws, not a census of every run.
# `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ii.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ii_profile.json"
const SCRATCH_RELICS := "user://ii_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261014
const VOW := "vow_of_silence"
const SILENT := "SILENT"
const DRAWS := 150
const DRIVE_TO := 2000   # §0.5b drives each uncapped meter this far
const ENC := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _floats := {}
var _vow := ""


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH II — THE FAMILY'S REMAINDER, AND THE FACES")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_vow = String(Runes.config(VOW).get("name", ""))
	await _s03_one_kind_of_face()
	await _s05a_the_more_chip()
	await _s05b_the_floor()
	await _s06_the_stats()
	await _s1a_the_tick()
	await _s1b_the_blight()
	await _s1c_the_burst()
	await _s2a_blight_readers()
	await _s2b_sigil_readers()
	_s2c_reachable()
	await _s3_credit_by_layer()
	_s4_the_documents()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


# A lineage's own engine and the named rule engines beside it, every one slotted.
func _engines(spec: String, extra: Array) -> Array:
	var out: Array = Runes.engine_pouch_for_spec(spec)
	for pid in extra:
		out.append(_rune(Runes.engine_rune_id(String(pid))))
	return out


func _board(specs: Array, over: Dictionary) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


# The same party entered under the run's own bargain (`Gate.spawn` starts a new run, which clears it).
func _board_under(specs: Array, over: Dictionary, mod_id: String) -> Node:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["spec"] = specs[i]
		_run.party[i]["engines"] = Runes.engine_pouch_for_spec(String(specs[i]))
		_run.party[i]["awakened"] = true
		_run.party[i]["tree"] = Talents.generate_tree(specs[i], _run.party[i]["key"])
		_run.party[i]["runes"] = []
		_run.party[i]["talents"] = {}
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	for seat in over:
		for k in over[seat]:
			_run.party[int(seat)][k] = over[seat][k]
	_run.party_runes = []
	_run.pending_modifier = mod_id
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, ENC.duplicate(true))
	Engine.time_scale = 50.0
	await Gate.frames(self, 90)
	var s: Node = current_scene
	for u in s.get("heroes") + s.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = -10.0
		u.crit_bonus = -1.0
	return s


func _clear(scene: Node) -> void:
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	_floats.clear()
	await Gate.frames(self, 3)


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == key:
			return h
	return null


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _melee(scene: Node, skip: Array = []) -> BattleUnit:
	for e in _foes(scene):
		if not (e as BattleUnit).is_ranged and not skip.has(e):
			return e
	return null


func _ability(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


func _lines_with(text: String, needle: String) -> Array:
	var out: Array = []
	for line in text.split("\n"):
		if String(line).contains(needle):
			out.append(String(line).strip_edges())
	return out


func _line_with(text: String, needle: String) -> String:
	var l := _lines_with(text, needle)
	return String(l[0]) if not l.is_empty() else ""


# The floating texts a unit puts up from here on (`float_text` adds each as a Label at z 10).
func _watch(u: BattleUnit) -> void:
	_floats[u] = []
	u.child_entered_tree.connect(func(n: Node):
		if n is Label and (n as Label).z_index == 10 and _floats.has(u):
			(_floats[u] as Array).append(String((n as Label).text)))


func _floated(u: BattleUnit) -> Array:
	return (_floats.get(u, []) as Array).duplicate()


func _booked(scene: Node, who: String, label: String) -> float:
	return float(((scene.get("_run_dealt") as Dictionary).get(who, {}) as Dictionary).get(label, 0.0))


func _booked_all(scene: Node, who: String) -> float:
	var t := 0.0
	var rows: Dictionary = (scene.get("_run_dealt") as Dictionary).get(who, {})
	for k in rows:
		t += float(rows[k])
	return t


func _same_face(a: Texture2D, b: Texture2D) -> bool:
	if a == null or b == null or not (a is AtlasTexture) or not (b is AtlasTexture):
		return false
	var x: AtlasTexture = a
	var y: AtlasTexture = b
	return x.atlas != null and y.atlas != null and x.atlas.resource_path == y.atlas.resource_path \
		and x.region == y.region


func _face_name(t: Texture2D) -> String:
	if t is AtlasTexture and (t as AtlasTexture).atlas != null:
		return "%s %s" % [(t as AtlasTexture).atlas.resource_path.get_file(), str((t as AtlasTexture).region)]
	return t.resource_path.get_file() if t != null else "<none>"


# ── §0.3 — ONE KIND OF FACE ─────────────────────────────────────────────────

func _new_run(specs: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(Classes.engine_of_spec(String(specs[i]))))
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
	var mp: Node = current_scene
	if mp != null and Gate.hero_draft(mp) != null:
		mp.call("_close_hero_draft")
		await Gate.frames(self, 2)
	return mp


func _s03_one_kind_of_face() -> void:
	print("\n§0.3 — every lineage wears the shared crop on the plate, the turn strip and the card")
	var specs := ["berserker", "pyromancer", "inquisitor", "sharpshooter"]
	var s: Node = await _board(specs, {})
	var strip_faces := {}
	var bar: Node = s.get("turn_bar")
	if bar != null:
		for slot in bar.get_children():
			for c in slot.get_children():
				if c is TextureRect:
					strip_faces[String((c as TextureRect).tooltip_text)] = (c as TextureRect).texture
	for key in SEATS:
		var u := _hero(s, key)
		if u == null:
			ok(false, "§0.3: the board seats no %s" % key)
			continue
		var shared := Classes.class_icon(key)
		var face: TextureRect = null
		for c2 in (u.get("_plate_panel") as Control).get_children():
			if c2 is TextureRect and (c2 as TextureRect).has_meta("plate_portrait"):
				face = c2
		ok(face != null and _same_face(face.texture, shared),
			"§0.3 (%s): the plate's face is %s, not the class's shared crop %s" % [u.unit_name,
				_face_name(face.texture) if face != null else "<none>", _face_name(shared)])
		ok(strip_faces.has(u.unit_name) and _same_face(strip_faces[u.unit_name], shared),
			"§0.3 (%s): the turn strip's face is not the shared crop" % u.unit_name)
		print("    %-12s plate %s; strip %s" % [u.unit_name, _face_name(face.texture) if face != null else "-",
			"shared" if strip_faces.has(u.unit_name) and _same_face(strip_faces[u.unit_name], shared) else "-"])
	# Their battle sprites stay their own.
	var bz := _hero(s, "warrior")
	var pz := _hero(s, "mage")
	ok(bz != null and pz != null and bz.frame_size == 124 and pz.frame_size == 236,
		"§0.3: the Berserker's and the Pyromancer's battle art changed (frame %s, %s) — only the face moves" % [
			bz.frame_size if bz != null else -1, pz.frame_size if pz != null else -1])
	await _clear(s)
	# THE MAP CARD: the shared crop, tinted by seat, for every lineage.
	_new_run(specs)
	var mp: Node = await _to_map()
	var consts: Dictionary = mp.get_script().get_script_constant_map()
	var cards := 0
	for c3 in mp.get_children():
		if not (c3 is TextureRect) or (c3 as TextureRect).size != Vector2(44, 44) \
				or not is_equal_approx((c3 as TextureRect).position.x, float(consts["CARD_X"]) + 8.0):
			continue
		var idx := int(round(((c3 as TextureRect).position.y - 8.0 - float(consts["CARD_Y"])) / float(consts["CARD_STEP"])))
		if idx < 0 or idx >= _run.party.size():
			continue
		cards += 1
		var key2 := String(_run.party[idx]["key"])
		var tint: Color = Classes.HERO_TINTS[idx % Classes.HERO_TINTS.size()]
		ok(_same_face((c3 as TextureRect).texture, Classes.class_icon(key2)) and (c3 as TextureRect).modulate == tint,
			"§0.3 (card %d, %s): the card's face is %s tinted %s — the shared crop tinted by seat is owed" % [idx,
				_run.party[idx]["spec"], _face_name((c3 as TextureRect).texture), (c3 as TextureRect).modulate])
	ok(cards == 4, "§0.3: %d card faces found on the map — four are drawn" % cards)
	# THE BUST IS KEPT, AND DRAWN NOWHERE.
	var bust := String(Classes.SPEC_PORTRAITS.get("berserker", ""))
	ok(bust != "" and FileAccess.file_exists(bust), "§0.3: the Berserker's bust is not kept in the repo (%s)" % bust)
	var drawn_by: Array = []
	for f in DirAccess.get_files_at("res://scripts"):
		if f.ends_with(".gd") and Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f)).contains("Berserker_Portrait"):
			drawn_by.append(f)
	var src_cl := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/classes.gd"))
	var icon_body := src_cl.substr(src_cl.find("static func class_icon("), 400)
	ok(drawn_by == ["classes.gd"] and not icon_body.contains("SPEC_PORTRAITS"),
		"§0.3: the bust is named by %s, or `class_icon` still reads it — it is kept, and drawn nowhere" % [drawn_by])
	print("    %d card faces; the bust kept at %s and named only by %s" % [cards, bust.get_file(), drawn_by])
	if mp != null:
		mp.queue_free()
	await Gate.frames(self, 3)


# ── §0.5a — THE +N CHIP NAMES ALL THE REST ──────────────────────────────────

func _s05a_the_more_chip() -> void:
	print("\n§0.5a — a full chip row's +N names every chip it did not draw, whole and in order")
	var s: Node = await _board(["warden", "pyromancer", "inquisitor", "sharpshooter"], {})
	var w := _hero(s, "warrior")
	var foe := _melee(s)
	if w == null or foe == null:
		ok(false, "§0.5a: the board seats a Warden and a raider")
		await _clear(s)
		return
	var ids: Array = (s.get("STATUS_INFO") as Dictionary).keys()
	for sid in ids.slice(0, 18):
		s.call("_apply_status", w, String(sid), 3, 0, 0, foe)
	await Gate.frames(self, 2)
	var row: Array = (w.get("engine_chips") as Array) + (w.get("display_chips") as Array) + (w.get("statuses") as Array)
	var more: Control = null
	var drawn := 0
	for c in (w.get("_chips_root") as Node).get_children():
		if c is ColorRect and not c.is_queued_for_deletion():
			if String((c as ColorRect).tooltip_text).contains(" more:\n"):
				more = c
			else:
				drawn += 1
	ok(more != null, "§0.5a: a row of %d chips drew no +N chip — the premise of the arm" % row.size())
	if more != null:
		var want := PackedStringArray()
		for i in range(drawn, row.size()):
			want.append(String((row[i] as Dictionary).label))
		var tip := String(more.tooltip_text)
		ok(tip == "%d more:\n%s" % [row.size() - drawn, "\n".join(want)],
			"§0.5a: the +N hover does not name every chip the row left out, whole and in order: '%s' against %s" % [
				tip.replace("\n", " | "), want])
		print("    %d chips, %d drawn, +%d names %d: %s" % [row.size(), drawn, row.size() - drawn, want.size(),
			" | ".join(want)])
	await _clear(s)


# ── §0.5b — THE FLOOR ───────────────────────────────────────────────────────

func _s05b_the_floor() -> void:
	print("\n§0.5b — a value shrinks one size, then drops its parenthetical; the hover carries the whole")
	var s: Node = await _board(["warden", "arcanist", "inquisitor", "sharpshooter"], {})
	# Read off the script, not named: HEAD's unit has no floor, and a gate that names it would not parse there (H01).
	var floor_font: int = int((load("res://scripts/unit.gd") as Script).get_script_constant_map().get("PLATE_VALUE_FLOOR", -1))
	var plate_font: int = int(BattleUnit.PLATE_VALUE_FONT)
	var bar_w: float = float(BattleUnit.PLATE_BAR_W)
	ok(floor_font == plate_font - 1, "§0.5b: the floor is %d against the plate's %d — one size down" % [floor_font, plate_font])
	var floors := 0
	for key in ["mage", "hunter"]:
		var u := _hero(s, key)
		if u == null:
			ok(false, "§0.5b: the board seats no %s" % key)
			continue
		var meter := String(u.second_resource_name)
		ok(meter in ["Resonance", "Focus"] and (meter == "Resonance" or int(u.second_max) < 0),
			"§0.5b (%s): the premise — an uncapped meter, read '%s' (max %d)" % [u.unit_name, meter, u.second_max])
		var lbl: Label = u.get("_res2_text")
		var font: Font = lbl.get_theme_font("font")
		var first_small := -1
		var at_floor := -1
		var worst := 0.0
		var least_font := plate_font
		var v := 0
		while v <= DRIVE_TO and at_floor < 0:
			u.second_resource = v
			u.refresh_bars()
			var fs := lbl.get_theme_font_size("font_size")
			worst = maxf(worst, font.get_string_size(lbl.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x)
			least_font = mini(least_font, fs)
			var hovered := String(lbl.tooltip_text) != ""
			if fs == floor_font and first_small < 0 and not hovered:
				first_small = v
			if hovered:
				at_floor = v
			v += 1
		ok(least_font >= floor_font, "§0.5b (%s): a value drew at font %d, under the floor %d" % [meter, least_font, floor_font])
		ok(worst <= bar_w, "§0.5b (%s): a value ran %.0f px in a %.0f-px bar on the way up" % [meter, worst, bar_w])
		if first_small < 0 and at_floor < 0:
			# A readout that never outgrows its bar at the plate's font needs neither step: said, not asserted away.
			ok(least_font == plate_font, "§0.5b (%s): it shrank with no step the arm saw" % meter)
			print("    %-9s never shrinks: the widest face up to %d is %.0f px of %.0f, at font %d" % [meter, DRIVE_TO, worst, bar_w, plate_font])
			continue
		floors += 1
		ok(first_small >= 0 and at_floor > first_small,
			"§0.5b (%s): the size-down step did not come before the floor (font 7 from %d, the parenthetical dropped at %d)" % [
				meter, first_small, at_floor])
		if at_floor < 0:
			print("    %-9s font 7 from %d; the parenthetical never dropped up to %d" % [meter, first_small, DRIVE_TO])
			continue
		# AT THE FLOOR: the count stands, at a font inside the bar, and the hover is the whole line.
		u.second_resource = at_floor
		u.refresh_bars()
		var full := String(lbl.tooltip_text)
		var fs2 := lbl.get_theme_font_size("font_size")
		ok(full.contains(" (") and lbl.text == full.substr(0, full.find(" ("))
			and font.get_string_size(lbl.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2).x <= bar_w
			and font.get_string_size(full, HORIZONTAL_ALIGNMENT_LEFT, -1, floor_font).x > bar_w,
			"§0.5b (%s at %d): the face is '%s' at %d and the hover '%s' — the count alone, the whole line on its hover" % [
				meter, at_floor, lbl.text, fs2, full])
		ok(lbl.mouse_filter == Control.MOUSE_FILTER_STOP and lbl.gui_input.is_connected(Callable(u, "_on_plate_input")),
			"§0.5b (%s): the shortened value's hover cannot be reached, or a click on it is not the plate's" % meter)
		# ONE BELOW: the whole line, at the floor, no hover.
		u.second_resource = at_floor - 1
		u.refresh_bars()
		ok(lbl.text.contains(" (") and String(lbl.tooltip_text) == "" and lbl.mouse_filter == Control.MOUSE_FILTER_IGNORE
			and font.get_string_size(lbl.text, HORIZONTAL_ALIGNMENT_LEFT, -1, lbl.get_theme_font_size("font_size")).x <= bar_w,
			"§0.5b (%s at %d): one below the floor reads '%s' with hover '%s'" % [meter, at_floor - 1, lbl.text, lbl.tooltip_text])
		u.second_resource = at_floor
		u.refresh_bars()
		print("    %-9s font 7 from %d; at %d the face reads '%s' (font %d), the hover '%s'" % [meter, first_small,
			at_floor, lbl.text, fs2, full])
	ok(floors >= 1, "§0.5b: no meter was driven to the floor — the arm has gone vacuous")
	await _clear(s)


# ── §0.6 — THE STATS ONE SIZE LARGER ────────────────────────────────────────

func _sheet(idx: int) -> Node:
	_run.hero_screen_idx = idx
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	return current_scene


func _s06_the_stats() -> void:
	print("\n§0.6 — every stat on the sheet one size larger, inside the column, a row a line")
	_new_run(["warden", "pyromancer", "inquisitor", "sharpshooter"])
	for idx in _run.party.size():
		var sh: Node = await _sheet(idx)
		if sh == null:
			ok(false, "§0.6: the sheet did not open for seat %d" % idx)
			continue
		var consts: Dictionary = sh.get_script().get_script_constant_map()
		var stat_font := int(consts.get("STAT_FONT", 0))
		var board_x := float((consts.get("TREE_BACK_POS", Vector2.ZERO) as Vector2).x)
		var rows: Array = []
		var passive: Control = null
		for c in sh.get_children():
			if c is HBoxContainer and is_equal_approx((c as Control).position.x, 60.0):
				rows.append(c)
			if c is Label and (c as Label).has_meta("passive_block"):
				passive = c
		rows.sort_custom(func(a, b): return (a as Control).position.y < (b as Control).position.y)
		var bad: Array = []
		var n_stats := 0
		var prev_bottom := -1.0
		for r in rows:
			var rr: Rect2 = (r as Control).get_global_rect()
			if rr.end.x > board_x:
				bad.append("a row runs to x %.0f, past the board at %.0f" % [rr.end.x, board_x])
			if prev_bottom >= 0.0 and rr.position.y < prev_bottom - 0.5:
				bad.append("a row at y %.0f starts over the one above (ends %.0f)" % [rr.position.y, prev_bottom])
			prev_bottom = rr.end.y
			for l in (r as Node).get_children():
				if l is Label:
					n_stats += 1
					if (l as Label).get_theme_font_size("font_size") != stat_font:
						bad.append("'%s' at font %d" % [(l as Label).text, (l as Label).get_theme_font_size("font_size")])
		ok(stat_font == 17, "§0.6: the stats' font is %d — one size up from IH's 15" % stat_font)
		ok(rows.size() == 5 and n_stats >= 9 and bad.is_empty(),
			"§0.6 (seat %d): %d rows, %d stats — %s" % [idx, rows.size(), n_stats, bad])
		ok(passive != null and passive.get_global_rect().position.y >= prev_bottom,
			"§0.6 (seat %d): the passive block starts above the last stat row (%s against %.0f)" % [idx,
				str(passive.get_global_rect().position.y) if passive != null else "none", prev_bottom])
		print("    seat %d: %d rows, %d stats at font %d, the last row ends y %.0f, the passive block at %s" % [idx, rows.size(),
			n_stats, stat_font, prev_bottom, str(passive.position.y) if passive != null else "-"])
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)


# ── §1a — THE TICK's LINE ───────────────────────────────────────────────────
#
# The Devout's Burn, as a run reaches it: a raider's Burn on the Warden, lifted by Unburden and cast back on the
# raider through Returned Burden with the Devout as its source. The tick is the raider's at its turn start.
func _devout_burn(s: Node, vowed: bool) -> Dictionary:
	var c := _hero(s, "cleric")
	var w := _hero(s, "warrior")
	var foe := _melee(s)
	var ub := _ability(c, "Unburden")
	var out := {"ok": false}
	if [c, w, foe, ub].any(func(x): return x == null):
		return out
	s._apply_status(w, "burn", 3, 0, 9, foe)
	await s._resolve(c, ub, w, "good")
	out["ok"] = foe.has_status("burn") and String(foe.get_status("burn").get("src_name", "")) == c.unit_name \
		and float(c.rune_vow_of_silence) > 0.0 == vowed
	out["c"] = c
	out["foe"] = foe
	return out


func _s1a_the_tick() -> void:
	print("\n§1a — a tick its layer's vow refuses prints no figure; unvowed, the line HEAD printed")
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var runes: Array = [_rune("returned_burden")] + ([_rune(VOW)] if vowed else [])
		var s: Node = await _board(["warden", "pyromancer", "inquisitor", "mystic"], {2: {"runes": runes}})
		var set: Dictionary = await _devout_burn(s, vowed)
		if not bool(set.get("ok", false)):
			ok(false, "§1a (%s): the premise — the Devout's Unburden did not cast the Warden's Burn back on the raider as his" % tag)
			await _clear(s)
			continue
		var c: BattleUnit = set["c"]
		var foe: BattleUnit = set["foe"]
		var label := String((s.get("STATUS_INFO") as Dictionary)["burn"][0])
		var tick := int(foe.get_status("burn").get("tick", 0))
		foe.hp = foe.max_hp
		var h0 := foe.hp
		var b0 := _booked(s, c.unit_name, label)
		_watch(foe)
		var log0 := _log_text(s).length()
		await s._dot_pass(foe)
		var tail := _log_text(s).substr(log0)
		var lost: int = h0 - foe.hp
		var fl := _floated(foe)
		var booked := _booked(s, c.unit_name, label) - b0
		if vowed:
			var want := "%s's %s tick — silenced by %s" % [foe.unit_name, label, _vow]
			ok(lost == 0 and fl == [SILENT] and _line_with(tail, foe.unit_name) == want and is_zero_approx(booked),
				"§1a (vowed): the tick took %d, floated %s, printed '%s', booked %s — the vow named, no figure" % [lost, fl,
					_line_with(tail, foe.unit_name), booked])
		else:
			var line := _line_with(tail, "%s takes" % foe.unit_name)
			ok(lost > 0 and lost == tick and fl == ["-%d %s" % [lost, label]]
				and line == "%s takes %d %s damage" % [foe.unit_name, lost, label],
				"§1a (no vow): the tick took %d of %d, floated %s, printed '%s' — HEAD's line, character for character" % [
					lost, tick, fl, line])
		print("    %-7s lost %d (tick %d), floats %s; '%s'" % [tag, lost, tick, fl, _line_with(tail, foe.unit_name)])
		await _clear(s)


# ── §1b — BLIGHT THE WELL's LINE AND ITS CREDIT ─────────────────────────────

func _blight(s: Node, layer: BattleUnit, bf: BattleUnit) -> bool:
	var card := _ability(layer, "Blight the Well")
	if card == null or bf == null:
		return false
	await s._resolve(layer, card, bf, "good")
	return bf.has_status("blight") and String(bf.get_status("blight").get("src_name", "")) == layer.unit_name


func _s1b_the_blight() -> void:
	print("\n§1b — Blight the Well's turned heal: the line and the credit read what landed")
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var over := {"bm_abilities": ["Blight the Well"], "bm_equipped": ["Blight the Well"],
			"runes": [_rune(VOW)] if vowed else []}
		var s: Node = await _board(["warden", "pyromancer", "occultist", "mystic"], {2: over})
		var occ := _hero(s, "cleric")
		var bf := _melee(s)
		var mender := _melee(s, [bf])
		if [occ, bf, mender].any(func(x): return x == null) or not await _blight(s, occ, bf):
			ok(false, "§1b (%s): the premise — the Occultist laid no blight of his own" % tag)
			await _clear(s)
			continue
		ok(occ.has_engine("old_gods"), "§1b (%s): the premise — the Occultist holds the Old Gods (the frame HEAD read)" % tag)
		bf.hp = bf.max_hp - 40
		var h0 := bf.hp
		var b0 := _booked(s, occ.unit_name, "Blight the Well")
		_watch(bf)
		var log0 := _log_text(s).length()
		s._dmg_frame(mender, "Cleansing Rite")
		bf.heal_amount(20)
		var line := _line_with(_log_text(s).substr(log0), "Blight the Well: the mending")
		var lost: int = h0 - bf.hp
		var fl := _floated(bf)
		var booked := _booked(s, occ.unit_name, "Blight the Well") - b0
		if vowed:
			ok(lost == 0 and fl == ["BLIGHTED", SILENT] and is_zero_approx(booked)
				and line == "→ Blight the Well: the mending turns on %s — silenced by %s" % [bf.unit_name, _vow],
				"§1b (vowed): took %d, floated %s, booked %s, printed '%s'" % [lost, fl, booked, line])
		else:
			ok(lost == 20 and fl == ["BLIGHTED", "-20"] and is_equal_approx(booked, 20.0)
				and line == "→ Blight the Well: the mending turns on %s for 20" % bf.unit_name,
				"§1b (no vow): took %d, floated %s, booked %s, printed '%s' — HEAD's line and credit" % [lost, fl, booked, line])
		print("    %-7s lost %d, floats %s, booked %s; '%s'" % [tag, lost, fl, booked, line])
		await _clear(s)


# ── §1c — THE BLEEDOUT BURST ────────────────────────────────────────────────

func _s1c_the_burst() -> void:
	print("\n§1c — the bleedout burst under Bloodletting: its float and its line read what landed")
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board_under(["warden", "pyromancer", "inquisitor", "mystic"],
			{2: {"runes": [_rune(VOW)] if vowed else []}}, "bloodletting")
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if c == null or foe == null or int(c.mod_bleed_add) <= 0:
			ok(false, "§1c (%s): the premise — the bargain stamps no Bleed on the Devout's blows" % tag)
			await _clear(s)
			continue
		foe.hp = foe.max_hp
		foe.bleed_buildup = 100 - int(c.mod_bleed_add)
		var burst := maxi(int(foe.max_hp * 0.20), 1)
		var h0 := foe.hp
		_watch(foe)
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(c, c.abilities[0], foe, "good")
		var tail := _log_text(s).substr(log0)
		var line := _line_with(tail, "BLEEDS OUT")
		var fl := _floated(foe)
		var lost: int = h0 - foe.hp
		ok(line != "", "§1c (%s): the premise — his blow did not burst the raider's meter" % tag)
		if vowed:
			ok(lost == 0 and not fl.any(func(t): return String(t).begins_with("BLEEDOUT")) and fl.has(SILENT)
				and line == "→ %s BLEEDS OUT — silenced by %s" % [foe.unit_name, _vow],
				"§1c (vowed): the raider lost %d, floated %s, printed '%s' — SILENT alone and the vow named" % [lost, fl, line])
		else:
			ok(lost >= burst and fl.has("BLEEDOUT %d" % burst) and line == "→ %s BLEEDS OUT for %d" % [foe.unit_name, burst],
				"§1c (no vow): lost %d, floated %s, printed '%s' — HEAD's float and line for the %d it lands" % [lost, fl, line, burst])
		print("    %-7s lost %d, floats %s; '%s'" % [tag, lost, fl, line])
		await _clear(s)


# ── §2a — BLIGHT THE WELL DEALS UNDER ITS LAYER's FRAME ─────────────────────
#
# The board for every reader: a Warden wearing the Reaver beside his own engine, a Pyromancer wearing the Leech,
# a Devout (no Old Gods) holding the card and wearing the Arbiter, a Survivalist.
func _readers_board(vowed: bool) -> Node:
	var over := {
		0: {"engines": _engines("warden", ["savage_assault"])},
		1: {"engines": _engines("pyromancer", ["siphon"])},
		2: {"engines": _engines("inquisitor", ["judgment"]), "bm_abilities": ["Blight the Well"],
			"bm_equipped": ["Blight the Well"], "runes": [_rune(VOW)] if vowed else []},
	}
	return await _board(["warden", "pyromancer", "inquisitor", "mystic"], over)


func _arbiter_lines(scene: Node) -> int:
	return _lines_with(_log_text(scene), "Rune of the Arbiter (core): the judged").size()


func _s2a_blight_readers() -> void:
	print("\n§2a — Blight the Well deals under its layer's frame: every reader, opened on a vowed Devout without the Old Gods")
	# THE LONGEST CASE FIRST: vowed, no Old Gods. HEAD dealt it under the raider's own frame and the vow never saw it.
	var s: Node = await _readers_board(true)
	var c := _hero(s, "cleric")
	var bf := _melee(s)
	var mender := _melee(s, [bf])
	if [c, bf, mender].any(func(x): return x == null) or not await _blight(s, c, bf):
		ok(false, "§2a (vowed): the premise — the Devout laid no blight of his own")
	else:
		ok(not c.has_engine("old_gods") and float(c.rune_vow_of_silence) > 0.0,
			"§2a (vowed): the premise — a vowed Devout without the Old Gods (Old Gods %s)" % c.has_engine("old_gods"))
		bf.hp = bf.max_hp - 40
		var h0 := bf.hp
		var b0 := _booked_all(s, c.unit_name)
		_watch(bf)
		var log0 := _log_text(s).length()
		s._dmg_frame(mender, "Cleansing Rite")
		bf.heal_amount(20)
		var line := _line_with(_log_text(s).substr(log0), "Blight the Well: the mending")
		ok(h0 - bf.hp == 0 and _floated(bf) == ["BLIGHTED", SILENT] and is_zero_approx(_booked_all(s, c.unit_name) - b0)
			and line.contains("silenced by %s" % _vow),
			"§2a (vowed, no Old Gods): the vow's gate — the raider lost %d, floated %s, booked %s, '%s'" % [h0 - bf.hp,
				_floated(bf), _booked_all(s, c.unit_name) - b0, line])
		print("    vowed, no Old Gods: lost %d, floats %s; '%s'" % [h0 - bf.hp, _floated(bf), line])
	await _clear(s)
	# UNVOWED: the layer's frame read by every other reader.
	s = await _readers_board(false)
	c = _hero(s, "cleric")
	var w := _hero(s, "warrior")
	var py := _hero(s, "mage")
	bf = _melee(s)
	mender = _melee(s, [bf])
	if [c, w, py, bf, mender].any(func(x): return x == null) or not await _blight(s, c, bf):
		ok(false, "§2a (no vow): the premise — the board and the Devout's own blight")
		await _clear(s)
		return
	ok(w.has_engine("savage_assault") and py.has_engine("siphon") and c.has_engine("judgment") and not c.has_engine("old_gods"),
		"§2a: the premise — a Reaver, a Leech, an Arbiter without the Old Gods")
	# THE MARKS: his Arbiter's mark lands on the first enemy he damages — here, the blighted raider.
	var marked_before: bool = bf.has_status("judged")
	bf.hp = bf.max_hp - 40
	py.resource = 0
	py.refresh_bars()
	var k0 := int(w.reaver_kills)
	var b0b := _booked(s, c.unit_name, "Blight the Well")
	_watch(bf)
	var log1 := _log_text(s).length()
	s._dmg_frame(mender, "Cleansing Rite")
	bf.heal_amount(20)
	var lost := (bf.max_hp - 40) - bf.hp
	ok(not marked_before and bf.has_status("judged") and String(bf.get_status("judged").get("src_name", "")) == c.unit_name,
		"§2a (no vow): the marks — the turned heal is his damage, so his Arbiter marks the raider (marked before %s, after %s)" % [
			marked_before, bf.has_status("judged")])
	ok(lost == 20 and is_equal_approx(_booked(s, c.unit_name, "Blight the Well") - b0b, 20.0),
		"§2a (no vow): the dealt ledger — %d landed and %s booked to %s under the card" % [lost,
			_booked(s, c.unit_name, "Blight the Well") - b0b, c.unit_name])
	# JUDGMENT: the judged raider's wound mends the party when the frame names the Arbiter.
	for h in (s.get("heroes") as Array):
		(h as BattleUnit).hp = int((h as BattleUnit).max_hp / 2)
	var a0 := _arbiter_lines(s)
	s._dmg_frame(mender, "Cleansing Rite")
	bf.heal_amount(20)
	ok(_arbiter_lines(s) == a0 + 1, "§2a (no vow): Judgment — the judged raider's blighted wound mended nobody (%d line(s) after %d)" % [
		_arbiter_lines(s), a0])
	# PENANCE: the mirror bills the dealer the frame names — a hero here, so nothing is billed.
	s._apply_status(bf, "penance", 4, 50, 0, c)
	var p0 := _lines_with(_log_text(s), "Penance: %s pays" % bf.unit_name).size()
	s._dmg_frame(mender, "Cleansing Rite")
	bf.heal_amount(10)
	ok(_lines_with(_log_text(s), "Penance: %s pays" % bf.unit_name).size() == p0,
		"§2a (no vow): Penance billed the raider for a wound the Devout dealt it")
	# THE KILL: the blight fells the raider — the Devout's kill, never the Reaver's; Siphon paid the Leech nothing.
	bf.hp = 5
	s._dmg_frame(mender, "Cleansing Rite")
	bf.heal_amount(20)
	ok(bf.dead and int(w.reaver_kills) == k0, "§2a (no vow): the Reaver's kill credit — dead %s, the Warden's kills %d → %d" % [
		bf.dead, k0, w.reaver_kills])
	ok(int(py.resource) == 0 and int(py.siphon_returned) == 0,
		"§2a (no vow): Siphon paid the Pyromancer %d Mana off the Devout's blight" % py.resource)
	ok(_lines_with(_log_text(s).substr(log1), "Blight the Well: the mending").size() == 4,
		"§2a (no vow): the four turned heals printed %d lines" % _lines_with(_log_text(s).substr(log1), "Blight the Well: the mending").size())
	print("    no vow: marked %s, booked %s, Arbiter lines %d, Reaver kills %d, Leech Mana %d" % [
		bf.has_status("judged") or bf.dead, _booked(s, c.unit_name, "Blight the Well"), _arbiter_lines(s), w.reaver_kills, py.resource])
	await _clear(s)


# ── §2b — UMBRAL SIGIL's ECHO IS ITS CASTER's ───────────────────────────────

func _sigil_board(vowed: bool, caster_engines: Array) -> Node:
	var over := {
		0: {"engines": _engines("warden", ["savage_assault"])},
		1: {"engines": _engines("pyromancer", ["siphon", "cast_echo"])},
		2: {"engines": _engines("occultist", caster_engines), "bm_abilities": ["Umbral Sigil"],
			"bm_equipped": ["Umbral Sigil"], "runes": [_rune(VOW)] if vowed else []},
	}
	return await _board(["warden", "pyromancer", "occultist", "mystic"], over)


func _brand(s: Node, occ: BattleUnit, foe: BattleUnit) -> bool:
	var card := _ability(occ, "Umbral Sigil")
	if card == null or foe == null:
		return false
	await s._resolve(occ, card, foe, "good")
	return foe.has_status("umbral_sigil") and String(foe.get_status("umbral_sigil").get("src_name", "")) == occ.unit_name


func _sigil_floats(fellows: Array) -> Array:
	var out: Array = []
	for e in fellows:
		out.append_array(_floated(e).filter(func(t): return String(t).ends_with(" Sigil")))
	return out


func _s2b_sigil_readers() -> void:
	print("\n§2b — Umbral Sigil's echo is its caster's: every reader, opened on a vowed caster under an unvowed striker")
	# THE LONGEST CASE FIRST: the Occultist wears the vow, the Warden strikes. HEAD echoed under the Warden's frame.
	var s: Node = await _sigil_board(true, [])
	var occ := _hero(s, "cleric")
	var w := _hero(s, "warrior")
	var br := _melee(s)
	if [occ, w, br].any(func(x): return x == null) or not await _brand(s, occ, br):
		ok(false, "§2b (vowed caster): the premise — the Occultist branded no raider")
	else:
		var fellows: Array = _foes(s).filter(func(e): return e != br)
		var hp0 := {}
		for e in fellows:
			e.hp = e.max_hp
			hp0[e] = e.hp
			_watch(e)
		br.hp = br.max_hp
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(w, w.abilities[0], br, "good")
		var took: Array = fellows.map(func(e): return int(hp0[e]) - (e as BattleUnit).hp)
		var line := _line_with(_log_text(s).substr(log0), "Umbral Sigil echoes")
		ok(br.max_hp - br.hp > 0 and took.all(func(x): return int(x) == 0) and _sigil_floats(fellows).is_empty()
			and fellows.all(func(e): return _floated(e).has(SILENT))
			and line == "→ Umbral Sigil echoes to the warband — silenced by %s" % _vow
			and is_zero_approx(_booked(s, occ.unit_name, "Umbral Sigil")),
			"§2b (vowed caster): the Warden's blow landed %d and the echo took %s, floated %s, printed '%s' — the caster's vow silences it" % [
				br.max_hp - br.hp, took, _sigil_floats(fellows), line])
		print("    vowed caster: the Warden's blow %d; the warband took %s; '%s'" % [br.max_hp - br.hp, took, line])
	await _clear(s)
	# THE REAVER, THE RECAP'S LEDGERS: an unvowed caster; the Reaver strikes; the echo fells a fellow.
	s = await _sigil_board(false, [])
	occ = _hero(s, "cleric")
	w = _hero(s, "warrior")
	br = _melee(s)
	if [occ, w, br].any(func(x): return x == null) or not await _brand(s, occ, br):
		ok(false, "§2b (Reaver): the premise — the Occultist branded no raider")
	else:
		var fellows2: Array = _foes(s).filter(func(e): return e != br)
		var low: BattleUnit = fellows2[0]
		low.hp = 1
		br.hp = br.max_hp
		var k0 := int(w.reaver_kills)
		var wb0 := _booked_all(s, w.unit_name)
		var log1 := _log_text(s).length()
		seed(SEED)
		await s._resolve(w, w.abilities[0], br, "good")
		var struck := br.max_hp - br.hp
		var echo := maxi(int(round(struck * 0.5)), 1)
		var booked := _booked(s, occ.unit_name, "Umbral Sigil")
		ok(low.dead and int(w.reaver_kills) == k0,
			"§2b (Reaver): the echo felled %s (%s) and the Warden's kills read %d → %d — the echo's kill is the caster's" % [
				low.unit_name, low.dead, k0, w.reaver_kills])
		ok(is_equal_approx(_booked_all(s, w.unit_name) - wb0, float(struck)) and is_equal_approx(booked, float(echo * fellows2.size())),
			"§2b (Reaver): the ledgers — the Warden booked %s for his %d, the Occultist %s for %d echoes of %d" % [
				_booked_all(s, w.unit_name) - wb0, struck, booked, fellows2.size(), echo])
		ok(_line_with(_log_text(s).substr(log1), "Umbral Sigil echoes") == "→ Umbral Sigil echoes %d to the warband" % echo,
			"§2b (Reaver): the line is not the echo that landed: '%s'" % _line_with(_log_text(s).substr(log1), "Umbral Sigil echoes"))
		print("    Reaver: the blow %d, the echo %d, %s felled; kills %d; booked %s to %s" % [struck, echo, low.unit_name,
			w.reaver_kills, booked, occ.unit_name])
	await _clear(s)
	# SIPHON AND THE WEAVER: the Pyromancer wears the Leech and the Weaver, his echo one cast short.
	s = await _sigil_board(false, [])
	occ = _hero(s, "cleric")
	var py := _hero(s, "mage")
	br = _melee(s)
	if [occ, py, br].any(func(x): return x == null) or not await _brand(s, occ, br):
		ok(false, "§2b (Leech): the premise — the Occultist branded no raider")
	else:
		var fellows3: Array = _foes(s).filter(func(e): return e != br)
		for e in fellows3:
			e.hp = e.max_hp
			_watch(e)
		_watch(br)
		br.hp = br.max_hp
		py.resource = 0
		py.siphon_returned = 0
		py.echo_casts = int(Classes.ECHO_EVERY) - 1
		py.refresh_bars()
		seed(SEED)
		await s._resolve(py, py.abilities[0], br, "good")
		var struck2 := br.max_hp - br.hp
		var fl_br := _floated(br).filter(func(t): return String(t).ends_with(" Repeat"))
		var fl_f: Array = []
		for e in fellows3:
			fl_f.append_array(_floated(e).filter(func(t): return String(t).ends_with(" Repeat")))
		ok(not _sigil_floats(fellows3).is_empty(), "§2b (Leech): the premise — the Pyromancer's blow raised no echo")
		ok(fl_f.is_empty() and not fl_br.is_empty(),
			"§2b (Weaver): the repeat struck the warband %s and the branded raider %s — the echo is not the Pyromancer's cast" % [fl_f, fl_br])
		ok(int(py.siphon_returned) <= int(round(struck2 * 0.01 * Classes.SIPHON_RETURN_PCT)) + 1,
			"§2b (Leech): Siphon returned %d Mana against the %d his own blow and repeat landed on the branded raider" % [
				py.siphon_returned, struck2])
		print("    Leech/Weaver: the branded raider lost %d, Siphon returned %d; repeats on it %s, on the warband %s" % [
			struck2, py.siphon_returned, fl_br, fl_f])
	await _clear(s)
	# PENANCE AND JUDGMENT: a penanced raider strikes its own branded fellow; the archer is judged by the Occultist.
	s = await _sigil_board(false, ["judgment"])
	occ = _hero(s, "cleric")
	br = _melee(s)
	var pen := _melee(s, [br])
	var arch: BattleUnit = null
	for e in _foes(s):
		if (e as BattleUnit).is_ranged:
			arch = e
	if [occ, br, pen, arch].any(func(x): return x == null) or not await _brand(s, occ, br):
		ok(false, "§2b (Penance): the premise — the board seats two raiders and an archer, one branded")
	else:
		s._apply_status(pen, "penance", 4, 50, 0, occ)
		s._lay_engine_mark(occ, "judgment", arch)
		ok(pen.has_status("penance") and arch.has_status("judged"), "§2b (Penance): the premise — Penance and the judged mark")
		for e in [br, pen, arch]:
			(e as BattleUnit).hp = (e as BattleUnit).max_hp
		var p0 := _lines_with(_log_text(s), "Penance: %s pays" % pen.unit_name).size()
		var a0 := _arbiter_lines(s)
		seed(SEED)
		await s._resolve(pen, pen.abilities[0], br, "good")
		var pays := _lines_with(_log_text(s), "Penance: %s pays" % pen.unit_name).size() - p0
		ok(br.max_hp - br.hp > 0 and pays == 1,
			"§2b (Penance): the penanced raider paid %d time(s) — once for its own blow, never for the caster's echo" % pays)
		ok(_arbiter_lines(s) == a0 + 1,
			"§2b (Judgment): the echo on the judged archer mended %d time(s) — the caster's damage on his judged foe mends once" % [
				_arbiter_lines(s) - a0])
		print("    Penance: billed %d; Judgment lines +%d" % [pays, _arbiter_lines(s) - a0])
	await _clear(s)
	# THE MARKS: the Occultist wears the Arbiter and has marked nobody; the Warden strikes the branded raider.
	s = await _sigil_board(false, ["judgment"])
	occ = _hero(s, "cleric")
	w = _hero(s, "warrior")
	br = _melee(s)
	if [occ, w, br].any(func(x): return x == null) or not await _brand(s, occ, br):
		ok(false, "§2b (marks): the premise — the Occultist branded no raider")
	else:
		var marks0: Array = _foes(s).filter(func(e): return (e as BattleUnit).has_status("judged"))
		for e in _foes(s):
			(e as BattleUnit).hp = (e as BattleUnit).max_hp
		seed(SEED)
		await s._resolve(w, w.abilities[0], br, "good")
		var judged: Array = _foes(s).filter(func(e): return (e as BattleUnit).has_status("judged") \
			and String((e as BattleUnit).get_status("judged").get("src_name", "")) == occ.unit_name)
		ok(marks0.is_empty() and judged.size() == 1 and judged[0] != br,
			"§2b (marks): the echo marked %s for the Occultist — the caster's damage lays his mark on a fellow" % [
				judged.map(func(e): return (e as BattleUnit).unit_name)])
		print("    marks: judged for the Occultist %s" % [judged.map(func(e): return (e as BattleUnit).unit_name)])
	await _clear(s)


# ── §2c — BOTH ARE REACHABLE ────────────────────────────────────────────────

func _s2c_reachable() -> void:
	print("\n§2c — Umbral Sigil and Blight the Well, each in a run played forward")
	# UMBRAL SIGIL: its writer is the card (`_resolve_special`'s `umbral_sigil`), its pool the Occultist's zone-boss award.
	ok(Classes.SPEC_POOLS.get("occultist", []).has("Umbral Sigil") and Classes.engine_read("Umbral Sigil") == ""
		and Classes.pool_ability("Umbral Sigil") != null,
		"§2c: Umbral Sigil is not an Occultist's boss-pool card with no engine row that resolves")
	var hits := 0
	seed(SEED)
	for i in DRAWS:
		_new_run(["warden", "pyromancer", "occultist", "mystic"])
		if (_run.roll_spec_ability_offer(_run.party[2]) as Array).has("Umbral Sigil"):
			hits += 1
	ok(hits > 0, "§2c: a fresh Occultist's zone-boss award never offered Umbral Sigil in %d rolls" % DRAWS)
	# BLIGHT THE WELL: its writer is the card (`blight_well`), its pool the Cleric's one draft pool — any lineage.
	ok(Classes.draft_pool("cleric").has("Blight the Well") and Classes.engine_read("Blight the Well") == "",
		"§2c: Blight the Well is not in the Cleric's draft pool with no engine row")
	var dv := 0
	seed(SEED)
	for i2 in DRAWS:
		_new_run(["warden", "pyromancer", "inquisitor", "mystic"])
		if (_run.roll_draft_offer(_run.party[2]) as Array).has("Blight the Well"):
			dv += 1
	ok(dv > 0, "§2c: a fresh Devout (no Old Gods) was never offered Blight the Well in %d drafts" % DRAWS)
	print("    Umbral Sigil: the Occultist's boss award, offered in %d of %d rolls; Blight the Well: a Devout's draft, %d of %d" % [
		hits, DRAWS, dv, DRAWS])


# ── §3 — A TICK IS CREDITED TO ITS LAYER ────────────────────────────────────

func _tick_credit(s: Node, foe: BattleUnit, id: String, layer: BattleUnit) -> Dictionary:
	var label := String((s.get("STATUS_INFO") as Dictionary)[id][0])
	var names: Array = (s.get("heroes") as Array).map(func(h): return (h as BattleUnit).unit_name)
	var before := {}
	for n in names:
		before[n] = _booked(s, String(n), label)
	if id == "poison" and layer != null:
		s._apply_poison(layer, foe, 3)
	elif layer != null:
		s._apply_status(foe, id, 3, 0, 7, layer)
	else:
		s._apply_status(foe, id, 3, 0, 7)
	if id == "poison":
		foe.get_status("poison")["fresh"] = false
	foe.hp = foe.max_hp
	var h0 := foe.hp
	await s._dot_pass(foe)
	var out := {"lost": h0 - foe.hp}
	for n2 in names:
		var d := _booked(s, String(n2), label) - float(before[n2])
		if not is_zero_approx(d):
			out[n2] = d
	foe.remove_status(id)
	return out


func _s3_credit_by_layer() -> void:
	print("\n§3 — a tick is credited to the hero who laid it, never to a lineage's name")
	# THE DEVOUT's re-laid Burn, unvowed: his.
	var s: Node = await _board(["warden", "pyromancer", "inquisitor", "mystic"], {2: {"runes": [_rune("returned_burden")]}})
	var set: Dictionary = await _devout_burn(s, false)
	if not bool(set.get("ok", false)):
		ok(false, "§3: the premise — the Devout's Burn")
	else:
		var c: BattleUnit = set["c"]
		var foe: BattleUnit = set["foe"]
		var label := String((s.get("STATUS_INFO") as Dictionary)["burn"][0])
		var py := _hero(s, "mage")
		var pb0 := _booked(s, py.unit_name, label)
		var cb0 := _booked(s, c.unit_name, label)
		foe.hp = foe.max_hp
		var h0 := foe.hp
		await s._dot_pass(foe)
		var lost: int = h0 - foe.hp
		ok(lost > 0 and is_equal_approx(_booked(s, c.unit_name, label) - cb0, float(lost))
			and is_zero_approx(_booked(s, py.unit_name, label) - pb0),
			"§3: the Devout's re-laid Burn landed %d and booked %s to him, %s to the Pyromancer — it is his" % [lost,
				_booked(s, c.unit_name, label) - cb0, _booked(s, py.unit_name, label) - pb0])
		# THE PYROMANCER's OWN, AS BEFORE.
		var mine := await _tick_credit(s, _melee(s, [foe]), "burn", py)
		ok(mine.size() == 2 and is_equal_approx(float(mine.get(py.unit_name, 0.0)), float(mine["lost"])),
			"§3: the Pyromancer's own Burn booked %s — his, as it always was" % [mine])
		# A BURN THAT NAMES NOBODY OF THE PARTY: nobody's.
		var none := await _tick_credit(s, _melee(s, [foe]), "burn", null)
		ok(int(none["lost"]) > 0 and none.size() == 1, "§3: a Burn that names nobody booked %s — it is nobody's" % [none])
		print("    the Devout's Burn %d → him; the Pyromancer's own %s; nobody's %s" % [lost, mine, none])
	await _clear(s)
	# A MAGE ON HIS CLASS's SPINE (named *Mage*) and A SHARPSHOOTER's POISON: theirs.
	s = await _board(["warden", "", "inquisitor", "sharpshooter"], {1: {"engines": [_rune(Runes.engine_rune_id("channel"))]}})
	var mg := _hero(s, "mage")
	var ss := _hero(s, "hunter")
	if mg == null or ss == null or mg.unit_name != "Mage":
		ok(false, "§3: the premise — a Mage on his spine, named Mage (%s)" % [mg.unit_name if mg != null else "none"])
	else:
		var a := await _tick_credit(s, _melee(s), "burn", mg)
		ok(a.size() == 2 and is_equal_approx(float(a.get("Mage", 0.0)), float(a["lost"])),
			"§3: a Mage on his spine laid a Burn that booked %s — his; HEAD booked it to nobody" % [a])
		var b := await _tick_credit(s, _melee(s), "poison", ss)
		ok(b.size() == 2 and is_equal_approx(float(b.get(ss.unit_name, 0.0)), float(b["lost"])),
			"§3: the Sharpshooter's Poison booked %s — his; HEAD booked it to a hero named Survivalist" % [b])
		print("    the spine Mage's Burn %s; the Sharpshooter's Poison %s" % [a, b])
	await _clear(s)


# ── §4 — THE DOCUMENTS ──────────────────────────────────────────────────────

# Each needle is the rule's own words — the heading or the sentence — never the provenance beside it (EA §2's rule:
# a pin that carries a batch code reds the day the attribution is edited, and asks when, not what).
const MOVED_HEADS := [
	"## THE LITERAL-DIGIT RULE IS A BASELINE, NOT A GATE",
	"## STANDING RULE — EK'S INERTNESS CLAIM ENDED AT EZ AND CAME BACK AT FN",
]
const RULE_HEADS := [
	"## STANDING RULE — A CENSUS OF READERS COVERS WHAT A BATCH MOVES, NOT ONLY WHAT IT DELETES",
	"## STANDING RULE — PLAYER-FACING TEXT THAT STATES A NUMBER READS IT OFF THE CONSTANT, OR AN INSTRUMENT ASSERTS THE TWO AGREE",
]


func _s4_the_documents() -> void:
	print("\n§4 — the archive pass and §0.7's rules, each where it lives")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cr := FileAccess.get_file_as_string("res://docs/combat-rules.md")
	# THE PRACTICE, IN THE FILE IT BINDS (§0.7's third rule is `CLAUDE.md`'s own).
	ok(cm.contains("WHAT A BATCH CLOSES HERE MOVES OUT, AS WHAT `docs/state.md` CLOSES DOES")
		and cm.contains("Every batch that writes a standing rule here asks")
		and cm.contains("whether the block it supersedes can move to a reference."),
		"§4: CLAUDE.md does not state the archive practice and its standing step")
	# THE FIRST PASS: each closed block gone from the required read and standing once in its reference.
	for h in MOVED_HEADS:
		ok(not cm.contains(String(h)) and ir.count(String(h)) == 1,
			"§4: '%s' is in CLAUDE.md %d time(s) and in the instrument rules %d — moved, once" % [String(h).substr(0, 60),
				cm.count(String(h)), ir.count(String(h))])
	# §0.7's FIRST TWO RULES, IN THE INSTRUMENT RULES (their rows are `check_hx` §1a's).
	for h2 in RULE_HEADS:
		ok(ir.count(String(h2)) == 1 and not cm.contains(String(h2)),
			"§4: '%s' does not stand once in the instrument rules, and nowhere else" % String(h2).substr(0, 70))
	var owed := ""
	for line in ir.split("\n"):
		if String(line).contains("THE SWEEP FOR THE REST IS OWED"):
			owed = String(line)
	ok(owed.contains("RULED, NOT BUILT"),
		"§4: the text-against-constant sweep is not recorded as owed, RULED, NOT BUILT")
	# §0.4 — FOUR GLYPHS.
	ok(cm.contains("○ — A THING YOU WEAR IS PAYING NOTHING — IS THE FOURTH") and cm.contains("Four glyphs, four meanings"),
		"§4: CLAUDE.md's glyph rule does not name ○ as the fourth")
	# THE COMBAT RULES, RE-READ (HY §6): the two frames, the tick's credit, the partition closed.
	ok(cr.contains("two more borrow under a LAYER's frame")
		and cr.contains("damage-over-time tick's line, Blight the Well's line and credit, the bleedout burst's float and line")
		and cr.contains("(`battle._layer_credit_name`: the hero who laid it"),
		"§4: docs/combat-rules.md does not say where the two frames, the three sites and the tick's credit stand since II")
	print("    the practice stated; %d block(s) moved, %d rule(s) written; four glyphs; the combat rules re-read" % [
		MOVED_HEADS.size(), RULE_HEADS.size()])


# ── §9 — THE PLAYER's FILES ────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
