# BATCH JA — THE SHARES, BEFORE THE FOUR.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: a new modifier names the two sides' shares of its quantity before it is
#        built, read off the census of record (`CLAUDE.md`'s ladder block, beside AQ's and IP's rules); the renamed card's why and
#        Fleeting's words' why (the design notes).
#   §1   LEADEN: the card's name and its two clauses, its figure read off the constant at the average speed, the constant named
#        for its card (IT §2a, C02), the id kept — the project has no rename path for a modifier id — and its chip its own letters;
#        DRIVEN, the board's first 48 turns change hands as IZ's drive read them (C04), and a subtraction past every speed slows a
#        unit to its floor and never stalls it (C03); the old name swept from every live text file (C01), its positive arm the
#        files that name the new one.
#   §2   FLEETING AT 3, MEASURED IN THE DECK: the kept reading's arithmetic, its tie with IZ's lever point, the band the scale gives
#        it; the deck holds the value the reading was taken at (C05) at the grade the reading gives, naming its population and
#        batch; its words are the template's at the value (C06) — and the census says why the brief's *every effect lasts one turn*
#        is not the rule (a status of five turns or more keeps all but three).
#   §3   THE SHARE CENSUS: the kept table's arithmetic (each ratio and class its own figures'); the population DERIVED — every live
#        modifier's quantity has a row (C07), and no row names a modifier the deck does not hold; both parties read; the
#        durations table its own arithmetic.
#   §4   THE AXIS TABLE: every modifier of the deck on one axis, each row's grades the deck's (C08), its top and its 4 its own
#        arithmetic, and its crossing the census's reading of its quantity; grade 4 holds the axes the deck gives it.
#   §5   `test_batch_cb`'s COIN FLIP: the Pyre Wake deep-stack arm reads the bank (Overburn's refund) and never where the scatter's
#        fires fell (C09).
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** It holds the kept tables' arithmetic, the code's doors and the documents' agreement with
# them — never that a reading is what the sim produces: that is the drive (`docs/reports/JA.md` §2, §3), which no gate re-runs. The
# old name's needle is built at run time, so this file names it nowhere.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ja.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# `check_iz` §4's turn-order model, read here rather than copied (DA §3: a helper copied between gates diverges silently).
const IZ = preload("res://check_iz.gd")

var _g := Gate.new()
var _docs := {}
var _run: Node = null


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JA — THE SHARES, BEFORE THE FOUR")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	await _s1_leaden()
	_s2_fleeting()
	_s3_the_census()
	_s4_the_axes()
	_s5_the_coin_flip()
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


# The scale's cuts, read off IZ's kept table — the scale JA's reading is graded on (re-derived and held by `check_iz` §1).
func _cuts() -> Array:
	var out: Array = []
	var seen := {}
	for r in _tsv("res://docs/reports/IZ-scale.tsv", ["level", "cut_iz"]):
		var lv := int(r["level"])
		if lv <= 5 and not seen.has(lv):
			seen[lv] = true
			out.append(float(r["cut_iz"]))
	return out


func _band(cost_points: float, z: float, cuts: Array) -> int:
	# THE TEST BINDS (IY §0.1): a cost inside two of its standard errors of none is no cost, whatever band its midpoint is in.
	if z < 2.0:
		return 0
	var b := 0
	for k in cuts.size():
		if cost_points >= float(cuts[k]):
			b = k + 1
	return b

