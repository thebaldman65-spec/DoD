extends SceneTree

# ══════════════════════════════════════════════════════════════════════════════
# BATCH GX — A RUNE SITTING OUT SAYS SO
#
# **GV GATED THIRTY-FIVE RUNES ON THEIR ENGINE AND LEFT THE SLOT UNSAID.** A
# rune bought while its engine was slotted is already past the offer's door;
# unequip the engine afterwards and it sits in one of the three ordinary slots
# paying nothing, with nothing on any screen saying why. **GT solved the same
# defect one layer down** for a benched CARD — its tell names which rune brings
# it back, on the hero sheet and the map's Kit panel — and this gate asserts the
# same tell one layer up, in GT's own words, on the three surfaces that show a
# HELD rune.
#
# **WHAT THIS GATE IS NOT ABOUT.** No rune is retuned, re-authored or retired;
# the payload is still applied at the spawn and every read site still refuses
# for want of the engine exactly as GV left it. §6 asserts that, because a tell
# that quietly became a mechanic is the failure this batch could commit.
#
# **THE NEGATIVE ANCHORS ARE PAIRED.** Every "this does not say it sits out"
# arm stands beside a "this does" arm on the same surface and the same frame —
# a gate that only ever asserts an absence passes on a screen that draws
# nothing at all (CW §1).
# ══════════════════════════════════════════════════════════════════════════════

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://gx_profile.json"
const SCRATCH_RELICS := "user://gx_relics.json"

# GT's sentence, and the clause GX keeps from it. **PINNED AS LITERALS HERE**
# so a reworded note is a red rather than a silent second phrasing.
const GT_HEAD := "Sits out of every fight while the"
const GX_NOTE_LINES := ["Sits out of every fight while the",
	"Still worn: the slot stays filled.",
	"Unequipping the rune frees the slot."]
const GT_NOTE_LINES := ["Sits out of every fight while the",
	"Still carried: the slot stays counted.",
	"Benching the card frees the slot."]
# The hand-broken ceiling GT measured for the same tooltip (`run_state.gd`).
const NOTE_LINE_CEILING := 44
# The map's three rune slots: 92 px wide, pitched 96 apart (`map_screen.gd`).
const SLOT_W := 92.0
const SLOT_PITCH := 96.0
# The marker the map slot draws for a worn rune that pays nothing.
const SLOT_MARK := "○ "
# A rune that reads NO engine, as the paired positive control on every arm that
# asserts a tell is absent. Beastmaster scope, ungated (GV's third group).
const CONTROL_RUNE := "shared_hide"

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _gated: Array = []
var _ungated: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GX — A RUNE SITTING OUT SAYS SO")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before anything is drawn")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_scratch_files()
	_populations()
	Engine.max_fps = 0
	_s1_the_predicate()
	_s2_the_slot_measures()
	await _s3_the_three_surfaces()
	await _s3c_the_battle_log()
	await _s4_the_pouch_with_six_held()
	_s5_the_sentence()
	await _s6_nothing_was_retuned()
	_s7_the_players_files()
	Engine.time_scale = 1.0
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _scratch_files() -> void:
	Profile.save_path = SCRATCH_PROFILE
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.loaded = false
	Profile.data = {}
	Relics.save_path = SCRATCH_RELICS
	var rf := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	rf.store_string("[]")
	rf.close()
	Relics.loaded = false


# **THE POPULATIONS ARE DERIVED, NEVER TYPED.** The gated set is
# `Runes.ENGINE_READ`'s own keys and the ungated set is every other live
# ordinary rune in `runes.json` — so a row added or dropped moves this gate's
# counts rather than slipping past a hand-written list (EA §5).
func _populations() -> void:
	for id in Runes.ENGINE_READ:
		_gated.append(String(id))
	_gated.sort()
	var data: Dictionary = Runes._load()
	for id2 in data:
		var e: Dictionary = data[id2]
		if String(e.get("retired", "")) != "":
			continue
		if String(e.get("engine", "")) != "":
			continue
		if Runes.ENGINE_READ.has(String(id2)):
			continue
		_ungated.append(String(id2))
	_ungated.sort()


func _seat_party() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
		_run.party[i]["runes"] = []
	_run.specs_chosen = true
	_run.active = true


# Seat `idx` wearing `rune_id` in an ordinary slot, holding the engine that rune
# reads, with that engine slotted or not. **THE RUNE IS EQUIPPED IN BOTH ARMS**
# — the batch is about a rune already past the offer's door.
func _dress(idx: int, rune_id: String, engine_in: bool, extra: Array = []) -> void:
	var pid := Runes.engine_read(rune_id)
	var erid := Runes.engine_rune_id(pid)
	var engines: Array = []
	if erid != "":
		var er: Dictionary = Runes.build(erid)
		er["equipped"] = engine_in
		engines.append(er)
	var runes: Array = []
	var r: Dictionary = Runes.build(rune_id)
	r["equipped"] = true
	runes.append(r)
	for x in extra:
		var xr: Dictionary = Runes.build(String(x))
		xr["equipped"] = true
		runes.append(xr)
	_run.party[idx]["engines"] = engines
	_run.party[idx]["runes"] = runes


func _labels(n: Node, out: Array) -> void:
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _label_with(n: Node, needle: String) -> Label:
	var all: Array = []
	_labels(n, all)
	for l in all:
		if String((l as Label).text).contains(needle):
			return l
	return null


