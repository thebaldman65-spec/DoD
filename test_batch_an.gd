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


# ---------- 1. the map (§1, SUPERSEDED BY BATCH BK) ----------

# BATCH BK REPLACED AN'S LINE WITH A GENERATED 3-ROW LATTICE, so everything
# this function used to assert about the twelve authored slots is now false by
# design: SLOTS_PER_ZONE is 16, ZONE_SHAPE is DELETED, `map[slot]` is an ARRAY
# of nodes rather than one dict, and `reachable()` returns 2-3 node indices at
# a branching column instead of exactly one slot. test_batch_bk owns those
# assertions now.
#
# WHAT IS KEPT HERE IS WHAT AN ACTUALLY DECIDED AND BK DID NOT REVISIT: three
# zones, the boss on the last slot, the end boss being the LAST zone's boss
# alone, and the budget ramp still reading the slot number with the boss band
# untouched. The rest is deleted rather than rewritten to pass — a test kept
# alive by re-pointing it at whatever the code now does has stopped asking its
# question.
func _test_line(RunState) -> void:
	print("\n§1 the map (AN's line, superseded by BK's lattice)")
	var run = RunState.new()
	ok(run.SLOT_COUNT == 3, "a run is 3 zones")
	ok(run.BOSS_SLOT == run.SLOTS_PER_ZONE - 1, "the boss is the last slot")
	ok(not ("ZONE_SHAPE" in run),
		"ZONE_SHAPE is DELETED with the line (BK) — not left unreachable")
	run.new_run()
	ok(run.slot_idx == -1, "a fresh zone is not entered yet")
	# The budget ramp still reads the SLOT number and the boss keeps its band.
	# BK rescaled the slope across 16 slots and moved neither end.
	for s in range(1, run.SLOTS_PER_ZONE):
		var b: int = run.battle_budget(s)
		ok(b >= 3 and b <= 10, "slot %d budgets inside the ramp (%d)" % [s, b])
	for trial in 40:
		var bb: int = run.battle_budget(run.SLOTS_PER_ZONE)
		ok(bb >= 10 and bb <= 12, "the boss slot keeps its 10-12 band (%d)" % bb)
	run.zone_idx = 1
	ok(run.is_end_boss_slot(run.BOSS_SLOT) == false, "zone 2's boss is not the end boss")
	run.zone_idx = 2
	# BATCH BM INVERTED THIS DELIBERATELY: zone 3's boss is a ZONE boss like
	# the other two — it pays a meta talent point and opens what follows it —
	# and the END BOSS is its own slot after it. Both halves asserted, because
	# what a later batch could break is the pair, not either one alone.
	ok(not run.is_end_boss_slot(run.BOSS_SLOT),
		"zone 3's boss is a ZONE boss now, not the end boss")
	ok(run.is_end_boss_slot(run.END_BOSS_SLOT), "the END BOSS is the slot after it")
	ok(not run.is_end_boss_slot(run.BOSS_SLOT - 1), "...and nothing else is")
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
			for node in run.map[s]:
				ok(String(node["type"]) != "rest",
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
	# The merchant reward. Batch BK deleted the drought counter it used to
	# reset (there is no post-fight roll left to have a drought), so what is
	# asserted now is the flag the victory screen actually routes on.
	run.pending_shop = false
	run.pending_reward = {"kind": "shop"}
	var shopped: Dictionary = run.claim_reward()
	ok(bool(shopped["shop"]), "the severity-4 merchant reward reports a merchant")
	ok(run.pending_shop, "...and arms the one merchant a fight can still queue")
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


# The other half of `_source_has`, added by Batch CD: this file's whole §5
# habit is pinning a DELETED name absent, and §4 now needs the same of BM's.
func _source_lacks(path: String, needle: String, msg: String) -> void:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		ok(false, "%s (cannot open %s)" % [msg, path])
		return
	ok(not f.get_as_text().contains(needle), msg)


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
	# THE POINT SCHEDULE THIS SECTION WAS WRITTEN FOR NO LONGER EXISTS, AND THE
	# RE-POINT IS AN INVERSION (Batch CD). AN shipped 1 apiece from elite /
	# mini-boss / boss and 0 from fights; BATCH BM §6 DELETED THE WHOLE IN-RUN
	# ECONOMY — `award_talent_points`, `award_spec_point`, `member["talent_points"]`
	# and `member["talent_flex"]` — and moved the currency to the META layer,
	# where a ZONE BOSS banks 1 per spec that played, to Profile, through
	# `bank_zone_boss_points`. So the five calls below have been throwing
	# `Invalid call ... award_talent_points` since BM, ABORTING THE WHOLE OF
	# `_test_rewards` while the suite printed a clean count: the upgrade-pool
	# section, the 200-trial never-re-offered loop and the 300-trial spec-pool
	# loop underneath had not run for twelve batches. That is the BC trap and
	# it is what Batch CD exists to close.
	#
	# WHAT IS ASSERTED INSTEAD IS THE DELETION ITSELF, in the file that used to
	# encode the schedule — because a schedule that is gone is not a smaller
	# schedule, and pinning ABSENCE is this suite's own pattern (§5 does the
	# same to BK's deleted scheduling). The banking door's BEHAVIOUR is driven
	# and negative-controlled in test_run_harness's gate 2, which redirects
	# Profile to a scratch file to do it; nothing here writes the ledger.
	ok(not run.has_method("award_talent_points"),
		"BM deleted the in-run point schedule outright")
	ok(not run.has_method("award_spec_point"),
		"...and the awakening point with it")
	for m2 in run.party:
		ok(not m2.has("talent_points"), "no member carries an in-run purse")
		ok(not m2.has("talent_flex"), "...nor AN's flex purse beside it")
	ok(run.has_method("bank_zone_boss_points"),
		"what replaced them is ONE door, and a ZONE BOSS is what opens it")
	_source_lacks("res://scripts/run_state.gd", "func award_talent_points",
		"...asserted at the source too, so a later batch cannot quietly re-add it")
	run.zone_idx = 2
	# BATCH BK: THE PER-RUN TOTAL IS NO LONGER A CONSTANT. AN's authored line
	# held exactly two elites a zone, so points-per-run was arithmetic: 4 a
	# zone, 12 a run. On a branching map the elites are 0-3 a WALKED zone, so
	# the total is a function of the route — which is the design (elites pay,
	# and routing to them is how you get paid). What is still fixed is the
	# floor and the ceiling, so those are what this asserts.
	var elite_columns := 0
	for c in range(1, run.BRANCH_COLUMNS + 1):
		for node in run.map[run.column_slot(c)]:
			if String(node["type"]) == "elite":
				elite_columns += 1
	ok(elite_columns == int(run.NODE_COPIES["elite"]),
		"a zone holds %d elites to route toward" % int(run.NODE_COPIES["elite"]))
	# INVERTED BY BATCH CD with the rest of the schedule. AN's floor was "2
	# points a zone, the mini-boss and the boss"; under BM the MINI-BOSS pays
	# no point at all, so the floor is one ZONE BOSS banking per zone and the
	# arithmetic is a property of the board rather than of the node types. What
	# is still worth asserting here — and is the half AN really meant — is that
	# the zone's guaranteed spine is unduckable: one mini-boss, one boss, on
	# every route.
	ok(run.map[run.MINI_SLOT].size() == 1,
		"every route crosses ONE mini-boss (the zone's convergence)")
	ok(run.map[run.BOSS_SLOT].size() == 1,
		"...and ends on ONE boss, which is the zone's guaranteed banking")
	run.zone_idx = 0
	# THE MINI-BOSS: a generic ability upgrade, chosen from three.
	# RE-POINTED IN PLACE (Batch BH §1): AN shipped a PLACEHOLDER pool of four
	# and this line pinned the placeholder. BH authored the other four, so the
	# question the check is really asking — "the mini-boss draws three from a
	# real pool" — is asserted against the pool's own size rather than a
	# literal, and the size itself is pinned in test_batch_bh where the eight
	# are specified.
	ok(run.ABILITY_UPGRADES.size() == 8, "a pool of eight upgrades (was four at AN)")
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
	# RE-POINTED IN PLACE (Batch BH §1): two taken out of FOUR left two to
	# offer; two out of EIGHT still leaves a full three. The question is the
	# same — the offer never pads and never repeats — so it is asked by
	# emptying the pool down to two rather than by a literal that only held
	# while the pool was four.
	ok(stacked.size() == 3, "two taken out of eight still fills a three-wide offer (got %d)"
		% stacked.size())
	var nearly: Array = []
	for drain_id in run.UPGRADE_PRIORITY.slice(0, 6):
		nearly.append({"id": String(drain_id), "ability": "Overpower"})
	hero["upgrades"] = nearly
	var short_offer: Array = run.roll_upgrade_offer(hero)
	ok(short_offer.size() <= 2, "...and the offer DOES shrink once six are taken (got %d)"
		% short_offer.size())
	hero["upgrades"] = [{"id": "up_damage", "ability": "Overpower"},
		{"id": "up_free", "ability": "Overpower"}]
	# ZONE BOSSES: the ability pick is SPEC-POOL ONLY now.
	var spec_pool: Array = Classes.spec_pool("berserker")
	# **DY §3 DELETED `CLASS_POOLS`, AND AN's OWN CHECK IS WHAT SURVIVES IT.**
	# AN §4 re-pointed the award at the spec pool and deleted `roll_ability_offer`;
	# this loop then proved the roller never returns a name only a SIBLING can
	# reach. The spec-foreign set is derived from the siblings' own pools now,
	# which is what "spec-foreign" always meant — the class pool was only ever
	# the list that happened to hold them.
	var class_only: Array = []
	for sib in ["warden", "swordmaster"]:
		for n in Classes.spec_pool(String(sib)):
			if not spec_pool.has(n) and not class_only.has(n):
				class_only.append(n)
		for n2 in Classes.spec_draft_pool(String(sib)):
			if not spec_pool.has(n2) and not class_only.has(n2):
				class_only.append(n2)
	ok(not class_only.is_empty(), "the Warrior siblings hold spec-foreign entries")
	for trial2 in 300:
		var ab_offer: Array = run.roll_spec_ability_offer(run.party[1])
		for n in ab_offer:
			ok(spec_pool.has(n), "%s is in the spec pool" % n)
			ok(not class_only.has(n), "%s never arrives from a sibling spec" % n)
	run.free()


# ---------- 5. scheduling (§5, §7, DELETED BY BATCH BK) ----------

# NOTHING ROLLS BEHIND A CLEARED FIGHT ANY MORE. Batch BK made the merchant
# and the event MAP NODES — walked to, or walked past — and deleted
# `roll_merchant`, `roll_event`, `MERCHANT_CHANCE`, `MERCHANT_FLOOR`,
# `EVENT_CHANCE`, `slots_since_merchant` and the `pending_after` queue. What
# this section used to prove (a 40% roll with a four-slot drought floor) is
# not a weaker version of the new rule, it is a different economy, so the
# checks are DELETED rather than re-pointed — and the absence is pinned, on
# the AN pattern this very file established.
func _test_scheduling(RunState) -> void:
	print("\n§5/§7 scheduling (deleted by BK — the merchant is a map node)")
	var run = RunState.new()
	run.new_run()
	for gone in ["MERCHANT_CHANCE", "MERCHANT_FLOOR", "EVENT_CHANCE",
			"slots_since_merchant", "pending_after"]:
		ok(not (gone in run), "%s is deleted with the post-fight roll (BK)" % gone)
	for gone_fn in ["roll_merchant", "roll_event"]:
		ok(not run.has_method(gone_fn), "%s() is deleted (BK)" % gone_fn)
	# The one survivor, and it is BOUGHT rather than rolled: the severity-4
	# bargain reward still puts a merchant behind the fight it priced.
	ok("pending_shop" in run,
		"the bargain's bought merchant survives — one boolean, not a queue")
	run.pending_shop = true
	ok(run.next_after_scene() == "res://scenes/shop.tscn",
		"...and next_after_scene routes to it exactly once")
	ok(run.next_after_scene() == "res://scenes/map.tscn",
		"...then back to the map")
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
