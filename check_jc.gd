# BATCH JC — THE DECK CLOSED, THE QUEUE REOPENED.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: the deck closed at its size (a ruling, so this one count is an equality, the
#        tripwire's shape) and its grades read off their readings; capacity's rule standing with the no-fourth-grade rule and the scale
#        (C02); the divisor where the census's practice stands (C03); a tie named, never resolved upward, in the tie block, and Ambushed
#        still a 4 (C04); the two rules for a brief that grades (`docs/ways-of-working.md`); the standing word among the batch-conduct
#        rules and not in the ladder block (C10b); Warden's gamble pool on the watch list.
#   §1   THE RETIRED TARGET: no living document states it (C01), and the design notes keep it. The sweep prints what it read.
#   §2a  OUTPACED: the card's words, and none of the three texts that state it says the game has the unit it does not have (C05).
#   §2b  THE SEATS: the glossary's line through the glossary's door (C06), and DRIVEN from a hero's own turn, because the line is true of a
#        modifier that puts the warband first and false of an ordinary fight: a seat goes ahead of the warband with no card, behind a
#        turn Outpaced or Ambushed put ahead, and first in a span with no enemy due.
#   §2c  THE FIELD: Ambushed carries it, nothing else does (C07, on the absence); the band's draw is the deck less what the field marks,
#        read off the code and DRIVEN through the door the rung deals by (C08).
#   §3   THE BATCH-CODE ARM: the pattern `check_is` §6 holds reads every code the project has reported under and the next one (C09).
#   §4   THE FALLEN HERO, READ OUT: every door the table names is a function in its file, in every place the brief asks after (doors);
#        each of the things the ruling prices stands in the record the row names, and the rows sum to the sentence the record states
#        (C10); and every figure carries its population and its fidelity (C11). What it read out is built since, and `check_jd` holds it.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2), and the retired figure is built at run time, so
#   this gate holds no copy of what it sweeps for.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jc.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE ONE EQUALITY HERE, AND IT IS A TRIPWIRE: the deck is closed by ruling, so a card arriving or leaving is the event. If this
# reds, the ground moved: re-read the ruling in `CLAUDE.md`'s ladder block before re-pointing it.
const DECK_CLOSED_AT := 25
const LADDER_HEAD := "## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"
const CONDUCT_HEAD := "## Working agreement"
const FLAG := "opening_burst"
const PLACES := ["in the fight", "at the fight's end", "between fights", "on the map", "in the save", "in the readout", "on the screens"]

var _g := Gate.new()
var _run: Node
var _docs := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JC — THE DECK CLOSED, THE QUEUE REOPENED")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	_s1_the_retired_target()
	_s2a_outpaced()
	await _s2b_the_seats()
	_s2c_the_field()
	_s3_the_batch_code_arm()
	_s4_the_fallen_hero()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


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
	var bad := 0
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			bad += 1
			continue
		var row := {}
		for i in head.size():
			row[String(head[i])] = String(f[i])
		out.append(row)
	ok(bad == 0, "%s: %d rows do not carry every column" % [path, bad])
	return out


