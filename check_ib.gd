# BATCH IB — THE DRAFT APPEARS, AND EACH HERO DRAFTS ALONE.
#
#   §1  A WAITING PICK APPEARS AT THE MAP, on the real map screen, the party arriving:
#       a  WHAT COUNTS IS AN UNMADE PICK, NEVER AN UNEQUIPPED HOLDING — four heroes each
#          holding runes unworn and owing nothing: the arrival opens nothing, and the
#          nameplate's ✦ N is drawn; a pick owed beside the same holding opens.
#       b  every kind opens on arrival as its own section of the hero's screen — a draft and the
#          zone boss's ability in ABILITIES, an upgrade in UPGRADES, a rune cache in RUNES (since
#          ID §1; the boss's ability and the upgrade opened the pick overlay until then).
#       c  SEVERAL WAITING APPEAR ONE AFTER ANOTHER, IN THE ORDER EARNED, which is not the
#          party's order here (a draft for the fourth hero earned first).
#       d  DISMISSING LOSES NOTHING: the first dismissed, the second taken; nothing reopens on
#          that arrival; the dismissed pick is still owed, its offer the same, its card still
#          marked, and it is made later from the card's CHOOSE. An upgrade's Later too.
#       e  ONCE PER ARRIVAL: back from the hero sheet through its own button, nothing opens;
#          the next arrival opens the dismissed pick again.
#       f  IT NEVER COVERS ANOTHER CHOICE: it runs from `_ready` after the map is drawn, it
#          opens nothing while an overlay is up, and nothing over the framing card.
#       g  THE MARK OF A PENDING PICK is the card's badge and CHOOSE, beside HR's ✦ N and
#          never mistaken for it: a holding alone shows ✦ only, a pick alone the badge only.
#       h  THE ORDER RIDES THE SAVE ON THE MEMBERS: a save keeps it; a save without it (an
#          older build's) opens with every pick still owed, in the party's order.
#   §2  EACH HERO DRAFTS ALONE:
#       a  the draft's columns were one pick a hero (the premise): each hero's screen draws his
#          own offer and no other hero's card.
#       b  ONE SCREEN SHAPE: a section with nothing owed is absent; the elite's looter owes
#          both and one Confirm commits both, disabled until both are decided; Later leaves both
#          owed; an empty cache is let go; at the cap the bench step names a carried card and
#          never the protected core, and the benched card is kept.
#       c  the kit preview opens on him and does not walk; closing it leaves the screen as it was.
#       d  the crest rune stays out of a hero's pick, and the crest's own bag is untouched.
#       e  the screen fits: both sections on the screen, the Confirm and Later outside any scroller.
#   §4  THE RUNE PANEL'S SCROLL LOOKS LIKE A SCROLL (IB §0.1): at its longest — the holding cap,
#       every core slot empty — the scroller's bar is drawn; where it fits, no bar.
#   §5  THE EMPTY CORE SLOT READS *— empty —* (IB §0.3), and HN §2.6's line follows the slots only
#       where he holds no core rune.
#   §6a THE WALKERS' ONE HELPER (`Gate.answer_hero_draft`) AT THE TWO ENDS OF WHAT THE SCREEN
#       HOLDS: the longest — the looter at the cap, both sections and the bench step — taken
#       and declined, as the four road walkers answer it; the emptiest — a rune alone, its
#       cache empty — let go. A road deals what it deals, so both ends are driven here.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** Whether a player FINDS the dismissed pick is a
# question about eyes; §1g asserts the mark is drawn and apart from ✦ N, not that it is seen.
# The road walkers (`check_gj`, `check_gp`, `check_gv`, `check_hk`, `check_fh`) meet the
# arrival on whole runs; this gate constructs each state it asserts, through the run's own
# doors, and asserts the premise of every arm. `Run` is fetched off the tree.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ib.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ib_profile.json"
const SCRATCH_RELICS := "user://ib_relics.json"
const SCRATCH_SAVE := "user://ib_scratch_save.bin"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261012
const EMPTY_ROW := "— empty —"
const OLD_ROW := "— empty core slot —"
const HN_LINE := "No core rune held. Core runes are found in play, alongside the others."

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IB — THE DRAFT APPEARS, AND EACH HERO DRAFTS ALONE")
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
	seed(SEED)
	await _s1a_a_holding_opens_nothing()
	await _s1b_every_kind()
	await _s1c_the_order()
	await _s1d_dismissing()
	await _s1e_once_an_arrival()
	await _s1f_never_covers()
	await _s1g_the_mark()
	await _s1h_the_save()
	await _s2a_each_his_own()
	await _s2b_one_screen()
	await _s2c_the_preview()
	await _s2d_the_crest()
	await _s2e_the_fit()
	await _s4_the_scroll()
	await _s5_the_empty_slot()
	await _s6a_the_helper()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta(framing_seen := true) -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	if framing_seen:
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


# The modal overlays the map has up (its picks, its panels and the hero's screen).
func _modals(mp: Node) -> Array:
	var out: Array = []
	for c in mp.get_children():
		if c is Control and not c.is_queued_for_deletion() \
				and [60, 62, 64, 72, 74].has((c as Control).z_index):
			out.append(c)
	return out


# What the arrival has up, read off the game's own marks: the hero's draft screen by its
# `hero_draft` meta. **BATCH ID §1 — IT IS THE ONLY SCREEN A PICK OPENS** (the pick overlay that
# took the boss's ability and the upgrade is retired), so what the arrival opened is told apart by
# the sections the screen holds — its `kind` is their names joined: *draft*, *boss* (the zone
# boss's offer in ABILITIES), *upgrade*, *rune* — read off the metas the game sets, never words.
func _up(mp: Node) -> Dictionary:
	var hd: Node = Gate.hero_draft(mp)
	if hd == null:
		return {}
	var parts := PackedStringArray()
	if not Gate.bound_buttons(hd, "_stage_draft_decline").is_empty():
		parts.append("draft")
	if Gate._has_offer(hd, "boss"):
		parts.append("boss")
	if Gate._has_section(hd, "upgrades"):
		parts.append("upgrade")
	if not Gate.bound_buttons(hd, "_stage_draft_rune").is_empty():
		parts.append("rune")
	return {"hero": int(hd.get_meta("hero_draft")), "kind": " + ".join(parts), "node": hd}


