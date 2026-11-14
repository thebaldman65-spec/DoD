# BATCH JL — THE SPEND COSTS NO TURN, AND THE WARBAND LEARNS FOUR HEXES
#
#   §0   JK's SEVEN RULINGS: answered, archived struck, every living citation re-pointed; the correction to the writing rule
#        written where the rule lives.
#   §1   A SPEND IS A FREE ACTION: it rides the body's own declaration beside its action, is bought first on the body's turn and
#        charges no delay (C01, driven), one a turn (C02), never a side's action (C04); a Rally while two bodies stand (C03); the
#        reserve a declared spend sets aside, beside its own body's; the plate names both.
#   §2   FOUR HEXES: carriers derived off the data (C08); each read at its door, each door on its own line (C05, C06); Fester
#        cleansable by what every run owns, on the absence too (C07); each priced by what it denies off JA's census (C09) and
#        cooled by JI's line (C10); each on the hero's plate (C11); the selection aims each at a hero who does not carry it.
#   §3   THE READING: the record carries the warband's blows a fight and each hex's uptime, as the kept table holds them (C12).
#   §4   WHAT IS DELIBERATELY NOT DONE: the fill, the cap, the heals and the three spends' figures and cooldowns unmoved (C13);
#        twenty-one kinds, fifty moves beside the spends and the hexes (fifty-two since JO §2, the hexes riding blows among
#        them); the deck closed at twenty-five (C14).
#   §5   THE TEXTS FOLLOW THE CONSTANTS: what each hex does, stated off its constant wherever it is stated (R01).
#   §6   THE PLAYER'S FILES, as this gate found them.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jl.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# JI's LINE AND ITS BREAK PRICE (JO §1): the one blow every gate on the line prices through.
const JI = preload("res://check_ji.gd")

# BATCH JS — SEVEN KINDS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its boss. Each
# is named here and read apart, so this gate goes on asking its own question of the warband its batch left; `check_js` holds
# the seven. (Rosters 4 and 5 joined too; nothing this gate counts reads a roster.)
# BATCH JU §1 — AND THE FOUR KINDS JU ADDED TO THE FOREST OF OLD, set aside as JS's seven are: this gate holds the warband its
# batch left, and a kind added after it is no figure of that warband moving.
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan",
	"grave_husk", "mossback", "blight_speaker", "carrion_pack",
	# BATCH JW §1 — AND THE DROWNED BARROW's THREE, set aside as JS's seven and JU's four are.
	"rotfiend", "fen_lurker", "bone_shepherd"]
const KINDS := 21
# The warband's moves beside its Malice spends — JK's fifty, and since JO §2 Gall and Mire among them, each a blow given damage;
# Sap and Fester ride two of the fifty, folded onto them.
const MOVES_BEFORE := 52
const HEXES := ["gall", "sap", "mire", "fester"]
# THE HEX SPECIAL JL BUILT — a hex dealing nothing, rolling no miss — gone since JO §2, the designer's: no warband move lays a status
# on a hero unless it deals damage. A hex's carrier is the kind whose move lays it (`_lays`); §2 asks that no move carries the special.
const HEX_SPECIAL := "warband_hex"
# An area blow reaches the party's four heroes, as check_ji prices it.
const REACH := 4
const DECK_CLOSED_AT := 25
const FILL := {"MALICE_DAMAGE_STEP": 10, "MALICE_PER_KILL": 25, "MALICE_CAP": 150}
const HEAL_WORTH := 0.5
const HEAL_SITES := ["target.max_hp * 0.25", "target.max_hp * 0.20", "tp_a.max_hp * 0.06"]
# The three spends' figures as JK set them; §4 holds them unmoved.
const SPEND_FIGURES := {"MALICE_RAISE_PCT": 0.40, "MALICE_RALLY_PCT": 0.30, "MALICE_RALLY_TURNS": 3, "MALICE_RALLY_PRICE": 40,
	"MALICE_ENTRENCH_TURNS": 3, "MALICE_ENTRENCH_PRICE": 30}
