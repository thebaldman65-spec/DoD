# BATCH DR — THE ENGINE / AXIS FRAMEWORK, ASSERTED AS PROPERTIES.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dr.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# **THE FRAMEWORK THIS FILE ENFORCES, RECORDED IN FULL IN `CLAUDE.md`:** an
# ENGINE is the spec's own currency and is exclusive by construction, one per
# spec. An AXIS is an effect type and is SHARED, deliberately. A pool is one
# exclusive engine plus a selection of shared axes, and a pool covering few axes
# holds one build however strong its engine is.
#
# **EVERY EXCLUSIVE BELOW IS ASSERTED AS A PROPERTY AND NEVER AS A COUNT.** DN's
# gate asserted two and there were five; DO's brief asserted nine and there were
# twenty-two; DR's own brief asserted three exclusive axes and ONE OF THE THREE
# WAS FALSE. So the shape here is: derive the population, assert the property
# over ALL of it, and PRINT the count beside the assertion rather than pinning
# the number.
#
# **THE THIRD CLAIMED EXCLUSIVE IS NOT ONE, AND §3 IS THE RECORD OF THAT.**
# The brief held that COOLDOWN MANIPULATION belongs to the Swordmaster and that
# Answering Steel and Battle Poise are "the only cards in the game that do it".
# `_tick_cooldowns` has SEVEN callers, one of them a MAGE CLASS-WIDE DRAFT CARD
# whose own comment names tempo as its axis. §3 asserts the axis is SHARED and
# names every site, so the next batch reads the population rather than the
# claim.
#
# IT READS ONLY THE **SPEC** draft pool through `Classes.spec_draft_pool(`, and
# takes the class half off the CONSTANT, so `check_da` §3's two-call fingerprint
# does not match and this gate needs no `WALK_EXEMPT` entry. Pool DEPTH is not
# a corpus walk — `Classes.ability_corpus()` is used below for everything that
# is one.
#
# **COMMENTS ARE STRIPPED BEFORE EVERY ABSENCE ASSERTION.** A comment recording
# a removal names the thing removed, so prose about the retirement of a card
# reads exactly like the retirement not having happened. §4's negative control
# proves the stripped check still bites.
extends SceneTree

# THE ONE AUTHORED BATTLE FIXTURE (DB's consolidation). A gate that spawns its
# own board is the copied helper `check_da` §3 exists to refuse.
const Gate = preload("res://gate_fixture.gd")

var checks := 0
var fails := 0

# THE TWO EXCLUSIVES THAT SURVIVED VERIFICATION, each with the property that
# makes it true rather than the count that describes it today.
const SUMMON_SPEC := "beastmaster"
const REVIVE_SPEC := "holy"

# THE SEVEN COOLDOWN-MANIPULATION SITES, NAMED WITH THEIR OWNERS. This is a
# RATCHET and not a pin: a site that VANISHES is a notice, a site that appears
# and is not on this list is an error, because a new one is the thing the brief
# assumed could not exist.
const TICK_SITES := {
	"Answering Steel": "Swordmaster draft card — per parry",
	"Battle Poise": "Swordmaster draft card — per parry",
	"Blink": "MAGE CLASS-WIDE DRAFT CARD — its own comment names tempo as its axis",
	"Blessing of Zeal": "Devout PROTECTED CORE — ticks the target's cooldowns on cast",
	"Frostbound Hours": "cr_frostbound, Cryomancer Thaw r8 — EVERY hero's cooldowns",
	"Practised Hands": "sv_practised, Survivalist Guerilla r8",
	"Follow-Through": "ss_follow, Sharpshooter Tempo r5",
}

# BATCH DR §4's three cards, and the axis each was authored to add.
const NEW_AXES := {
	"Lunge": "BREAK — re-authored; cooldown 0 -> 3, and the guard decides depth or breadth",
	"Wheeling Cut": "AREA DAMAGE + SELF-MITIGATION — a reader, so it branches and flips",
	"Counter Time": "CONTROL — gated on the Defensive guard, so it requires and stays",
}

