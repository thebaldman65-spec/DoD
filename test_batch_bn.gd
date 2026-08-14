# test_batch_bn.gd — THE CRASH, AND THE GATE. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bn.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize) and does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion, every check
# drives the hold machinery by hand.
#
# WHAT IT PROTECTS. §1 is a re-entrancy guard against a DETERMINISTIC two-body
# cycle, and the guard is the only thing preventing it: `_hold_release` chills
# its own target back to four stacks (Honed Shards) while `_hold_freeze` evicts
# and releases past the limit, so at a limit of 1 two enemies ping-pong until
# the stack limit. THREE OF THE CHECKS BELOW WOULD PASS ON BROKEN CODE IF THEY
# WERE WRITTEN THE OBVIOUS WAY, which is why each is built as its own scene:
#   · "the release does not re-freeze" is trivially true if the release never
#     applied the stacks at all — so the stack COUNT is asserted beside it;
#   · "the guard fixed the crash" is trivially true if the guard also refuses
#     every legitimate freeze — so the RE-ARM case is driven (an enemy parked
#     at the cap must still be freezable by a later chill);
#   · "Cryoclasm is unaffected" is trivially true if Cryoclasm never worked —
#     so the moved hold is asserted to LAND, not merely to be un-refused.
extends SceneTree

# §2's shipped value, and the whole point of the sweep: the rung-1 multiplier
# was chosen by measuring untalented completion at four values, not by guess.
const RUNG1_MULT := 0.50
const RUNG2_MULT := 1.00
const RUNG3_MULT := 1.30

var checks := 0
var fails: Array = []
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()

const REAL_SAVE := "user://run_save.bin"


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bn_test.json"
	Profile.loaded = false
	Profile.data = {}

	_source_guard()
	_difficulty_table()
	await _live_release_no_refreeze()
	await _live_eviction_completes()
	await _live_ice_lance_no_retake()
	await _live_cryoclasm_unaffected()
	await _live_rearm()
	await _live_guard_clears()
	_docs()

	# Restore the player's save byte-for-byte — the live half calls new_run.
	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	var scratch := "user://profile_batch_bn_test.json"
	if FileAccess.file_exists(scratch):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))

	print("\n=== BATCH BN ===")
	print("checks: %d   failures: %d" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit()


# ---------- §1 SOURCE: the shape of the guard ----------

func _source_guard() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("var _releasing := false"),
		"§1: the re-entrancy flag exists and is declared once")
	ok(src.count("var _releasing") == 1, "§1: ...exactly once")
	# ONE setter, ONE clearer. A second pair is how a flag starts leaking.
	ok(src.count("_releasing = true") == 1, "§1: exactly one site SETS the flag")
	ok(src.count("_releasing = false") == 1, "§1: exactly one site CLEARS it")
	# The wrapper is what makes the clear unconditional: GDScript has no
	# `finally` and the body carries an early return.
	ok(src.contains("_releasing = true\n\t_hold_release_body(target, reason)\n\t_releasing = false"),
		"§1: the flag brackets the body in ONE place, so no return path can leak it")
	ok(src.contains("func _hold_release_body("),
		"§1: ...and the body is its own function for that reason")
	# The early return is the FIRST thing _hold_freeze does. Below the dead /
	# already-frozen checks it would still be correct today, but it is above
	# them so no clause added later can slip in ahead of it.
	var fz := src.find("func _hold_freeze(target: BattleUnit, src: BattleUnit) -> void:")
	ok(fz > 0, "§1: _hold_freeze is where it was")
	if fz > 0:
		var body := src.substr(fz, 700)
		var guard := body.find("if _releasing:")
		var dead := body.find("if target.dead or target.has_status(\"frozen\"):")
		ok(guard > 0 and dead > 0 and guard < dead,
			"§1: the guard is the FIRST gate in _hold_freeze")
	# THE RE-ARM IS A PROPERTY OF THE THRESHOLD CHECK AND IT WAS READ, NOT
	# ASSUMED (§1's first verification). It is `>= 4`, i.e. it reads BEING at
	# four rather than REACHING four, so an enemy parked at the cap with its
	# freeze refused is frozen by the very next chill. An `== 4` here would
	# make the guard leave enemies permanently unfreezable, which would be a
	# worse bug than the crash and a silent one.
	ok(src.contains("if target.status_stacks(\"chilled\") >= 4 and not target.has_status(\"frozen\"):"),
		"§1: the flash-freeze threshold reads >= 4 (AT the cap), not == 4 (REACHING it)")
	# Cryoclasm moves a hold and is deliberately not a release. The guard can
	# only reach it if something in that branch sets the flag.
	var cc := src.find("\"cryoclasm\":")
	ok(cc > 0, "§1: the Cryoclasm branch is where it was")
	if cc > 0:
		var cc_body := src.substr(cc, 1800)
		ok(not cc_body.contains("_hold_release("),
			"§1: Cryoclasm still does NOT route through _hold_release")
		ok(cc_body.contains("_hold_freeze(target, attacker)"),
			"§1: ...and still ends in a freeze, which the guard must not refuse")
	# Both magnitudes the fix deliberately did NOT touch.
	ok(src.contains("const HOLD_RELEASE_STACKS := 1"),
		"§1: the release still comes back on 1 stack — no magnitude moved")
	var tal := _src("res://scripts/talents.gd")
	ok(tal.contains("\"payload\": {\"stat\": {\"honed_shards_ranks\": 3}}"),
		"§1: Honed Shards still applies 3 — the guard fixes control flow, not numbers")


