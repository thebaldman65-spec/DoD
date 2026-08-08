# test_batch_av.gd — HOLY: REVERSAL. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_av.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §0 THE INSTRUMENT. Nothing here reads damage share. She attacks at 50 and
#      the whole spec is contribution, so the live probes read healing landed
#      and damage prevented.
#   §1 RESURRECTION IN THE OPENING KIT — present at spawn with NO talent
#      learned, absent from SPEC_POOLS["holy"], and exactly ONE def of it in
#      the codebase (the kit calls Classes.pending_talent_ability).
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, the lane renamed VIGIL, every
#      final magnitude on the node that owes it, and every counter ADDITIVE.
#   §4 BOTH AUTHORED FALLBACKS (Divine Plea -> 1 Mercy, Intercession -> a
#      3-turn window), and AU §1's rule reaching a RUNE grant (Last Rites).
#   §5 THE RUNE AUDIT: every re-pointed counter lands on a live read site, the
#      Sleepless Vigil's by-name lane moved with the lane, and the three
#      cleric class-wide runes touch no Holy counter.
#   §6 THE BOT knows Resurrection and Intercession, and never Empowers down
#      past a raise it could otherwise make.
#   LIVE: Intercession fires once, costs a stack ON TRIGGER and not on cast,
#      and does nothing when she holds none. Serenity's cost waiver, and that
#      it does NOT alter the return health. Grace only at maximum Mercy.
#      Martyrdom's automatic return. Shared Vigil and Blessed Vestments.
#   NEGATIVE CONTROLS for the two that would fail silently: Guardian Angel
#      back at 53%, and Serenity also setting the return health to full.
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
	Profile.save_path = "user://profile_batch_av_test.json"
	Profile.loaded = false
	Profile.data = {}

	_kit_and_pool()
	_tree_shape()
	_magnitudes()
	_additive_units()
	_authored_fallbacks()
	_rune_audit()
	_negative_control_source()

	await _live_kit_at_spawn()
	await _live_intercession()
	await _live_serenity()
	await _live_grace()
	await _live_martyrdom()
	await _live_vigil_and_vestments()
	await _live_last_rites_rune()
	await _live_bot_policy()
	await _live_avatar()

	if FileAccess.file_exists("user://profile_batch_av_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_av_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_av: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("holy", "cleric")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _find(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


func _hero(scene: Node, idx: int) -> BattleUnit:
	var live: Array = []
	for h in scene.get("heroes"):
		if not h.is_companion:
			live.append(h)
	return live[idx] if idx < live.size() else null


# The party is warrior/mage/cleric/hunter, so the Cleric is slot 2 and the
# learned dict is applied to HER, not to slot 1 as the AU harness did.
func _spawn(learned: Dictionary, member_patch := {},
		lineup := ["raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "holy", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 2 else {}
		run.sync_spec_hp(i)
	for key in member_patch:
		run.party[2][key] = member_patch[key]
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT/AU discipline). The
	# CRIT roll matters more here than anywhere: Triage turns a heal crit into
	# a Radiant Cascade splash, so one unlucky coin doubles a measured heal.
	# Checks that WANT a crit set crit_bonus back themselves.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the
	# next spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


# ---------- §1 the kit and the pool ----------

func _kit_and_pool() -> void:
	var kit: Array = Classes.spec_abilities("holy")
	var names: Array = []
	for ab in kit:
		names.append(ab.display_name)
	ok(names.has("Resurrection"),
		"Resurrection is in the Holy opening kit (got %s)" % str(names))
	ok(names.size() == 4,
		"...and the kit is FOUR abilities, the deliberate parity break (got %d)" % names.size())
	for expected in ["Heal", "Renewal", "Hymn of Hope"]:
		ok(names.has(expected), "the original three survive: %s" % expected)
	# A boss cannot offer what she starts with.
	ok(not Classes.SPEC_POOLS["holy"].has("Resurrection"),
		"Resurrection LEFT SPEC_POOLS[holy] (%s)" % str(Classes.SPEC_POOLS["holy"]))
	ok(Classes.SPEC_POOLS["holy"].has("Divine Plea"),
		"...and Divine Plea is still earnable")
	# Intercession reads Mercy on trigger, so it can never be class-pool
	# eligible and is deliberately not in the spec pool either.
	ok(not Classes.SPEC_POOLS["holy"].has("Intercession"),
		"Intercession is a tree grant only, not a pool entry")
	ok(not Classes.CLASS_POOLS["cleric"].has("Resurrection")
		and not Classes.CLASS_POOLS["cleric"].has("Intercession"),
		"neither Mercy spender leaked into CLASS_POOLS[cleric]")
	# EXACTLY ONE DEF (the AK resolver rule): the kit list calls
	# pending_talent_ability rather than holding a second copy, so the rune
	# grant, the pool resolver and the kit can never drift apart.
	var csrc := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(csrc.count("\"display_name\": \"Resurrection\"") == 1,
		"exactly one Resurrection def exists in classes.gd")
	ok(csrc.contains("pending_talent_ability(\"Resurrection\")"),
		"...and the kit reads it from that one def")
	var res: Ability = Classes.pending_talent_ability("Resurrection")
	ok(res != null and res.faith_cost == 1 and res.cooldown == 3
		and is_equal_approx(res.delay, 4.0) and res.special == "resurrection",
		"Resurrection moved UNCHANGED: 1 Mercy, 4.0 initiative, 3cd")
	var icept: Ability = Classes.pending_talent_ability("Intercession")
	ok(icept != null, "Intercession has a def")
	if icept != null:
		ok(icept.cost == 25 and icept.cooldown == 4
			and is_equal_approx(icept.delay, 2.0),
			"Intercession is 25 Mana, 2.0 initiative, 4cd")
		ok(icept.faith_cost == 0,
			"Intercession carries NO faith_cost — the Mercy is paid on trigger")


# ---------- §3 the shape ----------

func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 24, "the Holy tree holds 24 nodes (got %d)" % tree.size())
	var lanes := {}
	var per_lane := {}
	var caps: Array = []
	var ids := {}
	for t in tree:
		var lane := String(t.get("lane", ""))
		var row := int(t.get("row", 0))
		lanes[lane] = true
		ids[String(t["id"])] = true
		if row == Talents.CAPSTONE_ROW:
			caps.append(String(t["id"]))
			ok(bool(t.get("capstone", false)),
				"%s sits on row 8 and carries the capstone flag" % t["id"])
		else:
			per_lane[lane] = int(per_lane.get(lane, 0)) + 1
			ok(not bool(t.get("capstone", false)),
				"%s is not on row 8 and must not claim the flag" % t["id"])
		ok(int(t.get("ranks", 0)) == 1, "%s is a single rank" % t["id"])
		ok(not t.has("exclusive_with"),
			"%s carries no leftover exclusive_with" % t["id"])
	ok(lanes.has("Radiance") and lanes.has("Mercy") and lanes.has("Vigil"),
		"the lanes are Radiance / Mercy / VIGIL (got %s)" % str(lanes.keys()))
	ok(not lanes.has("Sanctuary"),
		"NOTHING still calls the third lane Sanctuary")
	for lane in ["Radiance", "Mercy", "Vigil"]:
		ok(int(per_lane.get(lane, 0)) == 7,
			"%s holds 7 nodes in rows 1-7 (got %s)" % [lane, per_lane.get(lane, 0)])
	ok(caps.size() == 3, "three capstones (got %d)" % caps.size())
	# EVERY ID SURVIVES — the batch's own promise, and the reason no save
	# version moves. This is the list Batch AI shipped, checked verbatim.
	for id in ["hl_triage", "hl_soothe", "hl_on_mend", "hl_capacitor", "hl_swift",
			"hl_brilliance", "hl_overflow", "hl_heavenly", "hl_holy_light",
			"hl_zealous", "hl_sanctified", "hl_resurrection", "hl_ardor",
			"hl_martyr", "hl_guardian", "hl_presence", "hl_last_hope",
			"hl_inner_faith", "hl_vestments", "hl_beacon", "hl_serenity",
			"hl_divine_plea", "hl_avatar", "hl_sanctum"]:
		ok(ids.has(id), "id survives and re-specs in place: %s" % id)
	ok(ids.size() == 24, "no id was added (got %d distinct)" % ids.size())
	# The homes the batch names by hand.
	for pair in [["hl_divine_plea", "Radiance", 4], ["hl_resurrection", "Mercy", 5],
			["hl_inner_faith", "Vigil", 4], ["hl_beacon", "Vigil", 5],
			["hl_vestments", "Vigil", 6], ["hl_serenity", "Vigil", 7],
			["hl_sanctum", "Radiance", 8], ["hl_avatar", "Mercy", 8],
			["hl_capacitor", "Vigil", 8]]:
		var n := _node(String(pair[0]))
		ok(String(n.get("lane", "")) == String(pair[1])
			and int(n.get("row", 0)) == int(pair[2]),
			"%s sits at %s row %d (got %s row %s)" % [pair[0], pair[1], pair[2],
				n.get("lane", ""), n.get("row", 0)])
	# The renames, by name rather than by id — a re-spec that forgot its label
	# would pass every structural check above.
	for pair in [["hl_resurrection", "Grace"], ["hl_inner_faith", "Intercession"],
			["hl_beacon", "Shared Vigil"], ["hl_capacitor", "Martyrdom"],
			["hl_sanctum", "Sanctum"], ["hl_serenity", "Serenity"],
			["hl_vestments", "Blessed Vestments"]]:
		ok(String(_node(String(pair[0])).get("name", "")) == String(pair[1]),
			"%s is named %s" % [pair[0], pair[1]])


# ---------- §3 the magnitudes, which are final ----------

func _magnitudes() -> void:
	for probe in [
			["hl_triage", "triage_heal", 15],
			["hl_on_mend", "on_mend_pct", 35],
			["hl_brilliance", "cascade_pct", 75],
			["hl_overflow", "overflow_pct", 60],
			["hl_heavenly", "heavenly_step", 7],      # 5 + 7 = 12%
			["hl_holy_light", "holy_light_pct", 8],
			["hl_zealous", "zealous_mercy", 2],
			["hl_sanctified", "sanctified_pct", 35],
			["hl_resurrection", "grace_pct", 20],
			["hl_ardor", "ardor_at", 3],
			["hl_martyr", "mercy_cap_bonus", 3],      # 5 + 3 = 8
			["hl_guardian", "guardian_step", 15],     # 50 + 15 = 65%
			["hl_presence", "divine_presence_pct", 8],
			["hl_last_hope", "last_hope_pct", 40],
			["hl_beacon", "holy_vigil_pct", 15],
			["hl_vestments", "vestments_pct", 25],
			["hl_sanctum", "sanctum", 1],
			["hl_avatar", "avatar_of_mercy", 1]]:
		var got = _stat_of(String(probe[0]), String(probe[1]))
		ok(got != null and int(got) == int(probe[2]),
			"%s writes %s = %s (got %s)" % [probe[0], probe[1], probe[2], got])
	# The two ability-payload nodes: written that way so no field EXISTS that
	# could reach the health an ally returns at.
	var sooth := _payload("hl_soothe")
	ok(int(sooth.get("add", {}).get("cost", 0)) == -10
		and String(sooth.get("ability", "")) == "Heal",
		"Soothing Touch takes 10 Mana off Heal")
	var sooth_also: Array = sooth.get("also", [])
	ok(sooth_also.size() == 1
		and String(sooth_also[0].get("ability", "")) == "Renewal"
		and int(sooth_also[0].get("add", {}).get("cost", 0)) == -10,
		"...and 10 off Renewal")
	var swift := _payload("hl_swift")
	ok(int(swift.get("set", {}).get("cooldown", -1)) == 0
		and String(swift.get("ability", "")) == "Heal",
		"Swift Mending zeroes Heal's cooldown outright")
	var swift_also: Array = swift.get("also", [])
	ok(swift_also.size() == 1
		and String(swift_also[0].get("ability", "")) == "Hymn of Hope"
		and int(swift_also[0].get("add", {}).get("cooldown", 0)) == -1,
		"...and takes a turn off Hymn of Hope")
	var ser := _payload("hl_serenity")
	ok(String(ser.get("ability", "")) == "Resurrection"
		and int(ser.get("set", {}).get("faith_cost", -1)) == 0
		and int(ser.get("set", {}).get("cooldown", -1)) == 1,
		"Serenity waives the Mercy and drops the cooldown to 1")
	var ser_writes: Array = []
	for part in ["stat", "set", "add"]:
		for f in ser.get(part, {}):
			ser_writes.append(String(f))
	for extra in ser.get("also", []):
		for part2 in ["stat", "set", "add"]:
			for f2 in extra.get(part2, {}):
				ser_writes.append(String(f2))
	ok(ser_writes.size() == 2 and ser_writes.has("faith_cost")
		and ser_writes.has("cooldown"),
		"...and touches NOTHING ELSE — nothing that could reach the return health (%s)" % str(ser_writes))
	var mar := _payload("hl_capacitor")
	var mar_also: Array = mar.get("also", [])
	ok(mar_also.size() == 1
		and int(mar_also[0].get("stat", {}).get("martyrdom", 0)) == 1,
		"Martyrdom's automatic return rides the `also` half of its payload")
	ok(String(mar.get("ability", "")) == "Resurrection"
		and int(mar.get("set", {}).get("faith_cost", -1)) == 0
		and int(mar.get("set", {}).get("cooldown", -1)) == 0,
		"Martyrdom waives the Mercy and the cooldown entirely")
	# Row 8 is one per hero, ever — so the three must be on three lanes.
	var cap_lanes := {}
	for t in _tree():
		if int(t.get("row", 0)) == Talents.CAPSTONE_ROW:
			cap_lanes[String(t.get("lane", ""))] = true
	ok(cap_lanes.size() == 3, "the three capstones sit on three different lanes")


# ---------- §5 additive, not ranked ----------

# Every counter must hold its OWN magnitude in the units its read site sums.
# Asserted against the SOURCE, because a read site that still multiplies by a
# rank pays a node's 15 as 45 and nothing crashes.
func _additive_units() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for pair in [
			["0.01 * caster.triage_heal", "Triage"],
			["0.01 * (5 + caster.heavenly_step) * caster.second_resource", "Heavenly Aura"],
			["0.01 * attacker.holy_light_pct", "Holy Light"],
			["0.01 * mend_pct", "On the Mend"],
			["0.01 * caster.cascade_pct", "Radiant Cascade"],
			["0.01 * _overflow_share(caster)", "Overflow"],
			["* u.divine_presence_pct * _healing_done_mult(u)", "Divine Presence"],
			["0.01 * hv_c.holy_vigil_pct", "Shared Vigil"],
			["0.01 * caster.vestments_pct", "Blessed Vestments"],
			["0.01 * cleric.grace_pct", "Grace"],
			["0.01 * cleric.sanctified_pct", "Sanctified"],
			["0.5 + 0.01 * ga_step", "Guardian Angel"]]:
		ok(bsrc.contains(String(pair[0])),
			"%s reads its counter additively (%s)" % [pair[1], pair[0]])
	ok(usrc.contains("0.01 * last_hope_bonus"),
		"Last Hope reads its stamp additively")
	# No old ranked read site may survive anywhere.
	for dead in ["triage_ranks", "heavenly_ranks", "holy_light_ranks",
			"guardian_ranks", "last_hope_ranks", "on_mend_ranks",
			"sanctified_ranks", "cascade_ranks", "overflow_ranks",
			"ardor_ranks", "vestments_ranks", "divine_presence_ranks",
			"living_sanctum", "serenity_guard"]:
		ok(not bsrc.contains(dead) and not usrc.contains(dead),
			"the ranked counter %s is gone from every read site" % dead)
	# THE ONE PLACE THE SANCTIFIED ROLL HAPPENS — three spenders, one rule.
	ok(bsrc.count("func _sanctified_refund") == 1
		and bsrc.count("_sanctified_refund(") == 4,
		"the Sanctified roll has one definition and three callers (faith_cost, Empower, Intercession)")
	# THE ONE PLACE THE OVERFLOW SHARE IS DECIDED.
	ok(bsrc.count("func _overflow_share") == 1,
		"the overflow share has exactly one implementation")
	# RUNE-ONLY, READ SITES KEPT (the AR vault pattern) rather than deleted.
	for kept in ["capacitor_ranks", "beacon_ranks"]:
		ok(bsrc.contains(kept) and usrc.contains(kept),
			"%s is rune-only now but its read site is KEPT and gated" % kept)


# ---------- §4 the two authored fallbacks ----------

func _authored_fallbacks() -> void:
	var plea := _payload("hl_divine_plea")
	ok(Talents.collision_kind(plea) == "authored",
		"Divine Plea's node carries an AUTHORED fallback, not the generic")
	var plea_up: Array = plea.get("upgrade", [])
	ok(plea_up.size() == 1
		and String(plea_up[0].get("ability", "")) == "Divine Plea"
		and int(plea_up[0].get("set", {}).get("faith_cost", -1)) == 1,
		"...already owned -> Divine Plea costs 1 Mercy instead of 2")
	var ice := _payload("hl_inner_faith")
	ok(Talents.collision_kind(ice) == "authored",
		"Intercession's node carries an AUTHORED fallback")
	var ice_up: Array = ice.get("upgrade", [])
	ok(ice_up.size() == 1
		and int(ice_up[0].get("stat", {}).get("intercession_long", 0)) == 1,
		"...already owned -> the window lasts a turn longer")
	# Her three capstones are passives or ability edits, so none of them grants
	# an ability and none of them needs a fallback at all.
	for cap in ["hl_sanctum", "hl_avatar", "hl_capacitor"]:
		ok(Talents.granted_name(_payload(cap)) == "",
			"%s grants no ability, so it owes no fallback" % cap)
	# AU §1's rule reaching a RUNE grant needed no new machinery, and that is
	# the finding: runes share Talents.apply_payload, so _collided already
	# fires for them and Run.apply_upgrades already runs after the rune pass.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var rune_at := bsrc.find("Talents.apply_payload(cfg, rune[\"payload\"]")
	var upg_at := bsrc.find("Run.apply_upgrades(Run.party[i]")
	ok(rune_at > 0 and upg_at > rune_at,
		"the rune pass runs BEFORE apply_upgrades, so a rune grant's fallback resolves")


# ---------- §5 the rune audit ----------

func _rune_audit() -> void:
	var probe := BattleUnit.new()
	for id in ["triage_ward", "sleepless_vigil", "open_hand"]:
		var e: Dictionary = Runes.config(id)
		ok(String(e.get("scope", "")) == "spec:holy", "%s is a Holy spec rune" % id)
		for field in Runes.build(id)["payload"].get("stat", {}):
			var f := String(field)
			ok(f in probe, "%s writes a LIVE field: %s" % [id, f])
			# JSON parses every number as a float and BattleUnit.setup() pushes
			# cfg straight into typed vars — the Batch AA trap, and every one
			# of these fields is an int.
			ok(typeof(Runes.build(id)["payload"]["stat"][f]) == TYPE_INT
					or f == "speed",
				"%s: %s survived typing as an int" % [id, f])
	probe.free()
	# The re-points, by their advertised numbers.
	var tw: Dictionary = Runes.build("triage_ward")["payload"]["stat"]
	ok(int(tw.get("triage_heal", 0)) == 3,
		"the Triage Ward pays its advertised 3%% (got %s)" % tw.get("triage_heal", 0))
	var oh: Dictionary = Runes.build("open_hand")["payload"]["stat"]
	ok(int(oh.get("triage_heal", 0)) == 3 and int(oh.get("last_hope_pct", 0)) == 5
		and int(oh.get("zealous_mercy", 0)) == 1,
		"the Open Hand pays 3%% healing, 1 opening Mercy and 5%% to the nearly-dead")
	var sv: Dictionary = Runes.build("sleepless_vigil")["payload"]["stat"]
	ok(int(sv.get("divine_presence_pct", 0)) == 2,
		"the Sleepless Vigil pays its advertised 2%%")
	# THE BY-NAME LANE REFERENCE, which is exactly the kind that breaks
	# quietly: a dead lane name would leave the rune homeless in the bot's
	# build policy and in the per-lane coverage test.
	ok(String(Runes.config("sleepless_vigil").get("lane", "")) == "Vigil",
		"the Sleepless Vigil's lane tag moved Sanctuary -> Vigil")
	var lanes := {}
	for t in _tree():
		lanes[String(t.get("lane", ""))] = true
	for id in Runes.ids():
		var cfg: Dictionary = Runes.config(id)
		if String(cfg.get("scope", "")) != "spec:holy":
			continue
		var lane := String(cfg.get("lane", ""))
		ok(lane == "" or lanes.has(lane),
			"%s's lane tag '%s' names a live Holy lane" % [id, lane])
	# THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO HOLY COUNTER.
	var holy_fields := {}
	for t in _tree():
		for f in t.get("payload", {}).get("stat", {}):
			holy_fields[String(f)] = true
		for extra in t.get("payload", {}).get("also", []):
			for f2 in extra.get("stat", {}):
				holy_fields[String(f2)] = true
	for id in ["zealotry", "martyr", "binding_souls"]:
		var cfg2: Dictionary = Runes.config(id)
		ok(String(cfg2.get("scope", "")) == "class:cleric", "%s is class-wide" % id)
		for f3 in cfg2["payload"].get("stat", {}):
			ok(not holy_fields.has(String(f3)),
				"%s must not write the Holy tree counter %s" % [id, f3])
	# LAST RITES: its grant now COLLIDES rather than granting, so its text has
	# to stop promising an ability she already owns.
	var lr: Dictionary = Runes.config("last_rites")
	ok(not String(lr.get("desc", "")).begins_with("Grants RESURRECTION"),
		"the Last Rites no longer advertises granting what she starts with")


# ---------- negative controls ----------

# The two that would fail SILENTLY: a Guardian Angel still paying the old 53%
# window reads as a working node, and a Serenity that also set the return
# health to full would look like a generous capstone rather than a bug that
# makes Empower pointless.
func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not bsrc.contains("0.5 + 0.03 *"),
		"NEGATIVE CONTROL: no path leaves the Mercy window at 50 + 3 (the old 53%)")
	var ga := int(_stat_of("hl_guardian", "guardian_step"))
	ok(ga == 15, "NEGATIVE CONTROL: Guardian Angel is 15 points, not 3")
	var ser := _payload("hl_serenity")
	var mar := _payload("hl_capacitor")
	for pay in [ser, mar]:
		for part in ["set", "add"]:
			for f in pay.get(part, {}):
				ok(String(f) in ["faith_cost", "cooldown"],
					"NEGATIVE CONTROL: a reversal node touches only cost and cooldown (found %s)" % f)
	# The return health lives in ONE place — the resurrection branch — and no
	# talent field reaches it.
	ok(bsrc.contains("var rez_frac := 0.25 if is_perfect else 0.2"),
		"the return health is still 20% / 25% perfect / 100% Empowered")
	# EXACTLY ONE reassignment exists — Empower's. A Serenity or Martyrdom that
	# also moved it would add a second, and would read as generosity rather
	# than as the thing that makes Empower pointless.
	ok(bsrc.count("rez_frac = ") == 1,
		"NEGATIVE CONTROL: only Empower may reassign the return health (found %d)" % bsrc.count("rez_frac = "))
	ok(not bsrc.contains("serenity") and not bsrc.contains("rez_frac = 1.0 if"),
		"NEGATIVE CONTROL: nothing named Serenity can reach rez_frac")


