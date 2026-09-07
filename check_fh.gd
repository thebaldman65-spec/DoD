# BATCH FH — THE RUN IS DRIVEN END TO END, THROUGH THE REAL SCREENS.
#
#   §1  A COMPLETE RUN — 49 encounters, three zones and the end boss, walked by
#       pressing the map's own node handler, fighting the real battle scene and
#       pressing the real end-card buttons
#   §2  THE DRAFT — an offer at each slot count, a swap, a bench, the tag line
#   §3  THE RUNE OFFER — the Peddler, an elite cache ANSWERED A NODE LATER, and
#       what a boss actually awards
#   §4  A RUNE'S CONDITION ON AND OFF BY BENCHING, with the hero sheet's state
#   §5  THE POUCH — a purchase, a slot grant, a full-stack refusal, a sell
#   §6  THE SKILL CHECK — all four cases, on the real bar
#   §7  A ZONE BOSS AWARD AT AN EXHAUSTED POOL — EA's fallback chain, seen paying
#   §8  EVERY BUTTON ON EVERY SCREEN THE RUN OPENED, PRESSED
#
# **WHY THIS GATE EXISTS AND WHY IT IS NOT A SIM ARM.** The last four
# player-visible defects were all found by a person playing and none by a
# battery: retired runes in an elite cache, a duplicate equipped rune, a Peddler
# offering an ability draft, and 604 dead buttons. Every one of them is
# invisible to `run_sim`, because RunSim walks `Run` directly and never loads a
# screen — `map_screen._on_node_pressed` opens with `if Run.sim_run: return`,
# which is the line that makes the sim and the player two different programs.
# **SO THIS DRIVE IS NOT A SIM: `sim_run` IS FALSE, the scenes are the shipped
# scenes, and every step is a press.**
#
# ── THE THREE THINGS THAT MAKE A LIVE DRIVE POSSIBLE AT ALL ─────────────────
#
# 1. **`Engine.time_scale` MUST BE RE-ASSERTED EVERY FRAME, NOT SET ONCE.**
#    `battle._break_impact()` sets `Engine.time_scale = 0.05` for a hitstop and
#    then puts it back to the LITERAL `1.0` rather than to what it was. The
#    first Break of the run therefore cancels the drive's own time scale and
#    everything after it runs at wall-clock pace: **measured at 561 s for ten
#    battles set once, 15 s for the same ten re-asserted.** Reported in §8 as an
#    observation — it is invisible in play, where the scale is always 1.0.
#
# 2. **THE PLAYER'S RUN SAVE IS BACKED UP AND PUT BACK.** `Run.SAVE_PATH` is a
#    `const`, so it cannot be redirected the way `Profile.save_path` can, and a
#    live drive writes it on every step. `check_ct`'s pattern: read it, drive,
#    restore it byte for byte — or delete it if there was none.
#
# 3. **THE DRIVE OWNS NO SCENE.** It is a `--script` SceneTree, so
#    `change_scene_to_file` — which is what every real button calls — lands the
#    next screen in `root` as `current_scene` and frees the last one, with
#    nothing of this gate's in the way.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fh.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The party the drive plays. Four different classes so the draft, the runes and
# the skill check all have a spec that can reach them: the Sharpshooter is in
# it because his four-press sequence is the one bar nothing else in the project
# exercises.
const SPECS := ["berserker", "cryomancer", "inquisitor", "sharpshooter"]

const SCRATCH_PROFILE := "user://fh_profile.json"

# The drive's own bound. A run is 49 encounters and each one is a map press and
# a screen, so the step budget is generous — but it IS a budget, because a
# screen that never advances is a softlock and a gate that waits forever
# reports nothing at all (CLAUDE.md's hang mode 1).
const MAX_STEPS := 400
const BATTLE_FRAME_CAP := 20000

var _g := Gate.new()

# What the drive saw, printed at the end of §1 and asserted against.
var _seen := {}
var _visited: Array = []
var _wipe := false
var _end_boss_beaten := false
var _end_boss_screen_seen := false
var _dead_buttons: Array = []
var _observations: Array = []
var _obs_count := {}

var _run: Node = null
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


# **ONE FAULT, ONE LINE, WITH A COUNT.** A defect that repeats on every slot
# of a 49-slot run would otherwise print fifty times and bury the ones that
# happened once.
func note(what: String) -> void:
	if _observations.has(what):
		_obs_count[what] = int(_obs_count.get(what, 1)) + 1
		return
	_observations.append(what)


func _initialize() -> void:
	await process_frame
	seed(20260907)
	print("BATCH FH — THE RUN, DRIVEN END TO END THROUGH THE REAL SCREENS")
	_run = root.get_node("/root/Run")
	_take_the_save()
	Profile.save_path = SCRATCH_PROFILE
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")

	await _s1_the_whole_run()
	await _s2_the_draft()
	await _s3_the_rune_offer()
	await _s4_bench_a_condition()
	await _s5_the_pouch()
	await _s6_the_exhausted_pool()
	await _s7_the_skill_check()
	await _s8_the_end_boss()
	await _s9_every_button()
	await _s9b_the_numbers()
	_s10_the_observations()

	_give_the_save_back()
	_g.report(self)


# ── THE PLAYER'S SAVE ────────────────────────────────────────────────────────
#
# `check_ct` §2's pattern, and it is not optional here: this gate drives a real
# non-sim run, so `Run.save_run()` writes `user://run_save.bin` on every single
# step and `_resolve_boss` CLEARS it when the end boss dies. A gate that ate the
# designer's run in progress would be a worse defect than anything it could find.
#
# **AN IN-MEMORY BACKUP IS NOT ENOUGH AND THIS GATE PROVED IT ON ITS AUTHOR.**
# The first draft held the bytes in a member and put them back at the end of
# `_initialize`. A `SCRIPT ERROR` in a later section — three of them while this
# file was being written — aborts the coroutine, so the restore never ran, and
# by then §8's end boss had already called `Run.clear_save()`. **The run save
# was destroyed and every subsequent run reported `none — nothing to protect`,
# which is a clean-looking line for a file that is gone.**
#
# So the backup is a FILE, written before the first byte moves, and the gate is
# SELF-HEALING: a backup on disk with no live save means a previous run died
# holding it, and it is put back at the top of this one. The backup is removed
# only after a successful restore, so it can never resurrect a save the player
# themselves deleted between two clean runs.
const SAVE_BACKUP := "user://fh_run_save_backup.bin"


func _take_the_save() -> void:
	var p: String = _run.SAVE_PATH
	if not FileAccess.file_exists(p) and FileAccess.file_exists(SAVE_BACKUP):
		# A previous run of this gate died holding it.
		var rescued := FileAccess.get_file_as_bytes(SAVE_BACKUP)
		var wf := FileAccess.open(p, FileAccess.WRITE)
		wf.store_buffer(rescued)
		wf = null
		print("  RECOVERED the player's run save (%d B) from a previous run of this gate"
			% rescued.size())
	_had_save = FileAccess.file_exists(p)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(p)
		var bf := FileAccess.open(SAVE_BACKUP, FileAccess.WRITE)
		bf.store_buffer(_save_backup)
		bf = null
	print("  the player's run save: %s" % (
		"present, %d B — backed up to %s" % [_save_backup.size(), SAVE_BACKUP]
		if _had_save else "none — nothing to protect"))


func _give_the_save_back() -> void:
	var p: String = _run.SAVE_PATH
	if _had_save:
		var f := FileAccess.open(p, FileAccess.WRITE)
		f.store_buffer(_save_backup)
		f = null
	elif FileAccess.file_exists(p):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(p))
	# **BOTH ARMS RUN WHETHER OR NOT THERE WAS A SAVE.** Guarding the second
	# one behind `if _had_save` made this gate's CHECK COUNT depend on whether
	# the machine happened to have a run in progress — 160 on a machine with
	# none and 161 on one with a save — which is a baseline row that reds for a
	# reason that has nothing to do with the tree. Measured, not predicted.
	ok(FileAccess.file_exists(p) == _had_save,
		"the player's run save is NOT as this gate found it")
	ok(not _had_save or FileAccess.get_file_as_bytes(p) == _save_backup,
		"the player's run save came back changed")
	# Only now — the on-disk backup exists precisely to survive the path above
	# not being reached.
	if FileAccess.file_exists(SAVE_BACKUP):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_BACKUP))


# ── THE DRIVE'S PRIMITIVES ───────────────────────────────────────────────────

# Every visible Button under a node, in tree order. A press is
# `emit_signal("pressed")` — the same signal the mouse emits — rather than a
# call to the handler, because a button whose signal was never connected is
# exactly the defect this gate is looking for and calling the handler by hand
# would hide it.
# **A `queue_free`d BUTTON IS STILL IN THE TREE FOR A FRAME.** Every one of
# these screens rebuilds itself by freeing all its children and drawing again,
# so a walk that does not skip the doomed ones presses the button belonging to
# the screen that has already gone — which reads as a live press and does
# nothing.
func _buttons(n: Node, out: Array, visible_only := true) -> void:
	if n.is_queued_for_deletion():
		return
	if n is Button:
		if not visible_only or (n as Button).visible:
			out.append(n)
	for c in n.get_children():
		_buttons(c, out, visible_only)


func _labels(n: Node) -> Array:
	var btns: Array = []
	_buttons(n, btns)
	var out: Array = []
	for b in btns:
		out.append(String((b as Button).text))
	return out


# Every Label's text under a node. The tag line, the slot ledger and the
# refusal toast are all Labels rather than Buttons, and a drive that only reads
# buttons cannot see any of them.
func _texts(n: Node, out: Array) -> void:
	if n is Label:
		out.append(String((n as Label).text))
	for c in n.get_children():
		_texts(c, out)


func _has_text(n: Node, needle: String) -> bool:
	var t: Array = []
	_texts(n, t)
	for x in t:
		if String(x).contains(needle):
			return true
	return false


# Press one specific Button by its text. **THE STAGED MARK IS PART OF THE
# TEXT**: the draft re-draws its whole column on every stage and marks the
# chosen card `"▸ Gut Rip"`, so an exact-match press works once and then reads
# as a missing button — which is how the first pass of this gate reported
# forty-two dead buttons that were all its own.
func _press_exact(n: Node, want: String) -> bool:
	var btns: Array = []
	_buttons(n, btns)
	for b in btns:
		var t := String((b as Button).text)
		if (t == want or t == "▸ " + want) and not (b as Button).disabled:
			(b as Button).emit_signal("pressed")
			return true
	return false


# Press the first visible button whose text starts with one of `prefixes`.
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


# A row is a Button and a Label side by side. Find the row whose Label names
# `needle` and press its Button, which is how every list on these screens is
# actually built: the control says what it DOES ("Bench", "Carry") and the text
# beside it says what it does it TO.
func _press_row(n: Node, needle: String, want: String) -> bool:
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_back()
		if cur.is_queued_for_deletion():
			continue
		var kids: Array = cur.get_children()
		var named := false
		var btn: Button = null
		for k in kids:
			if k is Label and String((k as Label).text).contains(needle):
				named = true
			elif k is Button and String((k as Button).text) == want \
					and not (k as Button).disabled:
				btn = k
		if named and btn != null:
			btn.emit_signal("pressed")
			return true
		for k2 in kids:
			stack.append(k2)
	return false


# The overlay a map-screen panel opens. **READ THE OVERLAY, NEVER THE SCREEN**
# — FE §2d's rule, paid for once already: the map is covered in buttons of its
# own and a walk of the whole tree reads map-node buttons as pick offers. A
# `queue_free`d overlay is still IN the tree for a frame, so the doomed ones
# are skipped rather than counted.
func _overlay(screen: Node, z: int) -> Node:
	var found: Node = null
	for c in screen.get_children():
		if c is Control and (c as Control).z_index == z \
				and not c.is_queued_for_deletion():
			found = c
	return found


# Godot uniquifies a name that collides with a sibling already in `root`, so a
# second Battle arrives as `@Battle@42`. The screen is identified by the name
# it was AUTHORED with, not by the one the tree gave it.
func _scene_name() -> String:
	if current_scene == null:
		return "<none>"
	var raw := String(current_scene.name)
	for known in ["Map", "Battle", "Shop", "Blacksmith", "Event", "Offer",
			"Party", "MainMenu", "Draft", "SpecChoice"]:
		if raw.contains(String(known)):
			return String(known)
	return raw


