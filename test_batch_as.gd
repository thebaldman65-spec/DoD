# test_batch_as.gd — the Cryomancer re-authored around GLACIAL HOLD. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_as.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, one node per
#      lane per row, single ranks. (test_batch_ai asserts this generically for
#      all twelve trees; it is repeated here because AS moved TEN ids between
#      lanes and a shape break would otherwise only surface there.)
#   2. ALL 24 IDS — id, row, lane, name. EVERY id survives and re-specs in
#      place, which is the whole migration promise: saved picks resolve and no
#      save version moves. A dropped or renamed id silently voids a saved tree.
#   3. THE MAGNITUDES, ADDITIVE — both halves: the payload the node applies AND
#      the number its tooltip renders. Under the old `1 x step` form a rune
#      writing the same field inherited the node's multiplier, and four
#      Cryomancer spec runes ride these counters.
#   4. §0 — THE INITIATIVE AUDIT. The reschedule has ALWAYS read
#      effective_speed(); the OPENING ROLL had not. Both halves are asserted
#      against the source, because a seed is one random draw and a single
#      sample cannot tell two divisors apart.
#   5. GLACIAL HOLD'S THREE CLAUSES at their read sites, live: the permanence,
#      the indefinite hold with its NAMED releases, and the +15% window. Plus
#      the two rules a player will test first — ALLY DAMAGE DOES NOT RELEASE A
#      HOLD, and a HELD BOSS RELEASES AFTER ONE TURN.
#   6. THE RUNE AUDIT (§5) — every counter the four Cryomancer runes and the
#      three Mage runes ride is either written by a node or still has a live
#      read site. numbing_ranks has no node and is asserted RUNE-ONLY AND
#      LIVE, so "kept, not deleted" is a fact in the test rather than a note
#      in a changelog nobody re-reads.
#   7. §4 — a held enemy is off the turn bar, off the timeline, and wears a
#      HELD marker that names what releases it.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
# BATCH FX RE-POINTED THIS FILE IN PLACE, AND ITS SUBJECT WENT WITH THE TWELVE
# TREES. The Cryomancer wears the ONE class tree now (`generate_tree` answers it
# for every spec with a class), and the 24 nodes the tables below record exist
# nowhere a check can read them. Each section says at its site what moved and
# by exactly how many checks; in short:
#   * the SHAPE questions the one tree still answers (its size, single ranks,
#     no exclusivity, three full tiers) are asked of it; the lane / row /
#     capstone / name / tooltip questions are DELETED under DG §2, because FX
#     deleted their subject;
#   * every MECHANIC this file drives still has its field and its read site, so
#     RETIRED carries the exact payload each retired node carried and `_spawn`
#     installs it inline through the real `apply_from_tree` — not one live
#     assertion moved;
#   * "a lost id voids every saved tree" is asked of FX's load migration, which
#     DROPS a saved pick on a deleted id and keeps one on a live id.
# The tables below stay AS's record of its 24 nodes; RETIRED is FX's record of
# what they carried.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")


var checks := 0
var fails: Array = []

# id -> [row, lane, name]. BATCH_AS.md §3's three tables, transcribed once.
# The ids are the OLD ones by design — §9's mapping lives in the changelog,
# and this is the machine-checkable half of it.
const NODES := {
	"cr_hungering": [1, "Winter", "Hungering Cold"],
	"cr_emp_frostbolt": [2, "Winter", "Deep Chill"],
	"cr_grasp": [3, "Winter", "Winter's Grasp"],
	# BATCH DO renamed all four ability cells. A node named after a live DRAFT
	# CARD is the `wd_spiked`/Spite collision DN documented, so each cell took
	# a name of its own when its card left for the pool.
	"cr_rime": [4, "Winter", "Snowblind"],
	"cr_icy_resolve": [5, "Winter", "Icy Resolve"],
	"cr_whiteout": [6, "Winter", "Whiteout"],
	"cr_splinter": [7, "Winter", "Splintering Shards"],
	"cr_frostbite": [1, "Deep Freeze", "Brittle Ice"],
	"cr_bitter": [2, "Deep Freeze", "Bitter Cold"],
	"cr_frigid": [3, "Deep Freeze", "Frigid Grip"],
	"cr_numbing": [4, "Deep Freeze", "Numbing Cold"],
	"cr_frost_ward": [5, "Deep Freeze", "Second Prison"],
	"cr_cold_snap": [6, "Deep Freeze", "Cold Snap"],
	"cr_glacial": [7, "Deep Freeze", "Glacial Economy"],
	"cr_hypothermia": [1, "Thaw", "Hypothermia"],
	"cr_freezing": [2, "Thaw", "Killing Frost"],
	"cr_crystal": [3, "Thaw", "Crystal Edge"],
	"cr_lance_focus": [4, "Thaw", "Focused Lance"],
	"cr_piercing": [5, "Thaw", "Piercing Ice"],
	"cr_razor_hone": [6, "Thaw", "Honed Shards"],
	# BATCH EL §1 RE-POINTED: the node is SHOCKWAVE now — `Tempo` was freed for
	# the archetype tag. The id and the `shattered_tempo` counter did NOT move.
	"cr_icy_veins": [7, "Thaw", "Shockwave"],
	"cr_eternal": [9, "Winter", "Eternal Winter"],
	"cr_absolute": [9, "Deep Freeze", "Absolute Zero"],
	"cr_shatter": [9, "Thaw", "Shardfall"],
}

# id -> [stat field, the value the PAYLOAD writes]. ADDITIVE units: each is
# the design number in the units its read site sums, never a bare 1 standing
# in for a multiplier.
const PAYLOADS := {
	"cr_hungering": ["hungering_ranks", 3],
	"cr_emp_frostbolt": ["deep_chill_ranks", 1],
	"cr_grasp": ["grasp_ranks", 2],
	# BATCH DO RE-AUTHORED `cr_icy_resolve`. It read "Rime lasts 2 additional
	# turns" — and Rime left the tree for the draft in the same batch, so the
	# whole node became a bet. It modifies BLIZZARD now, which is PROTECTED
	# CORE, through the ability branch rather than through a stat.
	"cr_whiteout": ["whiteout_ranks", 3],
	"cr_splinter": ["splinter_ranks", 1],
	"cr_frostbite": ["frostbite_ranks", 6],
	"cr_bitter": ["bitter_cold_ranks", 2],
	"cr_frigid": ["frigid_ranks", 10],
	"cr_frost_ward": ["second_prison", 1],
	"cr_cold_snap": ["cold_snap_ranks", 15],
	"cr_glacial": ["glacial_ranks", 15],
	"cr_hypothermia": ["hypothermia_ranks", 3],
	"cr_freezing": ["killing_frost", 15],
	"cr_crystal": ["crystal_edge_ranks", 15],
	"cr_piercing": ["piercing_ice_ranks", 30],
	"cr_absolute": ["absolute_zero", 1],
	"cr_eternal": ["eternal_winter", 1],
}

