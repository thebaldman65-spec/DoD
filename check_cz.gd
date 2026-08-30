# BATCH CZ — the invariant gate. Five things, and each one is a rule a later
# batch could break without noticing:
#
#   §0  THE ENUMERATION IS ONE FUNCTION AND IT REACHES THE TALENT GRANTS.
#       `Classes.ability_corpus()` is now the only walk in the project, and the
#       five abilities the Batch CL enumeration always missed are in it. The
#       gate also RE-RUNS CN's and CO's criteria over those five and prints
#       what they turn out to be — a report, not a repair.
#   §1  BLOOD FRENZY HAS TWO TERMS AND ONE BAND. Rage spent buys steps at the
#       same rate health missing does, the sum is clamped at the band the
#       health term already had, and the ledger books what LEFT THE BAR.
#   §2  FAITH RELEASES AT `FAITH_RELEASE`, WHICH IS ONE NUMBER. Three sites
#       used to carry three literal fives.
#   §3  A SHIELD TAKES THE CAP; A HEAL DOES NOT. Both halves asserted, because
#       a rule with only its positive half checked is half a rule.
#   §4  `up_speed` IS ALIVE ON EVERY ABILITY IN THE GAME, and no floor or
#       threshold anywhere sits at or above the cap.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cz.gd
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

# §0 — THE FIVE THE BATCH CL ENUMERATION HAS ALWAYS MISSED, by display name.
# Named rather than counted, so a gate failure says WHICH one went missing.
const TALENT_ONLY := ["Backdraft", "Pyroblast", "Glacial Prison", "Cryoclasm",
	"Intercession"]

# WHAT EACH OF THE FIVE ACTUALLY DOES, **DERIVED BY WALKING `_resolve_special`
# AND NOT BY READING `damage` AND `pressure`.** This table is authored for the
# same reason CY's `MUST_NOT_CAP` is: those two fields are ZERO on four of the
# five, and every one of the four writes to an ENEMY from inside its handler. A
# field read would have called them all self-buffs, which is the exact mistake
# CN paid for on the timing bar and CO paid for again on the recast refusal.
const FIVE_HANDLERS := {
	"Backdraft": "adds turns of Burn to every already-burning enemy — enemy-facing, additive, no damage",
	"Pyroblast": "55 damage and 25 Break on its own fields — the only one of the five that is an ordinary attack",
	"Glacial Prison": "Chilled + `_hold_freeze` on ONE enemy, and nothing else",
	"Cryoclasm": "MOVES the oldest hold: strips one enemy, chills and freezes another, reschedules the first",
	"Intercession": "a status on every living hero and nothing anywhere else — a pure buff",
}

# §3 — the six, and the rule they now take. Held here as well as in
# `Ability.SHIELD_SPECIALS` on purpose: this is the gate's own copy of what the
# designer ruled, so a later batch that edits the table has to edit the gate
# too and cannot do it by accident.
const SHIELDS := ["divine_shield", "interpose", "magic_barrier", "mantle",
	"mirror_image", "vespers"]

# §3's NEGATIVE HALF — a heal is a RESPONSE and keeps its full price. If one of
# these ever comes down to the cap it is a design decision, and it should have
# to come through this list rather than through a table edit nobody reads.
const HEALS_STAY := ["dark_pact", "dawnbreak", "divine_plea", "field_dressing",
	"fortified_spirit", "holy_heal", "hymn", "jubilee", "ministration",
	"renewal", "reliquary", "sanctuary", "second_wind_holy", "spirit_bond"]

var _g := Gate.new()


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)


func _initialize() -> void:
	await process_frame
	seed(20260821)
	var battle_gd := load("res://scripts/battle.gd")
	var corpus := Classes.ability_corpus()
	print("BATCH CZ — %d ABILITIES IN THE CORPUS" % corpus.size())

	_s0_enumeration(corpus, battle_gd)
	_s1_frenzy()
	_s2_faith(battle_gd)
	_s3_shields(corpus)
	_s4_delay_floor(corpus)
	await _live(battle_gd)

	_report()