func _hp_line() -> String:
	var o := ""
	for m in _run.party:
		o += "%d/%d " % [int(m.get("hp", 0)), int(m.get("max_hp", 0))]
	return o


func _bump(key: String, n := 1) -> void:
	_seen[key] = int(_seen.get(key, 0)) + n


# ── §1 — THE WHOLE RUN ───────────────────────────────────────────────────────
#
# Three zones of sixteen and the end boss, walked slot by slot. The route is
# the FIRST reachable node every time, which is a real route a player could
# take rather than a search for an easy one: nothing here re-rolls a node,
# skips a fight, heals between slots or looks at what is coming.
func _s1_the_whole_run() -> void:
	print("\n§1 — a complete run, driven through the real screens")
	_run.sim_run = false
	# **THE RUN IS PLAYED ON WANDERER, RUNG 1 OF 3, AND THAT IS A PLAYER'S
	# CHOICE RATHER THAN A THUMB ON THE SCALE.** `Run.difficulty` defaults to
	# `wanderer`; the string `"standard"` the gate fixture passes is a LEGACY id
	# that resolves to `warden`, rung 2 at x1.00 — so a drive that copied the
	# fixture would be playing a harder run than the one the menu opens on. The
	# autoplay bot is already a weaker player than a person (it rolls a flat
	# `good` on every skill check and never drinks a potion in a fight), so
	# rung 1 is the honest place to ask whether a run completes at all.
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["tree"] = Talents.generate_tree(SPECS[i], _run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	ok(_run.total_slots() == 49,
		"§1: the run is %d slots, not the 49 the framing card promises"
			% _run.total_slots())

	OS.set_environment("DOD_AUTOPLAY", "1")
	change_scene_to_file("res://scenes/map.tscn")
	var t0 := Time.get_ticks_msec()
	var steps := 0
	var stalled := ""
	for _step in MAX_STEPS:
		Engine.time_scale = 100.0
		await process_frame
		await process_frame
		if current_scene == null:
			continue
		var s: Node = current_scene
		var nm := _scene_name()
		if nm == "MainMenu":
			stalled = "the run bounced to the MAIN MENU at slot %d" % _run.slot_idx
			break
		if nm == "Map":
			if not _run.active:
				break
			var moved := await _step_the_map(s)
			if moved == "":
				stalled = "nothing pressable on the MAP at slot %d" % _run.slot_idx
				break
		elif nm == "Battle":
			var out := await _fight(s)
			if out == "":
				stalled = "the battle ended with no pressable end card at slot %d" \
					% _run.slot_idx
				break
		else:
			var left := await _leave(s, nm)
			if left == "":
				stalled = "no way off the %s screen at slot %d — a SOFTLOCK" % [
					nm, _run.slot_idx]
				_dead_buttons.append("%s: %s" % [nm, _labels(s)])
				break
			_bump("screen:" + nm)
		steps += 1
		if _end_boss_beaten or _wipe:
			break
	Engine.time_scale = 1.0

	print("    %d steps, %d ms" % [steps, Time.get_ticks_msec() - t0])
	print("    slots walked: %d — %s" % [_visited.size(), ", ".join(_visited)])
	var keys: Array = _seen.keys()
	keys.sort()
	for k in keys:
		print("      %-24s %d" % [k, int(_seen[k])])
	# **WHAT IS ASSERTED HERE IS THE DRIVE, NOT THE BALANCE.** Whether the
	# autoplay bot survives to the end boss is a tuning fact that moves with
	# every magnitude the designer touches, and a gate that reds on it would be
	# a gate that reds on ordinary design work. What must always hold is that
	# every screen the run opens can be answered and that the road goes on:
	# a stall, a screen with no way off, or a button that does nothing is this
	# batch's business and a wipe in zone 3 is the designer's.
	ok(stalled == "", "§1: %s" % stalled)
	ok(_visited.size() >= 16,
		"§1: the drive walked only %d encounters — a zone is 16, so the road stopped"
			% _visited.size())
	ok(int(_seen.get("type:elite", 0)) > 0,
		"§1: the route walked no ELITE — the rune cache and the draft are both unreached")
	ok(int(_seen.get("type:boss", 0)) > 0, "§1: no zone boss was fought")
	ok(int(_seen.get("battles", 0)) > 0, "§1: no battle was fought")
	print("    OUTCOME: %s after %d of 49 encounters, %d zone bosses down." % [
		"the party WIPED" if _wipe else ("the END BOSS fell" if _end_boss_beaten
			else "the drive stopped"),
		_visited.size(), int(_seen.get("type:boss", 0))])
	print("    (autoplay is the BOT's policy — it rolls a flat `good` on every skill")
	print("     check and never drinks in a fight — so this is a bot datum, not a")
	print("     balance verdict. The end boss's own screen is driven in §8.)")


# One press on the map. Everything the map can put in front of the player
# before it will let them step is answered here, in the order the screen itself
# chains them: the draft screen first, then the pick overlays on the cards,
# then the item offers, then the node.
func _step_the_map(s: Node) -> String:
	# The party draft opens itself on `_ready`. It is a z=62 overlay.
	var draft: Node = _overlay(s, 62)
	if draft != null:
		await _answer_the_draft(s, draft)
		return "draft"
	# A pick owed on a card — ability, upgrade or rune — is a z=60 overlay the
	# card's own CHOOSE button opens. Answer them before stepping.
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		if int(m.get("bm_picks_owed", 0)) > 0 \
				or int(m.get("up_picks_owed", 0)) > 0 \
				or int(m.get("rune_picks_owed", 0)) > 0:
			if await _answer_a_pick(s, idx):
				return "pick"
	# **A PLAYER DRINKS.** The autoplay bot does not — `battle.gd` gates its
	# item use on `RunSim.active`, which is false in a live run — so a drive
	# that only pressed nodes would be playing the game with the pouch welded
	# shut, and would read as a balance datum when it is a bot datum. The
	# potion is used through the footer's own button and the target picker's
	# own button, which is also how §5's purchase path gets spent.
	if await _drink_if_hurt(s):
		return "potion"
	var reach: Array = _run.reachable()
	if reach.is_empty():
		return ""
	var j := int(reach[0])
	var ty := _type_of(j)
	_visited.append("%d:%s" % [_run.slot_idx + 1, ty])
	_bump("type:" + ty)
	s.call("_on_node_pressed", j)
	return ty


# The footer's pouch button, then the target picker's hero button. Both are
# real presses on real buttons; nothing here calls `_apply_item` by hand.
func _drink_if_hurt(s: Node) -> bool:
	var worst := -1
	var worst_frac := 1.0
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		var mx: float = float(max(1, int(m.get("max_hp", 1))))
		var f: float = float(int(m.get("hp", 0))) / mx
		if f < worst_frac:
			worst_frac = f
			worst = i
	if worst < 0 or worst_frac > 0.55:
		return false
	if int(_run.items.get("health", 0)) < 1:
		return false
	var btns: Array = []
	_buttons(s, btns)
	var hit: Button = null
	for b in btns:
		if String((b as Button).text).begins_with("Health  x"):
			hit = b
			break
	if hit == null:
		note("a hero was at %d%% with %d health potions and the footer drew no button"
			% [int(worst_frac * 100), int(_run.items.get("health", 0))])
		return false
	var hp_before: int = int(_run.party[worst].get("hp", 0))
	hit.emit_signal("pressed")
	await process_frame
	var picker: Node = _overlay(s, 70)
	if picker == null:
		note("the health potion opened NO target picker on the map")
		return false
	var pbtns: Array = []
	_buttons(picker, pbtns)
	var took := false
	for pb in pbtns:
		var t := String((pb as Button).text)
		if t == "Cancel":
			continue
		if t.begins_with(String(_run.party[worst].get("spec", ""))) \
				or t.contains("%d/" % hp_before):
			pb.emit_signal("pressed")
			took = true
			break
	if not took and pbtns.size() > 1:
		(pbtns[0] as Button).emit_signal("pressed")
		took = true
	await process_frame
	await process_frame
	var still: Node = _overlay(s, 70)
	if still != null:
		still.queue_free()
		await process_frame
	if took and int(_run.party[worst].get("hp", 0)) > hp_before:
		_bump("potions drunk on the map")
		return true
	if took:
		note("a health potion was applied and hero %d's HP did not move (%d)"
			% [worst, hp_before])
	return took


func _type_of(j: int) -> String:
	var nxt: int = int(_run.slot_idx) + 1
	var mp: Array = _run.map
	if nxt >= mp.size():
		return "?"
	var nodes: Array = mp[nxt]
	if j >= nodes.size():
		return "?"
	return String((nodes[j] as Dictionary).get("type", "?"))


# One battle, fought by the real scene on autoplay, ended by pressing the real
# end card. **`battle_over` IS THE SIGNAL, NOT THE CARD** — the card is built a
# frame or two later, and a driver that watched only for buttons would press
# whatever the battle UI already had on screen.
func _fight(s: Node) -> String:
	var guard := 0
	while not bool(s.get("battle_over")) and guard < BATTLE_FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	if guard >= BATTLE_FRAME_CAP:
		note("a battle never set `battle_over` in %d frames — hung at slot %d"
			% [BATTLE_FRAME_CAP, _run.slot_idx])
		return ""
	for _i in 6:
		await process_frame
	_bump("battles")
	# The run summary — a wipe or the completion — is its own card, and it is
	# the end of the drive either way.
	var labels := _labels(s)
	# **THE RUN SUMMARY IS HOW A RUN ENDS, BOTH WAYS.** `_show_run_summary` is
	# reached from the wipe branch and from the end boss's own, and its card is
	# the one that carries "Copy summary" and "New Run". Which of the two it is
	# is read off the card's own title, not guessed from the slot number.
	var is_summary := false
	for l in labels:
		if String(l).begins_with("New Run") or String(l).begins_with("Copy summary"):
			is_summary = true
	if is_summary:
		var complete := _has_text(s, "THE HOLLOW CROWN") or _has_text(s, "RUN COMPLETE") \
				or _has_text(s, "complete")
		_end_boss_beaten = complete
		_wipe = not complete
		print("    the run ENDED on the %s card after %d encounters (%s)" % [
			"COMPLETION" if complete else "WIPE", _visited.size(), _hp_line()])
		return "end"
	var pressed := _press(s, ["Continue", "Descend into", "Walk on", "Onward"])
	if pressed == "":
		_dead_buttons.append("Battle end card: %s" % [labels])
	return pressed


# ── EVERY OTHER SCREEN A RUN CAN PUT IN FRONT OF THE PLAYER ─────────────────
#
# **THE BARGAIN SCREEN HAS NO DECLINE AND THAT IS DELIBERATE** (AO §2: an event,
# not a toll booth). Three "Take this bargain" buttons and nothing else, so a
# driver looking for a way OUT finds none and reads the screen as a softlock —
# which is what the first pass of this gate did. The drive takes the LEAST
# SEVERE of the three, which is the cautious real choice the design promises is
# always survivable, and it presses the button rather than calling `_accept`.
func _leave(s: Node, nm: String) -> String:
	match nm:
		"Offer":
			return _take_a_bargain(s)
		"Event":
			var choice := _press(s, [""])   # the first ENABLED choice
			if choice == "":
				return ""
			_bump("event choices")
			await process_frame
			await process_frame
			var on := _press(s, ["Continue"])
			return choice if on == "" else on
		"Shop":
			await _shop(s)
			return _press(s, ["Leave the Shop"])
		"Blacksmith":
			return _press(s, ["Leave the forge", "Walk on"])
	return _press(s, ["Leave", "Walk on", "Onward", "Continue", "Depart"])


func _take_a_bargain(s: Node) -> String:
	var offer: Array = s.get("offer")
	var btns: Array = []
	_buttons(s, btns)
	var takes: Array = []
	for b in btns:
		if String((b as Button).text) == "Take this bargain":
			takes.append(b)
	if takes.is_empty() or offer.size() != takes.size():
		note("the bargain screen drew %d buttons for %d offers" % [
			takes.size(), offer.size()])
		if takes.is_empty():
			return ""
	var best := 0
	var best_sev := 99
	for i in takes.size():
		var id := String((offer[i] as Dictionary).get("modifier", ""))
		var sev: int = int(_run.modifier_severity(id))
		if sev < best_sev:
			best_sev = sev
			best = i
	_bump("bargains taken")
	_bump("bargain severity %d" % best_sev)
	(takes[best] as Button).emit_signal("pressed")
	return "Take this bargain"


# The Peddler, shopped the way a player shops: buy what is affordable, top
# down, until the gold or the shelf runs out. **THE REFUSALS ARE THE POINT** —
# a full stack and a full pouch are two different answers (CT §3) and both are
# reached here by simply buying until they are.
func _shop(s: Node) -> void:
	_bump("shops visited")
	for _pass in 8:
		var btns: Array = []
		_buttons(s, btns)
		var bought := false
		for b in btns:
			var t := String((b as Button).text)
			if (b as Button).disabled:
				continue
			if t.begins_with("Buy — ") or t.contains("g   (have "):
				var gold_before: int = int(_run.gold)
				(b as Button).emit_signal("pressed")
				await process_frame
				await process_frame
				if int(_run.gold) < gold_before:
					_bump("shop purchases")
					bought = true
				break
		if not bought:
			break


# ── THE DRAFT SCREEN, ANSWERED ───────────────────────────────────────────────
#
# One screen, one column per hero owed a card. A column is DECIDED when the
# player has chosen a card and, at the cap, named what it replaces — or
# declined. The confirm button is disabled until every column is decided, which
# is what makes "the screen resolves as one action" a property of one predicate.
func _answer_the_draft(s: Node, overlay: Node) -> void:
	_bump("draft screens")
	var cols: Array = s.call("_draft_columns")
	var cap: int = int(_run.ability_slot_cap())
	for idx in cols:
		var i := int(idx)
		var m: Dictionary = _run.party[i]
		# THE OFFER IS READ THE WAY THE COLUMN READS IT — `draft_candidates` is
		# a QUEUE of offers and the column draws its head.
		var queue: Array = m.get("draft_candidates", [])
		var offer: Array = queue[0] if not queue.is_empty() else []
		_bump("draft offers")
		_bump("draft offers at cap %d" % cap)
		if offer.is_empty():
			note("a draft column opened for hero %d with NO cards in the offer" % i)
			s.call("_stage_draft_decline", i)
			continue
		var card := String(offer[0])
		# **THE OVERLAY IS RE-FETCHED, NEVER HELD.** Every stage rebuilds the
		# whole screen, so a reference taken before the last press is a freed
		# node by the time this one lands.
		var live_ov: Node = _overlay(s, 62)
		if live_ov == null:
			live_ov = overlay
		# **THE CARD IS PRESSED, NOT STAGED.** `_stage_draft` is what the button
		# calls; calling it directly would pass a card whose button was never
		# drawn, which is the exact defect a live drive exists to catch.
		if not _press_exact(live_ov, card):
			note("the draft drew no pressable button for `%s` on hero %d" % [card, i])
			_dead_buttons.append("draft column %d: no button for %s" % [i, card])
			s.call("_stage_draft_decline", i)
			continue
		_bump("draft cards pressed")
		# EK §3 — THE TAG LINE, READ OFF THE SCREEN.
		var tag_line: String = Classes.card_tag_line(card)
		var tag_ov: Node = _overlay(s, 62)
		if tag_ov == null:
			tag_ov = live_ov
		if tag_line == "":
			note("the draft card `%s` has no tag line to render" % card)
		elif not _has_text(tag_ov, tag_line):
			note("the draft card `%s` did NOT render its tag line `%s`" % [card, tag_line])
			_bump("cards missing their tag line")
		else:
			_bump("cards showing a tag line")
		await process_frame
		# At the cap the card button opens the DROP step instead of staging, so
		# the column is re-drawn and the bench must be named on the new one.
		if bool(_run.ability_slots_full(m)):
			_bump("draft swaps (at the cap)")
			# THE DROP STEP IS TWO PRESSES, NOT ONE. The card button only
			# STAGES; the re-drawn column then carries "Choose what <card>
			# replaces", and THAT opens the z=64 overlay whose buttons read
			# "Bench <name>". The droppable list is `equipped_ability_names` —
			# the PROTECTED core is not in it, which is the half a drive reading
			# the whole loadout would get wrong.
			await process_frame
			var col_ov: Node = _overlay(s, 62)
			if col_ov != null:
				_press_exact(col_ov, "Choose what %s replaces" % card)
			await process_frame
			var drop_ov: Node = _overlay(s, 64)
			var benched := ""
			if drop_ov != null:
				var droppable: Array = _run.equipped_ability_names(m)
				for nm2 in droppable:
					if _press_exact(drop_ov, "Bench %s" % String(nm2)):
						benched = String(nm2)
						break
			if benched == "":
				var loadout: Array = _run.loadout_ability_names(m)
				if loadout.is_empty():
					note("hero %d is at the cap with an EMPTY loadout" % i)
				else:
					s.call("_stage_draft_drop", i, String(loadout[loadout.size() - 1]))
					note("hero %d: the drop step drew no pressable Bench button" % i)
					_dead_buttons.append("drop overlay hero %d" % i)
			else:
				_bump("benches pressed")
			await process_frame
	await process_frame
	var again: Node = _overlay(s, 62)
	var target: Node = again if again != null else overlay
	var hit := _press(target, ["Confirm the draft"])
	if hit == "":
		var undecided: Array = []
		for idx2 in cols:
			if not bool(s.call("_draft_decided", int(idx2))):
				undecided.append(int(idx2))
		note("the draft's confirm would not press; undecided columns %s" % [undecided])
		s.call("_close_party_draft")
	else:
		_bump("draft confirms")
	await process_frame
	await process_frame


# ── A PICK OWED ON A HERO CARD ───────────────────────────────────────────────
#
# The ability pick, the upgrade pick and the rune pick all come through the
# same z=60 overlay `_open_pick_overlay` builds, and all three are answered by
# pressing one of its buttons. **EVERY BUTTON IT DREW MUST BE LIVE** — the
# fault this exists to catch is a button that does nothing when pressed, which
# no assertion on the pouch can see.
func _answer_a_pick(s: Node, idx: int) -> bool:
	var m: Dictionary = _run.party[idx]
	var kind := ""
	if int(m.get("rune_picks_owed", 0)) > 0:
		kind = "rune"
	elif int(m.get("bm_picks_owed", 0)) > 0:
		kind = "ability"
	elif int(m.get("up_picks_owed", 0)) > 0:
		kind = "upgrade"
	s.call("_open_pick_overlay", idx)
	await process_frame
	var ov: Node = _overlay(s, 60)
	if ov == null:
		note("a %s pick was owed on hero %d and NO overlay opened — the pick is STRANDED"
			% [kind, idx])
		# Drop the pick so the drive can go on; the observation is the finding.
		m["%s_picks_owed" % ("bm" if kind == "ability" else
			("up" if kind == "upgrade" else "rune"))] = 0
		return true
	var btns: Array = []
	_buttons(ov, btns)
	var live: Array = []
	for b in btns:
		var t := String((b as Button).text)
		if t == "Not yet" or (b as Button).disabled:
			continue
		live.append(b)
	if live.is_empty():
		note("the %s overlay for hero %d drew NO pick buttons — the pick is STRANDED"
			% [kind, idx])
		_dead_buttons.append("%s overlay hero %d: %s" % [kind, idx, _labels(ov)])
		m["%s_picks_owed" % ("bm" if kind == "ability" else
			("up" if kind == "upgrade" else "rune"))] = 0
		ov.queue_free()
		await process_frame
		return true
	# A rune pick can put an already-owned rune on the card — CD's defect. Say
	# so rather than pressing past it.
	if kind == "rune":
		var owned: Array = []
		for r in m.get("runes", []):
			owned.append(String((r as Dictionary).get("name", "")))
		for b2 in live:
			var t2 := String((b2 as Button).text)
			for o in owned:
				if t2.contains(String(o)):
					note("the rune cache offered hero %d `%s`, which they already wear"
						% [idx, o])
	_bump("picks answered: " + kind)
	(live[0] as Button).emit_signal("pressed")
	await process_frame
	await process_frame
	var still: Node = _overlay(s, 60)
	if still != null:
		still.queue_free()
		await process_frame
	return true


# ── §2 .. §7 ARE WRITTEN BELOW THE RUN, BECAUSE THEY STAND ON ITS STATE ──────

# A LIVE RUN AND ITS MAP, BUILT THE WAY §1 BUILDS ONE. §1 ends with the run
# over — a wipe and a completion both call `Run.clear_save()` — so every
# section below stands one up for itself rather than inheriting a corpse.
func _fresh_map(bosses := 0) -> Node:
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["tree"] = Talents.generate_tree(SPECS[i], _run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	_run.zone_bosses_cleared = bosses
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 4:
		await process_frame
	return current_scene


# ── §2 — THE DRAFT ──────────────────────────────────────────────────────────
#
# §1 drove the draft as it fell — 28 cards pressed across seven screens — but
# the SLOT COUNT it saw is whatever the route paid for, and the brief asks for
# an offer at EACH. The ladder is [7, 8, 9, 10] indexed by zone bosses cleared,
# so the fourth rung needs three bosses down and no route reaches it early.
# **THE COUNT IS CONSTRUCTED, THE OFFER AND THE PRESS ARE NOT.**
func _s2_the_draft() -> void:
	print("\n§2 — the draft: an offer at each slot count, a swap, a bench, the tag line")
	var caps_seen: Array = []
	var tag_lines := 0
	var cards := 0
	for bosses in 4:
		var s: Node = await _fresh_map(bosses)
		var cap: int = int(_run.ability_slot_cap())
		caps_seen.append(cap)
		var m: Dictionary = _run.party[0]
		# The offer is awarded through the run's own door, then the screen is
		# opened through the map's own.
		var awarded: bool = bool(_run.award_draft_pick(m))
		ok(awarded, "§2: no draft offer could be rolled at a cap of %d" % cap)
		if not awarded:
			continue
		s.call("_open_party_draft")
		await process_frame
		var ov: Node = _overlay(s, 62)
		ok(ov != null, "§2: the draft screen did not open at a cap of %d" % cap)
		if ov == null:
			continue
		# THE SLOT LEDGER IS ON THE SCREEN, and it is where a player reads the
		# count. BO §2's rule: stated before the choice, not discovered by it.
		ok(_has_text(ov, "Ability slots %d of %d" % [
				int(_run.ability_slots_used(m)), cap]),
			"§2: the column does not state `Ability slots N of %d`" % cap)
		var queue: Array = m.get("draft_candidates", [])
		var offer: Array = queue[0] if not queue.is_empty() else []
		for card in offer:
			cards += 1
			var cn := String(card)
			var tl: String = Classes.card_tag_line(cn)
			if tl != "" and _has_text(ov, tl):
				tag_lines += 1
			ok(_press_exact(ov, cn) or _press_exact(_overlay(s, 62), cn),
				"§2: the card `%s` drew no pressable button at a cap of %d" % [cn, cap])
			await process_frame
			# Press it again to UNSTAGE — the same button toggles, and a screen
			# that could stage but not unstage is a trap with no way back.
			var ov2: Node = _overlay(s, 62)
			if ov2 != null:
				_press_exact(ov2, cn)
				await process_frame
			ov = _overlay(s, 62)
			if ov == null:
				break
		s.call("_close_party_draft")
		await process_frame
	print("    slot caps offered against: %s   cards pressed: %d   tag lines rendered: %d" % [
		caps_seen, cards, tag_lines])
	ok(caps_seen == [7, 8, 9, 10],
		"§2: the ladder read %s, not the [7, 8, 9, 10] `ABILITY_SLOTS_BY_BOSS` states"
			% [caps_seen])
	ok(cards > 0 and tag_lines == cards,
		"§2: %d of %d cards rendered their tag line on the screen" % [tag_lines, cards])
	# THE SWAP AND THE BENCH, at the cap, driven end to end on one screen.
	var s2: Node = await _fresh_map(0)
	var hero: Dictionary = _run.party[0]
	# Fill the kit to the cap through the run's own door so the column opens
	# in its at-the-cap shape.
	var guard := 0
	while not bool(_run.ability_slots_full(hero)) and guard < 20:
		guard += 1
		if not bool(_run.award_draft_pick(hero)):
			break
		var q2: Array = hero.get("draft_candidates", [])
		if q2.is_empty():
			break
		var take := String((q2[0] as Array)[0])
		var why: String = String(_run.take_draft_ability(hero, take))
		if why != "":
			break
	ok(bool(_run.ability_slots_full(hero)),
		"§2: the Berserker's kit could not be filled to the cap (%d of %d)" % [
			int(_run.ability_slots_used(hero)), int(_run.ability_slot_cap())])
	var before_loadout: Array = _run.loadout_ability_names(hero)
	var pool_before: int = int(_run.owned_ability_names(hero).size())
	if bool(_run.award_draft_pick(hero)):
		s2.call("_open_party_draft")
		await process_frame
		var ov3: Node = _overlay(s2, 62)
		var q3: Array = hero.get("draft_candidates", [])
		var incoming := String((q3[0] as Array)[0]) if not q3.is_empty() else ""
		ok(ov3 != null and incoming != "", "§2: the at-the-cap draft screen did not open")
		if ov3 != null and incoming != "":
			_press_exact(ov3, incoming)
			await process_frame
			var ov4: Node = _overlay(s2, 62)
			ok(ov4 != null and _press_exact(ov4, "Choose what %s replaces" % incoming),
				"§2: the at-the-cap column drew no `Choose what %s replaces`" % incoming)
			await process_frame
			var drop: Node = _overlay(s2, 64)
			ok(drop != null, "§2: the bench overlay did not open")
			var benched := ""
			if drop != null:
				# **THE PROTECTED CORE MUST NOT BE OFFERED.** A protected name
				# on this list is an ability a player could bench and never get
				# back, and the overlay's own droppable list is what says so.
				var protected: Array = Classes.protected_names(String(hero.get("spec", "")))
				for pn in protected:
					ok(not _has_text(drop, "Bench %s" % String(pn)),
						"§2: the bench overlay offered the PROTECTED `%s`" % String(pn))
				for dn in _run.equipped_ability_names(hero):
					if _press_exact(drop, "Bench %s" % String(dn)):
						benched = String(dn)
						break
			ok(benched != "", "§2: no `Bench …` button could be pressed")
			await process_frame
			var ov5: Node = _overlay(s2, 62)
			ok(ov5 != null and _press(ov5, ["Confirm the draft"]) != "",
				"§2: the confirm would not press with every column decided")
			await process_frame
			await process_frame
			var after_loadout: Array = _run.loadout_ability_names(hero)
			ok(after_loadout.has(incoming),
				"§2: `%s` was taken and is not in the loadout" % incoming)
			ok(not after_loadout.has(benched),
				"§2: `%s` was benched and is still in the loadout" % benched)
			# EG §2 — THE BENCHED CARD IS KEPT. The pool grows by one even
			# though the loadout did not, and that is the whole ruling.
			ok(int(_run.owned_ability_names(hero).size()) == pool_before + 1,
				"§2: the pool went %d → %d — a benched card was LOST, not kept" % [
					pool_before, int(_run.owned_ability_names(hero).size())])
			ok(_run.benched_ability_names(hero).has(benched),
				"§2: `%s` is benched and does not read as benched" % benched)
			print("    at cap %d: took %s, benched %s, loadout %d → %d, pool %d → %d" % [
				int(_run.ability_slot_cap()), incoming, benched,
				before_loadout.size(), after_loadout.size(), pool_before,
				int(_run.owned_ability_names(hero).size())])


# ── §3 — THE RUNE OFFER ─────────────────────────────────────────────────────
#
# **THE BRIEF NAMES THREE SOURCES AND THE CODE HAS TWO.** The Peddler and the
# elite cache are real; "a boss trophy" is not a rune source anywhere in the
# tree — `_resolve_boss` awards a RELIC, a slot rung, an ability pick and a
# meta talent point, and no rune. The two live rune doors beside those are the
# BARGAIN's `rune` reward and the event verb `rune_grant`. Asserted below so
# the claim cannot rot back in, and reported in §9.
func _s3_the_rune_offer() -> void:
	print("\n§3 — the rune offer")
	# (a) THE PEDDLER, bought on the real shop screen.
	var s: Node = await _fresh_map(0)
	_run.gold = 2000
	_run.save_run()
	change_scene_to_file("res://scenes/shop.tscn")
	for _i in 4:
		await process_frame
	var shop: Node = current_scene
	ok(_scene_name() == "Shop", "§3: the shop screen did not open")
	var offers: Array = shop.get("offers")
	print("    the Peddler offers %d runes" % offers.size())
	ok(not offers.is_empty(), "§3: the Peddler offered NO rune to any hero")
	var bought := 0
	var owned_before: Array = []
	if not offers.is_empty():
		var first: Dictionary = offers[0]
		var who: int = int(first["member_idx"])
		var rune: Dictionary = first["rune"]
		for r in _run.party[who].get("runes", []):
			owned_before.append(String((r as Dictionary).get("name", "")))
		# THE PRICE IS ON THE BUTTON, and EZ §0 ruled a rune is 100g flat.
		var gold_before: int = int(_run.gold)
		if _press(shop, ["Buy — "]) != "":
			await process_frame
			await process_frame
			bought = gold_before - int(_run.gold)
			var owned_after: Array = []
			for r2 in _run.party[who].get("runes", []):
				owned_after.append(String((r2 as Dictionary).get("name", "")))
			ok(owned_after.size() == owned_before.size() + 1,
				"§3: a rune was bought for %dg and the hero's pouch did not grow" % bought)
			ok(owned_after.has(String(rune.get("name", ""))),
				"§3: the rune bought was not the rune offered")
			print("    bought `%s` for %dg" % [String(rune.get("name", "")), bought])
	ok(bought > 0, "§3: the Peddler's rune Buy button spent nothing")
	# **A PEDDLER OFFERS NO ABILITY DRAFT.** FD's defect, and the one thing on
	# this screen a player already found.
	ok(not _has_text(shop, "draft"),
		"§3: the Peddler's screen names a DRAFT — FD's defect is back")

	# (b) THE ELITE CACHE, ANSWERED A NODE LATER. FD's hole was in the ANSWER,
	# not the offer, so the cache is rolled, the party WALKS ON, and only then
	# is the card's own CHOOSE pressed.
	var s2: Node = await _fresh_map(0)
	var looter: Dictionary = _run.party[1]
	var cands: Array = _run.roll_rune_candidates(looter)
	ok(not cands.is_empty(), "§3: an elite cache rolled NO rune candidates")
	if cands.is_empty():
		return
	looter["rune_candidates"] = looter.get("rune_candidates", []) + [cands]
	looter["rune_picks_owed"] = int(looter.get("rune_picks_owed", 0)) + 1
	# WALK ON — one whole node between the cache and the answer.
	var reach: Array = _run.reachable()
	ok(not reach.is_empty(), "§3: nowhere to walk to before answering the cache")
	if not reach.is_empty():
		_run.advance(int(reach[0]))
		_run.save_run()
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 5:
		await process_frame
	var s3: Node = current_scene
	ok(int(looter.get("rune_picks_owed", 0)) == 1,
		"§3: the rune pick did not survive the step to the next node")
	s3.call("_open_pick_overlay", 1)
	await process_frame
	var ov: Node = _overlay(s3, 60)
	ok(ov != null, "§3: the cache's pick overlay did not open a node later")
	if ov != null:
		var labels := _labels(ov)
		var live: Array = []
		for l in labels:
			if String(l) != "Not yet":
				live.append(String(l))
		ok(live.size() >= 1,
			"§3: the cache drew %d live buttons a node later — the pick is STRANDED"
				% live.size())
		# ES §1's defect: a RETIRED rune in a cache. The offer's own ids are
		# asked rather than its labels, because a retired rune keeps its name.
		var retired: Array = []
		for c in cands:
			var cid := String((c as Dictionary).get("id", ""))
			if cid != "" and bool(Runes.is_retired(cid)):
				retired.append(cid)
		ok(retired.is_empty(),
			"§3: the elite cache offered RETIRED runes — %s" % [retired])
		var worn_before: int = int(looter.get("runes", []).size())
		s3.call("_pick_rune", 1, 0)
		await process_frame
		await process_frame
		ok(int(looter.get("runes", []).size()) == worn_before + 1,
			"§3: the cache pick was answered and no rune arrived")
		ok(int(looter.get("rune_picks_owed", 0)) == 0,
			"§3: the cache pick was answered and is still owed")
		print("    the cache was answered a node later: %d candidates, %d retired" % [
			cands.size(), retired.size()])

	# (c) WHAT A BOSS ACTUALLY AWARDS.
	var boss_rune_doors: Array = []
	# **THE HOLDER IS DECLARED WITH `:=`, NOT `: String =`, AND THAT IS NOT A
	# STYLE CHOICE.** `build_pin_manifest.py` binds a holder off
	# `var\s+(\w+)\s*:?=`, which an explicitly typed declaration does not
	# match — so every literal this gate pins into `scripts/battle.gd` was
	# invisible to the manifest and to `check_ed` until these two lines were
	# rewritten. Measured: 1412 pins before, 1418 after.
	var src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var at := src.find("func _resolve_boss")
	var body := src.substr(at, 4000) if at >= 0 else ""
	for door in ["roll_rune_candidates", "grant_rune", "rune_picks_owed"]:
		if body.contains(door):
			boss_rune_doors.append(door)
	ok(boss_rune_doors.is_empty(),
		"§3: `_resolve_boss` now reaches a rune door (%s) — the brief's `boss trophy` has become real and this claim is stale"
			% [boss_rune_doors])
	print("    a boss awards a relic, a slot rung, an ability pick and a talent point — NO rune")


# ── §4 — A RUNE'S CONDITION, TURNED OFF BY BENCHING ─────────────────────────
#
# EZ–FC authored twenty-one runes that read the LOADOUT, so a bench is a lever
# on a rune. **THE LEVER AND ITS READOUT ARE THE SAME PRESS**: `_toggle_loadout`
# re-opens the panel it just acted on, so the RUNE CONDITIONS line is rebuilt
# from the live member and there is no cached count to go stale — which is the
# claim this section is here to test rather than to repeat.
func _s4_bench_a_condition() -> void:
	print("\n§4 — a rune's condition, turned off by benching")
	var s: Node = await _fresh_map(3)
	var hero: Dictionary = _run.party[0]
	# Give him cards until one tag threshold is MET, through the run's door.
	var tag := ""
	for _i in 14:
		if not bool(_run.award_draft_pick(hero)):
			break
		var q: Array = hero.get("draft_candidates", [])
		if q.is_empty():
			break
		var name0 := String((q[0] as Array)[0])
		if String(_run.take_draft_ability(hero, name0)) != "":
			# At the cap, bench the last carried card to make room.
			var carried: Array = _run.equipped_ability_names(hero)
			if carried.is_empty():
				break
			if String(_run.take_draft_ability(hero, name0,
					String(carried[carried.size() - 1]))) != "":
				break
		var dr: Array = Runes.drafted_names(hero)
		for t in Classes.TAG_ORDER:
			if bool(Runes.threshold_met(dr, String(t))):
				tag = String(t)
				break
		if tag != "":
			break
	ok(tag != "", "§4: no tag threshold could be met on a full Berserker kit")
	if tag == "":
		return
	var drafted: Array = Runes.drafted_names(hero)
	var cond := {"tag_threshold": tag}
	ok(bool(Runes.loadout_condition_met(cond, hero)),
		"§4: the %s threshold reads MET on the table and NOT through the door" % tag)
	# THE PANEL, AND ITS LINE.
	s.call("_open_loadout_panel", 0)
	await process_frame
	var ov: Node = _overlay(s, 60)
	ok(ov != null, "§4: the loadout panel did not open")
	if ov == null:
		return
	var met_line: String = "%s %d✓" % [tag, int(Classes.primary_tag_count(drafted, tag))]
	ok(_has_text(ov, met_line),
		"§4: the loadout panel does not show `%s` while the condition IS met" % met_line)
	# BENCH UNTIL IT FALLS. Every bench is a real press on the panel's own row.
	var benched: Array = []
	for _i in 8:
		if not bool(Runes.loadout_condition_met(cond, hero)):
			break
		var live_ov: Node = _overlay(s, 60)
		if live_ov == null:
			break
		var carried2: Array = _run.equipped_ability_names(hero)
		var hit := ""
		for c in carried2:
			if int(Classes.primary_tag_count([String(c)], tag)) > 0:
				hit = String(c)
				break
		if hit == "":
			break
		# **THE ROW'S BUTTON IS `Bench`, NOT THE ABILITY'S NAME.** The name is
		# the Label beside it, so the row is found by its Label and the press
		# lands on its sibling Button — which is what a player clicks.
		if not _press_row(live_ov, hit, "Bench"):
			note("the loadout panel drew no pressable Bench row for `%s`" % hit)
			_dead_buttons.append("loadout row %s" % hit)
			_run.unequip_earned_ability(hero, hit)
		benched.append(hit)
		await process_frame
		await process_frame
	ok(not benched.is_empty(), "§4: nothing could be benched to break the condition")
	ok(not bool(Runes.loadout_condition_met(cond, hero)),
		"§4: %d %s cards were benched and the condition is STILL met" % [
			benched.size(), tag])
	# AND THE SCREEN SAYS SO. The ✓ is gone from the same line.
	var ov2: Node = _overlay(s, 60)
	if ov2 == null:
		s.call("_open_loadout_panel", 0)
		await process_frame
		ov2 = _overlay(s, 60)
	ok(ov2 != null and not _has_text(ov2, met_line),
		"§4: the panel still shows `%s` after the condition was broken" % met_line)
	# AND BACK ON. The lever works in both directions or it is not a lever.
	for b in benched:
		var back_ov: Node = _overlay(s, 60)
		if back_ov == null or not _press_row(back_ov, String(b), "Carry"):
			_run.equip_earned_ability(hero, String(b))
		await process_frame
		await process_frame
	ok(bool(Runes.loadout_condition_met(cond, hero)),
		"§4: the benched cards were carried again and the condition did NOT come back")
	# THE HERO SHEET CARRIES THE SAME LINE — one builder, two surfaces.
	_run.hero_screen_idx = 0
	change_scene_to_file("res://scenes/party.tscn")
	for _i in 5:
		await process_frame
	var sheet: Node = current_scene
	ok(_scene_name() == "Party", "§4: the hero sheet did not open (got %s)" % _scene_name())
	var dr2: Array = Runes.drafted_names(hero)
	var sheet_line: String = "%s %d ✓" % [tag, int(Classes.primary_tag_count(dr2, tag))]
	ok(_has_text(sheet, "RUNE CONDITIONS"),
		"§4: the hero sheet does not carry a RUNE CONDITIONS line at all")
	ok(_has_text(sheet, sheet_line),
		"§4: the hero sheet does not show `%s` while the condition is met" % sheet_line)
	print("    %s met, %d cards benched to break it, and both surfaces followed" % [
		tag, benched.size()])


# ── §5 — THE POUCH ──────────────────────────────────────────────────────────
#
# CT §3's three outcomes, and §3 was emphatic that the last two must not be
# conflated: it LANDS; there is NO SLOT (a choice, queued as a swap offer); the
# STACK is full (a refusal, with a message). The slot count is a ladder on the
# zone boss, exactly as the ability cap is.
func _s5_the_pouch() -> void:
	print("\n§5 — the pouch")
	# **THE POUCH LADDER IS INDEXED BY THE ZONE YOU ARE STANDING IN, NOT BY
	# BOSSES CLEARED** — `ITEM_SLOTS_BY_ZONE[zone_idx]` — and the ABILITY
	# ladder is indexed by bosses cleared. The two part company on the third
	# boss, which is exactly why they are two functions and not one.
	var slots: Array = []
	await _fresh_map(0)
	for z in 3:
		_run.zone_idx = z
		slots.append(int(_run.item_slots()))
	print("    pouch slots by zone standing in: %s" % [slots])
	ok(slots == [4, 5, 6],
		"§5: the pouch ladder read %s, not the [4, 5, 6] ITEM_SLOTS_BY_ZONE states"
			% [slots])
	_run.zone_idx = 0
	# A PURCHASE, on the real shop screen.
	await _fresh_map(0)
	_run.items.clear()
	_run.gold = 2000
	_run.save_run()
	change_scene_to_file("res://scenes/shop.tscn")
	for _i in 4:
		await process_frame
	var shop: Node = current_scene
	var gold0: int = int(_run.gold)
	var slots0: int = int(_run.slots_used())
	var bought := _press(shop, ["Health"])
	ok(bought != "", "§5: the shop drew no consumable button to press")
	await process_frame
	await process_frame
	ok(int(_run.gold) < gold0, "§5: a consumable was bought and no gold was spent")
	ok(int(_run.items.get("health", 0)) >= 1, "§5: a Health Potion was bought and did not arrive")
	ok(int(_run.slots_used()) == slots0 + 1, "§5: the purchase took no pouch slot")
	# A FULL STACK IS A WALL. Buy until the cap, then buy once more.
	var cap: int = int(_run.item_stack_cap("health"))
	var passes := 0
	while int(_run.items.get("health", 0)) < cap and passes < 20:
		passes += 1
		var shop2: Node = current_scene
		if _press(shop2, ["Health"]) == "":
			break
		await process_frame
		await process_frame
	ok(int(_run.items.get("health", 0)) == cap,
		"§5: the stack could not be filled to its cap of %d (reached %d)" % [
			cap, int(_run.items.get("health", 0))])
	ok(bool(_run.item_full("health")), "§5: a full stack does not read as full")
	var before_refusal: int = int(_run.gold)
	var stack_before: int = int(_run.items.get("health", 0))
	var shop3: Node = current_scene
	_press(shop3, ["Health"])
	await process_frame
	await process_frame
	ok(int(_run.items.get("health", 0)) == stack_before,
		"§5: a FULL stack accepted another purchase — %d → %d" % [
			stack_before, int(_run.items.get("health", 0))])
	ok(int(_run.gold) == before_refusal,
		"§5: the refused purchase took %dg anyway" % (before_refusal - int(_run.gold)))
	# THE SELL. Two presses — arm, then confirm — which is the screen's own
	# guard against a mis-click selling a potion the player needs.
	var shop4: Node = current_scene
	var gold_b: int = int(_run.gold)
	var have_b: int = int(_run.items.get("health", 0))
	var armed := _press(shop4, ["Sell +"])
	ok(armed != "", "§5: the shop drew no Sell button")
	await process_frame
	await process_frame
	var shop5: Node = current_scene
	ok(int(_run.items.get("health", 0)) == have_b,
		"§5: the FIRST press of Sell sold the item — the confirm step is gone")
	var sold := _press(shop5, ["Sure? +"])
	ok(sold != "", "§5: the armed Sell drew no `Sure?` confirm")
	await process_frame
	await process_frame
	# **A SELL TAKES THE WHOLE STACK AND FREES THE SLOT** (CT §2: a partial
	# stack cannot be split across slots, so there is no "sell three of six").
	ok(int(_run.items.get("health", 0)) == 0 and not _run.items.has("health"),
		"§5: the confirmed sell left %d in the pouch — the stack and its SLOT go together"
			% int(_run.items.get("health", 0)))
	ok(int(_run.slots_used()) == 0,
		"§5: the sold stack did not free its slot (%d used)" % int(_run.slots_used()))
	ok(int(_run.gold) > gold_b, "§5: the confirmed sell paid nothing")
	print("    bought %d to the cap, the refusal held, sold the stack for %dg" % [
		have_b, int(_run.gold) - gold_b])
	# NO SLOT IS A CHOICE, NOT A REFUSAL. Fill every slot with other kinds and
	# then offer one more.
	await _fresh_map(0)
	_run.items.clear()
	var kinds: Array = []
	for id in _run.ITEM_INFO:
		kinds.append(String(id))
	var filled := 0
	for id2 in kinds:
		if int(_run.slots_free()) < 1:
			break
		_run.add_item(String(id2), 1)
		filled += 1
	ok(int(_run.slots_free()) == 0,
		"§5: the pouch could not be filled — %d free after %d kinds" % [
			int(_run.slots_free()), filled])
	var spare := ""
	for id3 in kinds:
		if not _run.items.has(String(id3)):
			spare = String(id3)
			break
	if spare != "":
		var queued_before: int = int(_run.pending_item_offers.size())
		var landed: bool = bool(_run.offer_item(spare))
		ok(landed, "§5: a NEW kind arriving at a full pouch was not queued as a choice")
		ok(int(_run.pending_item_offers.size()) == queued_before + 1,
			"§5: the no-slot arrival queued no swap offer")
		ok(not _run.items.has(spare),
			"§5: the no-slot arrival was taken anyway, over the slot cap")
		print("    the pouch filled at %d kinds; `%s` queued as a CHOICE, not refused"
			% [filled, spare])


# ── §6 — A ZONE BOSS AWARD AT AN EXHAUSTED POOL ────────────────────────────
#
# EA §1: a zone-boss award ALWAYS PAYS, and the baseline it replaced was
# SILENCE. EH §1 added the third tier when EG broke EA's floor. The chain is
# spec boss pool → spec draft pool → class pool, and this drives a hero whose
# first two are empty so the third is SEEN paying rather than reasoned about.
func _s6_the_exhausted_pool() -> void:
	print("\n§6 — a zone boss award at an exhausted pool")
	var s: Node = await _fresh_map(2)
	var hero: Dictionary = _run.party[2]
	# TIER 1 — the ordinary award, so the fallback is measured against it.
	hero["bm_abilities"] = []
	hero["bm_equipped"] = []
	hero["bm_candidates"] = []
	hero["bm_picks_owed"] = 0
	ok(bool(_run.award_ability_pick(hero)), "§6: the ordinary boss award paid nothing")
	var tier1: Array = hero["bm_candidates"]
	print("    tier 1 (the boss pool) offered %d" % (tier1[0] as Array).size())
	# TIER 3 — every pool but the class one emptied, by OWNING everything in
	# them. `owned_ability_names` is what each roll subtracts, so a hero who
	# holds the whole spec boss pool and the whole spec draft pool falls
	# through to `roll_class_fallback_offer` and nowhere else.
	hero["bm_candidates"] = []
	hero["bm_picks_owed"] = 0
	# **THE POOLS ARE ASKED THROUGH `Run.draft_pool_left`, WHICH IS THE DRAFT'S
	# OWN DOOR.** `Classes.spec_draft_pool` / `class_draft_pool` are the table
	# and `check_da` §3 forbids a gate reading them — rightly: a gate that
	# re-derives a corpus is a gate that goes stale the day the corpus moves.
	# The run's door answers the membership question the flat corpus cannot,
	# and it answers it after the owned filter, which is what this section is
	# manipulating.
	var spec := String(hero.get("spec", ""))
	var everything: Array = []
	for n in Classes.spec_pool(spec):
		everything.append(String(n))
	var pools_now: Dictionary = _run.draft_pool_left(hero)
	for n2 in pools_now.get("spec", []):
		everything.append(String(n2))
	hero["bm_abilities"] = everything.duplicate()
	hero["bm_equipped"] = []
	ok(_run.roll_spec_ability_offer(hero).is_empty(),
		"§6: the spec BOSS pool is not empty with every one of its names held")
	ok(_run.roll_spec_fallback_offer(hero).is_empty(),
		"§6: the spec DRAFT pool is not empty with every one of its names held")
	var paid: bool = bool(_run.award_ability_pick(hero))
	ok(paid, "§6: THE AWARD PAID NOTHING at an exhausted pool — EA §1's silence is back")
	if not paid:
		return
	var q: Array = hero["bm_candidates"]
	var offer: Array = q[q.size() - 1]
	ok(not offer.is_empty(), "§6: the third tier queued an EMPTY offer")
	var pools_after: Dictionary = _run.draft_pool_left(hero)
	var from_class: Array = []
	for n3 in pools_after.get("class", []):
		from_class.append(String(n3))
	for held in _run.owned_ability_names(hero):
		from_class.append(String(held))
	var outside: Array = []
	for c in offer:
		if not from_class.has(String(c)):
			outside.append(String(c))
	ok(outside.is_empty(),
		"§6: the class fallback offered a card that is not in the class pool — %s" % [outside])
	print("    tier 3 (the class pool) offered %d: %s" % [offer.size(), offer])
	# AND IT IS ANSWERABLE ON THE REAL CARD. A tier that pays an offer nobody
	# can press is the same silence with more steps.
	s.call("_open_pick_overlay", 2)
	await process_frame
	var ov: Node = _overlay(s, 60)
	ok(ov != null, "§6: the fallback award drew no pick overlay")
	if ov != null:
		var live: Array = []
		for l in _labels(ov):
			if String(l) != "Not yet":
				live.append(String(l))
		ok(live.size() >= offer.size(),
			"§6: the overlay drew %d live buttons for a %d-card fallback offer" % [
				live.size(), offer.size()])
		var held_before: int = int((hero["bm_abilities"] as Array).size())
		ok(_press_exact(ov, String(offer[0])),
			"§6: the fallback card `%s` drew no pressable button" % String(offer[0]))
		await process_frame
		await process_frame
		ok(int((hero["bm_abilities"] as Array).size()) == held_before + 1,
			"§6: the fallback card was pressed and the hero did not gain it")


# ── §7 — THE SKILL CHECK, ALL FOUR CASES ────────────────────────────────────
#
# CM/CN/CS's four: the normal check, the gated check, the defensive check and
# the Sharpshooter's SEQUENCE. **THEY SHARE ONE BAR AND ONE SET OF ZONES**, and
# the zones are a PROFILE rather than constants — so what is driven here is the
# bar itself, at real positions, on a real battle scene with autoplay off.
func _s7_the_skill_check() -> void:
	print("\n§7 — the skill check, all four cases")
	# **THE FOUR CASES NEED TWO PARTIES.** The defensive check belongs to the
	# Warden and the sequence to the Sharpshooter; the Warden and the Berserker
	# are both WARRIOR specs, so one party cannot hold the Warden, a gated
	# ability's owner and the Sharpshooter at once.
	var scene: Node = await Gate.spawn(self,
		["berserker", "pyromancer", "holy", "sharpshooter"], {"deterministic": true})
	var ss: BattleUnit = null
	var gated_owner: BattleUnit = null
	var gated_ab: Ability = null
	for h in scene.get("heroes"):
		if h.is_companion:
			continue
		if String(h.passive_id) == "lethal_aim":
			ss = h
		for a in h.abilities:
			if a != null and a.gated and gated_ab == null:
				gated_ab = a
				gated_owner = h
	ok(ss != null, "§7: the party has no Sharpshooter")
	if ss == null:
		return
	# (1) THE ORDINARY CHECK. Dead centre is Perfect, 0.60 is a Good, the far
	# end is a Sloppy — and the bar is VISIBLE while it grades.
	var g_perfect := await _bar(scene, "", 0.5)
	var g_good := await _bar(scene, "", 0.6)
	var g_fail := await _bar(scene, "", 0.99)
	print("    ordinary: centre=%s  0.60=%s  0.99=%s   hint=`%s`" % [
		g_perfect, g_good, g_fail, String(scene.sc_hint.text)])
	ok(g_perfect == "perfect", "§7: a centred press graded %s, not perfect" % g_perfect)
	ok(g_good == "good", "§7: a press at 0.60 graded %s, not good" % g_good)
	ok(g_fail == "fail", "§7: a press at the far end graded %s, not a Sloppy" % g_fail)
	ok(String(scene.sc_hint.text) == String(scene.SC_HINT_NORMAL),
		"§7: the ordinary bar's line is `%s`, not the plain one" % String(scene.sc_hint.text))
	# (2) THE GATED CHECK — the stakes are ON THE BAR at the moment of the
	# press (CM §1), and a Sloppy loses the cast while spending nothing.
	var g_gated := await _bar(scene, "gated", 0.99)
	ok(g_gated == "fail", "§7: the gated bar graded %s at the far end" % g_gated)
	ok(String(scene.sc_hint.text).contains("LOSES THIS CAST"),
		"§7: the gated bar does not name the stakes (was: `%s`)" % String(scene.sc_hint.text))
	# **A GATED ABILITY IS A DRAFT CARD, NOT A BASE KIT SLOT** — the five in
	# the tree (Reckless Abandon, Boil Over, Requiem, Unleash, Death Ray) are
	# all pool cards, so a party that has not drafted one carries none. It is
	# fetched from the pool by the same door the draft card renders through.
	if gated_ab == null:
		for pool_name in ["Reckless Abandon", "Boil Over", "Unleash", "Requiem"]:
			var cand: Ability = Classes.pool_ability(String(pool_name))
			if cand != null and cand.gated:
				gated_ab = cand
				# The card's own spec owner, so the resource the refusal is
				# asserted not to spend is the one the cast would have spent.
				for h3 in scene.get("heroes"):
					if not h3.is_companion and gated_owner == null:
						gated_owner = h3
				break
	ok(gated_ab != null,
		"§7: no gated ability could be found in the pool — the case cannot be driven")
	if gated_ab != null:
		# **THE METER AND THE COOLDOWN ARE PUT SOMEWHERE THEY CAN FALL FROM.**
		# A hero at zero resource and no cooldown satisfies both arms below no
		# matter what `_gated_failure` does — an injected `resource -= 1`
		# clamps at zero and the gate reads clean. Found by arming exactly that
		# control against this section and watching it NOT bite.
		gated_owner.resource = 40.0
		gated_owner.cooldowns[gated_ab.display_name] = 2
		var res_before: float = float(gated_owner.resource)
		var cd_before: int = int(gated_owner.cooldowns.get(gated_ab.display_name, 0))
		ok(res_before > 0.0 and cd_before > 0,
			"§7: the gated arms are standing on a zero meter and no cooldown — they cannot fall")
		await scene._gated_failure(gated_owner, gated_ab)
		ok(is_equal_approx(float(gated_owner.resource), res_before),
			"§7: A GATED FAILURE SPENT THE RESOURCE — %s → %s. Nothing is spent but the turn."
				% [res_before, float(gated_owner.resource)])
		ok(int(gated_owner.cooldowns.get(gated_ab.display_name, 0)) == cd_before,
			"§7: a gated failure started the cooldown — nothing is spent but the turn")
		print("    gated: `%s` lost on a Sloppy; %s and cooldown both unspent" % [
			gated_ab.display_name, gated_owner.resource_name])
	# (4) THE SHARPSHOOTER'S SEQUENCE. **HIS BAR IS HARDER IN SECONDS AND WIDER
	# AS A FRACTION, AND READING THE FRACTION IS THE WRONG READING** — CLAUDE.md
	# says so in as many words. `sweep_time` is his own literal (a 0.52 s pass),
	# and the half-widths are scaled so the TOLERANCE is a fixed 15% less than
	# everybody else's. A gate comparing `good_half` alone reads his window as
	# 63% WIDER and concludes the exception is backwards.
	var base: Dictionary = scene.SC_PROFILE_DEFAULT
	var prof: Dictionary = scene._sharpshooter_basic_profile(ss)
	var base_secs: float = float(base["good_half"]) * float(base["sweep_time"])
	var ss_secs: float = float(prof["good_half"]) * float(prof["sweep_time"])
	var base_p: float = float(base["perfect_half"]) * float(base["sweep_time"])
	var ss_p: float = float(prof["perfect_half"]) * float(prof["sweep_time"])
	print("    sharpshooter: good half %.4f of the track vs %.4f — but %.4f s vs %.4f s"
		% [float(prof["good_half"]), float(base["good_half"]), ss_secs, base_secs])
	ok(float(prof["good_half"]) > float(base["good_half"]),
		"§7: the Sharpshooter's Good FRACTION is not wider than the default — the derivation moved")
	ok(ss_secs < base_secs,
		"§7: the Sharpshooter's Good tolerance is %.4f s against the default %.4f s — his bar is not harder"
			% [ss_secs, base_secs])
	ok(ss_p < base_p,
		"§7: the Sharpshooter's Perfect tolerance is %.4f s against %.4f s" % [ss_p, base_p])
	var off: float = ss_secs / base_secs
	ok(absf(off - (base_p / base_p * ss_p / base_p)) < 1.0,
		"§7: the two halves take DIFFERENT offsets — the exception is a slope, not an offset")
	ok(absf((ss_p / base_p) - off) < 0.001,
		"§7: Good is scaled %.4f and Perfect %.4f — a fixed offset scales both the same"
			% [off, ss_p / base_p])
	# THE FOCUS METER IS `second_resource`, and the press count comes off it.
	# The Focus meter is `second_resource`, and the press ladder is one press
	# below 50 and then one per `SS_SEQ_STEP` — so the four-press case needs the
	# meter at the top of its ladder rather than at some "max" field, which the
	# unit does not carry.
	ss.second_resource = int(scene.SS_SEQ_STEP) * int(scene.SS_SEQ_MAX_PRESSES)
	var full: Dictionary = scene._sharpshooter_basic_profile(ss)
	var presses: int = int(scene._sequence_presses(ss))
	print("    at %d Focus the sequence is %d presses (profile says %d)" % [
		int(ss.second_resource), presses, int(full.get("presses", 1))])
	ok(presses > 1,
		"§7: at full Focus the sequence is %d press — the multi-press case is unreachable"
			% presses)
	var landed := await _sequence(scene, full, 0.5)
	print("    every press centred: %d of %d landed" % [
		int(landed["landed"]), int(landed["pressed"])])
	ok(int(landed["pressed"]) == presses,
		"§7: the bar asked for %d presses and %d were taken" % [
			presses, int(landed["pressed"])])
	ok(String(landed["grade"]) == "perfect",
		"§7: every press was centred and the sequence graded %s" % String(landed["grade"]))
	var partial := await _sequence(scene, full, 0.99)
	ok(String(partial["grade"]) == "fail",
		"§7: every press missed and the sequence graded %s" % String(partial["grade"]))
	ok(int(partial["pressed"]) == 1,
		"§7: a Sloppy on the FIRST press did not end the sequence — %d presses were taken"
			% int(partial["pressed"]))
	# (3) THE DEFENSIVE CHECK. **ITS BAR IS DRIVEN AND ITS JOIN CANNOT BE.**
	# `_defensive_brace` chooses between the bar and a bot roll on
	# `_nobody_can_press()`, which is `sim or autoplay or headless` — so under
	# `--headless` the player branch is unreachable BY CONSTRUCTION and no
	# headless gate can press it through an attack. That is what `check_cm_live`'s
	# four standing failures are, and it is why they are on purpose. What CAN be
	# driven headless is the bar itself, called the way the brace calls it.
	scene.queue_free()
	await process_frame
	var dscene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "holy", "beastmaster"], {"deterministic": true})
	var warden: BattleUnit = null
	var other: BattleUnit = null
	for h2 in dscene.get("heroes"):
		if h2.is_companion:
			continue
		if String(h2.passive_id) == "heavy_plating":
			warden = h2
		elif other == null:
			other = h2
	ok(warden != null, "§7: the party has no Warden")
	ok(other != null, "§7: the party has no hero who is not the Warden")
	if warden == null or other == null:
		return
	ok(bool(dscene._has_defensive_check(warden)), "§7: the Warden does not qualify to brace")
	ok(not bool(dscene._has_defensive_check(other)),
		"§7: a hero with no defensive passive qualifies to brace")
	var d_perfect := await _bar(dscene, "defensive", 0.5)
	ok(d_perfect == "perfect", "§7: a centred defensive press graded %s" % d_perfect)
	ok(String(dscene.sc_hint.text).contains("INCOMING"),
		"§7: the defensive bar's line is `%s`" % String(dscene.sc_hint.text))
	ok(dscene.sc_cancel == null,
		"§7: the defensive bar carries a Cancel — a hero cannot decline to be attacked")
	ok(bool(dscene._nobody_can_press()),
		"§7: `_nobody_can_press` is FALSE under --headless — the defensive brace's player branch is reachable now and check_cm_live's four standing reds should be re-derived")
	print("    defensive: the bar grades and says INCOMING with no Cancel; the")
	print("    BRACE's player branch is unreachable headless by construction")
	dscene.queue_free()
	await process_frame


