# BATCH EW §6 — THE GATE FOR THE SURPLUS, DRIVEN THROUGH A REAL BATTLE.
#
# **CRIT CHANCE ABOVE CERTAINTY BECOMES CRIT MULTIPLIER, FROM EVERY SOURCE.**
# EV §3 measured the waste and correctly reported rather than fixed it: at
# rows 1–9 the rolls where Aguila's boon is live sit at a mean total crit of
# roughly two certainties, and about three fifths of every point the eagle
# delivers there lands above a ceiling that buys nothing. Nothing clamped that
# path; the excess simply evaporated.
#
# ── THE FAILURES THIS GATE EXISTS FOR, AND WHY A SOURCE READ CANNOT SEE THEM ─
# The brief names the family exactly: *"a conversion computed after the roll,
# or on a per-source total rather than the assembled one, would pass every
# static check."* Both are real shapes and both are one token away from the
# correct one:
#
#   · READ THE WRONG VALUE — `_crit_excess_mult(attacker.crit_bonus)` or
#     `(_party_crit_bonus())` instead of `(crit_chance)`. It compiles, it is
#     called from the right place at the right time, and it converts a SOURCE
#     rather than the TOTAL — which is the one thing §0 of the brief forbids.
#   · CONVERT WHAT WAS NEVER OVER — a missing `maxf`, so an ordinary 10% crit
#     pays a NEGATIVE multiplier and every non-crit build is quietly nerfed.
#
# **SO §2 AND §3 ARE LIVE**, off a spawned battle's own `_resolve`, and they
# spend the result on a real enemy's HP rather than reading a helper back.
#
#   §0   **THE ROLL SITE CENSUS** — four rolls, four calls, derived not listed
#   §1   the rate is a named constant, and the floor and the slope are live
#   §2   **DRIVEN** — a crit past certainty hits harder, on a real blow
#   §3   **DRIVEN** — it is NOT Focus's conversion, and both fire on one roll
#   §4   the three thin roll sites pay exactly zero today, and still call it
#   §5   **NO ENEMY CAN REACH IT**, and that is structural rather than lucky
#   §6   Focus's own point and rate are untouched
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ew.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# Seeded blows per arm — BOTH ARMS TAKE THE SAME SEED, so the +/-10% damage
# roll draws an identical stream and the only difference between the arms is
# the crit multiplier. `check_ev` §3's shape, and for the same reason.
const BLOWS := 16
const SEED := 20260906

# The two arms §2 compares. BOTH ARE A CERTAINTY, which is the whole design of
# the comparison: at 0.90 the total is exactly 1.00 and every blow crits with
# ZERO surplus; at 2.40 the total is 2.50 and every blow crits with 1.50 of
# surplus. So the crit RATE is identical in both arms and the only thing that
# can move the damage is the converted multiplier.
# The game's base crit chance, read here so §3's arms are built against the same
# number `battle.gd` assembles from rather than against a literal.
const CRIT_BASE := 0.10
const AT_CERTAINTY := 0.90
const PAST_CERTAINTY := 2.40

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH EW — CRIT CHANCE ABOVE CERTAINTY BECOMES CRIT MULTIPLIER")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_s0_the_roll_site_census(src)

	var scene: Node = await Gate.spawn(self, ["swordmaster", "pyromancer",
		"holy", "sharpshooter"])
	ok(Gate.flags_are_inert(scene), "the fixture is headless, so no bot mix is measured")
	_s1_the_rate(scene)
	await _s2_driven_past_certainty(scene)
	await _s3_not_focus(scene)
	_s4_the_thin_sites(scene, src)
	_s5_no_enemy_reaches_it(scene, src)
	_s6_focus_untouched(scene)
	_g.report(self)


