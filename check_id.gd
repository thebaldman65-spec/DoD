# BATCH ID — ONE SURFACE, AND THE GLYPHS.
#
#   §1a THE PICK OVERLAY IS RETIRED, AND ITS CENSUS IS RE-READ AT THE DELETION: no script names it, the
#       card's CHOOSE opens the hero's own screen, and each of the four kinds of pick — the draft, the rune
#       cache, the zone boss's ability, the mini-boss's upgrade — opens that screen with its own section and
#       no other overlay. ABILITIES holds the draft's offer and the zone boss's, each labelled with its door
#       (*from the elite*, *from an event*, *from the zone boss*); UPGRADES names the card and what the
#       upgrade does to it; a section with nothing owed is absent; one Confirm commits all four; Later
#       leaves all four owed. THE CAP ACROSS TWO OFFERS: one free slot asks the boss's card a bench and the
#       draft's none; none free asks both, and the boss's bench offers no card the draft's benches. A card
#       in both offers is drawn in the other dead. A boss offer every card of which waits on an engine
#       says so, does not hold the Confirm, and stays owed.
#   §1b THE LONGEST SCREEN, MEASURED: a hero owing all four at the cap with both bench steps, and one, two
#       and three sections, with and without a bench — every panel inside the screen and above the Confirm,
#       at the size it declares; every scroller draws Godot's bar exactly when its text outgrows it; the
#       Confirm and Later outside every scroller. The emptiest: an upgrade with nothing left to offer.
#   §1c THE WALKERS' ONE HELPER (`Gate.answer_hero_draft`) AT THE LONGEST AND THE EMPTIEST: four sections at
#       the cap, taken and declined, every section answered and both benches pressed; an empty cache let
#       go; a boss offer held back whole, not confirmed — and its census, by shape.
#   §2  THE WORDS: the title names what is on the screen and never misnames it, for every combination of
#       the four; the owed line is one sentence and one constant tail; the counter counts to four in words
#       with no parenthesis; the Confirm says the title's noun; ABILITIES, UPGRADES and RUNES are the heads.
#   §3a THE GLYPH SWEEP, KEPT: every ◆ and ↑ in the game's scripts and data, counted by file; in the
#       game's code (comments stripped) every ◆ is a pending pick's badge and ↑ is drawn at the four upgrade
#       surfaces and nowhere else; no data file carries either.
#   §3b EACH SURFACE APART: a held upgrade reads ↑ on the battle button, the hero sheet's chip, the
#       Blacksmith's offer and the map card's corner; a pick reads ◆ and nothing else; a held rune ✦; none
#       of the three where another is meant; the room each surface gives the glyph, measured.
#   §3c THE CLASS PASSIVE's CHIP IS GONE AND THE PASSIVE IS READ ON THE HERO SHEET; A RARE RELIC READS RARE
#       on the shelf and in the picker, the picker's widest row measured against its button.
#   §4a THE VOW's CHIP SAYS WHAT IT SILENCES — his ground's reflect, the Ruin draught, Suffering's heal —
#       with the heal figure read off his payload; nobody unvowed, and nobody vowed who holds none of the
#       three, wears it.
#   §4b MIRRORBOUND's CARD AGAINST ITS CODE: a quarter, the floor of 1 on an attack that deals nothing, both
#       sides — each read off the line and driven on a real board.
#   §4c THE MAP CARD's KIT BUTTON IS INSIDE ITS CARD, at its widest face, and clear of CHOOSE and of the Runes
#       button beside it (IH §2 — the core-rune line that stood there is gone).
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** Whether the sections read well is a playtest question; this
# asserts what each one holds, says and costs, and measures where it sits. The Sanctity and the dice the
# class passive's chip was spending (four events and four floats a spawn) are PRINTED in §3c, not priced.
# `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_id.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://id_profile.json"
const SCRATCH_RELICS := "user://id_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261013
const VOW := "vow_of_silence"
const KINDS := ["draft", "boss", "upgrade", "rune"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH ID — ONE SURFACE, AND THE GLYPHS")
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
	await _s1a_the_overlay_is_gone()
	await _s1a_the_sections()
	await _s1a_the_cap_across_offers()
	await _s1a_held_back_and_shared()
	await _s1b_the_longest()
	await _s1c_the_helper()
	await _s2_the_words()
	_s3a_the_sweep()
	await _s3b_each_surface()
	await _s3c_the_passive_and_the_relics()
	await _s4a_the_vow()
	await _s4b_mirrorbound()
	await _s4c_the_kit_button()
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


func _fresh_meta(relic_ids: Array = []) -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string(JSON.stringify(relic_ids))
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


# His kit filled to the cap, less `leave` slots, with cards his class can be drafted.
func _fill(m: Dictionary, leave: int) -> void:
	for n in Classes.offerable(Classes.draft_pool(String(m["key"])), _run.held_engines(m)):
		if _run.ability_slots_used(m) >= _run.ability_slot_cap() - leave:
			break
		if not _run.owned_ability_names(m).has(String(n)):
			_run.hold_ability(m, String(n), true)


# The picks of `kinds` owed by `m`, each through its own award door.
func _owe(m: Dictionary, kinds: Array) -> void:
	for k in kinds:
		match String(k):
			"draft":
				_run.award_draft_pick(m)
			"event":
				_run.award_draft_pick(m, "event")
			"boss":
				_run.award_ability_pick(m)
			"upgrade":
				_run.award_upgrade_pick(m)
			"rune":
				_run.queue_rune_pick(m, _run.roll_rune_candidates(m))


func _owed(m: Dictionary) -> Array:
	return [_run.pick_owed(m, "draft"), _run.pick_owed(m, "ability"),
		_run.pick_owed(m, "upgrade"), _run.pick_owed(m, "rune")]


func _press(n: Node, method: String, k := 0) -> Array:
	if n == null:
		return []
	var bs: Array = Gate.bound_buttons(n, method)
	if bs.size() <= k:
		return []
	var args := Gate.bound_args(bs[k], method)
	(bs[k] as Button).emit_signal("pressed")
	return args


func _all(n: Node, cls: String) -> Array:
	var out: Array = []
	if n == null:
		return out
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_front()
		if cur.is_class(cls) and not cur.is_queued_for_deletion():
			out.append(cur)
		for c in cur.get_children():
			stack.append(c)
	return out


func _texts(n: Node) -> Array:
	var out: Array = []
	for l in _all(n, "Label"):
		out.append(String((l as Label).text))
	for b in _all(n, "Button"):
		out.append(String((b as Button).text))
	return out


func _with_meta(n: Node, key: String) -> Array:
	var out: Array = []
	for c in _all(n, "Control"):
		if (c as Control).has_meta(key):
			out.append(c)
	return out


func _metas(n: Node, key: String) -> Array:
	return _with_meta(n, key).map(func(c): return String((c as Control).get_meta(key)))


func _label_at_y(n: Node, y: int) -> String:
	for l in _all(n, "Label"):
		if int((l as Label).position.y) == y:
			return String((l as Label).text)
	return ""


# The title, the owed line and the Confirm's face of the hero's screen up now.
func _title(mp: Node) -> String:
	return _label_at_y(Gate.hero_draft(mp), 16)


func _owed_line(mp: Node) -> String:
	return _label_at_y(Gate.hero_draft(mp), 62)


func _confirm(mp: Node) -> Button:
	for b in _all(Gate.hero_draft(mp), "Button"):
		for c in (b as Button).pressed.get_connections():
			if (c["callable"] as Callable).get_method() == "_confirm_hero_draft":
				return b
	return null


func _in_scroller(n: Node) -> bool:
	var p: Node = n.get_parent() if n != null else null
	while p != null:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _modals(mp: Node) -> Array:
	var out: Array = []
	for c in mp.get_children():
		if c is Control and not c.is_queued_for_deletion() \
				and [60, 62, 64, 70, 72, 74].has((c as Control).z_index):
			out.append(c)
	return out


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


# ── §1a — THE PICK OVERLAY IS RETIRED; EVERY KIND OPENS THE HERO'S SCREEN ───────────────────────

func _s1a_the_overlay_is_gone() -> void:
	print("\n§1a — the pick overlay is retired, its census re-read: every kind opens the hero's screen")
	# NO SCRIPT NAMES IT, comments stripped — so no caller is left to open what is not there.
	var named: Array = []
	var dir := DirAccess.open("res://scripts")
	for f in dir.get_files():
		if f.ends_with(".gd"):
			var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f))
			for needle in ["_open_pick_overlay", "_finish_take", "_pick_group"]:
				if src.contains(needle):
					named.append("%s: %s" % [f, needle])
	ok(named.is_empty(), "§1a: the game's scripts still name the retired overlay: %s" % [named])
	var map_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	ok(map_src.count("func _open_hero_draft(") == 1 and map_src.contains("pick_btn.pressed.connect(_open_hero_draft.bind(idx))"),
		"§1a: the card's CHOOSE does not open the hero's own screen")
	# THE CENSUS AT THE DELETION: the kinds a pick can be are the four, and each opens his screen with its
	# own section and nothing else up.
	ok(Array(_run.PICK_KINDS) == ["draft", "rune", "ability", "upgrade"],
		"§1a: the pick kinds are %s — a fifth kind owes the screen a section" % [_run.PICK_KINDS])
	var want := {"draft": ["offer", "draft"], "boss": ["offer", "boss"], "upgrade": ["section", "upgrades"],
		"rune": ["rune", ""]}
	for k in KINDS:
		_new_run()
		var m: Dictionary = _run.party[2]
		_owe(m, [k])
		var mp := await _to_map()
		var hd: Node = Gate.hero_draft(mp)
		var others: Array = _modals(mp).filter(func(c): return c != hd)
		var has_it := false
		if String(want[k][0]) == "rune":
			has_it = not Gate.bound_buttons(hd, "_stage_draft_rune").is_empty()
		elif hd != null:
			has_it = _metas(hd, String(want[k][0])).has(String(want[k][1]))
		ok(hd != null and int(hd.get_meta("hero_draft")) == 2 and has_it and others.is_empty(),
			"§1a (%s): the arrival did not open the Cleric's screen with its section alone (screen %s, section %s, other overlays %d)" % [
				k, hd != null, has_it, others.size()])
		# Later leaves it owed; the card's CHOOSE — bound to the screen, not to an overlay — reopens it.
		var before := _owed(m)
		_press(hd, "_close_hero_draft")
		await Gate.frames(self, 2)
		ok(Gate.hero_draft(mp) == null and _owed(m) == before,
			"§1a (%s): Later did not leave the pick owed and the screen shut (owed %s, was %s)" % [k, _owed(m), before])
		var choose: Button = Gate.bound_button(mp, "_open_hero_draft", [2])
		ok(choose != null and Gate.bound_button(mp, "_open_hero_draft", [0]) == null,
			"§1a (%s): the Cleric's card carries no CHOOSE bound to his screen, or another card does" % k)
		if choose != null:
			choose.emit_signal("pressed")
			await Gate.frames(self, 2)
		ok(Gate.hero_draft(mp) != null and _modals(mp).size() == 1,
			"§1a (%s): the CHOOSE did not reopen his screen alone" % k)
		mp.call("_shut_hero_draft")
	print("    four kinds, four screens, no other overlay; Later keeps each, CHOOSE reopens each")