# **EXACT, NOT CONTAINING, AND THE DIFFERENCE IS LOAD-BEARING.** GT's own card
# chip reads `<card> — sits out`, which CONTAINS the state column's whole text,
# so a substring finder would let a benched CARD satisfy a rune's arm and would
# also break the rune arm's paired negative on any hero holding one. The state
# column is asked for by its exact text (EU: exact-match sweeps and containment
# are different questions, and this is the one that needs exact).
func _label_exact(n: Node, text: String) -> Label:
	var all: Array = []
	_labels(n, all)
	for l in all:
		if String((l as Label).text) == text:
			return l
	return null


func _buttons(n: Node, out: Array) -> void:
	if n is Button:
		out.append(n)
	for c in n.get_children():
		_buttons(c, out)


func _button(n: Node, text: String) -> Button:
	var all: Array = []
	_buttons(n, all)
	for b in all:
		if String((b as Button).text) == text:
			return b
	return null


func _inside_scroll(n: Node) -> bool:
	var p: Node = n.get_parent()
	while p != null:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _first_scroll(n: Node) -> ScrollContainer:
	if n is ScrollContainer:
		return n
	for c in n.get_children():
		var s := _first_scroll(c)
		if s != null:
			return s
	return null


func _close_overlays(mp: Node) -> void:
	for z in [60]:
		var ov: Node = Gate.overlay(mp, z)
		while ov != null:
			ov.free()
			ov = Gate.overlay(mp, z)
	mp._rune_panel_for = -1
	mp._loadout_panel_for = -1


# **THE RUNE SLOTS OF ONE SEAT, FOUND BY THE DOOR THEY OPEN AND NOT BY THEIR
# FACE.** A button read by the text it is EXPECTED to carry is invisible to a
# button carrying the WRONG text: the arm simply finds nothing and reports the
# absence, so the width arm beside it never runs at all. That is how `slotword`
# — the face the §2 measurement ruled out, put back — first printed the same
# FAIL lines as deleting the tell outright, proving nothing the other control
# had not. Found this way, the width is measured on whatever the slot drew.
func _slot_buttons(mp: Node, seat: int) -> Array:
	var all: Array = []
	_buttons(mp, all)
	var out: Array = []
	for b in all:
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_open_rune_panel" and cb.get_bound_arguments() == [seat]:
				out.append(b)
				break
	return out


func _engine_rune_name(rune_id: String) -> String:
	return String(Runes.config(Runes.engine_rune_id(Runes.engine_read(rune_id))).get("name", ""))


# ── §1 — THE PREDICATE, OVER ITS WHOLE DERIVED POPULATION ───────────────────

func _s1_the_predicate() -> void:
	print("\n§1 — which worn runes sit out, over every live ordinary rune")
	# **BATCH HC §2 — 36 AND 24: LAYERED AEGIS IS A ROW.** Its card is the
	# Devout's enabler and leaves with Conviction, and a cache's answer never asks
	# the requirement, so it joined `Runes.ENGINE_READ`. The populations are still
	# derived from the table and the file (`_populations`); these two lines are
	# the ruling's count, and they move only when a row does.
	# **BATCH HE §1 — 43 AND 17: SEVEN RULED ROWS.** Long Fuse, Killing Cold,
	# Deep Cold, Long Poison, Mirror Guard, Slaughterhouse and Bared Plate read a
	# status or a stance no class kit lays (or a price only one engine gives), and
	# the designer gated each on its engine. Each read site asks the engine too, so
	# each sits out without it, and every arm below walks them as rows.
	ok(_gated.size() == 43, "§1: %d gated runes — the table holds 43 (GV's 35, HC's Layered Aegis and HE's seven)" % _gated.size())
	ok(_ungated.size() == 17, "§1: %d ungated live ordinary runes — 17 since HE" % _ungated.size())
	# THE GATED FORTY-THREE: out without the engine, in with it. Both arms.
	var out_without := 0
	var in_with := 0
	for rid in _gated:
		var pid := Runes.engine_read(rid)
		ok(pid != "", "§1: %s is in ENGINE_READ with no engine named" % rid)
		ok(Runes.sits_out(rid, []), "§1: %s does not sit out for a hero holding no engine" % rid)
		if Runes.sits_out(rid, []):
			out_without += 1
		ok(not Runes.sits_out(rid, [pid]), "§1: %s still sits out with %s slotted" % [rid, pid])
		if not Runes.sits_out(rid, [pid]):
			in_with += 1
		# AND IT IS THE OFFER'S OWN ANSWER, INVERTED — one predicate, not two.
		ok(Runes.sits_out(rid, []) == (not Runes.offerable(rid, [])),
			"§1: %s reads differently through `sits_out` and `offerable`" % rid)
		# A HERO HOLDING SOME OTHER ENGINE IS NOT HOLDING THIS ONE.
		var other := "old_gods" if pid != "old_gods" else "mercy"
		ok(Runes.sits_out(rid, [other]), "§1: %s does not sit out for a hero holding only %s" % [rid, other])
	ok(out_without == _gated.size() and in_with == _gated.size(),
		"§1: %d of %d sit out with the engine out and %d of %d pay with it in" % [
			out_without, _gated.size(), in_with, _gated.size()])
	# THE PAIRED POSITIVE: the other 17 never sit out, on any engine set —
	# **BATCH HB: ON ANY SET THAT FIELDS A PET.** Four of them need a companion
	# (`Runes.COMPANION_READ`), and a hero holding the engine that dismisses the
	# pet fields none, so those four sit out beside it and for nobody else; the
	# other thirteen never sit out at all (HE §1 took seven into the table, none a
	# companion rune). Both halves on every rune.
	var never := 0
	var pet_out := 0
	for uid in _ungated:
		var s_none: bool = Runes.sits_out(uid, [])
		var s_all: bool = Runes.sits_out(uid, ["old_gods", "mercy", "pack"])
		var s_dis: bool = Runes.sits_out(uid, ["old_gods", "mercy", "pack", "lethal_aim"])
		var fits: bool = not s_none and not s_all and s_dis == Runes.reads_companion(uid)
		ok(fits, "§1: %s is ungated and reads as sitting out (%s), or beside the dismisser it reads %s where it %s a companion" % [
			uid, "empty set" if s_none else "a set with a pet", s_dis,
			"needs" if Runes.reads_companion(uid) else "needs no"])
		if fits:
			never += 1
		if s_dis:
			pet_out += 1
	ok(never == _ungated.size() and pet_out == 4,
		"§1: %d of %d ungated runes never sit out on a set that fields a pet, and %d sit out beside the dismisser — the four that need a companion" % [
			never, _ungated.size(), pet_out])
	# AN ENGINE RUNE IS NOT AN ORDINARY ONE AND NEVER SITS OUT.
	for spec in ["beastmaster", "occultist", "holy", "arcanist"]:
		var erid := Runes.engine_rune_id(Classes.engine_of_spec(spec))
		if erid == "":
			continue
		ok(not Runes.sits_out(erid, []), "§1: the engine rune %s reads as sitting out" % erid)
	print("    %d gated runes out in the empty arm and paying in the held arm; %d ungated never out" % [
		out_without, never])


