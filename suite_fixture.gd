# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES.
#
# DB did this for the seven GATES (`gate_fixture.gd`); this is the other side of
# the same debt and it is ten times the size. THE CENSUS, DERIVED RATHER THAN
# RECALLED: `_spawn` stood in **37 suites as 36 raw bodies — 33 once comments and
# blank lines are stripped** (four pairs are twins: bh/bi, bo/bp, bq/br, bt/cb),
# and `_kill` stood in **14 as four raw bodies that are ONE body**: every
# difference between those fourteen was a comment.
#
# ── WHY EACH SUITE KEEPS ITS OWN `_spawn` AND THIS FILE IS NOT A BASE CLASS ──
# Two reasons, and neither is taste.
#
# 1. `extends SuiteBase` DOES NOT COMPILE AND FAILS BY EXITING 0. A `--script`
#    SceneTree target cannot resolve its own base class — both `extends Base` and
#    `extends "res://base.gd"` print `Parse Error`, run not one line, and exit 0
#    (DB measured it; CLAUDE.md carries it twice). So this is a `preload`ed
#    `RefCounted`, and it carries **no `class_name`**: that registration lives in
#    the gitignored `.godot/global_script_class_cache.cfg`, so it would resolve
#    here and fail on a fresh clone. Consumers preload it BY PATH.
#
# 2. THE THIRTY-SEVEN SIGNATURES ARE NOT ONE SIGNATURE. The gates all spawned a
#    party and a lineup; the suites take `learned`, `granted`, `member_patch`,
#    `prep`, `learner`, `mod_id`, `cleric_spec`, `earned`, `runes` and `frames`
#    between them, across several hundred call sites. A suite therefore keeps a
#    thin `_spawn` with ITS OWN signature that delegates here — **not one call
#    site moved**, and every difference that used to be invisible inside a copy
#    is now an argument with a name.
#
# ── THE AUTOLOAD RULE, WHICH THIS FILE IS BOUND BY (CT, CLAUDE.md) ──────────
# A `--script` harness can only compile files that name no autoload, and this
# file is compiled as a dependency of thirty-seven of them. The project's
# autoloads are exactly `Run`, `Settings` and `Music`, so **`Run` IS NEVER NAMED
# HERE** — it is fetched at RUNTIME off the caller's tree by string path.
# `Talents` is a `class_name` script class, not an autoload, and is safe.
extends RefCounted

# BATCH GS — the one derivation of a lineage's returned cards lives in the gate
# fixture; this one reads it rather than holding a second copy.
const GateFixture = preload("res://gate_fixture.gd")

