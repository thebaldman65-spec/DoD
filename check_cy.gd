# BATCH CY — the invariant gate. §1 caps a PURE BUFF's initiative delay at half
# the basic attack's, and the whole batch rests on one question: which abilities
# are pure buffs. `Ability.PURE_BUFFS` is the answer, and a table of that size
# rots the moment a handler grows a second payload — so this gate does not read
# the table against another table. It SPAWNS A REAL BATTLE, casts every member
# through `_resolve_special`, and asserts that nothing moved except a status on
# the caster or an ally.
#
# THE NEGATIVE HALF IS THE HALF THAT MATTERS, and it is CO's lesson taken
# whole. A gate that can only pass is a gap, so §1's excluded populations are
# asserted OUT of the table by name: the heals, the shields, the enemy debuffs
# and the second-payload cards each have a reason, and a later batch quietly
# adding one of them would halve the price of something that was never priced
# as setup.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cy.gd
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

# Cards whose payload is NOT only a buff, verified by walking
# `_resolve_special`. Each would be mispriced by the cap, and each is named
# rather than left to look like an omission.
const MUST_NOT_CAP := {
	"battle_shout": "hands the caster +5 Rage",
	"hold_the_line": "hands the caster +5 Rage",
	"stabilize": "vents Resonance into Mana and heals 5% of maximum health",
	"reckless_abandon": "spends the whole Rage bar",
	"zeal": "ticks cooldowns down through Crusader's Tempo",
	"blink": "takes two turns off every cooldown he is holding",
	"preparation": "buys an extra turn",
	"elevation": "grants the party Faith",
	"ordination": "grants an ally Faith",
	"hold_breath": "grants the caster 40 Focus",
	"quarrys_mark": "grants the caster 20 Focus, and marks an enemy",
	"reacquire": "grants the caster 25 Focus, and names an enemy",
	"inner_arcane": "grants the caster Resonance",
	"overcharge": "grants the caster Resonance",
	"threshold": "sets the caster's Resonance outright",
	"surge": "grants the caster Resonance",
	"blood_price": "spends health for resource",
	"blood_offering": "spends health for resource",
	"shared_grief": "spends health for Mercy",
	"phoenix": "spends health for resource",
	"rally": "sheds the party's Pressure and refunds resource",
	"rally_ally": "refunds an ally's resource",
	"recant": "refunds resource",
	"dispel": "strips three effects off the target",
	"unburden": "purges an ally's debuffs",
	"funeral_pyre": "eats the target's Burn and refunds Mana",
	"aegis_reversal": "spends an ally's shield as bonus damage",
	"summon": "puts a companion on the field",
	"resurrection": "revives the dead",
	"call_wild": "strikes with every companion, standing or lost",
	"kill_command": "orders a companion strike",
	"harvest": "damages and heals",
	"feint": "hits from inside its handler",
	"guard_change": "hits, and moves the caster's stance and resource",
	"precision_strike": "hits from inside its handler",
	"savage_sweep": "hits from inside its handler",
	"cull": "hits from inside its handler",
	"primal_surge": "spends Loyalty as a companion strike",
	"bestial": "buffs the companions AND taunts three enemies",
	"eye_of_storm": "taunts the whole field",
	"deep_winter": "stacks Chilled on every enemy",
	"snare_line": "lays a status on every enemy",
	"covenant_ash": "binds an enemy and lands 2 Ruin",
	"transference": "moves Ruin between enemies",
}

