# BATCH IY — THE INSTRUMENT SHARPENED, AND NINE HANDLES TURNED.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: a grade's band is wider than its instrument and a grade may not
#        understate a measured cost (`CLAUDE.md`, beside the scale); pair at the unit you measure (`docs/instrument-rules.md`);
#        a count a door can compute belongs behind a door (`CLAUDE.md`'s figure rule); the nine slopes and a handle with no
#        reach (`docs/state.md`, where the grades are read).
#   §1   SEED A FIGHT, NOT A RUN: the sim reads `DOD_SIM_FIGHT_SEED` and reseeds at the step onto every node and at a won
#        fight's spoils, through one door, spending no die unset; DRIVEN, two arms whose fights drew different dice meet the
#        same dice at every later node with the flag and part without it; the kept table's ratio and ties, and the verdict
#        they give.
#   §2   NINE HANDLES, NINE SLOPES: each handle is a `Run` constant its stamp reads bare and its words format; the kept
#        table's new value is the live constant (a re-tune moves the table's subject) and follows its step's own rule from
#        the old; each slope is its two pairs' arithmetic; each grade the test-bound band of its new cost; no modifier that
#        costs nothing carries a severity, and some cost something and carry one.
#   §3   THE REACH TEST: each verdict the pre-registered rule's off its own figures, with the healing read beside it.
#   §4   EVERY GRADE IS THE HIGHEST COST MEASURED, TEST-BOUND, WITH ITS POPULATION AND ITS BATCH: the kept table's grade is the
#        best band among the readings that measure the modifier as it stands; every severity in the game is that grade; every
#        row of `Run.MODIFIERS` names the population and the batch; the state file says which reading was the higher.
#   §5   THE GLOSSARY's COUNT IS BEHIND A DOOR, AND THE BANDS ARE READ, NOT RE-SET: the entry's words carry the token and no
#        written count, and resolve to the count the deck holds; the rungs' bands are the ones the scale read, and the state
#        file says what each holds.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** It holds the kept tables' arithmetic, the code's doors and the documents'
# agreement with them — never that the readings are what the sim produces: that is the drive (`docs/reports/IY.md` §1–§3),
# which no gate re-runs. §1's drive walks the sim's own map with no fight in it: it proves the seed is the node's, not that a
# fight's rolls stay aligned past the first branch (the report's ratio is that). A handle re-tuned after the drive reds §2,
# because the table no longer measures the deck.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iy.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _docs := {}
var _run: Node = null
var _reach_turns := {}
# RunSim's seeding members, reached through an untyped reference and never named statically: against a tree that lacks them
# (HEAD's code — IY's control H01) the gate must red on its FAIL lines; named statically, it failed to parse and printed nothing.
var _rs = null


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IY — THE INSTRUMENT SHARPENED, AND NINE HANDLES TURNED")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	_s1_the_seeding()
	_s2_the_handles()
	_s3_the_reach()
	_s4_the_grades()
	_s5_the_door_and_the_bands()
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


const SEEDING_TSV := "docs/reports/IY-seeding.tsv"
const REACH_TSV := "docs/reports/IY-reach.tsv"
const HANDLES_TSV := "docs/reports/IY-handles.tsv"
const GRADES_TSV := "docs/reports/IY-grades.tsv"
# IX's scale (the cuts IX §3 derived; `check_ix` §3 re-derives them off IW's ladder every battery and holds the files to them).
const CUTS := [0.48, 1.70, 3.70, 6.88, 12.22]
# IX's figure for what pairing by run bought — the median paired error over the unpaired across IW's 23 arms (IX §1c).
const IX_MEDIAN_RATIO := 0.91
# The rungs' bands when the scale read them (IX §3): read here, never re-set (IY §0.4).
const BANDS := {"wanderer": [[1, 2], [3, 4]], "warden": [[1, 3], [4, 4]], "ruin": [[3, 4], [5, 5]]}
# THE NINE HANDLES: the modifier, its constant, the line of `battle._stamp_modifier`'s branch that reads it bare, and the figure
# each one's words state, formatted off the constant the way its `desc` does.
# RE-POINTED AT IZ: Dull Edge (§3) and Tinderbox (§5) are removed, so seven handles stand; Frenzied's is the flat amount its re-key
# adds (§4). IY's table below keeps all nine as IY's record.
const HANDLES := [
	["parched", "PARCHED_SHARE", "u.resource = mini(u.resource, int(u.max_resource * Run.PARCHED_SHARE))"],
	["frenzied", "FRENZIED_SPEED_ADD", "u.mod_speed_add = Run.FRENZIED_SPEED_ADD"],
	["muffled", "MUFFLED_BD_PCT", "u.mod_bd_mult = Run.MUFFLED_BD_PCT"],
	["fleeting", "FLEETING_TURNS", "u.mod_status_turns = -Run.FLEETING_TURNS"],
	["hoarfrost", "HOARFROST_CHILL_TURNS", "_apply_status(u, \"chilled\", Run.HOARFROST_CHILL_TURNS)"],
	["slick", "SLICK_DELAY", "ab.delay += Run.SLICK_DELAY"],
	["bloodletting", "BLOODLETTING_BLEED", "u.mod_bleed_add = Run.BLOODLETTING_BLEED"],
]