# The retired card, named once so the failure messages cannot drift from it.
const RETIRED := "Flash Freeze"

# Counter Time's promise, held here so the live check and the card cannot drift.
const COUNTER_TIME_TURNS_EXPECT := 2


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		print("  FAIL: %s" % msg)


# COMMENTS OUT. The `#` test is deliberately the LINE-LEADING one rather than a
# search anywhere in the line: a `#` inside a string literal is code.
func _code_only(src: String) -> String:
	var out := ""
	for line in src.split("\n"):
		if not line.strip_edges().begins_with("#"):
			out += line + "\n"
	return out


func _battle_code() -> String:
	return _code_only(FileAccess.get_file_as_string("res://scripts/battle.gd"))


func _classes_code() -> String:
	return _code_only(FileAccess.get_file_as_string("res://scripts/classes.gd"))


# ---------------- §1 — COMPANION SUMMONING IS THE BEASTMASTER'S ----------------
func _s1_summoning() -> void:
	print("§1 — COMPANION SUMMONING is exclusive to the Beastmaster")
	# THE PROPERTY: every ability in the game whose `special` is "summon"
	# belongs to the Beastmaster's protected core. Derived over the WHOLE
	# corpus, so a summon authored onto any other spec fails here.
	var owners := {}
	var summons: Array = []
	for spec in Classes.SPEC_INFO:
		for ab in Classes.spec_abilities(spec):
			if ab.special == "summon":
				summons.append(ab.display_name)
				owners[ab.display_name] = spec
	# `ability_corpus()` returns Ability OBJECTS, not names — the one walk, and
	# the reason this gate needs no hand-rolled enumeration of its own.
	for cab in Classes.ability_corpus():
		if cab.special == "summon" and not owners.has(cab.display_name):
			summons.append(cab.display_name)
			owners[cab.display_name] = "OUTSIDE THE BEASTMASTER'S CORE"
	ok(not summons.is_empty(), "no summon abilities found at all — the sweep read nothing")
	for n in summons:
		ok(owners[n] == SUMMON_SPEC,
			"%s carries `special: summon` and belongs to %s, not the %s" % [
				n, owners[n], SUMMON_SPEC])
	print("  %d summon abilities, all of them %s core: %s" % [
		summons.size(), SUMMON_SPEC, ", ".join(summons)])
	# AND THE SECOND DOOR: `_do_summon` is the only thing that puts a body on
	# the field, so a card reaching it from another pool would be a summon
	# without the `special`. Its callers are asserted by count-and-name.
	var code := _battle_code()
	ok(code.count("_do_summon(") == 3,
		"`_do_summon` has %d mentions in code, not 3 (its def, the `summon` special, Call the Wilds)" % \
			code.count("_do_summon("))
	ok(code.contains("\"call_wilds\":"),
		"Call the Wilds is the one draft card that summons and it is the Beastmaster's")


# ---------------- §2 — REVIVAL IS THE HOLY CLERIC'S ----------------
func _s2_revival() -> void:
	print("\n§2 — REVIVAL is exclusive to the Holy Cleric AMONG ABILITIES")
	# THE PROPERTY: `BattleUnit.revive()` is the one way a corpse stands up, and
	# exactly one ABILITY reaches it. **THE BRIEF ASKED THIS BE VERIFIED AND
	# REPORTED, AND THE HONEST ANSWER HAS A QUALIFIER**: two NON-ability channels
	# revive as well, and neither belongs to any spec — the REVIVE POTION (an
	# item any hero may drink) and the `revive_pct` MAP EVENT. Exclusive as an
	# ability; not exclusive as a channel. The count is asserted at 2 so that a
	# THIRD caller — which would be a second reviving ability — trips.
	var code := _battle_code()
	var n := code.count(".revive(")
	ok(n == 2, "`.revive(` has %d call sites in battle.gd code, not 2 (Resurrection, the Revive Potion)" % n)
	ok(code.contains("\"resurrection\":"),
		"the `resurrection` handler is gone — the one ABILITY that revives")
	# ...and it is HERS. Asserted off the kit rather than off a name.
	var found := ""
	for spec in Classes.SPEC_INFO:
		for ab in Classes.spec_abilities(spec):
			if ab.special == "resurrection":
				found = spec
	ok(found == REVIVE_SPEC,
		"`resurrection` belongs to '%s', not '%s'" % [found, REVIVE_SPEC])
	# AND NO DRAFT CARD MAY REACH IT. A pool entry with this special would hand
	# revival to whoever drafted it.
	var leaks: Array = []
	for cab in Classes.ability_corpus():
		if cab.special == "resurrection" and not Classes.spec_abilities(REVIVE_SPEC).any(
				func(k): return k.display_name == cab.display_name):
			leaks.append(cab.display_name)
	ok(leaks.is_empty(), "draft cards reaching `resurrection`: %s" % ", ".join(leaks))
	print("  Revival is one ability (Resurrection, %s) plus two non-ability channels" % REVIVE_SPEC)
	print("  — the Revive Potion item and the `revive_pct` map event. Reported, not ruled.")