# RE-POINTED AT JB §2: THIS GATE'S KEPT TABLES WERE TAKEN ON THE DECK BEFORE JB's FOUR, AND EACH OF THE FOUR NAMES THE BATCH THAT
# GRADED IT, SO THE DECK THEY MEASURED IS READ OFF THE ROWS AND NEVER OFF A LIST (`check_jb` §3 holds the four).
func _deck_before_jb() -> Dictionary:
	var out := {}
	var mods: Dictionary = _run.MODIFIERS
	for id in mods:
		if not String((mods[id] as Dictionary).get("graded", "")).contains("JB §"):
			out[id] = mods[id]
	return out


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var notes := _doc("res://docs/design-notes.md")
	ok(claude.contains("A NEW MODIFIER NAMES THE TWO SIDES' SHARES OF ITS QUANTITY BEFORE IT IS BUILT"),
		"§0.3: CLAUDE.md does not say a new modifier names the two sides' shares of its quantity before it is built")
	# WHERE THE MODIFIER RULES ARE: beside the rule that replaced IP's at JB §0.2, inside the ladder block that states the scale.
	var ip_at := claude.find("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE")
	var ja_at := claude.find("A NEW MODIFIER NAMES THE TWO SIDES' SHARES OF ITS QUANTITY BEFORE IT IS BUILT")
	ok(ip_at >= 0 and ja_at > ip_at and ja_at - ip_at < 6000,
		"§0.3: the share practice does not stand beside the rule on what costs the party (%d bytes apart)" % (ja_at - ip_at))
	ok(claude.contains("docs/reports/JA-shares.tsv"), "§0.3: CLAUDE.md does not name the census of record the shares are read off")
	ok(notes.contains("Why Leaden") and notes.contains("Why Fleeting's words are the code's"),
		"§0: docs/design-notes.md keeps no record of why the card is Leaden, or why Fleeting's words are the code's")
	print("    CHECKED the share practice in CLAUDE.md beside the rule on what costs the party, and the two records in the design notes")


# ── §1 — LEADEN ───────────────────────────────────────────────────────────────────────────────────────
# The old name, built at run time so this file holds no copy of it (a comment or needle naming a swept word is a hit — DR §2).
var OLD := "Fren" + "zied"


