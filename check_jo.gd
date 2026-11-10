# THE GATE FOR BREAK's PRICE, AND THE HEXES THAT RIDE BLOWS.
#
#   §0   HOUSEKEEPING: JN's nine rulings answered and archived; THE NEW FLOOR written where the work reads it — the rules of how a
#        batch comes to exist, beside the citation rule — balance the designer's, judged by playing; no batch runs a balance drive;
#        a plain count of whether a new mechanic fired stays, as correctness. The Cleric's cut, Boil Over's figure and Sanctity's
#        step as JN left them (C12).
#   §1   BREAK GETS A PRICE: a point of Break damage at a hero turn's damage over the Break meter's size, both figures read where they
#        stand and named (C01, C02, R01); every gate that prices on JI's line prices one blow, the Break in its sum; the ten JN raised
#        re-derived — a move that falls under the line priced is brought to it, one that still clears stays where JN put it (C03);
#        no basic moved (C04); every other band the repaired line moves held at the data's figure, named, and nothing else moved.
#   §2   THE HEXES RIDE BLOWS: no warband move lays a status on a hero and deals nothing, derived off the data (C05); the spends lay
#        on their own side and deal nothing (C06); a hex folded only onto a move that laid nothing (C07); a hex given damage clears
#        the line (C08), and so does the move a hex was folded onto (C09); each hex rides a blow — no special, aimed as the attacks
#        are, rolling its miss as the warband's other status blows do — and lands on a hit, driven (C10).
#   §3   THE COUNT, WHICH IS CORRECTNESS: the kept table counts each hex laid and the fights it was laid in, each re-derived move
#        cast, and the party's Breaks — and compares nothing (C11).
#   §4   WHAT IS DELIBERATELY NOT DONE: no balance drive's table (C13); the deck closed at twenty-five, no grade re-authored (C14).
#   §5   the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jo.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# JI's LINE, AND SINCE THIS GATE ITS BREAK PRICE: one source, read and never retyped.
const JI = preload("res://check_ji.gd")

const DECK_CLOSED_AT := 25
const DECK := {"overgrown": 4, "frenzied": 1, "brittle": 2, "warded": 2, "bloodless": 5, "parched": 2, "slick": 1, "muffled": 1,
	"hoarfrost": 1, "fleeting": 2, "feverish": 2, "deadened": 3, "miasma": 3, "thinair": 5, "encumbered": 1, "bloodletting": 1,
	"mirrorbound": 5, "rot": 4, "wasting": 5, "thin_veil": 3, "long_silence": 3, "ambushed": 4, "outpaced": 2, "fractured": 1,
	"porous": 2}
# THE WARBAND's KIT AS JN LANDED IT (every move but Gall) — what §1 and §2 are measured from — and as this gate's tree holds it.
const KIT_BEFORE := "res://docs/reports/JN-kit.json"
const KIT_AFTER := "res://docs/reports/JO-kit.json"
const JN_POPULATION := "res://docs/reports/JN-population.tsv"
const KEPT_BREAK := "res://docs/reports/JO-break.tsv"
const KEPT_HEXES := "res://docs/reports/JO-hexes.tsv"
const KEPT_HELD := "res://docs/reports/JO-held.tsv"
const KEPT_COUNT := "res://docs/reports/JO-count.tsv"
# THE KEPT TABLES THIS BATCH WRITES, AND NO OTHER: a drive's table is the one thing the floor forbids (C13).
const KEPT := ["JO-break.tsv", "JO-hexes.tsv", "JO-held.tsv", "JO-count.tsv", "JO-kit.json", "JO-routing.md"]
const HEXES := {"gall": "Gall", "sap": "Sap", "mire": "Mire", "fester": "Fester"}
# THE FOUR THE RULE NAMED BEFORE IT HELD, as JN landed them: the moves that laid a hex on a hero and dealt nothing.
const NAMED_BEFORE := ["archer/Gall", "hexer/Sap", "behemoth/Fester", "grave_totem/Mire"]
# JN's FIGURES THAT STAND (C12).
const CLERIC_CUT := 0.5
const BOIL_PER_RAGE := 1.5
const SANCTITY := {"SANCTITY_PER_STEP": 13, "SANCTITY_MAX_STEPS": 5, "SANCTITY_STEP_TURNS": 1}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["archer", "hexer", "behemoth", "grave_totem"]}
const SCRATCH_PROFILE := "user://jo_profile.json"
const SCRATCH_RELICS := "user://jo_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const ANSWERED := "all accepted as taken"
const FLOOR_HEAD := "BALANCE IS THE DESIGNER's, JUDGED BY PLAYING"
const FLOOR_WORDS := ["a batch's only job is making sure its code works", "no batch runs a balance drive",
	"a plain count of whether a new mechanic fired stays, as correctness"]
const CITES_ONLY := "A BRIEF CITES ONLY WHAT THE REPOSITORY HOLDS"
const COOLDOWNS_HEAD := "### THE WARBAND's COOLDOWNS"
const HEXES_HEAD := "### THE WARBAND's HEXES"
const RIDE := "rides a blow"
const HELD_WORDS := "held at the data's figure"
# A COMPARISON's MARKS: a count that carries one is a reading, and §3 is not one (C11).
const COMPARING := ["±", " z ", "(z ", "against", "paired", "before", "fell", "rose", "harder", "easier"]

