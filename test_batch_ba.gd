# test_batch_ba.gd — THE SURVIVALIST: ATTRITION THROUGH CRAFT. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ba.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 THE CONTAGION SPACE IS RESERVED: nothing in his tree, his abilities or
#      his read sites spreads on its own — no enemy-to-enemy transmission, no
#      transfer from a corpse, no field-wide infection.
#   §2 EACH VENOM NODE HANGS A DIFFERENT AFFLICTION off the poison: Coated
#      Blades' Cripple, Distillate's Exposed, Slow Acting's Slowed, and the
#      Trapper count rising as they land.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the node
#      that owes it, every counter ADDITIVE at its read site.
#   §3 Creeping Death REFRESHES rather than transfers; Quartermaster poisons
#      from an ALLY'S attack and credits HIM; Perfected Toxin survives a dispel
#      and its tick rises.
#   §4 BOTH NAMED PAIRS ARE GONE — and every surviving prose pair in CLAUDE.md
#      is one row exclusivity already enforces.
#   §5 THE TROPHY-POOL COLLISION CANNOT ARISE: no Survivalist node grants an
#      ability, so he owes no AU §1 fallback in either direction.
#   §6 the four spec runes re-pointed onto live counters in the new units, the
#      three Hunter class-wide runes touching none of them, and NO rune riding
#      a counter whose MEANING changed.
#   §7 HARVEST PAYS FOR WHAT IT REMOVED — sticky poison survives the purge and
#      is not billed for.
#   §8 THE BOT: breadth before depth, and Harvest reading the same yield the
#      ability is paid on.
#   NEGATIVE CONTROLS for the four that would fail silently: Creeping Death
#      still firing on death, Perfected Toxin poisoning the whole field at
#      battle start, Harvest counting sticky poison it did not remove, and
#      Quartermaster's poison being credited to the ally rather than to him.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
#
# BATCH FX REPAIRED THIS FILE IN PLACE, and every change is recorded AT ITS
# SITE (CQ §3: a stale assertion is repaired to intent, never deleted). FX
# deleted the twelve spec trees, and with them every node this file was written
# about: the Survivalist wears the ONE class tree now — twenty-seven nodes in
# three tiers of nine. What FX KEPT is every field those nodes wrote and every
# read site in `battle.gd` and `unit.gd`, and THREE of his nodes are precedents
# the one tree took whole (field AND magnitude). So:
#   * each LIVE section that learned a retired node wears that node's EXACT
#     payload (`RETIRED`, copied from the deleted tree) on his tree for that one
#     spawn — Quick Rigging's `also` arm included — and Woodcraft is learned as
#     the node that took it; every effect assertion is unchanged;
#   * §3's shape questions and §1's reservation are asked of the one tree, and
#     the 24 ids that used to "survive" are asked what their survival was for —
#     whether a SAVE holding them still loads — which FX answers by dropping them;
#   * the three precedents' magnitudes and tooltips are asked of the one-tree
#     nodes that took them;
#   * every check whose subject was the deleted tree itself — a node's
#     magnitude, row, lane, capstone flag, name or text — is DELETED under DG
#     §2's one exception, with the count at each site.
# FX DELETED 52 CHECKS HERE (690 -> 638): §3's shape 7, §3's magnitudes 41, §1's
# two untouched-lane texts 2, and §4's pairs 2.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")


