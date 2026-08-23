# BATCH DK — THE GATE FOR "FOUR ALLY-WORDED EFFECTS REACH THE BEAST, AND SEVEN
# SAY HERO BECAUSE THEY CANNOT".
#
# DJ §2 swept every broad ally-worded card and node and found ELEVEN besides
# Harvest walking bare `heroes`, which holds no companion. It ruled on none of
# them, because an exclusion that is INTENDED wants its TEXT corrected and one
# that is ACCIDENTAL wants its CODE corrected, and that is a designer's call.
# **DK IS THAT CALL, AND IT SPLIT THE ELEVEN FOUR AND SEVEN.**
#
# SIX SECTIONS, AND §2 AND §3 ARE THE ONES THAT COULD FAIL FOR A REAL REASON:
#   §1  the four widened COLLECTIONS, read out of `battle.gd`'s own text
#   §2  the receipts, on a REAL SUMMONED BEAST — four measurements
#   §3  THE NEGATIVE CONTROL: the union broken, and the same checks red
#   §4  Tank and Spank stayed narrow, and the MEASUREMENT that decided it
#   §5  the eleven texts, seven `hero` and four `ally`
#   §6  the belief is gone from the LIVE prose, glossary included
#
# WHY §3 EXISTS AND WHY IT IS NOT OPTIONAL. The failure DK repairs was INVISIBLE
# in every battery ever run: four effects quietly paid four units instead of
# five, and nothing anywhere reported it. A check that passes on the fixed tree
# proves nothing on its own — it has to be shown to FAIL on the broken one. §3
# empties `companions` for the length of one arm, which is precisely the
# pre-DK collection at these sites, and asserts the beast is untouched.
#
# WHY TANK AND SPANK IS IN §4 AND NOT §1, WHICH IS THIS BATCH'S ACTUAL CARE.
# It was the fifth candidate and it is the one the brief was wrong about.
# `empower` APPLIES to a companion perfectly well and pays it NOTHING: a beast
# strikes through `_companion_hit`, its own damage path, which reads none of
# the hero strike loop's multiplier block. Widening it would have hung a
# VISIBLE chip on a beast and moved no number — a no-op that reads as working,
# which is worse than the narrow word. §4 measures that rather than asserting
# it, so the day somebody gives `_companion_hit` an `empower` read, this gate
# says the ruling is stale instead of staying quietly true.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dk.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE FOUR THAT WIDENED, each pinned by its own read line. A fragment that stops
# matching is a REGRESSION here rather than a notice: DK ruled on these, so a
# site that goes back to bare `heroes` has undone the ruling.
const WIDENED := {
	"wd_rally Rally":
		"for h in _hero_side():\n\t\t\t\t\t\t\t\th.add_status(\"rally_heal\", rinfo[0], rinfo[1],",
	"wd_hold_line Hold the Line":
		"for h in _hero_side():\n\t\t\t\t_apply_status(h, \"hold_bd\", 2, hl_cut)",
	"sanctuary Sanctuary":
		"for h in _hero_side():\n\t\t\t\tvar amt := int(h.max_hp * sanct_pct)",
	"sv_medic Field Medic":
		"var fm_pool: Array = _hero_side().filter(\n\t\t\t\t\tfunc(h): return _status_count(h) > 0)",
}

# THE SEVEN THAT STAYED NARROW, each by the read line that keeps them narrow.
# **THE COLLECTION IS THE RULING HERE TOO** — the texts in §5 are only honest
# while these still walk the four.
const NARROW := {
	"wd_tank_spank Tank and Spank":
		"var pals := heroes.filter(func(h): return not h.dead)",
	"wd_stomp_drill Rallying Cry":
		"for rc_h in heroes:",
	"War Stomp's resource rider":
		"for h in heroes:\n\t\t\t\tif h.dead or h == attacker or h.resource_name == \"\":",
	"rally Rallying Shout":
		"for h in heroes.filter(func(he): return not he.dead):\n\t\t\t\th.pressure = maxi(h.pressure - pressure_cut, 0)",
	"dv_devoutness Devoutness":
		"for h in heroes:\n\t\t\t_apply_status(h, \"devotion\", -1, dvn_pct)",
	"hl_last_hope Last Hope":
		"for h in heroes:\n\t\tga_step = maxi(ga_step, h.guardian_step)",
	"dv_waters Cleansing Waters":
		"if zl_dv.waters_ranks > 0 and randf() < 0.01 * zl_dv.waters_ranks:",
}