# ── §2 — THE MAP SLOT'S FACE, MEASURED ──────────────────────────────────────

func _s2_the_slot_measures() -> void:
	print("\n§2 — the map's rune slot: why the face is a marker and not a word")
	var f: Font = ThemeDB.fallback_font
	var widest := {"name": 0.0, "mark": 0.0, "paren": 0.0, "dash": 0.0, "sits": 0.0}
	var who := {}
	for rid in _gated:
		var n := String(Runes.config(rid).get("name", ""))
		var forms := {"name": n, "mark": SLOT_MARK + n, "paren": "%s (out)" % n,
			"dash": "%s — out" % n, "sits": "%s — sits out" % n}
		for k in forms:
			var w: float = f.get_string_size(String(forms[k]), HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x
			if w > float(widest[k]):
				widest[k] = w
				who[k] = String(forms[k])
	ok(float(widest["name"]) <= SLOT_W,
		"§2: the widest gated name is %.0f px, over the %.0f-px slot" % [widest["name"], SLOT_W])
	ok(float(widest["mark"]) <= SLOT_W,
		"§2: the marker form is %.0f px (%s), over the %.0f-px slot" % [
			widest["mark"], who.get("mark", ""), SLOT_W])
	# THE NEGATIVE HALF, AND IT IS WHY THE FACE IS A MARKER: every word form
	# overflows. Paired with the two positives above, on the same measurement.
	for k2 in ["paren", "dash", "sits"]:
		ok(float(widest[k2]) > SLOT_W,
			"§2: the %s form fits the slot at %.0f px — the marker is no longer the only face that fits" % [
				k2, widest[k2]])
	print("    font 10, widest of the gated: name %.0f, marker %.0f, (out) %.0f, — out %.0f, — sits out %.0f; the slot is %.0f px, pitched %.0f" % [
		widest["name"], widest["mark"], widest["paren"], widest["dash"], widest["sits"], SLOT_W, SLOT_PITCH])


# ── §3 — THE THREE SURFACES, DRIVEN, IN BOTH ARMS ───────────────────────────

func _s3_the_three_surfaces() -> void:
	print("\n§3 — the pouch, the map's slot and the hero sheet, engine out and engine in")
	_seat_party()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 10)
	var mp: Node = current_scene
	ok(Gate.scene_name(self) == "Map", "§3: the map is not on screen (%s)" % Gate.scene_name(self))
	if Gate.scene_name(self) != "Map":
		return
	var seat := 0
	var pouch_said := 0
	var pouch_quiet := 0
	var slot_said := 0
	var slot_quiet := 0
	# EVERY ONE OF THE THIRTY-FIVE, ON THE POUCH AND ON THE MAP'S SLOT, IN BOTH
	# ARMS. The pouch is the surface the brief names as the one that matters.
	for rid in _gated:
		var rname := String(Runes.config(rid).get("name", ""))
		var ername := _engine_rune_name(rid)
		var note: String = _run.rune_sits_out_note(rid)
		for engine_in in [false, true]:
			_dress(seat, rid, engine_in)
			_close_overlays(mp)
			await Gate.frames(self, 2)
			mp._draw_screen()
			await Gate.frames(self, 2)
			var arm := "engine in" if engine_in else "engine out"
			# THE MAP'S SLOT BUTTON, before anything is opened — the slot the
			# rune is in, whatever face it drew.
			var slots: Array = _slot_buttons(mp, seat)
			ok(slots.size() == _run.rune_slots(),
				"§3 %s (%s): %d rune slot buttons — %d expected" % [
					rid, arm, slots.size(), _run.rune_slots()])
			var face: Button = null
			for b in slots:
				if String((b as Button).text).contains(rname):
					face = b
					break
			ok(face != null, "§3 %s (%s): no rune slot draws %s at all" % [rid, arm, rname])
			if face != null:
				# **THE WIDTH IS MEASURED IN BOTH ARMS AND ON WHATEVER THE SLOT
				# DREW**, which is the arm that catches a face the §2
				# measurement ruled out: the 92 is a MINIMUM, so an overlong
				# face grows the button past the 96-px pitch and lies over its
				# neighbour rather than clipping.
				ok(face.size.x <= SLOT_PITCH,
					"§3 %s (%s): the slot drawing `%s` is %.0f px wide, over the %.0f-px pitch" % [
						rid, arm, face.text, face.size.x, SLOT_PITCH])
				if engine_in:
					ok(String(face.text) == rname,
						"§3 %s (%s): the map's slot reads `%s`, not the rune's bare name" % [
							rid, arm, face.text])
					if String(face.text) == rname:
						slot_quiet += 1
				else:
					ok(String(face.text) == SLOT_MARK + rname,
						"§3 %s (%s): the map's slot reads `%s`, not the marked name" % [
							rid, arm, face.text])
					if String(face.text) == SLOT_MARK + rname:
						slot_said += 1
					var tip := String(face.tooltip_text)
					ok(tip.contains(note) and tip.contains(ername),
						"§3 %s (%s): the slot's tooltip does not carry the sentence and the engine rune" % [rid, arm])
			# THE POUCH.
			mp._open_rune_panel(seat)
			await Gate.frames(self, 3)
			var ov: Node = Gate.overlay(mp, 60)
			ok(ov != null, "§3 %s (%s): the pouch did not open" % [rid, arm])
			if ov == null:
				continue
			var told: Label = _label_with(ov, "✦ %s — %s" % [rname, GT_HEAD])
			var ordinary: Label = _label_with(ov, "✦ %s — %s" % [
				rname, Runes.shown_desc(Runes.build(rid))])
			if engine_in:
				ok(told == null and ordinary != null,
					"§3 %s (%s): the pouch does not show the rune's own rule" % [rid, arm])
				if told == null and ordinary != null:
					pouch_quiet += 1
			else:
				ok(told != null and ordinary == null,
					"§3 %s (%s): the pouch row does not say the rune is sitting out" % [rid, arm])
				if told != null:
					pouch_said += 1
					ok(String(told.text).contains(ername),
						"§3 %s: the pouch row does not name the engine rune that brings it back" % rid)
					ok(String(told.text) == "✦ %s — %s" % [rname, note.replace("\n", " ")],
						"§3 %s: the pouch row is not the one sentence, flattened" % rid)
					ok(not String(told.text).contains("\n"),
						"§3 %s: the pouch row carries a raw line break" % rid)
			_close_overlays(mp)
			await Gate.frames(self, 1)
	ok(pouch_said == _gated.size() and pouch_quiet == _gated.size(),
		"§3: the pouch said it for %d of the gated with the engine out and stayed quiet for %d of them with it in" % [
			pouch_said, pouch_quiet])
	ok(slot_said == _gated.size() and slot_quiet == _gated.size(),
		"§3: the map's slot marked %d of the gated with the engine out and left %d of them bare with it in" % [
			slot_said, slot_quiet])
	# THE UNGATED CONTROL, ON THE SAME SURFACES AND THE SAME FRAME: a rune with
	# no engine to wait on is never marked, whatever the hero's slots hold.
	var cr: Dictionary = Runes.build(CONTROL_RUNE)
	cr["equipped"] = true
	_run.party[seat]["engines"] = []
	_run.party[seat]["runes"] = [cr]
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp._draw_screen()
	await Gate.frames(self, 2)
	var cname := String(cr["name"])
	ok(_button(mp, cname) != null and _button(mp, SLOT_MARK + cname) == null,
		"§3: the ungated control %s is marked on the map's slot with no engine held" % CONTROL_RUNE)
	mp._open_rune_panel(seat)
	await Gate.frames(self, 3)
	var cov: Node = Gate.overlay(mp, 60)
	ok(cov != null and _label_with(cov, "✦ %s — %s" % [cname, Runes.shown_desc(cr)]) != null,
		"§3: the ungated control does not show its own rule in the pouch")
	ok(cov != null and _label_with(cov, GT_HEAD) == null,
		"§3: the ungated control is told it sits out")
	_close_overlays(mp)
	await Gate.frames(self, 2)
	# AND A GATED RUNE THE HERO HAS NOT EQUIPPED — in the pouch, not in a slot —
	# is not marked either: the tell is about a slot that is paying nothing.
	var unworn: Dictionary = Runes.build(_gated[0])
	unworn["equipped"] = false
	_run.party[seat]["engines"] = []
	_run.party[seat]["runes"] = [unworn]
	ok((_run.sitting_out_rune_names(_run.party[seat]) as Array).is_empty(),
		"§3: a gated rune sitting in the pouch unequipped is reported as sitting out")
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp._open_rune_panel(seat)
	await Gate.frames(self, 3)
	var uov: Node = Gate.overlay(mp, 60)
	ok(uov != null and _label_with(uov, GT_HEAD) == null,
		"§3: an unequipped gated rune is told it sits out")
	ok(uov != null and _label_with(uov, String(unworn["name"]) + " — ") != null,
		"§3: the unequipped gated rune is not drawn in the pouch at all")
	_close_overlays(mp)
	await Gate.frames(self, 2)
	# THE HERO SHEET, ONE RUNE PER ENGINE, BOTH ARMS.
	await _s3b_the_hero_sheet(seat)


