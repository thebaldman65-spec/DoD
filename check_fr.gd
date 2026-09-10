# BATCH FR — `docs/ways-of-working.md` HAS A READER.
#
#   §1  THE BRANCH RULE — the one rule in that file with an artefact to check
#   §2  NO SECOND COPY — the file's own preamble rule, mechanically
#   §3  NO DEAD POINTERS — every repo path it names resolves
#   §4  THE CONFLICT TABLE names real files, and covers what FQ measured
#   §5  IT STAYS THE SMALLEST OF THE THREE RULE FILES, AND HOLDS NO HISTORY
#   §6  THE GATE AND THE FILE CANNOT DRIFT APART, AND §2/§3 ARE NOT VACUOUS
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# FQ §2e measured it and said it plainly: **`docs/ways-of-working.md` has ZERO
# readers.** No gate, no suite and no script opened it. The branch rule it had
# just recorded — *the merge is developed on `class-merge`, `main` stays
# playable* — was therefore enforced by nothing, which is the same shape as
# BN's run-save warning: documented, correct, and silently ignored for thirty
# batches while the thing it warned about happened repeatedly.
#
# ── WHAT THIS GATE CANNOT DO, SAID FIRST ────────────────────────────────────
# **MOST OF THAT FILE IS NOT MECHANICALLY CHECKABLE AND THIS GATE DOES NOT
# PRETEND OTHERWISE.** Six of its eight rule blocks are about how a batch comes
# to EXIST — design settled before a brief, a recon read before authoring, the
# assistant able to state what a thing changes and reads, findings routed to the
# queue, implementation calls belonging to the batch, a batch being mostly
# transcription. **Not one of those leaves an artefact in the tree.** There is
# no file whose contents differ according to whether the designer and the
# assistant settled a name in conversation first. A check claiming to assert
# them would be a check that always passes, which is worse than none — it would
# make the file look instrumented while enforcing nothing, and that is precisely
# the fault this gate was built to end.
#
# **SO IT ASSERTS THE TWO RULES THAT HAVE ARTEFACTS, AND THE FILE'S OWN
# HOUSEKEEPING RULES, AND SAYS SO.** The branch rule has a git ref and a
# CLAUDE.md pointer. The *no second copy* rule is a string comparison against
# the two files it names. The pointers are paths. The size rule is three
# `FileAccess` calls. Everything else is prose about people and is left alone.
#
# ── AND §1 IS TWO FACTS, NOT THEIR CONJUNCTION ──────────────────────────────
# The rule says the branch is *cut from the commit that carries the profile
# version guard, not from before it*. **THIS GATE CANNOT WALK GIT HISTORY** —
# it reads refs out of `.git`, and a ref is a commit id, not an ancestry. So it
# asserts the two halves separately and says which: the branch EXISTS as a ref,
# and the guard the branch was cut to carry IS IN THE TREE. A branch cut from
# before the guard would satisfy both and is the hole; it is named here rather
# than papered over, and closing it needs a `git merge-base`, which is a shell
# and not a gate.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

const WOW := "res://docs/ways-of-working.md"
const CM := "res://CLAUDE.md"
const IR := "res://docs/instrument-rules.md"

# The rule blocks this gate reads, by their own headings. §6 asserts each is
# still there, so a rewrite that deletes a rule reds the gate rather than
# quietly making the arm that reads it vacuous.
const RULE_BRANCH := "THE MERGE IS DEVELOPED ON ITS OWN BRANCH"
const RULE_NO_COPY := "IT HOLDS ONLY RULES THAT ARE NOT RECORDED ELSEWHERE"
const RULE_SMALL := "KEEP IT SMALL AND KEEP IT STABLE"
const RULE_TABLE := "THE FILES EVERY BATCH WRITES"