# ---------- live: the kit at spawn ----------

func _live_kit_at_spawn() -> void:
	var scene := await _spawn({})
	var c := _hero(scene, 2)
	ok(c != null and c.second_resource_name == "Mercy", "slot 2 is the Holy Cleric")
	var res := _find(c, "Resurrection")
	ok(res != null, "Resurrection is in hand at spawn with NO talent learned")
	if res != null:
		ok(res.faith_cost == 1 and res.cooldown == 3,
			"...at its unchanged 1 Mercy / 3cd")
	ok(_find(c, "Divine Plea") == null,
		"Divine Plea is NOT in hand without its node")
	ok(_find(c, "Intercession") == null,
		"Intercession is NOT in hand without its node")
	ok(c.second_resource == 0, "she opens at 0 Mercy without Zealous Light")
	ok(c.second_max == 5, "...against the base ceiling of 5")
	await _kill(scene)
	# The two grants, and the repriced openers, on a full build.
	var built := await _spawn({"hl_divine_plea": 1, "hl_inner_faith": 1,
		"hl_zealous": 1, "hl_martyr": 1, "hl_soothe": 1, "hl_swift": 1})
	var c2 := _hero(built, 2)
	ok(_find(c2, "Divine Plea") != null, "the row-4 node grants Divine Plea")
	ok(_find(c2, "Intercession") != null, "the Vigil row-4 node grants Intercession")
	ok(c2.second_resource == 2, "Zealous Light opens her on 2 Mercy (got %d)" % c2.second_resource)
	ok(c2.second_max == 8, "Martyr's Vigor raises the ceiling to 8 (got %d)" % c2.second_max)
	var heal := _find(c2, "Heal")
	var ren := _find(c2, "Renewal")
	var hymn := _find(c2, "Hymn of Hope")
	ok(heal != null and heal.cost == 10, "Soothing Touch: Heal costs 10 (got %s)" % heal.cost)
	ok(ren != null and ren.cost == 10, "...and Renewal costs 10 (got %s)" % ren.cost)
	ok(heal != null and heal.cooldown == 0, "Swift Mending: Heal has NO cooldown")
	ok(hymn != null and hymn.cooldown == 1, "...and Hymn drops to 1 (got %s)" % hymn.cooldown)
	await _kill(built)


