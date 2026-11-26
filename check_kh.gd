# BATCH KH — THE ORCS TO THE SCARLANDS, AND THE FOREST OF OLD's OWN SEVEN KINDS (the designer's ask in conversation, 25
# November, *"lets move the orcs to scarlands and lets come up with enemies for the forest of old"*, and the four answers after
# it: the Rot Behemoth and the Grave Totem stay in the Forest; the seven as shown; *Each copies its Orc*; *Nature, like the
# Forest*).
#
# What this gate asserts, section by section (`docs/reports/KH.md` has the working):
#
#   §1  THE SEVEN, WRITTEN ON THE ORCS THEY REPLACE: each carries every key of its pattern at its figure (answer 3; its roles
#       too, KH's reading 1), but for the name, the zones (the Forest's roster alone), the tint and the resists; each kind's moves stand in its pattern's order at their
#       figures, every damaging move renamed and dealing nature and every other move keeping its name (answer 3: "Same health,
#       armor, speed, damage, Break damage and cooldowns"); the resists are nature 50% and fire −25% (answer 4); the
#       Huntmaster's Maul copy cools at 0 and costs the Chief's Rage.
#   §2  THE ROSTERS: the fourteen kinds that leave stand in the Scarlands' roster alone; the Rot Behemoth and the Grave Totem in
#       the Forest's alone (answer 1); no two zones' rosters share a kind but the Hollow Crown; the Forest's roster holds one
#       elite, its own, and a mender of its own; the Scarlands' elite is the Orc Chief; and at every budget an elite node can
#       roll, an elite theme composes in each of the two. What each zone never fields is printed.
#   §3  THE SEVEN IN A FIGHT, DRIVEN: two battles field the seven through `Enemies.config`; each unit carries its name, resists
#       and kit as §1 reads them off the data, the Maul's copy uncooled; and each damaging move, struck on a hero under the
#       same dice, takes far less off a hero who resists nature than off one who does not — the type reaches the blow's door;
#       and (§3b) the two support casts the support code finds by name: the Heartwood Sentinel, no ally shielded, chooses its
#       Shielding, and the Grove Tender, a hurt ally beside it and a pool that can pay, chooses its Healing Wave on it.
#   §4  THE RECORD: `CLAUDE.md`'s zone block names the Forest's own elite and mender and says the Orcs stand in the Scarlands.
#   §5  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the Forest plays as the designer wants — the figures
# are the designer's (RECORD_KH) and the sim tests the code; and how the seven read on screen — every enemy shares the one orc
# sheet, tint and scale only (`Enemies.SHEET`).
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
# Two fights, the seven between them: the Sentinel among the three it can shield, the Tender beside the two it can heal.
const FOES := [
	{"type": "fight", "theme": "Warband", "enemies": ["thornling", "bristleback", "spore_lobber", "heartwood_sentinel"]},
	{"type": "fight", "theme": "Warband", "enemies": ["grove_tender", "blightcap", "antlered_huntmaster"]},
]
const SCRATCH_PROFILE := "user://kh_profile.json"
const SCRATCH_RELICS := "user://kh_relics.json"
const ENEMIES_JSON := "res://data/enemies.json"
const ZONE_BLOCK := "## STANDING DESIGN RULE — A ZONE FIELDS ITS OWN KINDS"
# THE SEVEN AS BUILT: the pattern is the Orc each replaces (the designer's answer 3, its preview); the type every damaging move
# deals and the resists are the designer's (answer 4); the names are as the designer was shown them (answer 2).
const RESISTS := {"nature": 0.5, "fire": -0.25}
const TYPE := "nature"
const KINDS := {
	"thornling": {"pattern": "whelp", "name": "Thornling",
		"moves": {"Frenzied Nip": "Thorn Prick", "Reckless Lunge": "Bramble Lunge"}},
	"bristleback": {"pattern": "wolfrider", "name": "Bristleback",
		"moves": {"Lunging Bite": "Tusk Gore", "Ride-by Slash": "Trampling Rush"}},
	"spore_lobber": {"pattern": "archer", "name": "Spore Lobber",
		"moves": {"Arrow Shot": "Spore Pod", "Poison Arrow": "Choking Spores", "Gall": "Sour Cloud"}},
	"heartwood_sentinel": {"pattern": "shieldmaster", "name": "Heartwood Sentinel",
		"moves": {"Strike": "Bough Strike"}},
	"grove_tender": {"pattern": "shaman", "name": "Grove Tender",
		"moves": {"Chain Lightning": "Stinging Pollen"}},
	"blightcap": {"pattern": "hexer", "name": "Blightcap",
		"moves": {"Hex Bolt": "Rot Bolt", "Withering Hex": "Wilting Curse", "Bone Rattle": "Spore Choke"}},
	"antlered_huntmaster": {"pattern": "chief", "name": "Antlered Huntmaster",
		"moves": {"Strike": "Spear Thrust", "Heavy Strike": "Goring Charge", "Chieftain's Maul": "Antler Rend"}},
}
const MAUL := {"antlered_huntmaster": "Antler Rend"}
# Answer 1: what leaves the Forest for the Scarlands, and what stays.
const TO_SCARLANDS := ["raider", "whelp", "slinger", "totemist", "archer", "shieldmaster", "shaman", "hexer", "wolfrider",
	"brute", "chief", "chanter", "hurler", "bloodcaller"]
