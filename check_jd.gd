# BATCH JD — THE FALL REPAIRED, THE SEVEN DISPOSED.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: a fall stays inside its fight; the word's boundary stated beside the clause it
#        is about; the divisor a prior, written where the divisor stands; the census's *kills* row saying whose deaths it counts.
#   §1   THE FIGURE: the floor is one constant, the glossary reads it through its door, `master.html` states it and is held to it (R01),
#        and no living document says a hero who fell walks out above it (C04).
#   §2   THE RETURN, DRIVEN ON A REAL BOARD: a real fight, heroes down through the damage door, won through `_check_end`. A hero who
#        fell at the floor (C01); a hero at 1 health at the floor plus the clearing heal (C02); the others reached, which is what makes
#        *it did not reach him* a reading; every relic on the hook, derived, reaching the second and not the first (C03); Cairnmoss
#        lifting him; a hero raised inside the fight standing with the rest; the key through the save; the trace at the next fight's
#        spawn, and the one place it does not reach.
#   §3   ONE DEATH A BODY: the death callback once on a hero and on an enemy, a body raised able to fall again, no Break on a corpse;
#        and the road it happened on, a Sacred Resolve share under the bond felling the struck hero mid-strike (C05).
#   §4   THE FOUR DISPOSITIONS: the Cairn drawn after a real fall and not without one, the hero who fell made whole and nobody else
#        (C06, C07); Cairnmoss back in the pool (C08); no reader of the dead hook because it is gone, beside the hook that stays (C09);
#        the map potion's path gone, beside the battle's working (C10).
#   §5   THE ARM: every row is its own drive's reading, not JB's, its tie is the test's, and no grade moved (C11).
#   §7   WHAT IS NOT DONE: the deck closed, the three crest runes and the event vocabulary as they stood (C12).
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jd.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://jd_profile.json"
const SCRATCH_RELICS := "user://jd_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const BOND4 := ["bloodrage", "overburn", "covenant_oath", "pack"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const FELL := 1
const AT_ONE := 2
const REST := [0, 3]
# THE ONE EQUALITY HERE, AND IT IS A TRIPWIRE (the deck is closed by ruling, the same pin `check_jc` holds).
const DECK_CLOSED_AT := 25
const LADDER_HEAD := "## STANDING REFERENCE — THE DIFFICULTY LADDER AND THE END BOSS"
const CONDUCT_HEAD := "## Working agreement"
const FALL_HEAD := "## STANDING RULE — A FALL STAYS INSIDE ITS FIGHT"
const CENSUS_HEAD := "### THE SHARE CENSUS"
# The living documents §1 sweeps: every file that states what the game is, or what a batch reads as true.
const LIVING := ["res://CLAUDE.md", "res://docs/master.html", "res://docs/state.md", "res://docs/combat-rules.md",
	"res://docs/instrument-rules.md", "res://docs/ways-of-working.md", "res://docs/text-standard.html", "res://data/glossary.json",
	"res://data/events.json", "res://scripts/relics.gd", "res://scripts/run_state.gd", "res://scripts/unit.gd"]

var _g := Gate.new()
var _run: Node
var _player := {}
var _docs := {}
var _fns := {}
# READ OFF THE SCRIPT'S OWN MAP, NOT NAMED, SO HEAD's CODE RUNS UNDER THIS GATE AND REDS ON ITS ARMS RATHER THAN FAILING TO COMPILE (H01).
var _key := "fell_last_fight"
var _floor := 0.2


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JD — THE FALL REPAIRED, THE SEVEN DISPOSED")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	var unit_consts: Dictionary = (load("res://scripts/unit.gd") as Script).get_script_constant_map()
	_key = String(unit_consts.get("FELL_LAST_FIGHT", _key))
	_floor = float(unit_consts.get("RETURN_FLOOR_PCT", _floor))
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s0_the_rulings()
	_s1_the_figure()
	await _s2a_the_return()
	await _s2b_every_relic_on_the_hook()
	await _s2c_cairnmoss()
	await _s2d_a_hero_raised()
	await _s2e_the_key_and_the_trace()
	await _s3a_one_death_a_body()
	await _s3b_the_road()
	await _s4a_the_cairn()
	_s4b_the_relics()
	await _s4c_the_map_potion()
	_s5_the_arm()
	_s7_what_is_not_done()
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


