# BATCH GT — THE POUCH TRAP, THREE CARDS AT THE BASELINE, AND A CARD THAT SITS OUT.
#
#   §0  THE PLAYER'S FILES, AS FOUND — and this process writes the harness save
#   §1  THE POUCH NEVER TRAPS THE PLAYER — every engine rune held alone, every pair
#       of one class's six, and each class's six held at once (two slotted, four
#       kept — in the bag since HK), each with the pouch empty and with an ordinary
#       rune beside them (his class's longest, in the bag): Close is on the screen,
#       at ONE place in every configuration, outside every scroller, and pressing it
#       closes the pouch; every rule is drawn whole, at its size, inside the
#       scroller; the text fits unscrolled; a toggle that re-opens the pouch puts
#       Close back where it was; and (HK) a full bag, all but one of it his own
#       class's runes, three more worn: the list scrolls, Close does not move, the
#       other class's rune is not listed, and the last row's
#       button can be scrolled wholly into view
#   §2  THE PEDDLER — four offers, three deals (every seat's longest ordinary rune,
#       his class's shortest engine rule, his class's longest): no offer overlaps
#       another, every Buy button is inside the one scroller and can be scrolled
#       wholly into view, the scroller ends above Leave, Leave is outside it and on
#       the screen, and every Buy pressed buys its own hero's rune — into the bag
#       since HK
#   §3  THE CARD THAT SITS OUT — the table against the door: every card a hero of
#       each class can earn, asked with NO engine on a dressed board, is refused
#       exactly when it is a row or one of the ten card-conditional cards; each of
#       those ten opens by its own card or board route with still no engine; every
#       row opens with its engine held; and the drive — taken through the draft
#       door or the boss pick's under the engine, the engine dropped through the
#       pouch's door: kept (in the bag since HK), still carried, its slot still counted, not seated, the
#       fight runs, the sheet and the Kit panel say why, the save carries it; the
#       engine slotted again: seated again
#   §4  THE BASELINE — Fireball and Frostbolt at Magic Missiles' cost, cooldown and
#       initiative, Aimed Shot at Powershot's, and nothing else of theirs moved
#   §5  THE PLAYER'S FILES, AS THEY WERE
#
# ── EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM ───────────────────────────────
# Close outside every scroller, beside every rule inside one; no Buy under Leave,
# beside every Buy reachable and pressed; a row refused bare, beside the same row
# opened by its engine; a card that sits out not on the bar, beside a card of the
# same class seated in the same fight and the row seated again once the engine
# is back; nothing of a retuned card moved, beside its cost and cooldown moved.
#
# ── WHY §3 CARRIES ITS OWN COPY OF THE TABLE ────────────────────────────────
# **WHICH CARDS SIT OUT IS A RULING'S POPULATION.** `check_gs` §0's reason: a table
# that moved with no line changing here would be a ruling nobody took, so the gate
# holds `RULED` and compares, and the census below re-derives it off the door.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gt.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const NO_LINEAGE := ["", "", "", ""]
const SCRATCH_PROFILE := "user://gt_profile.json"
const SCRATCH_RELICS := "user://gt_relics.json"

# THE SEVENTEEN, AND THE ENGINE EACH CANNOT BE CAST WITHOUT.
const RULED := {
	"Winter's Toll": "permafrost", "Rimebinding": "permafrost",
	"Cryoclasm": "permafrost", "Shatter": "permafrost",
	"Arcane Bolt": "resonance", "Unmaking": "resonance",
	"Death Ray": "resonance", "Stabilize": "resonance",
	"Divine Plea": "mercy", "Hymn of Hope": "mercy", "Resurrection": "mercy",
	"Blessing of the Faithful": "conviction", "Aegis Reversal": "conviction",
	"Transference": "old_gods", "Requiem": "old_gods",
	"Unleash": "pack", "Primal Surge": "pack",
}
# **BATCH HE §2 RULED A ROW THE DOOR NEVER REFUSES, AND BATCH HF §7 UNDID IT (the
# designer).** Mark of the Hunt half-works without Pack Bond (its companion's
# halves read no engine), so the census below can never find it; HE ruled it Pack
# Bond's, to sit out with it, and HF §7 took the ruling back on that half: it is
# offered to every Hunter with a pet and sits out only beside the engine that
# dismisses the pet (`Classes.COMPANION_READ`'s ruled `seat`, `check_hf` §5). **So
# it is held here as an UNDONE row, keyed to the engine HE named**: asserted to be
# a row of neither table, its premise kept — usable bare, which is why it is no
# row — and driven through Pack Bond's drive as a card that STAYS SEATED when the
# engine is dropped, on the bar and on both screens. The day the door refuses it
# bare, the census has found it, and whether it sits out is a question again.
const UNDONE_BY_DESIGNER := {"Mark of the Hunt": "pack"}
# THE TEN THE DOOR REFUSES BARE THAT ARE NOT ROWS, AND WHAT OPENS EACH WITH NO
# ENGINE: a drafted swap turns the guard Defensive (Precision Strike — **a drafted
# Guard Change until HL §1**, when it began travelling with the Stances and left
# every pool, so no Warrior without them can hold it); a heal landed first; an
# enemy under 20% health; a companion from an earned Call the Wilds.
const CARD_ROUTES := {
	"Battle Poise": "guard", "Counter Time": "guard", "Reprisal": "heal",
	"Execute": "low", "Kill Command": "companion", "Twin Hunt": "companion",
	"Savage Sweep": "companion", "Ghostpack": "companion",
	"Bestial Wrath": "companion", "Spirit Bond": "companion",
}
# A card of each row's class that is earned, carried and NOT a row — the arm
# that proves a fight which leaves the rows out still seats what it should.
const CONTROL := {"mage": "Arcane Cannon", "cleric": "Heal", "hunter": "Hunter's Instinct"}

# §4 — what each retuned card is priced against, and what GS shipped of it that
# GT did not move.
const BASELINE := {"Fireball": "Magic Missiles", "Frostbolt": "Magic Missiles",
	"Aimed Shot": "Powershot"}
const UNMOVED := {
	"Fireball": {"damage": 20, "pressure": 15, "delay": 2.0, "dmg_type": "fire",
		"status": "burn", "perfect_text": "Deals {atk:25}"},
	"Frostbolt": {"damage": 20, "pressure": 15, "delay": 2.0, "dmg_type": "frost",
		"status": "chilled", "perfect_text": "Deals {atk:25}"},
	"Aimed Shot": {"damage": 45, "pressure": 15, "delay": 3.0, "dmg_type": "physical",
		"status": "", "perfect_text": "+20 Focus"},
}

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GT — THE POUCH TRAP, THREE CARDS AT THE BASELINE, AND A CARD THAT SITS OUT")
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
	Engine.max_fps = 0
	await _s1_the_pouch()
	await _s2_the_peddler()
	await _s3_the_card_that_sits_out()
	_s4_the_baseline()
	_s5_the_players_files()
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


# The party every screen section draws: four heroes through class selection,
# no lineage, no engine, nothing earned.
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


func _six(key: String) -> Array:
	return Classes.class_engines(key).map(func(p): return Runes.engine_rune_id(String(p)))


func _rule_len(rid: String) -> int:
	return Runes.engine_text(String(Runes.config(rid)["engine"])).length()


# His class's live ordinary rune with the longest text — the population §2's
# "every seat's longest ordinary rune" is, read once for both sections.
func _longest_ordinary(key: String, skip: int = 0) -> String:
	var ids: Array = _class_ordinary(key)
	return String(ids[skip]) if ids.size() > skip else ""


