# THE GATE FOR WHAT THE ARC DID, AND WHAT IT COST THE DECK.
#
#   §0   GALL MOVES AND REACHES EVERY HERO: JL's twelve rulings answered and archived; Gall carried by the kind the data names a
#        hexer that met the heroes most, read off the kept drive table (C01), the Hexer keeping Sap; Gall reaching every hero,
#        laid on every hero standing by one cast and read at each hero's own healing door (C02); its cooldown its worth's band on
#        JI's line, its worth what it denies on all four heroes against its carrier's basic, and the kept table saying so (C03)
#   §1   WHAT THE ARC DID: the kept reading names the tree before the arc by its commit, driven as it stands (C04), reads the
#        warband's blows a fight beside the outcomes (C05), and names every impurity with the way it pushes (C06)
#   §2   THE GAME AS IT IS PLAYED: the arm's relics are read off its own line and are not the default (C07), and the figures stand
#        in a block of their own, every older figure where it stood (C08)
#   §3   THE FIVE CARDS: each re-read on the tree that lands (C09), each band the point estimate's, a tie at a cut named and never
#        resolved upward (C10), the five and no sixth, and no grade in the deck re-authored (C11)
#   §4   NOTHING TUNED BUT GALL: every other move of the warband and every figure of the hexes and the pool as they stood (C12);
#        the deck closed at twenty-five (C13)
#   §5   THE TEXTS FOLLOW THE CONSTANT: what Gall does, stated off its constant where the record states it (R01)
#   §6   the player's files, as this gate found them
#   Every needle is the rule's own words, never the batch code beside them.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# JI's LINE AND ITS BREAK PRICE (JO §1): the one blow every gate on the line prices through.
const JI = preload("res://check_ji.gd")

# THE HEX SPECIAL — gone since JO §2 (no warband move lays a status on a hero unless it deals damage): a kind carries Gall by a
# move that lays it, always a blow now.
const HEX_SPECIAL := "warband_hex"
# An area blow reaches the party's four heroes, as check_ji prices it.
const REACH := 4
const DECK_CLOSED_AT := 25
# THE DECK's GRADES AS THEY STAND — each modifier's severity, read off `Run.MODIFIERS`; §3 re-reads five and re-authors none.
const DECK := {"overgrown": 4, "frenzied": 1, "brittle": 2, "warded": 2, "bloodless": 5, "parched": 2, "slick": 1, "muffled": 1,
	"hoarfrost": 1, "fleeting": 2, "feverish": 2, "deadened": 3, "miasma": 3, "thinair": 5, "encumbered": 1, "bloodletting": 1,
	"mirrorbound": 5, "rot": 4, "wasting": 5, "thin_veil": 3, "long_silence": 3, "ambushed": 4, "outpaced": 2, "fractured": 1,
	"porous": 2}
