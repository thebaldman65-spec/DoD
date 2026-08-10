# test_batch_an.gd — the Batch AN scaffold gates. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_an.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE LINE (§1) — 3 zones x 12 slots, the authored shape, one way
#      forward, and every deleted piece of the branching map actually GONE
#      rather than merely unreferenced.
#   2. THE OFFER (§3) — three distinct modifiers, reward severity matched to
#      modifier severity, and THE FLOOR: every offer holds a 1 or a 2. That
#      last one is a promise about an unbounded number of future rolls, so
#      it is sampled hard rather than eyeballed.
#   3. THE MODIFIERS (§3) — all six stamp both parties in a live battle, and
#      each one does what its text says at the read site that implements it.
#   4. REWARDS (§4, §8) — mini-boss upgrades (stacking, never twice), zone
#      boss ability picks drawn from the SPEC pool only, the end boss ending
#      the run, and the 12-per-run point schedule.
#   5. SCHEDULING (§5, §7) — the 40% merchant with its four-slot floor, and
#      that the floor is a floor rather than a nudge.
#   6. ATTRITION (§6) — the 15% slot heal stacking with the relic hook, the
#      six-per-type item cap refusing rather than swallowing.
#   7. RUNES (§9) — three slots flat, no starting rune, no growth ladder.
extends SceneTree

var passed := 0
var failed := 0


func ok(cond: bool, msg: String) -> void:
	if cond:
		passed += 1
	else:
		failed += 1
		print("  FAIL: %s" % msg)


func _initialize() -> void:
	# Scene-spawning checks must wait for the first process frame: children
	# added in _initialize never fire _ready, because the root is not ready.
	# park scene-spawning work on the first process_frame — SceneTree
	# owns that signal, NOT root (a Window): awaiting root.process_frame
	# never returns and the run hangs with no output at all.
	process_frame.connect(_go, CONNECT_ONE_SHOT)


func _go() -> void:
	await _run_all()
	print("\nBATCH AN: %d passed, %d FAILED" % [passed, failed])
	quit(1 if failed > 0 else 0)


func _run_all() -> void:
	var RunState = load("res://scripts/run_state.gd")
	_test_line(RunState)
	_test_deletions(RunState)
	_test_offer(RunState)
	_test_rewards(RunState)
	_test_scheduling(RunState)
	_test_attrition(RunState)
	_test_runes(RunState)
	_test_glossary_terms()
	await _test_modifiers_live()
	await _test_companion_modifier()


# ---------- 1. the line (§1) ----------

func _test_line(RunState) -> void:
	print("\n§1 the line")
	var run = RunState.new()
	ok(run.SLOTS_PER_ZONE == 12, "a zone is 12 slots")
	ok(run.SLOT_COUNT == 3, "a run is 3 zones")
	ok(run.SLOTS_PER_ZONE * run.SLOT_COUNT == 36, "a run is 36 slots")
	ok(run.ZONE_SHAPE == ["fight", "fight", "elite", "fight", "fight",
		"miniboss", "fight", "fight", "elite", "fight", "fight", "boss"],
		"the authored shape is fight fight ELITE fight fight MINI-BOSS "
		+ "fight fight ELITE fight fight BOSS")
	ok(run.BOSS_SLOT == 11, "the boss is the last slot")
	run.new_run()
	ok(run.map.size() == 12, "a generated zone is 12 slots")
	ok(run.slot_idx == -1, "a fresh zone is not entered yet")
	# Every slot is a flat dict — no columns, no links.
	for s in run.map.size():
		var slot: Dictionary = run.map[s]
		ok(slot is Dictionary, "slot %d is one dict, not a row" % s)
		ok(not slot.has("links"), "slot %d carries no links" % s)
		ok(String(slot["type"]) == String(run.ZONE_SHAPE[s]),
			"slot %d is its authored type" % s)
		ok(slot.has("enemies") and not (slot["enemies"] as Array).is_empty(),
			"slot %d pre-rolled its warband at map birth" % s)
		ok(slot.has("theme"), "slot %d carries its theme for the hover card" % s)
	# One way forward, always, and nothing after the boss.
	for s in run.SLOTS_PER_ZONE:
		var reach: Array = run.reachable()
		ok(reach.size() == 1, "exactly one slot forward from %d" % (s - 1))
		ok(int(reach[0]) == s, "...and it is slot %d" % s)
		run.advance(int(reach[0]))
		ok(bool(run.map[s]["visited"]), "slot %d is marked cleared" % s)
	ok(run.reachable().is_empty(), "nothing follows the boss")
	ok(run.run_slot_number() == 12, "run position reads 12 of 36 at zone 1's boss")
	# Zone 2 replays the identical shape, from the top.
	run.advance_zone()
	ok(run.zone_idx == 1, "advance_zone steps the zone")
	ok(run.slot_idx == -1, "...and resets the position")
	var second: Array = []
	for s in run.map.size():
		second.append(String(run.map[s]["type"]))
	ok(second == run.ZONE_SHAPE, "zone 2 is the same twelve slots")
	run.advance(0)
	ok(run.run_slot_number() == 13, "run position reads 13 of 36 in zone 2")
	# The budget ramp reads the SLOT number and the boss keeps its band.
	for s in range(1, 12):
		var b: int = run.battle_budget(s)
		ok(b >= 3 and b <= 10, "slot %d budgets inside the ramp (%d)" % [s, b])
	for trial in 40:
		var bb: int = run.battle_budget(12)
		ok(bb >= 10 and bb <= 12, "the boss slot keeps its 10-12 band (%d)" % bb)
	ok(run.is_end_boss_slot(11) == false, "zone 2's boss is not the end boss")
	run.zone_idx = 2
	ok(run.is_end_boss_slot(11), "zone 3's boss IS the end boss")
	ok(not run.is_end_boss_slot(10), "...and nothing else is")
	run.free()