func _new_run(engines: Array, relics: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, relics, "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
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


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


func _enter(engines: Array, relics: Array, potion := false, zone := 0) -> Node:
	_new_run(engines, relics)
	_run.zone_idx = zone
	if potion:
		_run.items = {"revive": 1}
	return await _next_fight()


func _next_fight() -> Node:
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


# THE ONE WAY A FIGHT ENDS HERE, THE WAY EVERY FIGHT ENDS: each enemy down through the damage door, then `_check_end`.
func _win(s: Node) -> void:
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			(e as BattleUnit).take_hit(999999, 0)
	s._check_end()
	await Gate.frames(self, 4)


# THE BOARD: the Mage down through the blow, the Cleric at 1 health, the other two at half, each through a damage door. Returns
# each seat's health as the fight ended, and the fight is won.
func _fought(relics: Array, zone := 0) -> Array:
	var s: Node = await _enter(ENG4, relics, false, zone)
	var hs := _heroes(s)
	(hs[FELL] as BattleUnit).take_hit(999999, 0)
	var one: BattleUnit = hs[AT_ONE]
	one.take_tick_damage(one.hp - 1, "-1", Color.WHITE)
	for i in REST:
		var u: BattleUnit = hs[i]
		u.take_tick_damage(u.hp / 2, "-1", Color.WHITE)
	await process_frame
	var ended: Array = []
	for u in hs:
		ended.append((u as BattleUnit).hp)
	await _win(s)
	return ended


func _note() -> String:
	return String(_run.call("clearing_heal_note")) if _run.has_method("clearing_heal_note") else ""


func _floor_of(i: int) -> int:
	return int(int(_run.party[i]["max_hp"]) * _floor)


func _healed(i: int, ended: int, pct: float) -> int:
	var mx := int(_run.party[i]["max_hp"])
	return mini(clampi(maxi(ended, _floor_of(i)), 1, mx) + int(mx * pct), mx)


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each in the file it binds")
	var rules := _doc("res://CLAUDE.md")
	var fall := _flat(_block(rules, FALL_HEAD))
	ok(fall.contains("THE FALL DOES NOT LAST"), "§0.1: the ruling does not stand in its block")
	ok(fall.contains("THE CLEARING HEAL PASSES HIM BY, AND SO DOES EVERY RELIC THAT ADDS TO IT"), "§0.1: the rule's sentence is not in its block")
	ok(fall.contains("a hero raised inside the fight"), "§0.1: the block does not say whom the key names")
	var conduct := _flat(_block(rules, CONDUCT_HEAD))
	var clause := conduct.find("IT SETTLES WHO DECIDES IN FLIGHT, NOT WHAT A BATCH MAY AUTHOR")
	var para := conduct.find("THE WORD REMOVES THE QUESTION, NOT THE RULING")
	ok(clause >= 0, "§0.3: the clause is gone from the batch-conduct rules")
	ok(para > clause and para - clause < 700, "§0.3: the boundary's paragraph does not stand beside the clause (%d, %d)" % [clause, para])
	ok(_flat(_block(rules, LADDER_HEAD)).contains("THE DIVISOR IS A PRIOR FOR A VALUE THAT HAS NOT BEEN BUILT"), "§0.4: the correction does not stand where the divisor stands")
	ok(_flat(_block(rules, LADDER_HEAD)).contains("DIVIDE BY ABOUT TWO AND A HALF"), "§0.4: the sentence it corrects is gone")
	var census := _flat(_block(_doc("res://docs/state.md"), CENSUS_HEAD))
	ok(census.contains("THE DIVISOR IS A PRIOR"), "§0.4: the census's own block does not say the divisor is a prior")
	var kills := ""
	for line in _doc("res://docs/reports/JA-shares.tsv").split("\n", false):
		if line.begins_with("kills\t"):
			kills = line
	ok(kills.contains("companion") and kills.contains("is_hero"), "§0.5: the census's kills row does not say a companion's death is on the heroes' side")
	ok(census.contains("| kills, a companion's death counted |"), "§0.5: the state's copy of the row does not say so either")


# ── §1 — THE FIGURE ───────────────────────────────────────────────────────────

func _s1_the_figure() -> void:
	print("\n§1 — the floor, one constant, every text holding it")
	var pct := int(round(_floor * 100))
	ok(_doc("res://scripts/unit.gd").contains("int(save_max * RETURN_FLOOR_PCT)"), "§1: the return does not read the constant")
	var fallen := String(Glossary.entry("fallen").get("long", ""))
	ok(fallen.contains("at least %d%% of their max HP" % pct) and not fallen.contains("{="), "§1: the glossary does not read the floor through its door: %s" % fallen.substr(0, 60))
	ok(fallen.contains("passes that hero by"), "§1: the glossary's fallen entry does not say the victory's heal passes that hero by")
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("Fallen heroes return after a won battle at %d%% max HP" % pct), "§1: master.html does not state the floor the code holds (%d%%)" % pct)
	ok(master.contains("returns the fallen at %d%% of maximum" % pct), "§1: master.html's second statement of the floor is not the code's (%d%%)" % pct)
	ok(master.contains("passes by a hero still down"), "§1: master.html still says a victory heals every hero")
	ok(_flat(_doc("res://CLAUDE.md")).contains("WALKS OUT AT THE %d%% FLOOR" % pct), "§1: the rule's own headline does not state the floor the code holds (%d%%)" % pct)
	# THE ABSENCE, BESIDE THE TWO ABOVE: no living document says he walks out above the floor. A sentence that names Cairnmoss is the
	# one place he does, and it is the relic's rule.
	var rx := RegEx.new()
	rx.compile("[^.|\\n]*\\b35%[^.|\\n]*")
	var stale: Array = []
	var read := 0
	for path in LIVING:
		var text := _flat(_doc(path))
		read += 1 if text.length() > 0 else 0
		for m in rx.search_all(text):
			var s := m.get_string()
			if (s.containsn("fell") or s.containsn("fallen") or s.containsn("falls")) \
					and (s.containsn("walk") or s.containsn("return") or s.containsn("leaves") or s.containsn("stands at")) \
					and not s.containsn("Cairnmoss"):
				stale.append("%s: %s" % [path, s.strip_edges().substr(0, 100)])
	print("    CHECKED %d of %d living files; the floor reads %d%%" % [read, LIVING.size(), pct])
	ok(read == LIVING.size(), "§1: the sweep read %d of %d files" % [read, LIVING.size()])
	ok(stale.is_empty(), "§1: %d living statements put a hero who fell above the floor: %s" % [stale.size(), str(stale)])


