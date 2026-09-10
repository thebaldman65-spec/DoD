# BATCH FS — THE DOC-vs-DOC PAIRING CHECK.
#
#   §1  A §7 HEADING NAMES THE TREE ITS TABLE LISTS
#   §2  A COUNT IN A TABLE'S HEADING EQUALS THE ROWS IN THAT TABLE
#   §3  THE EXTRACTORS ARE STILL EXTRACTING (the liveness arm)
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# FR read every numeric claim in `master.html` against the code — 1,265
# mechanical comparisons across the talent tables, the ability stat lines, the
# bestiary and the pool tables — and found **3 raw flags and 0 true defects**.
# The part of that document which names a constant is already right, and FR's
# recommendation was therefore that the value gate is **not worth building**:
# it would have caught **zero** of the fourteen defects that batch found.
#
# **WHAT IT RECOMMENDED INSTEAD IS THIS, AND THE ARGUMENT IS THAT THE LARGEST
# FINDING NEEDED NO CODE AT ALL.** Eight of the twelve §7 talent headings sat
# above the WRONG TREE's table — the Holy heading introduced the Pyromancer's
# tree, the Devout's the Cryomancer's, and so on — **while every one of the 324
# cells was correct, name for name and figure for figure.** A document can be
# right line by line and still tell a reader something false, and that is
# exactly how a brief comes to read the right numbers under the wrong name.
# No check that compares a value against a constant can see it. A check that
# compares two parts of the same document can.
#
# ── WHAT THIS GATE CANNOT SEE, SAID FIRST ───────────────────────────────────
# **A HEADING THAT NAMES THE WRONG TREE IS MECHANICAL. A HEADING THAT NAMES THE
# RIGHT TREE OVER A SUBTLY WRONG TABLE IS NOT.** This gate asserts that two
# parts of the document AGREE. It cannot assert that either is TRUE:
#
#   · If a heading and its table were BOTH re-pointed at the wrong spec, they
#     agree and this gate is silent. Only `master.html` §7 against
#     `Talents.desc_for()` sees that, and FR measured all 324 cells clean.
#   · If a lane were RENAMED in the code and in neither place here, the two
#     halves still agree. **This gate is doc-vs-doc by construction** — that is
#     what makes it cheap and what makes its failure mode noise rather than
#     silence, and it is also its ceiling.
#   · It reads the LANE NAMES and the ROW COUNTS. It reads no cell. A wrong
#     magnitude inside a correctly-paired table is invisible here.
#   · §2 asserts that a stated count matches the rows the document actually
#     carries. It cannot say whether the population the document chose to
#     catalogue is the right one — §6b catalogues 127 of a 154-card draft on
#     purpose, and which 27 are left out is an authoring decision.
#
# **AND THE FAILURE MODE IS THE REASON THIS SHAPE WAS THE ONE WORTH BUILDING.**
# FR's doc-vs-code instruments all failed toward FEWER findings — a regex
# needing a closing paren, a curly apostrophe, a line break inside "Speed\n125",
# a fixed-width window running into the next card's numbers — and **every one of
# those holes printed a clean zero.** A gate that has quietly stopped asking
# reads exactly like a clean one. §3 is here because this gate has the same
# exposure: both arms below pass by finding NOTHING.
#
# ── AND THE EXTRACTOR MUST READ UNWRAPPED TEXT, WHICH IS NOT A DETAIL ───────
# **THE FIRST DRAFT OF §1 READ NINE HEADINGS OF TWELVE AND REPORTED FOUR
# MISMATCHES, ALL FOUR OF THEM FALSE.** Three headings — the Arcanist's, the
# Holy's and the Devout's — wrap across a line break in the source, so a
# line-anchored match skipped them, and the nine it did find were then zipped
# against twelve tables and slid three places out of step. **It looked exactly
# like a real finding.** Everything below is matched on a WHITESPACE-FLATTENED
# copy of §7 for that reason, and §3 asserts the population is twelve.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fs.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

const DOC := "res://docs/master.html"

# The section boundaries, by the document's own headings. If either moves this
# gate reds at §0 rather than silently reading an empty slice.
const S7_OPEN := "<h2>7. Talents</h2>"
const S7_CLOSE := "<h2>8. Economy</h2>"
const S6B_ANCHOR := "drafted abilities catalogued here"

