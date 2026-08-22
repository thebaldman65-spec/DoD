# test_batch_bh.gd — FOUR MORE ABILITY UPGRADES, AND THE FAITH LANE GETS A
# SECOND AXIS. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bh.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# TWO SECTIONS THAT DO NOT INTERACT.
#
# §1 — the upgrade pool goes 4 -> 8. Weighted (Break), Widened (breadth),
# Piercing (armor) and Certain (reliability), on axes the original four do not
# touch. The checks that matter are the REFUSALS: an upgrade offered against an
# ability it cannot change reads as a reward and does nothing, which is the
# whole bug AP §3 exists to close, and a pool of eight is four new ways to
# reintroduce it.
#
# §2 — Fervor and Binding Oath move off the release-frequency axis. THE
# NEGATIVE CONTROL THAT MATTERS IS THAT THE DEVOUT'S OWN FAITH NEVER RELEASES:
# a releasing Devout puts the frequency loop straight back, and — this is the
# part the brief did not know — HE HAS BEEN RELEASING SINCE BATCH AW §2, because
# Consecrated Ground drips onto its own caster and `_gain_faith` never excluded
# him. Every source-level check below would pass with that loop live.
#
# Rates are MEASURED end to end (total damage over many casts) rather than read
# off the expression: a test that re-derives the formula it checks proves
# nothing. Damage carries a uniform ±10% roll, so every rate is a SUM over
# `HITS` casts — CLAUDE.md's standing trap is that one cast passes a wrong curve
# even with crit suppressed.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# §2's design numbers, in one place.
# BATCH BI §1 RE-POINTED ALL FOUR, AND TWO OF THEM ARE AN INVERSION rather than
# a re-price. The magnitudes fell (3 -> 2, 2 -> +1.5) because the held value now
# reads the battle's PEAK Faith rather than the current count, and a peak that
# ratchets to five pays roughly double what a low average count paid. THE TWO
# MULTIPLIERS NOW ADD INSTEAD OF MULTIPLYING: BH composed them as a product,
# reaching x4, and x4 on one term is the compounding fault this arc exists to
# remove rebuilt on the new axis. Base 1x + Fervor 1x + Apostle 1x = x3.
# `FERVOR_MULT`/`APOSTLE_MULT` therefore hold what each node ADDS, and the pair
# is `BOTH_MULT`. The suite's questions are unchanged and it is re-pointed in
# place; `_live_fervor_and_apostle_quadruple` is renamed for the same reason.
const BASE_MITIGATION := 2.0    # % per stack, per battle.gd's constant (BI: was 3)
const BASE_DAMAGE := 1.5        # % per stack (BI: was 2)
const APOSTLE_MULT := 2         # base 1x + Apostle's 1x
const FERVOR_MULT := 2          # base 1x + Fervor's 1x
const BOTH_MULT := 3            # Batch BI §1: ADDITIVE — never 4
# BATCH DC: `battle.FAITH_RELEASE`, ruled at CZ §2, mirrored ONCE per suite.
const RELEASE := 3
const HELD_MAX := RELEASE - 1   # the deepest an ally can CARRY; at RELEASE he releases
# STACKS is a DIRECT-WRITE PROBE DEPTH for the per-stack arithmetic (see bg's
# note): those checks write `faith_stacks`/`faith_peak` onto the unit and
# bypass `_gain_faith`'s clamp. Anything driven THROUGH `_gain_faith` uses
# HELD_MAX, because that is the only depth the game can produce.
const STACKS := 4
# Casts per measured rate. See the BG note: a 400-cast sum has an SE of ~0.3%,
# so the ±2-point bands below are ~5 sigma and cannot flap.
const HITS := 400

var checks := 0
var fails: Array = []
# A live check that THROWS aborts its own function while the suite still prints
# "0 failures" (the BC trap). Every live function bumps this on its LAST line
# and the total is asserted.
var _live_ran := 0
const LIVE_CHECKS := 10
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
var _report: Array = []


func _initialize() -> void:
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
	Profile.save_path = "user://profile_batch_bh_test.json"
	Profile.loaded = false
	Profile.data = {}

	# ---- §1: the pool of eight ----
	_the_pool_is_eight()
	_the_new_four_come_after_the_old_four()
	_every_effect_lands_on_its_own_field()
	_the_refusals()
	_the_fallback_is_byte_compatible()
	_the_perfect_window_is_a_constant()
	_the_offer_never_pairs_a_dud()
	_never_twice_across_eight()

	# ---- §2: the Faith lane's second axis ----
	_the_two_nodes_describe_their_new_axes()
	_the_deleted_fields_are_gone()
	_one_multiplier_two_gates()
	_the_rune_is_repointed()

	await _live_fervor_doubles_the_held_half()
	await _live_fervor_and_apostle_are_additive_not_multiplied()
	await _live_fervor_adds_no_release()
	await _live_the_ground_drips_a_flat_one()
	await _live_the_devout_accrues_his_own_faith()
	await _live_his_own_faith_pays_him_mitigation()
	await _live_his_own_faith_pays_him_damage()
	await _live_his_own_faith_never_releases()
	await _live_an_ally_release_resets_to_zero()
	await _live_the_opening_oath()

	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bh_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bh_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bh: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(Talents.LANE_TREES["inquisitor"], id)


func _run_obj():
	return root.get_node("/root/Run")


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


func _spawn(learned := {}) -> Node:
	var run = _run_obj()
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 2 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.combat_wins = 0
	run.pending_modifier = ""
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
		u.healing_received_mult = 1.0
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	scene.get("_b_slice").clear()
	scene.get("_b_bd_slice").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	await process_frame
	await process_frame


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


func _neutral(scene: Node) -> void:
	for u in scene.get("heroes") + scene.get("enemies"):
		u.hp = u.max_hp
		u.second_resource = 0
		u.faith_stacks = 0
		# BATCH BI §1: the damage sites read the PEAK, which never falls on its
		# own — an arm that left it set would carry into the next arm's control.
		u.faith_peak = 0
		u.remove_status("faith")
		u.remove_status("cons_ground")
		u.purge_debuffs()


