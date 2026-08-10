# test_batch_bb.gd — CLEARING THE DECK. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bb.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 THE PACK'S SWAP TAKES THE SHALLOWER BOND. Three beasts in sequence
#      replace the LOWEST-Loyalty one and not the oldest; equal Loyalty falls
#      back to the older; no two of a kind are ever active.
#   §2 CREEPING DEATH HAS TWO CLAUSES. It refreshes a clocked poison and ADDS A
#      STACK to a permanent one; the stack clause fires ONCE when a single cast
#      lands three statuses, and the refresh clause fires freely.
#   §4 `_ghost_hit` BOOKS ITS DAMAGE to the pack master, through the same
#      resolution `_companion_hit` uses — and books no Break damage because it
#      deals none.
#   §5 ROT, REINSTATED. It halves both parties with hp clamped under the new
#      maximum, and max_hp RETURNS to its pre-battle value on the party member
#      after a victory. The negative control that matters: a Devout growing, a
#      Warden's Tenacity growing and Rot active in ONE battle, all three fields
#      resolving at one sync.
#   §6 ASHES OF AL'AR HAS A HOME. Offerable to a Cryomancer and an Arcanist,
#      and not offered to a Pyromancer who already holds it.
#   NEGATIVE CONTROLS for the three that would fail quietly: the swap taking
#      the deeper bond, Rot's reduction persisting onto the party member, and
#      Creeping Death stacking once per STATUS rather than once per TURN.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
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
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bb_test.json"
	Profile.loaded = false
	Profile.data = {}

	_swap_rule_source()
	_creeping_source()
	_ghost_source()
	_rot_pool()
	_rot_sync_source()
	_ashes_pools()
	_ashes_offers()
	_docs()

	await _live_swap_takes_the_shallower()
	await _live_swap_tie_falls_to_the_older()
	await _live_never_two_of_a_kind()
	await _live_bot_prices_the_swap_victim()
	await _live_creeping_refresh_is_ungoverned()
	await _live_creeping_stacks_a_permanent_poison()
	await _live_creeping_stack_is_once_per_turn()
	await _live_ghost_hit_credits_the_hunter()
	await _live_rot_binds_both_parties()
	await _live_rot_leaves_the_battle()
	await _live_three_fields_one_sync()
	await _live_ashes_returns_the_mage()

	if FileAccess.file_exists("user://profile_batch_bb_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bb_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bb: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _hero(scene: Node, idx: int) -> BattleUnit:
	return scene.get("heroes")[idx]


# Script CONSTANTS are not properties, so `scene.get(name)` returns null for
# them — read the constant map instead. The test asserts against the named
# constants rather than repeating 25 and 40, or it is a mirror of the code.
func _const(scene: Node, name: String) -> int:
	return int(scene.get_script().get_script_constant_map()[name])


# One spawn for every live check. `specs` is warrior/mage/cleric/hunter order;
# `learned` lands on the hero named by `learner`. `mod_id` arms a bargain the
# way the offer screen does — it is read at `_ready`, so it must be set BEFORE
# the scene is instantiated.
func _spawn(specs: Array, learned := {}, learner := 3, mod_id := "",
		lineup := ["raider", "raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = String(specs[i])
		run.party[i]["tree"] = Talents.generate_tree(String(specs[i]),
			run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == learner else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.combat_wins = 0
	run.pending_modifier = mod_id
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/../BA discipline). A driven
	# _resolve still rolls miss, parry AND crit.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


func _kinds(hunter: BattleUnit, scene: Node) -> Array:
	var out: Array = []
	for b in scene.call("_beasts", hunter):
		out.append(b.companion_kind)
	return out


# ---------- §1: the swap rule, at its source ----------

func _swap_rule_source() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("func _swap_victim("),
		"§1: the swap victim has ONE implementation, `_swap_victim`")
	ok(src.contains("_free_beast(hunter, _swap_victim(hunter))"),
		"§1: `_do_summon` frees the beast `_swap_victim` names")
	# THE REGRESSION IS NAMED SO IT CANNOT BE 'FIXED' BACK. AY's rule shipped as
	# `_free_beast(hunter, _beasts(hunter)[0])`, and its comment argued for it;
	# both are gone, and the reason is recorded at the new site.
	ok(not src.contains("_free_beast(hunter, _beasts(hunter)[0])"),
		"§1: AY's oldest-beast eviction is gone from `_do_summon`")
	ok(src.contains("BATCH Q'S RULE, RESTORED"),
		"§1: the site says whose rule this is")
	# The bot must price the SAME beast the summon will actually free.
	ok(src.contains("var out_b: BattleUnit = _swap_victim(u)"),
		"§1: the bot prices `_swap_victim`, not `bot_beasts[0]`")
	ok(not src.contains("bot_beasts[0]  # the older, per §1"),
		"§1: the bot's old oldest-beast read is gone")
	# THE NEVER-TWO-OF-A-KIND CLAUSE IS BATCH Q'S AND MUST SURVIVE THE REVERT —
	# verified rather than assumed, exactly as §1 instructed.
	ok(src.contains("# Never a second beast of a kind already fielded"),
		"§1: Batch Q's never-two-of-a-kind clause survives the revert")
	# The two player-facing tooltips and the capstone all say the same thing.
	ok(src.contains("holds LESS Loyalty (ties: the older)")
		and src.contains("Replaces whichever beast holds LESS"),
		"§1: both swap tooltips describe the Loyalty rule")
	ok(not src.contains("replaces the OLDER") and not src.contains("the OLDER of the two"),
		"§1: no tooltip still says OLDER")
	var pack: Dictionary = Talents.node_in_tree(
		Talents.generate_tree("beastmaster", "hunter"), "bm_the_pack")
	ok(String(pack.get("desc", "")).contains("LESS Loyalty"),
		"§1: The Pack's own description carries the corrected rule")
	ok(not String(pack.get("desc", "")).contains("OLDER"),
		"§1: ...and no longer says OLDER")


# ---------- §1 live: the swap takes the SHALLOWER bond ----------
#
# THE CASE THAT MATTERS AND THE NEGATIVE CONTROL IN ONE: the deep beast is also
# the OLDER one, so AY's rule and Batch Q's rule name DIFFERENT victims here. A
# test where the oldest also holds the least Loyalty proves nothing.
func _live_swap_takes_the_shallower() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "beastmaster"],
		{"bm_the_pack": 1})
	var h := _hero(scene, 3)
	ok(h.the_pack == 1, "§1: the hunter holds The Pack")
	ok(scene.call("_beast_cap", h) == 2, "§1: ...so he fields two")
	await scene.call("_do_summon", h, "ursus")
	scene.call("_gain_loyalty", h, "ursus", 9)
	await scene.call("_do_summon", h, "canis")
	var deep: int = int(h.loyalty.get("ursus", 0))
	var shallow: int = int(h.loyalty.get("canis", 0))
	ok(deep > shallow,
		"§1: the OLDER beast holds the DEEPER bond (%d vs %d) — the two rules disagree here"
		% [deep, shallow])
	var victim: BattleUnit = scene.call("_swap_victim", h)
	ok(victim != null and victim.companion_kind == "canis",
		"§1: `_swap_victim` names the shallower bond")
	await scene.call("_do_summon", h, "aguila")
	var live := _kinds(h, scene)
	ok(live.size() == 2, "§1: still exactly two beasts (got %d)" % live.size())
	ok(live.has("ursus"),
		"§1: THE 50-STACK BOND SURVIVES the third summon — the deep beast keeps its place")
	ok(not live.has("canis"), "§1: ...and the shallow one is what broke")
	ok(live.has("aguila"), "§1: ...and the newcomer stood up")
	ok(int(h.loyalty.get("ursus", 0)) == deep,
		"§1: the surviving bond is untouched by the swap (%d)" % h.loyalty.get("ursus", 0))
	await _kill(scene)