# THE POPULATIONS, PINNED. Twelve specs and one row of `<th>`s each. These are
# floors-as-equalities on purpose: the tree count is a settled fact of the game
# (`3 lanes x 8 rows + a capstone`, twelve specs), and a thirteenth spec is a
# thing a batch does deliberately and would come here to say so.
const SPEC_TREES := 12
const LANES_PER_TREE := 3


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _rx(pattern: String) -> RegEx:
	var r := RegEx.new()
	r.compile(pattern)
	return r


# WHITESPACE-FLATTENED. Every arm below reads this and never the raw file.
func _flat(s: String) -> String:
	return _rx("\\s+").sub(s, " ", true)


func _slice(doc: String, open_at: String, close_at: String) -> String:
	var a := doc.find(open_at)
	var b := doc.find(close_at, a + 1)
	if a < 0 or b < 0:
		return ""
	return doc.substr(a, b - a)


func _initialize() -> void:
	await process_frame
	print("BATCH FS — THE DOC-vs-DOC PAIRING CHECK")
	print("  IT ASSERTS THAT TWO PARTS OF ONE DOCUMENT AGREE.")
	print("  IT CANNOT ASSERT THAT EITHER IS TRUE — a heading and a table that")
	print("  are BOTH wrong agree, and this gate is silent on them. The header")
	print("  of this file states the boundary in full.")
	var doc := FileAccess.get_file_as_string(DOC)
	ok(doc.length() > 0, "§0: docs/master.html is missing or empty")
	if doc.length() == 0:
		_g.report(self)
		return
	var s7 := _slice(doc, S7_OPEN, S7_CLOSE)
	ok(s7.length() > 0,
		"§0: §7 does not slice — `%s` .. `%s` no longer bound a section, so every arm below would read an empty string"
			% [S7_OPEN, S7_CLOSE])
	var heads: Array = []
	var tables: Array = []
	var order := ""
	if s7.length() > 0:
		var walked := _walk_s7(_flat(s7))
		heads = walked[0]
		tables = walked[1]
		order = String(walked[2])
	_s1_pairing(heads, tables, order)
	_s2_counts(_flat(doc))
	_s3_liveness(doc, heads, tables)
	_g.report(self)


# ── THE ONE WALK BOTH §1 AND §3 READ ────────────────────────────────────────
#
# ONE regex alternation over the flattened section, so headings and tables come
# back INTERLEAVED IN DOCUMENT ORDER. Two separate searches would each be in
# order and would say nothing about how they sit relative to one another, which
# is the entire question: FR's defect was a heading in the wrong PLACE, not a
# heading with the wrong CONTENT.
#
# A LANE HEADING IS A `<p>` WITH EXACTLY THREE ALL-CAPS BOLD SPANS IN IT. That
# is a derived rule and not a list of twelve names: §7 holds other `<p><b>X</b>
# — ...` paragraphs (the reassignable-points note is one) and they carry zero,
# while the Occultist's heading carries several bold spans that are NOT lanes
# and every one of them has a lower-case letter in it. §3 asserts the rule
# selects exactly twelve.
func _walk_s7(flat: String) -> Array:
	var heads: Array = []
	var tables: Array = []
	var order := ""
	var lane_b := _rx("<b>([A-Z][A-Z '’-]*?)</b>")
	var thc := _rx("<th>(.*?)</th>")
	# Either a paragraph opening `<p><b>Name</b> —` or a table's header row.
	# The dash is written BOTH ways in this document, so both are matched.
	var tok := _rx("<p><b>([A-Za-z][A-Za-z ]*?)</b> (?:—|&mdash;) (.*?)</p>|<tr><th>Row</th>(.*?)</tr>")
	for m in tok.search_all(flat):
		if m.get_string(1) != "":
			var lanes: Array = []
			for l in lane_b.search_all(m.get_string(2)):
				lanes.append(l.get_string(1))
			if lanes.size() == LANES_PER_TREE:
				heads.append([m.get_string(1), lanes])
				order += "H"
		else:
			var cols: Array = []
			for c in thc.search_all(m.get_string(3)):
				cols.append(c.get_string(1))
			tables.append(cols)
			order += "T"
	return [heads, tables, order]