func _s1a_the_sections() -> void:
	print("\n§1a — the sections: ABILITIES holds both offers, each labelled; UPGRADES names the card and what it does")
	# AN ELITE'S DRAFT, AN EVENT'S DRAFT, A FIXTURE'S (no record): each labelled by its door.
	for src in [["draft", "from the elite"], ["event", "from an event"], ["none", "from an elite or an event"]]:
		_new_run()
		var m: Dictionary = _run.party[0]
		if String(src[0]) == "none":
			m["draft_candidates"] = [_run.roll_draft_offer(m)]
			m["draft_picks_owed"] = 1
		else:
			_owe(m, [src[0]])
		var mp := await _to_map()
		var hd: Node = Gate.hero_draft(mp)
		ok(hd != null and _texts(hd).has(String(src[1])),
			"§1a: a %s draft is not labelled '%s' (%s)" % [src[0], src[1], _texts(hd) if hd != null else "no screen"])
		if hd != null:
			mp.call("_shut_hero_draft")
	# THE DRAFT AND THE ZONE BOSS's ABILITY: one ABILITIES section, two offers, two labels; UPGRADES and RUNES apart.
	_new_run()
	var m2: Dictionary = _run.party[1]
	_owe(m2, ["draft", "boss", "upgrade", "rune"])
	var mp2 := await _to_map()
	var hd2: Node = Gate.hero_draft(mp2)
	var sections: Array = _metas(hd2, "section")
	var offers: Array = _metas(hd2, "offer")
	ok(sections.count("abilities") == 1 and sections.count("upgrades") == 1 and offers == ["draft", "boss"],
		"§1a: four owed did not draw one ABILITIES section with the draft's and the boss's offers and one UPGRADES (sections %s, offers %s)" % [sections, offers])
	ok(_texts(hd2).has("from the elite") and _texts(hd2).has("from the zone boss") and _texts(hd2).has("from the mini-boss"),
		"§1a: an offer is not labelled with its door")
	# The boss's cards draw through the draft's renderer: each live card is a button bound to `_stage_boss`,
	# and its computed block is drawn under it as the draft's is.
	var live_b: Array = _run.ability_choice(m2)
	var boss_btns: Array = Gate.bound_buttons(hd2, "_stage_boss").map(func(b): return String(Gate.bound_args(b, "_stage_boss")[1]))
	ok(not live_b.is_empty() and boss_btns == live_b,
		"§1a: the boss's offer drew %s where its live list is %s" % [boss_btns, live_b])
	var block0 := Classes.computed_block(Classes.pool_ability(String(live_b[0])), 0,
		String(Classes.hero_config(String(m2["key"])).get("resource_name", "Mana"))) if not live_b.is_empty() else "?"
	ok(_texts(hd2).has(block0), "§1a: the boss's first card is not drawn with its computed block, as a draft's card is")
	mp2.call("_shut_hero_draft")
	# UPGRADES: each choice names the card and the upgrade, says what the upgrade does, and what it does to THIS card.
	_new_run()
	var m3: Dictionary = {}
	var card := ""
	for hm in _run.party:
		for n in _run.owned_ability_names(hm):
			var ab: Ability = Classes.pool_ability(String(n))
			if card == "" and ab != null and ab.damage > 0 and ab.cooldown > 0:
				card = String(n)
				m3 = hm
	ok(card != "", "§1a: the premise — a hero carries a card with damage and a cooldown")
	if card == "":
		return
	m3["up_candidates"] = [[{"id": "up_damage", "ability": card}, {"id": "up_cooldown", "ability": card},
		{"id": "up_pierce", "ability": card}]]
	m3["up_picks_owed"] = 1
	var mp3 := await _to_map()
	var hd3: Node = Gate.hero_draft(mp3)
	var tx: Array = _texts(hd3)
	var base: Ability = Classes.pool_ability(card)
	var honed := "Damage: %d%% → %d%%" % [base.damage, int(round(base.damage * 1.5))]
	var quick := ("Cooldown: %d → %d" % [base.cooldown, base.cooldown - 2]) if base.cooldown > 2 \
		else "Cooldown: %d turn%s → none" % [base.cooldown, "" if base.cooldown == 1 else "s"]
	ok(card != "" and tx.has("%s: Honed" % card) and tx.has("%s: Quickened" % card) and tx.has("%s: Piercing" % card),
		"§1a: the UPGRADES section does not name each choice as card: upgrade (%s)" % [tx])
	ok(tx.has(_run.upgrade_desc("up_damage")) and tx.has(_run.upgrade_desc("up_pierce")),
		"§1a: the UPGRADES section does not say what each upgrade does")
	ok(tx.has(honed) and tx.has(quick), "§1a: the UPGRADES section does not show what Honed and Quickened do to %s ('%s', '%s' in %s)" % [card, honed, quick, tx])
	ok(_run.upgrade_preview(m3, {"id": "up_pierce", "ability": card}) == "",
		"§1a: Piercing moves a figure the card's block prints — the premise of a choice shown with its sentence alone")
	print("    %s: '%s', '%s', Piercing its sentence alone" % [card, honed, quick])
	mp3.call("_shut_hero_draft")
	# ONE CONFIRM COMMITS ALL FOUR, at the cap, both benches; the benched kept.
	_new_run()
	var m4: Dictionary = _run.party[2]
	_fill(m4, 0)
	_owe(m4, ["draft", "boss", "upgrade", "rune"])
	var ups0: int = (m4.get("upgrades", []) as Array).size()
	var mp4 := await _to_map()
	var a: Dictionary = await Gate.answer_hero_draft(self, mp4, true)
	var eq: Array = _run.equipped_ability_names(m4)
	ok(bool(a.get("confirmed", false)) and _owed(m4) == [0, 0, 0, 0],
		"§1a: one Confirm did not commit all four (owed %s, %s)" % [_owed(m4), a])
	ok(eq.has(String(a["card"])) and eq.has(String(a["boss"])) and not eq.has(String(a["bench"]))
			and not eq.has(String(a["boss_bench"])) and String(a["bench"]) != String(a["boss_bench"])
			and (m4["bm_abilities"] as Array).has(String(a["bench"])) and (m4["bm_abilities"] as Array).has(String(a["boss_bench"])),
		"§1a: at the cap the two cards are not carried and the two benched kept (%s, carried %s)" % [a, eq])
	ok(_run.ability_slots_used(m4) == _run.ability_slot_cap() and (m4["upgrades"] as Array).size() == ups0 + 1,
		"§1a: the kit left its cap or the upgrade did not land")