func _s1_leaden() -> void:
	print("\n§1 — Leaden: the card, its constant, its id, its drive, and the old name swept")
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.has("frenzied"), "§1: the deck holds no `frenzied` — the id the card keeps")
	if not mods.has("frenzied"):
		return
	var card: Dictionary = mods["frenzied"]
	var name := String(card.get("name", ""))
	ok(name == "Leaden", "§1: the card is named '%s', not Leaden" % name)
	# THE ID STAYS: the project has no rename path for a modifier id — the load door's one rename map is the cards' — so a
	# save naming `frenzied` still names this card, and no map of renamed modifiers exists to send it anywhere else.
	ok(_konst("RENAMED_CARDS") != null and _konst("RENAMED_MODIFIERS") == null,
		"§1: Run carries a modifier rename path (RENAMED_MODIFIERS) or has lost the cards' map — the id's ruling is the other branch")
	# THE CONSTANT IS NAMED FOR ITS CARD (IT §2a, C02): the card's name, its figure's kind.
	var kname := name.to_upper() + "_SPEED_ADD"
	var add: Variant = _konst(kname)
	ok(add != null, "§1: Run carries no %s — the constant is not named for its card" % kname)
	ok(_konst(OLD.to_upper() + "_SPEED_ADD") == null, "§1: Run still carries the old card's constant")
	var cache := {}
	var stamp := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_stamp_modifier", cache))
	ok(Gate.count_whole(stamp, "u.mod_speed_add = Run.%s" % kname) == 1,
		"§1: the stamp does not write the card's constant once (`u.mod_speed_add = Run.%s`)" % kname)
	if add == null:
		return
	# THE CARD's TWO CLAUSES, ITS FIGURE THE CONSTANT's AT THE AVERAGE SPEED (100, `unit.gd`'s own convention) — a re-tune moves the
	# words with it (R01), and a figure typed into the words would not.
	var want := "Everyone acts about %d%% more slowly, and the slower a body already is the more it loses. Cooldowns are unchanged." \
		% int(round(-float(add)))
	ok(String(card.get("desc", "")) == want, "§1: the card's words are not its two clauses stating its constant's figure ('%s')" % card.get("desc", ""))
	ok(String(card.get("tag", "")) == "Ld", "§1: the card's chip wears '%s', not its own letters (Ld)" % card.get("tag", ""))
	ok(float(add) == -30.0, "§1: the constant reads %s — the rename moves no magnitude (-30)" % str(add))
	# DRIVEN, ON A REAL BOARD THROUGH THE REAL STAMP (IZ §4's drive, again on the renamed tree): the first 48 turns change hands as
	# they did — a flat amount moves who acts when, where a factor on every speed moves no turn (C04).
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var units: Array = scene.get("heroes") + scene.get("enemies")
	var plain_speeds := {}
	for i in units.size():
		plain_speeds[i] = float(units[i].effective_speed())
	var plain := IZ.turn_order(units, 48)
	for u in units:
		scene.call("_stamp_modifier", u, "frenzied")
	var stamped := IZ.turn_order(units, 48)
	var moved := 0
	for k in plain.size():
		if int(plain[k]) != int(stamped[k]):
			moved += 1
	ok(moved == IZ_MOVED, "§1: DRIVEN — under the card %d of the board's first 48 turns change hands, where IZ's drive read %d — the rename moved the mechanic" % [moved, IZ_MOVED])
	# THE FLOOR, DRIVEN PAST EVERY SPEED (C03): a subtraction no speed survives leaves each unit a tenth of its own, never a stall.
	# Each unit's other speed terms (a chill, a slow) multiply its speed, so its floor is the floor's share of its unstamped speed.
	var floor_k := float(BattleUnit.MOD_SPEED_FLOOR)
	var stalls: Array = []
	for i in units.size():
		var u = units[i]
		u.mod_speed_add = -100000.0
		var s := float(u.effective_speed())
		if s <= 0.0 or absf(s - floor_k * float(plain_speeds[i])) > 0.001:
			stalls.append("%s %.3f (floor %.3f)" % [u.unit_name, s, floor_k * float(plain_speeds[i])])
		u.mod_speed_add = float(add)
	ok(stalls.is_empty() and units.size() >= 5, "§1: DRIVEN — a subtraction past every speed stalls a unit or leaves it off its floor: %s" % str(stalls))
	scene.queue_free()
	await process_frame
	# THE OLD NAME SWEPT (C01): every live text file — the game's code and data, every gate and suite, the rule files, the living
	# documents — names it only where a line names the new one beside it (the rename's own record), or as the enemy ability that
	# shares its word (the Frenzy Nip of the warband, `data/enemies.json`'s whelp — another thing, not the card).
	var files: Array = []
	for d in ["res://scripts/", "res://data/"]:
		for f in DirAccess.get_files_at(d):
			if f.ends_with(".gd") or f.ends_with(".json"):
				files.append(d + f)
	for f in DirAccess.get_files_at("res://"):
		if (f.begins_with("check_") or f.begins_with("test_") or f.ends_with("_fixture.gd")) and f.ends_with(".gd"):
			files.append("res://" + f)
	for p in ["res://CLAUDE.md", "res://README.md", "res://docs/instrument-rules.md", "res://docs/combat-rules.md",
			"res://docs/ways-of-working.md", "res://docs/master.html", "res://docs/text-standard.html", "res://docs/state.md"]:
		files.append(p)
	var hits: Array = []
	var leaden_in := 0
	var nip := OLD + " Nip"
	for p in files:
		var src := FileAccess.get_file_as_string(String(p))
		if src.contains("Leaden"):
			leaden_in += 1
		for line in src.split("\n"):
			var l := String(line).replace(nip, "")
			if (l.contains(OLD) or l.contains(OLD.to_upper())) and not l.contains("Leaden") and not l.contains("LEADEN"):
				hits.append("%s: %s" % [String(p).trim_prefix("res://"), l.strip_edges().left(90)])
	ok(hits.is_empty(), "§1: %d live lines still name the old card without the new: %s" % [hits.size(), str(hits.slice(0, 6))])
	ok(files.size() > 100 and leaden_in >= 4, "§1: the sweep read %d files and %d name Leaden — its positive arm reads nothing" % [files.size(), leaden_in])
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("<tr><td>Leaden</td><td>1</td><td>%s</td></tr>" % want),
		"§1: master.html's bargain table has no Leaden row at severity 1 stating the card")
	print("    CHECKED the card, %s, the id and the chip; DRIVEN %d of 48 turns change hands and the floor holds; swept %d files, %d name Leaden" % [
		kname, moved, files.size(), leaden_in])


# IZ §4's drive read 23 of the first 48 turns changing hands on this board (`docs/reports/IZ.md` §4); the renamed tree reads it again.
const IZ_MOVED := 23