# The node/ability texts, and which WORD each must carry now. The four widened
# keep "ally" and are TRUE for the first time; the seven say "hero".
const TEXT_IS_HERO := [
	"Mocking Blow ALWAYS Empowers a random hero (2 turns).",
	"every hero regains {v}% of their maximum resource",
	"Heroes regain 20% of their resource",
	"and 15 BD each. Heroes regain 10%",
	"every other hero\\nregains 30% of their resource.",
	"each hero has a {v}% chance each turn",
	"Every hero takes {v}% less Break damage.",
	"Heroes under 25% of their maximum health receive 40% more healing.",
]

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DK — FOUR ALLY-WORDED EFFECTS REACH THE BEAST")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_collections(src)
	_texts()
	_prose()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	await _receipts(a)
	a.queue_free()

	_g.report(self)


# ── §1 — THE FOUR COLLECTIONS, AND THE SEVEN THAT STAYED ────────────────────
# READ OUT OF THE SOURCE, because §2's live measurement would also pass if a
# later batch spelled the union some other way — and because the SEVEN have no
# live measurement available at all (a narrow loop's evidence is that it is
# still narrow). Both halves are asserted so the ruling cannot half-rot.
func _collections(src: String) -> void:
	for what in WIDENED:
		ok(src.contains(WIDENED[what]),
			"%s no longer reads `_hero_side()` — the beast is out of the party again" % what)
	for what in NARROW:
		ok(src.contains(NARROW[what]),
			"%s no longer walks bare `heroes` — DK §2 ruled it a HERO effect, so its text is now wrong" % what)
	print("  %d widened to `_hero_side()`, %d deliberately still walk the four" % [
		WIDENED.size(), NARROW.size()])
	# AND THE DECISION ABOUT `dead`, WHICH IS THE HALF DI GOT WRONG ONE BATCH
	# AGO. All four widened sites take the LIVING, and `_hero_side()` is the
	# authored name for exactly that. Harvest is the counter-case and MUST NOT
	# be dragged along: it asks who OPENED a wound, so a fallen hero still pays.
	ok(src.contains("var hv_party: Array = heroes + companions"),
		"Harvest's union stopped being spelled out — a receive-site's `dead` answer is not its answer")
	var hv_at := src.find("for hv_h in ")
	ok(hv_at >= 0 and not src.substr(hv_at, src.find("\n", hv_at) - hv_at).contains("_hero_side"),
		"Harvest's loop now walks `_hero_side()`, which filters `dead` — a FALLEN opener's wound stops paying")


