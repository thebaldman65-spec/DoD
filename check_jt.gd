# BATCH JT — THE NEWEST REPORT ENDS WITH WHAT THE NEXT DECISION RECORD OWES.
#
#   §0   THE RULE STILL SAYS WHAT THIS GATE READS FOR, AND THE POPULATION IS LIVE
#   §1   THE NEWEST REPORT's LAST BLOCK IS THE CLOSING BLOCK, AND IT NAMES THE FOUR SECTIONS
#
# ── WHY THIS GATE EXISTS, AND WHY IT IS SO SMALL ────────────────────────────
# `docs/ways-of-working.md` ends every report with a block addressed to the next
# decision record — its four sections, and what the batch found that the record
# must not get wrong — because the record's author reads the report immediately
# before writing the next record. **A rule only a reader remembers is the shape
# that has failed every time here**, so it is held by checks:
#   1. THE PRIMARY HOLD IS THE REPORT's LANDING CHECK (`CLAUDE.md`'s report block:
#      a second grep, on the same finished report as the token grep, asks for the
#      heading). It runs before the report lands, so it has no latency.
#   2. THIS GATE IS THE BACKSTOP. It reads the newest report in the battery, so a
#      skipped landing check is found a batch late — and cannot persist.
# It is two reads of one file — the last heading, and the four sections' words
# in the block under it — plus the two arms that keep it honest (§0): the
# rule's own heading, so the gate and the rule cannot drift apart, and the
# population, so an empty listing does not read as a clean one.
#
# ── WHICH REPORT IS THE NEWEST ──────────────────────────────────────────────
# A report is `docs/reports/<CODE>.md` with an upper-case code alone in its name
# (the reports' own shape, `check_jc` §3's listing; the kept tables, `XX-*.md`
# and `XX-*.tsv`, are not reports). The codes run A … Z, AA … ZZ, so the newest
# is the last in that order — a longer code after a shorter, alphabetical within
# a length. **A file's time is not read**: a clone stamps every file alike.
# **It names the report it picked** (`docs/instrument-rules.md`: a gate that
# selects its subject by a superlative names the subject it picked).
#
# ── WHAT IT CANNOT DO, SAID FIRST ───────────────────────────────────────────
# It reads the newest report only. A report that lacked the block and was
# followed by one that carries it is not found later; the landing check holds
# that, and the designer's own reading is the third layer. It reads that the
# heading stands, last, and names the four sections — never whether the six
# lines are right, which is the reader's. Its four words match as substrings
# (*lane* inside *lanes*), and any line opening with `#` counts as a heading, so
# a fenced comment after the block would red it falsely: the report fences none.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

const WOW := "res://docs/ways-of-working.md"
const REPORTS := "res://docs/reports"
const HEADING := "WHAT THE NEXT DECISION RECORD OWES"
# THE FOUR SECTIONS, by the words the rule names them in, each read in the block
# case set aside: THE LANE, WHAT WAS DECIDED, WHAT IT WAS WRITTEN FROM, THE OPEN
# QUESTIONS.
const SECTIONS := ["lane", "decided", "written from", "open question"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH JT — THE NEWEST REPORT ENDS WITH WHAT THE NEXT DECISION RECORD OWES")
	var codes := _s0_the_rule_and_the_population()
	_s1_the_closing_block(codes)
	_g.report(self)


func _code_order(a: String, b: String) -> bool:
	if a.length() != b.length():
		return a.length() < b.length()
	return a < b


# ── §0 — THE RULE, AND THE POPULATION ──────────────────────────────────────
func _s0_the_rule_and_the_population() -> Array:
	print("\n§0 — the rule names the block this gate reads for, and the reports are listed")
	var wow := FileAccess.get_file_as_string(WOW)
	ok(wow.contains(HEADING),
		"§0: docs/ways-of-working.md no longer names `%s` — the gate reads for a block no rule asks for" % HEADING)
	var codes: Array = []
	var rx := RegEx.create_from_string("^[A-Z]+\\.md$")
	for f in DirAccess.get_files_at(REPORTS):
		if rx.search(f) != null:
			codes.append(f.get_basename())
	codes.sort_custom(_code_order)
	print("    %d reports listed, %s to %s" % [codes.size(), codes[0] if codes.size() > 0 else "-", codes[-1] if codes.size() > 0 else "-"])
	ok(codes.size() >= 100, "§0: the reports folder lists %d reports — the listing has stopped reading it" % codes.size())
	return codes


# ── §1 — THE NEWEST REPORT's CLOSING BLOCK ─────────────────────────────────
func _s1_the_closing_block(codes: Array) -> void:
	print("\n§1 — the newest report ends with the closing block, and the block names the four sections")
	if codes.is_empty():
		ok(false, "§1: no report to read")
		return
	var newest := String(codes[-1])
	var text := FileAccess.get_file_as_string("%s/%s.md" % [REPORTS, newest])
	print("    the newest report: %s.md (%d B)" % [newest, text.length()])
	var lines := text.split("\n")
	var last_head := -1
	for i in lines.size():
		if String(lines[i]).begins_with("#"):
			last_head = i
	var head := String(lines[last_head]) if last_head >= 0 else ""
	print("    its last heading: %s" % head.substr(0, 90))
	ok(head.contains(HEADING),
		"§1: %s.md's last block is not headed `%s` (its last heading: %s)" % [newest, HEADING, head.substr(0, 60)])
	if not head.contains(HEADING):
		return
	var block := "\n".join(lines.slice(last_head)).to_lower()
	var missing: Array = []
	for s in SECTIONS:
		if not block.contains(String(s)):
			missing.append(s)
	print("    the block names %d of the %d sections" % [SECTIONS.size() - missing.size(), SECTIONS.size()])
	ok(missing.is_empty(), "§1: %s.md's closing block does not name %s" % [newest, ", ".join(PackedStringArray(missing))])