# ── THE OPTIONS, AND WHY THERE ARE THIS MANY ────────────────────────────────
# One key per axis the 37 copies actually diverged on. They are validated below
# rather than silently ignored, because an ignored typo in an options dictionary
# is a suite quietly measuring a different board — the same class of fault as a
# gate that exits 0.
#
#   difficulty    "standard" (32 suites) or "wanderer" (bn, bo, bp, bq, br).
#   enemies       the lineup. Every copy passed one; there is no default.
#   node_type     encounter type, "fight" unless a suite drives an elite/boss.
#   talents       {index: Dictionary} — the equipped loadout, written per member.
#   talents_by_spec {spec: Dictionary} — the same thing keyed by spec (bo..br).
#   bm            {index: Array} — granted abilities. `new_run` DOES NOT create
#                 this key, so writing it is a real difference from not writing
#                 it, and `bm_all` is the copies that wrote `[]` to everyone.
#   bm_all        bool — write `bm`'s default to every member, not just named ones.
#   bm_by_spec    {spec: Array} — implies `bm_all` (bo..br's `granted`).
#   runes         {index: Array} — al alone equips any.
#   patch         {index: Dictionary} — arbitrary party-member keys written AFTER
#                 `sync_spec_hp`, which is where the four copies wrote them and
#                 is load-bearing for a patch that touches `spec` or `max_hp`.
#   prep          Callable(run) — ah_battle and ak, run after `active = true`.
#   slot_idx      int — `new_run` leaves this at -1; eight copies set 0.
#   modifier      String — `run.pending_modifier` (bb alone passes a live one).
#   autoplay      bool — true sets DOD_AUTOPLAY=1 AND WRITES NO DOD_ENEMIES_OFF
#                 (ah_battle, bl); false sets AUTOPLAY empty and ENEMIES_OFF=1.
#   frames        int — process frames to wait after `add_child`. 12 / 20 / 90,
#                 and bl passes its own.
#   fast          bool — `Engine.time_scale = 50` across the wait (the 90s).
#   deterministic bool — the AK/AL/AR forcing: `no_cover`, parry and block.
#   enemies_keep_cover  bool — bq and br arm `no_cover` on the HEROES ONLY, and
#                 it is documented in both: Mirror Image IS a miss.
#   crit          float — `crit_bonus`. TWO live values, -10.0 and -1.0, and
#                 which one a suite wants is a measurement decision, not a merge.
#   heal_mult     float — `healing_received_mult`, the healing suites' fourth coin.
#   sim           bool — `scene.sim = true` and `sim_stats` cleared.
#   slices        bool — `_b_slice` and `_b_bd_slice` cleared as well.
#   lineage_cards bool — BATCH GS §1: seat, for every hero seated by lineage, the
#                 cards his lineage opened with until GS as DRAFTED cards, ahead of
#                 any `bm` the suite names (`gate_fixture.lineage_cards`, the one
#                 derivation). A lineage opens with its engine's enablers alone
#                 since GS, so a suite about one of its other cards seats it the
#                 way a player now gets it.
const KNOWN := ["difficulty", "enemies", "node_type", "talents", "talents_by_spec",
	"bm", "bm_all", "bm_by_spec", "runes", "patch", "prep", "slot_idx", "modifier",
	"autoplay", "frames", "fast", "deterministic", "enemies_keep_cover", "crit",
	"heal_mult", "sim", "slices", "lineage_cards"]