# ── §1 — A HEADING NAMES THE TREE ITS TABLE LISTS ───────────────────────────
func _s1_pairing(heads: Array, tables: Array, order: String) -> void:
	print("\n§1 — a §7 heading names the tree whose lanes the table under it lists")
	ok(heads.size() == SPEC_TREES,
		"§1: found %d lane headings in §7, expected %d — THE EXTRACTOR IS THE POPULATION, and a short read pairs the wrong table with the wrong heading and calls it a finding"
			% [heads.size(), SPEC_TREES])
	ok(tables.size() == SPEC_TREES,
		"§1: found %d tree tables in §7, expected %d" % [tables.size(), SPEC_TREES])
	# THE ALTERNATION ITSELF. A heading that has drifted BELOW its table still
	# pairs by index and would read clean; the shape says so directly.
	var want := ""
	for i in range(SPEC_TREES):
		want += "HT"
	ok(order == want,
		"§1: §7 does not read heading-then-table twelve times over (got `%s`) — a heading that has moved past its own table still pairs by index"
			% order)
	if heads.size() != tables.size():
		print("    counts disagree; the per-tree comparison is skipped rather than zipped out of step")
		return
	var mismatched: Array = []
	var seen_specs := {}
	for i in range(heads.size()):
		var spec := String(heads[i][0])
		var lanes: Array = heads[i][1]
		var cols: Array = tables[i]
		seen_specs[spec] = int(seen_specs.get(spec, 0)) + 1
		# THE SAME FUNCTION §3 DRIVES. A control on a private copy of the
		# comparison proves nothing about the copy that runs here.
		var same := _lanes_agree(lanes, cols)
		ok(same,
			"§1: the %s heading names %s and the table beneath it lists %s — ONE OF THE TWO IS ABOVE THE WRONG TREE"
				% [spec, lanes, cols])
		if not same:
			mismatched.append(spec)
		print("    %-14s %-46s %s" % [spec, ", ".join(PackedStringArray(lanes)),
			"" if same else "<-- against " + ", ".join(PackedStringArray(cols))])
	# AND NO SPEC IS INTRODUCED TWICE. Eight headings permuted among themselves
	# leave every name present exactly once, so this is not what caught FR's
	# defect — it catches the OTHER shape, a heading duplicated or dropped by a
	# repair, which is precisely what a permutation edit risks.
	var dupes: Array = []
	for s in seen_specs:
		if int(seen_specs[s]) != 1:
			dupes.append("%s x%d" % [s, int(seen_specs[s])])
	ok(dupes.is_empty(),
		"§1: a spec heads more than one tree in §7 (%s)" % ", ".join(PackedStringArray(dupes)))
	print("    %d of %d headings pair with the table beneath them%s" % [
		heads.size() - mismatched.size(), heads.size(),
		"" if mismatched.is_empty() else "; MIS-PAIRED: " + ", ".join(PackedStringArray(mismatched))])


