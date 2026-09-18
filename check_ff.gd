# BATCH FF — THE INSTRUMENT RESIDUE FOLLOWS EF'S SEAM, AND THE INDEX IS PROVED
# NOT TO BE STANDING IN FOR THE RULES.
#
#   §1  THE EIGHT MOVED RULES LIVE IN THE REFERENCE AS HEADINGS, and appear in
#       `CLAUDE.md` only as INDEX ROWS
#   §2  AND THE RULE ITSELF MOVED, not just its title — a BODY sentence out of
#       each one is in the reference and is NOT in `CLAUDE.md`
#   §3  THE TIEBREAK STILL RUNS ONE WAY — both halves still declare which file
#       is the required read
#   §4  NO NEEDLE ANY READER ASSERTS INTO `CLAUDE.md` RESOLVES ONLY INSIDE AN
#       INDEX — EF's hazard, swept live rather than checked once, over BOTH
#       indexes since GR §2
#   §5  THE SUBJECT SEAM'S RESIDENCY (GR §2) — every row of the combat index
#       names exactly one heading in `docs/combat-rules.md` and is the only line
#       in `CLAUDE.md` that names it, every rule there has its row, and no line
#       of a rule there also stands in `CLAUDE.md`. DERIVED FROM THE INDEX, not
#       from a list typed here, so a rule a later batch moves joins by its row.
#
# **GR §2 SPLIT `CLAUDE.md` A THIRD TIME, BY SUBJECT, AND ADDED A SECOND INDEX.**
# Nine rules about how a fight resolves went to `docs/combat-rules.md` and nine
# more rows went into `CLAUDE.md` — nine more places a pin can resolve on a
# title while the rule it names is gone, which is the hazard §4 exists for. So
# §0 locates every index, §4 accuses a needle that resolves only inside any of
# them, and §5 asks the seam's own residency questions of the new one.
#
# **WHY THIS BATCH EARNS A GATE, AND WHY §4 IS THE HALF WORTH HAVING.** EF
# proved by control that an INDEX OF HEADINGS CAN SATISFY A PIN: rewording the
# rule reds, rewording the index does not. FF adds EIGHT more index rows, so it
# adds eight more places a future pin can be satisfied without ever reading a
# rule. §1 and §2 pin THIS batch's eight; §4 is the one that keeps working —
# it walks every suite and gate, locates every literal each asserts into
# `CLAUDE.md`, and fails the day one of them resolves NOWHERE BUT THE INDEX.
#
#   THE BODY NEEDLES IN §2 ARE THE SHARP HALF. A heading can be an index row.
#     A sentence out of the middle of a rule cannot, so §2 is what separates
#     "the rule moved" from "the title moved and the rule was dropped".
#   §4 PRINTS ITS OWN POPULATION. A sweep whose regex matched no reader, or no
#     literal, reports "no violations" exactly as loudly as a clean tree — so
#     the reader count and the literal count are asserted, not just printed.
#   NOTHING HERE COMPARES A FILE SIZE. Two sizes agreeing is consistent with a
#     duplicated block and a dropped one; the byte-exact reconstruction of both
#     halves is in `docs/reports/FF.md` §2 and is a batch-time proof against
#     the pre-split commit, which a gate on disk cannot reproduce.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ff.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

# THE EIGHT, AS (heading, a sentence out of the BODY). The body needle is taken
# from the middle of the moved text deliberately: it is the member no index row
# could ever carry, which is what makes the pair a real test rather than two
# readings of the same string.
const MOVED := [
	["COUNTS, BANDS, FLAKES AND THE PARSE FLOOR",
		"A BAND WIDE ENOUGH TO COVER A GENUINE FAILURE CANNOT REPORT ONE"],
	["THE SHELL, THE ENGINE AND THE FILES",
		"ZSH DOES NOT WORD-SPLIT UNQUOTED EXPANSIONS"],
	["RUN HEAD'S OWN GATE AGAINST THE NEW CODE BEFORE RE-POINTING IT",
		"THE COST OF SKIPPING IT IS A BATTERY"],
	["AN EXACT COUNTERFACTUAL IS EXACT ABOUT THE PAIRING",
		"QUOTE THE PAIRED DELTA AS EXACT AND THE LEVEL AS A SAMPLE"],
	["AN ARM IS NOT READ UNTIL ITS PROCESS HAS EXITED",
		"EACH ARM WRITES ITS OWN DONE MARKER AND THE READER POLLS FOR THE MARKER"],
	["A SNAPSHOT TAKEN MID-WAY MEASURES WHATEVER HAPPENED TO BE DONE AT THE TIME",
		"COPY THE WHOLE TREE BEFORE THE FIRST EDIT, AND DIFF AGAINST THAT"],
	["PROSE RECORDING A REMOVAL READS EXACTLY LIKE THE REMOVAL NOT HAPPENING",
		"A COMMENT CANNOT CONCATENATE"],
	["THE READ SITE IS THE LINE, NOT THE FUNCTION",
		"A THIRD CATEGORY EXISTS AND IT IS NOT THE SHAPE"],
]

