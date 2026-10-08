# BATCH HR — THE BAG SPLITS, THE NAMEPLATE SPEAKS, AND THE FIRST NODES SELL NOTHING.
#
# What this gate asserts, section by section (`docs/reports/HR.md` has the working):
#
#   §0  HQ's ruling 3: a rune the game cannot pay (`Talents.live_refusal`) is not
#       offered at any roll door — the drop, the Peddler, a cache, the event verb —
#       and no "why is my offer short" list names it; the same entry, payable, IS
#       offered at every one of them. And ruling 1's premise: the shared Break-heal
#       site heals the hero furthest from full by SHARE of maximum health.
#   §1  The bag is the crest's: a crest rune goes to the crest or the bag, a class or
#       core rune to the hero of its class, held unworn, `HERO_HOLD_CAP` of them; a
#       full holding queues a rune for that hero's panel; an unequip into a full
#       holding is refused and a swap is not; every door routes the same way; a v14
#       save's bag is handed out on load, a rune with no hero here is kept and said.
#   §2  On the real map: a real normal fight won, its drop on the right nameplate at
#       the right count, the panel opened from the marker, the rune equipped, the
#       marker gone — and a crest drop moves the bag's marker and no hero's.
#   §3  No Peddler and no Smith in the run's first `SHOP_GATE_NODES` columns, every
#       zone still dealt its full count, the later zones ungated, and the real map
#       screen's first columns drawn without either.
#
# What it cannot assert, said here so it is not mistaken for coverage: that an OLDER
# build refuses this build's save (a gate runs one build; `check_hl` §5 drives the
# ceiling against SAVE_VERSION + 1 and HR's report records the drive of HQ's build
# against a v15 file), and whether the proposed caps are the right figures (the
# measurement is the report's). `Run` is fetched off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://hr_profile.json"
const SCRATCH_RELICS := "user://hr_relics.json"
const SCRATCH_SAVE := "user://hr_scratch_save.bin"
const FRAME_CAP := 30000
const DROP_SEED := 20261005
const BOARD_SEED := 20261006
const BOARDS := 80
const REFUSED_FX := "hr_fixture_refused"
const PAYABLE_FX := "hr_fixture_payable"
const CREST_FX := "hr_fixture_crest_"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HR — THE BAG SPLITS, THE NAMEPLATE SPEAKS, AND THE FIRST NODES SELL NOTHING")
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
	_s0_the_rulings()
	await _s0b_the_read_site()
	_s1_the_bag_splits()
	_s1e_the_save()
	await _s1f_the_surfaces()
	_fresh_meta()
	await _s2_the_nameplate()
	await _s3_the_first_nodes()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
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


# A hero's runes he does not wear, by name, read the long way off both lists — so
# it is not `Run.held_rows` asked about itself.
func _unworn(m: Dictionary) -> Array:
	var out: Array = []
	for key in ["runes", "engines"]:
		for r in m.get(key, []):
			if not bool((r as Dictionary).get("equipped", false)):
				out.append(String((r as Dictionary).get("name", "")))
	return out


func _index_of(key: String) -> int:
	for i in _run.party.size():
		if String(_run.party[i]["key"]) == key:
			return i
	return -1


# The live entries of a class: ordinary (`core` false) or core, in file order.
func _class_ids(cls: String, core: bool) -> Array:
	var out: Array = []
	for id in Runes.ids():
		var e: Dictionary = Runes.config(String(id))
		if String(e.get("retired", "")) != "" or String(e.get("scope", "")) != "class:%s" % cls:
			continue
		if (String(e.get("engine", "")) != "") == core:
			out.append(String(id))
	return out


func _crest_ids() -> Array:
	var out: Array = []
	for id in Runes.ids():
		var e: Dictionary = Runes.config(String(id))
		if String(e.get("retired", "")) == "" and String(e.get("scope", "")) == "party":
			out.append(String(id))
	return out


# Every rune each hero could be offered now, less what the party holds — the union
# the drop draws from.
func _union_offerable() -> Array:
	var held: Array = _run.party_rune_names()
	var out: Array = []
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


# Put `ids` beyond every roll's reach WITHOUT touching a hero's holding or the bag:
# onto the waiting queue, which every roll excludes (`party_rune_names`). Only for a
# check that reads the roll, never the map — the map would open its panel on them.
func _park(ids: Array) -> void:
	for id in ids:
		_run.pending_rune_drops.append(Runes.build(String(id)))


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


func _marker(screen: Node, meta: String) -> Array:
	var out: Array = []
	var btns: Array = []
	Gate.buttons(screen, btns, false)
	for b in btns:
		if (b as Button).has_meta(meta) and not (b as Button).is_queued_for_deletion():
			out.append(b)
	return out


# The nameplate marker drawn for hero `idx`: the marker whose press opens his panel.
func _hero_marker(screen: Node, idx: int) -> Button:
	for b in _marker(screen, "held_marker"):
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_open_rune_panel" and cb.get_bound_arguments() == [idx]:
				return b
	return null


