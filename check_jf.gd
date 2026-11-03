# BATCH JF — THE CUT, THE READ-OUTS, AND THE VERIFICATION PUT RIGHT.
#
#   §1   THE RULINGS, EACH IN THE FILE IT BINDS: the covariance clause (C01), the settled ties named (C02), the trace's price beside the ruling and
#        recomputed off the spiral's own counts (C03), the worth rule with its uptimes read off the table (C04), the party's-shape sentence and both boons at 8 (C05).
#   §2   THE DEFAULT: the sim's relic-less opening as a row of the divergence census, sorted (C06), and written beside the absolute scale (C07).
#   §3   THE CUT: every unit the state file gave up stands in the archive, its length and hash read there, and nowhere in the state file (C08); no stale size of the archive folder stands, each needle the kept table names (C09).
#   §4   THE CREST POOL, READ OUT: every rune of the scope with its figure off the data and whether anything reads its condition (C10, R01); every uptime with its
#        population and rung, its share its own arithmetic (C11); every dependency's quote found in the record it names, and never the brief (C12).
#   §5   THE DECK: closed at twenty-five (C14).
#   §6   THE VERIFICATION: the two rewordings and the withdrawn cut; the readers the floor; the control of the positional tool, row by row, read off its kept table: the tool lives outside the tree, so C13 regenerates the table with a broken copy.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jf.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE ONE EQUALITY HERE, AND IT IS A TRIPWIRE (the deck is closed by ruling, the same pin `check_jc`, `check_jd` and `check_je` hold).
const DECK_CLOSED_AT := 25
const LADDER_HEAD := "## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"
const FALL_HEAD := "## STANDING RULE — A FALL STAYS INSIDE ITS FIGHT"
const CREST_HEAD := "## STANDING RULE — THE PARTY SCOPE, AND THE RUNES IT HOLDS"
const POOLED := "ARE POOLED — INVERSE-VARIANCE — NOT CHOSEN BETWEEN"
const WORTH := "A CONDITIONAL EFFECT IS WORTH ITS MAGNITUDE TIMES ITS UPTIME, AND THE UPTIME IS READ ON THE POPULATION THAT FINISHES RUNS"
const SETTLED := "THE GRADES WHOSE TIES WERE READ THE OLD WAY ARE AMBUSHED, POROUS, FLEETING, ENCUMBERED, FRACTURED, SLICK FOOTING, FEVERISH AND WARDED, ALL EIGHT ALREADY SETTLED"
# THE CONDITIONS OF THE POOL BY THE RUNE THAT READS THEM, each a `rune` of the table.
const CONDS := ["dirge", "dead_air", "empty_pulpit", "tithe", "fellowship"]
const NUMBERS := ["nothing", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

var _g := Gate.new()
var _docs := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JF — THE CUT, THE READ-OUTS, AND THE VERIFICATION PUT RIGHT")
	_s1_the_rulings()
	_s2_the_default()
	_s3_the_cut()
	_s4a_the_pool()
	_s4b_the_uptimes()
	_s4c_the_dependencies()
	_s5_the_deck()
	_s6_the_verification()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ───────────────────────────────────────────────────────────────────

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


func _pct(of: String) -> int:
	var f := of.split(" of ")
	return int(round(100.0 * float(f[0]) / float(f[1])))


# ── §1 — THE RULINGS ──────────────────────────────────────────────────────────

func _s1_the_rulings() -> void:
	print("\n§1 — the rulings, each in the file it binds")
	var rules := _doc("res://CLAUDE.md")
	var ladder := _flat(_block(rules, LADDER_HEAD))
	var pool := ladder.find(POOLED)
	var clause := ladder.find("ITS ERROR TAKES THE COVARIANCE WHERE THE ARMS SHARE SEEDS")
	ok(pool >= 0, "§1a: the pooling rule is not in the ladder block")
	ok(clause > pool and clause - pool < 900, "§1a: the covariance clause does not stand in the pooling rule (%d, %d)" % [pool, clause])
	ok(ladder.contains("that clause is correctness, so it is a batch's to write and the designer's to be told of"), "§1a: the clause is still written as the batch's reading, waiting on a ruling")
	var tie := ladder.find("WHERE SUCH A TIE DECIDES A GRADE, THE COVARIANCE IS COMPUTED BEFORE THE GRADE IS WRITTEN")
	ok(tie > pool and tie - pool < 1400, "§1a: the standing correction does not stand where the pooling rule stands (%d, %d)" % [pool, tie])
	ok(ladder.contains(SETTLED), "§1b: the settled ties are not named in one line")
	# EACH NAME A GRADE THE DECK STILL HOLDS, AT THE GRADE THE SENTENCE CALLS SETTLED: a re-grade owes this line a re-read.
	var deck: Dictionary = root.get_node("/root/Run").MODIFIERS
	for spec in [["ambushed", 4], ["porous", 2], ["fleeting", 2], ["encumbered", 1], ["fractured", 1], ["slick", 1], ["feverish", 2], ["warded", 2]]:
		ok(int((deck.get(spec[0], {}) as Dictionary).get("severity", -1)) == int(spec[1]), "§1b: %s no longer stands at %d, and the line calls it settled" % [spec[0], int(spec[1])])
	var source := _doc("res://scripts/run_state.gd")
	ok(source.contains("TWO READINGS OF ONE POPULATION ON ONE SEED BLOCK ARE NAMED AS CORRELATED"), "§1a: the comment above `Run.MODIFIERS`, the rule's second home, does not carry the correction")
	# THE PRICE, IN THE RULING's OWN BLOCK, EACH FIGURE ITS OWN ARITHMETIC OFF THE SPIRAL's COUNTS: 0 / 45 / 15, the old rule's and the standing one's.
	var fall := _flat(_block(rules, FALL_HEAD))
	var spiral := _tsv("res://docs/reports/JE-spiral.tsv", ["figure", "population", "jc_rule", "je_rule"])
	var again := {}
	for r in spiral:
		if String(r["figure"]) == "the same hero falling again" and String(r["gap"]) == "0 / 45 / 15":
			again[String(r["population"])] = r
	ok(again.has("the reference four, Warden") and again.has("the reference four, Ruin"), "§1c: the spiral's table lost the three-relic rows the price reads")
	if again.has("the reference four, Warden") and again.has("the reference four, Ruin"):
		var w_new := _pct(String(again["the reference four, Warden"]["je_rule"]))
		var w_old := _pct(String(again["the reference four, Warden"]["jc_rule"]))
		var r_new := _pct(String(again["the reference four, Ruin"]["je_rule"]))
		var r_old := _pct(String(again["the reference four, Ruin"]["jc_rule"]))
		print("    the price off the counts: %d%% against %d%% at Warden, %d%% against %d%% at Ruin" % [w_new, w_old, r_new, r_old])
		var want := "%d%% AGAINST %d%% AT WARDEN AND %d%% AGAINST %d%% AT RUIN" % [w_new, w_old, r_new, r_old]
		ok(fall.contains(want), "§1c: the ruling's block does not carry the trace's price (%s)" % want)
	ok(fall.contains("A HERO BEHIND BY THE BASE IS A LIKELIER NEXT FALL"), "§1c: the block does not say what the price is")
	# THE WORTH RULE, WHERE CREST RUNES ARE PRICED, ITS UPTIMES OFF THE TABLE: a sentence that loses them, or keeps a figure the table left, reds.
	var crest := _flat(_block(rules, CREST_HEAD))
	ok(crest.contains(WORTH), "§1d: the worth rule is not where crest runes are priced")
	var at := crest.find(WORTH)
	var worth := crest.substr(at, 1800) if at >= 0 else ""
	for spec in _worth_cells():
		ok(worth.contains(String(spec[1])), "§1d: the worth rule does not state %s (%s)" % [spec[0], spec[1]])
	# THE ARITHMETIC THE RULE IS NAMED FOR, ITS MAGNITUDE OFF THE DATA AND ITS UPTIME OFF THE TABLE: a re-tune reds this line, and the words follow.
	var figure := int(round(float(Runes.config("dirge")["payload"]["stat"]["dmg_bonus"]) * 100.0))
	var uptime := String(_worth_cells()[0][1]).trim_prefix("Dirge ")
	ok(worth.contains("Dirge at %d%% over %s of turns" % [figure, uptime]), "§1d: the rule's worked sentence does not state the figure the data holds (%d%%) over the table's uptime (%s)" % [figure, uptime])
	var worth_pct: float = float(figure) * uptime.trim_suffix("%").to_float() / 100.0
	var tenths := "about %s-tenths of a percent" % NUMBERS[int(round(worth_pct * 10.0))]
	print("    Dirge at %d%% over %s is worth %.2f%%: %s" % [figure, uptime, worth_pct, tenths])
	ok(worth.contains(tenths), "§1d: the rule does not state the product (%s)" % tenths)
	var watch := _flat(_block(_doc("res://docs/state.md"), "### TO WATCH IN PLAY"))
	ok(watch.contains("THEIR UPTIMES"), "§1d: the three do not stand on TO WATCH IN PLAY with their uptimes")
	for spec in _worth_cells():
		ok(watch.contains(String(spec[1])), "§1d: TO WATCH IN PLAY does not carry %s" % spec[1])
	ok(fall.contains("A REQUIREMENT ABOUT THE PARTY's SHAPE IS KNOWN WHEN THE PLAYER PICKS, AND THE PLAYER CHOSE INTO IT"), "§1e: the party's-shape sentence is not beside the rule")
	ok(fall.contains("A REQUIREMENT ABOUT WHAT JUST HAPPENED IS NOT CHOSEN AND FIRES RARELY, AND THAT IS THE ONE *DO NOT GATE TWICE* IS FOR"), "§1e: the rule's half is not beside it")
	for id in ["old_trapper", "arcane_obelisk"]:
		ok(int(Events.config(id).get("weight", 0)) == 8, "§1e: %s's weight moved to %d, and a requirement the player chose keeps it" % [id, int(Events.config(id).get("weight", 0))])
		ok((Events.config(id).get("requires", {}) as Dictionary).has("spec_in_party"), "§1e: %s no longer asks the party's shape, so the row reads another event" % id)
	ok(int(Events.config("fallen_cairn").get("weight", 0)) == 12, "§1e: the Cairn's weight moved")


# THE SIX UPTIMES THE RULE STATES, THE TABLE's RUNS THAT FINISH WITH NO CREST WORN: [where, the text as it prints it].
func _worth_cells() -> Array:
	var out: Array = []
	var rows := _tsv("res://docs/reports/JF-uptimes.tsv", ["population", "rung", "arm", "scope", "rune", "share"])
	for cell in [["the reference four", "1"], ["the incumbent", "3"]]:
		for rune in [["dirge", "Dirge"], ["dead_air", "Dead Air"], ["empty_pulpit", "Empty Pulpit"]]:
			var hit := ""
			for r in rows:
				if String(r["population"]) == String(cell[0]) and String(r["rung"]) == String(cell[1]) and String(r["arm"]) == "no crest worn" and String(r["scope"]) == "runs that finish" and String(r["rune"]) == String(rune[0]):
					hit = "%s %.1f%%" % [rune[1], float(r["share"]) * 100.0]
			ok(hit != "", "§1d: the table has no row for %s on %s at rung %s" % [rune[0], cell[0], cell[1]])
			out.append(["%s, rung %s" % [cell[0], cell[1]], hit])
	return out


# ── §2 — THE DEFAULT ──────────────────────────────────────────────────────────

func _s2_the_default() -> void:
	print("\n§2 — the relic default: a row of the census, and beside the scale")
	var rows := _tsv("res://docs/reports/IU-bot-divergence.tsv", ["id", "act", "bot_path", "sort", "reason", "evidence"])
	var hit := {}
	for r in rows:
		if String(r["act"]).contains("relic") and String(r["reason"]).contains("DOD_SIM_RELICS"):
			hit = r
	ok(not hit.is_empty(), "§2a: the divergence census holds no row for the sim's relic default")
	if not hit.is_empty():
		ok(String(hit["sort"]) == "POLICY", "§2a: the relic default is sorted %s: a legal draft the bot chooses is a POLICY, and a RULE is a defect owed" % hit["sort"])
		ok(String(hit["evidence"]).contains("the grades stand") and String(hit["evidence"]).contains("the absolute scale"), "§2a: the row does not say what rests on the default")
		print("    %s: %s" % [hit["id"], hit["sort"]])
	var worn := {}
	for r in rows:
		if String(r["act"]).contains("crest rune") and String(r["bot_path"]).contains("_sim_take_drop"):
			worn = r
	ok(not worn.is_empty(), "§2a: the divergence census holds no row for the bot wearing the crest rune it draws")
	if not worn.is_empty():
		ok(String(worn["sort"]) == "POLICY", "§2a: the crest default is sorted %s" % worn["sort"])
	var src := _doc("res://scripts/run_sim.gd")
	ok(src.contains("wear it if a hero it fits has a slot free"), "§2a: the crest default's written reason is gone from `run_sim.gd`")
	ok(src.contains("Relics (DOD_SIM_RELICS)  armed at the draft; none by default."), "§2a: the row's written reason is gone from `run_sim.gd`")
	var ladder := _flat(_block(_doc("res://CLAUDE.md"), LADDER_HEAD))
	var scale := ladder.find("A MODIFIER's SEVERITY IS WHAT IT COSTS THE REFERENCE PARTY's HEALTH")
	var said := ladder.find("A POINT IS A PERCENT OF THE HEALTH OF A PARTY THAT OPENED WITH NO RELIC, AND THAT DEFAULT IS WRITTEN BESIDE THE SCALE")
	ok(scale >= 0, "§2b: the scale's definition moved, so the default has nothing to stand beside")
	ok(said > scale and said - scale < 700, "§2b: the absolute scale stands without the default beside it (%d, %d)" % [scale, said])
	ok(ladder.contains("so a shared baseline that opens with no relic is consistent and the grades stand"), "§2b: the sentence does not say why the grades stand")
	ok(ladder.contains("a party that finds them is playing a milder deck than the one that was graded"), "§2b: the sentence does not say what rests on the default")
	ok(ladder.contains("And the bot wears the first crest rune it draws, row DV35"), "§2b: the scale's sentence is silent on the second default")
	ok(_doc("res://scripts/run_state.gd").contains("A POINT IS A PERCENT OF THE HEALTH OF A PARTY THAT OPENED WITH NO RELIC"), "§2b: the comment above `Run.MODIFIERS` states the scale without the default")


# ── §3 — THE CUT ──────────────────────────────────────────────────────────────

func _s3_the_cut() -> void:
	print("\n§3 — what the state file gave up stands in the archive, and no folder size stands typed")
	var state := _doc("res://docs/state.md")
	var arch := _doc("res://DoD-archive/state-archive.md")
	var rows := _tsv("res://docs/reports/JF-cut.tsv", ["unit", "kind", "bytes", "closed_by", "first_words", "chars", "md5"])
	ok(rows.size() >= 6, "§3a: the cut's table holds %d rows" % rows.size())
	var total := 0
	var gone: Array = []
	var kept: Array = []
	var unsaid: Array = []
	for r in rows:
		var w := String(r["first_words"])
		total += int(r["bytes"])
		# THE UNIT WHOLE, NOT ITS FIRST WORDS: its length and hash read in the archive, so a unit truncated in the move reads gone.
		var at := arch.find(w)
		if at < 0 or arch.substr(at, int(r["chars"])).md5_text() != String(r["md5"]):
			gone.append(r["unit"])
		if state.contains(w):
			kept.append(r["unit"])
		if String(r["closed_by"]).length() < 12:
			unsaid.append(r["unit"])
	print("    CHECKED %d units, %d B" % [rows.size(), total])
	ok(gone.is_empty(), "§3a: %d units were cut and the archive did not take them: %s" % [gone.size(), str(gone.slice(0, 3))])
	ok(kept.is_empty(), "§3a: %d units the table calls cut still stand in the state file: %s" % [kept.size(), str(kept.slice(0, 3))])
	ok(unsaid.is_empty(), "§3a: %d units do not say what closed them: %s" % [unsaid.size(), str(unsaid.slice(0, 3))])
	ok(arch.contains("## ARCHIVED AT JF"), "§3a: the archive has no head for this cut")
	ok(arch.find("## ARCHIVED AT JF") < arch.find("## ARCHIVED AT JE"), "§3a: the newest cut does not stand first")
	# THE FOLDER's SIZE: IT MOVES EVERY CUT, SO A TYPED FIGURE IS STALE THE BATCH AFTER IT. The census prints it; the state file points there.
	var needles := _tsv("res://docs/reports/JF-stale-sizes.tsv", ["needle", "where it stood", "reads now"])
	ok(needles.size() >= 4, "§3b: the stale sizes' table holds %d needles" % needles.size())
	for n in needles:
		ok(not state.contains(String(n["needle"])), "§3b: a stale archive-folder size stands: '%s'" % n["needle"])
	print("    CHECKED %d stale needles" % needles.size())
	var sync := _flat(_block(state, "### Knowledge sync, re-measured at EG"))
	ok(sync.contains("python3 claude_md_census.py"), "§3b: the sync's block does not point at what prints the size")
	ok(_doc("res://claude_md_census.py").contains("print(\"DoD-archive/: %d files, %d B\""), "§3b: the census no longer prints the folder, and the state file says it does")


# ── §4 — THE CREST POOL ───────────────────────────────────────────────────────

func _s4a_the_pool() -> void:
	print("\n§4a — every rune of the scope: its figure off the data, and whether anything reads its condition")
	var rows := _tsv("res://docs/reports/JF-pool.tsv", ["rune", "status", "words", "figure", "condition", "condition_read_at", "anything_reads_it", "writer", "fidelity"])
	var named := {}
	for r in rows:
		named[String(r["rune"])] = r
	var scope: Array = []
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) == "party":
			scope.append(id)
	print("    the scope holds %s" % str(scope))
	ok(scope.size() >= 5, "§4a: the party scope holds %d entries" % scope.size())
	for id in scope:
		# BATCH JG §3 — THE TABLE IS A KEPT READ-OUT OF THE FIVE THE POOL HELD AT JF, AND A KEPT REPORT IS NOT REWRITTEN: `check_jg` §3 holds Communion.
		if id == "communion":
			continue
		ok(named.has(id), "§4a: %s has no row in the pool's table" % id)
		if not named.has(id):
			continue
		var r: Dictionary = named[id]
		var stat: Dictionary = Runes.config(id).get("payload", {}).get("stat", {})
		var fig := absf(float(stat.values()[0]))
		var text: String = "%d%%" % int(round(fig * 100.0 if fig < 2.0 and not stat.has("rune_blood_communion") else fig))
		if stat.has("rune_field_medic"):
			text = "%d a turn" % int(fig)
		ok(String(r["figure"]) == text, "§4a: %s's row states %s and the data holds %s" % [id, r["figure"], text])
		# THE CARD's OWN WORDS READ THE FIGURE THROUGH THE DOOR: a re-tune moves the card and reds the kept table above.
		if not Runes.is_retired(id):
			ok(String(Runes.config(id).get("desc", "")).contains(text), "§4a: %s's card does not state the figure its data holds (%s)" % [id, text])
		ok(String(r["anything_reads_it"]) in ["yes", "no"], "§4a: %s's row does not say whether anything reads its condition: '%s'" % [id, r["anything_reads_it"]])
		ok(String(r["condition_read_at"]).length() > 8, "§4a: %s's row names no read site" % id)
		ok(String(r["status"]) == ("retired" if Runes.is_retired(id) else "live"), "§4a: %s's row says %s" % [id, r["status"]])
	# WHETHER ANYTHING READS IT, ASKED OF THE DOOR: a condition that holds of the wrong party, or of none, is a row that lies. Tithe has no condition; its read is the strike's.
	var party := [{"key": "warrior", "hp": 9}, {"key": "mage", "hp": 9}, {"key": "cleric", "hp": 9}, {"key": "hunter", "hp": 9}]
	var drive := {"dirge": 1, "dead_air": 1, "empty_pulpit": 2}
	for id in drive:
		var cond: Dictionary = Runes.config(id)["payload"]["condition"]
		var met := Talents.party_condition_met(cond, party)
		var down: Array = party.duplicate(true)
		(down[int(drive[id])] as Dictionary)["hp"] = 0
		ok(not met, "§4a: DRIVEN — %s holds with all four standing" % id)
		ok(Talents.party_condition_met(cond, down), "§4a: DRIVEN — %s does not hold with its hero down" % id)
	# THE TWO SENTENCES OF `docs/master.html` THAT STATE A CREST FIGURE, READ AGAINST THE DATA: no other gate reads them, and a re-tune must red here.
	var master := _flat(_doc("res://docs/master.html"))
	var dirge := int(round(float(Runes.config("dirge")["payload"]["stat"]["dmg_bonus"]) * 100.0))
	var dead := int(round(float(Runes.config("dead_air")["payload"]["stat"]["dmg_bonus"]) * 100.0))
	ok(master.contains("while a hero lies fallen, the rest deal %d%% more strike damage" % dirge), "§4a: master.html's Dirge does not state the figure the data holds (%d%%)" % dirge)
	ok(master.contains("<i>Dead Air</i>'s %d%% and <i>Dirge</i>'s %d%% more strike damage" % [dead, dirge]), "§4a: master.html's second statement of the two does not state the data's (%d%%, %d%%)" % [dead, dirge])
	var bt := _doc("res://scripts/battle.gd")
	ok(bt.contains("var bc_pct: int = attacker.blood_communion + attacker.rune_blood_communion"), "§4a: Tithe's read site moved")
	ok(bt.contains("if bc_pct > 0 and bc_bd > 0:"), "§4a: Tithe no longer reads the Break that landed")
	ok(bt.contains("if u.is_hero and not u.dead and u.rune_field_medic + u.field_medic > 0:"), "§4a: Fellowship's kept read site is gone")
	ok(Runes.is_retired("fellowship"), "§4a: Fellowship came back")
	ok(int(root.get_node("/root/Run").PARTY_RUNE_SLOTS) == 1, "§4a: the crest's cap moved")
	var draw := _tsv("res://docs/reports/JF-draw.tsv", ["route", "door", "a_crest_rune_arrives", "what_competes", "fidelity"])
	ok(draw.size() >= 5, "§4a: the routes' table holds %d rows" % draw.size())
	for r in draw:
		ok(String(r["a_crest_rune_arrives"]) in ["yes", "no", "not a route"] and String(r["what_competes"]).length() > 5, "§4a: the route '%s' does not say whether a crest rune arrives or what competes" % r["route"])


