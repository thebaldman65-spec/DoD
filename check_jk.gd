# BATCH JK — WHAT THE WARBAND BUYS WITH ITS MALICE.
#
#   §0   JJ's SIX RULINGS, ANSWERED: the block left the open queue for the archive, struck, with the answer (H02).
#   §1   EVERY KIND CAN BUY SOMETHING, DERIVED OFF THE DATA AND NEVER LISTED: every kind's kit holds a move the pool prices that
#        is no heal, every one holds a Rally or an Entrench, and on a board where the pool is full, a body is down and nothing
#        is hurt, warded or rallied, every kind's own selection declares one (C01); the kept table is the data's. RAISE stands a
#        fallen body up at its share of its health, un-Broken, once a body a fight (C02, C03); RALLY's blow is struck harder and
#        no heal it reaches restores or pays past its figure, so the reserve's arithmetic stands (C04); ENTRENCH is read at the one
#        door every blow's armor passes, and a blow reads it there (C05); OVERRUN is absent and the record says so, and nothing
#        puts a body into the warband once a fight has opened (C06); a spend is a move on a list, chosen by the support half,
#        paid in its arm, never a side's action (C09).
#   §2   THE PRICES: a Raise by the health it stands a body up with, a Rally and an Entrench flat — each on its own line (C07);
#        the selection never takes a spend the pool cannot pay and takes one it can, and a declared spend sets its price aside
#        (C08); every spend cools, by JI's line, read out of `check_ji` (C10).
#   §3   THE READING: the record holds the drive's ledger and its spend counts, as the kept table holds them (C11).
#   §4   WHAT IS DELIBERATELY NOT DONE: the fill, the cap and every heal's price as JJ left them (C12); the deck at twenty-five
#        (C13); no enemy kind added, and no move but the spends.
#   §5   THE TEXTS FOLLOW THE CONSTANTS: the state and the master document state what each spend buys and costs off the
#        constants, and the strip's words name them (R01).
#   §6   THE PLAYER's FILES, as this gate found them.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2). Every driven arm asks first whether the
#   machinery it drives exists, so HEAD's tree reds on each arm rather than throwing past the rest (H01).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jk.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# JI's LINE AND ITS BREAK PRICE (JO §1): the one blow and the one price, read where they stand.
const JI = preload("res://check_ji.gd")

# BATCH JS — SEVEN KINDS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its boss. Each
# is named here and read apart, so this gate goes on asking its own question of the warband its batch left; `check_js` holds
# the seven. (Rosters 4 and 5 joined too; nothing this gate counts reads a roster.)
# BATCH JU §1 — AND THE FOUR KINDS JU ADDED TO THE FOREST OF OLD, set aside as JS's seven are: this gate holds the warband its
# batch left, and a kind added after it is no figure of that warband moving.
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan",
	"grave_husk", "mossback", "blight_speaker", "carrion_pack"]
const KINDS := 21
# JK's fifty, and since JO §2 Gall and Mire among them, each a blow given damage (Sap and Fester ride two of the fifty).
const MOVES_BEFORE := 52
const DECK_CLOSED_AT := 25
# THE FILL AND THE HEALS AS JJ LEFT THEM (§4): a point a ten, a kill's 25, the cap of 150, hurt at half a heal's figure.
const FILL := {"MALICE_DAMAGE_STEP": 10, "MALICE_PER_KILL": 25, "MALICE_CAP": 150}
const HEAL_WORTH := 0.5
const HEAL_SITES := ["target.max_hp * 0.25", "target.max_hp * 0.20", "tp_a.max_hp * 0.06"]
# THE SPENDS' PRICING BY JI's LINE (§2): a spend's worth on the reference board against its own kind's basic. A Raise the health
# it stands the median composable body up with; a Rally what it adds to four bodies' blows at the warband's median basic; an
# Entrench the armor cut it takes again on four bodies, the cut a warband turn read off JA's census of the reference party.
const REACH := 4
const CENSUS_CUT := 93066.9
const CENSUS_TURNS := 10508.0
const CENSUS_TABLE := "res://docs/reports/JA-shares.tsv"
const LINE_SOURCE := "res://check_ji.gd"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["totemist", "raider", "shieldmaster", "brute", "slinger", "chief"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://jk_profile.json"
const SCRATCH_RELICS := "user://jk_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const ANSWERED := "all accepted as taken"
const SPENDS_HEAD := "### THE WARBAND's SPENDS"
const OVERRUN_RECORD := "There is no Overrun"
const OVERRUN_TAKES := "a place in the turn order"
const KEPT_COVER := "res://docs/reports/JK-spends.tsv"
const KEPT_DRAIN := "res://docs/reports/JK-drain.tsv"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}
var _spends: Array = []   # [kind, move, special], derived by §1


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JK — WHAT THE WARBAND BUYS WITH ITS MALICE")
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
	var spends := _has_spends(s)
	ok(spends, "§1: the battle holds no spend — no Raise, no Rally, no Entrench (the warband has nothing to buy but a heal)")
	await _s1_every_kind_buys(s, spends)
	await _s1_raise(s, spends)
	await _s1_rally(s, spends)
	await _s1_entrench(s, spends)
	_s1_overrun()
	_s1_the_shape(spends)
	_s2_the_prices(s, spends)
	_s2_the_cooldowns(s, spends)
	_s3_the_reading()
	_s4_not_done(s)
	_s5_the_texts(s, spends)
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


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves the pool.
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


func _has_spends(s: Node) -> bool:
	for m in ["_warband_spend", "_spend_price", "_raise_figure", "_raise_holds", "_find_spend", "_malice_price", "_malice_pay"]:
		if not s.has_method(m):
			return false
	return _const(s, "MALICE_SPENDS") != null and s.get("_malice_raised") != null