const CENSUS_TABLE := "res://docs/reports/JA-shares.tsv"
const LINE_SOURCE := "res://check_ji.gd"
const KEPT_SPENDS := "res://docs/reports/JK-spends.tsv"
# The kept hex table as the tree holds the hexes: JO's since JO §2 put them onto blows (JL-hexes.tsv stays JL's record, JM-hexes.tsv JM's).
const KEPT_HEXES := "res://docs/reports/JO-hexes.tsv"
const KEPT_DRIVE := "res://docs/reports/JL-drive.tsv"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["totemist", "raider", "shieldmaster", "brute", "slinger", "chief"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://jl_profile.json"
const SCRATCH_RELICS := "user://jl_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const ANSWERED := "all accepted as taken"
const SPENDS_HEAD := "### THE WARBAND's SPENDS"
const HEXES_HEAD := "### THE WARBAND's HEXES"
const CITES_ONLY := "A brief cites only what the repository holds"
const FREE_RULE := "A spend costs its body no turn"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JL — THE SPEND COSTS NO TURN, AND THE WARBAND LEARNS FOUR HEXES")
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
	_s0_the_rulings()
	var s: Node = await _board()
	var free := s.has_method("_warband_free_spend")
	var hexes := _hexes_in(s)
	ok(free, "§1: the battle holds no free spend — a spend is still its body's action")
	ok(hexes, "§2: the battle holds no hex — the warband lays none of the four")
	Engine.time_scale = 20.0
	_s1_the_shape(s, free)
	await _s1_every_kind_declares(s, free)
	await _s1_the_free_turn(s, free)
	await _s1_one_a_turn(s, free)
	await _s1_two_bodies(s, free)
	await _s1_the_reserve(s, free)
	_s2_the_carriers()
	await _s2_gall(s, hexes)
	await _s2_sap(s, hexes)
	await _s2_mire(s, hexes)
	await _s2_fester(s, hexes)
	_s2_the_prices(s)
	await _s2_the_plate(s, hexes)
	await _s2_the_selection(s, hexes)
	_s3_the_reading()
	_s4_not_done(s)
	_s5_the_texts(s, hexes)
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s6_the_players_files()
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


func _untagged(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("<[^>]+>")
	return _flat(rx.sub(s, "", true))


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


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves them.
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


func _const(s: Node, name: String) -> Variant:
	return (s.get_script() as Script).get_script_constant_map().get(name)


func _const_f(s: Node, name: String) -> float:
	var v: Variant = _const(s, name)
	return float(v) if v != null else -1.0


func _const_i(s: Node, name: String) -> int:
	var v: Variant = _const(s, name)
	return int(v) if v != null else -1


# A constant of the unit script, -1 where the tree holds none (HEAD's has no hex).
func _unit_f(name: String) -> float:
	var v: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get(name)
	return float(v) if v != null else -1.0


# THE HEX A MOVE LAYS, "" if none: a move carries a hex by laying it, since JO §2 always on a blow.
func _lays(a: Dictionary) -> String:
	var id := String((a.get("applies_status", {}) as Dictionary).get("id", ""))
	return id if HEXES.has(id) else ""


func _ab_lays(ab: Ability) -> String:
	var id := String(ab.applies_status.get("id", ""))
	return id if HEXES.has(id) else ""


func _hex_host(u: BattleUnit, id: String) -> Ability:
	for a in u.abilities:
		if _ab_lays(a as Ability) == id:
			return a
	return null


func _hexes_in(s: Node) -> bool:
	var info: Variant = _const(s, "STATUS_INFO")
	if info == null:
		return false
	for h in HEXES:
		if not (info as Dictionary).has(h):
			return false
	return true


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


func _hero(s: Node, key: String) -> BattleUnit:
	for h in _heroes(s):
		if (h as BattleUnit).hero_key == key:
			return h
	return _heroes(s)[0]


func _all(s: Node) -> Array:
	return (s.get("enemies") as Array)


func _foes(s: Node) -> Array:
	return _all(s).filter(func(e): return not (e as BattleUnit).dead)


func _pool(s: Node, n: int) -> void:
	s.set("malice", n)
	s.set("_malice_dealt", 0)


func _spent(s: Node) -> int:
	return int((s.get("malice_ledger") as Dictionary).get("spent", 0))


# One foe made a kind for a drive: that kind's kit at the whole ladder; full health; nothing cooling, declared or laid.
func _as_kind(f: BattleUnit, kind: String) -> void:
	var cfg := Enemies.config(kind)
	f.abilities = cfg["abilities"]
	f.cooldowns = {}
	f.hp = f.max_hp
	f.intent = {}
	f.enemy_role = String(cfg.get("enemy_role", f.enemy_role))
	for st in ["charging", "mocked", "heads_down", "psychosis", "hysteria", "bewitch", "warband_rally", "warband_entrench", "stunned"]:
		f.remove_status(st)


func _move(u: BattleUnit, special: String, name := "") -> Ability:
	for a in u.abilities:
		var ab: Ability = a
		if String(ab.special) == special and (name == "" or ab.display_name == name):
			return ab
	return null


# THE BOARD A SPEND IS WANTED ON: every standing body whole, undeclared, warded and carrying no Rally or Entrench; the last body
# down and not raised; the pool full; every hero whole and clean.
func _spend_board(s: Node) -> BattleUnit:
	var all := _all(s)
	var corpse: BattleUnit = all[all.size() - 1]
	if not corpse.dead:
		corpse.hp = 1
		s.call("_dmg_frame", null, "")
		corpse.take_hit(5, 0)
	for e in _foes(s):
		var u: BattleUnit = e
		u.hp = u.max_hp
		u.intent = {}
		u.cooldowns = {}
		for st in ["warband_rally", "warband_entrench"]:
			u.remove_status(st)
		if not u.has_status("shielded"):
			s._apply_status(u, "shielded", 9)
	var raised: Variant = s.get("_malice_raised")
	if raised != null:
		(raised as Array).clear()
	for h in _heroes(s):
		_clean(h)
	_pool(s, _const_i(s, "MALICE_CAP"))
	return corpse


func _clean(h: BattleUnit) -> void:
	h.hp = h.max_hp
	for st in HEXES + ["frostbite", "slow", "stunned", "frozen"]:
		h.remove_status(st)


# The spend riding a body's declaration, or {}.
func _rider(u: BattleUnit) -> Dictionary:
	var sp: Variant = u.intent.get("spend", {})
	return sp if sp is Dictionary else {}


func _rider_special(u: BattleUnit) -> String:
	var sp := _rider(u)
	return String((sp["ability"] as Ability).special) if sp.get("ability") is Ability else ""


func _count(src: String, needle: String) -> int:
	return Gate.strip_comments(src).count(needle)


# ── §0 — JK's SEVEN RULINGS ───────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JK's seven rulings, answered and archived; the writing rule's correction")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n### JK's RULINGS OWED"), "§0: ### JK's RULINGS OWED is still in the open queue — it was answered")
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JK's RULINGS OWED~~"))
	ok(struck.contains(ANSWERED), "§0: the archive does not hold JK's rulings struck and answered")
	# EVERY LIVING CITATION FOLLOWS: an answered ruling is cited as accepted, never as owed.
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/master.html", "res://scripts/battle.gd",
			"res://scripts/unit.gd", "res://docs/instrument-rules.md", "res://check_hi.gd"]:
		if _doc(p).contains("JK's RULINGS OWED"):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])
	# THE CORRECTION THE BRIEF RECORDS AGAINST THE WRITING RULE: a brief cites only what the repository holds.
	ok(_flat(_doc("res://docs/ways-of-working.md")).contains(CITES_ONLY), "§0: the writing rule does not say a brief cites only what the repository holds")


# ── §1 — A SPEND IS A FREE ACTION ─────────────────────────────────────────────

# C04: the shape — the spends are chosen by the declaration, bought by the body's own turn, and paid by their arms; no side's action.
func _s1_the_shape(s: Node, free: bool) -> void:
	print("\n§1 — the shape: a spend rides its body's declaration and is bought on its body's turn")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var payers: Array = []
	var choosers: Array = []
	var buyers: Array = []
	for chunk in src.split("\nfunc "):
		var name := String(chunk.split("(")[0]).strip_edges()
		if chunk.contains("_malice_pay("):
			payers.append(name)
		if chunk.contains("_warband_spend(") and not chunk.begins_with("_warband_spend("):
			choosers.append(name)
		if chunk.contains("_warband_free_spend(") and not chunk.begins_with("_warband_free_spend("):
			buyers.append(name)
	payers.sort()
	print("    paid by %s; chosen by %s; bought by %s" % [str(payers), str(choosers), str(buyers)])
	ok(payers == ["_malice_pay", "_resolve_special", "_warband_heal"], "§1: the pool is paid by %s, not its definition, a move's own arm and the heal's payment — a side's action" % str(payers))
	ok(choosers == ["_declare_intent"], "§1: the spends are chosen by %s, not the declaration of a body's own turn" % str(choosers))
	ok(free and buyers == ["_enemy_turn"], "§1: a spend is bought by %s, not by its body's own turn" % str(buyers))
	ok(not Gate.fn_body("scripts/battle.gd", "_enemy_support_action", _cache).contains("_warband_spend("), "§1: the support half still chooses a spend as the body's action")


