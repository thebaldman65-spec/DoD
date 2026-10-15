# BATCH IA — THE THIRD CORE SLOT, AND THE BAG.
#
#   §1  THE REFLECT PAYS WHAT LANDED (HZ's ruling 6, fixed). On a real battle, a Devout's Consecrated Ground
#       under a raider's blow, Lifewell seated through the spawn (the retired Burning Censer, which a saved run
#       still wears): with his Vow of Silence the log prints no reflect and Lifewell waters nobody; with the vow
#       off the log's figure is the raider's loss and Lifewell pays a fifth of it. The frame is the raider's after.
#   §2  THE THIRD CORE SLOT. The cap is three and read by name; three core runes slot through the panel's own
#       Equip and a fourth is refused with its sentence, the Swap drawn in its place. A save holding two
#       slotted opens with three slots, the third empty and usable; no slot count rides the save. A core rune
#       slotted mid-run changes one flag on the map and its engine and enabler arrive at the next spawn;
#       unslotted, they leave the next one. HL §1a's door at the event verb: a core rune its fallback hands over
#       is held, not slotted, and the line says so; an ordinary one is still worn.
#   §3  THE HERO'S PANEL IN THREE SECTIONS — CORE (every slot drawn), WORN, HELD, NOT WORN — in that order,
#       separated, with no state printed on a row. Negative arms: a hero holding nothing (three empty slots, two
#       empty sections, each legible); the holding cap (more than fit: it scrolls under GT §1, Close pinned);
#       a rune moved between sections by Equip, Unequip and Swap, the panel re-read each time. The crest's bag
#       is untouched, the nameplate's marker survives, the panel counts what he holds once, and the kit
#       preview stays one flat list with its state column.
#   §4  THE PLAYER'S WORD IS CORE — the hero sheet's state column and the kit preview say CORE, never ENGINE.
#   §5  ONE STALE CLAIM — the instrument rules' shared-walk sentence points at `check_dm` §1 and carries no
#       number; the sharing it describes still stands.
#   §6  THE MAP CARD'S CORE LINE WRAPS — three titles, the widest set, inside the card.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** The other half of the save — a save this build writes, opened by
# an older one — cannot be driven from inside this build; the report drives it in a copy of HEAD. Whether a
# panel that scrolls should page (HU §1) is a ruling, not a reading: §3d prints the figure and asserts GT §1's
# shape. `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ia.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ia_profile.json"
const SCRATCH_RELICS := "user://ia_relics.json"
const SCRATCH_SAVE := "user://ia_scratch_save.bin"
const SPECS := ["warden", "pyromancer", "inquisitor", "mystic"]
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261011
const HN_LINE := "No core rune held. Core runes are found in play, alongside the others."
# BATCH IB §0.3 (ruled): *— empty —*, the map card's word — a row does not repeat its
# section's head, which already says CORE and counts the slots.
const EMPTY_SLOT := "— empty —"
const FULL := "Every core slot is filled."

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IA — THE THIRD CORE SLOT, AND THE BAG")
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
	await _s1_the_reflect()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Engine.time_scale = 1.0
	await _s2_the_third_slot()
	await _s3_the_panel()
	await _s4_the_word()
	_s5_the_claim()
	await _s6_the_card_line()
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


func _board(specs: Array, over: Dictionary) -> Node:
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


