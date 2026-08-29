# BATCH DT §1 — THE GATE FOR THE TWO SPECIALS THAT SHIPPED WITH NO LIVE COVER.
#
# DS authored six Hunter draft cards and added NO gate, and it named the cost
# rather than hiding it: `check_co`'s saturation sweep exercises four of the six
# as a side effect, and **`bring_it_down` and `heads_down` are covered by
# nothing at all**. Both WERE driven through a real battle at DS — in a scratch
# fixture that is not in the repo — and that throwaway run is what found the
# fault below. **So the two newest specials were the two least protected.**
# This is the permanent copy of that run.
#
# FIVE SECTIONS, AND §2c IS THE ONE THAT EXISTS FOR A FAULT RATHER THAN FOR A
# FEATURE:
#   §0   the enemy corpus, DERIVED — how inert the mana premise actually is
#   §1   BRING IT DOWN cast on a live board: who wears it, at what number,
#        that the number is a SNAPSHOT, that the cap binds — and the amp
#        MEASURED on a hero's real strikes
#   §2a  HEADS DOWN cast through `_resolve`: the silence lands, 3 turns and 4
#   §2b  the boss arm, live — it is NOT in `_apply_status`'s carve-out
#   §2c  **THE FAULT.** The refusal is IDENTITY against `_cheapest_attack`,
#        not `cost > 0` — asserted so that the `cost > 0` version fails it
#   §2d  the fallback cannot starve, driven through `_revalidate_intent`
#
# ── WHY §2c IS SHAPED THE WAY IT IS, WHICH IS THE WHOLE POINT OF THIS GATE ──
# Heads Down's first version refused any ability with `cost > 0`, on the
# assumption that an enemy's better options are the ones it pays for. **THEY
# ARE NOT.** §0 derives the number live: the overwhelming majority of the enemy
# corpus costs ZERO, so the card would have refused a handful of abilities in
# the whole game while reading as working — a chip on the plate, a line in the
# log, and nothing suppressed.
#
# **A STATIC CHECK WOULD HAVE CALLED THAT CORRECT.** "The card refuses
# abilities" is true of both versions; "the refusal names `_cheapest_attack`"
# is a string the broken version could also have carried. The only assertion
# that separates them is a LIVE one: take a real enemy's real kit, run every
# ability in it through `_intent_ability_usable`, and require that **at least
# one REFUSED ability costs ZERO**. Under the shipped identity test that count
# is positive. Under `cost > 0` it is exactly zero, on every kit in the game
# but two. That is the assertion, and it is in `_fault()`.
#
# ── AND WHY THIS GATE NEEDS NO `check_da` §3 EXEMPTION ──────────────────────
# §3's fingerprint is a file carrying BOTH of the two draft-pool accessors on
# `Classes` — the mark of a gate that re-derives the ability corpus by hand
# instead of calling `Classes.ability_corpus()`. **THIS GATE CALLS NEITHER.**
# It reaches its two cards through `Classes.draft_ability()` by display name,
# which is the card BUILDER and not a walk, so it enumerates nothing and there
# is nothing for §3 to be right about. It is not exempted; it does not trip.
# `check_da`'s fixture marks are clear for the same reason: it authors no
# `_spawn` and instantiates no scene — `gate_fixture.gd` does both, which is
# what that rule is protecting.
#
# **AND THE TWO ACCESSORS ARE NOT SPELLED OUT IN THIS PARAGRAPH, WHICH IS NOT
# STYLE.** They were, in the first draft of this file, and `check_da` §3 went
# RED on the first run: the fingerprint is a substring match over the whole
# source, so a COMMENT explaining that the gate does not hand-roll the walk
# reads exactly like the gate hand-rolling the walk. `check_da`'s own header
# records the same trap and solves it for itself by splitting the literals at
# runtime; a comment cannot concatenate, so the names stay out of the prose.
# **An exemption here would have been an exemption granted to a sentence** —
# and it would have blinded §3 to a real walk arriving in this file later.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ds.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# Seeded strikes per arm. **BOTH ARMS OF EVERY PAIR TAKE THE SAME SEED**, so
# the ±10% damage roll draws an identical stream in each and the only
# difference between them is the chip — DD's rule, and `check_dk` §4's shape.
const BLOWS := 10
const SEED := 20260829

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DS — BRING IT DOWN AND HEADS DOWN, DRIVEN THROUGH A REAL BATTLE")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")

	_corpus()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	await _bring_it_down(a)
	a.queue_free()

	# THE SECOND FIXTURE IS NOT A CONVENIENCE. `Gate.spawn` fields ONE hunter
	# slot, and these two cards belong to two different Hunter specs — a
	# Beastmaster cannot hold Heads Down and a Sharpshooter cannot hold Bring
	# It Down. `check_di` is the precedent for a gate that spawns twice.
	var b: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"sharpshooter"], {"deterministic": true})
	await _heads_down(b, src)
	b.queue_free()

	_g.report(self)


