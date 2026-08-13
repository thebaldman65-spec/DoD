# test_batch_ak.gd — the Swordmaster kit correction and the re-authored
# tree. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ak.gd
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE KIT CORRECTION — Guard Change is back in the opening three and
#      Shatterpoint is earnable, with EXACTLY ONE definition of each. The
#      whole batch rests on the Swordmaster being able to change stance;
#      a silent regression here turns a quarter of the tree inert again,
#      which is precisely the bug Batch AH shipped and flagged.
#   2. THE POOLS STILL RESOLVE — every entry of every pool, all 12 specs
#      and 4 classes, still returns an Ability. Moving a def between two
#      resolvers is exactly how that breaks.
#   3. ALL 24 NODES — id, row, lane, and the magnitude each one carries.
#      The rows are exclusive, so a number IS the node.
#   4. THE CONDITIONAL HALVES — Sunder Guard's Shatterpoint hook and Off
#      Balance's cross-row widening, each proven to fire when its condition
#      holds, to stay dark when it does not, and to stay dark on an empty
#      ctx (the Batch AI §5 safe direction).
#   5. THE UPGRADE PATHS — Lunge and Execute both sit in the spec pool AND
#      the tree. Granted when unowned, upgraded when already earned, never
#      double-granted either way.
#   6. LIVE — a spawned battle, because the BD spread, the parry spike, the
#      parry counter and Execute's pricing only exist at cast time.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# id -> [row, lane, name, stat field, value]. The layout table of §Layout
# and the magnitudes of §Rows 1-8, transcribed once so a re-tune has to
# come here and say so.
const NODES := {
	"sm_agg_stance": [1, "Blade", "Aggressive Stance", "seasoned_off_bonus", 0.12],
	"sm_def_stance": [1, "Poise", "Defensive Stance", "seasoned_def_bonus", 0.12],
	"sm_flourish": [1, "Breaker", "Pressure Point", "pressure_point_ranks", 1],
	"sm_lunge": [2, "Blade", "Lunge", "", 0],
	"sm_sword_mastery": [2, "Poise", "Sword Mastery", "parry_bonus", 0.12],
	"sm_blade_dance": [2, "Breaker", "Sunder Guard", "guard_change_bd", 40],
	"sm_keen_edge": [3, "Blade", "Killing Edge", "killing_edge_ranks", 1],
	"sm_footwork": [3, "Poise", "Bracing", "bracing_ranks", 1],
	"sm_dominant": [3, "Breaker", "Dominant Presence", "dominant_ranks", 1],
	"sm_precision": [4, "Blade", "Precision Strikes", "precision_ranks", 1],
	"sm_swordsmanship": [4, "Poise", "Swordsmanship", "swordsmanship_parry", 0.15],
	"sm_opportunist": [4, "Breaker", "Opportunist", "opportunist", 1],
	"sm_seasoned_node": [5, "Blade", "Seasoned Fighter", "blade_crit_ranks", 1],
	"sm_high_guard": [5, "Poise", "High Guard", "high_guard", 1],
	"sm_perfect_form": [5, "Breaker", "No Quarter", "no_quarter_ranks", 1],
	"sm_momentum_sm": [6, "Blade", "Overwhelm", "overwhelm_ranks", 1],
	"sm_riposte": [6, "Poise", "Riposte", "counter_attacks", 1],
	"sm_punish": [6, "Breaker", "Punishment", "punishment_ranks", 1],
	"sm_deep_thrust": [7, "Blade", "Tempo", "tempo_ranks", 1],
	"sm_composure": [7, "Poise", "Deflection", "deflection", 1],
	"sm_guarded": [7, "Breaker", "Off Balance", "off_balance_ranks", 1],
	"sm_execute": [9, "Blade", "Execute", "", 0],
	"sm_untouchable": [9, "Poise", "Untouchable", "untouchable", 1],
	"sm_en_garde": [9, "Breaker", "Guard Breaker", "guard_breaker", 1],
}

