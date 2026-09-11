# test_batch_at.gd — the Arcanist re-authored around ESCALATION, plus §8's
# Shatter re-spec. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_at.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, single ranks,
#      every one of the 24 ids present. (test_batch_ai asserts this generically
#      for all twelve trees; it is repeated here because AT renamed a lane and
#      moved an id between lanes, and a shape break would otherwise only
#      surface there.)
#   2. ALL 24 IDS — id, row, lane, name. EVERY id survives and re-specs in
#      place, which is the whole migration promise: saved picks resolve and no
#      save version moves. A dropped or renamed id silently voids a saved tree.
#   3. THE MAGNITUDES, ADDITIVE — both halves: the payload the node applies AND
#      the number its tooltip renders.
#   4. §1 — THE COMPOUNDING CURVE, at BOTH read sites, against the batch's own
#      worked table. This is the one thing the batch said to report on, so it
#      is checked as arithmetic rather than trusted: 5 -> +22%/+11%,
#      8 -> +54%/+27%, 12 -> +117%/+59%, 16 -> +204%/+102%. Plus the two shapes
#      that make it an escalation rather than a ramp — the curve is CONVEX (its
#      differences grow), and NOTHING CAPS EITHER END.
#   5. §2 — THE SQUARING TRAP. Neither Arcane Cannon nor Magi's Wrath may carry
#      a per-stack DAMAGE term, in the source or in live damage. Their Break
#      terms must survive, because Break is a different axis.
#   6. §2 — DEATH RAY's 5-stack gate, and that it CONSUMES NOTHING. Stabilize
#      out of the opening three and earnable from the spec pool.
#   7. §8 — SHATTER scales on TURNS HELD, caps at 12, and a held entry's
#      counter advances ONCE PER TURN and not once per unit per turn. The last
#      clause is the one worth a test: `_hold_sync` walks a ledger, and a
#      nested walk would look identical until two enemies were held at once.
#   8. §4/§5 — the rune audit: every counter the four Arcanist runes and the
#      three Mage runes ride is written by a node or still has a live read
#      site, the re-points pay their advertised numbers ALONE AND STACKED, and
#      the dissolved exclusive pair is gone from CLAUDE.md's prose.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
# BATCH FX RE-POINTED THIS FILE IN PLACE, AND ITS SUBJECT WENT WITH THE TWELVE
# TREES. The Arcanist wears the ONE class tree now (`generate_tree` answers it
# for every spec with a class), and the 24 nodes the tables below record exist
# nowhere a check can read them. Each section says at its site what moved and
# by exactly how many checks; in short:
#   * the SHAPE questions the one tree still answers (its size, unique ids,
#     single ranks, no dangling exclusivity, three full tiers) are asked of it;
#     the lane / row / capstone / name / tooltip questions are DELETED under
#     DG §2, because FX deleted their subject — except Conversion's, whose field
#     AND magnitude `tn_resource_ward` carries, so its questions go there;
#   * every MECHANIC this file drives still has its field and its read site, so
#     RETIRED carries the exact payload each retired node carried and `_spawn`
#     installs it inline through the real `apply_from_tree` — not one live
#     assertion moved;
#   * "a dropped id voids a saved tree" is asked of FX's load migration, which
#     DROPS a saved pick on a deleted id and keeps one on a live id.
# The tables below stay AT's record of its 24 nodes; RETIRED is FX's record of
# what they carried.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")


var checks := 0
var fails: Array = []

# id -> [row, lane, name]. BATCH_AT.md §3's three tables, transcribed once.
# The ids are the OLD ones by design — §9's mapping lives in the changelog,
# and this is the machine-checkable half of it.
const NODES := {
	"ar_harmonics": [1, "Resonance", "Harmonics"],
	"ar_mastery": [2, "Resonance", "Attunement"],
	"ar_charged": [3, "Resonance", "Charged Bolts"],
	# BATCH DO re-authored both cells. `ar_overcharge` is "Overdraw" rather
	# than "Overcharge" ON PURPOSE: a node named after a live DRAFT CARD is
	# the `wd_spiked`/Spite collision, and DN paid for finding that one.
	"ar_overcharge": [4, "Resonance", "Overdraw"],
	"ar_core": [5, "Resonance", "Resonant Core"],
	"ar_critical_mass": [6, "Resonance", "Critical Mass"],
	"ar_unlimited": [7, "Resonance", "Cascade"],
	"ar_conduit": [1, "Overload", "Conduit"],
	"ar_volatility": [2, "Overload", "Volatility"],
	"ar_temporal": [3, "Overload", "Temporal Rift"],
	"ar_suppressing": [4, "Overload", "Suppressing Fire"],
	"ar_cannoneer": [5, "Overload", "Cannoneer"],
	"ar_barrister": [6, "Overload", "Barrage Master"],
	"ar_mindfulness": [7, "Overload", "Terminal Velocity"],
	"ar_conversion": [1, "Entropy", "Conversion"],
	"ar_on_edge": [2, "Entropy", "On the Edge"],
	"ar_meltdown": [3, "Entropy", "Feedback Loop"],
	"ar_stable": [4, "Entropy", "Stable Alignment"],
	"ar_still": [5, "Entropy", "Backlash"],
	"ar_attunement": [6, "Entropy", "Siphon"],
	"ar_ward": [7, "Entropy", "Event Horizon"],
	"ar_singularity": [9, "Resonance", "Singularity"],
	"ar_wrath": [9, "Overload", "Unchained"],
	"ar_timelord": [9, "Entropy", "Perfect Conversion"],
}

# id -> [stat field, the value the PAYLOAD writes]. ADDITIVE units: each is the
# design number in the units its read site sums, never a bare 1 standing in for
# a multiplier.
const PAYLOADS := {
	"ar_harmonics": ["harmonics_ranks", 1],
	"ar_mastery": ["attunement_crit", 1],
	"ar_charged": ["charged_bolts_ranks", 5],
	"ar_core": ["resonant_core_ranks", 1],
	"ar_critical_mass": ["critical_mass_stacks", 4],
	"ar_unlimited": ["cascade_stacks", 1],
	"ar_conduit": ["conduit_step", 0.5],
	"ar_volatility": ["volatility_ranks", 30],
	"ar_temporal": ["temporal_ranks", 40],
	"ar_suppressing": ["suppressing_ranks", 2],
	"ar_cannoneer": ["cannoneer_ranks", 4],
	"ar_mindfulness": ["terminal_velocity", 15],
	"ar_conversion": ["conversion_ranks", 30],
	"ar_on_edge": ["on_edge_threshold", 35.0],
	"ar_meltdown": ["feedback_ranks", 30],
	"ar_stable": ["stable_ranks", 25],
	"ar_still": ["backlash_stacks", 1],
	"ar_attunement": ["siphon_ranks", 20],
	"ar_ward": ["event_horizon", 15],
	# RE-POINTED BY BATCH AU §4, in place with the reason here: the two
	# capstones were crossed and are uncrossed now. The step-doubling moved to
	# Magi's Wrath (Overload, whose thesis it always was) and Singularity took
	# a BUILD-RATE effect instead. It writes two fields; the second is asserted
	# below beside the kill clause.
	"ar_singularity": ["singularity_crit_build", 2],
	"ar_timelord": ["perfect_conversion", 1],
}

# id -> the number its TOOLTIP must render. Most of this tree's magnitudes live
# in a battle.gd read site, so the tooltip is the only place the DESIGN number
# appears beside the payload — and the two can drift apart silently.
const TOOLTIPS := {
	"ar_harmonics": "2", "ar_mastery": "3", "ar_charged": "5",
	"ar_core": "1", "ar_critical_mass": "4", "ar_unlimited": "1",
	"ar_conduit": "2", "ar_volatility": "30", "ar_temporal": "40",
	"ar_suppressing": "2", "ar_cannoneer": "9", "ar_barrister": "3",
	"ar_mindfulness": "15", "ar_conversion": "30", "ar_on_edge": "35",
	"ar_meltdown": "30", "ar_stable": "25", "ar_still": "1",
	"ar_attunement": "20", "ar_ward": "15",
}