# ── §0 — HQ'S RULINGS ───────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — a rune the game cannot pay is not offered; the same rune, payable, is")
	var data: Dictionary = Runes._load()
	# Crest-scoped, so every hero's roll can reach both; the refused one carries a
	# live condition on a consumed field (HP §1b's refusal), the payable one does not.
	data[REFUSED_FX] = {"name": "HR Fixture Refused", "scope": "party", "price": 150,
		"desc": "A fixture of check_hr, never in the file.",
		"payload": {"stat": {"max_hp": 9}, "condition": {"heroes_all_standing": false}}}
	data[PAYABLE_FX] = {"name": "HR Fixture Payable", "scope": "party", "price": 150,
		"desc": "A fixture of check_hr, never in the file.",
		"payload": {"stat": {"max_hp": 9}}}
	ok(Talents.live_refusal((data[REFUSED_FX] as Dictionary)["payload"]) != ""
			and Talents.live_refusal((data[PAYABLE_FX] as Dictionary)["payload"]) == "",
		"§0a: the two fixtures are not one refused and one payable — nothing below can be read")
	_new_run()
	var refused_at := PackedStringArray()
	var payable_missing := PackedStringArray()
	for m in _run.party:
		var ids: Array = Runes.eligible_ids(m, [])
		if ids.has(REFUSED_FX):
			refused_at.append(String(m["key"]))
		if not ids.has(PAYABLE_FX):
			payable_missing.append(String(m["key"]))
	ok(refused_at.is_empty(), "§0a: `eligible_ids` offers the refused entry to %s" % [refused_at])
	ok(payable_missing.is_empty(), "§0a: ...and does not offer the payable one to %s — the absence read nothing" % [payable_missing])
	# THE LISTS THAT SAY WHY AN OFFER IS SHORT: a twin pair that waits on a card no hero
	# holds at spawn, so the payable one IS named as waiting and the refused one must not be.
	var wait_card := "Fireball"
	data[REFUSED_FX + "_card"] = {"name": "HR Fixture Refused Card", "scope": "party", "price": 150,
		"desc": "A fixture of check_hr, never in the file.", "requires_ability": wait_card,
		"payload": {"stat": {"max_hp": 9}, "condition": {"heroes_all_standing": false}}}
	data[PAYABLE_FX + "_card"] = {"name": "HR Fixture Payable Card", "scope": "party", "price": 150,
		"desc": "A fixture of check_hr, never in the file.", "requires_ability": wait_card,
		"payload": {"stat": {"max_hp": 9}}}
	var named := PackedStringArray()
	var waits := PackedStringArray()
	for m in _run.party:
		ok(not Runes.kit_names(m).has(wait_card), "§0a: %s opens holding %s — the waiting pair cannot wait" % [m["key"], wait_card])
		for lst in [Runes.locked_by_kit(m), Runes.locked_by_engine(m), Runes.locked_by_pet(m)]:
			if (lst as Array).has(REFUSED_FX) or (lst as Array).has(REFUSED_FX + "_card"):
				named.append(String(m["key"]))
		if Runes.locked_by_kit(m).has(PAYABLE_FX + "_card"):
			waits.append(String(m["key"]))
	ok(named.is_empty(), "§0a: a list that says why an offer is short names a refused entry for %s" % [named])
	ok(waits.size() == _run.party.size(), "§0a: ...and the payable twin is named as waiting on %s for only %s — the absence read nothing" % [wait_card, waits])
	data.erase(REFUSED_FX + "_card")
	data.erase(PAYABLE_FX + "_card")
	# EVERY DOOR, ON A POOL NARROWED TO THE TWO FIXTURES: everything else parked where
	# every roll excludes it, so a door that offered the refused one would draw it
	# about half the time.
	var rest: Array = _union_offerable().filter(func(x): return String(x) != REFUSED_FX and String(x) != PAYABLE_FX)
	_park(rest)
	seed(DROP_SEED)
	var drops := {}
	for _i in 120:
		var d: Dictionary = _run.roll_fight_drop()
		var did := String(d.get("id", "<nothing>"))
		drops[did] = int(drops.get(did, 0)) + 1
	print("    CHECKED 120 drops on the narrowed pool: %s" % [drops])
	ok(not drops.has(REFUSED_FX), "§0a: the drop handed over the refused entry %d times" % int(drops.get(REFUSED_FX, 0)))
	ok(int(drops.get(PAYABLE_FX, 0)) == 120, "§0a: ...and the payable one only %d of 120 times" % int(drops.get(PAYABLE_FX, 0)))
	var w: Dictionary = _run.party[0]
	var ped: Dictionary = _run.peddler_rune(w)
	ok(String(ped.get("id", "")) == PAYABLE_FX, "§0a: the Peddler stocked %s, not the payable fixture" % ped.get("id", "<nothing>"))
	# BATCH HW §1c — RE-POINTED, THE COUNT UNMOVED: a hero's own pick of three holds no crest rune now
	# (ruled), so the crest-scoped pair above can no longer reach the cache. Its door is asked with the
	# same twin pair scoped to his class, laid for this arm alone and lifted before the event verb.
	data[REFUSED_FX + "_class"] = (data[REFUSED_FX] as Dictionary).duplicate(true)
	data[REFUSED_FX + "_class"]["scope"] = "class:%s" % String(w["key"])
	data[PAYABLE_FX + "_class"] = (data[PAYABLE_FX] as Dictionary).duplicate(true)
	data[PAYABLE_FX + "_class"]["scope"] = "class:%s" % String(w["key"])
	data[REFUSED_FX + "_class"]["name"] = "HR Fixture Refused Class"
	data[PAYABLE_FX + "_class"]["name"] = "HR Fixture Payable Class"
	var trip: Array = _run.roll_rune_candidates(w)
	data.erase(REFUSED_FX + "_class")
	data.erase(PAYABLE_FX + "_class")
	var trip_ids: Array = trip.map(func(c): return String((c as Dictionary).get("id", "")))
	ok(trip_ids == [PAYABLE_FX + "_class"], "§0a: a cache holds %s — want the payable class twin and nothing refused, and no crest rune" % [trip_ids])
	var granted: Dictionary = _run.grant_rune(w)
	ok(String(granted.get("id", "")) == PAYABLE_FX, "§0a: the event verb granted %s" % granted.get("id", "<nothing>"))
	_run.pending_rune_drops = []
	# THE NET STAYS: a worn refused rune still meets the spawn's refused tail (HQ §1.5),
	# which `check_hp` §1c drives; here only that the source still carries it.
	var bat := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bat.contains("it cannot work as written, so it pays nothing this fight"),
		"§0a: the roll call's refused tail is gone — the net for a rune worn before a build refused it")
	data.erase(REFUSED_FX)
	data.erase(PAYABLE_FX)
	ok(not Runes.ids().has(REFUSED_FX) and not Runes.ids().has(PAYABLE_FX), "§0a: a fixture was left in the table")