# ---------- live: Intercession ----------

func _live_intercession() -> void:
	# (i) NOTHING WHEN SHE HOLDS NONE. The window is open, the blow lands, the
	# hero dies — the price is paid on TRIGGER, so an empty hand buys nothing.
	var empty := await _spawn({"hl_inner_faith": 1})
	var c := _hero(empty, 2)
	var victim := _hero(empty, 0)
	c.second_resource = 0
	# THE TRAP THIS LINE EXISTS FOR: a hero falling from ABOVE the Mercy
	# window crosses it on the way down and earns her the very stack the
	# refusal then spends — so the probe has to start the victim already
	# under the line, or it measures a net of zero and calls it a pass.
	victim.hp = int(victim.max_hp * 0.2)
	empty._apply_status(victim, "intercession", 2)
	victim.take_hit(victim.hp + 500, 0)
	ok(victim.dead,
		"holding NO Mercy, the refusal does not fire and the hero dies")
	ok(c.second_resource == 0, "...and nothing was spent")
	await _kill(empty)
	# (ii) IT FIRES, ONCE, AND COSTS A STACK ON TRIGGER.
	var live := await _spawn({"hl_inner_faith": 1})
	var c2 := _hero(live, 2)
	c2.second_resource = 3
	c2.sanctified_pct = 0  # the refund roll is a separate node; force the spend
	var v1 := _hero(live, 0)
	var v2 := _hero(live, 3)
	v1.hp = int(v1.max_hp * 0.2)   # already under the Mercy window (see above)
	v2.hp = int(v2.max_hp * 0.2)
	var before := c2.second_resource
	live._apply_status(v1, "intercession", 2)
	live._apply_status(v2, "intercession", 2)
	ok(before == 3, "she holds 3 Mercy with the window open — the CAST cost none")
	v1.take_hit(v1.hp + 500, 0)
	ok(not v1.dead and v1.hp == 1,
		"the lethal blow is refused: %s survives at 1 HP" % v1.unit_name)
	ok(c2.second_resource == before - 1,
		"...and exactly 1 Mercy leaves her hand ON TRIGGER (%d -> %d)" % [
			before, c2.second_resource])
	ok(not v1.has_status("intercession") and not v2.has_status("intercession"),
		"spending it clears the window for the WHOLE party")
	v2.take_hit(v2.hp + 500, 0)
	ok(v2.dead, "the second lethal blow lands — one refusal, not a standing ward")
	await _kill(live)
	# (ii-b) THE INTERACTION WORTH PINNING: a hero falling from FULL health
	# crosses the Mercy window on the way down, so their own fall earns her
	# the stack the refusal spends. It is free exactly once, and only against
	# a genuine one-shot — anyone already wounded pays for it properly.
	var oneshot := await _spawn({"hl_inner_faith": 1})
	var c5 := _hero(oneshot, 2)
	c5.second_resource = 0
	c5.sanctified_pct = 0
	var v3 := _hero(oneshot, 0)
	v3.hp = v3.max_hp
	oneshot._apply_status(v3, "intercession", 2)
	v3.take_hit(v3.hp + 500, 0)
	ok(not v3.dead and v3.hp == 1,
		"a one-shot from full health is refused even from an empty hand")
	ok(c5.second_resource == 0,
		"...because the fall itself earned the stack it spent (%d)" % c5.second_resource)
	await _kill(oneshot)
	# (iii) THE WINDOW LENGTH, cast for real, and the authored fallback.
	var short_w := await _spawn({"hl_inner_faith": 1})
	var c3 := _hero(short_w, 2)
	ok(c3.intercession_long == 0, "no fallback without an earned copy")
	await _kill(short_w)
	var long_w := await _spawn({"hl_inner_faith": 1},
		{"bm_abilities": ["Intercession"]})
	var c4 := _hero(long_w, 2)
	ok(c4.intercession_long == 1,
		"AUTHORED FALLBACK: already owned -> the window lasts a turn longer")
	ok(_find(c4, "Intercession") != null, "...and she still holds exactly one copy")
	var copies := 0
	for ab in c4.abilities:
		if ab.display_name == "Intercession":
			copies += 1
	ok(copies == 1, "no double grant (got %d copies)" % copies)
	await _kill(long_w)


