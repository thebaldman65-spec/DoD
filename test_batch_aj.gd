# test_batch_aj.gd — the re-authored Berserker tree. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_aj.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, one node
#      per lane per row, every node a single rank. Batch AI's structure is
#      what makes a magnitude mean anything, so it is asserted first.
#   2. ALL 24 NODES — id, row, lane, name. Two ids are re-specced IN PLACE
#      (bz_vitality -> First Blood, bz_warcry -> Overkill) and the whole
#      migration promise rests on those ids surviving; a rename here
#      silently voids every saved tree.
#   3. THE MAGNITUDES — both halves of each one: the payload the node
#      applies AND the number its tooltip renders. Several of this tree's
#      values live in a battle.gd read site rather than the payload (the
#      payload carries a bare 1), so the tooltip is the only place the
#      design number appears in the data — and the two can drift apart
#      without anything failing to run.
#   4. THE THREE CROSS-ROW CONDITIONS — Crushing Blows reads Savagery,
#      Scar Tissue reads Unstoppable, Measured Rage reads Reckless Fury.
#      Each proven to fire when its partner was taken, to stay dark when it
#      was not, and to stay dark on an EMPTY ctx (the Batch AI §5 safe
#      direction: a condition with nothing to read does nothing).
#   5. THE TWO UPGRADE PATHS — Battle Shout and Rampage sit in the spec
#      pool AND the tree. Granted when unowned, upgraded when already
#      earned, never double-granted, and correct in BOTH acquisition
#      orders (the AK lesson: the answer depends on the kit's state when
#      the tree runs, so the order the test builds it in is load-bearing).
#   6. LIVE — a spawned battle, because First Blood's opening Rage, the
#      Overkill reset, Second Wind's cleared cooldowns and the Measured/
#      Reckless cancellation only exist at battle time.
#
# BATCH FX DELETED THE SUBJECT OF ITEMS 1 AND 2, AND RE-POINTED THE REST. The
# twelve per-spec trees are gone (324 nodes): a Berserker wears the Warrior's
# cells of the ONE tree, `Talents.TREE` — 27 nodes in three tiers of nine, no
# lanes, no rows, no capstone shelf. EVERY FIELD this file drives kept its
# read site in battle.gd / unit.gd, so every MECHANIC question above still has
# a true answer, and each is now driven off the EXACT payload the retired node
# carried (`RETIRED`, below — copied out of the deleted table, never re-typed).
# The questions about the deleted tree ITSELF — a node's row, lane, name,
# capstone flag, scale text, and its id surviving a re-author — have no
# subject left anywhere, so they are deleted AT THEIR SITES (DG §2), each with
# its exact count. Where the one tree asks the same question, it is asked of
# the one tree instead: its size and tiers, a worn cell's single rank, and —
# DO's charter, which FX's line keeps — that nothing a hero wears grants.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")


var checks := 0
var fails: Array = []

# BATCH FX — THE LAYOUT TABLE IS DELETED WITH ITS SUBJECT. `NODES` transcribed
# BATCH_AJ.md §Layout — the row, the lane and the name of each of the 24
# Berserker nodes — "so a re-cut has to come here and say so". FX deleted the
# twelve spec trees, so no Berserker node, row or lane is left for a re-cut to
# move. §2 records the 99 checks that read the table and why each went.

# id -> [stat field, value the PAYLOAD writes]. Only the nodes whose
# payload is a stat; the ability-payload and grant nodes are checked in
# their own sections.
const PAYLOADS := {
	"bz_savagery": ["bleed_bonus", 15],
	"bz_unstoppable": ["bloodrage_step_bonus", 1.5],
	"bz_vitality": ["opening_rage", 40],
	"bz_hemorrhage": ["hemorrhage_ranks", 1],
	"bz_crushing_blows": ["crushing_blows_ranks", 1],
	"bz_thick_skin": ["bloodied_momentum_ranks", 1],
	"bz_arterial": ["arterial_ranks", 1],
	"bz_deathwish": ["deathwish_ranks", 1],
	"bz_gushing": ["scent_ranks", 1],
	"bz_frenzied_edge": ["scar_tissue_ranks", 1],
	"bz_bloodied_hide": ["second_wind", 1],
	"bz_bloodcraze": ["bloodcraze", 1],
	"bz_measured": ["dmg_taken_bonus", -0.20],
	"bz_unrelenting": ["unrelenting_ranks", 1],
	"bz_feast": ["blood_tithe_ranks", 1],
	"bz_enraged": ["enraged_ranks", 1],
	"bz_warcry": ["overkill_reset", 1],
	"bz_exsanguinate": ["exsanguination", 1],
	"bz_undying": ["undying_rage", 1],
}

# id -> the value scale.base + scale.step must render. THE DESIGN NUMBER:
# for most of this tree the payload is a bare counter and THIS is the only
# place the magnitude is written down in the data, so the read site in
# battle.gd and this number are what a re-tune has to keep in step.
const SCALE_VALUES := {
	"bz_savagery": 15.0,
	"bz_hemorrhage": 60.0,
	"bz_crushing_blows": 9.0,
	"bz_arterial": 100.0,
	"bz_gushing": 10.0,
	"bz_bloodcraze": 12.0,
	"bz_feast": 45.0,
	"bz_unstoppable": 3.5,
	"bz_deathwish": 25.0,
	"bz_enraged": 12.0,
	"bz_vitality": 40.0,
	"bz_thick_skin": 40.0,
	"bz_relentless": 15.0,
	"bz_unrelenting": 40.0,
}

