# BATCH IL — THE TWO MEASURED DEFECTS.
#
#   §0.2 EXECUTE's DARKENED BUTTON SAYS WHY: in the voice the other gates use, its figure read off `_execute_line` (the
#        upgraded copy's says 35%), and only while the cost is not what refuses it — he cannot cast it at all then.
#   §0.3 THE THREE CREST RUNES SAY STRIKE DAMAGE: Empty Pulpit, Dead Air and Dirge, and the crest chip's words, which
#        read the same two fields — both read in the strike loop alone.
#   §0.4 BLOOD DEBT NAMES ITS PAYER: *the enemy with the most health*, the Tracker's and the Arbiter's own words for the
#        rule; the payer is read off the board by points, never by share; the tie rule is the glossary's, not the rune's.
#   §0.6 THE GATE-SOURCE DERIVATION READS EVERY ROUTE: the rule's widened words stand once, in the instrument rules.
#   §0.9 SLOT 0 NEVER GRADES — one assertion, driven through the real turn, naming the three Perfects that would wake.
#   §1   SANCTITY's SOURCE GAP: the partition of IJ's sourceless calls, held — the seventeen a Cleric can source pass
#        him, the four kept apart pass nobody, and no Cleric card's arm is left sourceless but one dormant clause; a
#        Hierophant's repaired statuses land his steps longer, through the spawn; the recast gate adds the same steps.
#   §2   THE RUIN RUNG's BARGAINS: the census's own sample, read — one modifier table split by the rung's floor, the
#        floor at Ruin the table's top, and the ruled condition beyond any weighting of this table; the merchant at
#        severity 1; the glossary's *weighted toward the mild end* still the table's shape. (Re-pointed at IM §1: the
#        table is dealt by each rung's two bands, Ruin's gambles at the top; `check_im` §1 holds the bands. Re-pointed
#        at IN: the condition is met — severity 5 is Ruin's — the merchant rides the rung's mildest dealt severity, and
#        *weighted toward the mild end* is the twenty's; `check_in` §1 and §2 hold the rest.)
#   §3   THE BOT AIMS WHERE THE PICKER WOULD: the drafted hook asks `_enemy_pick_pool`, the picker's answer, so a
#        drafted Execute strikes a body that qualifies; the narrowing reaches Execute and no other card (and since
#        IM §3b, seven cards more by their own rule — `check_im` §3b drives them).
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 drives twelve of the seventeen repaired sites live and reads the other
# five off the source (two spills and a cast whose turns are battle-long, a Perfect-free Empowered branch, a rune's
# overheal) — a source pin on those five is a claim that the call passes him, not that a fight reaches it. §2 measures
# the offer, not a run: it says nothing about how often a Ruin party takes a harsh bargain. §3's reach is today's
# corpus; a card that grows a qualifier tomorrow is caught only if its narrowing lives in `_enemy_pick_pool`.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_il.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §1 — THE SEVENTEEN THE PARTITION REPAIRED: [function, status id, the source it now passes].
const REPAIRED := [
	["_alms_spill", "barrier", "cleric"], ["_grant_divine_shield", "barrier", "devout"],
	["_abundance_shield", "barrier", "ab_h"],
	["_resolve_special", "unity", "attacker"], ["_resolve_special", "zeal", "attacker"],
	["_resolve_special", "bulwark", "attacker"], ["_resolve_special", "rite_return", "attacker"],
	["_resolve_special", "vow", "attacker"], ["_resolve_special", "consecration", "attacker"],
	["_resolve_special", "unburdened", "attacker"], ["_resolve_special", "exhorted", "attacker"],
	["_resolve_special", "vigil", "attacker"], ["_resolve_special", "divine_presence", "attacker"],
	["_resolve_special", "alms", "attacker"], ["_resolve_special", "wrath", "attacker"],
	["_resolve_special", "intercession", "attacker"], ["_resolve_special", "sanctified", "attacker"],
]
# §1 — THE FOUR A CLERIC CAN CAUSE AND THAT PASS NOBODY, ON PURPOSE: [function, status id, why].
const KEPT_APART := [
	["_use_item", "fortify", "the pouch is the party's — an item is used at a hero's turn and is no hero's card"],
	["_use_item", "hexed", "the pouch is the party's — DI §2 left the Visage unstamped: the party uses items"],
	["_bewitched_strike", "dazed", "an enemy laying it on an enemy under the charm — DI §2's ambiguous source"],
	["_gain_ruin", "ruin_primed", "the Ruin engine's own clock, consumed as the bearer next acts"],
]
# §1 — A CLERIC's CLAUSE WITH A SOURCELESS CALL, ALLOWED ONLY WHILE IT IS DORMANT: {clause: the field that opens it}. The arm
# exemption is the one inside `_resolve_special`; Blessed Vestments' ward is a helper the arm walk does not read.
const DORMANT_CLERIC := {"Dark Pact's Invigoration": "invigoration_ranks", "Blessed Vestments' ward": "vestments_pct"}
const DORMANT_ARMS := ["dark_pact"]
# §1b — THE REPAIRED CARDS DRIVEN LIVE: [card, the status it lays, whom it lands on].
const LIVE := [
	["Blessing of Zeal", "zeal", "ally"], ["Divine Wrath", "wrath", "self"], ["Sacred Resolve", "unity", "self"],
	["Bulwark of Fortitude", "bulwark", "self"], ["Rite of Return", "rite_return", "ally"],
	["Vow of Suffering", "vow", "ally"], ["Consecration", "consecration", "self"],
	["Unburden", "unburdened", "ally"], ["Undying Vigil", "vigil", "ally"],
	["Divine Presence", "divine_presence", "self"], ["Alms", "alms", "self"], ["Intercession", "intercession", "self"],
]
const STEPS := 3


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IL — THE TWO MEASURED DEFECTS")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	await _s02_execute_button()
	await _s03_crest_words()
	await _s04_blood_debt_words()
	_s06_the_derivation()
	await _s09_slot_zero()
	_s1a_partition()
	await _s1b_lengthened()
	_s2_ruin_rung()
	await _s3_bot_aims()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


