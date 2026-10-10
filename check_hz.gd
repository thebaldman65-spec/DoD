# BATCH HZ — THE EYES, AND THE RAGE DUMP.
#
#   §0  THE CARRIED HALF IS THE RAIDER'S DAMAGE ON A SECOND BODY (HZ §0.1, the designer's ruling on HY's
#       first) — beyond `check_hy` §1's table: a Devout the share kills is the raider's kill; a
#       Covenant-bound Devout shares the carried half; the swing's riders fire ONCE (a status it applies
#       lands on the struck ally only, its lifesteal heals once); and nothing re-enters (the Devout's own
#       vow does not move his carried half, and a vowed Devout struck himself keeps the whole blow).
#   §1a THE ENEMY'S DECLARED ATTACK, ON HOVER — THE EFFECT, NEVER THE TARGET. On a real battle: the plate's
#       intent line carries the detail as its tooltip — the name, the band (`_damage_line`'s own line),
#       what it applies, its Break damage and how many it hits — and no hero's name. Negative arms: an
#       attack that applies nothing prints no effect line; an enemy that declares nothing shows nothing.
#       A census over every enemy ability in the data: each detail reads off its own fields.
#   §1b THE KIT PREVIEW, FROM THE DRAFT AND THE SHOP — read-only, an overlay that loses nothing: opened
#       mid-draft from a column, closed, and the staged pick confirmed and landed; from a rune cache's
#       pick, and the pick landed; from the Peddler, walking all four. Negative arm: a hero with no runes
#       at all and a starting kit — the preview renders.
#   §1c THE NAMEPLATE IS A SECOND HIT AREA — a left click on a pool unit's plate, pushed through the real
#       viewport during targeting, picks that unit (the plate, a chip on it, the intent line on it; an
#       enemy's for a strike, a hero's for a support); a plate outside the pool picks nothing; and the
#       same plate clicked outside targeting does what it did at HY: nothing.
#   §1d THE CHIPS — WHAT IS PAYING RIGHT NOW: the crest's one chip on its strip and on no plate, ARMED while
#       its condition does not hold and PAYING once it does (the Cleric falls, a hero falls), its words off
#       the payload; a chip with no condition reads PAYING; Last Rites' chip turns with health and the bar,
#       and a dump turns it off; a vowed Cleric's ground is chipped while it stands. A rune chip is not a
#       status and is not drawn as one. Negative arm: a hero wearing nothing that turns on and off — no
#       rune chip, and no crest strip.
#   §2  BOIL OVER IS A RAGE DUMP — the whole bar, no cost of its own, a floor to cast; no Blood Frenzy
#       term and no recovery. On one deterministic board: the dump priced against every Rage card a
#       Warrior can carry, with the Berserker's core and without, and the shape the designer set as the
#       pass condition asserted; Last Rites turned off by a dump, allowed and not refused.
#   §3  THE TOAST NAMES THE PET — a core rune that dismisses the pet, taken after class selection, says
#       which card leaves the kit, off the data; an ordinary core rune's toast does not.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** A tooltip is read off the control the engine would show it
# for (`get_tooltip`); the engine's tooltip window itself never opens headless. A click is pushed through
# the root viewport, so the GUI's own picking and filters decide where it lands — but no pointer moves.
# `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_hz.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://hz_profile.json"
const SCRATCH_RELICS := "user://hz_relics.json"
const SPECS := ["warden", "pyromancer", "inquisitor", "mystic"]
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261009
const PREVIEW := "res://scripts/kit_preview.gd"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


# HZ'S OWN NAMES ARE ASKED OF THE CODE AT RUN TIME, never written as identifiers here, so the HEAD arm — HEAD's
# code under this gate — reds line by line instead of failing to compile on a constant it never had.
func _cls() -> Script:
	return load("res://scripts/classes.gd") as Script


func _const(name: String, fallback: Variant) -> Variant:
	return _cls().get_script_constant_map().get(name, fallback)


func _call(obj: Object, method: String, args: Array, fallback: Variant) -> Variant:
	if obj != null and obj.has_method(method):
		return obj.callv(method, args)
	return fallback


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HZ — THE EYES, AND THE RAGE DUMP")
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
	await _s0_the_carried_half()
	await _s1a_the_telegraph()
	await _s1c_the_plates()
	await _s1d_the_chips()
	await _s2_the_rage_dump()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	await _s1b_the_preview()
	await _s3_the_toast()
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


func _engines(pids: Array) -> Array:
	var out: Array = []
	for pid in pids:
		out.append(_rune(Runes.engine_rune_id(String(pid))))
	return out


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


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _melee(scene: Node, skip: Array = []) -> BattleUnit:
	for e in _foes(scene):
		if not (e as BattleUnit).is_ranged and not skip.has(e):
			return e
	return null