# BATCH FX — WHAT THE TWO TABLES ABOVE ARE ASKED OF NOW. The nodes are deleted;
# the questions are not. A PAYLOADS row is asked of the payload the RETIRED
# node carried (below), applied the way the spawn applies it — except the one
# row whose field AND magnitude a node of the one tree took (talents.gd names
# each precedent above its node), which is asked of that live node, because
# there the question is still asked of a node a player can buy. SCALE_VALUES'
# design numbers are what `desc_for` must render off the retired nodes' exact
# desc and scale; §3 records which half of that loop went, and why.
const PRECEDENT := {"bz_undying": "tn_refuse_death"}

# BATCH FX — THE PAYLOADS THE RETIRED BERSERKER NODES CARRIED, copied verbatim
# out of the deleted `Talents.LANE_TREES["berserker"]` (ints stay ints, floats
# stay floats, `also` halves and their `has_node` conditions included). The
# nodes are deleted; every field they wrote and every read site those fields
# pay through still stands, so what this file asked of the nodes it asks of
# these. The ids are the retired ids because the conditions name them. Only
# the fourteen SCALE_VALUES nodes carry their desc and scale, for §3.
const RETIRED := {
	"bz_savagery": {"payload": {"stat": {"bleed_bonus": 15}},
		"desc": "All bleed-building Berserker abilities build +{v} more Bleed.",
		"scale": {"step": 15}},  # Savagery
	"bz_unstoppable": {"payload": {"stat": {"bloodrage_step_bonus": 1.5}},
		"desc": "Blood Frenzy grants {v}% damage for every 5% of health missing (up from the base 2%).",
		"scale": {"base": 2.0, "step": 1.5}},  # Unstoppable
	"bz_vitality": {"payload": {"stat": {"opening_rage": 40}},
		"desc": "The Berserker begins every battle with {v} Rage.",
		"scale": {"step": 40}},  # First Blood
	"bz_hemorrhage": {"payload": {"stat": {"hemorrhage_ranks": 1}},
		"desc": "Enemies at {v} or more bloodloss are Crippled.",
		"scale": {"base": 60}},  # Hemorrhage
	"bz_reckless": {"payload": {"stat": {"dmg_bonus": 0.2, "dmg_taken_bonus": 0.15}}},  # Reckless Fury
	"bz_bloodlust_node": {"payload": {"ability": "Hack and Slash", "add": {"multi_hits": 2}}},  # Flurry
	"bz_crushing_blows": {"payload": {"stat": {"crushing_blows_ranks": 1}, "also": [{"condition": {"has_node": "bz_savagery"}, "stat": {"crushing_blows_ranks": 1}}]},
		"desc": "For every 20 points of bloodloss on the enemy team, gain {v}% armor penetration. With Savagery, every 15 points instead.",
		"scale": {"step": 9}},  # Crushing Blows
	"bz_thick_skin": {"payload": {"stat": {"bloodied_momentum_ranks": 1}},
		"desc": "When an enemy is slain, the Berserker gains {v} Rage.",
		"scale": {"step": 40}},  # Bloodied Momentum
	"bz_arterial": {"payload": {"stat": {"arterial_ranks": 1}},
		"desc": "When an enemy bleeds out, {v}% of its blood buildup transfers to another living enemy.",
		"scale": {"step": 100}},  # Arterial Spray
	"bz_deathwish": {"payload": {"stat": {"deathwish_ranks": 1}},
		"desc": "+{v}% damage dealt while below 35% health.",
		"scale": {"step": 25}},  # Deathwish
	"bz_relentless": {"payload": {"ability": "Hack and Slash", "add": {"cost": -15}, "set": {"bleed_chance": 1.0}},
		"desc": "Hack and Slash costs {v} less Rage, and its bleed rolls ALWAYS land.",
		"scale": {"step": 15}},  # Relentless
	"bz_gushing": {"payload": {"stat": {"scent_ranks": 1}},
		"desc": "+{v}% damage for each enemy that has bled out this battle.",
		"scale": {"step": 10}},  # Scent of Blood
	"bz_frenzied_edge": {"payload": {"stat": {"scar_tissue_ranks": 1}, "also": [{"condition": {"has_node": "bz_unstoppable"}, "stat": {"scar_tissue_ranks": 1}}]}},  # Scar Tissue
	"bz_bloodied_hide": {"payload": {"stat": {"second_wind": 1}}},  # Second Wind
	"bz_bloodcraze": {"payload": {"stat": {"bloodcraze": 1}},
		"desc": "When an enemy bleeds out, the Berserker heals {v}% of max HP.",
		"scale": {"step": 12}},  # Bloodcraze
	"bz_measured": {"payload": {"stat": {"dmg_taken_bonus": -0.2}, "also": [{"condition": {"has_node": "bz_reckless"}, "stat": {"measured_cancels_reckless": 1}}]}},  # Measured Rage
	"bz_unrelenting": {"payload": {"stat": {"unrelenting_ranks": 1}},
		"desc": "Dropping below 25% health grants +{v} Constitution for 3 turns (at most once every 5 turns).",
		"scale": {"step": 40}},  # Unrelenting Assault
	"bz_feast": {"payload": {"stat": {"blood_tithe_ranks": 1}},
		"desc": "An enemy bleeding out grants the Berserker {v} Rage.",
		"scale": {"step": 45}},  # Blood Tithe
	"bz_enraged": {"payload": {"stat": {"enraged_ranks": 1}},
		"desc": "Dropping below 50% health grants a +{v}% damage buff for 5 turns (stacks up to 3 times).",
		"scale": {"step": 12}},  # Enraged
	"bz_warcry": {"payload": {"stat": {"overkill_reset": 1}}},  # Overkill
	"bz_exsanguinate": {"payload": {"stat": {"exsanguination": 1}}},  # Exsanguination
}


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	Profile.save_path = "user://profile_batch_aj_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	_magnitudes()
	_ability_nodes()
	_conditional_halves()
	_upgrade_paths()
	await _live_first_blood()
	await _live_overkill()
	await _live_second_wind()
	await _live_measured_reckless()
	await _live_scar_tissue()

	if FileAccess.file_exists("user://profile_batch_aj_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_aj_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	print("BATCH AJ: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# The tree a Berserker buys into. BATCH FX: `generate_tree` answers the tree
# the spec's CLASS buys into, and for every class that is the ONE tree.
func _tree() -> Array:
	return Talents.generate_tree("berserker", "warrior")


# BATCH FX — a retired node rebuilt inline from RETIRED: its id, its exact
# payload, and (for §3's `desc_for` machinery) its desc and scale. `{}` for an
# id RETIRED does not carry, which every caller reads as "not in the tree".
func _node(id: String) -> Dictionary:
	if not RETIRED.has(id):
		return {}
	var n: Dictionary = (RETIRED[id] as Dictionary).duplicate(true)
	n["id"] = id
	return n


# BATCH FX — the retired nodes as a tree `apply_from_tree` can walk. `_member`
# hands it to the payload machinery, and `_spawn` hands it to the Berserker as
# his member `tree`: the battle spawn applies `Run.party[i]["tree"]` against
# his learned dict, so a retired id he learns pays exactly what its node paid.
func _retired_tree() -> Array:
	var out: Array = []
	for id in RETIRED:
		out.append(_node(String(id)))
	return out


# The payload a PAYLOADS row is asked of: the live node's where the one tree
# took the field at the same magnitude (PRECEDENT), else the retired node's.
func _payload(id: String) -> Dictionary:
	if PRECEDENT.has(id):
		return Talents.node_in_tree(Talents.tree(), String(PRECEDENT[id])).get("payload", {})
	return _node(id).get("payload", {})


func _label(id: String) -> String:
	if PRECEDENT.has(id):
		return "%s (%s's precedent)" % [PRECEDENT[id], id]
	return id


# BATCH FX — every cell of the one tree, WORN: what a Berserker walks in
# wearing once the Warrior's purse has bought the whole tree. It comes out of
# `Talents.worn_learned`, the door `Profile.worn_talents` reads, so this is the
# real {id: rank} set a run hands the spawn, not a hand-built one.
func _all_worn() -> Dictionary:
	var cells := {}
	for n in Talents.tree():
		cells[String(n["id"])] = true
	return Talents.worn_learned(Talents.tree(), cells)


# `_applied`'s twin for the one tree, worn whole. What §6 used to ask of a CELL
# that might grant (DO's charter) it asks of this: a hero wears the whole tree
# now, so a grant could only ever come back through it.
func _applied_live(earned: Array = [], abilities: Array = []) -> Dictionary:
	var member := {"key": "warrior", "spec": "berserker", "talents": _all_worn(),
		"tree": _tree(), "bm_abilities": earned}
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], member["talents"], member)
	return cfg