# Every live ordinary rune of his class, longest text first.
func _class_ordinary(key: String) -> Array:
	var ids: Array = []
	for rid in Runes.ids():
		if Runes.is_engine_rune(String(rid)) or Runes.is_retired(String(rid)):
			continue
		if String(Runes.config(String(rid)).get("scope", "")) == "class:%s" % key:
			ids.append(String(rid))
	ids.sort_custom(func(a, b):
		var la := String(Runes.config(String(a)).get("desc", "")).length()
		var lb := String(Runes.config(String(b)).get("desc", "")).length()
		return la > lb or (la == lb and String(a) < String(b)))
	return ids


# **BATCH HK — THE SCROLLER THAT HOLDS THE BUY BUTTONS, NOT THE LAST ONE DRAWN.** The
# Peddler draws a second scroller since HK, the bag's sale rows under the supplies,
# after the rune column; HEAD's `for ch in shop.get_children()` kept the LAST
# ScrollContainer, so it measured the sale rows as the rune column: *"Buy N cannot
# be scrolled wholly into view"* twelve times (Godot's *"Must be an ancestor of the
# control"* under each), and the offers read *"37 px in a 156 px column"* — the empty
# bag's sentence. The rune column is the scroller the Buy buttons are inside.
func _scroll_holding(n: Node, prefix: String) -> ScrollContainer:
	var found: ScrollContainer = null
	for ch in n.get_children():
		if ch is ScrollContainer and not ch.is_queued_for_deletion() \
				and not _buttons_from(ch, prefix).is_empty():
			found = ch
	return found


func _bag_ids() -> Array:
	return _run.rune_bag.map(func(r): return String((r as Dictionary).get("id", "")))


# BATCH HR §1 — the engine runes a hero holds and has not slotted, by id: where an
# unslotted engine rune lives since the bag split.
func _hr_held_engine_ids(m: Dictionary) -> Array:
	var out: Array = []
	for r in m.get("engines", []):
		if not bool((r as Dictionary).get("equipped", false)):
			out.append(String((r as Dictionary).get("id", "")))
	return out


func _inside_scroll(n: Node) -> bool:
	var p: Node = n.get_parent()
	while p != null:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _first_scroll(n: Node) -> ScrollContainer:
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_front()
		if cur is ScrollContainer and not cur.is_queued_for_deletion():
			return cur
		for c in cur.get_children():
			stack.append(c)
	return null


func _button(n: Node, text: String) -> Button:
	var btns: Array = []
	Gate.buttons(n, btns)
	for b in btns:
		if String((b as Button).text) == text:
			return b
	return null


func _buttons_from(n: Node, prefix: String) -> Array:
	var btns: Array = []
	Gate.buttons(n, btns)
	return btns.filter(func(b): return String((b as Button).text).begins_with(prefix))


func _labels(n: Node, out: Array) -> void:
	if n == null or n.is_queued_for_deletion():
		return
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _label_with(n: Node, needle: String) -> Label:
	var ls: Array = []
	_labels(n, ls)
	for l in ls:
		if String((l as Label).text).contains(needle):
			return l
	return null


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and c.z_index == 60:
			c.queue_free()
	mp._rune_panel_for = -1
	mp._loadout_panel_for = -1


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 4:
		await process_frame


func _foes(s: Node) -> Array:
	return s.get("enemies").filter(func(e): return not e.dead)


# THE DRESSED BOARD, and it gives nothing an engine gives: every hero at half
# health with a bottomless bar and no cooldowns, every enemy at half health
# burning, chilled and poisoned. **No enemy is under 20% and none is Broken**, so
# Execute's own condition is a ROUTE below rather than a free pass here.
func _dress(s: Node, caster: BattleUnit) -> void:
	for e in _foes(s):
		e.max_hp = 100000
		e.hp = int(e.max_hp * 0.5)
		e.pressure = 30
		s._apply_status(e, "burn", 5, 12, 0, caster)
		s._apply_status(e, "chilled", 5, 0, 0, caster)
		s._apply_status(e, "poison", 5, 12, 0, caster)
	for h in s.get("heroes"):
		if h.is_companion:
			continue
		h.hp = maxi(int(h.max_hp * 0.5), 1)
		h.resource = 99999
		h.max_resource = 99999
		h.cooldowns.clear()


# The door, asked once standing and once with another hero fallen — the only
# thing Resurrection needs besides Mercy.
func _usable(s: Node, u: BattleUnit, ab: Ability) -> bool:
	u.cooldowns.clear()
	if bool(s._ability_usable(u, ab)):
		return true
	var fallen: BattleUnit = null
	for h in s.get("heroes"):
		if h != u and not h.is_companion and not h.dead:
			fallen = h
			break
	if fallen == null:
		return false
	fallen.dead = true
	var back := bool(s._ability_usable(u, ab))
	fallen.dead = false
	return back


func _bare_board() -> Node:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	return await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})


# ── §1 — THE POUCH NEVER TRAPS THE PLAYER ───────────────────────────────────