func _s4b_the_uptimes() -> void:
	print("\n§4b — every uptime with its population and its rung, its share its own arithmetic")
	var rows := _tsv("res://docs/reports/JF-uptimes.tsv", ["population", "rung", "arm", "scope", "runs", "finished", "hero_turns", "rune", "condition", "turns_held", "share", "crest_at_the_end", "fidelity"])
	ok(rows.size() >= 40, "§4b: the table holds %d rows" % rows.size())
	var worn := 0
	var bare: Array = []
	var wrong: Array = []
	var seen := {}
	for r in rows:
		if String(r["population"]).strip_edges() == "" or String(r["rung"]).strip_edges() == "" or String(r["fidelity"]).length() < 40:
			bare.append(r["rune"])
		# THE RULE's PREMISE: every figure it quotes reads a party that wore no crest rune at any run's end.
		if String(r["arm"]) == "no crest worn" and not String(r["crest_at_the_end"]).begins_with("0 of"):
			worn += 1
		var ht := int(r["hero_turns"])
		if ht > 0 and absf(float(r["share"]) - float(r["turns_held"]) / ht) > 0.00006:
			wrong.append("%s %s %s" % [r["population"], r["rung"], r["rune"]])
		seen["%s|%s|%s" % [r["population"], r["rung"], r["rune"]]] = true
	ok(bare.is_empty(), "§4b: %d uptimes carry no population, rung or fidelity: %s" % [bare.size(), str(bare.slice(0, 4))])
	ok(wrong.is_empty(), "§4b: %d shares are not their own arithmetic: %s" % [wrong.size(), str(wrong.slice(0, 3))])
	ok(worn == 0, "§4b: %d rows of the no-crest arm ended a run wearing one" % worn)
	for pop in ["the reference four", "the incumbent"]:
		for rung in ["1", "2", "3"]:
			for rune in CONDS:
				ok(seen.has("%s|%s|%s" % [pop, rung, rune]), "§4b: no uptime for %s on %s at rung %s" % [rune, pop, rung])