# §0b — *furthest from full* is the site's own reading: share of maximum health.
func _s0b_the_read_site() -> void:
	print("\n§0b — the Break heal's site heals the hero furthest from full, by share")
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var war: Object = heroes[0]
	var mag: Object = heroes[1]
	war.set("max_hp", 223)
	war.set("hp", 100)
	mag.set("max_hp", 173)
	mag.set("hp", 90)
	for k in [2, 3]:
		heroes[k].set("hp", int(heroes[k].get("max_hp")))
	var pool: Array = heroes.filter(func(h): return not bool(h.get("dead")) and not bool(h.get("is_companion")))
	var pick: Object = scene.call("_lowest_hp", pool)
	print("    Warrior 100/223 (%.3f), Mage 90/173 (%.3f) -> %s" % [100.0 / 223.0, 90.0 / 173.0, pick.get("unit_name")])
	ok(pick == war, "§0b: the site picked %s, not the Warrior at 100/223 — it is not the share comparison the words say" % pick.get("unit_name"))
	# THE OTHER READING, AND IT IS A DIFFERENT HERO: by points the Mage is lowest.
	ok(int(mag.get("hp")) < int(war.get("hp")) and pick != mag,
		"§0b: the pair does not tell share from points — the arm above read nothing")
	var tal := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/talents.gd"))
	var t_at := tal.find("\"id\": \"tn_break_heal\"")
	var t_line := tal.substr(t_at, tal.find("\n\t{", t_at + 5) - t_at) if t_at >= 0 else ""
	var tithe := String(Runes.config("tithe").get("desc", "")).replace("\n", " ")
	ok(t_line.contains("heals the hero furthest from full") and tithe.contains("heals the hero furthest from full"),
		"§0b: the talent's words or Tithe's do not say *the hero furthest from full* (%s)" % tithe)
	scene.queue_free()
	await process_frame


# ── §1 — THE BAG SPLITS ─────────────────────────────────────────────────────

