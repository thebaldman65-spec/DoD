# BATCH HL — WHAT THE PLAYTHROUGH FOUND.
#
#   §0  THE GROUND — this process writes the harness save, and scratch meta files
#   §1  THE FIVE DEFECTS, DRIVEN, EACH BOTH WAYS:
#       a  a pick hands over one card — every card of every class under every set
#          of engines a hero can slot, taken one at a time; Fireball drafted on the
#          real draft screen; and a core rune taken from a cache waits in the bag,
#          its enabler joining the kit only when the rune is slotted on the panel
#       b  the Peddler never offers a core rune, and a cache still can; the
#          counter says why when core runes are all that is left
#       c  a rune bought through the Buy button lands in the bag, the map counts
#          it, and the hero's panel equips it
#       d  the Stances bring Guard Change, and it changes the stance in a fight
#       e  Preparation, and every card shaped like it, asks for no target in a
#          fight, and still does what it does
#   §2  THE CORE RUNES — every engine rune's name wears "(core)"; no "Engine:"
#       prefix on the rule text; no player-facing string calls it an engine rune;
#       every hand-broken note under 44 with the longer names, and the log line
#       quoting the note's first sentence; an old name in a save takes today's
#   §3  THE FOUR MAGNITUDES — the Bastion banks only what is blocked, parried or
#       absorbed; Aggressive deals +30%; each Mercy stack takes 5% off; Faith
#       releases at eight
#   §5  THE CEILING — a save from a newer build is refused, and neither written
#       nor deleted; the floor at ten did not move
#   §6  A CONDITION ON WHO IS IN THE PARTY — five keys, each driven both ways over
#       a fixture crest rune never written to the file, two Warriors among them
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM** (the brief's rule): an absence is
# asked beside the arm that shows the window held something, and a population
# prints how many it checked, so a walk over nothing reads red.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hl.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://hl_profile.json"
const SCRATCH_RELICS := "user://hl_relics.json"
const HL_SEED := 20260929
const FRAME_CAP := 20000
# §1e — the cards the designer met and the nine the sweep found beside it, each
# with the lineage whose hero is seated to cast it. The population itself is
# DERIVED in §1e from `battle.gd`; this is only who casts what in the drive.
const SELF_CASTS := {
	"Preparation": "mystic", "Salve": "mystic", "Thick Hide": "mystic",
	"Dug In": "sharpshooter",
	"Bloodbond": "beastmaster", "Savage Sweep": "beastmaster",
	"Ghostpack": "beastmaster", "Bear the Brunt": "beastmaster",
	"Bring It Down": "beastmaster",
	"Sanctuary": "holy",
}

# §6's fixture crest rune, put into the loaded table for §6 and taken out again —
# the file holds none (ruled: author none).
const CREST_FX := "hl_fixture_crest"
const CREST_HP := 9
# §6's hero-rune arm: the same condition on a rune ONE hero wears, which the spawn
# hands the four through the same ctx as the crest's.
const HERO_FX := "hl_fixture_hero_rune"
const HERO_FX_HP := 7

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HL — WHAT THE PLAYTHROUGH FOUND")
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
	await _s1a_one_pick_one_card()
	await _s1b_the_counter()
	await _s1c_the_purchase()
	await _s1d_the_stances()
	await _s1e_no_target()
	await _s2_core_runes()
	await _s3_magnitudes()
	await _s5_the_ceiling()
	await _s6_party_condition()
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


# A fresh run of the four, each awakened on the engine rune named for his seat
# (or his class's first), so a check starts from a party the game can produce.
func _new_run(engines := {}) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		var pid := String(engines.get(key, Classes.class_engines(key)[0]))
		_run.awaken(i, Runes.engine_rune_id(pid))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []


# A member of `cls` holding exactly `engines`, slotted, with nothing earned —
# built off the party's own dict so every key the game reads is there.
func _member(tmpl: Dictionary, engines: Array) -> Dictionary:
	var m: Dictionary = tmpl.duplicate(true)
	var pouch: Array = []
	for pid in engines:
		var r: Dictionary = Runes.build(Runes.engine_rune_id(String(pid)))
		r["equipped"] = true
		pouch.append(r)
	m["engines"] = pouch
	m["spec"] = Classes.engine_spec(String(engines[0])) if not engines.is_empty() else ""
	m["awakened"] = true
	m["tree"] = Talents.tree()
	m["runes"] = []
	m["talents"] = {}
	m["bm_abilities"] = []
	m["bm_equipped"] = []
	return m


# Every card this hero's kit is read as, by every door: the opening kit, what
# the next fight seats, and the kit a rune's gate reads.
func _kit_read(m: Dictionary) -> Array:
	var out: Array = []
	for n in _run.opening_kit_names(m) + _run.seated_ability_names(m) + Runes.kit_names(m):
		if not out.has(String(n)):
			out.append(String(n))
	return out


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	return current_scene


func _names(units: Array) -> Array:
	var out: Array = []
	for a in units:
		out.append(a.display_name if a is Ability else String((a as Dictionary).get("name", "")))
	return out


# ── §1a — ONE PICK, ONE CARD ────────────────────────────────────────────────

func _s1a_one_pick_one_card() -> void:
	print("\n§1a — a pick hands over one card")
	_new_run()
	var tmpl := {}
	for m in _run.party:
		tmpl[String(m["key"])] = (m as Dictionary).duplicate(true)
	# (i) THE WHOLE POPULATION: every card a hero of each class can earn — his
	# class's draft pool and his lineage's boss pool — taken on its own, under every
	# set of engines he can slot. What his kit reads afterwards is what it read
	# before, and the card.
	var asked := 0
	var extras: Array = []
	var sets := 0
	for cls in SEATS:
		for es in Gate.engine_sets(Classes.class_engines(String(cls)), 2):
			sets += 1
			var m0 := _member(tmpl[cls], es)
			var cards: Array = Classes.draft_pool(String(cls)).duplicate()
			for n in Classes.spec_pool(String(m0.get("spec", ""))):
				if not cards.has(n):
					cards.append(n)
			for card in cards:
				var m := _member(tmpl[cls], es)
				var before := _kit_read(m)
				_run.hold_ability(m, String(card), true)
				asked += 1
				for n in _kit_read(m):
					if n != card and not before.has(n):
						extras.append("%s %s took %s: +%s" % [cls, str(es), card, n])
	print("    CHECKED %d takes over %d engine sets" % [asked, sets])
	ok(asked > 1000 and sets == 4 * 22, "§1a: the sweep walked %d takes over %d sets — not the population" % [asked, sets])
	ok(extras.is_empty(), "§1a: a pick handed over a second card: %s" % [extras.slice(0, 6)])
	# The positive arm the sweep stands beside: an ENGINE does bring a card, so the
	# read above can see one arrive — the Rune of the Cryomancer brings Razor Ice.
	var cryo := _member(tmpl["mage"], ["permafrost"])
	var bare := _member(tmpl["mage"], [])
	ok(_kit_read(cryo).has("Razor Ice") and not _kit_read(bare).has("Razor Ice"),
		"§1a: the kit read cannot see an enabler arrive with its engine — the sweep proves nothing")

	# (ii) FIREBALL, ON THE REAL DRAFT SCREEN, under the two engines the defect
	# names and none.
	for es2 in [["overburn"], ["permafrost"], []]:
		_new_run({"mage": es2[0] if not es2.is_empty() else "channel"})
		var mage: Dictionary = _run.party[1]
		if es2.is_empty():
			mage["engines"] = []
		var before2 := _kit_read(mage)
		mage["draft_candidates"] = [["Fireball"]]
		mage["draft_picks_owed"] = 1
		var mp := await _to_map()
		var ov: Node = Gate.overlay(mp, 62)
		var stage: Button = Gate.bound_button(ov, "_stage_draft", [1, "Fireball"]) if ov != null else null
		ok(stage != null, "§1a: the draft screen drew no Fireball for the Mage (%s)" % [es2])
		if stage != null:
			stage.emit_signal("pressed")
			await Gate.frames(self, 2)
		var conf := Gate.press(Gate.overlay(current_scene, 62), ["Confirm the draft"])
		await Gate.frames(self, 3)
		ok(conf == "Confirm the draft", "§1a: the draft would not confirm (%s)" % [es2])
		var gained: Array = _kit_read(mage).filter(func(n): return not before2.has(n))
		ok(gained == ["Fireball"], "§1a: drafting Fireball under %s handed over %s" % [es2, gained])
		# And the fight: the Mage's bar gains exactly the card.
		var spec_m := String(mage.get("spec", ""))
		var sc: Node = await Gate.spawn(self, ["berserker", spec_m, "holy", "beastmaster"],
			{"party": {1: {"engines": mage["engines"], "bm_abilities": [], "bm_equipped": []}}})
		var bar0 := _names(sc.get("heroes")[1].abilities)
		sc.queue_free()
		await process_frame
		sc = await Gate.spawn(self, ["berserker", spec_m, "holy", "beastmaster"],
			{"party": {1: {"engines": mage["engines"], "bm_abilities": ["Fireball"], "bm_equipped": ["Fireball"]}}})
		var bar1 := _names(sc.get("heroes")[1].abilities)
		sc.queue_free()
		await process_frame
		var bar_gain: Array = bar1.filter(func(n): return not bar0.has(n))
		ok(bar_gain == ["Fireball"] and bar1.size() == bar0.size() + 1,
			"§1a: the fight's bar under %s gained %s with Fireball" % [es2, bar_gain])

	# (iii) A CORE RUNE TAKEN FROM A CACHE WAITS IN THE BAG. Its enabler is the
	# one card a pick could bring beside it; it joins the kit when the player slots
	# the rune on the hero's panel, and not before.
	_new_run({"mage": "overburn"})
	var mg: Dictionary = _run.party[1]
	var core := Runes.build(Runes.engine_rune_id("permafrost"))
	var plain_id := ""
	for id in Runes.eligible_ids(mg, Runes.owned_names(mg, _run.party_rune_names())):
		if not Runes.is_engine_rune(String(id)):
			plain_id = String(id)
			break
	ok(plain_id != "", "§1a: no ordinary rune the Mage could be offered — the positive arm has nothing")
	var plain := Runes.build(plain_id)
	mg["rune_candidates"] = [[core, plain]]
	mg["rune_picks_owed"] = 1
	var kit0 := _kit_read(mg)
	var eng0: Array = _run.held_engines(mg)
	var mp2 := await _to_map()
	var choose: Button = Gate.bound_button(mp2, "_open_pick_overlay", [1])
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
	var pick_ov: Node = Gate.overlay(current_scene, 60)
	var took := Gate.press(pick_ov, [String(core["name"])]) if pick_ov != null else ""
	await Gate.frames(self, 3)
	ok(took == String(core["name"]), "§1a: the cache drew no button for %s" % core["name"])
	ok(_names(_run.rune_bag).has(String(core["name"])) and _run.held_engines(mg) == eng0,
		"§1a: the core rune taken from the cache went onto the Mage (engines %s, bag %s)" % [
			_run.held_engines(mg), _names(_run.rune_bag)])
	ok(_kit_read(mg) == kit0 and not _kit_read(mg).has("Razor Ice"),
		"§1a: taking a core rune from a cache put a card in the kit: %s" % [
			_kit_read(mg).filter(func(n): return not kit0.has(n))])
	# Slot it through the panel's own button: now, and only now, Razor Ice.
	var mp3: Node = current_scene
	mp3.call("_open_rune_panel", 1)
	await process_frame
	var panel: Node = Gate.overlay(current_scene, 60)
	var rows: Array = _run.engine_rows(mg)
	var bag_row := -1
	for ri in rows.size():
		if String(rows[ri]["src"]) == "bag" and String((rows[ri]["rune"] as Dictionary).get("engine", "")) == "permafrost":
			bag_row = ri
	var slot_btn: Button = Gate.bound_button(panel, "_toggle_engine", [1, bag_row, panel]) if panel != null else null
	ok(slot_btn != null, "§1a: the Mage's panel drew no button to slot the core rune from the bag")
	if slot_btn != null:
		slot_btn.emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(_run.held_engines(mg).has("permafrost") and _kit_read(mg).has("Razor Ice"),
		"§1a: slotting the core rune did not bring its enabler (%s)" % [_kit_read(mg)])
	# THE POSITIVE ARM OF THE CACHE: an ordinary rune is still worn at the pick
	# while a slot is free — the pick saves the click it always saved.
	_new_run({"mage": "overburn"})
	var mg2: Dictionary = _run.party[1]
	mg2["rune_candidates"] = [[Runes.build(plain_id)]]
	mg2["rune_picks_owed"] = 1
	var mp4 := await _to_map()
	var ch2: Button = Gate.bound_button(mp4, "_open_pick_overlay", [1])
	if ch2 != null:
		ch2.emit_signal("pressed")
		await process_frame
	var ov4: Node = Gate.overlay(current_scene, 60)
	if ov4 != null:
		Gate.press(ov4, [String(plain["name"])])
	await Gate.frames(self, 3)
	ok(_names(mg2.get("runes", [])).has(String(plain["name"])) and _run.runes_worn(mg2) == 1,
		"§1a: an ordinary rune taken from a cache was not worn while a slot was free")


# ── §1b — THE PEDDLER'S COUNTER ─────────────────────────────────────────────

# The counter's own roll, `Run.peddler_rune`. A tree without that door rolls the
# counter through `generate_rune`, which is what the screen did before HL — so
# this gate reads that tree red rather than throwing on it.
func _counter_roll(m: Dictionary) -> Dictionary:
	if _run.has_method("peddler_rune"):
		return _run.call("peddler_rune", m)
	return _run.generate_rune(m)


func _s1b_the_counter() -> void:
	print("\n§1b — the Peddler never offers a core rune; a cache still can")
	seed(HL_SEED)
	var counter_core := 0
	var counter_n := 0
	var cache_core := 0
	var cache_n := 0
	for es_key in ["none", "one"]:
		for _trial in 25:
			_new_run()
			for m in _run.party:
				if es_key == "none":
					m["engines"] = []
				var r: Dictionary = _counter_roll(m)
				if not r.is_empty():
					counter_n += 1
					if String(r.get("engine", "")) != "":
						counter_core += 1
				var c: Dictionary = _run.generate_rune(m)
				if not c.is_empty():
					cache_n += 1
					if String(c.get("engine", "")) != "":
						cache_core += 1
	print("    CHECKED %d counter rolls (%d core) and %d cache rolls (%d core)" % [
		counter_n, counter_core, cache_n, cache_core])
	ok(counter_n >= 150 and counter_core == 0,
		"§1b: the Peddler's roll put %d core runes on %d offers" % [counter_core, counter_n])
	ok(cache_core > 0, "§1b: the cache's roll drew no core rune in %d — the positive arm cannot tell a door from a dead pool" % cache_n)
	# Through the real screen, every offer on the counter is ordinary.
	var screen_core := 0
	var screen_n := 0
	for _v in 8:
		_new_run()
		_run.gold = 1000
		change_scene_to_file("res://scenes/shop.tscn")
		await Gate.frames(self, 5)
		for o in current_scene.get("offers"):
			screen_n += 1
			if String(((o as Dictionary)["rune"] as Dictionary).get("engine", "")) != "":
				screen_core += 1
	ok(screen_n >= 24 and screen_core == 0, "§1b: the Peddler's screen showed %d core runes in %d offers" % [screen_core, screen_n])
	# WHEN CORE RUNES ARE ALL THAT IS LEFT, THE COUNTER SAYS SO — and it is not the
	# sentence that says he carries everything, which would be false.
	_new_run()
	var w: Dictionary = _run.party[0]
	var ordinary: Array = Runes.eligible_ids(w, Runes.owned_names(w, _run.party_rune_names())).filter(
		func(x): return not Runes.is_engine_rune(String(x)))
	for id in ordinary:
		_run.bag_rune(Runes.build(String(id)))
	ok(_counter_roll(w).is_empty() and not _run.generate_rune(w).is_empty(),
		"§1b: with every ordinary rune held the counter still offered one, or the cache had nothing")
	ok(_run.has_method("peddler_withholds_only_core") and bool(_run.call("peddler_withholds_only_core", w)),
		"§1b: the counter cannot tell that core runes are all that is left")
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 5)
	ok(Gate.has_text(current_scene, "core runes, which are found in play and never sold"),
		"§1b: the counter did not say why it has nothing for the Warrior")
	ok(not Gate.has_text(current_scene, "they already carry every rune written for that class"),
		"§1b: the counter said the Warrior carries every rune while core runes are left")