# ---------- the deletions (§1) ----------

func _test_deletions(RunState) -> void:
	print("\n§1 deletions")
	var run = RunState.new()
	# DELETED RATHER THAN LEFT UNREACHABLE. A constant that still resolves is
	# a constant a later batch will read by accident, which is exactly how
	# the 70%/53% link bug survived three batches.
	for gone in ["FLOORS", "NODES_PER_TIER", "FIGHT_NODES", "REST_NODES",
			"SHOP_NODES", "EVENT_NODES", "DECK_FALLBACK", "DECK_FALLBACK_MB",
			"MINIBOSS_TIER"]:
		ok(not (gone in run), "%s is deleted, not merely unused" % gone)
	for gone_fn in ["map_mode", "miniboss_on", "dealt_tiers", "grant_start_runes",
			"start_rune_enabled", "spec_opening_enabled", "award_talent_flex",
			"roll_ability_offer"]:
		ok(not run.has_method(gone_fn), "%s() is deleted" % gone_fn)
	# No rest slot can be generated, in any zone.
	run.new_run()
	for zone in 3:
		for s in run.map.size():
			ok(String(run.map[s]["type"]) != "rest",
				"zone %d slot %d is not a rest" % [zone + 1, s])
		if zone < 2:
			run.advance_zone()
	run.free()


# ---------- 2. the offer (§3) ----------

