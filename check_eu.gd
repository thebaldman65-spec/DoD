# BATCH EU §6 — THE GATE FOR THE CONVERSION, DRIVEN THROUGH A REAL BATTLE.
#
# EU builds the thing ER ruled: above `BOND_CONVERT` a Loyalty stack stops
# adding to the companion's strike step and feeds the Pack Bond boon instead.
# **THE BRIEF NAMES THE FAILURE THIS GATE EXISTS FOR AND IT IS NOT A TYPO** —
# "a split point that never fires, or fires on the wrong side, would pass every
# static check". That is DS's Heads Down shape exactly: a source read can
# confirm the constant, the helpers and the call sites and still be describing
# a phase change that never happens, or happens to the wrong half.
#
# SO EVERY SECTION HERE IS LIVE. The multipliers are read off a spawned
# battle's own functions, the raw-stack readers are CAST on a real board, and
# §1c measures actual companion damage rather than the multiplier that feeds
# it — because ER's own probe had to sit inside `_comp_dmg_mult` to see the
# truth, and a multiplier nobody spends is not a measurement of a blow.
#
#   §0   the split is decided in ONE place, and the two halves are disjoint
#   §1a  the paid half STOPS at the point (live, both sides)
#   §1b  the converted half RECEIVES at double rate (live, both sides)
#   §1c  **MEASURED ON REAL COMPANION BLOWS** — seeded, two arms, one ratio
#   §2   THE FOUR RAW-STACK READERS DO NOT CONVERT, cast on a live board
#   §3   the three constraints: no cap, Kindred still fires at 8, accrual clean
#   §4   the phase is on the chip, above the point and below it
#
# ── WHY §2 IS THE LONGEST SECTION ───────────────────────────────────────────
# EQ established, and the brief repeats, that the raw-stack readers are "the
# thing most likely to be got wrong". A conversion that reached Unleash would
# change the game's largest single Loyalty payout with nobody ruling it, and it
# would do so SILENTLY — the card would still fire, still log, still spend the
# meter, and simply pay less. Nothing else in the tree would go red. So the
# four are cast rather than read, at two depths that straddle the point, and
# the assertion is that the payout scales with the WHOLE meter.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_eu.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# Seeded blows per arm. BOTH ARMS TAKE THE SAME SEED, so the +/-10% damage roll
# draws an identical stream in each and the only difference between them is the
# meter — DD's rule, check_dk §4's shape, check_ds's precedent.
const BLOWS := 12
const SEED := 20260904

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH EU — LOYALTY CONVERTS AT 8, DRIVEN THROUGH A REAL BATTLE")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_s0_one_place(src)

	var scene: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(scene), "the fixture is headless, so no bot mix is measured")
	var bm: BattleUnit = _hunter(scene)
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		_g.report(self)
		return

	await _s1_the_split(scene, bm)
	await _s2_raw_stack_readers(scene, bm)
	await _s3_constraints(scene, bm)
	_s4_the_chip(scene, bm)

	scene.queue_free()
	_g.report(self)


# ── §0 — THE SPLIT IS DECIDED IN ONE PLACE ──────────────────────────────────
# The source half, and it is deliberately SHORT: it establishes the shape the
# live sections then drive. Its one real job is the property a live test cannot
# see — that no payout site reaches the CONSTANT directly, because a site that
# does is a site a later rune's split-point move would leave behind. That is
# `unit.gd`'s stated reason for `focus_convert()` existing at all.
func _s0_one_place(src: String) -> void:
	print("§0 — the split is decided in one place")
	ok(src.contains("const BOND_CONVERT := 8"),
		"§0: `BOND_CONVERT` is a named constant beside `BOND_STEP`")
	ok(src.contains("func _bond_convert(") and src.contains("func _bond_paid(")
		and src.contains("func _bond_converted("),
		"§0: the point and its two halves are three named functions")
	# THE READERS GO THROUGH THE FUNCTION, NEVER THE CONSTANT. `_bond_convert`
	# is the only site allowed to name it — everything else asks.
	var stripped := Gate.strip_comments(src)
	var naming := 0
	for line in stripped.split("\n"):
		if line.contains("BOND_CONVERT") and not line.contains("const BOND_CONVERT"):
			naming += 1
	ok(naming == 1,
		"§0: exactly one line reads the constant (`_bond_convert`'s return) — got %d" % naming)
	# AND THE RATE IS UNTOUCHED, which is `CLAUDE.md`'s standing rule for this
	# meter stated in the direction that can break it: a batch that "moves the
	# split" by steepening a half instead is the thing the rule forbids.
	ok(stripped.contains("const BOND_STEP := 0.20"),
		"§0: the boon's rate is still 0.20 — the point moved, not the rate")
	ok(stripped.contains("var step := 0.05 + 0.01 * (pm.wild_communion_step"),
		"§0: the strike step is still 0.05 + its nodes — the point moved, not the rate")