# ---------- §2 THE LADDER ----------

func _difficulty_table() -> void:
	var run := root.get_node("/root/Run")
	ok(run != null, "§2: Run resolves")
	if run == null:
		return
	run.difficulty = "wanderer"
	ok(is_equal_approx(float(run.difficulty_mult()), RUNG1_MULT),
		"§2: rung 1 reads its NEW multiplier %.2f (got %.2f)" % [
			RUNG1_MULT, float(run.difficulty_mult())])
	ok(int(run.difficulty_rung()) == 1, "§2: ...and it is still rung 1")
	# RUNGS 2 AND 3 DO NOT MOVE, and this is asserted rather than assumed
	# because a batch that moved rung 1 is exactly where a later reader would
	# assume all three moved. Rung 2 IS the present balance byte for byte,
	# which is what keeps every BK-and-earlier row readable.
	run.difficulty = "warden"
	ok(is_equal_approx(float(run.difficulty_mult()), RUNG2_MULT),
		"§2: RUNG 2 IS UNTOUCHED at x1.00 — every pre-BN row still describes it")
	ok(int(run.difficulty_rung()) == 2, "§2: ...and is still rung 2")
	run.difficulty = "ruin"
	ok(is_equal_approx(float(run.difficulty_mult()), RUNG3_MULT),
		"§2: RUNG 3 IS UNTOUCHED at x1.30")
	ok(int(run.difficulty_rung()) == 3, "§2: ...and is still rung 3")
	# The two twists are not this batch's either.
	run.difficulty = "wanderer"
	ok(int(run.difficulty_def()["severity_floor"]) == 2
			and not bool(run.difficulty_def()["fixed_modifier"]),
		"§2: rung 1's twists are unchanged (floor 2, no fixed modifier)")
	run.difficulty = "warden"
	ok(int(run.difficulty_def()["severity_floor"]) == 3
			and not bool(run.difficulty_def()["fixed_modifier"]),
		"§2: rung 2's twists are unchanged (floor 3)")
	run.difficulty = "ruin"
	ok(int(run.difficulty_def()["severity_floor"]) == 4
			and bool(run.difficulty_def()["fixed_modifier"]),
		"§2: rung 3's twists are unchanged (floor 4, fixed modifier on)")
	# DOD_SIM_DIFFICULTY still arms each rung — that is the env read, and it
	# goes through difficulty_id, which is also what makes Batch Y's ids resolve.
	ok(String(run.difficulty_id("wanderer")) == "wanderer"
			and String(run.difficulty_id("warden")) == "warden"
			and String(run.difficulty_id("ruin")) == "ruin",
		"§2: DOD_SIM_DIFFICULTY arms all three rungs by name")
	ok(String(run.difficulty_id("standard")) == "warden",
		"§2: ...and Batch Y's 'standard' still maps to rung 2")
	ok(String(run.difficulty_id("nonsense")) == "wanderer",
		"§2: an unknown id falls to rung 1 rather than crashing")
	var sim := _src("res://scripts/run_sim.gd")
	ok(sim.contains("run.difficulty_id(OS.get_environment(\"DOD_SIM_DIFFICULTY\"))"),
		"§2: RunSim still reads DOD_SIM_DIFFICULTY through the one resolver")
	# The multiplier reaches the game through exactly one door, and rung 1 is
	# the only one whose product moved.
	run.difficulty = "wanderer"
	var z1: float = float(run.zone_base_mult(1))
	ok(is_equal_approx(z1, float(run.ZONE_BASE_MULTS[0]) * RUNG1_MULT),
		"§2: zone_base_mult(1) carries the new rung-1 multiplier (got %.3f)" % z1)
	run.difficulty = "warden"
	ok(is_equal_approx(float(run.zone_base_mult(1)), float(run.ZONE_BASE_MULTS[0])),
		"§2: ...and rung 2 still multiplies the zone ladder by exactly 1")
	run.difficulty = "wanderer"


