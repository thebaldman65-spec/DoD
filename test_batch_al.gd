# test_batch_al.gd — the re-authored Warden tree. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_al.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. TREE SHAPE — 24 nodes, one per lane per row, every id surviving the
#      re-author. Two nodes changed what they DO in place; if either lost
#      its id, saved trees would silently refund.
#   2. ALL 24 MAGNITUDES, in the payload AND in the tooltip that renders
#      it. Most of this tree's numbers live in a battle.gd read site, so
#      the tooltip is the only place the design number appears in the data
#      — two hand-written places, checked separately.
#   3. THE THREE CONDITIONAL HALVES — Bruising Guard's cross-row Spite
#      rider (has_node), and the War Stomp / Interpose ability riders
#      (owns_ability). Each proven to fire when its condition holds, to
#      stay dark when it does not, and to stay dark on an empty ctx (the
#      Batch AI §5 safe direction).
#   4. THE UPGRADE PATH — Hold the Line sits in the spec pool AND the
#      tree. Granted when unowned, upgraded when already earned, never
#      double-granted, in BOTH acquisition orders.
#   5. THE TWO RUNES THIS BATCH HAD TO REPAIR — the Rune of Grudges and
#      the Rune of the Standard used to add a RANK to a talent counter
#      whose per-rank value this batch multiplies by four. Left alone they
#      would have quadrupled without anyone touching them, which is
#      exactly the magnitude pass the designer closed in Batch AF. They
#      carry their own terms now, and both must pay ALONE as well as
#      stacked (a rune that is only live beside its node is a dead rune).
#   6. LIVE — a spawned battle, because the ally cover, the refuel, the
#      Break rider and the upgraded capstone only exist at cast time.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
#
# BATCH FX DELETED THE TREE THOSE TABLES RECORDED, AND RE-POINTED WHAT IT PAID.
# The twelve per-spec trees are gone (324 nodes): a Warden wears the Warrior's
# cells of the ONE tree, `Talents.TREE` — 27 nodes in three tiers of nine, no
# lanes, no rows, no capstone shelf. EVERY FIELD this file drives kept its read
# site in battle.gd / unit.gd, so every MECHANIC question still has a true
# answer, and each is now driven off the EXACT payload the retired node carried
# (`RETIRED`, below — copied out of the deleted table, never re-typed), or off
# the one tree's own node where it took the field at the same magnitude
# (`PRECEDENT`). The questions about the deleted tree ITSELF — a node's row,
# lane, name, capstone flag, tooltip prose, and its id surviving a re-author —
# have no subject left anywhere, so they are deleted AT THEIR SITES (DG §2),
# each with its exact count. Where the one tree asks the same question, it is
# asked of the one tree instead: its size and tiers, a cell's single rank and
# its tier, its tooltips naming no ability, and — DO's charter, which FX's line
# keeps — that nothing a hero wears grants.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")


var checks := 0
var fails: Array = []

# id -> [stat field, value]. BATCH FX: this was `NODES`, id -> [row, lane,
# name, stat field, value] — the layout table and the magnitudes of the batch
# doc, "transcribed once so a re-tune has to come here and say so". The ROW,
# LANE and NAME columns are DELETED WITH THEIR SUBJECT (§1 records the checks
# that read them). The ability-editing capstone, wd_hold_line, carried no stat
# field and is asked in the live half. What is left is the MAGNITUDE column,
# and each row is asked of the payload the RETIRED node carried (below) — or,
# where a node of the one tree took the field at the same magnitude, of that
# live node (`PRECEDENT`).
const PAYLOADS := {
	"wd_unkillable": ["unkillable_ranks", 1],  # Unkillable
	"wd_ricochet": ["ricochet_ranks", 1],  # Ricochet
	"wd_tank_spank": ["tank_spank_ranks", 1],  # Tank and Spank
	"wd_toughness": ["toughness_ranks", 1],  # Toughness
	"wd_taunt_master": ["provoke_ranks", 1],  # Provoke
	"wd_rally": ["rally", 1],  # Rally
	"wd_endurance": ["endurance_ranks", 1],  # Endurance
	"wd_iron_will": ["iron_will_ranks", 1],  # Iron Will
	"wd_stomp_drill": ["rallying_cry", 4],  # Rallying Cry
	"wd_tenacity": ["tenacity", 1],  # Tenacity
	"wd_sundering": ["sundering_ranks", 1],  # Sundering
	"wd_elem_weak": ["elem_weak_ranks", 1],  # Elemental Weakness
	"wd_shieldwall": ["shield_mastery_ranks", 1],  # Shield Mastery
	"wd_spiked": ["spite_ranks", 1],  # Spite
	"wd_bannerman": ["bulwark_ally_block", 10],  # Bulwark Line
	"wd_plating": ["plate_discipline_ranks", 1],  # Plate Discipline
	"wd_shatter_guard": ["bruising_ranks", 1],  # Bruising Guard
	"wd_fortress": ["shared_vigil_ranks", 1],  # Shared Vigil
	"wd_immovable": ["battered_ranks", 1],  # Battered Not Broken
	"wd_grudge": ["grudge_ranks", 1],  # Grudge
	"wd_veteran": ["steadfast_ranks", 1],  # Steadfast
	"wd_mountain": ["immovable", 1],  # Immovable
	"wd_avenger": ["vengeful_guardian", 1],  # Vengeful Guardian
}

# BATCH FX — the retired node whose field AND magnitude a node of the one tree
# took (talents.gd names each precedent above its node). Its rows are asked of
# the live node, because there the question is still asked of a node a player
# can buy: the node paying Iron Will's 12% a debuff.
const PRECEDENT := {"wd_iron_will": "tn_iron_will"}