# THE FIVE THE ARC REACHED, by id — the cards whose mechanism a new status of the warband's, or a hex, touches by name.
const FIVE := ["fleeting", "encumbered", "miasma", "thinair", "bloodless"]
# THE HEXES' AND THE POOL's FIGURES AS THEY STOOD — no mechanic is tuned beside Gall's carrier, reach and cooldown.
const UNIT_FIGURES := {"GALL_HEAL_CUT": 0.5, "SAP_CUT": 0.5, "MIRE_SLOW": 0.25, "MALICE_ENTRENCH_MULT": 2.0}
const BATTLE_FIGURES := {"MALICE_DAMAGE_STEP": 10, "MALICE_PER_KILL": 25, "MALICE_CAP": 150, "MALICE_RALLY_BODIES": 2}
const FESTER_RATE := 3
const CENSUS_TABLE := "res://docs/reports/JA-shares.tsv"
const LINE_SOURCE := "res://check_ji.gd"
const KEPT_DRIVE := "res://docs/reports/JL-drive.tsv"
# The hexes as the tree holds them: JO's since JO §2 put them onto blows (JM-hexes.tsv stays JM's record of Gall by what it denies).
const KEPT_HEXES := "res://docs/reports/JO-hexes.tsv"
const KEPT_ARC := "res://docs/reports/JM-arc.tsv"
const KEPT_IMPURITIES := "res://docs/reports/JM-impurities.tsv"
const KEPT_PLAYED := "res://docs/reports/JM-played.tsv"
const KEPT_GRADES := "res://docs/reports/JM-grades.tsv"
# SINCE JN THE KEPT KIT IS JN's: ten kinds' second damaging moves raised to the line (`check_jn` §1), every other move as JM left it.
# SINCE JO IT IS JO's, Gall among its moves: seven of the ten brought to the line priced with their Break, and the four hexes onto
# blows (`check_jo` §1, §2).
const KIT_PIN := "res://docs/reports/JO-kit.json"
# BATCH JS — SEVEN KINDS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its boss. Each
# is named here and read apart, so this gate goes on asking its own question of the warband its batch left; `check_js` holds
# the seven. (Rosters 4 and 5 joined too; nothing this gate counts reads a roster.)
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan"]
# THE TREE JM's FIVE RE-READS STAND FOR (§3), its digest as `check_jm` took it on JM's commit.
const JM_TREE := "c2c74d46e931d8be168cf759e9e83353"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["archer", "hexer", "raider", "shieldmaster"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://jm_profile.json"
const SCRATCH_RELICS := "user://jm_relics.json"
# THE RECORD's NEEDLES — the rule's own words where they stand.
const ANSWERED := "all accepted as taken"
const HEXES_HEAD := "### THE WARBAND's HEXES"
const ARC_HEAD := "### THE ARC, READ WHOLE"
const GRADES_HEAD := "### THE BARGAIN DECK's GRADES"
const PLAYED_RULE := "the project's first absolute figures that describe the game someone plays"
const UNPATCHED := "driven as it stands"
# THE READINGS THE ARC's ARM OWES (the brief's list), each a row of the kept table, levels and the paired difference.
const ARC_ROWS := ["completed (runs)", "falls a run (runs)", "fights won a run (runs)", "falls a fight, paired fights",
	"health at a fight's end, paired fights", "hero turns a fight, paired fights", "the warband's blows a fight, paired fights"]
# THE IMPURITIES THE PAIRING CARRIES, each a row named for what differs: the runner, the bot, the probes, the dice.
const IMPURITY_KINDS := ["the runner", "the bot", "the probes", "the dice"]
const SIGNS := ["toward harder", "toward easier", "neither way"]
# THE READINGS THE PLAYED ARM OWES.
const PLAYED_ROWS := ["completion rate", "falls a run", "health at a fight's end", "fights won a run"]
# THE OLDER FIGURES, AS THE RECORD STATES THEM — each stands where it stood, none written over.
const OLDER := ["completions 4 → 3 are ties", "**30 of 60** completed", "completed 3 of 60, health at a fight's end 0.8211, falls 7.30 a run"]

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR WHAT THE ARC DID, AND WHAT IT COST THE DECK")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH), "§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s0_the_rulings()
	_s0_the_carrier()
	var s: Node = await _board()
	Engine.time_scale = 20.0
	await _s0_the_reach(s)
	_s0_the_selection(s)
	_s0_the_band(s)
	_s1_the_arc()
	_s2_the_played()
	_s3_the_five()
	_s4_not_done(s)
	_s5_the_texts()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


func _untagged(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("<[^>]+>")
	return _flat(rx.sub(s, "", true))


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


# A kept table's rows by their first cell: {first cell: [the other cells]}.
func _table(text: String) -> Dictionary:
	var out := {}
	for r in text.split("\n", false).slice(1):
		var c := String(r).split("\t")
		if c.size() >= 2:
			out[c[0].strip_edges()] = c.slice(1)
	return out


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


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the enemies' own turns held off so only this gate moves them.
func _board() -> Node:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i]))[0])))
	_run.specs_chosen = true
	_run.active = true
	_run.items = {}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _const(s: Node, name: String) -> Variant:
	return (s.get_script() as Script).get_script_constant_map().get(name)


# A constant of the unit script, -1 where the tree holds none.
func _unit_f(name: String) -> float:
	var v: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get(name)
	return float(v) if v != null else -1.0


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


func _clean(h: BattleUnit) -> void:
	h.hp = h.max_hp
	for st in ["gall", "sap", "mire", "fester", "frostbite", "slow", "stunned", "frozen"]:
		h.remove_status(st)


# Each kind's hexes, off the data: {hex id: [kind, ...]}.
func _carriers() -> Dictionary:
	var out := {}
	var data: Dictionary = Enemies._load()
	for kind in data:
		for a in data[kind]["abilities"]:
			var id := String((a.get("applies_status", {}) as Dictionary).get("id", ""))
			if ["gall", "sap", "mire", "fester"].has(id):
				if not out.has(id):
					out[id] = []
				(out[id] as Array).append(String(kind))
	return out


func _gall_move(kind: String) -> Dictionary:
	var data: Dictionary = Enemies._load()
	if not data.has(kind):
		return {}
	for a in data[kind]["abilities"]:
		if String((a.get("applies_status", {}) as Dictionary).get("id", "")) == "gall":
			return a
	return {}


