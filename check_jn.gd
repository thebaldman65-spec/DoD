# THE GATE FOR THE ELEVEN KINDS' MOVE WORTH TAKING.
#
#   §0   HOUSEKEEPING: JM's ten rulings answered and archived; the brief's corrections recorded. THE CLERIC GAINS HALF, at the one
#        door every gain in a fight passes — the bar's setter — and nowhere else, never on the bar he walks in with, never on
#        another hero (C07); its words read the constant. THIN AIR RE-READ after the cut, on the tree that lands, its band
#        recorded and its grade unmoved (C08). BOIL OVER FLAT, a point of Rage at a time: one blow at two Attacks lands the
#        same (C09); its words read the constant. SANCTITY READ OUT, its step unchanged (C10).
#   §1   EVERY KIND's SECOND DAMAGING MOVE PRICES AT THE LINE OR BETTER: the population derived off the data by JI's rule, read
#        out of `check_ji` (C01, R01); no basic moved (C02); a raised move's damage and band the only keys that moved (C03); a
#        kind that already cleared untouched (C04); each raised move's band the rule's (C05); no move authored for a kind whose
#        only other move deals nothing (C06); the kept table states the before and the after as the data does.
#   §2   THE TWO ARMS: Arm A's kept reading names the warband's blows a fight beside the outcomes (C12); Arm B wore talents,
#        read off its own line, under a policy the census names (C11).
#   §3   THE DECK closed at twenty-five, no grade re-authored (C13).
#   §4   the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const LINE_SOURCE := "res://check_ji.gd"
const DECK_CLOSED_AT := 25
# THE DECK's GRADES AS THEY STAND — read off `Run.MODIFIERS`; none is re-authored, Thin Air's re-read included.
const DECK := {"overgrown": 4, "frenzied": 1, "brittle": 2, "warded": 2, "bloodless": 5, "parched": 2, "slick": 1, "muffled": 1,
	"hoarfrost": 1, "fleeting": 2, "feverish": 2, "deadened": 3, "miasma": 3, "thinair": 5, "encumbered": 1, "bloodletting": 1,
	"mirrorbound": 5, "rot": 4, "wasting": 5, "thin_veil": 3, "long_silence": 3, "ambushed": 4, "outpaced": 2, "fractured": 1,
	"porous": 2}
# THE WARBAND's KIT BEFORE JN, as JM kept it (every move but Gall) — what §1 is measured from.
const KIT_BEFORE := "res://docs/reports/JM-kit.json"
const KIT_AFTER := "res://docs/reports/JN-kit.json"
const KEPT_POPULATION := "res://docs/reports/JN-population.tsv"
const KEPT_ARC := "res://docs/reports/JN-arc.tsv"
const KEPT_PLAYED := "res://docs/reports/JN-played.tsv"
const KEPT_THINAIR := "res://docs/reports/JN-thinair.tsv"
const CENSUS := "res://docs/reports/IU-bot-divergence.tsv"
# THE DATA AS IT STOOD, every cooldown key aside and each raised move's damage aside: no other figure moved (C03). Printed below.
const DATA_REST := "3684af8e932a63e128de85b8cc8174b3"
# SANCTITY's STEP, AS IT STANDS — read out at §0, never changed (C10).
const SANCTITY := {"SANCTITY_PER_STEP": 13, "SANCTITY_MAX_STEPS": 5, "SANCTITY_STEP_TURNS": 1}
const SEATS := ["warden", "pyromancer", "inquisitor", "beastmaster"]
# The Devout's seat (a Cleric) and the bar he carries in, under his maximum: a rise the spawn writes, never a gain.
const CLERIC_SEAT := 2
const CARRIED_MANA := 40
const SCRATCH_PROFILE := "user://jn_profile.json"
const SCRATCH_RELICS := "user://jn_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const ANSWERED := "all accepted as taken"
const COOLDOWNS_HEAD := "### THE WARBAND's COOLDOWNS"
const READ_HEAD := "### WHAT THE RAISE DID, AND THE GAME WITH TALENTS"
const MANA_HEAD := "### THE CLERIC's MANA RATE"
const SANCTITY_HEAD := "### SANCTITY's STEP"
const BOIL_HEAD := "### BOIL OVER'S RATE"
const GRADES_HEAD := "### THE BARGAIN DECK's GRADES"
const FOUND_HEAD := "### FOUND AT JN AND NOT FIXED"
const RECORDED := "recorded, not repaired"
const WAITS := "what waits on it"
# THE READINGS ARM A OWES (the brief's list), each a row of the kept table.
const ARC_ROWS := ["completed (runs)", "falls a run (runs)", "falls a fight, paired fights", "health at a fight's end, paired fights",
	"hero turns a fight, paired fights", "fights won a run (runs)", "the warband's blows a fight, paired fights"]