# ── §1 — THE SPLIT, LIVE ────────────────────────────────────────────────────
func _s1_the_split(scene: Node, bm: BattleUnit) -> void:
	print("§1 — the split, driven live")
	# THE BEAR, NOT THE WOLF, AND THE FIRST DRAFT OF THIS GATE PROVES WHY.
	# §1c measures the STRIKE STEP off real blows, and Canis's blow also lays
	# Bleed at +2 per RAW Loyalty stack — a reader this batch deliberately did
	# not convert. Against a body with 1e8 max health the bleedout (a % of max
	# HP) dwarfed the strike, and the arm read a ratio of 1.5000 where the
	# strike step had in fact gone flat: **the instrument was measuring the one
	# term §2 exists to keep raw.** Ursus's blow is damage and nothing else.
	await scene._do_summon(bm, "ursus")
	var pack: Array = scene.get("companions")
	ok(pack.size() > 0, "§1: the summon put a companion on the field")
	if pack.is_empty():
		return
	var comp: BattleUnit = pack[0]
	var point: int = scene._bond_convert(bm)
	ok(point == 8, "§1: the live split point reads 8 (got %d)" % point)

	# §1a — THE PAID HALF STOPS. Sampled at the point, one below it and four
	# above: the multiplier must still be climbing below and FLAT above, and
	# "flat" is asserted against the value AT the point rather than against
	# itself, so a step that stopped one stack early or late is a failure.
	bm.loyalty["ursus"] = point - 1
	var strike_below: float = scene._comp_dmg_mult(comp)
	bm.loyalty["ursus"] = point
	var strike_at: float = scene._comp_dmg_mult(comp)
	ok(strike_at > strike_below,
		"§1a: the strike step is still climbing AT the point (%.4f > %.4f)" % [
			strike_at, strike_below])
	var flat := true
	for extra in [1, 2, 4, 8]:
		bm.loyalty["ursus"] = point + extra
		if absf(float(scene._comp_dmg_mult(comp)) - strike_at) > 0.0001:
			flat = false
	ok(flat, "§1a: past the point the strike step does not move — the stack stopped paying it")

	# §1b — THE CONVERTED HALF RECEIVES, AT DOUBLE RATE. Below the point a
	# stack buys one step of the boon; above it, two — its own plus the one it
	# stopped paying the strike. THE RATIO IS ASSERTED, not the magnitude, so
	# this stays true at every talent depth rather than pinning today's 0.20.
	bm.loyalty["ursus"] = point - 2
	var b0: float = scene._bond_mult(bm, "ursus")
	bm.loyalty["ursus"] = point - 1
	var b1: float = scene._bond_mult(bm, "ursus")
	bm.loyalty["ursus"] = point + 1
	var b2: float = scene._bond_mult(bm, "ursus")
	bm.loyalty["ursus"] = point + 2
	var b3: float = scene._bond_mult(bm, "ursus")
	var below := b1 - b0
	var above := b3 - b2
	ok(below > 0.0 and absf(above - 2.0 * below) < 0.0001,
		"§1b: a converted stack feeds the boon at DOUBLE the step (%.4f vs %.4f below)" % [
			above, below])
	# AND THE BOON BELOW THE POINT IS BYTE-FOR-BYTE WHAT IT ALWAYS WAS — the
	# arm that proves this is a conversion and not a general buff.
	bm.loyalty["ursus"] = 5
	ok(absf(float(scene._bond_mult(bm, "ursus")) - 2.0) < 0.0001,
		"§1b: below the point the boon is unchanged — x2.0 at five, exactly as before EU")

	# §1c — MEASURED ON REAL COMPANION BLOWS. §1a reads the multiplier; this
	# spends it. Two arms, the same seed, the same body: at the point and at
	# twice the point, the damage must be the SAME, because every stack in
	# between converted. A conversion that never reached the blow would show
	# up here as a ratio above 1.0 and nowhere else.
	var foe: BattleUnit = scene.get("enemies")[0]
	# THE FIELD IS NARROWED TO ONE BODY, AND THE SECOND DRAFT OF THIS GATE
	# PROVES WHY. Ursus's blow also mauls the enemies BESIDE the target, and an
	# adjacent raider that dies in one arm and survives in the other consumes a
	# different number of draws from the seeded stream — the arms then differ by
	# the ROLL rather than by the meter. It read 127 against 131, a ratio of
	# 1.0315, with the strike step provably flat. One standing body is the whole
	# fix: `_adjacent_enemies` finds nothing to sweep, so each arm is exactly
	# BLOWS calls with an identical stream.
	for e in scene.get("enemies"):
		if e != foe:
			e.dead = true
	var at_point := await _companion_damage(scene, bm, comp, foe, point)
	var far_above := await _companion_damage(scene, bm, comp, foe, point * 2)
	ok(at_point > 0, "§1c: the companion actually dealt damage (%d over %d blows)" % [
		at_point, BLOWS])
	var ratio := (float(far_above) / float(at_point)) if at_point > 0 else 0.0
	# EQUALITY, NOT A TOLERANCE. Both arms draw the same stream against the same
	# body and every term between them converted, so the totals are the same
	# INTEGERS — a tolerance here would let a real one-stack slip in the split
	# hide inside it.
	ok(far_above == at_point,
		"§1c: %d Loyalty and %d deal IDENTICAL companion damage — ratio %.4f (%d vs %d)" % [
			point, point * 2, ratio, at_point, far_above])
	# THE CONTROL ARM FOR §1c, AND IT IS WHY THE RATIO ABOVE IS NOT VACUOUS: a
	# measurement that reads 1.0000 because the harness moved nothing looks
	# exactly like one that reads 1.0000 because the conversion worked. BELOW
	# the point the same instrument must show the step still paying.
	var half := await _companion_damage(scene, bm, comp, foe, point / 2)
	ok(half > 0 and half < at_point,
		"§1c CONTROL: below the point the same instrument still moves (%d at %d vs %d at %d)" % [
			half, point / 2, at_point, point])