# One pick of `kind` awarded through the run's own door for it.
func _award(kind: String, m: Dictionary) -> bool:
	match kind:
		"draft":
			return bool(_run.award_draft_pick(m))
		"rune":
			var c: Array = _run.roll_rune_candidates(m)
			if c.is_empty():
				return false
			_run.queue_rune_pick(m, c)
			return true
		"ability":
			return bool(_run.award_ability_pick(m))
		"upgrade":
			return bool(_run.award_upgrade_pick(m))
	return false


# The button bound to `method`, enabled or not.
func _bound_any(n: Node, method: String) -> Button:
	var btns: Array = []
	Gate.buttons(n, btns, false)
	for b in btns:
		for c in (b as Button).pressed.get_connections():
			if (c["callable"] as Callable).get_method() == method:
				return b
	return null


func _owed(m: Dictionary) -> int:
	var n := 0
	for k in ["draft_picks_owed", "rune_picks_owed", "bm_picks_owed", "up_picks_owed"]:
		n += int(m.get(k, 0))
	return n


func _press_bound(n: Node, method: String, args: Array) -> bool:
	var b: Button = Gate.bound_button(n, method, args)
	if b == null:
		return false
	b.emit_signal("pressed")
	return true


func _texts(n: Node) -> Array:
	return Gate.texts(n) if n != null else []


# A rune of `key`'s class that `m` can be offered and holds none of: an ordinary one.
func _ordinary_for(m: Dictionary) -> Array:
	var out: Array = []
	for id in Runes.eligible_ids(m, Runes.owned_names(m, _run.party_rune_names())):
		if not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(Runes.config(String(id))):
			out.append(String(id))
	return out


# ── §1a — AN UNMADE PICK, NEVER AN UNEQUIPPED HOLDING ────────────────────────
func _s1a_a_holding_opens_nothing() -> void:
	print("\n§1a — a holding never opens a screen; a pick beside it does")
	_new_run()
	var held_total := 0
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		# Put down through the one door (HO §1), unworn: each held by the hero of its class.
		for id in _ordinary_for(m).slice(0, 2):
			var r: Dictionary = Runes.build(String(id))
			r["equipped"] = false
			_run.hold_rune(m, r)
		held_total += int(_run.held_count(m))
	ok(held_total >= 8 and _run.pending_picks().is_empty(),
		"§1a: the premise — every hero holds runes unworn (%d held) and owes nothing (%d picks)" % [
			held_total, _run.pending_picks().size()])
	var mp := await _to_map()
	ok(_modals(mp).is_empty(),
		"§1a: a HOLDING opened a screen on arrival (%d open) — the reminder became a nag" % _modals(mp).size())
	var marks := 0
	var btns: Array = []
	Gate.buttons(mp, btns)
	for b in btns:
		if (b as Button).has_meta("held_marker"):
			marks += 1
	ok(marks == 4, "§1a: the nameplates drew %d ✦ marks for four heroes holding runes — the holding is not shown at a glance" % marks)
	# THE POSITIVE ARM: the same holding with a pick owed beside it opens the pick.
	_run.award_draft_pick(_run.party[0])
	mp = await _to_map()
	var up := _up(mp)
	ok(not up.is_empty() and int(up["hero"]) == 0 and String(up["kind"]) == "draft",
		"§1a: a draft owed beside the same holding did not open on arrival (%s)" % [up.get("kind", "nothing")])
	print("    four heroes holding %d runes unworn: nothing opened; a draft beside them: it opened" % held_total)


# ── §1b — EVERY KIND OPENS ON ITS OWN SCREEN ─────────────────────────────────
func _s1b_every_kind() -> void:
	print("\n§1b — every kind of pick opens on arrival, a section of his own screen")
	# BATCH ID §1 — RE-POINTED, THE QUESTION UNMOVED: each kind still opens on arrival, and since the
	# fold it opens as its own section of the hero's screen — the boss's ability an offer in
	# ABILITIES, the upgrade UPGRADES — where it opened the pick overlay until ID.
	var sect := {"draft": "draft", "rune": "rune", "ability": "boss", "upgrade": "upgrade"}
	for kind in ["draft", "rune", "ability", "upgrade"]:
		_new_run()
		var m: Dictionary = _run.party[1]
		var made: bool = _award(String(kind), m)
		ok(made and int(_run.pick_owed(m, kind)) == 1, "§1b (%s): the premise — the pick was not awarded" % kind)
		var mp := await _to_map()
		var up := _up(mp)
		var want_kind: String = String(sect[kind])
		ok(not up.is_empty() and int(up["hero"]) == 1 and String(up["kind"]) == want_kind,
			"§1b (%s): the arrival did not open the Mage's pick on its screen (%s)" % [kind, up])
		if not up.is_empty():
			var node: Node = up["node"]
			if kind == "draft":
				ok(Gate.has_text(node, "ABILITIES") and not Gate.has_text(node, "RUNES"),
					"§1b (draft): the screen is not his ABILITIES section alone")
			elif kind == "rune":
				ok(Gate.has_text(node, "RUNES") and not Gate.has_text(node, "ABILITIES"),
					"§1b (rune): the screen is not his RUNES section alone")
			elif kind == "ability":
				ok(Gate.has_text(node, "ABILITIES") and Gate.has_text(node, "from the zone boss") and not Gate.has_text(node, "RUNES"),
					"§1b (ability): the screen is not his ABILITIES section holding the zone boss's offer alone")
			else:
				ok(Gate.has_text(node, "UPGRADES") and not Gate.has_text(node, "ABILITIES") and not Gate.has_text(node, "RUNES"),
					"§1b (upgrade): the screen is not his UPGRADES section alone")
	print("    a draft, a rune cache, a boss's ability and an upgrade each opened on arrival, each its section")


