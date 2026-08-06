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
	_scarred(data)
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

const RARITY_KEYS := ["common", "rare", "epic"]
const PAYLOAD_BRANCHES := ["stat", "ability", "grant_ability", "new_ability"]


func _schema(data: Dictionary) -> void:
	var seen_names := {}
	for id in data:
		var e: Dictionary = data[id]
		ok(e.has("name") and String(e["name"]) != "", "%s: no name" % id)
		ok(e.has("rarity") and RARITY_KEYS.has(String(e["rarity"])),
			"%s: bad rarity" % id)
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
		# Scarred entries must undercut their clean rarity peer, or the trade
		# only shows in the tooltip and never in the shop.
		var base_price: int = int(Runes.RARITIES[String(e["rarity"])]["price"])
		if bool(e.get("scarred", false)):
			ok(int(e["price"]) < base_price,
				"%s: scarred but priced >= its clean peer (%d vs %d)" % [
					id, int(e["price"]), base_price])


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
		# And SOME hero this rune can roll for must actually own it.
		ok(_reachable(e, req),
			"%s: requires_ability '%s' is in no eligible hero's derivable kit" % [id, req])


func _reachable(entry: Dictionary, ability_name: String) -> bool:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var member := {"key": key, "spec": spec, "runes": []}
			if not Runes.eligible_ids(member, "", []).has(_id_of(entry)):
				continue
			if Runes.kit_names(member).has(ability_name):
				return true
	return false


func _id_of(entry: Dictionary) -> String:
	for id in Runes.ids():
		if Runes.config(id) == entry:
			return id
	return ""


# ---------- scarred ----------

# A scarred payload MUST carry a real cost. Negative numbers are the cost in
# every branch: a stat term below zero, or an ability field reduced.
# Fields whose PENALTY reads as a positive number — "+15% damage taken" is a
# cost even though the term is +0.15. Batch X's Glass Rune is the precedent;
# without this list the check would reject an already-shipped rune.
const PENALTY_FIELDS := ["dmg_taken_bonus"]


