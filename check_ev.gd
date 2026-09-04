# BATCH EV §6 — THE GATE FOR THE FALLBACK, DRIVEN THROUGH A REAL BATTLE.
#
# EV builds what EU measured and did not fix: at rows=9 a Beastmaster fielding
# Ursus lost 36.7% of his companion's strike step and gained **exactly zero**,
# because both consumers of the bear's boon were already at their clamps.
# **A CONVERTED STACK THAT PAYS NOTHING NOW PAYS THE STRIKE STEP INSTEAD.**
#
# THE FAILURE THIS GATE EXISTS FOR IS THE ONE THE BRIEF NAMES: "a fallback that
# never fires, or fires for every stack, would both pass a static check." Those
# are not hypothetical shapes — they are the two ways the arithmetic in
# `_bond_fallback` can be off by one, and a source read confirming the function
# exists, is called from both halves and has a plausible body cannot tell
# either of them from a correct one. **SO EVERY SECTION HERE IS LIVE**, off a
# spawned battle's own functions, and §2 and §3 spend the result rather than
# reading it.
#
#   §0   the invariant — a stack is paid EXACTLY ONCE, over the whole meter
#   §1   it fires, it is PER STACK, and it declines on the one-stack window
#   §2   **IT COSTS THE BOON NOTHING** — real hits, both clamped consumers
#   §3   **THE STRIKE STEP COMES BACK** — measured on real companion blows
#   §4   the wolf and the eagle never fall back, because nothing clamps them
#   §5   `_bot_boon_worth` takes the branch, and it takes it structurally
#   §6   the four raw-stack readers are STILL raw AT A SATURATED DEPTH
#   §7   the phase is visible
#
# ── WHY §1's ONE-STACK WINDOW IS AN ASSERTION AND NOT A COMMENT ─────────────
# EU §4 proved the affected window is ONE STACK WIDE. At the fully talented
# boon step the mitigation clamps at a count of 10, so the ONLY depth at which
# a converted stack buys anything is Loyalty 9 — 0.73 against a clamp of 0.75.
# A fallback that is one stack greedy takes that stack back and silently pays
# the strike step with a stack the cover was still spending; a fallback that is
# one stack shy leaves the whole 36.7% on the floor at every depth above it.
# **BOTH FAILURES LOOK IDENTICAL FROM THE SOURCE AND BOTH ARE ASSERTED HERE.**
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ev.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# Seeded blows per arm — BOTH ARMS TAKE THE SAME SEED, so the +/-10% damage
# roll draws an identical stream and the only difference between them is the
# meter. `check_eu` §1c's shape exactly, and for the same reason.
const BLOWS := 12
const SEED := 20260905

# The fully talented boon step, set on the hunter rather than assumed: Absolute
# Devotion holds +15 on the base 20% and Ancient Pact doubles what that came
# to, which is the 0.70 a stack EU §4's histogram was taken at.
const DEEP_ABSOLUTE := 15

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH EV — A CONVERTED STACK NEVER PAYS NOTHING")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_s0_source(src)

	var scene: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(scene), "the fixture is headless, so no bot mix is measured")
	var bm: BattleUnit = _hunter(scene)
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		_g.report(self)
		return
	await scene._do_summon(bm, "ursus")
	var pack: Array = scene.get("companions")
	ok(pack.size() > 0, "the summon put the bear on the field")
	if pack.is_empty():
		_g.report(self)
		return

	_s0_live_invariant(scene, bm)
	_s1_it_fires(scene, bm)
	await _s2_costs_the_boon_nothing(scene, bm)
	await _s3_the_strike_step_comes_back(scene, bm, pack[0])
	_s4_the_unclamped_kinds(scene, bm)
	_s5_the_bot_mirror(scene, bm)
	await _s6_raw_readers_at_depth(scene, bm, pack[0])
	_s7_the_chip(scene, bm, pack[0])

	scene.queue_free()
	_g.report(self)


