# BATCH IC — THE SILENCED FIGURE.
#
#   §1a THE VOW IS LIVE: Vow of Silence is a Cleric's rune that nothing retired, refused or gated, in every
#       Cleric lineage's ordinary pool at a fresh run and offered at all four doors (the fight's drop, the
#       elite's cache, the Peddler, the event verb); held through the one door, worn, and its payload is on
#       the Cleric when the fight spawns.
#   §1b THE ONE QUESTION: `_resolve` asks `_vow_silences` once a strike, above the computation, and the one
#       branch that zeroes a refused blow stands above the first reader; the ground's reflect asks for itself.
#   §1c THE FIVE READERS, EACH DRIVEN VOWED AND UNVOWED ON ONE BOARD — and the unvowed arm reads the figure
#       that landed, exactly:
#       a  the strike's log line, its float and its credit: vowed, the line names the vow and its Break and
#          carries no figure, SILENT floats alone, nothing is booked; unvowed, the landed figure everywhere;
#       b  `total_dealt`, THE LONGEST CASE: one vowed blow that would have paid the card's lifesteal, the
#          rune's lifesteal, Siphon and Mirrorbound's recoil at once pays none of them, and recoils the floor;
#       c  the Ruin leech: a vowed Occultist striking a Ruined raider drinks nothing;
#       d  the tick labels: a tick under his frame, and his ground's reflect under an enemy's swing, float
#          SILENT alone — the reflect asks under its own frame, not the swing's;
#       e  beyond IA's five: Aegis Reversal's bonus is not printed as landing; Anointing's Ruin still rides a
#          silenced hit (it reached its body); Umbral Sigil echoes nothing off a blow that landed nothing.
#   §1d THE VOW'S PRICE, PRINTED: what it gives, what it costs, and what the refused blows used to pay.
#   §2  THE DOOR CALLS IC REPAIRS — five of the eight its partition left open, each driven vowed and unvowed:
#       Suffering heals nothing off a blow that landed nothing; Requiem, Reprisal, a Ruin detonation and
#       Penance's mirror book, float and print what landed. Each asks under its own frame, before its door.
#   §3a ◆ MEANS A DECISION WAITS (IC §0.4): the map card's held upgrades read ↑N, a pick ◆ N kind, a held
#       rune ✦ N — a holding alone, a pick alone, both at once and beside ✦, each reading as itself; the
#       corner's text fits its box, and the word is measured.
#   §3b THE ARRIVAL'S TAIL WHOLE: a swap offer that finds room, then the full holding's panel, then nothing.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** Two of the four figures `total_dealt` paid have no live writer
# — no card carries `lifesteal`, and nothing writes `siphon_ranks` — so §1c(b) sets both by hand on the
# vowed hero, the shape `test_batch_at` uses for Siphon; the rune's lifesteal is the retired Vampiric Rune,
# worn through the spawn as a saved run can wear it; Mirrorbound is the run's own bargain, seated before
# the fight. Whether the vow is still worth wearing is the designer's (§1d prints, asserts no price).
# `Run` is fetched off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ic.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ic_profile.json"
const SCRATCH_RELICS := "user://ic_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SPECS_DV := ["warden", "pyromancer", "inquisitor", "mystic"]
const SPECS_OC := ["warden", "pyromancer", "occultist", "mystic"]
const SEED := 20261012
const VOW := "vow_of_silence"
const DRAWS := 600
const ENC := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const SILENT := "SILENT"

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _floats := {}
var _vow_name := ""


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IC — THE SILENCED FIGURE")
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
	_vow_name = String(Runes.config(VOW).get("name", ""))
	_s1a_the_vow_is_live()
	await _s1a_worn_in_a_fight()
	_s1b_one_question()
	await _s1c_a_the_strike()
	await _s1c_b_the_longest()
	await _s1c_c_the_ruin_leech()
	await _s1c_d_the_ticks()
	await _s1c_e_beyond_the_five()
	await _s1d_the_price()
	await _s2_the_door_calls()
	await _s3a_the_corner()
	await _s3b_the_tail()
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


func _worn(vowed: bool, extra: Array = []) -> Array:
	var out: Array = []
	for id in extra:
		out.append(_rune(String(id)))
	if vowed:
		out.append(_rune(VOW))
	return out


func _board(specs: Array, over: Dictionary) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


# The same party, entered the way the map's node press enters a fight, under the run's own bargain:
# `Gate.spawn` starts a new run, which clears `pending_modifier`, so a modifier is seated here.
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


func _melee(scene: Node, skip: Array = []) -> BattleUnit:
	for e in scene.get("enemies"):
		if not (e as BattleUnit).dead and not (e as BattleUnit).is_ranged and not skip.has(e):
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


# The floating texts a unit puts up from here on: `float_text` adds each as a Label at z 10.
func _watch(u: BattleUnit) -> void:
	_floats[u] = []
	u.child_entered_tree.connect(func(n: Node):
		if n is Label and (n as Label).z_index == 10 and _floats.has(u):
			(_floats[u] as Array).append(String((n as Label).text)))


func _floated(u: BattleUnit) -> Array:
	return (_floats.get(u, []) as Array).duplicate()


# Everything the recap's ledger has booked to `h`, summed (`_run_dealt`, BL §2).
func _booked(scene: Node, h: BattleUnit) -> float:
	var t := 0.0
	var mine: Dictionary = (scene.get("_run_dealt") as Dictionary).get(h.unit_name, {})
	for k in mine:
		t += float(mine[k])
	return t


# ── §1a — THE VOW IS LIVE ───────────────────────────────────────────────────