# ---------- 1. the shape ----------
#
# BATCH FX RE-POINTED THIS SECTION TO THE ONE TREE, AND DELETED ITS GRID.
# `generate_tree("berserker", ...)` answers the tree the Berserker's CLASS buys
# into — `Talents.TREE`, the same 27 nodes for every class — so what this
# section asked of the Berserker tree it asks of that one: its size, one entry
# per id, and a single rank per node, which the one tree decides in
# `Talents.worn_learned` (the door `Profile.worn_talents` reads), since no node
# carries a `ranks` key any more.
#
# DELETED UNDER DG §2 — 54 CHECKS, each about the deleted grid:
#   27  "row R/lane L holds one node (<id>)" — no node sits in a row or a lane
#   27  "<id> carries the capstone flag iff it is on the shelf" — no shelf
# THE FILL CHECK IS RE-POINTED ONTO THE TIERS. "row R has a <lane> node" (27,
# one per cell of the 9 x 3 grid) asked whether every cell of the shape was
# filled; the one tree's shape is three tiers of NODES_PER_TIER, so each tier
# is asked to hold that many — 3 checks where there were 27.
func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 27,
		"the tree a Berserker buys into holds 27 nodes (got %d)" % tree.size())
	var seen: Dictionary = {}
	for n in tree:
		var id := String(n["id"])
		ok(not seen.has(id), "node id %s appears exactly once" % id)
		seen[id] = true
		ok(int(Talents.worn_learned(tree, {id: true}).get(id, 0)) == 1,
			"%s is worn at a single rank" % id)
	for tier in range(1, Talents.TIERS + 1):
		ok(Talents.tier_nodes(tree, tier).size() == Talents.NODES_PER_TIER,
			"tier %d holds %d nodes (got %d)" % [tier, Talents.NODES_PER_TIER,
				Talents.tier_nodes(tree, tier).size()])


