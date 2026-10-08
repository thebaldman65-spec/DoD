# BATCH HV — DOWNWIND CARRIES AFFLICTIONS, NOT A CARD'S OWN BOOKKEEPING.
#
# What this gate asserts, section by section (`docs/reports/HV.md` has the working):
#
#   §2a  THE RULE'S POSITIVE HALF: every affliction a hero can lay through the status door is
#        carried — laid on one enemy with a Downwind standing, it stands on a second as well.
#   §2b  VENDETTA'S LOCK IS NOT CARRIED (ruled): it binds its own enemy for the fight and no
#        second, Carrion or not — and a Mocking Blow's timed taunt, an affliction, still is.
#   §2c  SNARE TRAP'S SNARE IS NOT CARRIED (ruled): it stands on its own body with his seat and
#        springs there on its turn; once it is spent the Hunter can lay his next trap — the arm
#        that would have caught the copy holding his slot — and the spring's Poison is carried.
#   §2d  A COPIED POISON TAKES ITS ROUTE'S STAMPS (ruled): an uncleansable poison's copy is
#        uncleansable, and carries its original's full duration; an ordinary one's is ordinary.
#   §2e  A COPIED RUIN STACK TAKES `_gain_ruin` (ruled): a copy that lands a body on the
#        threshold primes its detonation, and a Covenant of Ash takes the copy's share.
#   §2f  THE WORDS: the card, the chip and the cast's line name what the wind leaves alone.
#   §5   The rule recorded where the rules live.
#   §9   The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: a Frostbind's copy, which is
# still a chip with no partner — the brief routed it and the rule names it a binding, and which
# body a copied end binds to is owed a ruling (printed below, never asserted). `Run` is fetched
# off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://hv_profile.json"
const SCRATCH_RELICS := "user://hv_relics.json"
# A Warden (Vendetta, the taunts), a Cryomancer, an Occultist holding the Old Gods (every Ruin
# write needs a living holder) and a Survivalist (Downwind, Snare Trap, his poison).
const PARTY := ["warden", "cryomancer", "occultist", "mystic"]
const FRAME_CAP := 900

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HV — DOWNWIND CARRIES AFFLICTIONS, NOT A CARD'S OWN BOOKKEEPING")
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
	await _s2a_every_affliction()
	await _s2b_vendetta()
	await _s2c_snare_trap()
	await _s2d_poison_route()
	await _s2e_ruin_route()
	await _s2f_the_words()
	_s5_the_record()
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


func _board(opts: Dictionary = {}) -> Node:
	var o := {"deterministic": true}
	o.merge(opts, true)
	var scene: Node = await Gate.spawn(self, PARTY, o)
	Engine.time_scale = 50.0
	return scene


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


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


# A clean body: no status, full health, an unbroken meter — so one drive cannot hand the
# next one a softened board.
func _wipe(u: BattleUnit) -> void:
	u.statuses = []
	u.broken = false
	u.broken_pending = false
	u.pressure = 0
	u.max_hp = maxi(u.max_hp, 100000)
	u.hp = u.max_hp
	u._refresh_chips()


func _wipe_all(s: Node) -> void:
	for u in (s.get("heroes") as Array) + (s.get("enemies") as Array):
		if not u.dead:
			_wipe(u)
	(s.get("_holds") as Array).clear()