func _scarred(data: Dictionary) -> void:
	for id in data:
		var e: Dictionary = data[id]
		if not bool(e.get("scarred", false)):
			continue
		var pay: Dictionary = e["payload"]
		var negative := false
		for field in pay.get("stat", {}):
			if float(pay["stat"][field]) < 0.0:
				negative = true
			elif PENALTY_FIELDS.has(String(field)) and float(pay["stat"][field]) > 0.0:
				negative = true
		for part in ["add"]:
			for field in pay.get(part, {}):
				if float(pay[part][field]) < 0.0:
					negative = true
		ok(negative, "%s: scarred but its payload carries no negative term" % id)
		ok(String(e["rarity"]) != "common", "%s: scarred commons are not a thing" % id)
		ok(Runes.display_name(e).begins_with(Runes.SCARRED_PREFIX),
			"%s: scarred rune does not wear the Scarred prefix" % id)


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
			# Rolls for its own spec...
			var mine := {"key": owner_key, "spec": spec, "runes": []}
			ok(Runes.eligible_ids(mine, "", []).has(id),
				"%s: does not roll for its own spec" % id)
			# ...and for nobody else's.
			for key in Classes.SPEC_IDS:
				for other in Classes.SPEC_IDS[key]:
					if other == spec:
						continue
					var theirs := {"key": key, "spec": other, "runes": []}
					ok(not Runes.eligible_ids(theirs, "", []).has(id),
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
			var mine: Array = []
			for id in data:
				if String(data[id].get("scope", "")) == "spec:%s" % spec:
					mine.append(id)
			ok(mine.size() == 4, "%s: has %d spec runes, expected 4" % [spec, mine.size()])
			# Lanes come out of LANE_TREES, never a written list (Batch Y's
			# 70%-vs-53% drift is the precedent for not trusting prose).
			var tree_lanes := {}
			for node in Talents.generate_tree(spec, key):
				if String(node.get("lane", "")) != "":
					tree_lanes[String(node["lane"])] = true
			var covered := {}
			var splash := 0
			var scarred_on_lane := 0
			var scarred_splash := 0
			for id in mine:
				var lane := String(data[id].get("lane", ""))
				var is_scarred := bool(data[id].get("scarred", false))
				if lane == "":
					splash += 1
					if is_scarred:
						scarred_splash += 1
					continue
				if is_scarred:
					scarred_on_lane += 1
				ok(tree_lanes.has(lane),
					"%s: rune %s names lane '%s', which is not in its LANE_TREES entry" % [
						spec, id, lane])
				ok(not covered.has(lane), "%s: two runes on lane '%s'" % [spec, lane])
				covered[lane] = true
			ok(splash == 1, "%s: %d splash runes, expected exactly 1" % [spec, splash])
			ok(covered.size() == tree_lanes.size(),
				"%s: covers %d of %d lanes" % [spec, covered.size(), tree_lanes.size()])
			# Exactly one scarred per set, and it sits ON a lane — the splash
			# is the clean, always-fine pick.
			ok(scarred_on_lane == 1,
				"%s: %d scarred lane runes, expected exactly 1" % [spec, scarred_on_lane])
			ok(scarred_splash == 0, "%s: the splash rune is scarred" % spec)
	ok(specs_seen == 12, "expected 12 specs, walked %d" % specs_seen)


# ---------- exclusive pairs ----------

# The tree makes some choices mutually exclusive. A rune writing one side's
# counter would hand a player the road they declined, which is a design
# decision no rune should be able to overrule silently.
func _exclusives(data: Dictionary) -> void:
	var barred := {}
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			for node in Talents.generate_tree(spec, key):
				if String(node.get("exclusive_with", "")) == "":
					continue
				for field in node.get("payload", {}).get("stat", {}):
					barred["%s/%s" % [spec, field]] = String(node["id"])
	for id in data:
		var scope := String(data[id].get("scope", ""))
		if not scope.begins_with("spec:"):
			continue
		var spec := scope.trim_prefix("spec:")
		for field in data[id].get("payload", {}).get("stat", {}):
			var probe_key := "%s/%s" % [spec, field]
			ok(not barred.has(probe_key),
				"%s: writes '%s', one half of the exclusive pair %s" % [
					id, field, barred.get(probe_key, "")])
	# POSITIVE CONTROL. The alarm above reads the trees, so it silently stops
	# watching anything a rename drops out of them. These are the pairs the
	# batches called out by name; if one vanishes, the barred map is wrong,
	# not the design.
	var must_bar := {
		"beastmaster/lone_bond": "Lone Bond", "beastmaster/wild_rotation": "Wild Rotation",
		"beastmaster/steadfast_bond": "Steadfast Bond", "beastmaster/vengeance": "Vengeance",
		"mystic/virulence_ranks": "Virulence", "mystic/slow_acting": "Slow Acting",
		"mystic/deadfall_network": "Deadfall Network", "mystic/plague_bearer": "Plague Bearer",
		"sharpshooter/spray": "Spray of Arrows", "sharpshooter/tunnel_vision": "Tunnel Vision",
		"pyromancer/heat_haze_ranks": "Firebrand", "cryomancer/cold_snap_ranks": "Cold Snap",
		"arcanist/arcane_ward_ranks": "Arcane Ward", "holy/cascade_ranks": "Radiant Cascade",
		"inquisitor/stalwart_ranks": "Stalwart", "occultist/pact_flesh_ranks": "Pact Flesh",
		"warden/spite_ranks": "Spite", "berserker/dmg_taken_bonus": "Reckless",
		"swordmaster/punishment_ranks": "Punishment",
	}
	for probe_key in must_bar:
		ok(barred.has(probe_key),
			"exclusive alarm no longer watches %s (%s) — a rename slipped through" % [
				probe_key, must_bar[probe_key]])


# ---------- call-site ordering ----------

# Batch AA: the ceilings (Resonance / Mercy / Focus) are derived FROM cfg, so
# they must be computed after runes have written into it. This assertion is
# the regression alarm: if the derivations ever move back above the rune
# block, every ceiling rune becomes a silent dud again.
func _ordering(battle_src: String) -> void:
	var rune_at := battle_src.find("Talents.apply_payload(cfg, rune[\"payload\"], 1)")
	ok(rune_at >= 0, "battle.gd: the rune apply site is gone")
	# Batch AA moved these derivations below the rune block. The Focus three
	# were the reason ("the Hunter batch would have hit this on Focus") and
	# Batch AB is the first time runes actually write them.
	for probe in ["resonant_core_ranks", "mercy_cap_bonus", "zealous_mercy",
			"deep_focus", "spray", "opening_volley"]:
		var derive_at := battle_src.find("cfg.get(\"%s\"" % probe)
		ok(derive_at >= 0, "battle.gd: no derivation reads %s" % probe)
		ok(derive_at > rune_at,
			"battle.gd: %s is derived BEFORE runes apply — ceiling runes are duds" % probe)
	# ...and the pool must actually hold a rune that writes a ceiling field,
	# or the assertion above is guarding a road nothing drives on.
	var ceiling_writers := 0
	for id in Runes.ids():
		for field in Runes.config(id).get("payload", {}).get("stat", {}):
			if String(field) in ["deep_focus", "opening_volley", "spray",
					"resonant_core_ranks", "mercy_cap_bonus", "zealous_mercy"]:
				ceiling_writers += 1
	ok(ceiling_writers >= 4,
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
# roll still gets something (the pool widens, then falls to the Common family).
func _exhaustion() -> void:
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var member := {"key": key, "spec": spec, "runes": []}
			var owned: Array = []
			for id in Runes.eligible_ids(member, "", []):
				owned.append({"name": Runes.display_name(Runes.config(id))})
			for t in Runes.TEMPLATES:
				owned.append({"name": "Cracked Rune of %s" % t["noun"]})
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
		ok(run.rune_slots() == 2 + z,
			"flags unset: rune_slots should be the shipped 2/3/4 ladder at zone %d" % z)

	# 2. Both SET, but NOT a sim: the flags must be unreachable.
	OS.set_environment("DOD_SIM_RUNE_ECON", "rich")
	OS.set_environment("DOD_SIM_RUNE_POWER", "3.0")
	for z in 3:
		run.zone_idx = z
		ok(run.rune_econ() == "normal",
			"REAL PLAY WITH THE ENV SET reached the rich arm — purity violated")
		ok(is_equal_approx(run.rune_power(), 1.0),
			"REAL PLAY WITH THE ENV SET reached the power arm — purity violated")
		ok(run.rune_slots() == 2 + z,
			"REAL PLAY WITH THE ENV SET moved the slot ladder at zone %d" % z)
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
	var stick: Dictionary = run._apply_rune_power(Runes.template_rune("warrior", "common", "Vitality"))
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
const UNSCALABLE := ["comet", "binding_souls", "last_rites", "flayed_mind",
	"quick_spring"]


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
	_scarred(scaled_data)


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
const BOOLEAN_READ_FIELDS := {
	"coated_blades": "coated_blades > 0",
	"deep_focus": "deep_focus\", 0) > 0",
	"perfect_form": "perfect_form > 0",
	"opening_volley": "opening_volley\", 0) > 0",
	"vulture": "vulture > 0",
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
			if line.contains("* %s" % field) or line.contains("%s *" % field) \
					or line.contains("+ %s" % field) or line.contains("%s +" % field):
				arith = true
		ok(not arith,
			"%s now has an arithmetic read site — it is no longer magnitude-free" % field)
		for id in data:
			var v = data[id]["payload"].get("stat", {}).get(field, null)
			if v == null:
				continue
			ok(int(v) == 1,
				"%s writes %s = %s, but that field is a boolean gate — any value above 1 does nothing" % [
					id, field, v])
	# The Deep Sight carries NOTHING BUT boolean fields, so no magnitude pass
	# can ever move it. Named so that a future pass reports it rather than
	# quietly shipping an entry that got relatively weaker for free.
	var ds: Dictionary = data["deep_sight"]["payload"]["stat"]
	var ds_scalable := 0
	for f in ds:
		if not BOOLEAN_READ_FIELDS.has(f):
			ds_scalable += 1
	ok(ds_scalable == 0,
		"deep_sight gained a scalable field — it is no longer magnitude-proof")


# ---------- Batch AE: what the opening pick can actually deal ----------
#
# The batch's whole deliverable is one pick of three at spec confirmation,
# rolled through the ORDINARY roller at zone slot 1. The report-back the
# designer asked for is how often that triple contains a spec-scoped rune,
# and the sim measured 36-42% across ten rows. That number is a property of
# the POOL and the slot-1 rarity weights, so it belongs in a test: if a
# future batch adds spec entries or moves RARITY_WEIGHTS, this is the check
# that tells the designer the opening-pick hit rate moved with it.
func _start_rune_pool(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.sim_run = false
	ok(run.start_rune_enabled(), "the start rune is off by default — AE ships it ON")
	var trials := 0
	var with_spec := 0
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			for i in 12:
				var member := {"key": key, "spec": spec, "runes": [],
					"bm_abilities": []}
				var triple: Array = run.roll_rune_candidates(member)
				ok(triple.size() == 3,
					"%s: the opening deal rolled %d candidates" % [spec, triple.size()])
				trials += 1
				for c in triple:
					if String(c.get("scope", "")) == "spec:%s" % spec:
						with_spec += 1
						break
	var rate := 100.0 * with_spec / maxf(float(trials), 1.0)
	# Deliberately a WIDE band: this is a drift alarm on the pool, not a
	# balance assertion. The measured sim figure sits near the middle of it.
	ok(rate > 20.0 and rate < 70.0,
		"a spec rune is in the opening triple %.0f%% of the time — outside the 20-70%% band Batch AE measured (36-42%%); the pool or RARITY_WEIGHTS moved" % rate)
	print("  (Batch AE report-back: a spec-scoped rune is among the opening three %.0f%% of the time)" % rate)
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
# The arm exists to put the FOUR runes written for a spec on that spec's
# hero. If the grant handed out universals it would probe a different
# question, and if it handed out duplicates the payload would double-apply.
func _rich_grant(run: Node) -> void:
	var had_sim: bool = run.sim_run
	run.sim_run = true
	for key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[key]:
			var member := {"key": key, "spec": spec, "runes": []}
			var names := {}
			for i in 4:
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
			# A fifth ask exhausts the spec's four and must fall back to the
			# ordinary roll rather than returning nothing.
			var extra: Dictionary = run.grant_rune(member)
			ok(not extra.is_empty(), "%s: the grant died once the spec set ran out" % spec)
	run.sim_run = had_sim