func _band(cost_points: float, z: float) -> int:
	# THE TEST BINDS (IY §0.1): a cost inside two of its standard errors of none is no cost, whatever band its midpoint is in.
	if z < 2.0:
		return 0
	var b := 0
	for k in CUTS.size():
		if cost_points >= float(CUTS[k]):
			b = k + 1
	return b


func _konst(name: String) -> Variant:
	return (_run.get_script() as Script).get_script_constant_map().get(name, null)


# ── §0 — THE RULINGS, EACH WHERE A FUTURE SESSION READS IT ──────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var ir := _doc("res://docs/instrument-rules.md")
	var state := _doc("res://docs/state.md")
	ok(claude.contains("A GRADE's BAND MUST BE WIDER THAN THE INSTRUMENT THAT SETS IT"),
		"§0.1: CLAUDE.md does not say a grade's band must be wider than the instrument that sets it")
	ok(claude.contains("A GRADE MAY OVERSTATE WHAT A MODIFIER COSTS. IT MAY NOT UNDERSTATE IT. THE GRADE IS THE HIGHEST COST THE PROJECT HAS MEASURED, ON ANY POPULATION"),
		"§0.3: CLAUDE.md does not carry the rule that a grade may not understate a measured cost")
	ok(claude.contains("A COUNT A DOOR CAN COMPUTE BELONGS BEHIND A DOOR, NOT DELETED"),
		"§0.5: CLAUDE.md does not carry the rule that a count a door can compute belongs behind a door")
	ok(ir.contains("PAIR AT THE UNIT YOU MEASURE, NOT THE UNIT YOU RUN."),
		"§1: the instrument rules do not carry the ruling — pair at the unit you measure, not the unit you run")
	ok(state.contains("TURNING NINE HANDLES TO ONE TARGET MEASURES NINE SLOPES"),
		"§0.2: docs/state.md does not carry the ruling that nine handles turned to one target measure nine slopes")
	ok(state.contains("A HANDLE WITH NO REACH CANNOT BE TURNED INTO A COST AT ANY VALUE"),
		"§3: docs/state.md does not carry what the reach test reads — a handle with no reach cannot be turned into a cost at any value")
	# THE RULE STANDS BESIDE THE SCALE (IY §4): within the ladder block that states the scale.
	var scale_at := claude.find("no severity under ")
	var rule_at := claude.find("THE GRADE IS THE HIGHEST COST THE PROJECT HAS MEASURED")
	ok(scale_at >= 0 and rule_at >= 0 and absi(rule_at - scale_at) < 6000,
		"§4: CLAUDE.md's higher-cost rule does not stand beside the scale (%d bytes apart)" % absi(rule_at - scale_at))
	print("    CHECKED six rulings in their files, and the grade rule beside the scale")


