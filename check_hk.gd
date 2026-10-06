# BATCH HK — RUNES DROP, AND THERE IS A BAG.
#
#   §0  THE GROUND — this process writes the harness save, and scratch meta files
#   §1  THE DROP — a normal fight won drops ONE rune into the bag, and the victory
#       card names it; an elite, a mini-boss and a zone boss won drop none (each
#       pays its own spoils, read beside it); the drop is one of the party's
#       classes, never a rune the party holds, and GV's engine gate holds at it
#   §2  THE BAG — twenty; a worn rune does not count; a drop on a full bag waits
#       and the map shows it beside the twenty — drop one to take it, or leave it;
#       equip from the bag and unequip back into it through the hero's panel; a
#       full bag refuses an Unequip and a Swap always goes through
#   §3  THE PEDDLER — 150g a rune and a third back; a purchase lands in the bag;
#       two presses sell one; a full bag greys every Buy and says so; never a rune
#       the party holds; GV's engine gate at his door, both ways
#   §4  THE CREST (the `party` scope) — no fixture in the file, and every door
#       working over a fixture party rune built in this gate: the scope, the drop,
#       the Peddler, the bag, the one slot, and every hero's numbers at the spawn
#   §5  THE SAVE — the bag, the crest and the waiting drops round-trip; a save from
#       before the bag migrates: what a hero wore he still wears, in the same
#       slots, and every rune he held unworn is in the bag — none lost, even past
#       twenty; the refusal floor did not move
#   §6  THE SIM — the bot takes the drop through the game's door, under its policy
#   §7  THE ROAD — a whole run on the real screens: drops after every normal fight,
#       the bag filling, the full-bag panel answered both ways, a sale and a
#       purchase at a Peddler, and a rune equipped from the bag and put back
#   §8  THE PLAYER'S FILES — as this gate found them
#
# **BATCH HR §1 RE-POINTED §1, §2, §3, §5, §6 AND §7 TO THE SPLIT HOLDINGS** (ruled): a
# class or core rune is held unworn by the hero of its class, eight at most, and the bag
# holds the crest's runes, six at most. Each arm asks HK's question of the holding that
# took the bag's place — a drop lands once where its kind lands, a hero's eight fill and
# the next waits on HIS panel, a full holding refuses an Unequip and his own Buy, a save
# from before the bag keeps its heroes' runes where they held them — and its reason is
# at the site. The bag's own arms (§2h, §4) ask it of a crest rune. `check_hr` drives
# what is HR's alone.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM** (the brief's rule): a refusal is
# asked where it must pass on the same state, an absence beside the arm that shows
# the window held something, so a door wired shut, or a walk over nothing, reads
# red rather than green.
#
# **§4's PARTY RUNES ARE FIXTURES, AND §4 ASSERTS BOTH HALVES**: none of them in
# `data/runes.json`, and the machinery live over one this gate builds and puts into
# `Runes`' loaded table for §4 alone — never into the file — removed before §5.
# (None was authored until HO §3; the two the file holds since are `check_ho`'s.)
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hk.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://hk_profile.json"
const SCRATCH_RELICS := "user://hk_relics.json"
const SCRATCH_SAVE := "user://hk_scratch_save.bin"
const DROP_SEED := 20260928
const ROAD_SEED := 20260929
const FRAME_CAP := 30000
const MAX_STEPS := 900
# §4's fixture party runes. Built here, put into the loaded table for §4 and taken
# out again. HK authored none (ruled); the two the file holds since HO §3 are driven
# by `check_ho`, and §4 asks the file only that neither fixture reached it.
const CREST_A := "hk_fixture_crest_a"
const CREST_B := "hk_fixture_crest_b"
const CREST_HP := 7

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HK — RUNES DROP, AND THERE IS A BAG")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	await _s1_the_drop()
	await _s2_the_bag()
	await _s3_the_peddler()
	await _s4_the_crest()
	_s5_the_save()
	_s6_the_sim()
	_fresh_meta()
	await _s7_the_road()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s8_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

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


