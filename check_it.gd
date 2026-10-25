# BATCH IT — THE STRIKE, THE FIGURES NAMED, THE POSITIONAL FAMILY, AND THE INDEX's STAMPS.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: the strip's test as its rule's operative half, and the strip as
#        prevention (CLAUDE.md's working agreement); a figure named for what it is (CLAUDE.md's text standard); and the
#        three instrument rules — the window and the pick, the alarm's fenced structure, the latent defect's armed gate —
#        each a block of docs/instrument-rules.md with its row, and standing in no other rule file.
#   §1   THE STRIKE FROM CLAUDE.md: the fifty-four items struck from IS's census of it stay struck, each block reads whole
#        across its cut, and each item's record stands where its row names it — a strike whose record is gone is a
#        deletion.
#   §2   THE FIGURES NAMED: every text figure a check_ij §3 pin held whose literal IT named — the figure the text states
#        against the value of the constant that now decides it, and the line that decides it reading that constant — and
#        every constant IT named is declared once and read where a fight decides it, and its declaration's comment names
#        what the figure IS and never the figure (HO §0's rule: a second copy beside the one rots at the first re-tune).
#   §3   THE POSITIONAL FAMILY: the kept census parses whole — every row its tree, every MISS a disposition, every
#        repaired target saying so in its source — and the window helpers are proved on synthetic input: a window cut by
#        its subject ends inside it, and a fixed window that runs past it is told apart.
#   §5   THE INDEX's STAMPS: every entry of docs/state.md's index carries the stamp of the block it names, so a batch that
#        amends a block amends its row in the same batch; the rule stands inside the index's fence.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §5's stamp proves a row was touched when its block changed, not that its words
# were re-read: a batch can re-stamp a row it never read. §2 holds the figures IT moved; the figures check_ij §3 still pins
# are check_ij's. §2c reads a constant's own declaration line; a comment at a read site that restates the figure is a
# census's to find (IT's report, §2), not this gate's.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_it.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _cache := {}
var _docs := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IT — THE STRIKE, THE FIGURES NAMED, THE POSITIONAL FAMILY, AND THE INDEX's STAMPS")
	_s0_the_rulings()
	_s1_the_strike()
	_s2_the_figures_named()
	_s3_the_positional_family()
	_s5_the_index_stamps()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string("res://" + path)
	return _docs[path]


# A record read as prose: an HTML file's tags out, emphasis and code ticks out, whitespace collapsed.
func _plain(path: String) -> String:
	var key := "plain:" + path
	if not _docs.has(key):
		var s := FileAccess.get_file_as_string("res://" + path)
		if path.ends_with(".html"):
			s = RegEx.create_from_string("<[^>]+>").sub(s, "", true)
		_docs[key] = _flat(s.replace("*", "").replace("`", ""))
	return _docs[key]


func _flat(s: String) -> String:
	return RegEx.create_from_string("\\s+").sub(s, " ", true).strip_edges()


# ── §0 — THE RULINGS ────────────────────────────────────────────────────────

const RULE_HEADS := [
	["A WINDOW ASSERTS IT ENDS INSIDE ITS OWN SUBJECT, AND A POSITIONAL PICK ASSERTS IT PICKED WHAT ITS PREDICATE NAMES",
		"A POSITIONAL PICK ASSERTS THAT WHAT IT PICKED IS WHAT ITS PREDICATE"],
	["AN ALARM's BAR IS SET BY THE THING IT IS ALARMING ABOUT, AND STRUCTURE IS FENCED",
		"A ONE-TIME STRUCTURAL SECTION IS NOT THAT THING"],
	["A LATENT DEFECT THAT NEEDS A WRITER GETS A GATE THAT REDS WHEN THE WRITER APPEARS",
		"It is better than a FOUND AT line"],
]


func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var cm := _doc("CLAUDE.md")
	var ir := _doc("docs/instrument-rules.md")
	# §0.2 — the strip's test and its record, in the working agreement's bullet that rules master.html.
	var wa := cm.find("## Working agreement")
	var wa_end := cm.find("\n## ", wa + 5)
	var bullet := cm.find("SAYS WHAT THE GAME IS. A CLAUSE ABOUT WHAT IT WAS", wa)
	ok(wa >= 0 and wa_end > wa and bullet > wa and bullet < wa_end,
		"§0.2: the working agreement's master.html bullet is not found — the rulings below have no subject")
	for n in ["THE RULE's OPERATIVE HALF", "never *is this a rationale*", "THE STRIP WAS PREVENTION, NOT REPAIR",
			"**140 in plain present-tense prose**", "the structural answer\n      is a figure behind a door"]:
		var at := cm.find(n)
		ok(cm.count(n) == 1 and at > bullet and at < wa_end,
			"§0.2: CLAUDE.md does not say '%s' once, inside the working agreement's master.html bullet" % n.replace("\n", " "))
	# §2a — a figure named for what it is, inside the text standard's figure bullet.
	var fig := cm.find("A FIGURE THE CODE HOLDS IS READ, NEVER RETYPED")
	for n in ["ONE CONSTANT ONLY IF A RE-TUNE WOULD MOVE BOTH", "CONSTANTS THAT HAPPEN TO BE EQUAL", "**The test is\n    a re-tune**",
			"a figure stated there with no door reds"]:
		var at := cm.find(n)
		ok(cm.count(n) == 1 and fig > 0 and at > fig and at < wa_end,
			"§2a: CLAUDE.md does not say '%s' once, beside the rule that a figure the code holds is read" % n.replace("\n", " "))
	# The three instrument rules: a block each in the reference, its row in CLAUDE.md's index, the block in no other file.
	for r in RULE_HEADS:
		var head := String(r[0])
		var blk_head := "## STANDING RULE — " + head
		var row := "| " + head + " |"
		ok(ir.count(blk_head) == 1, "§0: the instrument rules do not hold '%s' once" % head)
		ok(cm.count(row) == 1 and not cm.contains(blk_head), "§0: CLAUDE.md's index has no row for '%s', or holds its block" % head)
		var at := ir.find(blk_head)
		# A block runs to the next `## ` heading, or to the file's end when it is the last one.
		var blk := Gate.subject(ir, at, "\n## ") if ir.find("\n## ", at + 1) > at else (ir.substr(at) if at >= 0 else "")
		ok(blk.begins_with(blk_head) and blk.contains(String(r[1])), "§0: the block '%s' does not carry its statement" % head)


