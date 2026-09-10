# BATCH FT — THE THREE CLASS SPINES, AND THE PROOF THAT NOBODY HOLDS ONE.
#
#   §0  NOTHING IS ATTACHED, AND THIS IS THE SECTION THAT INVERTS. The three
#       switches read FALSE on every live spec's spawn, no spec passive names
#       one, and nothing under `scripts/` or `data/` assigns one. The day a
#       spine is attached this section goes red and the batch attaching it
#       rewrites it — the way `check_ez` §1 and `check_fk` §2 both did.
#   §1  CHANNEL — the build half reads the COST and cannot see the ability,
#       asserted against `note_resource_spent`'s own source AND driven; the
#       payout moves real damage at the one general multiplier.
#   §2  MOMENTUM — BOTH halves in ONE span or no step, one step per turn, and
#       the payout read from ONE function at THREE sites with `effective_speed`
#       deliberately untouched.
#   §3  SANCTITY — an EVENT counter and not Trapper's state reader, a refresh
#       books nothing, apply-and-remove inside a turn books ONE, a natural
#       expiry books nothing, and the duration payout is driven off the APPLIER.
#       The reachable population is COUNTED and printed, not described.
#   §4  THE ANTI-INERT WALK — every field this batch declares is read somewhere
#       in `scripts/`, and every payout is guarded. A payload that attaches and
#       pays exactly 1.0000 is this project's most common shipped defect.
#   §5  CHANNEL'S FLOOR (Batch FU) — a free cast counts as a floor value of
#       Mana, driven through `_resolve` at all three Mage specs: a free cast
#       books the floor, a costed one its net and never net + floor, a clamped
#       one the floor, a counter nothing and a Warrior nothing — and the
#       floor's REASON is asserted as a relation, at or under the cheapest
#       price a Mage can pay.
#
# **WHY §0 IS FIRST AND WHY IT IS THE POINT.** This batch lands on `class-merge`
# with the game still whole. Three engines exist, can be driven, and are reached
# by nothing — so the branch stays playable and `main` stays untouched. An
# assertion that they are unreachable is what makes that claim checkable instead
# of a sentence in a report.
#
# **WHAT THIS GATE CANNOT SEE, IN ITS OWN HEADER.** It asserts that the three
# spines are UNREACHABLE and that each one PAYS when it is switched on by hand.
# It says nothing about whether the rates are right — those are flagged, not
# tuned, and `docs/reports/FT.md` carries them for the designer.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ft.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The three switches, by name, because §0 sweeps the source for assignments to
# them and a sweep needs a population it did not invent.
const SWITCHES := ["momentum_active", "channel_active", "sanctity_active"]

# The fields this batch declares on `BattleUnit`. §4 asserts each is read
# somewhere under `scripts/`, which is `check_fk` §3's walk pointed at a spine.
const FT_FIELDS := ["momentum", "momentum_dealt", "momentum_taken",
	"mana_spent", "sanctity_events"]

# The three payouts. Each returns its IDENTITY value with its switch off.
const PAYOUTS := {
	"channel_bonus": 0.0,
	"momentum_delay_mult": 1.0,
	"sanctity_turn_bonus": 0,
}

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	await _s0_nothing_is_attached()
	await _s1_channel()
	await _s2_momentum()
	await _s3_sanctity()
	_s4_anti_inert()
	await _s5_the_floor()
	_g.report(self)


# Every `.gd` under a directory, recursively, as {path: comment-stripped source}.
# Comments are stripped for `check_ds`'s reason, which this project has paid for
# twice: prose describing a thing that was removed necessarily NAMES it, and a
# rule that reads comments accuses the sentence recording its own repair.
func _sources(dir_path: String) -> Dictionary:
	var out := {}
	var d := DirAccess.open(dir_path)
	if d == null:
		return out
	d.list_dir_begin()
	var f := d.get_next()
	while f != "":
		var full := dir_path + "/" + f
		if d.current_is_dir():
			if not f.begins_with("."):
				out.merge(_sources(full))
		elif f.ends_with(".gd"):
			out[full] = Gate.strip_comments(
				FileAccess.get_file_as_string(full))
		f = d.get_next()
	return out


# ── §0 ──────────────────────────────────────────────────────────────────────
func _s0_nothing_is_attached() -> void:
	print("\n§0 — the three spines exist and nothing reaches them")

	# (a) NO SPEC PASSIVE IS ONE OF THE THREE. `SPEC_INFO[spec]["passive"]` is
	# what `passive_id` is stamped from, so this is the table a spine would have
	# to enter to be attached at all.
	var named := 0
	for spec in Classes.SPEC_INFO:
		var p := String(Classes.SPEC_INFO[spec].get("passive", ""))
		if p in ["momentum", "channel", "sanctity"]:
			named += 1
	ok(named == 0,
		"§0a: no spec passive is momentum, channel or sanctity (checked %d specs)"
			% Classes.SPEC_INFO.size())
	ok(Classes.SPEC_INFO.size() == 12,
		"§0a: ...and the spec table is the whole twelve, so that sweep is not vacuous")

	# (b) NOTHING UNDER `scripts/` OR `data/` ASSIGNS A SWITCH. The DECLARATION
	# is excluded by matching an assignment shape — `X = ` or `X=` after a dot or
	# a line start — while `var X := false` is not one. The gate's own file is
	# OUTSIDE this population on purpose: it sets all three by hand to drive
	# them, which is the only way to prove they pay anything.
	var src := _sources("res://scripts")
	src.merge(_sources("res://data"))
	ok(src.size() >= 10,
		"§0b: the swept population is %d .gd files under scripts/ and data/" % src.size())
	var writes := 0
	var where := []
	for path in src:
		for raw in String(src[path]).split("\n"):
			var line := String(raw)
			for sw in SWITCHES:
				var at := line.find(sw)
				if at < 0:
					continue
				# a DECLARATION is `var <name> :=`, never an assignment
				if line.strip_edges().begins_with("var " + sw):
					continue
				var rest := line.substr(at + sw.length()).strip_edges()
				if rest.begins_with("=") and not rest.begins_with("=="):
					writes += 1
					where.append("%s: %s" % [path, line.strip_edges()])
	ok(writes == 0,
		"§0b: nothing under scripts/ or data/ assigns a spine switch (found %d: %s)"
			% [writes, ", ".join(where)])

	# (c) AND THE ARM THAT PROVES (b) CAN BITE. The same matcher, run over a
	# constructed line, has to find one — otherwise a zero above means only that
	# the matcher never worked. This is the two-armed control the project's own
	# rules require, armed in the direction the sweep is supposed to fire.
	var probe := "\tu.channel_active = true\n\tvar channel_active := false\n"
	var probe_hits := 0
	for raw in probe.split("\n"):
		var line := String(raw)
		for sw in SWITCHES:
			var at := line.find(sw)
			if at < 0:
				continue
			if line.strip_edges().begins_with("var " + sw):
				continue
			var rest := line.substr(at + sw.length()).strip_edges()
			if rest.begins_with("=") and not rest.begins_with("=="):
				probe_hits += 1
	ok(probe_hits == 1,
		"§0c: the matcher finds the constructed assignment and NOT the declaration beside it (%d)"
			% probe_hits)

	# (d) DRIVEN. A real party of four live specs spawns with all three switches
	# off and all three payouts at their identity value. This is the arm that
	# inverts: attaching a spine makes it red.
	var scene: Node = await Gate.spawn(self,
		["berserker", "arcanist", "holy", "sharpshooter"])
	var heroes: Array = scene.get("heroes")
	ok(heroes.size() == 4, "§0d: four heroes on the board")
	var off := 0
	var identity := 0
	for h in heroes:
		for sw in SWITCHES:
			if not bool(h.get(sw)):
				off += 1
		if is_equal_approx(h.channel_bonus("arcane"), 0.0):
			identity += 1
		if is_equal_approx(h.momentum_delay_mult(), 1.0):
			identity += 1
		if h.sanctity_turn_bonus() == 0:
			identity += 1
	ok(off == 12, "§0d: all three switches read false on all four heroes (%d of 12)" % off)
	ok(identity == 12,
		"§0d: and all three payouts return their identity value (%d of 12)" % identity)
	scene.queue_free()
	await process_frame


