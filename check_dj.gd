# BATCH DJ — THE GATE FOR "AN ALLY LOOP READS `companions` TOO".
#
# DH §1 made Harvest pay MORE for a wound an ALLY opened. DI found the plumbing
# under it and paid most of the debt, then stopped one site short and said so:
# **Harvest's ally loop walked `heroes`, and `heroes` does not carry the
# companions.** A wound Aguila opened therefore paid the BASE rate however it
# was stamped — measured live at exactly 1.0000 of a self-opened board — so DI
# deliberately left the seven companion call sites unstamped rather than let the
# sweep look complete while the wound still paid nothing.
#
# **DJ CLOSES BOTH HALVES**, and this gate is what keeps them closed.
#
# SIX SECTIONS, AND §2 IS THE ONE THAT COULD FAIL FOR A REAL REASON:
#   §1  the loop's COLLECTION, read out of `battle.gd`'s own text
#   §2  the payout, on a wound a REAL COMPANION STRIKE opened
#   §3  the seven companion call sites, driven the way the game drives them
#   §4  a FALLEN hero's wound still pays — the `_hero_side()` trap, asserted
#   §5  the `is_companion` count (the §2 site ratchet moved to `check_dk` at DK)
#   §6  the belief is gone from the LIVE prose
#
# WHY §4 EXISTS AT ALL, AND IT IS THE CARE THIS BATCH IS ACTUALLY ABOUT.
# `docs/reports/DI.md` §3 proposed the fix as *"one word in DH's loop
# (`heroes` -> `_hero_side()`)"*. **THAT WORD WOULD HAVE BEEN WRONG.**
# `_hero_side()` filters `dead`, and this loop deliberately does not — DH's own
# comment says so: *"a hero who has since DIED still opened the wound"*. Taking
# the suggested fix would have closed the companion gap and silently opened a
# second one, in the same shape and in the same loop. The union is written out.
#
# §2 IS SEEDED ON BOTH BLOWS OF THE COMPARED PAIR, which is DD's rule and
# `check_di` §2's idiom, inherited rather than re-derived.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dj.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The same four plain afflictions `check_di` §2 measures on, and deliberately
# the same: all in `DEBUFF_IDS`, none sticky, none on the boss immunity list, so
# `_harvest_yield` counts all four and `purge_debuffs` takes all four. The
# arithmetic is only honest if `hv_n` is identical in both arms.
const MIX := ["exposed", "sunder", "slow", "dazed"]

# §5's RATCHET — **RETIRED AT DK, AND THE REASON IS THE POINT.** DJ pinned all
# ELEVEN ally-worded effects that walk bare `heroes` by their own read lines,
# with a message telling the next batch to re-derive §2's table if one moved.
# **DK IS THAT BATCH.** It ruled on all eleven — four widened to `_hero_side()`
# and seven had their TEXT moved to "hero" — and `check_dk` §1 pins BOTH
# populations, in both directions, with messages that say which half broke.
#
# THE TABLE IS DELETED RATHER THAN UPDATED because keeping it would be a SECOND
# COPY of one fact in a second gate, which is this project's oldest recurring
# defect and the thing DJ's own §3 rule is about. The `is_companion` count below
# STAYS — that is DJ's own finding and no other gate asserts it.

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DJ — THE ALLY LOOP READS `companions` TOO")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src != "", "battle.gd is readable")
	_loop_collection(src)
	_sites_stamped(src)
	_sweep_ratchet(src)
	_prose()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	await _payout(a)
	await _driven(a)
	await _fallen(a)
	a.queue_free()

	_g.report(self)


# ── §1 — THE LOOP'S COLLECTION ──────────────────────────────────────────────
# READ OUT OF THE SOURCE, because the live measurement in §2 would also pass if
# somebody replaced the union with `_hero_side()` — the companion half would
# work and the fallen-hero half would quietly stop. §4 measures that half; this
# names it, so the two failures are told apart by WHICH check reds.
func _loop_collection(src: String) -> void:
	var at := src.find("for hv_h in ")
	ok(at >= 0, "Harvest's ally loop is still spelled `for hv_h in ...`")
	if at < 0:
		return
	var line := src.substr(at, src.find("\n", at) - at).strip_edges()
	print("  Harvest's ally loop: %s" % line)
	ok(not line.contains("_hero_side"),
		"Harvest's ally loop walks `_hero_side()`, which filters `dead` — a wound a FALLEN hero opened stops paying")
	# The union is hoisted above the status loop, so the loop reads the local.
	var built := src.find("var hv_party: Array = heroes + companions")
	ok(built >= 0,
		"the ally union is no longer built as `heroes + companions` — a loop over `heroes` alone excludes the beasts and reports nothing")
	ok(line.contains("hv_party"),
		"Harvest's ally loop no longer reads the hoisted union — it reads `%s`" % line)
	# AND THE BUILD SITE IS INSIDE HARVEST, not somewhere a later batch moved it.
	var harvest_at := src.find('"harvest":')
	ok(harvest_at >= 0 and built > harvest_at,
		"the ally union is built outside Harvest's handler")