# BATCH FX — THE PAYLOADS THE RETIRED WARDEN NODES CARRIED, copied verbatim out
# of the deleted `Talents.LANE_TREES["warden"]` (ints stay ints, floats stay
# floats, `also` halves and their `has_node` conditions included). The nodes
# are deleted; every field they wrote and every read site those fields pay
# through still stands, so what this file asked of the nodes it asks of these.
# The ids are the retired ids because the conditions name them. Only the
# seventeen DESC_NUMBERS nodes without a precedent carry their desc and scale,
# for `desc_for`'s machinery in §3.
const RETIRED := {
	"wd_unkillable": {"payload": {"stat": {"unkillable_ranks": 1}},
		"desc": "Every time you Block an attack, heal for {v}% of the health you brought into the battle.",
		"scale": {"step": 8}},  # Unkillable
	"wd_ricochet": {"payload": {"stat": {"ricochet_ranks": 1}},
		"desc": "Blocking an attack has a {v}% chance to Stun the attacker.",
		"scale": {"step": 35}},  # Ricochet
	"wd_tank_spank": {"payload": {"stat": {"tank_spank_ranks": 1}}},  # Tank and Spank
	"wd_toughness": {"payload": {"stat": {"toughness_ranks": 1}},
		"desc": "Constitution is increased by {v}% of maximum HP.",
		"scale": {"step": 25}},  # Toughness
	"wd_taunt_master": {"payload": {"stat": {"provoke_ranks": 1}},
		"desc": "Mocking Blow taunts {v} additional foes.",
		"scale": {"step": 2}},  # Provoke
	"wd_rally": {"payload": {"stat": {"rally": 1}}},  # Rally
	"wd_endurance": {"payload": {"stat": {"endurance_ranks": 1}},
		"desc": "+{v}% armor for every turn the Warden is not healed by an external source (resets when healed, capped at +75%).",
		"scale": {"step": 3}},  # Endurance
	"wd_stomp_drill": {"payload": {"stat": {"rallying_cry": 4}},
		"desc": "At the start of each of the Warden's turns, every hero regains {v}% of their maximum resource.",
		"scale": {"step": 4}},  # Rallying Cry
	"wd_tenacity": {"payload": {"stat": {"tenacity": 1}}},  # Tenacity
	"wd_sundering": {"payload": {"stat": {"sundering_ranks": 1}},
		"desc": "Crushing Blow deals {v}% of its Break damage to enemies Adjacent to the target (dead neighbors block the splash on their side).",
		"scale": {"step": 100}},  # Sundering
	"wd_elem_weak": {"payload": {"stat": {"elem_weak_ranks": 1}},
		"desc": "Crushing Blow also reduces all elemental resistances of the target by {v}% (3 turns).",
		"scale": {"step": 20}},  # Elemental Weakness
	"wd_shieldwall": {"payload": {"stat": {"shield_mastery_ranks": 1}},
		"desc": "Shieldwall's stance holds {v} turns longer — 5 turns.",
		"scale": {"step": 2}},  # Shield Mastery
	"wd_spiked": {"payload": {"stat": {"spite_ranks": 1}},
		"desc": "Attackers that damage the Warden take {v}% of that damage back.",
		"scale": {"step": 30}},  # Spite
	"wd_bannerman": {"payload": {"stat": {"bulwark_ally_block": 10}},
		"desc": "Shieldwall also grants every other hero +{v}% Block chance for its duration.",
		"scale": {"step": 10}},  # Bulwark Line
	"wd_plating": {"payload": {"stat": {"plate_discipline_ranks": 1}},
		"desc": "Heavy Plating's climbing Block bonus grows +{v}% faster per unblocked hit (8% becomes 20%, so it caps in two hits rather than five).",
		"scale": {"step": 12}},  # Plate Discipline
	"wd_shatter_guard": {"payload": {"stat": {"bruising_ranks": 1}, "also": [{"condition": {"has_node": "wd_spiked"}, "stat": {"spite_break": 1}}]},
		"desc": "Blocking an attack deals {v} Break damage to the attacker. If Spite was taken, its reflected damage builds Break equal to 50% of its value as well.",
		"scale": {"step": 30}},  # Bruising Guard
	"wd_fortress": {"payload": {"stat": {"shared_vigil_ranks": 1}},
		"desc": "Heroes take {v}% less damage while the Warden is above 50% health.",
		"scale": {"step": 12}},  # Shared Vigil
	"wd_immovable": {"payload": {"stat": {"battered_ranks": 1}},
		"desc": "Blocking an attack removes {v} Break from the Warden's own meter.",
		"scale": {"step": 30}},  # Battered Not Broken
	"wd_grudge": {"payload": {"stat": {"grudge_ranks": 1}},
		"desc": "+{v}% damage against enemies currently taunted by the Warden.",
		"scale": {"step": 25}},  # Grudge
	"wd_veteran": {"payload": {"stat": {"steadfast_ranks": 1}},
		"desc": "When damage would drop a hero below 20% health, the Warden absorbs {v}% of it instead.",
		"scale": {"step": 60}},  # Steadfast
	"wd_mountain": {"payload": {"stat": {"immovable": 1, "block_chance": 0.2}}},  # Immovable
	"wd_avenger": {"payload": {"stat": {"vengeful_guardian": 1}}},  # Vengeful Guardian
	"wd_hold_line": {"payload": {"ability": "Shieldwall", "set": {"cost": 0, "cooldown": 1}}},  # Braced
}

# The number the tooltip must render for every node whose content is a
# magnitude. desc_for() renders at rank 1, the only rank a node ever has.
const DESC_NUMBERS := {
	"wd_unkillable": "8", "wd_ricochet": "35", "wd_toughness": "25",
	"wd_taunt_master": "2", "wd_endurance": "3", "wd_iron_will": "12",
	"wd_stomp_drill": "4", "wd_sundering": "100", "wd_elem_weak": "20",
	"wd_shieldwall": "2", "wd_spiked": "30", "wd_bannerman": "10",
	"wd_plating": "12", "wd_shatter_guard": "30", "wd_fortress": "12",
	"wd_immovable": "30", "wd_grudge": "25", "wd_veteran": "60",
}

# BATCH FX — `PROSE_NUMBERS` IS DELETED WITH ITS SUBJECT. It held the numbers
# six Warden tooltips stated in PROSE because the magnitude lived only in a
# battle.gd read site — Tenacity's 15, Rally's 30% for 3 turns, Tank and
# Spank's ALWAYS, Plate Discipline's 20%, Shield Mastery's 5 turns and
# Endurance's 75 cap — so the prose "had to agree" with the read site. The
# tooltips went with their nodes; the read sites did not, and the live half
# still measures all of those but Endurance's cap off the exact retired
# payloads. §3 records the 7 checks.


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) —
	# park on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	Profile.save_path = "user://profile_batch_al_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_values()
	_tooltips()
	_conditional_halves()
	_upgrade_path()
	_rune_repair()
	_kit_unchanged()
	await _live_fields()
	await _live_bulwark_line()
	await _live_rallying_cry()
	await _live_spite_break()
	await _live_block_payoffs()
	await _live_taunt()
	await _live_hold_the_line()

	if FileAccess.file_exists("user://profile_batch_al_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_al_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	print("BATCH AL: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


func _ability_names(list: Array) -> Array:
	var out: Array = []
	for a in list:
		out.append(a.display_name)
	return out


# ---------- BATCH FX: the retired nodes inline, and the one tree worn whole ----------

# The tree a Warden buys into: `generate_tree` answers the tree the spec's CLASS
# buys into, and for every class that is the ONE tree.
func _tree() -> Array:
	return Talents.generate_tree("warden", "warrior")


# A retired node rebuilt inline from RETIRED: its id, its exact payload and, for
# the seventeen DESC_NUMBERS nodes without a precedent, its desc and scale. `{}`
# for an id RETIRED does not carry, which every caller reads as "not there".
func _retired_node(id: String) -> Dictionary:
	if not RETIRED.has(id):
		return {}
	var n: Dictionary = (RETIRED[id] as Dictionary).duplicate(true)
	n["id"] = id
	return n


# The retired nodes as a tree `apply_from_tree` can walk. `_member` hands it to
# the payload machinery, and `_spawn` hands it to the Warden as his member
# `tree`: the battle spawn applies `Run.party[i]["tree"]` against his learned
# dict, so a retired id he learns pays exactly what its node paid.
func _retired_tree() -> Array:
	var out: Array = []
	for id in RETIRED:
		out.append(_retired_node(String(id)))
	return out


# The node a PAYLOADS or DESC_NUMBERS row is asked of: the live node where the
# one tree took the field at the same magnitude (PRECEDENT), else the retired one.
func _row_node(id: String) -> Dictionary:
	if PRECEDENT.has(id):
		return Talents.node_in_tree(Talents.tree(), String(PRECEDENT[id]))
	return _retired_node(id)


func _label(id: String) -> String:
	if PRECEDENT.has(id):
		return "%s (%s's precedent)" % [PRECEDENT[id], id]
	return id


# Every cell of the one tree, WORN: what a Warden walks in wearing once the
# Warrior's purse has bought the whole tree. It comes out of
# `Talents.worn_learned`, the door `Profile.worn_talents` reads, so this is the
# real {id: rank} set a run hands the spawn, not a hand-built one.
func _all_worn() -> Dictionary:
	var cells := {}
	for n in Talents.tree():
		cells[String(n["id"])] = true
	return Talents.worn_learned(Talents.tree(), cells)


# `_applied`'s twin for the one tree, worn whole. What §5 used to ask of a CELL
# that might grant (DO's charter) it asks of this: a hero wears the whole tree
# now, so a grant could only ever come back through it.
func _applied_live(earned: Array = [], abilities: Array = []) -> Dictionary:
	var member := {"key": "warrior", "spec": "warden", "talents": _all_worn(),
		"tree": _tree(), "bm_abilities": earned}
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], member["talents"], member)
	return cfg