# One press on the real bar, at `pos`, and the grade it produces.
func _bar(scene: Node, mode: String, pos: float) -> String:
	var out := ["", false]
	var task := func():
		out[0] = await scene._run_skill_check(false, mode, {})
		out[1] = true
	task.call()
	for _i in 400:
		if bool(out[1]):
			break
		if bool(scene.sc_active):
			ok(bool(scene.sc_root.visible), "§7: the bar graded while its UI was hidden")
			scene.sc_pos = pos
			scene._grade_skill_check()
		await process_frame
	return String(out[0])


# The sequence, pressed `presses` times at the same position.
func _sequence(scene: Node, profile: Dictionary, pos: float) -> Dictionary:
	var out := ["", false]
	var task := func():
		out[0] = await scene._run_skill_check(false, "", profile)
		out[1] = true
	task.call()
	var pressed := 0
	for _i in 2000:
		if bool(out[1]):
			break
		if bool(scene.sc_active):
			scene.sc_pos = pos
			scene._grade_skill_check()
			pressed += 1
		await process_frame
	var seq: Dictionary = scene.sc_sequence
	return {"grade": String(out[0]), "presses": int(seq.get("presses",
		int(profile.get("presses", 1)))), "landed": int(seq.get("landed", 0)),
		"pressed": pressed}


