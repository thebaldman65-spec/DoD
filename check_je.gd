# BATCH JE — THE TRACE SIZED, THE CEILING CUT, THE RUNES PRICED.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: the fall's block resized, the weight's rule, the verification's two rules as they stand reworded, the brief's negatives.
#   §1   THE TRACE, DRIVEN ON A REAL BOARD: a hero who fell reads the floor plus the relic adds and not the base (C01, C02); a hero at 1 health the
#        floor plus base plus relics; Cairnmoss closing the base and no more (C03); the figure the fall costs fixed whatever the relics (R01); the
#        third zone's boss restoring through its card's own button and on a resume (C04), taking the mark (C05), and the end boss fought whole.
#   §2   THE POOLED READING AND THE CAIRN's WEIGHT: the mean off the two arms, both arms kept, its error taking the covariance (C06); the rule
#        beside the one it refines (C07); the Cairn at the pool's top and the four rows read off the pool (C08); the deck closed (C13).
#   §3   THE CUT: the card law where a card is written and not in the archive (C09); what closed in the archive and gone from the rule file (C10).
#   §4   THE TURNS: every row of the count carries its population (C11); the three runes' figures unmoved.
#   §5   THE SPIRAL: every figure JD printed named, with whether it moved (C12).
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_je.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://je_profile.json"
const SCRATCH_RELICS := "user://je_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const BOSS := {"type": "boss", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const FELL := 1
const AT_ONE := 2
const REST := [0, 3]
# THE ONE EQUALITY HERE, AND IT IS A TRIPWIRE (the deck is closed by ruling, the same pin `check_jc` and `check_jd` hold).
const DECK_CLOSED_AT := 25
const LADDER_HEAD := "## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"
const FALL_HEAD := "## STANDING RULE — A FALL STAYS INSIDE ITS FIGHT"
const SHARPER := "THE SHARPER INSTRUMENT's REPLACES THE OTHER"
const POOLED := "ARE POOLED — INVERSE-VARIANCE — NOT CHOSEN BETWEEN"
const LAW_HEAD := "<h3>4.9b THE WORKING RULES OF THE TWO WORDS"
# EACH WORD THE MOVE MUST CARRY, THE STANDARD's OWN MARKUP IN IT: the two bullets the old §4.9 never held, the test, and the five reasons.
const LAW := ["THE TEST IS NOT \"DOES THE COLLECTION REACH ONE\"", "A CARD WHOSE WORDS SAY <i>HERO</i> OFFERS ONLY THE HEROES",
	"A PICK IS OFFERED WHERE THE CAST PAYS", "UNREACHABLE IS NOT EXCLUDED, AND IT IS NOT A SIXTH REASON", "THE SURVIVING USES OF \"party\" ARE IDENTIFIERS AND ARE NAMED"]

var _g := Gate.new()
var _run: Node
var _player := {}
var _docs := {}
var _key := "fell_last_fight"
var _floor := 0.2


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JE — THE TRACE SIZED, THE CEILING CUT, THE RUNES PRICED")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	var unit_consts: Dictionary = (load("res://scripts/unit.gd") as Script).get_script_constant_map()
	_key = String(unit_consts.get("FELL_LAST_FIGHT", _key))
	_floor = float(unit_consts.get("RETURN_FLOOR_PCT", _floor))
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH), "§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s0_the_rulings()
	await _s1a_the_relics_reach_him()
	await _s1b_cairnmoss_closes_the_base()
	await _s1c_every_text()
	await _s1d_the_third_boss()
	_s2a_the_pooled_reading()
	_s2b_the_cairn()
	_s3_the_cut()
	_s4_the_turns()
	_s5_the_spiral()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	if current_scene != null:
		current_scene.queue_free()
	await Gate.frames(self, 3)
	Relics.save_path = Relics.SAVE_PATH
	Relics.loaded = false
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		ok(now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1]), "%s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ───────────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