# Every kind declares a spend beside its action on a board that wants one; the action itself is never a spend.
func _s1_every_kind_declares(s: Node, free: bool) -> void:
	print("\n§1 — every kind declares a spend beside its action, on a board that wants one")
	if not free:
		ok(false, "§1: a kind declares no spend beside its action — no free spend in the tree")
		return
	var f: BattleUnit = _foes(s)[0]
	var data: Dictionary = Enemies._load()
	var none: Array = []
	var as_action: Array = []
	for kind in data:
		_as_kind(f, String(kind))
		_spend_board(s)
		f.intent = {}
		s.call("_declare_intent", f)
		var act: Variant = f.intent.get("ability")
		if act is Ability and String((act as Ability).special).begins_with("malice_"):
			as_action.append(String(kind))
		if _rider_special(f) == "":
			none.append("%s declared %s and no spend" % [kind, (act as Ability).display_name if act is Ability else "nothing"])
		f.intent = {}
	print("    CHECKED %d of %d kinds" % [data.size(), KINDS])
	ok(none.is_empty(), "§1: a kind declares no spend beside its action on a board that wants one: %s" % [none])
	ok(as_action.is_empty(), "§1: a kind declares a spend as its action: %s" % [as_action])
	_pool(s, 0)


# C01: THE DRIVE — a Raider declares a Rally beside its blow; its turn buys the Rally, pays for it, and charges the blow's delay alone.
func _s1_the_free_turn(s: Node, free: bool) -> void:
	print("\n§1 — the free turn, driven: the spend bought, the body's own action taken, its own delay charged")
	if not free:
		ok(false, "§1: a spend consumed its body's turn — no free spend in the tree")
		return
	var f: BattleUnit = _foes(s)[1]
	_as_kind(f, "raider")
	_spend_board(s)
	# THE BLOW MUST NOT SHARE THE SPEND's DELAY, or a turn the spend took would read as the blow's (the new text's reader's M1): the
	# Raider declares again until its blow is one whose delay differs from the Rally's, and says which it declared.
	var act: Variant = null
	var sp := ""
	var spend_delay := -1.0
	for _d in 40:
		f.intent = {}
		s.call("_declare_intent", f)
		act = f.intent.get("ability")
		sp = _rider_special(f)
		spend_delay = (_rider(f)["ability"] as Ability).delay if sp != "" else -1.0
		if act is Ability and absf((act as Ability).delay - spend_delay) > 0.01:
			break
	ok(sp == "malice_rally" and act is Ability and (act as Ability).damage > 0 and absf((act as Ability).delay - spend_delay) > 0.01,
		"§1: the premise — the Raider declares a Rally beside a blow of another delay (%s, %s)" % [sp, str(act)])
	if not (act is Ability):
		return
	var ab: Ability = act
	# THE PLATE NAMES BOTH, THE SPEND FIRST, AND THE HOVER SAYS IT IS BOUGHT FIRST AND FREE (§1 premise 1: what the player sees).
	s.call("_refresh_intent_plate", f)
	var lab: Variant = f.get("_intent_label")
	var line := (lab as Label).text if lab is Label else ""
	var hover := (lab as Label).tooltip_text if lab is Label else ""
	print("    the Raider's plate: '%s'; its hover opens '%s'" % [line, hover.get_slice("\n", 0)])
	ok(line.find("Rally") >= 0 and line.find(ab.display_name) > line.find("Rally") and hover.begins_with("First, free: Rally"),
		"§1: the plate does not name the spend and the move, the spend first, or its hover does not say the spend comes first and free: '%s' / '%s'" % [line, hover.get_slice("\n", 0)])
	var t0 := f.next_time
	var m0 := int(s.get("malice"))
	var spent0 := _spent(s)
	var cd0 := f.cooldowns.duplicate()
	s.set("debug_enemies_off", false)
	await s._enemy_turn(f)
	s.set("debug_enemies_off", true)
	var dt := f.next_time - t0
	var want := ab.delay * 100.0 / f.effective_speed() * f.momentum_delay_mult()
	var rallied := _foes(s).filter(func(e): return (e as BattleUnit).has_status("warband_rally")).size()
	var paid := _spent(s) - spent0
	print("    a Raider's turn: %s then %s; its clock moved %.2f (its blow's %.2f, a spend's %.2f); %d of %d standing rallied; the pool paid %d of %d" % [
		sp, ab.display_name, dt, want, 2.5 * 100.0 / f.effective_speed(), rallied, _foes(s).size(), paid, m0])
	ok(absf(dt - want) < 0.01, "§1: the body's turn charged %.2f, not its own action's delay %.2f — the spend took the turn or a delay of its own" % [dt, want])
	ok(rallied == _foes(s).size() and paid == _const_i(s, "MALICE_RALLY_PRICE"), "§1: the free Rally was not bought: %d of %d rallied, the pool paid %d" % [rallied, _foes(s).size(), paid])
	ok(int(f.cooldowns.get("Rally", 0)) > int(cd0.get("Rally", 0)), "§1: a free Rally started no cooldown")
	for e in _foes(s):
		(e as BattleUnit).remove_status("warband_rally")
	_pool(s, 0)


# C02: ONE SPEND A TURN — a Totemist on a board that wants a Raise and an Entrench buys one of them on its turn.
func _s1_one_a_turn(s: Node, free: bool) -> void:
	print("\n§1 — one spend a turn")
	if not free:
		ok(false, "§1: two spends were bought on one turn — no free spend in the tree")
		return
	var f: BattleUnit = _foes(s)[0]
	_as_kind(f, "totemist")
	var corpse := _spend_board(s)
	f.intent = {}
	s.call("_declare_intent", f)
	var riders := 1 if not _rider(f).is_empty() else 0
	var spent0 := _spent(s)
	var free0 := float((s.get("sim_stats") as Dictionary).get("spend_free", 0.0))
	s.set("debug_enemies_off", false)
	await s._enemy_turn(f)
	s.set("debug_enemies_off", true)
	var bought := int(float((s.get("sim_stats") as Dictionary).get("spend_free", 0.0)) - free0)
	var kinds := 0
	if not corpse.dead:
		kinds += 1
	if _foes(s).any(func(e): return (e as BattleUnit).has_status("warband_entrench")):
		kinds += 1
	print("    a Totemist's turn on a board wanting a Raise and an Entrench: %d riding its declaration, %d bought, %d kinds laid; the pool paid %d" % [
		riders, bought, kinds, _spent(s) - spent0])
	ok(riders == 1 and bought == 1 and kinds == 1, "§1: two spends were bought on one turn (%d riding, %d bought, %d laid)" % [riders, bought, kinds])
	for e in _foes(s):
		(e as BattleUnit).remove_status("warband_entrench")
	_pool(s, 0)


