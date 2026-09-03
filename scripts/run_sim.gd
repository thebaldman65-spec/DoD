# Full-run simulation harness (Batch S): ./sim.sh --run N plays N complete
# runs — the real generated 16-slot branching map, real warbands at real
# budgets WITH tier stat scaling and the zone slot multiplier, state carried
# between battles exactly as a real run carries it, talent points earned AND
# spent — and reports where the runs end. The sweep isolates the composition axis;
# this instrument measures the whole difficulty curve, progression included.
#
# THE BOT IS DUMB ON PURPOSE. Every decision is a fixed, legible policy
# printed in the report header — a clever bot would make the numbers
# unattributable. We measure what the SYSTEMS do, not what a good player does.
#   Route (DOD_SIM_ROUTE)    three policies, ONE axis: how much ELITE the
#                            bot accepts (Batch BK). "greedy" takes the
#                            elite whenever one is reachable; "balanced"
#                            (the default, and what "default" now aliases
#                            to) puts trade nodes first and the elite
#                            ahead of the filler; "cautious" takes the
#                            elite only when nothing else is offered.
#                            "elites" aliases greedy. The spread between
#                            the three IS the deliverable — and it is a
#                            real spread again: Batch AN's line left one
#                            node reachable per step, so from AN to BJ the
#                            three policies were three samples of ONE walk
#                            (BG §1).
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
#   Blacksmith               buy the first offered pairing when the gold
#                            clears the 40g reserve (Batch BK §3).
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
# BATCH BM DELETED talent_spent / talent_left / boss_nodes_sum WITH THE
# IN-RUN PURSE THEY MEASURED. Every figure they ever produced is superseded,
# BK's 10.9 / 10.8 / 6.0 points per hero per run included: a run does not
# earn or spend talent points any more. `boss_entries` survives because the
# stage-0b resolution block counts boss reaches, which is still a real thing.
static var boss_entries := 0
static var boss_nodes_sum := 0.0  # avg nodes EQUIPPED entering a boss
static var rows_built := Talents.CAPSTONE_ROW  # DOD_SIM_ROWS: rows the loadout fills
static var diff_id := "wanderer"   # the rung this invocation walked, cached at
static var diff_rung := 1          # start_run — RunSim may never name `Run`
static var route := "balanced"
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
# Batch BK §3: the gold sink, split by how it FAILS — no gold is a pricing
# problem, nothing eligible is a pool problem, and the two want different
# fixes. `blacksmiths_seen` counts nodes WALKED, not nodes dealt.
static var merchants_bought := 0  # the bargain's reward, NOT a map node
static var blacksmiths_seen := 0
static var smith_bought := 0
static var smith_gold := 0.0
static var smith_refused_gold := 0
static var smith_refused_nothing := 0
static var items_used := 0        # potions drunk in battle (battle.gd increments)
static var items_left := 0.0      # consumables still carried when a run ends
static var gold_earned := 0.0     # everything a run ever held (start + income)
static var gold_spent := 0.0      # what the shop policy paid out
static var gold_unspent := 0.0    # balance at wipe or completion
static var heals_bought := 0      # rule 1: potions for the wounded
static var restock_bought := 0    # rule 2: consumables bought back at count 0
# BATCH CT §3: drops the sim DECLINED for want of a pouch slot. Counted and
# reported rather than swallowed — a cap the report does not mention reads as
# "everything landed", which is exactly the silence this project keeps banning.
static var drops_no_slot := 0
static var runes_bought := 0      # rule 2: runes bought (equipped at purchase)
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
# BATCH BO §3 — THE DRAFT. `draft_short` is the one worth watching for the
# next two batches: pools are thin until tranche 3, so an offer of three will
# often come up two or one, and the report says so rather than letting a short
# offer read as a broken instrument.
static var draft_attempts := 0    # elites that offered one (i.e. all of them)
static var draft_offered := 0     # cards SHOWN (3 per offer at a full pool)
static var draft_taken := 0       # offers resolved into an ability
static var draft_dropped := 0     # ...of those, ones that cost a bench (EG)
static var draft_short := 0       # offers that could not fill three cards
static var draft_refused_pool := 0  # offers with nothing left to show at all
# BATCH BX §2 — THE ONE NUMBER THE RATE CHANGE IS TO BE WATCHED BY, and it is
# counted at the OFFER rather than at the take: a hero already at the cap when
# the cards were shown. `draft_dropped` counts benches the bot actually made,
# which is the same figure only because the bot never declines; this one stays
# true of a policy that does. **BATCH EG WATCHES THIS NUMBER**: it is the
# 63%-of-offers figure the slot ladder was authored against.
static var draft_at_cap := 0
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
static var depth_reached: Array = []  # absolute slot at run end, 1..48
static var r8_samples: Array = []     # one ratio@z1t8 per run that fought it
static var _run_r8 := -1.0


