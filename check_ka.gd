# BATCH KA — JZ's RULINGS ANSWERED: THE FIVE KIT CARDS' FIGURES, BUILT; THE TWO NAMES, RULED.
#
# What this gate asserts, section by section (`docs/reports/KA.md` has the working):
#
#   §1  THE FIGURES AT THEIR SOURCE (JZ's ruling 1, the designer's): Nexus Ward a quarter of the Mage's
#       maximum, Ministration 35% of the ally's and its Perfect 45%, Unburden's cut 30%, Magic Missiles
#       5 Break damage a bolt over its three bolts — and Consecration HELD at its 5%, the one of the five
#       the ruling left as it stood.
#   §2  THE CARDS READ THEM: the texts of Nexus Ward, Ministration (and its Perfect) and Unburden, built by the
#       game, state their new figures; Missiles' card states no Break figure, so §1 and §3 hold it.
#   §3  THE CASTS PAY THEM: on a board of heroes holding no engine, the ward, the three bolts, the heal at
#       Good and at Perfect, and the cut against the same blow twice, each against its own figure and
#       not the one it replaced.
#   §4  THE ONE COMPARISON THE FIGURES MOVED THAT A COMMENT NOW STATES: Missiles' Break damage a bolt
#       sits under Razor Ice's and above Arcane Barrage's.
#   §5  THE TWO NAMES ARE RULED AND THE BUILD IS NOT (JZ's ruling 2; KA's ruling 1): the Tracker and the
#       Skirmisher are still the Hunter's rule engines under their old names, and the Hunter still holds
#       six. A batch that builds the conversion reds here, and takes the RULED, NOT BUILT marker off with it.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the figures are right — the
# shield figures rest on an assumed blow rate (FOUND AT JZ) and the sim reads the party's whole fight, not a
# card; and Volley's and the Ambusher's rules, which nobody has written (KA's ruling 1). Helpers `_hero`,
# `_foes`, `_clear`, `_reset_foe`, `_ready_to_cast` and `_blow` are `check_gn`'s shapes; the battle comes
# from `Gate.spawn`, the one fixture.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const NO_LINEAGE := ["", "", "", ""]
const SEED := 20261117
const SCRATCH_PROFILE := "user://ka_profile.json"
const SCRATCH_RELICS := "user://ka_relics.json"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KA — THE KIT CARDS' FIGURES, BUILT; THE TWO NAMES, RULED")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a fight is spawned")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	await _s1_to_s3()
	_s4_the_comparison()
	_s5_the_names_ruled()
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


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not e.dead)


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _reset_foe(e: BattleUnit) -> void:
	e.max_hp = 100000
	e.hp = e.max_hp
	e.pressure = 0
	e.broken = false
	e.broken_pending = false
	for st in e.statuses.duplicate():
		e.remove_status(String(st.id))


func _ready_to_cast(u: BattleUnit) -> void:
	u.resource = u.max_resource
	u.cooldowns.clear()


# A constant of the battle script, read off the script's own constant map (never a second copy).
func _k(s: Node, n: String) -> float:
	var m: Dictionary = (s.get_script() as Script).get_script_constant_map()
	return float(m.get(n, -1.0))  # a missing name reads -1, which every figure check reds on


func _card(u: BattleUnit, n: String) -> Ability:
	for a in u.abilities:
		if a != null and String((a as Ability).display_name) == n:
			return a
	return null


func _blow(s: Node, foe: BattleUnit, victim: BattleUnit) -> int:
	var mhp_was := victim.max_hp
	var atk_was := foe.attack
	victim.max_hp = 100000
	victim.hp = victim.max_hp
	victim.pressure = 0
	victim.broken = false
	foe.attack = maxi(atk_was, 400)
	foe.cooldowns.clear()
	seed(SEED + 7)
	var before := victim.hp
	await s._resolve(foe, foe.abilities[0], victim, "good")
	var lost := before - victim.hp
	foe.attack = atk_was
	victim.max_hp = mhp_was
	victim.hp = mhp_was
	victim.pressure = 0
	victim.broken = false
	return lost