var checks := 0
var fails: Array = []
var _report: Array = []


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
	Profile.save_path = "user://profile_batch_ba_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_contagion_reserved()
	_no_ability_grants()
	_rune_audit()
	_meaning_changed_audit()
	_bot_policy_source()
	_exclusive_pairs()
	_docs()
	_negative_control_source()

	await _live_carriers()
	await _live_slow_acting()
	await _live_breadth_rises()
	await _live_creeping_refresh()
	await _live_quartermaster()
	await _live_perfected_toxin()
	await _live_harvest_count()
	await _live_trap_cap()
	await _live_quick_rigging()
	await _live_snares_magnitudes()
	await _live_guerilla_magnitudes()

	if FileAccess.file_exists("user://profile_batch_ba_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ba_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_ba: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("mystic", "hunter")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _hero(scene: Node, idx: int) -> BattleUnit:
	var hs: Array = scene.get("heroes")
	return hs[idx] if idx < hs.size() else null


# The Survivalist sits in the HUNTER slot (index 3). His spec id is "mystic"
# and must never be renamed — saves and trees key on it.
#
# BATCH FX: a learned id the one tree no longer holds rides his `tree` as its
# retired payload (`_worn_tree`) — the fixture's `patch`, which is written after
# `sync_spec_hp` and before the battle reads the member.
func _spawn(learned: Dictionary, lineup := ["raider", "raider"]) -> Node:
	return await Fixture.spawn(self, ["berserker", "pyromancer", "inquisitor", "mystic"],
		{"enemies": lineup, "talents": {3: learned.duplicate()},
		"patch": {3: {"tree": _worn_tree(learned)}}, "deterministic": true})


# ── BATCH FX — THE PAYLOADS THE RETIRED NODES CARRIED ───────────────────────
# FX deleted the twelve spec trees. EVERY FIELD these nodes wrote was kept, and
# so was every read site — a field no node writes any more is DORMANT, not
# deleted — so the questions this file asks of those fields still have true
# answers. Each entry is the EXACT payload the node carried, copied from the
# tree FX removed: the node is deleted, the field and its read site stand.
# (Woodcraft is not here: the one tree's More Health took its field and its
# magnitude, and a precedent is learned as the node that took it.)
const RETIRED := {
	# Potent Toxins — +8 Poison damage a stack.
	"sv_potent": {"stat": {"potent_ranks": 8}},
	# Coated Blades — the basic attack poisons and Cripples.
	"sv_coated": {"stat": {"coated_blades": 1}},
	# Distillate — +2 extra stacks, and Exposed.
	"sv_virulence": {"stat": {"virulence_ranks": 2}},
	# Slow Acting — half damage, twice as long, uncleansable, and Slowed.
	"sv_slow_acting": {"stat": {"slow_acting": 1}},
	# Creeping Death — another status refreshes the Poison.
	"sv_creeping": {"stat": {"creeping_death": 1}},
	# Quartermaster — every other hero's basic attack applies his Poison.
	"sv_plague": {"stat": {"quartermaster": 1}},
	# Quick Rigging — its own 2, and an `also` arm: Snare Trap's cooldown -2.
	"sv_rigging": {"stat": {"quick_rigging": 2}, "also": [{"ability": "Snare Trap", "add": {"cooldown": -2}}]},
	# Caught Fast — a trapped enemy cannot be healed for 5 turns.
	"sv_caught": {"stat": {"caught_fast": 5}},
	# Bone Breaker — a sprung trap deals 90 Break damage.
	"sv_bone": {"stat": {"bone_breaker": 90}},
	# Deadfall Network — three traps at once.
	"sv_network": {"stat": {"deadfall_network": 3}},
	# Hit and Run — 2 turns of Elusive after applying a status.
	"sv_hitrun": {"stat": {"hit_and_run": 2}},
	# Scavenger — 25% of maximum Mana on an enemy death.
	"sv_scavenger": {"stat": {"scavenger_ranks": 25}},
	# Improvised — the first 2 abilities start no cooldown.
	"sv_improvised": {"stat": {"improvised": 2}},
	# Perfected Toxin — the Poison never expires and its tick rises by 2.
	"sv_epidemic": {"stat": {"perfected_toxin": 2}},
}

# The one cell the saved member in `_migrated_talents` also holds: any id the
# live tree carries would do.
const LIVE_CELL := "tn_health"


# The tree he wears for ONE spawn: the live class tree, plus the retired payload
# of every learned id the live tree no longer holds. It rides his `tree`, so the
# spawn applies it through the one door every node takes (`apply_from_tree` ->
# `apply_payload`, `also` arm and all) rather than as a field poked onto the unit
# afterwards — which would skip what the spawn does with it (Quick Rigging's
# edit to the Snare Trap card, for one).
func _worn_tree(learned: Dictionary) -> Array:
	var t := Talents.generate_tree("mystic", "hunter")
	for id in learned:
		if RETIRED.has(id) and Talents.node_in_tree(t, id).is_empty():
			t.append({"id": id, "payload": (RETIRED[id] as Dictionary).duplicate(true)})
	return t


func _ids(tree: Array) -> Array:
	return tree.map(func(t): return String(t["id"]))


# THE LOAD PATH'S OWN MIGRATION, driven on a member saved under the twelve
# trees: it holds every id in `ids` plus `LIVE_CELL`. Returns the talents the
# member comes out wearing. `Run` is an autoload, so it is fetched at RUNTIME (a
# --script harness cannot name one), and its party is put back afterwards.
func _migrated_talents(ids: Array) -> Dictionary:
	var run: Node = root.get_node("/root/Run")
	var kept: Array = run.party
	var learned := {LIVE_CELL: 1}
	for id in ids:
		learned[id] = 1
	run.party = [{"spec": "mystic", "key": "hunter", "tree": [],
		"talents": learned}]
	run.call("_migrate_trees")
	var out: Dictionary = (run.party[0]["talents"] as Dictionary).duplicate()
	run.party = kept
	return out


func _rune_pool() -> Dictionary:
	var pool := {}
	for rid in Runes.ids():
		pool[rid] = Runes.config(rid)
	return pool


func _kill(scene: Node) -> void:
	await Fixture.kill(self, scene)


# ---------- §3 the tree's shape ----------

# BATCH FX: `IDS` is still THIS BATCH'S RECORD OF ITS OWN 24 NODES — and every
# one of them is RETIRED, because FX deleted the twelve spec trees. The table
# stays: §3's save arm below asks each of these ids its question.
const IDS := ["sv_potent", "sv_coated", "sv_virulence", "sv_slow_acting",
	"sv_creeping", "sv_necrosis", "sv_plague",
	"sv_wire", "sv_rigging", "sv_cruel", "sv_snap_shut", "sv_caught",
	"sv_bone", "sv_network",
	"sv_woodcraft", "sv_hitrun", "sv_scavenger", "sv_medic", "sv_vulture",
	"sv_ghillie", "sv_improvised",
	"sv_epidemic", "sv_forest", "sv_force"]


func _tree_shape() -> void:
	var tree := _tree()
	# BATCH FX RE-POINTED THIS SECTION TO THE ONE TREE. The Survivalist wears the
	# one class tree now — twenty-seven nodes in three tiers of nine — so every
	# question below is asked of the tree he wears: its size, its ids, the rank
	# each node is worn at, where each node sits, that nothing in it is
	# exclusive, and how its levels are filled. Two questions were about a shape
	# the one tree does not have, and are deleted where they stood.
	ok(tree.size() == 27 and _ids(tree) == _ids(Talents.tree()),
		"the Survivalist wears the one class tree — 27 nodes (got %d)" % tree.size())
	var seen := {}
	for t in tree:
		var id := String(t["id"])
		ok(not seen.has(id), "id %s appears once" % id)
		seen[id] = true
		# RE-POINTED (FX): a node carries no rank of its own any more. The ledger
		# is what wears it, and it wears every node at exactly one
		# (`Talents.worn_learned`, the door `Profile.worn_talents` goes through).
		ok(not t.has("ranks")
			and int(Talents.worn_learned(tree, {id: true}).get(id, 0)) == 1,
			"%s is worn at a single rank" % id)
		# RE-POINTED (FX): rows 1-9 are gone; the level a node sits at is its TIER.
		var tier := int(t.get("tier", 0))
		ok(tier >= 1 and tier <= Talents.TIERS,
			"%s sits in a real tier 1-%d (got %d)" % [id, Talents.TIERS, tier])
		# Nothing in the one tree is exclusive, so no node may carry a stale
		# `exclusive_with` pointing anywhere.
		ok(not t.has("exclusive_with"),
			"%s carries no stale exclusive_with — nothing in the one tree is exclusive" % id)
	# DELETED AT FX — 4 CHECKS: "three capstones", and for each of the three
	# "capstone X is on the capstone shelf". The shelf was the capstone ROW of a
	# spec tree; FX deleted the spec trees, and the one tree has no rows and no
	# capstone, so neither question has anything left to read.
	# RE-POINTED (FX): "<lane> holds 8 rows" asked how the tree's levels are
	# filled. The one tree's levels are its three TIERS, nine nodes to each.
	for tier_n in range(1, Talents.TIERS + 1):
		var in_tier := Talents.tier_nodes(tree, tier_n).size()
		ok(in_tier == Talents.NODES_PER_TIER,
			"tier %d holds %d nodes (got %d)" % [tier_n, Talents.NODES_PER_TIER, in_tier])
	# RE-POINTED AND INVERTED (FX) — THE 24 IDS DID NOT SURVIVE. BA asserted that
	# every one of them survives the re-author because that is what let a SAVED
	# tree migrate with no save version moving (§10's promise). FX deleted all 24
	# and kept the promise the other way: `Run._migrate_trees` swaps a saved
	# member's tree for the live one and DROPS every id it no longer holds, so a
	# resumed run wears nothing the tree cannot price and still no save version
	# moves. So each id is asked the question its survival answered — does a
	# save holding it still load clean — and the answer is that it is dropped,
	# never carried as a dead node.
	var migrated := _migrated_talents(IDS)
	for id in IDS:
		ok(not migrated.has(id),
			"id %s is retired with its tree: a saved run holding it migrates with it DROPPED" % id)
	# RE-POINTED (FX): "the 24 survive and BM added exactly 3" was the exact-count
	# arm of the loop above, and it still is — exactly the 24 go and exactly the
	# live cell the same member held stays, so the drop is the TREE's doing and
	# not a wipe that would pass every line of the loop.
	ok(migrated.size() == 1 and migrated.has(LIVE_CELL),
		"the migration drops exactly the 24 and keeps the live cell %s (kept %s)" % [
			LIVE_CELL, str(migrated.keys())])
	# DELETED AT FX — 3 CHECKS: "the lane Venom / Snares / Guerilla still exists"
	# ("only what Venom's nodes DO was re-aimed"). Each asked a deleted tree's
	# lane, and no tree has lanes now; the names live on only as a retired
	# rune's `lane` tag.


# ---------- §3 the magnitudes, on the node that owes each one ----------

func _magnitudes() -> void:
	# RE-POINTED (FX) — THREE OF HIS NODES ARE PRECEDENTS OF THE ONE TREE. FX took
	# each one's FIELD AND MAGNITUDE unchanged (`talents.gd` names the precedent
	# above each node), so for these three "is the magnitude on the node that
	# owes it" still has a live answer: the node that owes it now is the one-tree
	# node that took it, and it pays the same number.
	ok(abs(float(_stat_of("tn_health", "max_hp_pct")) - 0.20) < 0.0001,
		"More Health, Woodcraft's precedent, pays 20% maximum Health")
	ok(_stat_of("tn_cleanse", "field_medic") == 2,
		"Cleanse Debuffs Each Turn, Field Medic's precedent, holds a COUNT of 2")
	ok(_stat_of("tn_look_past", "ghillie") == 65,
		"Enemies Look Past You, Ghillie Suit's precedent, holds a 65% chance")
	# DELETED AT FX — 21 CHECKS: the magnitudes of the nodes that are NOT
	# precedents — Potent Toxins' 8, Coated Blades' flag, Distillate's 2, Slow
	# Acting's flag, Creeping Death's flag, Necrosis's 35, Quartermaster's flag,
	# Reinforced Wire's 35, Quick Rigging's 2, Cruel Devices' 50, Snap Shut's
	# flag, Caught Fast's 5, Bone Breaker's 90, Deadfall Network's 3, Hit and
	# Run's 2, Scavenger's 25, Vulture's 60, Improvised's 2, Perfected Toxin's 2,
	# The Whole Forest's flag and Force of Nature's 20. Their SUBJECT was the
	# node, and FX deleted the tree that held it; no node of the one tree writes
	# any of these fields. Every FIELD still stands with its read site, and the
	# live sections below drive the ones BA measured, at these magnitudes, off
	# `RETIRED`.
	# THE TOOLTIP IS THE OTHER PLACE THE DESIGN NUMBER APPEARS. A magnitude that
	# lives only in a payload can drift from the text that sells it.
	# RE-POINTED (FX) for the three precedents: the one-tree node that took each
	# magnitude states it in its own text.
	var pairs := {"tn_health": ["sv_woodcraft", "+20%"],
		"tn_cleanse": ["sv_medic", "2 debuffs"],
		"tn_look_past": ["sv_ghillie", "65%"]}
	for id in pairs:
		var shown := Talents.desc_for(_node(id), 1)
		ok(shown.contains(String(pairs[id][1])),
			"%s (%s's precedent) renders its magnitude (%s not in \"%s\")" % [
				id, pairs[id][0], pairs[id][1], shown])
	# DELETED AT FX — 15 CHECKS: the same tooltip check for the fifteen nodes
	# that are not precedents (sv_potent, sv_virulence, sv_necrosis, sv_wire,
	# sv_rigging, sv_cruel, sv_caught, sv_bone, sv_network, sv_hitrun,
	# sv_scavenger, sv_vulture, sv_improvised, sv_epidemic, sv_force). Each
	# rendered a deleted node's own text.
	# DELETED AT FX — 5 CHECKS: the renames, "in the data rather than in a
	# comment" — sv_virulence carries Distillate, sv_plague Quartermaster,
	# sv_epidemic Perfected Toxin, sv_creeping keeps Creeping Death, and Necrosis
	# keeps its name. Each read a deleted node's name. The reservation those
	# names obeyed is still asserted over every node the Survivalist wears, in §1.


# ---------- §6 every counter is ADDITIVE at its READ SITE ----------
#
# The payload half is checked above; this is the other half, and it is the one
# that fails silently. A counter carrying 35 into a read site that still
# multiplies by 0.10 pays 350%, and nothing crashes.

func _additive_units() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var must := {
		"0.01 * fn_h.force_of_nature * sv_n": "Force of Nature reads percentage points",
		# BATCH EM — the rune half is summed at each site now, so these literals
		# carry the pair. THE QUESTION IS UNCHANGED: percentage POINTS read as a
		# magnitude, never a rank times a step — and the `gone` sweep below still
		# pins every retired coefficient.
		"0.01 * (attacker.vulture + attacker.rune_vulture)":
			"Vulture reads percentage points",
		"0.01 * nec_h.necrosis": "Necrosis reads percentage points (hero strikes)",
		"0.01 * nec_c.necrosis": "Necrosis reads percentage points (companion jaws)",
		"0.01 * (trapper.wire_ranks + trapper.rune_wire_ranks)":
			"Reinforced Wire reads percentage points",
		"0.01 * (trapper.cruel_ranks": "Cruel Devices reads percentage points (tripwire)",
		"0.01 * (placer.cruel_ranks + placer.rune_cruel_ranks)":
			"Cruel Devices reads percentage points (traps)",
		"0.01 * (sc_h.scavenger_ranks + sc_h.rune_scavenger_ranks)":
			"Scavenger reads percentage points",
		# RE-POINTED IN PLACE BY BATCH BR, AND IT WAS A REAL CATCH — the AZ
		# Follow-Through precedent exactly. The question is unchanged (does
		# Ghillie read its own counter as the percentage CHANCE, additively,
		# rather than through a hardcoded rate) and it is still worth asking;
		# only the fragment moved. BR extracted the roll into `_evade_chance`
		# so Camouflage could STACK with it as an independent chance rather
		# than overwrite it, and that extraction deleted this exact text.
		"0.01 * u.ghillie": "Ghillie Suit reads its own chance",
		"func _evade_chance(u: BattleUnit) -> float:":
			"...and it is one function, shared with Camouflage (Batch BR)",
		"maxi(u.deadfall_network, 1)": "the trap gate reads the counter, not a hardcoded 2",
		"placer.bone_breaker)": "Bone Breaker's Break damage comes off the counter",
		# BATCH DI — REPAIRED TO INTENT, NOT DELETED. The needle used to be
		# `placer.caught_fast)` and the closing paren was doing the work by
		# accident: DI passes the trap's PLACER as the status source, so the
		# call reads `..., placer.caught_fast, 0, 0, placer)` and the old
		# fragment stopped matching. The QUESTION is unchanged — does Caught
		# Fast's duration come off its own counter rather than a hardcoded
		# number — so the needle is anchored on the id and the counter
		# instead, which no further argument can break.
		"\"caught\", placer.caught_fast": "Caught Fast's duration comes off the counter",
		"_apply_status(src, \"elusive\", src.hit_and_run)":
			"Hit and Run's duration comes off the counter",
	}
	for needle in must:
		ok(src.contains(needle), "%s (missing: %s)" % [must[needle], needle])
	# ...and the OLD units are gone. A leftover would keep paying the old rate
	# from a second site while the new one looks correct.
	var gone := ["0.10 * trapper.wire_ranks", "0.15 * trapper.cruel_ranks",
		"0.15 * placer.cruel_ranks", "0.08 * sc_h.scavenger_ranks",
		"raw *= 1.30", "raw *= 1.20",
		"target.ghillie > 0 and randf() < 0.40",
		"victim.take_hit(0, 30)", "attacker.take_hit(0, 30)",
		"_apply_status(attacker, \"caught\", 3)",
		"_apply_status(victim, \"caught\", 3)"]
	for needle in gone:
		ok(not src.contains(needle),
			"the pre-BA unit is gone from battle.gd (still present: %s)" % needle)


# ---------- §1 the contagion space is RESERVED ----------
#
# The four nodes that occupied it are re-specced, and the rule is recorded in
# CLAUDE.md as a STANDING DESIGN RULE rather than as four edits — without that,
# a later batch re-adds "spreads to another enemy" innocently and spends the
# reserved spec's idea a second time.

func _contagion_reserved() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# Nothing in his tree names the retired designs.
	for t in _tree():
		var text := String(t["name"]) + " " + String(t["desc"])
		for banned in ["Epidemic", "Plague Bearer", "Virulence", "spreads", "leaps",
				"transfer", "Every enemy"]:
			ok(not text.contains(banned),
				"%s's node text carries nothing self-propagating (found \"%s\")" % [
					t["id"], banned])
	# The three read sites are gone, not merely unreachable.
	for needle in ["u.plague_bearer", "ep_h.epidemic", "Plague Bearer: the rot leaps",
			"Creeping Death: the rot crawls", "Epidemic: every enemy is already rotting"]:
		ok(not src.contains(needle),
			"the retired site is DELETED, not left gated (still present: %s)" % needle)
	# The fields themselves no longer exist, so a later batch cannot write one.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(not usrc.contains("var plague_bearer"),
		"BattleUnit has no plague_bearer field — the concept is gone, not renamed in place")
	ok(not usrc.contains("var epidemic"),
		"BattleUnit has no epidemic field")
	ok(usrc.contains("var quartermaster"), "...and quartermaster exists in its place")
	ok(usrc.contains("var perfected_toxin"), "...and perfected_toxin exists in its place")
	# The standing rule, in the file a later batch actually reads.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("CONTAGION"),
		"CLAUDE.md records the reservation as a standing design rule")
	ok(cm.to_lower().contains("self-propagating"),
		"...and names what is off-limits, so a later batch cannot re-add it innocently")
	# SNARES and GUERILLA were never disease and are untouched by the rule.
	# DELETED AT FX — 2 CHECKS: "Snap Shut is untouched by §1" and "The Whole
	# Forest is untouched by §1", each reading a deleted node's text for the word
	# that proved it unchanged ("RANGED", "Tripwire"). Both nodes went with the
	# tree; the reservation itself is asserted above over the one tree he wears.