func _s1a_the_cap_across_offers() -> void:
	print("\n§1a — the cap across two offers: the Confirm's order counts it")
	_new_run()
	var m: Dictionary = _run.party[1]
	_fill(m, 1)
	_owe(m, ["draft", "boss"])
	var mp := await _to_map()
	_press(Gate.hero_draft(mp), "_stage_draft")
	await Gate.frames(self, 1)
	ok(Gate.bound_buttons(Gate.hero_draft(mp), "_open_drop_overlay").is_empty(),
		"§1a: with one slot free the draft's card asks a bench")
	_press(Gate.hero_draft(mp), "_stage_boss")
	await Gate.frames(self, 1)
	var steps: Array = Gate.bound_buttons(Gate.hero_draft(mp), "_open_drop_overlay")
	ok(steps.size() == 1 and String(Gate.bound_args(steps[0], "_open_drop_overlay")[1]) == "ability",
		"§1a: with one slot free and the draft's card staged, the boss's card does not ask the bench")
	ok(_texts(Gate.hero_draft(mp)).has("Ability slots %d of %d  —  taking both means benching one" % [
		_run.ability_slots_used(m), _run.ability_slot_cap()]), "§1a: the ledger does not say taking both costs a bench")
	_press(Gate.hero_draft(mp), "_stage_draft_decline")
	await Gate.frames(self, 1)
	ok(Gate.bound_buttons(Gate.hero_draft(mp), "_open_drop_overlay").is_empty() \
			and _confirm(mp) != null and not _confirm(mp).disabled,
		"§1a: with the draft declined the boss's card still asks the bench, or the screen will not confirm")
	mp.call("_shut_hero_draft")
	# NONE FREE: both ask, and the boss's bench offers no card the draft's benches.
	_new_run()
	var m2: Dictionary = _run.party[1]
	_fill(m2, 0)
	_owe(m2, ["draft", "boss"])
	var mp2 := await _to_map()
	_press(Gate.hero_draft(mp2), "_stage_draft")
	await Gate.frames(self, 1)
	_press(Gate.hero_draft(mp2), "_stage_boss")
	await Gate.frames(self, 1)
	var kinds: Array = Gate.bound_buttons(Gate.hero_draft(mp2), "_open_drop_overlay").map(
		func(b): return String(Gate.bound_args(b, "_open_drop_overlay")[1]))
	ok(kinds == ["draft", "ability"], "§1a: with no slot free both cards do not ask a bench (%s)" % [kinds])
	var d_bench := String(_press(Gate.hero_draft(mp2), "_open_drop_overlay", 0)[2]) if kinds.size() == 2 else ""
	await Gate.frames(self, 1)
	var first: Array = Gate.pick_choices(Gate.overlay(mp2, 64))
	var named := String(((first[0] as Button).get_meta("choice") as Array)[1][1]) if not first.is_empty() else ""
	if not first.is_empty():
		(first[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 1)
	for b in Gate.bound_buttons(Gate.hero_draft(mp2), "_open_drop_overlay"):
		if String(Gate.bound_args(b, "_open_drop_overlay")[1]) == "ability":
			(b as Button).emit_signal("pressed")
	await Gate.frames(self, 1)
	var second: Array = Gate.pick_choices(Gate.overlay(mp2, 64)).map(
		func(b): return String(((b as Button).get_meta("choice") as Array)[1][1]))
	ok(d_bench != "" and named != "" and not second.is_empty() and not second.has(named),
		"§1a: the boss's bench step offers %s, the card the draft's benches (%s)" % [second, named])
	for ov in _modals(mp2):
		if (ov as Control).z_index == 64:
			ov.queue_free()
	mp2.call("_shut_hero_draft")
	await Gate.frames(self, 1)
	# THE BOSS's COMMIT DOOR ITSELF (`_pick_ability`), which the screen never reaches unbenched at the cap — so its own
	# refusal is driven here, not left to a source needle: at the cap with no bench it refuses and moves nothing; at the cap
	# with a bench it commits and benches that card; below the cap a bench named is not taken.
	_new_run()
	var m3: Dictionary = _run.party[1]
	_fill(m3, 0)
	_owe(m3, ["boss"])
	var mp3 := await _to_map()
	mp3.call("_shut_hero_draft")
	var offer3: Array = _run.ability_choice(m3)
	var card3 := String(offer3[0]) if not offer3.is_empty() else ""
	var kit3: Array = (m3["bm_equipped"] as Array).duplicate()
	var why3 := String(mp3.call("_pick_ability", 1, card3, ""))
	ok(card3 != "" and why3 == "the kit is full — name an ability to bench" and int(_owed(m3)[1]) == 1
			and m3["bm_equipped"] == kit3,
		"§1a: at the cap the boss's commit door took %s with no bench ('%s', owed %d)" % [card3, why3, int(_owed(m3)[1])])
	var bench3 := String(kit3[0]) if not kit3.is_empty() else ""
	var why3b := String(mp3.call("_pick_ability", 1, card3, bench3))
	ok(why3b == "" and (m3["bm_equipped"] as Array).has(card3) and not (m3["bm_equipped"] as Array).has(bench3)
			and int(_owed(m3)[1]) == 0,
		"§1a: at the cap with %s named the boss's commit door did not take %s and bench it ('%s')" % [bench3, card3, why3b])
	_new_run()
	var m4: Dictionary = _run.party[1]
	_fill(m4, 2)
	_owe(m4, ["boss"])
	var mp4 := await _to_map()
	mp4.call("_shut_hero_draft")
	var offer4: Array = _run.ability_choice(m4)
	var card4 := String(offer4[0]) if not offer4.is_empty() else ""
	var earned4: Array = (m4["bm_equipped"] as Array).duplicate()
	var why4 := String(mp4.call("_pick_ability", 1, card4, String(earned4[0]) if not earned4.is_empty() else ""))
	ok(card4 != "" and not earned4.is_empty() and why4 == "" and (m4["bm_equipped"] as Array).has(card4)
			and (m4["bm_equipped"] as Array).has(String(earned4[0])),
		"§1a: below the cap the boss's commit door benched the card it was handed (%s, '%s')" % [earned4, why4])
	await Gate.frames(self, 1)


func _s1a_held_back_and_shared() -> void:
	print("\n§1a — a boss offer held back whole stays owed and does not hold the Confirm; a card in both offers is taken once")
	_new_run()
	var m: Dictionary = _run.party[2]
	var gated: Array = Classes.draft_pool("cleric").filter(func(n): return Classes.engine_read(String(n)) != "")
	m["bm_candidates"] = [gated.slice(0, 3)]
	m["bm_picks_owed"] = 1
	for e in m.get("engines", []):
		(e as Dictionary)["equipped"] = false
	ok(gated.size() >= 3 and _run.ability_choice(m).is_empty() and _run.ability_choice_withheld(m).size() == 3,
		"§1a: the premise — three cards that wait on an engine, none slotted")
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var says_wait := false
	for t in _texts(hd):
		if String(t).begins_with("The offer holds 3 more that wait on") and String(t).ends_with("Equip it and they return."):
			says_wait = true
	ok(says_wait and _texts(hd).has("nothing to take now — the pick stays owed"),
		"§1a: the held-back offer does not say what it waits on and that the pick stays owed (%s)" % [_texts(hd)])
	ok(_confirm(mp) != null and _confirm(mp).disabled and _confirm(mp).text == "Nothing to choose yet",
		"§1a: a screen with nothing to take shows '%s'" % (_confirm(mp).text if _confirm(mp) != null else "no Confirm"))
	mp.call("_shut_hero_draft")
	# BESIDE A DRAFT: the draft confirms, the boss's pick stays owed and stored.
	_owe(m, ["draft"])
	var mp2 := await _to_map()
	_press(Gate.hero_draft(mp2), "_stage_draft")
	await Gate.frames(self, 1)
	var c2: Button = _confirm(mp2)
	ok(c2 != null and not c2.disabled and c2.text == "Confirm the draft",
		"§1a: the draft decided beside a held-back boss offer did not light the Confirm ('%s')" % (c2.text if c2 != null else ""))
	if c2 != null:
		c2.emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(_run.pick_owed(m, "draft") == 0 and _run.pick_owed(m, "ability") == 1 and (m["bm_candidates"] as Array).size() == 1,
		"§1a: the Confirm did not take the draft and keep the boss's pick owed and stored (owed %s)" % [_owed(m)])
	if Gate.hero_draft(current_scene) != null:
		current_scene.call("_shut_hero_draft")
	# A CARD IN BOTH OFFERS: staged in the draft's, drawn dead in the boss's, and refused there.
	_new_run()
	var w: Dictionary = _run.party[0]
	_owe(w, ["draft", "boss"])
	var x := String((w["draft_candidates"] as Array)[0][0])
	((w["bm_candidates"] as Array)[0] as Array)[0] = x
	var mp3 := await _to_map()
	var shared: bool = _run.ability_choice(w).has(x) and _run.draft_choice(w).has(x)
	ok(shared, "§1a: the premise — %s in both live offers" % x)
	mp3.call("_stage_draft", 0, x)
	await Gate.frames(self, 1)
	var dead := false
	for b in _all(Gate.hero_draft(mp3), "Button"):
		if (b as Button).disabled and String((b as Button).text) == "%s  — chosen from the elite" % x:
			dead = true
	ok(dead and Gate.bound_button(Gate.hero_draft(mp3), "_stage_boss", [0, x]) == null,
		"§1a: the boss's copy of %s is pressable while the draft's is staged" % x)
	mp3.call("_stage_boss", 0, x)
	await Gate.frames(self, 1)
	ok(String(mp3.call("_stage_of", 0)["bcard"]) == "", "§1a: the boss's offer staged %s, which the draft's has" % x)
	mp3.call("_shut_hero_draft")


# ── §1b — THE LONGEST SCREEN, MEASURED ──────────────────────────────────────────────────────

func _measure(mp: Node, label: String) -> Dictionary:
	var hd: Node = Gate.hero_draft(mp)
	var out := {"label": label, "panels": 0, "inside": true, "grew": false, "bars_ok": true, "span": 0.0,
		"lowest": 0.0, "scrollers": []}
	var lo := 1280.0
	var hi := 0.0
	for p in _all(hd, "PanelContainer"):
		var pc: PanelContainer = p
		var r := pc.get_global_rect()
		out["panels"] += 1
		lo = minf(lo, r.position.x)
		hi = maxf(hi, r.end.x)
		out["lowest"] = maxf(float(out["lowest"]), r.end.y)
		if r.position.x < 0 or r.end.x > 1280 or r.position.y < 0 or r.end.y > 652:
			out["inside"] = false
		if absf(pc.size.y - pc.custom_minimum_size.y) > 0.5:
			out["grew"] = true
	out["span"] = hi - lo
	for sc in _all(hd, "ScrollContainer"):
		var s: ScrollContainer = sc
		var content: float = (s.get_child(0) as Control).get_combined_minimum_size().y
		var bar: bool = s.get_v_scroll_bar().visible
		(out["scrollers"] as Array).append([int(round(content)), int(s.size.y), bar])
		if bar != (content > s.size.y + 0.5):
			out["bars_ok"] = false
	return out


func _s1b_the_longest() -> void:
	print("\n§1b — the longest screen: four sections at the cap with both benches; one to four sections, with and without a bench")
	# One to four kinds, with and without a bench: an ability offer at the cap draws its bench step once
	# its card is staged, so "with a bench" stages every ability offer on the screen.
	var cases := [["one: an upgrade", ["upgrade"], false], ["one: the draft", ["draft"], false],
		["two: the draft and the boss", ["draft", "boss"], false],
		["three: + the upgrade", ["draft", "boss", "upgrade"], false], ["four: + the rune", ["draft", "boss", "upgrade", "rune"], false],
		["one at the cap, its bench", ["draft"], true],
		["two at the cap, both benches", ["draft", "boss"], true], ["three at the cap, both benches", ["draft", "boss", "upgrade"], true],
		["four at the cap, both benches", ["draft", "boss", "upgrade", "rune"], true]]
	var rows: Array = []
	for c in cases:
		_new_run()
		var m: Dictionary = _run.party[2]
		if bool(c[2]):
			_fill(m, 0)
		_owe(m, c[1])
		var mp := await _to_map()
		if bool(c[2]):
			var staged := 0
			for st in [["draft", "_stage_draft"], ["boss", "_stage_boss"]]:
				if (c[1] as Array).has(st[0]):
					_press(Gate.hero_draft(mp), String(st[1]))
					await Gate.frames(self, 2)
					staged += 1
			ok(Gate.bound_buttons(Gate.hero_draft(mp), "_open_drop_overlay").size() == staged,
				"§1b (%s): the premise — a bench step drawn for each of the %d offers staged" % [c[0], staged])
		var r := _measure(mp, String(c[0]))
		rows.append(r)
		ok(bool(r["inside"]) and not bool(r["grew"]),
			"§1b (%s): a panel runs off the screen or past the Confirm, or outgrew what it declares (lowest %.0f)" % [c[0], r["lowest"]])
		ok(bool(r["bars_ok"]), "§1b (%s): a scroller's bar does not show exactly when its text outgrows it: %s" % [c[0], r["scrollers"]])
		for meth in ["_confirm_hero_draft", "_close_hero_draft"]:
			var bs: Array = Gate.bound_buttons(Gate.hero_draft(mp), meth)
			var b: Button = bs[0] if not bs.is_empty() else _confirm(mp)
			ok(b != null and not _in_scroller(b), "§1b (%s): %s is missing or inside a scroller" % [c[0], meth])
		mp.call("_shut_hero_draft")
		await Gate.frames(self, 1)
	for r2 in rows:
		print("    %-32s %d panels, %4.0f px wide, lowest y %3.0f; scrollers [content, viewport, bar] %s" % [
			r2["label"], r2["panels"], r2["span"], r2["lowest"], r2["scrollers"]])
	var four: Dictionary = rows[rows.size() - 1]
	ok(int(four["panels"]) == 3 and float(four["span"]) <= 1280.0 and (four["scrollers"] as Array).size() == 4,
		"§1b: the longest screen is not three sections, four columns, inside 1280 px (%s)" % [four])
	# THE EMPTIEST: an upgrade with nothing left — every id he could be offered already his.
	_new_run()
	var e: Dictionary = _run.party[0]
	var all_ups: Array = []
	for id in _run.ABILITY_UPGRADES:
		all_ups.append({"id": String(id), "ability": "Strike"})
	e["upgrades"] = all_ups
	e["up_candidates"] = [[{"id": "up_damage", "ability": "Strike"}]]
	e["up_picks_owed"] = 1
	ok(_run.upgrade_choice(e).is_empty(), "§1b: the premise — an upgrade offer with nothing left to take")
	var mpe := await _to_map()
	var tx: Array = _texts(Gate.hero_draft(mpe))
	# RE-POINTED BY BATCH IE §5 (ruled at IE §0.3): an offer with nothing left at all cannot refill, so it
	# is SPENT, in the cache's words, rather than left owed — the screen says so and offers Let it go;
	# the Confirm waits on that one decision. `check_ie` §5 drives the spend to the card.
	ok(tx.has(mpe.get("UPGRADE_SPENT_NOTE")) and not tx.has("nothing to take now — the pick stays owed")
			and Gate.bound_buttons(Gate.hero_draft(mpe), "_stage_spend").size() == 1
			and _confirm(mpe) != null and _confirm(mpe).disabled and _confirm(mpe).text == "One choice still to make",
		"§1b: the emptiest screen does not say its pick is spent and offer Let it go (%s)" % [tx])
	mpe.call("_shut_hero_draft")


# ── §1c — THE ONE HELPER AT THE LONGEST AND THE EMPTIEST ────────────────────────────────────

func _s1c_the_helper() -> void:
	print("\n§1c — the walkers' one helper: four sections at the cap, taken and declined; the emptiest")
	Gate.draft_census = {}
	for take in [true, false]:
		_new_run()
		var m: Dictionary = _run.party[3]
		_fill(m, 0)
		_owe(m, ["draft", "boss", "upgrade", "rune"])
		var mp := await _to_map()
		var a: Dictionary = await Gate.answer_hero_draft(self, mp, take)
		ok(bool(a["confirmed"]) and _owed(m) == [0, 0, 0, 0] and String(a["boss"]) != "" and String(a["upgrade"]) != ""
				and String(a["rune"]) != "" and String(a["boss_bench"]) != ""
				and (String(a["bench"]) != "" if take else bool(a["declined"])),
			"§1c (take %s): the helper did not answer every section of the longest screen: %s, owed %s" % [take, a, _owed(m)])
	# THE EMPTIEST: a rune alone, its cache empty, let go.
	_new_run()
	var r: Dictionary = _run.party[1]
	r["rune_candidates"] = [[]]
	r["rune_picks_owed"] = 1
	var mpr := await _to_map()
	var b: Dictionary = await Gate.answer_hero_draft(self, mpr, true)
	ok(bool(b["confirmed"]) and bool(b["let_go"]) and _run.pick_owed(r, "rune") == 0,
		"§1c: the helper did not let an empty cache go: %s" % [b])
	# A BOSS OFFER HELD BACK WHOLE: the helper presses nothing there, and says it could not confirm.
	_new_run()
	var h: Dictionary = _run.party[2]
	h["bm_candidates"] = [Classes.draft_pool("cleric").filter(func(n): return Classes.engine_read(String(n)) != "").slice(0, 3)]
	h["bm_picks_owed"] = 1
	for e in h.get("engines", []):
		(e as Dictionary)["equipped"] = false
	var mph := await _to_map()
	var c: Dictionary = await Gate.answer_hero_draft(self, mph, true)
	ok(not bool(c["confirmed"]) and String(c["boss"]) == "" and _run.pick_owed(h, "ability") == 1,
		"§1c: the helper pressed something on a screen with nothing to take: %s" % [c])
	mph.call("_shut_hero_draft")
	var cen: Dictionary = Gate.draft_census
	print("    the helper's census, by shape: %s" % [cen])
	ok(int(cen.get("draft + boss + upgrade + rune", 0)) == 2 and int(cen.get("at the cap, both offers benched", 0)) == 1
			and int(cen.get("at the cap, a card benched", 0)) == 2 and int(cen.get("rune", 0)) == 1
			and int(cen.get("an empty cache let go", 0)) == 1 and int(cen.get("boss", 0)) == 1
			and int(cen.get("NOT CONFIRMED", 0)) == 1 and int(cen.get("screens", 0)) == 4,
		"§1c: the helper's census did not count the longest, the emptiest and the held-back by shape: %s" % [cen])
	Gate.draft_census = {}


# ── §2 — THE WORDS ───────────────────────────────────────────────────────────────────────────

func _s2_the_words() -> void:
	print("\n§2 — the title, the owed line, the counter and the Confirm, for every combination of the four")
	var nouns := {"draft": "a new ability", "boss": "a new ability", "upgrade": "an ability upgrade", "rune": "a rune from the cache"}
	var seen_titles := {}
	for mask in range(1, 16):
		var kinds: Array = []
		for k in 4:
			if mask & (1 << k):
				kinds.append(KINDS[k])
		_new_run()
		var m: Dictionary = _run.party[2]
		_owe(m, kinds)
		var mp := await _to_map()
		var t := _title(mp)
		var line := _owed_line(mp)
		var who := String(_run.nameplate(m))
		# BATCH IE §0.4 — THE ABILITY: a zone boss's pick without the draft names itself, and the
		# non-draft kinds join as the owed line joins (*A, B and C*); a draft still takes THE DRAFT.
		var tn: Array = []
		for kn in [["boss", "THE ABILITY"], ["upgrade", "THE UPGRADE"], ["rune", "THE CACHE"]]:
			if kinds.has(kn[0]):
				tn.append(kn[1])
		var want_title: String = "THE DRAFT" if kinds.has("draft") else (String(tn[0]) if tn.size() == 1
			else "%s AND %s" % [", ".join(tn.slice(0, tn.size() - 1)), tn[tn.size() - 1]])
		ok(t == "%s — %s" % [want_title, who], "§2 %s: the title reads '%s'" % [kinds, t])
		seen_titles[want_title] = true
		# The owed line: what he is owed, as one sentence, then the one tail.
		var items: Array = []
		var abilities := int(kinds.has("draft")) + int(kinds.has("boss"))
		if abilities == 2:
			items.append("two new abilities")
		elif abilities == 1:
			items.append("a new ability")
		if kinds.has("upgrade"):
			items.append(nouns["upgrade"])
		if kinds.has("rune"):
			items.append(nouns["rune"])
		var said: String = items[0] if items.size() == 1 else "%s and %s" % [", ".join(items.slice(0, items.size() - 1)), items[items.size() - 1]]
		var want_line := "%s. Decide, then confirm." % (said.substr(0, 1).to_upper() + said.substr(1))
		ok(line == want_line and not line.contains("\n") and line.count(".") == 2,
			"§2 %s: the owed line reads '%s', not one sentence and the tail ('%s')" % [kinds, line, want_line])
		# The counter: words to four, no parenthesis; then the Confirm says the title's noun.
		var n := kinds.size()
		var words := ["One", "Two", "Three", "Four"]
		var cf: Button = _confirm(mp)
		ok(cf != null and cf.disabled and cf.text == "%s choice%s still to make" % [words[n - 1], "" if n == 1 else "s"]
				and not cf.text.contains("(") and not cf.text.contains(")"),
			"§2 %s: the counter reads '%s'" % [kinds, cf.text if cf != null else ""])
		var a: Dictionary = await Gate.answer_hero_draft(self, mp, true)
		# (answered: the Confirm's face just before it was pressed is the noun's — read it on a fresh screen below)
		ok(bool(a["confirmed"]), "§2 %s: the screen would not confirm once every section was decided" % [kinds])
	ok(seen_titles.size() == 8, "§2: the eight titles (THE DRAFT and the seven joins of the other three) were not all met: %s" % [seen_titles.keys()])
	# THE CONFIRM's DECIDED FACE, AND THE HEADS: four owed, every section decided, before the press.
	_new_run()
	var m2: Dictionary = _run.party[0]
	_owe(m2, KINDS)
	var mp2 := await _to_map()
	for meth in ["_stage_draft", "_stage_boss", "_stage_upgrade", "_stage_draft_rune"]:
		_press(Gate.hero_draft(mp2), meth)
		await Gate.frames(self, 1)
	var cf2: Button = _confirm(mp2)
	ok(cf2 != null and not cf2.disabled and cf2.text == "Confirm the draft", "§2: the decided Confirm reads '%s'" % (cf2.text if cf2 != null else ""))
	var heads: Array = _texts(Gate.hero_draft(mp2))
	ok(heads.has("ABILITIES") and heads.has("UPGRADES") and heads.has("RUNES"),
		"§2: the section heads are not ABILITIES, UPGRADES and RUNES")
	mp2.call("_shut_hero_draft")
	# THE UPGRADE AND THE CACHE: the Confirm says that noun, never the draft's.
	_new_run()
	var m3: Dictionary = _run.party[0]
	_owe(m3, ["upgrade", "rune"])
	var mp3 := await _to_map()
	_press(Gate.hero_draft(mp3), "_stage_upgrade")
	await Gate.frames(self, 1)
	_press(Gate.hero_draft(mp3), "_stage_draft_rune")
	await Gate.frames(self, 1)
	ok(_confirm(mp3) != null and _confirm(mp3).text == "Confirm the upgrade and the cache",
		"§2: an upgrade-and-cache screen's Confirm reads '%s'" % (_confirm(mp3).text if _confirm(mp3) != null else ""))
	mp3.call("_shut_hero_draft")
	# THE HOUSE WORD FOR AN UPGRADE IS THE GAME's OWN: the victory card and the corner's tooltip say it.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var msrc := FileAccess.get_file_as_string("res://scripts/map_screen.gd")
	ok(bsrc.contains("ABILITY UPGRADE: %s may choose one") and msrc.contains("\"Ability upgrades\\n%s\""),
		"§2: the game no longer says *ability upgrade* where a player reads one — UPGRADES is not its word")


# ── §3a — THE GLYPH SWEEP, KEPT ─────────────────────────────────────────────────────────────

const DIAMOND := "◆"
const ARROW := "↑"
const STAR := "✦"  # BATCH IE §4 — ✦ names a rune (§3a's third glyph)


func _s3a_the_sweep() -> void:
	print("\n§3a — the glyph sweep: every ◆, ↑ and ✦ in the game's scripts and data")
	var census := {}
	var code_diamonds: Array = []
	var code_arrows: Array = []
	var code_stars: Array = []
	var dir := DirAccess.open("res://scripts")
	for f in dir.get_files():
		if not f.ends_with(".gd"):
			continue
		var raw := FileAccess.get_file_as_string("res://scripts/" + f)
		if raw.contains(DIAMOND) or raw.contains(ARROW):
			census["scripts/" + f] = [raw.count(DIAMOND), raw.count(ARROW)]
		var lines := Gate.strip_comments(raw).split("\n")
		for ln in lines:
			if String(ln).contains(DIAMOND):
				code_diamonds.append("%s: %s" % [f, String(ln).strip_edges()])
			if String(ln).contains(ARROW):
				code_arrows.append("%s: %s" % [f, String(ln).strip_edges()])
			if String(ln).contains(STAR):
				code_stars.append("%s: %s" % [f, String(ln).strip_edges()])
	var data_hits: Array = []
	var dd := DirAccess.open("res://data")
	for f2 in dd.get_files():
		var raw2 := FileAccess.get_file_as_string("res://data/" + f2)
		if raw2.contains(DIAMOND) or raw2.contains(ARROW) or raw2.contains(STAR):
			data_hits.append(f2)
	print("    per script [◆, ↑] including comments: %s" % [census])
	print("    in code, comments stripped — ◆: %d line(s), ↑: %d line(s); data files carrying either: %s" % [
		code_diamonds.size(), code_arrows.size(), data_hits])
	# EVERY ◆ LEFT IN THE GAME's CODE IS A PENDING PICK's BADGE — one line for each of the four kinds.
	var stray: Array = code_diamonds.filter(func(l):
		return not RegEx.create_from_string("^map_screen\\.gd: badges\\.append\\(\"◆ %d (ability|draft|upgrade|rune)\" % owed_[a-z]+\\)$").search(String(l)))
	ok(code_diamonds.size() == 4 and stray.is_empty(), "§3a: ◆ is drawn for something that is not a pick's badge: %s" % [stray if not stray.is_empty() else code_diamonds])
	# ↑ IS DRAWN AT THE FOUR UPGRADE SURFACES AND NOWHERE ELSE (a fifth line is the preview's arrow, →, not ↑):
	# the battle button, the Blacksmith's offer, and on the map the card's corner and — since IH §5, where the
	# hero sheet's chip carried it until IH §3 — the Kit panel's row.
	var where := {"battle.gd": 0, "blacksmith_screen.gd": 0, "map_screen.gd": 0}
	var want_where := {"battle.gd": 1, "blacksmith_screen.gd": 1, "map_screen.gd": 2}
	var other: Array = []
	for l2 in code_arrows:
		var f3 := String(l2).get_slice(":", 0)
		if where.has(f3):
			where[f3] += 1
		else:
			other.append(l2)
	ok(other.is_empty() and where == want_where,
		"§3a: ↑ is not drawn once on each of the four upgrade surfaces and nowhere else: %s %s" % [where, other])
	# BATCH IE §4 (ruled at IE §0.1) — ✦ NAMES A RUNE: every ✦ left in the game's code is a rune's mark or a
	# count of runes held unworn — the battle's rune chip, the nameplate's count, the bag's crest count and the kit
	# preview's prose — and nothing else. **AND SINCE IF §3 THE RULE IS FINISHED, WITH NO EXCEPTION LEFT**: the
	# loadout panel's two lines (IE's finding — a CARRIED CARD marked ✦) and the crest panel's worn rune are gone
	# with the sections each panel now draws, so no panel in the game states a row's state twice (`check_if` §3c
	# sweeps the three sectioned panels for it).
	var star_lines := {
		"rune mark — the battle's rune chip": "^battle\\.gd: const RUNE_CHIP_TAG := \"✦\"$",
		"rune count — the kit preview's prose": "^kit_preview\\.gd: _line\\(\"   ✦ %d held, not worn",
		"rune count — the nameplate": "^map_screen\\.gd: mark\\.text = \"✦ %d\" % waiting$",
		"rune count — the bag's crest runes": "^map_screen\\.gd: \"  ✦ %d\" % crest_waiting if crest_waiting > 0",
	}
	var met := {}
	var stray_star: Array = []
	for l3 in code_stars:
		var named := ""
		for what in star_lines:
			if RegEx.create_from_string(String(star_lines[what])).search(String(l3)) != null:
				named = String(what)
		if named == "":
			stray_star.append(l3)
		else:
			met[named] = int(met.get(named, 0)) + 1
	print("    ✦ in code, comments stripped: %d line(s) — %s" % [code_stars.size(), met])
	ok(stray_star.is_empty() and met.size() == star_lines.size() and code_stars.size() == star_lines.size(),
		"§3a: ✦ is drawn for something that is not a rune's mark or a rune count: %s (met %s)" % [stray_star, met])
	ok(data_hits.is_empty(), "§3a: a data file carries ◆, ↑ or ✦: %s" % [data_hits])


# ── §3b — EACH SURFACE APART ────────────────────────────────────────────────────────────────

func _s3b_each_surface() -> void:
	print("\n§3b — a held upgrade reads ↑ on the button, the Kit panel's row, the Blacksmith and the corner; a pick ◆; a held rune ✦")
	# THE BATTLE BUTTON: the Cleric's basic carries Honed; his other buttons carry nothing.
	var s: Node = await _board(["warden", "pyromancer", "inquisitor", "mystic"],
		{2: {"upgrades": [{"ability": "Smite", "id": "up_damage"}]}})
	var cl := _hero(s, "cleric")
	var war := _hero(s, "warrior")
	if cl == null or war == null:
		ok(false, "§3b: the board seats a Cleric and a Warrior")
	else:
		ok(not (cl.ability_upgrades.get("Smite", []) as Array).is_empty(), "§3b: the premise — Honed landed on Smite")
		s.call("_show_actions", cl)
		await Gate.frames(self, 2)
		var faces: Array = []
		for b in _all(s.get("action_box"), "Button"):
			faces.append(String((b as Button).text))
		var marked: Array = faces.filter(func(t): return String(t).begins_with(ARROW + " ") and String(t).contains("Smite"))
		ok(marked.size() == 1 and not faces.any(func(t): return String(t).contains(DIAMOND)),
			"§3b: the upgraded basic does not read ↑, or a button draws ◆: %s" % [faces])
		for b2 in _all(s.get("action_box"), "Button"):
			if String((b2 as Button).text).contains("Smite"):
				var bw: float = ThemeDB.fallback_font.get_string_size((b2 as Button).text, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
				print("    the button '%s': its face %.0f px in %.0f" % [(b2 as Button).text, bw, (b2 as Button).size.x])
				ok(bw + 8.0 <= (b2 as Button).size.x + 0.5, "§3b: the ↑ face does not fit its button")
		s.call("_show_actions", war)
		await Gate.frames(self, 2)
		var wfaces: Array = []
		for b3 in _all(s.get("action_box"), "Button"):
			wfaces.append(String((b3 as Button).text))
		ok(not wfaces.any(func(t): return String(t).contains(ARROW) or String(t).contains(DIAMOND)),
			"§3b: a hero holding no upgrade draws a mark: %s" % [wfaces])
	await _clear(s)
	# THE KIT PANEL's ROW — BATCH IH §5: the hero sheet's chip carried ↑ until IH §3 took the cards off
	# the sheet; the row that names the card on the Kit panel carries it now, and its hover names the
	# upgrade that landed, as the battle button's does.
	_new_run()
	_run.party[2]["upgrades"] = [{"ability": "Smite", "id": "up_damage"}]
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	current_scene.call("_open_loadout_panel", 2)
	await Gate.frames(self, 2)
	var kov: Node = Gate.overlay(current_scene, 60)
	var kit_labels: Array = _all(kov, "Label") if kov != null else []
	var kit: Array = kit_labels.map(func(l): return String((l as Label).text))
	var chip: Array = kit.filter(func(t): return String(t).begins_with(ARROW + " Smite"))
	ok(chip.size() == 1 and not kit.any(func(t): return String(t).contains(DIAMOND)),
		"§3b: the Kit panel's row does not read ↑ Smite, or the panel draws ◆: %s" % [chip])
	for l in kit_labels:
		if String((l as Label).text).begins_with(ARROW + " Smite"):
			ok(String((l as Label).tooltip_text).ends_with(String(_run.upgrade_name("up_damage"))),
				"§3b: the Kit panel's ↑ Smite row does not name its upgrade on its hover: '%s'" % (l as Label).tooltip_text)
	# THE BLACKSMITH's OFFER.
	_new_run()
	change_scene_to_file("res://scenes/blacksmith.tscn")
	await Gate.frames(self, 6)
	var smith: Array = _all(current_scene, "Label").map(func(l): return String((l as Label).text))
	var offers: Array = current_scene.get("offer")
	var marks: Array = smith.filter(func(t): return String(t).begins_with(ARROW + " "))
	ok(not offers.is_empty() and marks.size() == offers.size() and not smith.any(func(t): return String(t).contains(DIAMOND)),
		"§3b: the Blacksmith's %d offers do not each read ↑ <upgrade>, or it draws ◆: %s" % [offers.size(), marks])
	# THE MAP CARD: ↑N held, ◆ N kind owed, ✦ N held rune — and no label carries two of them.
	_new_run()
	var p: Array = _run.party
	p[0]["upgrades"] = [{"ability": "Strike", "id": "up_damage"}, {"ability": "Strike", "id": "up_speed"}]
	_run.award_upgrade_pick(p[1])
	var hr: Dictionary = Runes.build(String(Runes.eligible_ids(p[3], Runes.owned_names(p[3], _run.party_rune_names())).filter(
		func(id): return not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(Runes.config(String(id))))[0]))
	hr["equipped"] = false
	_run.hold_rune(p[3], hr)
	var mp := await _to_map()
	if Gate.hero_draft(mp) != null:
		mp.call("_close_hero_draft")
		await Gate.frames(self, 2)
	var all: Array = _all(mp, "Label").map(func(l): return String((l as Label).text)) \
		+ _all(mp, "Button").map(func(b): return String((b as Button).text))
	var corner: Array = all.filter(func(t): return String(t).begins_with(ARROW))
	var badge: Array = all.filter(func(t): return String(t).contains(DIAMOND))
	var mark: Array = all.filter(func(t): return String(t).begins_with("✦ "))
	var mixed: Array = all.filter(func(t):
		return int(String(t).contains(ARROW)) + int(String(t).contains(DIAMOND)) + int(String(t).contains("✦")) > 1)
	ok(corner == [ARROW + "2"] and badge == [DIAMOND + " 1 upgrade"] and mark == ["✦ 1"] and mixed.is_empty(),
		"§3b: the map reads corner %s, badge %s, mark %s (mixed %s) — want ↑2, ◆ 1 upgrade and ✦ 1, each alone" % [corner, badge, mark, mixed])
	print("    the map: %s, %s, %s; the corner's 40 px holds ↑12 (IC §3a measured it)" % [corner, badge, mark])


# ── §3c — THE CLASS PASSIVE's CHIP, AND THE RELIC's WORD ─────────────────────────────────────

func _s3c_the_passive_and_the_relics() -> void:
	print("\n§3c — the class passive's chip is gone and the passive reads on the sheet; a rare relic reads RARE")
	BattleUnit.reset_sanctity()
	var s: Node = await _board(["warden", "pyromancer", "inquisitor", "mystic"], {})
	var with_chip: Array = []
	var shorts: Array = []
	for u in s.get("heroes") + s.get("enemies"):
		if (u as BattleUnit).has_status("class_passive"):
			with_chip.append((u as BattleUnit).unit_name)
		for st in (u as BattleUnit).statuses:
			shorts.append(String((st as Dictionary).get("short", "")))
	ok(with_chip.is_empty() and not shorts.has(DIAMOND), "§3c: the class passive's chip is still laid on %s, or a chip reads ◆" % [with_chip])
	print("    a spawn now books %d Sanctity events (each hero's class chip booked one more before ID, and floated one die)" % BattleUnit.sanctity_events)
	await _clear(s)
	_new_run()
	_run.hero_screen_idx = 1
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	var cp: Dictionary = Classes.CLASS_PASSIVES["mage"]
	var line_seen := false
	for l in _all(current_scene, "Label"):
		if String((l as Label).text).contains("Class: %s — %s" % [cp["name"], cp["desc"]]):
			line_seen = true
	ok(line_seen, "§3c: the hero sheet does not read the class passive ('Class: %s — …')" % cp["name"])
	ok(FileAccess.get_file_as_string("res://scripts/spec_choice_screen.gd").contains("\"Class Passive — "),
		"§3c: the class-selection card no longer reads the class passive")
	# THE RELIC SHELF AND THE PICKER: the word, no glyph; the picker's widest row against its button.
	var rares: Array = Relics.POOL.keys().filter(func(id): return String(Relics.POOL[id].get("tier", "common")) == "rare")
	var commons: Array = Relics.POOL.keys().filter(func(id): return String(Relics.POOL[id].get("tier", "common")) != "rare")
	_fresh_meta([rares[0], commons[0]])
	change_scene_to_file("res://scenes/relics_screen.tscn")
	await Gate.frames(self, 6)
	var shelf: Array = _all(current_scene, "Label").map(func(l): return String((l as Label).text))
	var rare_name := String(Relics.POOL[rares[0]]["name"])
	var common_name := String(Relics.POOL[commons[0]]["name"])
	ok(shelf.any(func(t): return String(t).begins_with(rare_name + "  RARE\n")) and not shelf.any(func(t): return String(t).contains(DIAMOND))
			and not shelf.any(func(t): return String(t).begins_with(common_name + "  RARE")),
		"§3c: the shelf does not read '%s  RARE' alone for the rare one, or draws ◆" % rare_name)
	var widest := ""
	var wpx := 0.0
	for id in rares:
		var face := "[ON]  " + String(Relics.POOL[id]["name"]) + "  RARE"
		var px: float = ThemeDB.fallback_font.get_string_size(face, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x
		if px > wpx:
			wpx = px
			widest = face
	_fresh_meta(rares.slice(0, 1))
	_run.sim_run = false
	change_scene_to_file("res://scenes/draft.tscn")
	await Gate.frames(self, 6)
	var picker: Array = _all(current_scene, "Button").map(func(b): return String((b as Button).text))
	ok(picker.has(rare_name + "  RARE") and not picker.any(func(t): return String(t).contains(DIAMOND)),
		"§3c: the picker does not read '%s  RARE', or draws ◆: %s" % [rare_name, picker.filter(func(t): return String(t).contains(rare_name))])
	ok(wpx + 8.0 <= 305.0, "§3c: the picker's widest rare row ('%s', %.0f px) does not fit its 305-px button" % [widest, wpx])
	print("    the picker's widest rare row '%s' is %.0f px of its 305-px button" % [widest, wpx])
	_fresh_meta()


# ── §4a — THE VOW's CHIP SAYS WHAT IT SILENCES ───────────────────────────────────────────────

# The rune chips a hero's plate draws now (`set_rune_chips`'s root), the doomed ones left out.
func _chips(u: BattleUnit) -> Array:
	var out: Array = []
	var r: Node = u.get("_rune_chip_root")
	if r != null and is_instance_valid(r) and not r.is_queued_for_deletion():
		for c in r.get_children():
			if not c.is_queued_for_deletion():
				out.append(c)
	return out


func _s4a_the_vow() -> void:
	print("\n§4a — the vow's chip names what it silences that he holds, its heal figure off the payload")
	var vow_name := String(Runes.config(VOW).get("name", ""))
	var kit := ["Consecrated Ground", "Suffering"]
	# THE FIGURE IS HIS PAYLOAD's, NOT A LITERAL: the rune he wears carries a figure no card prints (0.7, where the
	# authored one is 0.5), seated through the payload's own door at the spawn — never set on the unit (check_gw §2).
	var odd: Dictionary = _rune(VOW)
	(odd["payload"]["stat"] as Dictionary)["rune_vow_of_silence"] = 0.7
	var s: Node = await _board(["warden", "pyromancer", "occultist", "mystic"],
		{2: {"runes": [odd], "bm_abilities": kit, "bm_equipped": kit}})
	var oc := _hero(s, "cleric")
	if oc == null:
		ok(false, "§4a: the board seats a vowed Occultist")
		await _clear(s)
		return
	ok(absf(oc.rune_vow_of_silence - 0.7) < 0.001 and oc.has_engine("old_gods"),
		"§4a: the premise — a vowed Cleric holding the Old Gods, his payload's figure seated (%s)" % oc.rune_vow_of_silence)
	s.call("_refresh_rune_chips")
	var vc: Array = _chips(oc).filter(func(c): return String((c as Control).tooltip_text).begins_with(vow_name))
	var tip := String((vc[0] as Control).tooltip_text).replace("\n", " ") if not vc.is_empty() else ""
	ok(vc.size() == 1 and tip.contains("70% stronger") and not tip.contains("50%") and tip.contains("reflects nothing")
			and tip.contains("Ruin his blows would drink") and tip.contains("Suffering's heal") and tip.contains("ARMED"),
		"§4a: the vowed Occultist's chip does not name his ground, his draught and Suffering's heal with his payload's 70%%: '%s'" % tip)
	# IN EFFECT while a Ruined enemy stands.
	var foe: BattleUnit = null
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			foe = e
			break
	if foe != null:
		s.call("_apply_status", foe, "ruin", -1, 0, 0, oc)
		s.call("_refresh_rune_chips")
		vc = _chips(oc).filter(func(c): return String((c as Control).tooltip_text).begins_with(vow_name))
		ok(not vc.is_empty() and bool((vc[0] as Control).get_meta("paying")) and String((vc[0] as Control).tooltip_text).contains("IN EFFECT"),
			"§4a: with a Ruined enemy standing the vow's chip is not IN EFFECT")
	await _clear(s)
	# NOBODY UNVOWED WEARS IT, AND NOBODY VOWED WHO HOLDS NONE OF THE THREE.
	var s2: Node = await _board(["warden", "pyromancer", "occultist", "mystic"], {2: {"bm_abilities": kit, "bm_equipped": kit}})
	var oc2 := _hero(s2, "cleric")
	s2.call("_refresh_rune_chips")
	ok(oc2 != null and _chips(oc2).filter(func(c): return String((c as Control).tooltip_text).begins_with(vow_name)).is_empty(),
		"§4a: an unvowed Occultist wears the vow's chip")
	await _clear(s2)
	var s3: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {2: {"runes": [_rune(VOW)]}})
	var hc := _hero(s3, "cleric")
	s3.call("_refresh_rune_chips")
	ok(hc != null and hc.rune_vow_of_silence > 0.0 and not hc.has_engine("old_gods")
			and _chips(hc).filter(func(c): return String((c as Control).tooltip_text).begins_with(vow_name)).is_empty(),
		"§4a: a vowed Holy holding no ground, no Old Gods and no Suffering wears the vow's chip")
	await _clear(s3)
	print("    the chip: '%s'" % tip)


# ── §4b — MIRRORBOUND's CARD AGAINST ITS CODE ────────────────────────────────────────────────

func _s4b_mirrorbound() -> void:
	print("\n§4b — Mirrorbound's card: a quarter, at least 1 on an attack that deals nothing, both sides")
	var desc := String(_run.MODIFIERS["mirrorbound"]["desc"])
	ok(desc.contains("a quarter of the damage it deals") and desc.contains("at least 1, even when it deals none")
			and desc.contains("On both sides") and desc.contains("does not miss") and not desc.contains(" you"),
		"§4b: the card does not say the quarter, the floor, both sides and the miss, without a pronoun: '%s'" % desc)
	var bsrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bsrc.contains("var recoil := maxi(int(round(total_dealt * recoil_pct)), 1)") and bsrc.contains("u.mod_recoil = 0.25"),
		"§4b: the code's floor or its quarter moved — the card is read against them")
	# BOTH SIDES, ON A REAL BOARD UNDER THE BARGAIN; THE FLOOR, DRIVEN: a vowed Smite deals nothing and pays 1.
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	var specs := ["warden", "pyromancer", "inquisitor", "mystic"]
	for i in _run.party.size():
		_run.party[i]["spec"] = specs[i]
		_run.party[i]["engines"] = Runes.engine_pouch_for_spec(String(specs[i]))
		_run.party[i]["awakened"] = true
		_run.party[i]["tree"] = Talents.generate_tree(specs[i], _run.party[i]["key"])
		_run.party[i]["runes"] = []
		_run.party[i]["talents"] = {}
		_run.sync_spec_hp(i)
	_run.party[2]["runes"] = [_rune(VOW)]
	_run.specs_chosen = true
	_run.active = true
	_run.party_runes = []
	_run.pending_modifier = "mirrorbound"
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]})
	Engine.time_scale = 50.0
	await Gate.frames(self, 90)
	var s: Node = current_scene
	for u in s.get("heroes") + s.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = -10.0
		u.crit_bonus = -1.0
	var sides: Array = (s.get("heroes") + s.get("enemies")).filter(func(u): return absf((u as BattleUnit).mod_recoil - 0.25) > 0.001)
	ok(sides.is_empty(), "§4b: the bargain does not stamp its quarter on both sides: %s" % [sides.map(func(u): return (u as BattleUnit).unit_name)])
	var cl := _hero(s, "cleric")
	var foe: BattleUnit = null
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead and not (e as BattleUnit).is_ranged:
			foe = e
			break
	if cl != null and foe != null:
		var hp0 := cl.hp
		seed(SEED)
		await s._resolve(cl, cl.abilities[0], foe, "good")
		ok(hp0 - cl.hp == 1, "§4b: a vowed Smite that dealt nothing recoiled %d — the card's floor is 1" % (hp0 - cl.hp))
	# THE QUARTER: an unvowed attacker on the same board — the Warden's own basic, not the Cleric unvowed by hand.
	var wa := _hero(s, "warrior")
	if wa != null and foe != null:
		ok(wa.rune_vow_of_silence <= 0.0, "§4b: the premise — the Warden is unvowed")
		var hp1 := wa.hp
		var f0 := foe.hp
		seed(SEED)
		await s._resolve(wa, wa.abilities[0], foe, "good")
		var dealt := f0 - foe.hp
		ok(dealt > 0 and hp1 - wa.hp == maxi(int(round(dealt * 0.25)), 1),
			"§4b: an unvowed %s that dealt %d recoiled %d — the card's quarter" % [wa.abilities[0].display_name, dealt, hp1 - wa.hp])
		print("    a vowed Smite that dealt nothing paid 1; an unvowed %s that dealt %d paid %d" % [wa.abilities[0].display_name, dealt, hp1 - wa.hp])
	await _clear(s)
	_run.pending_modifier = ""


