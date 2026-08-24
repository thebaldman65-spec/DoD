# BATCH DM — THE GATE FOR "SIX CARDS, FIFTEEN CLAUSES, AND THE UNIT OF A RULING
# IS THE CLAUSE".
#
# DL closed Rallying Shout and listed six more cards carrying clauses of two
# different shapes under one word. **THIS GATE READS ALL SIX CLAUSE BY CLAUSE
# AND PINS EVERY CLAUSE BY ITS OWN READ LINE**, which is the thing that was
# missing when Rallying Shout survived two sweeps: DJ §2 and DK §2 both read the
# ABILITY, found one clause, ruled on it, and moved on satisfied.
#
# THE SIX ARE SIXTEEN CLAUSES — Bulwark 4, Consecrated Ground 3, Divine Wrath 2,
# Battle Shout 1 group + 1 self, Hold the Line 2 group + 1 self, Sacred Resolve
# 2. **FOURTEEN CARRY A COLLECTION AND ALL FOURTEEN WERE ALREADY CORRECT.**
#
# **ONLY TWO CLAUSES ACTUALLY MIS-SAID ANYTHING AND BOTH WERE TEXT, NOT CODE.**
# Battle Shout's "+5 Rage" sat inside "A roar every hero answers:" and is paid
# to exactly one unit; Hold the Line's no-death window said "for a turn" against
# the 2 the code applies, because CV §1 moved the NODE text and missed the
# `description` inside that node's own payload. Everything else on the six
# agrees with its read site, and this gate records WHY for each — a word without
# its reason is re-litigated, which is how this thread reached nine batches.
#
# FIVE SECTIONS:
#   §1  THE CLAUSES, each pinned by its own read line, walk and all
#   §2  THE RECEIPTS, on a REAL SUMMONED BEAST — every reason MEASURED
#   §3  THE NEGATIVE CONTROLS on the two clauses this batch moved
#   §4  THE SIX CARDS' WORDS, and the four prose surfaces DM corrected
#   §5  THE THREAD IS CLOSED, and the rule that closed it is written down
#
# **WHY §1 SEARCHES BACKWARD FROM THE CLAUSE AND NOT FORWARD FROM THE WALK.**
# DL's forward `find` on a short fragment silently measured War Stomp's site
# 200k characters earlier in the file, and two of `check_dk`'s pins matched two
# loops each. Bulwark and Consecrated Ground share a walk fragment BYTE FOR BYTE
# — `heroes.filter(func(he): return not he.dead and not he.is_companion)`, and so do
# THREE more sites: FIVE in all, so a forward search reads the wrong one four
# times in five. **The CLAUSE line is the
# unique half, so it is the anchor**, and the walk is found by `rfind` from
# there. That is the instrument this batch's whole finding demands: you cannot
# pin a clause from a fragment that names the card.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dm.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# ── §1's TABLE ──────────────────────────────────────────────────────────────
# [label, CLAUSE line (the unique anchor), the WALK above it, the largest gap
# allowed between them]. The gap is what makes it a pin on the CLAUSE rather
# than on the neighbourhood: a clause lifted out of its loop moves past it.
const CLAUSES := [
	["Bulwark of Fortitude — the three receivable clauses share ONE collection",
		"_apply_status(h, \"bulwark\", bw_turns)",
		"for h in heroes.filter(func(he): return not he.dead and not he.is_companion):", 120],
	["Consecrated Ground — mitigation and reflect, the same one collection",
		"_apply_status(h, \"cons_ground\", 3, 0, 0, attacker)",
		"for h in heroes.filter(func(he): return not he.dead and not he.is_companion):", 120],
	["Divine Wrath — one apply for BOTH of its clauses",
		"_apply_status(h, \"wrath\", 4)",
		"for h in heroes.filter(func(he): return not he.dead):", 120],
	["Sacred Resolve — the split's apply",
		"_apply_status(h, \"unity\", res_turns)",
		"for h in heroes.filter(func(he): return not he.dead):", 120],
	["Battle Shout — the GROUP clause",
		"_apply_status(h, \"battle_shout\", shout_turns, shout_pct)",
		"for h in heroes:", 1400],
	["Hold the Line — the `undying` clause, which `check_dk`'s pin does NOT cover",
		"_apply_status(h, \"undying\", hl_undying)",
		"for h in _hero_side():", 1400],
]