# THE READINGS ARM B OWES.
const PLAYED_ROWS := ["completion rate", "falls a run", "health at a fight's end", "fights won a run"]

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}
var _line := 1.4
var _reach := 4
var _figs: Array = []
var _top := 4
var _pop: Array = []   # [kind, move, damage, band, multiple], derived by §1


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR THE ELEVEN KINDS' MOVE WORTH TAKING")
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
	_read_the_line()
	_s0_the_rulings()
	_s1_the_population()
	_s1_the_kit()
	_s1_the_texts()
	_s2_the_arms()
	_s3_the_deck()
	_s0_the_thinair()
	_s0_sanctity()
	# THE CLERIC WALKS IN WITH A PART BAR — a fall from the 100 `setup` gives him, which no cut touches; the ORDER of the arming is
	# pinned below, since no driven bar on this board can show an early cut (the fresh reader, H2).
	var s: Node = await Gate.spawn(self, SEATS, {"deterministic": true, "party": {CLERIC_SEAT: {"mana": CARRIED_MANA}}})
	Engine.time_scale = 20.0
	await _s0_the_mana(s)
	await _s0_boil_over(s)
	Engine.time_scale = 1.0
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	_s4_the_players_files()
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


# A kept table's rows by their first cell: {first cell: [the other cells]}.
func _table(text: String) -> Dictionary:
	var out := {}
	for r in text.split("\n", false).slice(1):
		var c := String(r).split("\t")
		if c.size() >= 2:
			out[c[0].strip_edges()] = c.slice(1)
	return out


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


func _cls() -> Script:
	return load("res://scripts/classes.gd") as Script


func _call(obj: Object, method: String, args: Array, fallback: Variant) -> Variant:
	if obj != null and obj.has_method(method):
		return obj.callv(method, args)
	return fallback


# A constant of the unit script, -1 where the tree holds none.
func _unit_f(name: String) -> float:
	var v: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get(name)
	return float(v) if v != null else -1.0


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


func _hero(s: Node, key: String) -> BattleUnit:
	for h in _heroes(s):
		if (h as BattleUnit).hero_key == key:
			return h
	return null


# The tree's game, digested: every script and every data file, each file's md5 in name order, the whole hashed again.
func _tree_digest() -> String:
	var names: Array = []
	for dir in ["res://scripts", "res://data"]:
		for f in DirAccess.get_files_at(dir):
			if String(f).ends_with(".gd") or String(f).ends_with(".json"):
				names.append("%s/%s" % [dir, f])
	names.sort()
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_MD5)
	for n in names:
		ctx.update(("%s %s\n" % [String(n).trim_prefix("res://"), FileAccess.get_md5(n)]).to_utf8_buffer())
	return ctx.finish().hex_encode()


# JI's LINE, READ OUT OF ITS SOURCE AND NEVER RETYPED: the multiple, the reach of an area blow, the bands and the top (R01).
func _read_the_line() -> void:
	var src := _doc(LINE_SOURCE)
	var rx := RegEx.new()
	rx.compile("(?m)^const LINE := ([0-9.]+)$")
	var m := rx.search(src)
	rx.compile("(?m)^const REACH := ([0-9]+)$")
	var m2 := rx.search(src)
	rx.compile("(?m)^const TOP := ([0-9]+)$")
	var m3 := rx.search(src)
	rx.compile("(?m)^const FIGURES := (.*)$")
	var m4 := rx.search(src)
	ok(m != null and m2 != null and m3 != null and m4 != null, "§1: JI's line could not be read out of %s" % LINE_SOURCE)
	if m == null or m2 == null or m3 == null or m4 == null:
		return
	_line = float(m.get_string(1))
	_reach = int(m2.get_string(1))
	_top = int(m3.get_string(1))
	var pairs := RegEx.new()
	pairs.compile("\\[([0-9.]+), ([0-9]+)\\]")
	for p in pairs.search_all(m4.get_string(1)):
		_figs.append([float(p.get_string(1)), int(p.get_string(2))])
	print("    JI's line, read out of its source: %s times a move's own basic, an area blow on %d, bands %s, top %d" % [str(_line), _reach, str(_figs), _top])


func _dot() -> Dictionary:
	var v: Variant = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("DOT_STATUSES")
	return v if v is Dictionary else {}


