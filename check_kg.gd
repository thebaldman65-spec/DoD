# BATCH KG — EACH NEW ZONE FIELDS ITS OWN ELITE, AND THE DROWNED BARROW ITS OWN MENDER (the designer's (a), 24 November, answering
# KF's balance question with *"Each zone's own (a)"*, and the four figures after it: the Maul's copy *None, as the Chief*; the
# mender *One attack, as the Shaman*; the damage type *The zone's*; the resists *The zone's*).
#
# What this gate asserts, section by section (`docs/reports/KG.md` has the working):
#
#   §1  THE KINDS, WRITTEN ON THEIR ORIGINALS: the Rimeclad Warlord and the Drowned Thane carry every key of the Orc Chief at his
#       figure, and the Peat Witch every key of the Orc Shaman at hers, but for the name, the zones, the tint, the resists and the
#       renamed moves; each kind's moves stand in the original's order at its figures, each renamed move dealing the ruled type
#       (frost, shadow; the Witch's one attack nature, the Shaman's own); the Maul's copies cool as the Chief's and cost his Rage
#       (answer 1) — since KJ the Maul's place holds War Cry, the Chief's on all four elites, unrenamed (in the zone's type since KK, as the
#       Maul it took the place of: KJ's item 10), cooling 3 at
#       the Maul's Rage (the designer's F1 and answer 6); the Witch holds one damaging move (answer 2); the resists are the ruled
#       ones (answer 4), each with a weakness.
#   §2  THE ROSTERS: the Orc Chief stands in the Scarlands' roster alone (the Forest's and the Scarlands' from KG §1 until KH §1,
#       the designer's word, moved the Orcs to the Scarlands); each new zone's roster holds one
#       elite, its own; the Barrow's holds a mender, the Witch; and at every budget an elite node can roll, an elite theme composes
#       in each new zone. What each zone never fields is printed.
#   §3  THE KINDS IN A FIGHT, DRIVEN: a battle fields the three through `Enemies.config`; each unit carries its name, resists and
#       kit as §1 reads them off the data, the Maul's place at the Chief's War Cry (since KJ); and each damaging move, struck on a
#       hero under the same dice, takes far less off a hero who resists its ruled type than off one who does not — the type
#       reaches the blow's door; and
#       (§3b) the Witch, a hurt ally beside her and a pool that can pay, chooses her Healing Wave on it — the move the support
#       code reads by its name.
#   §4  THE RECORD: `CLAUDE.md`'s zone block names each zone's own elite and the Barrow's mender.
#   §5  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the zones play as the designer wants — the figures
# are the designer's (RECORD_KG) and the sim tests the code; and how the three read on screen — every enemy shares the one
# orc sheet, tint and scale only (`Enemies.SHEET`).
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["rimeclad_warlord", "drowned_thane", "peat_witch"]}
const SCRATCH_PROFILE := "user://kg_profile.json"
const SCRATCH_RELICS := "user://kg_relics.json"
const ENEMIES_JSON := "res://data/enemies.json"
const ZONE_BLOCK := "## STANDING DESIGN RULE — A ZONE FIELDS ITS OWN KINDS"
# THE THREE AS BUILT: the pattern, the zone, the type each renamed blow deals and the resists are the designer's (RECORD_KG: (a)
# and answers 3 and 4); the names are KG's (its reading 3). A key absent here is the pattern's at its figure.
const KINDS := {
	"rimeclad_warlord": {"pattern": "chief", "name": "Rimeclad Warlord", "zone": "frozen_plains",
		"moves": {"Strike": "Frostbrand Cut", "Heavy Strike": "Glacial Hew", "Chieftain's Maul": "Avalanche Maul"},
		"type": "frost", "resists": {"frost": 0.5, "fire": -0.25}},
	"drowned_thane": {"pattern": "chief", "name": "Drowned Thane", "zone": "drowned_barrow",
		"moves": {"Strike": "Drowned Blade", "Heavy Strike": "Sunken Cleave", "Chieftain's Maul": "Barrow Maul"},
		"type": "shadow", "resists": {"shadow": 0.5, "holy": -0.25}},
	"peat_witch": {"pattern": "shaman", "name": "Peat Witch", "zone": "drowned_barrow",
		"moves": {"Chain Lightning": "Marshlight Chain"},
		"type": "", "resists": "pattern"},
}
# BATCH KJ — THE MAUL's PLACE HOLDS WAR CRY ON ALL FOUR ELITES (the designer's F1 and answer 6, RECORD_KJ): one move, the Chief's —
# a physical blow, cooling 3, at the Maul's Rage — so the Warlord's and the Thane's are neither renamed nor typed, and each cools
# as the Chief's does (answer 1's rule). KG's Maul names above stand for the move KJ replaced; no kit holds them.
const MAUL := {"rimeclad_warlord": "War Cry", "drowned_thane": "War Cry"}
# The keys a kind may carry apart from its pattern's figure.
const OWN_KEYS := ["unit_name", "zones", "tint", "resists", "abilities"]

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _data := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KG — EACH NEW ZONE's OWN ELITE, AND THE BARROW's MENDER")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before anything is written")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_data = JSON.parse_string(FileAccess.get_file_as_string(ENEMIES_JSON))
	_fresh_meta()
	_s1_kinds()
	_s2_rosters()
	await _s3_fight()
	_s4_record()
	Engine.time_scale = 1.0
	_s5_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


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


