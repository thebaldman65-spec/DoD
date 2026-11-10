# THE GATE FOR THE COUNT THAT GETS FIGHTS, AND THE PARTY's THREE ANSWERS READ OUT.
#
#   §0   JO's EIGHT RULINGS answered and archived, and no living text citing them as owed; THE THREE DIALS recorded and not pulled —
#        each reversal written where its change is recorded, every key and figure off the kept table, the table's "now" the tree's
#        and its "back to" the record it returns to (C06, C07).
#   §1   THE COUNT GETS FIGHTS WHERE THE WARBAND ATTACKS: the kept count is taken over those fights alone (C01) and every row carries
#        how many there were (C02); its population the four hexes, the ten JO re-derived, every kind of the warband; nothing
#        compared; the rule written beside the floor and in no other rule file; and every gate that needs the warband's attacks off
#        still turns them off at its own line (C03).
#   §2   THE THREE ANSWERS, READ AT SOURCE: every door of the kept readout names a file and a function that exist and quotes a line
#        standing in that function, and each of the three answers carries its doors (C04).
#   §3   WHAT IS DELIBERATELY NOT DONE: no card, talent, rune, status or ability authored (C05); no basic, hex, spend or Malice term
#        changed (C09); JO's counts as they were taken (C08); the deck closed at twenty-five (C10); no table beside the report a
#        drive's.
#   §4   the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them. **It drives no fight and loads no scene**: what it holds
#   is the kept tables, the documents, the source and the data — the count's fights are the battery's own, read off its logs before
#   the table was kept (`docs/reports/JP.md` §1).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jp.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const DECK_CLOSED_AT := 25
# THE KEPT TABLES THIS BATCH WRITES, AND NO OTHER: a drive's table is the one thing the floor forbids.
const KEPT := ["JP-count.tsv", "JP-dials.tsv", "JP-answers.md", "JP-routing.md"]
# JO's COUNT, AS IT WAS TAKEN: the kept table's digest on JO's tree (C08). The record is not re-derived.
const JO_COUNT_MD5 := "accbbf300180293bb4d98a690009794f"
# WHAT THE TREE HOLDS OF EACH KIND OF PLAYER CONTENT AND OF THE WARBAND, AS JO LANDED IT — each a digest this gate's own function
# (`_content`) took on HEAD's tree (C05, C09): a card, a talent, a rune, a status, the deck, the warband's data.
const CONTENT_AT_HEAD := {"abilities": "b40ad23bc9956e7e48f579d9a98b6da4", "talents": "39b2a530f39e58e62843ece5bbe05742", "runes": "d2ae95b06053d03696cd1d889a10cab3", "statuses": "67da0036a51071c6189ffbbb05bdb814",
	"deck": "1d1f37491e4611bb78f94577074ede99", "warband": "f261e6345f22f42bc41a7f81276e066b"}
# WHAT A LATER BATCH AUTHORED, EACH NAMED AND LEFT OUT OF THE DIGESTS ABOVE, so they go on asking whether JP's own tree authored
# anything: the two cards and the status of the party's three answers, built after JP (Forsake, Read the Tell, Forsaken).
const AUTHORED_SINCE := {"abilities": ["Forsake", "Read the Tell"], "statuses": ["forsaken"]}
# BATCH JR — THREE APPEARANCE TAGS MOVED AFTER THIS GATE LANDED (JR §1): the Grave Totem and the Rot Behemoth each took a
# roster, the Orc Hexer a second role. Each is named here and put back before the digest, so it goes on asking whether
# anything else in the warband's data moved.
const MOVED_SINCE := {"grave_totem": {"zones": [1.0, 3.0]}, "behemoth": {"zones": [2.0, 3.0]}, "hexer": {"roles": ["hexer"]}}
# BATCH JS — SEVEN KINDS AND TWO ROSTERS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its
# boss, and rosters 4 and 5 on the kinds tagged for all three old rosters. Each is named here and read apart, so this gate goes on
# asking its own question of the warband its batch left; `check_js` holds the seven.
# BATCH JU §1 — AND THE FOUR KINDS JU ADDED TO THE FOREST OF OLD, set aside as JS's seven are: this gate holds the warband its
# batch left, and a kind added after it is no figure of that warband moving.
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan",
	"grave_husk", "mossback", "blight_speaker", "carrion_pack"]