# ---------- §1 live: equal Loyalty falls back to the older ----------

func _live_swap_tie_falls_to_the_older() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "beastmaster"],
		{"bm_the_pack": 1})
	var h := _hero(scene, 3)
	await scene.call("_do_summon", h, "canis")     # the older
	await scene.call("_do_summon", h, "aguila")    # the younger
	h.loyalty["canis"] = 4
	h.loyalty["aguila"] = 4
	ok(int(h.loyalty["canis"]) == int(h.loyalty["aguila"]),
		"§1: the two bonds are exactly equal")
	var victim: BattleUnit = scene.call("_swap_victim", h)
	ok(victim != null and victim.companion_kind == "canis",
		"§1: a TIE falls to the OLDER — the rule is total, not order-dependent")
	# ...and it stays total when the list is walked the other way round: the
	# strict `<` is what makes the earlier entry hold the slot.
	h.beasts.reverse()
	var victim2: BattleUnit = scene.call("_swap_victim", h)
	ok(victim2 != null and victim2.companion_kind == "aguila",
		"§1: ...and 'older' means first in the field order, whatever that order is")
	await _kill(scene)


# ---------- §1 live: no two of a kind, ever ----------

func _live_never_two_of_a_kind() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "beastmaster"],
		{"bm_the_pack": 1})
	var h := _hero(scene, 3)
	await scene.call("_do_summon", h, "ursus")
	var summon_ursus: Ability = scene.call("_find_ability", h, "Summon Ursus")
	var summon_canis: Ability = scene.call("_find_ability", h, "Summon Canis")
	ok(summon_ursus != null and summon_canis != null, "§1: both summons resolve")
	ok(not scene.call("_ability_usable", h, summon_ursus),
		"§1: a second Ursus is refused while one stands")
	ok(scene.call("_ability_usable", h, summon_canis),
		"§1: ...while a different kind is offered")
	await scene.call("_do_summon", h, "canis")
	await scene.call("_do_summon", h, "aguila")
	var live := _kinds(h, scene)
	ok(_unique(live).size() == live.size(),
		"§1: no kind is ever fielded twice (got %s)" % str(live))
	await _kill(scene)


func _unique(a: Array) -> Array:
	var out: Array = []
	for v in a:
		if not out.has(v):
			out.append(v)
	return out