func _engine(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


func _others_with(s: Node, not_this: BattleUnit, id: String) -> Array:
	return _foes(s).filter(func(f): return f != not_this and f.has_status(id))


# The hero whose turn is parked on a press, once the turn loop has handed one over.
func _hero_turn(s: Node) -> BattleUnit:
	var waited := 0
	while waited < FRAME_CAP:
		var cur: BattleUnit = s.get("current_hero")
		if cur != null and not cur.dead and bool(s.get("action_panel").visible) \
				and not bool(s.get("sc_active")) and (s.get("_kb_pool") as Array).is_empty():
			return cur
		await process_frame
		waited += 1
	return null


# Passes a turn the way a player would who wanted nothing on it: the basic attack, aimed.
func _pass_turn(s: Node, cur: BattleUnit) -> void:
	s._on_ability_button(cur.abilities[0])
	var waited := 0
	while (s.get("_kb_pool") as Array).is_empty() and waited < FRAME_CAP:
		await process_frame
		waited += 1
	if not (s.get("_kb_pool") as Array).is_empty():
		s._target_picked.emit(_foes(s)[0])
	await Gate.frames(self, 2)


# ── §2a — EVERY AFFLICTION A HERO CAN LAY IS CARRIED ───────────────────────

func _s2a_every_affliction() -> void:
	print("\n§2a — every affliction a hero can lay through the door is carried")
	var s: Node = await _board()
	var war: BattleUnit = _hero(s, "warrior")
	var hunter: BattleUnit = _hero(s, "hunter")
	var info: Dictionary = s.STATUS_INFO
	var seat: int = (s.get("heroes") as Array).find(war)
	var pop: Array = []
	var left_out := {}
	for id in BattleUnit.DEBUFF_IDS:
		if id == "broken":
			left_out[id] = "the carry excludes it by name"
		elif id == "rupture":
			left_out[id] = "formed at the door, never laid"
		elif not info.has(id):
			left_out[id] = "no status row: a meter or a field, never laid through the door"
		else:
			pop.append(String(id))
	var missed: Array = []
	for id2 in pop:
		_wipe_all(s)
		s._apply_status(hunter, "downwind", 4)
		var a: BattleUnit = _foes(s)[0]
		var power := seat if id2 in ["mocked", "snared"] else (15 if id2 == "elem_weak" else 0)
		var tick := 3 if id2 in ["burn", "poison"] else 0
		s._apply_status(a, id2, 3, power, tick, war)
		if not a.has_status(id2) or _others_with(s, a, id2).is_empty():
			missed.append("%s (on its own body %s)" % [id2, a.has_status(id2)])
	print("    CHECKED %d of %d afflictions laid by a hero, each on one enemy with Downwind standing; left out: %s" % [
		pop.size(), (BattleUnit.DEBUFF_IDS as Array).size(), str(left_out)])
	ok(pop.size() >= 25, "§2a: the population read %d afflictions" % pop.size())
	ok(missed.is_empty(), "§2a: Downwind did not carry %s" % str(missed))
	# Frostbind, recorded and not asserted: the copy is still a chip with no partner (owed a ruling).
	_wipe_all(s)
	s._apply_status(hunter, "downwind", 4)
	var fa: BattleUnit = _foes(s)[0]
	s._apply_status(fa, "frostbind", 3, 0, 0, _hero(s, "mage"))
	var fcopy: Array = _others_with(s, fa, "frostbind")
	print("    [record] a carried Frostbind: %d copies, partner %s — owed a ruling, not asserted" % [fcopy.size(),
		str(fcopy.map(func(f): return String(f.get_status("frostbind").get("partner", "")))) ])
	await _clear(s)


# ── §2b — VENDETTA'S LOCK IS NOT CARRIED; A TIMED TAUNT IS ─────────────────

func _s2b_vendetta() -> void:
	print("\n§2b — Vendetta's lock is the card's own, and stays on its own enemy")
	for carrion in [false, true]:
		var over := {}
		if carrion:
			over = {3: {"runes": [_engine("carrion")]}}
		var s: Node = await _board({"party": over})
		var war: BattleUnit = _hero(s, "warrior")
		var hunter: BattleUnit = _hero(s, "hunter")
		var tag := "with Carrion" if carrion else "without Carrion"
		ok(hunter.rune_carrion > 0 if carrion else hunter.rune_carrion <= 0,
			"§2b: the Hunter's Carrion reads %d %s" % [hunter.rune_carrion, tag])
		var seat: int = (s.get("heroes") as Array).find(war)
		_wipe_all(s)
		s._apply_status(hunter, "downwind", 4)
		var a: BattleUnit = _foes(s)[0]
		var vd: Ability = Classes.pool_ability("Vendetta")
		war.resource = 99999
		var lw := _log_text(s).length()
		await s._resolve(war, vd, a, "good")
		var lock: Dictionary = a.get_status("mocked")
		ok(not lock.is_empty() and int(lock.get("turns", 0)) < 0 and a.status_power("mocked") == seat
				and a.has_status("vendetta"),
			"§2b %s: Vendetta did not bind its own enemy for the fight (%s)" % [tag, str(lock)])
		var locked: Array = _others_with(s, a, "mocked")
		var vd_line := _log_text(s).substr(lw)
		print("    %s: Vendetta on %s — locked %s, and %d other bodies taunted" % [tag, a.unit_name,
			not lock.is_empty(), locked.size()])
		ok(locked.is_empty(), "§2b %s: Downwind locked %d more enemies onto him: %s" % [tag, locked.size(),
			str(locked.map(func(f): return f.unit_name))])
		ok(not vd_line.contains("Downwind: Mocked carries"),
			"§2b %s: the log has Downwind carrying Vendetta's lock" % tag)
		# The positive: a Mocking Blow's taunt is an affliction, and the wind carries it. The card taunts
		# two bodies itself, so the carry is read off its own line rather than a count of the taunted.
		_wipe_all(s)
		s._apply_status(hunter, "downwind", 4)
		var mb: Ability = s._find_ability(war, "Mocking Blow")
		ok(mb != null, "§2b: the Warrior holds no Mocking Blow")
		if mb != null:
			war.resource = 99999
			war.cooldowns.clear()
			var lw2 := _log_text(s).length()
			await s._resolve(war, mb, a, "good")
			ok(a.has_status("mocked") and _log_text(s).substr(lw2).contains("Downwind: Mocked carries"),
				"§2b %s: a Mocking Blow's taunt was not carried — the rule leaves a card's bookkeeping, not every taunt" % tag)
		await _clear(s)


# ── §2c — SNARE TRAP'S SNARE IS NOT CARRIED ────────────────────────────────

func _s2c_snare_trap() -> void:
	print("\n§2c — Snare Trap's snare is a trap slot, and stays on its own body")
	var s: Node = await _board()
	var hunter: BattleUnit = _hero(s, "hunter")
	var seat: int = (s.get("heroes") as Array).find(hunter)
	var snare: Ability = s._find_ability(hunter, "Snare Trap")
	ok(snare != null, "§2c: the Hunter holds no Snare Trap")
	if snare == null:
		await _clear(s)
		return
	_wipe_all(s)
	s._apply_status(hunter, "downwind", 4)
	var a: BattleUnit = _foes(s)[0]
	hunter.resource = 99999
	var lw0 := _log_text(s).length()
	await s._resolve(hunter, snare, a, "good")
	ok(not _log_text(s).substr(lw0).contains("Downwind: Snared carries"),
		"§2c: the log has Downwind carrying the snare")
	ok(a.has_status("snared") and a.status_power("snared") == seat,
		"§2c: the snare does not stand on its own body with his seat (%s)" % str(a.get_status("snared")))
	var copies: Array = _others_with(s, a, "snared")
	ok(copies.is_empty(), "§2c: Downwind laid %d more snares with his seat: %s" % [copies.size(),
		str(copies.map(func(f): return f.unit_name))])
	# Once the snare on its own body is spent — as its spring spends it — his slot is free.
	a.remove_status("snared")
	hunter.cooldowns.clear()
	ok(bool(s._ability_usable(hunter, snare)),
		"§2c: with his own snare spent, the Hunter cannot lay his next trap — a copy holds his slot")
	# The spring's Poison is an affliction, laid by `_apply_poison` with him as its source: carried.
	_wipe_all(s)
	s._apply_status(hunter, "downwind", 4)
	s._apply_poison(hunter, a, 4)
	ok(a.has_status("poison") and not _others_with(s, a, "poison").is_empty(),
		"§2c: the spring's Poison was not carried — the wind leaves the trap, not what it lays")
	# And the snare still springs on its own body, through the real turn.
	_wipe_all(s)
	s._apply_status(hunter, "downwind", 4)
	hunter.resource = 99999
	hunter.cooldowns.clear()
	await s._resolve(hunter, snare, a, "good")
	var lw := _log_text(s).length()
	var sprang := false
	for _turn in 10:
		var cur: BattleUnit = await _hero_turn(s)
		if cur == null:
			break
		if not a.has_status("snared"):
			sprang = true
			break
		cur.max_hp = maxi(cur.max_hp, 100000)
		cur.hp = cur.max_hp
		await _pass_turn(s, cur)
	var line := _log_text(s).substr(lw)
	print("    the snare on %s sprang %s; the spring's line %s" % [a.unit_name, sprang,
		line.contains("snare springs on %s" % a.unit_name)])
	ok(sprang and line.contains("snare springs on %s" % a.unit_name),
		"§2c: the snare did not spring on its own body through the turn (sprang %s)" % sprang)
	await _clear(s)


# ── §2d — A COPIED POISON TAKES ITS ROUTE'S STAMPS ─────────────────────────

func _s2d_poison_route() -> void:
	print("\n§2d — a copied poison takes its route's stamps")
	var s: Node = await _board()
	var hunter: BattleUnit = _hero(s, "hunter")
	# `slow_acting` is a field nothing live writes (HT §2f's dormant poison family); it is set here
	# because it is what stamps a poison uncleansable, and a copy must carry the stamp it buys.
	for sticky in [true, false]:
		_wipe_all(s)
		s._apply_status(hunter, "downwind", 4)
		hunter.slow_acting = 1 if sticky else 0
		var a: BattleUnit = _foes(s)[0]
		s._apply_poison(hunter, a, 3)
		var orig: Dictionary = a.get_status("poison")
		var holders: Array = _others_with(s, a, "poison")
		ok(not orig.is_empty() and not holders.is_empty(), "§2d: the poison was not carried (sticky %s)" % sticky)
		if orig.is_empty() or holders.is_empty():
			continue
		var cp_body: BattleUnit = holders[0]
		var cp: Dictionary = cp_body.get_status("poison")
		print("    sticky %s: the original reads sticky %s, full %d; the copy on %s reads sticky %s, full %d" % [sticky,
			bool(orig.get("sticky", false)), int(orig.get("full", 0)), cp_body.unit_name,
			bool(cp.get("sticky", false)), int(cp.get("full", 0))])
		ok(bool(orig.get("sticky", false)) == sticky, "§2d: the original's sticky reads %s — the fixture's premise" % [
			orig.get("sticky", false)])
		ok(bool(cp.get("sticky", false)) == sticky,
			"§2d: a copied poison reads sticky %s where its original reads %s" % [cp.get("sticky", false), sticky])
		ok(cp.has("full") and int(cp.get("full", 0)) == int(orig.get("full", -99)),
			"§2d: a copied poison's full duration reads %s, its original's %s" % [cp.get("full", "none"),
				orig.get("full", "none")])
		cp_body.purge_debuffs()
		ok(cp_body.has_status("poison") == sticky,
			"§2d: a cleanse on the copy left its poison %s — want %s, as on its original" % [
				cp_body.has_status("poison"), sticky])
	hunter.slow_acting = 0
	await _clear(s)


# ── §2e — A COPIED RUIN STACK TAKES `_gain_ruin` ───────────────────────────

func _s2e_ruin_route() -> void:
	print("\n§2e — a copied Ruin stack takes the route a stack arrives by")
	var s: Node = await _board()
	var hunter: BattleUnit = _hero(s, "hunter")
	var occ: BattleUnit = _hero(s, "cleric")
	ok(occ != null and occ.has_engine("old_gods"), "§2e: no Old Gods holder stands — every Ruin write needs one")
	var foes := _foes(s)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	var step := int(s._ruin_threshold())
	# B and C stand one stack short of the threshold, laid with no applier so no carry fires first;
	# whichever the copy reaches lands on the threshold.
	_wipe_all(s)
	for f in [b, c]:
		s._apply_status(f, "ruin", -1)
		f.set_ruin_stacks(step - 1)
	s._apply_status(hunter, "downwind", 4)
	s._gain_ruin(a, 1)
	var reached: Array = [b, c].filter(func(f): return f.status_stacks("ruin") >= step)
	print("    threshold %d: the copy reached %s; primed %s" % [step, str(reached.map(func(f): return f.unit_name)),
		str(reached.map(func(f): return f.has_status("ruin_primed")))])
	ok(reached.size() == 1, "§2e: the copy brought %d of the two bodies to the threshold" % reached.size())
	if reached.size() == 1:
		ok((reached[0] as BattleUnit).has_status("ruin_primed"),
			"§2e: a copy landed %s on the threshold and did not prime its detonation" % (reached[0] as BattleUnit).unit_name)
	# The Covenant: C bears it and already carries Ruin, so B is the one fresh body the carry reaches.
	_wipe_all(s)
	s._apply_status(c, "covenant", -1, 0, 0, occ)
	s._apply_status(c, "ruin", -1)
	var c0 := c.status_stacks("ruin")
	s._apply_status(hunter, "downwind", 4)
	s._gain_ruin(a, 1)
	var c_rise := c.status_stacks("ruin") - c0
	print("    one stack laid on the first body, the Covenant on the third: the copy on the fresh body reads %d, the bearer rose %d" % [
		b.status_stacks("ruin"), c_rise])
	ok(b.status_stacks("ruin") >= 1, "§2e: the carry did not reach %s, the one fresh body" % b.unit_name)
	ok(c_rise >= 2, "§2e: the Covenant took %d stacks — want its share of the stack and of the copy" % c_rise)
	await _clear(s)


# ── §2f — THE WORDS ────────────────────────────────────────────────────────

func _s2f_the_words() -> void:
	print("\n§2f — the card, the chip and the cast's line name what the wind leaves alone")
	var dw: Ability = Classes.pool_ability("Downwind")
	ok(dw != null and String(dw.description).contains("Vendetta's lock"),
		"§2f: Downwind's card does not name the lock the wind leaves alone")
	ok(dw != null and String(dw.description).contains("snare"),
		"§2f: Downwind's card does not name the snare the wind leaves alone")
	var s: Node = await _board()
	ok(String(s.STATUS_INFO["downwind"][3]).contains("Vendetta's lock"),
		"§2f: Downwind's chip does not name the lock the wind leaves alone")
	var hunter: BattleUnit = _hero(s, "hunter")
	var lw := _log_text(s).length()
	hunter.resource = 99999
	await s._resolve(hunter, dw, hunter, "good")
	ok(_log_text(s).substr(lw).contains("never a snare, nor Vendetta's lock"),
		"§2f: the cast's line does not name what the wind leaves alone")
	await _clear(s)


# ── §5 — THE RULE, RECORDED WHERE THE RULES LIVE ───────────────────────────

func _s5_the_record() -> void:
	print("\n§5 — the rule recorded where the rules live")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("NEVER A CARD'S OWN BOOKKEEPING"),
		"§5: CLAUDE.md does not record that a carrier never carries a card's own bookkeeping")


# ── §9 — THE PLAYER'S FILES ────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