# ── §1 ──────────────────────────────────────────────────────────────────────
func _s1_channel() -> void:
	print("\n§1 — Channel builds on the cost and pays spell damage")

	# (a) ELEMENT-BLIND BY CONSTRUCTION, ASSERTED AGAINST THE SOURCE. The build
	# half is one function and it may name none of these. A driven check cannot
	# prove this: a function that reads the ability and happens not to branch on
	# it today passes every drive.
	var unit_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var lines := unit_src.split("\n")
	var body := ""
	var inside := false
	for raw in lines:
		var line := String(raw)
		if line.begins_with("func note_resource_spent"):
			inside = true
			continue
		if inside:
			if line.begins_with("func ") or line.begins_with("static func "):
				break
			body += line + "\n"
	ok(body.strip_edges() != "", "§1a: `note_resource_spent`'s body was found")
	var blind := true
	for needle in ["dmg_type", "ab.", "ability", "display_name", "school",
			"element", "is_spell"]:
		if body.contains(needle):
			blind = false
	ok(blind,
		"§1a: it names no ability, element, school or damage type — it reads the COST")
	# BATCH FU — POINTED AT THE NEW FORM. The door also reads whether its caller
	# says the booking is a cast, and the floor; the blind half above is the
	# same list and still names nothing about what was cast.
	ok(body.contains("resource_name") and body.contains("mana_spent")
			and body.contains("rage_spent") and body.contains("CHANNEL_CAST_FLOOR"),
		"§1a: ...and what it DOES read is the bar's name, the two spend meters and the floor")

	# (b) TWO FIELDS, NOT ONE. `rage_spent` holding Mana is a name that lies,
	# and a shared field would make Blood Frenzy's second term readable by a
	# Mage. Driven on two real heroes rather than argued.
	var scene: Node = await Gate.spawn(self,
		["berserker", "arcanist", "holy", "sharpshooter"])
	var heroes: Array = scene.get("heroes")
	var war: BattleUnit = heroes[0]
	var mage: BattleUnit = heroes[1]
	ok(war.resource_name == "Rage" and mage.resource_name == "Mana",
		"§1b: the Warrior spends Rage and the Mage spends Mana")
	mage.note_resource_spent(30)
	war.note_resource_spent(30)
	ok(mage.mana_spent == 30 and mage.rage_spent == 0,
		"§1b: a Mage's spend lands in `mana_spent` and NOT in `rage_spent`")
	ok(war.rage_spent == 30 and war.mana_spent == 0,
		"§1b: a Warrior's lands in `rage_spent` and NOT in `mana_spent`")

	# (c) THE NET, AND THE CLAMP AT ZERO. The door's own contract: a refund
	# books nothing and a negative books nothing.
	var before := mage.mana_spent
	mage.note_resource_spent(0)
	mage.note_resource_spent(-25)
	ok(mage.mana_spent == before,
		"§1c: zero and a refund book nothing — the clamp the Rage half already had")

	# (d) THE METER AND THE PAYOUT, DRIVEN. Off, it is worth exactly nothing;
	# on, it moves. **THE OFF ARM IS THE ONE THAT MATTERS** — a payload that
	# attaches and pays exactly 1.0000 is what this project ships most often.
	mage.mana_spent = BattleUnit.CHANNEL_MANA_PER_STEP * 3
	ok(mage.channel_steps() == 3,
		"§1d: three steps at %d Mana a step" % BattleUnit.CHANNEL_MANA_PER_STEP)
	ok(is_equal_approx(mage.channel_bonus("arcane"), 0.0),
		"§1d: ...and with the switch OFF the payout is exactly 0.0")
	mage.channel_active = true
	var on := mage.channel_bonus("arcane")
	ok(on > 0.0, "§1d: with the switch ON it pays %.4f" % on)
	ok(is_equal_approx(on, 3.0 * BattleUnit.CHANNEL_STEP_BONUS),
		"§1d: ...and the payout is the STEPS times the step bonus, not a flat number")
	ok(is_equal_approx(mage.channel_bonus("physical"), 0.0),
		"§1d: physical damage is spared — the `not physical` ruling, at its one line")
	mage.mana_spent = BattleUnit.CHANNEL_MANA_PER_STEP * 40
	ok(mage.channel_steps() == BattleUnit.CHANNEL_MAX_STEPS,
		"§1d: and the meter is capped at %d steps" % BattleUnit.CHANNEL_MAX_STEPS)

	# (e) THE PAYOUT REACHES REAL DAMAGE, AND THIS IS THE SECTION A STATIC CHECK
	# CANNOT STAND IN FOR. §1d asserts the arithmetic of the function; this
	# asserts that the function's answer arrives in a health bar.
	#
	# **FOUR CONFOUNDS ARE CLOSED HERE RATHER THAN HOPED AWAY**, because each one
	# on its own produces a difference that reads like a finding:
	#   · THE VICTIM DIES. A body killed on the control arm cannot be struck by
	#     the second, which reads ZERO — indistinguishable from a dead payout.
	#     `_hit` restores health, `dead`, Pressure and the Break state.
	#   · THE ARCANIST'S OWN ENGINE RAMPS. Resonance climbs with every cast and
	#     feeds the same damage pipeline, so alternating cold-then-hot puts every
	#     hot arm LATER and biases the ratio upward — measured at 1.2422 before
	#     it was closed. `_hit` zeroes `second_resource`, and the pair ORDER is
	#     flipped every other iteration so position cannot masquerade as meter.
	#   · THE FIRST READING IS A WARM-UP and is discarded. It measured 0 twice
	#     over on a board where every later arm landed.
	#   · THE ROLL VARIES. Six pairs are summed rather than one compared, and the
	#     ability chosen is the HARDEST-hitting non-physical card so the band is
	#     wide against the roll rather than inside it.
	mage.channel_active = false
	mage.mana_spent = 0
	var enemies: Array = scene.get("enemies")
	var foe: BattleUnit = enemies[0]
	for u in heroes + enemies:
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = -10.0
		u.crit_bonus = -1.0
	foe.max_hp = 500000
	# A NON-PHYSICAL ability, CHOSEN rather than assumed: `apply_kit_overrides`
	# replaces `abilities[0]` for three of the four Mage specs, so "the first
	# card" is not a fixed damage type — and Channel spares physical, so a
	# physical pick would make both arms equal and read as a dead payout.
	var ab: Ability = null
	for cand in mage.abilities:
		if cand != null and cand.damage > 0 and cand.dmg_type != "physical":
			if ab == null or cand.damage > ab.damage:
				ab = cand
	ok(ab != null, "§1e: the Mage holds a damaging non-physical card to test with")
	if ab == null:
		scene.queue_free()
		return
	var full := BattleUnit.CHANNEL_MANA_PER_STEP * BattleUnit.CHANNEL_MAX_STEPS
	var arcane := await _ab_pair(scene, mage, ab, foe, full)
	var cold: int = int(arcane["cold"])
	var hot: int = int(arcane["hot"])
	print("  §1e: %s x6 — cold %d / hot %d (x%.4f)"
		% [ab.display_name, cold, hot, float(hot) / maxf(float(cold), 1.0)])
	ok(cold > 0, "§1e: six control strikes landed for %d in total" % cold)
	var want := 1.0 + BattleUnit.CHANNEL_MAX_STEPS * BattleUnit.CHANNEL_STEP_BONUS
	ok(hot > cold,
		"§1e: the same six with a full meter land for %d — x%.4f"
			% [hot, float(hot) / maxf(float(cold), 1.0)])
	ok(absf(float(hot) / maxf(float(cold), 1.0) - want) < 0.01,
		"§1e: ...and the LIVE pipeline reproduces the payout's own arithmetic — x%.4f against x%.4f"
			% [float(hot) / maxf(float(cold), 1.0), want])

	# (f) AND THE PHYSICAL ARM IS THE CONTROL THAT MAKES (e) MEAN SOMETHING. The
	# *not physical* ruling has to reach the damage PIPELINE and not only the
	# function: a `channel_bonus` that returned 0.0 for physical while the payout
	# was read somewhere that ignored the return would pass §1d and fail here.
	#
	# **IT IS THE SAME CARD WITH ITS DAMAGE TYPE CHANGED, AND THAT IS THE WHOLE
	# DESIGN OF THE ARM.** A different physical card means a different hero, and
	# every hero in this game carries a meter that ramps with casts — the first
	# draft of this control used the Sharpshooter's Aimed Shot and read x1.1015
	# on a payout that pays physical nothing, because his basic is a SEQUENCE and
	# his Focus climbs. Changing one field on one card holds the caster, the
	# victim, the roll, the order and every ramp fixed, so the only thing that
	# differs between this pair and the pair above is the word this ruling turns
	# on.
	var was_type := ab.dmg_type
	ab.dmg_type = "physical"
	var pair := await _ab_pair(scene, mage, ab, foe, full)
	ab.dmg_type = was_type
	var pc: int = int(pair["cold"])
	var ph: int = int(pair["hot"])
	print("  §1f: the same card as physical x6 — cold %d / hot %d (x%.4f)"
		% [pc, ph, float(ph) / maxf(float(pc), 1.0)])
	ok(pc > 0, "§1f: six physical control strikes landed for %d" % pc)
	ok(ph == pc,
		"§1f: a full meter moves the SAME card, read as physical, by EXACTLY nothing (%d against %d) — the ruling reaches the pipeline"
			% [ph, pc])
	ok(ab.dmg_type == was_type, "§1f: ...and the card is put back the way it was found")
	scene.queue_free()
	await process_frame