# ── §1 — THE STRIKE FROM CLAUDE.md ──────────────────────────────────────────
# [item, kind, [[the file its record stands in, a phrase of the record]], a phrase of the struck text, the join its cut
# left]. The struck phrase is absent; the join stands once, so the block reads whole across the cut; the record stands.
const STRIKE := [
	[0, "HIST", [["docs/reports/IJ.md", "THE FOUR CLOSED BLOCKS, EACH STRUCK TO ONE LINE"]],
		"II's four were struck so at IJ, each report read first (IJ's report, §",
		" stood and never a new file.\n\n**A RULING RECORDED BEFORE"],
	[1, "HIST", [["docs/reports/EF.md", "NOTHING WAS REWRITTEN, AND THE PROOF IS BYTE-FOR-BYTE"]],
		"stood here, the two halves were asserted to re-concatenate byte for by",
		"s a split taken in a hurry.\n- **WHEN A NEW RULE IS WRITT"],
	[2, "HIST", [["docs/reports/GR.md", "THE REJOIN, PROVED"], ["docs/reports/GR.md", "second script"]],
		"here, and the two halves rejoin byte for byte against the pre-split fi",
		"in `docs/reports/GR.md` §1.\n- **THE INDEX HAZARD ABOVE B"],
	[5, "MEAS", [["docs/reports/HN.md", "393.67"], ["docs/reports/HN.md", "474.65"], ["docs/reports/HY.md", "HU's floor"]],
		"80.99 = 474.65, stated as 470. HV priced the fifth at 510 on HU's floo",
		"vation is one nobody trusts.\n  · **THIS WAS THE CEILING'"],
	[7, "HIST", [["docs/reports/FF.md", "RE-DERIVE THE CEILING PER HALF"], ["docs/reports/FF.md", "OVERTURN THE ONE-WAY TIEBREAK"]],
		"FIRST** — the ceiling above is this file's own, off this file's own po",
		"he tiebreak\n    keeps both. The classification and\n    i"],
	[9, "HIST", [["DoD-archive/changelog-archive.html", "THE TALENT AUDIT CORRECTIONS"], ["DoD-archive/changelog-archive.html", "wd_hold_line"], ["DoD-archive/changelog-archive.html", "sm_deep_thrust"], ["DoD-archive/changelog-archive.html", "cr_rime"]],
		"brief — `wd_hold_line` (the undying window, 1/2→2/3). The Pivot chip's",
		"came to hold both at once.\n\n- **A STUN COSTS ONE TURN, W"],
	[11, "MEAS", [["docs/reports/DA.md", "0.81"], ["docs/reports/DA.md", "2.60"], ["docs/reports/DA.md", "4.24"]],
		"- **THE THRESHOLD ALONE IS WORTH ROUGHLY A TRIPLING OF RELEASES** — 0.",
		"e.\n  Measured, not assumed.\n- **THE SUITES WERE PAID AT "],
	[12, "HIST", [["docs/reports/DM.md", "FOUR PROSE COPIES OF ONE CLAUSE"]],
		"is refused to a companion twice over, so *ally* was never available to",
		" and only a suite\n  noticed.\n- **THE SUITE THAT NOTICED W"],
	[14, "MEAS", [["docs/reports/CY.md", "31%"], ["docs/reports/CY.md", "1.6"]],
		"At CY Blood Frenzy reached 31% of its band and Faith 1.6 of the 5 a re",
		"ure taken\n  the same way.**\n\n**THE BUFF IS NOT FREE AND "],
	[16, "HIST", [["docs/reports/GE.md", "NO PERMANENT LAYER IS SPEC-SPECIFIC"]],
		"talents until GE §2, which FX's one tree had already made impossible.",
		"he tree has no spec to know.\n- **If it sets the run up — "],
	[17, "HIST", [["docs/reports/EN.md", "STOPPED, AND NOTHING WAS REMOVED"]],
		"**EN WAS ASKED TO REMOVE IT AND STOPPED, WHICH IS WHAT ITS OWN BRIEF I",
		"through with nothing.**\n\nThe chain is four links and "],
	[18, "HIST", [["docs/reports/HL.md", "DRAFTING FIREBALL ALSO GRANTED RAZOR ICE"]],
		"Until HL one pick could hand over a rune and a card — the designer's *",
		"and nobody authored that.\n  Class selection still slots "],
	[19, "HIST", [["docs/reports/IT-claude-strike.md", "Recorded in full before a line of code, on the brief's instruction."]],
		"Recorded in full before a line of code, on the brief's instruction.",
		"K BUILT, CLAUSE BY CLAUSE.**\nIt supersedes the class-cor"],
	[20, "HIST", [["docs/reports/GS.md", "ENGINE_BOUND"], ["docs/reports/GS.md", "not zeroed"], ["docs/reports/GM.md", "ENGINE_BOUND"]],
		"builder took them out when the engine was dropped. GS §1 took every ca",
		"ING HOLDS BY CONSTRUCTION.**\n  **A LINEAGE CARD THE DOOR"],
	[21, "MEAS", [["docs/reports/IL.md", "IT STAYS 13"]],
		"as the source of every live status he lays (IJ's ruling 9), and it sta",
		" carries his steps a fight. **A rate is re-read when wha"],
	[23, "HIST", [["docs/reports/HJ.md", "lineage's SHELF"], ["docs/reports/HJ.md", "boss pool"]],
		"and boss pool from AU §5 until the draft pools merged;",
		"HJ §3, ruled by the designer; the NAME is HJ's proposal, the\n  des"],
	[24, "HIST", [["docs/reports/ED.md", "THE TWO STALE NAMES"]],
		"the report-header claim.",
		"ch AN, with their features).\n\n## STANDING RULE — THE REA"],
	[26, "HIST", [["docs/reports/ER.md", "STALE BY TEN THOUSAND LINES"], ["docs/reports/GB.md", "a line-number citation is dropped rather than re-numbered"]],
		"(EQ found it, ER corrected it, and they had drifted again by GB, which",
		"LE BY TEN\n  THOUSAND LINES** — the table's\n  CONTENT was r"],
	[27, "HIST", [["docs/reports/FU.md", "regenerates 22"]],
		"AND FT's ECONOMY WAS WRONG, SO THIS ROW NO LONGER SAYS THE BAR IS TIGH",
		"GHT AND THE CAP A LONG\n  ONE**: Mana starts at\n  100 and ca"],
	[28, "HIST", [["DoD-archive/changelog-archive.html", "30 of the 66 damaging abilities never state their damage"]],
		"CK the sheet held the only copy, which is exactly why the draft card h",
		"CE. That shared path is the point.**\n- **THE DRAFT CARD IS AN AR"],
	[29, "MEAS", [["DoD-archive/changelog-archive.html", "193"], ["DoD-archive/changelog-archive.html", "207 resolvable"]],
		"strings (over 207 resolvable abilities), **17 are wider than the 258px",
		"o be fixed, fix the layout.\n- CJ's 44-character ceiling is"],
	[33, "HIST", [["docs/reports/DO.md", "Five nodes were already named after live abilities"]],
		"Five nodes were already named after live abilities before DO and",
		"rd is a trap in a new place.\n· **WHAT THE MOVE COSTS, RE"],
	[34, "MEAS", [["docs/reports/FC.md", "6 detonations into 16"]],
		"payoff survives — over 60 marks it still turns 6 detonations into **16",
		"or a later batch to re-tune.\n- **AND THE FLAG IS SET ONL"],
	[35, "MEAS", [["docs/reports/EO.md", "5.7"], ["docs/reports/EO.md", "7.8"], ["docs/reports/EO.md", "9.2"], ["docs/reports/EO.md", "73%"]],
		"untalented, n=30 a rung: a rung-1 trash fight ran 5.7 rounds against r",
		"of pressure an item is for. **MEASURE THIS ON ROUNDS, NO"],
	[40, "MEAS", [["docs/reports/FN.md", "TWO OF THE EIGHT ARE UNREACHABLE"]],
		"share of each spec's reachable loadouts that satisfied them: 69–86% fo",
		" moves with the slot ladder.\n\n- **A CONDITIONED RUNE PAY"],
	[41, "MEAS", [["docs/reports/FD.md", "265"], ["docs/reports/FD.md", "127"], ["docs/reports/FD.md", "twice"]],
		"queued before either is answered share a name in 265 of 400 trials**,",
		"ready owns is offered again.\n- **THE INSTRUMENT THAT COU"],
	[43, "HIST", [["docs/reports/FE.md", "bm_candidates"], ["docs/reports/FE.md", "different fault"]],
		"**FE DROVE THE TWO QUEUES FD REPORTED AND BOTH OF FD'S ROWS WERE WRONG",
		"o not merely decline it.**\n\n- **THE IDIOM'S POPULATION I"],
	[44, "HIST", [["docs/reports/GF.md", "REPRODUCED, AS A REAL QUIT, ON BOTH BRANCHES"]],
		"nothing, so a quit on an elite's or a mini-boss's bargain, inside any",
		"> resumed run is placed.**\n\n- **THE STEP STAYS AT THE CL"],
	[45, "HIST", [["docs/reports/GH.md", "NO SAVE VERSION"]],
		"- **IT MOVED NO SAVE VERSION** (VERSIONS, under TALENTS ARE META PROGR",
		"lays the fight they opened.\n\n## STANDING RULE — BREAK IS"],
	[46, "HIST", [["docs/reports/FD.md", "Pyrewake"], ["docs/reports/FD.md", "54 of 227"]],
		"- **54 OF 227 ROWS MOVED, AND THE POPULATION WAS DERIVED RATHER THAN T",
		"e word is on the card for.\n\n- **30 ROWS LOST A SECONDARY"],
	[48, "HIST", [["docs/reports/HK.md", "ninety-nine live entries"]],
		"**It moved as a data edit on the ninety-nine live entries and nothing",
		" rune's text one field over."],
	[49, "HIST", [["docs/reports/EZ.md", "100g flat"], ["docs/reports/ES.md", "100g rares and a 75g Scarred are priced against a tier that will not exist"]],
		"**THIS CLOSES THE PRICING QUESTION ES §1 OPENED AND `docs/state.md` HA",
		"xt one field over.\n\nThe\nretired 67 keep their au"],
	[50, "HIST", [["docs/reports/HR.md", "THE SAVE MIGRATES"]],
		"save to v15 (the VERSIONS bullet under TALENTS ARE META PROGRESSION).",
		" the cap binds at intake.** HK's `_bag_the_unworn`, whic"],
	[51, "HIST", [["docs/reports/HK.md", "PARTY RUNES: THE MACHINERY, AND NO CONTENT"]],
		"HK built the scope, the slot and every door over none.",
		" RETIRED (two bullets down).\n  · **TITHE PAYS FOR BREAK "],
	[52, "HIST", [["docs/reports/IR.md", "A FLOOR PAYS ONLY WHEN WHAT IT IS A SHARE OF IS THERE"]],
		"billing every bound hero 1 for a blow parried outright**, repaired wit",
		"ion rounds away heal nobody.\n  · **A SPLIT DISTRIBUTES W"],
	[53, "MEAS", [["docs/reports/EJ.md", "59 of 135"], ["docs/reports/EJ.md", "32 of the 65"], ["docs/reports/EM.md", "56"]],
		"at **59 of 135 clauses in 32 of the 65 runes**; EM re-keyed **56** ont",
		"S IS ITS MECHANICAL HALF.** What\nremains open is design "],
	[54, "MEAS", [["docs/reports/GP.md", "spine-taker"]],
		"**A hero drew from 13 to 18 before the merge and a",
		"e cards into the class kits.\n**DO NOT RE-RECORD ANY PART"],
	[56, "HIST", [["docs/reports/HD.md", "three of HEAD's gates read the ruled rows as mistakes"]],
		"two rows as mistakes on the new code, each asking a row to be refused",
		"r that should read apart.** A ruled row is no evidence f"],
	[57, "HIST", [["docs/reports/HE.md", "| Lunge | Swordmaster | the Stances |"]],
		"there with the Stances unslotted until HE §3 pointed the boss at the e",
		"ss pool rather than a shelf.\n- **A CARD THAT SITS OUT WI"],
	[58, "HIST", [["docs/reports/FD.md", "run_sim never bought one"]],
		"`run_sim` never bought one, so no measured figure moves.",
		"\nsame breath as the removal.\n\n## STANDING RULE — A RUNE "],
	[59, "HIST", [["docs/reports/EG.md", "CT's own scar"]],
		"This is CT's scar (the opening pouch sized off the previous run's zone",
		"se open every\n  hero at ten.\n- **WHICH SET A READER WANT"],
	[60, "MEAS", [["docs/reports/EA.md", "Devout"], ["docs/reports/EA.md", "sharp case"]],
		"way; **the Devout is the sharp case, not Holy** — his boss pool is two",
		"me the pools are disjoint.**\n- **WHY THIS POOL, RECORDED"],
	[62, "MEAS", [["docs/reports/EH.md", "No rune grants a class-wide card"]],
		"EH §1 derived it against the class-wide tier as well: **no",
		" than assuming it is zero.**\n- **BATCH EH §1 TOOK THE TH"],
	[63, "HIST", [["DoD-archive/changelog-archive.html", "The Swordmaster's stances were a binary toggle"]],
		"behaved differently depending on which one he was in; BP's two draft c",
		"E IT LEAVES HIM IN WANTS.** Cast\nfrom Aggressive he land"],
	[65, "HIST", [["docs/reports/HS.md", "It read stances, Loyalty, Focus"]],
		"It read *Burn, Chilled* until HS, and a reader took the two STATUSES f",
		"S §1; HR §4h found it).**\n  Overburn and Glacial Hold ar"],
	[66, "HIST", [["docs/reports/DR.md", "DN's gate asserted two exclusives"]],
		"there were five; DO's brief asserted nine grant-capstones and there we",
		"AS A COUNT OF EXCLUSIVES.** A count is a fact about\ntoda"],
	[67, "MEAS", [["docs/reports/IT-claude-strike.md", "Nine absent axes, not three"]],
		"genuinely missing from all twenty-four Hunter spec cards, and so were",
		" are different populations.\n\n### A REPEATABLE DRAFT CARD"],
	[68, "HIST", [["docs/reports/EL.md", "THE CHEAP SIDE MOVED"]],
		"`cr_icy_veins` is **Shockwave** (`battle.gd`'s own log line already sa",
		"EAP SIDE WAS SIX STRINGS.** **THE STATUS IDS DID NOT MOV"],
	[69, "HIST", [["docs/reports/GM.md", "Hunter's Mark, Arcane Echo and Rime"]],
		"Arcane Echo and Rime — and listed all three there.",
		"s in `battle.DISPEL_NEVER`. **Rime is tagged an afflicti"],
	[70, "HIST", [["DoD-archive/changelog-archive.html", "Two accidental exceptions"]],
		"rather than about the party. Two accidental exceptions proved the shap",
		"IS DEAD MOST OF THE\nTIME.** The two halves of the rule a"],
	[71, "HIST", [["DoD-archive/changelog-archive.html", "which Holy already holds (tranche 1, Batch BO), and is Battle Trance here"]],
		"· **RENAMED HERE: the Warrior recovery card was authored as SECOND WIN",
		"ner's\ncall and one string).\n· **REPORTED, NOT RESOLVED —"],
	[74, "MEAS", [["docs/reports/HI.md", "SIX PLANTS"]],
		"· **MEASURED AT HI, PLANTING ONE SECOND DEFINITION OF EACH SHAPE.** An",
		"y's swing — as a named set.\n\n## STANDING RULE — A RUNE'S"],
	[75, "HIST", [["docs/reports/FK.md", "The Devout ships four"]],
		"Devout shipped four.**",
		"nd let the designer choose\".\n· **AND THE REASON GOES IN "],
	[76, "HIST", [["docs/reports/FK.md", "IT FORCED EXACTLY ONE RENAME"]],
		"rename**: bare, a second `Long Watch` is byte-identical to the Warden'",
		"ame is free\"* becomes TRUE. **Nothing RESOLVES a rune by"],
]