const FOREST_KEEPS := ["bog_troll", "behemoth", "withered_warden", "grave_totem"]
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
	print("BATCH KH — THE ORCS TO THE SCARLANDS, AND THE FOREST's OWN SEVEN")
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


# ── §1 — THE KINDS ───────────────────────────────────────────────────────────

func _s1_kinds() -> void:
	print("\n§1 — the seven, written on the Orcs they replace (the designer's answer 3), every blow nature (answer 4)")
	var checked := 0
	var forest := _roster_of("forest")
	for kind in KINDS:
		var spec: Dictionary = KINDS[kind]
		var k: Dictionary = _data.get(kind, {})
		var pat: Dictionary = _data.get(String(spec["pattern"]), {})
		if k.is_empty() or pat.is_empty():
			ok(false, "§1: %s or its pattern %s is not in data/enemies.json" % [kind, spec["pattern"]])
			continue
		ok(String(k["unit_name"]) == String(spec["name"]), "§1: %s is named %s" % [kind, k.get("unit_name")])
		ok((k["zones"] as Array).size() == 1 and int(k["zones"][0]) == forest, "§1: %s's zones are %s, not [%d]" % [kind, str(k["zones"]), forest])
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
		ok(str(k["resists"]) == str(RESISTS), "§1: %s resists %s, ruled %s" % [kind, str(k["resists"]), str(RESISTS)])
		ok(str(k["tint"]) != str(pat["tint"]), "§1: %s wears its pattern's tint" % kind)
		# The moves: the pattern's, in its order, at its figures; every damaging one renamed and nature, every other one its own.
		var ka: Array = k["abilities"]
		var pa: Array = pat["abilities"]
		ok(ka.size() == pa.size(), "§1: %s holds %d moves, its pattern %d" % [kind, ka.size(), pa.size()])
		for i in mini(ka.size(), pa.size()):
			var a: Dictionary = ka[i]
			var p: Dictionary = pa[i]
			var pn := String(p["display_name"])
			var hits := int(p.get("damage", 0)) > 0
			ok(hits == (spec["moves"] as Dictionary).has(pn), "§1: %s's %s — every damaging move is renamed, and only those" % [kind, pn])
			var want_name := String((spec["moves"] as Dictionary).get(pn, pn))
			ok(String(a["display_name"]) == want_name, "§1: %s's move %d is %s, want %s" % [kind, i, a["display_name"], want_name])
			var want_type := TYPE if hits else String(p.get("dmg_type", ""))
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
			ok(not maul.is_empty() and int(maul.get("cooldown", 0)) == 0 and int(maul.get("cost", 0)) > 0,
				"§1: %s's %s cools %s — the Chief's Maul cools at 0, and answer 3 keeps its cooldowns" % [kind, MAUL[kind], str(maul.get("cooldown", "?"))])
	print("    CHECKED %d moves of %d kinds against their patterns" % [checked, KINDS.size()])


