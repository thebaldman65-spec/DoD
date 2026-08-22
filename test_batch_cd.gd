# test_batch_cd.gd — HYGIENE: seven script errors, one wrong target count.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_cd.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). Nothing here spawns a scene or touches an autoload, so the whole
# suite is safe in `_initialize` — but §1 SPAWNS FORTY-FIVE CHILD GODOTS SINCE
# BATCH DD and is by a wide margin the slowest suite in the battery by wall
# clock: about 22 minutes of a battery that was 30. IT RUNS THE WHOLE BATTERY
# INSIDE THE BATTERY, and that is the deliberate price of the one question this
# suite exists to answer. `run_battery.sh` carries a per-target watchdog bound
# for it (`TMO[test_batch_cd]`) for the same reason `check_map` has one.
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
# THE RECURSION HAZARD, NAMED SO IT IS NOT DISCOVERED: `BASELINE` must never
# hold this file. A suite that drives itself does not terminate.
extends SceneTree

# BATCH DD — THE TABLE IS THE WHOLE BATTERY NOW, AND IT WAS A NINTH OF IT.
#
# CD wrote five rows and they were the five suites CD had just repaired. That is
# FIVE OF THE FORTY-FIVE `run_battery.sh` RUNS, and what it cost was measured
# rather than argued: repairing `be` through `bi` at Batch DC did not move this
# suite by one line, BECAUSE NOT ONE OF THE FIVE FAITH SUITES WAS IN THE TABLE.
# The project's count-differ — the one instrument built for its signature failure
# — was watching a ninth of the project.
#
# EVERY SUITE THE BATTERY RUNS IS HERE NOW, MINUS THIS FILE, PLUS `test_batch_cp`
# — which the battery's own `SUITES` array misses, so nothing watched it at all
# until now. Forty-five rows either way; they are not the same forty-five, and
# saying "all 45" without saying which is how a gap survives a headline.
#
# A ROW IS [checks_lo, checks_hi, fails_lo, fails_hi], AND BOTH HALVES ARE BANDS
# because three suites legitimately move and a band written too tight is a false
# alarm generator:
#
#   `an` 6047–6063 checks — it counts `for ab in u.abilities` over live units, so
#          the total follows the draft. TEN observations: DB's six (6047, 6051,
#          6052, 6054, 6048, 6054), DC's 6053, DD's two batteries at 6053, and
#          **DD's first widened sweep at 6055 — ONE ABOVE the 6047–6054 band that
#          had just been written from the other nine.** A band written to a
#          sample's exact extremes is exceeded by roughly two runs in eleven, and
#          this one was exceeded inside the batch that wrote it.
#          **THE RULE, APPLIED WHEN A BAND IS EXCEEDED AND NOT BEFORE:** floor =
#          the lowest observation; ceiling = the highest PLUS the observed spread
#          (6055 + 8). **The floor is the half that catches a real fault** — a
#          section of `an` that stopped running costs hundreds of checks, not
#          five — so it stays tight while the ceiling gets the headroom.
#   `bk` 129–130 checks, on FIVE observations: DB's 129 and 130, DC's 129, and
#          DD's two batteries, which read 130 and then 129. **Both ends were
#          observed in one batch. It is NOT widened**, because it has not been
#          exceeded: headroom is added where the evidence demands it, so that
#          every number here is traceable to a reading.
#   `bo` 0–1 failures — a known flake at roughly 1 run in 13: §5's NULL FIELD
#          check requires `deep < shallow` and the damage carries a 0.9–1.1
#          variance roll, so both can land on the same integer.
#
#   `at` IS NO LONGER ONE OF THEM. It read 3 failures or 4 — the fourth in 2 runs
#          of 5 — and BATCH DD SEEDED IT: both blows of each compared pair now
#          draw the same variance. It is pinned at 470 / 3 over five consecutive
#          runs, and it turned out to be TWO flaky checks rather than the one
#          that had been recorded.
#
# EVERYTHING ELSE IS EXACT ON BOTH HALVES, AND THAT IS THE INSTRUMENT.
# A COUNT THAT RISES IS AS MUCH NEWS AS ONE THAT FALLS — `bx` gained five checks
# at CX and `al` lost one at CV, and both were found batches later, by accident,
# by somebody verifying something else. And A FAILURE COUNT THAT MOVES INSIDE AN
# ALREADY-RED SUITE IS INVISIBLE IN AN AGGREGATE, which is exactly how
# `test_batch_bi` stayed wrong for four batches while its suite was red for an
# unrelated reason. When a row moves for a good reason, MOVE THE ROW — in the
# same commit, with the reason beside it.
#
# THE FAILURE COUNTS ARE NOT ZERO AND ARE NOT SUPPOSED TO BE. 46 assertions
# across 19 suites are deliberately red, each needing a ruling on what it should
# ask INSTEAD, and `bo`'s flake makes it 47 across 20 on the runs it appears.
# DC published 49 across 21: the two that are not in this table are THIS SUITE'S
# OWN, and they were `bb` and `bj` being reported red a second time. The widening
# turns those two from failures into recorded baselines — an ACCOUNTING change
# and the only movement in the project's failure total at DD.
# This table records WHERE THE REDS ARE so the next one is visible the day it
# arrives. Repairing them is its own batch; reading their count as a regression
# is the fault this file exists to prevent.
const BASELINE := {
	"test_batch_ah.gd":        [5625, 5625, 0, 0],
	"test_batch_ah_battle.gd": [65, 65, 0, 0],
	"test_batch_ai.gd":        [2217, 2217, 0, 0],
	"test_batch_aj.gd":        [418, 418, 0, 0],
	"test_batch_ak.gd":        [528, 528, 0, 0],
	"test_batch_al.gd":        [559, 559, 0, 0],
	"test_batch_an.gd":        [6047, 6063, 0, 0],
	"test_batch_ar.gd":        [735, 735, 1, 1],
	"test_batch_as.gd":        [396, 396, 3, 3],
	"test_batch_at.gd":        [470, 470, 3, 3],
	"test_batch_au.gd":        [336, 336, 0, 0],
	"test_batch_av.gd":        [324, 324, 1, 1],
	"test_batch_aw.gd":        [350, 350, 3, 3],
	"test_batch_ax.gd":        [345, 345, 2, 2],
	"test_batch_ay.gd":        [484, 484, 0, 0],
	"test_batch_az.gd":        [519, 519, 0, 0],
	"test_batch_ba.gd":        [690, 690, 0, 0],
	"test_batch_bb.gd":        [177, 177, 2, 2],
	"test_batch_bc.gd":        [91, 91, 0, 0],
	"test_batch_bd.gd":        [71, 71, 1, 1],
	"test_batch_be.gd":        [34, 34, 0, 0],
	"test_batch_bf.gd":        [78, 78, 0, 0],
	"test_batch_bg.gd":        [47, 47, 0, 0],
	"test_batch_bh.gd":        [233, 233, 0, 0],
	"test_batch_bi.gd":        [91, 91, 0, 0],
	"test_batch_bj.gd":        [67, 67, 1, 1],
	"test_batch_bk.gd":        [129, 130, 0, 0],
	"test_batch_bl.gd":        [88, 88, 0, 0],
	"test_batch_bm.gd":        [1891, 1891, 0, 0],
	"test_batch_bn.gd":        [81, 81, 2, 2],
	"test_batch_bo.gd":        [1025, 1025, 0, 1],
	"test_batch_bp.gd":        [275, 275, 0, 0],
	"test_batch_bq.gd":        [742, 742, 1, 1],
	"test_batch_br.gd":        [1450, 1450, 2, 2],
	"test_batch_bs.gd":        [266, 266, 0, 0],
	"test_batch_bt.gd":        [458, 458, 1, 1],
	"test_batch_bu.gd":        [480, 480, 5, 5],
	"test_batch_bv.gd":        [900, 900, 2, 2],
	"test_batch_bw.gd":        [551, 551, 3, 3],
	"test_batch_bx.gd":        [147, 147, 2, 2],
	"test_batch_cb.gd":        [1184, 1184, 2, 2],
	"test_batch_ce.gd":        [1116, 1116, 9, 9],
	"test_batch_cp.gd":        [697, 697, 0, 0],
	"test_runes.gd":           [3121, 3121, 0, 0],
	"test_rune_battle.gd":     [97, 97, 0, 0],
}