# ── §2 — FLEETING AT 3 ───────────────────────────────────────────────────────────────────────────────
func _s2_fleeting() -> void:
	print("\n§2 — Fleeting at 3, measured in the deck: its reading, its grade, its words")
	var rows := _tsv("res://docs/reports/JA-fleeting.tsv", ["arm", "id", "handle", "value", "runs", "reading", "se", "cost", "d_se",
		"z", "unpaired", "ratio", "prior_cost", "prior_se", "tie_z", "band"])
	var cuts := _cuts()
	ok(cuts.size() == 5, "§2: the scale yields %d cuts — five expected" % cuts.size())
	var arm := {}
	for r in rows:
		if String(r["id"]) == "fleeting":
			arm = r
	ok(not arm.is_empty(), "§2: the kept table holds no Fleeting arm")
	if arm.is_empty() or cuts.size() != 5:
		return
	var z := float(arm["cost"]) / maxf(float(arm["d_se"]), 1e-9)
	var ratio := float(arm["d_se"]) / maxf(float(arm["unpaired"]), 1e-9)
	var tie := (float(arm["cost"]) - float(arm["prior_cost"])) / sqrt(pow(float(arm["d_se"]), 2) + pow(float(arm["prior_se"]), 2))
	var band := _band(float(arm["cost"]), z, cuts)
	ok(absf(z - float(arm["z"])) < 0.01 and absf(ratio - float(arm["ratio"])) < 0.002 and absf(tie - float(arm["tie_z"])) < 0.01
		and band == int(arm["band"]) and int(arm["runs"]) == 60,
		"§2: the arm's z/ratio/tie/band are written %s/%s/%s/%s over %s runs; its figures give %.2f/%.3f/%.2f/%d over sixty" % [
			arm["z"], arm["ratio"], arm["tie_z"], arm["band"], arm["runs"], z, ratio, tie, band])
	# THE DECK HOLDS THE VALUE THE READING WAS TAKEN AT (C05), AT THE GRADE THE READING GIVES, NAMING WHERE IT CAME FROM.
	var live: Variant = _konst("FLEETING_TURNS")
	ok(live != null and int(live) == int(arm["value"]), "§2: fleeting: its reading was taken at FLEETING_TURNS %s and the deck holds %s" % [arm["value"], str(live)])
	var sev := int(_run.modifier_severity("fleeting"))
	ok(sev == band, "§2: fleeting carries severity %d in the game, its in-deck reading gives %d" % [sev, band])
	var card: Dictionary = (_run.MODIFIERS as Dictionary).get("fleeting", {})
	ok(String(card.get("graded", "")) == "the default four — JA §2", "§2: Fleeting's row names '%s' as its grade's source" % card.get("graded", ""))
	# ITS WORDS ARE THE TEMPLATE's AT THE VALUE (C06): the code's rule, stated — three turns less, never below one.
	if live != null:
		var want := "Every status applied lasts %s less (never below one)." % ("one turn" if int(live) == 1 else "%d turns" % int(live))
		ok(String(card.get("desc", "")) == want, "§2: Fleeting's words are not its rule at the value ('%s', want '%s')" % [card.get("desc", ""), want])
	# AND WHY NOT *every effect lasts one turn*: the census of the status door holds statuses of five turns and more (they keep
	# all but three of their turns), so a sentence saying every one lasts one would be false of the rule.
	var ge5 := 0.0
	for d in _tsv("res://docs/reports/JA-durations.tsv", ["party", "pays", "applications", "ge5", "share_ge5"]):
		ge5 += float(d["ge5"])
		var n := float(d["applications"])
		if absf((float(d["ge5"]) / n if n > 0.0 else 0.0) - float(d["share_ge5"])) > 0.001:
			ok(false, "§2: the durations table's share is not its own arithmetic (%s %s)" % [d["party"], d["pays"]])
	ok(ge5 > 0.0, "§2: the census holds no status of five turns or more — the words' reason reads nothing")
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	ok(grades.contains("Fleeting at 3"), "§2: the state file's grades block does not carry Fleeting at 3")
	print("    the arm: %+.2f ± %.2f points (z %.2f), a %d; a tie with IZ's lever point (z %.2f); the deck at %s, severity %d" % [
		float(arm["cost"]), float(arm["d_se"]), z, band, tie, str(live), sev])


