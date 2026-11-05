# BATCH JI — THE WARBAND GETS COOLDOWNS.
#
#   §1a  THE POPULATION, DERIVED FROM THE DATA AND NEVER LISTED: every enemy ability priced against its own enemy's basic
#        attack — a blow by its damage and the Burn or Poison it lays, times the heroes it reaches; a heal by the health it
#        restores — and every one at or past the line carries exactly the figure its multiple names, every other none, and a
#        basic never one (C01, C02). The table prints, every battery.
#   §1b  THE UNIT IS THE ENEMY's OWN TURN: the loop ticks a unit's cooldowns at its own turn's start on all three of its paths
#        and nowhere else, held at source (C03); and a move cast is refused for exactly its cooldown of the unit's own ticks
#        after it, driven by this gate's hand.
#   §1c  THE SELECTION ASKS THE COOLDOWN: at a declaration, a move still cooling when its turn comes is never chosen, a move
#        ready by then is; at re-validation nothing falls back; a support cast the same (C04); and the callers pass the ticks
#        that fall before the move — one at a turn's end, two from a stunned or frozen turn, none at re-validation (C04b–d).
#   §1d  EVERY KIND KEEPS A MOVE: with every move but its basic cooling, every kind still declares its basic (C04, C05).
#   §1e  THE PLATE: a cast lays the chip, each of the enemy's own turns counts it down, and it is gone when the move is back;
#        no hero wears one (C06).
#   §1f  THE TEXTS FOLLOW THE DATA: the master document names the moves that cool as the data gives them, and no figure; the
#        state's record of the eleven states each one's cooldown as the data gives it (R01, the brief's).
#   §2   ENCUMBERED BINDS BOTH SIDES: one branch stamps every unit on the field, so an enemy's cooling move costs two more of
#        its turns and its basic none; the record says so and calls its reading stale (C07).
#   §3   THE BEFORE FIGURE: the record holds the reading the arc's fifth batch starts from, as its kept table holds it (C08).
#   §4   WHAT IS DELIBERATELY NOT DONE: no enemy figure but the cooldown key moved; the deck closed; Encumbered's grade.
#   §5   THE PLAYER'S FILES, as this gate found them.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ji.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE RULE: a move worth 1.4 times its own basic or more takes a cooldown — 2 under 2x, 3 under 3x, 4 past.
const LINE := 1.4
# A DESIGNER's HAND-TUNE OF ONE MOVE, held beside the line ("kind/Move": its cooldown), so §1a reads it as the data's (JI's ruling 2, accepted at JJ §0).
# The Bellow takes a 2 by hand (JJ §0, the designer's): it prices 1.37 against four heroes and 1.71 once a companion stands,
# so on a party with a pet the warband's one big area blow was the only one with no rhythm. The state's record follows it (§1f).
const TUNED := {"behemoth/Wretched Bellow": 2}
const FIGURES := [[2.0, 2], [3.0, 3]]
const TOP := 4
# An area blow reaches the party's four heroes; so does an every-ally heal.
const REACH := 4
# A heal is priced as the health it restores, a share of the body healed (the three arms of `_resolve_special`).
const HEALS := {"healing_wave": 0.25, "wild_growth": 0.20, "totem_pulse": 0.06}
const HEAL_SITES := {"healing_wave": "target.max_hp * 0.25", "wild_growth": "target.max_hp * 0.20",
	"totem_pulse": "tp_a.max_hp * 0.06"}
# The one heal `_enemy_support_action` casts on its caster, so the body healed is its own.
const SELF_HEALS := ["Regenerate"]
# A ward and a cleanse have no exchange rate on the enemy's own data, so they are not priced.
const UNPRICED := ["enemy_shield", "cleanse_allies"]
# The data as it stood before the warband took cooldowns, every `cooldown` key aside: no other figure moved.
# JJ §3 re-pinned it: Healing Wave's words lost *under 40% health* with the policy that read it (the healers heal whenever the
# warband's pool allows and a body is hurt); its 25% and every other figure stand.
const DATA_BEFORE := "6f568b3c749bddbea70d9cbce9d6bb49"
const DECK_CLOSED_AT := 25
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["whelp", "raider", "archer"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://ji_profile.json"
const SCRATCH_RELICS := "user://ji_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const MASTER_NEEDLE := "An enemy's biggest moves wait between uses."
const BOTH_SIDES := "ENCUMBERED BINDS BOTH SIDES"
const STALE := "read on a warband with no cooldowns"
const BEFORE_HEAD := "### THE WARBAND's COOLDOWNS"
const KEPT_TABLE := "res://docs/reports/JI-cooldowns.tsv"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}
var _pop: Array = []   # [kind, ability, figure], derived by §1a


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JI — THE WARBAND GETS COOLDOWNS")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH), "§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	var s: Node = await _board()
	_s1a_the_population(s)
	await _s1b_the_tick(s)
	_s1c_the_selection(s)
	_s1d_every_kind_keeps_a_move(s)
	await _s1e_the_plate(s)
	_s1f_the_texts()
	_s2_encumbered(s)
	_s3_the_before_figure()
	_s4_not_done()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s5_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


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


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves a counter.
func _board() -> Node:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i]))[0])))
	_run.specs_chosen = true
	_run.active = true
	_run.items = {}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