# ── §1 — SEED A FIGHT, NOT A RUN ──────────────────────────────────────────────────────────────────────
func _s1_the_seeding() -> void:
	print("\n§1 — the sim seeds every node and every won fight's spoils off the run's seed, and the instrument paid")
	var cache := {}
	var begin := Gate.strip_comments(Gate.fn_body("scripts/run_sim.gd", "begin", cache))
	var walk := Gate.strip_comments(Gate.fn_body("scripts/run_sim.gd", "walk_to_next_fight", cache))
	var end := Gate.strip_comments(Gate.fn_body("scripts/run_sim.gd", "on_battle_end", cache))
	var door := Gate.strip_comments(Gate.fn_body("scripts/run_sim.gd", "_seed_node", cache))
	ok(Gate.count_whole(begin, "fight_seed_block = OS.get_environment(\"DOD_SIM_FIGHT_SEED\")") == 1,
		"§1: RunSim.begin does not read DOD_SIM_FIGHT_SEED once")
	var adv := walk.find("run.advance(pick)")
	ok(Gate.count_whole(walk, "_seed_node(run, 0)") == 1 and adv >= 0 and walk.find("_seed_node(run, 0)") > adv,
		"§1: the walk does not reseed once, right after the step onto a node (`_seed_node(run, 0)` after `run.advance(pick)`)")
	ok(Gate.count_whole(end, "_seed_node(run, 1)") == 1 and end.find("_seed_node(run, 1)") > end.find("if not victory:"),
		"§1: a won fight's spoils do not reseed once, below the loss's early return (`_seed_node(run, 1)`)")
	ok(door.contains("if fight_seed_block == \"\":") and door.contains("seed(node_seed("),
		"§1: `_seed_node` is not the one door — it returns unset and reseeds off `node_seed`")
	_rs = RunSim
	var names: Array = (_rs as Script).get_script_method_list().map(func(m): return String(m["name"]))
	var has_door: bool = names.has("node_seed") and names.has("_seed_node") and door != ""
	ok(has_door, "§1: RunSim declares no `node_seed` or no `_seed_node` — the fight seed has no door")
	if not has_door:
		return
	ok(_rs.node_seed(38, 4, 1, 7, 0) == _rs.node_seed(38, 4, 1, 7, 0) and _rs.node_seed(38, 4, 1, 7, 0) != _rs.node_seed(38, 4, 1, 8, 0)
		and _rs.node_seed(38, 4, 1, 7, 0) != _rs.node_seed(38, 4, 1, 7, 1) and _rs.node_seed(38, 4, 1, 7, 0) != _rs.node_seed(39, 4, 1, 7, 0),
		"§1: `node_seed` is not a function of the block, the run, the zone, the slot and the phase alone")
	# UNSET, NO DIE IS SPENT.
	var was_block: String = _rs.fight_seed_block
	_rs.fight_seed_block = ""
	seed(5)
	var a := randi()
	seed(5)
	_rs._seed_node(_run, 0)
	var b := randi()
	ok(a == b, "§1: unset, `_seed_node` moved the dice (%d against %d) — the switch must be inert unset" % [a, b])
	# DRIVEN: two arms through the sim's own walk, their fights drawing different dice, meet the same dice at every later node.
	var was_runs: int = RunSim.runs_done
	var was_sim: bool = _run.sim_run
	_run.sim_run = true  # in memory: a sim run never touches the player's save
	_rs.fight_seed_block = "38"
	var arm_a := _walk_arm(7, 3)
	var arm_b := _walk_arm(19, 1)
	ok(arm_a.size() >= 5 and arm_a == arm_b,
		"§1: DRIVEN — with the flag set, two arms whose fights drew 7 and 19 dice do not meet the same dice at every later node: %s against %s" % [str(arm_a), str(arm_b)])
	_rs.fight_seed_block = ""
	var arm_c := _walk_arm(7, 3)
	var arm_d := _walk_arm(19, 1)
	ok(arm_c.size() >= 5 and arm_c[0] == arm_d[0] and arm_c != arm_d,
		"§1: DRIVEN — unset, the two arms did not part after their first fight (the positive arm: the alignment is the seed's): %s against %s" % [str(arm_c), str(arm_d)])
	_rs.fight_seed_block = was_block
	RunSim.runs_done = was_runs
	_run.sim_run = was_sim
	# THE KEPT TABLE, AND THE VERDICT IT GIVES (IY §1: the pass is the cheap arm's ratio below 0.91; the readings ties).
	var rows := _tsv("res://" + SEEDING_TSV, ["arm", "id", "seed_block", "seeding", "runs", "reading", "se", "cost", "d_se", "z",
		"unpaired", "ratio", "ix_cost", "ix_d_se", "ix_ratio", "tie_z"])
	var by := {}
	for r in rows:
		by[String(r["id"])] = r
	ok(by.has("none") and by.has("encumbered") and by.has("frenzied"),
		"§1: the seeding table carries no baseline, no Encumbered or no Frenzied arm (%s)" % str(by.keys()))
	if not (by.has("none") and by.has("encumbered") and by.has("frenzied")):
		return
	var bad: Array = []
	for id in ["encumbered", "frenzied"]:
		var r: Dictionary = by[id]
		var ratio := float(r["d_se"]) / maxf(float(r["unpaired"]), 1e-9)
		if absf(ratio - float(r["ratio"])) > 0.001:
			bad.append("%s's ratio is written %s, its errors give %.3f" % [id, r["ratio"], ratio])
		var tie := (float(r["cost"]) - float(r["ix_cost"])) / sqrt(pow(float(r["d_se"]), 2) + pow(float(r["ix_d_se"]), 2))
		if absf(tie - float(r["tie_z"])) > 0.01:
			bad.append("%s's tie z is written %s, its costs give %.2f" % [id, r["tie_z"], tie])
		if absf(tie) >= 2.0:
			bad.append("%s's cost moved past two standard errors from IX's (z %.2f) — a seeding change that moves a reading is not a seeding change" % [id, tie])
	ok(absf(float(by["none"]["tie_z"])) < 2.0, "§1: the baseline at the new seeding is not a tie with IX's (z %s)" % by["none"]["tie_z"])
	ok(bad.is_empty(), "§1: %d of the seeding table's figures are not their own arithmetic, or a reading moved: %s" % [bad.size(), str(bad)])
	var paid := float(by["encumbered"]["ratio"]) < IX_MEDIAN_RATIO and float(by["encumbered"]["ratio"]) < float(by["encumbered"]["ix_ratio"])
	ok(paid, "§1: Encumbered's ratio %s is not below IX's %s and its median 0.91 — the seeding did not pay, and the old one is kept" % [
		by["encumbered"]["ratio"], by["encumbered"]["ix_ratio"]])
	var all_fight := rows.all(func(r): return String(r["seeding"]) == "fight")
	ok(all_fight, "§1: an arm of the seeding table was not driven fight-seeded")
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck), so IY's record is read where it lives.
	var grades := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	ok(grades.contains("ratio %.3f" % float(by["encumbered"]["ratio"])) and grades.contains("DOD_SIM_FIGHT_SEED"),
		"§1: the state file's grades block does not carry Encumbered's ratio (%.3f) or name the seeding the arms are driven at" % float(by["encumbered"]["ratio"]))
	print("    CHECKED the seeding's doors in run_sim.gd, the switch inert unset, two arms DRIVEN both ways (%d nodes), and %d arms of the kept table (Encumbered's ratio %s against IX's %s)" % [
		arm_a.size(), rows.size(), by["encumbered"]["ratio"], by["encumbered"]["ix_ratio"]])