# ── §3 — THE SHARE CENSUS ────────────────────────────────────────────────────────────────────────────
func _klass(h: float, w: float) -> String:
	if w <= 0.0 and h <= 0.0:
		return "neither"
	if w <= 0.0:
		return "heroes alone"
	if h <= 0.0:
		return "warband alone"
	var x := h / w
	return "heroes 2x+" if x >= 2.0 else ("warband 2x+" if x <= 0.5 else "inside 2:1")


func _ratio_ok(h: float, w: float, written: String) -> bool:
	if w <= 0.0:
		return written == ("inf" if h > 0.0 else "-")
	return absf(h / w - float(written)) < 0.006


func _s3_the_census() -> void:
	print("\n§3 — the share census: every live modifier's quantity a row, both sides, both parties, the table its own arithmetic")
	var rows := _tsv("res://docs/reports/JA-shares.tsv", ["quantity", "modifiers", "ledger", "ref_heroes", "ref_warband", "ref_ratio",
		"ref_class", "inc_heroes", "inc_warband", "inc_ratio", "inc_class", "ref_fights", "ref_runs", "inc_fights", "inc_runs"])
	var bad: Array = []
	var named := {}
	for r in rows:
		for side in ["ref", "inc"]:
			var h := float(r[side + "_heroes"])
			var w := float(r[side + "_warband"])
			if not _ratio_ok(h, w, String(r[side + "_ratio"])) or _klass(h, w) != String(r[side + "_class"]):
				bad.append("%s (%s): %s / %s written %s, %s" % [r["quantity"], side, r[side + "_heroes"], r[side + "_warband"], r[side + "_ratio"], r[side + "_class"]])
		for m in String(r["modifiers"]).split(","):
			if m != "-" and m != "":
				named[m] = true
	ok(bad.is_empty() and rows.size() >= 20, "§3: %d of the census's %d rows are not their own arithmetic: %s" % [bad.size(), rows.size(), str(bad)])
	# THE POPULATION IS DERIVED, NOT LISTED (C07): every modifier the deck holds has its quantity's row, and no row names one it does not.
	var deck: Array = _deck_before_jb().keys()
	var missing: Array = deck.filter(func(id): return not named.has(String(id)))
	var stray: Array = named.keys().filter(func(id): return not (_run.MODIFIERS as Dictionary).has(String(id)))
	ok(missing.is_empty(), "§3: %d live modifiers' quantities have no row in the census: %s" % [missing.size(), str(missing)])
	ok(stray.is_empty(), "§3: the census names modifiers the deck does not hold: %s" % str(stray))
	# BOTH PARTIES READ, AND EACH OVER REAL FIGHTS.
	if rows.size() > 0:
		var r0: Dictionary = rows[0]
		ok(int(r0["ref_runs"]) >= 20 and int(r0["inc_runs"]) >= 60 and int(r0["ref_fights"]) > 0 and int(r0["inc_fights"]) > 0,
			"§3: the census read %s runs of the reference party and %s of the incumbent — twenty and sixty were driven" % [r0["ref_runs"], r0["inc_runs"]])
	var state := _flat(_doc("res://docs/state.md"))
	ok(state.contains("THE SHARE CENSUS"), "§3: the state file carries no record of the share census")
	print("    CHECKED %d quantities, both parties; %d of the deck's %d modifiers placed on a quantity" % [rows.size(), deck.size() - missing.size(), deck.size()])