# §1's worked table, verbatim: stacks -> [damage %, damage-taken %].
const CURVE := {5: [22, 11], 8: [54, 27], 12: [117, 59], 16: [204, 102]}


# ── BATCH FX: THE RETIRED PAYLOADS ──────────────────────────────────────────
# FX deleted the twelve spec trees and the 27 Arcanist nodes with them. EVERY
# FIELD THEY WROTE AND EVERY READ SITE STANDS (dormant: no node writes one), so
# each question this file drove through a node is re-pointed by installing the
# EXACT payload the retired node carried, transcribed here from the tree FX
# deleted. `_retired_tree` builds an inline tree out of it and `_spawn` hands
# that to the real `apply_from_tree`, so a live check learns `ar_harmonics`
# exactly as it did before FX; only the source of the payload moved.
# id -> [name, payload]. 28 entries.
# PLUS ONE CRYOMANCER NODE, because §8's Shatter check spawns a Cryomancer
# learning `cr_shatter` and that payload has to come from somewhere too.
const RETIRED := {
	# FX: the payload the retired ar_harmonics (Harmonics) carried — the node is deleted,
	# the field and its read site stand.
	"ar_harmonics": ["Harmonics", {"stat": {"harmonics_ranks": 1}}],
	# FX: the payload the retired ar_mastery (Attunement) carried — the node is deleted,
	# the field and its read site stand.
	"ar_mastery": ["Attunement", {"stat": {"attunement_crit": 1}}],
	# FX: the payload the retired ar_charged (Charged Bolts) carried — the node is deleted,
	# the field and its read site stand.
	"ar_charged": ["Charged Bolts", {"stat": {"charged_bolts_ranks": 5}}],
	# FX: the payload the retired ar_overcharge (Overdraw) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"ar_overcharge": ["Overdraw", {"ability": "Arcane Cannon", "add": {"cost": -10}, "set": {"cooldown": 1}}],
	# FX: the payload the retired ar_core (Resonant Core) carried — the node is deleted,
	# the field and its read site stand.
	"ar_core": ["Resonant Core", {"stat": {"resonant_core_ranks": 1}}],
	# FX: the payload the retired ar_critical_mass (Critical Mass) carried — the node is deleted,
	# the field and its read site stand.
	"ar_critical_mass": ["Critical Mass", {"stat": {"critical_mass_stacks": 4}}],
	# FX: the payload the retired ar_unlimited (Cascade) carried — the node is deleted,
	# the field and its read site stand.
	"ar_unlimited": ["Cascade", {"stat": {"cascade_stacks": 1}}],
	# FX: the payload the retired ar_conduit (Conduit) carried — the node is deleted,
	# the field and its read site stand.
	"ar_conduit": ["Conduit", {"stat": {"conduit_step": 0.5}}],
	# FX: the payload the retired ar_volatility (Volatility) carried — the node is deleted,
	# the field and its read site stand.
	"ar_volatility": ["Volatility", {"stat": {"volatility_ranks": 30, "volatility_recoil": 25}}],
	# FX: the payload the retired ar_temporal (Temporal Rift) carried — the node is deleted,
	# the field and its read site stand.
	"ar_temporal": ["Temporal Rift", {"stat": {"temporal_ranks": 40}}],
	# FX: the payload the retired ar_suppressing (Suppressing Fire) carried — the node is deleted,
	# the field and its read site stand.
	"ar_suppressing": ["Suppressing Fire", {"stat": {"suppressing_ranks": 2}}],
	# FX: the payload the retired ar_cannoneer (Cannoneer) carried — the node is deleted,
	# the field and its read site stand.
	"ar_cannoneer": ["Cannoneer", {"stat": {"cannoneer_ranks": 4}}],
	# FX: the payload the retired ar_barrister (Barrage Master) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"ar_barrister": ["Barrage Master", {"ability": "Arcane Barrage", "add": {"random_hits": 3}}],
	# FX: the payload the retired ar_mindfulness (Terminal Velocity) carried — the node is deleted,
	# the field and its read site stand.
	"ar_mindfulness": ["Terminal Velocity", {"stat": {"terminal_velocity": 15}}],
	# FX: the payload the retired ar_conversion (Conversion) carried — the node is deleted,
	# the field and its read site stand.
	"ar_conversion": ["Conversion", {"stat": {"conversion_ranks": 30}}],
	# FX: the payload the retired ar_on_edge (On the Edge) carried — the node is deleted,
	# the field and its read site stand.
	"ar_on_edge": ["On the Edge", {"stat": {"on_edge_threshold": 35.0, "on_edge_stacks": 4}}],
	# FX: the payload the retired ar_meltdown (Feedback Loop) carried — the node is deleted,
	# the field and its read site stand.
	"ar_meltdown": ["Feedback Loop", {"stat": {"feedback_ranks": 30}}],
	# FX: the payload the retired ar_stable (Stable Alignment) carried — the node is deleted,
	# the field and its read site stand.
	"ar_stable": ["Stable Alignment", {"stat": {"stable_ranks": 25}}],
	# FX: the payload the retired ar_still (Backlash) carried — the node is deleted,
	# the field and its read site stand.
	"ar_still": ["Backlash", {"stat": {"backlash_stacks": 1}}],
	# FX: the payload the retired ar_attunement (Siphon) carried — the node is deleted,
	# the field and its read site stand.
	"ar_attunement": ["Siphon", {"stat": {"siphon_ranks": 20}}],
	# FX: the payload the retired ar_ward (Event Horizon) carried — the node is deleted,
	# the field and its read site stand.
	"ar_ward": ["Event Horizon", {"stat": {"event_horizon": 15}}],
	# FX: the payload the retired ar_convergence (Harmonic Convergence) carried — the node is deleted,
	# the field and its read site stand.
	"ar_convergence": ["Harmonic Convergence", {"stat": {"convergence": 10}}],
	# FX: the payload the retired ar_blowback (Blowback) carried — the node is deleted,
	# the field and its read site stand.
	"ar_blowback": ["Blowback", {"stat": {"blowback": 100}}],
	# FX: the payload the retired ar_entropy_toll (Entropy's Toll) carried — the node is deleted,
	# the field and its read site stand.
	"ar_entropy_toll": ["Entropy's Toll", {"stat": {"entropy_toll": 3}}],
	# FX: the payload the retired ar_singularity (Singularity) carried — the node is deleted,
	# the field and its read site stand.
	"ar_singularity": ["Singularity", {"stat": {"singularity_crit_build": 2, "singularity_kill_build": 3}}],
	# FX: the payload the retired ar_wrath (Unchained) carried — the node is deleted,
	# the field and its read site stand.
	"ar_wrath": ["Unchained", {"stat": {"wrath_step_double": 1}}],
	# FX: the payload the retired ar_timelord (Perfect Conversion) carried — the node is deleted,
	# the field and its read site stand.
	"ar_timelord": ["Perfect Conversion", {"stat": {"perfect_conversion": 1}}],
	# FX: the payload the retired cr_shatter (Shardfall) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_shatter": ["Shardfall", {"ability": "Razor Ice", "add": {"multi_hits": 3}, "set": {"cooldown": 1}}],
}


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


# BATCH FX — the tree a member wears, built from RETIRED: one node per id,
# carrying the retired node's exact payload. An id the record does not hold is
# a FAILED check rather than a silent no-op, because a learned id that installs
# nothing is exactly the fault FX left in every suite that learned a deleted id.
func _retired_tree(ids: Array) -> Array:
	var out: Array = []
	for id in ids:
		if not RETIRED.has(id):
			ok(false, "%s is not in the RETIRED record, so nothing installs it" % id)
			continue
		var rec: Array = RETIRED[id]
		out.append({"id": String(id), "name": String(rec[0]),
			"payload": (rec[1] as Dictionary).duplicate(true)})
	return out


