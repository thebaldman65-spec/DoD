# BATCH DL — THE GATE FOR "RALLYING SHOUT IS TWO CLAUSES, AND THEY HAVE TWO
# DIFFERENT ANSWERS".
#
# THE CARD HID THROUGH TWO SWEEPS AND THE REASON IS THE WHOLE POINT OF THIS
# GATE. DJ §2 swept every broad ally-worded text; DK §2 ruled on eleven of them.
# Both read the ABILITY. Rallying Shout carries TWO clauses in one sentence —
# it sheds 30 Pressure and it refuels 30% of a resource — and only the second
# was ally-worded, so both sweeps found that one, ruled it a HERO effect for the
# right reason ("a beast has no resource bar"), and never looked at the first.
# The first said "the whole party", which is neither of the two words, so
# nothing anywhere was sweeping for it. **It paid four for the life of the
# project while its card promised the shed to everyone standing.**
#
# FIVE SECTIONS:
#   §1  the TWO collections, read out of `battle.gd`'s own text
#   §2  the receipt, on a REAL SUMMONED BEAST — 30 Pressure shed
#   §3  THE NEGATIVE CONTROL: the union broken, and the same measurement reds
#   §4  the clause that did NOT move, measured the same way — it pays 0
#   §5  the two words, in one sentence, on the card and in the log
#
# WHY §3 IS NOT OPTIONAL. The failure DL repairs was invisible in every battery
# ever run: the clause quietly paid four bodies instead of five and no log, no
# suite and no battery said so. A check that passes on the fixed tree proves
# nothing on its own — it has to be shown to FAIL on the broken one. §3 empties
# `companions` for the length of one cast, which is precisely the pre-DL
# collection at this site, and asserts the beast sheds nothing.
#
# WHY §4 EXISTS, WHICH IS DK §1's RULE POINTED AT THE OTHER HALF. "We left this
# clause narrow BECAUSE widening it would pay nothing" is a claim about a code
# path, and a claim about a code path rots. §4 measures it: the beast's resource
# does not move, AND `max_resource` is checked to be non-zero, because DK
# recorded the reason as "`max_resource` 0" and that half was FALSE — it is
# `unit.gd`'s default 100, never overridden at the summon. The only thing
# standing between that loop and a beast banking 30 points of a bar it does not
# have is the `resource_name == ""` guard, which DL added.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dl.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# THE PRESSURE CLAUSE, WIDENED. A fragment that stops matching is a REGRESSION
# rather than a notice: DL ruled this, so a site that goes back to bare `heroes`
# has undone the ruling.
const PRESSURE_WALK := "for h in _hero_side():\n\t\t\t\th.pressure = maxi(h.pressure - pressure_cut, 0)"

# AND THE RESOURCE CLAUSE, WHICH DELIBERATELY DID NOT MOVE. Both halves are
# pinned, because the ruling is that they are DIFFERENT — a batch that widens
# this one has flattened the card back to a single answer.
# **IT CARRIES THE LINE BELOW THE GUARD, AND THAT IS NOT COSMETIC.** DL gave this
# loop the same guard War Stomp's refuel already carried, so the guard alone
# matches BOTH loops — and War Stomp's is 200k characters earlier in the file, so
# a `find` on the short fragment silently measures the wrong site. The `res_pct`
# line is what names this clause. (`check_dk`'s two entries were extended the
# same way and for the same reason.)
const RESOURCE_WALK := "if h.dead or h == attacker or h.resource_name == \"\":\n\t\t\t\t\tcontinue\n\t\t\t\tvar gain := int(h.max_resource * res_pct)"

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DL — RALLYING SHOUT SHEDS PRESSURE ON THE BEAST TOO")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_collections(src)
	_texts()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	await _receipts(a)
	a.queue_free()

	_g.report(self)


# ── §1 — THE TWO COLLECTIONS ────────────────────────────────────────────────
# READ OUT OF THE SOURCE, because §2's live measurement would also pass if a
# later batch spelled the union some other way — and because the NARROW half has
# no live measurement that distinguishes "correctly narrow" from "broken".
func _collections(src: String) -> void:
	ok(src.contains(PRESSURE_WALK),
		"Rallying Shout's Pressure clause no longer reads `_hero_side()` — the beast is out of the shout again")
	ok(src.contains(RESOURCE_WALK),
		"Rallying Shout's resource clause no longer walks bare `heroes` with its guard — a beast has no bar to fill")
	# THE TWO ARE TWO LOOPS, NOT ONE LOOP WITH A FILTER. That is what makes each
	# clause's collection visible where it is READ. A filter hung off a shared
	# union would put the resource clause's answer somewhere the resource clause
	# is not, which is the shape DJ §5 counted 23 of.
	var p_at := src.find(PRESSURE_WALK)
	var r_at := src.find(RESOURCE_WALK)
	ok(p_at >= 0 and r_at > p_at and (r_at - p_at) < 2000,
		"the two clauses are no longer two adjacent loops in one branch (%d, %d)" % [p_at, r_at])
	# AND `dead` IS STILL EXCLUDED BY NAME on the widened half. `_hero_side()` is
	# the authored name for "the union, living only" — the same decision DK took
	# at four sites, for Hold the Line's reason exactly: a corpse has no meter
	# running. Harvest is the counter-case and must not be dragged along.
	ok(src.contains("var hv_party: Array = heroes + companions"),
		"Harvest's union stopped being spelled out — a receive-site's `dead` answer is not its answer")