func _s1a_the_vow_is_live() -> void:
	print("\n§1a — Vow of Silence can be put on a Cleric by a run played forward")
	var cfg: Dictionary = Runes.config(VOW)
	ok(String(cfg.get("scope", "")) == "class:cleric" and String(cfg.get("retired", "")) == ""
		and not Runes.is_refused(cfg) and Runes.engine_read(VOW) == ""
		and String(cfg.get("requires_ability", "")) == "" and not Runes.is_engine_rune(VOW),
		"§1a: the entry is not a live, ungated Cleric rune (scope %s, retired '%s', refused %s, engine '%s', requires '%s')" % [
			cfg.get("scope", ""), cfg.get("retired", ""), Runes.is_refused(cfg), Runes.engine_read(VOW),
			cfg.get("requires_ability", "")])
	ok(float((cfg.get("payload", {}) as Dictionary).get("stat", {}).get("rune_vow_of_silence", 0.0)) > 0.0,
		"§1a: the vow's payload writes no `rune_vow_of_silence` — the gate's field would have no writer")
	for spec in Classes.SPEC_IDS["cleric"]:
		_run.sim_run = false
		_run.new_run(SEATS, [], "standard")
		for i in _run.party.size():
			var key := String(_run.party[i]["key"])
			var sp: String = String(spec) if key == "cleric" else String(Classes.SPEC_IDS[key][0])
			_run.party[i]["spec"] = sp
			_run.party[i]["engines"] = Runes.engine_pouch_for_spec(sp)
			_run.party[i]["awakened"] = true
		_run.specs_chosen = true
		_run.active = true
		var c: Dictionary = _run.party[2]
		var pool: Array = Runes.eligible_ids(c, Runes.owned_names(c, _run.party_rune_names()))
		ok(pool.has(VOW), "§1a (%s): the vow is not in a fresh Cleric's pool" % spec)
		var hits := {"the drop": 0, "the cache": 0, "the Peddler": 0, "the event verb": 0}
		seed(SEED)
		for k in DRAWS:
			if String(_run.roll_fight_drop().get("id", "")) == VOW:
				hits["the drop"] += 1
			if (_run.roll_rune_candidates(c) as Array).any(func(r): return String(r.get("id", "")) == VOW):
				hits["the cache"] += 1
			if String(_run.peddler_rune(c).get("id", "")) == VOW:
				hits["the Peddler"] += 1
			if String(_run.grant_rune(c).get("id", "")) == VOW:
				hits["the event verb"] += 1
		for door in hits:
			ok(int(hits[door]) > 0, "§1a (%s): %s never offered the vow in %d draws" % [spec, door, DRAWS])
		print("    %-10s pool %2d; offered in %d draws: drop %d, cache %d, Peddler %d, event %d" % [
			spec, pool.size(), DRAWS, hits["the drop"], hits["the cache"], hits["the Peddler"], hits["the event verb"]])


func _s1a_worn_in_a_fight() -> void:
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
	var c: Dictionary = _run.party[2]
	var where: String = _run.hold_rune(c, Runes.build(VOW))
	var at := -1
	for k in (c.get("runes", []) as Array).size():
		if String(c["runes"][k].get("id", "")) == VOW:
			at = k
	ok(where == "held" and at >= 0 and not bool(c["runes"][at].get("equipped", true)),
		"§1a: the drop was not held unworn on the Cleric through the one door ('%s')" % where)
	ok(at >= 0 and _run.toggle_rune(c, at) and bool(c["runes"][at].get("equipped", false)),
		"§1a: the held vow could not be worn from his holding")
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, ENC.duplicate(true))
	Engine.time_scale = 50.0
	await Gate.frames(self, 90)
	var s: Node = current_scene
	var cu: BattleUnit = _hero(s, "cleric") if s != null else null
	ok(cu != null and is_equal_approx(float(cu.rune_vow_of_silence), 0.5),
		"§1a: the worn vow is not on the Cleric when the fight spawns (%s)" % [str(cu.rune_vow_of_silence) if cu != null else "no Cleric"])
	print("    held, worn, and in the fight: rune_vow_of_silence %s" % [str(cu.rune_vow_of_silence) if cu != null else "-"])
	await _clear(s)


# ── §1b — THE ONE QUESTION ──────────────────────────────────────────────────

func _s1b_one_question() -> void:
	print("\n§1b — the vow is asked once a strike, above the computation; one branch zeroes a refused blow")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var a := src.find("\nfunc _resolve(")
	var b := src.find("\nfunc ", a + 10)
	var body := src.substr(a, b - a) if a >= 0 and b > a else ""
	var ask := body.find("var silenced := _vow_silences(strike_target)")
	var comp := body.find("var final := 0 if wall_parry")
	var branch := body.find("var refused := silenced and final > 0")
	var first := body.find("total_dealt += final")
	var leech := body.find("strike_target.has_status(\"ruin\") and not attacker.dead")
	var door := body.find("strike_target.take_hit(final, pr)")
	ok(body.count("_vow_silences(") == 2,
		"§1b: `_resolve` asks the vow %d times — once a strike, and once at the ground's reflect, under its own frame" % body.count("_vow_silences("))
	ok(ask > 0 and comp > ask, "§1b: the strike's question is not asked above the computation")
	ok(branch > comp and first > branch and leech > branch and door > branch,
		"§1b: the one branch does not stand above every reader — the credit, the leech and the door")
	print("    the question at %d, the computation at %d, the branch at %d, `total_dealt` at %d, the door at %d" % [
		ask, comp, branch, first, door])


# ── §1c(a) — THE STRIKE: ITS LINE, ITS FLOAT AND ITS CREDIT ─────────────────

