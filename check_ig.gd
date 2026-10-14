# BATCH IG — EVERY CHIP, AND SANCTITY.
#
#   §1a THE SWEEP, KEPT AND CLOSED (IE §2a's census, the rule IC set): every `add_status` call left in the game's
#       scripts, comments stripped — the one whose id is a variable is the status door's, and every literal id is a
#       named EFFECT that a line reads back for its payout. A new literal call reds until it is sorted here.
#   §1b THE NINETEEN DISPLAY CHIPS, AT THE SOURCE: each is laid by `set_display_chip` and by no `add_status`, and no
#       status verb in the game names one.
#   §1c DRIVEN THROUGH THEIR REAL WRITERS: Iron Will at the spawn and live, Refuse Death's chip below a quarter, the
#       Berserk bank, Loyalty on the COMPANION's body — each drawn in the plate's row, none in `statuses`, none found by
#       `has_status`, none a Sanctity event, none a float; a body that dies takes its chips with it.
#   §1d THE LONGEST CASE: a Devout releasing Faith on three allies in one turn — each chip on its own ally's body,
#       refreshed at the release and never removed, and the ledger unmoved by any of it, beside a status that books.
#   §1e A CHIP IS IN NO COUNT: the debuff count, the breadth count, Dispel's candidates and a cleanse all pass a chip
#       by, beside a status each one does take.
#   §2  SANCTITY's STEP, THE TUNING HANDLE, PINNED HERE AND NOWHERE ELSE: 13 events a step (16 until IG, set on the
#       count the chips inflated), five steps the cap — driven on a Hierophant at either side of a step and at the cap.
#   §4  THE MEMBER CARRIES THE BAR's TRUE MAXIMUM, DRIVEN BOTH WAYS: a Mage holding A Bigger Resource Pool walks out of a
#       won fight with the member's maximum at his own 120 — the Hourglass restores 30% of 120 against it, a new zone
#       refills him to it, a quit's in-flight bank and the save carry it — and a Mage with no node reads 100 through every
#       one of the same doors.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** Sanctity's threshold is set off a sim measurement (the report, IG §2),
# and the designer's play confirms it. `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ig.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ig_profile.json"
const SCRATCH_RELICS := "user://ig_relics.json"

# THE FIFTEEN EFFECTS (IE §2a's census), each with the payout its readers take off it. A literal-id `add_status` whose
# id is not here reds §1a until it is sorted: an effect is named here, a chip is drawn by `set_display_chip`.
const EFFECTS := ["seeding", "standard", "rally_heal", "crossfire", "bear_brunt", "held_breath", "instinct",
	"charging", "fortified", "anointed", "bloodbond", "ghostpack", "elusive", "unrelenting", "broken"]
# THE NINETEEN DISPLAY CHIPS (IE §2a's census): nine a run reaches, ten dormant.
const CHIPS := ["iron_will", "undying_rage", "keen_eyes", "loyalty", "aper_rhythm", "faith", "feint_guard",
	"berserk", "deadfall", "crushing_blows", "melted", "endurance", "scent", "deathwish", "killing_edge", "bracing",
	"waiting_guard", "enraged", "capacitor"]