# ── §1c — A RUNE BOUGHT LANDS ───────────────────────────────────────────────

func _s1c_the_purchase() -> void:
	print("\n§1c — a rune bought through the Buy button lands, and the map shows it")
	_new_run()
	_run.gold = 1000
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 6)
	var shop: Node = current_scene
	var offers: Array = shop.get("offers")
	ok(not offers.is_empty(), "§1c: the Peddler has nothing on the counter")
	if offers.is_empty():
		return
	var o0: Dictionary = offers[0]
	var for_idx := int(o0["member_idx"])
	var nm := String((o0["rune"] as Dictionary)["name"])
	ok(Gate.has_text(shop, "into the bag; equip it on the map"),
		"§1c: the counter does not say where a bought rune goes")
	var bought := Gate.press(shop, ["Buy — "])
	await Gate.frames(self, 2)
	ok(bought != "" and _run.gold == 1000 - int(_run.rune_price(o0["rune"])),
		"§1c: the Buy took %dg" % (1000 - int(_run.gold)))
	ok(_names(_run.rune_bag).has(nm), "§1c: the rune bought is not in the bag — gold spent, nothing received")
	var mp := await _to_map()
	ok(Gate.has_text(mp, "Rune bag  %d/%d" % [_run.rune_bag.size(), int(_run.BAG_CAP)]),
		"§1c: the map's bag row does not count the rune bought")
	mp.call("_open_rune_panel", for_idx)
	await process_frame
	var ov: Node = Gate.overlay(current_scene, 60)
	var m: Dictionary = _run.party[for_idx]
	var rows: Array = _run.rune_rows(m)
	var row := -1
	for ri in rows.size():
		if String(rows[ri]["src"]) == "bag" and String((rows[ri]["rune"] as Dictionary).get("name", "")) == nm:
			row = ri
	var eq: Button = Gate.bound_button(ov, "_toggle_rune", [for_idx, row, ov]) if ov != null else null
	ok(eq != null and String(eq.text) == "Equip", "§1c: the hero's panel drew no Equip for the rune bought")
	if eq != null:
		eq.emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(_names(m.get("runes", [])).has(nm) and not _names(_run.rune_bag).has(nm),
		"§1c: Equip did not put the rune bought on the hero")