func _s1_the_bag_splits() -> void:
	print("\n§1 — the bag is the crest's; a class or core rune lives with its hero")
	# BATCH HS §0 — BOTH CAPS RULED (proposed at HR §1): the PROPOSED marker is off the two messages, the pins unchanged.
	ok(int(_run.HERO_HOLD_CAP) == 8, "§1: a hero holds %d unworn — RULED at HS §0 as 8" % int(_run.HERO_HOLD_CAP))
	ok(int(_run.BAG_CAP) == 6, "§1: the bag holds %d — RULED at HS §0 as 6 (four crest runes and two of headroom)" % int(_run.BAG_CAP))
	ok(_crest_ids().size() <= int(_run.BAG_CAP),
		"§1: %d crest runes exist and the bag holds %d — the headroom the cap was proposed with is gone" % [_crest_ids().size(), int(_run.BAG_CAP)])
	# (a) ROUTED BY SCOPE, through the one door.
	_new_run()
	var wi := _index_of("warrior")
	var mi := _index_of("mage")
	var w: Dictionary = _run.party[wi]
	var m: Dictionary = _run.party[mi]
	var crest := _crest_ids()
	var c1 := Runes.build(String(crest[0]))
	c1["equipped"] = true
	ok(_run.hold_rune(w, c1) == "worn" and _run.party_runes.size() == 1,
		"§1a: a crest rune asked to be worn did not fill the free crest")
	var c2 := Runes.build(String(crest[1]))
	c2["equipped"] = true
	ok(_run.hold_rune(m, c2) == "bag" and _run.rune_bag.size() == 1,
		"§1a: a second crest rune with the crest full did not go into the bag")
	var mage_ord := _class_ids("mage", false)
	var mage_core := _class_ids("mage", true).filter(func(x): return not Runes.held_engines(m).has(String(Runes.config(String(x)).get("engine", ""))))
	var r_m := Runes.build(String(mage_ord[0]))
	var where_m: String = _run.hold_rune(w, r_m)
	ok(where_m == "held" and _unworn(m).has(String(r_m["name"])) and not _names(w.get("runes", [])).has(String(r_m["name"])),
		"§1a: a Mage rune handed over in the Warrior's name went %s — not held by the Mage" % where_m)
	var r_core := Runes.build(String(mage_core[0]))
	var where_c: String = _run.hold_rune(m, r_core)
	ok(where_c == "held" and _names(m.get("engines", [])).has(String(r_core["name"])) and not bool(r_core["equipped"]),
		"§1a: a core rune not asked for went %s — not held unworn on his core list" % where_c)
	var r_w := Runes.build(String(_class_ids("warrior", false)[0]))
	r_w["equipped"] = true
	ok(_run.hold_rune(w, r_w) == "worn" and _run.runes_worn(w) == 1, "§1a: a Warrior rune asked to be worn with a slot free was not worn")
	ok(_run.rune_bag.all(func(r): return Runes.is_party_rune(r)), "§1a: the bag holds a rune that is not the crest's: %s" % [_names(_run.rune_bag)])
	ok(_run.holder_index(r_m) == mi and _run.holder_index(c1) == -1,
		"§1a: `holder_index` names %d for a Mage rune and %d for a crest rune" % [_run.holder_index(r_m), _run.holder_index(c1)])
	# (b) THE CAP: eight unworn a hero, both kinds counted, worn ones not.
	_new_run()
	m = _run.party[mi]
	w = _run.party[wi]
	var worn_before: int = _run.runes_worn(m) + _run.engines_worn(m)
	var placed := 0
	var ords := _class_ids("mage", false)
	var cores := _class_ids("mage", true).filter(func(x): return not Runes.held_engines(m).has(String(Runes.config(String(x)).get("engine", ""))))
	var feed: Array = ords.slice(0, 6) + cores.slice(0, 2)
	for id in feed:
		if _run.hold_rune(m, Runes.build(String(id))) == "held":
			placed += 1
	ok(placed == 8 and _run.held_count(m) == 8 and _run.holding_full(m),
		"§1b: eight Mage runes, six ordinary and two core, held %d (count %d)" % [placed, _run.held_count(m)])
	ok(_run.runes_worn(m) + _run.engines_worn(m) == worn_before, "§1b: holding runes changed what he wears")
	var ninth := Runes.build(String(ords[6]))
	ok(_run.hold_rune(m, ninth) == "pending" and _run.pending_rune_drops.size() == 1
			and _run.pending_holder(ninth) == mi,
		"§1b: the ninth Mage rune was not queued for the Mage's panel")
	var r_w2 := Runes.build(String(_class_ids("warrior", false)[1]))
	ok(_run.hold_rune(w, r_w2) == "held" and _run.pending_rune_drops.size() == 1,
		"§1b: ...a Warrior rune was queued too while only the Mage is full — the queue is not per holding")
	# Wearing one frees a place: the worn are not counted.
	var rows: Array = _run.rune_rows(m)
	var first_held := -1
	for i in rows.size():
		if not bool(rows[i]["worn"]):
			first_held = i
			break
	ok(first_held >= 0 and _run.toggle_rune(m, first_held) and _run.held_count(m) == 7,
		"§1b: equipping a held rune did not free a place (held %d)" % _run.held_count(m))
	ok(_run.settle_pending_drops() == 1 and _run.pending_rune_drops.is_empty() and _run.held_count(m) == 8
			and _unworn(m).has(String(ninth["name"])),
		"§1b: with a place free the waiting rune did not go straight in")
	# The panel's answers: take (drop one of HIS to make room) and decline.
	var tenth := Runes.build(String(ords[7]))
	ok(_run.hold_rune(m, tenth) == "pending", "§1b: the tenth Mage rune was not queued")
	var gone := String((_run.held_rows(m)[0]["rune"] as Dictionary).get("name", ""))
	ok(_run.take_pending_drop(0) and _run.held_count(m) == 8 and _unworn(m).has(String(tenth["name"]))
			and not _unworn(m).has(gone) and _run.pending_rune_drops.is_empty(),
		"§1b: taking the waiting rune did not drop %s of his for it" % gone)
	ok(_run.hold_rune(m, Runes.build(String(ords[8]))) == "pending" and not _run.decline_pending_drop().is_empty()
			and _run.pending_rune_drops.is_empty() and _run.held_count(m) == 8,
		"§1b: leaving the waiting rune behind did not let it go")
	# (c) A FULL HOLDING REFUSES AN UNEQUIP, AND A SWAP STILL WORKS.
	var worn_i := -1
	var held_i := -1
	rows = _run.rune_rows(m)
	for i in rows.size():
		if bool(rows[i]["worn"]) and worn_i < 0:
			worn_i = i
		elif not bool(rows[i]["worn"]) and held_i < 0:
			held_i = i
	var why: String = _run.rune_toggle_refusal(m, worn_i)
	ok(worn_i >= 0 and why == _run.held_full_note() and not _run.toggle_rune(m, worn_i),
		"§1c: an unequip into a full holding was not refused with its sentence (%s)" % why)
	var e_rows: Array = _run.engine_rows(m)
	var e_worn := -1
	for i in e_rows.size():
		if bool(e_rows[i]["worn"]):
			e_worn = i
	ok(e_worn >= 0 and _run.engine_toggle_refusal(m, e_worn) == _run.held_full_note(),
		"§1c: unslotting a core rune into a full holding is not refused with the same sentence")
	var worn_name := String((rows[worn_i]["rune"] as Dictionary).get("name", ""))
	var held_name := String((rows[held_i]["rune"] as Dictionary).get("name", ""))
	ok(_run.swap_rune(m, held_i, worn_i) and _run.held_count(m) == 8 and _unworn(m).has(worn_name)
			and not _unworn(m).has(held_name),
		"§1c: a swap on a full holding did not put %s on and keep %s held" % [held_name, worn_name])
	for wl in ["He holds %d unworn runes, the most he can." % int(_run.HERO_HOLD_CAP)]:
		ok(_run.held_full_note().begins_with(wl), "§1c: the sentence reads '%s'" % _run.held_full_note())
	var wide := 0
	for ln in _run.held_full_note().split("\n"):
		wide = maxi(wide, ln.length())
	ok(wide <= 44, "§1c: the refusal sentence runs %d characters on a line, over the 44" % wide)
	# (d) EVERY DOOR ROUTES THE SAME WAY.
	_new_run()
	var hi := _index_of("hunter")
	var h: Dictionary = _run.party[hi]
	var keep_one := ""
	for id in _union_offerable():
		if Runes.rune_class(Runes.build(String(id))) == "hunter" and not Runes.is_engine_rune(String(id)):
			keep_one = String(id)
			break
	_park(_union_offerable().filter(func(x): return String(x) != keep_one))
	var parked: Array = _run.pending_rune_drops.duplicate()
	var drop: Dictionary = _run.drop_after_fight()
	_run.pending_rune_drops = parked
	ok(String(drop.get("where", "")) == "held" and int(drop.get("hero", -1)) == hi
			and _unworn(h).has(String((drop.get("rune", {}) as Dictionary).get("name", "?")))
			and (_run.last_drop as Dictionary).get("rune", {}) == drop.get("rune", {}),
		"§1d: the drop landed %s on hero %d, not held by the Hunter and recorded for the map" % [drop.get("where", ""), int(drop.get("hero", -1))])
	_run.pending_rune_drops = []
	_run.last_drop = {}
	var buy := Runes.build(String(_class_ids("cleric", false)[0]))
	var ci := _index_of("cleric")
	_run.gold = 400
	ok(_run.buy_rune(buy, _run.party[ci]) and _run.gold == 400 - int(_run.rune_price(buy))
			and _unworn(_run.party[ci]).has(String(buy["name"])),
		"§1d: a rune bought for the Cleric is not held by him, or the price did not move")
	var cleric: Dictionary = _run.party[ci]
	var c_ords := _class_ids("cleric", false)
	var k := 1
	while _run.held_count(cleric) < int(_run.HERO_HOLD_CAP) and k < c_ords.size():
		_run.hold_rune(cleric, Runes.build(String(c_ords[k])))
		k += 1
	var refused_buy := Runes.build(String(c_ords[k]))
	var g0: int = _run.gold
	var refusal: String = _run.buy_refusal(refused_buy, cleric)
	ok(not _run.buy_rune(refused_buy, cleric) and _run.gold == g0 and refusal.begins_with("Cleric holds %d unworn runes" % int(_run.HERO_HOLD_CAP)),
		"§1d: a purchase for a full holding was not refused before the gold moved (%s)" % refusal)
	ok(_run.buy_refusal(Runes.build(String(_class_ids("warrior", false)[0])), _run.party[wi]) == "",
		"§1d: ...the Warrior's purchase is refused too, with only the Cleric full")
	var sold_name := String((_run.held_rows(cleric)[0]["rune"] as Dictionary).get("name", ""))
	var g1: int = _run.gold
	var got: int = _run.sell_held_rune(cleric, 0)
	ok(got > 0 and _run.gold == g1 + got and not _unworn(cleric).has(sold_name)
			and _run.held_count(cleric) == int(_run.HERO_HOLD_CAP) - 1,
		"§1d: selling a held rune did not pay and take it from him")
	# The event verb: onto its taker. **THE CREST'S RUNES ARE HELD FIRST, SO THE GRANT IS A
	# HERO'S** — nothing held is offered again — or the arm would read whatever the dice
	# dealt: R30's control shifted them and the verb drew Dirge, a crest rune, into the bag.
	# HR's own rule (*an arm that reads what the dice dealt is a coin flip*), met in this gate.
	_new_run()
	for cid in _crest_ids():
		_run.hold_rune({}, Runes.build(String(cid)))
	for mm in _run.party:
		for rid in _class_ids(String(mm["key"]), false).slice(0, 3):
			var worn_r := Runes.build(String(rid))
			worn_r["equipped"] = true
			_run.hold_rune(mm, worn_r)
	var held0 := 0
	for mm in _run.party:
		held0 += _run.held_count(mm)
	var line: String = Events.apply(_run, {"effect": "rune_grant", "amount": 1})
	var held1 := 0
	var on_whom := ""
	for mm in _run.party:
		held1 += _run.held_count(mm)
		if _run.held_count(mm) > 0:
			on_whom = String(mm["key"])
	ok(held1 == held0 + 1 and on_whom != "" and line.contains("held, not worn") and _run.rune_bag.all(func(r): return Runes.is_party_rune(r)),
		"§1d: the event verb with every slot full did not leave the rune held on its taker (%s)" % line)


