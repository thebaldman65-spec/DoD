# BATCH FS — THE DOC-vs-DOC PAIRING CHECK.
#
#   §1  §7'S STATED SHAPE AGREES WITH THE TREE TABLE UNDER IT (re-pointed at FX)
#   §2  A COUNT IN A TABLE'S HEADING EQUALS THE ROWS IN THAT TABLE
#   §3  THE EXTRACTORS ARE STILL EXTRACTING (the liveness arm)
#
# ── FX: §1's SUBJECT WENT WITH THE TWELVE TREES, AND ITS QUESTION DID NOT ────
# §1 used to pair each of twelve §7 lane headings with the tree table beneath it.
# FX deleted the twelve spec trees. §7 now carries ONE tree of twenty-seven
# nodes, so there is no heading left to put above the wrong table, and the
# twelve-way pairing has no subject anywhere a check can read (DG §2).
# **Deleted with it, and counted: 22 checks.** §1 lost its twelve per-tree
# pairings, its three twelve-shaped structure checks and its duplicate-heading
# check (16). §3 lost its twelve-and-twelve walk check, its three wrapped-heading
# names and its two lane probes (6).
#
# **THE QUESTION SURVIVES, AND §1 NOW ASKS IT OF THE ONE TREE:** does what §7
# SAYS about its tree agree with the table §7 prints under it? That covers the
# node count, the tiers and their size, each tier's price and the total. It is
# still two parts of one document, and it is still FR's defect in its new shape:
# a table can be right row by row and still sit under a sentence that describes
# a different tree. §1 adds 10 checks and §3 adds 6, so the gate goes 39 -> 33.
# Nothing in §1 is pinned to the code's 27, because `check_fx` §1 owns that.
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
# **A SENTENCE THAT DESCRIBES THE WRONG TREE IS MECHANICAL. A SENTENCE THAT
# DESCRIBES THE RIGHT TREE OVER A SUBTLY WRONG TABLE IS NOT.** This gate asserts
# that two parts of the document AGREE. It cannot assert that either is TRUE:
#
#   · If the sentence and the table were BOTH changed to the same wrong shape,
#     they agree and this gate is silent. Only `master.html` §7 against the
#     code sees that.
#   · It reads the stated shape and the TIER column. It reads no node's text.
#     A wrong magnitude inside a correctly-shaped table is invisible here.
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
# MISMATCHES, ALL FOUR OF THEM FALSE.** Three headings wrapped across a line
# break in the source, so a line-anchored match skipped them, and the nine it did
# find were then zipped against twelve tables and slid three places out of step.
# **It looked exactly like a real finding.** Everything below is matched on a
# WHITESPACE-FLATTENED copy of the document for that reason. The one tree's node
# count and its prices wrap across a line break in the source in the same way,
# and §3 asserts both are read.
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

# §7's two tables, by their header rows. A header row renamed is a table this
# gate can no longer find, and §1 and §3 both say so rather than reading zero.
const TREE_HEAD := "<tr><th>Tier</th><th>Node</th><th>What it does</th></tr>"
const GATE_HEAD := "<tr><th>Tier</th><th>Open by difficulty after</th></tr>"


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
	print("  IT CANNOT ASSERT THAT EITHER IS TRUE — a sentence and a table that")
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
	var shape := _s1_shape(_flat(s7))
	_s2_counts(_flat(doc))
	_s3_liveness(doc, shape)
	_g.report(self)


# ── THE TWO TABLES §1 READS ─────────────────────────────────────────────────
# The tree table's rows as [tier, name], in document order, and the tiers the
# difficulty table opens. Each is bounded by its own header row and the next
# `</table>`, so a row of one can never be read as a row of the other.
func _tree_rows(flat7: String) -> Array:
	var a := flat7.find(TREE_HEAD)
	if a < 0:
		return []
	var b := flat7.find("</table>", a)
	if b < 0:
		return []
	var out: Array = []
	for m in _rx("<tr><td>([0-9]+)</td><td>(.*?)</td><td>(.*?)</td></tr>").search_all(flat7.substr(a, b - a)):
		out.append([int(m.get_string(1)), m.get_string(2)])
	return out