# ---------- live: Serenity ----------

func _live_serenity() -> void:
	var plain := await _spawn({})
	var c0 := _hero(plain, 2)
	var r0 := _find(c0, "Resurrection")
	ok(r0 != null and r0.faith_cost == 1 and r0.cooldown == 3,
		"without Serenity the raise costs 1 Mercy on a 3-turn cooldown")
	await _kill(plain)
	var scene := await _spawn({"hl_serenity": 1})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	ok(res != null, "Resurrection is still in hand with Serenity learned")
	if res != null:
		ok(res.faith_cost == 0, "Serenity: the raise costs NO Mercy")
		ok(res.cooldown == 1, "...and its cooldown is 1 (got %s)" % res.cooldown)
		# THE THING THE BATCH SAYS IT MUST NOT DO. Empower's whole payload is
		# the return health; a Serenity that also set it would make Empower
		# pointless, and it would look like generosity rather than a bug.
		ok(res.special == "resurrection",
			"...and it is still the same ability, not a re-specced one")
	var fallen := _hero(scene, 0)
	fallen.take_hit(fallen.hp + 500, 0)
	ok(fallen.dead, "an ally falls")
	c.second_resource = 0
	await scene._resolve_special(c, res, fallen, "good", 1.0)
	ok(not fallen.dead, "...and she raises them holding NO Mercy at all")
	var frac := float(fallen.hp) / float(fallen.max_hp)
	ok(abs(frac - 0.2) < 0.03,
		"THE RETURN HEALTH IS UNTOUCHED at 20%% (got %.0f%%)" % (frac * 100.0))
	_report.append("Serenity raise returns %.0f%% health — Empower's 100%% is untouched"
		% (frac * 100.0))
	await _kill(scene)