func _s1_the_pouch() -> void:
	print("\n§1 — the pouch: Close is on the screen, in one place, whatever it holds")
	_seat_party()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 10)
	var mp: Node = current_scene
	ok(Gate.scene_name(self) == "Map", "§1: the map is not on screen (%s)" % Gate.scene_name(self))
	if Gate.scene_name(self) != "Map":
		return
	var configs: Array = []
	for key in SEATS:
		var six := _six(key)
		for a in six:
			configs.append(["%s alone" % a, key, [a], "alone"])
		for i in six.size():
			for j in range(i + 1, six.size()):
				configs.append(["%s + %s" % [six[i], six[j]], key, [six[i], six[j]], "pair"])
		configs.append(["the %s's six" % key, key, six, "six"])
	ok(configs.size() == 88, "§1: %d configurations — 24 alone, 60 pairs and 4 sixes expected" % configs.size())
	var pinned := Rect2()
	var have_pin := false
	var seen := 0
	var closed := 0
	var sat_rows := 0
	var scrolled: Array = []
	var worst := {"alone": ["", 0, 0], "pair": ["", 0, 0], "six": ["", 0, 0]}
	var scroll_h := 0
	# **BATCH HK — THE SAME RUNES TO HAND, HELD WHERE THE GAME HOLDS THEM NOW.** HEAD
	# kept the four unslotted engines, and the ordinary rune, on the hero; since HK a
	# rune nobody wears is in the bag, and the pouch lists the bag's runes he may wear
	# after what he wears, each marked *(in the bag)*. So the two slotted stay on him
	# and the rest go into the bag — and the ordinary rune is his CLASS's longest,
	# because the bag's rows are the runes he may wear (`deepening_hex`, a Cleric's,
	# is not a row on a Warrior's pouch; on HEAD's it was, off his own list).
	for ordinary in ["", "one"]:
		for c in configs:
			var idx := SEATS.find(String(c[1]))
			var held: Array = []
			var bagged: Array = []
			for k in (c[2] as Array).size():
				var r: Dictionary = Runes.build(String(c[2][k]))
				r["equipped"] = k < 2
				(held if k < 2 else bagged).append(r)
			if ordinary != "":
				bagged.append(Runes.build(_longest_ordinary(String(c[1]))))
			# BATCH HR §1 — HELD ON HIM AGAIN (HK put them in the bag): the unslotted engines
			# ride his engine list unworn after the two slotted, and the ordinary rune his
			# own list, so the pouch draws them as his held rows. `bagged` keeps its name: it
			# is the set of runes he holds and does not wear, which was the bag's.
			var e_list: Array = held.duplicate()
			var o_list: Array = []
			for br in bagged:
				if Runes.is_engine_rune(String(br["id"])):
					e_list.append(br)
				else:
					o_list.append(br)
			_run.party[idx]["engines"] = e_list
			_run.party[idx]["runes"] = o_list
			_run.rune_bag = []
			_close_overlays(mp)
			await Gate.frames(self, 2)
			mp._open_rune_panel(idx)
			await Gate.frames(self, 3)
			var label := "%s, %s" % [c[0], "the pouch empty" if ordinary == "" else "one ordinary rune"]
			var ov: Node = Gate.overlay(mp, 60)
			var close: Button = _button(ov, "Close") if ov != null else null
			ok(close != null, "§1: %s — the pouch drew no Close button" % label)
			if close == null:
				continue
			seen += 1
			var cr := close.get_global_rect()
			if not have_pin:
				pinned = cr
				have_pin = true
			ok(cr.position.x >= 0.0 and cr.position.y >= 0.0 and cr.end.x <= 1280.0 and cr.end.y <= 720.0,
				"§1: %s — Close is not wholly on the 1280 x 720 screen (%s)" % [label, str(cr)])
			ok(cr == pinned, "§1: %s — Close moved to %s from %s" % [label, str(cr), str(pinned)])
			ok(not _inside_scroll(close), "§1: %s — Close is inside a scroller, where text can carry it off" % label)
			# EVERY RULE, WHOLE, AT ITS SIZE, IN THE SCROLLER.
			# **BATCH HC §5 — OR, FOR AN ENGINE THAT SITS OUT, GX's SENTENCE, WHOLE.**
			# The Rune of the Beastmaster slotted beside the Rune of the Sharpshooter
			# sits out, and its pouch row carries the tell in place of the rule —
			# the ordinary rows' own shape (GX §1, ruled for this pairing). What this
			# arm measures is unchanged: the text the row carries is drawn whole, at
			# its size, inside the scroller, with Close where it was.
			var eng_h := 0.0
			var sat_out: Array = _run.sitting_out_rune_names(_run.party[idx])
			for er in held + bagged:
				var l: Label = _label_with(ov, String(er["name"]) + " — ")
				var want_text: String = Runes.shown_desc(er)
				if sat_out.has(String(er["name"])) and held.has(er):
					want_text = _run.rune_sits_out_note(String(er["id"]),
						_run.held_engines(_run.party[idx])).replace("\n", " ")
					sat_rows += 1
				# HK — a bag row carries its rule and then says where the rune is; HR §1 —
				# a row he holds says so.
				if bagged.has(er):
					want_text += "   (held)"
				ok(l != null and String(l.text).ends_with(" — " + want_text),
					"§1: %s — %s's %s is not drawn whole" % [label, er["id"],
						"sits-out sentence" if sat_out.has(String(er["name"])) else "rule"])
				if l == null:
					continue
				ok(l.get_theme_font_size("font_size") == 12,
					"§1: %s — %s's rule is drawn at size %d, not 12 — the text was shrunk" % [
						label, er["id"], l.get_theme_font_size("font_size")])
				ok(_inside_scroll(l), "§1: %s — %s's rule is drawn outside the scroller, where it can push Close" % [
					label, er["id"]])
				if l.get_parent() is Control:
					eng_h += (l.get_parent() as Control).size.y
			var sc: ScrollContainer = _first_scroll(ov)
			ok(sc != null and sc.get_child_count() == 1, "§1: %s — the pouch has no scroller" % label)
			if sc != null and sc.get_child_count() == 1:
				var content_h := (sc.get_child(0) as Control).get_combined_minimum_size().y
				scroll_h = int(sc.size.y)
				if content_h > sc.size.y + 0.5:
					scrolled.append(label)
				var kind := String(c[3])
				if ordinary == "" and eng_h > float(worst[kind][1]):
					worst[kind] = [String(c[0]), int(eng_h), int(content_h)]
			# THE PLAYER LEAVES, THROUGH THE BUTTON.
			close.emit_signal("pressed")
			await Gate.frames(self, 2)
			var gone: bool = Gate.overlay(mp, 60) == null and int(mp._rune_panel_for) == -1
			ok(gone, "§1: %s — pressing Close did not close the pouch" % label)
			if gone:
				closed += 1
	ok(scrolled.is_empty(), "§1: the text scrolls for %d configurations, first %s — the pouch is not sized to its longest" % [
		scrolled.size(), str(scrolled.slice(0, 3))])
	ok(seen == 176 and closed == 176, "§1: Close drawn in %d and pressed shut in %d of 176" % [seen, closed])
	# BATCH HC §5 — THE ONE SLOTTED PAIRING THAT SITS OUT, AND ONLY IT: the Rune of
	# the Beastmaster beside the Rune of the Sharpshooter, which is one pair and the
	# Hunter's six (its first two slots), in both pouches — four rows. Fewer is a
	# tell gone missing; more is a tell drawn on an engine that pays.
	ok(sat_rows == 4, "§1: %d engine rows drew the sits-out sentence — the Pack Bond pairing appears in 4" % sat_rows)
	print("    Close at %s in all %d configurations; pressed shut in %d" % [str(pinned), seen, closed])
	for kind2 in ["alone", "pair", "six"]:
		print("    the longest %s: %s — its rules %d px, the list %d px in a %d px scroller" % [
			kind2, worst[kind2][0], worst[kind2][1], worst[kind2][2], scroll_h])
	# A TOGGLE RE-OPENS THE POUCH, AND CLOSE COMES BACK WHERE IT WAS — driven
	# through the Unequip button on the longest pair, then Equip back.
	var hunt := SEATS.find("hunter")
	var pair: Array = []
	for rid in ["engine_beastmaster", "engine_sharpshooter"]:
		var r2: Dictionary = Runes.build(rid)
		r2["equipped"] = true
		pair.append(r2)
	_run.party[hunt]["engines"] = pair
	_run.party[hunt]["runes"] = []
	_run.rune_bag = []
	# **BATCH HK — THE ROW THE ENGINE IS ON, READ OFF `Run.engine_rows`.** An unslotted
	# engine goes into the bag and its row moves below what he still has slotted, so
	# the Equip that brings it back is on the bag's row, not on row 0: HEAD pressed
	# row 0 twice, unslotting the Sharpshooter's too, and then read an empty list.
	for want in ["Unequip", "Equip"]:
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_rune_panel(hunt)
		await Gate.frames(self, 3)
		var ov2: Node = Gate.overlay(mp, 60)
		var at := -1
		var erows: Array = _run.engine_rows(_run.party[hunt])
		for ri in erows.size():
			if String((erows[ri]["rune"] as Dictionary).get("id", "")) == "engine_beastmaster":
				at = ri
		var tb: Button = Gate.bound_button(ov2, "_toggle_engine", [hunt, at, ov2]) if at >= 0 else null
		ok(tb != null and String(tb.text) == want,
			"§1: no %s button on the Rune of the Beastmaster's engine row (row %d)" % [want, at])
		if tb == null:
			continue
		tb.emit_signal("pressed")
		await Gate.frames(self, 3)
		var ov3: Node = Gate.overlay(mp, 60)
		var close2: Button = _button(ov3, "Close") if ov3 != null else null
		ok(close2 != null and close2.get_global_rect() == pinned,
			"§1: after %s the re-opened pouch puts Close at %s" % [want,
				str(close2.get_global_rect()) if close2 != null else "nowhere"])
		var slotted: bool = Runes.held_engines(_run.party[hunt]).has("pack")
		# BATCH HR §1 — an unslotted engine stays on him, unworn (HK: into the bag).
		var in_bag: bool = (_run.party[hunt]["engines"] as Array).any(func(r): return String((r as Dictionary).get("id", "")) == "engine_beastmaster" and not bool((r as Dictionary).get("equipped", false)))
		ok(slotted == (want == "Equip") and in_bag == (want == "Unequip")
				and Runes.held_engines(_run.party[hunt]).has("lethal_aim"),
			"§1: %s did not move the engine's slot (slotted %s, held %s, the Sharpshooter's %s)" % [
				want, slotted, in_bag, Runes.held_engines(_run.party[hunt]).has("lethal_aim")])
	_close_overlays(mp)
	_run.party[hunt]["engines"] = []
	_run.rune_bag = []
	await Gate.frames(self, 2)
	await _s1_a_bag_of_twenty(mp, pinned)


