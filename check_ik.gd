# BATCH IK — WHAT THE CENSUS FOUND IN THE CODE.
#
#   §0   THE RULINGS, WRITTEN WHERE EACH BINDS: why the seven runes the census over-read stand (beside GX's
#        sentence in CLAUDE.md), the writing rule for *ally* (the text standard), and the instrument rule that an
#        instrument which cannot read a defect is not one (the instrument rules, with its row in CLAUDE.md's index).
#   §1   BLOOD DEBT FIRES: Blood Price cast through the player's own turn (no picker; its target is its caster),
#        its cost dealt to the enemy with the most health — the first in the warband on a tie — and the Berserker
#        paying nothing; no die; under his frame (the recap, the Reaver's kill, Momentum, a judged enemy's heal),
#        not a strike (no bonus touches it), what the vow lets land and nothing more; the chip names the payer.
#   §2   EXECUTE OFFERS ONLY WHAT QUALIFIES: through the player's own turn in the fullest room the board holds, the
#        picker offers exactly the enemies below the line or Broken, a refused body's hover says why, and the door,
#        the picker and the bot ask one answer; the eight other cards that gate on the board offer every enemy.
#   §3   TWO PERFECTS: Sever's lays Sunder at its own step and duration (Crushing Blow's, one constant); Reality
#        Fracture's banks the engine's grant a second time for an Arcanist, nothing for a Mage without the meter,
#        and no other card's Perfect moves; the class basics stay Perfectless.
#   §4   THE TWO NAMES: Iron Will and Undying Rage on the node, the chip, the log and master.html, each node's
#        description opening its words, and the old labels gone.
#   §5   A STRIKE, NAMED ONCE: the glossary's entry, the eight texts and the ward's chip saying it through the door
#        each surface reads, and the asymmetries they now name read off the fight — Profligate's price on a Killing
#        Frost it pays nothing, a ward that lessens a hero's strike and no companion's blow.
#   §6   CAIRNMOSS POULTICE CANNOT BE DRAWN, AND THE BOMB's LINE: suspended at the boss's unlock, an event's grant,
#        the draft and the shelf, kept everywhere else; the bomb's sentence in the items entry, and true in a fight.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 drives Blood Price's own turn and reads the payer it chose; it does
# not play a run, so how often the Blood Debt rune pays in play is the readout's, not this gate's. §2's eight other
# cards are read off the source and one is driven; a ninth that joins the path tomorrow is a census owed, not caught.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ik.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_RELICS := "user://check_ik_relics.json"
const SCRATCH_PROFILE := "user://check_ik_profile.json"

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}
var _profile_path := ""


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IK — WHAT THE CENSUS FOUND IN THE CODE")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s0_rulings()
	await _s1_blood_debt()
	await _s2_execute()
	await _s3_perfects()
	_s4_names()
	await _s5_strike()
	await _s6_cairnmoss_and_the_bomb()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


# A function's comment-stripped body: from its `func` line to the next top-level declaration.
func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


func _engines(pids: Array) -> Array:
	var out: Array = []
	for pid in pids:
		out.append(_rune(Runes.engine_rune_id(String(pid))))
	return out


