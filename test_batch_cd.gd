# test_batch_cd.gd — HYGIENE: the dead test symbols, and the draft target.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_cd.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). Nothing here spawns a scene or touches an autoload, so the whole
# suite is safe in `_initialize`.
#
# BATCH DE — THE COUNT DIFFER HAS LEFT THIS FILE, AND THAT IS THE WHOLE BATCH.
#
# §1 USED TO SPAWN FORTY-FIVE CHILD GODOTS from inside a suite the battery was
# itself running — the battery inside the battery — because a GDScript runtime
# error is invisible to the suite it happens in and the only instrument that
# sees a throw is stderr. It cost about 22 minutes and took the run from 29.6
# minutes to roughly 50. DD widened it from five suites to forty-five and the
# price went up with the coverage, WHICH IS THE TELL: a suite that spawns suites
# squares the work when you widen it, so the instrument got more expensive
# exactly as it got more useful.
#
# DE ASKED WHAT THIS FILE DID THAT THE RUNNER COULD NOT, AND FOR THAT HALF THE
# HONEST ANSWER WAS NOTHING. `run_battery.sh` already spawns every target and
# already captures every stream, stderr included (`>"$log" 2>&1`); it already
# greps the same three count shapes and already counts the same two throw
# markers. The only thing it did not do was COMPARE — and comparing this run's
# counts to recorded ones is a property of the RUN, not of any suite in it. So
# the differ is `check_de.gd` now: a post-pass that reads the logs the runner
# has already written, spawns nothing, and cannot nest because reading a file is
# not running a suite. The baselines are `baselines.json`.
#
# WHAT STAYED, AND WHY IT HAD TO. The other three sections are not the differ
# and the runner cannot do them: they read the project's SOURCE and its DATA —
# the dead symbols pinned absent across the test tree, the draft target stated
# in four documents, and the pools measured through `Classes`. A shell runner
# has no `Classes` and no opinion about prose. They are assertions about the
# tree, they belong in a suite, and this is that suite.
#
# THIS FILE IS WATCHED BY `check_de` NOW, WHICH THE OLD DESIGN COULD NOT DO:
# `BASELINE` could never hold `test_batch_cd.gd`, because a suite that drives
# itself does not terminate. A post-pass has no such hazard.
extends SceneTree

# Every site that was aborting, by the symbol that aborted it. Pinned ABSENT
# from the test tree so the same dead name cannot come back in a sixth suite.
const DEAD_TEST_SYMBOLS := ["award_talent_points", "award_spec_point",
	"start_rune_enabled"]

# §2's arithmetic, transcribed once so every check below reads the same table.
const SPEC_TARGET := 96      # 12 specs x 8
const CLASS_TARGET := 24     # 4 classes x 6
const DRAFT_TARGET := 120    # 96 + 24
# RE-POINTED BY BATCH CE: the CLERIC three joined the Mage three at eight
# when tranche 3's second third landed, so what this list names is "the pools
# tranche 3 has already paid" rather than one class.
# RE-POINTED AGAIN BY BATCH CH: the HUNTER three joined them, so the list is
# NINE and what is left outside it is the WARRIOR three alone.
# RE-POINTED BY BATCH CI, AND IT IS THE LAST TIME — the WARRIOR three joined
# too, so the list is ALL TWELVE and there is nothing left outside it. **WHAT
# IT NAMES IS NO LONGER "the pools tranche 3 has paid" BUT SIMPLY THE POOLS**,
# and what the loop below guards changes with it: it asserted an ASYMMETRY for
# three batches and it asserts the FLATNESS now, so a pool that quietly empties
# trips where before it would have read as the old debt returning.
const DEEP_SPECS := ["berserker", "warden", "swordmaster",
	"pyromancer", "cryomancer", "arcanist",
	"holy", "inquisitor", "occultist",
	"beastmaster", "sharpshooter", "mystic"]

# The forms the dead denominator was written in, across four files. Matched as
# PHRASES rather than as the bare number, for the reason at `_target` below.
const STALE_TARGET_PHRASES := ["of ~96", "of a target ~96", "target of ~96",
	"of about ninety-six", "OF ~96"]

