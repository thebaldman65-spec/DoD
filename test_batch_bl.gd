# test_batch_bl.gd — ENEMY INTENT (§1) and THE RECAP (§2). Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --fixed-fps 12 \
#       --path . --script test_batch_bl.gd
#
# --fixed-fps 12 IS NOT OPTIONAL and it is not the sim.sh flag. sim.sh passes
# 240 to make frames run back-to-back in WALL time; this suite passes 12 to make
# each frame a big TIME step, because a real-play battle paces itself with
# `create_timer` waits and §2's ledger can only be read after a fight ends. At
# the default step a three-orc fight does not finish inside any sane frame
# budget; at 12 it finishes in ~700 frames. Nothing the battle computes reads
# delta, so the fights themselves are unchanged.
#
# Two halves, and they need different harnesses. §1's declaration machinery and
# §2's ledger are reachable on a SPAWNED BATTLE SCENE (the test_batch_ah_battle
# pattern: arm a run, instantiate battle.tscn under autoplay, drive it); the
# structural promises — that the lost-turn branches discard, that the intent
# display does no damage arithmetic of its own — are asserted against the SOURCE,
# because a rule with no live gate can only be checked where it is written.
#
# `_run_battle` cannot be driven step-by-step headlessly (the AR trap), so the
# re-validation branches are exercised by CALLING `_revalidate_intent` on a real
# spawned unit with the state hand-built around it, rather than by hoping a
# thousand random battles happen to produce a dead target.
#
# THE FIVE NEGATIVE CONTROLS ARE THE POINT OF §4 (marked NEGATIVE below). Each
# of the five would fail SILENTLY — a preview computing its own damage still
# shows a number, a fallback still swings, a declaration that survives a stun
# still resolves, an instance-keyed taken row still adds up, and a recap section
# missing from the copy text still renders on screen. Every one is checked by
# BUILDING the broken state and proving the checker rejects it.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var sections := 0   # bumped at the LAST line of each section
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


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
	Profile.save_path = "user://profile_batch_bl_test.json"
	Profile.loaded = false
	Profile.data = {}

	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_state.gd")

	await _section_declaration()
	await _section_revalidation()
	await _section_charging()
	_section_intent_structure(bsrc)
	await _section_taken()
	await _section_recap_lines()
	_section_tally_bounds()
	_section_save(rsrc)
	await _section_sim_purity()
	await _section_negative_controls(bsrc, usrc)

	if FileAccess.file_exists("user://profile_batch_bl_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bl_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	# A GDScript error mid-function aborts that function and the suite still
	# prints "0 failures" — the aborted body simply stops calling ok(). Every
	# section bumps this on its last line, so a section that died is a failure
	# rather than a quieter pass.
	ok(sections == 10,
		"suite: all 10 sections ran to their last line (%d did)" % sections)
	print("\ntest_batch_bl: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- harness ----------

# Arms a run and spawns one battle scene, PAUSED at the opening: the caller gets
# the scene before the autoplay loop has resolved much, which is what the
# declaration checks need. `frames` lets a caller run the fight out instead.
func _spawn(lineup: Array, frames := 6, node_type := "fight") -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "holy", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": node_type, "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in frames:
		await process_frame
	return scene


# Runs a spawned battle until it ends (or the budget runs out) and returns the
# Run tally. The end screen waits for input, so the budget is the exit.
func _finish(scene: Node, budget := 2500) -> Dictionary:
	for _i in budget:
		if scene.get("battle_over"):
			break
		await process_frame
	for _i in 8:
		await process_frame
	return root.get_node("/root/Run").tally


func _enemy_of(scene: Node, kind: String) -> BattleUnit:
	for e in scene.get("enemies"):
		if not e.dead and String(e.enemy_kind) == kind:
			return e
	return null


# ---------- §1a: declare on schedule ----------

func _section_declaration() -> void:
	# TEN FRAMES, deliberately. `_run_battle` declares after its opening hooks
	# and before its last pre-loop wait, so at ~0.5s of battle time every enemy
	# has declared and none has acted, been killed or been frozen yet. Reading
	# later would be reading the turn loop's re-declarations instead, which is a
	# different (and weaker) claim.
	var scene := await _spawn(["raider", "archer", "shieldmaster"], 10)
	var expected := 0
	var declared := 0
	for e in scene.get("enemies"):
		# A dead or HELD enemy declares nothing, by rule — it is not going to
		# act. Excluded from the denominator rather than from the check.
		if e.dead or scene._is_held(e):
			continue
		expected += 1
		if not e.intent.is_empty():
			declared += 1
	ok(expected > 0, "§1: the board has enemies that can declare")
	ok(declared == expected,
		"§1: every enemy declares at battle start (%d of %d)" % [declared, expected])
	# The declaration names a REAL ability the unit owns and a REAL target.
	var all_own := true
	var all_targeted := true
	for e in scene.get("enemies"):
		if e.intent.is_empty():
			continue
		var ab: Ability = e.intent.get("ability")
		if ab == null or not e.abilities.has(ab):
			all_own = false
		var t = e.intent.get("target")
		if t == null or not is_instance_valid(t):
			all_targeted = false
	ok(all_own, "§1: a declared ability is one the declaring unit actually owns")
	ok(all_targeted, "§1: a declaration names a live target")
	# Every declaration carries one of the seven categories, and the icon table
	# has an entry for it — a category with no icon would render blank.
	var cats_ok := true
	for e in scene.get("enemies"):
		if e.intent.is_empty():
			continue
		if not scene.INTENT_ICONS.has(String(e.intent.get("category", ""))):
			cats_ok = false
	ok(cats_ok, "§1: every declared category has an icon")
	ok(scene.INTENT_ICONS.size() == 7, "§1: seven categories, as the table says")
	# The categories are data-driven, so the roster classifies itself: check the
	# four that the shipped roster must produce.
	var seen := {}
	for kind in Enemies.kinds():
		var cfg := Enemies.config(kind)
		var probe := BattleUnit.new()
		probe.abilities = cfg["abilities"]
		for a in probe.abilities:
			seen[scene._intent_category(probe, a)] = true
		probe.free()
	for want in ["strike", "sweep", "crush", "afflict", "bolster", "mend"]:
		ok(seen.has(want), "§1: the shipped roster produces the %s category" % want)
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §1b: the three re-validation branches ----------

func _section_revalidation() -> void:
	var scene := await _spawn(["chief", "raider"])
	var chief := _enemy_of(scene, "chief")
	ok(chief != null, "§1: the chief spawned")
	if chief == null:
		sections += 1
		return
	var heroes: Array = scene.get("heroes")
	var basic: Ability = scene._cheapest_attack(chief)

	# --- 1: a dead target re-targets WITHIN THE SAME ABILITY ---
	var victim: BattleUnit = heroes[0]
	var survivor: BattleUnit = heroes[1]
	var before_rt: float = scene.sim_stats.get("intent_retarget", 0.0)
	chief.intent = {"ability": basic, "target": victim, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "strike"}
	victim.dead = true
	var decl: Dictionary = scene._revalidate_intent(chief)
	victim.dead = false
	ok(decl.get("ability") == basic,
		"§1 case 1: the ability survives a dead target — only the victim changes")
	ok(decl.get("target") != null and decl.get("target") != victim,
		"§1 case 1: a live target replaces the dead one")
	ok(scene.sim_stats.get("intent_retarget", 0.0) == before_rt + 1.0,
		"§1 case 1: the re-target is counted")

	# A FREED target, not merely a dead one. A Beastmaster's beast is
	# queue_free'd when it is swapped out, and an enemy that declared against it
	# is holding the last reference — so case 1 has to survive reading a freed
	# instance, which is a runtime error on a typed read before any validity
	# check gets to run. Found in a live 50-run measurement, pinned here.
	var ghost := BattleUnit.new()
	ghost.unit_name = "Ghost"
	ghost.is_hero = true
	scene.add_child(ghost)
	chief.intent = {"ability": basic, "target": ghost, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "strike"}
	ghost.free()
	var decl_ghost: Dictionary = scene._revalidate_intent(chief)
	ok(decl_ghost.get("ability") == basic,
		"§1 case 1: a FREED target re-targets rather than crashing")
	ok(decl_ghost.get("target") != null
			and is_instance_valid(decl_ghost.get("target")),
		"§1 case 1: the replacement target is a live unit")

	# --- 2: an unusable ability falls back to basic, AND SAYS SO ---
	# Heavy Strike costs 30 Rage; empty the chief's pool and the declaration
	# cannot be paid for at resolution.
	var heavy: Ability = scene._find_ability(chief, "Heavy Strike")
	ok(heavy != null and heavy.cost > 0, "§1: Heavy Strike still costs a resource")
	var before_fb: float = scene.sim_stats.get("intent_fallback", 0.0)
	var log_before: String = scene.history.get_parsed_text()
	chief.resource = 0
	chief.intent = {"ability": heavy, "target": survivor, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "strike"}
	var decl2: Dictionary = scene._revalidate_intent(chief)
	ok(decl2.get("ability") == basic,
		"§1 case 2: an unpayable declaration falls back to the basic attack")
	ok(scene.sim_stats.get("intent_fallback", 0.0) == before_fb + 1.0,
		"§1 case 2: the fallback is counted")
	var log_added: String = scene.history.get_parsed_text().substr(log_before.length())
	ok(log_added.contains("falls back to"),
		"§1 case 2: THE FALLBACK IS LOGGED — a silent substitution is the intent "
		+ "system lying (log said: %s)" % log_added.strip_edges().left(90))

	# --- 3: a unit that cannot act DISCARDS, and does not bank ---
	var before_dc: float = scene.sim_stats.get("intent_discarded", 0.0)
	chief.intent = {"ability": basic, "target": survivor, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "strike"}
	scene._discard_intent(chief, "stunned")
	ok(chief.intent.is_empty(), "§1 case 3: the declaration is discarded, not banked")
	ok(scene.sim_stats.get("intent_discarded", 0.0) == before_dc + 1.0,
		"§1 case 3: the discard is counted")
	ok(scene.sim_stats.get("intent_discard_stunned", 0.0) >= 1.0,
		"§1 case 3: the discard names its cause")
	# A second discard with nothing declared is free — the cancelled wind-up
	# path calls it twice by construction and must not double-count.
	scene._discard_intent(chief, "stunned")
	ok(scene.sim_stats.get("intent_discarded", 0.0) == before_dc + 1.0,
		"§1 case 3: discarding an empty declaration counts nothing")

	# The declared ability IS the one that resolves when nothing went stale.
	chief.resource = chief.max_resource
	chief.intent = {"ability": heavy, "target": survivor, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "strike"}
	var decl3: Dictionary = scene._revalidate_intent(chief)
	ok(decl3.get("ability") == heavy and decl3.get("target") == survivor,
		"§1: an intact declaration resolves exactly as declared")
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §1c: the wind-up is the SAME mechanism ----------

func _section_charging() -> void:
	var scene := await _spawn(["hurler", "raider"])
	var hurler := _enemy_of(scene, "hurler")
	ok(hurler != null, "§1: the Ash Hurler spawned")
	if hurler == null:
		sections += 1
		return
	var siege: Ability = scene._find_ability(hurler, "Siege Stone")
	ok(siege != null and siege.special == "windup",
		"§1: Siege Stone is still the wind-up")
	# A CHARGING ENEMY PRODUCES ONE DECLARATION, NOT TWO. Hoist the stone by
	# hand (status + intent, exactly as the windup handler does), then ask for
	# an end-of-turn declaration: it must leave the stored blow alone.
	hurler.add_status("charging", "Charging", "!!", Color(1, 0.62, 0.3), -1, "")
	hurler.intent = {"ability": siege, "target": null, "turns": 1,
		"support": false, "message": "", "logs": [], "category": "windup"}
	var before: float = scene.sim_stats.get("intent_declared", 0.0)
	scene._declare_intent(hurler)
	ok(hurler.intent.get("ability") == siege,
		"§1: a charging enemy keeps the blow it already declared")
	ok(scene.sim_stats.get("intent_declared", 0.0) == before,
		"§1: a charging enemy declares ONCE, not twice")
	# And the cancel routes through the same discard door.
	var before_dc: float = scene.sim_stats.get("intent_discarded", 0.0)
	scene._cancel_charge(hurler, "STUNNED")
	ok(hurler.intent.is_empty() and not hurler.has_status("charging"),
		"§1: a cancelled wind-up drops the declaration with the chip")
	ok(scene.sim_stats.get("intent_discarded", 0.0) == before_dc + 1.0,
		"§1: a cancelled wind-up counts as exactly one discard")
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §1d: what the source must say ----------

func _section_intent_structure(bsrc: String) -> void:
	# The charging status no longer carries an ability name of its own — ONE
	# declared-action store, which is the promise §1 makes about not building a
	# parallel mechanism.
	ok(not bsrc.contains("get_status(\"charging\").get(\"ability\""),
		"§1: nothing reads an ability name off the charging status any more")
	# Each of the three lost-turn branches discards.
	for branch in ["_discard_intent(u, \"stunned\")", "_discard_intent(u, \"frozen\")",
			"_discard_intent(u, \"broken\")"]:
		ok(bsrc.contains(branch),
			"§1: the lost-turn branch calls %s" % branch)
	# The declaration happens at the CALLER, after the enemy's turn returns —
	# `_enemy_turn` has too many exits to own it.
	ok(bsrc.contains("await _enemy_turn(u)\n\t\t\t# BATCH BL §1 — DECLARE ON SCHEDULE"),
		"§1: the end-of-turn declaration sits at the call site")
	ok(bsrc.contains("_declare_all_intents()"), "§1: battle start declares")
	sections += 1


# ---------- §2a: damage taken, by hero and by KIND ----------

func _section_taken() -> void:
	# THREE ORC BRUTES. They must aggregate into one row per ability, not three
	# — the difference between a recap and a transcript. Brutes rather than
	# Shieldmasters because this section needs heroes to actually TAKE damage,
	# and a warband of menders can spend a whole fight warding each other.
	var scene := await _spawn(["brute", "brute", "brute"])
	var tally := await _finish(scene)
	var taken: Dictionary = tally.get("taken", {})
	ok(not taken.is_empty(), "§2: damage taken is tracked per hero")
	var kind_rows := 0
	var stray_rows := 0
	for hero_name in taken:
		for key in taken[hero_name]:
			if String(key).begins_with("Orc Brute / "):
				kind_rows += 1
			elif not String(key).begins_with("themself / "):
				stray_rows += 1
	ok(kind_rows > 0, "§2: taken rows are keyed on the enemy KIND's display name")
	ok(stray_rows == 0,
		"§2: three Brutes produce no fourth source (%d stray rows)" % stray_rows)
	# The per-hero total is exact and matches the sum of that hero's rows while
	# the bound has not bitten (three Shieldmasters cannot reach 24 keys).
	var totals: Dictionary = tally.get("taken_total", {})
	var exact := true
	for hero_name in taken:
		var sum := 0.0
		for key in taken[hero_name]:
			sum += float(taken[hero_name][key])
		if absf(sum - float(totals.get(hero_name, 0.0))) > 0.5:
			exact = false
	ok(exact, "§2: taken_total equals the sum of a hero's rows")
	# Damage DEALT is split by ability, and the split sums to the flat total the
	# summary has reported since Batch Z.
	var dealt: Dictionary = tally.get("dealt", {})
	var flat: Dictionary = tally.get("damage", {})
	ok(not dealt.is_empty(), "§2: damage dealt is split by ability")
	var dealt_matches := true
	for hero_name in dealt:
		var sum := 0.0
		for ability in dealt[hero_name]:
			sum += float(dealt[hero_name][ability])
		if absf(sum - float(flat.get(hero_name, 0.0))) > 1.0:
			dealt_matches = false
	ok(dealt_matches,
		"§2: the per-ability split sums to Batch Z's per-hero damage total")
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §2b: the recap's lines, on screen AND in the paste ----------

func _section_recap_lines() -> void:
	var scene := await _spawn(["raider", "archer"])
	await _finish(scene)
	# A hand-built snapshot exercises every new section deterministically —
	# including the killing blow, which a two-orc fight will not produce.
	var run := root.get_node("/root/Run")
	run.tally["dealt"] = {"Berserker": {"Hack and Slash": 300.0, "Strike": 120.0}}
	run.tally["taken"] = {"Berserker": {"Orc Raider / Slash": 90.0,
		"themself / Blood Price": 40.0}}
	run.tally["taken_total"] = {"Berserker": 130.0}
	run.tally["kills"] = [{"hero": "Berserker", "source": "Orc Raider",
		"ability": "Slash", "amount": 52, "hp_before": 40, "self": false,
		"zone": 1, "tier": 4}]
	run.tally["final"] = {
		"dealt": {"Berserker": {"Strike": 25.0}},
		"taken": {"Berserker": {"Orc Raider / Slash": 52.0}},
		"taken_total": {"Berserker": 52.0},
		"kills": run.tally["kills"].duplicate(true)}
	var snap: Dictionary = scene._run_snapshot("wipe", "")
	var lines: Array = scene._summary_lines(snap)
	var plain: String = scene._summary_plain_text(snap)
	var headers := PackedStringArray()
	for line in lines:
		if String(line[0]) == "s":
			headers.append(String(line[1]))
	for want in ["Damage dealt — by ability (whole run)",
			"Damage taken — by source (whole run)",
			"The killing blow (whole run)",
			"Damage dealt — by ability (final battle)",
			"Damage taken — by source (final battle)",
			"The killing blow (final battle)"]:
		ok(headers.has(want), "§2: the recap renders the '%s' section" % want)
	# THE KILLING BLOW'S "WAS AT" — the single most valuable line in the batch.
	ok(plain.contains("52 damage, at 40 health"),
		"§2: the killing blow records the damage AND the health it landed against")
	ok(plain.contains("their own Blood Price") or plain.contains("themself / Blood Price"),
		"§2: self-inflicted damage is marked as self-inflicted")
	# The final-battle block is SCOPED to the final battle: its Berserker total
	# is 25, not the run's 420.
	ok(plain.contains("Berserker — 25 total"),
		"§2: the final-battle breakdown reports the final battle alone")
	ok(plain.contains("Berserker — 420 total"),
		"§2: the whole-run breakdown reports the whole run")
	# NOT A DEFEAT-ONLY SCREEN.
	var comp_snap: Dictionary = scene._run_snapshot("complete", "The road ends here.")
	var comp_plain: String = scene._summary_plain_text(comp_snap)
	ok(comp_plain.contains("Damage dealt — by ability (whole run)"),
		"§2: a COMPLETED run gets the new sections too")
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §2c: the bound is real ----------

func _section_tally_bounds() -> void:
	var run: Node = load("res://scripts/run_state.gd").new()
	run.sim_run = true
	run.reset_tally()
	ok(run.TALLY_KEYS_PER_HERO == 24, "§2: the bound is 24 keys per hero per map")
	ok(run.TALLY_KILLS_MAX == 12, "§2: at most 12 killing blows are kept")
	# 150 distinct abilities — the ability-draft-that-grows-the-save case §2
	# names — must not put 150 rows in the save.
	for i in 150:
		run.tally_dealt("Berserker", "Ability %d" % i, 10.0)
	var rows: Dictionary = run.tally["dealt"]["Berserker"]
	ok(rows.size() == 24,
		"§2: 150 distinct abilities bank as 24 rows INCLUDING the overflow row, "
		+ "not 150 (got %d)" % rows.size())
	ok(rows.has(run.TALLY_OTHER),
		"§2: the overflow lands in an '(other)' row rather than being dropped")
	var sum := 0.0
	for k in rows:
		sum += float(rows[k])
	ok(absf(sum - 1500.0) < 0.5,
		"§2: nothing is lost to the bound — the rows still total 1500 (got %.0f)" % sum)
	# The taken total is never folded, so it stays exact past the bound.
	for i in 150:
		run.tally_taken("Berserker", "Kind %d / Blow" % i, 7.0)
	ok(absf(float(run.tally["taken_total"]["Berserker"]) - 1050.0) < 0.5,
		"§2: taken_total is exact past the bound")
	for i in 40:
		run.tally_kill({"hero": "Berserker", "amount": i})
	ok((run.tally["kills"] as Array).size() == 12,
		"§2: the killing-blow list is bounded at 12")
	run.free()
	sections += 1


# ---------- §2d: the save ----------

func _section_save(rsrc: String) -> void:
	var run: Node = load("res://scripts/run_state.gd").new()
	run.sim_run = true
	run.new_run()
	ok(rsrc.contains("\"version\": 10"), "§2: the save version is 10 (BATCH BM)")
	# TOLERANT LOAD: a v8 tally with none of the new keys must load and simply
	# start the counters mid-run, not crash the first writer that touches them.
	run.tally = {"damage": {}, "gold_earned": 0, "gold_spent": 0,
		"elites": 0, "battles": 3}
	for k in ["dealt", "taken", "taken_total"]:
		if not (run.tally.get(k) is Dictionary):
			run.tally[k] = {}
	if not (run.tally.get("kills") is Array):
		run.tally["kills"] = []
	if not (run.tally.get("final") is Dictionary):
		run.tally["final"] = {"dealt": {}, "taken": {}, "taken_total": {}, "kills": []}
	run.tally_dealt("Berserker", "Strike", 5.0)
	run.tally_taken("Berserker", "Orc Raider / Slash", 5.0)
	ok(int(run.tally["battles"]) == 3,
		"§2: a v8 tally keeps its old counters through the seeding")
	ok(float(run.tally["dealt"]["Berserker"]["Strike"]) == 5.0,
		"§2: a seeded v8 tally accepts the new writers")
	# The seeding lives in load_run, beside the v8 refusal it deliberately does
	# not copy — these are counters, not structure.
	ok(rsrc.contains("BATCH BL §2: a v8 save carries a tally"),
		"§2: the tolerant-load rule is stated at the load site")
	run.free()
	sections += 1


# ---------- §2e: the sim path stays dry ----------

func _section_sim_purity() -> void:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run()
	run.active = false
	var before: String = JSON.stringify(run.tally)
	# A sim battle must leave the real-play slice empty. `sim` gates both the
	# taken callback and `_bank_run_ledgers`, so a simulated fight writes
	# nothing into the run ledger at all.
	OS.set_environment("DOD_SIM", "400")
	OS.set_environment("DOD_AUTOPLAY", "")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	# Deliberately stopped PART-WAY through the first fight: a sim `_wait` is one
	# frame, so a whole battle fits inside a hundred of them, and a sim battle
	# that reaches `_check_end` reloads the scene (or quits the tree) — which
	# would take the suite with it. Swinging is all this section needs; the
	# question is whether any of that damage reached the run ledger.
	for _i in 60:
		if scene.sim_stats.get("attacks", 0.0) >= 4.0:
			break
		await process_frame
	ok(scene.get("sim"), "§2: the spawned battle really is in sim mode")
	ok(scene.sim_stats.get("attacks", 0.0) > 0.0,
		"§2: the sim battle actually swung (%d attacks)" % int(
			scene.sim_stats.get("attacks", 0.0)))
	ok(JSON.stringify(run.tally) == before,
		"§2: THE SIM PATH LEAVES THE REAL-PLAY SLICE EMPTY — nothing double-counts")
	ok((scene.get("_run_dealt") as Dictionary).is_empty()
			and (scene.get("_run_taken") as Dictionary).is_empty(),
		"§2: a sim battle writes no battle-local recap slice either")
	OS.set_environment("DOD_SIM", "")
	# Stop the loop before freeing: a sim battle that reaches `_check_end` calls
	# reload_current_scene on a tree that has no current scene, which is noise
	# in the log rather than a failure — but noise a suite should not print.
	scene.set("battle_over", true)
	scene.queue_free()
	await process_frame
	sections += 1


# ---------- §4: the five negative controls ----------

func _section_negative_controls(bsrc: String, usrc: String) -> void:
	# NEGATIVE 1 — the intent preview computing damage by its own arithmetic
	# rather than the real path.
	#
	# THIS BATCH SHIPS NO PREDICTED NUMBER (see the batch report: the damage
	# path cannot be dry-run — it mutates on the way through and rolls
	# randf_range on its first line, so two calls with identical inputs return
	# different answers). §1's instruction for that case is that the number is
	# DROPPED rather than guessed, which turns this control into its sharper
	# form: prove the intent code does no damage arithmetic at all. A future
	# batch that adds a preview by reimplementing the maths trips this.
	var intent_block := ""
	var start := bsrc.find("func _intent_category")
	var stop := bsrc.find("func _enemy_turn")
	if start >= 0 and stop > start:
		intent_block = bsrc.substr(start, stop - start)
	ok(intent_block != "", "control 1: the intent block was located")
	for forbidden in ["attacker.attack", ".attack *", "effective_armor",
			"randf_range", "* 0.01 * ", "resists.get"]:
		ok(not intent_block.contains(forbidden),
			"control 1 NEGATIVE: the intent display does no damage arithmetic "
			+ "of its own (found %s)" % forbidden)
	# And it says so where a reader will find it.
	ok(bsrc.contains("THIS BATCH DOES NOT SHIP ONE"),
		"control 1: the dropped number is documented at the display site")

	# NEGATIVE 2 — a fallback substituting without logging. Proven live in
	# §1b; proven here to be structural rather than incidental, by checking the
	# log call sits inside the fallback branch and cannot be moved out of it.
	var fb_start := bsrc.find("if not _intent_ability_usable(u, ab):")
	var fb_stop := bsrc.find("# --- 1: is the target still there? ---")
	var fb_block := bsrc.substr(fb_start, maxi(fb_stop - fb_start, 0)) \
		if fb_start >= 0 and fb_stop > fb_start else ""
	ok(fb_block.contains("_istat(\"intent_fallback\")") and fb_block.contains("_log("),
		"control 2 NEGATIVE: the fallback branch counts AND logs — a silent "
		+ "substitution cannot pass")

	# NEGATIVE 3 — a declaration surviving a stun. Build the state and prove the
	# checker rejects the banking version: an intent left in place after the
	# discard must fail, so a future refactor that forgets the call is caught.
	var scene := await _spawn(["raider", "raider"])
	var raider := _enemy_of(scene, "raider")
	if raider != null:
		var basic: Ability = scene._cheapest_attack(raider)
		var t: BattleUnit = scene.get("heroes")[0]
		var banked := {"ability": basic, "target": t, "turns": 1,
			"support": false, "message": "", "logs": [], "category": "strike"}
		raider.intent = banked.duplicate()
		# The broken version: the stun fires but nothing discards.
		raider.add_status("stunned", "Stunned", "St", Color(1, 1, 0.4), 1, "")
		ok(not raider.intent.is_empty(),
			"control 3: the broken state (a stun with the declaration intact) built")
		scene._discard_intent(raider, "stunned")
		ok(raider.intent.is_empty(),
			"control 3 NEGATIVE: a declaration cannot survive a stun")

		# NEGATIVE 4 — taken damage attributed to the INSTANCE rather than the
		# kind. Give two same-kind enemies different display names and prove the
		# source key still collapses to one row: keying on `unit_name` would
		# produce two.
		var pair: Array = []
		for e in scene.get("enemies"):
			if String(e.enemy_kind) == "raider":
				pair.append(e)
		ok(pair.size() >= 2, "control 4: two raiders spawned")
		if pair.size() >= 2:
			pair[0].unit_name = "Orc Raider (left)"
			pair[1].unit_name = "Orc Raider (right)"
			var s0: String = scene._taken_source(pair[0])
			var s1: String = scene._taken_source(pair[1])
			ok(s0 == s1 and s0 == "Orc Raider",
				"control 4 NEGATIVE: two instances of one kind give ONE source "
				+ "row (got %s / %s)" % [s0, s1])
			ok(s0 != pair[0].unit_name,
				"control 4 NEGATIVE: the source is the kind, not the instance name")
	scene.queue_free()
	await process_frame

	# NEGATIVE 5 — a recap section rendering on screen but missing from the copy
	# text. `_summary_plain_text` walks the SAME line list the panel renders, so
	# the control is that every section header reaches the paste. A section
	# appended to the panel alone would fail this.
	var scene2 := await _spawn(["raider"])
	var run := root.get_node("/root/Run")
	run.tally["dealt"] = {"Berserker": {"Strike": 10.0}}
	run.tally["taken"] = {"Berserker": {"Orc Raider / Slash": 10.0}}
	run.tally["taken_total"] = {"Berserker": 10.0}
	run.tally["kills"] = [{"hero": "Berserker", "source": "Orc Raider",
		"ability": "Slash", "amount": 10, "hp_before": 5, "self": false}]
	run.tally["final"] = {"dealt": {"Berserker": {"Strike": 10.0}},
		"taken": {"Berserker": {"Orc Raider / Slash": 10.0}},
		"taken_total": {"Berserker": 10.0}, "kills": []}
	var snap: Dictionary = scene2._run_snapshot("wipe", "")
	var plain: String = scene2._summary_plain_text(snap)
	var missing := PackedStringArray()
	for line in scene2._summary_lines(snap):
		if String(line[0]) == "s" and not plain.contains(String(line[1])):
			missing.append(String(line[1]))
	ok(missing.is_empty(),
		"control 5 NEGATIVE: EVERY section on the panel is in the copy text "
		+ "(missing: %s)" % ", ".join(missing))
	# And the bodies, not only the headers.
	ok(plain.contains("at 5 health"),
		"control 5 NEGATIVE: the killing-blow BODY reaches the clipboard too")
	scene2.queue_free()
	await process_frame
	sections += 1
