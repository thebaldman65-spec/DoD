# BATCH IZ — THE PLACING, TWO RE-KEYS, AND A REMOVAL.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: the sharper reading of one population replaces the blunter (§0.1); a
#        modifier keyed on what only some builds do is graded on one that does it, and one keyed on what every build does that
#        costs nothing leaves the deck (§0.3); the removal's reason (§3) — `CLAUDE.md`, beside the scale; the two removed shapes
#        and the readings that removed them — the design notes.
#   §1   THE OLD VALUES AND THE CHEAP END ON THE NEW INSTRUMENT: the kept re-read table's arithmetic (cost, z, ratio, the tie with
#        the reading it replaces, the test-bound band); the scale re-derived off IW's levels with the sharper readings, and the cuts
#        the documents state are the derivation's; the twenty-seventh note's price — how many of the modifiers IX called free a
#        sharper reading at IX's own value finds under the old instrument's reach — stated where the eleven were recorded, the
#        state file's grades block.
#   §2   THE PLACING: every handle's live constant is the value its reading measured (a re-tune reds — R01); every grade is the
#        highest test-bound band of the readings that measure the modifier as it stands, and a reference reading graded is the
#        sharper one wherever one exists (C02); every severity in the game is its grade, every row names its population and batch;
#        the reverts hold their old values, and some modifier carries a grade (the positive arm).
#   §3   DULL EDGE AND TINDERBOX ARE REMOVED, NOT DISABLED: no file of the game names either, and the modifiers beside them still
#        are (the positive arm); DRIVEN, a save whose offer names them loads with those options dropped and a clean offer loads
#        whole, and a bargain taken under one is fought under none.
#   §4   FRENZIED ADDS: the stamp writes the flat amount, the speed reads it added and floored; the re-key's kept arms (the add,
#        its sign read, the subtraction driven because the add pays) and the amount shipped is one that costs the party; DRIVEN,
#        the turn order of a real board moves under the stamp — the property the multiplication could not have (C05).
#   §5   MUFFLED AND TINDERBOX ON THE POPULATIONS THEIR RULES NAME: each reading's arithmetic, the fire party's derivation, the
#        verdict the stop condition gives, and the deck holding what the verdicts leave (Tinderbox left by it, §3).
#   §6   WARDEN's BAND (IZ §0.4) AND THE CHANGELOG's CUT (IZ §6): the band is where its two arms' verdict puts it (C08); the live
#        changelog is under its bar, and the cut that put it there is the one its header records (C09).
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** It holds the kept tables' arithmetic, the code's doors and the documents' agreement with
# them — never that a reading is what the sim produces: that is the drive (`docs/reports/IZ.md` §1–§5), which no gate re-runs.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iz.gd
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
	print("BATCH IZ — THE PLACING, TWO RE-KEYS, AND A REMOVAL")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	_s1_the_rereads()
	_s2_the_placing()
	await _s3_the_removal()
	await _s4_the_rekey()
	_s5_the_populations()
	_s6_the_band_and_the_cut()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


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


func _block(doc: String, head: String) -> String:
	var a := doc.find("\n" + head)
	if a < 0:
		return ""
	var b := doc.find("\n### ", a + 1)
	var c := doc.find("\n## ", a + 1)
	if b < 0 or (c >= 0 and c < b):
		b = c
	return doc.substr(a, (b - a) if b > a else -1)


func _konst(name: String) -> Variant:
	return (_run.get_script() as Script).get_script_constant_map().get(name, null)


# The scale's cuts, as IZ §1 re-derived them — read off the kept table (§1 re-derives them and holds the table to them).
var _cuts: Array = []


func _band(cost_points: float, z: float) -> int:
	# THE TEST BINDS (IY §0.1): a cost inside two of its standard errors of none is no cost, whatever band its midpoint is in.
	if z < 2.0:
		return 0
	var b := 0
	for k in _cuts.size():
		if cost_points >= float(_cuts[k]):
			b = k + 1
	return b


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var notes := _doc("res://docs/design-notes.md")
	ok(claude.contains("TWO READINGS OF THE SAME POPULATION ARE TWO ESTIMATES OF ONE FACT, AND THE SHARPER INSTRUMENT's REPLACES THE OTHER"),
		"§0.1: CLAUDE.md does not say a sharper reading of one population replaces the blunter")
	ok(claude.contains("ONE THAT KEYS ON SOMETHING EVERY BUILD DOES AND STILL COSTS NOTHING HAS NO REACH, AND LEAVES THE DECK"),
		"§0.3: CLAUDE.md does not say a modifier keyed on what every build does that costs nothing leaves the deck")
	ok(claude.contains("A HANDLE WORTH 0.15 POINTS PER TEN POINTS OF ITS QUANTITY CANNOT CARRY A BARGAIN"),
		"§3: CLAUDE.md does not carry the removal's reason — a handle worth 0.15 points per ten points cannot carry a bargain")
	# THE RULES STAND BESIDE THE SCALE: inside the ladder block that states it.
	var scale_at := claude.find("no severity under ")
	var rule_at := claude.find("THE SHARPER INSTRUMENT's REPLACES THE OTHER")
	ok(scale_at >= 0 and rule_at > scale_at and rule_at - scale_at < 12000,
		"§0.1: CLAUDE.md's sharper-replaces rule does not stand beside the scale (%d bytes apart)" % (rule_at - scale_at))
	ok(notes.contains("Dull Edge") and notes.contains("0.15 points"),
		"§3: docs/design-notes.md keeps no record of Dull Edge's shape and the reading that removed it")
	ok(notes.contains("Tinderbox") and notes.contains("+0.24"),
		"§5: docs/design-notes.md keeps no record of Tinderbox's shape and the reading that removed it")
	print("    CHECKED three rulings in CLAUDE.md beside the scale, and the two removals' records in the design notes")