func _blow(a: Dictionary, dot: Dictionary) -> float:
	var st: Dictionary = a.get("applies_status", {})
	# A POISON SKIPS THE TURN IT LANDS (`_dot_pass`, its `fresh` flag), so it ticks one fewer than its turns; a Burn ticks every one.
	var ticks := maxf(0.0, float(st.get("turns", 0)) - (1.0 if String(st.get("id", "")) == "poison" else 0.0))
	var tick := float(dot.get(String(st.get("id", "")), 0)) * ticks * float(a.get("status_chance", 1.0))
	return (float(a.get("damage", 0)) + tick) * (_reach if bool(a.get("aoe", false)) else 1)


func _figure(m: float) -> int:
	if m < _line:
		return 0
	for band in _figs:
		if m < float(band[0]):
			return int(band[1])
	return _top


# A kind's basic, as JI's rule reads it: the first move that deals damage and costs nothing — its index in the kit, -1 if none.
func _basic_at(abilities: Array) -> int:
	for i in abilities.size():
		var a: Dictionary = abilities[i]
		if int(a.get("damage", 0)) > 0 and int(a.get("cost", 0)) == 0:
			return i
	return -1


# A kind's second damaging move: the first move after its basic, in the data's order, that deals damage — -1 if none.
func _second_at(abilities: Array, b: int) -> int:
	for j in range(b + 1, abilities.size()):
		if int((abilities[j] as Dictionary).get("damage", 0)) > 0:
			return j
	return -1


# check_jm §4's row of a move: name|damage|pressure|cooldown|delay|cost|special|status|turns|aoe.
func _row(a: Dictionary) -> String:
	var st: Dictionary = a.get("applies_status", {})
	return "%s|%d|%d|%d|%.2f|%d|%s|%s|%d|%s" % [a["display_name"], int(a.get("damage", 0)), int(a.get("pressure", 0)),
		int(a.get("cooldown", 0)), float(a.get("delay", 0)), int(a.get("cost", 0)), String(a.get("special", "")),
		String(st.get("id", "")), int(st.get("turns", 0)), "aoe" if bool(a.get("aoe", false)) else ""]


func _kit(path: String) -> Dictionary:
	var v: Variant = JSON.parse_string(_doc(path))
	return v if v is Dictionary else {}


func _figures(cell: String) -> Array:
	var rx := RegEx.new()
	rx.compile("[0-9]+\\.[0-9]+")
	var out: Array = []
	for m in rx.search_all(cell):
		out.append(m.get_string())
	return out


# ── §0 — JM's TEN RULINGS, AND THE BRIEF's CORRECTIONS ────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JM's ten rulings, answered and archived; the brief's corrections recorded")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n### JM's RULINGS OWED"), "§0: ### JM's RULINGS OWED is still in the open queue — it was answered")
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JM's RULINGS OWED~~"))
	ok(struck.contains(ANSWERED), "§0: the archive does not hold JM's rulings struck and answered")
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/master.html", "res://scripts/battle.gd",
			"res://scripts/unit.gd", "res://docs/instrument-rules.md", "res://check_jm.gd"]:
		if _doc(p).contains("JM's RULINGS OWED"):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])
	# THE BRIEF's FOUR CORRECTIONS, IN THE RECORD: the tree before the arc by its commit, and the two grades the brief misread.
	var found := _flat(_block(state, FOUND_HEAD))
	var lacking: Array = ["141b0be", "Fleeting is a grade 2", "Encumbered a 1"].filter(func(x): return not found.contains(String(x)))
	ok(found != "" and lacking.is_empty(), "§0: the record does not carry the brief's corrections: %s" % [lacking])


# ── §0 — THE CLERIC's MANA, HALVED AT THE BAR's SETTER (C07) ──────────────────