func _const(s: Node, name: String) -> Variant:
	return (s.get_script() as Script).get_script_constant_map().get(name)


# A constant as a number, -1 where the tree holds none — HEAD's has no spend, and a throw would hide the arms below it.
func _const_f(s: Node, name: String) -> float:
	var v: Variant = _const(s, name)
	return float(v) if v != null else -1.0


func _const_i(s: Node, name: String) -> int:
	var v: Variant = _const(s, name)
	return int(v) if v != null else -1


# A constant of the unit script, -1 where the tree holds none (HEAD's has no Entrench).
func _unit_f(name: String) -> float:
	var v: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get(name)
	return float(v) if v != null else -1.0


func _spend_specials(s: Node) -> Array:
	var v: Variant = _const(s, "MALICE_SPENDS")
	return (v as Array) if v != null else []


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


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
	for st in ["charging", "mocked", "heads_down", "psychosis", "hysteria", "bewitch"]:
		f.remove_status(st)


func _spend_of(u: BattleUnit, special: String) -> Ability:
	for a in u.abilities:
		if String((a as Ability).special) == special:
			return a
	return null


# THE BOARD A SPEND IS WANTED ON: every standing body whole, undeclared, warded (so no ward is wanted) and carrying no Rally or
# Entrench; the last body down and not raised; the pool full.
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
	_pool(s, _const_i(s, "MALICE_CAP"))
	return corpse


# The specials a foe declares as its spend, over n declarations — JL §1: a spend rides the body's declaration beside its action,
# so the declaration is where it is chosen ("" where none rides).
func _chosen(s: Node, f: BattleUnit, n: int) -> Dictionary:
	var got := {}
	for _i in n:
		var c := _spend_chosen(s, f)
		var sp := String((c["ability"] as Ability).special) if not c.is_empty() else ""
		got[sp] = int(got.get(sp, 0)) + 1
	return got


# The spend a foe's declaration carries, {} where none rides: the declaration made afresh, then cleared.
func _spend_chosen(s: Node, f: BattleUnit) -> Dictionary:
	f.intent = {}
	s.call("_declare_intent", f)
	var sp: Variant = f.intent.get("spend", {})
	f.intent = {}
	return sp if sp is Dictionary and (sp as Dictionary).get("ability") is Ability else {}


# ── §0 — JJ's SIX RULINGS ─────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JJ's six rulings, answered and archived")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n### JJ's RULINGS OWED"), "§0: ### JJ's RULINGS OWED is still in the open queue — it was answered")
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JJ's RULINGS OWED~~"))
	ok(struck.contains(ANSWERED), "§0: the archive does not hold JJ's rulings struck and answered")
	# EVERY LIVING CITATION FOLLOWS: an answered ruling is cited as accepted, never as owed.
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/master.html", "res://scripts/battle.gd",
			"res://scripts/unit.gd", "res://docs/instrument-rules.md"]:
		if _doc(p).contains("JJ's RULINGS OWED"):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])


# ── §1 — EVERY KIND CAN BUY SOMETHING ─────────────────────────────────────────

func _s1_every_kind_buys(s: Node, spends: bool) -> void:
	print("\n§1 — every kind of the warband can buy something, derived off the data")
	if not spends:
		for w in ["§1: a kind holds no move the pool buys — no spend in the tree", "§1: a kind declares no spend on a board that wants one — no spend in the tree"]:
			ok(false, w)
		return
	var specials := _spend_specials(s)
	var f: BattleUnit = _foes(s)[0]
	var data: Dictionary = Enemies._load()
	var holds := {}
	var none: Array = []
	var no_floor: Array = []
	var no_buy: Array = []
	var own_cooling := 0
	var own_cooling_buy := 0
	for kind in data:
		_as_kind(f, String(kind))
		var corpse := _spend_board(s)
		var mine: Array = []
		var cooled_before := false
		for a in f.abilities:
			var ab: Ability = a
			# A MOVE THE POOL BUYS THAT IS NO HEAL: priced on the body it would name — the caster itself, or the body down.
			var priced := int(s.call("_malice_price", f, ab, f)) > 0 or int(s.call("_malice_price", f, ab, corpse)) > 0
			if priced and String(s.call("_intent_category", f, ab)) != "mend":
				mine.append(ab.display_name)
				_spends.append([String(kind), ab.display_name, String(ab.special)])
			elif ab.cooldown > 0:
				cooled_before = true
		holds[kind] = mine
		if mine.is_empty():
			none.append(String(kind))
		if _spend_of(f, "malice_rally") == null and _spend_of(f, "malice_entrench") == null:
			no_floor.append(String(kind))
		var got := _chosen(s, f, 6)
		var bought := false
		for sp in got:
			if specials.has(sp):
				bought = true
		if not bought:
			no_buy.append("%s chose %s" % [kind, str(got)])
		if not cooled_before:
			own_cooling += 1
			if not mine.is_empty():
				own_cooling_buy += 1
		print("    %-16s buys %s; its selection on the board: %s" % [kind, str(mine), str(got)])
	print("    CHECKED %d of %d kinds; %d spends on their lists; the kinds that own no cooling move of their own: %d, and %d of them hold a spend" % [
		holds.size(), KINDS, _spends.size(), own_cooling, own_cooling_buy])
	ok(holds.size() == KINDS + ADDED_SINCE.size(), "§1: the walk read %d kinds, not %d" % [holds.size(), KINDS + ADDED_SINCE.size()])
	ok(none.is_empty(), "§1: a kind holds no move the pool buys: %s" % [none])
	ok(no_floor.is_empty(), "§1: a kind holds neither a Rally nor an Entrench, the pair every kind can buy: %s" % [no_floor])
	ok(no_buy.is_empty(), "§1: a kind declares no spend on a board that wants one: %s" % [no_buy])
	# THE KEPT TABLE IS THE DATA's: each kind's row names the spends its list holds, each with the cooldown it carries.
	var rows := _doc(KEPT_COVER).split("\n", false)
	ok(rows.size() == KINDS + 1, "§1: the kept table %s holds %d rows, not a header and %d kinds" % [KEPT_COVER, rows.size(), KINDS])
	var wrong: Array = []
	for r in rows.slice(1):
		var c := String(r).split("\t")
		if c.size() < 6 or not data.has(c[0]):
			wrong.append(String(r).left(60))
			continue
		var want := []
		for nm in holds.get(c[0], []):
			want.append("%s %d" % [nm, _data_cd(c[0], String(nm))])
		if c[5] != ", ".join(PackedStringArray(want)):
			wrong.append("%s: the table says '%s', the data '%s'" % [c[0], c[5], ", ".join(PackedStringArray(want))])
	ok(wrong.is_empty(), "§1: the kept table does not say what each kind holds as the data does: %s" % [wrong])
	_pool(s, 0)