func _s1_the_strike() -> void:
	print("
§1 — the strike from CLAUDE.md: struck, whole across each cut, and recorded")
	var cm := _doc("CLAUDE.md")
	var gone := 0
	var whole := 0
	var recorded := 0
	for r in STRIKE:
		var item := int(r[0])
		if cm.contains(String(r[3])):
			ok(false, "§1: item %d's struck text stands in CLAUDE.md again — '%s'" % [item, String(r[3]).substr(0, 60)])
		else:
			gone += 1
		if cm.count(String(r[4])) != 1:
			ok(false, "§1: item %d's cut does not read whole — its join stands %d times" % [item, cm.count(String(r[4]))])
		else:
			whole += 1
		var found := true
		for rec in r[2]:
			if not _plain(String(rec[0])).contains(_flat(String(rec[1]).replace("*", "").replace("`", ""))):
				found = false
				ok(false, "§1: item %d's record is gone from %s — '%s'; a strike whose record is gone is a deletion" % [item, rec[0], rec[1]])
		if found:
			recorded += 1
	ok(STRIKE.size() == 54 and gone == 54 and whole == 54 and recorded == 54,
		"§1: %d of %d items struck, %d whole across their cuts, %d recorded" % [gone, STRIKE.size(), whole, recorded])
	print("    CHECKED %d struck items: %d absent, %d whole across the cut, %d with their record standing" % [STRIKE.size(), gone, whole, recorded])


# ── §2 — THE FIGURES NAMED ──────────────────────────────────────────────────
# [holder, the needle in its text, the figure it states (digits, a word, or "" where the text is a format reading the
# constant itself), its door (an Expression over the constant maps, or the format's argument fragment), the file and the
# function that decide it, the line there that reads the constant]. 180 of these were check_ij §3's pins until IT named
# their literals; the 181st is a second figure one of those needles stated.
const FIGURES := [
	["card:Crushing Blow:perfect", "+5 bonus BD", "5", "Battle.CRUSHING_BLOW_PERFECT_BD", "scripts/battle.gd", "_resolve", "pr += CRUSHING_BLOW_PERFECT_BD"],
	["card:Pommel Strike:desc", "keen 25%", "25%", "Battle.POMMEL_STRIKE_CRIT*100", "scripts/battle.gd", "_resolve", "var crit_chance := (POMMEL_STRIKE_CRIT if ab.display_name == \"Pommel Strike\" else CRIT_CHANCE) \\"],
	["card:Mocking Blow:desc", "for 4 turns", "4", "Battle.MOCKING_BLOW_TURNS", "scripts/battle.gd", "_resolve", "var taunt_turns := MOCKING_BLOW_PERFECT_TURNS if is_perfect else MOCKING_BLOW_TURNS"],
	["card:Mocking Blow:perfect", "last 5 turns", "5", "Battle.MOCKING_BLOW_PERFECT_TURNS", "scripts/battle.gd", "_resolve", "var taunt_turns := MOCKING_BLOW_PERFECT_TURNS if is_perfect else MOCKING_BLOW_TURNS"],
	["card:Battle Trance:desc", "for 4 turns", "4", "Battle.BATTLE_TRANCE_TURNS", "scripts/battle.gd", "_resolve_special", "var bt_turns := BATTLE_TRANCE_TURNS"],
	["card:Rally:desc", "regain 15% of", "15%", "Battle.RALLY_RESOURCE_PCT*100", "scripts/battle.gd", "_resolve_special", "var rl_gain := maxi(int(target.max_resource * RALLY_RESOURCE_PCT), 1)"],
	["card:Warcry:desc", "4 turns", "4", "Battle.WARCRY_TURNS", "scripts/battle.gd", "_resolve_special", "var wc_turns := WARCRY_TURNS"],
	["card:Ironclad:desc", "for 4 turns", "4", "Battle.IRONCLAD_TURNS", "scripts/battle.gd", "_resolve_special", "var ic_turns := IRONCLAD_TURNS"],
	["card:Nexus Ward:desc", "for 3 turns", "3", "Battle.NEXUS_WARD_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"barrier\", NEXUS_WARD_TURNS, mb_power)"],
	["card:Nexus Ward:desc", "20% of the", "20%", "Battle.NEXUS_WARD_PCT*100", "scripts/battle.gd", "_resolve_special", "var mb_pct := NEXUS_WARD_PCT"],
	["card:Mirror Image:desc", "next FOUR", "four", "Battle.MIRROR_IMAGE_IMAGES", "scripts/battle.gd", "_resolve_special", "var mi_n: int = maxi(MIRROR_IMAGE_IMAGES,"],
	["card:Mana Well:desc", "for 4 turns", "4", "Battle.MANA_WELL_TURNS", "scripts/battle.gd", "_resolve_special", "var mw_turns := MANA_WELL_TURNS"],
	["card:Mana Well:desc", "DOUBLED", "doubled", "Battle.MANA_WELL_REGEN_MULT", "scripts/battle.gd", "_mana_regen", "regen *= MANA_WELL_REGEN_MULT"],
	["card:Dispel:desc", "strip THREE", "three", "Battle.DISPEL_COUNT", "scripts/battle.gd", "_resolve_special", "var dp_n := DISPEL_COUNT"],
	["card:Blink:desc", "two turns", "two", "Battle.BLINK_TURNS", "scripts/battle.gd", "_resolve_special", "var bl_turns := BLINK_TURNS"],
	["card:Blood Offering:desc", "gain 60 Rage", "60", "Battle.BLOOD_OFFERING_RAGE", "scripts/battle.gd", "_resolve_special", "var bo_rage := BLOOD_OFFERING_RAGE"],
	["card:Blood Offering:desc", "lose 20% of", "20%", "Battle.BLOOD_OFFERING_PCT*100", "scripts/battle.gd", "_resolve_special", "var bo_cost: int = maxi(int(round(attacker.hp * BLOOD_OFFERING_PCT)), 1)"],
	["card:Gut Rip:perfect", "{atk:9}", "9", "Battle.GUT_RIP_PERFECT_PCT", "scripts/battle.gd", "_resolve_special", "var gr_step := GUT_RIP_PERFECT_PCT if is_perfect else ab.damage"],
	["card:Reckless Abandon:desc", "for 3 turns", "3", "Battle.RECKLESS_TURNS", "scripts/battle.gd", "_resolve_special", "var ra_turns := RECKLESS_TURNS"],
	["card:Berserk:desc", "For 3 turns", "3", "Battle.BERSERK_RISK_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"berserk_risk\", BERSERK_RISK_TURNS, BERSERK_RISK_PCT)"],
	["card:Unslaked:desc", "For 4 turns", "4", "Battle.UNSLAKED_TURNS", "scripts/battle.gd", "_resolve_special", "var un_turns := UNSLAKED_TURNS"],
	["card:Unslaked:desc", "FULL bonus", "full", "Unit.UNSLAKED_KEEP", "scripts/unit.gd", "frenzy_bonus", "keep = maxf(keep, UNSLAKED_KEEP)"],
	["card:Spite:desc", "For 6 turns", "6", "Battle.SPITE_TURNS", "scripts/battle.gd", "_resolve_special", "var sp_turns := SPITE_TURNS"],
	["card:Covering Guard:desc", "for 4 turns", "4", "Battle.COVERING_GUARD_TURNS", "scripts/battle.gd", "_resolve_special", "var cg_turns := COVERING_GUARD_TURNS"],
	["card:Eye of the Storm:desc", "for 3 turns", "3", "Battle.EYE_STORM_TURNS", "scripts/battle.gd", "_resolve_special", "var es_turns := EYE_STORM_TURNS"],
	["card:Aegis Wall:desc", "for 4\\nturns", "4", "Battle.AEGIS_WALL_TURNS", "scripts/battle.gd", "_resolve_special", "var aw_turns := AEGIS_WALL_TURNS"],
	["card:Recompense:desc", "For 6 turns", "6", "Battle.RECOMPENSE_TURNS", "scripts/battle.gd", "_resolve_special", "var rp_turns := RECOMPENSE_TURNS"],
	["card:Turn the Blade:desc", "For 4 turns", "4", "Battle.TURN_THE_BLADE_TURNS", "scripts/battle.gd", "_resolve_special", "var tt_turns := TURN_THE_BLADE_TURNS"],
	["card:Precision Strike:desc", "strike TWICE", "twice", "Battle.PRECISION_AGGRO_HITS", "scripts/battle.gd", "_resolve_special", "var ps_hits := PRECISION_AGGRO_HITS if ps_aggressive else PRECISION_DEF_HITS"],
	["card:Feint:perfect", "45% in Aggressive", "45%", "Battle.FEINT_PERFECT_PCT", "scripts/battle.gd", "_resolve_special", "var ft_pct := FEINT_PERFECT_PCT if is_perfect else FEINT_STRIKE_PCT"],
	["card:Battle Poise:desc", "For 4 turns", "4", "Battle.BATTLE_POISE_TURNS", "scripts/battle.gd", "_resolve_special", "var bp_turns := BATTLE_POISE_TURNS"],
	["card:Feigned Guard:desc", "For 3 turns", "3", "Battle.FEIGNED_GUARD_TURNS", "scripts/battle.gd", "_resolve_special", "var fg_turns := FEIGNED_GUARD_TURNS"],
	["card:Discipline:desc", "For 7 turns", "7", "Battle.DISCIPLINE_TURNS", "scripts/battle.gd", "_resolve_special", "var di_turns := DISCIPLINE_TURNS"],
	["card:Answering Steel:desc", "For 6 turns", "6", "Battle.ANSWERING_TURNS", "scripts/battle.gd", "_resolve_special", "var an2_turns := ANSWERING_TURNS"],
	["card:Formless:desc", "For 4 turns", "4", "Battle.FORMLESS_TURNS", "scripts/battle.gd", "_resolve_special", "var fm_turns := FORMLESS_TURNS"],
	["card:Cinderfall:desc", "that much again", "again", "Battle.CINDERFALL_SKIM_MULT", "scripts/battle.gd", "_resolve_special", "cf_final *= CINDERFALL_SKIM_MULT"],
	["card:Cinderfall:desc", "tear 2 turns", "2", "Battle.CINDERFALL_TAKE", "scripts/battle.gd", "_resolve_special", "var cf_take := CINDERFALL_PERFECT_TAKE if is_perfect else CINDERFALL_TAKE"],
	["card:Cinderfall:perfect", "Takes 3 turns", "3", "Battle.CINDERFALL_PERFECT_TAKE", "scripts/battle.gd", "_resolve_special", "var cf_take := CINDERFALL_PERFECT_TAKE if is_perfect else CINDERFALL_TAKE"],
	["card:Ember Debt:desc", "12 turns of Burn", "12", "Battle.EMBER_DEBT_TURNS", "scripts/battle.gd", "_resolve_special", "var ed_turns := EMBER_DEBT_TURNS"],
	["card:Pyre Wake:perfect", "{atk:12}", "12", "Battle.PYRE_WAKE_PERFECT_PCT", "scripts/battle.gd", "_resolve_special", "var pw_pct := PYRE_WAKE_PERFECT_PCT if is_perfect else ab.damage"],
	["card:Winter's Toll:perfect", "{atk:12}", "12", "Battle.WINTERS_TOLL_PERFECT_PCT", "scripts/battle.gd", "_resolve_special", "var wt_step := WINTERS_TOLL_PERFECT_PCT if is_perfect else ab.damage"],
	["card:Rimebinding:desc", "Four", "four", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["card:Rimebinding:desc", "plus one", "one", "Battle.RIMEBINDING_BONUS_STACKS", "scripts/battle.gd", "_resolve_special", "var rb_n: int = rb_deepest + RIMEBINDING_BONUS_STACKS"],
	["card:Killing Frost:desc", "four stacks", "four", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["card:Deep Winter:desc", "HALF the stacks", "half", "1.0 / Battle.DEEP_WINTER_DIVISOR", "scripts/battle.gd", "_resolve_special", "dw_n = int((dw_deepest + 1) / DEEP_WINTER_DIVISOR)"],
	["card:Frostbolt:desc", "Four stacks", "four", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["card:Null Field:desc", "for 4 turns", "4", "Battle.NULL_FIELD_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"null_field\", NULL_FIELD_TURNS)"],
	["card:Null Field:desc", "5% less damage", "5%", "Battle.NULL_FIELD_PCT_PER_STACK*100", "scripts/battle.gd", "_resolve", "var nf_cut := minf(NULL_FIELD_PCT_PER_STACK * strike_target.second_resource, 0.95)"],
	["card:Inner Arcane:desc", "plus\\none", "one", "Battle.INNER_ARCANE_BONUS", "scripts/battle.gd", "_resolve_special", "var ia_gain := ia_alive * (INNER_ARCANE_LOW_MULT if ia_low else 1) + INNER_ARCANE_BONUS"],
	["card:Arcane Explosion:desc", "Builds 1 Resonance", "1", "Battle.RESONANCE_PER_CAST", "scripts/battle.gd", "_resolve", "+ attacker.singularity_crit_build) if any_crit else RESONANCE_PER_CAST"],
	["card:Ministration:desc", "for 20%", "20%", "Battle.MINISTRATION_PCT*100", "scripts/battle.gd", "_resolve_special", "var mn_pct := MINISTRATION_PERFECT_PCT if is_perfect else MINISTRATION_PCT"],
	["card:Ministration:perfect", "{mhp:26|ally}", "26", "Battle.MINISTRATION_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var mn_pct := MINISTRATION_PERFECT_PCT if is_perfect else MINISTRATION_PCT"],
	["card:Unburden:desc", "for 3 turns", "3", "Battle.UNBURDEN_TURNS", "scripts/battle.gd", "_resolve_special", "var ub_turns := UNBURDEN_TURNS"],
	["card:Unburden:desc", "take 20%", "20%", "Battle.UNBURDEN_CUT * 100", "scripts/battle.gd", "_resolve", "raw *= 1.0 - UNBURDEN_CUT"],
	["card:Consecration:desc", "for 4 turns", "4", "Battle.CONSECRATION_TURNS", "scripts/battle.gd", "_resolve_special", "var cn_turns := CONSECRATION_TURNS"],
	["card:Exhortation:desc", "35% more", "35%", "Battle.EXHORTATION_PCT", "scripts/battle.gd", "_resolve_special", "var ex_pct := EXHORTATION_PCT"],
	["card:Undying Vigil:desc", "for 4 turns", "4", "Battle.UNDYING_VIGIL_TURNS", "scripts/battle.gd", "_resolve_special", "var uv_turns := UNDYING_VIGIL_TURNS"],
	["card:Second Wind:desc", "up to 40%", "40%", "Battle.SECOND_WIND_CAP_PCT*100", "scripts/battle.gd", "_resolve_special", "var sw_cap_pct := SECOND_WIND_PERFECT_CAP_PCT if is_perfect else SECOND_WIND_CAP_PCT"],
	["card:Second Wind:perfect", "{mhp:55|ally}", "55", "Battle.SECOND_WIND_PERFECT_CAP_PCT*100", "scripts/battle.gd", "_resolve_special", "var sw_cap_pct := SECOND_WIND_PERFECT_CAP_PCT if is_perfect else SECOND_WIND_CAP_PCT"],
	["card:Rite of Return:desc", "for 4\\nturns", "4", "Battle.RITE_OF_RETURN_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"rite_return\", RITE_OF_RETURN_TURNS, 0, 0, attacker)"],
	["card:Rite of Return:desc", "loses 30%", "30%", "Battle.RITE_OF_RETURN_TOLL_PCT*100", "scripts/battle.gd", "_on_rite_return", "var toll := maxi(int(round(cleric.max_hp * RITE_OF_RETURN_TOLL_PCT)), 1)"],
	["card:Rite of Return:desc", "to 50%", "50%", "Battle.RITE_OF_RETURN_RESTORE_PCT*100", "scripts/battle.gd", "_on_rite_return", "saved.hp = maxi(int(saved.max_hp * RITE_OF_RETURN_RESTORE_PCT), 1)"],
	["card:Recant:desc", "regains 40%", "40%", "Battle.RECANT_PCT*100", "scripts/battle.gd", "_resolve_special", "var rc_pct := RECANT_PCT"],
	["card:Shared Grief:desc", "gain 4 Mercy", "4", "Battle.SHARED_GRIEF_MERCY", "scripts/battle.gd", "_resolve_special", "var sg_grant := SHARED_GRIEF_MERCY + sg_low * SHARED_GRIEF_PER_WOUNDED"],
	["card:Shared Grief:desc", "lose 25%", "25%", "Battle.SHARED_GRIEF_COST_PCT*100", "scripts/battle.gd", "_resolve_special", "var sg_cost := maxi(int(round(attacker.max_hp * SHARED_GRIEF_COST_PCT)), 1)"],
	["card:Reprisal:desc", "to 50%", "50%", "Battle.REPRISAL_SHARE*100", "scripts/battle.gd", "_resolve_special", "var rp_share := REPRISAL_PERFECT_SHARE if is_perfect else REPRISAL_SHARE"],
	["card:Reprisal:perfect", "75% of", "75%", "Battle.REPRISAL_PERFECT_SHARE*100", "scripts/battle.gd", "_resolve_special", "var rp_share := REPRISAL_PERFECT_SHARE if is_perfect else REPRISAL_SHARE"],
	["card:Divine Presence:desc", "for 4 turns", "4", "Battle.DIVINE_PRESENCE_TURNS", "scripts/battle.gd", "_resolve_special", "var mt_turns := DIVINE_PRESENCE_TURNS"],
	["card:Alms:desc", "for 4\\nturns", "4", "Battle.ALMS_TURNS", "scripts/battle.gd", "_resolve_special", "var al_turns := ALMS_TURNS"],
	["card:Vespers:desc", "for 4\\nturns", "4", "Battle.VESPERS_TURNS", "scripts/battle.gd", "_resolve_special", "var vs_turns := VESPERS_TURNS"],
	["card:Vow of Suffering:desc", "for 4\\nturns", "4", "Battle.VOW_OF_SUFFERING_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"vow\", VOW_OF_SUFFERING_TURNS, 0, 0, attacker)"],
	["card:Vow of Suffering:desc", "HALF", "half", "1.0 / Unit.VOW_OF_SUFFERING_SHARE", "scripts/unit.gd", "take_hit", "var share: int = int(vow_cb.call(self, amount / VOW_OF_SUFFERING_SHARE))"],
	["card:Vow of Suffering:desc", "hero\\n1 Faith", "1", "Battle.VOW_OF_SUFFERING_FAITH", "scripts/battle.gd", "_on_vow_share", "_gain_faith(ally, VOW_OF_SUFFERING_FAITH, \"vow\")"],
	["card:Aegis Reversal:desc", "half again", "half again", "Battle.AEGIS_REVERSAL_MULT", "scripts/battle.gd", "_resolve_special", "var ag_bonus: int = int(round(ag_left * AEGIS_REVERSAL_MULT))"],
	["card:Ordination:desc", "grant 4 Faith", "4", "Battle.ORDINATION_FAITH", "scripts/battle.gd", "_resolve_special", "var od_grant := ORDINATION_FAITH"],
	["card:Fortified Spirit:desc", "over\\n3 turns", "3", "Battle.FORTIFIED_SPIRIT_STEPS", "scripts/battle.gd", "_resolve_special", "var fs_steps := FORTIFIED_SPIRIT_PERFECT_STEPS if is_perfect else FORTIFIED_SPIRIT_STEPS"],
	["card:Fortified Spirit:desc", "10 points", "10", "Battle.FORTIFIED_SPIRIT_STEP_PCT*100", "scripts/battle.gd", "_resolve_special", "var fs_step := maxi(int(round(attacker.max_hp * FORTIFIED_SPIRIT_STEP_PCT)), 1)"],
	["card:Reliquary:desc", "for 2.5%", "2.5%", "Battle.RELIQUARY_PCT*100", "scripts/battle.gd", "_resolve_special", "var rq_pct := RELIQUARY_PERFECT_PCT if is_perfect else RELIQUARY_PCT"],
	["card:Reliquary:perfect", "3.5% per", "3.5%", "Battle.RELIQUARY_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var rq_pct := RELIQUARY_PERFECT_PCT if is_perfect else RELIQUARY_PCT"],
	["card:Blessing of the Faithful:desc", "and 3% of", "3%", "Battle.BLESSING_OF_THE_FAITHFUL_MANA_PCT*100", "scripts/battle.gd", "_resolve_special", "var jb_mana := maxi(int(round(attacker.max_resource * BLESSING_OF_THE_FAITHFUL_MANA_PCT"],
	["card:Blessing of the Faithful:desc", "6% of your", "6%", "Battle.BLESSING_OF_THE_FAITHFUL_PCT*100", "scripts/battle.gd", "_resolve_special", "var jb_pct := BLESSING_OF_THE_FAITHFUL_PERFECT_PCT if is_perfect else BLESSING_OF_THE_FAITHFUL_PCT"],
	["card:Blessing of the Faithful:perfect", "{mhp:8}", "8", "Battle.BLESSING_OF_THE_FAITHFUL_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var jb_pct := BLESSING_OF_THE_FAITHFUL_PERFECT_PCT if is_perfect else BLESSING_OF_THE_FAITHFUL_PCT"],
	["card:Blight the Well:desc", "for 6 turns", "6", "Battle.BLIGHT_THE_WELL_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"blight\", BLIGHT_THE_WELL_TURNS, 0, 0, attacker)"],
	["card:Suffering:desc", "For 4 turns", "4", "Battle.SUFFERING_TURNS", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"suffering\", SUFFERING_TURNS, su_rate, 0, attacker)"],
	["card:Suffering:desc", "gains 2 Ruin", "2", "Battle.SUFFERING_RUIN", "scripts/battle.gd", "_resolve_special", "var su_rate := SUFFERING_PERFECT_RUIN if is_perfect else SUFFERING_RUIN"],
	["card:Suffering:perfect", "3 Ruin", "3", "Battle.SUFFERING_PERFECT_RUIN", "scripts/battle.gd", "_resolve_special", "var su_rate := SUFFERING_PERFECT_RUIN if is_perfect else SUFFERING_RUIN"],
	["card:Transference:desc", "2 more", "2", "Battle.TRANSFERENCE_BONUS", "scripts/battle.gd", "_resolve_special", "var tf_bonus := TRANSFERENCE_BONUS"],
	["card:Breaking Darkness:desc", "for 3 turns", "3", "Battle.BREAKING_DARKNESS_TURNS", "scripts/battle.gd", "_resolve_special", "var an_turns := BREAKING_DARKNESS_PERFECT_TURNS if is_perfect else BREAKING_DARKNESS_TURNS"],
	["card:Breaking Darkness:perfect", "Holds 4 turns", "4", "Battle.BREAKING_DARKNESS_PERFECT_TURNS", "scripts/battle.gd", "_resolve_special", "var an_turns := BREAKING_DARKNESS_PERFECT_TURNS if is_perfect else BREAKING_DARKNESS_TURNS"],
	["card:Requiem:desc", "healed 2%", "2%", "Battle.REQUIEM_HEAL_PCT*100", "scripts/battle.gd", "_resolve_special", "var rq_share := maxi(int(round(attacker.max_hp * REQUIEM_HEAL_PCT"],
	["card:Requiem:perfect", "{atk:10}", "10", "Battle.REQUIEM_PERFECT_PER_STACK*100", "scripts/battle.gd", "_resolve_special", "var rq_per := REQUIEM_PERFECT_PER_STACK if is_perfect else REQUIEM_PER_STACK"],
	["card:Penance:desc", "for 4 turns", "4", "Battle.PENANCE_TURNS", "scripts/battle.gd", "_resolve_special", "var pn_turns := PENANCE_TURNS"],
	["engine:bloodrage", "Half the highest", "half", "Unit.FRENZY_FLOOR_KEEP", "scripts/unit.gd", "frenzy_bonus", "var keep: float = [FRENZY_FLOOR_KEEP, 0.85, 1.0][clampi(scar_tissue_ranks, 0, 2)]"],
	["engine:conviction", "{mhp:15|ally}", "15", "Battle.FAITH_RELEASE_HEAL * 100", "scripts/battle.gd", "_gain_faith", "var f_heal := maxi(int(round(u.max_hp * (FAITH_RELEASE_HEAL + 0.01 * (devout.faithful_step"],
	["engine:conviction", "{res:3}", "3", "Battle.FAITH_RELEASE_MANA * 100", "scripts/battle.gd", "_gain_faith", "var d_mana := maxi(int(round(devout.max_resource * FAITH_RELEASE_MANA)), 1)"],
	# BATCH IU §4 — the swap is priced in `_swap_choice`, the one builder the picker and the bot share.
	["src:scripts/battle.gd:_show_actions", "(%d %s,", "", "[SUMMON_SWAP_COST,", "scripts/battle.gd", "_swap_choice", "\"cooldown\": 0, \"cost\": SUMMON_SWAP_COST, \"special\": \"summon\", \"delay\": SUMMON_SWAP_DELAY,"],
	["src:scripts/battle.gd:_show_actions", "%.1f int,", "", "u.resource_name, SUMMON_SWAP_DELAY,", "scripts/battle.gd", "_swap_choice", "\"cooldown\": 0, \"cost\": SUMMON_SWAP_COST, \"special\": \"summon\", \"delay\": SUMMON_SWAP_DELAY,"],
	["src:scripts/battle.gd:_ability_popup_button", "(Requires at least %d Resonance)\" % ARCANE_BOLT_MIN_STACKS", "", "ARCANE_BOLT_MIN_STACKS", "scripts/battle.gd", "_ability_usable", "if ab.display_name == \"Arcane Bolt\" and u.second_resource < ARCANE_BOLT_MIN_STACKS:"],
	["src:scripts/battle.gd:_ability_popup_button", "(Requires at least %d Resonance)\" % ARCANE_BOLT_MIN_STACKS", "", "ARCANE_BOLT_MIN_STACKS", "scripts/battle.gd", "_ability_usable", "if ab.display_name == \"Arcane Bolt\" and u.second_resource < ARCANE_BOLT_MIN_STACKS:"],
	["src:scripts/battle.gd:_refresh_faith_chip", "int(round(FAITH_RELEASE_HEAL * 100)) + devout.faithful_step", "", "FAITH_RELEASE_HEAL", "scripts/battle.gd", "_gain_faith", "var f_heal := maxi(int(round(u.max_hp * (FAITH_RELEASE_HEAL + 0.01 * (devout.faithful_step"],
	["src:scripts/battle.gd:_resolve_special", "%d turns. Blood", "", "[BERSERK_RISK_PCT, BERSERK_RISK_TURNS]", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"berserk_risk\", BERSERK_RISK_TURNS, BERSERK_RISK_PCT)"],
	["src:scripts/battle.gd:_resolve_special", "reaches instead of half", "half", "Unit.FRENZY_FLOOR_KEEP", "scripts/unit.gd", "frenzy_bonus", "var keep: float = [FRENZY_FLOOR_KEEP, 0.85, 1.0][clampi(scar_tissue_ranks, 0, 2)]"],
	["src:scripts/battle.gd:_resolve_special", "for every %d%%", "", "int(SPITE_STEP_PCT)", "scripts/battle.gd", "_resolve", "/ float(strike_target.max_hp)) * 100.0 / SPITE_STEP_PCT)"],
	["src:scripts/battle.gd:_resolve_special", "sheds a tenth", "a tenth", "Battle.FORTIFIED_SPIRIT_STEP_PCT", "scripts/battle.gd", "_resolve_special", "var fs_step := maxi(int(round(attacker.max_hp * FORTIFIED_SPIRIT_STEP_PCT)), 1)"],
	["src:scripts/battle.gd:_stamp_deadfall_chip", "Stunned %d turn%s", "", "TRAP_STUN_TURNS, \"\" if TRAP_STUN_TURNS == 1 else \"s\"]", "scripts/battle.gd", "_spring_trap", "_apply_status(victim, \"stunned\", TRAP_STUN_TURNS, 0, 0, placer, force_stun)"],
	["status:chilled", "4 stacks FREEZE", "4", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["status:blind", "50% more likely", "50%", "Battle.BLIND_MISS_PCT * 100", "scripts/battle.gd", "_miss_chance", "+ (BLIND_MISS_PCT if attacker.has_status(\"blind\") else 0.0)"],
	["status:snared", "for 1 turn", "1", "Battle.TRAP_STUN_TURNS", "scripts/battle.gd", "_spring_trap", "_apply_status(victim, \"stunned\", TRAP_STUN_TURNS, 0, 0, placer, force_stun)"],
	["status:null_field", "by 5% per", "5%", "Battle.NULL_FIELD_PCT_PER_STACK * 100", "scripts/battle.gd", "_resolve", "var nf_cut := minf(NULL_FIELD_PCT_PER_STACK * strike_target.second_resource, 0.95)"],
	["status:vow", "half\\nthe damage", "half", "1.0 / Unit.VOW_OF_SUFFERING_SHARE", "scripts/unit.gd", "take_hit", "var share: int = int(vow_cb.call(self, amount / VOW_OF_SUFFERING_SHARE))"],
	["status:vow", "hero 1 Faith", "1", "Battle.VOW_OF_SUFFERING_FAITH", "scripts/battle.gd", "_on_vow_share", "_gain_faith(ally, VOW_OF_SUFFERING_FAITH, \"vow\")"],
	["status:rite_return", "Holy 30%", "30%", "Battle.RITE_OF_RETURN_TOLL_PCT * 100", "scripts/battle.gd", "_on_rite_return", "var toll := maxi(int(round(cleric.max_hp * RITE_OF_RETURN_TOLL_PCT)), 1)"],
	["status:rite_return", "to 50% health", "50%", "Battle.RITE_OF_RETURN_RESTORE_PCT * 100", "scripts/battle.gd", "_on_rite_return", "saved.hp = maxi(int(saved.max_hp * RITE_OF_RETURN_RESTORE_PCT), 1)"],
	["status:quarry", "is DOUBLED", "doubled", "Battle.QUARRYS_MARK_FOCUS_MULT", "scripts/battle.gd", "_sharpshooter_focus", "gain *= QUARRYS_MARK_FOCUS_MULT"],
	["status:crossfire", "2 other enemies", "2", "Battle.CROSSFIRE_SPLASH_TARGETS", "scripts/battle.gd", "_crossfire_splash", "while picks.size() < CROSSFIRE_SPLASH_TARGETS and not pool.is_empty():"],
	["status:unslaked", "of half of it", "half", "Unit.FRENZY_FLOOR_KEEP", "scripts/unit.gd", "frenzy_bonus", "var keep: float = [FRENZY_FLOOR_KEEP, 0.85, 1.0][clampi(scar_tissue_ranks, 0, 2)]"],
	["status:mana_well", "is DOUBLED", "doubled", "Battle.MANA_WELL_REGEN_MULT", "scripts/battle.gd", "_mana_regen", "regen *= MANA_WELL_REGEN_MULT"],
	["status:unburdened", "takes 20%", "20%", "Battle.UNBURDEN_CUT * 100", "scripts/battle.gd", "_resolve", "raw *= 1.0 - UNBURDEN_CUT"],
	["src:scripts/unit.gd:_chilled_desc", "at %d stacks", "", "CHILLED_FREEZE_STACKS]", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["rune:deep_cold", "cap at four", "four", "Unit.CHILLED_FREEZE_STACKS", "scripts/unit.gd", "add_status", "s.stacks = mini(int(s.stacks), CHILLED_FREEZE_STACKS)"],
	["card:Powershot:desc", "+2% damage", "2%", "Battle.POWERSHOT_PCT_PER_POINT", "scripts/battle.gd", "_resolve", "var ps_step := POWERSHOT_PCT_PER_POINT + attacker.opp_aim_step"],
	["card:Snare Trap:desc", "Poisoned for 4", "4", "Battle.SNARE_TRAP_POISON_TURNS", "scripts/battle.gd", "_run_battle", "_apply_poison(heroes[sn_idx], u, SNARE_TRAP_POISON_TURNS)"],
	["card:Snare Trap:desc", "for 1 turn", "1", "Battle.TRAP_STUN_TURNS", "scripts/battle.gd", "_spring_trap", "_apply_status(victim, \"stunned\", TRAP_STUN_TURNS, 0, 0, placer, force_stun)"],
	["card:Field Dressing:desc", "18% of", "18%", "Battle.FIELD_DRESSING_PCT*100", "scripts/battle.gd", "_resolve_special", "var fd_pct := FIELD_DRESSING_PERFECT_PCT if is_perfect else FIELD_DRESSING_PCT"],
	["card:Field Dressing:perfect", "{mhp:24}", "24", "Battle.FIELD_DRESSING_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var fd_pct := FIELD_DRESSING_PERFECT_PCT if is_perfect else FIELD_DRESSING_PCT"],
	["card:Camouflage:desc", "for 3 turns", "3", "Battle.CAMOUFLAGE_TURNS", "scripts/battle.gd", "_resolve_special", "var cm_turns := CAMOUFLAGE_TURNS"],
	["card:Bola:desc", "for 4\\nturns", "4", "Battle.BOLA_TURNS", "scripts/battle.gd", "_resolve_special", "var bl_turns := BOLA_TURNS"],
	["card:Hunter's Mark:desc", "for 6 turns", "6", "Battle.HUNTERS_MARK_TURNS", "scripts/battle.gd", "_resolve_special", "var hm_turns := HUNTERS_MARK_TURNS"],
	["card:Arcane Arrows:desc", "six arrows", "six", "Battle.ARCANE_ARROW_CHARGES", "scripts/battle.gd", "_resolve_special", "var aa_n: int = maxi(ARCANE_ARROW_CHARGES,"],
	["card:Twin Hunt:perfect", "{atk:55}", "55", "Battle.TWIN_HUNT_COMPANION_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var th_pct := TWIN_HUNT_COMPANION_PERFECT_PCT if is_perfect else TWIN_HUNT_COMPANION_PCT"],
	["card:Bloodbond:desc", "a QUARTER", "a quarter", "Battle.BLOODBOND_PCT / 100.0", "scripts/battle.gd", "_resolve_special", "var bb_pct := BLOODBOND_PCT"],
	["card:Savage Sweep:desc", "the THREE", "three", "Battle.SAVAGE_SWEEP_TARGETS", "scripts/battle.gd", "_resolve_special", "while ss_marks.size() < SAVAGE_SWEEP_TARGETS and not ss_pool.is_empty():"],
	["card:Savage Sweep:desc", "3 Loyalty", "3", "Battle.SAVAGE_SWEEP_LOYALTY", "scripts/battle.gd", "_resolve_special", "var ss_gain := SAVAGE_SWEEP_PERFECT_LOYALTY if is_perfect else SAVAGE_SWEEP_LOYALTY"],
	["card:Savage Sweep:perfect", "5 Loyalty", "5", "Battle.SAVAGE_SWEEP_PERFECT_LOYALTY", "scripts/battle.gd", "_resolve_special", "var ss_gain := SAVAGE_SWEEP_PERFECT_LOYALTY if is_perfect else SAVAGE_SWEEP_LOYALTY"],
	["card:Ghostpack:desc", "for 4 turns", "4", "Battle.GHOSTPACK_TURNS", "scripts/battle.gd", "_resolve_special", "var gp_turns := GHOSTPACK_TURNS"],
	["card:Last Howl:desc", "+3% strike", "3%", "Battle.LAST_HOWL_PCT_PER_STACK", "scripts/battle.gd", "_resolve_special", "attacker.last_howl = LAST_HOWL_PCT_PER_STACK"],
	["card:Succession:desc", "For 6 turns", "6", "Battle.SUCCESSION_TURNS", "scripts/battle.gd", "_resolve_special", "var sc_turns := SUCCESSION_TURNS"],
	["card:Unleash:desc", "20% of", "20%", "Battle.UNLEASH_PCT_PER_STACK*100", "scripts/battle.gd", "_resolve_special", "var ul_pct := UNLEASH_PERFECT_PCT_PER_STACK if is_perfect else UNLEASH_PCT_PER_STACK"],
	["card:Unleash:perfect", "{atk:25}", "25", "Battle.UNLEASH_PERFECT_PCT_PER_STACK*100", "scripts/battle.gd", "_resolve_special", "var ul_pct := UNLEASH_PERFECT_PCT_PER_STACK if is_perfect else UNLEASH_PCT_PER_STACK"],
	["card:Bring It Down:desc", "for 4 turns", "4", "Battle.BRING_IT_DOWN_TURNS", "scripts/battle.gd", "_resolve_special", "var bid_turns := BRING_IT_DOWN_TURNS"],
	["card:Quarry's Mark:desc", "DOUBLED", "doubled", "Battle.QUARRYS_MARK_FOCUS_MULT", "scripts/battle.gd", "_sharpshooter_focus", "gain *= QUARRYS_MARK_FOCUS_MULT"],
	["card:Crossfire:desc", "2 other", "2", "Battle.CROSSFIRE_SPLASH_TARGETS", "scripts/battle.gd", "_crossfire_splash", "while picks.size() < CROSSFIRE_SPLASH_TARGETS and not pool.is_empty():"],
	["card:Crossfire:desc", "for 3 turns", "3", "Battle.CROSSFIRE_TURNS", "scripts/battle.gd", "_resolve", "var cf_turns := CROSSFIRE_PERFECT_TURNS if is_perfect else CROSSFIRE_TURNS"],
	["card:Crossfire:perfect", "4th turn", "4", "Battle.CROSSFIRE_PERFECT_TURNS", "scripts/battle.gd", "_resolve", "var cf_turns := CROSSFIRE_PERFECT_TURNS if is_perfect else CROSSFIRE_TURNS"],
	["card:Calibrating Shot:desc", "10% of", "10%", "Battle.CALIBRATING_SHOT_PCT*100", "scripts/battle.gd", "_resolve", "var cs_pct := CALIBRATING_SHOT_PERFECT_PCT if is_perfect else CALIBRATING_SHOT_PCT"],
	["card:Calibrating Shot:perfect", "15% of", "15%", "Battle.CALIBRATING_SHOT_PERFECT_PCT*100", "scripts/battle.gd", "_resolve", "var cs_pct := CALIBRATING_SHOT_PERFECT_PCT if is_perfect else CALIBRATING_SHOT_PCT"],
	["card:Fault Line:desc", "For 6 turns", "6", "Battle.FAULT_LINE_TURNS", "scripts/battle.gd", "_resolve_special", "var fl_turns := FAULT_LINE_TURNS"],
	["card:Dug In:desc", "for 4 turns", "4", "Battle.DUG_IN_TURNS", "scripts/battle.gd", "_resolve_special", "var di_turns := DUG_IN_TURNS"],
	["card:Heads Down:desc", "for 3 turns", "3", "Battle.HEADS_DOWN_TURNS", "scripts/battle.gd", "_resolve", "var hd_turns := HEADS_DOWN_PERFECT_TURNS if is_perfect else HEADS_DOWN_TURNS"],
	["card:Heads Down:perfect", "4th turn", "4", "Battle.HEADS_DOWN_PERFECT_TURNS", "scripts/battle.gd", "_resolve", "var hd_turns := HEADS_DOWN_PERFECT_TURNS if is_perfect else HEADS_DOWN_TURNS"],
	["card:Deadfall:desc", "Stunned 1 turn", "1", "Battle.TRAP_STUN_TURNS", "scripts/battle.gd", "_spring_trap", "_apply_status(victim, \"stunned\", TRAP_STUN_TURNS, 0, 0, placer, force_stun)"],
	["card:Choking Smoke:desc", "for 3 turns", "3", "Battle.CHOKING_SMOKE_TURNS", "scripts/battle.gd", "_resolve_special", "var cs_turns := CHOKING_SMOKE_TURNS"],
	["card:Choking Smoke:desc", "50% more", "50%", "Battle.BLIND_MISS_PCT*100", "scripts/battle.gd", "_miss_chance", "+ (BLIND_MISS_PCT if attacker.has_status(\"blind\") else 0.0)"],
	["card:Snare Line:desc", "two turns", "two", "Battle.SNARE_LINE_TURNS", "scripts/battle.gd", "_resolve_special", "var sl_turns := SNARE_LINE_TURNS"],
	["card:Loaded Shot:perfect", "2 turns", "2", "Battle.LOADED_SHOT_PERFECT_POISON_TURNS", "scripts/battle.gd", "_resolve", "_apply_poison(attacker, ls_t, LOADED_SHOT_PERFECT_POISON_TURNS)"],
	["card:Preparation:desc", "15 Mana", "15", "Battle.PREPARATION_MANA", "scripts/battle.gd", "_resolve_special", "var pr_mana := PREPARATION_MANA"],
	["card:Stalking Horse:desc", "for 4 turns", "4", "Battle.STALKING_HORSE_TURNS", "scripts/battle.gd", "_resolve_special", "var sh_turns := STALKING_HORSE_TURNS"],
	["card:Downwind:desc", "For 4 turns", "4", "Battle.DOWNWIND_TURNS", "scripts/battle.gd", "_resolve_special", "var dw_turns := DOWNWIND_TURNS"],
	["card:Cull:desc", "10% of", "10%", "Battle.CULL_PCT*100", "scripts/battle.gd", "_resolve_special", "var cu_pct := CULL_PERFECT_PCT if is_perfect else CULL_PCT"],
	["card:Cull:perfect", "{atk:12}", "12", "Battle.CULL_PERFECT_PCT*100", "scripts/battle.gd", "_resolve_special", "var cu_pct := CULL_PERFECT_PCT if is_perfect else CULL_PCT"],
	["card:Thick Hide:desc", "for 4\\nturns", "4", "Battle.THICK_HIDE_TURNS", "scripts/battle.gd", "_resolve_special", "var th2_turns := THICK_HIDE_TURNS"],
	["card:Salve:desc", "for\\n3 turns", "3", "Battle.SALVE_TURNS", "scripts/battle.gd", "_resolve_special", "var sv_turns := SALVE_PERFECT_TURNS if is_perfect else SALVE_TURNS"],
	["card:Salve:perfect", "4th turn", "4", "Battle.SALVE_PERFECT_TURNS", "scripts/battle.gd", "_resolve_special", "var sv_turns := SALVE_PERFECT_TURNS if is_perfect else SALVE_TURNS"],
	["glossary:extra_turn:long", "after your NEXT turn", "next", "Battle.PREPARATION_DELAY - 1", "scripts/battle.gd", "_resolve_special", "attacker.prep_pending = PREPARATION_DELAY"],
	["glossary:hits_not_casts:long", "banks six charges", "six", "Battle.ARCANE_ARROW_CHARGES", "scripts/battle.gd", "_resolve_special", "var aa_n: int = maxi(ARCANE_ARROW_CHARGES,"],
	["glossary:miss:long", "Blind adds +50%", "50%", "Battle.BLIND_MISS_PCT*100", "scripts/battle.gd", "_miss_chance", "+ (BLIND_MISS_PCT if attacker.has_status(\"blind\") else 0.0)"],
	["glossary:stance_gated:long", "for 3 turns his abilities", "3", "Battle.FEIGNED_GUARD_TURNS", "scripts/battle.gd", "_resolve_special", "var fg_turns := FEIGNED_GUARD_TURNS"],
	["glossary:status_chilled:short", "4 stacks freeze solid", "4", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["glossary:status_chilled:long", "Chill stacks up to 4", "4", "Unit.CHILLED_FREEZE_STACKS", "scripts/unit.gd", "add_status", "s.stacks = mini(int(s.stacks), CHILLED_FREEZE_STACKS)"],
	["glossary:status_chilled:long", "the fourth FREEZES", "fourth", "Unit.CHILLED_FREEZE_STACKS", "scripts/battle.gd", "_apply_status", "if target.status_stacks(\"chilled\") >= BattleUnit.CHILLED_FREEZE_STACKS and not target.has_status(\"frozen\"):"],
	["glossary:status_blind:short", "50% more likely to miss", "50%", "Battle.BLIND_MISS_PCT*100", "scripts/battle.gd", "_miss_chance", "+ (BLIND_MISS_PCT if attacker.has_status(\"blind\") else 0.0)"],
	["glossary:status_blind:long", "miss an extra 50%", "50%", "Battle.BLIND_MISS_PCT*100", "scripts/battle.gd", "_miss_chance", "+ (BLIND_MISS_PCT if attacker.has_status(\"blind\") else 0.0)"],
	["glossary:status_snared:long", "Stunned for a turn", "a turn", "Battle.TRAP_STUN_TURNS", "scripts/battle.gd", "_spring_trap", "_apply_status(victim, \"stunned\", TRAP_STUN_TURNS, 0, 0, placer, force_stun)"],
	["glossary:res_resonance:long", "1 per cast", "1", "Battle.RESONANCE_PER_CAST", "scripts/battle.gd", "_resolve", "+ attacker.singularity_crit_build) if any_crit else RESONANCE_PER_CAST"],
	["glossary:res_faith:long", "a heal of 15%+ max HP", "15%", "Battle.FAITH_RELEASE_HEAL*100", "scripts/battle.gd", "_gain_faith", "var f_heal := maxi(int(round(u.max_hp * (FAITH_RELEASE_HEAL + 0.01 * (devout.faithful_step"],
	["glossary:lent_health:long", "a tenth of his maximum", "a tenth", "Battle.FORTIFIED_SPIRIT_STEP_PCT", "scripts/battle.gd", "_resolve_special", "var fs_step := maxi(int(round(attacker.max_hp * FORTIFIED_SPIRIT_STEP_PCT)), 1)"],
	["glossary:lent_health:long", "by 30% of his", "30%", "Battle.FORTIFIED_SPIRIT_STEPS * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100", "scripts/battle.gd", "_resolve_special", "var fs_steps := FORTIFIED_SPIRIT_PERFECT_STEPS if is_perfect else FORTIFIED_SPIRIT_STEPS"],
	["glossary:frenzy_floor:short", "keeps HALF", "half", "Unit.FRENZY_FLOOR_KEEP", "scripts/unit.gd", "frenzy_bonus", "var keep: float = [FRENZY_FLOOR_KEEP, 0.85, 1.0][clampi(scar_tissue_ranks, 0, 2)]"],
	["glossary:frenzy_floor:long", "FULL bonus for a few turns", "full", "Unit.UNSLAKED_KEEP", "scripts/unit.gd", "frenzy_bonus", "keep = maxf(keep, UNSLAKED_KEEP)"],
	["glossary:recast_refused:long", "Nexus Ward a fifth", "a fifth", "Battle.NEXUS_WARD_PCT", "scripts/battle.gd", "_resolve_special", "var mb_pct := NEXUS_WARD_PCT"],
	["glossary:lent_health:long", "(40% on a perfect cast)", "40%", "Battle.FORTIFIED_SPIRIT_PERFECT_STEPS * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100", "scripts/battle.gd", "_resolve_special", "var fs_steps := FORTIFIED_SPIRIT_PERFECT_STEPS if is_perfect else FORTIFIED_SPIRIT_STEPS"],
]
const WORD_VALUE := {"zero": 0, "one": 1, "once": 1, "a turn": 1, "next": 1, "full": 1, "two": 2, "twice": 2, "doubled": 2, "again": 2, "three": 3, "four": 4, "fourth": 4, "six": 6, "half": 0.5, "a quarter": 0.25, "a tenth": 0.1, "a fifth": 0.2, "half again": 1.5}
# Every constant IT named — the record of the naming pass. Each is declared once and read where a fight decides it.
const NAMED := [
	["scripts/battle.gd", "CRUSHING_BLOW_PERFECT_BD"],
	["scripts/battle.gd", "POMMEL_STRIKE_CRIT"],
	["scripts/battle.gd", "MOCKING_BLOW_EXTRA_TAUNTS"],
	["scripts/battle.gd", "MOCKING_BLOW_TURNS"],
	["scripts/battle.gd", "MOCKING_BLOW_PERFECT_TURNS"],
	["scripts/battle.gd", "NEXUS_WARD_PCT"],
	["scripts/battle.gd", "NEXUS_WARD_TURNS"],
	["scripts/battle.gd", "PERFECT_EXTRA_HITS"],
	["scripts/battle.gd", "MINISTRATION_PCT"],
	["scripts/battle.gd", "MINISTRATION_PERFECT_PCT"],
	["scripts/battle.gd", "UNBURDEN_CUT"],
	["scripts/battle.gd", "UNBURDEN_TURNS"],
	["scripts/battle.gd", "CONSECRATION_TURNS"],
	["scripts/battle.gd", "POWERSHOT_PCT_PER_POINT"],
	["scripts/battle.gd", "TRAP_STUN_TURNS"],
	["scripts/battle.gd", "SNARE_TRAP_POISON_TURNS"],
	["scripts/battle.gd", "BLOOD_OFFERING_PCT"],
	["scripts/battle.gd", "BLOOD_OFFERING_RAGE"],
	["scripts/battle.gd", "BLOOD_OFFERING_HP_FLOOR"],
	["scripts/battle.gd", "GUT_RIP_STEP"],
	["scripts/battle.gd", "GUT_RIP_PERFECT_PCT"],
	["scripts/battle.gd", "RECKLESS_TURNS"],
	["scripts/battle.gd", "BERSERK_RISK_TURNS"],
	["scripts/battle.gd", "UNSLAKED_TURNS"],
	["scripts/battle.gd", "SPITE_TURNS"],
	["scripts/battle.gd", "SPITE_STEP_PCT"],
	["scripts/battle.gd", "PRECISION_AGGRO_HITS"],
	["scripts/battle.gd", "PRECISION_GRANT_TURNS"],
	["scripts/battle.gd", "PRECISION_DEF_HITS"],
	["scripts/battle.gd", "PRECISION_PERFECT_GRANT_TURNS"],
	["scripts/battle.gd", "FEINT_PERFECT_PCT"],
	["scripts/battle.gd", "BATTLE_POISE_TURNS"],
	["scripts/battle.gd", "FEIGNED_GUARD_TURNS"],
	["scripts/battle.gd", "DISCIPLINE_TURNS"],
	["scripts/battle.gd", "ANSWERING_TURNS"],
	["scripts/battle.gd", "FORMLESS_TURNS"],
	["scripts/battle.gd", "COVERING_GUARD_TURNS"],
	["scripts/battle.gd", "EYE_STORM_TURNS"],
	["scripts/battle.gd", "AEGIS_WALL_TURNS"],
	["scripts/battle.gd", "ANVIL_TURNS"],
	["scripts/battle.gd", "RECOMPENSE_TURNS"],
	["scripts/battle.gd", "TURN_THE_BLADE_TURNS"],
	["scripts/battle.gd", "CINDERFALL_TAKE"],
	["scripts/battle.gd", "CINDERFALL_SKIM_MULT"],
	["scripts/battle.gd", "CINDERFALL_PERFECT_TAKE"],
	["scripts/battle.gd", "EMBER_DEBT_TURNS"],
	["scripts/battle.gd", "PYRE_WAKE_PERFECT_PCT"],
	["scripts/battle.gd", "WINTERS_TOLL_PERFECT_PCT"],
	["scripts/battle.gd", "RIMEBINDING_BONUS_STACKS"],
	["scripts/battle.gd", "NULL_FIELD_TURNS"],
	["scripts/battle.gd", "NULL_FIELD_PCT_PER_STACK"],
	["scripts/battle.gd", "KINDLED_MIND_RESONANCE"],
	["scripts/battle.gd", "RESONANCE_PER_CAST"],
	["scripts/battle.gd", "KINDLED_MIND_PERFECT_RESONANCE"],
	["scripts/battle.gd", "ARCANE_BOLT_PERFECT_PCT"],
	["scripts/battle.gd", "ARCANE_BOLT_MIN_STACKS"],
	["scripts/battle.gd", "INNER_ARCANE_LOW_MULT"],
	["scripts/battle.gd", "INNER_ARCANE_LOW_AT"],
	["scripts/battle.gd", "UNMAKING_MIN_STACKS"],
	["scripts/battle.gd", "SECOND_WIND_CAP_PCT"],
	["scripts/battle.gd", "SECOND_WIND_PERFECT_CAP_PCT"],
	["scripts/battle.gd", "RITE_OF_RETURN_TURNS"],
	["scripts/battle.gd", "RITE_OF_RETURN_RESTORE_PCT"],
	["scripts/battle.gd", "RITE_OF_RETURN_TOLL_PCT"],
	["scripts/battle.gd", "RECANT_PCT"],
	["scripts/battle.gd", "SHARED_GRIEF_COST_PCT"],
	["scripts/battle.gd", "SHARED_GRIEF_MERCY"],
	["scripts/battle.gd", "SHARED_GRIEF_HP_FLOOR"],
	["scripts/battle.gd", "REPRISAL_SHARE"],
	["scripts/battle.gd", "REPRISAL_PERFECT_SHARE"],
	["scripts/battle.gd", "DIVINE_PRESENCE_TURNS"],
	["scripts/battle.gd", "ALMS_TURNS"],
	["scripts/battle.gd", "VESPERS_TURNS"],
	["scripts/battle.gd", "VOW_OF_SUFFERING_TURNS"],
	["scripts/battle.gd", "VOW_OF_SUFFERING_FAITH"],
	["scripts/battle.gd", "AEGIS_REVERSAL_MULT"],
	["scripts/battle.gd", "ORDINATION_FAITH"],
	["scripts/battle.gd", "FORTIFIED_SPIRIT_STEPS"],
	["scripts/battle.gd", "FORTIFIED_SPIRIT_PERFECT_STEPS"],
	["scripts/battle.gd", "FORTIFIED_SPIRIT_STEP_PCT"],
	["scripts/battle.gd", "RELIQUARY_PCT"],
	["scripts/battle.gd", "RELIQUARY_PERFECT_PCT"],
	["scripts/battle.gd", "FAITH_RELEASE_HEAL"],
	["scripts/battle.gd", "FAITH_RELEASE_MANA"],
	["scripts/battle.gd", "BLESSING_OF_THE_FAITHFUL_PCT"],
	["scripts/battle.gd", "BLESSING_OF_THE_FAITHFUL_MANA_PCT"],
	["scripts/battle.gd", "BLESSING_OF_THE_FAITHFUL_PERFECT_PCT"],
	["scripts/battle.gd", "BLIGHT_THE_WELL_TURNS"],
	["scripts/battle.gd", "SUFFERING_TURNS"],
	["scripts/battle.gd", "SUFFERING_RUIN"],
	["scripts/battle.gd", "SUFFERING_PERFECT_RUIN"],
	["scripts/battle.gd", "TRANSFERENCE_BONUS"],
	["scripts/battle.gd", "ANOINTING_TURNS"],
	["scripts/battle.gd", "ANOINTING_RUIN"],
	["scripts/battle.gd", "BREAKING_DARKNESS_TURNS"],
	["scripts/battle.gd", "BREAKING_DARKNESS_PERFECT_TURNS"],
	["scripts/battle.gd", "REQUIEM_PERFECT_PER_STACK"],
	["scripts/battle.gd", "REQUIEM_HEAL_PCT"],
	["scripts/battle.gd", "PENANCE_TURNS"],
	["scripts/battle.gd", "TWIN_HUNT_COMPANION_PCT"],
	["scripts/battle.gd", "TWIN_HUNT_COMPANION_PERFECT_PCT"],
	["scripts/battle.gd", "BLOODBOND_PCT"],
	["scripts/battle.gd", "SAVAGE_SWEEP_TARGETS"],
	["scripts/battle.gd", "SAVAGE_SWEEP_LOYALTY"],
	["scripts/battle.gd", "SAVAGE_SWEEP_PERFECT_LOYALTY"],
	["scripts/battle.gd", "GHOSTPACK_TURNS"],
	["scripts/battle.gd", "LAST_HOWL_PCT_PER_STACK"],
	["scripts/battle.gd", "SUCCESSION_TURNS"],
	["scripts/battle.gd", "UNLEASH_PCT_PER_STACK"],
	["scripts/battle.gd", "UNLEASH_PERFECT_PCT_PER_STACK"],
	["scripts/battle.gd", "BRING_IT_DOWN_TURNS"],
	["scripts/battle.gd", "QUARRYS_MARK_FOCUS_MULT"],
	["scripts/battle.gd", "CROSSFIRE_TURNS"],
	["scripts/battle.gd", "CROSSFIRE_PERFECT_TURNS"],
	["scripts/battle.gd", "CROSSFIRE_SPLASH_TARGETS"],
	["scripts/battle.gd", "CALIBRATING_SHOT_PCT"],
	["scripts/battle.gd", "CALIBRATING_SHOT_PERFECT_PCT"],
	["scripts/battle.gd", "FAULT_LINE_TURNS"],
	["scripts/battle.gd", "DUG_IN_TURNS"],
	["scripts/battle.gd", "HEADS_DOWN_TURNS"],
	["scripts/battle.gd", "HEADS_DOWN_PERFECT_TURNS"],
	["scripts/battle.gd", "CHOKING_SMOKE_TURNS"],
	["scripts/battle.gd", "BLIND_MISS_PCT"],
	["scripts/battle.gd", "SNARE_LINE_TURNS"],
	["scripts/battle.gd", "LOADED_SHOT_PERFECT_POISON_TURNS"],
	["scripts/battle.gd", "HUNT_PERFECT_PCT"],
	["scripts/battle.gd", "PREPARATION_DELAY"],
	["scripts/battle.gd", "PREPARATION_MANA"],
	["scripts/battle.gd", "STALKING_HORSE_TURNS"],
	["scripts/battle.gd", "DOWNWIND_TURNS"],
	["scripts/battle.gd", "CULL_PCT"],
	["scripts/battle.gd", "CULL_PERFECT_PCT"],
	["scripts/battle.gd", "THICK_HIDE_TURNS"],
	["scripts/battle.gd", "SALVE_TURNS"],
	["scripts/battle.gd", "SALVE_PERFECT_TURNS"],
	["scripts/battle.gd", "MIRROR_IMAGE_IMAGES"],
	["scripts/battle.gd", "MANA_WELL_TURNS"],
	["scripts/battle.gd", "MANA_WELL_REGEN_MULT"],
	["scripts/battle.gd", "DISPEL_COUNT"],
	["scripts/battle.gd", "BLINK_TURNS"],
	["scripts/battle.gd", "EXHORTATION_PCT"],
	["scripts/battle.gd", "UNDYING_VIGIL_TURNS"],
	["scripts/battle.gd", "FIELD_DRESSING_PCT"],
	["scripts/battle.gd", "FIELD_DRESSING_PERFECT_PCT"],
	["scripts/battle.gd", "CAMOUFLAGE_TURNS"],
	["scripts/battle.gd", "BOLA_TURNS"],
	["scripts/battle.gd", "HUNTERS_MARK_TURNS"],
	["scripts/battle.gd", "BATTLE_TRANCE_TURNS"],
	["scripts/battle.gd", "RALLY_RESOURCE_PCT"],
	["scripts/battle.gd", "WARCRY_TURNS"],
	["scripts/battle.gd", "IRONCLAD_TURNS"],
	["scripts/battle.gd", "SUMMON_SWAP_COST"],
	["scripts/battle.gd", "SUMMON_SWAP_DELAY"],
	["scripts/battle.gd", "DEEP_WINTER_DIVISOR"],
	["scripts/battle.gd", "INNER_ARCANE_BONUS"],
	["scripts/battle.gd", "ARCANE_ECHO_PERFECT_TURNS"],
	["scripts/battle.gd", "UNMAKING_LOCK_PERFECT_TURNS"],
	["scripts/unit.gd", "UNSLAKED_KEEP"],
	["scripts/unit.gd", "FRENZY_FLOOR_KEEP"],
	["scripts/unit.gd", "MERCY_WINDOW_AT"],
	["scripts/unit.gd", "VOW_OF_SUFFERING_SHARE"],
	["scripts/unit.gd", "CHILLED_FREEZE_STACKS"],
	["scripts/unit.gd", "SECOND_WIND_WINDOW_TURNS"],
	["scripts/unit.gd", "REPRISAL_WINDOW_TURNS"],
]


func _s2_the_figures_named() -> void:
	print("
§2 — every figure IT named: the text against its constant, and the code reading it")
	var maps: Array = []
	for p in ["res://scripts/battle.gd", "res://scripts/unit.gd", "res://scripts/classes.gd", "res://scripts/ability.gd"]:
		maps.append((load(p) as Script).get_script_constant_map())
	var name_rx := RegEx.create_from_string("(?:Battle|Unit|Classes|Ability)\\.([A-Z_][A-Z0-9_]*)")
	var digits := RegEx.create_from_string("\\d+(?:\\.\\d+)?")
	var read := 0
	var bad: Array = []
	for r in FIGURES:
		var holder := String(r[0])
		var text: Variant = Gate.holder_text(holder, _cache)
		if text == null or String(text) == "":
			bad.append("%s names no text a surface reads" % holder)
			continue
		var src_row := holder.begins_with("src:")
		var needle := String(r[1]) if src_row else _flat(String(r[1]).replace("\\n", "\n"))
		if Gate.count_whole(String(text) if src_row else _flat(String(text)), needle) < 1:
			bad.append("%s no longer says '%s'" % [holder, r[1]])
			continue
		var code := String(r[6])
		var n := Gate.count_whole(Gate.fn_body(String(r[4]), String(r[5]), _cache), code)
		if n != 1:
			bad.append("%s's figure is decided by '%s' in %s::%s, which stands %d times" % [holder, code, r[4], r[5], n])
			continue
		var fig := String(r[2])
		var door := String(r[3])
		if fig == "":
			if not String(text).contains(door):
				bad.append("%s's format no longer hands it the constant ('%s')" % [holder, door])
				continue
		else:
			var reads_it := false
			for m in name_rx.search_all(door):
				if code.contains(m.get_string(1)):
					reads_it = true
			if not reads_it:
				bad.append("%s's deciding line '%s' does not read its door %s" % [holder, code, door])
				continue
			var v = Gate.eval_door(door, ["Battle", "Unit", "Classes", "Ability"], maps)
			var want := 0.0
			var dm := digits.search(fig)
			var dec := 0
			if dm != null:
				want = float(dm.get_string())
				dec = dm.get_string().split(".")[1].length() if dm.get_string().contains(".") else 0
			elif WORD_VALUE.has(fig.to_lower()):
				want = float(WORD_VALUE[fig.to_lower()])
				dec = 2
			else:
				bad.append("%s's figure '%s' is neither a number nor a word this gate reads" % [holder, fig])
				continue
			var scale := pow(10.0, dec)
			if v == null or roundf(absf(float(v)) * scale + 0.000001) != roundf(want * scale):
				bad.append("%s says %s ('%s'); its constant %s reads %s" % [holder, fig, r[1], door, str(v)])
				continue
		read += 1
	for b in bad:
		ok(false, "§2: " + String(b))
	ok(read >= 181 and bad.is_empty(), "§2: %d of %d figures read against their constants" % [read, FIGURES.size()])
	print("    CHECKED %d figures: each text's figure its constant's, each deciding line reading it" % read)
	# §2b — every constant IT named is declared once and read where a fight decides it.
	var fight := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")) + "\n" \
		+ Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var unread: Array = []
	for r in NAMED:
		var decl := RegEx.create_from_string("(?m)^const " + String(r[1]) + "\\b").search_all(fight).size()
		var uses := RegEx.create_from_string("\\b" + String(r[1]) + "\\b").search_all(fight).size()
		if decl != 1 or uses < 2:
			unread.append("%s (declared %d, named %d times)" % [r[1], decl, uses])
	ok(NAMED.size() == 164 and unread.is_empty(),
		"§2b: of the %d constants IT named, %d are not declared once and read — %s" % [NAMED.size(), unread.size(), str(unread.slice(0, 5))])
	print("    CHECKED %d constants IT named: each declared once and read" % NAMED.size())
	# §2c — A DECLARATION NAMES WHAT ITS FIGURE IS, NEVER THE FIGURE. IT first wrote 162 of its 164 declarations with a
	# comment carrying the figure (`:= 4  # Mocking Blow: 4 turns`) — a second copy one column from the first, which R01's
	# re-tune would have left stale on every one. The comment names the card and the role; the declaration holds the figure.
	# This arm reads the value's own forms (the number, its percentage, WORD_VALUE's words), so it caught 109 of the 162: a
	# comment stating a DERIVED figure (a Perfect's 23% off a 0.20) or another unit's (a quarter off a 25) passes it.
	var raw := {}
	for p in ["scripts/battle.gd", "scripts/unit.gd"]:
		raw[p] = FileAccess.get_file_as_string("res://" + p)
	var commented := 0
	var undeclared: Array = []
	var restated: Array = []
	for r in NAMED:
		var dm := RegEx.create_from_string("(?m)^const " + String(r[1]) + "\\b[^\\n]*$").search(String(raw.get(String(r[0]), "")))
		if dm == null:
			undeclared.append(String(r[1]))
			continue
		var line := dm.get_string()
		var hash_at := line.find("#")
		if hash_at < 0:
			continue
		commented += 1
		var note := line.substr(hash_at + 1)
		for form in _figure_forms(_named_value(String(r[1]), maps)):
			if _states(note, String(form)):
				restated.append("%s %s" % [r[1], line.substr(hash_at).strip_edges()])
				break
	ok(undeclared.is_empty(), "§2c: %d of the constants IT named have no declaration line to read — %s" % [undeclared.size(), str(undeclared.slice(0, 5))])
	ok(commented >= 160 and restated.is_empty(),
		"§2c: %d declaration comments restate their own constant's figure (of %d read) — %s" % [restated.size(), commented, str(restated.slice(0, 4))])
	print("    CHECKED %d declarations' comments: none restates its constant's figure" % commented)


# The value a constant IT named holds, off the script that declares it.
func _named_value(name: String, maps: Array) -> Variant:
	for m in maps:
		if (m as Dictionary).has(name):
			return m[name]
	return null


# Every way a comment could state a figure: the number as written, as a percentage, and the words WORD_VALUE reads.
func _figure_forms(v: Variant) -> Array:
	var out: Array = []
	if v == null or not (v is int or v is float):
		return out
	var f := float(v)
	out.append(str(int(roundf(f))) if is_equal_approx(f, roundf(f)) else String.num(f))
	if absf(f) < 1.0 and not is_zero_approx(f):
		out.append(String.num(snappedf(f * 100.0, 0.01)) + "%")
	elif f > 1.0 and f <= 100.0 and is_equal_approx(f, roundf(f)):
		out.append(str(int(roundf(f))) + "%")
	for w in WORD_VALUE:
		if is_equal_approx(float(WORD_VALUE[w]), f):
			out.append(String(w))
	return out


# A comment states a figure when the form stands whole: a number not inside a longer one, a word not inside a longer word.
func _states(note: String, form: String) -> bool:
	if form == "":
		return false
	var esc := form.replace(".", "\\.")
	var rx := ("(?i)\\b" + esc + "\\b") if form[0].is_valid_identifier() else ("(?<![\\w.])" + esc + "(?![\\d]|\\.\\d)")
	return RegEx.create_from_string(rx).search(note) != null


# ── §3 — THE POSITIONAL FAMILY ──────────────────────────────────────────────

const CENSUS := "docs/reports/IT-positional-census.tsv"


func _s3_the_positional_family() -> void:
	print("
§3 — the positional family: the census of record, and the window helpers")
	var lines := _doc(CENSUS).split("
", false)
	ok(lines.size() > 1, "§3: the census of record is not in the tree")
	if lines.size() < 2:
		return
	var head := lines[0].split("	")
	var col := {}
	for i in head.size():
		col[String(head[i])] = i
	for c in ["target", "section", "shape", "verdict", "tree", "it_disposition"]:
		ok(col.has(c), "§3: the census has no '%s' column" % c)
	var tally := {}
	var repaired := {}
	var bad: Array = []
	for k in range(1, lines.size()):
		var f := lines[k].split("	")
		if f.size() != head.size():
			bad.append("row %d has %d fields" % [k, f.size()])
			continue
		var verdict := String(f[col["verdict"]])
		var disp := String(f[col["it_disposition"]])
		if String(f[col["tree"]]).strip_edges() == "":
			bad.append("row %d does not say which tree it read" % k)
		var miss := verdict.begins_with("MISS")
		if miss and not (disp in ["REPAIRED", "REPAIRED (IS named it)", "REPORTED"]):
			bad.append("row %d is a MISS with no disposition" % k)
		if not miss and disp != "—":
			bad.append("row %d asks its question and still carries '%s'" % [k, disp])
		tally[disp] = int(tally.get(disp, 0)) + 1
		if disp.begins_with("REPAIRED"):
			var t := String(f[col["target"]])
			repaired[t if t.ends_with(".gd") else t + ".gd"] = true
	for b in bad:
		ok(false, "§3: " + String(b))
	ok(lines.size() - 1 == 489 and int(tally.get("REPAIRED", 0)) == 53 and int(tally.get("REPAIRED (IS named it)", 0)) == 5
		and int(tally.get("REPORTED", 0)) == 20,
		"§3: the census reads %d rows and %s — IT kept 489, 53 windows and IS's five repaired, 20 picks reported" % [lines.size() - 1, str(tally)])
	var silent: Array = []
	for t in repaired:
		if not FileAccess.get_file_as_string("res://" + String(t)).contains("IT §3b"):
			silent.append(t)
	ok(repaired.size() >= 30 and silent.is_empty(), "§3: %d repaired targets, and these do not say so in their source: %s" % [repaired.size(), str(silent)])
	print("    CHECKED %d census rows: %s; %d repaired targets say so" % [lines.size() - 1, str(tally), repaired.size()])
	# §3b — the helpers, on input whose answer is known, both ways.
	var src := "func a():
	x = 1
	if x:
		y = 2

func b():
	z = 3
"
	var at := src.find("func a")
	var blk := Gate.block(src, at)
	ok(blk.begins_with("func a") and blk.contains("y = 2") and not blk.contains("func b"),
		"§3b: `block` does not cut a function at its own end ('%s')" % blk.c_escape())
	var fixed := src.substr(at, 40)
	ok(fixed.contains("func b") and Gate.ends_inside(blk, "
func ") and not Gate.ends_inside(fixed, "
func "),
		"§3b: a fixed window that runs past its subject is not told apart from one cut by it")
	ok(Gate.subject(src, at, "
func ") == src.substr(at, src.find("
func b") - at) and Gate.subject(src, at, "
nowhere") == "",
		"§3b: `subject` does not end at its named end, or reads past a missing one")
	ok(Gate.within(src, src.find("	if x:"), "	if x:
		y = 2") and not Gate.within(src, src.find("	if x:"), "	if x:
		y = 2

func b"),
		"§3b: `within` does not tell a window inside its block from one past it")
	var com := "var a := 1
# one
# two
var x := 2
"
	var above := Gate.comment_above(com, com.find("var x"))
	ok(above == "# one
# two
" and Gate.is_comment(above) and not Gate.is_comment("# one
var a := 1
"),
		"§3b: `comment_above` does not read the comment lines directly above a line, and only those ('%s')" % above.c_escape())


# ── §5 — THE INDEX's STAMPS ─────────────────────────────────────────────────

const FENCE_OPEN := "<!-- INDEX:BEGIN ("
const FENCE_CLOSE := "<!-- INDEX:END -->"


# A block's stamp: the first six hex of the md5 of its text, whitespace runs collapsed to one space.
func _stamp(text: String) -> String:
	return RegEx.create_from_string("[ \t\r\n]+").sub(text, " ", true).strip_edges().md5_text().substr(0, 6)


func _s5_the_index_stamps() -> void:
	print("
§5 — the index's stamps: every row carries the stamp of the block it names")
	var st := _doc("docs/state.md")
	var a := st.find(FENCE_OPEN)
	var b := st.find(FENCE_CLOSE)
	ok(a >= 0 and b > a and st.count(FENCE_OPEN) == 1, "§5: docs/state.md's index is not fenced once")
	if a < 0 or b <= a:
		return
	var fenced := st.substr(a, b - a)
	ok(fenced.count("A BATCH THAT AMENDS A BLOCK AMENDS ITS INDEX ROW IN THE SAME BATCH") == 1,
		"§5: the maintenance rule does not stand once inside the index's fence")
	# The blocks below the fence, by heading.
	var blocks := {}
	var cur := ""
	var buf: Array = []
	for line in st.substr(st.find("
", b) + 1).split("
"):
		if line.begins_with("## ") or line.begins_with("### "):
			if cur != "":
				blocks[cur] = "
".join(PackedStringArray(buf))
			var h := String(line).strip_edges()
			var dash := h.find(" — ")
			cur = (h.substr(0, dash) if dash > 0 else h).strip_edges()
			buf = [line]
		elif cur != "":
			buf.append(line)
	if cur != "":
		blocks[cur] = "
".join(PackedStringArray(buf))
	var rows := 0
	var bad: Array = []
	for line in fenced.split("
"):
		var key := Gate.index_entry_key(String(line))
		if key == "":
			continue
		rows += 1
		var close := String(line).find(" ``", String(line).find("`` #") + 3)
		var tail := String(line).substr(close + 3)
		if not tail.begins_with(" `#") or tail.substr(9, 1) != "`":
			bad.append("%s carries no stamp" % key)
		elif not blocks.has(key):
			bad.append("%s names no block" % key)
		elif tail.substr(3, 6) != _stamp(String(blocks[key])):
			bad.append("%s's block changed and its row was not (stamp %s, block %s)" % [key, tail.substr(3, 6), _stamp(String(blocks[key]))])
	for x in bad:
		ok(false, "§5: " + String(x))
	ok(rows >= 130 and bad.is_empty(), "§5: %d rows read, %d stale or unstamped" % [rows, bad.size()])
	# The stamp tells a change apart and lets a re-wrap through, on input whose answer is known.
	ok(_stamp("## X
abc def") != _stamp("## X
abc deg") and _stamp("## X
abc def") == _stamp("## X
  abc
 def  "),
		"§5: the stamp does not tell a changed block apart, or reads a re-wrap as a change")
	print("    CHECKED %d rows against %d blocks; %d stale or unstamped" % [rows, blocks.size(), bad.size()])