# The tree's game, digested: every script and every data file, each file's md5 in name order, the whole hashed again.
func _tree_digest() -> String:
	var names: Array = []
	for dir in ["res://scripts", "res://data"]:
		for f in DirAccess.get_files_at(dir):
			if String(f).ends_with(".gd") or String(f).ends_with(".json"):
				names.append("%s/%s" % [dir, f])
	names.sort()
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_MD5)
	for n in names:
		ctx.update(("%s %s\n" % [String(n).trim_prefix("res://"), FileAccess.get_md5(n)]).to_utf8_buffer())
	return ctx.finish().hex_encode()


func _figures(cell: String) -> Array:
	var rx := RegEx.new()
	rx.compile("[0-9]+\\.[0-9]+")
	var out: Array = []
	for m in rx.search_all(cell):
		out.append(m.get_string())
	return out


# ── §0 — JL's TWELVE RULINGS, AND GALL ────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — JL's twelve rulings, answered and archived")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n### JL's RULINGS OWED"), "§0: ### JL's RULINGS OWED is still in the open queue — it was answered")
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), "### ~~JL's RULINGS OWED~~"))
	ok(struck.contains(ANSWERED), "§0: the archive does not hold JL's rulings struck and answered")
	var stale: Array = []
	for p in ["res://docs/state.md", "res://CLAUDE.md", "res://docs/combat-rules.md", "res://docs/master.html", "res://scripts/battle.gd",
			"res://scripts/unit.gd", "res://docs/instrument-rules.md", "res://check_jl.gd"]:
		if _doc(p).contains("JL's RULINGS OWED"):
			stale.append(p)
	ok(stale.is_empty(), "§0: an answered ruling is still cited as owed in %s" % [stale])


# C01: GALL's CARRIER, DERIVED OFF THE DATA AND THE KEPT DRIVE — of the kinds the data names a hexer, the one the heroes met in the
# most fights; Sap stays with the Orc Hexer.
func _s0_the_carrier() -> void:
	print("\n§0 — Gall's carrier: the hexer the heroes meet most")
	var data: Dictionary = Enemies._load()
	var met := {}
	var rx := RegEx.new()
	rx.compile("^fights acted in: (.+) \\(role hexer\\)$")
	for r in _doc(KEPT_DRIVE).split("\n", false):
		var c := String(r).split("\t")
		var m := rx.search(c[0].strip_edges())
		if m != null and c.size() >= 3:
			met[m.get_string(1).trim_prefix("the ")] = int(c[2])
	var best := ""
	var most := -1
	for kind in data:
		var kd: Dictionary = data[kind]
		if not (kd.get("roles", []) as Array).has("hexer"):
			continue
		var n := int(met.get(String(kd["unit_name"]), -1))
		if n > most:
			most = n
			best = String(kind)
	var car := _carriers()
	print("    the hexers met: %s; the most, %s (%d fights); Gall on %s, Sap on %s" % [str(met), best, most, str(car.get("gall", [])), str(car.get("sap", []))])
	ok(met.size() >= 5 and best != "", "§0: the kept drive table does not say how often each hexer met the heroes: %s" % str(met))
	ok(car.get("gall", []) == [best], "§0: Gall is not carried by the hexer the heroes meet most (%s), but by %s" % [best, str(car.get("gall", []))])
	ok((car.get("sap", []) as Array).filter(func(k): return not ADDED_SINCE.has(String(k))) == ["hexer"], "§0: Sap is not the Orc Hexer's alone: %s" % str(car.get("sap", [])))


