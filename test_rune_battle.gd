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

var _pierce_log := ""
var _pierce_why := ""


# BATCH DF §0 — THE SEED, AND WHY IT IS PER-SITE RATHER THAN PER-SUITE.
# `check_de` found this suite failing 2 in 15 with a rock-steady check count of
# 97, which is the flake signature: only the White Flame check moves. It calls
# `seed()` zero times, so every run draws a different stream.
#
# THE SEED GOES IMMEDIATELY BEFORE THE FORCED HIT AND NOWHERE ELSE — the
# AT/AV/BS/BT idiom of forcing determinism at the site under test rather than
# widening a tolerance until the noise fits. Seeding the whole suite would have
# fixed the draw for 96 other checks that never asked for it, which is the
# widening this project refuses; it would also have hidden WHICH draw mattered.
#
# AND IT IS A DIAGNOSTIC AS MUCH AS A FIX. The assertion's own comment says its
# snapshot "is the one that cannot race", so if this still reds when seeded the
# cause is NOT the draw and `_pierce_why` below says what it was instead —
# which is the reading Batch DF wanted and could not get by looking at source.
func _seeded() -> void:
	seed(20260822)
var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


# BATCH EM — WHAT A RE-KEYED COUNTER READS AS NOW. The charter took the runes
# off the talent trees, so 56 clauses write `rune_X` instead of the node's `X`
# and every read site in the game sums the pair. **The question each check
# below asks did not move** — did the rune's value reach this hero? — so they
# ask it of the pair, which is the number the game itself reads. A check left
# reading `X` alone on a rune-only hero reads ZERO and passes nothing, which is
# the same silent dud DP's Whispering Dark case was.
func _paid(u: Node, field: String) -> float:
	return float(u.get(field)) + float(u.get("rune_" + field))


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