# ---------- §5 the trophy-pool collision cannot arise ----------

func _no_ability_grants() -> void:
	# ASSERTED BOTH WAYS, the AY/AZ discipline: no node carries a grant, AND a
	# fully-learned tree adds nothing to the ability list.
	for t in _tree():
		var p: Dictionary = t.get("payload", {})
		ok(not p.has("new_ability"),
			"%s grants no ability inline" % t["id"])
		ok(not p.has("grant_ability"),
			"%s grants no ability by name" % t["id"])
		ok(Talents.granted_name(p) == "",
			"%s reports no granted name" % t["id"])
	# RE-POINTED (FX): learns every node of the tree he wears now, not the 24
	# retired ids — which the one tree does not hold, so learning them would
	# learn nothing and the comparison below would pass on an empty learn.
	var learned := {}
	for t in _tree():
		learned[String(t["id"])] = 1
	var bare := {"key": "hunter", "spec": "mystic", "tree": _tree(),
		"talents": {}, "bm_abilities": []}
	var full := {"key": "hunter", "spec": "mystic", "tree": _tree(),
		"talents": learned, "bm_abilities": []}
	var before: Array = Talents.ability_names(bare)
	var after: Array = Talents.ability_names(full)
	ok(after.size() == before.size(),
		"a fully-learned Survivalist tree adds NOTHING to the ability list (%d -> %d)" % [
			before.size(), after.size()])
	for n in after:
		ok(before.has(n), "the learned tree introduced no new ability (%s)" % n)
	# His three kit pieces are base kit and his five earnables are the pool, so
	# no trophy can ever land on a node's grant.
	var pool: Array = Classes.SPEC_POOLS["mystic"]
	for n in ["Explosive Shot", "Venom Coating", "Hamstring", "Deadfall", "Harvest"]:
		ok(pool.has(n), "%s is boss-trophy pool, not a tree grant" % n)
	for n in ["Tripwire", "Shrapnel Charge", "Snare Trap"]:
		ok(not pool.has(n), "%s is base kit, not earnable" % n)
	_report.append("§5: the Survivalist owes NO AU §1 fallback in either direction — "
		+ "his tree grants no abilities at all. With this batch, EVERY spec's "
		+ "fallback ownership is recorded.")


