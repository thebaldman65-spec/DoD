# BATCH JX — THE STAGES: A ZONE AT ANY STAGE, ITS STATS THE STAGE's; JK's FLOOR REMOVED; THE BONE SHEPHERD's KIT.
#
#   §0   THE RECORD: JW's eight rulings stand archived, not owed, and the state's WHERE names the lane
#   §1   THE STAGES: `ZONE_ORDER` holds every zone once and no per-stage pool stands; every zone def carries ONE roster, no two
#        share one, and every roster tag the data carries is a zone's; a run's draw deals three different zones, every zone is
#        drawn at every stage on a player's road and a sim's, the draw spends three dice, and `DOD_ZONE_ROTATION=0` holds a sim to
#        the order's first three; at every stage a zone fields its own roster; the stage's multiplier is read at the stage and
#        nowhere at the zone; the load's two fallbacks read the order; the debug jump begins the stage again in the zone and
#        never leaves a zone twice ahead; a zone's event is dealt wherever its zone stands
#   §2   JK's FLOOR IS GONE: no gate asserts that every kind holds a Rally or an Entrench, the record no longer says it, and the
#        kinds holding neither are printed (a record, never asserted)
#   §3   THE BONE SHEPHERD's KIT: Bone Smash his basic (the old basic's figures), Soul Leech an ability — the least whole damage
#        that clears JI's line against Bone Smash, the line's cooldown, its lifesteal kept — Noxious Fumes and Call the Drowned;
#        no Rally
#   §4   THE TEXTS: the master document, the state and the run's own comment say a zone stands at any stage, and none still
#        says a run takes one of eight shapes or that a zone has an opener's roster and a finale's
#   §5   THE FIXTURE's WINDOW, REPAIRED AT JX §1 (IT's census row on `Gate.returning_bodies`, owed by the batch that touched the
#        fixture): a `static func` opens a window of its own, so the function above it ends there and a void one is still dropped
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# The designer ruled at JX that a zone is for variety and the stage sets what a fight asks. The multiplier was already the
# stage's; what tied a zone to a place was a pool a stage and a roster a slot. **Both are claims a later zone could quietly
# break** — a zone added to the defs and not to the order is never drawn, a roster tag no zone owns fields nowhere — so §1
# derives each from the defs, never from a list here.
#
# ── WHAT IT CANNOT DO, SAID FIRST ───────────────────────────────────────────
# §1's draw is read over a walk of seeds, so "every zone at every stage" is what that walk met, printed with its counts; it
# is not a proof over every seed. Whether one zone's boss is harder than another's at the same stage is JX's ruling 1, accepted
# as taken after JX (each boss keeps its own base figures), so no arm here asserts the four bosses equal.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
const JI = preload("res://check_ji.gd")

var _g := Gate.new()
var _run: Node = null
var _cache := {}