# ── §1–§3 — THE FIGURES, THE TEXTS, THE CASTS ───────────────────────────────

func _s1_to_s3() -> void:
	print("\n§1 — the five figures at their source")
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	ok(is_equal_approx(_k(s, "NEXUS_WARD_PCT"), 0.25), "§1: Nexus Ward is a quarter of the Mage's maximum (%s)" % str(_k(s, "NEXUS_WARD_PCT")))
	ok(is_equal_approx(_k(s, "MINISTRATION_PCT"), 0.35), "§1: Ministration heals 35%% of the ally's maximum (%s)" % str(_k(s, "MINISTRATION_PCT")))
	ok(is_equal_approx(_k(s, "MINISTRATION_PERFECT_PCT"), 0.45),
		"§1: Ministration's Perfect heals 45%% (%s), its own constant" % str(_k(s, "MINISTRATION_PERFECT_PCT")))
	ok(is_equal_approx(_k(s, "UNBURDEN_CUT"), 0.30), "§1: Unburden cuts 30%% of a strike (%s)" % str(_k(s, "UNBURDEN_CUT")))
	ok(is_equal_approx(_k(s, "CONSECRATION_PCT"), 0.05),
		"§1: Consecration is HELD at 5%% a turn (%s) — the ruling left it as it stood" % str(_k(s, "CONSECRATION_PCT")))
	var mm: Ability = Classes.pool_ability("Magic Missiles")
	ok(mm != null and mm.pressure == 5 and mm.multi_hits == 3,
		"§1: Magic Missiles carries 5 Break damage a bolt over 3 bolts (%s)" % (
			"%d x %d" % [mm.pressure, mm.multi_hits] if mm != null else "no card"))

	print("\n§2 — the cards read them")
	var texts := {
		"Nexus Ward": ["description", "25% of the"],
		"Ministration": ["description", "for 35%"],
		"Unburden": ["description", "take 30%"],
	}
	for nm in texts:
		var ab: Ability = Classes.pool_ability(nm)
		var field: String = texts[nm][0]
		var want: String = texts[nm][1]
		var got := String(ab.get(field)) if ab != null else ""
		ok(got.contains(want), "§2: %s's card says %s (%s)" % [nm, want, got.replace("\n", " ")])
	var mn: Ability = Classes.pool_ability("Ministration")
	ok(mn != null and String(mn.perfect_text).contains("{mhp:45|ally}"),
		"§2: Ministration's Perfect reads 45 (%s)" % (String(mn.perfect_text) if mn != null else "no card"))

	print("\n§3 — the casts pay them")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var W := _hero(s, "warrior")
	var H := _hero(s, "hunter")
	if [M, C, W, H].any(func(h): return h == null):
		ok(false, "§3: the board seats one hero of each class")
		await _clear(s)
		return
	var foes := _foes(s)
	var e0: BattleUnit = foes[0]
	var striker: BattleUnit = e0
	for e in foes:
		if not e.is_ranged:
			striker = e
			break
	for e in foes:
		_reset_foe(e)
	# The ward.
	var ward_ab := _card(M, "Nexus Ward")
	if ward_ab == null:
		ok(false, "§3: the Mage holds Nexus Ward")
	else:
		_ready_to_cast(M)
		await s._resolve_special(M, ward_ab, M, "good", 1.0)
		var ward := int(M.status_power("barrier")) if M.has_status("barrier") else -1
		ok(ward == int(round(M.max_hp * 0.25)) and ward != int(round(M.max_hp * 0.20)),
			"§3: Nexus Ward raises %d on a Mage of %d — a quarter, not the fifth it replaced (%d)" % [
				ward, M.max_hp, int(round(M.max_hp * 0.20))])
		M.remove_status("barrier")
	# The three bolts: each bolt's Break damage is divided by the target's Constitution (`unit.gd`).
	var bolts := _card(M, "Magic Missiles")
	if bolts == null:
		ok(false, "§3: the Mage holds Magic Missiles")
	else:
		_ready_to_cast(M)
		_reset_foe(e0)
		await s._resolve(M, bolts, e0, "good")
		var per_bolt := int(round(5 * 100.0 / maxf(float(e0.constitution), 1.0)))
		ok(e0.pressure == 3 * per_bolt and e0.pressure > 3 * int(round(3 * 100.0 / maxf(float(e0.constitution), 1.0))),
			"§3: three Good bolts lay %d Break damage on a body of Constitution %d (%d a bolt)" % [
				e0.pressure, e0.constitution, per_bolt])
		_reset_foe(e0)
	# The heal, at Good and at Perfect, off the TARGET's maximum.
	var mend := _card(C, "Ministration")
	if mend == null:
		ok(false, "§3: the Cleric holds Ministration")
	else:
		for grade in ["good", "perfect"]:
			_ready_to_cast(C)
			W.hp = 1
			await s._resolve_special(C, mend, W, grade, 1.0)
			var pct := 0.45 if grade == "perfect" else 0.35
			ok(W.hp - 1 == int(round(W.max_hp * pct)),
				"§3: a %s Ministration heals the Warrior %d — %d%% of HIS maximum (%d)" % [
					grade.capitalize(), W.hp - 1, int(round(pct * 100)), W.max_hp])
			W.hp = W.max_hp
	# The cut, against the same blow twice.
	var lift := _card(C, "Unburden")
	if lift == null:
		ok(false, "§3: the Cleric holds Unburden")
	else:
		_ready_to_cast(C)
		await s._resolve_special(C, lift, H, "good", 1.0)
		var had := H.has_status("unburdened")
		var lost := await _blow(s, striker, H)
		H.remove_status("unburdened")
		var lost_plain := await _blow(s, striker, H)
		ok(had and lost_plain > 0 and absf(float(lost) / float(lost_plain) - 0.70) <= 0.05,
			"§3: Unburdened, the Hunter takes %d of the %d the same blow deals bare — 30%% less" % [lost, lost_plain])
	await _clear(s)


