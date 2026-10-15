# BATCH IH — THE CARD, THE SHEET, AND EVERY PLATE THAT OVERLAPS ITSELF.
#
#   §0a THE READOUT SAYS WHEN A FIGHT IS NOT PLAY: a debug action named on the map before the run's file exists rides
#       the header; one taken after it is a `debug` line of its own at once; every fight names each action that
#       touched it — on the map since the last fight, in the fight, or a switch in force as it opened; a clean run's
#       header and fight name none (the negative arm).
#   §0b A CONJUNCTION SAYS WHY IT ENDED: five Ruptures, one ended by each door — its clock, a cleanse, a consumer, its
#       body dying, the fight ending — each read off the line the real doors wrote.
#   §0c THE LINEAGE: the header's `lineage` is the key `Run.awaken` writes — "" for a hero on his class's spine — and
#       `lineage_name` and `core_kind` ride beside it (the designer's own party: Warden, spine Mage, Devout, Sharpshooter).
#   §0d SANCTITY's RULE TEXT reads its constants.
#   §2  THE CARD: no core-rune line on any card; a Runes button beside Kit on every card reading `Runes n/6`, inside the
#       card, clear of Kit and CHOOSE; it opens that hero's rune panel and no other's; Close leaves the card as it was;
#       a hero wearing nothing reads `Runes 0/6` and his panel draws its three sections, empty (the negative arm).
#   §3  THE SHEET: the blurb, every live stat, the class passive and the talent tree; no ability row, no tag census and
#       no rune row anywhere on it (the negative arm) — each drawn on its own panel (the positive arm); the passive
#       block holds the class passive and the lineage's own engine, no other core rune's rule, and no scroller.
#   §4  THE RUNES PANEL's DOORS: the button always, the ✦ marker while something is held, the slot buttons; the longest
#       panel — three cores, three runes, a full held list — draws every row once.
#   §5  THE KIT PANEL's HOVER: every ability row carries the moved builder's tooltip, string for string the kit
#       preview's for the same card; a card that sits out says so; a row that is not an ability carries none; the
#       builder is one (`Run.ability_hover`) and the sheet carries no copy.
#   §6  NOTHING ON A PLATE OR A CARD IS DRAWN OVER ANYTHING ELSE: every plate and card the census names, walked over
#       every class, lineage, enemy kind and plate state — no two drawn rects intersect but a value inside its own bar,
#       contained top and bottom; no drawn rect runs past its container. Controlled both ways.
#   §9  The player's files and his readout folder are as this gate found them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ih.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ih_profile.json"
const SCRATCH_RELICS := "user://ih_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const READOUT_DIR := "user://readout_harness"
const PLAYER_READOUT_DIR := "user://readout"
const ENC := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _player_readout := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IH — THE CARD, THE SHEET, AND EVERY PLATE THAT OVERLAPS ITSELF")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_player_readout = _listing(PLAYER_READOUT_DIR)
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_clear_harness_readout()
	await _s0a_debug()
	await _s0a_clean()
	await _s0b_conjunction_ends()
	await _s0c_lineage()
	_s0d_sanctity()
	await _s2_the_card()
	await _s3_the_sheet()
	await _s4_the_doors()
	await _s5_the_hover()
	await _s6_nothing_over_anything()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	OS.set_environment("DOD_READOUT", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _listing(dir_path: String) -> Dictionary:
	var out := {}
	if not DirAccess.dir_exists_absolute(dir_path):
		return out
	for f in DirAccess.get_files_at(dir_path):
		out[String(f)] = FileAccess.get_file_as_bytes(dir_path.path_join(String(f)))
	return out


func _clear_harness_readout() -> void:
	if not DirAccess.dir_exists_absolute(READOUT_DIR):
		return
	for f in DirAccess.get_files_at(READOUT_DIR):
		_remove(READOUT_DIR.path_join(String(f)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(READOUT_DIR))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string(JSON.stringify([]))
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


# A run on the map: each hero awakened on the engine named (a lineage's id, or `spine:<pid>`).
func _new_run(specs: Array = ["berserker", "spine:channel", "inquisitor", "sharpshooter"]) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var sp := String(specs[i])
		var pid := sp.trim_prefix("spine:") if sp.begins_with("spine:") else Classes.engine_of_spec(sp)
		_run.awaken(i, Runes.engine_rune_id(pid))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	var mp: Node = current_scene
	if mp != null and Gate.hero_draft(mp) != null:
		mp.call("_close_hero_draft")
		await Gate.frames(self, 2)
	return mp


# A real battle, entered the way the map's node press enters one.
func _enter(enc: Dictionary) -> Node:
	OS.set_environment("DOD_AUTOPLAY", "")
	Gate.enter_battle(self, enc.duplicate(true))
	await Gate.frames(self, 30)
	Engine.time_scale = 1.0
	var s: Node = current_scene
	return s if s != null and s.has_method("_check_end") else null


func _board(specs: Array, over: Dictionary = {}) -> Node:
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


func _wipe(u: BattleUnit) -> void:
	u.statuses = []
	u.broken = false
	u.broken_pending = false
	u.pressure = 0
	u.max_hp = maxi(u.max_hp, 100000)
	u.hp = u.max_hp
	u._refresh_chips()


func _rune(id: String, worn: bool) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = worn
	return r


func _ability(u: BattleUnit, name: String) -> Ability:
	for ab in u.abilities:
		if ab != null and String(ab.display_name) == name:
			return ab
	return null


# The fight's end, as `_check_end` reads it: the warband down. The combat is not the subject here.
func _end_fight(s: Node) -> void:
	if s == null:
		return
	for e in s.get("enemies"):
		(e as BattleUnit).hp = 0
		(e as BattleUnit).dead = true
	s.call("_check_end")


func _read_lines(path: String) -> Array:
	var out: Array = []
	if path == "" or not FileAccess.file_exists(path):
		return out
	for ln in FileAccess.get_file_as_string(path).split("\n"):
		if String(ln).strip_edges() == "":
			continue
		var v: Variant = JSON.parse_string(String(ln))
		out.append(v if v is Dictionary else {"unparsed": String(ln)})
	return out


func _labels(n: Node) -> Array:
	var out: Array = []
	if n == null:
		return out
	for c in n.get_children():
		if c is Label and not c.is_queued_for_deletion():
			out.append(c)
		out.append_array(_labels(c))
	return out


func _texts(n: Node) -> Array:
	return Gate.texts(n)


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and (c as Control).z_index == 60:
			c.queue_free()
	mp.set("_loadout_panel_for", -1)
	mp.set("_rune_panel_for", -1)
	mp.set("_bag_panel_open", false)


func _runes_button(mp: Node, idx: int) -> Button:
	for b in Gate.bound_buttons(mp, "_open_rune_panel"):
		if (b as Button).has_meta("runes_button") and int((b as Button).get_meta("runes_button")) == idx:
			return b
	return null


func _kit_button(mp: Node, idx: int) -> Button:
	return Gate.bound_button(mp, "_open_loadout_panel", [idx])


func _card_rect(idx: int) -> Rect2:
	return Rect2(Vector2(8.0, 84.0 + idx * 158.0), Vector2(300.0, 152.0))
# ── §0a — THE READOUT SAYS WHEN A FIGHT IS NOT PLAY ─────────────────────────────────────────────

func _s0a_debug() -> void:
	print("\n§0a — a debug action is named the moment it is taken, on the header, its own line and every fight it touched")
	_fresh_meta()
	_clear_harness_readout()
	_new_run()
	OS.set_environment("DOD_READOUT", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	var mp: Node = await _to_map()
	ok(mp != null and mp.has_method("_on_burger") and bool(_run.debug_enabled()),
		"§0a: the premise — the map screen with its debug dispatch, debug enabled in this build")
	if mp == null or not mp.has_method("_on_burger"):
		return
	# Before any file: the action is kept for the header.
	mp.call("_on_burger", 10)
	await Gate.frames(self, 2)
	var st: Dictionary = _run.readout
	ok(String(st.get("path", "")) == "" and (st.get("debug", []) as Array).size() == 1
			and String((st["debug"] as Array)[0].get("action", "")) == "+200 Gold"
			and String((st["debug"] as Array)[0].get("taken", "")) == "on the map",
		"§0a: +200 Gold on the map before any fight is not kept for the header: %s" % [st])
	# Fight 1, ended from the battle's own menu.
	var b1: Node = await _enter(ENC)
	ok(b1 != null and b1.get("_readout") != null and b1.has_method("_on_debug_menu"),
		"§0a: the premise — a real battle with the readout on and its DEBUG menu")
	if b1 == null or b1.get("_readout") == null:
		return
	b1.call("_on_debug_menu", 3)
	await Gate.frames(self, 3)
	var path := String((_run.readout as Dictionary).get("path", ""))
	var lines := _read_lines(path)
	ok(lines.size() == 2, "§0a: after one fight ended by Kill All the file holds %d lines — want the header and the fight" % lines.size())
	if lines.size() < 2:
		return
	var h: Dictionary = lines[0]
	var f1: Dictionary = lines[1]
	var want1 := [{"action": "+200 Gold", "taken": "on the map"}, {"action": "Kill All Enemies", "taken": "in the fight"}]
	ok(bool(h.get("debug_used", false)) and str(h.get("debug", [])) == str(want1),
		"§0a: the header does not carry the run's flag and the two actions before it: %s / %s" % [h.get("debug_used"), h.get("debug")])
	ok(str(f1.get("debug", [])) == str(want1),
		"§0a: the fight Kill All ended does not name both actions that touched it: %s" % [f1.get("debug")])
	# After the file exists: a line of its own, at once.
	mp = await _to_map()
	mp.call("_on_burger", 12)
	await Gate.frames(self, 2)
	lines = _read_lines(path)
	var dl: Dictionary = lines[lines.size() - 1] if lines.size() > 0 else {}
	ok(lines.size() == 3 and String(dl.get("kind", "")) == "debug" and String(dl.get("action", "")) == "Full Heal Heroes"
			and String(dl.get("taken", "")) == "on the map" and int(dl.get("after_fight", -1)) == 1,
		"§0a: Full Heal Heroes on the map after a fight wrote no line of its own at once: %s" % [dl])
	# Fight 2: ended as a fight ends; it names the heal, which touched it.
	var b2: Node = await _enter(ENC)
	_end_fight(b2)
	await Gate.frames(self, 3)
	lines = _read_lines(path)
	var f2: Dictionary = lines[lines.size() - 1] if lines.size() > 0 else {}
	ok(String(f2.get("kind", "")) == "fight" and int(f2.get("n", 0)) == 2
			and str(f2.get("debug", [])) == str([{"action": "Full Heal Heroes", "taken": "on the map"}]),
		"§0a: the second fight does not name the heal taken before it, and only that: %s" % [f2.get("debug")])
	# Fight 3: nothing touched it — THE NEGATIVE ARM.
	var b3: Node = await _enter(ENC)
	_end_fight(b3)
	await Gate.frames(self, 3)
	lines = _read_lines(path)
	var f3: Dictionary = lines[lines.size() - 1] if lines.size() > 0 else {}
	ok(int(f3.get("n", 0)) == 3 and f3.has("debug") and (f3.get("debug", [1]) as Array).is_empty(),
		"§0a: a fight no debug action touched names one, or carries no list: %s" % [f3.get("debug")])
	# A switch in force touches every fight while it is on.
	mp = await _to_map()
	mp.call("_on_burger", 16)
	await Gate.frames(self, 2)
	var b4: Node = await _enter(ENC)
	_end_fight(b4)
	await Gate.frames(self, 3)
	var b5: Node = await _enter(ENC)
	_end_fight(b5)
	await Gate.frames(self, 3)
	lines = _read_lines(path)
	var fights: Array = lines.filter(func(l): return String(l.get("kind", "")) == "fight")
	var f4: Dictionary = fights[3] if fights.size() > 3 else {}
	var f5: Dictionary = fights[4] if fights.size() > 4 else {}
	var unlocked := {"action": "All Class Abilities Unlocked", "taken": "in force"}
	ok(str(f4.get("debug", [])) == str([{"action": "All Class Abilities Unlocked: on", "taken": "on the map"}, unlocked])
			and str(f5.get("debug", [])) == str([unlocked]),
		"§0a: the unlock switch does not touch every fight while it is on: %s / %s" % [f4.get("debug"), f5.get("debug")])
	_run.debug_grant_all = false
	ok(fights.size() == 5 and lines.filter(func(l): return String(l.get("kind", "")) == "debug").size() == 2,
		"§0a: the file holds %d fights and its debug lines are not the two taken after it existed" % fights.size())
	OS.set_environment("DOD_READOUT", "")
	_clear_harness_readout()


# A clean run says so: the run's flag false and both lists empty — THE NEGATIVE ARM of the header.
func _s0a_clean() -> void:
	print("\n§0a — a run with no debug action says so: the flag false, the lists empty")
	_fresh_meta()
	_clear_harness_readout()
	_new_run()
	OS.set_environment("DOD_READOUT", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	var b: Node = await _enter(ENC)
	if b == null:
		ok(false, "§0a: the premise — a real battle")
		return
	_end_fight(b)
	await Gate.frames(self, 3)
	var lines := _read_lines(String((_run.readout as Dictionary).get("path", "")))
	ok(lines.size() == 2 and not bool(lines[0].get("debug_used", true)) and (lines[0].get("debug", [1]) as Array).is_empty()
			and lines[1].has("debug") and (lines[1].get("debug", [1]) as Array).is_empty(),
		"§0a: a clean run's header or fight names a debug action: %s" % [lines])
	OS.set_environment("DOD_READOUT", "")
	_clear_harness_readout()


# ── §0b — A CONJUNCTION SAYS WHY IT ENDED ─────────────────────────────────────────────────────────

func _s0b_conjunction_ends() -> void:
	print("\n§0b — a Rupture ended by each door: its clock, a cleanse, a consumer, its body dying, the fight ending")
	_fresh_meta()
	_clear_harness_readout()
	OS.set_environment("DOD_READOUT", "1")
	var s: Node = await _board(["berserker", "cryomancer", "holy", "mystic"], {1: {"bm_abilities": ["Smoulder"], "bm_equipped": ["Smoulder"]}})
	OS.set_environment("DOD_READOUT", "")
	var mage := _hero(s, "mage")
	var foes := _foes(s)
	var sm: Ability = _ability(mage, "Smoulder") if mage != null else null
	ok(mage != null and sm != null and foes.size() >= 3 and s.get("_readout") != null,
		"§0b: the premise — a Cryomancer with Smoulder, three enemies and the readout on")
	if mage == null or sm == null or foes.size() < 3 or s.get("_readout") == null:
		await _clear(s)
		return
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	for f in foes:
		_wipe(f)
	# 1 — the clock: its shorter ingredient runs out on the body's own tick.
	await _rupture(s, mage, sm, a)
	var guard := 0
	while a.has_status("rupture") and guard < 20:
		a.tick_statuses()
		guard += 1
	# 2 — a cleanse lifts it whole.
	await _rupture(s, mage, sm, a)
	a.purge_debuffs()
	# 3 — a consumer takes one ingredient.
	await _rupture(s, mage, sm, a)
	a.remove_status("chilled")
	# 4 — its body dies (the debug menu's switch, `_die()`).
	await _rupture(s, mage, sm, b)
	b.hp = 0
	b._die()
	# 5 — it stands when the fight ends (a forfeit: the bodies live).
	await _rupture(s, mage, sm, c)
	s.call("_do_forfeit", String(s.get("FORFEIT_REASONS")[0][0]), String(s.get("FORFEIT_REASONS")[0][1]))
	await Gate.frames(self, 3)
	var lines := _read_lines(String((_run.readout as Dictionary).get("path", "")))
	var f: Dictionary = lines[lines.size() - 1] if lines.size() > 0 else {}
	var cj: Array = f.get("conjunctions", [])
	var ends: Array = cj.map(func(x): return String(x.get("ended", "")))
	print("    ended %s" % [ends])
	ok(ends == ["its clock ran out", "it was cleansed", "an ingredient was consumed", "its body died", "the fight ended"],
		"§0b: the five Ruptures do not say why each ended, in order: %s" % [ends])
	ok(cj.size() == 5 and cj.all(func(x): return int(x.get("ended_turn", -1)) >= int(x.get("formed_turn", 0)))
			and bool(cj[4].get("standing_at_end", false)) and not cj.slice(0, 4).any(func(x): return bool(x.get("standing_at_end", true))),
		"§0b: an end's turn or the standing flag disagrees with why it ended: %s" % [str(cj).left(300)])
	ok(not ends.has("it left by a door the readout does not hear"),
		"§0b: an end came by a door the readout did not hear")
	await _clear(s)
	_clear_harness_readout()


func _rupture(s: Node, mage: BattleUnit, sm: Ability, on: BattleUnit) -> void:
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, Classes.pool_ability("Frostbolt"), on, "good")
	mage.resource = mage.max_resource
	mage.cooldowns = {}
	await s.call("_resolve", mage, sm, on, "good")
	ok(on.has_status("rupture"), "§0b: the premise — Frostbolt then Smoulder on %s made no Rupture" % on.unit_name)


# ── §0c — THE LINEAGE, AND WHAT A CORE RUNE IS ────────────────────────────────────────────────────

func _s0c_lineage() -> void:
	print("\n§0c — the header's lineage is the key `awaken` writes; its name and each core rune's kind ride beside it")
	_fresh_meta()
	_clear_harness_readout()
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	# The designer's party: a Warden, a Mage on the class's spine, a Devout, a Sharpshooter.
	var pids := [Classes.engine_of_spec("warden"), "channel", Classes.engine_of_spec("inquisitor"),
		Classes.engine_of_spec("sharpshooter")]
	for i in 4:
		_run.awaken(i, Runes.engine_rune_id(String(pids[i])))
	_run.specs_chosen = true
	_run.active = true
	OS.set_environment("DOD_READOUT", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	var bt: Node = await _enter(ENC)
	if bt == null:
		ok(false, "§0c: the premise — a real battle")
		return
	_end_fight(bt)
	await Gate.frames(self, 3)
	var lines := _read_lines(String((_run.readout as Dictionary).get("path", "")))
	var party: Array = lines[0].get("party", []) if lines.size() > 0 else []
	var got: Array = party.map(func(r): return [r.get("lineage"), r.get("lineage_name"), r.get("core_kind")])
	print("    %s" % [got])
	ok(got == [["warden", "Warden", ["lineage"]], ["", "", ["spine"]], ["inquisitor", "Devout", ["lineage"]],
			["sharpshooter", "Sharpshooter", ["lineage"]]],
		"§0c: the four rows do not read lineage, its name and the core rune's kind as `awaken` set them: %s" % [got])
	var fl: Array = lines[1].get("loadout", []) if lines.size() > 1 else []
	ok(fl.size() == 4 and fl.all(func(r): return r.has("lineage_name") and r.has("core_kind")),
		"§0c: the fight's loadout does not carry the name and the kind")
	OS.set_environment("DOD_READOUT", "")
	_clear_harness_readout()


# ── §0d — SANCTITY's RULE TEXT READS ITS CONSTANTS ───────────────────────────────────────────────

func _s0d_sanctity() -> void:
	print("\n§0d — Sanctity's rule text names the step and the cap its constants hold")
	var t := Classes.engine_desc("sanctity")
	var want_step := "every %d changes" % int(BattleUnit.SANCTITY_PER_STEP)
	var want_cap := "up to %d." % int(BattleUnit.SANCTITY_MAX_STEPS)
	print("    %s" % t.replace("\n", " ").left(120))
	ok(t.contains(want_step) and t.contains(want_cap) and not t.contains("%d"),
		"§0d: Sanctity's rule does not read `%s` and `%s` off its constants: %s" % [want_step, want_cap, t.left(80)])
	ok(Runes.engine_text("sanctity").contains(want_step),
		"§0d: the one door a rune's text asks (`Runes.engine_text`) does not carry the step")


# ── §2 — THE CARD: THE LINE GOES, THE BUTTON ARRIVES ─────────────────────────────────────────────

func _s2_the_card() -> void:
	print("\n§2 — every card: no core-rune line; Runes n/6 beside Kit, inside the card; its own panel; Close")
	_fresh_meta()
	_new_run()
	# Hero 3 wears an ordinary rune too, so a count of two kinds is read.
	var m3: Dictionary = _run.party[3]
	var rid := ""
	for id in Runes.ids():
		var r: Dictionary = Runes.build(String(id))
		if not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(r) and not Runes.is_retired(String(id)) \
				and String(r.get("scope", "")) == "class:hunter":
			rid = String(id)
			break
	if rid != "":
		m3["runes"] = [_rune(rid, true)]
	var mp: Node = await _to_map()
	var lines: Array = _labels(mp).filter(func(l): return (String((l as Label).text).begins_with("core runes:")
		or String((l as Label).text).contains("click the card for the sheet")))
	ok(lines.is_empty(), "§2: a card still draws the core-rune line: %s" % [lines.map(func(l): return l.text)])
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		var b := _runes_button(mp, i)
		var kit := _kit_button(mp, i)
		var want := "Runes %d/%d" % [int(_run.engines_worn(m)) + int(_run.runes_worn(m)),
			int(_run.ENGINE_SLOTS) + int(_run.rune_slots())]
		ok(b != null and String(b.text).ends_with(want), "§2: card %d's Runes button reads '%s' — want `%s`" % [
			i, b.text if b != null else "none", want])
		if b == null or kit == null:
			continue
		var card := _card_rect(i)
		var br := b.get_global_rect()
		var kr := kit.get_global_rect()
		ok(card.encloses(br) and not br.intersects(kr) and absf(br.position.y - kr.position.y) < 0.5
				and br.end.x <= kr.position.x and b.get_combined_minimum_size().x <= br.size.x + 0.5,
			"§2: card %d's Runes button %s is not inside its card on Kit's row, left of Kit %s, its face inside it" % [i, br, kr])
		# ITS PANEL, AND NO OTHER HERO's.
		b.emit_signal("pressed")
		await Gate.frames(self, 2)
		var ov: Node = Gate.overlay(mp, 60)
		var title := ""
		for l in _labels(ov):
			if String((l as Label).text).ends_with("— RUNES"):
				title = String((l as Label).text)
		ok(ov != null and int(mp.get("_rune_panel_for")) == i
				and title == "%s — RUNES" % String(m["key"]).capitalize(),
			"§2: card %d's Runes button opened '%s' (panel for %d)" % [i, title, int(mp.get("_rune_panel_for"))])
		# CLOSE RETURNS TO THE MAP, THE CARD AS IT WAS.
		var face_before := String(b.text)
		var pressed_close := Gate.press(ov, ["Close"]) if ov != null else ""
		await Gate.frames(self, 2)
		var b2 := _runes_button(mp, i)
		ok(pressed_close == "Close" and Gate.overlay(mp, 60) == null and int(mp.get("_rune_panel_for")) == -1
				and b2 != null and String(b2.text) == face_before,
			"§2: card %d's panel did not close back to the card as it was (%s, overlay %s, '%s')" % [
				i, pressed_close, Gate.overlay(mp, 60) != null, b2.text if b2 != null else "none"])
	# THE NEGATIVE ARM — a hero wearing nothing reads 0 of 6, and his panel draws its three sections empty.
	_run.party[1]["engines"] = []
	_run.party[1]["runes"] = []
	mp = await _to_map()
	var b0 := _runes_button(mp, 1)
	ok(b0 != null and String(b0.text) == "Runes 0/6", "§2: a hero wearing nothing reads '%s' — want `Runes 0/6`" % (
		b0.text if b0 != null else "none"))
	if b0 != null:
		b0.emit_signal("pressed")
		await Gate.frames(self, 2)
		var ov0: Node = Gate.overlay(mp, 60)
		var tx: Array = _texts(ov0) if ov0 != null else []
		var heads: Array = tx.filter(func(t): return (String(t).begins_with("CORE — ") or String(t).begins_with("WORN — ")
			or String(t).begins_with("HELD, NOT WORN — ")))
		heads.sort()
		var want_heads := ["CORE — 0 of 3 slots", "HELD, NOT WORN — 0 of %d" % int(_run.HERO_HOLD_CAP), "WORN — 0 of 3 slots"]
		ok(heads == want_heads
				and tx.filter(func(t): return String(t) == "— empty —").size() == 3 and tx.has("No rune worn.")
				and tx.any(func(t): return String(t).begins_with("Nothing held.")),
			"§2: the empty hero's panel does not draw its three sections, each empty: %s" % [tx.slice(0, 12)])
		_close_overlays(mp)
		await Gate.frames(self, 2)


# ── §3 — THE SHEET: WHAT HE IS, AND NOTHING ELSE ─────────────────────────────────────────────────

func _sheet(idx: int) -> Node:
	_run.hero_screen_idx = idx
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	return current_scene


func _s3_the_sheet() -> void:
	print("\n§3 — the sheet keeps what he is and draws nothing he wears; each thing he wears is drawn on its panel")
	_fresh_meta()
	_new_run(["berserker", "spine:channel", "inquisitor", "sharpshooter"])
	# The Berserker wears a second core rune that is not his lineage's — its rule is the Runes panel's.
	var m0: Dictionary = _run.party[0]
	var other_pid := Classes.engine_of_spec("warden")
	m0["engines"] = (m0["engines"] as Array) + [_rune(Runes.engine_rune_id(other_pid), true)]
	m0["bm_abilities"] = ["Cleave"]
	m0["bm_equipped"] = ["Cleave"]
	var kept := ["HP: ", "Attack: ", "Armor: ", "Resistances", "Speed: ", "Constitution: ", "Crit Chance: ", "Parry: "]
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		var key := String(m["key"])
		var sheet: Node = await _sheet(i)
		var tx: Array = _texts(sheet)
		var res_word := String(Classes.hero_config(key).get("resource_name", "Mana")) + ": "
		var missing: Array = (kept + [res_word]).filter(func(k): return not tx.any(func(t): return String(t).begins_with(k)))
		var cp: Dictionary = Classes.CLASS_PASSIVES[key]
		ok(missing.is_empty() and tx.has(String(Classes.CLASS_BLURBS[key]))
				and tx.any(func(t): return String(t).begins_with("Class: %s — " % cp["name"]))
				and tx.any(func(t): return String(t).contains("(LOCKED FOR THIS RUN)")),
			"§3 (%s): the sheet lost a block it keeps — stats missing %s, the blurb, the class passive or the talent tree" % [key, missing])
		# THE NEGATIVE ARM — no ability row, no tag census, no rune row, no state word and no scroller anywhere.
		var kit_names: Array = _run.loadout_ability_names(m)
		var rune_names: Array = []
		for r in (m.get("engines", []) as Array) + (m.get("runes", []) as Array):
			rune_names.append(String((r as Dictionary).get("name", "")))
		var stray: Array = tx.filter(func(t):
			var s := String(t).trim_prefix("↑ ")
			return (s.begins_with("ABILITIES") or s.contains("CARRIED BY TAG") or s.begins_with("RUNES")
				or ["CORE", "WORN", "CREST", "held", "sits out"].has(s) or s.contains("Core rune: none")
				or kit_names.any(func(n): return (s == String(n) or s.begins_with(String(n) + "  (")))
				or rune_names.any(func(n): return s.contains(String(n)))))
		var scrollers: Array = []
		var stack: Array = [sheet]
		while not stack.is_empty():
			var n: Node = stack.pop_back()
			if n is ScrollContainer:
				scrollers.append(n)
			for c in n.get_children():
				stack.append(c)
		ok(stray.is_empty() and scrollers.is_empty(),
			"§3 (%s): the sheet draws something he wears, or a scroller: %s (%d scrollers)" % [key, stray.slice(0, 4), scrollers.size()])
		# THE PASSIVE BLOCK: the class passive and his lineage's own engine — no other core rune's rule.
		var block: Label = null
		for l in _labels(sheet):
			if (l as Label).has_meta("passive_block"):
				block = l
		var spec := String(m.get("spec", ""))
		var own := Classes.engine_of_spec(spec) if spec != "" else ""
		var lines2: Array = String(block.text).split("\n") if block != null else []
		var want_n := 2 if own != "" and Runes.held_engines(m).has(own) else 1
		ok(block != null and lines2.size() == want_n and String(lines2[0]).begins_with("Class: ")
				and (want_n == 1 or String(lines2[1]).begins_with(Runes.engine_text(own).get_slice(":", 0))),
			"§3 (%s): the passive block is not the class passive and the lineage's own engine: %s" % [key, lines2])
		if block != null:
			var others: Array = Runes.held_engines(m).filter(func(p): return String(p) != own)
			ok(not others.any(func(p): return String(block.text).contains(Runes.engine_text(String(p)).left(30))),
				"§3 (%s): the passive block prints a worn core rune's rule that is not his lineage's: %s" % [key, others])
			# No scroller, and the whole block inside its column, clear of the stat rows above it.
			var r2 := block.get_global_rect()
			ok(r2.position.x >= 60.0 and r2.end.x <= 460.5 and r2.end.y <= 720.0
					and block.get_combined_minimum_size().y <= r2.size.y + 0.5,
				"§3 (%s): the passive block %s runs past its column or is cut (needs %.0f px)" % [key, r2, block.get_combined_minimum_size().y])
	# THE STANCES LINE READS THE FIGHT's FIGURE (IH §3; it read 15 while the fight paid 30).
	_new_run(["swordmaster", "spine:channel", "inquisitor", "sharpshooter"])
	var sw: Node = await _sheet(0)
	var agg := "AGGRESSIVE — +%d%% damage dealt" % int(round(BattleUnit.SEASONED_AGG_DEALT * 100.0))
	ok(_texts(sw).any(func(t): return String(t).contains(agg) and not String(t).contains("earnable")),
		"§3: the Swordmaster's Stances line does not read `%s`, or still calls Guard Change earnable" % agg)
	# THE POSITIVE ARM — each thing the sheet lost is drawn on its own panel.
	_new_run(["berserker", "spine:channel", "inquisitor", "sharpshooter"])
	_run.party[0]["engines"] = (_run.party[0]["engines"] as Array) + [_rune(Runes.engine_rune_id(other_pid), true)]
	var mp: Node = await _to_map()
	mp.call("_open_loadout_panel", 0)
	await Gate.frames(self, 2)
	var kt: Array = _texts(Gate.overlay(mp, 60))
	var kit0: Array = _run.loadout_ability_names(_run.party[0])
	ok(kt.any(func(t): return String(t).begins_with("CARRIED BY TAG"))
			and kit0.all(func(n): return kt.any(func(t): return String(t).trim_prefix("↑ ").begins_with(String(n)))),
		"§3: the Kit panel does not draw his cards and the tag census the sheet gave up")
	_close_overlays(mp)
	await Gate.frames(self, 1)
	mp.call("_open_rune_panel", 0)
	await Gate.frames(self, 2)
	var rt: String = "\n".join(PackedStringArray(_texts(Gate.overlay(mp, 60))))
	ok(rt.contains(Runes.engine_text(other_pid)) and rt.contains(String(Runes.config(Runes.engine_rune_id(other_pid)).get("name", "?"))),
		"§3: the Runes panel does not draw the worn core rune whose rule the sheet gave up")
	_close_overlays(mp)
	await Gate.frames(self, 1)


# ── §4 — THE RUNES PANEL, BEHIND ITS BUTTON ──────────────────────────────────────────────────────

func _s4_the_doors() -> void:
	print("\n§4 — the doors: the button always, ✦ while something waits, the slots; the longest panel draws every rune once")
	_fresh_meta()
	_new_run()
	var mp: Node = await _to_map()
	# Nothing held: the button is there and the ✦ marker is not (the negative arm of the glance).
	var marks: Array = Gate.bound_buttons(mp, "_open_rune_panel").filter(func(b): return (b as Button).has_meta("held_marker"))
	ok(_runes_button(mp, 0) != null and marks.is_empty(),
		"§4: with nothing held the card has no Runes button, or draws the ✦ marker (%d)" % marks.size())
	# THE LONGEST CASE: three cores slotted, three runes worn and a full held list.
	var m: Dictionary = _run.party[3]
	var engs: Array = []
	for pid in Classes.class_engines("hunter"):
		engs.append(_rune(Runes.engine_rune_id(String(pid)), engs.size() < 3))
	m["engines"] = engs
	var ords: Array = []
	for id in Runes.ids():
		var r: Dictionary = Runes.build(String(id))
		if Runes.is_engine_rune(String(id)) or Runes.is_party_rune(r) or Runes.is_retired(String(id)) \
				or String(r.get("scope", "")) != "class:hunter":
			continue
		r["equipped"] = ords.size() < 3
		ords.append(r)
		if ords.size() >= 3 + int(_run.HERO_HOLD_CAP) - 3:
			break
	m["runes"] = ords
	var held := int(_run.held_count(m))
	mp = await _to_map()
	var mark: Array = Gate.bound_buttons(mp, "_open_rune_panel").filter(func(b):
		return ((b as Button).has_meta("held_marker") and Gate.bound_args(b, "_open_rune_panel") == [3]))
	var faces4: Array = []
	for bb in Gate.bound_buttons(mp, "_open_rune_panel"):
		faces4.append("%s%s%s" % [(bb as Button).text, Gate.bound_args(bb, "_open_rune_panel"), " M" if (bb as Button).has_meta("held_marker") else ""])
	ok(held > 0 and mark.size() == 1, "§4: %d held and %d ✦ markers on the Hunter's card — want one while something waits %s" % [held, mark.size(), faces4])
	var slots: Array = Gate.bound_buttons(mp, "_open_rune_panel").filter(func(b):
		return (Gate.bound_args(b, "_open_rune_panel") == [3] and not (b as Button).has_meta("held_marker")
			and not (b as Button).has_meta("runes_button")))
	ok(slots.size() == int(_run.rune_slots()), "§4: the Hunter's card draws %d rune slots that open his panel" % slots.size())
	var b := _runes_button(mp, 3)
	ok(b != null and String(b.text).ends_with("Runes 6/6"), "§4: the longest hero's Runes button reads '%s'" % (b.text if b != null else "none"))
	if b == null:
		return
	b.emit_signal("pressed")
	await Gate.frames(self, 2)
	var ov: Node = Gate.overlay(mp, 60)
	var tx: Array = _texts(ov) if ov != null else []
	var all_names: Array = []
	for r2 in engs + ords:
		all_names.append(String((r2 as Dictionary).get("name", "")))
	var counts: Array = all_names.map(func(n): return tx.filter(func(t): return String(t).begins_with(String(n) + " — ")).size())
	print("    the longest panel: %d core runes, %d runes, %d held — %d rows" % [engs.size(), ords.size(), held, all_names.size()])
	ok(counts.all(func(c): return int(c) == 1), "§4: a rune of the longest panel is not drawn exactly once: %s" % [counts])
	# CORE and WORN read apart on the real screen: their heads are their own colours (IA §3).
	var core_c := Color.BLACK
	var worn_c := Color.BLACK
	for l in _labels(ov):
		if String((l as Label).text).begins_with("CORE — "):
			core_c = (l as Label).get_theme_color("font_color")
		elif String((l as Label).text).begins_with("WORN — "):
			worn_c = (l as Label).get_theme_color("font_color")
	ok(core_c != Color.BLACK and worn_c != Color.BLACK and not core_c.is_equal_approx(worn_c),
		"§4: the panel's CORE and WORN heads are not two colours (%s, %s)" % [core_c, worn_c])
	_close_overlays(mp)
	await Gate.frames(self, 1)


# ── §5 — THE KIT PANEL's ABILITY HOVER ───────────────────────────────────────────────────────────

func _s5_the_hover() -> void:
	print("\n§5 — every ability row on the Kit panel carries the moved hover; string for string the kit preview's")
	_fresh_meta()
	_new_run(["berserker", "pyromancer", "inquisitor", "mystic"])
	# THE LONGEST ABILITY TEXT IN THE GAME (the corpus, `Classes.ability_corpus`), carried by the hero
	# whose class's draft pool or whose lineage's pool holds it — it is earned, so it is a CARRIED row.
	var longest := ""
	var longest_len := 0
	for ab in Classes.ability_corpus():
		if ab != null and (ab as Ability).description.length() > longest_len:
			longest_len = (ab as Ability).description.length()
			longest = String((ab as Ability).display_name)
	var seat := -1
	for i in _run.party.size():
		var pm: Dictionary = _run.party[i]
		if Classes.draft_pool(String(pm["key"])).has(longest) or Classes.spec_pool(String(pm.get("spec", ""))).has(longest):
			seat = i
	print("    the longest description: %s (%d characters), seat %d" % [longest, longest_len, seat])
	ok(seat >= 0, "§5: the premise — a hero who can carry %s, the longest ability text" % longest)
	if seat < 0:
		seat = 0
	var m: Dictionary = _run.party[seat]
	var extra: Array = Classes.draft_pool(String(m["key"])).filter(func(n): return (String(n) != longest
		and not _run.opening_kit_names(m).has(n) and not Classes.sits_out(String(n), Runes.held_engines(m)))).slice(0, 2)
	m["bm_abilities"] = [longest] + extra
	m["bm_equipped"] = [longest]
	m["upgrades"] = [{"ability": longest, "id": "up_damage"}]
	var mp: Node = await _to_map()
	mp.call("_open_loadout_panel", seat)
	await Gate.frames(self, 2)
	var ov: Node = Gate.overlay(mp, 60)
	var live: Dictionary = _run.hero_live_config(m)
	var rows := 0
	var wrong: Array = []
	var bare: Array = []
	var heads_tipped: Array = []
	for l in _labels(ov):
		var lbl: Label = l
		var in_row := lbl.get_parent() is HBoxContainer
		if not in_row:
			if String(lbl.tooltip_text) != "":
				heads_tipped.append(lbl.text)
			continue
		var nm2 := String(lbl.text).trim_prefix("↑ ").get_slice(" — ", 0)
		rows += 1
		var want: String = _run.ability_hover(m, nm2, live)
		if String(lbl.tooltip_text) == "":
			bare.append(nm2)
		elif String(lbl.tooltip_text) != want:
			wrong.append(nm2)
	print("    %d ability rows, each with its hover" % rows)
	ok(rows >= 6 and bare.is_empty() and wrong.is_empty(),
		"§5: a Kit-panel ability row carries no hover %s, or not the moved builder's %s (%d rows)" % [bare, wrong, rows])
	# THE NEGATIVE ARM — a row that is not an ability (a section's head, a note) carries none.
	ok(heads_tipped.is_empty(), "§5: a line that is not an ability carries a hover: %s" % [heads_tipped])
	# THE LONGEST TEXT, WHOLE, AND ITS UPGRADE NAMED; THE BENCHED ONE READ SEATED.
	var lrow: Label = null
	var brow: Label = null
	for l2 in _labels(ov):
		var t := String((l2 as Label).text)
		if t == "↑ " + longest or t.begins_with("↑ " + longest + " — "):
			lrow = l2
		if extra.size() > 0 and t.begins_with(String(extra[0]) + " — "):
			brow = l2
	var vctx := Classes.value_ctx_from_config(live["cfg"], m)
	ok(lrow != null and String(lrow.tooltip_text).begins_with(Classes.resolve_values(
			Classes.spec_pool_ability(String(m.get("spec", "")), longest).description, vctx))
			and String(lrow.tooltip_text).ends_with(String(_run.upgrade_name("up_damage"))),
		"§5: the longest text's row is not ↑ %s with the whole description and its upgrade on its hover" % longest)
	ok(brow != null and String(brow.tooltip_text) != "" and String(brow.tooltip_text).contains("Damage")
			== (Classes.pool_ability(String(extra[0])).damage > 0) if extra.size() > 0 else true,
		"§5: the benched card's row carries no hover, or not its numbers seated")
	# STRING FOR STRING THE KIT PREVIEW's, for every card both list.
	_close_overlays(mp)
	await Gate.frames(self, 1)
	var kp: Node = mp.call("_open_kit_preview", seat)
	await Gate.frames(self, 2)
	var same := 0
	var differ: Array = []
	for l3 in _labels(kp):
		var t3 := String((l3 as Label).text).strip_edges()
		if String((l3 as Label).tooltip_text) == "" or t3.contains(" — sits out") or t3.begins_with("Benched"):
			continue
		var nm3 := t3.get_slice("  (", 0)
		if not _run.loadout_ability_names(m).has(nm3):
			continue
		if String((l3 as Label).tooltip_text) == _run.ability_hover(m, nm3, live):
			same += 1
		else:
			differ.append(nm3)
	ok(same >= 5 and differ.is_empty(), "§5: the kit preview's hover differs from the Kit panel's for %s (%d the same)" % [differ, same])
	kp.queue_free()
	await Gate.frames(self, 1)
	# A CARD THAT SITS OUT SAYS SO: Mark of the Hunt carried with the companion's engine gone.
	var bm: Dictionary = _run.party[3]
	var so_card := ""
	for card in Classes.draft_pool("hunter"):
		if Classes.sits_out(String(card), []) :
			so_card = String(card)
			break
	if so_card != "":
		bm["bm_abilities"] = [so_card]
		bm["bm_equipped"] = [so_card]
		bm["engines"] = []
		mp = await _to_map()
		mp.call("_open_loadout_panel", 3)
		await Gate.frames(self, 2)
		var sorow: Label = null
		for l4 in _labels(Gate.overlay(mp, 60)):
			if String((l4 as Label).text).begins_with(so_card + " — "):
				sorow = l4
		var note: String = _run.sits_out_note(so_card, [])
		ok(sorow != null and String(sorow.tooltip_text) == note and String(sorow.text).contains("Sits out"),
			"§5: %s, sitting out, does not say so on its row and its hover" % so_card)
		_close_overlays(mp)
	else:
		ok(false, "§5: the premise — a Hunter card that sits out without its engine")
	# THE BUILDER IS ONE: the sheet and the preview build no hover of their own.
	var ps := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/party_screen.gd"))
	var kps := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/kit_preview.gd"))
	var ms := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	ok(not ps.contains("computed_block(") and not kps.contains("computed_block(") and kps.contains("Run.ability_hover(")
			and ms.contains("Run.ability_hover(") and not ps.contains("tooltip_text = tip"),
		"§5: the hero sheet or the kit preview builds an ability hover of its own, or the panel does not ask the one builder")


# ── §6 — NOTHING ON A PLATE OR A CARD IS DRAWN OVER ANYTHING ELSE ────────────────────────────────
#
# **THE RULE, AS AN ASSERTION**: on one plate or card, no two drawn rects intersect, but for one
# sanctioned overlap — a value inside its own bar, contained by it entirely, top and bottom (a bar is
# its track and the fill laid inside it; a chip's tag is its chip's value) — and no drawn rect runs
# past its container. A Label's rect is its line box, never its ink, so "contained" means the whole
# line; a line that does not fit its box's width (clipped, or cut short) is a line running past it.

var _configs := {}          # family -> how many configurations were held to the rule
var _sanctioned := 0        # values read inside their own bars (the positive arm)
var _bad: Array = []        # every breach, named
var _most := {}            # family -> [where, drawn rects]
var _least := {}


# Every drawn rect under `nodes`, each [kind, global rect, node]. A flat button with no text draws nothing.
func _drawn(nodes: Array) -> Array:
	var out: Array = []
	var stack: Array = nodes.duplicate()
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n == null or n.is_queued_for_deletion():
			continue
		for k in n.get_children():
			stack.append(k)
		if not (n is Control) or not (n as Control).is_visible_in_tree():
			continue
		var c: Control = n
		var r := c.get_global_rect()
		if r.size.x <= 0.01 or r.size.y <= 0.01:
			continue
		var kind := ""
		if c is Label:
			if String((c as Label).text) == "":
				continue
			kind = "text"
		elif c is Button:
			if (c as Button).flat and String((c as Button).text) == "":
				continue
			kind = "button"
		elif c is ColorRect:
			if (c as ColorRect).color.a <= 0.01:
				continue
			kind = "fill"
		elif c is TextureRect:
			if (c as TextureRect).texture == null:
				continue
			kind = "image"
		elif c is Panel or c is PanelContainer:
			kind = "panel"
		else:
			continue
		out.append([kind, r, c])
	return out


func _nm(e: Array) -> String:
	var c: Control = e[2]
	var t := String(c.get("text")) if (c is Label or c is Button) else c.get_class()
	return "%s '%s' %s" % [e[0], t.left(24), e[1]]


# The track a rect lies inside: a fill or panel that encloses it and is not itself.
func _track_of(items: Array, e: Array) -> Array:
	for t in items:
		if t[2] == e[2] or not (t[0] == "fill" or t[0] == "panel"):
			continue
		if (t[1] as Rect2).grow(0.01).encloses(e[1]):
			return t
	return []


# THE ONE SANCTIONED OVERLAP. `a` and `b` meet; they may only if both lie inside one bar's track and
# `a` (or `b`) is that bar's own value or fill — a value laid on its bar (sharing its origin) and held
# by it top and bottom, a fill inside its track, or the track itself under either.
func _sanctioned_pair(items: Array, a: Array, b: Array) -> bool:
	for pair in [[a, b], [b, a]]:
		var inner: Array = pair[0]
		var outer: Array = pair[1]
		if inner[0] == "image" or outer[0] == "image":
			return false
		# The track itself, under its own value or fill.
		if (outer[0] == "fill" or outer[0] == "panel") and (outer[1] as Rect2).grow(0.01).encloses(inner[1]):
			if inner[0] == "fill" or ((inner[1] as Rect2).position - (outer[1] as Rect2).position).length() < 0.6:
				if inner[0] == "text":
					_sanctioned += 1
				return true
	# Two parts of one bar (its fill and its value), both inside the same track.
	var ta := _track_of(items, a)
	var tb := _track_of(items, b)
	return not ta.is_empty() and ta == tb and (a[0] == "fill" or b[0] == "fill") \
		and (a[0] != "text" or ((a[1] as Rect2).position - (ta[1] as Rect2).position).length() < 0.6) \
		and (b[0] != "text" or ((b[1] as Rect2).position - (ta[1] as Rect2).position).length() < 0.6)


# Holds one plate or card to the rule. `family` counts the configuration; `where` names it.
func _hold(family: String, where: String, container: Rect2, nodes: Array) -> void:
	_configs[family] = int(_configs.get(family, 0)) + 1
	var items := _drawn(nodes)
	if items.size() > int((_most.get(family, ["", -1]) as Array)[1]):
		_most[family] = [where, items.size()]
	if items.size() < int((_least.get(family, ["", 1 << 30]) as Array)[1]):
		_least[family] = [where, items.size()]
	for i in items.size():
		var a: Array = items[i]
		var ra: Rect2 = a[1]
		if not container.grow(0.5).encloses(ra):
			_bad.append("%s: %s runs past its container %s" % [where, _nm(a), container])
		if a[0] == "text":
			var l: Label = a[2]
			if l.get_combined_minimum_size().y > ra.size.y + 0.5:
				_bad.append("%s: %s is cut — its lines need %.0f px" % [where, _nm(a), l.get_combined_minimum_size().y])
			if l.autowrap_mode == TextServer.AUTOWRAP_OFF:
				var font := l.get_theme_font("font")
				var fs := l.get_theme_font_size("font_size")
				var w := 0.0
				for ln in String(l.text).split("\n"):
					w = maxf(w, font.get_string_size(String(ln), HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x)
				if w > ra.size.x + 0.5:
					_bad.append("%s: %s — its line is %.0f px in a %.0f-px box" % [where, _nm(a), w, ra.size.x])
		for j in range(i + 1, items.size()):
			var b: Array = items[j]
			var inter := ra.intersection(b[1])
			if inter.size.x <= 0.5 or inter.size.y <= 0.5:
				continue
			if _sanctioned_pair(items, a, b):
				continue
			_bad.append("%s: %s over %s" % [where, _nm(a), _nm(b)])


func _hold_unit(family: String, state: String, u: BattleUnit) -> void:
	var panel: Control = u.get("_plate_panel")
	if panel == null or not is_instance_valid(panel):
		return
	_hold(family, "%s %s (%s)" % [u.unit_name, "companion" if u.is_companion else ("hero" if u.is_hero else "enemy"),
		state], panel.get_global_rect(), panel.get_children())


func _hold_field(s: Node, state: String) -> void:
	for u in (s.get("heroes") as Array) + (s.get("companions") as Array) + (s.get("enemies") as Array):
		_hold_unit("battle plates", state, u)
	# AND NO PLATE RUNS INTO THE NEXT: each side's stack, plate by plate, clear of one another and on the screen.
	for side in [["the heroes' stack", (s.get("heroes") as Array) + (s.get("companions") as Array)],
			["the warband's stack", s.get("enemies")]]:
		_configs["plate stacks"] = int(_configs.get("plate stacks", 0)) + 1
		var rects: Array = []
		for u2 in side[1]:
			var pp: Control = (u2 as BattleUnit).get("_plate_panel")
			if pp != null and is_instance_valid(pp):
				rects.append([String((u2 as BattleUnit).unit_name), pp.get_global_rect()])
		for i in rects.size():
			if not Rect2(0, 0, 1280, 720).encloses(rects[i][1]):
				_bad.append("%s (%s): %s's plate %s runs off the screen" % [side[0], state, rects[i][0], rects[i][1]])
			for j in range(i + 1, rects.size()):
				var inter := (rects[i][1] as Rect2).intersection(rects[j][1])
				if inter.size.x > 0.5 and inter.size.y > 0.5:
					_bad.append("%s (%s): %s's plate over %s's" % [side[0], state, rects[i][0], rects[j][0]])


const HERO_SETS := [["berserker", "pyromancer", "holy", "beastmaster"],
	["warden", "cryomancer", "inquisitor", "sharpshooter"],
	["swordmaster", "arcanist", "occultist", "mystic"],
	["spine:momentum", "spine:channel", "spine:sanctity", "spine:field_kit"]]


func _s6_nothing_over_anything() -> void:
	print("\n§6 — nothing on a plate or a card is drawn over anything else on it")
	await _s6_the_walker_bites()
	_fresh_meta()
	# EVERY ENEMY KIND, six to a warband (`ENEMY_LAYOUTS`' largest).
	var raw: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var kinds: Array = raw.keys()
	var groups: Array = []
	for k in range(0, kinds.size(), 6):
		groups.append(kinds.slice(k, k + 6))
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	for gi in maxi(groups.size(), HERO_SETS.size()):
		_new_run(HERO_SETS[gi % HERO_SETS.size()])
		var enc := {"type": "fight", "theme": "Warband", "enemies": groups[gi % groups.size()]}
		var s: Node = await _enter(enc)
		ok(s != null, "§6: the premise — the battle for heroes %s against %s" % [HERO_SETS[gi % HERO_SETS.size()], enc["enemies"]])
		if s == null:
			continue
		await _walk_field(s)
		await _clear(s)
	OS.set_environment("DOD_ENEMIES_OFF", "")
	await _walk_cards()
	await _walk_bargains()
	print("    configurations held: %s" % [_configs])
	for fam in _most:
		print("    %s — the most on one: %s (%d drawn rects); the emptiest: %s (%d)" % [fam,
			_most[fam][0], _most[fam][1], _least[fam][0], _least[fam][1]])
	print("    values read inside their own bars: %d" % _sanctioned)
	for bline in _bad.slice(0, 400):
		print("    BREACH %s" % bline)
	ok(_bad.is_empty(), "§6: %d drawn rects over another or past their container — %s" % [_bad.size(), _bad.slice(0, 5)])
	var total := 0
	for f in _configs:
		total += int(_configs[f])
	# FLOORS, NOT EQUALITIES (DX §1): four warbands of five states over every kind and lineage, seven maps of four
	# cards, every modifier, the strip and the bar in each field.
	ok(int(_configs.get("battle plates", 0)) >= 150 and int(_configs.get("map cards", 0)) >= 28
			and int(_configs.get("bargain cards", 0)) >= 18 and int(_configs.get("turn strip", 0)) >= 4
			and int(_configs.get("crest strip", 0)) >= 4 and int(_configs.get("skill-check bar", 0)) >= 4
			and int(_configs.get("plate stacks", 0)) >= 40
			and _sanctioned > 100,
		"§6: the walk held too little to mean anything — %s, %d values in bars" % [_configs, _sanctioned])
	print("    %d configurations in all" % total)


# THE WALKER's OWN TWO ARMS, on a plate built here for it: a value laid on its bar and held by it top and
# bottom is passed, and the same value moved half its line down — over the bar's foot — is caught. A walk
# that passed everything, or caught the sanctioned case, would say nothing about the game's plates.
func _s6_the_walker_bites() -> void:
	var holder := Panel.new()
	root.add_child(holder)
	holder.position = Vector2(10, 10)
	holder.size = Vector2(200, 60)
	var track := ColorRect.new()
	track.color = Color(0.1, 0.1, 0.1)
	holder.add_child(track)
	track.position = Vector2(10, 10)
	track.size = Vector2(126, 12)
	var fill := ColorRect.new()
	fill.color = Color(0.3, 0.8, 0.3)
	holder.add_child(fill)
	fill.position = Vector2(11, 11)
	fill.size = Vector2(60, 10)
	var value := Label.new()
	value.add_theme_font_size_override("font_size", 8)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	holder.add_child(value)
	value.position = Vector2(10, 10)
	value.size = Vector2(126, 12)
	value.text = "175/175"
	await Gate.frames(self, 1)
	var bad0 := _bad.size()
	var sanc0 := _sanctioned
	_hold("the walker's own", "a value inside its bar", holder.get_global_rect(), holder.get_children())
	var passed := _bad.size() == bad0 and _sanctioned > sanc0
	value.position = Vector2(10, 16)
	await Gate.frames(self, 1)
	_hold("the walker's own", "the value half a line down", holder.get_global_rect(), holder.get_children())
	var caught := _bad.size() > bad0
	_bad.resize(bad0)
	ok(passed and caught, "§6: the walker passed the sanctioned value %s and caught the moved one %s" % [passed, caught])
	holder.queue_free()
	await Gate.frames(self, 1)
	_configs.erase("the walker's own")
	_most.erase("the walker's own")
	_least.erase("the walker's own")


# One field, in every state that changes a plate's contents.
func _walk_field(s: Node) -> void:
	var enemies: Array = s.get("enemies")
	var heroes: Array = s.get("heroes")
	# 1 — AS SPAWNED, each enemy declaring (the intent line present).
	for e in enemies:
		var eu: BattleUnit = e
		if eu.abilities.size() > 0:
			eu.intent = {"ability": eu.abilities[0], "target": heroes[0], "turns": 1, "support": false,
				"message": "", "logs": [], "category": "strike"}
			s.call("_refresh_intent_plate", eu)
	await Gate.frames(self, 2)
	_hold_field(s, "as spawned, declaring")
	# THE TURN STRIP: each slot holds its portrait, its stripe and its glyph apart.
	s.call("_rebuild_turn_bar")
	await Gate.frames(self, 2)
	var slot_i := 0
	for slot in (s.get("turn_bar") as Node).get_children():
		if slot is Control and not slot.is_queued_for_deletion():
			_hold("turn strip", "turn slot %d" % slot_i, (slot as Control).get_global_rect(), slot.get_children())
			slot_i += 1
	# 2 — THE LONGEST VALUES: four-digit health, full bars, the deepest uncapped meters, and the longest
	# declared action the warband can name.
	var longest_ab: Ability = null
	for e2 in enemies:
		for ab in (e2 as BattleUnit).abilities:
			if longest_ab == null or String(ab.display_name).length() > String(longest_ab.display_name).length():
				longest_ab = ab
	for u in heroes + (s.get("companions") as Array) + enemies:
		var bu: BattleUnit = u
		bu.max_hp = 9999
		bu.hp = 9999
		if bu.max_resource > 0:
			bu.resource = bu.max_resource
		if bu.second_resource_name != "":
			bu.second_resource = 150 if bu.second_max < 0 else bu.second_max
		bu.pressure = maxi(bu.stability - 1, 0)
		bu.refresh_bars()
		if not bu.is_hero and longest_ab != null:
			bu.intent = {"ability": longest_ab, "target": heroes[0], "turns": 1, "support": false,
				"message": "", "logs": [], "category": "strike"}
			s.call("_refresh_intent_plate", bu)
	await Gate.frames(self, 2)
	_hold_field(s, "the longest values")
	# 3 — THE CHIP ROW FULL: every status the game draws, and three rune chips at the row's end.
	var ids: Array = (s.get("STATUS_INFO") as Dictionary).keys()
	for u2 in heroes + (s.get("companions") as Array) + enemies:
		for sid in ids.slice(0, 14):
			s.call("_apply_status", u2, String(sid), 3, 0, 0, enemies[0])
		if (u2 as BattleUnit).is_hero:
			(u2 as BattleUnit).set_rune_chips([{"name": "IH one", "tag": "✦", "tip": "a", "paying": true},
				{"name": "IH two", "tag": "✦", "tip": "b", "paying": false},
				{"name": "IH three", "tag": "✦", "tip": "c", "paying": true}])
	await Gate.frames(self, 2)
	_hold_field(s, "the chip row full")
	# THE CREST STRIP above the heroes' first plate, three chips wide, clear of that plate.
	s.call("_draw_crest_strip", [{"name": "IH crest", "tag": "✦", "tip": "x", "paying": true},
		{"name": "IH crest 2", "tag": "✦", "tip": "y", "paying": false}, {"name": "IH crest 3", "tag": "✦", "tip": "z", "paying": true}])
	await Gate.frames(self, 1)
	var strip: Node = s.get("_crest_strip")
	if strip != null:
		var p0: Control = (heroes[0] as BattleUnit).get("_plate_panel")
		var room := Rect2(Vector2(0, 0), Vector2(1280, p0.get_global_rect().position.y))
		_hold("crest strip", "the crest strip", room, strip.get_children())
	# 4 — THE INTENT LINE ABSENT, the row emptied.
	for u3 in heroes + (s.get("companions") as Array) + enemies:
		(u3 as BattleUnit).statuses = []
		(u3 as BattleUnit).set_rune_chips([])
		(u3 as BattleUnit)._refresh_chips()
		if not (u3 as BattleUnit).is_hero:
			(u3 as BattleUnit).set_intent_plate("", Color.WHITE)
	await Gate.frames(self, 2)
	_hold_field(s, "no intent, the row empty")
	# THE SKILL-CHECK BAR, at its longest result line.
	var sc: Control = s.get("sc_root")
	if sc != null:
		sc.visible = true
		(s.get("sc_result") as Label).text = "CHAIN BROKEN 3 / 4  —  PERFECT"
		await Gate.frames(self, 1)
		var bg: Control = sc.get_child(0)
		_hold("skill-check bar", "the skill-check bar", bg.get_global_rect(), sc.get_children().filter(func(k): return k != bg))
		sc.visible = false
	# 5 — A HERO FALLEN (his plate dimmed, his row cleared).
	var h0: BattleUnit = heroes[0]
	h0.hp = 0
	h0._die()
	await Gate.frames(self, 2)
	_hold_field(s, "a hero fallen")


# THE MAP's CARDS, in every state that changes one: each lineage and the spines, a pick owed of every
# kind, runes held unworn, upgrades held, the Kit at its widest, a core rune sitting out, a hero
# unawakened, and a card fallen to no health.
func _hold_cards(mp: Node, state: String) -> void:
	for i in _run.party.size():
		var panel: Control = null
		var parts: Array = []
		for c in mp.get_children():
			if c is Control and c.has_meta("hero_card") and int(c.get_meta("hero_card")) == i \
					and not c.is_queued_for_deletion():
				if c is Panel and (c as Panel).size == Vector2(300, 152):
					panel = c
				else:
					parts.append(c)
		if panel == null:
			_bad.append("card %d (%s): no card panel tagged" % [i, state])
			continue
		_hold("map cards", "card %d %s (%s)" % [i, Run_nameplate(i), state], panel.get_global_rect(), parts)


func Run_nameplate(i: int) -> String:
	return String(_run.nameplate(_run.party[i]))


func _walk_cards() -> void:
	for hs in HERO_SETS:
		_new_run(hs)
		var mp: Node = await _to_map()
		_hold_cards(mp, "as dealt")
	# THE STATES, on the designer's own party.
	_new_run(["berserker", "pyromancer", "inquisitor", "sharpshooter"])
	_run.zone_bosses_cleared = 3
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		m["upgrades"] = [{"ability": String(_run.opening_kit_names(m)[0]), "id": "up_damage"},
			{"ability": String(_run.opening_kit_names(m)[0]), "id": "up_cooldown"},
			{"ability": String(_run.opening_kit_names(m)[1]), "id": "up_damage"}]
		var pool: Array = Classes.draft_pool(String(m["key"])).filter(func(n): return not _run.opening_kit_names(m).has(n))
		m["bm_abilities"] = pool.slice(0, 10)
		m["bm_equipped"] = pool.slice(0, 6)
		var held_r: Array = []
		for id in Runes.ids():
			var r: Dictionary = Runes.build(String(id))
			if Runes.is_engine_rune(String(id)) or Runes.is_party_rune(r) or Runes.is_retired(String(id)) \
					or String(r.get("scope", "")) != "class:" + String(m["key"]):
				continue
			r["equipped"] = held_r.size() < 3
			held_r.append(r)
			if held_r.size() >= 3 + int(_run.HERO_HOLD_CAP):
				break
		m["runes"] = held_r
	var mp2: Node = await _to_map()
	_hold_cards(mp2, "upgrades, a full Kit, runes held")
	for kind in ["rune_picks_owed", "bm_picks_owed", "up_picks_owed", "draft_picks_owed"]:
		for i2 in _run.party.size():
			_run.party[i2][kind] = 1
	var mp3: Node = await _to_map()
	_hold_cards(mp3, "every pick owed")
	for i3 in _run.party.size():
		for kind2 in ["rune_picks_owed", "bm_picks_owed", "up_picks_owed", "draft_picks_owed"]:
			_run.party[i3][kind2] = 0
	# A core rune sitting out (the Rune of the Beastmaster beside the Rune of the Sharpshooter) and a hero
	# fallen to nothing; a hero unawakened.
	_run.party[3]["engines"] = [_rune(Runes.engine_rune_id(Classes.engine_of_spec("beastmaster")), true),
		_rune(Runes.engine_rune_id(Classes.engine_of_spec("sharpshooter")), true)]
	_run.party[0]["hp"] = 0
	_run.party[1]["spec"] = ""
	_run.party[1]["awakened"] = false
	_run.party[1]["engines"] = []
	var mp4: Node = await _to_map()
	_hold_cards(mp4, "a core rune sitting out, a hero down, a hero unawakened")
	_run.zone_bosses_cleared = 0


# THE BARGAIN's CARDS: every modifier's words, three to a screen.
func _walk_bargains() -> void:
	_new_run()
	_run.encounter = {"type": "elite", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
	var reward: Variant = null
	var probe: Array = _run.encounter_offer()
	if not probe.is_empty():
		reward = (probe[0] as Dictionary).get("reward")
	change_scene_to_file("res://scenes/offer.tscn")
	await Gate.frames(self, 4)
	var os: Node = current_scene
	ok(os != null and os.has_method("_draw_option") and reward != null,
		"§6: the premise — the bargain screen, and a reward to show")
	if os == null or not os.has_method("_draw_option") or reward == null:
		return
	var mods: Array = (_run.MODIFIERS as Dictionary).keys()
	for k in range(0, mods.size(), 3):
		var offer: Array = []
		for mid in mods.slice(k, k + 3):
			offer.append({"modifier": String(mid), "reward": reward})
		os.set("offer", offer)
		os.call("_draw_screen")
		await Gate.frames(self, 2)
		for ci in offer.size():
			var panel: Control = null
			var parts: Array = []
			for c in os.get_children():
				if c is Control and c.has_meta("bargain_card") and int(c.get_meta("bargain_card")) == ci \
						and not c.is_queued_for_deletion():
					if c is Panel and (c as Panel).size == Vector2(350, 420):
						panel = c
					else:
						parts.append(c)
			if panel != null:
				_hold("bargain cards", "bargain %s" % offer[ci]["modifier"], panel.get_global_rect(), parts)


# ── §9 — THE PLAYER'S FILES ──────────────────────────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files and the player's own readout folder are as this gate found them")
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
	_clear_harness_readout()
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
	ok(_listing(PLAYER_READOUT_DIR) == _player_readout, "§9: the player's readout folder moved under this gate")
