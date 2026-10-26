# BATCH IV — THE SIM's OWN FIGURES, AND THE LAST OF THE PLUMBING.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS.
#   §1   THE BARGAIN's RUNE CACHE AND THE ORDER: (a) one door answers a cache, the player's screen and the sim alike —
#        a core rune held unworn, any other worn while a slot it fits is free; (b) DRIVEN through the sim's own victory
#        (`RunSim.on_battle_end`), every cache an elite and a bargain queue is answered and its rune is the hero's; (c)
#        the victory's order is the player's — the bargain claimed, the draft rolled, the cache rolled, the draft
#        answered, then the cache.
#   §1b  THE MERCHANT's DOORS, DRIVEN: a potion at its stack cap and a rune at a full holding are refused before the gold
#        moves, and each one the door allows is bought (the positive arms).
#   §1c  WHAT THE DRIVE SHOWED MOVED IS MARKED: every figure the kept drive table reads as moved stands marked
#        SUPERSEDED-PENDING in `docs/state.md`, with its delta and the batch that owes the re-take — until it is re-taken
#        (IW's re-take table; `check_iw` §3 holds the re-taken figure written and its mark gone).
#   §2   EVERY ENVIRONMENT READ IN THE GAME's SCRIPTS, ONE ROW EACH: the population is the table, every sim-family read
#        stands behind its guard, and DRIVEN, a player's run with every sim arm exported plays the game it drafted.
#   §3   THE FOUR REPAIRS, DRIVEN — the fallback bodies (DV11, on a Survivalist), the rotation's door (DV05, Guard Change
#        under Formless), the zone boss's cap (DV29, at the cap) — and the divergence census at RULE 0, a ceiling.
#   §4   THE CLAIMS: IR01, IR09 and IR50 repaired in place in IU's ledger; the two that stood on GK's names are repaired at
#        IW §0.1, so none stands (`check_iw` §0.1 holds their repair).
#   §5   THE INDEX QUESTION, CLOSED WHERE IT WAS QUEUED; THE PILOT ENDED; THE CLOSE-READ KEPT; THE STANDING LIST A CEILING.
#   §6   THE INDEX's POPULATION ROWS: every kind the derivation found has a row, each row names blocks that exist, and its
#        stamp reds when a member's block changes.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1's drive is one victory on a fixture party; it proves the doors and the
# order, never the size of what they move — that is the batch's paired drive (`docs/reports/IV.md` §1c), which no gate
# re-runs. §2 holds the reads the scripts make today and the guard each stands behind; it cannot tell a guard that is
# the wrong guard from a right one, only that the row's guard still stands. §1c holds the marks the kept table names;
# a figure the drive did not read is not in it. §6 holds the rows' shape and stamps, never that their kinds are right.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iv.gd
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
	print("BATCH IV — THE SIM's OWN FIGURES, AND THE LAST OF THE PLUMBING")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	await _s1_the_cache()
	await _s1b_the_merchant()
	_s1c_the_marks()
	await _s2_the_environment()
	await _s3_the_four()
	_s3b_the_census()
	_s4_the_claims()
	_s5_the_index_question()
	_s6_the_population_rows()
	for v in SIM_FAMILY_DRIVEN:
		OS.set_environment(String(v), "")
	_run.sim_run = false
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# A FILE READ ONCE, BY ITS FULL `res://` PATH — the path written at the call, so `build_pin_manifest.py` binds the holder
# off its initializer and every needle asserted against it is a pin (IU §6).
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


# ── §0 — THE RULINGS, EACH WHERE A FUTURE SESSION READS IT ─────────────────────
# Each needle is the ruling's own words, never its provenance (EA §2), in the file whose subject it binds.
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var cm := _flat(_doc("res://CLAUDE.md"))
	var ir := _flat(_doc("res://docs/instrument-rules.md"))
	var st := _flat(_doc("res://docs/state.md"))
	ok(cm.contains("THIS FILE TAKES NO INDEX, AND NOTHING IS STRUCK FROM IT"),
		"§0.1: CLAUDE.md does not say it takes no index — the derivation closed the question")
	ok(st.contains("AND IT ENDED AFTER THREE REPORTS (IS, IT, IU)"),
		"§0.1: docs/state.md's index does not say the pilot ended, and after how many reports")
	ok(ir.contains("A BATCH's WORK CHANGES WHAT THE FILE SAYS IS TRUE. READING THE FILE AGAINST THE FINISHED WORK IS HOW THE BATCH FINDS OUT"),
		"§0.1: the instrument rules do not keep the close-read as the batch's own obligation")
	ok(ir.contains("A RULE AND ITS OWN GATE ARE TWO DESCRIPTIONS OF ONE BEHAVIOUR. WHEN THEY DISAGREE, THE BEHAVIOUR IS THE ARBITER"),
		"§0.4: the instrument rules do not say the code decides between a rule and its gate")
	ok(cm.contains("A SIM-FAMILY FLAG IS READ BY A SIM ONLY"),
		"§2: CLAUDE.md does not say a sim-family flag is read by a sim only")
	ok(cm.contains("THE BOT ANSWERS WHAT A PLAYER ANSWERS, THROUGH THE SAME DOOR AND IN THE SAME ORDER"),
		"§1a: CLAUDE.md does not say the bot answers a cache through the player's door, in his order")
	ok(ir.contains("THE DIVERGENCE CENSUS's RULE COUNT IS A CEILING OF ZERO"),
		"§3: the instrument rules do not hold the bot's RULE rows to a ceiling of zero")
	ok(ir.contains("A KNOWN-MOVED FIGURE LEFT UNMARKED IS THE STALE CLAIM"),
		"§1c: the instrument rules do not say a figure a repair moved is marked until it is re-taken")
	ok(st.contains("A TRIGGER NAMES A SUBJECT. A BRIEF WHOSE SUBJECT IS A KIND OF THING MATCHES NO TRIGGER"),
		"§6: docs/state.md's index does not say why a kind gets a row of its own")


# ── §1 — THE BARGAIN's RUNE CACHE, AND THE ORDER ──────────────────────────────

# Every live ordinary rune of a class, by id — the fixture's way to fill a holding.
func _class_runes(key: String) -> Array:
	var out: Array = []
	for rid in Runes.ids():
		var cfg: Dictionary = Runes.config(String(rid))
		if Runes.is_retired(String(rid)) or Runes.is_engine_rune(String(rid)) or Runes.is_party_rune(cfg):
			continue
		if String(cfg.get("scope", "")) == "class:%s" % key:
			out.append(String(rid))
	return out


func _owned_names(m: Dictionary) -> Array:
	var out: Array = []
	for r in m.get("runes", []) + m.get("engines", []):
		out.append(String((r as Dictionary).get("name", "")))
	return out