static func begin(run: Node, n: int) -> void:
	active = true
	runs_target = maxi(n, 1)
	run.sim_run = true  # in-memory runs only — never touch the player's save
	route = OS.get_environment("DOD_SIM_ROUTE")
	# Batch BK: the three policies are greedy / balanced / cautious. "default"
	# and "elites" are kept as ALIASES rather than deleted — every sim script
	# and every Matrix row in the changelog names them, and a flag that
	# silently means something else is worse than one that still means what
	# it meant.
	if route in ["", "default"]:
		route = "balanced"
	elif route == "elites":
		route = "greedy"
	elif not route in ["greedy", "balanced", "cautious"]:
		push_warning("DOD_SIM_ROUTE '%s' unknown — using balanced" % route)
		route = "balanced"
	shops_on = not OS.get_environment("DOD_SIM_SHOPS") in ["off", "0"]
	items_on = not OS.get_environment("DOD_SIM_ITEMS") in ["off", "0"]
	for pair in OS.get_environment("DOD_SIM_BUILDS").split(",", false):
		var bits: PackedStringArray = pair.split(":")
		if bits.size() == 2:
			builds[bits[0].strip_edges()] = bits[1].strip_edges()
	# BATCH BM: DOD_SIM_ROWS is how many of the nine rows the equipped
	# loadout fills — 0 for an untalented party, 3 / 6 / 9 for the builds §7
	# pairs with each rung. Default 9 (a full tree); 0 is a real value, so
	# the check is "was it set", not "is it non-zero".
	var rows_env := OS.get_environment("DOD_SIM_ROWS")
	rows_built = clampi(int(rows_env), 0, Talents.CAPSTONE_ROW) if rows_env != "" \
		else Talents.CAPSTONE_ROW
	start_run(run)


# One draft + awakening, minus the screens: default heroes, DOD_SIM_RELICS
# armed at the draft, DOD_SIM_SPECS in the sim.sh class order.
static func start_run(run: Node) -> void:
	var relics: Array = []
	if OS.get_environment("DOD_SIM_RELICS") != "":
		relics = Array(OS.get_environment("DOD_SIM_RELICS").split(","))
	# BATCH BM §5: DOD_SIM_DIFFICULTY names a RUNG — wanderer | warden | ruin.
	# Batch Y's "standard" still resolves (Run.difficulty_id maps it to
	# warden, the rung tuned at the present balance) so every old script and
	# Matrix row reads. Default is rung 1, which is the rung an untalented
	# party is meant to meet.
	var diff: String = run.difficulty_id(OS.get_environment("DOD_SIM_DIFFICULTY"))
	run.new_run(["warrior", "mage", "cleric", "hunter"], relics, diff)
	diff_id = diff
	diff_rung = run.difficulty_rung()
	install_builds(run)
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
		run.equip_spec_talents(i)  # BATCH BM: the meta loadout, locked here
		var run_sn := String(Classes.SPEC_INFO[spec]["name"])
		spec_runs[run_sn] = int(spec_runs.get(run_sn, 0)) + 1
	# Batch AE: the sim gets the opening pick too, resolved through the same
	# _pick_rune_candidate policy the elite cache uses — otherwise the
	# harness measures a different game than the one shipping.
	run.specs_chosen = true
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
# BATCH BK: THE WALKER CHOOSES AGAIN. Batch AN's line left exactly one node
# reachable per step, so choice_steps was pinned at 0 for eleven batches and
# the three route policies were one walk (BG §1 had to correct that premise
# before it could read a number). The counters are unchanged — walk_steps,
# reach_sum, choice_steps, type_offered/type_taken all mean what they always
# meant — and they now have something to count.
#
# A step "offers a real choice" on BG's definition, kept byte for byte so the
# 0% it measured and the figure this batch prints are the same measurement:
# >= 2 nodes reachable AND not all of them the same type.
#
# NON-COMBAT NODES ARE RESOLVED HERE AND THE WALK CONTINUES. A blacksmith,
# merchant or event is a slot the party stands on; nothing reloads the battle
# scene for it, so the walker keeps stepping until it finds a fight.
static func walk_to_next_fight(run: Node) -> bool:
	while true:  # non-combat nodes resolve in place and the walk carries on
		_rich_top_up(run)
		var reach: Array = run.reachable()
		if reach.is_empty():
			return false
		if run.slot_idx < 0:
			_tally_map(run)  # fresh zone: book what the generator dealt
		var next_slot: int = run.slot_idx + 1
		walk_steps += 1
		reach_sum += reach.size()
		var kinds := {}
		for j in reach:
			kinds[String(run.map[next_slot][int(j)]["type"])] = true
		if reach.size() >= 2 and kinds.size() > 1:
			choice_steps += 1
		for k in kinds:
			type_offered[k] = int(type_offered.get(k, 0)) + 1
		# deck_seen means "ever REACHABLE on the taken path", not "taken" —
		# every option at this step counts, once. Against deck_present it is
		# the "the zone holds 6 blacksmiths, this route could reach 3" line,
		# and on Batch AN's line the two collapsed into each other.
		for j2 in reach:
			var key := "%d,%d" % [next_slot, int(j2)]
			if not _seen_nodes.has(key):
				_seen_nodes[key] = true
				var k := String(run.map[next_slot][int(j2)]["type"])
				deck_seen[k] = int(deck_seen.get(k, 0)) + 1
		var pick := _route_pick(run, next_slot, reach)
		var node: Dictionary = run.map[next_slot][pick]
		var ty := String(node["type"])
		type_taken[ty] = int(type_taken.get(ty, 0)) + 1
		run.advance(pick)
		if ty == "blacksmith":
			_blacksmith_visit(run)
			continue
		if ty == "merchant":
			merchants_seen += 1
			if shops_on:
				_shop_visit(run)
			continue
		if ty == "event":
			events_seen += 1
			_resolve_event(run)
			continue
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
			warband = run.compose(ty, next_slot + 1)
			node["theme"] = run.last_theme
		run.encounter = {"type": ty, "enemies": warband,
			"theme": node.get("theme", "Warband")}
		run.arm_fixed_modifier(ty)  # BATCH BM §5: rung 3's second twist
		return true
	return false  # unreachable: the loop only leaves through a return


