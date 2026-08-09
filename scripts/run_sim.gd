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
#   Route (DOD_SIM_ROUTE)    three policies, one axis: how much recovery
#                            the bot allows itself (Batch U). "greedy" =
#                            the Batch S floor byte for byte: fight >
#                            elite always; rest only when no combat is
#                            offered AND a hero sits under 60%. "default"
#                            rests when AVERAGE party HP < 65% and a rest
#                            is on offer, else fight > elite > shop >
#                            event. "cautious" = the same at 80%. The
#                            spread between the three IS the deliverable:
#                            one number is a point, three are a band that
#                            real play sits inside. "elites" kept as-is
#                            (greedy ladder, elite > fight).
#   Shops (DOD_SIM_SHOPS)    on by default (Batch U): heal-first (any
#                            hero < 50% buys one Health Potion each),
#                            then the priciest affordable offer not
#                            already carried — runes included, but only
#                            onto a member with a free slot (equipped at
#                            purchase; the sim has no party screen). No
#                            buy ever drops gold below the 40g reserve —
#                            a later heal stays reachable. "off" = the
#                            v1 floor: buy nothing.
#   Items (DOD_SIM_ITEMS)    on by default (Batch U): a hero opening a
#                            turn below 35% HP drinks a carried Health
#                            Potion before acting — nothing else, no
#                            offensive or pre-emptive use. "off" = the
#                            v1 floor: carried items are never drunk.
#                            Run sims only — sweep/standalone battles
#                            stay dry so Batch R/S baselines hold.
#   Talents (DOD_SIM_BUILDS) "spec:LaneName,..." — buy that lane's node in
#                            every row, top to bottom, then its capstone
#                            (Batch AI: a lane holds one node per row, so
#                            this is always a complete 8-node build).
#                            Default = each tree's first lane. Elite points
#                            go to the second node in the lowest row that
#                            has one, from the next lane in tree order.
#   Trophies (DOD_SIM_TROPHIES) comma list of preferred ability names;
#                            default = first unowned in the spec's pool.
#   Events                   take the first valid choice; the report
#                            counts which events fired.
#   Relics (DOD_SIM_RELICS)  armed at the draft; none by default.
#   Elite rune spoils        pick-of-3 resolved instantly: build-lane
#                            match first, then spec-scoped, else the
#                            first candidate; auto-equip while a slot
#                            (Run.rune_slots: 2/3/4 by zone) is free.
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
static var shops_on := true       # Batch U shop policy (DOD_SIM_SHOPS=off -> v1 floor)
static var items_on := true       # Batch U drink policy (DOD_SIM_ITEMS=off -> v1 floor)
# Batch AN §3: what the bot took at the offer screen. offer_severity_sum /
# offer_count is the run\'s average accepted severity — the one number that
# says whether the bargain table is being used as a lever or ignored.
static var offer_taken := {}      # modifier id -> times accepted
static var offer_severity_sum := 0
static var offer_count := 0
static var upgrade_taken := 0     # mini-boss ability upgrades resolved
# What FOLLOWED cleared slots (§5/§7): merchants and events are scheduled
# now, not dealt onto the board.
static var merchants_seen := 0
static var events_seen := 0
static var items_used := 0        # potions drunk in battle (battle.gd increments)
static var items_left := 0.0      # consumables still carried when a run ends
static var gold_earned := 0.0     # everything a run ever held (start + income)
static var gold_spent := 0.0      # what the shop policy paid out
static var gold_unspent := 0.0    # balance at wipe or completion
static var heals_bought := 0      # rule 1: potions for the wounded
static var restock_bought := 0    # rule 2: consumables bought back at count 0
static var runes_bought := 0      # rule 2: runes bought (equipped at purchase)
static var _run_spent := 0        # points paid this run
static var _run_gold_spent := 0   # gold paid this run (shop policy only)
static var _cur_tier := ""        # tier key of the battle in flight
static var _deaths_before := 0.0  # sim_stats hero_deaths before this battle
static var spec_runs := {}        # Batch W: spec display name -> runs sampled
# Route agency (Batch Y): is the map a route-planning surface or a corridor?
# Counted at every PICK STEP of the walk (the gate pick, each tier, the boss
# funnel) — a step "offers a real choice" only when >=2 nodes are reachable
# AND they are not all the same type. Deck-vs-seen is the "the deck says 15
# rests, the player could reach 5" line: dealt = nodes in the zone maps as
# generated; seen = nodes that were reachable at some step of the taken path.
static var walk_steps := 0        # pick steps across all runs
static var reach_sum := 0         # reachable nodes summed over those steps
static var choice_steps := 0      # steps with a real choice (count + type)
static var type_offered := {}     # type -> steps where one was reachable
static var type_taken := {}       # type -> nodes actually entered
static var deck_present := {}     # type -> nodes dealt into zone maps
static var deck_seen := {}        # type -> nodes ever reachable on the walk
static var _seen_nodes := {}      # "f,i" once-guard, reset per zone map
# ---------- Rune economy (Batch AD) ----------
# Nothing about the rune ECONOMY was visible in a run report before this
# batch: three batches authored the pool and every measurement of it
# confounded "the entries are weak" with "the entries never arrive". These
# count the second half. Split by SOURCE, because the shop and the elite
# cache fail differently — the shop fails on gold and on the bot walking
# past it, the cache fails on a slot that has not opened yet.
static var rune_shop_offered := 0   # rune offers actually put on the counter
static var rune_elite_offered := 0  # cache candidates shown (3 per cache)
static var rune_elite_taken := 0    # caches resolved — one rune each
static var rune_elite_equipped := 0 # ...of those, worn (a slot was free)
# Batch AH: the earnable-ability economy — offers shown and picks taken
# (2 awards a zone, 6 a run, when both pools still hold something).
static var ability_offered := 0
static var ability_taken := 0
static var rune_refused_noslot := 0 # never offered: every slot already worn
static var rune_refused_gold := 0   # offered, left on the counter: 40g reserve
static var rune_refused_dupe := 0   # re-roll kept landing on an owned rune
static var rune_granted := 0        # DOD_SIM_RUNE_ECON=rich only
# Batch AE: the third source, and the only one that is SHIPPED rather than
# an arm. Split out because it fails differently again — it cannot fail on
# gold, on routing, or on a closed slot, which is the whole reason it was
# the lever chosen.
static var slots_avail_sum := 0.0   # summed over heroes at run end
static var slots_filled_sum := 0.0
static var worn_kind := {}          # spec|class|universal|stick -> runes worn
# ---------- Stage 0b: per-run samples ----------
# Completions is a binary read on a 2-6% event: at n=50 the difference
# between "2%" and "6%" is TWO RUNS, and two batches concluded "noise" from
# an instrument that could not have seen anything smaller than a large
# effect. These are the continuous metrics that replace it as primary —
# stored per RUN so the report can print a spread, not just a point.
static var depth_reached: Array = []  # absolute tier at run end, 1..33
static var r8_samples: Array = []     # one ratio@z1t8 per run that fought it
static var _run_r8 := -1.0


