# BATCH HN — THE CEILING, SEVEN RULINGS, AND WHAT A CREST PAYLOAD CAN WRITE.
#
#   §0  THE GROUND — this process writes the harness save, and scratch meta files
#   §1  THE CEILING — the ruling that a fourth re-derivation is not the answer
#       stands beside the figure (`check_fg` §2 parses the figure itself; this
#       gate holds no copy of the number)
#   §2  THE TWO RULINGS THAT MOVED CODE, EACH BOTH WAYS:
#       a  the Fourth Stack is FORBEARANCE: the data's name, the id and the words
#          unchanged, the name swept against every population the game holds, and
#          a save holding either old name loading as today's
#       b  the pouch's empty line, on the real screen, measured against the pouch,
#          and not drawn for a hero who holds a core rune
#       c  and the confirmations took their markers off (Guard Change's row)
#   §3  THE CENSUS — what a crest payload can write, each answer driven:
#       a  the stat fields: the door, the population, a drive of each shape
#          (additive, multiplicative, max-merged), and the three ways a stat
#          resolves and does not do what it says
#       b  a condition holds several keys, and every one must hold
#       c  `heroes_all_standing: false` does not invert
#       d  a card a crest grants reaches every bar, on the battle's copy
#       e  `heroes_class_count` reads a named class and nothing else
#   §4  ORDINATION'S COMMENT names the threshold, not five
#   §9  THE PLAYER'S FILES, as this gate found them
#
# **EVERY FIXTURE IS PUT INTO THE LOADED TABLE AND TAKEN OUT AGAIN, AND NONE IS
# WRITTEN TO THE FILE** (HL §6's shape; the brief: author nothing, measure). §3
# asserts `data/runes.json` holds no crest entry, and that the table is left as
# found. **EVERY FIELD A DRIVE MEASURES ARRIVES THROUGH THE REAL DOOR** — the
# crest's payload, stamped at the spawn — and this gate assigns none of them on
# a unit by hand (GW §2: a gate that writes the state its assertion is about
# cannot fail when the door breaks).
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM** (the brief's rule): an absence
# is asked beside the arm that shows the window held something, and a population
# prints how many it checked, so a walk over nothing reads red.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hn.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const SCRATCH_PROFILE := "user://hn_profile.json"
const SCRATCH_RELICS := "user://hn_relics.json"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}

# The fixtures. None is in the file and none survives this gate.
const CREST_FX := "hn_fixture_crest"
const HERO_FX := "hn_fixture_hero_rune"
const CREST_HP := 9

# §2 — the ruled name and the ruled line, each the designer's.
const RULED_NAME := "Forbearance"
const RULED_WORDS := "Allies hold one more stack of Faith before releasing."
const POUCH_EMPTY := "No core rune held. Core runes are found in play, alongside the others."

# §3a — the fields a crest can stamp that pay EVERY hero, each at a delta it can
# be seen at. Twenty-six of them are the one talent tree's (FX: a node must pay
# every class that can buy it, and `check_fx` §4 drives each on all four), the
# rest are the class stat block every hero carries. `max_hp`, `max_hp_pct` and
# the two that pay one currency are asked apart below.
const EVERY_HERO := {
	"attack": 11, "armor": 0.05, "crit_bonus": 0.05, "speed": 10.0,
	"parry_bonus": 0.04, "max_resource": 20, "dmg_bonus": 0.1,
	"dmg_taken_bonus": -0.05, "broken_will_ranks": 25, "blood_communion": 20,
	"follow_through": 2, "bonecracker_ranks": 40, "field_medic": 2,
	"iron_will_ranks": 1, "pierce_bonus": 0.2, "deflection": 1, "whetstone": 3,
	"undying_rage": 1, "no_cover": 1, "sundering_shot": 45,
	"no_quarter_ranks": 1, "rapid_fire": 50, "snap_shot": 2,
	"constitution": 7, "stability": 5, "block_chance": 0.03,
	"last_rites": 1, "conversion_ranks": 30,
}

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HN — THE CEILING, SEVEN RULINGS, AND WHAT A CREST PAYLOAD CAN WRITE")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s1_the_ceiling()
	_s2a_forbearance()
	await _s2b_the_empty_pouch()
	_s2c_the_markers()
	await _s3a_stat_fields()
	await _s3b_two_keys()
	await _s3c_all_standing_false()
	await _s3d_a_granted_card()
	await _s3e_any_class()
	_s3_the_file_and_the_table()
	_s4_ordination()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