# ---------- 1. the tree still fits the Batch AI mould ----------
#
# BATCH FX RE-POINTED THIS SECTION TO THE ONE TREE, AND DELETED ITS LAYOUT.
# `generate_tree("warden", ...)` answers the tree the Warden's CLASS buys into —
# `Talents.TREE`, the same 27 nodes for every class — so what this section
# asked of the Warden tree it asks of that one: its size, one entry per id, a
# single rank per cell (decided now by `Talents.worn_learned`, the door
# `Profile.worn_talents` reads, since no node carries a `ranks` key), and the
# tier each node carries. The walk used to skip row 8 and so read 24 nodes; the
# one tree has no row 8, so it reads all 27 — three more per question, which is
# new content walked rather than coverage moved.
#
# THE `tier` CHECK IS INVERTED, NOT DELETED. It asserted each node carried NO
# `tier`, because Batch AI had retired a per-node tier field. FX brought the key
# back as the one tree's structure, so every node now MUST carry one and it must
# be a tier the tree has — and that is what is asked.
#
# DELETED UNDER DG §2 — 146 CHECKS, each about the deleted Warden tree:
#   24  "'<id>' is a node the layout table names"  (NODES; no such node now)
#   24  "'<id>' sits in row R"        24  "'<id>' sits in lane L"
#   24  "'<id>' is named N"           24  "'<id>' is flagged capstone iff on the shelf"
#   24  "'<id>' kept its id through the re-author" — the migration promise,
#       which FX retired: `Run._migrate_trees` drops every id the one tree does
#       not hold, and the v2 fold drops a profile's cells.
#    2  the two in-place re-specs kept their ids under new names
#       (wd_stomp_drill -> Rallying Cry, wd_bannerman -> Bulwark Line)
# THE ROW CHECK IS RE-POINTED ONTO THE TIERS. "row R holds one node in each of
# the 3 lanes" (9 rows) asked whether every cell of the shape was filled; the one
# tree's shape is three tiers of NODES_PER_TIER, so each tier is asked to hold
# that many — 3 checks where there were 9.
func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 27, "the tree is 27 cells (has %d)" % tree.size())
	var seen := {}
	for node in tree:
		var id := String(node["id"])
		ok(not seen.has(id), "'%s' appears once" % id)
		seen[id] = true
		ok(int(Talents.worn_learned(tree, {id: true}).get(id, 0)) == 1,
			"'%s' is worn at a single rank" % id)
		ok(node.has("tier") and int(node["tier"]) == Talents.tier_of(node),
			"'%s' carries its tier, one of the tree's %d (got %s)" % [id,
				Talents.TIERS, str(node.get("tier", "none"))])
	for tier in range(1, Talents.TIERS + 1):
		ok(Talents.tier_nodes(tree, tier).size() == Talents.NODES_PER_TIER,
			"tier %d holds %d nodes (has %d)" % [tier, Talents.NODES_PER_TIER,
				Talents.tier_nodes(tree, tier).size()])


# ---------- 2. what each node is worth ----------
#
# BATCH FX. A MECHANIC question — does the payload write its field at its
# magnitude — and every field kept its read site, so each PAYLOADS row is asked
# of the exact payload the retired node carried, applied as the spawn applies
# it; Iron Will's row is asked of the one tree's node that took its field and
# magnitude (PRECEDENT).
func _node_values() -> void:
	for id in PAYLOADS:
		var field := String(PAYLOADS[id][0])
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, _row_node(String(id)).get("payload", {}), 1,
			{"learned": {id: 1}, "member": {}})
		ok(cfg.has(field), "'%s' writes %s" % [_label(String(id)), field])
		if cfg.has(field):
			var got = cfg[field]
			var want = PAYLOADS[id][1]
			var same: bool = (abs(float(got) - float(want)) < 0.0001) \
				if want is float else (got == want)
			ok(same, "'%s' writes %s = %s, want %s" % [_label(String(id)), field,
				str(got), str(want)])


# ---------- 3. the tooltip renders the number the designer chose ----------
#
# BATCH FX SPLIT THIS SECTION. `desc_for` is live machinery — the build screen
# and the hero sheet both call it — and at FX its `{v}` / scale branch lost every
# live input (no node of the one tree and no rune carries a scale). So the two
# checks per node that prove IT — the number reached the string, and no
# placeholder was left — are driven off the retired nodes' exact desc and scale,
# and off the live node's desc for Iron Will's precedent (the node paying the
# magnitude says the magnitude). What asked about a deleted NODE's text has no
# node to ask. DELETED UNDER DG §2 — 25 CHECKS:
#   17  "'<id>' is in the tree", for the seventeen with no precedent
#    7  PROSE_NUMBERS — six tooltips stating their read site's number in prose
#       (the table's deletion record, above, names what the live half still
#       measures)
#    1  Bruising Guard's tooltip names Spite — the cross-row decision it
#       advertised; §4 still proves the rider fires only with Spite, off the
#       retired payloads
# AND FOUR ARE RE-POINTED TO THE ONE TREE, because DO's rule about what a node
# may ADVERTISE is a live rule — FX's line keeps it and widens it: a talent may
# not touch an ability at all. Three asked a Warden node's text not to name an
# ability it could not pay for (War Stomp, Interpose) or an upgrade it could
# not grant; those are asked of every tooltip in the one tree. The fourth asked
# Bulwark Line's text to STILL name Shieldwall because Shieldwall is protected
# core — the carve-out DO permitted and FX's line OVERTURNED (CLAUDE.md, the DO
# block: "SUPERSEDED IN ITS PERMITTED LIST AT FX") — so it INVERTS: no tooltip
# in the one tree names Shieldwall either.
func _tooltips() -> void:
	for id in DESC_NUMBERS:
		var node := _row_node(String(id))
		if PRECEDENT.has(id):
			ok(not node.is_empty(), "'%s' is in the tree" % _label(String(id)))
		if node.is_empty():
			continue
		var text := Talents.desc_for(node, 1)
		ok(text.contains(String(DESC_NUMBERS[id])),
			"'%s' tooltip renders %s: \"%s\"" % [_label(String(id)), DESC_NUMBERS[id], text])
		ok(not text.contains("{v}"),
			"'%s' tooltip has no unrendered placeholder" % _label(String(id)))
	# BATCH DO — INVERTED, AND THE RULE IS THE SAME RULE. A node must ADVERTISE
	# what it does; two of these advertised a clause that paid only a Warden who
	# had DRAWN War Stomp or Interpose, which the charter forbids. The clauses
	# are cut, so what must be true now is that the tooltips DO NOT name them —
	# a text that kept the promise while the payload dropped it is the exact
	# defect this project has found five times.
	var tips := _live_tooltips()
	ok(not tips.is_empty() and not tips.contains("War Stomp"),
		"no tooltip in the one tree names War Stomp (DO; FX's line)")
	ok(not tips.is_empty() and not tips.contains("Interpose"),
		"no tooltip in the one tree names Interpose (DO; FX's line)")
	ok(not tips.is_empty() and not tips.contains("Shieldwall"),
		"...nor Shieldwall — the protected-core carve-out was overturned at FX")
	ok(not tips.is_empty() and not tips.contains("UPGRADES"),
		"no tooltip in the one tree states an upgrade path — the tree grants nothing")


