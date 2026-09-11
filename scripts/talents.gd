# THE TALENT TREE — ONE TREE, TWENTY-SEVEN NODES (BATCH FX).
#
# **ONE TREE, NOT FOUR, AND IT KEYS TO THE CLASS.** Every hero wears the same
# twenty-seven nodes, and each CLASS buys them out of its own purse on
# `Profile` — a Berserker, a Warden and a Swordmaster all spend the Warrior's
# points in this one tree. The designer ruled the shape at FX: FW measured that
# any two class trees would share at least 49 ideas by arithmetic alone,
# because under the line nothing left is class-specific, so four trees would be
# one list dealt four times. The specs still exist; only the talent layer
# merged.
#
# **THE LINE, RULED AT FX: A TALENT MAY NOT TOUCH A RUNE, AN ABILITY, A PASSIVE
# OR AN ENGINE.** So every node below is `stat` payloads on fields the battle
# already reads — no `ability` edit, no grant, no condition — and the tree
# grants no ability (DO's rule, which the line keeps).
#
# THE SHAPE:
#   - THREE TIERS OF NINE. A cell costs its tier (1 / 2 / 3), so the whole tree
#     is 9 + 18 + 27 = 54 points — BM's curve, unchanged.
#   - FLAT WITHIN A TIER: no lanes, no rows, no graph and no per-node
#     prerequisite. Within an open tier a class buys what it can afford.
#   - BOTH GATES APPLY TO A TIER. The DIFFICULTY gate is BM's and EN §3's
#     (`TIERS_OPEN`, keyed on the end-boss rung beaten — a fresh profile opens
#     nothing, which is the tutorial gate). The SPEND gate is FX's: a tier opens
#     only once `TIER_SPEND_MIN` cells of the tier below are bought.
#   - NO NODE IS EXCLUSIVE, SO BUYING A CELL IS WEARING IT. BM's unlock-is-not-
#     equip distinction priced a choice of ONE node per row against two closed
#     doors; with no rows and nothing exclusive there is nothing left to choose
#     between, and an equip step would be a click that can only ever say yes.
#     Every cell a class owns is on every hero of that class, every run.
#
# THE LEDGER LIVES ON `Profile`; this file owns the SHAPE of the tree and the
# rules about it, and answers `can_buy` / `can_refund` so the build screen, the
# run and the tests cannot disagree.
class_name Talents

# How many tiers, how many nodes in each, and what a cell in each costs. The
# price IS the tier, so a full tree is 9*1 + 9*2 + 9*3 = 54 points.
const TIERS := 3
const NODES_PER_TIER := 9
const TIER_COSTS := [1, 2, 3]

# THE DIFFICULTY GATE — how many tiers a profile may buy into, indexed by
# `Profile.talent_tier()`: the highest rung whose END BOSS has fallen, 0-3. A
# fresh profile opens NOTHING, and that is the rule rather than a default: rung
# 1 is the only door into the talent layer (EN §3, standing). It is BM's
# `[0, 3, 6, 9]` read in tiers instead of rows, so the shape is unchanged —
# rung 1 opens the first third of the tree, rung 2 the second, rung 3 the rest.
const TIERS_OPEN := [0, 1, 2, 3]
const MAX_TIER := 3

# THE SPEND GATE (FX §1) — how many cells of the tier BELOW must be owned
# before a tier opens. Counted in CELLS, so it means the same thing at both
# gates: three tier-1 cells open tier 2, three tier-2 cells open tier 3.
# **THE NUMBER IS A CANDIDATE AND IT IS THE DESIGNER'S TO SET** — its range is 1
# (the gate is decorative) to 9 (the tier below must be bought out). 3 is
# derived rather than chosen: it is the three nodes of a tier a hero used to
# wear in a run (one per row, three rows to a tier), and it is exactly the
# purse one completed run banks (a point per zone boss). `docs/reports/FX.md` §1
# prices both ends of the range.
const TIER_SPEND_MIN := 3