# ---------------------------------------------------------------- §0 --------
# THE HOLE, CLOSED AND THEN PROVED CLOSED. The assertion is not "the corpus is
# 216" — a hard count rots the moment a card is authored — it is that the walk
# reaches every talent grant and that the five CY named are among them.
func _s0_enumeration(corpus: Array, battle_gd) -> void:
	print("\n§0 — THE ENUMERATION")
	var by_name := {}
	for ab in corpus:
		by_name[ab.display_name] = ab
	# Every name a talent node grants resolves to a real ability. This is the
	# assertion CY ran inline inside its own corpus walk; it moved here when the
	# walk moved onto `Classes`, because a function returning a corpus should
	# not also be the thing that shouts about a broken one.
	# BATCH DO EMPTIED THIS LIST AND THE LOOP IS KEPT WITH AN ASSERTION IN
	# FRONT OF IT. A `for` over an empty array is a check that has stopped
	# asking its question, which this project rates worse than a red — so the
	# EMPTINESS is now asserted outright, and the loop stays live behind it so
	# the day a grant comes back it is still resolved rather than assumed.
	var granted: Array = Classes.talent_granted_names()
	ok(granted.is_empty(),
		"NO talent node grants an ability (DO's charter); the list holds %d" % granted.size())
	for nm in granted:
		ok(Talents.granted_ability(String(nm)) != null,
			"talent grant `%s` resolves to nothing" % nm)
		ok(by_name.has(nm),
			"talent grant `%s` is not in the corpus — the walk has a hole again" % nm)
	print("  talent-granted names: %d (DO moved all twenty-two into the draft)" % granted.size())
	# THE TWENTY-TWO ARE STILL IN THE CORPUS, and that is the half worth
	# asserting now: they moved home, they did not stop existing. The corpus
	# reaching them through `spec_draft_pool` instead of through the trees is
	# exactly what "the draft is where abilities come from" means.
	for moved in ["Battle Shout", "Rampage", "Lunge", "Execute", "Hold the Line",
			"Backdraft", "Immolate", "Pyroblast", "Firestorm", "Phoenix Rebirth",
			"Rime", "Glacial Prison", "Cryoclasm", "Shatter", "Overcharge",
			"Magi's Wrath", "Divine Plea", "Intercession", "Sacred Resolve",
			"Bulwark of Fortitude", "Mind Flay", "Mass Hysteria"]:
		ok(by_name.has(moved),
			"`%s` left the trees and is still in the corpus" % moved)
		var homes: Array = []
		for spec2 in Classes.all_specs():
			if Classes.spec_draft_pool(spec2).has(moved):
				homes.append(spec2)
		ok(homes.size() == 1,
			"...and it drafts from exactly one spec pool (%s)" % str(homes))

	# THE FIVE, AND THE HOLE THEY MEASURED — **CLOSED BY BATCH DO.** This block
	# asserted, for eight batches, that the Batch CL walk could NOT reach these
	# five, because each was granted by a talent node and lived in no pool. DO
	# moved all twenty-two talent grants into `SPEC_DRAFT_POOLS`, and the CL
	# walk reads the draft pools — so the gap it was measuring is gone.
	#
	# **THE ASSERTION IS INVERTED, NOT DELETED, AND THE MESSAGE IT USED TO
	# CARRY IS THE ONE THAT CAME TRUE:** "§0's premise has changed and the
	# report is stale". It had never fired. It fires as its opposite now, so a
	# batch that put one of the five back outside every pool would be caught by
	# the same line reading the other way.
	var cl := _cl_only_corpus()
	var cl_names := {}
	for ab in cl:
		cl_names[ab.display_name] = true
	print("  the Batch CL walk reaches %d; the complete walk reaches %d" % [
		cl.size(), corpus.size()])
	for nm in TALENT_ONLY:
		ok(by_name.has(nm), "%s is not in the complete corpus" % nm)
		ok(cl_names.has(nm),
			"%s is NOT in the CL walk — DO put it in a draft pool, so it must be" % nm)
	# AND THE WHOLE POINT. CL's enumeration reached 211 of 216 for as long as
	# talents granted abilities; DO put all twenty-two into pools and the two
	# walks agreed on a COUNT from DO to DT.
	#
	# **BATCH DU §4 SEPARATED THEM AGAIN, ON PURPOSE, AND THE EQUALITY IS
	# REPLACED BY A SET IDENTITY RATHER THAN LOOSENED.** `apply_kit_overrides`
	# builds four mage specs' `abilities[0]` at spawn and none of the four sits
	# in any pool; the complete walk applies the overrides now and reaches them,
	# and the CL walk reads the class kit UNOVERRIDDEN and structurally cannot.
	# A bare `!=` here would have said nothing about WHICH four, and a hard `+ 4`
	# would rot the day a fifth override is authored — so the difference is
	# DERIVED off `apply_kit_overrides` itself and asserted as a set. An ability
	# that fell outside every kit and pool would still be caught: it would be in
	# NEITHER walk, so it cannot hide inside this difference.
	var over_names := {}
	for spec3 in Classes.SPEC_INFO:
		var ck3 := Classes.class_of_spec(spec3)
		if ck3 == "":
			continue
		var plain_kit: Array = Classes.kit(ck3)
		var cfg3 := {"abilities": Classes.kit(ck3)}
		Classes.apply_kit_overrides(cfg3, spec3)
		var over_kit: Array = cfg3["abilities"]
		for i3 in over_kit.size():
			var nm3: String = over_kit[i3].display_name
			if i3 >= plain_kit.size() or nm3 != String(plain_kit[i3].display_name):
				over_names[nm3] = true
	var only_complete: Array = []
	for ab3 in corpus:
		if not cl_names.has(ab3.display_name):
			only_complete.append(ab3.display_name)
	only_complete.sort()
	var expected: Array = over_names.keys()
	expected.sort()
	ok(only_complete == expected,
		"the walks differ by %s; the ONLY difference may be the kit overrides %s" % [
			str(only_complete), str(expected)])
	ok(cl.size() + expected.size() == corpus.size(),
		"the CL walk reaches %d and the complete walk %d — that is %d apart, not the %d overrides" % [
			cl.size(), corpus.size(), corpus.size() - cl.size(), expected.size()])
	print("  the complete walk reaches %d the CL walk cannot: %s" % [
		expected.size(), ", ".join(expected)])

	# ---- CN's CRITERION AND CO's, RE-RUN OVER THE FIVE. REPORT, NOT REPAIR ----
	# CN decides whether a card runs a TIMING BAR; CO decides whether a recast
	# that would change nothing is REFUSED. Both tables were derived over the
	# 211 the CL walk reaches, so neither has ever been asked about these five.
	# Whether any of them should have lost its bar or gained a refusal is a
	# RULING — the same reason CQ audited 105 folds and changed one.
	var gated: Array = battle_gd.RECAST_GATED
	print("\n  CN's AND CO's CRITERIA, RE-RUN OVER THE FIVE:")
	print("    %-16s %-9s %-11s %-7s %s" % ["ability", "runs bar",
		"refusable", "delay", "what the HANDLER does"])
	for nm in TALENT_ONLY:
		if not by_name.has(nm):
			continue
		var ab = by_name[nm]
		ok(FIVE_HANDLERS.has(nm), "no handler note authored for %s" % nm)
		print("    %-16s %-9s %-11s %-7.2f %s" % [nm,
			"yes" if ab.runs_skill_check() else "NO",
			"yes" if gated.has(ab.special) else "no", ab.delay,
			String(FIVE_HANDLERS.get(nm, "?"))])
	print("\n  WHAT THE RE-RUN SAYS — A REPORT, NOT A REPAIR:")
	print("    CN — its CRITERION already answers all five correctly, so nothing")
	print("         is owed: four deal no damage and no Break and run no bar,")
	print("         Pyroblast attacks and keeps its bar. Only CN's printed")
	print("         POPULATION was short, and it is short no longer.")
	print("    CO — GLACIAL PRISON IS THE ONE THAT FITS THE REFUSAL CRITERION.")
	print("         Its whole cast-time payload is Chilled plus `_hold_freeze`,")
	print("         and `_hold_freeze` returns immediately on a target that is")
	print("         already `frozen` — so a recast onto a held enemy writes")
	print("         NOTHING. Backdraft is additive (Interpose's shape, always")
	print("         improves), Cryoclasm moves state between two enemies and")
	print("         reschedules one, Pyroblast attacks, Intercession is an ally")
	print("         buff already inside CY's cap. **ONE RULING IS OWED, ON ONE")
	print("         ABILITY, AND THIS BATCH DOES NOT TAKE IT.**")

	# THE ONE OF THE FIVE THIS BATCH OWNS: CY's cap. Intercession is a pure
	# buff — a party-wide death-save whose whole payload is a status on every
	# living hero — and it is the one member of the five the delay rule reaches.
	# It is asserted rather than reported, because applying the cap to any of
	# the five that qualifies is §0's own instruction.
	for nm in TALENT_ONLY:
		if not by_name.has(nm):
			continue
		var ab = by_name[nm]
		if Ability.takes_delay_cap(ab.special):
			ok(ab.delay <= Ability.BUFF_DELAY_CAP + 0.001,
				"%s takes the delay cap and sits at %.2f, past %.2f" % [
					nm, ab.delay, Ability.BUFF_DELAY_CAP])


