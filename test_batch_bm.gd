# test_batch_bm.gd — TALENTS BECOME META PROGRESSION. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bm.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite spawns no battle scene, so it needs neither --fixed-fps
# 12 (BL's trick) nor a parked process_frame.
#
# WHAT IT DRIVES. BM made talents a PERMANENT LEDGER — points banked per zone
# boss, cells bought between runs, a global difficulty tier, a free respec, and
# nothing in a run paying a point. The ONE distinction BM wrote this suite to
# protect was BUYING A CELL UNLOCKS AN OPTION, IT DOES NOT EQUIP IT, and BATCH
# FX RETIRED IT WITH ITS PREMISE (CLAUDE.md: "A CELL BOUGHT IS A CELL WORN"):
# the one class tree has no rows and no node in it is exclusive, so there is
# nothing to choose between and no equip step. The checks that guarded it are
# INVERTED below rather than deleted — buying IS wearing, and a refund or a
# respec un-wears — because a purchase that silently stopped being worn would
# still produce a working hero, which is exactly the class of fault this suite
# exists to see.
#
# FX ALSO KEYED THE LEDGER TO THE CLASS (Profile v3) AND GAVE A TIER A SECOND
# GATE. The per-spec loops over twelve purses are per-CLASS loops over four; a
# zone boss pays each class ONCE however many of its specs played; and every
# purchase is checked against BOTH gates — the difficulty gate (`TIERS_OPEN`)
# and the spend gate (`TIER_SPEND_MIN` cells of the tier below) — and against
# `Talents.can_buy`'s reasons. `TIER_SPEND_MIN` is the designer's candidate:
# every expectation below is written RELATIVE to it and none pins its value.
#
# Six of the checks below would fail SILENTLY without being written down — a
# purchase that stops being worn still produces a working hero, points that
# transfer between classes still spend, a tier unlock that lands on one class
# still unlocks something, an elite still awards SOMETHING, and a node that is
# an earlier node with a bigger number is still a node. Each is built as broken
# state and the checker is proven to reject it.
#
# THE PROFILE IS REDIRECTED TO A SCRATCH FILE (`Profile.save_path` is a var
# for exactly this), the real one is never opened, and the redirect is put back
# on the way out. `Run` is an AUTOLOAD and does NOT resolve in a --script
# SceneTree, so every check here reads Talents, Profile and Classes — the three
# statics — and the Run-side rules (the end boss slot, the difficulty ladder,
# the deleted award sites) are asserted against the SOURCE, which is where a
# rule with no reachable gate can be checked at all.
extends SceneTree

const SCRATCH := "user://test_bm_profile.json"
# What `Profile.save_path` is put back to on the way out — its own default.
const REAL_PROFILE := "user://profile.json"

var checks := 0
var fails: Array = []
var sections := 0
# The four ledger keys (Profile v3 is keyed to the CLASS), read off
# `Classes.SPEC_IDS` rather than listed, so a fifth class is walked for free.
var class_keys: Array = []


func _check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		fails.append(label)


func _fresh() -> void:
	Profile.save_path = SCRATCH
	Profile.data = {}
	Profile.loaded = false
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))
	Profile.respec("warrior")  # forces a load + save against the scratch file


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


func _initialize() -> void:
	for cls in Classes.SPEC_IDS:
		class_keys.append(String(cls))
	_fresh()
	_structure()
	_earning()
	_spending()
	_gating()
	_persistence()
	_end_boss_and_ladder()
	_award_sites_deleted()
	_negative_controls()
	print("\n=== BATCH BM ===")
	print("sections: %d   checks: %d   failures: %d" % [sections, checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))
	# The redirect goes back where it was. Nothing below touches Profile and the
	# process quits next; it is put back so that no suite is ever the one that
	# leaves a scratch path standing for whatever runs after it.
	Profile.save_path = REAL_PROFILE
	Profile.loaded = false
	Profile.data = {}
	quit()


# ---------- §9 STRUCTURE — THE ONE TREE (re-cut at BATCH FX) ----------
#
# BM asserted the shape of TWELVE trees: 8 rows x 3 lanes plus a capstone row,
# 27 cells a spec, one node in every row x lane cell, capstones on row 9 and
# nowhere else, and no row-8 node re-writing its own lane. FX replaced them with
# ONE tree of twenty-seven in three flat tiers of nine, bought per CLASS. Every
# question that still has a subject is asked of the one tree; the two that do
# not are recorded where they stood.