# §1'S OTHER TWO EXCLUDED POPULATIONS, held apart because the REASON differs
# and the designer's ruling on them differs too.
#
# HEALS — "a heal is a response to what just happened, not setup". The answer to
# "is this card a heal" is `Ability.HEAL_SPECIALS` plus the `heal` fields: that
# question was authored once, in CN §2, and asking it twice is how two answers
# start disagreeing.
#
# SHIELDS — reported for a ruling and DELIBERATELY UNCHANGED. The criterion is
# mechanical: a consumable absorb pool or charge count that eats incoming
# attacks. Percentage mitigation that runs for N turns is NOT one — it has no
# pool — which is why Immolate, Ironclad and Consecrated Ground are buffs and
# these six are not.
const SHIELDS := ["divine_shield", "magic_barrier", "mantle", "interpose",
	"mirror_image", "vespers"]

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
	var corpus := _corpus()
	var pure: Array = Ability.PURE_BUFFS
	print("BATCH CY — %d PURE BUFFS of %d abilities" % [pure.size(), corpus.size()])

	# ---- §1's rule, stated against BASIC_DELAY rather than against 1.0 ----
	ok(is_equal_approx(Ability.BUFF_DELAY_CAP, Ability.BASIC_DELAY * 0.5),
		"BUFF_DELAY_CAP is %.2f, not half of BASIC_DELAY (%.2f)" % [
			Ability.BUFF_DELAY_CAP, Ability.BASIC_DELAY])
	ok(is_equal_approx(float(battle_gd.BASIC_DELAY), Ability.BASIC_DELAY),
		"battle.BASIC_DELAY (%.2f) and Ability.BASIC_DELAY (%.2f) disagree — there must be ONE baseline" % [
			float(battle_gd.BASIC_DELAY), Ability.BASIC_DELAY])

	# ---- the table's own shape ----
	var seen_dupe := {}
	for sp in pure:
		if seen_dupe.has(sp):
			ok(false, "`%s` appears twice in PURE_BUFFS" % sp)
		seen_dupe[sp] = true
	var used := {}
	for ab in corpus:
		if ab.special != "":
			used[ab.special] = true
	for sp in pure:
		ok(used.has(sp), "PURE_BUFFS names `%s`, which no drafted ability uses" % sp)
	for sp in MUST_NOT_CAP:
		ok(not pure.has(sp), "`%s` is capped as a pure buff but %s" % [
			sp, MUST_NOT_CAP[sp]])
	for sp in SHIELDS:
		ok(not pure.has(sp),
			"`%s` is a shield — §1 reports shields and changes nothing" % sp)

	# ---- the rule, applied ----
	var touched: Array = []
	for ab in corpus:
		if not ab.is_pure_buff():
			continue
		touched.append(ab)
		ok(ab.delay <= Ability.BUFF_DELAY_CAP + 0.001,
			"%s is a pure buff at delay %.2f, past the cap of %.2f" % [
				ab.display_name, ab.delay, Ability.BUFF_DELAY_CAP])
		# The mechanical half of the scope limit: a pure buff cannot be one
		# whose OWN FIELDS already prove it does something besides the buff.
		ok(ab.damage <= 0 and ab.pressure <= 0 and ab.heal <= 0 \
			and ab.heal_missing <= 0.0 and ab.bleed_build <= 0 \
			and ab.delay_push <= 0.0 and ab.lifesteal <= 0.0,
			"%s is capped as a pure buff and carries damage/BD/heal on its own fields" %
				ab.display_name)
		ok(not ab.special in Ability.DAMAGE_SPECIALS,
			"%s is capped as a pure buff and is in DAMAGE_SPECIALS" % ab.display_name)
		ok(not ab.special in Ability.HEAL_SPECIALS,
			"%s is capped as a pure buff and is in HEAL_SPECIALS — §1 excludes heals" %
				ab.display_name)
		ok(ab.applies_status.is_empty(),
			"%s is capped as a pure buff and carries an on-hit status" % ab.display_name)
		# CN's criterion agrees from the other side: a pure buff has nothing for
		# a grade to multiply, so it runs no timing bar.
		ok(not ab.runs_skill_check(),
			"%s is a pure buff and still runs a timing bar" % ab.display_name)

	# ---- the live half: cast every one of them and watch the board ----
	var by_special := {}
	for ab in corpus:
		if ab.special != "" and not by_special.has(ab.special):
			by_special[ab.special] = ab
	# TWO FIXTURES, CO'S REASON EXACTLY. Half this set reads the caster's own
	# sheet: ALMS and DIVINE PRESENCE need MERCY (the Holy Cleric) while the
	# Devout (`inquisitor`) is what several others read. A one-party sweep
	# reports the cards it cannot reach as untested, which is the fixture's
	# limit quietly reading as coverage.
	var first := await _sweep(await Gate.spawn(self, ["warden", "pyromancer", "holy",
		"beastmaster"]), pure, by_special, [])
	var second := await _sweep(await Gate.spawn(self, ["berserker", "cryomancer",
		"inquisitor", "sharpshooter"]), pure, by_special, [])
	var cast_n: int = int(first["cast"]) + int(second["cast"])
	# BOTH FIXTURES SWEEP THE WHOLE SET, and that is deliberate rather than
	# CO's narrowing. CO's second party existed to reach cards the first could
	# not write; here every card writes on either party, so the second pass buys
	# a DIFFERENT set of caster sheets — a Berserker's frenzy floor, a
	# Sharpshooter's Focus, a Devout's Faith — against the same assertion. The
	# count is casts, not abilities, and says so.
	var untested: Array = (second["untested"] as Array).duplicate()
	for nm in first["untested"]:
		if not untested.has(nm):
			untested.append(nm)
	print("  cast live and watched: %d casts across 2 fixtures (%d abilities)" % [
		cast_n, pure.size()])
	if not untested.is_empty():
		print("  not exercised live (%d): %s" % [untested.size(),
			", ".join(PackedStringArray(untested))])

	# ---- the report §1 asks for: every ability the rule touches ----
	touched.sort_custom(func(a, b): return a.display_name < b.display_name)
	print("\n  THE CAP, APPLIED (cap = BASIC_DELAY x 0.5 = %.2f):" % Ability.BUFF_DELAY_CAP)
	for ab in touched:
		print("    %-26s %-18s delay %.2f  cd %d" % [ab.display_name, ab.special,
			ab.delay, ab.cooldown])

	# ---- §2: the fold reaching back into CR ----
	# CR accepted 40 buffs whose duration meets or exceeds its own cooldown, on
	# the reasoning that holding one costs an action and its resource every
	# cycle. At half delay that maintenance is half price. NOTHING IS CHANGED
	# HERE — the list is printed so the consequence surfaces now rather than in
	# an audit five batches from now.
	var cr_dur := _cr_duration_list()
	var both: Array = []
	for ab in touched:
		if cr_dur.has(ab.special):
			both.append(ab)
	print("\n  §2 — IN BOTH §1's POPULATION AND CR's DURATION LIST (%d), CHANGED: NONE" % both.size())
	for ab in both:
		var d: Array = cr_dur[ab.special]
		print("    %-26s duration %-9s cd %d   new delay %.2f" % [
			ab.display_name, String(d[0]), int(d[1]), ab.delay])

	_report()