# Every tooltip the one tree renders, joined — what a Warden's build screen shows.
func _live_tooltips() -> String:
	var out := PackedStringArray()
	for n in _tree():
		out.append(Talents.desc_for(n, 1))
	return "\n".join(out)


# ---------- 4. the conditional halves ----------
#
# BATCH FX. `_member` hands the machinery the RETIRED nodes rebuilt inline —
# their exact payloads, `also` halves and `has_node` conditions included —
# because what this section asks (and §6's stacking pair) is about those
# payloads and the machinery that applies them (`apply_from_tree`,
# `apply_payload`'s stat arm, `also`, `condition`), all of which runes still
# use. The ids are the retired ids, because the conditions name them. The one
# tree carries no condition anywhere, so there is no live node for these to be
# asked of instead; the two checks that asked about deleted nodes' PAYLOAD
# SHAPE are asked of the one tree, and say so where they stand.
func _member(learned: Dictionary, earned: Array = []) -> Dictionary:
	return {"key": "warrior", "spec": "warden", "talents": learned,
		"tree": _retired_tree(),
		"bm_abilities": earned}


func _applied(learned: Dictionary, earned: Array = [],
		abilities: Array = []) -> Dictionary:
	var member := _member(learned, earned)
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], learned, member)
	return cfg


func _conditional_halves() -> void:
	# --- Bruising Guard: the cross-row rider on has_node.
	var solo := _applied({"wd_shatter_guard": 1})
	ok(int(solo.get("bruising_ranks", 0)) == 1,
		"Bruising Guard alone still applies")
	ok(int(solo.get("spite_break", 0)) == 0,
		"...and does NOT arm the Break rider without Spite")
	var both := _applied({"wd_shatter_guard": 1, "wd_spiked": 1})
	ok(int(both.get("spite_break", 0)) == 1,
		"Spite taken as well welds the pair into one Break engine")
	ok(int(both.get("spite_ranks", 0)) == 1, "...and Spite itself is unaffected")
	# The other way round: Spite alone must NOT arm it. The rider hangs off
	# Bruising Guard, so the second node is the one that pays for it.
	var spite_only := _applied({"wd_spiked": 1})
	ok(int(spite_only.get("spite_break", 0)) == 0,
		"Spite on its own arms nothing — Bruising Guard buys the rider")

	# --- Rallying Cry and Bulwark Line: BOTH ABILITY RIDERS ARE CUT (BATCH DO).
	# War Stomp and Interpose are `SPEC_POOLS` trophies, so each rider paid
	# only a Warden who had DRAWN one. The clauses are cut from the texts and
	# `rallying_stomp_ranks` / `bulwark_line_ranks` from the payloads; these
	# lines are INVERTED rather than deleted, so what they assert now is that
	# earning the ability changes nothing.
	var cry := _applied({"wd_stomp_drill": 1})
	ok(int(cry.get("rallying_cry", 0)) == 4,
		"Rallying Cry loads its own refuel unconditionally")
	ok(int(cry.get("rallying_stomp_ranks", 0)) == 0,
		"...and writes no War Stomp rider at all")
	var cry_stomp := _applied({"wd_stomp_drill": 1}, ["War Stomp"])
	ok(int(cry_stomp.get("rallying_cry", 0)) == 4,
		"with War Stomp earned the refuel is unchanged")
	ok(int(cry_stomp.get("rallying_stomp_ranks", 0)) == 0,
		"...and earning War Stomp pays NOTHING — the clause is gone (DO)")

	var wall := _applied({"wd_bannerman": 1})
	ok(int(wall.get("bulwark_ally_block", 0)) == 10,
		"Bulwark Line loads the Shieldwall grant unconditionally")
	ok(int(wall.get("bulwark_line_ranks", 0)) == 0,
		"...and writes no Interpose rider at all")
	var wall_ip := _applied({"wd_bannerman": 1}, ["Interpose"])
	ok(int(wall_ip.get("bulwark_ally_block", 0)) == 10,
		"with Interpose earned the Shieldwall grant is unchanged")
	ok(int(wall_ip.get("bulwark_line_ranks", 0)) == 0,
		"...and earning Interpose pays NOTHING — the clause is gone (DO)")

	# The two abilities stay EARNABLE and stay out of the opening kit — that
	# is unchanged by DO, and it is what makes "the node may not read them"
	# the right ruling rather than an arbitrary one.
	ok(not Talents.owns_ability(_member({}), "War Stomp"),
		"a fresh Warden does NOT own War Stomp (Batch AH trimmed it)")
	ok(not Talents.owns_ability(_member({}), "Interpose"),
		"...nor Interpose")
	ok(Talents.owns_ability(_member({}, ["War Stomp"]), "War Stomp"),
		"...and owns War Stomp once it is earned")
	ok(Talents.owns_ability(_member({}, ["Interpose"]), "Interpose"),
		"...and Interpose once it is earned")
	ok(Classes.spec_pool("warden").has("War Stomp") \
		and Classes.spec_pool("warden").has("Interpose"),
		"both ridden abilities are actually earnable from the spec pool")

	# An empty ctx leaves a conditional half INERT — the Batch AI §5 rule:
	# an effect that fails to appear is a bug you can see.
	# BATCH DO: only `wd_shatter_guard` still HAS a second half — its partner
	# is `wd_spiked`, a node in its own tree, which the charter permits. The
	# other two lost theirs, so asserting inertness on them would pass for no
	# reason; they are asserted to carry no `also` at all instead.
	# BATCH FX: the inertness loop reads the retired Bruising Guard's exact
	# payload, which still carries the `also` half it proves dark. The two
	# "carries no conditional half" checks asked it of two retired nodes; those
	# are deleted, and the one tree carries NO conditional half anywhere — no
	# `also` and no `condition` on any node (FX's line) — so the pair is asked of
	# every node of it, one check for each shape a conditional half can take,
	# with the population printed so an empty tree cannot pass them.
	for id in ["wd_shatter_guard"]:
		var bare := {"abilities": []}
		Talents.apply_payload(bare, _retired_node(id)["payload"], 1)
		ok(int(bare.get("spite_break", 0)) == 0,
			"'%s' second half is inert on an empty ctx" % id)
		ok(bare.size() > 1, "'%s' first half still lands on an empty ctx" % id)
	var with_also := 0
	var with_condition := 0
	for n in _tree():
		var pay: Dictionary = n["payload"]
		if pay.has("also"):
			with_also += 1
		if pay.has("condition"):
			with_condition += 1
	ok(with_also == 0 and not _tree().is_empty(),
		"no node of the one tree carries an `also` half (%d of %d do)" % [
			with_also, _tree().size()])
	ok(with_condition == 0 and not _tree().is_empty(),
		"...nor a `condition` (%d of %d do)" % [with_condition, _tree().size()])


# ---------- 5. grant, or upgrade ----------