# THE SELF CLAUSES. Two cards hand the CASTER five Rage and neither payload is
# reachable from the group walk above it — which is exactly the disagreement
# Battle Shout's card carried. Each is anchored on the unique line that ENDS its
# group clause, and the self line must follow inside the gap.
const SELF_CLAUSES := [
	["Battle Shout — the SELF clause (this is the one DM's text moved)",
		"shout_n += 1",
		"attacker.resource = mini(attacker.resource + 5, attacker.max_resource)", 1400],
	["Hold the Line — the SELF clause, which its card already worded correctly",
		"_apply_status(h, \"undying\", hl_undying)",
		"attacker.resource = mini(attacker.resource + 5, attacker.max_resource)", 1400],
]

# THE CLAUSES THAT ARE NARROW BY STRUCTURE RATHER THAN BY COLLECTION, each
# pinned by the line that IS the structure. **A per-turn clause has no walk to
# pin** — its exclusion lives in `_next_unit()`, one function away — so pinning
# its own loop would pin nothing.
const STRUCTURE := {
	"the per-turn walk a companion is never in (Bulwark's regen, the Faith drip, Cleansing Waters)":
		"var alive := (heroes + enemies).filter(func(u): return not u.dead)",
	"Bulwark of Fortitude — the 10%-a-turn regen, INSIDE the turn-start block":
		"if u.has_status(\"bulwark\"):\n\t\t\tvar bw_amt := maxi(int(round(u.max_hp * 0.10)), 1)",
	"Consecrated Ground — the Faith kindle, refused a SECOND time by `_gain_faith`":
		"if devout == null or u.dead or u.is_companion or not u.is_hero:",
	"Divine Wrath — the damage term, in the hero strike loop `_companion_hit` never enters":
		"if attacker.has_status(\"wrath\"):\n\t\t\t\traw *= 1.15",
	"Battle Shout — the damage term, the same loop and the same reason":
		"raw *= 1.0 + attacker.status_power(\"battle_shout\") / 100.0",
	"Sacred Resolve — the strike split gates AGAIN on is_hero and not is_companion":
		"if strike_target.is_hero and not strike_target.is_companion \\\n\t\t\t\t\tand strike_target.has_status(\"unity\"):",
	"Sacred Resolve — and so does the bleedout split":
		"if victim.is_hero and not victim.is_companion and victim.has_status(\"unity\"):",
}

# Divine Wrath's second clause is read in `unit.gd`, not `battle.gd`.
const SPEED_TERM := "if has_status(\"wrath\"):\n\t\ts *= 1.15"

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DM — THE SIX SPLIT-CLAUSE CARDS, CLAUSE BY CLAUSE")

	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(src != "" and usrc != "", "battle.gd and unit.gd are readable")
	_pins(src, usrc)
	_texts()
	_closed()

	var a: Node = await Gate.spawn(self, ["warden", "pyromancer", "inquisitor",
		"beastmaster"], {"deterministic": true})
	ok(Gate.flags_are_inert(a), "the fixture is headless, so no bot mix is measured")
	await _receipts(a)
	a.queue_free()

	_g.report(self)