# One arm of §1's drive: a run started and walked by the sim's own doors, each "fight" drawing `fight_draws` dice and its
# spoils `spoils_draws` — the first die at every node and every spoils, which is what the seed is for.
func _walk_arm(fight_draws: int, spoils_draws: int) -> Array:
	var out: Array = []
	seed(99991)
	RunSim.runs_done = 0
	RunSim.start_run(_run)
	out.append("%s die %d" % [String(_run.encounter.get("type", "")), randi()])
	for k in 3:
		for i in fight_draws:
			randi()
		_rs._seed_node(_run, 1)
		out.append("spoils die %d" % randi())
		for i in spoils_draws:
			randi()
		if not RunSim.walk_to_next_fight(_run):
			break
		out.append("%s die %d" % [String(_run.encounter.get("type", "")), randi()])
	return out


# ── §2 — NINE HANDLES, ONE TARGET, NINE SLOPES ──────────────────────────────────────────────────────
# The figure a modifier's words state, off its constant, the way its `desc` formats it.
func _figure_words(id: String, v: Variant) -> String:
	if v == null:  # no constant to read (HEAD's code, IY's control H01): the words cannot be derived, and the caller reds
		return "(no constant)"
	match id:
		"dulledge":
			return "-%d%%" % int(round(float(v) * 100))
		"parched":
			return "at %s resource" % String(_konst("SHARE_WORDS")[float(v)])
		"tinderbox":
			return "+%d%%" % int(round(float(v) * 100))
		"frenzied":
			return "%d%% faster" % int(round(float(v)))
		"muffled":
			return "reduced %d%%" % (100 - int(v))
		"fleeting":
			return "lasts %s less" % ("one turn" if int(v) == 1 else "%d turns" % int(v))
		"hoarfrost":
			return "begins the fight Chilled"
		"slick":
			return "+%s initiative" % str(v)
		"bloodletting":
			return "add %d Bleed" % int(v)
	return "?"


# The step a handle's rule gives from its old value (IY §2: a step, not a ratio, where the cost had no slope to scale from).
func _step(rule: String, old: float, floor_v: float) -> float:
	match rule:
		"a reduction doubled":
			return old * 2.0
		"a reduction doubled, to its floor":
			return minf(old * 2.0, floor_v)
		"a bonus trebled":
			return old * 3.0
		"the share's reduction doubled":
			# a share of 1 (Parched's) or an integer percent of 100 (Muffled's): what it takes away, doubled
			var whole := 100.0 if old > 1.0 else 1.0
			return maxf(whole - 2.0 * (whole - old), 0.0)
		"no reach: not turned":
			return old
	return NAN