# ── THE TWENTY-SEVEN ──────────────────────────────────────────────────────────
#
# **EVERY NODE IS A STAT PAYLOAD ON A FIELD THE BATTLE ALREADY READS** — FW's
# TODAY — and no two nodes write the same field, so no node is a second
# magnitude of another. **WHERE ONE OF FP's SURVIVING NODES ALREADY SAID THE
# THING, ITS MAGNITUDE AND ITS WORDING WERE TAKEN** (FX §3); the comment above
# each node names its precedent, or says there was none and what the proposed
# number was priced against. The wording lost its pronouns (the text standard)
# and the spec it no longer belongs to; no magnitude moved in the carry.
#
# **FOUR OF THE BRIEF'S TWENTY-SEVEN WERE NOT TODAY FOR A TREE ALL FOUR CLASSES
# BUY, AND AN ALTERNATE STANDS IN EACH PLACE** (FX §2): *regenerate more
# resource* pays no Warrior (Rage has no regeneration field) and no Mage
# (Evocation assigns over the field at the spawn); *debuffs on you expire
# sooner* has no field — the one that exists moves buffs as well; *a Perfect
# pays* pays Mana only; and *Elusive while you carry an affliction* has no field
# — the one that exists pays when a hero AFFLICTS. None was rescued with a hook.
#
# AND MOST OF THESE FIELDS ARE READ IN `_resolve`'s ORDINARY STRIKE BRANCH, which
# an ability carrying a `special` never reaches (FW's trap 6): damage dealt and
# taken, Break dealt, penetration and every on-crit rider pay on ordinary blows.
const TREE := [
	# ── TIER 1 — one point each. Stat creep, and the designer ruled it correct. ──
	# PRECEDENT: Woodcraft (sv_woodcraft) and Unwavering Faith (dv_unwavering),
	# which were the same node twice — max_hp_pct 0.20. TAKEN.
	{"id": "tn_health", "name": "More Health", "tier": 1,
		"desc": "+20% maximum Health.",
		"payload": {"stat": {"max_hp_pct": 0.20}}},
	# NO PRECEDENT: no node ever wrote `attack`. PROPOSED at +10, priced against
	# the party Attack boons two events pay (+10%, Blood Altar and Training
	# Grounds), which is +10 on a base-100 hero.
	{"id": "tn_attack", "name": "More Attack", "tier": 1,
		"desc": "+10 Attack.",
		"payload": {"stat": {"attack": 10}}},
	# NO PRECEDENT: no node ever wrote `armor`. PROPOSED at +0.05, the relic
	# layer's own armor hook (`hero_armor_add`, 0.05) — the one permanent armor
	# bonus that ships.
	{"id": "tn_armor", "name": "More Armor", "tier": 1,
		"desc": "+5% armor.",
		"payload": {"stat": {"armor": 0.05}}},
	# PRECEDENT: Steady Hands (ss_steady) — crit_bonus 0.15. TAKEN.
	{"id": "tn_crit", "name": "More Crit Chance", "tier": 1,
		"desc": "+15% critical chance.",
		"payload": {"stat": {"crit_bonus": 0.15}}},
	# PRECEDENT: Fletcher's Speed (ss_fletcher) — speed 18. TAKEN.
	{"id": "tn_speed", "name": "More Speed", "tier": 1,
		"desc": "+18 Speed.",
		"payload": {"stat": {"speed": 18.0}}},
	# PRECEDENT: Sword Mastery (sm_sword_mastery) — parry_bonus 0.12. TAKEN.
	{"id": "tn_parry", "name": "Parry More", "tier": 1,
		"desc": "+12% parry chance.",
		"payload": {"stat": {"parry_bonus": 0.12}}},
	# NO PRECEDENT: no node ever wrote `max_resource`. PROPOSED at +20, priced
	# against Woodcraft's +20% maximum Health, taken as the same share of a
	# 100-point pool.
	{"id": "tn_pool", "name": "A Bigger Resource Pool", "tier": 1,
		"desc": "+20 maximum Rage or Mana.",
		"payload": {"stat": {"max_resource": 20}}},
	# NO SURVIVING PRECEDENT: Reckless Fury paid +20% WITH +15% damage taken and
	# is not one of the 43. PROPOSED at +10%, the relic hook `hero_attack_mult`
	# (0.10), which lands in this same field at the spawn.
	{"id": "tn_damage", "name": "More Damage Dealt", "tier": 1,
		"desc": "+10% damage dealt.",
		"payload": {"stat": {"dmg_bonus": 0.10}}},
	# NO SURVIVING PRECEDENT: Measured Rage paid 20% as a row-6 node conditional
	# on Reckless Fury, and is not one of the 43. PROPOSED at 10%, the mirror of
	# More Damage Dealt.
	{"id": "tn_guard", "name": "Less Damage Taken", "tier": 1,
		"desc": "10% less damage taken.",
		"payload": {"stat": {"dmg_taken_bonus": -0.10}}},

	# ── TIER 2 — two points each. Each reads a condition rather than adding a number. ──
	# PRECEDENT: Broken Will (oc_broken_will) — broken_will_ranks 25. TAKEN.
	{"id": "tn_break", "name": "You Break Harder", "tier": 2,
		"desc": "Deals 25% more Break damage.",
		"payload": {"stat": {"broken_will_ranks": 25}}},
	# ALTERNATE, IN THE PLACE OF *REGENERATE MORE RESOURCE* (see the header).
	# PRECEDENT: Blood Communion (oc_blood_communion) — blood_communion 20. TAKEN.
	# THE BRIEF'S LABEL WAS "Breaking heals the party", AND BOTH HALVES OF IT
	# ARE WRONG HERE: the word *party* is retired from player-facing text
	# (CLAUDE.md, HERO AND ALLY — `test_batch_bx` §4b reads this file), and the
	# read site heals ONE body, the lowest-health hero. The name says that.
	{"id": "tn_break_heal", "name": "Breaking Heals a Hero", "tier": 2,
		"desc": "Every point of Break damage dealt heals the lowest-health hero for 20% of its value.",
		"payload": {"stat": {"blood_communion": 20}}},
	# PRECEDENT: Follow-Through (ss_follow) — follow_through 2. TAKEN.
	{"id": "tn_crit_cooldown", "name": "A Cooldown Ticks on a Crit", "tier": 2,
		"desc": "Critical hits reduce ALL cooldowns by 2.",
		"payload": {"stat": {"follow_through": 2}}},
	# ALTERNATE, IN THE PLACE OF *DEBUFFS ON YOU EXPIRE SOONER* (see the header).
	# PRECEDENT: Bonecracker (ss_bonecracker) — bonecracker_ranks 40. TAKEN.
	{"id": "tn_kill_down", "name": "Kill What Is Down", "tier": 2,
		"desc": "+40% damage against Broken enemies.",
		"payload": {"stat": {"bonecracker_ranks": 40}}},
	# PRECEDENT: Field Medic (sv_medic) — field_medic 2. TAKEN, and it is TWO:
	# the brief's label said "one", and the precedent's magnitude is the answer
	# (FX §3), so the name carries no number rather than the wrong one.
	{"id": "tn_cleanse", "name": "Cleanse Debuffs Each Turn", "tier": 2,
		"desc": "At the start of this hero's turn, cleanse 2 debuffs from random allies.",
		"payload": {"stat": {"field_medic": 2}}},
	# PRECEDENT: Last Hope (hl_last_hope) — last_hope_pct 40. Not one of the 43,
	# so it is a REFERENCE rather than salvage; a live node whose number has run.
	# PARTY-WIDE BY ITS READ SITE: the spawn stamps the best holder's figure on
	# every hero, so two holders in one party do not stack.
	{"id": "tn_last_hope", "name": "Heal More When Low", "tier": 2,
		"desc": "Heroes under 25% of their maximum health receive 40% more healing.",
		"payload": {"stat": {"last_hope_pct": 40}}},
	# PRECEDENT: Iron Will (wd_iron_will) — iron_will_ranks 1, which the read
	# site multiplies by 12. Not one of the 43: a REFERENCE, a live node.
	{"id": "tn_iron_will", "name": "Mitigation per Debuff You Carry", "tier": 2,
		"desc": "Takes 12% less damage for every debuff currently carried, to a maximum of 90%.",
		"payload": {"stat": {"iron_will_ranks": 1}}},
	# PRECEDENT: Armor Piercer (ss_piercer) — pierce_bonus 0.30. TAKEN.
	{"id": "tn_pierce", "name": "Armor Penetration", "tier": 2,
		"desc": "Attacks ignore 30% of the target's armor.",
		"payload": {"stat": {"pierce_bonus": 0.30}}},
	# PRECEDENT: Ghillie Suit (sv_ghillie) — ghillie 65. TAKEN.
	{"id": "tn_look_past", "name": "Enemies Look Past You", "tier": 2,
		"desc": "Enemies are 65% less likely to target this hero while another ally lives.",
		"payload": {"stat": {"ghillie": 65}}},

	# ── TIER 3 — three points each. ──
	# ALTERNATE, IN THE PLACE OF *A PERFECT PAYS* (see the header).
	# PRECEDENT: Whetstone (sm_whetstone) — whetstone 3. TAKEN.
	{"id": "tn_crit_pays", "name": "A Crit Pays", "tier": 3,
		"desc": "Every critical strike raises Attack by 3 for the rest of the battle.",
		"payload": {"stat": {"whetstone": 3}}},
	# PRECEDENT: Undying Rage (bz_undying) — undying_rage 1. Not one of the 43:
	# a REFERENCE, a live node. Its field carries a rider the read site pays and
	# no payload can take off — 50% more damage below a quarter's health until
	# the refusal is spent (`battle.gd`'s strike loop) — so the text states it.
	# AND THE REFUSAL ITSELF IS NOT GATED ON HEALTH, which the old text implied:
	# `unit.gd` refuses the killing hit whatever health it landed on.
	{"id": "tn_refuse_death", "name": "Refuse Death Once", "tier": 3,
		"desc": "Once per battle, the hit that would kill leaves 1 HP instead. Until that happens, deals 50% more damage below 25% health.",
		"payload": {"stat": {"undying_rage": 1}}},
	# PRECEDENTS, ONE PER CURRENCY: Last Rites (bz_last_rites) — last_rites 1,
	# the Rage form — and Conversion (ar_conversion) — conversion_ranks 30, the
	# Mana form. BOTH TAKEN. Each read site tests `resource_name`, so the node
	# writes both fields and every hero is paid in the one he holds.
	{"id": "tn_resource_ward", "name": "Pay a Lethal Hit out of Your Resource Pool", "tier": 3,
		"desc": "Rage: below 25% health, damage is paid out of Rage first, 1 Rage a point, and reaches health only once the Rage is gone. Mana: 30% of all damage taken is paid as Mana instead of health.",
		"payload": {"stat": {"last_rites": 1, "conversion_ranks": 30}}},
	# PRECEDENT: No Cover (ss_no_cover) — no_cover 1. TAKEN.
	{"id": "tn_no_miss", "name": "You Cannot Miss", "tier": 3,
		"desc": "Attacks cannot be made to miss: Blind and Dazed do not affect them, and Elusive does not protect against them.",
		"payload": {"stat": {"no_cover": 1}}},
	# ALTERNATE, IN THE PLACE OF *ELUSIVE WHILE YOU CARRY AN AFFLICTION* (see the
	# header). PRECEDENT: Devoutness (dv_devoutness) — devoutness_ranks 20. Not
	# one of the 43: a REFERENCE, a live node. PARTY-WIDE BY ITS READ SITE, like
	# Last Hope: the best holder's figure is stamped on every hero.
	{"id": "tn_unbreaking", "name": "We Do Not Break", "tier": 3,
		"desc": "Every hero takes 20% less Break damage.",
		"payload": {"stat": {"devoutness_ranks": 20}}},
	# PRECEDENT: Sundering Shot (ss_sundering) — sundering_shot 45. TAKEN.
	{"id": "tn_crack_guards", "name": "Your Crits Crack Guards", "tier": 3,
		"desc": "Critical hits deal 45 Break damage.",
		"payload": {"stat": {"sundering_shot": 45}}},
	# PRECEDENT: No Quarter (sm_perfect_form) — no_quarter_ranks 1, which the
	# read site multiplies by 45. TAKEN. It refills whatever pool the hero has,
	# so the text names both.
	{"id": "tn_break_refuel", "name": "Breaking an Enemy Refuels You", "tier": 3,
		"desc": "Breaking an enemy grants 45 Rage or Mana.",
		"payload": {"stat": {"no_quarter_ranks": 1}}},
	# PRECEDENT: Rapid Fire (ss_rapid) — rapid_fire 50. TAKEN.
	{"id": "tn_skip_cooldown", "name": "A Chance to Skip a Cooldown Entirely", "tier": 3,
		"desc": "Each ability used has a 50% chance not to start its cooldown.",
		"payload": {"stat": {"rapid_fire": 50}}},
	# PRECEDENT: Snap Shot (ss_snap) — snap_shot 2. TAKEN. The read site counts
	# only an ability that costs something, and the text says so.
	{"id": "tn_free_casts", "name": "Your First Casts of a Fight Are Free", "tier": 3,
		"desc": "Each fight, the first 2 abilities that cost anything cost nothing and start no cooldown.",
		"payload": {"stat": {"snap_shot": 2}}},
]


