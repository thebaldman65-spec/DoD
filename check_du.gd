# BATCH DU — THE TWO TERMS A COMPANION CAN WEAR, AND THE WALK THAT CAN SEE
# EVERY BASIC ATTACK.
#
#   §0  the premises this whole gate stands on, re-derived rather than inherited
#   §1  CRIPPLE — measured on real blows, not asserted from a read site
#   §2  CHILLED — both terms, measured, and the node magnitude read off the tree
#   §3  WHAT A COMPANION CAN ACTUALLY REACH, and the arm that is unreachable
#   §4  the term that is deliberately still unread, and why it would pay nothing
#   §5  the corpus reaches every spec's LIVE basic attack
#   §6  the rulings are written where a later batch will read them
#
# WHY THE RATIO AND NOT THE READ SITE. DK's Empower defect was a status that
# attached perfectly, hung a chip and moved no number, and DT measured seven
# more of exactly that shape on this same damage path. A gate that asserted
# `battle.gd` CONTAINS a cripple read would have passed on every one of them.
# **SO EVERY ASSERTION BELOW IS A NUMBER OFF FORTY SEEDED BLOWS**, and the
# arithmetic each arm is checked against is derived from the hero strike loop's
# own constants rather than typed in twice.
#
# AND THE GATE IS THE COMPANION TO THE RULING, NOT DECORATION. `check_dk` §4
# re-measures `empower` and `check_dm` §2 re-measures `wrath` and
# `battle_shout` every battery run, so the day a read site appears for one of
# those the gates say the ruling is stale. Before DU, `cripple` and `chilled`
# had no such instrument in either direction — which is why the day the read
# was ADDED there was nothing to notice it, and why removing it again would
# have been silent.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_du.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# Forty blows a side, one seed, both arms. The seed is per-PAIR and the same
# constant in every arm, so the variance roll and the crit coin are identical
# across arms and the only thing that differs is the status under test. DF's
# idiom, DD's method, and DK §4's `_blows` verbatim in intent.
const BLOWS := 40
const SEEDV := 20260829