const INDEX_OPEN := "**WHAT IS OVER THERE**"
# GR §2's index, for the rules that went to `docs/combat-rules.md`. It opens on
# its own words, so the two spans can never be read as one.
const COMBAT_INDEX_OPEN := "**WHAT IS IN THE COMBAT RULES**"

var _cm := ""
var _ir := ""
var _idx_from := -1
var _idx_to := -1
var _cidx_from := -1
var _cidx_to := -1


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH FF — THE SEAM'S RESIDENCY, AND THE INDEX IS NOT THE RULE")
	# The literal is written out on the assignment line on purpose: `check_ea`
	# §3 sweeps every identifier ASSIGNED from `res://CLAUDE.md`, and a const
	# path would hand it a holder it cannot see.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	_cm = cm
	_ir = ir
	ok(_cm.length() > 100000, "CLAUDE.md read back %d chars" % _cm.length())
	ok(_ir.length() > 40000, "docs/instrument-rules.md read back %d chars" % _ir.length())
	_locate_index()
	_s1_headings()
	_s2_bodies()
	_s3_the_tiebreak()
	_s4_no_pin_lives_only_in_the_index()
	_s5_the_subject_seam()
	_g.report(self)


# ── THE INDEX SPAN, LOCATED AND ASSERTED NON-EMPTY ──────────────────────────
func _locate_index() -> void:
	_idx_from = _cm.find(INDEX_OPEN)
	_idx_to = _cm.find("\n## ", maxi(_idx_from, 0))
	ok(_idx_from >= 0, "CLAUDE.md no longer carries the reference file's index — §1 and §4 cannot ask their question")
	ok(_idx_to > _idx_from,
		"the index has no closing `## ` heading after it, so §4's span is the rest of the file")
	# A SPAN OF ZERO WOULD MAKE §4 PASS BY MEASURING NOTHING.
	ok(_idx_to - _idx_from > 1500,
		"§0: the index span is %d chars — too short to be the table, so §4 would be vacuous" % (_idx_to - _idx_from))
	print("  index span: %d..%d (%d chars)" % [_idx_from, _idx_to, _idx_to - _idx_from])
	# AND GR §2's, ASKED THE SAME THREE QUESTIONS. Its table is nine rows, so its
	# floor is its own and not FF's: set under the span it measured (706 chars at
	# GR), far above what an opener with no table under it would measure.
	_cidx_from = _cm.find(COMBAT_INDEX_OPEN)
	_cidx_to = _cm.find("\n## ", maxi(_cidx_from, 0))
	ok(_cidx_from >= 0, "CLAUDE.md no longer carries the combat rules' index — §4 and §5 cannot ask their question")
	ok(_cidx_to > _cidx_from,
		"the combat rules' index has no closing `## ` heading after it, so §4's span is the rest of the file")
	ok(_cidx_to - _cidx_from > 500,
		"§0: the combat rules' index spans %d chars — too short to be the table, so §4 and §5 would be vacuous" % (
			_cidx_to - _cidx_from))
	print("  combat index span: %d..%d (%d chars)" % [_cidx_from, _cidx_to, _cidx_to - _cidx_from])


# AN OCCURRENCE OUTSIDE EVERY INDEX. §4's question is asked of both tables now,
# so a pin resolving only on a row of either one is the hazard.
func _outside_every_index(o: int) -> bool:
	return (o < _idx_from or o >= _idx_to) and (o < _cidx_from or o >= _cidx_to)