func _run() -> void:
	await process_frame
	Profile.save_path = "user://profile_batch_at_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	# BATCH FX: awaited now — §3 measures the retired payloads on a live spawn.
	await _magnitudes()
	_curve_maths()
	_kit()
	_source_audit()
	_rune_audit()
	_claude_md()

	await _live_curve()
	await _live_no_per_stack()
	await _live_death_ray()
	await _live_build_rate()
	await _live_entropy()
	await _live_shatter()

	if FileAccess.file_exists("user://profile_batch_at_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_at_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	print("test_batch_at: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- §3 the shape ----------

func _tree() -> Array:
	return Talents.generate_tree("arcanist", "mage")


# BATCH FX RE-POINTED THIS SECTION IN PLACE: 91 checks -> 85. The tree an
# Arcanist wears is the ONE class tree, so the shape questions it still answers
# are asked of it.
#   * KEPT, ASKED OF THE ONE TREE (82): its size, 27 single ranks, 27 unique
#     ids, and 27 nodes whose `exclusive_with` names nothing dangling (FX: no
#     node is exclusive, so every one reads empty).
#   * RE-POINTED, 3 -> 3: "lane X holds rows 1-8 plus its capstone" asked that
#     each lane be full. The one tree's bands are its three tiers, so each must
#     hold nine.
#   * DELETED, 6 CHECKS (DG §2 — FX deleted the twelve spec trees and the lanes
#     and capstone shelf with them): the 3 "is a capstone and sits on the
#     shelf", "exactly 3 capstones", "exactly 3 lanes" and "the Control lane is
#     gone" — a lane name, and there are no lanes for it to be absent from.
func _tree_shape() -> void:
	var tree: Array = _tree()
	ok(tree.size() == 27, "the tree an Arcanist wears holds 27 nodes (got %d)" % tree.size())
	var seen := {}
	for n in tree:
		ok(int(n.get("ranks", 1)) == 1, "%s is a single-rank node" % n["id"])
		ok(not seen.has(n["id"]), "%s appears exactly once" % n["id"])
		seen[n["id"]] = true
		# The tree carries no exclusive_with references at all — the ROW did the
		# barring from Batch AI to FX, and FX made no node exclusive — so "valid
		# exclusive references" is the assertion that none has crept back in
		# pointing at a node that does not exist.
		var excl := String(n.get("exclusive_with", ""))
		ok(excl == "" or seen.has(excl) or tree.any(func(m): return String(m["id"]) == excl),
			"%s's exclusive_with names a node that exists" % n["id"])
	# Literals on purpose: a check that reads the constant it checks has stopped
	# asking its question.
	for tier in [1, 2, 3]:
		var held := Talents.tier_nodes(tree, tier).size()
		ok(held == 9, "tier %d holds nine nodes (got %d)" % [tier, held])


# BATCH FX RE-POINTED THIS SECTION IN PLACE: 120 checks -> 53.
#   * INVERTED, 24 -> 26: "X survives (a dropped id voids a saved tree)" was the
#     migration promise. FX deleted all 24 ids and keeps the promise in
#     `Run._migrate_trees`, which swaps a saved tree for the one tree on load and
#     DROPS every pick the one tree does not hold — so a dropped id voids
#     nothing. Each id is asked that, driven on a member saved before FX, and
#     two LIVENESS ARMS prove the drop is a selection rather than a wipe: the
#     saved tree is swapped, and a pick the one tree holds survives the load.
#   * RE-POINTED, 24 -> 27: "is one of the 24 authored ids" — NO NEW IDS — asked
#     that the tree hold nothing but its authored population. That population
#     is the ONE tree's now, node for node, and BM's row-8 carve-out has no row
#     to skip.
#   * DELETED, 72 CHECKS (DG §2 — FX deleted the Arcanist tree): each of the 24
#     ids' row, lane and name. NODES stays as AT's record of what it shipped.
func _node_table() -> void:
	var run: Node = root.get_node("/root/Run")
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var member: Dictionary = run.party[1]
	member["spec"] = "arcanist"
	var retired_ids: Array = []
	for id in RETIRED:
		if String(id).begins_with("ar_"):
			retired_ids.append(id)
	member["tree"] = _retired_tree(retired_ids)
	var saved := {"tn_health": 1}
	for id in NODES:
		saved[id] = 1
	member["talents"] = saved
	run._migrate_trees()
	var kept: Dictionary = run.party[1].get("talents", {})
	ok(run.party[1].get("tree", []) == _tree(),
		"a tree saved before FX is swapped for the one tree on load")
	ok(kept.has("tn_health"),
		"...and a pick the one tree holds SURVIVES that load (the liveness arm)")
	for id in NODES:
		ok(not kept.has(id),
			"%s is DROPPED on load — FX deleted it, so a saved pick on it voids nothing" % id)
	var the_tree := Talents.tree()
	for n in _tree():
		ok(Talents.node_in_tree(the_tree, String(n["id"])) == n,
			"%s is one of the one tree's nodes, unchanged — no new id" % String(n["id"]))


# BATCH FX RE-POINTED THIS SECTION IN PLACE: 103 checks -> 51.
#   * RE-POINTED TO THE PRECEDENT, 5 -> 5: Conversion (ar_conversion) is
#     deleted, and `tn_resource_ward` carries its field AND its magnitude —
#     conversion_ranks 30, the Mana form (FX §3's precedent, TAKEN) — so its
#     three payload questions and its two tooltip questions are asked of the
#     live node, as the precedent rule prefers.
#   * RE-POINTED, 42 -> 42: each other PAYLOADS row asked that the node write
#     its field at the design number (two checks), and Volatility's recoil and
#     On the Edge's payout asked the same of their second fields. The nodes are
#     deleted and the FIELDS stand (FX kept every read site), so each asks that
#     the field is still a real BattleUnit property and that the exact payload
#     the retired node carried — installed inline from RETIRED through the real
#     spawn — lands on the Arcanist at exactly that number over a spawn that
#     learned nothing. PAYLOADS and RETIRED are two transcriptions of one
#     record, so a drift in either reds here.
#   * RE-POINTED, 4 -> 4: the conduit-float trap is asked of the LIVE writer of
#     the curve step (the Resonant Core rune, through `Runes.build`'s int
#     coercion) where it asked the node, and its two name checks stand as they
#     were; Barrage Master is the ABILITY arm of `apply_payload`, driven with its
#     exact payload on a fresh Arcanist kit.
#   * DELETED, 52 CHECKS (DG §2 — FX deleted the nodes, and a payload's form and
#     a tooltip are properties of a node): 14 "is a real magnitude, not a rank-1
#     stand-in" (the payload is this file's own inline record now, so its value
#     could only answer itself) and TOOLTIPS' 38 — "renders N" and "resolved its
#     {v}" for the 19 nodes that are not Conversion. The one tree's nodes carry
#     no `scale` and no `{v}`. TOOLTIPS stays as AT's record.
func _magnitudes() -> void:
	var ward := Talents.node_in_tree(Talents.tree(), "tn_resource_ward")
	var fields: Array = ["volatility_recoil", "on_edge_stacks"]
	var learn := {}
	for id in PAYLOADS:
		if id == "ar_conversion":
			continue
		learn[id] = 1
		fields.append(String(PAYLOADS[id][0]))
	var specs := ["berserker", "arcanist", "inquisitor", "beastmaster"]
	var bare := await _spawn({}, ["raider"], specs)
	var base := _fields_of(_arc(bare), fields)
	bare.queue_free()
	await process_frame
	var worn := await _spawn(learn, ["raider"], specs)
	var got := _fields_of(_arc(worn), fields)
	worn.queue_free()
	await process_frame
	for id in PAYLOADS:
		var field: String = PAYLOADS[id][0]
		if id == "ar_conversion":
			var stat: Dictionary = ward.get("payload", {}).get("stat", {})
			ok(stat.has(field), "%s's precedent, tn_resource_ward, writes %s" % [id, field])
			if stat.has(field):
				ok(abs(float(stat[field]) - float(PAYLOADS[id][1])) < 0.001,
					"...at %s's own %s = %s (got %s)" % [id, field, PAYLOADS[id][1], stat[field]])
			ok(float(stat.get(field, 0)) != 1.0,
				"...a real magnitude, not a rank-1 stand-in (%s)" % field)
			continue
		ok(got.get(field) != null,
			"the field %s the retired %s wrote still stands on BattleUnit (got %s)"
				% [field, id, str(got.get(field))])
		ok(_landed(got, base, field, PAYLOADS[id][1]),
			"the retired %s's payload lands %s = %s on the Arcanist (got %s over a bare %s)"
				% [id, field, PAYLOADS[id][1], str(got.get(field)), str(base.get(field))])
	# Conduit's counter must be a FLOAT and must NOT end in "_ranks", or
	# Runes.STAT_INT_KEYS coerces 0.5 to 0 and the node goes silently inert.
	# BATCH FX RE-POINTED THE FIRST OF THE THREE: the node that wrote
	# conduit_step is deleted, and the writer of the curve step left is the
	# Resonant Core rune's `rune_conduit_step` — so the float is asked of the
	# payload `Runes.build` hands the spawn, which is where the coercion runs.
	var core_built: Dictionary = Runes.build("resonant_core").get("payload", {}).get("stat", {})
	ok(core_built.get("rune_conduit_step", 0) is float,
		"the curve step stays a FLOAT through the rune coercion (rune_conduit_step %s)"
			% str(core_built.get("rune_conduit_step")))
	ok(not "conduit_step".ends_with("_ranks"),
		"conduit_step does not end in _ranks (the AA float-into-int trap)")
	ok(not Runes.STAT_INT_KEYS.has("conduit_step"),
		"conduit_step is not in STAT_INT_KEYS either")
	# Volatility carries TWO magnitudes: the damage add and the recoil SET.
	ok(_landed(got, base, "volatility_recoil", 25),
		"Volatility's retired payload sets Cannon's recoil to 25%% (got %s)"
			% str(got.get("volatility_recoil")))
	# On the Edge carries the threshold AND the payout.
	ok(_landed(got, base, "on_edge_stacks", 4),
		"On the Edge's retired payload pays 4 Resonance (got %s)" % str(got.get("on_edge_stacks")))
	# Barrage Master rides the ability, not a stat.
	# FX: the payload the retired ar_barrister (Barrage Master) carried — the
	# node is deleted, the ability and the arm it rode stand.
	var kit := {"abilities": Classes.spec_abilities("arcanist")}
	var bolts_before := -1
	for ab in kit["abilities"]:
		if ab.display_name == "Arcane Barrage":
			bolts_before = ab.random_hits
	Talents.apply_payload(kit, (RETIRED["ar_barrister"][1] as Dictionary).duplicate(true), 1, {})
	var bolts_after := -1
	for ab in kit["abilities"]:
		if ab.display_name == "Arcane Barrage":
			bolts_after = ab.random_hits
	ok(bolts_before >= 0 and bolts_after == bolts_before + 3,
		"Barrage Master adds 3 bolts to Arcane Barrage (%d -> %d)" % [bolts_before, bolts_after])
	# ...and the tooltip half, asked of Conversion's precedent alone.
	var shown := String(Talents.desc_for(ward, 1))
	ok(shown.contains(TOOLTIPS["ar_conversion"]),
		"ar_conversion's precedent's tooltip renders %s (got %s)" % [TOOLTIPS["ar_conversion"], shown])
	ok(not shown.contains("{v}"), "ar_conversion's precedent's tooltip resolved its {v}")


# BATCH FX — each named field's value on a spawned hero, or null where he has
# none: `get` answers null for a property BattleUnit does not declare.
func _fields_of(u: BattleUnit, fields: Array) -> Dictionary:
	var out := {}
	for f in fields:
		out[f] = u.get(f) if u != null else null
	return out


# BATCH FX — did an inline payload land exactly `want` on top of a bare spawn?
func _landed(got: Dictionary, base: Dictionary, f: String, want) -> bool:
	if got.get(f) == null or base.get(f) == null:
		return false
	return is_equal_approx(float(got[f]) - float(base[f]), float(want))


# ---------- §1 the compounding curve ----------

func _curve_maths() -> void:
	var u := BattleUnit.new()
	u.second_resource_name = "Resonance"
	for n in CURVE:
		u.second_resource = n
		# ROUNDED, not truncated, because that is how the game displays it and
		# how §1's table is written: 0.75 x 78 is 58.5, which the table calls 59.
		var dmg := int(round(u.resonance_dmg_bonus() * 100.0))
		var taken := int(round(u.resonance_taken_bonus() * 100.0))
		ok(dmg == CURVE[n][0],
			"§1 table: %d stacks give +%d%% damage (got +%d%%)" % [n, CURVE[n][0], dmg])
		ok(taken == CURVE[n][1],
			"§1 table: %d stacks give +%d%% taken (got +%d%%)" % [n, CURVE[n][1], taken])
	# COMPOUNDING, NOT LINEAR — the one thing the batch asked to be reported on.
	# A slope has constant differences; a curve's differences grow. Checked as a
	# PROPERTY rather than against four sampled numbers, because four points sit
	# on plenty of wrong functions.
	var prev_step := -1.0
	var last := 0.0
	for n in range(1, 21):
		u.second_resource = n
		var here := u.resonance_dmg_bonus()
		var step := here - last
		ok(step > prev_step + 0.0001,
			"the curve is CONVEX at %d stacks — each stack is worth more than the last" % n)
		prev_step = step
		last = here
	# NEITHER END IS CAPPED. At 40 stacks the curve is still climbing on both
	# sides; a ceiling anywhere would show up here as two equal readings.
	u.second_resource = 39
	var d39 := u.resonance_dmg_bonus()
	var t39 := u.resonance_taken_bonus()
	u.second_resource = 40
	ok(u.resonance_dmg_bonus() > d39, "the damage curve is uncapped at 40 stacks")
	ok(u.resonance_taken_bonus() > t39, "the taken curve is uncapped at 40 stacks")
	# CLAUSE 3 is LINEAR and stays that way — one stable term a player can hold
	# in their head. Its read site is asserted live below; here it is the shape.
	u.second_resource = 10
	var half := u.resonance_curve()
	u.second_resource = 20
	ok(u.resonance_curve() > 3.0 * half,
		"T(2N) grows faster than 2 x T(N) — the curve is not a slope in disguise")
	# Conduit and the Magi's Wrath capstone move the DAMAGE step, nothing else.
	u.second_resource = 12
	var base_taken := u.resonance_taken_bonus()
	u.conduit_step = 0.5
	ok(int(u.resonance_dmg_bonus() * 100.0) == 156,
		"Conduit at 12 stacks: +156%% (2%% x 78, got %d)" % int(u.resonance_dmg_bonus() * 100.0))
	u.conduit_step = 0.0
	# BATCH AU §4: the step-doubling is MAGI'S WRATH'S now, not Singularity's.
	# Same arithmetic, different capstone — the field is what moved.
	u.wrath_step_double = 1
	ok(int(u.resonance_dmg_bonus() * 100.0) == 234,
		"Magi's Wrath at 12 stacks: +234%% (3%% x 78, got %d)" % int(u.resonance_dmg_bonus() * 100.0))
	ok(abs(u.resonance_taken_bonus() - base_taken) < 0.0001,
		"...and neither one touches the damage-TAKEN step")
	u.free()


# ---------- §2 the kit ----------

func _kit() -> void:
	var kit: Array = Classes.spec_abilities("arcanist")
	var names := kit.map(func(a): return a.display_name)
	ok(names.size() == 3, "the opening three is three (got %d)" % names.size())
	ok(names.has("Arcane Cannon") and names.has("Arcane Barrage")
			and names.has("Death Ray"),
		"the opening three is Cannon, Barrage, DEATH RAY (got %s)" % [names])
	ok(not names.has("Stabilize"),
		"STABILIZE IS OUT of the opening three — it is the escape hatch")
	# Death Ray's own numbers, from §2 verbatim.
	for ab in kit:
		if ab.display_name == "Death Ray":
			# BATCH AU §3 raised it 40 -> 55.
			ok(ab.cost == 55, "Death Ray costs 55 Mana (got %d)" % ab.cost)
			ok(abs(ab.delay - 5.0) < 0.001, "Death Ray is 5.0 initiative")
			ok(ab.cooldown == 3, "Death Ray is 3cd (got %d)" % ab.cooldown)
			ok(ab.damage == 150, "Death Ray is 150%% of Attack (got %d)" % ab.damage)
			ok(String(ab.dmg_type) == "arcane", "Death Ray is arcane")
			ok(not ab.aoe and ab.random_hits == 0 and ab.multi_hits == 0,
				"Death Ray is single target")
	# Stabilize is EARNABLE, and exactly one def of it exists — the AK resolver
	# rule. A second copy is how a pool entry drifts from the kit it came from.
	ok(Classes.SPEC_POOLS["arcanist"].has("Stabilize"),
		"Stabilize joins SPEC_POOLS[arcanist] so it can be EARNED")
	var pooled := Classes.pool_ability("Stabilize")
	ok(pooled != null and String(pooled.special) == "stabilize",
		"...and it resolves out of the pool with its machinery intact")
	ok(Classes.trimmed_kit_ability("Stabilize") != null,
		"...from trimmed_kit_ability, which is its ONE def")
	# **DY §3 — re-pointed from `CLASS_POOLS["mage"]` (deleted) to the live
	# class-wide offer.** AH's curation rule is unchanged and Stabilize still
	# fails it: it reads Resonance, which a sibling Mage does not have.
	ok(not Classes.class_draft_pool("mage").has("Stabilize"),
		"...and it is spec-only: it reads Resonance, so AH's curation rule bars it")
	# Every pool entry still resolves (a pool naming an ability nothing defines
	# is an offer that pays nothing).
	for entry in Classes.SPEC_POOLS["arcanist"]:
		ok(Classes.pool_ability(entry) != null,
			"the Arcanist's pool entry %s resolves" % entry)
	# The passive's own text has to describe the passive that shipped.
	var pd := String(Classes.SPEC_INFO["arcanist"]["passive_desc"])
	ok(pd.contains("Runaway Resonance"), "the passive is called Runaway Resonance")
	ok(pd.contains("NO") and pd.contains("MAXIMUM"), "...and it says there is no maximum")
	ok(not pd.contains("max 5"), "...and no longer claims a cap of 5")
	ok(not pd.contains("Backlash Ward"),
		"...and no longer promises Backlash Ward, which is deleted")


# ---------- §2's trap, and §1's read sites, asserted against the SOURCE ----------

func _source_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	# THE SQUARING TRAP. These are the two exact expressions Batch AT removed;
	# either one back in the source multiplies a curve by a slope.
	ok(not src.contains("0.075 + 0.025 * attacker.cannoneer_ranks"),
		"Arcane Cannon carries no per-stack DAMAGE term (the squaring trap)")
	ok(not src.contains("raw *= 1.0 + 0.04 * attacker.second_resource"),
		"Magi's Wrath carries no per-stack DAMAGE term either")
	# ...but the Break terms MUST survive: Break is a different axis.
	ok(src.contains("(5.0 + attacker.cannoneer_ranks)"),
		"Cannon's BD is still 5 x stacks, deepened by Cannoneer")
	ok(src.contains("2.5 * attacker.second_resource"),
		"Wrath's BD is still 2.5 x stacks")
	# ONE implementation of the curve, in unit.gd, delegated to from battle.gd —
	# so the nameplate, the tooltip and the damage path cannot disagree.
	ok(usrc.contains("n * (n + 1.0) * 0.5"),
		"the triangular curve has exactly one implementation")
	ok(src.count("n * (n + 1.0) * 0.5") == 0,
		"...and battle.gd does not carry a second copy")
	ok(src.contains("func _resonance_dmg_mult") and src.contains("func _resonance_taken_mult"),
		"battle.gd reads the curve through two named sites")
	ok(src.count("_resonance_dmg_mult(") == 3,
		"the damage side has exactly its two read sites plus the definition")
	ok(src.count("_resonance_taken_mult(") == 2,
		"the taken side has exactly one read site plus the definition")
	# Overcharge's cap-weighting is gone with the cap.
	ok(not src.contains("_resonance_power"),
		"the Overcharge stack-weighting helper is gone with the ceiling")
	ok(not src.contains("Backlash Ward") and not src.contains("Unlimited Power"),
		"Backlash Ward and Unlimited Power are DELETED, not left unreachable")
	ok(not src.contains("\"unlimited\":"), "...and the Unlimited Power status went with them")
	# The vault pattern: kept, gated, and reachable only from a rune.
	for kept in ["mindfulness_ranks", "arcane_mastery_ranks", "critical_mass_ranks",
			"mana_attune_ranks", "still_mind_ranks"]:
		ok(usrc.contains("var %s" % kept),
			"%s is KEPT rather than silently deleted (the AR vault pattern)" % kept)


# ---------- §4/§5 the runes ----------

func _rune_audit() -> void:
	var arcanist_runes := []
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) == "spec:arcanist":
			arcanist_runes.append(id)
	ok(arcanist_runes.size() == 9,
		# **BATCH FK MOVED IT 4 -> 9** — ET's four retired plus FK's five. The
		# walk reads the FILE, retired included, so this is the file's own
		# population; the assertions below it are the ones about fields.
		"the Arcanist has 9 spec runes (got %d)" % arcanist_runes.size())
	# Every counter a rune writes must be written by a node OR still have a live
	# read site. This is the assertion that caught real breakage in AR and AS.
	# BATCH FX: "noded" is asked of the tree an Arcanist wears — the ONE tree, no
	# node of which writes an Arcanist counter, so every rune field below has to
	# earn its pass on a live read site. The Arcanist's OWN counters, which the
	# Mage-wide runes must not write, are the fields the retired nodes wrote;
	# they are read off RETIRED further down, where this loop used to find them.
	var node_fields := {}
	for n in _tree():
		for f in n.get("payload", {}).get("stat", {}):
			node_fields[String(f)] = true
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for id in arcanist_runes:
		for f in Runes.config(id).get("payload", {}).get("stat", {}):
			var field := String(f)
			if field == "mana_regen_bonus":
				continue
			var noded: bool = node_fields.has(field)
			var live: bool = bsrc.contains(field) or usrc.contains(field)
			ok(noded or live,
				"rune %s writes %s, which is noded or still read" % [id, field])
			ok(usrc.contains("var %s" % field),
				"...and %s is a real BattleUnit field (set() drops a typo silently)" % field)
	# THE RE-POINTS, each one named so a silent revert trips here.
	var core: Dictionary = Runes.config("resonant_core").get("payload", {}).get("stat", {})
	# BATCH EM RE-KEYED THE RUNE SIDE IN PLACE. The charter disconnects runes
	# from the talent trees, so each clause below writes `rune_X` instead of
	# the node's `X` and the read site sums the pair. **NOT ONE MAGNITUDE
	# MOVED** — the question these checks ask is the same one, of the field
	# the rune now owns.
	ok(core.has("rune_conduit_step") and not core.has("conduit_ranks"),
		"the Resonant Core rune was RE-POINTED conduit_ranks -> conduit_step")
	ok(abs(float(core.get("rune_conduit_step", 0.0)) - 0.5) < 0.001,
		"...and pays the node's own 0.5 points of curve step")
	var unquiet: Dictionary = Runes.config("unquiet_mind").get("payload", {}).get("stat", {})
	ok(int(unquiet.get("rune_feedback_ranks", 0)) == 20,
		"the Unquiet Mind rune was RE-POINTED feedback_ranks 2 -> 20 (percentage POINTS)")
	ok(String(Runes.config("unquiet_mind").get("lane", "")) == "Entropy",
		"...and its lane tag followed Control -> Entropy (a dead lane name leaves it homeless)")
	var wide: Dictionary = Runes.config("wide_current").get("payload", {}).get("stat", {})
	ok(wide.has("rune_on_edge_ranks") and not wide.has("on_edge_ranks"),
		"the Wide Current rune keeps its OWN On the Edge term (the AR Cinder Trail pattern)")
	ok(int(wide.get("arcane_mastery_ranks", 0)) == 1
			and int(wide.get("critical_mass_ranks", 0)) == 1,
		"...and its other two clauses are untouched, because their read sites were kept")
	# THE THREE MAGE CLASS-WIDE RUNES TOUCH NO ARCANIST COUNTER — asserted, not
	# assumed, because a collision there would re-tune a rune for every mage.
	# BATCH FX: the Arcanist's counters are the fields his retired nodes wrote
	# (RETIRED), not the one tree's — asked of the one tree, this would find the
	# tree's shared unit-math fields (dmg_bonus, max_hp_pct — `check_em.UNIT_MATH`
	# rules them not talent-keyed) and stop asking about the Arcanist at all.
	var arc_fields := {}
	for rid in RETIRED:
		if String(rid).begins_with("ar_"):
			for f in (RETIRED[rid][1] as Dictionary).get("stat", {}):
				arc_fields[String(f)] = true
	for extra in ["mindfulness_ranks", "arcane_mastery_ranks", "critical_mass_ranks",
			"rune_on_edge_ranks", "on_edge_stacks", "volatility_recoil"]:
		arc_fields[extra] = true
	var mage_runes := 0
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) != "class:mage":
			continue
		mage_runes += 1
		for f in Runes.config(id).get("payload", {}).get("stat", {}):
			ok(not arc_fields.has(String(f)),
				"the Mage-wide rune %s does not write the Arcanist counter %s" % [id, f])
	ok(mage_runes == 3, "there are 3 Mage class-wide runes (got %d)" % mage_runes)