# id -> the number its tooltip must render at one rank. The tooltip is the
# only place several of these design numbers appear in the DATA — every one
# of their read sites lives in battle.gd.
const TOOLTIPS := {
	"cr_hungering": "3", "cr_emp_frostbolt": "2", "cr_grasp": "2",
	"cr_whiteout": "3", "cr_frostbite": "6",
	"cr_bitter": "2", "cr_frigid": "10", "cr_cold_snap": "15",
	"cr_glacial": "15", "cr_hypothermia": "3", "cr_freezing": "30",
	"cr_crystal": "15", "cr_piercing": "30", "cr_razor_hone": "3",
	"cr_icy_veins": "2",
}

# id -> [ability name, cost, delay, cooldown] for the four ability nodes.
const ABILITY_NODES := {
	"cr_rime": ["Rime", 25, 3.0, 3],
	"cr_numbing": ["Glacial Prison", 25, 2.5, 4],
	"cr_lance_focus": ["Cryoclasm", 20, 2.0, 3],
	"cr_shatter": ["Shatter", 30, 4.0, 5],
}


# ── BATCH FX: THE RETIRED PAYLOADS ──────────────────────────────────────────
# FX deleted the twelve spec trees and the 27 Cryomancer nodes with them. EVERY
# FIELD THEY WROTE AND EVERY READ SITE STANDS (dormant: no node writes one), so
# each question this file drove through a node is re-pointed by installing the
# EXACT payload the retired node carried, transcribed here from the tree FX
# deleted. `_retired_tree` builds an inline tree out of it and `_spawn` hands
# that to the real `apply_from_tree`, so a live check learns `cr_freezing`
# exactly as it did before FX; only the source of the payload moved.
# id -> [name, payload]. 27 entries.
const RETIRED := {
	# FX: the payload the retired cr_hungering (Hungering Cold) carried — the node is deleted,
	# the field and its read site stand.
	"cr_hungering": ["Hungering Cold", {"stat": {"hungering_ranks": 3}}],
	# FX: the payload the retired cr_emp_frostbolt (Deep Chill) carried — the node is deleted,
	# the field and its read site stand.
	"cr_emp_frostbolt": ["Deep Chill", {"stat": {"deep_chill_ranks": 1}}],
	# FX: the payload the retired cr_grasp (Winter's Grasp) carried — the node is deleted,
	# the field and its read site stand.
	"cr_grasp": ["Winter's Grasp", {"stat": {"grasp_ranks": 2}}],
	# FX: the payload the retired cr_rime (Snowblind) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_rime": ["Snowblind", {"ability": "Blizzard", "add": {"cost": -10}, "set": {"cooldown": 2}}],
	# FX: the payload the retired cr_icy_resolve (Icy Resolve) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_icy_resolve": ["Icy Resolve", {"ability": "Blizzard", "add": {"damage": 10}}],
	# FX: the payload the retired cr_whiteout (Whiteout) carried — the node is deleted,
	# the field and its read site stand.
	"cr_whiteout": ["Whiteout", {"stat": {"whiteout_ranks": 3}}],
	# FX: the payload the retired cr_splinter (Splintering Shards) carried — the node is deleted,
	# the field and its read site stand.
	"cr_splinter": ["Splintering Shards", {"stat": {"splinter_ranks": 1}}],
	# FX: the payload the retired cr_frostbite (Brittle Ice) carried — the node is deleted,
	# the field and its read site stand.
	"cr_frostbite": ["Brittle Ice", {"stat": {"frostbite_ranks": 6}}],
	# FX: the payload the retired cr_bitter (Bitter Cold) carried — the node is deleted,
	# the field and its read site stand.
	"cr_bitter": ["Bitter Cold", {"stat": {"bitter_cold_ranks": 2}}],
	# FX: the payload the retired cr_frigid (Frigid Grip) carried — the node is deleted,
	# the field and its read site stand.
	"cr_frigid": ["Frigid Grip", {"stat": {"frigid_ranks": 10}}],
	# FX: the payload the retired cr_numbing (Numbing Cold) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_numbing": ["Numbing Cold", {"ability": "Ice Lance", "add": {"cost": -10}, "set": {"cooldown": 1}}],
	# FX: the payload the retired cr_frost_ward (Second Prison) carried — the node is deleted,
	# the field and its read site stand.
	"cr_frost_ward": ["Second Prison", {"stat": {"second_prison": 1}}],
	# FX: the payload the retired cr_cold_snap (Cold Snap) carried — the node is deleted,
	# the field and its read site stand.
	"cr_cold_snap": ["Cold Snap", {"stat": {"cold_snap_ranks": 15}}],
	# FX: the payload the retired cr_glacial (Glacial Economy) carried — the node is deleted,
	# the field and its read site stand.
	"cr_glacial": ["Glacial Economy", {"stat": {"glacial_ranks": 15}}],
	# FX: the payload the retired cr_hypothermia (Hypothermia) carried — the node is deleted,
	# the field and its read site stand.
	"cr_hypothermia": ["Hypothermia", {"stat": {"hypothermia_ranks": 3}}],
	# FX: the payload the retired cr_freezing (Killing Frost) carried — the node is deleted,
	# the field and its read site stand.
	"cr_freezing": ["Killing Frost", {"stat": {"killing_frost": 15}}],
	# FX: the payload the retired cr_crystal (Crystal Edge) carried — the node is deleted,
	# the field and its read site stand.
	"cr_crystal": ["Crystal Edge", {"stat": {"crystal_edge_ranks": 15}}],
	# FX: the payload the retired cr_lance_focus (Focused Lance) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_lance_focus": ["Focused Lance", {"ability": "Ice Lance", "add": {"damage": 15, "pressure": 15}}],
	# FX: the payload the retired cr_piercing (Piercing Ice) carried — the node is deleted,
	# the field and its read site stand.
	"cr_piercing": ["Piercing Ice", {"stat": {"piercing_ice_ranks": 30}}],
	# FX: the payload the retired cr_razor_hone (Honed Shards) carried — the node is deleted,
	# the field and its read site stand.
	"cr_razor_hone": ["Honed Shards", {"stat": {"honed_shards_ranks": 3}}],
	# FX: the payload the retired cr_icy_veins (Shockwave) carried — the node is deleted,
	# the field and its read site stand.
	"cr_icy_veins": ["Shockwave", {"stat": {"shattered_tempo": 2.0}}],
	# FX: the payload the retired cr_winters_depth (Winter's Depth) carried — the node is deleted,
	# the field and its read site stand.
	"cr_winters_depth": ["Winter's Depth", {"stat": {"winters_depth": 8}}],
	# FX: the payload the retired cr_cold_storage (Cold Storage) carried — the node is deleted,
	# the field and its read site stand.
	"cr_cold_storage": ["Cold Storage", {"stat": {"cold_storage": 5}}],
	# FX: the payload the retired cr_frostbound (Frostbound Hours) carried — the node is deleted,
	# the field and its read site stand.
	"cr_frostbound": ["Frostbound Hours", {"stat": {"frostbound_hours": 3}}],
	# FX: the payload the retired cr_shatter (Shardfall) carried — the node is deleted,
	# the ability and the arm it rode stand.
	"cr_shatter": ["Shardfall", {"ability": "Razor Ice", "add": {"multi_hits": 3}, "set": {"cooldown": 1}}],
	# FX: the payload the retired cr_absolute (Absolute Zero) carried — the node is deleted,
	# the field and its read site stand.
	"cr_absolute": ["Absolute Zero", {"stat": {"absolute_zero": 1}}],
	# FX: the payload the retired cr_eternal (Eternal Winter) carried — the node is deleted,
	# the field and its read site stand.
	"cr_eternal": ["Eternal Winter", {"stat": {"eternal_winter": 1}}],
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
	Profile.save_path = "user://profile_batch_as_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	# BATCH FX: awaited now — §3 measures the retired payloads on a live spawn.
	await _magnitudes()
	_ability_nodes()
	_initiative_audit()
	_rune_audit()
	_dissolved_pair()
	await _live_permanence()
	await _live_hold()
	await _live_no_accidental_thaw()
	await _live_window()
	await _live_limit()
	await _live_boss()
	await _live_turn_bar()
	await _live_tree_nodes()
	await _live_releases()

	if FileAccess.file_exists("user://profile_batch_as_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_as_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	print("test_batch_as: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- 1. the shape ----------

func _tree() -> Array:
	return Talents.generate_tree("cryomancer", "mage")


# BATCH FX RE-POINTED THIS SECTION IN PLACE: 88 checks -> 58. The tree a
# Cryomancer wears is the ONE class tree, so the shape questions it still
# answers are asked of it.
#   * KEPT, ASKED OF THE ONE TREE (55): its size, 27 single ranks, 27 nodes
#     carrying no authored exclusive pair (FX: no node is exclusive).
#   * RE-POINTED, 3 -> 3: "lane X holds 8 rows + a capstone" asked that each
#     lane be full. The one tree's bands are its three tiers, so each must hold
#     nine.
#   * DELETED, 30 CHECKS (DG §2 — FX deleted the twelve spec trees and the
#     lanes, rows and capstone shelf with them): "exactly 3 capstones", "exactly
#     3 lanes", the 27 "one node in <lane>:<row>" cells and "SHATTERPOINT is
#     gone" — a lane name, and there are no lanes for it to be absent from.
func _tree_shape() -> void:
	var tree: Array = _tree()
	ok(tree.size() == 27, "the tree a Cryomancer wears holds 27 nodes (got %d)" % tree.size())
	for n in tree:
		ok(int(n.get("ranks", 1)) == 1, "%s is a single rank" % n["id"])
		ok(not n.has("exclusive_with"),
			"%s carries no authored exclusive pair (FX: no node is exclusive)" % n["id"])
	# Literals on purpose: a check that reads the constant it checks has stopped
	# asking its question.
	for tier in [1, 2, 3]:
		var held := Talents.tier_nodes(tree, tier).size()
		ok(held == 9, "tier %d holds nine nodes (got %d)" % [tier, held])


# ---------- 2. what a saved pick on each id does now ----------

# BATCH FX RE-POINTED THIS SECTION IN PLACE: 120 checks -> 53.
#   * INVERTED, 24 -> 26: "id X survives (a lost id voids every saved tree)"
#     was the migration promise. FX deleted all 24 ids and keeps the promise in
#     `Run._migrate_trees`, which swaps a saved tree for the one tree on load and
#     DROPS every pick the one tree does not hold — so a lost id voids nothing.
#     Each id is asked that, driven on a member saved before FX, and two
#     LIVENESS ARMS prove the drop is a selection rather than a wipe: the saved
#     tree is swapped, and a pick the one tree holds survives the same load.
#   * RE-POINTED, 24 -> 27: "no node was ADDED" asked that the tree hold nothing
#     but its authored population. That population is the ONE tree's now, node
#     for node, and BM's row-8 carve-out has no row to skip.
#   * DELETED, 72 CHECKS (DG §2 — FX deleted the Cryomancer tree): each of the
#     24 ids' row, lane and name. NODES stays as AS's record of what it shipped.
func _node_table() -> void:
	var run: Node = root.get_node("/root/Run")
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var member: Dictionary = run.party[1]
	member["spec"] = "cryomancer"
	member["tree"] = _retired_tree(RETIRED.keys())
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
			"id %s is DROPPED on load — FX deleted it, so a saved pick on it voids nothing" % id)
	var the_tree := Talents.tree()
	for n in _tree():
		ok(Talents.node_in_tree(the_tree, String(n["id"])) == n,
			"no node was ADDED: %s is one of the one tree's nodes, unchanged" % String(n["id"]))


# ---------- 3. additive magnitudes, as they land on the hero ----------

# BATCH FX RE-POINTED THIS SECTION IN PLACE: 50 checks -> 19.
#   * RE-POINTED, 19 -> 19: each PAYLOADS row, and the two counters PAYLOADS
#     does not carry (Shockwave's float 2.0 and Honed Shards' 3), asked that the
#     node's payload write its field at the design number, in the units the read
#     site sums. The node is deleted and the FIELD stands (FX kept every read
#     site), so each row installs the exact payload the retired node carried —
#     inline, from RETIRED, through the real spawn — and asks that it lands on
#     the Cryomancer at exactly that number over a spawn that learned nothing.
#     PAYLOADS and RETIRED are two transcriptions of one record, so a drift in
#     either reds here, and so does a dormant field the spawn stopped writing.
#   * DELETED, 31 CHECKS (DG §2 — a tooltip is a property of a node, and FX
#     deleted the nodes; the one tree's nodes carry no `scale` and no `{v}`):
#     TOOLTIPS' 30 — "renders N" and "resolved its placeholder" for 15 nodes —
#     and "Splintering Shards is certain, not a roll", which read the deleted
#     cr_splinter's desc. TOOLTIPS stays as AS's record.
func _magnitudes() -> void:
	var fields: Array = ["shattered_tempo", "honed_shards_ranks"]
	var learn := {"cr_icy_veins": 1, "cr_razor_hone": 1}
	for id in PAYLOADS:
		learn[id] = 1
		fields.append(String(PAYLOADS[id][0]))
	var bare := await _spawn({}, ["raider", "raider"])
	var base := _fields_of(_cryo(bare), fields)
	bare.queue_free()
	await process_frame
	var worn := await _spawn(learn, ["raider", "raider"])
	var got := _fields_of(_cryo(worn), fields)
	worn.queue_free()
	await process_frame
	for id in PAYLOADS:
		var want: Array = PAYLOADS[id]
		var f := String(want[0])
		ok(_landed(got, base, f, want[1]),
			"the retired %s's payload lands %s = %d on the Cryomancer (got %s over a bare %s)"
				% [id, f, want[1], str(got.get(f)), str(base.get(f))])
	# The two counters PAYLOADS does not carry, and the first is the float.
	ok(_landed(got, base, "shattered_tempo", 2.0),
		"Shockwave's retired payload lands 2.0 of initiative push (got %s)"
			% str(got.get("shattered_tempo")))
	ok(_landed(got, base, "honed_shards_ranks", 3),
		"Honed Shards' retired payload lands 3 stacks (got %s)"
			% str(got.get("honed_shards_ranks")))


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


# ---------- the four ability nodes ----------

func _ability_nodes() -> void:
	# BATCH DO — THE NODES STOPPED GRANTING AND THE CARDS DID NOT STOP EXISTING,
	# SO THIS SECTION ASKS THE SAME FOUR QUESTIONS OF THE DRAFT POOL. Every
	# number below is the number the node's payload used to carry — they were
	# lifted VERBATIM into `Classes.draft_ability`, so a drift between the two
	# would show up here as a changed cost, initiative or cooldown.
	# BATCH FX RE-POINTED THE GATE, NOT THE QUESTIONS (28 -> 28). Each row opened
	# on the deleted tree and skipped when the id was missing — which, with the
	# tree gone, would have skipped all 24 silently. The questions are about the
	# CARD, which stands, so they are asked of it directly; the one that read the
	# node ("grants NOTHING") is asked of the tree a Cryomancer wears: owning
	# every cell of it still leaves him without the card.
	var wearer := {"key": "mage", "spec": "cryomancer", "tree": _tree(),
		"talents": {}, "bm_abilities": []}
	for n in wearer["tree"]:
		wearer["talents"][String(n["id"])] = 1
	var worn_names: Array = Talents.ability_names(wearer)
	for id in ABILITY_NODES:
		var want: Array = ABILITY_NODES[id]
		ok(not worn_names.has(String(want[0])),
			"%s's card, %s, is granted by NO node of the tree he wears — a talent may not (DO's charter)"
				% [id, want[0]])
		var ab: Ability = Classes.spec_pool_ability("cryomancer", String(want[0]))
		ok(ab != null, "%s's card, %s, is drafted now" % [id, want[0]])
		if ab == null:
			continue
		ok(Classes.spec_draft_pool("cryomancer").has(String(want[0])),
			"%s is in the Cryomancer's draft pool" % want[0])
		ok(ab.cost == want[1], "%s costs %d (got %d)" % [want[0], want[1], ab.cost])
		ok(abs(ab.delay - want[2]) < 0.001,
			"%s costs %.1f initiative (got %.1f)" % [want[0], want[2], ab.delay])
		ok(ab.cooldown == want[3],
			"%s cools down in %d (got %d)" % [want[0], want[3], ab.cooldown])
	# The two NEW abilities carry their specials; nothing else claims them.
	var gp: Ability = Classes.spec_pool_ability("cryomancer", "Glacial Prison")
	ok(gp != null and gp.special == "glacial_prison",
		"Glacial Prison carries its special")
	var cc: Ability = Classes.spec_pool_ability("cryomancer", "Cryoclasm")
	ok(cc != null and cc.special == "cryoclasm", "Cryoclasm carries its special")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# RE-POINTED 1 -> 3 AT BATCH DF, AND THE QUESTION IS THE SAME QUESTION. What
	# this refuses is a SECOND COPY of a handler that could drift from the first.
	# DA §2 put Glacial Prison into `RECAST_GATED` and said so in writing —
	# "three edits and no fourth" — so the name now appears in three DIFFERENT
	# tables rather than twice in one: `_recast_targets`' living-enemies pool,
	# `_recast_writes`' proposal (the one member whose handler guards its own
	# write), and the effect handler itself. A FOURTH still fails, which is what
	# the check is for. Cryoclasm did not join the gate and is still 1 below.
	ok(src.count('"glacial_prison":') == 3,
		"exactly three glacial_prison arms — targets, writes, handler (DA §2)")
	ok(src.count('"cryoclasm":') == 1, "exactly one cryoclasm handler")


# ---------- 4. §0: the initiative audit ----------

func _initiative_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# THE HOLE, CLOSED. The opening roll seeds off effective speed now.
	ok(src.contains("u.next_time = (100.0 / maxf(u.effective_speed(), 0.1))"),
		"§0: the opening initiative roll seeds off effective_speed()")
	ok(not src.contains("(100.0 / u.speed)"),
		"§0: nothing seeds the timeline off the RAW speed stat any more")
	# THE FINDING, PINNED. Every line in battle.gd that advances a unit's
	# place on the timeline divides by effective_speed() — that was already
	# true before Batch AS, and it is the reason Chilled has always slowed.
	# Asserted against the source because a scheduler cannot be driven
	# headlessly and a single seed is one random draw.
	var bad := 0
	var seeds := 0
	for line in src.split("\n"):
		if not ("next_time" in line and "/" in line):
			continue
		if "//" in line:
			continue
		seeds += 1
		if not ("effective_speed()" in line):
			bad += 1
	ok(seeds >= 8, "found the timeline arithmetic to audit (%d lines)" % seeds)
	ok(bad == 0, "§0: every next_time divisor is effective_speed() (%d are not)" % bad)
	# Frigid Grip is the node §0 exists for, so its arithmetic is pinned too:
	# PER STACK, and floored so a deep pile can never produce a zero divisor.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(usrc.contains("maxf(0.5 - frigid_bonus * chill, 0.1)"),
		"Frigid Grip slows PER STACK, floored")
	# A bare BattleUnit has no nameplate, so the status list is built by hand
	# rather than through add_status (which refreshes chips that do not exist).
	var u := BattleUnit.new()
	u.speed = 100.0
	ok(abs(u.effective_speed() - 100.0) < 0.01, "an unchilled unit runs at its speed")
	u.statuses.append({"id": "chilled", "stacks": 1, "turns": -1})
	ok(abs(u.effective_speed() - 75.0) < 0.01, "one stack of Chilled is -25%")
	u.frigid_bonus = 0.10
	ok(abs(u.effective_speed() - 65.0) < 0.01, "...-35% with Frigid Grip")
	u.statuses[0]["stacks"] = 2
	ok(abs(u.effective_speed() - 30.0) < 0.01,
		"two stacks is -50%, and Frigid Grip's 10 points ride EACH of them")
	u.statuses[0]["stacks"] = 3
	ok(abs(u.effective_speed() - 20.0) < 0.01, "...and three is -80%")
	u.free()


