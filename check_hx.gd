# BATCH HX — THE CHECKS A REFERENCE IS HELD BY, AND THE BIGGER FILE.
#
#   §1a RESIDENCY, BOTH WAYS, FOR EACH INDEX — every block of a reference has
#       its row in `CLAUDE.md`, and every row names exactly one block. DERIVED
#       FROM THE FILES: the rows are parsed out of the two tables and the blocks
#       out of the two references, so a block written into a reference without
#       its row, or a row whose block was deleted, reds with no list to keep.
#   §1b NO RULE TEXT STANDS IN TWO RULE FILES, CASE SET ASIDE — a run of twelve
#       words shared by any two of the four rule files, and a rule statement (a
#       heading or a bold lead) standing as a statement in a second file.
#   §1c A REFERENCE'S SUBJECT IS NOT WRITTEN BACK INTO `CLAUDE.md` — the file's
#       blocks are a KNOWN population, so a new block reds until its author has
#       said which file it belongs in, and a known block that is gone is a
#       notice; the two written back after the seam moved to the reference at
#       HY §4, by ruling (`WRITTEN_BACK` names any that are left).
#   §1d THE REFERENCES' NAMES RESOLVE — every backticked file, function,
#       constant and identifier in the two references is found in the tree;
#       (a) and found OUTSIDE an instrument's needle, or named here with what the
#       sentence does with it; (b) a constant's value written beside its name is
#       the value the script declares.
#   §2  THE STATE ARCHIVE — `docs/state.md` names it in its own header, a reader
#       reaches it through that name, and no section stands in both halves.
#   §3  THE TWO RULES EVERY BRIEF WROTE BY HAND STAND IN THE INSTRUMENT RULES,
#       each with its row, and neither is written into `CLAUDE.md`.
#   §5  THE RULINGS, WHERE A FUTURE SESSION READS THEM.
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# HV §3e re-read both references from the commit that made each to HEAD and
# found the same thing twice: a split HELD ON SUBSTANCE and ROTTED AT ITS SEAM —
# an index row missing (GW §2's), a rule standing in both files (the autoload
# rule), seven kilobytes of instrument rules written back into `CLAUDE.md` after
# the seam was taken, unindexed. **Opening the file protected neither. A
# mechanical check is what protected both**, and nothing mechanical held either
# seam: `check_ff` §4 and §5 hold the COMBAT index's structure and nothing else.
#
# ── WHAT THIS GATE CANNOT DO, SAID FIRST ────────────────────────────────────
# **A RULE'S SUBJECT IS NOT A STRING.** §1c does not decide whether a block is
# an instrument rule: HX measured two lexical classifiers and both failed — the
# instrument file's vocabulary scores a game rule (a retired piece of content is
# kept) as high as a supersession rule, and the seam sentence's own nouns
# (*gate*, *sweep*, *control*) are game words too while half the instrument
# file's blocks name none of them. **What a gate CAN hold is the moment a block
# is written**: the population is known, so the batch that writes a new block
# meets this gate and says which file it binds. A rule written into an
# EXISTING block as a bullet is not seen — the named limit.
#
# **AND §1d IS THE MECHANICAL HALF OF A CLAIMS SWEEP, NOT THE SWEEP.** A name
# that resolves can still sit in a false sentence (*`check_es` is the only gate
# that reads it*). HX's census sized both populations (`docs/reports/HX.md` §1d);
# the claims a gate can read beyond a name are read where they are cheap.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hx.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

# The two indexes open on their own words (`check_ff` reads the same two).
const INDEX_OPEN := "**WHAT IS OVER THERE**"
const COMBAT_INDEX_OPEN := "**WHAT IS IN THE COMBAT RULES**"

# §1b — THE SHARED RUNS STANDING TODAY, NAMED AND LEFT. Each is the pair of files
# and the run's opening words as §1b prints them. A run not on this list reds; a
# run on it that has gone is a notice (delete the line).
const KNOWN_SHARED := [
	"CLAUDE.md ~ instrument-rules.md: the rules about how a fight resolves and",  # seam prose: both sides say where combat law went (GR §2)
	"CLAUDE.md ~ instrument-rules.md: the seam is what a rule binds not",  # the seam rule, stated by both sides of it since EF §2
	"CLAUDE.md ~ instrument-rules.md: the fix is never the exemption an exemption",  # RULE TEXT IN TWO FILES: EV §5's mirror (DT), also in CLAUDE.md's DR §2 traps
	"CLAUDE.md ~ instrument-rules.md: before writing a comment that names a banned",  # RULE TEXT IN TWO FILES: the same passage
	"CLAUDE.md ~ instrument-rules.md: a sim that read the player's ledger would",  # RULE TEXT IN TWO FILES: RunSim calls Profile nowhere (the talent handoff and the sim bullet)
	"CLAUDE.md ~ combat-rules.md: the crit roll a multi hit's charges the",  # seam prose: the combat pointer's scope, stated by both sides (GR §2)
	"CLAUDE.md ~ combat-rules.md: the damage door and the attribution frame the",  # seam prose: the same scope
	"CLAUDE.md ~ combat-rules.md: multi hit's charges the collections a loop walks",  # seam prose: the same scope
	"CLAUDE.md ~ combat-rules.md: that is also about a card a rune",  # the tiebreak, stated by both sides of the subject seam
	"instrument-rules.md ~ combat-rules.md: rules the file a batch is required to",  # each reference's own opening, of itself
	"instrument-rules.md ~ combat-rules.md: a rule that belongs to two subjects stays",  # the tiebreak, in both references' preambles
	"instrument-rules.md ~ combat-rules.md: when a rule moves back or across the",  # each reference of itself: its pins move with its rules
	"instrument-rules.md ~ combat-rules.md: this file is under the same ceiling procedure",  # each reference of itself: no ceiling stated
]

# §1b — THE RULE STATEMENTS STANDING IN TWO FILES TODAY, NAMED AND LEFT.
const KNOWN_STATEMENTS := [
	"CLAUDE.md ~ instrument-rules.md: never preload a script that names an autoload",  # RULE IN TWO FILES (HV §3e): CT's block here, a trap there
	"CLAUDE.md ~ instrument-rules.md: the seam is what a rule binds, not what it is about",  # the seam rule, stated by both sides of it
	"CLAUDE.md ~ instrument-rules.md: every one of these cost a batch something",  # THE TRAPS' preamble, copied into both halves at EF §2
	"CLAUDE.md ~ ways-of-working.md: how a batch comes to exist",  # the map's pointer at that file, and that file's own opening
	"instrument-rules.md ~ combat-rules.md: when a rule moves back or across, the pin moves with it in the same batch",  # each reference of itself
	"instrument-rules.md ~ combat-rules.md: this file is under the same ceiling procedure as claude.md and has no stated ceiling",  # each reference of itself
]