# ---------- §1 live: the bot prices the beast it would actually lose ----------

func _live_bot_prices_the_swap_victim() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "beastmaster"],
		{"bm_the_pack": 1})
	var h := _hero(scene, 3)
	await scene.call("_do_summon", h, "ursus")
	scene.call("_gain_loyalty", h, "ursus", 12)
	await scene.call("_do_summon", h, "canis")
	var victim: BattleUnit = scene.call("_swap_victim", h)
	ok(victim.companion_kind == "canis", "§1: the swap would take the wolf")
	# The bot's margin reads the curve, so pricing the WRONG beast would value a
	# 13-stack bond it is not about to lose and refuse every swap forever.
	var worth_victim: float = scene.call("_bot_boon_worth", h, victim.companion_kind)
	var worth_deep: float = scene.call("_bot_boon_worth", h, "ursus")
	ok(worth_deep > worth_victim,
		"§1: the deep bond is worth more than the shallow one (%.2f vs %.2f)"
		% [worth_deep, worth_victim])
	await _kill(scene)


# ---------- §2: Creeping Death, at its source ----------

func _creeping_source() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("# THE STACK CLAUSE") and src.contains("# THE REFRESH CLAUSE"),
		"§2: the node has two named clauses at one site")
	ok(src.contains("cp[\"creep_turn\"] = _turns_taken"),
		"§2: the stack clause stamps the turn it fired on")
	# THE GOVERNOR IS ON THE STACK CLAUSE ALONE. The refresh half must NOT gain
	# one: refreshing three times is refreshing once, and a governor there would
	# be a silent nerf to the clause BA shipped.
	var creep: String = src.split("func _creeping_refresh(")[1].split("\nfunc ")[0]
	var stack_half: String = creep.split("# THE REFRESH CLAUSE")[0]
	var refresh_half: String = creep.split("# THE REFRESH CLAUSE")[1]
	ok(stack_half.contains("creep_turn"),
		"§2: the once-per-turn governor is inside the stack clause")
	ok(not refresh_half.contains("creep_turn"),
		"§2: the REFRESH clause has no governor and must not gain one")
	ok(src.contains("func _perfected_chip("),
		"§2: one writer owns a permanent poison's chip text")
	# `_turns_taken` had to leave `_run_battle` to be testable at all.
	ok(src.contains("\nvar _turns_taken := 0"),
		"§2: the turn counter is a field, not a local inside `_run_battle`")
	var node: Dictionary = Talents.node_in_tree(
		Talents.generate_tree("mystic", "hunter"), "sv_creeping")
	var desc := String(node.get("desc", ""))
	ok(desc.contains("refreshes") and desc.contains("adds a stack"),
		"§2: the node text carries BOTH clauses")
	ok(desc.contains("once per enemy per turn"),
		"§2: ...and states the governor, so the text reads correctly either way")


# ---------- §2 live: the refresh clause, unchanged and ungoverned ----------

func _live_creeping_refresh_is_ungoverned() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "mystic"],
		{"sv_creeping": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 5)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("full", 0)) == 5, "§2: a clocked poison remembers its full span")
	var stacks_before: int = int(ps.get("stacks", 1))
	ps["turns"] = 1
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("turns", 0)) == 5,
		"§2: BA's refresh still fires on a clocked poison")
	ok(int(foe.get_status("poison").get("stacks", 1)) == stacks_before,
		"§2: ...and refreshing adds NO stack")
	# FREELY: a second status in the SAME turn refreshes again. The governor is
	# the stack clause's alone.
	ps["turns"] = 1
	scene.call("_apply_status", foe, "exposed", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("turns", 0)) == 5,
		"§2: a SECOND status the same turn refreshes again — the refresh half is ungoverned")
	await _kill(scene)


# ---------- §2 live: a permanent poison is DEEPENED instead ----------

func _live_creeping_stacks_a_permanent_poison() -> void:
	# Venom row 5 AND the Venom capstone — the build BA reported as owning a
	# node that could never fire.
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "mystic"],
		{"sv_creeping": 1, "sv_epidemic": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(h.perfected_toxin > 0 and h.creeping_death > 0,
		"§2: the hero holds Creeping Death AND Perfected Toxin")
	scene.call("_apply_poison", h, foe, 5)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("turns", 0)) < 0 and int(ps.get("full", 0)) < 0,
		"§2: the capstone's poison is PERMANENT — there is no duration to refresh")
	var before: int = int(ps.get("stacks", 1))
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("stacks", 1)) == before + 1,
		"§2: applying a status to a permanently-poisoned enemy ADDS A STACK (%d -> %d)"
		% [before, int(foe.get_status("poison").get("stacks", 1))])
	ok(int(foe.get_status("poison").get("turns", 0)) < 0,
		"§2: ...and the poison stays permanent — deepening never gives it a clock")
	# The chip has to follow, or the node's effect is invisible.
	ok(String(foe.get_status("poison").get("short", "")) == "P%d" % (before + 1),
		"§2: the chip reads the new stack count")
	await _kill(scene)