# C03: A RALLY WHILE TWO BODIES STAND — with two standing a Raider declares one; with one, none.
func _s1_two_bodies(s: Node, free: bool) -> void:
	print("\n§1 — a Rally while two or more bodies stand")
	ok(_const_i(s, "MALICE_RALLY_BODIES") == 2, "§1: a Rally waits for %d standing bodies, not two" % _const_i(s, "MALICE_RALLY_BODIES"))
	if not free:
		ok(false, "§1: a Rally is not declared while two bodies stand — no free spend in the tree")
		return
	var f: BattleUnit = _foes(s)[1]
	_as_kind(f, "raider")
	_spend_board(s)
	var keep: Array = []
	var others := _foes(s).filter(func(e): return e != f)
	keep.append(others[0])
	var downed: Array = []
	for e in others.slice(1):
		var u: BattleUnit = e
		u.hp = 1
		s.call("_dmg_frame", null, "")
		u.take_hit(5, 0)
		downed.append(u)
	_pool(s, _const_i(s, "MALICE_CAP"))
	f.intent = {}
	s.call("_declare_intent", f)
	var at_two := _rider_special(f)
	var lone: BattleUnit = keep[0]
	lone.hp = 1
	s.call("_dmg_frame", null, "")
	lone.take_hit(5, 0)
	f.intent = {}
	var raised: Variant = s.get("_malice_raised")
	s.call("_declare_intent", f)
	var at_one := _rider_special(f)
	print("    two standing: %s; one standing: %s" % [at_two, at_one if at_one != "" else "none"])
	ok(at_two == "malice_rally", "§1: a Rally is not declared while two bodies stand (%s)" % at_two)
	ok(at_one != "malice_rally", "§1: a Rally is declared with one body standing")
	f.intent = {}
	# THE BOARD BACK ON ITS FEET for the drives below: every body the arm felled stood up whole.
	for u2 in downed + [lone]:
		(u2 as BattleUnit).revive(1.0)
	if raised != null:
		(raised as Array).clear()
	_pool(s, 0)


# THE RESERVE: a declared spend sets its price aside, so another body cannot buy with it; and a body's own heal and its spend are
# set aside together, so the spend never buys with its own heal's Malice.
func _s1_the_reserve(s: Node, free: bool) -> void:
	print("\n§1 — the reserve: a declared spend sets its price aside, beside its own body's heal")
	if not free:
		ok(false, "§1: a declared spend did not set its price aside — no free spend in the tree")
		return
	var f: BattleUnit = _foes(s)[1]
	var g: BattleUnit = _foes(s)[2]
	_as_kind(f, "raider")
	_as_kind(g, "shieldmaster")
	_spend_board(s)
	var price := _const_i(s, "MALICE_RALLY_PRICE")
	_pool(s, price)
	f.intent = {}
	s.call("_declare_intent", f)
	var held := int(_rider(f).get("malice", -1))
	var free_left := int(s.call("_malice_free", null))
	g.intent = {}
	s.call("_declare_intent", g)
	var g_spend := _rider_special(g)
	print("    a Raider's Rally set aside %d of %d; the pool's free share %d; the Shieldmaster beside it declared %s" % [held, price, free_left, g_spend if g_spend != "" else "no spend"])
	ok(held == price and free_left == 0 and g_spend == "", "§1: a declared spend did not set its price aside (held %d of %d, free %d, the next body bought %s)" % [held, price, free_left, g_spend])
	f.intent = {}
	g.intent = {}
	# A TOTEMIST's HEAL AND ITS SPEND: one short of both prices, the heal and no spend; at both, both.
	var t: BattleUnit = _foes(s)[0]
	_as_kind(t, "totemist")
	var corpse := _spend_board(s)
	var hurt: BattleUnit = _foes(s)[3]
	hurt.hp = int(hurt.max_hp * 0.3)
	var wave := _move(t, "healing_wave")
	var raise := _move(t, "malice_raise")
	var heal_price := int(s.call("_malice_price", t, wave, hurt)) if wave != null else -1
	var raise_price := int(s.call("_malice_price", t, raise, corpse)) if raise != null else -1
	var got: Array = []
	for pool in [heal_price + raise_price - 1, heal_price + raise_price]:
		_pool(s, pool)
		t.intent = {}
		s.call("_declare_intent", t)
		got.append([String((t.intent.get("ability") as Ability).special) if t.intent.get("ability") is Ability else "", _rider_special(t), int(t.intent.get("malice", 0)), int(_rider(t).get("malice", 0))])
		t.intent = {}
	print("    a Totemist with a body hurt and one down (a heal %d, a Raise %d): one short %s; at both %s" % [heal_price, raise_price, str(got[0]), str(got[1])])
	ok(got[0][0] == "healing_wave" and got[0][1] != "malice_raise" and got[1][0] == "healing_wave" and got[1][1] == "malice_raise" and int(got[1][3]) == raise_price,
		"§1: a body's spend bought with its own heal's reserve: one short of both %s, at both %s" % [str(got[0]), str(got[1])])
	# A RAISE RIDING A HEAL, BOUGHT ON THE TURN (the fresh reader's): the body the Raise stands up declares at once, and the heal's own
	# reserve must still be held then, or the raised body can set the heal's Malice aside and the heal lands short. The pool holds
	# exactly both prices; the turn buys the Raise, then heals; the heal restores its whole figure.
	t.intent = {}
	corpse = _spend_board(s)
	hurt.hp = int(hurt.max_hp * 0.3)
	_pool(s, heal_price + raise_price)
	s.call("_declare_intent", t)
	var rode := _rider_special(t) == "malice_raise" and t.intent.get("ability") is Ability \
		and String((t.intent["ability"] as Ability).special) == "healing_wave"
	var hp0 := hurt.hp
	s.set("debug_enemies_off", false)
	await s._enemy_turn(t)
	s.set("debug_enemies_off", true)
	var healed := hurt.hp - hp0
	var raised_rider := _rider(corpse)
	print("    a Totemist's Healing Wave with a Raise riding, the pool at both prices (%d): raised %s; the raised body's rider %s; the heal restored %d of %d" % [
		heal_price + raise_price, str(not corpse.dead), str(raised_rider.get("malice", 0)), healed, heal_price])
	ok(rode and not corpse.dead and healed == heal_price,
		"§1: a heal lands short when a Raise rides it — the raised body took the heal's reserve (rode %s, raised %s, healed %d of %d)" % [str(rode), str(not corpse.dead), healed, heal_price])
	hurt.hp = hurt.max_hp
	_pool(s, 0)


# ── §2 — FOUR HEXES ───────────────────────────────────────────────────────────

# C08: THE CARRIERS, DERIVED OFF THE DATA — every hex has one, and the Orc Hexer carries one or more: its Sap, since JM §0 moved
# Gall onto the Orc Archer (check_jm §0 holds who carries Gall).
func _s2_the_carriers() -> void:
	print("\n§2 — who carries each hex, off the data")
	var data: Dictionary = Enemies._load()
	var carriers := {}
	for h in HEXES:
		carriers[h] = []
	for kind in data:
		for a in data[kind]["abilities"]:
			if _lays(a) != "":
				var id := _lays(a)
				if carriers.has(id):
					(carriers[id] as Array).append(String(kind))
	var none: Array = HEXES.filter(func(h): return (carriers[h] as Array).is_empty())
	var hexer := 0
	for h2 in HEXES:
		if (carriers[h2] as Array).has("hexer"):
			hexer += 1
	print("    %s; the Orc Hexer carries %d" % [str(carriers), hexer])
	ok(none.is_empty(), "§2: a hex has no carrier: %s" % [none])
	ok(hexer >= 1, "§2: the Orc Hexer carries %d hexes, not one or more" % hexer)
	# THE KEPT TABLE SAYS WHO CARRIES WHAT AS THE DATA DOES.
	var rows := _doc(KEPT_HEXES).split("\n", false)
	var said := {}
	for r in rows.slice(1):
		var c := String(r).split("\t")
		if c.size() >= 3:
			said["%s/%s" % [c[0], c[2]]] = true
	var missing: Array = []
	for h3 in HEXES:
		for k in carriers[h3]:
			if ADDED_SINCE.has(String(k)):
				continue
			if not said.has("%s/%s" % [k, h3]):
				missing.append("%s/%s" % [k, h3])
	var extra: Array = said.keys().filter(func(x): return not (carriers.get(String(x).split("/")[1], []) as Array).has(String(x).split("/")[0]))
	ok(rows.size() > 1 and missing.is_empty() and extra.is_empty(), "§2: the kept table does not say who carries each hex as the data does: missing %s, extra %s" % [missing, extra])