# ---------- §6 the rune audit ----------

func _rune_audit() -> void:
	var pool := _rune_pool()
	var mystic: Array = []
	for id in pool:
		if String(pool[id].get("scope", "")) == "spec:mystic":
			mystic.append(id)
	mystic.sort()
	# **BATCH FK MOVED IT 4 -> 9** — BA's four retired plus FK's five. The walk
	# reads the FILE, retired included; the per-field assertions below are the
	# claim, and this count is what catches a set going missing.
	ok(mystic.size() == 9, "nine spec:mystic runes (got %d)" % mystic.size())
	# EACH STILL PAYS EXACTLY WHAT ITS TEXT ADVERTISES — only the units moved.
	var lh: Dictionary = pool["long_hunt"]["payload"]["stat"]
	# BATCH EM RE-KEYED THE RUNE SIDE IN PLACE. The charter disconnects runes
	# from the talent trees, so each clause below writes `rune_X` instead of
	# the node's `X` and the read site sums the pair. **NOT ONE MAGNITUDE
	# MOVED** — the question these checks ask is the same one, of the field
	# the rune now owns.
	ok(int(lh["rune_cruel_ranks"]) == 15, "the Long Hunt still pays +15% trap damage")
	ok(int(lh["rune_wire_ranks"]) == 10, "the Long Hunt still pays 10% more of his Attack")
	ok(int(lh["rune_potent_ranks"]) == 1,
		"the Long Hunt's +1 Poison damage per stack is UNTOUCHED — "
		+ "Potent Toxins kept its units, so nothing about this clause moved")
	var cw: Dictionary = pool["carrion_wake"]["payload"]["stat"]
	ok(int(cw["rune_vulture"]) == 30, "the Carrion Wake still strikes 30% harder")
	ok(int(cw["rune_scavenger_ranks"]) == 16, "the Carrion Wake still drinks 16% max Mana")
	ok(abs(float(cw["max_hp_pct"]) + 0.12) < 0.0001, "...and its scar is untouched")
	var ww: Dictionary = pool["weeping_wound"]["payload"]["stat"]
	ok(int(ww["rune_potent_ranks"]) == 2, "the Weeping Wound still bites 2 harder per stack")
	ok(int(ww["rune_coated_blades"]) == 1,
		"...and writes coated_blades as a FLAG, which is still what that field is")
	ok(pool["quick_spring"]["payload"].has("ability"),
		"the Quick Spring is an ability payload and needed no re-point")
	# Every rune-written counter still has a LIVE read site.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for f in ["potent_ranks", "cruel_ranks", "wire_ranks", "scavenger_ranks",
			"vulture", "coated_blades"]:
		ok(bsrc.contains(f), "the rune-written counter %s still has a read site" % f)
	# THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO SURVIVALIST COUNTER.
	var sv_fields := ["potent_ranks", "coated_blades", "virulence_ranks",
		"slow_acting", "creeping_death", "necrosis", "quartermaster", "wire_ranks",
		"quick_rigging", "cruel_ranks", "snap_shut", "caught_fast", "bone_breaker",
		"deadfall_network", "hit_and_run", "scavenger_ranks", "field_medic",
		"vulture", "ghillie", "improvised", "perfected_toxin", "whole_forest",
		"force_of_nature"]
	var hunter_runes := 0
	for id in pool:
		if String(pool[id].get("scope", "")) != "class:hunter":
			continue
		hunter_runes += 1
		var st: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in sv_fields:
			ok(not st.has(f),
				"the class:hunter rune %s touches no Survivalist counter (writes %s)" % [id, f])
	ok(hunter_runes == 3, "three class:hunter runes checked (got %d)" % hunter_runes)
	# THE FLOAT TRAP, BOTH WAYS (§6, per AZ).
	for f in ["vulture", "coated_blades", "necrosis", "quartermaster",
			"perfected_toxin", "force_of_nature", "deadfall_network"]:
		ok(Runes.STAT_INT_KEYS.has(f),
			"%s is an int field that does not end _ranks — it must be in STAT_INT_KEYS" % f)
	ok(not Runes.STAT_INT_KEYS.has("max_hp_pct"),
		"max_hp_pct is FRACTIONAL and must stay OUT of STAT_INT_KEYS")