# ── §2 — THE RECEIPTS, ON A REAL SUMMONED BEAST ─────────────────────────────
# **WHICH ARM IS DRIVEN AND WHICH IS COMPOSED IS SAID RATHER THAN BLURRED**,
# which is `check_dj` §3's discipline. Sanctuary and Hold the Line are DRIVEN
# through `_resolve_special` the way a cast reaches them. Rally and Field Medic
# live inside `_resolve`'s block branch and `_run_battle`'s turn-start block and
# cannot be called; for those the gate evaluates THE LOOP'S OWN EXPRESSION live
# and measures what the beast receives from it, which is the same two facts the
# driven pair prove in one step.
func _receipts(scene: Node) -> void:
	var bm := _beastmaster(scene)
	ok(bm != null, "the fixture fields a Beastmaster")
	if bm == null:
		return
	await scene._do_summon(bm, "ursus")
	var comps: Array = scene.get("companions")
	ok(comps.size() > 0, "the summon put a companion on the field")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]
	# THE PREMISE, RE-ASSERTED HERE RATHER THAN INHERITED (DJ's idiom). If a
	# later batch puts companions in `heroes`, `_hero_side()` double-counts and
	# every number below is measuring the wrong thing.
	ok(not scene.get("heroes").has(comp),
		"`heroes` now carries the companion — `_hero_side()` double-counts and DK's premise is stale")
	ok(scene._hero_side().has(comp),
		"`_hero_side()` does not hold the living beast — every widened site is reaching nobody")

	var warden := _warden(scene)
	ok(warden != null, "the fixture fields a Warden to cast")
	if warden == null:
		return

	# ── SANCTUARY, DRIVEN ────────────────────────────────────────────────────
	var sanct = _ability("Sanctuary")
	ok(sanct != null, "Sanctuary resolves out of the live corpus")
	if sanct != null:
		var healed := await _sanctuary_arm(scene, warden, sanct, comp, false)
		var control := await _sanctuary_arm(scene, warden, sanct, comp, true)
		print("  SANCTUARY  beast healed %d with the union, %d with it broken" % [
			healed, control])
		ok(healed > 0,
			"Sanctuary healed the beast for %d — the widening did not land" % healed)
		# §3's CONTROL. Pre-DK this site walked bare `heroes` and the beast got
		# nothing; emptying `companions` reproduces exactly that collection.
		ok(control == 0,
			"THE NEGATIVE CONTROL FAILED: the beast healed %d with `companions` empty, so the check is not reading the union" % control)

	# ── HOLD THE LINE, DRIVEN ────────────────────────────────────────────────
	var hold = _ability("Hold the Line")
	ok(hold != null, "Hold the Line resolves out of the live corpus")
	if hold != null:
		var bd_held := await _hold_arm(scene, warden, hold, comp, false)
		var bd_bare := await _hold_arm(scene, warden, hold, comp, true)
		print("  HOLD THE LINE  a 40-BD blow banked %d on the covered beast, %d with the union broken" % [
			bd_held, bd_bare])
		ok(bd_bare == 40,
			"the control arm banked %d Break rather than the unmitigated 40 — the fixture is not measuring what it thinks" % bd_bare)
		ok(bd_held < bd_bare,
			"Hold the Line left the beast at %d Break against an unheld %d — the line does not cover it" % [
				bd_held, bd_bare])
		# The cut is the status' own power, so the arithmetic is checkable
		# rather than merely directional: 40 at a 50% cut is 20.
		ok(bd_held == 20,
			"the covered beast banked %d Break; the base cut is 50%% of 40, which is 20" % bd_held)
		# AND THE SECOND HALF OF THE CARD, which is the one that saves a life.
		comp.statuses.clear()
		comp.broken = false
		comp.hp = comp.max_hp
		comp.dead = false
		await scene._resolve_special(warden, hold, warden, "good", 1.0)
		ok(comp.has_status("undying"),
			"the beast took the Break cut but not the no-death window — one of the two `_apply_status` calls is still narrow")
		comp.hp = 50
		comp.take_hit(999999, 0)
		ok(comp.hp == 1 and not comp.dead,
			"the beast died through Hold the Line's undying (hp %d, dead %s)" % [comp.hp, comp.dead])

	# ── RALLY, COMPOSED ──────────────────────────────────────────────────────
	# The loop's own collection, evaluated live, plus what the status pays the
	# body it lands on. Together these are the whole of "Rally reaches it".
	comp.statuses.clear()
	comp.broken = false
	comp.dead = false
	comp.max_hp = 10000
	comp.hp = 1000
	var plain: int = comp.heal_amount(1000, true)
	var rinfo: Array = scene.STATUS_INFO["rally_heal"]
	comp.add_status("rally_heal", rinfo[0], rinfo[1], rinfo[2], 3, rinfo[3])
	comp.hp = 1000
	var rallied: int = comp.heal_amount(1000, true)
	print("  RALLY  a 1000 heal on the beast: %d plain, %d Rallied" % [plain, rallied])
	ok(plain == 1000 and rallied == 1300,
		"Rallied healing on the beast read %d against a plain %d — the card promises +30%%" % [
			rallied, plain])
	comp.statuses.clear()

	# ── FIELD MEDIC, COMPOSED ────────────────────────────────────────────────
	# The pool expression verbatim, so a beast carrying an affliction is in it.
	scene._apply_status(comp, "poison", 5, 0, 3)
	var pool: Array = scene._hero_side().filter(
		func(h): return scene._status_count(h) > 0)
	ok(pool.has(comp),
		"the Field Medic's pool does not hold a poisoned beast — his washes cannot reach it")
	var washed: String = comp.dispel_one_debuff()
	ok(washed != "" and scene._status_count(comp) == 0,
		"the beast's affliction did not come off (washed '%s', %d left)" % [
			washed, scene._status_count(comp)])
	# AND THE CONTROL FOR THIS PAIR TOO: with the union broken the pool is the
	# four, and a poisoned beast is not in it.
	scene._apply_status(comp, "poison", 5, 0, 3)
	var kept: Array = scene.get("companions").duplicate()
	scene.set("companions", [])
	var bare: Array = scene._hero_side().filter(
		func(h): return scene._status_count(h) > 0)
	scene.set("companions", kept)
	ok(not bare.has(comp),
		"THE NEGATIVE CONTROL FAILED: the poisoned beast is in the pool with `companions` empty")
	comp.statuses.clear()

	await _tank_spank(scene, comp)