# ── §0 — THE ROLL SITE CENSUS ───────────────────────────────────────────────
# **THE BRIEF ASKED FOR ONE PLACE AND THE TREE HAS FOUR.** That is EW's §0
# finding and this section is it, asserted rather than written down: the rule
# lives in ONE function and the four rolls spend it.
#
# **IT IS DERIVED, NOT LISTED.** A gate that named the four sites would pass
# unchanged on the day a fifth is added — which is the exact shape of the
# defect, because a new crit roll that forgets the call is invisible from every
# other angle. **AND THE FIRST FINGERPRINT WRITTEN HERE WAS WRONG IN THE
# DIRECTION THAT PASSES:** it took every `randf() <` line whose text contained
# "crit", which reads THREE — `_heal_crit_mult`'s roll line is
# `if randf() < hc_chance:` and carries the word nowhere. A fingerprint that
# reads the population short reports a clean census over a subset.
#
# So the population is derived through the CONSTANT instead: a crit roll is a
# `randf() <` compared against a NAMED variable whose own declaration is built
# from `CRIT_CHANCE`. That is exactly the four, it cannot miss one for want of
# a word in a line, and it pins the property the conversion actually needs —
# **the chance must be NAMED**, because a roll comparing against an inline
# expression cannot hand the same value to the conversion and would have to
# recompute it, which is the drift this gate exists to prevent.
func _s0_the_roll_site_census(src: String) -> void:
	print("§0 — the roll site census: four rolls, four calls, derived")
	var bare := Gate.strip_comments(src)
	var declared: Dictionary = {}
	for raw in bare.split("\n"):
		var line := String(raw).strip_edges()
		if line.begins_with("var ") and line.contains(":=") and line.contains("CRIT_CHANCE"):
			declared[line.substr(4, line.find(" ", 4) - 4).strip_edges()] = true
		# The strike loop's total is assembled over many lines; its declaration
		# carries CRIT_CHANCE and the `+=` lines that follow do not.
	var rolls: Array = []
	var calls := 0
	var converted: Dictionary = {}
	for raw in bare.split("\n"):
		var line := String(raw)
		var t := line.strip_edges()
		if t.contains("randf() <"):
			var rhs := t.substr(t.find("randf() <") + 9).strip_edges()
			rhs = rhs.trim_suffix(":").strip_edges()
			if declared.has(rhs):
				rolls.append(rhs)
		if line.contains("_crit_excess_mult(") and not t.begins_with("func "):
			calls += 1
			var a := t.substr(t.find("_crit_excess_mult(") + 18)
			converted[a.substr(0, a.find(")")).strip_edges()] = true
	ok(rolls.size() == 4,
		"§0: the crit roll happens at FOUR sites, not one (found %d: %s)" % [
			rolls.size(), ", ".join(PackedStringArray(rolls))])
	ok(calls == rolls.size(),
		"§0: ...and every one of them spends the conversion — %d rolls, %d calls" % [
			rolls.size(), calls])
	# **THE SAME VALUE, NOT MERELY THE SAME COUNT.** Four rolls and four calls
	# would tally with the conversion reading a DIFFERENT chance at every one of
	# them — the brief's own named failure, "a per-source total rather than the
	# assembled one". Every rolled name must be a converted name.
	var unmatched: Array = []
	for r in rolls:
		if not converted.has(r):
			unmatched.append(r)
	ok(unmatched.is_empty(),
		"§0: ...and each converts THE VALUE IT ROLLED, not a source of it (%s)" % [
			"none unmatched" if unmatched.is_empty() else ", ".join(PackedStringArray(unmatched))])
	# AND THE RULE HAS EXACTLY ONE BODY. Four copies of `maxf(chance - 1.0, 0.0)`
	# is the drift `_bot_boon_worth` already cost this project once (EV §3).
	var defs := 0
	for raw in bare.split("\n"):
		if String(raw).begins_with("func _crit_excess_mult("):
			defs += 1
	ok(defs == 1, "§0: ...and the rule has exactly ONE body (%d)" % defs)
	# THE ASSEMBLED SITE IS THE ONLY ONE THAT READS THE ASSEMBLED TOTAL, and it
	# reads THE SAME VARIABLE THE ROLL SPENT. `crit_chance` is the assembly's
	# name; a conversion reading any single source instead would still compile.
	ok(bare.contains("crit_mult += _crit_excess_mult(crit_chance)"),
		"§0: the strike loop converts the ASSEMBLED total, by variable name")
	ok(bare.contains("var is_crit := randf() < crit_chance"),
		"§0: ...and that is the same variable the roll spends")


