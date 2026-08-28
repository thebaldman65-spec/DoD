# BATCH DI — THE GATE FOR "A STATUS IS APPLIED WITH ITS `src`".
#
# DH §1 made Harvest pay MORE for a wound an ally opened, off the `src_name`
# `_apply_status` has stamped since Batch W. The clause was correct and the
# PLUMBING was not: most call sites never passed a source, so an unstamped
# status read as "not an ally's" and quietly paid the base rate. **The
# under-payment was invisible by construction** — an unstamped status and one
# the Survivalist laid himself are the same thing to that loop — which is why
# this gate exists rather than a line in a report.
#
# FOUR SECTIONS, AND §2 IS THE ONE THAT COULD FAIL FOR A REAL REASON:
#   §1  the coverage RATCHET, counted out of `battle.gd`'s own text
#   §2  the payout, ally-opened versus self-opened, on a SEEDED pair
#   §3  the call sites themselves, driven through real casts
#   §4  the companion gap DI FOUND AND DELIBERATELY DID NOT CLOSE
#
# §2 IS SEEDED ON BOTH BLOWS OF THE COMPARED PAIR, which is DD's rule and the
# repair `test_batch_at`'s §1 ratio still owes. Harvest rolls `randf_range(0.9,
# 1.1)` on its damage, so an unseeded ally-versus-self comparison would be two
# populations differing in the roll as well as in the term being measured. Both
# arms draw the SAME stream, so the ratio is the pct ratio and nothing else.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_di.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The floor the last batch to touch it leaves behind. A ratchet, not an
# equality: a later batch widening the sweep must not trip this, but one that
# DELETES a `src` must. **DI left it at 99; DJ stamped the seven companion
# sites and left it at 106.**
const SRC_FLOOR := 106
# BATCH DP MOVED THIS BY ONE, AND THE MOVEMENT IS A COVERAGE IMPROVEMENT.
# The re-pointed Spread of Madness deleted `_apply_status(infected,
# "psychosis", 3)` — a site that carried NO source — so the population is
# 203 and the unstamped remainder is 97 rather than 98. `with_src` did not
# move: it is still 106, and SRC_FLOOR still holds it.
#
# **THIS EQUALITY IS THE ONE ASSERTION IN THIS FILE THAT IS A NUMBER RATHER
# THAN A PROPERTY, AND IT EARNED ITS KEEP HERE** — it is a tripwire saying
# "the population this gate was written against has moved, come and look",
# and DP's battery is exactly the case it exists for. Its sibling three
# lines up is deliberately a RATCHET (`with_src >= SRC_FLOOR`) because that
# one measures progress; this one measures the ground the progress is
# against. **A batch that changes it must say why, here, in this comment.**
#
# **BATCH DR MOVED IT 203 -> 205, AND SAYS WHY.** Net +2, from four sites:
# `flash_freeze`'s `_apply_status(target, "chilled", 3, 0, 0, attacker)` went
# with the retired card (§2, a STAMPED site — so the denominator fell and
# `with_src` fell with it), and §4's three new ones arrived — Wheeling Cut's
# two arriving-stance grants and Counter Time's Stun.
#
# **`with_src` DID NOT MOVE AND THAT IS ARITHMETIC RATHER THAN LUCK.** Counter
# Time passes `attacker` (DI's rule: a status is applied with its `src`), and
# it exactly replaces the stamped site the retirement took. The two Wheeling
# Cut grants are SELF-BUFFS on the hero — nothing Harvest reads, nothing
# `_note_debuff_applied` counts — so they are correctly unstamped and the
# unstamped remainder goes 97 -> 99.
const CALL_SITES := 205

# Four plain afflictions: all in `DEBUFF_IDS`, none sticky, none on the boss
# immunity list, so `_harvest_yield` counts all four and `purge_debuffs` takes
# all four. The arithmetic is only honest if `hv_n` is the same in both arms.
const MIX := ["exposed", "sunder", "slow", "dazed"]

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DI — `src` WHERE HARVEST READS IT")

	_coverage()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"mystic"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	_payout(a)
	_call_sites(a)
	a.queue_free()

	var b: Node = await Gate.spawn(self, ["warden", "pyromancer", "occultist",
		"beastmaster"], {"deterministic": true})
	await _companions(b)
	b.queue_free()

	_g.report(self)