# ── §2 — THE RETURN, ON A REAL BOARD ──────────────────────────────────────────

func _s2a_the_return() -> void:
	print("\n§2a — the return, on a real board, no relic")
	var ended := await _fought([])
	var pct: float = _run.victory_heal_pct()
	var fell := int(_run.party[FELL]["hp"])
	var one := int(_run.party[AT_ONE]["hp"])
	print("    fell %d of %d; at 1 health %d of %d; the floor %d, the heal %.2f" % [fell, _run.party[FELL]["max_hp"], one, _run.party[AT_ONE]["max_hp"], _floor_of(FELL), pct])
	ok(ended[FELL] == 0, "§2a: the board's hero did not fall (%d)" % ended[FELL])
	ok(ended[AT_ONE] == 1, "§2a: the board's second hero did not end at 1 health (%d)" % ended[AT_ONE])
	ok(fell == _floor_of(FELL), "§2a: DRIVEN — the hero who fell walks out at %d, and the floor is %d" % [fell, _floor_of(FELL)])
	ok(one == _healed(AT_ONE, 1, pct), "§2a: DRIVEN — the hero at 1 health walks out at %d, not the floor plus the clearing heal (%d)" % [one, _healed(AT_ONE, 1, pct)])
	ok(one > _floor_of(AT_ONE), "§2a: DRIVEN — the survivor lost the clearing heal (%d, the floor %d)" % [one, _floor_of(AT_ONE)])
	for i in REST:
		ok(int(_run.party[i]["hp"]) == _healed(i, ended[i], pct),
			"§2a: DRIVEN — the clearing heal did not reach seat %d: %d, wanted %d" % [i, int(_run.party[i]["hp"]), _healed(i, ended[i], pct)])
	ok(_note() != "", "§2a: the victory card says the heroes recover and names no exception")
	ok(_doc("res://scripts/battle.gd").contains("Run.clearing_heal()") and _doc("res://scripts/run_sim.gd").contains("run.clearing_heal()"),
		"§2a: a victory branch does not call the one door")
	ok(not _doc("res://scripts/battle.gd").contains("heal_party(Run.victory_heal_pct())") and not _doc("res://scripts/run_sim.gd").contains("heal_party(run.victory_heal_pct())"),
		"§2a: a victory branch goes around the door")