func _s2_the_handles() -> void:
	print("\n§2 — nine handles: each a constant read bare and stated in its words, and the kept table's steps and slopes")
	var cache := {}
	var stamp := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_stamp_modifier", cache))
	var rs_src := Gate.strip_comments(_doc("res://scripts/run_state.gd"))
	var bad: Array = []
	for h in HANDLES:
		var id := String(h[0])
		var cname := String(h[1])
		if RegEx.create_from_string("(?m)^const " + cname + " := ").search_all(rs_src).size() != 1:
			bad.append("%s's constant %s is not declared once in run_state.gd" % [id, cname])
		if Gate.count_whole(stamp, String(h[2])) != 1:
			bad.append("%s's stamp does not read %s bare (`%s`)" % [id, cname, h[2]])
		var desc := String((_run.MODIFIERS[id] as Dictionary).get("desc", ""))
		var words := _figure_words(id, _konst(cname))
		if not desc.contains(words):
			bad.append("%s's words do not state its constant's figure ('%s' not in '%s')" % [id, words, desc])
	# THE OLD LITERALS ARE GONE FROM THE STAMP: a branch that reads its constant does not carry its old figure beside it.
	for lit in ["u.crit_bonus - 0.05", "u.mod_speed_mult = 1.3", "u.max_resource / 2", "u.mod_bd_mult = 75", "u.mod_status_turns = -1",
			"\"chilled\", 3)", "ab.delay += 0.5", "u.mod_bleed_add = 15", "+ 0.25\n"]:
		if stamp.contains(lit):
			bad.append("the stamp still carries the literal `%s`" % lit.strip_edges())
	# AND THE DESIGN DOCUMENT's TABLE STATES THE SAME FIGURE (IQ §2's rule: a figure `master.html` states is held to what decides
	# it) — the row for each of the nine, read with its markup and whitespace flattened.
	var master := _flat(_doc("res://docs/master.html").replace("&mdash;", "—"))
	for h2 in HANDLES:
		var id2 := String(h2[0])
		var name2 := String((_run.MODIFIERS[id2] as Dictionary).get("name", ""))
		var at2 := master.find("<tr><td>%s</td>" % name2)
		var row2 := master.substr(at2, master.find("</tr>", at2) - at2) if at2 >= 0 else ""
		if not row2.contains(_figure_words(id2, _konst(String(h2[1])))):
			bad.append("master.html's row for %s does not state '%s'" % [name2, _figure_words(id2, _konst(String(h2[1])))])
	ok(bad.is_empty(), "§2: %d of the nine handles are not a constant read bare and stated in its words: %s" % [bad.size(), str(bad)])
	# THE KEPT TABLE.
	for rr in _tsv("res://" + REACH_TSV, ["id", "fight_turns_per_hero"]):
		_reach_turns[String(rr["id"])] = float(rr["fight_turns_per_hero"])
	var rows := _tsv("res://" + HANDLES_TSV, ["modifier", "id", "constant", "old_value", "new_value", "rule", "reasoning", "old_cost",
		"old_se", "new_cost", "new_se", "new_z", "slope", "grade"])
	# RE-POINTED AT IZ: the table is IY's record of nine; the deck holds seven of them (two removed at IZ).
	ok(rows.size() == 9, "§2: the handles table holds %d rows — the nine are nine" % rows.size())
	# THE DECK's VALUES ARE IZ's PLACING (`docs/reports/IZ-grades.tsv`, held to the live constants by `check_iz` §2): a handle the
	# placing kept is still IY's new value; one it reverted is back at IY's old value; one removed or re-keyed is IY's record alone.
	var placed := {}
	var iz_src := {}
	for zr in _tsv("res://docs/reports/IZ-grades.tsv", ["id", "handle", "value", "population", "batch"]):
		placed[String(zr["id"])] = [String(zr["handle"]), String(zr["value"])]
		iz_src[String(zr["id"])] = "%s — %s" % [String(zr["population"]), String(zr["batch"])]
	var off: Array = []
	var costs := 0
	for r in rows:
		var id := String(r["id"])
		var live: Variant = _konst(String(r["constant"]))
		# THE TABLE MEASURED THE DECK IY LEFT (R01 at IY); SINCE IZ the placing decides it — kept at IY's value or reverted to IY's old one.
		var pl: Array = placed.get(id, ["", ""])
		if String(pl[0]) == String(r["constant"]):
			var kept := is_equal_approx(float(pl[1]), float(r["new_value"]))
			var reverted := is_equal_approx(float(pl[1]), float(r["old_value"]))
			if live == null or not is_equal_approx(float(live), float(pl[1])) or not (kept or reverted):
				off.append("%s: the placing holds %s at %s and the deck at %s — neither IY's new value %s nor its old %s" % [id, r["constant"], pl[1], str(live), r["new_value"], r["old_value"]])
		# THE STEP IS ITS RULE's (C03): derived from the old value, never chosen.
		var floor_v := float((load("res://scripts/battle.gd") as Script).get_script_constant_map()["CRIT_CHANCE"]) if id == "dulledge" else 1e9
		var want := _step(String(r["rule"]), float(r["old_value"]), floor_v)
		if String(r["rule"]) == "derived against the reach test: the fight's length":
			# THE HANDLE's REACH IS THE FIGHT's LENGTH: a Chilled that outlasts the fight buys nothing more, so the value is the
			# bargain fight's length in each hero's own turns, off §3's reach row, rounded up.
			want = ceilf(float(_reach_turns.get(id, -1.0)))
		if is_nan(want) or not is_equal_approx(want, float(r["new_value"])):
			off.append("%s: its new value %s is not what its rule '%s' gives from %s (%s)" % [id, r["new_value"], r["rule"], r["old_value"], str(want)])
		if String(r["reasoning"]).length() < 24:
			off.append("%s carries no reasoning" % id)
		# THE SLOPE IS ITS TWO PAIRS' ARITHMETIC (points of health per unit of handle).
		var dv := float(r["new_value"]) - float(r["old_value"])
		if absf(dv) > 1e-9:
			var slope := (float(r["new_cost"]) - float(r["old_cost"])) / dv
			if absf(slope - float(r["slope"])) > 0.005 * maxf(1.0, absf(slope)):
				off.append("%s: its slope is written %s, its pairs give %.4f" % [id, r["slope"], slope])
		elif String(r["slope"]) != "-":
			off.append("%s: no step, so no slope, and the table writes %s" % [id, r["slope"]])
		# THE GRADE IS THE TEST-BOUND BAND OF ITS NEW COST.
		var g := _band(float(r["new_cost"]), float(r["new_z"]))
		if g != int(r["grade"]):
			off.append("%s: the table grades it %s, its new cost %s (z %s) gives %d" % [id, r["grade"], r["new_cost"], r["new_z"], g])
		if g > 0:
			costs += 1
	ok(off.is_empty(), "§2: %d of the handles table's rows are not the deck's, their rule's or their own arithmetic: %s" % [off.size(), str(off)])
	# THE ABSENCE AND ITS POSITIVE ARM: no modifier whose cost is inside the noise carries a severity, and some cost something.
	var free_graded: Array = []
	# RE-POINTED AT IZ: only a modifier still graded off IY's own reading answers to it; one IZ re-graded (a sharper reading, another
	# population, a re-key) or removed is IZ's, held by `check_iz` §2 and §5.
	for r in rows:
		if String(iz_src.get(String(r["id"]), "")) != "the default four — IY §2":
			continue
		if int(r["grade"]) == 0 and int(_run.modifier_severity(String(r["id"]))) != 0:
			free_graded.append(String(r["id"]))
	ok(free_graded.is_empty(), "§2: %d of the nine cost nothing the instrument can read and carry a severity: %s" % [free_graded.size(), str(free_graded)])
	ok(costs > 0, "§2: none of the nine turned handles costs something — the positive arm is empty")
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck), so IY's record is read where it lives.
	var grades := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	var unnamed: Array = []
	for r in rows:
		if not grades.contains("%s — %s → %s" % [String(r["modifier"]), String(r["old_value"]), String(r["new_value"])]):
			unnamed.append(String(r["modifier"]))
	ok(unnamed.is_empty(), "§2: the state file's grades block does not name %d handles' steps (old → new): %s" % [unnamed.size(), str(unnamed)])
	print("    CHECKED nine constants read bare and stated, %d table rows: steps, slopes and grades; %d of the nine cost something" % [rows.size(), costs])