# Every rune AUTHORED for this spec, all equipped at once — the harshest
# version of "does it apply", and the one that would expose a payload branch
# clobbering another.
#
# **BATCH EO §3 — THIS WALKS `Runes.ids()`, NOT `eligible_ids`, AND THE
# DISTINCTION IS THE WHOLE POINT.** Twelve runes are retired: kept in
# `runes.json`, still resolved by `config` / `build`, and simply never OFFERED.
# Walking the offer pool stops testing all twelve on the day they are retired —
# the Deepening Ruin's Break tick, the Deep Sight's Focus conversion and ten
# more. **IT DOES NOT FAIL SILENTLY, AND EO's NEGATIVE CONTROL CORRECTED THIS
# COMMENT'S FIRST DRAFT ON EXACTLY THAT POINT: armed, it reads 17 failures**,
# because the assertions below name specific runes and specific values. **The
# hazard is the REPAIR.** There are two ways to get the file green again — walk
# the authored set, or delete those twelve runes' clause assertions — and the
# second is the silent one, the smaller diff, and the same shape as the repair
# EO made in `test_runes._rich_grant` one file over. **A retired rune is kept so
# a later batch can point something at it again, and kept content that nothing
# drives is content that rots.**
# WHETHER a rune is offered is `test_runes`' question and it is asserted there
# in both directions; whether its clauses PAY is this file's, and that question
# is unchanged by the retirement.
func _equip_all(member: Dictionary) -> Array:
	var names: Array = []
	var want := "spec:%s" % String(member.get("spec", ""))
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) != want:
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
			# BATCH AY RE-POINTED THESE IN PLACE — the counters went additive
			# and `wild_communion_ranks` became the FLOAT `wild_communion_step`
			# (the Deep Bond and the Shared Wild each pay 1.5, so they sum to
			# 3.0). The question each check asks is unchanged.
			ok(abs(_paid(hunter, "wild_communion_step") - 3.0) < 0.001,
				"beastmaster: two runes feeding wild_communion_step did not sum (%s)" % \
					str(_paid(hunter, "wild_communion_step")))
			# The Devout's field is `communion_ranks`; writing that one would be
			# a silent dud that also buffs another class.
			ok(hunter.get("communion_ranks") == 0,
				"beastmaster: a rune wrote communion_ranks — that is the DEVOUT's field")
			ok(_paid(hunter, "momentum_ranks") >= 16,
				"beastmaster: momentum_ranks read %d, expected 8+8" % \
					int(_paid(hunter, "momentum_ranks")))
			# The Deep Bond's ceiling clause had no meaning left once Batch AY
			# uncapped Loyalty, so it was RE-POINTED at the boon's own step
			# rather than deleted. The rune must still pay something.
			ok(abs(_paid(hunter, "absolute_step") - 3.0) < 0.001,
				"beastmaster: absolute_step read %s — the re-pointed Deep Bond is a dud" % \
					str(_paid(hunter, "absolute_step")))
			ok(_paid(hunter, "masters_aim_ranks") >= 12,
				"beastmaster: masters_aim_ranks read %d, expected 12" % \
					int(_paid(hunter, "masters_aim_ranks")))
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
			# RE-POINTED BY BATCH AY, with the reason in the file: §2 gave
			# Loyalty NO ceiling, so the old "the rune raised it to 6" check
			# is asserting a design that no longer exists. The question worth
			# asking now is the inverse — that nothing derives a ceiling for a
			# hunter no node has given one to.
			ok(scene.call("_loyalty_cap", hunter) == scene.get("LOYALTY_UNCAPPED"),
				"beastmaster: a Loyalty ceiling of %d was derived — Batch AY removed the ceiling" % \
					scene.call("_loyalty_cap", hunter))
		"sharpshooter":
			# THE ORDERING FIX, live: what a rune writes must be derived from
			# cfg AFTER the rune pass. Before Batch AA it was read before.
			# RE-POINTED BY BATCH AZ, with the reason in the file and the same
			# treatment AY gave the Beastmaster block above: §1 gave Focus NO
			# ceiling, so "the rune raised the cap to 150" asserts a design that
			# no longer exists. THE QUESTION IS INVERTED — nothing may derive a
			# ceiling for a marksman no node has given one to — and the ordering
			# rule is still tested live by the OPENING VALUE, which the Rune of
			# the Long Draw still writes into cfg.
			ok(hunter.second_max == scene.get("FOCUS_UNCAPPED"),
				"sharpshooter: a Focus ceiling of %d was derived — Batch AZ removed the ceiling" % \
					hunter.second_max)
			ok(hunter.second_resource == 60,
				"sharpshooter: opened on %d Focus — the Long Draw was derived too early" % \
					hunter.second_resource)
			# The counters went ADDITIVE in Batch AZ, so these read magnitudes
			# rather than rank counts: the Deep Sight's +20 Focus a crit, and
			# 12 apiece from the Narrow Gap and the Level Aim.
			ok(_paid(hunter, "perfect_form") >= 20,
				"sharpshooter: perfect_form read %d — the Deep Sight pays 20" % \
					int(_paid(hunter, "perfect_form")))
			ok(hunter.pierce_bonus > 0.11,
				"sharpshooter: two runes feeding pierce_bonus did not sum (%.2f)" % \
					hunter.pierce_bonus)
			ok(_paid(hunter, "bonecracker_ranks") >= 24,
				"sharpshooter: bonecracker_ranks read %d — two runes pay 12 each" % \
					int(_paid(hunter, "bonecracker_ranks")))
			ok(_paid(hunter, "muscle_memory_ranks") >= 20,
				"sharpshooter: muscle_memory_ranks read %d — two runes pay 10 each" % \
					int(_paid(hunter, "muscle_memory_ranks")))
			ok(_paid(hunter, "deep_focus") >= 8,
				"sharpshooter: the Deep Sight's re-pointed clause never applied (%d)" % \
					int(_paid(hunter, "deep_focus")))
			ok(hunter.speed < 100.0,
				"sharpshooter: the Long Draw speed cost never applied (%.1f)" % hunter.speed)
		"mystic":
			ok(_paid(hunter, "potent_ranks") >= 3,
				"survivalist: two runes feeding potent_ranks did not sum (%d)" % \
					int(_paid(hunter, "potent_ranks")))
			ok(_paid(hunter, "coated_blades") >= 1, "survivalist: coated_blades never applied")
			ok(_paid(hunter, "vulture") >= 1, "survivalist: vulture never applied")
			ok(_paid(hunter, "scavenger_ranks") >= 2,
				"survivalist: scavenger_ranks read %d" % int(_paid(hunter, "scavenger_ranks")))
			ok(_paid(hunter, "cruel_ranks") >= 1 and _paid(hunter, "wire_ranks") >= 1,
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

	# RE-POINTED IN BATCH AR, and this is the standing 91/1 defect closing.
	# The old block asserted the INFERNO MASTER chip against a string Batch AG
	# had already changed ("+N% damage for each burning enemy" became a
	# per-burn-TURN readout), so it failed on unmodified HEAD from AK onward.
	# Batch AR replaced the passive outright, so the check is re-pointed at
	# OVERBURN rather than deleted: the question it was really asking — does
	# the live chip read live state, or a stale snapshot — is still worth
	# asking, and is asked here of the new passive.
	if by_spec.has("overburn"):
		var py: Node = by_spec["overburn"]
		# White Flame's own field, and its ONLY read site's input.
		ok(py.rune_resist_pierce > 0.0, "pyromancer: rune_resist_pierce never applied")
		# The write still LANDS (an unknown field name would be dropped in
		# silence) — but nothing reads it. Overburn has no per-turn step to
		# raise, so the White Flame's middle clause is INERT and flagged for
		# re-authoring; see Batch AR §4. This assertion is the flag.
		ok(py.pyromaniac_ranks >= 1,
			"pyromancer: pyromaniac_ranks never applied (the write must still land)")
		# The Rune of the Cinder Trail was RE-POINTED when the node took
		# cinder_trail_ranks for a new meaning; it rides its own term now.
		ok(py.rune_cinder_ember >= 1,
			"pyromancer: rune_cinder_ember never applied (the re-point)")
		# THE CHIP GOTCHA, re-pointed: the live passive readout must show the
		# field as it stands NOW — both halves of the trade, the bonus and the
		# drain — not a value snapshotted at spawn.
		# One enemy, then put the field back exactly as it was: the White
		# Flame check further down forces a hit into this same live battle,
		# and a probe that leaves the board changed is a probe that breaks
		# the next assertion instead of the code.
		var lit_foe: BattleUnit = null
		for foe in scene.get("enemies"):
			if not foe.dead and not foe.has_status("burn"):
				lit_foe = foe
				break
		if lit_foe != null:
			scene.call("_apply_status", lit_foe, "burn", 3, 0, 6)
		var lit: int = scene.call("_total_burn_turns")
		scene.call("_update_talent_chips")
		var chip := String(py.get_status("spec_passive").get("desc", ""))
		ok(chip.find("Overburn") >= 0,
			"pyromancer: the passive chip does not name Overburn (%s)" % chip)
		ok(lit > 0 and chip.find("+%d%%" % (lit * 2)) >= 0,
			"pyromancer: the chip does not read the LIVE bonus (%s)" % chip)
		# RE-POINTED IN PLACE BY BATCH BS §2, AND IT IS AN INVERSION. Batch AR
		# re-pointed this check FROM the old Inferno chip AT Overburn's drain,
		# because the question it was really asking is whether the chip reads
		# LIVE state rather than a number stamped once. THERE IS NO DRAIN — it
		# is deleted, not zeroed — so the same question is asked of what the
		# chip must NOT say: a term that no longer exists.
		ok(chip.find("Mana a turn") < 0 and chip.find("-%d Mana" % lit) < 0,
			"pyromancer: the chip still advertises a drain that no longer exists (%s)" % chip)
		ok(chip.find("refunds Mana") >= 0,
			"pyromancer: the chip does not state the surviving refund clause (%s)" % chip)
		if lit_foe != null:
			lit_foe.remove_status("burn")
	if by_spec.has("permafrost"):
		var cr: Node = by_spec["permafrost"]
		ok(_paid(cr, "hypothermia_ranks") >= 2, "cryomancer: hypothermia_ranks never applied")
		ok(_paid(cr, "frigid_ranks") >= 2, "cryomancer: two runes feeding frigid_ranks did not sum")
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
		# RE-POINTED IN PLACE BY BATCH AX, with the reason here: the Occultist's
		# counters went ADDITIVE, so the Deepening Ruin writes a magnitude rather
		# than a rank — 1 percentage point per Ruin stack and 5 Break damage a
		# turn, which is EXACTLY what the rune paid before the batch.
		ok(_paid(oc, "deep_hex_step") == 1,
			"occultist: the Deepening Ruin pays %d%% per stack, expected 1" % \
				int(_paid(oc, "deep_hex_step")))
		# RE-POINTED IN PLACE AT BATCH ER, with the reason here: EN §1 moved this
		# clause onto a rune-owned field (`rune_entropy_ranks`) and the drip's
		# EXISTING tick sums the pair — `battle.gd`'s Entropy read is
		# `ent_occ.entropy_ranks + ent_occ.rune_entropy_ranks`. This line still
		# read the NODE's counter alone, which the rune correctly stopped
		# writing, so it had been RED on every run since EN and its failure was
		# hiding inside this file's `fails: [0, 1]` flake band. The sibling
		# clause one line above was re-pointed through `_paid()` and this one
		# was not. Same question, asked against the field that now carries it.
		ok(_paid(oc, "entropy_ranks") == 5,
			"occultist: the Deepening Ruin grinds %d Break damage, expected 5" % \
				int(_paid(oc, "entropy_ranks")))
		ok(_paid(oc, "soul_leech_step") == 3 and _paid(oc, "gluttony_ranks") == 3,
			"occultist: the Hollow Chalice pays %d/%d per stack, expected 3/3" % [
				int(_paid(oc, "soul_leech_step")), int(_paid(oc, "gluttony_ranks"))])
		ok(oc.healing_received_mult < 1.15,
			"occultist: the Hollow Chalice healing cost never applied")
		var has_flay := false
		for ab in oc.abilities:
			if ab.display_name == "Mind Flay":
				has_flay = true
		ok(has_flay, "occultist: the Flayed Mind rune granted no Mind Flay")
	if by_spec.has("conviction"):
		var dv: Node = by_spec["conviction"]
		# RE-POINTED IN PLACE BY BATCH AW, with the reason here: the Devout's
		# counters went ADDITIVE, so the two runes feeding Blessed Barrier now
		# write 4 apiece (4% of absorbs each) rather than a rank each, and
		# Righteous Fire's counter is `righteous_step` — the INCREASE on the
		# ground's base 10%, which is what the Burning Censer's advertised
		# "reflects 10% more" means. Same question, current units.
		ok(_paid(dv, "blessed_barrier_ranks") >= 8,
			"devout: two runes feeding blessed_barrier_ranks did not sum")
		ok(_paid(dv, "righteous_step") >= 10, "devout: righteous_step never applied")

	# BATCH AH: the White Flame check below reads a LOG LINE, which made it a
	# race against how long the fight lasts — and AH trimmed the Berserker's
	# kit, so fights now sometimes end before the Pyromancer's FIRST turn
	# (measured: 0 fire casts in ~50% of runs; putting Blood Price back made
	# it 6/6 again). "The bot happened to get a turn" is not a thing a check
	# should depend on, so the hit is forced instead of hoped for. Every
	# enemy in this lineup resists fire, so any of them exercises the site.
	if mage_spec == "pyromancer" and by_spec.has("overburn"):
		var wf_py: BattleUnit = by_spec["overburn"]
		# A LIVING target: by this point the autoplay battle has been running,
		# and a hit onto a corpse exercises nothing.
		var wf_foes: Array = scene.get("enemies").filter(func(e): return not e.dead)
		ok(not wf_foes.is_empty(), "pyromancer: no living enemy left to force a hit onto")
		if not wf_foes.is_empty():
			var wf_tgt: BattleUnit = wf_foes[0]
			var wf_ab: Ability = wf_py.abilities[0]
			# BANKED BEFORE THE HIT, because a failure has to be able to say
			# which precondition was missing. Every one of these is a read.
			_pierce_why = (" [forced hit: over=%s py_dead=%s tgt=%s hp=%d/%d dead=%s"
				+ " type=%s resist=%.2f pierce=%.2f]") % [
					str(scene.get("battle_over")), str(wf_py.dead),
					wf_tgt.unit_name, wf_tgt.hp, wf_tgt.max_hp, str(wf_tgt.dead),
					String(wf_ab.dmg_type),
					float(wf_tgt.resists.get(wf_ab.dmg_type, 0.0)),
					wf_py.rune_resist_pierce]
			_seeded()
			await scene._resolve(wf_py, wf_ab, wf_tgt, "good")
			# SNAPSHOT THE LOG HERE, not after the fight. Reading it 900 frames
			# later made this a race against how long the battle runs, which is
			# exactly the flake Batch AH thought it had closed by forcing the
			# hit: forcing fixed WHETHER the line is written, not whether it
			# survives to be read. The forced hit is the proof, so it is read
			# the moment it happens.
			for rt in scene.find_children("*", "RichTextLabel", true, false):
				_pierce_log += rt.get_parsed_text()

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
		# resistant warband rather than assumed from the source. Read off the
		# snapshot taken at the forced hit (see above) OR the final log —
		# either is proof, and the snapshot is the one that cannot race.
		ok(_pierce_log.find("Rune: the flame bites through resistance") >= 0
			or log_text.find("Rune: the flame bites through resistance") >= 0,
			"pyromancer: rune_resist_pierce never fired against a resistant warband"
				+ _pierce_why)
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
