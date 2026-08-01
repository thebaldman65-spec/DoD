# Full-run simulation harness (Batch S): ./sim.sh --run N plays N complete
# runs — the real 30-node map deck, real warbands at real budgets WITH tier
# stat scaling and the zone slot multiplier, state carried between battles
# exactly as a real run carries it, talent points earned AND spent — and
# reports where the runs end. The sweep isolates the composition axis;
# this instrument measures the whole difficulty curve, progression included.
#
# THE BOT IS DUMB ON PURPOSE. Every decision is a fixed, legible policy
# printed in the report header — a clever bot would make the numbers
# unattributable. We measure what the SYSTEMS do, not what a good player does.
#   Route (DOD_SIM_ROUTE)    default: fight > elite; no combat offered ->
#                            rest if any hero < 60% HP, else shop, else
#                            event. "elites" flips to elite > fight.
#   Talents (DOD_SIM_BUILDS) "spec:LaneName,..." — buy down that lane
#                            cheapest node first, capstone the moment its
#                            gate opens; default = each tree's first lane;
#                            spillover continues into the next lane once
#                            the target lane is bought out.
#   Trophies (DOD_SIM_TROPHIES) comma list of preferred ability names;
#                            default = first unowned in the spec's pool.
#   Shops                    BUY NOTHING (v1) — the result is a FLOOR on
#                            real play, not an estimate.
#   Events                   take the first valid choice; the report
#                            counts which events fired.
#   Relics (DOD_SIM_RELICS)  armed at the draft; none by default.
#   Elite rune spoils        auto-equip while a slot (max 2) is free.
#
# NEVER PERSISTS: Run.sim_run gates save_run/clear_save, and this file
# never calls Relics.unlock_random or any Profile hook — a simulated run
# must not touch the player's save file, relic unlocks, or chronicle.
#
# The Run autoload is injected into every static (the Events pattern):
# statics can't read autoloads, and injection keeps the harness testable.
class_name RunSim

static var active := false
static var runs_target := 0
static var runs_done := 0
static var completed := 0
static var wipes: Array = []      # [{zone: 1-3, tier: 1-11}]
# "zone,tier" -> accumulators; every count is per FIGHT at that tier.
static var tier_stats := {}
static var event_counts := {}     # event id -> times fired across all runs
static var talent_spent := 0.0    # points PAID across all runs, all heroes
static var talent_left := 0.0     # unspent points at run end, all runs
static var boss_nodes_sum := 0.0  # avg distinct nodes owned entering a boss
static var boss_entries := 0
static var route := "default"
static var builds := {}           # spec -> target lane name
static var _run_spent := 0        # points paid this run
static var _cur_tier := ""        # tier key of the battle in flight
static var _deaths_before := 0.0  # sim_stats hero_deaths before this battle


static func begin(run: Node, n: int) -> void:
	active = true
	runs_target = maxi(n, 1)
	run.sim_run = true  # in-memory runs only — never touch the player's save
	route = OS.get_environment("DOD_SIM_ROUTE")
	if route == "":
		route = "default"
	elif not route in ["default", "elites"]:
		push_warning("DOD_SIM_ROUTE '%s' unknown — using default" % route)
		route = "default"
	for pair in OS.get_environment("DOD_SIM_BUILDS").split(",", false):
		var bits: PackedStringArray = pair.split(":")
		if bits.size() == 2:
			builds[bits[0].strip_edges()] = bits[1].strip_edges()
	start_run(run)


# One draft + awakening, minus the screens: default heroes, DOD_SIM_RELICS
# armed at the draft, DOD_SIM_SPECS in the sim.sh class order.
static func start_run(run: Node) -> void:
	var relics: Array = []
	if OS.get_environment("DOD_SIM_RELICS") != "":
		relics = Array(OS.get_environment("DOD_SIM_RELICS").split(","))
	run.new_run(["warrior", "mage", "cleric", "hunter"], relics)
	var default_specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	var specs := default_specs
	var env := OS.get_environment("DOD_SIM_SPECS")
	if env != "":
		specs = Array(env.split(","))
	for i in run.party.size():
		var spec: String = specs[i] if i < specs.size() else default_specs[i]
		run.party[i]["spec"] = spec
		run.party[i]["tree"] = Talents.generate_tree(spec, run.party[i]["key"])
	run.specs_chosen = true
	_run_spent = 0
	if not walk_to_next_fight(run):
		push_error("RunSim: no combat node reachable from the gate")