# ── §1 — THE RE-READS AND THE SCALE ───────────────────────────────────────────────────────────────────
const REREAD_TSV := "docs/reports/IZ-reread.tsv"
const SCALE_TSV := "docs/reports/IZ-scale.tsv"


func _s1_the_rereads() -> void:
	print("\n§1 — the old values and the cheap end on the sharper instrument, and the scale re-derived off them")
	# THE SCALE FIRST: IX §3's arithmetic re-run with the sharper readings (IZ §0.1). A member's IX cost is IX's baseline less IW's
	# reading; its cost is the sharper reading where one exists; a level's cost is the mean of its members'; a cut is the midpoint
	# of two adjacent levels. Every figure is re-derived here from IW's ladder, IX's baseline and the re-read table.
	var ladder := _tsv("res://docs/reports/IW-ladder.tsv", ["id", "reading", "level"])
	var base := -1.0
	for r in _tsv("res://docs/reports/IX-scale.tsv", ["id", "reading"]):
		if String(r["id"]) == "none":
			base = float(r["reading"])
	ok(base > 0.0, "§1: IX's scale table carries no baseline")
	var iw := {}
	for r in ladder:
		iw[String(r["id"])] = r
	var reread := _tsv("res://" + REREAD_TSV, ["arm", "id", "handle", "value", "runs", "reading", "se", "cost", "d_se", "z", "unpaired",
		"ratio", "prior_cost", "prior_se", "tie_z", "band"])
	var rr := {}
	for r in reread:
		rr[String(r["id"])] = r
	var members := _tsv("res://" + SCALE_TSV, ["level", "id", "ix_cost", "cost", "se", "source", "level_iz", "cut_iz"])
	var off: Array = []
	var lv_sum := {}
	var lv_n := {}
	for m in members:
		var id := String(m["id"])
		if not iw.has(id):
			off.append("%s is in the scale table and not on IW's ladder" % id)
			continue
		var ixc := (base - float(iw[id]["reading"])) * 100.0
		if absf(ixc - float(m["ix_cost"])) > 0.001 or int(iw[id]["level"]) != int(m["level"]):
			off.append("%s: IX's cost is written %s at level %s; IW's ladder and IX's baseline give %.4f at %s" % [id, m["ix_cost"], m["level"], ixc, iw[id]["level"]])
		if String(m["source"]) == "IZ §1" and (not rr.has(id) or absf(float(rr[id]["cost"]) - float(m["cost"])) > 0.0001):
			off.append("%s: the scale takes %s off IZ §1, and the re-read table does not say so" % [id, m["cost"]])
		var lv := int(m["level"])
		lv_sum[lv] = float(lv_sum.get(lv, 0.0)) + float(m["cost"])
		lv_n[lv] = int(lv_n.get(lv, 0)) + 1
	ok(members.size() == ladder.size(), "§1: the scale table holds %d members — IW's ladder %d" % [members.size(), ladder.size()])
	var levels := lv_sum.keys()
	levels.sort()
	_cuts = []
	for k in levels.size() - 1:
		_cuts.append((float(lv_sum[levels[k]]) / int(lv_n[levels[k]]) + float(lv_sum[levels[k + 1]]) / int(lv_n[levels[k + 1]])) / 2.0)
	_cuts = _cuts.slice(0, 5)
	# A FAILING PATH IS BOUNDED: a table that yields fewer than five cuts reds here and the section stops, never a throw.
	ok(_cuts.size() == 5, "§1: the scale table yields %d cuts — the derivation gives five" % _cuts.size())
	if _cuts.size() != 5:
		return
	for m2 in members:
		var lv2 := int(m2["level"])
		if absf(float(lv_sum[lv2]) / int(lv_n[lv2]) - float(m2["level_iz"])) > 0.001:
			off.append("level %d's cost is written %s, its members give %.4f" % [lv2, m2["level_iz"], float(lv_sum[lv2]) / int(lv_n[lv2])])
		if lv2 <= 5 and absf(float(_cuts[lv2 - 1]) - float(m2["cut_iz"])) > 0.001:
			off.append("the cut above level %d is written %s, the levels give %.4f" % [lv2, m2["cut_iz"], float(_cuts[lv2 - 1])])
	ok(off.is_empty(), "§1: %d of the scale table's figures are not IX's arithmetic on the sharper readings: %s" % [off.size(), str(off)])
	# THE CUTS THE RULE STATES ARE THE DERIVATION's (the scale is whatever the derivation gives, IZ §1).
	var said := "no severity under %.2f; 1 to %.2f; 2 to %.2f; 3 to %.2f; 4 to %.2f; 5 from %.2f" % [
		float(_cuts[0]), float(_cuts[1]), float(_cuts[2]), float(_cuts[3]), float(_cuts[4]), float(_cuts[4])]
	ok(_flat(_doc("res://CLAUDE.md")).contains(said), "§1: CLAUDE.md's scale does not state the cuts the derivation gives ('%s')" % said)
	var grades_block := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	ok(grades_block.contains(said), "§1: the state file's grades block does not state the cuts the derivation gives")
	# THE TWENTY-SEVENTH NOTE's PRICE (IZ §1): of the modifiers IX's test called free (`costs nothing` in IX's kept table), how many
	# a sharper reading at IX's own value — a scale member whose cost is no longer IW's — reads past the test. Stated where the
	# eleven were recorded: the state file's grades block (IX's, archived at IY; IZ's now).
	var ix_free: Array = []
	for r in _tsv("res://docs/reports/IX-scale.tsv", ["id", "verdict"]):
		if String(r["verdict"]) == "costs nothing":
			ix_free.append(String(r["id"]))
	var reread_n := 0
	var reach_n := 0
	for m in members:
		if ix_free.has(String(m["id"])) and not String(m["source"]).begins_with("IW"):
			reread_n += 1
			if float(m["cost"]) / maxf(float(m["se"]), 1e-9) >= 2.0:
				reach_n += 1
	var price := "%d OF THE %d MODIFIERS IX CALLED FREE WERE UNDER THE OLD INSTRUMENT's REACH" % [reach_n, ix_free.size()]
	ok(ix_free.size() > 0 and reread_n > 0, "§1: IX's table names %d free modifiers and the scale re-reads %d of them — the price reads nothing" % [ix_free.size(), reread_n])
	ok(grades_block.contains(price), "§1: the state file's grades block does not state the twenty-seventh note's price ('%s')" % price)
	print("    the price: %d of IX's %d free re-read at IX's own values, %d of them under the old instrument's reach" % [reread_n, ix_free.size(), reach_n])
	# THE RE-READ TABLE's OWN ARITHMETIC, AND EACH ARM's BAND ON THOSE CUTS.
	var bad: Array = []
	for r in reread:
		if String(r["id"]) == "none":
			continue
		var z := float(r["cost"]) / maxf(float(r["d_se"]), 1e-9)
		var ratio := float(r["d_se"]) / maxf(float(r["unpaired"]), 1e-9)
		var tie := (float(r["cost"]) - float(r["prior_cost"])) / sqrt(pow(float(r["d_se"]), 2) + pow(float(r["prior_se"]), 2))
		if absf(z - float(r["z"])) > 0.01 or absf(ratio - float(r["ratio"])) > 0.002 or absf(tie - float(r["tie_z"])) > 0.01:
			bad.append("%s: z/ratio/tie written %s/%s/%s, its figures give %.2f/%.3f/%.2f" % [r["id"], r["z"], r["ratio"], r["tie_z"], z, ratio, tie])
		if _band(float(r["cost"]), z) != int(r["band"]):
			bad.append("%s: its band is written %s, its cost and the test give %d" % [r["id"], r["band"], _band(float(r["cost"]), z)])
		if int(r["runs"]) != 60:
			bad.append("%s ran %s runs, not sixty" % [r["id"], r["runs"]])
	ok(bad.is_empty(), "§1: %d of the re-read table's figures are not their own arithmetic: %s" % [bad.size(), str(bad)])
	print("    CHECKED %d scale members over %d levels — the cuts %s — and %d re-read arms" % [members.size(), levels.size(), str(_cuts.map(func(c): return snappedf(float(c), 0.01))), reread.size() - 1])