# THE ROUTE POLICY, and it is one axis on purpose: HOW MUCH ELITE the bot
# accepts. Three orderings, printed in the report header, dumb and fixed —
# a clever router would make every other number unattributable.
#   greedy    elite first. Three elites is three modifiers, three rune
#             caches and three talent points against arriving at the
#             mini-boss wounded, and whether that trade pays is the one
#             question the whole map exists to ask.
#   balanced  trade nodes first, elite ahead of the filler.
#   cautious  elite LAST — taken only when nothing else is on offer.
# Every policy ranks the blacksmith at the top of the non-elite order, which
# is deliberate: §3 asks what fraction of income a BLACKSMITH-HEAVY route
# converts, and a policy that walks past the sink cannot answer it. The
# neutral (unsteered) walked distribution is measured over generated maps in
# test_batch_bk, not here.
const ROUTE_ORDER := {
	"greedy": ["elite", "blacksmith", "merchant", "event", "fight"],
	"balanced": ["blacksmith", "merchant", "elite", "event", "fight"],
	"cautious": ["blacksmith", "merchant", "event", "fight", "elite"],
}


static func _route_pick(run: Node, slot: int, reach: Array) -> int:
	var order: Array = ROUTE_ORDER.get(route, ROUTE_ORDER["balanced"])
	var best := int(reach[0])
	var best_rank := 99
	for j in reach:
		var rank: int = order.find(String(run.map[slot][int(j)]["type"]))
		if rank < 0:
			rank = order.size()  # miniboss / boss: never a choice, always alone
		if rank < best_rank:
			best_rank = rank
			best = int(j)
	return best


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
	for slot in run.map:
		for node in slot:
			var ty := String(node["type"])
			deck_present[ty] = int(deck_present.get(ty, 0)) + 1


static func _avg_hp(run: Node) -> float:
	var total := 0.0
	for m in run.party:
		total += float(m["hp"]) / maxf(float(m["max_hp"]), 1.0)
	return total / maxf(run.party.size(), 1.0)


# ---------- the shop policy (Batch U) ----------

# Prices come STRAIGHT OFF `Run` now (flat, no tier scaling; only the relic
# discount moves them). Stock never runs out; runes are one per member per
# visit, dupes re-rolled. (BATCH ES §1: the price used to be set by the rune's
# rarity tier, 50/100/160. There are no tiers — an authored rune carries its own
# price and a generated stat stick sits on `Runes.TEMPLATE_PRICE`.)
#
# BATCH CT: this used to be a hand-copied MIRROR of shop_screen.gd's table, and
# the copy broke the moment §4 added three ids — the loop below walks
# `run.ITEM_IDS` and indexes it, so a Cleansing Draught would have been a
# missing-key crash in every sim run, which no parse gate can see.
#
# **READ OFF THE RUN NODE AT RUNTIME, NEVER `preload`ed.** Preloading
# `shop_screen.gd` was tried first and it broke the WHOLE RUN HARNESS: that
# file names the `Run` autoload at compile time, autoloads are not registered
# when a `--script` SceneTree compiles its dependency chain, and the failure
# cascaded through this file into `test_run_harness.gd` ("Identifier not found:
# Run"). `run` is a parameter here; there is nothing to preload.
const GOLD_RESERVE := 40  # no purchase may dip below this — heals stay reachable


static func _price(run: Node, base: int) -> int:
	return maxi(int(round(base * (1.0 - run.relic_add("shop_discount")))), 1)