# ── §2 — THE ROSTERS ─────────────────────────────────────────────────────────

func _s2_rosters() -> void:
	print("\n§2 — the rosters: the Orcs in the Scarlands, the Forest's own, no kind in two zones but the Hollow Crown")
	var forest := _roster_of("forest")
	var scar := _roster_of("scarlands")
	var fk: Array = Enemies.kinds_for_roster(forest)
	var sk: Array = Enemies.kinds_for_roster(scar)
	var astray: Array = TO_SCARLANDS.filter(func(k): return fk.has(k) or not sk.has(k))
	ok(astray.is_empty(), "§2: %s — want each in the Scarlands' roster and not the Forest's" % str(astray))
	var kept: Array = FOREST_KEEPS.filter(func(k): return not fk.has(k) or sk.has(k))
	ok(kept.is_empty(), "§2: %s — want each in the Forest's roster and not the Scarlands'" % str(kept))
	ok(KINDS.keys().all(func(k): return fk.has(k)), "§2: the Forest's roster lacks one of its seven")
	# NO KIND IN TWO ZONES' ROSTERS BUT THE HOLLOW CROWN, NEVER COMPOSED.
	var seen := {}
	var twice: Array = []
	for z in _run.ZONE_ORDER:
		for k in Enemies.kinds_for_roster(_roster_of(String(z))):
			if seen.has(k) and String(k) != "hollow_crown" and not twice.has(k):
				twice.append(k)
			seen[k] = true
	ok(twice.is_empty(), "§2: %s stand in two zones' rosters" % str(twice))
	for z in ["forest", "scarlands"]:
		var ks: Array = Enemies.kinds_for_roster(_roster_of(z))
		var elites: Array = ks.filter(func(k): return Enemies.roles(String(k)).has("elite"))
		var menders: Array = ks.filter(func(k): return Enemies.roles(String(k)).has("mender"))
		print("    %-15s roster %d: %d kinds; elite %s; menders %s" % [z, _roster_of(z), ks.size(), str(elites), str(menders)])
		var want_elite := "antlered_huntmaster" if z == "forest" else "chief"
		ok(elites == [want_elite], "§2: %s's elites are %s — want %s alone" % [z, str(elites), want_elite])
		ok(not menders.is_empty(), "§2: %s's roster holds no mender" % z)
	ok(fk.has("grove_tender") and Enemies.roles("grove_tender").has("mender"), "§2: the Forest's mender is not the Grove Tender")
	# EVERY BUDGET AN ELITE NODE CAN ROLL, AN ELITE THEME COMPOSES IN EACH OF THE TWO; AND WHAT EACH ZONE NEVER FIELDS, PRINTED.
	var themes: Dictionary = _run.THEMES
	var holes: Array = []
	var asked := 0
	for z in ["forest", "scarlands"]:
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