# ---------- §6 the three counters whose MEANING changed ----------
#
# A rune riding one of these is not mis-scaled, it is pointed at something that
# no longer means what it meant — a harder failure than a wrong number, because
# the value still applies and nothing crashes.

func _meaning_changed_audit() -> void:
	var pool := _rune_pool()
	var homeless: Array = []
	for id in pool:
		var st: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in ["plague_bearer", "epidemic", "creeping_death"]:
			if st.has(f):
				homeless.append("%s writes %s" % [id, f])
	ok(homeless.is_empty(),
		"NO rune rides a counter whose meaning changed (found: %s)" % [homeless])
	_report.append("§6: the audit came back CLEAN — no spec:mystic or class:hunter "
		+ "rune ever rode plague_bearer, epidemic or creeping_death, so nothing "
		+ "needed flagging for re-authoring. Recorded rather than assumed.")
	# And the replacement is not silently wearing the old one's clothes.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("Quartermaster is NOT Plague Bearer"),
		"the code says in as many words that Quartermaster is not a renamed Plague Bearer")


# ---------- §8 the bot ----------

func _bot_policy_source() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# BREADTH BEFORE DEPTH: the two breadth options are gated on the target
	# LACKING the status they would add.
	ok(src.contains("_ability_usable(u, snare) and not target_foe.has_status(\"snared\")"),
		"the bot skips a Snare on an already-snared mark")
	ok(src.contains("not (target_foe.has_status(\"slow\") and target_foe.has_status(\"exposed\"))"),
		"the bot skips a Hamstring whose two statuses are both already standing")
	# ...and depth is still reachable, LAST, once breadth has nothing to add.
	var snare_at := src.find("var snare := _find_ability(u, \"Snare Trap\")")
	var depth_at := src.find("# Depth last: another poison application only after")
	ok(snare_at > 0 and depth_at > snare_at,
		"the depth fallback sits BELOW the breadth options, not above them")
	# HARVEST READS THE SAME YIELD THE ABILITY IS PAID ON.
	ok(src.contains("_harvest_yield(target_foe) >= HARVEST_BOT_YIELD"),
		"the bot's Harvest threshold reads _harvest_yield, not a raw status count")
	ok(not src.contains("_status_count(target_foe) >= 4"),
		"the old raw-count threshold of 4 is gone")
	ok(src.contains("const HARVEST_BOT_YIELD := 3"),
		"the threshold is a named constant, shared with nothing that can disagree")


# ---------- §4 the exclusive pairs ----------