func _s0_the_mana(s: Node) -> void:
	print("\n§0 — the Cleric gains half, at the bar's setter")
	var cut := _unit_f("CLERIC_MANA_CUT")
	ok(cut > 0.0 and cut < 1.0, "§0: the unit holds no cut of the Cleric's Mana gain (%s)" % str(cut))
	var cl := _hero(s, "cleric")
	var mg := _hero(s, "mage")
	if cl == null or mg == null:
		ok(false, "§0: the board holds no Cleric or no Mage to drive")
		return
	# THE BAR HE WALKS IN WITH IS NOT A GAIN: the spawn's carried bar stands whole.
	var idx := -1
	for i in _run.party.size():
		if String(_run.party[i]["key"]) == "cleric":
			idx = i
	var carried := int(_run.party[idx].get("mana", -1)) if idx >= 0 else -1
	print("    the Cleric walked in with %d of the %d he carried (CHECKED: a part bar, %d of %d)" % [cl.resource, carried, carried, cl.max_resource])
	# THE ARMING COMES AFTER THE OPENING BAR IS SETTLED: the carried bar, the relic's floor and the opening Rage are the spawn's
	# rises, and a cut armed before any of them would take it as a gain. Read in `_spawn_units`' own order (C16 moves it).
	var sp := Gate.fn_body("scripts/battle.gd", "_spawn_units", _cache)
	var at_carry := sp.find("u.resource = clampi(Run.party[i].get(\"mana\", u.resource), 0, u.max_resource)")
	var at_floor := sp.find("u.resource = maxi(u.resource, int(res_floor * u.max_resource))")
	var at_open := sp.find("u.resource = maxi(u.resource, mini(u.opening_rage, u.max_resource))")
	var at_arm := sp.find("u.mana_gain_cut = BattleUnit.CLERIC_MANA_CUT")
	print("    _spawn_units: the carried bar at %d, the floor at %d, the opening Rage at %d, the arming at %d" % [at_carry, at_floor, at_open, at_arm])
	ok(at_carry >= 0 and at_floor >= 0 and at_open >= 0 and at_arm > maxi(at_carry, maxi(at_floor, at_open)),
		"§0: the Cleric's cut is armed before his opening bar is settled — the carried bar, the floor or the opening Rage would be cut as a gain")
	ok(cl.resource == clampi(carried, 0, cl.max_resource), "§0: the bar the Cleric walked in with was cut: %d of %d" % [cl.resource, carried])
	var armed: Variant = cl.get("mana_gain_cut")
	ok(armed != null and absf(float(armed) - cut) < 0.0001, "§0: the Cleric's cut is not armed by the fight (%s)" % str(armed))
	# EVERY RISE IN A FIGHT PASSES THE SETTER: a card's gain, a refund, a potion — one rise of 12 at a bar of 10, each hero.
	var rises: Array = []
	for u in [cl, mg]:
		var b: BattleUnit = u
		b.remove_status("sap")
		b.resource = 10
		b.resource = 22
		rises.append(b.resource - 10)
	var want_cl := 12 - int(12 * cut)
	print("    a rise of 12: the Cleric gains %d (the cut's %d), the Mage %d" % [int(rises[0]), want_cl, int(rises[1])])
	ok(int(rises[0]) == want_cl, "§0: a rise of the Cleric's bar in a fight is not cut at its setter: +%d, the cut gives +%d" % [int(rises[0]), want_cl])
	ok(int(rises[1]) == 12, "§0: the cut reached a hero who is not the Cleric: the Mage gained +%d of 12" % int(rises[1]))
	# AND A LOWERING IS NO GAIN.
	cl.resource = 30
	cl.resource = 20
	ok(cl.resource == 20, "§0: lowering the Cleric's bar was cut (%d)" % cl.resource)
	# THE DRIP IS ONE OF THE RISES, NOT A SECOND DOOR: it pays its whole figure into the setter, which cuts it once.
	var regen := int(s.call("_mana_regen", cl))
	var mregen := int(s.call("_mana_regen", mg))
	ok(regen + 10 == mregen, "§0: the Cleric's drip is cut before the setter, a second door (%d against the Mage's %d)" % [regen, mregen])
	var loop := Gate.fn_body("scripts/battle.gd", "_player_turn", _cache)
	ok(loop.contains("u.resource = mini(u.resource + _mana_regen(u), u.max_resource)"), "§0: the turn-start drip no longer pays through the bar")
	# ITS WORDS READ THE CONSTANT: the class's own line, the master document's, the glossary's.
	var pct := "%d%%" % int(round(cut * 100))
	var passive := String(Classes.CLASS_PASSIVES["cleric"]["desc"])
	var master := _untagged(_doc("res://docs/master.html"))
	var gl := _flat(String(Glossary.entry("res_mana").get("long", "")))
	var said: Array = []
	if not passive.contains("cut by " + pct):
		said.append("the class passive: '%s'" % passive)
	var master_says := master.contains("Mana the Cleric gains in a fight is cut by " + pct)
	if not master_says:
		said.append("the master document")
	if not gl.contains("a Cleric gains %s less in a fight" % pct):
		said.append("the glossary's Mana")
	ok(said.is_empty(), "§0: a text does not state the Cleric's cut as its constant does (%s): %s" % [pct, said])
	cl.resource = cl.max_resource
	mg.resource = mg.max_resource


# ── §0 — THIN AIR, RE-READ AFTER THE CUT (C08) ────────────────────────────────