# ---------- §2 live: the governor — once per enemy per turn ----------
#
# NEGATIVE CONTROL, AND IT IS THE ONE THAT WOULD FAIL QUIETLY: since BA a single
# Distillate cast lands poison, Exposed AND Slowed. Refreshing three times is
# refreshing once, so the original never cared; adding three stacks is not
# adding one.
func _live_creeping_stack_is_once_per_turn() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "mystic"],
		{"sv_creeping": 1, "sv_epidemic": 1, "sv_virulence": 1, "sv_slow_acting": 1})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	# ONE CAST, three distinct statuses — the carriers ride `_apply_poison`.
	scene.call("_apply_poison", h, foe, 5)
	ok(foe.has_status("slow") and foe.has_status("exposed"),
		"§2: one application really does land three distinct statuses")
	var after_cast: int = int(foe.get_status("poison").get("stacks", 1))
	# THE WHOLE POINT, AS A NUMBER. `_apply_poison` lays 1 + Distillate's extra
	# stacks itself, and then its two CARRIERS (Slowed, Exposed) each pass back
	# through `_apply_status` — so an ungoverned stack clause would pay TWICE
	# for one cast. Exactly one is right.
	ok(after_cast == 1 + h.virulence_ranks + 1,
		"§2: ONE CAST, THREE STATUSES, EXACTLY ONE CREEPING DEATH STACK (%d stacks, want %d)"
		% [after_cast, 1 + h.virulence_ranks + 1])
	# Two more statuses inside the SAME turn must add nothing further.
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	scene.call("_apply_status", foe, "dazed", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("stacks", 1)) == after_cast,
		"§2: further statuses THE SAME TURN add no stack (held at %d)" % after_cast)
	# A new turn re-arms it — once per turn, not once per battle.
	scene.set("_turns_taken", int(scene.get("_turns_taken")) + 1)
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("stacks", 1)) == after_cast + 1,
		"§2: the NEXT turn arms it again — once per turn, not once per battle")
	# PER ENEMY: the marker rides the STATUS, so two victims are independent.
	# Both are poisoned and both take a status on the SAME turn; each gets one.
	scene.call("_apply_poison", h, other, 5)
	scene.set("_turns_taken", int(scene.get("_turns_taken")) + 1)
	var foe_b: int = int(foe.get_status("poison").get("stacks", 1))
	var oth_b: int = int(other.get_status("poison").get("stacks", 1))
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	scene.call("_apply_status", other, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("stacks", 1)) == foe_b + 1
		and int(other.get_status("poison").get("stacks", 1)) == oth_b + 1,
		"§2: TWO enemies each take a stack on the SAME turn — the governor is per ENEMY (%d->%d, %d->%d)"
		% [foe_b, int(foe.get_status("poison").get("stacks", 1)),
			oth_b, int(other.get_status("poison").get("stacks", 1))])
	await _kill(scene)


# ---------- §4: `_ghost_hit`, at its source ----------

func _ghost_source() -> void:
	var src := _src("res://scripts/battle.gd")
	var ghost: String = src.split("func _ghost_hit(")[1].split("\n# One companion attack")[0]
	ok(ghost.contains("_stat(\"dmg_hero_\" + ghost_credit.unit_name, final)"),
		"§4: `_ghost_hit` books its damage")
	ok(ghost.contains("if not victim.is_hero:"),
		"§4: ...through the same is_hero gate `_companion_hit` uses")
	# NO BREAK DAMAGE IS BOOKED BECAUSE NONE IS DEALT — verified at the site
	# rather than assumed, which is what §4 asked for.
	ok(ghost.contains("victim.take_hit(final, 0)"),
		"§4: the ghost blow carries a hardcoded pressure of 0 — no Break to credit")
	ok(not ghost.contains("_stat_bd("),
		"§4: ...so there is no Break half to mirror")


# ---------- §4 live: the credit lands on the hunter ----------

func _live_ghost_hit_credits_the_hunter() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "beastmaster"])
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	# `_stat("dmg_hero_*")` ONLY banks into sim_stats while `sim` is true — in
	# real play it routes to the run ledger instead (the AY trap).
	var was_sim: bool = scene.get("sim")
	scene.set("sim", true)
	var key := "dmg_hero_" + h.unit_name
	var before: float = float(scene.get("sim_stats").get(key, 0.0))
	var hp_before: int = foe.hp
	await scene.call("_ghost_hit", h, "ursus", foe, 0.15 * h.attack)
	var booked: float = float(scene.get("sim_stats").get(key, 0.0)) - before
	var dealt: int = hp_before - foe.hp
	scene.set("sim", was_sim)
	ok(dealt > 0, "§4: the bodiless blow really landed (%d damage)" % dealt)
	ok(booked > 0.0,
		"§4: CALL OF THE WILD'S BLOWS ARE BOOKED NOW — %.0f credited to the %s"
		% [booked, h.unit_name])
	ok(int(booked) == dealt,
		"§4: ...and the credit is the damage dealt, not an estimate (%d vs %d)"
		% [int(booked), dealt])
	await _kill(scene)


# ---------- §5: Rot is in the pool, at severity 4 ----------