# Consecrated Ground, applied by hand. Fervor reads the HOLDER's status, so
# the ground has to be on the unit whose stacks are being valued.
func _ground(u: BattleUnit) -> void:
	u.add_status("cons_ground", "Consecrated Ground", "CG",
		Color(0.9, 0.85, 0.5), 5, "")


# Total damage the carrier LANDS over HITS casts, holding `stacks` of Faith.
func _damage_dealt(scene: Node, carrier: BattleUnit, stacks: int,
		ground := false) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9_000_000
	var key := "dmg_hero_" + carrier.unit_name
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		if ground:
			_ground(carrier)
		foe.hp = foe.max_hp
		carrier.faith_stacks = stacks
		carrier.faith_peak = stacks   # Batch BI §1: the read site reads the peak
		await scene.call("_resolve", carrier, carrier.abilities[0], foe, "good")
	return _stat_of(scene, key)


# Total damage the carrier TAKES over HITS enemy casts, holding `stacks`.
func _damage_taken(scene: Node, carrier: BattleUnit, stacks: int,
		ground := false) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	var ab = scene.call("_cheapest_attack", foe)
	carrier.max_hp = 9_000_000
	var total := 0.0
	for _i in HITS:
		_neutral(scene)
		if ground:
			_ground(carrier)
		carrier.hp = carrier.max_hp
		carrier.faith_stacks = stacks
		carrier.faith_peak = stacks   # Batch BI §1: the read site reads the peak
		await scene.call("_resolve", foe, ab, carrier, "good")
		total += float(carrier.max_hp - carrier.hp)
	return total


# ---------- §1: the pool of eight ----------

func _the_pool_is_eight() -> void:
	var run = _run_obj()
	ok(run.ABILITY_UPGRADES.size() == 8,
		"§1: the pool holds eight upgrades (holds %d)" % run.ABILITY_UPGRADES.size())
	ok(run.UPGRADE_PRIORITY.size() == run.ABILITY_UPGRADES.size(),
		"§1: the priority list and the pool are the same length")
	for id in run.UPGRADE_PRIORITY:
		ok(run.ABILITY_UPGRADES.has(String(id)),
			"§1: priority entry %s is a real upgrade" % id)
	for id2 in run.ABILITY_UPGRADES:
		ok(run.UPGRADE_PRIORITY.has(String(id2)),
			"§1: pool entry %s has a priority slot" % id2)
		ok(String(run.ABILITY_UPGRADES[id2].get("name", "")) != ""
				and String(run.ABILITY_UPGRADES[id2].get("desc", "")) != "",
			"§1: %s carries a name and a description" % id2)
	for pair in [["up_break", "Weighted"], ["up_wide", "Widened"],
			["up_pierce", "Piercing"], ["up_certain", "Certain"]]:
		ok(run.upgrade_name(String(pair[0])) == String(pair[1]),
			"§1: %s is %s" % [pair[0], pair[1]])
	# THE REPLACEMENT IS RECORDED IN THE DATA, not only in a comment: `up_sure`
	# must not exist, so a later batch cannot half-restore it.
	ok(not run.ABILITY_UPGRADES.has("up_sure"),
		"§1: `up_sure` was NOT written — see _the_perfect_window_is_a_constant")


# THE COMPATIBILITY SURFACE. AU §1's generic talent fallback walks this list in
# order, so a node that granted Honed yesterday must grant Honed today. The four
# new ids must all sit BELOW the four old ones — an insertion anywhere else
# silently re-points every live fallback in the game.
func _the_new_four_come_after_the_old_four() -> void:
	var run = _run_obj()
	var p: Array = run.UPGRADE_PRIORITY
	ok(p.slice(0, 4) == ["up_damage", "up_cooldown", "up_free", "up_speed"],
		"§1: the original four still lead the priority list, in order")
	for new_id in ["up_break", "up_wide", "up_pierce", "up_certain"]:
		ok(p.find(new_id) >= 4,
			"§1: %s sits below every original (index %d)" % [new_id, p.find(new_id)])


func _every_effect_lands_on_its_own_field() -> void:
	var run = _run_obj()

	var brk: Ability = Ability.make({"display_name": "T", "damage": 30, "pressure": 12})
	run.call("_stamp_upgrade", "up_break", brk)
	ok(brk.pressure == 24, "§1: Weighted doubles Break damage (12 -> %d)" % brk.pressure)
	ok(brk.damage == 30, "§1: ...and touches nothing else")

	var rnd: Ability = Ability.make({"display_name": "T", "damage": 20, "random_hits": 3})
	run.call("_stamp_upgrade", "up_wide", rnd)
	ok(rnd.random_hits == 4 and rnd.multi_hits == 0,
		"§1: Widened adds a RANDOM target when the ability has them (3 -> %d)" % rnd.random_hits)

	var mlt: Ability = Ability.make({"display_name": "T", "damage": 20, "multi_hits": 3})
	run.call("_stamp_upgrade", "up_wide", mlt)
	ok(mlt.multi_hits == 4 and mlt.random_hits == 0,
		"§1: Widened adds a HIT when the ability is multi-hit (3 -> %d)" % mlt.multi_hits)

	var prc: Ability = Ability.make({"display_name": "T", "damage": 40})
	run.call("_stamp_upgrade", "up_pierce", prc)
	ok(is_equal_approx(prc.armor_pierce, 0.5),
		"§1: Piercing takes half the armor (0 -> %.2f)" % prc.armor_pierce)
	var prc2: Ability = Ability.make({"display_name": "T", "damage": 40,
		"armor_pierce": 0.8})
	run.call("_stamp_upgrade", "up_pierce", prc2)
	ok(is_equal_approx(prc2.armor_pierce, 1.0),
		"§1: ...added to what it already pierced, CLAMPED at 1.0 (0.8 -> %.2f)"
			% prc2.armor_pierce)

	var cer: Ability = Ability.make({"display_name": "T", "damage": 20,
		"applies_status": {"id": "slow", "turns": 2}, "status_chance": 0.5,
		"bleed_build": 30, "bleed_chance": 0.5})
	run.call("_stamp_upgrade", "up_certain", cer)
	ok(is_equal_approx(cer.status_chance, 1.0) and is_equal_approx(cer.bleed_chance, 1.0),
		"§1: Certain makes BOTH reliability rolls a certainty")

	# The originals are byte-unchanged — this batch adds, it does not re-price.
	var old: Ability = Ability.make({"display_name": "T", "damage": 40,
		"cooldown": 3, "cost": 25, "delay": 2.0})
	run.call("_stamp_upgrade", "up_damage", old)
	run.call("_stamp_upgrade", "up_cooldown", old)
	run.call("_stamp_upgrade", "up_free", old)
	run.call("_stamp_upgrade", "up_speed", old)
	ok(old.damage == 60 and old.cooldown == 1 and old.cost == 0
			and is_equal_approx(old.delay, 1.5),
		"§1: Honed/Quickened/Effortless/Swift still pay exactly what AP set")