func _exclusive_pairs() -> void:
	# BOTH NAMED PAIRS GO. Virulence <-> Slow Acting dissolved on its own, and
	# Plague Bearer <-> Deadfall Network went with Plague Bearer.
	# DELETED AT FX — 2 CHECKS: "Distillate and Slow Acting sit in DIFFERENT rows
	# of ONE lane — a player holds both" and "Quartermaster and Deadfall Network
	# share row 7, so row exclusivity already enforces the choice". Each read a
	# deleted node's row and lane; FX deleted the rows, the lanes and the nodes,
	# and nothing in the one tree is exclusive.
	# The prose list in CLAUDE.md must not name either.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not cm.contains("plague_bearer/deadfall") and not cm.contains("virulence/slow_acting"),
		"CLAUDE.md's prose pair list names neither retired pair")
	_report.append("§4: with this batch the prose exclusive-pair list is EMPTY. "
		+ "Every pair ever authored has either dissolved under Batch AI's row "
		+ "exclusivity or is a same-row pair row exclusivity already enforces. "
		+ "`test_runes._exclusives` has been a bare `pass` since AI.")


# ---------- §9 the documentation ----------

func _docs() -> void:
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	for banned in ["Plague Bearer", "Epidemic", "Virulence"]:
		ok(not doc.contains(banned),
			"master.html no longer documents %s" % banned)
	# FX — THREE CHECKS DELETED HERE (DG §2). They asked that master.html
	# document Quartermaster, Perfected Toxin and Distillate, three Survivalist
	# nodes BA authored. FX deleted the twelve spec trees and those nodes with
	# them, and master.html no longer describes them. The contagion names above
	# stay pinned ABSENT, because that reserve is a standing rule.
	ok(doc.contains("+8%") and doc.contains("DIFFERENT status effect"),
		"master.html still states Trapper's rate — the one ceiling that stays")
	ok(doc.contains("bounded by how many distinct debuffs exist"),
		"...and says WHY that ceiling is correct rather than an oversight")
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(not gloss.contains("Epidemic"),
		"the glossary's Poison entry no longer names Epidemic")
	# RE-POINTED AND INVERTED (FX). BA's pin said the Poison entry names Perfected
	# Toxin in Epidemic's place. FX deleted the tree that held Perfected Toxin and
	# took the glossary's clauses naming deleted nodes with it, so the entry now
	# describes Poison and names no node at all. The live question is the same
	# one pointed the way the doc now answers it: the entry does not name a
	# RETIRED node in the capstone's place either.
	ok(not gloss.contains("Perfected Toxin"),
		"...and names no retired node in its place — Perfected Toxin went with its tree")
	# The passive the player reads on the awakening screen and the hero sheet.
	var pd := String(Classes.SPEC_INFO["mystic"]["passive_desc"])
	ok(pd.contains("DIFFERENT status"), "the in-game passive text still names breadth")
	# The spec id is load-bearing and must never be renamed.
	ok(Classes.SPEC_INFO.has("mystic"),
		"the spec id is still \"mystic\" — saves and trees key on it")


# ---------- NEGATIVE CONTROLS, at the source ----------
#
# The four the batch named, each of which would fail SILENTLY: the code still
# runs, nothing logs an error, and the spec quietly becomes the one §1 forbids.

func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# (1) Creeping Death still firing on death — the corpse transfer §1 reserves.
	ok(not bsrc.contains("_living_hero_with(\"creeping_death\") != null"),
		"NEG 1: no death-path site reads creeping_death any more")
	ok(bsrc.contains("func _creeping_refresh"),
		"...and the re-spec lives on the status-application path instead")
	var death_at := bsrc.find("func _on_enemy_death")
	var creep_at := bsrc.find("_creeping_refresh(target, id)")
	ok(creep_at > 0 and creep_at < death_at,
		"NEG 1: the Creeping Death hook is in _apply_status, not in _on_enemy_death")
	# (2) Perfected Toxin poisoning the whole field at battle start.
	ok(not bsrc.contains("for ep_e in enemies"),
		"NEG 2: no battle-start loop poisons the field")
	ok(not bsrc.contains("perfected_toxin > 0:\n\t\t\tfor "),
		"NEG 2: the capstone has no field-wide hook of its own")
	# (3) Harvest counting sticky poison it did not remove.
	ok(bsrc.contains("hv_n = maxi(hv_before - _status_count(target), 0)"),
		"NEG 3: Harvest's count is measured AFTER the purge, as a delta")
	ok(not bsrc.contains("var hv_n := _status_count(target)"),
		"NEG 3: the pre-purge count is gone")
	# (4) Quartermaster's poison credited to the ally rather than to him.
	ok(bsrc.contains("_apply_poison(qm_h, qm_t, 2)"),
		"NEG 4: Quartermaster applies the poison with the SURVIVALIST as src")
	ok(not bsrc.contains("_apply_poison(attacker, qm_t"),
		"NEG 4: it is never applied with the swinging ally as src")


# ---------- §2 live: each Venom node hangs a DIFFERENT affliction ----------

func _live_carriers() -> void:
	# Distillate: extra stacks AND Exposed.
	var scene := await _spawn({"sv_virulence": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 4)
	ok(foe.has_status("poison"), "Distillate's poison lands")
	ok(foe.status_stacks("poison") == 3,
		"...as 1 + 2 extra stacks (got %d)" % foe.status_stacks("poison"))
	ok(foe.has_status("exposed"), "...AND it applies Exposed — the carrier clause")
	ok(scene.call("_status_count", foe) == 2,
		"...so ONE application is worth TWO distinct statuses to the passive")
	await _kill(scene)
	# Coated Blades: Poison AND Cripple, off a basic attack.
	scene = await _spawn({"sv_coated": 1})
	h = _hero(scene, 3)
	foe = scene.get("enemies")[0]
	await scene.call("_resolve", h, h.abilities[0], foe, "good")
	ok(foe.has_status("poison"), "Coated Blades poisons off the basic attack")
	ok(foe.has_status("cripple"), "...AND Cripples — the carrier clause")
	await _kill(scene)


func _live_slow_acting() -> void:
	var scene := await _spawn({"sv_slow_acting": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 3)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("turns", 0)) == 6, "Slow Acting doubles the duration (got %d)" % ps.get("turns", 0))
	ok(bool(ps.get("sticky", false)), "...and the poison is uncleansable")
	ok(foe.has_status("slow"),
		"...and it applies Slowed — the pun the node has carried unclaimed since Batch 33")
	foe.purge_debuffs()
	ok(foe.has_status("poison"), "...the sticky poison survives a cleanse")
	await _kill(scene)


