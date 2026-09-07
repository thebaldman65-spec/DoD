# BATCH FF — THE INSTRUMENT RESIDUE FOLLOWS EF'S SEAM, AND THE INDEX IS PROVED
# NOT TO BE STANDING IN FOR THE RULES.
#
#   §1  THE EIGHT MOVED RULES LIVE IN THE REFERENCE AS HEADINGS, and appear in
#       `CLAUDE.md` only as INDEX ROWS
#   §2  AND THE RULE ITSELF MOVED, not just its title — a BODY sentence out of
#       each one is in the reference and is NOT in `CLAUDE.md`
#   §3  THE TIEBREAK STILL RUNS ONE WAY — both halves still declare which file
#       is the required read
#   §4  NO NEEDLE ANY READER ASSERTS INTO `CLAUDE.md` RESOLVES ONLY INSIDE THE
#       INDEX — EF's hazard, swept live rather than checked once
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

var _cm := ""
var _ir := ""
var _idx_from := -1
var _idx_to := -1


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
# `CLAUDE.md` is inside the index table.
func _s4_no_pin_lives_only_in_the_index() -> void:
	print("\n§4 — no needle any reader asserts into CLAUDE.md resolves only inside the index")
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
					if o < _idx_from or o >= _idx_to:
						outside = true
				if not outside:
					accused.append("%s: %s (%d occurrence(s), all in the index)" % [f2, lit, occ.size()])
	for a in accused:
		ok(false, "§4: %s — the pin is satisfied by the INDEX and not by a rule" % a)
	ok(accused.is_empty(),
		"§4: every located needle resolves outside the index (%d literals across %d readers)" % [
			scanned, readers])
	# THE SWEEP PRINTS WHAT IT CHECKED. A regex matching no reader, or no
	# literal, reports a clean tree exactly as loudly as a clean tree.
	ok(readers >= 20,
		"§4: only %d files were found reading CLAUDE.md — the sweep is matching nothing" % readers)
	ok(scanned >= 40,
		"§4: only %d literals were swept — the call regex has stopped matching" % scanned)
	print("  CHECKED %d literals across %d readers; %d resolve only in the index" % [
		scanned, readers, accused.size()])
