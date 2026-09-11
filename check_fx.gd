# BATCH FX — ONE TREE, TWENTY-SEVEN NODES.
#
#   §1  THE SHAPE — twenty-seven nodes in three tiers of nine at 1 / 2 / 3 a
#       cell, a 54-point tree, unique ids, every payload a `stat` block and
#       nothing else (THE LINE), every field declared on `BattleUnit`, no field
#       written by two nodes, and a text that states the number it pays
#   §2  THE TWO GATES AND THE LEDGER — driven through `Profile` on a scratch
#       file: nothing opens before rung 1, a tier needs its rung AND
#       `TIER_SPEND_MIN` cells below, a refund cannot strand a tier, the purse
#       is the CLASS's, and a cell owned is a cell worn
#   §3  THE FOLD — a v2 profile's twelve purses become four by MAX, the old
#       cells and loadout drop, the tier carries, and a purse the fold cannot
#       place is REFUSED with the file untouched
#   §4  EVERY NODE PAYS, LIVE — a battle with all twenty-seven on all four
#       classes against one with none proves every payload LANDS on every
#       class; then every read site is driven on a live unit with the field at
#       the node's value and at zero, and a node that pays exactly nothing reds
#   §5  NOTHING READS A NODE BUT THE TREE'S OWN DOOR — no rune carries a
#       condition, and `has_node` is called nowhere but `talents.gd`
#
# **WHY §4 IS THE ARM THE BATCH EXISTS FOR.** This project's most common shipped
# defect is a payload that attaches and pays exactly 1.0000 — DK's Tank and
# Spank, EZ's Shared Hide before it — and every static arm above passes on one.
# FW's recon priced each of these fields TODAY by READING the code; this gate is
# the reading turned into a measurement, and it measures on all four classes
# because the tree is one tree every class buys. **A node that pays a Mage and
# not a Warrior is the defect FX §2 swapped four nodes out for** — the four did
# not reach this file, and this file is what says the twenty-seven that did pay.
#
# **§4 HAS TWO HALVES AND BOTH ARE NEEDED.** (a) PLUMBING: the node's value is
# on the unit after the spawn, per class — which catches an undeclared name, the
# zero-start trap and a class passive assigning over the tree (FW's SR-PLUMB
# traps 1-3). (b) THE READ SITE: the attached field moves the thing it is read
# into. Neither half proves the other: a field can land and be read nowhere, and
# a read site can be live while the spawn never writes it.
#
# **FIELD MEDIC IS DRIVEN THE WAY DK §1 DROVE IT, AND THE REASON IS STRUCTURAL.**
# Its read sits inline in `_run_battle`'s upkeep, which cannot be driven
# headlessly, so the arm composes it: the loop's own pool expression evaluated
# live, the one door it washes through, and the guard statement read off the
# comment-stripped source to prove it names no spec, passive or class.
#
# THE MAGNITUDES ARE NOT PINNED HERE — the designer re-rules any of them in one
# line of `talents.gd`, and a gate that reds for a re-ruling teaches the next
# batch to route around it. What is pinned is that each node's TEXT states its
# own payload's number, so a re-ruled magnitude cannot leave the card saying the
# old one. **`TIER_SPEND_MIN` is the designer's to set and is read, never
# pinned**; `TIERS_OPEN` is RULED (the brief: *"TIER_ROWS's shape stands"*) and
# is pinned, because a change to it is a change to EN §3's tutorial gate.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fx.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# NEVER `user://profile.json` — FQ's rule. This gate writes v2 and malformed
# profiles, and the whole reason the fold is guarded is that the real one is not
# disposable. §0 asserts the redirect landed before anything writes.
const SCRATCH := "user://check_fx_profile.json"

# One hero of each class, so every arm that is about a CLASS reaches all four.
const SPECS := ["berserker", "pyromancer", "holy", "sharpshooter"]
const SEED := 7707

# THE TEXT STATES THE NUMBER THE PAYLOAD PAYS. Per field: the factor that turns
# the payload value into the number on the card (1 for a field that IS the
# number, 100 for a fraction shown as a percentage, and — where the read site
# multiplies — that read site's own literal), and the words the number sits in.
# `%d` is the computed number; a node whose text has drifted from its payload
# fails here rather than on a playtest.
const TEXT := {
	"max_hp_pct": [100.0, "+%d% maximum Health"],
	"attack": [1.0, "+%d Attack"],
	"armor": [100.0, "+%d% armor"],
	"crit_bonus": [100.0, "+%d% critical chance"],
	"speed": [1.0, "+%d Speed"],
	"parry_bonus": [100.0, "+%d% parry chance"],
	"max_resource": [1.0, "+%d maximum Rage or Mana"],
	"dmg_bonus": [100.0, "+%d% damage dealt"],
	"dmg_taken_bonus": [-100.0, "%d% less damage taken"],
	"broken_will_ranks": [1.0, "%d% more Break damage"],
	"blood_communion": [1.0, "for %d% of its value"],
	"follow_through": [1.0, "cooldowns by %d"],
	"bonecracker_ranks": [1.0, "+%d% damage against Broken"],
	"field_medic": [1.0, "cleanse %d debuffs"],
	"last_hope_pct": [1.0, "receive %d% more healing"],
	"iron_will_ranks": [12.0, "%d% less damage for every debuff"],
	"pierce_bonus": [100.0, "ignore %d% of the target's armor"],
	"ghillie": [1.0, "%d% less likely to target"],
	"whetstone": [1.0, "Attack by %d"],
	"undying_rage": [50.0, "%d% more damage below 25% health"],
	"last_rites": [1.0, "%d Rage a point"],
	"conversion_ranks": [1.0, "Mana: %d% of all damage taken"],
	"devoutness_ranks": [1.0, "%d% less Break damage"],
	"sundering_shot": [1.0, "deal %d Break damage"],
	"no_quarter_ranks": [45.0, "grants %d Rage or Mana"],
	"rapid_fire": [1.0, "%d% chance not to start"],
	"snap_shot": [1.0, "first %d abilities"],
}
# A field whose card states no number: the payload is a switch.
const SWITCHES := ["no_cover"]

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	Profile.save_path = SCRATCH
	print("BATCH FX — ONE TREE, TWENTY-SEVEN NODES")
	_s0_redirect()
	_s1_shape()
	_s2_gates_and_ledger()
	_s3_fold()
	await _s4_every_node_pays()
	_s5_nothing_reads_a_node()
	_cleanup()
	_g.report(self)


# ─── helpers ────────────────────────────────────────────────────────────────

func _write(txt: String) -> void:
	var f := FileAccess.open(SCRATCH, FileAccess.WRITE)
	f.store_string(txt)
	f = null