# THE TWO HEXES FOLDED ONTO BLOWS (§2): the moves gone from the data, and the moves the rest of it is read without.
const FOLDED := ["behemoth/Fester", "hexer/Sap"]
# THE REST OF THE WARBAND's DATA ON JN's TREE (HEAD aa6f75f), computed there by `rest_digest` under JO's names: what §1 asks stood.
const JN_REST := "425c9c523cfbd5de4b2a12dd9089fdab"
# BATCH JR — THREE APPEARANCE TAGS MOVED AFTER THIS GATE LANDED (JR §1): the Grave Totem and the Rot Behemoth each took a
# roster, the Orc Hexer a second role. Each is named here and put back before the digest, so it goes on asking whether
# anything else in the warband's data moved.
const MOVED_SINCE := {"grave_totem": {"zones": [1.0, 3.0]}, "behemoth": {"zones": [2.0, 3.0]}, "hexer": {"roles": ["hexer"]}}
# BATCH JS — SEVEN KINDS AND TWO ROSTERS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its
# boss, and rosters 4 and 5 on the kinds tagged for all three old rosters. Each is named here and read apart, so this gate goes on
# asking its own question of the warband its batch left; `check_js` holds the seven.
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan"]
const ROSTERS_SINCE := [4, 5]
# A HOST's KEYS §2 MOVED: its damage, its cooldown, the special it lost, the status it took and its words.
const HOST_KEYS := ["damage", "cooldown", "special", "applies_status", "description"]

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}
var _fig := {}       # JI.break_figures(): turn, meter, price
var _dot := {}
var _named := {}     # "kind/Move": what moved it — the ten, and every move that carries a hex


# THE STRIP: every kind and every move, keys sorted by JSON's own order; the ten's damage, a host's HOST_KEYS and the folded moves
# left out. One function for both trees, so JN's digest and this tree's are taken alike.
static func rest_digest(raw: Variant, ten: Array, hosts: Array, folded: Array) -> String:
	var out := {}
	for kind in (raw as Dictionary):
		var kd: Dictionary = (raw as Dictionary)[kind]
		var k2 := {}
		for key in kd:
			if String(key) != "abilities":
				k2[key] = kd[key]
		var moves: Array = []
		for a in kd.get("abilities", []):
			var nm := "%s/%s" % [kind, String((a as Dictionary)["display_name"])]
			if folded.has(nm):
				continue
			var a2 := {}
			for key2 in (a as Dictionary):
				if (ten.has(nm) and String(key2) == "damage") or (hosts.has(nm) and HOST_KEYS.has(String(key2))):
					continue
				a2[key2] = (a as Dictionary)[key2]
			moves.append(a2)
		k2["abilities"] = moves
		out[kind] = k2
	return JSON.stringify(out, "", true).md5_text()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR BREAK's PRICE, AND THE HEXES THAT RIDE BLOWS")
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
	_s0_the_floor()
	_s0_what_stands()
	_s1_the_price()
	_s1_the_ten()
	_s1_nothing_else()
	_s2_the_rule()
	_s2_the_routes()
	var s: Node = await _board()
	await _s3_the_carriers_turns(s)
	await _s2_the_blows(s)
	_s2_the_aim()
	_s3_the_count()
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


# A kept table's rows: [[cells]], the header aside.
func _rows(text: String) -> Array:
	var out: Array = []
	for r in text.split("\n", false).slice(1):
		out.append(String(r).split("\t"))
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


func _kit(path: String) -> Dictionary:
	var v: Variant = JSON.parse_string(_doc(path))
	return v if v is Dictionary else {}


# check_jm §4's row of a move: name|damage|pressure|cooldown|delay|cost|special|status|turns|aoe.
func _row(a: Dictionary) -> String:
	var st: Dictionary = a.get("applies_status", {})
	return "%s|%d|%d|%d|%.2f|%d|%s|%s|%d|%s" % [a["display_name"], int(a.get("damage", 0)), int(a.get("pressure", 0)),
		int(a.get("cooldown", 0)), float(a.get("delay", 0)), int(a.get("cost", 0)), String(a.get("special", "")),
		String(st.get("id", "")), int(st.get("turns", 0)), "aoe" if bool(a.get("aoe", false)) else ""]


func _basic(abilities: Array) -> Dictionary:
	for a in abilities:
		if int((a as Dictionary).get("damage", 0)) > 0 and int((a as Dictionary).get("cost", 0)) == 0:
			return a
	return {}


func _move(kind: String, name: String) -> Dictionary:
	var data: Dictionary = Enemies._load()
	if not data.has(kind):
		return {}
	for a in data[kind]["abilities"]:
		if String((a as Dictionary).get("display_name", "")) == name:
			return a
	return {}


# A move's worth on JI's line, in health, and its multiple of its own kind's basic.
func _worth(kind: String, a: Dictionary) -> float:
	var data: Dictionary = Enemies._load()
	return JI.line_blow(a, _dot, float(data[kind]["attack"]), float(_fig.get("price", 0.0)))


func _multiple(kind: String, a: Dictionary) -> float:
	var data: Dictionary = Enemies._load()
	var bp := _worth(kind, _basic(data[kind]["abilities"]))
	return _worth(kind, a) / bp if bp > 0.0 else -1.0


# The least whole damage at which a move clears the line, its other keys as they stand.
func _least(kind: String, a: Dictionary) -> int:
	var probe := a.duplicate(true)
	var d := 0
	probe["damage"] = d
	while _multiple(kind, probe) < JI.LINE and d < 2000:
		d += 1
		probe["damage"] = d
	return d


func _band(m: float) -> int:
	if m < JI.LINE:
		return 0
	for band in JI.FIGURES:
		if m < float(band[0]):
			return int(band[1])
	return JI.TOP


func _cls() -> Script:
	return load("res://scripts/classes.gd") as Script


func _unit_f(name: String) -> float:
	var v: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get(name)
	return float(v) if v != null else -1.0


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves a body.
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
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion and not (u as BattleUnit).dead)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