# The hero strike loop's own numbers, and they are here so the failure MESSAGE
# can say what it wanted. §1 and §2 assert against these; a batch that retunes
# the loop and not this gate gets a red that names the disagreement rather than
# a silently re-derived pass.
const CRIPPLE_MULT := 0.75
const CHILL3_MULT := 0.85
const CHILL3_MIN := 3

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DU — THE COMPANION DAMAGE PATH READS TWO MORE TERMS")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")

	_s5_corpus()
	_s6_recorded()

	var scene: Node = await Gate.spawn(self, ["warden", "pyromancer", "cryomancer",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(scene), "the fixture is headless, so no bot mix is measured")
	await _live(scene)
	scene.queue_free()

	_g.report(self)


# ── the harness ─────────────────────────────────────────────────────────────
func _blows(scene: Node, comp: BattleUnit, foe: BattleUnit) -> int:
	var total := 0
	seed(SEEDV)
	for _i in BLOWS:
		var before: int = foe.hp
		await scene._companion_hit(comp, foe, 0.20 * comp.attack, 0)
		total += before - foe.hp
	return total


func _hunter(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.hero_key == "hunter":
			return h
	return null


func _foe(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead:
			return e
	return null


# The live rank of the node that deepens the chill malus, READ OFF THE TREE.
# Typing 3 in here would make §2's expected ratio agree with itself instead of
# with the game — the exact shape of a check that has stopped asking.
func _hungering_rank() -> int:
	for node in Talents.LANE_TREES.get("cryomancer", []):
		if String(node.get("id", "")) == "cr_hungering":
			return int((node.get("payload", {}).get("stat", {}) as Dictionary)
				.get("hungering_ranks", 0))
	return 0


func _live(scene: Node) -> void:
	var bm := _hunter(scene)
	ok(bm != null, "the fixture fields a hunter to summon with")
	if bm == null:
		return
	await scene._do_summon(bm, "ursus")
	var comps: Array = scene.get("companions")
	ok(comps.size() > 0, "the summon put a companion on the field")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]

	# ── §0 — THE PREMISES ───────────────────────────────────────────────────
	# Re-derived here rather than inherited from DT's report. Every number below
	# is meaningless if any of these has moved.
	print("\n§0 — the premises, re-derived")
	ok(not scene.get("heroes").has(comp),
		"`heroes` now carries the companion — it would take the hero loop's terms and this gate measures nothing")
	ok(scene._hero_side().has(comp),
		"`_hero_side()` does not hold the living companion — an enemy can no longer aim at it and §1's premise is gone")
	ok(comp.is_hero and comp.is_companion,
		"a companion is no longer built `is_hero` — every `not attacker.is_hero` gate in the strike loop changes meaning")
	ok(comp.passive_id == "",
		"a companion carries a `passive_id` now (`%s`) — the ten passive-gated terms are reachable and DT's count is stale" % comp.passive_id)
	# THE ENEMY HALF, DERIVED FROM THE DATA AND NOT LISTED. Two abilities carry
	# Cripple today; what matters is that the number is not zero, because a
	# malus nothing applies is not an exploit.
	var edata: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/enemies.json"))
	var crip_ab: Array = []
	for kind in edata:
		for ab in (edata[kind].get("abilities", []) as Array):
			if String((ab.get("applies_status", {}) as Dictionary).get("id", "")) == "cripple":
				crip_ab.append("%s (%s)" % [ab.get("display_name", "?"), kind])
	ok(not crip_ab.is_empty(),
		"NO enemy ability applies Cripple any more — §1 is repairing an exploit nothing can reach")
	print("  enemy abilities that land Cripple: %d — %s" % [crip_ab.size(),
		", ".join(crip_ab)])

	var foe := _foe(scene)
	ok(foe != null, "the fixture fields a foe for the companion to strike")
	if foe == null:
		return
	foe.max_hp = 100000000
	foe.hp = foe.max_hp
	foe.statuses.clear()
	comp.statuses.clear()
	comp.dead = false
	comp.hp = comp.max_hp
	# A LARGE ATTACK so the band measures the term and not integer rounding —
	# `check_di` §5's scar, inherited rather than re-learned.
	comp.attack = 5000

	var plain := await _blows(scene, comp, foe)
	ok(plain > 0, "the plain arm landed no damage at all — every ratio below divides by zero")
	if plain <= 0:
		return

	# ── §1 — CRIPPLE ────────────────────────────────────────────────────────
	print("\n§1 — a crippled companion bites a quarter softer, measured")
	comp.statuses.clear()
	var ci: Array = scene.STATUS_INFO["cripple"]
	comp.add_status("cripple", ci[0], ci[1], ci[2], 99, ci[3])
	ok(comp.has_status("cripple"),
		"the companion will not hold Cripple, so §1 is measuring nothing")
	var crip := await _blows(scene, comp, foe)
	var r1 := float(crip) / float(plain)
	print("  %d seeded blows: %d plain, %d Crippled — ratio %.4f (want %.4f)" % [
		BLOWS, plain, crip, r1, CRIPPLE_MULT])
	ok(absf(r1 - CRIPPLE_MULT) < 0.002,
		"Cripple moves a companion's damage by %.4f, want %.4f — the read at `_companion_hit` is gone or has been retuned, and an enemy debuff is paying nothing again" % [r1, CRIPPLE_MULT])

	# ── §2 — CHILLED, BOTH TERMS ────────────────────────────────────────────
	print("\n§2 — both chilled terms, measured, against the live node magnitude")
	var hr := _hungering_rank()
	ok(hr > 0,
		"the node that deepens the chill malus writes rank 0 — §2's second arm would measure nothing")
	# ARM A — one stack, no rank anywhere. Below the threshold and with no node
	# behind it, the correct answer is NO CHANGE, and asserting that is what
	# stops a batch from making the malus flat.
	comp.statuses.clear()
	scene._apply_status(comp, "chilled", 3)
	ok(comp.status_stacks("chilled") == 1,
		"one application of Chilled no longer lands exactly one stack (reads %d)" % comp.status_stacks("chilled"))
	var ch1 := await _blows(scene, comp, foe)
	var r2 := float(ch1) / float(plain)
	print("  1 stack, no node:      ratio %.4f (want 1.0000 — under the threshold)" % r2)
	ok(absf(r2 - 1.0) < 0.002,
		"one stack of Chilled and no node moved a companion's damage (%.4f) — the threshold arm is firing below its own floor" % r2)
	# ARM B — the threshold arm.
	comp.statuses.clear()
	for _i in CHILL3_MIN:
		scene._apply_status(comp, "chilled", 3)
	ok(comp.status_stacks("chilled") == CHILL3_MIN,
		"three applications no longer reach %d stacks (reads %d)" % [
			CHILL3_MIN, comp.status_stacks("chilled")])
	var ch3 := await _blows(scene, comp, foe)
	var r3 := float(ch3) / float(plain)
	print("  %d stacks, no node:     ratio %.4f (want %.4f)" % [CHILL3_MIN, r3, CHILL3_MULT])
	ok(absf(r3 - CHILL3_MULT) < 0.002,
		"%d stacks of Chilled move a companion's damage by %.4f, want %.4f" % [
			CHILL3_MIN, r3, CHILL3_MULT])
	# ARM C — the NODE arm, on one stack, which isolates the second term from
	# the first: the threshold arm cannot fire at one stack, so anything this
	# arm moves is the node and only the node.
	var carrier: BattleUnit = null
	for h2 in scene.get("heroes"):
		if not h2.is_companion and not h2.dead and carrier == null:
			carrier = h2
	ok(carrier != null, "no living hero to carry the rank")
	if carrier == null:
		return
	var kept_rank: int = carrier.hungering_ranks
	carrier.hungering_ranks = hr
	ok(scene._max_hero_rank("hungering_ranks") == hr,
		"the party's rank reads %d, not the node's %d" % [
			scene._max_hero_rank("hungering_ranks"), hr])
	comp.statuses.clear()
	scene._apply_status(comp, "chilled", 3)
	var ch1n := await _blows(scene, comp, foe)
	var r4 := float(ch1n) / float(plain)
	var want4 := 1.0 - 0.01 * hr * 1
	print("  1 stack, node rank %d:  ratio %.4f (want %.4f)" % [hr, r4, want4])
	ok(absf(r4 - want4) < 0.002,
		"the per-stack node term pays %.4f on one stack, want %.4f — the companion path reads the threshold arm and not this one" % [r4, want4])
	# ARM D — both terms at once, which is the only arm that would catch a
	# version that read one of them and silently dropped the other.
	comp.statuses.clear()
	for _i2 in CHILL3_MIN:
		scene._apply_status(comp, "chilled", 3)
	var ch3n := await _blows(scene, comp, foe)
	var r5 := float(ch3n) / float(plain)
	var want5 := CHILL3_MULT * (1.0 - 0.01 * hr * CHILL3_MIN)
	print("  %d stacks, node rank %d: ratio %.4f (want %.4f — both terms)" % [
		CHILL3_MIN, hr, r5, want5])
	ok(absf(r5 - want5) < 0.002,
		"both chilled terms together pay %.4f, want %.4f — one of the two is missing from the companion path" % [r5, want5])
	carrier.hungering_ranks = kept_rank

	# ── §3 — WHAT A COMPANION CAN ACTUALLY REACH ────────────────────────────
	# **THE ARM ABOVE IS DRIVEN AT A DEPTH THE GAME CANNOT CURRENTLY PRODUCE,
	# AND SAYING SO IS THE FINDING RATHER THAN A CAVEAT.** The only application
	# of Chilled that reaches a companion is the HOARFROST modifier's stamp, and
	# it lands ONE. The stack count was NOT raised to make the threshold arm
	# reachable — that would be authoring — so the arm is written, measured at a
	# depth a fixture can force, and reported as unreachable in play.
	print("\n§3 — what a companion can reach, measured rather than assumed")
	comp.statuses.clear()
	scene._stamp_modifier(comp, "hoarfrost")
	var stamped: int = comp.status_stacks("chilled")
	ok(stamped == 1,
		"the frost bargain stamps %d stack(s) on a summoned companion, not 1 — §3's ceiling has moved and the report is stale" % stamped)
	print("  the frost bargain stamps %d stack on a companion; the threshold arm needs %d," % [
		stamped, CHILL3_MIN])
	print("  so the threshold term is UNREACHABLE in play today and is written anyway.")

	# ── §4 — THE TERM THAT IS DELIBERATELY STILL UNREAD ─────────────────────
	print("\n§4 — typed relic damage is inert TWICE OVER and is not read")
	comp.statuses.clear()
	comp.type_dmg_bonus = {}
	scene._stamp_modifier(comp, "tinderbox")
	ok(not comp.type_dmg_bonus.is_empty(),
		"the kindling bargain no longer writes a typed bonus onto a companion — §4's first half is stale")
	print("  a companion CAN be given %s" % str(comp.type_dmg_bonus))
	var tind := await _blows(scene, comp, foe)
	ok(tind == plain,
		"a typed damage bonus now moves a companion's blow (%d vs %d) — it has grown a damage TYPE, and §4's second reason is gone" % [tind, plain])
	print("  ...and it pays nothing: %d against %d plain. A companion's blow carries no damage type," % [
		tind, plain])
	print("  so reading the bonus would find nothing to apply it to. Reported, not fixed.")
	comp.type_dmg_bonus = {}
	comp.statuses.clear()


# ── §5 — THE WALK REACHES EVERY LIVE BASIC ATTACK ───────────────────────────
# DERIVED, NEVER LISTED. Naming the four overrides here would pass on a fifth
# being authored and never reaching the walk, which is the defect DU §4 fixed
# wearing a different name.
func _s5_corpus() -> void:
	print("\n§5 — every spec's LIVE basic attack is in the one authorised walk")
	var names := {}
	for ab in Classes.ability_corpus():
		names[ab.display_name] = true
	var missing: Array = []
	var overridden: Array = []
	for spec in Classes.SPEC_INFO:
		var ck := Classes.class_of_spec(spec)
		if ck == "":
			continue
		var plain_kit: Array = Classes.kit(ck)
		var cfg := {"abilities": Classes.kit(ck)}
		Classes.apply_kit_overrides(cfg, spec)
		var live_kit: Array = cfg["abilities"]
		for i in live_kit.size():
			var nm: String = live_kit[i].display_name
			if not names.has(nm):
				missing.append("%s/%s" % [spec, nm])
			if i < plain_kit.size() and nm != String(plain_kit[i].display_name):
				overridden.append("%s -> %s" % [spec, nm])
	for m in missing:
		ok(false, "%s is a live protected-core ability the corpus walk cannot see (BATCH DU §4)" % m)
	ok(missing.is_empty(),
		"every spec's live basic attack is reachable through `Classes.ability_corpus()`")
	ok(not overridden.is_empty(),
		"no spec overrides its class basic any more — §5 is asserting nothing")
	print("  %d spec(s) replace their class basic at spawn: %s" % [
		overridden.size(), ", ".join(overridden)])
	# AND THE FIGURE THE BLIND SPOT PRODUCED, DERIVED SO IT CANNOT BE MIS-QUOTED
	# AGAIN. "Twelve cooldown-zero abilities in the protected cores" is twelve
	# INSTANCES across twelve specs; the DISTINCT count is what a reader hears.
	var inst := 0
	var distinct := {}
	for spec2 in Classes.SPEC_INFO:
		var ck2 := Classes.class_of_spec(spec2)
		if ck2 == "":
			continue
		var cfg2 := {"abilities": Classes.kit(ck2)}
		Classes.apply_kit_overrides(cfg2, spec2)
		for ab2 in (cfg2["abilities"] as Array):
			if ab2.cooldown == 0:
				inst += 1
				distinct[ab2.display_name] = true
		for ab3 in Classes.spec_abilities(spec2):
			if ab3 != null and ab3.cooldown == 0:
				inst += 1
				distinct[ab3.display_name] = true
	ok(distinct.size() < inst,
		"the protected-core cooldown-zero census reads %d instances and %d distinct names — they agree now, so the correction this gate carries is stale" % [
			inst, distinct.size()])
	print("  protected-core cooldown-zero: %d INSTANCES, %d DISTINCT names — %s" % [
		inst, distinct.size(), ", ".join(distinct.keys())])


# ── §6 — THE RULINGS ARE WRITTEN DOWN ───────────────────────────────────────
func _s6_recorded() -> void:
	print("\n§6 — the two rulings are recorded where a later batch will read them")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm != "", "CLAUDE.md is readable")
	ok(cm.contains("A REPEATABLE DRAFT CARD IS A LEGITIMATE SHAPE WHEN IT IS PRICED ELSEWHERE"),
		"CLAUDE.md does not carry DU §1's ruling")
	ok(cm.contains("A cooldown is not this project's only rate limiter"),
		"CLAUDE.md carries the ruling without the REASONING, which is the half a later batch needs")
	ok(cm.contains("A DEAD PLAYER CARD IS A DEAD CARD; A DEAD ENEMY DEBUFF IS AN EXPLOIT"),
		"CLAUDE.md does not carry DU §2's distinction — the reason this widening was taken where DK's was not")
