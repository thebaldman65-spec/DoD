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

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

# §3 — THE FINGERPRINT OF A HAND-ROLLED CORPUS WALK is assembled in
# `_walk_marks()` below rather than held as a literal, because a gate whose
# source contains its own fingerprint accuses itself on the first run and gets
# suppressed on the second. The halves are joined at runtime.

# The one file allowed to carry it, and why. NOT a suppression: the copy is the
# point there.
# BATCH DB — the one authored battle fixture. Named as a const so the failure
# messages and the census cannot drift apart from each other.
const FIXTURE := "gate_fixture.gd"

const WALK_EXEMPT := {
	# BATCH DO CORRECTED THIS REASON RATHER THAN THE EXEMPTION. `_cl_only_corpus`
	# is still §0's re-derivation of the Batch CL walk and still needs the pools
	# directly — but its JOB has inverted: DO moved all twenty-two talent grants
	# into `SPEC_DRAFT_POOLS`, which the CL walk reads, so the five it used to be
	# missing are now inside it. The old reason would have read as current truth
	# for as long as nobody re-derived it.
	# **BATCH DU CORRECTED IT A SECOND TIME, FOR THE SAME REASON.** DU §4 taught
	# `Classes.ability_corpus()` to apply the kit overrides, which the CL walk
	# structurally cannot — so §0 no longer asserts the two walks AGREE; it
	# asserts the difference between them is EXACTLY the overridden basics,
	# derived rather than listed. The exemption itself is untouched: the reason
	# it exists is the direct pool reads, and those have not moved.
	"check_cz.gd": "`_cl_only_corpus` re-derives the Batch CL walk directly — since DU it asserts the two walks differ by exactly the kit overrides",
	# BATCH DN — THE MARK OVER-FIRES HERE, AND THE EXEMPTION RECORDS WHY RATHER
	# THAN HIDING IT. The fingerprint is the two draft-pool calls, and it stands
	# in for the defect "this gate re-derived the corpus and is therefore missing
	# the five talent grants that live in no pool". `check_dn.gd` calls
	# `Classes.ability_corpus()` OUTRIGHT — that is the list it matches node text
	# against — and reads the pools for a DIFFERENT question the corpus cannot
	# answer: which BUCKET a named ability is in. `ability_corpus()` returns a
	# flat 216 with no membership, so "is Frostbolt core or drafted?" has no
	# other source. A gate that uses the canonical walk AND the buckets is not
	# the thing this rule is looking for.
	"check_dn.gd": "reads the pools for BUCKET membership, and calls `Classes.ability_corpus()` for the walk itself",
	# **BATCH EH §1 — A THIRD REASON THE MARK OVER-FIRES, AND IT WILL RECUR.**
	# The zone-boss award is a CHAIN of three pools now — boss, then the hero's
	# spec draft pool, then his class-wide one — so a gate that measures the
	# chain must read every pool the chain reads. That is the opposite of the
	# defect this rule exists to catch: these two do not enumerate abilities at
	# all, they measure DEPTH per spec and drive the tiers live, and neither
	# returns a collection (§3b sees nothing here, which is the check that the
	# shape is honest rather than merely declared).
	"check_ea.gd": "measures the AWARD CHAIN's depth per spec — it reads both draft pools because the chain does",
	"check_eh.gd": "drives the AWARD CHAIN's three tiers live — it reads both draft pools because the chain does",
}