func _rot_pool() -> void:
	var run := root.get_node("/root/Run")
	ok(run.MODIFIERS.has("rot"), "§5: `rot` is in the modifier pool")
	ok(run.modifier_severity("rot") == 4, "§5: ...at severity 4")
	ok(String(run.MODIFIERS["rot"]["name"]) == "Rot", "§5: ...named Rot")
	ok(String(run.MODIFIERS["rot"]["desc"]).contains("halved"),
		"§5: ...and its text says what it does")
	var by_sev := {1: 0, 2: 0, 3: 0, 4: 0}
	for mid in run.MODIFIERS:
		by_sev[run.modifier_severity(String(mid))] += 1
	ok(by_sev[4] == 4,
		"§5: THE SEVERITY-4 POOL IS FOUR — AQ's stated target (got %d)" % by_sev[4])
	ok(run.MODIFIERS.size() == 20, "§5: twenty modifiers (was nineteen)")
	# The floor still holds by construction with a bigger high pool.
	var misses := 0
	for _i in 400:
		var offer: Array = run.roll_offer()
		var low := 0
		for opt in offer:
			if run.modifier_severity(String(opt["modifier"])) <= 2:
				low += 1
		if low != 1:
			misses += 1
	ok(misses == 0,
		"§5: every offer still holds exactly one low option (%d of 400 missed)" % misses)


# ---------- §5: the three fields meet at one site, and the signs differ ----------

func _rot_sync_source() -> void:
	var bsrc := _src("res://scripts/battle.gd")
	var rsrc := _src("res://scripts/run_sim.gd")
	# THE ORDERING, ASSERTED AT BOTH SYNCS. This is the site with a ~127,000
	# max-HP runaway in its history and the site that got `rot` dropped from AQ.
	ok(bsrc.contains("heroes[i].max_hp - heroes[i].tenacity_hp_gained \\\n\t\t\t\t- heroes[i].conviction_hp_gained + heroes[i].rot_hp_lost"),
		"§5: battle.gd's sync subtracts two gains and ADDS the loss")
	ok(rsrc.contains("h.max_hp - h.tenacity_hp_gained - h.conviction_hp_gained \\\n\t\t\t+ h.rot_hp_lost"),
		"§5: run_sim.gd's sync carries the same three fields with the same signs")
	# ALL THREE STAY SEPARATE. Folding either of the others into
	# tenacity_hp_gained would change what Unkillable's mend heals for.
	ok(bsrc.contains("var unkill_base: int = strike_target.max_hp \\\n\t\t\t\t\t\t\t- strike_target.tenacity_hp_gained"),
		"§5: Unkillable's mend still reads tenacity_hp_gained ALONE — its second consumer")
	ok(not bsrc.contains("tenacity_hp_gained += heroes[i].rot_hp_lost")
		and not bsrc.contains("conviction_hp_gained + heroes[i].tenacity"),
		"§5: nothing is folded into another field")
	# The stamp banks what it took, and ACCUMULATES rather than assigns — a
	# companion arriving mid-fight is stamped through the same branch.
	ok(bsrc.contains("u.rot_hp_lost += rot_lost"),
		"§5: the stamp ACCUMULATES the reduction (a mid-fight arrival is stamped too)")
	ok(_src("res://scripts/unit.gd").contains("var rot_hp_lost := 0"),
		"§5: the field exists on BattleUnit")


# ---------- §5 live: Rot binds both parties ----------

func _live_rot_binds_both_parties() -> void:
	var run := root.get_node("/root/Run")
	var scene := await _spawn(["warden", "pyromancer", "inquisitor", "beastmaster"],
		{}, 3, "rot")
	for i in scene.get("heroes").size():
		var h: BattleUnit = _hero(scene, i)
		var pre: int = h.max_hp + h.rot_hp_lost
		ok(h.rot_hp_lost > 0, "§5: hero %d is bound by the bargain" % i)
		ok(h.max_hp == pre - h.rot_hp_lost and h.max_hp <= (pre / 2) + 1,
			"§5: hero %d's maximum is halved (%d of %d)" % [i, h.max_hp, pre])
		ok(h.hp <= h.max_hp,
			"§5: hero %d's current health is clamped under the new maximum (%d/%d)"
			% [i, h.hp, h.max_hp])
		ok(h.hp >= 1, "§5: ...and never to zero — a bargain does not kill")
	for e in scene.get("enemies"):
		ok(e.rot_hp_lost > 0,
			"§5: THE ENEMY IS BOUND TOO — Rot binds both parties (%s)" % e.unit_name)
	# The halving is NOT excluded from percentage effects that read max_hp, and
	# that is the design: they are ratios, so they scale.
	var devout := _hero(scene, 2)
	devout.conviction_base_hp = 0
	scene.call("_conviction_growth", devout, true)
	var grown: int = devout.conviction_hp_gained
	ok(grown > 0 and grown <= int(round((devout.max_hp) * 0.05)),
		"§5: the Devout's growth is a RATIO of the HALVED pool (%d on %d) — it scales"
		% [grown, devout.max_hp - grown])
	_report.append("§5 Unkillable's mend and Conviction's growth are ratios of max_hp and scale with the halved pool; TENACITY'S +15 A BLOCK IS FLAT and does not — reported, not changed.")
	ok(run.MODIFIERS.has("rot"), "§5: (the bargain the battle was fought under)")
	await _kill(scene)