var checks := 0
var fails: Array = []


func _initialize() -> void:
	_dead_calls()
	_target()
	_pools()
	for m in fails:
		print("FAIL: " + m)
	print("test_batch_cd: %d checks / %d failures" % [checks, fails.size()])
	quit()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


# §2's half of the same problem, from the documentation side: CD's own
# correction has to WRITE `~96` in order to say it is dead, so what is banned is
# the PHRASE that states a target rather than the string.
func _states_stale_target(text: String, phrase: String) -> bool:
	return text.to_lower().contains(phrase.to_lower())


# COMMENTS AND STRING LITERALS ARE STRIPPED BEFORE §1'S SWEEP, AND THAT IS
# LOAD-BEARING RATHER THAN TIDY — Batch BS learned it the expensive way and this
# batch would have re-learned it. Every one of CD's five repairs NAMES the dead
# symbol on purpose: in a tombstone comment saying why it went, and in a
# `has_method("...")` assertion pinning it absent. A bare `contains` therefore
# flags exactly the code that is correct, and the obvious "fix" is to delete the
# line that tells the next author not to bring the call back.
#
# What can actually throw is a CALL, so a call is what is searched for. Handles
# `#` inside a string and `\"` inside one; the project uses no single-quoted or
# triple-quoted literals (checked, not assumed).
func _code_only(src: String) -> String:
	var out := ""
	var in_str := false
	var in_comment := false
	var i := 0
	while i < src.length():
		var c := src[i]
		if in_comment:
			if c == "\n":
				in_comment = false
				out += c
		elif in_str:
			if c == "\\":
				i += 1
			elif c == "\"":
				in_str = false
		elif c == "\"":
			in_str = true
		elif c == "#":
			in_comment = true
		else:
			out += c
		i += 1
	return out


# Every test_*.gd and check_*.gd in the project root. Read off the DIRECTORY
# rather than from a list, so a suite added later is covered by doing nothing.
func _test_tree() -> Array:
	var out: Array = []
	var d := DirAccess.open("res://")
	if d == null:
		return out
	for f in d.get_files():
		if (f.begins_with("test_") or f.begins_with("check_")) and f.ends_with(".gd"):
			out.append(String(f))
	out.sort()
	return out


# ---------- §1: and the dead names cannot come back ----------

func _dead_calls() -> void:
	print("\n§1 the dead names resolve nowhere in the test tree")
	var tree := _test_tree()
	ok(tree.size() >= 43, "the test tree holds %d suites to sweep" % tree.size())
	ok(tree.has("test_batch_cd.gd"), "...including this one")
	for sym in DEAD_TEST_SYMBOLS:
		var carriers: Array = []
		for f in tree:
			if _code_only(_src("res://" + f)).contains("." + sym + "("):
				carriers.append(f)
		ok(carriers.is_empty(),
			"`%s` is CALLED by no suite (found in: %s)" % [sym, ", ".join(carriers)])
	# THE POSITIVE CONTROL, because a sweep that can only pass is a gap (BQ's
	# rule, and CB's own harness lesson): the stripper must still SEE a call.
	# `_code_only` returning "" would make every line above pass forever.
	ok(_code_only("run.award_talent_points(\"boss\")").contains(".award_talent_points("),
		"the sweep can see a real call")
	ok(not _code_only("# run.award_talent_points(\"boss\")")
		.contains(".award_talent_points("), "...and not one inside a comment")
	ok(not _code_only("ok(run.has_method(\"award_talent_points\"))")
		.contains("award_talent_points"), "...nor one inside a string literal")
	# The other half of the same question, at the source of truth: the deleted
	# names are still deleted. test_batch_bm pins this against run_state; it is
	# repeated here because §1's repairs are only correct while it holds.
	var rs := _src("res://scripts/run_state.gd")
	ok(not rs.contains("func award_talent_points"),
		"BM's deletion stands: run_state defines no award_talent_points")
	ok(not rs.contains("func award_spec_point"),
		"...nor award_spec_point")
	ok(not rs.contains("func start_rune_enabled"),
		"AN's deletion stands: run_state defines no start_rune_enabled")
	ok(rs.contains("func bank_zone_boss_points"),
		"...and the ONE live door, bank_zone_boss_points, is present")