const STATE := "res://docs/state.md"
const ARCHIVE := "res://DoD-archive/state-archive.md"
const MASTER := "res://docs/master.html"
const OWED_LIVE := "\n### JW's RULINGS OWED"
const OWED_STRUCK := "\n### ~~JW's RULINGS OWED~~"
const BOSS := "bone_shepherd"
const KIT := ["Bone Smash", "Soul Leech", "Noxious Fumes", "Call the Drowned"]
const SEEDS := 400
# The two zone events whose `zone_slot` named every stage their zone could stand at before JX; the one narrower stays.
const FREED := ["forest_spring", "scarland_mirage"]
const KEPT_NARROW := {"wardens_echo": [3]}
# Words a text that still described the old shape would carry (§4).
const STALE := ["one of eight shapes", "one of four shapes", "slot 2's second candidate", "tougher roster 3",
	"the Frozen Plains as the finale"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _const(name: String, fallback: Variant) -> Variant:
	return (_run.get_script() as Script).get_script_constant_map().get(name, fallback)


func _initialize() -> void:
	await process_frame
	print("BATCH JX — THE STAGES, JK's FLOOR REMOVED, AND THE BONE SHEPHERD's KIT")
	_run = root.get_node("/root/Run")
	var order: Array = _const("ZONE_ORDER", [])
	# A tree without the stages (HEAD's, under a control) reds here and reads no drive past it, rather than throwing.
	var built: bool = not order.is_empty() and _run.has_method("draw_zones")
	ok(built, "§1: the tree holds no ZONE_ORDER — the stages are not built")
	_s0_the_record()
	if built:
		_s1_the_stages(order)
	_s2_the_floor()
	_s3_the_shepherd()
	_s4_the_texts()
	_s5_the_window()
	_g.report(self)


# ── §0 — THE RECORD ────────────────────────────────────────────────────────
func _s0_the_record() -> void:
	print("\n§0 — JW's eight rulings stand archived; the WHERE names the lane")
	var state := FileAccess.get_file_as_string(STATE)
	var arch := FileAccess.get_file_as_string(ARCHIVE)
	print("    JW's RULINGS OWED in the open queue: %s; struck in the archive: %s" % [str(state.contains(OWED_LIVE)), str(arch.contains(OWED_STRUCK))])
	ok(state.length() > 1000 and not state.contains(OWED_LIVE), "§0: JW's RULINGS OWED is still in the open queue")
	ok(arch.contains(OWED_STRUCK), "§0: the archive does not hold JW's RULINGS OWED struck")
	var where := state.substr(0, state.find("\n## THE OPEN QUEUE"))
	ok(where.contains("Lane A"), "§0: the state's WHERE names no lane")


# ── §1 — THE STAGES ────────────────────────────────────────────────────────
func _s1_the_stages(order: Array) -> void:
	print("\n§1 — a zone at any stage: the order, one roster a zone, the draw, the multiplier, the fallbacks, the jump, the events")
	var defs: Dictionary = _run.ZONE_DEFS
	var stages := int(_run.SLOT_COUNT)
	var sorted_order := order.duplicate()
	sorted_order.sort()
	var keys: Array = defs.keys()
	keys.sort()
	print("    ZONE_ORDER %s; %d stages" % [str(order), stages])
	ok(sorted_order == keys and order.size() == keys.size(), "§1: ZONE_ORDER %s does not hold every zone def once (%s)" % [str(order), str(keys)])
	ok(not (_run.get_script() as Script).get_script_constant_map().has("SLOT_POOLS"), "§1: a per-stage pool (SLOT_POOLS) still stands")
	ok(stages < order.size(), "§1: %d stages and %d zones — the draw cannot deal a different zone a stage with room to vary" % [stages, order.size()])
	# ONE ROSTER A ZONE, AND EVERY TAG A ZONE's.
	var rosters := {}
	var bad: Array = []
	for z in defs:
		var d: Dictionary = defs[z]
		if not d.has("roster") or d.has("rosters") or typeof(d["roster"]) != TYPE_INT:
			bad.append("%s %s" % [z, str(d)])
			continue
		if rosters.has(int(d["roster"])):
			bad.append("%s shares roster %d with %s" % [z, int(d["roster"]), rosters[int(d["roster"])]])
		rosters[int(d["roster"])] = z
	ok(bad.is_empty(), "§1: a zone def does not carry one roster of its own: %s" % str(bad))
	var data: Dictionary = Enemies._load()
	var orphan := {}
	var boss_out: Array = []
	for k in data:
		for t in (data[k] as Dictionary).get("zones", []):
			if not rosters.has(int(t)):
				orphan["%s %d" % [k, int(t)]] = true
	for z2 in defs:
		var r := int(defs[z2].get("roster", -1))
		var b := String(defs[z2]["boss"])
		if not Enemies.kinds_for_roster(r).has(b):
			boss_out.append("%s's %s" % [z2, b])
		print("    %-15s roster %d: %d kinds, its boss %s" % [z2, r, Enemies.kinds_for_roster(r).size(), b])
	ok(orphan.is_empty(), "§1: a roster tag no zone fields: %s" % str(orphan.keys()))
	ok(boss_out.is_empty(), "§1: a zone's boss is not in its own roster: %s" % str(boss_out))
	# THE DRAW: three different zones; every zone at every stage, a player's road and a sim's; three dice; the sim held.
	var met := {"player": {}, "sim": {}}
	var twice: Array = []
	for arm in ["player", "sim"]:
		_run.sim_run = arm == "sim"
		OS.set_environment("DOD_ZONE_ROTATION", "")
		for i in SEEDS:
			seed(20261115 + i)
			_run.draw_zones()
			var dr: Array = _run.zone_draw
			var seen := {}
			for s in dr.size():
				met[arm]["%d/%s" % [s + 1, String(dr[s])]] = int(met[arm].get("%d/%s" % [s + 1, String(dr[s])], 0)) + 1
				if seen.has(String(dr[s])):
					twice.append(str(dr))
				seen[String(dr[s])] = true
	var unmet: Array = []
	for arm2 in met:
		for s2 in stages:
			for z3 in order:
				if not met[arm2].has("%d/%s" % [s2 + 1, z3]):
					unmet.append("%s: stage %d never drew %s" % [arm2, s2 + 1, z3])
	var line := PackedStringArray()
	for s3 in stages:
		var cells := PackedStringArray()
		for z4 in order:
			cells.append("%s %d" % [String(z4).left(6), int(met["player"].get("%d/%s" % [s3 + 1, z4], 0))])
		line.append("stage %d: %s" % [s3 + 1, ", ".join(cells)])
	print("    CHECKED %d draws a road, a player's and a sim's — a player's: %s" % [SEEDS, " | ".join(line)])
	ok(unmet.is_empty(), "§1: a zone is never drawn at a stage: %s" % str(unmet))
	ok(twice.is_empty(), "§1: a run's draw dealt a zone twice: %s" % str(twice.slice(0, 3)))
	# THREE DICE: the draw spends what the per-stage pools spent, so every later roll keeps its place in the stream.
	_run.sim_run = false
	seed(777)
	_run.draw_zones()
	var after_draw := randi()
	seed(777)
	for j in stages:
		randi()
	ok(after_draw == randi(), "§1: the draw does not spend one die a stage — every later roll of a run moves")
	_run.sim_run = true
	OS.set_environment("DOD_ZONE_ROTATION", "0")
	_run.draw_zones()
	var held: Array = _run.zone_draw.duplicate()
	_run.sim_run = false
	OS.set_environment("DOD_ZONE_ROTATION", "")
	print("    a sim held by DOD_ZONE_ROTATION=0: %s" % str(held))
	ok(held == order.slice(0, stages), "§1: DOD_ZONE_ROTATION=0 does not hold a sim to the order's first %d (%s)" % [stages, str(held)])
	# A ZONE FIELDS ITS OWN ROSTER AT EVERY STAGE; THE MULTIPLIER IS THE STAGE's.
	var wrong_roster: Array = []
	var keep_draw: Array = _run.zone_draw.duplicate()
	var keep_idx := int(_run.zone_idx)
	for z5 in order:
		for s4 in stages:
			var dr2: Array = order.filter(func(x): return x != z5).slice(0, stages - 1)
			dr2.insert(s4, z5)
			_run.zone_draw = dr2
			_run.zone_idx = s4
			if int(_run.active_roster()) != int(defs[z5]["roster"]) or String(_run.boss_kind()) != String(defs[z5]["boss"]):
				wrong_roster.append("%s at stage %d: roster %d, boss %s" % [z5, s4 + 1, int(_run.active_roster()), String(_run.boss_kind())])
	_run.zone_draw = keep_draw
	_run.zone_idx = keep_idx
	ok(wrong_roster.is_empty(), "§1: a zone does not field its own roster and boss at every stage: %s" % str(wrong_roster))
	var ladder := Gate.fn_body("scripts/run_state.gd", "_zone_ladder", _cache)
	var spawn := Gate.strip_comments(Gate.fn_body("scripts/battle.gd", "_spawn_units", _cache))
	ok(ladder.contains("func _zone_ladder(slot: int) -> float:") and not ladder.contains("zone_draw") and not ladder.contains("ZONE_DEFS"),
		"§1: the stage's multiplier reads the zone — `_zone_ladder` is no longer the stage's alone")
	ok(spawn.contains("slot_mult = Run.zone_base_mult(Run.zone_idx + 1)") and spawn.contains("hp_mult = Run.zone_base_mult_hp(Run.zone_idx + 1)"),
		"§1: the spawn no longer reads both multipliers at the stage (`Run.zone_idx + 1`)")
	# THE LOAD's FALLBACKS READ THE ORDER: an unknown zone takes the first zone of the order the draw lacks.
	var keep_name := String(_run.zone_name)
	_run.zone_draw = [order[0], "jx_gone_zone", order[1]]
	_run.zone_idx = 0
	_run.call("_drop_stale_save_keys")
	print("    an unknown zone at stage 2 of %s became %s" % [str([order[0], "jx_gone_zone", order[1]]), String(_run.zone_draw[1])])
	ok(String(_run.zone_draw[1]) == String(order[2]), "§1: an unknown zone took %s, not the first zone of the order the draw lacks (%s)" % [String(_run.zone_draw[1]), String(order[2])])
	var load_src := Gate.strip_comments(Gate.fn_body("scripts/run_state.gd", "load_run", _cache))
	ok(load_src.contains("zone_draw.append(ZONE_ORDER[slot])"), "§1: a save with no draw does not take the order's first stages")
	# THE DEBUG JUMP: the stage begins again in the zone; a later stage that held it takes the zone it replaced.
	_run.zone_draw = order.slice(0, stages)
	_run.zone_idx = 0
	var target := String(order[stages - 1])
	var moved: bool = _run.debug_force_zone(target)
	var after: Array = _run.zone_draw.duplicate()
	var again: bool = _run.debug_force_zone(target)
	print("    the jump to %s from stage 1 of %s: %s, the draw %s; asked again: %s" % [target, str(order.slice(0, stages)), str(moved), str(after), str(again)])
	var dupes := after.filter(func(x): return after.count(x) > 1)
	ok(moved and String(after[0]) == target and String(after[stages - 1]) == String(order[0]) and dupes.is_empty() and not again,
		"§1: the debug jump did not begin stage 1 again in %s and hand stage %d the zone it replaced (%s, %s)" % [target, stages, str(after), str(again)])
	_run.zone_draw = keep_draw
	_run.zone_idx = keep_idx
	_run.zone_name = keep_name
	# A ZONE's EVENT IS DEALT WHEREVER ITS ZONE STANDS.
	var evs: Dictionary = Events._load()
	var still: Array = []
	var zoned := 0
	for id in evs:
		var req: Dictionary = (evs[id] as Dictionary).get("requires", {})
		if not req.has("zone"):
			continue
		zoned += 1
		print("    %-16s zone %s, zone_slot %s" % [id, str(req["zone"]), str(req.get("zone_slot", "—"))])
		if FREED.has(String(id)) and req.has("zone_slot"):
			still.append(String(id))
		if KEPT_NARROW.has(String(id)) and (req.get("zone_slot", []) as Array).map(func(x): return int(x)) != KEPT_NARROW[String(id)]:
			still.append("%s %s" % [id, str(req.get("zone_slot", []))])
	ok(zoned >= FREED.size() + KEPT_NARROW.size(), "§1: the event table read %d zone events, not the %d named" % [zoned, FREED.size() + KEPT_NARROW.size()])
	ok(still.is_empty(), "§1: a zone event still names its old stages, or the Echo lost its narrowing: %s" % str(still))


# ── §2 — JK's FLOOR IS GONE ────────────────────────────────────────────────
func _s2_the_floor() -> void:
	print("\n§2 — JK's floor removed: no gate asserts it, the record no longer says it, and the kinds holding neither are printed")
	var jk := Gate.strip_comments(FileAccess.get_file_as_string("res://check_jk.gd"))
	ok(jk.length() > 1000 and not jk.contains("no_floor.is_empty()"), "§2: check_jk still asserts that every kind holds a Rally or an Entrench")
	var state := FileAccess.get_file_as_string(STATE)
	ok(not state.contains("- **EVERY KIND HOLDS ONE**"), "§2: the state still says every kind holds a spend of the pair")
	var data: Dictionary = Enemies._load()
	var neither: Array = []
	for k in data:
		var specials: Array = []
		for a in (data[k] as Dictionary).get("abilities", []):
			specials.append(String(a.get("special", "")))
		if not specials.has("malice_rally") and not specials.has("malice_entrench"):
			neither.append(String(k))
	# PRINTED, NEVER ASSERTED: an absence a later batch may undo (the owed boss strategies) is a record, not a rule.
	print("    [record] the kinds holding neither a Rally nor an Entrench: %d — %s" % [neither.size(), ", ".join(PackedStringArray(neither))])


# ── §3 — THE BONE SHEPHERD's KIT ───────────────────────────────────────────
func _s3_the_shepherd() -> void:
	print("\n§3 — the Bone Shepherd: Bone Smash his basic, Soul Leech an ability priced on the line, no Rally")
	var data: Dictionary = Enemies._load()
	ok(data.has(BOSS), "§3: the data holds no Bone Shepherd")
	if not data.has(BOSS):
		return
	var sh: Dictionary = data[BOSS]
	var kit: Array = sh.get("abilities", [])
	var names: Array = kit.map(func(a): return String(a.get("display_name", "")))
	print("    the kit: %s" % ", ".join(PackedStringArray(names)))
	ok(names == KIT, "§3: the Shepherd's kit is %s, not %s" % [str(names), str(KIT)])
	if names != KIT:
		return
	var smash: Dictionary = kit[0]
	var leech: Dictionary = kit[1]
	ok(int(smash.get("cooldown", 0)) == 0 and int(smash.get("damage", 0)) > 0 and int(smash.get("cost", 0)) == 0 and not smash.has("dmg_type")
		and not smash.has("special") and not smash.has("lifesteal"), "§3: Bone Smash is not a plain, uncooled, physical basic: %s" % str(smash))
	# THE OLD BASIC's FIGURES: the Tyrant's body's basic, which Soul Leech carried until JX.
	var tyrant_basic: Dictionary = (data["ash_tyrant"]["abilities"] as Array)[0]
	ok(int(smash["damage"]) == int(tyrant_basic["damage"]) and int(smash["pressure"]) == int(tyrant_basic["pressure"])
		and float(smash["delay"]) == float(tyrant_basic["delay"]), "§3: Bone Smash does not carry the Tyrant's basic's figures (%s)" % str(tyrant_basic))
	var bf := JI.break_figures()
	var price := float(bf["price"])
	var atk := float(sh["attack"])
	var basic := JI.line_blow(smash, {}, atk, price)
	var worth := JI.line_blow(leech, {}, atk, price) / basic
	var under := JI.line_blow(leech.merged({"damage": int(leech["damage"]) - 1}, true), {}, atk, price) / basic
	var want := 0 if worth < JI.LINE else (2 if worth < 2.0 else (3 if worth < 3.0 else 4))
	print("    Soul Leech: %d damage, worth %.4f of Bone Smash (%d damage: %.4f); the line gives %d, the data %d" % [
		int(leech["damage"]), worth, int(leech["damage"]) - 1, under, want, int(leech.get("cooldown", 0))])
	ok(price > 0.0 and worth >= JI.LINE and under < JI.LINE, "§3: Soul Leech's damage is not the least whole figure that clears the line (%.4f, %.4f)" % [worth, under])
	ok(int(leech.get("cooldown", 0)) == want and want > 0, "§3: Soul Leech cools %d, the line gives %d" % [int(leech.get("cooldown", 0)), want])
	ok(String(leech.get("dmg_type", "")) == "shadow" and float(leech.get("lifesteal", 0.0)) > 0.0, "§3: Soul Leech lost its shadow or its lifesteal")
	var specials: Array = kit.map(func(a): return String(a.get("special", "")))
	ok(not specials.has("malice_rally") and specials.has("malice_raise"), "§3: the Shepherd still holds the borrowed Rally, or lost Call the Drowned's Raise")


# ── §4 — THE TEXTS ─────────────────────────────────────────────────────────
func _s4_the_texts() -> void:
	print("\n§4 — the texts: a zone stands at any stage; none still says the old shape")
	var files := {"docs/master.html": FileAccess.get_file_as_string(MASTER), "docs/state.md": FileAccess.get_file_as_string(STATE),
		"scripts/run_state.gd": FileAccess.get_file_as_string("res://scripts/run_state.gd")}
	var found: Array = []
	for f in files:
		var t := String(files[f]).replace("\n", " ")
		for w in STALE:
			if t.contains(String(w)):
				found.append("%s: '%s'" % [f, w])
	print("    CHECKED %d files for %d phrases of the old shape; %d found" % [files.size(), STALE.size(), found.size()])
	ok(found.is_empty(), "§4: a text still describes a zone fixed to a stage: %s" % str(found))
	var master := String(files["docs/master.html"]).replace("\n", " ")
	ok(master.contains("any zone can stand at any stage"), "§4: master.html does not say any zone can stand at any stage")
	ok(master.contains("Bone Smash"), "§4: master.html does not name the Shepherd's Bone Smash")


# ── §5 — THE FIXTURE's WINDOW, REPAIRED ────────────────────────────────────
func _s5_the_window() -> void:
	print("\n§5 — `Gate.returning_bodies`: a static function opens a window of its own")
	var src := "func a() -> int:\n\treturn 1\n\n\nstatic func b() -> Array:\n\treturn []\n\n\nfunc c() -> void:\n\tpass\n"
	var bodies: Dictionary = Gate.returning_bodies(src)
	print("    the bodies read off a func, a static func and a void func: %s" % str(bodies.keys()))
	ok(bodies.has("a") and not String(bodies.get("a", "")).contains("static func b"), "§5: a function's window runs on into the static function below it")
	ok(bodies.has("b") and not bodies.has("c"), "§5: a static function is no body of its own, or a void function is kept: %s" % str(bodies.keys()))