# ---------- live harness ----------

# Same shape as test_batch_as's: a real battle scene with the enemies' turns
# off, determinism forced rather than retried (the AK/AL/AR discipline).
func _spawn(learned: Dictionary, lineup: Array, ty := "fight") -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": ty, "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _cryo(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "permafrost":
			return h
	return null


# Stacks through the NORMAL door, so the freeze cascade behaves as it does in
# play — driving set_chilled_stacks directly would skip the very branch that
# calls _hold_freeze.
func _chill(scene: Node, foe: BattleUnit, src: BattleUnit, n: int) -> void:
	for _i in n:
		scene.call("_apply_status", foe, "chilled", 3, 0, 0, src)


# ---------- §1 LIVE ----------

# The half of the cycle that lives in _hold_release: the stacks still land, the
# freeze no longer does. THE STACK COUNT IS ASSERTED BESIDE THE FREEZE because
# "it did not re-freeze" is trivially true of a release that applied nothing.
func _live_release_no_refreeze() -> void:
	var scene := await _spawn({"cr_razor_hone": 1}, ["raider", "raider"])
	var cryo := _cryo(scene)
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	ok(int(cryo.honed_shards_ranks) == 3, "Honed Shards is learned and pays 3")
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9999
	foe.hp = 9999
	_chill(scene, foe, cryo, 4)
	ok(scene.call("_is_held", foe), "four stacks put the enemy in a prison")
	scene.call("_hold_release", foe, "the test")
	ok(foe.status_stacks("chilled") == 4,
		"HONED SHARDS STILL LANDS: 1 + 3 = 4 stacks (got %d)" % foe.status_stacks("chilled"))
	ok(not foe.has_status("frozen"),
		"§1: ...AND THE RELEASE NO LONGER RE-FREEZES ITS OWN TARGET")
	ok(not scene.call("_is_held", foe), "§1: ...so the release is a real release")
	ok(not is_inf(foe.next_time), "...and the thawed enemy is back on the timeline")
	ok(not bool(scene.get("_releasing")), "the guard is down again once the release ends")
	scene.queue_free()
	await process_frame


# THE SEQUENCE THAT REPRODUCED THE OVERFLOW, RUN TO COMPLETION. Hold limit 1,
# Honed Shards learned, two enemies: freezing the second evicts the first,
# whose release used to re-freeze it, which evicted the second, and so on to
# the stack limit. Reaching the assertions below at all is half the check.
func _live_eviction_completes() -> void:
	var scene := await _spawn({"cr_razor_hone": 1}, ["raider", "archer"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	ok(int(scene.call("_hold_limit")) == 1, "the Thaw lane holds exactly ONE")
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	_chill(scene, foes[0], cryo, 4)
	ok(scene.call("_is_held", foes[0]), "the first enemy is held")
	_chill(scene, foes[1], cryo, 4)
	ok(true, "§1: THE TWO-ENEMY EVICTION RETURNS — no infinite recursion")
	ok(scene.get("_holds").size() == 1,
		"...with exactly one prison standing (got %d)" % scene.get("_holds").size())
	ok(scene.call("_is_held", foes[1]), "...and it is the NEWEST freeze that holds")
	ok(not scene.call("_is_held", foes[0]), "...while the evicted one is out")
	ok(not foes[0].has_status("frozen"),
		"THE EVICTED ENEMY IS NOT RE-FROZEN BY ITS OWN RELEASE")
	ok(foes[0].status_stacks("chilled") == 4,
		"...but it does carry Honed Shards' four stacks (got %d)" % \
			foes[0].status_stacks("chilled"))
	ok(not bool(scene.get("_releasing")), "the guard is down after the eviction")
	# AND IT STAYS BOUNDED. The cycle alternated between two bodies, so one
	# alternation proves nothing — drive several and assert the ledger never
	# grows and the flag never sticks.
	var bounded := true
	for i in 6:
		var a: BattleUnit = foes[i % 2]
		scene.call("_apply_status", a, "chilled", 3, 0, 0, cryo)
		if scene.get("_holds").size() != 1 or bool(scene.get("_releasing")):
			bounded = false
	ok(bounded, "§1: SIX MORE ALTERNATIONS and the ledger still holds exactly one")
	scene.queue_free()
	await process_frame


# The milder version of the same fault, which was never a crash: Ice Lance
# released a hold and instantly re-took it, so the release read as a no-op.
func _live_ice_lance_no_retake() -> void:
	var scene := await _spawn({"cr_razor_hone": 1}, ["raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9999
	foe.hp = 9999
	_chill(scene, foe, cryo, 4)
	ok(scene.call("_is_held", foe), "the enemy is held before the Lance")
	var lance: Ability = null
	for ab in cryo.abilities:
		if ab.display_name == "Ice Lance":
			lance = ab
	ok(lance != null, "the Cryomancer holds Ice Lance")
	if lance != null:
		await scene.call("_resolve", cryo, lance, foe, "good", true)
		ok(not scene.call("_is_held", foe),
			"§1: ICE LANCE'S RELEASE IS NOT INSTANTLY RE-TAKEN")
		ok(not foe.has_status("frozen"), "...the enemy really is thawed")
		ok(foe.status_stacks("chilled") == 4,
			"...and Honed Shards still leaves it deep in the cold")
	scene.queue_free()
	await process_frame


# CRYOCLASM MUST BE UNAFFECTED. It MOVES a hold and is deliberately not routed
# through _hold_release, precisely so no release payoff fires — so the guard
# must never be up when its freeze runs. Asserting "not refused" alone would
# pass on an ability that does nothing, so the moved hold is asserted to LAND.
func _live_cryoclasm_unaffected() -> void:
	var scene := await _spawn({"cr_razor_hone": 1, "cr_lance_focus": 1, "cr_icy_veins": 1},
		["raider", "archer", "shaman"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	_chill(scene, foes[0], cryo, 4)
	ok(scene.call("_is_held", foes[0]), "the first prison stands")
	var clasp: Ability = null
	for ab in cryo.abilities:
		if ab.display_name == "Cryoclasm":
			clasp = ab
	ok(clasp != null, "Cryoclasm is in the kit")
	var untouched: float = foes[2].next_time
	if clasp != null:
		await scene.call("_resolve", cryo, clasp, foes[1], "good", true)
		ok(not scene.call("_is_held", foes[0]), "Cryoclasm empties the old prison")
		ok(scene.call("_is_held", foes[1]),
			"§1: THE GUARD DOES NOT TOUCH CRYOCLASM — the hold lands on the new target")
		ok(foes[1].status_stacks("chilled") == 4, "...carrying its stacks with it")
		ok(abs(foes[2].next_time - untouched) < 0.01,
			"A MOVE IS STILL NOT A RELEASE: Shattered Tempo does not fire")
		ok(foes[0].status_stacks("chilled") == 1,
			"...and Honed Shards does not fire on a move either (got %d)" % \
				foes[0].status_stacks("chilled"))
	scene.queue_free()
	await process_frame


# THE VERIFICATION §1 ASKED FOR RATHER THAN ASSUMED, and the one whose failure
# would be silent and worse than the crash: an enemy parked at the chilled cap
# with its freeze refused must be freezable again by a later chill. It is,
# because the threshold reads `>= 4` — but a threshold is one edit away from
# `== 4`, so the behaviour is driven here rather than trusted.
func _live_rearm() -> void:
	var scene := await _spawn({"cr_razor_hone": 1}, ["raider", "archer"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	_chill(scene, foes[0], cryo, 4)
	_chill(scene, foes[1], cryo, 4)      # evicts foes[0]; its re-freeze is refused
	ok(foes[0].status_stacks("chilled") == 4 and not foes[0].has_status("frozen"),
		"the evicted enemy is parked AT the cap with no freeze")
	# One more chill, well after the release has finished.
	scene.call("_apply_status", foes[0], "chilled", 3, 0, 0, cryo)
	ok(foes[0].has_status("frozen"),
		"§1: A PARKED ENEMY IS FREEZABLE AGAIN — the guard needs no re-arm")
	ok(scene.call("_is_held", foes[0]), "...and the new freeze is a real hold")
	ok(not scene.call("_is_held", foes[1]),
		"...which evicted the other prison, exactly as the limit says")
	scene.queue_free()
	await process_frame


# The flag must be down on EVERY exit path of the release, including the two
# early returns — a flag left standing refuses every freeze for the rest of the
# battle, which is a softer failure than the crash and just as fatal.
func _live_guard_clears() -> void:
	var scene := await _spawn({"cr_razor_hone": 1}, ["raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		await process_frame
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	var other: BattleUnit = scene.get("enemies")[1]
	ok(not bool(scene.get("_releasing")), "the flag starts down")
	# Path 1: releasing something that is not held returns before the flag.
	scene.call("_hold_release", foe, "not held at all")
	ok(not bool(scene.get("_releasing")),
		"a release of an unheld enemy leaves the flag down")
	# Path 2: the body's own early return — a DEAD target.
	foe.max_hp = 9999
	foe.hp = 9999
	_chill(scene, foe, cryo, 4)
	foe.dead = true
	scene.call("_hold_release", foe, "the test")
	ok(not bool(scene.get("_releasing")),
		"§1: the DEAD-target early return still clears the flag")
	ok(not scene.call("_is_held", foe), "...and the ledger is still trued up")
	# ...and a freeze still works afterwards, which is what a leak would break.
	other.max_hp = 9999
	other.hp = 9999
	_chill(scene, other, cryo, 4)
	ok(scene.call("_is_held", other),
		"§1: A FREEZE AFTER THAT RELEASE STILL WORKS — the flag did not stick")
	scene.queue_free()
	await process_frame


# ---------- DOCS ----------

func _docs() -> void:
	var doc := _src("res://docs/master.html")
	# BATCH BO re-pointed this in place. It is the SAME gate test_batch_ah and
	# test_batch_bb carry — three copies of one assertion, and all three must
	# move together or the batch that bumps master.html trips two suites it did
	# not touch.
	ok(doc.contains("Last updated: 2026-08-13 (Batch BP)"),
		"master.html carries the current batch's stamp")
	# The number AND the reason it was chosen travel together, or the next
	# reader sees a float with no argument behind it.
	ok(doc.contains("&times;0.50") or doc.contains("×0.50"),
		"master.html's difficulty table reads the new rung-1 multiplier")
	ok(doc.contains("&times;1.00") or doc.contains("×1.00"),
		"...and rung 2 still reads x1.00 in the same table")
	var claude := _src("res://CLAUDE.md")
	ok(claude.contains("BATCH BN"), "CLAUDE.md carries a Batch BN block")
	ok(claude.to_lower().contains("rungs 2 and 3 were not touched")
			or claude.to_lower().contains("rungs 2 and 3 are untouched"),
		"CLAUDE.md says explicitly that rungs 2 and 3 were not touched")
	# The mechanism is kept after the fix, because the guard is the only thing
	# preventing it and a later batch could remove it for looking redundant.
	ok(claude.contains("_releasing"),
		"CLAUDE.md names the guard, so a later batch meets it before deleting it")
	var log_doc := _src("res://docs/changelog.html")
	ok(log_doc.contains("Batch BN"), "changelog.html carries a Batch BN entry")
	var notes := _src("res://docs/design-notes.md")
	ok(notes.contains("Batch BN"), "design-notes.md carries a Batch BN entry")