# ── §0 — THE ENEMY CORPUS, DERIVED RATHER THAN QUOTED ───────────────────────
# **THIS IS THE NUMBER THE FAULT TURNED ON**, and it is read out of the data
# file on every run rather than written down here, because a figure written
# down is a figure that goes stale the next time an enemy is authored. It is
# the SUPPORTING half of §2c and not a replacement for it: it establishes that
# the mana premise is inert across the whole corpus, where §2c establishes it
# on a live kit through the live function.
#
# THE SECOND COUNT IS THE ONE THAT MATTERS. A kit holding TWO OR MORE zero-cost
# damaging abilities is a kit where `_cheapest_attack` returns one of them and
# the OTHERS are free — those are exactly the kits on which a `cost > 0` test
# suppresses nothing while the chip says it did.
func _corpus() -> void:
	print("§0 — the enemy corpus, derived")
	var txt := FileAccess.get_file_as_string("res://data/enemies.json")
	ok(txt != "", "data/enemies.json is readable")
	var parsed = JSON.parse_string(txt)
	ok(parsed is Dictionary, "data/enemies.json no longer parses as a Dictionary of kits")
	if not (parsed is Dictionary):
		return
	var total := 0
	var free := 0
	var kits_exposed := 0
	for key in parsed:
		var kit: Array = parsed[key].get("abilities", [])
		var free_dmg := 0
		for ab in kit:
			total += 1
			if int(ab.get("cost", 0)) == 0:
				free += 1
				if int(ab.get("damage", 0)) > 0:
					free_dmg += 1
		if free_dmg >= 2:
			kits_exposed += 1
	print("  %d enemy abilities across %d kits; %d cost ZERO. %d kits carry a zero-cost DAMAGING ability that is not the basic — a `cost > 0` refusal suppresses nothing on any of them." % [
		total, parsed.size(), free, kits_exposed])
	ok(total > 0, "the corpus walk read no abilities at all")
	# A RATIO RATHER THAN A LITERAL: the count moves whenever an enemy is
	# authored, and what this gate needs to stay true is that the mana premise
	# is still inert, not that it is inert by exactly the margin DS measured.
	ok(free * 10 >= total * 9,
		"fewer than 90%% of enemy abilities are free now (%d of %d) — the `cost > 0` premise DS refused may have become live, and Heads Down's criterion is worth re-deriving" % [free, total])
	ok(kits_exposed > 0,
		"no enemy kit holds a second zero-cost damaging ability any more — §2c has nothing to discriminate against and this gate has stopped testing the fault")