# THE POPULATION IS THE HOOK'S, READ OFF THE POOL, SO THE NEXT RELIC ON IT IS DRIVEN WITH NOTHING WRITTEN HERE.
func _s2b_every_relic_on_the_hook() -> void:
	print("\n§2b — every relic on the hook reaches the second hero and not the first")
	var on_hook: Array = Relics.POOL.keys().filter(func(id): return (Relics.POOL[id].get("hooks", {}) as Dictionary).has("victory_heal_pct"))
	print("    the hook's relics: %s" % str(on_hook))
	ok(on_hook.size() >= 3, "§2b: the hook holds %d relics" % on_hook.size())
	for id in on_hook + ["*"]:
		var carried: Array = on_hook.slice(0, 3) if id == "*" else [id]
		var ended := await _fought(carried)
		var pct: float = _run.victory_heal_pct()
		ok(pct > _run.SLOT_HEAL_PCT, "§2b: %s lifted no heal" % str(carried))
		ok(int(_run.party[FELL]["hp"]) == _floor_of(FELL), "§2b: DRIVEN — %s reached the hero who fell: %d, the floor %d" % [str(carried), int(_run.party[FELL]["hp"]), _floor_of(FELL)])
		ok(int(_run.party[AT_ONE]["hp"]) == _healed(AT_ONE, 1, pct), "§2b: DRIVEN — %s did not reach the hero at 1 health: %d, wanted %d" % [str(carried), int(_run.party[AT_ONE]["hp"]), _healed(AT_ONE, 1, pct)])
		var said: bool = id == "*" or String(Relics.desc_of(String(id))).contains("standing hero")
		ok(said, "§2b: %s's words say every hero: %s" % [str(id), Relics.desc_of(String(id)) if id != "*" else ""])


func _s2c_cairnmoss() -> void:
	print("\n§2c — Cairnmoss Poultice: the hero who fell recovers with the rest")
	var ended := await _fought(["cairnmoss"])
	var pct: float = _run.victory_heal_pct()
	ok(is_equal_approx(pct, _run.SLOT_HEAL_PCT), "§2c: the relic moved the heal itself (%.2f)" % pct)
	ok(int(_run.party[FELL]["hp"]) == _healed(FELL, 0, pct), "§2c: DRIVEN — with it the hero who fell walks out at %d, wanted %d" % [int(_run.party[FELL]["hp"]), _healed(FELL, 0, pct)])
	ok(int(_run.party[AT_ONE]["hp"]) == _healed(AT_ONE, 1, pct), "§2c: DRIVEN — with it the hero at 1 health walks out at %d" % int(_run.party[AT_ONE]["hp"]))
	ok(_note() == "", "§2c: the victory card names an exception nothing made")
	ended = await _fought(["cairnmoss", "chalice"])
	pct = _run.victory_heal_pct()
	ok(int(_run.party[FELL]["hp"]) == _healed(FELL, 0, pct), "§2c: DRIVEN — beside a relic on the hook he does not take what everyone takes: %d, wanted %d" % [int(_run.party[FELL]["hp"]), _healed(FELL, 0, pct)])
	ok(ended.size() == 4, "§2c: the board moved")


