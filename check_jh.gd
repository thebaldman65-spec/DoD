# BATCH JH — THE RISING SHAPE, AND BOTH CEILINGS.
#
#   §0   THE RULINGS, EACH IN THE FILE IT BINDS: the shape that pays every party, its key and its one impurity beside the rune
#        (C03); the figure a payload's; the exceptions struck with the key (C06); the fight-first rule with its figures (C08); the
#        floor's example (C07); the die shift's record and its method (C11); note 35's rule and the citation rule.
#   §1   THE RE-KEY: the entry; the key at the door both ways, a hero short who falls, nobody standing (C01, C02); the card and its
#        figure read off the payload; the figure the worth rule's quotient off §2's own reading (C04); JG's field and constant gone
#        (C05); a real fight through a fall and a rise; the drop, the Peddler and the event verb, never a hero's own pick (C15); a
#        save that holds JG's payload, rebuilt at the load door.
#   §2   THE PRICE: the uptime on the shipped key, read at its door, agreeing with the probe's count, on the cells the worth rule
#        names (C09); the fight first, and the run read second, for the record (C10); Ambushed.
#   §3   BOTH CEILINGS: every unit cut stands whole in the archive and is gone from its file (C12, C13); the live rules where a
#        card's author reads them; the retired-word paragraph kept; the condition read projected (C14).
#   §4   WHAT IS DELIBERATELY NOT DONE: the four's figures and conditions, Fellowship, the cap, the deck (C16), one key and no
#        second, the crest readings before JH as their batches wrote them.
#   §5   THE PLAYER'S FILES, as this gate found them.
#
#   Every needle is the rule's own words, never the batch code beside them (EA §2).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jh.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const DECK_CLOSED_AT := 25
const CREST_HEAD := "## STANDING RULE — THE PARTY SCOPE, AND THE RUNES IT HOLDS"
const GV_HEAD := "## STANDING RULE — A RUNE THAT READS AN ENGINE IS OFFERED ONLY WHILE THAT ENGINE IS EQUIPPED"
# THE KEY THE DESIGNER AUTHORIZED, AND THE COUNT ITS SHAPE NAMES: every hero who stands wears two or more.
const KEY := "heroes_all_hold_cores"
const CORES := 2
# THE FIVE KEYS THE DOOR HELD BEFORE IT: one key, one shape, and nothing else widens.
const JG_KEYS := ["heroes_include_class", "heroes_lack_class", "heroes_class_count", "heroes_hold_core", "heroes_all_standing"]
# JG's PAYLOAD, AS A SAVED RUN WEARING IT CARRIES IT: the load door rebuilds it from today's definition.
const JG_PAYLOAD := {"stat": {"rune_core_strike": 1}, "condition": {"heroes_hold_core": "conviction"}}
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const FIRSTS := ["bloodrage", "permafrost", "conviction", "pack"]
const SHORT_SEAT := 0
const SCRATCH_PROFILE := "user://jh_profile.json"
const SCRATCH_RELICS := "user://jh_relics.json"
const FOUR_LIVE := {"dirge": {"heroes_all_standing": false}, "dead_air": {"heroes_lack_class": "mage"}, "empty_pulpit": {"heroes_lack_class": "cleric"}, "tithe": {}}
# THE TWO ROWS THE WORTH RULE NAMES: the population the figure answers to.
const ROWS := [["the reference four", "1"], ["the incumbent", "3"]]
# THE NONE A WORN RUNE IS PRICED ON: the union a party wearing it rolls, its own entry out of every roll (the die shift's rule).
const WEARER := "the wearer's union"
# THE CREST READINGS BEFORE JH, AS THEIR BATCHES WROTE THEM: the die shift is recorded beside them, and none is re-read.
const KEPT := {"res://docs/reports/JE-crest.tsv": "9266dc0eb6c8968d38941b7be2a7b48c", "res://docs/reports/JF-pool.tsv": "986b99b161bd522e5bde470bf798cc00", "res://docs/reports/JG-crest.tsv": "71e32af61394da88964c14368566ba33"}

var _g := Gate.new()
var _docs := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JH — THE RISING SHAPE, AND BOTH CEILINGS")
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
	_s1a_the_entry()
	_s1b_the_door()
	_s1c_the_card()
	_s1d_the_figure()
	_s1e_the_flag_gone()
	await _s1f_the_fight()
	_s1g_the_draw()
	_s1h_the_save()
	_s2_the_price()
	_s3_the_ceilings()
	_s4_not_done()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s5_the_players_files()
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