func _structure() -> void:
	# The tree's depth and width: BM's ROWS 8 and LANES 3 are TIERS and
	# NODES_PER_TIER now.
	_check(Talents.TIERS == 3, "three tiers")
	_check(Talents.NODES_PER_TIER == 9, "nine nodes a tier")
	# BATCH FX — DG §2, 1 CHECK REMOVED HERE: "the capstone shelf is row 9"
	# (`CAPSTONE_ROW == 9`) asked where the twelve trees kept their capstones.
	# FX deleted the trees and the constant, and the one tree has no capstone
	# and no shelf above the others, so the question has no subject.
	_check(Talents.TREE.size() == 27, "27 cells per class — the one tree")
	_check(Talents.full_tree_cost() == 54, "54 points fills the tree")
	var tree: Array = Talents.tree()
	var want_ids: Array = []
	for t in tree:
		want_ids.append(String(t["id"]))
	# EVERY SPEC READS THE ONE TREE. `generate_tree` still takes the SPEC,
	# because that is what every caller holds, and answers with its class's
	# tree — which is the same twenty-seven for every class.
	for spec in Classes.all_specs():
		var st: Array = Talents.generate_tree(String(spec), "")
		_check(st.size() == 27, "%s has 27 nodes" % spec)
		var got_ids: Array = []
		for t in st:
			got_ids.append(String(t["id"]))
		_check(got_ids == want_ids, "%s reads the one tree, id for id" % spec)
	# EVERY NODE, ONCE: a unique id, a real tier, worn at one rank, flat, and
	# one stat payload. (BM walked these per spec, over 324 nodes; there are 27.)
	var all_ids := {}
	for t in tree:
		var id := String(t["id"])
		_check(not all_ids.has(id), "id %s is unique in the tree" % id)
		all_ids[id] = true
		var tier := int(t.get("tier", 0))
		_check(tier >= 1 and tier <= Talents.TIERS,
			"%s sits in a tier 1-%d (reads %d)" % [id, Talents.TIERS, tier])
		_check(int(Talents.worn_learned(tree, {id: true}).get(id, 0)) == 1,
			"%s is worn at one rank" % id)
		_check(not t.has("lane") and not t.has("row") and not t.has("capstone"),
			"%s is flat — no lane, no row, no capstone" % id)
		var pay: Dictionary = t.get("payload", {})
		_check(pay.keys() == ["stat"] and not (pay.get("stat", {}) as Dictionary).is_empty(),
			"%s pays one stat block — no condition, no `also`, no ability edit, no grant" % id)
	for tier_n in range(1, Talents.TIERS + 1):
		_check(Talents.tier_nodes(tree, tier_n).size() == Talents.NODES_PER_TIER,
			"tier %d holds %d nodes" % [tier_n, Talents.NODES_PER_TIER])
	_check(all_ids.size() == 27, "27 distinct node ids in the one tree")
	# NO NODE RE-WRITES A FIELD AN EARLIER NODE ALREADY WRITES. BM's row-8 rule
	# asked this of a row-8 node against rows 1-7 of its own LANE — and the
	# instrument is the PAYLOAD's stat fields, because a node that writes a
	# field an earlier node already writes is, by construction, that node with
	# a different number. FX retired the lanes and kept the property (CLAUDE.md,
	# the row-8 block: no two nodes write one field), so the same instrument
	# runs over the whole tree: every node against every node authored before
	# it, one check per field, which asks every pair exactly once.
	for i in tree.size():
		var mine: Array = (tree[i].get("payload", {}).get("stat", {}) as Dictionary).keys()
		for j in i:
			for f in (tree[j].get("payload", {}).get("stat", {}) as Dictionary):
				_check(not mine.has(f), "%s does not re-write %s's %s" % [
					tree[i]["id"], tree[j]["id"], f])
	# tier costs and their gate come from ONE place and agree.
	# BATCH FX — DG §2, 9 CHECKS REMOVED HERE: "row N sits at tier ceil(N/3)",
	# one per row 1-9, asked `tier_of_row` how BM banded ROWS into tiers. FX
	# deleted the rows and the function, and a node carries its tier itself
	# (asserted per node above), so there is no row left to band. The PRICE
	# half of the same loop is live and is asked per tier, just below.
	for tier_c in range(1, Talents.TIERS + 1):
		_check(Talents.cell_cost(tier_c) == tier_c, "a tier-%d cell costs %d" % [tier_c, tier_c])
	_check(Talents.tiers_open(0) == 0, "a fresh profile opens no tiers")
	_check(Talents.tiers_open(1) == 1, "difficulty 1 opens tier 1")
	_check(Talents.tiers_open(2) == 2, "difficulty 2 opens tier 2")
	_check(Talents.tiers_open(3) == 3, "difficulty 3 opens tier 3")
	sections += 1


# ---------- §9 EARNING — per CLASS since BATCH FX ----------

func _earning() -> void:
	_fresh()
	# TWO WARRIORS AND NO HUNTER, on purpose. `award_zone_boss_points` takes the
	# party's SPECS and pays each spec's CLASS once: a real party never fields
	# two specs of one class, a test can, and that is the case that tells "per
	# class" from "per spec". The absent Hunter is the class that did not play.
	var party := ["berserker", "warden", "cryomancer", "inquisitor"]
	Profile.award_zone_boss_points(party)
	for cls in class_keys:
		var played := false
		for spec in party:
			if Classes.class_of_spec(String(spec)) == cls:
				played = true
		var note := ""
		if cls == "warrior":
			note = " — ONCE, with two of its specs in the party"
		elif not played:
			note = " — it did not play"
		_check(Profile.talent_points_earned(cls) == (1 if played else 0),
			"%s banks %d for a zone boss%s" % [cls, 1 if played else 0, note])
	# THE PURSE IS THE CLASS's. A spec key is not a ledger key any more.
	_check(Profile.talent_points_earned("berserker") == 0,
		"a SPEC key banks nothing — the purse belongs to the class")
	# A ZONE-2 WIPE HAS ALREADY BANKED 2 — partial credit is the mechanism.
	Profile.award_zone_boss_points(party)
	_check(Profile.talent_points_earned("warrior") == 2,
		"two zone bosses bank 2 (a zone-2 wipe keeps them)")
	# A completed run is three: 3 points per class per run, so 18 completions
	# fills the tree at 54.
	Profile.award_zone_boss_points(party)
	_check(Profile.talent_points_earned("warrior") == 3,
		"a completed run banks 3 per class")
	_check(Talents.full_tree_cost() / 3 == 18,
		"18 completions per class fills the tree")
	# An empty spec string banks nothing (an un-awakened hero).
	Profile.award_zone_boss_points(["", ""])
	_check(Profile.talent_points_earned("") == 0, "an un-awakened hero banks nothing")
	# THE END BOSS BANKS NONE — asserted against the source, because it is a
	# rule about what _resolve_boss does NOT call.
	var bs := _src("res://scripts/battle.gd")
	var idx := bs.find("func _resolve_boss")
	# **BATCH EG — THE WINDOW IS THE FUNCTION NOW, NOT 2400 CHARACTERS, AND THIS
	# IS ED §2's RULE MET IN THE WILD.** A scan that captures a WINDOW is blind
	# to what the window swallowed: EG added a comment block inside
	# `_resolve_boss` explaining why the slot is granted before the award, and
	# that pushed `# The end boss.` from character 2130 to 2955 — past the
	# window, so the anchor stopped resolving.
	#
	# **EE §4'S GUARD IS WHAT SAID SO, AND IT IS EXACTLY THE CASE IT WAS WRITTEN
	# FOR.** Without the `half_at >= 0` check below, `end_half` would have been
	# EMPTY, the negative assertion would have held for every needle, and the
	# alternation under it would have been satisfied by its `body` sibling —
	# **both checks green while neither read anything.**
	#
	# The slice runs to the NEXT top-level `func ` instead, which is the
	# function itself and cannot be outgrown by anything written inside it. It
	# falls back to the old window only if that search fails, so a malformed
	# file degrades to the previous behaviour rather than to an empty slice.
	var body_end := bs.find("\nfunc ", idx + 1)
	var body := bs.substr(idx, (body_end - idx) if body_end > idx else 2400)
	# GUARDED (BATCH EE §4). `# The end boss.` IS A COMMENT — ED's fragile
	# residency class — and an unasserted -1 makes `end_half` EMPTY. The
	# negative below then holds for every needle, and the alternation under it
	# is satisfied by its `body` sibling, so BOTH checks stay green while
	# neither reads anything. ED swept 87 slices for exactly this and this one
	# sat inside the sweep.
	var half_at := body.find("# The end boss.")
	_check(half_at >= 0, "the end-boss comment anchor resolves, so the slice is real")
	var end_half := body.substr(half_at)
	_check(not end_half.contains("bank_zone_boss_points"),
		"the end boss banks no talent points")
	_check(end_half.contains("Relics.unlock_random") or body.contains("Relics.unlock_random"),
		"the end boss awards a relic")
	sections += 1