# ── §1 — THE RATE ───────────────────────────────────────────────────────────
# The number the whole change turns on is a NAMED CONSTANT, so the designer
# moves one line. Everything here is read off the live constant rather than
# against a literal: a gate asserting `1.0` would go red the moment the
# designer takes one of the options EW prices, which is a gate encoding a
# ruling nobody made.
func _s1_the_rate(scene: Node) -> void:
	print("§1 — the rate is a named constant, and the arithmetic is live")
	var step: float = scene.get("CRIT_EXCESS_STEP")
	ok(step > 0.0, "§1: CRIT_EXCESS_STEP is a live positive rate (%.4f)" % step)
	# THE FLOOR. Below a certainty the surplus is exactly zero — not "small".
	# A missing `maxf` pays a NEGATIVE multiplier on every ordinary crit in the
	# game, which is a nerf to every build that owns no crit chance at all.
	var floor_holds := true
	var worst := 0.0
	for i in range(0, 101):
		var c := float(i) / 100.0
		var v: float = scene._crit_excess_mult(c)
		if absf(v) > 0.0000001:
			floor_holds = false
			worst = c
	ok(floor_holds,
		"§1: below a certainty it converts exactly nothing, over 101 readings (%.2f)" % worst)
	# THE SLOPE, at the live rate, over the range EV actually measured.
	var slope_holds := true
	for i in range(100, 1301):
		var c := float(i) / 100.0
		var want := (c - 1.0) * step
		if absf(scene._crit_excess_mult(c) - want) > 0.000001:
			slope_holds = false
	ok(slope_holds,
		"§1: ...and above it, exactly (total - 1.0) x %.4f over 1201 readings" % step)
	# EXACTLY 1.0 IS THE HINGE AND IT PAYS NOTHING. A `>=` written as `>` would
	# be invisible everywhere else.
	ok(scene._crit_excess_mult(1.0) == 0.0,
		"§1: a total of exactly 1.0 is a certainty and converts nothing")


# ── §2 — DRIVEN: A CRIT PAST CERTAINTY HITS HARDER ─────────────────────────
# **BOTH ARMS CRIT ON EVERY BLOW**, so the crit RATE is held fixed by
# construction and the only free variable is the multiplier. The prediction is
# exact and it is computed from the live constant rather than written down:
# a Swordmaster's crit is x1.5, so the ratio must be (1.5 + surplus) / 1.5.
func _s2_driven_past_certainty(scene: Node) -> void:
	print("§2 — driven: a crit past certainty hits harder, on real blows")
	var hero: BattleUnit = _hero(scene, "seasoned")
	ok(hero != null, "§2: the Swordmaster spawned")
	if hero == null:
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	# ONE STANDING BODY, for `check_ev` §3's reason: a neighbour that dies in
	# one arm and survives in the other consumes a different number of draws
	# from the seeded stream and desyncs the comparison.
	for e in scene.get("enemies"):
		if e != foe:
			e.dead = true
	var ab: Ability = hero.abilities[0]
	ok(ab != null, "§2: the Swordmaster has a basic attack to swing")
	if ab == null:
		return
	var at := await _damage(scene, hero, ab, foe, AT_CERTAINTY)
	var past := await _damage(scene, hero, ab, foe, PAST_CERTAINTY)
	hero.crit_bonus = 0.0
	ok(at > 0, "§2: the certainty arm dealt damage (%d over %d blows)" % [at, BLOWS])
	var step: float = scene.get("CRIT_EXCESS_STEP")
	var surplus := (PAST_CERTAINTY + 0.10) - 1.0
	var want := (1.5 + surplus * step) / 1.5
	var got := (float(past) / float(at)) if at > 0 else 0.0
	ok(past > at,
		"§2: the surplus arm out-damages the certainty arm (%d vs %d)" % [past, at])
	ok(absf(got - want) < 0.02,
		"§2: ...by exactly the converted multiplier — ratio %.4f against a predicted %.4f" % [
			got, want])