func _s3b_the_hero_sheet(seat: int) -> void:
	var per_engine := {}
	for rid in _gated:
		var pid := Runes.engine_read(rid)
		if not per_engine.has(pid):
			per_engine[pid] = rid
	ok(per_engine.size() == 12, "§3: %d engines in GV's table — twelve expected" % per_engine.size())
	var said := 0
	var quiet := 0
	for pid2 in per_engine:
		var rid2 := String(per_engine[pid2])
		var rname := String(Runes.config(rid2).get("name", ""))
		var ername := _engine_rune_name(rid2)
		var note: String = _run.rune_sits_out_note(rid2)
		for engine_in in [false, true]:
			_dress(seat, rid2, engine_in)
			_run.hero_screen_idx = seat
			change_scene_to_file("res://scenes/party.tscn")
			await Gate.frames(self, 6)
			var sheet: Node = current_scene
			var arm := "engine in" if engine_in else "engine out"
			var row: Label = _label_with(sheet, "✦ %s — " % rname)
			ok(row != null, "§3 %s (%s): the hero sheet does not draw the worn rune's row" % [rid2, arm])
			if row == null:
				continue
			var state: Label = _label_exact(sheet, "sits out")
			if engine_in:
				ok(state == null, "§3 %s (%s): the sheet says a paying rune sits out" % [rid2, arm])
				ok(String(row.tooltip_text) == "",
					"§3 %s (%s): the sheet hangs a sits-out note on a paying rune" % [rid2, arm])
				if state == null:
					quiet += 1
			else:
				ok(state != null and String(state.text) == "sits out",
					"§3 %s (%s): the sheet's state column does not read `sits out`" % [rid2, arm])
				ok(String(row.tooltip_text) == note and note.contains(ername),
					"§3 %s (%s): the sheet's row does not carry the sentence naming %s" % [rid2, arm, ername])
				ok(state != null and String(state.tooltip_text) == note,
					"§3 %s (%s): the sheet's state column carries no reason" % [rid2, arm])
				# THE ROW STILL SHOWS THE RUNE'S OWN RULE — this page is read to
				# study a loadout, so the text the player came for is not
				# replaced the way the pouch's is.
				ok(String(row.text).contains(Runes.shown_desc(Runes.build(rid2))),
					"§3 %s: the sheet dropped the rune's own rule" % rid2)
				if state != null:
					said += 1
	ok(said == 12 and quiet == 12,
		"§3: the hero sheet said it for %d of 12 engines and stayed quiet for %d of 12" % [said, quiet])
	print("    the pouch, the map's slot and the sheet each said it in the engine-out arm and stayed quiet in the engine-in arm")


