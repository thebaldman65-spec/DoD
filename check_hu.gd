# BATCH HU — THE BAR PAGES, DOWNWIND IS BOUNDED, AND EVERY ROUTE A CHILL OR A BURN TAKES.
#
# What this gate asserts, section by section (`docs/reports/HU.md` has the working):
#
#   §1  THE ABILITIES LIST PAGES (ruled by the designer: a pager, not a slider). A page is
#       the rows the hotkeys reach, and a full page with its pager row clears the top of the
#       screen. The widest menu a hero can raise in normal play — kit, both core runes'
#       enablers, a full slot ladder — fits one page, and the real scene builds it with NO
#       pager. Under the debug menu's unlock-all the list pages: the marker, the arrows dark
#       at each end, every card on exactly one page at a fixed place, the page kept between
#       builds — and a card on page two is CAST through the real turn: the skill-check bar
#       opens for it, a press resolves it, its cooldown starts, as a page-one card's does.
#       The cooldown wash and the refusal tooltip read the same on a paged card.
#   §2  EVERY ROUTE BY WHICH A CHILL OR A BURN TAKES HOLD REACHES `_conjoin`. The source:
#       the status door is the one writer of either. The cards: every card in the corpus
#       is cast on a board where Burn stands and again where Chilled stands, and any cast
#       that lands the other forms a Rupture there. The carriers and riders, driven one by
#       one: Downwind, Frostbind's mate, Rime's echo, Returned Burden, Hoarfrost Armor's and
#       Immolate's strikers, and an enemy's Burn on a hero the bargain chilled. And a frost
#       card that lays no chill forms nothing — Rime's own cast.
#   §3  DOWNWIND IS BOUNDED (ruled): a copied hold is an ordinary timed freeze, never a hold,
#       Carrion or not; the hold still holds its own enemy. The copy drops the boss override:
#       a Perfect Pommel Strike still stuns its own unbroken boss, and the copy does not —
#       and a Broken boss takes the copy, so the copy still carries the stun.
#   §4  EVERY STATUS'S CHIP IS ITS OWN: no two statuses share a tag's letters, a counter's
#       included (Bleed's Bl<n>, Chilled's C<n>, Faith's Fa<n>) — Frostbite and Frostbind,
#       Blighted and Bleed by name. And BROKEN IS NOT A DEBUFF *Mitigation per Debuff You
#       Carry* COUNTS (ruled), matching the breadth count.
#   §5  The ruling recorded where the rules live: a meter state is not a conjunction half.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether a page reads well
# to a player (the report's PNG is the look), and the six card-versus-code magnitudes HT
# found — they are the designer's. `Run` is fetched off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://hu_profile.json"
const SCRATCH_RELICS := "user://hu_relics.json"
# A Warden, a Pyromancer, a Holy and a Survivalist: nobody here chills on his own, and the
# Pyromancer's Flamewave is the one Burn the kit carries — every Burn and Chilled below is
# laid by this gate or by the card under test.
const PARTY := ["warden", "pyromancer", "holy", "mystic"]
const FRAME_CAP := 900

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HU — THE BAR PAGES, DOWNWIND IS BOUNDED, AND EVERY ROUTE A CHILL OR A BURN TAKES")
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
	await _s1_the_bar_pages()
	await _s2_every_route()
	await _s3_downwind_bounded()
	await _s4_chips_and_broken()
	_s5_the_record()
	_run.debug_grant_all = false
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


func _board(specs: Array = PARTY, opts: Dictionary = {}) -> Node:
	var o := {"deterministic": true}
	o.merge(opts, true)
	var scene: Node = await Gate.spawn(self, specs, o)
	Engine.time_scale = 50.0
	return scene


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


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


# A clean body: no status, full health, an unbroken meter — so one drive cannot hand the
# next one a softened board.
func _wipe(u: BattleUnit) -> void:
	u.statuses = []
	u.broken = false
	u.broken_pending = false
	u.pressure = 0
	u.max_hp = maxi(u.max_hp, 100000)
	u.hp = u.max_hp
	u._refresh_chips()