# One foe on the board made a kind for a drive: that kind's kit, at the whole ladder; a full bar; nothing cooling.
func _as_kind(f: BattleUnit, kind: String) -> void:
	var cfg := Enemies.config(kind)
	f.abilities = cfg["abilities"]
	f.max_resource = 100
	f.resource = 100
	f.resource_name = "Rage"
	f.cooldowns = {}
	f.hp = f.max_hp
	f.intent = {}
	for st in ["charging", "mocked", "heads_down", "psychosis", "hysteria", "bewitch"]:
		f.remove_status(st)


func _ab(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _args(s: Node, method: String) -> int:
	for m in (s.get_script() as Script).get_script_method_list():
		if String(m["name"]) == method:
			return (m["args"] as Array).size()
	return -1


# The data's own `cooldown` on a kind's move, as `data/enemies.json` writes it.
func _data_cd(kind: String, name: String) -> int:
	for a in (Enemies._load()[kind] as Dictionary).get("abilities", []):
		if String(a.get("display_name", "")) == name:
			return int(a.get("cooldown", 0))
	return -1


# ── §1a — THE POPULATION, DERIVED ─────────────────────────────────────────────

func _blow(a: Dictionary, dot: Dictionary) -> float:
	var st: Dictionary = a.get("applies_status", {})
	# A POISON SKIPS THE TURN IT LANDS (`_dot_pass`, its `fresh` flag), so it ticks one fewer than its turns; a Burn ticks every one.
	var ticks := maxf(0.0, float(st.get("turns", 0)) - (1.0 if String(st.get("id", "")) == "poison" else 0.0))
	var tick := float(dot.get(String(st.get("id", "")), 0)) * ticks * float(a.get("status_chance", 1.0))
	return (float(a.get("damage", 0)) + tick) * (REACH if bool(a.get("aoe", false)) else 1)


func _figure(m: float) -> int:
	if m < LINE:
		return 0
	for band in FIGURES:
		if m < float(band[0]):
			return int(band[1])
	return TOP


func _s1a_the_population(s: Node) -> void:
	print("\n§1a — the population, derived from the data: each move against its own basic")
	var data: Dictionary = Enemies._load()
	var dot: Dictionary = (s.get_script() as Script).get_script_constant_map().get("DOT_STATUSES", {})
	ok(dot.has("burn") and dot.has("poison"), "§1a: the damage a Burn and a Poison tick could not be read off the battle")
	var dot_pass := Gate.fn_body("scripts/battle.gd", "_dot_pass", _cache)
	ok(dot_pass.contains("if pstatus.get(\"fresh\", false):"), "§1a: a Poison no longer skips the turn it lands — the blow's price is stale")
	# JJ §3 LIFTED THE THREE FIGURES OUT OF `_resolve_special`'s ARMS, UNCHANGED, INTO THE ONE DOOR THE ARMS AND THE POOL's PRICE
	# BOTH READ — so the price this arm pins is read where it is decided now.
	var special := Gate.fn_body("scripts/battle.gd", "_warband_heal_figure", _cache)
	for sp in HEAL_SITES:
		ok(special.contains(String(HEAL_SITES[sp])), "§1a: the %s arm no longer heals `%s` — the heal's price is stale" % [sp, HEAL_SITES[sp]])
	var bodies: Array = []
	for k in data:
		if not bool((data[k] as Dictionary).get("is_boss", false)):
			bodies.append(float(data[k]["max_hp"]))
	bodies.sort()
	var n := bodies.size()
	var body: float = (bodies[n / 2 - 1] + bodies[n / 2]) / 2.0 if n % 2 == 0 else bodies[n / 2]
	var rows: Array = []
	var wrong: Array = []
	var basics_cooling: Array = []
	var total := 0
	var spends := 0
	var hexes := 0
	for kind in data:
		var k: Dictionary = data[kind]
		var basic: Dictionary = {}
		for a in k["abilities"]:
			if int(a.get("damage", 0)) > 0 and int(a.get("cost", 0)) == 0:
				basic = a
				break
		ok(not basic.is_empty(), "§1a: %s has no basic attack — no move is free and damaging" % kind)
		if basic.is_empty():
			continue
		var bp := _blow(basic, dot)
		for a in k["abilities"]:
			# JK §2 — A MALICE SPEND IS PRICED BY `check_jk` §2, on this line read out of this file: its worth on the reference board
			# against this kind's basic. It is counted here and walked there, so this walk stays the fifty it was written for.
			if String(a.get("special", "")).begins_with("malice_"):
				spends += 1
				continue
			# JL §2 — A HEX IS PRICED BY `check_jl` §2, on this line read out of this file: its worth by what it denies, off JA's
			# census, against this kind's basic. It deals nothing, so this walk would price it at nothing; it is counted and walked there.
			if String(a.get("special", "")) == "warband_hex":
				hexes += 1
				continue
			total += 1
			var name := String(a["display_name"])
			var sp := String(a.get("special", ""))
			var m := -1.0
			var how := ""
			if a == basic:
				m = 1.0
				how = "its basic"
				if int(a.get("cooldown", 0)) > 0:
					basics_cooling.append("%s's %s" % [kind, name])
			elif UNPRICED.has(sp):
				how = "not priced (%s)" % sp
			elif HEALS.has(sp):
				var b: float = float(k["max_hp"]) if SELF_HEALS.has(name) else body
				var hp: float = float(HEALS[sp]) * b * (REACH if sp == "totem_pulse" else 1)
				m = hp / (bp * float(k["attack"]) / 100.0)
				how = "heals %.1f against a basic of %.1f" % [hp, bp * float(k["attack"]) / 100.0]
			else:
				m = _blow(a, dot) / bp
				how = "%.1f against a basic of %.1f" % [_blow(a, dot), bp]
			var want := 0 if (m < 0.0 or a == basic) else _figure(m)
			if TUNED.has("%s/%s" % [kind, name]):
				want = int(TUNED["%s/%s" % [kind, name]])
			var have := int(a.get("cooldown", 0))
			rows.append([m, kind, name, want, have, how])
			if want > 0:
				_pop.append([String(kind), name, want])
			if want != have:
				wrong.append("%s's %s carries %d, the rule gives %d (%s)" % [kind, name, have, want, how])
	rows.sort_custom(func(x, y): return float(x[0]) > float(y[0]))
	for r in rows:
		if float(r[0]) >= 1.0 and String(r[5]) != "its basic" or int(r[4]) > 0:
			print("    %5.2f  %-16s %-18s rule %d, data %d  — %s" % [float(r[0]), r[1], r[2], int(r[3]), int(r[4]), r[5]])
	print("    CHECKED %d of %d moves in %d kinds; the median composable body %.1f; %d take a cooldown" % [rows.size(), total, data.size(), body, _pop.size()])
	print("    and %d Malice spends beside them, priced by check_jk §2, and %d hexes, priced by check_jl §2" % [spends, hexes])
	ok(rows.size() == total and total >= 50, "§1a: the walk priced %d of %d moves" % [rows.size(), total])
	ok(wrong.is_empty(), "§1a: the data and the rule disagree: %s" % [wrong])
	ok(basics_cooling.is_empty(), "§1a: a basic attack carries a cooldown: %s" % [basics_cooling])
	ok(_pop.size() >= 1, "§1a: the rule names no move at all — the population is empty")


# ── §1b — THE ENEMY's OWN TURN ────────────────────────────────────────────────

func _s1b_the_tick(s: Node) -> void:
	print("\n§1b — a cooldown ticks in the enemy's own turns, and a move is back after exactly its cooldown of them")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(src.count("tick_cooldowns()") == 3, "§1b: battle.gd ticks a unit's cooldowns at %d sites, not the turn loop's three" % src.count("tick_cooldowns()"))
	var loop := Gate.fn_body("scripts/battle.gd", "_run_battle", _cache)
	ok(loop.contains("\t\tu.tick_statuses()\n\t\tu.tick_cooldowns()\n"), "§1b: the loop does not tick every unit's cooldowns at its own turn's start")
	ok(loop.count("\t\t\tu.tick_cooldowns()\n") == 2, "§1b: the stunned and the frozen turn do not each tick the unit's own cooldowns")
	var res := Gate.fn_body("scripts/battle.gd", "_resolve", _cache)
	ok(res.contains("\t\telse:\n\t\t\tattacker.start_cooldown(ab)\n"), "§1b: `_resolve` no longer starts the cooldown of whoever cast")
	var foes := _foes(s)
	var w: BattleUnit = foes[0]
	_as_kind(w, "whelp")
	var lunge := _ab(w, "Reckless Lunge")
	var cd := lunge.cooldown if lunge != null else 0
	ok(lunge != null and cd == _data_cd("whelp", "Reckless Lunge") and cd > 0, "§1b: the Whelp's Reckless Lunge carries no cooldown (%d)" % cd)
	if lunge == null or cd <= 0:
		return
	var heroes := _heroes(s)
	await s._resolve(w, lunge, heroes[0], "good")
	ok(int(w.cooldowns.get("Reckless Lunge", 0)) == cd + 1, "§1b: the cast set its counter to %d, not one past its cooldown" % int(w.cooldowns.get("Reckless Lunge", 0)))
	# THE UNIT's OWN TICK, BY THIS GATE's HAND: what is measured is the cast's one-past against the tick's one-less; WHERE the loop
	# ticks (each unit's own turn, on all three paths, and nowhere else) is held by the source arms above (C03).
	var back_on := -1
	for turn in range(1, cd + 3):
		w.tick_statuses()
		w.tick_cooldowns()
		if back_on < 0 and bool(s._intent_ability_usable(w, lunge)):
			back_on = turn
	print("    Reckless Lunge (cooldown %d): back on the Whelp's own turn %d after the cast" % [cd, back_on])
	ok(back_on == cd + 1, "§1b: the move came back on its turn %d, not %d — it waited %d of its turns, not %d" % [back_on, cd + 1, back_on - 1, cd])


# ── §1c — THE SELECTION ───────────────────────────────────────────────────────

# The board a support cast's own condition asks for: an ally under 40%, its own health under half, two allies nicked.
func _support_board(f: BattleUnit, others: Array) -> void:
	for o in others:
		(o as BattleUnit).hp = int((o as BattleUnit).max_hp * 0.3)
	f.hp = int(f.max_hp * 0.4)


# JJ §3 — A HEAL IS ALSO REFUSED BY THE WARBAND's POOL, at the same door; these arms read the cooldown, so they hold the pool full.
# A tree with no pool is left as it is.
func _full_pool(s: Node) -> void:
	if s.get("malice") != null:
		s.set("malice", int((s.get_script() as Script).get_script_constant_map().get("MALICE_CAP", 0)))


func _picks(s: Node, f: BattleUnit, name: String, n: int, ticks := -1) -> int:
	var hit := 0
	for _i in n:
		var c: Dictionary = s._choose_enemy_action(f) if ticks < 0 else s._choose_enemy_action(f, ticks)
		if not c.is_empty() and (c["ability"] as Ability).display_name == name:
			hit += 1
	return hit


func _s1c_the_selection(s: Node) -> void:
	print("\n§1c — the selection asks the cooldown: never a move that will still be cooling, always one that is back")
	var foes := _foes(s)
	var f: BattleUnit = foes[1]
	var others: Array = foes.filter(func(x): return x != f)
	var has_ahead := _args(s, "_choose_enemy_action") >= 2
	ok(has_ahead, "§1c: `_choose_enemy_action` does not take how many of the unit's ticks fall before its move")
	seed(4401)
	var refused: Array = []
	var dead: Array = []
	var fell_back: Array = []
	var checked := 0
	for entry in _pop:
		var kind := String(entry[0])
		var name := String(entry[1])
		_as_kind(f, kind)
		var ab := _ab(f, name)
		if ab != null and HEALS.has(ab.special):
			_support_board(f, others)
			_full_pool(s)
		elif ab != null:
			# A TAUNT FORCES THE ATTACK: the support half is passed by, so the choice is among the attacks alone.
			s._apply_status(f, "mocked", 9, 0, 0, _heroes(s)[0])
		if ab == null:
			dead.append("%s's %s is not in its kit" % [kind, name])
			continue
		checked += 1
		# STILL COOLING WHEN ITS TURN COMES: two on the counter at the end of a turn is one at the next — refused.
		f.cooldowns = {name: 2}
		var wrongly := _picks(s, f, name, 120)
		if wrongly > 0:
			refused.append("%s's %s chosen %d of 120 times with two on its counter" % [kind, name, wrongly])
		# BACK BY ITS TURN: one on the counter at the end of a turn is none at the next — chosen.
		f.cooldowns = {name: 1}
		if _picks(s, f, name, 120) == 0:
			dead.append("%s's %s never chosen in 120 with one on its counter" % [kind, name])
		# FROM A LOST TURN, WHICH DECLARES BEFORE ITS OWN TICK: two on the counter is back by the move's turn.
		if has_ahead:
			f.cooldowns = {name: 2}
			if _picks(s, f, name, 120, 2) == 0:
				dead.append("%s's %s never chosen from a lost turn with two on its counter" % [kind, name])
			# AT RE-VALIDATION, AFTER THE TICK: one on the counter is still cooling this turn.
			f.cooldowns = {name: 1}
			var late := _picks(s, f, name, 120, 0)
			if late > 0:
				refused.append("%s's %s chosen %d of 120 times at re-validation with one on its counter" % [kind, name, late])
		# THE WHOLE TURN: declared with one on the counter, ticked, re-validated — no fallback.
		f.cooldowns = {name: 1}
		f.intent = {}
		var fb0 := _log_text(s).count("falls back to")
		for _j in 40:
			s._declare_intent(f)
			if f.intent.is_empty() or (f.intent["ability"] as Ability).display_name != name:
				continue
			f.tick_cooldowns()
			var d: Dictionary = s._revalidate_intent(f)
			if d.is_empty() or (d["ability"] as Ability).display_name != name:
				fell_back.append("%s's %s declared and then refused at its turn" % [kind, name])
			break
		if _log_text(s).count("falls back to") > fb0:
			fell_back.append("%s's %s fell back" % [kind, name])
	print("    CHECKED %d of %d moves at the declaration, a lost turn, re-validation and the whole turn" % [checked, _pop.size()])
	ok(checked == _pop.size() and checked > 0, "§1c: %d of %d moves could be driven" % [checked, _pop.size()])
	ok(refused.is_empty(), "§1c: the selection chose a move that will still be cooling: %s" % [refused])
	ok(dead.is_empty(), "§1c: the selection never chose a move that is back: %s" % [dead])
	ok(fell_back.is_empty(), "§1c: a declared move fell back at its turn: %s" % [fell_back])
	_s1c_the_callers(s, f, others)
	for o in others:
		(o as BattleUnit).hp = (o as BattleUnit).max_hp


# THE CALLERS' TICKS (the new text's reader: the arms above call the selection with ticks of their own choosing). A turn's end
# declares one of the unit's ticks ahead, a lost turn two (it declares before its own tick), re-validation none — held at source,
# and the two that a break most plausibly moves driven: the declaration's default, and re-validation of an empty intent.
func _s1c_the_callers(s: Node, f: BattleUnit, others: Array) -> void:
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var loop := Gate.fn_body("scripts/battle.gd", "_run_battle", _cache)
	ok(loop.count("_declare_intent(u, 2)") == 2, "§1c: the stunned and the frozen turn do not declare two of the unit's ticks ahead")
	ok(src.contains("func _declare_intent(u: BattleUnit, ticks_ahead := 1) -> void:"), "§1c: a declaration no longer reads one tick ahead by default")
	ok(Gate.fn_body("scripts/battle.gd", "_revalidate_intent", _cache).contains("_choose_enemy_action(u, 0)"), "§1c: re-validation does not choose with none of the unit's ticks ahead")
	ok(Gate.fn_body("scripts/battle.gd", "_psychotic_support", _cache).contains("_enemy_ready(u, a, 0)"), "§1c: the psychotic support does not ask the cooldown as it stands")
	var declared: Array = []
	var revalidated: Array = []
	var driven := 0
	for entry in _pop:
		var kind := String(entry[0])
		var name := String(entry[1])
		_as_kind(f, kind)
		var ab := _ab(f, name)
		if ab == null:
			continue
		if HEALS.has(ab.special):
			_support_board(f, others)
			_full_pool(s)
		else:
			s._apply_status(f, "mocked", 9, 0, 0, _heroes(s)[0])
		driven += 1
		# A TURN's END, TWO ON THE COUNTER: one at the move's turn — the plate must not show it.
		for _j in 40:
			f.cooldowns = {name: 2}
			s._declare_intent(f)
			if not f.intent.is_empty() and (f.intent["ability"] as Ability).display_name == name:
				declared.append("%s's %s declared at a turn's end with two on its counter" % [kind, name])
				break
		# AN EMPTY INTENT AT ITS TURN, ONE ON THE COUNTER: still cooling now — neither chosen nor fallen back from.
		var fb0 := _log_text(s).count("falls back to")
		for _j in 40:
			f.cooldowns = {name: 1}
			f.intent = {}
			var d: Dictionary = s._revalidate_intent(f)
			if not d.is_empty() and (d["ability"] as Ability).display_name == name:
				revalidated.append("%s's %s chosen at its turn with one on its counter" % [kind, name])
				break
		if _log_text(s).count("falls back to") > fb0:
			revalidated.append("%s's %s chosen at its turn and fallen back from" % [kind, name])
		f.intent = {}
		f.cooldowns = {}
	print("    the callers: %d moves driven through `_declare_intent` and `_revalidate_intent`" % driven)
	ok(driven == _pop.size(), "§1c: %d of %d moves could be driven through the callers" % [driven, _pop.size()])
	ok(declared.is_empty(), "§1c: a turn's end declared a move that will still be cooling: %s" % [declared])
	ok(revalidated.is_empty(), "§1c: re-validation of an empty intent reached a move still cooling: %s" % [revalidated])


# ── §1d — EVERY KIND KEEPS A MOVE ─────────────────────────────────────────────

func _s1d_every_kind_keeps_a_move(s: Node) -> void:
	print("\n§1d — with every move but its basic cooling, every kind still declares its basic")
	var f: BattleUnit = _foes(s)[2]
	seed(4402)
	var stuck: Array = []
	var kinds := Enemies.kinds()
	for kind in kinds:
		_as_kind(f, String(kind))
		var basic: Ability = s._cheapest_attack(f)
		if basic == null:
			stuck.append("%s has no basic" % kind)
			continue
		var cool := {}
		for a in f.abilities:
			if a != basic:
				cool[(a as Ability).display_name] = 9
		f.cooldowns = cool
		for _i in 20:
			var c: Dictionary = s._choose_enemy_action(f)
			if c.is_empty() or c["ability"] != basic:
				stuck.append("%s declared %s with every move but its basic cooling" % [kind, "nothing" if c.is_empty() else (c["ability"] as Ability).display_name])
				break
	print("    CHECKED %d kinds" % kinds.size())
	ok(kinds.size() >= 21, "§1d: the roster read %d kinds" % kinds.size())
	ok(stuck.is_empty(), "§1d: a kind does not declare its basic while its others cool (no move, or a cooling one): %s" % [stuck])


# ── §1e — THE PLATE ───────────────────────────────────────────────────────────

func _s1e_the_plate(s: Node) -> void:
	print("\n§1e — the plate: a cast lays the chip, each of its own turns counts it down, and it is gone when the move is back")
	var unit_src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var start := Gate.fn_body("scripts/unit.gd", "start_cooldown", _cache)
	var tick := Gate.fn_body("scripts/unit.gd", "tick_cooldowns", _cache)
	ok(start.contains("sync_cooldown_chip()") and tick.contains("sync_cooldown_chip()"), "§1e: the two doors that move a cooldown do not write the plate's chip")
	ok(unit_src.contains("set_display_chip(\"cooldown\""), "§1e: nothing lays the cooldown chip")
	var w: BattleUnit = _foes(s)[0]
	_as_kind(w, "hurler")
	var stone := _ab(w, "Siege Stone")
	ok(stone != null and stone.cooldown > 0, "§1e: the Hurler's Siege Stone carries no cooldown")
	if stone == null or stone.cooldown <= 0:
		return
	w.start_cooldown(stone)
	var chip: Dictionary = w.display_chip("cooldown")
	print("    after the cast: %s — %s" % [String(chip.get("short", "")), String(chip.get("desc", "")).replace("\n", " | ")])
	ok(String(chip.get("short", "")) == "CD%d" % (stone.cooldown + 1) and String(chip.get("desc", "")).contains("Siege Stone"),
		"§1e: a cooling move lays no chip naming it on its plate (%s)" % str(chip))
	var lines_ok := true
	for line in String(chip.get("desc", "")).split("\n"):
		lines_ok = lines_ok and line.length() <= 44
	ok(lines_ok, "§1e: a line of the chip's hover is past 44 characters")
	var counted: Array = []
	for _t in stone.cooldown + 1:
		w.tick_cooldowns()
		counted.append(String(w.display_chip("cooldown").get("short", "-")))
	print("    its own turns: %s" % str(counted))
	var want: Array = []
	for t2 in range(stone.cooldown, 0, -1):
		want.append("CD%d" % t2)
	want.append("-")
	ok(counted == want, "§1e: the chip counted %s, not %s" % [str(counted), str(want)])
	ok(not w.has_display_chip("cooldown"), "§1e: the chip stands after the move is back")
	# A HERO's COOLDOWNS ARE ON THE HERO's OWN BUTTONS: no chip.
	var war: BattleUnit = _heroes(s)[0]
	var cooled: Ability = null
	for a in war.abilities:
		if (a as Ability).cooldown > 0:
			cooled = a
			break
	if cooled != null:
		war.start_cooldown(cooled)
		ok(not war.has_display_chip("cooldown"), "§1e: a hero wears the enemy's cooldown chip")
		war.cooldowns = {}


# ── §1f — THE TEXTS FOLLOW THE DATA ───────────────────────────────────────────

func _s1f_the_texts() -> void:
	print("\n§1f — the master document names the moves that cool as the data gives them")
	var master := _flat(_doc("res://docs/master.html"))
	var at := master.find(MASTER_NEEDLE)
	ok(at >= 0, "§1f: the master document does not say an enemy's biggest moves wait between uses")
	if at < 0:
		return
	var para := master.substr(at, master.find("</p>", at) - at)
	ok(para.contains("%s times its own basic attack" % str(LINE)), "§1f: the master document does not state the rule's line, %s times a move's own basic" % str(LINE))
	var missing: Array = []
	for entry in _pop:
		if not para.contains(String(entry[1])):
			missing.append(String(entry[1]))
	ok(missing.is_empty(), "§1f: the master document does not name %s among the moves that cool" % [missing])
	var data: Dictionary = Enemies._load()
	# A NAME INSIDE A NAMED MOVE IS NOT A SECOND NAME (Strike inside Heavy Strike): the moves that cool come out first.
	var rest := para
	for entry2 in _pop:
		rest = rest.replace(String(entry2[1]), "")
	var extra: Array = []
	for kind in data:
		for a in data[kind]["abilities"]:
			var name := String(a["display_name"])
			if int(a.get("cooldown", 0)) == 0 and rest.contains(name) and not extra.has(name):
				extra.append(name)
	ok(extra.is_empty(), "§1f: the master document names %s as cooling, which the data does not" % [extra])
	var rx := RegEx.new()
	rx.compile("\\(cooldown \\d|cooldown of \\d+ turns")
	ok(rx.search(para) == null, "§1f: the master document states a move's cooldown as a figure: '%s'" % para.substr(0, 120))
	print("    %d moves named in the master document's paragraph" % (_pop.size() - missing.size()))
	# THE RECORD THAT STATES THE FIGURES FOLLOWS THEM (the brief's R01: a re-tune at its source, and every text that states it
	# follows the data). `### THE WARBAND's COOLDOWNS` names each of the eleven with its multiple and its cooldown, `(n)`.
	var warband := _flat(_block(_doc("res://docs/state.md"), BEFORE_HEAD))
	var at2 := warband.find("**The eleven**")
	var to2 := warband.find("**the line under them**", at2)
	var eleven := warband.substr(at2, to2 - at2) if at2 >= 0 and to2 > at2 else ""
	var stale: Array = []
	for entry3 in _pop:
		var nm := String(entry3[1])
		var have := _data_cd(String(entry3[0]), nm)
		var i3 := eleven.find(nm + " ")
		var said := -1
		if i3 >= 0:
			var p3 := eleven.find("(", i3)
			if p3 >= 0 and p3 - i3 <= nm.length() + 8:
				said = int(eleven.substr(p3 + 1, 1))
		if said != have:
			stale.append("%s: the record says %d, the data %d" % [nm, said, have])
	print("    the state's record of the eleven: %d of %d stated as the data gives them" % [_pop.size() - stale.size(), _pop.size()])
	ok(eleven != "" and stale.is_empty(), "§1f: the state's record does not state each cooling move's cooldown as the data gives it: %s" % [stale])


# ── §2 — ENCUMBERED ───────────────────────────────────────────────────────────

func _s2_encumbered(s: Node) -> void:
	print("\n§2 — Encumbered binds both sides: one branch, every unit on the field")
	var apply := Gate.fn_body("scripts/battle.gd", "_apply_battle_modifier", _cache)
	ok(apply.contains("for u in heroes + enemies:\n\t\t_stamp_modifier(u, mod_id)"), "§2: the bargain's stamp no longer walks every unit on the field")
	var f: BattleUnit = _foes(s)[1]
	_as_kind(f, "hurler")
	var stone := _ab(f, "Siege Stone")
	var lob := _ab(f, "Ember Lob")
	var cd0 := stone.cooldown if stone != null else -1
	s._stamp_modifier(f, "encumbered")
	print("    the Hurler under Encumbered: Siege Stone %d -> %d, Ember Lob %d" % [cd0, stone.cooldown if stone != null else -1, lob.cooldown if lob != null else -1])
	ok(stone != null and cd0 > 0 and stone.cooldown == cd0 + 2, "§2: an enemy's cooling move does not cost two more of its turns under Encumbered")
	ok(lob != null and lob.cooldown == 0, "§2: Encumbered put a cooldown on an enemy's basic")
	var state := _doc("res://docs/state.md")
	var grades := _flat(_block(state, "### THE BARGAIN DECK's GRADES"))
	ok(grades.contains(BOTH_SIDES), "§2: the grades' record does not say Encumbered binds both sides")
	# ITS READINGS STAND IN THE TABLES AS THEY WERE TAKEN, AND ONE SENTENCE BESIDE THEM SAYS WHAT THEY WERE TAKEN ON.
	var said := grades.find(BOTH_SIDES)
	ok(said >= 0 and grades.substr(said, 400).contains(STALE), "§2: the grades' record calls Encumbered's reading current — it was %s" % STALE)
	var census := _block(state, "### THE SHARE CENSUS")
	ok(census != "", "§2: the share census is gone from the record")
	var row_ok := false
	for line2 in census.split("\n"):
		if line2.begins_with("| cooldown turns started |"):
			row_ok = line2.contains(STALE) or line2.contains("both sides")
	ok(row_ok, "§2: the census's cooldown row still reads the warband as starting none")
	ok(not census.contains("Thin Air and Encumbered bind the party alone"), "§2: the census still names Encumbered among the cards that bind the party alone")


# ── §3 — THE BEFORE FIGURE ────────────────────────────────────────────────────

func _s3_the_before_figure() -> void:
	print("\n§3 — the record holds the reading the arc's fifth batch starts from")
	var lines := _doc(KEPT_TABLE).split("\n", false)
	ok(lines.size() > 4, "§3: the kept table %s is not in the tree" % KEPT_TABLE)
	var want := {}
	for l in lines:
		var f := l.split("\t")
		if f.size() >= 4 and ["completed", "falls a run", "health at a fight's end, paired fights"].has(f[0]):
			want[f[0]] = [f[1], f[2], f[3]]
	ok(want.size() == 3, "§3: the kept table lacks a row of the three the brief named: %s" % str(want.keys()))
	var block := _flat(_block(_doc("res://docs/state.md"), BEFORE_HEAD))
	ok(block != "", "§3: the record holds no block on the warband's cooldowns")
	var gone: Array = []
	for k in want:
		# THE BEFORE FIGURE BESIDE THE AFTER, AS THE TABLE PRINTS BOTH: HEAD's, then JI's, then the paired difference.
		var pair := "%s → %s" % [String(want[k][0]), String(want[k][1])]
		if not block.contains(pair):
			gone.append("%s: HEAD's %s beside JI's" % [k, pair])
		if not block.contains(String(want[k][2]).split(" ±")[0]):
			gone.append("%s: the paired %s" % [k, want[k][2]])
	ok(gone.is_empty(), "§3: the record states the reading without its before figure: %s" % [gone])
	print("    the before figures held: %s" % str(want))


# ── §4 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _strip(v: Variant) -> Variant:
	if v is Dictionary:
		var out := {}
		var keys: Array = (v as Dictionary).keys()
		keys.sort()
		for k in keys:
			if String(k) != "cooldown":
				out[k] = _strip(v[k])
		return out
	if v is Array:
		# JK §1 — AND THE WARBAND's MALICE SPENDS, the moves JK added and `check_jk` holds: the digest is of every other figure.
		# JL §2 — AND THE WARBAND's HEXES, the moves JL added and `check_jl` holds.
		return (v as Array).filter(func(x): return not (x is Dictionary and (String((x as Dictionary).get("special", "")).begins_with("malice_") \
			or String((x as Dictionary).get("special", "")) == "warband_hex"))) \
			.map(func(x): return _strip(x))
	return v


func _s4_not_done() -> void:
	print("\n§4 — no enemy figure but the cooldown moved; the deck closed; Encumbered's grade")
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var digest := JSON.stringify(_strip(raw)).md5_text()
	print("    the data, every cooldown key aside: %s" % digest)
	ok(digest == DATA_BEFORE, "§4: a figure of the warband moved beside its cooldowns (%s)" % digest)
	ok((_run.MODIFIERS as Dictionary).size() == DECK_CLOSED_AT, "§4: the deck holds %d, not the twenty-five it closed at" % (_run.MODIFIERS as Dictionary).size())
	var enc: Dictionary = _run.MODIFIERS.get("encumbered", {})
	ok(int(enc.get("severity", -1)) == 1, "§4: Encumbered's grade moved (%s)" % str(enc.get("severity")))


# ── §5 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	print("\n§5 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§5: %s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