# ── §3c — THE BATTLE LOG'S ROLL CALL ────────────────────────────
#
# **THE FOURTH SURFACE, AND THE ONE THE CARD LAYER HAS NO COUNTERPART FOR.** A
# card that sits out is absent from the fight, so GT had nothing to mark in the
# log; a rune that sits out is still equipped and still has its payload applied,
# so the spawn named it in the log of a fight it paid nothing in. Driven through
# a real spawn rather than read off the source: the roll call is built inside
# `battle.gd`'s hero loop and there is no other way to see what it holds.

func _s3c_the_battle_log() -> void:
	print("\n§3c — the battle log's opening roll call")
	var rid := ""
	for g in _gated:
		if Runes.engine_read(g) == "old_gods":
			rid = g
			break
	ok(rid != "", "§3c: no Occultist rune found")
	if rid == "":
		return
	var rname := String(Runes.config(rid).get("name", ""))
	var ername := _engine_rune_name(rid)
	for engine_in in [false, true]:
		var erid := Runes.engine_rune_id("old_gods")
		var er: Dictionary = Runes.build(erid)
		er["equipped"] = engine_in
		var r: Dictionary = Runes.build(rid)
		r["equipped"] = true
		var scene: Node = await Gate.spawn(self, ["occultist", "", "", ""],
			{"party": {0: {"engines": [er], "runes": [r]}}})
		var arm := "engine in" if engine_in else "engine out"
		var roll: Array = scene.get("_rune_roll_call")
		var mine: Array = roll.filter(func(l): return String(l).contains(rname))
		ok(mine.size() == 1,
			"§3c %s: the roll call names %s %d times — once expected" % [arm, rname, mine.size()])
		if mine.size() != 1:
			scene.queue_free()
			await Gate.frames(self, 2)
			continue
		var line := String(mine[0])
		if engine_in:
			# THE PAIRED POSITIVE: with the engine in the line is the bare one it
			# has always been, so the arm below cannot pass on a log that simply
			# stopped naming runes.
			ok(line.ends_with(": " + rname),
				"§3c %s: the roll call marks a rune that is paying (%s)" % [arm, line])
			ok(not line.to_lower().contains("sits out"),
				"§3c %s: the roll call says a paying rune sits out" % arm)
		else:
			# The note opens with a capital, so the needle is case-folded here
			# and NOT in the paired arm above, where a bare line must contain
			# no form of the words at all.
			ok(line.to_lower().contains("sits out"),
				"§3c %s: the roll call does not say the rune sits out (%s)" % [arm, line])
			ok(line.contains(ername),
				"§3c %s: the roll call does not name %s (%s)" % [arm, ername, line])
			ok(line.begins_with(String(scene.get("heroes")[0].unit_name) + ": " + rname),
				"§3c %s: the roll call's line no longer opens `<hero>: <rune>` (%s)" % [arm, line])
			# **AND IT IS THE NOTE'S OWN WORDS, NOT A FOURTH PHRASING.** The
			# tail is built from `rune_sits_out_note`; asserting it against
			# that function is what makes the log part of the one sentence
			# rather than a second thing to keep in step.
			var nl: PackedStringArray = String(_run.rune_sits_out_note(rid)).split("\n")
			ok(line.ends_with(" — %s %s" % [nl[0], nl[1]]),
				"§3c %s: the roll call's tail is not the note's first two lines joined (%s)" % [arm, line])
			print("    %s" % line)
		scene.queue_free()
		await Gate.frames(self, 2)



# ── §4 — THE POUCH WITH SIX HELD AND TWO SITTING OUT ────────────────────────
#
# **A TELL ADDED TO A LIST THAT ALREADY OVERFLOWED IS WORTH MEASURING.** GT
# found this panel's Close button drew off the 720-px screen for all sixty pairs
# of one class's engines before it fixed the layout; GX puts a two-line sentence
# into rune rows that were one line. The brief asks what the pouch measures with
# six runes held and two sitting out, so that is what this drives.