func _data_cd(kind: String, name: String) -> int:
	for a in (Enemies._load()[kind] as Dictionary).get("abilities", []):
		if String(a.get("display_name", "")) == name:
			return int(a.get("cooldown", 0))
	return -1


# RAISE (C02, C03): the body falls Broken, stands up un-Broken at its share of its health, the pool paying that health; it is
# not raised twice.
func _s1_raise(s: Node, spends: bool) -> void:
	print("\n§1 — Raise: a fallen body stands up at its share of its health, un-Broken, once a fight")
	if not spends:
		for w in ["§1: Raise stood no body up — no Raise in the tree", "§1: a body was raised twice in one fight — no Raise to ask"]:
			ok(false, w)
		return
	var foes := _foes(s)
	var f: BattleUnit = foes[0]
	_as_kind(f, "totemist")
	var raise := _spend_of(f, "malice_raise")
	ok(raise != null, "§1: the premise — the Totemist holds a Raise")
	if raise == null:
		return
	var c := _spend_board(s)
	# IT FALLS BROKEN: one blow fills the Break meter and takes the last of its health.
	c.hp = c.max_hp
	c.dead = false
	c.hp = 20
	c.pressure = c.stability - 5
	# A DECLARATION IT DIES WITH, a reserve set aside: the Raise must take it away with the corpse.
	c.intent = {"ability": raise, "target": c, "turns": 1, "support": true, "malice": 7, "gate_sentinel": true}
	s.call("_dmg_frame", null, "")
	c.take_hit(60, 40)
	ok(c.dead, "§1: the premise — the body did not fall")
	var cap := _const_i(s, "MALICE_CAP")
	_pool(s, cap)
	var pct := _const_f(s, "MALICE_RAISE_PCT")
	var want := maxi(int(c.max_hp * pct), 1)
	var spent0 := _spent(s)
	await s._resolve(f, raise, c, "good")
	var paid := cap - int(s.get("malice"))
	print("    a body of %d fell Broken; raised: dead %s, health %d (its share %d), Broken %s, chip %s; the pool paid %d (booked %d)" % [
		c.max_hp, c.dead, c.hp, want, c.broken, c.has_status("broken"), paid, _spent(s) - spent0])
	ok(not c.dead, "§1: Raise stood no body up")
	ok(not c.broken and not c.has_status("broken") and not c.broken_pending, "§1: Raise stood a body up Broken")
	ok(c.hp == want, "§1: Raise stood a body up at %d, not %d%% of its health (%d)" % [c.hp, int(round(pct * 100)), want])
	ok(paid == c.hp and _spent(s) - spent0 == paid, "§1: Raise paid %d (booked %d), not the %d health it stood the body up with" % [paid, _spent(s) - spent0, c.hp])
	ok(not c.intent.has("gate_sentinel"), "§1: the raised body kept the declaration it died with, and its reserve")
	# TWO RAISERS, ONE CORPSE: a second body's declared Raise on the corpse keeps this raiser off it; gone, the corpse is its again.
	var f2: BattleUnit = foes[1]
	_as_kind(f2, "chanter")
	var c2: BattleUnit = foes[4]
	c2.hp = 1
	c2.take_hit(5, 0)
	for wh in _foes(s):
		(wh as BattleUnit).hp = (wh as BattleUnit).max_hp
	_pool(s, cap)
	f.cooldowns = {}
	# JL §1 — a declared Raise rides its body's declaration as its spend.
	f2.intent = {"spend": {"ability": _spend_of(f2, "malice_raise"), "target": c2, "malice": maxi(int(c2.max_hp * pct), 1)}}
	var named := 0
	for _j in 20:
		var ch2 := _spend_chosen(s, f)
		if not ch2.is_empty() and String((ch2["ability"] as Ability).special) == "malice_raise" and ch2["target"] == c2:
			named += 1
	f2.intent = {}
	var freed := 0
	for _k in 20:
		var ch3 := _spend_chosen(s, f)
		if not ch3.is_empty() and String((ch3["ability"] as Ability).special) == "malice_raise" and ch3["target"] == c2:
			freed += 1
	print("    a corpse a second raiser has declared on: chosen %d of 20 times; with that declaration gone, %d of 20" % [named, freed])
	ok(named == 0 and freed > 0, "§1: two raisers took one corpse (chosen %d of 20 beside the other's declaration, %d of 20 without it)" % [named, freed])
	_as_kind(f2, "raider")
	c2.revive(1.0)
	c2.intent = {}
	# ONCE A BODY, A FIGHT: it falls again, the pool is full, and neither the selection nor the move itself stands it up.
	c.hp = 1
	c.take_hit(5, 0)
	_pool(s, cap)
	f.cooldowns = {}
	var again := 0
	for _i in 30:
		var ch := _spend_chosen(s, f)
		if not ch.is_empty() and String((ch["ability"] as Ability).special) == "malice_raise" and ch["target"] == c:
			again += 1
	await s._resolve(f, raise, c, "good")
	print("    fallen again: chosen %d of 30 times; the move itself left it dead %s, the pool at %d" % [again, c.dead, int(s.get("malice"))])
	ok(again == 0 and c.dead and int(s.get("malice")) == cap, "§1: a body was raised twice in one fight (chosen %d of 30, dead %s, the pool %d of %d)" % [again, c.dead, int(s.get("malice")), cap])
	f.cooldowns = {}
	_pool(s, 0)