# ---------- 6. the rune audit ----------

func _rune_audit() -> void:
	var pool := {}
	for id in Runes.ids():
		pool[id] = Runes.config(id)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var cryo := []
	var mage := []
	for id in pool:
		var r: Dictionary = pool[id]
		if String(r.get("scope", "")) == "spec:cryomancer":
			cryo.append(id)
		elif String(r.get("scope", "")) == "class:mage":
			mage.append(id)
	# **BATCH FK MOVED IT 4 -> 9.** The four are ET's retired ones and FK
	# authored five more; this walks `runes.json`, retired included, so the count
	# is the FILE's population and not the offerable one. **The claim was never
	# the number** — it is that every Cryomancer-scoped rune writes a field that
	# is LIVE on `BattleUnit`, which the loop below asserts one by one — so the
	# count is here to catch a set going MISSING, and it is re-pointed rather
	# than deleted for that reason.
	ok(cryo.size() == 9, "nine Cryomancer spec runes (got %d)" % cryo.size())
	ok(mage.size() == 3, "three Mage class-wide runes (got %d)" % mage.size())
	# Every lane tag must name a lane that EXISTS — the Honed Lance was tagged
	# Shatterpoint, which stopped being a lane.
	# BATCH FX — 3 CHECKS DELETED HERE (DG §2): "the rune X is tagged with a live
	# lane", for bitter_grip (Deep Freeze), honed_lance (Thaw) and killing_cold
	# (Winter). FX deleted every talent lane with the twelve trees, so no rune's
	# `lane` tag can name a live one: the tags are history (EM's own word for
	# them), all three runes are retired, and none of the Cryomancer's five live
	# runes carries a lane at all. There is no lane left to ask the question of.
	# The re-pointed magnitudes, in the units their read sites now sum.
	# BATCH EM RE-KEYED THE RUNE SIDE IN PLACE. The charter disconnects runes
	# from the talent trees, so each clause below writes `rune_X` instead of
	# the node's `X` and the read site sums the pair. **NOT ONE MAGNITUDE
	# MOVED** — the question these checks ask is the same one, of the field
	# the rune now owns.
	ok(int(pool["bitter_grip"]["payload"]["stat"]["rune_frigid_ranks"]) == 3,
		"the Bitter Grip pays its advertised 3 points of Frigid Grip")
	ok(int(pool["bitter_grip"]["payload"]["stat"]["rune_frostbite_ranks"]) == 2,
		"...and its advertised 2 points of Brittle Ice")
	ok(int(pool["long_winter"]["payload"]["stat"]["rune_frigid_ranks"]) == 3,
		"the Long Winter pays 3 points of Frigid Grip")
	ok(int(pool["long_winter"]["payload"]["stat"]["rune_crystal_edge_ranks"]) == 5,
		"...and 5 points of Crystal Edge")
	ok(int(pool["long_winter"]["payload"]["stat"]["rune_hungering_ranks"]) == 1,
		"...and 1 point of Hungering Cold, which did not move")
	ok(int(pool["killing_cold"]["payload"]["stat"]["numbing_ranks"]) == 5,
		"the Killing Cold pays its advertised 5 points of Numbing Veil")
	ok(int(pool["killing_cold"]["payload"]["stat"]["rune_hypothermia_ranks"]) == 2,
		"...and 2 points of Hypothermia, which did not move")
	# NUMBING VEIL HAS NO NODE AND THE READ SITE IS KEPT. That is §5's rule
	# made a fact: a rune whose node is gone is flagged for re-authoring, not
	# silently deleted. If a later batch re-nodes it, this check comes down.
	# BATCH FX: "no node writes it" is asked of the tree a Cryomancer wears — the
	# ONE tree. The Cryomancer's OWN counters (the fields the Mage-wide runes must
	# not write, below) are the fields his retired nodes wrote, read off RETIRED:
	# asked of the one tree instead, that question would find the tree's shared
	# unit-math fields (dmg_bonus, max_hp_pct — `check_em.UNIT_MATH` rules them
	# not talent-keyed) and would stop asking about the Cryomancer at all.
	var node_fields := []
	for n in _tree():
		for f in n["payload"].get("stat", {}):
			node_fields.append(String(f))
	var cryo_fields := []
	for rid in RETIRED:
		for f in (RETIRED[rid][1] as Dictionary).get("stat", {}):
			cryo_fields.append(String(f))
	ok(not node_fields.has("numbing_ranks"),
		"no node writes numbing_ranks any more (Glacial Prison took the id)")
	ok(bsrc.contains('chance += 0.01 * _max_hero_rank("numbing_ranks")'),
		"...and its read site is KEPT and LIVE, in the units the rune writes")
	# Every counter a Cryomancer rune writes must still be read SOMEWHERE.
	for id in cryo:
		for f in pool[id].get("payload", {}).get("stat", {}):
			if String(f) == "healing_received_mult":
				continue  # a generic unit field, not a talent counter
			ok(bsrc.contains(String(f)) or f == "frigid_ranks",
				"the counter %s (rune %s) still has a read site" % [f, id])
	# No Mage class-wide rune touches a Cryomancer counter — asserted so a
	# future re-tune of one cannot silently re-tune the other.
	for id in mage:
		for f in pool[id].get("payload", {}).get("stat", {}):
			ok(not cryo_fields.has(String(f)),
				"the Mage rune %s does not write a Cryomancer counter (%s)" % [id, f])