func _upgrade_path() -> void:
	# **BATCH DO INVERTED THIS SECTION.** The capstone grants nothing — a talent
	# may not — so the card moved into `SPEC_DRAFT_POOLS` and the cell became
	# `Braced`. What is asserted now is the three things that would break if a
	# grant came back, plus the card's own numbers, which were lifted VERBATIM
	# out of the payload and must not have drifted in the move.
	#
	# BATCH FX RE-POINTED THE CELL TO THE TREE. The capstone this asked about
	# went with the twelve trees, and a Warden wears the one tree WHOLE now —
	# every cell the Warrior owns — so "does what the hero wears hand out Hold
	# the Line" is asked of every cell of the one tree, worn (`_applied_live`).
	# That is DO's charter, which FX's line keeps: the tree grants no ability.
	# The card's own numbers are asked as before; they never lived in the tree.
	var fresh := _applied_live()
	ok(_ability_names(fresh["abilities"]).is_empty(),
		"the whole one tree, worn, hands out NOTHING — no Hold the Line (DO's charter)")
	ok(int(fresh.get("hold_line_upgraded", 0)) == 0,
		"...and `hold_line_upgraded` is read-only-zero — only a grant could write it")
	ok(Classes.spec_draft_pool("warden").has("Hold the Line"),
		"...while the card itself drafts from the Warden")
	var earned := Classes.spec_pool_ability("warden", "Hold the Line")
	ok(earned != null, "Hold the Line resolves out of the spec pool")
	if earned != null:
		ok(earned.cost == 30 and earned.cooldown == 6,
			"...at the ordinary 30 Rage / 6cd, unchanged by the move")
		ok(earned.description.contains("50%"),
			"...and its description states the base 50% cut")
		# CV §1 — A DURATION IS STATED AS APPLIED, and that ruling rides the
		# card, so it survived the move into `Classes.draft_ability` unedited.
		ok(earned.description.contains("die\nfor 2 turns"),
			"...and its no-death window is stated as APPLIED (CV §1)")
	# An earned copy plus the whole tree is still exactly one copy, and no upgrade.
	var up := _applied_live(["Hold the Line"], [earned])
	ok(_ability_names(up["abilities"]).count("Hold the Line") == 1,
		"an earned Hold the Line is never doubled by the tree")
	ok(int(up.get("hold_line_upgraded", 0)) == 0,
		"...and the flag STILL reads zero — no collision happened")
	for a in up["abilities"]:
		if a.display_name == "Hold the Line":
			ok(not a.description.contains("80%"),
				"...and the card promises no upgrade nothing can grant")

	# The reverse order — capstone first, pick second — cannot reach the
	# upgrade, and must not double-grant either. That is a property of the
	# ordering, not of the payload, and it is the half a future batch could
	# break by moving the earned-picks block.
	# BATCH FX: "capstone first" is the whole one tree first — a Warden wearing
	# every cell, with the card in his pool but not yet on his bar.
	var member := {"key": "warrior", "spec": "warden", "talents": _all_worn(),
		"tree": _tree(), "bm_abilities": ["Hold the Line"]}
	var late := {"abilities": []}
	Talents.apply_from_tree(late, member["tree"], member["talents"], member)
	var late_names := _ability_names(late["abilities"])
	ok(late_names.count("Hold the Line") == 0,
		"tree-first grants nothing at all now — the order has nothing to decide")
	ok(int(late.get("hold_line_upgraded", 0)) == 0,
		"...and no upgrade, because nothing was in the kit when the tree ran")


# ---------- 6. the two runes this batch had to repair ----------