# ── §3 — THE REACH TEST ─────────────────────────────────────────────────────────────────────────────
func _s3_the_reach() -> void:
	print("\n§3 — the reach test: each verdict the pre-registered rule's, the healing read beside it")
	var rows := _tsv("res://" + REACH_TSV, ["modifier", "id", "handle", "deck_value", "extreme_value", "cost", "d_se", "z", "heal",
		"heal_se", "heal_z", "verdict"])
	ok(rows.size() == 2, "§3: the reach table holds %d rows — Frenzied and Hoarfrost" % rows.size())
	var bad: Array = []
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck), so IY's record is read where it lives.
	var grades := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	for r in rows:
		var z := float(r["cost"]) / maxf(float(r["d_se"]), 1e-9)
		if absf(z - float(r["z"])) > 0.01:
			bad.append("%s's z is written %s, its cost gives %.2f" % [r["id"], r["z"], z])
		# THE RULE WRITTEN BEFORE THE DRIVE (IY's s1/PREDICT_S3.md): a cost past two standard errors is reach.
		var want := "reach" if z >= 2.0 else "no reach"
		if String(r["verdict"]) != want:
			bad.append("%s's verdict is written '%s', its z %.2f gives '%s'" % [r["id"], r["verdict"], z, want])
		if not (String(r["heal_se"]).is_valid_float() and float(r["heal_se"]) > 0.0):
			bad.append("%s carries no error on its healing" % r["id"])
		if float(r["extreme_value"]) <= float(r["deck_value"]) * 2.0:
			bad.append("%s's extreme %s is not far past its deck value %s" % [r["id"], r["extreme_value"], r["deck_value"]])
		if not grades.contains("%s at %s: %s" % [String(r["modifier"]), String(r["extreme_value"]), want]):
			bad.append("the state file does not name %s's reach as read ('%s at %s: %s')" % [r["id"], r["modifier"], r["extreme_value"], want])
	ok(bad.is_empty(), "§3: %d of the reach table's figures or verdicts are not their own arithmetic: %s" % [bad.size(), str(bad)])
	print("    CHECKED %d reach rows against the rule" % rows.size())