# A fresh run of `keys`, each awakened on the engine rune `engines` names for his
# seat — a party the game can produce.
func _new_run(keys: Array, engines: Array) -> void:
	_run.sim_run = false
	_run.new_run(keys, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []


# THE ONE DOOR EVERY §3 DRIVE ENTERS BY: a party of `keys` on `engines`, the
# fixture crest worn with `payload` when `crest` is true, hero `fallen` at 0
# health, and — when `hero_rune` is not empty — a fixture rune worn by the hero at
# `hero_rune.seat` with `hero_rune.payload`. The real battle scene for the run in
# hand (`Gate.enter_battle`, the door `check_da` §3 holds every gate to).
func _battle(keys: Array, engines: Array, payload: Dictionary, crest: bool,
		fallen := -1, hero_rune := {}) -> Node:
	var table: Dictionary = Runes._load()
	table[CREST_FX] = {"name": "HN Fixture Crest", "scope": "party", "price": 150,
		"desc": "A fixture of check_hn, never in the file.", "payload": payload}
	_new_run(keys, engines)
	if crest:
		var r := Runes.build(CREST_FX)
		r["equipped"] = true
		_run.party_runes = [r]
	if not hero_rune.is_empty():
		var seat := int(hero_rune["seat"])
		table[HERO_FX] = {"name": "HN Fixture Rune", "scope": "class:%s" % String(keys[seat]),
			"price": 150, "desc": "A fixture of check_hn, never in the file.",
			"payload": hero_rune["payload"]}
		var hr := Runes.build(HERO_FX)
		hr["equipped"] = true
		_run.party[seat]["runes"] = [hr]
	if fallen >= 0:
		_run.party[fallen]["hp"] = 0
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE)
	await Gate.frames(self, 8)
	return current_scene


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _approx(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if not is_equal_approx(float(a[i]), float(b[i])):
			return false
	return true


func _foe(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			return e
	return null


# The crest's +CREST_HP maximum health, per hero, against the same party without
# it — how many of the four it was paid on, and whether the roll call told why not.
func _paid(keys: Array, engines: Array, cond: Dictionary, fallen := -1) -> Dictionary:
	var w: Node = await _battle(keys, engines, {"stat": {"max_hp": CREST_HP}, "condition": cond}, true, fallen)
	var hp_w: Array = []
	for u in _heroes(w):
		hp_w.append(int((u as BattleUnit).max_hp))
	var roll: Array = (w.get("_rune_roll_call") as Array).duplicate()
	var o: Node = await _battle(keys, engines, {"stat": {"max_hp": CREST_HP}, "condition": cond}, false, fallen)
	var hp_o: Array = []
	for u2 in _heroes(o):
		hp_o.append(int((u2 as BattleUnit).max_hp))
	var paid := 0
	for i in mini(hp_w.size(), hp_o.size()):
		if int(hp_w[i]) - int(hp_o[i]) == CREST_HP:
			paid += 1
	var told := false
	for line in roll:
		if String(line).begins_with("the crest: HN Fixture Crest") \
				and String(line).contains("its condition does not hold"):
			told = true
	return {"paid": paid, "heroes": hp_w.size(), "told": told}


# One seeded blow of `atk`'s basic on `victim`, returning the damage dealt; the
# victim is whole before and after it.
func _blow(s: Node, atk: BattleUnit, victim: BattleUnit, sd: int) -> int:
	victim.hp = victim.max_hp
	victim.pressure = 0
	victim.broken = false
	atk.cooldowns.clear()
	seed(sd)
	var before := victim.hp
	await s._resolve(atk, atk.abilities[0], victim, "good")
	var dealt := before - victim.hp
	victim.hp = victim.max_hp
	return dealt


# ── §1 — THE CEILING ────────────────────────────────────────────────────────

func _s1_the_ceiling() -> void:
	print("\n§1 — the ceiling: the ruling beside the figure")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.length() > 100000, "§1: CLAUDE.md read back %d chars" % cm.length())
	var head := cm.find("## THIS FILE IS MEASURED IN KiB, AND THE CEILING IS ")
	var next := cm.find("\n## ", head + 10)
	ok(head >= 0 and next > head, "§1: the ceiling block is not where it was")
	var block := cm.substr(head, next - head) if head >= 0 and next > head else ""
	# THE RULING, IN THE BLOCK AND NOT ONLY IN THE FILE: a sentence that moved to
	# another block would no longer stand beside the figure.
	ok(block.contains("A FOURTH IS NOT THE ANSWER"),
		"§1: the ceiling block does not say that a fourth re-derivation is not the answer")
	ok(block.contains("RAISED AT FU §1, GY §1 AND HN §1"),
		"§1: the ceiling's heading does not name the third re-derivation")
	# And the reasoning split GY rejected is still rejected there — the recon the
	# ruling queues is not that seam.
	ok(block.contains("SPLITTING THE REASONING OUT. DO NOT") and block.contains("not the seam that recon reconsiders"),
		"§1: the ceiling block no longer keeps GY's rejection of the reasoning split apart from the shape recon")


# ── §2a — FORBEARANCE ───────────────────────────────────────────────────────

func _s2a_forbearance() -> void:
	print("\n§2a — the Fourth Stack is Forbearance")
	var cfg: Dictionary = Runes.config("fourth_stack")
	ok(not cfg.is_empty(), "§2a: `fourth_stack` is not in the table — the id must not move, saves key on it")
	ok(Runes.display_name(cfg) == RULED_NAME, "§2a: the rune reads '%s'" % Runes.display_name(cfg))
	ok(String(cfg.get("desc", "")) == RULED_WORDS, "§2a: its words moved: '%s'" % cfg.get("desc", ""))
	var pay: Dictionary = cfg.get("payload", {})
	ok(pay.get("stat", {}).has("rune_fourth_stack") and (pay.get("stat", {}) as Dictionary).size() == 1,
		"§2a: its payload moved — the ruling moved no magnitude: %s" % [pay])
	ok(String(cfg.get("retired", "")) == "" and String(cfg.get("scope", "")) == "class:cleric",
		"§2a: the rename retired or re-scoped it")
	ok(not Runes.display_name(cfg).begins_with("Rune of "),
		"§2a: a live ordinary rune wears the retired pool's long shape (FK §2a; `check_fd` §3)")
	# BR §1 — THE NAME, SWEPT AGAINST EVERY POPULATION THE GAME HOLDS: the runes,
	# live and retired, and the generated family; every card in the corpus; the
	# tree's nodes; the glossary; and every string the game's scripts and data
	# carry. Exact, contained, or containing — the word must stand alone.
	var low := RULED_NAME.to_lower()
	var hits: Array = []
	var seen := 0
	for id in Runes.ids():
		seen += 1
		var nm := Runes.display_name(Runes.config(String(id))).to_lower()
		if String(id) != "fourth_stack" and (nm.contains(low) or (nm != "" and low.contains(nm))):
			hits.append("rune:" + String(id))
	for t in Runes.TEMPLATES:
		seen += 1
		if String(t["noun"]).to_lower().contains(low):
			hits.append("template:" + String(t["noun"]))
	for ab in Classes.ability_corpus():
		seen += 1
		if (ab as Ability).display_name.to_lower().contains(low):
			hits.append("ability:" + (ab as Ability).display_name)
	for n in Talents.tree():
		seen += 1
		if String((n as Dictionary).get("name", "")).to_lower().contains(low):
			hits.append("node:" + String(n["name"]))
	print("    CHECKED %d names" % seen)
	ok(seen > 400, "§2a: the name sweep read %d names — not the game's populations" % seen)
	ok(hits.is_empty(), "§2a: '%s' collides with %s" % [RULED_NAME, hits])
	# Every file the game reads its words from, comment-stripped: the word is in the
	# one entry and nowhere else. The positive arm: the entry itself is found.
	var in_files: Array = []
	var files := 0
	for dir in ["res://scripts", "res://data"]:
		var d := DirAccess.open(dir)
		if d == null:
			continue
		for fn in d.get_files():
			var path := "%s/%s" % [dir, fn]
			if not (fn.ends_with(".gd") or fn.ends_with(".json")):
				continue
			files += 1
			var body := FileAccess.get_file_as_string(path)
			if fn.ends_with(".gd"):
				body = Gate.strip_comments(body)
			var n2 := body.to_lower().count("forbear")
			if n2 > 0:
				in_files.append("%s x%d" % [path.get_file(), n2])
	print("    CHECKED %d script and data files" % files)
	ok(files >= 30, "§2a: the file sweep read %d files — not the scripts and the data" % files)
	ok(in_files == ["runes.json x1"], "§2a: the word stands in %s — it should be the one entry's name alone" % [in_files])
	# THE SAVE CARRIES IT (HL §2e's door, `Run._refresh_rune_names`): a rune saved
	# under the name HL left and one saved under the long shape the brief wrote it
	# in both load as today's; a rune the data does not hold keeps its own.
	_new_run(SEATS, ENG4)
	var cl: Dictionary = _run.party[2]
	var worn := Runes.build("fourth_stack")
	ok(String(worn["name"]) == RULED_NAME, "§2a: a rune built today is named '%s'" % worn["name"])
	worn["name"] = "Fourth Stack"
	worn["equipped"] = true
	cl["runes"] = [worn]
	var bagged := Runes.build("fourth_stack")
	bagged["name"] = "Rune of the Fourth Stack"
	var tpl := {"id": "tpl:Might", "name": "Rune of Might", "payload": {"stat": {"attack": 1}}}
	_run.rune_bag = [bagged, tpl]
	_run.save_run()
	_run.load_run()
	var got_worn := ""
	for r in ((_run.party[2] as Dictionary).get("runes", []) as Array):
		if String((r as Dictionary).get("id", "")) == "fourth_stack":
			got_worn = String(r["name"])
	var got_bag := ""
	var got_tpl := ""
	for r2 in _run.rune_bag:
		if String((r2 as Dictionary).get("id", "")) == "fourth_stack":
			got_bag = String(r2["name"])
		if String((r2 as Dictionary).get("id", "")) == "tpl:Might":
			got_tpl = String(r2["name"])
	ok(got_worn == RULED_NAME, "§2a: a saved rune named 'Fourth Stack' loaded as '%s', not '%s'" % [got_worn, RULED_NAME])
	ok(got_bag == RULED_NAME, "§2a: a saved rune named 'Rune of the Fourth Stack' loaded as '%s', not '%s'" % [got_bag, RULED_NAME])
	ok(got_tpl == "Rune of Might", "§2a: a rune the data does not hold was renamed to '%s'" % got_tpl)


# ── §2b — THE EMPTY POUCH ───────────────────────────────────────────────────

func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	return current_scene


func _label_with(n: Node, text: String) -> Label:
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_back()
		if cur == null or cur.is_queued_for_deletion():
			continue
		if cur is Label and String((cur as Label).text) == text:
			return cur
		for k in cur.get_children():
			stack.append(k)
	return null


func _s2b_the_empty_pouch() -> void:
	print("\n§2b — the pouch's empty line, on the real screen")
	var ms := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	ok(ms.contains("\"%s\"" % POUCH_EMPTY), "§2b: map_screen.gd does not carry the ruled line")
	ok(not ms.contains("Core runes come with"), "§2b: map_screen.gd still carries HL's line")
	# THE MAGE HOLDS NO CORE RUNE AND THE BAG HOLDS NONE: the line is drawn.
	_new_run(SEATS, ENG4)
	var mage: Dictionary = _run.party[1]
	var dropped: Array = (mage["engines"] as Array).duplicate()
	mage["engines"] = []
	var mp := await _to_map()
	mp.call("_open_rune_panel", 1)
	await Gate.frames(self, 2)
	var ov: Node = Gate.overlay(current_scene, 60)
	var lbl: Label = _label_with(ov, POUCH_EMPTY) if ov != null else null
	ok(lbl != null, "§2b: the Mage's pouch holds no core rune and does not say so in the ruled words")
	ok(ov != null and not Gate.has_text(ov, "Core runes come with"), "§2b: the Mage's pouch still shows HL's line")
	if lbl != null:
		# MEASURED, NOT COUNTED: the label's own minimum width against the scroller
		# it sits in, whose horizontal scroll is off.
		var scroller: Control = lbl.get_parent().get_parent() as Control
		var need := lbl.get_minimum_size().x
		print("    the line needs %.0f px of the %.0f px the pouch's scroller gives it" % [need, scroller.size.x])
		ok(scroller is ScrollContainer and need > 0.0 and need <= scroller.size.x,
			"§2b: the line needs %.0f px against a %.0f px scroller" % [need, scroller.size.x])
	# THE OTHER WAY: a hero who holds one is shown his core runes, and no empty line.
	var ov2_ok := false
	var closed := Gate.press(ov, ["Close"]) if ov != null else ""
	await Gate.frames(self, 2)
	ok(closed == "Close", "§2b: the pouch's Close did not press (%s)" % closed)
	mp.call("_open_rune_panel", 0)
	await Gate.frames(self, 2)
	var ov2: Node = Gate.overlay(current_scene, 60)
	if ov2 != null:
		ov2_ok = Gate.has_text(ov2, "CORE RUNES — 1 of") and _label_with(ov2, POUCH_EMPTY) == null
	ok(ov2_ok, "§2b: the Warrior holds a core rune and his pouch showed the empty line, or no core-rune header")
	mage["engines"] = dropped


# ── §2c — THE CONFIRMATIONS' MARKERS ────────────────────────────────────────

func _s2c_the_markers() -> void:
	print("\n§2c — the five confirmations took their markers off")
	var row: Dictionary = Classes.PROTECTED_CORES["swordmaster"]
	ok(Array(row["enablers"]) == ["Guard Change"], "§2c: the Stances bring %s" % [row["enablers"]])
	ok(String(row["why"]).contains("ruled at HN §2") and not String(row["why"]).contains("PROPOSED"),
		"§2c: Guard Change's row still reads as proposed: %s" % row["why"])
	var cls := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/classes.gd"))
	ok(cls.contains("Guard Change is the unconditional swap (found in play at HL §1, ruled at HN §2)"),
		"§2c: classes.gd's row does not carry the ruling")


# ── §3a — THE STAT FIELDS ───────────────────────────────────────────────────

# Every script variable a BattleUnit declares, with its default: the population
# `BattleUnit.setup` can `set()` a payload's key onto.
func _unit_props() -> Dictionary:
	var probe := BattleUnit.new()
	var out := {}
	for p in probe.get_property_list():
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			out[String(p["name"])] = probe.get(String(p["name"]))
	probe.free()
	return out


# Every stat field an authored payload writes: the runes, live and retired (and
# their `also` halves), the one tree, and the generated family.
func _authored_fields() -> Array:
	var out: Array = []
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var stack: Array = []
	for id in (data as Dictionary):
		stack.append(((data as Dictionary)[id] as Dictionary).get("payload", {}))
	for n in Talents.tree():
		stack.append((n as Dictionary).get("payload", {}))
	while not stack.is_empty():
		var p: Variant = stack.pop_back()
		if not (p is Dictionary):
			continue
		for f in ((p as Dictionary).get("stat", {}) as Dictionary):
			if not out.has(String(f)):
				out.append(String(f))
		for sub in ((p as Dictionary).get("also", []) as Array):
			stack.append(sub)
	for t in Runes.TEMPLATES:
		if not out.has(String(t["stat"])):
			out.append(String(t["stat"]))
	return out


func _s3a_stat_fields() -> void:
	print("\n§3a — the stat fields a crest can stamp")
	# (1) THE DOOR. `apply_payload` adds `value x ranks` into the spawn's config under
	# ANY key and checks none; `setup` then `set()`s every key the unit declares.
	var cfg := {"armor": 0.15}
	Talents.apply_payload(cfg, {"stat": {"armor": 0.05, "hn_no_such_field": 7}}, 1, {})
	ok(is_equal_approx(float(cfg["armor"]), 0.20) and int(cfg.get("hn_no_such_field", 0)) == 7,
		"§3a: the door does not add into the config under any key: %s" % [cfg])
	var cfg2 := {}
	Talents.apply_payload(cfg2, {"stat": {"healing_received_mult": 0.2}}, 1, {})
	ok(is_equal_approx(float(cfg2.get("healing_received_mult", -1.0)), 0.2),
		"§3a: a key the config does not carry starts from %s, not from nothing" % [cfg2])
	# (2) THE POPULATION: what `setup` can land a key on, and what is written today.
	var props := _unit_props()
	var authored := _authored_fields()
	var undeclared: Array = []
	for f in authored:
		if not props.has(f):
			undeclared.append(f)
	print("    CHECKED %d declared unit fields; %d stat fields written by an authored payload" % [props.size(), authored.size()])
	ok(props.size() > 500, "§3a: the unit declares %d fields — not the population" % props.size())
	ok(authored.size() > 150, "§3a: %d authored stat fields — the walk read nothing" % authored.size())
	# THE ONE WRITTEN FIELD THE UNIT DOES NOT DECLARE IS THE ONE THE SPAWN CONSUMES
	# before the unit exists. Any other would be dropped by `setup`, in silence.
	ok(undeclared == ["max_hp_pct"], "§3a: authored stat fields the unit does not declare: %s" % [undeclared])
	# THE ZERO-BASE POPULATION, PRINTED: a declared number whose default is not zero
	# and which no class's spawn config carries — a payload there REPLACES the
	# default, because the add starts from nothing.
	var carried: Array = []
	for k in SEATS:
		for key in Classes.hero_config(String(k)):
			if not carried.has(String(key)):
				carried.append(String(key))
	var zero_base: Array = []
	for f2 in props:
		var v: Variant = props[f2]
		if (v is int or v is float) and float(v) != 0.0 and not carried.has(String(f2)) \
				and not String(f2).begins_with("_") and String(f2) != "frame_size":
			zero_base.append(String(f2))
	zero_base.sort()
	print("    replace-not-add fields: %s" % [zero_base])
	ok(zero_base.has("healing_received_mult") and zero_base.has("parry_chance"),
		"§3a: the replace-not-add population lost its two a crest would reach for: %s" % [zero_base])

	# (3) PLUMBING: every every-hero field arrives on all four through the crest.
	var w: Node = await _battle(SEATS, ENG4, {"stat": EVERY_HERO.merged({"max_hp": CREST_HP, "max_hp_pct": 0.1})}, true)
	var got_w: Array = []
	for u in _heroes(w):
		var row := {}
		for f3 in EVERY_HERO:
			row[f3] = (u as BattleUnit).get(f3)
		row["max_hp"] = (u as BattleUnit).max_hp
		row["has_pct"] = (u as BattleUnit).get("max_hp_pct") != null
		got_w.append(row)
	var o: Node = await _battle(SEATS, ENG4, {}, false)
	var got_o: Array = []
	for u2 in _heroes(o):
		var row2 := {}
		for f4 in EVERY_HERO:
			row2[f4] = (u2 as BattleUnit).get(f4)
		row2["max_hp"] = (u2 as BattleUnit).max_hp
		got_o.append(row2)
	var arrived := 0
	var missed: Array = []
	for i in mini(got_w.size(), got_o.size()):
		for f5 in EVERY_HERO:
			var d: float = float(got_w[i][f5]) - float(got_o[i][f5])
			if is_equal_approx(d, float(EVERY_HERO[f5])):
				arrived += 1
			else:
				missed.append("%s on hero %d (+%s)" % [f5, i, d])
	print("    CHECKED %d fields on %d heroes: %d arrived" % [EVERY_HERO.size(), got_w.size(), arrived])
	ok(got_w.size() == 4 and arrived == EVERY_HERO.size() * 4,
		"§3a: every-hero fields that did not arrive at their delta: %s" % [missed.slice(0, 6)])
	# MULTIPLICATIVE, AT THE SPAWN: the flat health is multiplied by the percentage,
	# which is consumed and is not a field the unit carries.
	var hp_ok := got_w.size() == 4
	for j in mini(got_w.size(), got_o.size()):
		var want := int(round((int(got_o[j]["max_hp"]) + CREST_HP) * 1.1))
		if int(got_w[j]["max_hp"]) != want or bool(got_w[j]["has_pct"]):
			hp_ok = false
			print("    hero %d: max_hp %d, want %d (base %d)" % [j, got_w[j]["max_hp"], want, got_o[j]["max_hp"]])
	ok(hp_ok, "§3a: +9 health and +10% did not land as (base + 9) x 1.10 on every hero, or the percentage is a field")

	# (4) ADDITIVE, READ AT EVERY BLOW: the crest's Attack adds to the stat the blow
	# reads. Both arms carry a heavy base so a blow rounds to a point in ~80 — +400
	# against +300 on a base of 100 is 500 / 400, x1.25.
	var a_w: Node = await _battle(SEATS, ENG4, {"stat": {"attack": 400}}, true)
	var dealt_w := await _blow(a_w, _heroes(a_w)[0], _foe(a_w), 4101)
	var a_o: Node = await _battle(SEATS, ENG4, {"stat": {"attack": 300}}, true)
	var dealt_o := await _blow(a_o, _heroes(a_o)[0], _foe(a_o), 4101)
	var ratio_a := float(dealt_w) / maxf(float(dealt_o), 1.0)
	print("    additive (Attack +400 against +300): %d against %d, x%.3f" % [dealt_w, dealt_o, ratio_a])
	ok(dealt_o > 20 and ratio_a >= 1.22 and ratio_a <= 1.28,
		"§3a: Attack +400 against +300 from the crest read %d against %d (x%.3f), not x1.25" % [dealt_w, dealt_o, ratio_a])

	# (5) MULTIPLICATIVE, READ AT EVERY BLOW: +10% damage on the same heavy blow.
	var m_w: Node = await _battle(SEATS, ENG4, {"stat": {"attack": 300, "dmg_bonus": 0.1}}, true)
	var dm_w := await _blow(m_w, _heroes(m_w)[0], _foe(m_w), 4102)
	var m_o: Node = await _battle(SEATS, ENG4, {"stat": {"attack": 300}}, true)
	var dm_o := await _blow(m_o, _heroes(m_o)[0], _foe(m_o), 4102)
	var ratio_m := float(dm_w) / maxf(float(dm_o), 1.0)
	print("    multiplicative (+10%% damage dealt): %d against %d, x%.3f" % [dm_w, dm_o, ratio_m])
	ok(dm_o > 0 and ratio_m >= 1.08 and ratio_m <= 1.12,
		"§3a: +10%% damage dealt from the crest read x%.3f on the same blow (%d against %d)" % [ratio_m, dm_w, dm_o])

	# (6) MAX-MERGED, AT THE SPAWN: the party-wide stamp takes the best holder, ONCE.
	var x0: Node = await _battle(SEATS, ENG4, {}, false)
	var none_have := true
	for u3 in _heroes(x0):
		if (u3 as BattleUnit).has_status("devotion"):
			none_have = false
	var x1: Node = await _battle(SEATS, ENG4, {"stat": {"devoutness_ranks": 5}}, true)
	var p1: Array = []
	for u4 in _heroes(x1):
		p1.append((u4 as BattleUnit).status_power("devotion") if (u4 as BattleUnit).has_status("devotion") else -1)
	var x2: Node = await _battle(SEATS, ENG4, {"stat": {"devoutness_ranks": 5}}, true, -1,
		{"seat": 2, "payload": {"stat": {"devoutness_ranks": 7}}})
	var p2: Array = []
	var cl_field := -1
	for u5 in _heroes(x2):
		p2.append((u5 as BattleUnit).status_power("devotion") if (u5 as BattleUnit).has_status("devotion") else -1)
		if (u5 as BattleUnit).hero_key == "cleric":
			cl_field = int((u5 as BattleUnit).devoutness_ranks)
	print("    max-merged (We Do Not Break): none %s; crest 5 -> %s; crest 5 + the Cleric's 7 -> %s" % [not none_have, p1, p2])
	ok(none_have, "§3a: a party with no source of the stamp carries it")
	ok(p1 == [5, 5, 5, 5], "§3a: four heroes each carrying the crest's 5 were stamped %s — four copies are the best holder's ONE" % [p1])
	ok(cl_field == 12 and p2 == [12, 12, 12, 12],
		"§3a: the Cleric at 12 beside three at 5 stamped %s (his field %d) — the best holder's figure, never the sum" % [p2, cl_field])

	# (7) RESOLVES AND DOES WHAT IT DOES NOT SAY — THE ZERO-BASE TRAP. The spawn
	# carries a healing multiplier for the Cleric alone, and a parry chance only
	# where a lineage's stat block sets one, so on everyone else the crest's value
	# REPLACES the default rather than adding to it.
	# Each battle is read before the next replaces it (a changed scene frees the old).
	var t_w: Node = await _battle(SEATS, ENG4, {"stat": {"healing_received_mult": 0.2, "parry_chance": 0.1}}, true)
	var mult_w: Array = []
	var parry_w: Array = []
	for u7 in _heroes(t_w):
		mult_w.append(snappedf(float((u7 as BattleUnit).healing_received_mult), 0.01))
		parry_w.append(float((u7 as BattleUnit).parry_chance))
	var war_w: BattleUnit = _heroes(t_w)[0]
	war_w.hp = 1
	var healed_w := war_w.heal_amount(100)
	var t_o: Node = await _battle(SEATS, ENG4, {}, false)
	var mult_o: Array = []
	var parry_o: Array = []
	for u8 in _heroes(t_o):
		mult_o.append(snappedf(float((u8 as BattleUnit).healing_received_mult), 0.01))
		parry_o.append(float((u8 as BattleUnit).parry_chance))
	var war_o: BattleUnit = _heroes(t_o)[0]
	war_o.hp = 1
	var healed_o := war_o.heal_amount(100)
	var parry_replaced := 0
	var parry_sentinels := 0
	for k2 in mini(parry_w.size(), parry_o.size()):
		if float(parry_o[k2]) < 0.0:
			parry_sentinels += 1
			if is_equal_approx(float(parry_w[k2]), 0.1):
				parry_replaced += 1
	print("    healing received, with the crest's +0.20: %s (without: %s)" % [mult_w, mult_o])
	ok(_approx(mult_o, [1.0, 1.0, 1.15, 1.0]) and _approx(mult_w, [0.2, 0.2, 1.35, 0.2]),
		"§3a: +0.20 healing received read %s against %s — on every hero but the Cleric it should REPLACE 1.0" % [mult_w, mult_o])
	print("    a heal of 100 on the Warrior lands %d with the crest, %d without" % [healed_w, healed_o])
	print("    parry chance, with the crest's +0.10: %s (without: %s) — %d of the %d on the role baseline replaced" % [
		parry_w, parry_o, parry_replaced, parry_sentinels])
	ok(healed_o == 100 and healed_w == 20,
		"§3a: a heal of 100 on the Warrior landed %d with the crest and %d without — the trap is closed, re-derive the census" % [healed_w, healed_o])
	ok(parry_sentinels >= 1 and parry_replaced == parry_sentinels,
		"§3a: %d of the %d heroes on the role baseline had their parry chance REPLACED by +0.10 (the baseline is %.2f)" % [
			parry_replaced, parry_sentinels, 0.05])

	# (8) RESOLVES AND DOES NOTHING: a key the unit does not declare is dropped by
	# `setup`, and a field one currency reads pays the other classes nothing.
	var d_w: Node = await _battle(SEATS, ENG4, {"stat": {"hn_no_such_field": 7, "mana_regen_bonus": 5}}, true)
	var dw: Array = _heroes(d_w)
	var dropped := 0
	var regen_w: Array = []
	for u6 in dw:
		if (u6 as BattleUnit).get("hn_no_such_field") == null:
			dropped += 1
		regen_w.append(int(d_w._mana_regen(u6)))
	var war_res := String((dw[0] as BattleUnit).resource_name) if not dw.is_empty() else ""
	ok(dw.size() == 4 and dropped == 4, "§3a: an undeclared key landed on %d of the four heroes, or the spawn did not finish" % (4 - dropped))
	var d_o: Node = await _battle(SEATS, ENG4, {}, false)
	var regen_up: Array = []
	var ks := 0
	for u9 in _heroes(d_o):
		if ks < regen_w.size():
			regen_up.append(int(regen_w[ks]) - int(d_o._mana_regen(u9)))
		ks += 1
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	# The drip's own guard is the nearest one ABOVE the drip, never the first in the
	# file — `resource_name == "Mana"` is asked in dozens of places.
	var regen_at := bs.find("u.resource = mini(u.resource + _mana_regen(u), u.max_resource)")
	var guard_at := bs.rfind("if u.resource_name == \"Mana\":", regen_at)
	print("    Mana a turn, with the crest's +5: %s; the Warrior's resource is %s" % [regen_up, war_res])
	ok(regen_up == [5, 5, 5, 5] and war_res == "Rage",
		"§3a: the regen field arrived as %s on the four" % [regen_up])
	ok(regen_at > guard_at and guard_at > 0 and regen_at - guard_at < 200,
		"§3a: the turn's Mana drip is not behind the Mana guard, so the census's one-currency row is wrong")


# ── §3b — A CONDITION HOLDS SEVERAL KEYS, AND EVERY ONE MUST HOLD ───────────

func _s3b_two_keys() -> void:
	print("\n§3b — a condition with two keys: no Mage AND two Warriors")
	var both := {"heroes_lack_class": "mage",
		"heroes_class_count": {"class": "warrior", "min": 2, "max": 2}}
	var wwch := ["warrior", "warrior", "cleric", "hunter"]
	var e_wwch := ["bloodrage", "heavy_plating", "mercy", "pack"]
	var yes := await _paid(wwch, e_wwch, both)
	ok(int(yes["paid"]) == 4 and not bool(yes["told"]),
		"§3b: two Warriors and no Mage were paid on %d of the four (told %s)" % [yes["paid"], yes["told"]])
	var mage_in := await _paid(["warrior", "warrior", "mage", "hunter"],
		["bloodrage", "heavy_plating", "overburn", "pack"], both)
	ok(int(mage_in["paid"]) == 0 and bool(mage_in["told"]),
		"§3b: two Warriors beside a Mage were paid on %d — the second key failed and the first alone paid" % mage_in["paid"])
	var one_w := await _paid(["warrior", "cleric", "cleric", "hunter"],
		["bloodrage", "mercy", "conviction", "pack"], both)
	ok(int(one_w["paid"]) == 0 and bool(one_w["told"]),
		"§3b: one Warrior and no Mage were paid on %d — the count failed and the absence alone paid" % one_w["paid"])
	# THE POSITIVE ARM: the half that failed the last party is a live key on its own,
	# so the refusal above is the AND's and not a dead key's.
	var half := await _paid(["warrior", "cleric", "cleric", "hunter"],
		["bloodrage", "mercy", "conviction", "pack"], {"heroes_lack_class": "mage"})
	ok(int(half["paid"]) == 4, "§3b: 'no Mage' alone was paid on %d of the four — the AND's refusal is not the AND's" % half["paid"])
	print("    both hold: %d; the second fails: %d; the first fails: %d; the first alone: %d" % [
		yes["paid"], mage_in["paid"], one_w["paid"], half["paid"]])


# ── §3c — `heroes_all_standing: false` ──────────────────────────────────────

func _s3c_all_standing_false() -> void:
	print("\n§3c — heroes_all_standing: false")
	var f_up := await _paid(SEATS, ENG4, {"heroes_all_standing": false})
	var f_down := await _paid(SEATS, ENG4, {"heroes_all_standing": false}, 1)
	var t_down := await _paid(SEATS, ENG4, {"heroes_all_standing": true}, 1)
	print("    false, all standing: %d; false, the Mage fallen: %d; true, the Mage fallen: %d" % [
		f_up["paid"], f_down["paid"], t_down["paid"]])
	# IT DOES NOT INVERT: `false` is read as "not asked", so it pays whatever the
	# party — the fallen Mage included, whose stamp lands before he is laid down.
	ok(int(f_up["paid"]) == 4 and int(f_down["paid"]) == 4,
		"§3c: `false` paid %d with all standing and %d with the Mage fallen — it now reads something" % [f_up["paid"], f_down["paid"]])
	# THE POSITIVE ARM: the key reads a fallen hero in its `true` form.
	ok(int(t_down["paid"]) == 0 and bool(t_down["told"]),
		"§3c: `true` with the Mage fallen paid %d — the key reads nothing at all" % t_down["paid"])


# ── §3d — A CARD A CREST GRANTS ─────────────────────────────────────────────

const FREE_CARD := {"display_name": "HN Fixture Strike", "cost": 0, "damage": 30,
	"pressure": 10, "delay": 2.0, "cooldown": 2, "anim": "attack01",
	"perfect_id": "", "perfect_text": "", "description": "A fixture of check_hn: 30% of Attack."}
const PRICED_CARD := {"display_name": "HN Fixture Rally", "cost": 20, "damage": 30,
	"pressure": 10, "delay": 2.0, "cooldown": 2, "anim": "attack01",
	"perfect_id": "", "perfect_text": "", "description": "A fixture of check_hn at 20."}


func _bar_has(u: BattleUnit, card: String) -> Ability:
	for ab in u.abilities:
		if (ab as Ability).display_name == card:
			return ab
	return null


func _s3d_a_granted_card() -> void:
	print("\n§3d — a card a crest grants, on a real battle")
	var grant := {"new_ability": FREE_CARD, "also": [{"new_ability": PRICED_CARD}]}
	var s: Node = await _battle(SEATS, ENG4, grant, true)
	var hs: Array = _heroes(s)
	var on_bars := 0
	for u in hs:
		if _bar_has(u, "HN Fixture Strike") != null and _bar_has(u, "HN Fixture Rally") != null:
			on_bars += 1
	ok(hs.size() == 4 and on_bars == 4, "§3d: the crest's cards reached %d of the four bars" % on_bars)
	var war: BattleUnit = hs[0]
	var mag: BattleUnit = hs[1]
	var free_w: Ability = _bar_has(war, "HN Fixture Strike")
	var priced_w: Ability = _bar_has(war, "HN Fixture Rally")
	var priced_m: Ability = _bar_has(mag, "HN Fixture Rally")
	# WHAT A CLASS-NEUTRAL CARD IS ON A WARRIOR'S BAR: priced in his own resource,
	# which opens at nothing — so a priced card is dark where the Mage's is lit.
	var lit_w_free := free_w != null and bool(s._ability_usable(war, free_w))
	var lit_w_priced := priced_w != null and bool(s._ability_usable(war, priced_w))
	var lit_m_priced := priced_m != null and bool(s._ability_usable(mag, priced_m))
	print("    the Warrior at %d %s: the free card %s, the 20-cost card %s; the Mage at %d %s: the 20-cost card %s" % [
		war.resource, war.resource_name, "lit" if lit_w_free else "dark", "lit" if lit_w_priced else "dark",
		mag.resource, mag.resource_name, "lit" if lit_m_priced else "dark"])
	ok(lit_w_free and not lit_w_priced and lit_m_priced,
		"§3d: at the opening the Warrior's free card lit %s, his 20-cost card lit %s, the Mage's lit %s" % [
			lit_w_free, lit_w_priced, lit_m_priced])
	# IT WORKS: cast off the Warrior's bar, it strikes, and it is still there after.
	var foe := _foe(s)
	var dealt := 0
	if free_w != null and foe != null:
		foe.hp = foe.max_hp
		seed(4103)
		var before := foe.hp
		await s._resolve(war, free_w, foe, "good")
		dealt = before - foe.hp
	ok(dealt > 0, "§3d: the granted card struck for %d off the Warrior's bar" % dealt)
	ok(_bar_has(war, "HN Fixture Strike") != null and int(war.cooldowns.get("HN Fixture Strike", 0)) > 0,
		"§3d: after its cast the card left the bar, or started no cooldown")
	# THE BATTLE'S COPY: the member was never handed it — he owns it only while the
	# crest is worn, and the next fight's spawn grants it again.
	var owned := false
	for m in _run.party:
		if (m as Dictionary).get("bm_abilities", []).has("HN Fixture Strike") \
				or _run.owned_ability_names(m).has("HN Fixture Strike"):
			owned = true
	ok(not owned, "§3d: a hero OWNS the crest's card — the grant reached the member, not the battle's copy")
	var s2: Node = await _battle(SEATS, ENG4, grant, true)
	var again := 0
	for u2 in _heroes(s2):
		if _bar_has(u2, "HN Fixture Strike") != null:
			again += 1
	var s3: Node = await _battle(SEATS, ENG4, grant, false)
	var without := 0
	for u3 in _heroes(s3):
		if _bar_has(u3, "HN Fixture Strike") != null:
			without += 1
	ok(again == 4 and without == 0,
		"§3d: the next fight granted it to %d with the crest and %d without it" % [again, without])
	print("    four bars: %d; struck %d; owned after: %s; the next fight: %d with, %d without" % [
		on_bars, dealt, owned, again, without])


# ── §3e — `heroes_class_count` READS A NAMED CLASS ──────────────────────────

func _s3e_any_class() -> void:
	print("\n§3e — heroes_class_count: any class with two or more")
	var wwch := ["warrior", "warrior", "cleric", "hunter"]
	var e_wwch := ["bloodrage", "heavy_plating", "mercy", "pack"]
	var any := await _paid(wwch, e_wwch, {"heroes_class_count": {"class": "any", "min": 2}})
	var named := await _paid(wwch, e_wwch, {"heroes_class_count": {"class": "warrior", "min": 2}})
	print("    'any', two Warriors seated: %d; 'warrior', the same party: %d" % [any["paid"], named["paid"]])
	ok(int(any["paid"]) == 0 and bool(any["told"]),
		"§3e: a class named 'any' paid %d with two Warriors seated — the key now reads any class" % any["paid"])
	ok(int(named["paid"]) == 4, "§3e: the named class paid %d of the four — the key reads nothing" % named["paid"])


# ── §3 — THE FILE AND THE TABLE ─────────────────────────────────────────────

func _s3_the_file_and_the_table() -> void:
	print("\n§3 — the fixtures stayed fixtures")
	var authored := 0
	var file_data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	for id in (file_data as Dictionary):
		if String(((file_data as Dictionary)[id] as Dictionary).get("scope", "")) == "party":
			authored += 1
	ok((file_data as Dictionary).size() > 100, "§3: data/runes.json read back %d entries" % (file_data as Dictionary).size())
	ok(authored == 0, "§3: %d crest runes are authored in the file — the ruling is none" % authored)
	Runes._load().erase(CREST_FX)
	Runes._load().erase(HERO_FX)
	ok(not Runes.ids().has(CREST_FX) and not Runes.ids().has(HERO_FX),
		"§3: a fixture was left in the loaded table")
	ok(Runes.ids().has("fourth_stack"), "§3: erasing the fixtures took a real entry with them")


# ── §4 — ORDINATION'S COMMENT ───────────────────────────────────────────────

func _s4_ordination() -> void:
	print("\n§4 — Ordination's comment names the threshold")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var anchor := "\n\t\t\"ordination\":\n"
	ok(bsrc.count(anchor) == 1, "§4: Ordination's arm is written %d times" % bsrc.count(anchor))
	var at := bsrc.find(anchor)
	var end := bsrc.find("var od_grant :=", at)
	var win := bsrc.substr(at, end - at) if at >= 0 and end > at else ""
	# THE POSITIVE ARM: this is the handler's comment and not another body's.
	ok(win.contains("THE LOWEST HOLDER, NOT A CLICK") and end - at < 1500,
		"§4: the window is not Ordination's comment (%d chars)" % (end - at))
	var rx := RegEx.new()
	rx.compile("(?i)\\bfive\\b")
	ok(win != "" and rx.search(win) == null, "§4: Ordination's comment still says five")
	ok(win.contains("FAITH_RELEASE"), "§4: Ordination's comment does not name the constant the cap is")


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§9: %s changed under this gate" % p)