# ── §0 — THE RULINGS ─────────────────────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each in the file it binds")
	var cl := _doc("res://CLAUDE.md")
	var ladder := _block(cl, LADDER_HEAD)
	ok(ladder.length() > 1000, "§0: the ladder block is not where this gate looks (%d chars)" % ladder.length())
	var deck: Dictionary = _run.MODIFIERS
	ok(deck.size() == DECK_CLOSED_AT, "§0: the deck holds %d, and it is closed at %d: the ground moved, re-read the ruling" % [deck.size(), DECK_CLOSED_AT])
	ok(ladder.contains("THE DECK IS CLOSED AT TWENTY-FIVE"), "§0: the ladder block does not close the deck")
	ok(ladder.contains("A GRADE IS FOUND AFTER A MECHANIC IS BUILT"), "§0: the ladder block does not say a grade is found after a card is built")
	# C02: WHY THE HIGH GRADES ARE WHERE THEY ARE STANDS WITH WHAT IT EXPLAINS, AND THE SENTENCE IT CORRECTS STANDS NOWHERE LIVING.
	ok(ladder.contains("THE HIGH GRADES BELONG TO RULES THAT TAKE AWAY WHAT THE PARTY ABSORBS WITH"), "§0: capacity's rule does not stand in the ladder block")
	ok(ladder.contains("NO FOURTH-GRADE CARD STANDS ON THE TURN ORDER, BREAK OR A BARRIER"), "§0: the no-fourth-grade rule does not stand in the ladder block")
	ok(ladder.contains("A MODIFIER's SEVERITY IS WHAT IT COSTS THE REFERENCE PARTY's HEALTH"), "§0: the grade scale does not stand in the ladder block")
	var old := "rate tweaks top out" + " near 3"
	ok(not cl.contains(old) and not _doc("res://docs/state.md").contains(old), "§0: the sentence capacity's rule corrects stands beside it")
	# C03: THE DIVISOR, IN THE BULLET THAT HOLDS THE CENSUS's PRACTICE.
	var census_at := ladder.find("A NEW MODIFIER NAMES THE TWO SIDES' SHARES")
	var census := ladder.substr(census_at, ladder.find("\n·", census_at + 10) - census_at) if census_at >= 0 else ""
	ok(_flat(census).contains("A CENSUS PRICES THE GROSS, AND THE COST IS THE GROSS AFTER THE PARTY's HEALING"), "§0: the census's practice stands without its divisor")
	ok(_flat(census).contains("READ THE GROSS ON THE POPULATION THE CARD ACTS ON"), "§0: the census's practice does not name the population to read the gross on")
	ok(_flat(census).contains("AGAINST WHAT THAT CAPACITY ABSORBS"), "§0: the census's practice does not check a multiplier on a capacity")
	# C04: THE TIE IS NAMED, NEVER RESOLVED UPWARD, IN THE BLOCK THAT HOLDS THE TIE; AND AMBUSHED's GRADE READS OFF ITS READING.
	var rules := _doc("res://docs/instrument-rules.md")
	var tie := _block(rules, "## STANDING RULE — A CUT INSIDE TWO STANDARD ERRORS IS NOT A MEASUREMENT")
	ok(tie.length() > 500, "§0: the tie block is not where this gate looks")
	ok(_flat(tie).contains("A GRADE IS READ OFF THE READING. A TIE AT A CUT IS NAMED, NOT RESOLVED UPWARD"), "§0: the tie block does not say a tie is named, not resolved upward")
	ok(_flat(tie).contains("never below what its error bar permits"), "§0: the tie block does not settle the two rules")
	ok(int(deck["ambushed"].get("severity", 0)) == 4, "§0: Ambushed reads %s, and a tie at a cut does not move it" % str(deck["ambushed"].get("severity", 0)))
	var graded := _tsv("res://docs/reports/JB-grades.tsv", ["id", "alt_cost"])
	var reading := -1.0
	for r in graded:
		if String(r["id"]) == "ambushed":
			reading = float(r["alt_cost"])
	var cut_5 := 0.0
	for r in _tsv("res://docs/reports/IZ-scale.tsv", ["level", "cut_iz"]):
		if int(r["level"]) == 5:
			cut_5 = float(r["cut_iz"])
	ok(reading > 0.0 and cut_5 > 0.0 and reading < cut_5, "§0: Ambushed's reading %.4f and grade 5's floor %.4f do not place it under the cut" % [reading, cut_5])
	# THE TWO RULES FOR A BRIEF, WHERE A BRIEF's RULES ARE.
	var wow := _flat(_doc("res://docs/ways-of-working.md"))
	ok(wow.contains("A BRIEF THAT GRADES A MODIFIER NAMES BOTH POPULATIONS"), "§0: a brief is not told to name both populations")
	ok(wow.contains("MAY ALLOW A CURVE WHERE A CUT IS SUSPECTED"), "§0: a brief is not told it may allow a curve")
	# C10b: THE STANDING WORD IS A RULE OF THE PROJECT, NOT OF THE DECK.
	var conduct := _block(cl, CONDUCT_HEAD)
	ok(conduct.length() > 1000, "§0: the batch-conduct block is not where this gate looks")
	ok(conduct.contains("DO NOT ASK. DECIDE, AND SAY WHAT YOU DECIDED"), "§0: the standing word is not among the batch-conduct rules")
	ok(not ladder.contains("DO NOT ASK. DECIDE"), "§0: the standing word stands in the ladder block, and it governs every batch")
	ok(conduct.contains("NEEDS A RULING") and conduct.contains("Nothing waits on a reply"), "§0: the standing word lost the half that says where a designer's choice goes")
	var state := _doc("res://docs/state.md") + _doc("res://DoD-archive/state-archive.md")
	ok(state.contains("WARDEN's GAMBLE POOL"), "§0: Warden's gamble pool is on no watch list")
	print("    CHECKED the deck at %d; the three rules in one block; the divisor; the tie; Ambushed %.2f under %.2f; the two brief rules; the word" % [deck.size(), reading, cut_5])