# ---------- live: Grace ----------

func _live_grace() -> void:
	var scene := await _spawn({"hl_resurrection": 1})
	var c := _hero(scene, 2)
	ok(c.grace_pct == 20, "Grace is stamped at 20%% of her maximum health")
	var ally := _hero(scene, 0)
	# BELOW the ceiling: the crossing pays a STACK and Grace stays silent.
	c.second_resource = 0
	ally.hp = ally.max_hp
	ally.take_hit(int(ally.max_hp * 0.6), 0)
	ok(c.second_resource == 1, "below the ceiling, the crossing earns a stack")
	var hp_after_stack := ally.hp
	ok(hp_after_stack == ally.max_hp - int(ally.max_hp * 0.6),
		"...and Grace does NOT fire (no healing landed)")
	# AT the ceiling: the stack she cannot hold becomes healing.
	c.second_resource = c.second_max
	ally.hp = ally.max_hp
	var expected := int(round(c.max_hp * 0.20 * scene._healing_done_mult(c)))
	ally.take_hit(int(ally.max_hp * 0.6), 0)
	var landed := ally.hp - (ally.max_hp - int(ally.max_hp * 0.6))
	ok(c.second_resource == c.second_max, "at the ceiling she gains no stack")
	ok(landed > 0, "GRACE FIRES: the wasted stack heals the ally (%d)" % landed)
	ok(abs(landed - int(round(expected * ally.healing_received_mult))) <= 2,
		"...for 20%% of her max health, Mercy-scaled (got %d, want ~%d)" % [
			landed, int(round(expected * ally.healing_received_mult))])
	await _kill(scene)
	# Without the node, a wasted crossing stays wasted.
	var bare := await _spawn({})
	var c2 := _hero(bare, 2)
	var a2 := _hero(bare, 0)
	c2.second_resource = c2.second_max
	a2.hp = a2.max_hp
	var hp_was := a2.hp
	a2.take_hit(int(a2.max_hp * 0.6), 0)
	ok(a2.hp == hp_was - int(a2.max_hp * 0.6),
		"without Grace the crossing at the ceiling pays nothing at all")
	await _kill(bare)