# ── §1 — BRING IT DOWN, CAST ON A LIVE BOARD ────────────────────────────────
# FIVE PROPERTIES, AND FOUR OF THEM ARE THINGS THE CARD'S OWN TEXT PROMISES:
# every hero deals more, 2% a stack, the cap at 20%, the bond is not spent, and
# the number is read AS THE HORN SOUNDS. The fifth is the one the text does not
# state and the source comment does — the beast that EARNED the Loyalty does
# not also collect on it, because the walk is `heroes` and not `_hero_side()`.
#
# **THE AMP IS MEASURED AND NOT ASSERTED.** A status that attaches perfectly
# and moves no number is precisely DK's Empower defect, and it is the failure
# mode this card is most exposed to: it is stamped in one place and READ in
# another, three thousand lines away, off each wearer's own status power.
func _bring_it_down(scene: Node) -> void:
	print("§1 — BRING IT DOWN")
	var bm := _hunter(scene)
	ok(bm != null, "the fixture fields no Beastmaster")
	if bm == null:
		return
	var ab: Ability = Classes.draft_ability("Bring It Down")
	ok(ab != null, "`Classes.draft_ability(\"Bring It Down\")` returns nothing — the card has left the builder")
	if ab == null:
		return
	ok(ab.special == "bring_it_down",
		"the card no longer carries `special: \"bring_it_down\"` — its whole effect is that branch")
	ok(scene.STATUS_INFO.has("bring_it_down"),
		"`bring_it_down` has no STATUS_INFO row, so the chip cannot render and the tooltip is empty")
	var per: int = scene.BRING_IT_DOWN_PER
	var cap: int = scene.BRING_IT_DOWN_CAP

	# --- THE NO-BOND ARM, TAKEN FIRST because it is the only arm that can be
	#     taken before a beast exists. A 0% amp stamped on four heroes is a
	#     chip that reads as working, which is the shape this whole gate is
	#     about; the handler refuses instead and says so in the log.
	ok(scene._deepest_bond(bm) == null,
		"a beast already stands before the summon, so the no-bond arm is measuring nothing")
	_clear_amp(scene)
	await scene._resolve_special(bm, ab, bm, "good", 1.0)
	var bare := _wearers(scene)
	ok(bare == 0,
		"with NO bond at all the horn stamped %d heroes — a +0%% amp is a chip that reads as working" % bare)

	# --- THE ORDINARY ARM ---
	await scene._do_summon(bm, "ursus")
	var pack: Array = scene.get("companions")
	ok(pack.size() > 0, "the summon put no companion on the field")
	if pack.is_empty():
		return
	var comp: BattleUnit = pack[0]
	bm.loyalty["ursus"] = 6
	ok(scene._deepest_bond(bm) == comp,
		"`_deepest_bond` does not return the one beast standing — the amp is reading the wrong meter")
	_clear_amp(scene)
	await scene._resolve_special(bm, ab, bm, "good", 1.0)
	var want: int = mini(6 * per, cap)
	var living := 0
	var stamped := 0
	for h in scene.get("heroes"):
		if h.dead:
			continue
		living += 1
		if h.has_status("bring_it_down") and h.status_power("bring_it_down") == want:
			stamped += 1
	ok(living > 1, "the fixture fields %d living hero, so \"every hero\" is untestable" % living)
	ok(stamped == living,
		"%d of %d living heroes carry the amp at +%d%% — the card says EVERY hero" % [
			stamped, living, want])
	# THE ONE PROPERTY THE CARD TEXT DOES NOT STATE AND THE HANDLER DOES.
	ok(not comp.has_status("bring_it_down"),
		"the BEAST is wearing the party amp — the walk is `heroes` on purpose, so the companion that EARNED the Loyalty does not also collect on it")
	# THE BOND IS NOT SPENT — the card's own clause, and the difference between
	# this card and UNLEASH, which is the inward one.
	ok(int(bm.loyalty.get("ursus", 0)) == 6,
		"the cast spent Loyalty — the card promises the bond is NOT spent, which is the whole distinction from Unleash")

	# --- THE SNAPSHOT. Deepening the bond AFTER the cast must not move a buff
	#     four heroes are already fighting under.
	bm.loyalty["ursus"] = 15
	ok(bm.status_power("bring_it_down") == want,
		"deepening the bond after the cast moved the standing amp to +%d%% — the number is read AS THE HORN SOUNDS" % bm.status_power("bring_it_down"))

	# --- THE CAP ---
	ok(15 * per > cap,
		"15 Loyalty buys +%d%% against a cap of +%d%%, so the cap arm is not testing the cap" % [15 * per, cap])
	_clear_amp(scene)
	await scene._resolve_special(bm, ab, bm, "good", 1.0)
	ok(bm.status_power("bring_it_down") == cap,
		"at 15 Loyalty the amp reads +%d%% rather than the +%d%% cap" % [
			bm.status_power("bring_it_down"), cap])

	await _amp_measured(scene, bm, ab, cap)