func _rune_repair() -> void:
	# THE POINT: neither rune may write a talent counter whose per-rank
	# value this batch multiplied. If one does, its advertised number is a
	# lie and the designer's closed magnitude question was reopened by
	# accident.
	var grudges: Dictionary = Runes.config("grudges")
	var standard: Dictionary = Runes.config("standard")
	ok(not grudges["payload"]["stat"].has("grudge_ranks"),
		"the Rune of Grudges no longer adds a RANK to the re-priced counter")
	ok(not standard["payload"]["stat"].has("shared_vigil_ranks"),
		"the Rune of the Standard likewise")

	# Each pays its OWN advertised number, alone.
	var g_only := {"abilities": []}
	Talents.apply_payload(g_only, grudges["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(g_only.get("rune_grudge_bonus", 0.0)) - 0.06) < 0.0001,
		"the Rune of Grudges pays its advertised 6%% on its own")
	ok(int(g_only.get("grudge_ranks", 0)) == 0,
		"...without touching the node's counter")
	var s_only := {"abilities": []}
	Talents.apply_payload(s_only, standard["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(s_only.get("rune_vigil_bonus", 0.0)) - 0.03) < 0.0001,
		"the Rune of the Standard pays its advertised 3%% on its own")
	ok(int(s_only.get("shared_vigil_ranks", 0)) == 0,
		"...without touching the node's counter")

	# ...and stacks with the node, which is what both descriptions promise.
	var stacked := _applied({"wd_grudge": 1, "wd_fortress": 1})
	Talents.apply_payload(stacked, grudges["payload"], 1, {"learned": {}, "member": {}})
	Talents.apply_payload(stacked, standard["payload"], 1, {"learned": {}, "member": {}})
	ok(int(stacked["grudge_ranks"]) == 1 \
		and abs(float(stacked["rune_grudge_bonus"]) - 0.06) < 0.0001,
		"node and rune stack for Grudge (25%% + 6%% = 31%%)")
	ok(int(stacked["shared_vigil_ranks"]) == 1 \
		and abs(float(stacked["rune_vigil_bonus"]) - 0.03) < 0.0001,
		"node and rune stack for Shared Vigil (12%% + 3%% = 15%%)")
	# The descriptions still name the numbers the payloads now carry.
	ok(String(grudges["desc"]).contains("6%"),
		"the Rune of Grudges still advertises 6%%")
	ok(String(standard["desc"]).contains("3%"),
		"the Rune of the Standard still advertises 3%%")
	# Nothing else in the pool writes a Warden counter this batch re-priced.
	for rune_id in Runes.ids():
		var entry: Dictionary = Runes.config(String(rune_id))
		var stat: Dictionary = entry.get("payload", {}).get("stat", {})
		ok(not stat.has("grudge_ranks") and not stat.has("shared_vigil_ranks") \
			and not stat.has("iron_will_ranks") and not stat.has("steadfast_ranks") \
			and not stat.has("spite_ranks") and not stat.has("bruising_ranks"),
			"rune '%s' writes no re-priced Warden counter" % rune_id)


# ---------- 7. the kit and the pools are untouched ----------

func _kit_unchanged() -> void:
	# This batch is a TREE re-author. AH's kit split is what both re-specs
	# depend on, so it is asserted rather than assumed.
	var kit := _ability_names(Classes.spec_abilities("warden"))
	ok(kit.size() == 3, "the Warden still opens with exactly 3 spec abilities (has %d)" % kit.size())
	ok(kit.has("Shieldwall"),
		"Shieldwall is in the opening three — Bulwark Line keys to it")
	ok(not kit.has("War Stomp") and not kit.has("Interpose"),
		"War Stomp and Interpose are still earnable, not opening kit")
	var pool: Array = Classes.spec_pool("warden")
	ok(pool.size() == 4, "the spec pool still holds 4 (has %d)" % pool.size())
	# Every pool entry of every spec still resolves: an upgrade path is a
	# new reason for a pool copy to drift from the kit's.
	for spec in Classes.SPEC_POOLS:
		for name in Classes.SPEC_POOLS[spec]:
			ok(Classes.spec_pool_ability(spec, String(name)) != null,
				"spec pool %s: '%s' resolves" % [spec, name])


# ---------- the live half ----------

# Spawns a battle FROZEN on the first hero turn: no autoplay, so nothing
# acts on its own and every cast below is one this test drove.
#
# BATCH FX: the Warden in slot 0 carries the RETIRED nodes as his member `tree`
# (the fixture's `patch`), so a retired id in `learned` has him wear exactly the
# payload that node carried — the battle spawn applies `Run.party[i]["tree"]`
# against his learned dict, and every field the live half reads kept its read
# site. FX: the payloads the retired wd_unkillable (Unkillable), wd_toughness
# (Toughness), wd_stomp_drill (Rallying Cry), wd_tenacity (Tenacity),
# wd_bannerman (Bulwark Line), wd_shatter_guard (Bruising Guard), wd_grudge
# (Grudge), wd_hold_line (Braced), wd_shieldwall (Shield Mastery), wd_spiked
# (Spite), wd_plating (Plate Discipline), wd_rally (Rally), wd_taunt_master
# (Provoke) and wd_tank_spank (Tank and Spank) carried — each node is deleted,
# each field and its read site stand. With nothing learned the inline tree pays
# nothing, which is what the live tree pays a Warden with nothing learned.
func _spawn(learned: Dictionary, lineup: Array, earned: Array = [],
		runes: Array = []) -> Node:
	return await Fixture.spawn(self, ["warden", "cryomancer", "holy", "mystic"],
		{"enemies": lineup, "talents": {0: learned}, "bm": {0: earned}, "runes": {0: runes},
			"patch": {0: {"tree": _retired_tree()}}})


func _wd(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "heavy_plating":
			return h
	return null


func _allies(scene: Node, wd: BattleUnit) -> Array:
	var out: Array = []
	for h in scene.get("heroes"):
		if h != wd and not h.is_companion and not h.dead:
			out.append(h)
	return out


func _find(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


# ---------- 8. every field reaches the live unit ----------

func _live_fields() -> void:
	# A full 8-node build, one per row, spanning all three lanes — the
	# shape a real run actually produces. `set()` DROPS an unknown name
	# silently (Batch AA), so a typo'd field is a dud rather than a crash:
	# this is the check that catches it.
	var build := {"wd_unkillable": 1, "wd_toughness": 1, "wd_stomp_drill": 1,
		"wd_tenacity": 1, "wd_bannerman": 1, "wd_shatter_guard": 1,
		"wd_grudge": 1, "wd_hold_line": 1}
	var scene := await _spawn(build, ["raider", "archer", "archer"],
		["Hold the Line"])
	var wd := _wd(scene)
	ok(wd != null, "the Warden spawned")
	if wd != null:
		ok(wd.unkillable_ranks == 1, "LIVE: Unkillable reached the unit")
		ok(wd.rallying_cry == 4, "LIVE: Rallying Cry reached the unit (4)")
		ok(wd.tenacity == 1, "LIVE: Tenacity reached the unit")
		ok(wd.bulwark_ally_block == 10,
			"LIVE: Bulwark Line reached the unit (10)")
		ok(wd.bruising_ranks == 1, "LIVE: Bruising Guard reached the unit")
		ok(wd.spite_break == 0,
			"LIVE: ...with the Spite rider dark, because Spite was not taken")
		ok(wd.grudge_ranks == 1, "LIVE: Grudge reached the unit")
		# BATCH DO: the capstone grants nothing, so the card is EARNED above.
		# What this proves is unchanged — the bar carries it — and it now also
		# proves the cell did not quietly hand out a second copy.
		# FX: the "cell" is the payload the retired wd_hold_line (Braced) carried
		# — a Shieldwall edit, no grant — worn off the inline tree; §5 asks the
		# same question of the whole one tree.
		ok(_find(wd, "Hold the Line") != null,
			"LIVE: the DRAFTED Hold the Line is on his bar")
		ok(_ability_names(wd.abilities).count("Hold the Line") == 1,
			"LIVE: ...exactly once — the retired Braced payload, worn, grants nothing (DO)")
		# Toughness reads the UNSCALED pool at spawn — 25% of max HP on top
		# of the spec's own Constitution.
		ok(wd.constitution > 100,
			"LIVE: Toughness raised Constitution (got %d)" % wd.constitution)
	scene.free()
	await process_frame


# ---------- 9. Bulwark Line covers the line ----------

func _live_bulwark_line() -> void:
	var scene := await _spawn({"wd_bannerman": 1, "wd_shieldwall": 1},
		["raider", "archer"])
	var wd := _wd(scene)
	ok(wd != null, "the Bulwark Line Warden spawned")
	if wd != null:
		ok(wd.shield_mastery_ranks == 1, "Shield Mastery reached the unit")
		await scene._resolve_special(wd, _find(wd, "Shieldwall"), wd, "good", 1.0)
		# BATCH CQ §3 — BASE **3** SINCE CN §3'S FOLD, + Shield Mastery's 2 = 5.
		# Shieldwall banked 2 turns and a Perfect banked a third; CN took the
		# card's timing bar off and folded the third turn into the base, so the
		# node's +2 now rides a 3 rather than a 2. Shieldwall's cooldown is 2,
		# so the stance already outlasted its own cooldown before the fold —
		# this widened an existing gap rather than opening one.
		ok(wd.has_status("shieldwall"), "the stance went up")
		var wall := wd.get_status("shieldwall")
		ok(int(wall.get("turns", 0)) == 5,
			"Shield Mastery holds the stance 5 turns (got %d)" % int(wall.get("turns", 0)))
		var allies := _allies(scene, wd)
		ok(allies.size() == 3, "there are three allies to cover (%d)" % allies.size())
		var covered := 0
		for a in allies:
			if a.has_status("bulwark_line"):
				covered += 1
				ok(a.status_power("bulwark_line") == 10,
					"%s is covered at +10%% Block (got %d)" % [
						a.unit_name, a.status_power("bulwark_line")])
				ok(int(a.get_status("bulwark_line").get("turns", 0)) == 5,
					"...for exactly as long as the stance holds")
		ok(covered == allies.size(),
			"EVERY ally is covered (%d of %d)" % [covered, allies.size()])
		ok(not wd.has_status("bulwark_line"),
			"the Warden is not double-covered — his own +25%% stance is up")

		# The cover is real BLOCK: it rides the Heavy Plating slice, so an
		# ally's roll can land in it. Pinned by forcing the slice to 100%.
		var ally: BattleUnit = allies[0]
		ally.update_status("bulwark_line", "+100% Block", "forced", 100)
		ally.parry_chance = 0.0
		var foe: BattleUnit = scene.get("enemies")[0]
		foe.no_cover = 1
		var hp_before: int = ally.hp
		await scene._resolve(foe, _find(foe, foe.abilities[0].display_name),
			ally, "good")
		ok(ally.hp == hp_before,
			"LIVE: a Bulwark Line block negates the hit entirely (%d -> %d)" % [
				hp_before, ally.hp])
		# ...and it must NOT feed the Warden's own Tenacity/Rally, which
		# key on "Heavy Plating" blocks specifically.
		ok(wd.tenacity_hp_gained == 0,
			"an ALLY's covered block does not feed the Warden's Tenacity")
	scene.free()
	await process_frame

	# Control: without the node, Shieldwall covers nobody.
	var plain := await _spawn({}, ["raider", "archer"])
	var wd2 := _wd(plain)
	if wd2 != null:
		await plain._resolve_special(wd2, _find(wd2, "Shieldwall"), wd2, "good", 1.0)
		var any := false
		for a in _allies(plain, wd2):
			if a.has_status("bulwark_line"):
				any = true
		ok(not any, "without Bulwark Line the stance covers nobody")
		ok(int(wd2.get_status("shieldwall").get("turns", 0)) == 3,
			"...and holds the folded base 3 turns without Shield Mastery")
	plain.free()
	await process_frame


# ---------- 10. Rallying Cry refuels the line ----------

func _live_rallying_cry() -> void:
	# The node's body fires in the turn-start block of _run_battle, which
	# cannot be called in isolation — so this runs a real autoplay battle
	# and reads the combat log the Warden's own turn writes. His first turn
	# is the earliest event in any battle, so there is no race here (the
	# Batch AH White Flame lesson: a log check must not depend on how LONG
	# a fight lasts).
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["warden", "cryomancer", "holy", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	# FX: the payload the retired wd_stomp_drill (Rallying Cry) carried —
	# rallying_cry 4 — worn off the inline tree; the node is deleted, the field
	# and its turn-start read site stand. The Warden wears the retired nodes as
	# his member `tree`, exactly as `_spawn` hands them to him.
	run.party[0]["tree"] = _retired_tree()
	run.party[0]["talents"] = {"wd_stomp_drill": 1}
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	# Batch AC gotcha: an autoplay battle paces on REAL timers. time_scale
	# scales the SceneTreeTimers it waits on and NOTHING else.
	Engine.time_scale = 50.0
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 400:
		await process_frame
	var text: String = scene.history.get_parsed_text()
	# The line is emitted ONLY after at least one ally has actually had
	# resource added (the counter it guards is incremented inside the
	# loop), so its presence is behavioural evidence, not just a print.
	ok(text.contains("Rallying Cry — the banner refuels the line (+4%)"),
		"LIVE: the banner refuels the line at the Warden's turn")
	Engine.time_scale = 1.0
	scene.free()
	await process_frame

	# Control: without the node, that line never appears.
	run.party[0]["talents"] = {}
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	Engine.time_scale = 50.0
	var plain: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(plain)
	for _i in 400:
		await process_frame
	ok(not plain.history.get_parsed_text().contains("Rallying Cry"),
		"without the node nothing refuels the line")
	Engine.time_scale = 1.0
	plain.free()
	OS.set_environment("DOD_AUTOPLAY", "")
	await process_frame


# ---------- 11. Spite, and the Break it carries once welded ----------

func _live_spite_break() -> void:
	# Spite alone: 30% of the damage back, and NO Break.
	var solo := await _spawn({"wd_spiked": 1}, ["raider"])
	var wd := _wd(solo)
	ok(wd != null, "the Spite Warden spawned")
	if wd != null:
		var foe: BattleUnit = solo.get("enemies")[0]
		foe.pressure = 0
		# Forced to LAND and forced NOT to be blocked or parried, so the
		# reflect is certain: the attacker carries the no_cover miss bypass,
		# and the block and parry rolls are driven NEGATIVE rather than to zero.
		#
		# BATCH CQ §1 — ZERO WAS NEVER ENOUGH HERE, AND THIS SUITE ALREADY SAID
		# SO ONE SECTION ABOVE. `_live_block_chance` is
		# `clampf(block_chance + _plating_slice(u), 0, 1)` and `_plating_slice`
		# hands a HEAVY PLATING Warden a flat **0.15** before his own field is
		# read — so `block_chance = 0.0` left him blocking roughly one hit in
		# six, the blow landed for nothing, and Spite reflects only on
		# `final > 0`. That is the 1-in-6 this check had been failing at, and
		# it was invisible for five batches because the suite never reached
		# this line: it deadlocked three sections earlier. `_live_fields`
		# carries the same warning in prose; this is it applied.
		wd.block_chance = -10.0
		wd.plating_bonus = 0.0
		wd.parry_chance = -10.0
		foe.no_cover = 1
		# BATCH CQ §1 — THE MITIGATION IS FORCED OFF TOO, and this is the AL/AR
		# determinism discipline applied to a variable that only became live
		# when the suite started completing. A WARDEN ALWAYS CARRIES A
		# DEFENSIVE CHECK (`_has_defensive_check` returns true on
		# `heavy_plating` regardless of stance), so every incoming blow now
		# rolls the bot's brace — a real random draw that can cut the blow by
		# 15% AND shifts every roll after it. Between that cut and the Warden's
		# own armor, a low damage roll could floor `final` to nothing, and
		# Spite reflects only when `final > 0`: the check failed once in four
		# runs on exactly that. Armor off makes the landed damage certain, and
		# the health is raised so the Warden cannot be FELLED by the blow it is
		# supposed to reflect — a first attempt raised the ATTACKER instead and
		# reintroduced the flake from the other end, because a crit on the high
		# roll could take a 200-health Warden off the board.
		wd.armor = 0.0
		wd.max_hp = 100000
		wd.hp = 100000
		var foe_hp: int = foe.hp
		await solo._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd, "good")
		ok(foe.hp < foe_hp, "Spite reflects damage at the attacker")
		ok(foe.pressure == 0,
			"...and NO Break without Bruising Guard (got %d)" % foe.pressure)
	solo.free()
	await process_frame

	# Welded: the reflect carries Break equal to half its damage. Driven
	# through the field rather than the dice, so the check cannot flake on
	# a block roll.
	var both := await _spawn({"wd_spiked": 1, "wd_shatter_guard": 1}, ["raider"])
	var wd2 := _wd(both)
	if wd2 != null:
		ok(wd2.spite_break == 1, "LIVE: the cross-row rider reached the unit")
		ok(wd2.spite_ranks == 1 and wd2.bruising_ranks == 1,
			"...alongside both halves it welds")
	both.free()
	await process_frame


# ---------- 12. the block payoffs ----------

func _live_block_payoffs() -> void:
	# Heavy Plating's ramp: +8% base, +12% with the node = 20%, so the
	# +40% cap arrives in two unblocked hits instead of five.
	var scene := await _spawn({"wd_plating": 1}, ["raider"])
	var wd := _wd(scene)
	ok(wd != null, "the Plate Discipline Warden spawned")
	if wd != null:
		ok(wd.plate_discipline_ranks == 1, "Plate Discipline reached the unit")
		ok(abs(0.08 + 0.12 * wd.plate_discipline_ranks - 0.20) < 0.0001,
			"the climb is 20% per unblocked hit")
	scene.free()
	await process_frame

	# Tenacity is +15 max HP a block now, and Rally's status is 3 turns of
	# +30%. Both are driven straight through their own machinery.
	var ten := await _spawn({"wd_tenacity": 1}, ["raider"])
	var wd2 := _wd(ten)
	if wd2 != null:
		var was: int = wd2.max_hp
		# The block-payoff cluster fires inside _resolve; forcing the roll
		# is what makes this deterministic rather than a 15% gamble. The
		# swing also has to LAND — `no_cover` is the Sharpshooter's own miss
		# BYPASS and parry_chance 0 shuts the other door, the same way Batch
		# AK forced its parry checks instead of retrying them.
		wd2.block_chance = 0.0
		wd2.plating_bonus = 1.0
		wd2.parry_chance = 0.0
		var foe: BattleUnit = ten.get("enemies")[0]
		foe.no_cover = 1
		await ten._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd2, "good")
		ok(wd2.max_hp == was + 15,
			"LIVE: a Heavy Plating block toughens him +15 max HP (%d -> %d)" % [
				was, wd2.max_hp])
		ok(wd2.tenacity_hp_gained == 15,
			"...and the gain is booked so the save sync can exclude it")
	ten.free()
	await process_frame

	var ral := await _spawn({"wd_rally": 1}, ["raider"])
	var wd3 := _wd(ral)
	if wd3 != null:
		wd3.block_chance = 0.0
		wd3.plating_bonus = 1.0
		wd3.parry_chance = 0.0
		var foe: BattleUnit = ral.get("enemies")[0]
		foe.no_cover = 1
		await ral._resolve(foe, _find(foe, foe.abilities[0].display_name),
			wd3, "good")
		var rallied := 0
		var full := 0
		for h in ral.get("heroes"):
			if h.has_status("rally_heal"):
				rallied += 1
				var left := int(h.get_status("rally_heal").get("turns", 0))
				if left == 3:
					full += 1
				# The Hunter's class passive makes him ACT FIRST, so by the
				# time this block runs his opening turn has already ticked
				# one off. That is the timeline, not the talent — hence the
				# floor rather than an equality on every hero.
				ok(left >= 2,
					"%s is Rallied and the clock has barely started (%d)" % [
						h.unit_name, left])
		ok(rallied >= 4, "the whole party is Rallied (%d)" % rallied)
		ok(full >= 3, "...for the full 3 turns on everyone yet to act (%d)" % full)
		# The multiplier itself: 30% on top, floored at 1.
		var ally: BattleUnit = _allies(ral, wd3)[0]
		ally.hp = maxi(ally.max_hp - 100, 1)
		var healed: int = ally.heal_amount(100, true)
		ok(healed > 100,
			"LIVE: Rally deepens a 100 heal past 100 (got %d)" % healed)
	ral.free()
	await process_frame


# ---------- 13. the taunt, and what it pays ----------

func _live_taunt() -> void:
	var scene := await _spawn({"wd_taunt_master": 1, "wd_tank_spank": 1},
		["raider", "archer", "archer", "shaman"])
	var wd := _wd(scene)
	ok(wd != null, "the Provoke Warden spawned")
	if wd != null:
		var mock := _find(wd, "Mocking Blow")
		ok(mock != null, "Mocking Blow is on his bar")
		var foes: Array = scene.get("enemies")
		await scene._resolve(wd, mock, foes[0], "good", true)
		var mocked := 0
		for e in foes:
			if e.has_status("mocked"):
				mocked += 1
		# Target + the base ability's one extra + Provoke's two = 4.
		ok(mocked == 4,
			"Provoke drags in 2 more on top of the base one (%d taunted)" % mocked)
		# Tank and Spank is CERTAIN now, so one cast is the whole test.
		var empowered := 0
		for h in scene.get("heroes"):
			if h.has_status("empower"):
				empowered += 1
		ok(empowered == 1,
			"Tank and Spank ALWAYS Empowers exactly one ally (%d)" % empowered)
	scene.free()
	await process_frame

	# Control: without Provoke the taunt still drags in the base one.
	var plain := await _spawn({}, ["raider", "archer", "archer", "shaman"])
	var wd2 := _wd(plain)
	if wd2 != null:
		var foes: Array = plain.get("enemies")
		await plain._resolve(wd2, _find(wd2, "Mocking Blow"), foes[0], "good", true)
		var mocked := 0
		for e in foes:
			if e.has_status("mocked"):
				mocked += 1
		ok(mocked == 2, "the base taunt still holds 2 (got %d)" % mocked)
		var empowered := 0
		for h in plain.get("heroes"):
			if h.has_status("empower"):
				empowered += 1
		ok(empowered == 0, "...and Empowers nobody without the node")
	plain.free()
	await process_frame


# ---------- 14. the capstone, granted and upgraded ----------

func _live_hold_the_line() -> void:
	# BATCH DO: EARNED rather than granted, because a talent may not grant an
	# ability. The base 50% cut and TWO turns of Undying are unchanged — the
	# applied number, which is CV §1's convention, and the card carried that
	# wording verbatim into `Classes.draft_ability`. This comment said "one
	# turn" until DM §1.
	# FX: the payload the retired wd_hold_line (Braced) carried — Shieldwall at
	# no Rage, cooldown 1 — is what he wears in both spawns below, off the inline
	# tree; the node is deleted, the flag and its read site stand. §5 asks the
	# same "nothing grants" question of the whole one tree.
	var scene := await _spawn({"wd_hold_line": 1}, ["raider"], ["Hold the Line"])
	var wd := _wd(scene)
	ok(wd != null, "the Hold the Line Warden spawned")
	if wd != null:
		ok(wd.hold_line_upgraded == 0,
			"LIVE: `hold_line_upgraded` is read-only-zero — the retired Braced payload, worn, grants nothing (DO)")
		await scene._resolve_special(wd, _find(wd, "Hold the Line"), wd, "good", 1.0)
		ok(wd.status_power("hold_bd") == 50,
			"the granted cast cuts 50%% of Break damage (got %d)" % \
				wd.status_power("hold_bd"))
		ok(int(wd.get_status("undying").get("turns", 0)) == 2,
			"...and holds death off for 2 turns (stated as APPLIED, CV §1)")
		# The cut is real: unit.gd reads the status' power at ONE site.
		wd.pressure = 0
		wd.constitution = 100
		wd.take_hit(0, 100)
		ok(wd.pressure == 50,
			"a 100-Break blow lands as 50 under the base cast (got %d)" % wd.pressure)
	scene.free()
	await process_frame

	# THE UPGRADED ARM: 80% and THREE turns. **No collision can write
	# `hold_line_upgraded` any more**, so the branch is driven from here rather
	# than left unreachable and unproved — the handler code is still live and a
	# rune could reach it, and an unexercised branch is a branch nobody knows
	# still works. What is asserted FIRST is that nothing wrote the flag.
	var earned := Classes.spec_pool_ability("warden", "Hold the Line")
	var up := await _spawn({"wd_hold_line": 1}, ["raider"], ["Hold the Line"])
	var wd2 := _wd(up)
	if wd2 != null:
		ok(wd2.hold_line_upgraded == 0,
			"LIVE: the flag is zero on an earned copy too — no collision (DO)")
		ok(_ability_names(wd2.abilities).count("Hold the Line") == 1,
			"...and there is exactly one on his bar")
		wd2.hold_line_upgraded = 1
		await up._resolve_special(wd2, _find(wd2, "Hold the Line"), wd2, "good", 1.0)
		ok(wd2.status_power("hold_bd") == 80,
			"the upgraded cast still cuts 80%% of Break damage (got %d)" % \
				wd2.status_power("hold_bd"))
		ok(int(wd2.get_status("undying").get("turns", 0)) == 3,
			"...and holds death off for 3 turns (stated as APPLIED, CV §1)")
		wd2.pressure = 0
		wd2.constitution = 100
		wd2.take_hit(0, 100)
		ok(wd2.pressure == 20,
			"a 100-Break blow lands as 20 under the upgraded cast (got %d)" % \
				wd2.pressure)
	ok(earned != null, "the earned copy resolved out of the pool")
	up.free()
	await process_frame
