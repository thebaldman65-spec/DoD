# BATCH DA — the invariant gate. Three things, and each one is a rule a later
# batch could break without noticing:
#
#   §1  THE FAITH BUILDERS ARE BACK AND THE THRESHOLD IS NOT. The two constants
#       are asserted, and so is the RELATIONSHIP that decided the revert: an
#       absorbed hit must pay LESS than a release costs, or a shielded ally
#       stops holding Faith at all and the high-water mark Conviction is built
#       on stops existing for allies. That is a mechanic, not a magnitude, and
#       it is driven live through `_on_shield_absorbed` rather than read off the
#       constant — CZ's own §2 lesson about instruments that measure the wrong
#       meter applies to gates as much as to sims.
#   §2  GLACIAL PRISON REFUSES ONLY WHEN IT WOULD WRITE NOTHING. Driven on a
#       real board rather than read off the table, CO's own discipline: a clean
#       enemy allows, a Chilled-but-unfrozen enemy allows, a saturated board
#       refuses with a reason — AND ONE CLEAN ENEMY ANYWHERE KEEPS THE BUTTON
#       LIT, which is the honest scope of a rule that darkens a button rather
#       than a pick. Both freeze shapes are exercised: ordinary timed ice with
#       no Cryomancer standing, and a real permanent HOLD with one.
#   §3  THE ENUMERATION RULE, ASSERTED AND NOT MERELY WRITTEN DOWN. No gate may
#       hand-roll the ability corpus; `Classes.ability_corpus()` is the walk.
#       CZ's `_cl_only_corpus` is the ONE deliberate exception — it is the
#       negative control that proves the old walk still misses the five — and it
#       is named here so a later reader cannot "fix" it into uselessness.
#       The §3 sweep for OTHER copied helpers is a REPORT and changes nothing.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_da.gd
extends SceneTree

# §3 — THE FINGERPRINT OF A HAND-ROLLED CORPUS WALK is assembled in
# `_walk_marks()` below rather than held as a literal, because a gate whose
# source contains its own fingerprint accuses itself on the first run and gets
# suppressed on the second. The halves are joined at runtime.

# The one file allowed to carry it, and why. NOT a suppression: the copy is the
# point there.
const WALK_EXEMPT := {
	"check_cz.gd": "`_cl_only_corpus` is §0's negative control — its job is to still be missing the five",
}

var _fails := 0
var _checks := 0


# BOTH halves are required to accuse a file, so a gate that mentions one pool
# for its own reasons is not called a corpus walk.
func _walk_marks() -> Array:
	return ["Classes.class_draft" + "_pool(", "Classes.spec_draft" + "_pool("]


func ok(cond: bool, what: String) -> void:
	_checks += 1
	if not cond:
		_fails += 1
		print("  FAIL: %s" % what)


func _initialize() -> void:
	await process_frame
	seed(20260821)
	var battle_gd := load("res://scripts/battle.gd")
	print("BATCH DA — the revert, the refusal and the enumeration rule")
	_s1_constants(battle_gd)
	_s2_table(battle_gd)
	_s3_enumeration_rule()
	await _live(battle_gd)
	_report()


# ---------------- §1 — THE TWO BUILDERS AND THE ONE THRESHOLD ----------------
func _s1_constants(battle_gd) -> void:
	print("§1 — FAITH: the threshold stays, the builders go back")
	var rel: int = battle_gd.FAITH_RELEASE
	var absorb: int = battle_gd.FAITH_PER_ABSORB
	var ground: int = battle_gd.FAITH_PER_GROUND_TURN
	ok(rel == 3, "FAITH_RELEASE is %d, want 3 — CZ's threshold is the half that stays" % rel)
	ok(absorb == 2, "FAITH_PER_ABSORB is %d, want 2" % absorb)
	ok(ground == 1, "FAITH_PER_GROUND_TURN is %d, want 1" % ground)
	# THE ASSERTION THAT IS NOT A MAGNITUDE. CZ shipped absorb == release and
	# that is what deleted the held half of the meter for allies. A strict
	# inequality is the rule; the numbers above are only today's instance of it.
	ok(absorb < rel,
		"an absorbed hit pays %d against a release costing %d — at or above it, a shielded ALLY never HOLDS Faith and `faith_peak` stops existing for him" % [
			absorb, rel])
	ok(ground < rel,
		"the ground drip pays %d against a release costing %d — a one-turn stand must not be a whole release" % [
			ground, rel])
	# REPORTED, NOT ASSERTED: the two cards §1 asked about. Neither moved.
	print("  threshold %d | %d a shielded hit | %d an ally turn on the ground" % [
		rel, absorb, ground])
	print("  Blessing of the Faithful needs %d held of a possible %d — still the WHOLE bar, and still only the Devout can hold it" % [
		int(battle_gd.JUBILEE_MIN_FAITH), rel])
	print("  Elevation grants %d of %d — %d%% of a release, to every ally at once; UNCHANGED" % [
		int(battle_gd.ELEVATION_STACKS), rel,
		int(round(100.0 * float(battle_gd.ELEVATION_STACKS) / float(rel)))])