func _roster_of(zone: String) -> int:
	return int((_run.ZONE_DEFS[zone] as Dictionary)["roster"])


# The resists a kind is ruled: its own, or its pattern's.
func _want_resists(kind: String) -> Dictionary:
	var w = KINDS[kind]["resists"]
	return (_data[KINDS[kind]["pattern"]] as Dictionary)["resists"] if typeof(w) == TYPE_STRING else w


# BATCH KJ — THE CHIEF's MOVE OF A NAME, off the data: the copy a kind holds of it cools and costs as his does.
func _chief_move(name: String) -> Dictionary:
	for a in ((_data.get("chief", {}) as Dictionary).get("abilities", []) as Array):
		if String((a as Dictionary).get("display_name", "")) == name:
			return a
	return {}


# ── §1 — THE KINDS ───────────────────────────────────────────────────────────

func _s1_kinds() -> void:
	print("\n§1 — the three kinds, written on their originals' figures (the designer's (a)), named as built")
	var checked := 0
	for kind in KINDS:
		var spec: Dictionary = KINDS[kind]
		var k: Dictionary = _data.get(kind, {})
		var pat: Dictionary = _data.get(String(spec["pattern"]), {})
		if k.is_empty() or pat.is_empty():
			ok(false, "§1: %s or its pattern %s is not in data/enemies.json" % [kind, spec["pattern"]])
			continue
		ok(String(k["unit_name"]) == String(spec["name"]), "§1: %s is named %s" % [kind, k.get("unit_name")])
		var r := _roster_of(String(spec["zone"]))
		ok((k["zones"] as Array).size() == 1 and int(k["zones"][0]) == r, "§1: %s's zones are %s, not [%d]" % [kind, str(k["zones"]), r])
		# Every key but its own at the pattern's figure, and no key the pattern lacks.
		var off: Array = []
		for key in pat:
			if OWN_KEYS.has(key):
				continue
			if not k.has(key) or str(k[key]) != str(pat[key]):
				off.append(key)
		for key in k:
			if not pat.has(key):
				off.append("+" + String(key))
		ok(off.is_empty(), "§1: %s departs from %s's figures at %s" % [kind, spec["pattern"], str(off)])
		ok(str(k["resists"]) == str(_want_resists(kind)), "§1: %s resists %s, ruled %s" % [kind, str(k["resists"]), str(_want_resists(kind))])
		ok((k["resists"] as Dictionary).values().any(func(v): return float(v) < 0.0), "§1: %s carries no weakness" % kind)
		ok(str(k["tint"]) != str(pat["tint"]), "§1: %s wears its pattern's tint" % kind)
		# The moves: the pattern's, in its order, at its figures; the renamed ones named and typed as ruled.
		var ka: Array = k["abilities"]
		var pa: Array = pat["abilities"]
		ok(ka.size() == pa.size(), "§1: %s holds %d moves, its pattern %d" % [kind, ka.size(), pa.size()])
		for i in mini(ka.size(), pa.size()):
			var a: Dictionary = ka[i]
			var p: Dictionary = pa[i]
			var pn := String(p["display_name"])
			var want_name := String((spec["moves"] as Dictionary).get(pn, pn))
			ok(String(a["display_name"]) == want_name, "§1: %s's move %d is %s, want %s" % [kind, i, a["display_name"], want_name])
			# BATCH KK — the Maul's place, War Cry, deals the zone's type as a renamed blow does (KJ's item 10: its Maul's type).
			var typed := ((spec["moves"] as Dictionary).has(pn) or String(MAUL.get(kind, "")) == pn) and String(spec["type"]) != ""
			var want_type := String(spec["type"]) if typed else String(p.get("dmg_type", ""))
			ok(String(a.get("dmg_type", "")) == want_type, "§1: %s's %s deals %s, want %s" % [kind, a["display_name"], a.get("dmg_type", "physical"), want_type if want_type != "" else "physical"])
			var moved: Array = []
			for key in p:
				if key in ["display_name", "dmg_type"]:
					continue
				if not a.has(key) or str(a[key]) != str(p[key]):
					moved.append(key)
			for key in a:
				if not p.has(key) and not key in ["dmg_type"]:
					moved.append("+" + String(key))
			ok(moved.is_empty(), "§1: %s's %s departs from %s's %s at %s" % [kind, a["display_name"], spec["pattern"], pn, str(moved)])
			checked += 1
		if MAUL.has(kind):
			var maul: Dictionary = {}
			for a in ka:
				if String(a["display_name"]) == String(MAUL[kind]):
					maul = a
			# BATCH KJ — REPAIRED TO ITS INTENT: answer 1 is *as the Chief's*, and since KJ the Chief's is War Cry, cooling 3 at the
			# Maul's Rage (answer 6), where his Maul cooled at 0.
			var chief_m := _chief_move(String(MAUL[kind]))
			ok(not maul.is_empty() and not chief_m.is_empty() and int(maul.get("cooldown", 0)) == int(chief_m.get("cooldown", -1))
					and int(maul.get("cooldown", 0)) > 0 and int(maul.get("cost", 0)) == int(chief_m.get("cost", -1)) and int(maul.get("cost", 0)) > 0,
				"§1: %s's %s cools %s at %s Rage — the designer's answer 1 is as the Chief's, and his War Cry cools %s at %s since KJ" % [
					kind, MAUL[kind], str(maul.get("cooldown", "?")), str(maul.get("cost", "?")), str(chief_m.get("cooldown", "?")), str(chief_m.get("cost", "?"))])
	var w: Array = (_data.get("peat_witch", {}) as Dictionary).get("abilities", [])
	var hitters: Array = w.filter(func(a): return int(a.get("damage", 0)) > 0)
	ok(hitters.size() == 1, "§1: the Peat Witch holds %d damaging moves — the designer's answer 2 is one, as the Shaman's" % hitters.size())
	print("    CHECKED %d moves of %d kinds against their originals; the Witch's damaging moves: %d" % [checked, KINDS.size(), hitters.size()])