# Walk the map tier by tier, resolving non-combat nodes in place, until a
# combat node is entered (its encounter is set). False = nothing to fight,
# which a well-formed map can't produce before the boss.
static func walk_to_next_fight(run: Node) -> bool:
	for step in 64:  # a zone is 11 tiers — 64 is "impossible map" insurance
		var reach: Array = run.reachable()
		if reach.is_empty():
			return false
		var f: int = run.floor_idx + 1
		var idx := _pick_node(run, f, reach)
		var node: Dictionary = run.map[f][idx]
		run.advance(f, idx)
		match String(node["type"]):
			"fight", "elite", "boss":
				# Pre-rolled at map birth, same as the real map click.
				var warband: Array = node.get("enemies", [])
				if warband.is_empty():
					warband = run.compose(node["type"])
					node["theme"] = run.last_theme
				run.encounter = {"type": node["type"], "enemies": warband,
					"theme": node.get("theme", "Warband")}
				return true
			"rest":
				var rest_pct: float = 0.3 + run.relic_add("rest_heal_add")
				run.heal_party(rest_pct)
				run.restore_mana(rest_pct)
			"shop":
				pass  # v1 policy: buy nothing (reported as an exclusion)
			"event":
				_resolve_event(run)
	return false


# The route policy. Combat first (order set by DOD_SIM_ROUTE), then the
# recovery ladder: hurt parties rest, healthy ones window-shop.
static func _pick_node(run: Node, f: int, reach: Array) -> int:
	var hurt := false
	for m in run.party:
		if int(m["hp"]) > 0 \
				and float(m["hp"]) / float(m["max_hp"]) < 0.6:
			hurt = true
	var prefs: Array = ["boss"]
	prefs += ["elite", "fight"] if route == "elites" else ["fight", "elite"]
	prefs += ["rest", "shop", "event"] if hurt else ["shop", "event", "rest"]
	for want in prefs:
		for i in reach:
			if String(run.map[f][i]["type"]) == want:
				return i
	return reach[0]


# The event screen boiled down to policy: draw at the door, take the first
# choice whose requirements pass, apply every effect. Mirrors map_screen +
# event_screen minus Profile.note_event (sims never write the chronicle).
static func _resolve_event(run: Node) -> void:
	var id := Events.pick(run)
	if id == "":
		return
	run.seen_events.append(id)
	event_counts[id] = int(event_counts.get(id, 0)) + 1
	for choice in Events.config(id).get("choices", []):
		if Events.requires_met(run, choice.get("requires", {})):
			for fx in choice.get("effects", []):
				Events.apply(run, fx)
			return


# Called after _spawn_units: measure both sides AS SPAWNED — talents, node
# scaling, runes, trophies, tier scaling and the slot multiplier all live.
# Effective HP = HP / (1 - armor), the Batch R modelled-table formula, so
# the measured curve lands in the same units as the modelled one.
static func note_battle_start(run: Node, heroes: Array, enemies: Array,
		stats: Dictionary) -> void:
	_cur_tier = "%d,%d" % [run.zone_idx + 1, run.floor_idx + 1]
	_deaths_before = stats.get("hero_deaths", 0.0)
	var t := _tier(_cur_tier)
	t["fights"] += 1.0
	var hp_sum := 0.0
	var living := 0.0
	for h in heroes:
		t["p_atk"] += h.attack
		t["p_ehp"] += h.max_hp / maxf(1.0 - clampf(h.armor, 0.0, 0.95), 0.05)
		if not h.dead:
			hp_sum += h.hp / float(h.max_hp)
			living += 1.0
	t["hp_pct"] += hp_sum / maxf(living, 1.0)
	for e in enemies:
		t["e_atk"] += e.attack
		t["e_ehp"] += e.max_hp / maxf(1.0 - clampf(e.armor, 0.0, 0.95), 0.05)
	# Correctness check 2 (the batch doc): heroes must enter the boss with
	# a real build, not base kits.
	if String(run.encounter.get("type", "")) == "boss":
		boss_entries += 1
		var nodes := 0.0
		for m in run.party:
			for tid in m.get("talents", {}):
				if int(m["talents"][tid]) > 0:
					nodes += 1.0
		boss_nodes_sum += nodes / maxf(run.party.size(), 1.0)