func _tsv(path: String, need: Array) -> Array:
	var lines := _doc(path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	var missing: Array = []
	for c in need:
		if not head.has(c):
			missing.append(c)
	ok(missing.is_empty(), "%s lacks the columns %s" % [path, str(missing)])
	var out: Array = []
	var torn := 0
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			torn += 1
			continue
		var row := {}
		for i in head.size():
			row[head[i]] = f[i]
		out.append(row)
	ok(torn == 0, "%s: %d rows do not hold the table's columns" % [path, torn])
	return out


# The shipped key's reading on one row of the worth rule, over every zone, on the runs that finish, on the wearer's union, or an empty row.
func _uptime_row(rows: Array, pop: String, rung: String) -> Dictionary:
	for r in rows:
		if String(r["population"]) == pop and String(r["rung"]) == rung and String(r["none"]) == WEARER and String(r["scope"]) == "runs that finish" and String(r["zone"]) == "all":
			return r
	return {}


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


# The core a hero of `cls` takes second: the first of his class's engines after his first, past the one that dismisses the pet.
func _second(cls: String, first: String) -> String:
	for pid in Classes.class_engines(cls):
		if String(pid) != first and not Classes.dismisses_pet([String(pid)]):
			return String(pid)
	return ""


# A fresh run of the four, each awakened on his first core, and each but `short` handed a second through the run's own door.
func _new_run(short: int) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(FIRSTS[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.items = {}
	for j in _run.party.size():
		if j == short:
			continue
		var r := Runes.build(Runes.engine_rune_id(_second(String(SEATS[j]), String(FIRSTS[j]))))
		r["equipped"] = true
		_run.hold_rune(_run.party[j], r)


# The crest worn through the run's own door — the bag, then the function the bag panel's Equip button is bound to.
func _wear_crest(id: String) -> bool:
	if not Runes.ids().has(id):
		return false
	_run.bag_rune(Runes.build(id))
	var rows: Array = _run.party_rune_rows()
	for i in rows.size():
		if String(rows[i]["src"]) == "bag" and String((rows[i]["rune"] as Dictionary).get("id", "")) == id:
			return bool(_run.toggle_party_rune(i))
	return false


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene, the crest worn when `worn`, a Revive Potion in the pouch.
func _fight(short: int, worn: bool) -> Node:
	_new_run(short)
	if worn:
		_wear_crest("communion")
	_run.items = {"revive": 1}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _c(s: Node, name: String) -> String:
	return String((s.get_script() as Script).get_script_constant_map().get(name, "<no %s>" % name))


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


# Each hero's `dmg_bonus`, the field the payload writes.
func _bonus(s: Node) -> Array:
	var out: Array = []
	for h in _heroes(s):
		out.append(snappedf(float((h as BattleUnit).dmg_bonus), 0.0001))
	return out


func _fell(s: Node, seat: int) -> void:
	(_heroes(s)[seat] as BattleUnit).take_hit(999999, 0)
	await process_frame


func _revived(s: Node) -> void:
	s.set("item_used", false)
	s._use_item("revive")
	await process_frame


# One seeded basic of `atk` on foe `fi`; returns the health it took.
func _blow(s: Node, atk: BattleUnit, sd: int, fi: int) -> int:
	var foe: BattleUnit = s.get("enemies")[fi]
	foe.max_hp = 200000
	foe.hp = foe.max_hp
	foe.pressure = 0
	foe.broken = false
	atk.cooldowns.clear()
	atk.no_cover = 1
	# A BLOW LARGE ENOUGH TO READ THE MULTIPLIER: at a raider's 18 health a blow the rounding hides it. Attack is no field this gate measures.
	atk.attack = 4000
	var was := foe.hp
	seed(sd)
	await s._resolve(atk, atk.abilities[0], foe, "good")
	return was - foe.hp


func _payload() -> Dictionary:
	return Runes.config("communion").get("payload", {})


func _cond() -> Dictionary:
	return _payload().get("condition", {})


func _fig() -> float:
	return float((_payload().get("stat", {}) as Dictionary).get("dmg_bonus", -1.0))


func _pct() -> int:
	return int(round(_fig() * 100.0))


func _member(cls: String, hp: int, pids: Array) -> Dictionary:
	var held: Array = []
	for p in pids:
		held.append({"engine": String(p), "equipped": true})
	return {"key": cls, "hp": hp, "engines": held}


# ── §0 — THE RULINGS ──────────────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each in the file it binds")
	var rules := _doc("res://CLAUDE.md")
	var crest := _flat(_block(rules, CREST_HEAD))
	ok(crest.length() > 5000, "§0: the crest block is not in CLAUDE.md")
	# THE SHAPE THAT PAYS EVERY PARTY, AND ITS ONE IMPURITY BESIDE THE RUNE, NOT FOUND LATER.
	var head := "COMMUNION READS WHAT THE FOUR CARRY: WHILE EVERY HERO WHO STANDS WEARS TWO OR MORE CORE RUNES"
	var at := crest.find(head)
	ok(at >= 0, "§0a: the crest block does not say what Communion reads")
	var bullet := crest.substr(at, crest.find("- **A CONDITION ON THE FOUR IS READ AS THE FIGHT RUNS", at) - at) if at >= 0 else ""
	ok(bullet.length() > 400 and bullet.length() < 3000, "§0a: Communion's bullet is %d characters, not one bullet" % bullet.length())
	ok(bullet.contains("ITS ONE IMPURITY, NAMED BESIDE IT") and bullet.contains("IT PARTLY KEYS ON A FALL"), "§0a: the shape's impurity is not named beside the rune")
	ok(bullet.contains("It switches on when the one hero short of a second core goes down, about a point of its 18.6%"), "§0a: the impurity is named without what it is and its size")
	ok(bullet.contains("It pays every party that builds for it, and it rises through a run") and bullet.contains("in about half the runs a hero never slots a second core and it pays nothing"), "§0a: the bullet does not say why the shape was taken, or what it does not pay")
	ok(bullet.contains("The condition's writers are the map's: `Run.awaken`, `Run.toggle_engine` and the swaps"), "§0a: the bullet does not name what writes the condition")
	# THE FIGURE IS A PAYLOAD's, AT THE POOL's PRECEDENT.
	ok(crest.contains("it is a payload's figure, as Dirge's and Dead Air's are"), "§0b: the crest block does not say the figure is the payload's")
	ok(crest.contains("a figure in the payload rides the save as built"), "§0b: the crest block does not carry the reason the payload was kept")
	# THE EXCEPTIONS COME OUT WITH THE KEY: GV's RULE STANDS UNQUALIFIED, AND master.html SAYS NOTHING OF A CORE A CREST RUNE WAITS FOR.
	var gv := _block(rules, GV_HEAD)
	ok(gv.contains("EQUIPPED, NEVER OWNED"), "§0c: GV's block is not where the exception was read")
	ok(not gv.contains("A CREST RUNE IS THE ONE EXCEPTION") and not gv.contains("It never wears ○"), "§0c: an exception stands beside GV's rule")
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("A rune that still does part of its job without its"), "§0c: master.html's eligibility paragraph is not where it was read")
	ok(not master.contains("can arrive with nobody wearing its core"), "§0c: master.html still carries the exception")
	# PRICE A RUNE AT THE FIGHT, WITH THE FIGURES THAT TAUGHT IT, BESIDE THE WORTH RULE.
	var fat := crest.find("PRICE A RUNE AT THE FIGHT, NOT THE RUN")
	var wat := crest.find("A CONDITIONAL EFFECT IS WORTH ITS MAGNITUDE TIMES ITS UPTIME")
	ok(fat > wat and wat >= 0, "§0d: the fight-first rule is not beside the worth rule (%d, %d)" % [fat, wat])
	var rule := crest.substr(fat, 1400) if fat >= 0 else ""
	ok(rule.contains("the unit of the reading is the unit the thing acts on"), "§0d: the fight-first rule does not say why")
	var fight := _tsv("res://docs/reports/JG-fight.tsv", ["population", "rung", "paired_hturns", "dealt_change"])
	var lo := 100.0
	var hi := -100.0
	var dlo := 100.0
	var dhi := -100.0
	for r in fight:
		if String(r["population"]) != "the reference four":
			continue
		var ph := float(String(r["paired_hturns"]).split(" ± ")[0])
		lo = minf(lo, -ph)
		hi = maxf(hi, -ph)
		var dc := float(String(r["dealt_change"]).trim_suffix("%"))
		dlo = minf(dlo, dc)
		dhi = maxf(dhi, dc)
	var said := "ended it %.2f to %.2f hero turns sooner and dealt %d to %d%% more a hero turn" % [lo, hi, roundi(dlo), roundi(dhi)]
	ok(rule.contains(said), "§0d: the fight-first rule is written without its figures: %s" % said)
	ok(rule.contains("So a crest rune is read at the fight first, and the run is read second, for the record"), "§0d: the rule does not order the two readings")
	# THE FLOOR'S EXAMPLE: THE ONE THE RELATION REFUSES IS STRUCK, AND THE ONE BOTH ALLOW STANDS.
	ok(not crest.contains("50% uptime at 10%") and not _flat(_doc("res://docs/state.md")).contains("50% uptime at 10%"), "§0e: the floor's rule still carries the case the relation refuses")
	ok(crest.contains("There the relation sets the figure and the floor stands beside it as a minimum"), "§0e: the precedence is not in the floor's rule")
	ok(crest.contains("25% uptime at 20% is the case both rules allow"), "§0e: the floor's rule does not carry the case both rules allow")
	# THE DIE SHIFT REACHES BACKWARD: RECORDED, AND ITS METHOD WRITTEN WHERE AN ARM IS PAIRED.
	var instr := _flat(_doc("res://docs/instrument-rules.md"))
	ok(instr.contains("A WORN RUNE LEAVES EVERY ROLL, SO A CREST ARM PAIRED AGAINST A NONE THAT ROLLS ITS ENTRY CARRIES A DIE SHIFT"), "§0f: the die shift's rule is not in docs/instrument-rules.md")
	ok(instr.contains("Every crest reading before JH that paired an arm against such a none carries it") and instr.contains("JG's against HEAD's none and its fight table rolled one union") and instr.contains("and none is re-read"), "§0f: the record does not say which readings carry the shift, or that none is re-read")
	ok(instr.contains("THE CLEAN PAIRING IS HEAD's NONE FOR A RUNE NEW TO THE POOL, AND A NONE WITH THE RUNE's ENTRY STRUCK FROM `data/runes.json` FOR ONE ALREADY IN IT"), "§0f: the method for the next reading is not written")
	# NOTE 35, AND THE CITATION RULE, IN THE FILE THAT BINDS A BRIEF.
	var wow := _flat(_doc("res://docs/ways-of-working.md"))
	ok(wow.contains("ORDER THE READING, AND DO NOT WRITE THE CARD UNTIL IT COMES BACK"), "§0g: note 35's rule is not in the file that binds a brief")
	ok(wow.contains("A CITATION NAMES THE FILE AND THE SECTION, AND NOTHING ELSE IS CITED"), "§0g: the citation rule is not in the file that binds a brief")


# ── §1 — THE RE-KEY ───────────────────────────────────────────────────────────

func _s1a_the_entry() -> void:
	print("\n§1a — the entry: a payload's figure, one key")
	var e: Dictionary = Runes.config("communion")
	ok(not e.is_empty(), "§1a: `communion` is not in data/runes.json")
	ok(String(e.get("name", "")) == "Communion" and String(e.get("scope", "")) == "party" and int(e.get("price", 0)) == 150 and not Runes.is_retired("communion"), "§1a: the entry is %s" % str(e))
	var st: Dictionary = _payload().get("stat", {})
	ok(st.keys() == ["dmg_bonus"], "§1a: the payload writes %s, not the pool's own `dmg_bonus`" % str(st.keys()))
	ok(_cond().keys() == [KEY] and int(_cond()[KEY]) == CORES, "§1a: its condition is %s, not every standing hero holding two or more" % str(_cond()))
	ok(Talents.is_live(_payload()) and Talents.live_refusal(_payload()) == "", "§1a: the live door refuses its payload: %s" % Talents.live_refusal(_payload()))
	ok(not Runes.is_refused(Runes.config("communion")), "§1a: the roll refuses it")
	ok(Runes.RUNE_SHAPES.get("communion", []) == ["STAT", "CONDITIONAL"], "§1a: its shape is %s" % str(Runes.RUNE_SHAPES.get("communion", [])))
	ok(Runes.RUNE_TAGS.get("communion", []) == ["OFFENSE"], "§1a: its tag is %s" % str(Runes.RUNE_TAGS.get("communion", [])))
	ok(int(_run.PARTY_RUNE_SLOTS) == 1 and Runes.is_party_rune(Runes.build("communion")), "§1a: it does not go in the crest")


func _s1b_the_door() -> void:
	print("\n§1b — the shipped condition at its door: every hero who stands, two or more worn")
	var cond := _cond()
	# THE CLERIC WEARS THE ROLE THE OLD KEY NAMED, SO A KEY PUT BACK TO ONE NAMED CORE READS THE SHORT PARTY AS PAID.
	var two := [_member("warrior", 10, ["bloodrage", "heavy_plating"]), _member("mage", 10, ["permafrost", "overburn"]),
		_member("cleric", 10, ["conviction", "mercy"]), _member("hunter", 10, ["pack", "trapper"])]
	var short: Array = two.duplicate(true)
	short[SHORT_SEAT] = _member("warrior", 10, ["bloodrage"])
	var short_down: Array = short.duplicate(true)
	short_down[SHORT_SEAT]["hp"] = 0
	var two_down: Array = two.duplicate(true)
	two_down[1]["hp"] = 0
	var nobody: Array = two.duplicate(true)
	for m in nobody:
		m["hp"] = 0
	var unworn: Array = two.duplicate(true)
	unworn[3]["engines"][1]["equipped"] = false
	# A HERO AT THE CAP: *two or more* is a floor, so a door that read *exactly two* reds here (the new-text reader's hole).
	var three: Array = two.duplicate(true)
	var third := ""
	for pid in Classes.class_engines("warrior"):
		if not ["bloodrage", "heavy_plating"].has(String(pid)):
			third = String(pid)
			break
	three[0] = _member("warrior", 10, ["bloodrage", "heavy_plating", third])
	ok(third != "" and Runes.held_engines(three[0]).size() == 3, "§1b: the hero at the cap holds %d core runes, not three" % Runes.held_engines(three[0]).size())
	ok(Talents.party_condition_met(cond, three), "§1b: a hero wearing three core runes reads short: the door counts exactly two")
	ok(Talents.party_condition_met(cond, two), "§1b: with every hero holding two, the door does not hold")
	ok(not Talents.party_condition_met(cond, short), "§1b: a party short of a second core reads true — the key reads a named core, or any hero")
	ok(Talents.party_condition_met(cond, short_down), "§1b: the hero short of a second core fell and the door does not hold: the impurity the rule names is gone")
	ok(Talents.party_condition_met(cond, two_down), "§1b: a hero holding two fell and the door stopped holding")
	ok(not Talents.party_condition_met(cond, nobody), "§1b: with nobody standing the door holds, and a wipe's last fall would switch it on")
	ok(not Talents.party_condition_met(cond, unworn), "§1b: an unslotted core rune counts")
	ok(Talents.live_condition_met(cond, short_down) and not Talents.live_condition_met(cond, short), "§1b: the re-read the battle asks reads otherwise")
	# ONE KEY, ONE SHAPE: THE DOOR HOLDS JG's FIVE AND THIS ONE.
	var want: Array = JG_KEYS.duplicate()
	want.insert(4, KEY)
	ok(Talents.HERO_KEYS == want and Talents.LIVE_KEYS == want, "§1b: the door's keys are %s / %s, not JG's five and the one authorized" % [str(Talents.HERO_KEYS), str(Talents.LIVE_KEYS)])
	print("    CHECKED %d parties at the door; the keys %s" % [[two, short, short_down, two_down, nobody, unworn, three].size(), str(Talents.LIVE_KEYS)])


func _s1c_the_card() -> void:
	print("\n§1c — the card reads its own entry, and every text that states the figure agrees")
	var raw: Dictionary = JSON.parse_string(_doc("res://data/runes.json"))
	var desc := String((raw.get("communion", {}) as Dictionary).get("desc", ""))
	ok(desc.contains("{=@payload.stat.dmg_bonus*100}") and desc.contains("{=@payload.condition.%s}" % KEY), "§1c: the card does not read its figure and its count off its own entry: %s" % desc)
	var shown := String(Runes.config("communion").get("desc", ""))
	var want := "While every hero who stands wears %d or more core runes, every hero deals %d%% more strike damage." % [int(_cond().get(KEY, -1)), _pct()]
	ok(shown.replace("\n", " ") == want, "§1c: the card shows '%s', not '%s'" % [shown.replace("\n", " "), want])
	for line in shown.split("\n"):
		ok(String(line).length() <= 44, "§1c: a line of the card is %d characters: %s" % [String(line).length(), line])
	var words := " " + shown.replace("\n", " ").to_lower() + " "
	for p in [" he ", " his ", " him ", " you ", " your ", " they ", " their ", " holds "]:
		ok(not words.contains(p), "§1c: the card breaks the text standard: '%s'" % p.strip_edges())
	var master := _flat(_doc("res://docs/master.html"))
	ok(master.contains("<b><i>Communion</i></b>: while every hero who stands wears two or more core runes, every hero deals %d%% more strike damage" % _pct()), "§1c: master.html's Communion does not state the payload's %d%%" % _pct())
	ok(master.contains("<i>Communion</i>'s %d%% against the same 10%%" % _pct()), "§1c: master.html's relation does not state the payload's %d%%" % _pct())
	ok(master.contains("how many core runes every standing hero wears"), "§1c: master.html's list of conditions does not carry the new one")
	ok(_flat(_block(_doc("res://CLAUDE.md"), CREST_HEAD)).contains("Communion %d%%" % _pct()), "§1c: the crest block's figure is not the payload's %d%%" % _pct())
	var whole := _doc("res://docs/state.md")
	ok(_flat(_block(whole, "### THE CREST POOL")).contains("Communion at %d%%" % _pct()), "§1c: the crest block of docs/state.md is not the payload's %d%%" % _pct())
	ok(_flat(_block(whole, "### TO WATCH IN PLAY")).contains("COMMUNION AT %d%%" % _pct()), "§1c: TO WATCH IN PLAY is not the payload's %d%%" % _pct())


func _s1d_the_figure() -> void:
	print("\n§1d — its figure, the worth rule's quotient, off this batch's own reading")
	var rows := _tsv("res://docs/reports/JH-uptimes.tsv", ["population", "rung", "none", "scope", "zone", "hero_turns", "shipped", "jg_probe14_every2", "agree", "share", "fidelity"])
	var lower := 2.0
	for row in ROWS:
		var r := _uptime_row(rows, String(row[0]), String(row[1]))
		ok(not r.is_empty(), "§1d: the table holds no reading of %s, rung %s" % [row[0], row[1]])
		if r.is_empty():
			continue
		var up := float(r["shipped"]) / float(r["hero_turns"])
		print("    %s, rung %s, runs that finish: %s of %s = %.4f" % [row[0], row[1], r["shipped"], r["hero_turns"], up])
		lower = minf(lower, up)
	var quotient := 0.05 / lower
	var want := ceilf(quotient * 100.0 - 0.000001) / 100.0
	print("    0.05 / %.4f = %.4f, a whole percent up %.2f; the payload holds %.4f" % [lower, quotient, want, _fig()])
	ok(is_equal_approx(_fig(), want), "§1d: the figure %.2f is not the worth rule's quotient off the shipped key's reading (%.4f, a whole percent up %.2f)" % [_fig(), quotient, want])
	ok(_fig() * lower >= 0.05, "§1d: magnitude × uptime is %.4f, under the floor" % (_fig() * lower))
	ok(_fig() <= 0.75, "§1d: the figure %.2f is above the pool's largest: the condition is too rare" % _fig())
	# THE RELATION THE FLOOR STANDS BESIDE: A CONDITIONED RUNE PAYS BEYOND THE BARE WRITER OF ITS EFFECT.
	var bare := 0.0
	for n in Talents.tree():
		var st: Dictionary = ((n as Dictionary).get("payload", {}) as Dictionary).get("stat", {})
		bare = maxf(bare, float(st.get("dmg_bonus", 0.0)))
	ok(bare > 0.0 and _fig() > bare, "§1d: the figure %.2f is not beyond the tree's bare %.2f" % [_fig(), bare])


func _s1e_the_flag_gone() -> void:
	print("\n§1e — JG's flag and its constant are gone, beside the field the payload writes")
	var stripped := ""
	for f in ["unit.gd", "battle.gd", "talents.gd", "runes.gd", "run_state.gd", "run_sim.gd", "classes.gd"]:
		stripped += Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f))
	var flag := "rune_core" + "_strike"
	var konst := "COMMUNION" + "_STRIKE"
	ok(not stripped.contains(flag), "§1e: the game's scripts still name the flag")
	ok(not stripped.contains(konst), "§1e: the game's scripts still name the code constant")
	ok(not (load("res://scripts/battle.gd") as Script).get_script_constant_map().has(konst), "§1e: the battle still holds the constant")
	ok(not Talents.LIVE_FIELDS.has(flag) and Talents.LIVE_FIELDS.has("dmg_bonus"), "§1e: the live door holds %s" % str(Talents.LIVE_FIELDS.filter(func(x): return String(x).begins_with("rune_core"))))
	var raw := _doc("res://data/runes.json")
	ok(not raw.contains(flag) and not raw.contains(konst), "§1e: data/runes.json still names the flag or the constant")
	ok(not _doc("res://check_fn.gd").contains("FLAG_WEIGHED") and not _doc("res://check_hp.gd").contains("RUNE_FLAGS"), "§1e: a gate still weighs a flag no rune writes")


