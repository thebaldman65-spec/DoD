# BATCH IJ — TEXT AGAINST ITS CONSTANT.
#
#   §0.2 THE FOUR CLOSED BLOCKS, STRUCK: each of II's four closed blocks that no reference holds is ONE struck line
#        where it stood, naming what closed it and a report that holds the record (the report is in the tree); its old
#        heading is gone; and CLAUDE.md's charter states the rule beside the archive practice.
#   §0.4 A NEW GATE's SOURCE IS READ BEFORE THE ACCEPTANCE: the rule stands once in the instrument rules with its row,
#        and the population it names — the targets that open "res://", and since IL §0.6 the targets that read
#        the battery's own list and open each target it names (`check_gw`) — is derived here, this gate among them.
#   §2a THE RESOLVER: a constant token, a field token, a product, a scale and a token that names nothing, each through
#        `Classes.resolve_figures`; every source `FIGURE_SOURCES` names loads.
#   §2b NO TOKEN ON ANY SURFACE: every card's words and Perfect, every rune, every glossary entry, every core rune's
#        rule, every talent, every relic, every status chip, item, bargain and class passive, read through the door a
#        surface reads it by — none still carries `{=`.
#   §2c EVERY TOKEN WRITTEN NAMES SOMETHING: the tokens standing in the sources are counted, each constant token
#        resolves, and the count is a floor at IJ's reading — a conversion undone reds.
#   §2d THE STRIKE READS THE GRADE OFF `Ability`: the two multipliers a Perfect text restates are the ones the strike
#        multiplies by.
#   §2e THE REPAIRS: what a census disagreement said is gone from the words, and what the code does stands there.
#   §3   THE PINS: a typed figure no constant decides is tied to the inline code that does — its needle stands in the
#        text a surface reads and the code's needle stands once in the function that decides it (a figure matched whole,
#        so a 4 that becomes 40 reds).
#   §4   THE RULES, WHERE EACH LIVES: the figure rule in CLAUDE.md, II §0.7's rule built, its row's words current.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** A pin ties a needle to a needle: it reds when one moves without the other
# and cannot tell a figure the code no longer pays from one it pays elsewhere. A figure decided at two sites, or derived,
# has no row (IJ's report counts them). And a converted text cannot disagree with its constant, so this gate asks only
# that every token resolves — the conversion is the instrument.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ij.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _player := {}
var _strip := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IJ — TEXT AGAINST ITS CONSTANT")
	var run: Node = root.get_node("/root/Run")
	for p in [String(run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s02_struck()
	_s04_new_gate_rule()
	_s2a_resolver()
	_s2b_no_token_on_a_surface()
	_s2c_every_token_resolves()
	_s2d_grade_multipliers()
	_s2e_repairs()
	_s3_pins()
	_s4_rules()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


# A function's comment-stripped body: from its `func` line to the next top-level declaration.
func _body(path: String, fn: String) -> String:
	return Gate.fn_body(path, fn, _cache)


# How many times `needle` stands in `hay` WHOLE: a needle that ends (or starts) on a digit is not counted where the
# number carries on past it — a digit, or a point and a digit — so `:= 4` is not found inside `:= 40` or `:= 4.5`, and
# `for 4` is found in `for 4. A BOSS`.
static func _count_whole(hay: String, needle: String) -> int:
	return Gate.count_whole(hay, needle)
# ── §0.2 — THE FOUR CLOSED BLOCKS, STRUCK ───────────────────────────────────
# Each needle is the struck line's own words and the report it names — the record pointer is the line's whole job.
const STRUCK := [
	["## ~~THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE~~", "## STANDING RULE — THE UNIT OF A HERO/ALLY RULING IS THE CLAUSE", "docs/reports/DL.md"],
	["### ~~THE VAULT'S EXIT IS THE POOLS~~", "### THE VAULT'S EXIT IS THE POOLS, AND A VAULT ENTRY IS OWED ONE", "docs/reports/DY.md"],
	["## ~~WHAT MAKES A ROW-8 NODE, AND BH'S FIFTEEN POINTS~~", "## STANDING RULE — WHAT MAKES A ROW-8 NODE", "docs/reports/FX.md"],
	["### ~~WHERE THE RETIRED RULE ITSELF IS KEPT~~", "### WHERE THE RETIRED RULE ITSELF IS KEPT, AND WHY IT IS NOT KEPT HERE", "docs/reports/EZ.md"],
]


func _s02_struck() -> void:
	print("\n§0.2 — the four closed blocks no reference holds, each struck to one line naming its record")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var lines := cm.split("\n")
	for s in STRUCK:
		var at := -1
		var n := 0
		for i in lines.size():
			if String(lines[i]).begins_with(String(s[0])):
				at = i
				n += 1
		ok(n == 1, "§0.2: the struck line '%s' stands %d time(s) in CLAUDE.md — once" % [String(s[0]).substr(0, 50), n])
		ok(not cm.contains(String(s[1])), "§0.2: the closed block '%s' is still in CLAUDE.md" % String(s[1]).substr(0, 60))
		if at < 0:
			continue
		var line := String(lines[at])
		ok(line.contains("`" + String(s[2]) + "`") and FileAccess.file_exists("res://" + String(s[2])),
			"§0.2: '%s' does not name the report that holds its record (%s), or the report is not in the tree" % [
				String(s[0]).substr(0, 50), s[2]])
		# ONE LINE: the next non-blank line is a heading of the file's own, never the old block's body.
		var nxt := at + 1
		while nxt < lines.size() and String(lines[nxt]).strip_edges() == "":
			nxt += 1
		ok(nxt < lines.size() and String(lines[nxt]).begins_with("#"),
			"§0.2: '%s' is followed by a body — a struck block is one line" % String(s[0]).substr(0, 50))
	# THE RULE, BESIDE THE ARCHIVE PRACTICE (each needle on one raw line of the charter).
	ok(cm.contains("A CLOSED BLOCK NO REFERENCE HOLDS IS STRUCK TO A LINE THAT NAMES WHAT CLOSED")
		and cm.contains("IT AND WHICH REPORT HOLDS THE RECORD — after reading that report. A block whose record stands nowhere else stays whole")
		and cm.contains("WHAT A BATCH CLOSES HERE MOVES OUT, AS WHAT `docs/state.md` CLOSES DOES"),
		"§0.2: CLAUDE.md's charter does not state the struck-line rule beside the archive practice")
	ok(not cm.contains("stays here until the designer\nnames its place") and not cm.contains("stays here until the designer names its place"),
		"§0.2: the charter still says a closed block with no reference waits for the designer — the designer has answered")
	print("    %d struck lines read, each naming a report in the tree" % STRUCK.size())


# ── §0.4 — A NEW GATE's SOURCE IS READ BEFORE THE ACCEPTANCE ─────────────────
const NEW_GATE_RULE := "## STANDING RULE — A NEW GATE's OWN SOURCE IS READ BY THE GATE-SOURCE READERS BEFORE THE ACCEPTANCE, NOT BY IT"
const NEW_GATE_ROW := "| A NEW GATE's OWN SOURCE IS READ BY THE GATE-SOURCE READERS BEFORE THE ACCEPTANCE, NOT BY IT |"


func _s04_new_gate_rule() -> void:
	print("\n§0.4 — a new gate's own source is read by the gate-source readers before the acceptance")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(ir.count(NEW_GATE_RULE) == 1 and not cm.contains(NEW_GATE_RULE),
		"§0.4: the rule does not stand once in the instrument rules and nowhere in CLAUDE.md")
	ok(cm.count(NEW_GATE_ROW) == 1, "§0.4: the rule's row is not in CLAUDE.md's instrument index, once")
	# THE POPULATION, DERIVED HERE AS THE RULE SAYS — BY EVERY ROUTE A TARGET READS ANOTHER's SOURCE
	# (BATCH IL §0.6, IJ §0.4's own defect): the targets whose source opens the root ("res://"), and the
	# targets that read the battery's own list off `run_battery.sh` and open each target it names
	# ("res://%s.gd"). IJ derived the first alone and missed `check_gw`, which takes the second route and
	# read IK's recon 2 red; `check_parse` takes both.
	var dir := DirAccess.open("res://")
	var pop: Array = []
	var by_root := 0
	var by_list: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd") and (f.begins_with("check_") or f.begins_with("test_")):
				var tsrc := FileAccess.get_file_as_string("res://" + f)
				var opens_root := tsrc.contains("\"res://\"")
				var reads_list := tsrc.contains("res://run_battery.sh") and tsrc.contains("\"res://%s.gd\"")
				if opens_root:
					by_root += 1
				if reads_list:
					by_list.append(f.get_basename())
				if opens_root or reads_list:
					pop.append(f.get_basename())
	pop.sort()
	by_list.sort()
	ok(pop.size() >= 23, "§0.4: only %d targets read another's source — IL read twenty-three; the derivation has moved" % pop.size())
	ok(pop.has("check_ij"), "§0.4: this gate opens the root and is not in its own population")
	ok(by_list.has("check_gw"), "§0.4: the battery-list route finds %s, not `check_gw`" % str(by_list))
	print("    %d gate-source readers (%d open the root; %d read the battery's list: %s): %s" % [pop.size(), by_root,
		by_list.size(), ", ".join(PackedStringArray(by_list)), ", ".join(PackedStringArray(pop))])


# ── §2a — THE RESOLVER ──────────────────────────────────────────────────────
func _s2a_resolver() -> void:
	print("\n§2a — the resolver reads a constant, a field, a product and a scale, and leaves a token that names nothing")
	var sunder := float(BattleUnit.SUNDER_STEP) * 100.0
	ok(Classes.resolve_figures("by {=Unit.SUNDER_STEP*100}%") == "by %s%%" % Classes.figure_text(sunder),
		"§2a: a constant token does not read `BattleUnit.SUNDER_STEP`")
	ok(Classes.resolve_figures("for {=@applies_status.turns} turns", {"applies_status": {"turns": 3}}) == "for 3 turns",
		"§2a: a field token does not walk the entry's fields")
	var perf := float(Ability.GRADE_DMG_MULT["perfect"])
	ok(Classes.resolve_figures("{=@damage*Ability.GRADE_DMG_MULT.perfect}", {"damage": 40}) == Classes.figure_text(40.0 * perf),
		"§2a: a product token does not multiply a field by a constant")
	ok(Classes.figure_text(17.25) == "17.25" and Classes.figure_text(35.000000001) == "35" and Classes.figure_text(1.5) == "1.5",
		"§2a: a figure does not print whole when whole and to two places when not")
	var bad := "{=Battle.NO_SUCH_CONSTANT}"
	ok(Classes.resolve_figures(bad) == bad, "§2a: a token that names nothing was not left standing for the eye and the gate")
	var loaded := 0
	for src in Classes.FIGURE_SOURCES:
		var s: Variant = load(String(Classes.FIGURE_SOURCES[src]))
		if s is Script and not (s as Script).get_script_constant_map().is_empty():
			loaded += 1
		else:
			ok(false, "§2a: the figure source %s does not load as a script with constants" % src)
	print("    %d figure sources load" % loaded)


# ── §2b — NO TOKEN ON ANY SURFACE ───────────────────────────────────────────
func _s2b_no_token_on_a_surface() -> void:
	print("\n§2b — no surface reads a token: every table through the door a surface reads it by")
	var left: Array = []
	var read := 0
	for ab in Classes.ability_corpus():
		for t in [ab.description, ab.perfect_text]:
			read += 1
			if String(t).contains("{="):
				left.append("card %s" % ab.display_name)
	for rid in Runes.ids():
		read += 1
		if String(Runes.config(rid).get("desc", "")).contains("{="):
			left.append("rune %s" % rid)
	for e in Glossary.entries():
		for f in ["short", "long"]:
			read += 1
			if String(e.get(f, "")).contains("{="):
				left.append("glossary %s.%s" % [e.get("id", "?"), f])
	for c in ["warrior", "mage", "cleric", "hunter"]:
		for pid in Classes.class_engines(c):
			read += 1
			if Classes.engine_desc(pid).contains("{=") or Runes.engine_text(pid).contains("{="):
				left.append("engine %s" % pid)
		read += 1
		if String(Classes.CLASS_PASSIVES[c]["desc"]).contains("{="):
			left.append("passive %s" % c)
	for node in Talents.TREE:
		read += 1
		if Talents.desc_for(node, 1).contains("{="):
			left.append("talent %s" % node.get("id", "?"))
	for rel in Relics.POOL:
		read += 1
		if Relics.desc_of(String(rel)).contains("{="):
			left.append("relic %s" % rel)
	var bs: Script = load("res://scripts/battle.gd")
	var st: Dictionary = bs.get_script_constant_map()["STATUS_INFO"]
	for sid in st:
		read += 1
		if str(st[sid]).contains("{="):
			left.append("status %s" % sid)
	var rs: Dictionary = (load("res://scripts/run_state.gd") as Script).get_script_constant_map()
	for tab in ["ITEM_INFO", "MODIFIERS", "REWARDS", "DIFFICULTIES"]:
		read += 1
		if str(rs[tab]).contains("{="):
			left.append("run table %s" % tab)
	ok(left.is_empty(), "§2b: %d text(s) still carry a token on a surface: %s" % [left.size(), ", ".join(PackedStringArray(left.slice(0, 8)))])
	ok(read > 900, "§2b: only %d texts were read — the walk has lost a table" % read)
	print("    CHECKED %d texts through their doors, %d carry a token" % [read, left.size()])


# ── §2c — EVERY TOKEN WRITTEN NAMES SOMETHING ───────────────────────────────
# IJ's reading of the tokens standing in the sources; a floor, never an equality (DX §1): a text that stops reading its
# constant reds, a text converted later does not.
const TOKEN_FLOOR := 422
const TOKEN_SOURCES := ["scripts/classes.gd", "scripts/talents.gd", "scripts/relics.gd", "data/runes.json", "data/glossary.json"]


func _s2c_every_token_resolves() -> void:
	print("\n§2c — every token written in a source names something, and the conversions stand")
	var rx := RegEx.new()
	rx.compile("\\{=([^{}*]+)(?:\\*([^{}]+))?\\}")
	var total := 0
	var dead: Array = []
	for path in TOKEN_SOURCES:
		var raw := FileAccess.get_file_as_string("res://" + path)
		var n := 0
		for m in rx.search_all(raw):
			n += 1
			for ref in [m.get_string(1).strip_edges(), m.get_string(2).strip_edges()]:
				if ref == "" or ref.begins_with("@") or ref.is_valid_float():
					continue
				if Classes.figure_value(ref) == null:
					dead.append("%s: %s" % [path, m.get_string(0)])
		print("    %s: %d token(s)" % [path, n])
		total += n
	ok(dead.is_empty(), "§2c: %d token(s) name no constant: %s" % [dead.size(), ", ".join(PackedStringArray(dead.slice(0, 6)))])
	ok(total >= TOKEN_FLOOR, "§2c: %d tokens stand in the sources, below IJ's floor of %d — a conversion was undone" % [total, TOKEN_FLOOR])
	print("    %d tokens, floor %d" % [total, TOKEN_FLOOR])


# ── §2d — THE STRIKE READS THE GRADE OFF `Ability` ──────────────────────────
func _s2d_grade_multipliers() -> void:
	print("\n§2d — the strike's grade multipliers are the ones a Perfect text reads")
	var res := _body("scripts/battle.gd", "_resolve")
	ok(_count_whole(res, "Ability.GRADE_DMG_MULT[grade]") == 1 and _count_whole(res, "Ability.GRADE_BD_MULT[grade]") == 1,
		"§2d: the strike does not read its damage and Break multipliers off `Ability.GRADE_DMG_MULT` / `GRADE_BD_MULT`")
	ok(not _src("scripts/battle.gd").contains("{\"perfect\": 1.15") and not _src("scripts/battle.gd").contains("{\"perfect\": 1.25"),
		"§2d: a literal grade table is back in battle.gd beside the named one")
	ok(float(Ability.GRADE_DMG_MULT["good"]) == 1.0 and float(Ability.GRADE_BD_MULT["good"]) == 1.0,
		"§2d: a Good grade no longer multiplies by one")


# ── §2e — THE REPAIRS ───────────────────────────────────────────────────────
# Each row: [holder, present, absent(, at least)] — every clause IJ repaired. The text rows come from the census dump's
# diff (a card, chip, rune, relic, item, bargain, glossary entry, core rune or passive, read through the door a surface
# reads it by); the `lit:` rows from the source diff (a log line, tooltip or screen, read as the string literals of the
# function that writes it — a data file's, of the whole file). Text is compared with its whitespace collapsed, so a
# re-wrap moves nothing. `present` must stand (at least once, or as many times as the row says) and `absent` — the
# false clause the census found — must not. An empty `absent` is a clause added where nothing false was written.
func _norm(s: String) -> String:
	if _ws_rx == null:
		_ws_rx = RegEx.new()
		_ws_rx.compile("\\s+")
	return _ws_rx.sub(s, " ", true).strip_edges()


var _ws_rx: RegEx = null
var _lit_rx: RegEx = null


# A function's (or a data file's) string literals, in order, each with its `\n` escapes read as spaces.
func _lit_stream(path: String, fn: String) -> String:
	if _lit_rx == null:
		_lit_rx = RegEx.new()
		_lit_rx.compile("\"((?:[^\"\\\\\\n]|\\\\.)*)\"")
	var src := FileAccess.get_file_as_string("res://" + path) if fn == "" else _body(path, fn)
	var parts: Array = []
	for m in _lit_rx.search_all(src):
		parts.append(m.get_string(1).replace("\\n", " "))
	return _norm(" ".join(PackedStringArray(parts)))


func _s2e_repairs() -> void:
	print("\n§2e — every clause IJ repaired says what the code does, and the false clause is gone")
	var bad_holder: Array = []
	var gone: Array = []
	var back: Array = []
	for row in REPAIRS:
		var holder := String(row[0])
		var text: Variant
		if holder.begins_with("lit:"):
			var p := holder.split(":", true, 2)
			text = _lit_stream(String(p[1]), String(p[2]) if p.size() > 2 else "")
		else:
			text = _holder_text(holder)
		# A text the repair emptied (a class basic's Perfect, which never grades) is read, not missing.
		if text == null or (String(text) == "" and String(row[1]) != ""):
			bad_holder.append(holder)
			continue
		var t := _norm(String(text))
		var want := int(row[3]) if row.size() > 3 else 1
		if String(row[1]) != "" and t.count(String(row[1])) < want:
			gone.append("%s ~ %s" % [holder, row[1]])
		if String(row[2]) != "" and t.contains(String(row[2])):
			back.append("%s ~ %s" % [holder, row[2]])
	for b in bad_holder:
		ok(false, "§2e: the holder %s names no text a surface reads" % b)
	for b in gone:
		ok(false, "§2e: a repaired clause is gone from its text — %s" % b)
	for b in back:
		ok(false, "§2e: a clause the census found false is back — %s" % b)
	ok(REPAIRS.size() >= 260, "§2e: only %d repair rows — the table has lost rows" % REPAIRS.size())
	print("    CHECKED %d repaired clauses: %d holders unread, %d repairs gone, %d false clauses back" % [
		REPAIRS.size(), bad_holder.size(), gone.size(), back.size()])


const REPAIRS := [
	["card:Strike:perfect", "", "+10 bonus Rage"],
	["card:Rally:desc", "one hero forward:", "one ally forward:"],
	["card:Cleave:perfect", "{atk:17.25}", "{atk:22}"],
	["card:Magic Bolt:perfect", "", "Restores 10 Mana"],
	["card:Nexus Ward:desc", "every blow, area attacks included, but no tick, recoil or reflected damage.", "a share of EVERYTHING, area attacks included."],
	["card:Smite:perfect", "", "{mhp:5}"],
	["card:Chastise:perfect", "Deals 25 Break", "Deals 30 Break"],
	["card:Undying Vigil:desc", "one hero: for", "one ally: for"],
	["card:Undying Vigil:desc", "second hero on", "second ally on"],
	["card:War Stomp:desc", "Other heroes", "each. Heroes regain"],
	["card:War Stomp:perfect", "Other heroes", "Heroes regain"],
	["card:Interpose:desc", "EVERY hero, the", "EVERY ally, the"],
	["card:Covering Guard:desc", "one hero, and", "one ally, and"],
	["card:Shield Slam:desc", "It reads that maximum", "Heavy Plating grows that maximum every time you block, and this reads it"],
	["card:Vendetta:desc", "does, though an enemy's cleanse can lift the taunt.", "you does."],
	["card:Shatterpoint:desc", "— one of his", "it — his heaviest"],
	["card:Shatterpoint:desc", "Break blows. If", "Break blow. If"],
	["card:Precision Strike:desc", "for 4 turns.", "for 3 turns."],
	["card:Precision Strike:desc", "for 4 turns.", "for 3 turns."],
	["card:Precision Strike:perfect", "holds 5 turns", "holds 4 turns"],
	# BATCH IK §3a — RE-POINTED: the Perfect is the designer's now (it lays Sunder), so IJ's interim words
	# moved to the ruled ones; the clause the census found false stays absent.
	["card:Sever:perfect", "Sunders armor by 35% for 3 turns", "Also strips 35% armor for 3 turns"],
	["card:Battle Poise:desc", "his other cooldowns", "his cooldowns"],
	["card:Answering Steel:desc", "your other cooldowns.", "your cooldowns."],
	["card:Firestorm:desc", "of Burn in", "of drain in"],
	["card:Firedraw:desc", "a debuff other than Burn", "ANOTHER spec's debuff"],
	["card:Backdraft:desc", "already lit.", "lit, drain and all."],
	["card:Phoenix Rebirth:desc", "FULL. The price", "Under Overburn a full pool is exactly the relief the drain denies you — and the"],
	["card:Smoulder:perfect", "Deals {atk:11.5}", "Deals {atk:12}"],
	["card:Cold Iron:perfect", "Deals {atk:28.75}", "Deals {atk:35}"],
	["card:Frostbolt:desc", "Freeze the enemy: under Glacial Hold it is", "put the enemy in Glacial Hold —"],
	["card:Frostbolt:desc", "A boss shrugs it after one turn.", "— off the turn order until the Cryomancer releases it."],
	["card:Arcane Barrage:desc", "the 3 enemies", "the 2-3 enemies"],
	["card:Arcane Barrage:perfect", "Each target takes an even share.", "No two bolts strike the same enemy."],
	["card:Null Field:desc", "Just 10%", "casting. Nothing at"],
	["card:Inner Arcane:desc", "still ALIVE —", "ALIVE, plus one"],
	["card:Inner Arcane:desc", "health — plus one.", "half health. Widest"],
	["card:Arcane Echo:desc", "Cinderfall, Killing Frost, Pyre Wake, Wildfire and Winter's Toll do not echo. A six-bolt Barrage echoes SIX", "A three-bolt Barrage echoes THREE"],
	# BATCH IK §3b — RE-POINTED for its reason: the Perfect banks the second Resonance now.
	["card:Reality Fracture:perfect", "An Arcanist banks +1 Resonance", "An Arcanist also banks 1 Resonance"],
	["card:Renewal:desc", "A hero heals", "Ally heals"],
	["card:Hymn of Hope:desc", "ALL heroes for", "ALL allies for"],
	["card:Resurrection:desc", "fallen hero to", "fallen ally to"],
	["card:Second Wind:desc", "turns on the turn order:", "two turns: heal"],
	["card:Second Wind:desc", "window (a companion: all battle),", "that window, up"],
	["card:Rite of Return:desc", "one hero the", "one ally the"],
	["card:Rite of Return:desc", "blow or tick that", "blow that"],
	["card:Shared Grief:desc", "OTHER hero already", "OTHER ally already"],
	["card:Reprisal:desc", "turns on the turn order.", "two turns. Overhealing"],
	["card:Alms:desc", "— by a hero falling below the window, or by Divine Presence —", "CAP instead"],
	["card:Intercession:desc", "blow or tick against", "blow against"],
	["card:Blessing of Zeal:desc", "Kindle a hero: +15%", "an ally:"],
	["card:Bulwark of Fortitude:desc", "5% of max health", "them {mhp:5} at"],
	["card:Vow of Suffering:desc", "that hero takes", "that ally takes"],
	["card:Vow of Suffering:desc", "that hero 1", "that ally 1"],
	["card:Aegis Reversal:desc", "a hero's", "an ally's"],
	["card:Ordination:desc", "other hero", "the ally holding"],
	["card:Ordination:desc", "the hero who", "the ally who"],
	["card:Ordination:desc", "toward the release.", "past the release and heals them."],
	["card:Fortified Spirit:desc", "one hero your", "one ally your"],
	["card:Reliquary:desc", "No release lowers the peak", "The peak never falls"],
	["card:Elevation:desc", "every hero gains", "every ally gains"],
	["card:Elevation:desc", "Faith. A hero who", "Faith. An ally who"],
	["card:Mantle:desc", "the hero on", "the ally on"],
	["card:Dark Pact:desc", "OTHER hero heals", "OTHER ally heals"],
	["card:Dark Pact:desc", "the Cleric regains", "the Occultist regains"],
	["card:Suffering:desc", "Cast on a BROKEN enemy,", "Against a BROKEN enemy"],
	["card:Suffering:desc", "them first feeds", "them feeds"],
	["card:Anointing:desc", "EVERY hero's attacks", "EVERY ally's attacks"],
	["card:Bestial Wrath:desc", "each strike it makes beside the Hunter", "every strike"],
	["card:Spirit Bond:desc", "their own", "of your max"],
	["card:Call of the Wild:desc", "The call stops when the target falls.", ""],
	["card:Called Volley:perfect", "Deals {atk:23}", "Deals {atk:26}"],
	["card:Trophy Shot:perfect", "Deals {atk:40.25}", "Deals {atk:45}"],
	["card:Harvest:desc", "every affliction on", "every status on"],
	["card:Choking Smoke:desc", "Pyromancer's Overburn, and", "Ember Debt,"],
	["card:Snare Line:desc", "teeth, Stun and", "teeth, Break and"],
	["card:Hunt:perfect", "{atk:23} per", "{atk:20} per"],
	["engine:bloodrage", "missing and every 5 Rage spent, up to +40%.", "health missing. Half"],
	["engine:permafrost", "oldest), or the Cryomancer falls.", "the oldest). Nothing"],
	["engine:resonance", "them but Arcane Bolt, Stabilize and Threshold.", "removes them. Each"],
	["engine:mercy", "when a hero falls", "when an ally falls"],
	["engine:mercy", "Hope, Resurrection and Divine Plea,", "Hope and talent abilities,"],
	["engine:conviction", "Conviction: heroes build", "Conviction: allies build"],
	["engine:old_gods", "the Occultist applies", "debuff applied marks"],
	["engine:old_gods", "MAXIMUM, and only an enemy's cleanse washes them", "MAXIMUM and never wash"],
	["engine:old_gods", "each heal 25% of the Occultist's maximum health,", "heal {mhp:25},"],
	["passive:warrior", "choosing a target at random weigh the Warrior 20% more.", "are 20% more likely to attack the Warrior."],
	["glossary:initiative:long", "it - except a held boss, which loses its turn like any frozen unit and shrugs the ice off after 1 turn.", "releases it. The"],
	["glossary:extra_turn:long", "Two Warrior runes", "Two Berserker runes"],
	["glossary:extra_turn:long", "the Berserker's", "and Slaughterhouse"],
	["glossary:skill_check:long", "whole Rage bar.", "live Blood Frenzy bonus."],
	["glossary:miss:short", "most single-target attacks", "any single-target attack"],
	["glossary:miss:long", "base - all but a counter and the few strikes an ability deals by its own rule (Shield Slam, Feint, Precision Strike), which never roll one.", "at base. Being"],
	["glossary:parry:long", "base, the Swordmaster 12%", "at base (enemies"],
	["glossary:stance:long", "The stances are the Swordmaster's: only his Seasoned Fighter pays their terms, though a drafted guard card reads and flips any Warrior's. He", "Only the Swordmaster has stances, and he"],
	["glossary:hero_vs_ally:long", "(each pays the OTHER heroes and not the caster, and a", "RESOURCE clause (a companion has"],
	# BATCH IR §1b — RE-POINTED: IJ's repair said a hand-aimed support card CAN take a companion, Rally excepted, and IR
	# narrowed every card whose words say hero to the heroes (`_ally_pick_pool`), so the entry says which do and why.
	["glossary:hero_vs_ally:long", "offers only the heroes - Rally, Covering Guard, Fortified Spirit and the rest -", "a companion, so"],
	["glossary:status_slow:long", "turn booked while it holds", "coming turn"],
	["glossary:status_slow:long", "timeline - the turn already waiting when it lands keeps its place.", "initiative timeline. It"],
	["glossary:status_chilled:long", "enemy (only an enemy mender's Cleansing Rite thaws it, a stack at a time, and never breaks the hold),", "the enemy, and"],
	["glossary:status_frozen:long", "4, or outright from the Cryomancer's Glacial Prison.", "to 4. Bosses"],
	["glossary:status_frozen:long", "all, except on a boss, which shrugs it off after 1 turn", "at all -"],
	["glossary:glacial_hold:short", "it, he falls, or a Harvest or Cull purges it.", "it or falls."],
	["glossary:glacial_hold:long", "falls or a hero's Harvest or Cull purges the enemy's afflictions,", "he falls, and"],
	["glossary:status_poison:short", "start, skipping the first after it lands.", "turn start."],
	["glossary:status_sunder:long", "keeps less than half its armor.", "is close to bare."],
	["glossary:status_exposed:long", "Ruin detonation, a", "detonation and"],
	["glossary:status_exposed:long", "and the abilities that deal their own separate damage", "blow are"],
	["glossary:status_dazed:long", "unit's single-target attacks", "unit's attacks"],
	["glossary:status_dazed:long", "base; its area attacks and counters never miss.", "5% base."],
	["glossary:status_blind:long", "Blinded single-target attacks", "Blinded attacks"],
	["glossary:status_blind:long", "at one target,", "swings at, it"],
	["glossary:status_blind:long", "hit; its area attacks still never miss.", "not hit."],
	["glossary:status_ruin:long", "Harvest or Cull,", "hero's Harvest, the"],
	["glossary:status_ruin:long", "Requiem and Transference (which moves it to another enemy),", "own Requiem, and"],
	["glossary:status_umbral_sigil:short", "most strikes", "every strike"],
	["glossary:status_umbral_sigil:long", "companion's blow, damage", "blow and"],
	["glossary:status_umbral_sigil:long", "and the abilities that deal their own separate damage", "over time do not"],
	["glossary:status_snared:long", "A Hunter's trap", "A Survivalist trap"],
	["glossary:dmg_frost:long", "many of its cards", "its hits"],
	["glossary:res_mana:short", "by a zone boss that opens a new zone.", "a zone boss."],
	["glossary:res_mana:long", "every hero who spends it, the Hunter included", "the Mage and the Cleric, not the Hunter"],
	["glossary:res_mana:long", "full when it opens the next zone (the last zone's boss, which the end boss follows on the same board, does not).", "in full. Unlike"],
	["glossary:res_mercy:short", "when heroes fall", "when allies fall"],
	["glossary:res_mercy:long", "her healing (not to Consecration's drip or a revive)", "all healing done"],
	["glossary:res_mercy:long", "each blow that strikes her (not off damage over time),", "the damage she takes,"],
	["glossary:mercy_window:long", "STATE: a hero earns", "STATE: an ally earns"],
	["glossary:mercy_window:long", "20% of HER", "a fifth of their"],
	["glossary:enemy_intent:long", "(a blow whose Break damage is greater than its damage's percentage of Attack),", "(more Break damage than health damage),"],
	["glossary:enemy_intent:long", "HOVER THE INTENT FOR ITS NUMBERS: the ability's name, its damage band and Break damage, any status it lays, and how many heroes it hits. The band is the attack's own roll, before armor, resistance, Block", "NO DAMAGE NUMBER IS SHOWN, deliberately. The only honest preview would be one produced by the same code the real hit runs, and that code cannot be run twice for the same answer - it rolls damage variance"],
	["glossary:enemy_intent:long", "- what the blow could be, never what it will deal.", "on the way through. A number worked out a second way would drift from the ability it claims to describe, so the category and the ability's own name are shown instead."],
	["glossary:ability_upgrades:long", "or Mana - Mercy and Focus are", "/ Mana / Focus - Mercy is"],
	["glossary:ability_upgrades:long", "a single-hit attack", "a single-target attack"],
	["glossary:ability_upgrades:long", "gold up-arrow on", "gold diamond on"],
	["glossary:ability_upgrades:long", "row in the loadout panel;", "chip on the hero sheet;"],
	["glossary:runes:long", "hero - or, worn in the Crest, for all four.", "single hero. One"],
	["glossary:runes:long", "card (though a rune picked from a cache, a bargain or an event goes straight into a free slot, unless it is a core rune):", "hero's card: a"],
	["glossary:runes:long", "works - except a core-rune swap that would put Summon Companion back into a kit with no free slot.", "always works. A"],
	["glossary:relics_vs_runes:long", "hero (or, in the Crest, by all four),", "one hero, and"],
	["glossary:consumables:short", "and two on", "and three on"],
	["glossary:consumables:long", "one hero's maximum", "one ally's maximum"],
	["glossary:consumables:long", "one hero's maximum", "one ally's maximum"],
	["glossary:consumables:long", "fallen hero at", "fallen ally at"],
	["glossary:consumables:long", "hero but Broken, Bleed and a poison that refuses every cleanse;", "one hero; a"],
	["glossary:consumables:long", "Health and Mana", "Health, Mana and Revive"],
	["glossary:node_types:long", "couple of", "three or four"],
	["glossary:elites:short", "short of its bosses", "fights -"],
	["glossary:elites:long", "You may not", "You will not"],
	["glossary:merchant:long", "(a crest rune goes to the bag)", "bought -"],
	["glossary:severity:short", "what decides the reward.", "the only thing the reward reads."],
	["glossary:severity:long", "SEVERITY, NOT YOUR HEROES:", "SEVERITY AND NOTHING ELSE:"],
	# BATCH IN §2 RE-POINTED THIS ROW: the merchant rides the road's mildest severity, so the gated sentence says *it*.
	["glossary:severity:long", "In the run's first 3 steps, where no merchant is offered, it pays its own reward alone.", "rune. Severity"],
	["glossary:pouch_slots:long", "but Broken, Bleed and a poison that refuses every cleanse", "hero and"],
	["glossary:archetype_tags:long", "but the core runes", "rune carries"],
	["glossary:archetype_tags:long", "panel counts them", "and the hero sheet count"],
	["glossary:class_draft:short", "Cards written for a whole CLASS, drawn from its one pool beside its spec cards.", "Roughly one draft card in four is drawn from a pool the whole CLASS shares."],
	["glossary:class_draft:long", "draws from ONE POOL, your CLASS's: the cards written for each of its specs and the CLASS-WIDE cards written for all of them, shuffled together with no share or slot for either", "mixes two pools. Most cards come from your SPEC's own pool; roughly ONE IN FOUR comes from a CLASS-WIDE pool that every spec of that class draws from"],
	["glossary:class_draft:long", "AS WRITTEN", "Frostbolt. AND THEY"],
	["glossary:class_draft:long", "SPEC ABILITIES -", "ABILITIES, ON PURPOSE"],
	["glossary:class_draft:long", "Frenzy. ALL FOUR CLASSES HAVE THEM", "Frenzy, and an Arcanist's damaging one still builds Resonance. If they were as strong as spec cards they would be the safe default in every build, and every hero would end up holding the same few. Slightly weaker but always-on makes them the pick you take when your spec's engine is not online yet, which is a real and different role. ALL FOUR CLASS POOLS ARE WRITTEN"],
	["glossary:class_draft:long", "three Cleric. Five", "Cleric - so the class card in an offer draws a real entry for every hero in the game."],
	["glossary:class_draft:long", "from the same class pool as everyone else.", "every later card from the class pool alone."],
	["glossary:ability_slots:long", "the basic attack and", "except a"],
	["glossary:ability_slots:long", "every hero opens with his class kit's 3 filled, and the Sharpshooter, who fields no companion, with 2.", "most heroes open with 4 or 5 filled, and a hero who took a spine with 3."],
	["glossary:ability_slots:long", "needs a bench only when a draft card taken on the same screen fills the new slot first.", "never needs a bench."],
	["glossary:protected_core:long", "held, save that a Lethal Aim holder opens without Summon Companion", "is held -"],
	["glossary:frenzy_floor:long", "one past", "which is exactly"],
	["glossary:frenzy_floor:long", "tops out while he lives:", "already topped out:"],
	["glossary:frenzy_floor:long", "at most one step", "gains nothing from"],
	["glossary:frenzy_floor:long", "ONE THING CHANGES", "TWO THINGS CHANGE"],
	["glossary:frenzy_floor:long", "does not touch it: it pours the whole Rage bar out as damage, and that Rage counts as spent like any other.", "spends the live bonus as damage and then leaves him receiving ONLY the floor for two turns - the floor itself is untouched, which is exactly why a deep one makes that recovery cost almost nothing."],
	["status:poison", "3% of the applier's Attack as", "Takes 3 nature"],
	["status:parry_up", "+25% parry", "+15% parry"],
	["status:unity", "the damage of every blow, recoil and bleedout", "all damage received"],
	["status:devotion", "We Do Not Break: takes", "The Devout's presence: takes 15%"],
	["status:shielded", "ward, or the Hollow Crown's Regalia).", "Shieldmaster's ward)."],
	["status:bulwark_line", "+12% Block", "+10% Block"],
	["status:arcane_echo", "Barrage echoes once for every bolt.", "three-bolt Barrage echoes three times."],
	["status:vespers", "absorbed, up to 20% of her maximum health.", "is absorbed. It"],
	["status:loyalty", "a stack. Past", "stack, with NO CEILING."],
	["status:loyalty", "strike, until the boon reaches its limit.", "the strike. Lost"],
	["status:bloodbond", "takes a share of", "takes HALF of"],
	["status:bloodbond", "the share he", "the half he"],
	["status:formless", "no recoil follows.", "he pays both downsides."],
	["status:vigil", "second hero on", "second ally on"],
	["status:camouflage", "", "It stacks with Ghillie Suit rather than replacing it."],
	["item:health", "one hero's maximum", "one ally's maximum"],
	["item:mana", "one hero's maximum", "one ally's maximum"],
	["item:revive", "fallen hero at", "fallen ally at"],
	["modifier:overgrown", "health at most.", "70% health."],
	["modifier:parched", "resource at most.", "half resource."],
	# BATCH IY §2 — Dull Edge's row stood here; IZ §3 removed the modifier, and its text with it.
	["modifier:thinair", "Anything else that builds it still does.", "What you have is what you get."],
	["relic:tithe", "Gold won in battles and bargains", "All gold earned from nodes"],
	["relic:kingsledger", "battle and bargain", "all node"],
	["relic:martyrbone", "every victory.", "victory; rest nodes restore 10% more."],
	["rune:shared_ruin", "detonates, unless a leap primed it, HALF", "Ruin detonates, HALF"],
	["rune:bracing_line", "Other heroes", "Allies take"],
	["rune:shared_hide", "every damage buff it wears but Blessing of Zeal", "already wearing —"],
	["rune:ashfall", "shields for 200% of the Burn still to deal", "for what the Burn"],
	["rune:whetstone", "at once and 3% more", "grows 3% for each"],
	["rune:open_line", "2 turns,", "for a turn, and"],
	["rune:vigil", "when a hero is", "when an ally is"],
	["rune:open_hand_fk", "EVERY hero below", "EVERY ally below"],
	["rune:layered_aegis", "whichever other hero has the least health.", "whoever is lowest."],
	["rune:fourth_stack", "Heroes hold", "Allies hold"],
	["rune:bare_altar", "An absorb grants TWICE the Faith", "Faith builds TWICE as fast"],
	["rune:long_poison", "expires (not the barb's or Explosive Shot's).", "never expires. It"],
	["rune:second_barb", "Each time the barb fires, the enemy that struck", "An enemy that strikes"],
	["rune:second_barb", "DIFFERENT affliction, cycling", "affliction each time,"],
	["rune:abundance", "His healing", "Healing beyond"],
	["rune:vow_of_silence", "stronger (not those Faith and Ruin pay),", "50% stronger, and"],
	["lit:data/enemies.json", "(tanks and supports first).", "(tanks and healers first)", 2],
	["lit:data/events.json", "one hero takes the rot", "one hero risks the rot"],
	["lit:data/events.json", "leaves something written behind.", "written on the inside."],
	["lit:scripts/battle.gd:_ability_popup_button", "(No fallen heroes)", "(No fallen allies)"],
	["lit:scripts/battle.gd:_intent_hover_text", "Hits every ally", "Hits every hero"],
	["lit:scripts/battle.gd:_intent_hover_text", "Hits one ally %d times", "Hits one hero"],
	["lit:scripts/battle.gd:_resolve", "(parried — %s)", "(parried — UNTOUCHABLE)"],
	["lit:scripts/battle.gd:_resolve", "had lost only %d health when the shot left", "Shot: %s was unhurt"],
	["lit:scripts/battle.gd:_hold_tooltip", "damage from every hero's strike.", "damage from EVERY source."],
	["lit:scripts/battle.gd:_hold_tooltip", "lets it or falls:", "Cryomancer lets it:"],
	["lit:scripts/battle.gd:_hold_freeze", "a boss shrugs it off after %d turn%s", "only the Cryomancer can release it"],
	["lit:scripts/battle.gd:_apply_status", "Glacial Hold: never thaws", "Permafrost: never thaws"],
	["lit:scripts/battle.gd:_stamp_mirror_chip", "Area attacks and blows that hit at random never miss", "Area attacks never miss"],
	["lit:scripts/battle.gd:_divine_presence_tick", "a hero dropped below half health", "an ally fell"],
	["lit:scripts/battle.gd:_stamp_feint_chip", "melee blow outright (never an area attack, nor while he is Broken)", "parries one attack outright"],
	["lit:scripts/battle.gd:_resolve_special", "resource (all but %s)", ""],
	["lit:scripts/battle.gd:_resolve_special", "Bewitch — %s resists the charm", ""],
	["lit:scripts/battle.gd:_resolve_special", "the other heroes heal", "%d; the heroes heal"],
	["lit:scripts/battle.gd:_resolve_special", "his other cooldowns,", "his cooldowns,"],
	["lit:scripts/battle.gd:_resolve_special", "heals every hero %d%%", "heals all allies"],
	["lit:scripts/battle.gd:_resolve_special", "his other cooldowns.", "his cooldowns."],
	["lit:scripts/battle.gd:_resolve_special", "every other cooldown", "every cooldown"],
	["lit:scripts/battle.gd:_resolve_special", "Counter Time — %s resists the stun", ""],
	["lit:scripts/battle.gd:_resolve_special", "hero regains heroes regain", "ally regains allies regain"],
	["lit:scripts/battle.gd:_resolve_special", "mends a second hero on lower health", "mends a second ally for"],
	["lit:scripts/battle.gd:_resolve_special", "hero deals heroes deal", "%d all%s deal"],
	["lit:scripts/battle.gd:_resolve_special", "(%d%% of %s's maximum)", "(20%% of their own maximum)"],
	["lit:scripts/battle.gd:_resolve_special", "%d hero(es) gain", "%d ally(s) gain"],
	["lit:scripts/battle.gd:_resolve_special", "Venom Coating — for 4 turns every attack Poisons", "every attack Poisons for 4 turns"],
	["lit:scripts/battle.gd:_resolve_special", "holds BOTH guards for %d turns", "BOTH guards for a turn"],
	["lit:scripts/battle.gd:_resolve_special", "every hero gains a shield charge", "every ally gains a shield charge"],
	["lit:scripts/battle.gd:_resolve_special", "Glacial Prison reaches for", "Glacial Prison closes on"],
	["lit:scripts/battle.gd:_resolve_special", "the Glass Prison — %s resists the seal", ""],
	["lit:scripts/battle.gd:_resolve_special", "the prison is hurled at", "the prison moves to"],
	["lit:scripts/battle.gd:_resolve_special", "%d other hero below half", "%d ally below half"],
	["lit:scripts/battle.gd:_resolve_special", "%d other heroes below half", "%d allies below half"],
	["lit:scripts/battle.gd:_resolve_special", "the heroes who carried Faith take no healing from it", ""],
	["lit:scripts/battle.gd:_resolve_special", "%d hero(es) paid", "%d ally(s) paid"],
	["lit:scripts/battle.gd:_resolve_special", "%d heroes' attacks", "%d allies' attacks"],
	["lit:scripts/battle.gd:_add_bleed_with_burst", "the Slaughterhouse — the bleedout is an opening", "the kill is an opening"],
	["lit:scripts/battle.gd:_show_skill_check_hint", "Attacks and heals run a timing check", "Every action runs a timing check"],
	["lit:scripts/draft_screen.gd:_draw_screen", "Enemies strike at %d%% strength, the end boss at full.", "Enemies at %d%% strength, the end boss at full."],
	["lit:scripts/draft_screen.gd:_draw_screen", "once %d cells of tier %d are owned.", ""],
	["lit:scripts/events.gd:apply", "no rune is left that any hero can take.", "every hero already carries every rune written for them."],
	["lit:scripts/map_screen.gd:_maybe_show_framing", "up to three ways forward,", "three ways forward at a time,"],
	# BATCH IR §1a — RE-POINTED: the card's bargain sentence names Ruin's mini-boss, which offers none, and *always a mild
	# one* was false on Ruin (no mild option there); the safe option is the safer deal on every rung. IJ's false clause stays absent.
	["lit:scripts/map_screen.gd:_maybe_show_framing", "always the safer deal. Ruin's mini-boss fights unpaid. Winning any fight", "survivable. Clearing any encounter"],
	["lit:scripts/map_screen.gd:_maybe_show_framing", "every zone boss a talent point for each class", ""],
	["lit:scripts/map_screen.gd:_node_tooltip", "It is the %s.", ""],
	["lit:scripts/map_screen.gd:_open_rune_panel", "A rune drops after every normal fight,", "A rune drops after every fight,"],
	["lit:scripts/map_screen.gd:_open_loadout_panel", "a pick of up to three.", "a pick of three."],
	["lit:scripts/party_screen.gd:_passive_desc_live", "missing and every %s Rage spent, to at most +%s%%.", ""],
	["lit:scripts/party_screen.gd:_draw_detail", "damage blocked, of any type.", "physical damage blocked."],
	["lit:scripts/party_screen.gd:_draw_detail", "awakens on taking a core rune.", "awakens after your first victory."],
	["lit:scripts/run_state.gd:reward_text", "A random consumable", "A random potion"],
	["lit:scripts/run_state.gd:reward_text", "A rune pick for one hero", "A random rune"],
	["lit:scripts/runes.gd:_empty_offer_base", "not yet in their kit", "they have not earned"],
	["lit:scripts/spec_choice_screen.gd:_draw_screen", "%d more can join it later, and any can be dropped", "a second can join it later"],
	["lit:scripts/unit.gd:refresh_bars", "up to %d; only Arcane Bolt, Stabilize and Threshold ever lower them.", "with NO MAXIMUM, and nothing removes them."],
	["upgrade:up_free", "Costs no Rage / Mana (Mercy is unaffected).", "Rage / Mana / Focus"],
	["glossary:res_faith:short", "stacks that grow on shielded heroes", "stacks that grow on shielded allies"],
	["glossary:res_faith:long", "Faith lives mostly on the Devout's fellow HEROES", "Faith lives mostly on the Devout's ALLIES"],
	["glossary:res_faith:long", "a HERO'S Faith releases", "an ALLY'S Faith releases"],
	["glossary:res_faith:long", "a shielded hero HOLDS what one absorbed hit gives him", "a shielded ally HOLDS"],
	["card:Alms:desc", "by a hero falling below the window", "by an ally falling below the window"],
	["card:Alms:desc", "wards the hero who earned it", "wards the ally who earned it"],
	["status:alms", "wards the hero who earned it", "wards the ally who earned it"],
	["glossary:mercy_window:long", "a ward on the hero who earned it", "a ward on the ally who earned it"],
	["card:Divine Presence:desc", "on which NO hero fell below the window", "NO ally fell"],
	["status:divine_presence", "on which no hero fell below the window", "no ally fell"],
	["engine:conviction", "the hero is healed for", "the ally is healed for"],
	["lit:data/enemies.json", "Mends the most wounded of its warband", "Mends the most wounded ally", 2],
	["lit:data/enemies.json", "Wards one of its warband: 25% less strike damage taken", "Wards an ally"],  # IK §5: the strike named
	["lit:data/enemies.json", "Heals one of its warband for 20%", "Heals an ally for 20%"],
	["lit:data/enemies.json", "Strips one harmful effect from each of its warband", "from each ally"],
	["lit:data/enemies.json", "for every one of its warband fallen this battle", "for every ally that has fallen"],
	["lit:data/enemies.json", "Its whole warband regains 6% of their maximum health", "Every ally regains 6%"],
	["lit:scripts/battle.gd:_resolve_special", "Dark Vigil — its whole warband regains", "Dark Vigil — every ally regains"],
]


# ── §3 — THE PINS ───────────────────────────────────────────────────────────
# Each row: [holder, text needle, code file, code function, code needle] — IJ's census rows for a typed figure a player
# acts on, decided by an inline literal and not by a constant (`PINS`, below). A holder names the text as a surface reads
# it: `card:<name>:desc|perfect`, `status:`, `rune:`, `relic:`, `talent:`, `item:`, `modifier:`, `difficulty:`,
# `engine:`, `passive:`, `glossary:<id>:short|long`, `upgrade:`, `lit:<data file>` (its string literals, as §2e reads them), or
# `src:<file>:<function>` for words built in code (the needle then read in that function's comment-stripped source, in source
# form).
# BATCH IT §2 — the holder reader, the bodies and the corpus by name live in `gate_fixture.gd` now, shared with
# `check_it` §2; this is their cache.
var _cache := {}


func _holder_text(holder: String) -> Variant:
	if holder.begins_with("lit:"):
		var p := holder.split(":", true, 2)
		return _lit_stream(String(p[1]), String(p[2]) if p.size() > 2 else "")
	return Gate.holder_text(holder, _cache)


func _s3_pins() -> void:
	print("\n§3 — every pinned figure stands in its text and once, whole, in the code that decides it")
	var bad_text: Array = []
	var bad_code: Array = []
	var bad_holder: Array = []
	for row in PINS:
		var holder := String(row[0])
		var text: Variant = _holder_text(holder)
		if text == null or String(text) == "":
			bad_holder.append(holder)
			continue
		# A typed text is read with its whitespace collapsed, so a re-wrap moves no pin; a `src:` needle is source form.
		var src_row := holder.begins_with("src:")
		var needle := String(row[1]) if src_row else _norm(String(row[1]).replace("\\n", "\n"))
		if _count_whole(String(text) if src_row else _norm(String(text)), needle) < 1:
			bad_text.append("%s ~ %s" % [holder, needle])
		var body := _body(String(row[2]), String(row[3]))
		var n := _count_whole(body, String(row[4]))
		if n != 1:
			bad_code.append("%s ~ %s::%s %s (x%d)" % [holder, row[2], row[3], row[4], n])
	for b in bad_holder:
		ok(false, "§3: the holder %s names no text a surface reads" % b)
	for b in bad_text:
		ok(false, "§3: a pinned figure's words are gone from its text — %s" % b)
	for b in bad_code:
		ok(false, "§3: a pinned figure's code no longer stands once, whole, where it is decided — %s" % b)
	# BATCH IT §2 — 180 rows LEFT this table, each for `check_it` §2: IT named the literal each pinned, so the figure has
	# a constant now and the pin's premise (no constant decides it) is gone. Each is held there against its intent — the
	# text's figure against the constant's value, and the decision site reading the constant. The floor is IJ's 400.
	# BATCH IY §2 — SIX MORE LEFT IT, FOR `check_iy` §2: Tinderbox's, Frenzied's (Leaden's), Slick Footing's, Muffled's, Fleeting's and
	# Bloodletting's figures are `Run` constants now (IU §0.4: a figure a batch re-tunes gets a constant then), read bare at the
	# stamp and formatted in the words, so the pin's premise is gone; `check_iy` §2 holds each text's figure to its constant.
	ok(PINS.size() >= 400, "§3: only %d pins — the table has lost rows" % PINS.size())
	print("    CHECKED %d pins: %d holders unread, %d texts moved, %d codes moved" % [
		PINS.size(), bad_holder.size(), bad_text.size(), bad_code.size()])



const PINS := [
	["card:Mirror Image:desc", "wait until spent", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"mirror\", -1, mi_n)"],
	["card:Mana Shield:desc", "for 3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"mana_shield\", 3)"],
	["card:Mana Shield:desc", "50% of damage", "scripts/unit.gd", "take_hit", "maxi(int(amount * 0.5), 1)"],
	["card:Bloodlust:perfect", "Heals 45%", "scripts/battle.gd", "_resolve", "0.45 if is_perfect else ab.heal_missing"],
	["card:Blood Price:desc", "for 2 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"blood_price\", 2)"],
	["card:Blood Price:desc", "30 Rage", "scripts/battle.gd", "_resolve_special", "attacker.resource + 30, attacker.max_resource"],
	["card:Blood Price:desc", "pays 7.5% of", "scripts/battle.gd", "_resolve_special", "attacker.hp * 0.075"],
	["card:Battle Shout:desc", "Lasts 2 turns", "scripts/battle.gd", "_resolve_special", "shout_turns: int = [2, 3, 4]"],
	["card:Battle Shout:desc", ": +8%", "scripts/battle.gd", "_resolve_special", "shout_base: int = [8, 12, 18]"],
	["card:Battle Shout:desc", "1% per 20", "scripts/battle.gd", "_resolve_special", "shout_base + int(shout_bleed / 20.0)"],
	["card:Blood Debt:desc", "rest of the battle", "scripts/battle.gd", "_resolve", "_apply_status(strike_target, \"blood_debt\", -1"],
	["card:Shieldwall:desc", "3 turns", "scripts/battle.gd", "_recast_writes", "sw_turns := 3 + 2 * u.shield_mastery_ranks"],
	["card:War Stomp:desc", "regain 10%", "scripts/battle.gd", "_resolve", "stomp_pct := 0.20 if is_perfect else 0.10"],
	["card:War Stomp:perfect", "regain 20%", "scripts/battle.gd", "_resolve", "stomp_pct := 0.20 if is_perfect else 0.10"],
	["card:Interpose:desc", "a shield charge", "scripts/battle.gd", "_resolve_special", "sw_grant := 1"],
	["card:Hold the Line:desc", "for 2 turns,", "scripts/battle.gd", "_resolve_special", "_apply_status(h, \"hold_bd\", 2, hl_cut)"],
	["card:Hold the Line:desc", "for 2 turns.", "scripts/battle.gd", "_resolve_special", "hl_undying := 3 if hl_up else 2"],
	["card:Hold the Line:desc", "50% less Break", "scripts/battle.gd", "_resolve_special", "hl_cut := 80 if hl_up else 50"],
	["card:Retaliation:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"retaliate\", 4)"],
	["card:Vendetta:desc", "REST OF THE", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"mocked\", -1, vd_idx"],
	["card:Rallying Shout:desc", "sheds 30", "scripts/battle.gd", "_resolve_special", "pressure_cut := 30"],
	["card:Rallying Shout:desc", "regains 30%", "scripts/battle.gd", "_resolve_special", "res_pct := 0.30"],
	["card:Overpower:desc", "held Broken one", "scripts/battle.gd", "_resolve", "strike_target.broken_extra_turns += 1"],
	["card:Overpower:desc", "+0.5 damage", "scripts/battle.gd", "_resolve", "raw += 0.5 * strike_target.pressure"],
	["card:Overpower:perfect", "+5 bonus Rage", "scripts/battle.gd", "_apply_perfect_bonus", "attacker.resource + 5,"],
	["card:Guard Change:desc", "15 BD", "scripts/battle.gd", "_resolve_special", "attacker.guard_change_bd if gc_wide else 15"],
	["card:Guard Change:perfect", "for 2 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"parry_up\", 2, gc_parry)"],
	["card:Guard Change:perfect", "+10% Parry", "scripts/battle.gd", "_resolve_special", "gc_parry := 10 + int("],
	["card:Sweeping Strikes:perfect", "+25% crit", "scripts/battle.gd", "_resolve", "crit_chance += 0.25"],
	["card:Shatterpoint:perfect", "+15 bonus BD", "scripts/battle.gd", "_resolve", "pr += 15"],
	["card:Lunge:desc", "3 turns either way", "scripts/battle.gd", "_resolve", "_apply_status(strike_target, lunge_status, 3"],
	# BATCH IK §2 — RE-POINTED: the line moved out of the door into the one answer the door, the picker and the bot ask.
	["card:Execute:desc", "below 20% health", "scripts/battle.gd", "_execute_line", "return 0.35 if u.execute_upgraded > 0 else 0.2"],
	["card:Feint:perfect", "A third charge", "scripts/battle.gd", "_resolve_special", "FEINT_GUARDS + (1 if is_perfect else 0)"],
	["card:Detonation:desc", "250% of its", "scripts/battle.gd", "_resolve", "det_mult: float = (2.5 + 0.75 * attacker.focused_flame)"],
	["card:Detonation:desc", "1 Mana for every", "scripts/battle.gd", "_overburn_refund", "rate := 2 if u.crucible > 0 else 1"],
	["card:Detonation:perfect", "2 turns of Burn", "scripts/battle.gd", "_resolve", "_apply_status(strike_target, \"burn\", 2,"],
	["card:Wildfire:desc", "18% of Attack", "scripts/battle.gd", "_resolve_special", "0.18 * wf_spent * attacker.attack"],
	["card:Wildfire:desc", "loses a turn", "scripts/battle.gd", "_resolve_special", "wf_take := 2 if is_perfect else 1"],
	["card:Wildfire:perfect", "Consumes 2 turns", "scripts/battle.gd", "_resolve_special", "wf_take := 2 if is_perfect else 1"],
	["card:Flamewave:desc", "applies 2 turns", "scripts/battle.gd", "_resolve", "(3 if is_perfect else 2) + attacker.conflagration_ranks"],
	["card:Flamewave:desc", "burn 2 turns", "scripts/battle.gd", "_resolve", "(3 if is_perfect else 2) + attacker.conflagration_ranks"],
	["card:Flamewave:perfect", "3 turns of Burn", "scripts/battle.gd", "_resolve", "(3 if is_perfect else 2) + attacker.conflagration_ranks"],
	["card:Immolate:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"immolate\", 4)"],
	["card:Immolate:desc", "3 turns", "scripts/battle.gd", "_resolve", "_apply_status(attacker, \"burn\", 3,"],
	["card:Firestorm:desc", "6-8 bolts", "scripts/battle.gd", "_resolve", "randi_range(6, 8)"],
	["card:Backdraft:desc", "gains 2 more", "scripts/battle.gd", "_resolve_special", "bd_turns := 3 if is_perfect else 2"],
	["card:Phoenix Rebirth:desc", "pay 15%", "scripts/battle.gd", "_resolve_special", "int(attacker.hp * 0.15)"],
	["card:Blizzard:desc", "1-2 stacks", "scripts/battle.gd", "_resolve", "randi_range(1, 2)"],
	["card:Blizzard:perfect", "Two stacks", "scripts/battle.gd", "_resolve", "(2 if is_perfect else randi_range(1, 2))"],
	["card:Ice Lance:desc", "+5% of", "scripts/battle.gd", "_resolve", "raw += (0.05 + 0.01 * (attacker.crystal_edge_ranks"],
	["card:Ice Lance:perfect", "20 BD", "scripts/battle.gd", "_resolve", "pr = 20"],
	["card:Rime:desc", "For 4 turns", "scripts/battle.gd", "_resolve_special", "rime_turns := 4 + attacker.icy_resolve_ranks"],
	["card:Rime:desc", "for 2 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"frostbite\", 2"],
	["card:Rime:desc", "50% less healing", "scripts/unit.gd", "heal_amount", "mult *= 0.5"],
	["card:Shatter:perfect", "becomes 4", "scripts/battle.gd", "_resolve", "attacker.cooldowns[ab.display_name] = 5"],
	["card:Arcane Cannon:desc", "BD = 5 x", "scripts/battle.gd", "_resolve", "(5.0 + attacker.cannoneer_ranks)"],
	["card:Overcharge:desc", "Once per battle", "scripts/unit.gd", "overcharge_ready", "overcharge_uses < 1 + overcharge_extra"],
	["card:Overcharge:desc", "FULL stacks", "scripts/battle.gd", "_resolve_special", "overcharge_mult = 1.0"],
	["card:Magi's Wrath:desc", "BD = 2.5 x", "scripts/battle.gd", "_resolve", "2.5 * attacker.second_resource"],
	["card:Magi's Wrath:perfect", "3.5 initiative", "scripts/battle.gd", "_resolve", "eff_delay = 3.5"],
	["card:Stabilize:desc", "for 2 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"stabilized\", 2, st_dr)"],
	["card:Stabilize:desc", "+10%", "scripts/battle.gd", "_resolve_special", "st_dr := 10 * st_stacks"],
	["card:Stabilize:desc", "+5 Mana", "scripts/battle.gd", "_resolve_special", "st_mana := 5 * st_stacks"],
	["card:Stabilize:desc", "ABOVE 2", "scripts/battle.gd", "_resolve_special", "st_floor := 2 + attacker.still_mind_ranks"],
	["card:Stabilize:desc", "{mhp:5}", "scripts/battle.gd", "_resolve_special", "st_heal := maxi(int(round(attacker.max_hp * 0.05)), 1)"],
	["card:Arcane Surge:desc", "your next turn", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"surge\", 2)"],
	["card:Arcane Surge:desc", "banks 2 Resonance", "scripts/battle.gd", "_resolve_special", "_gain_resonance(attacker, 2)"],
	["card:Heal:desc", "for 40%", "scripts/battle.gd", "_resolve_special", "var hh_amt := maxi(int(round(attacker.max_hp * 0.40"],
	["card:Heal:desc", "for 1 Mercy", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["card:Heal:perfect", "{mhp:5}", "scripts/battle.gd", "_resolve_special", "var hh_self := maxi(int(round(attacker.max_hp * 0.05)), 1)"],
	["card:Renewal:desc", "for 5 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"renewal\", 5, 0, ren_tick, attacker)"],
	["card:Renewal:desc", "heals 15%", "scripts/battle.gd", "_resolve_special", "var ren_tick := maxi(int(round(attacker.max_hp * 0.15"],
	["card:Renewal:desc", "for\\n1 Mercy", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["card:Renewal:perfect", "Heals 5%", "scripts/battle.gd", "_resolve_special", "var ren_burst := maxi(int(round(attacker.max_hp * 0.05 * rb_crit)), 1)"],
	["card:Hymn of Hope:desc", "for\\n20%", "scripts/battle.gd", "_resolve_special", "var pct := 0.20"],
	["card:Hymn of Hope:desc", "35% instead", "scripts/battle.gd", "_resolve_special", "pct = 0.35"],
	["card:Hymn of Hope:desc", "(+1 Mercy)", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["card:Hymn of Hope:perfect", "Heals 25%", "scripts/battle.gd", "_resolve_special", "pct = 0.25"],
	["card:Resurrection:desc", "plus 5 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"renewal\", 5, 0, rez_tick, attacker)"],
	["card:Resurrection:desc", "with 25%", "scripts/battle.gd", "_resolve_special", "var rez_frac := 0.25"],
	["card:Resurrection:desc", "(+1 Mercy)", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["card:Resurrection:desc", "full health", "scripts/battle.gd", "_resolve_special", "rez_frac = 1.0"],
	["card:Divine Plea:desc", "for 3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"sanctified\", 3, 0, 0, attacker)"],
	["card:Divine Plea:desc", "1 more Mercy", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["card:Dawnbreak:desc", "ally 40", "scripts/battle.gd", "_resolve_special", "(55 if is_perfect else 40)"],
	["card:Dawnbreak:perfect", "Heals 55", "scripts/battle.gd", "_resolve_special", "(55 if is_perfect else 40)"],
	["card:Sanctuary:desc", "heals\\n12%", "scripts/battle.gd", "_resolve_special", "(0.18 if is_perfect else 0.12)"],
	["card:Sanctuary:perfect", "Heals 18%", "scripts/battle.gd", "_resolve_special", "(0.18 if is_perfect else 0.12)"],
	["card:Intercession:desc", "For 2 turns", "scripts/battle.gd", "_resolve_special", "var ic_turns := 2 + attacker.intercession_long"],
	["card:Intercession:desc", "loses 1 Mercy", "scripts/battle.gd", "_on_intercession_save", "cleric.second_resource -= 1"],
	["card:Intercession:desc", "at 1 health", "scripts/unit.gd", "_holy_reversal", "hp = 1"],
	["card:Divine Shield:desc", "absorbs 35%", "scripts/battle.gd", "_resolve_special", "var ds_pct := 0.35 + 0.01 * attacker.stalwart_step"],
	["card:Consecrated Ground:desc", "for 3\\nturns", "scripts/battle.gd", "_resolve_special", "_apply_status(h, \"cons_ground\", 3, 0, 0, attacker)"],
	["card:Consecrated Ground:desc", "reflects 10%", "scripts/battle.gd", "_resolve", "var cg_pct := 0.10"],
	["card:Blessing of Zeal:desc", "for\\n4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"zeal\", 4, 0, 0, attacker)"],
	["card:Blessing of Zeal:desc", "doubled", "scripts/battle.gd", "_gain_faith", "n *= 2"],
	["card:Blessing of Zeal:desc", "1 turn NOW", "scripts/battle.gd", "_resolve_special", "var zeal_ticks := 1 + attacker.crusade_ranks"],
	["card:Sacred Resolve:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "var res_turns := 4 + attacker.resolve_extra_turns"],
	["card:Bulwark of Fortitude:desc", "for 3 turns", "scripts/battle.gd", "_resolve_special", "var bw_turns := 3 + attacker.bulwark_extra_turns"],
	["card:Bulwark of Fortitude:desc", "heals 10%", "scripts/battle.gd", "_run_battle", "var bw_amt := maxi(int(round(u.max_hp * 0.10)), 1)"],
	["card:Bulwark of Fortitude:desc", "by 50%", "scripts/unit.gd", "effective_armor", "a *= 1.5"],
	["card:Bulwark of Fortitude:desc", "them 5% of max health", "scripts/battle.gd", "_resolve_special", "var bw_heal := maxi(int(round(h.max_hp * 0.05)), 1)"],
	["card:Divine Wrath:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(h, \"wrath\", 4, 0, 0, attacker)"],
	["card:Divine Wrath:desc", "15% faster", "scripts/unit.gd", "effective_speed", "s *= 1.15"],
	["card:Bewitch:desc", "for 3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"bewitch\", 3, 0, 0, attacker)"],
	["card:Dark Pact:desc", "heals 15%", "scripts/battle.gd", "_resolve_special", "var pact_heal_pct := 0.15 + 0.01 * attacker.barter_step"],
	["card:Dark Pact:desc", "lose 20%", "scripts/battle.gd", "_resolve_special", "var pact_pct := maxf(0.20 - 0.01 * attacker.pact_flesh_ranks, 0.0)"],
	["card:Mind Flay:perfect", "lasts 4 turns", "scripts/battle.gd", "_resolve", "turns = 4"],
	["card:Mass Hysteria:desc", "for 3 turns", "scripts/battle.gd", "_enemy_turn", "\"applies_status\": {\"id\": \"sunder\", \"turns\": 3}"],
	["card:Mass Hysteria:desc", "DOUBLE", "scripts/battle.gd", "_enemy_turn", "\"pressure\": hys_basic.pressure * 2"],
	["card:Umbral Sigil:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"umbral_sigil\", 4, 0, 0, attacker)"],
	["card:Umbral Sigil:desc", "half of", "scripts/battle.gd", "_umbral_sigil_echo", "var echo := maxi(int(round(landed * 0.5)), 1)"],
	["card:Covenant of Ash:desc", "Two Ruin", "scripts/battle.gd", "_resolve_special", "_gain_ruin(target, 2)"],
	["card:Shadowrend:perfect", "{mhp:5}", "scripts/battle.gd", "_apply_perfect_bonus", "var sh_amt := maxi(int(round(attacker.max_hp * 0.05)), 1)"],
	["engine:bloodrage", "+2% damage", "scripts/unit.gd", "frenzy_bonus", "var step := (2.0 + bloodrage_step_bonus"],
	["engine:heavy_plating", "up to +40%", "scripts/battle.gd", "_resolve", "strike_target.plating_bonus + wd_climb, 0.40)"],
	["engine:heavy_plating", "+15% Block", "scripts/battle.gd", "_plating_slice", "var slice := (0.15 + u.plating_bonus)"],
	["engine:heavy_plating", "by 8%", "scripts/battle.gd", "_resolve", "var wd_climb := 0.08"],
	["engine:seasoned", "+10% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.10 * (2.0 if strike_target.rune_naked_blade > 0 else 1.0)"],
	["engine:seasoned", "-10% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 - 0.10 * (2.0 if attacker.rune_naked_blade > 0 else 1.0)"],
	["engine:seasoned", "15% less", "scripts/battle.gd", "_resolve", "var sf_def := 0.15 * (2.0 if strike_target.rune_naked_blade > 0 else 1.0)"],
	["engine:overburn", "refunds 1 Mana", "scripts/battle.gd", "_overburn_refund", "var rate := 2 if u.crucible > 0 else 1"],
	["engine:permafrost", "ONE held enemy", "scripts/battle.gd", "_hold_limit", "var hl := 1"],
	["engine:resonance", "(2 on a", "scripts/battle.gd", "_resolve", "var res_gain := (2 + attacker.rune_overflow"],
	["engine:resonance", "+1% critical", "scripts/battle.gd", "_resolve", "crit_chance += (0.01 + 0.01 * attacker.arcane_mastery_ranks)"],
	["engine:mercy", "(max 5)", "scripts/battle.gd", "_spawn_units", "cfg[\"second_max\"] = 5 + int(cfg.get(\"mercy_cap_bonus\", 0))"],
	["engine:mercy", "+5% healing", "scripts/battle.gd", "_healing_done_mult", "m += 0.01 * (5 + caster.heavenly_step) * caster.second_resource"],
	["engine:old_gods", "+2% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.01 * (2 + ruin_occ.deep_hex_step"],
	["engine:old_gods", "90% of Attack", "scripts/battle.gd", "_detonate_ruin", "var det_raw := 0.90 * occ.attack"],
	["engine:old_gods", "heal 2%", "scripts/battle.gd", "_resolve", "* (2 + occ_leech.soul_leech_step + occ_leech.rune_soul_leech_step"],
	["engine:pack", "+15% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.15 * bm_canis * bm_wounded"],
	["engine:pack", "under 35%", "scripts/battle.gd", "_resolve", "en.hp < en.max_hp * 0.35"],
	["engine:pack", "swap; +5%", "scripts/battle.gd", "_comp_dmg_mult", "var step := 0.05 + 0.01 * (pm.wild_communion_step + pm.rune_wild_communion_step)"],
	["engine:lethal_aim", "+20 FOCUS", "scripts/battle.gd", "_sharpshooter_focus", "var gain := 20 + attacker.muscle_memory_ranks + attacker.rune_muscle_memory_ranks"],
	["engine:lethal_aim", "50 retained", "scripts/battle.gd", "_sharpshooter_focus", "attacker.second_resource = mini(attacker.second_resource, 50)"],
	["engine:trapper", "for 5 turns", "scripts/battle.gd", "_resolve", "_apply_status(attacker, \"poison\", 5, 0,"],
	["engine:trapper", "+8% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.08 * sv_n"],
	["engine:trapper", "a 25%", "scripts/battle.gd", "_resolve", "(strike_target.rune_thin_blood > 0 or randf() < 0.25)"],
	["passive:cleric", "by 15%", "scripts/battle.gd", "_spawn_units", "+ 0.15"],
	["passive:mage", "10 Mana", "scripts/battle.gd", "_spawn_units", "cfg[\"mana_regen_bonus\"] = 10"],
	["src:scripts/classes.gd:computed_block", "int(hit * 0.9)", "scripts/battle.gd", "_resolve", "* 0.01 * attacker.attack * randf_range(0.9, 1.1) * dmg_mult"],
	["src:scripts/classes.gd:computed_block", "round(hit * 1.1)", "scripts/battle.gd", "_resolve", "* 0.01 * attacker.attack * randf_range(0.9, 1.1) * dmg_mult"],
	["src:scripts/battle.gd:_show_actions", "+1 Loyalty", "scripts/battle.gd", "_gain_loyalty", "amount := 1)"],
	["src:scripts/battle.gd:_show_actions", "Spend +1 Mercy", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	# BATCH IU §4 — the swap's words are built in `_swap_choice` since the bot and the picker share it.
	["src:scripts/battle.gd:_swap_choice", "+1 Loyalty", "scripts/battle.gd", "_gain_loyalty", "amount := 1)"],
	["src:scripts/battle.gd:_open_called_picker", "2 turns", "scripts/battle.gd", "_resolve", "_apply_status(target, \"sunder\", 2, 0, 0, attacker)"],
	["src:scripts/battle.gd:_open_called_picker", "+30 Break", "scripts/battle.gd", "_resolve", "target.take_hit(0, 30)"],
	["src:scripts/battle.gd:_open_called_picker", "(3 turns)", "scripts/battle.gd", "_resolve", "_apply_status(target, \"exposed\", 3, 0, 0, attacker)"],
	["src:scripts/battle.gd:_stamp_loyalty_chip", "(2 * stacks)", "scripts/battle.gd", "_companion_strike", "var wolf_bleed := (20 + 2 * l"],
	["src:scripts/battle.gd:_stamp_loyalty_chip", "mini(20 * stacks, 100)", "scripts/battle.gd", "_companion_strike", "0.20 * l)"],
	["src:scripts/battle.gd:_stamp_ruin_chip", "never clears", "scripts/battle.gd", "_gain_ruin", "_apply_status(target, \"ruin\", -1"],
	["src:scripts/battle.gd:_stamp_ruin_chip", "2 + occ.deep_hex_step", "scripts/battle.gd", "_resolve", "0.01 * (2 + ruin_occ.deep_hex_step"],
	["src:scripts/battle.gd:_resolve_special", "each turn (10%", "scripts/battle.gd", "_resolve_special", "pact_tick := maxi(int(round(attacker.max_hp * 0.10)), 1)"],
	["src:scripts/battle.gd:_resolve_special", "per 20 of the", "scripts/battle.gd", "_resolve_special", "shout_base + int(shout_bleed / 20.0)"],
	["src:scripts/battle.gd:_resolve_special", "(10%% per Resonance", "scripts/battle.gd", "_resolve_special", "var st_dr := 10 * st_stacks"],
	["src:scripts/battle.gd:_resolve_special", "turn (15%", "scripts/battle.gd", "_resolve_special", "var ren_tick := maxi(int(round(attacker.max_hp * 0.15"],
	["status:slow", "-25% speed", "scripts/unit.gd", "effective_speed", "0.75 if has_status(\"slow\")"],
	["status:chilled", "1 = -25% speed", "scripts/unit.gd", "effective_speed", "s *= maxf(0.75 - frigid_bonus, 0.1)"],
	["status:chilled", "2 = -50%", "scripts/unit.gd", "effective_speed", "s *= maxf(0.5 - frigid_bonus * chill, 0.1)"],
	["status:fortify", "+10% armor", "scripts/unit.gd", "effective_armor", "a += 0.10"],
	["status:renewal", "(15% of the caster", "scripts/battle.gd", "_resolve_special", "var ren_tick := maxi(int(round(attacker.max_hp * 0.15"],
	["status:quickdraw", "50% faster", "scripts/unit.gd", "effective_speed", "s *= 1.5"],
	["status:mana_shield", "50% of damage", "scripts/unit.gd", "take_hit", "var converted := maxi(int(amount * 0.5), 1)"],
	["status:psychosis", "50% each turn", "scripts/battle.gd", "_enemy_turn", "if randf() < 0.5:"],
	["status:ruin", "does not wear off", "scripts/battle.gd", "_gain_ruin", "_apply_status(target, \"ruin\", -1"],
	["status:ruin", "takes 2%", "scripts/battle.gd", "_resolve", "0.01 * (2 + ruin_occ.deep_hex_step"],
	["status:hysteria", "DOUBLE Break", "scripts/battle.gd", "_enemy_turn", "hys_basic.pressure * 2"],
	["status:tripwire", "75% of their damage", "scripts/battle.gd", "_resolve", "int(total_dealt * 0.75)"],
	["status:hexed", "rest of the battle", "scripts/battle.gd", "_use_item", "_apply_status(vs_e, \"hexed\", -1)"],
	["status:dazed", "20% more likely", "scripts/battle.gd", "_miss_chance", "0.20 if attacker.has_status(\"dazed\")"],
	["status:wrath", "+15% speed", "scripts/unit.gd", "effective_speed", "s *= 1.15"],
	["status:umbral_sigil", "half of every strike", "scripts/battle.gd", "_umbral_sigil_echo", "var echo := maxi(int(round(landed * 0.5)), 1)"],
	["status:shield_charges", "one charge each", "scripts/battle.gd", "_resolve", "charges[\"power\"] = int(charges[\"power\"]) - 1"],
	["status:hold_bd", "50% less Break", "scripts/battle.gd", "_resolve_special", "hl_cut := 80 if hl_up else 50"],
	["status:intercession", "loses 1 Mercy", "scripts/battle.gd", "_on_intercession_save", "cleric.second_resource -= 1"],
	["status:intercession", "survive at 1 HP", "scripts/unit.gd", "_holy_reversal", "hp = 1"],
	["status:immolate", "(3 turns)", "scripts/battle.gd", "_resolve", "_apply_status(attacker, \"burn\", 3,"],
	["status:frostbite", "reduced by 50%", "scripts/unit.gd", "heal_amount", "mult *= 0.5"],
	["status:stabilized", "(10% per stack", "scripts/battle.gd", "_resolve_special", "var st_dr := 10 * st_stacks"],
	["status:cons_ground", "reflects 10%", "scripts/battle.gd", "_resolve", "var cg_pct := 0.10"],
	["status:zeal", "is doubled", "scripts/battle.gd", "_gain_faith", "n *= 2"],
	["status:bulwark", "10% max health", "scripts/battle.gd", "_run_battle", "var bw_amt := maxi(int(round(u.max_hp * 0.10)), 1)"],
	["status:bulwark", "50%, and", "scripts/unit.gd", "effective_armor", "a *= 1.5"],
	["status:loyalty", "+5%\\nstrike damage", "scripts/battle.gd", "_comp_dmg_mult", "var step := 0.05 + 0.01"],
	["status:elusive", "are 25%", "scripts/battle.gd", "_miss_chance", "chance += 0.25"],
	["status:instinct", "+10% of", "scripts/battle.gd", "_resolve", "raw += 0.10 * attacker.attack"],
	["status:instinct", "15% of its max health", "scripts/battle.gd", "_resolve", "hi_b.heal_amount(int(hi_b.max_hp * 0.15))"],
	["status:bestial", "+10 Bleed", "scripts/battle.gd", "_companion_strike", "+ (10 if comp.has_status(\"bestial\") else 0)"],
	["status:bestial", "+50% armor", "scripts/battle.gd", "_resolve_special", "bw_comp.bestial_armor_bonus = bw_comp.armor * 0.5"],
	["status:bestial", "+25% damage", "scripts/battle.gd", "_bestial_dmg_mult", "return 1.25"],
	["status:bestial", "+50% damage", "scripts/battle.gd", "_bestial_dmg_mult", "return 1.5"],
	["status:bestial", "doubled health", "scripts/battle.gd", "_resolve_special", "bw_comp.bestial_hp_bonus = bw_comp.max_hp"],
	["status:spirit_heal", "heals 10%", "scripts/battle.gd", "_resolve_special", "int(attacker.max_hp * 0.10))"],
	["status:spirit_mana", "5% max Mana", "scripts/battle.gd", "_resolve_special", "int(attacker.max_resource * 0.05))"],
	["status:vigor", "+10% max", "scripts/battle.gd", "_resolve_special", "sb_u.vigor_hp_bonus = int(sb_u.max_hp * 0.10)"],
	["status:primal_surge", "+10% damage", "scripts/battle.gd", "_resolve", "raw *= 1.10"],
	["status:hunt_mark", "+25% damage", "scripts/battle.gd", "_companion_hit", "raw *= 1.25"],
	# BATCH IR §1b — RE-POINTED: the vow is a hero's (`HERO_PICKS`), so its chip says hero; the code it pins did not move.
	["src:scripts/unit.gd:refresh_bars", "damage per 5%", "scripts/unit.gd", "frenzy_bonus", "int((1.0 - hp / float(max_hp)) * 100.0 / 5.0)"],
	["src:scripts/unit.gd:refresh_bars", "Heavy Plating: +15%", "scripts/battle.gd", "_plating_slice", "(0.15 + u.plating_bonus)"],
	["src:scripts/unit.gd:refresh_bars", "adds +8%", "scripts/battle.gd", "_resolve", "var wd_climb := 0.08"],
	["src:scripts/unit.gd:refresh_bars", "cap +40%", "scripts/battle.gd", "_resolve", "strike_target.plating_bonus + wd_climb, 0.40)"],
	["src:scripts/unit.gd:refresh_bars", "dealt, +10%", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.10 * (2.0 if strike_target.rune_naked_blade > 0 else 1.0)"],
	["src:scripts/unit.gd:refresh_bars", "taken, -10%", "scripts/battle.gd", "_resolve", "raw *= 1.0 - 0.10 * (2.0 if attacker.rune_naked_blade > 0 else 1.0)"],
	["src:scripts/unit.gd:refresh_bars", "(2 on a crit)", "scripts/battle.gd", "_resolve", "var res_gain := (2 + attacker.rune_overflow"],
	["src:scripts/unit.gd:_chilled_desc", "-25% speed", "scripts/unit.gd", "effective_speed", "s *= maxf(0.75 - frigid_bonus, 0.1)"],
	["src:scripts/unit.gd:_chilled_desc", "-50% speed\"", "scripts/unit.gd", "effective_speed", "s *= maxf(0.5 - frigid_bonus * chill, 0.1)"],
	["src:scripts/unit.gd:_chilled_desc", "-50% speed,", "scripts/unit.gd", "effective_speed", "s *= maxf(0.5 - frigid_bonus * chill, 0.1)"],
	["src:scripts/unit.gd:log_bleed_chip", "20%% of max HP", "scripts/battle.gd", "_add_bleed_with_burst", "(0.15 if pact < 0 else 0.20)"],
	["src:scripts/unit.gd:log_bleed_chip", "At 100 the target", "scripts/unit.gd", "add_bleed", "var bled := bleed_buildup >= 100"],
	["src:scripts/unit.gd:_refresh_chips", "Iron Will: takes 12%", "scripts/battle.gd", "_resolve", "var iw_pct := 12 * strike_target.iron_will_ranks"],
	["src:scripts/unit.gd:take_hit", "-30% armor", "scripts/unit.gd", "effective_armor", "a *= 0.7"],
	["src:scripts/unit.gd:take_hit", "+25% crit", "scripts/battle.gd", "_resolve", "(0.25 if strike_target.broken else 0.0)"],
	["rune:shared_ruin", "HALF the stacks", "scripts/battle.gd", "_detonate_ruin", "var sr_share: int = sr_left / 2"],
	["rune:open_wound", "decays by 1", "scripts/battle.gd", "_run_battle", "u.set_ruin_stacks(ow_was - 1)"],
	["rune:standing_wall", "HALVES the Heavy", "scripts/battle.gd", "_resolve", "strike_target.plating_bonus *= 0.5"],
	["rune:keen_focus", "HALVES his Focus", "scripts/battle.gd", "_sharpshooter_focus", "attacker.second_resource = attacker.second_resource / 2"],
	["rune:answering_pack", "takes the blow", "scripts/battle.gd", "_on_brunt_guard", "var share_pct: int = 100 if by_rune"],
	["rune:open_vein", "counts DOUBLE", "scripts/unit.gd", "frenzy_rage_steps", "(2 if rune_open_vein > 0 else 1)"],
	["rune:ember_leap", "half the turns", "scripts/battle.gd", "_overburn_refund", "var el_half: int = turns_consumed / 2"],
	["rune:pyre_debt", "refunds DOUBLE", "scripts/battle.gd", "_overburn_refund", "rate *= 2"],
	["rune:killing_cold_fk", "at maximum Chill", "scripts/battle.gd", "_killing_cold_cast", "if kc_stacks < 4:"],
	["rune:overtone", "DOUBLE Resonance", "scripts/battle.gd", "_resolve", "res_gain *= 2"],
	["rune:dissonance", "TWICE his Resonance", "scripts/unit.gd", "resonance_curve", "(2 if rune_dissonance > 0 else 1)"],
	["rune:overflow", "instead of two", "scripts/battle.gd", "_resolve", "var res_gain := (2 + attacker.rune_overflow"],
	["rune:bare_altar", "half as much", "scripts/battle.gd", "_resolve_special", "ds_pct *= 0.5"],
	["rune:thin_blood", "a quarter", "scripts/battle.gd", "_resolve", "or randf() < 0.25)"],
	["src:scripts/draft_screen.gd:_draw_screen", "four heroes (%d/4)", "scripts/draft_screen.gd", "_toggle_hero", "elif picks.size() < 4:"],
	["src:scripts/draft_screen.gd:_draw_screen", "(%d/3)", "scripts/draft_screen.gd", "_toggle_relic", "elif relic_picks.size() < 3:"],
	# BATCH IM §1 RE-POINTED THIS ROW: the three are dealt by the gamble loop's own stop now, the fallback gone.
	["src:scripts/map_screen.gd:_maybe_show_framing", "THREE BARGAINS", "scripts/run_state.gd", "roll_offer", "if picked.size() >= 3:"],
	["src:scripts/map_screen.gd:_node_tooltip", "Three ability upgrades", "scripts/run_state.gd", "roll_blacksmith_offer", "if offer.size() == 3:"],
	["src:scripts/relics_screen.gd:_ready", "up to 3", "scripts/draft_screen.gd", "_toggle_relic", "elif relic_picks.size() < 3:"],
	["item:revive", "at 50% HP", "scripts/battle.gd", "_use_item", "target.revive(0.5)"],
	["item:defense", "for 3 turns", "scripts/battle.gd", "_use_item", "_apply_status(h, \"fortify\", 3)"],
	["item:defense", "+10% armor", "scripts/unit.gd", "effective_armor", "a += 0.10"],
	["modifier:warded", "25% more", "scripts/battle.gd", "_stamp_modifier", "u.mod_cost_mult = 1.25"],
	["modifier:feverish", "25% more damage", "scripts/battle.gd", "_stamp_modifier", "u.attack = int(round(u.attack * 1.25))"],
	["modifier:miasma", "is halved", "scripts/battle.gd", "_stamp_modifier", "u.healing_received_mult *= 0.5"],
	["modifier:encumbered", "two more turns", "scripts/battle.gd", "_stamp_modifier", "ab.cooldown += 2"],
	["modifier:mirrorbound", "a quarter", "scripts/battle.gd", "_stamp_modifier", "u.mod_recoil = 0.25"],
	["modifier:rot", "is halved", "scripts/battle.gd", "_stamp_modifier", "maxi(u.max_hp / 2, 1)"],
	["src:scripts/spec_choice_screen.gd:_draw_screen", "one of three core", "scripts/run_state.gd", "deal_engines", "dealt = pool.slice(0, 3)"],
	["src:scripts/spec_choice_screen.gd:_ability_text", "int(hit * 0.9)", "scripts/battle.gd", "_resolve", "0.01 * attacker.attack * randf_range(0.9, 1.1)"],
	["talent:tn_last_hope", "under 25%", "scripts/unit.gd", "heal_amount", "last_hope_bonus > 0 and hp < max_hp * 0.25"],
	["talent:tn_iron_will", "12% less damage", "scripts/battle.gd", "_resolve", "var iw_pct := 12 * strike_target.iron_will_ranks"],
	["talent:tn_iron_will", "maximum of 90%", "scripts/battle.gd", "_resolve", "raw *= maxf(1.0 - 0.01 * iw_pct, 0.1)"],
	["talent:tn_break_refuel", "45 Rage", "scripts/battle.gd", "_resolve", "var nq_gain := 45 * attacker.no_quarter_ranks"],
	["card:Summon Ursus:desc", "for 2 turns", "scripts/battle.gd", "_arrival_for_kind", "_apply_status(body, \"roar\", 2)"],
	["card:Summon Canis:desc", "15 Bleed", "scripts/battle.gd", "_arrival_for_kind", "30 if e in bloodiest else 15"],
	["card:Summon Canis:desc", "+15% damage", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.15 * bm_canis * bm_wounded"],
	["card:Summon Canis:desc", "20 Bleed", "scripts/battle.gd", "_companion_strike", "var wolf_bleed := (20 + 2 * l"],
	["card:Summon Canis:desc", "25% more", "scripts/battle.gd", "_miss_chance", "chance += 0.25"],
	["card:Summon Canis:desc", "for 20% of", "scripts/battle.gd", "_companion_strike", "_companion_hit(comp, victim, 0.20 * comp.attack * dmg_mult, 0)"],
	["card:Summon Aguila:desc", "+10% crit", "scripts/battle.gd", "_party_crit_bonus", "0.10 * _bond_mult(h, \"aguila\")"],
	["card:Summon Aguila:desc", "15% of your Attack", "scripts/battle.gd", "_arrival_for_kind", "_companion_hit(body, d, 0.15 * hunter.attack, 0)"],
	["card:Summon Aguila:desc", "25% more", "scripts/battle.gd", "_miss_chance", "chance += 0.25"],
	["card:Summon Aguila:desc", "for 20% of", "scripts/battle.gd", "_companion_strike", "_companion_hit(comp, victim, 0.20 * comp.attack * dmg_mult, 0,"],
	["card:Hunter's Instinct:desc", "next 3", "scripts/battle.gd", "_resolve_special", "attacker.instinctive if attacker.instinctive > 0 else 3"],
	["card:Hunter's Instinct:desc", "+10% of", "scripts/battle.gd", "_resolve", "raw += 0.10 * attacker.attack"],
	["card:Hunter's Instinct:desc", "15% of", "scripts/battle.gd", "_resolve", "hi_b.heal_amount(int(hi_b.max_hp * 0.15))"],
	["card:Kill Command:desc", "3 bites", "scripts/battle.gd", "_resolve_special", "for _bite in 3:"],
	["card:Kill Command:desc", "3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(kc_t, \"blind\", 3,"],
	["card:Kill Command:desc", "10 Bleed", "scripts/battle.gd", "_resolve_special", "var kc_bleed := 10 + 2 * kc_l"],
	["card:Kill Command:desc", "25% Attack", "scripts/battle.gd", "_resolve_special", "0.25 * comp.attack * kc_mult"],
	["card:Kill Command:desc", "30% of", "scripts/battle.gd", "_resolve_special", "int(comp.max_hp * 0.30)"],
	["card:Kill Command:desc", "45% of", "scripts/battle.gd", "_resolve_special", "0.45 * comp.attack * kc_mult"],
	["card:Kill Command:desc", "18% Attack", "scripts/battle.gd", "_resolve_special", "0.18 * comp.attack * kc_mult"],
	["card:Kill Command:desc", "40 Break", "scripts/battle.gd", "_resolve_special", "0.45 * comp.attack * kc_mult, 40"],
	["card:Bestial Wrath:desc", "taunts 3", "scripts/battle.gd", "_resolve_special", "if bw_taunted >= 3:"],
	["card:Bestial Wrath:desc", "+50%\\narmor", "scripts/battle.gd", "_resolve_special", "bw_comp.armor * 0.5"],
	["card:Bestial Wrath:desc", "+25%\\ndamage", "scripts/battle.gd", "_bestial_dmg_mult", "return 1.25"],
	["card:Bestial Wrath:desc", "+50% damage", "scripts/battle.gd", "_bestial_dmg_mult", "return 1.5"],
	["card:Spirit Bond:desc", "2 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"spirit_mana\", 2,"],
	["card:Spirit Bond:desc", "15% max", "scripts/battle.gd", "_resolve_special", "0.15 + 0.01 * attacker.deep_reserves_ranks"],
	["card:Spirit Bond:perfect", "for 5 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(sb_u, \"vigor\", 5)"],
	["card:Spirit Bond:perfect", "+10% max", "scripts/battle.gd", "_resolve_special", "int(sb_u.max_hp * 0.10)"],
	["card:Primal Surge:desc", "+10%\\ndamage", "scripts/battle.gd", "_resolve", "raw *= 1.10"],
	["card:Primal Surge:desc", "15% of", "scripts/battle.gd", "_resolve_special", "0.15 * ps_l * attacker.attack"],
	["card:Call of the Wild:desc", "for 15%", "scripts/battle.gd", "_resolve_special", "0.15 * attacker.attack)"],
	["card:Mark of the Hunt:desc", "for 7 turns", "scripts/battle.gd", "_resolve_special", "var mk_turns := 7"],
	["card:Aimed Shot:perfect", "+20 Focus", "scripts/battle.gd", "_apply_perfect_bonus", "_gain_focus(attacker, 20)"],
	["card:Hold Breath:desc", "next attack", "scripts/battle.gd", "_resolve_special", "attacker.second_nature if attacker.second_nature > 0 else 1"],
	["card:Hold Breath:desc", "+40 Focus", "scripts/battle.gd", "_resolve_special", "_gain_focus(attacker, 40)"],
	["card:Quick Draw:desc", "for 6 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"quickdraw\", 6)"],
	["card:Quick Draw:desc", "50% faster", "scripts/unit.gd", "effective_speed", "s *= 1.5"],
	["card:Coup de Grâce:desc", "1% of", "scripts/battle.gd", "_resolve", "(strike_target.max_hp - strike_target.hp) * 0.01 * cdg"],
	["card:Pinning Shot:desc", "for 3 turns", "scripts/battle.gd", "_resolve", "_apply_status(target, \"dazed\", 3, 0, 0, attacker)"],
	["card:Called Shot:desc", "3 turns", "scripts/battle.gd", "_resolve", "_apply_status(target, \"exposed\", 3, 0, 0, attacker)"],
	["card:Called Shot:desc", "2 turns", "scripts/battle.gd", "_resolve", "_apply_status(target, \"sunder\", 2, 0, 0, attacker)"],
	["card:Called Shot:desc", "30 BD", "scripts/battle.gd", "_resolve", "target.take_hit(0, 30)"],
	["card:Quarry's Mark:desc", "20 Focus", "scripts/battle.gd", "_resolve_special", "_gain_focus(attacker, 20)"],
	["card:Reacquire:desc", "25 Focus", "scripts/battle.gd", "_resolve_special", "_gain_focus(attacker, 25)"],
	["card:Tripwire:desc", "for 6 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"tripwire\", 6)"],
	["card:Shrapnel Charge:desc", "for 3 turns", "scripts/battle.gd", "_resolve", "var sv_turns := 4 if is_perfect else 3"],
	["card:Explosive Shot:perfect", "{atk:12}", "scripts/battle.gd", "_resolve", "raw = 0.12 * attacker.attack"],
	["card:Venom Coating:desc", "for 4 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"venom_coat\", 4)"],
	["card:Hamstring:desc", "for\\n3 turns", "scripts/battle.gd", "_resolve", "var sv_turns := 4 if is_perfect else 3"],
	["card:Harvest:desc", "12% of", "scripts/battle.gd", "_resolve_special", "var hv_pct := 0.12 + HARVEST_ALLY_BONUS"],
	["card:Harvest:perfect", "150%", "scripts/battle.gd", "_resolve_special", "(1.5 if is_perfect else 1.0)"],
	["card:Choking Smoke:desc", "Burning 2 turns", "scripts/battle.gd", "_resolve_special", "var cs_burn := 2"],
	["glossary:initiative:long", "a quarter at one stack", "scripts/unit.gd", "effective_speed", "maxf(0.75 - frigid_bonus"],
	["glossary:initiative:long", "Slowed cuts speed a quarter", "scripts/unit.gd", "effective_speed", "(0.75 if has_status(\"slow\") else 1.0)"],
	["glossary:initiative:long", "a half at two or more", "scripts/unit.gd", "effective_speed", "maxf(0.5 - frigid_bonus * chill"],
	["glossary:pressure_break:long", "crits deal 1.5x BD", "scripts/battle.gd", "_resolve", "ab.pressure * pr_mult * (1.5 if is_crit else 1.0)"],
	["glossary:pressure_break:long", "dropping 30% of its armor", "scripts/unit.gd", "effective_armor", "a *= 0.7"],
	["glossary:pressure_break:long", "+25% crit chance against it", "scripts/battle.gd", "_resolve", "(0.25 if strike_target.broken else 0.0)"],
	["glossary:crit:short", "1.5x Break damage", "scripts/battle.gd", "_resolve", "ab.pressure * pr_mult * (1.5 if is_crit else 1.0)"],
	["glossary:crit:short", "1.5x damage", "scripts/battle.gd", "_resolve", "var crit_mult := 1.5"],
	["glossary:crit:long", "bond shares +10%", "scripts/battle.gd", "_party_crit_bonus", "0.10 * _bond_mult(h, \"aguila\")"],
	["glossary:crit:long", "a flat +1% each", "scripts/battle.gd", "_resolve", "(0.01 + 0.01 * attacker.arcane_mastery_ranks)"],
	["glossary:miss:long", "Dazed adds +20%", "scripts/battle.gd", "_miss_chance", "(0.20 if attacker.has_status(\"dazed\")"],
	["glossary:miss:long", "Elusive target adds +25%", "scripts/battle.gd", "_miss_chance", "chance += 0.25"],
	["glossary:parry:short", "at a quarter strength", "scripts/battle.gd", "_resolve", "raw *= 0.0 if wall_parry else 0.25"],
	["glossary:parry:long", "and 25% Break damage", "scripts/battle.gd", "_resolve", "int(round(pr * 0.25))"],
	["glossary:parry:long", "lands at 25% damage", "scripts/battle.gd", "_resolve", "raw *= 0.0 if wall_parry else 0.25"],
	["glossary:stance:long", "+10% damage taken", "scripts/battle.gd", "_resolve", "raw *= 1.0 + 0.10 * (2.0 if strike_target.rune_naked_blade"],
	["glossary:stance:long", "-10% damage dealt", "scripts/battle.gd", "_resolve", "raw *= 1.0 - 0.10 * (2.0 if attacker.rune_naked_blade"],
	["glossary:stance:long", "15% less damage taken", "scripts/battle.gd", "_resolve", "var sf_def := 0.15 *"],
	["glossary:fallen:long", "at full health when Empowered", "scripts/battle.gd", "_resolve_special", "rez_frac = 1.0"],
	["glossary:fallen:long", "at least 20% of their max HP", "scripts/unit.gd", "sync_victory_state", "int(save_max * 0.2)"],
	["glossary:fallen:long", "back at 50% HP", "scripts/battle.gd", "_use_item", "target.revive(0.5)"],
	["glossary:fallen:long", "Resurrection at 25%", "scripts/battle.gd", "_resolve_special", "var rez_frac := 0.25"],
	["glossary:hero_vs_ally:long", "sheds the 30", "scripts/battle.gd", "_resolve_special", "var pressure_cut := 30"],
	["glossary:status_broken:short", "+25% crit chance against this unit", "scripts/battle.gd", "_resolve", "(0.25 if strike_target.broken else 0.0)"],
	["glossary:status_broken:short", "-30% armor", "scripts/unit.gd", "effective_armor", "a *= 0.7"],
	["glossary:status_broken:long", "crits it +25% more often", "scripts/battle.gd", "_resolve", "(0.25 if strike_target.broken else 0.0)"],
	["glossary:status_broken:long", "resets to zero", "scripts/unit.gd", "recover_from_break", "pressure = 0"],
	["glossary:status_broken:long", "armor drops by 30%", "scripts/unit.gd", "effective_armor", "a *= 0.7"],
	["glossary:status_slow:short", "-25% speed", "scripts/unit.gd", "effective_speed", "(0.75 if has_status(\"slow\") else 1.0)"],
	["glossary:status_slow:long", "cuts speed by 25%", "scripts/unit.gd", "effective_speed", "(0.75 if has_status(\"slow\") else 1.0)"],
	["glossary:status_chilled:short", "slower at one stack", "scripts/unit.gd", "effective_speed", "if chill == 1:"],
	["glossary:status_chilled:short", "slower again at two", "scripts/unit.gd", "effective_speed", "elif chill >= 2:"],
	["glossary:status_chilled:long", "one stack is -25% speed", "scripts/unit.gd", "effective_speed", "maxf(0.75 - frigid_bonus"],
	["glossary:status_chilled:long", "two is -50%", "scripts/unit.gd", "effective_speed", "maxf(0.5 - frigid_bonus * chill"],
	["glossary:status_chilled:long", "three also cuts", "scripts/battle.gd", "_resolve", "if atk_chill >= 3:"],
	["glossary:glacial_hold:long", "He holds ONE enemy", "scripts/battle.gd", "_hold_limit", "var hl := 1"],
	["glossary:status_frostbite:short", "reduced by 50%", "scripts/unit.gd", "heal_amount", "mult *= 0.5"],
	["glossary:status_frostbite:long", "is halved", "scripts/unit.gd", "heal_amount", "mult *= 0.5"],
	["glossary:status_bleed:short", "at 100 the target", "scripts/unit.gd", "add_bleed", "var bled := bleed_buildup >= 100"],
	["glossary:status_bleed:short", "for 20% max HP", "scripts/battle.gd", "_add_bleed_with_burst", "(0.15 if pact < 0 else 0.20)"],
	["glossary:status_bleed:long", "buildup (0-100)", "scripts/unit.gd", "add_bleed", "mini(bleed_buildup + amount, 100)"],
	["glossary:status_bleed:long", "immediate 20% of its max HP", "scripts/battle.gd", "_add_bleed_with_burst", "(0.15 if pact < 0 else 0.20)"],
	["glossary:status_hexed:short", "for the rest of the battle", "scripts/battle.gd", "_use_item", "_apply_status(vs_e, \"hexed\", -1)"],
	["glossary:status_hexed:long", "it never fades", "scripts/battle.gd", "_use_item", "_apply_status(vs_e, \"hexed\", -1)"],
	["glossary:status_dazed:short", "20% more likely to miss", "scripts/battle.gd", "_miss_chance", "(0.20 if attacker.has_status(\"dazed\")"],
	["glossary:status_dazed:long", "miss an extra 20%", "scripts/battle.gd", "_miss_chance", "(0.20 if attacker.has_status(\"dazed\")"],
	["glossary:status_psychosis:short", "50% each turn", "scripts/battle.gd", "_enemy_turn", "if randf() < 0.5:"],
	["glossary:status_psychosis:long", "there is a 50% chance", "scripts/battle.gd", "_enemy_turn", "if randf() < 0.5:"],
	["glossary:status_ruin:short", "it does not wear off", "scripts/battle.gd", "_gain_ruin", "_apply_status(target, \"ruin\", -1, 0, 0, occ)"],
	["glossary:status_ruin:short", "+2% damage taken per stack", "scripts/battle.gd", "_resolve", "0.01 * (2 + ruin_occ.deep_hex_step"],
	["glossary:status_ruin:long", "it DOES NOT WEAR OFF", "scripts/battle.gd", "_gain_ruin", "_apply_status(target, \"ruin\", -1, 0, 0, occ)"],
	["glossary:status_ruin:long", "2% of the damage dealt per stack", "scripts/battle.gd", "_resolve", "* (2 + occ_leech.soul_leech_step"],
	["glossary:status_ruin:long", "Each stack is +2% damage taken", "scripts/battle.gd", "_resolve", "0.01 * (2 + ruin_occ.deep_hex_step"],
	["glossary:status_ruin:long", "wears it down a stack a turn", "scripts/battle.gd", "_run_battle", "u.set_ruin_stacks(ow_was - 1)"],
	["glossary:status_hysteria:short", "double Break damage", "scripts/battle.gd", "_enemy_turn", "\"pressure\": hys_basic.pressure * 2"],
	["glossary:status_hysteria:long", "DOUBLE Break damage", "scripts/battle.gd", "_enemy_turn", "\"pressure\": hys_basic.pressure * 2"],
	["glossary:status_umbral_sigil:short", "half of most strikes", "scripts/battle.gd", "_umbral_sigil_echo", "landed * 0.5"],
	["glossary:status_umbral_sigil:long", "half the damage", "scripts/battle.gd", "_umbral_sigil_echo", "landed * 0.5"],
	["glossary:status_quickdraw:short", "act 50% faster", "scripts/unit.gd", "effective_speed", "s *= 1.5"],
	["glossary:status_quickdraw:long", "for several turns", "scripts/battle.gd", "_resolve_special", "_apply_status(attacker, \"quickdraw\", 6)"],
	["glossary:status_quickdraw:long", "bearer by 50%", "scripts/unit.gd", "effective_speed", "s *= 1.5"],
	["glossary:resists_vulns:long", "at least 1 damage", "scripts/battle.gd", "_resolve", "maxi(int(round(raw * (1.0 - effective_armor))), 1)"],
	["glossary:resists_vulns:long", "never beyond 85%", "scripts/unit.gd", "effective_armor", "return minf(a, 0.85)"],
	["glossary:res_rage:long", "+10 every time", "scripts/unit.gd", "take_hit", "resource = mini(resource + 10, max_resource)"],
	["glossary:res_rage:long", "+5 at each turn start", "scripts/battle.gd", "_player_turn", "u.resource = mini(u.resource + 5, u.max_resource)"],
	["glossary:res_mana:short", "regenerates slowly", "scripts/battle.gd", "_mana_regen", "var regen := 12 + u.mana_regen_bonus"],
	["glossary:res_mana:long", "+12 at each turn start", "scripts/battle.gd", "_mana_regen", "var regen := 12 + u.mana_regen_bonus"],
	["glossary:res_mana:long", "Evocation nearly doubles that", "scripts/battle.gd", "_spawn_units", "cfg[\"mana_regen_bonus\"] = 10"],
	["glossary:res_resonance:short", "no practical cap", "scripts/battle.gd", "_spawn_units", "cfg[\"second_max\"] = 99"],
	["glossary:res_resonance:long", "2 on a crit", "scripts/battle.gd", "_resolve", "var res_gain := (2 + attacker.rune_overflow"],
	["glossary:res_resonance:long", "everything above 2", "scripts/battle.gd", "_resolve_special", "var st_floor := 2 + attacker.still_mind_ranks"],
	["glossary:res_resonance:long", "a flat +1% crit chance per stack", "scripts/battle.gd", "_resolve", "(0.01 + 0.01 * attacker.arcane_mastery_ranks)"],
	["glossary:res_resonance:long", "the meter stops at 99", "scripts/battle.gd", "_spawn_units", "cfg[\"second_max\"] = 99"],
	["glossary:res_mercy:long", "adds +5% to her healing", "scripts/battle.gd", "_healing_done_mult", "0.01 * (5 + caster.heavenly_step)"],
	["glossary:res_mercy:long", "(cap 5)", "scripts/battle.gd", "_spawn_units", "cfg[\"second_max\"] = 5 + int(cfg.get(\"mercy_cap_bonus\", 0))"],
	["glossary:mercy_window:long", "she holds at most 5", "scripts/battle.gd", "_spawn_units", "cfg[\"second_max\"] = 5 + int(cfg.get(\"mercy_cap_bonus\", 0))"],
	["glossary:res_empower:short", "Spend a Mercy stack", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["glossary:res_empower:long", "at FULL health", "scripts/battle.gd", "_resolve_special", "rez_frac = 1.0"],
	["glossary:res_empower:long", "spending 1 Mercy", "scripts/battle.gd", "_consume_empower", "attacker.second_resource -= 1"],
	["glossary:res_focus:long", "banks up to 50", "scripts/battle.gd", "_sharpshooter_focus", "attacker.second_resource = mini(attacker.second_resource, 50)"],
	["glossary:res_focus:long", "builds +20 Focus", "scripts/battle.gd", "_sharpshooter_focus", "var gain := 20 + attacker.muscle_memory_ranks"],
	["glossary:pack_bond:long", "ONE COMPANION AT A TIME", "scripts/battle.gd", "_beast_cap", "the_pack > 0 else 1"],
	["glossary:overburn:long", "Detonation pays 250%", "scripts/battle.gd", "_resolve", "(2.5 + 0.75 * attacker.focused_flame)"],
	["glossary:overburn:long", "hands him back 1 Mana", "scripts/battle.gd", "_overburn_refund", "var rate := 2 if u.crucible > 0 else 1"],
	["glossary:res_loyalty:long", "+5% companion strike damage", "scripts/battle.gd", "_comp_dmg_mult", "var step := 0.05 + 0.01"],
	["glossary:talent_points:long", "You earn 1 PER CLASS", "scripts/profile.gd", "award_zone_boss_points", "int(purse.get(cls, 0)) + 1"],
	["glossary:ability_upgrades:long", "one more target", "scripts/run_state.gd", "_stamp_upgrade", "ab.random_hits += 1"],
	["glossary:ability_upgrades:long", "one more hit", "scripts/run_state.gd", "_stamp_upgrade", "ab.multi_hits += 1"],
	["glossary:ability_upgrades:long", "HONED (+50% damage)", "scripts/run_state.gd", "_stamp_upgrade", "ab.damage * 1.5"],
	["glossary:ability_upgrades:long", "ignores half the target's armor", "scripts/run_state.gd", "_stamp_upgrade", "ab.armor_pierce + 0.5"],
	["glossary:ability_upgrades:long", "-2 turns of cooldown, minimum 0", "scripts/run_state.gd", "_stamp_upgrade", "maxi(ab.cooldown - 2, 0)"],
	["glossary:ability_upgrades:long", "arrives 25% sooner", "scripts/run_state.gd", "_stamp_upgrade", "ab.delay * 0.75"],
	["glossary:ability_upgrades:long", "Break damage doubled", "scripts/run_state.gd", "_stamp_upgrade", "ab.pressure *= 2"],
	["glossary:node_scaling:long", "+2% of their base Attack and HP", "scripts/battle.gd", "_spawn_units", "(1.0 + 0.02 * Run.combat_wins)"],
	["glossary:node_scaling:long", "+2% of their base Attack and HP", "scripts/battle.gd", "_spawn_units", "base_hp * 0.02 * Run.combat_wins"],
	["glossary:node_scaling:long", "+2.5% HP per slot", "scripts/battle.gd", "_spawn_units", "(1.0 + 0.025 * zone_tier)"],
	["glossary:node_scaling:long", "roughly +2% Attack", "scripts/battle.gd", "_spawn_units", "(1.0 + 0.02 * zone_tier)"],
	["glossary:runes:long", "carries three slots", "scripts/run_state.gd", "rune_slots", "return 3"],
	["glossary:runes:long", "a cache of three", "scripts/run_state.gd", "roll_rune_candidates", "while out.size() < 3:"],
	["glossary:runes:long", "dealt three of the class's core runes", "scripts/run_state.gd", "deal_engines", "dealt = pool.slice(0, 3)"],
	["glossary:relics_vs_runes:long", "choose up to 3 unlocked relics", "scripts/draft_screen.gd", "_toggle_relic", "relic_picks.size() < 3"],
	["glossary:consumables:long", "enemy for the rest of the battle", "scripts/battle.gd", "_use_item", "_apply_status(vs_e, \"hexed\", -1)"],
	["glossary:consumables:long", "armor for 3 turns", "scripts/battle.gd", "_use_item", "_apply_status(h, \"fortify\", 3)"],
	["glossary:consumables:long", "+10% armor", "scripts/unit.gd", "effective_armor", "a += 0.10"],
	["glossary:consumables:long", "fallen hero at 50% health", "scripts/battle.gd", "_use_item", "target.revive(0.5)"],
	["glossary:elites:long", "picks from up to three runes", "scripts/run_state.gd", "roll_rune_candidates", "while out.size() < 3:"],
	["glossary:elites:long", "80-100 gold", "scripts/run_state.gd", "award_gold", "randi_range(80, 100)"],
	["glossary:blacksmith:long", "Three pairings on the counter", "scripts/run_state.gd", "roll_blacksmith_offer", "if offer.size() == 3:"],
	# BATCH IM §1 RE-POINTED THIS ROW: the three are dealt by the gamble loop's own stop now, the fallback gone.
	["glossary:bargain:short", "Three offers", "scripts/run_state.gd", "roll_offer", "if picked.size() >= 3:"],
	# BATCH IM §1 RE-POINTED THIS ROW: the three are dealt by the gamble loop's own stop now, the fallback gone.
	["glossary:bargain:long", "offers three bargains", "scripts/run_state.gd", "roll_offer", "if picked.size() >= 3:"],
	["glossary:modifier:long", "deals 25% more damage", "scripts/battle.gd", "_stamp_modifier", "u.attack = int(round(u.attack * 1.25))"],
	["glossary:end_boss:long", "a talent point apiece", "scripts/profile.gd", "award_zone_boss_points", "int(purse.get(cls, 0)) + 1"],
	["glossary:pouch_slots:long", "for the whole fight", "scripts/battle.gd", "_use_item", "_apply_status(vs_e, \"hexed\", -1)"],
	["glossary:ability_draft:short", "offered three at a time", "scripts/run_state.gd", "roll_draft_offer", "return left.slice(0, 3)"],
	["glossary:frenzy_floor:long", "+2% damage for every", "scripts/unit.gd", "frenzy_bonus", "(2.0 + bloodrage_step_bonus"],
	["glossary:frenzy_floor:long", "every 5% of maximum health", "scripts/unit.gd", "frenzy_bonus", "* 100.0 / 5.0)"],
	["glossary:plating_climb:long", "a flat 15% Block chance", "scripts/battle.gd", "_plating_slice", "(0.15 + u.plating_bonus)"],
	["glossary:plating_climb:long", "another 8% every time", "scripts/battle.gd", "_resolve", "var wd_climb := 0.08"],
	["glossary:recast_refused:long", "better than a third", "scripts/battle.gd", "_resolve_special", "var ds_pct := 0.35 + 0.01 * attacker.stalwart_step"],
	["lit:data/enemies.json", "for 25% of their max HP", "scripts/battle.gd", "_resolve_special", "var wave_heal := maxi(int(round(target.max_hp * 0.25)), 1)"],
	["lit:data/enemies.json", "heals 25% of max health", "scripts/battle.gd", "_resolve_special", "var wave_heal := maxi(int(round(target.max_hp * 0.25)), 1)"],
	# BATCH IK §5 — the two wards name the strike; the figure and its code are unmoved.
	["lit:data/enemies.json", "Wards one of its warband: 25% less strike damage taken for 3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"shielded\", 3)"],
	["lit:data/enemies.json", "The Crown wards itself: 25% less strike damage taken for 3 turns", "scripts/battle.gd", "_resolve_special", "_apply_status(target, \"shielded\", 3)"],
	["lit:data/enemies.json", "for 20% of their max health", "scripts/battle.gd", "_resolve_special", "var growth := maxi(int(round(target.max_hp * 0.20)), 1)"],
	["lit:data/enemies.json", "It lands next turn", "scripts/battle.gd", "_resolve_special", "\"ability\": ab, \"target\": null, \"turns\": 1, \"support\": false"],
	["lit:data/enemies.json", "regains 6% of their maximum health", "scripts/battle.gd", "_resolve_special", "var tp_amt := maxi(int(round(tp_a.max_hp * 0.06)), 1)"],
	["upgrade:up_damage", "+50% damage", "scripts/run_state.gd", "_stamp_upgrade", "ab.damage * 1.5"],
	["upgrade:up_cooldown", "-2 turns cooldown (minimum 0)", "scripts/run_state.gd", "_stamp_upgrade", "maxi(ab.cooldown - 2, 0)"],
	["upgrade:up_speed", "Arrives 25% sooner", "scripts/run_state.gd", "_stamp_upgrade", "ab.delay * 0.75"],
	["upgrade:up_break", "Break damage doubled", "scripts/run_state.gd", "_stamp_upgrade", "ab.pressure *= 2"],
	["upgrade:up_wide", "Strikes one additional target", "scripts/run_state.gd", "_stamp_upgrade", "ab.random_hits += 1"],
	["upgrade:up_wide", "lands one additional hit", "scripts/run_state.gd", "_stamp_upgrade", "ab.multi_hits += 1"],
	["upgrade:up_pierce", "Ignores half the target's armor", "scripts/run_state.gd", "_stamp_upgrade", "ab.armor_pierce + 0.5"],
]



# ── §4 — THE RULES, WHERE EACH LIVES ────────────────────────────────────────
# Needles are the rules' own words, never the batch code beside them (EA §2).
const FIGURE_RULE := "A FIGURE THE CODE HOLDS IS READ, NEVER RETYPED"
const SWEEP_ROW := "| PLAYER-FACING TEXT THAT STATES A NUMBER READS IT OFF THE CONSTANT, OR AN INSTRUMENT ASSERTS THE TWO AGREE |"


func _s4_rules() -> void:
	print("\n§4 — the figure rule names every door the resolver is read at; II §0.7's rule stands built, its row current")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(cm.count(FIGURE_RULE) == 1 and not ir.contains(FIGURE_RULE),
		"§4: the figure rule does not stand once in CLAUDE.md's text standard, and nowhere in the instrument rules")
	var bullet := ""
	var at := cm.find(FIGURE_RULE)
	if at >= 0:
		var end := cm.find("\n  · ", at)
		bullet = _norm(cm.substr(at, end - at if end > at else 1500))
	# THE DOORS, DERIVED: every function of a game script whose comment-stripped source calls the resolver.
	var fn_rx := RegEx.new()
	fn_rx.compile("(?m)^(?:static\\s+)?func\\s+(\\w+)\\s*\\(")
	var doors: Array = []
	var d := DirAccess.open("res://scripts")
	for f in (d.get_files() if d != null else PackedStringArray()):
		if not f.ends_with(".gd"):
			continue
		var path := "scripts/" + f
		if not _src(path).contains("resolve_figures("):
			continue
		for m in fn_rx.search_all(_src(path)):
			var fn := m.get_string(1)
			if fn != "resolve_figures" and _body(path, fn).contains("resolve_figures("):
				doors.append("%s.%s" % [f.get_basename().capitalize().replace(" ", ""), fn])
	for door in doors:
		ok(bullet.contains("`%s`" % door), "§4: the resolver is read in `%s` and the figure rule does not name that door" % door)
	ok(doors.size() >= 6, "§4: only %d doors call the resolver — IJ read six" % doors.size())
	ok(cm.count(SWEEP_ROW) == 1, "§4: II §0.7's rule has no row in CLAUDE.md's instrument index, once")
	print("    %d doors, each named in the rule: %s" % [doors.size(), ", ".join(PackedStringArray(doors))])


# ── §9 — THE PLAYER's FILES ─────────────────────────────────────────────────
func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