func _live_breadth_rises() -> void:
	# THE PASSIVE'S OWN COUNT, which is the number §0 measures: it rises as the
	# carriers land, which is the whole point of §2.
	var scene := await _spawn({"sv_virulence": 1, "sv_slow_acting": 1, "sv_coated": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(scene.call("_status_count", foe) == 0, "the mark opens clean")
	scene.call("_apply_poison", h, foe, 3)
	var n := int(scene.call("_status_count", foe))
	ok(n == 3, "one poison application from a full carrier build is worth THREE "
		+ "distinct statuses — Poison, Exposed and Slowed (got %d)" % n)
	_report.append(("§2 MEASURED: one poison application under Distillate + Slow "
		+ "Acting lands %d distinct statuses, i.e. Trapper pays +%d%% off a "
		+ "single cast where the pre-BA lane paid +8%%.") % [n, 8 * n])
	await _kill(scene)


# ---------- §3 live: Creeping Death REFRESHES, it does not transfer ----------

func _live_creeping_refresh() -> void:
	var scene := await _spawn({"sv_creeping": 1})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	scene.call("_apply_poison", h, foe, 5)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("full", 0)) == 5, "the poison remembers the duration it was applied with")
	ps["turns"] = 1        # let it run down
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("turns", 0)) == 5,
		"Creeping Death refreshes the Poison to FULL when another status lands (got %d)" \
			% foe.get_status("poison").get("turns", 0))
	ok(not other.has_status("poison"),
		"...and NOTHING crawls to a second enemy — the transmission is gone")
	# The old behaviour, gone: a poisoned death passes nothing on.
	foe.hp = 0
	scene.call("_on_enemy_death", foe)
	ok(not other.has_status("poison"),
		"a poisoned corpse passes its stacks to nobody")
	await _kill(scene)


# ---------- §3 live: Quartermaster poisons from an ALLY'S attack ----------

func _live_quartermaster() -> void:
	var scene := await _spawn({"sv_plague": 1, "sv_potent": 1})
	var h := _hero(scene, 3)
	var ally := _hero(scene, 0)          # the Berserker, who owns none of this
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(h.quartermaster == 1, "the Survivalist carries Quartermaster")
	ok(ally.quartermaster == 0, "...and his ally does not")
	await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	ok(foe.has_status("poison"),
		"an ALLY'S basic attack applies the Survivalist's Poison")
	# THE CREDIT, which is negative control 4: the tick is HIS, so it reads HIS
	# Attack and HIS Potent Toxins rather than the swinging ally's.
	var tick := int(foe.get_status("poison").get("tick", 0))
	var his := maxi(int(round(0.03 * h.attack)), 1) + h.potent_ranks
	ok(tick == his,
		"...and the tick is HIS (%d), not the ally's — the poison is the Survivalist's work" % his)
	ok(tick != maxi(int(round(0.03 * ally.attack)), 1),
		"...demonstrably not the ally's own %d" % maxi(int(round(0.03 * ally.attack)), 1))
	await _kill(scene)


# ---------- §3 live: Perfected Toxin ----------

func _live_perfected_toxin() -> void:
	var scene := await _spawn({"sv_epidemic": 1})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	# NEGATIVE CONTROL 2, live — AND THE FIRST DRAFT OF THIS CHECK COULD NOT
	# FAIL, which the control caught. `_run_battle` opens with `await _wait(0.6)`
	# on a REAL SceneTreeTimer, so 20 process_frames land BEFORE the battle-start
	# block runs and a reinstated field-wide infection sailed past. Engine
	# time_scale scales those timers and nothing else (the AC gotcha), so the
	# opening genuinely happens before the count is taken.
	Engine.time_scale = 50.0
	for _i in 60:
		await process_frame
	Engine.time_scale = 1.0
	var poisoned_at_start := 0
	for e in foes:
		if e.has_status("poison"):
			poisoned_at_start += 1
	ok(poisoned_at_start == 0,
		"Perfected Toxin poisons NOBODY at battle start (got %d) — that was Epidemic" \
			% poisoned_at_start)
	scene.call("_apply_poison", h, foe, 3)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("turns", 0)) == -1, "his Poison never expires")
	ok(bool(ps.get("sticky", false)), "...and cannot be cleansed")
	foe.purge_debuffs()
	ok(foe.has_status("poison"), "...it survives a full cleanse")
	ok(scene.call("_cleansable_debuffs", foe).is_empty()
		or not scene.call("_cleansable_debuffs", foe).any(func(s): return s.id == "poison"),
		"...and a Cleansing Rite cannot reach it either")
	# THE TICK RISES. Its own function precisely because _run_battle cannot be
	# driven headlessly (the AR trap).
	var t0 := int(foe.get_status("poison").get("tick", 0))
	scene.call("_perfected_toxin_tick", foe)
	var t1 := int(foe.get_status("poison").get("tick", 0))
	scene.call("_perfected_toxin_tick", foe)
	var t2 := int(foe.get_status("poison").get("tick", 0))
	ok(t1 == t0 + 2 and t2 == t0 + 4,
		"the tick rises by 2 each turn it persists (%d -> %d -> %d)" % [t0, t1, t2])
	_report.append(("§3 MEASURED: a Perfected Toxin tick opens at %d and reads %d "
		+ "after two turns — it is the only poison in the game that gets worse "
		+ "by standing still.") % [t0, t2])
	await _kill(scene)


# ---------- §7 live: Harvest pays for what it REMOVED ----------