# ---------------------------------------------------------------- §1 --------
# TWO TERMS, ONE BAND. The arithmetic is asserted directly rather than through
# a battle, because the property that matters is a bound: the second term can
# fill the band sooner and can NEVER make it deeper.
func _s1_frenzy() -> void:
	print("\n§1 — BLOOD FRENZY'S SECOND TERM")
	ok(BattleUnit.FRENZY_MAX_STEPS == 20,
		"the band is %d steps, not the 20 the health term always had" %
			BattleUnit.FRENZY_MAX_STEPS)
	ok(BattleUnit.FRENZY_RAGE_PER_STEP > 0,
		"FRENZY_RAGE_PER_STEP is %d — a rate of zero divides the band by nothing" %
			BattleUnit.FRENZY_RAGE_PER_STEP)

	var u := BattleUnit.new()
	u.max_hp = 100
	u.resource_name = "Rage"
	u.hp = 100
	# A full-health Berserker who has spent nothing is where he has always been.
	ok(is_zero_approx(u.frenzy_bonus()),
		"a full-health Berserker who has spent no Rage is at %.3f, not zero" %
			u.frenzy_bonus())
	# The ledger books what leaves the bar, and refuses everything else.
	u.note_resource_spent(0)
	u.note_resource_spent(-5)
	ok(u.rage_spent == 0, "the ledger booked a zero or negative spend")
	u.note_resource_spent(BattleUnit.FRENZY_RAGE_PER_STEP * 3)
	ok(u.frenzy_rage_steps() == 3, "3 steps of Rage bought %d steps" %
		u.frenzy_rage_steps())
	ok(is_equal_approx(u.frenzy_bonus(), 0.06),
		"3 steps at the default 2%% is %.3f, want 0.060" % u.frenzy_bonus())
	# A MANA HERO IS NOT PAID BY THIS TERM AT ALL, which is the guard that keeps
	# the ledger from becoming a fifth resource nobody declared.
	var m := BattleUnit.new()
	m.max_hp = 100
	m.hp = 100
	m.resource_name = "Mana"
	m.note_resource_spent(500)
	ok(m.rage_spent == 0, "a Mana hero booked %d Rage spent" % m.rage_spent)

	# THE BOUND, WHICH IS THE WHOLE DESIGN: the band does not grow.
	var deep := BattleUnit.new()
	deep.max_hp = 100
	deep.resource_name = "Rage"
	deep.hp = 1  # 99% missing — the health term is already at its ceiling
	deep.note_resource_spent(BattleUnit.FRENZY_RAGE_PER_STEP * 40)
	var band: float = BattleUnit.FRENZY_MAX_STEPS * 0.02
	ok(is_equal_approx(deep.frenzy_bonus(), band),
		"a dying Berserker who dumped 40 steps of Rage reads %.3f, past the band of %.3f" % [
			deep.frenzy_bonus(), band])
	print("  band %d steps (+%.0f%%), %d Rage a step, and the sum is clamped" % [
		BattleUnit.FRENZY_MAX_STEPS, band * 100.0,
		BattleUnit.FRENZY_RAGE_PER_STEP])


