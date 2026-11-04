# BATCH JG — COMMUNION, THE FIRST RUNE SINCE HP.
#
#   §0   THE RULINGS JF OWED, EACH IN THE FILE IT BINDS: the ties' rule in its second wording (C01), the worth rule's figures and the rate where *Ruin runes*
#        stood (C02), the recon rule reaching instruments and the runner (C03), the writing rule in the file that binds a brief.
#   §1   THE CREST POOL, RULED: the four uptimes beside the ruling, read off the table of record (C04); the cap (C05); Tithe's read site, not moved; the floor with
#        its derivation from its two ends, each recomputed (C06).
#   §2   WHAT THE DOOR ASKS AND WHAT IT IS WORTH: a named core, any standing hero, driven both ways; every row of the table with its population, rung and crest
#        state, its share its own arithmetic (C07); *every hero holds a core* on every hero turn of every cell, turn for turn; the spread read against the words.
#   §3   COMMUNION: the entry and its shape; its figure the floor's quotient, off the table (C08); its card reading its constant (C09); a real fight that pays with
#        every hero standing and through its holder's fall and rise (C10); the writers of its condition, beside the absence inside a fight (C11); the drop, the
#        Peddler and the event verb driven, never a hero's own pick (C12); a `rune_` field (C13); the name, swept whole; the price against a true none, both
#        pairings, off its tables.
#   §5   WHAT IS DELIBERATELY NOT DONE: the four's figures and their conditions, Fellowship, the deck (C15), `JE-crest.tsv`.
#   §6   THE VERIFICATION: the positional tool's control, read off its kept table: the tool lives outside the tree, so the arm reads the table (C14).
#   §7   THE PLAYER'S FILES, as this gate found them.
#
#   **SINCE THE RE-KEY (JH §1) THE RUNE IS `check_jh`'s**: every arm here that read JG's build — the named core, the flag, the code
#   constant — prints what it read as a `[record]` and asserts the fact that retired it (HG §2a's shape), and every needle into a
#   block JH archived reads the record where it landed, the live block and its closed items together.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jg.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# TWO EQUALITIES ON WHAT GROWS, EACH A TRIPWIRE BY RULING: the deck is closed (the pin `check_jc` to `check_jf` hold), and a condition shape is the designer's (§2a).
const DECK_CLOSED_AT := 25
const LADDER_HEAD := "## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"
const CREST_HEAD := "## STANDING RULE — THE PARTY SCOPE, AND THE RUNES IT HOLDS"
const TIES := "TWO READINGS OF ONE POPULATION ON ONE SEED BLOCK ARE NAMED AS CORRELATED"
const FLOOR_RULE := "A NEW CREST RUNE's MAGNITUDE × UPTIME CLEARS 5% ON THE POPULATION THAT FINISHES RUNS, OR THE CONDITION IS TOO RARE AND THE RUNE DOES NOT SHIP"
const STOP_RULE := "IF THE FIGURE THE FLOOR DEMANDS IS ABOVE 75%, THE POOL's LARGEST, THE CONDITION IS TOO RARE AND THE ANSWER IS A DIFFERENT CONDITION, NOT A BIGGER NUMBER"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
# THE REFERENCE FOUR'S CORES: the Cleric's is the one Communion asks, and `BARE` is the same party whose Cleric wears another.
const WORN := ["bloodrage", "permafrost", "conviction", "pack"]
const BARE := ["bloodrage", "permafrost", "mercy", "pack"]
const CLERIC_SEAT := 2
const SCRATCH_PROFILE := "user://jg_profile.json"
const SCRATCH_RELICS := "user://jg_relics.json"
const FOUR_LIVE := {"dirge": {"heroes_all_standing": false}, "dead_air": {"heroes_lack_class": "mage"}, "empty_pulpit": {"heroes_lack_class": "cleric"}, "tithe": {}}
# THE TWO ROWS JF's WORTH RULE NAMES: the population the figure answers to.
const ROWS := [["the reference four", "1"], ["the incumbent", "3"]]
const RETIRED_RULE_ENGINES := ["quarry_hunt", "opening_strike"]
# JG'S BUILD, AS THE RECORD: the core it named and the figure it derived. The live rune is the re-key's, and its key is this one.
const JG_CORE := "conviction"
const JG_FIG := 0.11
const JH_KEY := "heroes_all_hold_cores"
# THE DESIGNED NAMES THE RECORD HOLDS (no list of reserved names exists): the conjunctions, their old names, the two engines owing new ones, and BA §1's space.
const RESERVED := ["Seize", "Marrowfire", "Contagion", "Reckoning", "Breach", "Blight", "Skirmisher", "Tracker", "Virulence", "Epidemic", "Plague Bearer", "Creeping Death"]

var _g := Gate.new()
var _docs := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JG — COMMUNION, THE FIRST RUNE SINCE HP")
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
	_s1_the_pool()
	_s2_the_read()
	_s3a_the_entry()
	_s3b_the_figure()
	_s3c_the_card()
	await _s3d_the_fight()
	await _s3e_the_writers()
	_s3f_the_draw()
	_s3g_the_field()
	_s3h_the_name()
	_s3i_the_price()
	_s5_not_done()
	_s6_the_verification()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s7_the_players_files()
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