static func begin(run: Node, n: int) -> void:
	active = true
	runs_target = maxi(n, 1)
	run.sim_run = true  # in-memory runs only — never touch the player's save
	route = OS.get_environment("DOD_SIM_ROUTE")
	if route == "":
		route = "default"
	elif not route in ["greedy", "default", "cautious", "elites"]:
		push_warning("DOD_SIM_ROUTE '%s' unknown — using default" % route)
		route = "default"
	shops_on = not OS.get_environment("DOD_SIM_SHOPS") in ["off", "0"]
	items_on = not OS.get_environment("DOD_SIM_ITEMS") in ["off", "0"]
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
	# Alpha difficulty affordance (Batch Y): default standard, so no
	# baseline row can be contaminated by a forgotten env var.
	var diff := OS.get_environment("DOD_SIM_DIFFICULTY")
	if not diff in ["standard", "wanderer"]:
		diff = "standard"
	run.new_run(["warrior", "mage", "cleric", "hunter"], relics, diff)
	var default_specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	var specs := default_specs
	var env := OS.get_environment("DOD_SIM_SPECS")
	if env != "":
		specs = Array(env.split(","))
	# Batch W (DOD_SIM_ROTATE=1): cycle each class slot's spec across
	# successive RUNS — a spec never changes mid-run (that would be a
	# different game), but all twelve get sampled across the invocation.
	# Overrides DOD_SIM_SPECS.
	if OS.get_environment("DOD_SIM_ROTATE") == "1":
		specs = Classes.rotated_specs(runs_done)
	for i in run.party.size():
		var spec: String = specs[i] if i < specs.size() else default_specs[i]
		run.party[i]["spec"] = spec
		run.party[i]["tree"] = Talents.generate_tree(spec, run.party[i]["key"])
		run.sync_spec_hp(i)  # awakening HP sync — same call as the spec screen
		run.award_spec_point(i)  # Batch AI: the awakening's own talent point
		var run_sn := String(Classes.SPEC_INFO[spec]["name"])
		spec_runs[run_sn] = int(spec_runs.get(run_sn, 0)) + 1
	# Batch AE: the sim gets the opening pick too, resolved through the same
	# _pick_rune_candidate policy the elite cache uses — otherwise the
	# harness measures a different game than the one shipping.
	run.specs_chosen = true
	_run_spent = 0
	_run_gold_spent = 0
	_run_r8 = -1.0
	if not walk_to_next_fight(run):
		push_error("RunSim: no combat node reachable from the gate")


# Walk the LINE (Batch AN). Every slot is combat, so there is nothing to
# resolve in place any more — the walk advances one slot and returns with an
# encounter armed. The loop survives because the shop and the event are now
# things that FOLLOW a cleared slot rather than things standing on the board;
# they are resolved by on_battle_end, not here.
#
# ROUTE AGENCY IS STRUCTURALLY ZERO NOW and the counters say so rather than
# being deleted: walk_steps still climbs, reach_sum tracks it exactly, and
# choice_steps stays 0 for every run. A report line that reads "choice 0%"
# is the honest description of a line; a missing line would just look like
# the instrument broke.
static func walk_to_next_fight(run: Node) -> bool:
	_rich_top_up(run)
	var reach: Array = run.reachable()
	if reach.is_empty():
		return false
	if run.slot_idx < 0:
		_tally_map(run)  # fresh zone: book its (fixed) composition
	var s := int(reach[0])
	walk_steps += 1
	reach_sum += reach.size()
	var node: Dictionary = run.map[s]
	var ty := String(node["type"])
	type_offered[ty] = int(type_offered.get(ty, 0)) + 1
	type_taken[ty] = int(type_taken.get(ty, 0)) + 1
	var seen_key := str(s)
	if not _seen_nodes.has(seen_key):
		_seen_nodes[seen_key] = true
		deck_seen[ty] = int(deck_seen.get(ty, 0)) + 1
	run.advance(s)
	# §3: the offer, gated to elites and mini-bosses by Batch AO §2 — the
	# harness must walk the road the player walks. The bot takes the SEVEREST
	# bargain it is offered while the party is healthy and the MILDEST once it
	# is hurt — the crudest policy that exercises both ends of the severity
	# table, and the one a cautious human most resembles. It is a policy, not
	# a recommendation.
	if ty in ["elite", "miniboss"]:
		_take_offer(run)
	var warband: Array = node.get("enemies", [])
	if warband.is_empty():
		warband = run.compose(ty, s + 1)
		node["theme"] = run.last_theme
	run.encounter = {"type": ty, "enemies": warband,
		"theme": node.get("theme", "Warband")}
	return true


# The bot's bargain policy. Healthy (>=60% average party HP) it takes the
# highest severity offered; hurt, the lowest — which the §3 floor
# guarantees is always a 1 or a 2.
static func _take_offer(run: Node) -> void:
	var offer: Array = run.roll_offer()
	if offer.is_empty():
		return
	var hurt := _avg_hp(run) < 0.60
	var best: Dictionary = offer[0]
	for option in offer:
		# (explicit types: `run` is an untyped Node here, so := cannot infer
		# from its methods — the CLAUDE.md gotcha)
		var sev: int = run.modifier_severity(String(option["modifier"]))
		var cur: int = run.modifier_severity(String(best["modifier"]))
		if (hurt and sev < cur) or (not hurt and sev > cur):
			best = option
	offer_taken[String(best["modifier"])] = \
		int(offer_taken.get(String(best["modifier"]), 0)) + 1
	offer_severity_sum += int(run.modifier_severity(String(best["modifier"])))
	offer_count += 1
	run.accept_offer(best)