# ── §1 — THE RETIRED TARGET ──────────────────────────────────────────────────
func _s1_the_retired_target() -> void:
	print("\n§1 — the target is retired from every living document, and kept in the record")
	var spaced := " / ".join(["5", "5", "5", "4", "4"])
	var tight := "/".join(["5", "5", "5", "4", "4"])
	var files := ["res://CLAUDE.md", "res://README.md", "res://docs/state.md", "res://docs/master.html", "res://docs/instrument-rules.md",
		"res://docs/combat-rules.md", "res://docs/ways-of-working.md", "res://docs/text-standard.html", "res://data/glossary.json"]
	for f in DirAccess.get_files_at("res://scripts"):
		if f.ends_with(".gd"):
			files.append("res://scripts/" + f)
	var stated: Array = []
	var read := 0
	for f in files:
		var s := FileAccess.get_file_as_string(f)
		if s.length() > 0:
			read += 1
		# C01
		if s.contains(spaced) or s.contains(tight):
			stated.append(f)
	ok(read == files.size() and read >= 20, "§1: the sweep read %d of %d living files" % [read, files.size()])
	ok(stated.is_empty(), "§1: %d living documents state the retired target: %s" % [stated.size(), str(stated)])
	ok(_doc("res://docs/design-notes.md").contains(spaced), "§1: the design notes do not keep the retired target, and the record says what was true when it was written")
	print("    the sweep read %d living files; %d state the target; the design notes keep it" % [read, stated.size()])


# ── §2a — OUTPACED's WORDS ───────────────────────────────────────────────────
func _s2a_outpaced() -> void:
	print("\n§2a — Outpaced says what the code keeps")
	var want := "The warband moves first. A hero only goes ahead of an enemy by being clearly faster. The Hunter's opening turn stands."
	var mods: Dictionary = _run.MODIFIERS
	ok(String(mods["outpaced"].get("desc", "")) == want, "§2a: the card reads '%s'" % mods["outpaced"].get("desc", ""))
	var master := _doc("res://docs/master.html")
	ok(master.contains("<tr><td>Outpaced</td><td>%d</td><td>%s</td></tr>" % [int(mods["outpaced"].get("severity", 0)), want]), "§2a: master.html's row is not the card's words")
	# C05: THE GAME HAS NO ROUNDS, AND THE CARD NEVER SAID OTHERWISE AGAIN.
	var unit := "every " + "round"
	var carrying: Array = []
	for p in [["res://scripts/run_state.gd", _doc("res://scripts/run_state.gd")], ["res://docs/master.html", master], ["res://data/glossary.json", _doc("res://data/glossary.json")]]:
		if String(p[1]).contains(unit):
			carrying.append(p[0])
	ok(carrying.is_empty(), "§2a: %s still say the game has rounds" % str(carrying))
	print("    the card and master.html agree; 3 texts swept")