func _melee(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not (e as BattleUnit).dead and not (e as BattleUnit).is_ranged:
			return e
	return null


func _ability(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


func _line_with(text: String, needle: String) -> String:
	for line in text.split("\n"):
		if String(line).contains(needle):
			return String(line).strip_edges()
	return ""


func _frame(scene: Node) -> Array:
	var src = scene.get("_dmg_src")
	var who: Variant = src if src != null and is_instance_valid(src) else null
	return [who, String(scene.get("_dmg_label")), String(scene.get("_dmg_src_name"))]


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


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	return current_scene


# A class's six core runes as ids, in the class's own order.
func _six(key: String) -> Array:
	return Classes.class_engines(key).map(func(p): return Runes.engine_rune_id(String(p)))


# The live ordinary runes of a class, longest text first (the worst case a panel draws).
func _ordinary(key: String) -> Array:
	var ids: Array = []
	for id in Runes.ids():
		var c: Dictionary = Runes.config(String(id))
		if String(c.get("retired", "")) == "" and String(c.get("scope", "")) == "class:%s" % key \
				and String(c.get("engine", "")) == "":
			ids.append(String(id))
	ids.sort_custom(func(a, b): return Runes.shown_desc(Runes.build(a)).length() \
		> Runes.shown_desc(Runes.build(b)).length())
	return ids


func _built(ids: Array, worn: int) -> Array:
	var out: Array = []
	for k in ids.size():
		var r: Dictionary = Runes.build(String(ids[k]))
		r["equipped"] = k < worn
		out.append(r)
	return out


func _row_index(rows: Array, worn: bool) -> int:
	for i in rows.size():
		if bool(rows[i]["worn"]) == worn:
			return i
	return -1


func _row_of(rows: Array, id: String) -> int:
	for i in rows.size():
		if String((rows[i]["rune"] as Dictionary).get("id", "")) == id:
			return i
	return -1


func _open_panel(mp: Node, idx: int) -> Node:
	mp.set("_rune_panel_for", -1)
	for c in mp.get_children():
		if c is Control and (c as Control).z_index == 60 and not c.is_queued_for_deletion():
			c.queue_free()
	await Gate.frames(self, 1)
	mp.call("_open_rune_panel", idx)
	await Gate.frames(self, 2)
	return Gate.overlay(current_scene, 60)


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


# THE PANEL'S LIST, READ IN ORDER: a label is its text, a separator `<sep>`, a row
# `row:` and its label's text. What a section holds is read off this, never off the
# run's own lists — so the panel is what is asserted, not the door asked about itself.
func _sequence(ov: Node) -> Array:
	var out: Array = []
	var sc := _scroller(ov)
	if sc == null or sc.get_child_count() != 1:
		return out
	for c in (sc.get_child(0) as Node).get_children():
		if c is HSeparator:
			out.append("<sep>")
		elif c is Label:
			out.append(String((c as Label).text))
		elif c is HBoxContainer:
			var t := ""
			for k in c.get_children():
				if k is Label:
					t = String((k as Label).text)
			out.append("row:" + t)
	return out


# The rows between a section's head and the next separator (or the end), as rune names.
func _section_rows(seq: Array, head_prefix: String) -> Array:
	var out: Array = []
	var inside := false
	for e in seq:
		var s := String(e)
		if s.begins_with(head_prefix):
			inside = true
			continue
		if inside and s == "<sep>":
			break
		if inside and s.begins_with("row:"):
			out.append(s.substr(4).get_slice(" — ", 0))
	return out


func _head(seq: Array, prefix: String) -> String:
	for e in seq:
		if String(e).begins_with(prefix):
			return String(e)
	return ""


func _names(runes: Array) -> Array:
	return runes.map(func(r): return String((r as Dictionary).get("name", "")))


func _offerable_now() -> Array:
	var out: Array = []
	var held: Array = _run.party_rune_names()
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


# PARK every rune the party could be offered but `keep` on the waiting list, which
# `Run.party_rune_names` reads as held — so a real roll has `keep` left (`check_ho`'s
# dressing of the pool; the roll is the game's).
func _park_all_but(keep: Array) -> void:
	for id in _offerable_now():
		if not keep.has(String(id)):
			_run.pending_rune_drops.append(Runes.build(String(id)))


# ── §1 — THE REFLECT PAYS WHAT LANDED ──────────────────────────────────────

func _s1_the_reflect() -> void:
	print("\n§1 — the reflect's log line and Lifewell read the reflect that landed")
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var worn: Array = [_rune("burning_censer")]
		if vowed:
			worn.append(_rune("vow_of_silence"))
		seed(SEED)
		var s: Node = await _board(SPECS, {2: {"runes": worn}})
		var w := _hero(s, "warrior")
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if [w, c, foe].any(func(x): return x == null):
			ok(false, "§1 (%s): the board seats a Warden, a Devout and a raider" % tag)
			await _clear(s)
			continue
		# THE PREMISE, SEATED THROUGH THE SPAWN: the Censer's payload on the Devout, the vow's
		# as the arm says, and Conviction — the engine the ground's Devout is found by.
		ok(int(c.rune_lifewell_ranks) == 20 and int(c.rune_righteous_step) == 10,
			"§1 (%s): the Devout wears no Lifewell — the Censer's payload did not land at the spawn (%d, %d)" % [
				tag, int(c.rune_lifewell_ranks), int(c.rune_righteous_step)])
		ok((float(c.rune_vow_of_silence) > 0.0) == vowed,
			"§1 (%s): the Devout's vow is %s" % [tag, str(c.rune_vow_of_silence)])
		ok(c.has_engine("conviction"), "§1 (%s): the Devout does not hold Conviction" % tag)
		s._apply_status(w, "cons_ground", 3, 0, 0, c)
		ok(w.has_status("cons_ground"), "§1 (%s): the Devout's ground did not land on the Warden" % tag)
		var others: Array = []
		var before := {}
		for h in s.get("heroes"):
			if h != w and not (h as BattleUnit).is_companion:
				h.hp = maxi(int(h.max_hp / 2), 1)
				others.append(h)
				before[h] = int(h.hp)
		foe.hp = foe.max_hp
		var f0: int = foe.hp
		var log0 := _log_text(s).length()
		await s._resolve(foe, foe.abilities[0], w, "good")
		var landed: int = f0 - foe.hp
		var tail := _log_text(s).substr(log0)
		var line := _line_with(tail, "Consecrated Ground reflects")
		var well_line := _line_with(tail, "Lifewell")
		var healed := 0
		for h in others:
			if int(h.hp) > int(before[h]):
				healed += 1
		if vowed:
			ok(landed == 0, "§1 (vowed): the raider lost %d — the vowed Devout's own ground reflected" % landed)
			ok(line == "", "§1 (vowed): the log prints a reflect that never landed: '%s'" % line)
			ok(well_line == "" and healed == 0,
				"§1 (vowed): Lifewell watered %d heroes off a reflect the vow silenced ('%s')" % [healed, well_line])
		else:
			var want := maxi(int(round(landed * 0.01 * 20)), 1)
			ok(landed > 0, "§1 (no vow): the ground reflected nothing")
			ok(line.contains("reflects %d to %s" % [landed, foe.unit_name]),
				"§1 (no vow): the log's reflect is not the %d that landed: '%s'" % [landed, line])
			ok(well_line.contains("mends the heroes for %d" % want) and healed == others.size(),
				"§1 (no vow): Lifewell did not pay %d to the %d wounded heroes on the %d that landed ('%s', %d healed)" % [
					want, others.size(), landed, well_line, healed])
		ok(_frame(s)[0] == foe, "§1 (%s): after the reflect the frame is not the raider's own" % tag)
		print("  %-7s the raider lost %d; log: '%s'; Lifewell: '%s' (%d healed)" % [tag, landed, line, well_line, healed])
		await _clear(s)


# ── §2 — THE THIRD CORE SLOT ────────────────────────────────────────────────

func _s2_the_third_slot() -> void:
	print("\n§2 — three core slots: the cap, the save both ways, a swap mid-run, and nothing slotted on arrival")
	var cap := int(_run.ENGINE_SLOTS)
	ok(cap == 3, "§2a: `Run.ENGINE_SLOTS` is %d — the designer ruled three" % cap)
	# (a) THREE THROUGH THE PANEL'S OWN EQUIP, AND A FOURTH REFUSED.
	_new_run()
	var w: Dictionary = _run.party[0]
	var six := _six("warrior")
	for k in range(1, six.size()):
		var r: Dictionary = Runes.build(String(six[k]))
		r["equipped"] = false
		_run.hold_rune(w, r)
	ok(_run.engines_worn(w) == 1 and (w.get("engines", []) as Array).size() == 6,
		"§2a: the Warrior should hold his six core runes, one slotted (%d slotted of %d)" % [
			_run.engines_worn(w), (w.get("engines", []) as Array).size()])
	var mp := await _to_map()
	for k2 in 2:
		var ov: Node = await _open_panel(mp, 0)
		var hi := _row_index(_run.engine_rows(w), false)
		var eq: Button = Gate.bound_button(ov, "_toggle_engine", [0, hi, ov]) if ov != null else null
		ok(eq != null and eq.text == "Equip", "§2a: core rune %d drew no Equip with a slot free" % (k2 + 2))
		if eq != null:
			eq.emit_signal("pressed")
		await Gate.frames(self, 2)
		mp = current_scene
	ok(_run.engines_worn(w) == 3, "§2a: two Equips on the panel left %d core runes slotted, not 3" % _run.engines_worn(w))
	var ov4: Node = await _open_panel(mp, 0)
	var h4 := _row_index(_run.engine_rows(w), false)
	var sw: Button = Gate.bound_button(ov4, "_open_swap_chooser", [0, "engines", h4, ov4]) if ov4 != null else null
	ok(String(_run.engine_toggle_refusal(w, h4)) == FULL and not _run.toggle_engine(w, h4),
		"§2a: a fourth core rune was not refused with '%s' (%s)" % [FULL, _run.engine_toggle_refusal(w, h4)])
	ok(sw != null and sw.text == "Swap" and String(sw.tooltip_text).begins_with(FULL),
		"§2a: with every core slot full, a held core rune drew no Swap saying so")
	ok(ov4 != null and _head(_sequence(ov4), "CORE — ") == "CORE — 3 of 3 slots",
		"§2a: the panel's core head reads '%s'" % (_head(_sequence(ov4), "CORE — ") if ov4 != null else "<none>"))
	# (b) THE SAVE: two slotted, written by the run's own door, opens with three slots.
	var keep_path: String = _run.save_path
	_run.save_path = SCRATCH_SAVE
	_remove(SCRATCH_SAVE)
	_new_run()
	_run.party[0]["engines"] = _built(six, 2)
	_run.save_run()
	var d: Dictionary = {}
	if FileAccess.file_exists(SCRATCH_SAVE):
		var fr := FileAccess.open(SCRATCH_SAVE, FileAccess.READ)
		var v: Variant = fr.get_var(true)
		if v is Dictionary:
			d = v
	ok(not d.is_empty(), "§2b: the run's own save door wrote nothing to the scratch save")
	var keys_seen: Array = []
	_keys_deep(d, keys_seen)
	var slotty: Array = keys_seen.filter(func(k): return String(k).to_lower().contains("slot") \
		and (String(k).to_lower().contains("engine") or String(k).to_lower().contains("core")))
	ok(slotty.is_empty(), "§2b: the save carries a core-slot count %s — a slot count in a save owes a version" % [slotty])
	# `new_run` clears the save, so the run is emptied by hand and read back (`check_hr` §1e's shape).
	_run.party = []
	var loaded: bool = _run.load_run()
	var w2: Dictionary = _run.party[0] if loaded else {}
	ok(loaded and _run.engines_worn(w2) == 2 and (w2.get("engines", []) as Array).size() == 6,
		"§2b: the save did not open with two of six slotted (loaded %s)" % loaded)
	if loaded:
		var mp2 := await _to_map()
		var ovs: Node = await _open_panel(mp2, 0)
		var seq := _sequence(ovs)
		ok(_head(seq, "CORE — ") == "CORE — 2 of 3 slots" and seq.count(EMPTY_SLOT) == 1,
			"§2b: the loaded save's panel reads '%s' with %d empty core slots — three slots, the third empty" % [
				_head(seq, "CORE — "), seq.count(EMPTY_SLOT)])
		var hs := _row_index(_run.engine_rows(w2), false)
		var eqs: Button = Gate.bound_button(ovs, "_toggle_engine", [0, hs, ovs]) if ovs != null else null
		ok(eqs != null and eqs.text == "Equip", "§2b: the loaded save's third slot takes no Equip")
		if eqs != null:
			eqs.emit_signal("pressed")
			await Gate.frames(self, 2)
		ok(_run.engines_worn(w2) == 3, "§2b: the third slot of a loaded save did not fill (%d)" % _run.engines_worn(w2))
	_run.save_path = keep_path
	_remove(SCRATCH_SAVE)
	await _s2c_the_swap_mid_run()
	_s2d_the_event_door()


func _keys_deep(v: Variant, out: Array) -> void:
	if v is Dictionary:
		for k in (v as Dictionary):
			out.append(k)
			_keys_deep((v as Dictionary)[k], out)
	elif v is Array:
		for e in (v as Array):
			_keys_deep(e, out)


# (c) A SWAP MID-RUN — one flag on the map, the engine and its card at the spawn.
func _s2c_the_swap_mid_run() -> void:
	_new_run()
	var w: Dictionary = _run.party[0]
	var bz := Runes.engine_rune_id("bloodrage")
	var st := Runes.engine_rune_id("seasoned")
	ok(_run.held_engines(w) == ["bloodrage"], "§2c: the Warrior was not awakened on the Berserker's rune (%s)" % [_run.held_engines(w)])
	var held_st: Dictionary = Runes.build(st)
	held_st["equipped"] = false
	_run.hold_rune(w, held_st)
	var mp := await _to_map()
	var before: Dictionary = w.duplicate(true)
	var ov: Node = await _open_panel(mp, 0)
	var si := _row_of(_run.engine_rows(w), st)
	var eq: Button = Gate.bound_button(ov, "_toggle_engine", [0, si, ov]) if ov != null else null
	ok(eq != null and eq.text == "Equip", "§2c: the Stances' rune drew no Equip")
	if eq != null:
		eq.emit_signal("pressed")
		await Gate.frames(self, 2)
	# SLOT TIME WRITES ONE FLAG: put it back by hand and the member is what it was.
	var after: Dictionary = w.duplicate(true)
	var changed := false
	for r in after.get("engines", []):
		if String((r as Dictionary).get("id", "")) == st:
			changed = bool((r as Dictionary).get("equipped", false))
			(r as Dictionary)["equipped"] = false
	ok(changed and after == before, "§2c: slotting a core rune on the map wrote more than its own `equipped` flag")
	# THE SPAWN READS IT — the run's own battle.
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]})
	await Gate.frames(self, 90)
	var b: Node = current_scene
	var wu := _hero(b, "warrior") if Gate.scene_name(self) == "Battle" else null
	ok(wu != null and wu.has_engine("seasoned") and wu.has_engine("bloodrage")
			and _ability(wu, "Guard Change") != null and _ability(wu, "Bloodlust") != null,
		"§2c: the next fight did not seat both slotted engines and both enablers")
	# UNSLOT ONE, AND THE NEXT FIGHT LACKS IT.
	mp = await _to_map()
	var ov2: Node = await _open_panel(mp, 0)
	var bi := _row_of(_run.engine_rows(w), bz)
	var un: Button = Gate.bound_button(ov2, "_toggle_engine", [0, bi, ov2]) if ov2 != null else null
	ok(un != null and un.text == "Unequip", "§2c: the Berserker's slotted rune drew no Unequip")
	if un != null:
		un.emit_signal("pressed")
		await Gate.frames(self, 2)
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]})
	await Gate.frames(self, 90)
	var wu2 := _hero(current_scene, "warrior") if Gate.scene_name(self) == "Battle" else null
	ok(wu2 != null and wu2.has_engine("seasoned") and not wu2.has_engine("bloodrage")
			and _ability(wu2, "Guard Change") != null and _ability(wu2, "Bloodlust") == null,
		"§2c: the fight after the unslot still seats the Berserker's engine or its card")
	print("  a swap mid-run: slotted on the map (one flag), seated at the spawn; unslotted, gone from the next")
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)