# ── WHAT WAS DROPPED, AND WHY EACH ONE IS NOT A BEHAVIOUR CHANGE ────────────
# Four differences between the 37 copies are ABSENT from the option list above,
# because each was measured to be a no-op rather than ruled to be one:
#
#   `run.combat_wins = 0`      — `new_run` already sets it to 0 (run_state.gd).
#   `run.party[i]["runes"]=[]` — `new_run` already seeds every member with `[]`.
#   `run.party[i]["talents"]={}`— likewise `{}`.
#   `_run_obj()` vs `root.get_node("/root/Run")` — bh and bi call a one-line
#                                helper that returns exactly the second thing.
#
# And one ORDERING difference: `al` wrote its member-0 talents, runes and grants
# AFTER the loop rather than inside it. `sync_spec_hp` reads `spec`, `max_hp` and
# `hp` and nothing else, so the two orders cannot differ. The `patch` option is
# the one that genuinely must stay after the loop, and it does.
static func spawn(tree: SceneTree, specs: Array, opts: Dictionary = {}) -> Node:
	for k in opts:
		if not KNOWN.has(k):
			push_error("suite_fixture.spawn: unknown option `%s` — it does NOTHING. Known: %s"
				% [k, ", ".join(KNOWN)])
			printerr("suite_fixture.spawn: unknown option `%s`" % k)
	var root: Node = tree.root
	var run: Node = root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [],
		String(opts.get("difficulty", "standard")))
	var talents: Dictionary = opts.get("talents", {})
	var talents_by_spec: Dictionary = opts.get("talents_by_spec", {})
	var bm: Dictionary = opts.get("bm", {})
	var bm_by_spec: Dictionary = opts.get("bm_by_spec", {})
	var bm_all := bool(opts.get("bm_all", false)) or not bm_by_spec.is_empty()
	var runes: Dictionary = opts.get("runes", {})
	for i in run.party.size():
		var spec := String(specs[i])
		run.party[i]["spec"] = spec
		# BATCH GK — A SPEC NO LONGER BRINGS ITS ENGINE; THE ENGINE IS A RUNE. A
		# hero seated by lineage holds that lineage's engine rune, slotted, which
		# is what class selection hands a player who takes it. A caller wanting
		# him without it, or with a second, overrides `engines` after.
		run.party[i]["engines"] = Runes.engine_pouch_for_spec(spec)
		run.party[i]["awakened"] = true
		run.party[i]["tree"] = Talents.generate_tree(spec, run.party[i]["key"])
		run.party[i]["runes"] = runes.get(i, [])
		run.party[i]["talents"] = talents.get(i, talents_by_spec.get(spec, {}))
		if bm_all or bm.has(i) or bm_by_spec.has(spec):
			run.party[i]["bm_abilities"] = bm.get(i, bm_by_spec.get(spec, []))
		if bool(opts.get("lineage_cards", false)):
			var lc: Array = GateFixture.lineage_cards(spec)
			for n in run.party[i].get("bm_abilities", []):
				if not lc.has(n):
					lc.append(n)
			run.party[i]["bm_abilities"] = lc
		run.sync_spec_hp(i)
	# AFTER `sync_spec_hp`, deliberately — see the note above `spawn`.
	var patch: Dictionary = opts.get("patch", {})
	for i in patch:
		for key in patch[i]:
			run.party[i][key] = patch[i][key]
	run.specs_chosen = true
	run.active = true
	var prep: Callable = opts.get("prep", Callable())
	if prep.is_valid():
		prep.call(run)
	if opts.has("slot_idx"):
		run.slot_idx = int(opts["slot_idx"])
	if opts.has("modifier"):
		run.pending_modifier = String(opts["modifier"])
	run.encounter = {"type": String(opts.get("node_type", "fight")),
		"theme": "Warband", "enemies": opts.get("enemies", [])}
	# THE TWO ENV SHAPES ARE NOT INTERCHANGEABLE. An autoplay spawn sets
	# DOD_AUTOPLAY and writes NO DOD_ENEMIES_OFF at all — ah_battle and bl want
	# the enemies live, and an env var this process already carries would stay
	# set if this branch cleared it by writing "".
	if bool(opts.get("autoplay", false)):
		OS.set_environment("DOD_AUTOPLAY", "1")
	else:
		OS.set_environment("DOD_AUTOPLAY", "")
		OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	# Batch AC gotcha, carried from the copies: an autoplay battle paces on REAL
	# timers, and `time_scale` scales the SceneTreeTimers it waits on and NOTHING
	# else. Six copies spent 90 frames at 50x rather than 20 at 1x.
	var fast := bool(opts.get("fast", false))
	if fast:
		Engine.time_scale = 50.0
	for _i in int(opts.get("frames", 20)):
		await tree.process_frame
	if fast:
		Engine.time_scale = 1.0
	# DETERMINISM FORCED, NOT RETRIED (the AK/AL/AR discipline, and it is in
	# thirty-two of the thirty-seven). Every check that drives `_resolve` by hand
	# still rolls miss, parry and crit, and any one of those three reads exactly
	# like "the node did nothing" — which turns a real assertion into a coin flip.
	# `no_cover` is the miss BYPASS, not a modifier.
	if bool(opts.get("deterministic", false)):
		for u in scene.get("heroes") + scene.get("enemies"):
			u.parry_chance = 0.0
			u.block_chance = 0.0
			if opts.has("crit"):
				u.crit_bonus = float(opts["crit"])
			if opts.has("heal_mult"):
				u.healing_received_mult = float(opts["heal_mult"])
		# bq and br leave the ENEMIES their cover, and it is deliberate rather
		# than a copy slip: `no_cover` is an absolute miss BYPASS and MIRROR
		# IMAGE IS A MISS, so arming it on the enemy side makes every image look
		# broken. Those two suites hand it back per unit at the checks that need
		# a blow to land. PRESERVED, NOT MERGED — the majority would have
		# changed what two suites measure.
		var covered: Array = scene.get("heroes")
		if not bool(opts.get("enemies_keep_cover", false)):
			covered = covered + scene.get("enemies")
		for u in covered:
			u.no_cover = 1
	if bool(opts.get("sim", false)):
		scene.set("sim", true)
		scene.get("sim_stats").clear()
	if bool(opts.get("slices", false)):
		scene.get("_b_slice").clear()
		scene.get("_b_bd_slice").clear()
	return scene