# ---------- live: Martyrdom ----------

func _live_martyrdom() -> void:
	var scene := await _spawn({"hl_capacitor": 1})
	var c := _hero(scene, 2)
	ok(c.martyrdom == 1, "Martyrdom is stamped on the Cleric")
	var res := _find(c, "Resurrection")
	ok(res != null and res.faith_cost == 0 and res.cooldown == 0,
		"Martyrdom: the raise costs no Mercy and has no cooldown")
	var first := _hero(scene, 0)
	first.take_hit(first.hp + 500, 0)
	ok(not first.dead, "the FIRST hero to fall is returned automatically")
	var frac := float(first.hp) / float(first.max_hp)
	ok(abs(frac - BattleUnit.MARTYRDOM_RETURN) < 0.03,
		"...at 30%% health (got %.0f%%)" % (frac * 100.0))
	var second := _hero(scene, 3)
	second.take_hit(second.hp + 500, 0)
	ok(second.dead, "the SECOND falls for real — once per battle, not a standing net")
	await _kill(scene)


# ---------- live: Shared Vigil and Blessed Vestments ----------

func _live_vigil_and_vestments() -> void:
	# SHARED VIGIL. The same blow, twice, differing only in whether ANYONE is
	# under the line — so the 15% is measured rather than asserted.
	var scene := await _spawn({"hl_beacon": 1})
	var c := _hero(scene, 2)
	ok(c.holy_vigil_pct == 15, "Shared Vigil is stamped at 15%")
	var foe = scene.get("enemies")[0]
	var mark := _hero(scene, 0)
	for h in scene.get("heroes"):
		h.hp = h.max_hp
	mark.armor = 0.0
	var plain_hit := mark.max_hp - await _swing(scene, foe, mark, 60)
	# Put SOMEONE under 30% (the Cleric herself counts as "any hero") and
	# swing the identical blow again.
	c.hp = int(c.max_hp * 0.2)
	mark.hp = mark.max_hp
	var covered_hit := mark.max_hp - await _swing(scene, foe, mark, 60)
	ok(covered_hit < plain_hit,
		"the party takes less while a hero is at death's door (%d -> %d)" % [
			plain_hit, covered_hit])
	if plain_hit > 0:
		var cut := 1.0 - float(covered_hit) / float(plain_hit)
		ok(abs(cut - 0.15) < 0.015,
			"...and the cut is 15%% (got %.1f%%)" % (cut * 100.0))
		_report.append("Shared Vigil measured at %.1f%% damage taken" % (cut * 100.0))
	await _kill(scene)
	# BLESSED VESTMENTS: her healing leaves a barrier worth a quarter of it.
	var vest := await _spawn({"hl_vestments": 1})
	var c2 := _hero(vest, 2)
	ok(c2.vestments_pct == 25, "Blessed Vestments is stamped at 25%")
	var ally := _hero(vest, 0)
	ally.hp = int(ally.max_hp * 0.3)
	ally.remove_status("barrier")
	var heal := _find(c2, "Heal")
	await vest._resolve_special(c2, heal, ally, "good", 1.0)
	ok(ally.has_status("barrier"), "the heal leaves cloth-of-light behind")
	if ally.has_status("barrier"):
		var st: Dictionary = ally.get_status("barrier")
		ok(int(st.get("turns", 0)) == 2, "...for 2 turns (got %s)" % st.get("turns", 0))
		ok(int(st.get("power", 0)) > 0,
			"...worth a share of the heal (%d)" % int(st.get("power", 0)))
		_report.append("Blessed Vestments ward = %d off a Heal" % int(st.get("power", 0)))
	await _kill(vest)