func _engines(pids: Array) -> Array:
	var out: Array = []
	for pid in pids:
		out.append(_rune(Runes.engine_rune_id(String(pid))))
	return out


func _board(specs: Array, over: Dictionary) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	await Gate.frames(self, 3)


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == key:
			return h
	return null


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


# A body named by its slot in the warband and its health — a board can field one kind three times, and a FAIL line that
# names "Orc Raider" thrice says less than it read.
func _slot(scene: Node, e: BattleUnit) -> String:
	if e == null:
		return "nobody"
	return "slot %d (%s, %d of %d%s)" % [_foes(scene).find(e), e.unit_name, e.hp, e.max_hp, ", Broken" if e.broken else ""]


func _card(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


# Every enemy at one size, whole, unbroken and clean, so a shape laid after it is the only thing on the board.
func _calm(scene: Node, max_hp: int) -> void:
	for e in scene.get("enemies"):
		var eu: BattleUnit = e
		if eu.dead:
			continue
		eu.max_hp = max_hp
		eu.hp = max_hp
		eu.pressure = 0
		eu.broken = false
		for st in eu.statuses.duplicate():
			eu.remove_status(String(st.id))


# The button the abilities list draws for a card, built by the list's own builder, and its hover read.
func _button_tip(scene: Node, u: BattleUnit, ab: Ability) -> Dictionary:
	var pop := PopupPanel.new()
	scene.add_child(pop)
	var b: Button = scene.call("_ability_popup_button", u, ab, pop, -1)
	var out := {"tip": String(b.tooltip_text), "disabled": b.disabled}
	b.free()
	pop.free()
	return out


# THE PLAYER's OWN TURN, DRIVEN (IK's `_turn`, reading one more thing: whether a skill bar opened for `u`'s card).
# Every other hero's turn is answered with his basic; on `u`'s turn `ab` is pressed as a player presses it.
func _turn(scene: Node, u: BattleUnit, ab: Ability) -> Dictionary:
	var out := {"bar": false, "resolved": false}
	var pressed := false
	var frames_n := 0
	while frames_n < 6000:
		frames_n += 1
		Engine.time_scale = 100.0
		await process_frame
		if not is_instance_valid(scene):
			break
		if bool(scene.get("sc_active")):
			if pressed:
				out["bar"] = true
			scene.call("_grade_skill_check")
			continue
		var kb: Array = scene.get("_kb_pool")
		if not kb.is_empty():
			scene.emit_signal("_target_picked", kb[0])
			continue
		var p: BattleUnit = scene.get("current_hero")
		var panel: Control = scene.get("action_panel")
		if p == null or panel == null or not panel.visible:
			continue
		if pressed:
			out["resolved"] = true
			break
		if p != u:
			scene.emit_signal("_ability_picked", p.abilities[0])
			continue
		u.cooldowns.clear()
		pressed = true
		scene.emit_signal("_ability_picked", ab)
	Engine.time_scale = 1.0
	return out


# String contents masked, so a comma or a paren inside a literal is not syntax (check_ft §3i's walk, held here).
func _mask(s: String) -> String:
	var out := ""
	var quote := ""
	var i := 0
	while i < s.length():
		var c := s[i]
		if quote != "":
			if c == "\\":
				out += "XX"
				i += 2
				continue
			if c == quote:
				quote = ""
				out += c
			else:
				out += "X"
		elif c == "\"" or c == "'":
			quote = c
			out += c
		else:
			out += c
		i += 1
	return out


func _split_args(inner: String) -> Array:
	var mk := _mask(inner)
	var out: Array = []
	var depth := 0
	var start := 0
	for i in mk.length():
		var c := mk[i]
		if c in ["(", "[", "{"]:
			depth += 1
		elif c in [")", "]", "}"]:
			depth -= 1
		elif c == "," and depth == 0:
			out.append(inner.substr(start, i - start).strip_edges())
			start = i + 1
	var tail := inner.substr(start).strip_edges()
	if tail != "":
		out.append(tail)
	return out


# Every `_apply_status(` call in the comment-stripped battle script: its function, its `_resolve_special` arm (the
# match label above it, or ""), and its arguments, read by paren depth across lines.
func _sites() -> Array:
	var lines := _src("scripts/battle.gd").split("\n")
	var out: Array = []
	var fn := ""
	var arm := ""
	var arm_rx := RegEx.create_from_string("^\\t\\t(\"[a-z_0-9]+\"(?:, *\"[a-z_0-9]+\")*):\\s*$")
	for i in lines.size():
		var line := String(lines[i])
		if line.begins_with("func "):
			fn = line.substr(5, line.find("(") - 5)
			arm = ""
		if fn == "_resolve_special":
			var m := arm_rx.search(line)
			if m != null:
				arm = m.get_string(1).replace("\"", "").replace(" ", "")
		if line.begins_with("func _apply_status"):
			continue
		var at := _mask(line).find("_apply_status(")
		if at < 0:
			continue
		var acc := ""
		var depth := 0
		var j := i
		var closed := false
		while j < lines.size() and j < i + 12:
			var chunk := String(lines[j]) if j > i else line.substr(at + 13)
			var mk := _mask(chunk)
			for k in mk.length():
				if mk[k] == "(":
					depth += 1
				elif mk[k] == ")":
					depth -= 1
					if depth == 0:
						acc += chunk.substr(0, k + 1)
						closed = true
						break
			if closed:
				break
			acc += chunk + " "
			j += 1
		var o := acc.find("(")
		var c2 := acc.rfind(")")
		var args := _split_args(acc.substr(o + 1, c2 - o - 1)) if o >= 0 and c2 > o else []
		out.append({"fn": fn, "arm": arm, "args": args, "line": i + 1})
	return out


func _id_of(site: Dictionary) -> String:
	var a: Array = site["args"]
	return String(a[1]).replace("\"", "") if a.size() > 1 else ""


func _src_of(site: Dictionary) -> String:
	var a: Array = site["args"]
	return String(a[5]) if a.size() >= 6 and String(a[5]) != "null" else ""


# ── §0.2 — EXECUTE's DARKENED BUTTON SAYS WHY ───────────────────────────────

func _s02_execute_button() -> void:
	print("\n§0.2 — Execute's darkened button says why, its line read off `_execute_line`")
	var s: Node = await _board(["swordmaster", "pyromancer", "holy", "mystic"],
		{0: {"bm_abilities": ["Execute"], "bm_equipped": ["Execute"]}})
	var u := _hero(s, "warrior") if s != null else null
	var ex := _card(u, "Execute") if u != null else null
	ok(u != null and ex != null and _foes(s).size() >= 2, "§0.2: the board seats a Swordmaster holding Execute against a warband")
	if u == null or ex == null:
		await _clear(s)
		return
	var foes := _foes(s)
	_calm(s, 1000)
	u.resource = u.max_resource
	u.cooldowns.clear()
	var a := _button_tip(s, u, ex)
	var want := "(No enemy is below %d%% health or Broken)" % int(round(float(s.call("_execute_line", u)) * 100.0))
	ok(String(a["tip"]).contains(want) and bool(a["disabled"]),
		"§0.2: with no enemy below the line and none Broken the button does not say '%s' (dark: %s; hover: '%s')" % [
			want, a["disabled"], String(a["tip"]).replace("\n", " | ")])
	u.execute_upgraded = 1
	var up_line := "(No enemy is below %d%% health or Broken)" % int(round(float(s.call("_execute_line", u)) * 100.0))
	var b := _button_tip(s, u, ex)
	ok(up_line != want and String(b["tip"]).contains(up_line),
		"§0.2: the upgraded copy's button does not say its own line '%s' ('%s')" % [up_line, String(b["tip"]).replace("\n", " | ")])
	u.execute_upgraded = 0
	u.resource = 0
	var c := _button_tip(s, u, ex)
	ok(bool(c["disabled"]) and not String(c["tip"]).contains("No enemy is below"),
		"§0.2: with no Rage to pay the target's line overwrote the cost's reason (dark: %s; hover: '%s')" % [
			c["disabled"], String(c["tip"]).replace("\n", " | ")])
	u.resource = u.max_resource
	(foes[0] as BattleUnit).hp = 100
	var d := _button_tip(s, u, ex)
	ok(not bool(d["disabled"]) and not String(d["tip"]).contains("No enemy is below"),
		"§0.2: with an enemy below the line the button still says none is (dark: %s; hover: '%s')" % [
			d["disabled"], String(d["tip"]).replace("\n", " | ")])
	ok(_body("scripts/battle.gd", "_ability_popup_button").contains("int(round(_execute_line(u) * 100.0))"),
		"§0.2: the button's figure is not read off `_execute_line`")
	await _clear(s)


# ── §0.3 — THE THREE CREST RUNES SAY STRIKE DAMAGE ──────────────────────────

func _s03_crest_words() -> void:
	print("\n§0.3 — the three crest runes, and the crest chip, say strike damage")
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"], {})
	for id in ["empty_pulpit", "dead_air", "dirge"]:
		var desc := Runes.shown_desc(Runes.build(id))
		ok(desc.contains("% less strike damage.") or desc.contains("% more strike damage."),
			"§0.3: %s does not say strike damage ('%s')" % [id, desc.replace("\n", " ")])
		ok(not desc.contains("% less damage") and not desc.contains("% more damage"),
			"§0.3: %s still says bare damage ('%s')" % [id, desc.replace("\n", " ")])
		var chip := String(s.call("_rune_effect_words", Runes.config(id).get("payload", {}))) if s != null else ""
		ok(chip.contains("strike damage"), "§0.3: %s's crest chip does not say strike damage ('%s')" % [id, chip])
	await _clear(s)


# ── §0.4 — BLOOD DEBT NAMES ITS PAYER ───────────────────────────────────────

func _s04_blood_debt_words() -> void:
	print("\n§0.4 — Blood Debt names the enemy with the most health; the tie rule is the glossary's")
	var desc := Runes.shown_desc(Runes.build("blood_debt_rune"))
	ok(desc.begins_with("The enemy with the most health pays Blood Price's health cost instead of him"),
		"§0.4: the rune does not name its payer ('%s')" % desc)
	ok(not desc.contains("ENEMY's health") and not desc.contains("fullest"),
		"§0.4: the rune keeps an old or a fraction word ('%s')" % desc)
	ok(not desc.contains("first in the warband"), "§0.4: the tie rule stands on the rune, not in the glossary ('%s')" % desc)
	ok(String(Classes.engine_desc("quarry_hunt")).replace("\n", " ").contains("the enemy with the most health"),
		"§0.4: the Tracker's rule no longer says the enemy with the most health — the rune's words are its words")
	var g := Glossary.entry("most_health")
	var listed := Glossary.in_category("combat").any(func(e): return String(e.get("id", "")) == "most_health")
	ok(not g.is_empty() and listed, "§0.4: the glossary has no `most_health` entry the combat panel lists (listed: %s)" % listed)
	var gl := String(g.get("long", ""))
	ok(gl.contains("On a tie it is the first in the warband"), "§0.4: the glossary entry does not carry the tie rule ('%s')" % gl)
	ok(gl.contains("counted in points rather than as a share"), "§0.4: the glossary entry does not say the pick is by points")
	# THE PAYER, LIVE: by points, so a large enemy at 60% pays before a small one untouched — the word *fullest*
	# would name the small one, which is why the rune does not say it.
	var bp_over := {0: {"runes": [_rune("blood_debt_rune")]}}
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"], bp_over)
	var foes := _foes(s) if s != null else []
	ok(foes.size() >= 3, "§0.4: the board fields three enemies (%d)" % foes.size())
	if foes.size() >= 3:
		_calm(s, 20000)
		(foes[0] as BattleUnit).max_hp = 100000
		(foes[0] as BattleUnit).hp = 60000
		(foes[2] as BattleUnit).hp = 10000
		var payer: BattleUnit = s.call("_blood_debt_payer")
		ok(payer == foes[0],
			"§0.4: the payer is not the enemy with the most health — it billed %s, where slot 0 stands at 60000 of 100000 and slot 1, the fullest by share, at 20000 of 20000" % [
				_slot(s, payer)])
	await _clear(s)


# ── §0.6 — THE GATE-SOURCE DERIVATION READS EVERY ROUTE ─────────────────────

const WIDE_DERIVATION := "the targets that read the battery's own list off `run_battery.sh` and open each target it names"


func _s06_the_derivation() -> void:
	print("\n§0.6 — the gate-source readers are every target that reads another target's source, by either route")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(ir.count(WIDE_DERIVATION) == 1, "§0.6: the instrument rules state the battery-list route %d times, want once" % ir.count(WIDE_DERIVATION))
	ok(not cm.contains(WIDE_DERIVATION), "§0.6: CLAUDE.md carries the rule's words — the index names it, the reference holds it")


# ── §0.9 — SLOT 0 NEVER GRADES ──────────────────────────────────────────────

func _s09_slot_zero() -> void:
	print("\n§0.9 — slot 0 never grades, and three Perfects wait on that")
	# THE CENSUS: every class's basic with a Perfect id, less the one the Sharpshooter's sequence grades.
	var dead: Array = []
	for key in ["warrior", "mage", "cleric", "hunter"]:
		var basic: Ability = Classes.kit(key)[0]
		if String(basic.perfect_id) != "" and key != "hunter":
			dead.append("%s's `%s`" % [basic.display_name, basic.perfect_id])
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"], {})
	var bars: Array = []
	for key in ["warrior", "mage", "cleric"]:
		var u := _hero(s, key) if s != null else null
		if u == null:
			bars.append("%s unseated" % key)
			continue
		var r: Dictionary = await _turn(s, u, u.abilities[0])
		if bool(r["bar"]) or not bool(r["resolved"]):
			bars.append("%s's %s (bar %s, resolved %s)" % [key, u.abilities[0].display_name, r["bar"], r["resolved"]])
	await _clear(s)
	ok(bars.is_empty() and dead.size() == 3,
		"§0.9: slot 0 graded, or the census moved — the day slot 0 grades, %s Perfects wake unbidden (graded: %s)" % [
			" and ".join(PackedStringArray(dead)), str(bars)])
	print("    three basics through the real turn, no bar; the Perfects that wait: %s" % ", ".join(PackedStringArray(dead)))


# ── §1a — THE PARTITION, HELD ───────────────────────────────────────────────

func _s1a_partition() -> void:
	print("\n§1a — the partition, held: what a Cleric can source passes him, and what is kept apart passes nobody")
	var sites := _sites()
	var with_src := sites.filter(func(st): return _src_of(st) != "")
	print("    CHECKED %d of %d `_apply_status` call sites — %d carry a source, %d do not" % [
		sites.size(), sites.size(), with_src.size(), sites.size() - with_src.size()])
	ok(sites.size() >= 200, "§1a: the walk reached %d call sites, which is the population and not a sample" % sites.size())
	for row in REPAIRED:
		var hits := sites.filter(func(st): return String(st["fn"]) == String(row[0]) and _id_of(st) == String(row[1]))
		ok(hits.size() == 1 and _src_of(hits[0]) == String(row[2]),
			"§1a: %s's `%s` does not pass `%s` as its source (%d sites; sources %s)" % [row[0], row[1], row[2],
				hits.size(), str(hits.map(func(st): return _src_of(st)))])
	for row2 in KEPT_APART:
		var h2 := sites.filter(func(st): return String(st["fn"]) == String(row2[0]) and _id_of(st) == String(row2[1]))
		ok(h2.size() == 1 and _src_of(h2[0]) == "",
			"§1a: %s's `%s` passes a source (%s) — kept apart because %s" % [row2[0], row2[1],
				str(h2.map(func(st): return _src_of(st))), row2[2]])
	# NO CLERIC CARD's ARM IS LEFT SOURCELESS, but a dormant clause the field that opens it has no writer for. The
	# population is `Classes.ability_corpus()` (DA §3's one walk); the Cleric's kit, his class pool and his lineages'
	# tables and boss pools only say which of its cards are his.
	var his := {}
	for ab in Classes.kit("cleric") + Classes.class_kit("cleric"):
		his[ab.display_name] = true
	for nm in Classes.draft_pool("cleric"):
		his[String(nm)] = true
	for spec in Classes.SPEC_INFO:
		if Classes.class_of_spec(String(spec)) != "cleric":
			continue
		for ab in Classes.spec_abilities(String(spec)):
			his[ab.display_name] = true
		for nm in Classes.spec_pool(String(spec)):
			his[String(nm)] = true
	var cs := {}
	for ab in Classes.ability_corpus():
		if his.has(ab.display_name) and String(ab.special) != "":
			cs[String(ab.special)] = String(ab.display_name)
	var left: Array = []
	for st in sites:
		if _src_of(st) != "" or String(st["fn"]) != "_resolve_special":
			continue
		for sp in String(st["arm"]).split(","):
			if cs.has(sp) and not DORMANT_ARMS.has(sp):
				left.append("%s (%s) `%s`" % [cs[sp], sp, _id_of(st)])
	ok(left.is_empty(), "§1a: a Cleric card's arm still lays a status with no source: %s (%d Cleric specials read)" % [
		str(left), cs.size()])
	ok(cs.size() >= 20, "§1a: the corpus gave %d Cleric specials, want twenty or more — the sweep has stopped reading" % cs.size())
	for sp2 in DORMANT_CLERIC:
		var fld := String(DORMANT_CLERIC[sp2])
		var writers := 0
		for f in ["scripts/talents.gd", "scripts/runes.gd"]:
			writers += _src(f).count("\"%s\"" % fld)
		var data := FileAccess.get_file_as_string("res://data/runes.json")
		writers += data.count("\"%s\"" % fld)
		ok(writers == 0, "§1a: `%s`, which keeps %s sourceless, has %d writers now — pass the Cleric there" % [fld, sp2, writers])


# ── §1b — A HIEROPHANT's REPAIRED STATUSES LAND HIS STEPS LONGER ────────────

func _turns_of(u: BattleUnit, id: String) -> int:
	var st: Dictionary = u.get_status(id)
	return int(st.get("turns", -999)) if not st.is_empty() else -999


func _strip_all(scene: Node) -> void:
	for u in scene.get("heroes") + scene.get("enemies"):
		for st in (u as BattleUnit).statuses.duplicate():
			(u as BattleUnit).remove_status(String(st.id))
		(u as BattleUnit).battle_turn += 1


func _s1b_lengthened() -> void:
	print("\n§1b — a Hierophant's repaired statuses land his steps longer, seated through the spawn")
	var over := {2: {"engines": _engines(["mercy", "sanctity"])}}
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"], over)
	var c := _hero(s, "cleric") if s != null else null
	var ally := _hero(s, "warrior") if s != null else null
	ok(c != null and ally != null and c.sanctity_active and c.second_resource_name == "Mercy",
		"§1b: the spawn did not seat a Cleric holding Mercy and Sanctity (sanctity %s, %s)" % [
			c.sanctity_active if c != null else "-", c.second_resource_name if c != null else "-"])
	if c == null or ally == null:
		await _clear(s)
		return
	for row in LIVE:
		var ab: Ability = Classes.pool_ability(String(row[0]))
		var on: BattleUnit = ally if String(row[2]) == "ally" else c
		var t := ally if String(row[2]) == "ally" else c
		var arms := {}
		for steps in [0, STEPS]:
			_strip_all(s)
			BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP * steps
			c.second_resource = 0
			await s._resolve_special(c, ab, t, "good", 1.0)
			arms[steps] = _turns_of(on, String(row[1]))
		ok(int(arms[0]) > 0 and int(arms[STEPS]) == int(arms[0]) + STEPS * BattleUnit.SANCTITY_STEP_TURNS,
			"§1b: %s's `%s` lands %d turns at %d steps and %d at none — want %d more" % [row[0], row[1],
				arms[STEPS], STEPS, arms[0], STEPS * BattleUnit.SANCTITY_STEP_TURNS])
	# A BATTLE-LONG STATUS IS NOT LENGTHENED, AND IT NOW NAMES WHO LAID IT.
	_strip_all(s)
	BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP * STEPS
	await s._resolve_special(c, Classes.pool_ability("Exhortation"), c, "good", 1.0)
	var ex_st: Dictionary = ally.get_status("exhorted")
	ok(not ex_st.is_empty() and int(ex_st.get("turns", 0)) == -1 and String(ex_st.get("src_name", "")) == c.unit_name,
		"§1b: Exhortation's banked status on an ally reads turns %s, laid by '%s' — want battle-long and the Cleric's" % [
			ex_st.get("turns", "-"), ex_st.get("src_name", "")])
	# §1c — THE RECAST GATE ADDS THE SAME STEPS, BOTH WAYS: refused when a recast would write what stands, not refused
	# once a step more would lengthen it.
	var wrath: Ability = Classes.pool_ability("Divine Wrath")
	_strip_all(s)
	BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP * 2
	await s._resolve_special(c, wrath, c, "good", 1.0)
	var at2 := bool(s.call("_recast_refused", c, wrath))
	BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP * 3
	var at3 := bool(s.call("_recast_refused", c, wrath))
	ok(at2, "§1c: at the steps it was cast at, a second Divine Wrath that would write what stands was not refused (Wrath stands %d)" % _turns_of(c, "wrath"))
	ok(not at3, "§1c: a step later the recast would lengthen every Wrath and the gate still refused it (Wrath stands %d)" % _turns_of(c, "wrath"))
	print("    Divine Wrath standing at %d turns: refused at 2 steps %s, at 3 steps %s" % [_turns_of(c, "wrath"), at2, at3])
	BattleUnit.reset_sanctity()
	await _clear(s)


# ── §2 — THE RUIN RUNG's BARGAINS, READ ─────────────────────────────────────

func _s2_ruin_rung() -> void:
	print("\n§2 — the Ruin rung's bargains: the census's own sample, 400 offers a rung")
	var was := String(_run.difficulty)
	var was_slot := int(_run.slot_idx)
	# A slot past the run's shop gate, so the merchant (HS §0 holds it out of the first nodes) is offered where it pays.
	_run.slot_idx = int(_run.SHOP_GATE_NODES) + 4
	var means := {}
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		seed(4004)
		var dist := {1: 0, 2: 0, 3: 0, 4: 0}
		var sum := 0
		var n := 0
		var shops := 0
		for _i in 400:
			for opt in _run.roll_offer():
				var sev: int = _run.modifier_severity(String(opt["modifier"]))
				dist[sev] = int(dist.get(sev, 0)) + 1
				sum += sev
				n += 1
				if String((opt["reward"] as Dictionary).get("kind", "")) == "shop":
					shops += 1
		means[d] = float(sum) / maxf(float(n), 1.0)
		print("    %-8s mean severity %.2f over %d options — by severity %s — the merchant on %d" % [d, means[d], n, str(dist), shops])
	_run.difficulty = was
	_run.slot_idx = was_slot
	var table: Dictionary = _run.MODIFIERS
	var top := 0
	var low := 0
	var high := 0
	# BATCH IN §1 — *weighted toward the mild end* is said of the twenty every rung deals; Ruin's four stand above them.
	var top20 := int(((_run.DIFFICULTIES["ruin"] as Dictionary).get("gamble_band", [99, 99]) as Array)[0]) - 1
	for id in table:
		var sv: int = int(table[id]["severity"])
		top = maxi(top, sv)
		if sv > top20:
			continue
		if sv <= 2:
			low += 1
		else:
			high += 1
	var body := _body("scripts/run_state.gd", "roll_offer")
	# BATCH IM §1 RE-POINTED THESE TWO ROWS: the floor that split the table is gone, and each rung names the band its safe
	# slot is dealt from and the band its gambles are. What they still ask of IL's premise: ONE table, dealt by the rung's
	# own fields — and Ruin's gambles reach the table's top, so nothing stands above them (`check_im` §1 holds the rest).
	ok(body.contains("for id in MODIFIERS:") and body.contains("difficulty_def()[\"safe_band\"]")
			and body.contains("difficulty_def()[\"gamble_band\"]") and not body.contains("difficulty_rung"),
		"§2: `roll_offer` no longer deals one table by the rung's two bands — the premise IM built on has moved")
	var ruin_gb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary).get("gamble_band", [0, 0])
	ok(int(ruin_gb[1]) >= top,
		"§2: Ruin's gamble band (%s) stops below the table's top severity (%d) — a modifier stands above it now" % [
			str(ruin_gb), top])
	# BATCH IN §1 RE-POINTED THIS ROW: IL read the ruled condition — Ruin a full step above Warden — beyond any weighting of
	# a table topping at 4. IN's severity-5 band is what reaches it, so the row asks that it is met.
	ok(float(top) >= float(means["warden"]) + 1.0 and float(means["ruin"]) >= float(means["warden"]) + 1.0,
		"§2: Ruin's mean (%.2f) is not a full step above Warden's (%.2f), or the table's top (%d) does not reach it" % [
			means["ruin"], means["warden"], top])
	var shop_at: Array = []
	for sv2 in _run.REWARDS:
		for r in _run.REWARDS[sv2]:
			if String(r.get("kind", "")) == "shop":
				shop_at.append(int(sv2))
	# BATCH IN §2 RE-POINTED THIS ROW: the merchant is no severity's row; it rides the rung's mildest dealt severity.
	ok(shop_at.is_empty() and _body("scripts/run_state.gd", "rewards_for").contains("mildest_dealt_severity()"),
		"§2: the table holds the merchant at severity %s, or `rewards_for` does not read the mildest dealt (IN §2)" % str(shop_at))
	ok(low > high, "§2: the twenty are no longer weighted toward the mild end (%d at severity 1-2, %d at 3-%d) — G080L is false" % [low, high, top20])