const ROSTERS_SINCE := [4, 5]
# MALICE's TERMS, ITS SPENDS' PRICES AND THE HEXES' FIGURES, AS THEY STAND (C09): each read off its constant, never retyped elsewhere.
const BATTLE_FIGURES := {"MALICE_DAMAGE_STEP": 10, "MALICE_PER_KILL": 25, "MALICE_CAP": 150, "MALICE_HEAL_WORTH": 0.5,
	"MALICE_RAISE_PCT": 0.4, "MALICE_RALLY_PCT": 0.3, "MALICE_RALLY_TURNS": 3, "MALICE_RALLY_PRICE": 40, "MALICE_ENTRENCH_TURNS": 3,
	"MALICE_ENTRENCH_PRICE": 30, "MALICE_RALLY_BODIES": 2}
const UNIT_FIGURES := {"MALICE_ENTRENCH_MULT": 2, "GALL_HEAL_CUT": 0.5, "SAP_CUT": 0.5, "MIRE_SLOW": 0.25}
const DOTS := {"fester": 3}
# THE RECORD's NEEDLES — the rules' own words where they stand.
const ANSWERED := "all accepted as taken"
const OWED_HEAD := "### JO's RULINGS OWED"
const STRUCK_HEAD := "### ~~JO's RULINGS OWED~~"
const FLOOR_HEAD := "BALANCE IS THE DESIGNER's, JUDGED BY PLAYING"
const COUNT_RULE := "THE COUNT IS TAKEN ONLY ON FIGHTS WHERE THE WARBAND ATTACKS, AND IT SAYS HOW MANY SUCH FIGHTS IT HAD"
const NOT_PULLED := "RECORDED, NOT PULLED"
# WHERE EACH DIAL's CHANGE IS RECORDED, AND SO WHERE ITS REVERSAL IS WRITTEN — by the order the designer would reach for them.
const DIAL_BLOCKS := {"1": "### THE CLERIC's MANA RATE", "2": "### THE WARBAND's COOLDOWNS",
	"3": "### WHAT THE RAISE DID, AND THE GAME WITH TALENTS"}
# EVERY FUNCTION THAT TURNS THE WARBAND's ATTACKS OFF, IN EVERY GATE, SUITE AND FIXTURE THAT HAS ONE — 44 sites in 31 files: a road
# that must not end in a wipe before the screen it asks about, a fight won to read what winning does, or a board where only the gate
# moves a body (C03). `docs/reports/JP.md` §1 names the reasons. A new gate's switch joins by being listed; none is derived, since a
# derived list cannot see a switch removed.
const ATTACKS_OFF := {"check_gj.gd": ["_initialize"], "check_gn.gd": ["_s3_the_spine_taker"], "check_go.gd": ["_screen_pass"],
	"check_gp.gd": ["_s4_the_road"], "check_gv.gd": ["_s4_the_road"], "check_hk.gd": ["_fight", "_s7_the_road"],
	"check_hl.gd": ["_crest_spawn", "_hero_rune_paid"], "check_hn.gd": ["_battle"],
	"check_ho.gd": ["_battle", "_win", "_s2b_the_fallen_rise", "_s2c_what_the_three_would_pay", "_healing_on", "_stretch"],
	"check_hp.gd": ["_battle", "_s1e_a_quit_fight_resumed", "_battle_on", "_s2b_the_route", "_s3_fellowship"],
	"check_hr.gd": ["_fight_from_map"], "check_hw.gd": ["_s1d_the_click_zones"], "check_ia.gd": ["_initialize"],
	"check_ic.gd": ["_board_under", "_s1a_worn_in_a_fight"], "check_id.gd": ["_s4b_mirrorbound"], "check_ih.gd": ["_s6_nothing_over_anything"],
	"check_ii.gd": ["_board_under"], "check_jd.gd": ["_next_fight"], "check_je.gd": ["_enter"], "check_jg.gd": ["_fight", "_unslotted_fight"],
	"check_jh.gd": ["_fight"], "check_ji.gd": ["_board"], "check_jj.gd": ["_board"], "check_jk.gd": ["_board"], "check_jl.gd": ["_board"],
	"check_jm.gd": ["_board"], "check_jo.gd": ["_board"], "gate_fixture.gd": ["spawn"], "suite_fixture.gd": ["spawn"],
	"test_batch_al.gd": ["_live_rallying_cry"], "test_batch_ax.gd": ["_live_fervor"]}