# One swing of a plain attack, returning the target's HP after. THE SEED IS
# LOAD-BEARING: every hit rolls randf_range(0.9, 1.1) for variance, so two
# swings that differ only in a 15% mitigation can read anywhere from 11% to
# 17% apart. Seeding both swings identically makes the DIFFERENCE the only
# thing that moves — the AK/AS discipline of forcing determinism rather than
# widening the tolerance until the noise fits inside it.
func _swing(scene: Node, attacker: BattleUnit, target: BattleUnit, dmg: int) -> int:
	seed(20260808)
	var ab: Ability = Ability.make({"display_name": "Probe", "damage": dmg,
		"dmg_type": "physical", "delay": 2.0})
	await scene._resolve(attacker, ab, target, "good", true)
	return target.hp


# ---------- live: AU §1 reaching a rune grant ----------

func _live_last_rites_rune() -> void:
	# The Rune of the Last Rites grants Resurrection — which she now starts
	# with. Rather than a knowingly dead Epic, AU §1's rule reaches it: runes
	# share Talents.apply_payload, so the grant COLLIDES and takes the generic.
	# Resurrection has no damage, so Honed is skipped and QUICKENED lands.
	var rune: Dictionary = Runes.build("last_rites")
	rune["equipped"] = true
	var scene := await _spawn({}, {"runes": [rune]})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	ok(res != null, "she still holds exactly one Resurrection with the rune worn")
	var copies := 0
	for ab in c.abilities:
		if ab.display_name == "Resurrection":
			copies += 1
	ok(copies == 1, "the rune did not double-grant (got %d)" % copies)
	if res != null:
		ok(res.cooldown == 1,
			"the rune's dead grant became QUICKENED: 3cd -> 1 (got %s)" % res.cooldown)
	var landed: Dictionary = c.ability_upgrades
	ok(str(landed.get("Resurrection", [])).contains("Quickened"),
		"...and the kit reports it as Quickened (got %s)" % str(landed))
	_report.append("Last Rites is no longer a dead Epic — it Quickens the raise")
	await _kill(scene)


