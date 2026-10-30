# BATCH IX — THE BASELINE's OWN ERROR BAR, AND WHY THE FREE MODIFIERS ARE FREE.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: the grade scale is a cost band on a named party (`CLAUDE.md`); the
#        modifiers that cost nothing are the work and the rest a scale, not a re-cut (`docs/state.md`); an arm that measures
#        nothing happening is an arm, with a count, a seed and an error bar (`docs/instrument-rules.md`).
#   §1   THE BASELINE IS AN ARM: the *none* arm stands in the kept table with its seed, its runs, its count and its error bar,
#        and the state file carries it; it is read by the rule that counts the same fights the arms count — on every arm the
#        node reading and the modifier reading count the same fights — and every modifier's verdict follows its own paired z.
#   §2   WHY EACH IS FREE: the one-sided arms' table — every free modifier's halves with their errors — and the cause each row
#        names is the cause the pre-registered rule gives off its own figures.
#   §3   THE GRADE SCALE IS A COST: the cuts derived here off `docs/reports/IW-ladder.tsv`'s levels and the baseline are the
#        cuts written beside the modifier table and in `CLAUDE.md`; every severity in the game is the band its own cost falls
#        in, by arithmetic; a modifier under the first cut carries no severity; the reference party is named beside the scale
#        and is the sim's default party; the rung bands are read, not re-set, and the state file reports what each holds.
#   §4   THE SWING: every modifier's cost on the incumbent banded on the same scale; the state file names every modifier whose
#        two bands lie more than one apart, and no other — the swing between these two populations.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** It holds the tables' arithmetic and the documents' agreement with it — never that
# the readings are what the sim produces: that is the drive (`docs/reports/IX.md` §1–§2), which no gate re-runs, and its fidelity
# proof is in the report. A re-tune of a modifier's handle moves no figure here until it is measured again.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ix.gd
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
	print("BATCH IX — THE BASELINE's OWN ERROR BAR, AND WHY THE FREE MODIFIERS ARE FREE")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	var scale := _s3_the_scale()
	_s1_the_baseline()
	_s2_the_halves()
	_s4_the_swing(scale)
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


const SCALE_TSV := "docs/reports/IX-scale.tsv"
const HALVES_TSV := "docs/reports/IX-onesided.tsv"
const SWING_TSV := "docs/reports/IX-swing.tsv"
const LADDER := "docs/reports/IW-ladder.tsv"
# The rule IX §3 states, one line of `CLAUDE.md` and one of the comment above `Run.MODIFIERS`; its figures are parsed, never typed here.
const SCALE_RX := "no severity under ([0-9.]+); 1 to ([0-9.]+); 2 to ([0-9.]+); 3 to ([0-9.]+); 4 to ([0-9.]+); 5 from ([0-9.]+)"
# The party the scale is a cost on, named beside it in both files (IX §0.2).
const PARTY := "the sim's default party — the Berserker, the Cryomancer, the Devout and the Beastmaster — untalented, at Wanderer"
const PARTY_SPECS := "[\"berserker\", \"cryomancer\", \"inquisitor\", \"beastmaster\"]"
# How far beside the scale the party must stand to be beside it.
const BESIDE := 1600
# What the rungs dealt from when the scale was taken: the bands are read here, never re-set (IX §3).
const BANDS := {"wanderer": [[1, 2], [3, 4]], "warden": [[1, 3], [4, 4]], "ruin": [[3, 4], [5, 5]]}
# RE-POINTED AT IZ §3 and §5: the modifiers IZ removed (Dull Edge for no reach, Tinderbox by §5's stop condition) — IX's tables
# measured them, so IX's record names them and the deck does not.
const REMOVED_AT_IZ := ["dulledge", "tinderbox"]