# C05: GALL AT THE ONE DOOR EVERY HEAL PASSES — three paths, each on its own line: a cast's heal, a heal the warband casts on a hero
# (a maddened mender's), and the door itself.
func _s2_gall(s: Node, hexes: bool) -> void:
	print("\n§2 — Gall: healing received, at its one door")
	var cut := _unit_f("GALL_HEAL_CUT")
	if not hexes or cut < 0.0:
		ok(false, "§2: Gall is read at no healing door — no Gall in the tree")
		return
	var h := _hero(s, "warrior")
	var cl := _hero(s, "cleric")
	var e: BattleUnit = _foes(s)[0]
	var mend: Ability = Ability.make({"display_name": "The Gate's Mend", "heal": 40, "target": Ability.Target.ALLY})
	var paths := ["a cast's heal", "a warband heal on a hero", "the door itself"]
	var wrong: Array = []
	for p in paths:
		var got := []
		for galled in [false, true]:
			_clean(h)
			h.hp = 1
			if galled:
				s._apply_status(h, "gall", 3, 0, 0, e)
			cl.resource = cl.max_resource
			match p:
				"a cast's heal":
					await s._resolve(cl, mend, h, "good")
				"a warband heal on a hero":
					s.call("_warband_heal", e, h, "healing_wave")
				_:
					h.heal_amount(30, true)
			got.append(h.hp - 1)
		var want := int(round(float(got[0]) * (1.0 - cut)))
		print("    %-26s %3d whole, %3d galled (the door's %d)" % [p, got[0], got[1], want])
		if got[0] <= 0 or absi(int(got[1]) - want) > 1:
			wrong.append("%s: %d whole, %d galled, not %d" % [p, got[0], got[1], want])
	ok(wrong.is_empty(), "§2: Gall is not read at the one healing door every heal passes: %s" % [wrong])
	_clean(h)


# C06: SAP AT THE BAR's OWN SETTER — three paths that add to a hero's bar, each on its own line: a write of the shape fifty lines
# share, a cast's own gain at the price line, and a blow taken by a Rage hero.
func _s2_sap(s: Node, hexes: bool) -> void:
	print("\n§2 — Sap: resource gained, at its one door")
	var cut := _unit_f("SAP_CUT")
	if not hexes or cut < 0.0:
		ok(false, "§2: Sap is read at no resource door — no Sap in the tree")
		return
	var w := _hero(s, "warrior")
	var e: BattleUnit = _foes(s)[0]
	var build: Ability = Ability.make({"display_name": "The Gate's Build", "heal": 1, "resource_gain": 20, "target": Ability.Target.ALLY})
	var paths := ["a write to the bar", "a cast's gain at the price line", "a blow taken by a Rage hero"]
	var wrong: Array = []
	for p in paths:
		var got := []
		for sapped in [false, true]:
			_clean(w)
			w.resource = 0
			if sapped:
				s._apply_status(w, "sap", 3, 0, 0, e)
			match p:
				"a write to the bar":
					w.resource = mini(w.resource + 20, w.max_resource)
				"a cast's gain at the price line":
					await s._resolve(w, build, w, "good")
				_:
					s.call("_dmg_frame", e, "The Gate's Blow")
					w.take_hit(5, 0)
			got.append(w.resource)
		var want := int(got[0]) - int(int(got[0]) * cut)
		print("    %-32s +%d whole, +%d sapped (the door's +%d)" % [p, got[0], got[1], want])
		if int(got[0]) <= 0 or absi(int(got[1]) - want) > 1:
			wrong.append("%s: +%d whole, +%d sapped, not +%d" % [p, got[0], got[1], want])
	ok(wrong.is_empty(), "§2: Sap is not read at the one door every gain of the bar passes: %s" % [wrong])
	# A SPEC's OWN METER IS NOT THE BAR: Focus, Faith and Resonance ride `second_resource`, which Sap does not cut — and no hero's
	# bar is Focus, so a Sap text that promises to cut Focus promises what the door does not do (both readers' HIGH).
	_clean(w)
	s._apply_status(w, "sap", 3, 0, 0, e)
	w.second_resource = 0
	w.second_resource += 20
	var named: Array = []
	for kind in Enemies._load():
		for ab in Enemies.config(String(kind))["abilities"]:
			if String((ab as Ability).applies_status.get("id", "")) == "sap" and (ab as Ability).description.contains("Focus"):
				named.append(String(kind))
	print("    a spec meter under Sap: +%d of 20; Sap moves naming Focus: %s" % [w.second_resource, str(named)])
	ok(w.second_resource == 20 and named.is_empty(), "§2: Sap reaches a spec's own meter, or its words promise to cut one (+%d of 20; %s)" % [w.second_resource, str(named)])
	# A WRITE THAT LOWERS THE BAR IS UNTOUCHED.
	_clean(w)
	w.resource = 50
	s._apply_status(w, "sap", 3, 0, 0, e)
	w.resource = 30
	ok(w.resource == 30, "§2: Sap moved a write that lowers the bar, 50 to 30 read %d" % w.resource)
	_clean(w)