# `check_jg` §3d, JG's real fight through its named core's holder, is retired onto this arm (THE CROSS-TARGET SUPERSESSIONS in
# `docs/state.md`): it prints its record and asserts the re-key; this one drives the live rune through a fall and a rise.
func _s1f_the_fight() -> void:
	print("\n§1f — a real fight: it pays with every standing hero holding two, and through the short hero's fall and rise")
	# EACH PARTY's OWN BARE FIGHT IS ITS BASE: a second core may write a stat of its own.
	var short_bare: Node = await _fight(SHORT_SEAT, false)
	var base_short := _bonus(short_bare)
	var bare: Node = await _fight(-1, false)
	var base := _bonus(bare)
	var all2: Node = await _fight(-1, true)
	var held := 0
	for m in _run.party:
		held += 1 if Runes.held_engines(m as Dictionary).size() >= CORES else 0
	ok(held == 4, "§1f: the run's door seated two cores on %d of the four" % held)
	var paid := _bonus(all2)
	var deltas: Array = []
	for i in paid.size():
		deltas.append(snappedf(float(paid[i]) - float(base[i]), 0.0001))
	ok(deltas == [snappedf(_fig(), 0.0001), snappedf(_fig(), 0.0001), snappedf(_fig(), 0.0001), snappedf(_fig(), 0.0001)], "§1f: with every hero holding two it paid %s over the bare fight" % str(deltas))
	var chip: Dictionary = all2._rune_chip_for("Communion", "", _payload(), true)
	var tip := String(chip.get("tip", ""))
	ok(tip.contains("while every hero who stands wears %d or more core runes" % CORES) and tip.contains("%d%% more strike damage" % _pct()) and not tip.contains("heroes all hold") and not tip.contains("dmg bonus"), "§1f: the chip reads '%s'" % tip.replace("\n", " | "))
	# A HERO HOLDING TWO FALLS, AND THE REST STILL HOLD.
	await _fell(all2, 1)
	var after := _bonus(all2)
	ok(is_equal_approx(float(after[0]) - float(base[0]), _fig()) and is_equal_approx(float(after[2]) - float(base[2]), _fig()), "§1f: a hero holding two fell and it stopped paying: %s" % str(after))
	# THE SHORT HERO: NOT PAID, THEN PAID WHEN HE FALLS (THE IMPURITY), THEN NOT WHEN HE IS RAISED.
	var s: Node = await _fight(SHORT_SEAT, true)
	ok(_bonus(s) == base_short, "§1f: one hero short of a second core and it pays: %s against %s" % [str(_bonus(s)), str(base_short)])
	var waits := false
	for line in s.get("_rune_roll_call"):
		if String(line) == "the crest: Communion — %s" % _c(s, "CONDITION_UNMET_LIVE_TAIL"):
			waits = true
	ok(waits, "§1f: one hero short, the roll call does not say it waits")
	var mage: BattleUnit = _heroes(s)[1]
	var unpaid := await _blow(s, mage, 7301, 0)
	await _fell(s, SHORT_SEAT)
	var on := _bonus(s)
	ok(is_equal_approx(float(on[1]) - float(base_short[1]), _fig()) and is_equal_approx(float(on[3]) - float(base_short[3]), _fig()), "§1f: the short hero fell and it does not pay the rest: %s" % str(on))
	ok(_log_text(s).contains("Rune: the crest: Communion — %s" % _c(s, "LIVE_ON_TAIL")), "§1f: the switch on at the fall is not in the log")
	var paid_blow := await _blow(s, mage, 7301, 1)
	var want := float(unpaid) * (1.0 + float(on[1])) / (1.0 + float(base_short[1]))
	print("    the Mage's basic took %d unpaid and %d paid (want about %.1f)" % [unpaid, paid_blow, want])
	ok(unpaid > 0 and absf(float(paid_blow) - want) <= 2.0, "§1f: the paid blow took %d, not about %.1f" % [paid_blow, want])
	await _revived(s)
	ok(_bonus(s) == base_short, "§1f: the short hero was raised and it still pays: %s" % str(_bonus(s)))
	ok(_log_text(s).contains("Rune: the crest: Communion — %s" % _c(s, "LIVE_OFF_TAIL")), "§1f: the switch off at the rise is not in the log")