# (d) HL §1a's DOOR AT THE EVENT VERB.
func _s2d_the_event_door() -> void:
	_new_run()
	var w: Dictionary = _run.party[0]
	var core := Runes.engine_rune_id(String(Classes.class_engines("warrior")[1]))
	_park_all_but([core])
	var line: String = Events.apply(_run, {"effect": "rune_grant", "amount": 1})
	_run.pending_rune_drops = []
	var got: Dictionary = {}
	for r in w.get("engines", []):
		if String((r as Dictionary).get("id", "")) == core:
			got = r
	ok(not got.is_empty(), "§2d: the event's grant did not hand the Warrior the core rune left to it ('%s')" % line)
	ok(not got.is_empty() and not bool(got.get("equipped", true)) and _run.engines_worn(w) == 1,
		"§2d: the event slotted the core rune it handed over — one choice handing over two things")
	ok(line.contains("held, not worn"), "§2d: the event's line does not say the core rune is held: '%s'" % line)
	# THE POSITIVE ARM: an ordinary rune the verb hands over with a slot free is still worn.
	_new_run()
	var w2: Dictionary = _run.party[0]
	var ord: String = _ordinary("warrior")[0]
	_park_all_but([ord])
	var line2: String = Events.apply(_run, {"effect": "rune_grant", "amount": 1})
	_run.pending_rune_drops = []
	var worn2 := false
	for r2 in w2.get("runes", []):
		if String((r2 as Dictionary).get("id", "")) == ord and bool((r2 as Dictionary).get("equipped", false)):
			worn2 = true
	ok(worn2 and not line2.contains("held, not worn"),
		"§2d: an ordinary rune the event handed over with a slot free was not worn ('%s')" % line2)
	print("  the event door: a core rune held ('%s'); an ordinary one worn ('%s')" % [line, line2])