# C02: GALL REACHES EVERY HERO — the move's own reach, and one cast lays it on every hero standing, each hero's heal then halved
# at that hero's own door. SINCE JO §2 GALL IS AN AREA BLOW, so it reaches what an area blow strikes — every ally, a companion
# among them — and its hover names that reach; JM's *never a companion* went with the hex special.
func _s0_the_reach(s: Node) -> void:
	print("\n§0 — Gall's reach: one cast, every ally standing")
	var car := _carriers()
	var kind := String((car.get("gall", [""]) as Array)[0]) if not (car.get("gall", []) as Array).is_empty() else ""
	var mv := _gall_move(kind)
	ok(bool(mv.get("aoe", false)), "§0: Gall does not reach every hero — the move on %s carries no reach of every hero" % kind)
	var e: BattleUnit = _foes(s)[0]
	var cfg := Enemies.config(kind) if kind != "" else {}
	var gall: Ability = null
	for a in cfg.get("abilities", []):
		if String((a as Ability).applies_status.get("id", "")) == "gall":
			gall = a
	if gall == null:
		ok(false, "§0: no kind carries Gall — it reaches nobody")
		return
	e.attack = int(cfg.get("attack", e.attack))
	e.crit_bonus = -1.0
	e.abilities = cfg["abilities"]
	e.cooldowns = {}
	e.intent = {}
	# EACH HERO's OWN WHOLE HEAL FIRST — a passive can raise what one hero receives — then one cast, then each hero's heal again.
	var whole: Array = []
	for h in _heroes(s):
		var w: BattleUnit = h
		_clean(w)
		w.hp = 1
		w.heal_amount(40, true)
		whole.append(w.hp - 1)
		_clean(w)
		# A BLOW IS STRUCK, SO NOTHING MAY GUARD IT HERE: a Block negates a blow's on-hit effects, and this arm reads the reach.
		w.block_chance = -10.0
		w.parry_chance = 0.0
	# A COMPANION STANDS ON THE BOARD, SO "NEVER A COMPANION" IS ASKED AND NOT ASSUMED: the Beastmaster's seat summons one.
	var bm: BattleUnit = null
	for h0 in _heroes(s):
		if (h0 as BattleUnit).hero_key == "hunter":
			bm = h0
	if bm != null:
		await s._do_summon(bm, "aguila")
	var pets: Array = (s.get("companions") as Array).filter(func(c): return not (c as BattleUnit).dead)
	for c0 in pets:
		(c0 as BattleUnit).remove_status("gall")
	var aim: BattleUnit = _heroes(s)[1]
	# ITS HOVER NAMES WHOM IT REACHES: every ally, as every area blow's does.
	e.intent = {"ability": gall, "target": aim, "turns": 1, "support": false, "message": "", "logs": []}
	var hover := String(s.call("_intent_hover_text", e))
	e.intent = {}
	ok(hover.contains("Hits every ally") and not hover.contains("Reaches every hero"), "§0: Gall's hover does not say it hits every ally: '%s'" % hover.replace("\n", " / "))
	await s._resolve(e, gall, aim, "good")
	var took: Array = []
	var heal: Array = []
	for h in _heroes(s):
		var u: BattleUnit = h
		if u.has_status("gall"):
			took.append(u.hero_key)
		u.hp = 1
		u.heal_amount(40, true)
		heal.append(u.hp - 1)
	var cut := _unit_f("GALL_HEAL_CUT")
	var off: Array = []
	for i in heal.size():
		if int(whole[i]) <= 0 or absi(int(heal[i]) - int(round(float(whole[i]) * (1.0 - cut)))) > 1:
			off.append("%d of %d" % [int(heal[i]), int(whole[i])])
	print("    one cast at %s: %s carry it; a heal of 40 lands %s whole, %s galled" % [aim.hero_key, str(took), str(whole), str(heal)])
	ok(took.size() == _heroes(s).size(), "§0: one Gall reached %d of %d heroes, not every hero standing: %s" % [took.size(), _heroes(s).size(), str(took)])
	var pet_galled: Array = pets.filter(func(c): return (c as BattleUnit).has_status("gall"))
	print("    CHECKED %d heroes, %d companions" % [_heroes(s).size(), pets.size()])
	ok(not pets.is_empty(), "§0: no companion stood on the board, so Gall's reach was never asked of one")
	ok(pet_galled.size() == pets.size(), "§0: Gall, an area blow, missed a companion it struck: %d of %d galled" % [pet_galled.size(), pets.size()])
	ok(off.is_empty(), "§0: a galled hero's heal did not land at the door's cut: %s" % [off])
	for h2 in _heroes(s):
		_clean(h2)