# ── §2 — THE PLACING ──────────────────────────────────────────────────────────────────────────────────
const GRADES_TSV := "docs/reports/IZ-grades.tsv"


func _s2_the_placing() -> void:
	print("\n§2 — the placing: every handle where its reading measured it, every grade its readings' highest test-bound band")
	var rows := _tsv("res://" + GRADES_TSV, ["modifier", "id", "handle", "value", "ref_cost", "ref_se", "ref_z", "ref_source",
		"ref_seeding", "alt_population", "alt_cost", "alt_se", "alt_z", "alt_source", "alt_applies", "ref_band", "alt_band", "grade",
		"population", "batch"])
	var mods: Dictionary = _run.MODIFIERS
	var ids := rows.map(func(r): return String(r["id"]))
	var deck := mods.keys().map(func(k): return String(k))
	ids.sort()
	deck.sort()
	ok(ids == deck, "§2: the grades table grades %s — the deck holds %s" % [str(ids), str(deck)])
	# WHERE A FIGHT-SEEDED READING OF THE REFERENCE PARTY EXISTS, THE GRADE TAKES IT (IZ §0.1, C02): IZ's re-reads, IY's handles and
	# IY's seeding table are the fight-seeded readings on record.
	var sharp := {}
	for t in [["res://docs/reports/IZ-reread.tsv", "id"], ["res://docs/reports/IY-handles.tsv", "id"], ["res://docs/reports/IY-seeding.tsv", "id"]]:
		for r in _tsv(String(t[0]), [String(t[1])]):
			sharp[String(r[String(t[1])])] = true
	var off: Array = []
	var unsourced: Array = []
	var counts := {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	var graded_sharp := 0
	for r in rows:
		var id := String(r["id"])
		# THE TABLE MEASURES THE DECK: a handle's live constant is the value its reading was taken at (R01 — a re-tune reds; C01).
		if String(r["handle"]) != "-":
			var live: Variant = _konst(String(r["handle"]))
			if live == null or not is_equal_approx(float(live), float(r["value"])):
				off.append("%s: its reading was taken at %s %s and the deck holds %s" % [id, r["handle"], r["value"], str(live)])
		var rb := _band(float(r["ref_cost"]), float(r["ref_z"]))
		var ab := _band(float(r["alt_cost"]), float(r["alt_z"])) if String(r["alt_applies"]) == "yes" else 0
		if rb != int(r["ref_band"]) or ab != int(r["alt_band"]):
			off.append("%s: bands written %s / %s, its readings give %d / %d" % [id, r["ref_band"], r["alt_band"], rb, ab])
		var g := maxi(rb, ab)
		if g != int(r["grade"]):
			off.append("%s: graded %s, the higher of its bands is %d" % [id, r["grade"], g])
		if sharp.has(id) and String(r["ref_seeding"]) != "fight":
			off.append("%s: graded off a %s-seeded reading where a fight-seeded one exists" % [id, r["ref_seeding"]])
		if sharp.has(id) and g > 0:
			graded_sharp += 1
		var pop := String(r["alt_population"]) if (String(r["alt_applies"]) == "yes" and (ab > rb or (ab == rb and ab > 0 and float(r["alt_cost"]) > float(r["ref_cost"])))) else "the default four"
		if pop != String(r["population"]):
			off.append("%s: its highest passing cost is %s's, and the table names %s" % [id, pop, r["population"]])
		var sev := int(_run.modifier_severity(id)) if mods.has(id) else -1
		if sev != g:
			off.append("%s carries severity %d in the game, its readings give %d" % [id, sev, g])
		counts[g] = int(counts.get(g, 0)) + 1
		var gr := String((mods.get(id, {}) as Dictionary).get("graded", ""))
		if gr != "%s — %s" % [String(r["population"]), String(r["batch"])]:
			unsourced.append("%s ('%s', the table: '%s — %s')" % [id, gr, r["population"], r["batch"]])
	ok(off.is_empty(), "§2: %d grades are not where their readings put them: %s" % [off.size(), str(off)])
	ok(unsourced.is_empty(), "§2: %d rows of Run.MODIFIERS do not name the population and batch their grade came from: %s" % [unsourced.size(), str(unsourced)])
	# THE ABSENCE's POSITIVE ARM: modifiers graded off a sharper reading carry a grade.
	ok(graded_sharp >= 3, "§2: %d modifiers graded off a fight-seeded reading carry a grade — the positive arm is thin" % graded_sharp)
	# THE RULED REVERT (IZ §0.2): Bloodletting at its old 15, where the sharper instrument reads it a grade 1.
	ok(int(_konst("BLOODLETTING_BLEED") if _konst("BLOODLETTING_BLEED") != null else -1) == 15, "§2: Bloodletting's handle is %s — IZ §0.2 reverts it to 15" % str(_konst("BLOODLETTING_BLEED")))
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	var tally := "none %d; 1 %d; 2 %d; 3 %d; 4 %d; 5 %d" % [counts[0], counts[1], counts[2], counts[3], counts[4], counts[5]]
	ok(grades.contains(tally), "§2: the state file's grades block does not carry the tally the table gives (%s)" % tally)
	print("    CHECKED %d grades against their readings; the deck holds %s" % [rows.size(), tally])


# ── §3 — DULL EDGE AND TINDERBOX ARE REMOVED, NOT DISABLED ────────────────────────────────────────────
const REMOVED := ["dulledge", "tinderbox"]
const REMOVED_WORDS := ["dulledge", "Dull Edge", "DULL_EDGE_CRIT", "tinderbox", "Tinderbox", "TINDERBOX_FIRE_PCT"]


func _ids(offer: Variant) -> Array:
	var out: Array = []
	if offer is Array:
		for o in offer:
			out.append(String((o as Dictionary).get("modifier", "")))
	return out


func _s3_the_removal() -> void:
	print("\n§3 — Dull Edge and Tinderbox are removed, not disabled: no file of the game names either, and a save that does loads without them")
	# THE ABSENCE, COMMENT-STRIPPED (a comment recording a removal names it, which reads like the removal not having happened —
	# EV §5), over the game's code and data, AND ITS POSITIVE ARM: the modifiers beside them are named in the same files.
	var files: Array = []
	for d in ["res://scripts/", "res://data/"]:
		for f in DirAccess.get_files_at(d):
			if f.ends_with(".gd") or f.ends_with(".json"):
				files.append(d + f)
	var named: Array = []
	var beside := 0
	for p in files:
		var src := FileAccess.get_file_as_string(String(p))
		if String(p).ends_with(".gd"):
			src = Gate.strip_comments(src)
		for w in REMOVED_WORDS:
			if src.contains(String(w)):
				named.append("%s names %s" % [p, w])
		if src.contains("\"parched\"") and src.contains("\"brittle\""):
			beside += 1
	ok(named.is_empty(), "§3: %d files of the game still name a removed modifier: %s" % [named.size(), str(named)])
	ok(beside >= 2, "§3: the modifiers beside them are named in %d files of the game — the absence's positive arm reads nothing" % beside)
	var held: Array = REMOVED.filter(func(id): return (_run.MODIFIERS as Dictionary).has(id))
	ok(held.is_empty() and (_run.MODIFIERS as Dictionary).has("parched"),
		"§3: the deck holds %s, or no longer holds Parched (the positive arm)" % str(held))
	var master := _flat(_doc("res://docs/master.html"))
	ok(not master.contains("<tr><td>Dull Edge</td>") and not master.contains("<tr><td>Tinderbox</td>") and master.contains("<tr><td>Parched</td>"),
		"§3: master.html's bargain table still has Dull Edge's or Tinderbox's row, or has lost Parched's")
	# DRIVEN AT THE LOAD DOOR (IQ §4's guard, which is this case): a save whose stored offer names them loads with those options
	# dropped, the other in its place and no die spent; a clean offer loads exactly as it was saved.
	var path := String(_run.save_path)
	ok(path != String(_run.SAVE_PATH), "§3: the gate is on the player's save path (%s)" % path)
	if path == String(_run.SAVE_PATH):
		return
	var had_file := FileAccess.file_exists(path)
	var had := FileAccess.get_file_as_bytes(path) if had_file else PackedByteArray()
	for arm in ["named", "clean"]:
		_run.sim_run = false
		_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
		_run.encounter = {"type": "elite", "enemies": ["orc_raider"], "theme": "Warband"}
		var offer: Array = _run.encounter_offer()
		ok(offer.size() == 3, "§3 %s: the roll dealt %d options, not three" % [arm, offer.size()])
		if offer.size() != 3:
			continue
		var want: Array = _ids(offer)
		if arm == "named":
			offer[1]["modifier"] = REMOVED[0]
			offer[2]["modifier"] = REMOVED[1]
			want = [want[0]]
		_run.encounter["offer"] = offer
		var written: Array = (offer as Array).duplicate(true)
		_run.save_run()
		seed(2026102701)
		var before := randi()
		seed(2026102701)
		var loaded: bool = _run.load_run()
		var after := randi()
		ok(loaded and before == after, "§3 %s: the save did not load, or its load spent a die" % arm)
		var stored: Variant = _run.encounter.get("offer")
		if arm == "named":
			ok(_ids(stored) == want, "§3: a save whose offer names %s loaded %s, not the one the deck holds %s — the removal is owed the load door's guard" % [
				str(REMOVED), str(_ids(stored)), str(want)])
		else:
			ok(stored is Array and (stored as Array) == written, "§3: a clean offer did not load as it was saved — %s" % str(_ids(stored)))
		print("    %s: saved %s -> loaded %s" % [arm, str(_ids(written)), str(_ids(stored))])
	# A BARGAIN TAKEN UNDER IT IS FOUGHT UNDER NONE: `battle._active_modifier` asks the deck.
	_run.active = true
	_run.pending_modifier = REMOVED[0]
	var bs := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_active_modifier", {}))
	ok(bs.contains("Run.MODIFIERS.has(mod_id)"), "§3: `_active_modifier` no longer asks the deck — a save's %s would be fought under it" % str(REMOVED))
	_run.pending_modifier = ""
	_run.encounter = {}
	_run.active = false
	if had_file:
		var fr := FileAccess.open(path, FileAccess.WRITE)
		fr.store_buffer(had)
		fr.close()
	elif FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("    CHECKED %d files of the game for the removed words, the load door both ways, and the bargain in force" % files.size())


# ── §4 — FRENZIED ADDS ───────────────────────────────────────────────────────────────────────────────
const REKEY_TSV := "docs/reports/IZ-rekey.tsv"


# The first `steps` turns of a board read off each unit's `effective_speed()` — the opening seed without its die (100 over the
# speed) and a basic attack's delay after every turn (`Ability.BASIC_DELAY` over the speed), the division every reschedule in
# `battle.gd` makes — as the sequence of the units' seats. A factor on every speed divides every time by one number and leaves this
# sequence as it was; an amount added to every speed does not.
func _order(units: Array, steps: int) -> Array:
	var t := {}
	for i in units.size():
		t[i] = 100.0 / maxf(float(units[i].effective_speed()), 0.1)
	var seq: Array = []
	for k in steps:
		var best := -1
		for i in units.size():
			if best < 0 or float(t[i]) < float(t[best]) - 1e-9:
				best = i
		seq.append(best)
		t[best] = float(t[best]) + Ability.BASIC_DELAY * 100.0 / maxf(float(units[best].effective_speed()), 0.1)
	return seq


func _s4_the_rekey() -> void:
	print("\n§4 — Frenzied adds: the stamp writes a flat amount, the speed reads it added and floored, and a board's turn order moves")
	var cache := {}
	var stamp := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_stamp_modifier", cache))
	var speed_fn := Gate.strip_comments(Gate.fn_body("scripts/unit.gd", "effective_speed", cache))
	var add: Variant = _konst("FRENZIED_SPEED_ADD")
	ok(add != null and _konst("FRENZIED_SPEED") == null,
		"§4: Run carries no FRENZIED_SPEED_ADD (%s), or still carries the multiplier FRENZIED_SPEED" % str(add))
	ok(Gate.count_whole(stamp, "u.mod_speed_add = Run.FRENZIED_SPEED_ADD") == 1,
		"§4: Frenzied's stamp does not write the flat amount once (`u.mod_speed_add = Run.FRENZIED_SPEED_ADD`)")
	ok(speed_fn.contains("maxf(speed + mod_speed_add, speed * MOD_SPEED_FLOOR)") and not speed_fn.contains("mod_speed_mult"),
		"§4: effective_speed does not add the flat amount, floored at a share of the unit's own speed")
	# THE RE-KEY's KEPT ARMS (IZ §4): each arm's verdict is its own arithmetic; the subtraction is driven because an add pays the
	# party; the amount shipped is one an arm read costing the party — and with none that does, Frenzied is not in the deck.
	var rk := _tsv("res://" + REKEY_TSV, ["arm", "value", "runs", "cost", "d_se", "z", "verdict"])
	var bad: Array = []
	var add_pays := false
	var costs: Array = []
	for r in rk:
		if String(r["arm"]) == "none":
			continue
		var z := float(r["cost"]) / maxf(float(r["d_se"]), 1e-9)
		var verdict := "costs" if z >= 2.0 else ("pays" if z <= -2.0 else "tie")
		if absf(z - float(r["z"])) > 0.01 or String(r["verdict"]) != verdict or int(r["runs"]) != 60:
			bad.append("%s: z %s '%s' over %s runs; its figures give %.2f '%s' over sixty" % [r["arm"], r["z"], r["verdict"], r["runs"], z, verdict])
		if float(r["value"]) > 0.0 and verdict == "pays":
			add_pays = true
		if verdict == "costs":
			costs.append(float(r["value"]))
	ok(bad.is_empty() and rk.size() >= 3, "§4: %d of the re-key's %d arms are not their own arithmetic: %s" % [bad.size(), rk.size(), str(bad)])
	var shipped_neg := add != null and float(add) < 0.0
	ok(not shipped_neg or add_pays, "§4: Frenzied ships a subtraction and no add was read paying the party — the subtraction is driven only when the add pays")
	if costs.is_empty():
		ok(not (_run.MODIFIERS as Dictionary).has("frenzied"), "§4: no direction of the re-key costs the party, and Frenzied is still in the deck")
	else:
		ok(add != null and costs.has(float(add)), "§4: Frenzied ships %s; the arms that cost the party were driven at %s" % [str(add), str(costs)])
	print("    the re-key's arms: %d, an add paying %s, costing at %s; shipped %s" % [rk.size() - 1, str(add_pays), str(costs), str(add)])
	if add == null or not (_run.MODIFIERS as Dictionary).has("frenzied"):
		return
	# NO WORD OF FRENZIED's MOVES (IZ §4): its sentence is the one it was, stating its constant's figure — at the average speed
	# (100, `unit.gd`'s own convention) the amount is the share the words read.
	var desc := String((_run.MODIFIERS["frenzied"] as Dictionary).get("desc", ""))
	ok(desc == "Everyone acts %d%% faster. Cooldowns are unchanged." % int(round(float(add))),
		"§4: Frenzied's words are not its sentence stating its constant's figure ('%s')" % desc)
	# DRIVEN, ON A REAL BOARD THROUGH THE REAL STAMP.
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var units: Array = scene.get("heroes") + scene.get("enemies")
	var plain_speeds := {}
	for i in units.size():
		plain_speeds[i] = float(units[i].effective_speed())
	var distinct := {}
	for v in plain_speeds.values():
		distinct[snappedf(float(v), 0.01)] = true
	ok(units.size() >= 5 and distinct.size() >= 2,
		"§4: the board holds %d units at %d distinct speeds — the drive needs two speeds to move an order" % [units.size(), distinct.size()])
	var plain := _order(units, 48)
	for u in units:
		scene.call("_stamp_modifier", u, "frenzied")
	var stamped := _order(units, 48)
	var off: Array = []
	for i in units.size():
		var want := maxf(float(units[i].speed) + float(add), float(units[i].speed) * 0.1) * float(plain_speeds[i]) / float(units[i].speed)
		if absf(float(units[i].effective_speed()) - want) > 0.001:
			off.append("%s %.2f -> %.2f (want %.2f)" % [units[i].unit_name, float(plain_speeds[i]), float(units[i].effective_speed()), want])
	ok(off.is_empty(), "§4: under the stamp a unit's speed is not its own plus %s: %s" % [str(add), str(off)])
	ok(plain != stamped, "§4: DRIVEN — under Frenzied the board's first 48 turns fell in the same order as with no modifier — a speed change every unit shares moves no turn (the multiplication's shape)")
	var moved := 0
	for k in plain.size():
		if int(plain[k]) != int(stamped[k]):
			moved += 1
	scene.queue_free()
	await process_frame
	print("    CHECKED the stamp, the speed's door and the words; DRIVEN on %d units at %d speeds: %d of 48 turns change hands" % [
		units.size(), distinct.size(), moved])


# ── §5 — MUFFLED AND TINDERBOX ON THE POPULATIONS THEIR RULES NAME ─────────────────────────────────────
const POP_TSV := "docs/reports/IZ-populations.tsv"
const FIRE_TSV := "docs/reports/IZ-fire.tsv"


func _s5_the_populations() -> void:
	print("\n§5 — Muffled and Tinderbox on the populations their rules name: each reading, its verdict, and the deck it leaves")
	# THE FIRE PARTY IS DERIVED, NOT CHOSEN: the party whose strikes carry the most fire, by the derivation's own reading.
	var fire := _tsv("res://" + FIRE_TSV, ["party", "specs", "hero_fire", "hero_all", "hero_share", "enemy_fire", "enemy_all", "enemy_share"])
	var best := {}
	var bad: Array = []
	for f in fire:
		var share := float(f["hero_fire"]) / maxf(float(f["hero_all"]), 1.0)
		if absf(share - float(f["hero_share"])) > 0.001:
			bad.append("%s's fire share is written %s, its figures give %.3f" % [f["party"], f["hero_share"], share])
		if best.is_empty() or share > float(best["hero_share"]):
			best = f
	var rows := _tsv("res://" + POP_TSV, ["modifier", "id", "population", "specs", "tiers", "rung", "runs", "cost", "d_se", "z", "band",
		"verdict", "in_deck"])
	var by := {}
	for r in rows:
		by[String(r["id"])] = r
	ok(by.has("muffled") and by.has("tinderbox"), "§5: the populations table holds no Muffled or no Tinderbox row (%s)" % str(by.keys()))
	if by.has("tinderbox") and not best.is_empty():
		ok(String(by["tinderbox"]["specs"]) == String(best["specs"]),
			"§5: Tinderbox was read on %s; the party whose strikes carry the most fire is %s" % [by["tinderbox"]["specs"], best["specs"]])
	if by.has("muffled"):
		ok(String(by["muffled"]["tiers"]) == "3" and String(by["muffled"]["rung"]) == "ruin",
			"§5: Muffled was not read on the talented incumbent at Ruin (tiers %s, %s)" % [by["muffled"]["tiers"], by["muffled"]["rung"]])
	for r in rows:
		var id := String(r["id"])
		var z := float(r["cost"]) / maxf(float(r["d_se"]), 1e-9)
		if absf(z - float(r["z"])) > 0.01:
			bad.append("%s's z is written %s, its cost gives %.2f" % [id, r["z"], z])
		if _band(float(r["cost"]), z) != int(r["band"]):
			bad.append("%s's band is written %s, its cost and the test give %d" % [id, r["band"], _band(float(r["cost"]), z)])
		# THE STOP CONDITION (IZ §5): no cost past the test even on the population its rule names is no reach, and it leaves.
		var want := "reach" if z >= 2.0 else "no reach"
		if String(r["verdict"]) != want:
			bad.append("%s's verdict is written '%s', its z %.2f gives '%s'" % [id, r["verdict"], z, want])
		var stays := want == "reach"
		if String(r["in_deck"]) != ("yes" if stays else "no") or (_run.MODIFIERS as Dictionary).has(id) != stays:
			bad.append("%s: its verdict is '%s', and the deck %s it" % [id, want, "holds" if (_run.MODIFIERS as Dictionary).has(id) else "does not hold"])
		if stays and int(_run.modifier_severity(id)) < int(r["band"]):
			bad.append("%s carries severity %d, under the band %s its own population gives" % [id, _run.modifier_severity(id), r["band"]])
	ok(bad.is_empty(), "§5: %d of the populations' figures, verdicts or the deck's holdings are not the readings': %s" % [bad.size(), str(bad)])
	print("    CHECKED %d derivation parties (the fire party %s) and %d population readings" % [fire.size(), best.get("party", "?"), rows.size()])


# ── §6 — WARDEN's BAND (IZ §0.4) AND THE CHANGELOG's CUT (IZ §6) ───────────────────────────────────────
const BAND_TSV := "docs/reports/IZ-band.tsv"
const BAND_NOW := [[1, 3], [4, 4]]
const BAND_MOVED := [[1, 2], [3, 4]]


func _holds(band: Array) -> int:
	var n := 0
	for id in _run.MODIFIERS:
		var s := int(_run.modifier_severity(String(id)))
		if s >= int(band[0]) and s <= int(band[1]):
			n += 1
	return n


func _s6_the_band_and_the_cut() -> void:
	print("\n§6 — Warden's band is where its two arms put it, and the changelog is under its bar by the cut its header records")
	# THE BAND MOVES ON THE MEASUREMENT OR NOT AT ALL (IZ §0.4): a tie moves it — the repetition fixed for nothing — and a band
	# that makes Warden materially milder (its arm's bargain fights end healthier, past two standard errors) stays.
	var rows := _tsv("res://" + BAND_TSV, ["arm", "safe", "gamble", "holds_safe", "holds_gamble", "reading", "se", "d", "d_se", "z", "verdict"])
	var by := {}
	for r in rows:
		by[String(r["arm"])] = r
	ok(by.has("now") and by.has("moved"), "§6: the band table holds no `now` or no `moved` arm (%s)" % str(by.keys()))
	if by.has("now") and by.has("moved"):
		var m: Dictionary = by["moved"]
		var z := float(m["d"]) / maxf(float(m["d_se"]), 1e-9)
		var want := "milder" if z >= 2.0 else ("harsher" if z <= -2.0 else "tie")
		ok(absf(z - float(m["z"])) < 0.01 and String(m["verdict"]) == want,
			"§6: the moved arm's z is written %s and its verdict '%s'; its figures give %.2f and '%s'" % [m["z"], m["verdict"], z, want])
		var bands: Array = BAND_NOW if want == "milder" else BAND_MOVED
		var def: Dictionary = _run.DIFFICULTIES["warden"]
		ok(str(def["safe_band"]) == str(bands[0]) and str(def["gamble_band"]) == str(bands[1]),
			"§6: Warden's bands read %s / %s — its two arms' verdict ('%s') puts them at %s / %s" % [
				str(def["safe_band"]), str(def["gamble_band"]), want, str(bands[0]), str(bands[1])])
		for arm in ["now", "moved"]:
			var b: Array = BAND_NOW if arm == "now" else BAND_MOVED
			var r2: Dictionary = by[arm]
			ok(int(r2["holds_safe"]) == _holds(b[0]) and int(r2["holds_gamble"]) == _holds(b[1]),
				"§6: the %s arm was driven on a deck whose bands held %s / %s; the deck holds %d / %d" % [
					arm, r2["holds_safe"], r2["holds_gamble"], _holds(b[0]), _holds(b[1])])
		print("    the moved arm: %+.2f ± %.2f points (z %.2f) — %s; Warden %s / %s" % [
			float(m["d"]), float(m["d_se"]), z, want, str(def["safe_band"]), str(def["gamble_band"])])
	# THE CHANGELOG IS UNDER ITS BAR — read out of the rule (CW §4), never a copy of it — AND ITS POSITIVE ARM: the cut that put
	# it there is the one the header records, at the boundary the two files hold.
	var ir := _doc("res://docs/instrument-rules.md")
	var rx := RegEx.create_from_string("THE THRESHOLD IS ([0-9]+) KB")
	var hit := rx.search(ir)
	ok(hit != null, "§6: the rule no longer states the changelog's threshold in the form this gate reads")
	var live := _doc("res://docs/changelog.html")
	var size := FileAccess.get_file_as_bytes("res://docs/changelog.html").size()
	if hit != null:
		var bar := int(hit.get_string(1)) * 1000
		ok(size < bar, "§6: docs/changelog.html is %d B against its %d B bar — the cut is owed" % [size, bar])
	ok(live.contains("Batch IZ</b> at HR/HS"), "§6: the live header does not record the cut IZ made (`Batch IZ</b> at HR/HS`)")
	var heads := RegEx.create_from_string("<h2>[^<]*?Batch ([A-Z]{2})").search_all(live)
	# THE ARCHIVE IS REACHED THROUGH THE LIVE FILE's OWN HEADER, NEVER HARDCODED (CW §4, CD's pattern).
	var mark := live.find("/changelog-archive.html</code>")
	var open_at := live.rfind("<code>", mark) + 6 if mark > 0 else -1
	var arch_path := live.substr(open_at, mark + "/changelog-archive.html".length() - open_at) if mark > 0 else ""
	ok(arch_path.begins_with("res://"), "§6: the live changelog no longer leads to its archive ('%s')" % arch_path)
	var archive := FileAccess.get_file_as_string(arch_path) if arch_path != "" else ""
	var aheads := RegEx.create_from_string("<h2>[^<]*?Batch ([A-Z]{2})").search_all(archive)
	ok(heads.size() > 0 and heads[heads.size() - 1].get_string(1) == "HS" and aheads.size() > 0 and aheads[0].get_string(1) == "HR",
		"§6: the live file's oldest entry is not Batch HS, or the archive's newest is not Batch HR — the boundary is not the cut's")
	print("    CHECKED the band's verdict and its deck; the changelog %d B, its oldest entry %s, the archive's newest %s" % [
		size, heads[heads.size() - 1].get_string(1) if heads.size() > 0 else "?", aheads[0].get_string(1) if aheads.size() > 0 else "?"])