# ── §4 — TANK AND SPANK STAYED NARROW, AND WHY ──────────────────────────────
# **THE ONE OF THE FIVE THE BRIEF WAS WRONG ABOUT**, and the reason is measured
# here rather than asserted, because it is a claim about a damage path and a
# claim about a damage path can rot. If a later batch teaches `_companion_hit`
# to read `empower`, this ratio moves off 1.0 and the gate says the ruling
# needs re-taking — which is the only honest way to pin "we did not widen it
# BECAUSE it would have paid nothing".
func _tank_spank(scene: Node, comp: BattleUnit) -> void:
	var foe := _foe(scene)
	ok(foe != null, "the fixture fields a foe for the beast to strike")
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
	var einfo: Array = scene.STATUS_INFO["empower"]
	comp.add_status("empower", einfo[0], einfo[1], einfo[2], 99, einfo[3])
	ok(comp.has_status("empower"),
		"the beast will not even hold Empower, so §4 is measuring nothing")
	var empowered := await _blows(scene, comp, foe)
	var r := (float(empowered) / float(plain)) if plain > 0 else 0.0
	print("  TANK AND SPANK  40 seeded beast blows: %d plain, %d Empowered — ratio %.4f" % [
		plain, empowered, r])
	ok(plain > 0 and empowered > 0, "both arms landed blows")
	ok(r > 0.999 and r < 1.001,
		"Empower now moves a beast's damage (ratio %.4f) — `_companion_hit` has grown a read site, so DK §2's ruling that Tank and Spank is a HERO effect must be re-taken" % r)
	comp.statuses.clear()


# Forty seeded blows down the companion damage path. Both arms take the same
# seed, so the ±10% roll and the crit coin are identical in each and the only
# difference between them is the chip.
func _blows(scene: Node, comp: BattleUnit, foe: BattleUnit) -> int:
	var total := 0
	seed(20260824)
	for _i in 40:
		var before: int = foe.hp
		await scene._companion_hit(comp, foe, 0.20 * comp.attack, 0)
		total += before - foe.hp
	return total


# One Sanctuary. `break_union` empties `companions` for the length of the cast,
# which is exactly the collection this site walked before DK.
func _sanctuary_arm(scene: Node, caster: BattleUnit, sanct, comp: BattleUnit,
		break_union: bool) -> int:
	comp.statuses.clear()
	comp.broken = false
	comp.dead = false
	comp.max_hp = 10000
	comp.hp = 1000
	var kept: Array = scene.get("companions").duplicate()
	if break_union:
		scene.set("companions", [])
	await scene._resolve_special(caster, sanct, caster, "good", 1.0)
	if break_union:
		scene.set("companions", kept)
	return comp.hp - 1000


