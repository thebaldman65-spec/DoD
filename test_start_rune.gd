# The starting rune (Batch AE) — stage 5 item 3.
#
# The whole batch is one acquisition change, so the checks that matter are
# about WHEN it is dealt and how many times, not about what it rolls. A
# second grant on a resumed run would be an invisible power creep that only
# showed up as a drifting Matrix row three batches later.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script res://_scratch/test_start_rune.gd
extends SceneTree

var checks := 0
var fails: Array = []

const SAVE_PATH := "user://run_save.bin"
const BACKUP_PATH := "user://run_save.ae_backup"


func _initialize() -> void:
	# Autoloads are NOT in the tree during _initialize (the Batch Z gotcha).
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	var run: Node = get_root().get_node("/root/Run")
	# This test writes real saves, so the player's own is put aside first
	# and restored at the end whatever happens (the test_run_summary
	# precedent — a test that eats a save is worse than no test).
	var had_save := FileAccess.file_exists(SAVE_PATH)
	if had_save:
		DirAccess.copy_absolute(SAVE_PATH, BACKUP_PATH)

	_grant_shape(run)
	_once_per_run(run)
	_save_load(run)
	_flag_off(run)
	_sim_policy(run)
	_purity(run)

	# Batch AF starts here. The AE subtotal is printed separately below so
	# "AE's checks still pass unchanged" stays a number anyone can read off
	# the output rather than a claim in a commit message.
	var ae_checks := checks
	var ae_fails := fails.size()
	_af_guarantee(run)
	_af_other_callers_unchanged(run)
	_af_fallback(run)
	_af_rarity_and_position(run)
	_af_flag(run)
	_af_modes(run)

	if had_save:
		DirAccess.copy_absolute(BACKUP_PATH, SAVE_PATH)
		DirAccess.remove_absolute(BACKUP_PATH)
	elif FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

	print("test_start_rune: AE %d checks / %d failures + AF %d checks / %d failures" % [
		ae_checks, ae_fails, checks - ae_checks, fails.size() - ae_fails])
	print("test_start_rune: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# A party built the way the spec screen builds one: heroes drafted, specs
# locked, trees generated. Nothing here may run before the spec exists —
# that is the entire reason the hook site is spec confirmation and not the
# draft.
func _awaken(run: Node, specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]) -> void:
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.sync_spec_hp(i)


# ---------- shape: one pick of three, per hero, spec-eligible ----------

func _grant_shape(run: Node) -> void:
	_awaken(run)
	var granted: int = run.grant_start_runes()
	ok(granted == 4, "grant_start_runes dealt %d picks, expected one per hero" % granted)
	ok(run.owed_rune_picks() == 4,
		"owed_rune_picks reads %d, expected 4" % run.owed_rune_picks())
	for m in run.party:
		var q: Array = m.get("rune_candidates", [])
		ok(q.size() == 1, "%s: %d triples queued, expected 1" % [m["key"], q.size()])
		ok(int(m.get("rune_picks_owed", 0)) == 1,
			"%s: owes %d picks, expected 1" % [m["key"], int(m.get("rune_picks_owed", 0))])
		ok(m.get("runes", []).is_empty(),
			"%s: the grant equipped a rune outright — it must be a PICK" % m["key"])
		var triple: Array = q[0]
		ok(triple.size() == 3, "%s: %d candidates, expected 3" % [m["key"], triple.size()])
		var names := {}
		for c in triple:
			names[String(c["name"])] = true
			ok(String(c.get("source", "")) == "start",
				"%s: candidate is not labelled source=start" % m["key"])
			# The roller's ordinary eligibility, not a new one: a candidate
			# scoped to another class or another spec would mean the start
			# pick had bypassed Runes.eligible_ids.
			var scope := String(c.get("scope", "universal"))
			var legal := scope == "universal" \
				or scope == "class:%s" % String(m["key"]) \
				or scope == "spec:%s" % String(m.get("spec", ""))
			ok(legal, "%s: candidate scoped %s is not eligible for this hero" % [
				m["key"], scope])
			var req := String(c.get("requires_ability", ""))
			ok(req == "" or Runes.kit_names(m).has(req),
				"%s: candidate requires an ability the hero cannot own (%s)" % [
					m["key"], req])
		ok(names.size() == 3, "%s: the triple contains a duplicate" % m["key"])