func _s1c_a_the_strike() -> void:
	print("\n§1c(a) — the strike's line, its float and its credit read the blow that landed")
	var r := {}
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_DV, {2: {"runes": _worn(vowed)}})
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if c == null or foe == null:
			ok(false, "§1c(a) (%s): the board seats a Devout and a raider" % tag)
			await _clear(s)
			continue
		ok((float(c.rune_vow_of_silence) > 0.0) == vowed, "§1c(a) (%s): the vow reads %.2f" % [tag, c.rune_vow_of_silence])
		var ab: Ability = c.abilities[0]
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		var p0: int = foe.pressure
		var d0 := _booked(s, c)
		_watch(foe)
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(c, ab, foe, "good")
		var head := "%s: %s on %s — " % [c.unit_name, ab.display_name, foe.unit_name]
		r[vowed] = {"landed": h0 - foe.hp, "bd": foe.pressure - p0, "floats": _floated(foe),
			"line": _line_with(_log_text(s).substr(log0), head), "booked": _booked(s, c) - d0,
			"head": head, "type": ab.dmg_type}
		print("    %-7s landed %d, Break %d, floats %s, booked %s; '%s'" % [tag, r[vowed]["landed"],
			r[vowed]["bd"], r[vowed]["floats"], r[vowed]["booked"], r[vowed]["line"]])
		await _clear(s)
	if r.size() < 2:
		return
	var v: Dictionary = r[true]
	var u: Dictionary = r[false]
	ok(int(v["landed"]) == 0, "§1c(a) (vowed): the raider lost %d — the vow let a blow through" % v["landed"])
	ok(int(u["landed"]) > 0, "§1c(a) (no vow): the raider lost nothing — the premise of every comparison")
	ok(int(v["bd"]) > 0 and int(v["bd"]) == int(u["bd"]),
		"§1c(a): the Break read %d vowed against %d — the vow leaves Break damage alone" % [v["bd"], u["bd"]])
	ok(String(v["line"]) == "%ssilenced by %s, +%d BD" % [v["head"], _vow_name, v["bd"]],
		"§1c(a) (vowed): the line does not say the vow refused it and its Break, with no figure: '%s'" % v["line"])
	ok(not String(v["line"]).contains(" dmg"), "§1c(a) (vowed): the line prints a damage figure: '%s'" % v["line"])
	ok(v["floats"] == [SILENT], "§1c(a) (vowed): the raider floated %s — SILENT stands alone" % [v["floats"]])
	ok(is_zero_approx(float(v["booked"])), "§1c(a) (vowed): the recap booked %s to him for a blow that landed nothing" % v["booked"])
	ok(String(u["line"]).begins_with("%s%d %s dmg" % [u["head"], u["landed"], u["type"]])
		and String(u["line"]).ends_with(", +%d BD" % u["bd"]),
		"§1c(a) (no vow): the line is not the %d that landed: '%s'" % [u["landed"], u["line"]])
	ok((u["floats"] as Array).has(str(u["landed"])) and not (u["floats"] as Array).has(SILENT),
		"§1c(a) (no vow): the raider floated %s, not the %d that landed" % [u["floats"], u["landed"]])
	ok(is_equal_approx(float(u["booked"]), float(u["landed"])),
		"§1c(a) (no vow): the recap booked %s against %d landed" % [u["booked"], u["landed"]])


# ── §1c(b) — `total_dealt`: THE LONGEST CASE ────────────────────────────────

func _s1c_b_the_longest() -> void:
	print("\n§1c(b) — one blow that would have paid the card's lifesteal, the rune's, Siphon and recoil at once")
	const LS := 0.5
	const SIPHON := 10
	var r := {}
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board_under(SPECS_DV, {2: {"runes": _worn(vowed, ["vampiric"])}}, "mirrorbound")
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if c == null or foe == null:
			ok(false, "§1c(b) (%s): the board seats a Devout and a raider" % tag)
			await _clear(s)
			continue
		# THE PREMISE, SEATED THROUGH THE SPAWN: the retired Vampiric Rune and the run's Mirrorbound.
		ok(is_equal_approx(float(c.rune_lifesteal), 0.1) and is_equal_approx(float(c.mod_recoil), 0.25)
			and (float(c.rune_vow_of_silence) > 0.0) == vowed,
			"§1c(b) (%s): the spawn did not seat the rune's lifesteal, Mirrorbound's recoil and the vow (%.2f, %.2f, %.2f)" % [
				tag, c.rune_lifesteal, c.mod_recoil, c.rune_vow_of_silence])
		# THE TWO WITH NO WRITER, BY HAND (this file's header says why).
		var ab: Ability = c.abilities[0]
		ab.lifesteal = LS
		c.siphon_ranks = SIPHON
		c.resource = 20
		c.hp = int(c.max_hp / 2)
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(c, ab, foe, "good")
		var tail := _log_text(s).substr(log0)
		r[vowed] = {"landed": h0 - foe.hp,
			"leech": _line_with(tail, "%s leeches" % c.unit_name),
			"drink": _line_with(tail, "Rune: %s drinks" % c.unit_name),
			"siphon": _line_with(tail, "Siphon — %s draws" % c.unit_name),
			"recoil": _line_with(tail, "%s recoils for" % c.unit_name)}
		print("    %-7s landed %d; %s | %s | %s | %s" % [tag, r[vowed]["landed"], r[vowed]["leech"],
			r[vowed]["drink"], r[vowed]["siphon"], r[vowed]["recoil"]])
		await _clear(s)
	_run.pending_modifier = ""
	if r.size() < 2:
		return
	var v: Dictionary = r[true]
	var u: Dictionary = r[false]
	var l := int(u["landed"])
	ok(l > 0 and int(v["landed"]) == 0, "§1c(b): the premise — %d landed unvowed and %d vowed" % [l, v["landed"]])
	ok(String(u["leech"]).contains("leeches %d HP" % int(l * LS))
		and String(u["drink"]).contains("drinks %d HP" % maxi(int(l * 0.1), 1))
		and String(u["siphon"]).contains("draws %d Mana" % maxi(int(round(l * 0.01 * SIPHON)), 1))
		and String(u["recoil"]).contains("recoils for %d" % maxi(int(round(l * 0.25)), 1)),
		"§1c(b) (no vow): the four did not pay off the %d that landed: %s / %s / %s / %s" % [
			l, u["leech"], u["drink"], u["siphon"], u["recoil"]])
	ok(String(v["leech"]) == "", "§1c(b) (vowed): the card's lifesteal paid off a refused blow: '%s'" % v["leech"])
	ok(String(v["drink"]) == "", "§1c(b) (vowed): the rune's lifesteal paid off a refused blow: '%s'" % v["drink"])
	ok(String(v["siphon"]) == "", "§1c(b) (vowed): Siphon paid off a refused blow: '%s'" % v["siphon"])
	ok(String(v["recoil"]).ends_with("recoils for 1"),
		"§1c(b) (vowed): the recoil is not the floor a cast that dealt nothing pays: '%s'" % v["recoil"])


