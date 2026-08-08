# test_batch_au.gd — the four things from the AT playtest. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_au.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 THE FALLBACK RULE. A node whose ability the hero already owns applies its
#      fallback rather than doing nothing. Overcharge's AUTHORED fallback fires
#      (a second use per battle); the GENERIC picks an eligible upgrade and
#      skips an ineligible one; it does NOT consume AP's once-per-run
#      allowance; and a node with no eligible upgrade left SAYS SO rather than
#      failing silently. Magi's Wrath is the one node that deliberately owes
#      nothing, and that is a consequence of §4 rather than an exemption.
#   §2 EXCLUSIVITY MADE LEGIBLE — the band with its CHOOSE ONE label, the
#      hover dim, the lock glyph, and a barred node naming what barred it,
#      driven on a REAL hero sheet rather than asserted off the source.
#   §3 DEATH RAY at 8 Resonance and 55 Mana, Terminal Velocity still 15, and
#      the greyed-out affordance naming the NEW threshold. Plus the two things
#      the batch said to check and report: that a Mage's maximum Mana leaves
#      real headroom above 55, and that the gate text is live rather than
#      hardcoded.
#   §4 THE TWO CAPSTONES, UNCROSSED. The step doubles from Magi's Wrath and NOT
#      from Singularity; Magi's Wrath still carries no per-stack damage term;
#      crit building sums to 5 with Attunement (additive, one read site); and
#      the kill clause fires ONCE PER DEATH.
#   §5 THE DEBUG GRANT, spec-scoped: with the toggle on an Arcanist holds no
#      Pyromancer ability and no CLASS_POOLS entry, and each hero holds every
#      ability of their own spec.
#   NEGATIVE CONTROLS for the two that would fail silently — the step-doubling
#      back on Singularity, and the fallback consuming a mini-boss slot.
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
	Profile.save_path = "user://profile_batch_au_test.json"
	Profile.loaded = false
	Profile.data = {}

	_fallback_table()
	_fallback_resolver()
	_fallback_no_double_spend()
	_arcanist_authored()
	_death_ray_numbers()
	_capstone_payloads()
	_source_audit()
	_negative_control_source()

	await _live_fallback_generic()
	await _live_fallback_overcharge()
	await _live_fallback_dead_end()
	await _live_capstones()
	await _live_death_ray_gate()
	await _live_debug_grant()
	await _live_tree_legibility()

	if FileAccess.file_exists("user://profile_batch_au_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_au_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_au: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- §1 the priority order and its eligibility rules ----------

func _fallback_table() -> void:
	var run := root.get_node("/root/Run")
	# The order is a DESIGN decision, so it is written down separately from the
	# pool and both lists have to agree — an id in one and not the other is a
	# fallback that can never be chosen, or one chosen for an id nothing pays.
	ok(run.UPGRADE_PRIORITY == ["up_damage", "up_cooldown", "up_free", "up_speed"],
		"the fallback order is Honed -> Quickened -> Effortless -> Swift")
	ok(run.UPGRADE_PRIORITY.size() == run.ABILITY_UPGRADES.size(),
		"every upgrade in the pool has a place in the order")
	for id in run.UPGRADE_PRIORITY:
		ok(run.ABILITY_UPGRADES.has(String(id)),
			"the order names a real upgrade: %s" % id)
	ok(run.upgrade_name("up_damage") == "Honed", "up_damage is Honed")
	ok(run.upgrade_name("up_cooldown") == "Quickened", "up_cooldown is Quickened")
	ok(run.upgrade_name("up_free") == "Effortless", "up_free is Effortless")
	ok(run.upgrade_name("up_speed") == "Swift", "up_speed is Swift")


# The resolver on its own, before any battle: it reuses AP §3's eligibility
# rules rather than inventing a second set, so an upgrade with nothing to
# change is SKIPPED and the next one down is taken.
func _fallback_resolver() -> void:
	var run := root.get_node("/root/Run")
	# Everything eligible: the highest priority wins.
	var full: Ability = Ability.make({"display_name": "Full", "damage": 20, "cooldown": 3,
		"cost": 25, "delay": 3.0})
	ok(run.fallback_upgrade_id(full) == "up_damage",
		"an ability that fits everything takes Honed first")
	ok(run.fallback_upgrade_id(full, ["up_damage"]) == "up_cooldown",
		"...Quickened once Honed is already on it")
	ok(run.fallback_upgrade_id(full, ["up_damage", "up_cooldown"]) == "up_free",
		"...then Effortless")
	ok(run.fallback_upgrade_id(full,
		["up_damage", "up_cooldown", "up_free"]) == "up_speed",
		"...then Swift, which fits anything")
	ok(run.fallback_upgrade_id(full,
		["up_damage", "up_cooldown", "up_free", "up_speed"]) == "",
		"...and NOTHING when all four are already on it — the honest dead end")
	# INELIGIBLE ONES ARE SKIPPED, NOT PAIRED. A heal has no damage, a basic no
	# cooldown, a free ability no cost — the exact three duds AP §3 closed.
	var heal: Ability = Ability.make({"display_name": "Heal", "damage": 0, "cooldown": 3,
		"cost": 20, "delay": 3.0})
	ok(run.fallback_upgrade_id(heal) == "up_cooldown",
		"a 0-damage ability SKIPS Honed and takes Quickened")
	var basic: Ability = Ability.make({"display_name": "Basic", "damage": 10, "cooldown": 0,
		"cost": 0, "delay": 2.0})
	ok(run.fallback_upgrade_id(basic, ["up_damage"]) == "up_speed",
		"a 0-cooldown 0-cost ability falls all the way to Swift")
	var inert: Ability = Ability.make({"display_name": "Inert", "damage": 0, "cooldown": 0,
		"cost": 0, "delay": 2.0})
	ok(run.fallback_upgrade_id(inert) == "up_speed",
		"even an ability that fits nothing else still fits Swift")
	ok(run.fallback_upgrade_id(inert, ["up_speed"]) == "",
		"...and once Swift is on it there is genuinely nothing left")
	ok(run.fallback_upgrade_id(null) == "", "a missing ability resolves to nothing")


# THE ONCE-PER-RUN RULE IS AP'S, AND IT GOVERNS THE MINI-BOSS PICK POOL. A
# talent fallback is not a mini-boss pick, so it must neither read
# `has_upgrade` nor write `member["upgrades"]` — otherwise one tree node
# silently costs the hero a reward three mini-bosses hand out.
func _fallback_no_double_spend() -> void:
	var run := root.get_node("/root/Run")
	var member := {"upgrades": [], "spec": "arcanist"}
	var ab: Ability = Ability.make({"display_name": "Probe", "damage": 20, "cooldown": 3,
		"cost": 25, "delay": 4.0})
	var landed: Dictionary = run.apply_upgrades(member, [ab], ["Probe"])
	ok(ab.damage == 30, "the generic fallback really lands (20 -> %d)" % ab.damage)
	ok(landed.get("Probe", []) == ["Honed"],
		"...and is booked in the RETURN, so the chip marks it for free")
	ok((member.get("upgrades", []) as Array).is_empty(),
		"IT DOES NOT CONSUME A MINI-BOSS SLOT: `upgrades` is untouched")
	ok(not run.has_upgrade(member, "up_damage"),
		"...and has_upgrade still says Honed is available to be picked")
	# Nor is it BLOCKED by an allowance already spent elsewhere: the hero holds
	# Honed on another ability and the fallback still hands out Honed here.
	var member2 := {"upgrades": [{"id": "up_damage", "ability": "Other"}],
		"spec": "arcanist"}
	var ab2: Ability = Ability.make({"display_name": "Probe2", "damage": 20, "cooldown": 3,
		"cost": 25, "delay": 4.0})
	run.apply_upgrades(member2, [ab2], ["Probe2"])
	ok(ab2.damage == 30,
		"the fallback BYPASSES once-per-run: Honed lands though it is spent")
	# But "not already on THIS ability" is respected, and it reads the same
	# data apply_upgrades reads rather than a second copy of it.
	var member3 := {"upgrades": [{"id": "up_damage", "ability": "Probe3"}],
		"spec": "arcanist"}
	var ab3: Ability = Ability.make({"display_name": "Probe3", "damage": 20, "cooldown": 3,
		"cost": 25, "delay": 4.0})
	run.apply_upgrades(member3, [ab3], ["Probe3"])
	ok(ab3.damage == 30 and ab3.cooldown == 1,
		"a Honed already on this ability is skipped: it takes Quickened (dmg %d, cd %d)" % [
			ab3.damage, ab3.cooldown])
	# An entry naming an ability the kit no longer holds is silent, not an error.
	var member4 := {"upgrades": [], "spec": "arcanist"}
	var landed4: Dictionary = run.apply_upgrades(member4, [], ["Gone"])
	ok(landed4.is_empty(), "a fallback for an ability the hero lost is silent")


# ---------- §1 the Arcanist's two, authored ----------

func _arcanist_authored() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["arcanist"]:
		by_id[String(n["id"])] = n
	var oc: Dictionary = by_id["ar_overcharge"].get("payload", {})
	ok(Talents.collision_kind(oc) == "authored",
		"Overcharge's node carries an AUTHORED fallback")
	ok(Talents.granted_name(oc) == "Overcharge",
		"...on the ability it grants")
	var oc_up: Array = oc.get("upgrade", [])
	ok(oc_up.size() == 1
		and int((oc_up[0].get("stat", {}) as Dictionary).get("overcharge_extra", 0)) == 1,
		"...and it buys exactly one EXTRA use per battle")
	var wr: Dictionary = by_id["ar_wrath"].get("payload", {})
	ok(Talents.collision_kind(wr) == "none",
		"Magi's Wrath deliberately owes NOTHING on a collision")
	# ...and that is only honest because §4 gave it a passive half. A node that
	# opted out AND had nothing else would be exactly the dead node §1 exists
	# to close, so the two assertions belong together.
	var wr_also: Array = wr.get("also", [])
	ok(wr_also.size() == 1
		and int((wr_also[0].get("stat", {}) as Dictionary).get("wrath_step_double", 0)) == 1,
		"...because the node carries the step-doubling as a PASSIVE regardless")
	# Every OTHER ability-granting node in the game gets the generic — the
	# mechanism is game-wide, and a node left on nothing is what AU §1 fixes.
	var granting := 0
	var generic := 0
	var generic_ids: Array = []
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			var pay: Dictionary = n.get("payload", {})
			if Talents.granted_name(pay) == "":
				continue
			granting += 1
			var kind := Talents.collision_kind(pay)
			ok(kind in ["authored", "generic", "none"],
				"%s's collision behaviour is one of the three" % n["id"])
			if kind == "generic":
				generic += 1
				generic_ids.append(String(n["id"]))
			elif kind == "none":
				ok(String(n["id"]) == "ar_wrath",
					"%s is the only node that opts out entirely" % n["id"])
	ok(granting >= 20,
		"the roster really does hold a pile of ability-granting nodes (%d)" % granting)
	# RE-POINTED IN PLACE BY BATCH AX, with the reason here: this floor FALLS
	# on purpose, one class batch at a time. AU shipped it at 15 generics with
	# only the Arcanist's two authored; AV authored Holy's two (13), AW the
	# Devout's two (11), AX the Occultist's two (9) — and with that the CLERIC
	# CLASS IS DONE. A bare ">= 11" would have read as a regression rather
	# than as the mechanism working, so the floor moves WITH the reason and the
	# survivors are NAMED below so it cannot be lowered again by attrition.
	ok(generic >= 9,
		"most of them fall back on the GENERIC, which is the point (%d)" % generic)
	# THE DURABLE HALF: a class whose re-author batch has landed owes no
	# generics at all. ALL THREE Cleric specs are authored now.
	for done_spec in ["arcanist", "holy", "inquisitor", "occultist"]:
		for n2 in Talents.LANE_TREES.get(done_spec, []):
			var pay2: Dictionary = n2.get("payload", {})
			if Talents.granted_name(pay2) == "":
				continue
			ok(Talents.collision_kind(pay2) != "generic",
				"%s (%s) has an AUTHORED fallback — its class batch landed" % [
					n2["id"], done_spec])
	_report.append("ability-granting nodes: %d, of which %d take the generic" % [
		granting, generic])


# ---------- §3 Death Ray ----------

func _death_ray_numbers() -> void:
	var dray: Ability = null
	for ab in Classes.spec_abilities("arcanist"):
		if ab.display_name == "Death Ray":
			dray = ab
	ok(dray != null, "Death Ray is still in the opening three")
	if dray == null:
		return
	ok(dray.cost == 55, "Death Ray costs 55 Mana (got %d)" % dray.cost)
	# Unchanged, and stated so a later batch cannot quietly ride along.
	ok(dray.damage == 150, "damage unchanged at 150%% of Attack")
	ok(abs(dray.delay - 5.0) < 0.001, "initiative unchanged at 5.0")
	ok(dray.cooldown == 3, "cooldown unchanged at 3")
	ok(not dray.aoe and dray.random_hits == 0 and dray.multi_hits == 0,
		"target count unchanged: single target")
	ok(dray.pressure == 0,
		"STILL NO BREAK DAMAGE — left open deliberately, recorded not fixed")
	ok(dray.description.contains("below 8"),
		"...and its own description names the NEW gate")
	# THE FIRST THING THE BATCH ASKED TO CHECK AND REPORT: a Mage's maximum Mana
	# has to leave real headroom above 55, or this is a cost that cannot be paid.
	var run := root.get_node("/root/Run")
	var mage_mana := int(run.HERO_BASE["mage"]["mana"])
	ok(mage_mana >= 55 + 20,
		"a Mage's max Mana (%d) leaves real headroom above 55" % mage_mana)
	_report.append(("Mage max Mana %d vs Death Ray's 55 = %d headroom; "
		+ "at 22 regen that is %.1f turns of saving from empty") % [
		mage_mana, mage_mana - 55, 55.0 / 22.0])


# ---------- §4 the two capstones ----------

func _capstone_payloads() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["arcanist"]:
		by_id[String(n["id"])] = n
	var sg: Dictionary = by_id["ar_singularity"].get("payload", {}).get("stat", {})
	ok(int(sg.get("singularity_crit_build", 0)) == 2,
		"Singularity: critical hits build 2 ADDITIONAL Resonance")
	ok(int(sg.get("singularity_kill_build", 0)) == 3,
		"Singularity: every enemy killed builds 3")
	ok(not sg.has("wrath_step_double") and not sg.has("singularity"),
		"Singularity NO LONGER touches the damage step")
	var wr: Dictionary = by_id["ar_wrath"].get("payload", {})
	ok(not wr.get("stat", {}).has("singularity_crit_build"),
		"...and Magi's Wrath does not take a build-rate clause in exchange")
	ok(String(by_id["ar_singularity"]["lane"]) == "Resonance"
		and int(by_id["ar_singularity"]["row"]) == 8,
		"Singularity stays the RESONANCE capstone — it is the effect that moved")
	ok(String(by_id["ar_wrath"]["lane"]) == "Overload"
		and int(by_id["ar_wrath"]["row"]) == 8,
		"Magi's Wrath stays the OVERLOAD capstone")
	ok(String(by_id["ar_timelord"]["name"]) == "Perfect Conversion",
		"Perfect Conversion (Entropy) is unchanged")
	# Both descriptions have to describe what they now do — the tooltip is the
	# only place a player meets either number.
	ok(String(by_id["ar_singularity"]["desc"]).contains("2")
		and String(by_id["ar_singularity"]["desc"]).contains("3"),
		"Singularity's tooltip names both of its numbers")
	ok(not String(by_id["ar_singularity"]["desc"]).to_lower().contains("doubles"),
		"...and no longer promises a doubling it does not do")
	ok(String(by_id["ar_wrath"]["desc"]).contains("3%"),
		"Magi's Wrath's tooltip names the doubled step")
	# THE ARITHMETIC §4 ASKED TO BE CHECKED RATHER THAN ASSUMED.
	var u := BattleUnit.new()
	u.second_resource_name = "Resonance"
	u.second_resource = 12
	var plain := u.resonance_dmg_bonus()
	u.wrath_step_double = 1
	var doubled := u.resonance_dmg_bonus()
	u.wrath_step_double = 0
	u.second_resource = 16
	var deeper := u.resonance_dmg_bonus()
	u.free()
	ok(abs(doubled - 2.0 * plain) < 0.0001,
		"doubling the STEP doubles the payout (x%.2f)" % (doubled / plain))
	ok(deeper > 1.6 * plain and deeper < 1.8 * plain,
		"four more stacks is ~1.7x — quadratic beats linear (x%.2f)" % (deeper / plain))
	_report.append(("capstone comparison at 12 stacks: Magi's Wrath x%.2f, "
		+ "Singularity's ~16 stacks x%.2f — the two come out comparable") % [
		doubled / plain, deeper / plain])


# ---------- source audits: the things a live test cannot see ----------

func _source_audit() -> void:
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var tsrc := FileAccess.get_file_as_string("res://scripts/talents.gd")
	var psrc := FileAccess.get_file_as_string("res://scripts/party_screen.gd")
	# §4: exactly ONE field moves the damage step, and it is Magi's Wrath's.
	ok(usrc.contains("if wrath_step_double > 0:"),
		"the damage step reads wrath_step_double")
	ok(not usrc.contains("if singularity > 0:"),
		"NEGATIVE CONTROL: nothing reads a bare `singularity` for the step")
	ok(not usrc.contains("var singularity :="),
		"...and the old field is gone rather than left to be re-read")
	# §4: crit building is summed at exactly one site, additively.
	ok(bsrc.contains("attacker.attunement_crit\n\t\t\t\t+ attacker.singularity_crit_build"),
		"crit building sums base + Attunement + Singularity at ONE site")
	ok(bsrc.count("singularity_crit_build") == 1,
		"...and that is its ONLY read site (a second would double it)")
	ok(bsrc.count("_gain_resonance(sg_h") == 1,
		"the kill clause is paid in exactly one place")
	# §5: the class pool is gone from the debug grant.
	ok(not bsrc.contains("+ Classes.class_pool(Classes.class_of_spec(spec))"),
		"the debug grant no longer walks CLASS_POOLS")
	# §1: the grant site records a fallback rather than doing nothing.
	ok(tsrc.contains("static func _collided("),
		"there is ONE collision site in talents.gd")
	ok(tsrc.count("_collided(cfg, payload") == 2,
		"...reached from BOTH grant branches, new_ability and grant_ability")
	ok(tsrc.contains("const FALLBACK_KEY :="),
		"...and the cfg key it records under is named once")
	# §2: the three legibility changes, in the source that draws them.
	ok(psrc.contains("CHOOSE ONE"), "rows are drawn as bands with a CHOOSE ONE label")
	ok(psrc.contains("func _dim_siblings("), "hovering a node dims its siblings")
	ok(psrc.contains("const LOCK_GLYPH"), "a barred node wears a lock glyph")
	ok(psrc.contains("Barred — you took %s in this row."),
		"...and its tooltip names what barred it, verbatim")
	ok(psrc.contains("ONE PER HERO, EVER"),
		"the capstone shelf states its stricter rule")


# NEGATIVE CONTROLS, as source assertions for the two shapes that would
# otherwise pass silently. A test that cannot fail proves nothing.
func _negative_control_source() -> void:
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	# (1) putting the step-doubling back on Singularity.
	ok(not usrc.contains("singularity > 0")
		and not usrc.contains("singularity_crit_build > 0:\n\t\tstep"),
		"NEGATIVE CONTROL: no path lets Singularity move the damage step")
	# (2) letting the fallback consume a mini-boss upgrade slot. Both shapes
	# are named: consulting the allowance, and writing into it.
	var fb_block := rsrc.substr(rsrc.find("\tfor name in talent_fallbacks:"))
	fb_block = fb_block.substr(0, fb_block.find("\treturn landed"))
	ok(not fb_block.contains("has_upgrade"),
		"NEGATIVE CONTROL: the fallback loop never consults has_upgrade")
	ok(not fb_block.contains("member[\"upgrades\"]"),
		"NEGATIVE CONTROL: the fallback loop never writes member[\"upgrades\"]")
	ok(fb_block.contains("fallback_upgrade_id("),
		"...it resolves through the one named picker")


# ---------- live: a real battle spawn ----------

func _spawn(learned: Dictionary, specs: Array, member_patch := {},
		lineup := ["raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	for key in member_patch:
		run.party[1][key] = member_patch[key]
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT discipline): miss,
	# parry and — on this spec above all — the CRIT roll. A crit builds 2 where
	# an ordinary hit builds 1, so one unlucky coin turns "Singularity grants 2
	# extra" into "it granted 4". Checks that WANT a crit set crit_bonus back.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
	return scene


func _hero(scene: Node, idx: int) -> BattleUnit:
	var live: Array = []
	for h in scene.get("heroes"):
		if not h.is_companion:
			live.append(h)
	return live[idx] if idx < live.size() else null


func _find(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


# §1: THE HEADLINE CASE. A hero earns an ability from a boss, then takes the
# node that grants it — and the node PAYS instead of evaporating. Two probes,
# because they cover the two halves of the generic between them:
#   FIRESTORM (Pyromancer capstone, damage 12) fits Honed and takes it.
#   RIME (Cryomancer row 4, damage 0) does NOT fit Honed, so it SKIPS it and
#   takes Quickened — the eligibility rules reused rather than re-written.
func _live_fallback_generic() -> void:
	for probe in [
			{"spec": "pyromancer", "node": "py_firestorm", "ability": "Firestorm",
				"mark": "Honed", "field": "damage", "before": 12, "after": 18},
			{"spec": "cryomancer", "node": "cr_rime", "ability": "Rime",
				"mark": "Quickened", "field": "cooldown", "before": 3, "after": 1}]:
		var specs := ["berserker", String(probe["spec"]), "inquisitor", "beastmaster"]
		var name := String(probe["ability"])
		# (i) EARNED but never noded: the ability is untouched.
		var earned := await _spawn({}, specs, {"bm_abilities": [name]})
		var h_e := _hero(earned, 1)
		var ab_e := _find(h_e, name)
		ok(ab_e != null, "%s is in the kit once earned" % name)
		if ab_e != null:
			ok(int(ab_e.get(String(probe["field"]))) == int(probe["before"]),
				"...at its base %s of %d (got %s)" % [probe["field"], probe["before"],
					ab_e.get(String(probe["field"]))])
		earned.queue_free()
		await process_frame
		# (ii) EARNED AND THEN NODED. Before Batch AU this row silently dropped
		# to two live options; now the node upgrades what he already holds.
		var both := await _spawn({String(probe["node"]): 1}, specs,
			{"bm_abilities": [name]})
		var h := _hero(both, 1)
		var ab := _find(h, name)
		var copies := 0
		for a in h.abilities:
			if a.display_name == name:
				copies += 1
		ok(copies == 1, "exactly one copy of %s — no double grant (got %d)" % [name, copies])
		if ab != null:
			ok(int(ab.get(String(probe["field"]))) == int(probe["after"]),
				"THE NODE PAID ITS FALLBACK: %s %s %d -> %s" % [name, probe["field"],
					probe["before"], ab.get(String(probe["field"]))])
		# The battle tooltip's ◆ reads apply_upgrades' RETURN, so a talent
		# fallback is legible the moment it fires with nothing new to build.
		var marks: Dictionary = h.ability_upgrades
		ok((marks.get(name, []) as Array) == [String(probe["mark"])],
			"...and is marked ◆ %s on the unit, off the same return (got %s)" % [
				probe["mark"], marks.get(name, [])])
		both.queue_free()
		await process_frame
		# (iii) NODED WITHOUT EARNING IT: the ordinary grant, untouched by §1.
		var plain := await _spawn({String(probe["node"]): 1}, specs)
		var h_p := _hero(plain, 1)
		var ab_p := _find(h_p, name)
		ok(ab_p != null, "%s is granted normally when it was not owned" % name)
		if ab_p != null:
			ok(int(ab_p.get(String(probe["field"]))) == int(probe["before"]),
				"...and is NOT upgraded — a grant is not a collision")
		ok((h_p.ability_upgrades as Dictionary).get(name, []).is_empty(),
			"...and nothing is marked on it")
		plain.queue_free()
		await process_frame


# §1: OVERCHARGE'S AUTHORED FALLBACK — a second use per battle, not a generic.
func _live_fallback_overcharge() -> void:
	var scene := await _spawn({"ar_overcharge": 1},
		["berserker", "arcanist", "inquisitor", "beastmaster"],
		{"bm_abilities": ["Overcharge"]})
	var arc := _hero(scene, 1)
	var oc := _find(arc, "Overcharge")
	ok(oc != null, "Overcharge is in the kit")
	ok(arc.overcharge_extra == 1,
		"THE AUTHORED FALLBACK FIRED: one extra Overcharge (got %d)" % arc.overcharge_extra)
	ok(oc != null and oc.cost == 20,
		"...and the generic did NOT also fire (cost still 20)")
	ok(not (arc.ability_upgrades as Dictionary).has("Overcharge"),
		"...no generic upgrade was booked on it either")
	# The allowance itself, driven: two casts, then dark.
	arc.max_resource = 9999
	arc.resource = 9999
	arc.second_resource = 10
	ok(scene.call("_ability_usable", arc, oc), "Overcharge is up at the start")
	await scene.call("_resolve", arc, oc, arc, "good")
	ok(arc.overcharge_uses == 1, "one use spent")
	arc.cooldowns.erase("Overcharge")
	ok(scene.call("_ability_usable", arc, oc),
		"...and it is STILL up, because the node bought a second")
	await scene.call("_resolve", arc, oc, arc, "good")
	arc.cooldowns.erase("Overcharge")
	ok(arc.overcharge_uses == 2, "two uses spent")
	ok(not scene.call("_ability_usable", arc, oc),
		"...and NOW it is dark — two, not unlimited")
	ok(arc.has_status("overcharged"),
		"...and only now does the spent chip appear")
	scene.queue_free()
	await process_frame
	# WITHOUT the node, the base allowance is untouched: exactly one.
	var solo := await _spawn({}, ["berserker", "arcanist", "inquisitor", "beastmaster"],
		{"bm_abilities": ["Overcharge"]})
	var arc2 := _hero(solo, 1)
	var oc2 := _find(arc2, "Overcharge")
	arc2.max_resource = 9999
	arc2.resource = 9999
	arc2.second_resource = 10
	ok(arc2.overcharge_extra == 0, "an un-noded Overcharge gets no extra use")
	await solo.call("_resolve", arc2, oc2, arc2, "good")
	arc2.cooldowns.erase("Overcharge")
	ok(not solo.call("_ability_usable", arc2, oc2),
		"...and is dark after one cast, exactly as before")
	solo.queue_free()
	await process_frame


# §1: THE HONEST DEAD END. Every eligible upgrade already on the ability means
# the node grants nothing — and the hero screen SAYS SO rather than staying
# silent, which is the whole difference between this and the bug.
func _live_fallback_dead_end() -> void:
	var run := root.get_node("/root/Run")
	var scene := await _spawn({"cr_rime": 1},
		["berserker", "cryomancer", "inquisitor", "beastmaster"],
		{"bm_abilities": ["Rime"], "upgrades": [
			{"id": "up_damage", "ability": "Rime"},
			{"id": "up_cooldown", "ability": "Rime"},
			{"id": "up_free", "ability": "Rime"},
			{"id": "up_speed", "ability": "Rime"}]})
	var cryo := _hero(scene, 1)
	var rime := _find(cryo, "Rime")
	ok(rime != null, "Rime is in the kit with all four upgrades on it")
	var marks: Array = (cryo.ability_upgrades as Dictionary).get("Rime", [])
	ok(marks.size() == 4,
		"exactly the four mini-boss upgrades landed, no fifth (got %d)" % marks.size())
	scene.queue_free()
	await process_frame
	# ...and the tooltip line the hero screen renders says so in words.
	var member: Dictionary = run.party[1]
	var node := Talents.node_in_tree(member.get("tree", []), "cr_rime")
	var line: String = run.fallback_line(member, node.get("payload", {}))
	ok(line.contains("NOTHING"),
		"THE DEAD END IS STATED: '%s'" % line)
	# A node whose grant is NOT owned says nothing at all — the line only
	# appears when it would actually apply.
	var unowned: Dictionary = member.duplicate(true)
	unowned["bm_abilities"] = []
	unowned["talents"] = {}
	ok(run.fallback_line(unowned, node.get("payload", {})) == "",
		"...and a node whose ability is unowned says nothing")


# §4: BOTH CAPSTONES, LIVE.
func _live_capstones() -> void:
	# (a) the step doubles from Magi's Wrath and NOT from Singularity.
	var wr := await _spawn({"ar_wrath": 1},
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _hero(wr, 1)
	ok(arc.wrath_step_double == 1, "Magi's Wrath stamps the step-doubling")
	ok(arc.singularity_crit_build == 0 and arc.singularity_kill_build == 0,
		"...and none of Singularity's build rate")
	arc.second_resource = 12
	ok(int(arc.resonance_dmg_bonus() * 100.0) == 234,
		"...so at 12 stacks he reads +234%% (got %d)" % int(arc.resonance_dmg_bonus() * 100.0))
	ok(_find(arc, "Magi's Wrath") != null, "...and the ability came with it")
	wr.queue_free()
	await process_frame
	# §4 AND §1 CLOSE EACH OTHER'S WORST CASE, and this is the check that says so:
	# a hero who EARNED Magi's Wrath from a zone boss still gets the step-doubling
	# out of the node, which is the whole reason it owes no fallback.
	var owned := await _spawn({"ar_wrath": 1},
		["berserker", "arcanist", "inquisitor", "beastmaster"],
		{"bm_abilities": ["Magi's Wrath"]})
	var arc_o := _hero(owned, 1)
	ok(arc_o.wrath_step_double == 1,
		"an ALREADY-EARNED Magi's Wrath still gets the step-doubling from the node")
	var wcopies := 0
	for a in arc_o.abilities:
		if a.display_name == "Magi's Wrath":
			wcopies += 1
	ok(wcopies == 1, "...exactly once (got %d)" % wcopies)
	ok((arc_o.ability_upgrades as Dictionary).get("Magi's Wrath", []).is_empty(),
		"...and NO generic fallback fired: the node opted out deliberately")
	# ...and it still carries no per-stack DAMAGE term, which is AT's squaring trap.
	var mw := _find(arc_o, "Magi's Wrath")
	ok(mw != null and mw.damage == 15,
		"Magi's Wrath is a flat 15%% of Attack — no per-stack damage term")
	owned.queue_free()
	await process_frame
	var sg := await _spawn({"ar_singularity": 1},
		["berserker", "arcanist", "inquisitor", "beastmaster"],
		{}, ["raider", "raider"])
	var arc2 := _hero(sg, 1)
	ok(arc2.singularity_crit_build == 2 and arc2.singularity_kill_build == 3,
		"Singularity stamps 2 per crit and 3 per kill")
	ok(arc2.wrath_step_double == 0, "...and does NOT touch the step")
	arc2.second_resource = 12
	ok(int(arc2.resonance_dmg_bonus() * 100.0) == 117,
		"...so at 12 stacks he is still +117%% (got %d)" % int(arc2.resonance_dmg_bonus() * 100.0))
	# (b) THE KILL CLAUSE FIRES ONCE PER DEATH. Two enemies, killed one at a
	# time, so a hook firing per living hero or per strike would over-pay.
	var foes: Array = sg.get("enemies")
	arc2.second_resource = 0
	sg.call("_on_enemy_death", foes[0])
	ok(arc2.second_resource == 3,
		"one death builds exactly 3 (got %d)" % arc2.second_resource)
	sg.call("_on_enemy_death", foes[1])
	ok(arc2.second_resource == 6,
		"two deaths build exactly 6 — once per death (got %d)" % arc2.second_resource)
	sg.queue_free()
	await process_frame
	# (c) CRIT BUILDING IS ADDITIVE: base 2, Attunement 3, both 5. Driven
	# through _resolve with the crit FORCED on, which is the one place this
	# suite wants a crit rather than fearing it.
	for pair in [[{}, 2], [{"ar_mastery": 1}, 3], [{"ar_singularity": 1}, 4],
			[{"ar_mastery": 1, "ar_singularity": 1}, 5]]:
		var learned: Dictionary = pair[0]
		var expect: int = pair[1]
		var cs := await _spawn(learned, ["berserker", "arcanist", "inquisitor", "beastmaster"])
		var a := _hero(cs, 1)
		var foe: BattleUnit = cs.get("enemies")[0]
		foe.max_hp = 999999
		foe.hp = 999999
		a.max_resource = 9999
		a.resource = 9999
		a.crit_bonus = 10.0     # FORCE the crit — this check is about crits
		a.second_resource = 0
		var cannon := _find(a, "Arcane Cannon")
		await cs.call("_resolve", a, cannon, foe, "good")
		ok(a.second_resource == expect,
			"crit builds %d with %s (got %d)" % [expect, learned.keys(), a.second_resource])
		cs.queue_free()
		await process_frame


# §3: the gate at 8, live, and the affordance that names it.
func _live_death_ray_gate() -> void:
	var scene := await _spawn({}, ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _hero(scene, 1)
	var dray := _find(arc, "Death Ray")
	ok(dray != null, "Death Ray is in the kit")
	arc.max_resource = 9999
	arc.resource = 9999
	for n in [0, 5, 7]:
		arc.second_resource = n
		ok(not scene.call("_ability_usable", arc, dray),
			"Death Ray is DARK at %d Resonance" % n)
	for n in [8, 12]:
		arc.second_resource = n
		ok(scene.call("_ability_usable", arc, dray),
			"Death Ray LIGHTS at %d Resonance" % n)
	# THE SECOND THING THE BATCH ASKED TO CHECK: the greyed-out state names the
	# NEW threshold. Read off a REAL popup button, not off the constant.
	arc.second_resource = 3
	var popup := PopupPanel.new()
	scene.add_child(popup)
	var btn: Button = scene.call("_ability_popup_button", arc, dray, popup, 0)
	ok(btn.tooltip_text.contains("Requires 8 Resonance"),
		"the greyed affordance names the NEW threshold: %s" % btn.tooltip_text)
	ok(btn.disabled, "...and the button really is disabled at 3 stacks")
	popup.queue_free()
	# Terminal Velocity is unchanged and still sits clear of the gate.
	var tv := await _spawn({"ar_mindfulness": 1},
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc2 := _hero(tv, 1)
	ok(arc2.terminal_velocity == 15, "Terminal Velocity still reads 15")
	ok(arc2.terminal_velocity > scene.get("DEATH_RAY_STACKS"),
		"...and still sits clear ABOVE the new gate")
	tv.queue_free()
	scene.queue_free()
	await process_frame


# §5: the debug grant, scoped.
func _live_debug_grant() -> void:
	var run := root.get_node("/root/Run")
	run.debug_grant_all = true
	var specs := ["berserker", "arcanist", "holy", "beastmaster"]
	var scene := await _spawn({}, specs)
	for i in specs.size():
		var spec: String = specs[i]
		var h := _hero(scene, i)
		if h == null:
			continue
		var names: Array = h.abilities.map(func(a): return a.display_name)
		# Every ability of their OWN spec: the tree's grants and the spec pool.
		for entry in Classes.spec_pool(spec):
			ok(names.has(entry),
				"%s holds their own pool entry %s" % [spec, entry])
		for node in Talents.generate_tree(spec, h.hero_key):
			var granted := Talents.granted_name(node.get("payload", {}))
			if granted != "":
				ok(names.has(granted),
					"%s holds their own tree grant %s" % [spec, granted])
		# ...and NOTHING from the class pool, which is where the siblings live.
		for entry2 in Classes.class_pool(Classes.class_of_spec(spec)):
			if Classes.spec_pool(spec).has(entry2):
				continue
			if Classes.spec_abilities(spec).any(func(a): return a.display_name == entry2):
				continue
			if Talents.granted_ability(entry2) != null \
					and Talents.LANE_TREES[spec].any(func(n):
						return Talents.granted_name(n.get("payload", {})) == entry2):
				continue
			ok(not names.has(entry2),
				"%s does NOT hold class-pool entry %s" % [spec, entry2])
	# The named complaint, stated as its own check: the Arcanist and the
	# Pyromancer's signature abilities.
	var arc := _hero(scene, 1)
	var arc_names: Array = arc.abilities.map(func(a): return a.display_name)
	for pyro in ["Flamewave", "Firestorm", "Fireball", "Detonation", "Wildfire",
			"Immolate", "Pyroblast", "Backdraft"]:
		ok(not arc_names.has(pyro),
			"the Arcanist holds no Pyromancer ability (%s)" % pyro)
	for cryo in ["Razor Ice", "Blizzard", "Ice Lance", "Rime", "Shatter"]:
		ok(not arc_names.has(cryo),
			"...nor any Cryomancer one (%s)" % cryo)
	run.debug_grant_all = false
	scene.queue_free()
	await process_frame


# §2: driven on a REAL hero sheet, because the whole deliverable is drawn.
func _live_tree_legibility() -> void:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "arcanist", "holy", "beastmaster"][i]
		run.party[i]["tree"] = Talents.generate_tree(
			run.party[i]["spec"], run.party[i]["key"])
		run.party[i]["talents"] = {}
		run.party[i]["talent_points"] = 8
		run.sync_spec_hp(i)
	run.party[1]["talents"] = {"ar_harmonics": 1}
	run.specs_chosen = true
	run.active = true
	run.hero_screen_idx = 1
	var sheet: Node = load("res://scenes/party.tscn").instantiate()
	root.add_child(sheet)
	await process_frame
	await process_frame
	var labels: Array = []
	var buttons: Array = []
	for c in sheet.get_children():
		if c is Label:
			labels.append(String(c.text))
		elif c is Button:
			buttons.append(c)
	# (a) one band label per row, and the shelf naming its stricter rule.
	var bands := labels.filter(func(t): return t == "CHOOSE ONE")
	ok(bands.size() == Talents.ROWS,
		"one CHOOSE ONE band per row 1-7 (got %d)" % bands.size())
	ok(labels.any(func(t): return t.contains("ONE PER HERO, EVER")),
		"the capstone shelf states one capstone per hero, ever")
	# (c) row 1 is decided, so its two siblings wear the lock glyph.
	var locks := buttons.filter(func(b): return String(b.text) == sheet.get("LOCK_GLYPH"))
	ok(locks.size() == 2,
		"a decided row locks its TWO siblings with a glyph (got %d)" % locks.size())
	for lb in locks:
		ok(lb.modulate.r < 0.99, "...and greys them")
	# ...and the reason, by name, off the real tooltip renderer.
	var tree: Array = run.party[1].get("tree", [])
	var sibling := {}
	for n in tree:
		if int(n["row"]) == 1 and String(n["id"]) != "ar_harmonics":
			sibling = n
			break
	var check := Talents.can_learn(tree, String(sibling["id"]), run.party[1]["talents"])
	sheet.call("_show_tree_tip", sibling, 0, check, 8, Vector2(600, 200), 0)
	var state := String(sheet.get("_tree_tip_state").text)
	ok(state.contains("Barred — you took Harmonics in this row."),
		"a barred node NAMES what barred it: '%s'" % state)
	# (b) hovering dims the two siblings and nothing else, and restores.
	var by_id := {}
	for n in tree:
		by_id[String(n["id"])] = n
	var buttons_by_id: Dictionary = sheet.get("_tree_buttons")
	var base_mod: Dictionary = sheet.get("_tree_base_modulate")
	sheet.call("_dim_siblings", "ar_conduit")
	var dimmed := 0
	for id in buttons_by_id:
		var b: Button = buttons_by_id[id]
		if b.modulate.a < 0.99:
			dimmed += 1
			ok(int(by_id[id]["row"]) == 1 and String(id) != "ar_conduit",
				"only row 1's OTHER nodes dim (%s dimmed)" % id)
	ok(dimmed == 2, "hovering dims exactly two siblings (got %d)" % dimmed)
	sheet.call("_undim_siblings")
	var still := 0
	for id2 in buttons_by_id:
		if abs((buttons_by_id[id2] as Button).modulate.a - (base_mod[id2] as Color).a) > 0.001:
			still += 1
	ok(still == 0, "...and leaving restores every base modulate (%d left dim)" % still)
	# Capstones are one decision too, so the shelf dims as a row.
	sheet.call("_dim_siblings", "ar_singularity")
	var cap_dim := 0
	for id3 in buttons_by_id:
		if (buttons_by_id[id3] as Button).modulate.a < 0.99:
			cap_dim += 1
			ok(int(by_id[id3]["row"]) == Talents.CAPSTONE_ROW,
				"the shelf dims as one decision (%s)" % id3)
	ok(cap_dim == 2, "hovering a capstone dims the other two (got %d)" % cap_dim)
	sheet.queue_free()
	await process_frame