# ── §0 — THE DECISION IS MADE IN ONE PLACE, AND A STACK IS PAID ONCE ────────
# The source half is deliberately short and asserts only the property a live
# test cannot see: that the two halves do not each decide separately. **THAT
# IS THE FAILURE THE BRIEF NAMES BY NAME** — "a stack paying the boon AND the
# strike step because the saturation check and the payment happen in different
# places." They cannot, because both halves add and subtract the SAME call.
func _s0_source(src: String) -> void:
	print("§0 — the decision is made in one place")
	var stripped := Gate.strip_comments(src)
	var built := stripped.contains("func _bond_fallback(") \
		and stripped.contains("func _bond_saturation(")
	ok(built, "§0: the fallback is a named function beside `_bond_convert`")
	if not built:
		# A GUARD, NOT POLITENESS. Without it the splits below throw on a tree
		# that never built the fallback, and the battery reports a THROW rather
		# than a count — which is the one outcome a count-diffing rule cannot
		# read. It must go RED here, loudly, and keep counting.
		ok(false, "§0: ...and without it every section below is unassertable")
		return
	# BOTH HALVES CALL IT, EXACTLY ONCE EACH, AND NEITHER RE-DERIVES IT.
	for fn in ["_bond_paid(", "_bond_converted("]:
		var body: String = stripped.split("func " + fn)[1].split("\nfunc ")[0]
		ok(body.split("_bond_fallback(").size() - 1 == 1,
			"§0: `%s` reads the fallback exactly once" % fn)
		ok(not body.contains("_bond_saturation") and not body.contains("BOND_MITIGATION_MAX"),
			"§0: ...and does not re-derive saturation for itself" % [])
	# THE SATURATION POINT IS ASKED FOR, NEVER RE-DERIVED. One line outside the
	# function's own definition — the same property `check_eu` §0 asserts over
	# `BOND_CONVERT`, and for the same reason: a second derivation is a second
	# thing a designer moving a clamp has to remember.
	var asking := 0
	for line in stripped.split("\n"):
		if line.contains("_bond_saturation(") and not line.contains("func _bond_saturation"):
			asking += 1
	ok(asking == 1,
		"§0: exactly one line asks for the saturation point — got %d" % asking)
	# AND THE TWO READ SITES SPEND THE NAMED CONSTANTS THE POINT IS DERIVED
	# FROM. A read site that went back to a bare 0.10 would leave the fallback
	# deriving its point from a magnitude the game no longer spends, and
	# nothing else in the tree compares the two.
	var sat: String = stripped.split("func _bond_saturation(")[1].split("\nfunc ")[0]
	ok(sat.contains("SAVAGE_TAUNT_STEP") and sat.contains("SAVAGE_MITIGATION_STEP")
		and sat.contains("BOND_MITIGATION_MAX"),
		"§0: the saturation point is DERIVED from the clamps, not written down")
	ok(stripped.contains("minf(SAVAGE_TAUNT_STEP")
		and stripped.contains("minf(SAVAGE_MITIGATION_STEP"),
		"§0: ...and both read sites spend those same two constants")
	# THE RATE STILL DID NOT MOVE. `CLAUDE.md`'s standing rule for this meter,
	# asserted in the direction that can break it — a batch that "fixes" the
	# loss by steepening a half instead is the thing the rule forbids.
	ok(stripped.contains("const BOND_STEP := 0.20")
		and stripped.contains("const BOND_CONVERT := 8"),
		"§0: neither the boon's rate nor the split point moved")
	ok(stripped.contains("var step := 0.05 + 0.01 * (pm.wild_communion_step"),
		"§0: the strike step is still 0.05 + its nodes")