# ---------- §9 SPENDING ----------

func _spending() -> void:
	_fresh()
	var spec := "berserker"
	var cls := Classes.class_of_spec(spec)
	var tree: Array = Talents.tree()
	var t1: Array = Talents.tier_nodes(tree, 1)
	var t2: Array = Talents.tier_nodes(tree, 2)
	var t3: Array = Talents.tier_nodes(tree, 3)
	var need: int = Talents.TIER_SPEND_MIN
	# BM banked 20. What is banked is written relative to the spend minimum, so
	# the cheapest legal road to tier 3 — `need` cells at 1, `need` at 2 and one
	# at 3 — and the re-spends below fit at ANY value the designer sets (1-9).
	var bank := maxi(20, 3 * need + 8)
	# A LOCKED TIER REJECTS A PURCHASE even with points in hand.
	for i in bank:
		Profile.award_zone_boss_points([spec])
	_check(Profile.talent_points_earned(cls) == bank,
		"%d banked to the %s purse" % [bank, cls])
	_check(not Profile.buy_cell(cls, String(t1[0]["id"])),
		"difficulty 0: even tier 1 refuses")
	var why0 := String(Talents.can_buy(tree, String(t1[0]["id"]), {}, bank, 0)["why"])
	_check(why0.begins_with("Locked") and why0.ends_with("difficulty 1"),
		"…and can_buy names the clear that opens it (got \"%s\")" % why0)
	Profile.note_end_boss(1)
	var avail := Profile.talent_points_available(cls)
	_check(Profile.buy_cell(cls, String(t1[0]["id"])), "tier 1 buys at difficulty 1")
	_check(avail - Profile.talent_points_available(cls) == 1, "a tier-1 cell costs 1")
	_check(not Profile.buy_cell(cls, String(t2[0]["id"])), "tier 2 refuses at difficulty 1")
	var why1 := String(Talents.can_buy(tree, String(t2[0]["id"]), Profile.talent_cells(cls),
		Profile.talent_points_available(cls), Profile.talent_tier())["why"])
	_check(why1.begins_with("Locked") and why1.ends_with("difficulty 2"),
		"…LOCKED behind the difficulty-2 clear (got \"%s\")" % why1)
	# THE SPEND GATE (FX) — a tier opens only once TIER_SPEND_MIN cells of the
	# tier below are owned. Asked of CONSTRUCTED ledgers at the top difficulty,
	# so the difficulty gate is out of the way and only the spend gate can
	# answer, and it holds at any spend minimum: one cell short refuses and
	# names the shortfall; the minimum opens.
	for tier in [2, 3]:
		var below: Array = Talents.tier_nodes(tree, tier - 1)
		var ledger := {}
		if tier == 3:
			for t in t1.slice(0, need):
				ledger[String(t["id"])] = true
		for t in below.slice(0, need - 1):
			ledger[String(t["id"])] = true
		var target := String(Talents.tier_nodes(tree, tier)[0]["id"])
		var one_short := Talents.can_buy(tree, target, ledger, 99, Talents.MAX_TIER)
		var why_s := String(one_short["why"])
		_check(not bool(one_short["ok"]) and why_s.begins_with("Locked")
				and why_s.contains("1 more") and why_s.contains("tier %d" % (tier - 1)),
			"tier %d refuses one cell short of TIER_SPEND_MIN in tier %d, and says so (got \"%s\")"
				% [tier, tier - 1, why_s])
		ledger[String(below[need - 1]["id"])] = true
		_check(bool(Talents.can_buy(tree, target, ledger, 99, Talents.MAX_TIER)["ok"]),
			"…and TIER_SPEND_MIN tier-%d cells open tier %d" % [tier - 1, tier])
	# Now through the real door. Difficulty 2 opens tier 2's difficulty gate;
	# its spend gate opens once tier 1 holds `need` cells.
	Profile.note_end_boss(2)
	var k := 1
	while Talents.bought_in_tier(tree, Profile.talent_cells(cls), 1) < need and k < t1.size():
		Profile.buy_cell(cls, String(t1[k]["id"]))
		k += 1
	avail = Profile.talent_points_available(cls)
	_check(Profile.buy_cell(cls, String(t2[0]["id"])),
		"tier 2 buys at difficulty 2 once TIER_SPEND_MIN tier-1 cells are owned")
	_check(avail - Profile.talent_points_available(cls) == 2, "a tier-2 cell costs 2")
	_check(not Profile.buy_cell(cls, String(t3[0]["id"])), "tier 3 refuses at difficulty 2")
	var why2 := String(Talents.can_buy(tree, String(t3[0]["id"]), Profile.talent_cells(cls),
		Profile.talent_points_available(cls), Profile.talent_tier())["why"])
	_check(why2.begins_with("Locked") and why2.ends_with("difficulty 3"),
		"…LOCKED behind the difficulty-3 clear (got \"%s\")" % why2)
	Profile.note_end_boss(3)
	var m := 1
	while Talents.bought_in_tier(tree, Profile.talent_cells(cls), 2) < need and m < t2.size():
		Profile.buy_cell(cls, String(t2[m]["id"]))
		m += 1
	avail = Profile.talent_points_available(cls)
	_check(Profile.buy_cell(cls, String(t3[0]["id"])), "tier 3 buys at difficulty 3")
	_check(avail - Profile.talent_points_available(cls) == 3, "a tier-3 cell costs 3")
	# A TIER ARRIVES FULLY OPEN — all nine tier-2 cells at once, the moment
	# both of its gates are met.
	var at_min := {}
	for t in t1.slice(0, need):
		at_min[String(t["id"])] = true
	var ok_all := true
	for t in t2:
		if not bool(Talents.can_buy(tree, String(t["id"]), at_min, 99, 2)["ok"]):
			ok_all = false
	_check(ok_all, "difficulty 2 and TIER_SPEND_MIN tier-1 cells open all nine tier-2 cells at once")
	# BUYING IS WEARING — INVERTED AT BATCH FX. This block was "BUYING A CELL
	# DOES NOT EQUIP IT — the load-bearing one": a bought cell was an OPTION,
	# `Profile.equip_cell` put one node per row on the hero, and equipping a
	# sibling replaced it. FX retired that with its premise (no rows, nothing
	# exclusive — CLAUDE.md, "A CELL BOUGHT IS A CELL WORN"), so each check here
	# asks the new rule where the old one was asked. What a run wears is
	# `Profile.worn_talents(class)`, the set the handoff copies onto a member.
	var a := String(t1[0]["id"])
	_check(Profile.owns_cell(cls, a), "the cell is owned")
	_check(Profile.worn_talents(cls).has(a), "BUYING IS WEARING — the bought cell is worn at once")
	var worn_ids: Array = Profile.worn_talents(cls).keys()
	var owned_ids: Array = Profile.talent_cells(cls).keys()
	worn_ids.sort()
	owned_ids.sort()
	_check(worn_ids == owned_ids,
		"what a run wears is EXACTLY what the class owns — there is no equip step between them")
	_check(int(Profile.worn_talents(cls).get(a, 0)) == 1,
		"a worn cell is worn at one rank — the {id: 1} set every read site speaks")
	_check(Profile.talent_points_available(cls) == bank - (need * 1 + need * 2 + 3),
		"wearing costs nothing — the purse pays for the cells owned and nothing else")
	# NOTHING IS EXCLUSIVE: two cells of one tier are BOTH worn.
	var b := String(t1[1]["id"])
	if not Profile.owns_cell(cls, b):
		Profile.buy_cell(cls, b)
	var worn := Profile.worn_talents(cls)
	_check(worn.has(a) and worn.has(b),
		"two cells of one tier are BOTH worn — no node is exclusive, so nothing replaces anything")
	# AN UNOWNED CELL IS NOT WORN.
	_check(not Profile.worn_talents(cls).has(String(t3[1]["id"])),
		"an unowned cell is not worn")
	# A FULL RESPEC RETURNS EVERY POINT AND RE-SPENDS IT.
	var before := Profile.talent_points_earned(cls)
	Profile.respec(cls)
	_check(Profile.talent_points_available(cls) == before,
		"a respec returns every point")
	_check(Profile.worn_talents(cls).is_empty(), "a respec takes off everything worn")
	_check(Profile.talent_cells(cls).is_empty(), "a respec clears every cell")
	var c := String(t1[t1.size() - 1]["id"])
	_check(Profile.buy_cell(cls, c), "the points re-spend on a different cell")
	# A SINGLE refund gives back exactly the cell's price and takes it off.
	var avail2 := Profile.talent_points_available(cls)
	_check(Profile.refund_cell(cls, c), "a cell refunds")
	_check(Profile.talent_points_available(cls) == avail2 + 1,
		"the refund is the cell's price")
	_check(not Profile.worn_talents(cls).has(c), "refunding a cell takes it off too")
	# …AND A REFUND THAT WOULD STRAND THE TIER ABOVE IS REFUSED (FX). With
	# exactly TIER_SPEND_MIN tier-1 cells owned and a tier-2 cell resting on
	# them, giving one back would leave the tier-2 cell owned and worn behind a
	# gate that no longer opens; `can_refund` refuses, and the full respec —
	# which clears every tier at once — is the way out.
	for t in t1.slice(0, need):
		Profile.buy_cell(cls, String(t["id"]))
	Profile.buy_cell(cls, String(t2[0]["id"]))
	var strand := String(t1[0]["id"])
	var why_r := String(Talents.can_refund(tree, strand, Profile.talent_cells(cls))["why"])
	_check(not Profile.refund_cell(cls, strand) and Profile.owns_cell(cls, strand)
			and why_r.begins_with("Tier 2"),
		"a refund that would strand tier 2 is refused, and says why (got \"%s\")" % why_r)
	Profile.respec(cls)
	_check(Profile.talent_cells(cls).is_empty() and Profile.worn_talents(cls).is_empty(),
		"…and the full respec clears it instead")
	sections += 1