func _engine(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


# ── §1's instruments: the popup a hero's bar opens ─────────────────────────

func _open_bar(scene: Node, h: BattleUnit) -> void:
	scene._show_actions(h)
	await Gate.frames(self, 2)
	scene._open_ability_popup(scene.get("_main_popup"), scene.get("_main_popup_anchor"))
	await Gate.frames(self, 3)


func _list(scene: Node) -> VBoxContainer:
	var popup: PopupPanel = scene.get("_main_popup")
	if popup == null or not is_instance_valid(popup) or popup.get_child_count() == 0:
		return null
	return popup.get_child(0) as VBoxContainer


# The rows of the open list, in order — every child but a pager.
func _rows(scene: Node) -> Array:
	var out: Array = []
	var list := _list(scene)
	if list == null:
		return out
	for c in list.get_children():
		if c is Button:
			out.append(c)
	return out


# The pager row, or null: the list's one HBoxContainer whose middle child is the marker.
func _pager(scene: Node) -> HBoxContainer:
	var list := _list(scene)
	if list == null:
		return null
	for c in list.get_children():
		if c is HBoxContainer and (c as HBoxContainer).get_child_count() == 3 \
				and (c as HBoxContainer).get_child(1) is Label:
			return c
	return null


func _marker(scene: Node) -> String:
	var pg := _pager(scene)
	return "" if pg == null else String((pg.get_child(1) as Label).text)


# What a row's press resolves to: the ability it hands `_on_popup_ability`, or the summon
# group. Read off the button's own binding, never off its face.
func _row_name(btn: Button) -> String:
	for c in btn.pressed.get_connections():
		var cb: Callable = c["callable"]
		if cb.get_method() == "_on_popup_ability":
			var args: Array = cb.get_bound_arguments()
			return String((args[1] as Ability).display_name) if args.size() >= 2 else ""
		if cb.get_method() == "_on_summon_group_pressed":
			return "(summons)"
	return ""


func _row_ability(btn: Button) -> Ability:
	for c in btn.pressed.get_connections():
		var cb: Callable = c["callable"]
		if cb.get_method() == "_on_popup_ability":
			var args: Array = cb.get_bound_arguments()
			return args[1] if args.size() >= 2 else null
	return null


func _entry_name(e: Dictionary) -> String:
	return "(summons)" if e.has("summons") else String((e["ability"] as Ability).display_name)


# Where a control sits on the screen: the popup is a window of its own, so a row's place is
# the window's plus the list's plus its own.
func _screen_y(scene: Node, c: Control) -> float:
	var popup: PopupPanel = scene.get("_main_popup")
	var list := _list(scene)
	return float(popup.position.y) + list.position.y + c.position.y


# The widest Abilities menu a hero can raise in normal play: for every class, every lineage
# and every pair of its core runes (the two engine slots), the opening kit `Classes` builds
# plus a full slot ladder of earned cards, the summons one entry.
func _widest_normal_menu() -> Dictionary:
	var cap: int = int(_run.ABILITY_SLOTS_BY_BOSS[(_run.ABILITY_SLOTS_BY_BOSS as Array).size() - 1])
	var by_class := {"warrior": [], "mage": [], "cleric": [], "hunter": []}
	var rj: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	for rid in rj:
		var row = rj[rid]
		if typeof(row) == TYPE_DICTIONARY and row.has("engine") and not row.has("retired"):
			var sc := String(row.get("scope", ""))
			if sc.begins_with("class:") and by_class.has(sc.substr(6)):
				by_class[sc.substr(6)].append(String(row["engine"]))
	var best := {"entries": 0, "what": ""}
	var shapes := 0
	for ck in by_class:
		var engs: Array = by_class[ck]
		var sets: Array = [[]]
		for a in engs.size():
			sets.append([engs[a]])
			for b in range(a + 1, engs.size()):
				sets.append([engs[a], engs[b]])
		for spec in Classes.SPEC_IDS[ck]:
			for es in sets:
				shapes += 1
				var kit: Array = Classes.opening_kit(ck, spec, es)
				var earned: int = maxi(cap - Classes.kit_slots(ck, spec, es), 0)
				var summons := false
				var others := 0
				for i in range(1, kit.size()):
					if (kit[i] as Ability).special in ["summon", "call_wild"]:
						summons = true
					else:
						others += 1
				var n := 1 + (1 if summons else 0) + others + earned
				if n > int(best["entries"]):
					best = {"entries": n, "what": "%s %s, %d earned" % [spec, str(es), earned]}
	best["shapes"] = shapes
	return best


# ── §1 — THE BATTLE BAR PAGES ──────────────────────────────────────────────

func _s1_the_bar_pages() -> void:
	print("\n§1 — the battle bar pages")
	var probe: Node = await _board()
	var page: int = int(probe.BAR_PAGE_ROWS)
	var keys: int = (probe.ABILITY_KEYS as Array).size()
	# §1a — a page is the rows the keys reach: every key but the basic's own, then shifted.
	ok(page == keys * 2 - 1,
		"§1a: a page holds %d rows, the keys reach %d (every key but the basic's, then shifted)" % [page, keys * 2 - 1])
	var keyed := 0
	for e in range(1, page + 1):
		if String(probe._hotkey_name(e)) != "":
			keyed += 1
	ok(keyed == page and String(probe._hotkey_name(page + 1)) == "",
		"§1a: page one is not exactly the keyed rows — %d of its %d rows keyed, the next row's key '%s'" % [
			keyed, page, String(probe._hotkey_name(page + 1))])
	var widest := _widest_normal_menu()
	print("    the widest menu in normal play: %d entries (%s), over %d shapes; a page and the basic hold %d" % [
		int(widest["entries"]), widest["what"], int(widest["shapes"]), page + 1])
	ok(int(widest["shapes"]) >= 100, "§1a: the ceiling walk read %d hero shapes" % int(widest["shapes"]))
	# A TRIPWIRE, SAID SO: the day a hero can hold more than a page in normal play — a crest
	# that grants cards, a wider ladder — the pager is reachable without the debug menu, which
	# is a fact worth a batch saying out loud; re-point this arm then, do not loosen it.
	ok(int(widest["entries"]) <= page + 1,
		"§1a: in normal play a hero raises a %d-entry menu (%s) — more than one page; the pager is live without the debug menu" % [
			int(widest["entries"]), widest["what"]])
	# §1b — the pager exists only when the list overflows: an ordinary bar builds none.
	var w: BattleUnit = _hero(probe, "warrior")
	await _open_bar(probe, w)
	var plain_rows := _rows(probe)
	ok(not plain_rows.is_empty() and _pager(probe) == null,
		"§1b: an ordinary bar (%d rows) built a pager" % plain_rows.size())
	await _clear(probe)
	# The widest legal bar on the real scene: a Berserker holding both Warrior core runes that
	# bring an enabler, at the last rung of the ladder.
	var ceiling: Node = await _ceiling_board()
	var bz: BattleUnit = _hero(ceiling, "warrior")
	await _open_bar(ceiling, bz)
	var c_entries: Array = ceiling.get("_menu_entries")
	var c_rows := _rows(ceiling)
	var c_off := 0
	var c_unkeyed := 0
	for r in c_rows.size():
		if _screen_y(ceiling, c_rows[r]) < 0.0:
			c_off += 1
		if String(ceiling._hotkey_name(r + 1)) == "":
			c_unkeyed += 1
	print("    the ceiling bar on the real scene: %d entries, %d rows" % [c_entries.size(), c_rows.size()])
	ok(c_entries.size() == int(widest["entries"]),
		"§1b: the constructed ceiling bar raised %d entries, the walk's widest is %d" % [c_entries.size(), int(widest["entries"])])
	ok(_pager(ceiling) == null, "§1b: the widest normal bar (%d entries) built a pager" % c_entries.size())
	ok(c_off == 0, "§1b: %d of the widest normal bar's rows sit above the screen" % c_off)
	ok(c_unkeyed == 0, "§1b: %d of the widest normal bar's rows have no key" % c_unkeyed)
	await _clear(ceiling)
	# §1c — unlock-all overflows, and the list pages.
	_run.debug_grant_all = true
	var s: Node = await _board()
	_run.debug_grant_all = false
	var h: BattleUnit = s.get("current_hero")
	ok(h != null, "§1c: no hero's turn was waiting on a press")
	if h == null:
		await _clear(s)
		return
	h.resource = 99999
	var entries: Array = s.get("_menu_entries")
	await _open_bar(s, h)
	entries = s.get("_menu_entries")
	var rows_total := entries.size() - 1
	var pages := int(ceil(float(rows_total) / float(page)))
	print("    %s under unlock-all: %d entries, %d rows, %d pages" % [h.unit_name, entries.size(), rows_total, pages])
	ok(pages >= 2, "§1c: unlock-all left %s's list on one page (%d rows)" % [h.unit_name, rows_total])
	ok(_marker(s) == "1 of %d" % pages, "§1c: the marker reads '%s', want '1 of %d'" % [_marker(s), pages])
	var pg := _pager(s)
	ok(pg != null and (pg.get_child(0) as Button).disabled,
		"§1c: on page one the previous arrow is not dark")
	ok(pg != null and not (pg.get_child(2) as Button).disabled,
		"§1c: on page one the next arrow is dark")
	# Every page: its rows are the entries that belong there, in order, and on screen.
	var seen: Array = []
	var first_page: Array = []
	var wrong := ""
	var above := 0
	for p in pages:
		var names: Array = []
		for b in _rows(s):
			names.append(_row_name(b))
			if _screen_y(s, b) < 0.0:
				above += 1
		var want: Array = []
		for e in range(1 + p * page, mini(1 + (p + 1) * page, entries.size())):
			want.append(_entry_name(entries[e]))
		if names != want and wrong == "":
			wrong = "page %d shows %s, its entries are %s" % [p + 1, str(names.slice(0, 3)), str(want.slice(0, 3))]
		if p == 0:
			first_page = names.duplicate()
		seen.append_array(names)
		var pgr := _pager(s)
		if pgr != null and pgr.get_child(1) is Label and _screen_y(s, pgr) < 0.0:
			above += 1
		if p < pages - 1:
			if pgr == null or (pgr.get_child(2) as Button).disabled:
				wrong = "page %d has no live next arrow" % (p + 1)
				break
			(pgr.get_child(2) as Button).pressed.emit()
			await Gate.frames(self, 3)
	ok(wrong == "", "§1c: %s" % wrong)
	ok(above == 0, "§1c: %d rows of a full page sit above the screen" % above)
	var all_rows: Array = []
	for e2 in range(1, entries.size()):
		all_rows.append(_entry_name(entries[e2]))
	var first_diff := -1
	for k in mini(seen.size(), all_rows.size()):
		if seen[k] != all_rows[k]:
			first_diff = k
			break
	if first_diff < 0 and seen.size() != all_rows.size():
		first_diff = mini(seen.size(), all_rows.size())
	ok(seen == all_rows, "§1c: the pages hold %d rows against the list's %d; the first that differs is row %d — '%s' where the list has '%s'" % [
		seen.size(), all_rows.size(), first_diff + 1,
		String(seen[first_diff]) if first_diff >= 0 and first_diff < seen.size() else "<none>",
		String(all_rows[first_diff]) if first_diff >= 0 and first_diff < all_rows.size() else "<none>"])
	ok(_marker(s) == "%d of %d" % [pages, pages], "§1c: the last page's marker reads '%s'" % _marker(s))
	var pgl := _pager(s)
	ok(pgl != null and (pgl.get_child(2) as Button).disabled, "§1c: on the last page the next arrow is not dark")
	# Back to page one: the same cards in the same places.
	for _back in pages - 1:
		var pgb := _pager(s)
		if pgb == null:
			break
		(pgb.get_child(0) as Button).pressed.emit()
		await Gate.frames(self, 3)
	var again: Array = []
	for b2 in _rows(s):
		again.append(_row_name(b2))
	ok(again == first_page, "§1c: page one turned back to shows %s, it showed %s" % [str(again.slice(0, 3)), str(first_page.slice(0, 3))])
	# The page is kept between builds: turn to two, rebuild the bar as a turn does, still two.
	var pgk := _pager(s)
	if pgk != null:
		(pgk.get_child(2) as Button).pressed.emit()
		await Gate.frames(self, 3)
	await _open_bar(s, h)
	ok(_marker(s) == "2 of %d" % pages, "§1c: rebuilt after turning to page two, the list reads '%s'" % _marker(s))
	# §1d — a card on page two is CAST through the real turn. The turn is parked on its pick;
	# the row's own press hands the card over, the target is picked, and the skill-check bar
	# opens for it exactly as for a page-one card; a centred press resolves it. A hero whose
	# page holds no such card passes his turn with his basic attack, and the next is asked.
	var paged := await _a_turn_with(s, 1)
	ok(not paged.is_empty(), "§1d: no hero's page two held a damaging card the door lets him cast")
	if paged.is_empty():
		await _clear(s)
		return
	h = paged["hero"]
	var cast: Button = paged["row"]
	var cast_ab := _row_ability(cast)
	var drive := await _cast_through_the_bar(s, h, cast, cast_ab)
	ok(bool(drive["bar"]), "§1d: the skill-check bar did not open for %s, a page-two card" % cast_ab.display_name)
	ok(bool(drive["resolved"]), "§1d: %s, pressed on page two, did not resolve (%s)" % [cast_ab.display_name, drive["why"]])
	ok(h.cooldown_left(cast_ab) > 0 or cast_ab.cooldown <= 0,
		"§1d: %s resolved and started no cooldown" % cast_ab.display_name)
	print("    page two: %s cast %s through the bar — the check opened %s, resolved %s, cooling %d" % [h.unit_name,
		cast_ab.display_name, drive["bar"], drive["resolved"], h.cooldown_left(cast_ab)])
	# The control: a page-one card, on the turn that comes next, opens the same bar.
	var plain := await _a_turn_with(s, 0)
	ok(not plain.is_empty(), "§1d: no later turn's page one held a damaging card to cast")
	if not plain.is_empty():
		var ab1 := _row_ability(plain["row"])
		var d1 := await _cast_through_the_bar(s, plain["hero"], plain["row"], ab1)
		ok(bool(d1["bar"]), "§1d: the control — the bar did not open for %s on page one" % ab1.display_name)
		ok(bool(d1["resolved"]), "§1d: the control — %s on page one did not resolve (%s)" % [ab1.display_name, d1["why"]])
		print("    page one, the control: %s cast %s — the check opened %s, resolved %s" % [
			(plain["hero"] as BattleUnit).unit_name, ab1.display_name, d1["bar"], d1["resolved"]])
	# The turn loop runs on between casts: let it park on the next press before any bar below is
	# read, so no turn of its own rebuilds the list under the reads.
	await _hero_turn(s)
	# §1e — the cooldown wash reads the same on page two as on page one: the paged card just
	# cast sits dark with its count, and a page-one card put on a cooldown reads the same.
	s.set("_bar_page", {h: 1})
	await _open_bar(s, h)
	var washed: Button = null
	for b3 in _rows(s):
		if _row_ability(b3) == cast_ab:
			washed = b3
	var cd_left := h.cooldown_left(cast_ab)
	ok(washed != null and washed.disabled and washed.text.contains("(CD %d)" % cd_left),
		"§1e: %s on page two, cooling %d, reads '%s' (disabled %s)" % [cast_ab.display_name, cd_left,
			washed.text if washed != null else "<no row>", str(washed.disabled) if washed != null else "-"])
	var p1_ab: Ability = null
	for e3 in range(1, mini(1 + page, entries.size())):
		var ent: Dictionary = (s.get("_menu_entries") as Array)[e3]
		if ent.has("ability") and (ent["ability"] as Ability).cooldown > 0:
			p1_ab = ent["ability"]
			break
	ok(p1_ab != null, "§1e: page one holds no card with a cooldown to compare")
	if p1_ab != null:
		h.cooldowns[p1_ab.display_name] = cd_left
		s.set("_bar_page", {h: 0})
		await _open_bar(s, h)
		var p1_btn: Button = null
		for b4 in _rows(s):
			if _row_ability(b4) == p1_ab:
				p1_btn = b4
		ok(p1_btn != null and p1_btn.disabled and p1_btn.text.contains("(CD %d)" % cd_left),
			"§1e: the page-one control %s, cooling %d, reads '%s'" % [p1_ab.display_name, cd_left,
				p1_btn.text if p1_btn != null else "<no row>"])
		h.cooldowns.erase(p1_ab.display_name)
	# The refusal tooltip: a recast-gated card past page one, saturated where it writes, is dark
	# and says why — the same words `_recast_refusal_note` gives page one.
	var refused := await _a_refused_paged_card(s)
	ok(not refused.is_empty(), "§1e: no hero's bar holds a recast-gated card past page one to refuse")
	if not refused.is_empty():
		print("    refused on page %d: %s — dark %s, the tooltip ends '%s'" % [int(refused["page"]) + 1, refused["card"],
			refused["disabled"], String(refused["tip"]).right(70).replace("\n", " ")])
	if not refused.is_empty():
		ok(bool(refused["disabled"]) and String(refused["tip"]).contains(String(refused["note"]))
				and String(refused["note"]) != "",
			"§1e: %s on page %d, refused, reads dark %s with tooltip '%s' — want the refusal '%s'" % [
				refused["card"], int(refused["page"]) + 1, refused["disabled"],
				String(refused["tip"]).right(60), refused["note"]])
	# §1f — the keys keep their slots whatever page shows, and no key turns a page: with page
	# two showing, a hotkey hands over its own page-one card, and the list stays where it was.
	var kh: BattleUnit = await _hero_turn(s)
	ok(kh != null, "§1f: no hero's turn was waiting on a press")
	if kh != null:
		kh.resource = 99999
		s.set("_bar_page", {kh: 1})
		await _open_bar(s, kh)
		var k_entries: Array = s.get("_menu_entries")
		var k_idx := -1
		for ki in range(1, mini((s.ABILITY_KEYS as Array).size(), k_entries.size())):
			var ke: Dictionary = k_entries[ki]
			if ke.has("ability") and (ke["ability"] as Ability).target == Ability.Target.ENEMY \
					and bool(s._ability_usable(kh, ke["ability"])):
				k_idx = ki
				break
		ok(k_idx > 0, "§1f: %s's keyed slots hold no castable card aimed at an enemy" % kh.unit_name)
		if k_idx > 0:
			var got := []
			s._ability_picked.connect(func(ab): got.append(ab), CONNECT_ONE_SHOT)
			s._try_ability_hotkey((s.ABILITY_KEYS as Array)[k_idx], false)
			await Gate.frames(self, 2)
			var want: Ability = (k_entries[k_idx] as Dictionary)["ability"]
			ok(got.size() == 1 and got[0] == want,
				"§1f: with page two showing, key %s handed over %s — want its own slot's %s" % [
					s._hotkey_name(k_idx), str(got.map(func(x): return x.display_name)), want.display_name])
			ok(int((s.get("_bar_page") as Dictionary).get(kh, -1)) == 1,
				"§1f: the key turned the list off page two")
			print("    the keyboard: with page two showing, %s handed over %s, its own slot; the list stayed on page two" % [
				s._hotkey_name(k_idx), want.display_name])
			if not (s.get("_kb_pool") as Array).is_empty():
				s._target_picked.emit(null)
				await Gate.frames(self, 2)
	await _clear(s)


# A Berserker holding the two Warrior core runes that bring an enabler, at the ladder's last
# rung, with a full ladder of earned cards that sit in (none waits on an engine he lacks).
func _ceiling_board() -> Node:
	var cap: int = int(_run.ABILITY_SLOTS_BY_BOSS[(_run.ABILITY_SLOTS_BY_BOSS as Array).size() - 1])
	var engs := ["engine_berserker", "engine_swordmaster"]
	var eng_ids: Array = engs.map(func(x): return String(Runes.config(x).get("engine", "")))
	var kit: Array = Classes.opening_kit("warrior", "berserker", eng_ids)
	var kit_names: Array = kit.map(func(a): return a.display_name)
	var want: int = cap - Classes.kit_slots("warrior", "berserker", eng_ids)
	var cards: Array = []
	for nm in Classes.draft_pool("warrior"):
		if cards.size() >= want:
			break
		if kit_names.has(nm) or Classes.spec_pool_ability("berserker", String(nm)) == null:
			continue
		var probe_m := {"key": "warrior", "spec": "berserker", "bm_abilities": [nm], "bm_equipped": [nm],
			"engines": engs.map(func(x): return _engine(x))}
		if (_run.seated_ability_names(probe_m) as Array).has(nm):
			cards.append(nm)
	var over := {0: {"engines": engs.map(func(x): return _engine(x)), "bm_abilities": cards,
		"bm_equipped": cards.duplicate()}}
	return await _board(["berserker", "pyromancer", "holy", "mystic"], {"party": over})


# A row on the list as it stands whose card deals damage to an enemy, runs the skill check,
# carries a cooldown and is castable now.
func _a_castable_row(s: Node, h: BattleUnit) -> Button:
	for b in _rows(s):
		var ab := _row_ability(b)
		if ab == null or b.disabled:
			continue
		if ab.target == Ability.Target.ENEMY and ab.damage > 0 and ab.runs_skill_check() \
				and ab.cooldown > 0 and not ab.aoe and ab.random_hits == 0 and not ab.choose_two \
				and not ab.choose_three and ab.special == "" and bool(s._ability_usable(h, ab)):
			return b
	return null


# The real cast: the row's press, the target's pick, the bar opened, a centred press.
func _cast_through_the_bar(s: Node, h: BattleUnit, row: Button, ab: Ability) -> Dictionary:
	var out := {"bar": false, "resolved": false, "why": ""}
	var foe: BattleUnit = _foes(s)[0]
	var log_was := _log_text(s).length()
	row.pressed.emit()
	var waited := 0
	while (s.get("_kb_pool") as Array).is_empty() and waited < FRAME_CAP:
		await process_frame
		waited += 1
	if (s.get("_kb_pool") as Array).is_empty():
		out["why"] = "no target was asked for"
		return out
	s._target_picked.emit(foe)
	waited = 0
	while not bool(s.get("sc_active")) and waited < FRAME_CAP:
		await process_frame
		waited += 1
	out["bar"] = bool(s.get("sc_active")) and bool(s.get("sc_root").visible)
	if not out["bar"]:
		out["why"] = "the bar never opened"
		return out
	s.set("sc_pos", float((s.get("sc_profile") as Dictionary)["centre"]))
	s._grade_skill_check()
	waited = 0
	while waited < FRAME_CAP and not _log_text(s).substr(log_was).contains("%s: %s" % [h.unit_name, ab.display_name]):
		await process_frame
		waited += 1
	out["resolved"] = _log_text(s).substr(log_was).contains("%s: %s" % [h.unit_name, ab.display_name])
	if not out["resolved"]:
		out["why"] = "the log never named it"
	return out


# The hero whose turn is parked on a press, once the turn loop has handed one over.
func _hero_turn(s: Node) -> BattleUnit:
	var waited := 0
	while waited < FRAME_CAP:
		var cur: BattleUnit = s.get("current_hero")
		if cur != null and not cur.dead and bool(s.get("action_panel").visible) \
				and not bool(s.get("sc_active")) and (s.get("_kb_pool") as Array).is_empty():
			return cur
		await process_frame
		waited += 1
	return null


# Passes a turn the way a player would who wanted nothing on it: the basic attack, aimed.
func _pass_turn(s: Node, cur: BattleUnit) -> void:
	s._on_ability_button(cur.abilities[0])
	var waited := 0
	while (s.get("_kb_pool") as Array).is_empty() and waited < FRAME_CAP:
		await process_frame
		waited += 1
	if not (s.get("_kb_pool") as Array).is_empty():
		s._target_picked.emit(_foes(s)[0])
	await Gate.frames(self, 2)


# The first hero turn, from now, whose list shows a castable damaging card on page `page`,
# passing every turn before it. {} when none comes in a handful of turns.
func _a_turn_with(s: Node, page: int) -> Dictionary:
	for _turn in 8:
		var cur: BattleUnit = await _hero_turn(s)
		if cur == null:
			return {}
		cur.resource = 99999
		s.set("_bar_page", {cur: page})
		await _open_bar(s, cur)
		var row := _a_castable_row(s, cur)
		if row != null:
			return {"hero": cur, "row": row}
		await _pass_turn(s, cur)
	return {}


# A recast-gated card on some hero's list past page one, saturated where its cast writes so
# the door refuses a second — read off the list as that hero's bar builds it.
func _a_refused_paged_card(s: Node) -> Dictionary:
	var page: int = int(s.BAR_PAGE_ROWS)
	for hh in s.get("heroes"):
		var u: BattleUnit = hh
		if u.dead or u.is_companion:
			continue
		u.resource = 99999
		s.set("_bar_page", {})
		await _open_bar(s, u)
		var entries: Array = s.get("_menu_entries")
		for e in range(1 + page, entries.size()):
			var ent: Dictionary = entries[e]
			if not ent.has("ability"):
				continue
			var ab: Ability = ent["ability"]
			if not (s.RECAST_GATED as Array).has(ab.special):
				continue
			var wrote := false
			for t in s._recast_targets(u, ab):
				for wr in s._recast_writes(u, ab, t):
					s._apply_status(t, String(wr["id"]), int(wr["turns"]), int(wr["power"]), 0, u)
					wrote = true
			if not wrote or not bool(s._recast_refused(u, ab)):
				continue
			var pg := int((e - 1) / page)
			s.set("_bar_page", {u: pg})
			await _open_bar(s, u)
			for b in _rows(s):
				if _row_ability(b) == ab:
					return {"card": ab.display_name, "page": pg, "disabled": b.disabled,
						"tip": b.tooltip_text, "note": String(s._recast_refusal_note(u, ab))}
	return {}


# ── §2 — EVERY ROUTE A CHILL OR A BURN TAKES REACHES `_conjoin` ─────────────

func _s2_every_route() -> void:
	print("\n§2 — every route by which a chill or a burn takes hold reaches the composition")
	_s2a_the_source()
	await _s2b_every_card()
	await _s2c_the_carriers()


# §2a — the status door is the one writer of a Burn or a Chill. Comments stripped, literals kept.
func _s2a_the_source() -> void:
	var b := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var u := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var lit_writes := 0
	for src in [b, u]:
		for id in ["burn", "chilled"]:
			lit_writes += String(src).count("add_status(\"%s\"" % id)
	ok(lit_writes == 0, "§2a: %d add_status calls write a Burn or a Chilled by name, around the status door" % lit_writes)
	# Every add_status whose id is not a literal: the door's, and the engine chip's — no other.
	var re := RegEx.new()
	re.compile("(?<!func )add_status\\(\\s*([^\"\\s][^,]*),")
	var variable: Array = []
	for src2 in [b, u]:
		for m in re.search_all(String(src2)):
			variable.append(m.get_string(1).strip_edges())
	variable.sort()
	ok(variable == ["id", "u.engine_chip_id(String(pid))"],
		"§2a: the add_status calls with a variable id are %s — want the status door's and the engine chip's" % [variable])
	# The door: the arriving status is added, then the composition is asked, before any return.
	var at := b.find("target.add_status(id, info[0], info[1], info[2], eff_turns, info[3], power, tick)")
	var conj := b.find("_conjoin(target, id, src)", at)
	var ret := b.find("return", at)
	ok(at > 0 and conj > at and (ret < 0 or conj < ret),
		"§2a: the status door does not ask `_conjoin` between adding a status and its first return")
	# A direct write into a body's status list: the door's own add, the composition's two, the bleed chip.
	var appends := u.count("statuses.append(") + b.count("statuses.append(")
	var inserts := u.count("statuses.insert(") + b.count("statuses.insert(")
	ok(appends == 2 and inserts == 2,
		"§2a: %d appends and %d inserts write a body's status list — want the door's and the bleed chip's, compose's and dissolve's" % [appends, inserts])


# §2b — every card in the corpus, cast on a board where Burn stands and again where Chilled
# stands. A cast that lands the other must form a Rupture on that body.
func _s2b_every_card() -> void:
	var s: Node = await _board(["warden", "pyromancer", "occultist", "mystic"],
		{"party": {1: {"engines": [_engine("engine_pyromancer"), _engine("engine_cryomancer")]},
			3: {"engines": [_engine("engine_mystic")]}}})
	Engine.time_scale = 100.0
	var by_class := {"warrior": _hero(s, "warrior"), "mage": _hero(s, "mage"), "cleric": _hero(s, "cleric"),
		"hunter": _hero(s, "hunter")}
	var owner := {}
	for ck in by_class:
		var names: Array = Classes.draft_pool(ck) + Classes.class_kit_names(ck)
		for sp in Classes.SPEC_IDS[ck]:
			names += Classes.spec_pool(sp) + Classes.core_enablers(sp)
			for a in Classes.spec_abilities(sp):
				if a != null:
					names.append(a.display_name)
		for nm in names:
			if not owner.has(nm):
				owner[nm] = ck
	var driven := 0
	var formed_chill: Array = []
	var formed_burn: Array = []
	var around: Array = []
	for cab in Classes.ability_corpus():
		var nm2: String = cab.display_name
		if not owner.has(nm2):
			continue
		var caster: BattleUnit = by_class[owner[nm2]]
		var ab: Ability = s._find_ability(caster, nm2)
		if ab == null:
			ab = Classes.pool_ability(nm2)
			caster.abilities.append(ab)
		for standing in ["burn", "chilled"]:
			var r := await _census_cast(s, caster, ab, standing)
			if bool(r["refused"]):
				continue
			driven += 1
			if int(r["landed"]) > int(r["formed"]):
				around.append("%s (%s standing: landed on %d, formed on %d)" % [nm2, standing, r["landed"], r["formed"]])
			if int(r["formed"]) > 0:
				(formed_chill if standing == "burn" else formed_burn).append(nm2)
	print("    %d casts driven; a Chill landed on a burning body by %s; a Burn on a chilled one by %s" % [
		driven, str(formed_chill), str(formed_burn)])
	ok(driven >= 300, "§2b: the census drove %d casts" % driven)
	ok(formed_chill.size() >= 4 and formed_burn.size() >= 5,
		"§2b: the census formed Ruptures off %d chilling and %d burning cards" % [formed_chill.size(), formed_burn.size()])
	ok(around.is_empty(), "§2b: a cast landed the other status and no Rupture formed: %s" % str(around))
	await _clear(s)


func _census_cast(s: Node, caster: BattleUnit, ab: Ability, standing: String) -> Dictionary:
	for u in (s.get("heroes") as Array) + (s.get("enemies") as Array):
		if not u.dead:
			_wipe(u)
			u.cooldowns.clear()
	(s.get("_holds") as Array).clear()
	var mage: BattleUnit = _hero(s, "mage")
	var war: BattleUnit = _hero(s, "warrior")
	for e in _foes(s):
		if standing == "burn":
			s._apply_status(e, "burn", 5, 0, 6, mage)
		else:
			s._apply_status(e, "chilled", 3, 0, 0, war)
	caster.resource = 99999
	caster.second_resource = maxi(caster.second_resource, 5)
	var tgt: BattleUnit = _foes(s)[0] if ab.target == Ability.Target.ENEMY else caster
	if not bool(s._ability_usable(caster, ab)):
		return {"refused": true}
	seed(7)
	await s._resolve(caster, ab, tgt, "good")
	var other := "chilled" if standing == "burn" else "burn"
	var landed := 0
	var formed := 0
	for e2 in _foes(s):
		if e2.has_status(other):
			landed += 1
			if not e2.composition_of(other).is_empty():
				formed += 1
	return {"refused": false, "landed": landed, "formed": formed}


# §2c — the carriers and riders, one by one: each lands its status on a body carrying the
# other, and the Rupture forms there with its line in the log.
func _s2c_the_carriers() -> void:
	var s: Node = await _board(["warden", "cryomancer", "holy", "mystic"],
		{"party": {2: {"runes": [_engine("returned_burden")]}}})
	var war: BattleUnit = _hero(s, "warrior")
	var mage: BattleUnit = _hero(s, "mage")
	var cleric: BattleUnit = _hero(s, "cleric")
	var hunter: BattleUnit = _hero(s, "hunter")
	var foes := _foes(s)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	# The second variable-id add_status (§2a) names an engine chip, never a status a
	# conjunction is made of — asked of a hero holding one engine and of one holding none.
	var chip_ids: Array = [mage.engine_chip_id("permafrost"), war.engine_chip_id("nothing")]
	ok(chip_ids.all(func(x): return String(x).begins_with("spec_passive")),
		"§2c: the engine chip's id reads %s" % str(chip_ids))
	var reset := func():
		for u in (s.get("heroes") as Array) + (s.get("enemies") as Array):
			if not u.dead:
				_wipe(u)
		(s.get("_holds") as Array).clear()
	# Downwind: a Burn laid on A is carried to B, the one body not burning, which is chilled.
	reset.call()
	s._apply_status(hunter, "downwind", 4)
	# B's Chill and C's Burn are laid with no applier, so no carry fires before the one under
	# test, and B is the one body the carry can call fresh.
	s._apply_status(b, "chilled", 3)
	s._apply_status(c, "burn", 3, 0, 6)
	var lw := _log_text(s).length()
	s._apply_status(a, "burn", 3, 0, 6, mage)
	_route_formed(s, b, lw, "Downwind's carry of a Burn")
	# Frostbind's mate: A and B bound; B burns; A is chilled, the mate copy chills B.
	reset.call()
	var fb: Ability = Classes.pool_ability("Frostbind")
	s.set("second_target", b)
	mage.resource = 99999
	await s._resolve(mage, fb, a, "good")
	s.set("second_target", null)
	s._apply_status(b, "burn", 3, 0, 6, war)
	lw = _log_text(s).length()
	s._apply_status(a, "chilled", 3, 0, 0, war)
	ok(s._frostbind_partner(a) == b, "§2c: Frostbind did not bind A to B")
	_route_formed(s, b, lw, "Frostbind's mate copy")
	# Rime's echo: Rime on A; B and C burn; a chill on A echoes onto one of them.
	reset.call()
	s._apply_status(a, "rime", 4, 0, 0, mage)
	s._apply_status(b, "burn", 3, 0, 6, war)
	s._apply_status(c, "burn", 3, 0, 6, war)
	lw = _log_text(s).length()
	s._apply_status(a, "chilled", 3, 0, 0, war)
	var echoed: BattleUnit = b if b.has_status("chilled") else c
	_route_formed(s, echoed, lw, "Rime's echo")
	# Returned Burden: the Warden carries A's Chill; A burns; Unburden lifts it and casts it
	# back on the enemy that laid it, which is burning.
	reset.call()
	s._apply_status(war, "chilled", 3, 0, 0, a)
	s._apply_status(a, "burn", 3, 0, 6, mage)
	lw = _log_text(s).length()
	cleric.resource = 99999
	var unb: Ability = s._find_ability(cleric, "Unburden")
	ok(unb != null and cleric.rune_returned_burden > 0.0, "§2c: the Cleric holds no Unburden worn with Returned Burden")
	if unb != null:
		await s._resolve(cleric, unb, war, "good")
		_route_formed(s, a, lw, "Returned Burden's cast-back")
	# Hoarfrost Armor's striker: the Mage wears it; a burning enemy strikes him and is chilled.
	reset.call()
	var ha: Ability = Classes.pool_ability("Hoarfrost Armor")
	await s._resolve(mage, ha, mage, "good")
	s._apply_status(a, "burn", 3, 0, 6, war)
	lw = _log_text(s).length()
	a.resource = 99999
	await s._resolve(a, a.abilities[0], mage, "good")
	_route_formed(s, a, lw, "Hoarfrost Armor's chill on a striker")
	# Immolate's striker: the Warden is Immolated; a chilled enemy strikes him and burns.
	reset.call()
	s._apply_status(war, "immolate", 3, 0, 0, mage)
	s._apply_status(a, "chilled", 3, 0, 0, mage)
	lw = _log_text(s).length()
	await s._resolve(a, a.abilities[0], war, "good")
	_route_formed(s, a, lw, "Immolate's Burn on a striker")
	# The hero side: the bargain's Chill (no applier) and then an enemy's Burn.
	reset.call()
	s._apply_status(war, "chilled", 3)
	lw = _log_text(s).length()
	s._apply_status(war, "burn", 2, 0, 6, a)
	_route_formed(s, war, lw, "an enemy's Burn on a hero the bargain chilled")
	# A frost card that lays no chill forms nothing: Rime's own cast on a burning enemy lays
	# Rime and Frostbite, and neither is half of anything.
	reset.call()
	s._apply_status(a, "burn", 3, 0, 6, war)
	lw = _log_text(s).length()
	var rime: Ability = Classes.pool_ability("Rime")
	mage.resource = 99999
	await s._resolve(mage, rime, a, "good")
	ok(a.has_status("rime") and a.has_status("frostbite") and not a.has_status("chilled"),
		"§2c: Rime's cast on a burning enemy left %s — want Rime and Frostbite and no Chill" % [
			(a.statuses as Array).map(func(x): return String(x.id))])
	ok(a.composition_of("burn").is_empty() and not _log_text(s).substr(lw).contains("Rupture forms on"),
		"§2c: Rime's cast formed a Rupture")
	# A freeze's rewrite of the pile is no arrival: on a body with no chill it writes nothing.
	reset.call()
	b.set_chilled_stacks(3)
	ok(not b.has_status("chilled"), "§2c: set_chilled_stacks laid a Chill on a body that carried none")
	# ...and on a Rupture's chill it writes the pile inside, and the Rupture stands.
	s._apply_status(b, "burn", 3, 0, 6)
	s._apply_status(b, "chilled", 3)
	b.set_chilled_stacks(3)
	ok(not b.composition_of("chilled").is_empty() and b.status_stacks("chilled") == 3,
		"§2c: set_chilled_stacks on a Rupture's chill left it x%d inside %s" % [b.status_stacks("chilled"),
			str((b.statuses as Array).map(func(x): return String(x.id)))])
	await _clear(s)


func _route_formed(s: Node, body: BattleUnit, log_from: int, route: String) -> void:
	var line := _log_text(s).substr(log_from)
	print("    %s: Rupture on %s %s; forming line %s" % [route, body.unit_name,
		not body.composition_of("burn").is_empty(), line.contains("Rupture forms on %s" % body.unit_name)])
	ok(not body.composition_of("burn").is_empty(),
		"§2c: %s — no Rupture on %s (%s)" % [route, body.unit_name, str((body.statuses as Array).map(func(x): return String(x.id)))])
	ok(line.contains("Rupture forms on %s" % body.unit_name),
		"§2c: %s — the log has no forming line for %s" % [route, body.unit_name])


# ── §3 — DOWNWIND IS BOUNDED ───────────────────────────────────────────────

func _s3_downwind_bounded() -> void:
	print("\n§3 — Downwind is bounded")
	for carrion in [false, true]:
		var over := {}
		if carrion:
			over = {3: {"runes": [_engine("carrion")]}}
		var s: Node = await _board(["warden", "cryomancer", "holy", "mystic"], {"party": over})
		var cryo: BattleUnit = _hero(s, "mage")
		var hunter: BattleUnit = _hero(s, "hunter")
		var foes := _foes(s)
		for f in foes:
			_wipe(f)
		var tag := "with Carrion" if carrion else "without Carrion"
		ok(hunter.rune_carrion > 0 if carrion else hunter.rune_carrion <= 0,
			"§3a: the Hunter's Carrion reads %d %s" % [hunter.rune_carrion, tag])
		s._apply_status(hunter, "downwind", 4)
		var lw := _log_text(s).length()
		s._hold_freeze(foes[0], cryo)
		var holds: Array = s.get("_holds")
		var held: BattleUnit = foes[0]
		ok(holds.has(held) and is_inf(held.next_time) and int(held.get_status("frozen").get("turns", 0)) < 0,
			"§3a %s: the hold does not hold its own enemy (held %s, next %s)" % [tag, holds.has(held), held.next_time])
		var copies: Array = foes.filter(func(f): return f != held and f.has_status("frozen"))
		ok(copies.size() == (foes.size() - 1 if carrion else 1),
			"§3a %s: Downwind froze %d other bodies" % [tag, copies.size()])
		var bad := ""
		for cp in copies:
			var t := int(cp.get_status("frozen").get("turns", 0))
			if holds.has(cp) or t != int(s.ORDINARY_FREEZE_TURNS) or is_inf(cp.next_time):
				bad += "%s (turns %d, held %s, next %s) " % [cp.unit_name, t, holds.has(cp), cp.next_time]
		ok(bad == "", "§3a %s: a copied freeze is not an ordinary timed one: %s" % [tag, bad])
		print("    %s: the hold on %s (held %s, turns %d); %d copies, each Frozen %s turn(s), none held" % [tag,
			held.unit_name, holds.has(held), int(held.get_status("frozen").get("turns", 0)), copies.size(),
			str(copies.map(func(f): return int(f.get_status("frozen").get("turns", 0))))])
		ok(_log_text(s).substr(lw).contains("an ordinary freeze, never a hold"),
			"§3a %s: the carry's line does not say the freeze is an ordinary one" % tag)
		# An ordinary freeze's length later each copy has thawed, and the hold still holds. The
		# arm reads the length off the constant, so a re-tune of the ordinary freeze is not a red.
		for cp2 in copies:
			for _t in int(s.ORDINARY_FREEZE_TURNS):
				cp2.tick_statuses()
		var thawed := copies.filter(func(f): return not f.has_status("frozen")).size()
		ok(thawed == copies.size(), "§3a %s: %d of %d copied freezes outlived a turn" % [tag, copies.size() - thawed, copies.size()])
		ok(holds.has(held) and held.has_status("frozen"), "§3a %s: the hold let go when the copies thawed" % tag)
		await _clear(s)
	# §3b — the boss override stays with its own target. Two bosses, the third body stunned
	# with no applier (so no carry fires and it is not fresh); a Perfect Pommel Strike on boss A.
	var s2: Node = await _board(["warden", "cryomancer", "holy", "mystic"])
	var war: BattleUnit = _hero(s2, "warrior")
	var hunter2: BattleUnit = _hero(s2, "hunter")
	var f2 := _foes(s2)
	for f in f2:
		_wipe(f)
	f2[0].is_boss = true
	f2[1].is_boss = true
	s2._apply_status(f2[2], "stunned", 2)
	s2._apply_status(hunter2, "downwind", 4)
	var pommel: Ability = s2._find_ability(war, "Pommel Strike")
	ok(pommel != null, "§3b: the Warrior holds no Pommel Strike")
	if pommel != null:
		war.resource = 99999
		var lw2 := _log_text(s2).length()
		await s2._resolve(war, pommel, f2[0], "perfect")
		ok(f2[0].has_status("stunned"), "§3b: the Perfect Pommel Strike did not stun its own unbroken boss")
		ok(not f2[1].has_status("stunned"), "§3b: Downwind's copy stunned an unbroken boss")
		ok(_log_text(s2).substr(lw2).contains("%s resists the" % f2[1].unit_name),
			"§3b: the copy's refusal is not in the log")
		# The control: the same copy onto a Broken boss lands — the copy still carries the stun.
		_wipe(f2[0])
		f2[1].broken = true
		war.resource = 99999
		war.cooldowns.clear()
		await s2._resolve(war, pommel, f2[0], "perfect")
		ok(f2[1].has_status("stunned"), "§3b: Downwind's copy did not stun a Broken boss — the carry itself stopped")
	await _clear(s2)


# ── §4 — EVERY STATUS'S CHIP IS ITS OWN, AND BROKEN IS NOT A DEBUFF IRON WILL COUNTS ──

func _s4_chips_and_broken() -> void:
	print("\n§4 — every status's chip is its own; Broken is not a debuff Iron Will counts")
	var s: Node = await _board(PARTY, {"party": {0: {"talents": {"tn_iron_will": 1}}}})
	var info: Dictionary = s.STATUS_INFO
	# The letters a chip shows: digits (and the counter's placeholder) stripped, so Bleed's
	# Bl37 meets Blighted's Bl. A chip that leads with a sign is a value, not a tag.
	var letters := {}
	for sid in info:
		var st := _stem(String(info[sid][1]))
		if st != "":
			letters[String(sid)] = [st]
	var counters := _counter_families()
	for sid2 in counters:
		if not letters.has(sid2):
			letters[sid2] = []
		for st2 in counters[sid2]:
			if not (letters[sid2] as Array).has(st2):
				letters[sid2].append(st2)
	var owners := {}
	for sid3 in letters:
		for st3 in letters[sid3]:
			if not owners.has(st3):
				owners[st3] = []
			if not (owners[st3] as Array).has(sid3):
				owners[st3].append(sid3)
	var shared: Array = []
	for st4 in owners:
		if (owners[st4] as Array).size() > 1:
			shared.append("%s: %s" % [st4, str(owners[st4])])
	print("    CHECKED %d tags over %d statuses; %d statuses write a chip by hand: %s" % [owners.size(), letters.size(),
		counters.size(), str(counters.keys())])
	ok(letters.size() >= 150, "§4a: the tag walk read %d statuses" % letters.size())
	ok(counters.size() >= 20 and counters.has("bleed") and counters.has("chilled") and counters.has("faith")
			and counters.has("anointed"),
		"§4a: the walk of hand-written chips found %s" % str(counters.keys()))
	ok(shared.is_empty(), "§4a: two statuses wear one tag: %s" % str(shared))
	ok(_stem(String(info["frostbite"][1])) != _stem(String(info["frostbind"][1])),
		"§4a: Frostbite and Frostbind wear one tag")
	ok(not (counters.get("bleed", []) as Array).has(_stem(String(info["blight"][1]))),
		"§4a: Blighted's tag is Bleed's counter's letters")
	var fresh: Array = ["frostbind", "blight", "cripple", "faith", "blood_price", "covering_guard", "caught",
		"retaliate", "rally_heal", "spirit_heal", "scent", "unslaked", "anvil", "deathwish"]
	var reserved := ""
	for sid5 in fresh:
		var t5 := String(info[sid5][1])
		if t5.begins_with("BD") or t5 == "Ru":
			reserved += "%s=%s " % [sid5, t5]
	ok(reserved == "", "§4a: a moved tag took Break damage's or Rupture's: %s" % reserved)
	# §4b — Broken is not a debuff the talent counts. A Warden holding the node, Broken.
	var war: BattleUnit = _hero(s, "warrior")
	ok(war.iron_will_ranks == 1, "§4b: the Warden's talent did not land (iron_will_ranks %d)" % war.iron_will_ranks)
	war.take_hit(0, 999)
	ok(war.broken and war.has_status("broken"), "§4b: the Warden did not Break")
	ok(war.count_debuffs() == 0, "§4b: a Broken Warden with nothing else on him counts %d debuffs" % war.count_debuffs())
	var chip := ""
	for st6 in war.statuses:
		if String(st6.id) == "iron_will":
			chip = String(st6.short)
	ok(chip == "-0%", "§4b: the Iron Will chip on a Broken Warden reads '%s', want '-0%%'" % chip)
	s._apply_status(war, "dazed", 3)
	ok(war.count_debuffs() == 1, "§4b: Broken and Dazed count %d — want the Dazed alone" % war.count_debuffs())
	# The breadth count agrees, as the ruling says it must.
	ok(int(s._status_count(war)) == war.count_debuffs(),
		"§4b: the breadth count reads %d and the talent's count %d" % [int(s._status_count(war)), war.count_debuffs()])
	await _clear(s)
	# The magnitude that moves, driven: the same seeded blow on a Broken Warden with the node
	# and without it lands the same; with one real debuff on him the node takes one step off.
	var with_node := await _iron_will_blow(true, false)
	var without := await _iron_will_blow(false, false)
	print("    a Broken Warden struck: %d with the node, %d without" % [with_node, without])
	ok(with_node == without and with_node > 0,
		"§4b: Broken alone, the node changed the blow (%d with it, %d without)" % [with_node, without])
	var with_dazed := await _iron_will_blow(true, true)
	var without_dazed := await _iron_will_blow(false, true)
	print("    Broken and Dazed: %d with the node, %d without" % [with_dazed, without_dazed])
	ok(with_dazed < without_dazed and with_dazed >= int(floor(without_dazed * 0.88)) - 1
			and with_dazed <= int(ceil(without_dazed * 0.88)) + 1,
		"§4b: Broken and Dazed — the node paid %d against %d, want one debuff's step" % [with_dazed, without_dazed])


func _iron_will_blow(node: bool, dazed: bool) -> int:
	var over := {0: {"talents": {"tn_iron_will": 1}}} if node else {}
	var s: Node = await _board(PARTY, {"party": over})
	var war: BattleUnit = _hero(s, "warrior")
	var foe: BattleUnit = _foes(s)[0]
	war.take_hit(0, 999)
	if dazed:
		s._apply_status(war, "dazed", 3)
	war.hp = war.max_hp
	foe.resource = 99999
	var was := war.hp
	seed(4242)
	await s._resolve(foe, foe.abilities[0], war, "good")
	var dealt := was - war.hp
	await _clear(s)
	return dealt


# The letters of a tag: digits and a counter's placeholder out; "" for a chip that leads
# with a sign or carries no letter (a value, not a tag).
func _stem(tag: String) -> String:
	var t := tag.strip_edges()
	if t.begins_with("+") or t.begins_with("-"):
		return ""
	var out := ""
	for i in t.length():
		var ch := t[i]
		if ch >= "0" and ch <= "9":
			continue
		out += ch
	out = out.replace("%d", "").replace("%", "").strip_edges()
	var has_letter := false
	for j in out.length():
		if (out[j] >= "a" and out[j] <= "z") or (out[j] >= "A" and out[j] <= "Z"):
			has_letter = true
	return out if has_letter else ""


# Every chip the code writes by hand — a literal short handed to add_status or update_status
# with a literal id, a counter's (`%d` after its letters) or a fixed one's — and unit.gd's own
# counters on `.short`, keyed by the status it belongs to. Comments stripped first. A tag
# written here and not in `STATUS_INFO` (Anointed's) is as visible as one written there.
func _counter_families() -> Dictionary:
	var out := {}
	# add_status names its label before the short (any expression without a comma);
	# update_status leads with the short.
	var re_add := RegEx.new()
	re_add.compile("(?<!func )add_status\\(\\s*\"(\\w+)\"\\s*,\\s*[^,]+,\\s*\"([^\"]*)\"")
	var re_upd := RegEx.new()
	re_upd.compile("(?<!func )update_status\\(\\s*\"(\\w+)\"\\s*,\\s*\"([^\"]*)\"")
	for path in ["res://scripts/battle.gd", "res://scripts/unit.gd"]:
		var src := Gate.strip_comments(FileAccess.get_file_as_string(path))
		for re in [re_add, re_upd]:
			for m in (re as RegEx).search_all(src):
				var sid := m.get_string(1)
				var st := _stem(m.get_string(2))
				if st == "":
					continue
				if not out.has(sid):
					out[sid] = []
				if not (out[sid] as Array).has(st):
					out[sid].append(st)
	# unit.gd's own four, written by the status's own branch: `s.short = "P%d"` and kin.
	var usrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	for pair in [["poison", "P"], ["chilled", "C"], ["ruin", "R"], ["bleed", "Bl"]]:
		if usrc.contains("\"%s%%d\"" % pair[1]):
			if not out.has(pair[0]):
				out[pair[0]] = []
			if not (out[pair[0]] as Array).has(pair[1]):
				out[pair[0]].append(pair[1])
	return out


# ── §5 — THE RULING, RECORDED WHERE THE RULES LIVE ─────────────────────────

func _s5_the_record() -> void:
	print("\n§5 — the ruling recorded where the rules live")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("A METER STATE IS NOT A CONJUNCTION HALF"),
		"§5: CLAUDE.md does not record that a meter state is not a conjunction half")


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