func _gate_tiers(flat7: String) -> Array:
	var a := flat7.find(GATE_HEAD)
	if a < 0:
		return []
	var b := flat7.find("</table>", a)
	if b < 0:
		return []
	var out: Array = []
	# The fresh-save row carries a dash, not a tier, and is not a tier opened.
	for m in _rx("<tr><td>([0-9]+)</td>").search_all(flat7.substr(a, b - a)):
		out.append(int(m.get_string(1)))
	return out


# ── §1 — §7'S STATED SHAPE AGREES WITH THE TREE TABLE UNDER IT ─────────────
#
# Every figure is read as the document states it — the node count and the tiers
# in WORDS, the prices and the total as digits — and each is compared with what
# the table under it actually carries. **The per-tier comparison is ONE
# assertion, not one per tier**, so this gate's count does not rise and fall with
# how many tiers a sentence happens to describe (`check_es` §4's reason).
func _s1_shape(flat7: String) -> Dictionary:
	print("\n§1 — §7's stated shape agrees with the tree table under it")
	var m_nodes := _rx("one talent tree of <b>([a-z]+(?:-[a-z]+)?) nodes</b>").search(flat7)
	var m_tiers := _rx("Structure: ([a-z]+) TIERS of ([a-z]+)\\.").search(flat7)
	var m_price := _rx("tier 1 cells cost ([0-9]+) points?, tier 2 cost ([0-9]+), tier 3 cost ([0-9]+)").search(flat7)
	var m_total := _rx("the whole tree is <b>([0-9]+) points</b>").search(flat7)
	var read_all := m_nodes != null and m_tiers != null and m_price != null and m_total != null
	ok(read_all,
		"§1: §7's stated shape no longer matches its sentences (nodes %s / tiers %s / prices %s / total %s) — the arms below would read nothing"
			% [m_nodes != null, m_tiers != null, m_price != null, m_total != null])
	var rows := _tree_rows(flat7)
	ok(rows.size() > 0, "§1: §7's tree table parsed to zero rows, so every comparison below is vacuous")
	var shape := {"nodes": 0, "rows": rows.size(), "prices_read": m_price != null}
	if not read_all:
		return shape
	var said_nodes := _words_to_int(m_nodes.get_string(1))
	var said_tiers := _words_to_int(m_tiers.get_string(1))
	var said_per := _words_to_int(m_tiers.get_string(2))
	var prices := [int(m_price.get_string(1)), int(m_price.get_string(2)), int(m_price.get_string(3))]
	var said_total := int(m_total.get_string(1))
	shape["nodes"] = said_nodes
	ok(said_nodes == rows.size(),
		"§1: §7 says its tree has %d nodes and the table under it lists %d" % [said_nodes, rows.size()])
	var per_tier := {}
	var column: Array = []
	var seen := {}
	var dupes: Array = []
	for r in rows:
		var t := int(r[0])
		per_tier[t] = int(per_tier.get(t, 0)) + 1
		column.append(t)
		var nm := String(r[1])
		if seen.has(nm):
			dupes.append(nm)
		seen[nm] = true
	ok(per_tier.size() == said_tiers,
		"§1: §7 says %d tiers and its table lists %d distinct tiers (%s)" % [said_tiers, per_tier.size(), per_tier.keys()])
	var short: Array = []
	for t in per_tier:
		if int(per_tier[t]) != said_per:
			short.append("tier %d lists %d" % [int(t), int(per_tier[t])])
	ok(short.is_empty(),
		"§1: §7 says a tier is %d nodes and the table disagrees: %s" % [said_per, ", ".join(PackedStringArray(short))])
	# THE SAME FUNCTION §3 DRIVES. A control on a private copy of the comparison
	# proves nothing about the copy that runs here.
	ok(_tiers_in_order(column),
		"§1: the tier column of §7's table goes backwards — a node is printed inside another tier's band, which is FR's heading-over-the-wrong-table in the one tree's shape")
	var priced := 0
	for t in per_tier:
		if int(t) >= 1 and int(t) <= prices.size():
			priced += int(per_tier[t]) * int(prices[int(t) - 1])
	ok(priced == said_total,
		"§1: the table's rows at §7's stated prices come to %d points, and §7 says the whole tree is %d" % [priced, said_total])
	ok(said_tiers * said_per == said_nodes,
		"§1: §7's own arithmetic does not close — %d tiers of %d is not %d nodes" % [said_tiers, said_per, said_nodes])
	ok(dupes.is_empty(), "§1: a node is printed twice in §7's table (%s)" % ", ".join(PackedStringArray(dupes)))
	var opened := _gate_tiers(flat7)
	var want: Array = []
	for t in range(1, said_tiers + 1):
		want.append(t)
	ok(opened == want,
		"§1: §7's difficulty table opens tiers %s, and the section describes %d tiers" % [opened, said_tiers])
	print("    stated  %d nodes = %d tiers of %d, at %s a cell, %d points" % [said_nodes, said_tiers, said_per, prices, said_total])
	print("    counted %d rows %s, %d points at the stated prices; the difficulty table opens %s" % [rows.size(), per_tier, priced, opened])
	return shape