# RALLY (C04): every standing body rallied for its turns; a rallied blow struck harder; a heal it reaches restores and pays its
# figure, no more, so a reserve set aside for it is what it pays.
func _s1_rally(s: Node, spends: bool) -> void:
	print("\n§1 — Rally: the warband's blows land harder, and no heal is reached")
	var strike := Gate.fn_body("scripts/battle.gd", "_resolve", _cache)
	ok(strike.contains("if attacker.has_status(\"warband_rally\"):\n\t\t\t\traw *= 1.0 + MALICE_RALLY_PCT\n"), "§1: Rally is not read in the strike loop")
	var near: Array = []
	for fn in ["_warband_heal_figure", "_warband_heal", "_malice_price", "_malice_hurt", "_spend_price"]:
		if Gate.fn_body("scripts/battle.gd", fn, _cache).contains("warband_rally") or Gate.fn_body("scripts/battle.gd", fn, _cache).contains("MALICE_RALLY_PCT"):
			near.append(fn)
	ok(near.is_empty(), "§1: Rally's multiplier is read beside a warband heal or its price, in %s" % [near])
	if not spends:
		for w in ["§1: Rally laid no Rally — no Rally in the tree", "§1: a rallied blow landed no harder — no Rally", "§1: a heal under a Rally restored or paid past its figure — no Rally"]:
			ok(false, w)
		return
	var foes := _foes(s)
	var f: BattleUnit = foes[1]
	var a: BattleUnit = foes[2]
	var b: BattleUnit = foes[3]
	_as_kind(f, "raider")
	var rally := _spend_of(f, "malice_rally")
	ok(rally != null, "§1: the premise — the Raider holds a Rally")
	if rally == null:
		return
	_spend_board(s)
	var cap := _const_i(s, "MALICE_CAP")
	var turns := _const_i(s, "MALICE_RALLY_TURNS")
	var pct := _const_f(s, "MALICE_RALLY_PCT")
	# A BLOW BEFORE THE RALLY AND THE SAME BLOW AFTER IT, on the same dice: the warband's own body struck by its own.
	var blow: Ability = Ability.make({"display_name": "The Gate's Blow", "damage": 160, "pressure": 0})
	for st in ["shielded"]:
		b.remove_status(st)
	b.hp = b.max_hp
	seed(7701)
	await s._resolve(a, blow, b, "good")
	var d0 := b.max_hp - b.hp
	_pool(s, cap)
	await s._resolve(f, rally, f, "good")
	var laid: Array = []
	for e in _foes(s):
		if int((e as BattleUnit).get_status("warband_rally").get("turns", -1)) != turns:
			laid.append((e as BattleUnit).unit_name)
	print("    a Rally: %d bodies standing, %s without it at %d turns; the pool paid %d" % [_foes(s).size(), str(laid), turns, cap - int(s.get("malice"))])
	ok(laid.is_empty(), "§1: Rally laid no Rally for %d turns on %s" % [turns, str(laid)])
	b.hp = b.max_hp
	b.remove_status("warband_rally")
	b.remove_status("shielded")
	seed(7701)
	await s._resolve(a, blow, b, "good")
	var d1 := b.max_hp - b.hp
	print("    the warband's blow on its own: %d before the Rally, %d under it (%.2f times; the rule %.2f)" % [d0, d1, float(d1) / maxf(d0, 1), 1.0 + pct])
	ok(d0 > 0 and absf(d1 - d0 * (1.0 + pct)) <= 2.0, "§1: a rallied blow landed %d where %d without it is %.0f with a Rally" % [d1, d0, d0 * (1.0 + pct)])
	b.hp = b.max_hp
	# THE HEAL UNDER A RALLY: a rallied Totemist mends a body; it restores its figure, pays it, and a declaration set exactly that aside.
	var t: BattleUnit = foes[0]
	_as_kind(t, "totemist")
	s._apply_status(t, "warband_rally", turns, 0, 0, f)
	var wave: Ability = null
	for ab in t.abilities:
		if (ab as Ability).display_name == "Healing Wave":
			wave = ab
	var hurt: BattleUnit = foes[4]
	hurt.hp = int(hurt.max_hp * 0.3)
	var fig := int(s.call("_warband_heal_figure", "healing_wave", hurt))
	var price := int(s.call("_malice_price", t, wave, hurt)) if wave != null else -1
	_pool(s, cap)
	t.intent = {}
	s.call("_declare_intent", t)
	var reserve := int(t.intent.get("malice", -1)) if not t.intent.is_empty() and (t.intent["ability"] as Ability) == wave else -1
	t.intent = {}
	var hp0 := hurt.hp
	if wave != null:
		await s._resolve(t, wave, hurt, "good")
	var restored := hurt.hp - hp0
	var paid := cap - int(s.get("malice"))
	print("    a rallied Totemist's Healing Wave: its figure %d, priced %d, set aside %d; it restored %d and the pool paid %d" % [fig, price, reserve, restored, paid])
	ok(wave != null and restored == fig and paid == fig and price == fig and reserve == fig,
		"§1: a heal under a Rally restored or paid past its figure: figure %d, priced %d, set aside %d, restored %d, paid %d" % [fig, price, reserve, restored, paid])
	for e in _foes(s):
		(e as BattleUnit).remove_status("warband_rally")
	_pool(s, 0)