func _test_offer(RunState) -> void:
	print("\n§3 the offer")
	var run = RunState.new()
	run.new_run()
	# BATCH AQ authored the pool. The six AN placeholders are the first six
	# entries here and are asserted UNCHANGED — ids, severities and text —
	# because a save mid-run holds a pending modifier by id.
	var want := {"overgrown": 1, "tinderbox": 2, "frenzied": 2,
		"brittle": 3, "warded": 3, "bloodless": 4,
		"parched": 1, "slick": 1, "dulledge": 1, "muffled": 1, "hoarfrost": 1,
		"fleeting": 2, "feverish": 2, "deadened": 2, "miasma": 2,
		"thinair": 3, "encumbered": 3,
		"bloodletting": 4, "mirrorbound": 4,
		# BATCH BB §5 re-pointed this block IN PLACE: `rot` is AQ's authored
		# fourth severity-4 bargain and it SHIPS now, so the pool is twenty.
		"rot": 4}
	ok(run.MODIFIERS.size() == 20, "twenty authored modifiers (was six, then AQ's nineteen)")
	ok(run.MODIFIERS.size() == want.size(), "...and the test knows all of them")
	# The pool is WEIGHTED LOW on purpose: every offer's safe slot is served
	# by the 1-2 pool alone, so that is the end that actually repeats.
	var by_sev := {1: 0, 2: 0, 3: 0, 4: 0}
	for mid in run.MODIFIERS:
		by_sev[run.modifier_severity(String(mid))] += 1
	ok(by_sev[1] == 6, "six severity-1 modifiers (got %d)" % by_sev[1])
	ok(by_sev[2] == 6, "six severity-2 modifiers (got %d)" % by_sev[2])
	ok(by_sev[3] == 4, "four severity-3 modifiers (got %d)" % by_sev[3])
	ok(by_sev[4] == 4, "four severity-4 modifiers (got %d)" % by_sev[4])
	ok(by_sev[1] + by_sev[2] > by_sev[3] + by_sev[4],
		"the pool is weighted toward the low severities")
	# `rot` was authored by AQ and DROPPED there, because the battle-end sync
	# wrote max_hp back onto the party member and a halved maximum outlived the
	# fight that charged for it. BATCH BB §5 BUILT THE FIELD AQ NAMED, so the
	# assertion INVERTS rather than disappearing: what a later batch could break
	# is not "rot came back" but "rot came back without its guard", and
	# test_batch_bb owns that half.
	ok(run.MODIFIERS.has("rot"), "rot is in the pool (Batch BB reinstated it)")
	ok(run.modifier_severity("rot") == 4, "rot is severity 4")
	# The AN six, exactly as AN shipped them.
	ok(String(run.MODIFIERS["overgrown"]["desc"])
		== "Both parties begin the fight at 70% health.",
		"Overgrown's text is untouched")
	ok(String(run.MODIFIERS["bloodless"]["name"]) == "Bloodless",
		"Bloodless keeps its name")
	for id in want:
		ok(run.MODIFIERS.has(id), "%s exists" % id)
		ok(run.modifier_severity(id) == int(want[id]),
			"%s is severity %d" % [id, int(want[id])])
		ok(String(run.MODIFIERS[id]["desc"]) != "", "%s states its effect" % id)
	# Severity is FLAT: it must not read the party. Wreck the party and
	# confirm every severity is unmoved.
	for m in run.party:
		m["hp"] = 1
		m["spec"] = "berserker"
	for id2 in want:
		ok(run.modifier_severity(String(id2)) == int(want[id2]),
			"%s severity ignores party composition" % id2)
	# The reward table is keyed on severity and nothing else.
	ok(run.REWARDS[1].size() == 1, "severity 1 pays one way (40 gold)")
	ok(int(run.REWARDS[1][0]["amount"]) == 40, "...and it is 40 gold")
	ok(run.REWARDS[4].size() == 3, "severity 4 pays three ways")
	var sev4_kinds: Array = []
	for r in run.REWARDS[4]:
		sev4_kinds.append(String(r["kind"]))
	ok("shop" in sev4_kinds, "severity 4 can summon a merchant on demand")
	ok("rune" in sev4_kinds, "severity 4 can pay a rune")
	# 2000 offers: three DISTINCT modifiers, rewards matched to severity, THE
	# FLOOR (always at least one option of severity 1 or 2), and BATCH AQ §2 —
	# the other two slots come from the 3-4 pool alone, so no offer ever holds
	# two low options. Both are promises about an unbounded number of future
	# rolls, so they are sampled hard rather than eyeballed.
	var floor_misses := 0
	var two_low := 0
	var seen_mods := {}
	for trial in 2000:
		var offer: Array = run.roll_offer()
		ok(offer.size() == 3, "an offer holds three options")
		var ids := {}
		var low := 0
		for option in offer:
			var mid := String(option["modifier"])
			ids[mid] = true
			seen_mods[mid] = true
			var sev: int = run.modifier_severity(mid)
			if sev <= 2:
				low += 1
			# The reward must be one this severity is allowed to pay.
			var legal := false
			for allowed in run.REWARDS[sev]:
				if String(allowed["kind"]) == String(option["reward"]["kind"]):
					legal = true
			if not legal:
				ok(false, "%s (severity %d) paid a reward its tier does not allow: %s"
					% [mid, sev, option["reward"]])
		if ids.size() != 3:
			ok(false, "an offer repeated a modifier: %s" % offer)
		if low < 1:
			floor_misses += 1
		if low > 1:
			two_low += 1
	ok(floor_misses == 0,
		"EVERY offer holds a severity 1 or 2 (missed %d of 2000)" % floor_misses)
	ok(two_low == 0,
		"§2: NO offer holds two low options — one safe, two gambles (%d of 2000)"
		% two_low)
	ok(seen_mods.size() == run.MODIFIERS.size(),
		"all %d modifiers reach the offer screen over 2000 rolls (saw %d)"
		% [run.MODIFIERS.size(), seen_mods.size()])
	# Accepting arms exactly one battle's worth of state.
	var one: Array = run.roll_offer()
	run.accept_offer(one[0])
	ok(run.pending_modifier == String(one[0]["modifier"]), "accepting arms the modifier")
	ok(not run.pending_reward.is_empty(), "...and banks the reward")
	# Claiming pays, and CLEARS — nothing may leak into the next battle.
	var gold_before: int = run.gold
	run.pending_reward = {"kind": "gold", "amount": 100}
	var paid: Dictionary = run.claim_reward()
	ok(run.gold > gold_before, "a gold reward pays out")
	ok(String(paid["text"]) != "", "...and says so")
	ok(run.pending_modifier == "", "claiming clears the modifier")
	ok(run.pending_reward.is_empty(), "...and the reward")
	# The merchant reward resets the drought counter — the party HAS met one.
	run.slots_since_merchant = 3
	run.pending_reward = {"kind": "shop"}
	var shopped: Dictionary = run.claim_reward()
	ok(bool(shopped["shop"]), "the severity-4 merchant reward reports a merchant")
	ok(run.slots_since_merchant == 0, "...and resets the drought counter")
	run.free()


# ---------- 3. the modifiers, live (§3) ----------