# ── §2 — A COUNT IN A HEADING EQUALS THE ROWS UNDER IT ──────────────────────
#
# §6b states its own size three times in one paragraph, in words: the table
# catalogues N drafted abilities, of which S are spec cards and C class-wide,
# out of a draft of D. **FR found that paragraph claiming 142 / 118 / 24 over a
# table of 127 / 103 / 24 and pools of 154** — three numbers wrong in one
# sentence, none of which any doc-vs-code check would look at, because the
# sentence names no constant.
#
# THE NUMBERS ARE READ AS WORDS AND NOT PINNED AS LITERALS. A batch that
# authors a card writes the new word in the paragraph and the arm follows it;
# a batch that authors a card and does NOT is what this exists to catch.
func _s2_counts(flat: String) -> void:
	print("\n§2 — a count in §6b's heading equals the rows in §6b's table")
	var rx_total := _rx("The ([a-z ]+(?:-[a-z]+)?) drafted abilities catalogued here")
	var rx_split := _rx("The ([a-z ]+(?:-[a-z]+)?) spec cards come first; the ([a-z ]+(?:-[a-z]+)?) class-wide ones close the table")
	var rx_draft := _rx("The draft itself is ([a-z ]+(?:-[a-z]+)?)</b>")
	var rx_rest := _rx("the ([a-z ]+(?:-[a-z]+)?) not listed here")
	var m_total := rx_total.search(flat)
	var m_split := rx_split.search(flat)
	var m_draft := rx_draft.search(flat)
	var m_rest := rx_rest.search(flat)
	ok(m_total != null and m_split != null and m_draft != null and m_rest != null,
		"§2: §6b's four stated counts no longer match their sentences (total %s / split %s / draft %s / rest %s) — the arms below would read nothing"
			% [m_total != null, m_split != null, m_draft != null, m_rest != null])
	if m_total == null or m_split == null or m_draft == null or m_rest == null:
		return
	var said_total := _words_to_int(m_total.get_string(1))
	var said_spec := _words_to_int(m_split.get_string(1))
	var said_class := _words_to_int(m_split.get_string(2))
	var said_draft := _words_to_int(m_draft.get_string(1))
	var said_rest := _words_to_int(m_rest.get_string(1))
	ok(said_total > 0 and said_spec > 0 and said_class > 0 and said_draft > 0 and said_rest > 0,
		"§2: a stated count did not parse from its words (%d / %d + %d / %d / %d)"
			% [said_total, said_spec, said_class, said_draft, said_rest])
	var counted := _count_6b_rows(flat)
	var rows := int(counted[0])
	var spec_rows := int(counted[1])
	var class_rows := int(counted[2])
	ok(rows > 0, "§2: §6b's table parsed to zero rows, so every count below is vacuous")
	ok(said_total == rows,
		"§2: §6b says it catalogues %d drafted abilities and the table under it has %d rows"
			% [said_total, rows])
	ok(said_spec == spec_rows,
		"§2: §6b says %d spec cards and the table has %d rows before its first class-wide band"
			% [said_spec, spec_rows])
	ok(said_class == class_rows,
		"§2: §6b says %d class-wide cards and the table has %d rows in its class-wide bands"
			% [said_class, class_rows])
	# THE PARAGRAPH'S OWN ARITHMETIC, which is a fifth thing that can drift on
	# its own: the split must sum to the total, and the draft minus the table
	# must be the remainder the same sentence names.
	ok(said_spec + said_class == said_total,
		"§2: §6b's own split does not sum — %d spec + %d class-wide is not %d"
			% [said_spec, said_class, said_total])
	ok(said_draft - said_total == said_rest,
		"§2: §6b says the draft is %d and the table %d, and calls the remainder %d — the subtraction is %d"
			% [said_draft, said_total, said_rest, said_draft - said_total])
	print("    stated %d = %d spec + %d class-wide, of a %d-card draft (%d not listed)"
		% [said_total, said_spec, said_class, said_draft, said_rest])
	print("    counted %d = %d spec + %d class-wide, over %d bands"
		% [rows, spec_rows, class_rows, int(counted[3])])


# The table under §6b's anchor: its four-column data rows, split at the first
# band whose label says class-wide. A band row is `<td colspan="4">`; a card row
# opens `<td>`. Returns [rows, spec_rows, class_rows, bands].
func _count_6b_rows(flat: String) -> Array:
	var a := flat.find(S6B_ANCHOR)
	if a < 0:
		return [0, 0, 0, 0]
	var t0 := flat.find("<table", a)
	var t1 := flat.find("</table>", t0 + 1)
	if t0 < 0 or t1 < 0:
		return [0, 0, 0, 0]
	var tbl := flat.substr(t0, t1 - t0)
	var rows := 0
	var spec_rows := 0
	var class_rows := 0
	var bands := 0
	var in_class := false
	for m in _rx("<tr>(.*?)</tr>").search_all(tbl):
		var body := m.get_string(1)
		if body.contains("colspan=\"4\""):
			bands += 1
			# THE BAND LABELS ARE WRITTEN BOTH WAYS IN THIS TABLE — two say
			# `Class-wide &mdash;` and two say `Class-wide —` — so the test is
			# on the words that precede the dash and never on the dash.
			if body.to_lower().contains("class-wide"):
				in_class = true
			continue
		if not body.begins_with("<td>") and not body.begins_with("<td "):
			continue
		rows += 1
		if in_class:
			class_rows += 1
		else:
			spec_rows += 1
	return [rows, spec_rows, class_rows, bands]