# ── §2b — THE SEATS ──────────────────────────────────────────────────────────
func _s2b_the_seats() -> void:
	print("\n§2b — a seat that says next: the glossary's line, and the line driven both ways")
	# C06, THROUGH THE GLOSSARY's OWN DOOR.
	var entry: Dictionary = Glossary.entry("extra_turn")
	var line := "Under a modifier that puts the warband first, a card that moves a hero to act next cannot move that hero ahead of a warband turn that modifier put first."
	ok(String(entry.get("long", "")).contains(line), "§2b: the glossary has no line for the seats")
	# THE LINE IS SCOPED BECAUSE THE SEAT IS: each seat walks heroes and enemies alike, so in an ordinary fight it IS ahead of the warband,
	# and under Outpaced it is ahead of every enemy not due in its span. The board is a hero's own turn, as play reaches one: the caster has acted
	# and stands late, and no enemy is left in the span the clock stands in, because under Outpaced they all went first.
	var battle := _doc("res://scripts/battle.gd")
	ok(battle.contains("for u in heroes + enemies + companions:\n\t\tif u.dead or u == ally:"), "§2b: Rally's seat no longer walks the warband, and the line's scope was read off that walk")
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var enemies: Array = scene.get("enemies")
	var was_active: bool = _run.active
	var was_mod = _run.pending_modifier
	_run.active = true
	var span := float(scene.get("OUTPACED_SPAN"))
	var caster: BattleUnit = heroes[0]
	var ally: BattleUnit = heroes[1]
	var lay := func() -> void:
		for k in heroes.size():
			heroes[k].next_time = span * (1.6 + 0.1 * k)
		caster.next_time = span * 3.0
		for k in enemies.size():
			enemies[k].next_time = span * (1.2 + 0.02 * k)
		scene.set("_clock", span * 0.9)
	_run.pending_modifier = ""
	lay.call()
	scene.call("_rally_forward", caster, ally)
	ok(scene.call("_next_unit") == ally, "§2b: DRIVEN — with no card the seat did not go ahead of the warband, so the line need not be scoped")
	_run.pending_modifier = "outpaced"
	lay.call()
	scene.call("_rally_forward", caster, ally)
	var first: BattleUnit = scene.call("_next_unit")
	ok(not first.is_hero, "§2b: DRIVEN — under Outpaced the seat went to %s, ahead of an enemy in its span" % first.unit_name)
	# THE OTHER HALF: A HERO STILL DUE IN THE CASTER's SPAN PULLS THE SEAT INTO IT, WHERE NO WARBAND TURN STANDS AHEAD OF THE HEROES', SO IT GOES FIRST.
	lay.call()
	heroes[2].next_time = span * 0.95
	scene.call("_rally_forward", caster, ally)
	ok(scene.call("_next_unit") == ally, "§2b: DRIVEN — under Outpaced a seat in a span with no enemy due did not take the front of the heroes' turns")
	_run.pending_modifier = "ambushed"
	lay.call()
	scene.set("_ambush_left", 2)
	var unseated: float = ally.next_time
	scene.call("_rally_forward", caster, ally)
	ok(ally.next_time < unseated, "§2b: under Ambushed the seat moved nobody, so the arm below asks nothing")
	first = scene.call("_next_unit")
	ok(not first.is_hero, "§2b: DRIVEN — under Ambushed the seat went to %s, ahead of the run" % first.unit_name)
	scene.set("_ambush_left", 0)
	_run.pending_modifier = was_mod
	_run.active = was_active
	scene.queue_free()
	await process_frame
	print("    the line stands; DRIVEN from a hero's own turn: ahead of the warband with no card, behind a turn Outpaced or Ambushed put ahead, first in a span with no enemy due")