# ---------------- §3 — COOLDOWN MANIPULATION IS **SHARED** ----------------
func _s3_cooldowns_are_shared() -> void:
	print("\n§3 — COOLDOWN MANIPULATION is a SHARED axis, and the brief said otherwise")
	# **THIS SECTION ASSERTS THE OPPOSITE OF WHAT DR's BRIEF ASKED FOR**, and it
	# is here rather than absent because the false claim is the useful record:
	# the next batch that reads "cooldown manipulation is the Swordmaster's"
	# should find the seven sites rather than re-derive them.
	var code := _battle_code()
	var n := code.count("_tick_cooldowns(")
	# One def plus seven callers. A ratchet, not a pin: the message says which
	# way it moved so a repair reads differently from a regression.
	ok(n >= 8, "`_tick_cooldowns` has %d code mentions; 8 expected (1 def + 7 callers) — a caller has GONE" % n)
	if n > 8:
		print("  NOTICE: %d mentions, not 8 — a NEW cooldown-manipulation site exists." % n)
		print("  That is not an error; it is the thing to name in the next brief.")
	ok(code.contains("\"blink\":"),
		"the `blink` handler is gone — it is the MAGE CLASS-WIDE card that disproves the exclusive")
	ok(Classes.draft_ability("Blink") != null,
		"Blink no longer resolves as a draft card")
	print("  %d sites, and they are not one spec's:" % TICK_SITES.size())
	for k in TICK_SITES:
		print("    %-20s %s" % [k, TICK_SITES[k]])
	# THE ONE IMPLEMENTATION RULE STILL HOLDS AND IS THE HALF WORTH KEEPING.
	# BQ extracted four hand-written copies into `_tick_cooldowns`; what is
	# shared is the AXIS, not a second walk of the dictionary.
	ok(code.count("func _tick_cooldowns(") == 1,
		"`_tick_cooldowns` is authored more than once — BQ's one implementation is gone")


# ---------------- §4 — FLASH FREEZE IS RETIRED ----------------
func _s4_retired() -> void:
	print("\n§4 — %s is retired, and the suspension comment went with it" % RETIRED)
	# **COMMENTS STRIPPED.** `classes.gd` carries prose RECORDING the retirement
	# and that prose names the card; an un-stripped `contains` would read that
	# record as the card still being there. This is the trap DR's own CLAUDE.md
	# entry documents, tested here rather than described.
	var ccode := _classes_code()
	var bcode := _battle_code()
	ok(not ccode.contains("\"%s\"" % RETIRED),
		"%s is still defined or pooled in classes.gd CODE" % RETIRED)
	ok(not bcode.contains("flash_" + "freeze"),
		"the retired handler still stands in battle.gd CODE")
	ok(Classes.draft_ability(RETIRED) == null,
		"%s still resolves through `draft_ability`" % RETIRED)
	ok(not Classes.spec_draft_pool("cryomancer").has(RETIRED),
		"%s is still in the Cryomancer's draft pool" % RETIRED)
	# THE SURVIVOR IS THE BETTER CARD AND IT IS STILL THERE. Retiring the wrong
	# one of the pair would pass every assertion above.
	ok(Classes.spec_draft_pool("cryomancer").has("Glacial Prison"),
		"Glacial Prison is GONE — the wrong half of the pair was retired")
	# AND THE SUSPENSION COMMENT IS DELETED RATHER THAN UPDATED. Its two stated
	# reasons — the acquisition channel and the Perfect — died at DO and CR, and
	# a documented exception outliving its justifications reads as deliberate.
	var craw := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(not craw.contains("REPORTED, NOT RE-TUNED: on every number this is a strictly worse"),
		"the suspension comment is still in classes.gd — DR §2 deletes it, it does not update it")
	# THE MECHANIC IT WAS NOT: four Chilled stacks still flash-freeze, which is
	# `_apply_status`'s branch and belongs to no card.
	ok(bcode.contains("status_stacks(\"chilled\") >= 4"),
		"the Chilled-4 auto-freeze went with the card — that is a MECHANIC, not the ability")