const OFF_LINE := "OS.set_environment(\"DOD_ENEMIES_OFF\", \"1\")"
# THE COUNT's SHAPE: what each row counts, and the column that says how many attacking fights it was taken over.
const COUNT_HEAD := ["what", "name", "whose, or where", "count", "attacking fights it happened in",
	"attacking fights its kind is fielded in", "attacking fights its kind struck in", "laid on a companion",
	"the attacking fights it is taken over"]
const COUNTED := ["a hex laid", "a re-derived move cast", "a move that carries a hex, cast", "a warband kind", "heroes Broken"]
# A COMPARISON's MARKS: a count that carries one is a reading.
const COMPARING := ["±", " z ", "(z ", "against", "paired", "before", "fell", "rose", "harder", "easier"]
const ANSWERS := {"1": "## 1. TAKING MALICE OUT OF THE POOL", "2": "## 2. REFUSING A HEX", "3": "## 3. READING WHAT THE WARBAND DECLARED"}
# EACH ANSWER's DOORS AS THE READOUT HOLDS THEM: a row struck is a door the readout stops reading.
const ANSWER_DOORS := {"1": 23, "2": 24, "3": 17}

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
	print("THE GATE FOR THE COUNT THAT GETS FIGHTS, AND THE PARTY's THREE ANSWERS READ OUT")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s0_the_rulings()
	_s0_the_dials()
	_s1_the_count()
	_s1_the_rule()
	_s1_attacks_off()
	_s2_the_answers()
	_s3_not_done()
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
	return rx.sub(s, " ", true).strip_edges()


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


func _consts(path: String) -> Dictionary:
	return (load(path) as Script).get_script_constant_map()


# A move of the warband's data, by its kind's key and its name.
func _move(kind: String, name: String) -> Dictionary:
	var data: Dictionary = Enemies._load()
	if not data.has(kind):
		return {}
	for a in data[kind]["abilities"]:
		if String((a as Dictionary).get("display_name", "")) == name:
			return a
	return {}


# A table's row by the cells it holds at two columns.
func _row_by(rows: Array, ca: int, a: String, cb: int, b: String) -> Array:
	for r in rows:
		if (r as Array).size() > maxi(ca, cb) and String(r[ca]) == a and String(r[cb]) == b:
			return r
	return []


# WHAT THE TREE HOLDS, A DIGEST A KIND: the names and the data each kind of content is, read through the doors the game reads it by.
func _content() -> Dictionary:
	var out := {}
	var names: Array = []
	for ab in Classes.ability_corpus():
		if not (AUTHORED_SINCE["abilities"] as Array).has(String((ab as Ability).display_name)):
			names.append(String((ab as Ability).display_name))
	names.sort()
	out["abilities"] = ("%d|" % names.size() + "|".join(names)).md5_text()
	var nodes: Array = []
	for n in Talents.TREE:
		nodes.append(JSON.stringify(n, "", true))
	out["talents"] = ("%d|" % nodes.size() + "|".join(nodes)).md5_text()
	out["runes"] = JSON.stringify(Runes._load(), "", true).md5_text()
	var st: Array = (_consts("res://scripts/battle.gd")["STATUS_INFO"] as Dictionary).keys().filter(
		func(k): return not (AUTHORED_SINCE["statuses"] as Array).has(String(k)))
	st.sort()
	out["statuses"] = ("%d|" % st.size() + "|".join(st)).md5_text()
	var deck: Array = (_run.MODIFIERS as Dictionary).keys()
	deck.sort()
	out["deck"] = ("%d|" % deck.size() + "|".join(deck)).md5_text()
	out["warband"] = JSON.stringify(_warband_as_landed(), "", true).md5_text()
	return out