# THE AMP MEASURED ON A HERO'S REAL STRIKES, THROUGH `_resolve`.
#
# **WHY A RATIO AND NOT AN ABSOLUTE.** The two arms are identical in every
# respect but the chip — same striker, same ability, same target reset before
# every blow, same seed — so every other multiplier in the strike loop cancels
# and what is left is exactly the term under test. That is what lets this
# assert the FULL +20% rather than a band: an absolute would have to model the
# Warden's whole multiplier stack, and a band would stop being able to tell
# +20% from +12%.
#
# **AND THE THIRD ARM IS THE CONTROL THAT MATTERS.** Stripping the amp from
# the STRIKER ALONE, while the other heroes keep wearing it, must put the ratio
# back at 1.0. Without it, a party-wide global read at the strike site would
# pass the first two arms exactly as a per-wearer read does — and the source
# comment's claim is specifically that it is read off each wearer's own status
# power, so the class card and this one compose additively instead of one
# winning.
func _amp_measured(scene: Node, bm: BattleUnit, ab: Ability, cap: int) -> void:
	var striker := _warden(scene)
	var foe := _foe(scene)
	ok(striker != null, "the fixture fields no Warden to strike with")
	ok(foe != null, "the fixture fields no living foe to strike")
	if striker == null or foe == null:
		return
	var probe: Ability = _probe(striker)
	ok(probe != null, "the Warden holds no plain damaging ability to probe with")
	if probe == null:
		return
	# A LARGE ATTACK, SO THE RATIO MEASURES THE TERM AND NOT INTEGER ROUNDING —
	# `check_di` §5's scar, inherited rather than re-learned. At the Warden's
	# own Attack ten blows total about 127 points and the per-blow `round()`
	# alone moves the ratio by a third of a percentage point, which is most of
	# the room a +20%-versus-+18% assertion has to work in.
	striker.attack = 5000

	_clear_amp(scene)
	ok(not striker.has_status("bring_it_down"), "the plain arm is not plain")
	var plain := await _blows(scene, striker, probe, foe)

	await scene._resolve_special(bm, ab, bm, "good", 1.0)
	ok(striker.status_power("bring_it_down") == cap,
		"the striker is not wearing the capped amp, so the measured arm is measuring something else")
	var amped := await _blows(scene, striker, probe, foe)

	# THE CONTROL: the amp stays on the party, comes off the striker.
	striker.remove_status("bring_it_down")
	ok(_wearers(scene) > 0,
		"the control stripped the amp from EVERYBODY — it has stopped being a control and is a second plain arm")
	var control := await _blows(scene, striker, probe, foe)

	var want := 1.0 + float(cap) / 100.0
	var r := (float(amped) / float(plain)) if plain > 0 else 0.0
	var rc := (float(control) / float(plain)) if plain > 0 else 0.0
	print("  BRING IT DOWN  %d seeded Warden strikes with `%s`: %d plain, %d under +%d%% (ratio %.4f, want %.4f), %d with the amp on the PARTY but not on him (ratio %.4f)" % [
		BLOWS, probe.display_name, plain, amped, cap, r, want, control, rc])
	ok(plain > 0 and amped > 0, "an arm landed no damage at all")
	ok(absf(r - want) < 0.002,
		"the +%d%% amp moves a hero's strikes by %.2f%% — it attaches and pays a different number than the card states" % [
			cap, (r - 1.0) * 100.0])
	ok(absf(rc - 1.0) < 0.002,
		"THE CONTROL FAILED: the striker deals %.2f%% more with the amp on the PARTY and not on him, so the strike site is not reading his own status power" % ((rc - 1.0) * 100.0))
	_clear_amp(scene)