func _test_modifiers_live() -> void:
	print("\n§3 the modifiers, in a live battle")
	var run: Node = root.get_node("/root/Run")
	run.sim_run = false
	# THE CONTROL, TAKEN FIRST. Every AQ modifier that edits a STAT rather
	# than writing a field (Slick, Dull Edge, Feverish, Encumbered, Miasma,
	# Parched) can only be checked as a DELTA, so the unmodified battle is
	# measured before any of them and every later spawn is compared against
	# it. The lineup and the warband are fixed, so index i is the same unit
	# in every spawn.
	var clean := await _spawn_battle(run, "")
	var base: Array = []
	if clean != null:
		for u in clean.heroes + clean.enemies:
			var delays := {}
			var cds := {}
			for ab in u.abilities:
				delays[ab.display_name] = ab.delay
				cds[ab.display_name] = ab.cooldown
			base.append({"crit": u.crit_bonus, "attack": u.attack,
				"hrm": u.healing_received_mult, "res": u.resource,
				"maxres": u.max_resource, "second": u.second_resource,
				"second_max": u.second_max, "second_name": u.second_resource_name,
				"delays": delays, "cds": cds})
		# NO modifier = the pre-AN path, byte for byte. This is the check that
		# catches a stamp leaking out of the battle that armed it.
		for u in clean.heroes + clean.enemies:
			ok(not u.mod_ignore_armor, "no modifier: armor is untouched")
			ok(is_equal_approx(u.mod_speed_mult, 1.0), "no modifier: speed is untouched")
			ok(is_equal_approx(u.mod_cost_mult, 1.0), "no modifier: costs are untouched")
			ok(not u.mod_no_heals, "no modifier: healing is untouched")
			ok(u.mod_bd_mult == 100, "no modifier: Break damage is untouched")
			ok(u.mod_status_turns == 0, "no modifier: status durations are untouched")
			ok(not u.mod_no_break, "no modifier: the Break meter still works")
			ok(not u.mod_no_regen, "no modifier: the resource drip still runs")
			ok(u.mod_bleed_add == 0, "no modifier: no free Bleed")
			ok(is_equal_approx(u.mod_recoil, 0.0), "no modifier: no recoil")
			ok(is_equal_approx(float(u.type_dmg_bonus.get("fire", 0.0)), 0.0),
				"no modifier: fire damage is untouched")
			ok(u.hp == u.max_hp, "no modifier: everyone opens at full health")
			ok(not u.has_status("chilled"), "no modifier: nobody opens Chilled")
		clean.free()
	else:
		ok(false, "the control battle failed to spawn")
	# Every modifier is checked on BOTH parties — "applies to both parties"
	# is the load-bearing half of the design and the easiest thing to get
	# half-right.
	var expectations := {
		"overgrown": "hp",
		"tinderbox": "fire",
		"frenzied": "speed",
		"brittle": "armor",
		"warded": "cost",
		"bloodless": "heal",
		"parched": "resource",
		"slick": "delay",
		"dulledge": "crit",
		"muffled": "bd",
		"hoarfrost": "chilled",
		"fleeting": "status_turns",
		"feverish": "attack",
		"deadened": "no_break",
		"miasma": "half_heal",
		"thinair": "no_regen",
		"encumbered": "cooldown",
		"bloodletting": "bleed",
		"mirrorbound": "recoil",
	}
	for mod_id in expectations:
		var battle := await _spawn_battle(run, mod_id)
		if battle == null:
			ok(false, "%s: battle failed to spawn" % mod_id)
			continue
		var everyone: Array = battle.heroes + battle.enemies
		ok(everyone.size() >= 5, "%s: both parties are on the field" % mod_id)
		match String(expectations[mod_id]):
			"hp":
				for u in everyone:
					ok(u.hp <= int(round(u.max_hp * 0.7)) + 1,
						"Overgrown: %s opens at or under 70%% (%d/%d)" % [
							u.unit_name, u.hp, u.max_hp])
					ok(u.hp > 0, "Overgrown never kills anyone outright")
			"fire":
				for u in everyone:
					ok(is_equal_approx(float(u.type_dmg_bonus.get("fire", 0.0)), 0.25),
						"Tinderbox: %s deals +25%% fire" % u.unit_name)
			"speed":
				for u in everyone:
					ok(is_equal_approx(u.mod_speed_mult, 1.3),
						"Frenzied: %s acts 30%% faster" % u.unit_name)
					ok(is_equal_approx(u.effective_speed(), u.speed * 1.3),
						"...and effective_speed reads it")
			"armor":
				for u in everyone:
					ok(u.mod_ignore_armor, "Brittle: %s is stamped" % u.unit_name)
					ok(is_equal_approx(u.effective_armor(), 0.0),
						"Brittle: %s's armor is ignored entirely" % u.unit_name)
			"cost":
				for u in everyone:
					ok(is_equal_approx(u.mod_cost_mult, 1.25),
						"Warded: %s pays 25%% more" % u.unit_name)
				# The costed/free split, on a real kit.
				for h in battle.heroes:
					for ab in h.abilities:
						var eff: int = battle._eff_cost(h, ab)
						if ab.cost > 0:
							ok(eff > ab.cost or ab.cost == 0,
								"Warded: %s costs more than %d (got %d)" % [
									ab.display_name, ab.cost, eff])
						else:
							ok(eff == 0,
								"Warded: the free %s stays free" % ab.display_name)
			"heal":
				for u in everyone:
					ok(u.mod_no_heals, "Bloodless: %s cannot be healed" % u.unit_name)
					var was: int = u.hp
					u.hp = maxi(u.hp - 30, 1)
					var hurt: int = u.hp
					ok(u.heal_amount(50) == 0,
						"Bloodless: a 50-point heal on %s lands 0" % u.unit_name)
					ok(u.hp == hurt, "...and the health bar does not move")
					u.hp = was
			# ---- Batch AQ's thirteen ----
			"resource":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					var b: Dictionary = base[i]
					ok(u.resource <= int(b["maxres"]) / 2,
						"Parched: %s opens at or under half resource (%d of %d)" % [
							u.unit_name, u.resource, u.max_resource])
					if String(b["second_name"]) != "":
						ok(u.second_resource <= int(b["second_max"]) / 2,
							"Parched: %s's %s is halved too" % [u.unit_name,
								b["second_name"]])
					# Overgrown's lesson: it must never top a low tank UP.
					u.resource = 1
					battle._stamp_modifier(u, "parched")
					ok(u.resource == 1,
						"Parched never REFILLS %s — it only ever takes" % u.unit_name)
			"delay":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					var was_delays: Dictionary = base[i]["delays"]
					for ab in u.abilities:
						if not was_delays.has(ab.display_name):
							continue
						ok(is_equal_approx(ab.delay,
							float(was_delays[ab.display_name]) + 0.5),
							"Slick Footing: %s's %s costs +0.5 initiative" % [
								u.unit_name, ab.display_name])
			"crit":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					ok(is_equal_approx(u.crit_bonus,
						maxf(float(base[i]["crit"]) - 0.05, -0.10)),
						"Dull Edge: %s loses 5 points of crit" % u.unit_name)
					ok(0.10 + u.crit_bonus >= 0.0,
						"Dull Edge: %s's total crit chance never goes negative"
						% u.unit_name)
			"bd":
				for u in everyone:
					ok(u.mod_bd_mult == 75, "Muffled: %s is stamped" % u.unit_name)
					# Driven at the read site. Constitution is normalised first
					# so the assertion reads the modifier and not the stat.
					u.constitution = 100
					u.pressure = 0
					u.broken = false
					u.take_hit(0, 40)
					ok(u.pressure == 30,
						"Muffled: 40 Break damage on %s lands 30 (got %d)" % [
							u.unit_name, u.pressure])
			"chilled":
				for u in everyone:
					ok(u.has_status("chilled"),
						"Hoarfrost: %s begins the fight Chilled" % u.unit_name)
					ok(u.status_stacks("chilled") == 1,
						"...one stack, not a free Freeze")
					ok(u.effective_speed() < u.speed,
						"...and effective_speed reads it (%s)" % u.unit_name)
					ok(not u.get_status("chilled").is_empty()
						and int(u.get_status("chilled")["turns"]) == 3,
						"...for three turns")
			"status_turns":
				for u in everyone:
					ok(u.mod_status_turns == -1,
						"Fleeting: %s is stamped" % u.unit_name)
					u.remove_status("exposed")
					battle._apply_status(u, "exposed", 3)
					ok(int(u.get_status("exposed").get("turns", 0)) == 2,
						"Fleeting: a 3-turn status on %s lands as 2" % u.unit_name)
					u.remove_status("exposed")
					battle._apply_status(u, "exposed", 1)
					ok(int(u.get_status("exposed").get("turns", 0)) == 1,
						"Fleeting: a 1-turn status never falls below 1")
					u.remove_status("exposed")
					# Battle-long statuses are a PERMANENCE FLAG, not a
					# duration — shortening one would make it last a turn.
					u.add_status("sunder", "Sundered", "S", Color.WHITE, -1)
					ok(int(u.get_status("sunder").get("turns", 0)) == -1,
						"Fleeting: a battle-long status on %s stays battle-long"
						% u.unit_name)
					u.remove_status("sunder")
			"attack":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					ok(u.attack == int(round(float(base[i]["attack"]) * 1.25)),
						"Feverish: %s hits 25%% harder (%d, was %d)" % [
							u.unit_name, u.attack, int(base[i]["attack"])])
			"no_break":
				for u in everyone:
					ok(u.mod_no_break, "Deadened: %s is stamped" % u.unit_name)
					u.pressure = 0
					u.broken = false
					u.take_hit(0, 500)
					ok(u.pressure == 0,
						"Deadened: 500 Break damage moves %s's meter not at all"
						% u.unit_name)
					ok(not u.broken, "...and nobody Breaks")
			"half_heal":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					ok(is_equal_approx(u.healing_received_mult,
						float(base[i]["hrm"]) * 0.5),
						"Miasma: %s's healing multiplier is halved" % u.unit_name)
					u.hp = maxi(u.hp - 200, 1)
					var landed: int = u.heal_amount(100)
					ok(landed == int(round(100.0 * u.healing_received_mult)),
						"Miasma: a 100-point heal on %s lands %d" % [
							u.unit_name, landed])
					ok(landed > 0 and landed < 100,
						"...halved, not refused — Bloodless tops this ladder")
			"no_regen":
				for u in everyone:
					ok(u.mod_no_regen, "Thin Air: %s is stamped" % u.unit_name)
				# The read site is inline in _player_turn, which cannot be
				# driven without a live hero turn — so the GUARD is asserted
				# in the source instead. A refactor that moves the drip out
				# from under it trips this.
				_source_has("res://scripts/battle.gd", "if not u.mod_no_regen:",
					"Thin Air: the turn-start drip sits under the guard")
			"cooldown":
				for i in everyone.size():
					var u: BattleUnit = everyone[i]
					var was_cds: Dictionary = base[i]["cds"]
					for ab in u.abilities:
						if not was_cds.has(ab.display_name):
							continue
						var before: int = int(was_cds[ab.display_name])
						if before > 0:
							ok(ab.cooldown == before + 2,
								"Encumbered: %s's %s costs 2 more turns" % [
									u.unit_name, ab.display_name])
						else:
							ok(ab.cooldown == 0,
								"Encumbered: the cooldown-free %s gains none" %
								ab.display_name)
			"bleed":
				for u in everyone:
					ok(u.mod_bleed_add == 15,
						"Bloodletting: %s is stamped" % u.unit_name)
				_source_has("res://scripts/battle.gd",
					"bleed_amount += attacker.mod_bleed_add",
					"Bloodletting: the on-hit bleed site reads the field")
				# Bleedout still triggers at 100 by the existing rule.
				var bleeder: BattleUnit = everyone[0]
				bleeder.bleed_buildup = 0
				ok(not bleeder.add_bleed(99), "Bloodletting: 99 Bleed does not burst")
				ok(bleeder.add_bleed(15), "...and crossing 100 does")
			"recoil":
				for u in everyone:
					ok(is_equal_approx(u.mod_recoil, 0.25),
						"Mirrorbound: %s is stamped" % u.unit_name)
				_source_has("res://scripts/battle.gd",
					"recoil_pct += attacker.mod_recoil",
					"Mirrorbound: the recoil site reads the field")
				# The backlash is paid through take_tick_damage, which is not a
				# strike — so recoil can never itself recoil.
				_source_has("res://scripts/battle.gd",
					"var recoil_died := attacker.take_tick_damage(recoil,",
					"Mirrorbound: recoil is paid as tick damage, so it cannot recoil")
		battle.free()