# THE WARBAND's DATA WITH A LATER BATCH's APPEARANCE TAGS PUT BACK (`MOVED_SINCE`).
func _warband_as_landed() -> Dictionary:
	var d: Dictionary = Enemies._load().duplicate(true)
	for kind in MOVED_SINCE:
		if d.has(kind):
			for field in MOVED_SINCE[kind]:
				(d[kind] as Dictionary)[field] = (MOVED_SINCE[kind][field] as Array).duplicate()
	# BATCH JS — and the seven kinds and two rosters added since (`ADDED_SINCE`, `ROSTERS_SINCE`) taken out.
	for js_kind in ADDED_SINCE:
		d.erase(js_kind)
	for js_k in d:
		if (d[js_k] as Dictionary).has("zones"):
			(d[js_k] as Dictionary)["zones"] = ((d[js_k] as Dictionary)["zones"] as Array).filter(func(z): return not ROSTERS_SINCE.has(int(z)))
	return d


# ── §0 — JO's EIGHT RULINGS, AND THE THREE DIALS ──────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JO's eight rulings, answered and archived")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n" + OWED_HEAD), "§0: %s is still in the open queue — it was answered" % OWED_HEAD)
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), STRUCK_HEAD))
	var items := 0
	for n in range(1, 9):
		if struck.contains(" %d. **" % n):
			items += 1
	print("    the archive's struck block: %d of its eight rulings, answered: %s" % [items, str(struck.contains(ANSWERED))])
	ok(struck.contains(ANSWERED) and items == 8, "§0: the archive does not hold JO's eight rulings struck and answered (%d items)" % items)
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/instrument-rules.md",
			"res://docs/ways-of-working.md", "res://docs/master.html", "res://scripts/battle.gd"]:
		if _doc(p).contains(OWED_HEAD.substr(4)):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])