# ---------- 2. every id, row, lane and name ----------
#
# BATCH FX DELETED THIS SECTION'S SUBJECT, AND ITS 99 CHECKS WENT WITH IT (DG §2):
#   24  "<id> is still in the tree" — the migration promise ("a rename here
#       silently voids every saved tree"), which FX retired with the trees:
#       `Run._migrate_trees` drops every id the one tree does not hold, and the
#       v2 fold drops a profile's cells
#   24  "<id> sits on row R"   24  "<id> is in the L lane"   24  "<id> is named N"
#    3  the two in-place re-specs — bz_vitality kept its id as First Blood,
#       bz_warcry kept its id as Overkill, and Overkill no longer edits Battle
#       Shout's cooldown — asserted as ids and names surviving a re-author
# No Berserker node exists for an id, a row, a lane or a name to be true of.
# What those two re-specced nodes PAID is still asked, off their exact retired
# payloads: First Blood's opening Rage and Overkill's reset are PAYLOADS rows in
# §3 and live battles in §7.
func _node_table() -> void:
	pass


# ---------- 3. the magnitudes, payload AND tooltip ----------
#
# BATCH FX. THE PAYLOAD HALF is a MECHANIC question — does the payload write its
# field at its magnitude — and every field kept its read site, so each PAYLOADS
# row is asked of the exact payload the retired node carried, applied through
# `Talents.apply_payload` as the spawn applies it. The ctx is empty, so an
# `also` half stays dark and only the base half is read — which is what the row
# always pinned. Undying Rage's row is asked of the one tree's node that took its
# field and magnitude (PRECEDENT).
#
# THE TOOLTIP HALF SPLITS IN TWO. `desc_for` is live machinery — the build
# screen and the hero sheet both call it — and at FX its `{v}` / scale branch
# lost every live input (no node of the one tree and no rune carries a scale).
# So the three checks per node that prove IT — the placeholder consumed, the
# design number reached the string, no dead decimal left — are driven off the
# retired nodes' exact desc and scale. What asked about the deleted NODE has no
# node to ask. DELETED UNDER DG §2 — 30 CHECKS:
#   14  "<id> carries a scale for its tooltip"
#   14  "<id> renders <n>" — the suite's own base + step sum over the node's scale
#    2  Reckless Fury's tooltip states both numbers, and it carries no scale
# Reckless Fury's two PAYLOAD numbers are still asked, off its exact payload.
func _magnitudes() -> void:
	for id in PAYLOADS:
		var want: Array = PAYLOADS[id]
		var label := _label(String(id))
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, _payload(String(id)), 1, {})
		ok(cfg.has(want[0]), "%s writes %s" % [label, want[0]])
		if cfg.has(want[0]):
			ok(is_equal_approx(float(cfg[want[0]]), float(want[1])),
				"%s writes %s = %s (got %s)" % [label, want[0], want[1],
					cfg[want[0]]])
	for id in SCALE_VALUES:
		var n := _node(String(id))
		if n.is_empty():
			continue
		# desc_for is what the party screen actually shows: prove the
		# placeholder is consumed and the number reaches the string.
		#
		# BATCH AP trimmed the dead decimals out of desc_for, so a whole 15
		# renders "15" where it used to render "15.0". The expectation below
		# is built from the DESIGN value in SCALE_VALUES rather than from
		# desc_for's own output, so this stays a test and not a mirror:
		# whole numbers print as integers, and bz_unstoppable's genuine 3.5
		# still has to survive.
		var design: float = float(SCALE_VALUES[id])
		var want_txt: String = ("%d" % int(design)) \
			if is_equal_approx(design, float(int(design))) else String.num(design, 1)
		var shown := Talents.desc_for(n, 1)
		ok(not shown.contains("{v}"), "%s's tooltip consumes its placeholder" % id)
		ok(shown.contains(want_txt), "%s's tooltip shows %s (got \"%s\")"
			% [id, want_txt, shown])
		ok(not shown.contains(want_txt + ".0"),
			"%s's tooltip carries no dead decimal: \"%s\"" % [id, shown])
	# Reckless Fury carries two DIFFERENT numbers in one payload — assert both
	# land, applied off the payload the retired node carried. (Its tooltip and
	# its lack of a scale were the two checks deleted above.)
	var rk := {"abilities": []}
	Talents.apply_payload(rk, _payload("bz_reckless"), 1, {})
	ok(is_equal_approx(float(rk.get("dmg_bonus", 0.0)), 0.20),
		"Reckless Fury deals +20%")
	ok(is_equal_approx(float(rk.get("dmg_taken_bonus", 0.0)), 0.15),
		"Reckless Fury takes +15%")


# ---------- 4. the two ability-modifying nodes ----------