# ── §1c — IN THE ORDER EARNED ─────────────────────────────────────────────────
func _s1c_the_order() -> void:
	print("\n§1c — several waiting appear one after another, in the order earned")
	_new_run()
	var p: Array = _run.party
	_run.award_draft_pick(p[3])
	_run.award_upgrade_pick(p[0])
	_run.award_ability_pick(p[1])
	var c2: Array = _run.roll_rune_candidates(p[2])
	_run.queue_rune_pick(p[2], c2)
	var pend: Array = _run.pending_picks()
	var earned: Array = pend.map(func(t): return "%d:%s" % [int(t["hero"]), String(t["kind"])])
	ok(earned == ["3:draft", "0:upgrade", "1:ability", "2:rune"],
		"§1c: the premise — the picks were not earned in the order constructed: %s" % [earned])
	var mp := await _to_map()
	var seen: Array = []
	for _step in 8:
		var up := _up(mp)
		if up.is_empty():
			break
		seen.append("%d:%s" % [int(up["hero"]), String(up["kind"])])
		# BATCH ID §1 — every screen is the hero's own, answered through the one helper.
		await Gate.answer_hero_draft(self, mp, false)
	ok(seen == ["3:draft", "0:upgrade", "1:boss", "2:rune"],
		"§1c: the screens came %s, not in the order earned (the fourth hero's draft first)" % [seen])
	ok(seen != ["0:upgrade", "1:boss", "2:rune", "3:draft"],
		"§1c: the screens came in the party's order, not the order earned")
	var left := 0
	for m in p:
		left += _owed(m)
	ok(left == 0, "§1c: %d picks are still owed after every screen was answered" % left)
	await Gate.frames(self, 4)
	ok(_modals(mp).is_empty(), "§1c: a screen opened again after the last pick was answered")
	print("    earned 3:draft 0:upgrade 1:ability 2:rune — appeared %s" % [seen])


# ── §1d — DISMISSING LOSES NOTHING ───────────────────────────────────────────
func _s1d_dismissing() -> void:
	print("\n§1d — the first dismissed, the second taken; nothing lost, nothing back")
	_new_run()
	var m1: Dictionary = _run.party[1]
	var m2: Dictionary = _run.party[2]
	_run.award_draft_pick(m1)
	_run.award_draft_pick(m2)
	var offer1: Array = (m1["draft_candidates"] as Array)[0].duplicate()
	var refused1: Array = _run.draft_refused(m1).duplicate()
	var mp := await _to_map()
	var up := _up(mp)
	ok(not up.is_empty() and int(up["hero"]) == 1, "§1d: the first earned (the Mage's) did not open first (%s)" % [up])
	ok(_press_bound(Gate.hero_draft(mp), "_close_hero_draft", []), "§1d: the Mage's screen drew no Later")
	await Gate.frames(self, 3)
	up = _up(mp)
	ok(not up.is_empty() and int(up["hero"]) == 2, "§1d: dismissing the first did not bring the second (%s)" % [up])
	var a: Dictionary = await Gate.answer_hero_draft(self, mp, true)
	ok(bool(a.get("confirmed", false)) and String(a.get("card", "")) != ""
			and _run.owned_ability_names(m2).has(String(a["card"])),
		"§1d: the second was not taken (%s)" % [a])
	await Gate.frames(self, 4)
	ok(_modals(mp).is_empty(), "§1d: the dismissed screen came back on the same arrival — a modal loop")
	ok(int(m1["draft_picks_owed"]) == 1, "§1d: the dismissed draft is no longer owed (%d)" % int(m1["draft_picks_owed"]))
	ok((m1["draft_candidates"] as Array)[0] == offer1 and _run.draft_refused(m1) == refused1,
		"§1d: dismissing changed the offer or wrote the no-return ledger — dismissing LOST something")
	var choose: Button = Gate.bound_button(mp, "_open_hero_draft", [1])
	ok(choose != null and Gate.has_text(mp, "◆ 1 draft"), "§1d: the dismissed draft is not marked on the Mage's card")
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
	var hd: Node = Gate.hero_draft(mp)
	ok(hd != null and int(hd.get_meta("hero_draft")) == 1, "§1d: the card's CHOOSE did not open the Mage's own screen")
	if hd != null:
		var a2: Dictionary = await Gate.answer_hero_draft(self, mp, true)
		ok(bool(a2.get("confirmed", false)) and int(m1["draft_picks_owed"]) == 0
				and offer1.has(String(a2.get("card", ""))),
			"§1d: the dismissed draft could not be made later from the card (%s)" % [a2])
	# AN UPGRADE's LATER IS THE SAME DISMISSAL (BATCH ID §1: the upgrade is a section of the hero's
	# screen, whose Later is the dismissal the pick overlay's *Not yet* was until ID).
	_new_run()
	_run.award_upgrade_pick(_run.party[0])
	_run.award_upgrade_pick(_run.party[3])
	var mp2 := await _to_map()
	var u0 := _up(mp2)
	ok(not u0.is_empty() and int(u0["hero"]) == 0 and String(u0["kind"]) == "upgrade",
		"§1d: the Warrior's upgrade did not open first (%s)" % [u0])
	ok(_press_bound(Gate.hero_draft(mp2), "_close_hero_draft", []), "§1d: the upgrade's screen drew no Later")
	await Gate.frames(self, 3)
	var u3 := _up(mp2)
	ok(not u3.is_empty() and int(u3["hero"]) == 3, "§1d: Later did not bring the Hunter's upgrade (%s)" % [u3])
	if not u3.is_empty():
		await Gate.answer_hero_draft(self, mp2, true)
		await Gate.frames(self, 4)
	ok(_modals(mp2).is_empty() and int(_run.party[0]["up_picks_owed"]) == 1 and int(_run.party[3]["up_picks_owed"]) == 0,
		"§1d: after Later and a take, the Warrior's upgrade is not still owed and closed, or the Hunter's not taken")