# ── §2 — THE ROSTERS ─────────────────────────────────────────────────────────

func _s2_rosters() -> void:
	print("\n§2 — the rosters: each new zone's own elite, the Barrow's own mender, the Chief at home")
	var chief_in: Array = []
	for z in _run.ZONE_ORDER:
		if Enemies.kinds_for_roster(_roster_of(String(z))).has("chief"):
			chief_in.append(String(z))
	# BATCH KH §1 — REPAIRED TO ITS INTENT: the arm held the Chief at home, in the old zones and in no new one; since KH his home
	# is the Scarlands alone (the designer's *"lets move the orcs to scarlands"*), and `check_kh` §2 holds the Forest's own elite.
	ok(chief_in == ["scarlands"], "§2: the Orc Chief stands in %s — since KH the Scarlands alone" % str(chief_in))
	for z in ["frozen_plains", "drowned_barrow"]:
		var ks: Array = Enemies.kinds_for_roster(_roster_of(z))
		var elites: Array = ks.filter(func(k): return Enemies.roles(String(k)).has("elite"))
		var menders: Array = ks.filter(func(k): return Enemies.roles(String(k)).has("mender"))
		var own: Array = KINDS.keys().filter(func(k): return String(KINDS[k]["zone"]) == z)
		print("    %-15s roster %d: %d kinds; elite %s; mender %s" % [z, _roster_of(z), ks.size(), str(elites), str(menders)])
		ok(elites.size() == 1 and own.has(elites[0]), "§2: %s's elites are %s — want its own, one" % [z, str(elites)])
		ok(own.all(func(k): return ks.has(k)), "§2: %s's roster lacks one of its own %s" % [z, str(own)])
		ok(not menders.is_empty(), "§2: %s's roster holds no mender" % z)
	ok(Enemies.kinds_for_roster(_roster_of("drowned_barrow")).has("peat_witch"), "§2: the Barrow's mender is not the Peat Witch")
	# EVERY BUDGET AN ELITE NODE CAN ROLL, AN ELITE THEME COMPOSES IN EACH NEW ZONE; AND WHAT EACH NEVER FIELDS, PRINTED.
	var themes: Dictionary = _run.THEMES
	var holes: Array = []
	var asked := 0
	for z in ["frozen_plains", "drowned_barrow"]:
		for budget in range(6, 11):
			asked += 1
			var n := 0
			for t in themes:
				if (themes[t]["nodes"] as Array).has("elite"):
					n += int(_run._theme_count(themes[t], budget, _roster_of(z), ""))
			if n <= 0:
				holes.append("%s %d" % [z, budget])
	ok(asked == 10 and holes.is_empty(), "§2: an elite node composes no theme at %s" % str(holes))
	for z in _run.ZONE_ORDER:
		var never: Array = []
		for t in themes:
			var any := false
			for kind in themes[t]["nodes"]:
				var lo: int = {"fight": 3, "elite": 6, "boss": 10}.get(kind, 3)
				var hi: int = {"fight": 10, "elite": 10, "boss": 12}.get(kind, 10)
				var named := String(_run.ZONE_DEFS[z]["boss"]) if kind == "boss" else ""
				for b in range(lo, hi + 1):
					if int(_run._theme_count(themes[t], b, _roster_of(String(z)), named)) > 0:
						any = true
			if not any:
				never.append(String(t))
		print("    %-15s never fields: %s" % [z, ", ".join(PackedStringArray(never)) if not never.is_empty() else "—"])
	print("    CHECKED %d elite budgets in the two zones" % asked)