# ── §1d — THE STANCES CAN BE CHANGED ────────────────────────────────────────

func _s1d_the_stances() -> void:
	print("\n§1d — the Stances bring Guard Change, and it changes the stance")
	_new_run({"warrior": "seasoned"})
	var w: Dictionary = _run.party[0]
	ok(_run.opening_kit_names(w).has("Guard Change"),
		"§1d: a Warrior holding the Stances opens without Guard Change: %s" % [_run.opening_kit_names(w)])
	ok(Classes.engine_enablers("seasoned") == ["Guard Change"],
		"§1d: the Stances' enablers read %s" % [Classes.engine_enablers("seasoned")])
	var in_pool := Classes.draft_pool("warrior").has("Guard Change")
	for sp in Classes.SPEC_IDS["warrior"]:
		in_pool = in_pool or Classes.spec_pool(String(sp)).has("Guard Change")
	ok(not in_pool, "§1d: Guard Change travels and is still in a pool — an enabler sits in none")
	# The other way: a Warrior without the engine does not hold it.
	var w2: Dictionary = w.duplicate(true)
	w2["engines"] = []
	ok(not _run.opening_kit_names(w2).has("Guard Change"),
		"§1d: a Warrior with the Stances unslotted still opens with Guard Change")
	# In a fight: the swap is on his bar, needs no target, and flips the stance.
	var sc: Node = await Gate.spawn(self, ["swordmaster", "pyromancer", "holy", "beastmaster"])
	var sm: BattleUnit = sc.get("heroes")[0]
	var gc: Ability = null
	for ab in sm.abilities:
		if ab.display_name == "Guard Change":
			gc = ab
	ok(gc != null, "§1d: the Swordmaster's bar holds no Guard Change: %s" % [_names(sm.abilities)])
	var res := await _drive_casts(sc, {sm: ["Guard Change"]})
	var st0 := String(res.get("stance_before", ""))
	var r: Dictionary = res.get("Guard Change", {})
	ok(bool(r.get("resolved", false)) and not bool(r.get("prompted", true)),
		"§1d: Guard Change did not resolve on the Swordmaster's turn (%s)" % [r])
	ok(st0 == "aggressive" and String(r.get("stance_after", "")) == "defensive",
		"§1d: the stance read %s before and %s after the swap" % [st0, r.get("stance_after", "")])
	sc.queue_free()
	await process_frame


# ── §1e — A CARD THAT READS NO TARGET ASKS FOR NONE ─────────────────────────

# `battle.gd`'s special arms, as {special: reads target}, off the source with its
# comments stripped and its strings masked, so a log line saying "target" is not
# a read. And the list the hero's turn takes as needing no target.
func _special_reads() -> Dictionary:
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var lines := src.split("\n")
	var start := -1
	for i in lines.size():
		if lines[i].begins_with("func _resolve_special("):
			start = i
			break
	var out := {}
	if start < 0:
		return out
	var end := start + 1
	while end < lines.size() and not lines[end].begins_with("func "):
		end += 1
	var arm_re := RegEx.create_from_string("^\\t\\t((?:\"[a-z_]+\"(?:,\\s*)?)+):\\s*$")
	var name_re := RegEx.create_from_string("\"([a-z_]+)\"")
	var read_re := RegEx.create_from_string("(?<![A-Za-z0-9_.])target(?![A-Za-z0-9_])")
	var arms: Array = []
	for i in range(start + 1, end):
		var m := arm_re.search(lines[i])
		if m != null:
			var names: Array = []
			for nm in name_re.search_all(m.get_string(1)):
				names.append(nm.get_string(1))
			arms.append([i, names])
	for k in arms.size():
		var a0: int = arms[k][0]
		var a1: int = arms[k + 1][0] if k + 1 < arms.size() else end
		var body := ""
		for j in range(a0 + 1, a1):
			body += _mask_strings(lines[j]) + "\n"
		var reads := read_re.search(body) != null
		for nm in arms[k][1]:
			out[String(nm)] = reads
	return out