func _s1g_the_draw() -> void:
	print("\n§1g — the drop's union, the Peddler and the event verb, never a hero's own pick")
	_new_run(-1)
	var held: Array = _run.party_rune_names()
	var offered := 0
	for m in _run.party:
		if Runes.eligible_ids(m, Runes.owned_names(m, held)).has("communion"):
			offered += 1
	ok(offered == 4, "§1g: the roll offers it to %d of the four" % offered)
	var dealt := 0
	var rolled := 0
	for _i in 400:
		for m2 in _run.party:
			for c in _run.roll_rune_candidates(m2):
				rolled += 1
				if String((c as Dictionary).get("id", "")) == "communion":
					dealt += 1
	ok(rolled > 1000, "§1g: the cache rolled %d candidates, so its absence reads nothing" % rolled)
	ok(dealt == 0, "§1g: a hero's own pick of three dealt it %d times in %d candidates" % [dealt, rolled])
	var drops := 0
	var peddled := 0
	var granted := 0
	var seen := 3000
	for _j in seen:
		if String(_run.roll_fight_drop().get("id", "")) == "communion":
			drops += 1
		if String(_run.peddler_rune(_run.party[0]).get("id", "")) == "communion":
			peddled += 1
		if String(_run.grant_rune(_run.party[0]).get("id", "")) == "communion":
			granted += 1
	ok(drops > 0, "§1g: it never dropped in %d rolls" % seen)
	ok(peddled > 0, "§1g: the Peddler never rolled it in %d rolls" % seen)
	ok(granted > 0, "§1g: the event verb never rolled it in %d rolls" % seen)
	print("    in %d candidates a hero's pick dealt it %d times; in %d rolls the drop %d, the Peddler %d, the event verb %d" % [rolled, dealt, seen, drops, peddled, granted])


