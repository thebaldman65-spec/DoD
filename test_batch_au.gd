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
#      Pyromancer ability and nothing from a class-wide pool, and each hero
#      holds every ability of their own spec. (The class-wide BOSS pool it
#      named, `CLASS_POOLS`, was deleted at DY §3; the assertion is kept and a
#      second one pins the accessor's absence.)
#   NEGATIVE CONTROLS for the two that would fail silently — the step-doubling
#      back on Singularity, and the fallback consuming a mini-boss slot.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

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
	# BATCH BM DELETED THIS SECTION WITH ITS SUBJECT. AU §2 built exclusivity
	# legibility on the HERO SHEET — click-to-spend, sibling dimming while you
	# decide, and the named reason a node is barred — and BM made that page
	# READ-ONLY: talents are meta progression, chosen between runs on the
	# build screen, and the sheet's job is now to say what is worn and that it
	# cannot be changed. The questions the section asked are about a DECISION
	# SURFACE that moved, not about a rule that was dropped; test_batch_bm's
	# negative control 5 asserts the sheet has no spend path at all, and the
	# build screen's own lock is asserted beside it. Deleted rather than
	# half-repaired, on the same reasoning as test_batch_ai's three sections.

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
	# RE-POINTED IN PLACE (Batch BH §1): the pool went four -> eight and the new
	# ids were APPENDED, which is a compatibility surface rather than a
	# preference — a node that granted Honed yesterday must grant Honed today.
	# So the check that matters is that the ORIGINAL FOUR still lead, in order,
	# and that is what is asserted; the four new ones and their order are
	# pinned in test_batch_bh.
	ok(run.UPGRADE_PRIORITY.slice(0, 4) == ["up_damage", "up_cooldown", "up_free", "up_speed"],
		"the fallback order still opens Honed -> Quickened -> Effortless -> Swift")
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
	# RE-POINTED IN PLACE (Batch BH §1): `full` deals damage, so with a pool of
	# eight it legitimately continues into Piercing rather than dead-ending.
	# The dead end is still asserted — it just needs an ability that genuinely
	# has nothing left for any of the eight, which is what `bare` is.
	ok(run.fallback_upgrade_id(full,
		["up_damage", "up_cooldown", "up_free", "up_speed"]) == "up_pierce",
		"...then Piercing, once the pool holds eight")
	var bare: Ability = Ability.make({"display_name": "Bare", "heal": 10, "cooldown": 3,
		"cost": 20, "delay": 3.0})
	ok(run.fallback_upgrade_id(bare,
		["up_cooldown", "up_free", "up_speed"]) == "",
		"...and NOTHING when every eligible upgrade is on it — the honest dead end")
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