# ---------- §9 GATING ----------

func _gating() -> void:
	_fresh()
	_check(Profile.talent_tier() == 0, "a fresh profile has no tiers")
	# A PER-CLASS LOOP OVER FOUR PURSES — it was a per-spec loop over twelve
	# until FX keyed the ledger to the class.
	for cls in class_keys:
		_check(Profile.talent_points_earned(cls) == 0,
			"a fresh profile has no points for %s" % cls)
		_check(Profile.worn_talents(cls).is_empty(),
			"a fresh profile wears nothing for %s" % cls)
	# DIFFICULTY 1 OPENS TIER 1 FOR EVERY CLASS — the tier is global.
	Profile.note_end_boss(1)
	var tree: Array = Talents.tree()
	for cls in class_keys:
		for t in Talents.tier_nodes(tree, 1):
			var chk := Talents.can_buy(tree, String(t["id"]), Profile.talent_cells(cls), 99,
				Profile.talent_tier())
			_check(bool(chk["ok"]),
				"%s: %s is open to every class at difficulty 1" % [cls, t["id"]])
	# THE TOP TIER IS UNREACHABLE UNTIL DIFFICULTY 3 — and specifically not at 2.
	_check(not Talents.tier_open(Talents.TIERS, 1), "the top tier is shut at difficulty 1")
	_check(not Talents.tier_open(Talents.TIERS, 2), "the top tier is shut at difficulty 2")
	_check(Talents.tier_open(Talents.TIERS, 3), "the top tier opens at difficulty 3")
	Profile.note_end_boss(2)
	_check(Profile.talent_tier() == 2, "difficulty 2 raises the tier")
	# The tier never falls: clearing an easier rung afterwards changes nothing.
	Profile.note_end_boss(1)
	_check(Profile.talent_tier() == 2, "an easier clear does not lower the tier")
	sections += 1


# ---------- §9 PERSISTENCE ----------

