# Batch AA: the Mage and Cleric spec runes in a LIVE battle
# (Batch AB added the Hunter sets, Batch AD the power arm).
#
# The schema test proves the entries are well formed; this proves they
# actually reach a spawned hero. Three things it can see that a data test
# cannot: the "Rune:" tag in the combat log, the CALL-SITE ORDERING fix
# (ceiling fields written by a rune must still be read), and the live-value
# chips reading correctly when a rune — not a talent — is the source.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script res://_scratch/test_rune_battle.gd
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
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
	# Profile writes are impossible here (no wipe/completion branch is
	# reached), but redirect anyway — the chronicle is the player's.
	Profile.save_path = "user://profile_rune_battle_test.json"
	Profile.loaded = false
	Profile.data = {}

	# One mage spec and one cleric spec per pass, each in its OWN class slot
	# (a spec on the wrong class key spawns with the wrong stat block).
	await _pass("pyromancer", "holy")
	await _pass("cryomancer", "occultist")
	await _pass("arcanist", "inquisitor")
	# Batch AB — the Hunter sets, each spec alone in its own class slot.
	await _hunter_pass("beastmaster")
	await _hunter_pass("sharpshooter")
	await _hunter_pass("mystic")
	# Batch AD — the power arm, live.
	await _power_arm_pass()

	if FileAccess.file_exists("user://profile_rune_battle_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_rune_battle_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("test_rune_battle: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# Every authored rune this spec can roll, all equipped at once — the harshest
# version of "does it apply", and the one that would expose a payload branch
# clobbering another.
func _equip_all(member: Dictionary) -> Array:
	var names: Array = []
	for id in Runes.eligible_ids(member, "", []):
		if not String(Runes.config(id).get("scope", "")).begins_with("spec:"):
			continue
		var rune := Runes.build(id)
		rune["equipped"] = true
		member["runes"].append(rune)
		names.append(String(rune["name"]))
	return names


# Batch AB. Every Hunter spec is idiosyncratic in a way a data test cannot
# see: the Beastmaster's numbers land on up to THREE bodies (companions
# inherit his armor at summon and per-beast terms double under The Pack), the
# Sharpshooter's Focus ceiling is DERIVED at spawn (the Batch AA ordering fix,
# exercised here for the first time by an actual rune), and the Survivalist's
# meter lives on the enemy.
func _hunter_pass(spec: String) -> void:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var chosen := ["berserker", "cryomancer", "holy", spec]
	for i in run.party.size():
		run.party[i]["spec"] = chosen[i]
		run.party[i]["tree"] = Talents.generate_tree(chosen[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		run.sync_spec_hp(i)
	var equipped: Array = _equip_all(run.party[3])
	# The Pack: the capstone that makes per-beast terms count twice.
	if spec == "beastmaster":
		run.party[3]["talents"] = {"bm_the_pack": 1}
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband",
		"enemies": ["shieldmaster", "raider", "archer", "raider"]}

	OS.set_environment("DOD_AUTOPLAY", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 12:
		await process_frame

	var hunter: Node = null
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.hero_key) == "hunter":
			hunter = h
	ok(hunter != null, "%s: never spawned" % spec)
	ok(equipped.size() == 4, "%s: equipped %d spec runes, expected 4" % [
		spec, equipped.size()])
	if hunter == null:
		scene.queue_free()
		return

	match spec:
		"beastmaster":
			ok(hunter.wild_communion_ranks >= 2,
				"beastmaster: two runes feeding wild_communion_ranks did not sum (%d)" % \
					hunter.wild_communion_ranks)
			# The Devout's field is `communion_ranks`; writing that one would be
			# a silent dud that also buffs another class.
			ok(hunter.get("communion_ranks") == 0,
				"beastmaster: a rune wrote communion_ranks — that is the DEVOUT's field")
			ok(hunter.momentum_ranks >= 2,
				"beastmaster: momentum_ranks read %d" % hunter.momentum_ranks)
			ok(hunter.loyalty_cap_bonus >= 1,
				"beastmaster: loyalty_cap_bonus read %d — the ceiling rune is a dud" % \
					hunter.loyalty_cap_bonus)
			ok(hunter.masters_aim_ranks >= 2,
				"beastmaster: masters_aim_ranks read %d" % hunter.masters_aim_ranks)
			# The scarred cost: it lands on HIM and, at summon, on every beast.
			ok(hunter.armor < 0.10,
				"beastmaster: the Loosened Straps armor cost never applied (%.2f)" % \
					hunter.armor)
			# TWO beasts, because that is where his per-beast terms double.
			scene.call("_do_summon", hunter, "ursus")
			for _i in 4:
				await process_frame
			scene.call("_do_summon", hunter, "canis")
			for _i in 4:
				await process_frame
			ok(hunter.beasts.size() == 2,
				"beastmaster: The Pack fielded %d beasts, expected 2" % hunter.beasts.size())
			for b in hunter.beasts:
				ok(abs(b.armor - hunter.armor) < 0.001,
					"beastmaster: %s wears %.2f armor, the hunter %.2f — the rune did not multiply" % [
						b.unit_name, b.armor, hunter.armor])
			ok(hunter.kinds_summoned.size() == 2,
				"beastmaster: Feral Momentum sees %d distinct beasts, expected 2" % \
					hunter.kinds_summoned.size())
			ok(scene.call("_loyalty_cap", hunter) >= 6,
				"beastmaster: the Loyalty ceiling read %d, expected 6+" % \
					scene.call("_loyalty_cap", hunter))
		"sharpshooter":
			# THE ORDERING FIX, live: both ceilings are derived from cfg at
			# spawn. Before Batch AA they were read before runes applied.
			ok(hunter.second_max == 150,
				"sharpshooter: Focus cap read %d — Deep Sight was derived before it applied" % \
					hunter.second_max)
			ok(hunter.second_resource == 60,
				"sharpshooter: opened on %d Focus — the Long Draw was derived too early" % \
					hunter.second_resource)
			ok(hunter.perfect_form >= 1, "sharpshooter: perfect_form never applied")
			ok(hunter.pierce_bonus > 0.11,
				"sharpshooter: two runes feeding pierce_bonus did not sum (%.2f)" % \
					hunter.pierce_bonus)
			ok(hunter.bonecracker_ranks >= 2,
				"sharpshooter: bonecracker_ranks read %d" % hunter.bonecracker_ranks)
			ok(hunter.muscle_memory_ranks >= 2,
				"sharpshooter: muscle_memory_ranks read %d" % hunter.muscle_memory_ranks)
			ok(hunter.speed < 100.0,
				"sharpshooter: the Long Draw speed cost never applied (%.1f)" % hunter.speed)
		"mystic":
			ok(hunter.potent_ranks >= 3,
				"survivalist: two runes feeding potent_ranks did not sum (%d)" % \
					hunter.potent_ranks)
			ok(hunter.coated_blades >= 1, "survivalist: coated_blades never applied")
			ok(hunter.vulture >= 1, "survivalist: vulture never applied")
			ok(hunter.scavenger_ranks >= 2,
				"survivalist: scavenger_ranks read %d" % hunter.scavenger_ranks)
			ok(hunter.cruel_ranks >= 1 and hunter.wire_ranks >= 1,
				"survivalist: the splash trap terms never applied")
			# The ability-branch rune, and the only requires_ability in the set.
			var snare: Ability = null
			for ab in hunter.abilities:
				if ab.display_name == "Snare Trap":
					snare = ab
			ok(snare != null, "survivalist: Snare Trap is missing")
			if snare != null:
				ok(snare.cost == 15, "survivalist: Snare Trap costs %d, expected 15" % snare.cost)
				ok(snare.cooldown == 2,
					"survivalist: Snare Trap cooldown %d, expected 2" % snare.cooldown)

	# Let the fight run: a rune that crashes mid-battle is what a spawn-time
	# check cannot see.
	for _i in 1200:
		if scene.get("battle_over"):
			break
		await process_frame
	ok(true, "%s: battle ran without a script error" % spec)

	var log_text := ""
	for rt in scene.find_children("*", "RichTextLabel", true, false):
		log_text += rt.get_parsed_text()
	var missing: Array = []
	for rune_name in equipped:
		if log_text.find(rune_name) < 0:
			missing.append(rune_name)
	ok(missing.is_empty(),
		"%s: runes absent from the roll call — %s" % [spec, ", ".join(missing)])

	OS.set_environment("DOD_AUTOPLAY", "")
	scene.queue_free()
	await process_frame


func _pass(mage_spec: String, cleric_spec: String) -> void:
	var specs := [mage_spec, cleric_spec]
	var label := "%s + %s" % [mage_spec, cleric_spec]
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var chosen := ["berserker", mage_spec, cleric_spec, "beastmaster"]
	var equipped := {}
	for i in run.party.size():
		run.party[i]["spec"] = chosen[i]
		run.party[i]["tree"] = Talents.generate_tree(chosen[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.sync_spec_hp(i)
		equipped[chosen[i]] = _equip_all(run.party[i])
	run.specs_chosen = true
	run.active = true
	# A FIRE-RESISTANT warband on the Pyromancer pass: rune_resist_pierce
	# only has anything to bite through against a positive resist, so a
	# raider lineup would leave its one read site unexercised.
	var lineup := ["raider", "archer", "raider"]
	if mage_spec == "pyromancer":
		# EVERY enemy resists fire (ashblade/hurler 0.5, shaman 0.25).
		# A mixed warband made this check a coin flip on which target the bot
		# happened to burn — it failed once for that reason, not for a real
		# regression. rune_resist_pierce has exactly one read site, so any
		# fire hit at all must now exercise it.
		# BATCH AH: the bog troll (300 HP) joins to LENGTHEN the fight. The
		# check reads a log line, so it is a race against how long the
		# battle lasts — and AH trimmed the Berserker's kit, which changed
		# that. It failed ~50% of runs for that reason alone (proven by
		# putting Blood Price back: 6/6 passes). A tankier warband removes
		# the race instead of leaving a flake that would hide a real one.
		lineup = ["ashblade", "hurler", "shaman"]
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}

	OS.set_environment("DOD_AUTOPLAY", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 12:
		await process_frame

	var heroes: Array = scene.get("heroes")
	var by_spec := {}
	for h in heroes:
		if not h.is_companion:
			by_spec[String(h.passive_id)] = h

	# ---- the runes reached the spawned hero ----
	for spec in specs:
		ok(not equipped[spec].is_empty(), "%s: nothing eligible to equip" % spec)
		ok(equipped[spec].size() == 4, "%s: equipped %d spec runes, expected 4" % [
			spec, equipped[spec].size()])

	if by_spec.has("inferno"):
		var py: Node = by_spec["inferno"]
		# White Flame's new field, and its ONLY read site's input.
		ok(py.rune_resist_pierce > 0.0, "pyromancer: rune_resist_pierce never applied")
		# Counter stacking: two runes both feed Inferno Master's step.
		ok(py.pyromaniac_ranks >= 1, "pyromancer: pyromaniac_ranks never applied")
		ok(py.cinder_trail_ranks >= 1, "pyromancer: cinder_trail_ranks never applied")
		# THE CHIP GOTCHA: the live passive readout must show the rune's
		# contribution, not the talent-only number.
		scene.call("_update_talent_chips")
		var chip := String(py.get_status("spec_passive").get("desc", ""))
		ok(chip.find("+%d%% damage for each burning" % (5 + py.pyromaniac_ranks)) >= 0,
			"pyromancer: the Inferno chip does not read the rune-boosted step (%s)" % chip)
	if by_spec.has("permafrost"):
		var cr: Node = by_spec["permafrost"]
		ok(cr.hypothermia_ranks >= 2, "cryomancer: hypothermia_ranks never applied")
		ok(cr.frigid_ranks >= 2, "cryomancer: two runes feeding frigid_ranks did not sum")
		# The ability-branch rune: Ice Lance actually got cheaper.
		var lance: Ability = null
		for ab in cr.abilities:
			if ab.display_name == "Ice Lance":
				lance = ab
		ok(lance != null, "cryomancer: Ice Lance is missing")
		if lance != null:
			ok(lance.cost == 20, "cryomancer: Ice Lance costs %d, expected 20" % lance.cost)
			ok(lance.damage == 40, "cryomancer: Ice Lance deals %d, expected 40" % lance.damage)
	if by_spec.has("mercy"):
		var hl: Node = by_spec["mercy"]
		# THE ORDERING FIX: zealous_mercy is DERIVED at spawn. Before Batch AA
		# it was read before runes applied and this was silently 0.
		ok(hl.second_resource >= 1,
			"holy: the Open Hand rune's starting Mercy was derived before it applied")
		ok(hl.speed < 85.0, "holy: the Sleepless Vigil speed cost never applied")
		var has_res := false
		for ab in hl.abilities:
			if ab.display_name == "Resurrection":
				has_res = true
		ok(has_res, "holy: the Last Rites rune granted no Resurrection")
	if by_spec.has("resonance"):
		var ar: Node = by_spec["resonance"]
		ok(ar.second_max >= 6,
			"arcanist: Resonant Core's ceiling was derived before the rune applied")
		ok(ar.mana_regen_bonus == 2,
			"arcanist: Unquiet Mind's Mana cost read %d, expected 2" % ar.mana_regen_bonus)
		var barrage: Ability = null
		for ab in ar.abilities:
			if ab.display_name == "Arcane Barrage":
				barrage = ab
		ok(barrage != null and barrage.random_hits == 7,
			"arcanist: Arcane Barrage fires %d bolts, expected 7" % (
				barrage.random_hits if barrage != null else -1))
	if by_spec.has("old_gods"):
		var oc: Node = by_spec["old_gods"]
		ok(oc.deep_hex_ranks >= 1, "occultist: deep_hex_ranks never applied")
		ok(oc.entropy_ranks >= 1, "occultist: entropy_ranks never applied")
		ok(oc.healing_received_mult < 1.15,
			"occultist: the Hollow Chalice healing cost never applied")
		var has_flay := false
		for ab in oc.abilities:
			if ab.display_name == "Mind Flay":
				has_flay = true
		ok(has_flay, "occultist: the Flayed Mind rune granted no Mind Flay")
	if by_spec.has("conviction"):
		var dv: Node = by_spec["conviction"]
		ok(dv.blessed_barrier_ranks >= 2,
			"devout: two runes feeding blessed_barrier_ranks did not sum")
		ok(dv.righteous_ranks >= 2, "devout: righteous_ranks never applied")

	# BATCH AH: the White Flame check below reads a LOG LINE, which made it a
	# race against how long the fight lasts — and AH trimmed the Berserker's
	# kit, so fights now sometimes end before the Pyromancer's FIRST turn
	# (measured: 0 fire casts in ~50% of runs; putting Blood Price back made
	# it 6/6 again). "The bot happened to get a turn" is not a thing a check
	# should depend on, so the hit is forced instead of hoped for. Every
	# enemy in this lineup resists fire, so any of them exercises the site.
	if mage_spec == "pyromancer" and by_spec.has("inferno"):
		var wf_py: BattleUnit = by_spec["inferno"]
		var wf_foes: Array = scene.get("enemies")
		if not wf_foes.is_empty():
			await scene._resolve(wf_py, wf_py.abilities[0], wf_foes[0], "good")

	# Let the fight actually run: a rune that crashes mid-battle is the
	# failure a spawn-time check cannot see. The roll call is logged when
	# _run_battle opens (after a real 0.6s beat), so the log is read after.
	for _i in 900:
		if scene.get("battle_over"):
			break
		await process_frame
	ok(true, "%s: battle ran without a script error" % label)

	# ---- the log names them, with the grep-stable tag ----
	var log_text := ""
	for rt in scene.find_children("*", "RichTextLabel", true, false):
		log_text += rt.get_parsed_text()
	ok(log_text.find("Rune: ") >= 0, "%s: no Rune: tag anywhere in the log" % label)
	if mage_spec == "pyromancer":
		# The White Flame's ONLY read site, proven live against a fire-
		# resistant warband rather than assumed from the source.
		ok(log_text.find("Rune: the flame bites through resistance") >= 0,
			"pyromancer: rune_resist_pierce never fired against a resistant warband")
	for spec in specs:
		var missing: Array = []
		for rune_name in equipped[spec]:
			if log_text.find("Rune: ") < 0 or log_text.find(rune_name) < 0:
				missing.append(rune_name)
		ok(missing.is_empty(),
			"%s: runes absent from the log — %s" % [spec, ", ".join(missing)])

	OS.set_environment("DOD_AUTOPLAY", "")
	scene.queue_free()
	await process_frame


# ================= Batch AD: the power arm, live =================
#
# scale_payload producing the right DICTIONARY is a data test; test_runes
# already does that 3,000 times. This is the other half — that a scaled
# payload survives the whole spawn pipeline and lands on the BattleUnit.
# The live-value gotcha has bitten twice now (a readout that ignores the
# rune's contribution), and the batch's entire conclusion rests on this arm
# actually doing something in a real fight rather than in a dictionary.
#
# Three fields, chosen because they are the three shapes the scaler
# distinguishes, and it must get all three right at once:
#   blood_pact        int, INVERTED — a negative value is the BENEFIT.
#                     Held by sign alone, which left the Rune of
#                     Exsanguination inert in every arm until Batch AD
#                     caught it. This is that bug's live regression guard.
#   crit_bonus        float, ordinary benefit — scales.
#   dmg_taken_bonus   float, a cost written as a POSITIVE number — held.
# Each is measured as a DELTA against a rune-free control, so the assertion
# does not care what the Berserker's base stat block happens to be.
func _power_arm_pass() -> void:
	var base := await _berserker_probe(0.0)   # no runes at all
	var x1 := await _berserker_probe(1.0)     # authored magnitudes
	var x3 := await _berserker_probe(3.0)     # the arm
	if base.is_empty() or x1.is_empty() or x3.is_empty():
		ok(false, "power arm: a probe battle never spawned the Berserker")
		return
	var d1_pact: float = x1["blood_pact"] - base["blood_pact"]
	var d3_pact: float = x3["blood_pact"] - base["blood_pact"]
	ok(is_equal_approx(d1_pact, -15.0),
		"power arm: Exsanguination gave %.1f blood_pact at x1, expected -15" % d1_pact)
	ok(is_equal_approx(d3_pact, -45.0),
		"power arm: blood_pact reached the unit as %.1f at x3, expected -45 — the "
		% d3_pact + "inverted benefit was held as a cost again")
	var d1_crit: float = x1["crit_bonus"] - base["crit_bonus"]
	var d3_crit: float = x3["crit_bonus"] - base["crit_bonus"]
	ok(is_equal_approx(d1_crit, 0.08),
		"power arm: the Glass Rune gave %.3f crit at x1, expected 0.08" % d1_crit)
	ok(is_equal_approx(d3_crit, 0.24),
		"power arm: crit reached the unit as %.3f at x3, expected 0.24" % d3_crit)
	var d1_taken: float = x1["dmg_taken_bonus"] - base["dmg_taken_bonus"]
	var d3_taken: float = x3["dmg_taken_bonus"] - base["dmg_taken_bonus"]
	ok(is_equal_approx(d1_taken, 0.15),
		"power arm: the Glass Rune cost %.3f at x1, expected 0.15" % d1_taken)
	ok(is_equal_approx(d3_taken, 0.15),
		"power arm: THE COST SCALED to %.3f — the arm is supposed to hold costs "
		% d3_taken + "at their authored value")
	# And the sanity floor: the arm must actually have moved SOMETHING.
	ok(not is_equal_approx(d1_crit, d3_crit),
		"power arm: x1 and x3 produced identical live stats — the arm is a no-op")


# Spawn a Berserker wearing Exsanguination + the Glass Rune with their
# payloads scaled by `mult` (0.0 = wear no runes at all), and read the three
# fields straight off the spawned unit.
func _berserker_probe(mult: float) -> Dictionary:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var chosen := ["berserker", "cryomancer", "holy", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = chosen[i]
		run.party[i]["tree"] = Talents.generate_tree(chosen[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		run.sync_spec_hp(i)
	if mult > 0.0:
		for id in ["exsanguination", "glass"]:
			var rune: Dictionary = Runes.build(id)
			rune["payload"] = Runes.scale_payload(rune["payload"], mult)
			rune["equipped"] = true
			run.party[0]["runes"].append(rune)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband",
		"enemies": ["raider", "archer"]}
	OS.set_environment("DOD_AUTOPLAY", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 12:
		await process_frame
	var out := {}
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.hero_key) == "warrior":
			out = {"blood_pact": float(h.blood_pact),
				"crit_bonus": h.crit_bonus,
				"dmg_taken_bonus": h.dmg_taken_bonus}
	scene.queue_free()
	await process_frame
	return out