# ---------- Batch AQ §4: the companion the modifier used to miss ----------

func _test_companion_modifier() -> void:
	print("\n§4 a summoned beast is bound by the bargain")
	var run: Node = root.get_node("/root/Run")
	run.sim_run = false
	# Hoarfrost is the sharpest probe: _apply_battle_modifier walks
	# heroes + enemies, and a beast exists at neither moment, so before the
	# summon-site fix it was the ONE unit on the field not Chilled.
	var battle := await _spawn_battle(run, "hoarfrost",
		["berserker", "pyromancer", "holy", "beastmaster"])
	if battle == null:
		ok(false, "companion probe: battle failed to spawn")
		return
	var hunter: BattleUnit = null
	for h in battle.heroes:
		if h.hero_key == "hunter":
			hunter = h
	if hunter == null:
		ok(false, "companion probe: no Beastmaster on the field")
		battle.free()
		return
	battle.sim = true  # skips the pacing timers; the summon itself is unchanged
	await battle._do_summon(hunter, "ursus")
	var beasts: Array = battle._beasts(hunter)
	ok(beasts.size() == 1, "the Beastmaster fields one beast")
	if beasts.size() == 1:
		var beast: BattleUnit = beasts[0]
		ok(beast.has_status("chilled"),
			"§4: the summoned beast arrives Chilled like everyone else")
		ok(beast.effective_speed() < beast.speed,
			"...and the chill is real, not a chip")
	battle.free()
	# The two the summon site already inherited, stated so a future reader
	# does not "fix" them into a double application: the beast copies the
	# hunter's Attack and crit, and those already carry Feverish / Dull Edge.
	var fev := await _spawn_battle(run, "feverish",
		["berserker", "pyromancer", "holy", "beastmaster"])
	if fev != null:
		var fh: BattleUnit = null
		for h in fev.heroes:
			if h.hero_key == "hunter":
				fh = h
		if fh != null:
			fev.sim = true
			await fev._do_summon(fh, "canis")
			var fb: Array = fev._beasts(fh)
			if fb.size() == 1:
				ok(fb[0].attack == fh.attack,
					"§4: the beast inherits the hunter's Feverish Attack, once")
				ok(is_equal_approx(fb[0].crit_bonus, fh.crit_bonus),
					"...and his crit, once")
		fev.free()