# The Peddler boiled to policy: (1) any hero under half health buys one
# Health Potion each; (2) then the priciest affordable offer not already
# carried — consumables at count 0, or a rune for a member with a free
# slot (equipped at purchase: the sim has no party screen, so an
# unequippable rune would be dead gold and is never offered to it);
# (3) every purchase respects the reserve.
# One drop, under the sim's stated policy: take it if it fits, DECLINE if it
# would need a slot the pouch has not got. See the call site for why declining
# rather than swapping is the honest default.
static func _sim_drop(run: Node, id: String) -> void:
	if run.needs_slot(id):
		drops_no_slot += 1
		return
	run.add_item(id)


static func _shop_visit(run: Node) -> void:
	var heal_price := _price(run, int(run.ITEM_PRICES["health"]))
	for m in run.party:
		if float(m["hp"]) / float(m["max_hp"]) < 0.5 \
				and run.gold - heal_price >= GOLD_RESERVE:
			run.gold -= heal_price
			_run_gold_spent += heal_price
			# BATCH CT: through `add_item`, so the sim's pouch obeys the same two
			# walls the player's does. Health is in the opening four, so its slot
			# always exists and this can only ever be refused by the STACK cap —
			# which is the same refusal a player meets, and the gold is spent
			# either way because the sim's policy already decided to spend it.
			run.add_item("health")
			heals_bought += 1
	var offers := _roll_rune_offers(run)
	for guard in 32:  # each buy shrinks the offer set; 32 = runaway insurance
		var best_item := ""
		var best_offer := -1
		var best_price := -1
		for id in run.ITEM_IDS:
			if int(run.items.get(id, 0)) > 0:
				continue  # already carried
			# BATCH CT §1: and it cannot buy a type it has no SLOT for. Without
			# this the restock loop would keep picking the most expensive unheld
			# type forever, paying for it and never receiving it — the guard below
			# would break the loop only after the gold was gone.
			if run.needs_slot(id):
				continue
			var p := _price(run, int(run.ITEM_PRICES[id]))
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
			run.add_item(best_item)
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