# ── §1 — EVERY CLAUSE, BY ITS OWN READ LINE ─────────────────────────────────
func _pins(src: String, usrc: String) -> void:
	for row in CLAUSES:
		_clause_in_walk(src, row[0], row[1], row[2], int(row[3]), true)
	for row in SELF_CLAUSES:
		_clause_in_walk(src, row[0], row[1], row[2], int(row[3]), false)
	for what in STRUCTURE:
		ok(src.contains(STRUCTURE[what]),
			"the line that keeps this clause narrow has moved: %s" % what)
	ok(usrc.contains(SPEED_TERM),
		"Divine Wrath's SPEED term left `unit.effective_speed()` — the clause's second reason is gone")
	# **THE SHARED WALK IS STILL SHARED, AND THE LIVE COUNT IS PRINTED RATHER
	# THAN WRITTEN DOWN** — DJ's second standing rule. This gate's first run
	# asserted TWO, because two is how many of them this batch was looking at;
	# there are FIVE, so a forward `find` from this fragment reads the wrong
	# site four times in five. **The assertion is `> 1`, which is the property
	# the anchor choice actually rests on**, and a hard count here would red on
	# any unrelated new caller without telling anyone anything.
	var shared := _count(src, "for h in heroes.filter(func(he): return not he.dead and not he.is_companion):")
	print("  SHARED WALK  %d sites spell `heroes.filter(not dead and not is_companion)` identically" % shared)
	ok(shared > 1,
		"that walk is unique now (%d site) — §1 anchors on the clause BECAUSE the walk is shared, so the reasoning needs re-taking" % shared)


# Anchor on the CLAUSE (unique), then look for its WALK. `backward` searches up
# from the clause, which is what a group walk needs; a self clause is BELOW the
# line that anchors it, so it searches down.
func _clause_in_walk(src: String, label: String, anchor: String, other: String,
		gap: int, backward: bool) -> void:
	var at := src.find(anchor)
	ok(at >= 0, "the clause line itself is gone: %s" % label)
	if at < 0:
		return
	ok(src.find(anchor, at + 1) < 0,
		"the clause line is no longer unique, so this pin cannot name one clause: %s" % label)
	var found := src.rfind(other, at) if backward else src.find(other, at)
	ok(found >= 0 and absi(at - found) <= gap,
		"%s — its own read line is %d characters from the clause (gap %d)" % [
			label, absi(at - found) if found >= 0 else -1, gap])


func _count(hay: String, needle: String) -> int:
	var n := 0
	var at := hay.find(needle)
	while at >= 0:
		n += 1
		at = hay.find(needle, at + 1)
	return n