func _s1_the_cache() -> void:
	print("\n§1 — the bargain's rune cache and the order: one door, answered, in the player's order")
	var rs := Gate.strip_comments(_doc("res://scripts/run_state.gd"))
	var ms := Gate.strip_comments(_doc("res://scripts/map_screen.gd"))
	var sim := Gate.strip_comments(_doc("res://scripts/run_sim.gd"))
	# (a) ONE DOOR. The screen answers through it and the sim answers through it; the screen keeps no second copy.
	var door := Gate.block(rs, rs.find("func take_rune_pick(member: Dictionary, rune_name: String) -> Dictionary:"))
	ok(door.contains("rune_choice(member)") and door.contains("hold_rune(member, rune)") and door.contains("rune[\"equipped\"] = String(rune.get(\"engine\", \"\")) == \"\""),
		"§1a: `Run.take_rune_pick` is not the door — it does not answer out of `rune_choice` and hold a core rune unworn through `hold_rune`")
	var screen := Gate.block(ms, ms.find("func _take_rune_pick(idx: int, rune_name: String) -> Dictionary:"))
	ok(screen.contains("Run.take_rune_pick(member, rune_name)") and not screen.contains("Run.hold_rune(") and not screen.contains("queue.pop_front()"),
		"§1a: the hero's screen does not answer a cache through `Run.take_rune_pick` — it keeps a second copy of the door")
	ok(sim.contains("run.take_rune_pick(m, ") and sim.contains("run.spend_rune_pick(m)") and not sim.contains("run.hold_rune(looter, rune)"),
		"§1a: the sim does not answer a cache through the player's door — it holds the rune itself")
	# The door, on its own: a core rune held unworn, an ordinary one worn while a slot is free, a name not offered refused.
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var war: Dictionary = _run.party[0]
	var ord_ids: Array = _class_runes("warrior").filter(func(rid): return Runes.offerable(String(rid), _run.held_engines(war)))
	var core_ids: Array = []
	for rid in Runes.ids():
		if Runes.is_engine_rune(String(rid)) and String(Runes.config(String(rid)).get("scope", "")) == "class:warrior" \
				and not _owned_names(war).has(String(Runes.config(String(rid)).get("name", ""))):
			core_ids.append(String(rid))
	ok(ord_ids.size() >= 2 and core_ids.size() >= 1, "§1a: the fixture found %d ordinary and %d core Warrior runes" % [ord_ids.size(), core_ids.size()])
	if ord_ids.size() >= 2 and core_ids.size() >= 1:
		var trip: Array = [Runes.build(String(core_ids[0])), Runes.build(String(ord_ids[0]))]
		_run.queue_rune_pick(war, trip)
		var refused: Dictionary = _run.take_rune_pick(war, "no such rune")
		ok(refused.is_empty() and int(war.get("rune_picks_owed", 0)) == 1,
			"§1a: the door answered a name its live list does not hold")
		var core_name := String((trip[0] as Dictionary)["name"])
		var took: Dictionary = _run.take_rune_pick(war, core_name)
		ok(not took.is_empty() and String(took.get("landed", "")) == "held" and not bool((took.get("rune", {}) as Dictionary).get("equipped", true)),
			"§1a: a core rune taken from a cache was not held unworn (landed '%s') — one pick hands over one thing (HL §1)" % String(took.get("landed", "")))
		ok(int(war.get("rune_picks_owed", 0)) == 0 and (war.get("rune_candidates", []) as Array).is_empty(),
			"§1a: the door did not spend the triple it answered and pay the owed pick")
		_run.queue_rune_pick(war, [Runes.build(String(ord_ids[1]))])
		var took2: Dictionary = _run.take_rune_pick(war, String(Runes.config(String(ord_ids[1])).get("name", "")))
		ok(String(took2.get("landed", "")) == "worn", "§1a: an ordinary rune taken with a slot free was not worn (landed '%s')" % String(took2.get("landed", "")))
	scene.queue_free()
	await process_frame
	# (b) DRIVEN THROUGH THE SIM's OWN VICTORY: an elite won under a bargain that pays a rune. Every pick the two queue is
	# answered before the walk, and the runes are the heroes'.
	var scene2: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	_run.sim_run = true
	_run.encounter = {"type": "elite", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
	_run.pending_reward = {"kind": "rune"}
	var held_before := 0
	for m in _run.party:
		held_before += _owned_names(m).size()
		m["rune_picks_owed"] = 0
		m["rune_candidates"] = []
	var b0 := int(RunSim.rune_bargain_offered)
	var t0 := int(RunSim.rune_bargain_taken) + int(RunSim.rune_elite_taken) + int(RunSim.rune_picks_spent)
	var e0 := int(RunSim.rune_elite_offered)
	# The victory ends in the sim's walk and `reload_current_scene()`, which prints one engine ERROR here — the fixture
	# made no scene current — and is no SCRIPT ERROR, the line the battery counts.
	RunSim.on_battle_end(_run, scene2, true)
	var owed := 0
	var held_after := 0
	for m in _run.party:
		owed += int(m.get("rune_picks_owed", 0))
		held_after += _owned_names(m).size()
	var queued := (int(RunSim.rune_bargain_offered) - b0) + (1 if int(RunSim.rune_elite_offered) > e0 else 0)
	var answered := int(RunSim.rune_bargain_taken) + int(RunSim.rune_elite_taken) + int(RunSim.rune_picks_spent) - t0
	ok(queued == 2, "§1a: the drive's victory queued %d caches, not the bargain's and the elite's — the drive did not reach its subject" % queued)
	ok(owed == 0 and answered == queued,
		"§1a: THE DRIVE — the sim's victory left %d rune picks owed and answered %d of the %d its bargain and its elite queued: a run's rune supply is short of the player's" % [owed, answered, queued])
	var taken := int(RunSim.rune_bargain_taken) + int(RunSim.rune_elite_taken) + int(RunSim.rune_picks_spent) - t0
	ok(held_after >= held_before + taken - (int(RunSim.rune_picks_spent)),
		"§1a: the answered caches' runes are not the heroes' (%d runes held before, %d after, %d answered)" % [held_before, held_after, taken])
	_run.sim_run = false
	scene2.queue_free()
	await process_frame
	# (c) THE ORDER, read where it is written: the victory's body claims the bargain, rolls every draft, rolls the cache,
	# then answers the draft and then the cache — `battle._check_end`'s order and the hero's screen's.
	var obe := Gate.block(sim, sim.find("static func on_battle_end(run: Node, battle, victory: bool) -> void:"))
	var at_claim := obe.find("run.claim_reward()")
	var at_roll := obe.find("_roll_draft(run, d_m)")
	var at_cache := obe.find("run.roll_rune_candidates(looter)")
	var at_take := obe.find("_award_draft(run, d_m)")
	var at_ans := obe.find("_answer_rune_picks(run, answering)")
	ok(at_claim > 0 and at_roll > at_claim and at_cache > at_roll and at_take > at_cache and at_ans > at_take,
		"§1a: THE ORDER — the sim's victory does not claim, roll the draft, roll the cache, answer the draft and then the cache (%d, %d, %d, %d, %d)" % [at_claim, at_roll, at_cache, at_take, at_ans])
	ok(obe.count("_answer_rune_picks(") == 1 and obe.count("run.hold_rune(") == 0,
		"§1a: the victory must answer a cache once and hold no rune itself — it calls the answer %d time(s) and `run.hold_rune(` %d time(s)" % [
			obe.count("_answer_rune_picks("), obe.count("run.hold_rune(")])
	print("    CHECKED the door (3 answers), one victory driven (%d caches queued, %d answered, %d left owed), and the order" % [queued, answered, owed])


# ── §1b — THE MERCHANT's DOORS ───────────────────────────────────────────────

func _fill_worn(m: Dictionary, n: int) -> void:
	var ids := _class_runes(String(m["key"]))
	var worn: Array = []
	for i in mini(n, ids.size()):
		var r: Dictionary = Runes.build(String(ids[ids.size() - 1 - i]))
		r["equipped"] = true
		worn.append(r)
	m["runes"] = worn


func _s1b_the_merchant() -> void:
	print("\n§1b — the merchant's doors: asked before the gold moves")
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	_run.sim_run = true
	var heal: int = RunSim._price(_run, int(_run.ITEM_PRICES["health"]))
	var cap: int = _run.item_stack_cap("health")
	# THE POTION: every hero's slots worn (no rune on the counter for anyone), the pouch full (no restock), one hero
	# hurt, and the gold for exactly one potion over the reserve.
	for m in _run.party:
		_fill_worn(m, _run.rune_slots())
	_run.items = {"health": cap, "mana": 1, "bomb": 1, "revive": 1}
	_run.party[0]["hp"] = 1
	_run.gold = heal + RunSim.GOLD_RESERVE
	var g0: int = _run.gold
	RunSim._shop_visit(_run)
	ok(_run.gold == g0 and int(_run.items["health"]) == cap,
		"§1b: THE GOLD MOVED WHERE THE DOOR REFUSES — a potion bought at its stack cap of %d cost %d gold and landed nothing" % [cap, g0 - _run.gold])
	_run.items["health"] = cap - 1
	_run.gold = g0
	RunSim._shop_visit(_run)
	ok(_run.gold == g0 - heal and int(_run.items["health"]) == cap,
		"§1b: a potion the door allows (a stack under its cap) was not bought — the arm above proves nothing")
	# THE RUNE: the Warrior holds a full holding unworn and has a free slot; every other hero's slots are worn, so
	# the counter rolls for him alone. **AND THE BAG IS FULL TOO**: the Peddler can roll him a crest rune, which goes
	# to the bag and which a full holding does not refuse — so with the bag left empty this arm read the draw order
	# the sections above it left (IV's controls found it: C01 and R01 red it, the base did not). Full holding and full
	# bag, the door refuses whatever he is offered and no gold moves; with room in both he buys.
	var war: Dictionary = _run.party[0]
	war["hp"] = war["max_hp"]
	var ids := _class_runes("warrior")
	var held: Array = []
	for i in mini(int(_run.HERO_HOLD_CAP), ids.size()):
		var r: Dictionary = Runes.build(String(ids[i]))
		r["equipped"] = false
		held.append(r)
	war["runes"] = held
	var bag_fill: Array = []
	for rid in _class_runes("mage"):
		if bag_fill.size() < int(_run.BAG_CAP):
			bag_fill.append(Runes.build(String(rid)))
	_run.rune_bag = bag_fill
	_run.gold = 1000
	var g1: int = _run.gold
	var r_room0 := int(RunSim.rune_refused_room)
	RunSim._shop_visit(_run)
	ok(held.size() == int(_run.HERO_HOLD_CAP) and _run.bag_full(),
		"§1b: the fixture filled a holding of %d of %d and a bag of %d of %d" % [held.size(), int(_run.HERO_HOLD_CAP), (_run.rune_bag as Array).size(), int(_run.BAG_CAP)])
	ok(_run.gold == g1 and (war["runes"] as Array).size() == held.size(),
		"§1b: THE GOLD MOVED WHERE THE DOOR REFUSES — a rune bought for a hero holding %d unworn, the bag full, cost %d gold" % [held.size(), g1 - _run.gold])
	ok(int(RunSim.rune_refused_room) > r_room0, "§1b: the counter's refusal for want of room was not booked as the door's")
	war["runes"] = held.slice(0, held.size() - 2)
	_run.rune_bag = []
	_run.gold = g1
	RunSim._shop_visit(_run)
	ok(_run.gold < g1, "§1b: a rune the door allows (a holding and a bag with room) was not bought — the arm above proves nothing")
	# AND THE FALSE SENTENCE IS GONE: the gold is spent either way was true of the bot alone.
	ok(not _doc("res://scripts/run_sim.gd").contains("the gold is spent\n\t\t\t# either way"),
		"§1b: run_sim.gd still says the refused potion's gold is spent either way")
	_run.sim_run = false
	scene.queue_free()
	await process_frame
	print("    CHECKED the potion's door both ways and the rune counter's door both ways")


# ── §1c — WHAT THE DRIVE SHOWED MOVED IS MARKED ──────────────────────────────
# THE KEPT TABLE (docs/reports/IV-drive.tsv) is the paired drive's every figure, A (HEAD) against B (IV), with its verdict —
# a cut inside two standard errors is a tie (IP §0.4). Every row the table reads as MOVES and whose figure a document records
# names its mark, and the mark stands in `docs/state.md`: a known-moved figure left unmarked is the stale claim this project
# spent ten batches retiring.
const DRIVE_TABLE := "docs/reports/IV-drive.tsv"
# THE RE-TAKES (BATCH IW §3): a figure re-taken is no longer pending, so its mark goes with the re-take and the figure IW took
# stands where the record stood — `check_iw` §3 holds both; this section holds the marks of the rest.
const RETAKE_TABLE := "docs/reports/IW-retake.tsv"


func _s1c_the_marks() -> void:
	print("\n§1c — what the drive showed moved is marked superseded-pending")
	var rows := _tsv("res://" + DRIVE_TABLE, ["arm", "figure", "A", "B", "d", "z", "verdict", "recorded", "mark"])
	var st := _flat(_doc("res://docs/state.md"))
	var retaken := {}
	for t in _tsv("res://" + RETAKE_TABLE, ["arm", "figure"]):
		retaken["%s|%s" % [t["arm"], t["figure"]]] = true
	var retook := 0
	var moved := 0
	var marked := 0
	var unmarked: Array = []
	var bad: Array = []
	for r in rows:
		var v := String(r["verdict"])
		if not ["MOVES", "tie", "—"].has(v):
			bad.append("%s %s" % [r["arm"], r["figure"]])
			continue
		var z := float(r["z"])
		if (v == "MOVES") != (z > 2.0):
			bad.append("%s %s reads %s at |d|/se %.2f" % [r["arm"], r["figure"], v, z])
		if v != "MOVES" or String(r["recorded"]) == "":
			continue
		if retaken.has("%s|%s" % [r["arm"], r["figure"]]):
			retook += 1
			continue
		moved += 1
		var mk := _flat(String(r["mark"]))
		if mk.length() < 12 or not st.contains(mk) or not mk.contains("SUPERSEDED-PENDING"):
			unmarked.append("%s %s" % [r["arm"], r["figure"]])
		else:
			marked += 1
	ok(rows.size() >= 40, "§1c: the drive table holds %d rows — the drive read every default-sim figure it names" % rows.size())
	ok(bad.is_empty(), "§1c: %d rows' verdicts disagree with their noise (a cut inside two standard errors is a tie): %s" % [bad.size(), str(bad)])
	ok(moved + retook > 0, "§1c: the drive table holds no recorded figure that moved — the marks' population is empty, so the arm below proves nothing")
	ok(unmarked.is_empty(),
		"§1c: %d recorded figures the drive shows moved stand unmarked in docs/state.md — a known-moved figure is SUPERSEDED-PENDING with its delta and the batch that owes the re-take: %s" % [unmarked.size(), str(unmarked)])
	print("    CHECKED %d drive rows: %d recorded figures moved — %d re-taken at IW, %d of the rest marked superseded-pending" % [rows.size(), moved + retook, retook, marked])


# ── §2 — EVERY ENVIRONMENT READ, ONE ROW EACH ─────────────────────────────────
# THE POPULATION IS THE TABLE: every `OS.get_environment` read in `scripts/`, comment-stripped, keyed by its file, its
# function and its variable, with how many times that function reads it. **A SIM-FAMILY READ (`DOD_SIM*`) IS REACHED BY
# A SIM ONLY** — its row names the guard it stands behind (a needle that must stand in its function's body) or the sim
# path it lives on; **A NON-SIM SWITCH** is a row with its reason. A read nobody sorted reds, and so does a sorted one
# whose guard has gone (DV32's two were the exceptions, and the sweep found three more beside them).
const ENV_ROWS := {
	"battle.gd|_ready|DOD_SIM": [1, "SWITCH", "", "the sim's own switch: it makes this process a standalone sim"],
	"battle.gd|_ready|DOD_SIM_RUN": [2, "SWITCH", "", "the sim's own switch: it makes this process a run sim (RunSim.begin)"],
	"battle.gd|_ready|DOD_SIM_SWEEP": [1, "GATED", "sweep = sim_target > 0 and OS.get_environment(\"DOD_SIM_SWEEP\")", "read only by a standalone sim"],
	"battle.gd|_ready|DOD_SIM_RELICS": [2, "GATED", "if sim and not run_sim and OS.get_environment(\"DOD_SIM_RELICS\")", "a standalone sim's relic loadout (IV §2: a player's fight read it)"],
	"battle.gd|_ready|DOD_SIM_GRANT_ALL": [1, "GATED", "if sim and OS.get_environment(\"DOD_SIM_GRANT_ALL\")", "a sim's full kit (IV §2, DV32: it armed the player's debug toggle)"],
	"battle.gd|_ready|DOD_SIM_DEBUG": [1, "GATED", "or (sim and OS.get_environment(\"DOD_SIM_DEBUG\")", "a sim's combat-log echo"],
	"battle.gd|_ready|DOD_AUTOPLAY": [1, "NONSIM", "", "a harness switch every fixture sets: the bot plays a battle, which a player watching sees"],
	"battle.gd|_ready|DOD_ENEMIES_OFF": [1, "NONSIM", "", "arms the battle's debug toggle (Enemy attacks OFF); the readout names it in force (IH §0.2)"],
	"battle.gd|_spawn_units|DOD_SIM_SPECS": [1, "GATED", "\"\" if Run.active else OS.get_environment(\"DOD_SIM_SPECS\")", "a bot battle outside a run"],
	"battle.gd|_spawn_units|DOD_SIM_ROTATE": [1, "GATED", "if not Run.active and OS.get_environment(\"DOD_SIM_ROTATE\")", "a bot battle outside a run"],
	"battle.gd|_spawn_units|DOD_SIM_TALENTS": [1, "GATED", "elif autoplay and spec != \"\":", "a bot hero outside a run (the branch after `if Run.active`)"],
	"battle.gd|_spawn_units|DOD_SIM_ABILITIES": [1, "GATED", "elif autoplay and spec != \"\":", "a bot hero outside a run (the branch after `if Run.active`)"],
	"battle.gd|_spawn_units|DOD_SIM_ENEMIES": [1, "GATED", "OS.get_environment(\"DOD_SIM_ENEMIES\") if sim_hooks else \"\"", "a sim's or a bot battle's lineup (IV §2: it replaced a real run's)"],
	"battle.gd|_spawn_units|DOD_SIM_THEME": [1, "GATED", "OS.get_environment(\"DOD_SIM_THEME\") if sim_hooks else \"\"", "a sim's or a bot battle's lineup (IV §2: it replaced a real run's)"],
	"battle.gd|_spawn_units|DOD_SIM_ZONE": [4, "GATED", "elif env_theme != \"\":", "under the sweep's branch or the theme's, which a real run never reaches"],
	"battle.gd|_spawn_units|DOD_SIM_BUDGET": [2, "GATED", "elif env_theme != \"\":", "under the theme's branch, which a real run never reaches"],
	"battle.gd|_print_sim_report|DOD_SIM_THEME": [2, "SIMPATH", "_print_sim_report()", "the standalone sim's report"],
	"battle.gd|_print_sim_report|DOD_SIM_BUDGET": [1, "SIMPATH", "_print_sim_report()", "the standalone sim's report"],
	"battle.gd|_print_sim_report|DOD_SIM_ZONE": [1, "SIMPATH", "_print_sim_report()", "the standalone sim's report"],
	"battle.gd|_print_sweep_report|DOD_SIM_ZONE": [1, "SIMPATH", "_print_sweep_report()", "the sweep's report"],
	"battle.gd|_print_sweep_report|DOD_SIM_THEME": [1, "SIMPATH", "_print_sweep_report()", "the sweep's report"],
	"battle.gd|_print_sweep_report|DOD_SIM_SPECS": [1, "SIMPATH", "_print_sweep_report()", "the sweep's report"],
	"battle.gd|_print_sweep_report|DOD_SIM_ROTATE": [1, "SIMPATH", "_print_sweep_report()", "the sweep's report"],
	"battle.gd|_share_line|DOD_SIM_ROTATE": [1, "SIMPATH", "_share_line(", "a line of the sweep's report"],
	"run_state.gd|readout_wanted|DOD_READOUT": [1, "NONSIM", "", "the readout's own switch (IF §1): the readout moves no figure, so it is the player's"],
	"run_state.gd|debug_enabled|DOD_DEBUG": [1, "NONSIM", "", "the debug gate itself: every use trips debug_used and names itself to the readout"],
	"run_state.gd|rune_econ|DOD_SIM_RUNE_ECON": [1, "GATED", "if not sim_run:", "a run sim's arm (AD)"],
	"run_state.gd|rune_power|DOD_SIM_RUNE_POWER": [1, "GATED", "if not sim_run:", "a run sim's arm (AD)"],
	"run_state.gd|runes_mode|DOD_SIM_RUNES": [1, "GATED", "if not sim_run:", "a run sim's arm (IV §2, DV32: a player's run read it)"],
	"run_state.gd|rotation_enabled|DOD_ZONE_ROTATION": [1, "GATED", "return sim_run and OS.get_environment(\"DOD_ZONE_ROTATION\")", "the sim's since IW §0.3 (a flag that changes what a run contains is the sim's) — a player's run draws each pool's first zone (the latent arm below)"],
}
# The variables §2's drive exports into a player's run, and clears after.
const SIM_FAMILY_DRIVEN := ["DOD_SIM_RUNES", "DOD_SIM_GRANT_ALL", "DOD_SIM_RELICS", "DOD_SIM_ENEMIES", "DOD_SIM_THEME", "DOD_SIM_DEBUG"]


func _env_population() -> Dictionary:
	var out := {}
	var rx := RegEx.new()
	rx.compile("OS\\.(?:get|has)_environment\\(\"([A-Z0-9_]+)\"\\)")
	var fn := RegEx.new()
	fn.compile("^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for f in DirAccess.get_files_at("res://scripts"):
		if not String(f).ends_with(".gd"):
			continue
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		var cur := "(file)"
		for line in src.split("\n"):
			var fm := fn.search(line)
			if fm != null:
				cur = fm.get_string(1)
			for m in rx.search_all(line):
				var key := "%s|%s|%s" % [f, cur, m.get_string(1)]
				out[key] = int(out.get(key, 0)) + 1
	return out


# THE POPULATION's OWN SHAPE: every call that reads the environment, literal name or not. A read through a computed
# name is one the table above cannot key, so it reds as its own shape rather than passing unseen.
func _env_calls() -> Array:
	var calls := 0
	var named := 0
	var rx := RegEx.new()
	rx.compile("OS\\.(?:get|has)_environment\\(\"([A-Z0-9_]+)\"\\)")
	for f in DirAccess.get_files_at("res://scripts"):
		if not String(f).ends_with(".gd"):
			continue
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		calls += src.count("get_environment(") + src.count("has_environment(")
		named += rx.search_all(src).size()
	return [calls, named]


func _s2_the_environment() -> void:
	print("\n§2 — every environment read in the game's scripts, one row each")
	var pop := _env_population()
	var shape := _env_calls()
	ok(int(shape[0]) == int(shape[1]) and int(shape[0]) > 0,
		"§2: %d calls read the environment and %d of them name their variable as a literal — a read through a computed name is one no row can key" % [shape[0], shape[1]])
	var unsorted: Array = []
	var miscount: Array = []
	var unguarded: Array = []
	var sim_family := 0
	var gated := 0
	for key in pop:
		if not ENV_ROWS.has(key):
			unsorted.append("%s ×%d" % [key, pop[key]])
			continue
		var row: Array = ENV_ROWS[key]
		if int(row[0]) != int(pop[key]):
			miscount.append("%s reads %d, its row says %d" % [key, pop[key], row[0]])
	var gone: Array = []
	for key in ENV_ROWS:
		if not pop.has(key):
			gone.append(key)
			continue
		var row: Array = ENV_ROWS[key]
		var parts := String(key).split("|")
		var var_name := parts[2]
		var src := Gate.strip_comments(_doc("res://scripts/" + parts[0]))
		var at := src.find("func %s(" % parts[1])
		var body := Gate.block(src, at) if at >= 0 else ""
		if var_name.begins_with("DOD_SIM"):
			sim_family += 1
		match String(row[1]):
			"GATED":
				if not body.contains(String(row[2])):
					unguarded.append("%s — its guard `%s` is gone" % [key, row[2]])
				else:
					gated += 1
			"SIMPATH":
				# A report or a line of one: called from one place, the sim's end of count, and nowhere else.
				var calls := src.count(String(row[2])) - (1 if src.contains("func " + String(row[2])) else 0)
				var tail := src.find("var total_target := sim_target")
				if calls < 1 or tail < 0 or (String(row[2]).ends_with("()") and src.find(String(row[2]), tail) < 0):
					unguarded.append("%s — its sim path `%s` is not reached from the sim's end of count" % [key, row[2]])
				else:
					gated += 1
			"SWITCH", "NONSIM":
				if var_name.begins_with("DOD_SIM") and String(row[1]) == "NONSIM":
					unguarded.append("%s — a sim-family flag sorted as a non-sim switch" % key)
	# RunSim's own reads: every one is on the sim's path, entered only through the battle's run-sim branch.
	var rs_reads := 0
	for key in pop:
		if String(key).begins_with("run_sim.gd|"):
			rs_reads += int(pop[key])
	var bsrc := Gate.strip_comments(_doc("res://scripts/battle.gd"))
	ok(bsrc.contains("if run_sim and not RunSim.active:") and bsrc.contains("run_sim = int(OS.get_environment(\"DOD_SIM_RUN\")) > 0"),
		"§2: RunSim is entered somewhere besides the battle's run-sim branch — its reads are no longer the sim's alone")
	var unsorted_rs := unsorted.filter(func(x): return String(x).begins_with("run_sim.gd|"))
	unsorted = unsorted.filter(func(x): return not String(x).begins_with("run_sim.gd|"))
	ok(rs_reads >= 15 and unsorted_rs.size() == pop.keys().filter(func(k): return String(k).begins_with("run_sim.gd|")).size(),
		"§2: RunSim's reads (%d) are read as rows — they are the sim's path, one block" % rs_reads)
	ok(unsorted.is_empty(), "§2: %d environment reads nobody sorted — a new arm, read with no row: %s" % [unsorted.size(), str(unsorted)])
	ok(miscount.is_empty(), "§2: %d rows read a variable a different number of times than the row says: %s" % [miscount.size(), str(miscount)])
	ok(gone.is_empty(), "§2: %d rows name a read the scripts no longer make — delete them: %s" % [gone.size(), str(gone)])
	ok(unguarded.is_empty(), "§2: %d sim-family reads stand behind no guard — a sim's arm leaks into a player's game: %s" % [unguarded.size(), str(unguarded)])
	# THE LATENT ARM: since IW §0.3 the rotation is the sim's, so a player's run draws each slot pool's first zone — and a
	# pool of two holds a zone no player can draw, which is owed its door the day it is authored.
	var pools: Array = _run.SLOT_POOLS
	var multi: Array = pools.filter(func(p): return (p as Array).size() > 1)
	ok(multi.is_empty(),
		"§2: a slot pool holds %d zones — a player's run takes each pool's first (`DOD_ZONE_ROTATION` is the sim's since IW §0.3), so the second is a zone no player can draw; the draw a player gets is owed its door before the pool ships" % (multi[0] as Array).size() if not multi.is_empty() else "")
	# DRIVEN: a player's run with every sim-family arm exported plays the game it drafted.
	OS.set_environment("DOD_SIM_RUNES", "stats")
	OS.set_environment("DOD_SIM_GRANT_ALL", "1")
	OS.set_environment("DOD_SIM_RELICS", "hourglass")
	OS.set_environment("DOD_SIM_ENEMIES", "chief,chief")
	OS.set_environment("DOD_SIM_THEME", "")
	OS.set_environment("DOD_SIM_DEBUG", "1")
	_run.debug_grant_all = false
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var kinds: Array = []
	for e in scene.get("enemies"):
		kinds.append(String(e.get("enemy_kind")))
	ok(not _run.debug_grant_all, "§2: DRIVEN — `DOD_SIM_GRANT_ALL=1` armed a player's debug grant")
	ok(not (_run.active_relics as Array).has("hourglass"), "§2: DRIVEN — `DOD_SIM_RELICS` replaced a player's relics with %s" % str(_run.active_relics))
	ok(kinds == ["raider", "raider", "archer"], "§2: DRIVEN — `DOD_SIM_ENEMIES` replaced a real run's warband with %s" % str(kinds))
	ok(String(_run.runes_mode()) == "full", "§2: DRIVEN — `DOD_SIM_RUNES=stats` reached a player's run")
	ok(not bool(scene.get("debug_prints")), "§2: DRIVEN — `DOD_SIM_DEBUG` echoes a player's combat log")
	# AND THE ARMS STILL ARM UNDER THE SIM (the positive arm): the flag read once a sim runs.
	_run.sim_run = true
	ok(String(_run.runes_mode()) == "stats", "§2: under the sim `DOD_SIM_RUNES=stats` no longer arms — the gate shut the sim's arm too")
	_run.sim_run = false
	for v in SIM_FAMILY_DRIVEN:
		OS.set_environment(String(v), "")
	scene.queue_free()
	await process_frame
	print("    CHECKED %d reads in %d rows (%d sim-family, %d behind a guard or on the sim's path) and RunSim's %d; one player's run driven with six arms exported" % [
		pop.values().reduce(func(a, b): return a + b, 0), ENV_ROWS.size(), sim_family, gated, rs_reads])


# ── §3 — THE FOUR REPAIRS, DRIVEN ────────────────────────────────────────────

func _s3_the_four() -> void:
	print("\n§3 — the four repairs, driven")
	# DV11 — A SURVIVALIST's SHRAPNEL CHARGE, THE BOT's PATH (no second click): both bodies it strikes are poisoned.
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "mystic"], {"deterministic": true})
	var hunter: BattleUnit = scene.get("heroes")[3]
	var foes: Array = (scene.get("enemies") as Array).filter(func(e): return not e.dead)
	var shrap: Ability = Classes.pool_ability("Shrapnel Charge")
	ok(hunter.has_engine("trapper") and shrap != null and shrap.choose_two and foes.size() >= 3,
		"§3: the DV11 drive needs a Survivalist holding Trapper (%s), a choose-two Shrapnel Charge (%s) and three foes (%d)" % [
			hunter.has_engine("trapper"), shrap != null and shrap.choose_two, foes.size()])
	if shrap != null and foes.size() >= 2:
		for e in foes:
			e.statuses.clear()
			e.max_hp = 99999
			e.hp = 99999
		scene.set("second_target", null)
		scene.set("third_target", null)
		await scene._resolve(hunter, shrap, foes[0], "good")
		var poisoned := 0
		for e in foes:
			if e.has_status("poison"):
				poisoned += 1
		ok(poisoned == 2, "§3: DV11 — the bot's Shrapnel Charge poisoned %d of the two bodies it struck: the fallback body was not written back" % poisoned)
	scene.queue_free()
	await process_frame
	# DV05 — THE ROTATION ASKS THE DOOR: a Swordmaster out of the guard he wants, Guard Change ready, under Formless.
	var sc2: Node = await Gate.spawn(self, ["swordmaster", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var sm: BattleUnit = sc2.get("heroes")[0]
	var gc: Ability = null
	for a in sm.abilities:
		if a.display_name == "Guard Change":
			gc = a
	ok(gc != null and sm.has_engine("seasoned"), "§3: the DV05 drive needs a Swordmaster holding Guard Change (%s) and the Stances (%s)" % [gc != null, sm.has_engine("seasoned")])
	if gc != null:
		sm.cooldowns.clear()
		sm.hp = sm.max_hp
		sm.stance = "defensive"
		sm.statuses.erase("formless")
		var free_pick: Array = sc2._autoplay_pick(sm)
		ok(not free_pick.is_empty() and free_pick[0] == gc,
			"§3: DV05's drive does not construct its arm — out of the guard he wants, the rotation did not pick Guard Change (it picked %s)" % (free_pick[0].display_name if not free_pick.is_empty() else "nothing"))
		sc2._apply_status(sm, "formless", 4, 0, 0, sm)
		ok(not sc2._ability_usable(sm, gc), "§3: under Formless the player's door does not refuse Guard Change — the drive's premise is gone")
		var fl_pick: Array = sc2._autoplay_pick(sm)
		ok(not fl_pick.is_empty() and fl_pick[0] != gc,
			"§3: DV05 — under Formless the rotation still cast Guard Change, where the player's button is dark: the rotation's pick does not ask the door")
	sc2.queue_free()
	await process_frame
	# DV29 — THE ZONE BOSS's PICK ASKS THE CAP: every hero at the cap when the award is taken stays at it.
	var sc3: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var at_cap := 0
	for m in _run.party:
		var pool: Array = Classes.draft_pool(String(m["key"]))
		var filled: Array = []
		for card in pool:
			if _run.ability_slots_full(m):
				break
			if not _run.owned_ability_names(m).has(String(card)):
				_run.hold_ability(m, String(card), true)
				filled.append(card)
		if _run.ability_slots_full(m):
			at_cap += 1
	var taken0 := int(RunSim.ability_taken)
	RunSim._award_trophies(_run)
	var over: Array = []
	for m in _run.party:
		if _run.ability_slots_used(m) > _run.ability_slot_cap():
			over.append("%s %d of %d" % [m["key"], _run.ability_slots_used(m), _run.ability_slot_cap()])
	ok(at_cap == 4 and int(RunSim.ability_taken) > taken0,
		"§3: DV29's drive does not construct its state — %d heroes at the cap, %d awards taken" % [at_cap, int(RunSim.ability_taken) - taken0])
	ok(over.is_empty(), "§3: DV29 — the zone boss's pick took a hero past the cap: %s" % str(over))
	sc3.queue_free()
	await process_frame
	print("    CHECKED DV11 on a Survivalist, DV05 on Guard Change under Formless (both arms), DV29 at the cap (%d heroes)" % at_cap)


# ── §3b — THE DIVERGENCE CENSUS AT RULE 0, A CEILING ─────────────────────────
# IU's census of record, amended in place (IS §3b's rule): every row CLOSED, POLICY or MODEL, a CLOSED row naming the batch that
# closed it, a POLICY its reason, a MODEL the bot standing in for the player's hands — and the RULE count a ceiling of zero.
const DIVERGENCE := "docs/reports/IU-bot-divergence.tsv"
const RULE_CEILING := 0
const IV_CLOSED := ["DV05", "DV06", "DV07", "DV11", "DV24", "DV25", "DV26", "DV27", "DV29", "DV32"]


func _s3b_the_census() -> void:
	print("\n§3b — the divergence census at RULE 0")
	var rows := _tsv("res://" + DIVERGENCE, ["id", "sort", "reason", "iu_disposition", "tree"])
	var tally := {}
	var rules: Array = []
	var nameless: Array = []
	var reasonless: Array = []
	var unnamed_model: Array = []
	var iv_closed := 0
	for r in rows:
		var cid := String(r["id"])
		var srt := String(r["sort"])
		var disp := String(r["iu_disposition"])
		tally[srt] = int(tally.get(srt, 0)) + 1
		if srt == "RULE":
			rules.append(cid)
		elif srt == "CLOSED":
			if not (disp.contains("REPAIRED AT IU") or disp.contains("REPAIRED AT IV") or disp.contains("verified closed")):
				nameless.append(cid)
			if IV_CLOSED.has(cid) and disp.contains("REPAIRED AT IV"):
				iv_closed += 1
		elif srt == "POLICY" and String(r["reason"]).strip_edges().length() < 20:
			reasonless.append(cid)
		elif srt == "MODEL" and not disp.contains("standing in for the player"):
			unnamed_model.append(cid)
	ok(rows.size() >= 33, "§3b: the census holds %d rows — IU's read 33" % rows.size())
	ok(rules.size() <= RULE_CEILING,
		"§3b: THE CEILING AT ZERO — %d rows sort the bot playing by a different rule, and a RULE row is repaired in the batch that finds it, never recorded: %s" % [rules.size(), str(rules)])
	ok(iv_closed == IV_CLOSED.size(), "§3b: %d of the ten IV repaired are closed in the census with IV named" % iv_closed)
	ok(nameless.is_empty(), "§3b: %d CLOSED rows name no batch that closed them: %s" % [nameless.size(), str(nameless)])
	ok(reasonless.is_empty(), "§3b: %d POLICY rows carry no reason: %s" % [reasonless.size(), str(reasonless)])
	ok(unnamed_model.is_empty(), "§3b: %d MODEL rows are not named a stand-in: %s" % [unnamed_model.size(), str(unnamed_model)])
	print("    CHECKED %d rows: RULE %d (ceiling %d), POLICY %d, MODEL %d, CLOSED %d (%d of them IV's)" % [
		rows.size(), rules.size(), RULE_CEILING, tally.get("POLICY", 0), tally.get("MODEL", 0), tally.get("CLOSED", 0), iv_closed])


# ── §4 — THE CLAIMS ───────────────────────────────────────────────────────────
# IU's ledger of record, amended in place: IR01's qualification folded into its sentence, IR09's and IR50's sentence made
# HY §6's rule — each REPAIRED, its false words gone and its true ones found; GK's names (ISN04, ISF12) stand on GK's ruling,
# and the spine report the designer asked for is in IV's report.
const LEDGER := "docs/reports/IU-claims.tsv"


func _s4_the_claims() -> void:
	print("\n§4 — the claims: three repaired in place, and none standing since IW §0.1")
	var rows := _tsv("res://" + LEDGER, ["id", "file", "disposition", "stands", "gone", "tree"])
	var by := {}
	for r in rows:
		by[String(r["id"])] = r
	var ir := _doc("res://docs/instrument-rules.md")
	for cid in ["IR01", "IR09", "IR50"]:
		var r: Dictionary = by.get(cid, {})
		var gone := String(r.get("gone", "")).replace("\\n", "\n")
		var stands := String(r.get("stands", "")).replace("\\n", "\n")
		ok(String(r.get("disposition", "")) == "REPAIRED" and String(r.get("tree", "")).contains("IV"),
			"§4: %s is not repaired in the ledger, in place, with IV named" % cid)
		ok(gone != "" and not ir.contains(gone) and stands != "" and ir.contains(stands),
			"§4: %s's false words must be gone and its true ones present in the instrument rules — false words found: %s, true words found: %s" % [
				cid, gone != "" and ir.contains(gone), stands != "" and ir.contains(stands)])
	var standing: Array = []
	for r in rows:
		if String(r["disposition"]) == "STANDS":
			standing.append(String(r["id"]))
	standing.sort()
	ok(standing.is_empty(), "§4: the claims left standing are %s — GK's two names were the last, and IW §0.1 confirmed them, so none waits on a ruling" % str(standing))
	var rep := _doc("res://docs/reports/IV.md")
	for nm in ["Rune of the Vanguard", "Rune of the Invoker", "Rune of the Hierophant"]:
		ok(rep.contains(nm), "§4: IV's report does not carry the spine report for %s — what it does, its name, every surface" % nm)
	print("    CHECKED three repairs and %d claims standing" % standing.size())


# ── §5 — THE INDEX QUESTION, CLOSED WHERE IT WAS QUEUED ───────────────────────
# The derivation, not the conclusion alone: IU's census's three verdicts and 112 of 120 blocks, written in HN's shape-recon
# block; and the list IU left — the rules a gate could cheaply hold and does not — a standing list whose counts are ceilings.
const RULES_CENSUS := "docs/reports/IU-rules-census.tsv"
const CHEAP_CEILING := 188
const CHEAP_NONE_CEILING := 76


func _s5_the_index_question() -> void:
	print("\n§5 — the index question closed where it was queued; the standing list a ceiling")
	var st := _doc("res://docs/state.md")
	var at := st.find("\n### THE SHAPE RECON ON `CLAUDE.md`")
	var end := st.find("\n### ", at + 10)
	var recon := _flat(st.substr(at, end - at)) if at >= 0 and end > at else ""
	ok(recon.contains("CLOSED AT IV §0.1") and recon.contains("817 rules, HELD 299, PARTLY 229, NONE 284") and recon.contains("112 of its 120 blocks")
			and recon.contains("AN INDEX WHOSE CORE IS 112 OF 120 BLOCKS ROUTES AROUND NOTHING"),
		"§5: HN's shape-recon block does not close the index question with its derivation — 817 rules, three verdicts, 112 of 120 blocks, and the rule that makes them an answer")
	var rows := _tsv("res://" + RULES_CENSUS, ["id", "verdict", "cheap"])
	var cheap := 0
	var cheap_none := 0
	for r in rows:
		var v := String(r["verdict"])
		if (v == "NONE" or v == "PARTLY") and String(r["cheap"]).begins_with("YES"):
			cheap += 1
			if v == "NONE":
				cheap_none += 1
	ok(cheap > 0 and cheap <= CHEAP_CEILING and cheap_none <= CHEAP_NONE_CEILING,
		"§5: THE STANDING LIST ROSE — %d rules no gate fully holds that a gate could cheaply hold (ceiling %d), %d held by nothing (ceiling %d)" % [cheap, CHEAP_CEILING, cheap_none, CHEAP_NONE_CEILING])
	ok(_flat(st).contains("A STANDING LIST, WORKED THROUGH BY THE BATCH THAT TOUCHES EACH RULE's SUBJECT"),
		"§5: docs/state.md does not record the cheap gates as a standing list")
	print("    CHECKED HN's block's close and the standing list: %d cheap rows, %d of them NONE" % [cheap, cheap_none])


# ── §6 — THE INDEX's POPULATION ROWS ─────────────────────────────────────────
# Every kind the derivation gave a row (docs/reports/IV-populations.tsv, the last ten briefs' kinds asked for more than once)
# has one in the index; each row names blocks the file holds; and its stamp — the md5 of its members' texts, in its order,
# `index_stamp.py`'s and `check_it` §5's reading of a block — reds when a member's block changes.
const POPULATIONS := "docs/reports/IV-populations.tsv"


func _stamp(text: String) -> String:
	return RegEx.create_from_string("[ \t\r\n]+").sub(text, " ", true).strip_edges().md5_text().substr(0, 6)


# The blocks below the fence, by key — `check_it` §5's reading, so the two stamps are one stamp.
func _blocks_below(st: String, fence_end: int) -> Dictionary:
	var blocks := {}
	var cur := ""
	var buf: Array = []
	for line in st.substr(st.find("\n", fence_end) + 1).split("\n"):
		if line.begins_with("## ") or line.begins_with("### "):
			if cur != "":
				blocks[cur] = "\n".join(PackedStringArray(buf))
			var h := String(line).strip_edges()
			var dash := h.find(" — ")
			cur = (h.substr(0, dash) if dash > 0 else h).strip_edges()
			buf = [line]
		elif cur != "":
			buf.append(line)
	if cur != "":
		blocks[cur] = "\n".join(PackedStringArray(buf))
	return blocks


func _s6_the_population_rows() -> void:
	print("\n§6 — the index's population rows")
	var st := _doc("res://docs/state.md")
	var a := st.find("<!-- INDEX:BEGIN (")
	var b := st.find("<!-- INDEX:END -->")
	ok(a >= 0 and b > a, "§6: docs/state.md's index is not fenced")
	if a < 0 or b <= a:
		return
	var blocks := _blocks_below(st, b)
	var kinds := _tsv("res://" + POPULATIONS, ["kind", "briefs", "n_briefs"])
	var want: Array = []
	for k in kinds:
		if int(k["n_briefs"]) >= 2:
			want.append(String(k["kind"]))
	var span := RegEx.create_from_string("``\\s*(#{2,3} .+?)\\s*``")
	var found := {}
	var broken: Array = []
	for line in st.substr(a, b - a).split("\n"):
		if not String(line).begins_with("+ **POPULATION** **"):
			continue
		var l := String(line)
		var kind := l.substr(19, l.find("**", 19) - 19)
		var li := l.find("*lives in:*")
		var re := l.find("*records:*", li)
		var members: Array = []
		if li > 0:
			for m in span.search_all(l.substr(li, (re - li) if re > li else -1)):
				members.append(m.get_string(1).strip_edges())
		var missing: Array = members.filter(func(x): return not blocks.has(x))
		var texts := PackedStringArray()
		for mm in members:
			texts.append(String(blocks.get(mm, "")))
		var st_m := RegEx.create_from_string(" `#([0-9a-f]{6})`").search(l)
		var trig := l.substr(l.find("*triggers:*") + 11) if l.contains("*triggers:*") else ""
		if members.is_empty() or not missing.is_empty():
			broken.append("%s names no block %s" % [kind, str(missing)])
		elif st_m == null or st_m.get_string(1) != _stamp("\n".join(texts)):
			broken.append("%s's member block changed and its row was not re-read (stamp %s, members %s)" % [kind, st_m.get_string(1) if st_m != null else "none", _stamp("\n".join(texts))])
		elif trig.split(",", false).size() < 3 or l.find("*records:*") < 0:
			broken.append("%s carries no records or fewer than three triggers" % kind)
		found[kind] = true
	var rowless: Array = want.filter(func(k): return not found.has(k))
	ok(want.size() >= 5, "§6: the derivation names %d kinds asked for by more than one brief" % want.size())
	ok(rowless.is_empty(), "§6: %d kinds the derivation gave a row have none in the index — a brief about the kind matches no trigger: %s" % [rowless.size(), str(rowless)])
	ok(broken.is_empty(), "§6: %d population rows are broken: %s" % [broken.size(), str(broken)])
	ok(found.size() == want.size(), "§6: the index carries %d population rows against the derivation's %d" % [found.size(), want.size()])
	print("    CHECKED %d population rows against the derivation's %d kinds" % [found.size(), want.size()])