# C06, C07: EACH DIAL's EXACT REVERSAL, WHERE ITS CHANGE IS RECORDED — and the dial itself where it stands.
func _s0_the_dials() -> void:
	print("\n§0 — the three dials, recorded and not pulled")
	var rows := _rows(_doc("res://docs/reports/JP-dials.tsv"))
	var jo := _rows(_doc("res://docs/reports/JO-break.tsv"))
	var jn := _rows(_doc("res://docs/reports/JN-population.tsv"))
	var by := {"1": [], "2": [], "3": []}
	var pulled: Array = []
	var unrecorded: Array = []
	var not_its_record: Array = []
	for r in rows:
		if (r as Array).size() < 7:
			continue
		var dial := String(r[1])
		if not by.has(dial):
			continue
		(by[dial] as Array).append(r)
		var now := String(r[4])
		var back := String(r[5])
		if String(r[2]) == "scripts/unit.gd":
			# THE CUT: the constant where it stands, armed where it is armed, and "back to" the figure the setter cuts nothing at.
			var v: Variant = _consts("res://scripts/unit.gd").get(String(r[3]).get_slice(".", 1))
			if v == null or absf(float(v) - float(now)) > 0.0001:
				pulled.append("%s is %s, the table says %s" % [r[3], str(v), now])
			if not Gate.fn_body("scripts/battle.gd", "_spawn_units", _cache).contains("u.mana_gain_cut = BattleUnit.CLERIC_MANA_CUT"):
				pulled.append("the cut is no longer armed in _spawn_units")
			if not Gate.strip_comments(_doc("res://scripts/unit.gd")).contains("mana_gain_cut > 0.0") or back.is_empty() \
					or absf(float(back)) > 0.0001:
				not_its_record.append("the cut's reversal %s is not the figure the setter cuts nothing at" % back)
			continue
		var key := String(r[3]).split(" › ")
		if key.size() != 3:
			not_its_record.append("a key that names no move: %s" % r[3])
			continue
		var mv := _move(String(key[0]), String(key[1]))
		var field := String(key[2])
		var live := str(int(mv.get(field, 0))) if mv.has(field) else "absent"
		if mv.is_empty() or live != now:
			pulled.append("%s is %s, the table says %s" % [r[3], live, now])
		# "BACK TO" IS THE RECORD's FIGURE: JN's for the seven (JO-break's damage at JN), HEAD-before-JN's for the ten and their bands.
		var unit := Enemies.unit_name(String(key[0]))
		var want := ""
		if dial == "2":
			var jr := _row_by(jo, 1, unit, 8, String(key[1]))
			want = String(jr[12]) if not jr.is_empty() else "?"
		else:
			var nr := _row_by(jn, 1, unit, 4, String(key[1]))
			if nr.is_empty():
				want = "?"
			elif field == "damage":
				want = String(nr[9])
			else:
				want = "absent" if int(nr[12]) == 0 else String(nr[12])
		if back != want:
			not_its_record.append("%s goes back to %s, its record says %s" % [r[3], back, want])
		# THE REVERSAL, WRITTEN WHERE THE CHANGE IS RECORDED: the move and both figures, or the key and both figures.
		if field == "damage":
			var said := "%s %s → %s" % [key[1], now, back]
			if not _flat(_block(_doc("res://docs/state.md"), String(DIAL_BLOCKS[dial]))).contains(said):
				unrecorded.append("%s: %s" % [DIAL_BLOCKS[dial], said])
	var cut_said := "`BattleUnit.CLERIC_MANA_CUT` 0.5 → 0.0"
	for d in DIAL_BLOCKS:
		var blk := _flat(_block(_doc("res://docs/state.md"), String(DIAL_BLOCKS[d])))
		if not blk.contains(NOT_PULLED):
			unrecorded.append("%s does not say its dial is %s" % [DIAL_BLOCKS[d], NOT_PULLED])
	if not _flat(_block(_doc("res://docs/state.md"), String(DIAL_BLOCKS["1"]))).contains(cut_said):
		unrecorded.append("%s: %s" % [DIAL_BLOCKS["1"], cut_said])
	var b3 := _flat(_block(_doc("res://docs/state.md"), String(DIAL_BLOCKS["3"])))
	if not (b3.contains("cooldown key") and b3.contains("on nine of them") and b3.contains("all but the Wretched Bellow")):
		unrecorded.append("%s does not name the nine cooldown keys that go with the ten" % DIAL_BLOCKS["3"])
	print("    the table: %d rows for the cut, %d for JO's seven, %d for JN's ten; pulled %s; unrecorded %s" % [
		(by["1"] as Array).size(), (by["2"] as Array).size(), (by["3"] as Array).size(), str(pulled), str(unrecorded)])
	ok((by["1"] as Array).size() == 1 and (by["2"] as Array).size() == 7 and (by["3"] as Array).size() == 19,
		"§0: the dials' table does not hold the cut, JO's seven and JN's ten with their nine bands (%d, %d, %d)" % [
			(by["1"] as Array).size(), (by["2"] as Array).size(), (by["3"] as Array).size()])
	ok(pulled.is_empty(), "§0: a dial was pulled — %s" % [pulled])
	ok(not_its_record.is_empty(), "§0: a reversal's figure is not the record it returns to — %s" % [not_its_record])
	ok(unrecorded.is_empty(), "§0: a reversal is not written where its change is recorded, with its keys and figures — %s" % [unrecorded])


# ── §1 — THE COUNT GETS FIGHTS WHERE THE WARBAND ATTACKS ───────────────────────