# ── §8 — THE END BOSS ───────────────────────────────────────────────────────
#
# **THIS IS A SECOND ARM AND IT SAYS SO.** §1's run is played straight and the
# autoplay bot loses in zone 3, so the end boss's own screen would go undriven
# on the honest arm alone. This fights it on its own — the real encounter, the
# real battle scene, the real end card — with the party at full health, and it
# is NOT evidence about the run's balance.
func _s8_the_end_boss() -> void:
	print("\n§8 — the end boss, reached and fought through the map")
	# **THE END BOSS SLOT ONLY EXISTS IN THE FINAL ZONE.** `_build_lattice`
	# appends it after the third zone's boss and links that boss's `next` to
	# it, so the way to stand in front of it is to BE in the last zone — which
	# `advance_zone` is the one door to.
	var s: Node = await _fresh_map(0)
	while bool(_run.has_next_zone()):
		_run.advance_zone()
	_run.zone_bosses_cleared = 3
	_run.slot_idx = _run.BOSS_SLOT
	_run.node_idx = 0
	_run.heal_party(1.0)
	ok(bool(_run.is_end_boss_slot(_run.END_BOSS_SLOT)),
		"§8: slot %d does not read as the end boss slot" % _run.END_BOSS_SLOT)
	var reach: Array = _run.reachable()
	ok(reach.size() == 1,
		"§8: the third zone's boss leads to %d nodes, not the one end boss" % reach.size())
	if reach.is_empty():
		return
	# **THE BATTLE SCENE'S PATH IS NEVER NAMED IN THIS FILE — NOT EVEN IN A
	# COMMENT.** `_on_node_pressed` is what a player presses and it is what
	# changes the scene; a gate that wrote that path itself would be
	# instantiating the battle by hand, which is DB §1's rule and `check_da`
	# §3's fingerprint. **The fingerprint is a plain substring match on the RAW
	# source, so PROSE ABOUT THE PATH TRIPS IT EXACTLY AS THE PATH DOES** —
	# measured, after the sentence above was written with the literal in it and
	# the gate went 42 / 2 on a file that instantiates nothing.
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	_run.save_run()
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 5:
		await process_frame
	var mapscene: Node = current_scene
	ok(_scene_name() == "Map", "§8: the final zone's map did not open")
	mapscene.call("_on_node_pressed", int(reach[0]))
	for _i in 5:
		await process_frame
	ok(String(_run.encounter.get("type", "")) == "endboss",
		"§8: pressing the last node armed a `%s`, not the end boss"
			% String(_run.encounter.get("type", "")))
	var scene: Node = current_scene
	ok(_scene_name() == "Battle",
		"§8: the end boss's battle did not open — the screen is `%s`" % _scene_name())
	if _scene_name() != "Battle":
		return
	var names: Array = []
	for e in scene.get("enemies"):
		names.append(String(e.unit_name))
	print("    the board: %s" % [names])
	ok(not names.is_empty(), "§8: the end boss's board is empty")
	var guard := 0
	while not bool(scene.get("battle_over")) and guard < BATTLE_FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	ok(guard < BATTLE_FRAME_CAP, "§8: the end boss battle never ended in %d frames"
		% BATTLE_FRAME_CAP)
	for _i in 8:
		await process_frame
	var alive := 0
	for h in scene.get("heroes"):
		if not h.is_companion and not h.dead:
			alive += 1
	var labels := _labels(scene)
	var summary := false
	for l in labels:
		if String(l).begins_with("New Run") or String(l).begins_with("Copy summary"):
			summary = true
	ok(summary, "§8: the end boss ended and drew NO run-summary card — %s" % [labels])
	ok(not _run.active, "§8: the run is still active after the end boss died")
	print("    %d heroes standing, %s card drawn, run closed" % [
		alive, "summary" if summary else "no"])
	_end_boss_screen_seen = summary