func _mask_strings(line: String) -> String:
	var out := ""
	var q := ""
	var i := 0
	while i < line.length():
		var c := line[i]
		if q != "":
			if c == "\\":
				out += "  "
				i += 2
				continue
			if c == q:
				q = ""
				out += c
			else:
				out += " "
		elif c == "\"" or c == "'":
			q = c
			out += c
		else:
			out += c
		i += 1
	return out


func _no_target_list() -> Array:
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var at := src.find("func _player_turn(")
	var open := src.find("elif ab.special in [", at)
	var close := src.find("]:", open)
	var out: Array = []
	if at < 0 or open < 0 or close < 0:
		return out
	var tail := src.substr(close, 60)
	if not tail.contains("target = u"):
		return out
	for m in RegEx.create_from_string("\"([a-z_]+)\"").search_all(src.substr(open, close - open)):
		out.append(m.get_string(1))
	return out


# Drive a live fight: on each hero's parked turn, cast the next card named for
# him in `plan` (full resource, cooldowns clear), and answer every other turn
# with his basic on the first enemy. For each card: did a target picker open,
# and did the cast resolve (its own log line). The stance is read for §1d.
func _drive_casts(sc: Node, plan: Dictionary) -> Dictionary:
	var out := {}
	var todo := {}
	for u in plan:
		todo[u] = (plan[u] as Array).duplicate()
	var casting := ""
	var caster: BattleUnit = null
	var log_at := 0
	var hist: RichTextLabel = sc.get("history")
	var frames := 0
	for u in plan:
		out["stance_before"] = String((u as BattleUnit).stance)
	# Nothing may end the fight before every card has come round: the enemies are
	# made too deep for the basics that answer the other turns (their attacks are
	# off already — the fixture's switch).
	for e in sc.get("enemies"):
		(e as BattleUnit).max_hp = 1000000
		(e as BattleUnit).hp = 1000000
	while frames < FRAME_CAP:
		Engine.time_scale = 50.0
		await process_frame
		frames += 1
		if bool(sc.get("battle_over")):
			break
		var left := 0
		for u in todo:
			left += (todo[u] as Array).size()
		# A graded cast opens the bar, and the bar sweeps until it is pressed —
		# a basic resolves at a fixed Good and never opens it. Pressed here, as a
		# player presses it.
		if bool(sc.get("sc_active")):
			sc.call("_grade_skill_check")
			continue
		var kb: Array = sc.get("_kb_pool")
		if not kb.is_empty():
			if casting != "":
				out[casting] = {"prompted": true, "resolved": false}
				casting = ""
				sc.emit_signal("_target_picked", null)
			else:
				sc.emit_signal("_target_picked", kb[0])
			continue
		var panel: Control = sc.get("action_panel")
		var p: BattleUnit = sc.get("current_hero")
		if p == null or panel == null or not panel.visible:
			continue
		if casting != "":
			var fresh := hist.get_parsed_text().substr(log_at)
			out[casting] = {"prompted": false,
				"resolved": fresh.contains("%s: %s" % [caster.unit_name, casting]),
				"stance_after": String(caster.stance)}
			casting = ""
		if left == 0:
			break
		var want: Array = todo.get(p, [])
		if not want.is_empty():
			var card := String(want.pop_front())
			var ab: Ability = null
			for a in p.abilities:
				if a.display_name == card:
					ab = a
			if ab == null:
				out[card] = {"prompted": false, "resolved": false, "missing": true}
				continue
			p.cooldowns.clear()
			p.resource = p.max_resource
			# A card the door refuses is not cast — its button is dark, and a pick
			# emitted past the door parks the turn for good. Recorded, so the
			# caller can say the drive could not reach the card.
			if not bool(sc.call("_ability_usable", p, ab)):
				out[card] = {"prompted": false, "resolved": false, "unusable": true}
				sc.emit_signal("_ability_picked", p.abilities[0])
				continue
			casting = card
			caster = p
			log_at = hist.get_parsed_text().length()
			sc.emit_signal("_ability_picked", ab)
		else:
			sc.emit_signal("_ability_picked", p.abilities[0])
	Engine.time_scale = 1.0
	return out


func _s1e_no_target() -> void:
	print("\n§1e — a card that reads no target asks for none")
	# (i) THE POPULATION, DERIVED: every card whose special arm reads no target and
	# which deals no damage, lays no Break damage, and is neither an area attack nor
	# a scatter — the shape Preparation had — is on the hero turn's no-target list.
	var reads := _special_reads()
	var listed := _no_target_list()
	ok(reads.size() > 100 and listed.size() > 80,
		"§1e: read %d special arms and a no-target list of %d — the source did not parse" % [reads.size(), listed.size()])
	var shape: Array = []
	var unlisted: Array = []
	for ab in Classes.ability_corpus():
		var sp := String(ab.special)
		if sp == "" or not reads.has(sp) or bool(reads[sp]):
			continue
		if ab.damage > 0 or ab.pressure > 0 or ab.aoe or ab.random_hits > 0 \
				or ab.target != Ability.Target.ENEMY or sp == "summon":
			continue
		if not shape.has(ab.display_name):
			shape.append(ab.display_name)
		if not listed.has(sp):
			unlisted.append(ab.display_name)
	print("    CHECKED %d cards of the shape: %s" % [shape.size(), shape])
	ok(shape.size() >= SELF_CASTS.size(), "§1e: the shape holds %d cards — the derivation walked nothing" % shape.size())
	ok(unlisted.is_empty(), "§1e: a card that reads no target still asks for one: %s" % [unlisted])
	for nm in SELF_CASTS:
		ok(shape.has(nm), "§1e: %s is not of the shape the derivation finds" % nm)
	# The positive arm: a card whose arm DOES read its target is not required on
	# the list, and is not on it — Reprisal names one enemy.
	var rep_sp := ""
	for ab in Classes.ability_corpus():
		if ab.display_name == "Reprisal":
			rep_sp = String(ab.special)
	ok(rep_sp != "" and bool(reads.get(rep_sp, false)) and not listed.has(rep_sp),
		"§1e: Reprisal's arm reads no target, or it is on the list — the read is blind")
	# (ii) IN A FIGHT, THROUGH THE PLAYER'S OWN TURN: no picker, and the card
	# resolves. Three fights, one per Hunter lineage the cards need.
	var groups := {"beastmaster": [], "sharpshooter": [], "mystic": []}
	for nm2 in SELF_CASTS:
		var sp2 := String(SELF_CASTS[nm2])
		if groups.has(sp2):
			(groups[sp2] as Array).append(nm2)
	for hsp in groups:
		var cards: Array = groups[hsp]
		var cleric_cards: Array = []
		if hsp == "mystic":
			cleric_cards = ["Sanctuary"]
		var sc: Node = await Gate.spawn(self, ["berserker", "pyromancer", "holy", hsp],
			{"party": {3: {"bm_abilities": cards, "bm_equipped": cards},
				2: {"bm_abilities": cleric_cards, "bm_equipped": cleric_cards}}})
		var heroes: Array = sc.get("heroes")
		# The companion cards are cast where a player casts them: with one standing.
		if hsp == "beastmaster":
			await sc._do_summon(heroes[3], "ursus")
		var plan := {heroes[3]: cards.duplicate()}
		if not cleric_cards.is_empty():
			plan[heroes[2]] = cleric_cards.duplicate()
		var res := await _drive_casts(sc, plan)
		for nm3 in cards + cleric_cards:
			var r: Dictionary = res.get(nm3, {})
			ok(not bool(r.get("missing", false)) and not r.is_empty(),
				"§1e: %s never came round to be cast (%s)" % [nm3, r])
			ok(not bool(r.get("unusable", false)), "§1e: %s was refused at its door — the drive reached nothing" % nm3)
			ok(not bool(r.get("prompted", true)), "§1e: %s asked for a target" % nm3)
			ok(bool(r.get("resolved", false)), "§1e: %s did not resolve on its hero's turn" % nm3)
		if hsp == "mystic":
			ok(int(heroes[3].prep_pending) > 0 or bool(res.get("Preparation", {}).get("resolved", false)),
				"§1e: Preparation readied nothing")
		sc.queue_free()
		await process_frame