# ---------------------------------------------------------------- §2 --------
# ONE THRESHOLD. Three sites carried three literal fives before this batch, and
# the only way to prove they now agree is to drive the meter through the door
# they all guard.
func _s2_faith(battle_gd) -> void:
	print("\n§2 — FAITH'S RELEASE")
	var rel: int = battle_gd.FAITH_RELEASE
	ok(rel > 0, "FAITH_RELEASE is %d" % rel)
	ok(int(battle_gd.FAITH_PER_ABSORB) > 0 and int(battle_gd.FAITH_PER_GROUND_TURN) > 0,
		"a builder rate is zero — the meter cannot fill")
	# THE DENOMINATOR THE SIM REPORTS AGAINST IS THE THRESHOLD ITSELF. CY's row
	# read a hard 5.0; if the two ever disagree the report says a Devout arrived
	# when he did not.
	var meters: Array = battle_gd.CY_METERS
	var found := false
	for m in meters:
		if String(m[0]) == "conviction":
			found = true
			ok(is_equal_approx(float(m[2]), float(rel)),
				"CY_METERS reports Faith against %.0f, but the threshold is %d" % [
					float(m[2]), rel])
	ok(found, "CY_METERS has no `conviction` row — the Faith arrival figure is gone")
	# JUBILEE'S GATE IS NOW THE WHOLE BAR, AND THAT IS REPORTED RATHER THAN
	# MOVED. Blessing of the Faithful needs `JUBILEE_MIN_FAITH` held; at a
	# threshold of 3 that is every stack the meter can hold, so the card is
	# castable exactly when the meter is full — and ONLY by the Devout, whose
	# Faith holds. An ALLY at the threshold releases on the spot and can never
	# be holding three when the button is read.
	var jmin: int = battle_gd.JUBILEE_MIN_FAITH
	print("  threshold %d | %d a shielded hit | %d an ally turn on the ground" % [
		rel, int(battle_gd.FAITH_PER_ABSORB), int(battle_gd.FAITH_PER_GROUND_TURN)])
	print("  Blessing of the Faithful needs %d held of a possible %d — %s" % [
		jmin, rel,
		"THE WHOLE BAR, and only the Devout can hold it" if jmin >= rel \
			else "part of the bar"])
	# ELEVATION AGAINST THE NEW THRESHOLD, printed for the same reason: it
	# grants a flat count, so shortening the bar makes the same card worth more.
	var el: int = battle_gd.ELEVATION_STACKS
	print("  Elevation grants %d of %d — %.0f%% of a release, to every ally at once" % [
		el, rel, 100.0 * float(el) / float(rel)])