# ── §0 — THE RULINGS, EACH WHERE A FUTURE SESSION READS IT ──────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var ir := _doc("res://docs/instrument-rules.md")
	var state := _doc("res://docs/state.md")
	ok(claude.contains("A MODIFIER's SEVERITY IS WHAT IT COSTS THE REFERENCE PARTY's HEALTH AT A BARGAIN FIGHT's END"),
		"§3: CLAUDE.md does not define a severity as what a modifier costs the reference party at a bargain fight's end")
	ok(claude.contains("THE PARTY IS PART OF THE DEFINITION AND IS WRITTEN BESIDE THE SCALE"),
		"§0.2: CLAUDE.md does not say the reference party is part of the definition")
	ok(claude.contains("A MODIFIER THAT COSTS NOTHING HAS NO SEVERITY"),
		"§3: CLAUDE.md does not say a modifier that costs nothing has no severity")
	ok(state.contains("THE MODIFIERS THAT COST NOTHING ARE THE WORK; THE REST ARE A SCALE, NOT A RE-CUT"),
		"§0.1: docs/state.md does not carry the ruling that the free modifiers are the work and the rest a scale")
	ok(ir.contains("AN ARM THAT MEASURES NOTHING HAPPENING IS AN ARM, WITH A COUNT, A SEED AND AN ERROR BAR."),
		"§1: the instrument rules do not carry the ruling — an arm that measures nothing happening is an arm, with a count, a seed and an error bar")
	print("    CHECKED five rulings in their files")


# ── §1 — THE BASELINE IS AN ARM, AND IT COUNTS THE FIGHTS THE ARMS COUNT ────────────────────────────
func _s1_the_baseline() -> void:
	print("\n§1 — the baseline is an arm: its count, its seed, its error bar, and the fights it counts")
	var rows := _tsv("res://" + SCALE_TSV, ["arm", "id", "seed_block", "runs", "n_with_bargain", "rule", "fights_read", "fights_node",
		"fights_mod", "reading", "se", "cost", "d", "d_se", "z", "verdict", "grade"])
	var base: Dictionary = {}
	for r in rows:
		if String(r["id"]) == "none":
			base = r
	ok(not base.is_empty(), "§1: the kept table carries no *none* arm — the baseline is the one number that makes the others mean anything")
	if base.is_empty():
		return
	ok(int(base["seed_block"]) > 0 and int(base["runs"]) > 0 and int(base["n_with_bargain"]) > 0,
		"§1: the *none* arm carries no seed block, no run count or no count of runs it read (%s / %s / %s)" % [base["seed_block"], base["runs"], base["n_with_bargain"]])
	ok(String(base["se"]).is_valid_float() and float(base["se"]) > 0.0,
		"§1: the *none* arm carries no error bar ('%s') — an arm that measures nothing happening is an arm, with an error bar" % base["se"])
	# THE SAME FIGHTS. The arms are read by the modifier rule (a bargain fight where a modifier stood); the *none* arm lays no
	# modifier, so it is read by node — and the two are one rule only because, on every arm, they count the same fights.
	ok(String(base["rule"]) == "node" and int(base["fights_read"]) == int(base["fights_node"]) and int(base["fights_node"]) > 0,
		"§1: the baseline is read by the '%s' rule and counts %s of its %s bargain fights — read by the rule the arms count by, it counts none of them" % [
			base["rule"], base["fights_read"], base["fights_node"]])
	var differ: Array = []
	var verdicts_bad: Array = []
	var arms := 0
	for r in rows:
		if String(r["id"]) == "none":
			continue
		arms += 1
		if int(r["fights_node"]) != int(r["fights_mod"]) or int(r["fights_read"]) != int(r["fights_mod"]):
			differ.append("%s (node %s, modifier %s, read %s)" % [r["arm"], r["fights_node"], r["fights_mod"], r["fights_read"]])
		var z := float(r["d"]) / maxf(float(r["d_se"]), 1e-9)
		var want := "costs nothing"
		if z >= 2.0:
			want = "pays the party"
		elif z <= -2.0:
			want = "costs something"
		if String(r["verdict"]) != want or absf(z - float(r["z"])) > 0.01:
			verdicts_bad.append("%s (z %.2f, written %s / %s)" % [r["arm"], z, r["z"], r["verdict"]])
	ok(differ.is_empty(), "§1: %d arms count different fights by node and by modifier — a baseline read by a different rule than the arms is not a baseline: %s" % [differ.size(), str(differ)])
	ok(verdicts_bad.is_empty(), "§1: %d verdicts are not their own paired z's: %s" % [verdicts_bad.size(), str(verdicts_bad)])
	# RE-POINTED AT IZ: the deck holds IX's arms less the modifiers IZ removed.
	ok(arms == (_run.MODIFIERS as Dictionary).size() + REMOVED_AT_IZ.size(), "§1: the kept table reads %d modifier arms — the deck holds %d" % [arms, (_run.MODIFIERS as Dictionary).size()])
	# THE RECORD CARRIES THE ERROR BAR: the state file's grades block states the baseline with its se and its count.
	var want_line := "%.3f ± %.3f" % [float(base["reading"]), float(base["se"])]
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck, `DoD-archive/state-archive.md`), so a figure IY or IX
	# recorded there is read where that record lives; the live block is IZ's.
	var grades := _block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~")
	ok(_flat(grades).contains(want_line) and _flat(grades).contains("%d runs" % int(base["runs"])),
		"§1: the state file's grades block does not carry the baseline with its error bar and its count ('%s', %d runs)" % [want_line, int(base["runs"])])
	print("    CHECKED the baseline (%s ± %s, %s runs, block %s, %s fights by node) and %d arms' fights and verdicts" % [
		base["reading"], base["se"], base["runs"], base["seed_block"], base["fights_node"], arms])