# THE INVARIANT, DRIVEN. `_bond_paid + _bond_converted == l` is what makes this
# a conversion rather than a windfall, and it has to hold for EVERY kind at
# EVERY depth at EVERY talent step — including the depths where the fallback
# moves a stack between the two halves, which is exactly where a sign error
# would show up and nowhere else.
func _s0_live_invariant(scene: Node, bm: BattleUnit) -> void:
	print("§0 — a stack is paid exactly once, live")
	var bad := 0
	var checked := 0
	var moved := 0
	for deep in [false, true]:
		bm.absolute_step = DEEP_ABSOLUTE if deep else 0
		bm.ancient_pact = 1 if deep else 0
		for kind in ["ursus", "canis", "aguila"]:
			for l in range(0, 40):
				bm.loyalty[kind] = l
				checked += 1
				var paid: int = scene._bond_paid(bm, kind, l)
				var conv: int = scene._bond_converted(bm, kind, l)
				if paid + conv != l or paid < 0 or conv < 0:
					bad += 1
				if scene._bond_fallback(bm, kind, l) > 0:
					moved += 1
	bm.absolute_step = 0
	bm.ancient_pact = 0
	# CHECKED n OF m IS PRINTED BESIDE THE VERDICT. A walk that skipped every
	# row would report zero violations in exactly the same words as a clean
	# one, and this project has shipped that shape before.
	ok(bad == 0 and checked == 240,
		"§0: paid + converted == the whole meter at all %d readings (%d violations)" % [
			checked, bad])
	# AND THE WALK IS NOT VACUOUS: the fallback has to have MOVED a stack
	# somewhere in it, or the invariant above was asserted over a population in
	# which nothing happened.
	ok(moved > 0,
		"§0 CONTROL: the fallback actually moved a stack in %d of those readings" % moved)