func _s4_the_pouch_with_six_held() -> void:
	print("\n§4 — the pouch with six runes held and two sitting out")
	_seat_party()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 10)
	var mp: Node = current_scene
	if Gate.scene_name(self) != "Map":
		ok(false, "§4: the map is not on screen (%s)" % Gate.scene_name(self))
		return
	var seat := 0
	# SIX RUNES HELD — the pouch's own worst case, since three is the slot cap
	# and elite drops have no cap on what is CARRIED. Two of them are gated and
	# worn, so two sit out; the engine they read is held and unequipped.
	var gated_two: Array = []
	for rid in _gated:
		if Runes.engine_read(rid) == "old_gods" and gated_two.size() < 2:
			gated_two.append(rid)
	ok(gated_two.size() == 2, "§4: %d Occultist runes found for the two sitting out" % gated_two.size())
	var others: Array = _ungated.slice(0, 4)
	ok(others.size() == 4, "§4: %d filler runes — four expected" % others.size())
	var pinned := Rect2()
	var have_pin := false
	var rows := {}
	for engine_in in [true, false]:
		var erid := Runes.engine_rune_id("old_gods")
		var er: Dictionary = Runes.build(erid)
		er["equipped"] = engine_in
		var held: Array = []
		for k in gated_two.size():
			var r: Dictionary = Runes.build(String(gated_two[k]))
			r["equipped"] = true
			held.append(r)
		for m in others.size():
			var o: Dictionary = Runes.build(String(others[m]))
			o["equipped"] = m == 0
			held.append(o)
		_run.party[seat]["engines"] = [er]
		_run.party[seat]["runes"] = held
		ok(held.size() == 6, "§4: %d runes held — six expected" % held.size())
		var sitting: Array = _run.sitting_out_rune_names(_run.party[seat])
		ok(sitting.size() == (0 if engine_in else 2),
			"§4: %d runes sit out with the engine %s — %d expected" % [
				sitting.size(), "in" if engine_in else "out", 0 if engine_in else 2])
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_rune_panel(seat)
		await Gate.frames(self, 4)
		var ov: Node = Gate.overlay(mp, 60)
		ok(ov != null, "§4: the pouch did not open with six held")
		if ov == null:
			continue
		var arm := "engine in" if engine_in else "engine out"
		# CLOSE IS GT'S RULE AND IT STILL HOLDS: on the screen, in one place,
		# and not inside the scroller where text can carry it off.
		var close: Button = _button(ov, "Close")
		ok(close != null, "§4 (%s): the pouch drew no Close button" % arm)
		if close == null:
			continue
		var cr := close.get_global_rect()
		if not have_pin:
			pinned = cr
			have_pin = true
		ok(cr.position.x >= 0.0 and cr.position.y >= 0.0 and cr.end.x <= 1280.0 and cr.end.y <= 720.0,
			"§4 (%s): Close is not wholly on the 1280 x 720 screen (%s)" % [arm, str(cr)])
		ok(cr == pinned, "§4 (%s): Close moved to %s from %s" % [arm, str(cr), str(pinned)])
		ok(not _inside_scroll(close), "§4 (%s): Close is inside a scroller" % arm)
		# AND THE PLAYER LEAVES THROUGH IT.
		var sc: ScrollContainer = _first_scroll(ov)
		var content_h := 0.0
		if sc != null and sc.get_child_count() == 1:
			content_h = (sc.get_child(0) as Control).get_combined_minimum_size().y
		rows[arm] = [content_h, sc.size.y if sc != null else 0.0]
		close.emit_signal("pressed")
		await Gate.frames(self, 2)
		ok(Gate.overlay(mp, 60) == null and int(mp._rune_panel_for) == -1,
			"§4 (%s): pressing Close did not close the pouch" % arm)
	# THE MEASUREMENT THE BRIEF ASKED FOR, PRINTED RATHER THAN ASSERTED — a
	# height is a reading, and pinning it would red on any later layout change.
	for a2 in ["engine in", "engine out"]:
		if rows.has(a2):
			print("    six held, %s: the list measures %.0f px in a %.0f px scroller%s" % [
				a2, rows[a2][0], rows[a2][1],
				"" if float(rows[a2][0]) <= float(rows[a2][1]) else " — it scrolls"])
	if rows.has("engine in") and rows.has("engine out"):
		print("    the two rows sitting out add %.0f px to the list" % [
			float(rows["engine out"][0]) - float(rows["engine in"][0])])
	print("    Close at %s in both arms" % str(pinned))
	await _s4b_the_panels_worst_case(mp, seat, gated_two, others, pinned)
	_close_overlays(mp)
	await Gate.frames(self, 2)