func _is_heading_line(txt: String, needle: String) -> int:
	var n := 0
	for line in txt.split("\n"):
		if (line.begins_with("## ") or line.begins_with("### ")) and line.contains(needle):
			n += 1
	return n


# ── §1 — THE HEADING LIVES IN THE REFERENCE, AND IN `CLAUDE.md` IT IS A ROW ──
func _s1_headings() -> void:
	print("\n§1 — the eight moved headings: in the reference as headings, in CLAUDE.md as index rows")
	for pair in MOVED:
		var head: String = pair[0]
		ok(_is_heading_line(_ir, head) == 1,
			"§1: `%s` is a heading %d times in the reference — it should be exactly once" % [
				head, _is_heading_line(_ir, head)])
		ok(_is_heading_line(_cm, head) == 0,
			"§1: `%s` is STILL a heading in CLAUDE.md — the rule did not move" % head)
		# Every surviving occurrence in CLAUDE.md is a table row. A prose
		# restatement would be a second copy of a rule, which is what let this
		# file contradict itself 1900 lines apart after CW's split.
		var rows := 0
		var other := 0
		for line in _cm.split("\n"):
			if not line.contains(head):
				continue
			if line.begins_with("| "):
				rows += 1
			else:
				other += 1
		ok(rows == 1 and other == 0,
			"§1: `%s` appears in CLAUDE.md as %d index rows and %d other lines — one row, nothing else" % [
				head, rows, other])
	print("  %d headings checked" % MOVED.size())


# ── §2 — AND THE RULE MOVED, NOT ONLY ITS TITLE ─────────────────────────────
func _s2_bodies() -> void:
	print("\n§2 — a BODY sentence out of each moved rule: in the reference, absent from CLAUDE.md")
	for pair in MOVED:
		var head: String = pair[0]
		var body: String = pair[1]
		ok(_ir.count(body) == 1,
			"§2: the body of `%s` reads %d times in the reference — the rule is missing or duplicated" % [
				head, _ir.count(body)])
		ok(_cm.count(body) == 0,
			"§2: the body of `%s` is STILL in CLAUDE.md — a rule in two files is two rules" % head)
	print("  %d body sentences checked, none of which an index row could carry" % MOVED.size())


# ── §3 — THE TIEBREAK RUNS ONE WAY, AND BOTH HALVES SAY SO ──────────────────
func _s3_the_tiebreak() -> void:
	print("\n§3 — there are not two files a batch must read")
	# THE HOLDERS ARE RE-READ FROM THE PATH LITERAL HERE RATHER THAN TAKEN OFF
	# `_cm` / `_ir`. `build_pin_manifest.py` attributes a pin by propagating the
	# identifier ASSIGNED from `res://…`, and a member var filled by `_cm = cm`
	# breaks that chain — so every literal below would have been a pin into a
	# tracked document that the manifest could not see, and `check_ed` could not
	# enforce. **AN INSTRUMENT'S TERRITORY IS A CLAIM** (EC §2), and this gate
	# is not exempt from it.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(cm.contains("THIS FILE IS THE REQUIRED READ"),
		"§3: CLAUDE.md no longer declares itself the required read")
	ok(cm.contains("docs/instrument-rules.md"),
		"§3: CLAUDE.md no longer names the reference file by path")
	ok(cm.contains("WHERE A RULE DOES BOTH, IT STAYS HERE"),
		"§3: CLAUDE.md no longer carries the one-way tiebreak")
	# THE NEEDLE DELIBERATELY DOES NOT OPEN WITH THE SENTENCE'S FIRST WORDS.
	# `check_ea` §3 forbids a literal matching `BATCH <1-3 caps>` pinned into
	# either rule file, and the full sentence reads "…A BATCH IS REQUIRED…" —
	# which that regex reads as the batch code `IS`. The gate is right to be
	# blunt about it and the needle is the cheaper half to move. Found by the
	# battery, because this gate did not exist when FA §1b's pre-pass was run.
	ok(ir.contains("REQUIRED TO READ IS `CLAUDE.md`"),
		"§3: the reference no longer points back at the required read")
	ok(ir.contains("It holds no rule about what the game may"),
		"§3: the reference no longer declares that it holds no game-content rule")
	# THE PROOF SHAPE IS RECORDED WHERE THE NEXT SPLIT WILL LOOK FOR IT.
	ok(ir.contains("NEVER PROVE A SPLIT BY COMPARING SIZES"),
		"§3: the reference no longer carries the rule that a size compare is not a rejoin proof")