# ── §2/§3/§4 — THE RECEIPTS, ON A REAL SUMMONED BEAST ───────────────────────
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
	# THE PREMISE, RE-ASSERTED RATHER THAN INHERITED (DJ's idiom, DK's copy). If
	# a later batch puts companions in `heroes`, `_hero_side()` double-counts and
	# every number below measures the wrong thing.
	ok(not scene.get("heroes").has(comp),
		"`heroes` now carries the companion — `_hero_side()` double-counts and DL's premise is stale")

	var warden := _warden(scene)
	ok(warden != null, "the fixture fields a Warden to cast")
	if warden == null:
		return
	var shout = _ability("Rallying Shout")
	ok(shout != null, "Rallying Shout resolves out of the live corpus")
	if shout == null:
		return

	# ── §2: THE PRESSURE CLAUSE ARRIVES ─────────────────────────────────────
	var shed := await _shout_arm(scene, warden, shout, comp, false)
	# ── §3: THE NEGATIVE CONTROL. `companions` emptied for the length of one
	#    cast is EXACTLY the collection this site walked before DL.
	var control := await _shout_arm(scene, warden, shout, comp, true)
	print("  PRESSURE  beast shed %d with the union, %d with it broken" % [shed, control])
	ok(shed == 30,
		"the beast shed %d Pressure — the card says 30, so the widening did not land" % shed)
	ok(control == 0,
		"THE NEGATIVE CONTROL FAILED: the beast shed %d with `companions` empty, so the check is not reading the union" % control)

	# AND THE HERO HALF IS UNMOVED, which is the half the split could have
	# broken silently — one loop became two and a hero is in both.
	comp.pressure = 100
	warden.pressure = 100
	warden.broken = false
	warden.resource = 0
	await scene._resolve_special(warden, shout, warden, "good", 1.0)
	ok(warden.pressure == 70,
		"the CASTER shed %d rather than 30 — splitting the loop moved the hero half" % (100 - warden.pressure))

	# ── §4: THE CLAUSE THAT DID NOT MOVE, MEASURED THE SAME WAY ─────────────
	# DK §1's rule pointed at the half that stayed narrow: the reason is a claim
	# about a code path and a claim about a code path rots.
	ok(comp.resource_name == "",
		"a companion has grown a resource bar named '%s' — Rallying Shout's resource clause must be re-ruled" % comp.resource_name)
	# **AND `max_resource` IS NOT 0.** DK recorded the reason as "no
	# `resource_name` and `max_resource` 0" and the second half was false. If
	# this ever reads 0 the guard stops being load-bearing and the note beside
	# the loop needs re-taking; if it reads non-zero, the guard is the only
	# thing refusing the beast.
	ok(comp.max_resource > 0,
		"a companion's `max_resource` now reads %d — the `resource_name` guard was the only thing refusing it, so DL's recorded reason needs re-taking" % comp.max_resource)
	comp.resource = 0
	var res_before: int = comp.resource
	await scene._resolve_special(warden, shout, warden, "good", 1.0)
	print("  RESOURCE  beast %d -> %d of a %d bar (name '%s')" % [
		res_before, comp.resource, comp.max_resource, comp.resource_name])
	ok(comp.resource == 0,
		"the beast banked %d resource off Rallying Shout — the clause that says HERO is paying a companion" % comp.resource)
	# The measurement is only worth having if the cast actually PAID somebody.
	ok(warden.resource >= 0 and _fed_a_hero(scene, warden),
		"no hero was refuelled by the cast, so §4 is measuring a shout that did nothing")


# One Rallying Shout, and what the beast sheds. `break_union` empties
# `companions` for the length of the cast, which is exactly the collection this
# clause walked before DL.
func _shout_arm(scene: Node, caster: BattleUnit, shout, comp: BattleUnit,
		break_union: bool) -> int:
	comp.statuses.clear()
	comp.broken = false
	comp.dead = false
	comp.hp = comp.max_hp
	comp.pressure = 100
	var kept: Array = scene.get("companions").duplicate()
	if break_union:
		scene.set("companions", [])
	await scene._resolve_special(caster, shout, caster, "good", 1.0)
	if break_union:
		scene.set("companions", kept)
	return 100 - comp.pressure


# At least one hero other than the caster holds resource after the cast — the
# resource clause is live, so "the beast got nothing" is a statement about the
# beast rather than about a shout that paid nobody.
func _fed_a_hero(scene: Node, caster: BattleUnit) -> bool:
	for h in scene.get("heroes"):
		if h.dead or h.is_companion or h == caster:
			continue
		if h.resource > 0:
			return true
	return false


# ── §5 — THE TWO WORDS, IN ONE SENTENCE ─────────────────────────────────────
# **THIS IS THE RULING**, and both halves are asserted: a batch that flattens the
# card back to a single word has undone it, whichever word it picks.
func _texts() -> void:
	var cls := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var bat := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(cls != "" and bat != "", "classes.gd and battle.gd are readable")
	ok(cls.contains("Raise the line: every ally sheds 30"),
		"Rallying Shout's Pressure clause stopped saying `ally`, but its read site still reaches a companion")
	ok(cls.contains("every other hero\\nregains 30% of their resource."),
		"Rallying Shout's resource clause stopped saying `hero`, but a companion still has no bar")
	ok(not cls.contains("the whole party sheds"),
		"Rallying Shout's card has gone back to the word that hid it from two sweeps")
	# THE BATTLE LOG IS A PLAYER-FACING SURFACE TOO, and it carried the same
	# ambiguity one line below the loop.
	ok(bat.contains("Rallying Shout — allies -%d Pressure, heroes +%d%% resource"),
		"the Rallying Shout log line no longer carries both words")
	# AND THE STANDING RULE IS WRITTEN DOWN. A ruling with no rule behind it is
	# re-litigated by the next author who trips on it.
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(claude.contains("THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE, NOT THE ABILITY"),
		"CLAUDE.md no longer carries DL §1's standing rule")


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