func _tsv(path: String, need: Array) -> Array:
	var lines := _doc(path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	var missing: Array = []
	for c in need:
		if not head.has(c):
			missing.append(c)
	ok(missing.is_empty(), "%s lacks the columns %s" % [path, str(missing)])
	var out: Array = []
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			continue
		var row := {}
		for i in head.size():
			row[head[i]] = f[i]
		out.append(row)
	return out


func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _new_run(relics: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, relics, "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(ENG4[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.items = {}


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _enter(relics: Array, zone: int, node: Dictionary) -> Node:
	_new_run(relics)
	_run.zone_idx = zone
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, node.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


# THE BOARD: the Mage down through the blow, the Cleric at 1 health, the other two at half, each through a damage door, then won the way every
# fight is won: each enemy down through the damage door, then `_check_end`.
func _fought(relics: Array, zone := 0, node: Dictionary = FOE) -> void:
	var s: Node = await _enter(relics, zone, node)
	var hs := _heroes(s)
	(hs[FELL] as BattleUnit).take_hit(999999, 0)
	var one: BattleUnit = hs[AT_ONE]
	one.take_tick_damage(one.hp - 1, "-1", Color.WHITE)
	for i in REST:
		var u: BattleUnit = hs[i]
		u.take_tick_damage(u.hp / 2, "-1", Color.WHITE)
	await process_frame
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			(e as BattleUnit).take_hit(999999, 0)
	s._check_end()
	await Gate.frames(self, 4)


func _max(i: int) -> int:
	return int(_run.party[i]["max_hp"])


func _floor_of(i: int) -> int:
	return int(_max(i) * _floor)


func _hp(i: int) -> int:
	return int(_run.party[i]["hp"])


func _note() -> String:
	return String(_run.call("clearing_heal_note")) if _run.has_method("clearing_heal_note") else ""


func _adds(relics: Array) -> float:
	return Relics.hook_add(relics, "victory_heal_pct")


func _draws(id: String, n: int) -> int:
	var got := 0
	for _i in n:
		_run.seen_events = []
		if Events.pick(_run) == id:
			got += 1
	return got


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each in the file it binds")
	var rules := _doc("res://CLAUDE.md")
	var fall := _flat(_block(rules, FALL_HEAD))
	ok(fall.contains("THE BASE CLEARING HEAL PASSES HIM BY, AND EVERY RELIC THAT ADDS TO IT REACHES HIM"), "§0.1: the rule's sentence is not in its block")
	ok(fall.contains("A FALL MUST COST THE SAME THING EVERY TIME"), "§0.1: the reason does not stand beside the rule")
	ok(not fall.contains("AND SO DOES EVERY RELIC THAT ADDS TO IT"), "§0.1: the block still says the relics pass him by")
	ok(fall.contains("ALL THREE ZONE BOSSES RESTORE, AND THE END BOSS IS FOUGHT WHOLE"), "§0.2: the ruling does not stand in the block")
	ok(not fall.contains("the third zone's boss has no descent"), "§0.2: the block still carries him onto the end boss")
	ok(fall.contains("a raise is the answer to a fall"), "§0.5: the block does not say why a hero raised draws no Cairn")
	ok(fall.contains("A WEIGHT GATES FREQUENCY AND A REQUIREMENT GATES RELEVANCE. DO NOT GATE TWICE"), "§0.4: the weight's rule is not in the block")
	var instr := _doc("res://docs/instrument-rules.md")
	ok(instr.contains("A RECON IS OWED WHEN THE GAME's CODE OR DATA MOVES"), "§7: the recon's rule is not in the instrument rules")
	ok(instr.contains("THE POSITIONAL RE-RUN RE-DERIVES ALL 489 READS EVERY BATCH"), "§7: the positional rule is not in the instrument rules")
	ok(instr.contains("AN ASSERTION WRITTEN TO PASS IS NOT A PREDICTION"), "§7: the prediction's floor is not in the instrument rules")
	ok(_doc("res://docs/ways-of-working.md").contains("A BRIEF THAT GIVES AN ABSENCE AS A REASON ORDERS THE READING THAT WOULD FIND IT"), "§0.7: the brief's rule is not in the ways of working")
	var fallen := String(Glossary.entry("fallen").get("long", ""))
	ok(fallen.contains("still down when the fight ends") and fallen.contains("reaches that hero"), "§0.5: the glossary does not say what the mark means or that a relic reaches him: %s" % fallen.substr(0, 60))


# ── §1 — THE TRACE, ON A REAL BOARD ───────────────────────────────────────────

# THE POPULATION IS THE HOOK'S, READ OFF THE POOL, SO THE NEXT RELIC ON IT IS DRIVEN WITH NOTHING WRITTEN HERE. Every set: no relic, each alone, all of them.
func _s1a_the_relics_reach_him() -> void:
	print("\n§1a — the relics reach the hero who fell; what the fall costs is the base")
	var on_hook: Array = Relics.POOL.keys().filter(func(id): return (Relics.POOL[id].get("hooks", {}) as Dictionary).has("victory_heal_pct"))
	ok(on_hook.size() >= 3, "§1a: the hook holds %d relics" % on_hook.size())
	var base: float = _run.SLOT_HEAL_PCT
	var sets: Array = [[]]
	for id in on_hook:
		sets.append([id])
	sets.append(on_hook.slice(0, 3))
	var gaps := {}
	for relics in sets:
		await _fought(relics)
		var adds := _adds(relics)
		var fell := _hp(FELL)
		var want_fell := _floor_of(FELL) + int(_max(FELL) * adds)
		var pct: float = _run.victory_heal_pct()
		var want_one := mini(_floor_of(AT_ONE) + int(_max(AT_ONE) * pct), _max(AT_ONE))
		print("    %s: the hero who fell %d of %d (%.1f%%); at 1 health %d of %d (%.1f%%)" % [str(relics), fell, _max(FELL), 100.0 * fell / _max(FELL), _hp(AT_ONE), _max(AT_ONE), 100.0 * _hp(AT_ONE) / _max(AT_ONE)])
		ok(fell == want_fell, "§1a: DRIVEN — with %s the hero who fell walks out at %d, the floor plus the relics is %d" % [str(relics), fell, want_fell])
		ok(_hp(AT_ONE) == want_one, "§1a: DRIVEN — with %s the hero at 1 health walks out at %d, the floor plus base plus relics is %d" % [str(relics), _hp(AT_ONE), want_one])
		# THE GAP, ON THE FELLED HERO's OWN MAXIMUM: what he would have held had he ended at the floor standing, less what he holds. It reads the base
		# whatever the relics, truncation aside, and it is never nothing.
		var gap := _floor_of(FELL) + int(_max(FELL) * pct) - fell
		gaps[str(relics)] = gap
		ok(absi(gap - int(_max(FELL) * base)) <= 1, "§1a: DRIVEN — with %s the fall costs %d points, and the base is %d" % [str(relics), gap, int(_max(FELL) * base)])
		ok(gap > 0, "§1a: DRIVEN — with %s the gap closed to nothing" % str(relics))
		ok(not (_run.party[FELL] as Dictionary).get(_key, false) == false, "§1a: the board did not mark him")
	print("    the fall's cost, in points of %d: %s" % [_max(FELL), str(gaps)])


func _s1b_cairnmoss_closes_the_base() -> void:
	print("\n§1b — Cairnmoss Poultice closes the base and no more")
	var hooks: Dictionary = Relics.POOL["cairnmoss"].get("hooks", {})
	ok(hooks.has("fallen_recover") and hooks.size() == 1, "§1b: Cairnmoss adds a figure of its own: %s" % str(hooks))
	for relics in [["cairnmoss"], ["cairnmoss", "chalice"]]:
		await _fought(relics)
		var pct: float = _run.victory_heal_pct()
		var want := _floor_of(FELL) + int(_max(FELL) * pct)
		ok(_hp(FELL) == want, "§1b: DRIVEN — with %s he walks out at %d, and what everyone takes from the floor is %d" % [str(relics), _hp(FELL), want])
		ok(is_equal_approx(pct, float(_run.SLOT_HEAL_PCT) + _adds(relics)), "§1b: DRIVEN — %s moved the heal itself (%.2f)" % [str(relics), pct])
		ok(_note() == "", "§1b: the victory card names an exception nothing made")


func _s1c_every_text() -> void:
	print("\n§1c — every text that states the base follows the constant; the relics' words and the victory card's")
	var base := int(round(float(_run.SLOT_HEAL_PCT) * 100))
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("heals every hero %d%% of max HP</b>, and that %d%% passes by a hero still down" % [base, base]), "§1c: master.html does not state the base the code holds (%d%%)" % base)
	ok(master.contains("heals every hero <b>%d%% of max HP</b>" % base), "§1c: master.html's second statement of the base is not the code's (%d%%)" % base)
	ok(master.contains("reaches that hero all the same"), "§1c: master.html does not say a relic reaches a hero who fell")
	ok(master.contains("All three zone bosses restore every hero"), "§1c: master.html still has the third zone's boss carrying him")
	ok(not master.contains("has no descent"), "§1c: master.html still says the third zone's boss has no descent")
	for id in ["chalice", "martyrbone", "hourglass"]:
		var d := _flat(String(Relics.desc_of(id)))
		ok(d.containsn("every hero heals") or d.containsn("every hero with Mana") and d.containsn("hero heals"), "§1c: %s's words are not every hero's: %s" % [id, d])
		ok(not d.contains("standing hero"), "§1c: %s's words still pass him by: %s" % [id, d])
	await _fought([])
	ok(_note().contains("does not"), "§1c: with no relic the victory card says '%s'" % _note())
	await _fought(["chalice"])
	ok(_note().contains("recovers %d%%" % int(round(_adds(["chalice"]) * 100))), "§1c: with a relic the victory card says '%s'" % _note())
	var src := Gate.strip_comments(_doc("res://scripts/run_state.gd"))
	ok(src.contains("func fallen_heal_pct()") and src.contains("heal_party(victory_heal_pct(), fallen_heal_pct())"), "§1c: the clearing heal does not read what a hero left down takes through its one door")


func _s1d_the_third_boss() -> void:
	print("\n§1d — the third zone's boss restores, through its card's own button, and takes the mark")
	# A REAL BOSS NODE ON THE THIRD BOARD, AND THE CARD's OWN BUTTON, BECAUSE THE GATE IN FRONT OF THE RESTORE IS THE SUBJECT.
	await _fought([], 2, BOSS)
	ok(bool((_run.party[FELL] as Dictionary).get(_key, false)), "§1d: the boss did not mark him")
	ok(not _run.has_next_zone(), "§1d: the third zone has a next zone, so this arm reads a descent")
	var was := _hp(FELL)
	ok(was == _floor_of(FELL), "§1d: he left the boss at %d, the floor is %d" % [was, _floor_of(FELL)])
	_run.party[FELL]["mana"] = 0
	var pressed := Gate.press(current_scene, ["Walk on"])
	ok(pressed != "", "§1d: the card's own button is not on the card")
	await Gate.frames(self, 6)
	ok(_hp(FELL) == _max(FELL), "§1d: DRIVEN — a hero is carried onto the end boss at %d of %d" % [_hp(FELL), _max(FELL)])
	ok(int(_run.party[FELL].get("max_mana", 0)) > 0 and int(_run.party[FELL].get("mana", 0)) == int(_run.party[FELL].get("max_mana", -1)), "§1d: DRIVEN — the third boss left his Mana at %d of %d" % [int(_run.party[FELL].get("mana", 0)), int(_run.party[FELL].get("max_mana", -1))])
	ok(not (_run.party[FELL] as Dictionary).has(_key), "§1d: DRIVEN — the restore left the mark on a hero it made whole")
	ok(_draws("fallen_cairn", 3000) == 0, "§1d: DRIVEN — the Cairn stands drawable on a hero the third boss restored")
	ok(_draws("abandoned_wagon", 3000) > 0, "§1d: the draw itself is dead, so the zero above reads nothing")
	ok(int(_run.zone_idx) == 2, "§1d: the third zone's boss descended into a zone that does not exist (%d)" % int(_run.zone_idx))
	ok(Gate.strip_comments(_doc("res://scripts/battle.gd")).contains("Run.leave_zone_boss()") and Gate.strip_comments(_doc("res://scripts/run_sim.gd")).contains("run.leave_zone_boss()"),
		"§1d: a way out of a boss's card goes around the one door")
	# A QUIT ON THAT CARD: the resume comes through the same door, so a quit cannot duck the restore.
	await _fought([], 2, BOSS)
	ok(_hp(FELL) == _floor_of(FELL), "§1d: the second board left him at %d" % _hp(FELL))
	_run.slot_idx = _run.BOSS_SLOT
	var next: String = _run.resume_scene()
	print("    a quit on the card resumes to %s" % next)
	ok(_hp(FELL) == _max(FELL) and not (_run.party[FELL] as Dictionary).has(_key), "§1d: DRIVEN — a quit on the third boss's card ducked the restore: %d, marked %s" % [_hp(FELL), (_run.party[FELL] as Dictionary).has(_key)])
	ok(next == "res://scenes/map.tscn", "§1d: the resume landed on %s" % next)
	# THE TWO WITH A DESCENT STILL DESCEND.
	await _fought([], 0, BOSS)
	ok(_run.has_next_zone(), "§1d: the first zone has no next zone")
	Gate.press(current_scene, ["Descend into"])
	await Gate.frames(self, 6)
	ok(int(_run.zone_idx) == 1 and _hp(FELL) == _max(FELL) and not (_run.party[FELL] as Dictionary).has(_key), "§1d: DRIVEN — the first zone's boss did not descend and restore: zone %d, %d of %d" % [int(_run.zone_idx), _hp(FELL), _max(FELL)])


# ── §2 — THE POOLED READING AND THE CAIRN ─────────────────────────────────────

func _s2a_the_pooled_reading() -> void:
	print("\n§2a — the two readings pooled, both kept, the error taking the covariance")
	var rows := _tsv("res://docs/reports/JE-pooled.tsv", ["arm", "population", "cost", "se", "n", "seeds", "fidelity"])
	var arms := {}
	for r in rows:
		arms[String(r["arm"])] = r
	ok(arms.has("JB §3") and arms.has("JD §5") and arms.has("pooled"), "§2a: the table does not hold both arms and the pool: %s" % str(arms.keys()))
	if arms.size() < 3:
		return
	var a := float(arms["JB §3"]["cost"])
	var sa := float(arms["JB §3"]["se"])
	var b := float(arms["JD §5"]["cost"])
	var sb := float(arms["JD §5"]["se"])
	var wa := 1.0 / (sa * sa)
	var wb := 1.0 / (sb * sb)
	var mean := (a * wa + b * wb) / (wa + wb)
	var share := wa / (wa + wb)
	var pooled := float(arms["pooled"]["cost"])
	var r := float(arms["pooled"]["r"])
	var se := sqrt(share * share * sa * sa + (1.0 - share) * (1.0 - share) * sb * sb + 2.0 * share * (1.0 - share) * r * sa * sb)
	print("    JB's %+.4f ± %.4f, JD's %+.4f ± %.4f: pooled %+.3f; ± %.3f independent, ± %.3f at r %.3f" % [a, sa, b, sb, mean, sqrt(1.0 / (wa + wb)), se, r])
	ok(absf(pooled - mean) < 0.001, "§2a: the pooled figure (%.4f) is not the two arms' inverse-variance mean (%.4f)" % [pooled, mean])
	ok(absf(pooled - a) > 0.05 and absf(pooled - b) > 0.05, "§2a: the pooled figure is an arm's (%.4f)" % pooled)
	ok(absf(float(arms["pooled"]["se"]) - se) < 0.002, "§2a: the pooled error (%s) is not the one the arms' covariance gives (%.3f)" % [arms["pooled"]["se"], se])
	ok(String(arms["JB §3"]["seeds"]) == String(arms["JD §5"]["seeds"]), "§2a: the two arms no longer name one seed block, and the covariance is for one")
	ok(r > 0.0 and r < 1.0, "§2a: the correlation reads %.3f" % r)
	var cut := 0.0
	for line in _doc("res://docs/reports/IZ-scale.tsv").split("\n", false):
		var f := line.split("\t")
		if f.size() > 9 and String(f[0]) == "5":
			cut = float(f[9])
	ok(cut > 12.0 and pooled < cut, "§2a: the pooled reading (%.3f) stands at or over the cut to 5 (%.3f), and no grade moves" % [pooled, cut])
	ok(int(_run.MODIFIERS["ambushed"].get("severity", 0)) == 4, "§2a: Ambushed was re-graded")
	ok(String(_run.MODIFIERS["ambushed"].get("graded", "")).contains("pooled"), "§2a: Ambushed's row does not name the pooled reading as its grade's")
	var grades := _flat(_block(_doc("res://docs/state.md"), "### THE BARGAIN DECK's GRADES"))
	var pooled_txt := "+%.3f" % mean
	ok(grades.contains(pooled_txt), "§2a: the grades table does not carry the pooled figure (%s)" % pooled_txt)
	ok(grades.contains("+12.02 ± 1.20") and grades.contains("+12.34 ± 1.46"), "§2a: the grades table does not keep both arms beside it")
	var ladder := _flat(_block(_doc("res://CLAUDE.md"), LADDER_HEAD))
	var sharper := ladder.find(SHARPER)
	var pool := ladder.find(POOLED)
	ok(sharper >= 0, "§2a: the rule it refines is gone: a refinement, not a replacement")
	ok(pool > sharper and pool - sharper < 1600, "§2a: the pooling rule does not stand beside the rule it refines (%d, %d)" % [sharper, pool])
	ok(ladder.contains("ITS ERROR TAKES THE COVARIANCE WHERE THE ARMS SHARE SEEDS"), "§2a: the rule does not say what the error takes")


func _s2b_the_cairn() -> void:
	print("\n§2b — the Cairn at the pool's top, the four rows read off the pool, the deck closed")
	var ev: Dictionary = Events.config("fallen_cairn")
	var top := 0
	var boons: Array = []
	for id in Events.ids():
		var e: Dictionary = Events.config(id)
		if String(e.get("kind", "")) == "boon":
			boons.append(id)
			top = maxi(top, int(e.get("weight", 0)))
	ok(int(ev.get("weight", 0)) == top, "§2b: the Cairn's weight is %d and the pool's top is %d" % [int(ev.get("weight", 0)), top])
	ok(ev.get("requires", {}).has("fell_last_fight"), "§2b: the Cairn no longer waits on a fall, so the weight reads another event")
	# THE FOUR ROWS: the pool's own weights by which boons stand in the row's condition, against the kept table.
	var rows := _tsv("res://docs/reports/JE-pool.tsv", ["row", "zone", "mystic", "boons", "total", "among_boons", "of_a_draw"])
	ok(rows.size() == 4, "§2b: the table holds %d rows" % rows.size())
	for r in rows:
		var zone := int(r["zone"])
		var mystic := String(r["mystic"]) == "yes"
		var total := 0
		var n := 0
		for id in boons:
			var req: Dictionary = Events.config(id).get("requires", {})
			if req.has("zone_slot") and not (req["zone_slot"] as Array).any(func(z): return int(z) == zone):
				continue
			# THE MAGE's BOON STANDS IN EVERY ROW: both parties the rows are read for field one.
			if (req.get("spec_in_party", []) as Array).has("mystic") and not mystic:
				continue
			total += int(Events.config(id).get("weight", 0))
			n += 1
		var among := 100.0 * int(ev.get("weight", 0)) / total
		print("    %s: %d boons, weight %d; the Cairn %.1f%% of boons, %.2f%% of a draw" % [r["row"], n, total, among, among * 0.25])
		ok(total == int(r["total"]) and n == int(r["boons"]), "§2b: row '%s' reads %d boons at %d, the pool holds %d at %d" % [r["row"], int(r["boons"]), int(r["total"]), n, total])
		ok(absf(among * 0.25 - float(r["of_a_draw"])) < 0.01, "§2b: row '%s' is not the pool's arithmetic" % r["row"])
	ok(_run.MODIFIERS.size() == DECK_CLOSED_AT, "§2b: the deck holds %d, and it is closed at %d" % [_run.MODIFIERS.size(), DECK_CLOSED_AT])


# ── §3 — THE CUT ──────────────────────────────────────────────────────────────

func _s3_the_cut() -> void:
	print("\n§3 — the law where a card is written, the history in the archive, the rule file lighter")
	var rules := _doc("res://CLAUDE.md")
	var std := _doc("res://docs/text-standard.html")
	var arch := _doc("res://DoD-archive/state-archive.md")
	var at := std.find(LAW_HEAD)
	ok(at >= 0, "§3: the text standard does not carry the law's heading")
	var law := std.substr(at, std.find("<h2>4.10", at) - at) if at >= 0 else ""
	for n in LAW:
		ok(law.contains(String(n)), "§3: the card law's '%s' is not where a card is written" % String(n).left(46))
		# ON THE ABSENCE, BESIDE THE ARM ABOVE: the law did not go to the archive with its history, which a card's author never opens.
		ok(not arch.contains(String(n)), "§3: the card law's '%s' stands in the archive" % String(n).left(46))
		ok(not rules.contains(String(n)), "§3: the card law's '%s' still stands in the rule file" % String(n).left(46))
	ok(rules.contains("HERO AND ALLY ARE THE ONLY TWO WORDS, AND THAT LAW IS THE STANDARD's §4.9"), "§3: the required read does not say where the law went")
	ok(rules.contains("**`docs/instrument-rules.md`**,\n  **`docs/combat-rules.md`**") or rules.contains("`docs/design-notes.md`, `docs/text-standard.html`"), "§3: the text standard is not on the must-stay-selected list")
	for h in ["## HERO AND ALLY ARE THE ONLY TWO WORDS", "## THE ALLY/HERO THREAD IS CLOSED", "## ~~THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE~~",
			"### ~~THE VAULT'S EXIT IS THE POOLS~~", "## ~~WHAT MAKES A ROW-8 NODE, AND BH'S FIFTEEN POINTS~~", "### ~~WHERE THE RETIRED RULE ITSELF IS KEPT~~"]:
		var at_head: String = "\n" + String(h)
		ok(not rules.contains(at_head), "§3: '%s' still stands in the rule file" % String(h).left(50))
		ok(arch.contains(at_head), "§3: '%s' was cut and the archive did not take it" % String(h).left(50))
	ok(arch.contains("**A BATCH THAT FINDS\nNOTHING TO WIDEN HAS STILL MEASURED SOMETHING**"), "§3: the thread was not archived byte for byte")


# ── §4 — THE TURNS ────────────────────────────────────────────────────────────

func _s4_the_turns() -> void:
	print("\n§4 — the turn count carries its population; the three runes unmoved")
	var rows := _tsv("res://docs/reports/JE-turns.tsv", ["population", "rung", "who", "fights", "falls", "median_won", "mean_won", "median_lost", "share_of_falls", "fidelity"])
	ok(rows.size() >= 12, "§4: the count holds %d rows" % rows.size())
	var bare: Array = []
	var pops := {}
	for r in rows:
		pops[String(r["population"])] = true
		if String(r["population"]).strip_edges() == "" or String(r["rung"]).strip_edges() == "" or String(r["fidelity"]).length() < 40:
			bare.append(r["who"])
	ok(bare.is_empty(), "§4: %d rows of the turn count carry no population or fidelity: %s" % [bare.size(), str(bare.slice(0, 4))])
	ok(pops.size() >= 2, "§4: the count reads %d population(s)" % pops.size())
	for spec in [["empty_pulpit", "dmg_taken_bonus", -0.50], ["dead_air", "dmg_bonus", 0.75], ["dirge", "dmg_bonus", 0.45]]:
		var cfg: Dictionary = Runes.config(String(spec[0]))
		var pay := str(cfg.get("payload", {}))
		ok(pay.contains(String(spec[1])) and pay.contains(str(spec[2])), "§4: %s's figure moved: %s" % [spec[0], pay.left(90)])


# ── §5 — THE SPIRAL ───────────────────────────────────────────────────────────

func _s5_the_spiral() -> void:
	print("\n§5 — every figure JD printed, named, with whether it moved")
	var rows := _tsv("res://docs/reports/JE-spiral.tsv", ["figure", "population", "gap", "jc_rule", "jd_rule", "je_rule", "moved", "fidelity"])
	ok(rows.size() >= 8, "§5: the table holds %d rows" % rows.size())
	var named := {}
	for r in rows:
		named[String(r["figure"])] = true
		ok(String(r["moved"]) in ["moved", "did not move", "not comparable"], "§5: '%s' does not say whether it moved: '%s'" % [r["figure"], r["moved"]])
		ok(String(r["fidelity"]).length() > 40, "§5: '%s' carries no fidelity" % r["figure"])
	for f in ["falls", "the same hero falling again", "lost finishes", "paired falls a run"]:
		ok(named.has(f), "§5: the table does not name '%s'" % f)