# The real victory branch minus UI and persistence, then the map walk to
# the next fight. Defeat books the wipe. Either way the battle scene is
# reloaded (or the final report printed) — the caller just returns.
static func on_battle_end(run: Node, battle, victory: bool) -> void:
	var t := _tier(_cur_tier)
	t["deaths"] += battle.sim_stats.get("hero_deaths", 0.0) - _deaths_before
	# Shared inventory back to the run (mirrors the real end-of-battle sync).
	for id in battle.items:
		run.items[id] = battle.items[id][1]
	if not victory:
		wipes.append({"zone": run.zone_idx + 1, "tier": run.floor_idx + 1})
		_finish_run(run, battle, false)
		return
	t["wins"] += 1.0
	run.combat_wins += 1
	for i in battle.heroes.size():
		var h = battle.heroes[i]
		# Same clamp as the real branch: battle-long Tenacity gains stay in
		# the battle, and the fallen return at 20% HP.
		var save_max: int = h.max_hp - h.tenacity_hp_gained
		run.party[i]["hp"] = clampi(maxi(h.hp, int(save_max * 0.2)), 1, save_max)
		run.party[i]["max_hp"] = save_max
		if h.resource_name == "Mana":
			run.party[i]["mana"] = h.resource
	var node_type := String(run.encounter.get("type", "fight"))
	run.award_talent_points(node_type)
	run.award_gold(node_type)
	if node_type == "elite":
		var looter: Dictionary = run.party.pick_random()
		var rune: Dictionary = run.generate_rune(looter["key"])
		# Policy: spoils auto-equip while one of the 2 slots is free.
		var worn := 0
		for r in looter.get("runes", []):
			if r.get("equipped", false):
				worn += 1
		rune["equipped"] = worn < 2
		looter["runes"] = looter.get("runes", []) + [rune]
		var drop_id: String = run.random_loot()
		run.items[drop_id] = int(run.items.get(drop_id, 0)) + 1
		for extra_i in int(run.relic_add("loot_extra")):
			var extra_id: String = run.random_loot()
			run.items[extra_id] = int(run.items.get(extra_id, 0)) + 1
	var v_heal: float = run.relic_add("victory_heal_pct")
	if v_heal > 0.0:
		run.heal_party(v_heal)
	var v_mana: float = run.relic_add("victory_mana_pct")
	if v_mana > 0.0:
		run.restore_mana(v_mana)
	run.gold += int(run.relic_add("victory_gold"))
	var run_over := false
	if node_type == "boss":
		_award_trophies(run)  # never Relics.unlock_random — that persists
		if run.has_next_zone():
			run.advance_zone()
		else:
			run_over = true
	_spend_talents(run)  # the post-battle party screen, boiled to policy
	if run_over:
		_finish_run(run, battle, true)
		return
	if not walk_to_next_fight(run):
		push_error("RunSim: map walk found no next fight — ending run")
		_finish_run(run, battle, true)
		return
	battle.get_tree().reload_current_scene()


static func _finish_run(run: Node, battle, done: bool) -> void:
	runs_done += 1
	if done:
		completed += 1
	talent_spent += _run_spent
	for m in run.party:
		talent_left += int(m.get("talent_points", 0))
	if runs_done < runs_target:
		start_run(run)
		battle.get_tree().reload_current_scene()
	else:
		_print_report(battle)
		run.active = false
		battle.get_tree().quit()