# C06: MIRE AT THE ONE SPEED EVERY DELAY IS DIVIDED BY — an action's delay and a lost Sloppy cast's, each on its own line.
func _s2_mire(s: Node, hexes: bool) -> void:
	print("\n§2 — Mire: a hero's delay, at its one door")
	var slow := _unit_f("MIRE_SLOW")
	if not hexes or slow < 0.0:
		ok(false, "§2: Mire is read at no speed door — no Mire in the tree")
		return
	var h := _hero(s, "mage")
	var e: BattleUnit = _foes(s)[0]
	var step: Ability = Ability.make({"display_name": "The Gate's Step", "heal": 1, "delay": 2.0, "target": Ability.Target.ALLY})
	var paths := ["an action's delay", "a Sloppy cast's delay"]
	var wrong: Array = []
	var sp0 := 0.0
	for p in paths:
		var got := []
		for mired in [false, true]:
			_clean(h)
			if mired:
				s._apply_status(h, "mire", 3, 0, 0, e)
			var t0 := h.next_time
			if p == "an action's delay":
				await s._resolve(h, step, h, "good")
			else:
				await s._gated_failure(h, step)
			got.append(h.next_time - t0)
		var ratio := float(got[1]) / maxf(float(got[0]), 0.0001)
		print("    %-22s %.2f whole, %.2f mired (%.3f times; the door's %.3f)" % [p, got[0], got[1], ratio, 1.0 / (1.0 - slow)])
		if absf(ratio - 1.0 / (1.0 - slow)) > 0.002:
			wrong.append("%s: %.2f whole, %.2f mired" % [p, got[0], got[1]])
	_clean(h)
	sp0 = h.effective_speed()
	s._apply_status(h, "mire", 3, 0, 0, e)
	var sp1 := h.effective_speed()
	ok(wrong.is_empty() and absf(sp1 - sp0 * (1.0 - slow)) < 0.001, "§2: Mire is not read at the one speed every delay is divided by: %s (speed %.2f → %.2f)" % [wrong, sp0, sp1])
	_clean(h)


# C07: FESTER ticks a stack's share of its applier's Attack, gains a stack and its full clock each turn, and is cleansable by what
# every run owns — the Cleric's Unburden, a kit card — and by the Cleansing Draught's filter; never sticky.
func _s2_fester(s: Node, hexes: bool) -> void:
	print("\n§2 — Fester: it grows until it is cleansed, and every run can cleanse it")
	var kits: Dictionary = Classes.CLASS_KITS
	var owned := false
	for cls in kits:
		if (kits[cls] as Array).has("Unburden"):
			owned = true
	ok(owned, "§2: no card every run holds lifts a hex — the Cleric's kit holds no Unburden")
	if not hexes:
		ok(false, "§2: Fester is not cleansable by anything the party owns — no Fester in the tree")
		return
	var h := _hero(s, "warrior")
	var cl := _hero(s, "cleric")
	var b: BattleUnit = _foes(s)[3]
	_as_kind(b, "behemoth")
	var fester := _hex_host(b, "fester")
	ok(fester != null, "§2: the premise — the Rot Behemoth carries Fester")
	if fester == null:
		return
	_clean(h)
	h.hp = h.max_hp
	# THE BLOW THAT LAYS IT IS STRUCK, SO NOTHING MAY GUARD IT: a Block negates a blow's on-hit effects, and this arm reads the tick.
	h.block_chance = -10.0
	h.parry_chance = 0.0
	await s._resolve(b, fester, h, "good")
	var tick := int(h.get_status("fester").get("tick", 0))
	var lost: Array = []
	var stacks: Array = [h.status_stacks("fester")]
	for _t in 3:
		var hp0 := h.hp
		await s._dot_pass(h)
		h.tick_statuses()
		lost.append(hp0 - h.hp)
		stacks.append(h.status_stacks("fester"))
	var want_tick := maxi(int(round(float((_const(s, "DOT_STATUSES") as Dictionary).get("fester", 0)) * 0.01 * b.attack)), 1)
	print("    a Behemoth's Fester on a hero: its tick %d (the rule's %d); lost %s over three turns; its stacks %s; standing %s" % [tick, want_tick, str(lost), str(stacks), str(h.has_status("fester"))])
	ok(tick == want_tick and lost == [tick, tick * 2, tick * 3] and stacks == [1, 2, 3, 4] and h.has_status("fester"),
		"§2: Fester does not tick a stack's share and grow a stack a turn until cleansed: tick %d (want %d), lost %s, stacks %s" % [tick, want_tick, str(lost), str(stacks)])
	# CLEANSABLE: the cleanse filters and the Cleric's own card.
	var in_filter: bool = (s.call("_cleansable_debuffs", h) as Array).any(func(x): return String((x as Dictionary).get("id", "")) == "fester")
	var unburden: Ability = null
	for a in cl.abilities:
		if (a as Ability).display_name == "Unburden":
			unburden = a
	cl.resource = cl.max_resource
	cl.cooldowns = {}
	if unburden != null:
		await s._resolve(cl, unburden, h, "good")
	print("    the cleanse filter takes it: %s; the Cleric's Unburden lifted it: %s" % [str(in_filter), str(unburden != null and not h.has_status("fester"))])
	ok(in_filter and unburden != null and not h.has_status("fester"), "§2: Fester is not cleansable by anything the party owns (the filter %s, Unburden %s)" % [str(in_filter), str(unburden != null and not h.has_status("fester"))])
	var sticky: Array = []
	for hx in HEXES:
		_clean(h)
		s._apply_status(h, hx, 3, 0, 0, b)
		if not (s.call("_cleansable_debuffs", h) as Array).any(func(x): return String((x as Dictionary).get("id", "")) == hx):
			sticky.append(hx)
	ok(sticky.is_empty(), "§2: a hex no cleanse reaches: %s" % [sticky])
	_clean(h)
	_as_kind(b, "brute")


# C09, C10: EACH HEX PRICED AND COOLED BY THE BLOW THAT CARRIES IT, ON JI's ONE LINE — and the kept table. JL priced each hex move by
# what it denied, off JA's census; since JO §2 no move is a hex alone, so a hex rides a blow the line prices by its damage, the DoT
# it lays (Fester is one) and its Break, and nothing a hex denies is priced (as Sunder and Exposed are not). JL-hexes.tsv and
# JM-hexes.tsv keep the convention as JL and JM priced the standalone moves.
func _s2_the_prices(s: Node) -> void:
	print("\n§2 — each hex rides a blow, priced and cooled by JI's line")
	var rx := RegEx.new()
	rx.compile("\\nconst LINE := ([0-9.]+)\\n")
	var m := rx.search(_doc(LINE_SOURCE))
	var line := float(m.get_string(1)) if m != null else -1.0
	ok(line > 1.0, "§2: JI's line could not be read out of %s" % LINE_SOURCE)
	ok(Gate.fn_body("check_jl.gd", "_blow", _cache) == "" and Gate.fn_body("check_ji.gd", "line_blow", _cache) != "", "§2: this gate prices a blow otherwise than check_ji does")
	var price := float(JI.break_figures().get("price", -1.0))
	ok(price > 0.0, "§2: the Break price could not be read off check_ji")
	var dot: Dictionary = _const(s, "DOT_STATUSES") if _const(s, "DOT_STATUSES") != null else {}
	var data: Dictionary = Enemies._load()
	var wrong: Array = []
	var specials: Array = []
	var table := {}
	for r2 in _doc(KEPT_HEXES).split("\n", false).slice(1):
		var c2 := String(r2).split("\t")
		if c2.size() >= 17:
			table["%s/%s" % [c2[0], c2[2]]] = [float(c2[12]), int(c2[16])]
	var checked := 0
	for kind in data:
		var kd: Dictionary = data[kind]
		var basic: Dictionary = {}
		for a in kd["abilities"]:
			if int(a.get("damage", 0)) > 0 and int(a.get("cost", 0)) == 0:
				basic = a
				break
		var atk := float(kd["attack"])
		var bp := JI.line_blow(basic, dot, atk, price)
		for a2 in kd["abilities"]:
			if String(a2.get("special", "")) == HEX_SPECIAL:
				specials.append("%s/%s" % [kind, String(a2["display_name"])])
			var id := _lays(a2)
			if id == "":
				continue
			var worth := JI.line_blow(a2, dot, atk, price)
			var mult := worth / bp
			var want := 0 if mult < line else (2 if mult < 2.0 else (3 if mult < 3.0 else 4))
			var have := int(a2.get("cooldown", 0))
			checked += 1
			print("    %5.2f  %-14s %-7s on %-16s worth %6.1f against a basic of %5.1f: the line %d, the data %d" % [mult, kind, id, String(a2["display_name"]), worth, bp, want, have])
			if int(a2.get("damage", 0)) <= 0:
				wrong.append("%s's %s lays %s and deals nothing" % [kind, String(a2["display_name"]), id])
			if mult < line or want != have:
				wrong.append("%s's %s carries %d, the line gives %d (%.2f of its basic)" % [kind, String(a2["display_name"]), have, want, mult])
			var row: Variant = table.get("%s/%s" % [kind, id])
			if row == null and ADDED_SINCE.has(String(kind)):
				continue
			if row == null or absf(float(row[0]) - worth) > 0.051 or int(row[1]) != have:
				wrong.append("the kept table prices %s's %s at %s, its blow on the line is %.1f" % [kind, id, str(row), worth])
	print("    CHECKED %d hexes, each on a blow" % checked)
	ok(checked >= HEXES.size(), "§2: the walk priced %d hexes, not four or more" % checked)
	ok(specials.is_empty(), "§2: a move is still a hex that deals nothing and rolls no miss: %s" % [specials])
	ok(wrong.is_empty(), "§2: a hex rides no blow, or one not cooled off the line: %s" % [wrong])