func _s1_the_count() -> void:
	print("\n§1 — the count, taken only on fights where the warband attacks, and saying how many")
	var text := _doc("res://docs/reports/JP-count.tsv")
	var head := Array(text.get_slice("\n", 0).split("\t"))
	ok(head == COUNT_HEAD, "§1: the kept count's columns are not the count's — the denominator column is gone or moved: %s" % [head])
	var rows := _rows(text)
	var n_all := -1
	var n_off := -1
	var n_quiet := -1
	var n_att := -1
	var t_all := 0
	var t_off := 0
	var t_quiet := 0
	var targets := {}
	var counted := {}
	var undenominated: Array = []
	var over: Array = []
	var bad: Array = []
	for c in rows:
		var what := String(c[0])
		if what == "the fights" and c.size() >= 4:
			match String(c[1]):
				"the logs hold": n_all = int(c[3])
				"with enemy attacks off": n_off = int(c[3])
				"with attacks on and no warband strike": n_quiet = int(c[3])
				"where the warband attacks": n_att = int(c[3])
		elif what == "a target's fights" and c.size() >= 4:
			# "<off> with enemy attacks off, <quiet> with no warband strike"
			var off_t := int(String(c[2]).get_slice(" ", 0))
			var quiet_t := int(String(c[2]).get_slice(", ", 1).get_slice(" ", 0))
			t_all += int(c[3])
			t_off += off_t
			t_quiet += quiet_t
			targets[String(c[1])] = [int(c[3]), off_t, quiet_t]
	for c in rows:
		var what := String(c[0])
		if not COUNTED.has(what):
			continue
		counted[what] = int(counted.get(what, 0)) + 1
		if c.size() < COUNT_HEAD.size() or String(c[8]) != str(n_att):
			undenominated.append("%s %s" % [what, c[1]])
		if not String(c[3]).is_valid_int():
			bad.append("%s %s: %s" % [what, c[1], c[3]])
		for k in [4, 5, 6]:
			if k < c.size() and String(c[k]).is_valid_int() and int(c[k]) > n_att:
				over.append("%s %s: %s %s of %d" % [what, c[1], COUNT_HEAD[k], c[k], n_att])
	print("    %d fights the logs hold: %d with the warband's attacks off, %d with them on and no warband strike, %d where it attacks; the targets sum to %d, %d and %d" % [
		n_all, n_off, n_quiet, n_att, t_all, t_off, t_quiet])
	ok(n_att > 0 and n_off >= 0 and n_quiet >= 0 and n_all > n_att and n_att + n_off + n_quiet == n_all,
		"§1: the count does not say how many fights it was taken over (%d attacking, %d off, %d quiet, %d in all)" % [n_att, n_off, n_quiet, n_all])
	ok(t_all == n_all and t_off == n_off and t_quiet == n_quiet,
		"§1: the targets' fights (%d, %d off, %d quiet) are not the count's (%d, %d off, %d quiet)" % [t_all, t_off, t_quiet, n_all, n_off, n_quiet])
	ok(undenominated.is_empty(), "§1: a count stands without the number of attacking fights it was taken over: %s" % [undenominated])
	ok(over.is_empty(), "§1: a count was taken over more fights than the warband attacked in — it counts the attacks-off fights: %s" % [over])
	ok(bad.is_empty(), "§1: a count is not a plain count: %s" % [bad])
	# THE POPULATION, DERIVED: the four hexes, the ten JO re-derived, and every kind of the warband's data.
	var kinds := (Enemies._load() as Dictionary).keys().filter(func(k): return not ADDED_SINCE.has(String(k))).size()
	ok(int(counted.get("a hex laid", 0)) == 4 and int(counted.get("a re-derived move cast", 0)) == _rows(_doc("res://docs/reports/JO-break.tsv")).size()
		and int(counted.get("a warband kind", 0)) == kinds and int(counted.get("heroes Broken", 0)) >= 1,
		"§1: the count's population is not the four hexes, the ten and every kind (%s; %d kinds)" % [str(counted), kinds])
	# THE GATES THAT TURN THE WARBAND's ATTACKS OFF ARE ALL ATTACKS-OFF IN THE LOGS: the count read those fights as off, not as attacking.
	var leaked: Array = []
	for t in ["check_gv", "check_gp", "check_hk"]:
		if not targets.has(t) or int(targets[t][1]) != int(targets[t][0]):
			leaked.append("%s %s" % [t, str(targets.get(t, "absent"))])
	ok(leaked.is_empty(), "§1: a road the warband must not attack on is read as attacking: %s" % [leaked])
	var marked: Array = []
	for m in COMPARING:
		if text.contains(String(m)):
			marked.append(m)
	ok(marked.is_empty(), "§1: the count compares something — a reading, not a count: %s" % [marked])