# ---------- §5 live: the halving does not leave the battle ----------
#
# THE NEGATIVE CONTROL AQ'S DROP WAS ABOUT: without `+ rot_hp_lost` at the sync
# the party member keeps the halved maximum and a one-fight bargain costs half
# the party's health for the rest of the run, with nothing crashing to say so.
func _live_rot_leaves_the_battle() -> void:
	var run := root.get_node("/root/Run")
	var scene := await _spawn(["warden", "pyromancer", "inquisitor", "beastmaster"],
		{}, 3, "rot")
	var pre: Array = []
	for i in run.party.size():
		pre.append(int(run.party[i]["max_hp"]))
		var h: BattleUnit = _hero(scene, i)
		ok(h.max_hp + h.rot_hp_lost == int(run.party[i]["max_hp"]),
			"§5: hero %d entered the fight at the member's maximum (%d + %d)"
			% [i, h.max_hp, h.rot_hp_lost])
	for e in scene.get("enemies"):
		e.hp = 0
		e.call("_die")
	scene.call("_check_end")
	ok(bool(scene.get("battle_over")), "§5: the victory branch really ran")
	for i in run.party.size():
		ok(int(run.party[i]["max_hp"]) == int(pre[i]),
			"§5: hero %d's max_hp RETURNS to its pre-battle value (%d, was %d in the fight)"
			% [i, int(run.party[i]["max_hp"]), _hero(scene, i).max_hp])
		ok(int(run.party[i]["hp"]) <= int(run.party[i]["max_hp"]),
			"§5: ...with hp clamped under the restored maximum")
		ok(int(run.party[i]["hp"]) >= 1, "§5: ...and at least 1")
	await _kill(scene)


# ---------- §5 live: THREE FIELDS, ONE SYNC ----------
#
# THE COMBINATION NOBODY WOULD WRITE BY HAND AND THE ONE THAT WOULD FAIL
# SILENTLY: a Devout growing, a Warden's Tenacity growing, and Rot active, all
# in one battle. Two of the three cancel arithmetically if you are careless, so
# the magnitudes here are deliberately DIFFERENT.
func _live_three_fields_one_sync() -> void:
	var run := root.get_node("/root/Run")
	var scene := await _spawn(["warden", "pyromancer", "inquisitor", "beastmaster"],
		{}, 3, "rot")
	var warden := _hero(scene, 0)
	var devout := _hero(scene, 2)
	var pre_warden := int(run.party[0]["max_hp"])
	var pre_devout := int(run.party[2]["max_hp"])
	# TENACITY: the block site writes BOTH lines together, asserted at the
	# source so this stand-in cannot drift from what the game does.
	var bsrc := _src("res://scripts/battle.gd")
	ok(bsrc.contains("strike_target.max_hp += 15")
		and bsrc.contains("strike_target.tenacity_hp_gained += 15"),
		"§5: the Tenacity site raises max_hp and banks the same 15")
	for _block in 4:
		warden.max_hp += 15
		warden.tenacity_hp_gained += 15
	# CONVICTION: driven through the real function, four releases.
	for _release in 4:
		scene.call("_conviction_growth", devout, true)
	ok(warden.tenacity_hp_gained == 60, "§5: the Warden grew 60 from Tenacity")
	ok(devout.conviction_hp_gained > 0,
		"§5: the Devout grew %d from Conviction" % devout.conviction_hp_gained)
	ok(warden.rot_hp_lost > 0 and devout.rot_hp_lost > 0,
		"§5: and both of them are standing in Rot")
	ok(warden.tenacity_hp_gained != warden.rot_hp_lost,
		"§5: the two magnitudes DIFFER, so a sign error cannot cancel out (%d vs %d)"
		% [warden.tenacity_hp_gained, warden.rot_hp_lost])
	ok(devout.conviction_hp_gained != devout.rot_hp_lost,
		"§5: ...on the Devout too (%d vs %d)"
		% [devout.conviction_hp_gained, devout.rot_hp_lost])
	for e in scene.get("enemies"):
		e.hp = 0
		e.call("_die")
	scene.call("_check_end")
	ok(int(run.party[0]["max_hp"]) == pre_warden,
		"§5: THE WARDEN LEAVES AT HIS OWN MAXIMUM — Tenacity off, Rot back on (%d, want %d)"
		% [int(run.party[0]["max_hp"]), pre_warden])
	ok(int(run.party[2]["max_hp"]) == pre_devout,
		"§5: THE DEVOUT LEAVES AT HIS OWN MAXIMUM — Conviction off, Rot back on (%d, want %d)"
		% [int(run.party[2]["max_hp"]), pre_devout])
	for i in run.party.size():
		ok(int(run.party[i]["hp"]) <= int(run.party[i]["max_hp"]),
			"§5: hero %d's hp is clamped in the same step" % i)
	await _kill(scene)


# ---------- §6: Ashes of Al'ar has a home ----------