func _s4c_the_dependencies() -> void:
	print("\n§4c — every dependency read off the record it names")
	var rows := _tsv("res://docs/reports/JF-deps.tsv", ["thing", "kind", "record", "record_block", "quote", "what_it_is", "what_it_needs_the_ruling_to_say", "what_it_cannot_be_decided_without"])
	ok(rows.size() >= 5, "§4c: the table holds %d rows" % rows.size())
	var unfound: Array = []
	var briefed: Array = []
	var blank: Array = []
	var kinds := {}
	for r in rows:
		var rec := String(r["record"])
		if rec.contains("BATCH_") or rec.contains("brief"):
			briefed.append(r["thing"])
			continue
		var text := _flat(_doc("res://" + rec))
		var block := String(r["record_block"])
		# THE QUOTE IN THE BLOCK THE ROW NAMES, WHERE THE RECORD HAS HEADINGS THE ROW CAN NAME.
		if block.begins_with("#") and rec.ends_with(".md") and rec != "docs/reports/JE.md":
			text = _flat(_block(_doc("res://" + rec), block))
		if text == "" or not text.contains(String(r["quote"])):
			unfound.append(r["thing"])
		for c in ["what_it_is", "what_it_needs_the_ruling_to_say", "what_it_cannot_be_decided_without"]:
			if String(r[c]).length() < 7:
				blank.append(r["thing"])
		kinds[String(r["kind"])] = int(kinds.get(String(r["kind"]), 0)) + 1
	ok(briefed.is_empty(), "§4c: %d rows are asserted from a brief, not a record: %s" % [briefed.size(), str(briefed)])
	ok(unfound.is_empty(), "§4c: %d rows' quotes stand in no record they name: %s" % [unfound.size(), str(unfound.slice(0, 3))])
	ok(blank.is_empty(), "§4c: %d rows leave a question empty: %s" % [blank.size(), str(blank.slice(0, 3))])
	var said := "%d rows, %d waiting on the ruling, %d play questions it would reopen and %d that bound it" % [rows.size(), int(kinds.get("waits on the ruling", 0)), int(kinds.get("a play question it would reopen", 0)), int(kinds.get("a bound on the ruling", 0))]
	print("    CHECKED %d rows: %s" % [rows.size(), said])
	ok(_flat(_block(_doc("res://docs/state.md"), "### THE CREST POOL")).contains(said), "§4c: the state's sentence does not carry the count (%s)" % said)
	# THE CREST ARMS THE STATE QUOTES, OFF THE TABLE THEY CAME FROM.
	var crest := _tsv("res://docs/reports/JF-crest.tsv", ["arm", "rung", "paired_depth", "paired_finished", "fidelity"])
	var pool := _flat(_block(_doc("res://docs/state.md"), "### THE CREST POOL"))
	for r in crest:
		if String(r["rung"]) == "2" and String(r["arm"]) != "the bot's default":
			ok(pool.contains(String(r["paired_depth"])), "§4c: the crest block does not carry %s's depth at Warden (%s)" % [r["arm"], r["paired_depth"]])
		if String(r["rung"]) == "2" and String(r["arm"]) == "the bot's default":
			ok(pool.contains(String(r["paired_finished"])), "§4c: the crest block does not carry the default arm's finishes (%s)" % r["paired_finished"])