# ═══ BATCH DW §1 — THE SECOND SWEEP, BECAUSE THE FIRST ONE HAD TWO HOLES ═══
#
# THE RULE ABOVE IS UNCHANGED AND SO ARE BOTH OF ITS EXEMPTIONS. This is an
# ADDED instrument, not a loosened one — DV §5 found `test_batch_cp` walking a
# hand-rolled corpus that `check_da` §3 read 37/0 over, and the reason it could
# not see it is that the sweep above asks the wrong question in two ways at
# once:
#
#   HOLE 1 — POPULATION. It reads `check_*.gd` ONLY. The suite half of §3 is
#            about `_spawn`, not about the walk, so a walk living in a SUITE
#            was never looked at.
#   HOLE 2 — CALLING CONVENTION. Its fingerprint is the two draft-pool
#            ACCESSORS, and `test_batch_cp._corpus()` reads the pool CONSTANTS.
#
# AND A THIRD THE BRIEF DID NOT NAME, WHICH IS THE ONE THAT MATTERED MOST: the
# fingerprint assumed a corpus walk touches the DRAFT pools at all.
# `check_cl_resolver._every_ability()` is a walk in a GATE — inside the swept
# population, read on every battery run since DA — and it reads only
# `Classes.kit()` and `Classes.spec_abilities()`. It reaches 43 of 227. The old
# sweep could never have accused it whatever its population had been.
#
# SO THE FINGERPRINT HERE IS NOT A LONGER LIST OF MARKS. It asks what a walk
# IS: **a function that RETURNS a collection and builds it out of two or more
# of the game's ability-source families is answering "what abilities exist?",
# and `Classes.ability_corpus()` is the one authorised answer.** A body that
# reads a pool and ASSERTS on it returns void and is not what this is looking
# for — that distinction is what keeps this rule down to one exemption instead
# of the sixteen a flat mark-union would have needed, and an exemption granted
# to a genuine violation is worse than the violation it covers.
#
# THE EXEMPTION IS KEYED `file::func`, NOT BY FILE. A file-scoped exemption
# would blind this rule to a NEW walk arriving in that file later — which is
# the `check_ds` lesson (a REASON, not an exemption, is what a mark firing on
# prose deserves) one turn further on.
const RETURN_WALK_EXEMPT := {
	# The same file and the same reason as `WALK_EXEMPT` above, at function
	# scope: `_cl_only_corpus` IS the Batch CL walk, deliberately preserved as
	# the negative control that proves the complete walk reaches names it
	# cannot. Repointing it at `ability_corpus()` would delete the control.
	"check_cz.gd::_cl_only_corpus": "the deliberate CL-walk negative control — repointing it would delete the control",
}

# THE SEVEN SOURCE FAMILIES, ASSEMBLED AT RUNTIME for the reason the marks
# above are: a gate whose source contains its own fingerprint accuses itself on
# the first run and gets suppressed on the second. Every one of the twelve
# needles below is split across a `+` so this file never carries one whole.
func _walk_families() -> Array:
	return [
		["Classes.ki" + "t("],
		["Classes.class_" + "pool(", "Classes.CLASS_" + "POOLS"],
		["Classes.class_draft_" + "pool(", "Classes.CLASS_DRAFT_" + "POOLS"],
		["Classes.spec_abili" + "ties("],
		["Classes.spec_" + "pool(", "Classes.SPEC_" + "POOLS"],
		["Classes.spec_draft_" + "pool(", "Classes.SPEC_DRAFT_" + "POOLS"],
		["Talents.LANE_" + "TREES", "Classes.talent_granted_" + "names("],
	]


# BATCH DD — the suites' half of the same fixture, and the same enforcement.
# `_spawn` stood in 37 suites as 36 bodies; it is authored once now and each
# suite keeps a thin delegating `_spawn` with its OWN signature, because the 37
# signatures are not one signature and several hundred call sites read them.
const SUITE_FIXTURE := "suite_fixture.gd"

# THE RESIDUE, NAMED RATHER THAN LEFT TO A WILDCARD — the sites that still build
# a battle by hand OUTSIDE any `_spawn`, with the count each file carries. They
# are bespoke boards inside single checks rather than a copied helper, so they
# are not what the consolidation was about; they are listed so that a NEW copy
# cannot hide among them, and so the next batch can find them. **A file that
# gains a site, or a file that is not on this list, fails the check below.**
const HAND_SPAWN_SITES := {
	"test_batch_al.gd": 2,        # an autoplay history probe and its control
	"test_batch_an.gd": 1,        # `_spawn_battle()`, its own differently-named helper
	"test_batch_ax.gd": 1,        # a second board inside one check
	"test_batch_bl.gd": 1,        # the DOD_SIM probe, stopped part-way on purpose
	"test_rune_battle.gd": 3,     # no `_spawn` at all; three bespoke boards
	"test_run_harness.gd": 2,     # the harness is not a suite and has no `_spawn`
}

var _g := Gate.new()


# BOTH halves are required to accuse a file, so a gate that mentions one pool
# for its own reasons is not called a corpus walk.
func _walk_marks() -> Array:
	return ["Classes.class_draft" + "_pool(", "Classes.spec_draft" + "_pool("]


# BATCH DB — THE FIXTURE MARKS, JOINED AT RUNTIME FOR THE SAME REASON. DA
# counted the `_spawn` copies and reported them; DB deleted all seven, and this
# is what keeps them deleted. A gate that authors its own battle fixture again
# trips [0]; a gate that skips the fixture and instantiates the scene by hand
# trips [1], which is the same defect wearing a different name.
func _fixture_marks() -> Array:
	return ["\nfunc _spa" + "wn(", "res://scenes/bat" + "tle.tscn"]