# ── §1c(c) — THE RUIN LEECH ─────────────────────────────────────────────────

func _s1c_c_the_ruin_leech() -> void:
	print("\n§1c(c) — a vowed Occultist striking a Ruined raider drinks nothing")
	var r := {}
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_OC, {2: {"runes": _worn(vowed)}})
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if c == null or foe == null or not c.has_engine("old_gods"):
			ok(false, "§1c(c) (%s): the board seats an Occultist holding the Old Gods and a raider" % tag)
			await _clear(s)
			continue
		s._gain_ruin(foe, 3)
		ok(foe.status_stacks("ruin") == 3, "§1c(c) (%s): the premise — the raider carries %d Ruin, not 3" % [tag, foe.status_stacks("ruin")])
		c.hp = int(c.max_hp / 2)
		var c0: int = c.hp
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		_watch(c)
		seed(SEED)
		await s._resolve(c, c.abilities[0], foe, "good")
		r[vowed] = {"landed": h0 - foe.hp, "drank": c.hp - c0,
			"floats": _floated(c).filter(func(t): return String(t).begins_with("+"))}
		print("    %-7s landed %d; the Occultist drank %d (%s)" % [tag, r[vowed]["landed"], r[vowed]["drank"], r[vowed]["floats"]])
		await _clear(s)
	if r.size() < 2:
		return
	ok(int(r[false]["landed"]) > 0 and int(r[false]["drank"]) > 0 and not (r[false]["floats"] as Array).is_empty(),
		"§1c(c) (no vow): the Ruin leech did not pay off the %d that landed (drank %d)" % [r[false]["landed"], r[false]["drank"]])
	ok(int(r[true]["landed"]) == 0 and int(r[true]["drank"]) == 0 and (r[true]["floats"] as Array).is_empty(),
		"§1c(c) (vowed): the Ruin leech drank %d off a blow that landed %d (%s)" % [r[true]["drank"], r[true]["landed"], r[true]["floats"]])


# ── §1c(d) — THE TICK LABELS ────────────────────────────────────────────────

func _s1c_d_the_ticks() -> void:
	print("\n§1c(d) — a tick the vow refuses floats SILENT alone; the reflect asks under its own frame")
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_DV, {2: {"runes": _worn(vowed)}})
		var c := _hero(s, "cleric")
		var w := _hero(s, "warrior")
		var foe := _melee(s)
		var e1 := _melee(s, [foe])
		if [c, w, foe, e1].any(func(x): return x == null):
			ok(false, "§1c(d) (%s): the board seats a Devout, a Warden and two raiders" % tag)
			await _clear(s)
			continue
		# A tick his frame credits.
		e1.hp = e1.max_hp
		var t0: int = e1.hp
		_watch(e1)
		var was: Array = [s.get("_dmg_src"), String(s.get("_dmg_label")), String(s.get("_dmg_src_name"))]
		s._dmg_frame(c, "Poison", c.unit_name)
		e1.take_tick_damage(12, "-12 Poison", Color.WHITE)
		s._dmg_frame(was[0], was[1], was[2])
		var tick_floats := _floated(e1)
		if vowed:
			ok(t0 - e1.hp == 0 and tick_floats == [SILENT],
				"§1c(d) (vowed): a tick his frame credits took %d and floated %s — SILENT stands alone" % [t0 - e1.hp, tick_floats])
		else:
			ok(t0 - e1.hp == 12 and tick_floats == ["-12 Poison"],
				"§1c(d) (no vow): the tick took %d and floated %s, not its 12 and its label" % [t0 - e1.hp, tick_floats])
		# His ground under a raider's swing: the swing is the raider's, the reflect is his.
		s._apply_status(w, "cons_ground", 3, 0, 0, c)
		foe.hp = foe.max_hp
		var f0: int = foe.hp
		var w0: int = w.hp
		_watch(foe)
		seed(SEED)
		await s._resolve(foe, foe.abilities[0], w, "good")
		var lost: int = f0 - foe.hp
		var rf := _floated(foe)
		var refl: Array = rf.filter(func(t): return String(t).ends_with(" Reflect"))
		ok(w.hp < w0, "§1c(d) (%s): the premise — the raider's Slash did not land on the Warden" % tag)
		if vowed:
			ok(lost == 0 and refl.is_empty() and rf.has(SILENT),
				"§1c(d) (vowed): the reflect took %d and floated %s — SILENT stands alone" % [lost, rf])
		else:
			ok(lost > 0 and refl == ["-%d Reflect" % lost] and not rf.has(SILENT),
				"§1c(d) (no vow): the reflect floated %s, not the %d that landed" % [rf, lost])
		print("    %-7s the tick floated %s; the reflect took %d and floated %s" % [tag, tick_floats, lost, rf])
		await _clear(s)


# ── §1c(e) — BEYOND THE FIVE ────────────────────────────────────────────────