# §1e — the save: a v14 bag handed out on load, a rune with no hero here kept.
func _write_save(d: Dictionary) -> void:
	var f := FileAccess.open(_run.save_path, FileAccess.WRITE)
	f.store_var(d, true)
	f.close()


func _s1e_the_save() -> void:
	print("\n§1e — a v14 save's bag is handed out on load; a rune whose class is absent is kept, and said")
	var keep_path: String = _run.save_path
	_run.save_path = SCRATCH_SAVE
	_new_run(["warrior", "warrior", "mage", "cleric"])
	var m_ords := _class_ids("mage", false)
	var m_core := _class_ids("mage", true).filter(func(x): return not Runes.held_engines(_run.party[2]).has(String(Runes.config(String(x)).get("engine", ""))))
	var worn_r := Runes.build(String(m_ords[0]))
	worn_r["equipped"] = true
	_run.party[2]["runes"] = [worn_r]
	var bag: Array = [Runes.build(String(m_ords[1])), Runes.build(String(_class_ids("warrior", false)[0])),
		Runes.build(String(_crest_ids()[0])), Runes.build(String(m_core[0])),
		Runes.build(String(m_ords[2])), Runes.build(String(_class_ids("hunter", false)[0]))]
	var before: Array = _names(bag) + _names(_run.party[2]["runes"])
	for mm in _run.party:
		before.append_array(_names(mm.get("engines", [])))
	_run.rune_bag = bag
	_run.save_run()
	var d: Dictionary = FileAccess.open(SCRATCH_SAVE, FileAccess.READ).get_var(true)
	d["version"] = 14
	_write_save(d)
	_run.rune_bag = []
	_run.party = []
	ok(_run.load_run(), "§1e: a v14 save did not load")
	var mage: Dictionary = _run.party[2]
	ok(_unworn(mage).slice(0, 2) == [String(bag[0]["name"]), String(bag[4]["name"])]
			and _names(mage.get("engines", [])).has(String(bag[3]["name"])),
		"§1e: the Mage was not handed his two runes in the bag's order and his core rune (%s)" % [_unworn(mage)])
	ok(_names(mage.get("runes", []))[0] == String(worn_r["name"]) and bool((mage["runes"][0] as Dictionary).get("equipped", false)),
		"§1e: the rune the Mage wore moved or came off")
	ok(_unworn(_run.party[0]) == [String(bag[1]["name"])] and _unworn(_run.party[1]).is_empty(),
		"§1e: the Warrior rune did not go to the first Warrior (%s / %s)" % [_unworn(_run.party[0]), _unworn(_run.party[1])])
	ok(_names(_run.rune_bag) == [String(bag[2]["name"]), String(bag[5]["name"])],
		"§1e: the bag after the load holds %s — want the crest rune and the Hunter's" % [_names(_run.rune_bag)])
	ok(_run.bag_strays().size() == 1 and _run.load_notes.size() == 1
			and String(_run.load_notes[0]).contains(String(bag[5]["name"])) and String(_run.load_notes[0]).contains("Hunter"),
		"§1e: the Hunter rune with no Hunter here was not kept and said (%s)" % [_run.load_notes])
	var after: Array = _names(_run.rune_bag)
	for mm in _run.party:
		after.append_array(_names(mm.get("runes", [])))
		after.append_array(_names(mm.get("engines", [])))
	before.sort()
	after.sort()
	ok(before == after, "§1e: the load did not conserve the runes: %s against %s" % [after, before])
	_run.save_run()
	var d2: Dictionary = FileAccess.open(SCRATCH_SAVE, FileAccess.READ).get_var(true)
	ok(int(d2.get("version", 0)) == int(_run.SAVE_VERSION) and int(_run.SAVE_VERSION) > 14,
		"§1e: the save is written as version %d — the bag's meaning moved and the version did not" % int(d2.get("version", 0)))
	# A HERO MAY OPEN OVER HIS CAP: nothing is dropped, and the next waits.
	_new_run()
	var many: Array = []
	for id in _class_ids("mage", false).slice(1, 11):
		many.append(Runes.build(String(id)))
	_run.rune_bag = many
	_run.save_run()
	var d3: Dictionary = FileAccess.open(SCRATCH_SAVE, FileAccess.READ).get_var(true)
	d3["version"] = 14
	_write_save(d3)
	ok(_run.load_run(), "§1e: the over-full v14 save did not load")
	var mi := _index_of("mage")
	ok(_run.held_count(_run.party[mi]) == 10 and _run.rune_bag.is_empty(),
		"§1e: the Mage was handed %d of ten — a migration drops nothing" % _run.held_count(_run.party[mi]))
	ok(_run.hold_rune(_run.party[mi], Runes.build(String(_class_ids("mage", false)[11]))) == "pending",
		"§1e: ...and over his cap the next Mage rune did not wait")
	_remove(SCRATCH_SAVE)
	_run.save_path = keep_path