# THE SELECTION: Gall's carrier chooses it as it chooses an attack — check_jl §2's selection arm asked the Orc Hexer to lay two, and
# its Gall half stands here since Gall moved. SINCE JO §2 GALL IS A BLOW, so it is chosen among the attacks and still chosen once
# every hero carries it: a blow is never withheld for the status it lays.
func _s0_the_selection(s: Node) -> void:
	print("\n§0 — the selection: Gall's carrier chooses it among the attacks")
	var car := _carriers()
	var kind := String((car.get("gall", [""]) as Array)[0]) if not (car.get("gall", []) as Array).is_empty() else ""
	if kind == "":
		ok(false, "§0: no kind carries Gall, so no selection lays it")
		return
	var f: BattleUnit = _foes(s)[0]
	var cfg := Enemies.config(kind)
	f.abilities = cfg["abilities"]
	f.intent = {}
	for h in _heroes(s):
		_clean(h)
	var picked := 0
	var bad: Array = []
	for _i in 40:
		f.cooldowns = {}
		var c: Dictionary = s.call("_choose_enemy_action", f)
		var ab: Variant = c.get("ability")
		if ab is Ability and String((ab as Ability).applies_status.get("id", "")) == "gall":
			picked += 1
			if String((ab as Ability).special) != "":
				bad.append("a special, %s" % (ab as Ability).special)
	var e: BattleUnit = _foes(s)[1]
	for h2 in _heroes(s):
		s._apply_status(h2, "gall", 3, 0, 0, e)
	var again := 0
	for _j in 30:
		f.cooldowns = {}
		var c2: Dictionary = s.call("_choose_enemy_action", f)
		if c2.get("ability") is Ability and String((c2["ability"] as Ability).applies_status.get("id", "")) == "gall":
			again += 1
	print("    %s chose Gall %d of 40 on a clean board, %d of 30 with every hero carrying it" % [kind, picked, again])
	ok(picked >= 1 and bad.is_empty(), "§0: Gall's carrier never chooses it among its attacks on a clean board, or chooses a special: %d %s" % [picked, bad])
	ok(again >= 1, "§0: Gall's carrier withholds its blow once every hero carries Gall (%d of 30)" % again)
	for h3 in _heroes(s):
		_clean(h3)
	f.cooldowns = {}


# C03: GALL's BAND IS ITS BLOW's — since JO §2 a blow on every ally, priced on JI's one line by its damage and its Break (what Gall
# denies is unpriced, as a status a blow lays is), against its carrier's basic; and the kept table. JM-hexes.tsv keeps JM's
# reading of Gall by what it denied.
func _s0_the_band(s: Node) -> void:
	print("\n§0 — Gall's cooldown, off its blow on JI's line")
	var rx := RegEx.new()
	rx.compile("\\nconst LINE := ([0-9.]+)\\n")
	var m := rx.search(_doc(LINE_SOURCE))
	var line := float(m.get_string(1)) if m != null else -1.0
	ok(line > 1.0, "§0: JI's line could not be read out of %s" % LINE_SOURCE)
	var price := float(JI.break_figures().get("price", -1.0))
	ok(price > 0.0, "§0: the Break price could not be read off check_ji")
	var car := _carriers()
	var kind := String((car.get("gall", [""]) as Array)[0]) if not (car.get("gall", []) as Array).is_empty() else ""
	var mv := _gall_move(kind)
	if mv.is_empty() or line <= 1.0:
		ok(false, "§0: no kind carries Gall, so nothing prices it")
		return
	var data: Dictionary = Enemies._load()
	var kd: Dictionary = data[kind]
	var basic: Dictionary = {}
	for a in kd["abilities"]:
		if int(a.get("damage", 0)) > 0 and int(a.get("cost", 0)) == 0:
			basic = a
			break
	var dot: Dictionary = _const(s, "DOT_STATUSES") if _const(s, "DOT_STATUSES") != null else {}
	ok(Gate.fn_body("check_jm.gd", "_blow", _cache) == "" and Gate.fn_body("check_ji.gd", "line_blow", _cache) != "", "§0: this gate prices a blow otherwise than check_ji does")
	var atk := float(kd["attack"])
	var bp := JI.line_blow(basic, dot, atk, price)
	var worth := JI.line_blow(mv, dot, atk, price)
	var mult := worth / bp
	var want := 0 if mult < line else (2 if mult < 2.0 else (3 if mult < 3.0 else 4))
	var have := int(mv.get("cooldown", 0))
	print("    %.2f of %s's basic (%.1f): its blow worth %.2f — %d damage on every ally it strikes; the line %d, the data %d" % [
		mult, kind, bp, worth, int(mv.get("damage", 0)), want, have])
	ok(int(mv.get("damage", 0)) > 0 and want == have, "§0: Gall's cooldown is not the line's on its blow: %.2f of its basic gives %d, the data carries %d" % [mult, want, have])
	var row: Variant = null
	for r2 in _doc(KEPT_HEXES).split("\n", false).slice(1):
		var c2 := String(r2).split("\t")
		if c2.size() >= 17 and c2[0] == kind and c2[2] == "gall":
			row = c2
	ok(row != null and absf(float(row[12]) - worth) <= 0.051 and int(row[16]) == have and absf(float(row[15]) - mult) <= 0.006,
		"§0: the kept table does not price Gall as the data and the line do: %s, worth %.1f, %.2f, cooldown %d" % [str(row), worth, mult, have])


# ── §1 — WHAT THE ARC DID ─────────────────────────────────────────────────────