# THE REFUSALS — §4's own list, one per new upgrade, plus the two dud cases
# that are easy to author back in by accident.
func _the_refusals() -> void:
	var run = _run_obj()

	var no_bd: Ability = Ability.make({"display_name": "T", "damage": 40, "pressure": 0})
	ok(not run.upgrade_fits("up_break", no_bd),
		"§1: Weighted is REFUSED against a zero-Break ability")
	ok(run.upgrade_fits("up_break",
			Ability.make({"display_name": "T", "pressure": 5})),
		"§1: ...and accepted where there is Break to double")

	var single: Ability = Ability.make({"display_name": "T", "damage": 40})
	ok(not run.upgrade_fits("up_wide", single),
		"§1: Widened is REFUSED against a single-target ability")
	# THE CORRECTION THE BRIEF NAMED `aoe` FOR. An aoe already strikes every
	# living enemy, so there is no additional target — offering Widened there is
	# exactly the dud AP §3 exists to prevent.
	var wide: Ability = Ability.make({"display_name": "T", "damage": 40, "aoe": true})
	ok(not run.upgrade_fits("up_wide", wide),
		"§1: Widened is REFUSED against an AoE — it already hits everything")

	ok(not run.upgrade_fits("up_pierce",
			Ability.make({"display_name": "T", "heal": 30})),
		"§1: Piercing is REFUSED against an ability that deals no damage")
	ok(not run.upgrade_fits("up_pierce",
			Ability.make({"display_name": "T", "damage": 40, "armor_pierce": 1.0})),
		"§1: Piercing is REFUSED against an ability that already pierces it all")

	var sure_status: Ability = Ability.make({"display_name": "T", "damage": 20,
		"applies_status": {"id": "slow", "turns": 2}, "status_chance": 1.0})
	ok(not run.upgrade_fits("up_certain", sure_status),
		"§1: Certain is REFUSED against a GUARANTEED status (the AP §3 dud)")
	ok(not run.upgrade_fits("up_certain",
			Ability.make({"display_name": "T", "damage": 20})),
		"§1: ...and against an ability with no reliability roll at all")
	ok(run.upgrade_fits("up_certain",
			Ability.make({"display_name": "T", "damage": 20,
				"bleed_build": 30, "bleed_chance": 0.5})),
		"§1: ...and accepted on a partial BLEED roll, the axis the roster has")
	# A status roll with no status attached has nothing to guarantee.
	ok(not run.upgrade_fits("up_certain",
			Ability.make({"display_name": "T", "damage": 20, "status_chance": 0.5})),
		"§1: ...and refused where a partial chance carries no status")

	# THE FINDING, PINNED AS A NUMBER so a later batch that authors partial
	# status chances onto hero abilities can see this move: Certain reaches
	# exactly two abilities in the whole game today.
	var reach := 0
	for name in _all_ability_names():
		var ab: Ability = Classes.pool_ability(String(name))
		if ab != null and run.upgrade_fits("up_certain", ab):
			reach += 1
	ok(reach == 2,
		"§1: Certain reaches exactly 2 abilities game-wide (reaches %d) — REPORTED, not forced"
			% reach)
	_report.append("§1 Certain's reach across every resolvable ability: %d" % reach)


# Every ability a hero can ever hold, by display name.
func _all_ability_names() -> Array:
	var names: Dictionary = {}
	for ck in ["warrior", "mage", "cleric", "hunter"]:
		for ab in Classes.kit(ck):
			if ab != null:
				names[ab.display_name] = true
	for class_key in Classes.SPEC_IDS:
		for n in Classes.class_pool(class_key):
			names[String(n)] = true
		for spec_id in Classes.SPEC_IDS[class_key]:
			for ab2 in Classes.spec_abilities(spec_id):
				if ab2 != null:
					names[ab2.display_name] = true
			for n2 in Classes.spec_pool(spec_id):
				names[String(n2)] = true
	for spec in Talents.LANE_TREES:
		for node in Talents.LANE_TREES[spec]:
			var pay: Dictionary = node.get("payload", {})
			for key in ["grant_ability", "new_ability"]:
				var v = pay.get(key, null)
				if v is String and String(v) != "":
					names[String(v)] = true
				elif v is Dictionary and v.has("display_name"):
					names[String(v["display_name"])] = true
	return names.keys()