# **BATCH HR §1 — THE POUCH'S LONGEST IS HIS EIGHT HELD BESIDE WHAT HE WEARS** (re-pointed:
# HK's longest was a bag of twenty of his class's runes, which the split took away — a
# hero's panel lists his own lists only, and he holds eight unworn at most). Two engines
# slotted, three runes worn, and eight held — the rest of his six and his class's
# ordinary runes — is thirteen rows, each held row with its Drop; another class's rune
# sits in the bag and his pouch must not list it. The arms below are HK's, on that list.
#
# **BATCH HK — THE POUCH'S NEW LONGEST: A BAG OF TWENTY OF HIS OWN CLASS'S RUNES.**
# The pouch lists every rune in the bag he may wear, so the list is no longer
# bounded by his slots: two engines slotted and three runes worn, and the bag
# filled to twenty with the rest of his six and his class's ordinary runes, is
# twenty-four rows: his class's runes fill the bag but for ONE slot, which holds
# another class's rune — the bag holds it and his pouch must not list it, so the
# arm that asks for no stray row has one to find in every class. **This
# is where the longest genuinely cannot fit, and GT's rule is the one for it: the
# text scrolls and the button does not move.** Asserted for each class: Close drawn,
# at the one place, outside the scroller, and pressed shut; every row of his drawn
# whole at its size inside the scroller, and no row for a rune he may not wear; and
# the last row's button scrolled wholly into view. The list's height is printed.
func _s1_a_bag_of_twenty(mp: Node, pinned: Rect2) -> void:
	var tall := []
	for key in SEATS:
		var idx := SEATS.find(key)
		var six := _six(key)
		var ords: Array = _class_ordinary(key)
		var slotted: Array = []
		for k in 2:
			var r: Dictionary = Runes.build(String(six[k]))
			r["equipped"] = true
			slotted.append(r)
		var worn: Array = []
		for k2 in 3:
			var w: Dictionary = Runes.build(String(ords[k2]))
			w["equipped"] = true
			worn.append(w)
		var bagged: Array = []
		var held_e: Array = []
		for k3 in range(2, six.size()):
			var he: Dictionary = Runes.build(String(six[k3]))
			bagged.append(he)
			held_e.append(he)
		var held_o: Array = []
		var k4 := 3
		while bagged.size() < int(_run.HERO_HOLD_CAP) and k4 < ords.size():
			var ho: Dictionary = Runes.build(String(ords[k4]))
			bagged.append(ho)
			held_o.append(ho)
			k4 += 1
		var others: Array = []
		var other_key := String(SEATS[(idx + 1) % SEATS.size()])
		for oid in _class_ordinary(other_key):
			if others.size() >= 2:
				break
			others.append(Runes.build(String(oid)))
		_run.party[idx]["engines"] = slotted + held_e
		_run.party[idx]["runes"] = worn + held_o
		_run.rune_bag = others
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_rune_panel(idx)
		await Gate.frames(self, 3)
		var label := "the %s holding %d of his class's runes" % [key, bagged.size()]
		ok(_run.held_count(_run.party[idx]) == int(_run.HERO_HOLD_CAP) and _run.holding_full(_run.party[idx])
				and not others.is_empty(),
			"§1: %s — his holding is not full (%d), or the bag holds no other class's rune (%d) for the stray arm to find" % [
				label, _run.held_count(_run.party[idx]), others.size()])
		var ov: Node = Gate.overlay(mp, 60)
		var close: Button = _button(ov, "Close") if ov != null else null
		ok(close != null and close.get_global_rect() == pinned and not _inside_scroll(close),
			"§1: %s — Close is not where it always is, outside the scroller (%s)" % [label,
				str(close.get_global_rect()) if close != null else "none"])
		var sat_out: Array = _run.sitting_out_rune_names(_run.party[idx])
		var whole := 0
		for er in slotted + worn + bagged:
			var l: Label = _label_with(ov, String(er["name"]) + " — ") if ov != null else null
			var want_text: String = Runes.shown_desc(er)
			if sat_out.has(String(er["name"])) and not bagged.has(er):
				want_text = (_run.rune_sits_out_note(String(er["id"]), _run.held_engines(_run.party[idx]))
					if Runes.is_engine_rune(String(er["id"])) else
					_run.rune_sits_out_note(String(er["id"]), _run.held_engines(_run.party[idx]),
						_run.worn_rune_ids(_run.party[idx]))).replace("\n", " ")
			if bagged.has(er):
				want_text += "   (held)"
			if l != null and String(l.text).ends_with(" — " + want_text) \
					and l.get_theme_font_size("font_size") == 12 and _inside_scroll(l):
				whole += 1
		ok(whole == slotted.size() + worn.size() + bagged.size(),
			"§1: %s — %d of %d rows drawn whole, at their size, in the scroller" % [
				label, whole, slotted.size() + worn.size() + bagged.size()])
		var strays: Array = others.filter(func(o): return _label_with(ov, String(o["name"]) + " — ") != null) \
			if ov != null else []
		ok(strays.is_empty(), "§1: %s — his pouch lists %d rune(s) he may not wear (%s)" % [
			label, strays.size(), str(strays.map(func(o): return o["id"]))])
		var sc: ScrollContainer = _first_scroll(ov) if ov != null else null
		var btns: Array = []
		if sc != null:
			Gate.buttons(sc, btns)
		# HR §1 — a held row carries its toggle and its Drop: two buttons a row.
		ok(sc != null and btns.size() == slotted.size() + worn.size() + 2 * bagged.size(),
			"§1: %s — %d row buttons in the scroller for %d rows (%d of them held, each with a Drop)" % [label, btns.size(),
				slotted.size() + worn.size() + bagged.size(), bagged.size()])
		if sc != null and not btns.is_empty():
			var last: Button = btns[btns.size() - 1]
			sc.ensure_control_visible(last)
			await Gate.frames(self, 2)
			ok(sc.get_global_rect().encloses(last.get_global_rect()),
				"§1: %s — the last row's %s cannot be scrolled wholly into view (%s in %s)" % [
					label, String(last.text), str(last.get_global_rect()), str(sc.get_global_rect())])
			var content_h := (sc.get_child(0) as Control).get_combined_minimum_size().y
			tall.append("%s (%d rows) %d px in %d" % [key, btns.size(), int(content_h), int(sc.size.y)])
		if close != null:
			close.emit_signal("pressed")
			await Gate.frames(self, 2)
			ok(Gate.overlay(mp, 60) == null and int(mp._rune_panel_for) == -1,
				"§1: %s — pressing Close did not close the pouch" % label)
		_run.party[idx]["engines"] = []
		_run.party[idx]["runes"] = []
		_run.rune_bag = []
	print("    eight held beside three worn and two slotted — the list scrolls, Close stays: %s" % [
		", ".join(PackedStringArray(tall))])


