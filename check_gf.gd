# BATCH GF — A QUIT PUTS THE PARTY BACK WHERE IT WAS STANDING, NEVER PAST IT.
#
#   §1  THE BARGAIN — quit on an elite's offer: Continue opens that offer again,
#       the same three terms, and the party is not one step further on
#   §2  MID-FIGHT — quit inside a plain fight, through the battle's own Exit to
#       Main Menu and again the way a closed window quits: Continue opens the
#       same fight, from its opening, twice, and nothing is paid
#   §3  AFTER THE BARGAIN — quit inside the elite's fight: Continue opens the
#       battle, not the offer, with the bargain that was taken armed
#   §4  THE INVERSE — each resumed fight is won and its card quit: Continue opens
#       the map past it, the victory was paid once, and the post-fight offers
#       (the draft, the rune cache) are still owed
#   §5  THE ZONE BOSS — quit inside it: the boss again, not a closed board; a
#       save standing on a beaten one: the next zone, once, the award still owed
#   §6  THE EVENT AND THE BOUGHT MERCHANT — the same event, and not after it is
#       answered; the merchant visited once
#   §7  A v12 SAVE — it carries no record, so it lands where a v12 build landed
#       it; and one standing on a zone boss descends instead of stranding
#
# ── HOW A QUIT IS MADE ───────────────────────────────────────────────────────
# Nothing in the game hooks a window close, so what a quit leaves is exactly
# what the last save wrote. The gate takes the scene away WITHOUT saving —
# through the battle's own ☰ where there is one, and by leaving for the main
# menu where there is not — then CLOBBERS every field the resume reads, so a
# value that comes back can only have come off the disk, and presses the main
# menu's real Continue button. The one-off drive that found the defect killed
# the process instead; the save it read is the same file.
#
# ── THE ROAD IS CONSTRUCTED; THE STEP IS PRESSED ─────────────────────────────
# Each section walks to the node it needs through `Run.advance`, which moves the
# party exactly as the map's own press does, minus the fights before it — they
# are not under test. The step onto the node under test is a press on its own
# lattice button, so the save written there is the save the game writes.
#
# ── THE PLAYER'S FILES ───────────────────────────────────────────────────────
# A `--script` process writes `Run`'s harness path (FI) and `Profile` is pointed
# at a scratch file below. NO ARM KILLS A ZONE BOSS: `Relics.unlock_random`'s
# path is still a const, and FY §5b's deferred hazard gains no fifth reacher
# here. §5's beaten boss is the state `_resolve_boss` leaves, built by hand.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gf.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SPECS := ["berserker", "cryomancer", "inquisitor", "sharpshooter"]
const SCRATCH_PROFILE := "user://gf_profile.json"
const FRAME_CAP := 30000

var _g := Gate.new()
var _run: Node = null
var _player_save := PackedByteArray()
var _had_player_save := false


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH GF — A QUIT PUTS THE PARTY BACK WHERE IT WAS STANDING")
	_run = root.get_node("/root/Run")
	_had_player_save = FileAccess.file_exists(_run.SAVE_PATH)
	if _had_player_save:
		_player_save = FileAccess.get_file_as_bytes(_run.SAVE_PATH)
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	Profile.save_path = SCRATCH_PROFILE
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	OS.set_environment("DOD_AUTOPLAY", "1")
	Engine.max_fps = 0

	await _s1_to_s4_the_elite()
	await _s2_to_s4_the_plain_fight()
	await _s5_the_zone_boss()
	await _s6_the_event_and_the_merchant()
	await _s7_a_v12_save()

	OS.set_environment("DOD_AUTOPLAY", "")
	Engine.time_scale = 1.0
	# The player's own file, both arms unconditional (FH §2's rule: a guarded
	# arm makes the count depend on whether the machine has a run in progress).
	ok(FileAccess.file_exists(_run.SAVE_PATH) == _had_player_save,
		"the player's run save is not as this gate found it")
	ok(not _had_player_save or FileAccess.get_file_as_bytes(_run.SAVE_PATH) == _player_save,
		"the player's run save came back changed")
	_g.report(self)


# ── PRIMITIVES, AFTER check_fh's ─────────────────────────────────────────────

# `Engine.time_scale` is re-asserted every frame: a Break's hitstop puts it back
# to the literal 1.0 (FH's measured trap).
func _frames(n: int) -> void:
	for _i in n:
		Engine.time_scale = 100.0
		await process_frame