# THE BATTERY'S PER-SUITE FLAGS, AND THIS TABLE IS NOT OPTIONAL.
# `test_batch_bl` SILENTLY UNDER-RUNS WITHOUT `--fixed-fps 12` — that is one of
# the three scars `run_battery.sh`'s header records, and a driver that forgets it
# reads a real 88 as a smaller number and calls the difference a regression.
# `run_battery.sh` holds the same table in its `EXTRA` array; if a second entry
# is ever added there, it belongs here on the same day.
const SUITE_FLAGS := {
	"test_batch_bl.gd": ["--fixed-fps", "12"],
}

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


# ---------- §1: every suite runs, at the count it is recorded at ----------

# Joined at runtime, for the same reason `check_da`'s census marks are: THIS
# SUITE PRINTS ITS OWN FAILURE MESSAGES, and a message that spelled either marker
# out would put the words in this suite's log — where `run_battery.sh`'s
# `throws=` column would count THIS suite as the one that threw. The gate that
# reports the fault must not be the one that trips it.
func _throw_marks() -> Array:
	return ["SCRIPT " + "ERROR", "Parse " + "Error"]


# The LAST match, and whichever of the two alternation groups actually fired: a
# suite is free to print a running figure mid-run, and the summary line is the
# one that means "this is what ran". -1 when nothing matched, which fails the
# band rather than passing it — a count that cannot be READ is exactly the state
# a count-differ must refuse to bless.
func _last_int(re: RegEx, text: String) -> int:
	var all_m := re.search_all(text)
	if all_m.is_empty():
		return -1
	var m: RegExMatch = all_m[-1]
	for g in [1, 2]:
		if m.get_string(g) != "":
			return int(m.get_string(g))
	return -1