# ── §2 — THE CORE RUNES ─────────────────────────────────────────────────────

# String literals in the game's scripts, comments stripped: what a sweep of the
# player-facing words reads.
func _script_literals() -> Array:
	var out: Array = []
	var lit_re := RegEx.create_from_string("\"((?:[^\"\\\\]|\\\\.)*)\"")
	var dir := DirAccess.open("res://scripts")
	for f in dir.get_files():
		if not String(f).ends_with(".gd"):
			continue
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		for m in lit_re.search_all(src):
			out.append([String(f), m.get_string(1)])
	return out


func _s2_core_runes() -> void:
	print("\n§2 — the core runes: (core) on every name, no Engine: prefix, and the notes under 44")
	# (a) EVERY ENGINE RUNE IS NAMED "(core)", AND NO OTHER RUNE IS.
	var engines := 0
	var cored := 0
	var stray: Array = []
	for id in Runes.ids():
		var nm := Runes.display_name(Runes.config(String(id)))
		if Runes.is_engine_rune(String(id)):
			engines += 1
			if nm.ends_with(" (core)"):
				cored += 1
		elif nm.contains("(core)"):
			stray.append(nm)
	print("    CHECKED %d core runes" % engines)
	ok(engines == 24 and cored == engines, "§2a: %d of %d engine runes are named (core)" % [cored, engines])
	ok(stray.is_empty(), "§2a: an ordinary rune wears (core): %s" % [stray])
	# (b) THE RULE TEXT SHOWS WITH NO "Engine:" PREFIX — and it IS the rule, the
	# positive arm that the door still reads the engine.
	var prefixed: Array = []
	var wrong: Array = []
	for id2 in Runes.ids():
		if not Runes.is_engine_rune(String(id2)):
			continue
		var shown := Runes.shown_desc(Runes.build(String(id2)))
		if shown.begins_with("Engine"):
			prefixed.append(id2)
		if shown != Runes.engine_text(String(Runes.config(String(id2))["engine"])):
			wrong.append(id2)
	ok(prefixed.is_empty() and wrong.is_empty(),
		"§2b: rule text prefixed %s, or not the engine's rule %s" % [prefixed, wrong])
	# The class-selection card and the hero sheet, through their own screens.
	_new_run()
	_run.specs_chosen = false
	for m in _run.party:
		m["awakened"] = false
		m["spec"] = ""
		m["engines"] = []
	change_scene_to_file("res://scenes/spec_choice.tscn")
	await Gate.frames(self, 6)
	var sc_texts: Array = Gate.texts(current_scene)
	var card_prefixed := sc_texts.filter(func(t): return String(t).contains("Engine:"))
	var card_names := sc_texts.filter(func(t): return String(t).ends_with(" (core)"))
	ok(card_prefixed.is_empty(), "§2b: the class-selection card still reads \"Engine:\" (%s)" % [card_prefixed.slice(0, 2)])
	ok(card_names.size() == 3, "§2b: the class-selection screen names %d core runes, not the three dealt" % card_names.size())
	ok(Gate.has_text(current_scene, "Take one of three core runes"),
		"§2b: the class-selection screen does not call them core runes")
	_new_run()
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	ok(not Gate.has_text(current_scene, "Engine:") and Gate.has_text(current_scene, "Blood Frenzy:"),
		"§2b: the hero sheet still prefixes the rule, or does not show it")
	# (c) NO PLAYER-FACING STRING CALLS IT AN ENGINE RUNE. The positive arm: the
	# same sweep finds the new word.
	var lits := _script_literals()
	var old_words: Array = []
	var core_words := 0
	for pair in lits:
		var t := String(pair[1])
		for needle in ["engine rune", "Engine rune", "engine slot", "Engine:", "ENGINES"]:
			if t.contains(needle):
				old_words.append("%s: %s" % [pair[0], t.substr(0, 60)])
		if t.contains("core rune") or t.contains("CORE RUNE") or t.contains("core slot"):
			core_words += 1
	print("    CHECKED %d string literals; %d say core rune" % [lits.size(), core_words])
	ok(lits.size() > 5000, "§2c: the literal sweep read %d — not the scripts" % lits.size())
	ok(old_words.is_empty(), "§2c: a player-facing string still says engine: %s" % [old_words.slice(0, 5)])
	ok(core_words >= 8, "§2c: only %d literals say core rune — the rename is not where it was put" % core_words)
	# (d) THE NOTES: every hand-broken line under 44 with every core rune's name in
	# it, and the log quotes the first sentence whole.
	var lines_n := 0
	var over: Array = []
	var named := 0
	var gated := 0
	for id3 in Runes.ids():
		if Runes.is_retired(String(id3)):
			continue
		for engs in [[], ["lethal_aim"], ["lethal_aim", "pack"]]:
			var note: String = _run.rune_sits_out_note(String(id3), engs, [])
			for l in note.split("\n"):
				lines_n += 1
				if String(l).length() > 44:
					over.append("%s: \"%s\" (%d)" % [id3, l, String(l).length()])
		var eng := Runes.engine_read(String(id3))
		if eng != "":
			gated += 1
			var first: String = _run.note_first_sentence(_run.rune_sits_out_note(String(id3), [], []))
			var rn := Runes.display_name(Runes.config(Runes.engine_rune_id(eng)))
			if first.contains(rn) and first.ends_with("is not equipped."):
				named += 1
	for card in Classes.SITS_OUT:
		for engs2 in [[], ["lethal_aim"], ["lethal_aim", "pack"]]:
			for l2 in String(_run.sits_out_note(String(card), engs2)).split("\n"):
				lines_n += 1
				if String(l2).length() > 44:
					over.append("%s: \"%s\" (%d)" % [card, l2, String(l2).length()])
	print("    CHECKED %d note lines; %d gated runes' first sentences" % [lines_n, gated])
	ok(lines_n > 500 and over.is_empty(), "§2d: note lines over 44: %s" % [over.slice(0, 4)])
	ok(gated > 20 and named == gated,
		"§2d: %d of %d gated runes' first sentence names its core rune and ends 'is not equipped.'" % [named, gated])
	# (e) A SAVE HOLDING THE OLD NAME LOADS WITH TODAY'S — and an entry the data
	# does not hold keeps its own.
	_new_run()
	var mage: Dictionary = _run.party[1]
	var old_rune: Dictionary = (mage["engines"] as Array)[0]
	var today := String(old_rune["name"])
	old_rune["name"] = today.replace(" (core)", "")
	var tpl := {"id": "tpl:Might", "name": "Rune of Might", "payload": {"stat": {"attack": 1}}}
	_run.rune_bag = [tpl]
	_run.save_run()
	_run.load_run()
	var got := String(((_run.party[1] as Dictionary)["engines"] as Array)[0]["name"])
	ok(old_rune["name"] != today and got == today,
		"§2e: a saved core rune named '%s' loaded as '%s', not today's '%s'" % [old_rune["name"], got, today])
	ok(String((_run.rune_bag[0] as Dictionary)["name"]) == "Rune of Might",
		"§2e: a rune the data does not hold was renamed")