# ---------------------------------------------------------------- §3 --------
# THE RULE, WITH BOTH HALVES. A shield is setup and takes the cap; a heal is a
# response and does not. Asserting only the first half would let a later batch
# halve every heal in the game and still pass.
func _s3_shields(corpus: Array) -> void:
	print("\n§3 — SHIELDS TAKE THE CAP, HEALS DO NOT")
	var by_special := {}
	for ab in corpus:
		if ab.special != "" and not by_special.has(ab.special):
			by_special[ab.special] = ab
	var listed: Array = Ability.SHIELD_SPECIALS.duplicate()
	listed.sort()
	var want := SHIELDS.duplicate()
	want.sort()
	ok(listed == want, "SHIELD_SPECIALS is %s, want %s" % [listed, want])
	for sp in SHIELDS:
		ok(not Ability.PURE_BUFFS.has(sp),
			"`%s` is in PURE_BUFFS — the two populations must stay separate" % sp)
		ok(Ability.takes_delay_cap(sp),
			"`%s` is a shield and the cap does not bind it" % sp)
		if not by_special.has(sp):
			ok(false, "SHIELD_SPECIALS names `%s`, which no ability uses" % sp)
			continue
		var ab = by_special[sp]
		ok(ab.delay <= Ability.BUFF_DELAY_CAP + 0.001,
			"%s is a shield at delay %.2f, past the cap of %.2f" % [
				ab.display_name, ab.delay, Ability.BUFF_DELAY_CAP])
		print("    %-16s %-16s delay %.2f  cd %d" % [ab.display_name, sp,
			ab.delay, ab.cooldown])
	# THE OTHER HALF, AND IT IS THE HALF THAT KEEPS THE RULE A RULE.
	for sp in HEALS_STAY:
		ok(not Ability.takes_delay_cap(sp),
			"`%s` is a HEAL and the cap binds it — a heal is a response, not setup" % sp)
		if by_special.has(sp):
			var hb = by_special[sp]
			ok(hb.delay > Ability.BUFF_DELAY_CAP + 0.001,
				"%s is a heal sitting at %.2f, at or under the setup cap" % [
					hb.display_name, hb.delay])
	print("  %d shields capped, %d heals left at full price" % [
		SHIELDS.size(), HEALS_STAY.size()])