# ── §3 — THE KINDS IN A FIGHT ────────────────────────────────────────────────

func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(ENG4[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _battle() -> Node:
	_new_run()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	Engine.time_scale = 1.0
	return current_scene


# One blow of `ab` on `w` under fixed dice, the hero's resist to `type` set to `res`: the health it took.
func _blow(s: Node, atk: BattleUnit, ab: Ability, w: BattleUnit, type: String, res: float) -> int:
	w.hp = w.max_hp
	w.dead = false
	w.pressure = 0
	w.broken = false
	w.broken_pending = false
	w.resists = {type: res}
	seed(4242)
	var hp0 := w.hp
	await s._resolve(atk, ab, w, "good")
	return hp0 - w.hp


func _s3_fight() -> void:
	print("\n§3 — the three in a fight: built through the config door, each blow dealt in its ruled type")
	var s: Node = await _battle()
	var foes: Array = (s.get("enemies") as Array)
	var by := {}
	for e in foes:
		by[String((e as BattleUnit).enemy_kind)] = e
	ok(KINDS.keys().all(func(k): return by.has(k)), "§3: the fight fielded %s — want the three" % str(by.keys()))
	var hero: BattleUnit = (s.get("heroes") as Array)[0]
	var blows := 0
	for kind in KINDS:
		if not by.has(kind):
			continue
		var u: BattleUnit = by[kind]
		var raw: Dictionary = _data[kind]
		ok(u.unit_name == String(raw["unit_name"]) and str(u.resists) == str(_want_resists(kind)),
			"§3: %s fields as %s resisting %s" % [kind, u.unit_name, str(u.resists)])
		var names: Array = u.abilities.map(func(a): return (a as Ability).display_name)
		var want_names: Array = (raw["abilities"] as Array).map(func(a): return String(a["display_name"]))
		ok(names == want_names, "§3: %s fields the kit %s, the data holds %s" % [kind, str(names), str(want_names)])
		for ab in u.abilities:
			var a := ab as Ability
			if MAUL.has(kind) and a.display_name == String(MAUL[kind]):
				# BATCH KJ — War Cry fields at the Chief's cooldown and the Maul's 20 Rage (answer 6), where the Maul fielded uncooled.
				ok(a.cooldown == int(_chief_move(a.display_name).get("cooldown", -1)) and a.cooldown > 0 and a.cost == 20,
					"§3: %s's %s fields cooling %d at %d Rage" % [kind, a.display_name, a.cooldown, a.cost])
			if a.damage <= 0 or a.special != "":
				continue
			var t := a.dmg_type
			var want_t := String(KINDS[kind]["type"]) if String(KINDS[kind]["type"]) != "" else "nature"
			# BATCH KJ, KK — War Cry is the Chief's on all four elites, and since KK it deals the zone's type, as the Maul it took
			# the place of (KJ's item 10, answered): the kind's type, as every other blow here.
			ok(t == want_t, "§3: %s's %s fields as %s, ruled %s" % [kind, a.display_name, t, want_t])
			var plain := await _blow(s, u, a, hero, t, 0.0)
			var held := await _blow(s, u, a, hero, t, 0.9)
			print("    %-16s %-16s %-6s: %3d off a hero who does not resist it, %3d off one who resists it 90%%" % [kind, a.display_name, t, plain, held])
			ok(plain > 0 and held * 4 < plain, "§3: %s's %s took %d plain and %d resisted — the type does not reach the blow" % [kind, a.display_name, plain, held])
			blows += 1
	ok(blows == 7, "§3: %d blows driven — want the Warlord's three, the Thane's three and the Witch's one" % blows)
	print("    CHECKED %d blows, each twice under the same dice" % blows)
	# §3b — THE WITCH HEALS: the support code finds a heal by its name (`_enemy_support_action`, *Healing Wave*), so a hurt ally and
	# a pool that can pay draw her heal on it — the reason the move keeps its name (KG's reading 4).
	if by.has("peat_witch") and by.has("drowned_thane"):
		var witch: BattleUnit = by["peat_witch"]
		var thane: BattleUnit = by["drowned_thane"]
		for u2 in foes:
			(u2 as BattleUnit).hp = (u2 as BattleUnit).max_hp
		thane.hp = int(thane.max_hp / 2)
		s.set("malice", 150)
		var act: Array = s.call("_enemy_support_action", witch)
		var picked := "nothing" if act.is_empty() else "%s on %s" % [(act[0] as Ability).display_name, (act[1] as BattleUnit).unit_name]
		print("    the Witch, a hurt Thane beside her and 150 Malice in the pool: %s" % picked)
		ok(not act.is_empty() and (act[0] as Ability).display_name == "Healing Wave" and act[1] == thane,
			"§3b: the Peat Witch with a hurt ally and a full pool chose %s — want her Healing Wave on the Thane" % picked)


# ── §4 — THE RECORD ──────────────────────────────────────────────────────────

func _s4_record() -> void:
	print("\n§4 — the record: CLAUDE.md's zone block names each zone's own elite and the Barrow's mender")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var at := cm.find(ZONE_BLOCK)
	var end := cm.find("\n## ", at + 4) if at >= 0 else -1
	var block := cm.substr(at, end - at) if at >= 0 and end > at else ""
	for n in ["Rimeclad Warlord", "Drowned Thane", "Peat Witch"]:
		ok(block.contains(n), "§4: CLAUDE.md's zone block does not name %s" % n)
	print("    CHECKED the block (%d B)" % block.length())


# ── §5 — THE PLAYER's FILES ──────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	print("\n§5 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§5: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§5: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