# ---------- §6: the dissolved pair ----------

func _dissolved_pair() -> void:
	# cold_snap <-> bitter_cold was an authored exclusive pair. Both sat in
	# the SAME lane (Deep Freeze rows 6 and 2), so a player could hold both
	# and a rune writing either counter was legal.
	# BATCH FX — 2 CHECKS DELETED HERE (DG §2): "cold_snap and bitter_cold share a
	# lane" and "...and different rows". FX deleted both nodes and the lanes and
	# rows with them. The live half of "nothing is exclusive" is asked of the one
	# tree in §1 (no node carries an `exclusive_with`), and both counters stand
	# dormant with their read sites (cold_snap_ranks and bitter_cold_ranks, §3).
	# The sentence in the DG block below that points "above" at the pair is
	# therefore history: what it pointed at is the check FX deleted here.
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
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
	# CARRIED AND NAMED: the assertion below now passes VACUOUSLY — the pair is
	# absent because the WHOLE LIST is. It is left standing rather than deleted
	# because DG's sanctioned fall is the six REDS and nothing else, and it is
	# recorded as owed in docs/state.md with its two siblings in `at` and `aw`.
	ok(not claude.contains("(heat_haze/scorched, cold_snap/"),
		"CLAUDE.md's exclusive-pair LIST no longer names the dissolved pair")