# ── §9 — EVERY BUTTON ON EVERY SCREEN ───────────────────────────────────────
#
# **A BUTTON WITH NOTHING CONNECTED TO `pressed` IS A BUTTON THAT DOES NOTHING,
# AND IT IS THE ONE DEFECT CLASS A PLAYER FINDS IMMEDIATELY AND NO ASSERTION ON
# STATE EVER WILL.** 604 of them shipped once. This asks every visible, enabled
# button on every screen a run opens whether anything is listening, which needs
# no press and so is safe on the destructive ones (Sell, Discard, Confirm).
#
# **THE POPULATION IS PRINTED AS `n of m`**, because a census that walked
# nothing prints exactly like a census that found nothing wrong.
# **TWO EXEMPTIONS, AND BOTH ARE MECHANICAL RATHER THAN A LIST OF NAMES.**
# A list of names goes stale the day a screen is redrawn; a signature does not.
#
#   A MENU BUTTON's action lives on its POPUP (`id_pressed`), never on
#   `pressed` — the map's burger is one, and so is every submenu it opens.
#
#   A HOVER SURFACE is a `Button` used as the cheapest thing that can raise a
#   tooltip. The hero sheet's talent tree is 27 of them and `party_screen.gd`
#   says so in as many words: *"neither is clickable. `Button` survives only
#   because it is the cheapest hover surface; `disabled` stays false or the
#   tooltip stops firing."* The signature is exact — `focus_mode` NONE, an
#   ARROW cursor, and something connected to `mouse_entered` — and a control
#   that lost its handler would match none of the three.
#
# **BOTH ARE COUNTED AND PRINTED**, because an exemption nobody can see is how
# a real dead button gets filed under a sanctioned one.
var _census_screens := 0
var _census_buttons := 0
var _census_exempt := 0
var _census_hover := 0
var _census_menu := 0
var _census_dead: Array = []