const READ_VERBS := ["has_status", "get_status", "status_power", "status_stacks"]
const STATUS_VERBS := ["add_status", "has_status", "get_status", "status_power", "status_stacks", "update_status",
	"remove_status", "_find_status", "composition_of"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IG — EVERY CHIP, AND SANCTITY")
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
	_s1a_the_sweep()
	_s1b_the_nineteen()
	await _s1c_driven()
	await _s1d_the_longest_case()
	await _s1e_in_no_count()
	await _s2_sanctity_step()
	await _s4_the_true_maximum()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

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


# The game's scripts, comments stripped (a comment names code), keyed by file.
func _sources() -> Dictionary:
	var out := {}
	for f in DirAccess.get_files_at("res://scripts"):
		if String(f).ends_with(".gd"):
			out[String(f)] = Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
	return out


# The float labels standing on a unit: `float_text` adds a Label child at z 10.
func _floats(u: BattleUnit) -> int:
	var n := 0
	for c in u.get_children():
		if c is Label and (c as Label).z_index == 10 and not c.is_queued_for_deletion():
			n += 1
	return n


# The chips the plate's row draws (a ColorRect each), read after a frame.
func _drawn(u: BattleUnit) -> int:
	var n := 0
	var r: Node = u.get("_chips_root")
	for c in (r.get_children() if r != null else []):
		if c is ColorRect and not c.is_queued_for_deletion():
			n += 1
	return n


# The ledger's keys for a chip id: an event a chip booked would stand here as "<body>:<id>".
func _booked(ids: Array) -> Array:
	return BattleUnit._sanctity_seen.keys().filter(
		func(k): return ids.has(String(k).get_slice(":", 1)))


# A chip, as a chip and never as a status: drawn in `display_chips`, not in `statuses`, not found by `has_status`.
func _is_chip(u: BattleUnit, id: String) -> bool:
	return u.has_display_chip(id) and not u.has_status(id) \
		and not u.statuses.any(func(st): return String(st.id) == id)


# ── §1a — THE SWEEP, KEPT AND CLOSED ───────────────────────────────────────────

func _s1a_the_sweep() -> void:
	print("\n§1a — every add_status left in the game's scripts is the door's or a named effect")
	var srcs := _sources()
	var call := RegEx.create_from_string("(?<!func )(?<![\\w.])(?:[\\w.]+\\.)?add_status\\(\\s*([^,]+),")
	var variable: Array = []
	var literal := {}
	var calls := 0
	for f in srcs:
		for m in call.search_all(String(srcs[f])):
			calls += 1
			var arg := m.get_string(1).strip_edges()
			if arg.begins_with("\"") and arg.ends_with("\""):
				var id := arg.substr(1, arg.length() - 2)
				literal[id] = int(literal.get(id, 0)) + 1
			else:
				variable.append(arg)
	var ids: Array = literal.keys()
	ids.sort()
	var want: Array = EFFECTS.duplicate()
	want.sort()
	print("    CHECKED %d add_status calls across %d scripts: %d with a variable id %s, %d literal ids" % [
		calls, srcs.size(), variable.size(), str(variable), ids.size()])
	ok(variable == ["id"], "§1a: the add_status calls with a variable id are %s — want the status door's alone" % [variable])
	ok(ids == want, "§1a: the literal-id add_status calls lay %s — want the fifteen effects %s" % [ids, want])
	# AN EFFECT IS READ BACK FOR ITS PAYOUT: each has a reading line (has / get / power / stacks / `.id ==`).
	var unread: Array = []
	for id2 in EFFECTS:
		var reads := 0
		for f2 in srcs:
			var src := String(srcs[f2])
			for verb in READ_VERBS:
				reads += src.count("%s(\"%s\"" % [verb, id2])
			reads += src.count(".id == \"%s\"" % id2)
		if reads == 0:
			unread.append(id2)
	ok(unread.is_empty(), "§1a: an effect no line reads back: %s" % [unread])
	ok(calls == 1 + EFFECTS.size(), "§1a: %d add_status calls — want the door and the fifteen" % calls)


# ── §1b — THE NINETEEN, AT THE SOURCE ─────────────────────────────────────────

func _s1b_the_nineteen() -> void:
	print("\n§1b — each display chip is drawn by its writer and named by no status verb")
	var srcs := _sources()
	var all := ""
	for f in srcs:
		all += String(srcs[f]) + "\n"
	var unlaid: Array = []
	var as_status: Array = []
	for id in CHIPS:
		if not all.contains("set_display_chip(\"%s\"" % id):
			unlaid.append(id)
		for verb in STATUS_VERBS:
			if all.contains("%s(\"%s\"" % [verb, id]) or all.contains(".id == \"%s\"" % id):
				as_status.append("%s:%s" % [verb, id])
	print("    CHECKED %d chips against %d status verbs" % [CHIPS.size(), STATUS_VERBS.size()])
	ok(unlaid.is_empty(), "§1b: a display chip is not laid by `set_display_chip`: %s" % [unlaid])
	ok(as_status.is_empty(), "§1b: a status verb still names a display chip: %s" % [as_status])
	# The writer itself: it books no event and floats nothing, and the status door still does both.
	var u := String(srcs.get("unit.gd", ""))
	var at := u.find("func set_display_chip(")
	var body := u.substr(at, u.find("\nfunc ", at + 5) - at) if at >= 0 else ""
	var door_at := u.find("func add_status(")
	var door := u.substr(door_at, u.find("\nfunc ", door_at + 5) - door_at) if door_at >= 0 else ""
	ok(body != "" and not body.contains("note_status_event") and not body.contains("float_text"),
		"§1b: `set_display_chip` books a Sanctity event or floats a label")
	ok(door.contains("note_status_event(self, id)") and door.contains("float_text(label, color)"),
		"§1b: the positive arm — the status door no longer books its event or floats its label")


# ── §1c — DRIVEN THROUGH THEIR REAL WRITERS ───────────────────────────────────

func _s1c_driven() -> void:
	print("\n§1c — Iron Will, Refuse Death, Berserk and Loyalty, each drawn and none a status")
	var s: Node = await _board(["berserker", "pyromancer", "holy", "beastmaster"],
		{0: {"talents": {"tn_iron_will": 1, "tn_refuse_death": 1}}})
	await Gate.frames(self, 2)
	var war := _hero(s, "warrior")
	var hunter := _hero(s, "hunter")
	if war == null or hunter == null:
		ok(false, "§1c: the board seats a Berserker and a Beastmaster")
		await _clear(s)
		return
	# IRON WILL — laid at the spawn by its node, live off the debuff count.
	ok(_is_chip(war, "iron_will") and String(war.display_chip("iron_will").get("short", "")) == "-0%",
		"§1c: Iron Will is not a display chip at the spawn, reading -0%% (%s)" % [war.display_chip("iron_will")])
	s.call("_apply_status", war, "dazed", 3)
	ok(String(war.display_chip("iron_will").get("short", "")) == "-12%",
		"§1c: Iron Will does not read the debuff it carries live (%s)" % war.display_chip("iron_will").get("short", ""))
	war.remove_status("dazed")
	# REFUSE DEATH — the chip lights below a quarter, off `_update_talent_chips`.
	var ev0 := int(BattleUnit.sanctity_events)
	var fl0 := _floats(war)
	war.hp = maxi(int(war.max_hp * 0.2), 1)
	s.call("_update_talent_chips")
	ok(_is_chip(war, "undying_rage") and String(war.display_chip("undying_rage").get("short", "")) == "UNDYING",
		"§1c: Refuse Death's chip does not light below a quarter as a display chip")
	ok(int(BattleUnit.sanctity_events) == ev0 and _floats(war) == fl0,
		"§1c: lighting Refuse Death's chip booked %d events and floated %d labels — want none" % [
			int(BattleUnit.sanctity_events) - ev0, _floats(war) - fl0])
	war.hp = war.max_hp
	s.call("_update_talent_chips")
	ok(not war.has_display_chip("undying_rage") and int(BattleUnit.sanctity_events) == ev0,
		"§1c: Refuse Death's chip does not go above a quarter, or its going booked an event")
	# BERSERK — its bank is a chip; its 30% risk is a status and books its one event (the positive arm).
	var bk: Ability = Classes.pool_ability("Berserk")
	war.resource = war.max_resource
	war.cooldowns.clear()
	var ev1 := int(BattleUnit.sanctity_events)
	await s._resolve(war, bk, war, "good")
	ok(war.berserk_strikes > 0 and _is_chip(war, "berserk")
			and int(war.display_chip("berserk").get("power", -1)) == war.berserk_strikes,
		"§1c: the Berserk bank is not a display chip whose power is the count (%d, %s)" % [
			war.berserk_strikes, war.display_chip("berserk")])
	ok(war.has_status("berserk_risk") and int(BattleUnit.sanctity_events) == ev1 + 1,
		"§1c: the positive arm — Berserk's risk (a status) did not book its one event (%d → %d)" % [
			ev1, BattleUnit.sanctity_events])
	# LOYALTY — on the COMPANION's body; the meter is its hunter's.
	await s._do_summon(hunter, "ursus")
	var comp: BattleUnit = null
	for c in s.get("companions"):
		if not c.dead:
			comp = c
	if comp == null:
		ok(false, "§1c: Ursus did not come")
	else:
		hunter.loyalty[comp.companion_kind] = 3
		s.call("_stamp_loyalty_chip", hunter, comp)
		ok(_is_chip(comp, "loyalty") and String(comp.display_chip("loyalty").get("short", "")) == "L3"
				and not hunter.has_display_chip("loyalty") and not hunter.has_status("loyalty"),
			"§1c: Loyalty is not a display chip on the companion's own body (comp %s, hunter %s)" % [
				comp.display_chip("loyalty"), hunter.has_display_chip("loyalty")])
	# THE ROW DRAWS ALL THREE LISTS; THE LEDGER HOLDS NO CHIP.
	await Gate.frames(self, 1)
	ok(_drawn(war) == war.engine_chips.size() + war.display_chips.size() + war.statuses.size()
			and war.display_chips.size() >= 2,
		"§1c: the Berserker's row draws %d for %d engine chips, %d display chips, %d statuses" % [
			_drawn(war), war.engine_chips.size(), war.display_chips.size(), war.statuses.size()])
	var booked := _booked(CHIPS)
	ok(booked.is_empty(), "§1c: a display chip booked a Sanctity event: %s" % [booked])
	# A BODY THAT DIES TAKES ITS CHIPS WITH IT, as it did while they were statuses.
	war.hp = 1
	war.undying_rage_used = true
	war.take_hit(99999, 0)
	ok(war.dead and war.display_chips.is_empty(),
		"§1c: a dead hero still carries display chips (%d)" % war.display_chips.size())
	await _clear(s)


# ── §1d — THE LONGEST CASE: FAITH RELEASED ON THREE ALLIES IN ONE TURN ─────────

func _s1d_the_longest_case() -> void:
	print("\n§1d — a Devout releases Faith on three allies in one turn; each chip on its own body, the ledger unmoved")
	var s: Node = await _board(["warden", "pyromancer", "inquisitor", "mystic"])
	await Gate.frames(self, 2)
	var dv := _hero(s, "cleric")
	if dv == null or not dv.has_engine("conviction"):
		ok(false, "§1d: the board seats a Devout holding Conviction")
		await _clear(s)
		return
	var rel := int(s.get("FAITH_RELEASE")) + int(dv.rune_fourth_stack)
	var allies: Array = (s.get("heroes") as Array).filter(func(h): return h != dv and not h.is_companion and not h.dead)
	var ev0 := int(BattleUnit.sanctity_events)
	var fl0 := 0
	for a in allies:
		fl0 += _floats(a)
	for a2 in allies:
		s.call("_gain_faith", a2, rel - 1, "absorb")
	var built: Array = []
	for b in allies:
		if _is_chip(b, "faith") and String(b.display_chip("faith").get("short", "")) == "Fa%d" % (rel - 1):
			built.append(b)
	ok(built.size() == 3, "§1d: %d of three allies hold a Faith chip at Fa%d on their own body" % [built.size(), rel - 1])
	var ev_built := int(BattleUnit.sanctity_events)
	for a3 in allies:
		s.call("_gain_faith", a3, 1, "absorb")
	var released: Array = []
	for r in allies:
		if r.faith_stacks == 0 and r.faith_peak == rel and _is_chip(r, "faith") \
				and String(r.display_chip("faith").get("short", "")) == "Fa0":
			released.append(r)
	ok(released.size() == 3,
		"§1d: %d of three allies released and kept a Fa0 chip on their own body, the peak at %d" % [released.size(), rel])
	ok(not dv.has_display_chip("faith") and not dv.has_status("faith"),
		"§1d: the allies' Faith was drawn on the Devout's body")
	ok(ev_built == ev0 and int(BattleUnit.sanctity_events) == ev0,
		"§1d: six Faith writes on three bodies booked %d events — want none" % (int(BattleUnit.sanctity_events) - ev0))
	ok(_booked(["faith"]).is_empty(), "§1d: the ledger holds a Faith key: %s" % [_booked(["faith"])])
	var fl1 := 0
	for a4 in allies:
		fl1 += _floats(a4)
	# Each release floats its own heal ("FAITH +n"), the card's line; the chip floats nothing beside it.
	ok(fl1 - fl0 == 3, "§1d: three releases floated %d labels — want the three heals and no chip's" % (fl1 - fl0))
	s.call("_apply_status", allies[0], "sunder", 3)
	ok(int(BattleUnit.sanctity_events) == ev0 + 1,
		"§1d: the positive arm — a status landing beside the chips did not book its one event")
	# AND THE BATTLE RESET TAKES THE CHIPS, NOT A STATUS.
	s.call("_reset_faith_meters")
	ok(allies.all(func(a): return not a.has_display_chip("faith")), "§1d: the reset left a Faith chip standing")
	await _clear(s)


# ── §1e — A CHIP IS IN NO COUNT ─────────────────────────────────────────────

func _s1e_in_no_count() -> void:
	print("\n§1e — the debuff count, the breadth count, Dispel and a cleanse pass a chip by")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"])
	await Gate.frames(self, 2)
	var foe: BattleUnit = _foes(s)[0]
	var hero := _hero(s, "warrior")
	# Melt Armor — the one chip a body carried as an AFFLICTION (it is in DEBUFF_IDS); dormant, laid by its writer's call.
	foe.set_display_chip("melted", "Melt Armor", "-5%", Color(1.0, 0.5, 0.2), "")
	foe.set_display_chip("enraged", "Enraged", "+12%", Color(0.9, 0.35, 0.3), "", 0, 5)
	ok(foe.count_debuffs() == 0 and int(s.call("_status_count", foe)) == 0,
		"§1e: a chip counted as a debuff (%d) or in the breadth count (%d)" % [foe.count_debuffs(), int(s.call("_status_count", foe))])
	ok((s.call("_dispellable_buffs", foe) as Array).is_empty(), "§1e: Dispel would take a chip off an enemy")
	s.call("_apply_status", foe, "sunder", 3)
	ok(foe.count_debuffs() == 1 and int(s.call("_status_count", foe)) == 1,
		"§1e: the positive arm — a Sunder beside the chips counts %d / %d, want 1 / 1" % [foe.count_debuffs(), int(s.call("_status_count", foe))])
	var took := foe.purge_debuffs()
	ok(took == 1 and foe.has_display_chip("melted") and foe.has_display_chip("enraged"),
		"§1e: a cleanse took %d and left the chips %s / %s" % [took, foe.has_display_chip("melted"), foe.has_display_chip("enraged")])
	# Enraged's clock is its field's: the chip shows the timer, and goes when it runs out.
	hero.enraged_ranks = 1
	hero.hp = hero.max_hp
	var big := int(hero.max_hp * 0.6)
	hero.take_hit(big, 0)
	ok(_is_chip(hero, "enraged") and int(hero.display_chip("enraged").get("turns", 0)) == 5,
		"§1e: Enraged is not a display chip showing its 5-turn timer (%s)" % [hero.display_chip("enraged")])
	hero.tick_statuses()
	ok(int(hero.display_chip("enraged").get("turns", 0)) == 5,
		"§1e: a status tick moved Enraged's chip — its clock is its field's")
	for _i in 4:
		hero.tick_cooldowns()
	ok(int(hero.display_chip("enraged").get("turns", 0)) == 1, "§1e: the chip does not follow the timer (%s)" % [hero.display_chip("enraged")])
	hero.tick_cooldowns()
	ok(not hero.has_display_chip("enraged") and hero.enraged_stacks == 0, "§1e: Enraged's chip outlived its timer")
	await _clear(s)


# ── §2 — SANCTITY's STEP ──────────────────────────────────────────────────

# THE ONE PIN ON THE NUMBER (RUPTURE_BREAK_PER_TICK's rule, `check_hs` §3a): a tuning pass from the designer's play
# moves the constant and this line, never a dozen gates. The reading it was set on is `docs/reports/IG.md` §2.
const SANCTITY_STEP_AT_IG := 13

func _s2_sanctity_step() -> void:
	print("\n§2 — Sanctity's step: %d events, the cap five steps" % SANCTITY_STEP_AT_IG)
	ok(int(BattleUnit.SANCTITY_PER_STEP) == SANCTITY_STEP_AT_IG and int(BattleUnit.SANCTITY_MAX_STEPS) == 5,
		"§2: Sanctity's step reads %d events and its cap %d steps — want %d and 5 (a re-tune moves this pin with it)" % [
			int(BattleUnit.SANCTITY_PER_STEP), int(BattleUnit.SANCTITY_MAX_STEPS), SANCTITY_STEP_AT_IG])
	var hr: Dictionary = Runes.build(Runes.engine_rune_id("sanctity"))
	hr["equipped"] = true
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {2: {"engines": [hr]}})
	var hiero := _hero(s, "cleric")
	if hiero == null or not hiero.has_engine("sanctity"):
		ok(false, "§2: the board seats a Hierophant")
		await _clear(s)
		return
	var per := int(BattleUnit.SANCTITY_PER_STEP)
	var read: Array = []
	for ev in [per - 1, per, 2 * per - 1, 2 * per, 5 * per, 9 * per]:
		BattleUnit.sanctity_events = ev
		read.append(hiero.sanctity_steps())
	print("    steps at %d, %d, %d, %d, %d, %d events: %s" % [per - 1, per, 2 * per - 1, 2 * per, 5 * per, 9 * per, read])
	ok(read == [0, 1, 1, 2, 5, 5], "§2: a Hierophant's steps read %s — want [0, 1, 1, 2, 5, 5]" % [read])
	BattleUnit.reset_sanctity()
	await _clear(s)