# ── §2/§3 — THE RECEIPTS, ON A REAL SUMMONED BEAST ──────────────────────────
func _receipts(scene: Node) -> void:
	var bm := _hero(scene, "hunter")
	var wd := _hero(scene, "warrior")
	var dv := _hero(scene, "cleric")
	ok(bm != null and wd != null and dv != null,
		"the fixture fields a Beastmaster, a Warden and a Devout")
	if bm == null or wd == null or dv == null:
		return
	await scene._do_summon(bm, "ursus")
	var comps: Array = scene.get("companions")
	ok(comps.size() > 0, "the summon put a companion on the field")
	if comps.is_empty():
		return
	var comp: BattleUnit = comps[0]
	# THE PREMISE, RE-ASSERTED RATHER THAN INHERITED (DJ's idiom, DK's and DL's
	# copies). Every measurement below is worthless if a companion is in
	# `heroes`, because then the narrow walks were never narrow.
	ok(not scene.get("heroes").has(comp),
		"`heroes` now carries the companion — every `heroes` walk on the six is reaching one, and DM's premise is stale")

	# ── THE PER-TURN REASON, WHICH TWO OF THE SIX DEPEND ON ─────────────────
	ok(comp.next_time == INF,
		"the summon's `next_time` is %f rather than INF — a companion may take turns now, so Bulwark's regen and the Faith drip must be re-ruled" % comp.next_time)
	ok(not (scene.get("heroes") + scene.get("enemies")).has(comp),
		"`_next_unit()`'s walk now reaches the companion — the per-turn rulings on the six are stale")

	# ── THE FAITH REASON, MEASURED IN BOTH DIRECTIONS ───────────────────────
	comp.faith_stacks = 0
	dv.faith_stacks = 0
	scene._gain_faith(comp, 2, "dm")
	scene._gain_faith(dv, 2, "dm")
	print("  FAITH     beast %d stacks, Devout %d, off the same call" % [
		comp.faith_stacks, dv.faith_stacks])
	ok(comp.faith_stacks == 0,
		"`_gain_faith` paid the beast %d stacks — Consecrated Ground's Faith clause can say `ally` now" % comp.faith_stacks)
	ok(dv.faith_stacks > 0,
		"`_gain_faith` paid a HERO nothing either, so the beast's zero measures a broken call rather than the refusal")

	# ── THE STRIKE-LOOP REASON, TWICE: two chips, two no-ops ────────────────
	var foe := _foe(scene)
	ok(foe != null, "the fixture fields a foe for the beast to strike")
	if foe != null:
		foe.max_hp = 100000000
		foe.hp = foe.max_hp
		foe.statuses.clear()
		comp.attack = 5000
		await _no_op_chip(scene, comp, foe, "wrath", "Divine Wrath's +15% damage")
		await _no_op_chip(scene, comp, foe, "battle_shout", "Battle Shout's +12% damage")

	# ── THE SIX CARDS, CAST ─────────────────────────────────────────────────
	await _cast_narrow(scene, dv, comp, "Bulwark of Fortitude", "bulwark")
	await _cast_narrow(scene, dv, comp, "Consecrated Ground", "cons_ground")
	await _cast_narrow(scene, dv, comp, "Divine Wrath", "wrath")
	await _cast_narrow(scene, dv, comp, "Sacred Resolve", "unity")
	await _cast_narrow(scene, wd, comp, "Battle Shout", "battle_shout")

	# ── AND THE ONE CLAUSE ON THE SIX THAT IS `ally` AND IS NOT PINNED
	#    ANYWHERE ELSE: Hold the Line's no-death window. DK measured the Break
	#    cut on this same beast; nothing has ever measured this half.
	var hold = _ability("Hold the Line")
	ok(hold != null, "Hold the Line resolves out of the live corpus")
	if hold != null:
		comp.statuses.clear()
		comp.dead = false
		comp.hp = comp.max_hp
		await scene._resolve_special(wd, hold, wd, "good", 1.0)
		ok(comp.has_status("undying"),
			"Hold the Line's no-death window did not reach the beast — the card says `ally` and the clause pays four")
		var lethal: int = comp.max_hp * 10
		comp.take_hit(lethal, 0)
		print("  UNDYING   beast at %d HP after a %d blow (dead=%s)" % [
			comp.hp, lethal, str(comp.dead)])
		ok(comp.hp == 1 and not comp.dead,
			"the held beast died to a lethal blow at %d HP — `undying` attaches and pays nothing, so the clause is a no-op like Tank and Spank's" % comp.hp)

	# ── THE CLAUSE DM's TEXT MOVED, MEASURED: ONE BODY GAINS THE RAGE ───────
	comp.statuses.clear()
	comp.dead = false
	comp.hp = comp.max_hp
	var shout = _ability("Battle Shout")
	ok(shout != null, "Battle Shout resolves out of the live corpus")
	if shout != null:
		for h in scene.get("heroes"):
			h.resource = 0
		comp.resource = 0
		wd.resource = 0
		await scene._resolve_special(wd, shout, wd, "good", 1.0)
		var paid: Array = []
		for h in scene.get("heroes"):
			if h.resource > 0:
				paid.append(h.unit_name)
		print("  BATTLE SHOUT  caster +%d Rage; units paid: %s; beast %d" % [
			wd.resource, str(paid), comp.resource])
		ok(wd.resource == 5,
			"the caster banked %d rather than 5 Rage — the card's `Refunds 5 Rage.` clause does not match its payload" % wd.resource)
		ok(paid.size() == 1,
			"%d units gained Rage off one shout — the clause the card calls a REFUND is reaching a group" % paid.size())
		ok(comp.resource == 0,
			"the beast banked %d resource off Battle Shout" % comp.resource)