# One arm of §1c: BLOWS companion strikes at a fixed Loyalty, seeded, against a
# body that cannot die and cannot accumulate state between blows.
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


# ── §2 — THE FOUR RAW-STACK READERS DO NOT CONVERT ──────────────────────────
# CAST, not read. Each is driven at two depths that straddle the point and the
# payout is required to scale with the WHOLE meter — which is exactly what
# would stop being true if any of them had been re-pointed at `_bond_paid`.
func _s2_raw_stack_readers(scene: Node, bm: BattleUnit) -> void:
	print("§2 — the four raw-stack readers, cast on a live board")
	var point: int = scene._bond_convert(bm)
	var foe: BattleUnit = scene.get("enemies")[0]
	var comp: BattleUnit = scene.get("companions")[0]

	# (1) UNLEASH — the game's largest single Loyalty payout. 0.20 x stacks x
	# Attack, and it EMPTIES the meter, so each arm re-seats it. The two arms
	# are the point and twice the point: a converted Unleash would pay the
	# same at both, which is the failure this whole section exists for.
	var ul: Ability = Classes.pool_ability("Unleash")
	ok(ul != null, "§2: `Classes.pool_ability(\"Unleash\")` builds the card")
	if ul != null:
		var one := await _spender_damage(scene, bm, comp, foe, ul, point)
		var two := await _spender_damage(scene, bm, comp, foe, ul, point * 2)
		var r := (float(two) / float(one)) if one > 0 else 0.0
		ok(one > 0, "§2: Unleash dealt damage at %d Loyalty (%d)" % [point, one])
		ok(absf(r - 2.0) < 0.02,
			"§2: UNLEASH READS THE RAW METER — twice the stacks, twice the payout (ratio %.4f)" % r)

	# (2) PRIMAL SURGE — 0.15 x stacks x Attack per companion, and it empties
	# the meter too. Same two arms, same question.
	var ps: Ability = Classes.pool_ability("Primal Surge")
	ok(ps != null, "§2: `Classes.pool_ability(\"Primal Surge\")` builds the card")
	if ps != null:
		var one2 := await _spender_damage(scene, bm, comp, foe, ps, point)
		var two2 := await _spender_damage(scene, bm, comp, foe, ps, point * 2)
		var r2 := (float(two2) / float(one2)) if one2 > 0 else 0.0
		ok(one2 > 0, "§2: Primal Surge dealt damage at %d Loyalty (%d)" % [point, one2])
		ok(absf(r2 - 2.0) < 0.02,
			"§2: PRIMAL SURGE READS THE RAW METER — ratio %.4f" % r2)

	# (3) BRING IT DOWN — party-wide, and its own hard cap is what makes the
	# arms small: 2 points a stack against a cap of 20, so 3 and 6 stacks are
	# both under it and the amp must double. THE CAP IS ASSERTED SEPARATELY,
	# because a conversion that reached this card would show up as the cap
	# binding LATER rather than as a smaller number.
	var bid: Ability = Classes.pool_ability("Bring It Down")
	if bid != null:
		var per: int = int(scene.get("BRING_IT_DOWN_PER"))
		var cap: int = int(scene.get("BRING_IT_DOWN_CAP"))
		for stacks in [3, 6]:
			_clear_amp(scene)
			bm.loyalty[comp.companion_kind] = stacks
			await scene._resolve_special(bm, bid, bm, "good", 1.0)
			var want: int = mini(stacks * per, cap)
			var got := 0
			for h in scene.get("heroes"):
				if not h.dead and h.has_status("bring_it_down"):
					got = maxi(got, int(h.status_power("bring_it_down")))
			ok(got == want,
				"§2: BRING IT DOWN READS THE RAW METER — %d stacks stamp +%d%% (got +%d%%)" % [
					stacks, want, got])
		_clear_amp(scene)

	# (4) LAST HOWL — it banks the meter the DYING companion held, at the
	# death, which is why this arm kills the beast rather than casting a card.
	# `last_howl` is a status the hunter wears; `last_howl_dmg` is the banked
	# total, and it must read the whole meter and not the paid half.
	bm.last_howl = 3
	bm.last_howl_dmg = 0
	var howl_stacks: int = point * 2
	bm.loyalty[comp.companion_kind] = howl_stacks
	scene._on_beast_death(comp)
	ok(bm.last_howl_dmg == 3 * howl_stacks,
		"§2: LAST HOWL READS THE RAW METER — %d stacks bank +%d%% (got +%d%%)" % [
			howl_stacks, 3 * howl_stacks, bm.last_howl_dmg])
	bm.last_howl = 0
	bm.last_howl_dmg = 0

	# (5) AND THE GIFTS, WHICH ARE RAW READS INSIDE A FUNCTION THAT ALSO READS
	# THE PAID HALF. `_ghost_hit` and `_companion_strike` each hold both, one
	# stack count feeding the strike step and another feeding Aguila's armor
	# pierce or Canis's Bleed. A single `l` serving both would have converted
	# the gift silently, so the two names are asserted apart at their source.
	var stripped := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var ghost: String = stripped.split("func _ghost_hit(")[1].split("\nfunc ")[0]
	ok(ghost.contains("var paid: int = _bond_paid(hunter, l)"),
		"§2: `_ghost_hit`'s strike step reads the PAID half")
	ok(ghost.contains("(0.20 * l) if kind == \"aguila\""),
		"§2: ...and Aguila's pierce beside it still reads the WHOLE meter")