# ---------- exactly once per hero per run ----------

func _once_per_run(run: Node) -> void:
	_awaken(run)
	run.grant_start_runes()
	# Calling again is what a double-pressed Confirm, a re-entered spec
	# screen and the debug spec swap all look like from here.
	var second: int = run.grant_start_runes()
	ok(second == 0, "a second grant_start_runes dealt %d more picks" % second)
	ok(run.owed_rune_picks() == 4,
		"owed picks became %d after a repeat grant" % run.owed_rune_picks())
	for m in run.party:
		ok(m.get("rune_candidates", []).size() == 1,
			"%s: a repeat grant queued a second triple" % m["key"])

	# The debug spec swap clears specs and re-opens the spec screen; the
	# marker must survive it, because the run has already had its opening.
	for m in run.party:
		m["spec"] = ""
		m["talents"] = {}
		m["tree"] = []
	run.specs_chosen = false
	var third: int = run.grant_start_runes()
	ok(third == 0, "the debug spec swap dealt %d more starting picks" % third)

	# A genuinely fresh run gets a fresh opening — the marker is per-run
	# state, not a permanent lockout.
	_awaken(run)
	ok(not bool(run.party[0].get("start_rune_granted", false)),
		"new_run carried the granted marker into a fresh run")
	ok(run.grant_start_runes() == 4, "a fresh run did not get its opening pick")


# ---------- survives save/load, and is not re-dealt on resume ----------

func _save_load(run: Node) -> void:
	_awaken(run)
	run.grant_start_runes()
	var before: Array = []
	for m in run.party:
		before.append(String(m["rune_candidates"][0][0]["name"]))
	run.save_run()
	ok(run.has_save(), "save_run wrote nothing")

	# Wipe the live state and resume, exactly as Continue does.
	run.party = []
	run.active = false
	ok(run.load_run(), "load_run refused the save")
	ok(run.party.size() == 4, "the resumed run lost its party")
	for i in run.party.size():
		var m: Dictionary = run.party[i]
		ok(bool(m.get("start_rune_granted", false)),
			"%s: the granted marker did not survive the save round-trip" % m["key"])
		ok(int(m.get("rune_picks_owed", 0)) == 1,
			"%s: the owed pick did not survive the save round-trip" % m["key"])
		ok(m.get("rune_candidates", []).size() == 1,
			"%s: the queued triple did not survive the save round-trip" % m["key"])
		ok(String(m["rune_candidates"][0][0]["name"]) == String(before[i]),
			"%s: the candidates REROLLED across the save" % m["key"])
		ok(String(m["rune_candidates"][0][0].get("source", "")) == "start",
			"%s: the source label did not survive the save" % m["key"])
	# The resume beat itself: nothing on a resumed run may deal again.
	ok(run.grant_start_runes() == 0,
		"a resumed run was dealt a second opening pick")

	# A pre-AE save has no marker at all. It must not crash, and — because
	# the run it describes already started without one — it must not be
	# retro-fitted mid-run either. (Reaching the marker through .get is the
	# whole reason no save-version bump was needed.)
	for m in run.party:
		m.erase("start_rune_granted")
		m["rune_picks_owed"] = 0
		m["rune_candidates"] = []
	run.save_run()
	run.party = []
	ok(run.load_run(), "load_run refused a save with no AE marker")
	ok(not bool(run.party[0].get("start_rune_granted", false)),
		"a marker-less save invented a marker on load")
	run.clear_save()


# ---------- DOD_SIM_START_RUNE=off reproduces the pre-AE control ----------

