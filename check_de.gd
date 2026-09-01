# check_de.gd — THE COUNT DIFFER, AS A POST-PASS OVER THE RUN'S OWN LOGS.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_de.gd
#
# IT SPAWNS NOTHING. It reads `baselines.json` and the log directory the battery
# has just written, and it reports. That is the whole instrument.
#
# WHY IT IS NOT A SUITE, AND WHY THAT IS STRUCTURAL RATHER THAN TIDY.
# `test_batch_cd` §1 did this job by SPAWNING FORTY-FIVE CHILD GODOTS from
# inside a suite that the battery was itself running — the battery inside the
# battery. It cost about 22 minutes and it took the run from 29.6 minutes to
# roughly 50. The fault was not the implementation: A SUITE THAT SPAWNS SUITES
# SQUARES THE WORK WHEN YOU WIDEN IT, so the instrument got more expensive
# exactly as it got more useful, and the only lever left was to watch less.
#
# COMPARING THIS RUN'S COUNTS TO RECORDED ONES IS A PROPERTY OF THE RUN, NOT OF
# ANY SUITE IN IT. The runner already spawns every target and already captures
# every stream into `$OUT/<name>.log`, stderr included. So the differ needs no
# child of its own: it needs the logs that already exist. Reading a file cannot
# nest, so THE NESTING IS NOW IMPOSSIBLE RATHER THAN MERELY AVOIDED — and
# `baselines.json` may hold every target including `test_batch_cd`, which the
# old design could not watch at all (a suite that drives itself does not
# terminate).
#
# AND IT IS RE-RUNNABLE IN SECONDS. Re-checking the old differ's answer cost 22
# minutes because it re-ran the tree. This reads a directory: once the battery
# has written its logs, `check_de` can be re-run over them as many times as a
# batch needs, and the answer cannot drift because the evidence is fixed.
#
# WRITTEN IN GDSCRIPT AND NOT IN SHELL, ON PURPOSE. Bash string handling is how
# the battery's own check-count grep came to be too narrow three times (BQ's
# scar, CS's, CP's), and how a message that spelled a throw marker out in full
# would have made the battery accuse the differ of throwing. The count-differ
# has now been mis-instrumented twice. It is not a place to be clever.
extends SceneTree

# THE ONE PLACE THE NUMBERS LIVE. `docs/state.md` points at this file rather
# than restating it: a second copy of a number is this project's oldest
# recurring defect, and the differ that exists to catch drift must not be the
# thing that seeds it.
const BASELINES := "res://baselines.json"

# The manifest the battery writes as it goes — one target per line, appended
# before each is launched. THE DIFFER TRUSTS THIS AND NOT THE DIRECTORY
# LISTING, because `run_battery.sh` does not clear `$OUT` between runs: a
# target that failed to launch would otherwise be blessed by ITS PREVIOUS
# RUN'S LOG, which is the one fault a count-differ must never commit. A log
# named in the manifest is always fresh — `run_one` truncates it at spawn.
const MANIFEST := ".ran"

# The one deliberate exemption, named rather than left to a wildcard: the
# differ runs inside the battery it reports on, so its own log is being written
# while it reads. It does not baseline itself.
const SELF := "check_de"

var checks := 0
var fails: Array = []
var notices: Array = []


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


# A NOTICE IS NOT A FAILURE AND IS NOT SILENCE EITHER. See `_diff_checks`.
func note(msg: String) -> void:
	notices.append(msg)


# Joined at runtime, for the same reason `test_batch_cd`'s were and
# `check_da`'s census marks are: THIS GATE PRINTS ITS OWN MESSAGES INTO A LOG
# THE BATTERY GREPS. A message spelling either marker out in full would put the
# words in `check_de.log`, where `run_battery.sh`'s `throws=` column would count
# THIS gate as the one that threw. The gate that reports the fault must not be
# the one that trips it.
func _throw_marks() -> Array:
	return ["SCRIPT " + "ERROR", "Parse " + "Error"]