# AU §1's fallback must be byte-compatible. These four expectations are copied
# from test_batch_au and are the whole reason the new ids were APPENDED.
func _the_fallback_is_byte_compatible() -> void:
	var run = _run_obj()
	var full: Ability = Ability.make({"display_name": "T", "damage": 40,
		"cooldown": 3, "cost": 25})
	ok(run.fallback_upgrade_id(full, []) == "up_damage",
		"§1: a full ability still falls back to Honed first")
	ok(run.fallback_upgrade_id(full, ["up_damage"]) == "up_cooldown",
		"§1: ...then Quickened")
	ok(run.fallback_upgrade_id(full, ["up_damage", "up_cooldown"]) == "up_free",
		"§1: ...then Effortless")
	ok(run.fallback_upgrade_id(full, ["up_damage", "up_cooldown", "up_free"]) == "up_speed",
		"§1: ...then Swift — the four AU shipped, unmoved")
	# Only PAST Swift does the new half of the list come into play, which is the
	# point: nothing that resolved before this batch resolves differently now.
	# The dead end still exists, but a DAMAGING ability now legitimately
	# continues into Piercing, so the honest dead-end case is a heal.
	var mend: Ability = Ability.make({"display_name": "T", "heal": 30,
		"cooldown": 3, "cost": 25})
	ok(run.fallback_upgrade_id(mend,
			["up_cooldown", "up_free", "up_speed"]) == "",
		"§1: an ability with nothing left for any of the eight dead-ends at \"\"")
	ok(run.fallback_upgrade_id(full,
			["up_damage", "up_cooldown", "up_free", "up_speed"]) == "up_pierce",
		"§1: ...while a damaging one continues into Piercing rather than stopping")
	var rich: Ability = Ability.make({"display_name": "T", "damage": 40,
		"cooldown": 3, "cost": 25, "pressure": 10, "multi_hits": 2})
	ok(run.fallback_upgrade_id(rich,
			["up_damage", "up_cooldown", "up_free", "up_speed"]) == "up_break",
		"§1: ...and a Break-carrying one now continues into Weighted")
	ok(run.fallback_upgrade_id(rich,
			["up_damage", "up_cooldown", "up_free", "up_speed", "up_break"]) == "up_wide",
		"§1: ...then Widened, then Piercing, in the authored order")


# WHY `up_sure` WAS NOT WRITTEN, pinned against the source so the decision is
# revisited deliberately rather than forgotten. §1 required the Perfect window
# to be a readable value AT ITS SITE first; it is a bare script constant read by
# a grader that cannot see which ability is being cast.
func _the_perfect_window_is_a_constant() -> void:
	var bsrc := _src("res://scripts/battle.gd")
	# BATCH CQ §3 — RE-POINTED TO WHERE CN §1 PUT IT. The window was a bare
	# `const PERFECT_HALF`; CN made the skill check PARAMETERIC and the window
	# is now `perfect_half` in the profile handed to the check per cast. The
	# question this section exists to ask is UNCHANGED and is the reason
	# `up_sure` was never written — the window is a SCRIPT-side value that the
	# grader reads, not a field on the Ability — so it is asked of the profile.
	ok(bsrc.contains("\"perfect_half\":"),
		"§1: the Perfect window is a script-side profile value, not an Ability field")
	ok(bsrc.contains("func _grade_skill_check() -> void:"),
		"§1: ...and the grader takes NO arguments, so it cannot see the ability")
	ok(bsrc.contains("if dist <= float(sc_profile[\"perfect_half\"]):"),
		"§1: ...it compares against that profile value directly")
	var asrc := _src("res://scripts/ability.gd")
	ok(not asrc.contains("perfect_half") and not asrc.contains("perfect_window"),
		"§1: Ability carries no per-ability Perfect window to widen")


# 2000 offers, every pairing checked. AP §3's guarantee has to survive the pool
# doubling, and four new eligibility rules are four new ways to break it.
func _the_offer_never_pairs_a_dud() -> void:
	var run = _run_obj()
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
	var duds := 0
	var sizes: Dictionary = {}
	var seen: Dictionary = {}
	for _t in 500:
		for i2 in run.party.size():
			var member: Dictionary = run.party[i2]
			member["upgrades"] = []
			var offer: Array = run.roll_upgrade_offer(member)
			sizes[offer.size()] = int(sizes.get(offer.size(), 0)) + 1
			var ids: Dictionary = {}
			for entry in offer:
				var id := String(entry["id"])
				seen[id] = true
				ids[id] = int(ids.get(id, 0)) + 1
				var ab: Ability = Classes.pool_ability(String(entry["ability"]))
				if ab == null or not run.upgrade_fits(id, ab):
					duds += 1
			for k in ids:
				if int(ids[k]) > 1:
					duds += 1
	ok(duds == 0, "§1: 2000 offers, ZERO duds and no repeated id inside one offer (%d)" % duds)
	ok(seen.size() == 8,
		"§1: all eight upgrades appear across the battery (%d did)" % seen.size())
	var szs: Array = sizes.keys()
	szs.sort()
	_report.append("§1 offer sizes over 2000 rolls: %s" % str(sizes))
	ok(int(szs[szs.size() - 1]) == 3, "§1: a full offer is still three wide")


func _never_twice_across_eight() -> void:
	var run = _run_obj()
	var member: Dictionary = run.party[0]
	member["upgrades"] = []
	var taken: Dictionary = {}
	# Walk the pool dry, taking one upgrade each time and asserting it is never
	# re-offered. Eight rounds is the whole pool.
	for _round in 10:
		var offer: Array = run.roll_upgrade_offer(member)
		for entry in offer:
			ok(not taken.has(String(entry["id"])),
				"§1: %s is never re-offered once taken" % entry["id"])
		if offer.is_empty():
			break
		var pick: Dictionary = offer[0]
		taken[String(pick["id"])] = true
		member["upgrades"] = member["upgrades"] + [pick]
		ok(run.has_upgrade(member, String(pick["id"])),
			"§1: %s is recorded on the member" % pick["id"])
	ok(taken.size() >= 6,
		"§1: the walk exhausts most of a pool of eight (%d taken)" % taken.size())
	member["upgrades"] = []


# ---------- §2: the shape of the re-spec ----------