# ── §2 — THE PEDDLER ────────────────────────────────────────────────────────

func _s2_the_peddler() -> void:
	print("\n§2 — the Peddler: every offer can be bought, and Leave is where it was")
	_seat_party()
	_run.gold = 99999
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 8)
	var shop: Node = current_scene
	ok(Gate.scene_name(self) == "Shop", "§2: the Peddler is not on screen (%s)" % Gate.scene_name(self))
	if Gate.scene_name(self) != "Shop":
		return
	var longest: Array = []
	var shortest: Array = []
	var ordinary: Array = []
	for key in SEATS:
		var six := _six(key)
		six.sort_custom(func(a, b): return _rule_len(String(a)) > _rule_len(String(b)))
		longest.append(six[0])
		shortest.append(six[six.size() - 1])
		# BATCH HC §1 — THE SEAT'S CLASS'S RUNES: every ordinary rune is scoped to
		# its class now, so the longest a seat can be offered is its class's
		# longest — the same population the three lineages' runes made before.
		# (HK: read through `_longest_ordinary`, which §1 shares.)
		ordinary.append(_longest_ordinary(String(key)))
	ok(not ordinary.has(""), "§2: a seat has no ordinary rune to be offered (%s)" % str(ordinary))
	for deal in [["every seat's longest ordinary rune", ordinary], ["every class's shortest engine rule", shortest],
			["every class's longest engine rule", longest]]:
		var offers: Array = []
		for i in 4:
			offers.append({"member_idx": i, "rune": Runes.build(String(deal[1][i]))})
		shop.offers = offers
		# The four offers alone: a seat the roll found nothing for would add its
		# sentence under them, which is a different deal from the one measured.
		shop.set("_spent", [])
		_run.rune_bag = []
		shop._draw_screen()
		await Gate.frames(self, 4)
		var sc: ScrollContainer = _scroll_holding(shop, "Buy — ")
		var leave: Button = _button(shop, "Leave the Shop")
		ok(sc != null and leave != null, "§2: %s — no rune scroller (%s) or no Leave button (%s)" % [deal[0], sc, leave])
		if sc == null or leave == null:
			continue
		var sr := sc.get_global_rect()
		var lr := leave.get_global_rect()
		ok(not _inside_scroll(leave), "§2: %s — Leave is inside a scroller" % deal[0])
		ok(lr.end.y <= 720.0 and lr.position.y >= 0.0, "§2: %s — Leave is off the screen (%s)" % [deal[0], str(lr)])
		ok(sr.end.y <= lr.position.y and sr.end.y <= 720.0 and sr.end.x <= 1280.0,
			"§2: %s — the rune column (%s) runs under Leave (%s) or off the screen" % [deal[0], str(sr), str(lr)])
		var list: Control = sc.get_child(0)
		# EVERY OFFER'S PANEL, WHEREVER IT IS DRAWN — so a column laid at a fixed
		# pitch is read as the overlap it is, not merely as a missing scroller.
		var panels: Array = []
		var stack: Array = [shop]
		while not stack.is_empty():
			var cur: Node = stack.pop_front()
			if cur is PanelContainer and not cur.is_queued_for_deletion() \
					and not _buttons_from(cur, "Buy — ").is_empty():
				panels.append(cur)
				continue
			for ch3 in cur.get_children():
				stack.append(ch3)
		ok(panels.size() == 4, "§2: %s — %d offer panels drawn for four offers" % [deal[0], panels.size()])
		for a in panels.size():
			for b in range(a + 1, panels.size()):
				ok(not (panels[a] as Control).get_global_rect().intersects((panels[b] as Control).get_global_rect()),
					"§2: %s — offers %d and %d overlap" % [deal[0], a, b])
		var buys := _buttons_from(shop, "Buy — ")
		ok(buys.size() == 4, "§2: %s — %d Buy buttons" % [deal[0], buys.size()])
		for bi in buys.size():
			var bb: Button = buys[bi]
			ok(_inside_scroll(bb), "§2: %s — Buy %d is outside the column's scroller" % [deal[0], bi])
			sc.ensure_control_visible(bb)
			await Gate.frames(self, 2)
			ok(sc.get_global_rect().encloses(bb.get_global_rect()),
				"§2: %s — Buy %d cannot be scrolled wholly into view (%s in %s)" % [
					deal[0], bi, str(bb.get_global_rect()), str(sc.get_global_rect())])
		var content_h := list.get_combined_minimum_size().y
		var scrolls: bool = content_h > sc.size.y + 0.5
		print("    %s: the offers stack %d px in a %d px column%s" % [deal[0], int(content_h), int(sc.size.y),
			" — it scrolls" if scrolls else ", unscrolled"])
		if deal[1] == ordinary:
			ok(not scrolls, "§2: four ordinary offers — every seat's longest — no longer fit unscrolled (%d in %d)" % [
				int(content_h), int(sc.size.y)])
		# EVERY BUY, PRESSED, BUYS ITS OWN HERO'S RUNE — the lowest first, scrolled
		# to it, through the button.
		for _k in 4:
			var live: Array = shop.get("offers")
			if live.is_empty():
				break
			var last: int = live.size() - 1
			var mi: int = int(live[last]["member_idx"])
			var rune_id := String(live[last]["rune"]["id"])
			var sc2: ScrollContainer = _scroll_holding(shop, "Buy — ")
			var b2: Array = _buttons_from(shop, "Buy — ")
			if sc2 == null or b2.size() != live.size():
				ok(false, "§2: %s — %d Buy buttons for %d offers" % [deal[0], b2.size(), live.size()])
				break
			sc2.ensure_control_visible(b2[last])
			await Gate.frames(self, 2)
			(b2[last] as Button).emit_signal("pressed")
			await Gate.frames(self, 2)
			# **BATCH HK §3 — A PURCHASE GOES INTO THE BAG, EVERY KIND**, and never onto
			# the hero it was rolled for. **BATCH HR §1 — RE-POINTED: ONTO HIM, UNWORN**, every
			# class and core rune (a crest rune would go to the bag; these are his own): the
			# offer leaves the counter, the rune is held by him and worn by nobody, and the
			# bag does not have it.
			var m: Dictionary = _run.party[mi]
			var held_ids: Array = (m.get("engines", []) + m.get("runes", [])).filter(
				func(r): return not bool(r.get("equipped", false))).map(func(r): return String(r.get("id", "")))
			var left: Array = (shop.get("offers") as Array).map(func(o): return String(o["rune"]["id"]))
			ok(held_ids.has(rune_id) and not _bag_ids().has(rune_id) and not left.has(rune_id),
				"§2: %s — the Buy for %s (rolled for hero %d) did not leave it held by him, unworn (bag %s, held %s)" % [
					deal[0], rune_id, mi, str(_bag_ids()), str(held_ids)])
		for i2 in _run.party.size():
			_run.party[i2]["engines"] = []
			_run.party[i2]["runes"] = []
		_run.rune_bag = []