# ── AND THE EASY ONE, DONE FIRST TO PROVE THE METHOD ────────────────────────
# `_kill` stood in fourteen suites (av..bi) as ONE body. The only thing that
# differed between the fourteen was the comment above `await`, which said the
# same thing four ways — so this is a straight lift with no ruling in it, and it
# went in before the 37 divergent `_spawn`s were touched.
#
# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
# spawn, or two battle scenes briefly share the tree.
static func kill(tree: SceneTree, scene: Node) -> void:
	scene.queue_free()
	await tree.process_frame
	await tree.process_frame


# ══ BATCH HD §3 — ONE POOL FLOOR A CLASS, AND BOTH OF ITS FLOORS ════════════
#
# **THIRTY-FIVE FLOORS DESCRIBED SIXTEEN SHELVES; A HERO HAS DRAWN FROM ONE POOL
# A CLASS SINCE GP.** Eleven suites asserted that a lineage's shelf held at least
# eight and a class-wide shelf at least three (six, in one) — twenty-three and
# twelve arms, each written *"so a pool that quietly empties trips"*. After the
# merge a shelf is where a card was authored, not what a hero is offered, so
# those arms could go red on a card moved between two shelves of one class —
# which moves nothing a hero is offered — and stay green while what he IS offered
# thinned. **They fold into this one floor, asked per CLASS and in TWO halves,
# because the two measure different things and the second is the one that goes
# thin (ruled at HD §1):**
#   · WHOLE — `Classes.draft_pool(k)`: everything a hero of the class can draft;
#   · NO ENGINE — `Classes.offerable(draft_pool(k), [])`: what a hero holding no
#     engine at all can be offered, which is the pool less every `ENGINE_READ`
#     row and the half a new gated card thins.
#
# **THE VALUES ARE MEASURED, NOT CHOSEN, AND NO OLD SHELF FIGURE SURVIVES IN THEM.**
# They are the live reading on HD's tree, after its own card gate took Guard
# Change and Lunge out of the no-engine Warrior's half (40 -> 38). A floor AT the
# reading is the strict form of *a pool that quietly empties trips*: it reds on
# the first card that leaves either half, so the batch that thins a pool says so
# here, in one table, instead of in eleven suites. **A pool that GROWS passes** —
# it is a floor, never an equality (DX §1) — and the batch that grows it may raise
# the floor or leave it.
#
# **A FLOOR OF ZERO ASSERTS NOTHING, SO THE HELPER REFUSES ONE.** Every half must
# be at least one, whatever the table says, so the day a class can be offered
# nothing this goes red — rather than a zero row reading as correct. No class's
# card pool is near it (the Cleric's no-engine half is the thinnest, 29 of 43);
# the class whose RUNE offer is zero with no engine is the Cleric, and that floor
# is `check_gv` §3's, where the rune table is derived.
const CLASS_POOL_FLOOR := {
	"warrior": {"whole": 43, "bare": 38},
	"mage": {"whole": 51, "bare": 38},
	"cleric": {"whole": 43, "bare": 29},
	"hunter": {"whole": 42, "bare": 35},
}