func _ability(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _taken(scene: Node, h: BattleUnit) -> Dictionary:
	return ((scene.get("_run_taken") as Dictionary).get(h.unit_name, {}) as Dictionary).duplicate()


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


func _new_run(engines := {}) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		var pid := String(engines.get(key, Classes.class_engines(key)[0]))
		_run.awaken(i, Runes.engine_rune_id(pid))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []


func _to(path: String) -> Node:
	change_scene_to_file(path)
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	return current_scene


# The preview a screen holds, found by the script it runs — never by a z or a text.
func _previews(screen: Node) -> Array:
	var out: Array = []
	if screen == null:
		return out
	for c in screen.get_children():
		var s: Script = c.get_script() as Script
		if s != null and s.resource_path == PREVIEW and not c.is_queued_for_deletion():
			out.append(c)
	return out


func _kit_button(n: Node, idx: int) -> Button:
	var btns: Array = []
	Gate.buttons(n, btns)
	for b in btns:
		if (b as Button).has_meta("kit_preview") and int((b as Button).get_meta("kit_preview")) == idx:
			return b
	return null


func _texts_joined(n: Node) -> String:
	return "\n".join(PackedStringArray(Gate.texts(n)))


# A left click pushed through the root viewport at `at`: the GUI's own picking decides who gets it.
func _click(at: Vector2) -> void:
	for pressed in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT
		ev.pressed = pressed
		ev.position = at
		ev.global_position = at
		root.push_input(ev, true)
		await process_frame


# ── §0 — THE CARRIED HALF IS THE RAIDER'S ──────────────────────────────────

func _s0_the_carried_half() -> void:
	print("\n§0 — the vow's carried half: the raider's kill, a Covenant's share, the riders once, nothing re-enters")
	var vow_over := {2: {"bm_abilities": ["Vow of Suffering"], "bm_equipped": ["Vow of Suffering"]}}
	# (a) THE KILL RECORD — a Devout on 1 health carries a share that fells him.
	var s: Node = await _board(SPECS, vow_over)
	var w := _hero(s, "warrior")
	var c := _hero(s, "cleric")
	var foe := _melee(s)
	if [w, c, foe].any(func(x): return x == null):
		ok(false, "§0: the board seats a Warden, a Devout and a raider")
	else:
		s._apply_status(w, "vow", 4, 0, 0, c)
		w.hp = w.max_hp
		c.hp = 1
		var kills0: int = (s.get("_run_kills") as Array).size()
		seed(SEED)
		await s._resolve(foe, foe.abilities[0], w, "good")
		var kills: Array = s.get("_run_kills")
		var rec: Dictionary = kills[kills.size() - 1] if kills.size() > kills0 else {}
		ok(c.hp <= 0 and not rec.is_empty() and String(rec.get("hero", "")) == c.unit_name,
			"§0a: the share did not fell the Devout on 1 health, or no killing blow was recorded (%s)" % [rec])
		ok(not rec.is_empty() and String(rec.get("source", "")) == Enemies.unit_name(foe.enemy_kind)
			and String(rec.get("ability", "")) == (foe.abilities[0] as Ability).display_name
			and not bool(rec.get("self", true)),
			"§0a: the Devout's death by the carried half is recorded as %s — it is the raider's kill" % [rec])
		print("  (a) the Devout falls to the carried half: %s / %s, self %s" % [rec.get("source", "?"),
			rec.get("ability", "?"), rec.get("self", "?")])
	await _clear(s)
	# (b) A COVENANT-BOUND DEVOUT SHARES THE CARRIED HALF — a chain of two cards the player chose.
	var cov_over := {2: {"bm_abilities": ["Vow of Suffering"], "bm_equipped": ["Vow of Suffering"],
		"engines": _engines(["conviction", "covenant_oath"])}}
	var s2: Node = await _board(SPECS, cov_over)
	var w2 := _hero(s2, "warrior")
	var c2 := _hero(s2, "cleric")
	var foe2 := _melee(s2)
	var partner: BattleUnit = c2.covenant_partner() if c2 != null else null
	# The vowed ally is anyone but the Devout and the one he is bound to, so the three bodies are three.
	if partner == w2:
		for hh in s2.get("heroes"):
			if not hh.is_companion and hh != c2 and hh != partner:
				w2 = hh
				break
	if [w2, c2, foe2, partner].any(func(x): return x == null) or partner == w2:
		ok(false, "§0b: the Oathkeeper Devout is bound to nobody, or to the only ally the vow can go on (partner %s)" % [partner])
	else:
		s2._apply_status(w2, "vow", 4, 0, 0, c2)
		for u in [w2, c2, partner]:
			u.hp = u.max_hp
		var c0 := c2.hp
		var p0 := partner.hp
		var w0 := w2.hp
		seed(SEED)
		await s2._resolve(foe2, foe2.abilities[0], w2, "good")
		var wl := w0 - w2.hp
		var cl := c0 - c2.hp
		var pl := p0 - partner.hp
		ok(wl > 0 and cl > 0 and pl > 0,
			"§0b: the Warden lost %d, the Devout %d, his bound %s %d — the Covenant did not share the carried half" % [
				wl, cl, partner.unit_name, pl])
		var pt := _taken(s2, partner)
		var wound := "%s / %s" % [Enemies.unit_name(foe2.enemy_kind), (foe2.abilities[0] as Ability).display_name]
		ok(pt.keys() == [wound], "§0b: the bound ally's share of the carried half is booked %s — the raider's wound" % [pt])
		print("  (b) the Warden %d, the Devout %d, the bound %s %d — one blow on three bodies, booked %s" % [
			wl, cl, partner.unit_name, pl, pt.keys()])
	await _clear(s2)
	# (c) THE SWING'S RIDERS FIRE ONCE — an attack that applies a status every time, and a lifesteal on it.
	var s3: Node = await _board(SPECS, vow_over)
	var w3 := _hero(s3, "warrior")
	var c3 := _hero(s3, "cleric")
	var foe3 := _melee(s3)
	var rider: Ability = null
	for a in _all_enemy_abilities():
		var ab: Ability = a
		if not ab.applies_status.is_empty() and ab.status_chance >= 1.0 and not ab.aoe and ab.damage > 0 \
				and ab.target != Ability.Target.ALLY and ab.special == "":
			rider = ab
			break
	if [w3, c3, foe3, rider].any(func(x): return x == null):
		ok(false, "§0c: the board and an always-landing status attack for the riders' arm (%s)" % [rider])
	else:
		var sid := String(rider.applies_status.get("id", ""))
		var leech: Ability = Ability.make({"display_name": rider.display_name, "damage": rider.damage,
			"pressure": rider.pressure, "applies_status": rider.applies_status, "status_chance": 1.0,
			"lifesteal": 0.5, "dmg_type": rider.dmg_type})
		s3._apply_status(w3, "vow", 4, 0, 0, c3)
		w3.hp = w3.max_hp
		c3.hp = c3.max_hp
		foe3.max_hp = maxi(foe3.max_hp, 1000)
		foe3.hp = foe3.max_hp - 400
		var log0 := _log_text(s3).length()
		var cp0 := c3.pressure
		seed(SEED)
		await s3._resolve(foe3, leech, w3, "good")
		var lines := _log_text(s3).substr(log0)
		var leeches := lines.count("leeches")
		ok(w3.has_status(sid) and not c3.has_status(sid),
			"§0c: the swing's %s landed on the Warden %s and on the Devout %s — once, on the struck body" % [
				sid, w3.has_status(sid), c3.has_status(sid)])
		ok(leeches == 1, "§0c: the swing's lifesteal fired %d time(s) — once, on the swing's result" % leeches)
		ok(c3.pressure == cp0, "§0c: the Devout's Break moved %d → %d — Break stays on the struck body" % [cp0, c3.pressure])
		print("  (c) %s on the vowed Warden: the status on the Warden %s / the Devout %s; lifesteal lines %d; the Devout's Break %d → %d" % [
			rider.display_name, w3.has_status(sid), c3.has_status(sid), leeches, cp0, c3.pressure])
	await _clear(s3)
	# (d) NOTHING RE-ENTERS — the Devout wears a vow himself; the share he carries is not moved again, and a
	# blow on the vowed Devout is his whole.
	var s4: Node = await _board(SPECS, vow_over)
	var w4 := _hero(s4, "warrior")
	var c4 := _hero(s4, "cleric")
	var foe4 := _melee(s4)
	if [w4, c4, foe4].any(func(x): return x == null):
		ok(false, "§0d: the board seats a Warden, a Devout and a raider")
	else:
		s4._apply_status(w4, "vow", 4, 0, 0, c4)
		s4._apply_status(c4, "vow", 4, 0, 0, c4)
		w4.hp = w4.max_hp
		c4.hp = c4.max_hp
		seed(SEED)
		await s4._resolve(foe4, foe4.abilities[0], w4, "good")
		var wl4 := w4.max_hp - w4.hp
		var cl4 := c4.max_hp - c4.hp
		ok(cl4 > 0 and cl4 == (wl4 + cl4) / 2,
			"§0d: the Warden lost %d and the Devout %d of %d — the carried half moved again or was lost" % [wl4, cl4, wl4 + cl4])
		c4.hp = c4.max_hp
		w4.hp = w4.max_hp
		seed(SEED)
		await s4._resolve(foe4, foe4.abilities[0], c4, "good")
		ok(w4.hp == w4.max_hp and c4.hp < c4.max_hp,
			"§0d: a blow on the vowed Devout moved %d onto the Warden — a vow cannot carry its own wearer's wound" % (w4.max_hp - w4.hp))
		print("  (d) the Devout under his own vow carries %d of %d, once; struck himself he keeps the whole" % [cl4, wl4 + cl4])
	await _clear(s4)


func _all_enemy_abilities() -> Array:
	var out: Array = []
	var f := FileAccess.open("res://data/enemies.json", FileAccess.READ)
	var kinds: Dictionary = JSON.parse_string(f.get_as_text())
	f.close()
	var names: Array = kinds.keys()
	names.sort()
	for kind in names:
		var cfg: Dictionary = Enemies.config(String(kind))
		for a in cfg.get("abilities", []):
			if a is Ability:
				out.append(a)
	return out


# ── §1a — THE TELEGRAPH, ON HOVER ──────────────────────────────────────────

func _intent_label(u: BattleUnit) -> Label:
	return u.get("_intent_label") as Label


# The detail as the engine would show it: the line's own tooltip, asked of the control.
func _hover(u: BattleUnit) -> String:
	var l := _intent_label(u)
	if l == null or not l.visible or l.mouse_filter == Control.MOUSE_FILTER_IGNORE:
		return ""
	return l.get_tooltip(Vector2(2, 2))


func _declare(scene: Node, u: BattleUnit, ab: Ability, target: BattleUnit) -> void:
	u.intent = {"ability": ab, "target": target, "turns": 1, "support": false, "message": "",
		"logs": [], "category": scene._intent_category(u, ab)}
	scene._refresh_intent_plate(u)


func _detail_lines(scene: Node, u: BattleUnit, ab: Ability) -> Array:
	var want: Array = [ab.display_name]
	if ab.damage > 0:
		want.append(_call(scene, "_damage_line", [u, ab], "<no damage line>"))
	var sid := String(ab.applies_status.get("id", ""))
	if sid != "":
		var label := String((scene.get("STATUS_INFO") as Dictionary)[sid][0]) \
			if (scene.get("STATUS_INFO") as Dictionary).has(sid) else sid.capitalize()
		want.append("Applies %s" % label)
	return want


func _s1a_the_telegraph() -> void:
	print("\n§1a — the enemy's declared attack, on hover: the effect, never the target")
	var s: Node = await _board(SPECS, {})
	var w := _hero(s, "warrior")
	var foe := _melee(s)
	if w == null or foe == null:
		ok(false, "§1a: the board seats a Warden and a raider")
		await _clear(s)
		return
	var heroes: Array = (s.get("heroes") as Array).filter(func(h): return not h.is_companion)
	var with_status: Ability = null
	var plain: Ability = null
	for a in foe.abilities:
		var ab: Ability = a
		if ab.damage > 0 and not ab.applies_status.is_empty() and with_status == null:
			with_status = ab
		elif ab.damage > 0 and ab.applies_status.is_empty() and plain == null:
			plain = ab
	ok(with_status != null and plain != null,
		"§1a: the raider carries an attack that applies a status and one that applies nothing")
	# THE POSITIVE ARM — the attack that applies something, aimed at the Warden.
	if with_status != null:
		_declare(s, foe, with_status, w)
		var txt := _hover(foe)
		var lines := txt.split("\n")
		var sid := String(with_status.applies_status.get("id", ""))
		var st_label := String((s.get("STATUS_INFO") as Dictionary)[sid][0])
		var st_turns := int(with_status.applies_status.get("turns", 0))
		var want_applies := "Applies %s for %d turn%s" % [st_label, st_turns, "" if st_turns == 1 else "s"]
		if with_status.status_chance < 1.0:
			want_applies += " (%d%% chance)" % int(round(with_status.status_chance * 100.0))
		ok(txt != "" and _intent_label(foe).mouse_filter == Control.MOUSE_FILTER_PASS,
			"§1a: the intent line of a declaring enemy carries no hover (filter %d)" % _intent_label(foe).mouse_filter)
		ok(lines.size() > 0 and lines[0] == with_status.display_name,
			"§1a: the hover does not open on the attack's name: %s" % [lines])
		ok(lines.has(_call(s, "_damage_line", [foe, with_status], "<no damage line>")),
			"§1a: the hover's band is not the damage line the ability's own data gives: %s" % [lines])
		ok(lines.has(want_applies), "§1a: the hover does not say `%s`: %s" % [want_applies, lines])
		ok(lines.has("Hits one hero"), "§1a: the hover does not say how many it hits: %s" % [lines])
		var named: Array = heroes.filter(func(h): return txt.contains(h.unit_name))
		ok(named.is_empty(), "§1a: the hover names %s — it says what the attack does, never whom it is aimed at" % [
			named.map(func(h): return h.unit_name)])
		ok(not lines.has(""), "§1a: the hover prints an empty line: %s" % [lines])
		print("  declared %s at the %s → hover:\n      %s" % [with_status.display_name, w.unit_name,
			"\n      ".join(lines)])
	# THE NEGATIVE ARM — an attack that applies nothing prints no effect line.
	if plain != null:
		_declare(s, foe, plain, w)
		var txt2 := _hover(foe)
		var lines2 := txt2.split("\n")
		ok(txt2 != "" and lines2[0] == plain.display_name, "§1a: the plain attack's hover is %s" % [lines2])
		ok(not txt2.contains("Applies") and not lines2.has(""),
			"§1a: an attack that applies nothing printed an effect line or an empty one: %s" % [lines2])
		print("  declared %s → hover: %s" % [plain.display_name, " | ".join(lines2)])
	# THE ENEMY WITH NOTHING TO DETAIL — no declaration, no line, no hover.
	foe.intent = {}
	s._refresh_intent_plate(foe)
	ok(not _intent_label(foe).visible and _intent_label(foe).tooltip_text == ""
		and _intent_label(foe).mouse_filter == Control.MOUSE_FILTER_IGNORE,
		"§1a: an enemy that declares nothing still shows a line or a hover")
	# THE HOVER IS WHERE THE MOUSE IS — a motion pushed onto the line lands on the line.
	if with_status != null:
		_declare(s, foe, with_status, w)
		await process_frame
		var lbl := _intent_label(foe)
		var mv := InputEventMouseMotion.new()
		var at := lbl.get_global_rect().position + Vector2(6, 5)
		mv.position = at
		mv.global_position = at
		root.push_input(mv, true)
		await process_frame
		var hovered: Control = root.gui_get_hovered_control() if root.has_method("gui_get_hovered_control") else null
		ok(hovered == lbl, "§1a: a pointer on the intent line hovers %s, not the line" % [hovered])
	# THE TURN BAR'S GLYPH IS THE SAME TELEGRAPH, AND CARRIES THE SAME DETAIL.
	if with_status != null:
		_declare(s, foe, with_status, w)
		s._rebuild_turn_bar()
		await process_frame
		var glyph_tip := ""
		var stack: Array = [s.get("turn_bar")]
		while not stack.is_empty():
			var cur: Node = stack.pop_back()
			if cur == null:
				continue
			if cur is Label and String((cur as Label).tooltip_text).begins_with(foe.unit_name + ":") \
					and (cur as Label).tooltip_text.contains(with_status.display_name):
				glyph_tip = (cur as Label).tooltip_text
			for k in cur.get_children():
				stack.append(k)
		ok(glyph_tip != "" and glyph_tip.contains(String(_call(s, "_intent_hover_text", [foe], "<no hover>"))),
			"§1a: the turn bar's glyph does not carry the plate's detail (%s)" % glyph_tip.replace("\n", " | "))
	# THE CENSUS — every enemy ability in the data, detailed off its own fields, never a target.
	var n := 0
	var bad: Array = []
	for a in _all_enemy_abilities():
		var ab: Ability = a
		_declare(s, foe, ab, w)
		var t := String(_call(s, "_intent_hover_text", [foe], ""))
		var ls := t.split("\n")
		n += 1
		var why := ""
		if ls[0] != ab.display_name:
			why = "opens on %s" % ls[0]
		elif ls.has(""):
			why = "an empty line"
		elif (ab.damage > 0) != ls.has(_call(s, "_damage_line", [foe, ab], "<no damage line>")):
			why = "the band line"
		elif (not ab.applies_status.is_empty()) != t.contains("Applies "):
			why = "the effect line"
		elif ab.description != "" and not t.contains(ab.description):
			why = "its own description"
		elif heroes.any(func(h): return t.contains(h.unit_name)):
			why = "names a hero"
		elif ab.target != Ability.Target.ALLY and (ab.damage > 0 or ab.pressure > 0) \
				and not (t.contains("Hits every hero") or t.contains("Hits one hero") or t.contains("Hits ")):
			why = "no reach"
		if why != "":
			bad.append("%s (%s)" % [ab.display_name, why])
	ok(bad.is_empty(), "§1a: %d of %d enemy abilities detail wrong: %s" % [bad.size(), n, ", ".join(PackedStringArray(bad))])
	ok(n >= 40, "§1a: the census read %d enemy abilities — the walk has gone vacuous" % n)
	print("  CHECKED %d enemy abilities against their own data" % n)
	await _clear(s)


# ── §1c — THE NAMEPLATE IS A SECOND HIT AREA ───────────────────────────────

func _plate(u: BattleUnit) -> Control:
	return u.get("_plate_panel") as Control


func _s1c_the_plates() -> void:
	print("\n§1c — a click on a target's nameplate picks it; outside targeting it does nothing")
	var s: Node = await _board(SPECS, {})
	Engine.time_scale = 1.0
	var w := _hero(s, "warrior")
	var c := _hero(s, "cleric")
	var foe := _melee(s)
	var other := _melee(s, [foe])
	if [w, c, foe, other].any(func(x): return x == null):
		ok(false, "§1c: the board seats a Warden, a Devout and two raiders")
		await _clear(s)
		return
	var picked: Array = []
	s._target_picked.connect(func(u): picked.append(u))
	var clicks := [0]
	foe.clicked.connect(func(): clicks[0] += 1)
	var tip0 := _plate(foe).tooltip_text
	# OUTSIDE TARGETING — what it did at HY: nothing.
	await _click(_plate(foe).get_global_rect().position + Vector2(70, 7))
	ok(picked.is_empty() and clicks[0] == 0,
		"§1c: a click on a plate outside targeting picked %s and emitted %d click(s) — it must do nothing" % [picked, clicks[0]])
	ok(_plate(foe).tooltip_text == tip0, "§1c: the plate's tooltip moved under a click")
	# DURING TARGETING — the plate, a chip on it and the intent line on it each pick their unit.
	var arms := [["the plate", func(u): return _plate(u).get_global_rect().position + Vector2(70, 7)]]
	for arm in arms:
		picked.clear()
		s._pick_target([foe, other])
		await process_frame
		await _click(arm[1].call(foe))
		await process_frame
		ok(picked.size() == 1 and picked[0] == foe,
			"§1c (%s): a click on the raider's plate during targeting picked %s" % [arm[0], picked])
	# A CHIP — a status chip stops the mouse for its tooltip, and answers as the plate.
	s._apply_status(foe, "sunder", 3, 0, 0, w)
	await process_frame
	var chips_root: Node = foe.get("_chips_root")
	var chip: Control = null
	for k in (chips_root.get_children() if chips_root != null else []):
		if k is ColorRect and not k.is_queued_for_deletion():
			chip = k
	picked.clear()
	s._pick_target([foe, other])
	await process_frame
	if chip != null:
		await _click(chip.get_global_rect().get_center())
		await process_frame
	ok(chip != null and picked.size() == 1 and picked[0] == foe,
		"§1c (a chip): a click on the raider's status chip during targeting picked %s" % [picked])
	if picked.is_empty():
		s._target_picked.emit(null)
		await process_frame
	# THE INTENT LINE — it takes the mouse for its hover and passes the click to the plate.
	foe.intent = {"ability": foe.abilities[0], "target": w, "turns": 1, "support": false, "message": "",
		"logs": [], "category": "strike"}
	s._refresh_intent_plate(foe)
	await process_frame
	picked.clear()
	s._pick_target([foe, other])
	await process_frame
	var il := _intent_label(foe)
	await _click(il.get_global_rect().position + Vector2(6, 5))
	await process_frame
	ok(picked.size() == 1 and picked[0] == foe,
		"§1c (the intent line): a click on the raider's intent line during targeting picked %s" % [picked])
	if picked.is_empty():
		s._target_picked.emit(null)
		await process_frame
	# A PLATE OUTSIDE THE POOL — the Devout's, while only the raiders are targets — picks nothing.
	picked.clear()
	s._pick_target([foe, other])
	await process_frame
	await _click(_plate(c).get_global_rect().position + Vector2(70, 7))
	await process_frame
	ok(picked.is_empty(), "§1c: a click on a plate outside the pool picked %s" % [picked])
	s._target_picked.emit(null)
	await process_frame
	# A HERO'S PLATE FOR A SUPPORT — the same door on the party's side.
	picked.clear()
	var allies: Array = (s.get("heroes") as Array).filter(func(h): return not h.dead and not h.is_companion)
	s._pick_target(allies)
	await process_frame
	await _click(_plate(c).get_global_rect().position + Vector2(70, 7))
	await process_frame
	ok(picked.size() == 1 and picked[0] == c,
		"§1c: a click on the Devout's plate while the party is the pool picked %s" % [picked])
	# AND AFTER IT — targeting over, the same plate does nothing again.
	picked.clear()
	clicks[0] = 0
	await _click(_plate(foe).get_global_rect().position + Vector2(70, 7))
	ok(picked.is_empty() and clicks[0] == 0, "§1c: after targeting a plate click picked %s" % [picked])
	await _clear(s)


# ── §1d — THE CHIPS: WHAT IS PAYING RIGHT NOW ─────────────────────────────

func _rune_chips(u: BattleUnit) -> Array:
	var out: Array = []
	var r: Node = u.get("_rune_chip_root")
	if r != null and is_instance_valid(r) and not r.is_queued_for_deletion():
		for c in r.get_children():
			if not c.is_queued_for_deletion():
				out.append(c)
	return out


func _crest_chips(scene: Node) -> Array:
	var out: Array = []
	var strip: Node = scene.get("_crest_strip")
	if strip != null and is_instance_valid(strip) and not strip.is_queued_for_deletion():
		for c in strip.get_children():
			if c is Panel and c.has_meta("rune_chip"):
				out.append(c)
	return out


func _pct_words(payload: Dictionary) -> String:
	var stat: Dictionary = payload.get("stat", {})
	for f in stat:
		if String(f) in ["dmg_taken_bonus", "dmg_bonus"]:
			return "%d%%" % int(round(absf(float(stat[f])) * 100.0))
		if String(f) == "rune_blood_communion":
			return "%d%%" % int(round(float(stat[f])))
	return "?"


func _s1d_the_chips() -> void:
	print("\n§1d — the chips: the crest's one, a hero's own, ARMED and PAYING, read off the data")
	# THE NEGATIVE ARM — nothing that turns on and off: no rune chip on any plate, no crest strip.
	var s0: Node = await _board(SPECS, {})
	var none_chipped := true
	for h in s0.get("heroes"):
		if not h.is_companion and not _rune_chips(h).is_empty():
			none_chipped = false
	ok(none_chipped and s0.get("_crest_strip") == null,
		"§1d: a party wearing nothing that turns on and off drew a rune chip or a crest strip")
	await _clear(s0)
	# THE CREST — Empty Pulpit and Dirge, each one chip on the strip and on no plate; ARMED, then PAYING.
	for rid in ["empty_pulpit", "dirge"]:
		var rune: Dictionary = _rune(rid)
		var s: Node = await Gate.spawn(self, SPECS, {"deterministic": true, "party_runes": [rune]})
		Engine.time_scale = 1.0
		await Gate.frames(self, 2)
		var cc: Array = _crest_chips(s)
		var on_plates := 0
		for h2 in s.get("heroes"):
			if not h2.is_companion:
				for ch in _rune_chips(h2):
					if String(ch.get_meta("rune_chip")) == String(rune["name"]):
						on_plates += 1
		ok(cc.size() == 1 and on_plates == 0,
			"§1d (%s): the crest's rune drew %d chip(s) on the strip and %d on the plates — one chip, never four" % [
				rune["name"], cc.size(), on_plates])
		var armed0 := cc.size() == 1 and not bool(cc[0].get_meta("paying"))
		if cc.size() == 1:
			var tip0 := String((cc[0] as Panel).tooltip_text)
			ok(not bool(cc[0].get_meta("paying")) and tip0.contains("ARMED"),
				"§1d (%s): with every hero standing the chip is not ARMED: %s" % [rune["name"], tip0.replace("\n", " | ")])
			ok(tip0.contains(_pct_words(rune["payload"])) and tip0.contains(String(rune["name"])),
				"§1d (%s): the chip's words do not carry the payload's own figure (%s): %s" % [
					rune["name"], _pct_words(rune["payload"]), tip0.replace("\n", " | ")])
		# The condition comes true the way it does in a fight: a hero falls through the damage door.
		var victim := _hero(s, "cleric")
		if rid == "dirge":
			victim = _hero(s, "hunter")
		victim.take_hit(victim.hp + victim.max_hp, 0)
		await Gate.frames(self, 2)
		var cc2: Array = _crest_chips(s)
		ok(victim.dead and cc2.size() == 1 and bool(cc2[0].get_meta("paying"))
			and String((cc2[0] as Panel).tooltip_text).contains("PAYING"),
			"§1d (%s): with the %s fallen the chip does not read PAYING" % [rune["name"], victim.unit_name])
		print("  %s: %s → %s" % [rune["name"], "ARMED" if armed0 else "?",
			String((cc2[0] as Panel).tooltip_text).replace("\n", " | ") if cc2.size() == 1 else "<no chip>"])
		await _clear(s)
	# A CREST RUNE WITH NO CONDITION — it pays whenever its own trigger comes: PAYING while worn.
	var tithe: Dictionary = _rune("tithe")
	var st: Node = await Gate.spawn(self, SPECS, {"deterministic": true, "party_runes": [tithe]})
	Engine.time_scale = 1.0
	await Gate.frames(self, 2)
	var tc: Array = _crest_chips(st)
	ok(tc.size() == 1 and bool(tc[0].get_meta("paying")) and String((tc[0] as Panel).tooltip_text).contains(_pct_words(tithe["payload"])),
		"§1d (Tithe): the crest's rune with no condition does not read PAYING with its own figure")
	await _clear(st)
	# LAST RITES — the node's field on the Warrior: ARMED above a quarter's health, PAYING below it with Rage in
	# the bar, and turned off by a dump. And a vowed Devout's ground, chipped while it stands.
	var over := {0: {"bm_abilities": ["Boil Over"], "bm_equipped": ["Boil Over"]}.merged(_rites()),
		2: {"runes": [_rune("vow_of_silence")], "bm_abilities": ["Consecrated Ground"], "bm_equipped": ["Consecrated Ground"]}}
	var s3: Node = await _board(["berserker", "pyromancer", "inquisitor", "mystic"], over)
	var war := _hero(s3, "warrior")
	var dv := _hero(s3, "cleric")
	var foe := _melee(s3)
	if [war, dv, foe].any(func(x): return x == null):
		ok(false, "§1d: the board seats a Warrior, a vowed Devout and a raider")
	else:
		war.hp = war.max_hp
		war.resource = war.max_resource
		_call(s3, "_refresh_rune_chips", [], null)
		var lr: Array = _rune_chips(war)
		ok(lr.size() == 1 and not bool(lr[0].get_meta("paying")), "§1d: at full health Last Rites' chip is not ARMED")
		war.hp = int(war.max_hp * 0.2)
		_call(s3, "_refresh_rune_chips", [], null)
		lr = _rune_chips(war)
		ok(lr.size() == 1 and bool(lr[0].get_meta("paying")) and String((lr[0] as Panel).tooltip_text).contains("%d left" % war.resource),
			"§1d: below a quarter's health with Rage in the bar Last Rites' chip is not PAYING")
		var dump: Ability = _ability(war, "Boil Over")
		if dump != null:
			war.cooldowns.clear()
			seed(SEED)
			await s3._resolve(war, dump, foe, "good")
			_call(s3, "_refresh_rune_chips", [], null)
			lr = _rune_chips(war)
			ok(war.resource == 0 and lr.size() == 1 and not bool(lr[0].get_meta("paying"))
				and String((lr[0] as Panel).tooltip_text).contains("no Rage left"),
				"§1d: after the dump Last Rites' chip does not say the bar is dry")
		var vc: Array = _rune_chips(dv)
		ok(vc.size() == 1 and not bool(vc[0].get_meta("paying")), "§1d: the vowed Devout carrying the ground has no ARMED chip")
		s3._apply_status(war, "cons_ground", 3, 0, 0, dv)
		_call(s3, "_refresh_rune_chips", [], null)
		vc = _rune_chips(dv)
		ok(vc.size() == 1 and bool(vc[0].get_meta("paying")) and String((vc[0] as Panel).tooltip_text).contains("reflects nothing"),
			"§1d: with his ground laid the vowed Devout's chip does not say it reflects nothing")
		# A RUNE CHIP IS NOT A STATUS: not in the status row, not a filled chip, and the row is untouched.
		var status_row: Node = dv.get("_chips_root")
		var in_row := false
		for k in (status_row.get_children() if status_row != null else []):
			if k.has_meta("rune_chip"):
				in_row = true
		ok(not in_row and vc.size() == 1 and vc[0] is Panel and not (vc[0] is ColorRect)
			and not dv.has_status(String(vc[0].get_meta("rune_chip"))),
			"§1d: a rune chip was drawn as a status, in the status row, or written as a status")
		print("  Last Rites: ARMED → PAYING below a quarter → dry after the dump; the vowed ground: ARMED → IN EFFECT")
	await _clear(s3)


# ── §2 — BOIL OVER IS A RAGE DUMP ──────────────────────────────────────────

# One cast at `foe` on a fresh field: what the WHOLE field lost — an area card's other bodies count, as
# they do in a fight. Every enemy is put back to its own maximum health first, with no status and no
# Bleed carried from the last cast, so a burst that reads a body's maximum is priced on a real body.
func _cast(scene: Node, u: BattleUnit, ab: Ability, foe: BattleUnit, rage: int, hp_frac := 1.0) -> int:
	u.hp = maxi(int(u.max_hp * hp_frac), 1)
	u.resource = rage
	u.rage_spent = 0
	u.frenzy_floor = 0.0
	u.cooldowns.clear()
	var before := 0
	for e in scene.get("enemies"):
		var eu: BattleUnit = e
		eu.dead = false
		eu.statuses.clear()
		eu.bleed_buildup = 0
		eu.pressure = 0
		eu.broken = false
		eu.hp = eu.max_hp
		before += eu.hp
	seed(SEED)
	await scene._resolve(u, ab, foe, "good")
	var after := 0
	for e2 in scene.get("enemies"):
		after += maxi((e2 as BattleUnit).hp, 0)
	return before - after


func _dump_board(with_core: bool, rites := false) -> Node:
	var over := {0: {"bm_abilities": ["Boil Over"], "bm_equipped": ["Boil Over"]}}
	if not with_core:
		over[0]["engines"] = _engines(["heavy_plating"])
	if rites:
		over[0].merge(_rites())
	return await _board(["berserker", "pyromancer", "inquisitor", "mystic"], over)


# LAST RITES IS THE TIER-3 NODE'S FIELD, AND THE SPAWN WRITES IT. The Warrior is seated holding
# *Pay a Lethal Hit out of Your Resource Pool* — the class tree, the node learned — so the battle's
# own payload door writes `last_rites` as it does in a run. Set by hand on the built unit, the arms
# below would pass on a build whose node no longer wrote it (`check_gw` §2's shape).
func _rites() -> Dictionary:
	return {"tree": Talents.tree(), "talents": {"tn_resource_ward": 1}}


func _card_on(war: BattleUnit, cname: String) -> Ability:
	var ab: Ability = _ability(war, cname)
	if ab == null:
		ab = Classes.pool_ability(cname)
	for sp in Classes.SPEC_IDS.get("warrior", []):
		if ab == null:
			ab = Classes.spec_pool_ability(String(sp), cname)
	return ab


# One card cast on its OWN fresh board, so nothing a card before it left on the Warrior — Berserk's doubled
# strikes, a shout's damage, a stance — prices the next one. A full bar, so nothing is refused for its price.
func _priced(with_core: bool, cname: String) -> int:
	var s: Node = await _dump_board(with_core)
	var war := _hero(s, "warrior")
	var foe := _melee(s)
	var ab: Ability = _card_on(war, cname) if war != null else null
	var dealt := -1
	if war != null and foe != null and ab != null:
		dealt = await _cast(s, war, ab, foe, war.max_resource)
	await _clear(s)
	return dealt


func _s2_the_rage_dump() -> void:
	print("\n§2 — Boil Over pours out the whole bar: priced against every Rage card, with the core and without")
	var bo: Ability = Classes.pool_ability("Boil Over")
	ok(bo != null and bo.cost == 0 and bo.gated and bo.perfect_text == "" and bo.special == "",
		"§2: Boil Over is not a gated strike with no cost of its own and no Perfect rider")
	if bo == null:
		return
	var rate: float = float(_const("BOIL_OVER_PCT_PER_RAGE", -1.0))
	var floor_frac: float = float(_const("BOIL_OVER_MIN_BAR", -1.0))
	ok(rate > 0.0 and floor_frac > 0.0 and bo.description.contains(String.num(rate)) \
		and bo.description.contains("%d%%" % int(round(floor_frac * 100.0))),
		"§2: the card's words do not carry the rate and the floor off the constants: %s" % bo.description)
	var rows := {}
	for with_core in [false, true]:
		var s: Node = await _dump_board(with_core)
		var war := _hero(s, "warrior")
		var foe := _melee(s)
		var dump: Ability = _ability(war, "Boil Over") if war != null else null
		if [war, foe, dump].any(func(x): return x == null) or war.has_engine("bloodrage") != with_core:
			ok(false, "§2: the board seats a Warrior %s the Berserker's core, carrying Boil Over" % [
				"holding" if with_core else "without"])
			await _clear(s)
			continue
		var tag := "with the core" if with_core else "without"
		var mx := war.max_resource
		var floor_r := int(_call(_cls(), "rage_dump_min", [mx], int(ceil(mx * 0.4))))
		# THE FLOOR — refused below it, castable at it.
		war.resource = floor_r - 1
		ok(not s._ability_usable(war, dump), "§2 (%s): the dump is castable on %d Rage, under its floor of %d" % [tag, floor_r - 1, floor_r])
		war.resource = floor_r
		ok(s._ability_usable(war, dump), "§2 (%s): the dump is refused on %d Rage, its floor" % [tag, floor_r])
		# THE FULL BAR — the bar empties, the band is told, and no recovery is written.
		var full := await _cast(s, war, dump, foe, mx)
		ok(war.resource == 0 and war.rage_spent == mx,
			"§2 (%s): a full bar left %d Rage and booked %d spent — the dump pours out all %d" % [tag, war.resource, war.rage_spent, mx])
		ok(not war.has_status("boil_over"), "§2 (%s): the dump wrote the old recovery status" % tag)
		var at_floor := await _cast(s, war, dump, foe, floor_r)
		var half_full := await _cast(s, war, dump, foe, mx, 0.5)
		var names: Array = war.abilities.map(func(a): return (a as Ability).display_name)
		names.append_array(Classes.draft_pool("warrior"))
		for sp in Classes.SPEC_IDS.get("warrior", []):
			names.append_array(Classes.spec_pool(String(sp)))
		var cards: Array = []
		for card in names:
			var ab0: Ability = _card_on(war, String(card))
			if ab0 == null or cards.has(String(card)) or ab0.display_name == "Boil Over" or ab0.cost <= 0 \
					or ab0.target == Ability.Target.ALLY:
				continue
			cards.append(String(card))
		await _clear(s)
		# EVERY CARD THAT SPENDS RAGE TODAY: the kit he holds, the Warrior's draft shelf and the boss pools of
		# its three lineages — each aimed at an enemy and cast once on its own board, handlers included, so a
		# card whose blow a handler rolls is priced as it lands. One that deals nothing is listed apart.
		var best := 0
		var best_name := ""
		var plain := 0
		var table: Array = []
		var nothing: Array = []
		for cname in cards:
			var dealt := await _priced(with_core, String(cname))
			var ab1: Ability = Classes.pool_ability(String(cname))
			var cost := ab1.cost if ab1 != null else 0
			if cost <= 0:
				for sp3 in Classes.SPEC_IDS.get("warrior", []):
					var a3: Ability = Classes.spec_pool_ability(String(sp3), String(cname))
					if a3 != null and cost <= 0:
						cost = a3.cost
			if dealt <= 0:
				nothing.append(cname)
				continue
			table.append([cname, maxi(cost, 1), dealt])
			if dealt > best:
				best = dealt
				best_name = cname
			if cname == "Crushing Blow":
				plain = dealt
		rows[tag] = {"full": full, "floor": at_floor, "half_hp": half_full, "best": best, "best_name": best_name,
			"plain": plain, "max": mx, "floor_r": floor_r}
		table.sort_custom(func(a, b): return a[2] > b[2])
		print("  [%s] a bar of %d, floor %d: a full bar deals %d (at half health %d); the floor %d" % [
			tag, mx, floor_r, full, half_full, at_floor])
		print("      the Rage cards, one cast each on its own board: %s" % ", ".join(PackedStringArray(table.map(
			func(r): return "%s %d for %d (%.2f a point)" % [r[0], r[2], r[1], float(r[2]) / float(r[1])]))))
		print("      and %d that deal nothing on this board: %s" % [nothing.size(), ", ".join(PackedStringArray(nothing))])
		# THE SHAPE THE DESIGNER SET AS THE PASS CONDITION: a full bar beats the best ordinary turn and does not
		# beat two; a cast at the floor is worse than an ordinary card.
		ok(table.size() >= 10, "§2 (%s): only %d Rage cards were priced — the census has gone vacuous" % [tag, table.size()])
		ok(full > best, "§2 (%s): a full bar deals %d, not more than the best ordinary turn (%s, %d)" % [tag, full, best_name, best])
		ok(full < 2 * best, "§2 (%s): a full bar deals %d, more than two of the best ordinary turn (%s, %d)" % [tag, full, best_name, best])
		ok(plain > 0 and at_floor < plain,
			"§2 (%s): a cast at the floor deals %d, not less than an ordinary card (Crushing Blow, %d)" % [tag, at_floor, plain])
		# LAST RITES — the tier-3 node's field, live below a quarter's health; a dump empties the bar it pays
		# from, and that is allowed: the cast is not refused, and the next blow is paid in health.
		var s2: Node = await _dump_board(with_core, true)
		var war2 := _hero(s2, "warrior")
		var foe2 := _melee(s2)
		var dump2: Ability = _ability(war2, "Boil Over") if war2 != null else null
		if [war2, foe2, dump2].any(func(x): return x == null):
			ok(false, "§2 (%s): the Last Rites board seats a Warrior carrying Boil Over and a raider" % tag)
		else:
			war2.hp = int(war2.max_hp * 0.2)
			war2.resource = war2.max_resource
			# THE ARM'S PREMISE, ASSERTED: the window is open on this board — the spawn wrote the node's field, he
			# stands under a quarter's health and the bar holds Rage. Without it the two arms below would pass on
			# a build whose node wrote nothing: a dump is castable and a blow reaches health either way.
			var open_now: bool = bool(_call(war2, "last_rites_window", [], false))
			ok(war2.last_rites > 0 and open_now,
				"§2 (%s): Last Rites is not live on the arm's board (field %d, window %s) — the arm below would ask nothing" % [
					tag, war2.last_rites, open_now])
			ok(s2._ability_usable(war2, dump2), "§2 (%s): the dump is refused while Last Rites is live — refusing it removes the decision" % tag)
			await _cast(s2, war2, dump2, foe2, war2.max_resource, 0.2)
			var hp_before := war2.hp
			var log0 := _log_text(s2).length()
			seed(SEED)
			await s2._resolve(foe2, foe2.abilities[0], war2, "good")
			ok(not _log_text(s2).substr(log0).contains("Pay a Lethal Hit") and war2.hp < hp_before,
				"§2 (%s): after the dump the next blow was paid in Rage (%s), or not at all (health %d → %d)" % [
					tag, _log_text(s2).substr(log0).contains("Pay a Lethal Hit"), hp_before, war2.hp])
		await _clear(s2)
	if rows.has("with the core") and rows.has("without"):
		print("  THE NUMBER THAT DECIDES IT: a full bar reads %d without the Berserker's core and %d with it" % [
			rows["without"]["full"], rows["with the core"]["full"]])
		ok(rows["with the core"]["full"] > rows["without"]["full"],
			"§2: the core does not multiply the dump (%d with, %d without)" % [rows["with the core"]["full"], rows["without"]["full"]])


# ── §1b — THE KIT PREVIEW ──────────────────────────────────────────────────

func _s1b_the_preview() -> void:
	print("\n§1b — the kit preview: read-only, an overlay that loses nothing, from the draft and the shop")
	# (1) THE PARTY DRAFT — the Warrior owes a pick; the preview opens mid-draft, closes, and the pick lands.
	_new_run()
	var war: Dictionary = _run.party[0]
	ok(_run.award_draft_pick(war), "§1b: the Warrior could not be owed a draft pick")
	var offer: Array = _run.draft_choice(war)
	var card := String(offer[0]) if not offer.is_empty() else ""
	var mp := await _to("res://scenes/map.tscn")
	var ov: Node = Gate.overlay(mp, 62)
	ok(ov != null and card != "", "§1b: the party draft did not open for the Warrior's owed pick")
	if ov != null and card != "":
		var stage: Button = Gate.bound_button(ov, "_stage_draft", [0, card])
		ok(stage != null, "§1b: the draft column drew no button for %s" % card)
		if stage != null:
			stage.emit_signal("pressed")
			await Gate.frames(self, 2)
		ov = Gate.overlay(current_scene, 62)
		var kb := _kit_button(ov, 0)
		ok(kb != null, "§1b: the Warrior's draft column carries no kit button")
		if kb != null:
			kb.emit_signal("pressed")
			await Gate.frames(self, 2)
		var pv: Array = _previews(current_scene)
		ok(pv.size() == 1, "§1b: the column's button opened %d previews" % pv.size())
		if pv.size() == 1:
			var p: Node = pv[0]
			var txt := _texts_joined(p)
			var kit: Array = _run.opening_kit_names(war)
			var missing: Array = kit.filter(func(n): return not txt.contains(String(n)))
			ok(missing.is_empty() and not kit.is_empty(), "§1b: the preview leaves out the Warrior's kit cards %s" % [missing])
			var core_name := String((war.get("engines", [])[0] as Dictionary).get("name", "")) if not war.get("engines", []).is_empty() else ""
			ok(core_name != "" and core_name.contains("(core)") and txt.contains(core_name) and txt.contains("ENGINE"),
				"§1b: the preview does not show the Warrior's core rune as it reads (`%s`, ENGINE)" % core_name)
			var btns: Array = []
			Gate.buttons(p, btns)
			var labels: Array = btns.map(func(b): return String((b as Button).text))
			ok(labels == ["✕  Close"], "§1b: a preview opened from the draft carries buttons %s — it is read-only and stays on its hero" % [labels])
			ok(txt.contains("%s 1" % _run.nameplate(war)), "§1b: the preview is not on the Warrior, whose decision it is")
			Gate.press(p, ["✕  Close"])
			await Gate.frames(self, 2)
		ok(_previews(current_scene).is_empty(), "§1b: the preview did not close")
		ov = Gate.overlay(current_scene, 62)
		ok(ov != null and Gate.has_text(ov, "takes %s" % card),
			"§1b: after the preview closed the draft overlay is gone or lost the staged %s" % card)
		var took := Gate.press(ov, ["Confirm the draft"]) if ov != null else ""
		await Gate.frames(self, 3)
		ok(took != "" and _run.owned_ability_names(war).has(card),
			"§1b: the pick did not land after the preview — %s is not the Warrior's (confirm `%s`)" % [card, took])
		print("  the draft: %s staged, the preview opened and closed, the pick confirmed and landed: %s" % [card,
			_run.owned_ability_names(war).has(card)])
	# (2) A RUNE CACHE'S PICK — the same button, on that hero; the rune taken after it is held.
	_new_run()
	var mg: Dictionary = _run.party[1]
	var ids: Array = Runes.eligible_ids(mg, Runes.owned_names(mg, _run.party_rune_names())).filter(
		func(x): return not Runes.is_engine_rune(String(x)))
	var plain_rune: Dictionary = Runes.build(String(ids[0])) if not ids.is_empty() else {}
	mg["rune_candidates"] = [[plain_rune]]
	mg["rune_picks_owed"] = 1
	var mp2 := await _to("res://scenes/map.tscn")
	var choose: Button = Gate.bound_button(mp2, "_open_pick_overlay", [1])
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
	var pick_ov: Node = Gate.overlay(current_scene, 60)
	var kb2 := _kit_button(pick_ov, 1) if pick_ov != null else null
	ok(kb2 != null, "§1b: the rune cache's pick carries no kit button")
	if kb2 != null:
		kb2.emit_signal("pressed")
		await Gate.frames(self, 2)
		var pv2: Array = _previews(current_scene)
		ok(pv2.size() == 1 and _texts_joined(pv2[0]).contains("%s 2" % _run.nameplate(mg)),
			"§1b: the cache's preview did not open on the Mage")
		if pv2.size() == 1:
			Gate.press(pv2[0], ["✕  Close"])
			await Gate.frames(self, 2)
	pick_ov = Gate.overlay(current_scene, 60)
	var took2 := Gate.press(pick_ov, [String(plain_rune.get("name", "?"))]) if pick_ov != null else ""
	await Gate.frames(self, 3)
	var held: bool = (mg.get("runes", []) as Array).any(func(r): return String(r.get("name", "")) == String(plain_rune.get("name", "")))
	ok(took2 != "" and held, "§1b: the rune picked after the preview did not land on the Mage (%s)" % took2)
	# (3) THE NEGATIVE ARM — a hero with no runes at all and a starting kit: the preview renders.
	_new_run()
	var bare: Dictionary = _run.party[2]
	bare["engines"] = []
	bare["runes"] = []
	var mp3 := await _to("res://scenes/map.tscn")
	var pv3: Control = _call(mp3, "_open_kit_preview", [2], null)
	await Gate.frames(self, 2)
	var txt3 := _texts_joined(pv3) if pv3 != null else ""
	ok(pv3 != null, "§1b: the map has no kit preview to open")
	var kit3: Array = _run.opening_kit_names(bare)
	ok(not kit3.is_empty() and kit3.all(func(n): return txt3.contains(String(n))) and txt3.contains("None yet"),
		"§1b: the bare hero's preview did not render his kit and say he holds no runes:\n%s" % txt3)
	ok(not txt3.contains("✦"), "§1b: the bare hero's preview marks a held rune he does not have")
	if pv3 != null:
		pv3.close_preview()
	await process_frame
	# (4) THE PEDDLER — the purse is the party's, so the preview walks all four.
	_new_run()
	_run.gold = 1000
	var shop := await _to("res://scenes/shop.tscn")
	var kb4 := _kit_button(shop, -1)
	ok(kb4 != null, "§1b: the Peddler carries no kit button")
	if kb4 != null:
		kb4.emit_signal("pressed")
		await Gate.frames(self, 2)
	var pv4: Array = _previews(current_scene)
	ok(pv4.size() == 1, "§1b: the Peddler's button opened %d previews" % pv4.size())
	if pv4.size() == 1:
		var seen: Array = []
		for step in 5:
			if step > 0:
				Gate.press(pv4[0], ["Next ▶"])
				await process_frame
			var title := ""
			for t in Gate.texts(pv4[0]):
				if String(t).ends_with("— the kit"):
					title = String(t)
			seen.append(title)
		var want: Array = []
		for i in _run.party.size():
			want.append("%s %d — the kit" % [_run.nameplate(_run.party[i]), i + 1])
		want.append(want[0])
		ok(seen == want, "§1b: the Peddler's preview walked %s, not all four and back to the first" % [seen])
		Gate.press(pv4[0], ["◀ Previous"])
		await process_frame
		ok(Gate.has_text(pv4[0], want[3]), "§1b: Previous from the first hero does not reach the fourth")
		Gate.press(pv4[0], ["✕  Close"])
		await Gate.frames(self, 2)
	var gold0: int = _run.gold
	var bought := Gate.press(current_scene, ["Buy"])
	await Gate.frames(self, 2)
	ok(_previews(current_scene).is_empty() and bought != "" and _run.gold < gold0,
		"§1b: after the Peddler's preview closed a purchase did not land (pressed `%s`, gold %d → %d)" % [bought, gold0, _run.gold])


# ── §3 — THE TOAST NAMES THE PET ───────────────────────────────────────────

func _toast_text(screen: Node) -> String:
	var out := ""
	for c in screen.get_children():
		if c is Label and (c as Label).has_meta("toast") and not c.is_queued_for_deletion():
			out = (c as Label).text
	return out


func _s3_the_toast() -> void:
	print("\n§3 — a core rune that dismisses the pet says which card leaves the kit")
	for arm in [["the Sharpshooter's core", Classes.PET_DISMISSERS[0], true], ["an ordinary core", "trapper", false]]:
		_new_run({"hunter": "pack"})
		var h: Dictionary = _run.party[3]
		ok(_run.opening_kit_names(h).has(Classes.PET_CARD), "§3 (%s): the Hunter on Pack Bond fields no pet" % arm[0])
		var core: Dictionary = Runes.build(Runes.engine_rune_id(String(arm[1])))
		h["rune_candidates"] = [[core]]
		h["rune_picks_owed"] = 1
		var mp := await _to("res://scenes/map.tscn")
		var choose: Button = Gate.bound_button(mp, "_open_pick_overlay", [3])
		if choose != null:
			choose.emit_signal("pressed")
			await process_frame
		var ov: Node = Gate.overlay(current_scene, 60)
		var took := Gate.press(ov, [String(core.get("name", "?"))]) if ov != null else ""
		await process_frame
		var toast := _toast_text(current_scene)
		ok(took != "" and toast.contains("waits with the"), "§3 (%s): the pick put up no waiting toast (`%s`)" % [arm[0], toast])
		if arm[2]:
			ok(toast.contains(Classes.PET_CARD), "§3 (%s): the toast does not name %s: %s" % [arm[0], Classes.PET_CARD, toast])
			var drop_line := String(current_scene.drop_toast_text({"rune": core, "where": "held", "hero": 3}))
			ok(drop_line.contains(Classes.PET_CARD), "§3 (%s): a dropped one's toast does not name the pet: %s" % [arm[0], drop_line])
		else:
			ok(not toast.contains(Classes.PET_CARD), "§3 (%s): an ordinary core's toast names the pet: %s" % [arm[0], toast])
		print("  %s → %s" % [arm[0], toast])


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