# ── §2c — THE FIELD ──────────────────────────────────────────────────────────
func _s2c_the_field() -> void:
	print("\n§2c — a burst opener leaves the fixed band")
	var mods: Dictionary = _run.MODIFIERS
	var marked: Array = []
	for id in mods:
		if (mods[id] as Dictionary).has(FLAG):
			marked.append(String(id))
	ok(bool((mods["ambushed"] as Dictionary).get(FLAG, false)), "§2c: Ambushed does not carry the field")
	# C07, ON THE ABSENCE, BESIDE THE ARM ABOVE AND THE COUNT BELOW.
	ok(marked == ["ambushed"], "§2c: %d modifiers carry the field, and Ambushed alone should: %s" % [marked.size(), str(marked)])
	var band: Array = _run.FIXED_MODIFIER_BAND
	var in_band: Array = []
	for id in mods:
		var sev := int((mods[id] as Dictionary).get("severity", 0))
		if sev >= int(band[0]) and sev <= int(band[1]):
			in_band.append(String(id))
	var pool: Array = _run._fixed_modifier_pool()
	var want: Array = in_band.filter(func(i): return not marked.has(i))
	var got: Array = pool.duplicate()
	got.sort()
	want.sort()
	ok(got == want, "§2c: the band draws %s, and the deck less what the field marks is %s" % [str(got), str(want)])
	ok(in_band.has("ambushed") and pool.size() == in_band.size() - marked.size() and pool.size() > 0, "§2c: the band holds %d and draws %d, the field marking %d" % [in_band.size(), pool.size(), marked.size()])
	# C08: THE DOOR THE RUNG DEALS BY, DRIVEN: WHAT THE BAND DEALS, NOT WHAT THE TABLE SAYS.
	var was_diff: String = _run.difficulty
	var was_mod = _run.pending_modifier
	_run.difficulty = "ruin"
	seed(20261031)
	var dealt := {}
	for i in 600:
		_run.pending_modifier = ""
		_run.arm_fixed_modifier("boss")
		var m := String(_run.pending_modifier)
		dealt[m] = int(dealt.get(m, 0)) + 1
	_run.pending_modifier = was_mod
	_run.difficulty = was_diff
	ok(not dealt.has("ambushed"), "§2c: DRIVEN — Ruin's boss drew Ambushed %d times of 600" % int(dealt.get("ambushed", 0)))
	var never: Array = pool.filter(func(i): return not dealt.has(i))
	ok(never.is_empty() and dealt.size() == pool.size(), "§2c: DRIVEN — the door dealt %s, and the band draws %s" % [str(dealt.keys()), str(pool)])
	print("    CHECKED the field on %s; the band holds %d and draws %d; DRIVEN 600 deals over %d cards, Ambushed none" % [str(marked), in_band.size(), pool.size(), dealt.size()])


# ── §3 — THE BATCH-CODE ARM ──────────────────────────────────────────────────
func _s3_the_batch_code_arm() -> void:
	print("\n§3 — the arm that reads a batch code holds the project's own rule for one")
	var src := _doc("res://check_is.gd")
	var open := "var BATCH_NAME := RegEx.create_from_string(\""
	var at := src.find(open)
	ok(at >= 0, "§3: check_is no longer holds its pattern where this gate reads it")
	if at < 0:
		return
	var end := src.find("\")\n", at)
	var pattern := src.substr(at + open.length(), end - at - open.length()).replace("\\\\", "\\")
	var rx := RegEx.create_from_string(pattern)
	ok(rx != null and rx.is_valid(), "§3: the pattern does not compile")
	# C09: THE POPULATION IS THE REPORTS' OWN CODES, THE LAST OF THEM INCLUDED, AND THE NEXT LETTER.
	var codes: Array = []
	var report := RegEx.create_from_string("^[A-Z]+\\.md$")
	for f in DirAccess.get_files_at("res://docs/reports"):
		if report.search(f) != null:
			codes.append(f.get_basename())
	codes.sort()
	ok(codes.size() >= 100, "§3: the reports hold %d codes" % codes.size())
	var unread: Array = []
	for c in codes + ["KA", "ZZ"]:
		for form in ["Batch %s", "%s §2", "since %s"]:
			if rx.search(form % c) == null:
				unread.append(form % c)
	ok(unread.is_empty(), "§3: the pattern cannot read %d batch-code forms: %s" % [unread.size(), str(unread.slice(0, 6))])
	print("    the pattern reads all %d codes the reports carry, %s to %s, and the two past them" % [codes.size(), codes[0] if codes.size() > 0 else "-", codes[-1] if codes.size() > 0 else "-"])