# §1c — EVERY BLOCK OF `CLAUDE.md`, BY ITS HEADING'S RULE TEXT (the trailing
# provenance parenthesis off, a wrapped heading joined).
const KNOWN_BLOCKS := [
	"WHAT THIS FILE IS, AND WHAT IT IS NOT",
	"THE INSTRUMENT RULES LIVE IN `docs/instrument-rules.md`",
	"THE COMBAT RULES LIVE IN `docs/combat-rules.md`",
	"Working agreement",
	"EVERY BATCH WRITES ITS REPORT INTO THE REPO",
	"THIS FILE IS MEASURED IN KiB, AND THE CEILING IS 510 KiB",
	"Repo weight and the knowledge-base sync",
	"The skill check — FOUR CASES, AND THE BAR IS PARAMETERIC",
	"THE RULE EVERY PROFILE IS AUTHORED TO",
	"WHERE THE CHECK COMES OFF",
	"A DURATION IS STATED AS APPLIED",
	"HERO AND ALLY ARE THE ONLY TWO WORDS",
	"STANDING RULE — THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE, NOT THE ABILITY",
	"THE ALLY/HERO THREAD IS CLOSED (Batch DM §3) — RULE ON CLAUSES, NOT ON ABILITIES",
	"NEVER `preload` A SCRIPT THAT NAMES AN AUTOLOAD",
	"THE POUCH IS SLOT-LIMITED",
	"ITEM EFFECTS ARE PERCENTAGES OR SCALE WITH RUN DEPTH",
	"`hexed` IS NOT `crippled`, AND THE BRIEF ASKED FOR `crippled`",
	"VERIFY THE BRIEF AGAINST THE REPO BEFORE IMPLEMENTING IT",
	"AND A PRECEDENT IS A CLAIM, SO A PRECEDENT GETS CHECKED",
	"THE SHARPSHOOTER'S BASIC IS A SEQUENCE",
	"REMOVING A SKILL CHECK MAKES ITS PERFECT-ONLY BEHAVIOUR UNCONDITIONAL",
	"THE LITERAL-DIGIT RULE IS A BASELINE, NOT A GATE",
	"A PASSIVE PAID IN DAMAGE TAKEN INVERTS AGAINST EVERY BATCH THAT HELPS THE PARTY",
	"FAITH RELEASES AT `FAITH_RELEASE`, AND THE LANE TRADES DEPTH FOR FREQUENCY",
	"A REVERTED CONSTANT MUST BE SWEPT THROUGH THE ABILITY CARD TOO",
	"CARD TEXT AND COMMENTS DO NOT NAME A MAGNITUDE A CONSTANT HOLDS",
	"A PURE BUFF COSTS HALF A SWING",
	"THE ELITE BEING SHORTEST IS ACCEPTED, NOT A DEFECT",
	"A SHIELD TAKES THE CAP; A HEAL DOES NOT",
	"THE LADDER HAS THREE RUNGS AND EVERY ONE IS WRITTEN AGAINST THE ONE ABOVE",
	"THE ENUMERATION IS `Classes.ability_corpus()` AND IT IS THE ONLY ONE",
	"A recast that would not improve is REFUSED",
	"ADDING A NAME TO A TABLE IS NOT A CHANGE UNTIL THE MACHINERY REACHES ITS SHAPE",
	"THE AUTOPLAY HEURISTIC'S REFUSAL LIST IS AN ORACLE FOR PLAYER-DOOR GAPS",
	"THE VAULT'S EXIT IS THE POOLS, AND A VAULT ENTRY IS OWED ONE",
	"ESTABLISH WHY A STRUCTURE IS DEAD BEFORE DELETING IT",
	"THE TRAPS — RULES THAT WERE BURIED IN BATCH BLOCKS",
	"A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS",
	"NAMES THAT LOOK WRONG AND ARE RIGHT — NEVER \"CORRECT\" THEM",
	"Architecture",
	"STANDING RULES — TALENTS ARE META PROGRESSION",
	"STANDING RULE — ONE TALENT TREE, KEYED TO THE CLASS",
	"STANDING RULE — A RELIC SETS UP THE RUN; A TALENT CHANGES WHAT A CLASS DOES IN A FIGHT; ONLY A RUNE KNOWS THE SPEC",
	"STANDING RULE — WHAT MAKES A ROW-8 NODE (Batch BM §2), AND BH'S FIFTEEN POINTS",
	"STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS",
	"THE STARTER RUNG IS A META-PROGRESSION GATE AND MAY NOT BE REMOVED AS A BALANCE CHANGE",
	"STANDING RULE — HELD VALUE AND SPEND FREQUENCY ARE ANTAGONISTIC ON A SINGLE METER",
	"STANDING RULE — THE ENGINE RUNE CHARTER",
	"STANDING RULE — A CORE RUNE IS A DIRECTIONAL FOR ABILITY DRAFTING",
	"STANDING RULE — AN ENGINE RUNE SHOWS ITS ENGINE'S RULE, READ LIVE AT ONE DOOR",
	"STANDING RULE — A CONTROL THE PLAYER NEEDS TO LEAVE NEVER MOVES WITH TEXT",
	"STANDING RULE — A LIST OF CARDS PAGES; IT NEVER SCROLLS",
	"STANDING RULE — A CARD OR A RUNE THAT CANNOT PAY WITHOUT ITS ENGINE SITS OUT WHILE THE ENGINE IS GONE",
	"STANDING RULE — A STATUS IS SPENT WHERE IT PAYS, NEVER WHERE AN ENGINE READS IT",
	"STANDING RULE — TWO AFFLICTIONS MEETING ON ONE BODY MAKE A THIRD",
	"STANDING RULE — EVERY CLASS OPENS WITH A KIT OF THREE, INSIDE THE SLOT COUNT",
	"STANDING RULE — EVERY HUNTER HAS A PET, AND ONLY THE SHARPSHOOTER DISMISSES IT",
	"STANDING RULE — A RULE ENGINE READS A DOOR THE GAME ALREADY HAS",
	"STANDING RULE — A CLASS CORE IS A LEDGER, NOT A PURSE",
	"STANDING DESIGN RULE — THE CONTAGION SPACE IS RESERVED",
	"STANDING REFERENCE — THE DEBUG SURFACES, ALL OF THEM IN ONE TABLE",
	"STANDING REFERENCE — THE UNCAPPED-METER GOVERNOR TABLE",
	"STANDING REFERENCE — THE COMPUTED BLOCK: ONE BUILDER, TWO SCREENS, AND THE THIRD COPY THAT STAYS",
	"STANDING RULE — A TALENT MAY NOT GRANT AN ABILITY, NOR DEPEND ON ONE THE HERO IS NOT GUARANTEED",
	"THE STATUS HALF, ADDED AT DP — AND IT IS THE SAME RULE, NOT A SECOND ONE",
	"STANDING DESIGN RULE — A SPREAD THAT **MOVES** A THRESHOLD METER IS PERPETUAL MOTION; ONE THAT **ADDS** TO IT IS NOT",
	"STANDING RULE — A DIFFICULTY RUNG SCALES WHAT A MISTAKE COSTS, NEVER WHETHER THE QUESTION IS ASKED",
	"STANDING RULE — A RUNG MAY ONLY SCALE A SYSTEM EVERY SPEC CAN PARTICIPATE IN",
	"STANDING DESIGN RULE — A RUNE'S COST MAY BE BOUGHT BACK, AND PAYING FOR THAT IS THE DECISION",
	"STANDING RULE — THE OFFERABLE RUNE POOL IS RETIRED, AND A RETIREMENT IS DECLARED PER ENTRY",
	"STANDING RULE — RUNE CONTENT IS WRITTEN WITH THE DESIGNER, ONE RUNE AT A TIME",
	"STANDING RULE — THERE ARE NO RUNE RARITY TIERS, AND AN OFFER IS FLAT ACROSS THE RUN",
	"STANDING RULE — A RUNE IS SCOPED TO ITS CLASS, AND THREE GATES DECIDE WHAT A HERO CAN USE",
	"STANDING RULE — A NO-ENGINE RUNE READS ONLY WHAT EVERY HERO OF ITS CLASS HAS",
	"STANDING RULE — A RUNE READS ITS HOLDER'S EQUIPPED CARDS, NEVER HIS POOL",
	"STANDING RULE — A GATED RUNE AT A FLAT PRICE IS STRICTLY WORSE THAN A BARE ONE",
	"WHERE THE RETIRED RULE ITSELF IS KEPT, AND WHY IT IS NOT KEPT HERE",
	"STANDING RULE — A FLOOR ON A BUDGET IS NOT A FLOOR ON A COUNT",
	"STANDING RULE — A SUBTRACTION IS OPEN AT THE BOTTOM WHERE AN ASSIGNMENT IS NOT",
	"STANDING RULE — AN OFFER FROZEN AT DROP TIME IS RE-ASKED AT RESOLUTION",
	"THE POPULATION IS FIVE, BOTH REMAINING HOLES WERE REACHABLE, AND A REFUSAL IS NOT A REPAIR",
	"AND A RE-ASK CAN COME BACK EMPTY ONCE THE FLOOR UNDER IT IS REMOVED",
	"STANDING RULE — A STEP IN FLIGHT RIDES THE SAVE, AND A RESUME PUTS THE PARTY BACK IN IT",
	"STANDING RULE — A QUIT FIGHT RESTARTS, BUT THE PARTY'S LOSSES DO NOT",
	"STANDING RULE — BREAK IS A SECONDARY TAG ONLY",
	"STANDING RULE — EK'S INERTNESS CLAIM ENDED AT EZ AND CAME BACK AT FN",
	"STANDING RULE — THE COMPANION'S BLOW READS ELEVEN TERMS, NOT EIGHTY-FOUR, AND THE RULING SAID \"EVERYTHING\"",
	"STANDING RULE — A RUNE IS 150g, FLAT, AND SELLS BACK FOR A THIRD",
	"STANDING RULE — A RUNE DROPS AFTER EVERY NORMAL FIGHT; A CLASS RUNE LIVES WITH ITS HERO, THE BAG IS THE CREST'S",
	"STANDING RULE — NO PEDDLER, NO SMITH AND NO EVENT IN THE RUN'S FIRST THREE NODES",
	"STANDING RULE — THE PARTY SCOPE, AND THE RUNES IT HOLDS; ITS SCREEN WORD IS THE CREST",
	"STANDING RULE — LOYALTY IS GOVERNED BY A CONVERSION, NEVER BY A CEILING",
	"STANDING RULE — A RETIRED PIECE OF CONTENT IS KEPT, AND SAID TO BE KEPT",
	"STANDING RULE — A RUNE IS DISCONNECTED FROM THE TALENT TREES",
	"STANDING REFERENCE — THE ABILITY DRAFT, THE SLOT LADDER AND THE TWELVE PROTECTED CORES",
	"STANDING RULE — ONE DRAFT POOL A CLASS, AND A CARD THAT READS AN ENGINE IS OFFERED ONLY TO ITS HOLDER",
	"STANDING RULE — A RUNE THAT READS AN ENGINE IS OFFERED ONLY WHILE THAT ENGINE IS EQUIPPED",
	"STANDING RULE — THE SLOT LADDER, AND THE POOL IS NOT THE LOADOUT",
	"STANDING DESIGN RULE — A ZONE-BOSS AWARD ALWAYS PAYS",
	"STANDING DESIGN RULE — THE PROTECTED CORE IS THE BASELINE",
	"STANDING DESIGN RULE — THE ARRIVING-STANCE PRINCIPLE",
	"STANDING RULE — AN ENGINE IS EXCLUSIVE, AN AXIS IS SHARED",
	"THE EXCLUSIVE AXES, AND THERE ARE TWO — NOT THREE",
	"AND THE SAME RULE POINTED THE OTHER WAY — BEFORE DECLARING AN AXIS *ABSENT*, DERIVE IT TOO",
	"A REPEATABLE DRAFT CARD IS A LEGITIMATE SHAPE WHEN IT IS PRICED ELSEWHERE",
	"A DEAD PLAYER CARD IS A DEAD CARD; A DEAD ENEMY DEBUFF IS AN EXPLOIT",
	"STANDING REFERENCE — AN ENGINE, AN AXIS, AND NOW A TAG",
	"STANDING RULE — THE THREE DOORS THAT BITE A NEW DRAFT CARD",
	"STANDING RULE — READERS BRANCH AND FLIP; GATED ONES REQUIRE AND STAY",
	"STANDING RULE — EVERY ABILITY NAMES WHAT IT BUILDS WITH",
	"STANDING RULE — A CROSS-SPEC COUPLING IS NAMED IN THE CARD TEXT, AND IS A BONUS ON A CARD THAT ALREADY WORKS ALONE",
	"STANDING RULE — SWEEP A NAME AGAINST THE WHOLE ROSTER BEFORE AUTHORING IT",
	"STANDING RULE — A RUNE'S CLAUSE MUST BE CHECKED AGAINST THE BASE KIT, NOT ONLY AGAINST THE TALENT TREES AND THE CARDS",
	"STANDING RULE — `for i in n` EVALUATES ITS RANGE ONCE, SO A CLAUSE THAT ADDS AN ITERATION FROM INSIDE THE BODY NEEDS A `while`",
	"STANDING RULE — A SHARED SECOND-RESOURCE CARRY NEEDS ITS OWN KEY",
	"STANDING RULE — A RETIRED RUNE'S NAME IS NOT FREE, AND THE LIVE POOL'S NAMES ARE BARE",
]