func _s2d_a_hero_raised() -> void:
	print("\n§2d — a hero raised inside the fight stands, and the heal reaches him")
	var s: Node = await _enter(ENG4, [], true)
	var hs := _heroes(s)
	var u: BattleUnit = hs[FELL]
	u.take_hit(999999, 0)
	await process_frame
	s.set("item_used", false)
	s._use_item("revive")
	await process_frame
	ok(not u.dead, "§2d: the potion did not raise him (the battle's own door)")
	var back := u.hp
	await _win(s)
	ok(not (_run.party[FELL] as Dictionary).has(_key), "§2d: a hero raised inside the fight is marked as one who fell")
	ok(int(_run.party[FELL]["hp"]) == _healed(FELL, back, _run.victory_heal_pct()), "§2d: DRIVEN — the heal passed by a hero who stood at the end: %d from %d" % [int(_run.party[FELL]["hp"]), back])


func _s2e_the_key_and_the_trace() -> void:
	print("\n§2e — the key, the save, the trace, and where the trace stops")
	await _fought([])
	var fell_m: Dictionary = _run.party[FELL]
	ok(bool(fell_m.get(_key, false)), "§2e: the return did not mark the hero who fell")
	for i in [0, AT_ONE, 3]:
		ok(not (_run.party[i] as Dictionary).has(_key), "§2e: seat %d is marked and did not fall" % i)
	_run.save_run()
	ok(_run.load_run(), "§2e: the save the return wrote did not load")
	ok(bool((_run.party[FELL] as Dictionary).get(_key, false)), "§2e: the key did not ride the save")
	var floor_was := int(_run.party[FELL]["hp"])
	var s: Node = await _next_fight()
	var hs := _heroes(s)
	var opened: Array = hs.map(func(u): return (u as BattleUnit).hp)
	print("    the next fight opens at %s" % str(opened))
	ok((hs[FELL] as BattleUnit).hp == floor_was, "§2e: DRIVEN — the next fight opened him at %d, and he walked out at %d" % [(hs[FELL] as BattleUnit).hp, floor_was])
	# A fight nobody fell in takes the mark away, and leaves no key behind.
	await _win(s)
	ok(not (_run.party[FELL] as Dictionary).has(_key), "§2e: the mark outlived a fight he stood through")
	# WHERE THE MARK STOPS, THROUGH THE VICTORY CARD's OWN BUTTON, BECAUSE THE GATE IN FRONT OF THE RESTORE IS THE SUBJECT: zone 1's and zone
	# 2's descents restore every hero and take it, and the third zone's boss has no descent, so he meets the end boss at the floor.
	await _fought([])
	ok(bool((_run.party[FELL] as Dictionary).get(_key, false)), "§2e: the second board did not mark him")
	ok(_run.has_next_zone(), "§2e: the first zone has no next zone")
	current_scene._next_zone()
	await Gate.frames(self, 6)
	ok(int(_run.party[FELL]["hp"]) == int(_run.party[FELL]["max_hp"]) and not (_run.party[FELL] as Dictionary).has(_key),
		"§2e: a new zone left a mark on a hero it restored")
	await _fought([], 2)
	var at_floor := int(_run.party[FELL]["hp"])
	ok(not _run.has_next_zone(), "§2e: the third zone has a next zone")
	current_scene._next_zone()
	await Gate.frames(self, 6)
	ok(int(_run.party[FELL]["hp"]) == at_floor and at_floor == _floor_of(FELL), "§2e: DRIVEN — the third zone's boss restored him: %d, the floor %d" % [int(_run.party[FELL]["hp"]), at_floor])
	ok(bool((_run.party[FELL] as Dictionary).get(_key, false)), "§2e: DRIVEN — the third zone's boss took the mark")


# ── §3 — ONE DEATH A BODY ─────────────────────────────────────────────────────

func _counted(u: BattleUnit) -> Array:
	var n := [0]
	var was: Callable = u.died_cb
	u.died_cb = func(x):
		n[0] += 1
		was.call(x)
	return n