# ---------------- §2 — THE TABLE'S OWN SHAPE ----------------
func _s2_table(battle_gd) -> void:
	print("§2 — GLACIAL PRISON joins CO's refusal")
	var gated: Array = battle_gd.RECAST_GATED
	ok(gated.has("glacial_prison"),
		"`glacial_prison` is not in RECAST_GATED — §2 is not wired in")
	# It must come through CO's ONE door. A second path is what §2 forbids by
	# name, and the cheapest way to notice one is to count the doors.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# ONE DEFINITION AND TWO CALL SITES: `_ability_usable` (the door) and the
	# tooltip that must agree with it. A fourth occurrence is a second path,
	# which is precisely what §2 forbids by name.
	var doors := src.count("_recast_refused(")
	ok(doors == 3,
		"`_recast_refused` appears %d times, want 3 — one definition, `_ability_usable`, and the tooltip. A new occurrence is a second path" % doors)
	ok(not src.contains("if ab.special == \"glacial_prison\""),
		"a bespoke `glacial_prison` gate exists in `_ability_usable` — §2 says one door, not two")
	print("  RECAST_GATED holds %d abilities; Glacial Prison is the first TALENT-GRANT in the set" % gated.size())


# ---------------- §3 — ONE WALK, AND THE COPIED-HELPER CENSUS ----------------
func _s3_enumeration_rule() -> void:
	print("§3 — the enumeration rule, and the copied-helper census")
	var dir := DirAccess.open("res://")
	var gates: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.begins_with("check_") and f.ends_with(".gd"):
				gates.append(f)
	gates.sort()
	ok(not gates.is_empty(), "no `check_*.gd` files found — the sweep read nothing")
	var rolled: Array = []
	var spawn_bodies := {}
	var spawn_files: Array = []
	for f in gates:
		var s := FileAccess.get_file_as_string("res://" + f)
		var hand := true
		for mark in _walk_marks():
			if not s.contains(mark):
				hand = false
		if hand and not WALK_EXEMPT.has(f):
			rolled.append(f)
		# The census: how many gates carry their own copy of the battle fixture,
		# and how many DISTINCT copies that is. A number, so it cannot rot into
		# a sentence nobody re-checks.
		# The LEADING NEWLINE matters: without it this gate matches the search
		# string in this very function and censuses itself wrongly. It did.
		var at := s.find("\nfunc _spawn(")
		if at >= 0:
			spawn_files.append(f)
			var end := s.find("\nfunc ", at + 8)
			if end < 0:
				end = s.length()
			var body := s.substr(at, end - at)
			var key := ""
			for line in body.split("\n"):
				var t := line.strip_edges()
				if t == "" or t.begins_with("#"):
					continue
				key += t + "\n"
			spawn_bodies[key] = true
	for f in rolled:
		ok(false, "%s hand-rolls the ability corpus — `Classes.ability_corpus()` is the walk (BATCH DA §3)" % f)
	ok(rolled.is_empty(), "every gate enumerates abilities through `Classes.ability_corpus()`")
	for f in WALK_EXEMPT:
		var s2 := FileAccess.get_file_as_string("res://" + f)
		var still := true
		for mark in _walk_marks():
			if not s2.contains(mark):
				still = false
		ok(still, "%s no longer carries the old walk — %s" % [f, WALK_EXEMPT[f]])
	print("  %d gates; %d carry their own `_spawn` battle fixture, in %d DISTINCT bodies" % [
		gates.size(), spawn_files.size(), spawn_bodies.size()])
	print("  copies: %s" % ", ".join(PackedStringArray(spawn_files)))
	print("  REPORTED, NOT CONSOLIDATED — §3 says that is its own batch.")