# ── §1 — IT FIRES, IT IS PER STACK, AND IT DECLINES ON THE ONE-STACK WINDOW ─
func _s1_it_fires(scene: Node, bm: BattleUnit) -> void:
	print("§1 — the fallback, driven at both talent depths")
	var point: int = scene._bond_convert(bm)

	# (a) FULLY TALENTED, WHICH IS EU's ROWS=9 ARM. At a boon step of 0.70 the
	# mitigation is clamped from a count of 10 up.
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var step: float = scene._bond_step(bm)
	ok(absf(step - 0.70) < 0.0001,
		"§1a: the deep arm's boon step is 0.70 a stack (got %.4f)" % step)
	# BELOW THE POINT NOTHING FALLS BACK, because nothing converted.
	var below_clean := true
	for l in range(0, point + 1):
		bm.loyalty["ursus"] = l
		if scene._bond_fallback(bm, "ursus", l) != 0:
			below_clean = false
	ok(below_clean, "§1a: below the split point no stack falls back — there are none to fall")
	# **THE ONE-STACK WINDOW.** At Loyalty 9 the converted stack lifts the
	# mitigation from 0.73 to its 0.75 clamp, so it is buying something and it
	# MUST NOT be handed back. This is the assertion a one-stack-greedy
	# fallback fails and nothing else in the tree would catch.
	bm.loyalty["ursus"] = 9
	var win_boon: float = scene._bond_mult(bm, "ursus")
	ok(scene._bond_fallback(bm, "ursus", 9) == 0,
		"§1a: at Loyalty 9 the converted stack still buys the clamp — it does NOT fall back")
	ok(scene._bond_converted(bm, "ursus", 9) == 1
		and scene._bond_paid(bm, "ursus", 9) == 8,
		"§1a: ...so that stack is still converted and the paid half is still %d" % point)
	# AND THE WINDOW IS REAL RATHER THAN ASSUMED: without that stack the
	# mitigation is genuinely under its clamp, which is the whole reason it
	# stays converted.
	var unconv: float = scene._bond_curve(bm, 9) * scene._bond_reach(bm, "ursus")
	ok(scene.SAVAGE_MITIGATION_STEP * unconv < scene.BOND_MITIGATION_MAX
		and scene.SAVAGE_MITIGATION_STEP * win_boon >= scene.BOND_MITIGATION_MAX,
		"§1a: ...because 0.10 x %.2f is under the clamp and 0.10 x %.2f is at it" % [
			unconv, win_boon])
	# ONE STACK LATER EVERY CONVERTED STACK FALLS BACK, and the paid half is
	# the WHOLE meter again — the strike step is restored in full.
	for l in [10, 12, 16, 20]:
		bm.loyalty["ursus"] = l
		ok(scene._bond_paid(bm, "ursus", l) == l
			and scene._bond_converted(bm, "ursus", l) == 0,
			"§1a: at Loyalty %d the boon is full, so all %d converted stacks pay the strike" % [
				l, l - point])

	# (b) **PER STACK, NOT PER HERO** — and this is the arm that proves it.
	# At the untalented step the boon crosses its clamp partway up the meter,
	# so at Loyalty 21 SOME converted stacks fall back and the rest do not.
	# A hero-level test cannot produce this row at all.
	bm.absolute_step = 0
	bm.ancient_pact = 0
	var partial := 0
	var partial_at := -1
	for l in range(point + 1, 40):
		bm.loyalty["ursus"] = l
		var fell: int = scene._bond_fallback(bm, "ursus", l)
		var conv: int = scene._bond_converted(bm, "ursus", l)
		if fell > 0 and conv > 0:
			partial += 1
			if partial_at < 0:
				partial_at = l
	ok(partial > 0,
		"§1b: PER STACK — %d depths convert some stacks and hand others back (first at Loyalty %d)" % [
			partial, partial_at])
	# AND THE SPLIT AT THAT DEPTH IS EXACT: the stacks that stayed are the ones
	# still holding the boon at its clamp, and one fewer would drop it under.
	if partial_at > 0:
		bm.loyalty["ursus"] = partial_at
		var conv2: int = scene._bond_converted(bm, "ursus", partial_at)
		var keep: float = scene._bond_curve(bm, partial_at + conv2) \
			* scene._bond_reach(bm, "ursus")
		var one_less: float = scene._bond_curve(bm, partial_at + conv2 - 1) \
			* scene._bond_reach(bm, "ursus")
		ok(scene.SAVAGE_MITIGATION_STEP * keep >= scene.BOND_MITIGATION_MAX
			and scene.SAVAGE_MITIGATION_STEP * one_less < scene.BOND_MITIGATION_MAX,
			"§1b: ...and it is EXACT — one stack fewer drops the boon under its clamp")
	bm.loyalty["ursus"] = 0