# ---------------- §5 — THE SWORDMASTER'S FOUR NEW AXES ----------------
func _s5_new_axes() -> void:
	print("\n§5 — the Swordmaster gains four axes on three cards")
	var pool := Classes.spec_draft_pool("swordmaster")
	ok(pool.size() == 12, "the Swordmaster's pool is %d, not 12" % pool.size())
	for n in NEW_AXES:
		ok(pool.has(n), "%s is not in the Swordmaster's draft pool" % n)
		var ab = Classes.draft_ability(n)
		ok(ab != null, "%s does not resolve through `draft_ability`" % n)
	# **THE COOLDOWN-ZERO POPULATION IS THE REASON LUNGE WAS THE ONE TO
	# RE-AUTHOR.** DQ measured exactly two repeatable draft cards in 142 where
	# every cooldown-zero ability in the protected cores is the free basic
	# attack. Lunge is off that list now; Pyroblast is not, and DU §1 RULED
	# THAT IT STAYS THERE — priced twice, on tempo and on mana, just not with
	# a cooldown. The list below keeps printing every run all the same.
	#
	# **BATCH DU CORRECTED THE FIGURE THIS COMMENT CARRIED**, which read "all
	# twelve": twelve is the count of INSTANCES across twelve specs, and there
	# are SEVEN distinct names behind them. The claim is true either way.
	#
	# **AND THE WALK BELOW IS STILL THE DRAFT POOLS AND NOTHING ELSE**, which
	# is deliberate and is why DU §5 audited the boss-pick pools separately
	# rather than folding them in here: a census that silently changed
	# population would make every earlier reading of this line incomparable.
	var zero: Array = []
	for spec in Classes.SPEC_INFO:
		for n2 in Classes.spec_draft_pool(spec):
			var ab2 = Classes.draft_ability(n2)
			if ab2 != null and ab2.cooldown == 0:
				zero.append("%s (%s)" % [n2, spec])
	ok(not zero.has("Lunge (swordmaster)"),
		"Lunge still carries cooldown 0 — the whole reason DR §4 named it")
	print("  cooldown-zero draft cards remaining: %d — %s" % [zero.size(), ", ".join(zero)])
	# EVERY NEW CARD READS THE STANCE ENGINE, WHICH IS WHAT MAKES IT HIS. Two
	# BRANCH on it (`_eff_stance`) and one REQUIRES it (`_stance_satisfies`),
	# which is BW's rule: READERS BRANCH AND FLIP, GATED ONES REQUIRE AND STAY.
	var code := _battle_code()
	ok(code.contains("\"wheeling_cut\":"), "the Wheeling Cut handler is missing")
	ok(code.contains("\"counter_time\":"), "the Counter Time handler is missing")
	ok(code.contains("_eff_stance(attacker) == \"aggressive\"\n\t\t\tif wc_aggressive") \
			or code.contains("var wc_aggressive := _eff_stance(attacker)"),
		"Wheeling Cut does not read `_eff_stance` — a Feigned Guard would not move it")
	ok(code.contains("ab.special == \"counter_time\" and not _stance_satisfies(u, \"defensive\")"),
		"Counter Time is not gated at `_ability_usable` — the door BW established")
	ok(code.contains("var lunge_aggr := _eff_stance(attacker)"),
		"Lunge's Break rider does not read `_eff_stance`")
	# AND THE GATED CARD DOES NOT FLIP HIM. Getting the two card types backwards
	# is the single easiest mistake to make in this spec, so it is asserted.
	# THE LOCATOR IS ASSERTED BEFORE THE SLICE IS TAKEN. `find` returning -1 gives
	# a `substr` that Godot answers with "", and `not "".contains(X)` is true for
	# every X there is — the shape that let two of `test_batch_bg`'s checks pass
	# while reading nothing at all. The anchor resolves today; unguarded, it goes
	# silent the day somebody renames the special.
	var ct_at := code.find("\"counter_time\":")
	ok(ct_at >= 0, "the `counter_time` arm is findable, so the slice below is real")
	var ct := code.substr(ct_at)
	ct = ct.substr(0, ct.find("\n\t\t\"") if ct.find("\n\t\t\"") > 0 else ct.length())
	ok(not ct.contains("_swordmaster_switch"),
		"Counter Time SWITCHES the stance — it is a GATED card and must require and stay")