func _is_hover_surface(btn: Button) -> bool:
	return btn.focus_mode == Control.FOCUS_NONE \
		and btn.mouse_default_cursor_shape == Control.CURSOR_ARROW \
		and not (btn.mouse_entered as Signal).get_connections().is_empty()


func _census(n: Node, where: String) -> void:
	_census_screens += 1
	var btns: Array = []
	_buttons(n, btns)
	var here := 0
	var exempt := 0
	for b in btns:
		var btn := b as Button
		if btn.disabled:
			continue
		here += 1
		_census_buttons += 1
		if not (btn.pressed as Signal).get_connections().is_empty():
			continue
		if btn is MenuButton or btn is OptionButton:
			exempt += 1
			_census_exempt += 1
			_census_menu += 1
			continue
		if _is_hover_surface(btn):
			exempt += 1
			_census_exempt += 1
			_census_hover += 1
			continue
		_census_dead.append("%s: `%s`" % [where, String(btn.text)])
	print("    %-34s %3d buttons%s" % [where, here,
		"   (%d are hover surfaces or menus)" % exempt if exempt > 0 else ""])


func _s9_every_button() -> void:
	print("\n§9 — every button on every screen a run opens")
	var s: Node = await _fresh_map(1)
	_census(s, "map (standing on the road)")
	# The overlays, each opened through the map's own door.
	var m0: Dictionary = _run.party[0]
	if bool(_run.award_draft_pick(m0)):
		s.call("_open_party_draft")
		await process_frame
		var d: Node = _overlay(s, 62)
		if d != null:
			_census(d, "the draft screen")
			var q: Array = m0.get("draft_candidates", [])
			if not q.is_empty():
				var card := String((q[0] as Array)[0])
				_press_exact(d, card)
				await process_frame
				var d2: Node = _overlay(s, 62)
				if d2 != null:
					_census(d2, "the draft, one card staged")
		s.call("_close_party_draft")
		await process_frame
	# The card's CHOOSE button resolves in a fixed precedence — ability, draft,
	# upgrade, rune — so a draft still owed from the block above would open the
	# draft screen again rather than the upgrade overlay.
	m0["draft_picks_owed"] = 0
	m0["draft_candidates"] = []
	_run.award_upgrade_pick(m0)
	s.call("_open_pick_overlay", 0)
	await process_frame
	var up: Node = _overlay(s, 60)
	if up != null:
		_census(up, "the upgrade pick overlay")
		up.queue_free()
		await process_frame
	# **A PANEL WITH NOTHING IN IT DRAWS ONE BUTTON, AND THAT IS A VACUOUS
	# CENSUS.** Both are stocked first — through the run's own doors — so the
	# rows themselves are what gets read.
	var m1: Dictionary = _run.party[1]
	# `grant_rune` RETURNS a rune and does not fit it — every caller in the
	# tree appends it themselves, so a census that only called the door would
	# read an empty pouch and one Close button.
	var m0r: Dictionary = _run.party[0]
	for _r in 3:
		var got: Dictionary = _run.grant_rune(m0r)
		if got.is_empty():
			break
		got["equipped"] = _r == 0
		m0r["runes"] = m0r.get("runes", []) + [got]
	for _d in 4:
		if not bool(_run.award_draft_pick(m1)):
			break
		var dq: Array = m1.get("draft_candidates", [])
		if dq.is_empty():
			break
		_run.take_draft_ability(m1, String((dq[0] as Array)[0]))
	s.call("_open_rune_panel", 0)
	await process_frame
	var rp: Node = _overlay(s, 60)
	if rp != null:
		_census(rp, "the rune pouch")
		rp.queue_free()
		await process_frame
	s.call("_open_loadout_panel", 1)
	await process_frame
	var lp: Node = _overlay(s, 60)
	if lp != null:
		_census(lp, "the loadout panel")
		lp.queue_free()
		await process_frame
	_run.add_item("health", 2)
	s.call("_use_item", "health")
	await process_frame
	var tp: Node = _overlay(s, 70)
	if tp != null:
		_census(tp, "the item target picker")
		tp.queue_free()
		await process_frame
	# The four screens a node leads to, each opened as the map opens it.
	_run.gold = 900
	for pair in [["res://scenes/shop.tscn", "the Peddler"],
			["res://scenes/blacksmith.tscn", "the Blacksmith"],
			["res://scenes/party.tscn", "the hero sheet"]]:
		change_scene_to_file(String(pair[0]))
		for _i in 4:
			await process_frame
		if current_scene != null:
			_census(current_scene, String(pair[1]))
	# The bargain, armed the way an elite arms it. The screen rolls its own
	# three at `_ready` and refuses to open with no encounter — which is a
	# guard, so it is satisfied rather than bypassed.
	_run.active = true
	_run.encounter = {"type": "elite", "enemies": ["raider", "raider"],
		"theme": "Warband"}
	_run.arm_fixed_modifier("elite")
	change_scene_to_file("res://scenes/offer.tscn")
	for _i in 4:
		await process_frame
	if _scene_name() == "Offer":
		_census(current_scene, "the bargain")
	# The event, armed through its own door.
	if bool(_run.begin_event_node()):
		change_scene_to_file("res://scenes/event.tscn")
		for _i in 4:
			await process_frame
		if _scene_name() == "Event":
			_census(current_scene, "an event")
	# The main menu, which is where a run begins and ends. Its root node is
	# named `Screen`, so it is censused off the scene the tree is holding
	# rather than off a name match.
	_run.active = false
	change_scene_to_file("res://scenes/main_menu.tscn")
	for _i in 4:
		await process_frame
	if current_scene != null:
		_census(current_scene, "the main menu")
	print("    CENSUS: %d buttons across %d screens; %d exempt (menus and hover" % [
		_census_buttons, _census_screens, _census_exempt])
	print("    surfaces), %d with nothing connected" % _census_dead.size())
	ok(_census_screens >= 10,
		"§9: only %d screens were censused — the walk did not reach them" % _census_screens)
	ok(_census_buttons >= 100,
		"§9: only %d buttons were censused — the walk read almost nothing" % _census_buttons)
	ok(_census_dead.is_empty(),
		"§9: %d buttons have NOTHING connected to `pressed` — %s" % [
			_census_dead.size(), _census_dead.slice(0, 10)])