func _flag_off(run: Node) -> void:
	ok(run.start_rune_enabled(),
		"start_rune_enabled is false with the env unset — AE ships ON by default")
	OS.set_environment("DOD_SIM_START_RUNE", "off")
	ok(not run.start_rune_enabled(), "DOD_SIM_START_RUNE=off did not disarm")
	_awaken(run)
	ok(run.grant_start_runes() == 0, "the off flag still dealt an opening pick")
	ok(run.owed_rune_picks() == 0, "the off flag left an owed pick behind")
	for m in run.party:
		ok(m.get("runes", []).is_empty(), "the off flag still handed out a rune")
		ok(not bool(m.get("start_rune_granted", false)),
			"the off flag still set the granted marker")
	# UNLIKE Batch AD's two arms this one is NOT gated on sim_run: it is
	# shipped content, and a control row has to be reachable from a real
	# run or the whole comparison is unreproducible.
	var had_sim: bool = run.sim_run
	run.sim_run = false
	ok(not run.start_rune_enabled(),
		"the off flag is gated on sim_run — it must work in real play too")
	run.sim_run = had_sim
	OS.set_environment("DOD_SIM_START_RUNE", "")
	ok(run.start_rune_enabled(), "clearing the env did not re-arm the default")

	# Runes off entirely: nothing to deal, and no owed pick pointing at an
	# empty queue (which is the shape that would hang the Party screen).
	OS.set_environment("DOD_SIM_RUNES", "off")
	_awaken(run)
	ok(run.grant_start_runes() == 0, "DOD_SIM_RUNES=off still dealt a pick")
	ok(run.owed_rune_picks() == 0, "DOD_SIM_RUNES=off left an owed pick with no candidates")
	OS.set_environment("DOD_SIM_RUNES", "")


# ---------- the sim resolves it through the existing policy ----------

