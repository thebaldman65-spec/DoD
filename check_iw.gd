# BATCH IW — THE LADDER WITH RESOLUTION, AND THE DECK's MIDDLE.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS.
#   §0.1 THE THREE SPINE NAMES ARE CONFIRMED: no live file calls one proposed (swept), each stands where a player reads it,
#        and the two claims that stood on them are repaired in the ledger, so none stands.
#   §0.2 ONE PROCESS A LANE, DRIVEN: an idle lane runs a launch in place; a lane already running Godot is refused by name and
#        pid, and the launch runs in a lane the driver hands out — a refusal with a way forward.
#   §0.3 `DOD_ZONE_ROTATION` IS THE SIM's, DRIVEN: exported, a player's run does not read it, and a sim does.
#   §1   THE LADDER's MEASUREMENT IS KEPT: the screen's table (every candidate's five readings, R5 and R4 recomputed from them,
#        the winner the largest R5) and the ladder's (every modifier on the winner, its level and the cuts re-derived off the
#        readings by the pre-registered rule) — and the arm the batch took is the arm the tables give.
#   §2   EVERY GRADE CARRIES ITS MEASUREMENT: each modifier's severity in the game is the grade its row of the ladder names;
#        and each handle the ladder names is read at its source, so a re-tune moves the printed figure and reds nothing.
#   §3   NO SUPERSEDED-PENDING MARK OUTLIVES ITS RE-TAKE: every figure IW re-took is written in `docs/state.md` and its IV mark
#        is gone; every figure IV marked and IW did not re-take keeps its mark.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 holds the tables' arithmetic and shape — that R5, the levels and the cuts follow
# from the readings written — never that the readings are what the sim produces: that is the batch's drive (`docs/reports/IW.md`
# §1), which no gate re-runs, and its fidelity proof is in the report. §0.2 drives the driver with bare probes, never a battery.
# §0.1's sweep reads every live text file for the word beside a name, not every way of saying it.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iw.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _docs := {}
var _run: Node = null


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IW — THE LADDER WITH RESOLUTION, AND THE DECK's MIDDLE")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	_s01_the_names()
	_s02_the_lock()
	_s03_the_zone_flag()
	_s1_the_ladder()
	_s2_the_grades()
	_s3_the_retakes()
	OS.set_environment("DOD_ZONE_ROTATION", "")
	_run.sim_run = false
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# A FILE READ ONCE, BY ITS FULL `res://` PATH — the path written at the call, so `build_pin_manifest.py` binds the holder
# off its initializer and every needle asserted against it is a pin.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