# ── §2 — THE PAYOUT, ON A WOUND A REAL COMPANION STRIKE OPENED ──────────────
# `check_di` §4 measures this arithmetic off a HAND-STAMPED board and that is
# the right shape for the gate that OWNS the ruling's arithmetic. This one
# measures the PLUMBING with it: one of the four wounds is opened by driving
# `_companion_strike` the way the game drives it, so a handler that stops
# passing its source fails here even though the arithmetic still works.
func _payout(scene: Node) -> void:
	var bm := _beastmaster(scene)
	ok(bm != null, "the fixture fields a Beastmaster")
	if bm == null:
		return
	await scene._do_summon(bm, "aguila")
	var comps: Array = scene.get("companions")
	ok(comps.size() > 0, "the summon put a companion on the field")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]
	var party: Array = scene.get("heroes")
	# THE PREMISE, RE-ASSERTED HERE RATHER THAN INHERITED. If a later batch ever
	# does put companions in `heroes`, the union becomes a double-count and this
	# is the check that says so.
	ok(not party.has(comp),
		"`heroes` now carries the companion — the union double-counts and DJ's whole premise is stale")

	var harvest = _ability("Harvest")
	var caster := _hero_not(scene, comp)
	ok(harvest != null, "Harvest resolves out of the live corpus")
	ok(caster != null, "the fixture fields a hero to cast Harvest")
	if harvest == null or caster == null:
		return

	var self_dmg := await _arm(scene, caster, harvest, caster, null)
	var comp_dmg := await _arm(scene, caster, harvest, comp, null)
	var r := (float(comp_dmg) / float(self_dmg)) if self_dmg > 0 else 0.0
	print("  hand-stamped: self-opened %d, companion-opened %d — ratio %.4f" % [
		self_dmg, comp_dmg, r])
	ok(self_dmg > 0 and comp_dmg > 0, "both arms landed a Harvest")
	# THE SAME BAND `check_di` §2 GIVES A HERO, and deliberately the same: the
	# point of the ruling is that the clause can no longer tell the two apart.
	# A band admitting anything between 1.0 and 1.5 would pass with the fix half
	# applied, which is the state DI found the game in one layer up.
	ok(r > 1.48 and r < 1.52,
		"a companion-opened board pays %.4f of a self-opened one — the card's 18%%/12%% is 1.5" % r)

	# AND THE SAME MEASUREMENT WITH THE WOUND OPENED BY A REAL EAGLE STRIKE.
	# Three of the four afflictions are laid the same way in both arms; the
	# fourth — `exposed` — is opened by driving `_companion_strike`, so this arm
	# reds if that site stops passing `comp`.
	var struck := await _arm(scene, caster, harvest, caster, comp)
	var r2 := (float(struck) / float(self_dmg)) if self_dmg > 0 else 0.0
	print("  eagle-struck: %d against a self-opened %d — ratio %.4f" % [
		struck, self_dmg, r2])
	# One of four wounds is the ally's, so the rate is 0.12 + 0.06/4 = 0.135
	# against 0.12 — 1.125 exactly, and it cannot be 1.0 unless the strike
	# stamped nobody.
	ok(r2 > 1.11 and r2 < 1.14,
		"a wound a real eagle strike opened paid %.4f of a self-opened board — 1.0 means `_companion_strike` stamped nobody" % r2)


# One arm: clear the body, lay the mix, seed, cast. When `striker` is non-null
# the `exposed` in the mix is opened by a REAL companion strike instead of being
# stamped, so the arm measures the call site rather than the arithmetic.
func _arm(scene: Node, caster: BattleUnit, harvest, opener: BattleUnit,
		striker: BattleUnit) -> int:
	var foe := _foe(scene)
	if foe == null:
		return 0
	# A target that can never die, so neither arm can take a death branch the
	# other did not and desynchronise the stream.
	foe.max_hp = 100000000
	foe.hp = foe.max_hp
	foe.statuses.clear()
	# A LARGE ATTACK, so the band measures the term and not the integer
	# rounding — `check_di` §5's scar, inherited rather than re-learned. The
	# scale is applied in every arm and cancels out of every ratio.
	caster.attack = 5000
	for id in MIX:
		if striker != null and id == "exposed":
			await scene._companion_strike(striker, foe, 1.0, false)
		else:
			scene._apply_status(foe, id, 5, 0, 0, opener)
	ok(foe.statuses.size() == MIX.size(),
		"the board holds %d afflictions, not %d" % [foe.statuses.size(), MIX.size()])
	var before: int = foe.hp
	seed(20260823)
	await scene._resolve_special(caster, harvest, foe, "good", 1.0)
	return before - foe.hp