# ── §3 — A CARD THAT CANNOT BE CAST WITHOUT ITS ENGINE SITS OUT ─────────────

func _s3_the_card_that_sits_out() -> void:
	print("\n§3 — a card that cannot be cast without its engine sits out, and returns")
	# (a) THE TABLE IS THE RULED ONE.
	var table: Dictionary = Classes.SITS_OUT
	for card in RULED:
		ok(Classes.sits_out_engine(String(card)) == String(RULED[card]),
			"§3: %s sits out without %s by the ruling; the table says %s" % [card, RULED[card],
				Classes.sits_out_engine(String(card))])
		ok(String(table.get(card, {}).get("why", "")) != "", "§3: %s's row carries no why" % card)
		var er := Classes.engine_read(String(card))
		ok(er == "" or er == String(RULED[card]),
			"§3: %s reads %s in `ENGINE_READ` and sits out without %s" % [card, er, RULED[card]])
		ok(Classes.sits_out_ruled(String(card)) == "",
			"§3: %s is a derived row and carries a ruling (`%s`)" % [card, Classes.sits_out_ruled(String(card))])
	for cardr in UNDONE_BY_DESIGNER:
		ok(Classes.sits_out_engine(String(cardr)) == "" and Classes.sits_out_ruled(String(cardr)) == ""
				and not table.has(cardr),
			"§3: %s still sits out without %s — HF §7 undid HE §2's ruling (the table says %s, `ruled` %s)" % [
				cardr, UNDONE_BY_DESIGNER[cardr], Classes.sits_out_engine(String(cardr)),
				Classes.sits_out_ruled(String(cardr))])
		ok(Classes.engine_read(String(cardr)) == "" and Classes.engine_read_ruled(String(cardr)) == "",
			"§3: %s is still gated in `ENGINE_READ` — HF §7 undid HE §2's ruling (%s, `ruled` %s)" % [
				cardr, Classes.engine_read(String(cardr)), Classes.engine_read_ruled(String(cardr))])
	for card2 in table:
		ok(RULED.has(card2), "§3: %s sits out, and no ruling named it" % card2)
	ok(Classes.sits_out("Death Ray", []) and not Classes.sits_out("Death Ray", ["resonance"])
			and not Classes.sits_out("Arcane Cannon", []),
		"§3: `Classes.sits_out` does not answer by the table")
	# (b) THE CENSUS — every card a hero of each class can earn, asked bare.
	var asked := 0
	var refused_all: Array = []
	var met_ruled := {}
	for key in SEATS:
		var pop: Array = []
		for n in Classes.draft_pool(key):
			if not pop.has(String(n)):
				pop.append(String(n))
		for sp in Classes.SPEC_IDS[key]:
			for n2 in Classes.spec_pool(String(sp)):
				if not pop.has(String(n2)):
					pop.append(String(n2))
		var s: Node = await _bare_board()
		var u: BattleUnit = _hero(s, key)
		for h in s.get("heroes"):
			h.engines = []
		_dress(s, u)
		for card3 in pop:
			var ab: Ability = Classes.pool_ability(String(card3))
			ok(ab != null, "§3: the %s card %s does not resolve" % [key, card3])
			if ab == null:
				continue
			asked += 1
			var refused := not _usable(s, u, ab)
			if refused:
				refused_all.append(String(card3))
			if UNDONE_BY_DESIGNER.has(card3):
				met_ruled[String(card3)] = refused
			ok(not refused or RULED.has(card3) or CARD_ROUTES.has(card3),
				"§3: a %s holding no engine is refused %s, which is neither a row nor a card-conditional card" % [key, card3])
			ok(refused or not (RULED.has(card3) or CARD_ROUTES.has(card3)),
				"§3: %s is a row or card-conditional, and a %s holding no engine can cast it on a bare board" % [card3, key])
		await _clear(s)
	var named := RULED.size() + CARD_ROUTES.size()
	ok(asked >= 190 and refused_all.size() == named,
		"§3: the census asked %d cards and %d were refused bare — %d named" % [asked, refused_all.size(), named])
	for r3 in RULED.keys() + CARD_ROUTES.keys():
		ok(refused_all.has(r3), "§3: %s was not met in any class's earnable pool" % r3)
	# THE UNDONE ROW'S PREMISE: met in an earnable pool and NOT refused bare —
	# the half-working that made HF §7 take the ruling back.
	for r4 in UNDONE_BY_DESIGNER:
		ok(met_ruled.has(r4) and not bool(met_ruled[r4]),
			"§3: %s's row was undone because it half-works bare, and the census %s — whether it sits out is a question again" % [
				r4, "never met it" if not met_ruled.has(r4) else "found the door refuses it bare"])
	print("    the census: %d earnable cards asked with no engine; %d refused — %d rows and %d card-conditional" % [
		asked, refused_all.size(), RULED.size(), CARD_ROUTES.size()])
	# (c) THE TEN OPEN BY THEIR OWN ROUTE, STILL WITH NO ENGINE.
	for route in ["guard", "heal", "low", "companion"]:
		var key2: String = String({"guard": "warrior", "heal": "cleric", "low": "warrior",
			"companion": "hunter"}[route])
		var s2: Node = await _bare_board()
		var u2: BattleUnit = _hero(s2, key2)
		for h2 in s2.get("heroes"):
			h2.engines = []
		_dress(s2, u2)
		var foes: Array = _foes(s2)
		match route:
			"guard":
				# BATCH HL §1 — THE ROUTE IS A SWAP HE CAN STILL DRAFT: Precision
				# Strike, in the Warrior's pool and gated on no engine, switches the
				# guard as it resolves (Aggressive to Defensive).
				ok(Classes.draft_pool("warrior").has("Precision Strike")
						and Classes.engine_read("Precision Strike") == "",
					"§3: Precision Strike is not a draftable, ungated swap — the guard route has no card")
				await s2._resolve(u2, Classes.pool_ability("Precision Strike"), foes[0], "good")
			"heal":
				var ally: BattleUnit = _hero(s2, "warrior")
				await s2._resolve(u2, Classes.pool_ability("Ministration"), ally, "good")
			"low":
				foes[0].hp = int(foes[0].max_hp * 0.1)
			"companion":
				await s2._resolve(u2, Classes.pool_ability("Call the Wilds"), foes[0], "good")
		u2.resource = 99999
		for card4 in CARD_ROUTES:
			if CARD_ROUTES[card4] != route:
				continue
			ok(_usable(s2, u2, Classes.pool_ability(String(card4))),
				"§3: %s does not open for a %s holding no engine by its route (%s)" % [card4, key2, route])
		await _clear(s2)
	# (d) EVERY ROW OPENS WITH ITS ENGINE HELD — the positive arm of (b).
	var opened := 0
	for pid in ["permafrost", "resonance", "mercy", "conviction", "old_gods", "pack"]:
		var key3 := Classes.engine_class(pid)
		var seat := SEATS.find(key3)
		var rune := Runes.build(Runes.engine_rune_id(pid))
		rune["equipped"] = true
		var over := {}
		for i in 4:
			over[i] = {"engines": [rune] if i == seat else []}
		var s3: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
		var u3: BattleUnit = _hero(s3, key3)
		_dress(s3, u3)
		var foes3: Array = _foes(s3)
		match pid:
			"permafrost":
				s3._hold_freeze(foes3[0], u3)
			"resonance", "mercy":
				u3.second_resource = 20
			"conviction":
				u3.faith_stacks = 3
				s3._grant_divine_shield(u3, _hero(s3, "warrior"), 40)
			"old_gods":
				s3._gain_ruin(foes3[0], 3)
				s3._gain_ruin(foes3[1], 3)
			"pack":
				await s3._resolve_special(u3, Classes.pool_ability("Summon Ursus"), u3, "good", 1.0)
				for b in s3._beasts(u3):
					s3._gain_loyalty(u3, b.companion_kind, 3)
		u3.resource = 99999
		var every: Dictionary = RULED.duplicate()
		for card5 in every:
			if every[card5] != pid:
				continue
			var yes := _usable(s3, u3, Classes.pool_ability(String(card5)))
			ok(yes, "§3: %s does not open for a %s holding %s — a row its engine cannot open is a card nobody can cast" % [
				card5, key3, pid])
			if yes:
				opened += 1
		await _clear(s3)
	ok(opened == RULED.size(),
		"§3: %d of %d rows opened with their engine held" % [opened, RULED.size()])
	# (e) THE DRIVE, ONE ENGINE AT A TIME, THROUGH THE REAL DOORS.
	for pid2 in ["permafrost", "resonance", "mercy", "conviction", "old_gods", "pack"]:
		await _drive(pid2)