# DOD_SIM_RUNE_ECON=rich (Batch AD): top every hero up to the milestone
# target, one spec-eligible rune at a time. Under this arm every slot is
# open from tier 1 (Run.rune_slots), so the four runes written for a spec
# reach their hero by the middle of zone 2 instead of never — measured
# acquisition at the fixed party is 0.55-0.7 per hero PER RUN.
#
# Milestones are deliberately crude — 1 rune early in zone 1, 2 late, then
# +1 per half-zone to the slot cap. This is a probe, not an economy: it
# does not have to be shippable, it has to answer "what happens when the
# runes actually arrive?". The shop and the cache keep running underneath
# it, so the arm raises acquisition without removing a channel.
static func _rich_top_up(run: Node) -> void:
	if run.rune_econ() != "rich":
		return
	var half := 1 if run.slot_idx + 1 < 6 else 2
	var target: int = mini(run.zone_idx * 2 + half, run.rune_slots())
	for m in run.party:
		var worn := 0
		var owned_names: Array = []
		for r in m.get("runes", []):
			owned_names.append(String(r["name"]))
			if r.get("equipped", false):
				worn += 1
		while worn < target:
			var rune: Dictionary = run.grant_rune(m)
			# Empty = runes off; a dupe means the eligible pool is spent for
			# this hero. Either way, stop asking rather than spin.
			if rune.is_empty() or owned_names.has(String(rune["name"])):
				break
			rune["equipped"] = true
			m["runes"] = m.get("runes", []) + [rune]
			owned_names.append(String(rune["name"]))
			rune_granted += 1
			worn += 1


# Book a freshly generated zone map: what the deal actually put on the
# board (elites counted as their own type — they are the rune-cache
# source), and reset the per-map seen-guard for the ever-reachable count.
static func _tally_map(run: Node) -> void:
	_seen_nodes = {}
	for node in run.map:
		var ty := String(node["type"])
		deck_present[ty] = int(deck_present.get(ty, 0)) + 1


static func _avg_hp(run: Node) -> float:
	var total := 0.0
	for m in run.party:
		total += float(m["hp"]) / maxf(float(m["max_hp"]), 1.0)
	return total / maxf(run.party.size(), 1.0)


# ---------- the shop policy (Batch U) ----------

# Prices mirror shop_screen.gd (flat, no tier scaling; only the relic
# discount moves them). Stock never runs out; runes are one per member
# per visit, dupes re-rolled, price set by rarity (50/100/160).
const ITEM_PRICES := {"health": 30, "mana": 30, "bomb": 45, "revive": 80,
	"defense": 40}
const GOLD_RESERVE := 40  # no purchase may dip below this — heals stay reachable


static func _price(run: Node, base: int) -> int:
	return maxi(int(round(base * (1.0 - run.relic_add("shop_discount")))), 1)


# The Peddler boiled to policy: (1) any hero under half health buys one
# Health Potion each; (2) then the priciest affordable offer not already
# carried — consumables at count 0, or a rune for a member with a free
# slot (equipped at purchase: the sim has no party screen, so an
# unequippable rune would be dead gold and is never offered to it);
# (3) every purchase respects the reserve.
static func _shop_visit(run: Node) -> void:
	var heal_price := _price(run, ITEM_PRICES["health"])
	for m in run.party:
		if float(m["hp"]) / float(m["max_hp"]) < 0.5 \
				and run.gold - heal_price >= GOLD_RESERVE:
			run.gold -= heal_price
			_run_gold_spent += heal_price
			run.items["health"] = int(run.items.get("health", 0)) + 1
			heals_bought += 1
	var offers := _roll_rune_offers(run)
	for guard in 32:  # each buy shrinks the offer set; 32 = runaway insurance
		var best_item := ""
		var best_offer := -1
		var best_price := -1
		for id in run.ITEM_IDS:
			if int(run.items.get(id, 0)) > 0:
				continue  # already carried
			var p := _price(run, int(ITEM_PRICES[id]))
			if run.gold - p >= GOLD_RESERVE and p > best_price:
				best_item = id
				best_offer = -1
				best_price = p
		for i in offers.size():
			var rp := _price(run, int(offers[i]["rune"]["price"]))
			if run.gold - rp >= GOLD_RESERVE and rp > best_price:
				best_item = ""
				best_offer = i
				best_price = rp
		if best_item == "" and best_offer < 0:
			break  # nothing affordable left — the leftovers are counted below
		run.gold -= best_price
		_run_gold_spent += best_price
		if best_item != "":
			run.items[best_item] = int(run.items.get(best_item, 0)) + 1
			restock_bought += 1
		else:
			var offer: Dictionary = offers[best_offer]
			var rune: Dictionary = offer["rune"]
			rune["equipped"] = true
			var member: Dictionary = run.party[offer["member_idx"]]
			member["runes"] = member.get("runes", []) + [rune]
			runes_bought += 1
			offers.remove_at(best_offer)
	# A rune the party could not have taken is not a rune the economy
	# delivered (Batch AD). Anything still on the counter outlived the gold:
	# the buy loop only stops when nothing clears the 40g reserve.
	rune_refused_gold += offers.size()