# ── §1 — THE COVERAGE RATCHET ───────────────────────────────────────────────
# COUNTED WITH A BALANCED-PAREN WALK AND NOT A `grep`, because the recorded
# figure this batch inherited — 53 of 204 — WAS a grep, and it was wrong. It
# only ever saw calls that closed on the line they opened on; 25 of the 204 do
# not, and twelve of those already passed a source. The real coverage before DI
# was 63, not 53. A one-line count cannot see a call that wraps, so this walks.
func _coverage() -> void:
	var txt := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(txt != "", "battle.gd is readable")
	var sites := 0
	var with_src := 0
	var null_src := 0
	var i := txt.find("_apply_status(")
	while i >= 0:
		var open_at := i + "_apply_status".length()
		# The declaration is not a call site.
		var head := txt.substr(open_at, 24)
		if head.begins_with("(target: BattleUnit"):
			i = txt.find("_apply_status(", open_at)
			continue
		# A COMMENT THAT NAMES THE FUNCTION IS NOT A CALL SITE, and two of them
		# do. This is the same fault one layer down as the grep that produced
		# the 53: a text measurement that does not know what it is looking at.
		if _in_comment(txt, i):
			i = txt.find("_apply_status(", open_at)
			continue
		var args := _args_of(txt, open_at)
		sites += 1
		if args.size() >= 6:
			if args[5].strip_edges() == "null":
				null_src += 1
			else:
				with_src += 1
		i = txt.find("_apply_status(", open_at)
	print("  _apply_status call sites: %d — %d carry a source, %d do not" % [
		sites, with_src, sites - with_src])
	ok(sites == CALL_SITES,
		"the call-site population is %d, not the %d this gate was written against" % [
			sites, CALL_SITES])
	ok(with_src >= SRC_FLOOR,
		"`src` coverage fell to %d of %d — DI left it at %d" % [
			with_src, sites, SRC_FLOOR])
	# A site that passes `null` is worse than one that omits the argument: it
	# reads as deliberate. DI emptied that population and it stays empty.
	ok(null_src == 0,
		"%d call site(s) pass an explicit `null` source" % null_src)


# Is this occurrence inside a `#` comment? Walks back to the line start and
# reports whether a `#` stands before it outside of a string.
func _in_comment(txt: String, at: int) -> bool:
	var j := at
	while j > 0 and txt[j - 1] != "\n":
		j -= 1
	var in_str := false
	while j < at:
		var c := txt[j]
		if c == '"':
			in_str = not in_str
		elif c == "#" and not in_str:
			return true
		j += 1
	return false


# Split one call's arguments at depth zero. Strings are tracked so a comma
# inside a status description cannot be read as an argument break.
func _args_of(txt: String, open_at: int) -> Array:
	var depth := 0
	var in_str := false
	var cur := ""
	var out: Array = []
	var j := open_at
	while j < txt.length():
		var c := txt[j]
		if c == '"':
			in_str = not in_str
		if not in_str:
			if c == "(" or c == "[" or c == "{":
				depth += 1
				if depth == 1:
					j += 1
					continue
			elif c == ")" or c == "]" or c == "}":
				depth -= 1
				if depth == 0:
					if cur.strip_edges() != "":
						out.append(cur)
					return out
			elif c == "," and depth == 1:
				out.append(cur)
				cur = ""
				j += 1
				continue
		cur += c
		j += 1
	return out