func _s0_the_thinair() -> void:
	print("\n§0 — Thin Air, re-read after the cut, its band recorded")
	var t := _table(_doc(KEPT_THINAIR))
	var row: Array = t.get("thinair", [])
	ok(row.size() >= 8, "§0: the kept table %s holds no Thin Air row" % KEPT_THINAIR)
	if row.size() < 8:
		return
	# A STALENESS TRIPWIRE, SAID SO: the digest is the tree the re-read stands for, every script and data file, so the next batch
	# that edits one reds this arm by design and re-points it at its own re-read or a replay.
	var digest := _tree_digest()
	print("    this tree's game: %s; the table's: %s" % [digest, String(row[7]).strip_edges()])
	ok(String(row[7]).strip_edges() == digest, "§0: Thin Air was not re-read on the tree that lands, after the cut")
	var grade := int(((_run.MODIFIERS as Dictionary).get("thinair", {}) as Dictionary).get("severity", -1))
	ok(grade == int(DECK["thinair"]), "§0: Thin Air's grade was repaired rather than recorded: %d" % grade)
	# THE RE-READ STANDS WITH JN's READINGS, AND THE GRADES BLOCK POINTS AT IT (the close-read, M4).
	var block := _flat(_block(_doc("res://docs/state.md"), READ_HEAD))
	var grades := _flat(_block(_doc("res://docs/state.md"), GRADES_HEAD))
	var figs := _figures(String(row[2]))
	ok(figs.size() >= 2 and block.contains(String(figs[0])) and block.contains(RECORDED) and grades.contains(RECORDED),
		"§0: the record does not state Thin Air's re-read after the cut, %s, or the grades block does not point at it" % RECORDED)


# ── §0 — BOIL OVER, FLAT, A POINT OF RAGE AT A TIME (C09) ─────────────────────

func _s0_boil_over(s: Node) -> void:
	print("\n§0 — Boil Over: flat, a point of Rage at a time")
	var per: Variant = _cls().get_script_constant_map().get("BOIL_OVER_DMG_PER_RAGE")
	ok(per != null and float(per) > 0.0, "§0: Boil Over carries no flat damage a point of Rage")
	if per == null:
		return
	var at100: Variant = _call(_cls(), "rage_dump_damage", [100], null)
	ok(at100 != null and absf(float(at100) - 100.0 * float(per)) < 0.001, "§0: the dump's door does not pay %s a point: %s at 100" % [str(per), str(at100)])
	var res := Gate.fn_body("scripts/battle.gd", "_resolve", _cache)
	ok(res.contains("Classes.rage_dump_damage(bo_spent) if bo_dump else float(ab.damage) * 0.01 * attacker.attack)"),
		"§0: the strike line does not read the dump flat — Attack still scales it")
	# THE HOVER THE HERO PANEL SHOWS (the close-read, H4): a dump that never reads Attack carries no Attack scaling line.
	var m0: Dictionary = (_run.party[0] as Dictionary).duplicate(true)
	m0["bm_abilities"] = ["Boil Over"]
	m0["bm_equipped"] = ["Boil Over"]
	var tip := String(_run.ability_hover(m0, "Boil Over"))
	print("    the hero panel's hover on Boil Over: %s" % tip.replace("\n", " | ").left(220))
	ok(tip.contains("a point of Rage") and not tip.contains("Scaling:"),
		"§0: the hero panel's hover on Boil Over states a share of Attack, or no flat figure: '%s'" % tip.replace("\n", " | ").left(160))
	# ONE BLOW AT TWO ATTACKS: the same bar, the same dice, the same body; flat damage lands the same.
	var w := _hero(s, "warrior")
	var foe: BattleUnit = _foes(s)[0]
	var bo: Ability = Classes.draft_ability("Boil Over")
	if w == null or bo == null:
		ok(false, "§0: no Warrior or no Boil Over to drive")
		return
	var dealt: Array = []
	for atk in [100, 200]:
		foe.max_hp = 5000
		foe.hp = 5000
		foe.pressure = 0
		for st in foe.statuses.duplicate():
			foe.remove_status(String((st as Dictionary).get("id", "")))
		w.attack = atk
		w.resource = 100
		w.cooldowns = {}
		seed(4242)
		await s._resolve(w, bo, foe, "good")
		dealt.append(5000 - foe.hp)
		ok(w.resource == 0, "§0: Boil Over left %d Rage in the bar" % w.resource)
	print("    100 Rage poured at Attack 100: %d dealt; at Attack 200: %d dealt" % [int(dealt[0]), int(dealt[1])])
	ok(int(dealt[0]) > 0 and int(dealt[0]) == int(dealt[1]), "§0: Boil Over's blow scales with the caster's Attack: %d at 100, %d at 200" % [int(dealt[0]), int(dealt[1])])
	# ITS WORDS READ THE CONSTANT: the card, the master document's row.
	var card := String(bo.description)
	var full := int(round(float(per) * 100.0))
	var pp := String.num(float(per))
	ok(card.contains("for %s damage per point spent" % pp) and card.contains("100 Rage is %d" % full),
		"§0: Boil Over's card does not state its constant: '%s'" % card.replace("\n", " / "))
	var master := _untagged(_doc("res://docs/master.html"))
	ok(master.contains("%s damage for every point spent, flat" % pp) and master.contains("a full bar of 100 is %d" % full),
		"§0: the master document does not state Boil Over's flat figure")
	var rec := _flat(_block(_doc("res://docs/state.md"), BOIL_HEAD))
	ok(rec.contains("%s damage a point of Rage, flat" % pp), "§0: the record does not state Boil Over's flat figure")