# ── §3 — THE FOUR MAGNITUDES ────────────────────────────────────────────────

func _foe(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			return e
	return null


# One seeded blow of `atk`'s basic on `victim`, returning the damage dealt; the
# victim is made deep and whole around it.
func _blow(s: Node, atk: BattleUnit, victim: BattleUnit, sd: int) -> int:
	victim.max_hp = 100000
	victim.hp = 100000
	victim.pressure = 0
	victim.broken = false
	atk.cooldowns.clear()
	seed(sd)
	var before := victim.hp
	await s._resolve(atk, atk.abilities[0], victim, "good")
	var dealt := before - victim.hp
	victim.hp = victim.max_hp
	return dealt


func _s3_magnitudes() -> void:
	print("\n§3 — the Bastion's bank, Aggressive's +30%, Mercy's 5% a stack, Faith at eight")
	# (a) THE BASTION BANKS WHAT IS BLOCKED, PARRIED OR ABSORBED — and armor none.
	var bastion := Runes.build(Runes.engine_rune_id("redoubt"))
	bastion["equipped"] = true
	var s: Node = await Gate.spawn(self, ["", "pyromancer", "holy", "beastmaster"],
		{"deterministic": true, "party": {0: {"engines": [bastion]}}})
	var w: BattleUnit = s.get("heroes")[0]
	var foe := _foe(s)
	foe.attack = 400
	ok(w.has_engine("redoubt") and w.effective_armor() > 0.0,
		"§3a: the Warrior does not hold the Bastion, or wears no armor to cut with")
	w.redoubt_bank = 0.0
	var took := await _blow(s, foe, w, HL_SEED + 1)
	ok(took > 0 and w.redoubt_bank == 0.0,
		"§3a: armor cut a blow of %d and the bank read %.1f — armor still banks" % [took, w.redoubt_bank])
	w.block_chance = 10.0
	await _blow(s, foe, w, HL_SEED + 2)
	var blocked_bank := w.redoubt_bank
	w.block_chance = -10.0
	ok(blocked_bank > 0.0, "§3a: a blocked blow banked nothing")
	w.redoubt_bank = 0.0
	w.parry_chance = 1.0
	await _blow(s, foe, w, HL_SEED + 3)
	var parried_bank := w.redoubt_bank
	w.parry_chance = 0.0
	ok(parried_bank > 0.0, "§3a: a parried blow banked nothing")
	w.redoubt_bank = 0.0
	s._apply_status(w, "barrier", 3, 5000)
	await _blow(s, foe, w, HL_SEED + 4)
	ok(w.redoubt_bank > 0.0, "§3a: a barrier's absorb banked nothing")
	if w.has_status("barrier"):
		w.remove_status("barrier")
	print("    blocked %.1f · parried %.1f banked; armor alone 0" % [blocked_bank, parried_bank])
	# The rule text says so.
	var bt := Classes.engine_desc("redoubt")
	ok(bt.contains("blocks") and bt.contains("Armor and other") and not bt.contains("cut by armor"),
		"§3a: the Bastion's rule text still banks armor")
	s.queue_free()
	await process_frame
	# (b) AGGRESSIVE DEALS +30%: the Swordmaster's blow against the same blow with
	# the engine out, seeded alike.
	ok(is_equal_approx(BattleUnit.SEASONED_AGG_DEALT, 0.30), "§3b: the Aggressive upside reads %s" % BattleUnit.SEASONED_AGG_DEALT)
	var formless: float = float(load("res://scripts/battle.gd").get_script_constant_map()["FORMLESS_DEALT"])
	ok(is_equal_approx(formless, 1.0 + BattleUnit.SEASONED_AGG_DEALT),
		"§3b: Formless's dealt term %s is not both stances' upsides" % formless)
	var s2: Node = await Gate.spawn(self, ["swordmaster", "pyromancer", "holy", "beastmaster"], {"deterministic": true})
	var sm: BattleUnit = s2.get("heroes")[0]
	sm.attack = 1000
	var foe2 := _foe(s2)
	foe2.armor = 0.0
	var with_eng := await _blow(s2, sm, foe2, HL_SEED + 5)
	var engs_was: Array = sm.engines.duplicate()
	sm.engines = []
	var without := await _blow(s2, sm, foe2, HL_SEED + 5)
	sm.engines = engs_was
	var ratio := float(with_eng) / maxf(float(without), 1.0)
	print("    Aggressive %d against %d without the engine: x%.3f" % [with_eng, without, ratio])
	ok(sm.stance == "aggressive" and ratio > 1.28 and ratio < 1.32,
		"§3b: Aggressive dealt x%.3f, not x1.30" % ratio)
	# Defensive's cut stays 15%: the same blow taken with the engine and without.
	sm.stance = "defensive"
	foe2.attack = 400
	var took_def := await _blow(s2, foe2, sm, HL_SEED + 6)
	sm.engines = []
	var took_bare := await _blow(s2, foe2, sm, HL_SEED + 6)
	sm.engines = engs_was
	var dratio := float(took_def) / maxf(float(took_bare), 1.0)
	ok(dratio > 0.83 and dratio < 0.87, "§3b: Defensive took x%.3f, not the x0.85 it was" % dratio)
	s2.queue_free()
	await process_frame
	# (c) EACH MERCY STACK TAKES 5% OFF, TO THE FIVE THE BAR HOLDS.
	var s3: Node = await Gate.spawn(self, ["berserker", "pyromancer", "holy", "beastmaster"], {"deterministic": true})
	var holy: BattleUnit = s3.get("heroes")[2]
	var foe3 := _foe(s3)
	foe3.attack = 400
	ok(holy.has_engine("mercy") and holy.second_resource_name == "Mercy" and holy.second_max == 5,
		"§3c: the Holy's Mercy bar is not the five-stack bar (%s, %d)" % [holy.second_resource_name, holy.second_max])
	holy.second_resource = 0
	var t0 := await _blow(s3, foe3, holy, HL_SEED + 7)
	holy.second_resource = 3
	var t3 := await _blow(s3, foe3, holy, HL_SEED + 7)
	holy.second_resource = 5
	var t5 := await _blow(s3, foe3, holy, HL_SEED + 7)
	var r3 := float(t3) / maxf(float(t0), 1.0)
	var r5 := float(t5) / maxf(float(t0), 1.0)
	print("    Mercy 0 / 3 / 5 took %d / %d / %d (x%.3f, x%.3f)" % [t0, t3, t5, r3, r5])
	ok(r3 > 0.83 and r3 < 0.87 and r5 > 0.73 and r5 < 0.77,
		"§3c: three stacks took x%.3f and five x%.3f — not 5%% a stack" % [r3, r5])
	var hengs: Array = holy.engines.duplicate()
	holy.engines = []
	var t_bare := await _blow(s3, foe3, holy, HL_SEED + 7)
	holy.engines = hengs
	ok(absf(float(t_bare) - float(t0)) <= 1.0, "§3c: five stacks with the engine out still cut the blow (%d against %d)" % [t_bare, t0])
	s3.queue_free()
	await process_frame
	# (d) FAITH RELEASES AT EIGHT: an ally at two a hit releases on the fourth, and
	# the Devout's own count holds at eight.
	var bs: Dictionary = load("res://scripts/battle.gd").get_script_constant_map()
	ok(int(bs["FAITH_RELEASE"]) == 8 and int(bs["FAITH_PER_ABSORB"]) < int(bs["FAITH_RELEASE"]),
		"§3d: Faith releases at %d, or an absorb meets it" % int(bs["FAITH_RELEASE"]))
	var s4: Node = await Gate.spawn(self, ["berserker", "pyromancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var dv: BattleUnit = s4.get("heroes")[2]
	var ally: BattleUnit = s4.get("heroes")[0]
	var counts: Array = []
	for _k in 4:
		s4._gain_faith(ally, 2, "absorb")
		counts.append(ally.faith_stacks)
	for _k2 in 6:
		s4._gain_faith(dv, 2, "absorb")
	print("    an ally's count over four absorbs: %s; the Devout's own after six: %d" % [counts, dv.faith_stacks])
	ok(counts == [2, 4, 6, 0] and ally.faith_peak == 8,
		"§3d: an ally's Faith read %s (peak %d) — not a release on the fourth absorb at eight" % [counts, ally.faith_peak])
	ok(dv.faith_stacks == 8, "§3d: the Devout's own count holds at %d, not eight" % dv.faith_stacks)
	s4.queue_free()
	await process_frame


# ── §5 — THE CEILING ────────────────────────────────────────────────────────

func _bytes(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()


func _s5_the_ceiling() -> void:
	print("\n§5 — a save from a newer build is refused, kept and never written")
	var path := String(_run.save_path)
	var had := _bytes(path)
	var had_file := FileAccess.file_exists(path)
	ok(int(_run.SAVE_VERSION) == 14 and int(_run.MIN_SAVE_VERSION) == 10,
		"§5: this build writes v%d and reads from v%d" % [int(_run.SAVE_VERSION), int(_run.MIN_SAVE_VERSION)])
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(src.contains("\"version\": SAVE_VERSION") and src.contains("if save_version < 10:"),
		"§5: the save does not write SAVE_VERSION, or the floor at ten moved")
	# (a) A v15-SHAPED SAVE: this build's own save, stamped a version on and given a
	# key this build does not know.
	_new_run()
	_run.save_run()
	var f := FileAccess.open(path, FileAccess.READ)
	var d: Dictionary = f.get_var(true)
	f.close()
	d["version"] = 15
	d["hl_a_key_from_the_future"] = [1, 2, 3]
	var fw := FileAccess.open(path, FileAccess.WRITE)
	fw.store_var(d, true)
	fw.close()
	var v15 := _bytes(path)
	ok(not _run.load_run() and bool(_run.save_refused) and int(_run.save_refused_version) == 15,
		"§5a: this build loaded a v15 save, or did not say it refused it")
	ok(_bytes(path) == v15, "§5a: refusing the v15 save changed the file")
	_run.active = true
	_run.save_run()
	ok(_bytes(path) == v15, "§5a: save_run wrote over the v15 save")
	_run.clear_save()
	ok(FileAccess.file_exists(path) and _bytes(path) == v15, "§5a: clear_save deleted the v15 save")
	_run.new_run(SEATS, [], "standard")
	ok(FileAccess.file_exists(path) and _bytes(path) == v15, "§5a: a New Game deleted the v15 save")
	# The main menu: Continue dark, and the banner says what and why.
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 6)
	var cont: Button = null
	var mb: Array = []
	Gate.buttons(current_scene, mb, false)
	for b in mb:
		if String((b as Button).text) == "Continue":
			cont = b
	ok(cont != null and cont.disabled, "§5a: the main menu's Continue is live over a refused save")
	ok(Gate.has_text(current_scene, "NEWER build than this one (version 15)")
			and Gate.has_text(current_scene, "NOTHING HAS BEEN CHANGED OR DELETED"),
		"§5a: the main menu does not say the save was refused and kept")
	ok(_bytes(path) == v15, "§5a: the file is not byte-identical after all of it")
	# (b) THE POSITIVE ARM: a v14 save loads, saves and clears.
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	_new_run()
	_run.save_run()
	ok(_run.load_run() and not bool(_run.save_refused), "§5b: a v14 save was refused")
	_run.gold += 7
	var before14 := _bytes(path)
	_run.save_run()
	ok(_bytes(path) != before14, "§5b: a v14 save was not written over")
	_run.clear_save()
	ok(not FileAccess.file_exists(path), "§5b: a v14 save was not cleared")
	# (c) THE FLOOR DID NOT MOVE: a v9 save is refused AND cleared.
	_new_run()
	_run.save_run()
	var f9 := FileAccess.open(path, FileAccess.READ)
	var d9: Dictionary = f9.get_var(true)
	f9.close()
	d9["version"] = 9
	var fw9 := FileAccess.open(path, FileAccess.WRITE)
	fw9.store_var(d9, true)
	fw9.close()
	ok(not _run.load_run() and not FileAccess.file_exists(path) and not bool(_run.save_refused),
		"§5c: a v9 save was not refused and cleared, or it read as a newer build's")
	# Put the harness file back as this gate found it.
	if had_file:
		var fr := FileAccess.open(path, FileAccess.WRITE)
		fr.store_buffer(had)
		fr.close()
	elif FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	ok(_bytes(path) == had and FileAccess.file_exists(path) == had_file, "§5: the harness save was not put back")


# ── §6 — A CONDITION ON WHO IS IN THE PARTY ─────────────────────────────────

# A party of `keys`, each awakened on the engine named for his seat, the fixture
# crest rune worn with `cond`, and hero `fallen` at 0 health — entered through the
# fixture's door for the run in hand. Returns {max_hp: [...], roll: [...]}.
func _crest_spawn(keys: Array, engines: Array, cond: Dictionary, fallen := -1, with_crest := true) -> Dictionary:
	var table: Dictionary = Runes._load()
	table[CREST_FX] = {"name": "HL Fixture Crest", "scope": "party", "price": 150,
		"desc": "A fixture of check_hl, never in the file.",
		"payload": {"stat": {"max_hp": CREST_HP}, "condition": cond}}
	_run.sim_run = false
	_run.new_run(keys, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	if with_crest:
		var r := Runes.build(CREST_FX)
		r["equipped"] = true
		_run.party_runes = [r]
	if fallen >= 0:
		_run.party[fallen]["hp"] = 0
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]})
	await Gate.frames(self, 8)
	var s: Node = current_scene
	var hp: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			hp.append(int((u as BattleUnit).max_hp))
	var roll: Array = (s.get("_rune_roll_call") as Array).duplicate()
	return {"max_hp": hp, "roll": roll}


# Did the crest's payload land on every hero, against the same party without it.
func _crest_paid(keys: Array, engines: Array, cond: Dictionary, fallen := -1) -> Dictionary:
	var with_c := await _crest_spawn(keys, engines, cond, fallen, true)
	var without := await _crest_spawn(keys, engines, cond, fallen, false)
	var paid := 0
	var hp_w: Array = with_c["max_hp"]
	var hp_o: Array = without["max_hp"]
	for i in mini(hp_w.size(), hp_o.size()):
		if int(hp_w[i]) - int(hp_o[i]) == CREST_HP:
			paid += 1
	var told := false
	for line in with_c["roll"]:
		if String(line).begins_with("the crest: HL Fixture Crest") \
				and String(line).contains("its condition does not hold"):
			told = true
	return {"paid": paid, "heroes": hp_w.size(), "told": told}


# A hero rune with a condition, worn by the Mage (index 1), against the same party
# without it: paid on him alone when it holds, on nobody and TOLD when it does not.
func _hero_rune_paid(keys: Array, engines: Array, cond: Dictionary) -> Dictionary:
	var table: Dictionary = Runes._load()
	table[HERO_FX] = {"name": "HL Fixture Rune", "scope": "class:mage", "price": 150,
		"desc": "A fixture of check_hl, never in the file.",
		"payload": {"stat": {"max_hp": HERO_FX_HP}, "condition": cond}}
	var hp_arms: Array = []
	var roll: Array = []
	for with_rune in [true, false]:
		_run.sim_run = false
		_run.new_run(keys, [], "standard")
		for i in _run.party.size():
			_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
		_run.specs_chosen = true
		_run.active = true
		_run.rune_bag = []
		_run.pending_rune_drops = []
		_run.party_runes = []
		if with_rune:
			var r := Runes.build(HERO_FX)
			r["equipped"] = true
			_run.party[1]["runes"] = [r]
		OS.set_environment("DOD_AUTOPLAY", "")
		OS.set_environment("DOD_ENEMIES_OFF", "1")
		Gate.enter_battle(self, {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]})
		await Gate.frames(self, 8)
		var s: Node = current_scene
		var hp: Array = []
		for u in s.get("heroes"):
			if not (u as BattleUnit).is_companion:
				hp.append(int((u as BattleUnit).max_hp))
		hp_arms.append(hp)
		if with_rune:
			roll = (s.get("_rune_roll_call") as Array).duplicate()
	var w: Array = hp_arms[0]
	var o: Array = hp_arms[1]
	var on_him := w.size() > 1 and o.size() > 1 and int(w[1]) - int(o[1]) == HERO_FX_HP
	var others := 0
	for i in mini(w.size(), o.size()):
		if i != 1 and int(w[i]) != int(o[i]):
			others += 1
	var named := false
	var told := false
	for line in roll:
		if String(line).contains("HL Fixture Rune"):
			named = true
			if String(line).contains("its condition does not hold"):
				told = true
	return {"on_him": on_him, "others": others, "named": named, "told": told}


