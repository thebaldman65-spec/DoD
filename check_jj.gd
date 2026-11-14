# BATCH JJ — MALICE, AND WHAT IT PAYS FOR.
#
#   §1   THE STATE FILE's CEILING: the figure in the sentence `check_fg` §4 reads, with its reason beside it — the routing
#        bounds what a batch reads now — and HY's derivation kept beside it as the record it superseded (C10).
#   §2   MALICE FILLS AT BL's DOORS, DRIVEN: a point for every `MALICE_DAMAGE_STEP` of the hero side's damage, a kill's worth when
#        a body of the warband falls, and a point for every point a blow spends past a body's last — each read on its own line
#        (C01, C02) — and the pool holds its cap (C03). The warband's damage to itself fills nothing. It is the fight's: a battle
#        opens it empty, and the run carries none of it.
#   §3   WHAT IT PAYS FOR, DRIVEN: every warband heal the data holds — derived through the intent's own classifier, never listed —
#        pays a point for every point of health it restores, the selection priced it at that, a short pool's heal restores what
#        the pool held and an overheal pays only what the bodies lacked (C04), and Blight the Well's damage, which a heal on its
#        bearer becomes, is the heal's whole figure whatever the pool holds, and the selection prices that heal at nothing,
#        so an empty pool never keeps a healer off it (C04c, C04d); the selection never takes a heal the pool cannot pay and
#        takes one it can (C05); the pool is asked at the selection's one door and by the
#        heal's own payment, nowhere else (C06); a declared heal sets its price aside from the next healer; the healers heal
#        whenever the pool allows and a body is hurt (C07).
#   §4   THE BAR: the warband's pool stands on screen above its stack, clear of the log and the plates, its count and its
#        words read off the constants (C08, R01).
#   §5   COMMUNION's COUNT beside its crest chip, off the live party (C11); the Bellow's cooldown a hand-tune through
#        `check_ji`'s `TUNED` (C12).
#   §6   THE RECORD: the twelve rulings answered and archived, the pool's sentence and rule in the state and the master
#        document off the constants (R01), the reading with its before figures and the pool's own (C09, H02).
#   §7   WHAT IS DELIBERATELY NOT DONE: the deck at twenty-five (C13); no enemy kind or move added.
#   §8   THE PLAYER's FILES, as this gate found them.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2). Every driven arm asks first whether the
#   machinery it drives exists, so HEAD's tree reds on each arm rather than throwing past the rest (H01).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jj.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE STATE FILE's CEILING and the reason the brief gave for it, in the rule's own words.
# BATCH JS §0 — RAISED AGAIN, TO 520, the designer's, for the reason this gate already holds beside it (the routing bounds what a
# batch reads); JJ's 440 stands in the preamble as the record JS's raise superseded.
const CEILING_KIB := 520
const CEILING_REASON := "THE CEILING's JOB WAS TO BOUND WHAT A BATCH READS, AND THE ROUTING DOES THAT NOW"
const CEILING_RECORD := "ten batches of this file's mean growth"
# THE POOL's RULE, in the words the record carries.
const COST_RULE := "A HEAL THE WARBAND CASTS COSTS A POINT OF MALICE FOR EVERY POINT OF HEALTH IT RESTORES"
const BAR_HEAD := "MALICE"
const MASTER_NEEDLE := "The warband shares one pool, Malice."
const DECK_CLOSED_AT := 25
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
# JK's fifty, and since JO §2 Gall and Mire among them, each a blow given damage (Sap and Fester ride two of the fifty).
const MOVES := 52
const KEPT_TABLE := "res://docs/reports/JJ-malice.tsv"
const ANSWERED := "all accepted as taken"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "raider", "raider", "raider", "raider"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://jj_profile.json"
const SCRATCH_RELICS := "user://jj_relics.json"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}
var _heals: Array = []   # [kind, move], derived by §3


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JJ — MALICE, AND WHAT IT PAYS FOR")
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
	_s1_the_ceiling()
	var s: Node = await _board()
	var pool := _has_pool(s)
	ok(pool, "§2: the battle holds no pool — no `malice`, no fill, no price (the warband has nothing to spend)")
	_s2_the_fill(s, pool)
	await _s3_what_it_pays_for(s, pool)
	await _s4_the_bar(s)
	await _s5_communion(s)
	_s5_the_bellow()
	_s6_the_record()
	_s7_not_done()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s8_the_players_files()
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


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves the pool.
# The warrior and the mage wear a second core rune and the crest wears Communion, each put down through the run's own door
# (`Run.hold_rune`), so the count §5 reads is the party's, not this gate's.
func _board() -> Node:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i]))[0])))
	for i2 in [0, 1]:
		var second := Runes.build(Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i2]))[1])))
		second["equipped"] = true
		_run.hold_rune(_run.party[i2], second)
	var crest := Runes.build("communion")
	crest["equipped"] = true
	_run.hold_rune({}, crest)
	_run.specs_chosen = true
	_run.active = true
	_run.items = {}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _has_pool(s: Node) -> bool:
	for m in ["_malice_fill", "_malice_on_damage", "_malice_pay", "_malice_free", "_malice_price", "_malice_hurt",
			"_warband_heal", "_warband_heal_figure", "_draw_malice_strip"]:
		if not s.has_method(m):
			return false
	return s.get("malice") != null and s.get("malice_ledger") != null