# One rune per party member, dupes re-rolled (shop_screen._roll_offers),
# minus members with every slot worn — the sim never holds a rune it
# cannot equip.
static func _roll_rune_offers(run: Node) -> Array:
	var offers: Array = []
	for i in run.party.size():
		var member: Dictionary = run.party[i]
		var worn := 0
		var owned_names: Array = []
		for r in member.get("runes", []):
			owned_names.append(r["name"])
			if r.get("equipped", false):
				worn += 1
		if worn >= run.rune_slots():
			rune_refused_noslot += 1
			continue
		var rune: Dictionary = run.generate_rune(member)
		if rune.is_empty():
			continue  # DOD_SIM_RUNES=off — no rune offers at all
		for attempt in 4:
			if not owned_names.has(rune["name"]):
				break
			rune = run.generate_rune(member)
		if not owned_names.has(rune["name"]):
			offers.append({"member_idx": i, "rune": rune})
			rune_shop_offered += 1
		else:
			rune_refused_dupe += 1
	return offers


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
	_cur_tier = "%d,%d" % [run.zone_idx + 1, run.slot_idx + 1]
	_deaths_before = stats.get("hero_deaths", 0.0)
	var t := _tier(_cur_tier)
	t["fights"] += 1.0
	var hp_sum := 0.0
	var living := 0.0
	var p_atk := 0.0
	var p_ehp := 0.0
	var e_atk := 0.0
	var e_ehp := 0.0
	for h in heroes:
		p_atk += h.attack
		p_ehp += h.max_hp / maxf(1.0 - clampf(h.armor, 0.0, 0.95), 0.05)
		if not h.dead:
			hp_sum += h.hp / float(h.max_hp)
			living += 1.0
	t["p_atk"] += p_atk
	t["p_ehp"] += p_ehp
	t["hp_pct"] += hp_sum / maxf(living, 1.0)
	for e in enemies:
		e_atk += e.attack
		e_ehp += e.max_hp / maxf(1.0 - clampf(e.armor, 0.0, 0.95), 0.05)
	t["e_atk"] += e_atk
	t["e_ehp"] += e_ehp
	# Stage 0b: the SAME ratio the report has always headlined, kept per RUN
	# so it carries a spread instead of a single pooled point. z1t8 is the
	# established comparison tier (the Matrix row's ratio@z1t8) and nearly
	# every run reaches it, which is what makes it a usable primary metric
	# where completions is not.
	if _cur_tier == "1,8":
		_run_r8 = sqrt((p_atk * p_ehp) / maxf(e_atk * e_ehp, 1.0))
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
		wipes.append({"zone": run.zone_idx + 1, "tier": run.slot_idx + 1})
		_finish_run(run, battle, false)
		return
	t["wins"] += 1.0
	run.combat_wins += 1
	for i in battle.heroes.size():
		var h = battle.heroes[i]
		# Same clamp as the real branch: battle-long Tenacity gains stay in
		# the battle, and the fallen return at 20% HP.
		# Conviction's growth (Batch AW) comes back off here too — it is a
		# one-fight loan, not permanent bulk. See battle.gd's victory branch.
		var save_max: int = h.max_hp - h.tenacity_hp_gained - h.conviction_hp_gained
		run.party[i]["hp"] = clampi(maxi(h.hp, int(save_max * 0.2)), 1, save_max)
		run.party[i]["max_hp"] = save_max
		if h.resource_name == "Mana":
			run.party[i]["mana"] = h.resource
	var node_type := String(run.encounter.get("type", "fight"))
	run.award_talent_points(node_type)
	run.award_gold(node_type)
	if node_type == "elite":
		var looter: Dictionary = run.party.pick_random()
		# Pick-of-3 (Batch X), resolved instantly by bot policy — dumb and
		# printed in the report header: prefer a candidate whose lane
		# matches the spec's DOD_SIM_BUILDS target lane, then any
		# spec-scoped candidate, else the first. Auto-equip while a slot
		# (Run.rune_slots) is free. Empty = DOD_SIM_RUNES=off — the elite
		# still drops its item.
		var candidates: Array = run.roll_rune_candidates(looter)
		if not candidates.is_empty():
			rune_elite_offered += candidates.size()
			var rune: Dictionary = _pick_rune_candidate(looter, candidates)
			var worn := 0
			for r in looter.get("runes", []):
				if r.get("equipped", false):
					worn += 1
			rune["equipped"] = worn < run.rune_slots()
			rune_elite_taken += 1
			if rune["equipped"]:
				rune_elite_equipped += 1
			looter["runes"] = looter.get("runes", []) + [rune]
		# Batch AN §6: drops honour the six-per-type cap, through the same
		# Run.add_item every other grant uses — a sim that could stockpile
		# past the cap would report an economy the game cannot produce.
		run.add_item(run.random_loot())
		for extra_i in int(run.relic_add("loot_extra")):
			run.add_item(run.random_loot())
	# §6: clearing ANY slot heals 15%, with the relic stacking on top.
	run.heal_party(run.victory_heal_pct())
	var v_mana: float = run.relic_add("victory_mana_pct")
	if v_mana > 0.0:
		run.restore_mana(v_mana)
	run.gold += int(run.relic_add("victory_gold"))
	# §3: the accepted bargain pays out, and the modifier is cleared.
	var bargain: Dictionary = run.claim_reward()
	var merchant_owed: bool = bool(bargain.get("shop", false))
	var run_over := false
	# §4: the mini-boss pays an ABILITY UPGRADE now, not an ability.
	if node_type == "miniboss":
		_award_upgrades(run)
	if node_type == "boss":
		# The END boss awards no ability pick (§4) — nothing follows it.
		if run.has_next_zone():
			_award_trophies(run)  # never Relics.unlock_random — that persists
			run.advance_zone()
		else:
			run_over = true
	# §5 and §7: what follows a cleared fight or elite, resolved by the same
	# rolls the victory screen makes.
	if merchant_owed or run.roll_merchant(node_type):
		merchants_seen += 1
		if shops_on:
			_shop_visit(run)
	if run.roll_event(node_type):
		events_seen += 1
		_resolve_event(run)
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
		talent_left += int(m.get("talent_points", 0)) + int(m.get("talent_flex", 0))
	# Gold ledger (Batch U): earned = everything the run ever held (start
	# gold + income, net of event losses), so earned = spent + unspent.
	gold_spent += _run_gold_spent
	gold_unspent += run.gold
	gold_earned += run.gold + _run_gold_spent
	for id in run.items:
		items_left += int(run.items[id])
	# Stage 0b primary metric: how far the run actually got, on the same
	# absolute ladder the wipe median uses ((zone-1)*11 + tier, so a full
	# clear is 33). A mean over per-run samples, never a median — the median
	# is the knife-edge statistic Batch AB caught flipping a whole zone on a
	# two-run difference.
	depth_reached.append(run.zone_idx * run.SLOTS_PER_ZONE + run.slot_idx + 1)
	if _run_r8 >= 0.0:
		r8_samples.append(_run_r8)
	# Stage 0a: the slot ladder and what is actually worn on it. Slots open
	# on boss kills, so a run that ends in zone 1 never owned a third slot —
	# that is a structural half of dilution and nobody had measured it.
	for m in run.party:
		slots_avail_sum += run.rune_slots()
		var spec_scope := "spec:%s" % String(m.get("spec", ""))
		var worn := 0
		for r in m.get("runes", []):
			if not r.get("equipped", false):
				continue
			worn += 1
			var scope := String(r.get("scope", "universal"))
			var kind := "universal"
			if String(r.get("id", "")).begins_with("tpl_"):
				kind = "stick"  # the generated Common family, not authored
			elif scope == spec_scope:
				kind = "spec"
			elif scope.begins_with("class:"):
				kind = "class"
			worn_kind[kind] = int(worn_kind.get(kind, 0)) + 1
		slots_filled_sum += worn
	# Progress line (Batch W), mirroring the sweep's per-stage marker: the run
	# report only prints at the very end, so without this a long invocation is
	# indistinguishable from a hung one for its entire life.
	print("run %d/%d — %s (%d completed so far)" % [runs_done, runs_target,
		("COMPLETED" if done else "wiped z%d t%d" % [run.zone_idx + 1,
		run.slot_idx + 1]), completed])
	if runs_done < runs_target:
		start_run(run)
		battle.get_tree().reload_current_scene()
	else:
		_print_report(battle)
		run.active = false
		battle.get_tree().quit()


