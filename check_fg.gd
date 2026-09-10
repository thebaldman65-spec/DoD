# BATCH FG — SOMETHING WATCHES THE TWO CEILINGS NOW.
#
#   §1  `docs/changelog.html` against CW §4's threshold, READ OUT OF THE RULE
#   §2  `CLAUDE.md` against EE §1's ceiling, READ OUT OF THE RULE
#   §3  the rule and this gate cannot drift apart, and the standing rule that
#       generalises them is where it says it is
#
# **WHY THIS GATE EXISTS.** CW §4 wrote a threshold and a whole cut procedure
# and **nothing was ever built to notice the threshold being crossed.** It was
# crossed at FB/FC and four batches went past in silence; the last recorded
# reading was EV's *"about seven batches away"*, and seven batches came and
# went. `check_dv` §4 prints the live changelog's ENTRY COUNT every battery and
# nothing anywhere printed its SIZE against the bar. **A CEILING NOBODY
# MEASURES IS A CEILING THAT GETS CROSSED SILENTLY**, and the same hole was
# open on `CLAUDE.md`'s 290 KiB.
#
# ── THE TWO ARMS, AND WHY IT IS NOT ONE OR THE OTHER ────────────────────────
# **THE WARNING IS THE LINE AND THE FAILURE IS THE DEADLINE.** A check that
# reds the moment the bar is crossed reds on a batch whose only crime is
# writing its own changelog entry, and the cut is a batch of work — a
# byte-for-byte split with its own rejoin proof — which this project's own rule
# says must not share a diff with anything else. A check that ONLY warns can be
# ignored, which is exactly what four batches of silence look like.
#
# So both, and the split between them is the RULE's own words rather than a
# margin anyone chose: *cut at the NEXT batch boundary*. §1 measures the file
# WITHOUT its newest entry, which is the file as the previous batch left it.
#   · over the bar WITH the newest entry only  → WARNING. You are the batch
#     that crossed it; the cut is owed at the next boundary.
#   · over the bar WITHOUT it as well         → FAILURE. The previous batch
#     crossed it, this is the next boundary, and the cut was not taken.
# **The red therefore never lands on a batch that had no warning in front of
# it**, and it cannot be ignored twice. No magnitude is invented anywhere here.
#
# §2 has no per-entry structure to lean on, so its deadline is the ceiling plus
# the LARGEST SINGLE-BATCH GROWTH ON RECORD — the same figure EE's derivation
# of the ceiling is built from, read out of the same block. By then a batch of
# the loudest kind on record has passed since the warning.
#
# ── THREE THINGS THIS GATE DOES NOT DO ─────────────────────────────────────
#   IT HOLDS NO COPY OF EITHER NUMBER. Both bars are parsed out of the rule
#     that states them, because a second copy of a number is this project's
#     oldest recurring defect. It asserts that EVERY statement of a bar in its
#     own file AGREES, so a half-edited rule reds rather than drifting.
#     **AND UNTIL FU §1 IT HELD ONE ANYWAY**: each form check was `contains()`
#     on the whole sentence, number included, so moving the ceiling to 340
#     took §2 red against a correct rule and a correct file while its parse
#     arms had already followed. The form is asserted by the pattern that
#     parses the number now, and no literal of either bar is left in here.
#   IT MEASURES BYTES, NEVER CHARACTERS. `String.length()` is a CHARACTER
#     count and `CLAUDE.md` holds 1,959 bytes of multi-byte punctuation — 1.91
#     KiB, against a ceiling whose whole margin is measured in KiB. A gate
#     reading `.length()` would report the file about two KiB smaller than the
#     census does, and would say so with no error.
#   IT DOES NOT ASSERT THE CUT'S STRUCTURE. `check_dv` §4 owns the boundary,
#     the heading counts and the disjointness of the two halves. A helper
#     copied between gates inherits its bugs and diverges silently (DA §3).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fg.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

# The standing rule this batch writes, as (heading, a sentence out of its BODY).
# The body needle is the member no index row could ever carry — FF §2's shape.
const RULE_HEAD := "A CEILING NOBODY MEASURES IS A CEILING THAT GETS CROSSED SILENTLY"
const RULE_BODY := "THE WARNING IS THE LINE AND THE FAILURE IS THE DEADLINE"


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH FG — THE TWO CEILINGS ARE MEASURED EVERY BATTERY NOW")
	_s1_the_changelog()
	_s2_the_required_read()
	_s3_the_rule_and_the_gate()
	_g.report(self)


# ── SIZE IN BYTES, WHICH IS THE ONLY UNIT EITHER BAR IS STATED IN ───────────
func _bytes(path: String) -> int:
	return FileAccess.get_file_as_bytes(path).size()


# EVERY STATEMENT OF A BAR IN ITS OWN FILE, AND THEY MUST AGREE. Returns -1
# when the rule does not state it at all, which is asserted rather than
# defaulted: a gate that silently falls back to a hardcoded bar is a gate that
# cannot be disarmed by editing the rule, and that is the wrong direction —
# the rule is the authority and a gate that cannot find it must say so.
func _bar_from_rule(text: String, pattern: String) -> Array:
	var rx := RegEx.new()
	rx.compile(pattern)
	var seen: Array = []
	for m in rx.search_all(text):
		var v := float(m.get_string(1))
		if not seen.has(v):
			seen.append(v)
	return seen