func _ability_nodes() -> void:
	var kit: Array = Classes.spec_abilities("berserker")
	var base_hs := _find_in(kit, "Hack and Slash")
	ok(base_hs != null, "Hack and Slash is in the Berserker kit")
	if base_hs == null:
		return
	ok(int(base_hs.multi_hits) == 3, "Hack and Slash opens at 3 strikes")
	ok(int(base_hs.cost) == 20, "Hack and Slash opens at 20 Rage")
	ok(is_equal_approx(float(base_hs.bleed_chance), 0.5),
		"Hack and Slash opens at a 50% bleed roll")
	# Flurry: 2 additional strikes, 5 in total.
	var fl := _applied({"bz_bloodlust_node": 1}, [],
		Classes.spec_abilities("berserker"))
	var fl_hs := _find_in(fl["abilities"], "Hack and Slash")
	ok(fl_hs != null and int(fl_hs.multi_hits) == 5,
		"Flurry takes Hack and Slash to 5 strikes (got %s)" % [
			"missing" if fl_hs == null else fl_hs.multi_hits])
	# Relentless: -15 Rage AND the bleed roll always lands. The reliability
	# half is bought permanently rather than earned per cast (Batch AG).
	var rl := _applied({"bz_relentless": 1}, [],
		Classes.spec_abilities("berserker"))
	var rl_hs := _find_in(rl["abilities"], "Hack and Slash")
	ok(rl_hs != null and int(rl_hs.cost) == 5,
		"Relentless takes Hack and Slash to 5 Rage (got %s)" % [
			"missing" if rl_hs == null else rl_hs.cost])
	ok(rl_hs != null and is_equal_approx(float(rl_hs.bleed_chance), 1.0),
		"Relentless makes Hack and Slash's bleed roll always land")
	# Both together, since they sit in different rows and a real tree can
	# hold both: the two payloads must not fight over one ability.
	var both := _applied({"bz_bloodlust_node": 1, "bz_relentless": 1}, [],
		Classes.spec_abilities("berserker"))
	var both_hs := _find_in(both["abilities"], "Hack and Slash")
	ok(both_hs != null and int(both_hs.multi_hits) == 5 \
			and int(both_hs.cost) == 5 \
			and is_equal_approx(float(both_hs.bleed_chance), 1.0),
		"Flurry and Relentless stack cleanly on one ability")


func _find_in(list: Array, name: String) -> Ability:
	for a in list:
		if a.display_name == name:
			return a
	return null


# BATCH FX: the member's tree is the RETIRED nodes rebuilt inline — their exact
# payloads, `also` halves and `has_node` conditions included — because §4 and
# §5 ask about those payloads and the machinery that applies them
# (`apply_from_tree`, `apply_payload`'s ability and stat arms, `also`,
# `condition`), all of which runes still use. The ids are the retired ids,
# because the conditions name them. The one tree carries no ability edit and no
# condition anywhere, so there is no live node for these to be asked of.
func _member(learned: Dictionary, earned: Array = []) -> Dictionary:
	return {"key": "warrior", "spec": "berserker", "talents": learned,
		"tree": _retired_tree(), "bm_abilities": earned}


func _applied(learned: Dictionary, earned: Array = [],
		abilities: Array = []) -> Dictionary:
	var member := _member(learned, earned)
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], learned, member)
	return cfg


# ---------- 5. the three cross-row conditions ----------

func _conditional_halves() -> void:
	# --- Crushing Blows reads Savagery. The counter is an INDEX: 1 = the
	# node alone (a step of 20 bloodloss), 2 = Savagery too (a step of 15).
	var cb_alone := _applied({"bz_crushing_blows": 1})
	ok(int(cb_alone.get("crushing_blows_ranks", 0)) == 1,
		"Crushing Blows alone loads its counter at 1 (a 20-point step)")
	var cb_both := _applied({"bz_crushing_blows": 1, "bz_savagery": 1})
	ok(int(cb_both.get("crushing_blows_ranks", 0)) == 2,
		"Crushing Blows with Savagery loads 2 (a 15-point step)")
	var cb_savagery_only := _applied({"bz_savagery": 1})
	ok(int(cb_savagery_only.get("crushing_blows_ranks", 0)) == 0,
		"Savagery alone pays nothing toward Crushing Blows")
	# --- Scar Tissue reads Unstoppable, same shape.
	var st_alone := _applied({"bz_frenzied_edge": 1})
	ok(int(st_alone.get("scar_tissue_ranks", 0)) == 1,
		"Scar Tissue alone loads its counter at 1 (an 85% floor)")
	var st_both := _applied({"bz_frenzied_edge": 1, "bz_unstoppable": 1})
	ok(int(st_both.get("scar_tissue_ranks", 0)) == 2,
		"Scar Tissue with Unstoppable loads 2 (a 100% floor)")
	ok(is_equal_approx(float(st_both.get("bloodrage_step_bonus", 0.0)), 1.5),
		"...and Unstoppable's own payload is untouched by being read")
	# --- Measured Rage reads Reckless Fury. This one could NOT be folded
	# into a counter: both nodes write the same field, and the promise is
	# that taking both lands on exactly zero rather than on their sum.
	var mr_alone := _applied({"bz_measured": 1})
	ok(is_equal_approx(float(mr_alone.get("dmg_taken_bonus", 0.0)), -0.20),
		"Measured Rage alone takes 20% less damage")
	ok(int(mr_alone.get("measured_cancels_reckless", 0)) == 0,
		"...and raises no cancellation flag with nothing to cancel")
	var mr_both := _applied({"bz_measured": 1, "bz_reckless": 1})
	ok(int(mr_both.get("measured_cancels_reckless", 0)) == 1,
		"Measured Rage with Reckless Fury raises the cancellation flag")
	ok(is_equal_approx(float(mr_both.get("dmg_bonus", 0.0)), 0.20),
		"...leaving Reckless Fury's +20% dealt clean")
	# --- The Batch AI §5 safe direction: no ctx = INERT, never silently
	# unconditional. Applied WITHOUT a member/learned pair, every
	# conditional half must stay dark.
	var bare := {"abilities": []}
	for id in ["bz_crushing_blows", "bz_frenzied_edge", "bz_measured"]:
		Talents.apply_payload(bare, _node(id)["payload"], 1, {})
	ok(int(bare.get("crushing_blows_ranks", 0)) == 1,
		"empty ctx: Crushing Blows loads its base half only")
	ok(int(bare.get("scar_tissue_ranks", 0)) == 1,
		"empty ctx: Scar Tissue loads its base half only")
	ok(int(bare.get("measured_cancels_reckless", 0)) == 0,
		"empty ctx: Measured Rage raises no flag")