# ── §0 — SANCTITY, READ OUT (C10) ─────────────────────────────────────────────

func _s0_sanctity() -> void:
	print("\n§0 — Sanctity's step, read out and unchanged")
	var moved: Array = []
	for k in SANCTITY:
		if int(_unit_f(k)) != int(SANCTITY[k]):
			moved.append("%s %d" % [k, int(_unit_f(k))])
	ok(moved.is_empty(), "§0: Sanctity was changed rather than read out: %s" % [moved])
	var body := Gate.fn_body("scripts/unit.gd", "sanctity_steps", _cache)
	ok(body.contains("return mini(sanctity_events / SANCTITY_PER_STEP, SANCTITY_MAX_STEPS)"), "§0: what steps Sanctity was changed")
	var rec := _flat(_block(_doc("res://docs/state.md"), SANCTITY_HEAD))
	ok(rec.contains(WAITS) and rec.contains("Rune of the Hierophant"), "§0: the record does not read Sanctity out — what it is and %s" % WAITS)


# ── §1 — EVERY KIND's SECOND DAMAGING MOVE CLEARS THE LINE ────────────────────

func _s1_the_population() -> void:
	print("\n§1 — every kind's second damaging move, priced on JI's line against its own basic")
	var data: Dictionary = Enemies._load()
	var dot := _dot()
	ok(dot.has("burn") and dot.has("poison"), "§1: the damage a Burn and a Poison tick could not be read off the battle")
	var before := _kit(KIT_BEFORE)
	ok(before.size() > 0, "§1: the kept kit %s is not in the tree" % KIT_BEFORE)
	var under: Array = []
	var bands: Array = []
	var none: Array = []
	var checked := 0
	for kind in data:
		var abs_: Array = data[kind]["abilities"]
		var b := _basic_at(abs_)
		if b < 0:
			ok(false, "§1: %s has no basic attack" % kind)
			continue
		var j := _second_at(abs_, b)
		if j < 0:
			none.append(String(kind))
			continue
		checked += 1
		var a: Dictionary = abs_[j]
		var m := _blow(a, dot) / _blow(abs_[b], dot)
		var name := String(a["display_name"])
		var was := ""
		for r in (before.get(kind, []) as Array):
			if String(r).begins_with(name + "|"):
				was = String(r)
		var raised := was != "" and int(String(was).split("|")[1]) != int(a.get("damage", 0))
		# A RAISE IS A MOVE THAT STOOD UNDER THE LINE: a second move whose damage moved while it already cleared is no raise, and
		# §1's kit walk then reads it as a move touched (C04 found the walk counting any moved second move as raised).
		if raised:
			var a_was := a.duplicate(true)
			a_was["damage"] = int(String(was).split("|")[1])
			if _blow(a_was, dot) / _blow(abs_[b], dot) >= _line:
				raised = false
		if raised:
			_pop.append([String(kind), name, int(a.get("damage", 0)), _figure(m), m])
		print("    %-16s %-18s %5.2f of its basic, band %d, the data %d%s" % [kind, name, m, _figure(m), int(a.get("cooldown", 0)), "  (raised)" if raised else ""])
		if m < _line:
			under.append("%s's %s at %.2f" % [kind, name, m])
		if _figure(m) != int(a.get("cooldown", 0)):
			bands.append("%s's %s: the rule gives %d, the data %d" % [kind, name, _figure(m), int(a.get("cooldown", 0))])
	print("    CHECKED %d kinds' second damaging moves of %d kinds; %d raised; %d kinds hold none: %s" % [checked, data.size(), _pop.size(), none.size(), str(none)])
	ok(checked + none.size() == data.size() and checked >= 10, "§1: the walk priced %d of %d kinds" % [checked, data.size()])
	ok(under.is_empty(), "§1: a kind's second damaging move prices under the line: %s" % [under])
	ok(bands.is_empty(), "§1: a raised move's band is not the rule's: %s" % [bands])
	ok(_pop.size() >= 1, "§1: no move was raised — the population is empty")