# A HERO CLEAN AND WHOLE, NOTHING TO BLOCK OR PARRY A BLOW WITH: the drive reads what the blow lands, not what a guard took.
func _clean(h: BattleUnit) -> void:
	for st in h.statuses.duplicate():
		h.remove_status(String((st as Dictionary).get("id", "")))
	h.hp = h.max_hp
	h.pressure = 0
	h.broken = false
	h.broken_pending = false
	h.block_chance = -10.0
	h.parry_chance = 0.0


# ── §0 — JN's NINE RULINGS, AND THE NEW FLOOR ─────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JN's nine rulings, answered and archived")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n### JN's RULINGS OWED"), "§0: ### JN's RULINGS OWED is still in the open queue — it was answered")
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JN's RULINGS OWED~~"))
	ok(struck.contains(ANSWERED), "§0: the archive does not hold JN's rulings struck and answered")
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/master.html", "res://scripts/battle.gd",
			"res://scripts/unit.gd", "res://docs/instrument-rules.md", "res://check_jn.gd"]:
		if _doc(p).contains("JN's RULINGS OWED"):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])


# THE FLOOR, WHERE THE WORK READS IT: the file of how a batch comes to exist, beside the citation rule, and in no rule file twice.
func _s0_the_floor() -> void:
	print("\n§0 — the new floor, written where the work reads it")
	var wow := _doc("res://docs/ways-of-working.md")
	var at := wow.find(FLOOR_HEAD)
	var cite := wow.find(CITES_ONLY)
	print("    ways-of-working: the citation rule at %d, the floor at %d" % [cite, at])
	ok(at >= 0, "§0: docs/ways-of-working.md does not hold the floor — balance the designer's, judged by playing")
	ok(cite >= 0 and at > cite and wow.substr(cite, at - cite).count("\n\n") <= 1,
		"§0: the floor does not stand beside the citation rule, the paragraph after it")
	var para := _flat(wow.substr(at, wow.find("\n\n", at) - at)) if at >= 0 else ""
	var lacking: Array = FLOOR_WORDS.filter(func(w): return not para.contains(String(w)))
	ok(para != "" and lacking.is_empty(), "§0: the floor's paragraph does not say %s" % [lacking])
	var twice: Array = []
	for p in ["res://CLAUDE.md", "res://docs/instrument-rules.md", "res://docs/combat-rules.md"]:
		if _doc(p).contains(FLOOR_HEAD):
			twice.append(p)
	ok(twice.is_empty(), "§0: the floor stands in a second rule file too: %s" % [twice])


# C12: THE CLERIC's CUT, BOIL OVER's FIGURE AND SANCTITY's STEP, AS JN LEFT THEM.
func _s0_what_stands() -> void:
	print("\n§0 — the Cleric's cut, Boil Over's figure and Sanctity's step, as they stood")
	var moved: Array = []
	if absf(_unit_f("CLERIC_MANA_CUT") - CLERIC_CUT) > 0.0001:
		moved.append("the Cleric's cut %s" % str(_unit_f("CLERIC_MANA_CUT")))
	var per: Variant = _cls().get_script_constant_map().get("BOIL_OVER_DMG_PER_RAGE")
	if per == null or absf(float(per) - BOIL_PER_RAGE) > 0.0001:
		moved.append("Boil Over's figure %s" % str(per))
	for k in SANCTITY:
		if int(_unit_f(k)) != int(SANCTITY[k]):
			moved.append("%s %d" % [k, int(_unit_f(k))])
	var arm := Gate.fn_body("scripts/battle.gd", "_spawn_units", _cache)
	if not arm.contains("u.mana_gain_cut = BattleUnit.CLERIC_MANA_CUT"):
		moved.append("the cut's arming in _spawn_units")
	print("    moved: %s" % str(moved))
	ok(moved.is_empty(), "§0: a figure JN left was touched: %s" % [moved])


# ── §1 — BREAK GETS A PRICE ───────────────────────────────────────────────────