func _the_two_nodes_describe_their_new_axes() -> void:
	var fv := _node("dv_fervor")
	ok(not fv.is_empty() and int(fv.get("row", 0)) == 6
			and String(fv.get("lane", "")) == "Faith",
		"§2: dv_fervor keeps its id, lane and row 6")
	var fd := Talents.desc_for(fv, 1)
	ok(fd.contains("Consecrated Ground") and fd.to_lower().contains("double"),
		"§2: Fervor's text is the ground doubling a HELD stack")
	ok(fd.contains("%d%%" % (BASE_MITIGATION * FERVOR_MULT))
			and fd.contains("+%d%%" % (BASE_DAMAGE * FERVOR_MULT)),
		"§2: ...and states both doubled magnitudes (6%% and +4%%)")
	ok(fd.to_lower().contains("no extra faith"),
		"§2: ...and says outright that it grants no Faith — the frequency claim")
	# BATCH BI §1 INVERTED THIS. BH asked whether Fervor's text names the
	# QUADRUPLE it made with Apostle; the two add rather than multiply now, so
	# the text must say TRIPLE — and must not say quadruple, because a tooltip
	# promising x4 is exactly the compounding the re-spec removed.
	ok(fd.to_lower().contains("triple") and not fd.to_lower().contains("quadruple"),
		"§2/BI: ...and names the Apostle stack as TRIPLE, not quadruple")
	ok(int((fv.get("payload", {}).get("stat", {}) as Dictionary).get("fervor", 0)) == 1,
		"§2: Fervor's payload is the `fervor` gate")
	ok(not (fv.get("payload", {}).get("stat", {}) as Dictionary).has("fervor_step"),
		"§2: ...and no longer writes `fervor_step`")

	var bo := _node("dv_oath")
	ok(not bo.is_empty() and int(bo.get("row", 0)) == 7
			and String(bo.get("lane", "")) == "Faith",
		"§2: dv_oath keeps its id, lane and row 7")
	var bd := Talents.desc_for(bo, 1)
	ok(bd.contains("Devout") and bd.to_lower().contains("himself"),
		"§2: Binding Oath's text is about the Devout's OWN Faith")
	ok(bd.to_lower().contains("never releases"),
		"§2: ...and states the rule that keeps it off the frequency axis")
	ok(not bd.to_lower().contains("keep 3") and not bd.to_lower().contains("instead of resetting"),
		"§2: ...and no longer promises a release remnant")
	ok(int((bo.get("payload", {}).get("stat", {}) as Dictionary).get("oath_faith", 0)) == 1,
		"§2: Binding Oath's payload is `oath_faith`")
	ok(not (bo.get("payload", {}).get("stat", {}) as Dictionary).has("oath_ranks"),
		"§2: ...and no longer writes `oath_ranks`")

	# Communion is the lane's ONE surviving frequency node and is untouched.
	var cm := _node("dv_communion")
	ok(int((cm.get("payload", {}).get("stat", {}) as Dictionary).get("communion_ranks", 0)) == 15,
		"§2: Communion still pays 15 — the lane keeps exactly one frequency node")
	# Sacred Covenant's +2 stays: one small frequency term is not the fault.
	var cv := _node("dv_covenant")
	ok(int((cv.get("payload", {}).get("stat", {}) as Dictionary).get("covenant_faith", 0)) == 2,
		"§2: Sacred Covenant still grants its 2 Faith on a lethal save")


# A field that changed MEANING must be DELETED with its read site, not renamed
# in place — otherwise a later batch writes one and nothing complains (the BA
# `plague_bearer` precedent, and BD's `deadfall_armed` is the counter-example).
func _the_deleted_fields_are_gone() -> void:
	var u := BattleUnit.new()
	ok(u.get("fervor_step") == null,
		"§2: `fervor_step` DOES NOT EXIST on BattleUnit")
	ok(u.get("oath_ranks") == null,
		"§2: `oath_ranks` DOES NOT EXIST on BattleUnit")
	ok(u.get("fervor") != null and u.get("oath_faith") != null
			and u.get("oath_opening") != null,
		"§2: the three replacements do")
	u.free()
	var bsrc := _src("res://scripts/battle.gd")
	ok(not bsrc.contains("devout.fervor_step") and not bsrc.contains("devout.oath_ranks"),
		"§2: battle.gd reads neither deleted field")
	ok(not bsrc.contains("1 + devout.fervor_step"),
		"§2: the ground's drip no longer adds Fervor to it")
	# BATCH DC: the drip is written against `FAITH_PER_GROUND_TURN` now — CZ §2
	# named every Faith rate — so the assertion names the constant, not the digit.
	ok(bsrc.contains("_gain_faith(u, FAITH_PER_GROUND_TURN, \"ground\")"),
		"§2: ...it is a flat FAITH_PER_GROUND_TURN per ally per turn, Batch AW §2's base, unchanged")
	var tsrc := _src("res://scripts/talents.gd")
	ok(not tsrc.contains("\"fervor_step\":") and not tsrc.contains("\"oath_ranks\":"),
		"§2: no tree node writes either deleted field")
	var rsrc := _src("res://scripts/runes.gd")
	ok(not rsrc.contains("\"fervor_step\","),
		"§2: `fervor_step` left Runes.STAT_INT_KEYS with the field")
	ok(rsrc.contains("\"oath_opening\","),
		"§2: `oath_opening` is IN it — a rune writes a bare int that does not end \"_ranks\"")


