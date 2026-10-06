# BATCH HT — TWO RULINGS, AND THE CENSUS THAT OPENS THE REST OF THE LADDER.
#
# What this gate asserts, section by section (`docs/reports/HT.md` has the working):
#
#   §1  THE RITE READS `chilled`, SO IT READS THE CHILL INSIDE (HS ruling 4, ruled): an
#       enemy mender's Cleansing Rite takes one stack off a bare chill and never the pile,
#       and the same off the chill INSIDE a Rupture — the Rupture stands; at the chill's
#       last stack the chill goes as a bare one's does and the Burn stands alone; a Glacial
#       Hold chill inside one is still the rite's first pick. THE NEGATIVE, paired: a
#       generic cleanse still takes a Rupture whole (HS §2f, unchanged).
#   §2  ON SCREEN A TIER IS A DEGREE (HS ruling 6, ruled): the chip, the forming line, both
#       glossary entries and `master.html`'s conjunction rows say *degree* and never *tier*;
#       every string literal of the composition machinery is swept for the old word (BX §4b's
#       shape); and the IDENTIFIERS ARE UNMOVED — `tier_of` stands, and no code token names a
#       degree.
#   §3  `master.html` STATES WHAT THE GAME IS: the seven fire-and-ice sentences HR §4h found,
#       each held to the code fact that makes the corrected sentence true, and the copies the
#       sweep found off the document (the glossary's Overburn, the Glacial Hold rule text).
#       The designed conjunctions stay unbuilt: `CONJUNCTIONS` keeps its one row.
#   §4  THE CENSUS'S TWO STRUCTURAL FACTS, driven rather than read: BROKEN is a meter state
#       with a chip — an entry written around the status door, with no clock and no `src`,
#       ended only by the recovery — and a WARRIOR HOLDING NO ENGINE lays statuses on an
#       enemy from his own kit.
#   §5  The record beside the code: Rupture's watch condition sits on its constant.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether a second-degree
# figure is right, and which conjunction comes next — both are the designer's. `Run` is
# fetched off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
# A Swordmaster, a Pyromancer, a Holy and a Survivalist — no hero here chills or burns on
# his own, so every Burn and Chilled below is one this gate laid.
const PARTY := ["swordmaster", "pyromancer", "holy", "mystic"]
const SCRATCH_PROFILE := "user://ht_profile.json"
const SCRATCH_RELICS := "user://ht_relics.json"
# The composition machinery's own words: a function whose body (comments stripped, its
# literals kept — a composition's key IS a literal) names one of these is a function that
# writes what a conjunction says, and §2 sweeps its literals. `BattleUnit.tier_of(`, never
# a bare `tier_of(`: `Talents.tier_of(` is the talent tree's tier, a different word on screen.
const COMPOSITION_MARKS := ["\"parts\"", "composition_of(", "BattleUnit.tier_of(", "TICK_BREAK", "CONJUNCTIONS",
	"_dissolve(", "tier_ordinal(", "_rite_chill(", "bases_of(", "composition_turns("]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HT — TWO RULINGS, AND THE CENSUS THAT OPENS THE REST OF THE LADDER")
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
	await _s1_the_rite()
	await _s2_degree()
	_s3_the_document()
	await _s4_the_census_facts()
	_s5_the_record()
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


func _board(specs: Array = PARTY, opts: Dictionary = {}) -> Node:
	var o := {"deterministic": true}
	o.merge(opts, true)
	var scene: Node = await Gate.spawn(self, specs, o)
	return scene