# One arm of a spender: re-seat the meter, cast, read the damage off the body.
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


func _clear_amp(scene: Node) -> void:
	for h in scene.get("heroes"):
		h.remove_status("bring_it_down")
	for c in scene.get("companions"):
		c.remove_status("bring_it_down")


# ── §3 — THE THREE CONSTRAINTS ──────────────────────────────────────────────
func _s3_constraints(scene: Node, bm: BattleUnit) -> void:
	print("§3 — the three constraints")
	# (1) NO CAP, ANYWHERE. The conversion writes nothing into the accrual, so
	# this is asserted the way `test_batch_ay` asserts it — by GAINING, not by
	# reading a constant. Forty gains must reach forty.
	bm.loyalty["ursus"] = 0
	for _i in 40:
		scene._gain_loyalty(bm, "ursus", 1)
	ok(int(bm.loyalty["ursus"]) >= 40,
		"§3: forty gains reach %d — the conversion introduced no ceiling" % \
			int(bm.loyalty["ursus"]))
	ok(int(scene._loyalty_cap(bm)) == int(scene.get("LOYALTY_UNCAPPED")),
		"§3: `_loyalty_cap` still returns the uncapped sentinel")

	# (2) KINDRED IS A ROW-8 NODE AND THE POINT IS 8. This is the constraint
	# the brief states as "any cap below 8 makes Kindred unreachable", and the
	# conversion satisfies it structurally — but the two 8s meeting is worth
	# asserting rather than trusting, because they came from different places.
	var point: int = scene._bond_convert(bm)
	bm.kindred = 8
	ok(point == bm.kindred,
		"§3: the split point (%d) is exactly Kindred's threshold (%d) — the row-8 node sits ON it, not past it" % [
			point, bm.kindred])
	bm.kindred = 0

	# (3) THE ACCRUAL IS UNTOUCHED, ASSERTED WHERE IT COULD BREAK. `_gain_loyalty`
	# and `_loyalty_cap` must not have learned about the split at all — that is
	# the property `CLAUDE.md` calls "the whole reason the shape was ruled".
	var stripped := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	for fn in ["_gain_loyalty(", "_loyalty_cap("]:
		var body: String = stripped.split("func " + fn)[1].split("\nfunc ")[0]
		ok(not body.contains("_bond_paid") and not body.contains("_bond_converted")
			and not body.contains("BOND_CONVERT"),
			"§3: `%s` never reads the split — the accrual is untouched" % fn)