func _claude_md() -> void:
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	# §5: the ar_ward <-> ar_still pair dissolves with the two designs, and the
	# prose is the only place it ever lived (Batch AI retired the test to a
	# bare `pass`). The entry must be GONE, and the other four left alone.
	# The pair must leave the ACTIVE list — read out of the parenthetical the
	# rule names, not the whole file, because the dissolution itself is recorded
	# in prose right after it (the AS pattern: never let an entry quietly vanish).
	# BATCH DG §2 — ASSERTIONS DELETED HERE, AND IT IS A DELIBERATE EXCEPTION TO
	# "NEVER DELETE AN ASSERTION", RECORDED AS ONE. They pinned CLAUDE.md's
	# EXCLUSIVE-PAIR LIST. CW §1 removed that list along with Batch AA's
	# narrative, and THE STRINGS EXIST NOWHERE — not in CLAUDE.md, master.html,
	# the live changelog, or changelog-archive.html, which reaches back to Batch
	# 1, so this is not an archiving gap. The rule they guarded was already dead
	# when CW dropped it: the removed block's own closing sentence records that
	# Batch AI retired `test_runes._exclusives` to a bare `pass`.
	# THE NEVER-DELETE RULE PROTECTS A LIVE QUESTION FROM BEING SILENCED, AND
	# THIS IS NOT ONE. A check asking about a deleted feature cannot pass, cannot
	# fail meaningfully, and cannot be repointed at anything. The live half of
	# the question survives above, asserted off the TREE, where "these two nodes
	# share a lane and sit in different rows" is true and checkable.
	# CARRIED AND NAMED: the assertion below now passes VACUOUSLY — `at` is -1,
	# so `active` is the empty string and every substring is absent from it. It
	# is left standing rather than deleted because DG's sanctioned fall is the
	# six REDS and nothing else, and it is recorded as owed in docs/state.md
	# with its two siblings in `as` and `aw`.
	var at := claude.find("EXCLUSIVE talent pair (")
	var active := claude.substr(at, claude.find(" — cold_snap", at) - at) if at >= 0 else ""
	ok(not active.contains("arcane_ward/still_mind"),
		"the arcane_ward/still_mind pair is gone from the ACTIVE list")