func _hero(scene: Node, spec_name: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if String((h as BattleUnit).unit_name).to_lower() == spec_name.to_lower():
			return h
	return null


# The top-level ids standing on a body, in order — one per chip.
func _ids(u: BattleUnit) -> Array:
	var out: Array = []
	for s in u.statuses:
		out.append(String(s.id))
	return out


func _clear(u: BattleUnit) -> void:
	u.statuses = []
	u._refresh_chips()


func _burn(scene: Node, target: BattleUnit, src: BattleUnit, turns: int) -> void:
	scene.call("_apply_status", target, "burn", turns, 0, scene.call("_dot_tick", "burn", src), src)


func _chill(scene: Node, target: BattleUnit, src: BattleUnit, turns: int) -> void:
	scene.call("_apply_status", target, "chilled", turns, 0, 0, src)


func _log_text(scene: Node) -> String:
	return String((scene.get("history") as RichTextLabel).get_parsed_text())


# The enemy mender's rite, built off the data as the warband's own is — never a copy.
func _the_rite() -> Ability:
	for ab in Enemies.config("chanter").get("abilities", []):
		if (ab as Ability).special == "cleanse_allies":
			return ab
	return null


# One cast of the rite by `caster` (an enemy), its side the enemies; what it said.
func _cast_rite(scene: Node, caster: BattleUnit, rite: Ability) -> String:
	var from := _log_text(scene).length()
	await scene.call("_resolve", caster, rite, caster, "good")
	return _log_text(scene).substr(from)


# Every string literal on a line, quotes of both kinds masked in order — the content
# between a quote and its partner. A comment is stripped before this is asked.
func _literals(line: String) -> Array:
	var out: Array = []
	var quote := ""
	var cur := ""
	var i := 0
	while i < line.length():
		var c := line[i]
		if quote != "":
			if c == "\\":
				cur += line.substr(i, 2)
				i += 2
				continue
			if c == quote:
				out.append(cur)
				cur = ""
				quote = ""
			else:
				cur += c
		elif c == "\"" or c == "'":
			quote = c
		i += 1
	return out


# The line with every string literal's content removed — what the CODE says.
func _code_only(line: String) -> String:
	var out := ""
	var quote := ""
	var i := 0
	while i < line.length():
		var c := line[i]
		if quote != "":
			if c == "\\":
				i += 2
				continue
			if c == quote:
				quote = ""
			i += 1
			continue
		if c == "\"" or c == "'":
			quote = c
		else:
			out += c
		i += 1
	return out


# Every function body in a file, comments stripped: [[name, body], …].
func _bodies(path: String) -> Array:
	var src := Gate.strip_comments(FileAccess.get_file_as_string(path))
	var out: Array = []
	var name := ""
	var body := ""
	for raw in src.split("\n"):
		var line := String(raw)
		if line.begins_with("func ") or line.begins_with("static func "):
			if name != "":
				out.append([name, body])
			name = line.get_slice("(", 0).replace("static func ", "").replace("func ", "").strip_edges()
			body = ""
		if name != "":
			body += line + "\n"
	if name != "":
		out.append([name, body])
	return out


func _says_tier(text: String) -> bool:
	return RegEx.create_from_string("(?i)\\btiers?\\b").search(text) != null


# ── §1 — THE RITE AT THE CHILL DOOR ──────────────────────────────────────────

func _s1_the_rite() -> void:
	print("\n§1 — the rite reads the chill inside a Rupture: one stack, never the pile, never the Rupture")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	var a: BattleUnit = foes[0]
	var chanter: BattleUnit = foes[2]
	var rite := _the_rite()
	ok(rite != null, "§1: the Ritual Chanter's rite is not in the data — nothing to drive")
	if rite == null:
		scene.queue_free()
		await process_frame
		return
	var lname := String(scene.STATUS_INFO["rupture"][0])
	for f in foes:
		_clear(f)
	# A BARE CHILL, Batch V's rule as it always stood: one stack off, never the pile.
	_chill(scene, a, sv, 3)
	_chill(scene, a, sv, 3)
	var said := await _cast_rite(scene, chanter, rite)
	ok(_ids(a) == ["chilled"] and a.status_stacks("chilled") == 1,
		"§1: the rite on a bare chill x2 left %s x%d — want one stack off, never the pile" % [_ids(a), a.status_stacks("chilled")])
	ok(said.contains("Cleansing Rite thaws one stack of Chilled on %s (x1 remains)" % a.unit_name),
		"§1: the rite's thaw on a bare chill went unlogged")
	_clear(a)
	_chill(scene, a, sv, 3)
	await _cast_rite(scene, chanter, rite)
	ok(_ids(a).is_empty(), "§1: the rite on a bare chill x1 left %s — its one stack is the pile, and it goes" % [_ids(a)])
	# A RUPTURE WHOSE CHILL HOLDS TWO: one stack off the chill INSIDE; the Rupture stands,
	# its Burn untouched.
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	_chill(scene, a, sv, 3)
	ok(_ids(a) == ["rupture"] and a.status_stacks("chilled") == 2,
		"§1: the board for the rite's Rupture case did not compose: %s x%d" % [_ids(a), a.status_stacks("chilled")])
	var burn_was := int(a.get_status("burn").get("turns", 0))
	said = await _cast_rite(scene, chanter, rite)
	ok(_ids(a) == ["rupture"] and a.status_stacks("chilled") == 1,
		"§1: the rite on a Rupture left %s x%d — want the Rupture standing, its chill one stack less" % [_ids(a), a.status_stacks("chilled")])
	ok(int(a.get_status("burn").get("turns", -9)) == burn_was,
		"§1: the rite on a Rupture moved its Burn (%d → %d) — it reads the chill and nothing else" % [burn_was, int(a.get_status("burn").get("turns", -9))])
	# ONE ok() A PROPERTY, so each control's FAIL line names its own defect. The negative reads the
	# line the rite prints when it strips a status whole — the Rupture's fate before HT §1.4.
	ok(said.contains("thaws one stack of the Chilled inside %s's %s (x1 remains)" % [a.unit_name, lname]),
		"§1: the rite's thaw inside a Rupture was not logged as a thaw")
	ok(not said.contains("Cleansing Rite strips %s from %s" % [lname, a.unit_name]),
		"§1: the rite logged the Rupture stripped whole")
	# THE CHILL'S LAST STACK INSIDE: it goes as a bare chill's does; the Rupture ends by it
	# and the Burn stands alone with its turns — one ingredient left, one Sanctity event.
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	burn_was = int(a.get_status("burn").get("turns", 0))
	a.battle_turn = int(BattleUnit._sanctity_turn) + 1
	var ev0 := int(BattleUnit.sanctity_events)
	said = await _cast_rite(scene, chanter, rite)
	ok(_ids(a) == ["burn"] and int(a.get_status("burn").get("turns", -9)) == burn_was,
		"§1: the rite on a Rupture's last chill stack left %s — want the Burn standing alone with its %d turns" % [_ids(a), burn_was])
	ok(int(BattleUnit.sanctity_events) - ev0 == 1,
		"§1: the rite taking the chill out of a Rupture booked %d Sanctity events — the one ingredient that left" % (int(BattleUnit.sanctity_events) - ev0))
	ok(said.contains("%s ends on %s — a cleanse: its Chilled is lifted; Burn stands alone" % [lname, a.unit_name]),
		"§1: the end of a Rupture by the rite was not logged as a cleanse taking its Chilled")
	ok(not said.contains("Cleansing Rite strips %s from %s" % [lname, a.unit_name]),
		"§1: at its chill's last stack the rite logged the Rupture stripped whole")
	# A GLACIAL HOLD CHILL INSIDE A RUPTURE IS STILL THE RITE'S FIRST PICK, as it is bare —
	# the rank is the chill's, not the composition's shorter clock.
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, -1)
	_chill(scene, a, sv, -1)
	scene.call("_apply_status", a, "exposed", 4, 0, 0, sv)
	ok(_ids(a) == ["rupture", "exposed"] and int(a.statuses[0].get("turns", 0)) == 3,
		"§1: the rank board did not stand a Rupture on a 3-turn clock beside a 4-turn Exposed: %s" % [_ids(a)])
	await _cast_rite(scene, chanter, rite)
	ok(a.has_status("exposed") and a.status_stacks("chilled") == 1 and _ids(a).has("rupture"),
		"§1: the rite took %s — a permanent chill inside a Rupture must rank first, as it does bare" % [_ids(a)])
	# THE NEGATIVE, PAIRED: a GENERIC cleanse still takes a Rupture whole (HS §2f).
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	_chill(scene, a, sv, 3)
	var lifted := a.dispel_one_debuff()
	ok(lifted == lname and a.statuses.is_empty(),
		"§1: Dispel One took '%s' and left %s — a generic cleanse takes a Rupture whole" % [lifted, _ids(a)])
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	var taken: Array = a.purge_debuffs_taken()
	ok(taken.size() == 1 and String(taken[0].get("id", "")) == "rupture" and a.statuses.is_empty(),
		"§1: the purge handed back %d entries — a generic cleanse takes a Rupture whole" % taken.size())
	scene.queue_free()
	await process_frame