# Batch AN §4: the mini-boss award is a generic ABILITY UPGRADE, chosen
# from three. The bot takes the FIRST offer entry — the four placeholders
# are not comparable without a payoff model, and a policy that pretended to
# rank them would be inventing a preference this batch has no basis for.
static func _award_upgrades(run: Node) -> void:
	for m in run.party:
		var offer: Array = run.roll_upgrade_offer(m)
		if offer.is_empty():
			continue
		m["upgrades"] = m.get("upgrades", []) + [(offer[0] as Dictionary).duplicate()]
		upgrade_taken += 1


# Ability awards (zone bosses only since Batch AN), resolved instantly
# instead of owed to the party screen. The bot rolls the SAME offer-of-3 a
# player would see (Run.roll_ability_offer) and picks from THAT, so a sim
# can never take an ability the real flow would not have offered it.
# DOD_SIM_TROPHIES names win when they are in the offer, else offer order.
static func _award_trophies(run: Node) -> void:
	var wanted: Array = []
	for trophy_name in OS.get_environment("DOD_SIM_TROPHIES").split(",", false):
		wanted.append(trophy_name.strip_edges())
	for m in run.party:
		var offer: Array = run.roll_spec_ability_offer(m)
		if offer.is_empty():
			continue
		var pick := ""
		for trophy_name in wanted:
			if trophy_name in offer:
				pick = trophy_name
				break
		if pick == "":
			pick = String(offer[0])
		m["bm_abilities"] = m.get("bm_abilities", []) + [pick]
		ability_offered += offer.size()
		ability_taken += 1


# Spend every point the policy can: same bookkeeping as the party screen's
# _learn_talent (1 point a node, the purse can_learn names), driven by
# _next_buy.
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
			# Batch AN: `Talents.purse_for` decides, exactly as the hero
			# sheet does — flex first while it holds anything, ordinary
			# points after. Reading `pool` raw here would strand the surplus
			# in the bank, and the sim would report a tree three nodes
			# shallower than a player's.
			var purse := Talents.purse_for(m,
				Talents.can_learn(tree, buy, learned))
			if purse == "":
				break
			learned[buy] = 1
			m["talents"] = learned
			m[purse] = int(m.get(purse, 0)) - 1
			_run_spent += 1


static func _target_lane(spec: String, tree: Array) -> String:
	var want := String(builds.get(spec, ""))
	if want != "":
		return want
	return String(tree[0].get("lane", ""))


static func _pick_rune_candidate(member: Dictionary, candidates: Array) -> Dictionary:
	var spec := String(member.get("spec", ""))
	var tree: Array = member.get("tree", [])
	var target := _target_lane(spec, tree) if not tree.is_empty() else ""
	if target != "":
		for c in candidates:
			if String(c.get("lane", "")) == target:
				return c
	for c in candidates:
		if String(c.get("scope", "")) == "spec:%s" % spec:
			return c
	return candidates[0]


# The next node the policy buys (Batch AI: rows, not lanes).
#   Normal points: the target lane's node in the lowest open row, and the
#   target lane's capstone once the shelf opens. A lane holds exactly one
#   node per row, so a pure-lane build is always available — no spillover
#   rule is needed to keep the bot spending.
#   Surplus: a SECOND node in the lowest row that has one pick, taken from
#   the next lane in tree order. Deliberately dumb and deterministic.
# "" = nothing learnable with anything the hero is carrying — bank it.
#
# BATCH AN: the ROW picks still come first and the SECOND-node picks second,
# which is the ordering that matters — climbing before widening. What
# changed is that ordinary points can now pay for the widening once the
# eight rows are spent, so the second pass runs on `talent_points` too
# rather than only on a flex purse nothing feeds any more.
static func _next_buy(m: Dictionary, tree: Array, target: String) -> String:
	var learned: Dictionary = m.get("talents", {})
	var lanes: Array = [target]
	for t in tree:
		var lane := String(t.get("lane", ""))
		if not lane in lanes:
			lanes.append(lane)
	if int(m.get("talent_points", 0)) < 1 and int(m.get("talent_flex", 0)) < 1:
		return ""
	# Row picks before second-node picks: climbing beats widening while a
	# row is still unopened.
	for want_pool in ["points", "flex"]:
		for row in range(1, Talents.CAPSTONE_ROW + 1):
			for lane in lanes:
				for t in Talents.row_nodes(tree, row):
					if String(t.get("lane", "")) != lane:
						continue
					var check := Talents.can_learn(tree, String(t["id"]), learned)
					if check["ok"] and check["pool"] == want_pool \
							and Talents.purse_for(m, check) != "":
						return String(t["id"])
	return ""


static func _tier(key: String) -> Dictionary:
	if not tier_stats.has(key):
		tier_stats[key] = {"fights": 0.0, "wins": 0.0, "deaths": 0.0,
			"hp_pct": 0.0, "p_atk": 0.0, "p_ehp": 0.0,
			"e_atk": 0.0, "e_ehp": 0.0}
	return tier_stats[key]


# ---------- the report ----------

# Stage 0b's arithmetic. Nothing clever: a mean, a sample SD, and the
# smallest difference two same-sized rows could actually resolve. The point
# is not statistical rigour, it is that the project has never had ANY
# statement of what its instrument can see, and "completions at n=50 cannot
# distinguish a 3-point change from noise" is worth more than a formal
# power calculation nobody runs.
static func _mean(xs: Array) -> float:
	if xs.is_empty():
		return 0.0
	var s := 0.0
	for x in xs:
		s += float(x)
	return s / xs.size()