# ---------------------------------------------------------------- §4 --------
# `up_speed` WAS DEAD ON 52 CARDS AND NOTHING SAID SO. The assertion is the
# general one rather than a list: SWIFT must change the delay of every ability
# in the game that `upgrade_fits` says it fits. That is true today and stays
# true whatever a later batch authors.
func _s4_delay_floor(corpus: Array) -> void:
	print("\n§4 — SWIFT IS ALIVE AGAIN")
	ok(Ability.DELAY_FLOOR < Ability.BUFF_DELAY_CAP,
		"DELAY_FLOOR (%.2f) is not below BUFF_DELAY_CAP (%.2f) — Swift is a dead pick" % [
			Ability.DELAY_FLOOR, Ability.BUFF_DELAY_CAP])
	ok(is_equal_approx(Ability.DELAY_FLOOR, Ability.BUFF_DELAY_CAP * 0.5),
		"DELAY_FLOOR is %.2f, not half the cap — the ladder's third rung has drifted" %
			Ability.DELAY_FLOOR)
	var run := root.get_node("/root/Run")
	var dead: Array = []
	var fitted := 0
	for ab in corpus:
		if not run.upgrade_fits("up_speed", ab):
			continue
		fitted += 1
		var before: float = ab.delay
		# `_stamp_upgrade` mutates, so it runs on a COPY. The corpus hands back
		# live objects and a gate that quietly re-priced the game's own
		# abilities would be a very expensive way to check them.
		var copy: Ability = Ability.make({"display_name": ab.display_name,
			"special": ab.special, "delay": before})
		run._stamp_upgrade("up_speed", copy)
		if copy.delay >= before - 0.0001:
			dead.append("%s (%.2f)" % [ab.display_name, before])
	ok(dead.is_empty(), "Swift buys nothing on %d abilities: %s" % [
		dead.size(), ", ".join(PackedStringArray(dead))])
	print("  Swift fits %d of %d abilities and moves the delay on every one" % [
		fitted, corpus.size()])
	# THE SWEEP §4 ASKS FOR. Every ability in the game, against the floor: an
	# authored delay at or under the floor would be a card Swift cannot help and
	# a card the ladder does not describe.
	var under: Array = []
	for ab in corpus:
		if ab.delay > 0.0 and ab.delay < Ability.DELAY_FLOOR - 0.0001:
			under.append("%s (%.2f)" % [ab.display_name, ab.delay])
	ok(under.is_empty(), "authored below the floor: %s" % ", ".join(PackedStringArray(under)))
	print("  ladder: swing %.2f | setup cap %.2f | floor %.2f" % [
		Ability.BASIC_DELAY, Ability.BUFF_DELAY_CAP, Ability.DELAY_FLOOR])