# The block of a markdown file that opens with `head`, to the next heading of its level or above.
func _block(doc: String, head: String) -> String:
	var a := doc.find("\n" + head)
	if a < 0:
		return ""
	var b := doc.find("\n### ", a + 1)
	var c := doc.find("\n## ", a + 1)
	if b < 0 or (c >= 0 and c < b):
		b = c
	return doc.substr(a, (b - a) if b > a else -1)


# ── §2 — WHY EACH FREE MODIFIER IS FREE ─────────────────────────────────────────────────────────────
# The pre-registered rule (IX §2): a half MOVES the party when |z| ≥ 2. W > 0 moving: the warband's half pays the party.
# P > 0 moving with W < 0: the party's own half pays it (the mirror). Neither moving: the magnitude is too small. One half
# charging (moving, negative) while the other is silent: one half charges. Every cause that holds is named.
func _causes(P: float, Pse: float, W: float, Wse: float) -> Array:
	var zp := P / maxf(Pse, 1e-9)
	var zw := W / maxf(Wse, 1e-9)
	var out: Array = []
	if zw >= 2.0:
		out.append("the warband's half pays the party")
	if zp >= 2.0 and W < 0.0:
		out.append("the party's own half pays the party")
	if absf(zp) < 2.0 and absf(zw) < 2.0:
		out.append("the magnitude is too small")
	if (zp <= -2.0 and absf(zw) < 2.0) or (zw <= -2.0 and absf(zp) < 2.0):
		out.append("one half charges")
	return out