# ── §4c — THE KIT BUTTON IS INSIDE ITS CARD ──────────────────────────────────────────────────

func _s4c_the_kit_button() -> void:
	print("\n§4c — the map card's Kit button inside its card, at its widest face")
	_new_run()
	_run.zone_bosses_cleared = 3
	var m: Dictionary = _run.party[0]
	_fill(m, 0)
	_owe(_run.party[1], ["upgrade"])
	var mp := await _to_map()
	if Gate.hero_draft(mp) != null:
		mp.call("_close_hero_draft")
		await Gate.frames(self, 2)
	var faces: Array = []
	for i in _run.party.size():
		var card := Rect2(Vector2(8.0, 84.0 + i * 158.0), Vector2(300.0, 152.0))
		var kit: Button = Gate.bound_button(mp, "_open_loadout_panel", [i])
		ok(kit != null, "§4c: card %d draws no Kit button" % i)
		if kit == null:
			continue
		faces.append(kit.text)
		ok(card.encloses(kit.get_global_rect()), "§4c: card %d's Kit button %s runs past its card %s" % [i, kit.get_global_rect(), card])
		var choose: Button = Gate.bound_button(mp, "_open_hero_draft", [i])
		if choose != null:
			ok(not choose.get_global_rect().intersects(kit.get_global_rect()), "§4c: card %d's CHOOSE lies over its Kit button" % i)
		# BATCH IH §2 — the Runes button took the core-rune line's room on this row: inside the card, and
		# over neither Kit nor CHOOSE.
		var rb: Button = null
		for b in Gate.bound_buttons(mp, "_open_rune_panel"):
			if (b as Button).has_meta("runes_button") and int((b as Button).get_meta("runes_button")) == i:
				rb = b
		ok(rb != null and card.encloses(rb.get_global_rect()) and not rb.get_global_rect().intersects(kit.get_global_rect())
				and (choose == null or not rb.get_global_rect().intersects(choose.get_global_rect())),
			"§4c: card %d's Runes button runs past its card or lies over Kit or CHOOSE (%s)" % [i,
				rb.get_global_rect() if rb != null else "none"])
	ok(faces.has("Kit 10/10"), "§4c: the premise — a card at its widest face, Kit 10/10 (%s)" % [faces])
	print("    the Kit faces %s, each inside its card" % [faces])
	_run.zone_bosses_cleared = 0


# ── §9 — THE PLAYER'S FILES ──────────────────────────────────────────────────────────────────

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