# ── §3 — THE HERO'S PANEL IN THREE SECTIONS ────────────────────────────────

func _s3_the_panel() -> void:
	print("\n§3 — the hero's panel: CORE, WORN, HELD, NOT WORN, separated, no state on a row")
	# (a) A HERO HOLDING NOTHING.
	_new_run()
	var hn: Dictionary = _run.party[3]
	hn["engines"] = []
	hn["runes"] = []
	var mp := await _to_map()
	var ov: Node = await _open_panel(mp, 3)
	var seq := _sequence(ov)
	var want_bare := ["CORE — 0 of %d slots" % int(_run.ENGINE_SLOTS), EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, HN_LINE, "<sep>",
		"WORN — 0 of %d slots" % int(_run.rune_slots()), "No rune worn.", "<sep>",
		"HELD, NOT WORN — 0 of %d" % int(_run.HERO_HOLD_CAP), "A rune taken off stays with him; Drop lets one go for good.",
		"Nothing held. A rune drops after every fight, and the Peddler sells them."]
	ok(seq == want_bare, "§3a: a hero holding nothing draws %s" % [seq])
	var why := _illegible(ov)
	ok(why == "", "§3a: a label of the bare panel is not legible — %s" % why)
	ok(_close_outside_scroller(ov), "§3a: the bare panel's Close is inside the scroller, where text can carry it off")
	ok(_close_on_screen(ov), "§3a: the bare panel's Close is not wholly on the 1280 x 720 screen")
	# (b) EVERY KIND, EACH IN ITS SECTION, NO STATE ON A ROW.
	_new_run()
	var m: Dictionary = _run.party[1]
	var six := _six("mage")
	var ords := _ordinary("mage")
	m["engines"] = _built(six.slice(0, 4), 2)
	m["runes"] = _built(ords.slice(0, 4), 2)
	mp = await _to_map()
	ov = await _open_panel(mp, 1)
	seq = _sequence(ov)
	var core_n: Array = _names(m["engines"]).slice(0, 2)
	var worn_n: Array = _names(m["runes"]).slice(0, 2)
	var held_n: Array = _names(m["engines"]).slice(2, 4) + _names(m["runes"]).slice(2, 4)
	ok(_section_rows(seq, "CORE — ") == core_n, "§3b: CORE holds %s, not the slotted %s" % [_section_rows(seq, "CORE — "), core_n])
	ok(_section_rows(seq, "WORN — ") == worn_n, "§3b: WORN holds %s, not the worn %s" % [_section_rows(seq, "WORN — "), worn_n])
	ok(_section_rows(seq, "HELD, NOT WORN — ") == held_n,
		"§3b: HELD, NOT WORN holds %s, not %s (core runes first)" % [_section_rows(seq, "HELD, NOT WORN — "), held_n])
	var heads: Array = []
	for e in seq:
		if String(e).begins_with("CORE — ") or String(e).begins_with("WORN — ") or String(e).begins_with("HELD, NOT WORN — "):
			heads.append(String(e).get_slice(" — ", 0))
	ok(heads == ["CORE", "WORN", "HELD, NOT WORN"] and seq.count("<sep>") == 2,
		"§3b: the sections read %s with %d separators — the designer's order, each separated" % [heads, seq.count("<sep>")])
	ok(seq.count(EMPTY_SLOT) == int(_run.ENGINE_SLOTS) - 2, "§3b: two slotted of three drew %d empty core slots" % seq.count(EMPTY_SLOT))
	var marked: Array = seq.filter(func(e): return String(e).begins_with("row:") and (String(e).substr(4).begins_with("✦")
		or String(e).ends_with("(held)")))
	ok(marked.is_empty(), "§3b: a row prints its state beside the section that says it: %s" % [marked])
	ok(not Gate.has_text(ov, "HELD, NOT WORN: "), "§3b: HR's count line stands beside the section that counts — two counts of one thing")
	ok(_head(seq, "HELD, NOT WORN — ") == "HELD, NOT WORN — %d of %d" % [_run.held_count(m), int(_run.HERO_HOLD_CAP)],
		"§3b: the held section's head reads '%s'" % _head(seq, "HELD, NOT WORN — "))
	# (c) A RUNE MOVED BETWEEN SECTIONS — Equip, Unequip, Swap — AND THE PANEL RE-READ EACH TIME.
	var o3 := String(m["runes"][2]["name"])
	var i3 := _row_of(_run.rune_rows(m), String(m["runes"][2]["id"]))
	var eq: Button = Gate.bound_button(ov, "_toggle_rune", [1, i3, ov]) if ov != null else null
	ok(eq != null and eq.text == "Equip", "§3c: the held %s drew no Equip" % o3)
	if eq != null:
		eq.emit_signal("pressed")
		await Gate.frames(self, 2)
	ov = Gate.overlay(current_scene, 60)
	seq = _sequence(ov)
	ok(_section_rows(seq, "WORN — ").has(o3) and not _section_rows(seq, "HELD, NOT WORN — ").has(o3)
			and _head(seq, "WORN — ") == "WORN — 3 of 3 slots",
		"§3c: after Equip the re-read panel does not show %s under WORN (%s)" % [o3, seq])
	var c1 := String(m["engines"][0]["name"])
	var ci := _row_of(_run.engine_rows(m), String(m["engines"][0]["id"]))
	var un: Button = Gate.bound_button(ov, "_toggle_engine", [1, ci, ov]) if ov != null else null
	ok(un != null and un.text == "Unequip", "§3c: the slotted %s drew no Unequip" % c1)
	if un != null:
		un.emit_signal("pressed")
		await Gate.frames(self, 2)
	ov = Gate.overlay(current_scene, 60)
	seq = _sequence(ov)
	ok(_section_rows(seq, "HELD, NOT WORN — ").has(c1) and not _section_rows(seq, "CORE — ").has(c1)
			and seq.count(EMPTY_SLOT) == 2,
		"§3c: after Unequip the re-read panel does not show %s under HELD, NOT WORN with two empty slots" % c1)
	var o4 := String(m["runes"][3]["name"])
	var i4 := _row_of(_run.rune_rows(m), String(m["runes"][3]["id"]))
	var swb: Button = Gate.bound_button(ov, "_open_swap_chooser", [1, "runes", i4, ov]) if ov != null else null
	ok(swb != null and swb.text == "Swap", "§3c: with every rune slot full the held %s drew no Swap" % o4)
	var out_n := String(m["runes"][0]["name"])
	if swb != null:
		swb.emit_signal("pressed")
		await Gate.frames(self, 1)
		var ch: Node = Gate.overlay(current_scene, 80)
		var took := Gate.press(ch, [out_n]) if ch != null else ""
		ok(took != "", "§3c: the swap chooser offered no %s to swap out" % out_n)
		await Gate.frames(self, 2)
	ov = Gate.overlay(current_scene, 60)
	seq = _sequence(ov)
	ok(_section_rows(seq, "WORN — ").has(o4) and _section_rows(seq, "HELD, NOT WORN — ").has(out_n)
			and not _section_rows(seq, "WORN — ").has(out_n) and _head(seq, "WORN — ") == "WORN — 3 of 3 slots",
		"§3c: after the swap the re-read panel does not show %s worn and %s held" % [o4, out_n])
	# (d) MORE THAN FIT — THE HOLDING CAP: three slotted, three held core runes, three worn, five held.
	_new_run()
	var cm: Dictionary = _run.party[1]
	cm["engines"] = _built(six, 3)
	cm["runes"] = _built(ords.slice(0, 8), 3)
	ok(_run.held_count(cm) == int(_run.HERO_HOLD_CAP), "§3d: the Mage holds %d unworn, not the cap" % _run.held_count(cm))
	mp = await _to_map()
	ov = await _open_panel(mp, 1)
	seq = _sequence(ov)
	var rows_n: int = seq.filter(func(e): return String(e).begins_with("row:")).size()
	var sc := _scroller(ov)
	var content: float = (sc.get_child(0) as Control).get_combined_minimum_size().y if sc != null else 0.0
	ok(rows_n == 14, "§3d: the panel at the holding cap drew %d rune rows, not 14" % rows_n)
	ok(_close_outside_scroller(ov), "§3d: at the holding cap Close is inside the scroller — GT §1's pin")
	ok(_close_on_screen(ov), "§3d: at the holding cap Close is not wholly on the screen")
	print("    [record] at the holding cap the panel lists %d runes in %.0f px against a %.0f px scroller — %s; HU §1's pager is the designer's call (GT §1 rules this panel's scroller)" % [
		rows_n, content, sc.size.y if sc != null else 0.0, "it scrolls" if sc != null and content > sc.size.y + 0.5 else "it fits"])
	# (e) THE CREST'S BAG IS UNTOUCHED, AND (f) THE NAMEPLATE'S MARKER SURVIVES.
	_run.bag_rune(Runes.build("tithe"))
	mp = await _to_map()
	var mk: Button = null
	var btns: Array = []
	Gate.buttons(mp, btns)
	for b in btns:
		if (b as Button).has_meta("held_marker") and int((b as Button).get_meta("held_marker")) == _run.held_count(cm):
			mk = b
	ok(mk != null and String(mk.text) == "✦ %d" % _run.held_count(cm), "§3f: the Mage's nameplate does not carry ✦ %d" % _run.held_count(cm))
	mp.call("_open_bag_panel")
	await Gate.frames(self, 2)
	var bp: Node = Gate.overlay(current_scene, 60)
	ok(bp != null and Gate.has_text(bp, "THE CREST — ") and Gate.has_text(bp, "Tithe"),
		"§3e: the crest's bag does not list the crest's rune under THE CREST")
	ok(bp != null and not Gate.has_text(bp, "CORE — ") and not Gate.has_text(bp, "WORN — ") and not Gate.has_text(bp, "HELD, NOT WORN"),
		"§3e: the crest's bag drew a hero's section head")
	if bp != null:
		bp.queue_free()
	mp.set("_bag_panel_open", false)
	await Gate.frames(self, 1)
	# (g) THE KIT PREVIEW STAYS FLAT, WITH ITS STATE COLUMN.
	var kp: Control = mp.call("_open_kit_preview", 1)
	await Gate.frames(self, 2)
	var kt := "\n".join(PackedStringArray(Gate.texts(kp))) if kp != null else ""
	ok(kp != null and kt.contains("RUNES") and kt.contains("CORE     ") and kt.contains("WORN     ") and kt.contains("held     ")
			and not kt.contains("CORE — ") and not kt.contains("HELD, NOT WORN"),
		"§3g: the kit preview is not one flat list with its state column")
	if kp != null:
		kp.queue_free()
	await Gate.frames(self, 1)