# ---------- the tree's shape, read off the data ----------

# The tree every hero wears, as a copy a caller may keep.
static func tree() -> Array:
	return TREE.duplicate(true)


# Which tier a node sits in.
static func tier_of(node: Dictionary) -> int:
	return clampi(int(node.get("tier", 1)), 1, TIERS)


# Every node in a tier, in authored order.
static func tier_nodes(tree_nodes: Array, tier: int) -> Array:
	var out: Array = []
	for t in tree_nodes:
		if tier_of(t) == tier:
			out.append(t)
	return out


# ---------- BATCH BM's meta layer, re-cut by tier at FX ----------

# What a cell in this TIER costs. The price IS the tier (1/2/3), and ONE place
# decides it, so the price and the gate cannot drift.
static func cell_cost(tier: int) -> int:
	return TIER_COSTS[clampi(tier, 1, TIERS) - 1]


# How many tiers a profile at this difficulty tier may buy into. A tier arrives
# FULLY open — beating difficulty 2 makes every tier-2 cell buyable at once, so
# far as the spend gate allows — which is what makes an uncapped bank worth
# having.
static func tiers_open(difficulty_tier: int) -> int:
	return TIERS_OPEN[clampi(difficulty_tier, 0, MAX_TIER)]


static func tier_open(tier: int, difficulty_tier: int) -> bool:
	return tier <= tiers_open(difficulty_tier)