# ── §4 — THE PHASE IS VISIBLE ───────────────────────────────────────────────
# `CLAUDE.md`: "a silent second phase is a stat nobody knows they have." The
# chip is asserted at BOTH depths deliberately — a phase a player only learns
# about by crossing it is still a surprise, and Focus's nameplate prints its
# second half at zero Focus.
func _s4_the_chip(scene: Node, bm: BattleUnit) -> void:
	print("§4 — the phase is visible")
	var comp: BattleUnit = null
	for c in scene.get("companions"):
		if not c.dead:
			comp = c
	if comp == null:
		ok(false, "§4: no living companion to stamp a chip on")
		return
	var point: int = scene._bond_convert(bm)
	var kind: String = comp.companion_kind

	bm.loyalty[kind] = point - 3
	scene._stamp_loyalty_chip(bm, comp)
	var below := String(comp.get_status("loyalty").get("desc", ""))
	ok(below.contains("CONVERTS at %d" % point),
		"§4: the chip names the point BELOW it — the player learns the phase before reaching it")
	ok(not below.contains("converted)"),
		"§4: ...and does not claim a converted stack it does not have")

	bm.loyalty[kind] = point + 5
	scene._stamp_loyalty_chip(bm, comp)
	var above := String(comp.get_status("loyalty").get("desc", ""))
	ok(above.contains("(5 converted)"),
		"§4: the chip counts the converted stacks ABOVE the point")
	# AND THE STRIKE FIGURE ON THE CHIP MUST AGREE WITH THE BLOW. A chip still
	# multiplying by the whole meter would print a bonus the companion does not
	# have, which is worse than the silent phase: a visible number the game
	# disagrees with. Both depths print the SAME strike figure, because every
	# stack between them converted.
	var step := 5 + int(bm.wild_communion_step) + int(bm.rune_wild_communion_step)
	ok(above.contains("+%d%% strike damage" % (step * point)),
		"§4: the chip's strike figure reads the PAID half (+%d%%)" % (step * point))
	bm.loyalty[kind] = point
	scene._stamp_loyalty_chip(bm, comp)
	var at := String(comp.get_status("loyalty").get("desc", ""))
	ok(at.split("\n")[0] == above.split("\n")[0].replace(
			"Loyalty %d" % (point + 5), "Loyalty %d" % point),
		"§4: ...and it is the same figure at the point as five stacks past it")


# ── helpers ─────────────────────────────────────────────────────────────────

func _hunter(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and h.passive_id == "pack":
			return h
	return null