func _buttons(n: Node, out: Array, visible_only := true) -> void:
	if n.is_queued_for_deletion():
		return
	if n is Button:
		if not visible_only or (n as Button).visible:
			out.append(n)
	for c in n.get_children():
		_buttons(c, out, visible_only)


func _press(n: Node, prefixes: Array) -> String:
	var btns: Array = []
	_buttons(n, btns)
	for p in prefixes:
		for b in btns:
			var t := String((b as Button).text)
			if t.begins_with(String(p)) and not (b as Button).disabled:
				(b as Button).emit_signal("pressed")
				return t
	return ""


func _overlay(screen: Node, z: int) -> Node:
	var found: Node = null
	for c in screen.get_children():
		if c is Control and (c as Control).z_index == z \
				and not c.is_queued_for_deletion():
			found = c
	return found


# The screen is named by the FILE it was loaded from rather than by its root
# node's name: the main menu's root is called "Screen", which a name match
# cannot tell apart from anything — the first run of this gate read every
# resume as "not the main menu" for exactly that reason.
func _scene_name() -> String:
	if current_scene == null:
		return "<none>"
	var base := String(current_scene.scene_file_path).get_file().get_basename()
	var named := {"main_menu": "MainMenu", "map": "Map", "offer": "Offer",
		"event": "Event", "shop": "Shop", "blacksmith": "Blacksmith",
		"party": "Party", "draft": "Draft", "spec_choice": "SpecChoice"}
	if named.has(base):
		return String(named[base])
	if base == "bat" + "tle":
		return "Battle"
	return base if base != "" else String(current_scene.name)


# The lattice buttons that can be pressed right now, as node indices into the
# next slot — read off each button's own connection, so a node the map drew no
# button for is a node no player can press.
func _open_nodes(s: Node) -> Array:
	var out: Array = []
	var btns: Array = []
	_buttons(s, btns, false)
	for b in btns:
		if (b as Button).disabled:
			continue
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_on_node_pressed":
				var args: Array = cb.get_bound_arguments()
				if not args.is_empty():
					out.append(int(args[0]))
	out.sort()
	return out


func _press_node(s: Node, j: int) -> bool:
	var btns: Array = []
	_buttons(s, btns, false)
	for b in btns:
		if (b as Button).disabled:
			continue
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_on_node_pressed" and cb.get_bound_arguments() == [j]:
				(b as Button).emit_signal("pressed")
				return true
	return false


func _disk() -> Dictionary:
	var p: String = _run.save_path
	if not FileAccess.file_exists(p):
		return {}
	var f := FileAccess.open(p, FileAccess.READ)
	var d: Variant = f.get_var(true)
	f.close()
	return d if d is Dictionary else {}


func _write_disk(d: Dictionary) -> void:
	var f := FileAccess.open(String(_run.save_path), FileAccess.WRITE)
	f.store_var(d, true)
	f.close()


# EVERY READ OF A SCREEN TOLERATES THE WRONG SCREEN. A resume that lands
# somewhere else is exactly what this gate exists to report, and a read that
# threw there would bury the report under a SCRIPT ERROR.
func _ids(offer: Variant) -> Array:
	var out: Array = []
	if not (offer is Array):
		return out
	for o in offer:
		out.append(String((o as Dictionary).get("modifier", "")))
	return out


func _hp() -> Array:
	var out: Array = []
	for m in _run.party:
		out.append(int(m.get("hp", 0)))
	return out


# Sorted, because what is asserted is WHICH warband, not the order the spawn
# laid it out in.
func _kinds(s: Node) -> Array:
	var out: Array = []
	var es: Variant = s.get("enemies") if s != null else null
	if not (es is Array):
		return out
	for e in es:
		out.append(String(e.get("enemy_kind")))
	out.sort()
	return out


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


func _sorted(a: Array) -> Array:
	var out: Array = a.duplicate()
	out.sort()
	return out


func _won(s: Node) -> bool:
	if not _is_battle(s):
		return false
	for h in s.get("heroes"):
		if not bool(h.get("dead")):
			return true
	return false


func _menu_button(s: Node) -> MenuButton:
	var stack: Array = [s]
	while not stack.is_empty():
		var cur: Node = stack.pop_back()
		if cur is MenuButton and String((cur as MenuButton).text) == "☰":
			return cur
		for k in cur.get_children():
			stack.append(k)
	return null