# Taken under the engine, dropped through the pouch's door, kept, still carried
# and counted, not seated, the fight runs, the screens say why, the save carries
# it; slotted again, seated again.
func _drive(pid: String) -> void:
	var key := Classes.engine_class(pid)
	var seat := SEATS.find(key)
	var rows: Array = RULED.keys().filter(func(c): return RULED[c] == pid)
	# BATCH HF §7 — a row undone is carried with the engine and STAYS SEATED without it.
	var undone: Array = UNDONE_BY_DESIGNER.keys().filter(func(c): return UNDONE_BY_DESIGNER[c] == pid)
	var control := String(CONTROL.get(key, ""))
	_seat_party()
	_run.zone_bosses_cleared = 3
	var m: Dictionary = _run.party[seat]
	var rune := Runes.build(Runes.engine_rune_id(pid))
	# BATCH HL §1 — `hold_rune` SLOTS A CORE RUNE ONLY WHEN ITS CALLER ASKS (a
	# cache's answer never does, so no card arrives beside a rune unasked). This
	# drive takes the rune to wear it, so it asks — as class selection and the sim
	# do — and the arm below still holds it to slotting.
	rune["equipped"] = true
	_run.hold_rune(m, rune)
	ok(Runes.held_engines(m) == [pid], "§3 %s: the rune did not slot (%s)" % [pid, str(Runes.held_engines(m))])
	# THROUGH THE DOORS A PLAYER USES: the draft's for a pool card, the boss
	# pick's one writer for a zone-boss card.
	var drafted := Classes.draft_pool(key)
	for card in rows + undone + [control]:
		if drafted.has(card):
			m["draft_candidates"] = [[card]]
			m["draft_picks_owed"] = 1
			var why: String = _run.take_draft_ability(m, String(card))
			ok(why == "", "§3 %s: %s could not be drafted under its engine (%s)" % [pid, card, why])
		else:
			_run.hold_ability(m, String(card), true)
	var pool_before: Array = m.get("bm_abilities", []).duplicate()
	var carried_before: Array = _run.equipped_ability_names(m)
	var slots_before: int = int(_run.ability_slots_used(m))
	ok(carried_before.size() == rows.size() + undone.size() + 1, "§3 %s: carrying %s" % [pid, str(carried_before)])
	# HELD: every row seated.
	var got: Array = await _bar(seat, m)
	for card2 in rows + undone + [control]:
		ok(got.has(card2), "§3 %s: holding the engine, the fight does not seat %s (%s)" % [pid, card2, str(got)])
	# DROPPED, THROUGH THE POUCH'S DOOR.
	ok(bool(_run.toggle_engine(m, 0)) and Runes.held_engines(m).is_empty(),
		"§3 %s: the pouch's door did not drop the engine" % pid)
	# HK §2 — KEPT; HR §1 — ON HIM, UNWORN, where an unslotted engine rune goes since the
	# bag split (HK kept it in the bag).
	ok(_hr_held_engine_ids(m) == [String(rune["id"])] and _bag_ids().is_empty(),
		"§3 %s: dropping the engine lost the rune (held %s, bag %s)" % [pid, str(_hr_held_engine_ids(m)), str(_bag_ids())])
	ok(m.get("bm_abilities", []) == pool_before, "§3 %s: dropping the engine changed what the hero owns" % pid)
	ok(_run.equipped_ability_names(m) == carried_before, "§3 %s: dropping the engine changed what he carries" % pid)
	ok(int(_run.ability_slots_used(m)) == slots_before,
		"§3 %s: the slot count moved from %d to %d — a card that sits out keeps its slot" % [
			pid, slots_before, _run.ability_slots_used(m)])
	var sat: Array = _run.sitting_out_names(m)
	var seated: Array = _run.seated_ability_names(m)
	sat.sort()
	var want: Array = rows.duplicate()
	want.sort()
	var want_seated: Array = undone + [control]
	want_seated.sort()
	seated.sort()
	ok(sat == want and seated == want_seated, "§3 %s: sitting out %s and seated %s" % [pid, str(sat), str(seated)])
	var got2: Array = await _bar(seat, m, true)
	for card3 in rows:
		ok(not got2.has(card3), "§3 %s: with the engine dropped the fight still seats %s" % [pid, card3])
	ok(got2.has(control), "§3 %s: with the engine dropped the fight does not seat %s either" % [pid, control])
	for cardu in undone:
		ok(got2.has(cardu), "§3 %s: with the engine dropped the fight does not seat %s — HF §7 undid its row" % [pid, cardu])
	# THE SCREENS SAY WHY.
	await _screens_say_why(pid, seat, rows, undone)
	# THE SAVE CARRIES IT.
	_run.save_run()
	ok(_run.load_run(), "§3 %s: the harness save did not load back" % pid)
	var m2: Dictionary = _run.party[seat]
	ok(m2.get("bm_abilities", []) == pool_before and _run.equipped_ability_names(m2) == carried_before
			and Runes.held_engines(m2).is_empty() and _hr_held_engine_ids(m2) == [String(rune["id"])],
		"§3 %s: the save did not carry the kept cards and the dropped rune" % pid)
	# BENCHING IS THE PLAYER'S DOOR TO THE SLOT, AND IT IS REVERSIBLE.
	ok(_run.unequip_earned_ability(m2, String(rows[0])) and int(_run.ability_slots_used(m2)) == slots_before - 1,
		"§3 %s: benching %s did not free its slot" % [pid, rows[0]])
	ok(_run.equip_earned_ability(m2, String(rows[0])) and int(_run.ability_slots_used(m2)) == slots_before,
		"§3 %s: carrying %s again did not take the slot back" % [pid, rows[0]])
	# SLOTTED AGAIN, SEATED AGAIN.
	var back := -1
	var erows2: Array = _run.engine_rows(m2)
	for ri in erows2.size():
		if String((erows2[ri]["rune"] as Dictionary).get("id", "")) == String(rune["id"]):
			back = ri
	ok(back >= 0 and bool(_run.toggle_engine(m2, back)) and Runes.held_engines(m2) == [pid]
			and _hr_held_engine_ids(m2).is_empty(),
		"§3 %s: the pouch's door did not slot the engine back out of his holding (row %d)" % [pid, back])
	ok(_run.sitting_out_names(m2).is_empty(), "§3 %s: cards still sit out with the engine back" % pid)
	var got3: Array = await _bar(seat, m2)
	for card4 in rows + undone:
		ok(got3.has(card4), "§3 %s: the engine is back and the fight does not seat %s" % [pid, card4])
	print("    %s: %s — kept, %d slots before and after the drop, left out of the fight and seated again" % [
		pid, ", ".join(PackedStringArray(rows)), slots_before])