# ── §4 — THE MEMBER CARRIES THE BAR's TRUE MAXIMUM ─────────────────────────

# One won fight with the Hourglass worn, the Mage's bar left at `left` of his maximum; the Mage's member read after.
func _won_with(node: bool, left: int, relic: bool) -> Dictionary:
	Profile.save_path = SCRATCH_PROFILE
	Relics.save_path = SCRATCH_RELICS
	var over := {1: {"talents": {"tn_pool": 1}}} if node else {}
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], over)
	_run.active_relics = ["hourglass"] if relic else []
	var mage := _hero(s, "mage")
	var top := mage.max_resource if mage != null else -1
	if mage != null:
		mage.resource = left
	# The fight's in-flight bank (GH) writes the maximum at every turn boundary too; the member is put back at the old
	# fixed 100 here, with no frame between, so the figure read after is the victory's own write (C15 found the bank
	# masking it).
	_run.party[1]["max_mana"] = 100
	for e in s.get("enemies"):
		(e as BattleUnit).hp = 0
		(e as BattleUnit).dead = true
	s.call("_check_end")
	await Gate.frames(self, 3)
	var m: Dictionary = _run.party[1]
	var out := {"top": top, "mana": int(m["mana"]), "max": int(m["max_mana"])}
	await _clear(s)
	_run.active_relics = []
	return out


