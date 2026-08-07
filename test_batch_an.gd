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
	await _test_modifiers_live()


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
	# The six placeholders and their authored severities.
	var want := {"overgrown": 1, "tinderbox": 2, "frenzied": 2,
		"brittle": 3, "warded": 3, "bloodless": 4}
	ok(run.MODIFIERS.size() == 6, "six placeholder modifiers")
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
	# 2000 offers: three DISTINCT modifiers, rewards matched to severity, and
	# THE FLOOR — always at least one option of severity 1 or 2.
	var floor_misses := 0
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
	ok(floor_misses == 0,
		"EVERY offer holds a severity 1 or 2 (missed %d of 2000)" % floor_misses)
	ok(seen_mods.size() == 6, "all six modifiers reach the offer screen over 2000 rolls")
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
		battle.free()
	# NO modifier = the pre-AN path, byte for byte. This is the check that
	# catches a stamp leaking out of the battle that armed it.
	var clean := await _spawn_battle(run, "")
	if clean != null:
		for u in clean.heroes + clean.enemies:
			ok(not u.mod_ignore_armor, "no modifier: armor is untouched")
			ok(is_equal_approx(u.mod_speed_mult, 1.0), "no modifier: speed is untouched")
			ok(is_equal_approx(u.mod_cost_mult, 1.0), "no modifier: costs are untouched")
			ok(not u.mod_no_heals, "no modifier: healing is untouched")
			ok(is_equal_approx(float(u.type_dmg_bonus.get("fire", 0.0)), 0.0),
				"no modifier: fire damage is untouched")
			ok(u.hp == u.max_hp, "no modifier: everyone opens at full health")
		clean.free()


func _spawn_battle(run: Node, mod_id: String) -> Node:
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "pyromancer", "holy", "sharpshooter"][i]
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