# ── §1 — THE CHANGELOG AGAINST CW §4's THRESHOLD ───────────────────────────
#
# THE UNIT IS THE RULE'S OWN WORD AND IT IS `KB`, SO THE BAR IS 400,000 BYTES.
# The two readings are 9,600 B apart and they put the crossing one batch apart
# — FB on the KB reading, FC on the KiB one — so the choice is not cosmetic.
# **The literal reading is also the STRICTER one**, and a bar that fires early
# is the safe direction for a ceiling whose whole purpose is to be noticed.
# Both figures are printed so a reader never has to guess which is meant.
func _s1_the_changelog() -> void:
	print("\n§1 — docs/changelog.html against the threshold the rule states")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(ir.length() > 40000, "§1: docs/instrument-rules.md read back %d chars" % ir.length())
	# THE FORM IS ASSERTED BY THE PATTERN THAT PARSES THE NUMBER (FU §1). This
	# arm was `contains()` on the sentence with its number in it, which is a
	# second copy of the bar; the pattern finds the form whatever the number is.
	var bars := _bar_from_rule(ir, "THE THRESHOLD IS ([0-9]+(?:\\.[0-9]+)?) KB")
	ok(bars.size() >= 1,
		"§1: the rule no longer states the changelog threshold in the form this gate reads")
	ok(bars.size() == 1,
		"§1: the rule states %d DIFFERENT changelog thresholds %s — they must agree" % [
			bars.size(), bars])
	if bars.size() != 1:
		return
	var kb: float = bars[0]
	ok(kb >= 100.0 and kb <= 4000.0,
		"§1: the threshold parsed out of the rule reads %.1f KB, which is not a credible bar" % kb)
	var bar := int(kb * 1000.0)

	var live := FileAccess.get_file_as_string("res://docs/changelog.html")
	var size := _bytes("res://docs/changelog.html")
	ok(size > 1000, "§1: docs/changelog.html read back %d bytes" % size)

	# THE FILE AS THE PREVIOUS BATCH LEFT IT. The newest entry runs from the
	# first `<h2>` to the second; everything else is unchanged from the last
	# commit, so removing it is the previous batch's reading without needing
	# git, a stored number, or anything this gate has to remember.
	var first := live.find("<h2")
	var second := live.find("<h2", maxi(first, 0) + 3)
	ok(first >= 0 and second > first,
		"§1: the live changelog holds fewer than two entries — §1's derivation has nothing to subtract")
	if first < 0 or second <= first:
		return
	var newest := live.substr(first, second - first).to_utf8_buffer().size()
	ok(newest > 0, "§1: the newest entry measured 0 bytes — the subtraction below would be vacuous")
	var before := size - newest

	print("  live %d B = %.2f KB = %.2f KiB   |  bar %.0f KB = %d B" % [
		size, size / 1000.0, size / 1024.0, kb, bar])
	print("  newest entry %d B; the file WITHOUT it is %d B = %.2f KB" % [
		newest, before, before / 1000.0])

	# THE WARNING ARM. Not a failure, and the reason is in the header.
	if size > bar:
		print("  *** CEILING WARNING *** docs/changelog.html is %.2f KB against a %.0f KB threshold."
			% [size / 1000.0, kb])
		print("      The cut is owed AT THE NEXT BATCH BOUNDARY and this gate FAILS if it is not taken.")
		print("      Procedure: docs/instrument-rules.md, THE CHANGELOG IS ARCHIVED ON A SCHEDULE.")
	else:
		print("  under the bar with %d B = %.2f KB of headroom" % [bar - size, (bar - size) / 1000.0])

	# THE FAILURE ARM. It asks about the PREVIOUS batch's file, so it can only
	# fire on a batch that had the warning in front of it.
	ok(before <= bar,
		"§1: docs/changelog.html was ALREADY %.2f KB before this batch's entry, against a %.0f KB threshold — the cut was owed at this boundary and was not taken" % [
			before / 1000.0, kb])