# ---------- §2: the draft target ----------

func _target() -> void:
	print("\n§2 the draft target is 120, and ~96 is stated nowhere live")
	# The arithmetic itself, so a later batch moving the target has to move a
	# number here and read the reason beside it.
	ok(SPEC_TARGET == 12 * 8, "the spec pool target is 12 specs x 8 = 96")
	ok(CLASS_TARGET == 4 * 6, "the class-wide target is 4 classes x 6 = 24")
	ok(DRAFT_TARGET == SPEC_TARGET + CLASS_TARGET, "the draft target is 120")
	# THE LIVE SITES. `~96` came from an older assumption of six spec cards per
	# spec; CB completed the Mage at EIGHT and test_batch_bt has asserted depth
	# 8 ever since, so the tests have encoded the right figure while the prose
	# contradicted it. These are the files a reader treats as current truth.
	# WHAT IS BANNED IS THE STALE DENOMINATOR, NOT THE STRING. CD's own
	# corrections have to NAME `~96` to say it is dead — in classes.gd, in
	# CLAUDE.md and in the changelog — so a bare `contains("~96")` fails against
	# the very text that fixes the problem, and the obvious repair is to delete
	# the correction. The discriminating form is the phrase that STATES a
	# target: "of ~96", "of a target ~96", "of about ninety-six".
	for phrase in STALE_TARGET_PHRASES:
		ok(not _states_stale_target(_src("res://docs/master.html"), phrase),
			"master.html states no \"%s\"" % phrase)
	# master.html is CURRENT TRUTH ONLY — no history lives in it by standing
	# rule — so there it can be held to the stricter form: the string at all.
	var master := _src("res://docs/master.html")
	ok(not master.contains("~96"), "master.html carries no ~96 at all")
	ok(master.contains("120 of 120"), "master.html states 120 of 120")
	ok(master.contains("96 spec"), "...and names the 96-card spec half")
	var classes := _src("res://scripts/classes.gd")
	for phrase in STALE_TARGET_PHRASES:
		ok(not _states_stale_target(classes, phrase),
			"classes.gd states no \"%s\"" % phrase)
	ok(classes.contains("A TARGET 120"), "...it carries the real target")
	# CLAUDE.md keeps its dated batch blocks as written — they are the record
	# of what each batch believed, and rewriting them destroys it (CA's rule).
	# What must be current is the STANDING REFERENCE, so that is what is read.
	var cm := _src("res://CLAUDE.md")
	var anchor := "STANDING REFERENCE — THE ABILITY DRAFT"
	var at := cm.find(anchor)
	ok(at >= 0, "CLAUDE.md carries the standing draft reference")
	# End the slice at the next standing block, so a later batch's prose cannot
	# quietly extend what this check is reading (the BE anchor lesson).
	# REPAIRED BY BATCH DG §5, AND IT HAD NEVER ONCE BITTEN. It searched for
	# "### STANDING" — THREE hashes — against a file in which every heading is
	# "## STANDING", TWO. `find` returned -1, the guard fell through to the
	# `stop <= 0` arm, and the slice ran to END OF FILE: 20,949 characters
	# against the block's 10,337. The assertions below went on passing because
	# the correct sentence also lives inside the true block, so this was A
	# CHECK THAT HAD STOPPED ASKING ITS QUESTION WITH NO FAILURE TO ANNOUNCE
	# IT — in the suite whose whole job is finding exactly that.
	# THE LEADING NEWLINE IS LOAD-BEARING: `tail` opens mid-heading at the
	# anchor, so the "## STANDING" it must not match is its OWN, and a leading
	# "\n" is what excludes it. Anchoring on the bare heading would slice the
	# block to nothing and every assertion below would go red at once.
	var tail := cm.substr(at)
	var stop := tail.find("\n## STANDING")
	# AND THE GUARD ASSERTS THAT IT RESOLVED, which is the half that was
	# missing. A fall-through is only silent while nothing asks; an anchor that
	# stops matching is RED now rather than quietly wide. CP's rule — an
	# instrument repaired without a negative control is an instrument nobody
	# has tested — and the control was run: changing the "##" back to "###"
	# turns this line red on its own.
	ok(stop > 0, "...and the block's END anchor resolves, so the slice is bounded")
	var block := tail if stop <= 0 else tail.substr(0, stop)
	ok(block.length() > 500, "...and the slice covers it (%d chars)" % block.length())
	for phrase in STALE_TARGET_PHRASES:
		ok(not _states_stale_target(block, phrase),
			"the standing reference states no \"%s\"" % phrase)
	# RE-POINTED BY BATCH CE, and the question is unchanged: does the STANDING
	# reference carry the LIVE count against the REAL target? Only the correct
	# answer moved. COMMENT CORRECTED BY BATCH DG §3 — it still read "the draft
	# is 102 and what is owed is the Hunter and Warrior thirds", which CH and CI
	# paid; the draft is 120 of 120 and nothing is owed.
	ok(block.contains("120 OF 120") or block.contains("120 of 120"),
		"...it states 120 of 120")
	# RE-POINTED BY BATCH CI, AND IT IS AN INVERSION: the Warrior third is paid,
	# so the standing block must no longer name ANYTHING as owed. Asserting the
	# absence of a debt is what keeps §6's "rewrite rather than patch" honest —
	# a block that still said "9 are owed" beside a 120-of-120 count would be
	# exactly the half-edited prose CD's own sweep exists to catch.
	ok(block.contains("NOTHING IS OWED") or block.contains("nothing is owed"),
		"...and states that NOTHING is owed")
	ok(not block.contains("9 ARE OWED") and not block.contains("9 are owed"),
		"...and no longer names a debt that has been paid")
	# No suite may carry the stale denominator either: a test whose MESSAGE
	# states a wrong target teaches it to whoever reads the failure — and four
	# suites carried it in exactly that form. This file is the one legitimate
	# mention (its const table is what makes the sweep possible), so it is the
	# one exemption, named rather than left to a wildcard.
	var carriers: Array = []
	for f in _test_tree():
		if f == "test_batch_cd.gd":
			continue
		if _src("res://" + f).contains("~96"):
			carriers.append(f)
	ok(carriers.is_empty(), "no suite states ~96 (found in: %s)" % ", ".join(carriers))