# C11: EACH HEX ON THE HERO's PLATE — its chip, its own tag, in the row under the bars.
func _s2_the_plate(s: Node, hexes: bool) -> void:
	print("\n§2 — each hex on the hero's plate")
	if not hexes:
		ok(false, "§2: a hex is invisible on the hero's plate — no hex in the tree")
		return
	var h := _hero(s, "mage")
	var e: BattleUnit = _foes(s)[0]
	var info: Dictionary = _const(s, "STATUS_INFO")
	var unseen: Array = []
	for hx in HEXES:
		_clean(h)
		s._apply_status(h, hx, 3, 0, 1, e)
		await process_frame
		var tag := String(h.get_status(hx).get("short", ""))
		var shown := false
		var root: Node = h.get("_chips_root")
		if root != null:
			for n in root.find_children("*", "Label", true, false):
				if not n.is_queued_for_deletion() and (n as Label).text == tag:
					shown = true
		print("    %-7s the tag '%s' (its row's '%s'), on the plate: %s" % [hx, tag, String(info[hx][1]), str(shown)])
		if tag == "" or String(info[hx][1]) == "" or not shown:
			unseen.append(hx)
	ok(unseen.is_empty(), "§2: a hex is invisible on the hero's plate: %s" % [unseen])
	_clean(h)


# THE SELECTION (JO §2): the Orc Hexer's Bone Rattle, carrying Sap, is chosen as its attacks are — among the moves that deal damage —
# and is still chosen once every hero carries Sap, since a blow is never withheld for the status it lays. JL's hex, aimed past the
# draws at a hero who did not carry it and never once all did, went with the hex special.
func _s2_the_selection(s: Node, hexes: bool) -> void:
	print("\n§2 — the selection: a hex's blow chosen as an attack is")
	if not hexes:
		ok(false, "§2: the selection lays no hex — no hex in the tree")
		return
	var f: BattleUnit = _foes(s)[2]
	_as_kind(f, "hexer")
	for h in _heroes(s):
		_clean(h)
	var picked := {}
	for _i in 40:
		f.cooldowns = {}
		var c: Dictionary = s.call("_choose_enemy_action", f)
		var ab: Variant = c.get("ability")
		if ab is Ability:
			var nm := (ab as Ability).display_name
			picked[nm] = int(picked.get(nm, 0)) + 1
	var host := _hex_host(f, "sap")
	var name := host.display_name if host != null else "?"
	print("    the Hexer's choices over 40 on a clean board: %s" % str(picked))
	ok(host != null and int(picked.get(name, 0)) >= 1 and picked.size() >= 2, "§2: the Hexer's selection does not take the blow that carries Sap among its attacks: %s" % str(picked))
	var e: BattleUnit = _foes(s)[0]
	for h2 in _heroes(s):
		s._apply_status(h2, "sap", 3, 0, 0, e)
	var again := 0
	for _j in 30:
		f.cooldowns = {}
		var c2: Dictionary = s.call("_choose_enemy_action", f)
		if c2.get("ability") is Ability and (c2["ability"] as Ability).display_name == name:
			again += 1
	print("    with every hero carrying Sap: %s chosen %d of 30" % [name, again])
	ok(again >= 1, "§2: the Hexer withholds the blow that lays Sap once every hero carries it (%d of 30)" % again)
	for h3 in _heroes(s):
		_clean(h3)
	_as_kind(f, "shieldmaster")



# ── §3 — THE READING ──────────────────────────────────────────────────────────

func _s3_the_reading() -> void:
	print("\n§3 — the reading: the warband's blows a fight and each hex's uptime, as the kept table holds them")
	var lines := _doc(KEPT_DRIVE).split("\n", false)
	ok(lines.size() > 8, "§3: the kept table %s is not in the tree" % KEPT_DRIVE)
	var want := ["the warband's blows a fight, paired fights", "hero turns a fight, paired fights", "Gall: uptime on hero turns", "Sap: uptime on hero turns",
		"Mire: uptime on hero turns", "Fester: uptime on hero turns", "Malice spent a fight", "Rallies a fight", "falls a run"]
	var rows := {}
	for l in lines:
		var c := String(l).split("\t")
		if c.size() >= 3 and want.has(c[0].strip_edges()):
			rows[c[0].strip_edges()] = [c[1], c[2], c[3] if c.size() > 3 else ""]
	ok(rows.size() == want.size(), "§3: the kept table lacks a row the brief named: %s" % [want.filter(func(w): return not rows.has(w))])
	var block := _flat(_block(_doc("res://docs/state.md"), HEXES_HEAD))
	ok(block != "", "§3: the record holds no block on the warband's hexes")
	var gone: Array = []
	for k in rows:
		for fig in _figures(String(rows[k][0]) + " " + String(rows[k][1])):
			if not block.contains(fig):
				gone.append("%s: %s" % [k, fig])
	ok(gone.is_empty(), "§3: the record states the reading without the warband's blows a fight or each hex's uptime: %s" % [gone])
	print("    the reading held: %s" % str(rows))