# ---------- 6. the two upgrade paths, and the charter that closed them ----------
#
# **BATCH DO INVERTED THIS SECTION RATHER THAN DELETING IT.** AJ built the two
# grant-or-upgrade paths and this is where they were proved: a hero without the
# card got a GRANT (index 1), a hero who had earned it got an UPGRADE (index 2),
# and the acquisition ORDER decided which — "was it in the kit when the tree
# ran". DO's charter ends the premise: **a talent may not grant an ability.**
# Both cards moved into `SPEC_DRAFT_POOLS` and both cells were re-authored.
#
# So there is no collision left to have a path for, and what is asserted now is
# the three things that would break if a grant came back: the node hands out
# NOTHING, the card is still reachable, and the read-site index that counted
# which path ran is READ-ONLY-ZERO. **The index is the sharp one** — a 1 or a 2
# is only writable by a grant, so it is the single value that catches a
# regression here no matter how it is reintroduced.
#
# BATCH FX RE-POINTED THE CELL TO THE TREE. The two cells this asked about
# (bz_battle_shout, bz_rampage) went with the twelve trees, and a Berserker
# wears the one tree WHOLE now — every cell the Warrior owns — so "does what
# the hero wears hand out Battle Shout or Rampage" is asked of every cell of the
# one tree, worn (`_applied_live`). That is DO's charter, which FX's line keeps:
# the tree grants no ability. The indices stay the sharp half, for the same
# reason as before: only a grant's collision could write them.

func _upgrade_paths() -> void:
	# --- Battle Shout: the tree grants nothing and the card is drafted.
	var bs_grant := _applied_live([], [])
	ok(_names(bs_grant["abilities"]).is_empty(),
		"the whole one tree, worn, hands out NOTHING — no Battle Shout (DO's charter)")
	ok(int(bs_grant.get("battle_shout_node", 0)) == 0,
		"...and `battle_shout_node` is read-only-zero — only a grant could write it")
	ok(Classes.spec_draft_pool("berserker").has("Battle Shout"),
		"...while the card itself drafts from the Berserker")
	# It stays in the BOSS pool too, untouched: DO added to the draft and took
	# nothing away, which is what "the existing pick, unchanged" means.
	var earned := [Classes.spec_pool_ability("berserker", "Battle Shout")]
	ok(earned[0] != null, "Battle Shout still resolves out of the Berserker pool")
	# A hero who has EARNED it and also wears the whole tree keeps exactly one
	# copy — the same anti-double-grant property, reached the other way.
	var bs_up := _applied_live(["Battle Shout"], earned)
	ok(_names(bs_up["abilities"]).count("Battle Shout") == 1,
		"an earned Battle Shout is never doubled by the tree")
	ok(int(bs_up.get("battle_shout_node", 0)) == 0,
		"...and the index STILL reads zero — no collision happened")
	# THE CARD CARRIES ONE MAGNITUDE NOW, AND IT IS THE ONE THE HANDLER PAYS.
	# `[8, 12, 18][battle_shout_node]` can only ever index 0, so the +12% and
	# +18% the node used to buy have no source — and the description said +12%,
	# which `docs/state.md` has carried as an open defect since DM. It says +8%.
	var bs_ab := _find_in(bs_up["abilities"], "Battle Shout")
	ok(bs_ab != null and String(bs_ab.description).contains("+8%"),
		"the drafted Battle Shout states +8%, which is what the handler pays")
	ok(bs_ab != null and String(bs_ab.description).contains("2 turns"),
		"...and 2 turns")
	ok(bs_ab != null and not String(bs_ab.description).contains("18%"),
		"...and promises no upgrade nothing can grant")
	# --- Rampage, same shape.
	var rp_grant := _applied_live([], [])
	ok(_names(rp_grant["abilities"]).is_empty(),
		"the whole one tree, worn, hands out NOTHING — no Rampage (DO's charter)")
	ok(int(rp_grant.get("rampage_upgraded", 0)) == 0,
		"...and `rampage_upgraded` is read-only-zero")
	var rp_earned := [Classes.spec_pool_ability("berserker", "Rampage")]
	ok(rp_earned[0] != null, "Rampage still resolves out of the Berserker pool")
	ok(Classes.spec_draft_pool("berserker").has("Rampage"),
		"...and drafts from the Berserker as well")
	var rp_up := _applied_live(["Rampage"], rp_earned)
	ok(_names(rp_up["abilities"]).count("Rampage") == 1,
		"an earned Rampage is never doubled by the tree")
	ok(int(rp_up.get("rampage_upgraded", 0)) == 0,
		"...and its index reads zero too")
	# --- BOTH ACQUISITION ORDERS STILL MATTER, AND THE ANSWER IS NOW THE SAME
	# EITHER WAY, which is the point: the order used to decide grant-versus-
	# upgrade, and there is nothing left for it to decide.
	var node_first := _applied_live([], [])
	ok(int(node_first.get("battle_shout_node", 0)) == 0,
		"tree first, pick later: still zero — the tree grants nothing to count")
	var pool_ab := Classes.spec_pool_ability("berserker", "Battle Shout")
	var after: Array = node_first["abilities"]
	var dupe := false
	for a in after:
		if pool_ab != null and a.display_name == pool_ab.display_name \
				and after.count(a) > 1:
			dupe = true
	ok(not dupe, "...and no duplicate survives that order either")