func _const(s: Node, name: String) -> Variant:
	return (s.get_script() as Script).get_script_constant_map().get(name)


# A constant as a whole number, -1 where the tree holds none — HEAD's has no pool, and a throw would hide the arms below it.
func _const_i(s: Node, name: String) -> int:
	var v: Variant = _const(s, name)
	return int(v) if v != null else -1


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


func _pool(s: Node, n: int) -> void:
	s.set("malice", n)
	s.set("_malice_dealt", 0)


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


func _ab(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _whole(s: Node) -> void:
	for e in _foes(s):
		(e as BattleUnit).hp = (e as BattleUnit).max_hp
		(e as BattleUnit).intent = {}


# Every body whole and undeclared but one, left as it stands.
func _whole_but(s: Node, keep: BattleUnit) -> void:
	for e in _foes(s):
		if e != keep:
			(e as BattleUnit).hp = (e as BattleUnit).max_hp
		(e as BattleUnit).intent = {}


# ── §1 — THE STATE FILE's CEILING ─────────────────────────────────────────────

func _s1_the_ceiling() -> void:
	print("\n§1 — the state file's ceiling, with its reason")
	var st := _flat(_doc("res://docs/state.md"))
	var rx := RegEx.new()
	rx.compile("THIS FILE'S CEILING IS ([0-9]+) KiB")
	var bars: Array = []
	for m in rx.search_all(st):
		if not bars.has(int(m.get_string(1))):
			bars.append(int(m.get_string(1)))
	print("    the ceiling the file states: %s KiB" % str(bars))
	ok(bars == [CEILING_KIB], "§1: the state file's ceiling reads %s KiB, not %d" % [str(bars), CEILING_KIB])
	var at := st.find("THIS FILE'S CEILING IS")
	var para := st.substr(at, 3000) if at >= 0 else ""
	ok(para.contains(CEILING_REASON), "§1: the ceiling was raised without its reason beside it — the routing bounds what a batch reads")
	ok(para.contains(CEILING_RECORD), "§1: the derivation the raise superseded is gone from beside it — a supersession is recorded, never deleted")
	ok(para.contains("never to split this file"), "§1: the ceiling's sentence no longer says the answer is the archive, never a split")


# ── §2 — THE FILL ─────────────────────────────────────────────────────────────

func _s2_the_fill(s: Node, pool: bool) -> void:
	print("\n§2 — Malice fills at BL's doors: a tenth of the damage, a kill, and what a blow spends past a body's last")
	# THE DOORS, AT SOURCE: the damage door hands the pool what a blow spent past a body's last, and the death door fills it.
	var report := Gate.fn_body("scripts/unit.gd", "_report_taken", _cache)
	ok(report.contains("maxi(amount - lost, 0) if hp <= 0 else 0") and report.contains("damage_taken_cb.call(self, lost, hp_before, past_last)"),
		"§2: the damage door does not hand on what a blow spends past a body's last")
	ok(Gate.fn_body("scripts/battle.gd", "_on_damage_taken", _cache).contains("_malice_on_damage(victim, lost, past_last)"),
		"§2: the fill is off the damage door")
	ok(Gate.fn_body("scripts/battle.gd", "_on_unit_died", _cache).contains("_malice_fill(MALICE_PER_KILL)"),
		"§2: the death door does not fill the pool")
	var step := _const_i(s, "MALICE_DAMAGE_STEP")
	var kill := _const_i(s, "MALICE_PER_KILL")
	var cap := _const_i(s, "MALICE_CAP")
	print("    the constants: a point a %d damage, %d a kill, a cap of %d" % [step, kill, cap])
	if not pool or step <= 0 or kill <= 0 or cap <= 0:
		# NOTHING TO DRIVE: each driven arm reds by its own name, and nothing is called that the tree does not hold (H01).
		for w in ["§2: a fight's damage leaves Malice at 0 — no pool to fill", "§2: a body of the warband fell and Malice took nothing for it — no pool",
				"§2: a blow spent 50 past a body's last and Malice took nothing for it — no pool", "§2: the pool banks past its cap — no cap to hold it"]:
			ok(false, w)
		return
	var heroes := _heroes(s)
	var foes := _foes(s)
	var h: BattleUnit = heroes[0]
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	# 1 — A TENTH OF THE HERO SIDE's DAMAGE, the remainder carried: two blows that make a whole ten between them.
	_pool(s, 0)
	s.call("_dmg_frame", h, "the gate's blow")
	var a0 := a.hp
	a.take_hit(37, 0)
	a.take_hit(15, 0)
	var dealt := a0 - a.hp
	var want := dealt / step
	print("    two blows dealt %d: the pool %d (a point a %d is %d)" % [dealt, int(s.get("malice")), step, want])
	ok(dealt > 0 and want > 0 and int(s.get("malice")) == want, "§2: a fight's damage leaves Malice at %d — the hero side dealt %d, a point a %d is %d" % [int(s.get("malice")), dealt, step, want])
	# 2 — THE SIDE IS THE FRAME's: the warband's blow on its own body, and a hero's on a hero, fill nothing.
	var before := int(s.get("malice"))
	s.call("_dmg_frame", b, "the warband's own blow")
	a.take_hit(40, 0)
	s.call("_dmg_frame", h, "a hero's blow on a hero")
	heroes[1].take_hit(20, 0)
	heroes[1].hp = heroes[1].max_hp
	ok(int(s.get("malice")) == before, "§2: the warband's damage to itself, or a hero's to a hero, filled the pool (%d → %d)" % [before, int(s.get("malice"))])
	# 3 — A KILL's WORTH: a body felled by a blow of exactly its health (nothing past its last).
	_pool(s, 0)
	s.call("_dmg_frame", h, "the gate's blow")
	b.hp = 30
	b.take_hit(30, 0)
	var exact := int(s.get("malice"))
	var exact_tenth := 30 / step
	print("    a body felled by exactly its health (30): the pool %d — a tenth %d and a kill" % [exact, exact_tenth])
	ok(b.dead and exact - exact_tenth == kill, "§2: a body of the warband fell and Malice took %d for it, not a kill's %d" % [exact - exact_tenth, kill])
	# 4 — WHAT A BLOW SPENDS PAST A BODY's LAST, point for point: the same fall with 50 more behind the blow.
	_pool(s, 0)
	s.call("_dmg_frame", h, "the gate's blow")
	c.hp = 30
	c.take_hit(80, 0)
	var over := int(s.get("malice"))
	print("    a body on 30 felled by 80: the pool %d — the same fall %d, and 50 past its last" % [over, exact])
	ok(c.dead and over - exact == 50, "§2: a blow spent 50 past a body's last and Malice took %d for it" % (over - exact))
	# 5 — THE CAP: the pool holds it, and what the cap refuses is counted as wasted.
	_pool(s, cap - 5)
	var w0 := int((s.get("malice_ledger") as Dictionary).get("wasted", 0))
	s.call("_malice_fill", 30)
	var w1 := int((s.get("malice_ledger") as Dictionary).get("wasted", 0))
	print("    %d given to a pool at %d: it holds %d, %d wasted" % [30, cap - 5, int(s.get("malice")), w1 - w0])
	ok(int(s.get("malice")) == cap, "§2: the pool banks past its cap: %d of %d" % [int(s.get("malice")), cap])
	ok(w1 - w0 == 25, "§2: what the cap refused was not counted as wasted (%d, not 25)" % (w1 - w0))
	# 6 — IT IS THE FIGHT's: declared empty on the battle, and the run carries none of it.
	ok(Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")).contains("var malice := 0"),
		"§2: the battle does not open its pool empty")
	ok(not Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd")).contains("malice"),
		"§2: the run carries the warband's pool — a quit fight restarts with the warband, and the pool is the warband's")
	_pool(s, 0)
	s.call("_dmg_frame", null, "")


# ── §3 — WHAT IT PAYS FOR ─────────────────────────────────────────────────────

# The health every living body of the warband holds, by body.
func _warband_hp(s: Node) -> Dictionary:
	var out := {}
	for e in _foes(s):
		out[e] = (e as BattleUnit).hp
	return out


func _gained(s: Node, before: Dictionary) -> int:
	var g := 0
	for e in before:
		if is_instance_valid(e) and not (e as BattleUnit).dead:
			g += maxi((e as BattleUnit).hp - int(before[e]), 0)
	return g


func _picks(s: Node, f: BattleUnit, name: String, n: int) -> int:
	var hit := 0
	for _i in n:
		var c: Dictionary = s.call("_choose_enemy_action", f)
		if not c.is_empty() and (c["ability"] as Ability).display_name == name:
			hit += 1
	return hit


# A board for one heal: the caster made its kind; every other body whole but the one it would heal, at 30% (a whole-warband
# heal and a self-heal wound their bodies); the target that heal's own selection would name.
func _heal_board(s: Node, f: BattleUnit, ab: Ability) -> BattleUnit:
	_whole(s)
	var others: Array = _foes(s).filter(func(x): return x != f)
	match ab.special:
		"totem_pulse":
			for o in others:
				(o as BattleUnit).hp = int((o as BattleUnit).max_hp * 0.3)
			return f
		_:
			if ab.display_name == "Regenerate":
				f.hp = int(f.max_hp * 0.3)
				return f
			var t: BattleUnit = others[0]
			t.hp = int(t.max_hp * 0.3)
			return t


func _s3_what_it_pays_for(s: Node, pool: bool) -> void:
	print("\n§3 — what it pays for: every warband heal pays a point for every point it restores")
	_s3_the_door()
	if not pool:
		for w in ["§3: a heal costs a point of Malice for every point of health it restores, and none paid — no pool",
				"§3: the selection took a heal the pool cannot pay — no pool to ask", "§3: a declared heal did not set its price aside — no pool",
				"§3: the healers do not heal whenever the pool allows and a body is hurt — no pool to allow it"]:
			ok(false, w)
		return
	var foes := _foes(s)
	ok(foes.size() >= 3, "§3: the premise — three bodies of the warband standing for the heals (%d)" % foes.size())
	if foes.size() < 3:
		return
	var f: BattleUnit = foes[0]
	var cap := _const_i(s, "MALICE_CAP")
	# THE POPULATION, DERIVED: every move in the data the intent's own classifier calls a mend — never a list of names.
	var data: Dictionary = Enemies._load()
	for kind in data:
		_as_kind(f, String(kind))
		for a in f.abilities:
			if String(s.call("_intent_category", f, a)) == "mend":
				_heals.append([String(kind), (a as Ability).display_name])
	print("    the warband's heals, derived: %s" % str(_heals))
	ok(_heals.size() >= 5, "§3: the classifier names %d warband heals, not the five the data held" % _heals.size())
	var unpaid: Array = []
	var unpriced: Array = []
	var short: Array = []
	var overpaid: Array = []
	var dead: Array = []
	seed(4501)
	for entry in _heals:
		var kind := String(entry[0])
		var name := String(entry[1])
		_as_kind(f, kind)
		var ab := _ab(f, name)
		if ab == null:
			dead.append("%s's %s is not in its kit" % [kind, name])
			continue
		var t := _heal_board(s, f, ab)
		print("    %-15s %-13s its figure on a body of %d: %d" % [kind, name, t.max_hp, int(s.call("_warband_heal_figure", ab.special, t))])
		# THE PRICE THE SELECTION ASKS, AND THE HEAL THAT LANDS: one figure, paid point for point.
		var price := int(s.call("_malice_price", f, ab, t))
		_pool(s, cap)
		var before := _warband_hp(s)
		var spent0 := int((s.get("malice_ledger") as Dictionary).get("spent", 0))
		await s._resolve(f, ab, t, "good")
		var gained := _gained(s, before)
		var paid := cap - int(s.get("malice"))
		var booked := int((s.get("malice_ledger") as Dictionary).get("spent", 0)) - spent0
		print("        priced %d; restored %d; the pool paid %d (booked %d)" % [price, gained, paid, booked])
		if gained <= 0 or paid != gained or booked != paid:
			unpaid.append("%s's %s restored %d and the pool paid %d (booked %d)" % [kind, name, gained, paid, booked])
		if price != gained:
			unpriced.append("%s's %s: the selection priced it %d and it restored %d" % [kind, name, price, gained])
		# WITH THE POOL SHORT: the heal restores no more than the pool can pay.
		t = _heal_board(s, f, ab)
		f.cooldowns = {}
		_pool(s, 7)
		var before2 := _warband_hp(s)
		await s._resolve(f, ab, t, "good")
		var g2 := _gained(s, before2)
		# Every body the board hurt is missing more than any figure, so the heal restores exactly what the pool held.
		if g2 != 7 or int(s.get("malice")) != 0:
			short.append("%s's %s restored %d on a pool of 7, which holds %d" % [kind, name, g2, int(s.get("malice"))])
		# AN OVERHEAL: every body it reaches missing 5 — it restores what the bodies lacked, and pays that, never its figure.
		t = _heal_board(s, f, ab)
		f.cooldowns = {}
		for e in _foes(s):
			if (e as BattleUnit).hp < (e as BattleUnit).max_hp:
				(e as BattleUnit).hp = (e as BattleUnit).max_hp - 5
		_pool(s, cap)
		var before3 := _warband_hp(s)
		await s._resolve(f, ab, t, "good")
		var g3 := _gained(s, before3)
		if g3 <= 0 or cap - int(s.get("malice")) != g3:
			overpaid.append("%s's %s restored %d to bodies missing 5 and the pool paid %d" % [kind, name, g3, cap - int(s.get("malice"))])
		f.cooldowns = {}
	ok(dead.is_empty(), "§3: %s" % [dead])
	ok(unpaid.is_empty(), "§3: a heal costs a point of Malice for every point of health it restores, and these did not: %s" % [unpaid])
	ok(unpriced.is_empty(), "§3: the selection's price is not the health the heal restores: %s" % [unpriced])
	ok(short.is_empty(), "§3: a heal on a short pool did not restore exactly what the pool held: %s" % [short])
	ok(overpaid.is_empty(), "§3: an overheal paid for health it did not restore: %s" % [overpaid])
	await _s3_blight(s, f)
	_s3_the_selection(s, f)
	_s3_the_reserve(s)
	_s3_the_policy(s, f)
	_whole(s)
	_pool(s, 0)


# BLIGHT THE WELL TURNS A HEAL ON ITS BEARER INTO DAMAGE, and the card's damage is the heal's whole figure whatever the pool holds:
# the heal restores nothing, so it pays nothing — and the selection prices it at nothing, so the pool never keeps a healer off a
# blighted body and a declaration sets nothing aside for one (the fresh reader's finding: this arm drove the cast alone).
func _s3_blight(s: Node, f: BattleUnit) -> void:
	_as_kind(f, "totemist")
	var wave := _ab(f, "Healing Wave")
	if wave == null:
		ok(false, "§3: the premise — the Totemist's Healing Wave")
		return
	var t := _heal_board(s, f, wave)
	s._apply_status(t, "blight", 3, 0, 0, _heroes(s)[0])
	var fig := int(s.call("_warband_heal_figure", "healing_wave", t))
	var hp0 := t.hp
	_pool(s, 0)
	var spent0 := int((s.get("malice_ledger") as Dictionary).get("spent", 0))
	await s._resolve(f, wave, t, "good")
	var spent := int((s.get("malice_ledger") as Dictionary).get("spent", 0)) - spent0
	print("    a blighted body healed on an empty pool: it lost %d (the figure %d); the pool paid %d" % [hp0 - t.hp, fig, spent])
	ok(hp0 - t.hp == fig and spent == 0, "§3: Blight the Well's damage moved with the warband's pool: %d of the figure %d, %d paid" % [hp0 - t.hp, fig, spent])
	# THE SELECTION's HALF: the same body, still blighted and still the one body hurt, the pool empty and nothing declared.
	f.cooldowns = {}
	_whole_but(s, t)
	_pool(s, 0)
	var price := int(s.call("_malice_price", f, wave, t))
	var took := _picks(s, f, "Healing Wave", 40)
	var held := -1
	for _i in 20:
		f.intent = {}
		s.call("_declare_intent", f)
		if not f.intent.is_empty() and (f.intent["ability"] as Ability).display_name == "Healing Wave":
			held = int(f.intent.get("malice", -1))
			break
	f.intent = {}
	print("    the same body at an empty pool: priced %d; the healer took the heal %d of 40; a declaration set aside %d" % [price, took, held])
	ok(price == 0 and took > 0 and held == 0, "§3: a heal on a blighted body waits on the warband's pool: priced %d, taken %d of 40 at an empty pool, %d set aside" % [price, took, held])
	t.remove_status("blight")
	f.cooldowns = {}


# THE SELECTION NEVER TAKES A HEAL THE POOL CANNOT PAY, AND TAKES ONE IT CAN (C05).
func _s3_the_selection(s: Node, f: BattleUnit) -> void:
	var refused: Array = []
	var never: Array = []
	for entry in _heals:
		_as_kind(f, String(entry[0]))
		var ab := _ab(f, String(entry[1]))
		if ab == null:
			continue
		var t := _heal_board(s, f, ab)
		var price := int(s.call("_malice_price", f, ab, t))
		for pool in [0, price - 1]:
			_pool(s, maxi(pool, 0))
			var took := _picks(s, f, ab.display_name, 60)
			if took > 0:
				refused.append("%s's %s chosen %d of 60 times with %d in the pool against a price of %d" % [entry[0], entry[1], took, maxi(pool, 0), price])
		_pool(s, price)
		if _picks(s, f, ab.display_name, 60) == 0:
			never.append("%s's %s never chosen with the pool at its price, %d" % [entry[0], entry[1], price])
	print("    the selection: %d heals driven at an empty pool, one short of the price and the price" % _heals.size())
	ok(refused.is_empty(), "§3: the selection took a heal the pool cannot pay: %s" % [refused])
	ok(never.is_empty(), "§3: the selection never took a heal the pool can pay: %s" % [never])


# ONE DOOR (C06): the selection asks the pool where it asks the cooldown, and nothing else that chooses or re-validates does.
func _s3_the_door() -> void:
	var ready := Gate.fn_body("scripts/battle.gd", "_enemy_ready", _cache)
	# JL §1 — and beside what the asker's own declaration already sets aside (`held`), since a spend rides beside its body's heal.
	ok(ready.contains("_malice_price(u, ab, body) + held <= _malice_free(u)"), "§3: the selection's door does not ask the pool")
	var second: Array = []
	for fn in ["_intent_ability_usable", "_revalidate_intent", "_choose_enemy_action", "_enemy_support_action", "_declare_intent", "_enemy_turn", "_find_ready"]:
		if Gate.fn_body("scripts/battle.gd", fn, _cache).contains("_malice_free("):
			second.append(fn)
	ok(second.is_empty(), "§3: the pool is asked beside the selection's door — a second gate in %s" % [second])
	# EVERY FUNCTION THAT ASKS WHAT THE POOL HOLDS, by name: its own definition, the selection's door and the heal's payment.
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var askers: Array = []
	for chunk in src.split("\nfunc "):
		if chunk.contains("_malice_free("):
			askers.append(String(chunk.split("(")[0]).strip_edges())
	askers.sort()
	print("    the functions that ask what the pool holds: %s" % str(askers))
	ok(askers == ["_enemy_ready", "_malice_free", "_warband_heal"], "§3: the pool is asked by %s, not its definition, the selection's door and the heal's payment" % str(askers))


# A DECLARED HEAL SETS ITS PRICE ASIDE: with the pool at one heal's price, the first healer declares it and the second does not.
func _s3_the_reserve(s: Node) -> void:
	var foes := _foes(s)
	var f1: BattleUnit = foes[0]
	var f2: BattleUnit = foes[1]
	_as_kind(f1, "totemist")
	_as_kind(f2, "shaman")
	var wave := _ab(f1, "Healing Wave")
	if wave == null:
		ok(false, "§3: the premise — the Totemist's Healing Wave")
		return
	var t := _heal_board(s, f1, wave)
	if t == f2:
		t = foes[2]
		_whole(s)
		t.hp = int(t.max_hp * 0.3)
	var price := int(s.call("_malice_price", f1, wave, t))
	_pool(s, price)
	s.call("_declare_intent", f1)
	var first := not f1.intent.is_empty() and (f1.intent["ability"] as Ability).display_name == "Healing Wave"
	var set_aside := int(f1.intent.get("malice", 0))
	var second := _picks(s, f2, "Healing Wave", 40)
	print("    one heal's price (%d) in the pool: the first healer declared it %s, set aside %d; the second took it %d of 40" % [price, first, set_aside, second])
	ok(first and set_aside == price, "§3: a declared heal did not set its price aside (%s, %d of %d)" % [first, set_aside, price])
	ok(second == 0, "§3: a second healer declared the heal the first had set the pool aside for (%d of 40)" % second)
	f1.intent = {}
	ok(_picks(s, f2, "Healing Wave", 40) > 0, "§3: with the first declaration gone, the second healer still cannot take the heal")
	f2.intent = {}


# THE SPEND POLICY (C07): heal whenever the pool allows and a body is hurt — missing at least half of what the heal restores.
func _s3_the_policy(s: Node, f: BattleUnit) -> void:
	var cap := _const_i(s, "MALICE_CAP")
	var worth := float(_const(s, "MALICE_HEAL_WORTH")) if _const(s, "MALICE_HEAL_WORTH") != null else -1.0
	ok(worth > 0.0 and worth < 1.0, "§3: the healers' threshold could not be read off the battle (%s)" % str(worth))
	var held_back: Array = []
	var eager: Array = []
	for entry in _heals:
		_as_kind(f, String(entry[0]))
		var ab := _ab(f, String(entry[1]))
		if ab == null:
			continue
		_whole(s)
		var others: Array = _foes(s).filter(func(x): return x != f)
		# A body at 70% — HEAD's Wave waited for 40%, Regenerate for half, Wild Growth for 70% and a coin.
		var bodies: Array = [f] if ab.display_name == "Regenerate" else (others.slice(0, 2) if ab.special == "totem_pulse" else others.slice(0, 1))
		for b in bodies:
			(b as BattleUnit).hp = int((b as BattleUnit).max_hp * 0.7)
		_pool(s, cap)
		var took := _picks(s, f, ab.display_name, 60)
		if took < 60:
			held_back.append("%s's %s took %d of 60 with %s at 70%% and the pool full" % [entry[0], entry[1], took, "itself" if bodies == [f] else "a body"])
		# A SCRATCH: missing under half of what the heal would restore — not hurt, so the turn is an attack.
		for b2 in bodies:
			var fig := int(s.call("_warband_heal_figure", ab.special, b2))
			(b2 as BattleUnit).hp = (b2 as BattleUnit).max_hp - maxi(int(floor(fig * worth)) - 1, 0)
		if _picks(s, f, ab.display_name, 60) > 0:
			eager.append("%s's %s healed a scratch" % [entry[0], entry[1]])
	print("    the policy: %d heals driven at 70%% and at a scratch, the pool full" % _heals.size())
	ok(held_back.is_empty(), "§3: the healers do not heal whenever the pool allows and a body is hurt — the spend policy is HEAD's: %s" % [held_back])
	ok(eager.is_empty(), "§3: a healer spends its turn on a body missing under half of what its heal restores: %s" % [eager])


# ── §4 — THE BAR ──────────────────────────────────────────────────────────────

func _s4_the_bar(s: Node) -> void:
	print("\n§4 — the warband's pool on screen, above its stack, its words off its constants")
	var strip: Variant = s.get("_malice_strip")
	ok(strip != null and is_instance_valid(strip), "§4: the warband's pool is drawn nowhere — a pool the player cannot see is invisible difficulty")
	if strip == null or not is_instance_valid(strip):
		return
	var cap := _const_i(s, "MALICE_CAP")
	_pool(s, 87)
	s.call("_refresh_malice_strip")
	await Gate.frames(self, 2)
	var texts: Array = []
	var hover := ""
	var top := INF
	var bottom := -INF
	for n in (strip as Node).find_children("*", "Control", true, false):
		var c: Control = n
		if c is Label:
			texts.append(String((c as Label).text))
		if c.tooltip_text != "":
			hover = c.tooltip_text
		top = minf(top, c.get_global_rect().position.y)
		bottom = maxf(bottom, c.get_global_rect().end.y)
	print("    the strip reads %s; it spans y %.0f to %.0f" % [str(texts), top, bottom])
	ok(texts.has(BAR_HEAD) and texts.has("%d/%d" % [87, cap]), "§4: the strip does not show the pool's name and its count (%s)" % str(texts))
	var log_foot := (s.get("history_panel") as Control).get_global_rect().end.y
	var stack_top := INF
	for e in s.get("enemies"):
		var p: Variant = (e as BattleUnit).get("_plate_panel")
		if p != null and is_instance_valid(p):
			stack_top = minf(stack_top, (p as Control).get_global_rect().position.y)
	ok(top >= log_foot and bottom <= stack_top, "§4: the strip (y %.0f to %.0f) runs into the combat log (foot %.0f) or the warband's stack (top %.0f)" % [top, bottom, log_foot, stack_top])
	# ITS WORDS READ THE CONSTANTS (R01): a re-tune moves the hover with it.
	var step := _const_i(s, "MALICE_DAMAGE_STEP")
	var kill := _const_i(s, "MALICE_PER_KILL")
	var flat_hover := hover.replace("\n", " ")
	ok(flat_hover.contains("every %d damage" % step) and flat_hover.contains("by %d when" % kill) and flat_hover.contains("%d of %d" % [87, cap]),
		"§4: the strip's hover does not state the pool's figures off its constants: '%s'" % flat_hover.left(160))
	var long_lines: Array = []
	for line in hover.split("\n"):
		if String(line).length() > 44:
			long_lines.append(line)
	ok(long_lines.is_empty(), "§4: a line of the strip's hover runs past 44 characters: %s" % [long_lines])
	_pool(s, 0)
	s.call("_refresh_malice_strip")


# ── §5 — COMMUNION's COUNT, AND THE BELLOW ─────────────────────────────────────

func _s5_communion(s: Node) -> void:
	print("\n§5 — Communion's count beside its chip on the crest strip")
	s.call("_refresh_rune_chips")
	await Gate.frames(self, 2)
	var want := _communion_count(s)
	var said := _progress_label(s)
	print("    the party: %s; the strip: '%s'" % [want, said])
	ok(said != "" and said == want, "§5: Communion's chip does not count how close the party is: '%s', the party %s" % [said, want])
	# A HERO WHO WEARS TWO FALLS: the count is of the heroes who stand.
	var mage: BattleUnit = _heroes(s)[1]
	s.call("_dmg_frame", _foes(s)[0], "the gate's blow")
	mage.take_hit(mage.hp + 100, 0)
	s.call("_dmg_frame", null, "")
	# NO HAND ON THE STRIP: the death door re-reads the live party and redraws the chips itself.
	await Gate.frames(self, 2)
	var want2 := _communion_count(s)
	var said2 := _progress_label(s)
	print("    one wearing two has fallen: the party %s; the strip '%s'" % [want2, said2])
	ok(mage.dead and said2 == want2 and want2 != want, "§5: Communion's count does not follow a fall: '%s', the party %s" % [said2, want2])


# The party's count, off the members the run holds: of the heroes who stand, how many slot two or more core runes.
func _communion_count(s: Node) -> String:
	var k := int(((Runes.config("communion").get("payload", {}) as Dictionary).get("condition", {}) as Dictionary).get("heroes_all_hold_cores", 0))
	var standing := 0
	var met := 0
	var hs := _heroes(s)
	for i in hs.size():
		if (hs[i] as BattleUnit).dead:
			continue
		standing += 1
		if Runes.held_engines(_run.party[i]).size() >= k:
			met += 1
	return "%d of %d" % [met, standing]


func _progress_label(s: Node) -> String:
	var strip: Variant = s.get("_crest_strip")
	if strip == null or not is_instance_valid(strip):
		return ""
	for n in (strip as Node).find_children("*", "Label", true, false):
		if (n as Label).has_meta("rune_progress"):
			return String((n as Label).text)
	return ""


func _s5_the_bellow() -> void:
	print("\n§5 — the Bellow's cooldown: a hand-tune at JJ §0, the rule's own since JN §1")
	var data: Dictionary = Enemies._load()
	var cd := -1
	for a in (data.get("behemoth", {}) as Dictionary).get("abilities", []):
		if String(a.get("display_name", "")) == "Wretched Bellow":
			cd = int(a.get("cooldown", 0))
	# JO §2 FOLDED FESTER ONTO THE BELLOW, and JI's line prices the DoT a blow lays (Fester is one, off `DOT_STATUSES`): with its tick
	# in the sum the rule gives it a longer band than the hand did. The hand's figure is the record of JJ §0; the data's band is the
	# rule's, whatever it reads, as `JO-hexes.tsv` states it and `check_ji` §1a holds it.
	var rule := 0
	for line in FileAccess.get_file_as_string("res://docs/reports/JO-hexes.tsv").split("\n", false):
		var c := String(line).split("\t")
		if c.size() >= 17 and c[0] == "behemoth" and c[6] == "Wretched Bellow":
			rule = int(c[16])
	ok(cd > 0 and cd == rule, "§5: the Rot Behemoth's Wretched Bellow carries %d, not the %d the rule gives it with Fester on it" % [cd, rule])
	# JN §1 RAISED THE BELLOW TO THE LINE (14 → 15, an area blow on four heroes, 1.46 of its basic), so the rule gave the 2 the hand
	# gave, and the hand-tune went with its reason: `check_ji` §1a derives the band and holds no tune for it (`check_jn` §1 the raise);
	# since JO §2 Fester rides the Bellow and the rule gives it 3, read above off the hexes' table.
	var tuned := Gate.strip_comments(FileAccess.get_file_as_string("res://check_ji.gd"))
	ok(tuned.contains("const TUNED := {}") and not tuned.contains("behemoth/Wretched Bellow"),
		"§5: a hand-tune of the Bellow still stands beside the rule, which gives it its band since JN §1")


# ── §6 — THE RECORD ───────────────────────────────────────────────────────────

func _s6_the_record() -> void:
	print("\n§6 — the record: the rulings answered, the pool's sentence and rule, the reading with its before figures")
	var state := _doc("res://docs/state.md")
	var archive := _flat(_doc("res://DoD-archive/state-archive.md"))
	# THE TWELVE, ANSWERED: both blocks left the open queue for the archive, struck, with the answer.
	for code in ["JH", "JI"]:
		var head := "### %s's RULINGS OWED" % code
		ok(not state.contains("\n" + head), "§6: %s is still in the open queue — it was answered" % head)
		var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~%s's RULINGS OWED~~" % code))
		ok(struck.contains(ANSWERED), "§6: the archive does not hold %s's rulings struck and answered" % code)
	ok(archive != "", "§6: the archive could not be read")
	# THE POOL's SENTENCE AND RULE, in the state, its figures the constants' (R01).
	var batt := (load("res://scripts/battle.gd") as Script).get_script_constant_map()
	var step := int(batt.get("MALICE_DAMAGE_STEP", -1))
	var kill := int(batt.get("MALICE_PER_KILL", -1))
	var cap := int(batt.get("MALICE_CAP", -1))
	var sentence := "Malice fills by a point for every %d points of damage the heroes deal the warband, by %d when one of its bodies falls, and by a point for every point of damage spent past a body's last. It holds %d." % [step, kill, cap]
	var flat_state := _flat(state)
	ok(flat_state.contains(sentence), "§6: the state does not state the pool's sentence off its constants: '%s'" % sentence)
	ok(flat_state.contains(COST_RULE), "§6: the state does not state what a warband heal costs")
	var master := _flat(_doc("res://docs/master.html"))
	var at := master.find(MASTER_NEEDLE)
	ok(at >= 0, "§6: the master document does not say the warband shares one pool")
	var para := master.substr(at, master.find("</p>", at) - at) if at >= 0 else ""
	ok(para.contains("a point for every %d points of damage" % step) and para.contains("%d when one of the warband falls" % kill) and para.contains("holds %d" % cap),
		"§6: the master document's pool does not state its figures off the constants: '%s'" % para.left(200))
	ok(para.contains("above the warband's plates"), "§6: the master document does not say where the pool is shown")
	ok(not master.contains("under 40% HP (friendly tanks"), "§6: the master document's enemy AI still waits for 40% to heal")
	ok(_flat(_doc("res://docs/combat-rules.md")).contains("THE SELECTION ASKS THE POOL WHERE IT ASKS THE COOLDOWN"), "§6: the intent block does not say the selection asks the pool")
	# THE LOOK-LIST names the strip and the count: drawn headless, never seen.
	var look := _flat(_block(state, "### THE PLAYTEST'S OTHER FINDINGS"))
	ok(look.contains("THE WARBAND's MALICE STRIP") and look.contains("COMMUNION's COUNT"), "§6: the look-list does not name the pool's strip and Communion's count")
	# THE READING (C09): the kept table's rows, the before figure beside the after, and the pool's own figures.
	var lines := _doc(KEPT_TABLE).split("\n", false)
	ok(lines.size() > 8, "§6: the kept table %s is not in the tree" % KEPT_TABLE)
	var pool_rows := {}
	var before_rows := {}
	for l in lines:
		var c := l.split("\t")
		if c.size() >= 3 and ["completed", "falls a run", "health at a fight's end, paired fights", "hero turns a fight, paired fights"].has(c[0]):
			before_rows[c[0]] = [c[1], c[2]]
		if c.size() >= 3 and (c[0].begins_with("Malice, every fight") or c[0].begins_with("  at the cap, every fight")):
			pool_rows[c[0].strip_edges()] = c[2]
	ok(before_rows.size() == 4 and pool_rows.size() == 2, "§6: the kept table lacks a row the brief named: %s %s" % [str(before_rows.keys()), str(pool_rows.keys())])
	var block := _flat(_block(state, "### THE WARBAND's MALICE"))
	ok(block != "", "§6: the record holds no block on the warband's pool")
	var gone: Array = []
	for k in before_rows:
		var pair := "%s → %s" % [String(before_rows[k][0]), String(before_rows[k][1])]
		if not block.contains(pair):
			gone.append("%s: %s" % [k, pair])
	for k2 in pool_rows:
		for fig in _figures(String(pool_rows[k2])):
			if not block.contains(fig):
				gone.append("%s: %s" % [k2, fig])
	ok(gone.is_empty(), "§6: the record states the reading without its before figure or the pool's own: %s" % [gone])
	print("    the reading held: %s; the pool's: %s" % [str(before_rows), str(pool_rows)])


# The numbers a kept-table cell states, as written there.
func _figures(cell: String) -> Array:
	var rx := RegEx.new()
	rx.compile("[0-9]+\\.[0-9]+%?")
	var out: Array = []
	for m in rx.search_all(cell):
		out.append(m.get_string())
	return out


# ── §7 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s7_not_done() -> void:
	print("\n§7 — the deck closed, and no enemy kind or move added")
	ok((_run.MODIFIERS as Dictionary).size() == DECK_CLOSED_AT, "§7: the deck holds %d, not the twenty-five it closed at" % (_run.MODIFIERS as Dictionary).size())
	var data: Dictionary = Enemies._load()
	var moves := 0
	for k in data:
		# JK §1 — the warband's Malice spends are JK's moves, held by `check_jk` §4; the moves beside them (fifty-two since JO §2) are
		# what this pins.
		if ADDED_SINCE.has(String(k)):
			continue
		for mv in (data[k] as Dictionary).get("abilities", []):
			# JL §2 — and JL's hex special, which no move carries since JO §2: each hex rides a blow, counted among the fifty-two.
			if not String((mv as Dictionary).get("special", "")).begins_with("malice_") \
					and String((mv as Dictionary).get("special", "")) != "warband_hex":
				moves += 1
	print("    %d kinds, %d moves" % [data.size(), moves])
	var kinds_then := data.keys().filter(func(k): return not ADDED_SINCE.has(String(k))).size()
	ok(kinds_then == KINDS and moves == MOVES, "§7: the warband holds %d kinds and %d moves, not %d and %d" % [kinds_then, moves, KINDS, MOVES])


# ── §8 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s8_the_players_files() -> void:
	print("\n§8 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§8: %s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