# ---------------- THE LIVE HALF ----------------
func _live(battle_gd) -> void:
	# FIXTURE ONE — NO CRYOMANCER, so every freeze is ordinary TIMED ice and the
	# hold limit never evicts anything. That is the board on which "saturate
	# every enemy" is actually reachable, and it exercises `_freeze_turns`'s
	# boss/ordinary branch. It also carries the DEVOUT for §1's live half.
	var scene := await _spawn(["warden", "pyromancer", "inquisitor", "beastmaster"])
	await _live_faith(scene, battle_gd)
	await _live_prison_timed(scene)
	scene.queue_free()
	# FIXTURE TWO — WITH A CRYOMANCER, so the freeze is a real permanent HOLD.
	# `_freeze_turns` returns -1 here and the eviction loop is live, which is
	# exactly why the saturation test cannot run on this board: a hold limit of
	# one means freezing the second enemy releases the first.
	var held_scene := await _spawn(["warden", "cryomancer", "inquisitor", "beastmaster"])
	await _live_prison_held(held_scene)
	held_scene.queue_free()


# §1 live — THE MECHANIC THE REVERT EXISTS TO RESTORE.
func _live_faith(scene: Node, battle_gd) -> void:
	var rel: int = battle_gd.FAITH_RELEASE
	var per: int = battle_gd.FAITH_PER_ABSORB
	var devout: BattleUnit = scene._living_devout()
	if devout == null:
		ok(false, "§1: no Devout in the fixture — the live half measured nothing")
		return
	var ally: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and not h.dead and h != devout:
			ally = h
			break
	if ally == null:
		ok(false, "§1: no living ally to absorb a hit")
		return
	ally.faith_stacks = 0
	ally.faith_peak = 0
	# THROUGH THE REAL CALL SITE. `_on_shield_absorbed` is the one place an
	# absorbed hit pays Faith, so the gate cannot pass by agreeing with a
	# constant it also reads.
	scene._on_shield_absorbed(ally)
	ok(ally.faith_stacks == per,
		"§1: one absorbed hit paid %d Faith, want %d" % [ally.faith_stacks, per])
	ok(ally.faith_stacks > 0 and ally.faith_stacks < rel,
		"§1: A SHIELDED ALLY MUST HOLD FAITH AFTER ONE ABSORB — he reads %d of %d, so the hold is %s" % [
			ally.faith_stacks, rel,
			"gone" if ally.faith_stacks >= rel else "there"])
	ok(ally.faith_peak == per,
		"§1: the peak reads %d after one absorb, want %d — the held half is what `faith_peak` pays on" % [
			ally.faith_peak, per])
	# ...AND IT STILL RELEASES. A revert that restored the hold by breaking the
	# release would pass every assertion above.
	scene._on_shield_absorbed(ally)
	ok(ally.faith_stacks == 0,
		"§1: two absorbs (%d Faith against a threshold of %d) did not release — he holds %d" % [
			2 * per, rel, ally.faith_stacks])
	ok(ally.faith_peak == rel,
		"§1: the peak reads %d after the release, want %d — the peak must not reset" % [
			ally.faith_peak, rel])
	print("  §1 live: one absorb holds %d of %d, two release and leave a peak of %d" % [
		per, rel, ally.faith_peak])


# §2 live, half one — ORDINARY ICE, AND THE POOL IS THE THING THAT DECIDES.
func _live_prison_timed(scene: Node) -> void:
	var gp = _prison()
	if gp == null:
		ok(false, "§2: Glacial Prison is not in `Classes.ability_corpus()`")
		return
	var caster: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and not h.dead:
			caster = h
			break
	var live: Array = scene.get("enemies").filter(func(e): return not e.dead)
	ok(live.size() >= 2, "§2: the fixture needs two live enemies, has %d" % live.size())
	for e in live:
		e.statuses.clear()
	ok(not scene._recast_refused(caster, gp),
		"§2: refused on a CLEAN board — it would freeze something")
	# A Chilled but UNFROZEN enemy: the freeze half still lands, so the cast is
	# allowed. This is the half §2 warns about — refusing here would block a cast
	# that does the thing the card is for.
	scene._apply_status(live[0], "chilled", 3, 0, 0, caster)
	ok(not scene._recast_refused(caster, gp),
		"§2: refused with a Chilled-but-unfrozen enemy standing — the FREEZE would still land")
	ok(_writes_ids(scene, caster, gp, live[0]) == ["frozen"],
		"§2: on a Chilled target it still proposes a Chilled write — the handler's own guard says it would not land")
	# Now saturate the whole board.
	for e in live:
		await scene._resolve_special(caster, gp, e, "good", 1.0)
	var frozen_all := true
	for e in live:
		if not e.has_status("frozen") or not e.has_status("chilled"):
			frozen_all = false
	ok(frozen_all, "§2: the fixture did not freeze and chill every enemy — the saturation test measured nothing")
	ok(scene._recast_refused(caster, gp),
		"§2: STILL CASTS onto a board where every enemy is already frozen and Chilled — that cast writes nothing")
	ok(scene._recast_refusal_note(caster, gp) != "",
		"§2: refuses with no reason given (CO §3 — a greyed button must name the thing)")
	# ...AND ONE CLEAN ENEMY ANYWHERE LIGHTS IT BACK UP. This is the answer to
	# "which half decides it" and it is neither half: it is the POOL.
	live[0].remove_status("frozen")
	ok(not scene._recast_refused(caster, gp),
		"§2: still refused after one enemy thawed — a button darkens only when NO legal pick would improve")
	print("  §2 live (timed ice): clean allows | Chilled-only allows | every enemy frozen refuses | one thawed enemy allows again")