# ---------- live ----------

# BATCH DO added `earned`: the four Cryomancer cards are drafted now, so a
# suite that needs one on the bar earns it exactly as a player does.
func _spawn(learned: Dictionary, lineup: Array, ty := "fight",
		earned: Array = []) -> Node:
	var opts := {"enemies": lineup, "node_type": ty,
		"talents": {1: learned.duplicate()}, "deterministic": true}
	if not earned.is_empty():
		opts["bm"] = {1: earned}
	# BATCH FX: every id a check here learns is deleted, so the member's tree is
	# the inline one RETIRED builds — the exact payloads, through the real
	# `apply_from_tree` at the spawn. Learning nothing leaves him the one tree.
	if not learned.is_empty():
		opts["patch"] = {1: {"tree": _retired_tree(learned.keys())}}
	return await Fixture.spawn(self,
		["berserker", "cryomancer", "inquisitor", "beastmaster"], opts)


func _cryo(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "permafrost":
			return h
	return null


# Put `n` stacks of Chilled on a foe THROUGH THE NORMAL DOOR, so Rime, Frigid
# Grip and the freeze cascade all behave exactly as they do in play.
func _chill(scene: Node, foe: BattleUnit, src: BattleUnit, n: int) -> void:
	for _i in n:
		scene.call("_apply_status", foe, "chilled", 3, 0, 0, src)


# Clause 1 — PERMAFROST: his stacks never expire.
func _live_permanence() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	var cryo := _cryo(scene)
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	_chill(scene, foe, cryo, 1)
	ok(int(foe.get_status("chilled").get("turns", 0)) < 0,
		"CLAUSE 1: a stack the Cryomancer applies never expires")
	# An enemy-applied chill keeps its clock — the permanence is HIS.
	var hero: BattleUnit = scene.get("heroes")[0]
	scene.call("_apply_status", hero, "chilled", 3, 0, 0, foe)
	ok(int(hero.get_status("chilled").get("turns", 0)) == 3,
		"...but an enemy's chill still runs on a 3-turn clock")
	scene.queue_free()
	await process_frame


# Clause 2 — THE HOLD.
func _live_hold() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	var before := foe.next_time
	_chill(scene, foe, cryo, 4)
	ok(foe.has_status("frozen"), "four stacks freeze the victim")
	ok(scene.call("_is_held", foe), "CLAUSE 2: and the freeze is a HOLD")
	ok(int(foe.get_status("frozen").get("turns", 0)) < 0,
		"the hold is INDEFINITE — it carries no clock at all")
	ok(is_inf(foe.next_time),
		"a held enemy leaves the timeline entirely (was %.1f)" % before)
	ok(foe.status_stacks("chilled") == 4,
		"the pile stays maxed while he holds it (got %d)" % foe.status_stacks("chilled"))
	# TIME DOES NOT THAW IT. Ticking its statuses the way a lost turn would is
	# the closest thing to "waiting it out" the engine has.
	for _i in 12:
		foe.tick_statuses()
	ok(foe.has_status("frozen"), "twelve ticks later it is STILL held — time does nothing")
	# The named release.
	scene.call("_hold_release", foe, "the test")
	ok(not foe.has_status("frozen"), "the named release thaws it")
	ok(not scene.call("_is_held", foe), "...and clears the ledger")
	ok(foe.status_stacks("chilled") == 1,
		"a released enemy comes back on 1 stack, so the engine stays warm")
	ok(not is_inf(foe.next_time), "...and rejoins the timeline")
	scene.queue_free()
	await process_frame


# The rule a player will test first, and the one the spec dies without.
func _live_no_accidental_thaw() -> void:
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	_chill(scene, foe, cryo, 4)
	ok(scene.call("_is_held", foe), "the target is held")
	# ALLY DAMAGE DOES NOT RELEASE A HOLD.
	var ally: BattleUnit = scene.get("heroes")[0]
	await scene.call("_resolve", ally, ally.abilities[0], foe, "good", true)
	ok(scene.call("_is_held", foe) or foe.dead,
		"ALLY DAMAGE DOES NOT RELEASE A HOLD")
	ok(foe.dead or foe.has_status("frozen"), "...the ice is still on it")
	# HIS OWN AoE DOES NOT RELEASE IT EITHER — the reason Blizzard's
	# description says so, and the reason the release is named.
	if not foe.dead:
		var bliz: Ability = null
		for ab in cryo.abilities:
			if ab.display_name == "Blizzard":
				bliz = ab
		ok(bliz != null, "the Cryomancer holds Blizzard")
		if bliz != null:
			await scene.call("_resolve", cryo, bliz, foes[1], "good", true)
			ok(scene.call("_is_held", foe) or foe.dead,
				"HIS OWN BLIZZARD DOES NOT THAW A HOLD")
	# NOR DOES AN ENEMY CLEANSING RITE: a battle-long freeze reads as 999
	# turns remaining, so the rite's longest-first pick would take the hold
	# every single time.
	if not foe.dead:
		var cleansable: Array = scene.call("_cleansable_debuffs", foe)
		var has_freeze := false
		for s in cleansable:
			if String(s.get("id", "")) == "frozen":
				has_freeze = true
		ok(not has_freeze, "a Cleansing Rite cannot reach a hold")
	scene.queue_free()
	await process_frame


# Clause 3 — THE WINDOW.
func _live_window() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	ok(abs(float(scene.call("_hold_window_mult")) - 1.15) < 0.001,
		"CLAUSE 3: a held enemy takes +15% damage from all sources")
	scene.queue_free()
	await process_frame
	var kf := await _spawn({"cr_freezing": 1}, ["raider", "raider"])
	ok(abs(float(kf.call("_hold_window_mult")) - 1.30) < 0.001,
		"Killing Frost lifts the window to +30%")
	kf.queue_free()
	await process_frame


# The limit, and what happens when he freezes past it.
func _live_limit() -> void:
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	ok(int(scene.call("_hold_limit")) == 1, "he holds ONE enemy by default")
	var foes: Array = scene.get("enemies")
	_chill(scene, foes[0], cryo, 4)
	_chill(scene, foes[1], cryo, 4)
	ok(not scene.call("_is_held", foes[0]),
		"freezing past the limit releases the OLDEST hold")
	ok(scene.call("_is_held", foes[1]), "...and the newest one holds")
	ok(foes[0].status_stacks("chilled") == 1,
		"the evicted enemy comes back on 1 stack like any other release")
	scene.queue_free()
	await process_frame
	# Second Prison, then Absolute Zero.
	var two := await _spawn({"cr_frost_ward": 1}, ["raider", "raider", "raider"])
	ok(int(two.call("_hold_limit")) == 2, "Second Prison holds TWO")
	var c2 := _cryo(two)
	var f2: Array = two.get("enemies")
	if c2 != null:
		_chill(two, f2[0], c2, 4)
		_chill(two, f2[1], c2, 4)
		ok(two.call("_is_held", f2[0]) and two.call("_is_held", f2[1]),
			"...and both prisons stand at once")
	two.queue_free()
	await process_frame
	var az := await _spawn({"cr_absolute": 1}, ["raider", "raider", "raider"])
	ok(int(az.call("_hold_limit")) >= 3,
		"Absolute Zero puts NO limit on how many he holds")
	az.queue_free()
	await process_frame


# The boss carve-out: they resist until Broken, and a held boss releases on
# its own after one turn. A boss removed from the fight indefinitely is not a
# control fantasy, it is a softlock.
func _live_boss() -> void:
	var scene := await _spawn({}, ["withered_warden", "raider"], "boss")
	var cryo := _cryo(scene)
	var boss: BattleUnit = null
	for e in scene.get("enemies"):
		if e.is_boss:
			boss = e
	ok(boss != null, "the boss spawned")
	if cryo == null or boss == null:
		scene.queue_free()
		return
	_chill(scene, boss, cryo, 4)
	ok(not boss.has_status("frozen"),
		"a boss resists the freeze until Broken — the carve-out it already had")
	ok(not scene.call("_is_held", boss), "...so it is never held")
	boss.broken = true
	_chill(scene, boss, cryo, 1)
	ok(boss.has_status("frozen"), "a BROKEN boss can be frozen")
	ok(scene.call("_is_held", boss), "...and it is held")
	ok(int(boss.get_status("frozen").get("turns", 0)) == 1,
		"A HELD BOSS CARRIES ONE TURN OF ICE, not an indefinite hold")
	ok(not is_inf(boss.next_time),
		"...and it keeps its place on the timeline, so the turn can be spent")
	# ...WHICH IS WHY THE TURN BAR'S _is_held FILTER IS LOAD-BEARING, and why
	# this assertion lives here rather than in _live_turn_bar. An ordinary
	# hold leaves the bar because its next_time is INF; a held BOSS does not
	# get that, so only the filter keeps it off. A negative control that
	# stripped the filter passed cleanly against a raider and is caught here.
	scene.call("_rebuild_turn_bar")
	await process_frame
	var boss_slots := 0
	for slot in scene.get("turn_bar").get_children():
		if slot.get_child(0).tooltip_text.begins_with(boss.unit_name):
			boss_slots += 1
	ok(boss_slots == 0,
		"§4: a held BOSS is off the turn bar too (%d slots left)" % boss_slots)
	# Spend it the way the turn loop does, then let the ledger true up.
	boss.tick_statuses()
	scene.call("_hold_sync")
	ok(not boss.has_status("frozen"), "A HELD BOSS RELEASES AFTER ONE TURN")
	ok(not scene.call("_is_held", boss), "...and leaves the ledger with it")
	scene.queue_free()
	await process_frame


# §4 — the turn bar. The single most legible thing in the batch.
func _live_turn_bar() -> void:
	# DISTINCT enemy kinds on purpose: the bar's tooltip is the unit NAME, so
	# three raiders would be three identical tooltips and "the held one is
	# gone" would be unprovable. This check failed exactly that way first.
	var scene := await _spawn({}, ["raider", "archer", "shaman"])
	var cryo := _cryo(scene)
	if cryo == null:
		scene.queue_free()
		return
	var foe: BattleUnit = null
	for e in scene.get("enemies"):
		if e.unit_name.contains("Archer"):
			foe = e
	ok(foe != null, "the archer spawned")
	if foe == null:
		scene.queue_free()
		return
	var bar: Node = scene.get("turn_bar")
	# A FRAME BETWEEN EACH REBUILD AND ITS COUNT. _rebuild_turn_bar opens by
	# queue_free()ing its old slots, and queue_free is DEFERRED — so counting
	# immediately after sees BOTH bars at once. That artefact read as "the
	# held enemy is still in the bar" on this check's first run, and it is a
	# harness bug that looks exactly like a product one.
	scene.call("_rebuild_turn_bar")
	await process_frame
	var before := bar.get_child_count()
	ok(before > 0, "the turn bar draws slots at all (%d)" % before)
	var seen_before := 0
	for slot in bar.get_children():
		if slot.get_child(0).tooltip_text.begins_with(foe.unit_name):
			seen_before += 1
	ok(seen_before > 0, "the enemy has slots in the bar before it is held")
	_chill(scene, foe, cryo, 4)
	scene.call("_rebuild_turn_bar")
	await process_frame
	var seen_after := 0
	for slot in bar.get_children():
		if slot.get_child(0).tooltip_text.begins_with(foe.unit_name):
			seen_after += 1
	ok(seen_after == 0,
		"§4: A HELD ENEMY IS REMOVED FROM THE TURN BAR ENTIRELY (%d slots left)" % seen_after)
	# ...and its nameplate says so, in words that name every door out.
	var st := foe.get_status("frozen")
	ok(String(st.get("label", "")) == "HELD", "the nameplate marker reads HELD")
	var tip := String(st.get("desc", ""))
	ok(tip.contains("Ice Lance") and tip.contains("Shatter"),
		"...and the tooltip names what releases it")
	ok(tip.contains("Ally damage"), "...and what does NOT")
	scene.queue_free()
	await process_frame


# The nodes whose whole existence is a battle-time read site.
func _live_tree_nodes() -> void:
	# Deep Chill: Frostbolt lays two stacks, not one.
	var dc := await _spawn({"cr_emp_frostbolt": 1}, ["raider", "raider"])
	var c1 := _cryo(dc)
	if c1 != null:
		var foe: BattleUnit = dc.get("enemies")[0]
		await dc.call("_resolve", c1, c1.abilities[0], foe, "good", true)
		ok(foe.status_stacks("chilled") == 2 or foe.dead,
			"Deep Chill: Frostbolt applies 2 stacks (got %d)" % foe.status_stacks("chilled"))
	dc.queue_free()
	await process_frame
	# Splintering Shards: Razor Ice ALWAYS strikes a fourth time, which is a
	# freeze out of a single cast.
	var sp := await _spawn({"cr_splinter": 1}, ["raider", "raider"])
	var c2 := _cryo(sp)
	if c2 != null:
		var razor: Ability = null
		for ab in c2.abilities:
			if ab.display_name == "Razor Ice":
				razor = ab
		var foe2: BattleUnit = sp.get("enemies")[0]
		if razor != null:
			await sp.call("_resolve", c2, razor, foe2, "good", true)
			ok(sp.call("_is_held", foe2) or foe2.dead,
				"Splintering Shards: ONE Razor Ice is a freeze")
	sp.queue_free()
	await process_frame
	# Whiteout: Blizzard lays a flat 3 on everything.
	var wo := await _spawn({"cr_whiteout": 1}, ["raider", "raider"])
	var c3 := _cryo(wo)
	if c3 != null:
		var bliz: Ability = null
		for ab in c3.abilities:
			if ab.display_name == "Blizzard":
				bliz = ab
		var wfoes: Array = wo.get("enemies")
		if bliz != null:
			await wo.call("_resolve", c3, bliz, wfoes[0], "good", true)
			var least := 4
			for f in wfoes:
				if not f.dead:
					least = mini(least, f.status_stacks("chilled"))
			ok(least >= 3, "Whiteout: every enemy takes 3 stacks (lowest was %d)" % least)
	wo.queue_free()
	await process_frame
	# Cold Snap: the hold is not idle time — it converts into the party's
	# Break, 15 a turn.
	var cs := await _spawn({"cr_cold_snap": 1}, ["raider", "raider"])
	var c4 := _cryo(cs)
	if c4 != null:
		var foe4: BattleUnit = cs.get("enemies")[0]
		_chill(cs, foe4, c4, 4)
		var pr_before := foe4.pressure
		foe4.take_hit(0, c4.cold_snap_ranks)
		ok(foe4.pressure > pr_before,
			"Cold Snap: a held enemy's Break meter fills while it waits")
		ok(c4.cold_snap_ranks == 15, "...by 15 (got %d)" % c4.cold_snap_ranks)
	cs.queue_free()
	await process_frame
	# Glacial Economy pays 15% of maximum Mana per freeze.
	var ge := await _spawn({"cr_glacial": 1}, ["raider", "raider"])
	var c5 := _cryo(ge)
	if c5 != null:
		c5.resource = 0
		var foe5: BattleUnit = ge.get("enemies")[0]
		_chill(ge, foe5, c5, 4)
		var want := int(round(c5.max_resource * 0.15))
		ok(c5.resource == want,
			"Glacial Economy returns 15%% of max Mana (%d, wanted %d)" % [c5.resource, want])
	ge.queue_free()
	await process_frame
	# Bitter Cold rolls two stacks across every OTHER enemy.
	var bc := await _spawn({"cr_bitter": 1}, ["raider", "raider", "raider"])
	var c6 := _cryo(bc)
	if c6 != null:
		var bfoes: Array = bc.get("enemies")
		_chill(bc, bfoes[0], c6, 4)
		ok(bfoes[1].status_stacks("chilled") == 2 and bfoes[2].status_stacks("chilled") == 2,
			"Bitter Cold: the freeze lays 2 stacks on every other enemy")
	bc.queue_free()
	await process_frame


# The releases, and the two nodes that ride them.
func _live_releases() -> void:
	# Ice Lance IS the release.
	var il := await _spawn({}, ["raider", "raider"])
	var c1 := _cryo(il)
	if c1 != null:
		var foe: BattleUnit = il.get("enemies")[0]
		foe.max_hp = 9999
		foe.hp = 9999
		_chill(il, foe, c1, 4)
		var lance: Ability = null
		for ab in c1.abilities:
			if ab.display_name == "Ice Lance":
				lance = ab
		ok(lance != null, "the Cryomancer holds Ice Lance")
		if lance != null:
			await il.call("_resolve", c1, lance, foe, "good", true)
			ok(not il.call("_is_held", foe), "ICE LANCE IS THE RELEASE")
			ok(foe.status_stacks("chilled") == 1, "...and the enemy comes back on 1 stack")
	il.queue_free()
	await process_frame
	# Honed Shards rides the RELEASE now, not the crit — and because it lives
	# in _hold_release, every release inherits it.
	var hs := await _spawn({"cr_razor_hone": 1}, ["raider", "raider"])
	var c2 := _cryo(hs)
	if c2 != null:
		var foe2: BattleUnit = hs.get("enemies")[0]
		foe2.max_hp = 9999
		foe2.hp = 9999
		_chill(hs, foe2, c2, 4)
		hs.call("_hold_release", foe2, "the test")
		ok(foe2.status_stacks("chilled") == 4,
			"Honed Shards: 1 + 3 fresh stacks (got %d)" % foe2.status_stacks("chilled"))
		# RE-POINTED IN PLACE, AND IT IS AN INVERSION (Batch BN §1). This line
		# asserted "...which is four again, so the release re-holds it on the
		# spot" — the behaviour AS shipped and the near half of a crash. The
		# release re-freezing its own target, plus a freeze past the limit
		# evicting and releasing another, is a deterministic two-body cycle that
		# ran to the stack limit (23 events per 400 budget-12 battles, BF §3).
		# BN's `_releasing` guard refuses a freeze while a release resolves, so
		# THE STACKS STILL LAND AND THE FREEZE DOES NOT. The check is kept
		# rather than deleted because "does the release re-hold" is still the
		# question worth asking; only the correct answer moved.
		ok(not hs.call("_is_held", foe2),
			"...and BN's guard stops those four re-freezing it on the spot")
	hs.queue_free()
	await process_frame
	# Shockwave (EL §1: was Shattered Tempo) pays the release out in TIME.
	var st := await _spawn({"cr_icy_veins": 1}, ["raider", "raider", "raider"])
	var c3 := _cryo(st)
	if c3 != null:
		var sfoes: Array = st.get("enemies")
		_chill(st, sfoes[0], c3, 4)
		var other_before: float = sfoes[1].next_time
		st.call("_hold_release", sfoes[0], "the test")
		ok(sfoes[1].next_time > other_before,
			"Shockwave: releasing pushes every OTHER enemy back")
		var pushed: float = sfoes[1].next_time - other_before
		var want: float = 2.0 * 100.0 / maxf(sfoes[1].effective_speed(), 0.1)
		ok(abs(pushed - want) < 0.01,
			"...by 2.0 on the timeline, through the delay_push arithmetic")
	st.queue_free()
	await process_frame
	# Cryoclasm MOVES a hold without spending it — no release payoff fires.
	var cc := await _spawn({"cr_lance_focus": 1, "cr_icy_veins": 1},
		["raider", "raider", "raider"], "fight", ["Cryoclasm"])
	var c4 := _cryo(cc)
	if c4 != null:
		var cfoes: Array = cc.get("enemies")
		_chill(cc, cfoes[0], c4, 4)
		var clasp: Ability = null
		for ab in c4.abilities:
			if ab.display_name == "Cryoclasm":
				clasp = ab
		ok(clasp != null, "Cryoclasm is in the kit")
		var untouched: float = cfoes[2].next_time
		if clasp != null:
			await cc.call("_resolve", c4, clasp, cfoes[1], "good", true)
			ok(not cc.call("_is_held", cfoes[0]), "Cryoclasm empties the old prison")
			ok(cc.call("_is_held", cfoes[1]), "...and the hold lands on the new target")
			ok(cfoes[1].status_stacks("chilled") == 4, "...carrying its stacks with it")
			ok(abs(cfoes[2].next_time - untouched) < 0.01,
				"A MOVE IS NOT A RELEASE: Shockwave does not fire")
	cc.queue_free()
	await process_frame
	# Shatter is the MASS release, paid on the pile each prison carried.
	var sh := await _spawn({"cr_shatter": 1, "cr_absolute": 1},
		["raider", "raider", "raider"], "fight", ["Shatter"])
	var c5 := _cryo(sh)
	if c5 != null:
		var hfoes: Array = sh.get("enemies")
		for f in hfoes:
			f.max_hp = 9999
			f.hp = 9999
			_chill(sh, f, c5, 4)
		ok(sh.get("_holds").size() == 3, "Absolute Zero lets all three be held at once")
		var shat: Ability = null
		for ab in c5.abilities:
			if ab.display_name == "Shatter":
				shat = ab
		ok(shat != null, "Shatter is in the kit")
		if shat != null:
			ok(sh.call("_ability_usable", c5, shat), "Shatter lights with a hold to break")
			await sh.call("_resolve", c5, shat, hfoes[0], "good", true)
			ok(sh.get("_holds").is_empty(), "SHATTER RELEASES EVERY HOLD AT ONCE")
			for f in hfoes:
				ok(f.hp < 9999, "...and every held enemy took the blast")
	sh.queue_free()
	await process_frame
	# ...and it does NOT light with nothing held.
	var dry := await _spawn({"cr_shatter": 1}, ["raider", "raider"])
	var c6 := _cryo(dry)
	if c6 != null:
		for ab in c6.abilities:
			if ab.display_name == "Shatter":
				ok(not dry.call("_ability_usable", c6, ab),
					"Shatter is dark with no prison to break")
	dry.queue_free()
	await process_frame