# ── §3 — THE SEVEN COMPANION CALL SITES ─────────────────────────────────────
# DI named all seven and left all seven, because stamping them without the loop
# fix would have made the sweep look complete while the wound still paid
# nothing. They are stamped now. Four are DRIVEN below; the other three are
# asserted off the source here, and **which is which is said rather than
# blurred** — a taunt encoded as `100 + index` needs a live board with the right
# beast standing on it, and a gate that pretends otherwise is a gate that
# asserts on nothing.
func _sites_stamped(src: String) -> void:
	var must := {
		"Guardian's Roar taunts the roarer, not nobody":
			'var gr_src: BattleUnit = body if body != null else hunter',
		"the bear's Bestial Wrath taunt names the bear":
			'_apply_status(bw_e, "mocked", 2, 100 + bw_idx,\n\t\t\t\t\t\t\t\t\t0, bw_comp)',
		"the eagle's dive Dazes in its own name":
			'_apply_status(d, "dazed", 2, 0, 0,\n\t\t\t\t\t\tbody if body != null else hunter)',
	}
	for what in must:
		ok(src.contains(must[what]), "%s — the site no longer passes a source" % what)


# The four that a live board can drive.
func _driven(scene: Node) -> void:
	var bm := _beastmaster(scene)
	if bm == null:
		return
	var comps: Array = scene.get("companions")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]

	# 1 — the eagle's strike lays Exposed, and Blinds while its Wrath rides.
	var f := _clean_foe(scene)
	await scene._companion_strike(comp, f, 1.0, false)
	_stamped(f, "exposed", comp, "the eagle's strike laid Exposed with no source")
	f = _clean_foe(scene)
	scene._apply_status(comp, "bestial", 3)
	await scene._companion_strike(comp, f, 1.0, false)
	_stamped(f, "blind", comp, "the eagle's Wrath Blind named nobody")

	# 2 — Kill Command's second Blind, driven as a real cast.
	var kc = _ability("Kill Command")
	ok(kc != null, "Kill Command resolves out of the live corpus")
	if kc != null:
		f = _clean_foe(scene)
		await scene._resolve_special(bm, kc, f, "good", 1.0)
		_stamped(f, "blind", comp, "Kill Command's Blind is the hunter's order and the EAGLE's work")

	# 3 — the arrival dive's Daze, driven through `_arrival_for_kind` with a
	# real body, which is the branch a summoned eagle takes.
	f = _clean_foe(scene)
	await scene._arrival_for_kind(bm, "aguila", comp, f)
	_stamped(f, "dazed", comp, "the arrival dive Dazed in nobody's name")


func _stamped(foe: BattleUnit, id: String, who: BattleUnit, why: String) -> void:
	var st: Dictionary = foe.get_status(id)
	ok(not st.is_empty(), "%s never landed, so its source cannot be read" % id)
	if st.is_empty():
		return
	ok(String(st.get("src_name", "")) == who.unit_name,
		"%s — `%s` reads `%s`, not `%s`" % [why, id, String(st.get("src_name", "")),
			who.unit_name])


# ── §4 — A FALLEN HERO'S WOUND STILL PAYS ───────────────────────────────────
# THE NEGATIVE CONTROL ON THE COLLECTION ITSELF. `_hero_side()` would have
# passed §2 and failed this, which is exactly why DI's proposed "one word" fix
# is not the one that shipped. Neither half of the union is filtered on `dead`,
# because a hero who has since fallen still opened the wound.
func _fallen(scene: Node) -> void:
	var harvest = _ability("Harvest")
	if harvest == null:
		return
	var bm := _beastmaster(scene)
	var caster := _hero_not(scene, bm)
	var opener := _hero_third(scene, caster, bm)
	ok(opener != null, "the fixture fields a third hero to open a wound and then fall")
	if caster == null or opener == null:
		return
	var alive_dmg := await _arm(scene, caster, harvest, opener, null)
	# He falls AFTER opening them. The statuses keep his name; the loop must
	# keep finding him.
	var was_hp: int = opener.hp
	opener.hp = 0
	opener.dead = true
	var dead_dmg := await _arm(scene, caster, harvest, opener, null)
	opener.dead = false
	opener.hp = was_hp
	var r := (float(dead_dmg) / float(alive_dmg)) if alive_dmg > 0 else 0.0
	print("  a FALLEN opener's board pays %.4f of a living one (1.0 = still paid)" % r)
	ok(r > 0.98 and r < 1.02,
		"a wound opened by a hero who has since fallen pays %.4f — the loop grew a `dead` filter" % r)