# ---------- Batch AQ §5D: the four glossary terms ----------

func _test_glossary_terms() -> void:
	print("\n§5D the glossary learns the bargain")
	var want := {
		"ability_upgrades": "progression",
		"bargain": "run",
		"modifier": "run",
		"severity": "run",
	}
	var ids := {}
	for e in Glossary.entries():
		ids[String(e["id"])] = true
	for id in want:
		var entry: Dictionary = Glossary.entry(String(id))
		ok(not entry.is_empty(), "glossary has '%s'" % id)
		if entry.is_empty():
			continue
		ok(String(entry["category"]) == String(want[id]),
			"'%s' is filed under %s" % [id, want[id]])
		ok(String(entry["short"]) != "" and String(entry["long"]) != "",
			"'%s' says something" % id)
		# Cross-linked to each other, and every link resolves.
		ok(not (entry.get("see_also", []) as Array).is_empty(),
			"'%s' cross-links" % id)
		for link in entry.get("see_also", []):
			ok(ids.has(String(link)),
				"'%s' links to a real entry (%s)" % [id, link])
	# The bargain trio names each other — a system with nineteen faces needs
	# one place that explains the system.
	ok("modifier" in Glossary.entry("bargain").get("see_also", []),
		"the Bargain entry points at Modifier")
	ok("severity" in Glossary.entry("bargain").get("see_also", []),
		"...and at Severity")


# Reads a source file and asserts a needle is in it. Used for the three AQ
# fields whose read site is INLINE in a function that cannot be called
# without a live hero turn or a full strike resolution — the field assert
# alone would pass on code that never reads it.
func _source_has(path: String, needle: String, msg: String) -> void:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		ok(false, "%s (cannot open %s)" % [msg, path])
		return
	ok(f.get_as_text().contains(needle), msg)