func _hash() -> String:
	return FileAccess.get_md5(SCRATCH)


func _reload() -> void:
	Profile.loaded = false
	Profile.data = {}
	Profile._load()


func _fresh() -> void:
	_cleanup()
	_reload()


func _cleanup() -> void:
	if FileAccess.file_exists(SCRATCH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH))


func _on_disk() -> Dictionary:
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string(SCRATCH))
	return raw if raw is Dictionary else {}


func _ids(tree: Array, tier: int) -> Array:
	var out: Array = []
	for t in Talents.tier_nodes(tree, tier):
		out.append(String(t["id"]))
	return out


# ═══ §0 — THE REDIRECT ═══════════════════════════════════════════════════════

func _s0_redirect() -> void:
	print("\n§0 — the scratch redirect")
	ok(Profile.save_path == SCRATCH,
		"§0: `Profile.save_path` is not the scratch file — this gate writes v2 and malformed profiles and would be writing them over the player's")
	print("  writing to %s" % SCRATCH)


# ═══ §1 — THE SHAPE ══════════════════════════════════════════════════════════

func _s1_shape() -> void:
	print("\n§1 — the shape")
	var tree: Array = Talents.tree()
	var want := Talents.TIERS * Talents.NODES_PER_TIER
	ok(Talents.TIERS == 3 and Talents.NODES_PER_TIER == 9,
		"§1: the tree is not three tiers of nine (%d x %d) — the shape is ruled" % [
			Talents.TIERS, Talents.NODES_PER_TIER])
	ok(tree.size() == want, "§1: the tree holds %d nodes, not %d" % [tree.size(), want])
	ok(Talents.TIER_COSTS == [1, 2, 3],
		"§1: the tier costs are %s — BM's 1 / 2 / 3 curve is ruled unchanged" % str(Talents.TIER_COSTS))
	ok(Talents.full_tree_cost() == 54,
		"§1: the whole tree costs %d, not 54" % Talents.full_tree_cost())
	var per_tier := {}
	var ids := {}
	var writer := {}
	var u := BattleUnit.new()
	var paren := RegEx.new()
	paren.compile("\\([^)]*\\d[^)]*\\)")
	var stated := 0
	for t in tree:
		var id := String(t.get("id", ""))
		ok(id != "" and not ids.has(id), "§1: node id `%s` is empty or repeated" % id)
		ids[id] = true
		var tier := Talents.tier_of(t)
		ok(int(t.get("tier", 0)) == tier, "§1: %s names tier %s, outside 1-%d" % [
			id, str(t.get("tier")), Talents.TIERS])
		per_tier[tier] = int(per_tier.get(tier, 0)) + 1
		ok(String(t.get("name", "")) != "" and String(t.get("desc", "")) != "",
			"§1: %s has no name or no text" % id)
		# THE LINE: a talent may not touch a rune, an ability, a passive or an
		# engine. A `stat` block on a unit field is the whole of what is left.
		var pay: Dictionary = t.get("payload", {})
		ok(pay.keys() == ["stat"],
			"§1: %s's payload carries %s — under the line a node is a stat block and nothing else" % [
				id, str(pay.keys())])
		var st: Dictionary = pay.get("stat", {})
		ok(not st.is_empty(), "§1: %s writes no field at all" % id)
		var desc := String(t.get("desc", ""))
		ok(paren.search(desc) == null,
			"§1: %s's text carries an authored digit in parentheses (CL §1)" % id)
		for f in st:
			var field := String(f)
			ok(not writer.has(field),
				"§1: `%s` is written by %s AND %s — two nodes on one field are one idea at two prices" % [
					field, writer.get(field, ""), id])
			writer[field] = id
			ok(field == "max_hp_pct" or u.get(field) != null,
				"§1: `%s` (%s) is declared nowhere on BattleUnit — `set()` drops it and the node pays nothing" % [
					field, id])
			if SWITCHES.has(field):
				continue
			ok(TEXT.has(field), "§1: `%s` (%s) has no row in this gate's text table" % [field, id])
			if not TEXT.has(field):
				continue
			var row: Array = TEXT[field]
			var n := int(round(float(st[f]) * float(row[0])))
			var phrase := String(row[1]).replace("%d", str(n))
			ok(desc.contains(phrase),
				"§1: %s's text does not say `%s` — its payload pays %s" % [id, phrase, str(st[f])])
			stated += 1
	u.free()
	for tier in range(1, Talents.TIERS + 1):
		ok(int(per_tier.get(tier, 0)) == Talents.NODES_PER_TIER,
			"§1: tier %d holds %d nodes, not %d" % [tier, int(per_tier.get(tier, 0)),
				Talents.NODES_PER_TIER])
	# The tree grants nothing — DO's rule, which the line keeps — so the corpus
	# walk that reads talent grants walks nothing.
	ok(Classes.talent_granted_names().is_empty(),
		"§1: a talent grants an ability (%s)" % str(Classes.talent_granted_names()))
	print("  %d nodes, %d / %d / %d a tier, %d fields each written once, %d texts stating their payload" % [
		tree.size(), int(per_tier.get(1, 0)), int(per_tier.get(2, 0)), int(per_tier.get(3, 0)),
		writer.size(), stated])


# ═══ §2 — THE TWO GATES AND THE LEDGER ═══════════════════════════════════════