# SIX PAIRS OF ONE STRIKE, the meter off and on, with the ORDER INSIDE THE PAIR
# FLIPPED every other iteration. Returns the two sums. The flip is the whole
# reason this is a function rather than a loop written twice: a difference that
# follows the position rather than the meter survives one order and dies in the
# other, and only running both can tell them apart.
func _ab_pair(scene: Node, u: BattleUnit, ab: Ability, foe: BattleUnit,
		full: int) -> Dictionary:
	u.channel_active = false
	u.mana_spent = 0
	await _hit(scene, u, ab, foe)   # the warm-up, discarded
	var cold := 0
	var hot := 0
	for i in 6:
		if i % 2 == 0:
			u.channel_active = false
			u.mana_spent = 0
			cold += await _hit(scene, u, ab, foe)
			u.channel_active = true
			u.mana_spent = full
			hot += await _hit(scene, u, ab, foe)
		else:
			u.channel_active = true
			u.mana_spent = full
			hot += await _hit(scene, u, ab, foe)
			u.channel_active = false
			u.mana_spent = 0
			cold += await _hit(scene, u, ab, foe)
	u.channel_active = false
	u.mana_spent = 0
	return {"cold": cold, "hot": hot}


# One strike, resolved through the real path, returning the health it removed.
# The victim is reset first so two arms are measured from the same body.
func _hit(scene: Node, attacker: BattleUnit, ab: Ability,
		victim: BattleUnit) -> int:
	# THE BODY IS PUT BACK BETWEEN ARMS, `dead` INCLUDED. Resetting health alone
	# leaves the flag standing, and `_resolve` refuses a dead target — so the
	# second arm reads 0 and looks exactly like a payout that pays nothing.
	victim.hp = victim.max_hp
	victim.dead = false
	victim.pressure = 0
	victim.broken = false
	victim.broken_pending = false
	victim.refresh_bars()
	attacker.resource = attacker.max_resource
	# THE CASTER'S OWN SPEC METER IS ZEROED TOO. Resonance feeds the SAME damage
	# pipeline this is measuring and it climbs with every cast, so leaving it
	# standing means the instrument is reading the untouched term.
	attacker.second_resource = 0
	# **AND THE ROLL IS SEEDED, WHICH IS WHAT MAKES A ONE-STRIKE A/B HONEST.**
	# `randf_range(0.9, 1.1)` is a plus-or-minus ten per cent band on every
	# blow, and six-pair sums still left a physical control reading between
	# x0.9537 and x1.0349 across three runs — a spread that swallows a real
	# finding and manufactures a false one in equal measure. Re-seeding puts
	# both arms on the SAME draw, so what is left between them is the
	# multiplier and nothing else. Measured, not assumed: the arcane pair now
	# reproduces the payout's own arithmetic to four places.
	seed(90210)
	var before := victim.hp
	var done := [false]
	var task := func():
		await scene._resolve(attacker, ab, victim, "good")
		done[0] = true
	task.call()
	for _i in 400:
		if done[0]:
			break
		if scene.sc_active:
			scene.sc_pos = 0.99
			scene._grade_skill_check()
		await process_frame
	return before - victim.hp