func _names(list: Array) -> Array:
	var out: Array = []
	for a in list:
		out.append(a.display_name)
	return out


# ---------- 7. live ----------
#
# BATCH FX: every battle below is driven off a retired node's exact payload.
# FX: the payloads the retired bz_vitality (First Blood — opening_rage 40),
# bz_warcry (Overkill — overkill_reset 1), bz_bloodied_hide (Second Wind —
# second_wind 1), bz_measured (Measured Rage) with bz_reckless (Reckless Fury),
# and bz_frenzied_edge (Scar Tissue) with bz_unstoppable (Unstoppable) carried —
# each node is deleted, each field and its read site stand, and the battle reads
# every one of those fields at the spawn or in the fight exactly as it did.

# Spawns a real battle with a Berserker in slot 0 carrying `learned`.
# Enemies are switched OFF so nothing acts on its own — every check below
# drives the state it reads.
# BATCH FX: he carries the RETIRED nodes as his member `tree` (the fixture's
# `patch`), so a retired id in `learned` has him wear exactly the payload that
# node carried — the battle spawn applies `Run.party[i]["tree"]` against his
# learned dict. With nothing learned the inline tree pays nothing, which is what
# the live tree pays a Berserker with nothing learned.
func _spawn(learned: Dictionary, lineup: Array) -> Node:
	return await Fixture.spawn(self,
		["berserker", "cryomancer", "inquisitor", "beastmaster"],
		{"enemies": lineup, "talents": {0: learned.duplicate()},
			"patch": {0: {"tree": _retired_tree()}}})