# C01, C02, R01: THE PRICE IS A HERO TURN's DAMAGE OVER THE METER, BOTH READ WHERE THEY STAND — and every gate on the line prices it.
func _s1_the_price() -> void:
	print("\n§1 — a point of Break damage, priced at a hero turn's damage over the Break meter")
	var bt: Variant = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("DOT_STATUSES")
	_dot = bt if bt is Dictionary else {}
	_fig = JI.break_figures()
	var turn := float(_fig.get("turn", -1.0))
	var meter := float(_fig.get("meter", -1.0))
	var price := float(_fig.get("price", -1.0))
	print("    a hero turn's damage %.4f (JA's census: %s over %s); the meter %.2f (the reference four: %s); a point of Break %.6f" % [
		turn, str(_fig.get("dealt", "?")), str(_fig.get("turns", "?")), meter, str(_fig.get("meters", {})), price])
	ok(turn > 0.0 and meter > 0.0, "§1: a hero turn's damage or the meter's size could not be read: %.2f, %.2f" % [turn, meter])
	ok(price > 0.0 and absf(price - turn / meter) < 0.000001, "§1: the Break price is not a hero turn's damage over the meter: %.6f" % price)
	# C02: TAKEN FROM THE TWO FIGURES, NEVER BY HAND — the line's source types no price.
	var src := Gate.strip_comments(_doc("res://check_ji.gd"))
	var rx := RegEx.new()
	rx.compile("0\\.34[0-9]")
	ok(rx.search(src) == null, "§1: the line's source types a Break price by hand")
	var body := Gate.fn_body("check_ji.gd", "break_figures", _cache)
	ok(body.contains("BREAK_CENSUS") and body.contains("BREAK_SEATS") and body.contains("constitution") and body.contains("stability"),
		"§1: the Break price is not read off the census and the meter")
	# C01: THE BLOW's WORTH CARRIES ITS BREAK, AND EVERY GATE THAT PRICES ON THE LINE PRICES THE SAME ONE.
	var blow := Gate.fn_body("check_ji.gd", "line_blow", _cache)
	ok(blow.contains("float(a.get(\"pressure\", 0)) * price"), "§1: JI's line does not put a move's Break damage in its worth")
	var apart: Array = []
	for g in ["check_jk.gd", "check_jl.gd", "check_jm.gd", "check_jn.gd"]:
		if not Gate.strip_comments(_doc("res://" + g)).contains("JI.line_blow("):
			apart.append(g)
		var own := Gate.fn_body(g, "_blow", _cache)
		if own != "" and not own.contains("JI.line_blow("):
			apart.append(g + " (a blow of its own)")
	ok(apart.is_empty(), "§1: a gate prices on JI's line otherwise than through its one blow: %s" % [apart])
	# THE RECORD STATES THE PRICE AND BOTH FIGURES OFF THEIR SOURCES (R01).
	# Three places state it — the cooldowns' rule, WHERE and JO's ruling 1 — and each is asked, so a figure moved in one alone reds.
	# RE-POINTED AT JP: the rulings were answered and archived word for word, the heading struck, so ruling 1 is read in the archive.
	var said := [ "%.2f" % turn, "%.2f" % meter, "%.4f" % price]
	var lacking: Array = []
	for head in [COOLDOWNS_HEAD, "## WHERE THE PROJECT IS", "### ~~JO's RULINGS OWED~~"]:
		var rec := _flat(_block(_doc("res://DoD-archive/state-archive.md"), String(head))) if String(head).begins_with("### ~~") \
			else _flat(_block(_doc("res://docs/state.md"), String(head)))
		var miss: Array = said.filter(func(x): return not rec.contains(String(x)))
		if rec == "" or not miss.is_empty():
			lacking.append("%s: %s" % [head, str(miss) if rec != "" else "absent"])
	# BREAK_SEATS IS THE CENSUS's OWN PARTY: the four the scale's sim plays, as `check_ix` names them.
	var ix := str((load("res://check_ix.gd") as Script).get_script_constant_map().get("PARTY_SPECS", ""))
	var seats := "[%s]" % ", ".join((JI.BREAK_SEATS as Array).map(func(x): return "\"%s\"" % x))
	ok(seats == ix, "§1: the meter's four are not the census's party: %s, check_ix's %s" % [seats, ix])
	ok(lacking.is_empty(), "§1: the record does not state the Break price off its source: %s missing of a hero turn %.2f over the meter %.2f" % [lacking, turn, meter])


# C03: THE TEN JN RAISED, RE-DERIVED WITH THE BREAK IN BOTH SUMS — under the line priced, brought to it; still clear, where JN put it.
func _s1_the_ten() -> void:
	print("\n§1 — the ten JN raised, re-derived with Break in the sum")
	var jn := _kit(KIT_BEFORE)
	var ten: Array = []
	for c in _rows(_doc(JN_POPULATION)):
		if c.size() > 13 and String(c[13]) == "yes":
			ten.append([String(c[0]), String(c[4])])
	ok(ten.size() == 10, "§1: JN's kept table names %d raised moves, not ten" % ten.size())
	var kept := {}
	for c2 in _rows(_doc(KEPT_BREAK)):
		if c2.size() >= 20:
			kept["%s/%s" % [c2[0], c2[8]]] = c2
	var wrong: Array = []
	var brought := 0
	for t in ten:
		var kind := String(t[0])
		var name := String(t[1])
		var key := "%s/%s" % [kind, name]
		var a := _move(kind, name)
		var jn_dmg := -1
		for r in (jn.get(kind, []) as Array):
			if String(r).begins_with(name + "|"):
				jn_dmg = int(String(r).split("|")[1])
		if a.is_empty() or jn_dmg < 0:
			wrong.append("%s: not in the data or not in JN's kit" % key)
			continue
		var at_jn := a.duplicate(true)
		at_jn["damage"] = jn_dmg
		var m_jn := _multiple(kind, at_jn)
		var want := jn_dmg if m_jn >= JI.LINE else _least(kind, a)
		if m_jn < JI.LINE:
			brought += 1
		var m := _multiple(kind, a)
		print("    %-12s %-16s at JN's %3d: %.3f; the least that clears %3d; the data %3d (%.3f), band %d, the data's %d" % [
			kind, name, jn_dmg, m_jn, _least(kind, a), int(a.get("damage", 0)), m, _band(m), int(a.get("cooldown", 0))])
		if int(a.get("damage", 0)) != want:
			wrong.append("%s carries %d, the re-derivation gives %d (%.2f at JN's %d)" % [key, int(a.get("damage", 0)), want, m_jn, jn_dmg])
		var row: Array = kept.get(key, [])
		if row.size() < 20 or int(row[12]) != jn_dmg or int(row[17]) != want or int(row[19]) != _band(m):
			wrong.append("the kept table does not state %s as the re-derivation does" % key)
		_named[key] = "the ten"
	print("    CHECKED %d of the ten; %d brought to the line, %d where JN put them" % [ten.size(), brought, ten.size() - brought])
	ok(wrong.is_empty(), "§1: a re-derived move is not where the line priced with its Break puts it: %s" % [wrong])
	ok(brought >= 1 and brought < ten.size(), "§1: the re-derivation moved %d of the ten — the price reaches nothing, or everything" % brought)