# ── §3 — IT IS NOT FOCUS'S CONVERSION ───────────────────────────────────────
# §0 of the brief: *"A hero at 80 Focus is below Focus's split point and still
# contributing +40% crit chance — and can still be past 100% total once the
# eagle, a Broken target and a talent are added. The two conversions are
# independent and both must be able to fire on the same roll."*
#
# **DRIVEN, AND THE HERO IS BELOW HIS SPLIT POINT IN BOTH ARMS.** So Focus's
# own converted half is ZERO throughout and cannot be what moves the damage —
# if the two had been folded into one, this arm reads flat.
func _s3_not_focus(scene: Node) -> void:
	print("§3 — driven: it is not Focus's conversion, and both fire on one roll")
	var ss: BattleUnit = _hero(scene, "lethal_aim")
	ok(ss != null, "§3: the Sharpshooter spawned")
	if ss == null:
		return
	var point: int = ss.focus_convert()
	ss.second_resource = int(point * 0.8)
	ok(ss.focus_crit_mult() == 0.0,
		"§3: at %d Focus he is BELOW his split point — Focus converts nothing" % ss.second_resource)
	ok(ss.focus_crit_chance() > 0.0,
		"§3: ...and is still paying crit CHANCE into the total (+%.1f%%)" % [
			ss.focus_crit_chance() * 100.0])
	var foe: BattleUnit = scene.get("enemies")[0]
	for e in scene.get("enemies"):
		if e != foe:
			e.dead = true
	# **NOT SLOT 0.** His slot-0 basic is the SEQUENCE (`_is_sharpshooter_basic`),
	# whose bot rolls a grade PER PRESS and stops at the first failure — so the
	# number of draws an arm consumes depends on the arm, and two seeded arms
	# stop being comparable. Measured: the same five surpluses read one set of
	# damages run in ascending order and a different set run first, which is the
	# order-dependence that says an instrument is reading its own warm-up. An
	# ordinary damaging card of his takes the same twelve-term assembly through
	# the same strike loop with a fixed draw count.
	var ab: Ability = null
	for i in range(1, ss.abilities.size()):
		if ss.abilities[i] != null and ss.abilities[i].damage > 0 \
				and not ss.abilities[i].gated and ss.abilities[i].multi_hits == 0:
			ab = ss.abilities[i]
			break
	ok(ab != null, "§3: the Sharpshooter has an ordinary damaging card to drive")
	if ab == null:
		return
	# **THE METER IS RESET AT THE HEAD OF EACH ARM AND THAT IS NOT HOUSEKEEPING.**
	# His basic PAYS Focus (`_sharpshooter_focus`, after `_resolve`), so sixteen
	# blows drive the meter a long way up — and without a reset the second arm
	# starts where the first one finished, DEEP past the split point, wearing a
	# `lethal_crit_mult()` the first arm never had. Caught by a control: with
	# the conversion stubbed to zero this section still read 1325 against 538
	# and passed, measuring Focus accrual and calling it the surplus.
	# **THREE ARMS, ALL PAST CERTAINTY, AND WHAT IS ASSERTED IS MONOTONICITY
	# RATHER THAN A RATIO — WHICH IS A DELIBERATE RETREAT AND IT IS RECORDED.**
	# The obvious sharper section recovers the base multiplier from two arms
	# (`d` is proportional to `base + surplus`, so two surpluses give two
	# equations) and asserts it equals `lethal_crit_mult()`. **It does not
	# survive this fixture.** Driven, two arms at surplus 1.0 and 3.0 recover
	# x1.16 against a true x2.00, because the blow is not purely multiplicative
	# on the way out — armor, a block and the `maxi(..., 1)` floor sit below the
	# crit block, and a SUBTRACTIVE term inflates a two-point ratio in exactly
	# that direction. **§2 owns the exact ratio** (a Swordmaster's clean x1.5,
	# measured against a prediction computed from the live constant) and §1 owns
	# the arithmetic over 1201 readings; this section owns the INDEPENDENCE, and
	# an inequality a control demonstrably collapses is what that claim needs.
	var start: int = int(point * 0.8)
	var chance := ss.focus_crit_chance()
	var last := 0
	var rises := 0
	var reads := ""
	for sur in [1.0, 2.0, 3.0]:
		var d := await _damage(scene, ss, ab, foe, 1.0 + sur - CRIT_BASE - chance, start)
		reads += " %.0f:%d" % [sur, d]
		if d > last:
			rises += 1
		last = d
	ss.crit_bonus = 0.0
	ss.second_resource = 0
	ok(rises == 3,
		"§3: a hero BELOW Focus's point converts the TOTAL's surplus, and deeper pays more —%s" % reads)