# ── §2 — THE PAYOUT, ALLY-OPENED VERSUS SELF-OPENED ─────────────────────────
# THE POINT OF THE WHOLE BATCH, MEASURED. Same target, same four afflictions,
# same purge count, same RNG stream — the ONLY difference is whose name is on
# the statuses. The card promises 12% a status rising to 18% when the whole
# board is the party's work, so the arms must stand at exactly 1.5.
func _payout(scene: Node) -> void:
	var surv := _hero(scene, "trapper")
	var ally := _hero_not(scene, surv)
	ok(surv != null, "the fixture fields a Survivalist to cast Harvest")
	ok(ally != null, "the fixture fields an ally to open wounds")
	if surv == null or ally == null:
		return
	var harvest = _ability("Harvest")
	ok(harvest != null, "Harvest resolves out of the live corpus")
	if harvest == null:
		return

	var self_dmg := await _arm(scene, surv, harvest, surv)
	var ally_dmg := await _arm(scene, surv, harvest, ally)
	print("  Harvest on a board of %d: self-opened %d damage, ally-opened %d" % [
		MIX.size(), self_dmg, ally_dmg])
	ok(self_dmg > 0 and ally_dmg > 0, "both arms landed a Harvest")
	if self_dmg <= 0:
		return
	var ratio := float(ally_dmg) / float(self_dmg)
	print("  ratio %.4f (the card's 18%%/12%% is 1.5)" % ratio)
	# THE BAND IS TIGHT ON PURPOSE. Both arms are seeded identically, so the
	# only slack is the integer rounding of two damage numbers in the hundreds.
	# A WIDE band here would pass with the bonus half-applied, which is the
	# state DI found the game in.
	ok(ratio > 1.48 and ratio < 1.52,
		"ally-opened Harvest paid %.4f of self-opened, not the card's 1.5" % ratio)
	# THE NEGATIVE HALF: a self-opened board must NOT pay the bonus. Without
	# this the check above would pass just as well if every status paid 18%.
	var self_again := await _arm(scene, surv, harvest, surv)
	var flat := float(self_again) / float(self_dmg)
	ok(flat > 0.98 and flat < 1.02,
		"two self-opened arms differ by %.4f — the seed is not holding" % flat)
	# AND THE SOURCE HAS TO BE RESOLVED AGAINST THE PARTY, NOT MERELY COMPARED
	# TO THE CASTER'S OWN NAME. A debuff one ENEMY laid on another carries a
	# `src_name` too, and reading it as the party's work is the mis-credit DH's
	# own comment warns about.
	var foe := _foe(scene)
	var other_foe := _other_foe(scene, foe)
	if other_foe != null:
		var enemy_dmg := await _arm(scene, surv, harvest, other_foe)
		var enemy_ratio := float(enemy_dmg) / float(self_dmg)
		ok(enemy_ratio > 0.98 and enemy_ratio < 1.02,
			"an ENEMY's debuff on another enemy paid %.4f — it is being read as the party's work" % enemy_ratio)


# One arm: clear the body, lay the mix stamped to `opener`, seed, cast.
func _arm(scene: Node, caster: BattleUnit, harvest, opener: BattleUnit) -> int:
	var foe := _foe(scene)
	if foe == null:
		return 0
	# A target that can never die, so neither arm can take a death branch the
	# other did not and desynchronise the stream.
	foe.max_hp = 100000000
	foe.hp = foe.max_hp
	foe.statuses.clear()
	# A LARGE ATTACK, SO THE BAND MEASURES THE TERM AND NOT THE ROUNDING. At the
	# fixture's own Attack the two arms land on 37 and 55, where a single point
	# of integer rounding is 2.7% of the ratio — most of the band's width. The
	# scale is applied to BOTH arms and cancels out of the ratio entirely.
	caster.attack = 5000
	for id in MIX:
		scene._apply_status(foe, id, 5, 0, 0, opener)
	ok(foe.statuses.size() == MIX.size(),
		"the board holds %d afflictions, not %d" % [foe.statuses.size(), MIX.size()])
	var before: int = foe.hp
	seed(20260822)
	await scene._resolve_special(caster, harvest, foe, "good", 1.0)
	return before - foe.hp


# ── §3 — THE CALL SITES ─────────────────────────────────────────────────────
# §2 proves the ARITHMETIC. This proves the PLUMBING, which is what DI actually
# changed: each of these is a site that stamped nothing before this batch, and
# each is driven the way the game drives it rather than by calling
# `_apply_status` directly, so a handler that stops passing its source fails
# here even though the arithmetic still works.
func _call_sites(scene: Node) -> void:
	var occ := _hero(scene, "old_gods")
	var pyro := _hero(scene, "overburn")
	var surv := _hero(scene, "trapper")

	# The two sites that passed an explicit `null` until DI, and both had the
	# real source sitting in their own signature already.
	if occ != null:
		var f := _clean_foe(scene)
		scene._hold_freeze(f, occ)
		_stamped(f, "frozen", occ, "_hold_freeze discarded the `src` in its own signature")
		f = _clean_foe(scene)
		scene._apply_poison(occ, f, 3)
		_stamped(f, "poison", occ, "_apply_poison discarded the `src` in its own signature")
	if surv != null:
		var f2 := _clean_foe(scene)
		scene._spring_trap(surv, f2, 0.0)
		_stamped(f2, "stunned", surv, "the trap's Stun named nobody")

	# Real casts through `_resolve_special`, one per spec that owns one.
	if occ != null:
		await _cast(scene, occ, "Bewitch", "bewitch")
		await _cast(scene, occ, "Umbral Sigil", "umbral_sigil")
		await _cast(scene, occ, "Mass Hysteria", "hysteria")
	if pyro != null:
		await _cast(scene, pyro, "Slow Burn", "slow_burn")
	if surv != null:
		await _cast(scene, surv, "Snare Trap", "snared")