# §1c — THE INSTRUMENT RULES WRITTEN BACK AFTER THE SEAM WAS TAKEN (HV §3e), named and left until a ruling
# moves them. HG–HJ's two stood here from HX and MOVED to `docs/instrument-rules.md` at HY §4, by the designer's
# ruling, byte for byte; none is left. A block this table names is printed every run, so it is never forgotten.
const WRITTEN_BACK := {}

# §1d — THE BACKTICKED NAMES THAT ARE NOT REPO NAMES, BY DESIGN: a path
# pattern, a player's file named bare, a shell fragment. A path under `user://`
# is passed by rule, never listed: spelled here, the player's save path is the
# one string `check_fi` §5 lets no file but `run_state.gd` carry.
const NOT_REPO_NAMES := [
	"docs/reports/<CODE>.md",
	".gd",
	"res://data/*.json",
	"check_*.gd",
	".godot",
	"grep -ln \"Last updated\" test_batch_*.gd",
	"run_save.bin",
	"relics.json",
	"target=(${SCENE[$name]:---script $name.gd})",
	"data/*.json",
	"chr(39)",
	"profile.json",
	"app_userdata",
]

# §1d(a) — THE NAMES THE REFERENCES CARRY THAT LIVE ONLY INSIDE AN INSTRUMENT'S
# STRINGS, each with what its sentence does with it. A name gone from the game
# and from every instrument's code still resolves to a plain search while a gate
# pins it absent BY NAMING IT — `check_dv` holds `roll_ability_offer` that way —
# so the population is derived and only the reading is written here: a RECORD
# of a deletion is correct and stays (EB §2: sweeping one deletes the project's
# memory of why a symbol is gone); a KEY or a convention word is an
# instrument's own; a LIVE CLAIM IN A DEAD NAME is the stale shape, named and
# queued. A new member reds; a member that has gone prints a notice.
const KNOWN_NEEDLE_ONLY := {
	"instrument-rules.md::wd_hold_line": "a KEY — `check_dk` §1's pin table names an entry by the node it pinned",
	"instrument-rules.md::dv_waters": "a KEY — `check_dk` §1's pin table, re-pointed at `_next_unit()`'s walk",
	"instrument-rules.md::CLASS_POOLS": "a RECORD of a deletion (DY §3) — the sentence says it was deleted",
	"instrument-rules.md::_overburn_drain": "a RECORD of a deletion — EB §2's own example of one that must not be swept",
	"instrument-rules.md::AXIS": "a CONVENTION word — the AXIS/SYNERGY comment lines six tranche suites pin",
	"instrument-rules.md::SYNERGY": "a CONVENTION word — the AXIS/SYNERGY comment lines six tranche suites pin",
	"combat-rules.md::wd_tank_spank": "a LIVE CLAIM IN A DEAD NAME — DK §1's reading kept in the present tense; FX deleted the node; queued at HX §1d, not repaired (the file is not HX's)",
}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH HX — THE CHECKS A REFERENCE IS HELD BY, AND THE BIGGER FILE")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cr := FileAccess.get_file_as_string("res://docs/combat-rules.md")
	var wow := FileAccess.get_file_as_string("res://docs/ways-of-working.md")
	ok(cm.length() > 100000, "§0: CLAUDE.md read back %d chars" % cm.length())
	ok(ir.length() > 40000, "§0: docs/instrument-rules.md read back %d chars" % ir.length())
	ok(cr.length() > 10000, "§0: docs/combat-rules.md read back %d chars" % cr.length())
	ok(wow.length() > 5000, "§0: docs/ways-of-working.md read back %d chars" % wow.length())
	_s1a_residency(cm, ir, cr)
	_s1b_no_second_copy(cm, ir, cr, wow)
	_s1c_not_written_back(cm)
	_s1d_names_resolve(ir, cr)
	_s2_the_state_archive()
	_s3_the_two_rules()
	_s5_the_rulings()
	_g.report(self)