# One Hold the Line, then a 40-BD blow on the beast. Returns the Break banked.
func _hold_arm(scene: Node, caster: BattleUnit, hold, comp: BattleUnit,
		break_union: bool) -> int:
	comp.statuses.clear()
	comp.broken = false
	comp.dead = false
	comp.hp = comp.max_hp
	comp.pressure = 0
	var kept: Array = scene.get("companions").duplicate()
	if break_union:
		scene.set("companions", [])
	await scene._resolve_special(caster, hold, caster, "good", 1.0)
	if break_union:
		scene.set("companions", kept)
	comp.take_hit(0, 40)
	return comp.pressure


# ── §5 — THE ELEVEN TEXTS ───────────────────────────────────────────────────
# Seven say HERO because no collection can reach a beast (or, for Tank and
# Spank, because reaching it would pay nothing). Four keep ALLY and are true
# for the first time. **BOTH HALVES ARE ASSERTED**: a batch that widens a
# narrow loop without moving its word, or narrows a wide one, breaks one half.
func _texts() -> void:
	var tal := FileAccess.get_file_as_string("res://scripts/talents.gd")
	var cls := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(tal != "" and cls != "", "talents.gd and classes.gd are readable")
	for t in TEXT_IS_HERO:
		ok(tal.contains(t) or cls.contains(t),
			"a DK §2 text no longer says `hero`: %s" % t)
	# AND THE FOUR THAT KEEP "ALLY", which are only correct because §1 widened.
	var allies := {
		"wd_rally Rally": "grants every ally +30% healing received",
		"wd_hold_line Hold the Line": "every ally takes 50% less Break damage",
		"sv_medic Field Medic": "cleanse {v} debuffs from random allies",
	}
	for what in allies:
		ok(tal.contains(allies[what]),
			"%s stopped saying `ally`, but its read site still reaches companions" % what)
	ok(cls.contains("Ground made safe: every ally heals"),
		"sanctuary Sanctuary stopped saying `ally`, but its read site still reaches companions")
	# NO §2 TEXT MAY STILL CARRY THE OLD WORD. The seven were moved one at a
	# time and a half-moved text is the failure this catches.
	for stale in ["Empowers a random ally", "every ally regains {v}%",
			"Allies regain", "every other ally", "each ally has a {v}%",
			"Every ally takes {v}%", "Allies under 25%"]:
		ok(not tal.contains(stale) and not cls.contains(stale),
			"a DK §2 text still carries its pre-DK `ally` wording: %s" % stale)


# ── §6 — THE PROSE ──────────────────────────────────────────────────────────
# CV §4's stated test was *"their read sites genuinely include companions"* and
# it was false for all four texts it moved. DJ corrected the FACT in four live
# places; the TEST itself is what a future author would apply, so DK corrects
# that. **THE GLOSSARY IS THE ONE THAT WAS ACTIVELY MISLEADING A PLAYER**: its
# `hero_vs_ally` entry named five effects as examples of what "ally" pays, and
# four of the five were false when it was written.
func _prose() -> void:
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(gloss != "", "data/glossary.json is readable")
	# The two examples that were WRONG and are now named on the other side.
	ok(not gloss.contains("Tank and Spank's Empower, Rally's healing bonus"),
		"the glossary still lists Tank and Spank's Empower as an `ally` effect — it pays a beast nothing")
	ok(gloss.contains("hero_vs_ally"), "the glossary still carries the hero_vs_ally entry")
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(claude != "", "CLAUDE.md is readable")
	# CV's test, which is the sentence a future author would actually apply.
	ok(not claude.contains("moved to *ally* on the reading that their read sites include companions"),
		"CLAUDE.md still records CV §4's false test as the rule for a new node")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master != "", "docs/master.html is readable")
	ok(not master.contains("companions NOT included"),
		"master.html still flags Hold the Line as excluding companions — DK included them")


# ── helpers ────────────────────────────────────────────────────────────────

func _ability(name: String):
	for ab in Classes.ability_corpus():
		if ab.display_name == name:
			return ab
	return null


func _beastmaster(scene: Node) -> BattleUnit:
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