# What a fight seats for `m` in `seat`: the member stamped onto a fresh fixture
# party the way the save would carry it. With `run_it`, the real loop runs a
# stretch on autoplay and counts its turns (`_turns_taken`, every unit's). **The
# fixture starts a new run**, so the run's own party and slot ladder are put back afterwards —
# the member under test is the one the rest of the drive keeps writing.
func _bar(seat: int, m: Dictionary, run_it := false) -> Array:
	var keep: Array = _run.party
	# **BATCH HK — AND THE BAG, THE CREST AND THE WAITING DROPS**: run state the
	# fixture's `new_run` resets, and the drive's dropped engine is in the bag.
	var keep_bag: Array = _run.rune_bag
	var keep_crest: Array = _run.party_runes
	var keep_wait: Array = _run.pending_rune_drops
	var over := {seat: {"engines": m.get("engines", []).duplicate(true),
		"bm_abilities": m.get("bm_abilities", []).duplicate(),
		"bm_equipped": m.get("bm_equipped", []).duplicate()}}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"party": over})
	var u: BattleUnit = _hero(s, SEATS[seat])
	var names: Array = _names(u.abilities) if u != null else []
	if run_it and u != null:
		var parked: BattleUnit = s.get("current_hero")
		if parked != null:
			s.emit_signal("_ability_picked", parked.abilities[0])
			await process_frame
			s.emit_signal("_target_picked", _foes(s)[0])
		var turns0: int = int(s.get("_turns_taken"))
		s.set("autoplay", true)
		var frames := 0
		while frames < 1200 and int(s.get("_turns_taken")) < turns0 + 8:
			Engine.time_scale = 100.0
			await process_frame
			frames += 1
			for e in _foes(s):
				if e.hp < 50000:
					e.max_hp = 100000
					e.hp = e.max_hp
			for h in s.get("heroes"):
				if not h.is_companion and h.hp < int(h.max_hp * 0.5):
					h.hp = int(h.max_hp * 0.5)
			if bool(s.get("battle_over")):
				break
		Engine.time_scale = 1.0
		s.set("autoplay", false)
		ok(int(s.get("_turns_taken")) >= turns0 + 8 and not bool(s.get("battle_over")),
			"§3: the fight with a card sitting out did not run — %d turns in %d frames" % [
				int(s.get("_turns_taken")) - turns0, frames])
		for card in _names(u.abilities):
			ok(names.has(card), "§3: %s reached the bar mid-fight" % card)
	await _clear(s)
	_run.party = keep
	_run.rune_bag = keep_bag
	_run.party_runes = keep_crest
	_run.pending_rune_drops = keep_wait
	_run.zone_bosses_cleared = 3
	_run.active = true
	return names


func _screens_say_why(pid: String, seat: int, rows: Array, undone: Array = []) -> void:
	var rune_name := String(Runes.config(Runes.engine_rune_id(pid))["name"])
	# THE HERO SHEET.
	_run.hero_screen_idx = seat
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	var sheet_labels: Array = []
	_labels(current_scene, sheet_labels)
	for card in rows:
		var chip: Label = _label_with(current_scene, "%s — sits out" % card)
		var tip := String((chip.get_parent() as Control).tooltip_text) if chip != null else ""
		ok(chip != null and tip == _run.sits_out_note(String(card)) and tip.contains(rune_name),
			"§3 %s: the hero sheet does not show %s sitting out with its reason (%s)" % [pid, card, tip])
		# AND NOT ALSO AS A CARD THE FIGHT WILL SEAT: an ordinary chip reads the
		# name, or the name and its cost, with no "sits out".
		var as_seated := sheet_labels.filter(func(l):
			var t := String((l as Label).text).trim_prefix("◆ ")
			return t == String(card) or t.begins_with(String(card) + "  ("))
		ok(as_seated.is_empty(), "§3 %s: the hero sheet also shows %s as a seated card" % [pid, card])
	# BATCH HF §7 — AN UNDONE ROW IS SHOWN SEATED, AND NOT AS SITTING OUT.
	for cardu in undone:
		var as_seated_u := sheet_labels.filter(func(l):
			var t := String((l as Label).text).trim_prefix("◆ ")
			return t == String(cardu) or t.begins_with(String(cardu) + "  ("))
		ok(_label_with(current_scene, "%s — sits out" % cardu) == null and not as_seated_u.is_empty(),
			"§3 %s: the hero sheet does not show %s as a seated card with the engine dropped" % [pid, cardu])
	# THE KIT PANEL ON THE MAP.
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 8)
	var mp: Node = current_scene
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp._open_loadout_panel(seat)
	await Gate.frames(self, 3)
	var ov: Node = Gate.overlay(mp, 60)
	for card2 in rows:
		var l: Label = _label_with(ov, "✦ %s — Sits out" % card2) if ov != null else null
		ok(l != null and String(l.text).contains(rune_name),
			"§3 %s: the Kit panel does not say %s sits out, or which rune brings it back" % [pid, card2])
	for cardu2 in undone:
		# Carried and seated, the row reads its own text; sitting out, the sentence.
		var lu: Label = _label_with(ov, "✦ %s — " % cardu2) if ov != null else null
		ok(lu != null and not String(lu.text).contains("Sits out"),
			"§3 %s: the Kit panel does not show %s carried and seated with the engine dropped — HF §7 undid its row (%s)" % [
				pid, cardu2, String(lu.text) if lu != null else "no row"])
	_close_overlays(mp)
	await Gate.frames(self, 2)


# ── §4 — THE BASELINE ───────────────────────────────────────────────────────

func _s4_the_baseline() -> void:
	print("\n§4 — Fireball, Frostbolt and Aimed Shot at the price of the kit card beside them")
	for card in BASELINE:
		var a: Ability = Classes.pool_ability(String(card))
		var k: Ability = Classes.pool_ability(String(BASELINE[card]))
		ok(a != null and k != null, "§4: %s or %s does not resolve" % [card, BASELINE[card]])
		if a == null or k == null:
			continue
		ok(a.cost == k.cost and a.cooldown == k.cooldown and absf(a.delay - k.delay) < 0.001,
			"§4: %s costs %d, cooldown %d, initiative %.1f — the baseline is %s's %d, %d, %.1f" % [
				card, a.cost, a.cooldown, a.delay, BASELINE[card], k.cost, k.cooldown, k.delay])
		var u: Dictionary = UNMOVED[card]
		var st := String(a.applies_status.get("id", "")) if not a.applies_status.is_empty() else ""
		ok(a.damage == int(u["damage"]) and a.pressure == int(u["pressure"])
				and absf(a.delay - float(u["delay"])) < 0.001 and String(a.dmg_type) == String(u["dmg_type"])
				and st == String(u["status"]) and String(a.perfect_text) == String(u["perfect_text"]),
			"§4: something of %s besides its cost and cooldown moved" % card)
		print("    %s: %d Mana, cooldown %d, initiative %.1f — %s's" % [card, a.cost, a.cooldown, a.delay, BASELINE[card]])


# ── §5 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§5: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§5: %s is byte for byte what it was" % p)