# ── §9b — THE NUMBERS ON THE SCREEN AGAINST THE NUMBERS IN THE RUN ─────────
#
# **A NUMBER THAT DISAGREES WITH ITS CARD IS THE DEFECT A PLAYER TRUSTS AND
# THE INSTRUMENTS CANNOT SEE**, because every gate in the tree reads `Run` and
# so does the label. This reads the LABEL — the rendered string on the shipped
# screen — and asks whether it says what the run says, before AND after an act
# that must move it. The second half is the one that catches a screen that
# does not refresh.
func _s9b_the_numbers() -> void:
	print("\n§9b — the numbers on the screen against the numbers in the run")
	var s: Node = await _fresh_map(1)
	_run.gold = 764
	_run.items.clear()
	_run.add_item("health", 2)
	_run.add_item("mana", 1)
	s.call("_draw_screen")
	await process_frame
	ok(_has_text(s, "Gold: %d" % int(_run.gold)),
		"§9b: the map footer does not say `Gold: %d`" % int(_run.gold))
	ok(_has_text(s, "Pouch  %d/%d slots" % [int(_run.slots_used()), int(_run.item_slots())]),
		"§9b: the map footer does not say `Pouch  %d/%d slots`" % [
			int(_run.slots_used()), int(_run.item_slots())])
	# THE HERO CARD'S HP, against the member the card is drawn from.
	var m: Dictionary = _run.party[0]
	m["hp"] = int(int(m["max_hp"]) * 0.5)
	s.call("_draw_screen")
	await process_frame
	# The card writes the bar's numbers with spaces around the slash — the
	# footer's pouch line does not, and reading one shape for both is how a
	# label check passes on the wrong label.
	ok(_has_text(s, "%d / %d" % [int(m["hp"]), int(m["max_hp"])]),
		"§9b: the hero card does not show `%d / %d` after the member's HP moved" % [
			int(m["hp"]), int(m["max_hp"])])
	# THE SHOP, AND THE REFRESH. The gold line must be right on arrival and
	# must MOVE on a purchase — a screen that draws once and never again is a
	# stale label with a correct first frame.
	_run.save_run()
	change_scene_to_file("res://scenes/shop.tscn")
	for _i in 4:
		await process_frame
	var shop: Node = current_scene
	ok(_has_text(shop, "Gold: %d" % int(_run.gold)),
		"§9b: the Peddler does not say `Gold: %d` on arrival" % int(_run.gold))
	ok(_has_text(shop, "pouch: %d/%d slots" % [
			int(_run.slots_used()), int(_run.item_slots())]),
		"§9b: the Peddler's SUPPLIES header does not say `pouch: %d/%d slots`" % [
			int(_run.slots_used()), int(_run.item_slots())])
	var gold_before: int = int(_run.gold)
	var pressed := _press(shop, ["Health"])
	await process_frame
	await process_frame
	var shop2: Node = current_scene
	ok(pressed != "" and int(_run.gold) < gold_before,
		"§9b: nothing could be bought to test the refresh")
	ok(not _has_text(shop2, "Gold: %d" % gold_before),
		"§9b: the Peddler still shows `Gold: %d` after spending — THE SCREEN DID NOT REFRESH"
			% gold_before)
	ok(_has_text(shop2, "Gold: %d" % int(_run.gold)),
		"§9b: the Peddler does not show `Gold: %d` after the purchase" % int(_run.gold))
	# THE HERO SHEET'S RUNE LINE, against the runes actually worn.
	var m0: Dictionary = _run.party[0]
	m0["runes"] = []
	for i in 2:
		var got: Dictionary = _run.grant_rune(m0)
		if got.is_empty():
			break
		got["equipped"] = i == 0
		m0["runes"] = m0.get("runes", []) + [got]
	var worn := 0
	for r in m0.get("runes", []):
		if bool((r as Dictionary).get("equipped", false)):
			worn += 1
	_run.hero_screen_idx = 0
	change_scene_to_file("res://scenes/party.tscn")
	for _i in 4:
		await process_frame
	var sheet: Node = current_scene
	ok(_has_text(sheet, "RUNES  (%d/%d equipped" % [worn, int(_run.rune_slots())]),
		"§9b: the hero sheet does not say `RUNES  (%d/%d equipped`" % [
			worn, int(_run.rune_slots())])
	print("    gold, pouch, hero HP, the shop's refresh and the sheet's rune line all agree")