func _s1_the_kit() -> void:
	print("\n§1 — nothing moved but the raised moves' damage and band")
	var data: Dictionary = Enemies._load()
	var before := _kit(KIT_BEFORE)
	var after := _kit(KIT_AFTER)
	ok(after.size() > 0, "§1: the kept kit %s is not in the tree" % KIT_AFTER)
	var raised := {}
	for p in _pop:
		raised["%s/%s" % [p[0], p[1]]] = true
	var basics: Array = []
	var others: Array = []
	var touched: Array = []
	var authored: Array = []
	var off_kit: Array = []
	for kind in data:
		var abs_: Array = (data[kind]["abilities"] as Array).filter(func(x): return String((x as Dictionary).get("display_name", "")) != "Gall")
		var was: Array = before.get(kind, [])
		# C06: NO MOVE AUTHORED, NONE TAKEN: each kind holds the moves it held, by name, in order.
		var names_now: Array = abs_.map(func(x): return String((x as Dictionary)["display_name"]))
		var names_was: Array = was.map(func(x): return String(x).split("|")[0])
		if names_now != names_was:
			authored.append("%s: %s, was %s" % [kind, str(names_now), str(names_was)])
			continue
		var b := _basic_at(data[kind]["abilities"])
		var kind_raised := false
		for i in abs_.size():
			var a: Dictionary = abs_[i]
			var now := _row(a)
			var name := String(a["display_name"])
			var key := "%s/%s" % [kind, name]
			if a == data[kind]["abilities"][b]:
				if now != String(was[i]):
					basics.append("%s's %s: %s, was %s" % [kind, name, now, was[i]])
				continue
			if raised.has(key):
				kind_raised = true
				var w := String(was[i]).split("|")
				var n := now.split("|")
				# C03: ONLY THE DAMAGE AND THE BAND: the Break damage, the delay, the cost, the special, the status, its turns, the reach.
				for f in [0, 2, 4, 5, 6, 7, 8, 9]:
					if w[f] != n[f]:
						others.append("%s's %s field %d: %s, was %s" % [kind, name, f, n[f], w[f]])
				continue
			if now != String(was[i]):
				touched.append("%s's %s: %s, was %s" % [kind, name, now, was[i]])
		if not kind_raised:
			for i2 in abs_.size():
				if _row(abs_[i2]) != String(was[i2]):
					touched.append("%s (a kind that already cleared)" % kind)
					break
		if after.get(kind, []) != abs_.map(func(x): return _row(x)):
			off_kit.append(kind)
	if data.size() != before.size():
		authored.append("%d kinds, not %d" % [data.size(), before.size()])
	print("    basics moved %s; raised moves' other fields moved %s; other moves moved %s" % [str(basics), str(others), str(touched)])
	ok(basics.is_empty(), "§1: a basic attack moved: %s" % [basics])
	ok(others.is_empty(), "§1: a raised move's status, delay or reach moved instead of its damage: %s" % [others])
	ok(touched.is_empty(), "§1: a move that already cleared the line was touched: %s" % [touched])
	ok(authored.is_empty(), "§1: a move was authored or taken away: %s" % [authored])
	ok(off_kit.is_empty(), "§1: the kept kit does not hold the warband as the data does: %s" % [off_kit])
	# AND EVERY OTHER KEY OF THE DATA — the status's chance, the damage's type, the words — as it stood: the data with every cooldown
	# key and each raised move's damage set aside, digested.
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var rest := JSON.stringify(_strip(raw, raised, "")).md5_text()
	print("    the data, every cooldown and each raised move's damage aside: %s" % rest)
	ok(rest == DATA_REST, "§1: a figure of the warband moved beside the raised moves' damage and bands (%s)" % rest)


func _strip(v: Variant, raised: Dictionary, kind: String) -> Variant:
	if v is Dictionary:
		var out := {}
		var d: Dictionary = v
		var key := "%s/%s" % [kind, String(d.get("display_name", ""))]
		for k in d:
			if String(k) == "cooldown":
				continue
			if String(k) == "damage" and raised.has(key):
				continue
			out[k] = _strip(d[k], raised, String(k) if kind == "" else kind)
		return out
	if v is Array:
		return (v as Array).map(func(x): return _strip(x, raised, kind))
	return v