func _board(specs: Array, over: Dictionary) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	await Gate.frames(self, 3)


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == key:
			return h
	return null


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _card(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


func _calm(scene: Node, max_hp: int) -> void:
	for e in scene.get("enemies"):
		var eu: BattleUnit = e
		if eu.dead:
			continue
		eu.max_hp = max_hp
		eu.hp = max_hp
		eu.pressure = 0
		eu.broken = false
		for st in eu.statuses.duplicate():
			eu.remove_status(String(st.id))


# THE PLAYER's OWN TURN, DRIVEN. Every hero's parked turn but `u`'s is answered with his basic on the
# picker's first offer (the enemies' health is set so a basic cannot move what is measured); on `u`'s turn
# `ab` is pressed as a player presses it, through `_ability_picked`. `setup` runs in the frame the card is
# pressed, so the board it measures is the board the turn reads. The skill bar is graded as it sweeps.
# What it returns: whether a picker opened, the pool it offered, every body's refusal hover while it was
# open, the turn's log, and whether the pick resolved (the action panel came back).
func _turn(scene: Node, u: BattleUnit, ab: Ability, setup: Callable = Callable(), choose := 0) -> Dictionary:
	var out := {"prompted": false, "pool": [], "refused": {}, "resolved": false, "log": ""}
	var hist: RichTextLabel = scene.get("history")
	var pressed := false
	var log_at := 0
	var frames_n := 0
	while frames_n < 6000:
		frames_n += 1
		Engine.time_scale = 100.0
		await process_frame
		if not is_instance_valid(scene):
			break
		if bool(scene.get("sc_active")):
			scene.call("_grade_skill_check")
			continue
		var kb: Array = scene.get("_kb_pool")
		if not kb.is_empty():
			if pressed and not out["prompted"]:
				out["prompted"] = true
				out["pool"] = kb.duplicate()
				for e in scene.get("enemies"):
					var why := String((e as BattleUnit).target_refusal())
					if why != "":
						out["refused"][e] = why
			scene.emit_signal("_target_picked", kb[clampi(choose, 0, kb.size() - 1)])
			continue
		var p: BattleUnit = scene.get("current_hero")
		var panel: Control = scene.get("action_panel")
		if p == null or panel == null or not panel.visible:
			continue
		if pressed:
			out["resolved"] = true
			break
		if p != u:
			scene.emit_signal("_ability_picked", p.abilities[0])
			continue
		u.cooldowns.clear()
		u.resource = u.max_resource
		if setup.is_valid():
			setup.call()
		pressed = true
		log_at = hist.get_parsed_text().length() if hist != null else 0
		scene.emit_signal("_ability_picked", ab)
	Engine.time_scale = 1.0
	if hist != null and is_instance_valid(hist):
		out["log"] = hist.get_parsed_text().substr(log_at)
	return out


# ── §0 — THE RULINGS, WRITTEN WHERE EACH BINDS ──────────────────────────────

func _s0_rulings() -> void:
	print("\n§0 — the rulings, written where each binds")
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	var rules := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var std := FileAccess.get_file_as_string("res://docs/text-standard.html")
	ok(claude.length() > 100000 and rules.length() > 100000 and std.length() > 10000,
		"§0: the rule files did not read (%d / %d / %d chars)" % [claude.length(), rules.length(), std.length()])
	# §0.2 — the seven over-read runes, beside GX's sentence: in the block that holds the sentence, once.
	var seven := "A RUNE WHOSE BRANCH NEEDS AN ENGINE IS NEVER DRAFTED DEAD"
	ok(claude.count(seven) == 1, "§0.2: CLAUDE.md does not say once why a rune that needs an engine is never drafted dead (%d)" % claude.count(seven))
	var gx_at := claude.find("## STANDING RULE — A CARD OR A RUNE THAT CANNOT PAY WITHOUT ITS ENGINE SITS OUT")
	var gx_end := claude.find("\n## ", gx_at + 10)
	var at7 := claude.find(seven)
	ok(gx_at >= 0 and at7 > gx_at and (gx_end < 0 or at7 < gx_end),
		"§0.2: the reasoning does not stand in GX's block, beside the sentence a sitting-out rune wears")
	for n in ["N010", "N026", "N027", "N030", "N033", "N036", "N043"]:
		ok(claude.substr(at7, 1400).contains(n), "§0.2: the reasoning does not name %s, one of the seven it stands for" % n)
	# §0.11 — the writing rule, in the text standard (and only there).
	var ally := "A TEXT THAT MEANS THE FOUR MEANS HERO"
	ok(std.count(ally) == 1 and not claude.contains(ally) and not rules.contains(ally),
		"§0.11: the writing rule for ally does not stand once in the text standard alone (%d / %s / %s)" % [
			std.count(ally), claude.contains(ally), rules.contains(ally)])
	ok(std.contains("MEANS WARBAND"), "§0.11: the text standard's rule does not say what a text means for an enemy's own side")
	# §0.12 — the instrument rule, in the instrument rules, with its row in CLAUDE.md's index.
	# The heading and the row are joined into variables first: a literal handed to `contains` is read by
	# `check_ec` §2 as a needle on its own, and the prefix alone stands in CLAUDE.md a hundred times.
	var head := "AN INSTRUMENT THAT CANNOT READ A DEFECT IS NOT AN INSTRUMENT"
	var blk_head := "## STANDING RULE — " + head
	var row := "| " + head + " |"
	ok(rules.count(blk_head) == 1, "§0.12: the instrument rules do not hold the rule's block once")
	ok(claude.contains(row), "§0.12: CLAUDE.md's index has no row for the rule")
	ok(not claude.contains(blk_head), "§0.12: the rule's block is in CLAUDE.md too — a rule stands in one file")
	var blk := rules.substr(rules.find(blk_head), 2600)
	ok(blk.contains("Every alternative in a needle is live, or it is deleted"),
		"§0.12: the rule does not carry its needle half")
	ok(blk.contains("zero is indistinguishable"), "§0.12: the rule does not carry its zero-read half")


# ── §1 — BLOOD DEBT FIRES ───────────────────────────────────────────────────

func _berserker_over(extra_engines: Array = []) -> Dictionary:
	var engs: Array = _engines(["bloodrage"] + extra_engines)
	return {0: {"engines": engs, "runes": [_rune("blood_debt_rune")],
		"bm_abilities": ["Blood Price"], "bm_equipped": ["Blood Price"]}}


func _s1_blood_debt() -> void:
	print("\n§1 — Blood Debt fires: the fullest enemy pays, through the Berserker's own turn")
	var specs := ["berserker", "pyromancer", "holy", "mystic"]
	# (a) THE PLAYER's OWN CAST: no picker, and its target is its caster (the no-target list holds it).
	var src := _src("scripts/battle.gd")
	var pt := src.find("func _player_turn(")
	var open := src.find("elif ab.special in [", pt)
	var close := src.find("]:", open)
	ok(pt >= 0 and open > pt and close > open and src.substr(open, close - open).contains("\"blood_price\"")
			and src.substr(close, 60).contains("target = u"),
		"§1a: Blood Price is not on the player turn's no-target list, so its target is not its caster")
	var s: Node = await _board(specs, _berserker_over())
	var b := _hero(s, "warrior")
	var bp := _card(b, "Blood Price") if b != null else null
	ok(b != null and bp != null and b.rune_blood_debt > 0, "§1a: the board seats a Berserker wearing Blood Debt and holding Blood Price")
	if b == null or bp == null:
		await _clear(s)
		return
	_calm(s, 100000)
	var foes: Array = _foes(s)
	var want: Array = [61000, 87000, 52000]
	var hp_set := func():
		for i in foes.size():
			(foes[i] as BattleUnit).hp = int(want[i % want.size()])
	# A lambda captures a local by value, so what it records goes in a Dictionary.
	var before := {}
	var grab := func():
		hp_set.call()
		before["b"] = b.hp
		for e in foes:
			before[e] = (e as BattleUnit).hp
	var r: Dictionary = await _turn(s, b, bp, grab)
	ok(bool(r["resolved"]) and not bool(r["prompted"]),
		"§1a: Blood Price's own turn did not resolve, or opened a picker (resolved %s, prompted %s)" % [r["resolved"], r["prompted"]])
	# A turn that never reached the board recorded nothing: the arms below read it as it stands, and say so, never throw.
	for e1 in foes:
		if not before.has(e1):
			before[e1] = (e1 as BattleUnit).hp
	var fullest: BattleUnit = null
	for e2 in foes:
		if fullest == null or int(before[e2]) > int(before[fullest]):
			fullest = e2
	var fullest_pick := ("%s at %d, the fullest of the warband's %d, the first in the warband on a tie" % [
		fullest.unit_name, int(before[fullest]), foes.size()]) if fullest != null else "no enemy was picked"
	var share := maxi(int(round(int(before[fullest]) * 0.075)), 1)
	var lost := {}
	for e3 in foes:
		lost[e3] = int(before[e3]) - (e3 as BattleUnit).hp
	ok(int(lost[fullest]) == share, "§1a: the fullest enemy (%s, %d) lost %d, want its 7.5%% (%d)" % [
		fullest.unit_name, int(before[fullest]), int(lost[fullest]), share])
	var others := 0
	for e4 in foes:
		if e4 != fullest and int(lost[e4]) != 0:
			others += 1
	ok(others == 0, ("§1a: %d enemies who are not the fullest lost health to the bill" % others) + " — %s" % fullest_pick)
	var b_was := int(before.get("b", -1))
	ok(b.hp == b_was, "§1a: the Berserker's health read %s before the bill and %d after — the rune sends the bill away" % [
		str(before.get("b", "nothing (the turn never set the board)")), b.hp])
	ok(String(r["log"]).contains("Rune: Blood Debt — %s pays %d" % [fullest.unit_name, share]),
		"§1a: the log does not say the fullest enemy paid what it lost" + " — %s" % fullest_pick)
	var bp_line := ""
	for ln in String(r["log"]).split("\n"):
		if ln.contains("Blood Price —"):
			bp_line = ln
	ok(bp_line.contains("%s pays the debt" % fullest.unit_name),
		"§1a: Blood Price's own line does not say the fullest enemy (%s) pays the debt ('%s')" % [fullest.unit_name, bp_line])
	var chip: String = String(b.get_status("blood_price").get("desc", ""))
	ok(chip.contains("%s's blood" % fullest.unit_name) and not chip.contains("his own blood"),
		("§1a: the +25%% chip does not say whose blood paid ('%s')" % chip) + " — %s" % fullest_pick)
	print("    the bill: %s at %d paid %d; the others lost nothing; he paid %d" % [fullest.unit_name, int(before[fullest]), share, b_was - b.hp])
	# (b) A TIE GOES TO THE FIRST IN THE WARBAND, AND THE CHOICE SPENDS NO DIE.
	for e5 in foes:
		(e5 as BattleUnit).hp = 70000
	ok(s.call("_blood_debt_payer") == foes[0], "§1b: on a tie the payer is not the first in the warband")
	(foes[foes.size() - 1] as BattleUnit).hp = 70001
	ok(s.call("_blood_debt_payer") == foes[foes.size() - 1], "§1b: one more point of health does not make an enemy the payer")
	seed(4242)
	var d1 := randf()
	seed(4242)
	s.call("_blood_debt_payer")
	var d2 := randf()
	ok(d1 == d2, "§1b: choosing the payer spent a die")
	var pb := _body("scripts/battle.gd", "_blood_debt_payer")
	ok(pb.length() > 40 and not pb.contains("rand") and not pb.contains("pick_random") and not pb.contains("shuffle"),
		"§1b: `_blood_debt_payer` read %d chars, naming a dice spender: %s" % [pb.length(),
			pb.contains("rand") or pb.contains("pick_random") or pb.contains("shuffle")])
	await _clear(s)
	# (c) HIS DAMAGE, UNDER HIS FRAME: the recap's row, Momentum's dealt, the Reaver's kill, a judged enemy's heal.
	var s2: Node = await _board(specs, _berserker_over(["savage_assault"]))
	var b2 := _hero(s2, "warrior")
	_calm(s2, 100000)
	var f2: Array = _foes(s2)
	for i2 in f2.size():
		(f2[i2] as BattleUnit).hp = 40000 + 10000 * i2
	var payer2: BattleUnit = s2.call("_blood_debt_payer")
	var share2 := maxi(int(round(payer2.hp * 0.075)), 1)
	var dealt_was := int(b2.momentum_dealt)
	var rows_was := float(((s2.get("_run_dealt") as Dictionary).get(b2.unit_name, {}) as Dictionary).get("Blood Price", 0.0))
	await s2._resolve(b2, _card(b2, "Blood Price"), b2, "good")
	var rows_now := float(((s2.get("_run_dealt") as Dictionary).get(b2.unit_name, {}) as Dictionary).get("Blood Price", 0.0))
	ok(int(rows_now - rows_was) == share2, "§1c: the recap books %d under the Berserker's Blood Price, want %d" % [int(rows_now - rows_was), share2])
	ok(int(b2.momentum_dealt) - dealt_was == share2, "§1c: Momentum's dealt ledger moved %d, want the %d he dealt" % [int(b2.momentum_dealt) - dealt_was, share2])
	# THE KILL: every enemy at 1 health, so the payer is the first in the warband (the tie's rule) and the
	# bill's floor of 1 fells it while the rest stand — the Reaver's kill, and the fight goes on.
	for e6 in _foes(s2):
		(e6 as BattleUnit).hp = 1
	var kills_was := int(b2.reaver_kills)
	await s2._resolve(b2, _card(b2, "Blood Price"), b2, "good")
	ok((f2[0] as BattleUnit).dead, "§1c: the bill did not fell the last enemy at 1 health")
	ok(int(b2.reaver_kills) == kills_was + 1, "§1c: the Reaver did not count the bill's kill as his (%d → %d)" % [kills_was, int(b2.reaver_kills)])
	await _clear(s2)
	# A JUDGED ENEMY's WOUND HEALS THE HEROES OFF THE BILL — the damage door reads him as its dealer.
	var s3: Node = await _board(specs, _berserker_over().merged({2: {"engines": _engines(["judgment"])}}))
	var b3 := _hero(s3, "warrior")
	var c3 := _hero(s3, "cleric")
	_calm(s3, 100000)
	var f3: Array = _foes(s3)
	for e3b in f3:
		(e3b as BattleUnit).hp = 50000
	(f3[0] as BattleUnit).hp = 90000
	s3.call("_lay_engine_mark", c3, "judgment", f3[0])
	for h in s3.get("heroes"):
		(h as BattleUnit).hp = maxi(int((h as BattleUnit).max_hp * 0.5), 1)
	var party_was := 0
	for h2 in s3.get("heroes"):
		party_was += (h2 as BattleUnit).hp
	await s3._resolve(b3, _card(b3, "Blood Price"), b3, "good")
	var party_now := 0
	for h3 in s3.get("heroes"):
		party_now += (h3 as BattleUnit).hp
	ok((f3[0] as BattleUnit).has_status("judged") and party_now > party_was,
		"§1c: the judged enemy lost %d to the bill and the heroes' health read %d → %d — no heal arrived" % [
			90000 - (f3[0] as BattleUnit).hp, party_was, party_now])
	await _clear(s3)
	# AND WHAT IT CANNOT REACH: no Warrior holds an engine that pays or marks off the dealer.
	var wengs: Array = Classes.class_engines("warrior")
	for pid in ["siphon", "cast_echo", "quarry_hunt", "judgment"]:
		ok(not wengs.has(pid), "§1c: a Warrior can hold %s — the bill would feed or mark off it, and this gate says it does not" % pid)
	ok(wengs.has("savage_assault") and wengs.has("momentum"), "§1c: the Warrior's engines no longer hold the Reaver and the Vanguard (%s)" % str(wengs))
	# (d) NOT A STRIKE: every bonus a strike reads is on him, and the share is the payer's 7.5% to the point.
	var s4: Node = await _board(specs, _berserker_over())
	var b4 := _hero(s4, "warrior")
	_calm(s4, 100000)
	var f4: Array = _foes(s4)
	for e4b in f4:
		(e4b as BattleUnit).hp = 40000
	(f4[1] as BattleUnit).hp = 88888
	b4.dmg_bonus = 3.0
	b4.type_dmg_bonus["physical"] = 3.0
	s4.call("_apply_status", b4, "blood_price", 2)
	var want4 := maxi(int(round(88888 * 0.075)), 1)
	await s4._resolve(b4, _card(b4, "Blood Price"), b4, "good")
	ok(88888 - (f4[1] as BattleUnit).hp == want4, "§1d: under every strike bonus the fullest enemy lost %d to the bill, want its 7.5%% (%d)" % [88888 - (f4[1] as BattleUnit).hp, want4])
	await _clear(s4)
	# (e) WHAT THE VOW LETS LAND: a vowed Berserker's bill lands nothing, credits nothing, and says so. No Warrior is
	# offered the vow, so it is worn on his member and seated by the spawn — the gate sets no field it reads (check_gw §2).
	var vow_over := _berserker_over()
	(vow_over[0]["runes"] as Array).append(_rune("vow_of_silence"))
	var s5: Node = await _board(specs, vow_over)
	var b5 := _hero(s5, "warrior")
	_calm(s5, 100000)
	var f5: Array = _foes(s5)
	for e5b in f5:
		(e5b as BattleUnit).hp = 40000
	(f5[0] as BattleUnit).hp = 95000
	var mo5 := int(b5.momentum_dealt)
	await s5._resolve(b5, _card(b5, "Blood Price"), b5, "good")
	var hist5: RichTextLabel = s5.get("history")
	ok(b5.rune_vow_of_silence > 0.0 and (f5[0] as BattleUnit).hp == 95000 and int(b5.momentum_dealt) == mo5,
		"§1e: the spawn seated the vow at %s; the vowed Berserker's bill landed %d and was credited %d" % [
			b5.rune_vow_of_silence, 95000 - (f5[0] as BattleUnit).hp, int(b5.momentum_dealt) - mo5])
	ok(hist5 != null and hist5.get_parsed_text().contains("bill is silenced by"),
		"§1e: the silenced bill's line does not say it was silenced")
	await _clear(s5)
	# (f) THE CONTROL: without the rune he pays, and no enemy does — the card's own rule, unchanged.
	var s6: Node = await _board(specs, {0: {"bm_abilities": ["Blood Price"], "bm_equipped": ["Blood Price"]}})
	var b6 := _hero(s6, "warrior")
	_calm(s6, 100000)
	var foes_was := 0
	for e8 in _foes(s6):
		foes_was += (e8 as BattleUnit).hp
	var b6_was := b6.hp
	await s6._resolve(b6, _card(b6, "Blood Price"), b6, "good")
	var foes_now := 0
	for e9 in _foes(s6):
		foes_now += (e9 as BattleUnit).hp
	ok(b6_was - b6.hp == maxi(int(round(b6_was * 0.075)), 1) and foes_now == foes_was,
		"§1f: without the rune the Berserker did not pay his 7.5%%, or an enemy paid (%d / %d)" % [b6_was - b6.hp, foes_was - foes_now])
	await _clear(s6)


# ── §2 — EXECUTE OFFERS ONLY WHAT QUALIFIES ─────────────────────────────────

const SIX := ["raider", "raider", "archer", "raider", "archer", "raider"]
# The eight other cards whose door asks whether ANY enemy meets a condition and whose pick is the whole living
# warband (IK's census of `_ability_usable` against `_player_turn`'s pool): by special, or by name for two.
const BOARD_GATED := {"cull": "Cull", "transference": "Transference", "requiem": "Requiem",
	"funeral_pyre": "Funeral Pyre", "firedraw": "Firedraw", "pyre_wake": "Pyre Wake",
	"cryoclasm": "Cryoclasm", "": "Hunt"}


# The fullest room the board holds: the fixture's run, entered with six. Returns the battle scene.
func _six_room(specs: Array, over: Dictionary) -> Node:
	var s0: Node = await Gate.spawn(self, specs, {"party": over})
	await _clear(s0)
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": SIX.duplicate()})
	await Gate.frames(self, 90)
	var s: Node = current_scene
	# The fixture's deterministic roll, as `Gate.spawn` lays it: no miss, parry, block or crit to swamp a pick.
	if s != null:
		for u in s.get("heroes") + s.get("enemies"):
			u.no_cover = 1
			u.parry_chance = 0.0
			u.block_chance = -10.0
			u.crit_bonus = -1.0
	return s


func _s2_execute() -> void:
	print("\n§2 — Execute offers only what qualifies, through the Swordmaster's own turn")
	var specs := ["swordmaster", "pyromancer", "holy", "mystic"]
	var over := {0: {"bm_abilities": ["Execute"], "bm_equipped": ["Execute"]}}
	var s: Node = await _six_room(specs, over)
	var u := _hero(s, "warrior") if s != null else null
	var ex := _card(u, "Execute") if u != null else null
	var foes: Array = _foes(s) if s != null else []
	ok(u != null and ex != null and foes.size() == 6, "§2: the room seats a Swordmaster holding Execute against six (%d)" % foes.size())
	if u == null or ex == null or foes.size() != 6:
		return
	# (a) TWO BELOW THE LINE, ONE BROKEN, THREE NOT: the picker offers the three and refuses the three.
	var shape := func():
		_calm(s, 100000)
		var hps := [15000, 100000, 50000, 25000, 100000, 19000]
		for i in 6:
			(foes[i] as BattleUnit).hp = hps[i]
		(foes[1] as BattleUnit).broken = true
	var r: Dictionary = await _turn(s, u, ex, shape, 0)
	var want: Array = [foes[0], foes[1], foes[5]]
	var pool: Array = r["pool"]
	ok(bool(r["prompted"]) and pool.size() == 3 and want.all(func(e): return pool.has(e)),
		"§2a: the picker offered %d (%s), want the three that qualify" % [pool.size(), str(pool.map(func(e): return (e as BattleUnit).hp))])
	var refused: Dictionary = r["refused"]
	var line := "%d%%" % int(round(float(s.call("_execute_line", u)) * 100.0))
	ok(refused.size() == 3 and [foes[2], foes[3], foes[4]].all(func(e): return String(refused.get(e, "")).contains(line)),
		"§2a: the three it refuses do not each say, on their hover, the %s line they are above (%s)" % [line, str(refused.values())])
	ok(not refused.has(foes[0]) and not refused.has(foes[1]) and not refused.has(foes[5]),
		"§2a: a body the picker offers carries a refusal")
	ok(foes.all(func(e): return String((e as BattleUnit).target_refusal()) == ""),
		"§2a: a refusal hover outlived the pick")
	print("    the fullest room: offered %d of six, refused %d — '%s'" % [pool.size(), refused.size(),
		String(refused.values()[0]).replace("\n", " ") if not refused.is_empty() else ""])
	# (b) ONE THAT QUALIFIES: no picker, and the blow lands on it.
	var one := func():
		_calm(s, 100000)
		for i2 in 6:
			(foes[i2] as BattleUnit).hp = 60000
		(foes[3] as BattleUnit).hp = 9000
	var r2: Dictionary = await _turn(s, u, ex, one)
	ok(not bool(r2["prompted"]) and (foes[3] as BattleUnit).hp < 9000,
		"§2b: with one enemy below the line the cast opened a picker (%s), and that enemy stands at %d of 9000" % [
			r2["prompted"], (foes[3] as BattleUnit).hp])
	# (c) NONE: the door refuses — the card is castable exactly when one qualifies.
	_calm(s, 100000)
	u.resource = u.max_resource
	u.cooldowns.clear()
	ok(not bool(s.call("_ability_usable", u, ex)), "§2c: Execute is usable with no enemy below the line and none Broken")
	(foes[2] as BattleUnit).broken = true
	ok(bool(s.call("_ability_usable", u, ex)), "§2c: Execute is refused with a Broken enemy standing — the positive arm")
	(foes[2] as BattleUnit).broken = false
	# (d) THE UPGRADED LINE, AND THE FREE CAST HE CANNOT OTHERWISE PAY FOR: the line moves to the upgraded one,
	# and with no Rage the pick is the Broken alone, a low enemy told why.
	u.execute_upgraded = 1
	var up := func():
		_calm(s, 100000)
		var hps2 := [30000, 100000, 50000, 90000, 100000, 80000]
		for i3 in 6:
			(foes[i3] as BattleUnit).hp = hps2[i3]
		(foes[1] as BattleUnit).broken = true
	var r3: Dictionary = await _turn(s, u, ex, up, 0)
	ok(bool(r3["prompted"]) and (r3["pool"] as Array).size() == 2 and (r3["pool"] as Array).has(foes[0]),
		"§2d: the upgraded line did not offer the enemy at 30%% (offered %d)" % (r3["pool"] as Array).size())
	var broke := func():
		up.call()
		u.resource = 0
	var r4: Dictionary = await _turn(s, u, ex, broke, 0)
	ok(not bool(r4["prompted"]) and (foes[1] as BattleUnit).hp < 100000 and (foes[0] as BattleUnit).hp == 30000,
		"§2d: with no Rage the upgraded pick was not the Broken one alone (prompted %s)" % r4["prompted"])
	var why := String(s.call("_target_refusals", u, ex, [foes[1]]).get(foes[0], ""))
	ok(why.contains("only a Broken enemy is free"), "§2d: the low enemy he cannot pay to execute is not told why ('%s')" % why)
	u.execute_upgraded = 0
	# (e) ONE ANSWER: the line is written once, and the door, the pick and the bot each ask it.
	var src := _src("scripts/battle.gd")
	ok(src.count("0.35 if u.execute_upgraded > 0 else 0.2") == 1, "§2e: Execute's line is written %d times" % src.count("0.35 if u.execute_upgraded > 0 else 0.2"))
	ok(_body("scripts/battle.gd", "_ability_usable").contains("_execute_qualifies(u, e)"), "§2e: the door does not ask `_execute_qualifies`")
	# BATCH IL §3 RE-POINTED THIS ROW: the picker's narrowing moved into `_enemy_pick_pool`, the one answer the
	# bot's drafted hook asks too, so the picker asks the qualifier through it — both halves read, both printed.
	var pk_calls := _body("scripts/battle.gd", "_player_turn").contains("pool = _enemy_pick_pool(u, ab, pool)")
	var pk_asks := _body("scripts/battle.gd", "_enemy_pick_pool").contains("_execute_qualifies(u, e)")
	ok(pk_calls and pk_asks, "§2e: the picker does not ask `_execute_qualifies` (the picker calls `_enemy_pick_pool`: %s; it asks the qualifier: %s)" % [pk_calls, pk_asks])
	ok(src.count("_execute_qualifies(u, e)") >= 3, "§2e: the bot does not ask `_execute_qualifies` (%d askers)" % src.count("_execute_qualifies(u, e)"))
	# (f) THE EIGHT OTHERS SHARE THE PATH: each is a single-target enemy pick off the no-target list, and the narrowing
	# Execute's branch makes is keyed on Execute alone. SINCE IM §3b seven of them narrow by their own rule (a body that
	# would produce nothing), Hunt offers every enemy, and Requiem driven offers the bodies carrying Ruin.
	var pt := src.find("func _player_turn(")
	var open := src.find("elif ab.special in [", pt)
	var close := src.find("]:", open)
	var self_list := src.substr(open, close - open)
	var met := 0
	for ab in Classes.ability_corpus():
		var key := String(ab.special) if BOARD_GATED.has(String(ab.special)) and String(ab.special) != "" else ""
		if not (BOARD_GATED.has(key) and String(BOARD_GATED[key]) == ab.display_name):
			continue
		met += 1
		ok(ab.target == Ability.Target.ENEMY and not ab.aoe and ab.random_hits == 0
				and (ab.special == "" or not self_list.contains("\"%s\"" % ab.special)),
			"§2f: %s is not a single-target enemy pick — it does not share Execute's path" % ab.display_name)
		# BATCH IM §3b RE-POINTED THIS ROW: seven of the eight refuse a body that would produce nothing (IL §0.7's
		# rubric, the designer's), each with its own reason; Hunt pays its base and refuses nobody. What it still asks:
		# Execute's narrowing reached none of them — every refusal any of them gives is in its own name.
		var rf: Dictionary = s.call("_target_refusals", u, ab, [])
		var own := rf.values().all(func(w): return String(w).begins_with(ab.display_name + ":"))
		ok(own and (ab.display_name != "Hunt" or rf.is_empty()),
			"§2f: %s's pick is narrowed by a reason not its own — Execute's fix reached it (%s)" % [ab.display_name, str(rf.values())])
	ok(met == BOARD_GATED.size(), "§2f: the census met %d of the %d cards it names" % [met, BOARD_GATED.size()])
	# BATCH IL §3 RE-POINTED THIS ROW to where the narrowing lives now (`_enemy_pick_pool`), still keyed on Execute alone.
	# BATCH IM §3b RE-POINTED IT AGAIN: Execute's branch is keyed on Execute alone, beside the seven's.
	var narrow := _body("scripts/battle.gd", "_enemy_pick_pool")
	ok(narrow.contains("if ab.display_name == \"Execute\":\n\t\tvar out: Array = pool.filter(func(e): return _execute_qualifies(u, e))"),
		"§2f: the pool's narrowing is not keyed on Execute alone (`_enemy_pick_pool` reads %d chars)" % narrow.length())
	await _clear(s)
	var s2: Node = await _six_room(["swordmaster", "pyromancer", "occultist", "mystic"],
		{2: {"bm_abilities": ["Requiem"], "bm_equipped": ["Requiem"]}})
	var c := _hero(s2, "cleric") if s2 != null else null
	var rq := _card(c, "Requiem") if c != null else null
	var f2: Array = _foes(s2) if s2 != null else []
	ok(c != null and rq != null and f2.size() == 6, "§2f: the room seats an Occultist holding Requiem against six")
	if c != null and rq != null and f2.size() == 6:
		# BATCH IM §3b RE-POINTED THIS DRIVE: Requiem offers the bodies carrying Ruin and refuses the rest with its own
		# reason. And the mark is LAID now — `set_ruin_stacks` rewrites a mark that stands and lays none on a body that
		# carries none, so IK's setup put Ruin nowhere and drove a cast the door refuses (found at IM).
		var ruin_two := func():
			_calm(s2, 100000)
			for rb in [f2[1], f2[2]]:
				s2.call("_apply_status", rb, "ruin", -1, 0, 0, c)
				(rb as BattleUnit).set_ruin_stacks(3)
		var r5: Dictionary = await _turn(s2, c, rq, ruin_two, 1)
		var rq_own := (r5["refused"] as Dictionary).values().all(func(w): return String(w).begins_with("Requiem:"))
		ok(bool(r5["prompted"]) and (r5["pool"] as Array) == [f2[1], f2[2]] and (r5["refused"] as Dictionary).size() == 4 and rq_own,
			"§2f: Requiem's pick prompted %s, offered %d of six (want the two carrying Ruin) and refused %d in its own words %s" % [
				r5["prompted"], (r5["pool"] as Array).size(), (r5["refused"] as Dictionary).size(), rq_own])
		print("    Requiem, gated on the board as Execute is: offered %d of six, the two carrying Ruin" % (r5["pool"] as Array).size())
	await _clear(s2)


# ── §3 — TWO PERFECTS, AUTHORED ─────────────────────────────────────────────

func _first_strike_card(class_key: String, skip: Array) -> String:
	for n in Classes.draft_pool(class_key):
		var ab: Ability = Classes.pool_ability(String(n))
		if ab != null and ab.special == "" and ab.damage > 0 and ab.cost > 0 and not ab.aoe \
				and ab.random_hits == 0 and ab.multi_hits == 0 and not ab.gated and not skip.has(ab.display_name) \
				and not Classes.SITS_OUT.has(ab.display_name):
			return ab.display_name
	return ""


func _s3_perfects() -> void:
	print("\n§3 — Sever's Perfect lays Sunder; Reality Fracture's banks a second Resonance")
	# (a) SEVER: the card's arm and its words, both read off Sunder's own step and duration.
	var sv: Ability = Classes.pool_ability("Sever")
	var cb: Ability = Classes.pool_ability("Crushing Blow")
	ok(sv != null and sv.perfect_id == "sunder", "§3a: Sever's Perfect does not name the Sunder arm (%s)" % (sv.perfect_id if sv != null else "<none>"))
	var sv_words := "Sunders armor by %d%% for %d turns" % [int(round(BattleUnit.SUNDER_STEP * 100.0)), BattleUnit.SUNDER_TURNS]
	ok(sv != null and sv.perfect_text == sv_words, "§3a: Sever's Perfect reads '%s', want '%s'" % [sv.perfect_text if sv != null else "", sv_words])
	ok(cb != null and int(cb.applies_status.get("turns", 0)) == BattleUnit.SUNDER_TURNS
			and cb.description.contains("for %d turns" % BattleUnit.SUNDER_TURNS),
		"§3a: Crushing Blow — Sunder's base application — does not lay and state `SUNDER_TURNS`")
	var arm := _body("scripts/battle.gd", "_apply_perfect_bonus")
	ok(arm.contains("_apply_status(target, \"sunder\", BattleUnit.SUNDER_TURNS, 0, 0, attacker)"),
		"§3a: the Sunder arm does not lay one deep for `SUNDER_TURNS`")
	ok(not _src("scripts/classes.gd").contains("\"applies_status\": {\"id\": \"sunder\", \"turns\": 3}"),
		"§3a: Crushing Blow still types its Sunder's turns")
	var s: Node = await _board(["swordmaster", "arcanist", "holy", "mystic"],
		{0: {"bm_abilities": ["Sever"], "bm_equipped": ["Sever"]},
		1: {"bm_abilities": ["Reality Fracture"], "bm_equipped": ["Reality Fracture"]}})
	var w := _hero(s, "warrior")
	var sev := _card(w, "Sever") if w != null else null
	_calm(s, 100000)
	var f: Array = _foes(s)
	ok(w != null and sev != null and f.size() >= 3, "§3a: the board seats a Swordmaster holding Sever")
	if w != null and sev != null and f.size() >= 3:
		w.stance = "aggressive"
		w.resource = 9999
		await s._resolve(w, sev, f[0], "perfect")
		var st: Dictionary = (f[0] as BattleUnit).get_status("sunder")
		ok(not st.is_empty() and int(st.get("turns", 0)) == BattleUnit.SUNDER_TURNS and (f[0] as BattleUnit).sunder_depth() == 1,
			"§3a: a Perfect Sever laid %s — want Sunder one deep for %d turns" % [str(st), BattleUnit.SUNDER_TURNS])
		w.cooldowns.clear()
		await s._resolve(w, sev, f[1], "good")
		ok(not (f[1] as BattleUnit).has_status("sunder"), "§3a: a Good Sever laid Sunder — the arm is the Perfect's")
		s.call("_apply_status", f[2], "sunder", 3, 3, 0, w)
		w.cooldowns.clear()
		await s._resolve(w, sev, f[2], "perfect")
		ok((f[2] as BattleUnit).sunder_depth() == 3, "§3a: a Perfect Sever made a deeper Sunder shallower (%d)" % (f[2] as BattleUnit).sunder_depth())
		# WHAT IT OPENS, REPORTED: Sunder and Burn on one body — and Crushing Blow, every Warrior's, already laid it.
		s.call("_apply_status", f[0], "burn", 3, 0, 5, s.get("heroes")[1])
		var both := (f[0] as BattleUnit).has_status("sunder") and (f[0] as BattleUnit).has_status("burn")
		ok(both, "§3a: Sunder and Burn did not stand together on one body")
		print("    Sunder + Burn on one body: %s; a conjunction of them built: %s (the table holds %s)" % [
			"reachable" if both else "NOT reached", str((s.CONJUNCTIONS as Dictionary).values().any(func(v): return (v as Array).has("sunder"))),
			str((s.CONJUNCTIONS as Dictionary).keys())])
	# (b) REALITY FRACTURE: an Arcanist banks the grant twice on a Perfect, once otherwise; nothing without the meter.
	var rf: Ability = Classes.pool_ability("Reality Fracture")
	ok(rf != null and rf.perfect_text == "An Arcanist banks +1 Resonance" and rf.perfect_id == "",
		"§3b: Reality Fracture's Perfect reads '%s'" % (rf.perfect_text if rf != null else ""))
	var res := _body("scripts/battle.gd", "_resolve")
	ok(res.contains("if ab.display_name == \"Reality Fracture\" and is_perfect:\n\t\t\t\tres_gain += 1"),
		"§3b: the Resonance block does not bank Reality Fracture's Perfect a second time")
	ok(res.contains("singularity_crit_build) if any_crit else 1"), "§3b: the engine's own grant — the base it banks again — moved")
	var m := _hero(s, "mage")
	var rfc := _card(m, "Reality Fracture") if m != null else null
	ok(m != null and rfc != null and m.second_resource_name == "Resonance", "§3b: the board seats an Arcanist holding Reality Fracture")
	if m != null and rfc != null:
		var grades := {}
		for g in ["good", "perfect", "fail"]:
			m.second_resource = 0
			m.res_cast_this_turn = false
			m.cooldowns.clear()
			m.resource = m.max_resource
			await s._resolve(m, rfc, f[1], g)
			grades[g] = m.second_resource
		ok(int(grades["good"]) == 1 and int(grades["perfect"]) == 2 and int(grades["fail"]) == 1,
			"§3b: an Arcanist banked %s from Reality Fracture — want 1 / 2 / 1 (Good / Perfect / Sloppy)" % str(grades))
		var other := _first_strike_card("mage", ["Reality Fracture", "Kindled Mind", "Arcane Bolt", "Unmaking"])
		var oc: Ability = Classes.pool_ability(other) if other != "" else null
		if oc != null:
			m.second_resource = 0
			m.res_cast_this_turn = false
			m.resource = m.max_resource
			await s._resolve(m, oc, f[1], "perfect")
			ok(m.second_resource == 1, "§3b: %s's Perfect banked %d — the second Resonance reached another card" % [other, m.second_resource])
		ok(oc != null, "§3b: no other Mage strike card to hold the control on")
		print("    Reality Fracture banks %s (Good / Perfect / Sloppy); %s's Perfect banks 1" % [str(grades), other])
	await _clear(s)
	var s2: Node = await _board(["swordmaster", "pyromancer", "holy", "mystic"],
		{1: {"bm_abilities": ["Reality Fracture"], "bm_equipped": ["Reality Fracture"]}})
	var py := _hero(s2, "mage")
	var rf2 := _card(py, "Reality Fracture") if py != null else null
	_calm(s2, 100000)
	ok(py != null and rf2 != null and py.second_resource_name != "Resonance", "§3b: the control seats a Mage with no Resonance holding Reality Fracture")
	if py != null and rf2 != null:
		var was := py.second_resource
		py.resource = py.max_resource
		await s2._resolve(py, rf2, _foes(s2)[0], "perfect")
		ok(py.second_resource == was, "§3b: a Mage without the meter banked %d on a Perfect" % (py.second_resource - was))
	await _clear(s2)
	# THE CLASS BASICS STAY PERFECTLESS — slot 0 resolves at a fixed Good (read off the corpus, the class-kit walk).
	var corpus := {}
	for cab in Classes.ability_corpus():
		corpus[cab.display_name] = cab
	# Their words carry none (IJ cleared them); a `perfect_id` left on one never fires, because slot 0 never grades.
	for basic in ["Strike", "Magic Bolt", "Smite"]:
		var bab: Ability = corpus.get(basic, null)
		ok(bab != null and bab.perfect_text == "", "§3: %s's words carry a Perfect" % basic)


# ── §4 — THE TWO NAMES ──────────────────────────────────────────────────────

func _s4_names() -> void:
	print("\n§4 — Iron Will and Undying Rage, on the node and every reader")
	var tree_nodes: Array = Talents.tree()
	var pairs := [["tn_iron_will", "Iron Will", "Mitigation per debuff you carry. ", "Mitigation per Debuff You Carry", "iron_will_ranks"],
		["tn_refuse_death", "Undying Rage", "Refuse death once. ", "Refuse Death Once", "undying_rage"]]
	var bat := _src("scripts/battle.gd")
	var unit := _src("scripts/unit.gd")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	for p in pairs:
		var node: Dictionary = Talents.node_in_tree(tree_nodes, String(p[0]))
		var nm := String(node.get("name", ""))
		var words := Talents.desc_for(node, 1)
		ok(nm == String(p[1]) and (node.get("payload", {}).get("stat", {}) as Dictionary).has(String(p[4])),
			"§4: %s is '%s' (want '%s', paying %s)" % [p[0], nm, p[1], p[4]])
		ok(words.begins_with(String(p[2])), "§4: %s's words do not open with its description ('%s')" % [p[0], words.substr(0, 50)])
		var same := tree_nodes.filter(func(n): return String((n as Dictionary).get("name", "")) == String(p[1]))
		ok(same.size() == 1, "§4: %d nodes are called %s" % [same.size(), p[1]])
		ok(Classes.pool_ability(String(p[1])) == null, "§4: an ability answers to %s" % p[1])
		ok(not bat.contains(String(p[3])) and not unit.contains(String(p[3])) and not _src("scripts/talents.gd").contains(String(p[3])),
			"§4: the old label %s still stands in the game's code" % p[3])
		ok(master.contains("<td>%s</td><td>%s" % [p[1], String(p[2]).strip_edges()]),
			"§4: master.html's talent row does not read %s and its description" % p[1])
		ok(not master.contains(String(p[3])), "§4: master.html still names %s" % p[3])
	ok(bat.contains("set_display_chip(\"iron_will\", \"Iron Will\"") and bat.contains("Talent: Iron Will —"),
		"§4: the node's name is on the Iron Will chip: %s; on its log line: %s" % [
			bat.contains("set_display_chip(\"iron_will\", \"Iron Will\""), bat.contains("Talent: Iron Will —")])
	ok(bat.contains("\"undying_rage\": [\"Undying Rage\""),
		"§4: the Undying Rage chip does not wear the node's name")
	ok(unit.count("Talent: Undying Rage —") == 2, "§4: the two refusal lines do not name Undying Rage (%d)" % unit.count("Talent: Undying Rage —"))


# ── §5 — A STRIKE, NAMED ONCE ───────────────────────────────────────────────

func _lost(scene: Node) -> int:
	var t := 0
	for e in scene.get("enemies"):
		t += (e as BattleUnit).max_hp - (e as BattleUnit).hp
	return t


# One cast on a calm board, its damage read off every enemy, the dice seeded so two boards cast alike.
func _cast_lost(scene: Node, u: BattleUnit, ab: Ability, target: BattleUnit, chill := false) -> int:
	_calm(scene, 100000)
	if chill:
		for e in _foes(scene):
			scene.call("_apply_status", e, "chilled", 3, 0, 0, u)
			scene.call("_apply_status", e, "chilled", 3, 0, 0, u)
	u.resource = 9999
	u.max_resource = 9999
	u.cooldowns.clear()
	var was := _lost(scene)
	seed(9137)
	await scene._resolve(u, ab, target, "good")
	return _lost(scene) - was


func _s5_strike() -> void:
	print("\n§5 — a strike, named once: the glossary, the eight texts, and what they say read off a fight")
	# (a) THE GLOSSARY's ENTRY, through the panel's door.
	var g: Dictionary = Glossary.entry("strike_damage")
	var gl := String(g.get("long", ""))
	ok(String(g.get("term", "")) == "Strike Damage" and String(g.get("category", "")) == "combat"
			and Glossary.in_category("combat").any(func(e): return String((e as Dictionary).get("id", "")) == "strike_damage"),
		"§5a: the glossary has no Strike Damage entry the combat panel lists")
	for clause in ["A strike is the damage an ability deals as its blow lands.",
			"A status's tick, a detonation, a bleedout burst, a reflection and a bomb are not strikes, and a bonus to strike damage does not reach them.",
			"a strike a card deals by a rule of its own, as a Killing Frost does",
			"a ward does not lessen a companion's blow."]:
		ok(gl.contains(clause), "§5a: the entry does not say: %s" % clause)
	# (b) THE EIGHT TEXTS AND THE WARD's CHIP, EACH THROUGH THE DOOR ITS SURFACE READS.
	var texts := {
		"relic emberheart": Relics.desc_of("emberheart"),
		"relic frostsigil": Relics.desc_of("frostsigil"),
		"relic nightbloom": Relics.desc_of("nightbloom"),
		"modifier tinderbox": String(_run.MODIFIERS["tinderbox"]["desc"]),
		"rune clarity": String(Runes.config("clarity").get("desc", "")),
		"rune profligate": String(Runes.config("profligate").get("desc", "")),
	}
	for kind in [["shieldmaster", "Shielding"], ["hollow_crown", "Regalia"]]:
		for eab in Enemies.config(String(kind[0]))["abilities"]:
			if (eab as Ability).display_name == String(kind[1]):
				texts["enemy %s" % kind[1]] = (eab as Ability).description
	var bsrc := _src("scripts/battle.gd")
	var chip_at := bsrc.find("\"shielded\": [\"Shielded\"")
	texts["chip shielded"] = bsrc.substr(chip_at, bsrc.find("\n", chip_at) - chip_at) if chip_at >= 0 else ""
	ok(texts.size() == 9, "§5b: %d of the nine texts read" % texts.size())
	for k in texts:
		ok(String(texts[k]).contains("strike damage"), "§5b: %s does not say strike damage ('%s')" % [k, texts[k]])
		ok(not String(texts[k]).contains("{="), "§5b: %s carries a raw token" % k)
		for dead in ["Fire and Holy damage +", "Frost and Arcane damage +", "Shadow and Nature damage +",
				"All fire damage +", "25% less damage taken", "Takes 25% less damage\\n", "% more damage and cost",
				"% more damage."]:
			ok(not String(texts[k]).contains(dead), "§5b: %s still says '%s'" % [k, dead])
	ok(String(texts["modifier tinderbox"]).contains("whoever deals it"), "§5b: Tinderbox lost *whoever deals it*")
	ok(String(texts["rune profligate"]).contains("a Killing Frost costs double and is paid nothing"),
		"§5b: Profligate does not name its asymmetry")
	var fig := "+%d%%" % int(round(float(Relics.POOL["emberheart"]["hooks"]["dmg_type_mult"]["fire"]) * 100.0))
	ok(String(texts["relic emberheart"]) == "Fire and Holy strike damage %s." % fig, "§5b: Emberheart reads '%s'" % texts["relic emberheart"])
	var clar := _body("scripts/battle.gd", "_resolve")
	ok(clar.contains("its strikes land") and not clar.contains("the spell lands")
			and clar.contains("if ab.special == \"\" and ab.heal <= 0:\n\t\t\t_log(\"   → Rune: Clarity"),
		"§5b: Clarity's line says its strikes land: %s; the old words are gone: %s; it is guarded to a spell that strikes: %s" % [
			clar.contains("its strikes land"), not clar.contains("the spell lands"),
			clar.contains("if ab.special == \"\" and ab.heal <= 0:\n\t\t\t_log(\"   → Rune: Clarity")])
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	for row in ["All fire strike damage +25%, whoever deals it.", "Takes 25% less strike damage", "more strike damage"]:
		ok(master.contains(row), "§5b: master.html does not read '%s'" % row)
	# (c) WHAT THE WORDS SAY, READ OFF THE FIGHT. Profligate prices a Killing Frost double and pays it nothing,
	# and pays a spell that strikes; the arms differ by the rune alone.
	var kills := {}
	for wear in [false, true]:
		var over := {1: {"bm_abilities": ["Killing Frost"], "bm_equipped": ["Killing Frost"],
			"runes": [_rune("profligate")] if wear else []}}
		var strike_card := _first_strike_card("mage", ["Reality Fracture", "Kindled Mind", "Arcane Bolt", "Unmaking"])
		if strike_card != "":
			over[1]["bm_abilities"].append(strike_card)
			over[1]["bm_equipped"].append(strike_card)
		var s: Node = await _board(["swordmaster", "cryomancer", "holy", "mystic"], over)
		var m := _hero(s, "mage")
		var kf := _card(m, "Killing Frost") if m != null else null
		var sc := _card(m, strike_card) if m != null and strike_card != "" else null
		ok(m != null and kf != null and sc != null, "§5c: the board seats a Cryomancer holding Killing Frost and %s" % strike_card)
		if m == null or kf == null or sc == null:
			await _clear(s)
			continue
		kills[wear] = {"kf": await _cast_lost(s, m, kf, _foes(s)[0], true),
			"price": int(s.call("_eff_cost", m, kf, null)),
			"strike": await _cast_lost(s, m, sc, _foes(s)[0]), "card": strike_card}
		await _clear(s)
	if kills.has(true) and kills.has(false):
		var a: Dictionary = kills[false]
		var b: Dictionary = kills[true]
		ok(int(b["kf"]) == int(a["kf"]) and int(a["kf"]) > 0, "§5c: Profligate paid a Killing Frost (%d against %d)" % [b["kf"], a["kf"]])
		ok(int(b["price"]) == 2 * int(a["price"]) and int(a["price"]) > 0, "§5c: Profligate did not double Killing Frost's price (%d against %d)" % [b["price"], a["price"]])
		var ratio := float(b["strike"]) / maxf(float(a["strike"]), 1.0)
		var pay := 1.0 + float(Runes.config("profligate")["payload"]["stat"]["rune_profligate"])
		ok(absf(ratio - pay) < 0.05, "§5c: Profligate's %s struck x%.3f — want the rune's x%.2f" % [b["card"], ratio, pay])
		print("    Profligate: Killing Frost %d / %d (price %d / %d); %s %d / %d (x%.3f)" % [a["kf"], b["kf"], a["price"], b["price"], b["card"], a["strike"], b["strike"], ratio])
	# THE WARD LESSENS A HERO's STRIKE, AND A COMPANION's BLOW IS FIGURED APART.
	var s2: Node = await _board(["swordmaster", "pyromancer", "holy", "mystic"], {})
	var w := _hero(s2, "warrior")
	var e0: BattleUnit = _foes(s2)[0]
	var bare := await _cast_lost(s2, w, w.abilities[0], e0)
	_calm(s2, 100000)
	s2.call("_apply_status", e0, "shielded", 3)
	var was2 := _lost(s2)
	seed(9137)
	await s2._resolve(w, w.abilities[0], e0, "good")
	var warded := _lost(s2) - was2
	var wr := float(warded) / maxf(float(bare), 1.0)
	# The ward's figure, read off the words a player reads (the chip's, which `check_ij` §3 pins to its inline code).
	var m_pct := RegEx.create_from_string("Takes (\\d+)% less strike damage").search(String(texts["chip shielded"]))
	var want_w := 1.0 - 0.01 * float(m_pct.get_string(1)) if m_pct != null else -1.0
	ok(bare > 0 and absf(wr - want_w) < 0.03, "§5c: the ward lessened a hero's strike x%.3f (%d against %d) — want x%.2f, the chip's" % [wr, warded, bare, want_w])
	await _clear(s2)
	ok(not _body("scripts/battle.gd", "_companion_hit").contains("\"shielded\"") and bsrc.contains("if strike_target.has_status(\"shielded\"):"),
		"§5c: the glossary's sentence needs the ward read at the strike and not at a companion's blow — the strike reads it: %s; the companion's blow reads it: %s" % [
			bsrc.contains("if strike_target.has_status(\"shielded\"):"), _body("scripts/battle.gd", "_companion_hit").contains("\"shielded\"")])
	var reads := _body("scripts/battle.gd", "_resolve").count("type_dmg_bonus.get(")
	var stamps := _body("scripts/battle.gd", "_stamp_modifier").count("type_dmg_bonus.get(")
	ok(reads == 1 and stamps == 1 and bsrc.count("type_dmg_bonus.get(") == reads + stamps,
		"§5c: the school bonus is read somewhere other than the strike (%d in the strike, %d in Tinderbox's stamp, %d in all)" % [
			reads, stamps, bsrc.count("type_dmg_bonus.get(")])


# ── §6 — CAIRNMOSS POULTICE CANNOT BE DRAWN, AND THE BOMB's LINE ────────────

func _fresh_relics(ids: Array) -> void:
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string(JSON.stringify(ids))
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _all(n: Node, cls: String) -> Array:
	var out: Array = []
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_back()
		if cur.is_class(cls) and not cur.is_queued_for_deletion():
			out.append(cur)
		for c in cur.get_children():
			stack.append(c)
	return out


func _s6_cairnmoss_and_the_bomb() -> void:
	print("\n§6 — Cairnmoss Poultice cannot be drawn; the bomb's line")
	var suspended: Array = Relics.POOL.keys().filter(func(id): return Relics.is_suspended(String(id)))
	print("    suspended: %s of %d relics" % [str(suspended), Relics.POOL.size()])
	ok(suspended.has("cairnmoss"), "§6: Cairnmoss Poultice is not suspended")
	for sid in suspended:
		var why := String(Relics.POOL[sid].get("suspended", ""))
		ok(why.contains("pays nothing") and why.contains("returns when"), "§6: %s's suspension does not say what is lost and what brings it back" % sid)
	ok(not Relics.is_suspended("coin"), "§6: a live relic reads as suspended — the door is blind")
	# KEPT: the entry resolves, and an unlock of it survives a load.
	ok(Relics.POOL.has("cairnmoss") and Relics.desc_of("cairnmoss") != "", "§6: Cairnmoss's entry no longer resolves")
	_fresh_relics(["cairnmoss", "coin"])
	ok(Relics.unlocked.has("cairnmoss"), "§6: a load dropped an unlock of the suspended relic")
	# THE BOSS's UNLOCK: never it — and with every other relic owned, nothing.
	var drew := 0
	for _i in 300:
		_fresh_relics([])
		var got: Dictionary = Relics.unlock_random()
		if String(got.get("id", "")) == "cairnmoss":
			drew += 1
	ok(drew == 0, "§6: the boss's unlock drew Cairnmoss %d times in 300" % drew)
	var all_but: Array = Relics.POOL.keys().filter(func(id): return id != "cairnmoss")
	_fresh_relics(all_but)
	ok(Relics.unlock_random().is_empty() and not Relics.unlocked.has("cairnmoss"),
		"§6: with every other relic owned the unlock handed out the suspended one")
	# AN EVENT's GRANT: never it — and with every other common held, gold instead.
	var active_was: Array = (_run.get("active_relics") as Array).duplicate()
	var gold_was := int(_run.get("gold"))
	var granted := 0
	for _j in 300:
		_run.set("active_relics", [])
		Events.apply(_run, {"effect": "relic_grant", "tier": "common"})
		if (_run.get("active_relics") as Array).has("cairnmoss"):
			granted += 1
	ok(granted == 0, "§6: an event granted Cairnmoss %d times in 300" % granted)
	var commons: Array = Relics.POOL.keys().filter(func(id): return String(Relics.POOL[id].get("tier", "common")) == "common" and id != "cairnmoss")
	_run.set("active_relics", commons.slice(0, 2))
	var last := Events.apply(_run, {"effect": "relic_grant", "tier": "common"})
	ok(last.begins_with("RELIC: ") and not last.contains("Cairnmoss"), "§6: a common grant with room did not grant a live common ('%s')" % last)
	_run.set("active_relics", active_was)
	_run.set("gold", gold_was)
	# THE DRAFT AND THE SHELF: unlocked, it draws no button and no panel; the relic beside it does.
	_profile_path = Profile.save_path
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	_fresh_relics(["cairnmoss", "coin"])
	_run.sim_run = false
	change_scene_to_file("res://scenes/draft.tscn")
	await Gate.frames(self, 6)
	var picker: Array = _all(current_scene, "Button").map(func(b): return String((b as Button).text))
	ok(picker.any(func(t): return String(t).contains("Gravewrought Coin")) and not picker.any(func(t): return String(t).contains("Cairnmoss")),
		"§6: the draft's assignment draws Cairnmoss, or not the coin beside it: %s" % str(picker.filter(func(t): return String(t).contains("Coin") or String(t).contains("Cairnmoss"))))
	change_scene_to_file("res://scenes/relics_screen.tscn")
	await Gate.frames(self, 6)
	var shelf: Array = _all(current_scene, "Label").map(func(l): return String((l as Label).text))
	ok(shelf.any(func(t): return String(t).begins_with("Gravewrought Coin")) and not shelf.any(func(t): return String(t).contains("Cairnmoss")),
		"§6: the shelf shows the coin beside it: %s; it shows Cairnmoss: %s" % [
			shelf.any(func(t): return String(t).begins_with("Gravewrought Coin")), shelf.any(func(t): return String(t).contains("Cairnmoss"))])
	if current_scene != null:
		current_scene.queue_free()
	await Gate.frames(self, 3)
	Relics.save_path = Relics.SAVE_PATH
	Relics.loaded = false
	Relics.unlocked = []
	Profile.save_path = String(_profile_path)
	Profile.loaded = false
	for p in [SCRATCH_RELICS, SCRATCH_PROFILE]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))
	# THE BOMB's LINE, IN THE ITEMS ENTRY — and true: a bomb's kill is no one's, it marks nothing and feeds nothing.
	# BATCH IM §0.5 RE-POINTED THIS ROW: the line is the pouch's one rule now, the potions' statuses beside the bomb's
	# damage (IL's ruling 5, the designer's), and it still says the bomb marks, feeds and claims nothing.
	var line := "No one deals a bomb's damage and no one lays a potion's status — the pouch belongs to all four heroes: a bomb marks nothing, feeds nothing and claims no kill"
	ok(String(Glossary.entry("consumables").get("long", "")).count(line) == 1, "§6: the items entry does not carry the bomb's line once")
	var s: Node = await _board(["berserker", "arcanist", "holy", "mystic"],
		{0: {"engines": _engines(["bloodrage", "savage_assault"])}, 1: {"engines": _engines(["siphon"])},
		3: {"engines": _engines(["quarry_hunt"])}})
	var war := _hero(s, "warrior")
	var mage := _hero(s, "mage")
	_calm(s, 100000)
	var foes: Array = _foes(s)
	var bomb_dmg: int = int(_run.bomb_damage()) if bool(_run.active) else int(_run.BOMB_BASE_DAMAGE)
	(foes[0] as BattleUnit).hp = maxi(bomb_dmg - 1, 1)
	mage.resource = 0
	var pouch: Dictionary = s.get("items")
	pouch["bomb"] = [String(_run.ITEM_INFO["bomb"][0]), 1, String(_run.ITEM_INFO["bomb"][1])]
	s.set("item_used", false)
	var kills_was := int(war.reaver_kills)
	var dealt_was := {}
	for h in s.get("heroes"):
		dealt_was[h] = int((h as BattleUnit).momentum_dealt)
	await s._use_item("bomb")
	ok((foes[0] as BattleUnit).dead, "§6: the bomb did not fell the enemy at %d health" % maxi(bomb_dmg - 1, 1))
	ok(int(war.reaver_kills) == kills_was, "§6: the Reaver claimed the bomb's kill")
	ok(mage.resource == 0, "§6: the bomb fed the Leech %d Mana" % mage.resource)
	var marked := 0
	for e in s.get("enemies"):
		if (e as BattleUnit).has_status("tracked") or (e as BattleUnit).has_status("judged"):
			marked += 1
	ok(marked == 0, "§6: the bomb laid %d marks" % marked)
	var moved := 0
	for h2 in dealt_was:
		if int((h2 as BattleUnit).momentum_dealt) != int(dealt_was[h2]):
			moved += 1
	ok(moved == 0, "§6: the bomb moved %d heroes' dealt ledgers" % moved)
	# THE POSITIVE ARMS: the same readers move for a hero's blow — the Leech's Mana and the Tracker's mark.
	mage.resource = 0
	await s._resolve(mage, mage.abilities[0], _foes(s)[0], "good")
	ok(mage.resource > 0, "§6: the Leech's own blow fed him nothing — the bomb's arm reads a dead door")
	var hunter := _hero(s, "hunter")
	await s._resolve(hunter, hunter.abilities[0], _foes(s)[0], "good")
	ok(_foes(s).any(func(e): return (e as BattleUnit).has_status("tracked")), "§6: the Tracker's own blow laid no mark — the bomb's arm reads a dead door")
	await _clear(s)


# ── §9 — THE PLAYER's FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