func _s1c_e_beyond_the_five() -> void:
	print("\n§1c(e) — Aegis Reversal's line, Anointing's mark and Umbral Sigil's echo")
	# AEGIS REVERSAL: his own shield turned outward, spent by his next blow.
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_DV, {2: {"runes": _worn(vowed),
			"bm_abilities": ["Aegis Reversal"], "bm_equipped": ["Aegis Reversal"]}})
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		var ds: Ability = _ability(c, "Divine Shield") if c != null else null
		var ar: Ability = _ability(c, "Aegis Reversal") if c != null else null
		if [c, foe, ds, ar].any(func(x): return x == null):
			ok(false, "§1c(e) Aegis (%s): the Devout holds Divine Shield and Aegis Reversal, and a raider stands" % tag)
			await _clear(s)
			continue
		await s._resolve(c, ds, c, "good")
		await s._resolve(c, ar, c, "good")
		var bonus: int = int(c.aegis_bonus)
		ok(bonus > 0, "§1c(e) Aegis (%s): the premise — his shield was not turned into a bonus" % tag)
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(c, c.abilities[0], foe, "good")
		var line := _line_with(_log_text(s).substr(log0), "Aegis Reversal:")
		var lost: int = h0 - foe.hp
		if vowed:
			ok(lost == 0 and line == "→ Aegis Reversal: the unspent shield is spent, and %s silences it" % _vow_name,
				"§1c(e) Aegis (vowed): the line prints a bonus that never landed: '%s' (lost %d)" % [line, lost])
		else:
			ok(line == "→ Aegis Reversal: the unspent shield lands as %d bonus damage" % bonus and lost >= bonus,
				"§1c(e) Aegis (no vow): the line is not the %d that lands ('%s', lost %d)" % [bonus, line, lost])
		ok(int(c.aegis_bonus) == 0, "§1c(e) Aegis (%s): the bonus was not spent by the blow" % tag)
		print("    Aegis %-7s bonus %d; lost %d; '%s'" % [tag, bonus, lost, line])
		await _clear(s)
	# ANOINTING: a hit that reaches its body marks it, silenced or not.
	var marks := {}
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_OC, {2: {"runes": _worn(vowed),
			"bm_abilities": ["Anointing"], "bm_equipped": ["Anointing"]}})
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		var an: Ability = _ability(c, "Anointing") if c != null else null
		if [c, foe, an].any(func(x): return x == null):
			ok(false, "§1c(e) Anointing (%s): the Occultist holds Anointing and a raider stands" % tag)
			await _clear(s)
			continue
		await s._resolve(c, an, c, "good")
		ok(c.has_status("anointed"), "§1c(e) Anointing (%s): the premise — the Occultist is not anointed" % tag)
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		var r0: int = foe.status_stacks("ruin")
		seed(SEED)
		await s._resolve(c, c.abilities[0], foe, "good")
		marks[vowed] = [foe.status_stacks("ruin") - r0, h0 - foe.hp]
		print("    Anointing %-7s Ruin +%d; lost %d" % [tag, marks[vowed][0], marks[vowed][1]])
		await _clear(s)
	if marks.size() == 2:
		ok(int(marks[false][0]) > 0 and int(marks[true][0]) == int(marks[false][0]) and int(marks[true][1]) == 0,
			"§1c(e) Anointing: a silenced hit marked %d against %d unvowed — it reached its body and still marks" % [
				marks[true][0], marks[false][0]])
	# UMBRAL SIGIL: half of a strike echoes to the warband — half of what landed.
	for vowed in [true, false]:
		var tag := "vowed" if vowed else "no vow"
		var s: Node = await _board(SPECS_OC, {2: {"runes": _worn(vowed)}})
		var c := _hero(s, "cleric")
		var foe := _melee(s)
		if c == null or foe == null:
			ok(false, "§1c(e) Sigil (%s): the board seats an Occultist and a raider" % tag)
			await _clear(s)
			continue
		s._apply_status(foe, "umbral_sigil", 4, 0, 0, c)
		ok(foe.has_status("umbral_sigil"), "§1c(e) Sigil (%s): the premise — the raider is not branded" % tag)
		var fellows: Array = (s.get("enemies") as Array).filter(func(e): return e != foe and not e.dead)
		var hp0 := {}
		for e in fellows:
			e.hp = e.max_hp
			hp0[e] = e.hp
			_watch(e)
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		var log0 := _log_text(s).length()
		seed(SEED)
		await s._resolve(c, c.abilities[0], foe, "good")
		var lost: int = h0 - foe.hp
		var line := _line_with(_log_text(s).substr(log0), "Umbral Sigil echoes")
		var took: Array = []
		var fl: Array = []
		for e in fellows:
			took.append(int(hp0[e]) - (e as BattleUnit).hp)
			fl.append_array(_floated(e).filter(func(t): return String(t).ends_with(" Sigil")))
		if vowed:
			ok(lost == 0 and took.all(func(x): return int(x) == 0) and fl.is_empty() and line == "",
				"§1c(e) Sigil (vowed): an echo of a blow that landed nothing — took %s, floated %s, '%s'" % [took, fl, line])
		else:
			var echo := maxi(int(round(lost * 0.5)), 1)
			ok(lost > 0 and took.all(func(x): return int(x) == echo) and fl.size() == fellows.size()
				and fl.all(func(t): return String(t) == "-%d Sigil" % echo)
				and line.contains("echoes %d to the warband" % echo),
				"§1c(e) Sigil (no vow): the echo is not half the %d that landed — took %s, floated %s, '%s'" % [lost, took, fl, line])
		print("    Sigil %-7s lost %d; the warband took %s; '%s'" % [tag, lost, took, line])
		await _clear(s)


# ── §1d — THE VOW'S PRICE, PRINTED ──────────────────────────────────────────