# C04 AND THE REST: NO BASIC MOVED; EVERY MOVE BUT THE NAMED AS JN LANDED IT; EVERY BAND THE LINE MOVES ELSEWHERE HELD AND NAMED.
func _s1_nothing_else() -> void:
	print("\n§1 — no basic moved, nothing else moved, every other band the line moves held")
	var data: Dictionary = Enemies._load()
	var jn := _kit(KIT_BEFORE)
	for c in _rows(_doc(KEPT_HEXES)):
		if c.size() > 7:
			_named["%s/%s" % [c[0], c[6]]] = "a hex's host"
	var basics: Array = []
	var touched: Array = []
	var gone: Array = []
	for kind in data:
		if ADDED_SINCE.has(String(kind)):
			continue
		var abs_: Array = data[kind]["abilities"]
		var b := _basic(abs_)
		var was: Array = jn.get(kind, [])
		var was_b := ""
		for r in was:
			var f := String(r).split("|")
			if int(f[1]) > 0 and int(f[5]) == 0:
				was_b = String(r)
				break
		if b.is_empty() or _row(b) != was_b:
			basics.append("%s: %s, was %s" % [kind, _row(b) if not b.is_empty() else "none", was_b])
		var names_now: Array = abs_.map(func(x): return String((x as Dictionary)["display_name"]))
		for r2 in was:
			var nm := String(r2).split("|")[0]
			if not names_now.has(nm):
				gone.append("%s/%s" % [kind, nm])
		for a in abs_:
			var key := "%s/%s" % [kind, String(a["display_name"])]
			if _named.has(key) or a == b:
				continue
			var row := ""
			for r3 in was:
				if String(r3).begins_with(String(a["display_name"]) + "|"):
					row = String(r3)
			if row != _row(a):
				touched.append("%s: %s, was %s" % [key, _row(a), row])
	gone.sort()
	# THE REST OF THE WARBAND's DATA, AS JN LEFT IT: every figure but what §1 and §2 moved, digested as JN's data digests under the
	# same strip — a kind's stats, and every key of every move the kit row does not carry (its status chance, damage type, target).
	var ten: Array = []
	for c4 in _rows(_doc(JN_POPULATION)):
		if c4.size() > 13 and String(c4[13]) == "yes":
			ten.append("%s/%s" % [c4[0], c4[4]])
	var hosts: Array = []
	for c5 in _rows(_doc(KEPT_HEXES)):
		if c5.size() > 7:
			hosts.append("%s/%s" % [c5[0], c5[6]])
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	# BATCH JR — THREE APPEARANCE TAGS MOVED AFTER THIS GATE LANDED (JR §1), each named in `MOVED_SINCE` and put back
	# before the digest, so it goes on asking whether anything else in the warband's data moved.
	for jr_kind in MOVED_SINCE:
		if (raw as Dictionary).has(jr_kind):
			for jr_field in MOVED_SINCE[jr_kind]:
				raw[jr_kind][jr_field] = (MOVED_SINCE[jr_kind][jr_field] as Array).duplicate()
	# BATCH JS — the seven kinds and the two rosters added since (`ADDED_SINCE`, `ROSTERS_SINCE`) out before the digest.
	for js_kind in ADDED_SINCE:
		(raw as Dictionary).erase(js_kind)
	for js_k in (raw as Dictionary):
		if ((raw as Dictionary)[js_k] as Dictionary).has("zones"):
			raw[js_k]["zones"] = (raw[js_k]["zones"] as Array).filter(func(z): return not ROSTERS_SINCE.has(int(z)))
	var rest := rest_digest(raw, ten, hosts, FOLDED)
	print("    the rest of the data, the ten's damage, the hosts' moved keys and the folded moves aside: %s (JN's %s; %d of the ten, %d hosts)" % [
		rest, JN_REST, ten.size(), hosts.size()])
	ok(ten.size() == 10 and hosts.size() == 4 and rest == JN_REST,
		"§1: a figure of the warband moved that neither §1 nor §2 moved — a kind's stats, or a key the kit row does not carry (%s)" % rest)
	print("    basics moved %s; other moves moved %s; moves gone %s" % [str(basics), str(touched), str(gone)])
	ok(basics.is_empty(), "§1: a basic attack moved: %s" % [basics])
	ok(touched.is_empty(), "§1: a move neither the ten nor a hex's host moved: %s" % [touched])
	ok(gone == FOLDED, "§1: the moves gone are not the two hexes folded onto blows: %s" % [gone])
	# THE HELD BANDS: the line's source names each, the kept table says so, and each is still a band the line would move.
	var held: Dictionary = JI.HELD
	var kept := {}
	for c in _rows(_doc(KEPT_HELD)):
		if c.size() >= 7:
			kept["%s/%s" % [c[0], c[2]]] = int(c[6])
	var off: Array = []
	for k in held:
		var parts := String(k).split("/")
		var a2 := _move(parts[0], parts[1])
		if a2.is_empty() or int(a2.get("cooldown", 0)) != int(held[k]) or int(kept.get(k, -1)) != int(held[k]):
			off.append("%s: held %d, the data %d, the table %d" % [k, int(held[k]), int(a2.get("cooldown", -1)), int(kept.get(k, -1))])
	print("    held at the data's figure: %s" % str(held))
	ok(off.is_empty() and kept.size() == held.size(), "§1: a band the line moves is held otherwise than the data and the kept table say: %s" % [off])
	var rec := _flat(_block(_doc("res://docs/state.md"), COOLDOWNS_HEAD))
	ok(rec.contains(HELD_WORDS), "§1: the record does not say the bands the line moves elsewhere are %s" % HELD_WORDS)


# ── §2 — THE HEXES RIDE BLOWS ─────────────────────────────────────────────────