# A fresh run of `keys`, every hero awakened on his class's FIRST engine rune — a
# fixed seat, so what each hero can be offered is the same on every run.
func _new_run(keys: Array = SEATS) -> void:
	_run.sim_run = false
	_run.new_run(keys, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true


func _names(runes: Array) -> Array:
	var out: Array = []
	for r in runes:
		out.append(String((r as Dictionary).get("name", "")))
	return out


# Every rune the party holds, by name — read the long way, off each list, so it
# is not `Run.party_rune_names` asked about itself.
func _held() -> Array:
	var out: Array = _names(_run.rune_bag) + _names(_run.pending_rune_drops) + _names(_run.party_runes)
	for m in _run.party:
		out.append_array(_names((m as Dictionary).get("runes", [])))
		out.append_array(_names((m as Dictionary).get("engines", [])))
	return out


# The ids every hero could be offered right now, less what the party holds.
func _union_offerable() -> Array:
	var held := _held()
	var out: Array = []
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


# Put `ids` into the party's hands (the bag, then the queue once it is full), so a
# draw's pool can be narrowed to exactly what a check wants left in it.
func _hold_all(ids: Array) -> void:
	for id in ids:
		_run.bag_rune(Runes.build(String(id)))


func _clear_bag() -> void:
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


# Fight one encounter of `ty` on the real battle scene, won on autoplay with the
# enemy's attacks off (`check_gj`'s switches), and return the scene on its card.
func _fight(ty: String) -> Node:
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	# Through the fixture's door into the battle scene (`check_da` §3, DB §1), with
	# this run's own party and bag — `Gate.spawn` would start a new run.
	Gate.enter_battle(self, {"type": ty, "enemies": _run.compose(ty)})
	await Gate.frames(self, 4)
	var s: Node = current_scene
	var guard := 0
	while _is_battle(s) and not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	await Gate.frames(self, 6)
	return current_scene


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	return current_scene


func _row_where(rows: Array, src: String) -> int:
	for i in rows.size():
		if String(rows[i]["src"]) == src:
			return i
	return -1


# BATCH HR §1 — the first row a hero holds and does not wear: what `_row_where(rows,
# "bag")` found while his unworn runes lived in the bag.
func _row_held(rows: Array) -> int:
	for i in rows.size():
		if not bool(rows[i]["worn"]):
			return i
	return -1


# A hero's runes he holds and does not wear, by name, read off both lists.
func _unworn(m: Dictionary) -> Array:
	var out: Array = []
	for key in ["runes", "engines"]:
		for r in m.get(key, []):
			if not bool((r as Dictionary).get("equipped", false)):
				out.append(String((r as Dictionary).get("name", "")))
	return out


# How many places hold a rune of this name: the bag, the waiting queue, the crest and
# every hero's two lists. One is right for a rune just put down.
func _places(nm: String) -> int:
	return _held().count(nm)


# Hand `member` his own class's ordinary runes through the one door until he holds
# `n` unworn — named runes from the data, on the hero who can wear them (HO §1's rule),
# never one the party already holds. Drawn from his CLASS's live entries rather than
# from what he can be offered: a fresh hero is offered a handful (HC §3), fewer than eight.
func _fill_holding(member: Dictionary, n: int) -> void:
	var held_now := _held()
	var ids: Array = []
	for id in Runes.ids():
		var e: Dictionary = Runes.config(String(id))
		if String(e.get("retired", "")) == "" and not Runes.is_engine_rune(String(id)) \
				and String(e.get("scope", "")) == "class:%s" % String(member["key"]) \
				and not held_now.has(Runes.display_name(e)):
			ids.append(String(id))
	var k := 0
	while _run.held_count(member) < n and k < ids.size():
		_run.hold_rune(member, Runes.build(String(ids[k])))
		k += 1


func _fixture_crest(id: String, nm: String) -> Dictionary:
	return {"name": nm, "scope": "party", "price": 150,
		"desc": "A fixture of check_hk, never in the file.",
		"payload": {"stat": {"max_hp": CREST_HP}}}


# ── §1 — THE DROP ───────────────────────────────────────────────────────────

func _s1_the_drop() -> void:
	print("\n§1 — the drop: one rune after a normal fight, and none after the three that pay their own")
	seed(DROP_SEED)
	_new_run()
	# (a) A NORMAL FIGHT WON DROPS ONE RUNE, AND ITS CARD SAYS SO.
	# BATCH HR §1 — RE-POINTED: the drop goes where its kind lands — held unworn by the
	# hero of its class, or into the bag for a crest rune — where HK sent every drop into
	# the bag. Each arm asks the same question of the new place.
	var held_before: int = _held().size()
	var s := await _fight("fight")
	ok(_is_battle(s) and bool(s.get("battle_over")), "§1a: the normal fight did not end")
	var drop: Dictionary = _run.last_drop
	var dropped := String((drop.get("rune", {}) as Dictionary).get("name", ""))
	ok(dropped != "" and _held().size() == held_before + 1 and _places(dropped) == 1
			and _run.pending_rune_drops.is_empty(),
		"§1a: a normal fight won dropped %d runes (want one, held once: %s)" % [_held().size() - held_before, dropped])
	ok(dropped != "" and Gate.has_text(s, "RUNE DROP: %s" % dropped),
		"§1a: the victory card does not name the drop (%s)" % dropped)
	var crest_drop := Runes.is_party_rune(drop.get("rune", {}))
	var hi := int(drop.get("hero", -1))
	var says := "into the bag." if crest_drop else ("for the %s" % _run.nameplate(_run.party[hi]) if hi >= 0 else "<no hero>")
	ok(dropped != "" and Gate.has_text(s, says), "§1a: the card does not say where the drop went (%s)" % says)
	ok(dropped != "" and (crest_drop and _names(_run.rune_bag).has(dropped)
			or (not crest_drop and hi >= 0 and _unworn(_run.party[hi]).has(dropped)
				and Runes.wearable_by(drop.get("rune", {}), _run.party[hi]))),
		"§1a: the drop is not held where its kind lands — its hero unworn, or the bag for a crest rune")
	# (b) AN ELITE WON DROPS NONE — and pays its own rune reward, the cache, beside it.
	# BATCH HR §1 — counted over everything held, not the bag: a drop can land on a hero.
	var bag0: int = _held().size()
	var owed0 := 0
	for m in _run.party:
		owed0 += int((m as Dictionary).get("rune_picks_owed", 0))
	s = await _fight("elite")
	var owed1 := 0
	for m in _run.party:
		owed1 += int((m as Dictionary).get("rune_picks_owed", 0))
	ok(_is_battle(s) and bool(s.get("battle_over")), "§1b: the elite fight did not end")
	ok(_held().size() == bag0 and not Gate.has_text(s, "RUNE DROP:"),
		"§1b: an elite won dropped a rune (held %d -> %d)" % [bag0, _held().size()])
	ok(owed1 == owed0 + 1 and Gate.has_text(s, "RUNE CACHE:"),
		"§1b: ...and the elite did not pay its own cache beside it (owed %d -> %d) — the no-drop reading asked nothing" % [owed0, owed1])
	# (c) A MINI-BOSS WON DROPS NONE — it pays an upgrade pick.
	bag0 = _held().size()
	s = await _fight("miniboss")
	var ups := 0
	for m in _run.party:
		ups += int((m as Dictionary).get("up_picks_owed", 0))
	ok(_held().size() == bag0 and not Gate.has_text(s, "RUNE DROP:"),
		"§1c: a mini-boss won dropped a rune")
	ok(ups > 0 and Gate.has_text(s, "THE WAY IS OPEN"),
		"§1c: ...and the mini-boss paid no upgrade pick beside it (%d owed)" % ups)
	# (d) A ZONE BOSS WON DROPS NONE — it pays an ability pick.
	bag0 = _held().size()
	_run.slot_idx = _run.BOSS_SLOT
	s = await _fight("boss")
	var picks := 0
	for m in _run.party:
		picks += int((m as Dictionary).get("bm_picks_owed", 0))
	ok(_held().size() == bag0 and not Gate.has_text(s, "RUNE DROP:"),
		"§1d: a zone boss won dropped a rune")
	ok(picks > 0, "§1d: ...and the zone boss paid no ability pick beside it")
	# (e) THE SITE: the one call, under the normal fight's node type, in the victory
	# branch — and `_resolve_boss` reaches none.
	var bat := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var ce := bat.find("func _check_end() -> void:")
	var ce_end := bat.find("\nfunc ", ce + 10)
	var body := bat.substr(ce, ce_end - ce)
	ok(body.count("_fight_drop_line()") == 1 and body.contains("if node_type == \"fight\":\n\t\t\tspoils += _fight_drop_line()"),
		"§1e: `_check_end`'s victory branch does not call the drop once, under the normal fight's type")
	var rb := bat.find("func _resolve_boss(")
	var rb_body := bat.substr(rb, bat.find("\nfunc ", rb + 10) - rb)
	ok(rb > 0 and not rb_body.contains("drop_after_fight") and not rb_body.contains("_fight_drop_line"),
		"§1e: `_resolve_boss` reaches the drop")
	# (f) ONLY CLASSES PRESENT: a party with no Hunter is never dropped a Hunter rune
	# — and IS dropped its Warriors' (the positive arm), from 400 seeded draws.
	seed(DROP_SEED)
	_new_run(["warrior", "warrior", "mage", "cleric"])
	var seen_class := {}
	var crest_drops := 0
	for _i in 400:
		var r: Dictionary = _run.roll_fight_drop()
		if not r.is_empty():
			seen_class[Runes.rune_class(r)] = int(seen_class.get(Runes.rune_class(r), 0)) + 1
			if Runes.is_party_rune(r):
				crest_drops += 1
	ok(not seen_class.has("hunter"), "§1f: a party with no Hunter was dropped %d Hunter runes" % int(seen_class.get("hunter", 0)))
	ok(int(seen_class.get("warrior", 0)) > 0 and int(seen_class.get("mage", 0)) > 0
			and int(seen_class.get("cleric", 0)) > 0,
		"§1f: ...and the classes it holds were not all dropped (%s) — the absence read nothing" % [seen_class])
	# BATCH HO §3 — THE DROPS ARE A PARTITION: a class the party holds, or the crest.
	# A crest rune has no class, so it fell into a bucket the two arms above never
	# read; the bucket is held to the crest's own drops, and they do drop.
	ok(seen_class.keys().all(func(k): return ["warrior", "mage", "cleric", ""].has(String(k)))
			and int(seen_class.get("", 0)) == crest_drops,
		"§1f: a drop was neither a class the party holds nor a crest rune (%s, %d of them the crest's)" % [seen_class, crest_drops])
	ok(crest_drops > 0, "§1f: 400 drops held no crest rune — the file's two are in every party's union")
	# (g) NEVER A RUNE THE PARTY HOLDS: hold all but one of what the party could be
	# dropped, and the drop is that one; hold it too, and there is nothing to drop.
	_new_run()
	var pool := _union_offerable()
	ok(pool.size() > 20, "§1g: the party could be dropped only %d runes — the construction below needs more" % pool.size())
	var last := String(pool.back())
	_hold_all(pool.slice(0, pool.size() - 1))
	var only: Dictionary = _run.roll_fight_drop()
	ok(String(only.get("id", "")) == last,
		"§1g: with all but %s held, the drop was %s" % [last, only.get("id", "<nothing>")])
	_run.bag_rune(Runes.build(last))
	ok(_run.roll_fight_drop().is_empty(), "§1g: with everything held, something still dropped — a rune the party holds")
	# (h) GV'S GATE AT THIS DOOR: the Mage's engine rows cannot drop while his engine
	# is out of its slot, and can the moment it is back.
	_new_run()
	var mage: Dictionary = _run.party[1]
	var mage_pid := String(Runes.held_engines(mage)[0])
	var rows_for := []
	for id in Runes.ENGINE_READ:
		if Runes.engine_read(String(id)) == mage_pid:
			rows_for.append(String(id))
	ok(not rows_for.is_empty(), "§1h: the Mage's first engine gates no rune — the gate cannot be asked here")
	var engine_idx := _row_where(_run.engine_rows(mage), "hero")
	ok(_run.toggle_engine(mage, engine_idx), "§1h: the Mage's engine would not come out of its slot")
	var ungated := _union_offerable().filter(func(x): return not rows_for.has(String(x)))
	_hold_all(ungated)
	ok(_run.roll_fight_drop().is_empty(),
		"§1h: with every ungated rune held and the engine out, a drop still came — the gate did not hold")
	var er: Array = _run.engine_rows(mage)
	# BATCH HR §1 — the unslotted engine is held on him, not in the bag.
	ok(_run.toggle_engine(mage, _row_held(er)), "§1h: the Mage's engine would not go back into its slot")
	var gated: Dictionary = _run.roll_fight_drop()
	ok(rows_for.has(String(gated.get("id", ""))),
		"§1h: ...and with it slotted, the drop was not one of its rows (%s) — the gate is shut, not a gate" % gated.get("id", "<nothing>"))


# ── §2 — THE BAG ────────────────────────────────────────────────────────────

func _s2_the_bag() -> void:
	# BATCH HR §1 — RE-POINTED, EVERY ARM. HK's bag of twenty held every rune nobody wore;
	# since HR a class or core rune is held unworn by its hero, eight at most, and the bag
	# holds the crest's runes. Each lettered arm asks HK's question of the holding that
	# replaced the bag: (a)-(g) a hero's, (h) the bag's own panel, with a crest rune in it.
	print("\n§2 — the holdings: eight a hero, the full-holding panel, and equipping through it")
	ok(int(_run.HERO_HOLD_CAP) == 8 and int(_run.BAG_CAP) == 6,
		"§2: a hero holds %d and the bag %d, not the proposed eight and six" % [int(_run.HERO_HOLD_CAP), int(_run.BAG_CAP)])
	seed(DROP_SEED + 2)
	_new_run()
	# (a) DROPS LAND ON THEIR HEROES; THE ONE THAT FINDS ITS HERO HOLDING EIGHT WAITS.
	var landed := 0
	var waited: Dictionary = {}
	var guard := 0
	while waited.is_empty() and guard < 400:
		var d: Dictionary = _run.drop_after_fight()
		guard += 1
		if d.is_empty():
			break
		if String(d.get("where", "")) == "pending":
			waited = d
		else:
			landed += 1
	var wi := int(waited.get("hero", -1))
	var waiting := String((waited.get("rune", {}) as Dictionary).get("name", ""))
	print("    %d drops landed before one found its hero full (%s)" % [landed, _run.nameplate(_run.party[wi]) if wi >= 0 else "none"])
	ok(wi >= 0 and _run.held_count(_run.party[wi]) == int(_run.HERO_HOLD_CAP) and _run.pending_rune_drops.size() == 1,
		"§2a: no drop found its hero holding eight and waited (%d drops)" % guard)
	ok(wi >= 0 and _run.pending_holder(waited.get("rune", {})) == wi,
		"§2a: the waiting rune is not bound for the hero who is full")
	ok(waiting != "" and _held().has(waiting) and _run.party_rune_names().has(waiting),
		"§2a: the rune waiting on the panel is not the party's — it could be offered twice")
	# (b) THE PANEL, ON THE REAL MAP: shown beside his eight; a drop takes it.
	var mp := await _to_map()
	var fb: Node = Gate.overlay(mp, 74)
	ok(fb != null and wi >= 0 and Gate.has_text(fb, "THE %s HOLDS ALL HE CAN" % _run.nameplate(_run.party[wi]).to_upper())
			and Gate.has_text(fb, waiting),
		"§2b: the map did not show the waiting drop on its hero's full-holding panel")
	var drop_btns: Array = []
	if fb != null:
		var all_b: Array = []
		Gate.buttons(fb, all_b)
		for b in all_b:
			if String((b as Button).text) == "Drop this":
				drop_btns.append(b)
	ok(drop_btns.size() == int(_run.HERO_HOLD_CAP), "§2b: the panel offers %d runes to drop, not his eight" % drop_btns.size())
	var victim := String((_run.held_rows(_run.party[wi])[3]["rune"] as Dictionary).get("name", "")) if wi >= 0 else ""
	var b3: Button = Gate.bound_button(fb, "_take_pending_drop", [3, fb]) if fb != null else null
	ok(b3 != null, "§2b: the fourth row's Drop button is not bound to its row")
	if b3 != null:
		b3.emit_signal("pressed")
		await Gate.frames(self, 4)
	ok(wi >= 0 and _run.held_count(_run.party[wi]) == int(_run.HERO_HOLD_CAP) and _unworn(_run.party[wi]).has(waiting),
		"§2b: dropping one did not put the waiting rune in his holding")
	ok(not _held().has(victim), "§2b: the rune dropped for it is still held — nothing was given up")
	# (c) DECLINING THE DROP ITSELF IS ALLOWED.
	var second := ""
	guard = 0
	while second == "" and guard < 400:
		var d2: Dictionary = _run.drop_after_fight()
		guard += 1
		if d2.is_empty():
			break
		if String(d2.get("where", "")) == "pending":
			second = String((d2.get("rune", {}) as Dictionary).get("name", ""))
	var held_total: int = 0
	for m in _run.party:
		held_total += _run.held_count(m)
	mp = await _to_map()
	fb = Gate.overlay(mp, 74)
	var left := Gate.press(fb, ["Leave "]) if fb != null else ""
	await Gate.frames(self, 4)
	var held_after: int = 0
	for m in _run.party:
		held_after += _run.held_count(m)
	ok(left == "Leave %s behind" % second, "§2c: the panel's decline did not name the drop (%s)" % left)
	ok(_run.pending_rune_drops.is_empty() and not _held().has(second) and held_after == held_total,
		"§2c: leaving the drop behind kept it, or took a rune from a hero")
	# (d) A WORN RUNE DOES NOT COUNT: equip three of his held runes through the panel's
	# own button, and five more fit before he holds eight.
	_clear_bag()
	_new_run()
	var w: Dictionary = _run.party[0]
	_fill_holding(w, 4)
	ok(_run.held_count(w) == 4, "§2d: the Warrior could be handed only %d of his runes" % _run.held_count(w))
	mp = await _to_map()
	for k in 3:
		mp.call("_open_rune_panel", 0)
		await process_frame
		var ov: Node = Gate.overlay(current_scene, 60)
		var rows: Array = _run.rune_rows(w)
		var bi := _row_held(rows)
		var eq: Button = Gate.bound_button(ov, "_toggle_rune", [0, bi, ov]) if ov != null else null
		ok(eq != null and String(eq.text) == "Equip", "§2d: the panel drew no Equip for a held rune (%s)" % [k])
		if eq != null:
			eq.emit_signal("pressed")
		await Gate.frames(self, 2)
		mp = current_scene
	ok(_run.runes_worn(w) == 3 and _run.held_count(w) == 1,
		"§2d: equipping three of his held runes left %d worn and %d held" % [_run.runes_worn(w), _run.held_count(w)])
	_fill_holding(w, int(_run.HERO_HOLD_CAP))
	ok(_run.held_count(w) == int(_run.HERO_HOLD_CAP) and _run.pending_rune_drops.is_empty(),
		"§2d: with three worn he took %d before a wait — a worn rune is counted against his eight" % _run.held_count(w))
	# (e) FULL HOLDING, FULL SLOTS: Unequip refused and saying why, Swap goes through.
	mp = await _to_map()
	mp.call("_open_rune_panel", 0)
	await process_frame
	var ov2: Node = Gate.overlay(current_scene, 60)
	var worn_i := -1
	var rows2: Array = _run.rune_rows(w)
	for i in rows2.size():
		if bool(rows2[i]["worn"]) and worn_i < 0:
			worn_i = i
	var worn_btn: Button = null
	var all2: Array = []
	Gate.buttons(ov2, all2, false)
	for b in all2:
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_toggle_rune" and cb.get_bound_arguments() == [0, worn_i, ov2]:
				worn_btn = b
	ok(worn_btn != null and worn_btn.disabled and String(worn_btn.tooltip_text) == String(_run.held_full_note()),
		"§2e: a full holding did not refuse the Unequip with its sentence")
	ok(_run.rune_toggle_refusal(w, worn_i) == String(_run.held_full_note()) and not _run.toggle_rune(w, worn_i),
		"§2e: the door let a worn rune into a full holding")
	var swap_btn: Button = null
	for b in all2:
		if String((b as Button).text) == "Swap" and not (b as Button).disabled:
			swap_btn = b
	ok(swap_btn != null, "§2e: with every slot full, no held rune offered a Swap")
	if swap_btn != null:
		swap_btn.emit_signal("pressed")
		await process_frame
	var ch: Node = Gate.overlay(current_scene, 80)
	var worn_before: Array = _names(w["runes"].filter(func(r): return bool(r.get("equipped", false))))
	var took := Gate.press(ch, [String(worn_before[0])]) if ch != null and not worn_before.is_empty() else ""
	await Gate.frames(self, 3)
	var worn_now: Array = _names(w["runes"].filter(func(r): return bool(r.get("equipped", false))))
	ok(took != "" and _run.held_count(w) == int(_run.HERO_HOLD_CAP) and not worn_now.has(worn_before[0])
			and _unworn(w).has(String(worn_before[0])),
		"§2e: the swap did not put a held rune on in the worn one's place, his holding unchanged at eight")
	# (f) UNEQUIP INTO HIS HOLDING, once there is room — the positive arm of (e).
	_run.drop_held_rune(w, 0)
	rows2 = _run.rune_rows(w)
	worn_i = -1
	for i in rows2.size():
		if bool(rows2[i]["worn"]) and worn_i < 0:
			worn_i = i
	ok(_run.rune_toggle_refusal(w, worn_i) == "" and _run.toggle_rune(w, worn_i)
			and _run.held_count(w) == int(_run.HERO_HOLD_CAP) and _run.runes_worn(w) == 2,
		"§2f: with room in his holding, the worn rune would not come off into it")
	# (g) AN ENGINE RUNE UNSLOTS INTO HIS HOLDING, AND A FULL HOLDING REFUSES THAT TOO.
	var h: Dictionary = _run.party[3]
	_fill_holding(h, int(_run.HERO_HOLD_CAP))
	var er: Array = _run.engine_rows(h)
	var ei := _row_where(er, "hero")
	ok(_run.engine_toggle_refusal(h, ei) == String(_run.held_full_note()) and not _run.toggle_engine(h, ei),
		"§2g: a full holding let an engine rune in")
	_run.drop_held_rune(h, 0)
	ok(_run.toggle_engine(h, ei) and Runes.held_engines(h).is_empty()
			and _unworn(h).has(String((er[ei]["rune"] as Dictionary)["name"])),
		"§2g: ...and with room the engine rune did not come off into his holding")
	# (h) THE BAG'S OWN PANEL, WITH A CREST RUNE IN IT: two presses drop it for good; the
	# crest is empty.
	_clear_bag()
	var crest_ids: Array = Runes.ids().filter(func(x): return not Runes.is_retired(String(x)) and Runes.is_party_rune(Runes.build(String(x))))
	_run.hold_rune(w, Runes.build(String(crest_ids[0])))
	mp = await _to_map()
	ok(Gate.has_text(mp, "Rune bag  %d/%d" % [_run.rune_bag.size(), int(_run.BAG_CAP)]),
		"§2h: the map's bag row does not read the bag's count")
	Gate.press(mp, ["Rune bag"])
	await process_frame
	var bp: Node = Gate.overlay(current_scene, 60)
	ok(bp != null and Gate.has_text(bp, "THE RUNE BAG")
			and Gate.has_text(bp, "THE CREST — 0 of %d filled" % int(_run.PARTY_RUNE_SLOTS))
			and not Gate.has_text(bp, "No crest rune held."),
		"§2h: the bag panel is not on screen, or its crest does not say it is empty with a crest rune in the bag")
	var nb0: int = _run.rune_bag.size()
	var first := String((_run.rune_bag[0] as Dictionary).get("name", ""))
	Gate.press(bp, ["Drop"])
	await process_frame
	ok(_run.rune_bag.size() == nb0, "§2h: one press on Drop dropped a rune — it must ask first")
	bp = Gate.overlay(current_scene, 60)
	Gate.press(bp, ["Sure?"])
	await Gate.frames(self, 2)
	ok(_run.rune_bag.size() == nb0 - 1 and not _held().has(first),
		"§2h: the second press did not drop the rune for good")


# ── §3 — THE PEDDLER ────────────────────────────────────────────────────────

func _s3_the_peddler() -> void:
	print("\n§3 — the Peddler: 150g a rune to its hero, a third back, and a wall at his eight")
	_clear_bag()
	_new_run()
	var live := Runes.build(String(Runes.ids().filter(func(x): return not Runes.is_retired(String(x)))[0]))
	ok(int(_run.rune_price(live)) == 150 and int(_run.rune_sell_value(live)) == 50,
		"§3: a rune is %dg and sells for %dg, not 150 and 50" % [int(_run.rune_price(live)), int(_run.rune_sell_value(live))])
	ok(is_equal_approx(float(_run.RUNE_SELL_FRACTION), 1.0 / 3.0), "§3: the sale is not a third")
	# THE DISCOUNT CUTS BOTH, so the two cannot be arbitraged.
	_run.active_relics = ["lodestone"]
	var disc_p: int = _run.rune_price(live)
	var disc_s: int = _run.rune_sell_value(live)
	_run.active_relics = []
	ok(disc_p < 150 and disc_s == int(round(disc_p / 3.0)) and disc_s < disc_p,
		"§3: under the shop discount the rune is %dg and sells for %dg — the sale does not follow the price" % [disc_p, disc_s])
	# (a) A PURCHASE LANDS ON THE HERO IT WAS ROLLED FOR, UNWORN — through the Buy button.
	# BATCH HR §1 — RE-POINTED: HK sent it into the bag and asked that the hero's lists did
	# not move; the hero holds it now, and a crest rune would still go to the bag, so the
	# arm looks for the rune where its kind lands (HO §1's rule for a first offer).
	_run.gold = 1000
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	var shop: Node = current_scene
	ok(Gate.has_text(shop, "SELL A RUNE NOBODY WEARS"), "§3a: the Peddler draws no sale column")
	var offers: Array = shop.get("offers")
	ok(offers.size() == 4, "§3a: the Peddler put %d runes on the counter, not one for every hero" % offers.size())
	var o0: Dictionary = offers[0]
	var for_idx := int(o0["member_idx"])
	var o_name := String((o0["rune"] as Dictionary)["name"])
	var o_crest := Runes.is_party_rune(o0["rune"])
	var bought := Gate.press(shop, ["Buy — 150g"])
	await Gate.frames(self, 2)
	ok(bought == "Buy — 150g" and _run.gold == 850, "§3a: a Buy took %dg, not 150" % (1000 - int(_run.gold)))
	ok(_places(o_name) == 1 and (_names(_run.rune_bag).has(o_name) if o_crest else _unworn(_run.party[for_idx]).has(o_name)),
		"§3a: the rune bought is not held where its kind lands (crest: %s)" % o_crest)
	ok(o_crest or not _names(_run.rune_bag).has(o_name),
		"§3a: ...and it went into the bag, not to the hero it was rolled for")
	# (b) TWO PRESSES SELL IT BACK FOR A THIRD.
	shop = current_scene
	var g1: int = _run.gold
	Gate.press(shop, ["Sell +50g"])
	await Gate.frames(self, 2)
	ok(_run.gold == g1 and _places(o_name) == 1, "§3b: one press on Sell sold the rune")
	Gate.press(current_scene, ["Sure? +50g"])
	await Gate.frames(self, 2)
	ok(_run.gold == g1 + 50 and _places(o_name) == 0, "§3b: the second press did not sell it for 50")
	# (c) A FULL HOLDING GREYS THAT HERO'S BUY AND SAYS SO — and one sale opens it. The
	# other heroes' Buys stay live: the wall is his, not the counter's.
	_fill_holding(_run.party[0], int(_run.HERO_HOLD_CAP))
	# BATCH HS — THE CREST'S RUNES ARE HELD FIRST, so the counter cannot deal the Warrior
	# one: a crest rune goes to the bag, never to his holding, so his full holding is no wall
	# to it and the arm below would ask nothing. HR's dice dealt him a class rune; HS's map
	# change (no event in the run's first three nodes) moved the dice and dealt a crest rune
	# — ATTRIBUTED BY A STUB: HS's game with that change set back read this gate 167 / 0.
	# HR §6's rule, `check_fh` §9b's construction: held, they are out of every roll.
	for cid in Runes.ids():
		if not Runes.is_retired(String(cid)) and Runes.is_party_rune(Runes.build(String(cid))) \
				and not (_run.party_rune_names() as Array).has(Runes.display_name(Runes.config(String(cid)))):
			_run.hold_rune(_run.party[0], Runes.build(String(cid)))
	_run.gold = 1000
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	shop = current_scene
	var w_row := -1
	offers = shop.get("offers")
	for i in offers.size():
		if int((offers[i] as Dictionary)["member_idx"]) == 0:
			w_row = i
	ok(w_row >= 0 and not Runes.is_party_rune((offers[w_row] as Dictionary)["rune"]),
		"§3c: the Warrior's row is not a class rune — the full-holding arm below would ask nothing")
	var w_buy: Button = Gate.bound_button(shop, "_buy_rune", [w_row]) if w_row >= 0 else null
	var w_buy_any: Button = null
	var sb: Array = []
	Gate.buttons(shop, sb, false)
	for b in sb:
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_buy_rune" and cb.get_bound_arguments() == [w_row]:
				w_buy_any = b
	var enabled := 0
	for b in sb:
		if String((b as Button).text).begins_with("Buy — ") and not (b as Button).disabled:
			enabled += 1
	ok(w_buy == null and w_buy_any != null and w_buy_any.disabled
			and String(w_buy_any.tooltip_text).begins_with("Warrior holds %d unworn runes" % int(_run.HERO_HOLD_CAP)),
		"§3c: on the Warrior's full holding his Buy is live, or its tooltip does not say why")
	ok(enabled == offers.size() - 1, "§3c: %d of the %d other Buys are live — a full holding is one hero's wall" % [enabled, offers.size() - 1])
	ok(Gate.has_text(shop, "Warrior holds %d unworn runes, the most he can." % int(_run.HERO_HOLD_CAP)),
		"§3c: the Warrior's row does not say his holding is full")
	var sale_val: int = _run.rune_sell_value(_run.held_rows(_run.party[0])[0]["rune"])
	Gate.press(shop, ["Sell +%dg" % sale_val])
	await Gate.frames(self, 2)
	Gate.press(current_scene, ["Sure? +%dg" % sale_val])
	await Gate.frames(self, 2)
	ok(Gate.bound_button(current_scene, "_buy_rune", [w_row]) != null,
		"§3c: a sale made room and the Warrior's Buy did not come back — the wall is a lock")
	# (d) NEVER A RUNE THE PARTY HOLDS: hold every Warrior offer but one, and his
	# offer is that one; hold it too, and the Peddler has nothing for him.
	_clear_bag()
	_new_run()
	var w: Dictionary = _run.party[0]
	# BATCH HL §1b — THE PEDDLER SELLS NO CORE RUNE, so his population is the
	# ordinary runes the Warrior is eligible for: a core rune kept back here would
	# be one he can never be offered, and the arm would read the ruling as a hole.
	var w_ids := Runes.eligible_ids(w, Runes.owned_names(w, _held())).filter(
		func(x): return not Runes.is_engine_rune(String(x)))
	var keep := String(w_ids.back())
	_hold_all(w_ids.slice(0, w_ids.size() - 1))
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	var w_offer := ""
	for o in current_scene.get("offers"):
		if int((o as Dictionary)["member_idx"]) == 0:
			w_offer = String(((o as Dictionary)["rune"] as Dictionary)["id"])
	ok(w_offer == keep, "§3d: with all but %s held, the Warrior was offered '%s'" % [keep, w_offer])
	_run.bag_rune(Runes.build(keep))
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	var w_offered := false
	for o in current_scene.get("offers"):
		if int((o as Dictionary)["member_idx"]) == 0:
			w_offered = true
	ok(not w_offered and Gate.has_text(current_scene, "The Peddler has nothing for"),
		"§3d: with every rune of his held, the Warrior was still offered one — or the column did not say why")
	# (e) GV'S GATE AT HIS DOOR: with the Mage's engine out of its slot and every
	# ungated rune of his held, the Peddler has nothing for him; with the engine
	# back, what he is offered is one of that engine's rows.
	_clear_bag()
	_new_run()
	var mage: Dictionary = _run.party[1]
	var pid := String(Runes.held_engines(mage)[0])
	var rows_for: Array = []
	for id in Runes.ENGINE_READ:
		if Runes.engine_read(String(id)) == pid:
			rows_for.append(String(id))
	ok(not rows_for.is_empty(), "§3e: the Mage's first engine gates no rune — the gate cannot be asked here")
	ok(_run.toggle_engine(mage, _row_where(_run.engine_rows(mage), "hero")),
		"§3e: the Mage's engine would not come out of its slot")
	var m_ungated := Runes.eligible_ids(mage, Runes.owned_names(mage, _held())).filter(
		func(x): return not rows_for.has(String(x)))
	_hold_all(m_ungated)
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	var m_offer := ""
	for o in current_scene.get("offers"):
		if int((o as Dictionary)["member_idx"]) == 1:
			m_offer = String(((o as Dictionary)["rune"] as Dictionary)["id"])
	ok(m_offer == "", "§3e: with his engine out, the Mage was offered %s — the gate did not hold at the Peddler" % m_offer)
	ok(_run.toggle_engine(mage, _row_held(_run.engine_rows(mage))),
		"§3e: the Mage's engine would not go back into its slot")
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	m_offer = ""
	for o in current_scene.get("offers"):
		if int((o as Dictionary)["member_idx"]) == 1:
			m_offer = String(((o as Dictionary)["rune"] as Dictionary)["id"])
	ok(rows_for.has(m_offer), "§3e: ...and with it slotted the Mage was offered '%s', not one of its rows — the gate is shut, not a gate" % m_offer)


# ── §4 — THE CREST ──────────────────────────────────────────────────────────

func _s4_the_crest() -> void:
	print("\n§4 — the crest: no fixture in the file, and every door live over a fixture one")
	# BATCH HO §3 — THE FILE HOLDS CREST RUNES NOW, AND NONE OF THEM IS THIS GATE'S. The
	# arm read *no party entry in the file* while the ruling was none (HK built every
	# door over zero of them); what it guarded is that a FIXTURE never reaches the
	# file, and it asks that of the fixtures — by id and by the name each wears.
	# `check_ho` §1 drives the same doors with the two the file holds.
	var authored := 0
	var leaked: Array = []
	var file_data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	for id in (file_data as Dictionary):
		var fe: Dictionary = (file_data as Dictionary)[id]
		if String(fe.get("scope", "")) == "party":
			authored += 1
		if [CREST_A, CREST_B].has(String(id)) or String(fe.get("name", "")).begins_with("HK Fixture"):
			leaked.append(String(id))
	print("    crest runes in the file: %d (none at HK; the first were authored at HO §3)" % authored)
	ok((file_data as Dictionary).size() > 100 and leaked.is_empty(),
		"§4: a fixture of this gate is written in the file, or the file did not read back: %s" % [leaked])
	ok(int(_run.PARTY_RUNE_SLOTS) == 1, "§4: the crest holds %d, not the ruled one" % int(_run.PARTY_RUNE_SLOTS))
	# EVERY READER OF THE CAP ASKS THE ONE CONSTANT: each comparison of the slot's
	# size in the game reads `PARTY_RUNE_SLOTS`, and there is at least one.
	var readers := 0
	var bare: Array = []
	for f in ["res://scripts/run_state.gd", "res://scripts/map_screen.gd", "res://scripts/party_screen.gd",
			"res://scripts/battle.gd", "res://scripts/shop_screen.gd", "res://scripts/run_sim.gd"]:
		for ln in Gate.strip_comments(FileAccess.get_file_as_string(f)).split("\n"):
			if ln.contains("party_runes.size()") and (ln.contains(" < ") or ln.contains(" >= ")):
				if ln.contains("PARTY_RUNE_SLOTS"):
					readers += 1
				else:
					bare.append(ln.strip_edges())
	ok(readers >= 2 and bare.is_empty(),
		"§4: the crest's cap is read %d times off the constant, and %d times off something else (%s)" % [readers, bare.size(), bare])
	# THE FIXTURE, put into the loaded table and never into the file.
	var table: Dictionary = Runes._load()
	table[CREST_A] = _fixture_crest(CREST_A, "HK Fixture Crest")
	table[CREST_B] = _fixture_crest(CREST_B, "HK Fixture Crest Two")
	_clear_bag()
	_new_run()
	var a := Runes.build(CREST_A)
	ok(Runes.is_party_rune(a) and Runes.rune_class(a) == "" and _run.rune_for_label(a) == "the crest",
		"§4a: the fixture does not read as a crest rune")
	for m in _run.party:
		ok(Runes._scope_ok(table[CREST_A], m), "§4a: the party scope refuses a %s" % m["key"])
		ok(not Runes.wearable_by(a, m), "§4a: a %s could wear a crest rune in his own slots" % m["key"])
		ok(Runes.eligible_ids(m, []).has(CREST_A), "§4a: a %s cannot be offered the crest rune" % m["key"])
	ok(not Runes._scope_ok({"scope": "spec:berserker"}, _run.party[0]),
		"§4a: a `spec:` scope passes beside the party scope — a third band came back with the fourth")
	# (b) IT DROPS, ONCE IN THE UNION: hold everything else, and the drop is a crest rune.
	var others := _union_offerable().filter(func(x): return String(x) != CREST_A and String(x) != CREST_B)
	_hold_all(others)
	var drop: Dictionary = _run.roll_fight_drop()
	ok([CREST_A, CREST_B].has(String(drop.get("id", ""))),
		"§4b: with everything else held, the drop was not a crest rune (%s)" % drop.get("id", "<nothing>"))
	# (c) THE PEDDLER OFFERS IT TO ONE HERO, NOT FOUR.
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	# BATCH HO §3 — COUNTED BY ID. The file holds two crest runes of its own now, and
	# this read two only because §4b had just put those in the bag; asked by id, the
	# arm says what it means: each rune the party does not hold is on the counter
	# once, for one hero, and nothing the party holds is there at all.
	var crest_offers := {}
	for o in current_scene.get("offers"):
		var o_rune: Dictionary = (o as Dictionary)["rune"]
		if Runes.is_party_rune(o_rune):
			crest_offers[String(o_rune.get("id", ""))] = int(crest_offers.get(String(o_rune.get("id", "")), 0)) + 1
	ok(crest_offers.size() == 2 and int(crest_offers.get(CREST_A, 0)) == 1
			and int(crest_offers.get(CREST_B, 0)) == 1,
		"§4c: the counter's crest runes were %s — each of the two the party does not hold, once" % [crest_offers])
	# (d) INTO THE BAG, INTO THE CREST: one slot, a second refused, a swap through.
	_clear_bag()
	_run.bag_rune(Runes.build(CREST_A))
	_run.bag_rune(Runes.build(CREST_B))
	var prow: Array = _run.party_rune_rows()
	ok(prow.size() == 2 and _run.party_toggle_refusal(0) == "" and _run.toggle_party_rune(0)
			and _run.party_runes.size() == 1,
		"§4d: a crest rune would not go from the bag into the crest")
	prow = _run.party_rune_rows()
	var bi := _row_where(prow, "bag")
	ok(_run.party_toggle_refusal(bi) == String(_run.PARTY_SLOT_FULL_NOTE) and not _run.toggle_party_rune(bi),
		"§4d: a second crest rune went into the one slot")
	ok(_run.swap_party_rune(bi, 0) and String(_run.party_runes[0]["id"]) == CREST_B
			and _names(_run.rune_bag).has("HK Fixture Crest"),
		"§4d: the swap did not trade the worn crest rune for the bag's")
	# (e) THE DISPLAY: the map's crest button and the bag panel's crest section.
	var mp := await _to_map()
	ok(Gate.has_text(mp, "Crest: HK Fixture Crest Two"), "§4e: the map's crest button does not name its rune")
	Gate.press(mp, ["Crest:"])
	await process_frame
	var bp: Node = Gate.overlay(current_scene, 60)
	ok(bp != null and Gate.has_text(bp, "THE CREST — 1 of 1 filled") and Gate.has_text(bp, "HK Fixture Crest Two"),
		"§4e: the bag panel's crest section does not show the worn crest rune")
	# (f) EVERY HERO'S NUMBERS AT THE SPAWN, and the roll call names it once.
	var worn := Runes.build(CREST_A)
	worn["equipped"] = true
	var with_s: Node = await Gate.spawn(self, ["berserker", "cryomancer", "holy", "beastmaster"],
		{"deterministic": true, "party_runes": [worn]})
	var with_hp: Array = []
	for u in with_s.get("heroes"):
		if not u.is_companion:
			with_hp.append(int(u.max_hp))
	var calls := 0
	for line in with_s.get("_rune_roll_call"):
		if String(line) == "the crest: HK Fixture Crest":
			calls += 1
	with_s.queue_free()
	await Gate.frames(self, 3)
	var bare_s: Node = await Gate.spawn(self, ["berserker", "cryomancer", "holy", "beastmaster"],
		{"deterministic": true})
	var bare_hp: Array = []
	for u in bare_s.get("heroes"):
		if not u.is_companion:
			bare_hp.append(int(u.max_hp))
	bare_s.queue_free()
	await Gate.frames(self, 3)
	var all_up := with_hp.size() == 4 and bare_hp.size() == 4
	for i in mini(with_hp.size(), bare_hp.size()):
		if int(with_hp[i]) != int(bare_hp[i]) + CREST_HP:
			all_up = false
	ok(all_up, "§4f: the crest rune did not reach every hero's maximum health (%s against %s)" % [with_hp, bare_hp])
	ok(calls == 1, "§4f: the roll call named the crest rune %d times, not once" % calls)
	# (g) THE SAVE CARRIES THE CREST.
	_run.party_runes = [worn]
	_run.save_path = SCRATCH_SAVE
	_run.active = true
	_run.save_run()
	_run.party_runes = []
	ok(_run.load_run() and _names(_run.party_runes) == ["HK Fixture Crest"],
		"§4g: the crest did not round-trip the save")
	_run.save_path = _run.TEST_SAVE_PATH
	_remove(SCRATCH_SAVE)
	table.erase(CREST_A)
	table.erase(CREST_B)
	_clear_bag()
	ok(not Runes._load().has(CREST_A), "§4: the fixture outlived its section")


# ── §5 — THE SAVE, AND THE MIGRATION ────────────────────────────────────────

func _write_save(d: Dictionary) -> void:
	var f := FileAccess.open(SCRATCH_SAVE, FileAccess.WRITE)
	f.store_var(d, true)
	f.close()


func _read_save() -> Dictionary:
	var f := FileAccess.open(SCRATCH_SAVE, FileAccess.READ)
	var d: Variant = f.get_var(true)
	f.close()
	return d if d is Dictionary else {}


func _s5_the_save() -> void:
	print("\n§5 — the save: the holdings ride it, and a save from before the bag keeps its heroes' runes")
	_run.save_path = SCRATCH_SAVE
	_new_run()
	for _i in 22:
		_run.drop_after_fight()
	_run.active = true
	_run.save_run()
	var d := _read_save()
	# THE INVARIANT THIS GATE OWNS, never the newest version (BK §6's rule).
	ok(int(d.get("version", 0)) >= 14 and d.has("rune_bag") and d.has("crest") and d.has("pending_rune_drops"),
		"§5: the save does not carry the bag, the crest and the waiting drops")
	# BATCH HR §1 — WHAT RIDES THE SAVE IS EVERY HOLDING: the bag, the waiting drops and
	# each hero's held runes, which live on him again.
	var bag_names := _names(_run.rune_bag)
	var wait_names := _names(_run.pending_rune_drops)
	var held_names: Array = []
	for m in _run.party:
		held_names.append(_unworn(m))
	_clear_bag()
	var held_back: Array = []
	var loaded: bool = _run.load_run()
	for m in _run.party:
		held_back.append(_unworn(m))
	ok(loaded and _names(_run.rune_bag) == bag_names and _names(_run.pending_rune_drops) == wait_names
			and held_back == held_names,
		"§5: the bag, the waiting drops or a hero's held runes did not round-trip")
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	var lr := rs.find("func load_run() -> bool:")
	var lr_body := rs.substr(lr, rs.find("\nfunc ", lr + 10) - lr)
	ok(lr_body.contains("if save_version < 10:"), "§5: the refusal floor moved off v10")
	# A SAVE FROM BEFORE THE BAG, with runes worn and runes held unworn on each hero, and
	# an engine rune unslotted. BATCH HR §1 — THE CORRECT ANSWER MOVED: HK's migration put
	# every unworn rune into the bag; since HR an unworn rune lives on its hero, so the
	# save loads with each where its hero held it (a v14 bag is handed out instead —
	# `check_hr` §1e). Each arm below asks HK's question of the new answer.
	_new_run()
	var warrior: Dictionary = _run.party[0]
	var ids := Runes.eligible_ids(warrior, []).filter(func(x): return not Runes.is_engine_rune(String(x)))
	var worn_a := Runes.build(String(ids[0]))
	worn_a["equipped"] = true
	var worn_b := Runes.build(String(ids[1]))
	worn_b["equipped"] = true
	var loose_a := Runes.build(String(ids[2]))
	var loose_b := Runes.build(String(ids[3]))
	warrior["runes"] = [worn_a, loose_a, worn_b, loose_b]
	var spare_pid := String(Classes.class_engines("warrior")[1])
	var spare := Runes.build(Runes.engine_rune_id(spare_pid))
	spare["equipped"] = false
	warrior["engines"] = warrior["engines"] + [spare]
	# and every ordinary rune the other three could be offered, held unworn on
	# them, so the bag opens past its twenty
	var others_loose := 0
	for seat in [1, 2, 3]:
		var om: Dictionary = _run.party[seat]
		# BATCH HO §3 — WHAT A HERO COULD HOLD BEFORE THE BAG: a rune he can wear. A
		# crest rune is offered to every hero and worn by none, so three heroes'
		# worth of "everything he could be offered" put six crest instances on
		# heroes — a save no build ever wrote.
		var oids := Runes.eligible_ids(om, []).filter(func(x): return (not Runes.is_engine_rune(String(x))
			and Runes.wearable_by(Runes.build(String(x)), om)))
		var loose: Array = []
		for id in oids:
			loose.append(Runes.build(String(id)))
		om["runes"] = loose
		others_loose += loose.size()
	var before_all: Array = []
	for m in _run.party:
		before_all.append_array(_names(m["runes"]) + _names(m["engines"]))
	before_all.sort()
	var old := {"version": 13, "party": _run.party.duplicate(true), "items": _run.items, "gold": _run.gold,
		"zone_idx": 0, "zone_name": _run.zone_name, "slot_idx": 0, "node_idx": 0,
		"specs_chosen": true, "active_relics": [], "map": _run.map, "zone_draw": _run.zone_draw}
	_write_save(old)
	_clear_bag()
	ok(_run.load_run(), "§5: a v13 save with runes on its heroes did not load")
	var w2: Dictionary = _run.party[0]
	var w2_worn: Array = _names(w2["runes"].filter(func(r): return bool((r as Dictionary).get("equipped", false))))
	ok(w2_worn == [String(worn_a["name"]), String(worn_b["name"])],
		"§5: the Warrior does not wear exactly what he wore, in order (%s)" % [w2_worn])
	ok(_names(w2["engines"]).size() == 2 and bool((w2["engines"][0] as Dictionary).get("equipped", false))
			and not bool((w2["engines"][1] as Dictionary).get("equipped", false)),
		"§5: the Warrior's slotted engine did not stay slotted, and his unslotted one held")
	var after_all: Array = _names(_run.rune_bag)
	for m in _run.party:
		after_all.append_array(_names(m["runes"]) + _names(m["engines"]))
	after_all.sort()
	ok(after_all == before_all, "§5: the migration lost or invented a rune (%d before, %d after)" % [before_all.size(), after_all.size()])
	ok(_unworn(w2) == [String(loose_a["name"]), String(loose_b["name"]), String(spare["name"])]
			and _run.rune_bag.is_empty(),
		"§5: the Warrior does not still hold his unworn runes and unslotted engine, in the order held, with the bag empty")
	var over_cap := 0
	for seat in [1, 2, 3]:
		if _run.held_count(_run.party[seat]) > int(_run.HERO_HOLD_CAP):
			over_cap += 1
	ok(_run.held_count(_run.party[1]) + _run.held_count(_run.party[2]) + _run.held_count(_run.party[3]) == others_loose
			and over_cap > 0,
		"§5: the others hold %d of their %d, and %d opened over their eight — a load drops nothing, past the cap" % [
			_run.held_count(_run.party[1]) + _run.held_count(_run.party[2]) + _run.held_count(_run.party[3]), others_loose, over_cap])
	var full_seat := -1
	for seat in [1, 2, 3]:
		if _run.holding_full(_run.party[seat]) and full_seat < 0:
			full_seat = seat
	var over_r: Array = Runes.eligible_ids(_run.party[full_seat], Runes.owned_names(_run.party[full_seat], _held())).filter(
		func(x): return not Runes.is_party_rune(Runes.build(String(x)))) if full_seat >= 0 else []
	var over_w: String = String(_run.hold_rune(_run.party[full_seat], Runes.build(String(over_r[0])))) \
		if not over_r.is_empty() else "<none left>"
	ok(over_w == "pending", "§5: a rune for a hero over his cap landed (%s) instead of waiting" % over_w)
	# Every rune on a hero is where the save put it, worn or held as it was written.
	var saved_party: Array = old["party"]
	for i in _run.party.size():
		var saved_m: Dictionary = saved_party[i]
		for key in ["runes", "engines"]:
			var saved_l: Array = saved_m.get(key, [])
			var now_l: Array = (_run.party[i] as Dictionary).get(key, [])
			for j in saved_l.size():
				var was: Dictionary = saved_l[j]
				var is_now: Dictionary = now_l[j] if j < now_l.size() else {}
				ok(String(is_now.get("name", "")) == String(was.get("name", ""))
						and bool(is_now.get("equipped", false)) == bool(was.get("equipped", false)),
					"§5: a rune on a hero moved or changed state in the load (%s)" % String(was.get("name", "")))
	_remove(SCRATCH_SAVE)
	_run.save_path = _run.TEST_SAVE_PATH
	_clear_bag()


# ── §6 — THE SIM ────────────────────────────────────────────────────────────

func _s6_the_sim() -> void:
	print("\n§6 — the sim: the bot takes the drop through the game's own door")
	var sim := FileAccess.get_file_as_string("res://scripts/run_sim.gd")
	var ob := sim.find("static func on_battle_end(")
	var ob_body := sim.substr(ob, sim.find("\nstatic func ", ob + 10) - ob)
	ok(ob_body.contains("if node_type == \"fight\":\n\t\t_sim_take_drop(run)"),
		"§6: RunSim's victory walk does not take the normal fight's drop")
	var ts := sim.find("static func _sim_take_drop(")
	var ts_body := sim.substr(ts, sim.find("\nstatic func ", ts + 10) - ts)
	ok(ts_body.contains("run.drop_after_fight()"), "§6: the bot rolls its own drop instead of the game's")
	# THE POLICY, DRIVEN: worn while a slot is free, left in the bag when not, let
	# go on a full bag.
	_new_run()
	var worn0: int = RunSim.rune_drop_worn
	var n0: int = RunSim.rune_drops
	for _i in 6:
		RunSim._sim_take_drop(_run)
	ok(RunSim.rune_drops == n0 + 6 and RunSim.rune_drop_worn > worn0,
		"§6: six drops booked %d and wore %d" % [RunSim.rune_drops - n0, RunSim.rune_drop_worn - worn0])
	# every slot the bot fills first, so a hero's holding fills only after them.
	# BATCH HR §1 — RE-POINTED: the bag's twenty became a hero's eight, so the drop the
	# bot lets go is the one whose hero holds all he can.
	var declined0: int = RunSim.rune_drop_declined
	var guard := 0
	while RunSim.rune_drop_declined == declined0 and guard < 400:
		RunSim._sim_take_drop(_run)
		guard += 1
	var full_n := 0
	for m in _run.party:
		if _run.holding_full(m):
			full_n += 1
	ok(full_n >= 1, "§6: %d drops never filled a hero's holding — the decline below cannot be asked" % guard)
	ok(RunSim.rune_drop_declined == declined0 + 1 and _run.pending_rune_drops.is_empty(),
		"§6: on a full holding the bot did not let the drop go (declined %d, waiting %d)" % [RunSim.rune_drop_declined - declined0, _run.pending_rune_drops.size()])
	_clear_bag()


# ── §7 — THE ROAD ───────────────────────────────────────────────────────────
#
# A whole run to the end boss's door on the real screens — `check_gj` §1's walk,
# with this batch's answers added: the full-holding panel answered by a drop the
# first time and a decline the next, the first Peddler's counter used to sell a rune
# and buy one, and a rune a hero holds equipped and put back through his panel (HR §1:
# a hero's holding where HK had the bag).

var _cards_fight := 0
var _cards_fight_drop := 0
var _cards_other_drop := 0
var _panel_took := 0
var _panel_left := 0
var _sold := 0
var _bought := 0
var _equipped := 0
var _unequipped := 0
var _held_max := 0
var _road_dead: Array = []


func _most_held() -> int:
	var most := 0
	for m in _run.party:
		most = maxi(most, _run.held_count(m))
	return most


func _road_step_map(s: Node) -> String:
	_held_max = maxi(_held_max, _most_held())
	if Gate.overlay(s, 62) != null:
		await _road_decline_draft(s)
		return "draft"
	var fb: Node = Gate.overlay(s, 74)
	if fb != null:
		if _panel_took == 0:
			var b: Button = Gate.bound_button(fb, "_take_pending_drop", [0, fb])
			if b != null:
				b.emit_signal("pressed")
				_panel_took += 1
		else:
			if Gate.press(fb, ["Leave "]) != "":
				_panel_left += 1
		await Gate.frames(self, 3)
		return "panel"
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		if int(m.get("bm_picks_owed", 0)) > 0 or int(m.get("up_picks_owed", 0)) > 0 \
				or int(m.get("rune_picks_owed", 0)) > 0:
			await _road_answer_pick(s, idx)
			return "pick"
	# EQUIP ONE HE HOLDS, AND PUT ONE BACK, through the Warrior's own panel (HR §1: his
	# holding, where HK's road equipped from the bag).
	var w: Dictionary = _run.party[0]
	if _equipped < 2 and _run.runes_worn(w) < int(_run.rune_slots()):
		var bi := _row_held(_run.rune_rows(w))
		if bi >= 0:
			s.call("_open_rune_panel", 0)
			await process_frame
			var ov: Node = Gate.overlay(current_scene, 60)
			var eq: Button = Gate.bound_button(ov, "_toggle_rune", [0, bi, ov]) if ov != null else null
			if eq != null and String(eq.text) == "Equip":
				var worn0: int = _run.runes_worn(w)
				eq.emit_signal("pressed")
				await Gate.frames(self, 2)
				if _run.runes_worn(w) == worn0 + 1:
					_equipped += 1
			var ov2: Node = Gate.overlay(current_scene, 60)
			if ov2 != null:
				Gate.press(ov2, ["Close"])
				await process_frame
			return "equip"
	if _equipped >= 2 and _unequipped == 0 and not _run.holding_full(w) and _run.runes_worn(w) > 0:
		s.call("_open_rune_panel", 0)
		await process_frame
		var ov3: Node = Gate.overlay(current_scene, 60)
		var wr := -1
		var w_rows: Array = _run.rune_rows(w)
		for i in w_rows.size():
			if bool(w_rows[i]["worn"]) and wr < 0:
				wr = i
		var un: Button = Gate.bound_button(ov3, "_toggle_rune", [0, wr, ov3]) if ov3 != null else null
		if un != null and String(un.text) == "Unequip":
			var held0: int = _run.held_count(w)
			un.emit_signal("pressed")
			await Gate.frames(self, 2)
			if _run.held_count(w) == held0 + 1:
				_unequipped += 1
		var ov4: Node = Gate.overlay(current_scene, 60)
		if ov4 != null:
			Gate.press(ov4, ["Close"])
			await process_frame
		return "unequip"
	var reach: Array = _run.reachable()
	if reach.is_empty():
		return ""
	# THE ROUTE: a Peddler once, while one has not been visited; otherwise a normal
	# fight where one is reachable (drops are what this road is for); otherwise the
	# first reachable node, as `check_gj` walks.
	var nxt_slot: int = int(_run.slot_idx) + 1
	var pick := int(reach[0])
	for want in (["merchant", "fight"] if _sold == 0 else ["fight"]):
		var found := false
		for j in reach:
			if String(_run.map[nxt_slot][int(j)]["type"]) == want:
				pick = int(j)
				found = true
				break
		if found:
			break
	var btn: Button = Gate.bound_button(s, "_on_node_pressed", [pick])
	if btn == null:
		return ""
	var ty := String(_run.map[nxt_slot][pick]["type"])
	btn.emit_signal("pressed")
	return ty


func _road_decline_draft(s: Node) -> void:
	for _i in 8:
		var ov: Node = Gate.overlay(s, 62)
		var btn: Button = null
		var btns: Array = []
		Gate.buttons(ov if ov != null else s, btns)
		for b in btns:
			if String((b as Button).text) != "Decline" or (b as Button).disabled:
				continue
			for c in (b as Button).pressed.get_connections():
				if (c["callable"] as Callable).get_method() == "_stage_draft_decline":
					btn = b
		if btn == null:
			break
		btn.emit_signal("pressed")
		await process_frame
	var again: Node = Gate.overlay(s, 62)
	if Gate.press(again if again != null else s, ["Confirm the draft"]) == "":
		_road_dead.append("the draft screen would not confirm")
		s.call("_close_party_draft")
	await Gate.frames(self, 2)


func _road_answer_pick(s: Node, idx: int) -> void:
	var m: Dictionary = _run.party[idx]
	var choose: Button = Gate.bound_button(s, "_open_pick_overlay", [idx])
	var ov: Node = null
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
		ov = Gate.overlay(s, 60)
	var live: Array = []
	if ov != null:
		var btns: Array = []
		Gate.buttons(ov, btns)
		for b in btns:
			if String((b as Button).text) != "Not yet" and not (b as Button).disabled:
				live.append(b)
	if live.is_empty():
		_road_dead.append("hero %d owed a pick and no live choice could be pressed" % idx)
		for k in ["bm_picks_owed", "up_picks_owed", "rune_picks_owed"]:
			m[k] = 0
		if ov != null:
			ov.queue_free()
		await process_frame
		return
	(live[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 2)
	var still: Node = Gate.overlay(s, 60)
	if still != null:
		still.queue_free()
		await process_frame


func _road_shop(s: Node) -> String:
	# BATCH HR §1 — THE SALE IS OF ANY RUNE NOBODY WEARS (a hero's held, or the bag's),
	# the counter's first row; the purchase lands where its kind does. Counted over
	# everything held, where HK counted the bag.
	var sale: Array = s.call("_sale_rows")
	if _sold == 0 and not sale.is_empty():
		var g0: int = _run.gold
		var held0: int = _held().size()
		var value: int = _run.rune_sell_value(sale[0]["rune"])
		Gate.press(s, ["Sell +%dg" % value])
		await Gate.frames(self, 2)
		Gate.press(current_scene, ["Sure? +%dg" % value])
		await Gate.frames(self, 2)
		if _run.gold == g0 + value and _held().size() == held0 - 1:
			_sold += 1
		s = current_scene
	if _bought == 0:
		_run.gold = maxi(int(_run.gold), 400)
		var g1: int = _run.gold
		var held1: int = _held().size()
		var pressed := Gate.press(s, ["Buy — "])
		await Gate.frames(self, 2)
		if pressed != "" and _run.gold < g1 and _held().size() == held1 + 1:
			_bought += 1
		s = current_scene
	return Gate.press(s, ["Leave the Shop"])


func _road_leave(s: Node, nm: String) -> String:
	match nm:
		"Offer":
			var takes: Array = []
			var btns: Array = []
			Gate.buttons(s, btns)
			for b in btns:
				if String((b as Button).text) == "Take this bargain" and not (b as Button).disabled:
					takes.append(b)
			if takes.is_empty():
				return ""
			(takes[0] as Button).emit_signal("pressed")
			return "Take this bargain"
		"Event":
			var choice := Gate.press(s, [""])
			if choice == "":
				return ""
			await Gate.frames(self, 3)
			var on := Gate.press(s, ["Continue"])
			return choice if on == "" else on
		"Shop":
			return await _road_shop(s)
		"Blacksmith":
			return Gate.press(s, ["Leave the forge", "Walk on"])
	return Gate.press(s, ["Leave", "Walk on", "Onward", "Continue", "Depart"])


func _s7_the_road() -> void:
	print("\n§7 — the road: a whole run, the bag filling as it goes")
	seed(ROAD_SEED)
	_clear_bag()
	_new_run()
	# BATCH HR §1 — CONSTRUCTED, NOT WAITED FOR: every hero holds seven of his own runes
	# before the first step, so the road's drops fill a holding and the full-holding
	# panel is met on the real screens. A run hands a hero five or six runes from start
	# to end (HR §1's measurement), so a road left to fill one by itself never would.
	for m in _run.party:
		_fill_holding(m, int(_run.HERO_HOLD_CAP) - 1)
	# Fights won on autoplay with the enemy's attacks off, as `check_gj` walks: a
	# balance fact is the sim's, and this road is about the rewards.
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)
	var stalled := ""
	var arrived := false
	var battles := 0
	for _step in MAX_STEPS:
		await Gate.frames(self, 2)
		var s: Node = current_scene
		if s == null or s.is_queued_for_deletion():
			continue
		var nm := Gate.scene_name(self)
		if nm == "Map":
			var nxt: int = int(_run.slot_idx) + 1
			if nxt < _run.map.size() and String(_run.map[nxt][0].get("type", "")) == "endboss":
				arrived = true
				break
			if await _road_step_map(s) == "":
				stalled = "nothing pressable on the map at zone %d slot %d" % [int(_run.zone_idx) + 1, int(_run.slot_idx) + 1]
				break
		elif nm == "Battle":
			var guard := 0
			while not bool(s.get("battle_over")) and guard < FRAME_CAP:
				Engine.time_scale = 100.0
				await process_frame
				guard += 1
			Engine.time_scale = 1.0
			await Gate.frames(self, 6)
			battles += 1
			var ty := String(_run.encounter.get("type", ""))
			var dropped := Gate.has_text(s, "RUNE DROP:")
			if ty == "fight":
				_cards_fight += 1
				if dropped:
					_cards_fight_drop += 1
			elif dropped:
				_cards_other_drop += 1
			if Gate.press(s, ["Continue", "Descend into", "Walk on", "Onward"]) == "":
				stalled = "a %s's card drew nothing to press" % ty
				break
		elif nm == "MainMenu":
			stalled = "the run bounced to the main menu"
			break
		elif await _road_leave(s, nm) == "":
			stalled = "no way off the %s screen" % nm
			break
		_held_max = maxi(_held_max, _most_held())
	Engine.time_scale = 1.0
	print("    %d battles, %d normal fights, a hero held at most %d, panel took %d and left %d, sold %d, bought %d, equipped %d, unequipped %d" % [
		battles, _cards_fight, _held_max, _panel_took, _panel_left, _sold, _bought, _equipped, _unequipped])
	ok(stalled == "" and arrived, "§7: the road stopped — %s" % (stalled if stalled != "" else "short of the end boss"))
	ok(_road_dead.is_empty(), "§7: a screen on the road could not be answered — %s" % [_road_dead])
	ok(_cards_fight >= 15 and _cards_fight_drop == _cards_fight,
		"§7: %d normal fights were won and %d of their cards named a drop — every one should" % [_cards_fight, _cards_fight_drop])
	ok(_cards_other_drop == 0, "§7: %d elite, mini-boss or boss cards named a rune drop" % _cards_other_drop)
	ok(_held_max >= int(_run.HERO_HOLD_CAP),
		"§7: a hero held at most %d on the road, never his eight — the full-holding panel was not met" % _held_max)
	ok(_panel_took >= 1 and _panel_left >= 1,
		"§7: the full-holding panel was answered %d times by a drop and %d by a decline — both are owed" % [_panel_took, _panel_left])
	ok(_sold >= 1 and _bought >= 1, "§7: the road sold %d runes and bought %d at a Peddler" % [_sold, _bought])
	ok(_equipped >= 1 and _unequipped >= 1,
		"§7: the road equipped %d runes from a hero's holding and put %d back" % [_equipped, _unequipped])
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")


# ── §8 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s8_the_players_files() -> void:
	print("\n§8 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var had_now := FileAccess.file_exists(p)
		ok(had_now == bool(was[0]), "§8: %s %s" % [p, "appeared" if had_now else "vanished"])
		if had_now and bool(was[0]):
			ok(FileAccess.get_file_as_bytes(p) == was[1], "§8: %s was rewritten" % p)