# ── §2 — DEGREE ON SCREEN, TIER IN THE CODE ─────────────────────────────────

func _s2_degree() -> void:
	print("\n§2 — on screen a conjunction's tier is its degree; the identifiers are unmoved")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var a: BattleUnit = scene.get("enemies")[0]
	_clear(a)
	_burn(scene, a, pyro, 3)
	var from := _log_text(scene).length()
	_chill(scene, a, sv, 3)
	var forms := ""
	for ln in _log_text(scene).substr(from).split("\n"):
		if String(ln).contains(" forms on "):
			forms = String(ln).strip_edges()
	var desc := String(a.get_status("rupture").get("desc", ""))
	print("    the chip: %s" % desc.replace("\n", " / "))
	print("    the log:  %s" % forms)
	ok(desc.contains("(second degree)"),
		"§2: the chip's words do not say its degree: %s" % desc.replace("\n", " / "))
	ok(not _says_tier(desc), "§2: the chip's words still say a tier: %s" % desc.replace("\n", " / "))
	var longest := 0
	for ln2 in desc.split("\n"):
		longest = maxi(longest, String(ln2).length())
	ok(longest <= 44, "§2: a line of the chip's words is %d characters — the tooltip does not wrap" % longest)
	ok(forms.contains("lands on its Burn — second degree, 3 turns"),
		"§2: the forming line does not say its degree: %s" % forms)
	ok(not _says_tier(forms), "§2: the forming line still says a tier: %s" % forms)
	ok(BattleUnit.tier_ordinal(1) == "first" and BattleUnit.tier_ordinal(2) == "second"
			and BattleUnit.tier_ordinal(3) == "third",
		"§2: a tier is not rendered as the ordinal the text says it in")
	scene.queue_free()
	await process_frame
	# THE GLOSSARY, both entries: degree, and no tier — and still no digit (HS §3c).
	for gid in ["conjunctions", "status_rupture"]:
		var e: Dictionary = Glossary.entry(gid)
		var txt := String(e.get("short", "")) + " " + String(e.get("long", ""))
		ok(not e.is_empty() and txt.to_lower().contains("degree"),
			"§2: the glossary's %s does not say degree" % gid)
		ok(not _says_tier(txt), "§2: the glossary's %s still says tier" % gid)
	# THE DOCUMENT: the Rupture row and the CONJUNCTIONS block.
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	var row_at := master.find("<tr><td>Rupture</td>")
	var row := master.substr(row_at, master.find("</tr>", row_at) - row_at) if row_at >= 0 else ""
	var blk_at := master.find("<p><b>CONJUNCTIONS")
	var blk := master.substr(blk_at, master.find("<h3>", blk_at) - blk_at) if blk_at >= 0 else ""
	ok(row != "" and row.contains("second-degree"),
		"§2: master.html's Rupture row does not say its degree")
	ok(not _says_tier(row), "§2: master.html's Rupture row still says a tier")
	# The ruling's own words, *Rupture is a second-degree affliction*, wrapped at the article.
	ok(blk != "" and blk.contains("second-degree affliction"),
		"§2: master.html's conjunction block does not say Rupture is a second-degree affliction")
	ok(not _says_tier(blk), "§2: master.html's conjunction block still says tier")
	# EVERY STRING LITERAL OF THE COMPOSITION MACHINERY, swept for the old word (BX §4b's
	# shape: literals only, comments stripped). The population is DERIVED — every function
	# whose code names the machinery — and it is asserted to hold the three that write words.
	var fns := 0
	var lits := 0
	var strays: Array = []
	var named: Array = []
	for path in ["res://scripts/unit.gd", "res://scripts/battle.gd"]:
		for fb in _bodies(path):
			var body := String(fb[1])
			var hit := false
			for mark in COMPOSITION_MARKS:
				if body.contains(String(mark)):
					hit = true
			if not hit:
				continue
			fns += 1
			named.append(String(fb[0]))
			for bl2 in body.split("\n"):
				for lit in _literals(String(bl2)):
					lits += 1
					if _says_tier(String(lit)):
						strays.append("%s: %s" % [fb[0], String(lit).substr(0, 50)])
	print("    CHECKED %d literals in %d functions of the composition machinery" % [lits, fns])
	ok(fns >= 10 and named.has("_resync_composition") and named.has("_conjoin") and named.has("_dissolve"),
		"§2: the literal sweep read %d functions (%s) — not the machinery's" % [fns, ", ".join(PackedStringArray(named.slice(0, 6)))])
	ok(strays.is_empty(), "§2: a literal of the composition machinery still says tier (%d: %s)" % [strays.size(), ", ".join(PackedStringArray(strays.slice(0, 3)))])
	# THE IDENTIFIERS ARE UNMOVED (HL §2's split): `tier_of` is declared and read, and no
	# code token — comments and string literals stripped — names a degree.
	var unit_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var bat_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(unit_src.contains("static func tier_of(") and bat_src.contains("BattleUnit.tier_of("),
		"§2: `tier_of` was renamed or is no longer read — the code's word does not move")
	var degree_tokens: Array = []
	var dir := DirAccess.open("res://scripts")
	for f in dir.get_files():
		if not f.ends_with(".gd"):
			continue
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f))
		var n := 0
		for ln3 in src.split("\n"):
			if _code_only(String(ln3)).to_lower().contains("degree"):
				n += 1
		if n > 0:
			degree_tokens.append("%s (%d)" % [f, n])
	ok(degree_tokens.is_empty(), "§2: a code token names a degree — the identifiers keep tier: %s" % [degree_tokens])