# ---------------- §6 — BATTLE POISE BUYS A FREE GUARD CHANGE ----------------
func _s6_battle_poise() -> void:
	print("\n§6 — the Defensive guard buys a free Guard Change")
	var code := _battle_code()
	# **THE ONE DOOR.** The free pivot asks `_ability_usable` about the REAL
	# Guard Change rather than re-deciding, which is what makes three promises
	# true at once and keeps them from disagreeing: Formless refuses it, the
	# 1-turn cooldown is respected, and the cost is checked.
	ok(code.contains("_find_ability(strike_target, \"Guard Change\")"),
		"the free pivot does not resolve the real Guard Change ability")
	ok(code.contains("_ability_usable(strike_target, bp_gc)"),
		"the free pivot does not go through `_ability_usable` — it has a second path")
	ok(code.contains("strike_target.start_cooldown(bp_gc)"),
		"the free pivot does not START Guard Change's cooldown, so `respects it` is once only")
	ok(code.contains("strike_target.poise_pivot_used = true"),
		"the free pivot is not bounded to once a turn")
	ok(code.contains("u.poise_pivot_used = false"),
		"`poise_pivot_used` is never cleared — the pivot is once a BATTLE, not once a turn")
	# THE PIVOT AND NOT THE ABILITY: Guard Change's own payload stays on Guard
	# Change. A Defensive Swordmaster holding Sunder Guard and parrying twice a
	# turn would otherwise land 80 free Break damage across the field each turn.
	var bp := code.substr(code.find("has_status(\"battle_poise\")"))
	bp = bp.substr(0, 2000)
	ok(not bp.contains("guard_change_bd"),
		"the free pivot pays Sunder Guard — it must be `_swordmaster_switch` alone")
	ok(bp.contains("_swordmaster_switch(strike_target)"),
		"the free pivot does not go through the ONE stance pivot")
	# AND FORMLESS STILL REFUSES IT, at that same door.
	ok(code.contains("ab.special == \"guard_change\" and u.has_status(\"formless\")"),
		"Formless no longer refuses Guard Change — the free pivot would slip past it")