# The lowest end-boss rung that opens this tier — what a locked cell's reason
# names. Read off `TIERS_OPEN` rather than assumed equal to the tier, so a
# re-mapped table cannot leave the message saying the old thing.
static func difficulty_for_tier(tier: int) -> int:
	for d in range(0, MAX_TIER + 1):
		if tiers_open(d) >= tier:
			return d
	return MAX_TIER


# What filling the whole tree costs, in points. 9 cells at each tier price = 54.
static func full_tree_cost() -> int:
	var total := 0
	for tier in range(1, TIERS + 1):
		total += cell_cost(tier) * NODES_PER_TIER
	return total


# How many cells of this tier a ledger owns.
static func bought_in_tier(tree_nodes: Array, cells: Dictionary, tier: int) -> int:
	var n := 0
	for t in tier_nodes(tree_nodes, tier):
		if bool(cells.get(String(t["id"]), false)):
			n += 1
	return n


# THE SPEND GATE. Tier 1 has nothing below it; every higher tier needs
# `TIER_SPEND_MIN` cells owned in the tier directly below.
static func spend_gate_met(tree_nodes: Array, cells: Dictionary, tier: int) -> bool:
	if tier <= 1:
		return true
	return bought_in_tier(tree_nodes, cells, tier - 1) >= TIER_SPEND_MIN