func _s1h_the_save() -> void:
	print("\n§1h — a save that holds JG's payload is rebuilt at the load door")
	_new_run(-1)
	var old := Runes.build("communion")
	old["payload"] = JG_PAYLOAD.duplicate(true)
	old["desc"] = "the card the save was written with"
	old["equipped"] = true
	_run.party_runes = [old]
	_run.save_run()
	ok(_run.load_run(), "§1h: the save holding JG's payload did not load")
	var now: Dictionary = (_run.party_runes[0] as Dictionary) if _run.party_runes.size() == 1 else {}
	ok(now.get("payload", {}) == Runes.definition("communion")["payload"], "§1h: JG's payload loaded as %s, not today's" % str(now.get("payload")))
	var rebuilt: Array = _run.get("load_rebuilt_runes") if _run.get("load_rebuilt_runes") is Array else []
	ok(rebuilt.size() == 1 and String((rebuilt[0] as Dictionary).get("rune", "")) == "communion", "§1h: the load names %s rebuilt" % str(rebuilt))
	var notes := " · ".join(PackedStringArray((_run.get("load_notes") as Array).map(func(x): return String(x))))
	ok(notes.contains("Communion is rebuilt"), "§1h: the rebuild is not said: '%s'" % notes)
	ok(Runes.shown_desc(now) == String(Runes.config("communion").get("desc", "")), "§1h: the rebuilt rune pays today's payload under the save's card: '%s'" % Runes.shown_desc(now))