func _ashes_pools() -> void:
	var mage: Array = Classes.class_pool("mage")
	ok(mage.has("Ashes of Al'ar"),
		"§6: Ashes of Al'ar is in CLASS_POOLS[mage], as §6 instructed")
	ok(mage.size() == 12,
		"§6: THE MAGE CLASS POOL IS TWELVE AGAIN (got %d) — it lost one when Flame Shield stopped existing"
		% mage.size())
	# THE CORRECTION §6 NEEDED, PINNED: the class draw was retired in Batch AN
	# §4, so a class-pool entry alone would be unreachable. The live draw reads
	# SPEC pools, and all three Mage specs carry it.
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		ok(Classes.spec_pool(spec).has("Ashes of Al'ar"),
			"§6: %s can earn it — the pool the LIVE draw reads" % spec)
	var src := _src("res://scripts/run_state.gd")
	ok(src.contains("var offer := roll_spec_ability_offer(member)"),
		"§6: `award_ability_pick` still reads the SPEC pool (the AN §4 rule)")
	# It resolves, and it is legal in a class pool by AH's curation rule: a
	# self-revive reads nothing but the taker's own health.
	var ab: Ability = Classes.pool_ability("Ashes of Al'ar")
	ok(ab != null, "§6: the pool entry resolves to an Ability")
	if ab == null:
		return
	ok(ab.display_name == "Ashes of Al'ar", "§6: ...to its own name")
	ok(ab.faith_cost == 0, "§6: ...costing no Mercy/Faith (AH's curation rule)")
	ok(ab.special == "ashes", "§6: ...and carrying the guard's own special")
	ok(ab.cost > 0 and ab.delay > 0.0,
		"§6: the wrapper has a real cost and a real initiative price")
	# It is EARNABLE, never default: no Mage opens with it and no node grants it.
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		for kit in Classes.spec_abilities(spec):
			ok(kit.display_name != "Ashes of Al'ar",
				"§6: %s does not START with it — earnable, not default" % spec)
	ok(Talents.granted_ability("Ashes of Al'ar") == null,
		"§6: no talent node grants it — AR's removal stands")


func _ashes_offers() -> void:
	var run := root.get_node("/root/Run")
	# OFFERABLE to a Cryomancer and an Arcanist: over enough rolls out of a
	# 3-4 deep pool the entry has to show up.
	for spec in ["cryomancer", "arcanist"]:
		var seen := false
		for _trial in 60:
			var m := {"key": "mage", "spec": spec, "bm_abilities": [],
				"tree": [], "talents": {}}
			if run.roll_spec_ability_offer(m).has("Ashes of Al'ar"):
				seen = true
				break
		ok(seen, "§6: a %s is offered Ashes of Al'ar" % spec)
	# NOT OFFERED to a Pyromancer who already holds it — `owned_ability_names`
	# reads earned picks, so the filter is the live one.
	var held := {"key": "mage", "spec": "pyromancer",
		"bm_abilities": ["Ashes of Al'ar"], "tree": [], "talents": {}}
	var repeats := 0
	for _trial in 60:
		if run.roll_spec_ability_offer(held).has("Ashes of Al'ar"):
			repeats += 1
	ok(repeats == 0,
		"§6: a Pyromancer who ALREADY HOLDS IT is never offered it again (%d of 60)"
		% repeats)
	# ...and the un-owning Pyromancer still is, or the filter is just broken.
	var fresh := {"key": "mage", "spec": "pyromancer", "bm_abilities": [],
		"tree": [], "talents": {}}
	var offered := false
	for _trial in 60:
		if run.roll_spec_ability_offer(fresh).has("Ashes of Al'ar"):
			offered = true
			break
	ok(offered,
		"§6: ...while a Pyromancer who does NOT hold it can still buy his escape hatch back")


# ---------- §6 live: the phoenix ----------

func _live_ashes_returns_the_mage() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var mage := _hero(scene, 1)
	var ashes: Ability = Classes.pool_ability("Ashes of Al'ar")
	ok(mage.ashes_return == 0, "§6: a Mage who never cast it is not armed")
	# A lethal blow with nothing armed simply kills.
	var doomed := mage.max_hp * 10
	mage.take_hit(doomed, 0)
	ok(mage.dead, "§6: ...and dies to a lethal blow, as AR left him")
	mage.revive(1.0)
	mage.hp = mage.max_hp
	await scene.call("_resolve_special", mage, ashes, mage, "good", 1.0)
	ok(mage.ashes_return == _const(scene, "ASHES_RETURN"),
		"§6: the cast arms the return share (%d%%)" % mage.ashes_return)
	mage.take_hit(doomed, 0)
	ok(not mage.dead,
		"§6: THE PHOENIX REFUSES THE GRAVE — the lethal blow is survived")
	ok(mage.hp == maxi(int(mage.max_hp * 0.01 * _const(scene, "ASHES_RETURN")), 1),
		"§6: ...and he returns at exactly %d%% (%d of %d)"
		% [_const(scene, "ASHES_RETURN"), mage.hp, mage.max_hp])
	ok(mage.ashes_used, "§6: the rise is spent")
	# ONCE PER BATTLE: the second lethal blow lands.
	mage.take_hit(doomed, 0)
	ok(mage.dead, "§6: ...and it is ONCE PER BATTLE — the second one kills")
	# A tick death is refused exactly as an attack death is (one guard, two
	# callers), and the perfect pays more.
	mage.revive(1.0)
	mage.hp = mage.max_hp
	mage.ashes_used = false
	await scene.call("_resolve_special", mage, ashes, mage, "perfect", 1.0)
	ok(mage.ashes_return == _const(scene, "ASHES_RETURN_PERFECT"),
		"§6: a perfect cast returns him higher (%d%%)" % mage.ashes_return)
	mage.take_tick_damage(doomed, "-x", Color.WHITE)
	ok(not mage.dead,
		"§6: a TICK death is refused too — one guard, two callers")
	await _kill(scene)