# ── §2 — `CLAUDE.md` AGAINST EE §1's CEILING ───────────────────────────────
func _s2_the_required_read() -> void:
	print("\n§2 — CLAUDE.md against the ceiling the rule states")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.length() > 100000, "§2: CLAUDE.md read back %d chars" % cm.length())
	# THE FORM IS ASSERTED BY THE PATTERN THAT PARSES THE NUMBER (FU §1). This
	# arm was `contains("THE CEILING IS 290 KiB")` — the old ceiling, copied —
	# and moving the ceiling to 340 took it red while the parse below followed.
	var bars := _bar_from_rule(cm, "THE CEILING IS ([0-9]+(?:\\.[0-9]+)?) KiB")
	ok(bars.size() >= 1,
		"§2: CLAUDE.md no longer states its ceiling in the form this gate reads")

	# THE FILE SAYS IT TWICE — the heading and the rule sentence under it — and
	# THAT IS THE POINT OF READING THEM ALL: two copies of a number that
	# disagree is the defect, and a gate that read only the first would not see
	# it. Every occurrence is collected and the SET must have one member.
	ok(bars.size() == 1,
		"§2: CLAUDE.md states %d DIFFERENT ceilings %s — the copies disagree" % [bars.size(), bars])
	var growth := _bar_from_rule(cm,
		"largest single-batch growth on record is \\*\\*\\+([0-9]+(?:\\.[0-9]+)?) KiB\\*\\*")
	ok(growth.size() == 1,
		"§2: the ceiling's own derivation states %d DIFFERENT largest-batch figures %s" % [
			growth.size(), growth])
	if bars.size() != 1 or growth.size() != 1:
		return
	var kib: float = bars[0]
	var grow: float = growth[0]
	ok(kib >= 100.0 and kib <= 2000.0,
		"§2: the ceiling parsed out of the rule reads %.1f KiB, which is not a credible bar" % kib)
	ok(grow > 0.0 and grow < 100.0,
		"§2: the largest-batch figure parsed out of the rule reads %.2f KiB, which is not credible" % grow)
	var bar := int(kib * 1024.0)
	var deadline := int((kib + grow) * 1024.0)

	var size := _bytes("res://CLAUDE.md")
	ok(size > 1000, "§2: CLAUDE.md read back %d bytes" % size)
	# THE CHARACTER COUNT IS PRINTED BESIDE THE BYTE COUNT so the difference is
	# on the page rather than in a comment. It is not small.
	print("  CLAUDE.md %d B = %.2f KiB  (%d chars — %d bytes of multi-byte punctuation)" % [
		size, size / 1024.0, cm.length(), size - cm.length()])
	print("  ceiling %.0f KiB = %d B; deadline %.0f + %.2f = %.2f KiB = %d B" % [
		kib, bar, kib, grow, kib + grow, deadline])

	if size > bar:
		print("  *** CEILING WARNING *** CLAUDE.md is %.2f KiB against a %.0f KiB ceiling."
			% [size / 1024.0, kib])
		print("      The answer is a SPLIT, never a prune, and FF measured that there is no third")
		print("      seam of this kind — the two moves left are both the designer's.")
	else:
		print("  under the ceiling with %d B = %.2f KiB of headroom" % [
			bar - size, (bar - size) / 1024.0])

	ok(size <= deadline,
		"§2: CLAUDE.md is %.2f KiB, past its ceiling by more than the largest single batch on record (%.2f KiB) — the split is overdue by a batch" % [
			size / 1024.0, grow])


# ── §3 — THE RULE AND THE GATE CANNOT DRIFT APART ──────────────────────────
#
# The bars above are parsed out of prose, so the prose is load-bearing. If a
# later batch rewords either statement this gate stops being able to find its
# bar — and §1 and §2 say so rather than passing. §3 pins the rule that
# generalises them, on FF §2's shape: the heading lives in the reference, it is
# an INDEX ROW in `CLAUDE.md` and nothing else, and a BODY sentence no index
# row could carry proves the rule itself is there rather than only its title.
func _s3_the_rule_and_the_gate() -> void:
	print("\n§3 — the standing rule, and the rule points at its instrument")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")

	var heads := 0
	var rows := 0
	var other := 0
	for line in ir.split("\n"):
		if line.begins_with("## ") and line.contains(RULE_HEAD):
			heads += 1
	for line2 in cm.split("\n"):
		if not line2.contains(RULE_HEAD):
			continue
		if line2.begins_with("| "):
			rows += 1
		elif line2.begins_with("## ") or line2.begins_with("### "):
			heads += 100
		else:
			other += 1
	ok(heads == 1, "§3: the rule is a heading %d times in the reference — it should be exactly once" % heads)
	ok(rows == 1 and other == 0,
		"§3: the rule appears in CLAUDE.md as %d index rows and %d other lines — one row, nothing else" % [
			rows, other])
	ok(ir.count(RULE_BODY) == 1,
		"§3: the rule's body sentence reads %d times in the reference — the rule is missing or duplicated" % ir.count(RULE_BODY))
	ok(cm.count(RULE_BODY) == 0,
		"§3: the rule's body is in CLAUDE.md too — a rule in two files is two rules")

	# THE RULE NAMES ITS INSTRUMENT BY FILE, both where the threshold is stated
	# and where the ceiling is. A rule whose instrument is unnamed is a rule
	# nobody can find the gate for, which is how CW §4 came to have none.
	ok(ir.contains("check_fg.gd"),
		"§3: docs/instrument-rules.md no longer names the gate that measures its thresholds")
	ok(cm.contains("check_fg.gd"),
		"§3: CLAUDE.md's ceiling block no longer names the gate that measures it")
	# THE PRINT REPORTS WHAT WAS MEASURED, NEVER WHAT WAS EXPECTED. A line that
	# states the conclusion reads identically on a clean run and a red one.
	print("  reference: %d heading, %d body sentence; CLAUDE.md: %d index row, %d other lines" % [
		heads, ir.count(RULE_BODY), rows, other])