# A fight's in-flight bank, mid-fight: the Mage's bar at 37 of his own maximum, the member read after.
func _banked_mid_fight(node: bool) -> Dictionary:
	Profile.save_path = SCRATCH_PROFILE
	Relics.save_path = SCRATCH_RELICS
	var over := {1: {"talents": {"tn_pool": 1}}} if node else {}
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], over)
	var mage := _hero(s, "mage")
	_run.party[1]["max_mana"] = 100
	if mage != null:
		mage.resource = 37
	s.call("_bank_party_losses")
	var m: Dictionary = _run.party[1]
	var out := {"mana": int(m["mana"]), "max": int(m["max_mana"])}
	await _clear(s)
	return out


func _s4_the_true_maximum() -> void:
	print("\n§4 — the member carries the bar's true maximum: with the +20 node, and with none")
	var pct := float(Relics.POOL["hourglass"]["hooks"]["victory_mana_pct"])
	for arm in [[true, 120], [false, 100]]:
		var node: bool = arm[0]
		var top: int = arm[1]
		var tag := "with the node" if node else "no node"
		# CARRIED: a won fight writes the bar and its maximum, a full bar carried whole.
		var a := await _won_with(node, top, false)
		ok(int(a["top"]) == top and int(a["max"]) == top and int(a["mana"]) == top,
			"§4 (%s): a full %d bar carried out of a won fight reads %d of %d on the member" % [tag, int(a["top"]), int(a["mana"]), int(a["max"])])
		# THE HOURGLASS: 30% of the true maximum, against the true maximum.
		var b := await _won_with(node, 50, true)
		ok(int(b["mana"]) == mini(50 + int(top * pct), top) and int(b["max"]) == top,
			"§4 (%s): the Hourglass took 50 to %d of %d — want %d" % [tag, int(b["mana"]), int(b["max"]), mini(50 + int(top * pct), top)])
		# A QUIT MID-FIGHT: the fight's in-flight bank (GH) writes the maximum with the bar.
		var q := await _banked_mid_fight(node)
		ok(int(q["max"]) == top and int(q["mana"]) == 37,
			"§4 (%s): the in-flight bank wrote %d of %d — want 37 of %d" % [tag, int(q["mana"]), int(q["max"]), top])
		# A NEW ZONE refills to it; the save carries it (one key, read back, no version moved).
		var m: Dictionary = _run.party[1]
		var zone_was := int(_run.zone_idx)
		_run.advance_zone()
		ok(int(m["mana"]) == top and int(m["max_mana"]) == top,
			"§4 (%s): a new zone refilled him to %d of %d — want %d" % [tag, int(m["mana"]), int(m["max_mana"]), top])
		_run.save_run()
		m["max_mana"] = 1
		_run.load_run()
		ok(int((_run.party[1] as Dictionary).get("max_mana", -1)) == top,
			"§4 (%s): the save did not carry the member's maximum back (%s)" % [tag, (_run.party[1] as Dictionary).get("max_mana", -1)])
		_run.zone_idx = zone_was
	print("    the +20 node: carried at 120, the Hourglass's 30% of 120, a zone's refill to 120; no node: every figure at 100")


# ── §9 — THE PLAYER'S FILES ────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now_has := FileAccess.file_exists(p)
		ok(now_has == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1]),
			"§9: %s moved under this gate" % p)
	for scratch in [SCRATCH_PROFILE, SCRATCH_RELICS]:
		if FileAccess.file_exists(scratch):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))