func _s1d_the_price() -> void:
	print("\n§1d — what the vow gives and what it costs, per Cleric lineage, on one board (printed, not priced)")
	print("    %-10s %-26s %-26s %s" % ["lineage", "Ministration bare → vowed", "Consecration drip", "his basic lands (bare → vowed)"])
	for spec in Classes.SPEC_IDS["cleric"]:
		var row := {}
		for vowed in [false, true]:
			var specs: Array = SPECS_DV.duplicate()
			specs[2] = spec
			var s: Node = await _board(specs, {2: {"runes": _worn(vowed)}})
			var c := _hero(s, "cleric")
			var w := _hero(s, "warrior")
			var h := _hero(s, "hunter")
			var foe := _melee(s)
			var mn: Ability = _ability(c, "Ministration") if c != null else null
			var cn: Ability = _ability(c, "Consecration") if c != null else null
			if [c, w, h, foe, mn, cn].any(func(x): return x == null):
				ok(false, "§1d (%s): the board seats a Cleric with Ministration and Consecration, a Warden, a Hunter and a raider" % spec)
				await _clear(s)
				continue
			w.hp = int(w.max_hp / 2)
			var w0: int = w.hp
			seed(SEED)
			await s._resolve(c, mn, w, "good")
			await s._resolve(c, cn, c, "good")
			h.hp = int(h.max_hp / 2)
			var hh0: int = h.hp
			s._consecration_tick(h)
			foe.hp = foe.max_hp
			var f0: int = foe.hp
			seed(SEED)
			await s._resolve(c, c.abilities[0], foe, "good")
			row[vowed] = [w.hp - w0, h.hp - hh0, f0 - foe.hp, c.abilities[0].display_name]
			await _clear(s)
		if row.size() == 2:
			ok(int(row[true][0]) > int(row[false][0]) and int(row[true][2]) == 0 and int(row[false][2]) > 0,
				"§1d (%s): the premise — the vow heals more and lands nothing (%s / %s)" % [spec, row[false], row[true]])
			print("    %-10s %-26s %-26s %s %d → %d" % [spec, "%d → %d" % [row[false][0], row[true][0]],
				"%d → %d" % [row[false][1], row[true][1]], row[false][3], row[false][2], row[true][2]])
	# THE RUIN DRAUGHT BY DEPTH: what a vowed Occultist's refused blow drank before IC is exactly what the same
	# seeded blow drinks unvowed (the draught was paid off the figure computed), and what it drinks now is nothing.
	var depth := []
	for stacks in [1, 3, 5, 7, 9]:
		var drank := {}
		for vowed in [false, true]:
			var s: Node = await _board(SPECS_OC, {2: {"runes": _worn(vowed)}})
			var c := _hero(s, "cleric")
			var foe := _melee(s)
			if c == null or foe == null:
				ok(false, "§1d (Ruin %d): the board seats an Occultist and a raider" % stacks)
				await _clear(s)
				continue
			s._gain_ruin(foe, stacks)
			c.hp = int(c.max_hp / 2)
			var c0: int = c.hp
			foe.hp = foe.max_hp
			seed(SEED)
			await s._resolve(c, c.abilities[0], foe, "good")
			drank[vowed] = c.hp - c0
			await _clear(s)
		if drank.size() == 2:
			ok(int(drank[false]) > 0 and int(drank[true]) == 0,
				"§1d (Ruin %d): the draught paid %d unvowed and %d vowed" % [stacks, drank[false], drank[true]])
			depth.append("%d → %d at %d" % [drank[false], drank[true], stacks])
	print("    the Ruin draught off one Smite, before IC → now, by Ruin: %s" % ", ".join(PackedStringArray(depth)))


# ── §2 — THE DOOR CALLS IC REPAIRS ──────────────────────────────────────────

# Everything booked to `h` under one label of the recap's ledger.
func _booked_as(scene: Node, h: BattleUnit, label: String) -> float:
	return float(((scene.get("_run_dealt") as Dictionary).get(h.unit_name, {}) as Dictionary).get(label, 0.0))


func _s2_the_door_calls() -> void:
	print("\n§2 — Suffering, Requiem, Reprisal, a Ruin detonation and Penance's mirror print and pay what landed")
	for site in ["Suffering", "Requiem", "Reprisal", "detonation", "Penance"]:
		var r := {}
		for vowed in [true, false]:
			var tag := "vowed" if vowed else "no vow"
			var specs: Array = SPECS_OC.duplicate()
			var over := {"runes": _worn(vowed)}
			if site == "Reprisal":
				specs[2] = "holy"
			if site in ["Suffering", "Requiem", "Reprisal"]:
				over["bm_abilities"] = [site]
				over["bm_equipped"] = [site]
			var s: Node = await _board(specs, {2: over})
			var c := _hero(s, "cleric")
			var w := _hero(s, "warrior")
			var foe := _melee(s)
			var card: Ability = _ability(c, site) if c != null else null
			if [c, w, foe].any(func(x): return x == null) or (site in ["Suffering", "Requiem", "Reprisal"] and card == null):
				ok(false, "§2 %s (%s): the board seats the Cleric holding it, a Warden and a raider" % [site, tag])
				await _clear(s)
				continue
			foe.hp = foe.max_hp
			c.hp = int(c.max_hp / 2)
			var label: String = site
			match site:
				"Requiem":
					s._gain_ruin(foe, 4)
					ok(foe.status_stacks("ruin") == 4, "§2 Requiem (%s): the premise — the raider carries no Ruin to sing out" % tag)
				"Reprisal":
					w.hp = int(w.max_hp / 2)
					await s._resolve(c, _ability(c, "Ministration"), w, "good")
					ok(c.healing_done_recent() > 0, "§2 Reprisal (%s): the premise — he healed nothing to answer for" % tag)
				"detonation":
					label = String(s.get("STATUS_INFO")["ruin"][0])
					s._gain_ruin(foe, int(s._ruin_threshold()))
					ok(foe.has_status("ruin_primed"), "§2 detonation (%s): the premise — the mark is not primed" % tag)
				"Penance":
					s._apply_status(foe, "penance", 4, 50, 0, c)
					ok(foe.has_status("penance"), "§2 Penance (%s): the premise — the raider carries no Penance" % tag)
			var h0: int = foe.hp
			var c0: int = c.hp
			var w0: int = w.hp
			var b0 := _booked_as(s, c, label)
			_watch(foe)
			var log0 := _log_text(s).length()
			seed(SEED)
			match site:
				"detonation":
					s._detonate_ruin(foe)
				"Penance":
					await s._resolve(foe, foe.abilities[0], w, "good")
				_:
					await s._resolve(c, card, foe, "good")
			var tail := _log_text(s).substr(log0)
			var needle: String = {"Suffering": "Suffering", "Requiem": "Requiem —", "Reprisal": "Reprisal —",
				"detonation": "Ruin detonates on", "Penance": "Penance: %s pays" % foe.unit_name}[site]
			r[vowed] = {"lost": h0 - foe.hp, "healed": c.hp - c0, "booked": _booked_as(s, c, label) - b0,
				"floats": _floated(foe), "line": _line_with(tail, needle), "struck": w.hp < w0}
			print("    %-10s %-7s lost %d, booked %s, floats %s; '%s'" % [site, tag, r[vowed]["lost"],
				r[vowed]["booked"], r[vowed]["floats"], r[vowed]["line"]])
			await _clear(s)
		if r.size() < 2:
			continue
		var v: Dictionary = r[true]
		var u: Dictionary = r[false]
		var l := int(u["lost"])
		if site == "Penance":
			ok(bool(v["struck"]) and bool(u["struck"]), "§2 Penance: the premise — the raider's blow did not land on the Warden")
		ok(l > 0, "§2 %s (no vow): the raider lost nothing — the premise of the comparison" % site)
		ok(int(v["lost"]) == 0, "§2 %s (vowed): the raider lost %d — the vow let it through" % [site, v["lost"]])
		ok(is_zero_approx(float(v["booked"])) and is_equal_approx(float(u["booked"]), float(l)),
			"§2 %s: booked %s vowed and %s against %d landed unvowed — the credit is what landed" % [site, v["booked"], u["booked"], l])
		ok((v["floats"] as Array).has(SILENT) and not (v["floats"] as Array).any(func(t): return String(t).contains(str(l))),
			"§2 %s (vowed): the raider floated %s — a figure beside SILENT" % [site, v["floats"]])
		ok(String(v["line"]).contains("silenced by %s" % _vow_name) and not String(v["line"]).contains(" %d " % l)
			and not String(v["line"]).contains(" %d shadow" % l),
			"§2 %s (vowed): the line does not say the vow refused it, or prints the figure: '%s'" % [site, v["line"]])
		var want: String = {"Suffering": "— %d damage to %s and" % [l, ""], "Requiem": "consumed for %d shadow" % l,
			"Reprisal": "Reprisal — %d damage" % l, "detonation": "for %d shadow" % l,
			"Penance": "— %d shadow damage" % l}[site]
		if site == "Suffering":
			want = "Suffering — %d damage to " % l
		ok(String(u["line"]).contains(want), "§2 %s (no vow): the line is not the %d that landed: '%s'" % [site, l, u["line"]])
		if site == "Suffering":
			ok(int(v["healed"]) == 0 and int(u["healed"]) > 0,
				"§2 Suffering: healed %d vowed against %d unvowed — the heal is the whole of what landed" % [v["healed"], u["healed"]])