func _s1_the_arc() -> void:
	print("\n§1 — the arc: the tree before it against the tree that lands")
	var t := _table(_doc(KEPT_ARC))
	ok(t.size() > 8, "§1: the kept table %s is not in the tree" % KEPT_ARC)
	# C04: THE TREE BEFORE THE ARC, BY ITS COMMIT, DRIVEN AS IT STANDS.
	var before: Array = t.get("the tree before the arc", [])
	var named := String(before[0]) if before.size() > 0 else ""
	var rx := RegEx.new()
	rx.compile("\\b([0-9a-f]{40})\\b")
	var m := rx.search(named)
	var commit := m.get_string(1) if m != null else ""
	ok(commit != "" and named.contains(UNPATCHED), "§1: the kept reading does not name the tree before the arc by its commit, driven as it stands: '%s'" % named)
	ok(commit != "" and _flat(_block(_doc("res://docs/state.md"), ARC_HEAD)).contains(commit.left(7)), "§1: the record does not name the commit the arc was read against (%s)" % commit.left(7))
	# C05: THE READINGS THE BRIEF NAMED, THE WARBAND's BLOWS AMONG THEM, EACH WITH BOTH LEVELS AND THE PAIRED DIFFERENCE.
	var lacking: Array = ARC_ROWS.filter(func(r): return not t.has(r) or (t[r] as Array).size() < 3 or String(t[r][2]).strip_edges() == "")
	ok(lacking.is_empty(), "§1: the kept reading lacks a row the brief named, or its paired difference: %s" % [lacking])
	var block := _flat(_block(_doc("res://docs/state.md"), ARC_HEAD))
	var gone: Array = []
	for k in ["the warband's blows a fight, paired fights", "health at a fight's end, paired fights", "falls a fight, paired fights"]:
		for fig in _figures(String((t.get(k, ["", "", ""]) as Array)[2])):
			if not block.contains(fig):
				gone.append("%s: %s" % [k, fig])
	ok(block != "" and gone.is_empty(), "§1: the record states the arc's reading without the warband's blows a fight or the outcomes: %s" % [gone])
	# C06: EVERY IMPURITY NAMED, AND THE WAY IT PUSHES.
	var imp := _table(_doc(KEPT_IMPURITIES))
	var unsigned: Array = []
	for k2 in imp:
		var cells: Array = imp[k2]
		var sign := String(cells[1]).strip_edges() if cells.size() > 1 else ""
		if not SIGNS.any(func(x): return sign.begins_with(x)):
			unsigned.append(k2)
	# THE RECORD SIGNS §0 AS THE TABLE DOES: the tree that lands carries §0's two edits, and the way they push is the split's.
	var s0: Array = imp.get("the tree that lands carries JM §0", [])
	var sign0 := String(s0[1]).strip_edges().left(13) if s0.size() > 1 else ""
	ok(sign0.begins_with("toward") and block.contains("the tree that lands carries §0, " + sign0), "§1: the record does not sign §0 as its table does ('%s')" % sign0)
	var kinds: Array = IMPURITY_KINDS.filter(func(x): return not imp.keys().any(func(k3): return String(k3).begins_with(x)))
	print("    %d impurities named; unsigned %s; kinds unnamed %s" % [imp.size(), str(unsigned), str(kinds)])
	ok(imp.size() >= IMPURITY_KINDS.size() and kinds.is_empty() and unsigned.is_empty(),
		"§1: an impurity of the pairing is unnamed or unsigned: kinds unnamed %s, unsigned %s" % [kinds, unsigned])


# ── §2 — THE GAME AS IT IS PLAYED ─────────────────────────────────────────────

func _s2_the_played() -> void:
	print("\n§2 — the game as it is played")
	var t := _table(_doc(KEPT_PLAYED))
	ok(t.size() > 4, "§2: the kept table %s is not in the tree" % KEPT_PLAYED)
	# C07: THE ARM's RELICS, READ OFF ITS OWN LINE — the variable that holds them, and never its default.
	var rel: Array = t.get("DOD_SIM_RELICS", [])
	var val := String(rel[0]).strip_edges() if rel.size() > 0 else ""
	print("    the arm's relics: '%s'" % val)
	ok(val != "" and val != "-" and val != "none" and not val.begins_with("(default"), "§2: the played arm ran with its relics at the default: '%s'" % val)
	var lacking: Array = PLAYED_ROWS.filter(func(r): return not t.has(r))
	ok(lacking.is_empty(), "§2: the kept table lacks a reading the brief named: %s" % [lacking])
	# C08: THE FIGURES IN A BLOCK OF THEIR OWN, SAID TO BE THE FIRST OF THE GAME AS IT IS PLAYED; EVERY OLDER FIGURE WHERE IT STOOD.
	var state := _flat(_doc("res://docs/state.md"))
	var block := _flat(_block(_doc("res://docs/state.md"), ARC_HEAD))
	ok(block.contains(PLAYED_RULE), "§2: the record does not say these are %s" % PLAYED_RULE)
	var gone: Array = []
	for k in PLAYED_ROWS:
		for fig in _figures(String((t.get(k, [""]) as Array)[0])):
			if not block.contains(fig):
				gone.append("%s: %s" % [k, fig])
	ok(gone.is_empty(), "§2: the record does not state the played arm's figures in its block: %s" % [gone])
	var over: Array = OLDER.filter(func(x): return not state.contains(String(x)))
	ok(over.is_empty(), "§2: a figure dated before these was written over: %s" % [over])