func _figures(cell: String) -> Array:
	var rx := RegEx.new()
	rx.compile("[0-9]+\\.[0-9]+%?")
	var out: Array = []
	for m in rx.search_all(cell):
		out.append(m.get_string())
	return out


# ── §4 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s4_not_done(s: Node) -> void:
	print("\n§4 — the fill, the cap, the heals and the spends as JK left them; the deck closed; no kind and no move but the hexes")
	var moved: Array = []
	for k in FILL:
		if _const_i(s, k) != int(FILL[k]):
			moved.append("%s %d" % [k, _const_i(s, k)])
	if absf(_const_f(s, "MALICE_HEAL_WORTH") - HEAL_WORTH) > 0.0001:
		moved.append("MALICE_HEAL_WORTH %s" % str(_const(s, "MALICE_HEAL_WORTH")))
	var fig := Gate.fn_body("scripts/battle.gd", "_warband_heal_figure", _cache)
	for site in HEAL_SITES:
		if not fig.contains(site):
			moved.append("a heal no longer reads `%s`" % site)
	for k2 in SPEND_FIGURES:
		if absf(_const_f(s, k2) - float(SPEND_FIGURES[k2])) > 0.0001:
			moved.append("%s %s" % [k2, str(_const(s, k2))])
	if absf(_unit_f("MALICE_ENTRENCH_MULT") - 2.0) > 0.0001:
		moved.append("MALICE_ENTRENCH_MULT %s" % str(_unit_f("MALICE_ENTRENCH_MULT")))
	# THE SPENDS' COOLDOWNS: each kind's spends as JK's kept table holds them.
	var data: Dictionary = Enemies._load()
	for r in _doc(KEPT_SPENDS).split("\n", false).slice(1):
		var c := String(r).split("\t")
		if c.size() < 6 or not data.has(c[0]):
			continue
		var have := []
		for a in data[c[0]]["abilities"]:
			if String(a.get("special", "")).begins_with("malice_"):
				have.append("%s %d" % [String(a["display_name"]), int(a.get("cooldown", 0))])
		if c[5] != ", ".join(PackedStringArray(have)):
			moved.append("%s's spends %s, JK's '%s'" % [c[0], str(have), c[5]])
	ok(moved.is_empty(), "§4: the fill, the cap, a heal's price or a spend's figure moved: %s" % [moved])
	ok((_run.MODIFIERS as Dictionary).size() == DECK_CLOSED_AT, "§4: the deck holds %d, not the twenty-five it closed at" % (_run.MODIFIERS as Dictionary).size())
	var moves := 0
	var hex_moves := 0
	for k3 in data:
		if ADDED_SINCE.has(String(k3)):
			continue
		for a2 in (data[k3] as Dictionary).get("abilities", []):
			var sp := String(a2.get("special", ""))
			if _lays(a2) != "":
				hex_moves += 1
			if not sp.begins_with("malice_"):
				moves += 1
	print("    %d kinds, %d moves beside the spends, %d of them laying a hex" % [data.size(), moves, hex_moves])
	var kinds_then := data.keys().filter(func(k): return not ADDED_SINCE.has(String(k))).size()
	ok(kinds_then == KINDS and moves == MOVES_BEFORE, "§4: the warband holds %d kinds and %d moves beside its spends, not %d and %d" % [kinds_then, moves, KINDS, MOVES_BEFORE])


# ── §5 — THE TEXTS FOLLOW THE CONSTANTS ───────────────────────────────────────

func _s5_the_texts(s: Node, hexes: bool) -> void:
	print("\n§5 — what each hex does, stated off its constant")
	var gall := int(round(_unit_f("GALL_HEAL_CUT") * 100))
	var sap := int(round(_unit_f("SAP_CUT") * 100))
	var mire := int(round(_unit_f("MIRE_SLOW") * 100))
	var dot: Dictionary = _const(s, "DOT_STATUSES") if _const(s, "DOT_STATUSES") != null else {}
	var fester := int(dot.get("fester", -1))
	var turns := {}
	for kind in Enemies._load():
		for a in Enemies._load()[kind]["abilities"]:
			if _lays(a) != "":
				turns[_lays(a)] = int(a["applies_status"]["turns"])
	var sentence := "Gall cuts the healing every hero receives by %d%% for %d turns; Sap cuts what a hero's resource bar gains by %d%% for %d turns; Mire makes a hero act %d%% slower for %d turns; Fester deals %d%% of its applier's Attack a stack at each of the hero's turn starts and gains a stack each turn, until it is cleansed." % [
		gall, int(turns.get("gall", -1)), sap, int(turns.get("sap", -1)), mire, int(turns.get("mire", -1)), fester]
	ok(_flat(_block(_doc("res://docs/state.md"), HEXES_HEAD)).contains(sentence), "§5: the state does not state what each hex does off the constants: '%s'" % sentence)
	ok(_untagged(_doc("res://docs/master.html")).contains(sentence), "§5: the master document does not state what each hex does off the constants: '%s'" % sentence.left(160))
	ok(_flat(_block(_doc("res://docs/state.md"), "## WHERE THE PROJECT IS")).contains(sentence), "§5: the WHERE block does not state what each hex does off the constants")
	ok(_flat(_block(_doc("res://docs/state.md"), SPENDS_HEAD)).contains(FREE_RULE), "§5: the state does not say a spend costs its body no turn")
	if not hexes:
		ok(false, "§5: a hex's chip and glossary line do not state its figure — no hex in the tree")
		return
	# THE CHIP, THE GLOSSARY AND THE MOVE's OWN WORDS READ THE CONSTANT.
	var info: Dictionary = _const(s, "STATUS_INFO")
	var want := {"gall": "%d%%" % gall, "sap": "%d%%" % sap, "mire": "%d%%" % mire, "fester": "%d%%" % fester}
	var off: Array = []
	var data: Dictionary = Enemies._load()
	for hx in HEXES:
		if not String(info[hx][3]).contains(String(want[hx])):
			off.append("%s's chip" % hx)
		var g := Glossary.entry("status_" + hx)
		if g.is_empty() or not (String(g.get("short", "")) + " " + String(g.get("long", ""))).contains(String(want[hx])):
			off.append("%s's glossary line" % hx)
	for kind in data:
		for ab in Enemies.config(String(kind))["abilities"]:
			if _ab_lays(ab as Ability) != "":
				var id := _ab_lays(ab as Ability)
				if not (ab as Ability).description.contains(String(want.get(id, "?"))):
					off.append("%s's %s" % [kind, (ab as Ability).display_name])
				for ln in (ab as Ability).description.split("\n"):
					if String(ln).length() > 44:
						off.append("%s's %s runs past 44 characters" % [kind, (ab as Ability).display_name])
	ok(off.is_empty(), "§5: a hex's text does not state its figure off the constant: %s" % [off])


# ── §6 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s6_the_players_files() -> void:
	print("\n§6 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§6: %s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