# ── §1e — ONCE AN ARRIVAL ─────────────────────────────────────────────────────
func _s1e_once_an_arrival() -> void:
	print("\n§1e — once an arrival: back from the sheet opens nothing; the next arrival does")
	_new_run()
	_run.award_draft_pick(_run.party[2])
	var mp := await _to_map()
	ok(Gate.hero_draft(mp) != null, "§1e: the premise — the Cleric's draft did not open on arrival")
	_press_bound(Gate.hero_draft(mp), "_close_hero_draft", [])
	await Gate.frames(self, 3)
	ok(Gate.hero_draft(mp) == null, "§1e: Later did not close the screen")
	# THE HERO SHEET, AND BACK, THROUGH THE REAL BUTTONS.
	ok(_press_bound(mp, "_open_hero", [2]), "§1e: the Cleric's card has no button into his sheet")
	await Gate.frames(self, 6)
	var sheet: Node = current_scene
	ok(Gate.scene_name(self) == "Party", "§1e: the sheet did not open (%s)" % Gate.scene_name(self))
	var back: Array = Gate.bound_buttons(sheet, "_on_back")
	ok(not back.is_empty(), "§1e: the sheet drew no button back to the map")
	if not back.is_empty():
		(back[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 6)
	var mp2: Node = current_scene
	ok(Gate.scene_name(self) == "Map", "§1e: the sheet's button did not return to the map")
	ok(_modals(mp2).is_empty(),
		"§1e: a return from the sheet opened the dismissed draft again — it is not an arrival")
	ok(not bool(_run.map_reentry), "§1e: the map did not clear the return it read")
	ok(int(_run.party[2]["draft_picks_owed"]) == 1, "§1e: the dismissed draft is not still owed")
	# THE POSITIVE ARM: the party arrives again, and it opens.
	var mp3 := await _to_map()
	var hd: Node = Gate.hero_draft(mp3)
	ok(hd != null and int(hd.get_meta("hero_draft")) == 2,
		"§1e: the next arrival did not open the dismissed draft again")


# ── §1f — IT NEVER COVERS ANOTHER CHOICE ─────────────────────────────────────
func _s1f_never_covers() -> void:
	print("\n§1f — after the map is drawn, never over an open overlay, never over the framing card")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	var ready_at := src.find("func _ready() -> void:")
	var body := src.substr(ready_at, src.find("\nfunc ", ready_at + 10) - ready_at) if ready_at >= 0 else ""
	ok(body.find("_draw_screen()") >= 0 and body.find("_begin_arrival()") > body.find("_draw_screen()"),
		"§1f: the arrival does not start in `_ready` after the map is drawn")
	ok(body.contains("not _maybe_show_framing()"),
		"§1f: the arrival no longer waits on the framing card")
	_new_run()
	_run.award_draft_pick(_run.party[0])
	_run.award_draft_pick(_run.party[1])
	var mp := await _to_map()
	ok(Gate.hero_draft(mp) != null and _modals(mp).size() == 1, "§1f: the premise — one screen up on arrival")
	# The walk asked to go on while a screen is up opens nothing over it.
	mp.call("_arrival_next")
	await Gate.frames(self, 2)
	ok(_modals(mp).size() == 1 and int(Gate.hero_draft(mp).get_meta("hero_draft")) == 0,
		"§1f: the walk opened a screen over one already up (%d up)" % _modals(mp).size())
	# Nor over a panel the player opened himself: the rune panel up, the screen answered.
	await Gate.answer_hero_draft(self, mp, false)
	await Gate.frames(self, 2)
	ok(Gate.hero_draft(mp) != null and int(Gate.hero_draft(mp).get_meta("hero_draft")) == 1,
		"§1f: the positive arm — the second did not open once the first closed")
	# THE FRAMING CARD: the first map of a profile that has not seen it, a pick owed (a
	# state only a fixture reaches): the card is up and nothing opens over it.
	_fresh_meta(false)
	_new_run()
	_run.award_draft_pick(_run.party[0])
	var mp2 := await _to_map()
	var framed := false
	for c in mp2.get_children():
		if c is Control and (c as Control).z_index == 91 and not c.is_queued_for_deletion():
			framed = true
	ok(framed, "§1f: the premise — the framing card did not show on a profile that has not seen it")
	ok(Gate.hero_draft(mp2) == null and _modals(mp2).is_empty(),
		"§1f: a pick opened over the framing card")
	_fresh_meta(true)


# ── §1g — THE MARK OF A PENDING PICK ─────────────────────────────────────────
func _s1g_the_mark() -> void:
	print("\n§1g — a pending pick is marked on its card, apart from HR's ✦ N")
	_new_run()
	var p: Array = _run.party
	# hero 0 holds and owes nothing; hero 1 owes and holds nothing; hero 2 holds and owes.
	for i in [0, 2]:
		var r: Dictionary = Runes.build(String(_ordinary_for(p[i])[0]))
		r["equipped"] = false
		_run.hold_rune(p[i], r)   # the one door (HO §1), unworn
	_run.award_draft_pick(p[1])
	_run.award_draft_pick(p[2])
	var mp := await _to_map()
	for i in [1, 2]:
		var hd: Node = Gate.hero_draft(mp)
		if hd != null:
			_press_bound(hd, "_close_hero_draft", [])
			await Gate.frames(self, 3)
	ok(_modals(mp).is_empty(), "§1g: the premise — both drafts dismissed")
	var marks := {}
	var btns: Array = []
	Gate.buttons(mp, btns)
	for b in btns:
		if (b as Button).has_meta("held_marker"):
			var consts: Dictionary = mp.get_script().get_script_constant_map()
			var at := int(round(((b as Button).position.y - float(consts["CARD_Y"])) / float(consts["CARD_STEP"])))
			marks[at] = String((b as Button).text)
	var choose := {}
	for i in 4:
		choose[i] = Gate.bound_button(mp, "_open_hero_draft", [i]) != null
	print("    held marks %s, CHOOSE on %s" % [marks, choose])
	ok(marks.has(0) and not bool(choose[0]), "§1g: a holding alone did not read as ✦ alone (✦ %s, CHOOSE %s)" % [marks.has(0), choose[0]])
	ok(not marks.has(1) and bool(choose[1]), "§1g: a pick alone did not read as its mark alone (✦ %s, CHOOSE %s)" % [marks.has(1), choose[1]])
	ok(marks.has(2) and bool(choose[2]), "§1g: a holding and a pick did not each carry its own mark (✦ %s, CHOOSE %s)" % [marks.has(2), choose[2]])
	ok(String(marks.get(0, "")).begins_with("✦") and Gate.has_text(mp, "◆ 1 draft"),
		"§1g: the two marks no longer read apart — ✦ for a holding, ◆ for a pick")


# ── §1h — THE ORDER RIDES THE SAVE ON THE MEMBERS ────────────────────────────
func _s1h_the_save() -> void:
	print("\n§1h — the order rides the save on the members; an older save opens in the party's order")
	_new_run()
	_run.award_draft_pick(_run.party[3])
	_run.award_upgrade_pick(_run.party[0])
	var before: Array = _run.pending_picks().map(func(t): return "%d:%s" % [int(t["hero"]), String(t["kind"])])
	var had_path := String(_run.save_path)
	_run.save_path = SCRATCH_SAVE
	_remove(SCRATCH_SAVE)
	_run.save_run()
	var f := FileAccess.open(SCRATCH_SAVE, FileAccess.READ)
	var data: Variant = f.get_var(true) if f != null else null
	if f != null:
		f.close()
	ok(data is Dictionary and not (data as Dictionary).has("pick_serials")
			and ((data as Dictionary)["party"] as Array)[3].has("pick_serials"),
		"§1h: the order does not ride the members (a run-level key would be one an older build writes away)")
	_run.party = []
	ok(_run.load_run(), "§1h: the scratch save did not load")
	var after: Array = _run.pending_picks().map(func(t): return "%d:%s" % [int(t["hero"]), String(t["kind"])])
	ok(before == ["3:draft", "0:upgrade"] and after == before, "§1h: the order did not survive the save (%s → %s)" % [before, after])
	# AN OLDER BUILD'S SAVE: no serials anywhere — every pick still owed, the party's order.
	for m in _run.party:
		(m as Dictionary).erase("pick_serials")
	_run.save_run()
	_run.party = []
	_run.load_run()
	var older: Array = _run.pending_picks().map(func(t): return "%d:%s:%d" % [int(t["hero"]), String(t["kind"]), int(t["serial"])])
	ok(older == ["0:upgrade:0", "3:draft:0"], "§1h: a save with no order did not open in the party's order (%s)" % [older])
	_run.save_path = had_path
	_remove(SCRATCH_SAVE)


# ── §2a — EACH HIS OWN OFFER ─────────────────────────────────────────────────
func _s2a_each_his_own() -> void:
	print("\n§2a — the draft is one pick a hero, and each hero's screen draws his own")
	_new_run()
	var offers := {}
	for i in _run.party.size():
		ok(_run.award_draft_pick(_run.party[i]), "§2a: the premise — no draft could be rolled for hero %d" % i)
		offers[i] = _run.draft_choice(_run.party[i])
	var mp := await _to_map()
	var screens := 0
	for _step in 6:
		var hd: Node = Gate.hero_draft(mp)
		if hd == null:
			break
		screens += 1
		var i := int(hd.get_meta("hero_draft"))
		var drawn: Array = Gate.bound_buttons(hd, "_stage_draft").map(func(b): return Gate.bound_args(b, "_stage_draft"))
		var mine: Array = drawn.filter(func(a2): return int(a2[0]) == i).map(func(a2): return String(a2[1]))
		var others: Array = drawn.filter(func(a2): return int(a2[0]) != i)
		ok(mine == offers[i] and others.is_empty(),
			"§2a: hero %d's screen drew %s for his offer %s, and %d of another hero's" % [i, mine, offers[i], others.size()])
		await Gate.answer_hero_draft(self, mp, false)
	ok(screens == 4, "§2a: %d screens for four heroes' drafts — not one a hero" % screens)


# ── §2b — ONE SCREEN SHAPE ────────────────────────────────────────────────────
func _s2b_one_screen() -> void:
	print("\n§2b — a section only when owed, one Confirm for both, Later loses nothing")
	# THE ELITE'S LOOTER: a draft and a cache.
	_new_run()
	var m: Dictionary = _run.party[2]
	_run.award_draft_pick(m)
	var cands: Array = _run.roll_rune_candidates(m)
	_run.queue_rune_pick(m, cands)
	ok(int(m["draft_picks_owed"]) == 1 and int(m["rune_picks_owed"]) == 1 and not cands.is_empty(),
		"§2b: the premise — the looter does not owe both")
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	ok(hd != null and Gate.has_text(hd, "ABILITIES") and Gate.has_text(hd, "RUNES"),
		"§2b: the looter's screen does not show both sections")
	var conf0: Array = Gate.bound_buttons(hd, "_confirm_hero_draft")
	ok(conf0.is_empty(), "§2b: the Confirm is live with nothing decided")
	var card := String(Gate.bound_args(Gate.bound_buttons(hd, "_stage_draft")[0], "_stage_draft")[1])
	_press_bound(hd, "_stage_draft", [2, card])
	await process_frame
	ok(Gate.bound_buttons(Gate.hero_draft(mp), "_confirm_hero_draft").is_empty(),
		"§2b: the Confirm went live with the card decided and the rune not")
	var rn := String(Gate.bound_args(Gate.bound_buttons(Gate.hero_draft(mp), "_stage_draft_rune")[0], "_stage_draft_rune")[1])
	_press_bound(Gate.hero_draft(mp), "_stage_draft_rune", [2, rn])
	await process_frame
	var conf: Array = Gate.bound_buttons(Gate.hero_draft(mp), "_confirm_hero_draft")
	ok(conf.size() == 1, "§2b: the Confirm is not live with both decided")
	var bag0: Array = _run.rune_bag.duplicate()
	if conf.size() == 1:
		(conf[0] as Button).emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(int(m["draft_picks_owed"]) == 0 and int(m["rune_picks_owed"]) == 0
			and _run.owned_ability_names(m).has(card) and _run.party_rune_names().has(rn),
		"§2b: one Confirm did not commit both (card %s owned %s, rune %s held %s)" % [
			card, _run.owned_ability_names(m).has(card), rn, _run.party_rune_names().has(rn)])
	ok(_run.rune_bag == bag0, "§2b: the crest's bag moved when a hero answered his own cache")
	# A CARD ALONE, AND A RUNE ALONE.
	_new_run()
	_run.award_draft_pick(_run.party[0])
	var c3: Array = _run.roll_rune_candidates(_run.party[3])
	_run.queue_rune_pick(_run.party[3], c3)
	mp = await _to_map()
	hd = Gate.hero_draft(mp)
	ok(hd != null and int(hd.get_meta("hero_draft")) == 0 and Gate.bound_buttons(hd, "_stage_draft_rune").is_empty()
			and not Gate.has_text(hd, "RUNES") and not Gate.bound_buttons(hd, "_stage_draft").is_empty(),
		"§2b: a hero owing a card alone was shown a RUNES section, or no card")
	await Gate.answer_hero_draft(self, mp, false)
	hd = Gate.hero_draft(mp)
	ok(hd != null and int(hd.get_meta("hero_draft")) == 3 and Gate.bound_buttons(hd, "_stage_draft_decline").is_empty()
			and not Gate.has_text(hd, "ABILITIES") and not Gate.bound_buttons(hd, "_stage_draft_rune").is_empty(),
		"§2b: a hero owing a rune alone was shown an ABILITIES section, or no rune")
	# LATER LEAVES BOTH OWED.
	_new_run()
	var mL: Dictionary = _run.party[1]
	_run.award_draft_pick(mL)
	_run.queue_rune_pick(mL, _run.roll_rune_candidates(mL))
	var d0: Array = (mL["draft_candidates"] as Array).duplicate(true)
	var r0: Array = (mL["rune_candidates"] as Array).duplicate(true)
	mp = await _to_map()
	_press_bound(Gate.hero_draft(mp), "_stage_draft", [1, String(_run.draft_choice(mL)[0])])
	await process_frame
	_press_bound(Gate.hero_draft(mp), "_close_hero_draft", [])
	await Gate.frames(self, 3)
	ok(int(mL["draft_picks_owed"]) == 1 and int(mL["rune_picks_owed"]) == 1
			and mL["draft_candidates"] == d0 and mL["rune_candidates"] == r0,
		"§2b: Later did not leave both picks owed and both offers as they were")
	# Two picks owed, one screen dismissed: the rune's turn in the walk goes with it, or the
	# screen comes straight back — a modal loop.
	ok(Gate.hero_draft(mp) == null and _modals(mp).is_empty(),
		"§2b: Later on a hero owing a card and a rune brought his screen straight back — a modal loop")
	# AN EMPTY CACHE IS LET GO: his pool spent between the drop and the answer.
	_new_run()
	var mE: Dictionary = _run.party[1]
	var cE: Array = _run.roll_rune_candidates(mE)
	_run.queue_rune_pick(mE, cE)
	var worn: Array = []
	for id in Runes.eligible_ids(mE, []):
		worn.append(Runes.build(String(id)))
	mE["runes"] = worn
	ok(Runes.pool_empty_for(mE) and (_run.rune_choice(mE) as Array).is_empty(),
		"§2b: the premise — the Mage's cache is not empty")
	mp = await _to_map()
	hd = Gate.hero_draft(mp)
	ok(hd != null and Gate.has_text(hd, "The cache holds nothing this hero can take")
			and Gate.bound_button(hd, "_stage_draft_rune", [1, ""]) != null,
		"§2b: an empty cache does not say why, or offers no way to let it go")
	_press_bound(hd, "_stage_draft_rune", [1, ""])
	await process_frame
	_press_bound(Gate.hero_draft(mp), "_confirm_hero_draft", [])
	await Gate.frames(self, 3)
	ok(int(mE["rune_picks_owed"]) == 0 and (mE.get("rune_candidates", []) as Array).is_empty(),
		"§2b: letting an empty cache go did not spend the pick")
	# AT THE CAP: the bench step, never the protected core, the benched card kept.
	_new_run()
	var mC: Dictionary = _run.party[0]
	var guard := 0
	while not _run.ability_slots_full(mC) and guard < 20:
		guard += 1
		if not _run.award_draft_pick(mC):
			break
		_run.take_draft_ability(mC, String(_run.draft_choice(mC)[0]))
	ok(_run.ability_slots_full(mC) and _run.award_draft_pick(mC), "§2b: the premise — the Warrior's kit is not at the cap with a draft owed")
	var pool0: int = _run.owned_ability_names(mC).size()
	mp = await _to_map()
	var inc := String(_run.draft_choice(mC)[0])
	_press_bound(Gate.hero_draft(mp), "_stage_draft", [0, inc])
	await process_frame
	var step: Array = Gate.bound_buttons(Gate.hero_draft(mp), "_open_drop_overlay")
	ok(step.size() == 1, "§2b: at the cap the screen drew no bench step")
	if step.size() == 1:
		(step[0] as Button).emit_signal("pressed")
		await process_frame
	var benches: Array = Gate.pick_choices(Gate.overlay(mp, 64)).map(func(b): return String(((b as Button).get_meta("choice") as Array)[1][1]))
	var protected: Array = Classes.protected_names(String(mC.get("spec", "")))
	ok(not benches.is_empty() and benches.all(func(n): return _run.equipped_ability_names(mC).has(n) and not protected.has(n)),
		"§2b: the bench step offered %s — not the carried earned cards alone" % [benches])
	if not benches.is_empty():
		(Gate.pick_choices(Gate.overlay(mp, 64))[0] as Button).emit_signal("pressed")
		await process_frame
	_press_bound(Gate.hero_draft(mp), "_confirm_hero_draft", [])
	await Gate.frames(self, 3)
	var benched := String(benches[0]) if not benches.is_empty() else "?"
	ok(_run.loadout_ability_names(mC).has(inc) and _run.benched_ability_names(mC).has(benched)
			and _run.owned_ability_names(mC).size() == pool0 + 1,
		"§2b: at the cap, %s was not taken with %s benched and kept" % [inc, benched])


# ── §2c — THE KIT PREVIEW OPENS ON HIM ────────────────────────────────────────
func _s2c_the_preview() -> void:
	print("\n§2c — the kit preview opens on him, does not walk, and changes nothing")
	_new_run()
	var m: Dictionary = _run.party[3]
	_run.award_draft_pick(m)
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var card := String(_run.draft_choice(m)[0])
	_press_bound(hd, "_stage_draft", [3, card])
	await process_frame
	hd = Gate.hero_draft(mp)
	var kb: Button = null
	var btns: Array = []
	Gate.buttons(hd, btns)
	for b in btns:
		if (b as Button).has_meta("kit_preview"):
			kb = b
	ok(kb != null and int(kb.get_meta("kit_preview")) == 3, "§2c: the Hunter's screen carries no kit button on him")
	if kb != null:
		kb.emit_signal("pressed")
		await Gate.frames(self, 2)
	var pv: Node = null
	for c in mp.get_children():
		if c.get_script() != null and String(c.get_script().resource_path).ends_with("kit_preview.gd") and not c.is_queued_for_deletion():
			pv = c
	ok(pv != null and int(pv.get("hero_idx")) == 3 and not bool(pv.get("walk")),
		"§2c: the preview did not open on the Hunter, or it walks")
	if pv != null:
		pv.call("close_preview")
		await Gate.frames(self, 2)
	var still: Node = Gate.hero_draft(mp)
	ok(still != null and Gate.has_text(still, "▸ " + card) and int(m["draft_picks_owed"]) == 1,
		"§2c: closing the preview lost the screen or its staged card")


# ── §2d — THE CREST RUNE STAYS OUT OF A HERO'S PICK ──────────────────────────
func _s2d_the_crest() -> void:
	print("\n§2d — a hero's own pick holds no crest rune; the crest's bag is untouched")
	_new_run()
	var m: Dictionary = _run.party[1]
	var crest_id := ""
	for id in Runes.ids():
		if Runes.is_party_rune(Runes.config(String(id))) and not Runes.is_retired(String(id)) \
				and not _run.party_rune_names().has(Runes.display_name(Runes.config(String(id)))):
			crest_id = String(id)
			break
	var cls: Array = _ordinary_for(m)
	ok(crest_id != "" and not cls.is_empty(), "§2d: the premise — no live crest rune or no class rune to offer")
	# A triple from before HW: a crest rune beside a class rune.
	_run.queue_rune_pick(m, [Runes.build(crest_id), Runes.build(String(cls[0]))])
	var bag0: Array = _run.rune_bag.duplicate(true)
	var crest0: Array = _run.party_runes.duplicate(true)
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var drawn: Array = Gate.bound_buttons(hd, "_stage_draft_rune").map(func(b): return String(Gate.bound_args(b, "_stage_draft_rune")[1]))
	var crest_name := Runes.display_name(Runes.config(crest_id))
	ok(not drawn.is_empty() and not drawn.has(crest_name) and drawn.has(Runes.display_name(Runes.config(String(cls[0])))),
		"§2d: the hero's screen drew %s — a crest rune in his pick, or not his class rune" % [drawn])
	await Gate.answer_hero_draft(self, mp, false)
	ok(_run.rune_bag == bag0 and _run.party_runes == crest0, "§2d: answering a hero's cache moved the crest's bag or its slot")


# ── §2e — THE SCREEN FITS ─────────────────────────────────────────────────────
func _s2e_the_fit() -> void:
	print("\n§2e — both sections on the screen, the Confirm and Later outside any scroller")
	_new_run()
	var m: Dictionary = _run.party[2]
	_run.award_draft_pick(m)
	_run.queue_rune_pick(m, _run.roll_rune_candidates(m))
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var panels: Array = []
	var stack: Array = [hd]
	while not stack.is_empty():
		var cur: Node = stack.pop_back()
		if cur is PanelContainer:
			panels.append(cur)
		for k in cur.get_children():
			stack.append(k)
	var inside := true
	for p in panels:
		var r: Rect2 = (p as Control).get_global_rect()
		if r.position.x < 0 or r.end.x > 1280 or r.position.y < 0 or r.end.y > 652:
			inside = false
	ok(panels.size() == 2 and inside, "§2e: %d section panels, all inside the screen and above the Confirm: %s" % [panels.size(), inside])
	for meth in ["_confirm_hero_draft", "_close_hero_draft"]:
		var b: Button = _bound_any(hd, meth)
		var in_scroll := false
		var pn: Node = b.get_parent() if b != null else null
		while pn != null:
			if pn is ScrollContainer:
				in_scroll = true
			pn = pn.get_parent()
		ok(b != null and not in_scroll, "§2e: %s is missing or inside a scroller, where text can carry it off" % meth)


# ── §4 — THE RUNE PANEL'S SCROLL LOOKS LIKE A SCROLL (IB §0.1) ───────────────
func _scroller(n: Node) -> ScrollContainer:
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_front()
		if cur is ScrollContainer and not cur.is_queued_for_deletion():
			return cur
		for c in cur.get_children():
			stack.append(c)
	return null


func _s4_the_scroll() -> void:
	print("\n§4 — the rune panel: a bar where it scrolls, none where it fits")
	_new_run()
	var mp := await _to_map()
	var idx := SEATS.find("cleric")
	var m: Dictionary = _run.party[idx]
	var six: Array = Classes.class_engines("cleric").map(func(p): return Runes.engine_rune_id(String(p)))
	var ords: Array = []
	for rid in Runes.ids():
		if not Runes.is_engine_rune(String(rid)) and not Runes.is_retired(String(rid)) \
				and String(Runes.config(String(rid)).get("scope", "")) == "class:cleric":
			ords.append(String(rid))
	ords.sort_custom(func(a, b):
		var la := String(Runes.config(String(a)).get("desc", "")).length()
		var lb := String(Runes.config(String(b)).get("desc", "")).length()
		return la > lb or (la == lb and String(a) < String(b)))
	# THE LONGEST: every core slot empty, three worn, the holding full (IA §3d, 815 px).
	var worn: Array = []
	for k in 3:
		var w: Dictionary = Runes.build(String(ords[k]))
		w["equipped"] = true
		worn.append(w)
	var held_e: Array = six.map(func(rid): return Runes.build(String(rid)))
	var held_o: Array = []
	var k4 := 3
	while held_e.size() + held_o.size() < int(_run.HERO_HOLD_CAP) and k4 < ords.size():
		held_o.append(Runes.build(String(ords[k4])))
		k4 += 1
	m["engines"] = held_e
	m["runes"] = worn + held_o
	ok(_run.held_engines(m).is_empty() and _run.holding_full(m), "§4: the premise — every core slot empty and the holding full")
	mp.call("_open_rune_panel", idx)
	await Gate.frames(self, 4)
	var sc: ScrollContainer = _scroller(Gate.overlay(mp, 60))
	var content: float = sc.get_child(0).get_combined_minimum_size().y if sc != null and sc.get_child_count() > 0 else 0.0
	ok(sc != null and content > sc.size.y and sc.get_v_scroll_bar().visible and sc.get_v_scroll_bar().size.x > 0.0,
		"§4: at its longest (%.0f px in %.0f) the panel scrolls and shows no bar" % [content, sc.size.y if sc != null else 0.0])
	print("    the longest: %.0f px in a %.0f px scroller — the bar drawn %.0f px wide" % [
		content, sc.size.y if sc != null else 0.0, sc.get_v_scroll_bar().size.x if sc != null else 0.0])
	# AND WHERE IT FITS, NO BAR.
	for c in mp.get_children():
		if c is Control and (c as Control).z_index == 60:
			c.queue_free()
	mp.set("_rune_panel_for", -1)
	m["engines"] = []
	m["runes"] = []
	await Gate.frames(self, 2)
	mp.call("_open_rune_panel", idx)
	await Gate.frames(self, 4)
	var sc2: ScrollContainer = _scroller(Gate.overlay(mp, 60))
	var content2: float = sc2.get_child(0).get_combined_minimum_size().y if sc2 != null and sc2.get_child_count() > 0 else 0.0
	ok(sc2 != null and content2 <= sc2.size.y and not sc2.get_v_scroll_bar().visible,
		"§4: a panel that fits (%.0f px) shows a scroll bar" % content2)


# ── §5 — THE EMPTY CORE SLOT'S WORDS (IB §0.3) ───────────────────────────────
func _s5_the_empty_slot() -> void:
	print("\n§5 — an empty core slot reads `%s`" % EMPTY_ROW)
	_new_run()
	var mp := await _to_map()
	var m: Dictionary = _run.party[1]
	m["engines"] = []
	m["runes"] = []
	mp.call("_open_rune_panel", 1)
	await Gate.frames(self, 3)
	var tx: Array = _texts(Gate.overlay(mp, 60))
	ok(tx.count(EMPTY_ROW) == int(_run.ENGINE_SLOTS) and not tx.has(OLD_ROW),
		"§5: a hero holding no core rune drew %d `%s` rows of %d, or the old words" % [tx.count(EMPTY_ROW), EMPTY_ROW, int(_run.ENGINE_SLOTS)])
	ok(tx.has(HN_LINE), "§5: HN §2.6's line does not follow the slots where he holds no core rune")
	# One core rune slotted: one fewer empty row, and HN's line gone.
	for c in mp.get_children():
		if c is Control and (c as Control).z_index == 60:
			c.queue_free()
	mp.set("_rune_panel_for", -1)
	var core: Dictionary = Runes.build(Runes.engine_rune_id(String(Classes.class_engines("mage")[0])))
	core["equipped"] = true
	m["engines"] = [core]
	await Gate.frames(self, 2)
	mp.call("_open_rune_panel", 1)
	await Gate.frames(self, 3)
	var tx2: Array = _texts(Gate.overlay(mp, 60))
	ok(tx2.count(EMPTY_ROW) == int(_run.ENGINE_SLOTS) - 1 and not tx2.has(HN_LINE),
		"§5: one slotted drew %d empty rows (want %d), or HN's line still follows" % [tx2.count(EMPTY_ROW), int(_run.ENGINE_SLOTS) - 1])


# ── §6a — THE WALKERS' ONE HELPER, AT THE LONGEST AND THE EMPTIEST ───────────
# IA's standing rule: a re-point opens the longest case, not the shortest. The road walkers
# answer every hero's screen through `Gate.answer_hero_draft`, and a road deals what it deals,
# so the two ends are constructed here: THE LONGEST, the elite's looter at the cap — both
# sections and the bench step — TAKEN (check_gp's and check_gv's answer) and DECLINED
# (check_gj's and check_hk's); THE EMPTIEST, a rune alone with its cache empty, let go.
func _s6a_the_helper() -> void:
	print("\n§6a — the walkers' one helper, at the longest screen and the emptiest")
	for take in [true, false]:
		_new_run()
		var m: Dictionary = _run.party[0]
		var guard := 0
		while not _run.ability_slots_full(m) and guard < 20:
			guard += 1
			if not _run.award_draft_pick(m):
				break
			_run.take_draft_ability(m, String(_run.draft_choice(m)[0]))
		var owes_card: bool = _run.ability_slots_full(m) and _run.award_draft_pick(m)
		var cands: Array = _run.roll_rune_candidates(m)
		_run.queue_rune_pick(m, cands)
		ok(owes_card and not cands.is_empty() and int(m["rune_picks_owed"]) == 1,
			"§6a: the premise — the Warrior is not at the cap owing a card and a rune")
		var pool0: int = _run.owned_ability_names(m).size()
		var mp := await _to_map()
		var hd: Node = Gate.hero_draft(mp)
		ok(hd != null and int(hd.get_meta("hero_draft")) == 0 and Gate.has_text(hd, "ABILITIES")
				and Gate.has_text(hd, "RUNES"),
			"§6a: the longest screen did not open with both sections")
		var a: Dictionary = await Gate.answer_hero_draft(self, mp, take)
		var rn := String(a.get("rune", ""))
		ok(bool(a.get("confirmed", false)) and rn != "" and _run.party_rune_names().has(rn)
				and int(m["rune_picks_owed"]) == 0 and int(m["draft_picks_owed"]) == 0,
			"§6a: the helper did not answer the longest screen (take %s): %s" % [take, a])
		if take:
			var card := String(a.get("card", ""))
			var bench := String(a.get("bench", ""))
			ok(card != "" and bench != "" and _run.loadout_ability_names(m).has(card)
					and _run.benched_ability_names(m).has(bench)
					and _run.owned_ability_names(m).size() == pool0 + 1,
				"§6a: at the cap the helper did not take the card and bench a carried one: %s" % [a])
		else:
			ok(bool(a.get("declined", false)) and String(a.get("bench", "")) == ""
					and not _run.draft_refused(m).is_empty()
					and _run.owned_ability_names(m).size() == pool0,
				"§6a: the helper did not decline the card at the cap: %s" % [a])
	# THE EMPTIEST: a rune alone, the cache empty.
	_new_run()
	var mE: Dictionary = _run.party[1]
	var cE: Array = _run.roll_rune_candidates(mE)
	_run.queue_rune_pick(mE, cE)
	var worn: Array = []
	for id in Runes.eligible_ids(mE, []):
		worn.append(Runes.build(String(id)))
	mE["runes"] = worn
	ok(Runes.pool_empty_for(mE) and (_run.rune_choice(mE) as Array).is_empty()
			and int(mE.get("draft_picks_owed", 0)) == 0,
		"§6a: the premise — the Mage's screen is not a rune alone with an empty cache")
	var mp2 := await _to_map()
	var hd2: Node = Gate.hero_draft(mp2)
	ok(hd2 != null and not Gate.has_text(hd2, "ABILITIES") and Gate.has_text(hd2, "RUNES"),
		"§6a: the emptiest screen did not open as a rune section alone")
	var b: Dictionary = await Gate.answer_hero_draft(self, mp2, true)
	ok(bool(b.get("confirmed", false)) and bool(b.get("let_go", false))
			and String(b.get("card", "")) == "" and int(mE["rune_picks_owed"]) == 0,
		"§6a: the helper did not let the empty cache go: %s" % [b])
	ok(int(Gate.draft_census.get("at the cap, a card benched", 0)) >= 1
			and int(Gate.draft_census.get("an empty cache let go", 0)) >= 1,
		"§6a: the helper's census did not count the longest and the emptiest: %s" % [Gate.draft_census])


# ── §9 — THE PLAYER'S FILES ──────────────────────────────────────────────────
func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