# ── §4 — THE AXIS TABLE ──────────────────────────────────────────────────────────────────────────────
func _s4_the_axes() -> void:
	print("\n§4 — the axis table: the deck's modifiers on their axes at their grades, crossed with the census")
	var rows := _tsv("res://docs/reports/JA-axes.tsv", ["axis", "quantity", "modifiers", "grades", "top", "holds_4", "ref_ratio",
		"inc_ratio", "candidate"])
	var shares := {}
	for s in _tsv("res://docs/reports/JA-shares.tsv", ["quantity", "ref_ratio", "inc_ratio"]):
		shares[String(s["quantity"])] = s
	var seen := {}
	var off: Array = []
	var fours: Array = []
	for r in rows:
		var gs: Array = []
		for pair in String(r["modifiers"]).split(","):
			var kv := String(pair).split(":")
			var id := String(kv[0])
			var sev := int(_run.modifier_severity(id)) if (_run.MODIFIERS as Dictionary).has(id) else -1
			if kv.size() != 2 or int(kv[1]) != sev:
				off.append("%s: %s is written at %s, the deck holds it at %d" % [r["axis"], id, kv[1] if kv.size() > 1 else "?", sev])
			seen[id] = int(seen.get(id, 0)) + 1
			gs.append(sev)
		gs.sort()
		var top := int(gs.max()) if gs.size() > 0 else 0
		if ",".join(gs.map(func(x): return str(x))) != String(r["grades"]) or top != int(r["top"]) \
				or (gs.has(4) != (String(r["holds_4"]) == "yes")):
			off.append("%s: grades %s top %s 4 %s — the deck gives %s top %d 4 %s" % [r["axis"], r["grades"], r["top"], r["holds_4"], str(gs), top, str(gs.has(4))])
		if gs.has(4):
			fours.append(String(r["axis"]))
		# THE CROSSING: the axis's quantity as the census read it, and a candidate only where the warband produces it too.
		var q := String(r["quantity"])
		if not shares.has(q) or String(shares[q]["ref_ratio"]) != String(r["ref_ratio"]) or String(shares[q]["inc_ratio"]) != String(r["inc_ratio"]):
			off.append("%s: its quantity '%s' does not read the census's ratios" % [r["axis"], q])
		else:
			var even := false
			for side in ["ref_ratio", "inc_ratio"]:
				var x := String(r[side])
				if x != "inf" and x != "-" and float(x) < 2.0:
					even = true
			if (String(r["candidate"]) == "yes") != even:
				off.append("%s: written candidate '%s', the census gives %s" % [r["axis"], r["candidate"], str(even)])
	ok(off.is_empty(), "§4: %d of the axis table's cells are not the deck's or the census's: %s" % [off.size(), str(off)])
	var deck: Array = _deck_before_jb().keys()
	var unplaced: Array = deck.filter(func(id): return int(seen.get(String(id), 0)) != 1)
	ok(unplaced.is_empty() and rows.size() >= 8, "§4: %d modifiers of the deck sit on no axis or on two: %s" % [unplaced.size(), str(unplaced)])
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	# RE-POINTED AT JB §4: JA's table is the deck before the four, and it read grade 4 on health alone; the state speaks for the deck since (`check_jb` §4).
	ok(fours == ["health"] and grades.contains("Grade 4 holds health and tempo"),
		"§4: JA's table holds a 4 on %s, or the state file's grades block does not say what grade 4 holds now" % str(fours))
	print("    CHECKED %d axes over the deck's %d modifiers; the axes holding a 4: %s" % [rows.size(), deck.size(), str(fours)])


# ── §5 — test_batch_cb's COIN FLIP ───────────────────────────────────────────────────────────────────
func _s5_the_coin_flip() -> void:
	print("\n§5 — test_batch_cb's Pyre Wake deep-stack arm reads the bank, never where the scatter's fires fell")
	var cache := {}
	var body := Gate.strip_comments(Gate.fn_body("test_batch_cb.gd", "_live_pyre_wake", cache))
	ok(body != "", "§5: test_batch_cb.gd has no `_live_pyre_wake`")
	ok(body.contains("py2.resource - mana2_was == 9 - pw2_cost"),
		"§5: the deep-stack arm does not read the bank at Overburn's door (the refund of the nine turns consumed)")
	ok(not body.contains("_burn_turns(deep) < 9"),
		"§5: the deep-stack arm reads where the scatter's fires fell again (`_burn_turns(deep) < 9`) — a coin flip (HR §6)")
	ok(body.contains("_burn_turns(deep) + _burn_turns(f2[1]) == 9"),
		"§5: the total arm (all nine landed again) is gone — the bank's positive arm")
	print("    CHECKED the arm's predicate in test_batch_cb's source")