# ENTRENCH (C05): read at the one door every blow's armor passes, and nowhere else; a blow on an entrenched body reads it there.
func _s1_entrench(s: Node, spends: bool) -> void:
	print("\n§1 — Entrench: the warband's armor multiplied, at its one door")
	ok(Gate.fn_body("scripts/unit.gd", "effective_armor", _cache).contains("if has_status(\"warband_entrench\"):\n\t\ta *= MALICE_ENTRENCH_MULT\n"),
		"§1: Entrench is not read at the armor's one door, `effective_armor()`")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")) + Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var reads := src.count("has_status(\"warband_entrench\")")
	print("    the reads of an Entrench in the code: %d (the door, and the policy's one ask)" % reads)
	ok(reads == 2, "§1: Entrench is read at %d sites, not the armor's door and the policy that asks whether one stands" % reads)
	if not spends:
		for w in ["§1: Entrench laid no Entrench — no Entrench in the tree", "§1: an entrenched body's armor is not multiplied at its door — no Entrench"]:
			ok(false, w)
		return
	var foes := _foes(s)
	var f: BattleUnit = foes[2]
	var a: BattleUnit = foes[3]
	var b: BattleUnit = foes[1]
	_as_kind(f, "shieldmaster")
	var entrench := _spend_of(f, "malice_entrench")
	ok(entrench != null, "§1: the premise — the Shieldmaster holds an Entrench")
	if entrench == null:
		return
	_spend_board(s)
	var mult := _unit_f("MALICE_ENTRENCH_MULT")
	var cap := _const_i(s, "MALICE_CAP")
	var turns := _const_i(s, "MALICE_ENTRENCH_TURNS")
	var blow: Ability = Ability.make({"display_name": "The Gate's Blow", "damage": 60, "pressure": 0})
	b.remove_status("shielded")
	b.hp = b.max_hp
	var arm0 := b.effective_armor()
	seed(7702)
	await s._resolve(a, blow, b, "good")
	var d0 := b.max_hp - b.hp
	_pool(s, cap)
	await s._resolve(f, entrench, f, "good")
	var laid: Array = []
	for e in _foes(s):
		if int((e as BattleUnit).get_status("warband_entrench").get("turns", -1)) != turns:
			laid.append((e as BattleUnit).unit_name)
	ok(laid.is_empty(), "§1: Entrench laid no Entrench for %d turns on %s" % [turns, str(laid)])
	b.remove_status("shielded")
	var arm1 := b.effective_armor()
	b.hp = b.max_hp
	seed(7702)
	await s._resolve(a, blow, b, "good")
	var d1 := b.max_hp - b.hp
	var want := d0 * (1.0 - minf(arm0 * mult, 0.85)) / maxf(1.0 - arm0, 0.01)
	print("    the armor: %.3f, entrenched %.3f (%.0f times); the warband's blow on its own: %d, entrenched %d (the door's %.1f); the pool paid %d" % [
		arm0, arm1, mult, d0, d1, want, cap - int(s.get("malice"))])
	ok(arm0 > 0.0 and absf(arm1 - minf(arm0 * mult, 0.85)) < 0.0001, "§1: an entrenched body's armor is not multiplied at its door: %.3f, not %.3f" % [arm1, minf(arm0 * mult, 0.85)])
	ok(d0 > 0 and absf(d1 - want) <= 2.0, "§1: a blow on an entrenched body landed %d, not the %.0f its door's armor gives — the multiplier is read at a second door" % [d1, want])
	b.hp = b.max_hp
	for e in _foes(s):
		(e as BattleUnit).remove_status("warband_entrench")
	_pool(s, 0)


# OVERRUN (C06): no body joins the warband once a fight has opened, no kind's list holds one, and the record says so.
func _s1_overrun() -> void:
	print("\n§1 — Overrun: no body joins the warband mid-fight, and the record says so")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var adders: Array = []
	for chunk in src.split("\nfunc "):
		if chunk.contains("enemies.append(") or chunk.contains("enemies.push_back(") or chunk.contains("enemies.insert(") \
				or chunk.contains("enemies.append_array(") or chunk.contains("enemies += ") or chunk.contains("enemies = enemies +"):
			adders.append(String(chunk.split("(")[0]).strip_edges())
	print("    the functions that put a body into the warband: %s" % str(adders))
	ok(adders == ["_spawn_units"], "§1: a body joins the warband outside the fight's opening, in %s — an Overrun's body would need its place in the order" % str(adders))
	var data: Dictionary = Enemies._load()
	var named: Array = []
	for kind in data:
		for a in data[kind]["abilities"]:
			if String(a.get("display_name", "")) == "Overrun" or String(a.get("special", "")).contains("overrun"):
				named.append(String(kind))
	ok(named.is_empty(), "§1: a kind holds an Overrun the game cannot field: %s" % [named])
	var block := _flat(_block(_doc("res://docs/state.md"), SPENDS_HEAD))
	ok(block.contains(OVERRUN_RECORD) and block.contains(OVERRUN_TAKES), "§1: Overrun's absence is not reported — the record does not say there is none and what it would take")
	ok(not _untagged(_doc("res://docs/master.html")).contains("Overrun"), "§1: the master document names an Overrun the game does not hold")