# ONE multiplier, TWO gates, and the gates are independent. `_faith_stack_mult`
# must remain the only place either doubling is decided, or the tooltip can
# describe a number the arithmetic does not use.
func _one_multiplier_two_gates() -> void:
	var bsrc := _src("res://scripts/battle.gd")
	ok(bsrc.contains("func _faith_stack_mult(devout: BattleUnit, holder: BattleUnit = null) -> int:"),
		"§2: the multiplier takes the HOLDER as well as the Devout")
	ok(bsrc.count(".apostle > 0") == 1,
		"§2: `.apostle` is still read in exactly ONE place (read %d)"
			% bsrc.count(".apostle > 0"))
	ok(bsrc.count("devout.fervor > 0") == 2,
		"§2: `.fervor` is read at the multiplier and the log line only (read %d)"
			% bsrc.count("devout.fervor > 0"))
	# The doubling must follow the CARRIER. Reading devout.faith_stacks at either
	# damage site is the mis-write BG's own control exists for, and Fervor adds a
	# second way to make it: reading the DEVOUT's cons_ground instead of the
	# holder's would double everybody whenever he stood on his own ground.
	# BATCH BI §1: both sites read `faith_peak` now — the highest count held this
	# battle — but the CARRIER-KEYED question BH asked is untouched and is what
	# these two still check.
	# BATCH BM: the peak both sites read now goes through `_faith_paid_peak`
	# (Creed can pay it on the party's highest instead of the holder's own).
	# The CARRIER-KEYED question BH asked is what these two check and it is
	# untouched — the multiplier is still keyed on who is CARRYING the stack.
	ok(bsrc.contains("_faith_stack_mult(fd_dv, attacker) * _faith_paid_peak(attacker)"),
		"§2: the damage site values the ATTACKER's Faith under the ATTACKER's ground")
	ok(bsrc.contains("_faith_stack_mult(fp_dv, strike_target) * _faith_paid_peak(strike_target)"),
		"§2: the mitigation site values the TARGET's")
	ok(bsrc.contains("holder.has_status(\"cons_ground\")"),
		"§2: Fervor's gate reads the HOLDER's ground, never the Devout's")


func _the_rune_is_repointed() -> void:
	var cfg: Dictionary = Runes.config("binding_oath")
	ok(not cfg.is_empty(), "§2: the Rune of the Binding Oath still exists")
	var stat: Dictionary = cfg.get("payload", {}).get("stat", {})
	ok(not stat.has("oath_ranks"),
		"§2: it no longer writes the deleted `oath_ranks`")
	ok(int(stat.get("oath_opening", 0)) == 1,
		"§2: RE-POINTED, NOT DELETED — it buys an opening stack of his own Faith")
	ok(int(stat.get("faithful_step", 0)) == 5,
		"§2: ...and its second clause is byte-untouched, still paying 5")
	ok(String(cfg.get("desc", "")).to_lower().contains("opens each battle"),
		"§2: ...and its description was rewritten rather than left lying")
	ok(not String(cfg.get("desc", "")).contains("leaves 1 stack standing"),
		"§2: ...the old promise is gone from the text")
	# Nothing else in the pool wrote either deleted counter.
	for rid in Runes.ids():
		var s2: Dictionary = Runes.config(String(rid)).get("payload", {}).get("stat", {})
		ok(not s2.has("oath_ranks") and not s2.has("fervor_step"),
			"§2: %s writes neither deleted counter" % rid)


# ---------- §2: live ----------