# ── §3 — THE FIVE CARDS ───────────────────────────────────────────────────────

func _s3_the_five() -> void:
	print("\n§3 — the five cards, re-read on the tree that lands")
	var lines := _doc(KEPT_GRADES).split("\n", false)
	ok(lines.size() > 1, "§3: the kept table %s is not in the tree" % KEPT_GRADES)
	# THE SCALE's CUTS, read out of the record's own sentence.
	var scale := _flat(_block(_doc("res://docs/state.md"), GRADES_HEAD))
	var rx := RegEx.new()
	rx.compile("no severity under ([0-9.]+); 1 to ([0-9.]+); 2 to ([0-9.]+); 3 to ([0-9.]+); 4 to ([0-9.]+); 5 from ([0-9.]+)")
	var m := rx.search(scale)
	ok(m != null, "§3: the record's scale sentence could not be read")
	if m == null:
		return
	var cuts: Array = []
	for i in range(1, 6):
		cuts.append(float(m.get_string(i)))
	var digest := _tree_digest()
	var seen: Array = []
	var wrong: Array = []
	var off_tree: Array = []
	for r in lines.slice(1):
		var c := String(r).split("\t")
		if c.size() < 9:
			continue
		var id := c[0].strip_edges()
		# The *none* each card is read against is the table's last row, a level and not a cost.
		if id == "none":
			continue
		seen.append(id)
		var est := float(c[3])
		var se := float(c[4])
		var band := 0
		if se > 0.0 and est / se >= 2.0:
			for cut in cuts:
				if est >= float(cut):
					band += 1
		var tied: Array = []
		for cut2 in cuts:
			if absf(est - float(cut2)) < 2.0 * se:
				tied.append("%.2f" % float(cut2))
		var tie := " ".join(PackedStringArray(tied))
		var said_band := int(c[5]) if c[5].strip_edges() != "—" else 0
		var said_tie := c[6].strip_edges()
		print("    %-11s %+.2f ± %.2f: the point's band %d (the table %d); a tie at %s (the table '%s')" % [id, est, se, band, said_band, tie if tie != "" else "none", said_tie])
		if said_band != band:
			wrong.append("%s: the table bands %d, the point estimate %d" % [id, said_band, band])
		if (tie != "") != (said_tie != "" and said_tie != "none") or (tie != "" and said_tie != tie):
			wrong.append("%s: a tie at %s, the table names '%s'" % [id, tie if tie != "" else "none", said_tie])
		# A STALENESS TRIPWIRE, SAID SO, AND JN RE-POINTED IT: the digest was the tree the table stands for, every script and data file,
		# and JN edited the tree. **SINCE JN THE TABLE IS A RECORD OF JM's TREE** (`994f747`, its digest `JM_TREE`, which JN's first
		# arm reproduced line for line): the five readings stand where JM took them, and JN's re-read of Thin Air on the tree that
		# lands is `check_jn` §0's, a tripwire of its own.
		if c[8].strip_edges() != JM_TREE:
			off_tree.append(id)
	print("    this tree's game: %s; the tree JM's re-reads stand for: %s" % [digest, JM_TREE])
	ok(off_tree.is_empty(), "§3: a re-read ran on a tree that is not JM's: %s" % [off_tree])
	ok(wrong.is_empty(), "§3: a grade is read otherwise than off its point estimate, or a tie at a cut is resolved or unnamed: %s" % [wrong])
	var five := FIVE.duplicate()
	five.sort()
	seen.sort()
	ok(seen == five, "§3: the re-read cards are not the five the arc reached: %s" % [seen])
	var moved: Array = []
	for id2 in DECK:
		var row: Dictionary = (_run.MODIFIERS as Dictionary).get(id2, {})
		if int(row.get("severity", -1)) != int(DECK[id2]):
			moved.append("%s %s" % [id2, str(row.get("severity", "gone"))])
	ok(moved.is_empty(), "§3: a grade in the deck was re-authored: %s" % [moved])