# ---------- live ----------

# BATCH DO added `earned`. Shatter used to arrive from `cr_shatter`'s GRANT;
# a talent may not grant an ability now, so a suite that needs the card on the
# bar has to earn it, exactly as a player does.
func _spawn(learned: Dictionary, lineup: Array, specs: Array, ty := "fight",
		earned: Array = []) -> Node:
	# THE CRIT IS THE THIRD COIN AND ON THIS SPEC IT IS THE WORST ONE: Runaway
	# Resonance adds +1% crit PER STACK, so a "same cast at 0 stacks vs 12"
	# comparison silently compares 10% crit against 22% crit. A build-rate check
	# has the same problem from the other side — a crit builds 2 where a normal
	# hit builds 1. Checks that WANT a crit set `crit_bonus` back themselves.
	var opts := {"enemies": lineup, "node_type": ty,
		"talents": {1: learned.duplicate()}, "deterministic": true, "crit": -10.0}
	if not earned.is_empty():
		opts["bm"] = {1: earned}
	# BATCH FX: every id a check here learns is deleted, so the member's tree is
	# the inline one RETIRED builds — the exact payloads, through the real
	# `apply_from_tree` at the spawn. Learning nothing leaves him the one tree.
	if not learned.is_empty():
		opts["patch"] = {1: {"tree": _retired_tree(learned.keys())}}
	return await Fixture.spawn(self, specs, opts)