# ---------------- §7 — THE NAME SWEEP, AND THE DRAFT TOTAL ----------------
func _s7_names_and_total() -> void:
	print("\n§7 — BR §1's name sweep, and the draft total")
	# BR §1: every ability, talent node, status and rune. An ability-vs-ability
	# duplicate is a REAL BREAK — `pool_ability` is keyed on `display_name` — so
	# it is asserted; everything else is a label collision and is PRINTED.
	var labels := {}
	for cab in Classes.ability_corpus():
		labels[cab.display_name] = "ability"
	for spec in Classes.SPEC_INFO:
		if not Talents.has_tree(spec):
			continue
		for cell in Talents.generate_tree(spec, Classes.class_of_spec(spec)):
			labels[String(cell.get("name", ""))] = "talent node"
	var dupes: Array = []
	for n in NEW_AXES:
		if n == "Lunge":
			continue  # not a new name; it is a re-author
		var seen := 0
		for cab in Classes.ability_corpus():
			if cab.display_name == n:
				seen += 1
		ok(seen == 1, "%s resolves %d times in the corpus — an ability-vs-ability duplicate" % [n, seen])
		if labels.get(n, "") == "talent node":
			dupes.append(n)
	ok(dupes.is_empty(), "new card names colliding with a talent node: %s" % ", ".join(dupes))
	# THE TOTAL, DERIVED. 142 - 1 (Flash Freeze) + 2 (the Swordmaster's two) = 143
	# at DR, and BATCH DS's six Hunter cards take it to 149. This gate asserts
	# the LIVE total rather than DR's, on purpose: its subject is the two
	# movements DR made, and a later batch adding cards elsewhere must not read
	# as DR's work coming undone.
	var spec_total := 0
	for spec in Classes.SPEC_INFO:
		spec_total += Classes.spec_draft_pool(spec).size()
	var class_total := 0
	for k in Classes.CLASS_DRAFT_POOLS:
		class_total += (Classes.CLASS_DRAFT_POOLS[k] as Array).size()
	# BATCH DX §1 — A FLOOR, NOT AN EQUALITY. The draft is a collection that
	# GROWS — DO added twenty-two, DR a net +1, DS six — and each time, this
	# line had to be hand-bumped in a dozen files at once. An equality here reds
	# on the next batch that authors a card, and that failure reads exactly like
	# a regression. THE FLOOR IS THE HALF THIS SUITE OWNS: a pool quietly
	# EMPTYING still trips it. The ONE surviving equality is `test_batch_cd`'s,
	# beside `PER_SPEC_DEPTH` — the authoritative table a new card must move.
	ok(spec_total >= 125,
		"the spec draft half has FALLEN to %d, below the 125 that shipped" % spec_total)
	ok(class_total >= 24,
		"the class draft half has FALLEN to %d, below the 24 that shipped" % class_total)
	ok(spec_total + class_total >= 149,
		"the draft has FALLEN to %d, below the 149 that shipped" % (spec_total + class_total))
	print("  draft: %d spec + %d class-wide = %d" % [spec_total, class_total,
		spec_total + class_total])
	ok(Classes.talent_granted_names().is_empty(),
		"a card has fallen outside every pool — `talent_granted_names()` is not empty")


# ---------------- §8 — THE FRAMEWORK IS WRITTEN DOWN ----------------
func _s8_recorded() -> void:
	print("\n§8 — the framework and the trap are recorded where a later batch reads them")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("An ENGINE is the spec's own currency"),
		"CLAUDE.md does not carry the ENGINE half of the framework")
	ok(cm.contains("An AXIS is an effect type"),
		"CLAUDE.md does not carry the AXIS half of the framework")
	ok(cm.contains("Adding axes to a spec does not dilute its identity"),
		"CLAUDE.md does not carry the sentence the whole framework exists to license")
	ok(cm.contains("A DOCUMENTED EXCEPTION THAT OUTLIVES ITS JUSTIFICATIONS"),
		"CLAUDE.md does not carry DR §2's trap")