func _live_harvest_count() -> void:
	# Slow Acting makes his poison sticky, so the purge cannot take it — and
	# THAT is the status Harvest used to be paid for anyway.
	var scene := await _spawn({"sv_slow_acting": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 3)               # poison (sticky) + slowed
	scene.call("_apply_status", foe, "cripple", 3, 0, 0, h)
	var standing := int(scene.call("_status_count", foe))
	var reapable := int(scene.call("_harvest_yield", foe))
	ok(standing == 3, "three statuses stand on the mark (got %d)" % standing)
	ok(reapable == 2,
		"...but only TWO can actually be reaped — the sticky poison refuses (got %d)" % reapable)
	ok(reapable < standing,
		"the two numbers genuinely differ, so the test can fail")
	var hp_before := foe.hp
	var harv := Classes.survivalist_pool_ability("Harvest")
	await scene.call("_resolve", h, harv, foe, "good")
	ok(foe.has_status("poison"),
		"Harvest leaves the sticky poison standing — it did not remove it")
	# The bill: 12% of Attack per status, and it must be the REAPED count.
	var dealt := hp_before - foe.hp
	var per := 0.12 * h.attack * (1.0 - foe.effective_armor()) \
		* (1.0 - float(foe.resists.get("nature", 0.0)))
	ok(dealt < per * 2.6,
		"...and is paid for TWO statuses, not three (dealt %d, three would be ~%d)" % [
			dealt, int(per * 3.0)])
	_report.append("§7 MEASURED: Harvest against 3 standing / 2 reapable statuses "
		+ "dealt %d, against ~%d for the old over-count." % [dealt, int(per * 3.0)])
	await _kill(scene)


# ---------- §3 live: the trap cap reads the counter ----------

func _live_trap_cap() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	var snare: Ability = null
	for a in h.abilities:
		if a.display_name == "Snare Trap":
			snare = a
	ok(snare != null, "Snare Trap is in his opening kit")
	ok(scene.call("_ability_usable", h, snare), "with no traps out, a snare is usable")
	h.deadfall_armed = 1
	ok(not scene.call("_ability_usable", h, snare),
		"one trap out and no Deadfall Network: the second is refused")
	await _kill(scene)
	scene = await _spawn({"sv_network": 1})
	h = _hero(scene, 3)
	ok(h.deadfall_network == 3, "Deadfall Network installs a cap of THREE")
	# RE-POINTED IN PLACE BY BATCH BD, with the reason in the file, because the
	# UNIT of `deadfall_armed` changed underneath this check: it counted armed
	# TRAPS and now counts CHARGES on the ONE deadfall a cast places, so a
	# 3-charge trap is ONE occupant rather than three. Filling the cap therefore
	# means real occupants — a deadfall plus snared enemies — which is what the
	# question was always about. THE QUESTION IS UNCHANGED: the cap is the
	# counter, not a hardcoded 2. test_batch_bd owns the charges-are-not-traps
	# half directly.
	var ba_idx: int = scene.get("heroes").find(h)
	var ba_foes: Array = scene.get("enemies")
	h.deadfall_armed = 3
	ba_foes[0].add_status("snared", "Snared", "Sn", Color(0.75, 0.65, 0.30), -1,
		"", ba_idx)
	ok(scene.call("_ability_usable", h, snare),
		"a deadfall plus ONE snare under Deadfall Network: a THIRD trap is allowed")
	ba_foes[1].add_status("snared", "Snared", "Sn", Color(0.75, 0.65, 0.30), -1,
		"", ba_idx)
	ok(not scene.call("_ability_usable", h, snare),
		"...and a fourth is refused — the cap is the counter, not a hardcoded 2")
	await _kill(scene)


# ---------- §3 live: Quick Rigging's cooldown clause, which was INERT ----------

func _live_quick_rigging() -> void:
	var base := await _spawn({})
	var bh := _hero(base, 3)
	var base_cd := 0
	for a in bh.abilities:
		if a.display_name == "Snare Trap":
			base_cd = a.cooldown
	ok(base_cd == 3, "Snare Trap's base cooldown is 3 (got %d)" % base_cd)
	await _kill(base)
	var scene := await _spawn({"sv_rigging": 1})
	var h := _hero(scene, 3)
	var cd := 99
	for a in h.abilities:
		if a.display_name == "Snare Trap":
			cd = a.cooldown
	ok(cd == base_cd - 2,
		"Quick Rigging really reduces Snare Trap's cooldown by 2 (%d -> %d) — "
		% [base_cd, cd] + "the clause had NO implementation at all before this batch")
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.has_status("cripple"), "...and its spring still applies Cripple")
	await _kill(scene)


# ---------- §3 live: the Snares magnitudes land as written ----------

func _live_snares_magnitudes() -> void:
	var scene := await _spawn({"sv_bone": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	var pr_before := foe.pressure
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.pressure > pr_before,
		"Bone Breaker's Break damage lands (pressure %d -> %d)" % [pr_before, foe.pressure])
	await _kill(scene)
	scene = await _spawn({"sv_caught": 1})
	h = _hero(scene, 3)
	foe = scene.get("enemies")[0]
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.has_status("caught"), "Caught Fast lands")
	ok(int(foe.get_status("caught").get("turns", 0)) == 5,
		"...for 5 turns (got %d)" % foe.get_status("caught").get("turns", 0))
	foe.hp = maxi(foe.max_hp / 2, 1)
	var before := foe.hp
	foe.heal_amount(50)
	ok(foe.hp == before, "...and the wound genuinely refuses healing")
	await _kill(scene)


# ---------- §3 live: the Guerilla magnitudes land as written ----------

func _live_guerilla_magnitudes() -> void:
	# RE-POINTED (FX): Woodcraft is learned as More Health, the one-tree node that
	# took its field and its magnitude (max_hp_pct 0.20) whole.
	var scene := await _spawn({"tn_health": 1})
	var h := _hero(scene, 3)
	var bare := await _spawn_bare_hp()
	ok(h.max_hp > bare,
		"More Health (Woodcraft's precedent) raises his maximum Health (%d over a bare %d)" % [h.max_hp, bare])
	ok(abs(float(h.max_hp) / float(bare) - 1.20) < 0.02,
		"...by 20%% (ratio %.3f)" % (float(h.max_hp) / float(bare)))
	await _kill(scene)
	scene = await _spawn({"sv_hitrun": 1})
	h = _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_status", foe, "cripple", 3, 0, 0, h)
	scene.call("_hit_and_run", h)
	ok(h.has_status("elusive"), "Hit and Run grants Elusive")
	ok(int(h.get_status("elusive").get("turns", 0)) == 2,
		"...for 2 turns (got %d)" % h.get_status("elusive").get("turns", 0))
	await _kill(scene)
	scene = await _spawn({"sv_improvised": 1})
	h = _hero(scene, 3)
	ok(h.improvised == 2, "Improvised covers TWO opening abilities")
	ok(h.improvised_used == 0, "...and the spend counter opens at zero, not false")
	await _kill(scene)
	scene = await _spawn({"sv_scavenger": 1})
	h = _hero(scene, 3)
	h.resource = 0
	var dying: BattleUnit = scene.get("enemies")[0]
	dying.hp = 0
	scene.call("_on_enemy_death", dying)
	ok(h.resource == int(h.max_resource * 0.25),
		"Scavenger restores 25%% of maximum Mana on a death (got %d of %d)" % [
			h.resource, h.max_resource])
	await _kill(scene)


# A Survivalist with no talents at all, for Woodcraft's ratio.
func _spawn_bare_hp() -> int:
	var scene := await _spawn({})
	var hp: int = _hero(scene, 3).max_hp
	await _kill(scene)
	return hp