func _band(lo: int, hi: int) -> String:
	return str(lo) if lo == hi else "%d-%d" % [lo, hi]


func _throws() -> void:
	print("\n§1 every suite runs, and reports the count it is recorded at")
	var exe := OS.get_executable_path()
	var proj := ProjectSettings.globalize_path("res://")
	# THE BATTERY'S OWN SHAPES, AND THEY MUST STAY GENERAL. `[0-9]+ checks` alone
	# is NOT enough: SIX suites print `checks: N   failures: N` (bm, bn, bo, bp,
	# bq, br) and TWO print `BATCH XX: N passed, N FAILED` (ai, an), and every one
	# of those is a suite CLAUDE.md pins with a number. **CS's scar is recorded
	# everywhere as "seven suites print the colon shape"; the seven is the set the
	# narrow grep MISSED, and only six of them print that shape.** This grep has been too narrow three times — BQ's scar,
	# CS's and CP's — and each time the report read `checks=?`, which is the one
	# thing a count-diffing rule cannot compare.
	# THE SINGLE SPACE IN `([0-9]+) checks` IS LOAD-BEARING AND DD PAID FOR IT.
	# Written as `[ \t]+` instead, the FIRST alternative eats the wrong number out
	# of the colon shape: `sections: 8   checks: 1891   failures: 0` matches
	# "8   checks" and "1891   failures", so `bm` reported **8 checks / 1891
	# failures** on its first widened run. `run_battery.sh`'s grep has one space
	# and is right; this is that grep, transcribed.
	var count_re := RegEx.create_from_string(
		"([0-9]+) (?:checks|passed)|checks: *([0-9]+)")
	var fail_re := RegEx.create_from_string(
		"(?i)([0-9]+) (?:failures|failed)|(?:failures|failed): *([0-9]+)")
	var names: Array = BASELINE.keys()
	names.sort()
	var moved: Array = []
	for suite in names:
		var out: Array = []
		var args: Array = ["--headless", "--path", proj]
		args.append_array(SUITE_FLAGS.get(suite, []))
		args.append_array(["--script", String(suite)])
		# read_stderr = true: a script error goes to stderr and NOWHERE ELSE.
		# The suite's own stdout says nothing about it, which is the point.
		OS.execute(exe, args, out, true)
		var text := "\n".join(out)
		# BOTH markers, the way `run_battery.sh` counts them. A parse failure runs
		# not one line and EXITS 0 (DB's trap), so neither the tally nor the exit
		# code is evidence — the stream is.
		var marks := _throw_marks()
		var throws := text.count(marks[0]) + text.count(marks[1])
		ok(throws == 0, "%s runs without a throw (got %d)" % [suite, throws])
		var row: Array = BASELINE[suite]
		var n := _last_int(count_re, text)
		var fl := _last_int(fail_re, text)
		var n_ok := n >= int(row[0]) and n <= int(row[1])
		var f_ok := fl >= int(row[2]) and fl <= int(row[3])
		ok(n_ok, "%s reports %d checks, recorded %s — MOVE THE ROW and say why, or find what stopped running"
			% [suite, n, _band(int(row[0]), int(row[1]))])
		ok(f_ok, "%s reports %d failures, recorded %s — a red suite going redder or greener is news either way"
			% [suite, fl, _band(int(row[2]), int(row[3]))])
		if not (n_ok and f_ok):
			moved.append(suite)
		print("  %-24s %5d checks / %2d failures   (recorded %s / %s)"
			% [suite, n, fl, _band(int(row[0]), int(row[1])),
				_band(int(row[2]), int(row[3]))])
	ok(names.size() >= 45, "the table watches %d suites" % names.size())
	print("  %d suites swept, %d off their recorded line%s" % [names.size(),
		moved.size(),
		"" if moved.is_empty() else ": " + ", ".join(PackedStringArray(moved))])


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
	var tail := cm.substr(at)
	var stop := tail.find("### STANDING")
	var block := tail if stop <= 0 else tail.substr(0, stop)
	ok(block.length() > 500, "...and the slice covers it (%d chars)" % block.length())
	for phrase in STALE_TARGET_PHRASES:
		ok(not _states_stale_target(block, phrase),
			"the standing reference states no \"%s\"" % phrase)
	# RE-POINTED BY BATCH CE, and the question is unchanged: does the STANDING
	# reference carry the LIVE count against the REAL target? Only the correct
	# answer moved — CE paid tranche 3's second third, so the draft is 102 and
	# what is owed is the Hunter and Warrior thirds.
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