# Boss trophies, resolved instantly instead of owed to the party screen:
# DOD_SIM_TROPHIES names win when available, else pool order.
static func _award_trophies(run: Node) -> void:
	var wanted: Array = []
	for trophy_name in OS.get_environment("DOD_SIM_TROPHIES").split(",", false):
		wanted.append(trophy_name.strip_edges())
	for m in run.party:
		var pool: Array = Classes.spec_pool(String(m.get("spec", "")))
		if pool.is_empty():
			continue
		var owned: Array = m.get("bm_abilities", [])
		if owned.size() >= pool.size():
			continue
		var pick := ""
		for trophy_name in wanted:
			if trophy_name in pool and not trophy_name in owned:
				pick = trophy_name
				break
		if pick == "":
			for trophy_name in pool:
				if not trophy_name in owned:
					pick = trophy_name
					break
		m["bm_abilities"] = owned + [pick]


# Spend every point the policy can: same bookkeeping as the party screen's
# _learn_talent (cost, ranks, purchase order), driven by _next_buy.
static func _spend_talents(run: Node) -> void:
	for m in run.party:
		var tree: Array = m.get("tree", [])
		if tree.is_empty():
			continue
		var target := _target_lane(String(m.get("spec", "")), tree)
		for guard in 200:  # one buy per loop; 200 = runaway insurance
			var buy := _next_buy(m, tree, target)
			if buy == "":
				break
			var learned: Dictionary = m.get("talents", {})
			var cost := Talents.node_cost(tree, learned, buy)
			var first_rank := int(learned.get(buy, 0)) < 1
			learned[buy] = int(learned.get(buy, 0)) + 1
			m["talents"] = learned
			m["talent_points"] = int(m.get("talent_points", 0)) - cost
			_run_spent += cost
			if first_rank and Talents.is_lane_tree(tree):
				m["talent_order"] = m.get("talent_order", []) + [buy]


static func _target_lane(spec: String, tree: Array) -> String:
	var want := String(builds.get(spec, ""))
	if want != "":
		return want
	return String(tree[0].get("lane", ""))


# The next node the policy buys: the target lane's capstone the moment its
# gate opens, else the cheapest learnable node in the target lane (ties go
# to the lower tier), else spillover into the other lanes in tree order.
# "" = nothing affordable/learnable — bank the points.
static func _next_buy(m: Dictionary, tree: Array, target: String) -> String:
	var learned: Dictionary = m.get("talents", {})
	var order: Array = m.get("talent_order", [])
	var pts := int(m.get("talent_points", 0))
	var lanes: Array = [target]
	for t in tree:
		var lane := String(t.get("lane", ""))
		if not lane in lanes:
			lanes.append(lane)
	for lane in lanes:
		var best := ""
		var best_cost := 999
		var best_tier := 999
		for t in tree:
			if String(t.get("lane", "")) != lane:
				continue
			var id := String(t["id"])
			if not Talents.can_learn(tree, id, learned, order)["ok"]:
				continue
			var cost := Talents.node_cost(tree, learned, id)
			if cost > pts:
				continue
			if t.get("capstone", false):
				return id
			var tier := int(t.get("tier", 0))
			if cost < best_cost or (cost == best_cost and tier < best_tier):
				best = id
				best_cost = cost
				best_tier = tier
		if best != "":
			return best
	return ""


static func _tier(key: String) -> Dictionary:
	if not tier_stats.has(key):
		tier_stats[key] = {"fights": 0.0, "wins": 0.0, "deaths": 0.0,
			"hp_pct": 0.0, "p_atk": 0.0, "p_ehp": 0.0,
			"e_atk": 0.0, "e_ehp": 0.0}
	return tier_stats[key]


# ---------- the report ----------