# ── THE RUN AND THE ROAD ─────────────────────────────────────────────────────

# A fresh run on its map, seeded per section so each section's board is the
# same board every run whatever the fights before it rolled.
func _fresh_map(section_seed: int) -> Node:
	seed(section_seed)
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["tree"] = Talents.generate_tree(SPECS[i], _run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	change_scene_to_file("res://scenes/map.tscn")
	await _frames(4)
	return current_scene


func _dist(s: int, j: int, want: String) -> int:
	var mp: Array = _run.map
	var frontier: Array = [[s, j, 0]]
	var seen := {}
	while not frontier.is_empty():
		var cur: Array = frontier.pop_front()
		var ss := int(cur[0])
		var jj := int(cur[1])
		var key := "%d,%d" % [ss, jj]
		if seen.has(key):
			continue
		seen[key] = true
		var nd: Dictionary = mp[ss][jj]
		if String(nd.get("type", "")) == want:
			return int(cur[2])
		if ss + 1 < mp.size():
			for t in nd.get("next", []):
				frontier.append([ss + 1, int(t), int(cur[2]) + 1])
	return 999


# Advance until a node of type `want` is one step away, then redraw the map and
# return the index of that node in the next slot (or -1).
func _walk_to(want: String) -> int:
	for _guard in 20:
		var reach: Array = _run.reachable()
		if reach.is_empty():
			return -1
		var nxt: int = int(_run.slot_idx) + 1
		for j in reach:
			if String(_run.map[nxt][int(j)]["type"]) == want:
				change_scene_to_file("res://scenes/map.tscn")
				await _frames(4)
				return int(j)
		var best := int(reach[0])
		var bd := 999
		for j2 in reach:
			var d := _dist(nxt, int(j2), want)
			if d < bd:
				bd = d
				best = int(j2)
		if bd >= 999:
			return -1
		_run.advance(best)
	return -1


# ── A QUIT, AND THE RESUME ───────────────────────────────────────────────────

# THE ☰ IS PRESSED ONLY ON THE BATTLE. The map carries a ☰ too, and its item 2
# is Quit to Desktop — pressed there it would end this gate mid-run, which is a
# truncated gate printing no verdict (FR §5a's fault), on exactly the resume
# that landed wrong.
func _quit(via_menu: bool) -> void:
	var mb: MenuButton = _menu_button(current_scene) \
		if via_menu and _scene_name() == "Battle" else null
	if mb != null:
		mb.get_popup().emit_signal("id_pressed", 2)
	else:
		change_scene_to_file("res://scenes/main_menu.tscn")
	await _frames(6)


func _clobber() -> void:
	_run.encounter = {"type": "fight", "enemies": ["gf_clobbered"], "theme": "clobbered"}
	_run.pending_modifier = "gf_clobbered"
	_run.pending_reward = {"kind": "gf_clobbered"}
	_run.pending_event = "gf_clobbered"
	_run.pending_shop = false
	_run.slot_idx = -1
	_run.node_idx = 0
	_run.zone_idx = 0


func _continue() -> String:
	if _scene_name() != "MainMenu":
		return "not the main menu (%s)" % _scene_name()
	var btns: Array = []
	_buttons(current_scene, btns)
	var cont: Button = null
	for b in btns:
		if String((b as Button).text) == "Continue":
			cont = b
	if cont == null or cont.disabled:
		return "no Continue button"
	_clobber()
	cont.emit_signal("pressed")
	for _i in 60:
		await _frames(1)
		if _scene_name() != "MainMenu":
			break
	await _frames(6)
	return _scene_name()


func _fight_to_end(s: Node) -> void:
	if not _is_battle(s):
		return
	var guard := 0
	while not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	await _frames(6)


func _fight_a_little(s: Node) -> void:
	if not _is_battle(s):
		return
	var guard := 0
	while int(s.get("_turns_taken")) < 2 and not bool(s.get("battle_over")) \
			and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1


# ── §1 / §3 / §4 — THE ELITE ─────────────────────────────────────────────────

func _s1_to_s4_the_elite() -> void:
	print("\n§1 — quit on an elite's bargain")
	var s: Node = await _fresh_map(20260913)
	var j := await _walk_to("elite")
	ok(j >= 0, "§1: no elite is reachable on the seeded board")
	if j < 0:
		return
	var at: Array = [int(_run.slot_idx) + 1, j]
	var hp_at_step := _hp()
	ok(_press_node(current_scene, j), "§1: the elite drew no pressable button")
	await _frames(6)
	ok(_scene_name() == "Offer", "§1: stepping onto the elite opened %s, not its bargain" % _scene_name())
	var shown: Array = _ids(current_scene.get("offer"))
	var warband: Array = _sorted(Array(_run.encounter.get("enemies", [])))
	var d := _disk()
	var denc: Dictionary = d.get("encounter", {})
	ok(int(d.get("version", 0)) >= 13, "§1: the save is v%d — the record needs v13 or later" % int(d.get("version", 0)))
	ok(String(denc.get("type", "")) == "elite" and _sorted(Array(denc.get("enemies", []))) == warband,
		"§1: the save written as the party stepped on does not carry the elite (%s)" % str(denc))
	ok(_ids(denc.get("offer", [])) == shown and shown.size() == 3,
		"§1: the save does not carry the three bargains the screen drew (%s vs %s)" % [str(_ids(denc.get("offer", []))), str(shown)])
	ok(not denc.has("bargain"), "§1: a bargain is recorded as taken before one was")

	await _quit(false)
	var landed := await _continue()
	# THE PAIR: where it must land, and the landing the defect produced.
	ok(landed == "Offer", "§1: Continue opened %s, not the elite's bargain" % landed)
	ok(landed != "Map", "§1: Continue opened the MAP — the party walked past the elite, which is the defect")
	ok(_ids(current_scene.get("offer")) == shown,
		"§1: the bargains RE-ROLLED on resume (%s, were %s) — a quit is a reroll of the terms" % [str(_ids(current_scene.get("offer"))), str(shown)])
	ok(_sorted(Array(_run.encounter.get("enemies", []))) == warband,
		"§1: the resumed encounter is not the warband stepped onto")
	ok([int(_run.slot_idx), int(_run.node_idx)] == at,
		"§1: the party is at %s, not %s" % [str([_run.slot_idx, _run.node_idx]), str(at)])
	ok(_hp() == hp_at_step, "§1: the party's health is not what it was at the step")

	# ── §3 — take a bargain, quit inside the fight ──
	print("\n§3 — quit inside the elite's fight, after its bargain")
	var offer_v: Variant = current_scene.get("offer") if current_scene != null else null
	var offer: Array = offer_v if offer_v is Array else []
	# Any bargain but one that buys a merchant: §6 drives that on its own, and
	# here a merchant would stand between the elite's card and the map.
	var pick := 0
	for i in offer.size():
		if String(((offer[i] as Dictionary).get("reward", {}) as Dictionary).get("kind", "")) != "shop":
			pick = i
			break
	var took := ""
	var took_reward := {}
	if pick < offer.size():
		took = String((offer[pick] as Dictionary).get("modifier", ""))
		took_reward = ((offer[pick] as Dictionary).get("reward", {}) as Dictionary).duplicate()
	var takes: Array = []
	var ob: Array = []
	_buttons(current_scene, ob)
	for b in ob:
		if String((b as Button).text) == "Take this bargain":
			takes.append(b)
	ok(takes.size() == offer.size() and pick < takes.size(),
		"§3: the offer drew %d bargain buttons for %d bargains" % [takes.size(), offer.size()])
	if pick < takes.size():
		(takes[pick] as Button).emit_signal("pressed")
	await _frames(6)
	ok(_scene_name() == "Battle", "§3: taking the bargain opened %s, not the fight" % _scene_name())
	var d3 := _disk()
	var enc3: Dictionary = d3.get("encounter", {})
	ok(String((enc3.get("bargain", {}) as Dictionary).get("modifier", "")) == took,
		"§3: the save does not record the bargain taken (%s)" % str(enc3.get("bargain", "<absent>")))
	ok(String(d3.get("pending_modifier", "")) == took,
		"§3: the save does not carry the armed modifier (%s)" % str(d3.get("pending_modifier", "<absent>")))
	await _fight_a_little(current_scene)
	ok(_is_battle(current_scene) and not bool(current_scene.get("battle_over")), "§3: the fight ended before the quit could be made inside it")
	await _quit(true)
	landed = await _continue()
	ok(landed == "Battle", "§3: Continue opened %s, not the elite's fight" % landed)
	ok(landed != "Offer", "§3: Continue opened the OFFER again — the terms of one fight could be chosen twice")
	ok(String(_run.pending_modifier) == took, "§3: the resumed fight is not under the bargain taken ('%s', took '%s')" % [String(_run.pending_modifier), took])
	ok(Dictionary(_run.pending_reward) == took_reward, "§3: the resumed fight does not owe the bargain's reward")
	ok(_kinds(current_scene) == warband, "§3: the resumed fight is not the elite's warband (%s)" % str(_kinds(current_scene)))
	ok(_hp() == hp_at_step, "§3: the fight did not restart from the party's health at the step")

	# ── §4 — win it, quit on its card ──
	print("\n§4 — win the resumed elite, quit on its card")
	await _fight_to_end(current_scene)
	ok(_won(current_scene), "§4: the resumed elite was lost — the inverse arms below have nothing to stand on")
	var gold_won: int = int(_run.gold)
	var wins_won: int = int(_run.combat_wins)
	var d4 := _disk()
	ok(bool((d4.get("encounter", {}) as Dictionary).get("resolved", false)),
		"§4: the victory's save does not mark the elite resolved")
	var draft_owed := 0
	var rune_owed := 0
	for m in d4.get("party", []):
		draft_owed += int(m.get("draft_picks_owed", 0))
		rune_owed += int(m.get("rune_picks_owed", 0))
	ok(draft_owed > 0, "§4: the elite's victory saved no draft owed")
	await _quit(false)
	landed = await _continue()
	ok(landed == "Map", "§4: Continue after a WON elite opened %s" % landed)
	ok(landed != "Battle" and landed != "Offer", "§4: Continue re-entered a fight that was WON — it would pay twice")
	ok(int(_run.gold) == gold_won, "§4: the gold is %d, not the %d the victory left — paid twice or lost" % [int(_run.gold), gold_won])
	ok(int(_run.combat_wins) == wins_won, "§4: the win count is %d, not %d" % [int(_run.combat_wins), wins_won])
	ok(_overlay(current_scene, 62) != null, "§4: the draft the elite awarded did not reopen on the map")
	var owed_after := 0
	for m2 in _run.party:
		owed_after += int(m2.get("rune_picks_owed", 0))
	ok(owed_after == rune_owed, "§4: the rune cache owed changed across the quit (%d, was %d)" % [owed_after, rune_owed])
	ok([int(_run.slot_idx), int(_run.node_idx)] == at, "§4: the party moved across the quit")


# ── §2 / §4 — A PLAIN FIGHT ──────────────────────────────────────────────────

func _s2_to_s4_the_plain_fight() -> void:
	print("\n§2 — quit inside a plain fight, twice")
	var s: Node = await _fresh_map(20260914)
	var j := await _walk_to("fight")
	ok(j >= 0, "§2: no fight is reachable on the seeded board")
	if j < 0:
		return
	var at: Array = [int(_run.slot_idx) + 1, j]
	var hp_at_step := _hp()
	var gold_at_step: int = int(_run.gold)
	ok(_press_node(current_scene, j), "§2: the fight drew no pressable button")
	await _frames(6)
	ok(_scene_name() == "Battle", "§2: stepping onto the fight opened %s" % _scene_name())
	var warband: Array = _sorted(Array(_run.encounter.get("enemies", [])))
	for attempt in ["the battle's own Exit to Main Menu", "a closed window"]:
		await _fight_a_little(current_scene)
		ok(_is_battle(current_scene) and not bool(current_scene.get("battle_over")), "§2: the fight ended before a quit could be made inside it (%s)" % attempt)
		await _quit(attempt.begins_with("the battle"))
		var landed := await _continue()
		ok(landed == "Battle", "§2: after quitting through %s, Continue opened %s, not the fight" % [attempt, landed])
		ok(landed != "Map", "§2: after quitting through %s, Continue opened the MAP — the fight was walked past" % attempt)
		ok(_kinds(current_scene) == warband, "§2: the resumed fight is not the warband stepped onto (%s)" % attempt)
		ok(_hp() == hp_at_step, "§2: the fight did not restart from the party's health at the step (%s)" % attempt)
		ok(int(_run.gold) == gold_at_step, "§2: a fight not yet won paid gold (%s)" % attempt)
		ok([int(_run.slot_idx), int(_run.node_idx)] == at, "§2: the party moved (%s)" % attempt)

	print("\n§4 — win the resumed fight, quit on its card")
	await _fight_to_end(current_scene)
	ok(_won(current_scene), "§4: the resumed fight was lost — the inverse arms below have nothing to stand on")
	var gold_won: int = int(_run.gold)
	var wins_won: int = int(_run.combat_wins)
	ok(gold_won > gold_at_step, "§4: the won fight paid no gold, so 'paid once' cannot be read")
	await _quit(false)
	var landed2 := await _continue()
	ok(landed2 == "Map", "§4: Continue after a WON fight opened %s" % landed2)
	ok(landed2 != "Battle", "§4: Continue re-entered a WON fight")
	ok(int(_run.gold) == gold_won and int(_run.combat_wins) == wins_won,
		"§4: gold %d / wins %d after the quit, %d / %d before it" % [int(_run.gold), int(_run.combat_wins), gold_won, wins_won])
	ok(not bool(_run.encounter_pending()), "§4: a won fight still reads as pending")
	ok(not _open_nodes(current_scene).is_empty(), "§4: the map past the won fight has nothing to press")


# ── §5 — THE ZONE BOSS ───────────────────────────────────────────────────────

func _s5_the_zone_boss() -> void:
	print("\n§5 — quit inside a zone boss, and on a beaten one")
	var s: Node = await _fresh_map(20260915)
	var j := await _walk_to("boss")
	ok(j >= 0, "§5: the zone boss is not reachable on the seeded board")
	if j < 0:
		return
	ok(_press_node(current_scene, j), "§5: the zone boss drew no pressable button")
	await _frames(6)
	ok(_scene_name() == "Battle", "§5: stepping onto the boss opened %s" % _scene_name())
	var warband: Array = _sorted(Array(_run.encounter.get("enemies", [])))
	await _fight_a_little(current_scene)
	await _quit(true)
	var landed := await _continue()
	ok(landed == "Battle", "§5: Continue after quitting a zone boss opened %s, not the boss" % landed)
	ok(not (landed == "Map" and _open_nodes(current_scene).is_empty()),
		"§5: Continue left the party on a board with nothing to press — the strand the defect produced")
	ok(_kinds(current_scene) == warband, "§5: the resumed boss fight is not the warband stepped onto")
	ok(int(_run.slot_idx) == int(_run.BOSS_SLOT) and int(_run.zone_idx) == 0,
		"§5: the party is not standing on zone 1's boss")

	# THE BEATEN BOSS, BUILT BY HAND: what `_resolve_boss` leaves on disk — the
	# encounter resolved, the ladder moved, an ability pick owed — without the
	# kill that would reach `Relics.unlock_random`.
	await _quit(true)
	_run.encounter["resolved"] = true
	_run.note_zone_boss_cleared()
	ok(bool(_run.award_ability_pick(_run.party[0])), "§5: no ability pick could be awarded to build the beaten boss")
	_run.save_run()
	var owed: int = int(_run.party[0].get("bm_picks_owed", 0))
	var cleared: int = int(_run.zone_bosses_cleared)
	landed = await _continue()
	ok(landed == "Map", "§5: Continue on a beaten zone boss opened %s" % landed)
	ok(int(_run.zone_idx) == 1 and int(_run.slot_idx) == -1,
		"§5: a beaten zone boss did not DESCEND (zone %d, slot %d)" % [int(_run.zone_idx) + 1, int(_run.slot_idx)])
	ok(not _open_nodes(current_scene).is_empty(), "§5: the next zone's first column has nothing to press")
	ok(int(_run.party[0].get("bm_picks_owed", 0)) == owed, "§5: the boss's ability pick did not survive the descent")
	ok(int(_run.zone_bosses_cleared) == cleared, "§5: the slot ladder moved across the descent")
	ok(int(_disk().get("zone_idx", -1)) == 1, "§5: the descent was not saved — a second quit would descend again")
	await _quit(false)
	landed = await _continue()
	ok(landed == "Map" and int(_run.zone_idx) == 1 and int(_run.slot_idx) == -1,
		"§5: a SECOND quit moved the party again (zone %d, slot %d, %s) — a zone skipped" % [int(_run.zone_idx) + 1, int(_run.slot_idx), landed])


# ── §6 — THE EVENT, AND THE MERCHANT THE BARGAIN BOUGHT ──────────────────────

func _s6_the_event_and_the_merchant() -> void:
	print("\n§6 — quit on an event, and before a bought merchant")
	var s: Node = await _fresh_map(20260916)
	var j := await _walk_to("event")
	ok(j >= 0, "§6: no event is reachable on the seeded board")
	if j < 0:
		return
	ok(_press_node(current_scene, j), "§6: the event drew no pressable button")
	await _frames(6)
	ok(_scene_name() == "Event", "§6: stepping onto the event opened %s" % _scene_name())
	var drawn := String(_run.pending_event)
	ok(drawn != "" and String(_disk().get("pending_event", "")) == drawn,
		"§6: the save does not carry the event drawn ('%s')" % str(_disk().get("pending_event", "<absent>")))
	await _quit(false)
	var landed := await _continue()
	ok(landed == "Event", "§6: Continue opened %s, not the event" % landed)
	ok(landed != "Map", "§6: Continue opened the MAP — the event was walked past")
	ok(String(_run.pending_event) == drawn, "§6: the resumed event is '%s', not the '%s' drawn" % [String(_run.pending_event), drawn])
	# Answer it; after that it is not offered again.
	ok(_press(current_scene, [""]) != "", "§6: the event drew no choice to press")
	await _frames(4)
	ok(_press(current_scene, ["Continue"]) != "", "§6: the event's outcome drew no Continue")
	await _frames(6)
	await _quit(false)
	landed = await _continue()
	ok(landed == "Map", "§6: Continue after the event was ANSWERED opened %s" % landed)

	# THE BOUGHT MERCHANT: the state a victory card leaves when the bargain paid
	# "a merchant follows the fight" and the player quit before Continue.
	_run.pending_shop = true
	_run.save_run()
	await _quit(false)
	landed = await _continue()
	ok(landed == "Shop", "§6: Continue with a bought merchant owed opened %s" % landed)
	ok(not bool(_disk().get("pending_shop", true)), "§6: the merchant was not marked visited on disk")
	await _quit(false)
	landed = await _continue()
	ok(landed == "Map", "§6: the bought merchant was offered TWICE (%s)" % landed)


# ── §7 — A v12 SAVE ──────────────────────────────────────────────────────────

func _s7_a_v12_save() -> void:
	print("\n§7 — a v12 save: no record, and a zone boss that does not strand")
	var s: Node = await _fresh_map(20260917)
	var j := await _walk_to("elite")
	ok(j >= 0, "§7: no elite is reachable on the seeded board")
	if j < 0:
		return
	ok(_press_node(current_scene, j), "§7: the elite drew no pressable button")
	await _frames(6)
	var v13 := _disk()
	await _quit(false)
	# THE CONTROL ARM FIRST: the same save at v13 resumes onto the bargain.
	var landed := await _continue()
	ok(landed == "Offer", "§7: control — the v13 save resumed onto %s, not the offer" % landed)
	await _quit(false)
	var v12 := v13.duplicate(true)
	for k in ["encounter", "pending_modifier", "pending_reward", "pending_event"]:
		v12.erase(k)
	v12["version"] = 12
	_write_disk(v12)
	landed = await _continue()
	# THE TOLERANT DEFAULT, SAID: a v12 save carries no record of the step, so it
	# lands where a v12 build landed it — past the elite. Nothing in the file
	# can recover the encounter, and GF records that rather than guessing.
	ok(landed == "Map", "§7: a v12 save at an elite's step resumed onto %s — the tolerant default moved" % landed)
	ok(not bool(_run.encounter_pending()), "§7: a v12 save invented a pending encounter")

	# And one standing on a zone boss — where a v12 build strands the party.
	await _quit(false)
	var sb: Node = await _fresh_map(20260918)
	var jb := await _walk_to("boss")
	ok(jb >= 0, "§7: the zone boss is not reachable on the seeded board")
	if jb < 0:
		return
	ok(_press_node(current_scene, jb), "§7: the zone boss drew no pressable button")
	await _frames(6)
	var boss12 := _disk()
	await _quit(true)
	for k2 in ["encounter", "pending_modifier", "pending_reward", "pending_event"]:
		boss12.erase(k2)
	boss12["version"] = 12
	_write_disk(boss12)
	landed = await _continue()
	ok(landed == "Map" and int(_run.zone_idx) == 1 and int(_run.slot_idx) == -1,
		"§7: a v12 save on a zone boss resumed onto %s at zone %d slot %d — not the next zone" % [landed, int(_run.zone_idx) + 1, int(_run.slot_idx)])
	ok(not _open_nodes(current_scene).is_empty(), "§7: a v12 save on a zone boss left a board with nothing to press")