# ── §2 ──────────────────────────────────────────────────────────────────────
func _s2_momentum() -> void:
	print("\n§2 — Momentum reads the exchange and pays initiative")

	var scene: Node = await Gate.spawn(self,
		["berserker", "arcanist", "holy", "sharpshooter"])
	var heroes: Array = scene.get("heroes")
	var bz: BattleUnit = heroes[0]

	# (a) BOTH HALVES OR NO STEP, and each of the three cases is driven. A
	# one-sided span is the case that must book nothing, because a meter that
	# paid for taking a blow alone would invert against every batch that helps
	# the party — CZ §1's standing rule, one engine along.
	bz.momentum = 0
	bz.momentum_dealt = 0
	bz.momentum_taken = 0
	ok(not bz.note_momentum_turn(), "§2a: an empty span books nothing")
	bz.momentum_dealt = 40
	ok(not bz.note_momentum_turn(), "§2a: dealing alone books nothing")
	bz.momentum_taken = 40
	ok(not bz.note_momentum_turn(), "§2a: taking alone books nothing — the accumulators were cleared")
	bz.momentum_dealt = 40
	bz.momentum_taken = 40
	ok(bz.note_momentum_turn(), "§2a: dealing AND taking in one span books a step")
	ok(bz.momentum == 1, "§2a: ...and the meter reads 1")

	# (b) THE SPAN IS CLOSED WHETHER OR NOT A STEP WAS EARNED. Leaving a lone
	# accumulator standing would let a turn he only dealt on and a later turn he
	# only took on add up to a step between them — the opposite of "both halves,
	# in the same turn".
	ok(bz.momentum_dealt == 0 and bz.momentum_taken == 0,
		"§2b: booking a step clears both accumulators")
	bz.momentum_dealt = 40
	bz.note_momentum_turn()
	bz.momentum_taken = 40
	ok(not bz.note_momentum_turn(),
		"§2b: and a lone deal in one span cannot pair with a lone take in the next")

	# (c) A BERSERKER AND A WARDEN BUILD IT IDENTICALLY. That is the property
	# that makes it a CLASS core rather than a spec passive: it reads the
	# exchange and knows nothing about the style. **A SECOND BOARD, because the
	# two are both Warriors and cannot stand in one party** — and the source is
	# asserted beside the drive, since a function that happened not to branch on
	# the spec today would pass the drive and fail the day one was added.
	var scene_b: Node = await Gate.spawn(self,
		["warden", "arcanist", "holy", "sharpshooter"])
	var wd: BattleUnit = scene_b.get("heroes")[0]
	ok(wd.passive_id == "heavy_plating", "§2c: the second board's seat 0 is a Warden")
	wd.momentum = 0
	wd.momentum_dealt = 40
	wd.momentum_taken = 40
	ok(wd.note_momentum_turn() and wd.momentum == 1,
		"§2c: the Warden books the same step off the same span the Berserker did")
	var u_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var step_body := ""
	var in_fn := false
	for raw in u_src.split("\n"):
		var line := String(raw)
		if line.begins_with("func note_momentum_turn"):
			in_fn = true
			continue
		if in_fn:
			if line.begins_with("func ") or line.begins_with("static func "):
				break
			step_body += line + "\n"
	var spec_blind := true
	for needle in ["passive_id", "spec", "stance", "hero_key", "unit_name"]:
		if step_body.contains(needle):
			spec_blind = false
	ok(step_body.strip_edges() != "" and spec_blind,
		"§2c: ...and the step function names no spec, passive, stance or hero key")
	scene_b.queue_free()
	await process_frame

	# (d) THE CAP.
	bz.momentum = BattleUnit.MOMENTUM_MAX_STEPS
	bz.momentum_dealt = 40
	bz.momentum_taken = 40
	bz.note_momentum_turn()
	ok(bz.momentum == BattleUnit.MOMENTUM_MAX_STEPS,
		"§2d: the meter is capped at %d steps" % BattleUnit.MOMENTUM_MAX_STEPS)

	# (e) THE PAYOUT — OFF, THEN ON. The off arm is the 1.0000 arm.
	ok(is_equal_approx(bz.momentum_delay_mult(), 1.0),
		"§2e: with the switch OFF a full meter is worth exactly 1.0000")
	bz.momentum_active = true
	var mult := bz.momentum_delay_mult()
	ok(mult < 1.0, "§2e: with it ON a full meter scales the delay to %.4f" % mult)
	ok(is_equal_approx(mult,
			1.0 - BattleUnit.MOMENTUM_MAX_STEPS * BattleUnit.MOMENTUM_STEP_HASTE),
		"§2e: ...and it is the steps times the step, not a flat discount")
	bz.momentum = 0
	ok(is_equal_approx(bz.momentum_delay_mult(), 1.0),
		"§2e: an empty meter is worth 1.0000 even with the switch on")

	# (f) IT REACHES THE TIMELINE. A real ability's schedule, both arms.
	var ab: Ability = bz.abilities[0]
	bz.momentum_active = false
	bz.momentum = 0
	bz.next_time = 0.0
	bz.next_time += bz.momentum_delay_mult() * ab.delay * 100.0 / bz.effective_speed()
	var cold := bz.next_time
	bz.momentum_active = true
	bz.momentum = BattleUnit.MOMENTUM_MAX_STEPS
	bz.next_time = 0.0
	bz.next_time += bz.momentum_delay_mult() * ab.delay * 100.0 / bz.effective_speed()
	var hot := bz.next_time
	ok(cold > 0.0, "§2f: the control schedule puts his next turn at %.2f" % cold)
	ok(hot < cold, "§2f: a full meter brings it forward to %.2f" % hot)
	bz.momentum_active = false

	# (h) AND IT REACHES THE REAL SCHEDULING LINE, DRIVEN THROUGH `_resolve`.
	# (f) asserts the arithmetic; this asserts that the arithmetic is what the
	# fight actually uses. **A meter that pays through a SECOND write site would
	# pass every arm above** — the delay would move and the timeline would not,
	# or the reverse — which is why the measurement is the delta `_resolve`
	# itself puts on `next_time` rather than a number this file computes.
	var ab2: Ability = null
	for cand in bz.abilities:
		if cand != null and cand.delay > 0.0:
			ab2 = cand
			break
	ok(ab2 != null, "§2h: the Berserker holds a card with a delay to schedule")
	if ab2 != null:
		var foe2: BattleUnit = scene.get("enemies")[0]
		foe2.max_hp = 500000
		bz.momentum_active = false
		bz.momentum = 0
		var slow_delta := await _schedule(scene, bz, ab2, foe2)
		bz.momentum_active = true
		bz.momentum = BattleUnit.MOMENTUM_MAX_STEPS
		var fast_delta := await _schedule(scene, bz, ab2, foe2)
		bz.momentum_active = false
		bz.momentum = 0
		var ratio := fast_delta / maxf(slow_delta, 0.0001)
		print("  §2h: %s — next turn scheduled %.4f later with an empty engine, %.4f with a full one (x%.4f)"
			% [ab2.display_name, slow_delta, fast_delta, ratio])
		ok(slow_delta > 0.0, "§2h: the control cast pushed his next turn out by %.4f" % slow_delta)
		ok(fast_delta < slow_delta,
			"§2h: a full meter brings it in to %.4f — the payout reaches the timeline" % fast_delta)
		ok(absf(ratio - (1.0 - BattleUnit.MOMENTUM_MAX_STEPS
				* BattleUnit.MOMENTUM_STEP_HASTE)) < 0.001,
			"§2h: ...and the LIVE delta is exactly the multiplier, x%.4f — one write site, not two"
				% ratio)

	# (g) ONE FUNCTION, THREE READ SITES, AND `effective_speed` UNTOUCHED. A
	# second writer of turn order is a second set of rules for one question, so
	# the count is asserted rather than described. The three are the post-cast
	# schedule, the gated-failure schedule and the initiative PREVIEW.
	var battle_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var reads := battle_src.count("momentum_delay_mult()")
	ok(reads == 3,
		"§2g: `momentum_delay_mult()` is read at exactly 3 sites in battle.gd (found %d)" % reads)
	var unit_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var eff := ""
	var inside := false
	for raw in unit_src.split("\n"):
		var line := String(raw)
		if line.begins_with("func effective_speed"):
			inside = true
			continue
		if inside:
			if line.begins_with("func ") or line.begins_with("static func "):
				break
			eff += line + "\n"
	ok(eff.strip_edges() != "", "§2g: `effective_speed`'s body was found")
	ok(not eff.contains("momentum"),
		"§2g: ...and it carries NO momentum term — the timeline is not bent continuously")
	scene.queue_free()
	await process_frame