# ── §2 — THE PRICE ────────────────────────────────────────────────────────────

func _s2_the_price() -> void:
	print("\n§2 — the price: the uptime on the shipped key, the fight first, the run for the record")
	var rows := _tsv("res://docs/reports/JH-uptimes.tsv", ["population", "rung", "none", "scope", "zone", "runs", "finished", "crest_at_the_end", "hero_turns", "shipped", "jg_probe14_every2", "agree", "share", "all_four_stand_each_two", "jg_count", "fidelity"])
	var disagree: Array = []
	var worn := 0
	for r in rows:
		if String(r["agree"]) != "yes":
			disagree.append("%s %s %s z%s" % [r["population"], r["rung"], r["scope"], r["zone"]])
		if not String(r["crest_at_the_end"]).begins_with("0 of"):
			worn += 1
		ok(String(r["fidelity"]).contains("the SHIPPED KEY asked at its own door"), "§2a: %s %s reads no door" % [r["population"], r["rung"]])
	ok(rows.size() >= 40, "§2a: the table holds %d rows" % rows.size())
	ok(disagree.is_empty(), "§2a: the door and the probe's count part on %s" % str(disagree))
	ok(worn == 0, "§2a: %d rows ended a run wearing a crest rune" % worn)
	var crest := _flat(_block(_doc("res://CLAUDE.md"), CREST_HEAD))
	var state := _flat(_block(_doc("res://docs/state.md"), "### THE CREST POOL"))
	ok(crest.contains("(`docs/reports/JH-uptimes.tsv`)") and not crest.contains("2.2, 9.2 and 38.2% by zone on the first (`docs/reports/JG-uptimes"), "§2a: the crest block reads the uptime off JG's table, not the shipped key's")
	for row in ROWS:
		var r2 := _uptime_row(rows, String(row[0]), String(row[1]))
		if not r2.is_empty():
			ok(state.contains("%.1f%%" % (float(r2["share"]) * 100.0)), "§2a: the crest block of docs/state.md does not carry %s's %.1f%%" % [row[0], float(r2["share"]) * 100.0])
	# THE FIGHT FIRST.
	var fight := _tsv("res://docs/reports/JH-fight.tsv", ["population", "rung", "reading", "runs", "with_a_paid_fight", "same_history", "paired_hturns", "hturns_change", "paired_dealt", "dealt_change", "fidelity"])
	var first := 0
	var paid := 0
	for r3 in fight:
		if String(r3["reading"]) == "the first fight":
			first += 1
			ok(String(r3["paired_hturns"]) == "+0.00 ± 0.00" and String(r3["paired_dealt"]) == "+0.00 ± 0.00" and String(r3["with_a_paid_fight"]) == "0 paid hero turns",
				"§2b: %s rung %s's first fight is not the none's line for line: %s, %s" % [r3["population"], r3["rung"], r3["paired_hturns"], r3["with_a_paid_fight"]])
		elif String(r3["reading"]) == "the first fight it pays in":
			paid += 1
			var sh := String(r3["same_history"]).split(" of ")
			ok(sh.size() == 2 and int(sh[0]) == int(sh[1]) and int(sh[0]) > 0, "§2b: %s rung %s's first paid fight has a history that differs: %s" % [r3["population"], r3["rung"], r3["same_history"]])
			var said := "hero turns %s (%s) and damage a hero turn %s (%s)" % [r3["paired_hturns"], r3["hturns_change"], r3["paired_dealt"], r3["dealt_change"]]
			if ["the reference four", "the incumbent"].has(String(r3["population"])):
				ok(state.contains(said), "§2b: the crest pool does not carry %s rung %s's first paid fight: %s" % [r3["population"], r3["rung"], said])
			if [["the reference four", "1"], ["the incumbent", "3"]].has([String(r3["population"]), String(r3["rung"])]):
				var ht := String(r3["paired_hturns"]).split(" ± ")
				var dl := String(r3["paired_dealt"]).split(" ± ")
				ok(ht.size() == 2 and dl.size() == 2 and float(ht[0]) < -4.0 * float(ht[1]) and float(dl[0]) > 4.0 * float(dl[1]),
					"§2b: on %s rung %s, the row the worth rule names, the fight it pays in does not end sooner and deal more past four errors: %s, %s" % [r3["population"], r3["rung"], r3["paired_hturns"], r3["paired_dealt"]])
	ok(first >= 4 and paid >= 4, "§2b: the fight's table reads %d first fights and %d first paid fights" % [first, paid])
	ok(state.contains("THE READING THAT DECIDES IS THE FIGHT") and state.contains("the run is read for the record"), "§2b: the crest block does not say which reading decides")
	# THE RUN, FOR THE RECORD.
	var run := _tsv("res://docs/reports/JH-crest.tsv", ["population", "rung", "none", "runs", "none_crest_at_the_end", "arm_paid", "paired_falls", "paired_depth", "paired_finished", "fidelity"])
	var struck := 0
	var past := 0
	for r4 in run:
		if String(r4["none"]) == "HEAD's struck none":
			struck += 1
			ok(String(r4["none_crest_at_the_end"]).begins_with("0 of"), "§2c: %s's none wore a crest rune" % r4["population"])
			for col in ["paired_falls", "paired_depth", "paired_finished"]:
				var f := String(r4[col]).split(" ± ")
				if f.size() == 2 and float(f[1]) > 0.0 and absf(float(f[0])) > 2.0 * float(f[1]):
					past += 1
	ok(struck == 4, "§2c: the run is read on %d cells against the struck none" % struck)
	ok(state.contains("%d of twelve readings of falls, depth and finishes pass two errors against HEAD's struck none" % past) or (past == 0 and state.contains("none of twelve readings of falls, depth and finishes passes two errors against HEAD's struck none")), "§2c: the crest block does not state the run's count past two errors (%d)" % past)
	var amb := _tsv("res://docs/reports/JH-ambushed.tsv", ["arm", "population", "cost", "se", "fidelity"])
	var high := 0.0
	for r5 in amb:
		if String(r5["arm"]).begins_with("JH"):
			high = maxf(high, float(r5["cost"]))
	ok(amb.size() == 4 and int((_run.MODIFIERS.get("ambushed", {}) as Dictionary).get("severity", -1)) == 4 and high >= 6.88 and high < 12.22, "§2d: Ambushed reads %.2f, out of its grade's band" % high)