# ── §5 — THE DECK ─────────────────────────────────────────────────────────────

func _s5_the_deck() -> void:
	print("\n§5 — the deck")
	var deck: Dictionary = root.get_node("/root/Run").MODIFIERS
	ok(deck.size() == DECK_CLOSED_AT, "§5: the deck holds %d, and it is closed at %d" % [deck.size(), DECK_CLOSED_AT])


# ── §6 — THE VERIFICATION ─────────────────────────────────────────────────────

func _s6_the_verification() -> void:
	print("\n§6 — the rewordings, the readers, and the positional tool's own control")
	var instr := _flat(_doc("res://docs/instrument-rules.md"))
	ok(instr.contains("A RECON IS OWED WHEN THE GAME's CODE OR DATA MOVES. A GATE's, AN INSTRUMENT's OR THE RUNNER's OWN CHANGE IS COVERED BY THE PRE-RUN THAT RUNS IT, PLUS THE STANDALONE `check_de` AND THE ACCEPTANCE"), "§6a: cut two's wording is not fixed")
	var old_recon := "RECON IS OWED FOR " + "CODE AND GATES"
	ok(not instr.contains(old_recon), "§6a: the old wording of cut two still stands")
	ok(instr.contains("THE POSITIONAL RE-RUN RE-DERIVES ALL 489 READS EVERY BATCH"), "§6a: the positional rule does not re-derive all 489")
	ok(instr.contains("JE §7's cut is withdrawn"), "§6a: the positional rule does not say the cut is withdrawn")
	var old_cut := "RUNS WHERE A READ's OWN FILE " + "CHANGED, NOT EVERY BATCH"
	ok(not instr.contains(old_cut), "§6a: the withdrawn cut still stands as a rule")
	ok(instr.contains("THE READERS ARE THE FLOOR AND THE RECON IS THE VARIABLE PART"), "§6b: the readers are not written as the floor")
	ok(instr.contains("If something must be dropped for time it is a recon, by the rule below, and never a reader"), "§6b: what is dropped for time is not said")
	ok(instr.contains("EVERY PREDICTION IS A FILE WRITTEN BEFORE ITS LAUNCH, AND A READ-OUT's TABLES ARE PREDICTED TOO"), "§6b: the prediction's floor does not reach a read-out")
	var rows := _tsv("res://docs/reports/JF-posseq.tsv", ["fixture", "what_moved", "want", "the_tool_reads", "fidelity"])
	ok(rows.size() >= 10, "§6c: the control holds %d rows" % rows.size())
	var moved := 0
	var still := 0
	for r in rows:
		if String(r["want"]) == "READER":
			moved += 1
		else:
			still += 1
		ok(String(r["the_tool_reads"]) == String(r["want"]), "§6c: %s: the tool reads %s, and the read wants %s" % [r["fixture"], r["the_tool_reads"], r["want"]])
	var je_said: Array = []
	for r in rows:
		if r.has("the_tool_as_je_left_it") and String(r["the_tool_as_je_left_it"]) != String(r["want"]):
			je_said.append(r["fixture"])
	print("    the tool as JE left it misread %s" % str(je_said))
	var back := _tsv("res://docs/reports/JF-backread.tsv", ["n", "target", "status", "slack", "note"])
	ok(back.size() >= 54, "§6c: the reads the blind tool cleared are not all read: %d of 54" % back.size())
	var off: Array = []
	for r in back:
		if not (String(r["status"]) in ["ON-SUBJECT", "TIGHT"]):
			off.append("%s %s: %s" % [r["n"], r["target"], r["status"]])
	ok(off.is_empty(), "§6c: %d of the reads the blind tool cleared do not stand on their subject: %s" % [off.size(), str(off.slice(0, 4))])
	ok(moved >= 8 and still >= 2, "§6c: the control reads %d moved and %d unmoved rows: a control with no positive arm passes on a tool that clears nothing" % [moved, still])
	print("    CHECKED %d rows: %d moved, %d unmoved" % [rows.size(), moved, still])