func _s3a_one_death_a_body() -> void:
	print("\n§3a — the death callback runs once a body, and a body raised can fall again")
	var s: Node = await _enter(ENG4, [])
	var u: BattleUnit = _heroes(s)[FELL]
	var n := _counted(u)
	u.take_hit(999999, 0)
	ok(n[0] == 1 and u.dead, "§3a: the first death ran the callback %d times" % n[0])
	u.take_hit(50, 999)
	ok(n[0] == 1, "§3a: a blow on the corpse ran the death callback again (%d)" % n[0])
	ok(not u.broken and not u.broken_pending and not u.has_status("broken"), "§3a: a blow on the corpse laid a Break")
	u._die()
	ok(n[0] == 1, "§3a: a second call ran the death callback again (%d)" % n[0])
	u.revive(0.5)
	ok(not u.dead and not u.broken and not u.broken_pending, "§3a: the raised body rose wrong: dead %s, broken %s" % [u.dead, u.broken])
	u.take_hit(999999, 0)
	ok(n[0] == 2 and u.dead, "§3a: a body raised cannot fall again: the callback ran %d times" % n[0])
	var e: BattleUnit = s.get("enemies")[0]
	var m := _counted(e)
	e.take_hit(999999, 0)
	e.take_hit(50, 999)
	e._die()
	ok(m[0] == 1 and e.dead, "§3a: an enemy's death ran the callback %d times" % m[0])


# THE ROAD IT HAPPENED ON, BUILT RATHER THAN WAITED FOR: two in 360 runs. A blow on the Mage, the souls bound, the Cleric bound to the
# Mage by the oath: the Cleric's share of the blow comes back on the Mage as a tick and fells him, and the blow then lands on the corpse
# with the meter one short of full.
func _s3b_the_road() -> void:
	print("\n§3b — the road: a share under the bond fells the struck hero mid-strike")
	var felled := false
	for attempt in 12:
		var s: Node = await _enter(BOND4, [])
		var hs := _heroes(s)
		var mage: BattleUnit = hs[FELL]
		var cleric: BattleUnit = hs[AT_ONE]
		if cleric.covenant_partner() != mage:
			ok(false, "§3b: the oath bound the Cleric to %s" % str(cleric.covenant_partner()))
			return
		for h in hs:
			s._apply_status(h, "unity", 4, 0, 0, cleric)
		var e: BattleUnit = s.get("enemies")[0]
		e.attack = 400
		var ab: Ability = e.abilities[0]
		var n := _counted(mage)
		mage.hp = 2
		mage.pressure = mage.stability - 1
		await s._resolve(e, ab, mage, "good")
		await process_frame
		if not mage.dead:
			continue
		felled = true
		var text := _log_text(s)
		print("    attempt %d: fell, the callback ran %d times; broken %s" % [attempt, n[0], mage.broken])
		ok(text.contains("falls under the oath"), "§3b: the oath did not fell him, so this arm drove another road")
		ok(n[0] == 1, "§3b: DRIVEN — the strike ran the death callback %d times on one body" % n[0])
		ok(not mage.broken and not mage.has_status("broken"), "§3b: DRIVEN — the strike Broke the corpse")
		ok(text.count("the bond passes on") + text.count("the bond ends") == 1, "§3b: the bond moved more than once")
		break
	ok(felled, "§3b: twelve strikes did not fell him; the road is not driven")


# ── §4 — THE FOUR DISPOSITIONS ────────────────────────────────────────────────

func _draws(id: String, n: int) -> int:
	var got := 0
	for _i in n:
		_run.seen_events = []
		if Events.pick(_run) == id:
			got += 1
	return got