# The number the tooltip must render for the nodes whose whole content is a
# magnitude. desc_for() renders at rank 1, the only rank a node ever has.
const DESC_NUMBERS := {
	"sm_agg_stance": "12", "sm_def_stance": "12", "sm_flourish": "30",
	"sm_sword_mastery": "12", "sm_blade_dance": "40", "sm_keen_edge": "15",
	"sm_footwork": "30", "sm_dominant": "15", "sm_precision": "20",
	"sm_swordsmanship": "25", "sm_seasoned_node": "15", "sm_perfect_form": "45",
	"sm_momentum_sm": "8", "sm_punish": "60", "sm_deep_thrust": "30",
	"sm_guarded": "20",
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
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_ak_test.json"
	Profile.loaded = false
	Profile.data = {}

	_kit_correction()
	_pools_resolve()
	_tree_shape()
	_node_values()
	_conditional_halves()
	_upgrade_paths()
	_no_rune_regression()
	await _live_guard_change()
	await _live_parry()
	await _live_execute()
	await _live_lunge()
	await _live_off_balance()

	if FileAccess.file_exists("user://profile_batch_ak_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ak_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH AK: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


func _ability_names(list: Array) -> Array:
	var out: Array = []
	for a in list:
		out.append(a.display_name)
	return out


# ---------- 1. the kit correction ----------

func _kit_correction() -> void:
	var kit := _ability_names(Classes.spec_abilities("swordmaster"))
	ok(kit.size() == 3, "the Swordmaster still opens with exactly 3 spec abilities (has %d)" % kit.size())
	ok(kit.has("Overpower"), "Overpower is in the opening three")
	ok(kit.has("Pommel Strike"), "Pommel Strike is in the opening three")
	ok(kit.has("Guard Change"),
		"GUARD CHANGE IS BACK IN THE OPENING THREE — the only stance swap in the game")
	ok(not kit.has("Shatterpoint"), "Shatterpoint left the opening three")

	var pool: Array = Classes.spec_pool("swordmaster")
	ok(pool.size() == 4, "the spec pool still holds 4 (has %d)" % pool.size())
	ok(pool.has("Shatterpoint"), "Shatterpoint is earnable from the spec pool")
	ok(pool.has("Sweeping Strikes") and pool.has("Lunge") and pool.has("Execute"),
		"the other three spec-pool entries are unchanged")
	ok(not pool.has("Guard Change"), "Guard Change left the spec pool")

	# EXACTLY ONE definition of each: a second copy is how a pool entry
	# drifts from the kit's, which is the whole point of the resolvers.
	ok(Classes.trimmed_kit_ability("Shatterpoint") != null,
		"Shatterpoint has a trimmed-kit def, so an offer can hand it over")
	ok(Classes.trimmed_kit_ability("Guard Change") == null,
		"Guard Change has NO second def — the kit's copy is the only one")
	for name in kit:
		ok(Classes.trimmed_kit_ability(name) == null,
			"'%s' is in the kit and so must not also be a trimmed def" % name)

	# Whichever resolver it goes through, Shatterpoint keeps its numbers.
	var sp := Classes.pool_ability("Shatterpoint")
	ok(sp != null, "pool_ability resolves Shatterpoint")
	if sp != null:
		ok(sp.cost == 30 and sp.damage == 20 and sp.pressure == 40 \
			and sp.cooldown == 4,
			"the earnable Shatterpoint carries the kit's numbers (30/20/40/4cd)")

	# The class pool's stance exclusion (Batch AH's curation rule) survives.
	var warrior: Array = Classes.class_pool("warrior")
	ok(warrior.has("Shatterpoint"), "the warrior class pool still holds Shatterpoint")
	ok(not warrior.has("Guard Change") and not warrior.has("Lunge"),
		"the stance pieces stay out of the class pool — a sibling has no stance to swap")

	# The passive blurb must not still advertise Guard Change as earnable.
	var blurb := String(Classes.SPEC_INFO["swordmaster"]["passive_desc"])
	ok(not blurb.contains("earnable"),
		"the Seasoned Fighter blurb no longer calls Guard Change earnable")
	ok(blurb.contains("Guard Change"), "...but still names what does the swapping")


# ---------- 2. every pool entry still resolves ----------

func _pools_resolve() -> void:
	for spec in Classes.SPEC_POOLS:
		for name in Classes.SPEC_POOLS[spec]:
			ok(Classes.spec_pool_ability(spec, String(name)) != null,
				"spec pool %s: '%s' resolves" % [spec, name])
	for class_key in Classes.CLASS_POOLS:
		for name in Classes.CLASS_POOLS[class_key]:
			ok(Classes.pool_ability(String(name)) != null,
				"class pool %s: '%s' resolves" % [class_key, name])


# ---------- 3. the tree still fits the Batch AI mould ----------

func _tree_shape() -> void:
	var tree: Array = Talents.generate_tree("swordmaster", "warrior")
	ok(tree.size() == 27, "the tree is 27 cells (has %d)" % tree.size())
	var seen := {}
	for node in tree:
		# BATCH BM: this batch's table is THIS BATCH'S RECORD OF ITS OWN 24
		# NODES, and BM added a ROW-8 node to every lane. The walk skips row 8
		# rather than being taught the three new ids: what the check exists to
		# prove is that the twenty-four survive UNCHANGED, and asserting that
		# nothing else exists would make every later addition a failure here
		# instead of in the batch that made it.
		if int(node["row"]) == 8:
			continue
		var id := String(node["id"])
		ok(NODES.has(id), "'%s' is a node the layout table names" % id)
		ok(not seen.has(id), "'%s' appears once" % id)
		seen[id] = true
		ok(int(node.get("ranks", 0)) == 1, "'%s' holds a single rank" % id)
		ok(not node.has("tier"), "'%s' carries no retired tier field" % id)
		if not NODES.has(id):
			continue
		var want: Array = NODES[id]
		ok(int(node["row"]) == int(want[0]),
			"'%s' sits in row %d, want %d" % [id, int(node["row"]), int(want[0])])
		ok(String(node["lane"]) == String(want[1]),
			"'%s' sits in lane %s, want %s" % [id, node["lane"], want[1]])
		ok(String(node["name"]) == String(want[2]),
			"'%s' is named '%s', want '%s'" % [id, node["name"], want[2]])
		ok(node.get("capstone", false) == (int(want[0]) == Talents.CAPSTONE_ROW),
			"'%s' is flagged capstone iff it sits on the shelf" % id)
	for id in NODES:
		ok(seen.has(id), "'%s' kept its id through the re-author" % id)
	# One node per lane per row, the Batch AI rule the class batch must not
	# break — the layout table is the promise, this is the check.
	for row in range(1, Talents.CAPSTONE_ROW + 1):
		var lanes := {}
		for node in Talents.row_nodes(tree, row):
			lanes[String(node["lane"])] = true
		ok(lanes.size() == 3, "row %d holds one node in each of the 3 lanes" % row)


# ---------- 4. what each node is worth ----------

func _node_values() -> void:
	var tree: Array = Talents.generate_tree("swordmaster", "warrior")
	for node in tree:
		var id := String(node["id"])
		if not NODES.has(id):
			continue
		var field := String(NODES[id][3])
		if field == "":
			continue  # the two ability-granting nodes, covered in §5
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, node["payload"], 1,
			{"learned": {id: 1}, "member": {}})
		ok(cfg.has(field), "'%s' writes %s" % [id, field])
		if cfg.has(field):
			var got = cfg[field]
			var want = NODES[id][4]
			var same: bool = (abs(float(got) - float(want)) < 0.0001) \
				if want is float else (got == want)
			ok(same, "'%s' writes %s = %s, want %s" % [id, field, str(got), str(want)])
	# The tooltip has to render the number the designer chose, not the old
	# one — the desc and the payload are two hand-written places.
	for id in DESC_NUMBERS:
		var node: Dictionary = Talents.node_in_tree(tree, id)
		ok(not node.is_empty(), "'%s' is in the tree" % id)
		if node.is_empty():
			continue
		var text := Talents.desc_for(node, 1)
		ok(text.contains(String(DESC_NUMBERS[id])),
			"'%s' tooltip renders %s: \"%s\"" % [id, DESC_NUMBERS[id], text])
		ok(not text.contains("{v}"), "'%s' tooltip has no unrendered placeholder" % id)
	# High Guard's whole content is prose, so it is checked by hand.
	var hg: Dictionary = Talents.node_in_tree(tree, "sm_high_guard")
	ok(Talents.desc_for(hg, 1).contains("40%") \
		and Talents.desc_for(hg, 1).contains("2 turns"),
		"High Guard's tooltip says 40% for 2 turns")
	# Riposte and Opportunist both answer with Overpower now; the tooltips
	# have to say so or the player cannot tell they are the same answer.
	ok(Talents.desc_for(Talents.node_in_tree(tree, "sm_riposte"), 1).contains("Overpower"),
		"Riposte's tooltip names Overpower, not a Strike")
	ok(Talents.desc_for(Talents.node_in_tree(tree, "sm_opportunist"), 1).contains("PARRIED"),
		"Opportunist's tooltip names the parry trigger")


# ---------- 5. the conditional halves ----------

func _member(learned: Dictionary, earned: Array = []) -> Dictionary:
	return {"key": "warrior", "spec": "swordmaster", "talents": learned,
		"tree": Talents.generate_tree("swordmaster", "warrior"),
		"bm_abilities": earned}


func _applied(learned: Dictionary, earned: Array = [],
		abilities: Array = []) -> Dictionary:
	var member := _member(learned, earned)
	var cfg := {"abilities": abilities}
	Talents.apply_from_tree(cfg, member["tree"], learned, member)
	return cfg


func _conditional_halves() -> void:
	# --- Sunder Guard: the Guard Change half is unconditional, the
	# Shatterpoint half rides owns_ability.
	var plain := _applied({"sm_blade_dance": 1})
	ok(int(plain.get("guard_change_bd", 0)) == 40,
		"Sunder Guard loads Guard Change unconditionally (40 BD)")
	ok(int(plain.get("sunder_guard_bd", 0)) == 0,
		"...and pays nothing toward a Shatterpoint he does not own")
	var with_sp := _applied({"sm_blade_dance": 1}, ["Shatterpoint"])
	ok(int(with_sp.get("guard_change_bd", 0)) == 40,
		"with Shatterpoint earned, Guard Change still gets its 40")
	ok(int(with_sp.get("sunder_guard_bd", 0)) == 40,
		"...and the ability hook pays its +40 as well")
	# The hook must read the LIVE ability list, so the base kit alone is
	# not enough — Shatterpoint left it in §1.
	ok(not Talents.owns_ability(_member({}), "Shatterpoint"),
		"an un-upgraded Swordmaster does not own Shatterpoint")
	ok(Talents.owns_ability(_member({}, ["Shatterpoint"]), "Shatterpoint"),
		"...and owns it once it is earned")
	ok(Talents.owns_ability(_member({}), "Guard Change"),
		"every Swordmaster owns Guard Change from the start (the §1 guarantee)")

	# --- Off Balance: the cross-row condition on has_node.
	var solo := _applied({"sm_guarded": 1})
	ok(int(solo.get("off_balance_ranks", 0)) == 1, "Off Balance alone still applies")
	ok(int(solo.get("off_balance_wide", 0)) == 0,
		"...and does NOT widen without Punishment")
	var both := _applied({"sm_guarded": 1, "sm_punish": 1})
	ok(int(both.get("off_balance_wide", 0)) == 1,
		"Punishment taken as well widens the window")
	ok(int(both.get("punishment_ranks", 0)) == 1,
		"...and Punishment itself is unaffected")

	# An empty ctx leaves a conditional half INERT — the Batch AI §5 rule:
	# an effect that fails to appear is a bug you can see.
	var tree: Array = Talents.generate_tree("swordmaster", "warrior")
	for id in ["sm_blade_dance", "sm_guarded"]:
		var bare := {"abilities": []}
		Talents.apply_payload(bare, Talents.node_in_tree(tree, id)["payload"], 1)
		ok(int(bare.get("sunder_guard_bd", 0)) == 0 \
			and int(bare.get("off_balance_wide", 0)) == 0,
			"'%s' second half is inert on an empty ctx" % id)
		# ...but the UNCONDITIONAL half still lands, or the node is broken.
		ok(bare.size() > 1, "'%s' first half still lands on an empty ctx" % id)


# ---------- 6. grant, or upgrade ----------

func _upgrade_paths() -> void:
	# Lunge, unowned: the node grants it at full price and nothing upgrades.
	var fresh := _applied({"sm_lunge": 1})
	var fresh_names := _ability_names(fresh["abilities"])
	ok(fresh_names.count("Lunge") == 1, "the node grants Lunge when he has none")
	ok(int(fresh.get("lunge_upgraded", 0)) == 0, "...and marks no upgrade")
	for a in fresh["abilities"]:
		if a.display_name == "Lunge":
			ok(a.cost == 25, "...at the ordinary 25 Rage (got %d)" % a.cost)

	# Lunge, already earned from a pool pick: upgraded, never duplicated.
	# Earned picks go on BEFORE the tree at both real call sites, which is
	# what this arrangement reproduces.
	var earned_lunge := Classes.spec_pool_ability("swordmaster", "Lunge")
	ok(earned_lunge != null, "Lunge resolves out of the spec pool")
	var up := _applied({"sm_lunge": 1}, ["Lunge"], [earned_lunge])
	var up_names := _ability_names(up["abilities"])
	ok(up_names.count("Lunge") == 1, "an earned Lunge is not granted a second time")
	ok(int(up.get("lunge_upgraded", 0)) == 1, "...the node marks the UPGRADE instead")
	for a in up["abilities"]:
		if a.display_name == "Lunge":
			ok(a.cost == 15, "...the cost drops to 15 Rage (got %d)" % a.cost)
			ok(a.description.contains("Exposes AND"),
				"...and the description says it applies both wounds")

	# Execute, the same shape one row later.
	var cap_fresh := _applied({"sm_execute": 1})
	ok(_ability_names(cap_fresh["abilities"]).count("Execute") == 1,
		"the capstone grants Execute when he has none")
	ok(int(cap_fresh.get("execute_upgraded", 0)) == 0, "...and marks no upgrade")
	var earned_exec := Classes.spec_pool_ability("swordmaster", "Execute")
	var cap_up := _applied({"sm_execute": 1}, ["Execute"], [earned_exec])
	ok(_ability_names(cap_up["abilities"]).count("Execute") == 1,
		"an earned Execute is not granted a second time")
	ok(int(cap_up.get("execute_upgraded", 0)) == 1,
		"...the capstone marks the UPGRADE instead")
	for a in cap_up["abilities"]:
		if a.display_name == "Execute":
			ok(a.description.contains("35%") and a.description.contains("FREE"),
				"...and the description states the 35% threshold and the free cast")

	# The two names are in the pools that make this reachable at all.
	ok(Classes.spec_pool("swordmaster").has("Lunge") \
		and Classes.spec_pool("swordmaster").has("Execute"),
		"both upgradeable abilities are actually earnable")


# ---------- 7. the shared applicator is unchanged for runes ----------

func _no_rune_regression() -> void:
	# apply_payload is shared with shop runes. The two new keys are opt-in:
	# a payload without them has to behave exactly as it did.
	var cfg := {"abilities": []}
	Talents.apply_payload(cfg, {"stat": {"crit_bonus": 0.08}}, 1)
	ok(abs(float(cfg.get("crit_bonus", 0.0)) - 0.08) < 0.0001,
		"a plain stat payload is untouched")
	Talents.apply_payload(cfg, {"stat": {"crit_bonus": 0.08}}, 3)
	ok(abs(float(cfg["crit_bonus"]) - 0.32) < 0.0001,
		"...and still multiplies by ranks (runes pass them)")
	# A conditional rune payload with no ctx is still inert.
	var gated := {"abilities": []}
	Talents.apply_payload(gated, {"condition": {"has_node": "sm_punish"},
		"stat": {"crit_bonus": 0.1}}, 1)
	ok(not gated.has("crit_bonus"), "a conditional payload with no ctx stays inert")
	# Every authored rune still applies without an `also`/`upgrade` key.
	var touched := 0
	for rune_id in Runes.ids():
		var entry: Dictionary = Runes.config(String(rune_id))
		var rcfg := {"abilities": []}
		Talents.apply_payload(rcfg, entry.get("payload", {}), 1,
			{"learned": {}, "member": {}})
		touched += 1
	ok(touched > 40, "the whole authored rune pool still applies (%d entries)" % touched)


# ---------- the live half ----------

# Spawns a battle FROZEN on the first hero turn: no autoplay, so nothing
# acts on its own and every cast below is one this test drove.
func _spawn(specs: Array, lineup: Array, prep := Callable()) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	if prep.is_valid():
		prep.call(run)
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	return scene


func _sm(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "seasoned":
			return h
	return null


func _find(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


# ---------- 8. Guard Change: the spread, and the parry spike ----------

func _live_guard_change() -> void:
	# Without Sunder Guard: 15 BD to the ONE enemy nearest to Breaking.
	var plain := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider", "archer", "archer"])
	var sm := _sm(plain)
	ok(sm != null, "the Swordmaster spawned")
	if sm != null:
		ok(_find(sm, "Guard Change") != null,
			"LIVE: Guard Change is on his bar from turn one")
		ok(_find(sm, "Shatterpoint") == null,
			"LIVE: Shatterpoint is not, until he earns it")
		ok(sm.abilities.size() == 4,
			"LIVE: core attack + 3 spec abilities (has %d)" % sm.abilities.size())
		var foes: Array = plain.get("enemies")
		for e in foes:
			e.pressure = 0
		foes[1].pressure = 30  # the mark: nearest to Breaking
		await plain._resolve_special(sm, _find(sm, "Guard Change"), sm, "good", 1.0)
		ok(foes[1].pressure > 0, "the plain pivot presses the enemy nearest to Breaking")
		ok(foes[0].pressure == 0 and foes[2].pressure == 0,
			"...and only that one")
		ok(sm.stance == "defensive", "...and the guard actually changed")
	plain.free()

	# With Sunder Guard: 40 BD to EVERY enemy. Swordsmanship raises the
	# perfect's parry grant from 10% to 25%.
	var prep := func(run):
		run.party[0]["talents"] = {"sm_blade_dance": 1, "sm_swordsmanship": 1}
	var wide := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider", "archer", "archer"], prep)
	var sm2 := _sm(wide)
	ok(sm2 != null, "the Sunder Guard Swordmaster spawned")
	if sm2 != null:
		ok(sm2.guard_change_bd == 40, "LIVE: Sunder Guard reached the unit (40)")
		ok(abs(sm2.swordsmanship_parry - 0.15) < 0.0001,
			"LIVE: Swordsmanship reached the unit (0.15 on top of the ability's 10%)")
		var foes: Array = wide.get("enemies")
		for e in foes:
			e.pressure = 0
		await wide._resolve_special(sm2, _find(sm2, "Guard Change"), sm2, "perfect", 1.0)
		var pressed := 0
		for e in foes:
			if e.pressure > 0 or e.broken:
				pressed += 1
		ok(pressed == foes.size(),
			"the sundering pivot presses EVERY enemy (%d of %d)" % [pressed, foes.size()])
		ok(sm2.has_status("parry_up"), "the perfect pivot grants Parry Up")
		ok(sm2.status_power("parry_up") == 25,
			"...at Swordsmanship's 25%%, not the base 10 (got %d)" % \
				sm2.status_power("parry_up"))
	wide.free()

	# ...and without the node, the perfect still grants the base 10.
	var base := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider", "archer"])
	var sm3 := _sm(base)
	if sm3 != null:
		await base._resolve_special(sm3, _find(sm3, "Guard Change"), sm3, "perfect", 1.0)
		ok(sm3.status_power("parry_up") == 10,
			"without Swordsmanship the perfect still grants the base 10%% (got %d)" % \
				sm3.status_power("parry_up"))
	base.free()

	# The Rune of the Still Wrist pays into the SAME field. It pointed at a
	# perfect Pommel Strike, whose parry blessing stopped existing in Batch
	# AH — this batch re-pointed it at the mechanic that survived. It has to
	# pay ON ITS OWN (a max() against the node's value would leave it inert)
	# and stack with the node when both are held.
	var wrist: Dictionary = Runes.config("still_wrist")
	ok(String(wrist.get("desc", "")).contains("Guard Change"),
		"the Still Wrist rune names the mechanic that still exists")
	var rune_only := {"abilities": []}
	Talents.apply_payload(rune_only, wrist["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(rune_only.get("swordsmanship_parry", 0.0)) - 0.05) < 0.0001,
		"the rune writes the live field")
	var stacked := _applied({"sm_swordsmanship": 1})
	Talents.apply_payload(stacked, wrist["payload"], 1, {"learned": {}, "member": {}})
	ok(abs(float(stacked["swordsmanship_parry"]) - 0.20) < 0.0001,
		"rune and node stack (0.20 = a 30%% grant)")
	var rune_prep := func(run):
		run.party[0]["runes"] = [{"id": "still_wrist", "equipped": true,
			"payload": wrist["payload"], "name": String(wrist["name"]),
			"rarity": String(wrist["rarity"])}]
	var runed := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider", "archer"], rune_prep)
	var sm4 := _sm(runed)
	if sm4 != null:
		await runed._resolve_special(sm4, _find(sm4, "Guard Change"), sm4, "perfect", 1.0)
		ok(sm4.status_power("parry_up") == 15,
			"LIVE: the rune ALONE deepens the perfect to 15%% (got %d)" % \
				sm4.status_power("parry_up"))
	runed.free()


# ---------- 9. a parry answers with Overpower, once ----------

func _live_parry() -> void:
	for node_id in ["sm_riposte", "sm_opportunist"]:
		var prep := func(run):
			run.party[0]["talents"] = {node_id: 1}
		var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
			["raider"], prep)
		var sm := _sm(scene)
		var foe: BattleUnit = scene.get("enemies")[0]
		ok(sm != null and foe != null, "%s: both combatants spawned" % node_id)
		if sm == null or foe == null:
			scene.free()
			continue
		# Force the parry: a certainty replaces the roll outright, and
		# No Cover (the Sharpshooter's bypass) takes the miss roll off the
		# table so the attack cannot whiff past the parry it is testing.
		sm.parry_chance = 1.0
		foe.no_cover = 1
		foe.hp = foe.max_hp * 4
		foe.max_hp = foe.hp
		ok(scene._roll_parry(sm) != "", "%s: the parry is forced" % node_id)
		var before := foe.hp
		scene.history.clear()
		await scene._resolve(foe, foe.abilities[0], sm, "good")
		var log_text: String = scene.history.get_parsed_text()
		ok(foe.hp < before,
			"%s: the parry is answered — the attacker took the counter" % node_id)
		# The Strike this used to be carries 18 BD against Overpower's 20,
		# so the damage cannot tell them apart. The log names the ability.
		ok(log_text.contains("answers the parry with Overpower"),
			"%s: ...and the counter is an OVERPOWER, not a basic Strike" % node_id)
		ok(log_text.contains("Swordmaster: Overpower"),
			"%s: ...which really resolved as Overpower" % node_id)
		scene.free()

	# Both nodes at once still fires ONE counter, not two: they are the
	# same answer bought from two lanes.
	var prep_both := func(run):
		run.party[0]["talents"] = {"sm_riposte": 1, "sm_opportunist": 1}
	var two := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider"], prep_both)
	var sm2 := _sm(two)
	var foe2: BattleUnit = two.get("enemies")[0]
	if sm2 != null and foe2 != null:
		sm2.parry_chance = 1.0
		foe2.no_cover = 1
		foe2.hp = foe2.max_hp * 4
		foe2.max_hp = foe2.hp
		two.history.clear()
		await two._resolve(foe2, foe2.abilities[0], sm2, "good")
		var both_log: String = two.history.get_parsed_text()
		ok(both_log.count("answers the parry with Overpower") == 1,
			"both nodes together still answer ONCE (%d counters)" % \
				both_log.count("answers the parry with Overpower"))
		ok(both_log.contains("Talent: Riposte"),
			"...and the log credits the node that paid for it")
	two.free()


# ---------- 10. Execute's threshold and its free cast ----------

func _live_execute() -> void:
	var prep := func(run):
		run.party[0]["bm_abilities"] = ["Execute"]
		run.party[0]["talents"] = {"sm_execute": 1}
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider", "archer"], prep)
	var sm := _sm(scene)
	ok(sm != null, "the upgraded-Execute Swordmaster spawned")
	if sm != null:
		ok(sm.execute_upgraded == 1, "LIVE: the capstone upgraded the earned Execute")
		var ex := _find(sm, "Execute")
		ok(ex != null, "...and there is exactly one Execute on the bar")
		var names := _ability_names(sm.abilities)
		ok(names.count("Execute") == 1, "...exactly one (found %d)" % names.count("Execute"))
		var foes: Array = scene.get("enemies")
		var prey: BattleUnit = foes[0]
		var other: BattleUnit = foes[1]
		if ex != null:
			# 30% health: dead to the upgraded threshold, safe from the old one.
			prey.hp = int(prey.max_hp * 0.30)
			other.hp = other.max_hp
			sm.resource = sm.max_resource
			ok(scene._ability_usable(sm, ex),
				"the upgraded Execute reaches a target at 30% health")
			sm.execute_upgraded = 0
			ok(not scene._ability_usable(sm, ex),
				"...and the un-upgraded one does not (the 20% rule is intact)")
			sm.execute_upgraded = 1
			# Free against a Broken target, full price against anyone else.
			ok(scene._eff_cost(sm, ex, other) == ex.cost,
				"the upgraded Execute costs full price against an unbroken target")
			prey.broken = true
			ok(scene._eff_cost(sm, ex, prey) == 0,
				"...and NOTHING against a Broken one")
			ok(scene._eff_cost(sm, ex) == 0,
				"...which is also what lights the button while a Broken enemy stands")
			sm.execute_upgraded = 0
			ok(scene._eff_cost(sm, ex, prey) == ex.cost,
				"an un-upgraded Execute is never free, Broken target or not")
	scene.free()


# ---------- 11. the upgraded Lunge wounds both ways ----------

func _live_lunge() -> void:
	var prep := func(run):
		run.party[0]["bm_abilities"] = ["Lunge"]
		run.party[0]["talents"] = {"sm_lunge": 1}
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider"], prep)
	var sm := _sm(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(sm != null, "the upgraded-Lunge Swordmaster spawned")
	if sm != null and foe != null:
		ok(sm.lunge_upgraded == 1, "LIVE: the node upgraded the earned Lunge")
		ok(_ability_names(sm.abilities).count("Lunge") == 1,
			"...and there is still one Lunge on the bar")
		foe.hp = foe.max_hp * 4  # survive the thrust so the statuses can be read
		foe.max_hp = foe.hp
		sm.no_cover = 1          # ...and cannot whiff past the wounds it applies
		sm.stance = "aggressive"
		await scene._resolve(sm, _find(sm, "Lunge"), foe, "good")
		ok(foe.has_status("exposed") and foe.has_status("cripple"),
			"the upgraded Lunge applies BOTH wounds from the Aggressive guard")
	scene.free()

	# The un-upgraded Lunge still picks by stance — the node's base grant
	# must not have quietly inherited the upgrade.
	var prep_plain := func(run):
		run.party[0]["talents"] = {"sm_lunge": 1}
	var plain := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider"], prep_plain)
	var sm2 := _sm(plain)
	var foe2: BattleUnit = plain.get("enemies")[0]
	if sm2 != null and foe2 != null:
		ok(sm2.lunge_upgraded == 0, "a granted Lunge is not upgraded")
		foe2.hp = foe2.max_hp * 4
		foe2.max_hp = foe2.hp
		sm2.no_cover = 1
		sm2.stance = "aggressive"
		await plain._resolve(sm2, _find(sm2, "Lunge"), foe2, "good")
		ok(foe2.has_status("exposed") and not foe2.has_status("cripple"),
			"the granted Lunge still Exposes only, from the Aggressive guard")
	plain.free()


# ---------- 12. Off Balance's widened window ----------

func _live_off_balance() -> void:
	var prep := func(run):
		run.party[0]["talents"] = {"sm_guarded": 1, "sm_punish": 1}
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		["raider"], prep)
	var sm := _sm(scene)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(sm != null, "the Off Balance Swordmaster spawned")
	if sm != null and foe != null:
		ok(sm.off_balance_wide == 1, "LIVE: the cross-row condition reached the unit")
		foe.hp = foe.max_hp * 6
		foe.max_hp = foe.hp
		sm.no_cover = 1
		# Neither Broken nor wounded: the plain window is shut.
		scene.history.clear()
		await scene._resolve(sm, sm.abilities[0], foe, "good")
		ok(not scene.history.get_parsed_text().contains("Off Balance"),
			"a clean target is not a window")
		# Exposed is, once Punishment has widened it.
		scene._apply_status(foe, "exposed", 3)
		scene.history.clear()
		await scene._resolve(sm, sm.abilities[0], foe, "good")
		ok(scene.history.get_parsed_text().contains("Off Balance — +20% vs Exposed"),
			"an EXPOSED target is a window once Punishment widened it")
		# ...and without Punishment it is not.
		sm.off_balance_wide = 0
		scene.history.clear()
		await scene._resolve(sm, sm.abilities[0], foe, "good")
		ok(not scene.history.get_parsed_text().contains("Off Balance"),
			"...and is not, without Punishment")
	scene.free()