# A TSV of record, its header the first line: an array of {column: value}.
func _tsv(path: String, need: Array) -> Array:
	var lines := _doc(path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	for c in need:
		ok(head.has(c), "%s has no '%s' column" % [path, c])
	var out: Array = []
	var bad := 0
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			bad += 1
			continue
		var row := {}
		for i in head.size():
			row[String(head[i])] = String(f[i])
		out.append(row)
	ok(bad == 0, "%s: %d rows do not carry every column" % [path, bad])
	return out


# The words §0 and §1 pin in the documents, each on one line of its file.
const MEASURE_NEEDLE := "RESOLUTION COMES FROM A POPULATION WHOSE SUBJECTS DIFFER MORE, NOT FROM MORE RUNS (IW §1, the designer's)."
const ARM_NEEDLE := {"A": "ARM A — THE GRADES ARE RE-SET FROM THE MEASUREMENT", "B": "ARM B — THE GRADES ARE NOT FIVE LEVELS ON THIS POPULATION EITHER, SO NONE IS RE-CUT"}
const SUPERSEDED_NEEDLE := "THE LADDER's FIGURES REPLACE IP's — THIS MEASUREMENT REPLACES THE RECORD RATHER THAN CHECKING IT"


# ── §0 — THE RULINGS, EACH WHERE A FUTURE SESSION READS IT ──────────────────────────────────────────
# Each needle on one line of the file the ruling binds: the names' test and the zone flag's in `CLAUDE.md` (what the game may
# contain), the lock's and the measurement's in `docs/instrument-rules.md` (how a batch verifies itself), the lock's own
# account in `lane.sh`'s header where a reader of the driver meets it.
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var ir := _doc("res://docs/instrument-rules.md")
	var lane := _doc("res://lane.sh")
	ok(claude.contains("A NAME THE PROJECT's OWN PROSE TOOK UP AS THE THING's NOUN HAS ALREADY PASSED THE TEST A NEW NAME WOULD HAVE TO PASS (IW §0.1, the designer's)"),
		"§0.1: CLAUDE.md's name-sweep block does not carry the names' ruling — a name the prose took up as the noun has passed the test")
	ok(claude.contains("AND A FLAG THAT CHANGES WHAT A RUN CONTAINS IS THE SIM's, UNLESS THE PLAYER CHOOSES THAT CONTENT SOMEWHERE ELSE TOO (IW §0.3, the designer's)"),
		"§0.3: CLAUDE.md's debug table does not say whose a flag that changes what a run contains is")
	ok(ir.contains("A REFUSAL WITH NO WAY FORWARD IS A RULE WEARING A LOCK's CLOTHES."),
		"§0.2: the instrument rules' lane block does not carry the lock's ruling — a refusal with no way forward is a rule wearing a lock's clothes")
	ok(lane.contains("ONE PROCESS A LANE, AND A LANE IN USE HANDS OUT ANOTHER (IW §0.2, the designer's)"),
		"§0.2: lane.sh's header does not say why it refuses a lane in use and what it hands out")
	ok(ir.contains(MEASURE_NEEDLE),
		"§1: the instrument rules do not carry the measurement's ruling — resolution comes from a population whose subjects differ more, not from more runs")
	print("    CHECKED five rulings in their files")

# ── §0.1 — THE THREE SPINE NAMES ARE CONFIRMED, AND NO FILE CALLS THEM PROPOSED ──────────────────────
# THE POPULATION IS EVERY LIVE TEXT FILE: the rule files, this repository's documents, the game's scripts and data — every
# `.md`, `.html`, `.gd`, `.json` and `.tsv` under the repository but its reports, its archive and the backups (a report is the
# record of what was true when it was written, and GK's and IV's said *proposed* truly). A file reds when the word *proposed*
# stands within a sentence's reach of a spine rune's name — the absence; and each name must still stand where a player reads it
# and where the rules name it — the positive arm, so a sweep that stopped reading files is not read as a clean one.
const SPINE_NAMES := ["Rune of the Vanguard", "Rune of the Invoker", "Rune of the Hierophant"]
const NAME_REACH := 160
const LEDGER := "docs/reports/IU-claims.tsv"


func _live_text_files(dir: String, out: Array) -> void:
	for d in DirAccess.get_directories_at(dir):
		if d.begins_with(".") or d in ["save-backups", "DoD-archive", "assets", "reports"]:
			continue
		_live_text_files(dir.path_join(d), out)
	for f in DirAccess.get_files_at(dir):
		if dir == "res://" and f == "check_iw.gd":
			continue  # this gate's own needles are the words it sweeps for
		for ext in [".md", ".html", ".gd", ".json", ".tsv"]:
			if String(f).ends_with(ext):
				out.append(dir.path_join(f))


func _s01_the_names() -> void:
	print("\n§0.1 — the three spine names, confirmed: no live file calls them proposed")
	var files: Array = []
	_live_text_files("res://", files)
	var hits: Array = []
	var read := 0
	var rx := RegEx.new()
	rx.compile("(?i)proposed")
	for path in files:
		var txt := _flat(FileAccess.get_file_as_string(path))
		if txt == "":
			continue
		read += 1
		for m in rx.search_all(txt):
			var at: int = m.get_start()
			var win := txt.substr(maxi(at - NAME_REACH, 0), 2 * NAME_REACH)
			for nm in SPINE_NAMES:
				# the bare noun too — *a Hierophant*, *(names PROPOSED at GK)* beside *the Hierophant's engines*
				var noun := String(nm).trim_prefix("Rune of the ")
				if win.contains(noun):
					hits.append("%s: …%s…" % [path, txt.substr(maxi(at - 60, 0), 120)])
					break
	ok(read >= 150, "§0.1: the sweep read only %d live text files — it has stopped reading the tree" % read)
	ok(hits.is_empty(), "§0.1: %d live passages still call a spine name proposed — the designer confirmed all three at IW §0.1: %s" % [hits.size(), str(hits)])
	# THE POSITIVE ARM: each name stands where a player reads it and where the rules name it.
	var runes := _doc("res://data/runes.json")
	var claude := _doc("res://CLAUDE.md")  # raw: the needle sits on one line, where `check_ec`'s holder filter reads it
	var recon := _doc("res://docs/kit-recon.html")
	for nm in SPINE_NAMES:
		ok(runes.contains("\"%s (core)\"" % nm), "§0.1: %s (core) is not a rune's name in data/runes.json — the confirmed name is the data's" % nm)
		ok(recon.contains(String(nm)), "§0.1: docs/kit-recon.html no longer names %s" % nm)
	ok(claude.contains("the Hierophant's engines (named at GK, confirmed at IW §0.1, the designer's)"),
		"§0.1: CLAUDE.md's class-core block does not say the three names are confirmed — the parenthetical goes with the ruling")
	# THE LEDGER: ISN04 and ISF12, the two claims that stood on the names, repaired in place, IW in their tree.
	var rows := _tsv("res://" + LEDGER, ["id", "disposition", "stands", "gone", "tree"])
	var standing: Array = []
	for r in rows:
		if String(r["disposition"]) == "STANDS":
			standing.append(String(r["id"]))
		if String(r["id"]) in ["ISN04", "ISF12"]:
			var gone := String(r["gone"]).replace("\\n", "\n")
			var stands := String(r["stands"]).replace("\\n", "\n")
			ok(String(r["disposition"]) == "REPAIRED", "§0.1: %s is not REPAIRED in the ledger, in place (it reads %s)" % [r["id"], r["disposition"]])
			ok(String(r["tree"]).contains("IW"), "§0.1: %s's repair does not name IW in its tree column (%s)" % [r["id"], r["tree"]])
			# Three questions, each its own line: a repaired row records both its words, the false ones are gone, the true ones stand.
			ok(gone != "" and stands != "", "§0.1: %s's row does not record both its false words (`gone`) and its true ones (`stands`) — a repaired row carries both" % r["id"])
			ok(gone == "" or not claude.contains(gone), "§0.1: %s's false words still stand in CLAUDE.md: '%s'" % [r["id"], gone.substr(0, 80)])
			ok(stands == "" or claude.contains(stands), "§0.1: %s's true words are not in CLAUDE.md: '%s'" % [r["id"], stands.substr(0, 80)])
	ok(standing.is_empty(), "§0.1: the ledger still holds %d standing claims — GK's names were the last two, and both are repaired: %s" % [standing.size(), str(standing)])
	print("    CHECKED %d live text files for a spine name beside *proposed*, three names where they stand, the ledger's two rows" % read)


# ── §0.2 — ONE PROCESS A LANE, AND A LANE IN USE HANDS OUT ANOTHER, DRIVEN ─────────────────────────────
# The driver is run, never read: a bare probe made in a scratch directory (`lane.sh probe`, so it holds no file of the game's),
# a long launch held in it, then a second launch into the same lane — which must be refused BY NAME (the lane and the pid) and
# run in another lane the driver hands out. **Two arms an absence alone would miss**: the idle lane still runs in place (the
# lock refuses a lane, never an idle one), and the refusal has a way forward (a lock that stops is a rule wearing a lock's
# clothes). The probe's user folders are named inside the clearing command's last pattern (`DoD probe IW lock`, and the lane
# handed out, `… 2`), reused every battery.
const SLEEPER := "extends SceneTree\nfunc _initialize() -> void:\n\tprint(\"IWLOCK ran in \", ProjectSettings.globalize_path(\"res://\"))\n\tif not OS.get_cmdline_user_args().has(\"quick\"):\n\t\tvar t := Time.get_ticks_msec()\n\t\twhile Time.get_ticks_msec() - t < 30000:\n\t\t\tOS.delay_msec(100)\n\tquit()\n"


func _sh(args: Array) -> String:
	var out: Array = []
	OS.execute(ProjectSettings.globalize_path("res://lane.sh"), args, out, true)
	return "\n".join(out)


func _s02_the_lock() -> void:
	print("\n§0.2 — one process a lane: a lane in use is refused by name and another handed out, driven")
	var src := Gate.strip_comments(_doc("res://lane.sh"))
	ok(src.contains("godot)   lane=\"$2\"; shift 2; check \"$lane\" >&2 || exit 1; lane=$(_lane_or_handout \"$lane\") || exit 1"),
		"§0.2: lane.sh's `godot` door launches without asking whether the lane is in use")
	ok(src.contains("battery) lane=\"$2\"; shift 2; check \"$lane\" || exit 1; lane=$(_lane_or_handout \"$lane\") || exit 1"),
		"§0.2: lane.sh's `battery` door launches without asking whether the lane is in use")
	var tmp_out: Array = []
	OS.execute("mktemp", ["-d"], tmp_out)
	var tmp := String(tmp_out[0]).strip_edges() if not tmp_out.is_empty() else ""
	# the directory as Godot will print its own res:// — `/var` is `/private/var` on this system
	var real_out: Array = []
	if tmp != "":
		OS.execute("/bin/zsh", ["-c", "cd '%s' && pwd -P" % tmp], real_out)
		tmp = String(real_out[0]).strip_edges() if not real_out.is_empty() else tmp
	ok(tmp != "" and DirAccess.dir_exists_absolute(tmp), "§0.2: no scratch directory could be made for the drive")
	if tmp == "":
		return
	var f := FileAccess.open(tmp.path_join("iw_sleeper.gd"), FileAccess.WRITE)
	f.store_string(SLEEPER)
	f.close()
	var lane := tmp.path_join("lane")
	var made := _sh(["probe", lane, "IW lock", tmp.path_join("iw_sleeper.gd")])
	ok(made.contains("LANE OK"), "§0.2: the bare probe the drive runs in could not be made: %s" % made.strip_edges())
	# THE IDLE ARM: a lane nothing runs in runs the launch in place.
	var idle := _sh(["godot", lane, "--headless", "--script", "res://iw_sleeper.gd", "--", "quick"])
	ok(idle.contains("IWLOCK ran in %s/" % lane) and not idle.contains("LANE BUSY"),
		"§0.2: an idle lane did not run the launch in place — the lock refuses a lane in use, never an idle one: %s" % idle.strip_edges().right(300))
	# THE BUSY ARM: a long launch held, then a second into the same lane.
	var pid := OS.create_process(ProjectSettings.globalize_path("res://lane.sh"), ["godot", lane, "--headless", "--script", "res://iw_sleeper.gd"])
	var busy := ""
	var t0 := Time.get_ticks_msec()
	while busy == "" and Time.get_ticks_msec() - t0 < 15000:
		OS.delay_msec(250)
		busy = _sh(["busy", lane]).strip_edges()
	ok(busy == str(pid), "§0.2: `lane.sh busy` does not name the one Godot running in the lane (pid %d): '%s'" % [pid, busy])
	var second := _sh(["godot", lane, "--headless", "--script", "res://iw_sleeper.gd", "--", "quick"])
	var ran_in_place := second.contains("IWLOCK ran in %s/" % lane)
	ok(not ran_in_place, "§0.2: DRIVEN — a second launch ran in a lane already running Godot (pid %d): two processes in one lane share its user:// and race the harness save" % pid)
	ok(second.contains("LANE BUSY: %s already runs Godot (pid %d)" % [lane, pid]),
		"§0.2: DRIVEN — the refusal does not name the lane and the pid it found running there")
	ok(second.contains("LANE HANDED OUT: %s-2" % lane),
		"§0.2: DRIVEN — a lane in use was refused with no way forward: no lane was handed out (a refusal with no way forward is a rule wearing a lock's clothes)")
	ok(second.contains("IWLOCK ran in %s-2/" % lane), "§0.2: DRIVEN — the launch did not run in the lane handed out: %s" % second.strip_edges().right(200))
	if pid > 0:
		OS.kill(pid)
	OS.execute("rm", ["-rf", tmp])
	print("    CHECKED both doors, an idle lane run in place, a busy lane refused by name (pid %d) and another handed out and run" % pid)


# ── §0.3 — `DOD_ZONE_ROTATION` IS THE SIM's, DRIVEN ──────────────────────────────────────────────────
# A flag that changes what a run contains is the sim's: with it exported a player's run draws each pool's first zone, and a sim
# reaches the draw. The absence (a player's run does not read it) and the positive arm (the sim does) are one drive; `check_iv`
# §2 holds its row (GATED, its guard) beside the other five.
func _s03_the_zone_flag() -> void:
	print("\n§0.3 — DOD_ZONE_ROTATION is the sim's: a player's run does not read it, a sim does")
	var body := Gate.fn_body("scripts/run_state.gd", "rotation_enabled", _docs)
	ok(Gate.strip_comments(body).contains("return sim_run and OS.get_environment(\"DOD_ZONE_ROTATION\") == \"1\""),
		"§0.3: `Run.rotation_enabled` reads DOD_ZONE_ROTATION with no sim gate — a flag that changes what a run contains is the sim's")
	var was: bool = _run.sim_run
	OS.set_environment("DOD_ZONE_ROTATION", "1")
	_run.sim_run = false
	ok(not _run.rotation_enabled(), "§0.3: DRIVEN — `DOD_ZONE_ROTATION=1` reached a player's run: it changes what a run contains with nothing to say so")
	_run.sim_run = true
	ok(_run.rotation_enabled(), "§0.3: DRIVEN — under the sim `DOD_ZONE_ROTATION=1` no longer arms: the gate shut the sim's arm too")
	_run.sim_run = was
	OS.set_environment("DOD_ZONE_ROTATION", "")
	print("    CHECKED the guard and both arms, a player's run and a sim's")


# ── §1 — THE LADDER's MEASUREMENT IS KEPT, AND THE ARM FOLLOWS FROM IT ───────────────────────────────
# THE TWO KEPT TABLES are the screen (every candidate population's five readings: health at a bargain fight's end, ± se over runs)
# and the ladder on the winner (every modifier). **The rule is the pre-registered one** (`docs/reports/IW.md` §1): R5 is the spread
# of a candidate's five readings over their mean 2se and the largest wins; R4 the same over the four above the lowest; a LEVEL
# opens at the cheapest reading and each next joins it while within two standard errors of the difference of the level's first;
# a CUT at IO's counts (6 / 6 / 4 / 4 / 3) is REAL when its two neighbours sit in different levels; ARM A when the best R5 is 4 or
# more and every cut is real, ARM B otherwise. Re-derived here off the readings, so a table hand-edited out of its own arithmetic
# reds.
const SCREEN := "docs/reports/IW-screen.tsv"
const LADDER := "docs/reports/IW-ladder.tsv"
const IO_COUNTS := [6, 6, 4, 4, 3]
const R_FLOOR := 4.0


func _ratio(rows: Array) -> float:
	var vals: Array = []
	var ses := 0.0
	for r in rows:
		vals.append(float(r["reading"]))
		ses += float(r["se"])
	if rows.is_empty() or ses <= 0.0:
		return 0.0
	return (vals.max() - vals.min()) / (2.0 * ses / rows.size())


# The arm the tables give: [best R5, the winner's id, the ladder's levels (per sorted row), the cuts real, "A" or "B"].
func _the_arm() -> Dictionary:
	var srows := _tsv("res://" + SCREEN, ["candidate", "population", "arm", "reading", "se", "R5", "R4"])
	var by := {}
	for r in srows:
		var c := String(r["candidate"])
		if not by.has(c):
			by[c] = []
		(by[c] as Array).append(r)
	var best := -1.0
	var winner := ""
	var bad_ratio: Array = []
	for c in by:
		var five: Array = by[c]
		var five_sorted := five.duplicate()
		five_sorted.sort_custom(func(a, b): return float(a["reading"]) > float(b["reading"]))
		var r5 := _ratio(five)
		var r4 := _ratio(five_sorted.slice(0, 4))
		if absf(r5 - float(five[0]["R5"])) > 0.05 or absf(r4 - float(five[0]["R4"])) > 0.05:
			bad_ratio.append("%s (R5 %.2f, R4 %.2f, written %s / %s)" % [c, r5, r4, five[0]["R5"], five[0]["R4"]])
		if five.size() == 5 and r5 > best:
			best = r5
			winner = c
	var lrows := _tsv("res://" + LADDER, ["modifier", "id", "reading", "se", "n_with_bargain", "grade", "io_cut_grade", "level", "supported", "handle_kind", "handle"])
	lrows.sort_custom(func(a, b): return float(a["reading"]) > float(b["reading"]))
	var levels: Array = []
	var lvl := 0
	var anchor := {}
	for r in lrows:
		if anchor.is_empty() or float(anchor["reading"]) - float(r["reading"]) > 2.0 * sqrt(pow(float(anchor["se"]), 2) + pow(float(r["se"]), 2)):
			lvl += 1
			anchor = r
		levels.append(lvl)
	var real: Array = []
	var at := 0
	for i in range(IO_COUNTS.size() - 1):
		at += int(IO_COUNTS[i])
		real.append(at < levels.size() and levels[at - 1] != levels[at])
	var all_real := real.size() == 4 and not real.has(false)
	return {"screen": srows, "by": by, "best": best, "winner": winner, "bad_ratio": bad_ratio, "ladder": lrows,
		"levels": levels, "real": real, "arm": "A" if best >= R_FLOOR and all_real else "B"}

# RE-POINTED AT JB §2: THIS GATE'S KEPT TABLES WERE TAKEN ON THE DECK BEFORE JB's FOUR, AND EACH OF THE FOUR NAMES THE BATCH THAT
# GRADED IT, SO THE DECK THEY MEASURED IS READ OFF THE ROWS AND NEVER OFF A LIST (`check_jb` §3 holds the four).
func _deck_before_jb() -> Dictionary:
	var out := {}
	var mods: Dictionary = _run.MODIFIERS
	for id in mods:
		if not String((mods[id] as Dictionary).get("graded", "")).contains("JB §"):
			out[id] = mods[id]
	return out


func _s1_the_ladder() -> void:
	print("\n§1 — the ladder's measurement is kept: the screen, the ladder, and the arm they give")
	var a := _the_arm()
	var by: Dictionary = a["by"]
	ok(by.size() >= 5, "§1: the screen holds %d candidate populations — the brief asked for the screen to be derived, and it read nine" % by.size())
	var short: Array = []
	for c in by:
		if (by[c] as Array).size() != 5:
			short.append(c)
	ok(short.is_empty(), "§1: candidates without their five readings: %s" % str(short))
	ok((a["bad_ratio"] as Array).is_empty(), "§1: %d candidates' written R5 or R4 is not the ratio their own readings give: %s" % [(a["bad_ratio"] as Array).size(), str(a["bad_ratio"])])
	var lrows: Array = a["ladder"]
	var mods: Dictionary = _deck_before_jb()
	# RE-POINTED AT IZ §3 and §5: the ladder measured the two IZ removed (Dull Edge, Tinderbox); every modifier the deck holds is on it.
	var removed_at_iz := ["dulledge", "tinderbox"]
	ok(lrows.size() == mods.size() + removed_at_iz.size(), "§1: the ladder holds %d modifiers and the deck %d — every modifier is measured" % [lrows.size(), mods.size()])
	var thin: Array = []
	var foreign: Array = []
	var lvl_bad: Array = []
	var levels: Array = a["levels"]
	for i in lrows.size():
		var r: Dictionary = lrows[i]
		if not mods.has(String(r["id"])) and not removed_at_iz.has(String(r["id"])):
			foreign.append(String(r["id"]))
		if int(r["n_with_bargain"]) < 40:
			thin.append("%s n=%s" % [r["modifier"], r["n_with_bargain"]])
		if int(r["level"]) != int(levels[i]):
			lvl_bad.append("%s written level %s, its reading gives %d" % [r["modifier"], r["level"], levels[i]])
	ok(foreign.is_empty(), "§1: the ladder names modifiers the deck does not hold: %s" % str(foreign))
	ok(thin.is_empty(), "§1: %d modifiers were read on fewer than 40 runs with a bargain fight: %s" % [thin.size(), str(thin)])
	ok(lvl_bad.is_empty(), "§1: %d ladder rows' levels are not the levels their readings give by the pre-registered rule: %s" % [lvl_bad.size(), str(lvl_bad)])
	# THE DOCUMENT CARRIES THE LADDER's FIGURES AND SAYS WHICH ARM RAN, AND THAT IP's ARE SUPERSEDED.
	var st := _doc("res://docs/state.md")
	var missing: Array = []
	for r in lrows:
		if removed_at_iz.has(String(r["id"])):
			continue
		# RE-POINTED AT JA §1: the ladder names a card as IW knew it, and the state file's table carries it under the name the deck
		# gives it today (the card IW read as the old name is Leaden since JA; its id is unmoved).
		var shown := String((mods.get(String(r["id"]), {}) as Dictionary).get("name", r["modifier"]))
		if not st.contains("| %s | %.3f" % [shown, float(r["reading"])]):
			missing.append(shown)
	ok(missing.is_empty(), "§1: %d modifiers' readings are not the figures docs/state.md's grades table carries: %s" % [missing.size(), str(missing)])
	# RE-POINTED AT IX §3: IX archived IW's grades block word for word, its heading struck as superseded by the cost scale, so
	# the arm IW's tables gave and the ladder's figures replacing IP's are IW's record, read where that record lives; the
	# readings above stay the live file's, IX's grades table carrying them.
	var arch := _doc("res://DoD-archive/state-archive.md")
	ok(arch.contains(ARM_NEEDLE[a["arm"]]), "§1: the state archive does not keep the arm the tables give (%s) — the screen's best R5 is %.2f and the cuts real %s" % [a["arm"], a["best"], str(a["real"])])
	ok(arch.contains(SUPERSEDED_NEEDLE), "§1: the state archive does not keep the ladder's figures replacing IP's — the measurement replaces the record rather than checking it")
	print("    CHECKED %d candidates (the winner %s, R5 %.2f), %d modifiers on its ladder, %d levels, cuts real %s — arm %s" % [
		by.size(), a["winner"], a["best"], lrows.size(), levels.max() if not levels.is_empty() else 0, str(a["real"]), a["arm"]])


# ── §2 — EVERY GRADE CARRIES ITS MEASUREMENT, AND EVERY HANDLE IS READ AT ITS SOURCE ─────────────────
# A modifier's severity in the game is the grade its row of the ladder names — the grade as it stands on arm B, the re-cut on
# arm A — so a grade moved with no reading behind it reds. And each handle the ladder names (a percentage, a count, a duration —
# or a rule, which has none) is found in that modifier's own arm of `battle._stamp_modifier`, or as the constant it reads, and
# its figure is PRINTED from there: the documents name the handle and never type its figure, so a re-tune at the source moves the
# print and reds nothing (IW's R01).
func _s2_the_grades() -> void:
	print("\n§2 — every grade carries its measurement; every handle is read at its source")
	var a := _the_arm()
	var lrows: Array = a["ladder"]
	var mods: Dictionary = _run.MODIFIERS
	var moved: Array = []
	var arm_bad: Array = []
	# RE-POINTED AT IX §3: the grade a reading gives is the cost scale's (`docs/reports/IX-scale.tsv`, IX's arithmetic on these
	# readings); the ladder's `grade` column is the grade as it stood at IW, kept as the record.
	var scaled := {}
	# RE-POINTED AT IY §4: the measurement behind every grade is IY's grades table (the highest cost measured, test-bound).
	# RE-POINTED AT IZ §2: it is IZ's since — the sharper reading of one population replaces the blunter (IZ §0.1) — and the two
	# IZ removed are the ladder's record, not the deck's.
	var removed_at_iz := ["dulledge", "tinderbox"]
	# RE-POINTED AT JA §2: the grades of record are JA's table since Fleeting was re-read in the deck at three turns off.
	for sr in _tsv("res://docs/reports/JA-grades.tsv", ["id", "grade"]):
		scaled[String(sr["id"])] = String(sr["grade"])
	for r in lrows:
		var id := String(r["id"])
		if removed_at_iz.has(id):
			continue
		var sev := int((mods.get(id, {}) as Dictionary).get("severity", 0))
		if not scaled.has(id) or sev != int(scaled[id]):
			moved.append("%s carries severity %d, its measurement reads grade %s" % [r["modifier"], sev, scaled.get(id, "none")])
		if a["arm"] == "A" and int(r["grade"]) != int(r["io_cut_grade"]):
			arm_bad.append(String(r["modifier"]))
	ok(moved.is_empty(), "§2: %d modifiers carry a grade no reading is behind — every grade carries its measurement: %s" % [moved.size(), str(moved)])
	ok(arm_bad.is_empty(), "§2: arm A re-sets every grade from the measurement, and %d rows' grade is not their re-cut: %s" % [arm_bad.size(), str(arm_bad)])
	# THE HANDLES, AT THEIR SOURCE.
	var src := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_stamp_modifier", _docs))
	var lost: Array = []
	var printed: Array = []
	var unsupported := 0
	var unnamed: Array = []
	for r in lrows:
		var id := String(r["id"])
		if removed_at_iz.has(id):
			continue
		var kind := String(r["handle_kind"])
		var handle := String(r["handle"])
		# RE-POINTED AT IZ §4: Leaden (Frenzied then) is re-keyed — the field its arm writes is the flat amount, `mod_speed_add`.
		if id == "frenzied" and handle == "mod_speed_mult":
			handle = "mod_speed_add"
		if String(r["supported"]) == "no":
			unsupported += 1
			if kind == "":
				unnamed.append(String(r["modifier"]))
		if kind == "":
			continue
		var at := src.find("\"%s\":" % id)  # the modifier's own arm of the match
		var arm_body := Gate.block(src, at) if at >= 0 else ""
		var body_for := arm_body
		if handle.contains("@"):
			body_for = Gate.strip_comments(Gate.fn_body("scripts/battle.gd", handle.get_slice("@", 1), _docs))
			handle = handle.get_slice("@", 0)
		if handle.begins_with("Run."):
			var c := handle.trim_prefix("Run.")
			var cmap: Dictionary = _run.get_script().get_script_constant_map()
			if not body_for.contains(handle) or not cmap.has(c):
				lost.append("%s's %s" % [r["modifier"], handle])
			else:
				printed.append("%s %s = %s" % [r["modifier"], handle, str(cmap[c])])
		else:
			if not body_for.contains(handle):
				lost.append("%s's `%s`" % [r["modifier"], handle])
			else:
				var line := ""
				for l in body_for.split("\n"):
					if l.contains(handle):
						line = l.strip_edges()
						break
				printed.append("%s: %s" % [r["modifier"], line])
	ok(lost.is_empty(), "§2: %d handles the ladder names are not in their modifier's arm of `_stamp_modifier`: %s" % [lost.size(), str(lost)])
	ok(unnamed.is_empty(), "§2: %d modifiers whose grade the measurement does not support name no handle (a rule says `rule`): %s" % [unnamed.size(), str(unnamed)])
	for p in printed:
		print("      handle  %s" % p)
	print("    CHECKED %d grades against their readings (%d unsupported), %d handles read at their source" % [lrows.size(), unsupported, printed.size()])


# ── §3 — NO SUPERSEDED-PENDING MARK OUTLIVES ITS RE-TAKE ─────────────────────────────────────────────
# IV's kept table names the eleven figures its drive moved and the mark each wears in `docs/state.md`; IW's re-take table names
# what IW re-took, each with the figure written where the record stood. **A mark whose figure was re-taken is gone** (the stale
# claim the mark was invented to prevent), **and the figure IW took stands**; a mark IW did not re-take still stands with what it
# waits on (`check_iv` §1c holds those). The two figures IV's drive could not read are rows too, with no IV figure beside them.
const DRIVE_TABLE := "docs/reports/IV-drive.tsv"
const RETAKE := "docs/reports/IW-retake.tsv"


func _s3_the_retakes() -> void:
	print("\n§3 — no superseded-pending mark outlives its re-take")
	var st := _flat(_doc("res://docs/state.md"))
	var rt := _tsv("res://" + RETAKE, ["arm", "figure", "record", "iw", "iw_se", "n", "state_needle"])
	var taken := {}
	var unwritten: Array = []
	for r in rt:
		taken["%s|%s" % [r["arm"], r["figure"]]] = r
		if String(r["state_needle"]).length() < 8 or not st.contains(_flat(String(r["state_needle"]))):
			unwritten.append("%s %s" % [r["arm"], r["figure"]])
	ok(rt.size() >= 11, "§3: the re-take table holds %d rows — IV marked eleven figures and IW reads two IV could not" % rt.size())
	ok(unwritten.is_empty(), "§3: %d re-taken figures are not written in docs/state.md where the record stood: %s" % [unwritten.size(), str(unwritten)])
	var drive := _tsv("res://" + DRIVE_TABLE, ["arm", "figure", "verdict", "recorded", "mark"])
	var outlived: Array = []
	var marks := 0
	for r in drive:
		if String(r["verdict"]) != "MOVES" or String(r["recorded"]) == "" or String(r["mark"]) == "":
			continue
		marks += 1
		var key := "%s|%s" % [r["arm"], r["figure"]]
		if taken.has(key) and st.contains(_flat(String(r["mark"]))):
			outlived.append(key)
	ok(marks >= 11, "§3: IV's table names %d marked figures — the arm below would prove nothing over fewer" % marks)
	ok(outlived.is_empty(), "§3: %d SUPERSEDED-PENDING marks stand over a figure IW re-took — a mark that outlives its re-take is the stale claim it was invented to prevent: %s" % [outlived.size(), str(outlived)])
	print("    CHECKED %d re-taken figures written, %d of IV's marks read against them" % [rt.size(), marks])