# ---------- §6 the bot ----------

func _live_bot_policy() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("var icept := _find_ability(u, \"Intercession\")"),
		"the cleric policy knows Intercession exists")
	ok(bsrc.count("func _holy_empower_ok") == 1,
		"the Empower rule has exactly one implementation")
	var scene := await _spawn({"hl_ardor": 1})
	var c := _hero(scene, 2)
	var res := _find(c, "Resurrection")
	var hymn := _find(c, "Hymn of Hope")
	ok(res != null and hymn != null, "both spenders are in hand")
	# NEVER Empower down past a raise she could otherwise cast. Hymn costs 1
	# and Resurrection costs 1, so at 2 stacks the surcharge would strand her.
	c.avatar_of_mercy = 0
	c.ardor_at = 0
	c.second_resource = 2
	ok(not scene._holy_empower_ok(c, hymn),
		"at 2 Mercy she will not Empower a Hymn — it would cost her the raise")
	c.second_resource = 3
	ok(scene._holy_empower_ok(c, hymn),
		"at 3 she will: the raise survives the surcharge")
	# Ardor learned: bank to the threshold first, then Empower freely.
	c.ardor_at = 3
	c.second_resource = 2
	ok(not scene._holy_empower_ok(c, hymn),
		"with Ardor learned she banks to its threshold rather than paying")
	c.second_resource = 3
	ok(scene._holy_empower_ok(c, hymn),
		"...and Empowers freely at it")
	# Avatar of Mercy makes it unconditional.
	c.avatar_of_mercy = 1
	c.second_resource = 0
	ok(scene._holy_empower_ok(c, hymn),
		"Avatar of Mercy makes Empower unconditional")
	# THE ROTATION: a fallen ally is the first priority.
	c.avatar_of_mercy = 0
	c.ardor_at = 0
	c.second_resource = 2
	c.resource = c.max_resource
	var down := _hero(scene, 0)
	down.take_hit(down.hp + 500, 0)
	ok(down.dead, "an ally is down")
	var pick: Array = scene._autoplay_pick(c)
	ok(pick[0] != null and pick[0].display_name == "Resurrection",
		"the bot raises the fallen FIRST (picked %s)" % pick[0].display_name)
	await _kill(scene)


# ---------- Avatar of Mercy: Empower now GENERATES ----------

func _live_avatar() -> void:
	var scene := await _spawn({"hl_avatar": 1})
	var c := _hero(scene, 2)
	ok(c.avatar_of_mercy == 1, "Avatar of Mercy is stamped")
	c.second_resource = 2
	scene.empower_armed = true
	var hymn := _find(c, "Hymn of Hope")
	var before := c.second_resource
	ok(scene._consume_empower(c, hymn), "the Empower lands")
	ok(c.second_resource == before + 1,
		"Avatar of Mercy GRANTS a stack instead of spending one (%d -> %d)" % [
			before, c.second_resource])
	await _kill(scene)