func _bz(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "bloodrage":
			return h
	return null


func _live_first_blood() -> void:
	# Control: no node, so the Rage tank opens where it always did.
	var plain := await _spawn({}, ["raider", "raider"])
	var bz0 := _bz(plain)
	ok(bz0 != null, "the Berserker spawned (control)")
	var opened_at := 0
	if bz0 != null:
		opened_at = bz0.resource
		ok(bz0.opening_rage == 0, "control carries no opening_rage")
	plain.queue_free()
	await process_frame
	# With First Blood: 40 Rage in the tank at the bell.
	var scene := await _spawn({"bz_vitality": 1}, ["raider", "raider"])
	var bz := _bz(scene)
	ok(bz != null, "the Berserker spawned (First Blood)")
	if bz != null:
		ok(bz.opening_rage == 40, "First Blood loads opening_rage = 40")
		ok(bz.resource >= 40,
			"...and the battle opens with at least 40 Rage (got %d)" % bz.resource)
		ok(bz.resource > opened_at,
			"...which is more than the control opened with (%d)" % opened_at)
		ok(bz.max_hp > 0 and not bz.dead, "...and nothing else about him moved")
	scene.queue_free()
	await process_frame


func _live_overkill() -> void:
	var scene := await _spawn({"bz_warcry": 1}, ["raider", "raider", "raider"])
	var bz := _bz(scene)
	ok(bz != null, "the Berserker spawned (Overkill)")
	if bz == null:
		scene.queue_free()
		return
	ok(bz.overkill_reset == 1, "Overkill loads its flag")
	# Put both abilities on cooldown, plus one that must NOT be cleared.
	bz.cooldowns["Hack and Slash"] = 2
	bz.cooldowns["Wildstrikes"] = 3
	bz.cooldowns["Bloodlust"] = 2
	var victim: BattleUnit = scene.get("enemies")[0]
	scene.call("_on_enemy_death", victim)
	ok(not bz.cooldowns.has("Hack and Slash"),
		"a kill clears Hack and Slash")
	ok(not bz.cooldowns.has("Wildstrikes"), "a kill clears Wildstrikes")
	ok(int(bz.cooldowns.get("Bloodlust", 0)) == 2,
		"...and leaves every other cooldown alone")
	scene.queue_free()
	await process_frame
	# Control: without the node the kill changes nothing.
	var plain := await _spawn({}, ["raider", "raider"])
	var bz2 := _bz(plain)
	if bz2 != null:
		bz2.cooldowns["Hack and Slash"] = 2
		plain.call("_on_enemy_death", plain.get("enemies")[0])
		ok(int(bz2.cooldowns.get("Hack and Slash", 0)) == 2,
			"without Overkill a kill clears nothing")
	plain.queue_free()
	await process_frame


func _live_second_wind() -> void:
	var scene := await _spawn({"bz_bloodied_hide": 1}, ["raider", "raider"])
	var bz := _bz(scene)
	ok(bz != null, "the Berserker spawned (Second Wind)")
	if bz == null:
		scene.queue_free()
		return
	ok(bz.second_wind == 1, "Second Wind loads its flag")
	bz.cooldowns["Hack and Slash"] = 2
	bz.cooldowns["Wildstrikes"] = 3
	bz.resource = 0
	# Drive him under a quarter in one blow, from above it.
	bz.hp = bz.max_hp
	bz.take_hit(int(bz.max_hp * 0.85), 0)
	ok(bz.second_wind_used, "the first dive below 25% fires Second Wind")
	ok(bz.resource >= 60, "...granting 60 Rage (got %d)" % bz.resource)
	ok(bz.cooldowns.is_empty(), "...and clearing every cooldown")
	# Once per battle: a second dive pays nothing.
	bz.cooldowns["Hack and Slash"] = 2
	var rage_after := bz.resource
	bz.hp = bz.max_hp
	bz.take_hit(int(bz.max_hp * 0.85), 0)
	ok(int(bz.cooldowns.get("Hack and Slash", 0)) == 2,
		"a second dive pays nothing — Second Wind is once per battle")
	ok(bz.resource <= rage_after + 10,
		"...and grants no second helping of Rage")
	scene.queue_free()
	await process_frame


func _live_measured_reckless() -> void:
	# Measured Rage ALONE must actually reduce damage taken. Before this
	# batch the read site was guarded `> 0.0` and ate every negative, so
	# this check is the regression alarm for a node that shipped inert.
	var solo := await _spawn({"bz_measured": 1}, ["raider", "raider"])
	var bz_solo := _bz(solo)
	ok(bz_solo != null, "the Berserker spawned (Measured Rage alone)")
	if bz_solo != null:
		ok(is_equal_approx(bz_solo.dmg_taken_bonus, -0.20),
			"Measured Rage alone carries -20% damage taken")
		ok(bz_solo.measured_cancels_reckless == 0,
			"...and no cancellation flag")
	solo.queue_free()
	await process_frame
	# Both nodes: the damage-taken term is cancelled outright, and the
	# damage DEALT bonus survives untouched.
	var scene := await _spawn({"bz_measured": 1, "bz_reckless": 1},
		["raider", "raider"])
	var bz := _bz(scene)
	ok(bz != null, "the Berserker spawned (Measured + Reckless)")
	if bz != null:
		ok(bz.measured_cancels_reckless == 1,
			"both nodes raise the cancellation flag")
		ok(is_equal_approx(bz.dmg_bonus, 0.20),
			"...the +20% damage dealt is left clean")
	scene.queue_free()
	await process_frame


func _live_scar_tissue() -> void:
	# 85% alone.
	var scene := await _spawn({"bz_frenzied_edge": 1}, ["raider", "raider"])
	var bz := _bz(scene)
	ok(bz != null, "the Berserker spawned (Scar Tissue)")
	if bz != null:
		ok(bz.scar_tissue_ranks == 1, "Scar Tissue alone loads 1")
		bz.hp = int(bz.max_hp * 0.5)
		var peak := bz.frenzy_bonus()
		ok(peak > 0.0, "half health earns a Frenzy bonus (%.3f)" % peak)
		ok(is_equal_approx(bz.frenzy_floor, peak * 0.85),
			"...and the floor scars in at 85%% of it (%.3f vs %.3f)" % [
				bz.frenzy_floor, peak * 0.85])
		bz.hp = bz.max_hp
		ok(is_equal_approx(bz.frenzy_bonus(), peak * 0.85),
			"...and a full heal cannot take the floor back")
	scene.queue_free()
	await process_frame
	# 100% with Unstoppable: the bonus never falls at all.
	var both := await _spawn({"bz_frenzied_edge": 1, "bz_unstoppable": 1},
		["raider", "raider"])
	var bz2 := _bz(both)
	ok(bz2 != null, "the Berserker spawned (Scar Tissue + Unstoppable)")
	if bz2 != null:
		ok(bz2.scar_tissue_ranks == 2, "the pair loads 2")
		ok(is_equal_approx(bz2.bloodrage_step_bonus, 1.5),
			"...Unstoppable still steps at 3.5% per 5% missing")
		bz2.hp = int(bz2.max_hp * 0.5)
		var peak2 := bz2.frenzy_bonus()
		bz2.hp = bz2.max_hp
		ok(is_equal_approx(bz2.frenzy_bonus(), peak2),
			"...and the floor holds the whole peak — it never falls")
	both.queue_free()
	await process_frame