# CR's duration list, as CQ's published census measured it and CR ruled on it:
# every fold whose duration meets or exceeds the ability's own cooldown. Held
# here as a RECORD of a ruling rather than as a live value — the durations are
# literals inside `_resolve_special`'s arms and the cooldowns are on the
# abilities, and §2 asks for the intersection, not for a re-derivation of CR.
func _cr_duration_list() -> Dictionary:
	return {
		"alms": ["4 turns", 4], "answering_steel": ["6 turns", 4],
		"battle_poise": ["4 turns", 4], "battle_trance": ["4 turns", 4],
		"blight_well": ["6 turns", 4], "bola": ["4 turns", 3],
		"cons_ground": ["3 turns", 3], "covering_guard": ["4 turns", 4],
		"discipline": ["7 turns", 5], "divine_presence": ["4 turns", 4],
		"divine_wrath": ["4 turns", 4], "ember_debt": ["12 turns", 4],
		"emberkeep": ["4 turns", 4], "fault_line": ["6 turns", 4],
		"feigned_guard": ["3 turns", 3], "frostbind": ["4 turns", 4],
		"hoarfrost_armor": ["4 turns", 4], "hunters_mark": ["6 turns", 4],
		"immolate": ["4 turns", 2], "ironclad": ["4 turns", 4],
		"mark_hunt": ["7 turns", 3], "null_field": ["4 turns", 4],
		"penance": ["4 turns", 4], "quickdraw": ["6 turns", 5],
		"recompense": ["6 turns", 4], "resonant_field": ["4 turns", 4],
		"retaliate": ["4 turns", 3], "rime": ["4 turns", 3],
		"shield_block": ["3 turns", 2], "slow_burn": ["4 turns", 4],
		"spite": ["6 turns", 4], "stalking_horse": ["4 turns", 4],
		"succession": ["6 turns", 4], "tripwire": ["6 turns", 4],
		"turn_the_blade": ["4 turns", 4], "umbral_sigil": ["4 turns", 4],
		"undying_vigil": ["4 turns", 4], "vespers": ["4 turns", 4],
		"vow_suffering": ["4 turns", 3], "zeal": ["4 turns", 2],
	}