# The first label of the panel's list that a player could not read, and why — "" when every one can.
func _illegible(ov: Node) -> String:
	var sc := _scroller(ov)
	if sc == null:
		return "the panel has no scroller"
	for c in (sc.get_child(0) as Node).get_children():
		if c is Label:
			var l := c as Label
			var r := l.get_global_rect()
			if String(l.text).strip_edges() == "":
				return "an empty label"
			if not l.is_visible_in_tree():
				return "'%s' is hidden" % l.text
			if l.get_theme_font_size("font_size") < 12:
				return "'%s' is under 12 points" % l.text
			if r.position.x < 0.0 or r.end.x > 1280.0 or r.position.y < 0.0 or r.end.y > 720.0:
				return "'%s' is off the screen (%s)" % [l.text, str(r)]
	return ""


func _close(ov: Node) -> Button:
	if ov == null:
		return null
	var btns: Array = []
	Gate.buttons(ov, btns)
	for b in btns:
		if String((b as Button).text) == "Close":
			return b
	return null


func _close_outside_scroller(ov: Node) -> bool:
	var b := _close(ov)
	var n: Node = b
	while n != null and n != ov:
		if n is ScrollContainer:
			return false
		n = n.get_parent()
	return b != null


func _close_on_screen(ov: Node) -> bool:
	var b := _close(ov)
	if b == null:
		return false
	var r := b.get_global_rect()
	return r.position.y >= 0.0 and r.end.y <= 720.0 and r.position.x >= 0.0 and r.end.x <= 1280.0