static func _sd(xs: Array) -> float:
	if xs.size() < 2:
		return 0.0
	var m := _mean(xs)
	var s := 0.0
	for x in xs:
		s += pow(float(x) - m, 2.0)
	return sqrt(s / (xs.size() - 1))


# Minimum detectable difference between two independent rows of n samples
# each, at 80% power and alpha 0.05 two-sided: 2.8 * SD * sqrt(2/n). Rough
# by design and labelled as such.
static func _mde(sd: float, n: int) -> float:
	return 2.8 * sd * sqrt(2.0 / maxf(float(n), 1.0))


static func _resolution_line(sd: float, n: int, fmt: String) -> String:
	return "      resolves a difference of %s (n=%d)   %s at n=100   %s at n=150" % [
		fmt % _mde(sd, n), n, fmt % _mde(sd, 100), fmt % _mde(sd, 150)]

static func _print_report(battle) -> void:
	var runs := maxf(float(runs_done), 1.0)
	print("\n===== DAWN OF DECAY — RUN REPORT =====")
	print("Runs: %d    Completed: %d (%.0f%%)    Wiped: %d (%.0f%%)" % [
		runs_done, completed, 100.0 * completed / runs,
		wipes.size(), 100.0 * wipes.size() / runs])
	var relics_env := OS.get_environment("DOD_SIM_RELICS")
	var troph := OS.get_environment("DOD_SIM_TROPHIES")
	var builds_env := OS.get_environment("DOD_SIM_BUILDS")
	var shops_desc := "on(heal<50% first, then priciest unowned incl. runes; 40g reserve)" \
		if shops_on else "OFF(v1 floor: buy nothing)"
	var items_desc := "on(drink Health Potion <35% HP)" \
		if items_on else "OFF(v1 floor: never drinks)"
	print("Policies: route=%s shops=%s" % [route, shops_desc])
	print("          items=%s builds=%s relics=%s" % [items_desc,
		builds_env if builds_env != "" else "default(first lane)",
		relics_env if relics_env != "" else "none"])
	print("          trophies=%s runes=elite-pick(lane>spec>first)+auto-equip(2/3/4 slots) events=first-valid" % [
		troph if troph != "" else "first-in-pool"])
	# Mirrors Run.runes_mode() without touching the autoload (RunSim reads
	# no autoloads — the injection discipline).
	var runes_env := OS.get_environment("DOD_SIM_RUNES")
	var runes_mode := runes_env if runes_env in ["off", "stats"] else "full"
	print("          runes_pool=%s (DOD_SIM_RUNES: full=authored pool, stats=Common family, off=none)" % runes_mode)
	var diff := OS.get_environment("DOD_SIM_DIFFICULTY")
	if not diff in ["standard", "wanderer"]:
		diff = "standard"
	print("          map=line (Batch AN: 3 zones x 12 fixed slots; DOD_SIM_MAP/MINIBOSS/START_RUNE/SPEC_OPENING are RETIRED with the branching map)  difficulty=%s (DOD_SIM_DIFFICULTY; alpha testing affordance, NOT balance)" % diff)
	var specs_desc := OS.get_environment("DOD_SIM_SPECS")
	if OS.get_environment("DOD_SIM_ROTATE") == "1":
		specs_desc = "rotating all twelve (DOD_SIM_ROTATE=1)"
	print("Specs: %s" % specs_desc)
	# Batch AD experiment arms — printed here so a row is reproducible from
	# its own header, and so a row that IS in an arm can never be mistaken
	# for a baseline.
	var econ_env := OS.get_environment("DOD_SIM_RUNE_ECON")
	var econ_desc := "rich(all slots open from t1 + spec-eligible grants at zone half-marks)" \
		if econ_env == "rich" else "normal"
	var power_env := OS.get_environment("DOD_SIM_RUNE_POWER")
	var power_mult := power_env.to_float() if power_env != "" else 1.0
	if power_mult <= 0.0:
		power_mult = 1.0
	print("          EXPERIMENT ARMS (Batch AD, sim-only, off by default, never shipped):")
	print("            rune_econ=%s (DOD_SIM_RUNE_ECON)" % econ_desc)
	print("            rune_power=x%.2f (DOD_SIM_RUNE_POWER: scales authored payload UPSIDE only —" % power_mult)
	print("              costs held at authored value; grant/new_ability, \"set\" fields and")
	print("              ability cost/cooldown reductions have no magnitude to scale)")
	# THE CONFOUNDER, stated in the header rather than buried in a comment.
	var shops_taken: float = float(type_taken.get("shop", 0)) / runs
	var shops_seen: float = float(type_offered.get("shop", 0)) / runs
	print("KNOWN CONFOUNDER on every rune number below: since Batch Y the bot's fight-first")
	print("  preference BINDS — it takes %.1f of %.1f shops offered per run. Sim rune" % [
		shops_taken, shops_seen])
	print("  acquisition is a FLOOR ON THE BOT'S ROUTING, not an estimate of a human's.")
	print("  No route policy in this harness ranks a shop above a fight (greedy/default/")
	print("  cautious/elites all put combat first), so the ceiling is NOT reachable by")
	print("  changing route — that gap is reported, not papered over with a policy")
	print("  invented mid-batch. DOD_SIM_RUNE_ECON=rich is what supplies the ceiling.")

	# ---------- Stage 0b: what this instrument can actually see ----------
	# Printed BEFORE the numbers it qualifies, on purpose. Two batches read
	# a 4-point completions move as "noise" without ever establishing that
	# the instrument could not have resolved anything smaller than a large
	# effect. It could not. Completions is demoted to secondary here and
	# always carries its band.
	var n_runs := int(runs_done)
	var d_mean := _mean(depth_reached)
	var d_sd := _sd(depth_reached)
	var r8_mean := _mean(r8_samples)
	var r8_sd := _sd(r8_samples)
	var p := float(completed) / runs
	# A row with 0 or 100% completions has zero binomial variance, which
	# would print an absurd "resolves 0 points". Clamp to the half-run
	# continuity floor so the band stays honest at the edges.
	var p_adj := clampf(p, 0.5 / runs, 1.0 - 0.5 / runs)
	var p_sd := sqrt(p_adj * (1.0 - p_adj))
	print("\nINSTRUMENT RESOLUTION (Batch AD stage 0b) — read this before the numbers:")
	print("  PRIMARY   depth reached      mean %.2f  SD %.2f  SE %.2f   (absolute tier, 1-33; a full clear is 33)" % [
		d_mean, d_sd, d_sd / sqrt(maxf(float(n_runs), 1.0))])
	print(_resolution_line(d_sd, n_runs, "%.2f tiers"))
	print("  PRIMARY   ratio@z1t8        mean %.3f  SD %.3f  SE %.3f   (%d of %d runs reached t8)" % [
		r8_mean, r8_sd, r8_sd / sqrt(maxf(float(r8_samples.size()), 1.0)),
		r8_samples.size(), n_runs])
	print(_resolution_line(r8_sd, maxi(r8_samples.size(), 1), "%.3f"))
	# TWO CAVEATS, both found by running Batch AD's arms rather than reasoned
	# out in advance. (1) This is the mean of PER-RUN ratios; the Matrix row
	# below reports the POOLED aggregate it has always reported, so the two
	# differ slightly by construction — same tier, different estimator, and
	# only the pooled one compares to pre-AD rows. (2) The sample is
	# CONDITIONED ON SURVIVAL: only runs that reach z1 t8 contribute. An
	# intervention that helps weak runs live longer ADDS weak runs to the
	# sample and pushes this mean DOWN while making the game easier. Depth
	# reached has no such bias, which is why it is the primary of the two.
	print("            ^ mean of per-run ratios (the Matrix row's ratio@z1t8 is the pooled")
	print("              aggregate — same tier, different estimator). SURVIVAL-CONDITIONED:")
	print("              an arm that changes who reaches t8 changes this sample's makeup.")
	print("  SECONDARY completions       %.0f%% (%d of %d)   95%% band +/-%.1f pts" % [
		100.0 * p, completed, n_runs, 100.0 * 1.96 * p_sd / sqrt(runs)])
	print(_resolution_line(100.0 * p_sd, n_runs, "%.1f pts"))
	print("            ^ AT THIS n, COMPLETIONS CANNOT DISTINGUISH A SMALL CHANGE FROM NOISE.")
	print("              Never quote it on its own; it is a binary read on a 2-6% event.")
	print("  SECONDARY wipe median       knife-edge at n=50 (Batch AB: a true null-change")
	print("            control moved it a whole zone on a two-run difference). Reported below,")
	print("            never quoted as a trend on its own.")

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
	if OS.get_environment("DOD_SIM_ROTATE") == "1":
		var rp := PackedStringArray()
		var rp_names: Array = spec_runs.keys()
		rp_names.sort()
		for rn in rp_names:
			rp.append("%s x%d" % [rn, int(spec_runs[rn])])
		print("Runs sampled per spec: %s" % ", ".join(rp))
	var rs_stale := int(battle.sim_stats.get("stalemates", 0.0))
	if rs_stale > 0:
		print("STALEMATES force-ended: %d battles (scored as losses — a fight "
			% rs_stale + "neither side could finish; see CLAUDE.md Batch W)")
	print("Per-spec contribution (avg per battle present):")
	print(battle._contrib_table(battle.sim_stats))
	# Batch AX §0: the only instrument that meets a boss, so the trash/boss
	# split lives here as well as in the standalone report.
	var rx_line: String = battle.ruin_report_line(battle.sim_stats)
	if rx_line != "":
		print(rx_line)
	# Batch AY §0: the Beastmaster's two — deepest Loyalty, and how often The
	# Pack really fields two. Same rule, same place.
	var px_line: String = battle.pack_report_line(battle.sim_stats)
	if px_line != "":
		print(px_line)
	# Batch AZ §0: the deepest Focus the marksman's patience actually reaches,
	# and what the converted half was paying there. Same rule, same place — and
	# a RUN is the only instrument whose fights are long enough to show it.
	var fx_line: String = battle.focus_report_line(battle.sim_stats)
	if fx_line != "":
		print(fx_line)
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

	# Batch U additions: what the run economy actually did.
	print("Gold per run: earned %.0f   spent %.0f   unspent at end %.0f" % [
		gold_earned / runs, gold_spent / runs, gold_unspent / runs])
	if shops_on:
		print("Shop buys per run: heals %.1f   restock %.1f   runes %.1f" % [
			heals_bought / runs, restock_bought / runs, runes_bought / runs])
	print("Items: used %.1f/run   carried unused at end %.1f" % [
		items_used / runs, items_left / runs])
	# Batch AN: rests are gone, so the recovery line is the per-slot heal and
	# what the bot bought instead. The bargain line replaces the route line
	# as the batch\'s most diagnostic: it is the only agency a run has left.
	print("Merchants met: %.2f/run   Events: %.2f/run" % [
		merchants_seen / runs, events_seen / runs])
	if offer_count > 0:
		var sev_avg := offer_severity_sum / float(offer_count)
		var mods := PackedStringArray()
		var mod_ids: Array = offer_taken.keys()
		mod_ids.sort_custom(func(a, b): return int(offer_taken[a]) > int(offer_taken[b]))
		for mid in mod_ids:
			mods.append("%s %.2f" % [String(mid),
				int(offer_taken[mid]) / float(runs)])
		print("Bargains taken: %.1f/run   avg severity %.2f" % [
			offer_count / runs, sev_avg])
		print("   by modifier (per run): %s" % "   ".join(mods))

	# ---------- Ability economy (Batch AH) ----------
	# Six awards a run (a mini-boss and a boss in each of three zones), three
	# choices each. "taken" below the ceiling means a hero ran its two pools
	# dry, which is the only way an award can pass a hero by.
	print("\nAbility economy (per run, per hero):")
	print("  Awards   offers %.2f (%.2f picks x3)   taken %.2f   ceiling 2.00 (zone bosses only)" % [
		ability_offered / runs / 4.0, ability_taken / runs / 4.0,
		ability_taken / runs / 4.0])
	print("  Upgrades %.2f/hero/run taken   ceiling 3.00 (one per mini-boss)" % [
		upgrade_taken / runs / 4.0])

	# ---------- Rune economy (Batch AD stage 0a) ----------
	# The half of the rune question no measurement has ever shown. Read it
	# next to the gold line above: unspent gold beside empty slots is a
	# specific diagnosis, and a different one from empty slots beside no
	# gold at all.
	print("\nRune economy (per run):")
	print("  Shop     offered %.2f   bought %.2f   (every shop rune is equipped at purchase)" % [
		rune_shop_offered / runs, runes_bought / runs])
	print("  Elite    candidates %.2f (%.2f caches x3)   taken %.2f   equipped %.2f" % [
		rune_elite_offered / runs, rune_elite_taken / runs,
		rune_elite_taken / runs, rune_elite_equipped / runs])
	if rune_granted > 0:
		print("  GRANTED  %.2f   <-- DOD_SIM_RUNE_ECON=rich is ON; this row is an experiment arm" % [
			rune_granted / runs])
	print("  Acquired per hero per run: %.2f   (the four written for a spec are the target)" % [
		(runes_bought + rune_elite_taken + rune_granted) / runs / 4.0])
	print("  Shop offers refused:  no free slot %.2f   unaffordable (40g reserve) %.2f   duplicate %.2f" % [
		rune_refused_noslot / runs, rune_refused_gold / runs, rune_refused_dupe / runs])
	print("  Elite runes won with no free slot: %.2f/run  (pouched, not worn)" % [
		(rune_elite_taken - rune_elite_equipped) / runs])
	# Batch AN: nothing is "walked past" any more — the merchant is scheduled
	# rather than dealt onto a board a route could miss, so the old dominant
	# refusal (ROUTING) is structurally gone and the remaining refusals above
	# are the whole story.
	var heroes_seen := maxf(slots_avail_sum, 1.0)
	print("  Slots at run end: %.2f available per hero, %.2f filled (%.0f%%)" % [
		slots_avail_sum / runs / 4.0, slots_filled_sum / runs / 4.0,
		100.0 * slots_filled_sum / heroes_seen])
	var kind_parts := PackedStringArray()
	for kind in ["spec", "class", "universal", "stick"]:
		kind_parts.append("%s %.2f" % [kind, float(worn_kind.get(kind, 0)) / runs / 4.0])
	print("  Worn per hero at run end, by kind: %s" % "   ".join(kind_parts))
	print("    (spec = one of the FOUR authored for that spec; stick = the generated Common family)")

	# Route agency (Batch Y): the batch's headline pair is choice rate
	# before vs after the link/deal rework — completions are a consequence.
	var steps := maxf(float(walk_steps), 1.0)
	print("\nRoute agency:")
	print("  Reachable nodes per step: %.2f    steps offering a real choice: %.0f%% (%d of %d)" % [
		reach_sum / steps, 100.0 * choice_steps / steps, choice_steps,
		walk_steps])
	var off_parts := PackedStringArray()
	var deck_parts := PackedStringArray()
	for ty in ["fight", "elite", "miniboss", "rest", "shop", "event", "boss"]:
		off_parts.append("%s %.1f/%.1f" % [ty,
			float(type_taken.get(ty, 0)) / runs,
			float(type_offered.get(ty, 0)) / runs])
		deck_parts.append("%s %.1f/%.1f" % [ty,
			float(deck_seen.get(ty, 0)) / runs,
			float(deck_present.get(ty, 0)) / runs])
	print("  Taken vs offered per run:  %s" % "   ".join(off_parts))
	print("  Ever reachable vs dealt per run:  %s" % "   ".join(deck_parts))

	# One machine-comparable row per invocation — the three-policy matrix
	# is assembled from these across runs (median wipe tier counts the
	# whole ladder: absolute tier = (zone-1)*11 + tier).
	var med_desc := "none"
	if not wipes.is_empty():
		var abs_tiers: Array = []
		for w in wipes:
			abs_tiers.append((int(w["zone"]) - 1) * 11 + int(w["tier"]))
		abs_tiers.sort()
		var n := abs_tiers.size()
		var med: float = float(abs_tiers[n / 2]) if n % 2 == 1 \
			else (abs_tiers[n / 2 - 1] + abs_tiers[n / 2]) / 2.0
		var mz := int(ceil(med / 11.0))
		var mt := med - (mz - 1) * 11.0
		med_desc = "%.1f (z%d t%.1f)" % [med, mz, mt]
	var r8_desc := "n/a"
	if tier_stats.has("1,8"):
		var t8: Dictionary = tier_stats["1,8"]
		var f8: float = maxf(t8["fights"], 1.0)
		r8_desc = "%.2f" % sqrt((t8["p_atk"] / f8) * (t8["p_ehp"] / f8) \
			/ maxf((t8["e_atk"] / f8) * (t8["e_ehp"] / f8), 1.0))
	# BATCH AN ROWS ARE NOT COMPARABLE WITH ANY EARLIER ROW, and the field
	# list says so rather than leaving it to be noticed: map= now reads
	# `line` and start=/specopen=/mb= are GONE, because the flags behind them
	# went with the branching map. depth= is out of 36 slots now, not 33
	# tiers, so even the primary metric changed units. A row carrying
	# `map=line` is an AN-or-later row; anything else predates the line.
	# choice= is retained and will read 0% forever — a line has no route
	# decision, and a missing field would look like a broken instrument.
	print("Matrix row: route=%s  map=line  diff=%s  econ=%s  power=x%.2f  bargain_sev=%.2f  depth=%.2f+/-%.2f (of 36)  ratio@z1t8=%s  completions=%.0f%%  wipe median slot=%s  choice=%.0f%%" % [
		route, diff,
		("rich" if OS.get_environment("DOD_SIM_RUNE_ECON") == "rich" else "normal"),
		power_mult,
		(offer_severity_sum / float(maxi(offer_count, 1))),
		_mean(depth_reached),
		_sd(depth_reached) / sqrt(maxf(float(runs_done), 1.0)),
		r8_desc, 100.0 * completed / runs, med_desc,
		100.0 * choice_steps / steps])

	print("Still excluded: bomb/revive/defense/mana items never used in battle (only the <35% heal drink); no pre-emptive or offensive item use; potions are never drunk ON THE MAP (Batch AN made them usable there and the bot does not); the bargain policy is severity-extreme only, never a read of the modifier against the party; shop rune picks ignore build synergy (priciest first).")
	print("=============================================\n")