# **AND GT's OWN WORST CASE, WITH GX's TEXT ON TOP OF IT.** Six ordinary runes
# is the brief's case; the panel's MEASURED worst case is a class holding all
# six of its engine runes, each drawn with its whole rule — that is the
# combination GT found Close 422 px below the screen for. Driving the two
# together is the only reading that says whether a tell added to a list that
# already overflowed put it back over.
func _s4b_the_panels_worst_case(mp: Node, seat: int, gated_two: Array, others: Array,
		pinned: Rect2) -> void:
	var six: Array = Classes.class_engines("mage").map(
		func(pid): return Runes.engine_rune_id(String(pid)))
	ok(six.size() == 6, "§4: the Mage holds %d engine runes — six expected" % six.size())
	var engines: Array = []
	for k in six.size():
		var er: Dictionary = Runes.build(String(six[k]))
		# THE ARCANIST'S IS SLOTTED SECOND, so the two Resonance runes below
		# sit out while five other rules are drawn at full length.
		er["equipped"] = k < 2
		engines.append(er)
	# Two RESONANCE runes worn, and the Arcanist's engine NOT among the slotted
	# two, so both sit out on a panel already holding six rules.
	var res: Array = []
	for g in _gated:
		if Runes.engine_read(g) == "resonance" and res.size() < 2:
			res.append(g)
	ok(res.size() == 2, "§4: %d Resonance runes found" % res.size())
	var arc := Runes.engine_rune_id("resonance")
	for e in engines:
		if String((e as Dictionary).get("id", "")) == arc:
			(e as Dictionary)["equipped"] = false
	var runes: Array = []
	for r2 in res:
		var rr: Dictionary = Runes.build(String(r2))
		rr["equipped"] = true
		runes.append(rr)
	for m in others.size():
		var o: Dictionary = Runes.build(String(others[m]))
		o["equipped"] = m == 0
		runes.append(o)
	_run.party[seat]["engines"] = engines
	_run.party[seat]["runes"] = runes
	var sitting: Array = _run.sitting_out_rune_names(_run.party[seat])
	ok(sitting.size() == 2,
		"§4: %d runes sit out on the panel's worst case — two expected" % sitting.size())
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp._open_rune_panel(seat)
	await Gate.frames(self, 5)
	var ov: Node = Gate.overlay(mp, 60)
	ok(ov != null, "§4: the pouch did not open on the worst case")
	if ov == null:
		return
	var close: Button = _button(ov, "Close")
	ok(close != null, "§4 (worst case): the pouch drew no Close button")
	if close == null:
		return
	var cr := close.get_global_rect()
	ok(cr.position.x >= 0.0 and cr.position.y >= 0.0 and cr.end.x <= 1280.0 and cr.end.y <= 720.0,
		"§4 (worst case): Close is not wholly on the 1280 x 720 screen (%s)" % str(cr))
	ok(cr == pinned, "§4 (worst case): Close moved to %s from %s" % [str(cr), str(pinned)])
	ok(not _inside_scroll(close), "§4 (worst case): Close is inside a scroller")
	# THE TELL IS DRAWN, WHOLE, INSIDE THE SCROLLER — the paired positive, so
	# "Close is fine" cannot be satisfied by a panel that drew no tell at all.
	var told := 0
	for nm in sitting:
		var l: Label = _label_with(ov, "✦ %s — %s" % [String(nm), GT_HEAD])
		ok(l != null, "§4 (worst case): %s is not told it sits out" % nm)
		if l == null:
			continue
		ok(_inside_scroll(l), "§4 (worst case): %s's tell is drawn outside the scroller" % nm)
		ok(l.get_theme_font_size("font_size") == 12,
			"§4 (worst case): %s's tell is drawn at size %d, not 12 — the text was shrunk" % [
				nm, l.get_theme_font_size("font_size")])
		told += 1
	ok(told == 2, "§4 (worst case): %d of 2 tells drawn" % told)
	var sc: ScrollContainer = _first_scroll(ov)
	var content_h := 0.0
	if sc != null and sc.get_child_count() == 1:
		content_h = (sc.get_child(0) as Control).get_combined_minimum_size().y
	print("    the panel's worst case — six engine rules and six runes, two sitting out: the list measures %.0f px in a %.0f px scroller%s" % [
		content_h, sc.size.y if sc != null else 0.0,
		"" if sc != null and content_h <= sc.size.y else " — it scrolls, as a long pouch always did"])
	print("    Close at %s on the worst case too" % str(cr))
	close.emit_signal("pressed")
	await Gate.frames(self, 2)
	ok(Gate.overlay(mp, 60) == null and int(mp._rune_panel_for) == -1,
		"§4 (worst case): pressing Close did not close the pouch")


# ── §5 — THE SENTENCE IS GT'S, AND THERE IS ONLY ONE OF IT ──────────────────

func _s5_the_sentence() -> void:
	print("\n§5 — one phrasing, GT's, and the 44-character break it was written to")
	var note: String = _run.rune_sits_out_note(_gated[0])
	for line in GX_NOTE_LINES:
		ok(note.contains(String(line)), "§5: the rune note has lost the line \"%s\"" % line)
	# IT OPENS WITH GT'S OWN CLAUSE, WORD FOR WORD.
	ok(note.begins_with(GT_HEAD), "§5: the rune note does not open with GT's clause")
	var card_note: String = _run.sits_out_note("Divine Plea")
	ok(card_note.begins_with(GT_HEAD), "§5: GT's card note no longer opens with its own clause")
	for line2 in GT_NOTE_LINES:
		ok(card_note.contains(String(line2)), "§5: GT's card note has lost the line \"%s\"" % line2)
	# THE TWO DIFFER ONLY IN THEIR NOUNS — a rune is worn and unequipped, a card
	# is carried and benched. **PAIRED**: the shared clause is asserted present
	# above and the divergent clauses are asserted to differ here, so a batch
	# that collapsed the two into one sentence reds, and so does one that
	# reworded the shared half.
	ok(not note.contains("Benching") and not note.contains("stays counted"),
		"§5: the rune note carries the card's own nouns")
	ok(not card_note.contains("Unequipping") and not card_note.contains("stays filled"),
		"§5: the card note carries the rune's own nouns")
	# EVERY LINE UNDER THE HAND-BROKEN CEILING, OVER EVERY ENGINE IN THE TABLE.
	var longest := ""
	for rid in _gated:
		for l in String(_run.rune_sits_out_note(rid)).split("\n"):
			ok(String(l).length() <= NOTE_LINE_CEILING,
				"§5: \"%s\" is %d characters, over the %d the tooltip was broken to" % [
					l, String(l).length(), NOTE_LINE_CEILING])
			if String(l).length() > longest.length():
				longest = String(l)
	ok(longest.length() > 0, "§5: no note line was measured")
	# AND IT NAMES A REAL ENGINE RUNE FOR EVERY ONE OF THE THIRTY-FIVE, never
	# the fallback. The fallback is kept and is asserted to be reachable.
	var named := 0
	for rid2 in _gated:
		var ername := _engine_rune_name(rid2)
		ok(ername != "" and String(_run.rune_sits_out_note(rid2)).contains(ername),
			"§5: %s's note does not name its engine rune" % rid2)
		if ername != "":
			named += 1
	ok(named == _gated.size(), "§5: %d of %d notes name a real engine rune" % [named, _gated.size()])
	ok(String(_run.rune_sits_out_note("no_such_rune")).contains("engine rune it needs"),
		"§5: the note's fallback clause is unreachable")
	print("    the longest line of the gated: %d characters — \"%s\"" % [longest.length(), longest])