# One arm of seeded strikes down the HERO damage path, through `_resolve` —
# the crit, the armour read, the parry roll and every rider a real blow draws.
# The target is reset before EVERY blow (Break banked, statuses shed, health
# restored) so the arm measures ten independent first strikes rather than one
# strike and nine against a progressively different body.
func _blows(scene: Node, striker: BattleUnit, ab: Ability, foe: BattleUnit) -> int:
	var total := 0
	seed(SEED)
	for _i in BLOWS:
		foe.max_hp = 100000000
		foe.hp = foe.max_hp
		foe.statuses.clear()
		foe.broken = false
		foe.pressure = 0
		foe.dead = false
		striker.crit_streak = 0
		var before: int = foe.hp
		await scene._resolve(striker, ab, foe, "good")
		total += before - foe.hp
	return total


# The amp off every body on the hero side — companions included, so a stray
# stamp on a beast cannot survive into the next arm and read as a pass.
func _clear_amp(scene: Node) -> void:
	for h in scene.get("heroes"):
		h.remove_status("bring_it_down")
	for c in scene.get("companions"):
		c.remove_status("bring_it_down")


func _wearers(scene: Node) -> int:
	var n := 0
	for h in scene.get("heroes"):
		if h.has_status("bring_it_down"):
			n += 1
	for c in scene.get("companions"):
		if c.has_status("bring_it_down"):
			n += 1
	return n


# ── §2 — HEADS DOWN, AND THE FAULT THAT NEARLY SHIPPED ──────────────────────
func _heads_down(scene: Node, src: String) -> void:
	print("§2 — HEADS DOWN")
	var ss := _hunter(scene)
	ok(ss != null, "the fixture fields no Sharpshooter")
	if ss == null:
		return
	var ab: Ability = Classes.draft_ability("Heads Down")
	ok(ab != null, "`Classes.draft_ability(\"Heads Down\")` returns nothing — the card has left the builder")
	if ab == null:
		return
	# THE SHAPE, ASSERTED. A `special` would hand-roll the blow and lose the
	# crit, the armour read, the parry roll, the Break and every talent rider
	# that reads a strike — the card rides `display_name` beside Crossfire's
	# for exactly that reason.
	ok(ab.special == "",
		"Heads Down has grown a `special` — it is an ORDINARY ATTACK with a status rider, and a `special` hand-rolls the blow and loses the whole pipeline")
	ok(ab.damage > 0, "Heads Down deals no damage — its rider rides a strike")
	ok(BattleUnit.DEBUFF_IDS.has("heads_down"),
		"`heads_down` has left DEBUFF_IDS — a mender can no longer cleanse it, it stops counting toward a Survivalist's Trapper breadth, and a Mage's Dispel can strip the party's work off the enemy carrying it")

	var foe := _foe(scene)
	ok(foe != null, "the fixture fields no living foe")
	if foe == null:
		return
	foe.max_hp = 100000000
	foe.hp = foe.max_hp
	foe.statuses.clear()
	foe.dead = false

	# --- §2a: THE CAST, AND BOTH DURATIONS ---
	await scene._resolve(ss, ab, foe, "good")
	ok(foe.has_status("heads_down"), "a good cast landed no silence at all")
	ok(int(foe.get_status("heads_down").get("turns", 0)) == 3,
		"a good cast holds %d turns rather than the 3 the card states" % int(foe.get_status("heads_down").get("turns", 0)))
	foe.statuses.clear()
	await scene._resolve(ss, ab, foe, "perfect")
	ok(int(foe.get_status("heads_down").get("turns", 0)) == 4,
		"a PERFECT cast holds %d turns rather than the 4 its `perfect_text` promises" % int(foe.get_status("heads_down").get("turns", 0)))

	# --- §2b: THE BOSS ARM, LIVE. `heads_down` is deliberately NOT in
	#     `_apply_status`'s carve-out: that list refuses effects which cost a
	#     boss its whole turn, and this one never takes one. Driven rather
	#     than pinned as a literal, because two gates already pin that literal
	#     and a third copy of one fact is DJ §3's rule.
	foe.statuses.clear()
	foe.is_boss = true
	foe.broken = false
	await scene._resolve(ss, ab, foe, "good")
	ok(foe.has_status("heads_down"),
		"an UNBROKEN boss refused the silence — it has joined `_apply_status`'s carve-out, which exists for effects that take a whole turn, and this one never does")
	foe.is_boss = false

	_fault(scene, foe)
	await _fallback(scene, ss, foe)
	_policy(src)