func _battle(foe: Dictionary) -> Node:
	_new_run()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, foe.duplicate(true))
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
	print("\n§3 — the seven in a fight: built through the config door, each blow dealt in nature")
	var blows := 0
	var fielded := 0
	for foe in FOES:
		var s: Node = await _battle(foe)
		var foes: Array = (s.get("enemies") as Array)
		var by := {}
		for e in foes:
			by[String((e as BattleUnit).enemy_kind)] = e
		ok((foe["enemies"] as Array).all(func(k): return by.has(k)), "§3: the fight fielded %s — want %s" % [str(by.keys()), str(foe["enemies"])])
		var hero: BattleUnit = (s.get("heroes") as Array)[0]
		for kind in foe["enemies"]:
			if not by.has(kind):
				continue
			fielded += 1
			var u: BattleUnit = by[kind]
			var raw: Dictionary = _data[kind]
			ok(u.unit_name == String(raw["unit_name"]) and str(u.resists) == str(RESISTS),
				"§3: %s fields as %s resisting %s" % [kind, u.unit_name, str(u.resists)])
			var names: Array = u.abilities.map(func(a): return (a as Ability).display_name)
			var want_names: Array = (raw["abilities"] as Array).map(func(a): return String(a["display_name"]))
			ok(names == want_names, "§3: %s fields the kit %s, the data holds %s" % [kind, str(names), str(want_names)])
			for ab in u.abilities:
				var a := ab as Ability
				if MAUL.has(kind) and a.display_name == String(MAUL[kind]):
					ok(a.cooldown == 0 and a.cost == 20, "§3: %s's %s fields cooling %d at %d Rage" % [kind, a.display_name, a.cooldown, a.cost])
				if a.damage <= 0 or a.special != "":
					continue
				ok(a.dmg_type == TYPE, "§3: %s's %s fields as %s, ruled %s" % [kind, a.display_name, a.dmg_type, TYPE])
				var plain := await _blow(s, u, a, hero, a.dmg_type, 0.0)
				var held := await _blow(s, u, a, hero, a.dmg_type, 0.9)
				print("    %-19s %-16s %-6s: %3d off a hero who does not resist it, %3d off one who resists it 90%%" % [kind, a.display_name, a.dmg_type, plain, held])
				ok(plain > 0 and held * 4 < plain, "§3: %s's %s took %d plain and %d resisted — the type does not reach the blow" % [kind, a.display_name, plain, held])
				blows += 1
		# §3b — THE TWO SUPPORT CASTS THE SUPPORT CODE FINDS BY NAME (`_enemy_support_action`), the reason each keeps its name.
		if by.has("heartwood_sentinel"):
			for u2 in foes:
				(u2 as BattleUnit).hp = (u2 as BattleUnit).max_hp
				(u2 as BattleUnit).remove_status("shielded")
			(by["thornling"] as BattleUnit).hp = 20
			var act: Array = s.call("_enemy_support_action", by["heartwood_sentinel"])
			var picked := "nothing" if act.is_empty() else "%s on %s" % [(act[0] as Ability).display_name, (act[1] as BattleUnit).unit_name]
			print("    the Sentinel, no ally shielded and a Thornling at 20 health: %s" % picked)
			ok(not act.is_empty() and (act[0] as Ability).display_name == "Shielding" and act[1] == by["thornling"],
				"§3b: the Heartwood Sentinel with no ally shielded chose %s — want its Shielding on the lowest" % picked)
		if by.has("grove_tender") and by.has("blightcap"):
			for u2 in foes:
				(u2 as BattleUnit).hp = (u2 as BattleUnit).max_hp
			var cap: BattleUnit = by["blightcap"]
			cap.hp = int(cap.max_hp / 2)
			s.set("malice", 150)
			var act2: Array = s.call("_enemy_support_action", by["grove_tender"])
			var picked2 := "nothing" if act2.is_empty() else "%s on %s" % [(act2[0] as Ability).display_name, (act2[1] as BattleUnit).unit_name]
			print("    the Tender, a hurt Blightcap beside it and 150 Malice in the pool: %s" % picked2)
			ok(not act2.is_empty() and (act2[0] as Ability).display_name == "Healing Wave" and act2[1] == cap,
				"§3b: the Grove Tender with a hurt ally and a full pool chose %s — want its Healing Wave on the Blightcap" % picked2)
	ok(fielded == 7, "§3: %d of the seven fielded" % fielded)
	ok(blows == 15, "§3: %d blows driven — want the seven's fifteen damaging moves" % blows)
	print("    CHECKED %d blows, each twice under the same dice" % blows)


# ── §4 — THE RECORD ──────────────────────────────────────────────────────────

func _s4_record() -> void:
	print("\n§4 — the record: CLAUDE.md's zone block names the Forest's own elite and mender, and the Orcs in the Scarlands")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var at := cm.find(ZONE_BLOCK)
	var end := cm.find("\n## ", at + 4) if at >= 0 else -1
	var block := cm.substr(at, end - at) if at >= 0 and end > at else ""
	for n in ["Antlered Huntmaster", "Grove Tender", "THE ORCS STAND IN THE SCARLANDS"]:
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