# C05, C06: THE RULE, DERIVED OFF THE DATA — a move aimed at the heroes that lays a status and deals nothing; the spends lay on their own side.
func _s2_the_rule() -> void:
	print("\n§2 — no warband move lays a status on a hero unless it deals damage")
	var data: Dictionary = Enemies._load()
	var named: Array = []
	var specials: Array = []
	var spends: Array = []
	var walked := 0
	for kind in data:
		for a in data[kind]["abilities"]:
			walked += 1
			var key := "%s/%s" % [kind, String(a["display_name"])]
			var own_side := String(a.get("target", "")) == "ally"
			var lays := not (a.get("applies_status", {}) as Dictionary).is_empty()
			if not own_side and lays and int(a.get("damage", 0)) <= 0:
				named.append(key)
			if String(a.get("special", "")) == "warband_hex":
				specials.append(key)
			if String(a.get("special", "")).begins_with("malice_"):
				if not own_side or lays or int(a.get("damage", 0)) > 0 or int(a.get("cost", 0)) > 0:
					spends.append(key)
	# THE RULE NAMED, BEFORE IT HELD, THE FOUR HEXES AND NOTHING ELSE: JN's kit read the same way.
	var before: Array = []
	var jn := _kit(KIT_BEFORE)
	for kind2 in jn:
		for r in (jn[kind2] as Array):
			var f := String(r).split("|")
			if int(f[1]) <= 0 and f[7] != "":
				before.append("%s/%s" % [kind2, f[0]])
	# JN's kit holds no row for Gall (its archer reads Arrow Shot, Poison Arrow and Rally), so Gall's half of "before" is the hexes'
	# table's word, not the kit's: this half of the arm cannot red for Gall, and its FAIL text says so.
	before.append("archer/Gall")
	before.sort()
	var nb: Array = NAMED_BEFORE.duplicate()
	nb.sort()
	print("    CHECKED %d moves; the rule names %s; before it held it named %s" % [walked, str(named), str(before)])
	ok(walked >= 70, "§2: the walk read %d moves" % walked)
	ok(named.is_empty(), "§2: a warband move lays a status on a hero and deals nothing: %s" % [named])
	ok(specials.is_empty(), "§2: a move is still a hex that rolls no miss (special warband_hex): %s" % [specials])
	ok(before == nb, "§2: the rule, read on JN's kit (Gall's row absent there, named by the hexes' table), names %s, not the four hexes" % [before])
	print("    the spends: every Malice spend lays on its own side, deals nothing and costs no Malice in the data (%d off)" % spends.size())
	ok(spends.is_empty(), "§2: a spend is pulled into the rule — it is aimed at a hero, lays a status there, deals damage or costs: %s" % [spends])


# C07, C08, C09: EACH HEX's ROUTE, AS THE KEPT TABLE STATES IT AND THE DATA HOLDS IT.
func _s2_the_routes() -> void:
	print("\n§2 — each hex's route: folded onto a move that laid nothing, or given the damage that clears the line")
	var jn := _kit(KIT_BEFORE)
	var rows := _rows(_doc(KEPT_HEXES))
	var seen := {}
	var wrong: Array = []
	for c in rows:
		if c.size() < 17:
			continue
		var kind := String(c[0])
		var hex := String(c[2])
		var route := String(c[5])
		var host := String(c[6])
		seen[hex] = true
		var a := _move(kind, host)
		if a.is_empty():
			wrong.append("%s's host %s/%s is not in the data" % [hex, kind, host])
			continue
		var st: Dictionary = a.get("applies_status", {})
		var m := _multiple(kind, a)
		print("    %-6s %-12s on %-12s %-16s damage %3d, %.3f of its basic, band %d (the data's %d)" % [hex, route, kind, host, int(a.get("damage", 0)), m, _band(m), int(a.get("cooldown", 0))])
		if String(st.get("id", "")) != hex:
			wrong.append("%s/%s does not lay %s" % [kind, host, hex])
		if route == "folded":
			# C07: THE MOVE IT RIDES LAID NOTHING BEFORE, AND IS NOT THE BASIC.
			var was := ""
			for r in (jn.get(kind, []) as Array):
				if String(r).begins_with(host + "|"):
					was = String(r)
			var data: Dictionary = Enemies._load()
			if was == "" or String(was).split("|")[7] != "" or a == _basic(data[kind]["abilities"]):
				wrong.append("%s was folded onto %s/%s, which laid something already or is the basic (%s)" % [hex, kind, host, was])
		# C08, C09: EVERY MOVE THAT CARRIES A HEX CLEARS THE LINE, AT THE LEAST DAMAGE THAT DOES IF IT HAD TO BE GIVEN ANY.
		if m < JI.LINE:
			wrong.append("%s/%s carries %s at %.3f of its basic — under the line" % [kind, host, hex, m])
		var dmg_before := int(c[8])
		var dmg := int(a.get("damage", 0))
		if dmg != dmg_before and dmg != _least(kind, a):
			wrong.append("%s/%s was given %d, the least that clears is %d" % [kind, host, dmg, _least(kind, a)])
		if int(a.get("cooldown", 0)) != _band(m) or int(c[16]) != _band(m) or int(c[9]) != dmg:
			wrong.append("%s/%s's band or damage is not the line's as the data and the table state it" % [kind, host])
	ok(seen.size() == HEXES.size(), "§2: the kept table routes %d hexes, not the four" % seen.size())
	ok(wrong.is_empty(), "§2: a hex rides a move otherwise than the rule and the line say: %s" % [wrong])
	var rec := _flat(_block(_doc("res://docs/state.md"), HEXES_HEAD))
	ok(rec.contains(RIDE), "§2: the record does not say each hex %s" % RIDE)