# ── §4 — THE PLAYER'S WORD IS CORE ─────────────────────────────────────────

func _s4_the_word() -> void:
	print("\n§4 — the rune panel and the kit preview say CORE; the sheet carries no rune state at all (IH §3)")
	_new_run()
	_run.hero_screen_idx = 0
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	var sheet: Node = current_scene
	var core_state := 0
	var engine_word := 0
	for t in Gate.texts(sheet):
		if String(t) == "CORE":
			core_state += 1
		if String(t) == "ENGINE" or String(t).begins_with("ENGINE "):
			engine_word += 1
	# BATCH IH §3 — THE SHEET's RUNE BLOCK LEFT IT, state column and all: the negative half here, the
	# word's positive halves on the rune panel (CORE heads the core runes) and the kit preview below.
	ok(core_state == 0 and engine_word == 0,
		"§4: the sheet reads CORE %d time(s) and ENGINE %d — it carries no rune state since IH §3" % [core_state, engine_word])
	var mp := await _to_map()
	mp.call("_open_rune_panel", 0)
	await Gate.frames(self, 2)
	var rp: Node = Gate.overlay(mp, 60)
	var rpt: Array = Gate.texts(rp) if rp != null else []
	ok(rpt.filter(func(t): return String(t).begins_with("CORE — ")).size() == 1
			and not rpt.any(func(t): return String(t).contains("ENGINE")),
		"§4: the rune panel does not head its core runes CORE, once, with no ENGINE: %s" % [rpt.slice(0, 6)])
	if rp != null:
		rp.queue_free()
	mp.set("_rune_panel_for", -1)
	await Gate.frames(self, 1)
	var kp: Control = mp.call("_open_kit_preview", 0)
	await Gate.frames(self, 2)
	var kt := "\n".join(PackedStringArray(Gate.texts(kp))) if kp != null else ""
	var nm := String((_run.party[0]["engines"][0] as Dictionary).get("name", ""))
	ok(kt.contains("CORE     %s" % nm), "§4: the kit preview's row does not read 'CORE     %s'" % nm)
	ok(not kt.contains("ENGINE"), "§4: the kit preview still says ENGINE")
	if kp != null:
		kp.queue_free()
	await Gate.frames(self, 1)