func _tsv(path: String, need: Array) -> Array:
	var lines := _doc(path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	var missing: Array = []
	for c in need:
		if not head.has(c):
			missing.append(c)
	ok(missing.is_empty(), "%s lacks the columns %s" % [path, str(missing)])
	var out: Array = []
	var torn := 0
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			torn += 1
			continue
		var row := {}
		for i in head.size():
			row[head[i]] = f[i]
		out.append(row)
	ok(torn == 0, "%s: %d rows do not hold the table's columns" % [path, torn])
	return out


# One condition's share on one row of the table, or -1.0.
func _share(rows: Array, pop: String, rung: String, cond: String) -> float:
	for r in rows:
		if String(r["population"]) == pop and String(r["rung"]) == rung and String(r["scope"]) == "runs that finish" and String(r["condition"]) == cond:
			return float(r["share"])
	return -1.0


# One rune's uptime on the reference four at Wanderer, on the runs that finish, off JF's table of record.
func _jf_share(rows: Array, rune: String) -> float:
	for r in rows:
		if String(r["population"]) == "the reference four" and String(r["rung"]) == "1" and String(r["arm"]) == "no crest worn" and String(r["scope"]) == "runs that finish" and String(r["rune"]) == rune:
			return float(r["turns_held"]) / float(r["hero_turns"])
	return -1.0


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


# A fresh run of the four, each awakened on the core `cores` names for his seat.
func _new_run(cores: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(cores[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.items = {}


# The crest worn through the run's own door — the bag, then the function the bag panel's Equip button is bound to.
func _wear_crest(id: String) -> bool:
	if not Runes.ids().has(id):
		return false
	_run.bag_rune(Runes.build(id))
	var rows: Array = _run.party_rune_rows()
	for i in rows.size():
		if String(rows[i]["src"]) == "bag" and String((rows[i]["rune"] as Dictionary).get("id", "")) == id:
			return bool(_run.toggle_party_rune(i))
	return false


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene for a party on `cores`, the crest worn when `worn`, a Revive Potion in the pouch when `potion`.
func _fight(cores: Array, worn: bool, potion := false) -> Node:
	_new_run(cores)
	if worn:
		_wear_crest("communion")
	if potion:
		_run.items = {"revive": 1}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _c(s: Node, name: String) -> String:
	return String((s.get_script() as Script).get_script_constant_map().get(name, "<no %s>" % name))


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


# Whether a worn crest rune's live stamp is on: the battle's own record of what pays.
func _paying(s: Node) -> bool:
	for e in s.get("_live_stamps"):
		if bool((e as Dictionary).get("crest", false)) and bool((e as Dictionary).get("on", false)):
			return true
	return false


# A RECORD WHERE IT STANDS: the live block and what JH archived of it, under the archive's own heading for its closed items.
func _record(head: String) -> String:
	var live := _block(_doc("res://docs/state.md"), head)
	var arch := _block(_doc("res://DoD-archive/state-archive.md"), head + " — ITS CLOSED ITEMS (archived at JH")
	return _flat(live + "\n" + arch)


func _fell(s: Node, seat: int) -> void:
	(_heroes(s)[seat] as BattleUnit).take_hit(999999, 0)
	await process_frame


func _revived(s: Node) -> void:
	s.set("item_used", false)
	s._use_item("revive")
	await process_frame


# One seeded basic of `atk` on foe `fi`; returns the health it took.
func _blow(s: Node, atk: BattleUnit, sd: int, fi: int) -> int:
	var foe: BattleUnit = s.get("enemies")[fi]
	foe.max_hp = 200000
	foe.hp = foe.max_hp
	foe.pressure = 0
	foe.broken = false
	atk.cooldowns.clear()
	atk.no_cover = 1
	# A BLOW LARGE ENOUGH TO READ THE MULTIPLIER: at a raider's 18 health a blow, 11% is inside the rounding, and an arm that cannot tell paid from unpaid proves nothing. Attack is no field this gate measures.
	atk.attack = 4000
	var was := foe.hp
	seed(sd)
	await s._resolve(atk, atk.abilities[0], foe, "good")
	return was - foe.hp


# THE LIVE FIGURE, A PAYLOAD's SINCE THE RE-KEY (JH §0.2): the texts that state it read this.
func _strike() -> float:
	return float(((Runes.config("communion").get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get("dmg_bonus", -1.0))


func _pct() -> int:
	return int(round(_strike() * 100.0))


func _cond() -> Dictionary:
	return (Runes.config("communion").get("payload", {}) as Dictionary).get("condition", {})


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings JF owed, each in the file it binds")
	var rules := _doc("res://CLAUDE.md")
	var ladder := _flat(_block(rules, LADDER_HEAD))
	ok(ladder.contains(TIES), "§0a: the ties' rule does not read two readings of one population on one seed block")
	ok(ladder.contains("WHAT MATTERS IS THE SHARED SEEDS"), "§0a: the ties' rule does not say what matters")
	var old_tie := "A TIE BETWEEN TWO BATCHES' " + "ARMS"
	var state := _doc("res://docs/state.md")
	var run_src := _doc("res://scripts/run_state.gd")
	ok(not ladder.contains(old_tie), "§0a: the ties' rule stands in its old wording in the ladder block")
	ok(not run_src.contains(old_tie), "§0a: the comment above `Run.MODIFIERS` stands in the old wording")
	ok(run_src.contains(TIES), "§0a: the comment above `Run.MODIFIERS`, the rule's second home, does not carry the new wording")
	ok(_flat(_block(state, "### THE BARGAIN DECK's GRADES")).contains("Two readings of one population on one seed block are named as correlated"), "§0a: the grades block does not carry the new wording")
	# *RUIN RUNES* STRUCK, AND THE UPTIMES THE RULE QUOTES ARE THE TRUE NONE's.
	var crest := _flat(_block(rules, CREST_HEAD))
	var ruin := "Ruin " + "runes"
	ok(not crest.contains(ruin) and not crest.contains(ruin.to_upper()), "§0b: *Ruin runes* stands in the crest block")
	ok(not state.contains(ruin) and not state.contains(ruin.to_upper()), "§0b: *Ruin runes* stands in docs/state.md")
	ok(crest.contains("A hero turn of a lost run holds them four to thirteen times as often as one of a run that finishes"), "§0b: the rate does not stand in the worth rule")
	var rows := _tsv("res://docs/reports/JF-uptimes.tsv", ["population", "rung", "arm", "scope", "rune", "turns_held", "hero_turns"])
	var dirge := _jf_share(rows, "dirge")
	ok(crest.contains("Dirge at 45%% over %.1f%% of turns" % (dirge * 100.0)), "§0b: the worth rule's uptime is not the table's (%.1f%%)" % (dirge * 100.0))
	var je_figure := "over 1.4" + "% of turns"
	ok(not crest.contains(je_figure), "§0b: the worth rule states JE's uptime, the default arm's")
	# THE RECON RULE: THE GAME's CODE OR DATA, AND EVERYTHING ELSE THE PRE-RUN's.
	var instr := _flat(_doc("res://docs/instrument-rules.md"))
	ok(instr.contains("A RECON IS OWED WHEN THE GAME's CODE OR DATA MOVES. A GATE's, AN INSTRUMENT's OR THE RUNNER's OWN CHANGE IS COVERED BY THE PRE-RUN THAT RUNS IT"), "§0c: the recon rule does not reach instruments and the runner")
	# THE WRITING RULE, IN THE FILE THAT BINDS A BRIEF.
	var wow := _flat(_doc("res://docs/ways-of-working.md"))
	ok(wow.contains("A FIGURE IN A BRIEF CARRIES THE POPULATION IT WAS READ ON, AND A CITATION NAMES ITS SECTION"), "§0d: the writing rule is not in the file that binds a brief")


# ── §1 — THE CREST POOL, RULED ────────────────────────────────────────────────

func _s1_the_pool() -> void:
	print("\n§1 — the crest pool, ruled")
	var crest := _flat(_block(_doc("res://CLAUDE.md"), CREST_HEAD))
	ok(crest.contains("THREE OF THE FOUR KEY ON A HERO BEING DOWN, AND A HERO BEING DOWN IS RARE IN A RUN THAT FINISHES"), "§1a: the ruling is not in the crest block")
	# THE FOUR UPTIMES BESIDE THE RULING, EACH READ OFF THE TABLE OF RECORD, EACH PRODUCT ITS OWN ARITHMETIC.
	var rows := _tsv("res://docs/reports/JF-uptimes.tsv", ["population", "rung", "arm", "scope", "rune", "turns_held", "hero_turns"])
	var at := crest.find("THE POOL IS THREE PARTS INSURANCE AND ONE PART A RUNE")
	ok(at >= 0, "§1a: the ruling has no head")
	var ruling := crest.substr(at, crest.find("THE CAP STAYS AT ONE", at) - at) if at >= 0 else ""
	ok(ruling.contains("Empty Pulpit") and ruling.ends_with("· **"), "§1a: the ruling's window does not end at the next ruling: %d characters" % ruling.length())
	for spec in [["tithe", "Tithe", 30.0, 0], ["dirge", "Dirge", 45.0, 2], ["dead_air", "Dead Air", 75.0, 1], ["empty_pulpit", "Empty Pulpit", 50.0, 2]]:
		var up := _jf_share(rows, String(spec[0]))
		var fig := (String(spec[1]) + " %.1f%%") % (up * 100.0)
		var prod := up * float(spec[2])
		var said := ("%%.%df%%%%" % int(spec[3])) % prod
		ok(ruling.contains(fig), "§1a: the ruling does not state %s's uptime beside it (%s)" % [spec[1], fig])
		ok(ruling.contains(said), "§1a: the ruling does not state %s's product (%s)" % [spec[1], said])
	ok(int(_run.PARTY_RUNE_SLOTS) == 1, "§1b: the crest's cap moved to %d" % int(_run.PARTY_RUNE_SLOTS))
	ok(crest.contains("THE CAP STAYS AT ONE") and crest.contains("WIDEN THE SLOT WHEN THE POOL IS WORTH FILLING, NOT BEFORE"), "§1b: the cap's ruling is not in the crest block")
	ok(crest.contains("TITHE's READ SITE WAITS ON THE TALENT's OWN BATCH"), "§1c: Tithe's ruling is not in the crest block")
	var bt := _doc("res://scripts/battle.gd")
	ok(bt.contains("var bc_pct: int = attacker.blood_communion + attacker.rune_blood_communion"), "§1c: Tithe's read site moved")
	# THE FLOOR, AND ITS DERIVATION FROM ITS OWN TWO ENDS: each recomputed, the floor between them.
	ok(crest.contains(FLOOR_RULE), "§1d: the floor's rule is not in the crest block")
	ok(crest.contains(STOP_RULE), "§1d: the floor's stop is not in the crest block")
	var low := _jf_share(rows, "dirge") * 45.0
	var high := _jf_share(rows, "tithe") * 30.0
	ok(crest.contains("Tithe's product is about %d%%, Dirge's %.2f%%" % [int(round(high)), low]), "§1d: the floor is written without its derivation from Tithe (%.1f) and Dirge (%.2f)" % [high, low])
	ok(low < 5.0 and 5.0 < high, "§1d: the floor no longer stands between the pool's two ends (%.2f, %.1f)" % [low, high])
	ok(crest.contains("reachable at 25% uptime and 20%"), "§1d: the rule does not say the floor is reachable")


# ── §2 — WHAT THE DOOR ASKS AND WHAT IT IS WORTH ──────────────────────────────

func _s2_the_read() -> void:
	print("\n§2 — what the door asks, and the table of what it is worth")
	# THE DOOR, BOTH WAYS: A NAMED CORE, ANY HERO WHO STANDS.
	var holder := {"key": "cleric", "hp": 10, "engines": [{"engine": "conviction", "equipped": true}]}
	var other := {"key": "warrior", "hp": 10, "engines": [{"engine": "bloodrage", "equipped": true}]}
	var down: Dictionary = holder.duplicate(true)
	down["hp"] = 0
	var key := {"heroes_hold_core": "conviction"}
	ok(Talents.party_condition_met(key, [other, holder]), "§2a: the door does not hold with one standing hero wearing the named core")
	ok(not Talents.party_condition_met(key, [other, down]), "§2a: the door holds with the one holder down")
	ok(not Talents.party_condition_met({"heroes_hold_core": "pack"}, [other, holder]), "§2a: the door takes any core: it holds with the named one on nobody")
	ok(Talents.HERO_KEYS.size() == 6 and Talents.HERO_KEYS.has(JH_KEY) and Talents.LIVE_KEYS.size() == 6 and Talents.LIVE_KEYS.has(JH_KEY),
		"§2a: a condition shape was added beyond the one the designer authorized at the re-key: %s" % str(Talents.HERO_KEYS))
	var rows := _tsv("res://docs/reports/JG-uptimes.tsv", ["population", "rung", "scope", "runs", "finished", "crest_at_the_end", "hero_turns", "kind", "condition", "turns_held", "share", "fidelity"])
	ok(rows.size() >= 300, "§2b: the table holds %d rows" % rows.size())
	var bare: Array = []
	var worn := 0
	var wrong: Array = []
	var seen := {}
	var hold_all: Array = []
	var every_read := 0
	for r in rows:
		if String(r["population"]).strip_edges() == "" or String(r["rung"]).strip_edges() == "" or String(r["crest_at_the_end"]).strip_edges() == "" or String(r["fidelity"]).length() < 40:
			bare.append(r["condition"])
		if not String(r["crest_at_the_end"]).begins_with("0 of"):
			worn += 1
		var ht := int(r["hero_turns"])
		if ht > 0 and String(r["share"]) != "-" and String(r["condition"]).begins_with("core runes held") == false and absf(float(r["share"]) - float(r["turns_held"]) / ht) > 0.00006:
			wrong.append("%s %s %s" % [r["population"], r["rung"], r["condition"]])
		seen["%s|%s" % [r["population"], r["rung"]]] = true
		if String(r["condition"]) == "every standing hero holds a core rune" and ht > 0:
			every_read += 1
			if int(r["turns_held"]) != ht:
				hold_all.append("%s %s, %s: %s of %d" % [r["population"], r["rung"], r["scope"], r["turns_held"], ht])
	ok(bare.is_empty(), "§2b: %d uptimes carry no population, rung, crest state or fidelity: %s" % [bare.size(), str(bare.slice(0, 4))])
	ok(wrong.is_empty(), "§2b: %d shares are not their own arithmetic: %s" % [wrong.size(), str(wrong.slice(0, 3))])
	ok(worn == 0, "§2b: %d rows ended a run wearing a crest rune" % worn)
	for pop in ["the reference four", "the incumbent"]:
		for rung in ["1", "2", "3"]:
			ok(seen.has("%s|%s" % [pop, rung]), "§2b: no row for %s at rung %s" % [pop, rung])
	ok(seen.has("the reference four, three relics|1"), "§2b: no row for the three-relic arm")
	# A ROW DELETED IS A ROW NOTHING READS: EVERY CELL, EVERY SCOPE, HOLDS EVERY COUNT.
	var counts := {}
	for r0 in rows:
		if String(r0["kind"]) == "count":
			var k0 := "%s|%s|%s" % [r0["population"], r0["rung"], r0["scope"]]
			counts[k0] = int(counts.get(k0, 0)) + 1
	var short: Array = []
	for k1 in counts:
		if int(counts[k1]) != 15:
			short.append("%s: %d" % [k1, int(counts[k1])])
	ok(counts.size() == 14 and short.is_empty(), "§2b: %d cell scopes, and these lost a count: %s" % [counts.size(), str(short)])
	# *EVERY HERO HOLDS A CORE* IS TRUE ON EVERY HERO TURN: A CORE IS TAKEN AT CLASS SELECTION AND THE BOT NEVER UNSLOTS ONE.
	ok(every_read == 13 and hold_all.is_empty(), "§2c: *every hero holds a core* read on %d of the 13 cells with hero turns, and under every turn on %s" % [every_read, str(hold_all)])
	print("    CHECKED %d cells: every standing hero holds a core on every hero turn" % every_read)
	var state := _record("### THE CREST POOL")
	ok(state.contains("holds on every hero turn of every run on every cell"), "§2c: the crest block does not say what the read found")
	# THE SPREAD THE BLOCK STATES, OFF THE TABLE: THE FOUR LINEAGE CORES OF THE REFERENCE FOUR, AND THE TWENTY OTHERS.
	var held: Array = []
	for r in rows:
		if String(r["population"]) == "the reference four" and String(r["rung"]) == "1" and String(r["scope"]) == "runs that finish" and String(r["kind"]) == "core":
			held.append(float(r["share"]) * 100.0)
	held.sort()
	ok(held.size() == 24, "§2e: the reference four at Wanderer reads %d cores, not 24" % held.size())
	if held.size() == 24:
		var said := "its four lineage cores %.1f to %.1f%%, the twenty others %.1f to %.1f%%" % [held[20], held[23], held[0], held[19]]
		ok(state.contains(said), "§2e: the crest block does not state the spread: %s" % said)
	# THE LOWER EVERY-HERO READING RISES THROUGH THE RUN: WHAT THE CARD'S WORDS WANTED, AND THE DOOR LACKS.
	var zones := _tsv("res://docs/reports/JG-uptimes-zones.tsv", ["population", "rung", "scope", "zone", "condition", "share"])
	var two := "every standing hero holds two or more"
	var read := {}
	for z in zones:
		if String(z["population"]) == "the reference four" and String(z["rung"]) == "1" and String(z["scope"]) == "runs that finish" and String(z["condition"]) == two:
			read[String(z["zone"])] = float(z["share"])
	ok(read.size() == 3 and float(read["1"]) < float(read["2"]) and float(read["2"]) < float(read["3"]), "§2d: two or more does not rise through the run: %s" % str(read))
	print("    CHECKED %d rows on %d cells; two or more, by zone: %s" % [rows.size(), seen.size(), str(read)])


# ── §3 — COMMUNION ────────────────────────────────────────────────────────────

func _s3a_the_entry() -> void:
	print("\n§3a — the entry and its shape")
	var e: Dictionary = Runes.config("communion")
	ok(not e.is_empty(), "§3a: `communion` is not in data/runes.json")
	ok(String(e.get("name", "")) == "Communion" and String(e.get("scope", "")) == "party" and int(e.get("price", 0)) == 150 and not Runes.is_retired("communion"), "§3a: the entry is %s" % str(e))
	ok(Talents.is_live(e.get("payload", {})) and Talents.live_refusal(e.get("payload", {})) == "", "§3a: the live door refuses its payload: %s" % Talents.live_refusal(e.get("payload", {})))
	ok(not Runes.is_refused(Runes.config("communion")), "§3a: the roll refuses it")
	ok(Runes.RUNE_SHAPES.get("communion", []) == ["STAT", "CONDITIONAL"], "§3a: its shape is %s" % str(Runes.RUNE_SHAPES.get("communion", [])))
	ok(Runes.RUNE_TAGS.get("communion", []) == ["OFFENSE"], "§3a: its tag is %s" % str(Runes.RUNE_TAGS.get("communion", [])))
	var cond := _cond()
	print("    [record] JG's condition named one core, `heroes_hold_core: %s`; the re-key's is %s" % [JG_CORE, str(cond)])
	ok(cond.size() == 1 and cond.has(JH_KEY) and not cond.has("heroes_hold_core"), "§3a: its condition is %s: the rune names a core again, the key its re-key retired" % str(cond))
	ok(int(_run.PARTY_RUNE_SLOTS) == 1 and not e.is_empty() and Runes.is_party_rune(Runes.build("communion")), "§3a: it does not go in the crest")


func _s3b_the_figure() -> void:
	print("\n§3b — its figure, the floor's quotient, off the table")
	var rows := _tsv("res://docs/reports/JG-uptimes.tsv", ["population", "rung", "scope", "condition", "share", "kind"])
	var core := JG_CORE
	var lower := 2.0
	for row in ROWS:
		var up := _share(rows, String(row[0]), String(row[1]), core)
		print("    %s on %s, rung %s, runs that finish: %.4f" % [core, row[0], row[1], up])
		ok(up > 0.0, "§3b: the table holds no reading of %s on %s" % [core, row[0]])
		lower = minf(lower, up)
	var quotient := 0.05 / lower
	var want := ceilf(quotient * 100.0 - 0.000001) / 100.0
	print("    [record] 0.05 / %.4f = %.4f, a whole percent up %.2f; JG's figure was %.4f, and the re-key's is %.4f, off its own reading (`check_jh` §1d)" % [lower, quotient, want, JG_FIG, _strike()])
	ok(is_equal_approx(JG_FIG, want), "§3b: JG's figure %.2f is not the floor's quotient off its own kept table (%.4f, a whole percent up %.2f)" % [JG_FIG, quotient, want])
	ok(JG_FIG * lower >= 0.05, "§3b: JG's magnitude × uptime is %.4f, under the floor" % (JG_FIG * lower))
	ok(not (load("res://scripts/battle.gd") as Script).get_script_constant_map().has("COMMUNION" + "_STRIKE"), "§3b: the code constant is back, where the re-key put the figure in the payload")
	# THE RELATION THE FLOOR DOES NOT REPLACE: A CONDITIONED RUNE PAYS BEYOND THE BARE WRITER OF ITS EFFECT.
	var bare := 0.0
	for n in Talents.tree():
		var st: Dictionary = ((n as Dictionary).get("payload", {}) as Dictionary).get("stat", {})
		bare = maxf(bare, float(st.get("dmg_bonus", 0.0)))
	ok(bare > 0.0 and JG_FIG > bare and _strike() > bare, "§3b: a figure, %.2f or %.2f, is not beyond the tree's bare %.2f" % [JG_FIG, _strike(), bare])
	# THE CORE: THE SMALLEST QUOTIENT PAST THE BARE FIGURE ON THE TWO ROWS, WHICH IS THE ONE MOST HELD ON ITS LOWER ROW.
	var lowers := {}
	for r in rows:
		if String(r["kind"]) == "core" and String(r["scope"]) == "runs that finish":
			var c := String(r["condition"])
			if not lowers.has(c):
				lowers[c] = minf(maxf(_share(rows, String(ROWS[0][0]), String(ROWS[0][1]), c), 0.0), maxf(_share(rows, String(ROWS[1][0]), String(ROWS[1][1]), c), 0.0))
	var best := ""
	for c2 in lowers:
		if float(lowers[c2]) > 0.0 and 0.05 / float(lowers[c2]) > bare and (best == "" or float(lowers[c2]) > float(lowers[best])):
			best = String(c2)
	ok(best == core, "§3b: the smallest quotient past the bare figure is %s's, and the rune names %s" % [best, core])
	print("    CHECKED %d cores on the two rows: %s stands first at %.4f" % [lowers.size(), best, float(lowers.get(best, 0.0))])


func _s3c_the_card() -> void:
	print("\n§3c — its card reads its constant, and every text that states the figure agrees")
	var raw: Dictionary = JSON.parse_string(_doc("res://data/runes.json"))
	var desc := String((raw.get("communion", {}) as Dictionary).get("desc", ""))
	ok(desc.contains("{=@payload.stat.dmg_bonus*100}"), "§3c: the card is cut off its own entry: %s" % desc)
	var shown := String(Runes.config("communion").get("desc", ""))
	ok(shown.replace("\n", " ").contains("%d%% more strike damage" % _pct()), "§3c: the card shows '%s', not the constant's %d%%" % [shown.replace("\n", " "), _pct()])
	var noun := String(Runes.config(Runes.engine_rune_id(JG_CORE)).get("name", "")).trim_suffix(" (core)")
	print("    [record] JG's card read *While a hero wearing the %s stands*" % noun)
	ok(shown.replace("\n", " ").begins_with("While every hero who stands wears"), "§3c: the card does not name what it reads: '%s'" % shown.replace("\n", " "))
	for line in shown.split("\n"):
		ok(String(line).length() <= 44, "§3c: a line of the card is %d characters: %s" % [String(line).length(), line])
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("while every hero who stands wears two or more core runes, every hero deals %d%% more strike damage" % _pct()), "§3c: master.html's Communion does not state the payload's %d%%" % _pct())
	ok(master.contains("<i>Communion</i>'s %d%%" % _pct()), "§3c: master.html's relation does not state the constant's %d%%" % _pct())
	var rules := _flat(_block(_doc("res://CLAUDE.md"), CREST_HEAD))
	ok(rules.contains("Communion %d%%" % _pct()), "§3c: the crest block's figure is not the constant's %d%%" % _pct())
	var whole := _doc("res://docs/state.md")
	var state := _flat(_block(whole, "### THE CREST POOL"))
	ok(state.contains("Communion at %d%%" % _pct()), "§3c: the crest block of docs/state.md is not the payload's %d%%" % _pct())
	var card := "every hero deals %d%% more strike damage" % _pct()
	ok(_flat(_block(whole, "## WHERE THE PROJECT IS")).contains(card), "§3c: the WHERE block is not the constant's %d%%" % _pct())
	var jg_card := "every hero deals %d%% more strike damage" % int(round(JG_FIG * 100.0))
	ok(_flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JG's RULINGS OWED~~")).contains(jg_card), "§3c: JG's rulings, archived, do not state JG's %d%%" % int(round(JG_FIG * 100.0)))
	ok(_flat(_block(whole, "### TO WATCH IN PLAY")).contains("COMMUNION AT %d%%" % _pct()), "§3c: TO WATCH IN PLAY is not the constant's %d%%" % _pct())


func _s3d_the_fight() -> void:
	print("\n§3d — a real fight: it pays with every hero standing, and through its holder's fall and rise")
	# RETIRED ONTO THE RE-KEY: the drive moved with the rune. JG's party of one named core is the record, read once more —
	# worn by a party whose heroes each wear one core, the re-keyed rune pays nothing — and `check_jh` §1f drives the live one.
	var rec: Node = await _fight(WORN, true)
	print("    [record] JG's party, each hero one core and the Cleric Conviction: paying %s" % str(_paying(rec)))
	ok(not _paying(rec), "§3d: worn by heroes wearing one core each, the rune pays: it reads a named core again")
	ok(FileAccess.get_file_as_string("res://check_jh.gd").contains("func _s1f_the_fight"), "§3d: no gate drives the re-keyed rune through a real fall and rise")
	ok(String(rec._condition_words(_cond())).contains("every hero who stands wears"), "§3d: the chip's words are not the re-keyed condition's: %s" % rec._condition_words(_cond()))


func _s3e_the_writers() -> void:
	print("\n§3e — what writes its condition, and the absence inside a fight")
	# THE CORE IS ONE A HERO CAN WEAR: A RUNE CARRIES IT, A CLASS HOLDS IT, AND THE TWO RETIRED-IN-WAITING ARE NOT NAMED.
	var core := JG_CORE
	var rid := Runes.engine_rune_id(core)
	ok(rid != "", "§3e: no rune carries `%s`, so nothing can write this condition" % core)
	ok(Runes.is_engine_rune(rid) and not Runes.is_retired(rid), "§3e: `%s` is no live core rune" % rid)
	ok(not RETIRED_RULE_ENGINES.has(core), "§3e: the rune names a core ruled into an ordinary rune")
	# THE MAP's DOOR WRITES IT, AND THE NEXT SPAWN READS IT: THE WRITER, DRIVEN.
	_new_run(WORN)
	var cleric: Dictionary = _run.party[CLERIC_SEAT]
	var rows: Array = _run.engine_rows(cleric)
	var at := -1
	for i in rows.size():
		if String((rows[i]["rune"] as Dictionary).get("engine", "")) == core:
			at = i
	ok(at >= 0, "§3e: the panel lists no row for the core")
	# RE-POINTED TO THE RE-KEY: one core each at class selection, a second each through the run's own door, one unslotted at the panel's.
	ok(not Talents.party_condition_met(_cond(), _run.party), "§3e: one core each at class selection, and the condition holds")
	for m in _run.party:
		for pid in Classes.class_engines(String((m as Dictionary)["key"])):
			if not Runes.held_engines(m as Dictionary).has(String(pid)) and not Classes.dismisses_pet([String(pid)]):
				var r := Runes.build(Runes.engine_rune_id(String(pid)))
				r["equipped"] = true
				_run.hold_rune(m, r)
				break
	ok(Talents.party_condition_met(_cond(), _run.party), "§3e: a second core slotted on each through the run's door, and the condition does not hold")
	rows = _run.engine_rows(cleric)
	at = -1
	for i2 in rows.size():
		if String((rows[i2]["rune"] as Dictionary).get("engine", "")) == core:
			at = i2
	ok(at >= 0 and bool(_run.toggle_engine(cleric, at)), "§3e: the panel's door did not unslot the core")
	ok(not Talents.party_condition_met(_cond(), _run.party), "§3e: unslotted through the panel's door, the condition still holds")
	var off: Node = await _unslotted_fight()
	ok(not _paying(off), "§3e: unslotted on the map, the next fight still pays")
	# THE ABSENCE, BESIDE ITS ARM: INSIDE A FIGHT NOTHING WRITES A SLOT, SO A FALL AND A RISE ARE ALL THAT MOVE IT.
	var bs := Gate.strip_comments(_doc("res://scripts/battle.gd"))
	var writers: Array = []
	# THE NEEDLES ARE JOINED AT RUNTIME: written whole, one reads to `check_gw` §2's sweep as a hand-set engine.
	var dot := ".engines"
	for w in ["toggle_engine(", "swap_engine(", "hold_rune(", dot + " = ", dot + ".append(", dot + ".erase(", "[\"equipped\"] = "]:
		if bs.contains(w):
			writers.append(w)
	ok(writers.is_empty(), "§3e: the battle writes an engine's slot: %s" % str(writers))
	var state := _record("### THE CREST POOL")
	ok(state.contains("The writers of its condition are the map's"), "§3e: the crest block does not name what writes the condition")
	var rules := _flat(_block(_doc("res://CLAUDE.md"), CREST_HEAD))
	ok(rules.contains("The condition's writers are the map's: `Run.awaken`, `Run.toggle_engine` and the swaps"), "§3e: the crest block of `CLAUDE.md` does not name the writers")


# The run in hand, its slots as the panel left them, into a real fight.
func _unslotted_fight() -> Node:
	_wear_crest("communion")
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _s3f_the_draw() -> void:
	print("\n§3f — the drop's union, the Peddler and the event verb, never a hero's own pick")
	_new_run(WORN)
	var held: Array = _run.party_rune_names()
	var offered := 0
	for m in _run.party:
		if Runes.eligible_ids(m, Runes.owned_names(m, held)).has("communion"):
			offered += 1
	ok(offered == 4, "§3f: the roll offers it to %d of the four" % offered)
	# A HERO's OWN PICK OF THREE: THE ELITE's CACHE AND THE BARGAIN, ONE ROLL.
	var dealt := 0
	var rolled := 0
	for _i in 400:
		for m2 in _run.party:
			for c in _run.roll_rune_candidates(m2):
				rolled += 1
				if String((c as Dictionary).get("id", "")) == "communion":
					dealt += 1
	ok(rolled > 1000, "§3f: the cache rolled %d candidates, so its absence reads nothing" % rolled)
	ok(dealt == 0, "§3f: the elite's cache dealt it %d times in %d candidates" % [dealt, rolled])
	ok(_run.crest_rune_names().has("Communion"), "§3f: the cache's exclusion does not name it")
	# THE THREE ROUTES, EACH ROLLED: THE DROP'S UNION, THE PEDDLER'S ROW AND THE EVENT VERB.
	var drops := 0
	var peddled := 0
	var granted := 0
	var seen := 3000
	for _j in seen:
		if String(_run.roll_fight_drop().get("id", "")) == "communion":
			drops += 1
		if String(_run.peddler_rune(_run.party[0]).get("id", "")) == "communion":
			peddled += 1
		if String(_run.grant_rune(_run.party[0]).get("id", "")) == "communion":
			granted += 1
	ok(drops > 0, "§3f: it never dropped in %d rolls" % seen)
	ok(peddled > 0, "§3f: the Peddler never rolled it in %d rolls" % seen)
	ok(granted > 0, "§3f: the event verb never rolled it in %d rolls" % seen)
	print("    in %d candidates the cache dealt it %d times; in %d rolls the drop %d, the Peddler %d, the event verb %d" % [rolled, dealt, seen, drops, peddled, granted])
	ok(Runes.ids().has("communion") and String(_run.rune_for_label(Runes.build("communion"))) == "the crest", "§3f: an offer in one hero's name does not say it is for the crest")


func _s3g_the_field() -> void:
	print("\n§3g — the charter: a `rune_` field, and never a node's counter")
	var st: Dictionary = (Runes.config("communion").get("payload", {}) as Dictionary).get("stat", {})
	# RETIRED AT THE RE-KEY (JH §0.2, the designer's): the figure went back into the payload as `dmg_bonus`, the pool's own precedent.
	print("    [record] JG wrote a `rune_` flag, `%s`, and a code constant beside it" % ("rune_core" + "_strike"))
	ok(st.keys() == ["dmg_bonus"], "§3g: the rune writes %s, not the pool's own field" % str(st.keys()))
	ok(not Talents.LIVE_FIELDS.has("rune_core" + "_strike"), "§3g: the live door holds a flag no rune writes")
	var nodes := 0
	for n in Talents.tree():
		if ((n as Dictionary).get("payload", {}) as Dictionary).get("stat", {}).has("rune_core" + "_strike"):
			nodes += 1
	ok(nodes == 0, "§3g: a node writes the rune's field")
	var bt := Gate.strip_comments(_doc("res://scripts/battle.gd"))
	ok(bt.count("rune_core" + "_strike") == 0, "§3g: the battle reads a flag no rune writes, at %d sites" % bt.count("rune_core" + "_strike"))


func _s3h_the_name() -> void:
	print("\n§3h — the name, swept whole (BR §1)")
	var pop: Array = []
	for id in Runes.ids():
		if String(id) == "communion":
			continue
		pop.append(["rune", Runes.display_name(Runes.config(String(id)))])
		pop.append(["rune id", String(id)])
		var lane := String(Runes.config(String(id)).get("lane", ""))
		if lane != "" and not pop.has(["lane", lane]):
			pop.append(["lane", lane])
	for t in Runes.TEMPLATES:
		pop.append(["template", "Rune of %s" % String(t["noun"])])
	for ab in Classes.ability_corpus():
		pop.append(["ability", (ab as Ability).display_name])
	for n in Talents.tree():
		pop.append(["node", String((n as Dictionary).get("name", ""))])
		pop.append(["node id", String((n as Dictionary).get("id", ""))])
	var foes: Dictionary = JSON.parse_string(_doc("res://data/enemies.json"))
	for kind in foes:
		pop.append(["enemy", String((foes[kind] as Dictionary).get("unit_name", ""))])
		for fa in (foes[kind] as Dictionary).get("abilities", []):
			var fan := String((fa as Dictionary).get("display_name", ""))
			if not pop.has(["enemy ability", fan]):
				pop.append(["enemy ability", fan])
	for ge in JSON.parse_string(_doc("res://data/glossary.json")):
		pop.append(["glossary", String((ge as Dictionary).get("term", ""))])
		pop.append(["glossary id", String((ge as Dictionary).get("id", ""))])
	for item_id in _run.ITEM_INFO:
		pop.append(["item", String((_run.ITEM_INFO[item_id] as Array)[0])])
	for relic_id in Relics.POOL:
		pop.append(["relic", String((Relics.POOL[relic_id] as Dictionary).get("name", ""))])
		pop.append(["relic id", String(relic_id)])
	var statuses: Dictionary = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("STATUS_INFO", {})
	for sid in statuses:
		pop.append(["status", String((statuses[sid] as Array)[0])])
		pop.append(["status id", String(sid)])
	for pid in Classes.SPINE_INFO:
		pop.append(["spine", String(Classes.SPINE_INFO[pid]["name"])])
	for pid2 in Classes.RULE_ENGINES:
		pop.append(["rule engine", String(Classes.RULE_ENGINES[pid2]["name"])])
	for mid in _run.MODIFIERS:
		pop.append(["modifier", String((_run.MODIFIERS[mid] as Dictionary).get("name", mid))])
	for tag in Classes.TAG_ORDER:
		pop.append(["tag", String(tag)])
	for r in RESERVED:
		pop.append(["designed", String(r)])
	var kinds := {}
	var hits: Array = []
	for row in pop:
		kinds[row[0]] = true
		if String(row[1]).to_lower().contains("communion"):
			hits.append("%s:%s" % [row[0], row[1]])
	print("    CHECKED %d names in %d populations: %s" % [pop.size(), kinds.size(), str(hits)])
	ok(pop.size() >= 1300 and kinds.size() == 21, "§3h: the sweep read %d names in %d populations, not the game's" % [pop.size(), kinds.size()])
	ok(hits.is_empty(), "§3h: the name stands beside %s" % str(hits))
	var said := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JG's RULINGS OWED~~"))
	ok(said.contains("on %s names in %d populations" % [_commas(pop.size()), kinds.size()]), "§3h: the ruling does not state the sweep's own size (%d in %d)" % [pop.size(), kinds.size()])
	# ITS FIELD MAY NOT CROSS THE WORD: `communion_ranks` IS THE DEVOUT's AND `wild_communion_step` THE BEASTMASTER's, AND THE TWO HAVE BEEN CROSSED ONCE.
	var f := "var rune_" + "communion"
	ok(not _doc("res://scripts/unit.gd").contains(f + " ") and not _doc("res://scripts/unit.gd").contains(f + "_"), "§3h: a `rune_` field carries the word, and reads as the twin of a dormant node's counter")


func _commas(n: int) -> String:
	var t := str(n)
	return t if t.length() <= 3 else "%s,%s" % [t.substr(0, t.length() - 3), t.substr(t.length() - 3)]


func _s3i_the_price() -> void:
	print("\n§3i — the price, against a true none, both pairings, off its tables")
	var rows := _tsv("res://docs/reports/JG-crest.tsv", ["population", "rung", "none", "runs", "none_crest_at_the_end", "arm_paid", "falls_none", "falls_arm", "finished_none", "finished_arm", "paired_falls", "paired_depth", "z_depth", "paired_finished", "fidelity"])
	ok(rows.size() == 8, "§3i: the table holds %d rows, not four cells on two pairings" % rows.size())
	var seen := {}
	var state := _record("### THE CREST POOL")
	var found := _record("### FOUND AT JG AND NOT FIXED")
	var past_two := 0
	for r in rows:
		seen[String(r["population"])] = true
		ok(int(r["runs"]) >= 60, "§3i: %s reads %s runs" % [r["population"], r["runs"]])
		ok(String(r["none_crest_at_the_end"]).begins_with("0 of"), "§3i: %s's none wore a crest rune (%s)" % [r["population"], r["none_crest_at_the_end"]])
		ok(String(r["fidelity"]).length() > 40, "§3i: %s carries no fidelity" % r["population"])
		if String(r["none"]) == "HEAD's":
			ok(state.contains(String(r["paired_depth"])), "§3i: the crest block does not carry %s rung %s's depth (%s)" % [r["population"], r["rung"], r["paired_depth"]])
			ok(state.contains(String(r["paired_falls"])), "§3i: the crest block does not carry %s rung %s's falls (%s)" % [r["population"], r["rung"], r["paired_falls"]])
			for col in ["paired_falls", "paired_depth", "paired_finished"]:
				var f := String(r[col]).split(" ± ")
				if f.size() == 2 and float(f[1]) > 0.0 and absf(float(f[0])) > 2.0 * float(f[1]):
					past_two += 1
		ok(state.contains("%.1f" % (float(r["arm_paid"]) * 100.0)), "§3i: the crest block does not carry what it paid on %s rung %s" % [r["population"], r["rung"]])
	ok(seen.has("the reference four") and seen.has("the incumbent"), "§3i: both populations are not read: %s" % str(seen.keys()))
	ok(past_two == 0 and state.contains("none of twelve readings of falls, depth and finishes passes two errors"), "§3i: %d readings pass two errors on the pairing with one union, and the block says none" % past_two)
	# THE ONE READING THE BRIEF's PAIRING PASSED, AND THE SHIFT IT IS.
	for r2 in rows:
		if String(r2["none"]) == "this tree's" and String(r2["rung"]) == "2" and String(r2["population"]) == "the reference four":
			ok(state.contains(String(r2["paired_falls"])) and found.contains(String(r2["paired_falls"])), "§3i: the brief's pairing's reading is not stated (%s)" % r2["paired_falls"])
	var noise := _tsv("res://docs/reports/JG-noise.tsv", ["population", "rung", "paired_falls", "paired_depth", "fidelity"])
	ok(noise.size() == 4, "§3i: the die shift's table holds %d rows" % noise.size())
	for r3 in noise:
		if String(r3["population"]) == "the reference four" and String(r3["rung"]) == "2":
			ok(found.contains(String(r3["paired_falls"])) and state.contains(String(r3["paired_falls"])), "§3i: the die shift is not stated (%s)" % r3["paired_falls"])
	# WHAT THE RUNE DOES INSIDE A FIGHT: THE FIRST FIGHT IS THE ONE ENCOUNTER BOTH SIDES PLAY, AND THE PAY SHOWS THERE (the fresh reader's).
	var fight := _tsv("res://docs/reports/JG-fight.tsv", ["population", "rung", "same_first_node", "paired_hturns", "hturns_change", "paired_dealt", "dealt_change", "fidelity"])
	ok(fight.size() == 4, "§3i: the fight's table holds %d rows" % fight.size())
	var lo := 100.0
	var hi := -100.0
	var dlo := 100.0
	var dhi := -100.0
	for r5 in fight:
		if String(r5["population"]) != "the reference four":
			continue
		var ph := String(r5["paired_hturns"]).split(" ± ")
		var pd := String(r5["paired_dealt"]).split(" ± ")
		ok(String(r5["same_first_node"]) == "60 of 60", "§3i: rung %s's first fight is not one node on both sides (%s)" % [r5["rung"], r5["same_first_node"]])
		ok(ph.size() == 2 and float(ph[0]) < -4.0 * float(ph[1]), "§3i: rung %s's first fight is not shorter past four errors (%s)" % [r5["rung"], r5["paired_hturns"]])
		ok(pd.size() == 2 and float(pd[0]) > 4.0 * float(pd[1]), "§3i: rung %s's damage a hero turn does not rise past four errors (%s)" % [r5["rung"], r5["paired_dealt"]])
		var hc := -float(String(r5["hturns_change"]).trim_suffix("%"))
		var dc := float(String(r5["dealt_change"]).trim_suffix("%"))
		lo = minf(lo, hc)
		hi = maxf(hi, hc)
		dlo = minf(dlo, dc)
		dhi = maxf(dhi, dc)
	var said := "%d to %d%% sooner and deal %d to %d%% more a hero turn" % [floori(lo), roundi(hi), roundi(dlo), roundi(dhi)]
	ok(state.contains(said), "§3i: the crest block does not say what the fight shows: %s" % said)
	# THE AMBUSHED ARM, AND THE GRADE IT LEAVES WHERE IT WAS.
	var amb := _tsv("res://docs/reports/JG-ambushed.tsv", ["arm", "population", "cost", "se", "fidelity"])
	ok(amb.size() == 4, "§3i: the Ambushed table holds %d rows" % amb.size())
	var high := 0.0
	for r4 in amb:
		if String(r4["arm"]).begins_with("JG"):
			high = maxf(high, float(r4["cost"]))
			ok(state.contains("+%.2f ± %.2f" % [float(r4["cost"]), float(r4["se"])]), "§3i: the crest block does not state Ambushed's reading on %s" % r4["population"])
	ok(int((_run.MODIFIERS.get("ambushed", {}) as Dictionary).get("severity", -1)) == 4 and high >= 6.88 and high < 12.22, "§3i: Ambushed reads %.2f, out of its grade's band" % high)


# ── §5 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s5_not_done() -> void:
	print("\n§5 — what is deliberately not done")
	var ruled := {"tithe": ["rune_blood_communion", 30.0], "dirge": ["dmg_bonus", 0.45], "dead_air": ["dmg_bonus", 0.75], "empty_pulpit": ["dmg_taken_bonus", -0.5]}
	for id in ruled:
		var st: Dictionary = (Runes.config(id).get("payload", {}) as Dictionary).get("stat", {})
		ok(is_equal_approx(float(st.get(String(ruled[id][0]), 0.0)), float(ruled[id][1])), "§5: %s's figure moved: %s" % [id, str(st)])
		var now: Dictionary = (Runes.config(id).get("payload", {}) as Dictionary).get("condition", {})
		ok(now == FOUR_LIVE[id], "§5: %s's condition moved: %s" % [id, str(now)])
	ok(Runes.is_retired("fellowship"), "§5: Fellowship came back")
	var deck: Dictionary = _run.MODIFIERS
	ok(deck.size() == DECK_CLOSED_AT, "§5: the deck holds %d, and it is closed at %d" % [deck.size(), DECK_CLOSED_AT])
	var kept := _doc("res://docs/reports/JE-crest.tsv")
	ok(kept.contains("paired by seed against the same party with no crest"), "§5: `JE-crest.tsv` was rewritten: a kept report is not")
	var live := 0
	for id2 in Runes.ids():
		if String(Runes.config(String(id2)).get("scope", "")) == "party" and not Runes.is_retired(String(id2)):
			live += 1
	ok(live >= FOUR_LIVE.size() + 1, "§5: the crest holds %d live runes" % live)


# ── §6 — THE VERIFICATION ─────────────────────────────────────────────────────

func _s6_the_verification() -> void:
	print("\n§6 — the positional tool's control, again")
	var rows := _tsv("res://docs/reports/JG-posseq.tsv", ["fixture", "what_moved", "want", "the_tool_reads", "fidelity"])
	ok(rows.size() >= 10, "§6: the control holds %d rows" % rows.size())
	var moved := 0
	var still := 0
	for r in rows:
		if String(r["want"]) == "READER":
			moved += 1
		else:
			still += 1
		ok(String(r["the_tool_reads"]) == String(r["want"]), "§6: %s: the tool reads %s, and the read wants %s" % [r["fixture"], r["the_tool_reads"], r["want"]])
	ok(moved >= 8 and still >= 2, "§6: the control reads %d moved and %d unmoved rows" % [moved, still])
	print("    CHECKED %d rows: %d moved, %d unmoved" % [rows.size(), moved, still])


# ── §7 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	print("\n§7 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§7: %s changed under this gate" % p)