# ── §3 — BOTH CEILINGS ────────────────────────────────────────────────────────

func _s3_the_ceilings() -> void:
	print("\n§3 — both ceilings cut: each unit whole in the archive, gone from its file")
	var files := {"CLAUDE.md": _doc("res://CLAUDE.md"), "docs/state.md": _doc("res://docs/state.md")}
	var arch := _doc("res://DoD-archive/state-archive.md")
	var rows := _tsv("res://docs/reports/JH-cut.tsv", ["file", "unit", "kind", "bytes", "closed_by", "first_words", "chars", "md5"])
	ok(rows.size() >= 6, "§3a: the cut's table holds %d units" % rows.size())
	var total := {"CLAUDE.md": 0, "docs/state.md": 0}
	var gone: Array = []
	var kept: Array = []
	var unsaid: Array = []
	for r in rows:
		var w := String(r["first_words"])
		var fn := String(r["file"])
		total[fn] = int(total.get(fn, 0)) + int(r["bytes"])
		var at := arch.find(w)
		if at < 0 or arch.substr(at, int(r["chars"])).md5_text() != String(r["md5"]):
			gone.append(r["unit"])
		if String(files.get(fn, w)).contains(w):
			kept.append(r["unit"])
		if String(r["closed_by"]).length() < 12:
			unsaid.append(r["unit"])
	print("    CHECKED %d units: %s" % [rows.size(), str(total)])
	ok(gone.is_empty(), "§3a: %d units were cut and the archive did not take them whole: %s" % [gone.size(), str(gone.slice(0, 3))])
	ok(kept.is_empty(), "§3a: %d units the table calls cut still stand in their file: %s" % [kept.size(), str(kept.slice(0, 3))])
	ok(unsaid.is_empty(), "§3a: %d units do not say what closed them: %s" % [unsaid.size(), str(unsaid.slice(0, 3))])
	ok(int(total["CLAUDE.md"]) > 0 and int(total["docs/state.md"]) > 0, "§3a: a file was not cut: %s" % str(total))
	ok(arch.contains("## ARCHIVED AT JH") and arch.find("## ARCHIVED AT JH") < arch.find("## ARCHIVED AT JG"), "§3a: the newest cut does not stand first")
	# THE LIVE RULES WHERE A CARD's AUTHOR READS THEM, NOT IN THE ARCHIVE.
	var ts := _flat(_doc("res://docs/text-standard.html"))
	ok(ts.contains("A NUMBER A CARD SPEAKS IS SWEPT WITH ITS CONSTANT, AND THE CARD IS THE COPY THAT GETS MISSED"), "§3b: the reverted constant's live rule is not where a card's author reads it")
	ok(ts.contains("TWO STATUSES A PLAYER CANNOT TELL APART ARE ONE STATUS TOO MANY"), "§3b: the homonym rule is not where a card's author reads it")
	var tsr := _doc("res://docs/text-standard.html")
	var d_at := tsr.find("4.5a A DURATION IS STATED AS APPLIED")
	var d_end := -1
	for tag in ["<h2>", "<h3>"]:
		var e := tsr.find(tag, d_at + 10) if d_at >= 0 else -1
		if e >= 0 and (d_end < 0 or e < d_end):
			d_end = e
	var stun := tsr.find("A STUN COSTS ONE TURN, WHATEVER IT IS LAID FOR")
	ok(d_at >= 0 and stun > d_at and (d_end < 0 or stun < d_end), "§3b: the duration block's stun bullet did not land inside the text standard's §4.5a (%d, %d, %d)" % [d_at, stun, d_end])
	var rules := _flat(files["CLAUDE.md"])
	ok(rules.contains("DF §1's RULE, IN `docs/text-standard.html` §4.13 SINCE ITS CUT, SAYS TO SWEEP THE NUMBER WHEN A CONSTANT MOVES"), "§3b: HO §0's pointer still reads *above* a block that left")
	# THE RETIRED-WORD STRIP STAYS: IT STANDS NOWHERE ELSE.
	var reds := _flat(_block(files["docs/state.md"], "### THE SUITE REDS, AND WHY ZERO IS NOT THE SAME AS FIXED"))
	ok(reds.contains("THE RETIRED-WORD SWEEP CAUGHT DU TOO") and reds.contains("The cheap defence is to run the sweep's own strip over the edited document before the battery"), "§3c: THE SUITE REDS' retired-word paragraph went with its block")
	# THE CONDITION, PROJECTED TO THE CLOSE, WHERE THE READINGS AGAINST A BAR ARE ORDERED.
	var instr := _flat(_doc("res://docs/instrument-rules.md"))
	ok(instr.contains("A CEILING's CONDITION READS THE ROOM PROJECTED TO THE CLOSE: THE ROOM AT THE OPEN, LESS WHAT THE BATCH EXPECTS TO WRITE, AGAINST THE BAR"), "§3d: the ceiling's condition does not read the room projected to the close")
	var where := _flat(_block(files["docs/state.md"], "## WHERE THE PROJECT IS"))
	# JJ re-pointed this arm at its intent, as FOUND AT JI named: a projected figure for the next batch, whichever it is — the block
	# is rewritten every batch, and a needle naming one batch reds every batch after it. Its own bullet's bold head, which the
	# line checking the last projection (*X's PROJECTED FOR Y, CHECKED*) cannot match.
	var proj := RegEx.new()
	proj.compile("\\*\\*PROJECTED FOR [A-Z]{2}\\*\\*")
	ok(proj.search(where) != null, "§3d: the WHERE block carries no projected figure for the next batch")