func _s2_gates_and_ledger() -> void:
	print("\n§2 — the two gates, the class purse, and a cell owned is a cell worn")
	_fresh()
	var tree: Array = Talents.tree()
	var t1 := _ids(tree, 1)
	var t2 := _ids(tree, 2)
	var t3 := _ids(tree, 3)
	var need := Talents.TIER_SPEND_MIN
	ok(need >= 1 and need <= Talents.NODES_PER_TIER,
		"§2: `TIER_SPEND_MIN` is %d, outside the 1-%d a tier of nine allows" % [
			need, Talents.NODES_PER_TIER])
	# ── THE PURSE IS THE CLASS's.
	Profile.award_zone_boss_points(["berserker", "warden"])
	ok(Profile.talent_points_earned("warrior") == 1,
		"§2: two Warrior specs in one award paid the Warrior purse %d, not once" % \
			Profile.talent_points_earned("warrior"))
	ok(Profile.talent_points_earned("berserker") == 0,
		"§2: a SPEC key holds a purse — the ledger did not merge")
	Profile.award_zone_boss_points(["pyromancer"])
	ok(Profile.talent_points_earned("mage") == 1 and Profile.talent_points_earned("warrior") == 1,
		"§2: a Mage's point reached another class")
	for _i in 60:
		Profile.award_zone_boss_points(["swordmaster"])
	var earned := Profile.talent_points_earned("warrior")
	# ── THE DIFFICULTY GATE. A fresh profile opens nothing — EN §3's tutorial gate.
	ok(Talents.TIERS_OPEN == [0, 1, 2, 3],
		"§2: `TIERS_OPEN` is %s — the difficulty gate's shape is ruled to stand" % str(Talents.TIERS_OPEN))
	ok(not Profile.buy_cell("warrior", t1[0]), "§2: a cell bought before any end boss fell")
	ok(String(Talents.can_buy(tree, t1[0], {}, 99, 0)["why"]).begins_with("Locked"),
		"§2: a tier-1 cell at rung 0 is not refused as Locked")
	Profile.note_end_boss(1)
	ok(Profile.buy_cell("warrior", t1[0]), "§2: rung 1 did not open tier 1")
	ok(Profile.talent_points_available("warrior") == earned - 1,
		"§2: a tier-1 cell did not cost 1")
	# ── THE SPEND GATE. Rung 2 alone does not open tier 2.
	Profile.note_end_boss(2)
	if need > 1:
		ok(not Profile.buy_cell("warrior", t2[0]),
			"§2: tier 2 opened at rung 2 with 1 tier-1 cell owned — the spend gate is inert")
		var why := String(Talents.can_buy(tree, t2[0], Profile.talent_cells("warrior"), 99, 2)["why"])
		ok(why.begins_with("Locked") and why.contains("tier 1"),
			"§2: the spend refusal does not name the tier below (`%s`)" % why)
	for k in range(1, need):
		Profile.buy_cell("warrior", t1[k])
	ok(Talents.bought_in_tier(tree, Profile.talent_cells("warrior"), 1) == need,
		"§2: the setup did not reach %d tier-1 cells" % need)
	ok(Profile.buy_cell("warrior", t2[0]),
		"§2: tier 2 did not open at rung 2 with %d tier-1 cells" % need)
	ok(Profile.talent_points_available("warrior") == earned - need - 2,
		"§2: a tier-2 cell did not cost 2")
	for k in range(1, need):
		Profile.buy_cell("warrior", t2[k])
	# ── AND THE DIFFICULTY GATE STILL BINDS WITH THE SPEND MET.
	ok(not Profile.buy_cell("warrior", t3[0]),
		"§2: tier 3 opened at rung 2 because the spend was met — the difficulty gate is inert")
	Profile.note_end_boss(3)
	ok(Profile.buy_cell("warrior", t3[0]), "§2: tier 3 did not open at rung 3 with the spend met")
	# ── BOTH GATES, THE OTHER WAY ROUND: rung 3, nothing below.
	for _i in 20:
		Profile.award_zone_boss_points(["cryomancer"])
	ok(not Profile.buy_cell("mage", t2[0]),
		"§2: a Mage with rung 3 and no tier-1 cell bought into tier 2 — the spend gate is per class and it did not bind")
	ok(Profile.buy_cell("mage", t1[0]), "§2: a funded Mage could not buy tier 1 at rung 3")
	# ── A CELL OWNED IS A CELL WORN, AND THE PURSES ARE APART.
	var worn := Profile.worn_talents("warrior")
	ok(worn.has(t1[0]) and worn.has(t2[0]) and worn.has(t3[0]),
		"§2: an owned cell is not in what a run wears — buying did not wear it")
	ok(worn.size() == Profile.talent_cells("warrior").size(),
		"§2: the Warrior wears %d cells and owns %d" % [worn.size(), Profile.talent_cells("warrior").size()])
	ok(not Profile.worn_talents("mage").has(t3[0]),
		"§2: the Warrior's cells reached the Mage")
	ok(Profile.worn_talents("hunter").is_empty(), "§2: a class that bought nothing wears something")
	# ── A REFUND CANNOT STRAND A TIER.
	ok(not Profile.refund_cell("warrior", t1[0]),
		"§2: a tier-1 refund that leaves tier 2 below its gate was allowed — tier 2's cells are stranded")
	var before_refund := Profile.talent_points_available("warrior")
	ok(Profile.refund_cell("warrior", t3[0]), "§2: a tier-3 cell with nothing above it did not refund")
	ok(Profile.talent_points_available("warrior") == before_refund + 3,
		"§2: the refund was not the cell's price")
	# ── THE RESPEC clears every tier at once and returns every point.
	Profile.respec("warrior")
	ok(Profile.talent_cells("warrior").is_empty() and Profile.worn_talents("warrior").is_empty(),
		"§2: a respec left cells owned or worn")
	ok(Profile.talent_points_available("warrior") == earned,
		"§2: a respec did not return every point (%d of %d)" % [
			Profile.talent_points_available("warrior"), earned])
	# ── THE HANDOFF READS THE CLASS. Run is an autoload and does not resolve
	# under --script, so the one line is read off the source.
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(rs.contains("Profile.worn_talents(Classes.class_of_spec(spec))"),
		"§2: the run handoff does not read the CLASS's worn cells")
	print("  class purse; rung 0 opens nothing; tier 2 at rung 2 + %d below; tier 3 at rung 3; refund cannot strand; respec whole" % need)


# ═══ §3 — THE FOLD ═══════════════════════════════════════════════════════════

func _v2(purses: Dictionary) -> Dictionary:
	return {
		"version": 2,
		"runs_started": {"berserker": 42, "holy": 40},
		"runs_completed": {},
		"wipes": {"berserker": 2},
		"forfeits": {"holy": 1},
		"bosses_killed": {"withered_warden": 13},
		"events_seen": {"blood_altar": 2},
		"zones_cleared": 13,
		"flags": {"run_framing_seen": true},
		"talent_points": purses,
		"talent_cells": {"berserker": {"bz_savagery": true, "bz_hemorrhage": true}},
		"talent_equipped": {"swordmaster": {}, "warden": {}},
		"talent_tier": 3,
	}