# Every floor, as `[held, message]` pairs: the calling suite asserts each through
# its own `ok()`, so the count and the FAIL line are the suite's and this file
# holds no copy of anybody's assertion machinery. `who` names the caller, so a
# FAIL line says which suite read it. Eight pairs — four classes, two halves.
#
# **BATCH HH §2 — TWO RETIRED SHELF ARMS STAND ON THESE FLOORS**: `test_batch_bp`
# §5's "every spec has a draft" and `test_batch_cd` §2's per-shelf floor of eight,
# each naming them at its own site (HG's control c6 emptied the Warden's shelf and
# these went red where the suite asserts them). `test_batch_cd` asserts none of them
# — its own per-shelf depth table stands behind that floor in that suite — so
# retiring or loosening these floors narrows what stands behind both.
static func class_pool_floors(who: String) -> Array:
	var out: Array = []
	for k in CLASS_POOL_FLOOR:
		var f: Dictionary = CLASS_POOL_FLOOR[k]
		var pool: Array = Classes.draft_pool(String(k))
		var bare: Array = Classes.offerable(pool, [])
		var fw := maxi(int(f["whole"]), 1)
		var fb := maxi(int(f["bare"]), 1)
		out.append([pool.size() >= fw,
			"%s: the %s pool holds %d cards, below its floor of %d — a card left the class's one pool (HD §3)"
				% [who, k, pool.size(), fw]])
		out.append([bare.size() >= fb,
			"%s: a %s holding no engine can be offered %d of the pool, below its floor of %d — the no-engine half thinned (HD §3)"
				% [who, k, bare.size(), fb]])
	return out


# ══ BATCH HH — THE FACT THAT RETIRED THE SHELF ARMS, ASSERTED IN ONE PLACE ═══
#
# **FOURTEEN ARMS IN ELEVEN SUITES ASKED WHERE A CARD WAS AUTHORED AS THOUGH IT
# WERE WHAT A HERO IS OFFERED** — a tranche card "not on a class-wide shelf", an
# enabler "absent from its OWN shelf", "every spec has a draft", a draft name "not a
# SIBLING's boss card", a Warden's offer "beside real spec cards". **GP made a
# class's three lineage shelves and its class-wide shelf ONE POOL**, so a shelf is
# where a card was written down and nothing more: HH retired those arms, each at its
# own site with what it guarded, and each asserts THIS instead — the fact that
# retired it. **The day a class's draft is anything but its shelves together, every
# one of those questions is live again, and every suite that retired one goes red
# here saying so.** The questions themselves are asked where they still mean
# something, and each retired arm names that check (the uniqueness sweeps, the pool
# floors above, `check_gs` §1, `test_batch_bp` §5's enabler arm).
#
# ONE PAIR, `[held, message]`, asserted through the caller's own `ok()`, like the
# floors: `who` names the suite and the arm, so a FAIL line says which retirement it
# reopens. It compares the pool against the shelves as SETS, so an order or a dedupe
# inside `draft_pool` does not read as a split, and it walks all four classes and
# says so, so an empty walk cannot pass.
static func one_pool_a_class(who: String) -> Array:
	var split: Array = []
	var walked := 0
	for k in Classes.SPEC_IDS:
		var shelves := {}
		for spec in Classes.SPEC_IDS[k]:
			for n in Classes.spec_draft_pool(String(spec)):
				shelves[String(n)] = true
		for n2 in Classes.class_draft_pool(String(k)):
			shelves[String(n2)] = true
		var pool := {}
		for n3 in Classes.draft_pool(String(k)):
			pool[String(n3)] = true
		var a: Array = shelves.keys()
		var b: Array = pool.keys()
		a.sort()
		b.sort()
		walked += 1
		if a != b or b.is_empty():
			split.append("%s (%d on its shelves, %d in its pool)" % [k, a.size(), b.size()])
	return [walked == 4 and split.is_empty(),
		"%s: a class's draft is not its four shelves together (%s; %d of 4 classes walked) — GP's one pool is split again, and the shelf question this arm asked until HH is live again (retired at HH)"
			% [who, ", ".join(PackedStringArray(split)), walked]]