# ── §3 — THE BOT AIMS WHERE THE PICKER WOULD ────────────────────────────────

func _s3_bot_aims() -> void:
	print("\n§3 — the bot's drafted hook aims a drafted Execute where the picker would let him")
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"],
		{0: {"engines": [], "bm_abilities": ["Execute"], "bm_equipped": ["Execute"]}})
	var u := _hero(s, "warrior") if s != null else null
	var ex := _card(u, "Execute") if u != null else null
	var foes := _foes(s) if s != null else []
	ok(u != null and ex != null and foes.size() >= 3, "§3: the board seats a Warrior holding a drafted Execute and no core rune against three")
	if u == null or ex == null or foes.size() < 3:
		await _clear(s)
		return
	# The lowest-health body by share is NOT one the picker offers (it stands above the line, read off `_execute_line`);
	# the Broken one at 97% is.
	_calm(s, 10000)
	var line := float(s.call("_execute_line", u))
	(foes[0] as BattleUnit).hp = int(round(10000.0 * minf(line + 0.10, 0.95)))
	(foes[1] as BattleUnit).hp = 9700
	(foes[1] as BattleUnit).broken = true
	u.resource = u.max_resource
	u.cooldowns.clear()
	var pick: Array = s.call("_bot_drafted_pick", u)
	ok(not pick.is_empty() and pick[0] == ex and pick[1] == foes[1],
		"§3: the hook aimed %s at %s — the picker offers only slot 1, the Broken one" % [
			(pick[0] as Ability).display_name if not pick.is_empty() else "nothing",
			_slot(s, pick[1] as BattleUnit) if not pick.is_empty() else "nobody"])
	# The upgraded copy he cannot pay for: the Broken alone, still.
	u.execute_upgraded = 1
	u.resource = 0
	(foes[0] as BattleUnit).hp = int(round(10000.0 * maxf(float(s.call("_execute_line", u)) - 0.05, 0.01)))
	var pick2: Array = s.call("_bot_drafted_pick", u)
	ok(not pick2.is_empty() and pick2[0] == ex and pick2[1] == foes[1],
		"§3: with no Rage the upgraded copy aimed at %s — the free cast covers slot 1, the Broken one, alone" % [
			_slot(s, pick2[1] as BattleUnit) if not pick2.is_empty() else "nobody"])
	u.execute_upgraded = 0
	u.resource = u.max_resource
	# A pool with nobody in it is what the hook skips on.
	_calm(s, 10000)
	ok((s.call("_enemy_pick_pool", u, ex, _foes(s)) as Array).is_empty(),
		"§3: with nobody below the line or Broken the pick pool is not empty")
	# THE REACH: every single-target enemy pick in the corpus keeps the whole warband but Execute.
	var narrowed: Array = []
	var read := 0
	for ab in Classes.ability_corpus():
		if ab.target != Ability.Target.ENEMY or ab.aoe or ab.random_hits > 0:
			continue
		read += 1
		var pool: Array = s.call("_enemy_pick_pool", u, ab, _foes(s))
		if pool.size() != _foes(s).size():
			narrowed.append(ab.display_name)
	(foes[2] as BattleUnit).hp = 100
	var ex_pool: Array = s.call("_enemy_pick_pool", u, ex, _foes(s))
	# BATCH IM §3b RE-POINTED THIS ROW: the pick that can produce nothing is refused for seven cards more (IL §0.7's
	# rubric, the designer's), and on a clean board — nothing on the field that any of them reads — each narrows to nobody.
	var narrowed_sorted := narrowed.duplicate()
	narrowed_sorted.sort()
	ok(narrowed_sorted == ["Cryoclasm", "Cull", "Execute", "Firedraw", "Funeral Pyre", "Pyre Wake", "Requiem", "Transference"]
			and ex_pool == [foes[2]] and read >= 100,
		"§3: the pick pool narrows %s on a clean board (want Execute and IM's seven), and Execute's with one low enemy is %s (%d cards read)" % [
			str(narrowed_sorted), str(ex_pool.map(func(e): return (e as BattleUnit).unit_name)), read])
	ok(_body("scripts/battle.gd", "_bot_drafted_pick").contains("_enemy_pick_pool(u, ab, foes)"),
		"§3: the drafted hook does not ask `_enemy_pick_pool`")
	# THE SECOND BOT SITE: the Swordmaster's rotation aims his own Execute (most of the sim's casts), and it asks the
	# same pool — and the qualifier is asked by the door, the button, the pool and the hover and nowhere else, so a
	# narrowing written by hand at a new site reds here.
	ok(_body("scripts/battle.gd", "_autoplay_pick_kit").contains("_enemy_pick_pool(u, sm_exec, foes)"),
		"§3: the Swordmaster's rotation does not aim Execute through `_enemy_pick_pool`")
	var q_all := _src("scripts/battle.gd").count("_execute_qualifies(") - 1
	var q_known := 0
	for fn in ["_ability_usable", "_ability_popup_button", "_enemy_pick_pool", "_target_refusals"]:
		q_known += _body("scripts/battle.gd", fn).count("_execute_qualifies(")
	ok(q_all == q_known,
		"§3: `_execute_qualifies` is asked %d times outside the door, the button, the pool and the hover (%d calls, %d there)" % [
			q_all - q_known, q_all, q_known])
	ok(q_known >= 4, "§3: the door, the button, the pool and the hover ask `_execute_qualifies` %d times, want four or more" % q_known)
	print("    the qualifier reaches Execute alone: %d single-target enemy picks read" % read)
	await _clear(s)


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