func _sim_policy(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.sim_run = true
	_awaken(run)
	RunSim._resolve_start_runes(run)
	for m in run.party:
		ok(int(m.get("rune_picks_owed", 0)) == 0,
			"%s: the sim left its opening pick unresolved" % m["key"])
		ok(m.get("rune_candidates", []).is_empty(),
			"%s: the sim left a triple in the queue" % m["key"])
		var worn: Array = m.get("runes", [])
		ok(worn.size() == 1, "%s: the sim resolved to %d runes, expected 1" % [
			m["key"], worn.size()])
		if worn.is_empty():
			continue
		# Two slots are open at run start, so the opening rune always lands
		# WORN — an unworn one would mean the sim measured a rune nobody
		# was wearing.
		ok(bool(worn[0].get("equipped", false)),
			"%s: the sim's opening rune was pouched, not worn" % m["key"])
		ok(String(worn[0].get("source", "")) == "start",
			"%s: the resolved rune lost its source label" % m["key"])
	# Resolving twice must be a no-op, not a second rune.
	RunSim._resolve_start_runes(run)
	ok(run.party[0].get("runes", []).size() == 1,
		"a second sim resolution handed out another rune")
	run.sim_run = had_sim


# ==================== Batch AF ====================
#
# AE shipped the opening pick and measured that the ordinary roller put a
# spec-scoped rune among the three only 36-42% of the time. AF guarantees
# one. The checks below are about the guarantee HOLDING and about it
# reaching nothing else — the second half matters more, because the roller
# is shared with the elite cache and a change that leaked into it would be
# invisible until a Matrix row drifted three batches from now.

const ROLLS := 250  # per spec, per assertion — enough that a 42% hole shows


# A bare member of the right class for a spec, the shape the roller reads.
func _member_for(spec: String) -> Dictionary:
	for key in Classes.SPEC_IDS:
		if spec in Classes.SPEC_IDS[key]:
			return {"key": key, "spec": spec, "runes": [], "bm_abilities": []}
	return {}


func _has_spec_rune(triple: Array, spec: String) -> bool:
	for c in triple:
		if String(c.get("scope", "")) == "spec:%s" % spec:
			return true
	return false


# ---------- 1. the guarantee holds, for ALL TWELVE specs ----------
#
# All twelve, not the four a fixed party happens to draw: the eight the
# default party never rolls are exactly the ones a regression would hide in.

func _af_guarantee(run: Node) -> void:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var m := _member_for(spec)
			var hits := 0
			var distinct := 0
			var legal := 0
			for i in ROLLS:
				var triple: Array = run.roll_rune_candidates(m, true)
				if _has_spec_rune(triple, spec):
					hits += 1
				var names := {}
				for c in triple:
					names[String(c["name"])] = true
				if names.size() == 3:
					distinct += 1
				if _triple_legal(triple, m):
					legal += 1
			ok(hits == ROLLS, "%s: %d of %d guaranteed triples held no spec rune" % [
				spec, ROLLS - hits, ROLLS])
			ok(distinct == ROLLS, "%s: %d guaranteed triples contained a duplicate" % [
				spec, ROLLS - distinct])
			ok(legal == ROLLS, "%s: %d guaranteed triples held an ineligible candidate" % [
				spec, ROLLS - legal])

	# And end to end, through the shipped path rather than the roller alone:
	# three rotated parties cover all twelve specs as grant_start_runes
	# actually deals them.
	for n in 3:
		var specs: Array = Classes.rotated_specs(n)
		_awaken(run, specs)
		run.grant_start_runes()
		for m in run.party:
			var q: Array = m.get("rune_candidates", [])
			ok(q.size() == 1, "%s: no triple queued" % String(m.get("spec", "")))
			if q.is_empty():
				continue
			ok(_has_spec_rune(q[0], String(m["spec"])),
				"%s: the dealt opening triple held no spec rune" % String(m["spec"]))


func _triple_legal(triple: Array, m: Dictionary) -> bool:
	if triple.size() != 3:
		return false
	var kit: Array = Runes.kit_names(m)
	for c in triple:
		var scope := String(c.get("scope", "universal"))
		var okay := scope == "universal" \
			or scope == "class:%s" % String(m["key"]) \
			or scope == "spec:%s" % String(m.get("spec", ""))
		if not okay:
			return false
		var req := String(c.get("requires_ability", ""))
		if req != "" and not kit.has(req):
			return false
	return true


# ---------- 2. nothing else moved ----------
#
# The direct assertion the brief asked for, and it has to be direct: the
# roll is random, so "it looks the same" proves nothing. Seeding the global
# RNG makes the sequence reproducible, and the comparison runs against a
# VERBATIM copy of the default loop written out below — if the default path
# consumed one extra random number, or consumed them in a different order,
# these diverge.
#
# THE REFERENCE WAS RE-TRANSCRIBED (Batch AI). It used to be a copy of the
# PRE-AF loop, which rolled and retried on a collision and then appended the
# fourth result UNCHECKED — so on a small per-rarity pool it emitted the
# same rune twice, about one triple in a hundred. That is now fixed by
# drawing without replacement, which necessarily changes the default path:
# fewer random numbers (no wasted retries) and a smaller pool for draws 2
# and 3. Freezing the old copy here would have meant asserting the bug had
# to stay forever, so the reference moved with the fix and the distinctness
# assertion below is new — it is the check whose absence let the bug live
# on this path unseen while the guaranteed path caught it intermittently.

func _default_roll(run: Node, member: Dictionary) -> Array:
	var out: Array = []
	for i in 3:
		var taken: Array = []
		for c in out:
			taken.append(String(c["name"]))
		var rune: Dictionary = run.generate_rune(member, taken)
		if rune.is_empty():
			return []
		out.append(rune)
	return out


func _af_other_callers_unchanged(run: Node) -> void:
	for spec in ["berserker", "cryomancer", "inquisitor", "beastmaster", "holy", "mystic"]:
		var m := _member_for(spec)
		var after: Array = []
		seed(20260804)
		for i in 40:
			after.append(run.roll_rune_candidates(m))
		var before: Array = []
		seed(20260804)
		for i in 40:
			before.append(_default_roll(run, m))
		var same := true
		var distinct := 0
		for i in before.size():
			var a: Array = before[i]
			var b: Array = after[i]
			var names := {}
			for c in b:
				names[String(c["name"])] = true
			if names.size() == b.size():
				distinct += 1
			if a.size() != b.size():
				same = false
				break
			for j in a.size():
				if String(a[j]["name"]) != String(b[j]["name"]):
					same = false
					break
		ok(same, "%s: the default roll diverged from its written-out reference on a shared seed" % spec)
		# The default path deduped by retry-and-hope until Batch AI and had
		# no assertion of its own; only the guaranteed path's zero-tolerance
		# check ever caught it, and only sometimes.
		ok(distinct == after.size(), "%s: %d default triples contained a duplicate" % [
			spec, after.size() - distinct])

	# The elite cache is the caller that matters, so assert it AT ITS CALL
	# SITES rather than trusting the default. A future batch adding a bare
	# `true` here is the one edit that would break this batch's promise.
	for path in ["res://scripts/run_sim.gd", "res://scripts/battle.gd"]:
		var src := FileAccess.get_file_as_string(path)
		ok(src.find("roll_rune_candidates(looter)") > -1,
			"%s no longer calls roll_rune_candidates(looter) with no guarantee" % path)
		ok(src.find("roll_rune_candidates(looter, true") < 0,
			"%s arms the spec guarantee on the ELITE CACHE" % path)
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(rs.find("func roll_rune_candidates(member: Dictionary, guarantee_spec := false)") > -1,
		"the guarantee parameter is no longer opt-in and defaulted OFF")
	# Exactly one caller may arm it, and it is the opening pick.
	ok(rs.count("roll_rune_candidates(member, spec_opening_enabled())") == 1,
		"the opening pick is not the only caller arming the guarantee")


# ---------- 3. the fallback path, FORCED ----------
#
# Waiting for an empty spec subset to happen would be waiting forever —
# every spec has four entries today and the only gates on them are core kit
# abilities. Both reachable shapes are forced instead.

func _af_fallback(run: Node) -> void:
	# (a) the realistic one: the hero already owns all four of their spec's
	# runes, so eligible_ids filters the whole subset out.
	var m := _member_for("berserker")
	var owned: Array = []
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) == "spec:berserker":
			owned.append(Runes.build(id))
	ok(owned.size() == 4, "expected 4 berserker spec runes, found %d" % owned.size())
	m["runes"] = owned
	ok(Runes.generate_spec(m, 1).is_empty(),
		"generate_spec found an entry in a subset the hero has exhausted")
	_assert_fallback_triple(run, m, "berserker", "owned-out spec subset")

	# (b) the defensive one: a member with no spec at all. Unreachable from
	# the shipped call site (the pick is dealt at spec confirmation) and
	# asserted anyway, because "unreachable" is what every save-shape bug
	# was called first.
	var bare := {"key": "warrior", "spec": "", "runes": [], "bm_abilities": []}
	ok(Runes.generate_spec(bare, 1).is_empty(),
		"generate_spec invented a rune for a member with no spec")
	_assert_fallback_triple(run, bare, "", "member with no spec")