# ---------- §7: the documentation the batch owes ----------

func _docs() -> void:
	var doc := _src("res://docs/master.html")
	ok(doc != "", "§7: master.html is readable")
	# RE-POINTED BY BATCH BE (BB -> BE) AND AGAIN BY BATCH BF (BD -> BF), with
	# the reason in the file: this duplicates test_batch_ah's stamp gate, which
	# is the canonical one and moves with every batch that touches the doc. What
	# it is really guarding is that the doc was touched AT ALL. Bump it, do not
	# delete it.
	ok(doc.contains("Last updated: 2026-08-09 (Batch BG)"),
		"§7: master.html carries the current batch's stamp")
	ok(doc.contains("Rot"), "§7: §3a's modifier table has Rot back")
	# The pool tables are verbatim — test_batch_ah asserts them too, so this is
	# the early warning rather than the only guard.
	ok(doc.contains(", ".join(Classes.CLASS_POOLS["mage"])),
		"§7: §6a lists the mage class pool verbatim, Ashes of Al'ar included")
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		ok(doc.contains(", ".join(Classes.spec_pool(spec))),
			"§7: §6a lists %s's spec pool verbatim" % spec)
	var gl := _src("res://data/glossary.json")
	ok(gl.contains("there is no duration to refresh, so it adds a stack instead"),
		"§7: the glossary's Poison entry names Creeping Death's split behaviour")
	ok(gl.contains("holds LESS Loyalty"),
		"§7: the Pack Bond and Loyalty entries carry the corrected swap rule")
	ok(gl.contains("There are twenty, weighted toward the mild end"),
		"§7: the Modifier entry counts twenty")
	# §7 asked for "a Rot entry IF the modifier list is enumerated there". IT IS
	# NOT — the glossary teaches the SYSTEM (bargain / modifier / severity) and
	# names Feverish and Bloodless only as examples, and not one of the twenty
	# has an entry of its own. Rot gets none for the same reason, and the
	# condition is pinned so a later batch does not read the absence as a gap.
	var enumerated := 0
	for name in ["\"mirrorbound\"", "\"bloodletting\"", "\"encumbered\"", "\"hoarfrost\""]:
		if gl.contains(name):
			enumerated += 1
	ok(enumerated == 0,
		"§7: the glossary does not enumerate modifiers, so Rot correctly has no entry (%d found)"
		% enumerated)
	var cm := _src("res://CLAUDE.md")
	ok(cm.contains("rot_hp_lost"),
		"§7: CLAUDE.md states the three-field ordering at the victory sync")
	ok(cm.contains("BATCH BB"), "§7: CLAUDE.md carries the batch block")
	var log := _src("res://docs/changelog.html")
	ok(log.contains("Batch BB"), "§7: the changelog has this batch's entry")
	# §7: the entry LEADS with §3's number, and it carries both halves with
	# sample counts and deepest marks the way AX printed them, so the three
	# rows are comparable. The number is what §3 was actually asking for, and
	# it had never reached a changelog before.
	# ANCHOR REPAIRED BY BATCH BE, and it was READING THE WRONG ENTRY. It used
	# to slice on the bare phrase "Batch BB", which BC's own changelog entry
	# then reproduced in its regression line ("every suite at its Batch BB
	# count") — so from BC onward the slice was the TAIL OF BC'S ENTRY and all
	# four checks below failed for a reason that had nothing to do with BB.
	# REPRODUCED ON UNMODIFIED HEAD before it was touched. It anchors on the
	# HEADING now and ends at the next one, which no later entry's prose can
	# imitate. The four assertions themselves are byte-unchanged: the question
	# was always right, only the text it was asked of was wrong.
	var bb: String = log.split("<h2>2026-08-09 &mdash; Batch BB")[1].split("<h2>")[0]
	ok(bb.contains("trash 0.07") and bb.contains("n=566") and bb.contains("deepest mark 31"),
		"§7: the entry carries the trash half in full")
	ok(bb.contains("boss 0.60") and bb.contains("n=25") and bb.contains("deepest mark 18"),
		"§7: ...and the boss half in full")
	ok(bb.contains("AX's trash 0.00") and bb.contains("AY's trash 0.06"),
		"§7: ...beside AX's and AY's rows, so the three are comparable")
	ok(bb.find("detonations/battle") < bb.find("&sect;1"),
		"§7: ...and it LEADS the entry")