# CAN THIS CELL BE BOUGHT? {ok, why, cost}. `cells` is the class's owned set
# ({id: true}), `points` its available purse, `difficulty_tier` the GLOBAL rung
# tier. "why" prefixes matter to the build screen's greying: Owned / Locked /
# Costs. Both gates answer "Locked", and each names what opens it.
static func can_buy(tree_nodes: Array, id: String, cells: Dictionary,
		points: int, difficulty_tier: int) -> Dictionary:
	var t := node_in_tree(tree_nodes, id)
	if t.is_empty():
		return {"ok": false, "why": "Unknown", "cost": 0}
	var tier := tier_of(t)
	var cost := cell_cost(tier)
	if bool(cells.get(id, false)):
		return {"ok": false, "why": "Owned", "cost": cost}
	if not tier_open(tier, difficulty_tier):
		return {"ok": false, "cost": cost,
			"why": "Locked: beat the end boss on difficulty %d" % difficulty_for_tier(tier)}
	if not spend_gate_met(tree_nodes, cells, tier):
		return {"ok": false, "cost": cost,
			"why": "Locked: own %d more in tier %d first" % [
				TIER_SPEND_MIN - bought_in_tier(tree_nodes, cells, tier - 1), tier - 1]}
	if points < cost:
		return {"ok": false, "cost": cost,
			"why": "Costs %d — you have %d" % [cost, points]}
	return {"ok": true, "why": "", "cost": cost}


# CAN THIS CELL BE REFUNDED? A refund that leaves a tier short of
# `TIER_SPEND_MIN` while the tier above it holds cells would strand every one of
# them — owned, worn, and behind a gate that no longer opens — so it is refused,
# and the full respec (which clears every tier at once) is the way out.
static func can_refund(tree_nodes: Array, id: String, cells: Dictionary) -> Dictionary:
	var t := node_in_tree(tree_nodes, id)
	if t.is_empty():
		return {"ok": false, "why": "Unknown"}
	if not bool(cells.get(id, false)):
		return {"ok": false, "why": "Not owned"}
	var tier := tier_of(t)
	if tier < TIERS and bought_in_tier(tree_nodes, cells, tier + 1) > 0 \
			and bought_in_tier(tree_nodes, cells, tier) - 1 < TIER_SPEND_MIN:
		return {"ok": false,
			"why": "Tier %d holds cells that need %d owned here" % [tier + 1, TIER_SPEND_MIN]}
	return {"ok": true, "why": ""}