# ── THE TWO INDEX SPANS ─────────────────────────────────────────────────────
func _span(cm: String, opener: String) -> Vector2i:
	var a := cm.find(opener)
	if a < 0:
		return Vector2i(-1, -1)
	return Vector2i(a, cm.find("\n## ", a))


func _rows(cm: String, opener: String) -> Array:
	var sp := _span(cm, opener)
	var out: Array = []
	if sp.x < 0 or sp.y <= sp.x:
		return out
	var ann := RegEx.new()
	ann.compile("\\s*\\*\\(.*\\)\\*\\s*$")
	for line in cm.substr(sp.x, sp.y - sp.x).split("\n"):
		if line.begins_with("| ") and not line.begins_with("| |") and not line.begins_with("|---"):
			var core := ann.sub(String(line.split("|")[1]), "", true).strip_edges()
			if core != "":
				out.append(core)
	return out


# A reference's blocks below its preamble (`---`), each with its level and the
# index of its `##` parent.
func _blocks(ref: String) -> Array:
	var out: Array = []
	var at := ref.find("\n---\n")
	var parent := -1
	for line in ref.substr(maxi(at, 0)).split("\n"):
		if line.begins_with("## "):
			out.append({"head": line, "level": 2, "parent": -1})
			parent = out.size() - 1
		elif line.begins_with("### "):
			out.append({"head": line, "level": 3, "parent": parent})
	return out