func _s10_the_observations() -> void:
	print("\n§10 — what the drive saw and is NOT fixing")
	# **SIX FINDINGS, AND NONE OF THEM IS A CRASH OR A SOFTLOCK**, so none is
	# repaired here. Each is asserted where the assertion is cheap and true
	# TODAY, so the day one of them changes the gate says so instead of this
	# paragraph going quietly stale.
	#
	# (1) `battle._break_impact()` RESTORES `Engine.time_scale` TO THE LITERAL
	# 1.0 RATHER THAN TO WHAT IT WAS. It is invisible in play — the scale is
	# always 1.0 there — and it is not invisible to anything that drives the
	# game: this gate measured 561 s for ten battles with the scale set once
	# and 15 s for the same ten with it re-asserted every frame, because the
	# first Break of the run silently cancelled it.
	var battle_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var hits := battle_src.count("Engine.time_scale = 1.0")
	print("    (1) `Engine.time_scale = 1.0` is written %d time(s) in battle.gd —" % hits)
	print("        a hitstop that RESETS rather than restores. Invisible in play;")
	print("        it cost this gate 546 seconds a run before it was found.")
	ok(hits >= 1,
		"§10: battle.gd no longer resets `Engine.time_scale` — finding (1) is stale")
	# (2) THE DEFENSIVE BRACE'S PLAYER BRANCH CANNOT BE REACHED HEADLESS.
	# `_defensive_brace` chooses on `_nobody_can_press()`, which is
	# `sim or autoplay or DisplayServer.get_name() == "headless"` — so under
	# every gate in this project the bot branch is taken and the bar never
	# opens through an attack. **`check_cm_live`'s four standing failures are
	# exactly that** and its own baseline records them as on purpose; what is
	# worth writing down is that they are not four separate defects but one
	# consequence of CQ §1's hang fix, and that the only way to press that bar
	# is a run with a display server.
	print("    (2) the defensive brace's PLAYER branch is unreachable under")
	print("        --headless by construction; check_cm_live's four standing")
	print("        reds are that one fact, not four defects.")
	# (3) THE HERO SHEET DRAWS 27 ENABLED BUTTONS THAT DO NOTHING WHEN PRESSED.
	# `party_screen._make_tree_node` says so in as many words — they are hover
	# surfaces and `disabled` must stay false or the tooltip stops firing — so
	# this is a deliberate shape, not a fault. It is reported because it is the
	# same silhouette as the 604 dead buttons that shipped once, and because
	# §9's census has to know which is which.
	print("    (3) %d enabled Buttons in the census have nothing connected to" % _census_exempt)
	print("        `pressed`: %d HOVER SURFACES (the hero sheet's talent tree)" % _census_hover)
	print("        and %d MENU %s (the map's burger). Both are deliberate," % [
		_census_menu, "button" if _census_menu == 1 else "buttons"])
	print("        and the census exempts them by SIGNATURE, never by name.")
	# (4) `Run.grant_rune` RETURNS A RUNE IT DOES NOT FIT. Its callers append
	# to `member["runes"]` by hand afterwards, so the door that LOOKS like the
	# grant is only the roll. Not a defect today — the callers are COUNTED
	# below rather than restated, because this gate's own first draft called
	# the door and read an empty pouch.
	var callers: Array = []
	for f in ["res://scripts/events.gd", "res://scripts/run_sim.gd",
			"res://scripts/shop_screen.gd", "res://scripts/battle.gd",
			"res://scripts/map_screen.gd", "res://scripts/run_state.gd"]:
		var body: String = Gate.strip_comments(FileAccess.get_file_as_string(String(f)))
		var n2 := body.count("grant_rune(")
		if String(f).ends_with("run_state.gd"):
			n2 -= 1   # the declaration itself
		if n2 > 0:
			callers.append("%s x%d" % [String(f).get_file(), n2])
	print("    (4) `Run.grant_rune` returns a rune and does not FIT it — every")
	print("        caller appends to `member[\"runes\"]` itself: %s" % [callers])
	# (5) TWENTY-FOUR BATTERY TARGETS DESTROY THE PLAYER'S RUN SAVE.
	# `gate_fixture.spawn` sets `run.sim_run = false` and `run.active = true`
	# — it has to, because a `sim_run` battle is not the battle a player
	# fights — and `battle._check_end` then reaches `Run.clear_save()` on a
	# wipe and `Run.save_run()` on a victory. **CENSUSED BEHAVIOURALLY RATHER
	# THAN SAMPLED: every one of the 80 battery targets that reaches a spawn or
	# sets `sim_run` was run ALONE against a fresh copy of a real 62,360 B run
	# save, and the save checked after each. 24 DELETE IT, 56 leave it
	# byte-identical, none overwrites it in place.**
	#
	# **ONLY THIS GATE PROTECTS IT END TO END, AND `check_ct` IS THE
	# CAUTIONARY CASE**: its §2 backs the save up and puts it back, with an arm
	# asserting exactly that which PASSES, and then its §3 spawns a battle that
	# destroys it after the restore. A protection scoped to a section is not a
	# protection, and its own passing arm is what makes that invisible.
	#
	# **AND THE FIRST MEASUREMENT OF THIS REPORTED TWO.** It bisected eight
	# gates, drew mostly document gates, and the number reached five documents
	# before the save went missing again after a seven-target re-run that the
	# "two" did not include. **A SAMPLE IS NOT A POPULATION.**
	#
	# **IT IS NOT REPAIRED HERE** — the brief's rule is that a defect that is
	# not a crash or a softlock is reported and ruled on — but it is why a
	# battery must not be run over a run the designer cares about.
	print("    (5) TWENTY-FOUR of the battery's 80 spawning targets DELETE")
	print("        `user://run_save.bin`. Censused one at a time against a fresh")
	print("        copy of a real save: 24 delete, 56 leave it byte-identical.")
	print("        Only this gate protects it END TO END — check_ct restores it")
	print("        in §2 and its own §3 destroys it again. NOT repaired here.")
	# (6) A BOSS AWARDS NO RUNE — see §3.
	print("    (6) no boss awards a rune. The live rune doors are the Peddler,")
	print("        the elite cache, the bargain's `rune` reward and the event")
	print("        verb `rune_grant`; `_resolve_boss` reaches none of them.")
	if _observations.is_empty():
		print("    the drive itself reported nothing further")
	for o in _observations:
		var n := int(_obs_count.get(o, 1))
		print("    * %s%s" % [o, "" if n == 1 else "   (x%d)" % n])
	ok(_end_boss_screen_seen, "§10: the end boss's own screen was never driven")
	ok(_dead_buttons.is_empty(),
		"§10: %d screens drew a button the drive could not press — %s" % [
			_dead_buttons.size(), _dead_buttons.slice(0, 6)])