func _persistence() -> void:
	_fresh()
	var spec := "pyromancer"
	var cls := Classes.class_of_spec(spec)
	Profile.note_end_boss(2)
	for i in 8:
		Profile.award_zone_boss_points([spec])
	var tree: Array = Talents.tree()
	var pick := String(Talents.tier_nodes(tree, 1)[1]["id"])
	Profile.buy_cell(cls, pick)
	# Round-trip: drop the in-memory copy and read the file back.
	Profile.data = {}
	Profile.loaded = false
	_check(Profile.talent_points_earned(cls) == 8, "points survive a restart")
	_check(Profile.owns_cell(cls, pick), "cells survive a restart")
	_check(Profile.worn_talents(cls).has(pick),
		"what is worn survives a restart — it is the cells, read back")
	_check(Profile.talent_tier() == 2, "the difficulty tier survives a restart")
	# A PRE-BM (v1) PROFILE — INVERTED AT BATCH FX. BM loaded one tolerantly:
	# "…with zeros, while its OTHER buckets survive intact, and it is written
	# back at the new version". FX moved the floor, `Profile.MIN_VERSION`, to 2 —
	# the oldest version this build carries a migration for — so a v1 profile is
	# REFUSED rather than silently zeroed (CLAUDE.md, the BM block's VERSIONS),
	# and a refusal never writes. The same questions are asked of the rule that
	# replaced it.
	var v1 := JSON.stringify({"version": 1, "runs_started": {"holy": 4},
		"runs_completed": {}, "wipes": {}, "forfeits": {}, "bosses_killed": {},
		"events_seen": {}, "zones_cleared": 3, "flags": {"framing": true}})
	var f := FileAccess.open(SCRATCH, FileAccess.WRITE)
	f.store_string(v1)
	f = null
	Profile.data = {}
	Profile.loaded = false
	var tier_v1 := Profile.talent_tier()
	_check(Profile.refused and Profile.refused_version == 1,
		"a pre-BM (v1) profile is REFUSED — it is below MIN_VERSION %d" % Profile.MIN_VERSION)
	_check(tier_v1 == 0, "…so it is read at tier 0 — nothing of it is merged")
	_check(Profile.talent_points_earned("cleric") == 0, "…and with no points")
	_check(Profile.talent_cells("cleric").is_empty(), "…and no cells")
	# THE TEETH: a write attempted after a refusal is a no-op, so the file on
	# disk is the file that was refused, byte for byte.
	Profile.note_end_boss(3)
	var after_v1 := FileAccess.get_file_as_string(SCRATCH)
	_check(after_v1 == v1,
		"…while its OTHER buckets survive intact ON DISK — a refused profile is never written")
	_check(int((JSON.parse_string(after_v1) as Dictionary).get("version", 0)) == 1,
		"…and it is NOT written back at the new version: it stays v1 for a build that reads it")
	# AND THE PROFILE THIS BUILD DOES MIGRATE — v2, THE LAST OF THE SPEC PURSES.
	# This is the live form of BM's question "does an existing profile load into
	# the new ledger": twelve spec purses FOLD into four class purses by MAX,
	# not by sum (ruled by the designer); the v2 cells and the v2 loadout name
	# nodes of the deleted trees and are DROPPED; the global tier and every
	# other bucket carry; and the next save writes it at the new version.
	var v2 := {"version": 2, "runs_started": {"holy": 4}, "runs_completed": {},
		"wipes": {}, "forfeits": {}, "bosses_killed": {}, "events_seen": {},
		"zones_cleared": 3, "flags": {"framing": true}, "talent_tier": 2,
		"talent_points": {"berserker": 3, "warden": 5, "swordmaster": 1, "holy": 2},
		"talent_cells": {"warden": {"wd_ricochet": true}},
		"talent_equipped": {"warden": {"1": "wd_ricochet"}}}
	f = FileAccess.open(SCRATCH, FileAccess.WRITE)
	f.store_string(JSON.stringify(v2))
	f = null
	Profile.data = {}
	Profile.loaded = false
	_check(Profile.talent_points_earned("warrior") == 5 and Profile.migrated_from == 2,
		"a v2 profile FOLDS on load: the Warrior's purse is the MAX of its specs' (5), not their sum (9)")
	_check(Profile.talent_points_earned("cleric") == 2 and Profile.talent_points_earned("mage") == 0,
		"…a class with one spec purse takes it, and a class with none starts at 0")
	_check(Profile.talent_cells("warrior").is_empty() and not Profile.data.has("talent_equipped"),
		"…its cells and its loadout name deleted nodes, and are DROPPED")
	_check(Profile.talent_tier() == 2 and Profile.flag("framing"),
		"…while the global tier and every other bucket carry")
	Profile.award_zone_boss_points(["warden"])
	var on_disk: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SCRATCH))
	var class_keyed := true
	for key in on_disk.get("talent_points", {}):
		if not class_keys.has(String(key)):
			class_keyed = false
	_check(int(on_disk.get("version", 0)) == Profile.VERSION and class_keyed,
		"…and the next save writes it at v%d, every purse keyed to a class" % Profile.VERSION)
	# THE RUN SAVE CARRIES WHAT EACH MEMBER WEARS: asserted against the source,
	# because Run is an autoload and does not resolve in a --script SceneTree.
	# `party` carries `talents` — since FX the class's worn set, copied at the
	# handoff — and the version moved.
	var rs := _src("res://scripts/run_state.gd")
	# BATCH CT re-pointed this IN PLACE, on BK §6's precedent. It pinned the
	# literal 10 and broke when CT's slotted pouch raised it to 11. **BM's
	# invariant is that the party — and its equipped talents — is IN the save,
	# and that a pre-v10 save is refused**, neither of which is a claim about the
	# newest version number. Asserted as "10 or later" so the next bump does not
	# fail a talents test either.
	var bm_ver := -1
	var bm_vpos := rs.find('"version": ')
	if bm_vpos >= 0:
		bm_ver = int(rs.substr(bm_vpos + 11, 3).strip_edges().split(",")[0])
	_check(bm_ver >= 10, "the run save is v10 or later (found %d)" % bm_ver)
	_check(rs.contains("if save_version < 10:"), "a pre-v10 save is refused")
	_check(rs.contains('"party": party'), "the party — and its talents — is saved")
	sections += 1


# ---------- §6 THE END BOSS AND §5 THE LADDER ----------