# ── §3 — THE DOCUMENT STATES WHAT THE GAME IS ───────────────────────────────

func _s3_the_document() -> void:
	print("\n§3 — master.html's seven fire-and-ice sentences, each held to its code fact")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	var bat := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var bat_script := load("res://scripts/battle.gd") as Script
	var consts: Dictionary = bat_script.get_script_constant_map()
	# 1 — SHATTER PAYS PER TURN HELD, capped, as its card says.
	# ONE ok() A PROPERTY: the old sentence gone and the new one there are two claims, and a
	# control that breaks one must not read as the other.
	ok(not master.contains("10% of Attack per stack of Chilled"),
		"§3: master.html's Shatter still pays per stack")
	ok(master.contains("10% of Attack for every turn it was held"),
		"§3: master.html's Shatter does not say it pays for every turn held")
	ok(bat.contains("clampi(strike_target.hold_turns, 1, SHATTER_TURN_CAP)"),
		"§3: Shatter's payout no longer scales by the turns held, capped — the document's sentence has lost its fact")
	ok(int(consts.get("SHATTER_TURN_CAP", 0)) == 12,
		"§3: SHATTER_TURN_CAP is %d — the document says at most twelve" % int(consts.get("SHATTER_TURN_CAP", 0)))
	# 2 — THE HOLD WINDOW IS A HERO'S STRIKE'S, read in the strike loop alone.
	ok(not master.contains("+15% damage from all sources"),
		"§3: master.html's hold window still says all sources")
	ok(master.contains("+15% damage from every hero's strike"),
		"§3: master.html's hold window does not say every hero's strike")
	ok(bat.count("_hold_window_mult()") == 2,
		"§3: `_hold_window_mult` is read at %d sites — the window's one read is the strike loop's" % (bat.count("_hold_window_mult()") - 1))
	var cryo: String = Classes.engine_desc("permafrost")
	ok(not cryo.contains("all sources"), "§3: the Glacial Hold rule text still says all sources")
	ok(cryo.contains("every hero's strike"), "§3: the Glacial Hold rule text does not say every hero's strike")
	# 3 — FIREDRAW TAKES SIX (`FIREDRAW_TAKE_PERFECT`), never four.
	ok(not master.contains("or 4, whichever is less"),
		"§3: master.html's Firedraw still takes what is there or 4")
	ok(master.contains("or 6, whichever is less"),
		"§3: master.html's Firedraw does not say it takes what is there or 6")
	ok(bat.contains("var fd_take := FIREDRAW_TAKE_PERFECT"),
		"§3: Firedraw no longer takes FIREDRAW_TAKE_PERFECT")
	ok(int(consts.get("FIREDRAW_TAKE_PERFECT", 0)) == 6,
		"§3: FIREDRAW_TAKE_PERFECT is %d — the document says six" % int(consts.get("FIREDRAW_TAKE_PERFECT", 0)))
	# 4 — EMBERKEEP DOUBLES ANY HERO'S BURN.
	ok(not master.contains("every Burn he applies lands at DOUBLE"),
		"§3: master.html's Emberkeep row still doubles only the Burn he applies")
	ok(master.contains("every Burn any hero applies lands at DOUBLE"),
		"§3: master.html's Emberkeep row does not double any hero's Burn")
	ok(bat.contains("and _emberkeep_holder() != null:"),
		"§3: Emberkeep's window no longer reads its holder — any hero's Burn is no longer its scope")
	# 5 — FLAMEWAVE ON A BURNING BODY IS LENGTHENED, NOT DOUBLED.
	ok(not master.contains("<b>Flamewave</b> lays 4 turns on everyone"),
		"§3: master.html still has Flamewave lay 4 on everyone under Emberkeep")
	# THE SENTENCE'S OWN WORDS, never the bare phrase: *not yet alight* stands in Slow Burn's row too, and the
	# arm read that copy green with the Flamewave sentence put back (HT's control T18).
	ok(master.contains("lays 4 turns instead of 2 on every enemy not yet alight"),
		"§3: master.html does not say Flamewave lays 4 only on an enemy not yet alight")
	ok(bat.contains("strike_target.update_status(\"burn\", binfo[1], binfo[3], -1,\n\t\t\t\t\t\tint(fw.turns) + fw_turns)"),
		"§3: Flamewave's burning branch no longer writes through update_status — the window may now double it")
	# 6 — WEAKNESSES ARE ASSIGNED: every enemy kind but one carries one.
	var foes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var none_weak: Array = []
	for kind in foes:
		var res: Dictionary = (foes[kind] as Dictionary).get("resists", {})
		var weak := false
		for school in res:
			if float(res[school]) < 0.0:
				weak = true
		if not weak:
			none_weak.append(String(kind))
	print("    enemy kinds %d, with no weakness: %s" % [foes.size(), none_weak])
	ok(not master.contains("only the Tyrant's frost weakness is set"),
		"§3: master.html still says only the Tyrant's frost weakness is set")
	ok(none_weak == ["raider"],
		"§3: the roster's kinds with no weakness are %s — the document names the Orc Raider alone" % [none_weak])
	ok(master.contains("every enemy kind but the Orc Raider is soft to"),
		"§3: master.html's weakness hook does not name the Orc Raider as the one kind soft to nothing")
	# 7 — SIX CONSUMERS PAY OVERBURN'S REFUND, in the document and in the glossary.
	var six := "Detonation, Wildfire, Cinderfall, Ember Debt, Funeral Pyre and Pyre Wake"
	var ob: Dictionary = Glossary.entry("overburn")
	ok(master.contains(six), "§3: master.html does not name the six refund consumers")
	ok(not master.contains("Cinderfall and Ember Debt all pay it"),
		"§3: master.html still names four refund consumers")
	ok(String(ob.get("long", "")).contains(six), "§3: the glossary's Overburn does not name the six refund consumers")
	ok(bat.count("_overburn_refund(") == 7,
		"§3: Overburn's refund is paid at %d sites — the document names six" % (bat.count("_overburn_refund(") - 1))
	# AND THE DESIGNED CONJUNCTIONS STAY DESIGNED: one row, one composed status.
	var conj: Dictionary = consts.get("CONJUNCTIONS", {})
	var info: Dictionary = consts.get("STATUS_INFO", {})
	ok(conj.size() == 1 and conj.has("rupture"),
		"§3: `CONJUNCTIONS` holds %s — the next conjunction is the designer's, and none is built" % [conj.keys()])
	var built: Array = []
	for cid in ["seize", "marrowfire", "contagion", "reckoning"]:
		if info.has(cid):
			built.append(cid)
	ok(built.is_empty(), "§3: a status carries a designed, unbuilt conjunction's id: %s" % [built])