# ── §2 — IT COSTS THE BOON NOTHING ─────────────────────────────────────────
# THE CENTRAL CLAIM OF THE BATCH, AND IT IS SPENT RATHER THAN READ. `_bond_mult`
# genuinely FALLS when the fallback fires — that is the point, the stacks left
# it — so the only honest test is whether the terms the game actually pays out
# of it move. They must not.
func _s2_costs_the_boon_nothing(scene: Node, bm: BattleUnit) -> void:
	print("§2 — it costs the boon nothing")
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	# (a) BOTH CLAMPED CONSUMERS, AT EVERY DEPTH, AGAINST THE COUNTERFACTUAL —
	# the same terms computed off the meter the conversion WOULD have delivered
	# without a fallback. Not one of them may differ.
	var differed := 0
	var compared := 0
	var dropped := 0
	for l in range(0, 40):
		bm.loyalty["ursus"] = l
		var live: float = scene._bond_mult(bm, "ursus")
		var nominal: float = scene._bond_curve(bm,
			l + maxi(l - scene._bond_convert(bm), 0)) * scene._bond_reach(bm, "ursus")
		if live < nominal - 0.0001:
			dropped += 1
		compared += 1
		var mit_live: float = minf(scene.SAVAGE_MITIGATION_STEP * live, scene.BOND_MITIGATION_MAX)
		var mit_nom: float = minf(scene.SAVAGE_MITIGATION_STEP * nominal, scene.BOND_MITIGATION_MAX)
		var tau_live: float = minf(scene.SAVAGE_TAUNT_STEP * live, 1.0)
		var tau_nom: float = minf(scene.SAVAGE_TAUNT_STEP * nominal, 1.0)
		if absf(mit_live - mit_nom) > 1e-9 or absf(tau_live - tau_nom) > 1e-9:
			differed += 1
	ok(differed == 0 and compared == 40,
		"§2a: both clamped terms are IDENTICAL at all %d depths (%d differed)" % [
			compared, differed])
	# THE ARM IS NOT VACUOUS AND THIS IS THE CHECK THAT SAYS SO. If the boon
	# never fell, the equality above would be true because nothing happened.
	ok(dropped > 0,
		"§2a CONTROL: the boon itself DID fall at %d of those depths — the terms held anyway" % dropped)

	# (b) **SPENT, ON REAL HITS.** The mitigation is applied inside `_resolve`
	# and nothing above reaches it. Two saturated depths that deliver very
	# different boons must cost the hunter the SAME damage; two unsaturated
	# depths must not, or the instrument is measuring nothing.
	var foe: BattleUnit = scene.get("enemies")[0]
	# **THE WARM-UP ARM IS DISCARDED AND THIS GATE'S INSTRUMENT WAS WRONG
	# WITHOUT IT.** The first pass through `_resolve` against a freshly spawned
	# board leaves state behind — the twelve hits read `7 7 7 7 7 7 7 8 ...`
	# on the FIRST arm and `8 7 8 7 7 8 8 7 ...` on every arm after it,
	# whichever Loyalty that first arm was driven at. Run 12 then 24 and the
	# totals read 86 against 90 and look exactly like a clamp that is not
	# holding; run 24 then 12 and they read 86 against 90 in the SAME order,
	# which is what proves it is the pass and not the meter. `check_eu` §1c
	# was wrong twice for the same family of reason and recorded both.
	var _warm := await _damage_taken(scene, bm, foe, 12)
	var deep_a := await _damage_taken(scene, bm, foe, 12)
	var deep_b := await _damage_taken(scene, bm, foe, 24)
	ok(deep_a > 0, "§2b: the hunter actually took damage (%d over %d hits)" % [deep_a, BLOWS])
	ok(deep_a == deep_b,
		"§2b: SATURATED — Loyalty 12 and 24 cost him the SAME damage (%d vs %d)" % [
			deep_a, deep_b])
	var shallow_a := await _damage_taken(scene, bm, foe, 1)
	var shallow_b := await _damage_taken(scene, bm, foe, 6)
	ok(shallow_b < shallow_a,
		"§2b CONTROL: UNSATURATED — the same instrument still moves (%d at 6 vs %d at 1)" % [
			shallow_b, shallow_a])
	bm.absolute_step = 0
	bm.ancient_pact = 0
	bm.loyalty["ursus"] = 0


# One arm of §2b: BLOWS enemy attacks on the hunter at a fixed Loyalty, seeded,
# with the hunter restored between hits so nothing accumulates across them.
func _damage_taken(scene: Node, bm: BattleUnit, foe: BattleUnit, stacks: int) -> int:
	bm.loyalty["ursus"] = stacks
	var ab: Ability = foe.abilities[0]
	var total := 0
	seed(SEED)
	for _i in BLOWS:
		bm.max_hp = 100000000
		bm.hp = bm.max_hp
		bm.statuses.clear()
		bm.dead = false
		var before: int = bm.hp
		await scene._resolve(foe, ab, bm, "good")
		total += before - bm.hp
	return total