func _assert_fallback_triple(run: Node, m: Dictionary, spec: String, label: String) -> void:
	var full := 0
	var distinct := 0
	var clean := 0
	var leaked := 0
	for i in 60:
		var triple: Array = run.roll_rune_candidates(m, true)
		if triple.size() == 3:
			full += 1
		var names := {}
		var all_named := true
		for c in triple:
			names[String(c.get("name", ""))] = true
			if String(c.get("name", "")) == "" or not c.has("payload"):
				all_named = false
		if names.size() == 3:
			distinct += 1
		if all_named:
			clean += 1
		if spec != "" and _has_spec_rune(triple, spec):
			leaked += 1
	ok(full == 60, "%s: %d fallback rolls were not three candidates" % [label, 60 - full])
	ok(distinct == 60, "%s: %d fallback rolls contained a duplicate" % [label, 60 - distinct])
	ok(clean == 60, "%s: %d fallback rolls held a malformed candidate" % [label, 60 - clean])
	ok(leaked == 0, "%s: the fallback produced a spec rune it had no pool for" % label)


# ---------- 4. rarity weighting inside the subset is not bypassed ----------
#
# The guaranteed candidate is an ORDINARY roll that happens to draw from a
# smaller pool, not a forced Epic. The four specs that own an epic are the
# only place this is observable, and it is observable sharply: a bypass
# would pin them at 100% Epic, a forced-common would pin them at 0%.