func _s3_fold() -> void:
	print("\n§3 — twelve purses fold to four, by MAX")
	# THE DESIGNER'S OWN TWELVE, as FX read them off `profile.json` before the
	# fold was written (`docs/reports/FX.md` §4). Driven here on a COPY — this
	# gate never opens the real file.
	var twelve := {"arcanist": 60, "beastmaster": 68, "berserker": 68, "cryomancer": 65,
		"holy": 66, "inquisitor": 62, "mystic": 60, "occultist": 60, "pyromancer": 63,
		"sharpshooter": 60, "swordmaster": 60, "warden": 60}
	_write(JSON.stringify(_v2(twelve)))
	_reload()
	ok(not Profile.refused, "§3: the designer's v2 profile was REFUSED — the fold did not run")
	ok(Profile.migrated_from == 2, "§3: the load did not record a fold from v2")
	var folded := 0
	for cls in Classes.SPEC_IDS:
		var mx := 0
		var sm := 0
		for spec in Classes.SPEC_IDS[cls]:
			mx = maxi(mx, int(twelve[String(spec)]))
			sm += int(twelve[String(spec)])
		ok(Profile.talent_points_earned(String(cls)) == mx,
			"§3: %s folded to %d — the highest of its three is %d and the sum would be %d" % [
				cls, Profile.talent_points_earned(String(cls)), mx, sm])
		ok(int((Profile.fold_report.get(String(cls), {}) as Dictionary).get("purse", -1)) == mx,
			"§3: the fold report for %s does not say %d" % [cls, mx])
		folded += 1
	ok(folded == 4, "§3: CHECKED %d of 4 classes" % folded)
	ok(Profile.talent_cells("warrior").is_empty() and Profile.talent_cells("berserker").is_empty(),
		"§3: a v2 cell survived the fold — it names a node no tree holds")
	ok(not Profile.data.has("talent_equipped"), "§3: the v2 loadout survived the fold")
	ok(Profile.talent_tier() == 3, "§3: the rung tier did not carry")
	ok(int(Profile.data["runs_started"]["berserker"]) == 42 and int(Profile.data["zones_cleared"]) == 13,
		"§3: a bucket the merge does not touch moved in the fold")
	ok(Profile.talent_points_available("warrior") == Profile.talent_points_earned("warrior"),
		"§3: a folded purse arrived partly spent")
	# THE FOLD WRITES NOTHING UNTIL A SAVE, and the save writes the new version.
	ok(int(_on_disk().get("version", 0)) == 2, "§3: loading the v2 file rewrote it before any save")
	Profile._save()
	var disk := _on_disk()
	ok(int(disk.get("version", 0)) == Profile.VERSION
			and (disk.get("talent_points", {}) as Dictionary).size() == 4,
		"§3: the save did not write four purses at v%d" % Profile.VERSION)
	# THE BRIEF'S OWN CASE: 3 on each of three Warrior specs is 3, not 9.
	_write(JSON.stringify(_v2({"berserker": 3, "warden": 3, "swordmaster": 3})))
	_reload()
	ok(Profile.talent_points_earned("warrior") == 3,
		"§3: three Warrior purses of 3 folded to %d — the ruling is the max, 3, not the sum, 9" % \
			Profile.talent_points_earned("warrior"))
	# REFUSED, NOT ZEROED: a purse the fold cannot place, and the file untouched.
	_write(JSON.stringify(_v2({"berserker": 5, "paladin": 9})))
	var h := _hash()
	_reload()
	ok(Profile.refused, "§3: a purse for a spec this build does not know was folded into nothing")
	Profile.award_zone_boss_points(["berserker"])
	Profile._save()
	ok(_hash() == h, "§3: a REFUSED fold wrote to the file — the unplaceable purse is gone")
	_write(JSON.stringify(_v2({"berserker": "lots"})))
	_reload()
	ok(Profile.refused, "§3: a purse that is not a number was folded")
	# THE FLOOR MOVED — FQ set it to 1 as "the line the merge moves".
	ok(Profile.MIN_VERSION > 1,
		"§3: `MIN_VERSION` is still %d — FX was to move it" % Profile.MIN_VERSION)
	_write(JSON.stringify({"version": Profile.MIN_VERSION - 1, "runs_started": {"holy": 4}}))
	_reload()
	ok(Profile.refused, "§3: a profile below the floor was accepted")
	print("  twelve -> four by max; cells and loadout dropped; tier kept; unplaceable purse refused, file untouched; floor %d" % Profile.MIN_VERSION)


# ═══ §4 — EVERY NODE PAYS, LIVE ══════════════════════════════════════════════

# Every field the tree writes, and the node that writes it.
func _fields() -> Dictionary:
	var out := {}
	for t in Talents.tree():
		for f in (t["payload"]["stat"] as Dictionary):
			out[String(f)] = [String(t["id"]), t["payload"]["stat"][f]]
	return out


func _by_key(scene: Node) -> Dictionary:
	var out := {}
	for h in scene.get("heroes"):
		if not h.is_companion:
			out[String(h.hero_key)] = h
	return out


# What the spawn left on each hero, for every field the tree writes — plus the
# three things a node reaches that are not its own field: health (the spawn
# multiplies it), the Last Hope stamp and the Devoutness stamp (both party-wide).
func _snapshot(scene: Node, fields: Dictionary) -> Dictionary:
	var snap := {}
	var heroes := _by_key(scene)
	for k in heroes:
		var h: BattleUnit = heroes[k]
		var row := {"max_hp": h.max_hp, "last_hope_bonus": h.last_hope_bonus,
			"devotion": h.status_power("devotion") if h.has_status("devotion") else 0}
		for f in fields:
			if String(f) != "max_hp_pct":
				row[f] = h.get(String(f))
		snap[k] = row
	return snap


func _s4_every_node_pays() -> void:
	print("\n§4 — every node pays, live, on every class")
	var fields := _fields()
	var all := {}
	for t in Talents.tree():
		all[String(t["id"])] = 1
	# ── (a) THE PLUMBING — all twenty-seven on all four, against none.
	var wear := {}
	for seat in 4:
		wear[seat] = {"talents": all.duplicate()}
	var sb: Node = await Gate.spawn(self, SPECS, {"party": wear})
	var with_all := _snapshot(sb, fields)
	sb.queue_free()
	await process_frame
	var scene: Node = await Gate.spawn(self, SPECS)
	var none := _snapshot(scene, fields)
	var landed := 0
	for k in none:
		ok(with_all.has(k), "§4a: the %s hero is missing from the talented battle" % k)
		if not with_all.has(k):
			continue
		var a: Dictionary = none[k]
		var b: Dictionary = with_all[k]
		for f in fields:
			var v = fields[f][1]
			if String(f) == "max_hp_pct":
				var want := int(round(int(a["max_hp"]) * (1.0 + float(v))))
				ok(int(b["max_hp"]) == want,
					"§4a: %s — More Health left the %s at %d health, not %d" % [fields[f][0], k,
						int(b["max_hp"]), want])
			else:
				var got := float(b[f]) - float(a[f])
				ok(absf(got - float(v)) < 0.0001,
					"§4a: %s — `%s` on the %s moved by %s, not %s: the payload did not land (an undeclared name, the zero-start trap, or a passive assigning over it)" % [
						fields[f][0], f, k, str(got), str(v)])
			landed += 1
		# THE TWO PARTY-WIDE STAMPS reach every hero whoever holds them.
		ok(int(b["last_hope_bonus"]) == int(fields["last_hope_pct"][1]) and int(a["last_hope_bonus"]) == 0,
			"§4a: tn_last_hope — the %s carries a Last Hope stamp of %d, not %d" % [k,
				int(b["last_hope_bonus"]), int(fields["last_hope_pct"][1])])
		ok(int(b["devotion"]) == int(fields["devoutness_ranks"][1]) and int(a["devotion"]) == 0,
			"§4a: tn_unbreaking — the %s carries a Devoutness stamp of %d, not %d" % [k,
				int(b["devotion"]), int(fields["devoutness_ranks"][1])])
	ok(landed == 4 * fields.size(),
		"§4a: CHECKED %d of %d (four classes x every field the tree writes)" % [landed, 4 * fields.size()])
	print("  (a) %d field landings checked across four classes; both party stamps reach every hero" % landed)
	# ── (b) THE READ SITES, each driven on the untalented battle's live units.
	await _drive(scene, fields)
	scene.queue_free()
	await process_frame