# ── THE WORD-NUMBER READER ──────────────────────────────────────────────────
# Zero is not a legal reading here — every caller treats 0 as "did not parse"
# and says so — because a silent zero is how a count arm goes vacuous.
func _words_to_int(phrase: String) -> int:
	const UNITS := {
		"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6,
		"seven": 7, "eight": 8, "nine": 9, "ten": 10, "eleven": 11,
		"twelve": 12, "thirteen": 13, "fourteen": 14, "fifteen": 15,
		"sixteen": 16, "seventeen": 17, "eighteen": 18, "nineteen": 19,
	}
	const TENS := {
		"twenty": 20, "thirty": 30, "forty": 40, "fifty": 50, "sixty": 60,
		"seventy": 70, "eighty": 80, "ninety": 90,
	}
	var total := 0
	var current := 0
	for w in phrase.to_lower().replace("-", " ").split(" ", false):
		var word := String(w).strip_edges()
		if word == "and" or word == "":
			continue
		if UNITS.has(word):
			current += int(UNITS[word])
		elif TENS.has(word):
			current += int(TENS[word])
		elif word == "hundred":
			current = maxi(current, 1) * 100
		elif word == "thousand":
			total += maxi(current, 1) * 1000
			current = 0
		else:
			return 0  # an unreadable word is a failure, never a partial sum
	return total + current


# ── §3 — THE EXTRACTORS ARE STILL EXTRACTING ────────────────────────────────
#
# BOTH ARMS ABOVE PASS BY FINDING NOTHING — no mis-paired heading, no count
# that disagrees. **A gate whose clean state is "no findings" reads identically
# to a gate that has stopped looking**, and this gate's own first draft proved
# the point: a line-anchored heading match read 9 of 12 and printed four
# confident false mismatches. Every population §1 and §2 depend on is asserted
# here, and the word reader is driven on values it cannot get wrong.
func _s3_liveness(doc: String, heads: Array, tables: Array) -> void:
	print("\n§3 — the extractors, armed")
	ok(doc.contains(S7_OPEN) and doc.contains(S7_CLOSE),
		"§3: §7's own boundaries are gone from the document")
	ok(doc.contains(S6B_ANCHOR),
		"§3: §6b's anchor `%s` is gone, so §2 reads nothing" % S6B_ANCHOR)
	ok(heads.size() == SPEC_TREES and tables.size() == SPEC_TREES,
		"§3: the §7 walk returned %d headings and %d tables — §1's comparison is only as good as this"
			% [heads.size(), tables.size()])
	# THE WRAPPED HEADINGS, BY NAME. These three wrap across a line break in the
	# source and are the three a line-anchored extractor drops. They are pinned
	# so the flattening cannot be quietly removed.
	var found: Array = []
	for h in heads:
		found.append(String(h[0]))
	for spec in ["Arcanist", "Holy", "Devout"]:
		ok(found.has(spec),
			"§3: the %s heading is not in the walk — it wraps across a line break in the source, and its absence means the flattening has stopped happening"
				% spec)
	# THE WORD READER, both ways. A reader that returned a constant would pass
	# every arm in §2.
	ok(_words_to_int("one hundred and twenty-seven") == 127,
		"§3: the word reader misreads `one hundred and twenty-seven`")
	ok(_words_to_int("one hundred and fifty-four") == 154,
		"§3: the word reader misreads `one hundred and fifty-four`")
	ok(_words_to_int("twenty-four") == 24, "§3: the word reader misreads `twenty-four`")
	ok(_words_to_int("one hundred and three") == 103,
		"§3: the word reader misreads `one hundred and three`")
	ok(_words_to_int("not a number") == 0,
		"§3: the word reader returns a number for a phrase that holds none")
	# AND THE PAIRING COMPARISON ITSELF, driven on a pair it must reject. §1
	# passes by finding nothing; this is the arm that says it would find one.
	var probe_same := _lanes_agree(["RUIN", "MADNESS", "LEECH"], ["Ruin", "Madness", "Leech"])
	var probe_diff := _lanes_agree(["RUIN", "MADNESS", "LEECH"], ["Ruin", "Madness", "Entropy"])
	ok(probe_same, "§3: the lane comparison rejects a pair that differs only in case")
	ok(not probe_diff, "§3: the lane comparison accepts a table that lists a different lane")


func _lanes_agree(lanes: Array, cols: Array) -> bool:
	if lanes.size() != cols.size():
		return false
	for j in range(lanes.size()):
		if String(lanes[j]).to_upper() != String(cols[j]).to_upper():
			return false
	return true