# ------------------------------------------------------------- the live half -
# THE ARITHMETIC ABOVE IS A PREDICTION; THIS IS THE GAME. A real battle, a real
# cast, and the two things the batch changed watched on the actual units: Rage
# leaving the bar has to reach the ledger, and Faith crossing the threshold has
# to release.
func _live(battle_gd) -> void:
	print("\nTHE LIVE HALF")
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor",
		"beastmaster"])
	var heroes: Array = scene.get("heroes")
	var zerk: BattleUnit = null
	var devout: BattleUnit = null
	for h in heroes:
		if h.is_companion:
			continue
		if h.passive_id == "bloodrage":
			zerk = h
		elif h.passive_id == "conviction":
			devout = h
	ok(zerk != null, "no Berserker in the fixture")
	ok(devout != null, "no Devout in the fixture")

	# §1 LIVE — a real cast, and the ledger has to see what left the bar.
	if zerk != null:
		zerk.resource = zerk.max_resource
		zerk.rage_spent = 0
		var paid_ab: Ability = null
		for ab in zerk.abilities:
			if ab.cost > 0 and ab.cost <= zerk.resource:
				paid_ab = ab
				break
		if paid_ab == null:
			ok(false, "the Berserker holds no ability with a cost — §1 cannot be driven")
		else:
			var before: int = zerk.resource
			var foes: Array = scene.get("enemies")
			await scene._resolve(zerk, paid_ab, foes[0], "good")
			var left: int = before - zerk.resource
			ok(left <= 0 or zerk.rage_spent == left,
				"%s took %d off the bar and the ledger booked %d" % [
					paid_ab.display_name, left, zerk.rage_spent])
			ok(zerk.frenzy_rage_steps() == zerk.rage_spent / BattleUnit.FRENZY_RAGE_PER_STEP,
				"the ledger and the step count disagree")
			print("  §1: %s took %d Rage off the bar, booked %d, worth %d step(s)" % [
				paid_ab.display_name, left, zerk.rage_spent,
				zerk.frenzy_rage_steps()])

	# §2 LIVE — walk an ALLY up to the threshold one stack at a time and watch
	# it pay out. The Devout is deliberately not the subject: his own Faith
	# HOLDS by rule (Batch BH §2) and would never release however far it is
	# driven, which is the negative control this assertion needs.
	if devout != null:
		var ally: BattleUnit = null
		for h in heroes:
			if not h.is_companion and h != devout and not h.dead:
				ally = h
				break
		if ally == null:
			ok(false, "no living ally to drive Faith onto")
		else:
			var rel: int = battle_gd.FAITH_RELEASE
			ally.faith_stacks = 0
			ally.faith_peak = 0
			for i in rel - 1:
				scene._gain_faith(ally, 1, "gate")
			ok(ally.faith_stacks == rel - 1,
				"one under the threshold reads %d, want %d" % [
					ally.faith_stacks, rel - 1])
			scene._gain_faith(ally, 1, "gate")
			ok(ally.faith_stacks == 0,
				"the ally reached the threshold and did not release (holds %d)" %
					ally.faith_stacks)
			ok(ally.faith_peak == rel,
				"the peak reads %d after a release, want %d — the peak must not reset" % [
					ally.faith_peak, rel])
			# And the Devout's own meter does NOT release, at the same threshold.
			devout.faith_stacks = 0
			devout.faith_peak = 0
			scene._gain_faith(devout, rel, "gate")
			ok(devout.faith_stacks == rel,
				"the Devout's own Faith released — it must HOLD at %d (reads %d)" % [
					rel, devout.faith_stacks])
			print("  §2: an ally releases at %d and keeps a peak of %d; the Devout holds %d" % [
				rel, ally.faith_peak, devout.faith_stacks])
	scene.queue_free()


# The CL walk EXACTLY as it stood before this batch, kept here as §0's negative
# control. Its whole job is to still be missing the five — if it ever stops
# being, the gap `Classes.ability_corpus()` exists to close has closed itself
# and the report above is stale.
func _cl_only_corpus() -> Array:
	var out: Array = []
	var seen := {}
	var add := func(ab):
		if ab == null or seen.has(ab.display_name):
			return
		seen[ab.display_name] = true
		out.append(ab)
	# **BATCH DY §3 — THE `class_pool(key)` ARM IS GONE WITH `CLASS_POOLS`, AND
	# THE SET IDENTITY BELOW STILL HOLDS EXACTLY.** That arm named the sibling
	# specs' KIT abilities, every one of which this walk already reaches through
	# `spec_abilities()` two loops down — so the walk narrows from 227-minus-4
	# to the same 223, and the four names it still cannot see are the same four
	# kit overrides. Measured, not assumed: the difference is DERIVED off
	# `apply_kit_overrides` at the assertion site, so this deletion could only
	# have been silent if it had changed nothing, and it did not change it.
	for key in ["warrior", "mage", "cleric", "hunter"]:
		for ab in Classes.kit(key):
			add.call(ab)
		for nm in Classes.class_draft_pool(key):
			add.call(Classes.pool_ability(String(nm)))
	for spec in Classes.SPEC_INFO:
		for ab in Classes.spec_abilities(spec):
			add.call(ab)
		for nm in Classes.spec_pool(spec):
			add.call(Classes.spec_pool_ability(spec, String(nm)))
		for nm in Classes.spec_draft_pool(spec):
			add.call(Classes.spec_pool_ability(spec, String(nm)))
	return out