# A chip that ATTACHES to a beast and moves none of its damage. This is DK §4's
# instrument pointed at two more statuses: a ruling of the form "we left this
# narrow BECAUSE widening it would pay nothing" is a claim about a damage path,
# and a claim about a damage path rots.
func _no_op_chip(scene: Node, comp: BattleUnit, foe: BattleUnit, id: String,
		label: String) -> void:
	comp.statuses.clear()
	comp.dead = false
	comp.hp = comp.max_hp
	var plain := await _blows(scene, comp, foe)
	var info: Array = scene.STATUS_INFO[id]
	comp.add_status(id, info[0], info[1], info[2], 99, info[3])
	comp.update_status(id, "+50%", "measured by check_dm", 50)
	ok(comp.has_status(id),
		"the beast will not hold `%s`, so this measurement is of nothing" % id)
	var chipped := await _blows(scene, comp, foe)
	var r := (float(chipped) / float(plain)) if plain > 0 else 0.0
	print("  %-14s 40 seeded beast blows: %d plain, %d chipped — ratio %.4f" % [
		id, plain, chipped, r])
	ok(plain > 0 and chipped > 0, "both arms of the `%s` measurement landed blows" % id)
	ok(r > 0.999 and r < 1.001,
		"%s now moves a beast's damage (ratio %.4f) — `_companion_hit` has grown a read site, so DM's recorded reason for this clause must be re-taken" % [label, r])
	comp.statuses.clear()


# Forty seeded blows down the companion damage path. Both arms take the same
# seed, so the only difference between them is the chip.
func _blows(scene: Node, comp: BattleUnit, foe: BattleUnit) -> int:
	var total := 0
	seed(20260825)
	for _i in 40:
		var before: int = foe.hp
		await scene._companion_hit(comp, foe, 0.20 * comp.attack, 0)
		total += before - foe.hp
	return total


# Cast one of the six and assert the beast is NOT wearing what it grants. The
# caster IS, which is what stops this measuring a cast that did nothing.
func _cast_narrow(scene: Node, caster: BattleUnit, comp: BattleUnit,
		name: String, id: String) -> void:
	var ab = _ability(name)
	ok(ab != null, "%s resolves out of the live corpus" % name)
	if ab == null:
		return
	comp.statuses.clear()
	comp.dead = false
	comp.hp = comp.max_hp
	caster.statuses.clear()
	await scene._resolve_special(caster, ab, caster, "good", 1.0)
	ok(caster.has_status(id),
		"%s did not even reach its own caster, so `%s` on the beast measures nothing" % [name, id])
	ok(not comp.has_status(id),
		"%s put `%s` on the companion — its card says HERO and its collection has widened" % [name, id])