# THE SHAPE (C09): a spend is a move on a list, chosen by the support half and paid in its own arm, never a side's action.
func _s1_the_shape(spends: bool) -> void:
	print("\n§1 — the shape: a spend is a move on a kind's list")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var payers: Array = []
	for chunk in src.split("\nfunc "):
		if chunk.contains("_malice_pay("):
			payers.append(String(chunk.split("(")[0]).strip_edges())
	payers.sort()
	print("    the functions that pay out of the pool: %s" % str(payers))
	ok(payers == ["_malice_pay", "_resolve_special", "_warband_heal"], "§1: the pool is paid by %s, not its definition, a move's own arm and the heal's payment — a side's action" % str(payers))
	var callers: Array = []
	for chunk2 in src.split("\nfunc "):
		if chunk2.contains("_warband_spend(") and not chunk2.begins_with("_warband_spend("):
			callers.append(String(chunk2.split("(")[0]).strip_edges())
	# JL §1 — A SPEND IS CHOSEN BY THE BODY's OWN DECLARATION NOW, beside its action, and bought free on its turn: still never a
	# side's action (`check_jl` §1 holds the turn).
	ok(callers == ["_declare_intent"], "§1: the spends are chosen by %s, not the declaration of a body's own turn" % str(callers))
	var listed: Array = []
	if spends:
		var data: Dictionary = Enemies._load()
		for sp in ["malice_raise", "malice_rally", "malice_entrench"]:
			var on := false
			for kind in data:
				for a in data[kind]["abilities"]:
					if String(a.get("special", "")) == sp:
						on = true
			if not on:
				listed.append(sp)
	ok(spends and listed.is_empty(), "§1: a spend stands on no kind's list: %s" % [listed])


# ── §2 — THE PRICES AND THE COOLDOWNS ─────────────────────────────────────────

func _s2_the_prices(s: Node, spends: bool) -> void:
	print("\n§2 — the prices: health for a Raise, flat for a Rally and an Entrench")
	if not spends:
		for w in ["§2: a Raise is not priced at the health it stands a body up with — no Raise", "§2: a Rally is not priced flat — no Rally",
				"§2: an Entrench is not priced flat — no Entrench", "§2: the selection took a spend the pool cannot pay — no spend"]:
			ok(false, w)
		return
	var all := _all(s)
	var f: BattleUnit = _foes(s)[0]
	var pct := _const_f(s, "MALICE_RAISE_PCT")
	# A RAISE BY HEALTH (C07): two bodies of different health, two prices, each the health it would stand that body up with.
	_as_kind(f, "totemist")
	var raise := _spend_of(f, "malice_raise")
	if raise == null:
		ok(false, "§2: the premise — the Totemist holds no Raise to price")
		return
	var by_body: Array = []
	for e in all.slice(1):
		var u: BattleUnit = e
		var pr := int(s.call("_malice_price", f, raise, u))
		if pr != maxi(int(u.max_hp * pct), 1):
			by_body.append("%s of %d priced %d" % [u.unit_name, u.max_hp, pr])
	var distinct := {}
	for e2 in all.slice(1):
		distinct[int(s.call("_malice_price", f, raise, e2))] = true
	print("    a Raise priced on bodies of %s health: %s" % [str(all.slice(1).map(func(x): return (x as BattleUnit).max_hp)), str(distinct.keys())])
	ok(by_body.is_empty() and distinct.size() >= 2, "§2: a Raise is not priced at the health it stands a body up with: %s" % [by_body])
	# A RALLY AND AN ENTRENCH FLAT: the same price on every body, the constant's.
	var flats := {"malice_rally": ["raider", "MALICE_RALLY_PRICE", "Rally"], "malice_entrench": ["shieldmaster", "MALICE_ENTRENCH_PRICE", "Entrench"]}
	for sp in flats:
		_as_kind(f, String(flats[sp][0]))
		var ab := _spend_of(f, String(sp))
		if ab == null:
			ok(false, "§2: the premise — the %s holds no %s to price" % [flats[sp][0], flats[sp][2]])
			continue
		var want := _const_i(s, String(flats[sp][1]))
		var seen := {}
		for e3 in all:
			seen[int(s.call("_malice_price", f, ab, e3))] = true
		print("    %s priced on every body: %s (the constant %d)" % [flats[sp][2], str(seen.keys()), want])
		ok(seen.keys() == [want] and want > 0, "§2: %s %s is not priced flat at %d: %s" % ["a" if sp == "malice_rally" else "an", flats[sp][2], want, str(seen.keys())])
	# THE SELECTION's DOOR (C08): one point short of the price, never chosen; at the price, chosen; a declaration sets it aside.
	var refused: Array = []
	var never: Array = []
	var unheld: Array = []
	for entry in [["totemist", "malice_raise"], ["raider", "malice_rally"], ["shieldmaster", "malice_entrench"]]:
		_as_kind(f, String(entry[0]))
		var c := _spend_board(s)
		var ab2 := _spend_of(f, String(entry[1]))
		if ab2 == null:
			never.append("%s holds no %s" % [entry[0], entry[1]])
			continue
		var body := c if entry[1] == "malice_raise" else f
		var price := int(s.call("_malice_price", f, ab2, body))
		for pool in [0, price - 1]:
			_pool(s, maxi(pool, 0))
			var got := _chosen(s, f, 20)
			if int(got.get(entry[1], 0)) > 0:
				refused.append("%s's %s chosen %d of 20 times with %d in the pool against a price of %d" % [entry[0], ab2.display_name, int(got[entry[1]]), maxi(pool, 0), price])
		_pool(s, price)
		if int(_chosen(s, f, 20).get(entry[1], 0)) == 0:
			never.append("%s's %s never chosen with the pool at its price, %d" % [entry[0], ab2.display_name, price])
		f.intent = {}
		s.call("_declare_intent", f)
		# JL §1 — the spend rides the declaration, and sets its own price aside there.
		var rd: Dictionary = f.intent.get("spend", {})
		var held := int(rd.get("malice", -1)) if rd.get("ability") is Ability and String((rd["ability"] as Ability).special) == entry[1] else -1
		if held != price:
			unheld.append("%s's %s set aside %d of its price %d" % [entry[0], ab2.display_name, held, price])
		f.intent = {}
	print("    the selection's door: three spends at an empty pool, one short of the price and the price")
	ok(refused.is_empty(), "§2: the selection took a spend the pool cannot pay: %s" % [refused])
	ok(never.is_empty(), "§2: the selection never took a spend the pool can pay: %s" % [never])
	ok(unheld.is_empty(), "§2: a declared spend did not set its price aside: %s" % [unheld])
	_pool(s, 0)