# ---------- §2: what the pools actually hold ----------

func _pools() -> void:
	print("\n§2 the pools measured against that target")
	var spec_total := 0
	var specs: Array = []
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			specs.append(String(spec))
	ok(specs.size() == 12, "twelve specs (%d)" % specs.size())
	for spec in specs:
		var pool: Array = Classes.spec_draft_pool(spec)
		spec_total += pool.size()
		var want := 8 if DEEP_SPECS.has(spec) else 5
		ok(pool.size() == want, "%s drafts %d (want %d)" % [spec, pool.size(), want])
		# A pool with a repeat would keep the count and change the draft.
		var seen := {}
		for n in pool:
			seen[String(n)] = 1
		ok(seen.size() == pool.size(), "%s's pool holds no duplicate" % spec)
	ok(spec_total == 96, "SPEC_DRAFT_POOLS holds 96 entries (got %d)" % spec_total)
	ok(spec_total == 12 * 8,
		"...which is ALL TWELVE at eight — the draft is complete (Batch CI)")
	var class_total := 0
	for cls in Classes.CLASS_DRAFT_POOLS:
		class_total += (Classes.CLASS_DRAFT_POOLS[cls] as Array).size()
	ok(class_total == CLASS_TARGET,
		"CLASS_DRAFT_POOLS is full at %d (got %d)" % [CLASS_TARGET, class_total])
	ok(spec_total + class_total == 120, "the draft stands at 120 of 120")
	# INVERTED BY BATCH CI RATHER THAN DELETED. This asserted a DEBT for four
	# batches; the debt is paid, so what it asserts now is that there is none —
	# which is the thing a later batch could actually break (a pool emptying, a
	# card quietly removed), and it is still the same question.
	ok(DRAFT_TARGET - (spec_total + class_total) == 0,
		"NOTHING is owed — the draft is complete at 120 of 120")
	ok(SPEC_TARGET - spec_total == 0, "...and the spec half is full at 96")