# ── §5 — ONE STALE CLAIM, POINTED AT ITS INSTRUMENT ─────────────────────────

func _s5_the_claim() -> void:
	print("\n§5 — the shared-walk sentence points at its instrument and carries no number")
	var doc := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var at := doc.find("- **ANCHOR ON THE CLAUSE LINE AND SEARCH BACKWARD FOR THE WALK.**")
	var para := doc.substr(at, 900) if at >= 0 else ""
	var walk := "heroes.filter(func(he): return not he.dead and not he.is_companion)"
	ok(at >= 0 and para.contains(walk), "§5: the instrument rules lost the sentence about the shared walk")
	var cut := para.substr(0, para.find("Bulwark")) if para.contains("Bulwark") else para
	ok(cut.contains("`check_dm` §1") and cut.contains("live count"),
		"§5: the shared-walk sentence does not point at `check_dm` §1's live count")
	var re := RegEx.new()
	re.compile("(?i)\\b(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|[0-9]+) sites\\b")
	ok(re.search(cut) == null, "§5: the shared-walk sentence states a count of sites again: %s" % (re.search(cut).get_string() if re.search(cut) != null else ""))
	# THE CLAIM'S SUBJECT STILL STANDS: the walk is spelled at more than one site.
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(src.count(walk) > 1, "§5: the walk is spelled at %d site(s) — the hazard the sentence warns of is gone" % src.count(walk))
	print("  the walk is spelled at %d sites of `battle.gd` (check_dm §1 prints it every battery)" % src.count(walk))