func _tiers_in_order(column: Array) -> bool:
	var last := 0
	for t in column:
		if int(t) < last:
			return false
		last = int(t)
	return true


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
# BOTH ARMS ABOVE PASS BY FINDING NOTHING — no disagreeing shape, no count that
# disagrees. **A gate whose clean state is "no findings" reads identically to a
# gate that has stopped looking**, and this gate's own first draft proved the
# point: a line-anchored heading match read 9 of 12 and printed four confident
# false mismatches. Every population §1 and §2 depend on is asserted here, and
# the word reader is driven on values it cannot get wrong.
func _s3_liveness(doc: String, shape: Dictionary) -> void:
	print("\n§3 — the extractors, armed")
	ok(doc.contains(S7_OPEN) and doc.contains(S7_CLOSE),
		"§3: §7's own boundaries are gone from the document")
	ok(doc.contains(S6B_ANCHOR),
		"§3: §6b's anchor `%s` is gone, so §2 reads nothing" % S6B_ANCHOR)
	ok(int(shape["rows"]) > 0 and int(shape["nodes"]) > 0,
		"§3: the §7 read returned %d table rows against a stated %d nodes — §1's comparison is only as good as this"
			% [int(shape["rows"]), int(shape["nodes"])])
	# THE WRAPPED STATEMENTS, BY WHAT THEY SAY. The node count and the prices
	# each wrap across a line break in the source, so a line-anchored reader
	# drops both. They are asserted read so the flattening cannot be quietly
	# removed.
	ok(int(shape["nodes"]) > 0,
		"§3: §7's node count is not read — it wraps across a line break in the source, and its absence means the flattening has stopped happening")
	ok(bool(shape["prices_read"]),
		"§3: §7's tier prices are not read — the sentence wraps across a line break in the source, and its absence means the flattening has stopped happening")
	# THE WORD READER, both ways. A reader that returned a constant would pass
	# every arm in §1 and §2.
	ok(_words_to_int("one hundred and twenty-seven") == 127,
		"§3: the word reader misreads `one hundred and twenty-seven`")
	ok(_words_to_int("one hundred and fifty-four") == 154,
		"§3: the word reader misreads `one hundred and fifty-four`")
	ok(_words_to_int("twenty-four") == 24, "§3: the word reader misreads `twenty-four`")
	ok(_words_to_int("one hundred and three") == 103,
		"§3: the word reader misreads `one hundred and three`")
	ok(_words_to_int("twenty-seven") == 27, "§3: the word reader misreads `twenty-seven`")
	ok(_words_to_int("not a number") == 0,
		"§3: the word reader returns a number for a phrase that holds none")
	# AND THE TIER-ORDER COMPARISON ITSELF, driven on a column it must reject.
	# §1 passes by finding nothing; this is the arm that says it would find one.
	ok(_tiers_in_order([1, 1, 2, 2, 3, 3]), "§3: the tier-order check rejects a column that never goes backwards")
	ok(not _tiers_in_order([1, 1, 2, 1, 3]), "§3: the tier-order check accepts a column with a node in another tier's band")