# ---------------- §9 — THE THREE CARDS, DRIVEN LIVE ----------------
# A def that resolves is not a card that works. Every assertion above reads
# source or tables; this one spawns a board and casts.
func _s9_live() -> void:
	print("\n§9 — the three cards, driven on a live board")
	var scene: Node = await Gate.spawn(self, ["swordmaster", "arcanist", "holy",
		"sharpshooter"], {"deterministic": true})
	var sm: BattleUnit = null
	for h in scene.get("heroes"):
		if h.passive_id == "seasoned":
			sm = h
	ok(sm != null, "the Swordmaster spawned")
	if sm == null:
		scene.queue_free()
		return
	var foes: Array = (scene.get("enemies") as Array).filter(func(e): return not e.dead)
	ok(foes.size() >= 2, "at least two enemies stand (%d)" % foes.size())
	sm.resource = sm.max_resource

	# ---- COUNTER TIME: gated on the Defensive guard at the ONE door ----
	var ct := Classes.draft_ability("Counter Time")
	sm.stance = "aggressive"
	ok(not scene.call("_ability_usable", sm, ct),
		"Counter Time is castable from the Aggressive guard — the gate is not biting")
	sm.stance = "defensive"
	ok(scene.call("_ability_usable", sm, ct),
		"Counter Time is refused from the Defensive guard it requires")
	# FORMLESS satisfies BOTH gates (CI's rule), so it must be castable there too.
	sm.stance = "aggressive"
	scene.call("_apply_status", sm, "formless", 4)
	ok(scene.call("_ability_usable", sm, ct),
		"a FORMLESS Swordmaster is refused Counter Time — Formless satisfies BOTH gates")
	sm.remove_status("formless")
	sm.formless_pending = 0
	sm.stance = "defensive"
	var ct_victim: BattleUnit = foes[0]
	ct_victim.broken = true   # the boss carve-out is inherited, not re-written
	await scene.call("_resolve", sm, ct, ct_victim, "good")
	ok(ct_victim.has_status("stunned"), "Counter Time did not Stun")
	ok(int(ct_victim.get_status("stunned").get("turns", 0)) >= COUNTER_TIME_TURNS_EXPECT,
		"Counter Time's Stun is shorter than the %d turns the card promises" % COUNTER_TIME_TURNS_EXPECT)
	# GATED ONES REQUIRE AND STAY: it must not have moved him.
	ok(sm.stance == "defensive",
		"Counter Time SWITCHED the guard — a gated card requires and stays")

	# ---- WHEELING CUT: reads and flips, and the branch buys what he ARRIVES in ----
	sm.resource = sm.max_resource
	var wc := Classes.draft_ability("Wheeling Cut")
	sm.stance = "aggressive"
	await scene.call("_resolve", sm, wc, foes[0], "good")
	ok(sm.has_status("wheeling_guard"),
		"cast from AGGRESSIVE he lands DEFENSIVE and must arrive holding DEFENCE")
	ok(not sm.has_status("wheeling_edge"), "...and not the offensive half as well")
	ok(sm.stance == "defensive", "Wheeling Cut did not flip the guard — it is a READER")
	sm.resource = sm.max_resource
	await scene.call("_resolve", sm, wc, foes[0], "good")
	ok(sm.has_status("wheeling_edge"),
		"cast from DEFENSIVE he lands AGGRESSIVE and must arrive holding OFFENCE")
	ok(sm.stance == "aggressive", "...and the guard flipped back")
	# THE PERFECT IS BOTH GIFTS AT ONCE, and `test_batch_bo` §5's biconditional
	# is why the card has one at all: it runs a bar, so it must state a Perfect.
	sm.remove_status("wheeling_guard")
	sm.remove_status("wheeling_edge")
	sm.resource = sm.max_resource
	await scene.call("_resolve", sm, wc, foes[0], "perfect")
	ok(sm.has_status("wheeling_guard") and sm.has_status("wheeling_edge"),
		"a PERFECT Wheeling Cut does not grant BOTH guards' gifts")
	ok(Classes.draft_ability("Wheeling Cut").perfect_text != "",
		"Wheeling Cut runs a bar and advertises no Perfect — bo §5's biconditional")

	# ---- LUNGE: the guard decides where the Break lands ----
	sm.resource = sm.max_resource
	var lg := Classes.draft_ability("Lunge")
	ok(lg.cooldown > 0, "Lunge is still repeatable every turn — cooldown %d" % lg.cooldown)
	var other: BattleUnit = null
	for e in (scene.get("enemies") as Array):
		if not e.dead and e != foes[0]:
			other = e
	ok(other != null, "a second enemy stands for the breadth branch")
	if other != null:
		# AGGRESSIVE: depth. The OTHER enemy's meter must not move.
		sm.stance = "aggressive"
		var before_other: int = other.pressure
		sm.cooldowns.erase("Lunge")
		await scene.call("_resolve", sm, lg, foes[0], "good")
		ok(other.pressure == before_other,
			"Lunge from AGGRESSIVE moved a bystander's Break meter — that is the DEFENSIVE branch")
		# DEFENSIVE: breadth. It must.
		sm.stance = "defensive"
		sm.resource = sm.max_resource
		sm.cooldowns.erase("Lunge")
		var before_other2: int = other.pressure
		await scene.call("_resolve", sm, lg, foes[0], "good")
		ok(other.pressure > before_other2 or other.dead or other.broken,
			"Lunge from DEFENSIVE left a bystander's Break meter untouched — the breadth branch is dead")

	# ---- BATTLE POISE: the parry buys ONE free Guard Change a turn ----
	# Driven rather than read, because the whole clause lives at a site no cast
	# reaches: an ENEMY's blow, turned aside. The parry is forced to 100% so the
	# check measures the clause and not the roll.
	sm.remove_status("wheeling_edge")
	sm.remove_status("wheeling_guard")
	sm.parry_chance = 1.0
	sm.stance = "defensive"
	sm.poise_pivot_used = false
	sm.cooldowns.erase("Guard Change")
	scene.call("_apply_status", sm, "battle_poise", 4)
	# **MELEE ONLY.** Only a melee attack can be parried unless the defender
	# knows Deflection, and the fixture's board carries an archer — picking the
	# last living enemy would have measured the ranged refusal and read as the
	# clause being dead.
	var biter: BattleUnit = null
	for e in (scene.get("enemies") as Array):
		if not e.dead and not e.is_ranged and biter == null:
			biter = e
	ok(biter != null, "a MELEE enemy stands to be parried")
	if biter != null:
		var bp_before := String(sm.stance)
		await scene.call("_resolve", biter, biter.abilities[0], sm, "good")
		ok(sm.stance != bp_before,
			"the parry did not buy the free Guard Change — he is still %s" % bp_before)
		ok(sm.poise_pivot_used, "...and the once-a-turn flag was not spent")
		# ONCE A TURN: a second parry in the same turn buys nothing.
		var bp_mid := String(sm.stance)
		await scene.call("_resolve", biter, biter.abilities[0], sm, "good")
		ok(sm.stance == bp_mid,
			"a SECOND parry pivoted him again — the clause is once a TURN, not once a parry")
		# ...AND FORMLESS REFUSES IT AT THE SAME DOOR. No stance to change.
		sm.poise_pivot_used = false
		sm.cooldowns.erase("Guard Change")
		scene.call("_apply_status", sm, "formless", 4)
		var bp_fm := String(sm.stance)
		await scene.call("_resolve", biter, biter.abilities[0], sm, "good")
		ok(sm.stance == bp_fm and not sm.poise_pivot_used,
			"FORMLESS did not refuse the free pivot — there is no stance to change")
		sm.remove_status("formless")
		sm.formless_pending = 0
		# ...AND GUARD CHANGE'S OWN COOLDOWN IS RESPECTED, which is what makes
		# `_ability_usable` the door rather than a convenience.
		sm.poise_pivot_used = false
		var gc_ab: Ability = scene.call("_find_ability", sm, "Guard Change")
		sm.cooldowns[gc_ab.display_name] = 3
		var bp_cd := String(sm.stance)
		await scene.call("_resolve", biter, biter.abilities[0], sm, "good")
		ok(sm.stance == bp_cd,
			"the free pivot ignored Guard Change's own cooldown — the 1cd is what stops spam")
	scene.queue_free()
	await process_frame


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	await process_frame
	print("check_dr — the engine/axis framework, and the Swordmaster's pool")
	_s1_summoning()
	_s2_revival()
	_s3_cooldowns_are_shared()
	_s4_retired()
	_s5_new_axes()
	_s6_battle_poise()
	_s7_names_and_total()
	_s8_recorded()
	await _s9_live()
	print("\ncheck_dr: %d checks, %d failures" % [checks, fails])
	quit()