# One seeded ordinary blow and what it did: health lost and Break taken. The
# target is reset first so nothing dies mid-arm, and the pair of blows under
# comparison draws the same random stream.
func _blow(scene: Node, a: BattleUnit, ab: Ability, t: BattleUnit, broken := false) -> Dictionary:
	if not t.is_hero:
		t.max_hp = 100000000
		t.hp = t.max_hp
		t.statuses.clear()
	t.broken = broken
	t.pressure = 0
	t.dead = false
	var hp0: int = t.hp
	seed(SEED)
	await scene._resolve(a, ab, t, "good")
	return {"dmg": hp0 - t.hp, "bd": t.pressure}


# The hero's ordinary blow: a free, damaging ability with no `special`, so it
# resolves through the strike loop where most of these fields are read.
func _basic(h: BattleUnit) -> Ability:
	for ab in h.abilities:
		if ab.damage > 0 and ab.special == "" and ab.cost == 0:
			return ab
	return null


# A costed, damaging ability with a cooldown and no `special` — what the two
# cast-time nodes (free casts, a skipped cooldown) are about.
func _costed(heroes: Dictionary) -> Array:
	for k in ["warrior", "hunter", "mage", "cleric"]:
		var h: BattleUnit = heroes[k]
		for ab in h.abilities:
			if ab.cost > 0 and ab.cooldown > 0 and ab.special == "" and ab.damage > 0:
				return [h, ab]
	return []


# Every field §4b reads off the tree's own payloads. Named once, so a field the
# tree stops writing is reported by name rather than read as a missing key.
const DRIVEN_FIELDS := ["attack", "armor", "crit_bonus", "speed", "parry_bonus",
	"max_resource", "dmg_bonus", "dmg_taken_bonus", "broken_will_ranks",
	"blood_communion", "follow_through", "bonecracker_ranks", "last_hope_pct",
	"iron_will_ranks", "pierce_bonus", "ghillie", "whetstone", "undying_rage",
	"last_rites", "conversion_ranks", "no_cover", "devoutness_ranks",
	"sundering_shot", "no_quarter_ranks", "rapid_fire", "snap_shot"]