func _s4a_the_cairn() -> void:
	print("\n§4a — the Cairn, after a real fall")
	var ev: Dictionary = Events.config("fallen_cairn")
	ok(int(ev.get("weight", 0)) == 8, "§4a: the Cairn's weight moved (%d)" % int(ev.get("weight", 0)))
	ok(not (ev.get("requires", {}) as Dictionary).has("fallen_hero"), "§4a: the Cairn still asks for a member at 0 health")
	await _fought([])
	var drawn := _draws("fallen_cairn", 3000)
	print("    a real fall: drawn %d of 3000" % drawn)
	ok(drawn > 0, "§4a: DRIVEN — the event is never drawn after a real fall")
	# THE BOON, OFF THE CHOICE ITSELF.
	var choices: Array = ev.get("choices", [])
	ok(choices.size() == 2 and (choices[1].get("effects", []) as Array).is_empty(), "§4a: the second choice costs or pays something now")
	var was: Array = (_run.party as Array).map(func(m): return int(m["hp"]))
	ok(was[FELL] < int(_run.party[FELL]["max_hp"]), "§4a: the board left him whole, so the boon reads nothing")
	for fx in choices[0].get("effects", []):
		Events.apply(_run, fx)
	ok(int(_run.party[FELL]["hp"]) == int(_run.party[FELL]["max_hp"]), "§4a: DRIVEN — the hero who fell was not made whole: %d of %d" % [int(_run.party[FELL]["hp"]), int(_run.party[FELL]["max_hp"])])
	for i in [0, AT_ONE, 3]:
		ok(int(_run.party[i]["hp"]) == was[i], "§4a: DRIVEN — the boon reached seat %d: %d from %d" % [i, int(_run.party[i]["hp"]), was[i]])
	# NO FALL, NO CAIRN, AND THE OTHER EVENTS STILL DRAW.
	await _fought([])
	current_scene._next_zone()
	await Gate.frames(self, 6)
	ok(_draws("fallen_cairn", 3000) == 0, "§4a: DRIVEN — a new zone left the Cairn drawable on a hero it restored")
	ok(_draws("abandoned_wagon", 3000) > 0, "§4a: the draw itself is dead, so the zero above reads nothing")


func _s4b_the_relics() -> void:
	print("\n§4b — Cairnmoss Poultice and Martyr's Knucklebone")
	ok(not Relics.is_suspended("cairnmoss"), "§4b: Cairnmoss Poultice is still suspended")
	var moss: Dictionary = Relics.POOL["cairnmoss"].get("hooks", {})
	ok(moss.has("fallen_recover") and moss.size() == 1, "§4b: Cairnmoss Poultice reads the wrong hook: %s" % str(moss))
	ok(String(Relics.POOL["cairnmoss"].get("tier", "")) == "common", "§4b: Cairnmoss Poultice is no longer a common relic")
	ok(String(Relics.desc_of("cairnmoss")).contains("recovers with the rest"), "§4b: its words moved: %s" % Relics.desc_of("cairnmoss"))
	var bone: Dictionary = Relics.POOL["martyrbone"].get("hooks", {})
	ok(is_equal_approx(float(bone.get("victory_heal_pct", 0.0)), 0.15), "§4b: the Knucklebone's figure moved: %s" % str(bone))
	# THE ABSENCE: comments stripped, because a record of the removal names the thing removed.
	var dead_hook := "rest_" + "heal_add"
	var holders: Array = []
	var read := 0
	for path in ["res://scripts/relics.gd", "res://scripts/run_state.gd", "res://scripts/battle.gd", "res://scripts/run_sim.gd", "res://scripts/map_screen.gd",
			"res://scripts/events.gd", "res://data/events.json"]:
		read += 1
		if Gate.strip_comments(_doc(path)).contains(dead_hook):
			holders.append(path)
	print("    CHECKED %d files for the dead hook" % read)
	ok(holders.is_empty(), "§4b: the dead hook stands in %s, with no reader" % str(holders))
	ok(Gate.strip_comments(_doc("res://scripts/run_state.gd")).contains("relic_add(\"fallen_recover\")"), "§4b: the hook that replaced it has no reader, so the absence above reads a sweep of nothing")


func _s4c_the_map_potion() -> void:
	print("\n§4c — the map's Revive Potion: the path gone, the battle's standing")
	var path := "scripts/map_screen.gd"
	var use := Gate.fn_body(path, "_use_item", _fns)
	var apply := Gate.fn_body(path, "_apply_item", _fns)
	ok(use.contains("_open_target_picker"), "§4c: the sweep read no `_use_item`")
	ok(apply.contains("\"health\":"), "§4c: the sweep read no `_apply_item`")
	ok(not use.contains("wants_dead"), "§4c: the map still offers the fallen")
	ok(not apply.contains("\"revive\":"), "§4c: the map's fallen branch is back")
	var refused: Dictionary = (load("res://scripts/map_screen.gd") as Script).get_script_constant_map()["MAP_REFUSAL"]
	ok(refused.has("revive"), "§4c: the map's button is lit on a potion it cannot use")
	# THE POSITIVE ARM: the potion raises a fallen hero in a fight, at its figure.
	var s: Node = await _enter(ENG4, [], true)
	var u: BattleUnit = _heroes(s)[FELL]
	u.take_hit(999999, 0)
	await process_frame
	s.set("item_used", false)
	s._use_item("revive")
	await process_frame
	ok(not u.dead and u.hp == int(u.max_hp * 0.5), "§4c: DRIVEN — the potion did not raise him in a fight: dead %s, %d of %d" % [u.dead, u.hp, u.max_hp])
	ok(int((s.get("items") as Dictionary)["revive"][1]) == 0, "§4c: the fight did not spend the potion")