# ── §4 — THE SIX CARDS' WORDS, AND THE FOUR SURFACES DM CORRECTED ───────────
func _texts() -> void:
	var tal := FileAccess.get_file_as_string("res://scripts/talents.gd")
	var cls := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var mas := FileAccess.get_file_as_string("res://docs/master.html")
	var glo := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(tal != "" and cls != "" and mas != "" and glo != "",
		"talents.gd, classes.gd, master.html and glossary.json are readable")

	# THE FIVE THAT AGREED ALREADY. Each is asserted so a later batch that
	# widens a collection cannot leave the word behind — the DK/DL failure in
	# the other direction.
	ok(cls.contains("The unbreakable stand: for 3 turns\\nevery hero takes NO Break damage"),
		"Bulwark of Fortitude stopped saying `hero` while all four of its clauses still pay four")
	ok(cls.contains("Holy ground blooms underfoot: every\\nhero takes 15% less damage"),
		"Consecrated Ground stopped saying `hero` while its collection still walks the four")
	ok(cls.contains("The light answers: every hero deals\\n+15% damage and acts 15% faster"),
		"Divine Wrath stopped saying `hero` while neither of its clauses can reach a beast")
	ok(cls.contains("Bind the heroes' souls"),
		"Sacred Resolve stopped saying `heroes` while its apply and all three of its splits walk the four")
	ok(tal.contains("Embolden every ally: 50% less Break"),
		"Hold the Line stopped saying `ally` while `_hero_side()` still covers a beast")

	# ── THE TWO CLAUSES DM MOVED ────────────────────────────────────────────
	# BATTLE SHOUT: the Rage is the caster's and now says so, in Hold the Line's
	# own words for the identical payload.
	ok(tal.contains("on the warband. Lasts 3 turns.\\nRefunds 5 Rage."),
		"Battle Shout's SELF clause is not worded as one — the +5 Rage is back inside `every hero answers`")
	ok(not tal.contains("on the warband, and 5 Rage."),
		"THE NEGATIVE CONTROL FAILED: Battle Shout's pre-DM wording is still in the file")
	# HOLD THE LINE: CV §1's duration ruling, reaching the surface it missed.
	ok(tal.contains("no one can die\\nfor 2 turns. Refunds 5 Rage."),
		"Hold the Line's base card no longer states its no-death window as APPLIED (CV §1)")
	ok(tal.contains("no one can die\\nfor 3 turns."),
		"Hold the Line's UPGRADED card no longer states its no-death window as APPLIED (CV §1)")
	ok(not tal.contains("for a turn. Refunds 5 Rage.") and not tal.contains("die\\nfor two turns."),
		"THE NEGATIVE CONTROL FAILED: Hold the Line's pre-CV translated durations are still in the file")

	# ── AND THE PROSE SURFACES THAT STILL SAID `ally` FOR A FAITH CLAUSE ────
	# text-standard §4.9 is binding: `_gain_faith` refuses companions outright,
	# so **nothing Faith-flavoured can ever say `ally`**. DL corrected the card
	# and these four copies of the same clause were the surfaces nobody swept —
	# the DA/DC/DG shape exactly.
	for stale in ["1 an ally a turn", "1 per ally per turn",
			"every ally gains 1 Faith at the start of their turn"]:
		ok(not mas.contains(stale),
			"master.html still says `%s` for a clause `_gain_faith` refuses outright" % stale)
	ok(not glo.contains("every ally standing on Consecrated Ground"),
		"the glossary still says `ally` for the Faith drip, which is two exclusions deep")
	ok(mas.contains("1 a hero a turn") and mas.contains("1 per hero per turn"),
		"master.html's two Faith-drip parentheticals no longer say `hero`")
	ok(glo.contains("every hero standing on Consecrated Ground"),
		"the glossary's Faith entry no longer says `hero` for the drip")


# ── §5 — THE THREAD IS CLOSED, AND THE RULE THAT CLOSED IT IS WRITTEN DOWN ──
# A ruling with no rule behind it is re-litigated by the next author who trips
# on it — the sentence this thread has proved over nine batches.
func _closed() -> void:
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(claude != "", "CLAUDE.md is readable")
	ok(claude.contains("THE ALLY/HERO THREAD IS CLOSED"),
		"CLAUDE.md no longer records that the ally/hero thread is closed")
	ok(claude.contains("RULE ON CLAUSES, NOT ON ABILITIES"),
		"CLAUDE.md no longer carries the rule the thread produced")
	var ts := FileAccess.get_file_as_string("res://docs/text-standard.html")
	ok(ts.contains("CLOSED AT DM"),
		"text-standard.html §4.9 no longer records the close")


func _ability(name: String):
	for ab in Classes.ability_corpus():
		if ab.display_name == name:
			return ab
	return null


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.dead and not h.is_companion and h.hero_key == key:
			return h
	return null


func _foe(scene: Node) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead:
			return e
	return null