# One cast through the real path, returning what `_resolve` added to the
# caster's `next_time`. The DELTA is measured rather than the value, because
# where the clock stands is a fact about the fight and what a cast costs is a
# fact about the engine under test.
func _schedule(scene: Node, u: BattleUnit, ab: Ability,
		victim: BattleUnit) -> float:
	victim.hp = victim.max_hp
	victim.dead = false
	victim.refresh_bars()
	u.resource = u.max_resource
	u.next_time = 0.0
	seed(90210)
	var done := [false]
	var task := func():
		await scene._resolve(u, ab, victim, "good")
		done[0] = true
	task.call()
	for _i in 400:
		if done[0]:
			break
		if scene.sc_active:
			scene.sc_pos = 0.99
			scene._grade_skill_check()
		await process_frame
	return u.next_time


# ── §3 ──────────────────────────────────────────────────────────────────────
func _s3_sanctity() -> void:
	print("\n§3 — Sanctity counts events, not state, and pays duration")

	var scene: Node = await Gate.spawn(self,
		["berserker", "arcanist", "holy", "sharpshooter"])
	var heroes: Array = scene.get("heroes")
	var cleric: BattleUnit = heroes[2]
	var ally: BattleUnit = heroes[1]
	var enemies: Array = scene.get("enemies")
	var foe: BattleUnit = enemies[0]

	# **THE RULE, STATED ONCE: ONE EVENT PER (TURN, BODY, STATUS).** A status
	# moving on a given body in a given turn is worth exactly one, whichever
	# direction it moved and however many times. That single sentence is the
	# whole anti-farming answer and every arm below is a reading of it.
	#
	# THE BODY IS CLEARED BETWEEN ARMS. A status left standing by an earlier arm
	# turns the next arm's application into a REFRESH, which books nothing — and
	# an arm measuring zero for a reason it did not intend reads exactly like an
	# arm measuring zero for the reason it meant to.
	_clear(foe)
	_clear(ally)

	# (a) IT IS NOT TRAPPER'S READER, AND THE DIFFERENCE IS DRIVEN. Trapper's
	# `_status_count` reads a target's status LIST over the curated debuff
	# allowlist — one body, debuffs only, a SNAPSHOT. Sanctity counts events as
	# they happen. A status that lands and leaves is INVISIBLE to the first and
	# is a real event to the second, and that is the whole reason this batch
	# built a second instrument instead of reusing the first.
	BattleUnit.reset_sanctity()
	var before_count: int = scene._status_count(foe)
	foe.add_status("sunder", "Sunder", "D", Color.WHITE, 3, "")
	foe.remove_status("sunder")
	ok(scene._status_count(foe) == before_count,
		"§3a: a status that landed and left leaves Trapper's state reader at %d — unmoved"
			% before_count)
	ok(BattleUnit.sanctity_events == 1,
		"§3a: ...and books %d on the Sanctity ledger, which the state reader cannot see"
			% BattleUnit.sanctity_events)

	# (b) A REFRESH BOOKS NOTHING. The event is a status ARRIVING on a body that
	# did not have it; `add_status`'s refresh branch returns before the door.
	_clear(foe)
	_advance(scene)
	BattleUnit.reset_sanctity()
	foe.add_status("surge", "Surge", "A+", Color.WHITE, 3, "")
	var after_first := BattleUnit.sanctity_events
	_advance(scene)
	foe.add_status("surge", "Surge", "A+", Color.WHITE, 3, "")
	foe.add_status("surge", "Surge", "A+", Color.WHITE, 3, "")
	ok(after_first == 1, "§3b: the first application books one")
	ok(BattleUnit.sanctity_events == 1,
		"§3b: ...and two re-applications on a LATER turn still book nothing (read %d) — it is the refresh that is silent, not the dedupe"
			% BattleUnit.sanctity_events)

	# (c) WHAT STOPS APPLY-AND-REMOVE FARMING, DRIVEN AT THE SCALE THAT WOULD
	# HURT. Eight cycles is worth one, because the key is the pair and not the
	# call. **AND BREADTH IS STILL PAID**: the same status on a second body is a
	# second event, which is the pattern the engine is supposed to reward.
	_clear(foe)
	_clear(ally)
	_advance(scene)
	BattleUnit.reset_sanctity()
	for _i in 8:
		foe.add_status("sunder", "Sunder", "D", Color.WHITE, 3, "")
		foe.remove_status("sunder")
	ok(BattleUnit.sanctity_events == 1,
		"§3c: eight apply-and-remove cycles on one body in one turn book ONE event (read %d)"
			% BattleUnit.sanctity_events)
	ally.add_status("sunder", "Sunder", "D", Color.WHITE, 3, "")
	ok(BattleUnit.sanctity_events == 2,
		"§3c: ...and the same status on a SECOND body books a second — breadth still pays")
	_advance(scene)
	foe.add_status("sunder", "Sunder", "D", Color.WHITE, 3, "")
	ok(BattleUnit.sanctity_events == 3,
		"§3c: ...and the same body and status books again on the NEXT turn — the cap is per turn, not for the battle")

	# (d) A REMOVAL THAT REMOVES NOTHING BOOKS NOTHING. `remove_status` filters
	# unconditionally and is called on bodies that are already clean, so the
	# door counts a DELTA rather than a call.
	_clear(ally)
	_advance(scene)
	BattleUnit.reset_sanctity()
	ally.remove_status("frostbite")
	ally.remove_status("frostbite")
	ok(BattleUnit.sanctity_events == 0,
		"§3d: removing a status that is not standing books nothing (read %d)"
			% BattleUnit.sanctity_events)

	# (e) A NATURAL EXPIRY IS NOT A REMOVAL. A clock running out is time
	# passing, not a hero acting, and a meter that built from it would build for
	# a hero doing nothing.
	_clear(ally)
	_advance(scene)
	BattleUnit.reset_sanctity()
	ally.add_status("surge", "Surge", "A+", Color.WHITE, 1, "")
	var after_apply := BattleUnit.sanctity_events
	ok(after_apply == 1, "§3e: the application books one")
	_advance(scene)
	ally.tick_statuses()
	ok(not ally.has_status("surge"), "§3e: the status expired off the clock")
	ok(BattleUnit.sanctity_events == after_apply,
		"§3e: ...and the expiry booked nothing (still %d, on a fresh turn where a real removal WOULD have booked)"
			% BattleUnit.sanctity_events)

	# (f) A CLEANSE BOOKS WHAT IT ACTUALLY TOOK. `purge_debuffs` takes several
	# at once, so the ids are captured before the filter — a count alone could
	# not say WHICH left, and the ledger is keyed on the status.
	_clear(ally)
	_advance(scene)
	BattleUnit.reset_sanctity()
	ally.add_status("sunder", "Sunder", "D", Color.WHITE, 3, "")
	ally.add_status("slow", "Slowed", "Sl", Color.WHITE, 3, "")
	ally.add_status("surge", "Surge", "A+", Color.WHITE, 3, "")
	var applied := BattleUnit.sanctity_events
	ok(applied == 3, "§3f: three distinct statuses land as three events (read %d)" % applied)
	# THE TURN IS ADVANCED BEFORE THE CLEANSE, because the three keys are
	# already spent on this turn and the rule is one event per pair per turn.
	# Without this the arm would read 0 and look like a broken purge door.
	_advance(scene)
	var took := ally.purge_debuffs()
	ok(took == 2, "§3f: the cleanse takes the two DEBUFFS and leaves the buff (%d)" % took)
	ok(BattleUnit.sanctity_events - applied == 2,
		"§3f: ...and books exactly two removals, not three and not one (read %d)"
			% (BattleUnit.sanctity_events - applied))

	# (g) THE METER AND THE PAYOUT — OFF, THEN ON, THEN DRIVEN THROUGH THE REAL
	# APPLICATION PATH so the duration a status actually LANDS with is measured
	# rather than the function that computes it.
	#
	# **THE METER IS READABLE WITH THE SWITCH OFF AND THE PAYOUT IS NOT**, which
	# is `frenzy_rage_steps()`'s split: a sampler can read the curve without the
	# engine, and the engine can be turned off without blinding the sampler.
	BattleUnit.reset_sanctity()
	BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP * 3
	ok(cleric.sanctity_steps() == 3,
		"§3g: the METER reads three steps with the switch off — it is the payout that is guarded")
	ok(cleric.sanctity_turn_bonus() == 0,
		"§3g: ...and the PAYOUT is exactly 0 turns")
	cleric.sanctity_active = true
	ok(cleric.sanctity_turn_bonus() == 3 * BattleUnit.SANCTITY_STEP_TURNS,
		"§3g: with the switch ON it pays %d extra turns" % cleric.sanctity_turn_bonus())

	_clear(foe)
	_advance(scene)
	scene._apply_status(foe, "sunder", 3, 0, 0, ally)
	var plain: int = int(foe.get_status("sunder").get("turns", 0))
	_clear(foe)
	_advance(scene)
	scene._apply_status(foe, "sunder", 3, 0, 0, cleric)
	var blessed: int = int(foe.get_status("sunder").get("turns", 0))
	ok(plain == 3, "§3g: an ordinary applier lands Sunder for %d turns" % plain)
	ok(blessed == plain + cleric.sanctity_turn_bonus(),
		"§3g: the Sanctity holder lands the SAME status for %d — the payout is off the APPLIER, never the victim"
			% blessed)

	# (h) AND IT MUST NOT UN-PERMANENT A BATTLE-LONG STATUS. A negative turn
	# count is a permanence flag, and adding to it would produce a number
	# nothing downstream understands. This is Emberkeep's guard, re-driven.
	_clear(foe)
	_advance(scene)
	scene._apply_status(foe, "mocked", -1, 0, 0, cleric)
	ok(int(foe.get_status("mocked").get("turns", 0)) == -1,
		"§3h: a battle-long status stays at -1 in the Sanctity holder's hands")
	cleric.sanctity_active = false

	# (i) THE REACHABLE POPULATION, COUNTED AND PRINTED. The payout is read off
	# `src`, and 104 of the 214 `_apply_status` calls pass none — so this line
	# reaches a MEASURED fraction of the game's status applications and the
	# figure is asserted rather than described. **CHECKED n OF m**, because a
	# walk that silently matched nothing prints exactly like a clean one.
	var battle_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var tally := _apply_status_sites(battle_src)
	var total: int = int(tally["total"])
	var with_src: int = int(tally["with_src"])
	print("  §3i: CHECKED %d of %d `_apply_status` call sites — %d carry a source, %d do not"
		% [total, total, with_src, total - with_src])
	ok(total >= 200,
		"§3i: the walk reached %d call sites, which is the population and not a sample" % total)
	ok(with_src + int(tally["no_src"]) == total,
		"§3i: every site is classified — with a source or without, never neither")
	ok(with_src >= 100 and with_src < total,
		"§3i: %d carry a source; the gap to %d is what a later stage has to close"
			% [with_src, total])
	ok(not battle_src.contains("func add_status") ,
		"§3i: `add_status` is not declared in battle.gd — the funnel is unit.gd's")
	var unit_src2 := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var sig := ""
	for raw in unit_src2.split("\n"):
		if String(raw).begins_with("func add_status"):
			sig = String(raw)
			break
	ok(sig != "" and not sig.contains("src"),
		"§3i: ...and the funnel takes NO source, which is why the payout cannot live there")
	scene.queue_free()
	await process_frame


