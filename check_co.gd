# BATCH CO — the invariant gate. The table in `battle.gd` names 58 abilities
# whose WHOLE payload is a status application, and a table of that size rots the
# moment a handler changes its duration, its power or its target pool. So this
# gate does not read the table against another table: it SPAWNS A REAL BATTLE,
# casts each of the 58 through `_resolve_special`, and asserts the gate's own
# prediction against what actually landed on the actual units.
#
# THE NEGATIVE HALF IS THE HALF THAT MATTERS. A gate that can only pass is a
# gap, so §2's excluded cards are asserted OUT of the set by name: Funeral Pyre,
# Stabilize, Battle Shout, Reckless Abandon and Blessing of Zeal each carry a
# second payload, and a later batch quietly adding one of them would make the
# refusal delete a resource conversion the player wanted.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_co.gd
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

# Cards whose payload is NOT only the status, verified by walking
# `_resolve_special`: each does something a refusal would destroy.
const MUST_NOT_GATE := {
	"funeral_pyre": "pays `_overburn_refund` — the Burn it eats returns as Mana",
	"stabilize": "vents Resonance into Mana and heals 5% of maximum health",
	"battle_shout": "hands the caster +5 Rage",
	"reckless_abandon": "spends the whole Rage bar",
	"zeal": "ticks cooldowns down through Crusade",
	"divine_plea": "heals and purges",
	"jubilee": "spends Faith, heals and returns Mana",
	"harvest": "damages and heals",
	"kill_command": "orders a companion strike",
	"preparation": "buys an extra turn",
}

# INTERPOSE IS THE ONE MEMBER THAT CAN NEVER REFUSE, and it is named here rather
# than left to look like a failure. Its charges are ADDITIVE (`held + grant`), so
# a second cast always improves and the rule correctly never fires. Divine Shield
# under LAYERED FAITH is the same shape for the same reason, which is exactly why
# §2 says that bespoke path is not subsumed.
const ALWAYS_IMPROVES := ["interpose"]

var _g := Gate.new()


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260818)
	var battle_gd := load("res://scripts/battle.gd")
	var gated: Array = battle_gd.RECAST_GATED
	var plain: Dictionary = battle_gd.RECAST_SELF_PLAIN
	var self_only: Array = battle_gd.RECAST_SELF_ONLY
	print("BATCH CO — %d GATED ABILITIES" % gated.size())

	# ---- the table's own shape ----
	var seen_dupe := {}
	for sp in gated:
		if seen_dupe.has(sp):
			ok(false, "`%s` appears twice in RECAST_GATED" % sp)
		seen_dupe[sp] = true
	for sp in plain:
		ok(gated.has(sp), "RECAST_SELF_PLAIN names `%s`, which is not gated" % sp)
	for sp in self_only:
		ok(gated.has(sp), "RECAST_SELF_ONLY names `%s`, which is not gated" % sp)
	for sp in plain:
		ok(not self_only.has(sp),
			"`%s` is in BOTH self tables — one of them is dead" % sp)

	# ---- the scope limit, against the live corpus ----
	var corpus := _corpus()
	var used := {}
	for ab in corpus:
		if ab.special != "":
			used[ab.special] = true
	for sp in gated:
		ok(used.has(sp), "RECAST_GATED names `%s`, which no ability uses" % sp)
	for sp in MUST_NOT_GATE:
		ok(not gated.has(sp), "`%s` is gated but %s" % [sp, MUST_NOT_GATE[sp]])
	# The mechanical half of the scope limit: a refusable ability cannot be one
	# whose fields already prove it does something besides the status.
	for ab in corpus:
		if not gated.has(ab.special):
			continue
		ok(ab.damage <= 0 and ab.pressure <= 0 and ab.heal <= 0 \
			and ab.heal_missing <= 0.0,
			"%s is gated and carries damage/BD/heal on its own fields" % ab.display_name)

	# ---- the live half ----
	var by_special := {}
	for ab in corpus:
		if ab.special != "" and not by_special.has(ab.special):
			by_special[ab.special] = ab

	# TWO FIXTURES, AND THE SECOND ONE IS NOT OPTIONAL. Half this set reads the
	# caster's own sheet, and no single party can write all of it: ALMS and
	# DIVINE PRESENCE need MERCY (the Holy Cleric) while MANTLE needs a living
	# DEVOUT (`inquisitor`) for `_living_devout` to answer. A one-party sweep
	# reports the cards it cannot reach as "untested", which is the fixture's
	# limit quietly reading as coverage.
	var first := await _sweep(await Gate.spawn(self, ["warden", "pyromancer", "holy",
		"beastmaster"]), gated, by_special, [])
	var second := await _sweep(await Gate.spawn(self, ["warden", "pyromancer",
		"inquisitor", "beastmaster"]), gated, by_special, first["untested"])
	var refused_after: int = int(first["refused"]) + int(second["refused"])
	var untested: Array = second["untested"]
	print("  refused after saturation: %d of %d" % [refused_after, gated.size()])
	if not untested.is_empty():
		print("  not exercised live (%d): %s" % [untested.size(),
			", ".join(PackedStringArray(untested))])
	_report()