# ── §5 — THE ARM ──────────────────────────────────────────────────────────────

func _s5_the_arm() -> void:
	print("\n§5 — the arm: its own reading, its tie the test's, no grade moved")
	var rows := _tsv("res://docs/reports/JD-arm.tsv", ["arm", "population", "runs", "completed", "reading", "se", "cost", "d_se", "z", "jb_cost", "jb_se", "diff", "diff_se", "verdict", "fidelity"])
	var jb := {}
	for line in _doc("res://docs/reports/JB-grades.tsv").split("\n", false):
		var f := line.split("\t")
		if f.size() > 12 and String(f[0]) == "Ambushed":
			jb["the default four"] = [float(f[4]), float(f[5])]
			jb["the incumbent"] = [float(f[10]), float(f[11])]
	ok(jb.size() == 2, "§5: JB's row was not read")
	var armed := 0
	for r in rows:
		if String(r["arm"]) != "ambushed at 8":
			continue
		armed += 1
		var pop := String(r["population"])
		var cost := float(r["cost"])
		var jc: float = jb[pop][0]
		var js: float = jb[pop][1]
		ok(not is_equal_approx(cost, jc), "§5: %s: the reading is JB's figure (%.4f), not this tree's" % [pop, cost])
		ok(is_equal_approx(float(r["jb_cost"]), jc) and is_equal_approx(float(r["jb_se"]), js), "§5: %s: the row misquotes JB's reading" % pop)
		var diff := cost - jc
		var se := sqrt(float(r["d_se"]) ** 2 + js ** 2)
		var tie: bool = absf(diff) <= 2.0 * se
		ok(is_equal_approx(float(r["diff"]), snappedf(diff, 0.0001)) or absf(float(r["diff"]) - diff) < 0.001, "§5: %s: the difference is not its two readings'" % pop)
		ok(absf(float(r["diff_se"]) - se) < 0.001, "§5: %s: the error of the difference is not its two errors'" % pop)
		ok((String(r["verdict"]) == "tie") == tie, "§5: %s: the row says %s and the test says %s" % [pop, r["verdict"], "tie" if tie else "moved"])
		print("    %s: %+.2f ± %.2f against JB's %+.2f ± %.2f: %s" % [pop, cost, float(r["d_se"]), jc, js, r["verdict"]])
		ok(String(r["fidelity"]).length() > 40, "§5: %s: the row carries no population or fidelity" % pop)
	ok(armed == 2, "§5: the table holds %d arms, and the brief names both populations" % armed)
	# NOTHING RE-GRADED: the card reads what it read.
	ok(int(_run.MODIFIERS["ambushed"].get("severity", 0)) == 4, "§5: Ambushed was re-graded, and that is the designer's")


# ── §7 — WHAT IS NOT DONE ─────────────────────────────────────────────────────

func _s7_what_is_not_done() -> void:
	print("\n§7 — what is deliberately not done")
	ok(_run.MODIFIERS.size() == DECK_CLOSED_AT, "§7: the deck holds %d, and it is closed at %d" % [_run.MODIFIERS.size(), DECK_CLOSED_AT])
	var battle := _doc("res://scripts/battle.gd")
	ok(battle.contains("func _lay_down_the_fallen()"), "§7: the resumed fight's door moved")
	ok(_doc("res://scripts/readout.gd").contains("func hero_fell(u) -> void:"), "§7: the readout's fall moved")
	ok(Events.VERBS.has("revive_pct"), "§7: the event vocabulary lost a verb nothing asked it to lose")