# ── §4 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s4_not_done() -> void:
	print("\n§4 — what is deliberately not done")
	var ruled := {"tithe": ["rune_blood_communion", 30.0], "dirge": ["dmg_bonus", 0.45], "dead_air": ["dmg_bonus", 0.75], "empty_pulpit": ["dmg_taken_bonus", -0.5]}
	for id in ruled:
		var st: Dictionary = (Runes.config(id).get("payload", {}) as Dictionary).get("stat", {})
		ok(is_equal_approx(float(st.get(String(ruled[id][0]), 0.0)), float(ruled[id][1])), "§4: %s's figure moved: %s" % [id, str(st)])
		var now: Dictionary = (Runes.config(id).get("payload", {}) as Dictionary).get("condition", {})
		ok(now == FOUR_LIVE[id], "§4: %s's condition moved: %s" % [id, str(now)])
	ok(Runes.is_retired("fellowship"), "§4: Fellowship came back")
	ok(int(_run.PARTY_RUNE_SLOTS) == 1, "§4: the crest's cap moved to %d" % int(_run.PARTY_RUNE_SLOTS))
	ok(_run.MODIFIERS.size() == DECK_CLOSED_AT, "§4: the deck holds %d, and it is closed at %d" % [_run.MODIFIERS.size(), DECK_CLOSED_AT])
	for p in KEPT:
		ok(FileAccess.get_file_as_string(String(p)).md5_text() == String(KEPT[p]), "§4: %s was rewritten: a crest reading before JH stands as its batch wrote it" % p)


# ── §5 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	print("\n§5 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§5: %s changed under this gate" % p)