# THE LEDGER AS THE {id: ranks} SET every read site in the game already speaks
# — Run.party members, apply_from_tree, battle.gd. Buying is wearing, so this is
# every owned cell the tree still holds; an id it no longer holds is dropped
# rather than carried.
static func worn_learned(tree_nodes: Array, cells: Dictionary) -> Dictionary:
	var learned := {}
	for id in cells:
		if bool(cells[id]) and not node_in_tree(tree_nodes, String(id)).is_empty():
			learned[String(id)] = 1
	return learned


# What a class's ledger has SPENT, read off the cells it owns. Points earned
# minus this is what is available — so a respec is "drop the cells, get their
# price back" with no second accounting anywhere.
static func cells_spent(tree_nodes: Array, cells: Dictionary) -> int:
	var total := 0
	for id in cells:
		if not bool(cells[id]):
			continue
		var t := node_in_tree(tree_nodes, String(id))
		if not t.is_empty():
			total += cell_cost(tier_of(t))
	return total


# ---------- hooks the class batches author against (Batch AI §5) ----------

# Was this node taken? The condition every "if you also picked X" payload
# reads, and the one battle.gd calls at resolve time.
static func has_node(learned: Dictionary, id: String) -> bool:
	return int(learned.get(id, 0)) > 0


# THE list of every ability display name a hero can cast: core kit + spec
# kit + kit-override renames + earned picks (Runes.kit_names, which is what
# the action bar is built from), PLUS anything a LEARNED talent node grants.
# Run.owned_ability_names forwards to this, so the ability-offer roller, the
# rune "requires_ability" filter and a node's condition all read one list
# and can never disagree with what the player sees on their own bar.
# (Lives here rather than on Run: autoload identifiers do not resolve inside
# a class_name script — the same reason RunSim takes Run injected.)
static func ability_names(member: Dictionary) -> Array:
	var names: Array = Runes.kit_names(member)
	var learned: Dictionary = member.get("talents", {})
	for node in member.get("tree", []):
		if int(learned.get(String(node.get("id", "")), 0)) < 1:
			continue
		var pay: Dictionary = node.get("payload", {})
		if pay.has("new_ability"):
			names.append(String(pay["new_ability"]["display_name"]))
		elif pay.has("grant_ability"):
			names.append(String(pay["grant_ability"]))
	return names


# Does this hero currently have the ability, from ANY source — starting kit,
# kit override, mini-boss/boss pick, or a talent grant?
static func owns_ability(member: Dictionary, display_name: String) -> bool:
	if member.is_empty() or display_name == "":
		return false
	return ability_names(member).has(display_name)


# A payload's optional "condition": {"has_node": id} / {"owns_ability": name},
# or both (ALL must hold). ctx carries {learned, member} — an empty ctx makes a
# conditional payload inert rather than silently unconditional, which is the
# safe direction: an effect that fails to appear is a bug you can see.
#
# ── BATCH FN — THE TWO RUNE CONDITIONS CAME THROUGH HERE AND NO LONGER DO ───
# **EZ §0 added two keys, `tag_threshold` and `tag_breadth`, and handed the
# whole `cond` dict to `Runes.loadout_condition_met` so that this file named no
# tag word.** FK retired both secondaries going forward and FN took them off the
# eight runes that still carried one, so **no payload in the tree carries either
# key** — asserted over `data/runes.json` by `check_fn` §1 and by `check_fk` §2,
# rather than left as a property of a table nobody re-reads.
#
# **THE CALL IS REMOVED RATHER THAN LEFT RETURNING TRUE.** A door that can only
# answer one way is not a door, and `check_ek` §3's whole claim is about which
# files reach the tag surface: with the call gone this file names none of it
# again, and moves back out of that gate's `TAG_CONSUMERS` and into its
# `NO_TAG_FILES` — a tighter bound, not a looser one. The day a rune asks a
# loadout question again, the door comes back with it.
static func condition_met(cond: Dictionary, ctx: Dictionary) -> bool:
	if cond.is_empty():
		return true
	if cond.has("has_node") \
			and not has_node(ctx.get("learned", {}), String(cond["has_node"])):
		return false
	if cond.has("owns_ability") \
			and not owns_ability(ctx.get("member", {}), String(cond["owns_ability"])):
		return false
	return true


# ---------- tree build ----------

