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
const KNOWN := ["difficulty", "enemies", "node_type", "talents", "talents_by_spec",
	"bm", "bm_all", "bm_by_spec", "runes", "patch", "prep", "slot_idx", "modifier",
	"autoplay", "frames", "fast", "deterministic", "enemies_keep_cover", "crit",
	"heal_mult", "sim", "slices"]


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
		run.party[i]["tree"] = Talents.generate_tree(spec, run.party[i]["key"])
		run.party[i]["runes"] = runes.get(i, [])
		run.party[i]["talents"] = talents.get(i, talents_by_spec.get(spec, {}))
		if bm_all or bm.has(i) or bm_by_spec.has(spec):
			run.party[i]["bm_abilities"] = bm.get(i, bm_by_spec.get(spec, []))
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