func _af_rarity_and_position(run: Node) -> void:
	for spec in ["berserker", "pyromancer", "holy", "occultist"]:
		var m := _member_for(spec)
		var epics := 0
		var n := 600
		for i in n:
			var r: Dictionary = Runes.generate_spec(m, 1)
			if String(r.get("rarity", "")) == "Epic":
				epics += 1
		var pct := 100.0 * epics / n
		ok(pct > 8.0 and pct < 45.0,
			"%s: the guaranteed candidate is %.0f%% Epic — a uniform draw over its four is ~25%%" % [
				spec, pct])

	# Never a generated stat stick: filler would satisfy the guarantee's
	# letter and defeat the thing it exists for.
	var sticks := 0
	for spec in ["warden", "arcanist", "mystic"]:
		var m2 := _member_for(spec)
		for i in 200:
			var r2: Dictionary = Runes.generate_spec(m2, 1)
			if String(r2.get("id", "")).begins_with("tpl_") or r2.is_empty():
				sticks += 1
	ok(sticks == 0, "%d guaranteed candidates were stat sticks or empty" % sticks)

	# The guaranteed rune must not always sit in slot 1 — a fixed position
	# turns a real choice into a positional tell.
	var seen := {0: 0, 1: 0, 2: 0}
	var m3 := _member_for("swordmaster")
	for i in 300:
		var triple: Array = run.roll_rune_candidates(m3, true)
		for j in triple.size():
			if String(triple[j].get("scope", "")) == "spec:swordmaster":
				seen[j] = int(seen[j]) + 1
				break
	for j in 3:
		ok(int(seen[j]) > 30,
			"the guaranteed rune landed in slot %d only %d times of 300 — position is a tell" % [
				j, int(seen[j])])


# ---------- 5. the flag ----------

func _af_flag(run: Node) -> void:
	ok(run.spec_opening_enabled(),
		"spec_opening_enabled is false with the env unset — AF ships ON by default")
	OS.set_environment("DOD_SIM_SPEC_OPENING", "off")
	ok(not run.spec_opening_enabled(), "DOD_SIM_SPEC_OPENING=off did not disarm")
	# Off means AE's opening, NOT no opening: the starting rune still ships.
	_awaken(run)
	ok(run.grant_start_runes() == 4,
		"the AF off flag suppressed the starting rune itself — it must only drop the guarantee")
	var offered := 0
	var with_spec := 0
	for n in 40:
		_awaken(run, Classes.rotated_specs(n))
		run.grant_start_runes()
		for m in run.party:
			var q: Array = m.get("rune_candidates", [])
			if q.is_empty():
				continue
			offered += 1
			if _has_spec_rune(q[0], String(m["spec"])):
				with_spec += 1
	var rate := 100.0 * with_spec / maxf(float(offered), 1.0)
	ok(rate > 15.0 and rate < 70.0,
		"with the guarantee off the offer rate read %.0f%% — AE measured 36-42%%" % rate)

	# Shipped content, so it is NOT gated on sim_run: a control a real build
	# cannot reach is a control nobody can reproduce.
	var had_sim: bool = run.sim_run
	run.sim_run = false
	ok(not run.spec_opening_enabled(),
		"the AF flag is gated on sim_run — it must work in real play too")
	run.sim_run = had_sim
	OS.set_environment("DOD_SIM_SPEC_OPENING", "")
	ok(run.spec_opening_enabled(), "clearing the env did not re-arm the default")


# ---------- 6. the guarantee is a no-op where there is no authored pool ----------

func _af_modes(run: Node) -> void:
	var m := _member_for("cryomancer")
	OS.set_environment("DOD_SIM_RUNES", "stats")
	ok(run._generate_spec_rune(m).is_empty(),
		"DOD_SIM_RUNES=stats still seeded an authored spec rune")
	var triple: Array = run.roll_rune_candidates(m, true)
	ok(triple.size() == 3, "stats mode returned %d candidates under the guarantee" % triple.size())
	var all_sticks := true
	for c in triple:
		if not String(c.get("id", "")).begins_with("tpl_"):
			all_sticks = false
	ok(all_sticks, "stats mode leaked an authored rune through the guarantee")

	OS.set_environment("DOD_SIM_RUNES", "off")
	ok(run._generate_spec_rune(m).is_empty(), "DOD_SIM_RUNES=off still seeded a spec rune")
	ok(run.roll_rune_candidates(m, true).is_empty(),
		"DOD_SIM_RUNES=off returned candidates under the guarantee")
	OS.set_environment("DOD_SIM_RUNES", "")


# ---------- purity: a sim party never reaches the real save ----------

func _purity(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.clear_save()
	run.sim_run = true
	_awaken(run)
	run.grant_start_runes()
	RunSim._resolve_start_runes(run)
	run.save_run()
	ok(not run.has_save(),
		"a sim_run party's opening rune reached user://run_save.bin")
	run.sim_run = had_sim