# One party, one pass. `only` narrows the sweep to the cards a previous fixture
# could not write, so the second party is charged for exactly the gap it exists
# to close rather than re-proving the first party's work.
func _sweep(scene: Node, gated: Array, by_special: Dictionary,
		only: Array) -> Dictionary:
	var refused_after := 0
	var untested: Array = []
	var want := {}
	for nm in only:
		want[nm] = true
	var bodies: Array = scene.get("heroes") + scene.get("enemies")
	for sp in gated:
		if not by_special.has(sp):
			continue
		var ab = by_special[sp]
		if not only.is_empty() and not want.has(ab.display_name):
			continue
		# A CLEAN BOARD PER ABILITY. `barrier` is a SHARED status with three
		# writers in the set (Magic Barrier, Divine Shield, Mantle), so without
		# this the first one to run saturates the other two and they report as
		# untested — which is the fixture lying, not the rule failing.
		for b in bodies:
			b.statuses.clear()
		# THE CASTER IS CHOSEN PER CARD rather than fixed, because half this set
		# reads the caster's own sheet: Alms and Divine Presence write nothing
		# without MERCY, and Mantle writes nothing without a living Devout. A
		# single caster would leave those three silently unexercised.
		var caster: BattleUnit = null
		for h in scene.get("heroes"):
			if h.is_companion or h.dead:
				continue
			var proposes := false
			for t in scene._recast_targets(h, ab):
				if not scene._recast_writes(h, ab, t).is_empty():
					proposes = true
					break
			if proposes and not bool(scene._recast_refused(h, ab)):
				caster = h
				break
		if caster == null:
			untested.append(ab.display_name)
			continue
		var pool: Array = scene._recast_targets(caster, ab)
		# Cast it onto EVERY unit it could touch. A picked-target card is not
		# saturated until every legal pick holds it, and a gate that darkened the
		# button while a second enemy stood clean would be the wrong refusal.
		for t in pool:
			if t.dead:
				continue
			await scene._resolve_special(caster, ab, t, "good", 1.0)
		var still: bool = scene._recast_refused(caster, ab)
		if sp in ALWAYS_IMPROVES:
			ok(not still, "%s is additive and must never refuse" % ab.display_name)
			continue
		ok(still, "%s still casts after landing on every target it can reach" %
			ab.display_name)
		if still:
			refused_after += 1
			# §3 — the refusal has to SAY why and NAME the thing.
			var note: String = scene._recast_refusal_note(caster, ab)
			ok(note != "", "%s refuses with no reason given" % ab.display_name)

	scene.queue_free()
	return {"refused": refused_after, "untested": untested}


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)


# BATCH CZ §0 — THE ENUMERATION IS `Classes.ability_corpus()` NOW, AND THIS
# GATE NO LONGER CARRIES A COPY OF IT. The copy it used to carry was the Batch
# CL walk, which reaches the kits, the class pools and the spec pools and MISSES
# the five abilities a talent node grants into no pool at all (Backdraft,
# Pyroblast, Glacial Prison, Cryoclasm, Intercession). Four gates held four
# copies of the same hole; there is one enumeration now and it reaches 216.
func _corpus() -> Array:
	return Classes.ability_corpus()