# ── §3 — THE STRIKE STEP COMES BACK ────────────────────────────────────────
# `check_eu` §1c asserts that at the point and at twice the point a companion
# deals IDENTICAL damage, because every stack between them converted. **THAT
# IS STILL TRUE WHERE THE BOON IS NOT SATURATED AND IT IS THE OPPOSITE OF TRUE
# WHERE IT IS** — and it is the same instrument, so the two gates disagreeing
# is precisely what this batch changed.
func _s3_the_strike_step_comes_back(scene: Node, bm: BattleUnit,
		comp: BattleUnit) -> void:
	print("§3 — the strike step comes back, on real companion blows")
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var point: int = scene._bond_convert(bm)
	# ONE STANDING BODY, for `check_eu` §1c's reason: the bear's sweep mauls
	# the enemies beside its target, and a neighbour that dies in one arm and
	# survives in the other consumes a different number of draws from the
	# seeded stream. That read 1.0315 with the strike step provably flat.
	var foe: BattleUnit = scene.get("enemies")[0]
	for e in scene.get("enemies"):
		if e != foe:
			e.dead = true
	var at_point := await _companion_damage(scene, bm, comp, foe, point)
	var far_above := await _companion_damage(scene, bm, comp, foe, point * 2)
	ok(at_point > 0, "§3: the companion dealt damage at the point (%d over %d blows)" % [
		at_point, BLOWS])
	var ratio := (float(far_above) / float(at_point)) if at_point > 0 else 0.0
	ok(far_above > at_point,
		"§3: at a SATURATED boon %d Loyalty now out-damages %d — ratio %.4f (%d vs %d)" % [
			point * 2, point, ratio, at_point, far_above])
	# AND IT COMES BACK IN FULL RATHER THAN PARTLY. At Loyalty 16 every
	# converted stack fell back, so the blow must be worth exactly what an
	# UNCONVERTED meter of 16 would have paid — which is the strike multiplier
	# read off the read site's own arithmetic.
	bm.loyalty[comp.companion_kind] = point * 2
	var mult: float = scene._comp_dmg_mult(comp)
	bm.absolute_step = 0
	bm.ancient_pact = 0
	var flat: float = scene._comp_dmg_mult(comp)
	ok(mult > flat,
		"§3: ...and the multiplier itself moved with it (%.4f deep vs %.4f untalented)" % [
			mult, flat])
	bm.loyalty[comp.companion_kind] = 0


func _companion_damage(scene: Node, bm: BattleUnit, comp: BattleUnit,
		foe: BattleUnit, stacks: int) -> int:
	bm.loyalty[comp.companion_kind] = stacks
	var total := 0
	seed(SEED)
	for _i in BLOWS:
		foe.max_hp = 100000000
		foe.hp = foe.max_hp
		foe.statuses.clear()
		foe.broken = false
		foe.pressure = 0
		foe.dead = false
		var before: int = foe.hp
		await scene._companion_strike(comp, foe, 1.0, false)
		total += before - foe.hp
	return total


# ── §4 — THE WOLF AND THE EAGLE NEVER FALL BACK ────────────────────────────
# **AND THAT IS A MEASUREMENT RATHER THAN AN OVERSIGHT.** Canis's wounded-prey
# bonus and Aguila's party crit are spent UNCLAMPED, so no stack of theirs can
# ever pay nothing — EU §3 measured +62.6% and +49.0% at the same rows=9 arm
# where the bear's two terms gained +0.00%. A fallback that reached them would
# be taking a stack out of a boon that was still growing.
func _s4_the_unclamped_kinds(scene: Node, bm: BattleUnit) -> void:
	print("§4 — the wolf and the eagle never fall back")
	for kind in ["canis", "aguila"]:
		ok(is_inf(scene._bond_saturation(kind)),
			"§4: %s has no saturation point — nothing that spends its boon clamps" % kind)
		var fell := 0
		for deep in [false, true]:
			bm.absolute_step = DEEP_ABSOLUTE if deep else 0
			bm.ancient_pact = 1 if deep else 0
			for l in range(0, 60):
				bm.loyalty[kind] = l
				fell += scene._bond_fallback(bm, kind, l)
		bm.absolute_step = 0
		bm.ancient_pact = 0
		ok(fell == 0,
			"§4: ...so not one stack falls back over 120 readings (%d did)" % fell)
		bm.loyalty[kind] = 0
	# AND THE BEAR DOES, ON THE SAME WALK — the arm that stops §4 passing
	# because the fallback is broken everywhere rather than absent here.
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var ursus_fell := 0
	for l in range(0, 60):
		bm.loyalty["ursus"] = l
		ursus_fell += scene._bond_fallback(bm, "ursus", l)
	bm.absolute_step = 0
	bm.ancient_pact = 0
	bm.loyalty["ursus"] = 0
	ok(ursus_fell > 0,
		"§4 CONTROL: the bear DOES fall back on the same walk (%d stacks)" % ursus_fell)