# THE BLACKSMITH POLICY (Batch BK §3), and it is the dumbest one that still
# exercises the sink: buy the FIRST offered pairing whenever the gold clears
# the same 40g reserve every other purchase respects. No preference between
# upgrades, no saving up for a later zone — a bot that shopped cleverly would
# make "what fraction of income does the sink convert" unattributable, and
# that fraction is the number §3 asks for.
static func _blacksmith_visit(run: Node) -> void:
	blacksmiths_seen += 1
	if not shops_on:
		return
	var offer: Array = run.roll_blacksmith_offer()
	if offer.is_empty():
		smith_refused_nothing += 1
		return
	var price: int = run.blacksmith_price()
	if run.gold - price < GOLD_RESERVE:
		smith_refused_gold += 1
		return
	if run.buy_blacksmith(offer[0]):
		smith_bought += 1
		smith_gold += price
		_run_gold_spent += price


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
	# a real build, not base kits. BATCH BM: the build is the EQUIPPED
	# loadout, fixed before the run, so this counts what was equipped rather
	# than what was bought along the way.
	if String(run.encounter.get("type", "")) in ["boss", "endboss"]:
		boss_entries += 1
		var nodes := 0.0
		for m in run.party:
			nodes += float((m.get("talents", {}) as Dictionary).size())
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
		# The three-field sync (two gains off, Rot's loss back on) is ONE
		# implementation on BattleUnit now, shared with battle.gd's victory
		# branch (Batch BJ §1) — it can no longer drift from the real one.
		battle.heroes[i].sync_victory_state(run.party[i])
	var node_type := String(run.encounter.get("type", "fight"))
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
		# Batch AN §6: drops honour the per-type stack cap, through the same
		# Run.add_item every other grant uses — a sim that could stockpile
		# past the cap would report an economy the game cannot produce.
		#
		# BATCH CT §3: AND THE SLOT CAP. A drop with no slot is a SWAP OFFER in
		# the real game, answered on the map; the sim has no map, so it needs a
		# POLICY and the policy is stated rather than implied: **IT DECLINES.**
		# That is a legal player answer and the conservative one, so the sim's
		# item economy is a FLOOR on the real thing rather than a guess at it.
		# The declines are counted and printed, because an unreported cap reads
		# as "everything landed".
		_sim_drop(run, run.random_loot())
		for extra_i in int(run.relic_add("loot_extra")):
			_sim_drop(run, run.random_loot())
		# BATCH BO §3 / BATCH BX §2 — AN ELITE OFFERS A DRAFT TO EVERY LIVING
		# HERO. BO offered to one drawn at random; BX makes it party-wide, and
		# the walk has to match battle.gd's victory branch or the sim measures a
		# draft rate the game does not have. Resolved instantly here rather than
		# owed to a screen, exactly as the trophy pick already is: the bot rolls
		# the SAME offer a player would see and takes from THAT, so a sim can
		# never hold a card the real flow would not have shown it.
		#
		# The health gate is the same one battle.gd applies and is likewise never
		# false in practice — `heal_party` runs below and the victory sync has
		# already returned the fallen — but a walk that silently depended on that
		# would be a walk that breaks the day it stops being true.
		for d_m in run.party:
			if int(d_m.get("hp", 0)) > 0:
				_award_draft(run, d_m)
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
			# BATCH EG §1 — THE SLOT BEFORE THE AWARD, the same order
			# `battle._resolve_boss` uses, so the bot's hero has the new slot
			# to receive the pick into.
			#
			# **AND THIS BRANCH IS WHY THE SIM ONLY EVER SEES 7 -> 8 -> 9.**
			# It gates the award on `has_next_zone()`, so the THIRD zone boss
			# — which pays a pick in the real game (BM §6 made the end boss a
			# separate slot) — ends the run here instead: `run_over` is set
			# below and the `endboss` node is never walked. The report line
			# that read `ceiling 2.00 (zone bosses only)` was that same
			# assumption written as a literal. **PRE-EXISTING AND REPORTED,
			# NOT FIXED HERE**: closing it moves every sim baseline in the
			# project, which is its own batch. `check_eg` §3 drives all three
			# grants on a real `_resolve_boss` instead.
			run.note_zone_boss_cleared()
			_award_trophies(run)  # never Relics.unlock_random — that persists
			run.advance_zone()
		else:
			run_over = true
	# Batch BK §3: the merchant and the event are MAP NODES now — walked to,
	# or walked past — and walk_to_next_fight resolves them. The one thing a
	# fight can still queue is the bargain's bought merchant.
	if merchant_owed:
		merchants_bought += 1
		if shops_on:
			_shop_visit(run)
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
				kind = "stick"  # the generated stat family, not authored
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
# player would see and picks from THAT, so a sim can never take an ability
# the real flow would not have offered it. **THE ROLLERS ARE NAMED AT THE
# SITE BELOW AND NOT HERE.** This header carried a second copy of the name,
# and a second copy is what goes stale: it went on naming the roller for
# eighteen batches after AN §4 deleted it.
# DOD_SIM_TROPHIES names win when they are in the offer, else offer order.
static func _award_trophies(run: Node) -> void:
	var wanted: Array = []
	for trophy_name in OS.get_environment("DOD_SIM_TROPHIES").split(",", false):
		wanted.append(trophy_name.strip_edges())
	for m in run.party:
		var offer: Array = run.roll_spec_ability_offer(m)
		if offer.is_empty():
			# BATCH EA §1: the real flow pays a spec-DRAFT card here rather
			# than skipping the hero, so the bot rolls the same fallback. A
			# sim that kept skipping would under-measure exactly the
			# population EA changed — the eight specs that can empty a boss
			# pool. The sequence is duplicated; the pool and its filter are
			# authored once, in `Run.roll_spec_fallback_offer`.
			offer = run.roll_spec_fallback_offer(m)
		if offer.is_empty():
			# BATCH EH §1: and the THIRD tier, for the same reason. A bot that
			# stopped at two would under-measure the case the third tier was
			# built for — a hero holding his whole spec draft pool, which EG §2
			# made reachable by keeping benched cards.
			offer = run.roll_class_fallback_offer(m)
		if offer.is_empty():
			continue
		var pick := ""
		for trophy_name in wanted:
			if trophy_name in offer:
				pick = trophy_name
				break
		if pick == "":
			pick = String(offer[0])
		run.hold_ability(m, pick, true)
		ability_offered += offer.size()
		ability_taken += 1


# BATCH BO §3 — ONE DRAFT OFFER, resolved instantly by bot policy. THE POLICY
# IS DUMB AND PRINTED: take the first card of the shuffled offer, and at the
# cap BENCH the oldest CARRIED ability to make room. IT NEVER DECLINES —
# declining is a real player choice and a legitimate end state, but a bot that
# declined would measure the machinery less, not more, and the
# take-one-bench-one path is exactly the one worth exercising at scale.
#
# **BATCH EG §2 — IT NAMES A CARRIED ABILITY, NOT AN EARNED ONE.** Those were
# the same list until this batch and are not now: `earned_ability_names` is the
# POOL and holds benched cards, which `unequip_earned_ability` correctly
# refuses — so a bot reading the pool would name a benched card, get a refusal
# string back, and count every capped offer as an untaken one. The bot must
# read the same set the bench step shows the player.
static func _award_draft(run: Node, m: Dictionary) -> void:
	draft_attempts += 1
	if not run.award_draft_pick(m):
		draft_refused_pool += 1
		return
	var queue: Array = m.get("draft_candidates", [])
	if queue.is_empty():
		return
	var offer: Array = queue[0]
	draft_offered += offer.size()
	if offer.size() < 3:
		draft_short += 1
	var drop := ""
	if run.ability_slots_full(m):
		draft_at_cap += 1
		var carried: Array = run.equipped_ability_names(m)
		if carried.is_empty():
			return
		drop = String(carried[0])
	# Through the SAME door the map screen calls, so a sim can never resolve a
	# draft by a rule the real flow does not have.
	if run.take_draft_ability(m, String(offer[0]), drop) != "":
		return
	draft_taken += 1
	if drop != "":
		draft_dropped += 1