# ── §4 — NOTHING TUNED BUT GALL ───────────────────────────────────────────────

func _s4_not_done(s: Node) -> void:
	print("\n§4 — every move but Gall as it stood, the hexes' and the pool's figures, the deck closed")
	# A STALENESS TRIPWIRE, SAID SO: the kept kit is HEAD's warband less Gall, so the next batch that tunes a move or adds a kind reds
	# this arm by design and re-points it at its own kit — JN did, at its §1 raise (`KIT_PIN`).
	var pin: Variant = JSON.parse_string(_doc(KIT_PIN))
	ok(pin is Dictionary and (pin as Dictionary).size() > 0, "§4: the kept kit %s is not in the tree" % KIT_PIN)
	var moved: Array = []
	if pin is Dictionary:
		var data: Dictionary = Enemies._load()
		for kind in pin:
			var have: Array = []
			for a in (data.get(kind, {}) as Dictionary).get("abilities", []):
				var st: Dictionary = a.get("applies_status", {})
				have.append("%s|%d|%d|%d|%.2f|%d|%s|%s|%d|%s" % [a["display_name"], int(a.get("damage", 0)), int(a.get("pressure", 0)),
					int(a.get("cooldown", 0)), float(a.get("delay", 0)), int(a.get("cost", 0)), String(a.get("special", "")),
					String(st.get("id", "")), int(st.get("turns", 0)), "aoe" if bool(a.get("aoe", false)) else ""])
			if have != Array(pin[kind]):
				moved.append(kind)
		var kinds_then := data.keys().filter(func(k): return not ADDED_SINCE.has(String(k))).size()
		if kinds_then != (pin as Dictionary).size():
			moved.append("%d kinds, not %d" % [kinds_then, (pin as Dictionary).size()])
	for k in UNIT_FIGURES:
		if absf(_unit_f(k) - float(UNIT_FIGURES[k])) > 0.0001:
			moved.append("%s %s" % [k, str(_unit_f(k))])
	for k2 in BATTLE_FIGURES:
		var v: Variant = _const(s, k2)
		if v == null or int(v) != int(BATTLE_FIGURES[k2]):
			moved.append("%s %s" % [k2, str(v)])
	var dot: Variant = _const(s, "DOT_STATUSES")
	if not (dot is Dictionary) or int((dot as Dictionary).get("fester", -1)) != FESTER_RATE:
		moved.append("Fester's rate %s" % str(dot))
	print("    moved: %s" % str(moved))
	ok(moved.is_empty(), "§4: a mechanic beside Gall's carrier, reach and cooldown was tuned: %s" % [moved])
	var n := (_run.MODIFIERS as Dictionary).size()
	ok(n == DECK_CLOSED_AT, "§4: the deck holds %d, not the twenty-five it closed at" % n)


# ── §5 — THE TEXTS FOLLOW THE CONSTANT ────────────────────────────────────────

func _s5_the_texts() -> void:
	print("\n§5 — what Gall does, stated off its constant")
	var cut := int(round(_unit_f("GALL_HEAL_CUT") * 100))
	var car := _carriers()
	var kind := String((car.get("gall", [""]) as Array)[0]) if not (car.get("gall", []) as Array).is_empty() else ""
	var turns := int((_gall_move(kind).get("applies_status", {}) as Dictionary).get("turns", -1))
	var sentence := "Gall cuts the healing every hero receives by %d%% for %d turns" % [cut, turns]
	var off: Array = []
	if not _flat(_block(_doc("res://docs/state.md"), HEXES_HEAD)).contains(sentence):
		off.append("the hexes' block")
	if not _untagged(_doc("res://docs/master.html")).contains(sentence):
		off.append("the master document")
	var cfg := Enemies.config(kind) if kind != "" else {}
	for a in cfg.get("abilities", []):
		if String((a as Ability).applies_status.get("id", "")) == "gall" \
				and not (a as Ability).description.contains("Every hero receives %d%%" % cut):
			off.append("%s's %s" % [kind, (a as Ability).display_name])
	var g := Glossary.entry("status_gall")
	if g.is_empty() or not String(g.get("long", "")).contains("every hero") or not (String(g.get("short", "")) + String(g.get("long", ""))).contains("%d%%" % cut):
		off.append("Gall's glossary line")
	ok(off.is_empty(), "§5: what Gall does is not stated off its constant: '%s' — %s" % [sentence, off])


func _s6_the_players_files() -> void:
	print("\n§6 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§6: %s changed under this gate" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