func _end_boss_and_ladder() -> void:
	var rs := _src("res://scripts/run_state.gd")
	# The fourth boss is one extra slot in the final zone: 3 x 16 + 1 = 49.
	_check(rs.contains("const END_BOSS_SLOT := SLOTS_PER_ZONE"),
		"the end boss is the slot after the final zone's boss")
	_check(rs.contains("func total_slots() -> int:"), "the run knows its own length")
	_check(rs.contains("return SLOT_COUNT * SLOTS_PER_ZONE + 1"),
		"a run is 49 encounters")
	_check(rs.contains('slot == END_BOSS_SLOT and not has_next_zone()'),
		"only the end-boss slot ends the run")
	# It is FIXED, not composed.
	_check(rs.contains('node["enemies"] = [END_BOSS_KIND]'),
		"the end boss is a fixed encounter, not a budget roll")
	_check(Enemies.kinds().has(Run_end_boss_kind()),
		"the end boss kind exists in the roster")
	# …and it gains MECHANICS with difficulty.
	var ranked := 0
	for ab in Enemies._load()[Run_end_boss_kind()].get("abilities", []):
		if int(ab.get("rung", 1)) > 1:
			ranked += 1
	_check(ranked == 2, "the end boss gains two abilities across the ladder")
	_check(Enemies.config(Run_end_boss_kind(), 1)["abilities"].size() == 3,
		"rung 1 meets three of its abilities")
	_check(Enemies.config(Run_end_boss_kind(), 2)["abilities"].size() == 4,
		"rung 2 meets four")
	_check(Enemies.config(Run_end_boss_kind(), 3)["abilities"].size() == 5,
		"rung 3 meets five")
	# Every other kind reads identically at every rung — the filter is inert
	# where nothing is tagged.
	for kind in Enemies.kinds():
		if kind == Run_end_boss_kind():
			continue
		_check(Enemies.config(String(kind), 1)["abilities"].size()
			== Enemies.config(String(kind), 3)["abilities"].size(),
			"%s is unchanged by the rung" % kind)
	# THE LADDER: three rungs, rung 1 BELOW the present balance, rung 2 AT it.
	_check(rs.contains('const DIFFICULTY_ORDER := ["wanderer", "warden", "ruin"]'),
		"three rungs in order")
	# RE-POINTED IN PLACE (Batch BN §2): this pinned the literal 0.70, which BM
	# inherited from Batch Y's Wanderer affordance — a float picked for a
	# different job. BN swept untalented completion at 0.70 / 0.60 / 0.50 / 0.40
	# (13% / 28% / 83% / 95%) and shipped 0.50. THE QUESTION IS UNCHANGED AND SO
	# IS THE LABEL — rung 1 must sit BELOW the present balance — only the number
	# moved, so the check is re-pointed rather than deleted, and rungs 2 and 3
	# below it are asserted UNMOVED in the same breath.
	_check(rs.contains('"mult": 0.50'), "rung 1 is below the present balance")
	_check(rs.contains('"mult": 1.00'), "rung 2 IS the present balance")
	_check(rs.contains('"mult": 1.30'), "rung 3 is above it")
	_check(rs.contains('const LEGACY_DIFFICULTY := {"standard": "warden"}'),
		"Batch Y's 'standard' still resolves, at the rung it was tuned for")
	# Each rung above 1 carries a NAMED TWIST as well as scaling.
	_check(rs.contains('"severity_floor": 2') and rs.contains('"severity_floor": 3')
		and rs.contains('"severity_floor": 4'),
		"the severity floor rises with the rung")
	_check(rs.contains("var floor_sev := int(difficulty_def()[\"severity_floor\"])"),
		"roll_offer reads the rung's floor rather than a constant 2")
	_check(rs.contains("func arm_fixed_modifier(node_type: String) -> void:"),
		"rung 3 puts a modifier on the encounters a route cannot duck")
	_check(rs.contains('const FIXED_MODIFIER_NODES := ["miniboss", "boss", "endboss"]'),
		"…and it names which those are")
	_check(_src("res://scripts/map_screen.gd").contains("Run.arm_fixed_modifier(ty)"),
		"the map walk arms it")
	_check(_src("res://scripts/run_sim.gd").contains("run.arm_fixed_modifier(ty)"),
		"and so does the harness — it must walk the road the player walks")
	sections += 1


func Run_end_boss_kind() -> String:
	# Run is an autoload and does not resolve here; the constant is read off
	# the source rather than guessed.
	var rs := _src("res://scripts/run_state.gd")
	var i := rs.find('const END_BOSS_KIND := "')
	return rs.substr(i + 24, rs.find('"', i + 24) - (i + 24))


# ---------- §6 THE DELETED AWARD SITES ----------