# C10: EACH HEX RIDES A BLOW, DRIVEN — no special; it lands on a hit, on every hero an area move reaches; a single blow misses as the
# warband's other status blows do, and then lays nothing.
func _s2_the_blows(s: Node) -> void:
	print("\n§2 — each hex rides a blow: it lands on a hit, and a blow that misses lays nothing")
	if s == null:
		ok(false, "§2: no board to drive")
		return
	Engine.time_scale = 20.0
	var foes := _foes(s)
	var heroes := _heroes(s)
	ok(foes.size() >= 1 and heroes.size() == 4, "§2: the board holds %d foes and %d heroes" % [foes.size(), heroes.size()])
	if foes.is_empty() or heroes.size() < 4:
		return
	var f: BattleUnit = foes[0]
	var wrong: Array = []
	var shape := {}
	for c in _rows(_doc(KEPT_HEXES)):
		if c.size() < 17:
			continue
		var kind := String(c[0])
		var hex := String(c[2])
		var host := String(c[6])
		var cfg := Enemies.config(kind)
		var ab: Ability = null
		for x in cfg["abilities"]:
			if (x as Ability).display_name == host:
				ab = x
		if ab == null:
			wrong.append("%s: no %s in %s's kit" % [hex, host, kind])
			continue
		if String(ab.special) != "":
			wrong.append("%s rides %s, a special (%s) — it rolls no miss" % [hex, host, ab.special])
		f.abilities = cfg["abilities"]
		f.attack = int(cfg.get("attack", f.attack))
		f.no_cover = 1
		f.cooldowns = {}
		f.crit_bonus = -1.0
		for h in heroes:
			_clean(h)
			(h as BattleUnit).no_cover = 1
		var aim: BattleUnit = heroes[1]
		seed(4040)
		await s._resolve(f, ab, aim, "good")
		var took: Array = heroes.filter(func(h): return (h as BattleUnit).has_status(hex))
		var hurt: Array = heroes.filter(func(h): return (h as BattleUnit).hp < (h as BattleUnit).max_hp)
		var want := heroes.size() if ab.aoe else 1
		print("    %-7s on %-16s (%s): laid on %d hero%s, %d hurt" % [hex, host, "every hero" if ab.aoe else "one", took.size(), "" if took.size() == 1 else "es", hurt.size()])
		if took.size() != want or hurt.size() != want or (not ab.aoe and not aim.has_status(hex)):
			wrong.append("%s on %s laid on %d and hurt %d, not %d" % [hex, host, took.size(), hurt.size(), want])
		# A SINGLE BLOW AT A HERO BEHIND A MIRROR IMAGE MISSES — rolled as every single blow is — and lays nothing.
		if not ab.aoe:
			_clean(aim)
			f.no_cover = 0
			s._apply_status(aim, "mirror", 3, 2)
			await s._resolve(f, ab, aim, "good")
			shape[host] = [aim.has_status(hex), aim.hp < aim.max_hp]
			if aim.has_status(hex) or aim.hp < aim.max_hp:
				wrong.append("%s on %s at a hero behind a Mirror Image did not miss" % [hex, host])
			_clean(aim)
	# THE WARBAND's OTHER STATUS BLOW, THE SAME WAY: Poison Arrow misses its image and lays nothing.
	var acfg := Enemies.config("archer")
	var pa: Ability = null
	for x2 in acfg["abilities"]:
		if (x2 as Ability).display_name == "Poison Arrow":
			pa = x2
	if pa != null:
		var aim2: BattleUnit = heroes[2]
		_clean(aim2)
		f.abilities = acfg["abilities"]
		f.no_cover = 0
		s._apply_status(aim2, "mirror", 3, 2)
		await s._resolve(f, pa, aim2, "good")
		print("    Poison Arrow at a hero behind a Mirror Image: poisoned %s, hurt %s; the hexes' single blows: %s" % [str(aim2.has_status("poison")), str(aim2.hp < aim2.max_hp), str(shape)])
		if aim2.has_status("poison") or aim2.hp < aim2.max_hp:
			wrong.append("Poison Arrow did not miss its image either — the drive proves nothing")
		_clean(aim2)
	ok(shape.size() >= 2, "§2: the drive missed %d single blows that carry a hex, not two" % shape.size())
	ok(wrong.is_empty(), "§2: a hex does not ride a blow as the warband's other status blows do: %s" % [wrong])
	Engine.time_scale = 1.0


# C10: THE AIM — the selection picks a move that carries a hex as it picks an attack, and no hex arm stands to pick or lay one.
func _s2_the_aim() -> void:
	print("\n§2 — the aim: chosen as the attacks are, through the draws and the evasions")
	var choose := Gate.fn_body("scripts/battle.gd", "_choose_enemy_action", _cache)
	var special := Gate.fn_body("scripts/battle.gd", "_resolve_special", _cache)
	var pick := "ab = affordable.pick_random()"
	ok(choose.contains(pick), "§2: the selection does not pick its blow from the attacks alone")
	var hex_arm := "\"warband_hex\":"
	ok(not choose.contains("warband_hex") and not special.contains(hex_arm), "§2: a hex arm still stands in the selection or the specials")
	ok(Gate.fn_body("scripts/battle.gd", "_hex_open", _cache) == "", "§2: the hexes' own aim (_hex_open) still stands")


# ── §3 — THE COUNT ────────────────────────────────────────────────────────────