# THE RULE, BESIDE THE FLOOR IT QUALIFIES, AND IN NO RULE FILE TWICE.
func _s1_the_rule() -> void:
	print("\n§1 — the count's rule, written beside the floor")
	var wow := _doc("res://docs/ways-of-working.md")
	var at := wow.find(FLOOR_HEAD)
	var para := wow.substr(at, wow.find("\n\n", at) - at) if at >= 0 else ""
	ok(_flat(para).contains(COUNT_RULE), "§1: the floor's paragraph does not carry the count's rule — %s" % COUNT_RULE)
	var twice: Array = []
	for p in ["res://CLAUDE.md", "res://docs/instrument-rules.md", "res://docs/combat-rules.md"]:
		if _flat(_doc(p)).contains(COUNT_RULE):
			twice.append(p)
	ok(twice.is_empty(), "§1: the count's rule stands in a second rule file too: %s" % [twice])


# C03: A GATE THAT NEEDS THE WARBAND's ATTACKS OFF STILL TURNS THEM OFF, AT ITS OWN LINE.
func _s1_attacks_off() -> void:
	print("\n§1 — every gate that needs the warband's attacks off still turns them off")
	var on: Array = []
	var read := 0
	for f in ATTACKS_OFF:
		for fn in ATTACKS_OFF[f]:
			read += 1
			if not Gate.fn_body(String(f), String(fn), _cache).contains(OFF_LINE):
				on.append("%s %s" % [f, fn])
	# THE SWITCH's WHOLE POPULATION, PRINTED BESIDE THE SITES HELD: the rest each a gate's own board, whose fights print no log.
	var all_sites := 0
	var all_files := 0
	for f2 in DirAccess.get_files_at("res://"):
		if String(f2).ends_with(".gd") and (String(f2).begins_with("check_") or String(f2).begins_with("test_") or String(f2).ends_with("_fixture.gd")):
			var n2 := Gate.strip_comments(FileAccess.get_file_as_string("res://" + String(f2))).count(OFF_LINE)
			if n2 > 0:
				all_sites += n2
				all_files += 1
	print("    CHECKED %d sites in %d files, of the %d sites in %d files that set the switch" % [read, ATTACKS_OFF.size(), all_sites, all_files])
	ok(read > 0 and on.is_empty(), "§1: a gate that needs the warband's attacks off no longer turns them off: %s" % [on])
	# AND THE BATTLE STILL READS THE SWITCH, AND STILL SKIPS THE TURN: the count's attacks-off fights are the loop's own skip.
	ok(Gate.fn_body("scripts/battle.gd", "_enemy_turn", _cache).contains("skips its turn (enemy attacks off)")
		and Gate.fn_body("scripts/battle.gd", "_ready", _cache).contains("DOD_ENEMIES_OFF"),
		"§1: the battle no longer reads the attacks-off switch or no longer logs the skipped turn the count reads")


# ── §2 — THE THREE ANSWERS, READ AT SOURCE ─────────────────────────────────────