# Everything off a body, so an arm below measures what it means to measure and
# not a refresh of something an earlier arm left standing.
func _clear(u: BattleUnit) -> void:
	u.statuses = []
	u._refresh_chips()


# One turn on, for every body on the field. The Sanctity ledger is keyed on the
# turn, so an arm that wants a fresh key has to move the clock the way the turn
# loop does rather than reach into the ledger.
func _advance(scene: Node) -> void:
	for u in scene.get("heroes") + scene.get("enemies"):
		u.battle_turn += 1


# `_apply_status(` call sites in a comment-stripped source, classified on
# whether they pass a source. Continuation lines are joined by tracking paren
# depth, because a fixed line window runs past its own match; string contents
# are masked so a comma inside a description is not an argument boundary.
func _apply_status_sites(src: String) -> Dictionary:
	var lines := src.split("\n")
	var total := 0
	var with_src := 0
	var no_src := 0
	for i in lines.size():
		var line := String(lines[i])
		if line.begins_with("func _apply_status"):
			continue
		var at := _mask(line).find("_apply_status(")
		if at < 0:
			continue
		total += 1
		var acc := ""
		var depth := 0
		var j := i
		var closed := false
		while j < lines.size() and j < i + 12:
			var chunk := String(lines[j]) if j > i else line.substr(at + 13)
			var mk := _mask(chunk)
			for k in mk.length():
				var c := mk[k]
				if c == "(":
					depth += 1
				elif c == ")":
					depth -= 1
					if depth == 0:
						acc += chunk.substr(0, k + 1)
						closed = true
						break
			if closed:
				break
			acc += chunk + " "
			j += 1
		var args := _split_args(acc)
		if args.size() >= 6 and args[5].strip_edges() != "null":
			with_src += 1
		else:
			no_src += 1
	return {"total": total, "with_src": with_src, "no_src": no_src}


# String contents replaced with X, so a comma or a paren inside a literal is
# invisible to a structural walk. GDScript quote masking cuts both ways and
# this file has only one job for it: never treat text as syntax.
func _mask(s: String) -> String:
	var out := ""
	var quote := ""
	var i := 0
	while i < s.length():
		var c := s[i]
		if quote != "":
			if c == "\\":
				out += "XX"
				i += 2
				continue
			if c == quote:
				quote = ""
				out += c
			else:
				out += "X"
		elif c == "\"" or c == "'":
			quote = c
			out += c
		else:
			out += c
		i += 1
	return out