func _award_sites_deleted() -> void:
	# DELETED, NOT ZEROED — the standing rule. Each name is pinned ABSENT so a
	# later batch that re-adds one has to read this first.
	var rs := _src("res://scripts/run_state.gd")
	var bs := _src("res://scripts/battle.gd")
	var sim := _src("res://scripts/run_sim.gd")
	var ts := _src("res://scripts/talents.gd")
	var ps := _src("res://scripts/party_screen.gd")
	var ms := _src("res://scripts/map_screen.gd")
	var sc := _src("res://scripts/spec_choice_screen.gd")
	var ev := _src("res://scripts/events.gd")
	var rl := _src("res://scripts/relics.gd")
	for pair in [["func award_talent_points", rs], ["func award_spec_point", rs],
			["award_talent_points(", bs], ["award_talent_points(", sim],
			["award_spec_point(", sim], ["award_spec_point(", sc],
			["talent_points", ps], ["talent_flex", ps],
			["talent_points", ms], ["talent_flex", ms],
			["start_talent_points", rl],
			['"talent_points"', ev],
			["func can_learn", ts], ["func purse_for", ts],
			["MAX_PER_ROW", ts], ["func points_spent", ts]]:
		_check(not String(pair[1]).contains(String(pair[0])),
			"DELETED: %s" % pair[0])
	# **AND AT BATCH FX** — the twelve trees and their row machinery, the equip
	# step and its per-spec loadout, and the sim's lane builds. CLAUDE.md's BM
	# block lists each of these under "DELETED, NOT ZEROED (each pinned ABSENT
	# in test_batch_bm)", so each is pinned ABSENT here, in its DECLARATION
	# shape: a bare name would match the comments that record the deletion, and
	# `var builds :=` is spelled out because `var builds_desc` is live.
	var pf := _src("res://scripts/profile.gd")
	for pair in [["const LANE_TREES :=", ts], ["const LANE_NAMES :=", ts],
			["const TIER_ROWS :=", ts], ["const ROWS :=", ts],
			["const CAPSTONE_ROW :=", ts], ["const LANES :=", ts],
			["const CELLS_PER_SPEC :=", ts], ["func row_nodes(", ts],
			["func row_picks(", ts], ["func row_picked(", ts],
			["func has_capstone(", ts], ["func tier_of_row(", ts],
			["func rows_unlocked(", ts], ["func row_unlocked(", ts],
			["func full_spec_cost(", ts], ["func can_equip(", ts],
			["func equipped_learned(", ts], ["func talent_equipped(", pf],
			["func equip_cell(", pf], ["func unequip_row(", pf],
			["func equipped_talents(", pf], ["var rows_built", sim],
			["var builds :=", sim], ["func _target_lane(", sim]]:
		_check(not String(pair[1]).contains(String(pair[0])),
			"DELETED AT FX: %s" % pair[0])
	# The events.json verb went with its handler.
	var ej := _src("res://data/events.json")
	_check(not ej.contains("talent_points"),
		"no event awards a talent point any more")
	# The two relics that granted them are re-specced, not left with a dead hook.
	_check(rl.contains('"waystone"') and rl.contains('"warhorn"'),
		"both re-specced relics survive by id")
	for id in ["waystone", "warhorn"]:
		var hooks: Dictionary = Relics.POOL[id]["hooks"]
		_check(not hooks.is_empty(), "%s still does something" % id)
		_check(not hooks.has("start_talent_points"), "%s has no dead hook" % id)
	# The superseded figures are named as superseded where they are recorded.
	_check(sim.contains("BATCH BM DELETED talent_spent"),
		"the harness says its old talent metrics are gone")
	_check(sim.contains("10.9"), "…and names BK's figure as superseded")
	# THE HANDOFF: the awakening EQUIPS rather than pays, from BOTH paths.
	_check(sc.contains("Run.equip_spec_talents(idx)"), "the spec screen equips")
	_check(sim.contains("run.equip_spec_talents(i)"), "and so does the harness")
	_check(rs.contains("func equip_spec_talents(idx: int) -> void:"),
		"one implementation of the handoff")
	# A SIM NEVER READS Profile: the loadout comes off Run.sim_talents.
	# BATCH FX RE-POINTED THE FIRST: a real run reads its CLASS's worn set now —
	# `Profile.worn_talents`, keyed by `Classes.class_of_spec` — where it read a
	# spec's equipped loadout, which was deleted with the equip step.
	_check(rs.contains("Profile.worn_talents(Classes.class_of_spec(spec))"),
		"a real run reads Profile — the worn set of the spec's CLASS")
	_check(rs.contains("else sim_equipped_talents(spec)"),
		"a sim reads its own installed loadout instead")
	# A bare `contains` trips on a COMMENT naming the thing it forbids, and
	# naming it in a comment is exactly how this project asks a later batch
	# not to re-add it (the AW lesson). Look for a CALL.
	var sim_calls := 0
	for line in sim.split("\n"):
		var code := String(line).strip_edges()
		if code.begins_with("#"):
			continue
		if code.contains("Profile."):
			sim_calls += 1
	_check(sim_calls == 0, "RunSim CALLS Profile nowhere at all")
	sections += 1


# ---------- §9 THE SIX NEGATIVE CONTROLS ----------
#
# Each builds the BROKEN state and proves the checker rejects it. Every one of
# the six would otherwise fail silently: the game still runs, the hero still
# fights, and only the design is gone.