# ── §5 — THE SWEEP RATCHET ──────────────────────────────────────────────────
# DJ §2 swept every broad ally-worded effect and found ELEVEN whose read site
# walks bare `heroes`. **NOTHING IS RULED ON HERE AND NOTHING SHOULD BE**: an
# exclusion that is intended wants its TEXT corrected to say "hero", one that is
# accidental wants its CODE corrected, and the two look identical from inside a
# gate. What this asserts is that the population does not move in silence.
#
# IT COUNTS `is_companion` FILTERS OVER `heroes`, WHICH ARE ALL NO-OPS. CV §4
# recorded 23 nodes "shorted by an explicit `is_companion` filter"; the filters
# are real and every one of them is filtering an array that cannot hold a
# companion. They record INTENT, which is worth reading — they are simply not
# what does the excluding.
func _sweep_ratchet(src: String) -> void:
	var lines := src.split("\n")
	var walks := 0
	var filtered := 0
	for i in lines.size():
		var code: String = lines[i]
		var hash_at := code.find("#")
		if hash_at >= 0:
			code = code.substr(0, hash_at)
		if not code.contains("heroes"):
			continue
		if not (code.contains("for ") and code.contains(" in heroes")) \
				and not code.contains("heroes.filter"):
			continue
		# The statement, continuations included, so a filter split across lines
		# is read as one thing.
		var stmt := code
		var j := i
		while (stmt.strip_edges().ends_with("\\") \
				or stmt.count("(") > stmt.count(")")) and j + 1 < lines.size():
			j += 1
			var nxt: String = lines[j]
			var h2 := nxt.find("#")
			if h2 >= 0:
				nxt = nxt.substr(0, h2)
			stmt += " " + nxt
		walks += 1
		if stmt.contains("is_companion"):
			filtered += 1
	print("  `heroes` walks: %d, of which %d carry a no-op `is_companion` filter" % [
		walks, filtered])
	ok(filtered == 23,
		"the `is_companion`-over-`heroes` population is %d, not the 23 CV measured and DJ re-derived" % filtered)
	# **AND DK ASKED THE QUESTION THIS COUNT EXISTS FOR, AND THE ANSWER WAS
	# NONE.** DK widened four ally-worded read sites to `_hero_side()`, which
	# genuinely does hold companions — so a filter sitting on one of them would
	# have stopped being decoration and started removing a beast, and the
	# widening would have been a no-op wearing a fix's clothes. Not one of the
	# four carried an `is_companion` clause, and this count holding at 23 across
	# DK is how that is checkable rather than merely stated.
	print("  the eleven bare-`heroes` ally effects are ruled and pinned by `check_dk` §1 since DK")


# ── §6 — THE BELIEF IS GONE FROM THE LIVE PROSE ─────────────────────────────
# A COMMENT IS NOT EVIDENCE — CU's whole method — and this one was asserted in
# four live places at once, so correcting the loop without correcting them would
# leave the next batch reading the wrong thing in the rule file. The changelog
# and the batch reports are HISTORY and are deliberately not swept: they record
# what was believed when they were written.
func _prose() -> void:
	var live := {
		"res://CLAUDE.md": "CLAUDE.md",
		"res://docs/text-standard.html": "docs/text-standard.html",
		"res://docs/talent-audit.html": "docs/talent-audit.html",
	}
	for path in live:
		var txt := FileAccess.get_file_as_string(path)
		ok(txt != "", "%s is readable" % live[path])
		if txt == "":
			continue
		ok(not txt.contains("beast stands in `heroes`") \
				and not txt.contains("beast stands in <code>heroes</code>"),
			"%s still says a Beastmaster's beast stands in `heroes` — it does not" % live[path])
	# AND THE SOURCE COMMENT DH LEFT, which is the one DI quoted.
	var bg := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not bg.contains("`heroes` CARRIES THE COMPANIONS"),
		"battle.gd still asserts that `heroes` carries the companions")
	# THE COVERAGE FIGURE IS NOT RE-WRITTEN INTO THE COMMENT EITHER. It carried
	# "53 of 204" from DH through DI to DJ without ever being re-derived.
	ok(not bg.contains("53 of 204 single-line"),
		"battle.gd's Harvest comment quotes a coverage figure again — `check_di` §1 prints the live one")


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


func _hero_not(scene: Node, who: BattleUnit) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h != who:
			return h
	return null


func _hero_third(scene: Node, a: BattleUnit, b: BattleUnit) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h != a and h != b:
			return h
	return null


func _foe(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead:
			return e
	return null


func _clean_foe(scene: Node) -> BattleUnit:
	var f := _foe(scene)
	if f != null:
		f.max_hp = 100000000
		f.hp = f.max_hp
		f.statuses.clear()
	return f