# BATCH BM — THE BOT NO LONGER SPENDS POINTS, IT EQUIPS A LOADOUT. Talents
# are meta progression now: there is no in-run purse, and what a run wears is
# decided before it starts. DOD_SIM_BUILDS still names a lane per spec and
# still means "that lane's node in every row"; DOD_SIM_ROWS says how many of
# the nine rows the build is allowed to fill, which is what makes §7's
# "rows 1-3 at rung 1, 1-6 at rung 2, 1-9 at rung 3" measurable.
#
# IT NEVER READS Profile. A sim that read the player's ledger would make
# every baseline depend on whoever ran it; the loadout is installed on
# `Run.sim_talents` and `Run.equip_spec_talents` reads that under sim_run.
static func install_builds(run: Node) -> void:
	var loadout := {}
	for spec in Classes.all_specs():
		var tree: Array = Talents.generate_tree(String(spec), "")
		if tree.is_empty():
			continue
		var target := _target_lane(String(spec), tree)
		var learned := {}
		for row in range(1, mini(rows_built, Talents.CAPSTONE_ROW) + 1):
			var picked := ""
			for t in Talents.row_nodes(tree, row):
				if String(t.get("lane", "")) == target:
					picked = String(t["id"])
					break
			# The capstone shelf has no lane purity, so a lane whose shelf
			# entry sits elsewhere still takes one — the first on the shelf.
			if picked == "" and row == Talents.CAPSTONE_ROW:
				var shelf := Talents.row_nodes(tree, row)
				if not shelf.is_empty():
					picked = String(shelf[0]["id"])
			if picked != "":
				learned[picked] = 1
		loadout[String(spec)] = learned
	run.sim_talents = loadout


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
	# BATCH DB §3 — THE CAVEAT IS PRINTED BESIDE THE FIGURE, NOT FILED AWAY.
	# `DOD_SIM_BUILDS` defaults to each tree's FIRST lane, so the other two
	# thirds of every talent tree have never appeared in ANY measurement taken
	# in this project — Glacial Prison, Second Prison, Cold Snap, Glacial
	# Economy and Absolute Zero among them. THIS IS NOT A BUG: a fixed default
	# party is exactly what makes arms comparable across batches. It is a
	# permanent caveat on every sim figure, and it belongs where the next person
	# reading one will actually meet it. The counts are DERIVED, so a lane or a
	# spec added later moves them without anybody remembering to.
	var lanes_total := Talents.LANES * Classes.all_specs().size()
	var lanes_seen := Classes.all_specs().size()
	var builds_desc := builds_env
	if builds_desc == "":
		builds_desc = "default(FIRST LANE of each tree — %d of %d lanes NEVER MEASURED)" % [
			lanes_total - lanes_seen, lanes_total]
	print("          items=%s builds=%s relics=%s" % [items_desc, builds_desc,
		relics_env if relics_env != "" else "none"])
	print("          trophies=%s runes=elite-pick(lane>spec>first)+auto-equip(2/3/4 slots) events=first-valid" % [
		troph if troph != "" else "first-in-pool"])
	# Mirrors Run.runes_mode() without touching the autoload (RunSim reads
	# no autoloads — the injection discipline).
	var runes_env := OS.get_environment("DOD_SIM_RUNES")
	var runes_mode := runes_env if runes_env in ["off", "stats"] else "full"
	print("          runes_pool=%s (DOD_SIM_RUNES: full=authored pool, stats=generated stat family, off=none)" % runes_mode)
	# BATCH BM: the RUNG this row was walked at, read off the live run rather
	# than off the env — Batch Y's "standard" still resolves and maps to rung
	# 2, so an old script's row would otherwise print a name the ladder does
	# not have. `rows=` is the equipped loadout's depth, which is the OTHER
	# axis §7 pairs with the rung.
	# THE INJECTION DISCIPLINE (the Events pattern): a class_name script cannot
	# name an autoload — `Run` does not resolve here, and a --script test proves
	# it by failing to compile. Both are cached at start_run, where the run
	# object is in hand.
	var diff := diff_id
	var rung := diff_rung
	print("          map=branch (BATCH BM: 3 zones x 16 slots + the END BOSS = 49 encounters)  difficulty=%s rung %d of 3 (DOD_SIM_DIFFICULTY)  rows=%d of %d equipped (DOD_SIM_ROWS)" % [
		diff, rung, rows_built, Talents.CAPSTONE_ROW])
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
	print("  PRIMARY   depth reached      mean %.2f  SD %.2f  SE %.2f   (absolute slot, 1-48; a full clear is 48)" % [
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
	print("  zone tier   fights   win%   deaths/fight   hero HP% entering")
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
	print("\nHero power vs warband power, measured (not modelled):")
	print("  zone tier   hero Atk    hero effHP    warband Atk   warband effHP   ratio")
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
	# BATCH BL §1: the three re-validation rates. Printed here as well as in the
	# standalone report because the run harness is the only instrument that
	# meets bosses, mini-bosses and holds — and holds are one of the four ways a
	# declaration is discarded.
	print(battle.intent_report_line(battle.sim_stats))
	print("Per-spec contribution (avg per battle present):")
	print(battle._contrib_table(battle.sim_stats))
	# BATCH BF §1: the Break prevented audit, by source. Same rule, same place.
	var bp_line: String = battle.break_prevented_line(battle.sim_stats)
	if bp_line != "":
		print(bp_line)
	# BATCH CY §0: rounds to resolution split trash/elite/boss, and the four
	# ramp meters against what each spec is built around. A RUN is the only
	# instrument that meets all three encounter kinds, so this is the reading
	# the batch is judged on.
	var cy_line: String = battle.cy_report_line(battle.sim_stats)
	if cy_line != "":
		print(cy_line)
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
	# Batch BA §0: the average count of distinct statuses standing on a target
	# when the Survivalist strikes it — his damage multiplier, read directly.
	# Same rule, same place.
	var bx_line: String = battle.breadth_report_line(battle.sim_stats)
	if bx_line != "":
		print(bx_line)
	# Batch BC §1: the Devout's aggregate, decomposed into the terms it is built
	# from. Same rule, same place — and a run is where the release count has
	# room to run, since a smoke fight ends in 7 rounds.
	var dx_line: String = battle.faith_report_line(battle.sim_stats)
	if dx_line != "":
		print(dx_line)
	# Batch BD §1: the deadfall's springs and what the trap cap refused. A RUN is
	# where a three-charge trap has room to spend itself, so this is the honest
	# home for the number the slot rule is decided on.
	var tx_line: String = battle.trap_report_line(battle.sim_stats)
	if tx_line != "":
		print(tx_line)
	# BJ §3a: the signature-payoff table — the run harness is the standard
	# source for it (only a run ever meets a boss).
	var sx_block: String = battle.signature_report_block(battle.sim_stats)
	if sx_block != "":
		print(sx_block)
	# BATCH BM: no earned/spent/banked line — a run neither earns nor spends
	# talent points. What it wears was decided before it started, and THAT is
	# what the harness now reports. Meta points banked per run are a Profile
	# number and deliberately not measured here (a sim never touches Profile).
	print("Talent rows equipped: %d of %d   (nodes/hero %.1f over %d boss fights)" % [
		rows_built, Talents.CAPSTONE_ROW,
		boss_nodes_sum / maxf(boss_entries, 1.0), boss_entries])
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
	print("Items: used %.1f/run   carried unused at end %.1f   drops declined for want of a slot %.1f/run" % [
		items_used / runs, items_left / runs, drops_no_slot / runs])
	# Batch BK: merchants and events are WALKED to now, not rolled — read these
	# against the map's own copies (5 merchants and 5 events a zone, 15 each a
	# run) rather than against a per-fight chance.
	print("Merchants met: %.2f/run walked + %.2f/run bought with a bargain   Events: %.2f/run" % [
		merchants_seen / runs, merchants_bought / runs, events_seen / runs])
	# §3: the gold sink, and the number this batch was written for. Split by
	# how a visit failed — no gold and nothing eligible want different fixes.
	var smith_conv := 0.0
	if gold_earned > 0.0:
		smith_conv = 100.0 * smith_gold / gold_earned
	print("Blacksmiths walked: %.2f/run   bought %.2f   %.0f gold/run (%.0f%% of all income)" % [
		blacksmiths_seen / runs, smith_bought / runs, smith_gold / runs, smith_conv])
	print("   refused: no gold %.2f/run   nothing eligible %.2f/run" % [
		smith_refused_gold / runs, smith_refused_nothing / runs])
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
	print("  Awards   offers %.2f (%.2f picks x3)   taken %.2f   ceiling 2.00 (the zone bosses the SIM plays — see _award_trophies)" % [
		ability_offered / runs / 4.0, ability_taken / runs / 4.0,
		ability_taken / runs / 4.0])
	print("  Upgrades %.2f/hero/run taken   ceiling 3.00 (one per mini-boss)" % [
		upgrade_taken / runs / 4.0])
	# BATCH BO §3 — THE DRAFT, and it is ROUTE-DEPENDENT by construction: an
	# elite always offers one, elites run 0-3 a zone since BK, so a greedy
	# route drafts far more than a cautious one. Read `short` and `dry`
	# together — pools are thin until tranche 3 and BOTH are expected to be
	# large until then. They are printed rather than smoothed over precisely
	# so "the pool is thin" never gets mistaken for "the roller is broken".
	print("  Draft    %.2f offers/run   %.2f cards shown   taken %.2f   cost a bench %.2f" % [
		draft_attempts / runs, draft_offered / runs, draft_taken / runs,
		draft_dropped / runs])
	print("           short offers (pool under 3) %.2f/run   nothing left to offer %.2f/run" % [
		draft_short / runs, draft_refused_pool / runs])
	# BATCH BX §2 — THE RATE CHANGE, STATED SO IT IS WATCHED RATHER THAN
	# DISCOVERED. An elite offers to all four heroes now, so the offers line
	# above is ~4x BO's; `at cap` is the share of those offers where taking a
	# card meant dropping one, which is the figure the "constant meaningful
	# decisions, or churn?" question actually turns on.
	print("           at cap when offered %.2f/run (%.0f%% of offers)" % [
		draft_at_cap / runs,
		100.0 * draft_at_cap / maxf(draft_attempts, 1.0)])

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
	print("    (spec = one of the FOUR authored for that spec; stick = the generated stat family)")

	# ROUTE AGENCY — Batch BK's headline, and it is the SAME measurement Batch
	# BG printed as 0% of 2,764 steps. 42 steps a run (an entry plus 13
	# transitions in each of three zones); a step is a real choice only when
	# >= 2 nodes are reachable AND they are not all the same type.
	var steps := maxf(float(walk_steps), 1.0)
	print("\nRoute agency:")
	print("  Walk steps per run: %.1f   reachable nodes per step %.2f" % [
		walk_steps / runs, reach_sum / steps])
	print("    (48 on a full clear: 42 branching columns plus the 6 forced steps onto the mini-bosses and bosses)")
	print("  DECISIONS — steps offering a real choice: %.1f per run, %.0f%% of steps (%d of %d)" % [
		choice_steps / runs, 100.0 * choice_steps / steps, choice_steps,
		walk_steps])
	print("    (Batch BG measured this as 0%% of 2,764 steps: a line has no route decision)")
	var off_parts := PackedStringArray()
	var deck_parts := PackedStringArray()
	for ty in ["fight", "elite", "miniboss", "blacksmith", "merchant",
			"event", "boss"]:
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
			abs_tiers.append((int(w["zone"]) - 1) * 16 + int(w["tier"]))
		abs_tiers.sort()
		var n := abs_tiers.size()
		var med: float = float(abs_tiers[n / 2]) if n % 2 == 1 \
			else (abs_tiers[n / 2 - 1] + abs_tiers[n / 2]) / 2.0
		var mz := int(ceil(med / 16.0))
		var mt := med - (mz - 1) * 16.0
		med_desc = "%.1f (z%d t%.1f)" % [med, mz, mt]
	var r8_desc := "n/a"
	if tier_stats.has("1,8"):
		var t8: Dictionary = tier_stats["1,8"]
		var f8: float = maxf(t8["fights"], 1.0)
		r8_desc = "%.2f" % sqrt((t8["p_atk"] / f8) * (t8["p_ehp"] / f8) \
			/ maxf((t8["e_atk"] / f8) * (t8["e_ehp"] / f8), 1.0))
	# NO BATCH AN-TO-BJ ROW IS COMPARABLE WITH A BK ROW EITHER, and the field
	# list says so rather than leaving it to be noticed: map= reads `branch`,
	# depth= is out of 49 SLOTS (BATCH BM added the end boss) not 48, and route= is a real axis again rather
	# than three names for one walk. A row carrying `map=line` is an AN-to-BJ
	# row; `map=branch` is BK or later; anything else predates both.
	print("Matrix row: route=%s  map=branch  diff=%s(r%d) rows=%d  econ=%s  power=x%.2f  bargain_sev=%.2f  depth=%.2f+/-%.2f (of 49)  ratio@z1t8=%s  completions=%.0f%%  wipe median slot=%s  choice=%.0f%%" % [
		route, diff, rung, rows_built,
		("rich" if OS.get_environment("DOD_SIM_RUNE_ECON") == "rich" else "normal"),
		power_mult,
		(offer_severity_sum / float(maxi(offer_count, 1))),
		_mean(depth_reached),
		_sd(depth_reached) / sqrt(maxf(float(runs_done), 1.0)),
		r8_desc, 100.0 * completed / runs, med_desc,
		100.0 * choice_steps / steps])

	print("Still excluded: bomb/revive/defense/mana items never used in battle (only the <35% heal drink); no pre-emptive or offensive item use; potions are never drunk ON THE MAP (Batch AN made them usable there and the bot does not); the bargain policy is severity-extreme only, never a read of the modifier against the heroes; shop rune picks ignore build synergy (priciest first).")
	print("=============================================\n")