# Top-level commas only: a nested call's arguments belong to that call.
func _split_args(call: String) -> Array:
	var open_at := call.find("(")
	var close_at := call.rfind(")")
	if open_at < 0 or close_at <= open_at:
		return []
	var inner := call.substr(open_at + 1, close_at - open_at - 1)
	var mk := _mask(inner)
	var out := []
	var depth := 0
	var start := 0
	for i in mk.length():
		var c := mk[i]
		if c == "(" or c == "[" or c == "{":
			depth += 1
		elif c == ")" or c == "]" or c == "}":
			depth -= 1
		elif c == "," and depth == 0:
			out.append(inner.substr(start, i - start).strip_edges())
			start = i + 1
	out.append(inner.substr(start).strip_edges())
	var kept := []
	for a in out:
		if String(a) != "":
			kept.append(a)
	return kept


# ── §4 ──────────────────────────────────────────────────────────────────────
func _s4_anti_inert() -> void:
	print("\n§4 — nothing declared here is inert")

	# EVERY FIELD IS READ SOMEWHERE UNDER `scripts/`. This is `check_fk` §3's
	# walk pointed at a spine: a field that is written and never read is a
	# payload that pays nothing, in silence, and it is what this project ships
	# most often. The DECLARATION line is excluded, so a field read only by its
	# own `var` statement fails.
	var src := _sources("res://scripts")
	var read_somewhere := 0
	for field in FT_FIELDS:
		var found := false
		for path in src:
			for raw in String(src[path]).split("\n"):
				var line := String(raw)
				if not line.contains(field):
					continue
				if line.strip_edges().begins_with("var " + field):
					continue
				if line.strip_edges().begins_with("static var " + field):
					continue
				found = true
				break
			if found:
				break
		if found:
			read_somewhere += 1
		else:
			ok(false, "§4: `%s` is declared and never read outside its declaration" % field)
	ok(read_somewhere == FT_FIELDS.size(),
		"§4: all %d fields this batch declares are read under scripts/ (CHECKED %d of %d)"
			% [FT_FIELDS.size(), read_somewhere, FT_FIELDS.size()])

	# EVERY PAYOUT IS GUARDED. The three functions each open with their own
	# switch, asserted against the source rather than trusted: a payout whose
	# guard was deleted would still return the identity value on a fresh hero
	# and pass every driven arm in §0.
	var unit_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var lines := unit_src.split("\n")
	var guarded := 0
	for fn in PAYOUTS:
		var body := ""
		var inside := false
		for raw in lines:
			var line := String(raw)
			if line.begins_with("func " + fn + "("):
				inside = true
				continue
			if inside:
				if line.begins_with("func ") or line.begins_with("static func "):
					break
				body += line + "\n"
		var want := ""
		for sw in SWITCHES:
			if fn.begins_with(sw.replace("_active", "")):
				want = sw
		if body.contains("if not " + want + ":"):
			guarded += 1
		else:
			ok(false, "§4: `%s` does not open with `if not %s:`" % [fn, want])
	ok(guarded == PAYOUTS.size(),
		"§4: all %d payouts open with their own switch (CHECKED %d of %d)"
			% [PAYOUTS.size(), guarded, PAYOUTS.size()])