# ── §5 — THE BOT MIRROR TAKES THE BRANCH ───────────────────────────────────
# `_bot_boon_worth` recomputes the boon's curve so the bot can price a swap it
# has not made. EU found it missing from ER's payout table and added it; **the
# same applies here**, and it takes the fallback STRUCTURALLY rather than by a
# second copy of the rule — it calls the same `_bond_converted`. This asserts
# the consequence, which is the thing that could drift.
func _s5_the_bot_mirror(scene: Node, bm: BattleUnit) -> void:
	print("§5 — the bot mirror takes the branch")
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var moved := 0
	var disagreed := 0
	for l in range(0, 30):
		bm.loyalty["ursus"] = l
		var worth: float = scene._bot_boon_worth(bm, "ursus")
		# The bot values an ABSENT kind at the curve it would arrive on, so the
		# comparison is against the curve rather than against `_bond_mult`.
		var conv: int = scene._bond_converted(bm, "ursus", l)
		var want: float = scene._bond_curve(bm, l + conv) * scene.SAVAGE_MITIGATION_STEP \
			* (2.0 if bm.hp < bm.max_hp * 0.5 else 1.0)
		if absf(worth - want) > 0.0001:
			disagreed += 1
		if scene._bond_fallback(bm, "ursus", l) > 0:
			moved += 1
	bm.absolute_step = 0
	bm.ancient_pact = 0
	bm.loyalty["ursus"] = 0
	ok(disagreed == 0,
		"§5: `_bot_boon_worth` reads the SAME converted half the game pays (%d disagreements over 30)" % disagreed)
	ok(moved > 0,
		"§5 CONTROL: and the fallback fired in %d of those 30 readings" % moved)


# ── §6 — THE RAW-STACK READERS ARE STILL RAW, AT A SATURATED DEPTH ─────────
# `check_eu` §2 casts these four at the untalented fixture, where the fallback
# never fires. **THIS IS THE SAME QUESTION ASKED WHERE IT CAN NOW GO WRONG.**
# The fallback moves stacks INTO `_bond_paid`, so anything that had been
# reading the paid half by mistake would suddenly pay MORE rather than less —
# a regression in the opposite direction from the one EU guarded, and one its
# own arms cannot see because they sit below the saturation point.
func _s6_raw_readers_at_depth(scene: Node, bm: BattleUnit, comp: BattleUnit) -> void:
	print("§6 — the raw-stack readers, cast at a saturated depth")
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.dead = false
	var point: int = scene._bond_convert(bm)
	# Both arms are ABOVE the point and both are saturated, so under the
	# fallback every converted stack has been handed back at both — and the
	# payout must STILL double, because these cards count stacks.
	for nm in ["Unleash", "Primal Surge"]:
		var ab: Ability = Classes.pool_ability(nm)
		ok(ab != null, "§6: `Classes.pool_ability(\"%s\")` builds the card" % nm)
		if ab == null:
			continue
		var one := await _spender_damage(scene, bm, comp, foe, ab, point + 4)
		var two := await _spender_damage(scene, bm, comp, foe, ab, (point + 4) * 2)
		var r := (float(two) / float(one)) if one > 0 else 0.0
		ok(one > 0, "§6: %s dealt damage at %d Loyalty (%d)" % [nm, point + 4, one])
		ok(absf(r - 2.0) < 0.02,
			"§6: %s STILL READS THE RAW METER at a saturated boon (ratio %.4f)" % [nm, r])
	# LAST HOWL banks the meter the dying beast held, and it banks the WHOLE
	# meter — not the paid half the fallback just grew.
	bm.last_howl = 3
	bm.last_howl_dmg = 0
	var howl: int = point * 3
	bm.loyalty[comp.companion_kind] = howl
	scene._on_beast_death(comp)
	ok(bm.last_howl_dmg == 3 * howl,
		"§6: LAST HOWL STILL READS THE RAW METER — %d stacks bank +%d%% (got +%d%%)" % [
			howl, 3 * howl, bm.last_howl_dmg])
	bm.last_howl = 0
	bm.last_howl_dmg = 0
	bm.absolute_step = 0
	bm.ancient_pact = 0