# Every ability a talent NODE grants, by display name — the single source
# the earnable pools read, so a pool copy can never drift from the copy a
# talent purchase hands out.
static func granted_ability(display_name: String) -> Ability:
	for node in TREE:
		var pay: Dictionary = node.get("payload", {})
		if pay.has("new_ability") \
				and String(pay["new_ability"]["display_name"]) == display_name:
			return Ability.make(pay["new_ability"])
		if pay.has("grant_ability") and String(pay["grant_ability"]) == display_name:
			return Classes.pending_talent_ability(display_name)
	return null


# BATCH FX — THE TREE KEYS TO THE CLASS, AND THERE IS ONE. `generate_tree`
# still takes the hero's SPEC, because that is what every caller holds, and
# answers "the tree this spec's class buys into" — which is `TREE` for every
# class. A spec with no class (an unawakened hero) has none.
static func has_tree(spec: String) -> bool:
	return Classes.class_of_spec(spec) != ""


static func generate_tree(spec: String, _class_key: String) -> Array:
	if not has_tree(spec):
		return []
	return tree()


static func node_in_tree(tree_nodes: Array, id: String) -> Dictionary:
	for t in tree_nodes:
		if t["id"] == id:
			return t
	return {}


# Tooltip text for a node: "{v}" in the desc becomes scale.base +
# scale.step. Since Batch AI every node is a single rank, so this renders
# the one value the node will ever have — learned or not.
static func desc_for(node: Dictionary, ranks: int) -> String:
	var desc: String = node["desc"]
	if node.has("scale"):
		var sc: Dictionary = node["scale"]
		var val := float(sc.get("base", 0.0)) \
			+ float(sc.get("step", 0.0)) * maxi(ranks, 1)
		# Two decimals, then the dead ones trimmed: a whole number reads "25"
		# rather than "25.00" (every tooltip in all twelve trees said the
		# latter until Batch AP) and a genuine 2.5 still reads "2.5".
		var txt := String.num(val, 2)
		if txt.contains("."):
			txt = txt.rstrip("0").rstrip(".")
		desc = desc.replace("{v}", txt)
	return desc


# ---------- applying a tree ----------

# Applies a tree's learned talents onto a hero config. `member` is the run
# party entry the tree belongs to — it feeds payload conditions that ask
# what the hero can already cast; pass it whenever you have it.
static func apply_from_tree(cfg: Dictionary, tree_nodes: Array,
		learned: Dictionary, member: Dictionary = {}) -> void:
	var ctx := {"learned": learned, "member": member}
	for t in tree_nodes:
		var ranks := int(learned.get(t["id"], 0))
		if ranks < 1:
			continue
		apply_payload(cfg, t["payload"], ranks, ctx)


# Shared payload applicator (talents and shop runes). Stats missing from the
# config (e.g. talent counters) default to 0. `ranks` is 1 for every talent
# node since Batch AI; the parameter stays because runes pass it too.
#
# "condition" is THE one read site for payload gating (Batch AI §5): a
# payload that names a condition does nothing at all unless it holds.
#
# Batch AK added two sub-payload lists, because a node can have two halves
# that answer different questions:
#   "also"    — extra payloads applied alongside this one, each carrying its
#               OWN condition. That is how a node says "and if you took X
#               as well, this widens" without a second node id.
#   "upgrade" — extra payloads applied INSTEAD of granting, when the hero
#               already owns the new_ability from an earned pick. It cannot
#               be written as an `also` + owns_ability condition, because a
#               learned node's own grant is itself in ability_names() — the
#               only honest question is "was it already in the kit when the
#               tree ran", and the abilities list is what knows that. Both
#               call sites apply earned picks BEFORE the tree, deliberately.
#
# BATCH AU §1 — AN EARNED ABILITY NO LONGER KILLS ITS OWN TREE NODE. The rule
# ran ONE DIRECTION ONLY: a talent that had already granted an ability stopped
# the boss offering it, but taking Magi's Wrath from a zone boss left its
# capstone node granting something the hero already owned, and that row
# silently dropped to two live options. Filtering the boss pool is NOT the fix
# — SPEC_POOLS entries ARE tree nodes across the roster, so filtering would
# empty pools. THE NODE UPGRADES THE ABILITY INSTEAD OF GRANTING IT:
#   * an authored `upgrade` list wins where a class batch has written one;
#   * otherwise the node owes its GENERIC fallback — the highest-priority
#     eligible ABILITY_UPGRADES entry the ability does not already carry.
# The generic is RESOLVED IN `Run.apply_upgrades`, not here, for two reasons.
# The table and its eligibility rules live on Run (an autoload identifier does
# not resolve inside a class_name script), and more importantly AP's ordering
# rule is load-bearing: several talents and runes SET an ability field, so an
# upgrade applied mid-tree would be silently overwritten. Upgrades go LAST.
# This records WHICH abilities owe one; apply_upgrades decides WHAT they get.
#
# `no_fallback: true` opts a node out — the authored answer is "nothing extra
# is needed". Magi's Wrath is the only one today: its capstone carries the
# step-doubling as a passive since Batch AU §4, so owning the ability already
# does not make the node dead.
const FALLBACK_KEY := "talent_upgrade_fallbacks"