func _s6_party_condition() -> void:
	print("\n§6 — a condition on who is in the party, each key both ways")
	var authored := 0
	var file_data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	for id in (file_data as Dictionary):
		if String(((file_data as Dictionary)[id] as Dictionary).get("scope", "")) == "party":
			authored += 1
	ok(authored == 0, "§6: %d party runes are authored — the ruling is none" % authored)
	var four := ["warrior", "mage", "cleric", "hunter"]
	var eng4 := ["bloodrage", "overburn", "mercy", "pack"]
	var cases := [
		# [label, cond, keys that satisfy, engines, fallen, keys that do not, engines, fallen]
		["a class is present", {"heroes_include_class": "cleric"},
			four, eng4, -1, ["warrior", "mage", "hunter", "hunter"], ["bloodrage", "overburn", "pack", "lethal_aim"], -1],
		["a class is absent", {"heroes_lack_class": "mage"},
			["warrior", "cleric", "cleric", "hunter"], ["bloodrage", "mercy", "conviction", "pack"], -1, four, eng4, -1],
		["how many of a class — two Warriors", {"heroes_class_count": {"class": "warrior", "min": 2, "max": 2}},
			["warrior", "warrior", "cleric", "hunter"], ["bloodrage", "heavy_plating", "mercy", "pack"], -1, four, eng4, -1],
		["a core rune held by anyone", {"heroes_hold_core": "pack"},
			four, eng4, -1, four, ["bloodrage", "overburn", "mercy", "lethal_aim"], -1],
		["all four stand as the fight opens", {"heroes_all_standing": true},
			four, eng4, -1, four, eng4, 1],
		["a class present who has fallen is not present", {"heroes_include_class": "mage"},
			four, eng4, -1, four, eng4, 1],
	]
	var works := 0
	for c in cases:
		var yes := await _crest_paid(c[2], c[3], c[1], int(c[4]))
		var no := await _crest_paid(c[5], c[6], c[1], int(c[7]))
		var yes_ok: bool = int(yes["paid"]) == int(yes["heroes"]) and int(yes["heroes"]) == 4 and not bool(yes["told"])
		var no_ok: bool = int(no["paid"]) == 0 and bool(no["told"])
		ok(yes_ok, "§6 %s: the party that satisfies it was paid on %d of %d heroes (told %s)" % [c[0], yes["paid"], yes["heroes"], yes["told"]])
		ok(no_ok, "§6 %s: the party that does not was paid on %d heroes, or the log did not say why" % [c[0], no["paid"]])
		if yes_ok and no_ok:
			works += 1
		print("    %s: %s" % [c[0], "both ways" if yes_ok and no_ok else "FAILED"])
	# AND A HERO RUNE READS THE SAME FOUR: the spawn hands every worn rune's payload
	# the party through the ctx the crest's uses, so a condition on one hero's rune
	# holds or fails exactly as the crest's does — paid on him alone, never on the
	# others, and told in the roll call when it does not hold.
	var hr_yes := await _hero_rune_paid(four, eng4, {"heroes_include_class": "cleric"})
	var hr_no := await _hero_rune_paid(["warrior", "mage", "hunter", "hunter"],
		["bloodrage", "overburn", "pack", "lethal_aim"], {"heroes_include_class": "cleric"})
	ok(bool(hr_yes["on_him"]) and int(hr_yes["others"]) == 0 and bool(hr_yes["named"]) and not bool(hr_yes["told"]),
		"§6 a hero rune's condition that holds: paid on its wearer %s, on %d others, told %s" % [
			hr_yes["on_him"], hr_yes["others"], hr_yes["told"]])
	ok(not bool(hr_no["on_him"]) and int(hr_no["others"]) == 0 and bool(hr_no["told"]),
		"§6 a hero rune's condition that does not hold: paid on its wearer %s, or the log did not say why" % hr_no["on_him"])
	print("    a hero rune's condition: %s" % ("both ways" if bool(hr_yes["on_him"]) and not bool(hr_no["on_him"]) and bool(hr_no["told"]) else "FAILED"))
	Runes._load().erase(HERO_FX)
	ok(not Runes.ids().has(HERO_FX), "§6: the fixture hero rune was left in the loaded table")
	# A PARTY KEY WITH NO PARTY IN THE CTX IS FALSE, and the door takes one ctx for
	# every caller that stamps a payload on a hero.
	ok(not Talents.condition_met({"heroes_include_class": "cleric"}, {"member": {}}),
		"§6: a party key with no party read true")
	ok(Talents.condition_met({}, {}), "§6: an empty condition read false")
	for f2 in ["res://scripts/battle.gd", "res://scripts/party_screen.gd"]:
		ok(Gate.strip_comments(FileAccess.get_file_as_string(f2)).contains("\"party\": Run.party"),
			"§6: %s does not hand the party to the payload's condition" % f2)
	Runes._load().erase(CREST_FX)
	ok(not Runes.ids().has(CREST_FX), "§6: the fixture crest rune was left in the loaded table")
	print("    %d of %d conditions work both ways" % [works, cases.size()])


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§9: %s changed under this gate" % p)