func _s1_the_texts() -> void:
	print("\n§1 — the kept table and the record state the raise as the data does")
	var lines := _doc(KEPT_POPULATION).split("\n", false)
	ok(lines.size() > 1, "§1: the kept table %s is not in the tree" % KEPT_POPULATION)
	var t := {}
	for r in lines.slice(1):
		var c := String(r).split("\t")
		if c.size() >= 18:
			t[c[0].strip_edges()] = c
	var wrong: Array = []
	for p in _pop:
		var c2: Array = t.get(String(p[0]), [])
		if c2.size() < 18 or String(c2[4]) != String(p[1]) or int(c2[14]) != int(p[2]) or int(c2[17]) != int(p[3]):
			wrong.append("%s's %s" % [p[0], p[1]])
	var said_pop := 0
	for k in t:
		if String((t[k] as Array)[13]).begins_with("yes"):
			said_pop += 1
	print("    the kept table: %d raised, the data %d" % [said_pop, _pop.size()])
	ok(wrong.is_empty() and said_pop == _pop.size(), "§1: the kept table does not state the raise as the data does: %s" % [wrong])
	# THE RECORD NAMES EACH RAISED MOVE AMONG THE MOVES THAT COOL, WITH ITS BAND, AND STATES THE LINE OFF ITS SOURCE (R01).
	var rec := _flat(_block(_doc("res://docs/state.md"), COOLDOWNS_HEAD))
	var missing: Array = []
	for p2 in _pop:
		if not rec.contains("%s %.2f (%d)" % [p2[1], float(p2[4]), p2[3]]):
			missing.append(p2[1])
	ok(missing.is_empty(), "§1: the record does not name a raised move with its band: %s" % [missing])
	var read := _flat(_block(_doc("res://docs/state.md"), READ_HEAD))
	ok(read.contains("%s× its own basic" % str(_line)), "§1: the record does not state the line off its source, %s× its own basic" % str(_line))


# ── §2 — THE TWO ARMS ─────────────────────────────────────────────────────────

func _s2_the_arms() -> void:
	print("\n§2 — Arm A, what §1 did; Arm B, the game with talents")
	var a := _table(_doc(KEPT_ARC))
	ok(a.size() > 8, "§2: the kept table %s is not in the tree" % KEPT_ARC)
	# C12: THE READINGS THE BRIEF NAMED, THE WARBAND's BLOWS A FIGHT AMONG THEM, EACH WITH ITS PAIRED DIFFERENCE.
	var lacking: Array = ARC_ROWS.filter(func(r): return not a.has(r) or (a[r] as Array).size() < 3 or String(a[r][2]).strip_edges() == "")
	ok(lacking.is_empty(), "§2: Arm A's kept reading lacks a row the brief named, or its paired difference: %s" % [lacking])
	var read := _flat(_block(_doc("res://docs/state.md"), READ_HEAD))
	var gone: Array = []
	for k in ["the warband's blows a fight, paired fights", "health at a fight's end, paired fights"]:
		for fig in _figures(String((a.get(k, ["", "", ""]) as Array)[2])):
			if not read.contains(fig):
				gone.append("%s: %s" % [k, fig])
	ok(read != "" and gone.is_empty(), "§2: the record states Arm A without the warband's blows a fight or the outcomes: %s" % [gone])
	# C11: ARM B WORE TALENTS, READ OFF ITS OWN BANNER, UNDER A POLICY THE KEPT TABLE AND THE CENSUS NAME.
	var p := _table(_doc(KEPT_PLAYED))
	ok(p.size() > 4, "§2: the kept table %s is not in the tree" % KEPT_PLAYED)
	var tiers: Array = p.get("DOD_SIM_TIERS, read off the arm's banner", [])
	var worn := int(String(tiers[1]).strip_edges()) if tiers.size() > 1 and String(tiers[1]).strip_edges().is_valid_int() else 0
	var policy: Array = p.get("the talent policy", [])
	var named := String(policy[0]).strip_edges() if policy.size() > 0 else ""
	print("    Arm B wore %d tiers; its policy: '%s'" % [worn, named.left(80)])
	ok(worn >= 1, "§2: Arm B ran without talents — its banner reads %d tiers worn" % worn)
	var census := _doc(CENSUS)
	ok(named != "" and census.contains(named.left(40)), "§2: Arm B's talent policy is not named, or the census does not name it: '%s'" % named.left(60))
	var lack2: Array = PLAYED_ROWS.filter(func(r): return not p.has(r))
	ok(lack2.is_empty(), "§2: Arm B's kept table lacks a reading the brief named: %s" % [lack2])


# ── §3 — THE DECK ─────────────────────────────────────────────────────────────

func _s3_the_deck() -> void:
	print("\n§3 — the deck closed at twenty-five, no grade re-authored")
	var n := (_run.MODIFIERS as Dictionary).size()
	ok(n == DECK_CLOSED_AT, "§3: the deck holds %d, not the twenty-five it closed at" % n)
	var moved: Array = []
	for id2 in DECK:
		var row: Dictionary = (_run.MODIFIERS as Dictionary).get(id2, {})
		if int(row.get("severity", -1)) != int(DECK[id2]):
			moved.append("%s %s" % [id2, str(row.get("severity", "gone"))])
	ok(moved.is_empty(), "§3: a grade in the deck was re-authored: %s" % [moved])


# ── §4 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s4_the_players_files() -> void:
	print("\n§4 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§4: %s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
