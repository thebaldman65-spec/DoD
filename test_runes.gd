# Rune schema + coverage audit (Batch X, extended in Batch AA, AB and AD).
#
# The valuable part is the DRIFT ALARMS, not the schema checks: an authored
# rune that names a field nothing reads, or an ability the hero cannot own,
# applies cleanly and does NOTHING — the player paid for a blank. Every
# check here exists because that failure is silent.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script res://_scratch/test_runes.gd
extends SceneTree

var checks := 0
var fails: Array = []


func _initialize() -> void:
	# GOTCHA (Batch Z, re-hit): autoloads are NOT in the tree during
	# _initialize — park on the first process_frame before touching them.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	var data := {}
	for id in Runes.ids():
		data[id] = Runes.config(id)

	var unit_src := FileAccess.open("res://scripts/unit.gd",
		FileAccess.READ).get_as_text()
	var battle_src := FileAccess.open("res://scripts/battle.gd",
		FileAccess.READ).get_as_text()

	# Every declared property on BattleUnit, so a mistyped stat field is a
	# FAILURE rather than a rune that quietly does nothing.
	var probe: Node = load("res://scripts/unit.gd").new()
	var unit_props := {}
	for p in probe.get_property_list():
		unit_props[String(p["name"])] = true
	probe.free()

	_schema(data)
	_payloads(data, unit_props, unit_src, battle_src)
	_requires_ability(data)
	_costs(data)
	_eligibility(data)
	_coverage(data)
	_exclusives(data)
	_ordering(battle_src)
	_int_restore(data)
	_exhaustion()
	# Batch AD
	var run: Node = get_root().get_node("/root/Run")
	_arm_purity(run)
	_penalty_list_agrees()
	_power_arm(data, unit_props, unit_src, battle_src)
	_rich_grant(run)
	# Batch AE
	_boolean_fields(data, battle_src)
	_healing_floor(data)
	_start_rune_pool(run)

	print("test_runes: %d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- schema ----------

# BATCH ES §1 — `RARITY_KEYS` WENT WITH THE TIERS. The schema used to require
# every entry to name one of three; there is no tier to name, and the price
# assertion that hung off it (a costed entry must undercut its clean rarity
# peer) had no peer left to undercut — see `_costs` below for what replaced it.
const PAYLOAD_BRANCHES := ["stat", "ability", "grant_ability", "new_ability"]


func _schema(data: Dictionary) -> void:
	var seen_names := {}
	for id in data:
		var e: Dictionary = data[id]
		ok(e.has("name") and String(e["name"]) != "", "%s: no name" % id)
		# BATCH ES §1 — RARITY IS GONE FROM THE DATA AND IS PINNED ABSENT, not
		# merely unread. A key nothing reads is a key a later batch re-keys
		# something to, and this file is the schema.
		ok(not e.has("rarity"), "%s: still carries a `rarity` key (ES §1)" % id)
		ok(not e.has("scarred"), "%s: still carries a `scarred` flag (ES §3)" % id)
		ok(e.has("price") and int(e["price"]) > 0, "%s: bad price" % id)
		ok(e.has("desc") and String(e["desc"]) != "", "%s: no desc" % id)
		ok(e.has("payload") and e["payload"] is Dictionary, "%s: no payload" % id)
		# apply_payload is an if/elif chain — a payload carrying two branches
		# silently drops all but the first.
		var branches := 0
		for b in PAYLOAD_BRANCHES:
			if e.get("payload", {}).has(b):
				branches += 1
		ok(branches == 1, "%s: payload must carry exactly 1 branch, has %d" % [id, branches])
		var disp := Runes.display_name(e)
		ok(not seen_names.has(disp), "%s: duplicate display name %s" % [id, disp])
		seen_names[disp] = true
		# **BATCH ES §1 — AND THE NAME IS NOW THE ONLY THING KEEPING THEM
		# APART.** `display_name` used to prepend a tier or the Scarred prefix,
		# so two entries could share a `name` and still be distinct runes; they
		# cannot now, which makes this uniqueness check load-bearing where it
		# used to be belt-and-braces.
		ok(disp == String(e["name"]),
			"%s: display_name no longer adds a prefix (ES §1)" % id)


# ---------- the silent-dud alarms ----------

func _payloads(data: Dictionary, unit_props: Dictionary, unit_src: String,
		battle_src: String) -> void:
	for id in data:
		var pay: Dictionary = data[id].get("payload", {})
		if pay.has("stat"):
			for field in pay["stat"]:
				var f := String(field)
				# (1) the field must EXIST somewhere real: either a declared
				# BattleUnit property (setup() pushes cfg into typed vars —
				# set() on an unknown name is silently DROPPED, so a typo is a
				# dud, not a crash) or a cfg-only field battle.gd consumes at
				# spawn (max_hp_pct is folded into max_hp and never reaches
				# the unit).
				ok(unit_props.has(f) or battle_src.find('cfg.get("%s"' % f) >= 0,
					"%s: stat field '%s' is neither a BattleUnit property nor read out of cfg" % [id, f])
				# (2) SOMETHING must read it. A declared-but-unread field is
				# exactly the failure this batch was chartered to hunt.
				ok(battle_src.find(f) >= 0 or unit_src.count(f) > 1,
					"%s: stat field '%s' is never read in battle.gd or unit.gd" % [id, f])
		if pay.has("ability"):
			ok(pay.has("add") or pay.has("set") or pay.has("status_turns"),
				"%s: ability payload changes nothing" % id)
		if pay.has("grant_ability"):
			ok(Classes.pending_talent_ability(String(pay["grant_ability"])) != null,
				"%s: grant_ability '%s' has no def in Classes" % [id, pay["grant_ability"]])
		if pay.has("new_ability"):
			ok(String(pay["new_ability"].get("display_name", "")) != "",
				"%s: new_ability without a display_name" % id)


# apply_payload matches on display_name — a rune naming an ability its owner
# cannot have is a blank the player paid for.
func _requires_ability(data: Dictionary) -> void:
	for id in data:
		var e: Dictionary = data[id]
		var pay: Dictionary = e.get("payload", {})
		if not pay.has("ability"):
			continue
		var req := String(e.get("requires_ability", ""))
		ok(req != "", "%s: ability payload with no requires_ability" % id)
		ok(req == String(pay["ability"]),
			"%s: requires_ability '%s' != the ability it alters '%s'" % [
				id, req, pay["ability"]])
		# And SOME hero this rune is WRITTEN FOR must actually own it.
		ok(_reachable(e, req),
			"%s: requires_ability '%s' is in no in-scope hero's derivable kit" % [id, req])


# **BATCH ET §2 — THIS ASKS ABOUT SCOPE NOW, NOT ABOUT OFFERABILITY, AND THE
# DISTINCTION IS THE SAME ONE `test_rune_battle` MAKES.**
#
# It used to skip any hero who could not currently ROLL the rune, so with the
# whole pool retired at ET every `requires_ability` entry read as unreachable
# and nine of them failed — not because the authoring is wrong but because
# nothing is offered. **The question this section asks is about the AUTHORED
# ENTRY**: a rune whose payload names an ability no hero it is written for can
# ever hold applies silently and does nothing, and that is a defect whether or
# not the rune is currently in the offer pool. WHETHER it is offered is
# `_eligibility`'s question and is asserted there in BOTH directions.
#
# **THE REPAIR IS DELIBERATELY NOT AN EXEMPTION.** Skipping retired entries
# would have been the smaller diff and the silent one: it would have left this
# section looping over nothing and printing like a clean run, which is the
# shape EO's own comment in `test_rune_battle` warns about one file over.
# Scope is read off the entry the same way `_scope_ok` reads it, so the check
# survives a retirement, survives a re-scope, and still fires the day a rune
# names an ability its class cannot reach.
func _reachable(entry: Dictionary, ability_name: String) -> bool:
	var scope := String(entry.get("scope", "universal"))
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			if scope.begins_with("class:") and scope.trim_prefix("class:") != String(key):
				continue
			if scope.begins_with("spec:") and scope.trim_prefix("spec:") != String(spec):
				continue
			var member := {"key": key, "spec": spec, "runes": []}
			if Runes.kit_names(member).has(ability_name):
				return true
	return false


func _id_of(entry: Dictionary) -> String:
	for id in Runes.ids():
		if Runes.config(id) == entry:
			return id
	return ""


# ---------- the cost clauses (was: scarred) ----------
#
# ── BATCH ES §3 — THE LABEL WENT, THE COSTS STAYED, AND THE POPULATION IS
# DERIVED NOW INSTEAD OF DECLARED ──────────────────────────────────────────
#
# This section used to read the `scarred` boolean and check that a flagged
# entry carried a negative term. **THERE IS NO FLAG**, so the question inverts
# into the one that was always the real one: **which runes actually charge for
# their upside, and does `Runes.is_cost` — the function the power probe uses to
# hold a cost at its authored value — agree that they do?** A cost clause that
# stopped being RECOGNISED as a cost would be scaled by the arm and the rune
# would quietly become pure upside, which is the defect §3 names.
#
# **AND DERIVING IT IMMEDIATELY FOUND THAT THE FLAG AND THE BEHAVIOUR HAD NEVER
# AGREED.** Both sets are 17 and they are not the same 17:
#
#   `exsanguination` WAS FLAGGED AND HAS NO PAYLOAD COST TO FIND. Its whole
#     payload is `blood_pact: -15`, which is in `INVERTED_STAT_FIELDS` because a
#     negative there is the rune's PROMISE (veins open at 85). Its price — the
#     bleedout tearing 15% of max health instead of 20% — is a second behaviour
#     of the SAME field at the SAME read site (`battle._add_bleed_with_burst`),
#     so there is no term for any sweep to see. The flag was the only
#     machine-readable record that this rune charges anything, and it is gone.
#     **IT IS NAMED HERE RATHER THAN SUPPRESSED**, which is what an exemption is
#     for in this project.
#   `anchor` CARRIES A REAL COST (-10 Speed) AND WAS NEVER FLAGGED, because the
#     old rule forbade a "scarred common" and it is the one common in the file.
#     **That was a RARITY rule hiding a cost**, and ES §1 removing rarity is
#     what surfaces it.
const PENALTY_FIELDS := ["dmg_taken_bonus"]

# The one entry whose cost is a behaviour rather than a term. See above.
const COST_WITHOUT_A_TERM := {
	"exsanguination": "its cost and its promise are two behaviours of one field (blood_pact) at one read site, so no payload term expresses it",
}


# Every payload term `Runes.is_cost` calls a cost, for one entry.
func _cost_terms(e: Dictionary) -> Array:
	var out: Array = []
	var pay: Dictionary = e.get("payload", {})
	for field in pay.get("stat", {}):
		var v = pay["stat"][field]
		if (v is float or v is int) and Runes.is_cost(String(field), float(v)):
			out.append("stat.%s" % field)
	for field2 in pay.get("add", {}):
		var v2 = pay["add"][field2]
		if (v2 is float or v2 is int) and float(v2) < 0.0 \
				and not Runes.INVERTED_AB_FIELDS.has(String(field2)):
			out.append("add.%s" % field2)
	return out


func _costs(data: Dictionary) -> void:
	var costed: Array = []
	for id in data:
		if not _cost_terms(data[id]).is_empty():
			costed.append(String(id))
	costed.sort()
	# **THE SWEEP ASSERTS ITS OWN POPULATION** (EA §5): a walk that recognised
	# nothing would report a file with no costs in it and read green.
	ok(costed.size() >= 15,
		"the cost sweep read a real population (%d entries charge for their upside)" % costed.size())
	# The named exception must still be in the file and must still be the ONLY
	# one that needs naming — a second entry losing its term is what this catches.
	for id2 in COST_WITHOUT_A_TERM:
		ok(data.has(id2), "COST_WITHOUT_A_TERM names '%s', which is not in the pool" % id2)
		ok(not costed.has(id2),
			"%s now carries a payload cost term — it is no longer the exception, update the list" % id2)
	print("  (ES §3: %d entries carry a cost term `is_cost` recognises; %d named exception)" % [
		costed.size(), COST_WITHOUT_A_TERM.size()])


# ---------- eligibility ----------

func _eligibility(data: Dictionary) -> void:
	for id in data:
		var e: Dictionary = data[id]
		var scope := String(e.get("scope", "universal"))
		if scope.begins_with("spec:"):
			var spec := scope.trim_prefix("spec:")
			var owner_key := ""
			for key in Classes.SPEC_IDS:
				if Classes.SPEC_IDS[key].has(spec):
					owner_key = key
			ok(owner_key != "", "%s: scope names an unknown spec '%s'" % [id, spec])
			if owner_key == "":
				continue
			# Rolls for its own spec — UNLESS IT IS RETIRED, and then it must
			# roll for NOBODY.
			#
			# BATCH EO §3: twelve of the sixteen the charter emptied are retired
			# the way Melted Armor is retired — the entry is kept in
			# `runes.json` and simply never offered. **The property is asserted
			# in BOTH directions rather than exempted**, because a one-armed
			# version would go green on the day the whole file stopped rolling.
			var mine := {"key": owner_key, "spec": spec, "runes": []}
			var rolls: bool = Runes.eligible_ids(mine, []).has(id)
			# BATCH EZ — THE THIRD ARM, AND IT IS `requires_ability` DOING ITS
			# JOB RATHER THAN AN EXEMPTION. This member has drafted nothing, so
			# a rune naming an ability outside the DERIVABLE kit — core kit plus
			# spec abilities plus the overrides — correctly does not roll for
			# him. **Ambush requires Called Volley, which is a DRAFT card**, and
			# the alternative to this arm is a rune that applies silently and
			# does NOTHING for a hero who was offered it.
			#
			# **THE ARM IS TWO-WAY, WHICH IS WHAT KEEPS IT FROM BEING A SKIP.**
			# A rune whose requirement the bare member DOES satisfy must still
			# roll (Split Tongue, Open Wound and the Split Shield all name core
			# kit and are asserted to roll), and one whose requirement it does
			# not must not — so a `requires_ability` pointing at a name nothing
			# resolves still turns this red.
			var needs := String(Runes.config(id).get("requires_ability", ""))
			# **THE SAME DOOR `eligible_ids` ITSELF USES.** A second reading of
			# "does he own it" would be a second answer to the question the
			# filter is asking, and the two would eventually disagree.
			var owns: bool = needs == "" or Runes.kit_names(mine).has(needs)
			if Runes.is_retired(id):
				ok(not rolls, "%s: is RETIRED and must not roll for its own spec" % id)
			elif owns:
				ok(rolls, "%s: does not roll for its own spec" % id)
			else:
				ok(not rolls,
					"%s: requires '%s', which this member does not own, and rolled anyway"
						% [id, needs])
			# ...and for nobody else's.
			for key in Classes.SPEC_IDS:
				for other in Classes.SPEC_IDS[key]:
					if other == spec:
						continue
					var theirs := {"key": key, "spec": other, "runes": []}
					ok(not Runes.eligible_ids(theirs, []).has(id),
						"%s: leaks into spec %s" % [id, other])
		elif scope.begins_with("class:"):
			var ckey := scope.trim_prefix("class:")
			ok(Classes.SPEC_IDS.has(ckey), "%s: scope names an unknown class" % id)


# ---------- coverage (the check that catches a lane being renamed) ----------

func _coverage(data: Dictionary) -> void:
	# Batch AB: ALL TWELVE specs, not a hand-written subset — the Hunter was
	# the last one owing, and reading the class list out of Classes means a
	# thirteenth spec fails this test until it has a set.
	var specs_seen := 0
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			specs_seen += 1
			# ── BATCH EZ SPLIT THIS WALK IN TWO, AND NEITHER HALF IS WEAKER ──
			# **EVERYTHING BELOW IS THE OLD AUTHORING RULE — one rune per talent
			# lane plus one splash, exactly one of the four charging for its
			# upside — AND THAT RULE GOVERNS THE 65 ET RETIRED AND NOTHING
			# ELSE.** ES §5 severed the lane rule; EZ's twenty-one carry no
			# `lane` at all, so under the unsplit walk every one of them read as
			# a splash and the per-spec count went 4 -> 9 (10 for the
			# Beastmaster). **Re-deriving the retired entries under a rule they
			# were never authored to would be inventing history**, and dropping
			# the rule would lose the only thing pinning the lane coverage those
			# 65 were built on. So the population is narrowed and the assertions
			# are untouched.
			# **BATCH FC — "RETIRED" IS NO LONGER THE SAME SET AS "AUTHORED TO
			# THE LANE RULE", AND THE POPULATION IS NARROWED RATHER THAN THE
			# ASSERTION LOOSENED.** FC §3 retires Split Tongue — an EZ rune,
			# authored under the SHAPES charter and never under the lane rule —
			# and it walked straight into this population as a fifth Occultist
			# entry and a second splash, turning two assertions red for a
			# retirement doing exactly the right thing. **THE DISCRIMINATOR IS
			# `RUNE_SHAPES` MEMBERSHIP, WHICH IS THE VINTAGE ITSELF**: the 65 ET
			# retired predate EZ §0's vocabulary and carry no row, every rune
			# authored at EZ or after carries one, and a retirement does not take
			# the row away (a retired rune is still an ABILITY rune). So this
			# needs no vintage list and no per-batch exemption — the next EZ-era
			# retirement is classified correctly with no edit here.
			var mine: Array = []
			var live_here: Array = []
			var later_retired: Array = []
			for id in data:
				if String(data[id].get("scope", "")) != "spec:%s" % spec:
					continue
				if Runes.is_retired(String(id)):
					if not (Runes.rune_shape(String(id)) as Array).is_empty():
						later_retired.append(id)
						continue
					mine.append(id)
				else:
					live_here.append(id)
			# **AND THE NARROWING IS ASSERTED RATHER THAN TRUSTED.** A skipped
			# entry must be one this walk genuinely does not govern: no `lane`
			# (the field the rule is made of) and a retirement string that names
			# neither of the two batches that emptied the pool.
			for lr in later_retired:
				ok(String(data[lr].get("lane", "")) == "",
					"%s: %s was retired after EZ and still carries a `lane`" % [spec, lr])
				var lr_s := String(data[lr].get("retired", ""))
				ok(not lr_s.contains("BATCH EO") and not lr_s.contains("BATCH ET"),
					"%s: %s carries a SHAPES row and an EO/ET retirement — the two vintages have crossed"
						% [spec, lr])
			ok(mine.size() == 4,
				"%s: has %d RETIRED spec runes, expected the 4 authored to the lane rule"
					% [spec, mine.size()])
			# **AND THE LIVE HALF IS FLOORED AND PRINTED RATHER THAN PINNED**,
			# because which specs are authored next is CONTENT and is the
			# designer's: an equality here would go red on the next authoring
			# batch for doing exactly the right thing. What is asserted is the
			# thing that cannot be intentional — a live rune carrying a `lane`,
			# which would mean the severed rule had quietly come back.
			var live_with_lane: Array = []
			for lid in live_here:
				if String(data[lid].get("lane", "")) != "":
					live_with_lane.append(lid)
			ok(live_with_lane.is_empty(),
				"%s: %s are live and still carry a `lane` — the severed rule is back"
					% [spec, live_with_lane])
			# Lanes come out of LANE_TREES, never a written list (Batch Y's
			# 70%-vs-53% drift is the precedent for not trusting prose).
			var tree_lanes := {}
			for node in Talents.generate_tree(spec, key):
				if String(node.get("lane", "")) != "":
					tree_lanes[String(node["lane"])] = true
			var covered := {}
			var splash := 0
			# **BATCH ES §3 — DERIVED THROUGH `is_cost`, NOT OFF A FLAG.** The
			# property is unchanged and only its instrument moved: exactly one
			# rune in each spec's set of four CHARGES for its upside, and it is
			# never the splash — the splash is the clean, always-fine pick.
			var costed_on_lane := 0
			var costed_splash := 0
			for id in mine:
				var lane := String(data[id].get("lane", ""))
				var charges: bool = not _cost_terms(data[id]).is_empty() \
					or COST_WITHOUT_A_TERM.has(String(id))
				if lane == "":
					splash += 1
					if charges:
						costed_splash += 1
					continue
				if charges:
					costed_on_lane += 1
				ok(tree_lanes.has(lane),
					"%s: rune %s names lane '%s', which is not in its LANE_TREES entry" % [
						spec, id, lane])
				ok(not covered.has(lane), "%s: two runes on lane '%s'" % [spec, lane])
				covered[lane] = true
			ok(splash == 1, "%s: %d splash runes, expected exactly 1" % [spec, splash])
			ok(covered.size() == tree_lanes.size(),
				"%s: covers %d of %d lanes" % [spec, covered.size(), tree_lanes.size()])
			ok(costed_on_lane == 1,
				"%s: %d lane runes charge for their upside, expected exactly 1" % [
					spec, costed_on_lane])
			ok(costed_splash == 0, "%s: the splash rune charges a cost" % spec)
	ok(specs_seen == 12, "expected 12 specs, walked %d" % specs_seen)


# ---------- row exclusivity ----------

# RETIRED IN BATCH AI, deliberately and with the reasoning left in place.
#
# The alarm this replaces watched authored "exclusive_with" pairs: a rune
# writing one side's counter would hand a player the road they declined.
# Batch AI deleted exclusive_with — EVERY row is now three mutually
# exclusive options, so at row granularity the old test would fire on
# nearly every spec rune in the game. That is not 24 violations; it is the
# alarm asking a question the design no longer answers the same way.
#
# What replaced it in kind: the coverage test above still pins one rune per
# lane per spec, and Batch AI's own harness (test_batch_ai.gd) pins the row
# structure itself. What is NOT covered, and is a real question for the four
# class batches that re-author all 252 nodes: whether a rune should be able
# to grant a counter whose node sits in a row the player passed on. Author
# the answer with the nodes, then bring an alarm back that states it.
func _exclusives(_data: Dictionary) -> void:
	pass


# ---------- call-site ordering ----------

# Batch AA: the ceilings (Resonance / Mercy / Focus) are derived FROM cfg, so
# they must be computed after runes have written into it. This assertion is
# the regression alarm: if the derivations ever move back above the rune
# block, every ceiling rune becomes a silent dud again.
func _ordering(battle_src: String) -> void:
	var rune_at := battle_src.find("Talents.apply_payload(cfg, rune[\"payload\"], 1,")
	ok(rune_at >= 0, "battle.gd: the rune apply site is gone")
	# Batch AA moved these derivations below the rune block. The Focus three
	# were the reason ("the Hunter batch would have hit this on Focus") and
	# Batch AB is the first time runes actually write them.
	# RE-POINTED IN PLACE, BATCH AT, with the reason here rather than a silent
	# deletion: `resonant_core_ranks` is no longer a CEILING field. Runaway
	# Resonance has no maximum at all, so nothing derives a Resonance ceiling
	# from cfg any more and the probe had nothing left to find. The RULE is
	# untouched and still live for Mercy and Focus, which is what the remaining
	# five probes watch — and the Resonance side is now covered by the opposite
	# assertion below: that no derivation reads a Resonance ceiling out of cfg.
	# RE-POINTED IN PLACE AGAIN, BATCH AZ, same shape and same reason as AT's:
	# `deep_focus` IS NO LONGER A CEILING FIELD. Focus has no maximum at all
	# now, and the node moves the CONVERSION POINT instead — which is decided on
	# BattleUnit at read time, not derived from cfg at spawn. So the probe had
	# nothing left to find, and the deep_focus side is covered by the opposite
	# assertion below: that no derivation reads a Focus ceiling out of cfg.
	# `spray` and `opening_volley` STILL derive from cfg and keep their probes —
	# Spray of Arrows is the one node that still imposes a ceiling, and Opening
	# Volley still sets what he walks in holding.
	# BATCH EM RE-POINTED THE TWO RUNE-WRITTEN PROBES AND KEPT THE OTHER TWO.
	# The charter took the runes off the talent counters, so the Open Hand writes
	# `rune_zealous_mercy` and the Long Draw `rune_opening_volley` — and THOSE are
	# the names a derivation running too early would now leave as duds. The node's
	# `zealous_mercy` and `opening_volley` are still derived here and still
	# checked; `spray` and `mercy_cap_bonus` are written by no rune either way and
	# are unchanged. **The ordering question did not move; the field name did.**
	for probe in ["mercy_cap_bonus", "zealous_mercy", "spray", "opening_volley",
			"rune_zealous_mercy", "rune_opening_volley"]:
		var derive_at := battle_src.find("cfg.get(\"%s\"" % probe)
		ok(derive_at >= 0, "battle.gd: no derivation reads %s" % probe)
		ok(derive_at > rune_at,
			"battle.gd: %s is derived BEFORE runes apply — ceiling runes are duds" % probe)
	# Batch AZ: the Sharpshooter's ceiling is GONE, not moved — the same alarm
	# AT armed for Resonance. A batch that quietly re-derived one would put a cap
	# back on a meter whose whole design is not having one.
	ok(battle_src.find("cfg.get(\"deep_focus\"") < 0,
		"battle.gd: a Focus CEILING is being derived from deep_focus again — Lethal Aim has no maximum")
	ok(battle_src.find("const FOCUS_UNCAPPED := -1") >= 0,
		"battle.gd: the Focus sentinel is gone — 'no cap' must not become a large number")
	# Batch AT: the Arcanist's ceiling is GONE, not moved. A batch that quietly
	# re-derives one would put a cap back on a passive whose whole design is not
	# having one, so the alarm now watches for its RETURN.
	ok(battle_src.find("cfg.get(\"resonant_core_ranks\"") < 0,
		"battle.gd: a Resonance CEILING is being derived again — Runaway Resonance has no maximum")
	ok(battle_src.find("cfg[\"second_max\"] = 99") > rune_at,
		"battle.gd: the Arcanist's sentinel second_max is gone or moved above the rune block")
	# ...and the pool must actually hold a rune that writes a ceiling field,
	# or the assertion above is guarding a road nothing drives on.
	var ceiling_writers := 0
	for id in Runes.ids():
		for field in Runes.config(id).get("payload", {}).get("stat", {}):
			# BATCH EM: a rune's ceiling clause is `rune_X` now, so the name it
			# is counted under moved. Both names are read, because the question
			# is whether a rune drives this road at all — and if a node-keyed
			# ceiling rune is ever authored again it must still be counted.
			if String(field).trim_prefix("rune_") in ["opening_volley", "spray",
					"mercy_cap_bonus", "zealous_mercy"]:
				ceiling_writers += 1
	# Batch AT lowered this floor 4 -> 3 and BATCH AZ LOWERS IT 3 -> 2, both for
	# the same arithmetic reason: the field a named writer wrote stopped being a
	# ceiling. AT's was the Resonant Core (Runaway Resonance has no maximum);
	# AZ's is the Deep Sight, because Lethal Aim has none either and the rune was
	# re-pointed at the conversion point instead. THE TWO THAT REMAIN ARE NAMED
	# so a future batch cannot lower it again by attrition — Open Hand
	# (zealous_mercy) and Long Draw (opening_volley). IF IT WOULD FALL TO ONE,
	# the honest move is to author a ceiling rune, not to drop the floor again.
	ok(ceiling_writers >= 2,
		"only %d runes write a second-resource ceiling — the ordering fix is untested in practice" % ceiling_writers)


# ---------- int restoration ----------

# JSON parses every number as a float and BattleUnit.setup() pushes cfg
# straight into typed vars: a float landing in an int var is a runtime error
# mid-spawn, not a rounding.
func _int_restore(data: Dictionary) -> void:
	for id in data:
		var built := Runes.build(id)
		for field in built.get("payload", {}).get("stat", {}):
			var f := String(field)
			if f.ends_with("_ranks") or Runes.STAT_INT_KEYS.has(f):
				ok(typeof(built["payload"]["stat"][f]) == TYPE_INT,
					"%s: stat '%s' survived as a float" % [id, f])
		for part in ["add", "set"]:
			for field in built.get("payload", {}).get(part, {}):
				if Runes.AB_INT_KEYS.has(String(field)):
					ok(typeof(built["payload"][part][field]) == TYPE_INT,
						"%s: ability field '%s' survived as a float" % [id, field])


# ---------- exhaustion ----------

# An offer list can never come back empty: a hero holding every rune they can
# roll still gets something. **BATCH ES §1: the pool no longer WIDENS first —
# there is no tier to widen out of — so the fall to the generated stat family is
# the whole floor now and this check is the only thing standing on it.**
func _exhaustion() -> void:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var member := {"key": key, "spec": spec, "runes": []}
			var owned: Array = []
			for id in Runes.eligible_ids(member, []):
				owned.append({"name": Runes.display_name(Runes.config(id))})
			for t in Runes.TEMPLATES:
				owned.append({"name": "Rune of %s" % t["noun"]})
			member["runes"] = owned
			for _i in 5:
				var offer := Runes.generate(member, 3)
				ok(not offer.is_empty(), "%s: exhausted pool returned an empty offer" % spec)
				ok(String(offer.get("name", "")) != "", "%s: offer with no name" % spec)
				ok(offer.get("payload", {}) is Dictionary and not offer["payload"].is_empty(),
					"%s: offer with an empty payload" % spec)


# ================= Batch AD: the two experiment arms =================

# ---------- purity: the load-bearing half ----------
#
# The whole batch is void if a player can be silently in an experiment arm.
# DOD_SIM_RUNES and every other harness flag read the environment
# unconditionally, so a stale export in a shell changes a real game; these
# two must not, and "must not" is worth an assertion rather than a comment.
# THE CHECK THAT MATTERS is the middle one: env SET, sim_run FALSE, nothing
# happens. A gate that is always closed proves nothing, so the arms are
# also asserted to actually ARM under sim_run.
func _arm_purity(run: Node) -> void:
	var had_econ := OS.get_environment("DOD_SIM_RUNE_ECON")
	var had_power := OS.get_environment("DOD_SIM_RUNE_POWER")
	var had_sim: bool = run.sim_run
	var had_zone: int = run.zone_idx

	# 1. Both unset, real play: the shipped defaults.
	OS.set_environment("DOD_SIM_RUNE_ECON", "")
	OS.set_environment("DOD_SIM_RUNE_POWER", "")
	run.sim_run = false
	for z in 3:
		run.zone_idx = z
		ok(run.rune_econ() == "normal", "flags unset: rune_econ should be normal")
		ok(is_equal_approx(run.rune_power(), 1.0), "flags unset: rune_power should be 1.0")
		# Batch AN §9: THREE SLOTS FLAT from run start. The 2/3/4 growth
		# ladder is gone, so the assertion is that the zone does NOT move it.
		ok(run.rune_slots() == 3,
			"flags unset: rune_slots is a flat 3 at zone %d (got %d)" % [
				z, run.rune_slots()])

	# 2. Both SET, but NOT a sim: the flags must be unreachable.
	OS.set_environment("DOD_SIM_RUNE_ECON", "rich")
	OS.set_environment("DOD_SIM_RUNE_POWER", "3.0")
	for z in 3:
		run.zone_idx = z
		ok(run.rune_econ() == "normal",
			"REAL PLAY WITH THE ENV SET reached the rich arm — purity violated")
		ok(is_equal_approx(run.rune_power(), 1.0),
			"REAL PLAY WITH THE ENV SET reached the power arm — purity violated")
		ok(run.rune_slots() == 3,
			"REAL PLAY WITH THE ENV SET moved the flat 3 slots at zone %d" % z)
	var real_rune: Dictionary = run._apply_rune_power(Runes.build("glass"))
	ok(is_equal_approx(float(real_rune["payload"]["stat"]["crit_bonus"]), 0.08),
		"REAL PLAY WITH THE ENV SET scaled a rune payload — purity violated")

	# 3. Same env under sim_run: the arms must actually arm.
	run.sim_run = true
	ok(run.rune_econ() == "rich", "sim_run + env: the rich arm did not arm")
	ok(is_equal_approx(run.rune_power(), 3.0), "sim_run + env: the power arm did not arm")
	for z in 3:
		run.zone_idx = z
		ok(run.rune_slots() == run.RICH_SLOTS,
			"rich arm should open every slot at zone %d" % z)
	var sim_rune: Dictionary = run._apply_rune_power(Runes.build("glass"))
	ok(is_equal_approx(float(sim_rune["payload"]["stat"]["crit_bonus"]), 0.24),
		"sim_run + env: the power arm did not scale an authored payload")
	# Generated stat sticks are not authored content and stay put.
	var stick: Dictionary = run._apply_rune_power(Runes.template_rune("warrior", "Vitality"))
	ok(int(stick["payload"]["stat"]["max_hp"]) == 10,
		"the power arm scaled a generated stat stick; only authored entries should move")

	# 4. Junk must fall back to 1.0, never to 0.0 — a mistyped multiplier
	#    that zeroed every payload in the pool would look like a finding.
	for junk in ["banana", "-2", "0", "0.0", " "]:
		OS.set_environment("DOD_SIM_RUNE_POWER", junk)
		ok(is_equal_approx(run.rune_power(), 1.0),
			"DOD_SIM_RUNE_POWER='%s' should fall back to 1.0" % junk)
	OS.set_environment("DOD_SIM_RUNE_ECON", "RICH")  # case-sensitive on purpose
	ok(run.rune_econ() == "normal", "DOD_SIM_RUNE_ECON should match 'rich' exactly")

	OS.set_environment("DOD_SIM_RUNE_ECON", had_econ)
	OS.set_environment("DOD_SIM_RUNE_POWER", had_power)
	run.sim_run = had_sim
	run.zone_idx = had_zone


# The scarred check and the power arm must agree about what a cost IS. If
# they drift, either scarred runes stop being audited or the arm starts
# scaling a penalty — the exact failure the brief warned about.
func _penalty_list_agrees() -> void:
	ok(Array(Runes.PENALTY_FIELDS) == PENALTY_FIELDS,
		"Runes.PENALTY_FIELDS %s has drifted from this test's list %s" % [
			Runes.PENALTY_FIELDS, PENALTY_FIELDS])
	for f in PENALTY_FIELDS:
		ok(Runes.is_cost(String(f), 0.15), "%s: a positive value should read as a cost" % f)
	ok(Runes.is_cost("speed", -10.0), "a negative ordinary term should read as a cost")
	ok(not Runes.is_cost("crit_bonus", 0.08), "a positive ordinary term is not a cost")
	# REGRESSION GUARD (Batch AD): blood_pact runs backwards — the Rune of
	# Exsanguination's -15 is its whole PROMISE (bleedout at 85, not 100).
	# Read by sign alone it looks like a drawback and gets held, leaving the
	# rune inert in every arm. That is how it was found; this is why it
	# cannot come back.
	for f in Runes.INVERTED_STAT_FIELDS:
		ok(not Runes.is_cost(String(f), -15.0),
			"%s runs backwards: a negative value is the benefit, not a cost" % f)
		ok(Runes.is_cost(String(f), 15.0),
			"%s runs backwards: a positive value is the cost" % f)


# ---------- the power arm ----------
#
# Entries that legitimately have no magnitude to scale, named here so a
# future rune quietly joining them is a FAILURE rather than a shrug. Three
# grant an ability, one adds one, and Quick Spring's whole payload is
# inverted (cost/cooldown reductions), which the arm deliberately leaves
# alone rather than making an ability free.
# **BATCH EZ ADDED `split_tongue`, AND IT IS A REAL MEMBER RATHER THAN AN
# EXEMPTION.** The arm scales every `stat` BENEFIT and every ability `add` by
# three and requires the payload to MOVE, so an entry that does not respond is
# an entry the power probe cannot measure. Split Tongue's whole payload is
# `{"ability": "Hex of Ruin", "set": {"aoe": true}}` plus an `also` carrying a
# FLAG (`rune_split_tongue: 1`): a `set` is an absolute assignment the arm
# correctly refuses to scale, and **a flag has no magnitude — three is not more
# `aoe` than one.** It belongs here for `comet`'s reason and not for a new one.
#
# **AND THE ARM HAS A HOLE THIS ENTRY SITS BESIDE, WHICH IS WORTH THE LINE:
# the walk reads `base["stat"]` and `base["add"]` at the TOP LEVEL and does not
# descend into `also`.** No rune's `also` carries a magnitude today, so nothing
# is unmeasured — but the day one does, the probe will report it as a dud
# rather than scaling it, and the entry will be added here instead of the hole
# being closed. Recorded so that is a decision somebody makes on purpose.
const UNSCALABLE := ["comet", "binding_souls", "last_rites", "flayed_mind",
	"quick_spring", "split_tongue"]


func _power_arm(data: Dictionary, unit_props: Dictionary, unit_src: String,
		battle_src: String) -> void:
	var scaled_data := {}
	for id in data:
		var base: Dictionary = Runes.build(id)["payload"]
		ok(Runes.scale_payload(base, 1.0) == base,
			"%s: x1.0 must be the identity — a control row would not be a control" % id)
		var big: Dictionary = Runes.scale_payload(base, 3.0)
		var clone: Dictionary = data[id].duplicate(true)
		clone["payload"] = big
		scaled_data[id] = clone
		var moved := false
		for field in base.get("stat", {}):
			var b = base["stat"][field]
			var a = big["stat"][field]
			var f := String(field)
			# A COST must be byte-identical: the arm asks "are the entries
			# too weak", and growing the drawbacks answers something else.
			if Runes.is_cost(f, float(b)):
				ok(is_equal_approx(float(a), float(b)),
					"%s: cost term '%s' was scaled (%s -> %s)" % [id, f, b, a])
			else:
				ok(is_equal_approx(float(a), float(b) * 3.0),
					"%s: benefit '%s' did not scale (%s -> %s)" % [id, f, b, a])
				moved = true
			# Sign must survive: a drawback must never become a bonus.
			ok(signf(float(a)) == signf(float(b)) or is_zero_approx(float(b)),
				"%s: '%s' changed sign under the arm (%s -> %s)" % [id, f, b, a])
			# Type must survive — a float into a typed int var is a runtime
			# error, not a rounding (the Batch AA trap).
			ok((b is int) == (a is int),
				"%s: '%s' changed int/float type under the arm" % [id, f])
		for field in base.get("add", {}):
			var ab = base["add"][field]
			var aa = big["add"][field]
			if Runes.INVERTED_AB_FIELDS.has(String(field)) or float(ab) < 0.0:
				ok(is_equal_approx(float(aa), float(ab)),
					"%s: inverted/negative add '%s' was scaled" % [id, field])
			else:
				ok(is_equal_approx(float(aa), float(ab) * 3.0),
					"%s: ability add '%s' did not scale" % [id, field])
				moved = true
			ok((ab is int) == (aa is int),
				"%s: add '%s' changed int/float type under the arm" % [id, field])
		ok(base.get("set", {}) == big.get("set", {}),
			"%s: a 'set' field is an absolute assignment and must not scale" % id)
		ok(base.get("new_ability", {}) == big.get("new_ability", {}),
			"%s: new_ability has no magnitude and must not be touched" % id)
		# The positive control: every entry NOT on the named list must
		# actually respond to the arm, or the arm silently measures nothing.
		if UNSCALABLE.has(id):
			ok(not moved, "%s is on UNSCALABLE but the arm moved it — update the list" % id)
		else:
			ok(moved, "%s: the power arm changed NOTHING — it is a dud in every arm" % id)
	for id in UNSCALABLE:
		ok(data.has(id), "UNSCALABLE names '%s', which is not in the pool" % id)
	# A scaled pool must still be a LEGAL pool: same field vocabulary, same
	# one-branch rule, same int discipline. Stage 2 raises magnitudes for
	# real, so the schema has to hold at the numbers the arm produced too.
	_payloads(scaled_data, unit_props, unit_src, battle_src)
	_costs(scaled_data)


# ---------- Batch AE: fields with a NUMBER but no MAGNITUDE ----------
#
# UNSCALABLE above catches entries the arm cannot move. This catches the
# worse case: entries the arm DOES move on paper while the game ignores the
# new value entirely. Five rune fields are read as pure booleans — the
# value is a gate, and the effect behind it is a hard-coded constant — so
# `deep_focus: 1 -> 3` is a silent no-op in the data and, after an authored
# pass, a lie in the tooltip.
#
# This is also a CORRECTION TO BATCH AD, asserted rather than remembered:
# its power arm scaled these terms like any other int, so its x3 / x6 / x10
# rows never actually multiplied them.
#
# The check is on the READ SITE, not on the rune: if someone later makes one
# of these arithmetic, this fails and tells them the field can now carry a
# magnitude — which is the moment the pool could start using it.
#
# BATCH AZ TOOK THREE OF THE FIVE OFF THIS LIST, AND THAT IS THE ALARM DOING ITS
# JOB RATHER THAN THE LIST DECAYING. `deep_focus`, `perfect_form` and
# `opening_volley` were flag talents whose payload was a bare 1; the
# Sharpshooter re-author gave each of them a real magnitude in the units its
# read site sums (points the conversion point drops, Focus a crit grants, Focus
# he opens holding), so a rune CAN now move them and the pool does. The check
# fired the moment the code changed, which is exactly the moment it was supposed
# to.
#
# BATCH BA TOOK A FOURTH, AND IT IS THE ONE AZ PREDICTED IN THIS COMMENT.
# `vulture` was a Survivalist flag in front of a hard-coded 1.30; the re-author
# gave it a real magnitude in the units its read site sums (60 = percentage
# points), and the Rune of the Carrion Wake pays 30 into it now instead of a
# bare 1 that did nothing. The prediction and the removal are recorded together
# on purpose — the list shrinks when a tree is re-authored, never by attrition.
#
# ONE SURVIVOR, NAMED SO THE LIST CANNOT EMPTY QUIETLY: `coated_blades`. It is a
# RULE, not an amount — his basic attack applies Poison and Cripple — so no
# re-author can give it a magnitude, and the Rune of the Weeping Wound writing
# it a bare 1 is correct rather than a leftover. WITH THE SURVIVALIST DONE,
# EVERY TREE IN THE GAME HAS BEEN RE-AUTHORED: a future entry to this list would
# be a NEW flag field, not another old one waiting its turn.
const BOOLEAN_READ_FIELDS := {
	"coated_blades": "coated_blades > 0",
}


func _boolean_fields(data: Dictionary, battle_src: String) -> void:
	for field in BOOLEAN_READ_FIELDS:
		ok(battle_src.contains(BOOLEAN_READ_FIELDS[field]),
			"%s is no longer read as a boolean gate — it may now carry a magnitude, so it must leave BOOLEAN_READ_FIELDS" % field)
		# ...and it must be read ONLY that way. An arithmetic use elsewhere
		# would mean the value does matter after all.
		var arith := false
		for line in battle_src.split("\n"):
			if not line.contains(field) or line.strip_edges().begins_with("#"):
				continue
			# BATCH EM — THE PAIR IS NOT ARITHMETIC ON THE VALUE. A re-keyed flag
			# is read `u.coated_blades + u.rune_coated_blades > 0`, so the `+`
			# detector fires on the JOIN rather than on a magnitude. The join is
			# masked out and everything else is still caught: an `x + coated_blades`
			# anywhere else, or a `*` in any form, still trips this.
			var probe_line := line.replace("%s + " % field, "")
			probe_line = probe_line.replace("+ rune_%s" % field, "")
			if probe_line.contains("* %s" % field) or probe_line.contains("%s *" % field) \
					or probe_line.contains("+ %s" % field) or probe_line.contains("%s +" % field):
				arith = true
		ok(not arith,
			"%s now has an arithmetic read site — it is no longer magnitude-free" % field)
		# BATCH EM — READ BOTH NAMES OR THIS STOPS RUNNING SILENTLY. The Rune of
		# the Weeping Wound writes `rune_coated_blades` now; a lookup on the bare
		# name returns null, `continue` fires, and the check below reports nothing
		# while looking exactly as green as a check that ran.
		for id in data:
			var stat: Dictionary = data[id]["payload"].get("stat", {})
			var v = stat.get(field, stat.get("rune_" + field, null))
			if v == null:
				continue
			ok(int(v) == 1,
				"%s writes %s = %s, but that field is a boolean gate — any value above 1 does nothing" % [
					id, field, v])
	# INVERTED IN PLACE, BATCH AZ. It used to assert the Deep Sight carried
	# NOTHING BUT boolean fields, so no magnitude pass could ever move it — one
	# of AE's six magnitude-proof entries, named so a future pass would report it
	# rather than quietly ship an entry that got relatively weaker for free. Both
	# its fields carry real magnitudes now, so the honest question flipped: the
	# alarm watches for it going BACK to being magnitude-proof, which would mean
	# a batch had re-flagged a counter the tree spent this work making additive.
	var ds: Dictionary = data["deep_sight"]["payload"]["stat"]
	var ds_scalable := 0
	for f in ds:
		if not BOOLEAN_READ_FIELDS.has(f):
			ds_scalable += 1
	ok(ds_scalable == ds.size() and ds_scalable > 0,
		"deep_sight has lost a scalable field — it was magnitude-proof until Batch AZ and must not go back")


# ---------- Batch AE: what the opening pick can actually deal ----------
#
# Batch AE's deliverable was one pick of three at spec confirmation, rolled
# through the ORDINARY roller at zone slot 1. The report-back the designer
# asked for is how often that triple contains a spec-scoped rune, and the sim
# measured 36-42% across ten rows. That number is a property of the POOL, so it
# belongs in a test: if a future batch adds or retires spec entries, this is the
# check that tells the designer the hit rate moved with it.
#
# **BATCH ES §1 MOVED THE OTHER HALF OF WHAT SETS IT, AND MOVED THE FIGURE.**
# The rate used to be a property of the pool AND the slot-1 tier weights
# (60/30/10, which put 60% of every zone-1 draw into a bucket holding one
# authored rune and the six stat sticks). **The draw is FLAT now**, so a
# spec-scoped rune's share of the triple is simply its share of the eligible
# pool, and the band below is re-derived rather than carried.
#
# RE-POINTED IN PLACE BY BATCH CD, AND THE FIRST LINE IS AN INVERSION. BATCH
# AN DELETED THE OPENING PICK — `start_rune_enabled`, `spec_opening_enabled`,
# `grant_start_runes` and `_generate_spec_rune` all went with it, and heroes
# now begin with no runes and three empty slots. The call below therefore
# threw `Invalid call ... start_rune_enabled` and ABORTED THIS WHOLE FUNCTION
# while the suite printed a clean 2973: the 144 triple checks and the drift
# alarm underneath had not run since AN. That is the BC trap, and it is what
# Batch CD exists to close.
#
# THE MEASUREMENT IS UNCHANGED AND STILL WORTH TAKING — `roll_rune_candidates`
# is the same function AE measured, on the same slot-1 weights; what moved is
# WHICH pick it feeds. Its one live caller is the ELITE RUNE CACHE, so the
# alarm now guards that triple. The deleted name is pinned ABSENT rather than
# deleted outright, so a later batch reviving an opening pick has to come here
# and say so.
func _start_rune_pool(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.sim_run = false
	ok(not run.has_method("start_rune_enabled"),
		"AN deleted the opening pick — heroes begin with no runes")
	ok(not run.has_method("grant_start_runes"), "...and nothing grants one")
	ok(run.has_method("roll_rune_candidates"),
		"the roller AE measured is still live — it is the elite cache's now")
	var trials := 0
	var with_spec := 0
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			for i in 12:
				var member := {"key": key, "spec": spec, "runes": [],
					"bm_abilities": []}
				var triple: Array = run.roll_rune_candidates(member)
				ok(triple.size() == 3,
					"%s: the cache deal rolled %d candidates" % [spec, triple.size()])
				trials += 1
				for c in triple:
					if String(c.get("scope", "")) == "spec:%s" % spec:
						with_spec += 1
						break
	var rate := 100.0 * with_spec / maxf(float(trials), 1.0)
	# **BATCH ET §2 — TWO-ARMED, AND THE ARM IS CHOSEN BY THE POOL RATHER THAN
	# BY THIS FILE'S MEMORY.** The 20-70 band is a drift alarm on the eligible
	# pool and it is the right alarm whenever there IS one; with every entry
	# retired at ET the rate is 0 by ruling, and a band that cannot be met is
	# not an alarm. So the arm is derived: if no spec rune is eligible for any
	# spec the rate MUST be exactly zero — which is a real assertion, because a
	# retired rune leaking into a cache triple is precisely what it would catch
	# — and the day one is authored the band comes back with no edit here.
	var any_spec_eligible := false
	for key2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[key2]:
			for rid in Runes.eligible_ids({"key": key2, "spec": spec2, "runes": []}, []):
				if String(Runes.config(rid).get("scope", "")) == "spec:%s" % spec2:
					any_spec_eligible = true
	if any_spec_eligible:
		ok(rate > 20.0 and rate < 70.0,
			"a spec rune is in the cache triple %.0f%% of the time — outside the 20-70%% band; the eligible pool moved (ES §1: the draw is flat, so this is the pool's own shape)" % rate)
	else:
		ok(is_zero_approx(rate),
			"no spec rune is eligible for any spec (ET §1 retired the pool), yet one reached a cache triple %.0f%% of the time" % rate)
	print("  (Batch AE report-back, re-pointed at the elite cache by CD: a spec-scoped rune is among the three %.0f%% of the time)" % rate)
	run.sim_run = had_sim


# ---------- Batch AE: the healing floor cannot be reached by stacking ----------
#
# healing_received_mult is a running SUM onto a 1.0 base and unit.heal_amount
# FLOORS it at zero. Batch AA's guard comment says "no reachable loadout gets
# there today"; that is a claim about the DATA, and nothing was checking it.
# A magnitude pass on the three runes that write it would have crossed the
# floor and silently turned "heals are weaker" into "you cannot be healed".
func _healing_floor(data: Dictionary) -> void:
	var uni := 0.0
	var by_scope := {}
	for id in data:
		var v = data[id]["payload"].get("stat", {}).get("healing_received_mult", null)
		if v == null or float(v) >= 0.0:
			continue
		var scope := String(data[id].get("scope", "universal"))
		if scope == "universal":
			uni += float(v)
		else:
			by_scope[scope] = float(by_scope.get(scope, 0.0)) + float(v)
	# Worst reachable hero: every universal cost plus the worst single scope's
	# (a hero has one class and one spec, so scopes cannot combine).
	var worst := uni
	for scope in by_scope:
		worst = minf(worst, uni + float(by_scope[scope]))
	ok(1.0 + worst > 0.0,
		"healing_received_mult costs sum to %.2f on one reachable hero — heal_amount floors at 0, so heals would do NOTHING" % worst)



# ---------- the rich arm's grant ----------
#
# The arm exists to put the runes written for a spec on that spec's hero. If
# the grant handed out universals it would probe a different question, and if
# it handed out duplicates the payload would double-apply.
#
# **BATCH EO §3 — THE COUNT IS DERIVED, NOT THE LITERAL 4.** Every spec was
# authored four spec runes and this loop asked for exactly that many; the
# retirement leaves some specs 2 or 3, and `grant_rune` then CORRECTLY falls
# back to the ordinary roll, which read as nine failures. Asking for the number
# that actually survives keeps the arm probing its own question — the spec's own
# runes reach the spec's hero — and means a further retirement, or a
# re-authoring that restores one, needs no edit here. The fifth-ask fallback
# below is unchanged and is what covers the exhausted case.
func _rich_grant(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.sim_run = true
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var member := {"key": key, "spec": spec, "runes": []}
			var names := {}
			var own := 0
			for rid in Runes.eligible_ids(member, []):
				if String(Runes.config(rid).get("scope", "")) == "spec:%s" % spec:
					own += 1
			# **BATCH ET §2 — TWO-ARMED, BECAUSE THE POOL BEING EMPTY IS NOW A
			# RULING RATHER THAN A DEFECT.** This asserted `own > 0` — "the
			# retirement left its own set empty" — which was the right alarm
			# while EO's twelve were the only retirement and is a statement of
			# ET's ruling now, so at ET it fired on all twelve specs. Deleting
			# it would leave the loop below running zero times and the section
			# printing like a clean run, which is the silent repair EO's own
			# comment in `test_rune_battle` names. **The property is asserted in
			# BOTH directions instead**: where a spec HAS surviving spec runes
			# they must reach its hero without repeating, and where it has none
			# the FALLBACK must be what answers — and the day a rune is authored
			# for that spec, the first arm comes back on its own.
			if own == 0:
				var only: Dictionary = run.grant_rune(member)
				ok(not only.is_empty(),
					"%s: with no spec rune surviving, the grant returned nothing" % spec)
				ok(String(only.get("scope", "")) != "spec:%s" % spec,
					"%s: no spec rune is eligible, yet the grant returned one" % spec)
			for i in own:
				var rune: Dictionary = run.grant_rune(member)
				ok(not rune.is_empty(), "%s: grant %d came back empty" % [spec, i])
				ok(String(rune.get("scope", "")) == "spec:%s" % spec,
					"%s: grant %d was scope '%s', not the spec's own set" % [
						spec, i, rune.get("scope", "")])
				ok(not names.has(String(rune["name"])),
					"%s: grant %d duplicated '%s' — the payload would double-apply" % [
						spec, i, rune.get("name", "")])
				names[String(rune["name"])] = true
				member["runes"] = member["runes"] + [rune]
			# One ask past the spec's surviving set must fall back to the
			# ordinary roll rather than returning nothing.
			var extra: Dictionary = run.grant_rune(member)
			ok(not extra.is_empty(), "%s: the grant died once the spec set ran out" % spec)
	run.sim_run = had_sim