# ── §4 — THE COMPARISON THE COMMENT STATES ──────────────────────────────────

func _s4_the_comparison() -> void:
	print("\n§4 — Missiles' Break damage a bolt, between its two siblings")
	var mm: Ability = Classes.pool_ability("Magic Missiles")
	var razor: Ability = Classes.pool_ability("Razor Ice")
	var barrage: Ability = Classes.pool_ability("Arcane Barrage")
	ok(mm != null and razor != null and barrage != null
			and barrage.pressure < mm.pressure and mm.pressure < razor.pressure,
		"§4: Magic Missiles' Break damage a bolt sits above Arcane Barrage's and under Razor Ice's (%s)" % (
			"%d < %d < %d" % [barrage.pressure, mm.pressure, razor.pressure] if mm != null and razor != null and barrage != null else "a card missing"))


# ── §5 — THE TWO NAMES RULED, THE BUILD NOT ─────────────────────────────────

func _s5_the_names_ruled() -> void:
	print("\n§5 — the Tracker and the Skirmisher: named, not yet converted")
	var re: Dictionary = Classes.RULE_ENGINES
	ok(re.has("quarry_hunt") and String(re["quarry_hunt"]["name"]) == "Tracker"
			and re.has("opening_strike") and String(re["opening_strike"]["name"]) == "Skirmisher",
		"§5: both are still the Hunter's rule engines under their old names — the conversion to Common Foe and Pounce waits on Volley's and the Ambusher's rules")
	var hunter: Array = Classes.class_engines("hunter")
	ok(hunter.size() == 6 and hunter.has("quarry_hunt") and hunter.has("opening_strike"),
		"§5: the Hunter holds six engines, the two among them (%s)" % str(hunter))


func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