# §2 live, half two — A REAL HOLD, which is the case the brief actually names.
func _live_prison_held(scene: Node) -> void:
	var gp = _prison()
	if gp == null:
		return
	var cryo: BattleUnit = scene._living_hero_passive("permafrost")
	ok(cryo != null, "§2: no Cryomancer in the second fixture — the HOLD path measured nothing")
	if cryo == null:
		return
	var live: Array = scene.get("enemies").filter(func(e): return not e.dead)
	for e in live:
		e.statuses.clear()
	var victim: BattleUnit = live[0]
	ok(scene._freeze_turns(victim) == -1,
		"§2: `_freeze_turns` reads %d on a non-boss with a Cryomancer standing, want -1 (a HOLD)" % scene._freeze_turns(victim))
	await scene._resolve_special(cryo, gp, victim, "good", 1.0)
	ok(victim.has_status("frozen") and victim.has_status("chilled"),
		"§2: Glacial Prison did not land a hold on a clean enemy")
	# The exact test, on the exact target the brief names: a recast onto the
	# HELD enemy proposes nothing that improves.
	ok(_writes_ids(scene, cryo, gp, victim) == ["frozen"],
		"§2: on a HELD enemy it proposes %s — the Chilled half cannot land on a body already at four stacks" % str(
			_writes_ids(scene, cryo, gp, victim)))
	var w: Array = scene._recast_writes(cryo, gp, victim)
	ok(w.size() == 1 and not scene._status_write_improves(victim, w[0]),
		"§2: the proposed freeze reads as an IMPROVEMENT on an enemy already held — that recast writes nothing")
	# ...and the pool still keeps the button lit, which is the finding.
	ok(not scene._recast_refused(cryo, gp),
		"§2: refused while two unfrozen enemies stood — the other picks are legal")
	print("  §2 live (real hold): a held enemy proposes only a freeze that does not improve; two clean enemies keep the button lit")


# The write IDs this cast would propose onto `t`, in order — the shape §2's
# exactness claim is actually about.
func _writes_ids(scene: Node, u: BattleUnit, ab, t: BattleUnit) -> Array:
	var out: Array = []
	for w in scene._recast_writes(u, ab, t):
		out.append(String(w["id"]))
	return out


# THE ENUMERATION RULE, PRACTISED AND NOT ONLY PREACHED: this gate finds its own
# ability through `Classes.ability_corpus()`. A hand-rolled walk would not reach
# a talent grant, which is the whole reason §2 took five batches to be noticed.
func _prison():
	for ab in Classes.ability_corpus():
		if ab.special == "glacial_prison":
			return ab
	return null


func _report() -> void:
	print("check_da: %d checks / %d failures" % [_checks, _fails])
	quit(1 if _fails > 0 else 0)


# THE SEVENTH COPY OF THIS FIXTURE, AND §3 IS ABOUT EXACTLY THAT. It is written
# here rather than shared because §3 rules that consolidating the copies is its
# own batch — and a gate that reported the census while quietly inventing an
# eighth shape would be worse than one that copies the prevailing one honestly.
# This is v1 of the four (`check_co` / `check_cy` / `check_cz`), unmodified apart
# from the party being a parameter, which v1 already made it.
func _spawn(specs: Array) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband",
		"enemies": ["raider", "raider", "archer"]}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	Engine.time_scale = 50.0
	for _i in 90:
		await process_frame
	Engine.time_scale = 1.0
	return scene