func _spender_damage(scene: Node, bm: BattleUnit, comp: BattleUnit,
		foe: BattleUnit, ab: Ability, stacks: int) -> int:
	foe.max_hp = 100000000
	foe.hp = foe.max_hp
	foe.statuses.clear()
	foe.broken = false
	foe.pressure = 0
	foe.dead = false
	bm.loyalty[comp.companion_kind] = stacks
	var before: int = foe.hp
	seed(SEED)
	await scene._resolve_special(bm, ab, foe, "good", 1.0)
	return before - foe.hp


# ── §7 — THE PHASE IS VISIBLE ──────────────────────────────────────────────
# `CLAUDE.md`: "a silent second phase is a stat nobody knows they have." **A
# SILENT THIRD PHASE IS WORSE**, because at a saturated bear the converted
# count on the chip FALLS as the meter climbs while the strike figure RISES,
# and a player reading only EU's line would conclude the chip was broken.
func _s7_the_chip(scene: Node, bm: BattleUnit, comp: BattleUnit) -> void:
	print("§7 — the phase is visible")
	bm.absolute_step = DEEP_ABSOLUTE
	bm.ancient_pact = 1
	var kind: String = comp.companion_kind
	var point: int = scene._bond_convert(bm)

	bm.loyalty[kind] = point * 2
	scene._stamp_loyalty_chip(bm, comp)
	var full := String(comp.get_status("loyalty").get("desc", ""))
	ok(full.contains("Boon at its limit"),
		"§7: the chip names the fallback where it fires")
	ok(full.contains("%d stacks pay" % (point * 2 - point)),
		"§7: ...and counts the stacks that fell back")
	# AND THE STRIKE FIGURE MOVED WITH IT. The chip's number has to agree with
	# the blow — EU's rule, in the direction EV made possible: a chip still
	# reading the OLD paid half would now under-report a bonus the companion
	# does have.
	var step := 5 + int(bm.wild_communion_step) + int(bm.rune_wild_communion_step)
	ok(full.contains("+%d%% strike damage" % (step * point * 2)),
		"§7: ...and the strike figure reads the restored paid half (+%d%%)" % (step * point * 2))

	# WHERE IT DOES NOT FIRE THE LINE IS ABSENT, because a chip that announced
	# "no stacks fell back" at every depth would be noise rather than
	# legibility — and EU's own CONVERTS line must survive underneath it.
	bm.loyalty[kind] = 9
	scene._stamp_loyalty_chip(bm, comp)
	var window := String(comp.get_status("loyalty").get("desc", ""))
	ok(not window.contains("Boon at its limit"),
		"§7: at the one-stack window the line is ABSENT — nothing fell back")
	ok(window.contains("CONVERTS at %d" % point) and window.contains("(1 converted)"),
		"§7: ...and EU's own converted line still reads the stack that stayed")
	bm.absolute_step = 0
	bm.ancient_pact = 0
	bm.loyalty[kind] = 0


# ── helpers ─────────────────────────────────────────────────────────────────

func _hunter(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and h.passive_id == "pack":
			return h
	return null