static func apply_payload(cfg: Dictionary, payload: Dictionary, ranks: int,
		ctx: Dictionary = {}) -> void:
	if not condition_met(payload.get("condition", {}), ctx):
		return
	if payload.has("stat"):
		for field in payload["stat"]:
			var v = payload["stat"][field]
			var base = 0.0 if v is float else 0
			cfg[field] = cfg.get(field, base) + v * ranks
	elif payload.has("new_ability"):
		var nab: Ability = Ability.make(payload["new_ability"])
		# Never double-grant (the Batch 31 testing aid pre-grants these).
		if not cfg["abilities"].any(func(a): return a.display_name == nab.display_name):
			cfg["abilities"] = cfg["abilities"] + [nab]
		else:
			_collided(cfg, payload, nab.display_name, ranks, ctx)
	elif payload.has("grant_ability"):
		# The ability def lives in Classes (single source shared with the
		# DOD_SIM_ABILITIES hook), not inline in the node.
		var granted := Classes.pending_talent_ability(payload["grant_ability"])
		if granted != null:
			if not cfg["abilities"].any(func(a): return a.display_name == granted.display_name):
				cfg["abilities"] = cfg["abilities"] + [granted]
			else:
				_collided(cfg, payload, granted.display_name, ranks, ctx)
	elif payload.has("ability"):
		for ab in cfg["abilities"]:
			if ab.display_name == payload["ability"]:
				for field in payload.get("add", {}):
					ab.set(field, ab.get(field) + payload["add"][field] * ranks)
				for field in payload.get("set", {}):
					ab.set(field, payload["set"][field])
				if payload.has("status_turns") and not ab.applies_status.is_empty():
					ab.applies_status["turns"] = payload["status_turns"]
	# The node's second half, if it has one. Each entry is a full payload
	# and re-enters at the top, so its own `condition` is read at the same
	# single site — no second gate anywhere.
	for extra in payload.get("also", []):
		apply_payload(cfg, extra, ranks, ctx)


# THE COLLISION SITE (Batch AU §1) — reached when an ability-granting node
# finds the hero already holding what it grants. Exactly one rule, so no
# ability-granting node in the game can be silently dead:
#   1. an AUTHORED fallback (`upgrade`) wins where a class batch wrote one;
#   2. `no_fallback: true` means the authored answer is deliberately nothing;
#   3. otherwise the node OWES ITS GENERIC — recorded on the cfg by ability
#      name and resolved by `Run.apply_upgrades`, which runs last.
static func _collided(cfg: Dictionary, payload: Dictionary, display_name: String,
		ranks: int, ctx: Dictionary) -> void:
	var authored: Array = payload.get("upgrade", [])
	if not authored.is_empty():
		for up in authored:
			apply_payload(cfg, up, ranks, ctx)
		return
	if bool(payload.get("no_fallback", false)):
		return
	cfg[FALLBACK_KEY] = cfg.get(FALLBACK_KEY, []) + [display_name]


# Does this node's payload grant an ability, and if so which? "" when it does
# not. The hero screen asks it to decide whether a node's tooltip needs the
# collision line at all — one answer, so the tooltip cannot claim a fallback
# for a node that has nothing to fall back from.
static func granted_name(payload: Dictionary) -> String:
	if payload.has("new_ability"):
		return String(payload["new_ability"].get("display_name", ""))
	if payload.has("grant_ability"):
		return String(payload["grant_ability"])
	return ""


# What a node does when its grant collides, for the tooltip: "authored" (a
# class batch wrote one), "none" (deliberately nothing) or "generic".
static func collision_kind(payload: Dictionary) -> String:
	if not (payload.get("upgrade", []) as Array).is_empty():
		return "authored"
	if bool(payload.get("no_fallback", false)):
		return "none"
	return "generic"