# FERVOR DOUBLES WHAT A HELD STACK IS WORTH. Measured as damage TAKEN over 400
# enemy casts at four stacks, on the ground versus off it: 12% mitigation must
# become 24%.
func _live_fervor_doubles_the_held_half() -> void:
	var scene := await _spawn({"dv_fervor": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	# TWO BASELINES, AND THAT IS THE POINT: Consecrated Ground carries its own
	# −15% target-side mitigation (Batch K), so a zero-stack baseline taken OFF
	# the ground would bank the ground's effect as Fervor's and the check would
	# pass at roughly double the right answer. Each arm is measured against a
	# baseline standing exactly where it stands.
	var base_off := await _damage_taken(scene, ally, 0, false)
	var base_on := await _damage_taken(scene, ally, 0, true)
	var off := await _damage_taken(scene, ally, STACKS, false)
	var on := await _damage_taken(scene, ally, STACKS, true)
	var cut_off := 100.0 * (1.0 - off / base_off)
	var cut_on := 100.0 * (1.0 - on / base_on)
	var want_off := float(BASE_MITIGATION * STACKS)
	var want_on := float(BASE_MITIGATION * FERVOR_MULT * STACKS)
	_report.append("§2 Fervor mitigation at %d stacks: off the ground %.1f%% (want %.0f), on it %.1f%% (want %.0f)"
		% [STACKS, cut_off, want_off, cut_on, want_on])
	ok(absf(cut_off - want_off) < 2.0,
		"§2: off the ground a stack still mitigates %d%% (measured %.1f%%)"
			% [BASE_MITIGATION, cut_off])
	ok(absf(cut_on - want_on) < 2.0,
		"§2: ON the ground Fervor doubles it to %d%% (measured %.1f%%)"
			% [BASE_MITIGATION * FERVOR_MULT, cut_on])
	# The node must not leak onto a party that never took it.
	await _kill(scene)
	var bare := await _spawn()
	var b_ally: BattleUnit = bare.get("heroes")[0]
	var b_base := await _damage_taken(bare, b_ally, 0, true)
	var b_on := await _damage_taken(bare, b_ally, STACKS, true)
	var b_cut := 100.0 * (1.0 - b_on / b_base)
	ok(absf(b_cut - want_off) < 2.0,
		"§2: WITHOUT the node the ground doubles nothing (measured %.1f%%)" % b_cut)
	await _kill(bare)
	_live_ran += 1


# BATCH BI §1 — FERVOR AND APOSTLE COMPOSE TO TRIPLE, AND THIS IS THE NEGATIVE
# CONTROL THE BATCH MOST NEEDS: a PRODUCT would pass every other check in this
# file. BH had them multiply to x4; x4 on one term is the compounding fault the
# whole arc exists to remove, rebuilt on the held axis. They add — base 1x,
# Fervor +1x, Apostle +1x — so they must not take the larger (x2) and must not
# multiply (x4). The two arms are 8 mitigation points apart at four stacks, so
# the ±2.5 band cannot confuse them.
func _live_fervor_and_apostle_are_additive_not_multiplied() -> void:
	var scene := await _spawn({"dv_fervor": 1, "dv_apostle": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	var base_off := await _damage_taken(scene, ally, 0, false)
	var base_on := await _damage_taken(scene, ally, 0, true)
	var off := await _damage_taken(scene, ally, STACKS, false)
	var on := await _damage_taken(scene, ally, STACKS, true)
	var cut_off := 100.0 * (1.0 - off / base_off)
	var cut_on := 100.0 * (1.0 - on / base_on)
	var want_off := float(BASE_MITIGATION * APOSTLE_MULT * STACKS)
	var want_on := float(BASE_MITIGATION * BOTH_MULT * STACKS)
	_report.append("§2 Fervor + Apostle at %d stacks: off the ground %.1f%% (want %.0f), on it %.1f%% (want %.0f — x3, NOT x4)"
		% [STACKS, cut_off, want_off, cut_on, want_on])
	ok(absf(cut_off - want_off) < 2.0,
		"§2: Apostle alone still doubles to %d%% (measured %.1f%%)"
			% [BASE_MITIGATION * APOSTLE_MULT, cut_off])
	ok(absf(cut_on - want_on) < 2.5,
		"§2/BI: the two TRIPLE on the ground — %.1f%% a stack, not %.1f%% (measured %.1f%%)"
			% [BASE_MITIGATION * BOTH_MULT, BASE_MITIGATION * 4, cut_on])
	ok(absf(cut_on - float(BASE_MITIGATION * 4 * STACKS)) > 2.5,
		"§2/BI: NEGATIVE CONTROL — they do NOT multiply to x4 (measured %.1f%%, x4 would be %.1f%%)"
			% [cut_on, BASE_MITIGATION * 4 * STACKS])
	ok(absf(cut_on - float(BASE_MITIGATION * 2 * STACKS)) > 2.5,
		"§2/BI: ...and they do not take the larger either (x2 would be %.1f%%)"
			% (BASE_MITIGATION * 2 * STACKS))
	# The damage half moves with it, on the same gates.
	var dmg_off := await _damage_dealt(scene, ally, STACKS, false)
	var dmg_on := await _damage_dealt(scene, ally, STACKS, true)
	var d_base_off := await _damage_dealt(scene, ally, 0, false)
	var d_base_on := await _damage_dealt(scene, ally, 0, true)
	var up_off := 100.0 * (dmg_off / d_base_off - 1.0)
	var up_on := 100.0 * (dmg_on / d_base_on - 1.0)
	_report.append("§2 Fervor + Apostle damage dealt at %d stacks: off %.1f%% (want %.1f), on %.1f%% (want %.1f — x3)"
		% [STACKS, up_off, BASE_DAMAGE * APOSTLE_MULT * STACKS,
			up_on, BASE_DAMAGE * BOTH_MULT * STACKS])
	ok(absf(up_on - float(BASE_DAMAGE * BOTH_MULT * STACKS)) < 2.5,
		"§2/BI: ...and TRIPLES the damage half too (measured +%.1f%%)" % up_on)
	await _kill(scene)
	_live_ran += 1


# THE NEGATIVE CONTROL THE BRIEF NAMED FIRST: Fervor must double the VALUE of a
# stack and grant no stack. Drive the ground's own tick and count what lands.
func _live_fervor_adds_no_release() -> void:
	var scene := await _spawn({"dv_fervor": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	_ground(ally)
	scene.get("sim_stats").clear()
	# Five ticks: with the old +1 drip this reached five Faith and RELEASED on
	# the third; at a flat 1 it reaches exactly five on the fifth and releases
	# once, which is the base kit's rate and not the node's.
	for _i in 5:
		scene.call("_ground_faith_tick", ally)
	var rel := _stat_of(scene, "faith_releases")
	_report.append("§2 five ground ticks with Fervor: %d release(s), %d stacks left"
		% [int(rel), ally.faith_stacks])
	ok(rel == 1.0,
		"§2: five ticks of the ground release EXACTLY ONCE with Fervor learned (got %d)"
			% int(rel))
	await _kill(scene)
	_live_ran += 1


# ...and the matched control: the same five ticks WITHOUT the node must release
# exactly the same number of times. If Fervor still deepened the drip this pair
# would differ, and nothing else in the suite would notice.
func _live_the_ground_drips_a_flat_one() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	_ground(ally)
	scene.get("sim_stats").clear()
	for _i in 5:
		scene.call("_ground_faith_tick", ally)
	var rel := _stat_of(scene, "faith_releases")
	ok(rel == 1.0,
		"§2: WITHOUT Fervor, five ticks release exactly once too (got %d)" % int(rel))
	# One tick is one stack, stated directly.
	_neutral(scene)
	_ground(ally)
	scene.call("_ground_faith_tick", ally)
	ok(ally.faith_stacks == 1,
		"§2: one tick of Consecrated Ground is ONE Faith (got %d)" % ally.faith_stacks)
	await _kill(scene)
	_live_ran += 1


# BINDING OATH: an ally's release swears the Devout a stack of his own.
func _live_the_devout_accrues_his_own_faith() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var dv := _devout(scene)
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(dv != null and dv.oath_faith == 1, "§2: Binding Oath is stamped on the Devout")
	_neutral(scene)
	for i in 3:
		# BATCH DC: HELD_MAX, not 4. Under CZ §2's threshold a gain from 4 clamps
		# DOWN to 3, so `_faith_gained` was booking a NEGATIVE stack into the
		# source table on every iteration while the release still fired.
		ally.faith_stacks = HELD_MAX
		scene.call("_gain_faith", ally, 1, "absorb")   # the threshold stack: a release
		ok(dv.faith_stacks == i + 1,
			"§2: ally release %d leaves the Devout holding %d Faith (holds %d)"
				% [i + 1, i + 1, dv.faith_stacks])
	# ...and without the node he gains nothing from an ally's release.
	await _kill(scene)
	var bare := await _spawn()
	var b_dv := _devout(bare)
	var b_ally: BattleUnit = bare.get("heroes")[0]
	_neutral(bare)
	for _i in 3:
		b_ally.faith_stacks = HELD_MAX
		bare.call("_gain_faith", b_ally, 1, "absorb")
	ok(b_dv.faith_stacks == 0,
		"§2: WITHOUT the node an ally's release swears him nothing (holds %d)"
			% b_dv.faith_stacks)
	await _kill(bare)
	_live_ran += 1


# HIS OWN STACKS PAY HIM. The mitigation half, measured, and it must be the same
# rate an ally gets — "the same mitigation and damage they pay them".
func _live_his_own_faith_pays_him_mitigation() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var dv := _devout(scene)
	var base := await _damage_taken(scene, dv, 0)
	var held := await _damage_taken(scene, dv, STACKS)
	var cut := 100.0 * (1.0 - held / base)
	_report.append("§2 the Devout's OWN %d stacks mitigate %.1f%% (want %d)"
		% [STACKS, cut, BASE_MITIGATION * STACKS])
	ok(absf(cut - float(BASE_MITIGATION * STACKS)) < 2.0,
		"§2: his own Faith pays HIM the same %d%% a stack (measured %.1f%%)"
			% [BASE_MITIGATION, cut])
	await _kill(scene)
	_live_ran += 1


func _live_his_own_faith_pays_him_damage() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var dv := _devout(scene)
	var base := await _damage_dealt(scene, dv, 0)
	var held := await _damage_dealt(scene, dv, STACKS)
	var up := 100.0 * (held / base - 1.0)
	_report.append("§2 the Devout's OWN %d stacks add %.1f%% damage (want %d)"
		% [STACKS, up, BASE_DAMAGE * STACKS])
	ok(absf(up - float(BASE_DAMAGE * STACKS)) < 2.0,
		"§2: ...and the same +%d%% a stack dealt (measured +%.1f%%)"
			% [BASE_DAMAGE, up])
	await _kill(scene)
	_live_ran += 1


# THE NEGATIVE CONTROL THAT MATTERS. A releasing Devout puts the frequency loop
# straight back — and he HAS been releasing since Batch AW §2, so this is a
# behaviour change and not only a guard against a future one.
func _live_his_own_faith_never_releases() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var dv := _devout(scene)
	_neutral(scene)
	scene.get("sim_stats").clear()
	var hp_before := dv.max_hp
	# Twenty stacks' worth, one at a time. An ALLY would have released six times
	# over — BATCH DC: four under a threshold of five, six under CZ §2's three.
	for _i in 20:
		scene.call("_gain_faith", dv, 1, "absorb")
	ok(dv.faith_stacks == RELEASE,
		"§2: the Devout's own Faith HOLDS at the threshold (holds %d)" % dv.faith_stacks)
	ok(_stat_of(scene, "faith_releases") == 0.0,
		"§2: ...twenty gains produce ZERO releases (%d)"
			% int(_stat_of(scene, "faith_releases")))
	ok(dv.max_hp == hp_before,
		"§2: ...so Conviction's principal never grows off his own meter (%d -> %d)"
			% [hp_before, dv.max_hp])
	ok(dv.has_status("faith"),
		"§2: ...and the chip is there, showing what he holds")
	var chip_desc := ""
	for s in dv.statuses:
		if s.id == "faith":
			chip_desc = String(s.get("desc", ""))
	ok(chip_desc.to_lower().contains("never releases"),
		"§2: ...and its tooltip says so rather than promising a payout")
	# The same twenty gains on an ALLY release 20/RELEASE times — the pair is what
	# proves the rule is about WHO holds the Faith, not about the amount.
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	scene.get("sim_stats").clear()
	for _i2 in 20:
		scene.call("_gain_faith", ally, 1, "absorb")
	ok(_stat_of(scene, "faith_releases") == float(20 / RELEASE),
		"§2: ...while an ALLY's twenty gains release %d times (%d)"
			% [20 / RELEASE, int(_stat_of(scene, "faith_releases"))])
	await _kill(scene)
	_live_ran += 1


# THE REMNANT IS GONE. A release resets to zero, with Binding Oath learned and
# without it — the node no longer touches what a release consumes.
func _live_an_ally_release_resets_to_zero() -> void:
	var scene := await _spawn({"dv_oath": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	_neutral(scene)
	ally.faith_stacks = HELD_MAX
	scene.call("_gain_faith", ally, 1, "absorb")
	ok(ally.faith_stacks == 0,
		"§2: a release resets the ally to ZERO even with Binding Oath (left %d)"
			% ally.faith_stacks)
	# BATCH BI §1 INVERTED THIS, as it did BG's identical check. The COUNT goes
	# to zero; the PEAK does not, and it keeps paying — so a chip that vanished
	# would hide a live benefit rather than report an empty meter.
	ok(ally.has_status("faith"),
		"§2/BI: ...and the chip STAYS, at zero stacks, because the peak pays on")
	ok(ally.faith_peak == RELEASE,
		"§2/BI: ...with the peak standing at the threshold (reads %d)" % ally.faith_peak)
	var bsrc := _src("res://scripts/battle.gd")
	ok(bsrc.contains("_conviction_growth(devout, true)"),
		"§2: ...so the growth is always a full step — nothing consumes nothing now")
	await _kill(scene)
	_live_ran += 1


# The re-pointed rune clause, driven at its own function (the `_run_battle`
# cannot-be-driven-headlessly rule — a clause left inline could only ever be
# checked by a grep).
func _live_the_opening_oath() -> void:
	var scene := await _spawn()
	var dv := _devout(scene)
	_neutral(scene)
	dv.oath_opening = 0
	scene.call("_swear_opening_oath")
	ok(dv.faith_stacks == 0,
		"§2: without the rune the opening oath grants nothing (%d)" % dv.faith_stacks)
	dv.oath_opening = 1
	scene.call("_swear_opening_oath")
	ok(dv.faith_stacks == 1,
		"§2: with it the Devout opens the fight holding 1 Faith (holds %d)"
			% dv.faith_stacks)
	var bsrc := _src("res://scripts/battle.gd")
	ok(bsrc.contains("\t_swear_opening_oath()"),
		"§2: ...and it is CALLED from the battle-start block, not merely defined")
	await _kill(scene)
	_live_ran += 1