func _s2_the_answers() -> void:
	print("\n§2 — the party's three answers, each door read at source")
	var text := _doc("res://docs/reports/JP-answers.md")
	var sec := ""
	var doors := {"1": 0, "2": 0, "3": 0}
	var bad: Array = []
	for raw in text.split("\n"):
		var line := String(raw)
		for k in ANSWERS:
			if line.begins_with(String(ANSWERS[k])):
				sec = String(k)
		if sec == "" or not line.begins_with("| "):
			continue
		var cells: Array = Array(line.strip_edges().trim_prefix("|").trim_suffix("|").split("|")).map(func(x): return String(x).strip_edges())
		if cells.size() != 4 or String(cells[0]) == "door" or String(cells[0]).begins_with("---"):
			continue
		var path := String(cells[1]).trim_prefix("`").trim_suffix("`")
		var fn := String(cells[2]).trim_prefix("`").trim_suffix("`")
		var q := String(cells[3])
		if not (q.begins_with("`") and q.ends_with("`") and q.length() > 2):
			bad.append("§%s %s: quotes nothing" % [sec, cells[0]])
			continue
		q = _flat(q.substr(1, q.length() - 2))
		var body := Gate.strip_comments(_doc("res://" + path)) if fn == "—" else Gate.fn_body(path, fn, _cache)
		if body == "":
			bad.append("§%s %s: no door %s in %s" % [sec, cells[0], fn, path])
		elif not _flat(body).contains(q):
			bad.append("§%s %s: %s does not say `%s`" % [sec, cells[0], fn, q])
		else:
			doors[sec] = int(doors[sec]) + 1
	print("    doors read at source: %s" % str(doors))
	for k in ANSWERS:
		ok(text.contains(String(ANSWERS[k])) and int(doors[k]) >= int(ANSWER_DOORS[k]),
			"§2: %s carries %d doors read at source, of the %d it holds" % [ANSWERS[k], int(doors[k]), int(ANSWER_DOORS[k])])
	ok(bad.is_empty(), "§2: the readout names a door that does not exist, or quotes none: %s" % [bad])


# ── §3 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s3_not_done() -> void:
	print("\n§3 — nothing authored, nothing the brief held moved, JO's counts as taken, the deck at twenty-five")
	var now := _content()
	print("    the content's digests: %s" % str(now))
	var authored: Array = []
	for k in ["abilities", "talents", "runes", "statuses"]:
		if String(now[k]) != String(CONTENT_AT_HEAD[k]):
			authored.append(k)
	ok(authored.is_empty(), "§3: player content was authored or changed — a card, talent, rune or status: %s" % [authored])
	ok(String(now["warband"]) == String(CONTENT_AT_HEAD["warband"]),
		"§3: the warband's data moved — a basic, a hex's blow, a spend or a move changed")
	var moved: Array = []
	var bc := _consts("res://scripts/battle.gd")
	for k in BATTLE_FIGURES:
		if bc.get(k) == null or absf(float(bc.get(k)) - float(BATTLE_FIGURES[k])) > 0.0001:
			moved.append("%s %s" % [k, str(bc.get(k))])
	var uc := _consts("res://scripts/unit.gd")
	for k2 in UNIT_FIGURES:
		if uc.get(k2) == null or absf(float(uc.get(k2)) - float(UNIT_FIGURES[k2])) > 0.0001:
			moved.append("%s %s" % [k2, str(uc.get(k2))])
	var dot: Dictionary = bc.get("DOT_STATUSES", {})
	for k3 in DOTS:
		if int(dot.get(k3, -1)) != int(DOTS[k3]):
			moved.append("DOT_STATUSES.%s %s" % [k3, str(dot.get(k3))])
	ok(moved.is_empty(), "§3: a Malice term, a spend's price or a hex's figure changed: %s" % [moved])
	var jo_now := _doc("res://docs/reports/JO-count.tsv").md5_text()
	ok(jo_now == JO_COUNT_MD5, "§3: JO's count was re-derived or edited — its record is as it was taken (%s)" % jo_now)
	ok((_run.MODIFIERS as Dictionary).size() == DECK_CLOSED_AT and String(now["deck"]) == String(CONTENT_AT_HEAD["deck"]),
		"§3: the deck holds %d, not the twenty-five it closed at, or a card was swapped in it" % (_run.MODIFIERS as Dictionary).size())
	var extra: Array = []
	for f in DirAccess.get_files_at("res://docs/reports"):
		if String(f).begins_with("JP") and not KEPT.has(String(f)) and String(f) != "JP.md":
			extra.append(String(f))
	ok(extra.is_empty(), "§3: a table this batch keeps is a drive's or a reading's: %s" % [extra])


# ── §4 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s4_the_players_files() -> void:
	print("\n§4 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§4: %s changed under this gate" % p)