func _drive(scene: Node, fields: Dictionary) -> void:
	var heroes := _by_key(scene)
	var war: BattleUnit = heroes["warrior"]
	var mage: BattleUnit = heroes["mage"]
	var cleric: BattleUnit = heroes["cleric"]
	var foe: BattleUnit = scene.get("enemies")[0]
	var ab := _basic(war)
	ok(ab != null, "§4b: the Warrior has no ordinary free blow to drive the strike loop with")
	if ab == null:
		return
	var foe_ab := _basic(foe)
	ok(foe_ab != null, "§4b: the enemy has no ordinary blow to drive the taken half with")
	for u in heroes.values() + [foe]:
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = -10.0
		u.crit_bonus = -1.0
	var v := {}
	for f in fields:
		v[f] = fields[f][1]
	# A FIELD THE TREE STOPPED WRITING IS A FAILURE HERE, NEVER A THROW. FX's own
	# zero-start control found this: indexing `v` for a field no node writes
	# stopped §4b at that node, and every node after it went unread — a truncated
	# gate reads as fewer checks, not as the defect. Each missing field is named
	# here and driven at 0 below, so its own arm fails on the value it reads.
	var missing: Array = []
	for f in DRIVEN_FIELDS:
		if not v.has(f):
			missing.append(f)
			v[f] = 0
	ok(missing.is_empty(),
		"§4b: the tree no longer writes %s — each is driven at 0 below, and its node's own arm fails" % ", ".join(PackedStringArray(missing)))
	var paid := 0

	# ── TIER 1 ──
	# More Attack: the blow is made of Attack.
	var base_atk: int = war.attack
	var r0 := await _blow(scene, war, ab, foe)
	war.attack = base_atk + int(v["attack"])
	var r1 := await _blow(scene, war, ab, foe)
	war.attack = base_atk
	ok(int(r1["dmg"]) > int(r0["dmg"]), "§4b: tn_attack — a blow at +%d Attack did %d, not more than %d" % [
		int(v["attack"]), int(r1["dmg"]), int(r0["dmg"])])
	paid += 1
	# More Armor: the armor the damage pipeline reads.
	var ea0: float = war.effective_armor()
	war.armor += float(v["armor"])
	var ea1: float = war.effective_armor()
	var hit1 := await _blow(scene, foe, foe_ab, war)
	war.armor -= float(v["armor"])
	war.hp = war.max_hp
	var hit0 := await _blow(scene, foe, foe_ab, war)
	war.hp = war.max_hp
	ok(absf((ea1 - ea0) - float(v["armor"])) < 0.0001 and int(hit1["dmg"]) < int(hit0["dmg"]),
		"§4b: tn_armor — effective armor moved %s and a blow took %d against %d" % [
			str(ea1 - ea0), int(hit1["dmg"]), int(hit0["dmg"])])
	paid += 1
	# More Crit Chance: forty seeded blows, each arm, and the crits are the difference.
	var c0 := 0
	var c1 := 0
	for i in 40:
		war.crit_bonus = 0.0
		seed(SEED + i)
		foe.hp = foe.max_hp
		var h0: int = foe.hp
		await scene._resolve(war, ab, foe, "good")
		c0 += h0 - foe.hp
		war.crit_bonus = float(v["crit_bonus"])
		seed(SEED + i)
		foe.hp = foe.max_hp
		var h1: int = foe.hp
		await scene._resolve(war, ab, foe, "good")
		c1 += h1 - foe.hp
	war.crit_bonus = -1.0
	ok(c1 > c0, "§4b: tn_crit — forty blows at +%s crit did %d, not more than %d" % [
		str(v["crit_bonus"]), c1, c0])
	paid += 1
	# More Speed: the one arithmetic every turn is scheduled by.
	var sp0: float = war.effective_speed()
	war.speed += float(v["speed"])
	var sp1: float = war.effective_speed()
	war.speed -= float(v["speed"])
	ok(sp1 > sp0, "§4b: tn_speed — effective speed read %s, not above %s" % [str(sp1), str(sp0)])
	paid += 1
	# Parry More: the parry roll, over four hundred seeded draws, on a zero base.
	var p0 := 0
	var p1 := 0
	war.parry_chance = 0.0
	for i in 400:
		war.parry_bonus = 0.0
		seed(SEED + i)
		if scene._roll_parry(war) != "":
			p0 += 1
		war.parry_bonus = float(v["parry_bonus"])
		seed(SEED + i)
		if scene._roll_parry(war) != "":
			p1 += 1
	war.parry_bonus = 0.0
	ok(p0 == 0 and p1 > 400 * float(v["parry_bonus"]) * 0.5 and p1 < 400 * float(v["parry_bonus"]) * 1.5,
		"§4b: tn_parry — %d parries in 400 at +%s against %d at none" % [p1, str(v["parry_bonus"]), p0])
	paid += 1
	# A Bigger Resource Pool: Rage on a hit taken is clamped at the pool.
	war.max_resource += int(v["max_resource"])
	war.resource = 95
	war.hp = war.max_hp
	war.take_hit(1, 0)
	var rage1: int = war.resource
	war.max_resource -= int(v["max_resource"])
	war.resource = 95
	war.hp = war.max_hp
	war.take_hit(1, 0)
	var rage0: int = war.resource
	war.hp = war.max_hp
	ok(rage1 > rage0, "§4b: tn_pool — a hit at 95 Rage left %d in the bigger pool and %d in the base one" % [
		rage1, rage0])
	paid += 1
	# More Damage Dealt: the one general damage multiplier.
	var d0 := await _blow(scene, war, ab, foe)
	war.dmg_bonus = float(v["dmg_bonus"])
	var d1 := await _blow(scene, war, ab, foe)
	war.dmg_bonus = 0.0
	ok(int(d1["dmg"]) > int(d0["dmg"]), "§4b: tn_damage — %d against %d" % [int(d1["dmg"]), int(d0["dmg"])])
	paid += 1
	# Less Damage Taken: the damage-taken multiplier, on a blow the enemy lands.
	war.hp = war.max_hp
	var g0 := await _blow(scene, foe, foe_ab, war)
	war.dmg_taken_bonus = float(v["dmg_taken_bonus"])
	war.hp = war.max_hp
	var g1 := await _blow(scene, foe, foe_ab, war)
	war.dmg_taken_bonus = 0.0
	war.hp = war.max_hp
	ok(int(g1["dmg"]) < int(g0["dmg"]), "§4b: tn_guard — the Warrior took %d against %d" % [
		int(g1["dmg"]), int(g0["dmg"])])
	paid += 1

	# ── TIER 2 ──
	# You Break Harder.
	var b0 := await _blow(scene, war, ab, foe)
	war.broken_will_ranks = int(v["broken_will_ranks"])
	var b1 := await _blow(scene, war, ab, foe)
	war.broken_will_ranks = 0
	ok(int(b1["bd"]) > int(b0["bd"]), "§4b: tn_break — the blow's Break read %d against %d" % [
		int(b1["bd"]), int(b0["bd"])])
	paid += 1
	# Breaking Heals the Party: the lowest-health hero drinks from the Break.
	cleric.hp = 10
	await _blow(scene, war, ab, foe)
	var heal0: int = cleric.hp - 10
	cleric.hp = 10
	war.blood_communion = int(v["blood_communion"])
	await _blow(scene, war, ab, foe)
	var heal1: int = cleric.hp - 10
	war.blood_communion = 0
	cleric.hp = cleric.max_hp
	ok(heal1 > 0 and heal0 == 0, "§4b: tn_break_heal — the lowest hero healed %d with it and %d without" % [
		heal1, heal0])
	paid += 1
	# A Cooldown Ticks on a Crit.
	war.crit_bonus = 5.0
	war.cooldowns = {"fx_probe": 5}
	await _blow(scene, war, ab, foe)
	var cd0: int = int(war.cooldowns.get("fx_probe", 0))
	war.cooldowns = {"fx_probe": 5}
	war.follow_through = int(v["follow_through"])
	await _blow(scene, war, ab, foe)
	var cd1: int = int(war.cooldowns.get("fx_probe", 0))
	war.follow_through = 0
	war.cooldowns = {}
	ok(cd0 == 5 and cd1 == 5 - int(v["follow_through"]),
		"§4b: tn_crit_cooldown — a crit left a 5-turn cooldown at %d with it and %d without" % [cd1, cd0])
	paid += 1
	# Kill What Is Down.
	war.crit_bonus = -1.0
	var k0 := await _blow(scene, war, ab, foe, true)
	war.bonecracker_ranks = int(v["bonecracker_ranks"])
	var k1 := await _blow(scene, war, ab, foe, true)
	war.bonecracker_ranks = 0
	foe.broken = false
	ok(int(k1["dmg"]) > int(k0["dmg"]), "§4b: tn_kill_down — %d against a Broken enemy, %d without" % [
		int(k1["dmg"]), int(k0["dmg"])])
	paid += 1
	# Cleanse Debuffs Each Turn — composed, DK §1's way (see the header).
	scene._apply_status(mage, "dazed", 3)
	var pool: Array = scene._hero_side().filter(func(h): return scene._status_count(h) > 0)
	var washed: String = mage.dispel_one_debuff() if pool.has(mage) else ""
	var up := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var gi := up.find("u.field_medic > 0")
	var guard := up.substr(up.rfind("\n", gi), up.find("\n", gi) - up.rfind("\n", gi)) if gi >= 0 else ""
	ok(pool.has(mage) and washed != "" and gi >= 0 and not guard.contains("passive_id")
			and not guard.contains("hero_key") and not guard.contains("spec"),
		"§4b: tn_cleanse — pool held the afflicted hero: %s; washed '%s'; guard `%s`" % [
			str(pool.has(mage)), washed, guard.strip_edges()])
	paid += 1
	# Heal More When Low: the stamp the spawn writes, read inside the heal.
	war.hp = int(war.max_hp * 0.1)
	var hl0: int = war.heal_amount(100, true)
	war.hp = int(war.max_hp * 0.1)
	war.last_hope_bonus = int(v["last_hope_pct"])
	var hl1: int = war.heal_amount(100, true)
	war.last_hope_bonus = 0
	war.hp = war.max_hp
	ok(hl1 == int(round(hl0 * (1.0 + 0.01 * float(v["last_hope_pct"])))),
		"§4b: tn_last_hope — a 100 heal under a quarter's health gave %d with it and %d without" % [hl1, hl0])
	paid += 1
	# Mitigation per Debuff You Carry.
	war.statuses.clear()
	scene._apply_status(war, "dazed", 5)
	scene._apply_status(war, "cripple", 5)
	var n_deb: int = war.count_debuffs()
	war.hp = war.max_hp
	var iw0 := await _blow(scene, foe, foe_ab, war)
	war.iron_will_ranks = int(v["iron_will_ranks"])
	war.hp = war.max_hp
	var iw1 := await _blow(scene, foe, foe_ab, war)
	war.iron_will_ranks = 0
	war.statuses.clear()
	war.hp = war.max_hp
	ok(n_deb >= 2 and int(iw1["dmg"]) < int(iw0["dmg"]),
		"§4b: tn_iron_will — carrying %d debuffs the Warrior took %d with it and %d without" % [
			n_deb, int(iw1["dmg"]), int(iw0["dmg"])])
	paid += 1
	# Armor Penetration, into real armor.
	var foe_armor: float = foe.armor
	foe.armor = 0.5
	var pe0 := await _blow(scene, war, ab, foe)
	war.pierce_bonus = float(v["pierce_bonus"])
	var pe1 := await _blow(scene, war, ab, foe)
	war.pierce_bonus = 0.0
	foe.armor = foe_armor
	ok(int(pe1["dmg"]) > int(pe0["dmg"]), "§4b: tn_pierce — %d into 50%% armor, %d without" % [
		int(pe1["dmg"]), int(pe0["dmg"])])
	paid += 1
	# Enemies Look Past You: the evasion re-pick's own chance.
	var ev0: float = scene._evade_chance(war)
	war.ghillie = int(v["ghillie"])
	var ev1: float = scene._evade_chance(war)
	war.ghillie = 0
	ok(ev0 == 0.0 and absf(ev1 - 0.01 * float(v["ghillie"])) < 0.0001,
		"§4b: tn_look_past — the re-pick chance read %s with it and %s without" % [str(ev1), str(ev0)])
	paid += 1

	# ── TIER 3 ──
	# A Crit Pays: every crit raises Attack for the battle.
	war.crit_bonus = 5.0
	var at0: int = war.attack
	await _blow(scene, war, ab, foe)
	var dat0: int = war.attack - at0
	war.attack = at0
	war.whetstone = int(v["whetstone"])
	await _blow(scene, war, ab, foe)
	var dat1: int = war.attack - at0
	war.whetstone = 0
	war.attack = at0
	ok(dat0 == 0 and dat1 == int(v["whetstone"]),
		"§4b: tn_crit_pays — a crit raised Attack by %d with it and %d without" % [dat1, dat0])
	paid += 1
	# Your Crits Crack Guards: a crit lands Break of its own.
	var s0 := await _blow(scene, war, ab, foe)
	war.sundering_shot = int(v["sundering_shot"])
	var s1 := await _blow(scene, war, ab, foe)
	war.sundering_shot = 0
	war.crit_bonus = -1.0
	ok(int(s1["bd"]) > int(s0["bd"]), "§4b: tn_crack_guards — a crit's Break read %d with it and %d without" % [
		int(s1["bd"]), int(s0["bd"])])
	paid += 1
	# Refuse Death Once, and its rider.
	war.hp = 5
	war.dead = false
	war.undying_rage = int(v["undying_rage"])
	war.undying_rage_used = false
	war.take_hit(9999, 0)
	var survived: bool = not war.dead and war.hp == 1
	war.undying_rage = 0
	war.undying_rage_used = false
	war.dead = false
	war.hp = 5
	war.take_hit(9999, 0)
	var died: bool = war.dead or war.hp == 0
	war.dead = false
	war.hp = int(war.max_hp * 0.2)
	var ur0 := await _blow(scene, war, ab, foe)
	war.undying_rage = int(v["undying_rage"])
	war.hp = int(war.max_hp * 0.2)
	var ur1 := await _blow(scene, war, ab, foe)
	war.undying_rage = 0
	war.hp = war.max_hp
	ok(survived and died and int(ur1["dmg"]) > int(ur0["dmg"]),
		"§4b: tn_refuse_death — refused: %s; died without: %s; a blow below 25%% did %d with it and %d without" % [
			str(survived), str(died), int(ur1["dmg"]), int(ur0["dmg"])])
	paid += 1
	# Pay a Lethal Hit out of Your Resource Pool — both currencies.
	war.hp = int(war.max_hp * 0.2)
	war.resource = 50
	var hp_r: int = war.hp
	war.last_rites = int(v["last_rites"])
	war.take_hit(20, 0)
	var rage_paid: bool = war.hp == hp_r
	war.last_rites = 0
	war.hp = hp_r
	war.resource = 50
	war.take_hit(20, 0)
	var rage_unpaid: bool = war.hp == hp_r - 20
	war.hp = war.max_hp
	mage.hp = mage.max_hp
	mage.resource = mage.max_resource
	mage.conversion_ranks = int(v["conversion_ranks"])
	mage.take_hit(40, 0)
	var mana_loss1: int = mage.max_resource - mage.resource
	var hp_loss1: int = mage.max_hp - mage.hp
	mage.conversion_ranks = 0
	mage.hp = mage.max_hp
	mage.resource = mage.max_resource
	mage.take_hit(40, 0)
	var hp_loss0: int = mage.max_hp - mage.hp
	mage.hp = mage.max_hp
	ok(rage_paid and rage_unpaid and mana_loss1 > 0 and hp_loss1 < hp_loss0,
		"§4b: tn_resource_ward — Rage paid the wound: %s (without, health took it: %s); a Mage paid %d Mana and lost %d health against %d" % [
			str(rage_paid), str(rage_unpaid), mana_loss1, hp_loss1, hp_loss0])
	paid += 1
	# You Cannot Miss: a blinded attacker's miss chance.
	war.no_cover = 0
	war.statuses.clear()
	scene._apply_status(war, "blind", 3)
	var m0: float = scene._miss_chance(war)
	war.no_cover = int(v["no_cover"])
	var m1: float = scene._miss_chance(war)
	war.statuses.clear()
	ok(m0 > 0.0 and m1 == 0.0, "§4b: tn_no_miss — a blinded hero's miss chance read %s with it and %s without" % [
		str(m1), str(m0)])
	paid += 1
	# We Do Not Break: the stamp the spawn writes, read by the victim's Break block.
	war.pressure = 0
	war.broken = false
	war.take_hit(0, 40)
	var wb0: int = war.pressure
	war.pressure = 0
	scene._apply_status(war, "devotion", -1, int(v["devoutness_ranks"]))
	war.take_hit(0, 40)
	var wb1: int = war.pressure
	war.pressure = 0
	war.statuses.clear()
	ok(wb1 < wb0, "§4b: tn_unbreaking — 40 Break damage filled the meter to %d with it and %d without" % [wb1, wb0])
	paid += 1
	# Breaking an Enemy Refuels You — both currencies, off a blow that Breaks.
	var refuel := {}
	for pair in [[war, ab], [mage, _basic(mage)]]:
		var hero: BattleUnit = pair[0]
		var hab: Ability = pair[1]
		if hab == null:
			continue
		var gained := []
		for on in [0, int(v["no_quarter_ranks"])]:
			foe.max_hp = 100000000
			foe.hp = foe.max_hp
			foe.statuses.clear()
			foe.broken = false
			foe.dead = false
			foe.pressure = foe.stability - 1
			hero.no_quarter_ranks = on
			hero.resource = 10
			seed(SEED)
			await scene._resolve(hero, hab, foe, "good")
			gained.append(hero.resource - 10)
		hero.no_quarter_ranks = 0
		foe.broken = false
		foe.pressure = 0
		refuel[String(hero.hero_key)] = gained
	ok(refuel.size() == 2 and int(refuel["warrior"][1]) > int(refuel["warrior"][0])
			and int(refuel["mage"][1]) > int(refuel["mage"][0]),
		"§4b: tn_break_refuel — a Break refuelled %s (with/without, per class)" % str(refuel))
	paid += 1
	# A Chance to Skip a Cooldown Entirely, and Your First Casts of a Fight Are
	# Free — both on a costed ability with a cooldown.
	var cast := _costed(heroes)
	ok(not cast.is_empty(), "§4b: no costed ability with a cooldown and no special to drive the cast nodes with")
	if not cast.is_empty():
		var ch: BattleUnit = cast[0]
		var cab: Ability = cast[1]
		var skipped := [0, 0]
		for arm in 2:
			ch.rapid_fire = 0 if arm == 0 else int(v["rapid_fire"])
			for i in 40:
				ch.cooldowns = {}
				ch.resource = ch.max_resource
				foe.hp = foe.max_hp
				foe.pressure = 0
				foe.broken = false
				seed(SEED + i)
				await scene._resolve(ch, cab, foe, "good")
				if int(ch.cooldowns.get(cab.display_name, 0)) <= 0:
					skipped[arm] += 1
		ch.rapid_fire = 0
		ch.cooldowns = {}
		var want_skip := 40.0 * 0.01 * float(v["rapid_fire"])
		ok(skipped[0] == 0 and skipped[1] > want_skip * 0.4 and skipped[1] < want_skip * 1.6,
			"§4b: tn_skip_cooldown — %d of 40 casts skipped the cooldown with it and %d without" % [
				skipped[1], skipped[0]])
		paid += 1
		var costs := {}
		for arm in 2:
			ch.snap_shot = 0 if arm == 0 else int(v["snap_shot"])
			ch.snap_used = 0
			var row: Array = []
			for i in 3:
				ch.cooldowns = {}
				ch.resource = ch.max_resource
				foe.hp = foe.max_hp
				foe.pressure = 0
				foe.broken = false
				seed(SEED + i)
				await scene._resolve(ch, cab, foe, "good")
				row.append([ch.max_resource - ch.resource, ch.cooldowns.has(cab.display_name)])
			costs[arm] = row
		ch.snap_shot = 0
		ch.snap_used = 0
		ch.cooldowns = {}
		var free_n := int(v["snap_shot"])
		var free_ok := true
		for i in 3:
			var with_row: Array = costs[1][i]
			var none_row: Array = costs[0][i]
			if i < free_n:
				free_ok = free_ok and int(with_row[0]) < int(none_row[0]) and not bool(with_row[1])
			else:
				free_ok = free_ok and int(with_row[0]) == int(none_row[0]) and bool(with_row[1])
		ok(free_ok, "§4b: tn_free_casts — three casts [spent, cooldown started] read %s with it and %s without" % [
			str(costs[1]), str(costs[0])])
		paid += 1
	# More Health pays at the spawn and §4a measured it on every class.
	paid += 1
	ok(paid == Talents.tree().size(),
		"§4b: CHECKED %d of %d nodes' read sites" % [paid, Talents.tree().size()])
	print("  (b) %d of %d read sites driven; each moved what it is read into" % [paid, Talents.tree().size()])