# EVERY SPEND COOLS, BY JI's LINE (C10): its worth on the reference board against its own kind's basic, the line read out of check_ji.
func _s2_the_cooldowns(s: Node, spends: bool) -> void:
	print("\n§2 — every spend cools, by JI's line")
	var rx := RegEx.new()
	rx.compile("\\nconst LINE := ([0-9.]+)\\n")
	var m := rx.search(_doc(LINE_SOURCE))
	var line := float(m.get_string(1)) if m != null else -1.0
	ok(line > 1.0, "§2: JI's line could not be read out of %s" % LINE_SOURCE)
	# THE BASIC IS PRICED AS JI's LINE PRICES IT: through check_ji's one blow, its Break priced (JO §1), and no blow of this gate's own.
	ok(Gate.fn_body("check_jk.gd", "_blow", _cache) == "" and Gate.fn_body("check_ji.gd", "line_blow", _cache) != "", "§2: this gate prices a blow otherwise than check_ji does")
	var price := float(JI.break_figures().get("price", -1.0))
	ok(price > 0.0, "§2: the Break price could not be read off check_ji")
	var census := _doc(CENSUS_TABLE)
	ok(census.contains("\t%s\t" % str(CENSUS_CUT)) and census.contains("\t%s\t" % str(CENSUS_TURNS).replace(".0", "") + ".0\t") or census.contains("%.1f" % CENSUS_TURNS),
		"§2: JA's census no longer reads the warband's armor cut (%s) over its turns (%s)" % [str(CENSUS_CUT), str(CENSUS_TURNS)])
	if not spends or line <= 1.0:
		ok(false, "§2: a spend carries no cooldown, or one not off the line — no spend to price")
		return
	var data: Dictionary = Enemies._load()
	var dot: Dictionary = _const(s, "DOT_STATUSES") if _const(s, "DOT_STATUSES") != null else {}
	var basics := {}
	var bodies: Array = []
	var bvals: Array = []
	for k in data:
		var kd: Dictionary = data[k]
		var basic: Dictionary = {}
		for a in kd["abilities"]:
			if int(a.get("damage", 0)) > 0 and int(a.get("cost", 0)) == 0:
				basic = a
				break
		basics[k] = JI.line_blow(basic, dot, float(kd["attack"]), price)
		if not bool(kd.get("is_boss", false)):
			bodies.append(float(kd["max_hp"]))
			bvals.append(float(basics[k]))
	var body := _median(bodies)
	var med := _median(bvals)
	var worth := {
		"malice_raise": _const_f(s, "MALICE_RAISE_PCT") * body,
		# A RALLY's CLOCK TICKS AT A BODY's TURN START, BEFORE IT ACTS, so each rallied body strikes rallied one turn fewer than the clock.
		"malice_rally": _const_f(s, "MALICE_RALLY_PCT") * (_const_i(s, "MALICE_RALLY_TURNS") - 1) * REACH * med,
		"malice_entrench": (_unit_f("MALICE_ENTRENCH_MULT") - 1.0) * (CENSUS_CUT / CENSUS_TURNS) * _const_i(s, "MALICE_ENTRENCH_TURNS") * REACH,
	}
	print("    the reference board: the median composable body %.1f, the median basic %.1f; a Raise worth %.1f, a Rally %.1f, an Entrench %.1f" % [
		body, med, worth["malice_raise"], worth["malice_rally"], worth["malice_entrench"]])
	var wrong: Array = []
	# A HOLD THE LINE AGREES WITH IS A STALE ONE (JO's ruling 2): check_ji's §1a passes every spend by, so the spends' holds are asked here.
	var stale: Array = []
	var held := 0
	var cool := 0
	for k2 in data:
		for a2 in data[k2]["abilities"]:
			var sp := String(a2.get("special", ""))
			if not worth.has(sp):
				continue
			var mult := float(worth[sp]) / float(basics[k2])
			var want := 0 if mult < line else (2 if mult < 2.0 else (3 if mult < 3.0 else 4))
			var have := int(a2.get("cooldown", 0))
			# A BAND THE REPAIRED LINE MOVES ON A SPEND NO BRIEF NAMED is held at the data's figure, where check_ji holds it (JO's ruling 2).
			var hk := "%s/%s" % [k2, String(a2["display_name"])]
			var line_gives := want
			if JI.HELD.has(hk):
				want = int(JI.HELD[hk])
			print("    %5.2f  %-16s %-9s the line %d, the data %d%s" % [mult, k2, String(a2["display_name"]), line_gives, have, (", held at %d" % want) if JI.HELD.has(hk) else ""])
			if JI.HELD.has(hk):
				held += 1
			if JI.HELD.has(hk) and line_gives == int(JI.HELD[hk]):
				stale.append("%s holds %d where the line gives it %d" % [hk, int(JI.HELD[hk]), line_gives])
			if have > 0:
				cool += 1
			if want == 0 or want != have:
				wrong.append("%s's %s carries %d, the line gives %d (%.2f of its basic)" % [k2, String(a2["display_name"]), have, want, mult])
	print("    CHECKED %d spends; %d cool; %d held, each asked whether the line still moves it" % [_spends.size(), cool, held])
	ok(wrong.is_empty(), "§2: a spend carries no cooldown, or one not off the line: %s" % [wrong])
	ok(stale.is_empty(), "§2: a spend's band is held where the line already gives it — the hold outlived its reason: %s" % [stale])