# ── §3a — ◆ MEANS A DECISION WAITS ──────────────────────────────────────────

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


func _modals(mp: Node) -> Array:
	var out: Array = []
	for c in mp.get_children():
		if c is Control and not c.is_queued_for_deletion() \
				and [60, 62, 64, 70, 72, 74].has((c as Control).z_index):
			out.append(c)
	return out


# `n` upgrades held by party seat `i`, bought at the Blacksmith's door (the list the mini-boss pick writes too).
func _hold_upgrades(i: int, n: int) -> int:
	var guard := 0
	while (_run.party[i].get("upgrades", []) as Array).size() < n and guard < 40:
		guard += 1
		for pr in _run.roll_blacksmith_offer():
			if int(pr["member_idx"]) == i:
				_run.gold = int(_run.gold) + int(_run.blacksmith_price())
				_run.buy_blacksmith(pr)
				break
	return (_run.party[i].get("upgrades", []) as Array).size()


func _card_at(mp: Node, y: float) -> int:
	var consts: Dictionary = mp.get_script().get_script_constant_map()
	return int(floor((y - float(consts["CARD_Y"]) + 1.0) / float(consts["CARD_STEP"])))


func _labels(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Label and (c as Label).visible:
			out.append(c)
		_labels(c, out)


func _s3a_the_corner() -> void:
	print("\n§3a — held upgrades read ↑N, a pick ◆ N kind, a held rune ✦ N — each as itself")
	seed(SEED)
	_new_run()
	var p: Array = _run.party
	var held := [_hold_upgrades(0, 3), 0, _hold_upgrades(2, 2), _hold_upgrades(3, 1)]
	_run.award_upgrade_pick(p[1])
	_run.award_upgrade_pick(p[2])
	var hr: Dictionary = Runes.build(String(Runes.eligible_ids(p[3], Runes.owned_names(p[3], _run.party_rune_names())).filter(
		func(id): return not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(Runes.config(String(id))))[0]))
	hr["equipped"] = false
	_run.hold_rune(p[3], hr)
	ok(held == [3, 0, 2, 1] and _run.held_count(p[3]) == 1,
		"§3a: the premise — upgrades held %s (want [3, 0, 2, 1]) and one rune held by the Hunter" % [held])
	var mp := await _to_map()
	for k in 3:
		var ov: Node = Gate.overlay(mp, 60)
		if ov == null:
			break
		Gate.press(ov, ["Not yet"])
		await Gate.frames(self, 3)
	ok(_modals(mp).is_empty(), "§3a: the premise — the two upgrade picks the arrival opened were dismissed")
	var corner := {}
	var corner_lb := {}
	var badge := {}
	var stray: Array = []
	var all_lb: Array = []
	_labels(mp, all_lb)
	for lb in all_lb:
		var t := String((lb as Label).text)
		if String((lb as Label).tooltip_text).begins_with("Ability upgrades"):
			var at := _card_at(mp, ((lb as Label).get_parent() as Control).position.y)
			corner[at] = t
			corner_lb[at] = lb
		elif t.contains("◆"):
			var at2 := _card_at(mp, (lb as Label).position.y)
			badge[at2] = t
			var re := RegEx.create_from_string("^(◆ \\d+ (ability|draft|upgrade|rune)(  )?)+$")
			if re.search(t) == null:
				stray.append(t)
	var choose := {}
	var mark := {}
	var mark_btn := {}
	for i in 4:
		choose[i] = Gate.bound_button(mp, "_open_pick_overlay", [i]) != null
	var btns: Array = []
	Gate.buttons(mp, btns)
	for b in btns:
		if (b as Button).has_meta("held_marker"):
			var at3 := _card_at(mp, (b as Button).position.y)
			mark[at3] = String((b as Button).text)
			mark_btn[at3] = b
	print("    corners %s; badges %s; CHOOSE %s; ✦ %s" % [corner, badge, choose, mark])
	ok(String(corner.get(0, "")) == "↑3" and not badge.has(0) and not bool(choose[0]),
		"§3a: a holding alone did not read ↑3 alone (corner '%s', badge '%s', CHOOSE %s)" % [corner.get(0, ""), badge.get(0, ""), choose[0]])
	ok(not corner.has(1) and String(badge.get(1, "")) == "◆ 1 upgrade" and bool(choose[1]),
		"§3a: a pick alone did not read ◆ 1 upgrade alone (corner '%s', badge '%s')" % [corner.get(1, ""), badge.get(1, "")])
	ok(String(corner.get(2, "")) == "↑2" and String(badge.get(2, "")) == "◆ 1 upgrade" and bool(choose[2]),
		"§3a: a holding and a pick did not each read as itself (corner '%s', badge '%s')" % [corner.get(2, ""), badge.get(2, "")])
	ok(String(corner.get(3, "")) == "↑1" and String(mark.get(3, "")) == "✦ 1",
		"§3a: held upgrades beside a held rune did not read ↑1 and ✦ 1 (corner '%s', ✦ '%s')" % [corner.get(3, ""), mark.get(3, "")])
	ok(stray.is_empty(), "§3a: ◆ marks something on the map that is not a pick waiting: %s" % [stray])
	ok(corner.values().all(func(t): return not String(t).contains("◆") and not String(t).contains("✦")),
		"§3a: a held-upgrade corner borrows a pick's or a rune's glyph: %s" % [corner.values()])
	if corner_lb.has(3) and mark_btn.has(3):
		var cr: Rect2 = (corner_lb[3] as Label).get_global_rect()
		var font: Font = (corner_lb[3] as Label).get_theme_font("font")
		var fs: int = (corner_lb[3] as Label).get_theme_font_size("font_size")
		var txt_w: float = font.get_string_size(String(corner[3]), HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var mr: Rect2 = (mark_btn[3] as Button).get_global_rect()
		var drawn := Rect2(cr.end.x - txt_w, cr.position.y, txt_w, cr.size.y)
		ok(not drawn.intersects(mr), "§3a: the ↑ corner's text (%s) runs into the ✦ mark (%s)" % [drawn, mr])
		var widest: float = font.get_string_size("↑%d" % 12, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var word: float = font.get_string_size("3 upgrades", HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		ok(widest <= cr.size.x, "§3a: a two-figure count (%.0f px) does not fit the %.0f-px corner" % [widest, cr.size.x])
		print("    the corner is %.0f px at font %d: '↑12' %.0f px fits; the word '3 upgrades' %.0f px does not" % [
			cr.size.x, fs, widest, word])
	else:
		ok(false, "§3a: the Hunter's corner or his ✦ mark is not drawn")
	await _clear(mp)


# ── §3b — THE ARRIVAL'S TAIL, WHOLE ─────────────────────────────────────────

func _s3b_the_tail() -> void:
	print("\n§3b — a swap offer that finds room, then the full holding's panel, then nothing")
	_new_run()
	var m: Dictionary = _run.party[1]
	_run.items = {"health": 1}
	var room: bool = not _run.needs_slot("bomb")
	var ids: Array = []
	for id in Classes.class_engines("mage"):
		var rid := Runes.engine_rune_id(String(id))
		if not (m.get("engines", []) as Array).any(func(r): return String(r.get("id", "")) == rid):
			ids.append(rid)
	for id2 in Runes.eligible_ids(m, Runes.owned_names(m, _run.party_rune_names())):
		if not Runes.is_engine_rune(String(id2)) and not Runes.is_party_rune(Runes.config(String(id2))):
			ids.append(String(id2))
	var put := 0
	for rid2 in ids:
		if _run.holding_full(m):
			break
		var r: Dictionary = Runes.build(String(rid2))
		r["equipped"] = false
		if _run.hold_rune(m, r) == "held":
			put += 1
	var last: Dictionary = {}
	for rid3 in ids:
		if not _run.party_rune_names().has(Runes.display_name(Runes.config(String(rid3)))):
			last = Runes.build(String(rid3))
			break
	var how := ""
	if not last.is_empty():
		last["equipped"] = false
		how = _run.hold_rune(m, last)
	_run.pending_item_offers = ["bomb"]
	ok(room and _run.holding_full(m) and how == "pending" and _run.pending_rune_drops.size() == 1,
		"§3b: the premise — a pouch with room (%s), the Mage's holding full (%d held) and one rune waiting ('%s')" % [
			room, _run.held_count(m), how])
	var mp := await _to_map()
	await Gate.frames(self, 3)
	var bombs := int(_run.items.get("bomb", 0))
	var panel: Node = Gate.overlay(mp, 74)
	var title := ""
	if panel != null:
		for t in Gate.texts(panel):
			if String(t).contains("HOLDS ALL HE CAN"):
				title = String(t)
	ok(bombs == 1 and _run.pending_item_offers.is_empty(),
		"§3b: the swap offer that found room was not taken (bombs %d, offers %s)" % [bombs, _run.pending_item_offers])
	ok(panel != null and title != "",
		"§3b: after the offer that found room, the full holding's panel did not open — the tail ended at the offer")
	var left := false
	if panel != null:
		var btns: Array = []
		Gate.buttons(panel, btns)
		for b in btns:
			for cn in (b as Button).pressed.get_connections():
				if (cn["callable"] as Callable).get_method() == "_decline_pending_drop" and not left:
					(b as Button).emit_signal("pressed")
					left = true
	await Gate.frames(self, 4)
	ok(left and _modals(mp).is_empty() and _run.pending_rune_drops.is_empty(),
		"§3b: after the full holding was answered something is still open (%d up) or waiting (%d)" % [
			_modals(mp).size(), _run.pending_rune_drops.size()])
	print("    the offer taken (bomb x%d), then '%s', then %d open" % [bombs, title, _modals(mp).size()])
	await _clear(mp)


# ── §9 ──────────────────────────────────────────────────────────────────────

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