# ═══ §5 — NOTHING READS A NODE BUT THE TREE'S OWN DOOR ═══════════════════════
#
# EM re-keyed fifty-six rune clauses off talent counters, and FX deleted every
# node those counters belonged to. What is left that could read a node is the
# payload `condition` door — `Talents.has_node` — so the property is that no rune
# carries a condition and nothing outside the tree's own file calls the door.
# (FX's one-off sweep for the 324 deleted ids as string literals in `scripts/`
# and `data/` found none; the ids themselves are not listed here, because a list
# of 324 deleted names is a second copy of a table the batch deleted.)

func _conditions(x: Variant) -> int:
	var n := 0
	if x is Dictionary:
		for k in x:
			if String(k) == "condition":
				n += 1
			n += _conditions(x[k])
	elif x is Array:
		for e in x:
			n += _conditions(e)
	return n


func _s5_nothing_reads_a_node() -> void:
	print("\n§5 — nothing reads a node but the tree's own door")
	var runes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var conds := 0
	for rid in runes:
		conds += _conditions(runes[rid])
	ok(conds == 0, "§5: %d rune payload(s) carry a condition — a rune reading a node" % conds)
	ok(runes.size() > 0, "§5: no runes were read — the sweep above read nothing")
	var callers: Array = []
	var files := 0
	for f in DirAccess.get_files_at("res://scripts/"):
		if not String(f).ends_with(".gd"):
			continue
		files += 1
		if String(f) == "talents.gd":
			continue
		var code := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		if code.contains("has_node("):
			callers.append(String(f))
	ok(callers.is_empty(), "§5: `has_node(` is called outside the tree's own file: %s" % str(callers))
	ok(files > 20, "§5: only %d scripts were swept — the walk read almost nothing" % files)
	var tree_conds := 0
	for t in Talents.tree():
		tree_conds += _conditions(t)
	ok(tree_conds == 0, "§5: a node carries a condition — the tree reads itself")
	print("  %d runes, 0 conditions; %d scripts swept, `has_node` only in talents.gd" % [runes.size(), files])