func _read(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _log_dir() -> String:
	var d := OS.get_environment("DOD_BATTERY_OUT")
	if d == "":
		d = "/tmp/dod_battery"
	while d.ends_with("/"):
		d = d.substr(0, d.length() - 1)
	return d


# THE BATTERY'S OWN SHAPES, TRANSCRIBED, AND THEY MUST STAY GENERAL.
# `[0-9]+ checks` alone is NOT enough: SIX suites print `checks: N  failures: N`
# (bm, bn, bo, bp, bq, br) and TWO print `BATCH XX: N passed, N FAILED` (ai, an).
# This grep has been too narrow three times — BQ's scar, CS's and CP's — and
# each time the report read `checks=?`, which is the one thing a count-diffing
# rule cannot compare.
# THE SINGLE SPACE IN `([0-9]+) checks` IS LOAD-BEARING AND BATCH DD PAID FOR IT.
# Written `[ \t]+`, the first alternative eats the wrong number out of the colon
# shape: `sections: 8   checks: 1891   failures: 0` matches "8   checks" and
# "1891   failures", so `bm` reported 8 checks / 1891 failures on its first
# widened run. `run_battery.sh`'s grep has one space and is right; this is that
# grep, transcribed. `_self_test` holds that line as a regression case.
func _count_re() -> RegEx:
	return RegEx.create_from_string("([0-9]+) (?:checks|passed)|checks: *([0-9]+)")


func _fail_re() -> RegEx:
	return RegEx.create_from_string(
		"(?i)([0-9]+) (?:failures|failed)|(?:failures|failed): *([0-9]+)")


# The harness reports a VERDICT beside its count — `GATE 2 PASS (165 checks)` —
# and prints no failure line at all, so it is parsed on its own shape rather
# than made to fit the other two.
func _harness_re() -> RegEx:
	return RegEx.create_from_string("GATE ([0-9]+) (PASS|FAIL) \\(([0-9]+) checks\\)")


# The LAST match, and whichever alternation group actually fired: a target is
# free to print a running figure mid-run, and the summary line is the one that
# means "this is what ran". -1 when nothing matched, WHICH IS ITSELF A READING —
# see `_diff_checks`: a count that cannot be read is a recorded state here, not
# a silent pass.
func _last_int(re: RegEx, text: String) -> int:
	var all_m := re.search_all(text)
	if all_m.is_empty():
		return -1
	var m: RegExMatch = all_m[-1]
	for g in [1, 2]:
		if m.get_string(g) != "":
			return int(m.get_string(g))
	return -1


func _band(row: Variant) -> String:
	if row == null:
		return "no readable count"
	var lo := int((row as Array)[0])
	var hi := int((row as Array)[1])
	return str(lo) if lo == hi else "%d-%d" % [lo, hi]


# ---------- THE ASYMMETRY, WHICH IS THE POINT OF THE SECTION ----------
#
# A FALL AND A RISE ARE NOT THE SAME EVENT, AND A DIFFER THAT TREATS THEM ALIKE
# IS EITHER A FALSE-ALARM GENERATOR OR BLIND.
#
# CHECK COUNTS. A FALLING count is this project's signature failure — `bb`
# 172->168, `bo` 505->495, harness gate 2 at CA, and every one of the seven
# SCRIPT ERRORs that hid 2,714 assertions. Something stopped running and the
# suite still printed a clean summary. THAT IS AN ERROR. A RISING count is
# almost always a suite's own loop walking new content — `bx` gained five at CX
# and `an` follows the draft — so it is a NOTICE.
#   THE FLOOR IS ASSERTED AND THE CEILING IS NOT, and this is the SAME
#   asymmetry `an`'s band already had written into it: floor = the lowest
#   observation, ceiling = the highest plus the observed spread. The floor is
#   the half that catches a real fault, so it stays tight; the ceiling takes the
#   headroom. What was a convention for writing bands is now the rule the
#   instrument runs on.
#
# FAILURE COUNTS INVERT, AND THIS IS THE HALF THAT IS WORTH MORE THAN THE OTHER.
# With 47 known failures across 20 suites a 48th is invisible. That is not
# hypothetical: `test_batch_bi` was right and the game was wrong for FOUR
# BATCHES, and it hid because that suite was already red for an unrelated
# reason. A RED CHECK DOES NOT ANNOUNCE A SECOND PROBLEM UNDERNEATH IT. So a
# suite going from 6 red to 7 is an ERROR, reported exactly as loudly as one
# going from 0 to 1; a suite going from 6 to 5 is a NOTICE, because something
# was repaired and the row has to move in the batch that repaired it.
#
# A NOTICE IS NOT SILENCE. It prints in its own block, it is counted in the
# summary line, and the rule stands: A BASELINE MOVES ONLY IN THE BATCH THAT
# CAUSES THE MOVEMENT, AND THE CHANGELOG SAYS WHY. A row left drifting behind a
# notice is CQ §3's failure arriving in a new place.
func _diff_checks(name: String, got: int, row: Variant) -> void:
	if row == null:
		# Recorded as unable to report a count. The set-level ratchet in
		# `_sweep` is where that claim is enforced in both directions; here the
		# assertion is the one thing that can still break silently.
		if got >= 0:
			note("%s now REPORTS A COUNT (%d) where none was readable — record it" % [name, got])
		return
	var lo := int((row as Array)[0])
	var hi := int((row as Array)[1])
	if got < 0:
		ok(false, "%s reports NO READABLE CHECK COUNT, recorded %s — a count that cannot be read is the one state a count-differ must refuse to bless"
			% [name, _band(row)])
		return
	ok(got >= lo, "%s FELL to %d checks, recorded %s — find what stopped running, or MOVE THE ROW and say why"
		% [name, got, _band(row)])
	if got > hi:
		note("%s ROSE to %d checks, recorded %s — usually its own loop walking new content; move the row in the batch that caused it"
			% [name, got, _band(row)])


func _diff_fails(name: String, got: int, row: Variant) -> void:
	if row == null:
		if got >= 0:
			note("%s now REPORTS A FAILURE COUNT (%d) where none was readable — record it" % [name, got])
		return
	var lo := int((row as Array)[0])
	var hi := int((row as Array)[1])
	if got < 0:
		ok(false, "%s reports NO READABLE FAILURE COUNT, recorded %s — the battery cannot see whether it passed at all"
			% [name, _band(row)])
		return
	ok(got <= hi, "%s went REDDER: %d failures, recorded %s — a red suite going redder is exactly the movement an aggregate hides (BATCH DE §3)"
		% [name, got, _band(row)])
	if got < lo:
		note("%s went GREENER: %d failures, recorded %s — something was repaired; move the row in the batch that repaired it"
			% [name, got, _band(row)])


# ---------- READING ONE TARGET'S LOG ----------

func _measure(kind: String, text: String) -> Array:
	if kind == "harness":
		var all_m := _harness_re().search_all(text)
		if all_m.is_empty():
			return [-1, -1]
		var m: RegExMatch = all_m[-1]
		return [int(m.get_string(3)), 0 if m.get_string(2) == "PASS" else 1]
	return [_last_int(_count_re(), text), _last_int(_fail_re(), text)]


# ---------- THE SWEEP ----------

func _sweep(targets: Dictionary) -> void:
	var dir := _log_dir()
	print("\n§1 every target the battery ran, at the count it is recorded at")
	print("  logs: %s" % dir)
	var ran: Array = []
	for line in _read(dir + "/" + MANIFEST).split("\n"):
		var t := String(line).strip_edges()
		if t != "" and not ran.has(t):
			ran.append(t)
	# A SWEEP THAT CAN ONLY PASS IS A GAP (BQ's rule). With no manifest there is
	# nothing to compare and the honest answer is to say so loudly, not to
	# report zero failures over zero targets.
	ok(not ran.is_empty(),
		"the battery wrote a manifest at %s/%s — WITHOUT IT THE DIFFER READS NOTHING, and `run_battery.sh` does not clear $OUT, so a previous run's logs would be blessed as this one's"
			% [dir, MANIFEST])
	if ran.is_empty():
		return
	var names: Array = targets.keys()
	names.sort()
	var moved: Array = []
	var seen_unreadable_checks: Array = []
	var seen_unreadable_fails: Array = []
	var recorded_unreadable_checks: Array = []
	var recorded_unreadable_fails: Array = []
	var swept := 0
	for name in names:
		var row: Dictionary = targets[name]
		if row.get("checks", null) == null:
			recorded_unreadable_checks.append(name)
		if row.get("fails", null) == null:
			recorded_unreadable_fails.append(name)
		if not ran.has(name):
			continue
		swept += 1
		var before := fails.size()
		var text := _read("%s/%s.log" % [dir, name])
		ok(text.length() > 0, "%s wrote a log with content in it" % name)
		# BOTH markers, the way `run_battery.sh` counts them. A parse failure
		# runs not one line and EXITS 0 (DB's trap), so neither the tally nor
		# the exit code is evidence — the stream is, and the runner already
		# captured it (`>"$log" 2>&1`).
		var marks := _throw_marks()
		var throws := text.count(marks[0]) + text.count(marks[1])
		ok(throws == 0, "%s runs without a throw (got %d — grep its log for the two markers)"
			% [name, throws])
		# THE VERDICT PIN, FOR A TARGET THAT REPORTS NEITHER COUNT.
		# `check_map_screen` prints `check_map_screen: OK` and nothing else — no
		# check count, no failure count — so the only thing standing between it
		# and a silent pass is that one word. A target with an `expect` string
		# must still print it.
		var want := String(row.get("expect", ""))
		if want != "":
			ok(text.contains(want),
				"%s still prints its verdict — it reports no count, so this line is the whole of what it says" % name)
		var m := _measure(String(row.get("kind", "suite")), text)
		var n := int(m[0])
		var fl := int(m[1])
		if n < 0:
			seen_unreadable_checks.append(name)
		if fl < 0:
			seen_unreadable_fails.append(name)
		_diff_checks(name, n, row.get("checks", null))
		_diff_fails(name, fl, row.get("fails", null))
		if fails.size() != before:
			moved.append(name)
		print("  %-24s %6s checks / %3s failures   (recorded %s / %s)%s"
			% [name, "?" if n < 0 else str(n), "?" if fl < 0 else str(fl),
				_band(row.get("checks", null)), _band(row.get("fails", null)),
				"   obs %d/%d" % [int(row.get("checks_obs", 0)), int(row.get("fails_obs", 0))]])
	print("  %d of %d recorded targets swept, %d off their recorded line%s" % [
		swept, names.size(), moved.size(),
		"" if moved.is_empty() else ": " + ", ".join(PackedStringArray(moved))])

	print("\n§2 the table and the run describe the same tree")
	# THE FAULT THIS BATCH INHERITED, MADE STRUCTURAL. `test_batch_cd` wrote
	# five rows and they were the five suites CD had just repaired — A NINTH OF
	# THE PROJECT — and nothing said so. A target the battery runs and the table
	# does not hold is unwatched, and being unwatched is silent by construction.
	var unwatched: Array = []
	for t in ran:
		if t != SELF and not targets.has(t):
			unwatched.append(t)
	ok(unwatched.is_empty(),
		"every target the battery ran has a row (UNWATCHED: %s)" % ", ".join(PackedStringArray(unwatched)))
	# And the other direction: a row nothing ran certifies nothing. This is what
	# a subset invocation (`./run_battery.sh bo bp`) trips, correctly — a
	# partial run must not read as a clean tree.
	var absent: Array = []
	for name in names:
		if not ran.has(name):
			absent.append(name)
	ok(absent.is_empty(),
		"every recorded target ran in this battery — %d DID NOT (a subset run cannot certify the tree): %s"
			% [absent.size(), ", ".join(PackedStringArray(absent))])
	# THE `checks=?` RATCHET, IN BOTH DIRECTIONS AND THEY ARE NOT THE SAME NEWS.
	# A count that reads `?` is the one thing a count-diffing rule cannot
	# compare. Losing a count is a regression; gaining one is progress that has
	# to be recorded before the next run can hold the gate to it. The live set
	# is derived from `baselines.json` rather than written here, because the
	# figure that used to stand in this comment ("ten of nineteen gates") was a
	# second copy of a number and had been wrong for eleven gates and one batch
	# by the time EI gave `check_parse` a count.
	_ratchet_set("check count", recorded_unreadable_checks, seen_unreadable_checks, ran)
	_ratchet_set("failure count", recorded_unreadable_fails, seen_unreadable_fails, ran)


func _ratchet_set(what: String, recorded: Array, seen: Array, ran: Array) -> void:
	var lost: Array = []
	for t in seen:
		if not recorded.has(t):
			lost.append(t)
	var gained: Array = []
	for t in recorded:
		if ran.has(t) and not seen.has(t):
			gained.append(t)
	ok(lost.is_empty(),
		"no target LOST its %s — these now read `?` and were recorded with a number: %s"
			% [what, ", ".join(PackedStringArray(lost))])
	if not gained.is_empty():
		note("%d target(s) GAINED a readable %s — record the number so the next run can hold them to it: %s"
			% [gained.size(), what, ", ".join(PackedStringArray(gained))])
	print("  %d recorded with no readable %s; %d lost, %d gained" % [
		recorded.size(), what, lost.size(), gained.size()])


# ---------- THE POSITIVE CONTROLS ----------
#
# A SWEEP THAT CAN ONLY PASS IS A GAP, and this file is nothing but a parser and
# a comparison — both of which have failed silently in this project before. The
# parser half pins the three log shapes AND `bm`'s scar; the comparison half
# pins the batch's central claim, THAT A FALL AND A RISE ARE DIFFERENT EVENTS,
# by driving both through the real function and checking which one goes red.
#
# The probes roll the counters back, so a control cannot pad the tally it is
# there to make trustworthy.
func _probe_checks(got: int, row: Array) -> bool:
	var f0 := fails.size()
	var n0 := notices.size()
	var c0 := checks
	_diff_checks("PROBE", got, row)
	var red := fails.size() > f0
	fails.resize(f0)
	notices.resize(n0)
	checks = c0
	return red


func _probe_fails(got: int, row: Array) -> bool:
	var f0 := fails.size()
	var n0 := notices.size()
	var c0 := checks
	_diff_fails("PROBE", got, row)
	var red := fails.size() > f0
	fails.resize(f0)
	notices.resize(n0)
	checks = c0
	return red


func _self_test() -> void:
	print("\n§0 the instrument, before it is pointed at anything")
	var cre := _count_re()
	var fre := _fail_re()
	# THE THREE SHAPES THE BATTERY MATCHES, because 45 suites print at least
	# five between them and a narrow grep has cost this project three batteries.
	ok(_last_int(cre, "test_batch_ah: 5625 checks / 0 failures") == 5625,
		"the plain shape reads its count")
	ok(_last_int(fre, "test_batch_ah: 5625 checks / 0 failures") == 0,
		"...and its failures")
	ok(_last_int(cre, "BATCH AN: 6053 passed, 0 FAILED") == 6053,
		"the passed/FAILED shape reads its count")
	ok(_last_int(fre, "BATCH AN: 6053 passed, 0 FAILED") == 0,
		"...and its failures")
	# BATCH DD'S SCAR, PINNED AS A REGRESSION CASE. Written `[ \t]+` instead of a
	# single space, the first alternative eats "8   checks" and "1891
	# failures" out of this exact line, and `bm` reported 8 checks / 1891
	# failures. It is the reason the space is a space.
	var bm := "sections: 8   checks: 1891   failures: 0"
	ok(_last_int(cre, bm) == 1891, "the colon shape reads 1891, not the section count")
	ok(_last_int(fre, bm) == 0, "...and 0 failures, not 1891")
	ok(_last_int(cre, "nothing here says how much ran") == -1,
		"a log with no count reads -1 rather than 0 — the two are not the same answer")
	var h := _measure("harness", "GATE 2 PASS (165 checks)")
	ok(int(h[0]) == 165 and int(h[1]) == 0, "the harness shape reads its count and its verdict")
	var hf := _measure("harness", "GATE 2 FAIL (3 checks)")
	ok(int(hf[0]) == 3 and int(hf[1]) == 1, "...and a FAILing gate is not read as a passing one")
	# THE ASYMMETRY ITSELF, DRIVEN THROUGH THE REAL FUNCTIONS.
	ok(_probe_checks(100, [200, 200]), "a FALLING check count is an ERROR")
	ok(not _probe_checks(300, [200, 200]), "...and a RISING one is a notice, not an error")
	ok(_probe_checks(-1, [200, 200]), "...and an unreadable count is an ERROR, not a pass")
	ok(_probe_fails(7, [6, 6]), "a RISING failure count is an ERROR — the 48th failure among 47 (BATCH DE §3)")
	ok(not _probe_fails(5, [6, 6]), "...and a FALLING one is a notice, not an error")
	ok(not _probe_checks(200, [200, 200]) and not _probe_fails(6, [6, 6]),
		"...and a target on its recorded line is neither")


func _initialize() -> void:
	print("check_de — THE COUNT DIFFER, AS A POST-PASS OVER THE RUN'S OWN LOGS")
	print("  It spawns nothing. `run_battery.sh` already ran every target and")
	print("  already captured every stream; this reads what it wrote.")
	_self_test()
	var parsed: Variant = JSON.parse_string(_read(BASELINES))
	ok(parsed is Dictionary, "%s parses as JSON — the baselines are unreadable" % BASELINES)
	var targets: Dictionary = {}
	if parsed is Dictionary:
		targets = (parsed as Dictionary).get("targets", {}) as Dictionary
	ok(not targets.is_empty(), "%s holds a `targets` table with rows in it" % BASELINES)
	if not targets.is_empty():
		_sweep(targets)
	if not notices.is_empty():
		print("\n%d NOTICE(S) — not failures, and not silence either. A baseline moves" % notices.size())
		print("only in the batch that causes the movement, and the changelog says why.")
		for m in notices:
			print("NOTICE: " + m)
	if not fails.is_empty():
		print("")
		for m in fails:
			print("FAIL: " + m)
	print("\ncheck_de: %d checks / %d failures / %d notices"
		% [checks, fails.size(), notices.size()])
	quit()