func _s2_the_halves() -> void:
	print("\n§2 — why each free modifier is free: the halves, and the cause the rule gives")
	var rows := _tsv("res://" + HALVES_TSV, ["modifier", "id", "one_reading", "one_se", "P", "P_se", "W", "W_se", "net", "net_se", "cause"])
	var bad: Array = []
	var no_err: Array = []
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck, `DoD-archive/state-archive.md`), so a figure IY or IX
	# recorded there is read where that record lives; the live block is IZ's.
	var grades := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	var unnamed: Array = []
	for r in rows:
		# An error is a number, and it may be zero: a half whose every run reads its twin's (Parched's warband half) has none.
		if not (String(r["P_se"]).is_valid_float() and String(r["W_se"]).is_valid_float() and String(r["net_se"]).is_valid_float()) \
				or float(r["P_se"]) <= 0.0 or float(r["net_se"]) <= 0.0 or float(r["W_se"]) < 0.0:
			no_err.append(String(r["modifier"]))
		var want := ", ".join(PackedStringArray(_causes(float(r["P"]), float(r["P_se"]), float(r["W"]), float(r["W_se"]))))
		if String(r["cause"]) != want:
			bad.append("%s (written '%s', the rule gives '%s')" % [r["modifier"], r["cause"], want])
		if not grades.contains("%s — %s" % [String(r["modifier"]), want]):
			unnamed.append("%s — %s" % [r["modifier"], want])
	ok(rows.size() >= 6, "§2: the one-sided table holds %d rows — every free modifier has its arm" % rows.size())
	ok(no_err.is_empty(), "§2: %d one-sided rows carry no error on a half: %s" % [no_err.size(), str(no_err)])
	ok(bad.is_empty(), "§2: %d causes are not the ones the pre-registered rule gives off their own figures: %s" % [bad.size(), str(bad)])
	ok(unnamed.is_empty(), "§2: the state file's grades block does not name %d causes as the rule gives them: %s" % [unnamed.size(), str(unnamed)])
	# THE POPULATION: every modifier the scale leaves without a severity has its one-sided arm.
	var have := {}
	for r in rows:
		have[String(r["id"])] = true
	var missing: Array = []
	for id in _run.MODIFIERS:
		if int(_run.modifier_severity(String(id))) == 0 and not have.has(String(id)):
			missing.append(String(id))
	ok(missing.is_empty(), "§2: %d modifiers carry no severity and have no one-sided arm: %s" % [missing.size(), str(missing)])
	print("    CHECKED %d one-sided rows against the rule" % rows.size())