# C11's FIGHT OF ITS OWN: the four carriers' own turns on this gate's board, through the selection — its cooldowns ticked at its
# turn's start, then the choice taken on the tick it resolves on (`ticks_ahead` 0, as `_revalidate_intent` chooses when nothing was
# declared), then the move resolved at the target it names — twelve rounds, every carrier once a round. Each hex is counted where it lands, on every body of the party's side; the party is kept whole and standing between rounds
# so the warband always has bodies to strike. A plain count of whether each fires: nothing compared, nothing read for its size.
func _s3_the_carriers_turns(s: Node) -> void:
	print("\n§3 — the carriers' own turns, through the selection: each hex counted where it lands")
	if s == null:
		ok(false, "§3: no board to drive")
		return
	Engine.time_scale = 20.0
	var hosts := {}
	for c in _rows(_doc(KEPT_HEXES)):
		if c.size() > 7:
			hosts[String(c[1])] = [String(c[2]), String(c[6])]
	var carriers: Array = _foes(s).filter(func(e): return hosts.has((e as BattleUnit).unit_name))
	var laid := {}
	var cast := {}
	for hx in HEXES:
		laid[hx] = 0
	var actions := 0
	seed(5151)
	for _round in 12:
		for f in carriers:
			var u: BattleUnit = f
			var party: Array = (s.get("heroes") as Array) + (s.get("companions") as Array)
			for h in party:
				var b: BattleUnit = h
				if b.dead:
					continue
				for hx2 in HEXES:
					b.remove_status(String(hx2))
				b.hp = b.max_hp
				b.pressure = 0
				b.broken = false
				b.broken_pending = false
			u.tick_cooldowns()
			var c2: Dictionary = s.call("_choose_enemy_action", u, 0)
			var ab: Variant = c2.get("ability")
			var t: Variant = c2.get("target")
			if not (ab is Ability) or not (t is BattleUnit):
				continue
			actions += 1
			cast[(ab as Ability).display_name] = int(cast.get((ab as Ability).display_name, 0)) + 1
			await s._resolve(u, ab, t, "good")
			for h2 in party:
				for hx3 in HEXES:
					if (h2 as BattleUnit).has_status(String(hx3)):
						laid[hx3] = int(laid[hx3]) + 1
	var host_casts := {}
	for k in hosts:
		host_casts[String(hosts[k][1])] = int(cast.get(String(hosts[k][1]), 0))
	print("    CHECKED %d carriers, %d actions; laid on the party's side: %s; the hosts cast: %s" % [carriers.size(), actions, str(laid), str(host_casts)])
	var silent: Array = HEXES.keys().filter(func(h): return int(laid[h]) < 1)
	ok(carriers.size() == HEXES.size(), "§3: the board holds %d of the four carriers" % carriers.size())
	ok(silent.is_empty(), "§3: a hex was never laid in its carrier's own turns — the code does not fire: %s" % [silent])
	ok(host_casts.values().all(func(n): return int(n) >= 1), "§3: a move that carries a hex was never chosen in its carrier's own turns: %s" % str(host_casts))
	Engine.time_scale = 1.0


# C11: A COUNT A HEX, A COUNT A MOVE, THE BREAKS — integers, and nothing compared.
func _s3_the_count() -> void:
	print("\n§3 — the count, which is correctness: each hex laid, each re-derived move cast, the party's Breaks")
	var rows := _rows(_doc(KEPT_COUNT))
	ok(rows.size() >= 17, "§3: the kept table %s holds %d rows" % [KEPT_COUNT, rows.size()])
	var hexes := {}
	var moves := 0
	var breaks := 0
	var bad: Array = []
	for c in rows:
		if c.size() < 5:
			continue
		var what := String(c[0])
		if not String(c[3]).is_valid_int():
			bad.append("%s %s: %s" % [what, c[1], c[3]])
		if what == "a hex laid":
			hexes[String(c[1])] = int(c[3])
			if not String(c[4]).is_valid_int():
				bad.append("%s: its fights %s" % [c[1], c[4]])
		elif what == "a re-derived move cast":
			moves += 1
		elif what == "heroes Broken":
			breaks += 1
	print("    the hexes laid %s; %d re-derived moves counted; %d Break rows" % [str(hexes), moves, breaks])
	ok(hexes.size() == HEXES.size(), "§3: the count is not per hex: %s" % [hexes.keys()])
	ok(moves == 10 and breaks >= 2, "§3: the count lacks the ten re-derived moves or the Breaks (%d, %d)" % [moves, breaks])
	ok(bad.is_empty(), "§3: a count is not a plain count: %s" % [bad])
	var marked: Array = []
	for m in COMPARING:
		if _doc(KEPT_COUNT).contains(String(m)):
			marked.append(m)
	ok(marked.is_empty(), "§3: the count compares something — a reading, not a count: %s" % [marked])


# ── §4 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s4_not_done() -> void:
	print("\n§4 — no balance drive; the deck closed at twenty-five, no grade re-authored")
	var extra: Array = []
	for f in DirAccess.get_files_at("res://docs/reports"):
		if String(f).begins_with("JO") and not KEPT.has(String(f)) and String(f) != "JO.md":
			extra.append(String(f))
	print("    this batch's kept tables beside its report: %s" % str(KEPT))
	ok(extra.is_empty(), "§4: a table this batch keeps is a drive's or a reading's: %s" % [extra])
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.size() == DECK_CLOSED_AT, "§4: the deck holds %d, not the twenty-five it closed at" % mods.size())
	var moved: Array = []
	for k in DECK:
		if int((mods.get(k, {}) as Dictionary).get("severity", -1)) != int(DECK[k]):
			moved.append("%s %s" % [k, str((mods.get(k, {}) as Dictionary).get("severity"))])
	ok(moved.is_empty(), "§4: a grade was re-authored: %s" % [moved])


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