func _spawn_battle(run: Node, mod_id: String,
		specs := ["berserker", "pyromancer", "holy", "sharpshooter"]) -> Node:
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = String(specs[i])
		run.party[i]["tree"] = Talents.generate_tree(run.party[i]["spec"],
			run.party[i]["key"])
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.pending_modifier = mod_id
	run.encounter = {"type": "fight", "enemies": ["raider", "archer", "shaman"],
		"theme": "Warband"}
	var battle: Node = (load("res://scenes/battle.tscn") as PackedScene).instantiate()
	root.add_child(battle)  # _ready spawns units, then parks on its first await
	for _i in 4:
		await process_frame
	return battle


# ---------- 4. the rewards (§4, §8) ----------

func _test_rewards(RunState) -> void:
	print("\n§4/§8 rewards")
	var run = RunState.new()
	run.new_run()
	for m in run.party:
		m["spec"] = "berserker"
		m["tree"] = Talents.generate_tree("berserker", "warrior")
	# The point schedule: 1 apiece from elite / mini-boss / boss, 0 from
	# fights, and the END boss pays too (it used to pay nothing).
	ok(run.award_talent_points("fight") == 0, "an ordinary fight pays no point")
	ok(run.award_talent_points("elite") == 1, "an elite pays 1")
	ok(run.award_talent_points("miniboss") == 1, "a mini-boss pays 1")
	ok(run.award_talent_points("boss") == 1, "a zone boss pays 1")
	run.zone_idx = 2
	ok(run.award_talent_points("boss") == 1, "the END boss pays 1 as well")
	var per_zone := 0
	for ty in run.ZONE_SHAPE:
		if String(ty) in ["elite", "miniboss", "boss"]:
			per_zone += 1
	ok(per_zone == 4, "4 point-paying slots a zone")
	ok(per_zone * run.SLOT_COUNT == 12, "12 a run, against an 8-node tree")
	run.zone_idx = 0
	# THE MINI-BOSS: a generic ability upgrade, chosen from three.
	ok(run.ABILITY_UPGRADES.size() == 4, "a placeholder pool of four upgrades")
	var hero: Dictionary = run.party[0]
	var up_offer: Array = run.roll_upgrade_offer(hero)
	ok(up_offer.size() == 3, "the mini-boss offers three upgrades")
	for entry in up_offer:
		ok(run.ABILITY_UPGRADES.has(String(entry["id"])), "each is a real upgrade")
		ok(String(entry["ability"]) != "", "...attached to a named ability")
		ok(String(entry["ability"]) != "Strike",
			"...and never to the basic attack")
	ok(run.award_upgrade_pick(hero), "the award queues")
	ok(int(hero.get("up_picks_owed", 0)) == 1, "...owing one pick")
	ok((hero.get("up_candidates", []) as Array).size() == 1,
		"...with its three banked in the same call")
	# UPGRADES STACK on one ability; the SAME upgrade never comes twice.
	hero["upgrades"] = [{"id": "up_damage", "ability": "Overpower"}]
	ok(run.has_upgrade(hero, "up_damage"), "a taken upgrade is remembered")
	for trial in 200:
		var later: Array = run.roll_upgrade_offer(hero)
		for entry2 in later:
			ok(String(entry2["id"]) != "up_damage",
				"a taken upgrade is never re-offered")
	# Two DIFFERENT upgrades on the same ability is legal — that is stacking.
	hero["upgrades"] = [{"id": "up_damage", "ability": "Overpower"},
		{"id": "up_free", "ability": "Overpower"}]
	ok(not run.has_upgrade(hero, "up_speed"), "an untaken upgrade stays available")
	var stacked: Array = run.roll_upgrade_offer(hero)
	ok(stacked.size() == 2, "the offer shrinks as the pool empties (got %d)"
		% stacked.size())
	# ZONE BOSSES: the ability pick is SPEC-POOL ONLY now.
	var spec_pool: Array = Classes.spec_pool("berserker")
	var class_pool: Array = Classes.class_pool("warrior")
	var class_only: Array = class_pool.filter(func(n): return not spec_pool.has(n))
	ok(not class_only.is_empty(), "the warrior class pool holds spec-foreign entries")
	for trial2 in 300:
		var ab_offer: Array = run.roll_spec_ability_offer(run.party[1])
		for n in ab_offer:
			ok(spec_pool.has(n), "%s is in the spec pool" % n)
			ok(not class_only.has(n), "%s never arrives via the class pool" % n)
	run.free()


# ---------- 5. scheduling (§5, §7) ----------