func _cast(scene: Node, caster: BattleUnit, name: String, id: String) -> void:
	var ab = _ability(name)
	ok(ab != null, "%s resolves out of the live corpus" % name)
	if ab == null:
		return
	var f := _clean_foe(scene)
	await scene._resolve_special(caster, ab, f, "good", 1.0)
	_stamped(f, id, caster, "%s laid %s with no source" % [name, id])


func _stamped(foe: BattleUnit, id: String, who: BattleUnit, why: String) -> void:
	var st: Dictionary = foe.get_status(id)
	ok(not st.is_empty(), "%s never landed, so its source cannot be read" % id)
	if st.is_empty():
		return
	ok(String(st.get("src_name", "")) == who.unit_name,
		"%s — `%s` reads `%s`" % [why, id, String(st.get("src_name", ""))])


# ── §4 — THE COMPANION GAP, FOUND AT DI AND CLOSED AT DJ ───────────────────
# DH's Harvest comment stated: *"`heroes` CARRIES THE COMPANIONS, which is
# correct rather than incidental: Aguila's Exposed is the Beastmaster's work."*
# **IT DOES NOT.** `heroes.append` is reached at exactly ONE site — the party
# spawn — and a companion is appended to `companions`.
#
# DI ASSERTED THE GAP RATHER THAN CLOSING IT, because closing it moves a
# magnitude and DI's brief forbade that. **BATCH DJ RULED ON IT**: Harvest's
# ally loop now walks `heroes + companions`, and the seven companion call sites
# are stamped. **THIS SECTION IS WHAT CHANGED, WHICH IS WHY IT WAS WRITTEN THIS
# WAY** — the belief was already asserted, so the ruling cost an assertion
# rather than a discovery.
#
# THE FIRST TWO ASSERTIONS DID NOT MOVE and must not: `heroes` still does not
# hold the companion and `_hero_side()` still does. **What moved is the third,
# from 1.0 (paying nothing) to 1.5 (paying what a hero's wound pays).**
func _companions(scene: Node) -> void:
	var bm := _hero(scene, "pack_bond")
	if bm == null:
		bm = _hero_with_beasts(scene)
	ok(bm != null, "the second fixture fields a Beastmaster")
	if bm == null:
		return
	await scene._do_summon(bm, "aguila")
	var comps: Array = scene.get("companions")
	ok(comps.size() > 0, "the summon put a companion on the field")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]
	var party: Array = scene.get("heroes")
	ok(not party.has(comp),
		"`heroes` now carries the companion — DH's comment has become true and §4's assertion is stale")
	ok(scene._hero_side().has(comp),
		"`_hero_side()` is the union and must still reach the companion")
	# And the consequence, measured rather than argued. BEFORE DJ this read
	# 1.0000 — a companion-stamped affliction paid nothing at all, which is why
	# DI left the seven companion sites unstamped rather than stamping them and
	# calling the sweep complete. It now pays what a HERO's wound pays.
	var harvest = _ability("Harvest")
	var caster := _hero_not(scene, comp)
	if harvest == null or caster == null:
		return
	var self_dmg := await _arm(scene, caster, harvest, caster)
	var comp_dmg := await _arm(scene, caster, harvest, comp)
	var r := float(comp_dmg) / float(self_dmg) if self_dmg > 0 else 0.0
	print("  a companion-opened board pays %.4f of a self-opened one (1.0 = nothing, 1.5 = a hero's)" % r)
	# THE SAME BAND §2 USES FOR A HERO, and deliberately the same: the point of
	# the ruling is that the two are now indistinguishable to the clause. A band
	# that admitted anything between 1.0 and 1.5 would pass with the fix half
	# applied — the exact state DI found the game in one layer up.
	ok(r > 1.48 and r < 1.52,
		"a companion-opened wound pays %.4f of a self-opened one — DJ ruled it should pay a hero's 1.5" % r)


# ── helpers ────────────────────────────────────────────────────────────────

func _ability(name: String):
	for ab in Classes.ability_corpus():
		if ab.display_name == name:
			return ab
	return null


func _hero(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.passive_id == passive:
			return h
	return null


func _hero_with_beasts(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.hero_key == "hunter":
			return h
	return null


func _hero_not(scene: Node, who: BattleUnit) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h != who:
			return h
	return null


func _foe(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead:
			return e
	return null


func _other_foe(scene: Node, first: BattleUnit) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead and e != first:
			return e
	return null


func _clean_foe(scene: Node) -> BattleUnit:
	var f := _foe(scene)
	if f != null:
		f.max_hp = 100000000
		f.hp = f.max_hp
		f.statuses.clear()
	return f