static func _print_report(battle) -> void:
	var runs := maxf(float(runs_done), 1.0)
	print("\n===== DAWN OF DECAY — RUN REPORT =====")
	print("Runs: %d    Completed: %d (%.0f%%)    Wiped: %d (%.0f%%)" % [
		runs_done, completed, 100.0 * completed / runs,
		wipes.size(), 100.0 * wipes.size() / runs])
	var relics_env := OS.get_environment("DOD_SIM_RELICS")
	var troph := OS.get_environment("DOD_SIM_TROPHIES")
	var builds_env := OS.get_environment("DOD_SIM_BUILDS")
	print("Policies: route=%s builds=%s shops=OFF(v1: result is a floor) relics=%s" % [
		route, builds_env if builds_env != "" else "default(first lane)",
		relics_env if relics_env != "" else "none"])
	print("          trophies=%s runes=auto-equip(2 slots) events=first-valid" % [
		troph if troph != "" else "first-in-pool"])
	print("Specs: %s" % OS.get_environment("DOD_SIM_SPECS"))

	print("\nWipe tier distribution:")
	for z in range(1, 4):
		var bands := {"t1-3": 0, "t4-7": 0, "t8-10": 0, "boss": 0}
		for w in wipes:
			if int(w["zone"]) != z:
				continue
			var wt := int(w["tier"])
			if wt >= 11:
				bands["boss"] += 1
			elif wt >= 8:
				bands["t8-10"] += 1
			elif wt >= 4:
				bands["t4-7"] += 1
			else:
				bands["t1-3"] += 1
		print("  zone %d: t1-3 x%-3d t4-7 x%-3d t8-10 x%-3d boss x%d" % [
			z, bands["t1-3"], bands["t4-7"], bands["t8-10"], bands["boss"]])

	print("\nPer-tier averages (all runs reaching that tier):")
	print("  zone tier   fights   win%   deaths/fight   party HP% entering")
	for z in range(1, 4):
		for ft in range(1, 12):
			var key := "%d,%d" % [z, ft]
			if not tier_stats.has(key):
				continue
			var t: Dictionary = tier_stats[key]
			var fights: float = maxf(t["fights"], 1.0)
			print("  z%d %s %8d %6.0f%% %10.2f %12.0f%%" % [
				z, ("boss" if ft == 11 else " t%-2d" % ft), int(t["fights"]),
				100.0 * t["wins"] / fights, t["deaths"] / fights,
				100.0 * t["hp_pct"] / fights])

	# THE DELIVERABLE: both power curves measured with progression live.
	# Ratio = sqrt(Atk x effHP / Atk x effHP) — flat-ish means progression
	# keeps pace with the enemy ladder; collapsing means the gap is real.
	print("\nParty power vs warband power, measured (not modelled):")
	print("  zone tier   party Atk   party effHP   warband Atk   warband effHP   ratio")
	for z in range(1, 4):
		for ft in range(1, 12):
			var key := "%d,%d" % [z, ft]
			if not tier_stats.has(key):
				continue
			var t: Dictionary = tier_stats[key]
			var fights: float = maxf(t["fights"], 1.0)
			var p_atk: float = t["p_atk"] / fights
			var p_ehp: float = t["p_ehp"] / fights
			var e_atk: float = t["e_atk"] / fights
			var e_ehp: float = t["e_ehp"] / fights
			print("  z%d %s %9d %13d %13d %15d %9.2f" % [
				z, ("boss" if ft == 11 else " t%-2d" % ft),
				int(p_atk), int(p_ehp), int(e_atk), int(e_ehp),
				sqrt((p_atk * p_ehp) / maxf(e_atk * e_ehp, 1.0))])

	print("\nDamage share across all runs: %s" % \
		battle._share_line(battle.sim_stats))
	var earned := talent_spent + talent_left
	print("Talent points per hero per run: earned %.1f   spent %.1f (banked %.1f)" % [
		earned / runs / 4.0, talent_spent / runs / 4.0, talent_left / runs / 4.0])
	if boss_entries > 0:
		print("Avg talent nodes owned entering a boss: %.1f (%d boss fights)" % [
			boss_nodes_sum / boss_entries, boss_entries])
	var ev_parts := PackedStringArray()
	var ev_ids: Array = event_counts.keys()
	ev_ids.sort()
	for id in ev_ids:
		ev_parts.append("%s x%d" % [id, event_counts[id]])
	print("Events fired: %s" % (", ".join(ev_parts) if not ev_parts.is_empty() else "none"))
	print("Excluded from v1: shop purchases (gold accrues unspent), item use in battle (the bot never drinks).")
	print("=============================================\n")