func _negative_controls() -> void:
	_fresh()
	var spec := "warden"
	var cls := Classes.class_of_spec(spec)
	var tree: Array = Talents.tree()
	Profile.note_end_boss(3)
	for i in 60:
		Profile.award_zone_boss_points([spec])
	var a := String(Talents.tier_nodes(tree, 1)[0]["id"])
	var b := String(Talents.tier_nodes(tree, 1)[1]["id"])

	# (1) INVERTED AT BATCH FX — A PURCHASE THAT IS NOT WORN, AND A REFUND THAT
	# STAYS ON. This control built "a purchased cell auto-equipping" and proved
	# the ledger refused it; FX made wearing on purchase the RULE (no node is
	# exclusive, so there is no equip step — CLAUDE.md, "A CELL BOUGHT IS A CELL
	# WORN"). The broken state is the opposite one now, and it is just as
	# silent: a cell bought and not worn, a refund left on, or a cell the tree
	# cannot price being worn anyway.
	Profile.buy_cell(cls, a)
	_check(Profile.worn_talents(cls).has(a),
		"NEGATIVE 1 (INVERTED AT FX): buying IS wearing")
	Profile.buy_cell(cls, b)
	var worn := Profile.worn_talents(cls)
	_check(worn.has(a) and worn.has(b),
		"NEGATIVE 1: a second purchase is worn too — beside the first, not instead of it")
	Profile.refund_cell(cls, b)
	worn = Profile.worn_talents(cls)
	_check(worn.has(a) and not worn.has(b),
		"NEGATIVE 1: refunding a cell un-wears it, and only it")
	_check(not Talents.worn_learned(tree, {"bz_savagery": true}).has("bz_savagery"),
		"NEGATIVE 1: a cell the tree does not hold (a deleted node's id) is never worn")

	# (2) POINTS TRANSFERRING BETWEEN CLASSES — between SPECS until FX moved
	# the purse to the class. The Warrior's 60 are the Warrior's.
	var other := Profile.talent_points_available("mage")
	_check(other == 0, "NEGATIVE 2: the Warrior's purse is not the Mage's")
	_check(not Profile.buy_cell("mage", String(tree[0]["id"])),
		"NEGATIVE 2: another class cannot spend it")
	# …and the half FX made true on purpose: every spec of a class spends it.
	_check(Profile.talent_points_earned(Classes.class_of_spec("berserker")) == 60,
		"NEGATIVE 2: a Berserker spends the purse the Warden's zone bosses banked — one purse per class")

	# (3) TIER UNLOCKS APPLYING TO ONE CLASS ONLY.
	var opened_everywhere := true
	for c2 in class_keys:
		if not Talents.tier_open(Talents.TIERS, Profile.talent_tier()):
			opened_everywhere = false
	_check(opened_everywhere,
		"NEGATIVE 3: the difficulty tier is global, not per class")
	var per_class_tier := false
	for key in Profile.data:
		if String(key).begins_with("talent_tier_"):
			per_class_tier = true
	_check(Profile.talent_tier() == 3 and not per_class_tier,
		"NEGATIVE 3: there is no per-class tier to disagree with it")

	# (4) A TALENT POINT STILL AWARDED BY AN ELITE. There is no in-run purse
	# at all, so the control is that the member dict has no field for one.
	var rs := _src("res://scripts/run_state.gd")
	var i := rs.find('party.append({"key": key')
	# GUARDED: an unguarded -1 makes `member_line` empty and the negative below
	# true for every needle — a check that has stopped asking its question with
	# nothing to announce it (the `test_batch_bg` shape, EC §2).
	_check(i >= 0, "NEGATIVE 4: the party-member anchor resolves, so the slice is real")
	var member_line := rs.substr(i, 300)
	_check(not member_line.contains("talent_points")
		and not member_line.contains("talent_flex"),
		"NEGATIVE 4: a party member carries no talent purse to award into")
	var bs := _src("res://scripts/battle.gd")
	var vi := bs.find('var node_type := String(Run.encounter.get("type", "fight"))')
	# GUARDED (BATCH EE §4): a -1 here yields an EMPTY slice, no lines, and a
	# negative that is true of nothing — the same vacuum as NEGATIVE 4 above,
	# wearing a `for` loop instead of a `contains`.
	_check(vi >= 0, "NEGATIVE 4: the victory-branch anchor resolves, so the slice is real")
	var victory_code := PackedStringArray()
	for line in bs.substr(vi, 1400).split("\n"):
		var code := String(line).strip_edges()
		if not code.begins_with("#"):
			victory_code.append(code)
	_check(not "\n".join(victory_code).to_lower().contains("talent"),
		"NEGATIVE 4: the victory branch awards no talent anything")

	# (5) WORN TALENTS CHANGING MID-RUN. The build screen refuses while a run
	# is active, the party sheet has no spend path at all, and nothing in a run
	# writes member["talents"] after the awakening.
	var tsx := _src("res://scripts/talents_screen.gd")
	_check(tsx.contains("func _locked() -> bool:") and tsx.contains("return Run.active"),
		"NEGATIVE 5: the build screen locks while a run is in flight")
	for guard in ["func _on_node(id: String) -> void:", "func _on_respec() -> void:"]:
		var gi := tsx.find(guard)
		_check(tsx.substr(gi, 120).contains("if _locked():"),
			"NEGATIVE 5: %s checks the lock first" % guard)
	var ps := _src("res://scripts/party_screen.gd")
	_check(not ps.contains("func _learn_talent"),
		"NEGATIVE 5: the hero sheet has no spend path")
	_check(ps.contains("LOCKED FOR THIS RUN"),
		"NEGATIVE 5: …and says so where the player reads it")
	# THE WRITERS ARE COUNTED BY SITE (re-pointed at BATCH FX). BM's claim is
	# EXACTLY TWO WRITERS — the handoff and the tree migration — and it counted
	# LINES, which read 2 while each site wrote once. FX's handoff writes twice
	# inside its one function (an unawakened hero is handed an empty set before
	# the early return; a hero with a class is handed that class's worn set), so
	# the line count reads 3 with no third SITE. The claim is about sites, so
	# sites are what is counted: every writer must sit in one of the two
	# functions, each of the two must write, and nothing else may.
	var sites := {}
	var stray := 0
	var fn := ""
	for line in rs.split("\n"):
		var raw := String(line)
		if raw.begins_with("func ") or raw.begins_with("static func "):
			fn = raw.get_slice("func ", 1).get_slice("(", 0)
		var code := raw.strip_edges()
		if code.begins_with("#"):
			continue
		if code.contains('member["talents"] =') or code.contains('party[idx]["talents"] ='):
			if fn == "equip_spec_talents" or fn == "_migrate_trees":
				sites[fn] = true
			else:
				stray += 1
	_check(sites.size() == 2 and stray == 0,
		"NEGATIVE 5: EXACTLY two writers — the handoff and the tree migration (sites %s, %d elsewhere)"
			% [str(sites.keys()), stray])

	# (6) A NODE THAT IS AN EARLIER NODE WITH A BIGGER NUMBER. Built directly:
	# BM built it as a row-8 node re-writing a row-4 node's field in its own
	# LANE; FX retired the lanes and kept the property over the whole tree, so
	# the fake is a tree whose later node writes an earlier node's own field,
	# proven to be caught by the same field-overlap rule §9's structure check
	# runs over the live tree.
	var fake: Array = [
		{"id": "x_t1", "name": "One", "tier": 1, "desc": "",
			"payload": {"stat": {"shared_field": 10}}},
		{"id": "x_t3", "name": "Three", "tier": 3, "desc": "",
			"payload": {"stat": {"shared_field": 40}}},
	]
	_check(_field_duplicates(fake),
		"NEGATIVE 6: a node re-writing an earlier node's field IS caught")
	var clean: Array = [
		{"id": "y_t1", "name": "One", "tier": 1, "desc": "",
			"payload": {"stat": {"field_a": 10}}},
		{"id": "y_t3", "name": "Three", "tier": 3, "desc": "",
			"payload": {"stat": {"field_b": 40}}},
	]
	_check(not _field_duplicates(clean),
		"NEGATIVE 6: …and a genuinely new effect is not")
	# The live tree passes it — asserted here as well as in _structure, so the
	# control and the thing it controls sit side by side. Asked per spec,
	# because `generate_tree(spec)` is the door every spec's hero is built from.
	for s3 in Classes.all_specs():
		_check(not _field_duplicates(Talents.generate_tree(String(s3), "")),
			"NEGATIVE 6: %s's tree writes no field twice" % s3)
	sections += 1


func _field_duplicates(tree: Array) -> bool:
	for i in tree.size():
		var mine: Array = (tree[i].get("payload", {}).get("stat", {}) as Dictionary).keys()
		for j in i:
			for f in (tree[j].get("payload", {}).get("stat", {}) as Dictionary):
				if mine.has(f):
					return true
	return false