func _arc(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.second_resource_name) == "Resonance":
			return h
	return null


func _find(u: BattleUnit, name: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


# BATCH DD §2 — THE SEED, AND WHY THE FLAKE WAS NOT WIDENED AWAY.
# §2's Cannon check reads a RATIO between two blows, and the FIRST line of the
# strike block is `randf_range(0.9, 1.1)` — so each blow carries a +/-10% swing
# and the ratio of two carries up to 22%. The band it asserts is 1.35-1.85
# around a passive that pays 1.54, which is +/-20%: THE NOISE IS THE WIDTH OF THE
# QUESTION. That is why it failed in 2 of 5 dedicated runs while its check count
# never moved, and why a count-diffing rule read `at` 3 -> 4 as a regression.
#
# WIDENING THE BAND WOULD HAVE CHANGED WHAT THE CHECK ASKS. The band exists to
# separate 1.54 (the passive alone) from 2.46 (the passive TIMES the old ability
# term); open it far enough to swallow the variance and it stops telling those
# two apart, which is the whole assertion. Seeding both blows to the same value
# makes them draw the SAME variance, so the only thing left between them is the
# eight stacks — the AK/AL/AR/AV/BS discipline of forcing determinism rather than
# widening the tolerance until the noise fits inside it.
# `n` varies the draw across a LOOP of pairs while keeping each PAIR matched:
# §1's take-damage check sums ten blows a side, and averaging ten different
# variances is what makes its band meaningful. Seeding the whole loop to one
# value would collapse it into the same measurement ten times.
func _seeded(n := 0) -> void:
	seed(20260821 + n)


# §1's curve at the two LIVE read sites — the same numbers the table promises,
# measured through _resolve rather than off the helper.
func _live_curve() -> void:
	var scene := await _spawn({}, ["raider", "raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	ok(arc != null, "the Arcanist spawned holding Resonance")
	if arc == null:
		scene.queue_free()
		return
	ok(arc.second_max >= 99, "his Resonance ceiling is a sentinel, not a cap")
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.armor = 0.0
	foe.resists = {}
	var explosion: Ability = arc.abilities[0]
	# The DAMAGE side: the same cast at 0 stacks and at 12 must differ by the
	# table's +117%. Each hit still carries a +/-10% variance roll, so this SUMS
	# TEN CASTS at each level — one pair of samples has a +/-22% envelope, which
	# is wide enough to pass a wrong curve.
	#
	# **BATCH DY §4 — THE PROJECT'S LAST UNSEEDED FLAKE, SEEDED PER-PAIR.**
	# This loop drew off whatever the startup RNG happened to be: `at` calls
	# `_seeded()` in four places and EVERY ONE OF THEM IS DOWNSTREAM of this
	# check, so the one measurement in the file that most needed determinism
	# was the one running on nothing. It went red at DG on a ratio of 2.40
	# against a ceiling of 2.35 and has read clean in every battery since —
	# twenty consecutive quiet readings, at an observed rate of about one in
	# eighteen, which proves nothing.
	#
	# THE SEED IS PER-PAIR AND NOT PER-LOOP, WHICH IS DD's METHOD AND THE HALF
	# A LATER BATCH COULD UNDO. Both arms of one pair draw the SAME stream, so
	# the ±10% variance roll cancels between them and the only thing left is the
	# stack count; `_i` varies the draw ACROSS the ten pairs, so the sum is
	# still an average of ten different variances rather than one measurement
	# taken ten times. **THE TAKEN LOOP BELOW HAS DONE EXACTLY THIS SINCE DD AND
	# THIS ONE NEVER DID** — the fix is that loop's own two lines, moved up.
	#
	# AND THE BAND IS NOT WIDENED. DD's rule, and the reason is the same here as
	# there: the band IS the question. 2.0-2.35 is what separates the table's
	# 2.17 from a curve that is not compounding, and opening it to swallow a
	# 2.40 would delete the check rather than repair it.
	var at0 := 0
	var at12 := 0
	for _i in 10:
		arc.second_resource = 0
		foe.hp = 999999
		_seeded(_i)
		await scene.call("_resolve", arc, explosion, foe, "good")
		at0 += 999999 - foe.hp
		arc.second_resource = 12
		foe.hp = 999999
		_seeded(_i)
		await scene.call("_resolve", arc, explosion, foe, "good")
		at12 += 999999 - foe.hp
	ok(at0 > 0 and at12 > 0, "both casts landed")
	if at0 > 0:
		var ratio := float(at12) / float(at0)
		ok(ratio > 2.0 and ratio < 2.35,
			"12 stacks roughly DOUBLE his damage (ratio %.2f, table says 2.17)" % ratio)
	# The TAKEN side, measured the same way on the way in.
	var hitter: BattleUnit = scene.get("enemies")[1]
	arc.max_hp = 999999
	arc.armor = 0.0
	arc.resists = {}
	arc.dmg_taken_bonus = 0.0
	var swing: Ability = hitter.abilities[0]
	var took0 := 0
	var took12 := 0
	for _i in 10:
		arc.second_resource = 0
		arc.hp = 999999
		_seeded(_i)
		await scene.call("_resolve", hitter, swing, arc, "good")
		took0 += 999999 - arc.hp
		arc.second_resource = 12
		arc.hp = 999999
		_seeded(_i)
		await scene.call("_resolve", hitter, swing, arc, "good")
		took12 += 999999 - arc.hp
	ok(took0 > 0 and took12 > took0,
		"12 stacks make him take MORE (%d -> %d)" % [took0, took12])
	if took0 > 0:
		var tratio := float(took12) / float(took0)
		ok(tratio > 1.48 and tratio < 1.70,
			"...by roughly the table's +59%% (ratio %.2f)" % tratio)
	# CLAUSE 3, live: +1% crit per stack, LINEAR. Read off the source's own
	# expression rather than sampled, because a crit rate is a coin.
	var csrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(csrc.contains("(0.01 + 0.01 * attacker.arcane_mastery_ranks) \\\n\t\t\t\t\t* attacker.second_resource"),
		"crit is +1% per stack, linear and off the raw stack count")
	scene.queue_free()
	await process_frame


# §2's trap, live: the same Cannon cast at 0 and at 8 stacks must differ by the
# PASSIVE's curve alone. If a per-stack term were still on the ability the gap
# would be the square of it.
func _live_no_per_stack() -> void:
	var scene := await _spawn({}, ["raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.armor = 0.0
	foe.resists = {}
	var cannon := _find(arc, "Arcane Cannon")
	ok(cannon != null, "Arcane Cannon is in the kit")
	if cannon == null:
		scene.queue_free()
		return
	arc.max_resource = 9999
	arc.resource = 9999
	arc.second_resource = 0
	foe.hp = 999999
	_seeded()
	await scene.call("_resolve", arc, cannon, foe, "good")
	var c0 := 999999 - foe.hp
	arc.second_resource = 8
	foe.hp = 999999
	foe.pressure = 0
	_seeded()
	await scene.call("_resolve", arc, cannon, foe, "good")
	var c8 := 999999 - foe.hp
	if c0 > 0:
		var r := float(c8) / float(c0)
		# The passive alone gives 1.54x at 8 stacks. The old ability term would
		# have made it 1.54 x 1.60 = 2.46 — outside this band by a mile.
		ok(r > 1.35 and r < 1.85,
			"Cannon at 8 stacks scales by the PASSIVE alone (%.2fx, not ~2.5x)" % r)
	# ...and its Break damage still rides the stacks.
	ok(foe.pressure >= 40,
		"Cannon still pays BD = 5 x stacks (8 stacks -> %d Break)" % foe.pressure)
	scene.queue_free()
	await process_frame


# §2: Death Ray's gate, and that pressing it costs him nothing but Mana.
func _live_death_ray() -> void:
	var scene := await _spawn({}, ["raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var dray := _find(arc, "Death Ray")
	ok(dray != null, "Death Ray is in the opening three")
	if dray == null:
		scene.queue_free()
		return
	arc.max_resource = 9999
	arc.resource = 9999
	# BATCH AU §3 raised the gate 5 -> 8, so 5 and 7 are DARK where they lit.
	for n in [0, 1, 4, 5, 7]:
		arc.second_resource = n
		ok(not scene.call("_ability_usable", arc, dray),
			"Death Ray is DARK at %d Resonance" % n)
	for n in [8, 9, 20]:
		arc.second_resource = n
		ok(scene.call("_ability_usable", arc, dray),
			"Death Ray LIGHTS at %d Resonance" % n)
	# IT CONSUMES NOTHING — the whole point of "the ramp never comes down". Note
	# what that does NOT mean: Death Ray is a damaging cast, so it still BUILDS
	# one like every other one. The assertion is that the count never FALLS.
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.hp = 999999
	arc.second_resource = 9
	await scene.call("_resolve", arc, dray, foe, "good")
	ok(arc.second_resource >= 9,
		"Death Ray consumed NO stacks (9 -> %d)" % arc.second_resource)
	ok(arc.second_resource == 10,
		"...and, being a damaging cast, it built one like any other")
	ok(foe.hp < 999999, "...and it landed")
	# Terminal Velocity: at 15+ the cooldown never starts.
	var tv := await _spawn({"ar_mindfulness": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc2 := _arc(tv)
	if arc2 != null:
		ok(arc2.terminal_velocity == 15, "Terminal Velocity's threshold is 15")
		var dr2 := _find(arc2, "Death Ray")
		var foe2: BattleUnit = tv.get("enemies")[0]
		foe2.max_hp = 999999
		foe2.hp = 999999
		arc2.max_resource = 9999
		arc2.resource = 9999
		arc2.second_resource = 9
		await tv.call("_resolve", arc2, dr2, foe2, "good")
		ok(arc2.cooldown_left(dr2) > 0, "below 15 stacks Death Ray still cools")
		arc2.cooldowns.erase("Death Ray")
		arc2.second_resource = 16
		await tv.call("_resolve", arc2, dr2, foe2, "good")
		ok(arc2.cooldown_left(dr2) == 0,
			"TERMINAL VELOCITY: at 16 stacks Death Ray has no cooldown")
	tv.queue_free()
	scene.queue_free()
	await process_frame


# §3's Resonance lane: every node that moves the build rate, at its read site.
func _live_build_rate() -> void:
	var scene := await _spawn({"ar_harmonics": 1}, ["raider", "raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.hp = 999999
	var explosion: Ability = arc.abilities[0]
	# Harmonics: the free basic builds 2, not 1. res_cast_this_turn is forced
	# true so Resonant Core cannot be mistaken for this.
	arc.second_resource = 0
	arc.res_cast_this_turn = true
	await scene.call("_resolve", arc, explosion, foe, "good")
	ok(arc.second_resource == 2,
		"HARMONICS: Arcane Explosion builds 2 (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame
	# Cascade: at 10+ stacks every cast builds one extra. Below 10 it does not,
	# which is the half that proves the gate is real.
	var cas := await _spawn({"ar_unlimited": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a2 := _arc(cas)
	if a2 != null:
		var f2: BattleUnit = cas.get("enemies")[0]
		f2.max_hp = 999999
		f2.hp = 999999
		a2.second_resource = 5
		a2.res_cast_this_turn = true
		await cas.call("_resolve", a2, a2.abilities[0], f2, "good")
		ok(a2.second_resource == 6, "Cascade is DARK at 5 stacks (got %d)" % a2.second_resource)
		a2.second_resource = 10
		a2.res_cast_this_turn = true
		await cas.call("_resolve", a2, a2.abilities[0], f2, "good")
		ok(a2.second_resource == 12,
			"CASCADE: at 10 stacks a cast builds 2 (got %d)" % a2.second_resource)
	cas.queue_free()
	await process_frame
	# Resonant Core: the FIRST cast of a turn only. The second must not pay.
	var rc := await _spawn({"ar_core": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a3 := _arc(rc)
	if a3 != null:
		var f3: BattleUnit = rc.get("enemies")[0]
		f3.max_hp = 999999
		f3.hp = 999999
		a3.second_resource = 0
		a3.res_cast_this_turn = false
		await rc.call("_resolve", a3, a3.abilities[0], f3, "good")
		ok(a3.second_resource == 2,
			"RESONANT CORE: the first cast of a turn builds 2 (got %d)" % a3.second_resource)
		await rc.call("_resolve", a3, a3.abilities[0], f3, "good")
		ok(a3.second_resource == 3,
			"...and the second cast of the same turn builds 1 (got %d)" % a3.second_resource)
	rc.queue_free()
	await process_frame


# §3's Entropy lane: danger into fuel, and the capstone that ends it.
func _live_entropy() -> void:
	# Backlash: being hit builds Resonance.
	var scene := await _spawn({"ar_still": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var hitter: BattleUnit = scene.get("enemies")[0]
	arc.max_hp = 999999
	arc.hp = 999999
	arc.second_resource = 0
	await scene.call("_resolve", hitter, hitter.abilities[0], arc, "good")
	ok(arc.second_resource >= 1,
		"BACKLASH: a blow received builds Resonance (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame
	# Event Horizon: at 15+ stacks no single attack can put him down.
	var eh := await _spawn({"ar_ward": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a2 := _arc(eh)
	if a2 != null:
		ok(a2.event_horizon == 15, "Event Horizon's threshold is 15")
		a2.max_hp = 200
		a2.hp = 40
		a2.second_resource = 14
		a2.take_hit(500, 0)
		ok(a2.hp == 0 or a2.dead,
			"below 15 stacks a lethal blow is still lethal (hp %d)" % a2.hp)
		a2.dead = false
		a2.hp = 40
		a2.second_resource = 15
		a2.take_hit(500, 0)
		ok(a2.hp == 1,
			"EVENT HORIZON: at 15 stacks a lethal blow leaves him on 1 (hp %d)" % a2.hp)
	eh.queue_free()
	await process_frame
	# Perfect Conversion: ALL recoil is paid as Mana. Cannon recoils 15%, so a
	# capstone Arcanist takes a full-Mana Cannon and loses no health at all.
	var pc := await _spawn({"ar_timelord": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a3 := _arc(pc)
	if a3 != null:
		ok(a3.perfect_conversion == 1, "Perfect Conversion landed as a capstone")
		var f3: BattleUnit = pc.get("enemies")[0]
		f3.max_hp = 999999
		f3.hp = 999999
		f3.armor = 0.0
		f3.resists = {}
		var cannon := _find(a3, "Arcane Cannon")
		a3.max_resource = 9999
		a3.resource = 9999
		a3.max_hp = 999999
		a3.hp = 999999
		a3.second_resource = 8
		await pc.call("_resolve", a3, cannon, f3, "good")
		ok(a3.hp == 999999,
			"PERFECT CONVERSION: Cannon's recoil cost him NO health (hp %d)" % a3.hp)
		ok(a3.resource < 9999, "...it came out of his Mana instead")
	pc.queue_free()
	await process_frame


# ---------- §8 Shatter ----------

func _live_shatter() -> void:
	var scene := await _spawn({"cr_shatter": 1}, ["raider", "archer", "shaman"],
		["berserker", "cryomancer", "inquisitor", "beastmaster"], "fight", ["Shatter"])
	var cryo: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "permafrost":
			cryo = h
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 999999
		f.hp = 999999
		f.armor = 0.0
		f.resists = {}
	# Freeze one through the normal door, so the whole cascade behaves.
	for _i in 4:
		scene.call("_apply_status", foes[0], "chilled", 3, 0, 0, cryo)
	ok(scene.get("_holds").has(foes[0]), "the first enemy is HELD")
	ok(foes[0].hold_turns == 0, "a fresh prison starts on a charge of 0")
	# THE COUNTER ADVANCES ONCE PER TURN, NOT ONCE PER UNIT PER TURN. This is
	# the clause worth a test: `_hold_sync` walks the ledger, and a nested walk
	# would look identical until two enemies were held at once.
	for _i in 3:
		scene.call("_hold_sync")
	ok(foes[0].hold_turns == 3,
		"three _hold_sync passes charge it 3 turns (got %d)" % foes[0].hold_turns)
	# Now hold a SECOND enemy and prove neither one advances twice per pass.
	cryo.second_prison = 1
	for _i in 4:
		scene.call("_apply_status", foes[1], "chilled", 3, 0, 0, cryo)
	ok(scene.get("_holds").size() == 2, "two prisons stand")
	var was0: int = foes[0].hold_turns
	var was1: int = foes[1].hold_turns
	scene.call("_hold_sync")
	ok(foes[0].hold_turns == was0 + 1 and foes[1].hold_turns == was1 + 1,
		"ONE increment each per pass with TWO held — not one per unit per unit")
	# The chip shows the charge, because a charge the player cannot see is a
	# decision they cannot make.
	# `short` is what the chip actually PRINTS (_refresh_chips renders it into
	# the tag Label); `label` is the tooltip's heading. Asserting the wrong one
	# is how a test proves a chip that says nothing.
	var chip: Dictionary = foes[0].get_status("frozen")
	ok(String(chip.get("short", "")).begins_with("HELD"),
		"the nameplate chip still reads HELD (got %s)" % chip.get("short", ""))
	ok(String(chip.get("short", "")).contains(str(foes[0].hold_turns)),
		"...and it SHOWS THE COUNT (%s)" % chip.get("short", ""))
	ok(String(chip.get("desc", "")).contains("TURNS HELD"),
		"...and its tooltip says what the number buys")
	# THE 12-TURN CAP.
	for _i in 40:
		scene.call("_hold_sync")
	ok(foes[0].hold_turns == 12,
		"the charge CAPS at 12 turns (got %d)" % foes[0].hold_turns)
	# THE SCALING: 10% of Attack per turn held. Set two prisons to different
	# charges and prove the damage follows the charge, not the stacks — both
	# carry 4 stacks of Chilled, so a stack-based reading would tie them.
	ok(foes[0].status_stacks("chilled") == foes[1].status_stacks("chilled"),
		"both prisons carry the SAME Chilled pile — a stack reading would tie")
	foes[0].hold_turns = 10
	foes[1].hold_turns = 2
	foes[0].hp = 999999
	foes[1].hp = 999999
	var shat := _find(cryo, "Shatter")
	ok(shat != null, "Shatter is in the kit")
	if shat != null:
		cryo.max_resource = 9999
		cryo.resource = 9999
		await scene.call("_resolve", cryo, shat, foes[0], "good")
		var d0: int = 999999 - foes[0].hp
		var d1: int = 999999 - foes[1].hp
		ok(d0 > 0 and d1 > 0, "the mass release hit both prisons")
		if d1 > 0:
			var r := float(d0) / float(d1)
			ok(r > 3.5 and r < 7.0,
				"SHATTER SCALES ON TURNS HELD: 10 turns vs 2 is %.2fx (want ~5x)" % r)
		ok(scene.get("_holds").is_empty(), "...and every prison broke")
	# The bot prefers Shatter once the oldest hold has charged 5 turns.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("SHATTER_BOT_TURNS := 5"),
		"the bot's Shatter/Lance crossover is 5 turns held")
	ok(bsrc.find("var shat := _find_ability(u, \"Shatter\")")
			< bsrc.find("if lance_up and not _holds.is_empty():"),
		"...and the Shatter check comes BEFORE the Ice Lance release")
	ok(not bsrc.contains("_ability_usable(u, shat) and _holds.size() >= 2"),
		"...and the two-prison gate that made it never fire is gone")
	scene.queue_free()
	await process_frame