# ── §5 ──────────────────────────────────────────────────────────────────────
# BATCH FU — A FREE CAST COUNTS AS A FLOOR VALUE OF MANA, DRIVEN AT ALL THREE
# MAGE SPECS.
#
# **THE RULING IS ONE TERM, NOT TWO.** A cast books `max(net, floor)`, so the
# engine keeps its stated shape — builds per Mana spent — and a cast that took
# nothing off the bar carries a nominal value instead of zero. A parallel
# cast-counter would have been a second mechanism for one question.
#
# **A STATIC CHECK CANNOT TELL THE FLOOR APART FROM ITS TWO WRONG VERSIONS**: one
# that lands on a cast that was never free (a per-cast bonus added on top), and
# one that misses a cast that was. Both read correctly off the constant and off
# the function. So every arm below goes through `_resolve` — the one line every
# cast in the game pays at — on a real spawned Mage of each spec.
#
# **AND THE FLOOR'S REASON IS A RELATION, SO THE RELATION IS ASSERTED (h).** The
# floor is the cheapest price a Mage can pay, which is what makes "it lifts no
# card he pays for" true. A card authored under it is the day (h) reds, and the
# answer is a ruling on the floor rather than an exemption for the card.
func _s5_the_floor() -> void:
	print("\n§5 — a free cast counts as a floor value of Mana, driven at all three Mage specs")
	var fl := BattleUnit.CHANNEL_CAST_FLOOR
	ok(fl > 1 and fl < BattleUnit.CHANNEL_MANA_PER_STEP,
		"§5: the floor is %d Mana, above one and below the %d-Mana step — a nominal value, not a step"
			% [fl, BattleUnit.CHANNEL_MANA_PER_STEP])

	# (g) THE DOOR ITSELF, BEFORE ANYTHING IS SPAWNED. A direct call is not a
	# cast unless its caller says so — which is what keeps `check_cz`'s and §1c's
	# direct calls byte-identical — and the floor names Mana and nothing else.
	var m := BattleUnit.new()
	m.resource_name = "Mana"
	m.note_resource_spent(0)
	ok(m.mana_spent == 0, "§5g: a zero that is not a cast reads %d, want 0 — the door's default" % m.mana_spent)
	m.note_resource_spent(0, true)
	ok(m.mana_spent == fl, "§5g: a zero that IS a cast reads %d, want the floor, %d" % [m.mana_spent, fl])
	m.note_resource_spent(-25, true)
	ok(m.mana_spent == 2 * fl,
		"§5g: a cast that handed back more than it took is still a cast — reads %d, want %d"
			% [m.mana_spent, 2 * fl])
	m.note_resource_spent(fl + 7, true)
	ok(m.mana_spent == 3 * fl + 7,
		"§5g: a cast above the floor books its net, never net + floor — reads %d, want %d" % [m.mana_spent, 3 * fl + 7])
	var w := BattleUnit.new()
	w.resource_name = "Rage"
	w.note_resource_spent(0, true)
	ok(w.rage_spent == 0 and w.mana_spent == 0,
		"§5g: a Warrior's free cast reads %d Rage and %d Mana, want 0 and 0 — no floor on Rage" % [w.rage_spent, w.mana_spent])
	m.free()
	w.free()

	var free_books := []
	# (h)'s MEMBERSHIP: every card name a Mage of any spec can hold. The pools say
	# WHO CAN HOLD a card, which is the award chain's question; what EXISTS is the
	# corpus walk after the loop (DA §3).
	var mage_names := {}
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		var scene: Node = await Gate.spawn(self, ["berserker", spec, "holy", "sharpshooter"])
		var heroes: Array = scene.get("heroes")
		var war: BattleUnit = heroes[0]
		var mage: BattleUnit = heroes[1]
		var foe: BattleUnit = scene.get("enemies")[0]
		# EVERY ENEMY IS MADE UNKILLABLE, not only the target: Barrage's random
		# hits find the lowest-health bodies, and a board that empties ends the
		# fight under the arms that are still measuring it.
		for e in scene.get("enemies"):
			e.max_hp = 500000
			e.hp = 500000

		# (h) MEMBERSHIP, NOT A WALK. The kit this Mage holds as spawned (overrides
		# included), and every channel the award chain reads for his spec — the
		# boss pool, his spec draft pool and his class-wide draft pool, FJ §1's
		# three, all landing in `bm_abilities` through one `hold_ability()`.
		for a in mage.abilities:
			if a != null:
				mage_names[String(a.display_name)] = true
		for nm in Classes.spec_pool(spec) + Classes.spec_draft_pool(spec) \
				+ Classes.class_draft_pool(Classes.class_of_spec(spec)):
			mage_names[String(nm)] = true

		# THE TWO CARDS ARE FOUND OFF THE PRICE, NOT NAMED. The free one is
		# whatever costs nothing here — the basic, today, on all three — and the
		# costed one is the cheapest card at or over the floor with no refund of
		# its own, so its whole cost is what the spend line nets.
		var free_ab: Ability = null
		var paid_ab: Ability = null
		var paid_c := 1 << 30
		for cand in mage.abilities:
			if cand == null:
				continue
			var c: int = scene._eff_cost(mage, cand, foe)
			if c == 0 and free_ab == null:
				free_ab = cand
			if c >= fl and cand.resource_gain == 0 and c < paid_c:
				paid_ab = cand
				paid_c = c
		ok(free_ab != null and paid_ab != null,
			"§5 %s: a free card and a costed card to drive (%s / %s)" % [spec,
				free_ab.display_name if free_ab else "none",
				paid_ab.display_name if paid_ab else "none"])
		if free_ab == null or paid_ab == null:
			scene.queue_free()
			await process_frame
			continue

		# (a) A FREE CAST BOOKS EXACTLY THE FLOOR AND TAKES NOTHING OFF THE BAR.
		# The floor is a nominal value on the LEDGER; the bar never sees it.
		var d := await _cast_delta(scene, mage, free_ab, foe, false, mage.max_resource)
		ok(int(d["bar"]) == 0,
			"§5a %s: %s took %d off the bar, want 0 — a free cast spends nothing" % [
				spec, free_ab.display_name, int(d["bar"])])
		ok(int(d["mana"]) == fl,
			"§5a %s: ...and the ledger reads %d, want the floor, %d" % [spec, int(d["mana"]), fl])
		free_books.append(int(d["mana"]))

		# (b) A COSTED CAST BOOKS WHAT LEFT THE BAR, AND NOT THE FLOOR ON TOP.
		d = await _cast_delta(scene, mage, paid_ab, foe, false, mage.max_resource)
		ok(int(d["mana"]) == paid_c,
			"§5b %s: %s reads %d, want its %d net and never %d — the floor is a minimum, not a bonus" % [
				spec, paid_ab.display_name, int(d["mana"]), paid_c, paid_c + fl])

		# (c) A CAST THAT TOOK LESS THAN THE FLOOR BOOKS THE FLOOR. The clamp at
		# zero is the honest way to put a sub-floor net on a real cast: the bar
		# holds one less than the floor and the card costs more.
		d = await _cast_delta(scene, mage, paid_ab, foe, false, fl - 1)
		ok(int(d["mana"]) == fl,
			"§5c %s: a cast that could only take %d reads %d, want the floor, %d — max(net, floor) is one term" % [
				spec, fl - 1, int(d["mana"]), fl])

		# (d) A RETALIATION IS NOT A CAST. `_resolve`'s `is_counter` is the line's
		# own definition — the Killing Cold and the Overtone read it the same way —
		# and a counter that booked the floor would pay a Mage for being struck.
		d = await _cast_delta(scene, mage, free_ab, foe, true, mage.max_resource)
		ok(int(d["mana"]) == 0,
			"§5d %s: a counter reads %d, want 0 — a retaliation is not a cast" % [spec, int(d["mana"])])

		# (e) THE RAGE HALF IS UNTOUCHED. The same line books a Warrior's free
		# basic, and the floor names Mana.
		var war_free: Ability = null
		for cand in war.abilities:
			if cand != null and scene._eff_cost(war, cand, foe) == 0:
				war_free = cand
				break
		ok(war_free != null, "§5e %s: the Warrior holds a free card" % spec)
		if war_free != null:
			d = await _cast_delta(scene, war, war_free, foe, false, 0)
			ok(int(d["rage"]) == 0 and int(d["mana"]) == 0,
				"§5e %s: the Warrior's free %s reads %d Rage and %d Mana, want 0 and 0" % [
					spec, war_free.display_name, int(d["rage"]), int(d["mana"])])
		scene.queue_free()
		await process_frame

	# (f) ELEMENT-BLIND, DRIVEN. Fire, frost and arcane book the same floor. The
	# SOURCE assertion in §1a is the proof; this is the drive beside it.
	ok(free_books.size() == 3 and free_books.count(fl) == 3,
		"§5f: the free casts of all three Mage specs read %s, want [%d, %d, %d] — identical, the floor" % [str(free_books), fl, fl, fl])

	# (h) THE RELATION, OVER THE CORPUS. `Classes.ability_corpus()` is the one
	# authorised walk (DA §3, and `check_da` §3 is what said so when this section's
	# first draft walked the pools itself); a card is in the population when a
	# Mage can hold it. A membership name the corpus does not contain is COUNTED,
	# not dropped — it would otherwise shrink the population unseen and read
	# exactly like a pass.
	var corpus: Array = Classes.ability_corpus()
	var corpus_names := {}
	var held := 0
	var cheapest := 1 << 30
	var cheapest_name := ""
	for ab in corpus:
		corpus_names[String(ab.display_name)] = true
		if not mage_names.has(String(ab.display_name)):
			continue
		held += 1
		if ab.cost > 0 and ab.cost < cheapest:
			cheapest = ab.cost
			cheapest_name = ab.display_name
	var outside := 0
	for nm in mage_names:
		if not corpus_names.has(nm):
			outside += 1
	print("  §5h: CHECKED %d corpus cards; %d a Mage can hold, %d membership names outside the corpus; cheapest price %d (%s)"
		% [corpus.size(), held, outside, cheapest, cheapest_name])
	ok(corpus.size() >= 200 and held >= 30 and outside == 0,
		"§5h: the corpus walk read %d cards, %d a Mage can hold, %d membership names outside it — the population is the corpus, not a sample"
			% [corpus.size(), held, outside])
	ok(fl <= cheapest,
		"§5h: the floor %d is at or under the cheapest price a Mage can pay (%s, %d) — it lifts no card he pays for"
			% [fl, cheapest_name, cheapest])


# One cast through the real path, from a chosen starting bar, returning what it
# did to the bar and to both ledgers. The victim is put back first, `dead`
# included, for §1e's reason.
func _cast_delta(scene: Node, u: BattleUnit, ab: Ability, victim: BattleUnit,
		counter: bool, start: int) -> Dictionary:
	victim.hp = victim.max_hp
	victim.dead = false
	victim.pressure = 0
	victim.broken = false
	victim.broken_pending = false
	victim.refresh_bars()
	u.resource = start
	var bar0 := u.resource
	var mana0 := u.mana_spent
	var rage0 := u.rage_spent
	seed(90210)
	var done := [false]
	var task := func():
		await scene._resolve(u, ab, victim, "good", counter)
		done[0] = true
	task.call()
	for _i in 400:
		if done[0]:
			break
		if scene.sc_active:
			scene.sc_pos = 0.99
			scene._grade_skill_check()
		await process_frame
	return {"bar": bar0 - u.resource, "mana": u.mana_spent - mana0,
		"rage": u.rage_spent - rage0}