# One party, one pass. `only` narrows the sweep to the cards a previous fixture
# could not reach, so the second party is charged for exactly the gap it exists
# to close.
#
# THE ASSERTION IS "NOTHING MOVED BUT A BUFF". Every enemy's health, resource
# and status set is snapshotted, every hero's health and resource with them,
# and the cast has to leave all of it standing. That is the walk §1 asks for,
# executed rather than read.
func _sweep(scene: Node, pure: Array, by_special: Dictionary,
		only: Array) -> Dictionary:
	var cast_n := 0
	var untested: Array = []
	var want := {}
	for nm in only:
		want[nm] = true
	for sp in pure:
		if not by_special.has(sp):
			continue
		var ab = by_special[sp]
		if not only.is_empty() and not want.has(ab.display_name):
			continue
		var caster: BattleUnit = null
		for h in scene.get("heroes"):
			if h.is_companion or h.dead:
				continue
			caster = h
			break
		if caster == null:
			untested.append(ab.display_name)
			continue
		# THE TARGET IS A REAL ONE. Most of this set carries `Target.ENEMY` on
		# the card and writes to the caster anyway — the player still picks an
		# enemy — so handing the cast an enemy is what the game does, and it is
		# what makes "nothing landed over there" worth asserting.
		var target: BattleUnit = null
		if ab.target == Ability.Target.ALLY:
			for h in scene.get("heroes"):
				if not h.dead and not h.is_companion and h != caster:
					target = h
					break
		else:
			for e in scene.get("enemies"):
				if not e.dead:
					target = e
					break
		if target == null:
			untested.append(ab.display_name)
			continue
		var before := _snapshot(scene)
		await scene._resolve_special(caster, ab, target, "good", 1.0)
		var after := _snapshot(scene)
		cast_n += 1
		for key in after:
			if before.get(key, null) == null:
				continue
			ok(str(before[key]) == str(after[key]),
				"%s moved %s: %s -> %s" % [ab.display_name, key,
					before[key], after[key]])
	scene.queue_free()
	return {"cast": cast_n, "untested": untested}


# What a pure buff may NOT move. Statuses on HEROES are deliberately absent —
# that is the payload. Everything else is here.
func _snapshot(scene: Node) -> Dictionary:
	var out := {}
	for e in scene.get("enemies"):
		out["enemy %s hp" % e.unit_name] = e.hp
		out["enemy %s resource" % e.unit_name] = e.resource
		var ids := PackedStringArray()
		for st in e.statuses:
			ids.append(String(st.get("id", "?")))
		ids.sort()
		out["enemy %s statuses" % e.unit_name] = ", ".join(ids)
	for h in scene.get("heroes"):
		out["hero %s hp" % h.unit_name] = h.hp
		out["hero %s resource" % h.unit_name] = h.resource
		out["hero %s second" % h.unit_name] = h.second_resource
		out["hero %s faith" % h.unit_name] = h.faith_stacks
	return out


# BATCH CZ §0 — THE ENUMERATION MOVED TO `Classes.ability_corpus()`.
#
# CY built the complete walk HERE, in a gate, because it needed the five
# abilities the Batch CL enumeration has always missed — Backdraft, Pyroblast,
# Glacial Prison, Cryoclasm and INTERCESSION, which is a pure buff a CL-only
# sweep would have left at full price. It reported the gap rather than closing
# it, and `check_cm`, `check_cn` and `check_co` each kept their own holed copy.
#
# CZ CLOSED IT AT THE SOURCE. The walk is one static function on `Classes` now
# and all four gates call it, so the corpus is 216 for every one of them. The
# grant-resolves assertion CY ran inline moved with it, into `check_cz.gd`,
# which walks `Classes.talent_granted_names()` and fails on any name that
# resolves to nothing.
func _corpus() -> Array:
	return Classes.ability_corpus()