# ── §1a — RESIDENCY, BOTH WAYS, FOR EACH INDEX ──────────────────────────────
#
# **A ROW NAMES A BLOCK** when its text (an italic annotation such as *(+ the
# staleness-tripwire exemption…)* taken off) is found in exactly one of the
# reference's headings. **A BLOCK IS ROWED** when one row names it — or it is a
# `###` child whose `##` parent is rowed (it travels with the parent: the
# equality rule's two children), or a `##` CONTAINER, a heading with no rule of
# its own whose every `###` child is rowed (THE TRAPS' instrument half). Every
# other block with no row is a rule the required read does not point at, which is
# what GW §2's block was from GW to HX.
func _s1a_residency(cm: String, ir: String, cr: String) -> void:
	print("\n§1a — residency, both ways, for each index")
	for pair in [["the instrument index", INDEX_OPEN, ir, "docs/instrument-rules.md", 45],
			["the combat index", COMBAT_INDEX_OPEN, cr, "docs/combat-rules.md", 9]]:
		var label: String = pair[0]
		var rows := _rows(cm, String(pair[1]))
		var blocks := _blocks(String(pair[2]))
		ok(rows.size() >= int(pair[4]),
			"§1a: %s reads %d rows — %d stood at HX, so the table or its parser has broken" % [
				label, rows.size(), int(pair[4])])
		ok(not blocks.is_empty(), "§1a: %s has no blocks below its preamble" % pair[3])
		var named: Array = []
		for b in blocks:
			named.append(0)
		var bad_rows: Array = []
		for core in rows:
			var hits := 0
			for k in blocks.size():
				if String(blocks[k]["head"]).contains(String(core)):
					hits += 1
					named[k] = int(named[k]) + 1
			if hits != 1:
				bad_rows.append("%s (%d blocks)" % [core, hits])
		var orphans: Array = []
		var travelling := 0
		var containers := 0
		for k2 in blocks.size():
			var b2: Dictionary = blocks[k2]
			var n := int(named[k2])
			if n == 1:
				continue
			if n > 1:
				orphans.append("%s (%d rows)" % [String(b2["head"]).substr(0, 80), n])
				continue
			if int(b2["level"]) == 3 and int(b2["parent"]) >= 0 and int(named[int(b2["parent"])]) == 1:
				travelling += 1
				continue
			if int(b2["level"]) == 2:
				var kids := 0
				var kids_rowed := 0
				for k3 in blocks.size():
					if int(blocks[k3]["parent"]) == k2:
						kids += 1
						if int(named[k3]) == 1:
							kids_rowed += 1
				if kids > 0 and kids == kids_rowed:
					containers += 1
					continue
			orphans.append(String(b2["head"]).substr(0, 100))
		ok(bad_rows.is_empty(),
			"§1a: in %s a row does not name exactly one block of %s: %s" % [
				label, pair[3], " / ".join(PackedStringArray(bad_rows))])
		ok(orphans.is_empty(),
			"§1a: %s has a block %s does not point at: %s" % [
				pair[3], label, " / ".join(PackedStringArray(orphans))])
		print("  %s: %d rows, %d blocks — %d rowed, %d travelling with their parent, %d containers, %d orphans, %d rows naming no single block" % [
			label, rows.size(), blocks.size(), blocks.size() - travelling - containers - orphans.size(),
			travelling, containers, orphans.size(), bad_rows.size()])


# ── §1b — NO RULE TEXT IN TWO RULE FILES, CASE SET ASIDE ────────────────────
#
# THE UNIT IS A RUN OF TWELVE WORDS, lowercased, with the markdown taken off
# (the emphasis and the code ticks) and the line markers too — so a rewrap, a
# change of case or a bold that moved cannot hide a copy, which is the hole
# `check_ff` §2's needles had (one of FF's eight stands in `CLAUDE.md` again,
# in another case). Twelve because sixty characters, `check_fr` §2's floor, is
# about ten words and the seam's own vocabulary shares eleven-word phrases that
# are not a rule (*the suites, the gates, the battery, baselines.json, the
# negative controls*). `CLAUDE.md`'s two index spans are left out: a row is a
# heading's copy on purpose, and `check_ff` §4 is what holds that hazard.
#
# AND A RULE STATEMENT — a heading, or the bold lead of a bullet — that stands
# as a statement in a second file is a duplicate however short it is: the
# autoload rule is eight words, a heading in one file and a bold lead in the
# other.
func _words(txt: String) -> PackedStringArray:
	var t := txt.to_lower().replace("`", " ").replace("*", " ")
	var rx := RegEx.new()
	rx.compile("[a-z0-9_§']+")
	var out := PackedStringArray()
	for m in rx.search_all(t):
		out.append(m.get_string())
	return out


func _shingles(ws: PackedStringArray, n: int) -> Dictionary:
	var d := {}
	for i in range(0, ws.size() - n + 1):
		var key := " ".join(ws.slice(i, i + n))
		if not d.has(key):
			d[key] = i
	return d


func _without_indexes(cm: String) -> String:
	var out := cm
	for opener in [INDEX_OPEN, COMBAT_INDEX_OPEN]:
		var sp := _span(out, String(opener))
		if sp.x >= 0 and sp.y > sp.x:
			out = out.substr(0, sp.x) + out.substr(sp.y)
	return out