func _test_scheduling(RunState) -> void:
	print("\n§5/§7 scheduling")
	var run = RunState.new()
	run.new_run()
	ok(is_equal_approx(run.MERCHANT_CHANCE, 0.40), "the merchant rolls at 40%")
	ok(run.MERCHANT_FLOOR == 4, "the floor is four dry slots")
	ok(is_equal_approx(run.EVENT_CHANCE, 0.25), "events roll at 25%")
	# Mini-bosses and bosses schedule nothing — §5 and §7 say "fight or
	# elite", and a merchant after a zone boss would land after the zone.
	for ty in ["miniboss", "boss"]:
		var any := false
		for trial in 400:
			run.slots_since_merchant = 0
			if run.roll_merchant(ty) or run.roll_event(ty):
				any = true
		ok(not any, "a %s slot schedules nothing" % ty)
	# THE FLOOR IS A FLOOR: four cleared slots without a merchant and the
	# fifth is guaranteed. Driven rather than sampled — the guarantee is
	# about the worst case, and sampling only ever sees the average.
	run.slots_since_merchant = 0
	var forced := 0
	for trial2 in 2000:
		run.slots_since_merchant = run.MERCHANT_FLOOR
		if run.roll_merchant("fight"):
			forced += 1
	ok(forced == 2000, "at the floor the merchant is GUARANTEED (%d of 2000)" % forced)
	# ...and a merchant resets the counter, so the drought restarts.
	run.slots_since_merchant = run.MERCHANT_FLOOR
	run.roll_merchant("fight")
	ok(run.slots_since_merchant == 0, "meeting a merchant resets the drought")
	# The gap between merchants can never exceed the floor.
	run.slots_since_merchant = 0
	var gap := 0
	var worst := 0
	for trial3 in 4000:
		if run.roll_merchant("fight"):
			worst = maxi(worst, gap)
			gap = 0
		else:
			gap += 1
	ok(worst <= run.MERCHANT_FLOOR,
		"no drought ever runs past %d slots (worst was %d)" % [run.MERCHANT_FLOOR, worst])
	# The rate itself sits near 40% once the floor is excluded — a sanity
	# band, not a tight assertion, because the floor lifts the mean.
	run.slots_since_merchant = 0
	var hits := 0
	for trial4 in 4000:
		if run.roll_merchant("fight"):
			hits += 1
	var rate := hits / 4000.0
	ok(rate > 0.35 and rate < 0.60,
		"the merchant rate lands in band with the floor lifting it (%.2f)" % rate)
	run.free()


# ---------- 6. attrition (§6) ----------

func _test_attrition(RunState) -> void:
	print("\n§6 attrition")
	var run = RunState.new()
	run.new_run()
	ok(is_equal_approx(run.SLOT_HEAL_PCT, 0.15), "clearing a slot heals 15%")
	ok(is_equal_approx(run.victory_heal_pct(), 0.15), "with no relic, 15%")
	# The Chalice's 10% STACKS on top, through the hook it already used.
	run.active_relics = ["chalice"]
	ok(is_equal_approx(run.victory_heal_pct(), 0.25),
		"the Chalice of Dawn stacks to 25%% (got %.2f)" % run.victory_heal_pct())
	run.active_relics = []
	# The heal is a heal: it never overshoots the maximum.
	for m in run.party:
		m["hp"] = int(m["max_hp"]) - 1
	run.heal_party(run.victory_heal_pct())
	for m in run.party:
		ok(int(m["hp"]) == int(m["max_hp"]), "the slot heal never overshoots max HP")
	# THE ITEM CAP: six per type, refused rather than swallowed.
	ok(run.ITEM_CAP == 6, "the cap is six per item type")
	run.items = {}
	ok(run.add_item("health", 4) == 4, "four potions land")
	ok(run.add_item("health", 4) == 2, "...and only two of the next four fit")
	ok(int(run.items["health"]) == 6, "the stack tops out at six")
	ok(run.item_full("health"), "...and reports itself full")
	ok(run.add_item("health") == 0, "a further drop is REFUSED, reporting 0")
	ok(int(run.items["health"]) == 6, "...and the stack does not move")
	ok(not run.item_full("bomb"), "the cap is PER TYPE — bombs are unaffected")
	ok(run.add_item("bomb", 6) == 6, "...and a second type fills independently")
	# A relic that hands out start items cannot break the cap either.
	run.new_run(["warrior", "mage", "cleric", "hunter"], ["packcharm"], "standard")
	for id in run.items:
		ok(int(run.items[id]) <= run.ITEM_CAP,
			"relic start items respect the cap (%s = %d)" % [id, int(run.items[id])])
	run.free()


# ---------- 7. runes (§9) ----------

func _test_runes(RunState) -> void:
	print("\n§9 runes")
	var run = RunState.new()
	run.new_run()
	# THREE SLOTS, FLAT, FROM RUN START. No growth ladder.
	for zone in 3:
		run.zone_idx = zone
		ok(run.rune_slots() == 3, "zone %d still has 3 slots" % [zone + 1])
	run.zone_idx = 0
	# HEROES START WITH NO RUNES and empty slots.
	for m in run.party:
		ok((m.get("runes", []) as Array).is_empty(), "a hero starts with no runes")
		ok(int(m.get("rune_picks_owed", 0)) == 0, "...and owes no opening pick")
		ok(not m.has("start_rune_granted"), "...and carries no start-rune marker")
	# The elite triple still rolls, and still never repeats inside itself.
	run.party[0]["spec"] = "berserker"
	for trial in 400:
		var triple: Array = run.roll_rune_candidates(run.party[0])
		if triple.is_empty():
			continue
		ok(triple.size() == 3, "an elite cache offers three")
		var names := {}
		for c in triple:
			names[String(c["name"])] = true
		ok(names.size() == 3, "...with no duplicate inside the triple")
	run.free()