# ── §2c — THE FAULT, AND THE ONE ASSERTION A STATIC CHECK COULD NOT MAKE ────
# The card's criterion is IDENTITY against `_cheapest_attack`. Its first
# version tested `cost > 0`. **Both versions refuse abilities; both name a
# criterion; both log a fallback.** What separates them is a single live
# number: how many of the abilities actually REFUSED on a real kit cost
# nothing. Under identity that number is positive on 14 of the 21 kits in the
# game. Under `cost > 0` it is zero on every kit but the two that hold a
# priced ability at all.
#
# So the assertion is not "the refusal works" — it is **"the refusal reaches
# something free"**, which is the exact claim the shipped fix makes and the
# exact claim the broken one cannot.
#
# THE NEGATIVE CONTROL IS IN THE SAME FUNCTION AND IS NOT OPTIONAL: with the
# silence lifted the whole kit must come back. Without it, an
# `_intent_ability_usable` that returned false for some unrelated reason —
# a cooldown, an unaffordable cost, a kit-membership test — would pass every
# assertion above while the card did nothing.
func _fault(scene: Node, foe: BattleUnit) -> void:
	ok(foe.has_status("heads_down"), "the foe is not silenced, so §2c is measuring an ordinary enemy")
	var basic: Ability = scene._cheapest_attack(foe)
	ok(basic != null,
		"%s holds no zero-cost damaging attack, so the silence refuses nothing on it and this arm measures nothing" % foe.unit_name)
	if basic == null:
		return
	var kept: Array = []
	var refused: Array = []
	for a in foe.abilities:
		if scene._intent_ability_usable(foe, a):
			kept.append(a)
		else:
			refused.append(a)
	var free_refused: Array = refused.filter(func(a): return a.cost == 0)
	print("  HEADS DOWN  %s's kit: %d abilities, %d kept, %d refused — and %d of the REFUSED cost ZERO (%s)" % [
		foe.unit_name, foe.abilities.size(), kept.size(), refused.size(),
		free_refused.size(),
		", ".join(free_refused.map(func(a): return a.display_name))])
	ok(kept.size() == 1,
		"the silence left %d abilities usable — it holds the enemy to its BASIC ATTACK alone" % kept.size())
	ok(kept.size() == 1 and kept[0] == basic,
		"the one ability left standing is not `_cheapest_attack` — the enemy has been left a better option than the one the fallback reaches for")
	# **THE ASSERTION THE WHOLE GATE EXISTS FOR.**
	ok(free_refused.size() > 0,
		"EVERY ability this silence refused costs mana, so a `cost > 0` test would measure IDENTICALLY here — that is the version that nearly shipped, and it suppressed four abilities in the entire game while reading as working")
	# AND THE FALLBACK CANNOT BE STARVED, which is the property that keeps this
	# a downgrade rather than a Stun with extra steps.
	ok(scene._intent_ability_usable(foe, basic),
		"the one ability the silence never refuses is refused — the fallback is starved and the enemy has no legal action, which is a Stun and not a downgrade")

	# THE CONTROL.
	foe.remove_status("heads_down")
	var kept_after := 0
	for a in foe.abilities:
		if scene._intent_ability_usable(foe, a):
			kept_after += 1
	ok(kept_after == foe.abilities.size(),
		"THE CONTROL FAILED: %d of %d abilities are STILL refused with the silence lifted, so the refusal above is not reading `heads_down`" % [
			foe.abilities.size() - kept_after, foe.abilities.size()])


