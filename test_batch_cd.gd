# test_batch_cd.gd — HYGIENE: seven script errors, one wrong target count.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_cd.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). Nothing here spawns a scene or touches an autoload, so the whole
# suite is safe in `_initialize` — but §1 SPAWNS FIVE CHILD GODOTS and is
# therefore the slowest suite in the battery by wall clock. That cost is the
# deliberate price of the one question this batch exists to answer, and the
# reason is below.
#
# WHY §1 RUNS THE SUITES INSTEAD OF GREPPING THEM. A GDScript runtime error
# inside a `--script` suite is INVISIBLE TO THAT SUITE: the error aborts the
# function it happened in, execution resumes in the caller, and the suite goes
# on to print a clean "N checks, 0 failures" with every check below the throw
# silently missing. That is the BC trap, it is what CA found gate 2 doing with
# a WORD instead of a number, and at the CB battery it was still standing in
# five suites. NO SOURCE-LEVEL CHECK CAN SEE IT — a grep for the dead call this
# batch repaired would pass the day a different dead call arrives. The only
# instrument that sees a throw is stderr, and the only way to read a suite's
# stderr from inside a suite is to run it. So §1 runs them.
#
# THE RECURSION HAZARD, NAMED SO IT IS NOT DISCOVERED: `REPAIRED` must never
# hold this file. A suite that drives itself does not terminate.
extends SceneTree

# The five suites Batch CD repaired, with the check-count FLOOR each one
# measured afterwards. A FLOOR rather than a pin, deliberately, and for two
# different reasons: `an` and `ah` walk generated boards and offer tables, so
# their totals drift run to run by construction (CLAUDE.md has said so about
# `an` since BO); and §1's rule is that a repaired suite must come back EQUAL
# OR HIGHER, which is exactly what a floor asserts. A count that FALLS through
# one of these floors is a section that stopped running — which is the failure
# this whole batch is about, arriving again.
const REPAIRED := {
	"test_batch_ah.gd":  5600,
	"test_batch_an.gd":  5900,
	"test_batch_bb.gd":  170,
	"test_batch_bj.gd":  67,
	"test_runes.gd":     3100,
}

# Every site that was aborting, by the symbol that aborted it. Pinned ABSENT
# from the test tree so the same dead name cannot come back in a sixth suite.
const DEAD_TEST_SYMBOLS := ["award_talent_points", "award_spec_point",
	"start_rune_enabled"]

# §2's arithmetic, transcribed once so every check below reads the same table.
const SPEC_TARGET := 96      # 12 specs x 8
const CLASS_TARGET := 24     # 4 classes x 6
const DRAFT_TARGET := 120    # 96 + 24
const MAGE_SPECS := ["pyromancer", "cryomancer", "arcanist"]

# The forms the dead denominator was written in, across four files. Matched as
# PHRASES rather than as the bare number, for the reason at `_target` below.
const STALE_TARGET_PHRASES := ["of ~96", "of a target ~96", "target of ~96",
	"of about ninety-six", "OF ~96"]

var checks := 0
var fails: Array = []


func _initialize() -> void:
	_throws()
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


# ---------- §1: the seven throws are closed ----------

func _throws() -> void:
	print("\n§1 the five repaired suites run without throwing")
	var exe := OS.get_executable_path()
	var proj := ProjectSettings.globalize_path("res://")
	var count_re := RegEx.create_from_string("(\\d+)\\s+(?:checks|passed)")
	var names: Array = REPAIRED.keys()
	names.sort()
	for suite in names:
		var out: Array = []
		# read_stderr = true: a SCRIPT ERROR goes to stderr and NOWHERE ELSE.
		# The suite's own stdout says nothing about it, which is the point.
		OS.execute(exe, ["--headless", "--path", proj, "--script", String(suite)],
			out, true)
		var text := "\n".join(out)
		var throws := text.count("SCRIPT ERROR")
		ok(throws == 0, "%s throws no SCRIPT ERROR (got %d)" % [suite, throws])
		# A clean line is not evidence on its own — CA's finding. Read the
		# COUNT beside it, and read it as a floor. The LAST match, not the
		# first: a suite is free to print a running figure mid-run, and the
		# summary line is the one that means "this is what ran".
		var all_m := count_re.search_all(text)
		var n := -1 if all_m.is_empty() else int(all_m[-1].get_string(1))
		ok(n >= int(REPAIRED[suite]),
			"%s reports %d checks, at or above its floor of %d"
			% [suite, n, int(REPAIRED[suite])])
		ok(text.contains("0 failures") or text.contains("0 FAILED"),
			"%s reports zero failures" % suite)
		print("  %s: %d checks, %d throws" % [suite, n, throws])


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
	ok(master.contains("93 of 120"), "master.html states 93 of 120")
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
	var tail := cm.substr(at)
	var stop := tail.find("### STANDING")
	var block := tail if stop <= 0 else tail.substr(0, stop)
	ok(block.length() > 500, "...and the slice covers it (%d chars)" % block.length())
	for phrase in STALE_TARGET_PHRASES:
		ok(not _states_stale_target(block, phrase),
			"the standing reference states no \"%s\"" % phrase)
	ok(block.contains("93 OF 120") or block.contains("93 of 120"),
		"...it states 93 of 120")
	ok(block.contains("27"), "...and names the 27 still owed")
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
		var want := 8 if MAGE_SPECS.has(spec) else 5
		ok(pool.size() == want, "%s drafts %d (want %d)" % [spec, pool.size(), want])
		# A pool with a repeat would keep the count and change the draft.
		var seen := {}
		for n in pool:
			seen[String(n)] = 1
		ok(seen.size() == pool.size(), "%s's pool holds no duplicate" % spec)
	ok(spec_total == 69, "SPEC_DRAFT_POOLS holds 69 entries (got %d)" % spec_total)
	ok(spec_total == 3 * 8 + 9 * 5, "...which is three at eight and nine at five")
	var class_total := 0
	for cls in Classes.CLASS_DRAFT_POOLS:
		class_total += (Classes.CLASS_DRAFT_POOLS[cls] as Array).size()
	ok(class_total == CLASS_TARGET,
		"CLASS_DRAFT_POOLS is full at %d (got %d)" % [CLASS_TARGET, class_total])
	ok(spec_total + class_total == 93, "the draft stands at 93")
	ok(DRAFT_TARGET - (spec_total + class_total) == 27,
		"27 are owed — the Cleric, Hunter and Warrior thirds of tranche 3")
	ok(SPEC_TARGET - spec_total == 27, "...and every one of them is a SPEC card")