# ── §4 — EVERY GRADE: THE HIGHEST COST MEASURED, TEST-BOUND, ITS POPULATION AND ITS BATCH ───────────────
func _s4_the_grades() -> void:
	print("\n§4 — every grade is the highest cost measured on any population, test-bound, and says whose it is")
	# Each row: IX's reference reading and IV's incumbent reading, the sweep's two (`higher` names which is the more costly);
	# the reference reading the grade reads (IX's, or IY §2's where the handle moved); whether the incumbent's reading still
	# measures the modifier as it stands (`inc_applies` — no once its handle moved); each one's test-bound band; the grade.
	var rows := _tsv("res://" + GRADES_TSV, ["modifier", "id", "ix_ref_cost", "ref_cost", "ref_se", "ref_z", "ref_source", "inc_cost",
		"inc_se", "inc_z", "inc_applies", "higher", "ref_band", "inc_band", "grade", "population", "batch"])
	var mods: Dictionary = _run.MODIFIERS
	# RE-POINTED AT IZ: IY's table graded IY's deck; IZ removed two of its rows, and re-graded others on sharper readings or other
	# populations (`docs/reports/IZ-grades.tsv`, `check_iz` §2). IY's table is held to its own arithmetic here, and to the game only
	# where IZ kept IY's grade and its source.
	var iz_src := {}
	for zr in _tsv("res://docs/reports/IZ-grades.tsv", ["id", "population", "batch"]):
		iz_src[String(zr["id"])] = "%s — %s" % [String(zr["population"]), String(zr["batch"])]
	ok(rows.size() == mods.size() + 2, "§4: the grades table holds %d rows — the deck holds %d" % [rows.size(), mods.size()])
	var off: Array = []
	var unsourced: Array = []
	var counts := {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	var by_inc := 0
	for r in rows:
		var id := String(r["id"])
		var rb := _band(float(r["ref_cost"]), float(r["ref_z"]))
		var ib := _band(float(r["inc_cost"]), float(r["inc_z"])) if String(r["inc_applies"]) == "yes" else 0
		if rb != int(r["ref_band"]) or ib != int(r["inc_band"]):
			off.append("%s: bands written %s / %s, its readings give %d / %d" % [id, r["ref_band"], r["inc_band"], rb, ib])
		# A GRADE MAY NOT UNDERSTATE A MEASURED COST (C05): the grade is the better of the two test-bound bands.
		var g := maxi(rb, ib)
		if g != int(r["grade"]):
			off.append("%s: graded %s, the higher of its bands is %d" % [id, r["grade"], g])
		# THE SWEEP (IY §4): of IX's reading and IV's, which costs the more — said for every modifier, moved or not.
		var hi := "reference" if float(r["ix_ref_cost"]) >= float(r["inc_cost"]) else "incumbent"
		if hi != String(r["higher"]):
			off.append("%s: the higher reading is written %s, its costs say %s" % [id, r["higher"], hi])
		# WHOSE GRADE IT IS: the population of the highest cost that passes the test — the incumbent's where its band is the
		# higher, or its cost the higher inside one band; the default four's otherwise, and where neither reading passes.
		var inc_valid := String(r["inc_applies"]) == "yes"
		var pop := "the incumbent" if inc_valid and (ib > rb or (ib == rb and ib > 0 and float(r["inc_cost"]) > float(r["ref_cost"]))) else "the default four"
		if pop != String(r["population"]):
			off.append("%s: its highest passing cost is %s's, and the table names %s" % [id, pop, r["population"]])
		if pop == "the incumbent":
			by_inc += 1
		var sev := int(_run.modifier_severity(id))
		var iy_kept := String(iz_src.get(id, "")) == "%s — %s" % [String(r["population"]), String(r["batch"])]
		if iy_kept and sev != g:
			off.append("%s carries severity %d in the game, the highest measured cost gives %d" % [id, sev, g])
		counts[g] = int(counts.get(g, 0)) + 1
		# EVERY GRADE NAMES ITS POPULATION AND ITS BATCH (C06), in the code's own row.
		var graded := String((mods.get(id, {}) as Dictionary).get("graded", ""))
		if iy_kept and graded != "%s — %s" % [String(r["population"]), String(r["batch"])] or String(r["batch"]) == "":
			unsourced.append("%s ('%s', the table: '%s — %s')" % [id, graded, r["population"], r["batch"]])
	ok(off.is_empty(), "§4: %d grades are not the highest cost measured, test-bound: %s" % [off.size(), str(off)])
	ok(unsourced.is_empty(), "§4: %d rows of Run.MODIFIERS do not name the population and the batch their grade came from: %s" % [unsourced.size(), str(unsourced)])
	# DEADENED AND BRITTLE (IY §0.3), AND THE POSITIVE ARM: the incumbent grades some modifier.
	ok(int(_run.modifier_severity("deadened")) == 3 and int(_run.modifier_severity("brittle")) == 2,
		"§4: Deadened carries %d and Brittle %d — the incumbent's readings give them 3 and 2" % [_run.modifier_severity("deadened"), _run.modifier_severity("brittle")])
	ok(by_inc >= 2, "§4: the incumbent grades %d modifiers — Deadened and Brittle at least" % by_inc)
	# RE-POINTED AT IZ: IZ archived IY's grades block word for word (its heading struck), so IY's record is read where it lives.
	var grades := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~THE BARGAIN DECK's GRADES~~"))
	var said: Array = []
	for r in rows:
		if not grades.contains("%s — the %s is the higher" % [String(r["modifier"]), String(r["higher"])]):
			said.append(String(r["modifier"]))
	ok(said.is_empty(), "§4: the state file's sweep does not say for %d modifiers which reading is the higher: %s" % [said.size(), str(said)])
	print("    CHECKED %d grades against both readings (%d by the incumbent); the grades hold none %d; 1 %d; 2 %d; 3 %d; 4 %d; 5 %d" % [
		rows.size(), by_inc, counts[0], counts[1], counts[2], counts[3], counts[4], counts[5]])


# ── §5 — THE GLOSSARY's COUNT, AND THE BANDS READ ───────────────────────────────────────────────────
func _s5_the_door_and_the_bands() -> void:
	print("\n§5 — the glossary's count behind its door, and the rungs' bands read, not re-set")
	var raw := _doc("res://data/glossary.json")
	var at := raw.find("\"id\": \"modifier\"")
	var entry := raw.substr(at, raw.find("\"see_also\"", at) - at) if at >= 0 else ""
	var token := "{=Run.figure_modifiers_dealt_beneath_top}"
	ok(entry.contains("the " + token + " beneath them are what every road deals"),
		"§5: the glossary's modifier entry does not read its count through the door (`the %s beneath them`)" % token)
	# A COUNT WRITTEN AS A LITERAL (C07): the sentence's count is a word or a numeral typed into the words.
	var lit := RegEx.create_from_string("the (\\d+|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty) beneath them")
	ok(lit.search(entry) == null, "§5: the glossary's modifier entry writes its count as a literal (%s) — a count a door can compute belongs behind the door" % (lit.search(entry).get_string() if lit.search(entry) else ""))
	var n := 0
	for id in _run.MODIFIERS:
		var s := int(_run.modifier_severity(String(id)))
		if s >= 1 and s < int(_run.DIFFICULTIES["ruin"]["gamble_band"][0]):
			n += 1
	var has_count: bool = _run.has_method("figure_modifiers_dealt_beneath_top")
	var counted: Variant = _run.call("figure_modifiers_dealt_beneath_top") if has_count else null
	ok(has_count and int(counted) == n, "§5: the door counts %s, the deck holds %d beneath the top band" % [
		str(counted) if has_count else "nothing (Run declares no figure_modifiers_dealt_beneath_top)", n])
	var shown := String(Glossary.entry("modifier").get("long", ""))
	ok(shown.contains("the %d beneath them are what every road deals" % n) and not shown.contains("{="),
		"§5: the glossary's modifier entry, as a player reads it, does not say 'the %d beneath them'" % n)
	ok(Classes.figure_value("Run.figure_no_such_count") == null and Classes.figure_value("Run.modifier_severity") == null,
		"§5: the door reads a function that is not a `figure_` count (the shape a computed figure must take)")
	# THE BANDS ARE READ, NOT RE-SET (C08), AND THE STATE FILE SAYS WHAT EACH HOLDS.
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	for d in BANDS:
		var def: Dictionary = _run.DIFFICULTIES[d]
		ok(str(def["safe_band"]) == str(BANDS[d][0]) and str(def["gamble_band"]) == str(BANDS[d][1]),
			"§5: %s's bands read %s / %s — the bands are read, never re-set (%s / %s)" % [d, str(def["safe_band"]), str(def["gamble_band"]), str(BANDS[d][0]), str(BANDS[d][1])])
		for k in 2:
			var band: Array = BANDS[d][k]
			var held := 0
			for id in _run.MODIFIERS:
				var s := int(_run.modifier_severity(String(id)))
				if s >= int(band[0]) and s <= int(band[1]):
					held += 1
			var says := "%s's %s band (%d–%d) holds %d" % [String(def["name"]), "safe" if k == 0 else "gamble", int(band[0]), int(band[1]), held]
			ok(grades.contains(says), "§5: the state file's grades block does not report '%s'" % says)
	print("    CHECKED the door (%d beneath the top band), its words, a non-count refused, and six bands read" % n)