# ── §2d — THE DOWNGRADE, DRIVEN THROUGH `_revalidate_intent` ────────────────
# The card reuses a shipped announcement rather than inventing a second one:
# the enemy SELECTS freely a turn ahead and the suppression lands at
# re-validation, where the caller already logs "cannot bring X to bear" and
# already counts `intent_fallback`. This drives that path with a real declared
# intent and reads the counter, so "it still acts" is measured rather than
# asserted.
func _fallback(scene: Node, ss: BattleUnit, foe: BattleUnit) -> void:
	var basic: Ability = scene._cheapest_attack(foe)
	if basic == null:
		return
	var better: Ability = null
	for a in foe.abilities:
		if a != basic and a.cost == 0:
			better = a
			break
	ok(better != null,
		"%s holds no second zero-cost ability to declare, so the drive is not exercising the fault" % foe.unit_name)
	if better == null:
		return
	foe.statuses.clear()
	await scene._resolve(ss, Classes.draft_ability("Heads Down"), foe, "good")
	ok(foe.has_status("heads_down"), "the drive arm is not silenced")
	foe.intent = {"ability": better, "target": ss, "category": "strike",
		"support": false}
	var before: float = float(scene.sim_stats.get("intent_fallback", 0.0))
	var decl: Dictionary = scene._revalidate_intent(foe)
	var after: float = float(scene.sim_stats.get("intent_fallback", 0.0))
	ok(not decl.is_empty(),
		"the silenced enemy declared NOTHING — it must still act, and a lost turn is the thing this card is written not to be")
	ok(decl.get("ability") == basic,
		"the silenced enemy still brings `%s` to bear" % better.display_name)
	ok(after - before == 1.0,
		"`intent_fallback` moved by %.0f — the card promises it reuses the shipped announcement rather than inventing a second one" % (after - before))
	print("  HEADS DOWN  declared `%s`, resolved `%s`, intent_fallback +%.0f" % [
		better.display_name, String(decl.get("ability").display_name), after - before])
	foe.statuses.clear()


# ── §2e — THE SELECTION POLICY IS UNTOUCHED ─────────────────────────────────
# BL §1's header states that a diff which touches the rules inside
# `_choose_enemy_action` is a diff that broke its promise. The card is ONE
# condition in `_intent_ability_usable` and NOTHING in the selection policy,
# and that is asserted here in both directions — the refusal is where it is
# claimed to be, and it is not anywhere it is claimed not to be.
func _policy(src: String) -> void:
	ok(src.contains("if u.has_status(\"heads_down\"):\n\t\tvar hd_basic := _cheapest_attack(u)\n\t\tif hd_basic != null and ab != hd_basic:\n\t\t\treturn false"),
		"the refusal is no longer the identity test against `_cheapest_attack` — if it has become a cost test again it suppresses almost nothing while reading as working")
	var at := src.find("func _choose_enemy_action")
	ok(at >= 0, "`_choose_enemy_action` is gone — BL §1's selection half has moved")
	if at < 0:
		return
	var end := src.find("\nfunc ", at + 1)
	ok(end > at, "`_choose_enemy_action` runs to the end of the file — the scan found no next function")
	if end <= at:
		return
	ok(not src.substr(at, end - at).contains("heads_down"),
		"`_choose_enemy_action` has grown a `heads_down` read — BL §1 forbids touching the selection policy, and the suppression belongs at re-validation where the announcement already exists")


# ── HELPERS ─────────────────────────────────────────────────────────────────
# `hero_key` rather than spec: the fixture puts whichever Hunter spec it was
# handed into the one hunter slot, so both fixtures answer the same lookup.
func _hunter(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.hero_key == "hunter":
			return h
	return null


func _warden(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.hero_key == "warrior":
			return h
	return null


func _foe(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead:
			return e
	return null


# A PLAIN SINGLE-TARGET STRIKE. `special` and `aoe` are both excluded so the
# probe cannot route through `_resolve_special` (which never reaches the
# multiplier block at all) or spill onto a second body whose own reset this
# arm does not do.
func _probe(u: BattleUnit) -> Ability:
	for a in u.abilities:
		if a.damage > 0 and a.special == "" and not a.aoe:
			return a
	return null
