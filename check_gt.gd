# BATCH GT — THE POUCH TRAP, THREE CARDS AT THE BASELINE, AND A CARD THAT SITS OUT.
#
#   §0  THE PLAYER'S FILES, AS FOUND — and this process writes the harness save
#   §1  THE POUCH NEVER TRAPS THE PLAYER — every engine rune held alone, every pair
#       of one class's six, and each class's six held at once (two slotted, four
#       kept), each with the pouch empty and with an ordinary rune beside them:
#       Close is on the screen, at ONE place in every configuration, outside every
#       scroller, and pressing it closes the pouch; every rule is drawn whole, at
#       its size, inside the scroller; the text fits unscrolled; and a toggle that
#       re-opens the pouch puts Close back where it was
#   §2  THE PEDDLER — four offers, three deals (every seat's longest ordinary rune,
#       his class's shortest engine rule, his class's longest): no offer overlaps
#       another, every Buy button is inside the one scroller and can be scrolled
#       wholly into view, the scroller ends above Leave, Leave is outside it and on
#       the screen, and every Buy pressed buys its own hero's rune
#   §3  THE CARD THAT SITS OUT — the table against the door: every card a hero of
#       each class can earn, asked with NO engine on a dressed board, is refused
#       exactly when it is a row or one of the ten card-conditional cards; each of
#       those ten opens by its own card or board route with still no engine; every
#       row opens with its engine held; and the drive — taken through the draft
#       door or the boss pick's under the engine, the engine dropped through the
#       pouch's door: kept, still carried, its slot still counted, not seated, the
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
# **BATCH HE §2 — A ROW THE DESIGNER RULED, WHICH THE DOOR NEVER REFUSES.** Mark of
# the Hunt half-works without Pack Bond (its companion's halves read no engine),
# so the census below can never find it; it was ruled Pack Bond's and sits out
# with it. It is held APART from `RULED`, whose population the census derives,
# and driven as a ruling (HD §1's rule for a ruled row): its premise asserted —
# usable bare — and its seat driven with the derived rows. The day the door
# refuses it bare, the census has found it and the ruling is no longer why.
const RULED_BY_DESIGNER := {"Mark of the Hunt": "pack"}
# THE TEN THE DOOR REFUSES BARE THAT ARE NOT ROWS, AND WHAT OPENS EACH WITH NO
# ENGINE: a drafted Guard Change turns the guard Defensive; a heal landed first;
# an enemy under 20% health; a companion from an earned Call the Wilds.
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
	for ordinary in [[], ["deepening_hex"]]:
		for c in configs:
			var idx := SEATS.find(String(c[1]))
			var held: Array = []
			for k in (c[2] as Array).size():
				var r: Dictionary = Runes.build(String(c[2][k]))
				r["equipped"] = k < 2
				held.append(r)
			_run.party[idx]["engines"] = held
			_run.party[idx]["runes"] = (ordinary as Array).map(func(o): return Runes.build(String(o)))
			_close_overlays(mp)
			await Gate.frames(self, 2)
			mp._open_rune_panel(idx)
			await Gate.frames(self, 3)
			var label := "%s, %s" % [c[0], "the pouch empty" if ordinary.is_empty() else "one ordinary rune"]
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
			for er in held:
				var l: Label = _label_with(ov, String(er["name"]) + " — ")
				var want_text: String = Runes.shown_desc(er)
				if sat_out.has(String(er["name"])):
					want_text = _run.rune_sits_out_note(String(er["id"]),
						_run.held_engines(_run.party[idx])).replace("\n", " ")
					sat_rows += 1
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
				if ordinary.is_empty() and eng_h > float(worst[kind][1]):
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
	for want in ["Unequip", "Equip"]:
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_rune_panel(hunt)
		await Gate.frames(self, 3)
		var ov2: Node = Gate.overlay(mp, 60)
		var tb: Button = Gate.bound_button(ov2, "_toggle_engine", [hunt, 0, ov2])
		ok(tb != null and String(tb.text) == want, "§1: no %s button on the pouch's first engine row" % want)
		if tb == null:
			continue
		tb.emit_signal("pressed")
		await Gate.frames(self, 3)
		var ov3: Node = Gate.overlay(mp, 60)
		var close2: Button = _button(ov3, "Close") if ov3 != null else null
		ok(close2 != null and close2.get_global_rect() == pinned,
			"§1: after %s the re-opened pouch puts Close at %s" % [want,
				str(close2.get_global_rect()) if close2 != null else "nowhere"])
		ok(bool(_run.party[hunt]["engines"][0]["equipped"]) == (want == "Equip"),
			"§1: %s did not move the engine's slot" % want)
	_close_overlays(mp)
	_run.party[hunt]["engines"] = []
	await Gate.frames(self, 2)


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
		var best := ""
		var best_len := -1
		# BATCH HC §1 — THE SEAT'S CLASS'S RUNES: every ordinary rune is scoped to
		# its class now, so the longest a seat can be offered is its class's
		# longest — the same population the three lineages' runes made before.
		for rid in Runes.ids():
			if Runes.is_engine_rune(String(rid)) or Runes.is_retired(String(rid)):
				continue
			var sc0 := String(Runes.config(String(rid)).get("scope", ""))
			var dl := String(Runes.config(String(rid)).get("desc", "")).length()
			if sc0 == "class:%s" % String(key) and dl > best_len:
				best = String(rid)
				best_len = dl
		ordinary.append(best)
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
		shop._draw_screen()
		await Gate.frames(self, 4)
		var sc: ScrollContainer = null
		for ch in shop.get_children():
			if ch is ScrollContainer and not ch.is_queued_for_deletion():
				sc = ch
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
			var sc2: ScrollContainer = null
			for ch2 in shop.get_children():
				if ch2 is ScrollContainer and not ch2.is_queued_for_deletion():
					sc2 = ch2
			var b2: Array = _buttons_from(shop, "Buy — ")
			if sc2 == null or b2.size() != live.size():
				ok(false, "§2: %s — %d Buy buttons for %d offers" % [deal[0], b2.size(), live.size()])
				break
			sc2.ensure_control_visible(b2[last])
			await Gate.frames(self, 2)
			(b2[last] as Button).emit_signal("pressed")
			await Gate.frames(self, 2)
			var m: Dictionary = _run.party[mi]
			var held_ids: Array = (m.get("engines", []) + m.get("runes", [])).map(func(r): return String(r.get("id", "")))
			ok(held_ids.has(rune_id), "§2: %s — the Buy for %s did not give it to hero %d" % [deal[0], rune_id, mi])
		for i2 in _run.party.size():
			_run.party[i2]["engines"] = []
			_run.party[i2]["runes"] = []


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
	for cardr in RULED_BY_DESIGNER:
		var er2 := String(RULED_BY_DESIGNER[cardr])
		ok(Classes.sits_out_engine(String(cardr)) == er2 and Classes.sits_out_ruled(String(cardr)) == "HE §2",
			"§3: %s sits out without %s by the designer's ruling; the table says %s (`ruled` %s)" % [
				cardr, er2, Classes.sits_out_engine(String(cardr)), Classes.sits_out_ruled(String(cardr))])
		ok(Classes.engine_read(String(cardr)) == er2 and Classes.engine_read_ruled(String(cardr)) == "HE §2",
			"§3: %s is not the same ruled row in `ENGINE_READ` (%s, `ruled` %s)" % [
				cardr, Classes.engine_read(String(cardr)), Classes.engine_read_ruled(String(cardr))])
		ok(String(table.get(cardr, {}).get("why", "")) != "", "§3: %s's row carries no why" % cardr)
	for card2 in table:
		ok(RULED.has(card2) or RULED_BY_DESIGNER.has(card2), "§3: %s sits out, and no ruling named it" % card2)
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
			if RULED_BY_DESIGNER.has(card3):
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
	# THE RULED ROW'S PREMISE: met in an earnable pool and NOT refused bare.
	for r4 in RULED_BY_DESIGNER:
		ok(met_ruled.has(r4) and not bool(met_ruled[r4]),
			"§3: %s is a ruled row, and the census %s — the ruling is no longer why it sits out" % [
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
				await s2._resolve(u2, Classes.pool_ability("Guard Change"), foes[0], "good")
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
		every.merge(RULED_BY_DESIGNER)
		for card5 in every:
			if every[card5] != pid:
				continue
			var yes := _usable(s3, u3, Classes.pool_ability(String(card5)))
			ok(yes, "§3: %s does not open for a %s holding %s — a row its engine cannot open is a card nobody can cast" % [
				card5, key3, pid])
			if yes:
				opened += 1
		await _clear(s3)
	ok(opened == RULED.size() + RULED_BY_DESIGNER.size(),
		"§3: %d of %d rows opened with their engine held" % [opened, RULED.size() + RULED_BY_DESIGNER.size()])
	# (e) THE DRIVE, ONE ENGINE AT A TIME, THROUGH THE REAL DOORS.
	for pid2 in ["permafrost", "resonance", "mercy", "conviction", "old_gods", "pack"]:
		await _drive(pid2)


# Taken under the engine, dropped through the pouch's door, kept, still carried
# and counted, not seated, the fight runs, the screens say why, the save carries
# it; slotted again, seated again.
func _drive(pid: String) -> void:
	var key := Classes.engine_class(pid)
	var seat := SEATS.find(key)
	var rows: Array = RULED.keys().filter(func(c): return RULED[c] == pid) \
		+ RULED_BY_DESIGNER.keys().filter(func(c): return RULED_BY_DESIGNER[c] == pid)
	var control := String(CONTROL.get(key, ""))
	_seat_party()
	_run.zone_bosses_cleared = 3
	var m: Dictionary = _run.party[seat]
	var rune := Runes.build(Runes.engine_rune_id(pid))
	_run.hold_rune(m, rune)
	ok(Runes.held_engines(m) == [pid], "§3 %s: the rune did not slot (%s)" % [pid, str(Runes.held_engines(m))])
	# THROUGH THE DOORS A PLAYER USES: the draft's for a pool card, the boss
	# pick's one writer for a zone-boss card.
	var drafted := Classes.draft_pool(key)
	for card in rows + [control]:
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
	ok(carried_before.size() == rows.size() + 1, "§3 %s: carrying %s" % [pid, str(carried_before)])
	# HELD: every row seated.
	var got: Array = await _bar(seat, m)
	for card2 in rows + [control]:
		ok(got.has(card2), "§3 %s: holding the engine, the fight does not seat %s (%s)" % [pid, card2, str(got)])
	# DROPPED, THROUGH THE POUCH'S DOOR.
	ok(bool(_run.toggle_engine(m, 0)) and Runes.held_engines(m).is_empty(),
		"§3 %s: the pouch's door did not drop the engine" % pid)
	ok((m.get("engines", []) as Array).size() == 1, "§3 %s: dropping the engine lost the rune" % pid)
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
	ok(sat == want and seated == [control], "§3 %s: sitting out %s and seated %s" % [pid, str(sat), str(seated)])
	var got2: Array = await _bar(seat, m, true)
	for card3 in rows:
		ok(not got2.has(card3), "§3 %s: with the engine dropped the fight still seats %s" % [pid, card3])
	ok(got2.has(control), "§3 %s: with the engine dropped the fight does not seat %s either" % [pid, control])
	# THE SCREENS SAY WHY.
	await _screens_say_why(pid, seat, rows)
	# THE SAVE CARRIES IT.
	_run.save_run()
	ok(_run.load_run(), "§3 %s: the harness save did not load back" % pid)
	var m2: Dictionary = _run.party[seat]
	ok(m2.get("bm_abilities", []) == pool_before and _run.equipped_ability_names(m2) == carried_before
			and Runes.held_engines(m2).is_empty() and (m2.get("engines", []) as Array).size() == 1,
		"§3 %s: the save did not carry the kept cards and the dropped rune" % pid)
	# BENCHING IS THE PLAYER'S DOOR TO THE SLOT, AND IT IS REVERSIBLE.
	ok(_run.unequip_earned_ability(m2, String(rows[0])) and int(_run.ability_slots_used(m2)) == slots_before - 1,
		"§3 %s: benching %s did not free its slot" % [pid, rows[0]])
	ok(_run.equip_earned_ability(m2, String(rows[0])) and int(_run.ability_slots_used(m2)) == slots_before,
		"§3 %s: carrying %s again did not take the slot back" % [pid, rows[0]])
	# SLOTTED AGAIN, SEATED AGAIN.
	ok(bool(_run.toggle_engine(m2, 0)) and Runes.held_engines(m2) == [pid],
		"§3 %s: the pouch's door did not slot the engine back" % pid)
	ok(_run.sitting_out_names(m2).is_empty(), "§3 %s: cards still sit out with the engine back" % pid)
	var got3: Array = await _bar(seat, m2)
	for card4 in rows:
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
	_run.zone_bosses_cleared = 3
	_run.active = true
	return names


func _screens_say_why(pid: String, seat: int, rows: Array) -> void:
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