# ---------- §1 the collision machinery, and the charter that emptied it ----------
#
# BATCH DO INVERTED THIS SECTION RATHER THAN DELETING IT. AU §1 built the
# collision site so that no ability-granting TALENT could be silently dead:
# an authored `upgrade`, an opt-out, or the generic fallback. **DO'S CHARTER
# REMOVED THE POPULATION** — a talent may not grant an ability at all now, so
# there is no talent collision left to have a fallback for.
#
# The machinery itself is NOT dead and must not be deleted: `apply_payload`'s
# two grant branches are how RUNES grant, and four runes do (Comet carries a
# `new_ability`; Binding Souls, the Last Rites and the Flayed Mind carry a
# `grant_ability`). So what this section asserts now is BOTH halves — that no
# talent grants, and that the site a rune reaches still works.
func _arcanist_authored() -> void:
	# THE CHARTER, AS A PROPERTY RATHER THAN AS A COUNT. The live number is
	# printed beside it so a regression names itself instead of just failing.
	var granting: Array = []
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			var pay: Dictionary = n.get("payload", {})
			if Talents.granted_name(pay) != "":
				granting.append("%s/%s -> %s" % [
					spec, n["id"], Talents.granted_name(pay)])
	ok(granting.is_empty(),
		"NO talent node grants an ability (%d do: %s)" % [
			granting.size(), ", ".join(granting)])
	ok(Classes.talent_granted_names().is_empty(),
		"...and `Classes.talent_granted_names()` agrees, at %d" % \
			Classes.talent_granted_names().size())
	# The two nodes this section was named for keep their ids and their cells
	# and now modify the PROTECTED CORE instead of handing out a card.
	var by_id := {}
	for n2 in Talents.LANE_TREES["arcanist"]:
		by_id[String(n2["id"])] = n2
	var oc: Dictionary = by_id["ar_overcharge"].get("payload", {})
	ok(String(oc.get("ability", "")) == "Arcane Cannon",
		"ar_overcharge points at Arcane Cannon, which every Arcanist owns")
	ok(not oc.has("upgrade") and not oc.has("new_ability"),
		"...and carries neither a grant nor a collision fallback")
	# ar_wrath kept the half that was already charter-clean: the step-doubling
	# was an `also` payload beside the grant, and it is the whole node now.
	# The FIELD and its one read site did not move, so AU §4's negative control
	# (putting the doubling back on Singularity) still bites.
	var wr: Dictionary = by_id["ar_wrath"].get("payload", {})
	ok(int((wr.get("stat", {}) as Dictionary).get("wrath_step_double", 0)) == 1,
		"ar_wrath still carries the step-doubling, as its whole payload now")
	ok(not wr.has("no_fallback"),
		"...and its `no_fallback` opt-out went with the grant it opted out of")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(usrc.count("wrath_step_double") == 2,
		"`wrath_step_double` still has exactly its field and its one read site")
	# THE MACHINERY SURVIVES FOR RUNES. Deleting it would have been the tidy
	# edit and the wrong one — four runes reach these branches.
	var tsrc := FileAccess.get_file_as_string("res://scripts/talents.gd")
	ok(tsrc.contains("static func _collided("),
		"the collision site is still authored, for the runes that reach it")
	var rune_grants := 0
	var runes_raw = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	for key in runes_raw:
		var pay3: Dictionary = (runes_raw[key] as Dictionary).get("payload", {})
		if pay3.has("grant_ability") or pay3.has("new_ability"):
			rune_grants += 1
			var nm3 := String(pay3.get("grant_ability", ""))
			if nm3 != "":
				ok(Classes.pending_talent_ability(nm3) != null,
					"rune grant `%s` still resolves outside the trees" % nm3)
	ok(rune_grants == 4,
		"FOUR runes grant an ability and they are the only grants left (%d)" % rune_grants)
	# ...AND NO SPEC IS EXEMPT ANY MORE. BA pinned three specs whose trees
	# granted nothing; that is every spec now. **IT IS ONE ASSERTION OVER ALL
	# TWELVE RATHER THAN 324 SEPARATE ONES** — the property is the same either
	# way, and 324 green lines that can only move together are 324 lines that
	# say one thing. The offenders are NAMED in the message, so a regression
	# still arrives with its spec and its id attached.
	for exempt in Talents.LANE_TREES:
		var bad: Array = []
		for n3 in Talents.LANE_TREES[exempt]:
			if Talents.granted_name(n3.get("payload", {})) != "":
				bad.append(String(n3["id"]))
		ok(bad.is_empty(),
			"%s grants no ability from any of its 27 cells (%s)" % [
				exempt, ", ".join(bad)])
	_report.append("ability-granting talent nodes: %d (DO's charter); "
		% granting.size() + "ability-granting RUNES: %d" % rune_grants)


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
		and int(by_id["ar_singularity"]["row"]) == Talents.CAPSTONE_ROW,
		"Singularity stays the RESONANCE capstone — it is the effect that moved")
	ok(String(by_id["ar_wrath"]["lane"]) == "Overload"
		and int(by_id["ar_wrath"]["row"]) == Talents.CAPSTONE_ROW,
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
	# §5: the class pool is gone from the debug grant. **AND AS OF DY §3 IT IS
	# GONE FROM THE GAME** — `class_pool()` was deleted with `CLASS_POOLS`, so
	# this negative can no longer be made false by re-adding the call: the
	# symbol it names does not resolve. Both halves are asserted, because the
	# second one is what makes the first permanent.
	ok(not bsrc.contains("+ Classes.class_pool(Classes.class_of_spec(spec))"),
		"the debug grant does not walk a class-wide boss pool")
	ok(not FileAccess.get_file_as_string("res://scripts/classes.gd").contains(
			"static func class_pool("),
		"...and `class_pool()` itself is DELETED (DY §3), so it cannot come back by accident")
	# §1: the grant site records a fallback rather than doing nothing.
	ok(tsrc.contains("static func _collided("),
		"there is ONE collision site in talents.gd")
	ok(tsrc.count("_collided(cfg, payload") == 2,
		"...reached from BOTH grant branches, new_ability and grant_ability")
	ok(tsrc.contains("const FALLBACK_KEY :="),
		"...and the cfg key it records under is named once")
	# §2: BATCH BM MOVED THE DECISION SURFACE AND THESE FOUR MOVED WITH IT.
	# AU §2's legibility was for a page where a player DECIDED; the hero sheet
	# is read-only now (talents are meta, chosen between runs), so the three
	# affordances that fired at the moment of deciding — the CHOOSE ONE bands,
	# the sibling dim, the click-to-spend — live on the build screen. WHAT AU
	# §2 WAS REALLY GUARDING SURVIVES AND IS ASSERTED HERE: a node the player
	# is not wearing must never be a bare greyed square — it wears a glyph and
	# its tooltip NAMES what stands in its row.
	var build_src := FileAccess.get_file_as_string("res://scripts/talents_screen.gd")
	ok(psrc.contains("const LOCK_GLYPH"), "an unequipped node wears a lock glyph")
	ok(psrc.contains("%s holds this row"),
		"...and its tooltip NAMES what holds the row instead")
	ok(build_src.contains("unlocking is not equipping"),
		"the build screen states the unlock-is-not-equip rule in words")
	ok(build_src.contains("it will replace"),
		"...and a node's tooltip says what equipping it would close")
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
	# THE CRIT ABOVE ALL ON THIS SPEC: a crit builds 2 where an ordinary hit
	# builds 1, so one unlucky coin turns "Singularity grants 2 extra" into "it
	# granted 4". Checks that WANT a crit set `crit_bonus` back themselves.
	return await Fixture.spawn(self, specs,
		{"enemies": lineup, "talents": {1: learned.duplicate()}, "patch": {1: member_patch},
		"deterministic": true, "crit": -10.0})


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
		# **BATCH DO INVERTED THE PAYOUT.** The generic fallback fires on a
		# GRANT COLLISION, and no talent grants any more — so an earned card
		# plus its old cell is just an earned card, at its BASE numbers. The
		# `◆` mark reads `apply_upgrades`' return, so it is empty for the same
		# reason. Both are asserted rather than removed: they are the pair that
		# would move first if a grant came back.
		if ab != null:
			ok(int(ab.get(String(probe["field"]))) == int(probe["before"]),
				"NO FALLBACK FIRES: %s %s stays at its base %d (got %s)" % [
					name, probe["field"], probe["before"],
					ab.get(String(probe["field"]))])
		var marks: Dictionary = h.ability_upgrades
		ok((marks.get(name, []) as Array).is_empty(),
			"...and nothing is marked ◆ on it, because nothing collided (got %s)" % [
				marks.get(name, [])])
		both.queue_free()
		await process_frame
		# (iii) THE CELL WITHOUT THE CARD: it hands out nothing at all now.
		var plain := await _spawn({String(probe["node"]): 1}, specs)
		var h_p := _hero(plain, 1)
		ok(_find(h_p, name) == null,
			"%s is NOT granted by its old cell — a talent may not (DO)" % name)
		ok(Classes.spec_draft_pool(String(probe["spec"])).has(name),
			"...it drafts from the %s instead" % probe["spec"])
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
	# BATCH DO: `overcharge_extra` is READ-ONLY-ZERO — the arm fires on a grant
	# collision and no talent grants. The read site (`unit.can_overcharge`) is
	# live code, so the branch is driven from here rather than left unproved.
	ok(arc.overcharge_extra == 0,
		"`overcharge_extra` is read-only-zero — nothing grants (got %d)" % arc.overcharge_extra)
	arc.overcharge_extra = 1
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
	# BATCH DO: the tooltip line describes what a node's grant does when it
	# COLLIDES, and `cr_rime` grants nothing, so there is no collision line to
	# render. An empty line is the correct answer, and it is asserted rather
	# than left to be assumed — a stale "NOTHING extra" line on a cell that
	# hands out nothing at all would be prose describing dead machinery.
	ok(line == "",
		"a cell that grants nothing renders no collision line at all: '%s'" % line)
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
	# BATCH DO: the capstone is `Unchained` and carries ONLY the step-doubling —
	# which is why AU §4's whole point survives: the node was never dead without
	# the grant, and now the grant is what went.
	ok(_find(arc, "Magi's Wrath") == null,
		"...and the ability did NOT come with it — a talent may not grant (DO)")
	ok(Classes.spec_draft_pool("arcanist").has("Magi's Wrath"),
		"...it drafts from the Arcanist instead")
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
		# ...and NOTHING a SIBLING SPEC owns. **DY §3 deleted `CLASS_POOLS`,
		# which is the list this walked**; the siblings' own boss and draft
		# pools are where those names live, and they are what the complaint
		# (testing the Arcanist put Pyromancer abilities in his hands) was
		# always about.
		var sibling_names: Array = []
		for sib in Classes.SPEC_IDS.get(Classes.class_of_spec(spec), []):
			if String(sib) == spec:
				continue
			for sn in Classes.spec_pool(String(sib)):
				if not sibling_names.has(sn):
					sibling_names.append(sn)
			for sn2 in Classes.spec_draft_pool(String(sib)):
				if not sibling_names.has(sn2):
					sibling_names.append(sn2)
		for entry2 in sibling_names:
			if Classes.spec_pool(spec).has(entry2):
				continue
			if Classes.spec_abilities(spec).any(func(a): return a.display_name == entry2):
				continue
			if Talents.granted_ability(entry2) != null \
					and Talents.LANE_TREES[spec].any(func(n):
						return Talents.granted_name(n.get("payload", {})) == entry2):
				continue
			ok(not names.has(entry2),
				"%s does NOT hold sibling-spec entry %s" % [spec, entry2])
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