# BATCH DD — the suite tree, read off the DIRECTORY rather than a list, so a
# suite added later is covered by doing nothing.
func _total(d: Dictionary) -> int:
	var n := 0
	for k in d:
		n += int(d[k])
	return n


func _suites() -> Array:
	var out: Array = []
	var d := DirAccess.open("res://")
	if d != null:
		for f in d.get_files():
			if f.begins_with("test_") and f.ends_with(".gd"):
				out.append(String(f))
	out.sort()
	return out


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


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
	var fixture_users: Array = []
	for f in gates:
		var s := FileAccess.get_file_as_string("res://" + f)
		var hand := true
		for mark in _walk_marks():
			if not s.contains(mark):
				hand = false
		if hand and not WALK_EXEMPT.has(f):
			rolled.append(f)
		# BATCH DB — THE CENSUS IS AN ASSERTION NOW. DA could only count the
		# copies, because consolidating them was its own batch; this is that
		# batch's enforcement. The LEADING NEWLINE in mark [0] matters — without
		# it this gate matches the string in its own source and accuses itself.
		if s.contains(_fixture_marks()[0]):
			spawn_files.append(f)
		if s.contains(_fixture_marks()[1]):
			spawn_bodies[f] = true
		if s.contains(FIXTURE):
			fixture_users.append(f)
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
	# BATCH DB — DA PRINTED THESE TWO NUMBERS; NOW THEY ARE BOTH ASSERTED ZERO.
	# The census stays printed beside them: a rule with a number under it cannot
	# rot into a sentence nobody re-checks, and the number is the tell if the
	# marks ever stop matching what they are meant to match.
	for f in spawn_files:
		ok(false, "%s authors its own `_spawn` — `%s` is the one fixture (BATCH DB §1)" % [f, FIXTURE])
	ok(spawn_files.is_empty(), "no gate authors its own `_spawn` battle fixture")
	for f in spawn_bodies:
		ok(false, "%s instantiates the battle scene by hand — go through `%s` (BATCH DB §1)" % [f, FIXTURE])
	ok(spawn_bodies.is_empty(), "no gate instantiates the battle scene outside the fixture")
	print("  %d gates; %d author their own `_spawn`, %d instantiate the battle by hand" % [
		gates.size(), spawn_files.size(), spawn_bodies.size()])
	print("  %d go through `%s`: %s" % [
		fixture_users.size(), FIXTURE, ", ".join(PackedStringArray(fixture_users))])
	# BATCH DD — THE SUITES' HALF. A suite KEEPS its `_spawn` (37 signatures are
	# not one signature), so the mark that means "authored its own" is a `_spawn`
	# in a file that does NOT reach the fixture.
	var suites := _suites()
	ok(not suites.is_empty(), "no `test_*.gd` files found — the suite sweep read nothing")
	var rolled_suites: Array = []
	var suite_users: Array = []
	var hand: Dictionary = {}
	for f in suites:
		var src := FileAccess.get_file_as_string("res://" + f)
		var has_spawn := src.contains(_fixture_marks()[0])
		var uses := src.contains(SUITE_FIXTURE)
		if uses:
			suite_users.append(f)
		if has_spawn and not uses:
			rolled_suites.append(f)
		var n := src.count(_fixture_marks()[1])
		if n > 0:
			hand[f] = n
	for f in rolled_suites:
		ok(false, "%s authors its own `_spawn` — `%s` is the one fixture (BATCH DD)" % [f, SUITE_FIXTURE])
	ok(rolled_suites.is_empty(),
		"no suite authors its own `_spawn` — all %d go through `%s`"
		% [suite_users.size(), SUITE_FIXTURE])
	# The residue is a RATCHET, not a wildcard: the named files at the named
	# counts, and nothing else. A new hand-built board anywhere in the suites
	# trips this, which is the whole point of writing the six down.
	ok(hand == HAND_SPAWN_SITES,
		"the hand-built battle sites are exactly the %d named ones (found %s)"
		% [HAND_SPAWN_SITES.size(), JSON.stringify(hand)])
	print("  %d suites; %d go through `%s`, %d author their own; %d hand-built boards remain in %d files" % [
		suites.size(), suite_users.size(), SUITE_FIXTURE, rolled_suites.size(),
		_total(hand), hand.size()])
	_s3b_returning_walks(gates, suites)