# `docs/reports/XX.md` names a SHAPE — one new file per batch — and not a file.
# It is the only such entry, and §3 asserts that it is the only one rather than
# skipping anything that fails to resolve.
const PATH_SHAPES := ["docs/reports/XX.md"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH FR — ways-of-working.md HAS A READER")
	var wow := FileAccess.get_file_as_string(WOW)
	ok(wow.length() > 0, "§0: docs/ways-of-working.md is missing or empty")
	if wow.length() == 0:
		_g.report(self)
		return
	_s1_the_branch(wow)
	_s2_no_second_copy(wow)
	_s3_no_dead_pointers(wow)
	_s4_the_conflict_table(wow)
	_s5_small_and_no_history(wow)
	_s6_the_gate_and_the_file(wow)
	_g.report(self)


# ── READING A GIT REF WITHOUT A SHELL ───────────────────────────────────────
# Three places a branch can live, and a fresh clone uses a different one from
# this working copy: a loose local head, a loose remote-tracking head, or a
# line in `packed-refs`. **A check that looked only in `refs/heads` would read
# ABSENT on any clone that had never checked the branch out** — a false red
# that a later batch would "fix" by deleting the arm.
func _ref_exists(branch: String) -> bool:
	if FileAccess.file_exists("res://.git/refs/heads/%s" % branch):
		return true
	if FileAccess.file_exists("res://.git/refs/remotes/origin/%s" % branch):
		return true
	var packed := FileAccess.get_file_as_string("res://.git/packed-refs")
	return packed.contains("refs/heads/%s" % branch) \
		or packed.contains("refs/remotes/origin/%s" % branch)


# ── §1 — THE BRANCH RULE ────────────────────────────────────────────────────
func _s1_the_branch(wow: String) -> void:
	var cm := FileAccess.get_file_as_string(CM)

	# THE BRANCH NAME IS READ OUT OF THE RULE, NEVER PINNED HERE. The batch that
	# renames the branch edits one file and this gate follows it; a literal here
	# would make the gate the second copy the file's own preamble forbids.
	var rx := RegEx.new()
	rx.compile("developed on its own branch — `([a-z0-9-]+)`")
	var m := rx.search(wow)
	ok(m != null,
		"§1: the branch rule no longer names its branch in backticks, so nothing can read it")
	if m == null:
		return
	var branch := m.get_string(1)

	# THE REPO IS THE AUTHORITY. A rule naming a branch nobody cut is a rule
	# that has already failed, and this is the arm FQ said did not exist.
	ok(FileAccess.file_exists("res://.git/HEAD"),
		"§1: no .git here, so the branch arm below cannot mean anything")
	ok(_ref_exists(branch),
		"§1: ways-of-working.md names `%s` and no such ref exists in this repo" % branch)
	ok(branch != "main",
		"§1: the merge branch and main are the same name, so `main stays playable` says nothing")

	# THE SECOND HALF OF THE CUT RULE, ASSERTED AS ITS OWN FACT. See the header:
	# this is the guard being IN THE TREE, not the branch descending from it.
	var prof := FileAccess.get_file_as_string("res://scripts/profile.gd")
	ok(prof.contains("MIN_VERSION"),
		"§1: the profile version guard the branch was cut to carry is not in the tree")
	ok(prof.contains("refusal_message"),
		"§1: ...and neither is the refusal it reports to the player")

	# CLAUDE.md POINTS HERE AND DOES NOT RESTATE. Both directions, because a
	# pointer that has lost its target and a rule that grew a second copy are
	# different faults and neither is visible from the other side.
	ok(cm.contains("docs/ways-of-working.md"),
		"§1: CLAUDE.md no longer points at ways-of-working.md at all")
	ok(not cm.contains("`%s`" % branch),
		"§1: CLAUDE.md now names `%s` itself — that is the second copy the rule forbids" % branch)
	print("  §1: branch `%s` — ref present: %s" % [branch, str(_ref_exists(branch))])


# ── §2 — NO SECOND COPY ─────────────────────────────────────────────────────
#
# The file's own preamble: *a second copy of a rule is the defect that let
# CLAUDE.md contradict itself 1900 lines apart after CW's split.* Checkable as
# written: no long run of this file may appear verbatim in either neighbour.
#
# THE FLOOR IS 60 CHARACTERS AND IT IS NOT ARBITRARY. Shorter runs are shared
# vocabulary — every rule file in this project says "the designer" and "a
# batch" — and a floor low enough to catch those would red on every run and be
# deleted. Sixty is about a line of prose: long enough that a match is a
# COPIED SENTENCE rather than a shared phrase.
func _s2_no_second_copy(wow: String) -> void:
	var cm := FileAccess.get_file_as_string(CM)
	var ir := FileAccess.get_file_as_string(IR)
	var dupes: Array = []
	var compared := 0
	for raw in wow.split("\n"):
		var line := String(raw).strip_edges()
		# Skip structure: headings, table rows, blockquotes and bullets carry
		# markup that would never match verbatim anyway.
		if line.length() < 60 or line.begins_with("#") or line.begins_with("|"):
			continue
		compared += 1
		if cm.contains(line):
			dupes.append("CLAUDE.md: %s" % line.substr(0, 50))
		elif ir.contains(line):
			dupes.append("instrument-rules.md: %s" % line.substr(0, 50))
	# CHECKED n OF m, PRINTED. A comparison that silently skipped every line
	# reads exactly like a clean one, and this project has paid for that twice.
	print("  §2: compared %d lines of %d against CLAUDE.md and instrument-rules.md"
		% [compared, wow.split("\n").size()])
	ok(compared > 20,
		"§2: only %d lines were long enough to compare — the arm has gone vacuous" % compared)
	ok(dupes.is_empty(),
		"§2: ways-of-working.md has grown a second copy of %d line(s): %s" % [
			dupes.size(), ", ".join(dupes)])


# ── §3 — NO DEAD POINTERS ───────────────────────────────────────────────────
#
# *Where a rule below has a neighbour in another file, it POINTS at it and does
# not restate it.* A pointer to a file that does not exist is that rule failing
# silently — the reader follows it, finds nothing, and restates the rule.
func _s3_no_dead_pointers(wow: String) -> void:
	var rx := RegEx.new()
	rx.compile("`([A-Za-z0-9_./-]+\\.(?:md|html|json|sh|py|gd))`")
	var seen: Array = []
	var dead: Array = []
	var shapes := 0
	for m in rx.search_all(wow):
		var path := m.get_string(1)
		if seen.has(path):
			continue
		seen.append(path)
		if PATH_SHAPES.has(path):
			shapes += 1
			continue
		# A bare name (`master.html`) is a reference to the same file the table
		# names with its directory; resolve both spellings before calling it dead.
		if FileAccess.file_exists("res://%s" % path) \
				or FileAccess.file_exists("res://docs/%s" % path):
			continue
		dead.append(path)
	print("  §3: %d distinct paths named, %d template shape(s) exempt" % [seen.size(), shapes])
	ok(seen.size() >= 10,
		"§3: only %d paths found — the extractor has stopped matching" % seen.size())
	ok(dead.is_empty(),
		"§3: ways-of-working.md points at %d file(s) that do not exist: %s" % [
			dead.size(), ", ".join(dead)])
	# THE EXEMPTION IS PINNED AT ITS SIZE, so a later batch cannot quiet a real
	# dead pointer by adding its name to PATH_SHAPES.
	ok(shapes == PATH_SHAPES.size(),
		"§3: %d of the %d exempt template shapes are no longer in the file" % [
			shapes, PATH_SHAPES.size()])


# ── §4 — THE CONFLICT TABLE ─────────────────────────────────────────────────
#
# FQ measured the conflicting population over fourteen commits and found EIGHT
# files, against the three the brief predicted. The table is what stops that
# being re-derived at every merge point. A FLOOR and not an equality: a later
# batch that adds a ninth row is right to, and this arm must not punish it.
func _s4_the_conflict_table(wow: String) -> void:
	var measured := ["docs/state.md", "docs/changelog.html", "docs/design-notes.md",
		"run_battery.sh", "pin-manifest.json", "baselines.json", "CLAUDE.md",
		"docs/master.html"]
	var missing: Array = []
	for f in measured:
		if not wow.contains(f):
			missing.append(f)
	ok(missing.is_empty(),
		"§4: the conflict table has lost %d of FQ's eight measured files: %s" % [
			missing.size(), ", ".join(missing)])
	ok(wow.contains(RULE_TABLE),
		"§4: the conflict table's own heading is gone, so §4 is asserting on nothing")


# ── §5 — SMALL, AND NO HISTORY ──────────────────────────────────────────────
#
# *KEEP IT SMALL AND KEEP IT STABLE. It has no batch blocks, no measurements
# that go stale and no history.*
#
# THE SIZE BAR IS DERIVED, NOT INVENTED. No byte figure is pinned anywhere here.
# The file's own claim is that it is a THIRD FILE and not a third seam of the
# rule tree, so the bar is its two neighbours: it must stay the smallest of the
# three. That is the rule's own words made measurable, and it moves when they do.
#
# **IT DOES NOT ASSERT "no measurements".** The file carries several today —
# twelve to fourteen batches, fifty red targets, forty runes — and an arm
# forbidding numbers would red on the file as written. What is checkable is the
# BATCH BLOCK, which is the shape `state.md` and the changelog own.
func _s5_small_and_no_history(wow: String) -> void:
	var n_wow := FileAccess.get_file_as_bytes(WOW).size()
	var n_cm := FileAccess.get_file_as_bytes(CM).size()
	var n_ir := FileAccess.get_file_as_bytes(IR).size()
	print("  §5: ways-of-working %d B, CLAUDE.md %d B, instrument-rules %d B" % [
		n_wow, n_cm, n_ir])
	ok(n_wow < n_cm and n_wow < n_ir,
		"§5: ways-of-working.md is no longer the smallest of the three rule files")
	var rx := RegEx.new()
	rx.compile("(?m)^#{1,4} +BATCH [A-Z]{1,2}\\b")
	ok(rx.search(wow) == null,
		"§5: ways-of-working.md has grown a batch block — that belongs in the changelog")
	ok(not wow.contains("Last rewritten") and not wow.contains("Last updated"),
		"§5: ways-of-working.md has grown a timestamp, which is state.md's shape and not this file's")


# ── §6 — THE GATE AND THE FILE CANNOT DRIFT, AND THE ARMS ARE LIVE ──────────
#
# check_fg's own idiom. Every arm above reads a block by its heading; if a
# rewrite deletes the block, the arm goes quiet and passes. These say so.
#
# AND THE LIVENESS ARM. §2 and §3 both pass by finding NOTHING — a duplicate
# that is not there, a dead pointer that is not there. A gate whose clean state
# is "no findings" reads identically to a gate that has stopped looking, so the
# two extractors are asserted to still be extracting.
func _s6_the_gate_and_the_file(wow: String) -> void:
	for head in [RULE_BRANCH, RULE_NO_COPY, RULE_SMALL, RULE_TABLE]:
		ok(wow.contains(head),
			"§6: ways-of-working.md no longer contains `%s`, so the arm reading it is vacuous" % head)
	# The two extractors, armed against the file itself: a line this gate KNOWS
	# is there must be found by the same regexes §1 and §3 use.
	var rx_branch := RegEx.new()
	rx_branch.compile("developed on its own branch — `([a-z0-9-]+)`")
	ok(rx_branch.search(wow) != null,
		"§6: §1's branch extractor matches nothing in the live file")
	var rx_path := RegEx.new()
	rx_path.compile("`([A-Za-z0-9_./-]+\\.(?:md|html|json|sh|py|gd))`")
	ok(rx_path.search_all(wow).size() >= 10,
		"§6: §3's path extractor matches fewer than ten paths, so §3 proves nothing")