# ── §4 — THE FALLEN HERO, READ OUT ───────────────────────────────────────────
func _s4_the_fallen_hero() -> void:
	print("\n§4 — the fallen hero: three tables, and nothing built")
	# THE DOORS: every one a real function, and every place the brief asks after holds at least one.
	var doors := _tsv("res://docs/reports/JC-fallen-doors.tsv", ["where", "door", "file", "function", "what_it_does"])
	var places := {}
	var unresolved: Array = []
	for r in doors:
		places[String(r["where"])] = int(places.get(String(r["where"]), 0)) + 1
		if not FileAccess.get_file_as_string("res://" + String(r["file"])).contains("func %s(" % String(r["function"])):
			unresolved.append("%s: %s" % [r["file"], r["function"]])
	ok(unresolved.is_empty(), "§4: %d doors name no function in their file: %s" % [unresolved.size(), str(unresolved)])
	var unasked: Array = PLACES.filter(func(p): return not places.has(p))
	ok(unasked.is_empty(), "§4: the doors table asks nothing of %s" % str(unasked))
	# C10: EVERY THING THE RULING PRICES IS READ OFF THE RECORD ITS ROW NAMES, NOT OFF A BRIEF.
	var seven := _tsv("res://docs/reports/JC-fallen-seven.tsv", ["thing", "kind", "record", "record_block", "what_it_is", "what_it_needs_the_ruling_to_say", "what_it_cannot_be_decided_without"])
	var live := _doc("res://docs/state.md")
	var kept := _doc("res://DoD-archive/state-archive.md")
	var not_recorded: Array = []
	var kinds := {}
	for r in seven:
		var kind := String(r["kind"]).split(",")[0]
		kinds[kind] = int(kinds.get(kind, 0)) + 1
		var word := String(r["thing"]).replace("The map's ", "").replace("The Cairn", "Cairn")
		var held := false
		for hay in [live, kept]:
			var b: String = _block(hay, String(r["record_block"]))
			if b.findn(word) >= 0 and b.findn("stays down") >= 0:
				held = true
		if not held:
			not_recorded.append(String(r["thing"]))
	ok(not_recorded.is_empty(), "§4: %d rows stand on no record that names both them and the ruling: %s" % [not_recorded.size(), str(not_recorded)])
	var line := "it prices three crest runes, two relics, an event and the map's Revive Potion"
	ok(_flat(live + kept).contains(line), "§4: the record no longer says what the ruling prices")
	ok(kinds == {"crest rune": 3, "relic": 2, "event": 1, "item": 1}, "§4: the rows hold %s, and the record says three, two, one and one" % str(kinds))
	# C11: A FIGURE WITH NO POPULATION AND NO FIDELITY IS NOT A FIGURE.
	var rate := _tsv("res://docs/reports/JC-fallen-rate.tsv", ["population", "rung", "kind", "runs", "fights", "falls", "falls_a_fight", "fidelity"])
	var bare := 0
	var pops := {}
	var rungs := {}
	for r in rate:
		if String(r["population"]) == "" or String(r["population"]) == "-" or String(r["fidelity"]) == "" or String(r["fidelity"]) == "-":
			bare += 1
		pops[String(r["population"])] = true
		rungs[int(r["rung"])] = true
	ok(bare == 0 and rate.size() > 0, "§4: %d of %d rows give a figure with no population or no fidelity" % [bare, rate.size()])
	ok(pops.size() >= 2 and rungs.size() == 3, "§4: the rate reads %d populations on %d rungs" % [pops.size(), rungs.size()])
	# THE RULING CAME AFTER THESE TWO WERE WRITTEN: THE RETURN STANDS AT THE LINE THE DOORS TABLE NAMES, ITS FLOOR A NAMED CONSTANT, AND THE
	# EVENT READS WHAT THE RULING LEFT IT.
	var unit := _doc("res://scripts/unit.gd")
	ok(unit.contains("member[\"hp\"] = clampi(maxi(hp, int(save_max * RETURN_FLOOR_PCT)), 1, save_max)"), "§4: the return moved, and the ruling is the designer's")
	ok(_doc("res://data/events.json").contains("\"fell_last_fight\": true"), "§4: the Cairn's requirement moved")
	print("    CHECKED %d doors in %d places; %d things on their records %s; %d rate rows on %d populations and %d rungs" % [doors.size(), places.size(), seven.size(), str(kinds), rate.size(), pops.size(), rungs.size()])