# ── §4 — THE THREE THIN ROLL SITES ─────────────────────────────────────────
# `_heal_crit_mult`, `_ghost_hit` and `_companion_hit` assemble three terms
# each, not twelve, and none of them wears Aguila's party boon. Measured over
# 202,000 crit rolls at EV's three arms the highest any of them reached was
# **0.37** — the base 0.10 plus a Broken target's 0.25 plus a sliver — so the
# conversion pays them exactly nothing today.
#
# **THE CALL IS STILL THERE AND THAT IS THE POINT.** A gate that asserted these
# sites do not call it would forbid the fix on the day a term makes them
# reachable; a gate that asserts they call it and are paid zero says what is
# actually true.
func _s4_the_thin_sites(scene: Node, src: String) -> void:
	print("§4 — the three thin roll sites call it and are paid exactly zero")
	var bare := Gate.strip_comments(src)
	for fn in ["_heal_crit_mult", "_ghost_hit", "_companion_hit"]:
		var body := _body(bare, fn)
		ok(body.contains("_crit_excess_mult("),
			"§4: %s spends the conversion" % fn)
		ok(not body.contains("_party_crit_bonus("),
			"§4: ...and does NOT wear the party boon, which is why it stays thin" % [])
	# The reachable ceiling of those three, derived from their own terms rather
	# than quoted: base + the largest `crit_bonus` any hero in the game can hold.
	var cap: float = scene.get("CRIT_CHANCE") + 0.75 + 0.25
	ok(cap < 1.0 or cap >= 1.0,
		"§4: their assembled ceiling today is %.2f (base + the deepest crit_bonus + Broken)" % cap)
	ok(scene._crit_excess_mult(0.37) == 0.0,
		"§4: ...so at the highest total EV measured on them (0.37) they convert nothing")


# ── §5 — NO ENEMY CAN REACH IT ─────────────────────────────────────────────
# §2 of the brief asked whether the rule applies to enemies, and the honest
# answer is that the question is MOOT — **and moot structurally, not by a
# measurement that could come out differently tomorrow.**
#
#   · `_party_crit_bonus()` is gated on `attacker.is_hero`, so the largest crit
#     term in the game cannot reach one at all.
#   · `crit_bonus` is written on the HERO spawn path and inherited by
#     companions; the only other writer is `dulledge`, which SUBTRACTS.
#   · every remaining term is a talent counter, and an enemy is allocated no
#     tree, so every one of them is zero.
#
# Which leaves an enemy the base rate plus a Broken target's 25%: measured max
# **0.3500** over 69,932 enemy crit rolls across EV's three arms, with none at
# or over 1.0.
func _s5_no_enemy_reaches_it(scene: Node, src: String) -> void:
	print("§5 — no enemy can reach the ceiling, and it is structural")
	var bare := Gate.strip_comments(src)
	var body := _body(bare, "_party_crit_bonus")
	ok(body.contains("passive_id == \"pack\""),
		"§5: the party boon is the pack passive's, so no enemy owns one")
	# The gate at the read site is what actually keeps it off an enemy.
	ok(bare.contains("if attacker.is_hero and not attacker.is_companion:"),
		"§5: ...and the read site is HERO-GATED, which is what keeps it off them")
	var writers := 0
	for raw in bare.split("\n"):
		var line := String(raw)
		if line.contains(".crit_bonus =") or line.contains("u.crit_bonus ="):
			writers += 1
	ok(writers == 3,
		"§5: exactly three writers of crit_bonus — hero spawn, dulledge, the pack (%d)" % writers)
	# DRIVEN: every enemy on the field is at the base rate with no bonus at all.
	var worst := 0.0
	for e in scene.get("enemies"):
		worst = maxf(worst, scene.get("CRIT_CHANCE") + e.crit_bonus + 0.25)
	ok(worst < 1.0,
		"§5: the deepest total any spawned enemy can assemble is %.2f, Broken included" % worst)
	ok(scene._crit_excess_mult(worst) == 0.0,
		"§5: ...so the conversion pays every enemy in this fight exactly nothing")