# §1f — the surfaces that read a holding, on the real screens.
func _s1f_the_surfaces() -> void:
	print("\n§1f — the surfaces: the map's bag row, his panel, the Peddler's rows and the summary")
	_new_run()
	var mi := _index_of("mage")
	var m: Dictionary = _run.party[mi]
	for id in _class_ids("mage", false).slice(0, 2):
		_run.hold_rune(m, Runes.build(String(id)))
	_run.hold_rune(m, Runes.build(String(_crest_ids()[0])))
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	var s: Node = current_scene
	ok(Gate.has_text(s, "Rune bag  1/%d" % int(_run.BAG_CAP)), "§1f: the map's bag row does not read 'Rune bag  1/%d'" % int(_run.BAG_CAP))
	s.call("_open_rune_panel", mi)
	await process_frame
	var ov: Node = Gate.overlay(current_scene, 60)
	ok(ov != null and Gate.has_text(ov, "HELD, NOT WORN: 2 of %d" % int(_run.HERO_HOLD_CAP)) and Gate.has_text(ov, "(held)"),
		"§1f: the Mage's panel does not say what he holds")
	ok(ov != null and not Gate.has_text(ov, "(in the bag)"), "§1f: the Mage's panel still lists a rune as in the bag")
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	s = current_scene
	ok(Gate.has_text(s, "held by him; equip it on the map"), "§1f: no Peddler row says the rune goes to its hero")
	ok(Gate.has_text(s, "SELL A RUNE NOBODY WEARS") and Gate.has_text(s, "held by %s" % s.call("_hero_label", mi)),
		"§1f: the Sell rows do not list the Mage's held runes under his name")
	var bat := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bat.contains("\"\\n    Held, not worn: %s\""), "§1f: the run summary has no line for the runes a hero holds unworn")


# ── §2 — THE NAMEPLATE ──────────────────────────────────────────────────────