# ── BATCH DW §1 — THE WIDENED SWEEP, ACROSS BOTH POPULATIONS ────────────────
# Gates AND suites, constants AND accessors, and the discriminator is the
# RETURN rather than a longer list of needles. See `RETURN_WALK_EXEMPT` above
# for why this is an added instrument rather than a loosened one.
#
# **THE COUNT IS PART OF THE ASSERTION AND IS PRINTED EVERY RUN.** DW found
# THREE walks where DV had found one, and the two it had not found were the
# two that reach LESS of the corpus — 43 and 91 against `test_batch_cp`'s 207.
# A fingerprint with holes does not fail loudly; it reads 37/0.
func _s3b_returning_walks(gates: Array, suites: Array) -> void:
	var fams := _walk_families()
	var files: Array = []
	files.append_array(gates)
	files.append_array(suites)
	files.sort()
	var accused: Array = []
	var exempt_seen := {}
	var scanned := 0
	for f in files:
		var src := FileAccess.get_file_as_string("res://" + f)
		if src == "":
			continue
		var bodies := Gate.returning_bodies(src)
		for fname in bodies:
			scanned += 1
			var body: String = bodies[fname]
			var families := 0
			for marks in fams:
				for m in marks:
					if body.contains(m):
						families += 1
						break
			if families < 2:
				continue
			var key := "%s::%s" % [f, fname]
			if RETURN_WALK_EXEMPT.has(key):
				exempt_seen[key] = families
				continue
			accused.append("%s (%d families)" % [key, families])
	for a in accused:
		ok(false,
			"%s RETURNS a corpus it builds itself — `Classes.ability_corpus()` is the walk (BATCH DW §1)" % a)
	ok(accused.is_empty(),
		"no gate or suite RETURNS a hand-rolled ability corpus (%d returning bodies scanned across %d files)"
			% [scanned, files.size()])
	# THE EXEMPTIONS ARE ASSERTED LIVE, IN THE SAME SHAPE THE RULE ABOVE USES:
	# an exemption whose file no longer carries the walk is a stale suppression,
	# and a stale suppression is the thing that lets the next one through.
	for key2 in RETURN_WALK_EXEMPT:
		ok(exempt_seen.has(key2),
			"%s no longer carries the walk it is exempted for — %s" % [
				key2, RETURN_WALK_EXEMPT[key2]])
	print("  %d returning bodies across %d gates and %d suites; %d hand-rolled walks, %d exempt" % [
		scanned, gates.size(), suites.size(), accused.size(), exempt_seen.size()])


# ---------------- THE LIVE HALF ----------------
func _live(battle_gd) -> void:
	# FIXTURE ONE — NO CRYOMANCER, so every freeze is ordinary TIMED ice and the
	# hold limit never evicts anything. That is the board on which "saturate
	# every enemy" is actually reachable, and it exercises `_freeze_turns`'s
	# boss/ordinary branch. It also carries the DEVOUT for §1's live half.
	var scene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "inquisitor", "beastmaster"])
	# BATCH DB §1 — THE GROUND THE MERGE STANDS ON, ASSERTED RATHER THAN ARGUED.
	# Five gates hand-set `skill_check_taught` and `defensive_check_taught` and
	# two did not; the fixture sets neither, because `_nobody_can_press()` makes
	# both unreachable in a gate — the read site is never entered and the
	# defensive brace always takes the bot branch. **That is the whole
	# justification for dropping ten lines from five gates**, so it is checked
	# here rather than left as a paragraph: the day it stops being true, this
	# fails instead of the gates quietly measuring a bot mix they did not mean to.
	ok(Gate.flags_are_inert(scene),
		"`_nobody_can_press()` is true in a gate — the Profile flags the fixture "
		+ "no longer sets are unreachable (BATCH DB §1)")
	await _live_faith(scene, battle_gd)
	await _live_prison_timed(scene)
	scene.queue_free()
	# FIXTURE TWO — WITH A CRYOMANCER, so the freeze is a real permanent HOLD.
	# `_freeze_turns` returns -1 here and the eviction loop is live, which is
	# exactly why the saturation test cannot run on this board: a hold limit of
	# one means freezing the second enemy releases the first.
	var held_scene: Node = await Gate.spawn(self,
		["warden", "cryomancer", "inquisitor", "beastmaster"])
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


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)