# ── §6 — NOTHING WAS RETUNED ────────────────────────────────────────────────
#
# **THE ONE THING THIS BATCH COULD HAVE DONE WRONG.** GV's ruling 3 named four
# options — leave it, sit it out with a note, unequip it automatically, or let
# it be sold — and GX takes the SECOND. A tell that quietly unequipped the rune,
# freed its slot or moved a magnitude would be a different ruling built under
# this one's name.

func _s6_nothing_was_retuned() -> void:
	print("\n§6 — the tell moved no magnitude, no slot and no state")
	# **BATCH HC §1 — THE CLERIC'S SEAT, BECAUSE THE RUNE IS A CLERIC'S.** This
	# stood at the Warrior's seat with `spec = "occultist"` below, which reached
	# an Occultist rune only because the spec scope matched the LINEAGE and never
	# the class. The scope is the class now, so the rune is dressed on the class
	# it belongs to and the paired positive asks the question it always asked.
	var seat := SEATS.find("cleric")
	_seat_party()
	var rid := ""
	for g in _gated:
		if Runes.engine_read(g) == "old_gods":
			rid = g
			break
	ok(rid != "", "§6: no Occultist rune found")
	if rid == "":
		return
	for engine_in in [true, false]:
		_dress(seat, rid, engine_in)
		var m: Dictionary = _run.party[seat]
		var arm := "engine in" if engine_in else "engine out"
		# THE RUNE IS STILL EQUIPPED AND STILL FILLS ITS SLOT.
		ok(bool((m["runes"][0] as Dictionary).get("equipped", false)),
			"§6 (%s): the rune was unequipped" % arm)
		var worn := 0
		for r in m.get("runes", []):
			if bool((r as Dictionary).get("equipped", false)):
				worn += 1
		ok(worn == 1, "§6 (%s): %d runes worn — the slot did not stay filled" % [arm, worn])
		# ITS PAYLOAD IS STILL APPLIED — the refusal is inside the read site,
		# where GV put it, and this batch did not move it to the spawn.
		var cfg := {"unit_name": "probe", "max_hp": 100, "attack": 100}
		Talents.apply_payload(cfg, (m["runes"][0] as Dictionary)["payload"], 1,
			{"learned": {}, "member": m})
		var fields: Array = []
		for k in cfg:
			if String(k).begins_with("rune_"):
				fields.append(String(k))
		ok(not fields.is_empty(),
			"§6 (%s): the rune's payload wrote no `rune_` field — the spawn stopped applying it" % arm)
		# AND ITS AUTHORED TERMS ARE BYTE-UNCHANGED.
		var e: Dictionary = Runes.config(rid)
		var built: Dictionary = Runes.build(rid)
		ok(int(built["price"]) == int(e["price"]) and String(built["desc"]) == String(e["desc"]),
			"§6 (%s): %s's price or text moved" % [arm, rid])
	# THE OFFER'S OWN DOORS ARE UNTOUCHED: a gated rune is still unofferable with
	# the engine out and offerable with it in, which is GV's gate, not GX's.
	var pid := Runes.engine_read(rid)
	ok(not Runes.offerable(rid, []) and Runes.offerable(rid, [pid]),
		"§6: GV's offer gate reads differently under GX")
	# THE PEDDLER AND THE CACHE NEED NO TELL AND GOT NONE — a gated rune cannot
	# be OFFERED while the engine is out, so a tell there could never render.
	# Asserted through the doors themselves rather than by reading the screens.
	_dress(seat, rid, false)
	var m2: Dictionary = _run.party[seat]
	var elig: Array = Runes.eligible_ids(m2, Runes.owned_names(m2))
	var leaked: Array = []
	for g2 in _gated:
		if elig.has(g2):
			leaked.append(g2)
	ok(leaked.is_empty(),
		"§6: the offer pool hands %d gated runes to a hero with no engine slotted (%s)" % [
			leaked.size(), str(leaked.slice(0, 3))])
	# PAIRED POSITIVE: with the engine in, its own runes ARE in the pool, so the
	# emptiness above is the gate and not an empty pool.
	_dress(seat, rid, true)
	var m3: Dictionary = _run.party[seat]
	m3["spec"] = "occultist"
	var elig2: Array = Runes.eligible_ids(m3, Runes.owned_names(m3))
	var back := 0
	for g3 in _gated:
		if elig2.has(g3):
			back += 1
	ok(back > 0, "§6: with the engine slotted no gated rune is offerable either — the arm proves nothing")
	print("    the rune stays worn, its slot stays filled, its payload still applies, and GV's offer gate is unmoved")
	print("    the offer pool holds %d gated runes with the engine out and %d with it in" % [leaked.size(), back])


# ── §7 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§7: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§7: %s is byte for byte what it was" % p)