func _fight_from_map(s: Node) -> Node:
	var nxt: int = int(_run.slot_idx) + 1
	var pick := -1
	for j in _run.reachable():
		if String(_run.map[nxt][int(j)]["type"]) == "fight":
			pick = int(j)
			break
	if pick < 0:
		return null
	var btn: Button = Gate.bound_button(s, "_on_node_pressed", [pick])
	if btn == null:
		return null
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	btn.emit_signal("pressed")
	await Gate.frames(self, 4)
	var b: Node = current_scene
	var guard := 0
	while _is_battle(b) and not bool(b.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	await Gate.frames(self, 6)
	return current_scene


# The map after a card's Continue, read before its toast can fade: real time.
func _arrive() -> void:
	for _i in 4:
		Engine.time_scale = 1.0
		await process_frame


func _s2_the_nameplate() -> void:
	print("\n§2 — a real fight's drop on the right nameplate, equipped from it, and the marker gone")
	seed(DROP_SEED)
	_new_run()
	# Every crest rune into the bag first, so the drop is a hero's: the bag's own
	# marker reads them, and no hero's does.
	for id in _crest_ids():
		_run.bag_rune(Runes.build(String(id)))
	var crest_n: int = _run.rune_bag.size()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	var s: Node = current_scene
	ok(_marker(s, "held_marker").is_empty(), "§2: a nameplate shows a marker before anything is held")
	var bag_m: Array = _marker(s, "crest_marker")
	ok(bag_m.size() == 1 and int((bag_m[0] as Button).get_meta("crest_marker")) == crest_n
			and String((bag_m[0] as Button).text).contains("✦ %d" % crest_n),
		"§2: the bag's row does not mark the %d crest runes in it" % crest_n)
	var card: Node = await _fight_from_map(s)
	ok(_is_battle(card) and bool(card.get("battle_over")), "§2: the normal fight from the map did not end")
	var drop: Dictionary = _run.last_drop
	var hi := int(drop.get("hero", -1))
	var rune: Dictionary = drop.get("rune", {})
	var nm := String(rune.get("name", ""))
	ok(String(drop.get("where", "")) == "held" and hi >= 0 and _unworn(_run.party[hi]) == [nm],
		"§2: the drop (%s) is not held by one hero, alone" % nm)
	var plate: String = _run.nameplate(_run.party[hi]) if hi >= 0 else "?"
	ok(Gate.has_text(card, "RUNE DROP: %s, for the %s" % [nm, plate]), "§2: the victory card does not name the drop and the %s" % plate)
	ok(Gate.press(card, ["Continue", "Walk on", "Onward"]) != "", "§2: the victory card drew nothing to press")
	# AT TIME SCALE ONE: the toast fades in 1.9 s of game time, which `Gate.frames`'
	# hundredfold scale spends in two frames.
	await _arrive()
	s = current_scene
	ok(Gate.scene_name(self) == "Map", "§2: the card did not lead back to the map (%s)" % Gate.scene_name(self))
	ok(Gate.has_text(s, "%s drops for the %s" % [nm, plate]), "§2: the map's toast does not name the drop and the %s" % plate)
	var mk: Button = _hero_marker(s, hi)
	ok(mk != null and String(mk.text) == "✦ 1" and int(mk.get_meta("held_marker")) == 1,
		"§2: the %s's nameplate does not mark one rune waiting (%s)" % [plate, mk.text if mk != null else "<no marker>"])
	ok(_marker(s, "held_marker").size() == 1, "§2: ...and %d nameplates are marked — want only his" % _marker(s, "held_marker").size())
	bag_m = _marker(s, "crest_marker")
	ok(bag_m.size() == 1 and int((bag_m[0] as Button).get_meta("crest_marker")) == crest_n, "§2: a hero's drop moved the bag's marker")
	# OPENING THE PANEL DOES NOT CLEAR IT: the count is the holding's, not a flag.
	mk.emit_signal("pressed")
	await process_frame
	var ov: Node = Gate.overlay(current_scene, 60)
	ok(ov != null and Gate.has_text(ov, nm), "§2: the marker did not open the %s's rune panel on the drop" % plate)
	Gate.press(ov, ["Close"])
	await Gate.frames(self, 2)
	s.call("_draw_screen")
	await process_frame
	mk = _hero_marker(current_scene, hi)
	ok(mk != null and String(mk.text) == "✦ 1", "§2: opening and closing the panel cleared the marker with the rune still waiting")
	# EQUIP IT FROM THE PANEL, THROUGH ITS OWN BUTTON.
	mk.emit_signal("pressed")
	await process_frame
	ov = Gate.overlay(current_scene, 60)
	var rows: Array = _run.rune_rows(_run.party[hi])
	var ri := -1
	for i in rows.size():
		if String((rows[i]["rune"] as Dictionary).get("name", "")) == nm:
			ri = i
	var method := "_toggle_rune"
	if ri < 0:
		rows = _run.engine_rows(_run.party[hi])
		method = "_toggle_engine"
		for i in rows.size():
			if String((rows[i]["rune"] as Dictionary).get("name", "")) == nm:
				ri = i
	var eq: Button = Gate.bound_button(ov, method, [hi, ri, ov]) if ov != null else null
	ok(eq != null and String(eq.text) == "Equip", "§2: the panel has no Equip for %s" % nm)
	if eq != null:
		eq.emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(_unworn(_run.party[hi]).is_empty(), "§2: the rune was not equipped")
	ok(_hero_marker(current_scene, hi) == null and _marker(current_scene, "held_marker").is_empty(),
		"§2: with nothing waiting the %s's marker is still drawn" % plate)
	var ov2: Node = Gate.overlay(current_scene, 60)
	if ov2 != null:
		Gate.press(ov2, ["Close"])
		await process_frame
	# THE COUNT IS THE COUNT: three held read three.
	var other: int = (hi + 1) % int(_run.party.size())
	var okey := String(_run.party[other]["key"])
	for id in _class_ids(okey, false).slice(4, 7):
		_run.hold_rune(_run.party[other], Runes.build(String(id)))
	current_scene.call("_draw_screen")
	await process_frame
	var mk3: Button = _hero_marker(current_scene, other)
	ok(mk3 != null and String(mk3.text) == "✦ 3", "§2: three held runes read %s on the nameplate" % (mk3.text if mk3 != null else "<no marker>"))
	# (b) A CREST DROP MOVES THE BAG'S MARKER, AND NO HERO'S.
	_new_run()
	var marks0 := {}
	for i in _run.party.size():
		for id in _class_ids(String(_run.party[i]["key"]), false) + _class_ids(String(_run.party[i]["key"]), true):
			if Runes.wearable_by(Runes.build(String(id)), _run.party[i]) and _union_offerable().has(String(id)):
				_run.call("_put_on_hero", _run.party[i], Runes.build(String(id)))
		marks0[i] = _run.held_count(_run.party[i])
	var left: Array = _union_offerable()
	ok(not left.is_empty() and left.all(func(x): return Runes.is_party_rune(Runes.build(String(x)))),
		"§2b: the narrowed pool is not the crest's alone (%s)" % [left])
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	card = await _fight_from_map(current_scene)
	var cdrop: Dictionary = _run.last_drop
	var cnm := String((cdrop.get("rune", {}) as Dictionary).get("name", ""))
	ok(String(cdrop.get("where", "")) == "bag" and int(cdrop.get("hero", 0)) == -1 and _names(_run.rune_bag) == [cnm],
		"§2b: a crest drop (%s) did not go into the bag" % cnm)
	ok(Gate.has_text(card, "RUNE DROP: %s, for the crest" % cnm), "§2b: the card does not say the crest drop is the crest's")
	Gate.press(card, ["Continue", "Walk on", "Onward"])
	await _arrive()
	var cm: Array = _marker(current_scene, "crest_marker")
	ok(cm.size() == 1 and int((cm[0] as Button).get_meta("crest_marker")) == 1, "§2b: the bag's marker does not read the crest drop")
	var moved := PackedStringArray()
	for i in _run.party.size():
		var mki: Button = _hero_marker(current_scene, i)
		if mki == null or int(mki.get_meta("held_marker")) != int(marks0[i]):
			moved.append(String(_run.party[i]["key"]))
	ok(moved.is_empty(), "§2b: a crest drop moved the nameplate marker of %s" % [moved])
	ok(Gate.has_text(current_scene, "%s drops for the crest" % cnm), "§2b: the map's toast does not say the drop is the crest's")
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")


# ── §3 — THE FIRST NODES ────────────────────────────────────────────────────

func _s3_the_first_nodes() -> void:
	print("\n§3 — no Peddler and no Smith in the run's first %d nodes" % int(_run.SHOP_GATE_NODES))
	var gate_n: int = int(_run.SHOP_GATE_NODES)
	ok(gate_n == 3, "§3: the gate is %d nodes — ruled at three, measured at HR §3" % gate_n)
	var in_gate := 0
	var short := PackedStringArray()
	var later_early := 0
	var z1_kinds := {}
	_new_run()
	for z in 3:
		for i in BOARDS:
			seed(BOARD_SEED + i + 1000 * z)
			_run.zone_idx = z
			_run._generate_map()
			var cnt := {}
			for slot in _run.map:
				for node in slot:
					var ty := String(node["type"])
					cnt[ty] = int(cnt.get(ty, 0)) + 1
			for ty2 in ["elite", "blacksmith", "merchant", "event"]:
				if int(cnt.get(ty2, 0)) != int(_run.NODE_COPIES[ty2]):
					short.append("zone %d board %d: %s %d" % [z + 1, i, ty2, int(cnt.get(ty2, 0))])
			for c in range(1, gate_n + 1):
				for node in _run.map[_run.column_slot(c)]:
					var ty3 := String(node["type"])
					if z == 0:
						z1_kinds[ty3] = int(z1_kinds.get(ty3, 0)) + 1
					if ty3 in ["merchant", "blacksmith"]:
						if z == 0:
							in_gate += 1
						else:
							later_early += 1
	print("    CHECKED %d boards a zone: zone 1's first %d columns held %s" % [BOARDS, gate_n, z1_kinds])
	ok(in_gate == 0, "§3a: %d Peddlers or Smiths stood in zone 1's first %d columns" % [in_gate, gate_n])
	ok(int(z1_kinds.get("fight", 0)) > 0, "§3a: ...and those columns held no fight at all — the absence read nothing")
	ok(short.is_empty(), "§3a: a board was dealt short of a kind: %s" % [short.slice(0, 4)])
	ok(later_early > 0, "§3a: no zone after the first put a Peddler or a Smith in its first %d columns in %d boards — the gate is the run's, not every zone's" % [gate_n, 2 * BOARDS])
	# THE REAL MAP: a fresh run's first columns, as the screen draws them.
	_new_run()
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	var s: Node = current_scene
	var drawn := PackedStringArray()
	for b in Gate.lattice_buttons(s):
		drawn.append(String((b as Button).text))
	var shops_early := 0
	var nodes_early := 0
	for c in range(1, gate_n + 1):
		for node in _run.map[_run.column_slot(c)]:
			nodes_early += 1
			if String(node["type"]) in ["merchant", "blacksmith"]:
				shops_early += 1
	ok(nodes_early >= 2 * gate_n and shops_early == 0 and Gate.lattice_buttons(s).size() > nodes_early,
		"§3b: the real map's first %d columns hold %d shops among %d nodes" % [gate_n, shops_early, nodes_early])
	# A WHOLE RUN'S BOARDS, COUNTED: sixteen, sixteen and seventeen columns.
	var sizes: Array = []
	_new_run()
	for z in 3:
		sizes.append(_run.map.size())
		if _run.has_next_zone():
			_run.advance_zone()
	ok(sizes == [16, 16, 17], "§3c: a whole run's boards were %s columns long — want 16, 16 and 17" % [sizes])


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