# ── §4 — THE CENSUS'S TWO STRUCTURAL FACTS ──────────────────────────────────

func _s4_the_census_facts() -> void:
	print("\n§4 — Broken is a meter state with a chip; a Warrior with no engine lays statuses")
	# A WARRIOR HOLDING NO ENGINE, his kit cast at a clean enemy: each card's status lands.
	var over := {0: {"engines": []}}
	var scene: Node = await _board(["swordmaster", "pyromancer", "holy", "mystic"], {"party": over})
	var war: BattleUnit = null
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == "warrior":
			war = h
	var foes: Array = scene.get("enemies")
	var laid := {}
	if war != null:
		ok(war.engines.is_empty(), "§4: the Warrior seated for the kit drive holds an engine: %s" % [war.engines])
		for pair in [["Crushing Blow", "sunder"], ["Pommel Strike", "stunned"], ["Mocking Blow", "mocked"]]:
			var e: BattleUnit = foes[0]
			_clear(e)
			var card: Ability = null
			for ab in war.abilities:
				if (ab as Ability).display_name == String(pair[0]):
					card = ab
			if card == null:
				laid[pair[0]] = "not held"
				continue
			# Health no blow can take, so the strike never kills and the status always has
			# a body to land on (`_resolve` lays a card's status only on a survivor).
			e.max_hp = 99999
			e.hp = 99999
			war.resource = war.max_resource
			war.cooldowns.clear()
			await scene.call("_resolve", war, card, e, "good")
			laid[pair[0]] = e.has_status(String(pair[1]))
	print("    the Warrior's kit, no engine: %s" % laid)
	ok(war != null and laid.get("Crushing Blow", false) == true and laid.get("Pommel Strike", false) == true
			and laid.get("Mocking Blow", false) == true,
		"§4: a Warrior holding no engine did not lay Sunder, Stunned and Mocked from his own kit: %s" % laid)
	# BROKEN: an entry and a chip, written around the status door — no clock, no `src`.
	var b: BattleUnit = foes[1]
	_clear(b)
	b.pressure = 0
	b.take_hit(0, b.stability)
	var entry: Dictionary = {}
	for s in b.statuses:
		if String(s.id) == "broken":
			entry = s
	ok(b.broken and not entry.is_empty() and int(entry.get("turns", 0)) == 1 and not entry.has("src_name"),
		"§4: a Break did not write Broken's chip as an entry of one turn with no src: %s" % [entry])
	b.tick_statuses()
	b.tick_statuses()
	ok(b.has_status("broken") and int(b.get_status("broken").get("turns", 0)) == 1,
		"§4: Broken's turn count moved with the clock — it is the meter's, ended by the recovery")
	b.recover_from_break()
	ok(not b.broken, "§4: the recovery did not end the Break")
	ok(not b.has_status("broken"), "§4: the recovery did not take Broken's chip off")
	var conj: Dictionary = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("CONJUNCTIONS", {})
	var halves: Array = []
	for cid in conj:
		halves.append_array(conj[cid])
	ok(not halves.has("broken"), "§4: a conjunction names Broken as a half — the status door never sees it")
	# AND BLEED IS A METER TOO: `log_bleed_chip` writes its chip around the door, so no
	# conjunction can see it either (HT §2e) — Contagion, as designed, names it.
	ok(not halves.has("bleed"), "§4: a conjunction names Bleed as a half — its chip is written around the status door")
	scene.queue_free()
	await process_frame


# ── §5 — THE RECORD BESIDE THE CODE ─────────────────────────────────────────

func _s5_the_record() -> void:
	print("\n§5 — Rupture's watch condition sits on its constant")
	var raw := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var at := raw.find("const RUPTURE_BREAK_PER_TICK")
	var above := raw.substr(maxi(at - 2400, 0), 2400) if at >= 0 else ""
	ok(at >= 0 and above.contains("WATCH CONDITION, RECORDED BESIDE IT"),
		"§5: the watch condition is not recorded beside RUPTURE_BREAK_PER_TICK")
	ok(above.contains("IS NOT A GUIDE"),
		"§5: the record beside RUPTURE_BREAK_PER_TICK no longer says the sim's Break is not a guide")


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