# ── §4 — EF'S HAZARD, SWEPT LIVE ────────────────────────────────────────────
#
# EF proved by two-armed control that a pin can be satisfied by an INDEX ROW
# rather than by the rule it names, and FF added eight more rows. This walks
# the whole suite tree the way `check_ea` §3 does — matching the VARIABLE
# holding the file, not the literal, because a needle can sit three hundred
# lines below its read — and fails on any literal whose ONLY occurrence in
# `CLAUDE.md` is inside the index table. **AND SINCE GR §2 INSIDE EITHER
# INDEX**: the combat rules' nine rows are the same hazard.
func _s4_no_pin_lives_only_in_the_index() -> void:
	print("\n§4 — no needle any reader asserts into CLAUDE.md resolves only inside an index")
	var dir := DirAccess.open("res://")
	var files: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd") and (f.begins_with("check_") or f.begins_with("test_")):
				files.append(f)
	files.sort()
	ok(files.size() > 60, "§4: the sweep read %d suites and gates — the population has moved" % files.size())

	var assign := RegEx.new()
	assign.compile("var\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*:?=[^\\n]*res://CLAUDE\\.md")
	var readers := 0
	var scanned := 0
	var accused: Array = []
	for f2 in files:
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + f2))
		var names: Array = []
		for m in assign.search_all(src):
			var nm := m.get_string(1)
			if not names.has(nm):
				names.append(nm)
		if names.is_empty():
			continue
		readers += 1
		for nm2 in names:
			var call := RegEx.new()
			call.compile("\\b" + nm2 + "\\s*(?:\\.to_lower\\(\\))?\\.[A-Za-z_]+\\s*\\(\\s*\"([^\"]*)\"")
			for m2 in call.search_all(src):
				var lit := m2.get_string(1)
				if lit == "":
					continue
				scanned += 1
				var occ: Array = []
				var at := _cm.find(lit)
				while at >= 0:
					occ.append(at)
					at = _cm.find(lit, at + 1)
				if occ.is_empty():
					continue	# resolves nowhere: an or-group sibling or a
								# negative pin. Not this section's question.
				var outside := false
				for o in occ:
					if _outside_every_index(o):
						outside = true
				if not outside:
					accused.append("%s: %s (%d occurrence(s), all in an index)" % [f2, lit, occ.size()])
	for a in accused:
		ok(false, "§4: %s — the pin is satisfied by the INDEX and not by a rule" % a)
	ok(accused.is_empty(),
		"§4: every located needle resolves outside every index (%d literals across %d readers)" % [
			scanned, readers])
	# THE SWEEP PRINTS WHAT IT CHECKED. A regex matching no reader, or no
	# literal, reports a clean tree exactly as loudly as a clean tree.
	ok(readers >= 20,
		"§4: only %d files were found reading CLAUDE.md — the sweep is matching nothing" % readers)
	ok(scanned >= 40,
		"§4: only %d literals were swept — the call regex has stopped matching" % scanned)
	print("  CHECKED %d literals across %d readers; %d resolve only inside an index" % [
		scanned, readers, accused.size()])


