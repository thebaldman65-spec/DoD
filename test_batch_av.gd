# test_batch_av.gd — HOLY: REVERSAL. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_av.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §0 THE INSTRUMENT. Nothing here reads damage share. She attacks at 50 and
#      the whole spec is contribution, so the live probes read healing landed
#      and damage prevented.
#   §1 RESURRECTION IN THE OPENING KIT — present at spawn with NO talent
#      learned, absent from SPEC_POOLS["holy"], and exactly ONE def of it in
#      the codebase (the kit calls Classes.pending_talent_ability).
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, the lane renamed VIGIL, every
#      final magnitude on the node that owes it, and every counter ADDITIVE.
#   §4 BOTH AUTHORED FALLBACKS (Divine Plea -> 1 Mercy, Intercession -> a
#      3-turn window), and AU §1's rule reaching a RUNE grant (Last Rites).
#   §5 THE RUNE AUDIT: every re-pointed counter lands on a live read site, the
#      Sleepless Vigil's by-name lane moved with the lane, and the three
#      cleric class-wide runes touch no Holy counter.
#   §6 THE BOT knows Resurrection and Intercession, and never Empowers down
#      past a raise it could otherwise make.
#   LIVE: Intercession fires once, costs a stack ON TRIGGER and not on cast,
#      and does nothing when she holds none. Serenity's cost waiver, and that
#      it does NOT alter the return health. Grace only at maximum Mercy.
#      Martyrdom's automatic return. Hour of Need and Blessed Vestments.
#   NEGATIVE CONTROLS for the two that would fail silently: Guardian Angel
#      back at 53%, and Serenity also setting the return health to full.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
#
# BATCH FX DELETED THE TREE THIS FILE WAS WRITTEN ABOUT. The twelve spec trees
# are gone (`Talents.LANE_TREES`, and every hl_* node with it); the Holy Cleric
# buys into the ONE class tree — twenty-seven `tn_*` nodes in three tiers of
# nine. EVERY FIELD READ SITE STOOD, so every MECHANIC this file drives is still
# driven, off the exact payload its retired node carried (`RETIRED`, below).
# Every question about the tree's SHAPE is asked of the one tree wherever it
# still has a subject there. What asked about the Holy tree ITSELF — its ids,
# lanes, rows, homes, names, per-node magnitudes and payload shapes — is
# deleted at its own site under DG §2, and each site says what it asked, why the
# subject is gone and how many checks went.
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
	Profile.save_path = "user://profile_batch_av_test.json"
	Profile.loaded = false
	Profile.data = {}

	_kit_and_pool()
	_tree_shape()
	_magnitudes()
	_additive_units()
	_authored_fallbacks()
	_rune_audit()
	_negative_control_source()

	await _live_kit_at_spawn()
	await _live_intercession()
	await _live_serenity()
	await _live_grace()
	await _live_martyrdom()
	await _live_vigil_and_vestments()
	await _live_last_rites_rune()
	await _live_bot_policy()
	await _live_avatar()

	if FileAccess.file_exists("user://profile_batch_av_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_av_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_av: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

# BATCH FX: the tree the Holy Cleric buys into — the ONE class tree, since the
# twelve spec trees are deleted. `generate_tree` still takes the spec.
func _tree() -> Array:
	return Talents.generate_tree("holy", "cleric")


# ---------- BATCH FX: the retired Holy nodes this suite still drives ----------
#
# FX deleted the Holy tree, and every field below kept its declaration and its
# read site (FX kept every one: a field no node writes is dormant, not deleted).
# So each live question is still asked — of the EXACT payload the retired node
# carried, lifted verbatim from HEAD's `LANE_TREES["holy"]`. `_spawn` hands each
# one it is given to the Cleric as a node BESIDE the live tree, so
# `apply_from_tree` applies it at the point in the spawn the Holy tree always
# did: after the earned picks, before the class passive, the runes and the
# upgrades. No live `tn_*` node writes any of these fields.
const RETIRED := {
	# FX: the payload the retired hl_zealous (Zealous Light) carried — the node
	# is deleted, the field and its read site stand.
	"hl_zealous": {"name": "Zealous Light", "payload": {"stat": {"zealous_mercy": 2}}},
	# FX: the payload the retired hl_martyr (Martyr's Vigor) carried — the node
	# is deleted, the field and its read site stand.
	"hl_martyr": {"name": "Martyr's Vigor", "payload": {"stat": {"mercy_cap_bonus": 3}}},
	# FX: the payload the retired hl_soothe (Soothing Touch) carried — the node
	# is deleted; the `ability` arm and its `also` are live machinery (runes).
	"hl_soothe": {"name": "Soothing Touch", "payload": {"ability": "Heal",
		"add": {"cost": -10}, "also": [{"ability": "Renewal", "add": {"cost": -10}}]}},
	# FX: the payload the retired hl_swift (Swift Mending) carried — the node is
	# deleted; the `ability` arm and its `also` are live machinery (runes).
	"hl_swift": {"name": "Swift Mending", "payload": {"ability": "Heal",
		"set": {"cooldown": 0}, "also": [{"ability": "Hymn of Hope", "add": {"cooldown": -1}}]}},
	# FX: the payload the retired hl_serenity (Serenity) carried — the node is
	# deleted; the `ability` arm is live machinery (runes).
	"hl_serenity": {"name": "Serenity", "payload": {"ability": "Resurrection",
		"set": {"faith_cost": 0, "cooldown": 1}}},
	# FX: the payload the retired hl_resurrection (Grace) carried — the node is
	# deleted, the field and its read site stand.
	"hl_resurrection": {"name": "Grace", "payload": {"stat": {"grace_pct": 20}}},
	# FX: the payload the retired hl_capacitor (Martyrdom) carried — the node is
	# deleted; the `ability` arm and the `martyrdom` field in its `also` stand.
	"hl_capacitor": {"name": "Martyrdom", "payload": {"ability": "Resurrection",
		"set": {"faith_cost": 0, "cooldown": 0}, "also": [{"stat": {"martyrdom": 1}}]}},
	# FX: the payload the retired hl_beacon (Hour of Need) carried — the node is
	# deleted, the field and its read site stand.
	"hl_beacon": {"name": "Hour of Need", "payload": {"stat": {"holy_vigil_pct": 15}}},
	# FX: the payload the retired hl_vestments (Blessed Vestments) carried — the
	# node is deleted, the field and its read site stand.
	"hl_vestments": {"name": "Blessed Vestments", "payload": {"stat": {"vestments_pct": 25}}},
	# FX: the payload the retired hl_ardor (Ardor) carried — the node is deleted,
	# the field and its read site stand.
	"hl_ardor": {"name": "Ardor", "payload": {"stat": {"ardor_at": 3}}},
	# FX: the payload the retired hl_avatar (Avatar of Mercy) carried — the node
	# is deleted, the field and its read site stand.
	"hl_avatar": {"name": "Avatar of Mercy", "payload": {"stat": {"avatar_of_mercy": 1}}},
}

# FX: every counter the retired Holy tree wrote — its 27 nodes' `stat` payloads
# and their `also` halves, inlined from HEAD's `LANE_TREES["holy"]`. The tree is
# deleted; every one of these fields is still declared on `BattleUnit`.
const HOLY_COUNTERS := ["triage_heal", "on_mend_pct", "cascade_pct", "overflow_pct",
	"heavenly_step", "holy_light_pct", "zealous_mercy", "sanctified_pct", "grace_pct",
	"ardor_at", "mercy_cap_bonus", "guardian_step", "divine_presence_pct",
	"last_hope_pct", "holy_vigil_pct", "vestments_pct", "font_of_light",
	"mercy_aegis", "watchtower", "sanctum", "avatar_of_mercy", "martyrdom"]


# FX: every cell of the ONE tree, worn — what `Profile.worn_talents` hands a
# class that has bought the whole tree (a cell owned is a cell worn).
func _all_cells() -> Dictionary:
	var out := {}
	for t in _tree():
		out[String(t["id"])] = 1
	return out


# FX: the Cleric's tree for one spawn — the live tree, plus a node for each
# RETIRED id the spawn learns. An id that is in NEITHER would apply nothing in
# silence, so it fails here instead of passing quietly.
func _member_tree(learned: Dictionary) -> Array:
	var tree := _tree()
	for id in learned:
		if not Talents.node_in_tree(tree, String(id)).is_empty():
			continue
		if not RETIRED.has(id):
			ok(false, "the spawn learns %s, which is neither a live node nor a RETIRED payload" % id)
			continue
		tree.append({"id": String(id), "name": String(RETIRED[id]["name"]), "desc": "",
			"payload": (RETIRED[id]["payload"] as Dictionary).duplicate(true)})
	return tree


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _find(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


func _hero(scene: Node, idx: int) -> BattleUnit:
	var live: Array = []
	for h in scene.get("heroes"):
		if not h.is_companion:
			live.append(h)
	return live[idx] if idx < live.size() else null


# The party is warrior/mage/cleric/hunter, so the Cleric is slot 2 and the
# learned dict is applied to HER, not to slot 1 as the AU harness did.
func _spawn(learned: Dictionary, member_patch := {},
		lineup := ["raider"]) -> Node:
	# THE CRIT ROLL MATTERS MORE HERE THAN ANYWHERE: Triage turns a heal crit
	# into a Radiant Cascade splash, so one unlucky coin doubles a measured
	# heal. Checks that WANT a crit set `crit_bonus` back themselves.
	# BATCH FX: her tree is the one tree plus any RETIRED payload the spawn learns
	# (`_member_tree`), written through `patch` — which the fixture applies AFTER
	# it sets the tree, so the fixture itself did not move.
	var patch: Dictionary = member_patch.duplicate()
	patch["tree"] = _member_tree(learned)
	return await Fixture.spawn(self, ["berserker", "pyromancer", "holy", "beastmaster"],
		{"enemies": lineup, "talents": {2: learned.duplicate()}, "patch": {2: patch},
		"deterministic": true, "crit": -10.0})


func _kill(scene: Node) -> void:
	await Fixture.kill(self, scene)


# ---------- §1 the kit and the pool ----------

func _kit_and_pool() -> void:
	var kit: Array = Classes.spec_abilities("holy")
	var names: Array = []
	for ab in kit:
		names.append(ab.display_name)
	ok(names.has("Resurrection"),
		"Resurrection is in the Holy opening kit (got %s)" % str(names))
	ok(names.size() == 4,
		"...and the kit is FOUR abilities, the deliberate parity break (got %d)" % names.size())
	for expected in ["Heal", "Renewal", "Hymn of Hope"]:
		ok(names.has(expected), "the original three survive: %s" % expected)
	# A boss cannot offer what she starts with.
	ok(not Classes.SPEC_POOLS["holy"].has("Resurrection"),
		"Resurrection LEFT SPEC_POOLS[holy] (%s)" % str(Classes.SPEC_POOLS["holy"]))
	ok(Classes.SPEC_POOLS["holy"].has("Divine Plea"),
		"...and Divine Plea is still earnable")
	# Intercession reads Mercy on trigger, so it can never be class-pool
	# eligible and is deliberately not in the spec pool either.
	ok(not Classes.SPEC_POOLS["holy"].has("Intercession"),
		"Intercession is a tree grant only, not a pool entry")
	# **DY §3 — re-pointed from `CLASS_POOLS["cleric"]` (deleted) to the live
	# class-wide offer.** Both read Mercy on trigger, so neither can ever be
	# offered to a sibling Cleric who has no stacks to pay them with — the same
	# rule, over the structure that still exists.
	ok(not Classes.class_draft_pool("cleric").has("Resurrection")
		and not Classes.class_draft_pool("cleric").has("Intercession"),
		"neither Mercy spender leaked into the CLERIC class-wide draft")
	# EXACTLY ONE DEF (the AK resolver rule): the kit list calls
	# pending_talent_ability rather than holding a second copy, so the rune
	# grant, the pool resolver and the kit can never drift apart.
	var csrc := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(csrc.count("\"display_name\": \"Resurrection\"") == 1,
		"exactly one Resurrection def exists in classes.gd")
	ok(csrc.contains("pending_talent_ability(\"Resurrection\")"),
		"...and the kit reads it from that one def")
	var res: Ability = Classes.pending_talent_ability("Resurrection")
	ok(res != null and res.faith_cost == 1 and res.cooldown == 3
		and is_equal_approx(res.delay, 4.0) and res.special == "resurrection",
		"Resurrection moved UNCHANGED: 1 Mercy, 4.0 initiative, 3cd")
	var icept: Ability = Classes.pending_talent_ability("Intercession")
	ok(icept != null, "Intercession has a def")
	if icept != null:
		# RE-POINTED AT BATCH DF. CY §1 capped a PURE BUFF at half a swing and
		# Intercession is one: its `special` is in `Ability.PURE_BUFFS` and its
		# def carries `"delay": Ability.BUFF_DELAY_CAP` outright, so the 2.0 this
		# pinned is a pre-CY number. The literal is kept rather than read off the
		# constant — a check that reads the number it is checking has stopped
		# asking its question (CE's rule).
		ok(icept.cost == 25 and icept.cooldown == 4
			and is_equal_approx(icept.delay, 1.0),
			"Intercession is 25 Mana, 1.0 initiative, 4cd")
		ok(icept.faith_cost == 0,
			"Intercession carries NO faith_cost — the Mercy is paid on trigger")


# ---------- §3 the shape ----------

# BATCH FX — THE HOLY TREE IS DELETED, SO THIS SECTION ASKS WHAT STILL HAS A
# SUBJECT. The tree the Holy Cleric buys into is the ONE class tree; its size,
# its partition into tiers, the rank each node is worn at, its distinct ids and
# the absence of any capstone flag or exclusive node are questions with true
# answers there, and each is asked of it below. The per-node walk covers 27
# nodes, as it covered the Holy tree's 27.
func _tree_shape() -> void:
	var tree := _tree()
	# RE-POINTED (FX): the one tree holds 27 nodes — three tiers of nine.
	ok(tree.size() == 27,
		"the one tree the Holy Cleric buys into holds 27 nodes (got %d)" % tree.size())
	# A cell owned is a cell worn, and the handoff is where a node's RANK comes
	# from now — so "a single rank" is asked of what the handoff wears.
	var every_cell := {}
	for t in tree:
		every_cell[String(t["id"])] = true
	var worn := Talents.worn_learned(tree, every_cell)
	var per_tier := {}
	var ids := {}
	for t in tree:
		ids[String(t["id"])] = true
		var tier := int(t.get("tier", 0))
		per_tier[tier] = int(per_tier.get(tier, 0)) + 1
		# RE-POINTED (FX): the one tree has NO capstone row, so every node stands
		# where the old `else` branch stood — off it — and none may claim the flag.
		ok(not bool(t.get("capstone", false)),
			"%s claims no capstone flag — the one tree has no capstone row" % t["id"])
		# RE-POINTED (FX): asked of the rank the FX handoff wears the node at.
		ok(int(worn.get(String(t["id"]), 0)) == 1, "%s is worn at a single rank" % t["id"])
		# RE-POINTED (FX): the one tree, where no node is exclusive at all.
		ok(not t.has("exclusive_with"),
			"%s carries no leftover exclusive_with" % t["id"])
	# FX: DG §2 — 2 CHECKS DELETED HERE. They asked that the Holy tree's lanes
	# were Radiance / Mercy / VIGIL, and that nothing still called the third lane
	# Sanctuary. FX deleted the twelve spec trees and the one tree has no lanes,
	# so the subject exists nowhere a check can read it.
	# RE-POINTED (FX): "each lane holds its 7 row nodes" becomes "each TIER holds
	# its nine" — the one tree's partition, asked of the one tree.
	for tier in range(1, Talents.TIERS + 1):
		ok(int(per_tier.get(tier, 0)) == Talents.NODES_PER_TIER,
			"tier %d holds %d nodes (got %s)" % [tier, Talents.NODES_PER_TIER,
				per_tier.get(tier, 0)])
	# FX: DG §2 — 1 CHECK DELETED HERE ("three capstones"). The one tree has no
	# capstone row; the per-node walk above asks that no node claims one.
	# FX: DG §2 — 24 CHECKS DELETED HERE. "id survives and re-specs in place" was
	# AV's promise that every Holy id survived, and the reason no save version
	# moved. FX deleted every one (Profile moved to v3; `Run._migrate_trees` drops
	# a retired id from a saved member), so there is no id left for it to find.
	# RE-POINTED (FX): no id is carried twice in the one tree.
	ok(ids.size() == 27,
		"the one tree carries 27 distinct ids — none twice (got %d distinct)" % ids.size())
	# FX: DG §2 — 16 CHECKS DELETED HERE: the 9 "sits at <lane> row <n>" homes
	# the batch named by hand, and the 7 "is named <name>" renames (Grace, Inner
	# Faith, Hour of Need, Martyrdom, Sanctum, Serenity, Blessed Vestments). Both
	# asked where a Holy node sat and what it was called; FX deleted the nodes,
	# the lanes and the rows. The mechanics under five of those names are still
	# driven live below, off `RETIRED`.


# ---------- §3 the magnitudes, which are final ----------

func _magnitudes() -> void:
	# **BATCH FX — 26 CHECKS DELETED HERE, UNDER DG §2.** This section asked each
	# Holy node to carry its final magnitude: 17 of the 18 "node writes field = N"
	# rows; the 8 that read the SHAPE of an ability-editing payload (Soothing
	# Touch and Swift Mending — the `add` / `set` and their `also` halves —
	# Serenity with "touches NOTHING ELSE", and Martyrdom's `set` and `also`); and
	# "the three capstones sit on three different lanes". FX deleted the twelve
	# spec trees, so no node carries those numbers or shapes and there are no
	# lanes. THE FIELDS AND READ SITES STAND: §5 below still pins every read
	# site's units, and the live sections drive each payload — inlined from
	# `RETIRED` — through the spawn and assert what it pays.
	# RE-POINTED (FX): Last Hope is the one row with a precedent-mapped node in
	# the one tree — tn_last_hope carries hl_last_hope's field and magnitude.
	var got = _stat_of("tn_last_hope", "last_hope_pct")
	ok(got != null and int(got) == 40,
		"tn_last_hope writes last_hope_pct = 40, Last Hope's own number (got %s)" % got)


# ---------- §5 additive, not ranked ----------

# Every counter must hold its OWN magnitude in the units its read site sums.
# Asserted against the SOURCE, because a read site that still multiplies by a
# rank pays a node's 15 as 45 and nothing crashes.
func _additive_units() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for pair in [
			# BATCH EM: the Triage Ward and the Open Hand write `rune_triage_heal`
			# now, and the site sums the pair. Still a magnitude, still no rank.
			["0.01 * (caster.triage_heal + caster.rune_triage_heal)", "Triage"],
			["0.01 * (5 + caster.heavenly_step) * caster.second_resource", "Heavenly Aura"],
			["0.01 * attacker.holy_light_pct", "Holy Light"],
			["0.01 * mend_pct", "On the Mend"],
			["0.01 * caster.cascade_pct", "Radiant Cascade"],
			["0.01 * _overflow_share(caster)", "Overflow"],
			# BATCH EN — the last of EM's 59. Divine Presence sums its two halves
			# into a LOCAL, because the GUARD is what goes silently dead on a
			# Holy Cleric holding the Rune of the Sleepless Vigil and not the
			# node (DP's case, measured live at EN: 81 fires -> 0). Both the
			# local and its use are pinned, exactly as AX pins Spread of Madness.
			["var dp_pct := u.divine_presence_pct + u.rune_divine_presence_pct",
				"Divine Presence (both halves)"],
			["* dp_pct * _healing_done_mult(u)", "Divine Presence"],
			["0.01 * hv_c.holy_vigil_pct", "Hour of Need"],
			["0.01 * caster.vestments_pct", "Blessed Vestments"],
			["0.01 * cleric.grace_pct", "Grace"],
			["0.01 * cleric.sanctified_pct", "Sanctified"],
			["0.5 + 0.01 * ga_step", "Guardian Angel"]]:
		ok(bsrc.contains(String(pair[0])),
			"%s reads its counter additively (%s)" % [pair[1], pair[0]])
	ok(usrc.contains("0.01 * last_hope_bonus"),
		"Last Hope reads its stamp additively")
	# No old ranked read site may survive anywhere.
	for dead in ["triage_ranks", "heavenly_ranks", "holy_light_ranks",
			"guardian_ranks", "last_hope_ranks", "on_mend_ranks",
			"sanctified_ranks", "cascade_ranks", "overflow_ranks",
			"ardor_ranks", "vestments_ranks", "divine_presence_ranks",
			"living_sanctum", "serenity_guard"]:
		ok(not bsrc.contains(dead) and not usrc.contains(dead),
			"the ranked counter %s is gone from every read site" % dead)
	# THE ONE PLACE THE SANCTIFIED ROLL HAPPENS — one rule, and the SPENDERS
	# ARE WHAT GROWS. CE took it from three callers to four (Observance's
	# second Mercy) and BATCH CG §1 DELETED THAT CARD, so it is back to three.
	# RE-POINTED IN PLACE RATHER THAN LOOSENED: the question — is there exactly
	# ONE definition and does every spender go through it — is unchanged, and a
	# count is what makes the next spender come and say so.
	ok(bsrc.count("func _sanctified_refund") == 1
		and bsrc.count("_sanctified_refund(") == 4,
		"the Sanctified roll has one definition and THREE callers (faith_cost, Empower, Intercession)")
	# THE ONE PLACE THE OVERFLOW SHARE IS DECIDED.
	ok(bsrc.count("func _overflow_share") == 1,
		"the overflow share has exactly one implementation")
	# RUNE-ONLY, READ SITES KEPT (the AR vault pattern) rather than deleted.
	for kept in ["capacitor_ranks", "beacon_ranks"]:
		ok(bsrc.contains(kept) and usrc.contains(kept),
			"%s is rune-only now but its read site is KEPT and gated" % kept)


# ---------- §4 the two authored fallbacks ----------

# **BATCH DO INVERTED THIS SECTION.** AV authored two fallbacks so that a node
# granting what the hero already held would not be dead. DO's charter removes
# the premise — a talent may not grant an ability at all — so both cards moved
# into `SPEC_DRAFT_POOLS` and both cells were re-authored. There is no collision
# left to fall back FROM, and a fallback for a grant that cannot happen would be
# machinery nothing can reach.
func _authored_fallbacks() -> void:
	# **BATCH FX — 3 CHECKS DELETED HERE, UNDER DG §2.** "Divine Plea's cell hands
	# out NOTHING", "Intercession's cell hands out NOTHING" and the Intercession
	# twin of "...so it carries no fallback" asked about two cells of the Holy tree
	# (hl_divine_plea, hl_inner_faith), and FX deleted that tree. What the four
	# asked is still asked — of EVERY cell of the one tree: whether it grants (the
	# walk below) and whether it carries a collision fallback (once, over all 27).
	ok(Classes.spec_draft_pool("holy").has("Divine Plea"),
		"...while the card itself drafts from the Cleric")
	ok(Classes.spec_draft_pool("holy").has("Intercession"),
		"...and Intercession drafts from the Cleric — earnable for the first time")
	# RE-POINTED (FX): "...so it carries no collision fallback", of the whole tree.
	var arms := 0
	for t in _tree():
		if (t.get("payload", {}) as Dictionary).has("upgrade"):
			arms += 1
	ok(arms == 0, "no cell of the one tree carries a collision fallback (%d of %d do)"
		% [arms, _tree().size()])
	# NOW EVERY CELL IN HER TREE IS IN THAT POSITION, not just the capstones.
	# RE-POINTED (FX): her tree is the one tree, and it grants nothing at all.
	for cap in _tree():
		ok(Talents.granted_name(cap.get("payload", {})) == "",
			"%s grants no ability, so it owes no fallback" % String(cap["id"]))
	# AU §1's rule reaching a RUNE grant needed no new machinery, and that is
	# the finding: runes share Talents.apply_payload, so _collided already
	# fires for them and Run.apply_upgrades already runs after the rune pass.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var rune_at := bsrc.find("Talents.apply_payload(cfg, rune[\"payload\"]")
	var upg_at := bsrc.find("Run.apply_upgrades(Run.party[i]")
	ok(rune_at > 0 and upg_at > rune_at,
		"the rune pass runs BEFORE apply_upgrades, so a rune grant's fallback resolves")


# ---------- §5 the rune audit ----------

func _rune_audit() -> void:
	var probe := BattleUnit.new()
	for id in ["triage_ward", "sleepless_vigil", "open_hand"]:
		var e: Dictionary = Runes.config(id)
		ok(String(e.get("scope", "")) == "spec:holy", "%s is a Holy spec rune" % id)
		for field in Runes.build(id)["payload"].get("stat", {}):
			var f := String(field)
			ok(f in probe, "%s writes a LIVE field: %s" % [id, f])
			# JSON parses every number as a float and BattleUnit.setup() pushes
			# cfg straight into typed vars — the Batch AA trap, and every one
			# of these fields is an int.
			ok(typeof(Runes.build(id)["payload"]["stat"][f]) == TYPE_INT
					or f == "speed",
				"%s: %s survived typing as an int" % [id, f])
	probe.free()
	# The re-points, by their advertised numbers.
	var tw: Dictionary = Runes.build("triage_ward")["payload"]["stat"]
	# BATCH EM RE-KEYED THE RUNE SIDE IN PLACE. The charter disconnects runes
	# from the talent trees, so each clause below writes `rune_X` instead of
	# the node's `X` and the read site sums the pair. **NOT ONE MAGNITUDE
	# MOVED** — the question these checks ask is the same one, of the field
	# the rune now owns.
	ok(int(tw.get("rune_triage_heal", 0)) == 3,
		"the Triage Ward pays its advertised 3%% (got %s)" % tw.get("rune_triage_heal", 0))
	var oh: Dictionary = Runes.build("open_hand")["payload"]["stat"]
	ok(int(oh.get("rune_triage_heal", 0)) == 3
		and int(oh.get("rune_last_hope_pct", 0)) == 5
		and int(oh.get("rune_zealous_mercy", 0)) == 1,
		"the Open Hand pays 3%% healing, 1 opening Mercy and 5%% to the nearly-dead")
	var sv: Dictionary = Runes.build("sleepless_vigil")["payload"]["stat"]
	# BATCH EN RE-KEYED THIS CLAUSE. The question is unchanged — does the rune
	# pay its advertised 2%? — and it is asked of the field the rune now OWNS.
	# The bare name is checked ABSENT as well: a payload writing both halves
	# would pay a holder of the node twice.
	ok(int(sv.get("rune_divine_presence_pct", 0)) == 2
		and not sv.has("divine_presence_pct"),
		"the Sleepless Vigil pays its advertised 2%% and pays it once")
	# **BATCH FX — 10 CHECKS DELETED HERE, UNDER DG §2.** "the Sleepless Vigil's
	# lane tag moved Sanctuary -> Vigil" and the walk of the nine spec:holy runes,
	# "%s's lane tag names a live Holy lane", asked that a rune's by-name lane
	# reference found a lane of the Holy tree, so it was not homeless in the bot's
	# build policy or the per-lane coverage test. FX deleted the trees, the one
	# tree has no lanes, and the per-lane build policy went with them: a tag can
	# name nothing live, and nothing in `scripts/` reads a rune's `lane` (only
	# `Runes.build` copies it onto the instance). Three retired Holy runes still
	# carry one (Radiance, Mercy, Vigil) — inert data, reported rather than touched.
	# THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO HOLY COUNTER.
	# RE-POINTED (FX): the Holy counters are the FIELDS the retired Holy tree
	# wrote, every one still declared and read, so the set is `HOLY_COUNTERS`
	# rather than a walk of a tree that no longer holds them. (The one tree's own
	# fields are general stats — `speed`, which the Martyr rune writes, among
	# them — and a rune sharing unit math is not talent-keyed: EM's UNIT_MATH.)
	for id in ["zealotry", "martyr", "binding_souls"]:
		var cfg2: Dictionary = Runes.config(id)
		ok(String(cfg2.get("scope", "")) == "class:cleric", "%s is class-wide" % id)
		for f3 in cfg2["payload"].get("stat", {}):
			ok(not HOLY_COUNTERS.has(String(f3)),
				"%s must not write the Holy tree counter %s" % [id, f3])
	# LAST RITES: its grant now COLLIDES rather than granting, so its text has
	# to stop promising an ability she already owns.
	var lr: Dictionary = Runes.config("last_rites")
	ok(not String(lr.get("desc", "")).begins_with("Grants RESURRECTION"),
		"the Last Rites no longer advertises granting what she starts with")


# ---------- negative controls ----------

# The two that would fail SILENTLY: a Guardian Angel still paying the old 53%
# window reads as a working node, and a Serenity that also set the return
# health to full would look like a generous capstone rather than a bug that
# makes Empower pointless.
func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not bsrc.contains("0.5 + 0.03 *"),
		"NEGATIVE CONTROL: no path leaves the Mercy window at 50 + 3 (the old 53%)")
	# **BATCH FX — 5 CHECKS DELETED HERE, UNDER DG §2.** "Guardian Angel is 15
	# points, not 3" read the magnitude off hl_guardian, and "a reversal node
	# touches only cost and cooldown" (four: two fields each) read the `set` of
	# hl_serenity and hl_capacitor. FX deleted all three nodes. The SOURCE halves
	# stand and are asserted here — no 53% window survives (above), exactly one
	# reassignment of the return health, nothing named Serenity reaches it
	# (below) — and `_live_serenity` / `_live_martyrdom` drive both retired
	# payloads, inlined from `RETIRED`, and measure the return health untouched.
	# The return health lives in ONE place — the resurrection branch — and no
	# talent field reaches it.
	# BATCH CQ §3 — RE-POINTED TO THE FOLDED SOURCE. CN §3 folded the perfect's
	# 25% into the base, so the ternary this pinned is gone and 25% is what a
	# raise returns. Empower's 100% reassignment is what the block below still
	# guards, and that is untouched.
	ok(bsrc.contains("var rez_frac := 0.25"),
		"the return health is 25% since CN's fold / 100% Empowered")
	# EXACTLY ONE reassignment exists — Empower's. A Serenity or Martyrdom that
	# also moved it would add a second, and would read as generosity rather
	# than as the thing that makes Empower pointless.
	ok(bsrc.count("rez_frac = ") == 1,
		"NEGATIVE CONTROL: only Empower may reassign the return health (found %d)" % bsrc.count("rez_frac = "))
	ok(not bsrc.contains("serenity") and not bsrc.contains("rez_frac = 1.0 if"),
		"NEGATIVE CONTROL: nothing named Serenity can reach rez_frac")


# ---------- live: the kit at spawn ----------

func _live_kit_at_spawn() -> void:
	var scene := await _spawn({})
	var c := _hero(scene, 2)
	ok(c != null and c.second_resource_name == "Mercy", "slot 2 is the Holy Cleric")
	var res := _find(c, "Resurrection")
	ok(res != null, "Resurrection is in hand at spawn with NO talent learned")
	if res != null:
		ok(res.faith_cost == 1 and res.cooldown == 3,
			"...at its unchanged 1 Mercy / 3cd")
	ok(_find(c, "Divine Plea") == null,
		"Divine Plea is NOT in hand without its node")
	ok(_find(c, "Intercession") == null,
		"Intercession is NOT in hand without its node")
	ok(c.second_resource == 0, "she opens at 0 Mercy without Zealous Light")
	ok(c.second_max == 5, "...against the base ceiling of 5")
	await _kill(scene)
	# The two grants, and the repriced openers, on a full build.
	# RE-POINTED (FX): the build wears EVERY cell of the one tree, so the DO
	# checks below are asked of the tree the Cleric really buys, plus the four
	# retired payloads the repricing checks drive (Zealous Light, Martyr's Vigor,
	# Soothing Touch, Swift Mending), inlined from `RETIRED`. It learned
	# hl_divine_plea and hl_inner_faith for the DO checks; FX deleted both cells.
	var built_learned := _all_cells()
	for id in ["hl_zealous", "hl_martyr", "hl_soothe", "hl_swift"]:
		built_learned[id] = 1
	var built := await _spawn(built_learned)
	var c2 := _hero(built, 2)
	# BATCH DO: the two cards are DRAFTED now, so a build that buys the cells
	# and nothing else holds neither. That is the charter working, not a gap.
	ok(_find(c2, "Divine Plea") == null,
		"wearing every cell of the one tree grants no Divine Plea (DO; FX)")
	ok(_find(c2, "Intercession") == null, "...nor Intercession (DO; FX)")
	ok(c2.second_resource == 2, "Zealous Light opens her on 2 Mercy (got %d)" % c2.second_resource)
	ok(c2.second_max == 8, "Martyr's Vigor raises the ceiling to 8 (got %d)" % c2.second_max)
	var heal := _find(c2, "Heal")
	var ren := _find(c2, "Renewal")
	var hymn := _find(c2, "Hymn of Hope")
	ok(heal != null and heal.cost == 10, "Soothing Touch: Heal costs 10 (got %s)" % heal.cost)
	ok(ren != null and ren.cost == 10, "...and Renewal costs 10 (got %s)" % ren.cost)
	ok(heal != null and heal.cooldown == 0, "Swift Mending: Heal has NO cooldown")
	ok(hymn != null and hymn.cooldown == 1, "...and Hymn drops to 1 (got %s)" % hymn.cooldown)
	await _kill(built)


# ---------- live: Intercession ----------

func _live_intercession() -> void:
	# (i) NOTHING WHEN SHE HOLDS NONE. The window is open, the blow lands, the
	# hero dies — the price is paid on TRIGGER, so an empty hand buys nothing.
	# FX: these three spawns learned hl_inner_faith, which granted Intercession
	# before DO and has been irrelevant here since — every check below lays the
	# window by hand. FX deleted the node, so they learn nothing.
	var empty := await _spawn({})
	var c := _hero(empty, 2)
	var victim := _hero(empty, 0)
	c.second_resource = 0
	# THE TRAP THIS LINE EXISTS FOR: a hero falling from ABOVE the Mercy
	# window crosses it on the way down and earns her the very stack the
	# refusal then spends — so the probe has to start the victim already
	# under the line, or it measures a net of zero and calls it a pass.
	victim.hp = int(victim.max_hp * 0.2)
	empty._apply_status(victim, "intercession", 2)
	victim.take_hit(victim.hp + 500, 0)
	ok(victim.dead,
		"holding NO Mercy, the refusal does not fire and the hero dies")
	ok(c.second_resource == 0, "...and nothing was spent")
	await _kill(empty)
	# (ii) IT FIRES, ONCE, AND COSTS A STACK ON TRIGGER.
	var live := await _spawn({})
	var c2 := _hero(live, 2)
	c2.second_resource = 3
	c2.sanctified_pct = 0  # the refund roll is a separate node; force the spend
	var v1 := _hero(live, 0)
	var v2 := _hero(live, 3)
	v1.hp = int(v1.max_hp * 0.2)   # already under the Mercy window (see above)
	v2.hp = int(v2.max_hp * 0.2)
	var before := c2.second_resource
	live._apply_status(v1, "intercession", 2)
	live._apply_status(v2, "intercession", 2)
	ok(before == 3, "she holds 3 Mercy with the window open — the CAST cost none")
	v1.take_hit(v1.hp + 500, 0)
	ok(not v1.dead and v1.hp == 1,
		"the lethal blow is refused: %s survives at 1 HP" % v1.unit_name)
	ok(c2.second_resource == before - 1,
		"...and exactly 1 Mercy leaves her hand ON TRIGGER (%d -> %d)" % [
			before, c2.second_resource])
	ok(not v1.has_status("intercession") and not v2.has_status("intercession"),
		"spending it clears the window for the WHOLE party")
	v2.take_hit(v2.hp + 500, 0)
	ok(v2.dead, "the second lethal blow lands — one refusal, not a standing ward")
	await _kill(live)
	# (ii-b) THE INTERACTION WORTH PINNING: a hero falling from FULL health
	# crosses the Mercy window on the way down, so their own fall earns her
	# the stack the refusal spends. It is free exactly once, and only against
	# a genuine one-shot — anyone already wounded pays for it properly.
	var oneshot := await _spawn({})
	var c5 := _hero(oneshot, 2)
	c5.second_resource = 0
	c5.sanctified_pct = 0
	var v3 := _hero(oneshot, 0)
	v3.hp = v3.max_hp
	oneshot._apply_status(v3, "intercession", 2)
	v3.take_hit(v3.hp + 500, 0)
	ok(not v3.dead and v3.hp == 1,
		"a one-shot from full health is refused even from an empty hand")
	ok(c5.second_resource == 0,
		"...because the fall itself earned the stack it spent (%d)" % c5.second_resource)
	await _kill(oneshot)
	# (iii) THE WINDOW LENGTH, cast for real, and the authored fallback.
	# RE-POINTED (FX): the fallback question is asked of a Cleric wearing EVERY
	# cell of the one tree — none of which grants, so nothing can collide.
	var short_w := await _spawn(_all_cells())
	var c3 := _hero(short_w, 2)
	ok(c3.intercession_long == 0, "no fallback without an earned copy")
	await _kill(short_w)
	var long_w := await _spawn(_all_cells(),
		{"bm_abilities": ["Intercession"]})
	var c4 := _hero(long_w, 2)
	# BATCH DO: `intercession_long` is READ-ONLY-ZERO — an `upgrade` arm fires
	# only on a grant collision, and no talent grants. The read site below is
	# still live code, so the branch is driven from here rather than left
	# unreachable and unproved.
	ok(c4.intercession_long == 0,
		"`intercession_long` is read-only-zero — nothing grants (DO's charter)")
	ok(_find(c4, "Intercession") != null, "...and she still holds exactly one copy")
	var copies := 0
	for ab in c4.abilities:
		if ab.display_name == "Intercession":
			copies += 1
	ok(copies == 1, "no double grant (got %d copies)" % copies)
	await _kill(long_w)


# ---------- live: Serenity ----------

func _live_serenity() -> void:
	var plain := await _spawn({})
	var c0 := _hero(plain, 2)
	var r0 := _find(c0, "Resurrection")
	ok(r0 != null and r0.faith_cost == 1 and r0.cooldown == 3,
		"without Serenity the raise costs 1 Mercy on a 3-turn cooldown")
	await _kill(plain)
	# FX: hl_serenity is inlined from `RETIRED` — the exact payload it carried.
	var scene := await _spawn({"hl_serenity": 1})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	ok(res != null, "Resurrection is still in hand with Serenity learned")
	if res != null:
		ok(res.faith_cost == 0, "Serenity: the raise costs NO Mercy")
		ok(res.cooldown == 1, "...and its cooldown is 1 (got %s)" % res.cooldown)
		# THE THING THE BATCH SAYS IT MUST NOT DO. Empower's whole payload is
		# the return health; a Serenity that also set it would make Empower
		# pointless, and it would look like generosity rather than a bug.
		ok(res.special == "resurrection",
			"...and it is still the same ability, not a re-specced one")
	var fallen := _hero(scene, 0)
	fallen.take_hit(fallen.hp + 500, 0)
	ok(fallen.dead, "an ally falls")
	c.second_resource = 0
	await scene._resolve_special(c, res, fallen, "good", 1.0)
	ok(not fallen.dead, "...and she raises them holding NO Mercy at all")
	var frac := float(fallen.hp) / float(fallen.max_hp)
	ok(abs(frac - 0.25) < 0.03,
		"THE RETURN HEALTH IS UNTOUCHED by Serenity at 25%% (got %.0f%%)" % (frac * 100.0))
	_report.append("Serenity raise returns %.0f%% health — Empower's 100%% is untouched"
		% (frac * 100.0))
	await _kill(scene)


# ---------- live: Grace ----------

func _live_grace() -> void:
	# FX: hl_resurrection (Grace) is inlined from `RETIRED` — the exact payload.
	var scene := await _spawn({"hl_resurrection": 1})
	var c := _hero(scene, 2)
	ok(c.grace_pct == 20, "Grace is stamped at 20%% of her maximum health")
	var ally := _hero(scene, 0)
	# BELOW the ceiling: the crossing pays a STACK and Grace stays silent.
	c.second_resource = 0
	ally.hp = ally.max_hp
	ally.take_hit(int(ally.max_hp * 0.6), 0)
	ok(c.second_resource == 1, "below the ceiling, the crossing earns a stack")
	var hp_after_stack := ally.hp
	ok(hp_after_stack == ally.max_hp - int(ally.max_hp * 0.6),
		"...and Grace does NOT fire (no healing landed)")
	# AT the ceiling: the stack she cannot hold becomes healing.
	c.second_resource = c.second_max
	ally.hp = ally.max_hp
	var expected := int(round(c.max_hp * 0.20 * scene._healing_done_mult(c)))
	ally.take_hit(int(ally.max_hp * 0.6), 0)
	var landed := ally.hp - (ally.max_hp - int(ally.max_hp * 0.6))
	ok(c.second_resource == c.second_max, "at the ceiling she gains no stack")
	ok(landed > 0, "GRACE FIRES: the wasted stack heals the ally (%d)" % landed)
	ok(abs(landed - int(round(expected * ally.healing_received_mult))) <= 2,
		"...for 20%% of her max health, Mercy-scaled (got %d, want ~%d)" % [
			landed, int(round(expected * ally.healing_received_mult))])
	await _kill(scene)
	# Without the node, a wasted crossing stays wasted.
	var bare := await _spawn({})
	var c2 := _hero(bare, 2)
	var a2 := _hero(bare, 0)
	c2.second_resource = c2.second_max
	a2.hp = a2.max_hp
	var hp_was := a2.hp
	a2.take_hit(int(a2.max_hp * 0.6), 0)
	ok(a2.hp == hp_was - int(a2.max_hp * 0.6),
		"without Grace the crossing at the ceiling pays nothing at all")
	await _kill(bare)


# ---------- live: Martyrdom ----------

func _live_martyrdom() -> void:
	# FX: hl_capacitor (Martyrdom) is inlined from `RETIRED` — the exact payload.
	var scene := await _spawn({"hl_capacitor": 1})
	var c := _hero(scene, 2)
	ok(c.martyrdom == 1, "Martyrdom is stamped on the Cleric")
	var res := _find(c, "Resurrection")
	ok(res != null and res.faith_cost == 0 and res.cooldown == 0,
		"Martyrdom: the raise costs no Mercy and has no cooldown")
	var first := _hero(scene, 0)
	first.take_hit(first.hp + 500, 0)
	ok(not first.dead, "the FIRST hero to fall is returned automatically")
	var frac := float(first.hp) / float(first.max_hp)
	ok(abs(frac - BattleUnit.MARTYRDOM_RETURN) < 0.03,
		"...at 30%% health (got %.0f%%)" % (frac * 100.0))
	var second := _hero(scene, 3)
	second.take_hit(second.hp + 500, 0)
	ok(second.dead, "the SECOND falls for real — once per battle, not a standing net")
	await _kill(scene)


# ---------- live: Hour of Need and Blessed Vestments ----------

func _live_vigil_and_vestments() -> void:
	# SHARED VIGIL. The same blow, twice, differing only in whether ANYONE is
	# under the line — so the 15% is measured rather than asserted.
	# FX: hl_beacon (Hour of Need) is inlined from `RETIRED` — the exact payload.
	var scene := await _spawn({"hl_beacon": 1})
	var c := _hero(scene, 2)
	ok(c.holy_vigil_pct == 15, "Hour of Need is stamped at 15%")
	var foe = scene.get("enemies")[0]
	var mark := _hero(scene, 0)
	for h in scene.get("heroes"):
		h.hp = h.max_hp
	mark.armor = 0.0
	# BATCH BM RE-POINTED THIS IN PLACE, AND THE REASON GENERALISES.
	# `_swing` re-seeds the global RNG before each call, but the battle's own
	# `_run_battle` loop is ADVANCING CONCURRENTLY on real timers and draws
	# from the same RNG, so two "identical" seeded swings do NOT roll the same
	# raw damage — measured 55.4 and 67.2 on one pair. That is the harness race
	# CLAUDE.md already records against test_batch_al's Spite check, arriving
	# through a second door. Instrumenting the read site showed Hour of Need
	# firing exactly as designed (`hv_c=true below=true`, -15% applied), so the
	# check was measuring the roll, not the node. IT AVERAGES FIVE SWINGS A SIDE
	# NOW: the roll is +/-10% about its mean, so five samples put the mean well
	# inside the 15% the node pays, and the check asks its original question
	# again instead of asking about the RNG.
	var plain_hit := 0.0
	for _p in 5:
		mark.hp = mark.max_hp
		plain_hit += mark.max_hp - await _swing(scene, foe, mark, 60)
	plain_hit /= 5.0
	# Put SOMEONE under 30% (the Cleric herself counts as "any hero") and
	# swing the identical blow again.
	c.hp = int(c.max_hp * 0.2)
	var covered_hit := 0.0
	for _q in 5:
		mark.hp = mark.max_hp
		covered_hit += mark.max_hp - await _swing(scene, foe, mark, 60)
	covered_hit /= 5.0
	ok(covered_hit < plain_hit,
		"the party takes less while a hero is at death's door (%.1f -> %.1f)" % [
			plain_hit, covered_hit])
	if plain_hit > 0:
		var cut := 1.0 - float(covered_hit) / float(plain_hit)
		# The tolerance was 1.5 points when the two swings were believed to be
		# exact; averaged over five noisy rolls a side it is +/-5 points, which
		# still separates 15% from 0% (the only failure that matters here) by
		# three times the band.
		ok(abs(cut - 0.15) < 0.05,
			"...and the cut is 15%% (got %.1f%%)" % (cut * 100.0))
		_report.append("Hour of Need measured at %.1f%% damage taken" % (cut * 100.0))
	await _kill(scene)
	# BLESSED VESTMENTS: her healing leaves a barrier worth a quarter of it.
	# FX: hl_vestments is inlined from `RETIRED` — the exact payload it carried.
	var vest := await _spawn({"hl_vestments": 1})
	var c2 := _hero(vest, 2)
	ok(c2.vestments_pct == 25, "Blessed Vestments is stamped at 25%")
	var ally := _hero(vest, 0)
	ally.hp = int(ally.max_hp * 0.3)
	ally.remove_status("barrier")
	var heal := _find(c2, "Heal")
	await vest._resolve_special(c2, heal, ally, "good", 1.0)
	ok(ally.has_status("barrier"), "the heal leaves cloth-of-light behind")
	if ally.has_status("barrier"):
		var st: Dictionary = ally.get_status("barrier")
		ok(int(st.get("turns", 0)) == 2, "...for 2 turns (got %s)" % st.get("turns", 0))
		ok(int(st.get("power", 0)) > 0,
			"...worth a share of the heal (%d)" % int(st.get("power", 0)))
		_report.append("Blessed Vestments ward = %d off a Heal" % int(st.get("power", 0)))
	await _kill(vest)


# One swing of a plain attack, returning the target's HP after. THE SEED IS
# LOAD-BEARING: every hit rolls randf_range(0.9, 1.1) for variance, so two
# swings that differ only in a 15% mitigation can read anywhere from 11% to
# 17% apart. Seeding both swings identically makes the DIFFERENCE the only
# thing that moves — the AK/AS discipline of forcing determinism rather than
# widening the tolerance until the noise fits inside it.
func _swing(scene: Node, attacker: BattleUnit, target: BattleUnit, dmg: int) -> int:
	seed(20260808)
	var ab: Ability = Ability.make({"display_name": "Probe", "damage": dmg,
		"dmg_type": "physical", "delay": 2.0})
	await scene._resolve(attacker, ab, target, "good", true)
	return target.hp


# ---------- live: AU §1 reaching a rune grant ----------

func _live_last_rites_rune() -> void:
	# The Rune of the Last Rites grants Resurrection — which she now starts
	# with. Rather than a knowingly dead Epic, AU §1's rule reaches it: runes
	# share Talents.apply_payload, so the grant COLLIDES and takes the generic.
	# Resurrection has no damage, so Honed is skipped and QUICKENED lands.
	var rune: Dictionary = Runes.build("last_rites")
	rune["equipped"] = true
	var scene := await _spawn({}, {"runes": [rune]})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	ok(res != null, "she still holds exactly one Resurrection with the rune worn")
	var copies := 0
	for ab in c.abilities:
		if ab.display_name == "Resurrection":
			copies += 1
	ok(copies == 1, "the rune did not double-grant (got %d)" % copies)
	if res != null:
		ok(res.cooldown == 1,
			"the rune's dead grant became QUICKENED: 3cd -> 1 (got %s)" % res.cooldown)
	var landed: Dictionary = c.ability_upgrades
	ok(str(landed.get("Resurrection", [])).contains("Quickened"),
		"...and the kit reports it as Quickened (got %s)" % str(landed))
	_report.append("Last Rites is no longer a dead Epic — it Quickens the raise")
	await _kill(scene)


# ---------- §6 the bot ----------

func _live_bot_policy() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("var icept := _find_ability(u, \"Intercession\")"),
		"the cleric policy knows Intercession exists")
	ok(bsrc.count("func _holy_empower_ok") == 1,
		"the Empower rule has exactly one implementation")
	# FX: hl_ardor is inlined from `RETIRED` — the exact payload it carried.
	var scene := await _spawn({"hl_ardor": 1})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	var hymn := _find(c, "Hymn of Hope")
	ok(res != null and hymn != null, "both spenders are in hand")
	# NEVER Empower down past a raise she could otherwise cast. Hymn costs 1
	# and Resurrection costs 1, so at 2 stacks the surcharge would strand her.
	c.avatar_of_mercy = 0
	c.ardor_at = 0
	c.second_resource = 2
	ok(not scene._holy_empower_ok(c, hymn),
		"at 2 Mercy she will not Empower a Hymn — it would cost her the raise")
	c.second_resource = 3
	ok(scene._holy_empower_ok(c, hymn),
		"at 3 she will: the raise survives the surcharge")
	# Ardor learned: bank to the threshold first, then Empower freely.
	c.ardor_at = 3
	c.second_resource = 2
	ok(not scene._holy_empower_ok(c, hymn),
		"with Ardor learned she banks to its threshold rather than paying")
	c.second_resource = 3
	ok(scene._holy_empower_ok(c, hymn),
		"...and Empowers freely at it")
	# Avatar of Mercy makes it unconditional.
	c.avatar_of_mercy = 1
	c.second_resource = 0
	ok(scene._holy_empower_ok(c, hymn),
		"Avatar of Mercy makes Empower unconditional")
	# THE ROTATION: a fallen ally is the first priority.
	c.avatar_of_mercy = 0
	c.ardor_at = 0
	c.second_resource = 2
	c.resource = c.max_resource
	var down := _hero(scene, 0)
	down.take_hit(down.hp + 500, 0)
	ok(down.dead, "an ally is down")
	var pick: Array = scene._autoplay_pick(c)
	ok(pick[0] != null and pick[0].display_name == "Resurrection",
		"the bot raises the fallen FIRST (picked %s)" % pick[0].display_name)
	await _kill(scene)


# ---------- Avatar of Mercy: Empower now GENERATES ----------

func _live_avatar() -> void:
	# FX: hl_avatar is inlined from `RETIRED` — the exact payload it carried.
	var scene := await _spawn({"hl_avatar": 1})
	var c := _hero(scene, 2)
	ok(c.avatar_of_mercy == 1, "Avatar of Mercy is stamped")
	c.second_resource = 2
	scene.empower_armed = true
	var hymn := _find(c, "Hymn of Hope")
	var before := c.second_resource
	ok(scene._consume_empower(c, hymn), "the Empower lands")
	ok(c.second_resource == before + 1,
		"Avatar of Mercy GRANTS a stack instead of spending one (%d -> %d)" % [
			before, c.second_resource])
	await _kill(scene)