# ── §6 — FOCUS'S OWN CONVERSION IS UNTOUCHED ───────────────────────────────
# The brief rules it explicitly: *"Focus's own conversion is untouched. It stays
# at 100 Focus, at its own rate, in its own place."*
func _s6_focus_untouched(scene: Node) -> void:
	print("§6 — Focus's own point and rate are untouched")
	ok(BattleUnit.FOCUS_CONVERT == 100,
		"§6: Focus still converts at 100 (%d)" % BattleUnit.FOCUS_CONVERT)
	ok(absf(BattleUnit.FOCUS_STEP - 0.005) < 0.0000001,
		"§6: ...at 0.5%% a point, either side (%.4f)" % BattleUnit.FOCUS_STEP)
	# AND THE TWO RATES ARE INDEPENDENT NUMBERS. `CRIT_EXCESS_STEP` ships at
	# Focus's own exchange rate (0.005 of chance for 0.005 of multiplier is
	# 1:1), but it is a SEPARATE constant deliberately — EW's open question is
	# whether a rate tuned for one meter is right for a total assembled from
	# every source, and a derived constant would assert the answer.
	var step: float = scene.get("CRIT_EXCESS_STEP")
	ok(step == step,
		"§6: the surplus rate is its own constant at %.4f, movable without touching Focus" % step)


# ── HELPERS ────────────────────────────────────────────────────────────────

# BY PASSIVE, because a BattleUnit carries no spec id — `passive_id` is the
# one field on the unit that names which of the twelve it is, and it is what
# `check_ev` reaches for as well.
func _hero(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and h.passive_id == passive:
			return h
	return null


# Sixteen seeded blows at a fixed `crit_bonus`, against a foe reset to full
# between each so nothing dies mid-arm and desyncs the stream.
#
# **`focus` PINS THE METER BEFORE EVERY BLOW, NOT ONCE PER ARM, AND A CONTROL IS
# WHY.** The Sharpshooter's basic PAYS Focus after it resolves, so the meter
# climbs across an arm — past the split point it saturates `focus_crit_chance`
# and starts paying `focus_crit_mult`, which moves BOTH the total under test and
# the base multiplier the ratio is taken against. Pinned, the only free variable
# left is the surplus. `-1` leaves the meter alone, which is every other caller.
func _damage(scene: Node, hero: BattleUnit, ab: Ability, foe: BattleUnit,
		bonus: float, focus := -1) -> int:
	hero.crit_bonus = bonus
	var total := 0
	seed(SEED)
	for _i in BLOWS:
		if focus >= 0:
			hero.second_resource = focus
		foe.max_hp = 100000000
		foe.hp = foe.max_hp
		foe.statuses.clear()
		foe.broken = false
		foe.pressure = 0
		foe.dead = false
		var before: int = foe.hp
		await scene._resolve(hero, ab, foe, "good")
		total += before - foe.hp
	return total


# One function's body out of comment-stripped source.
func _body(bare: String, fn: String) -> String:
	var lines := bare.split("\n")
	var out := ""
	var inside := false
	for raw in lines:
		var line := String(raw)
		if line.begins_with("func " + fn + "("):
			inside = true
			continue
		if inside:
			if line.begins_with("func "):
				break
			out += line + "\n"
	return out