func _median(xs: Array) -> float:
	var v := xs.duplicate()
	v.sort()
	var n := v.size()
	if n == 0:
		return 0.0
	return (float(v[n / 2 - 1]) + float(v[n / 2])) / 2.0 if n % 2 == 0 else float(v[n / 2])


# ── §3 — THE READING ──────────────────────────────────────────────────────────

func _s3_the_reading() -> void:
	print("\n§3 — the reading: the pool's ledger and the spend counts, as the kept table holds them")
	var lines := _doc(KEPT_DRAIN).split("\n", false)
	ok(lines.size() > 8, "§3: the kept table %s is not in the tree" % KEPT_DRAIN)
	var want := ["Malice given a fight", "Malice taken a fight", "Malice wasted a fight", "Malice spent a fight", "turns at the cap",
		"Raises a fight", "Rallies a fight", "Entrenches a fight"]
	var rows := {}
	for l in lines:
		var c := String(l).split("\t")
		if c.size() >= 3 and want.has(c[0]):
			rows[c[0]] = [c[1], c[2]]
	ok(rows.size() == want.size(), "§3: the kept table lacks a row the brief named: %s" % [want.filter(func(w): return not rows.has(w))])
	var block := _flat(_block(_doc("res://docs/state.md"), SPENDS_HEAD))
	ok(block != "", "§3: the record holds no block on the warband's spends")
	var gone: Array = []
	for k in rows:
		for fig in _figures(String(rows[k][1])):
			if not block.contains(fig):
				gone.append("%s: %s" % [k, fig])
	ok(gone.is_empty(), "§3: the record states the reading without the pool's ledger or the spend counts: %s" % [gone])
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
	print("\n§4 — the fill, the cap and the heals as JJ left them; the deck closed; no kind and no move but the spends")
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
	ok(moved.is_empty(), "§4: the fill, the cap or a heal's price moved: %s" % [moved])
	ok((_run.MODIFIERS as Dictionary).size() == DECK_CLOSED_AT, "§4: the deck holds %d, not the twenty-five it closed at" % (_run.MODIFIERS as Dictionary).size())
	var data: Dictionary = Enemies._load()
	var moves := 0
	for k2 in data:
		if ADDED_SINCE.has(String(k2)):
			continue
		for a in (data[k2] as Dictionary).get("abilities", []):
			# JL §2 — and JL's hex special, which no move carries since JO §2: each hex rides a blow among these fifty-two.
			if not String(a.get("special", "")).begins_with("malice_") and String(a.get("special", "")) != "warband_hex":
				moves += 1
	print("    %d kinds, %d moves beside the spends" % [data.size(), moves])
	var kinds_then := data.keys().filter(func(k): return not ADDED_SINCE.has(String(k))).size()
	ok(kinds_then == KINDS and moves == MOVES_BEFORE, "§4: the warband holds %d kinds and %d moves beside its spends, not %d and %d" % [kinds_then, moves, KINDS, MOVES_BEFORE])


# ── §5 — THE TEXTS FOLLOW THE CONSTANTS ───────────────────────────────────────

func _s5_the_texts(s: Node, spends: bool) -> void:
	print("\n§5 — what each spend buys and costs, stated off the constants")
	var batt := (load("res://scripts/battle.gd") as Script).get_script_constant_map()
	var mult := int(_unit_f("MALICE_ENTRENCH_MULT"))
	var sentence := "A Raise stands a fallen body of the warband back up at %d%% of its maximum health, once a body a fight, for the health it stands it up with; a Rally makes every standing body of the warband deal %d%% more damage with its blows for %d turns, for %d Malice; an Entrench multiplies their armor by %d for %d turns, for %d Malice." % [
		int(round(float(batt.get("MALICE_RAISE_PCT", -1)) * 100)), int(round(float(batt.get("MALICE_RALLY_PCT", -1)) * 100)), int(batt.get("MALICE_RALLY_TURNS", -1)),
		int(batt.get("MALICE_RALLY_PRICE", -1)), mult, int(batt.get("MALICE_ENTRENCH_TURNS", -1)), int(batt.get("MALICE_ENTRENCH_PRICE", -1))]
	ok(_flat(_block(_doc("res://docs/state.md"), SPENDS_HEAD)).contains(sentence), "§5: the state does not state what each spend buys and costs off the constants: '%s'" % sentence)
	ok(_untagged(_doc("res://docs/master.html")).contains(sentence), "§5: the master document does not state what each spend buys and costs off the constants: '%s'" % sentence.left(160))
	var where := _flat(_block(_doc("res://docs/state.md"), "## WHERE THE PROJECT IS"))
	ok(where.contains("a Rally %d and an Entrench %d, flat" % [int(batt.get("MALICE_RALLY_PRICE", -1)), int(batt.get("MALICE_ENTRENCH_PRICE", -1))]),
		"§5: the WHERE block does not state the flat prices off the constants")
	if not spends:
		ok(false, "§5: the strip's words do not name what the pool buys — no spend")
		return
	var words := String(s.call("_malice_words")).replace("\n", " ")
	ok(words.contains("a Rally %d" % int(batt.get("MALICE_RALLY_PRICE", -1))) and words.contains("an Entrench %d" % int(batt.get("MALICE_ENTRENCH_PRICE", -1)))
		and words.contains("%d%% of it" % int(round(float(batt.get("MALICE_RAISE_PCT", -1)) * 100))),
		"§5: the strip's words do not state what each spend costs off the constants: '%s'" % words.left(220))
	var long_lines: Array = []
	for l in String(s.call("_malice_words")).split("\n"):
		if String(l).length() > 44:
			long_lines.append(l)
	ok(long_lines.is_empty(), "§5: a line of the strip's words runs past 44 characters: %s" % [long_lines])


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