# ── §3 — THE GRADE SCALE IS A COST ──────────────────────────────────────────────────────────────────
# Returns {cuts: [free|1, 1|2, 2|3, 3|4, 4|5] in points, base: the baseline} for §4.
func _s3_the_scale() -> Dictionary:
	print("\n§3 — the grade scale is a cost: the derivation, the written scale, every grade by arithmetic, the party, the bands")
	var srows := _tsv("res://" + SCALE_TSV, ["id", "reading", "se", "cost", "grade"])
	var base := -1.0
	for r in srows:
		if String(r["id"]) == "none":
			base = float(r["reading"])
	ok(base > 0.0, "§3: no baseline to cost against")
	# THE DERIVATION, off IW's kept ladder: a level's cost is the baseline less the mean of its readings; the cuts are the
	# midpoints between adjacent levels' costs; the five grades are levels 2, 3, 4, 5 and 6 onward.
	var lrows := _tsv("res://" + LADDER, ["id", "reading", "level"])
	var sums := {}
	var ns := {}
	for r in lrows:
		var L := int(r["level"])
		sums[L] = float(sums.get(L, 0.0)) + float(r["reading"])
		ns[L] = int(ns.get(L, 0)) + 1
	var cost := {}
	for L in sums:
		cost[L] = base - float(sums[L]) / float(ns[L])
	var cuts: Array = []
	for L in [1, 2, 3, 4, 5]:
		cuts.append(100.0 * (float(cost.get(L, 0.0)) + float(cost.get(L + 1, 0.0))) / 2.0)
	ok(ns.size() >= 6, "§3: IW's ladder holds %d levels — the scale's five grades need six" % ns.size())
	print("    the derivation: the levels' costs %s points; the cuts %s" % [
		str(cost.keys().map(func(k): return "%d %.2f" % [k, 100.0 * float(cost[k])])), str(cuts.map(func(c): return "%.2f" % c))])
	# THE WRITTEN SCALE, in both files, is the derivation's.
	# RE-POINTED AT IZ §1: the derivation the documents state is IZ's — IX's arithmetic, unchanged, on the sharper readings
	# (`docs/reports/IZ-scale.tsv`, re-derived by `check_iz` §1: the sharper reading of one population replaces the blunter,
	# IZ §0.1); IX's own derivation off IW's readings is printed above as IX's record, and grades IX's table below.
	var iz_cut := {}
	var iz_lv := {}
	for zr in _tsv("res://docs/reports/IZ-scale.tsv", ["level", "level_iz", "cut_iz"]):
		iz_lv[int(zr["level"])] = float(zr["level_iz"]) / 100.0
		if String(zr["cut_iz"]) != "-":
			iz_cut[int(zr["level"])] = float(zr["cut_iz"])
	var stated: Array = [1, 2, 3, 4, 5].map(func(L): return float(iz_cut.get(L, -1.0)))
	var rx := RegEx.new()
	rx.compile(SCALE_RX)
	for path in ["res://CLAUDE.md", "res://scripts/run_state.gd"]:
		var flat := _flat(_doc(path).replace("#", " ").replace("*", ""))
		var m := rx.search(flat)
		ok(m != null, "§3: %s does not write the scale (no severity under …; 1 to …; … 5 from …)" % path)
		if m == null:
			continue
		var written: Array = []
		for k in range(1, 6):
			written.append(m.get_string(k))
		var derived: Array = stated.map(func(c): return "%.2f" % c)
		ok(str(written) == str(derived), "§3: %s writes the cuts %s — the derivation gives %s: the scale is the derivation's" % [path, str(written), str(derived)])
		ok(m.get_string(6) == m.get_string(5), "§3: %s's severity 5 opens at %s where 4 ends at %s" % [path, m.get_string(6), m.get_string(5)])
		# THE PARTY STANDS BESIDE THE SCALE (IX §0.2): the definition names its party within the paragraph that states it.
		var at := m.get_start()
		var near := flat.substr(maxi(at - BESIDE, 0), 2 * BESIDE)
		ok(near.contains(PARTY), "§0.2: %s does not name the reference party beside the scale — the party is part of the definition" % path)
	# THE CENTRES, WHERE A DOCUMENT STATES THEM: each grade's level cost, to a decimal (II §0.7 — a figure a text states is
	# held against what decides it).
	# RE-POINTED AT IZ §1: the centres the documents state are IZ's levels' costs (IZ-scale.tsv), as the cuts are.
	var centre: Array = [iz_lv.get(2, 0.0), iz_lv.get(3, 0.0), iz_lv.get(4, 0.0), iz_lv.get(5, 0.0), 9.9]
	var top := 9.9
	for L in iz_lv:
		if int(L) >= 6:
			top = minf(top, float(iz_lv[L]))
	centre[4] = top
	var want_c: Array = centre.map(func(c): return "%.1f" % (100.0 * float(c)))
	var crx := RegEx.new()
	crx.compile("a grade of about ([0-9.]+), ([0-9.]+), ([0-9.]+), ([0-9.]+) and ([0-9.]+) or more")
	var mrx := RegEx.new()
	mrx.compile("about ([0-9.]+)% for a 1, ([0-9.]+)% for a 2, ([0-9.]+)% for a 3, ([0-9.]+)% for a 4 and ([0-9.]+)% or more for a 5")
	for pair in [["res://CLAUDE.md", crx], ["res://docs/master.html", mrx]]:
		var ft := _flat(_doc(String(pair[0])).replace("<b>", "").replace("</b>", "").replace("*", ""))
		var cm: RegExMatch = (pair[1] as RegEx).search(ft)
		ok(cm != null, "§3: %s does not state the grades' centres" % pair[0])
		if cm != null:
			var got: Array = []
			for k in range(1, 6):
				got.append(cm.get_string(k))
			ok(str(got) == str(want_c), "§3: %s states the centres %s — the levels' costs are %s" % [pair[0], str(got), str(want_c)])
	# THE PARTY NAMED IS THE SIM's DEFAULT PARTY (its positive arm): `RunSim`'s default lineages are the four named.
	var sim := _doc("res://scripts/run_sim.gd")
	ok(sim.contains("var default_specs := " + PARTY_SPECS), "§0.2: the sim's default party is not the four the scale names (%s)" % PARTY_SPECS)
	# EVERY GRADE BY ARITHMETIC: the severity in the game is the band its own cost falls in, and under the first cut none.
	var mods: Dictionary = _run.MODIFIERS
	var off: Array = []
	var free_graded: Array = []
	var free := 0
	var graded := 0
	var counts := {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	# RE-POINTED AT IY §4: the grade a modifier carries is the highest cost measured on any population, test-bound — IY's kept
	# table, which `check_iy` §4 re-derives from both readings; IX's arithmetic on its own readings is IX's record, and the arm
	# below still holds IX's table to its own column.
	# RE-POINTED AT IZ §2: the grade is IZ's table's (`docs/reports/IZ-grades.tsv`, which `check_iz` §2 re-derives): the sharper
	# reading of one population replaces the blunter (IZ §0.1). A modifier IZ removed is IX's record and not the deck's.
	var iy := {}
	for gr in _tsv("res://docs/reports/IZ-grades.tsv", ["id", "grade"]):
		iy[String(gr["id"])] = int(gr["grade"])
	for r in srows:
		var id := String(r["id"])
		if id == "none" or REMOVED_AT_IZ.has(id):
			continue
		var c := 100.0 * (base - float(r["reading"]))
		var band := 0
		for k in cuts.size():
			if c >= float(cuts[k]):
				band = k + 1
		var sev := int((mods.get(id, {}) as Dictionary).get("severity", -1))
		var want := int(iy.get(id, -1))
		counts[want] = int(counts.get(want, 0)) + 1
		if want == 0:
			free += 1
			if sev != 0:
				free_graded.append("%s (graded none at IY, carries severity %d)" % [id, sev])
		else:
			graded += 1
			if sev != want:
				off.append("%s carries severity %d, the highest cost measured gives %d" % [id, sev, want])
		if int(r["grade"]) != band:
			off.append("%s: the kept table writes grade %s, its cost gives %d" % [id, r["grade"], band])
	ok(free_graded.is_empty(), "§3: %d modifiers cost nothing and carry a severity — a modifier that costs nothing has no severity: %s" % [free_graded.size(), str(free_graded)])
	ok(off.is_empty(), "§3: %d grades are not the band their own cost falls in — the arithmetic: %s" % [off.size(), str(off)])
	ok(free + graded == mods.size(), "§3: the kept table costs %d of the deck's %d modifiers" % [free + graded, mods.size()])
	# RE-POINTED AT IZ §0.3: a modifier keyed on what only some builds do is graded on one that does it, and one that costs nothing
	# even there leaves the deck — so the deck holds no free modifier, and the free arm's subject is `check_iz` §5's.
	ok(free == 0 and graded > 0, "§3: the scale reads %d free and %d graded — since IZ §0.3 the deck holds no free modifier" % [free, graded])
	# SEVERITY 5 ZEROES NO CLASS's KIT (IN §1's line), AND THE SCALE MOVED A MODIFIER INTO IT: Thin Air stops the turn-start drip
	# and nothing else, so what it can never take is a card that costs nothing — and every class's basic costs nothing.
	var at5: Array = []
	for id in mods:
		if int(_run.modifier_severity(String(id))) == 5:
			at5.append(String(id))
	ok(at5.has("thinair"), "§3: Thin Air does not stand at severity 5 — the scale gives it 5 (%s)" % str(at5))
	var dear: Array = []
	for k in ["warrior", "mage", "cleric", "hunter"]:
		var kit: Array = Classes.kit(k)
		if kit.is_empty() or int((kit[0] as Ability).cost) != 0:
			dear.append(k)
	ok(dear.is_empty(), "§3: a class's basic costs something under a severity-5 modifier that stops the drip — a kit Thin Air could zero: %s" % str(dear))
	# THE RUNG BANDS ARE READ, NOT RE-SET, AND THE STATE FILE SAYS WHAT EACH HOLDS.
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	for d in BANDS:
		var def: Dictionary = _run.DIFFICULTIES[d]
		ok(str(def["safe_band"]) == str(BANDS[d][0]) and str(def["gamble_band"]) == str(BANDS[d][1]),
			"§3: %s's bands read %s / %s — the scale reads the bands and never re-sets them (%s / %s)" % [d, str(def["safe_band"]), str(def["gamble_band"]), str(BANDS[d][0]), str(BANDS[d][1])])
		for k in 2:
			var band: Array = BANDS[d][k]
			var n := 0
			for id in mods:
				var s := int(_run.modifier_severity(String(id)))
				if s >= int(band[0]) and s <= int(band[1]):
					n += 1
			var says := "%s's %s band (%d–%d) holds %d" % [String(def["name"]), "safe" if k == 0 else "gamble", int(band[0]), int(band[1]), n]
			ok(grades.contains(says), "§3: the state file's grades block does not report '%s'" % says)
			ok(n >= 1, "§3: %s is empty — a band the rung deals from holds nothing" % says)
	print("    CHECKED the scale in two files against the derivation, %d grades by arithmetic (%d free), the party, and %d bands" % [graded + free, free, 6])
	print("    the grades the scale gives: none %d; 1 %d; 2 %d; 3 %d; 4 %d; 5 %d" % [counts[0], counts[1], counts[2], counts[3], counts[4], counts[5]])
	return {"cuts": cuts, "base": base}


# ── §4 — THE SWING BETWEEN THESE TWO ────────────────────────────────────────────────────────────────
func _s4_the_swing(scale: Dictionary) -> void:
	print("\n§4 — the swing between the reference party and the incumbent, banded on the one scale")
	var rows := _tsv("res://" + SWING_TSV, ["modifier", "id", "ref_cost", "ref_band", "inc_reading", "inc_cost", "inc_band", "swing"])
	var cuts: Array = scale.get("cuts", [])
	var inc_base := -1.0
	for r in rows:
		if String(r["id"]) == "none":
			inc_base = float(r["inc_reading"])
	ok(inc_base > 0.0, "§4: the swing table carries no incumbent baseline")
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck, `DoD-archive/state-archive.md`), so a figure IY or IX
	# recorded there is read where that record lives; the live block is IZ's.
	var block := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	var bad: Array = []
	var over: Array = []
	var named_wrong: Array = []
	var n := 0
	for r in rows:
		if String(r["id"]) == "none" or REMOVED_AT_IZ.has(String(r["id"])):
			continue
		n += 1
		var ic := 100.0 * (inc_base - float(r["inc_reading"]))
		var ib := 0
		var rb := 0
		for k in cuts.size():
			if ic >= float(cuts[k]):
				ib = k + 1
			if 100.0 * float(r["ref_cost"]) >= float(cuts[k]):
				rb = k + 1
		var sw := absi(ib - rb)
		if ib != int(r["inc_band"]) or rb != int(r["ref_band"]) or sw != int(r["swing"]):
			bad.append("%s (bands %d / %d, swing %d; written %s / %s, %s)" % [r["modifier"], rb, ib, sw, r["ref_band"], r["inc_band"], r["swing"]])
		var named := block.contains("%s swings %d bands" % [String(r["modifier"]), sw])
		if sw > 1:
			over.append(String(r["modifier"]))
			if not named:
				named_wrong.append("%s (swings %d, not named)" % [r["modifier"], sw])
		elif block.contains("%s swings" % String(r["modifier"])):
			named_wrong.append("%s (swings %d, named as a swing)" % [r["modifier"], sw])
	ok(bad.is_empty(), "§4: %d rows' bands or swing are not their costs' on the scale: %s" % [bad.size(), str(bad)])
	ok(n == (_run.MODIFIERS as Dictionary).size(), "§4: the swing is computed over %d modifiers — the deck holds %d" % [n, (_run.MODIFIERS as Dictionary).size()])
	ok(named_wrong.is_empty(), "§4: the state file's swing list is not the modifiers over one band: %s" % str(named_wrong))
	ok(not over.is_empty(), "§4: no modifier swings more than one band — the list's positive arm is empty")
	ok(block.contains("the swing between these two"),
		"§4: the swing is not called the swing between these two populations (two readings, not a range)")
	ok(not block.contains("the swing across builds"),
		"§4: the swing is called the swing across builds — it is two populations, not a range")
	print("    CHECKED %d modifiers' swing; over one band: %s" % [n, str(over)])