# ── §5 — THE SUBJECT SEAM'S RESIDENCY (GR §2) ───────────────────────────────
#
# FF's §1 and §2 ask of its eight: the rule is a heading in the reference, it
# survives in `CLAUDE.md` as one row and nothing else, and a sentence out of its
# body proves the rule moved rather than only its title. §5 asks the same of
# GR's seam, DERIVED FROM THE INDEX rather than from a list typed here — a rule
# a later batch moves joins the check by getting its row, and one it drops is
# a row that names nothing:
#   · every row names a heading `docs/combat-rules.md` carries exactly once,
#     and in `CLAUDE.md` the row is the only line that names it;
#   · every rule heading in that file has exactly one row, so a rule moved
#     there without its row — one `CLAUDE.md` no longer points at — is caught;
#   · no line of a rule there stands verbatim in `CLAUDE.md`. A rule in two
#     files is two rules, and a line out of a body is the member no index row
#     carries. SIXTY CHARACTERS, the floor `check_fr` §2 reasons out.
# Each is collected and asserted ONCE, so the count does not move when a rule
# moves: the row count is printed, and floored at the nine GR moved.
func _s5_the_subject_seam() -> void:
	print("\n§5 — the subject seam: each combat index row names one rule, and no rule stands in both files")
	# The holders are read from the path literal HERE, on the assignment line,
	# so `build_pin_manifest.py` and `check_ea` §3 both see them (FF §2e).
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var cr := FileAccess.get_file_as_string("res://docs/combat-rules.md")
	ok(cr.length() > 10000, "§5: docs/combat-rules.md read back %d chars" % cr.length())
	# THE TWO FILES DECLARE THE SEAM, EACH FROM ITS OWN SIDE.
	ok(cm.contains("docs/combat-rules.md"),
		"§5: CLAUDE.md no longer names the combat rules by path")
	ok(cr.contains("REQUIRED TO READ IS `CLAUDE.md`"),
		"§5: the combat rules no longer point back at the required read")
	ok(cr.contains("THE SEAM IS WHAT A RULE IS ABOUT"),
		"§5: the combat rules no longer state the test that put a rule there")

	var rows: Array = []
	if _cidx_from >= 0 and _cidx_to > _cidx_from:
		for line in cm.substr(_cidx_from, _cidx_to - _cidx_from).split("\n"):
			if line.begins_with("| ") and not line.begins_with("| |"):
				rows.append(line.split("|")[1].strip_edges())
	ok(rows.size() >= 9,
		"§5: the combat index reads %d rows — GR moved nine, so the table or its parser has broken" % rows.size())
	# THE RULE HEADINGS OF THE REFERENCE, below its own header. The header holds
	# no `##` of its own, and the title is a single `#`.
	var body_at := cr.find("\n---\n")
	var heads: Array = []
	for line2 in cr.substr(maxi(body_at, 0)).split("\n"):
		if line2.begins_with("## ") or line2.begins_with("### "):
			heads.append(line2)
	var unnamed: Array = []
	var not_a_row: Array = []
	for core in rows:
		var n_heads := 0
		for h in heads:
			if String(h).contains(core):
				n_heads += 1
		if n_heads != 1:
			unnamed.append("%s (%d headings)" % [core, n_heads])
		var lines_cm := 0
		var row_cm := 0
		for line3 in cm.split("\n"):
			if line3.contains(core):
				lines_cm += 1
				if line3.begins_with("| "):
					row_cm += 1
		if lines_cm != 1 or row_cm != 1:
			not_a_row.append("%s (%d lines, %d rows)" % [core, lines_cm, row_cm])
	ok(unnamed.is_empty(),
		"§5: an index row does not name exactly one heading in docs/combat-rules.md: %s" % ", ".join(unnamed))
	ok(not_a_row.is_empty(),
		"§5: a moved rule's title is in CLAUDE.md as something other than its one row: %s" % ", ".join(not_a_row))
	var orphans: Array = []
	for h2 in heads:
		var n_rows := 0
		for core2 in rows:
			if String(h2).contains(core2):
				n_rows += 1
		if n_rows != 1:
			orphans.append("%s (%d rows)" % [String(h2).substr(0, 70), n_rows])
	ok(orphans.is_empty() and not heads.is_empty(),
		"§5: a rule in docs/combat-rules.md has no single row in CLAUDE.md's index: %s" % ", ".join(orphans))
	# NO RULE IN BOTH FILES. Headings and table rows are left out — a heading is
	# what the index is FOR — and so are blockquote markers' bare lines.
	var compared := 0
	var dupes: Array = []
	for raw in cr.substr(maxi(body_at, 0)).split("\n"):
		var line4 := String(raw).strip_edges()
		if line4.length() < 60 or line4.begins_with("#") or line4.begins_with("|"):
			continue
		compared += 1
		if cm.contains(line4):
			dupes.append(line4.substr(0, 60))
	ok(compared >= 200,
		"§5: only %d body lines were long enough to compare — the arm has gone vacuous" % compared)
	ok(dupes.is_empty(),
		"§5: %d line(s) of a rule in docs/combat-rules.md also stand in CLAUDE.md: %s" % [
			dupes.size(), " / ".join(dupes)])
	print("  %d rows, %d rule headings, %d body lines compared; %d unnamed, %d not a row, %d orphans, %d in both" % [
		rows.size(), heads.size(), compared, unnamed.size(), not_a_row.size(), orphans.size(), dupes.size()])