# ── §6 — THE MAP CARD SAYS WHAT HE WEARS, INSIDE THE CARD (the core line until IH §2) ─────

func _s6_the_card_line() -> void:
	print("\n§6 — three core runes: counted on the card's Runes button, inside the card, and named on its panel")
	_new_run()
	var hi := 3
	var titles: Array = Classes.class_engines("hunter").map(func(p): return Classes.engine_title(String(p)))
	var font: Font = ThemeDB.fallback_font
	var best := []
	var best_w := 0.0
	for a in titles.size():
		for b in range(a + 1, titles.size()):
			for c in range(b + 1, titles.size()):
				var t := "core runes: %s + %s + %s — click the card for the sheet" % [titles[a], titles[b], titles[c]]
				var wd := font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, 11).x
				if wd > best_w:
					best_w = wd
					best = [a, b, c]
	var six := _six("hunter")
	var eng: Array = []
	for k in six.size():
		if best.has(k):
			eng.append(_rune(String(six[k])))
	_run.party[hi]["engines"] = eng
	var mp := await _to_map()
	# BATCH IH §2 — THE LINE IS GONE (the designer's), so the question IA asked of it — does the card
	# say what he wears, inside the card — is asked of the button that took its room: the widest set
	# of three core runes, counted on the Runes button inside its card and named on the panel it opens.
	var line: Label = null
	var btn: Button = null
	var stack: Array = [mp]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is Label and String((n as Label).text).begins_with("core runes:"):
			line = n
		if n is Button and (n as Button).has_meta("runes_button") and int((n as Button).get_meta("runes_button")) == hi:
			btn = n
		for k2 in n.get_children():
			stack.append(k2)
	ok(line == null, "§6: a card still draws the core-rune line: '%s'" % (line.text if line != null else ""))
	ok(btn != null and String(btn.text).ends_with("Runes 3/6"),
		"§6: the Hunter's card does not count three slotted core runes on its Runes button ('%s')" % (btn.text if btn != null else "none"))
	if btn == null:
		return
	var card := Rect2(Vector2(8.0, 84.0 + hi * 158.0), Vector2(300.0, 152.0))
	var r := btn.get_global_rect()
	ok(card.encloses(r) and btn.get_combined_minimum_size().x <= r.size.x + 0.5,
		"§6: the Runes button runs out of its card or its face out of the button (%s in %s, needs %.0f px)" % [
			str(r), str(card), btn.get_combined_minimum_size().x])
	btn.emit_signal("pressed")
	await Gate.frames(self, 2)
	var rp: Node = Gate.overlay(mp, 60)
	var named := 0
	var rpt := "\n".join(PackedStringArray(Gate.texts(rp))) if rp != null else ""
	for k3 in best:
		if rpt.contains(String(Runes.config(String(six[k3])).get("name", "?"))):
			named += 1
	ok(named == 3, "§6: the panel the button opens names %d of the three core runes" % named)
	print("  the widest three (%.0f px as the old line) are counted on the button (%s) and named on its panel" % [best_w, btn.text])


# ── §9 — THE PLAYER'S FILES ────────────────────────────────────────────────
func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