func _norm(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	var t := s.to_lower().replace("`", "").replace("*", "")
	t = rx.sub(t, " ", true).strip_edges()
	while t.ends_with(".") or t.ends_with(":") or t.ends_with(","):
		t = t.substr(0, t.length() - 1)
	return t


func _statements(txt: String) -> Array:
	var out: Array = []
	var prov := RegEx.new()
	prov.compile("\\s*\\((STANDING|SET AT|Batch|RULED|this file|GATHERED)[^)]*\\)?.*$")
	var bold := RegEx.new()
	bold.compile("(?m)^\\s*(?:- |· |\\d+\\. |> )?\\*\\*([^*\\n][^*]{20,400}?)\\*\\*")
	for line in txt.split("\n"):
		if line.begins_with("## ") or line.begins_with("### "):
			var h := prov.sub(line.lstrip("# "), "", false)
			var n := _norm(h)
			if n.split(" ").size() >= 5:
				out.append(n)
	for m in bold.search_all(txt):
		var n2 := _norm(m.get_string(1))
		if n2.split(" ").size() >= 5:
			out.append(n2)
	return out


func _s1b_no_second_copy(cm: String, ir: String, cr: String, wow: String) -> void:
	print("\n§1b — no rule text stands in two rule files, case set aside")
	var texts := {"CLAUDE.md": _without_indexes(cm), "instrument-rules.md": ir,
		"combat-rules.md": cr, "ways-of-working.md": wow}
	var names: Array = texts.keys()
	var words := {}
	var shs := {}
	for nm in names:
		words[nm] = _words(String(texts[nm]))
		shs[nm] = _shingles(words[nm], 12)
	# A RUN THAT SITS WHOLLY INSIDE A HEADING OF ANY OF THE FOUR FILES IS A RULE
	# CITED BY ITS TITLE — the pointer `docs/ways-of-working.md` asks for (*it
	# POINTS at it and does not restate it*) — and is printed, never failed. ANY
	# of the four, not the pair compared: two files citing one title of a third
	# share the run and neither holds a copy (HX's re-tune R04 found the pair's
	# own headings blind to that).
	var all_heads: Array = []
	for nm0 in names:
		for line in String(texts[nm0]).split("\n"):
			if line.begins_with("## ") or line.begins_with("### "):
				all_heads.append(" ".join(_words(line)))
	var found: Array = []
	var cited: Array = []
	for i in names.size():
		for j in range(i + 1, names.size()):
			var a: String = names[i]
			var b: String = names[j]
			var pos: Array = []
			for key in shs[a]:
				if shs[b].has(key):
					pos.append(int(shs[a][key]))
			pos.sort()
			var runs: Array = []
			for p in pos:
				if not runs.is_empty() and p <= int(runs[-1][1]) + 1:
					runs[-1][1] = p
				else:
					runs.append([p, p])
			for r in runs:
				var wa: PackedStringArray = words[a]
				var length := int(r[1]) - int(r[0]) + 12
				var opening := " ".join(wa.slice(int(r[0]), int(r[0]) + 8))
				var whole := " ".join(wa.slice(int(r[0]), int(r[0]) + length))
				var is_title := false
				for hw2 in all_heads:
					if String(hw2).contains(whole):
						is_title = true
				if is_title:
					cited.append("%s ~ %s: %s (%d words)" % [a, b, opening, length])
				else:
					found.append("%s ~ %s: %s (%d words)" % [a, b, opening, length])
	var new_runs: Array = []
	for f in found:
		var known := false
		for k in KNOWN_SHARED:
			if String(f).begins_with(String(k)):
				known = true
		if not known:
			new_runs.append(f)
	var gone: Array = []
	for k2 in KNOWN_SHARED:
		var seen := false
		for f2 in found:
			if String(f2).begins_with(String(k2)):
				seen = true
		if not seen:
			gone.append(k2)
	for c in cited:
		print("  [a title cited] %s" % c)
	for nr in new_runs:
		print("    SHARED RUN: %s" % nr)
	ok(new_runs.is_empty(),
		"§1b: %d run(s) of twelve words stand in two rule files and are not known: %s" % [
			new_runs.size(), " / ".join(PackedStringArray(new_runs))])
	for g in gone:
		print("  [notice] §1b: the known shared run `%s` is gone — delete its line" % g)
	# THE STATEMENTS.
	var stmts := {}
	for nm2 in names:
		stmts[nm2] = _statements(String(texts[nm2]))
	var dup_st: Array = []
	for i2 in names.size():
		for j2 in range(i2 + 1, names.size()):
			for s1 in stmts[names[i2]]:
				for s2 in stmts[names[j2]]:
					if String(s1).contains(String(s2)) or String(s2).contains(String(s1)):
						var key2 := "%s ~ %s: %s" % [names[i2], names[j2],
							String(s1 if String(s1).length() <= String(s2).length() else s2)]
						if not dup_st.has(key2):
							dup_st.append(key2)
	var new_st: Array = []
	for d in dup_st:
		if not KNOWN_STATEMENTS.has(d):
			new_st.append(d)
	for ns in new_st:
		print("    SHARED STATEMENT: %s" % ns)
	ok(new_st.is_empty(),
		"§1b: %d rule statement(s) stand as a statement in two rule files and are not known: %s" % [
			new_st.size(), " / ".join(PackedStringArray(new_st))])
	for k3 in KNOWN_STATEMENTS:
		if not dup_st.has(k3):
			print("  [notice] §1b: the known shared statement `%s` is gone — delete its line" % k3)
	var n_sh := 0
	for nm3 in names:
		n_sh += (shs[nm3] as Dictionary).size()
	ok(n_sh > 50000, "§1b: only %d word runs were built across the four files — the arm has gone vacuous" % n_sh)
	print("  CHECKED %d twelve-word runs across %d files: %d shared (%d known); %d shared statements (%d known)" % [
		n_sh, names.size(), found.size(), found.size() - new_runs.size(), dup_st.size(), dup_st.size() - new_st.size()])


# ── §1c — A REFERENCE'S SUBJECT IS NOT WRITTEN BACK ─────────────────────────
func _block_keys(cm: String) -> Array:
	# A HEADING THAT WRAPS onto a second heading line of the same level is one
	# heading (three do in `CLAUDE.md`), and the key is its text with ONE
	# trailing parenthesis — the provenance — taken off, so a batch adding a
	# citation to a heading's provenance does not move its key.
	var prov := RegEx.new()
	prov.compile("\\s*\\([^()]*\\)\\s*$")
	var heads: Array = []
	var lines := cm.split("\n")
	var i := 0
	while i < lines.size():
		var line := String(lines[i])
		if line.begins_with("## ") or line.begins_with("### "):
			var marker := line.substr(0, line.find(" ") + 1)
			var text := line.substr(marker.length())
			while i + 1 < lines.size() and String(lines[i + 1]).begins_with(marker) \
					and not String(lines[i + 1]).begins_with(marker + "#"):
				i += 1
				text += " " + String(lines[i]).substr(marker.length())
			heads.append(prov.sub(text, "", false).strip_edges())
		i += 1
	return heads


func _s1c_not_written_back(cm: String) -> void:
	print("\n§1c — a reference's subject is not written back into CLAUDE.md")
	var keys := _block_keys(cm)
	var new_blocks: Array = []
	for k in keys:
		if not KNOWN_BLOCKS.has(k):
			new_blocks.append(k)
	for nb in new_blocks:
		print("    BLOCK: %s" % nb)
	ok(new_blocks.is_empty(),
		"§1c: %d block(s) in CLAUDE.md are not in the known population: %s" % [
			new_blocks.size(), " / ".join(PackedStringArray(new_blocks))])
	# BOTH WAYS, AS THIS GATE'S HEADER SAYS (repaired at HY §4: until then a block that LEFT printed nothing, so
	# a block moved out — or deleted — passed in silence): a known block that is gone is a notice, never a red.
	for kb in KNOWN_BLOCKS:
		if not keys.has(kb):
			print("  [notice] §1c: the known block `%s` is gone from CLAUDE.md — delete its line" % kb)
	for wb in WRITTEN_BACK:
		print("  [written back, named and left] %s — %s" % [wb, WRITTEN_BACK[wb]])
	print("  %d blocks read" % keys.size())


# ── §1d — THE REFERENCES' NAMES RESOLVE ─────────────────────────────────────
func _corpora() -> Dictionary:
	# THREE READINGS OF ONE WALK. `whole` is every name the tree carries; `game` is
	# the game's scripts, data and scenes, where a string IS a read site
	# (`has_status("charging")`); `instr` is the root's instruments with their
	# strings masked, because there a string is a needle. The root's two
	# data files — the baselines and the pin manifest, which holds every needle —
	# are in `whole` alone.
	var whole := ""
	var game := ""
	var instr := ""
	for dir_any in ["res://scripts", "res://", "res://data", "res://scenes"]:
		var dir_path: String = dir_any
		var d := DirAccess.open(dir_path)
		if d == null:
			continue
		var at_root := dir_path == "res://"
		for f_any in d.get_files():
			var f: String = f_any
			var p: String = ("res://" + f) if at_root else dir_path.path_join(f)
			if f.ends_with(".gd"):
				var src := Gate.strip_comments(FileAccess.get_file_as_string(p))
				whole += src + "\n"
				if at_root:
					instr += _mask_strings(src) + "\n"
				else:
					game += src + "\n"
			elif f.ends_with(".sh") or f.ends_with(".py"):
				var kept := ""
				for line in FileAccess.get_file_as_string(p).split("\n"):
					if not String(line).strip_edges().begins_with("#"):
						kept += line + "\n"
				whole += kept
				instr += kept
			elif f.ends_with(".json") or f.ends_with(".tscn") or f == "project.godot":
				var t := FileAccess.get_file_as_string(p) + "\n"
				whole += t
				if not at_root or f == "project.godot":
					game += t
				elif f.ends_with(".tscn"):
					instr += t
	return {"whole": whole, "game": game, "instr": instr}


# A line's strings blanked once `Gate.strip_comments` has taken its comments —
# both quotes, because a needle is written in either.
func _mask_strings(src: String) -> String:
	var out := ""
	for raw in src.split("\n"):
		var line := String(raw)
		var quote := ""
		var kept := ""
		var i := 0
		while i < line.length():
			var c := line[i]
			if quote != "":
				if c == "\\":
					kept += "  "
					i += 2
					continue
				if c == quote:
					quote = ""
					kept += c
				else:
					kept += " "
			elif c == "\"" or c == "'":
				quote = c
				kept += c
			else:
				kept += c
			i += 1
		out += kept + "\n"
	return out


func _kind(t: String) -> String:
	var rx_path := RegEx.new()
	rx_path.compile("\\.(gd|md|json|sh|py|html|cfg|bin|tscn|godot)\\b")
	if rx_path.search(t) != null:
		return "path"
	var rx_call := RegEx.new()
	rx_call.compile("^[A-Za-z_][\\w.]*\\(")
	if rx_call.search(t) != null:
		return "call"
	var rx_const := RegEx.new()
	rx_const.compile("^[A-Z][A-Z0-9_]{2,}$")
	if rx_const.search(t) != null:
		return "const"
	var rx_dot := RegEx.new()
	rx_dot.compile("^[A-Za-z_]\\w*\\.[A-Za-z_]\\w*$")
	if rx_dot.search(t) != null:
		return "dotted"
	var rx_id := RegEx.new()
	rx_id.compile("^[a-z_][a-z0-9_]*$")
	if rx_id.search(t) != null and t.contains("_"):
		return "ident"
	return ""


func _word_in(corpus: String, w: String) -> bool:
	var rx := RegEx.new()
	rx.compile("\\b" + w + "\\b")
	return rx.search(corpus) != null


func _path_exists(t: String) -> bool:
	var rx := RegEx.new()
	rx.compile("([\\w./-]+\\.(gd|md|json|sh|py|html|cfg|bin|tscn|godot))")
	var m := rx.search(t)
	if m == null:
		return false
	var p := m.get_string(1).trim_prefix("res://")
	for base in ["res://", "res://docs/", "res://docs/reports/", "res://scripts/", "res://data/", "res://DoD-archive/"]:
		if FileAccess.file_exists(base + p) or FileAccess.file_exists(base + p.get_file()):
			return true
	return false


func _s1d_names_resolve(ir: String, cr: String) -> void:
	print("\n§1d — every backticked name in the two references resolves")
	var corp := _corpora()
	var corpus: String = corp["whole"]
	var game: String = corp["game"]
	var instr: String = corp["instr"]
	ok(corpus.length() > 1000000, "§1d: the code corpus read back %d chars — the walk has broken" % corpus.length())
	ok(game.length() > 1000000 and instr.length() > 500000,
		"§1d(a): the game read back %d chars and the instruments' code %d — the split has broken" % [
			game.length(), instr.length()])
	var tick := RegEx.new()
	tick.compile("`([^`\\n]+)`")
	var checked := 0
	var unresolved: Array = []
	var needle_only: Array = []
	var new_needle_only: Array = []
	for pair in [["instrument-rules.md", ir], ["combat-rules.md", cr]]:
		var seen := {}
		for m in tick.search_all(String(pair[1])):
			var t := m.get_string(1)
			if seen.has(t):
				continue
			seen[t] = true
			var kind := _kind(t)
			if kind == "":
				continue
			checked += 1
			if t.begins_with("user://"):
				continue
			var good := false
			var w := ""
			match kind:
				"path":
					good = _path_exists(t)
				"call":
					var head := t.substr(0, t.find("("))
					w = head.get_slice(".", head.get_slice_count(".") - 1)
				"const", "ident":
					w = t
				"dotted":
					w = t.get_slice(".", 1)
			if w != "":
				good = _word_in(corpus, w)
			if not good and not NOT_REPO_NAMES.has(t):
				unresolved.append("%s: `%s` (%s)" % [pair[0], t, kind])
			if good and w != "" and not NOT_REPO_NAMES.has(t) and not _word_in(game, w) and not _word_in(instr, w):
				var key := "%s::%s" % [pair[0], w]
				needle_only.append(key)
				if not KNOWN_NEEDLE_ONLY.has(key):
					new_needle_only.append(key)
	for u in unresolved:
		print("    UNRESOLVED: %s" % u)
	ok(unresolved.is_empty(),
		"§1d: %d backticked name(s) in the references resolve nowhere in the tree: %s" % [
			unresolved.size(), " / ".join(PackedStringArray(unresolved))])
	ok(checked >= 300, "§1d: only %d names were checked — the extractor has stopped matching" % checked)
	print("  CHECKED %d names across the two references; %d unresolved" % [checked, unresolved.size()])
	# (a) — a name found only inside an instrument's needle.
	for k in needle_only:
		print("  [needle only] %s — %s" % [k, KNOWN_NEEDLE_ONLY.get(k, "NEW: not read yet")])
	ok(new_needle_only.is_empty(),
		"§1d(a): %d name(s) in the references live only inside an instrument's string — a dead name a needle keeps alive, or a key nobody has read: %s" % [
			new_needle_only.size(), " / ".join(PackedStringArray(new_needle_only))])
	for k in KNOWN_NEEDLE_ONLY:
		if not needle_only.has(k):
			print("  NOTICE: %s is no longer found only in a needle — delete its KNOWN_NEEDLE_ONLY line" % k)
	print("  (a) CHECKED %d names against the game and the instruments' code; %d live only in a needle, %d of them known" % [
		checked, needle_only.size(), needle_only.size() - new_needle_only.size()])
	# (b) — a constant's value written beside its name.
	var stated := RegEx.new()
	stated.compile("`(?:[\\w.]*\\.)?([A-Z][A-Z0-9_]+)\\s*:?=\\s*([^`]+)`")
	var values := 0
	var wrong: Array = []
	for pair in [["instrument-rules.md", ir], ["combat-rules.md", cr]]:
		for m in stated.search_all(String(pair[1])):
			values += 1
			var name := m.get_string(1)
			var said := m.get_string(2).strip_edges()
			var decl := RegEx.new()
			decl.compile("(?m)^\\s*(?:static\\s+)?(?:const|var)\\s+" + name + "\\s*(?::\\s*\\w+\\s*)?:?=\\s*([^\\n]+)")
			var d := decl.search(corpus)
			var held := d.get_string(1).strip_edges() if d != null else "<declared nowhere>"
			print("  [stated] %s: `%s` — declared %s" % [pair[0], m.get_string(0).trim_prefix("`").trim_suffix("`"), held])
			if held != said:
				wrong.append("%s: %s is %s in the script, %s in the reference" % [pair[0], name, held, said])
	ok(wrong.is_empty(),
		"§1d(b): %d constant value(s) in the references are not the declared ones: %s" % [
			wrong.size(), " / ".join(PackedStringArray(wrong))])
	print("  (b) CHECKED %d stated constant values; %d wrong" % [values, wrong.size()])


# ── §2 — THE STATE ARCHIVE, REACHED THROUGH THE LIVE FILE ───────────────────
#
# CD's pattern, the changelog's (`check_dv` §4): the archive is found through the
# live file's OWN HEADER, never through a path written here, so moving it is one
# edit and a header that stops naming it reds. **NO SIZE IS ASSERTED** — two sizes
# agreeing is consistent with a section duplicated and one dropped. What is asked
# is the shape: the archive is there and says what it is, and no section heading
# stands in both halves, so a section is in one place or the other, never both.
func _s2_the_state_archive() -> void:
	print("\n§2 — the state archive, reached through docs/state.md's own header")
	var live := FileAccess.get_file_as_string("res://docs/state.md")
	ok(live.length() > 10000, "§2: docs/state.md read back %d chars" % live.length())
	var stamp := live.find("Last rewritten")
	var mark := live.find("/state-archive.md`")
	ok(mark > 0 and (stamp < 0 or mark < stamp),
		"§2: docs/state.md's header no longer names its archive by its full path, above the Last rewritten line")
	# NO EARLY RETURN: a header that lost the name reds the arms below with it, and
	# the count stays the count (a falling count is the differ's error, DE).
	var arch_path := ""
	if mark > 0:
		var open_at := live.rfind("`", mark - 1) + 1
		arch_path = live.substr(open_at, mark + "/state-archive.md".length() - open_at)
	ok(arch_path.begins_with("res://"), "§2: the archive is named as %s, not by its res:// path" % arch_path)
	var arch := FileAccess.get_file_as_string(arch_path) if arch_path != "" else ""
	ok(arch.length() > 10000, "§2: the archive at %s reads %d chars" % [arch_path, arch.length()])
	ok(arch.contains("docs/state.md"), "§2: the archive does not name the live file it was cut from")
	var live_heads := _h3_heads(live)
	var arch_heads := _h3_heads(arch)
	var both: Array = []
	for h in arch_heads:
		if live_heads.has(h):
			both.append(String(h).substr(0, 90))
	ok(arch_heads.size() >= 20,
		"§2: the archive holds %d sections — the cut, or the reader, has broken" % arch_heads.size())
	ok(both.is_empty(),
		"§2: %d section(s) stand in both docs/state.md and its archive: %s" % [both.size(), " / ".join(PackedStringArray(both))])
	var struck := 0
	for h2 in live_heads:
		if String(h2).begins_with("~~"):
			struck += 1
	print("  the live file: %d sections, %d with a struck heading; the archive: %d sections; %d in both" % [
		live_heads.size(), struck, arch_heads.size(), both.size()])


func _h3_heads(txt: String) -> Array:
	var out: Array = []
	for line in txt.split("\n"):
		if line.begins_with("### "):
			out.append(line.substr(4).strip_edges())
	return out


# ── §3 — THE TWO RULES EVERY BRIEF WROTE BY HAND ────────────────────────────
#
# HV §3e counted them: *write the docs before the verification run* in 89 of 94
# briefs and *read the rows of `ps`* in 51, and in no rule file. They bind how a
# batch verifies itself, so they are INSTRUMENT rules and live in the reference —
# each as a block with its row (§1a holds the row), a sentence out of its body
# pinned against the reference, and the same sentence absent from `CLAUDE.md`
# with case set aside, which is the placement §1c exists to hold.
func _s3_the_two_rules() -> void:
	print("\n§3 — the two rules every brief wrote by hand, in the instrument rules")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(ir.contains("## STANDING RULE — WRITE THE DOCUMENTS BEFORE THE VERIFICATION RUN"),
		"§3: the instrument rules carry no block for writing the documents before the run")
	ok(ir.contains("A DOCUMENT EDITED AFTER THE RUN IS A TREE THE RUN DID NOT READ"),
		"§3: the documents rule has lost the sentence that says why")
	ok(ir.contains("## STANDING RULE — READ THE ROWS OF `ps`, NEVER A `grep -c`"),
		"§3: the instrument rules carry no block for reading the rows of ps")
	ok(ir.contains("A COUNT OVER `ps` COUNTS THE SEARCH TOO"),
		"§3: the ps rule has lost the sentence that says why")
	ok(not cm.to_lower().contains("a document edited after the run is a tree the run did not read"),
		"§3: the documents rule is written into CLAUDE.md as well — an instrument rule lives in the reference")
	ok(not cm.to_lower().contains("a count over `ps` counts the search too"),
		"§3: the ps rule is written into CLAUDE.md as well — an instrument rule lives in the reference")


# ── §5 — THE RULINGS, WHERE A FUTURE SESSION READS THEM ─────────────────────
func _s5_the_rulings() -> void:
	print("\n§5 — HV's rulings, recorded in CLAUDE.md")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("THE ORDER IS NOT HV's: the checks a reference is held by first"),
		"§5: the ceiling block does not record the shape ruling and its order")
	ok(cm.contains("designer ruled its copy REFUSED, not routed (HX §0)"),
		"§5: the carrier rule does not record the Frostbind ruling")
	ok(cm.contains("The Covenant half of the Ruin route is KEPT (HX §0, ruled)"),
		"§5: the carrier rule does not record why the Covenant half is kept")
	ok(cm.contains("AND SINCE HX THE SEAM IS HELD BY CHECKS, NOT BY BEING OPENED"),
		"§5: the instrument pointer does not say the seam is held by this gate")
