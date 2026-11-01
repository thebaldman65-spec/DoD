# BATCH IP — THE DECK's LAST CUT, AND THE INSTRUMENT's OWN DEFECT.
#
#   §1a  THE HUNGERING DARK IS REMOVED, NOT DISABLED: no row, no constant, no door and no word of it in the game's code or
#        data, comments set aside; `heal_amount`'s `unowned` door goes with it — nothing else reached that door — so the heal
#        door is the two-parameter door it was before the Dark, and no call passes a third. A save written before IP can
#        carry the id a removed modifier went by: the fight reads no modifier for it (`_active_modifier` asks the deck), and
#        a live id is still read — the positive arm.
#   §1b  SEVERITY 5 IS THE CLIFF, THREE DEEP: the deck holds twenty-three, cut six / six / four / four / three; Ruin's gamble
#        band holds the three and every Ruin offer deals two of them, distinct; no Wanderer or Warden band reaches severity 5,
#        over the data and over EP's sample; the fixed encounters draw the eight of severity 3–4; EP's sample reads its
#        bands' arithmetic, and IO's reading beside it. **NO GRADE IS PINNED HERE**: the grades are the measurement's (IP's
#        report, §1b), and a re-grade that keeps the counts leaves this gate green.
#   §2   THE BOT DRINKS THE PLAYER's POTION: DRIVEN — on the real turn loop, a bot hero who opens his turn below the line
#        drinks `Run.health_potion_heal` of his own maximum through the heal door, the figure the player's own use path
#        reads; the drink line names no figure of its own.
#   §0   The rulings recorded: a two-sided rule keyed on a lopsided quantity (`CLAUDE.md`'s ladder block); the tie, the
#        site test and the instrument's fidelity (`docs/instrument-rules.md`); the Dark's shape and figures
#        (`docs/design-notes.md`).
#   §7   The archive's newest cut stands at its top.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** What a modifier COSTS a party, and so which grade it holds, is the sim's forced
# arm (IP's report, §1b and §2); this gate holds the shape the measurement is cut into and the doors the batch moved. That
# the repaired potion moves a grade is a measurement, never an assertion here.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ip.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §1a — every name the removed modifier and its doors went by.
const DARK_WORDS := ["hungering_dark", "Hungering Dark", "HUNGERING_DARK_PCT", "_dark_feeds"]
# §1b — the sizes the bands are built on since the cut (the brief's §1b): the table's own counts, the top three deep.
# RE-POINTED AT IX §3: a grade is a cost band on the reference party now, so the counts are the scale's arithmetic on IW's
# ladder (six modifiers carry no severity and stand in no band) — a re-measure moves them with the costs, and this line with it.
# RE-POINTED AT IY §2 and §4: the tally the grades hold — the test binds (a cost inside two standard errors has no severity),
# the grade is the highest cost measured on any population (Deadened 3, Brittle 2), and the nine turned handles graded by
# their own measurement (`docs/reports/IY-grades.tsv`).
# RE-POINTED AT IZ §1–§5: the tally the grades hold since IZ — the sharper reading of one population replaces the blunter
# (IZ §0.1), the reverts graded by their own old readings, Dull Edge removed (§3); `docs/reports/IZ-grades.tsv`.
# RE-POINTED AT JA §2: Fleeting at three turns off, re-read in the deck, is a 2 — six at 1, five at 2; the grades of record are
# `docs/reports/JA-grades.tsv`.
# RE-POINTED AT JB §3: the four, each placed by its reading.
const GRADE_COUNTS := {1: 7, 2: 7, 3: 4, 4: 3, 5: 4}
# §1b — EP's sample as IO read it (`docs/reports/IO.md` §2d): the reading the cut is held against, not a grade.
# RE-POINTED AT IX §3: the scale's grades deal these means from the same dice (IX's reading; IO's 2.84 / 3.29 / 4.49 stood until
# then), so a grade moved with no measurement still moves a mean here.
const IO_SAMPLE := {"wanderer": 2.76, "warden": 3.28, "ruin": 4.47}
# RE-POINTED AT IY §4: the held reading is IY's — its re-grade moved the bands' contents (the test binds, the higher cost, the
# nine turned), so Warden's mean moved +0.10 off IO's by the deck, not by the draw; IO's figures stay printed as the record.
const IY_SAMPLE := {"wanderer": 2.733, "warden": 3.377, "ruin": 4.434}
# RE-POINTED AT IZ: the held reading is IZ's, read off this gate's own print on IZ's tree — the sharper readings, the
# reverts and the two removals moved the bands' contents, so the means moved by the deck, not by the draw (each sits within
# 0.01 of its bands' arithmetic); IY's figures stay printed as the record.
const IZ_SAMPLE := {"wanderer": 2.671, "warden": 3.275, "ruin": 4.443}
# RE-POINTED AT JB §3: the held reading is JB's, read off this gate's own print on JB's tree — the four moved the bands' contents,
# so the means moved by the deck, not by the draw (each sits within 0.02 of its bands' arithmetic); IZ's figures stay printed as the record.
const JB_SAMPLE := {"wanderer": 2.776, "warden": 3.261, "ruin": 4.470}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IP — THE DECK's LAST CUT, AND THE INSTRUMENT's OWN DEFECT")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s1a_the_dark_removed()
	await _s1a_a_stale_id()
	_s1b_the_cut()
	_s1b_the_sample()
	await _s2_the_potion()
	_s0_rulings()
	_s7_the_archive()
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


func _band_members(band: Array) -> Array:
	var out: Array = []
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		if sv >= int(band[0]) and sv <= int(band[1]):
			out.append(String(id))
	return out


func _mean_sev(ids: Array) -> float:
	var sum := 0.0
	for id in ids:
		sum += float(_run.modifier_severity(String(id)))
	return sum / maxf(float(ids.size()), 1.0)


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _clear(scene: Node) -> void:
	_run.pending_modifier = ""
	_run.pending_reward = {}
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	await Gate.frames(self, 3)


# ── §1a — THE HUNGERING DARK, REMOVED ───────────────────────────────────────

func _s1a_the_dark_removed() -> void:
	print("\n§1a — the Hungering Dark is removed, not disabled: no row, no constant, no door, no word")
	ok(not (_run.MODIFIERS as Dictionary).has("hungering_dark"), "§1a: `hungering_dark` is still in the deck")
	ok(_run.get("HUNGERING_DARK_PCT") == null, "§1a: `Run.HUNGERING_DARK_PCT` still stands")
	# NO WORD OF IT in the game's code or data, comments set aside (a record of the removal may name it). The population is
	# every script and every data file, and the sweep says how many it read (EA §5: a sweep asserts its own population).
	var left: Array = []
	var read := 0
	for f in DirAccess.get_files_at("res://scripts"):
		if not String(f).ends_with(".gd"):
			continue
		read += 1
		var src := _src("scripts/" + String(f))
		for w in DARK_WORDS:
			if src.contains(String(w)):
				left.append("%s in scripts/%s" % [w, f])
	for df in DirAccess.get_files_at("res://data"):
		if not String(df).ends_with(".json"):
			continue
		read += 1
		var dsrc := FileAccess.get_file_as_string("res://data/" + String(df))
		for w2 in DARK_WORDS:
			if dsrc.contains(String(w2)):
				left.append("%s in data/%s" % [w2, df])
	ok(read >= 20 and left.is_empty(), "§1a: the Dark is still named — %s (read %d files)" % [str(left), read])
	# THE HEAL DOOR IS THE TWO-PARAMETER DOOR AGAIN: nothing but the Dark reached `unowned`, so it goes, and no caller in the
	# game passes a third argument. The positive arm: the door stands, with both of its parameters.
	var u := _src("scripts/unit.gd")
	ok(u.contains("func heal_amount(amount: int, external := false) -> int:"),
		"§1a: `heal_amount` is not the two-parameter door (external alone)")
	ok(not u.contains("unowned"), "§1a: `unit.gd` still names the `unowned` door")
	var third: Array = []
	var rx := RegEx.new()
	rx.compile("heal_amount\\(([^()]|\\([^()]*\\))*,([^()]|\\([^()]*\\))*,")
	var calls := 0
	for f2 in DirAccess.get_files_at("res://scripts"):
		if not String(f2).ends_with(".gd"):
			continue
		var s2 := _src("scripts/" + String(f2))
		calls += s2.count(".heal_amount(")
		for m in rx.search_all(s2):
			if not m.get_string().begins_with("heal_amount(amount"):
				third.append("scripts/%s: %s" % [f2, m.get_string().left(60)])
	ok(calls >= 20 and third.is_empty(), "§1a: a heal passes a third argument — %s (of %d calls)" % [str(third), calls])
	# AND THE DAMAGE DOOR FEEDS NOBODY: `_on_damage_taken` calls no feed.
	var od := _body("scripts/battle.gd", "_on_damage_taken")
	ok(od != "" and not od.contains("feeds") and od.contains("_rule_engines_on_damage(victim, lost)"),
		"§1a: BL's damage door still calls a feed, or the door was not found")
	ok(not _src("scripts/battle.gd").contains("\"wasting\", \""), "§1a: `_stamp_modifier`'s Wasting arm still shares its line")
	print("    the deck: %d modifiers; %d files read; %d heal calls, none with a third argument" % [
		(_run.MODIFIERS as Dictionary).size(), read, calls])


# A SAVE WRITTEN BEFORE IP CAN CARRY `hungering_dark` as the bargain in force (GF: the step in flight rides the save). The
# fight reads the deck for it, so it is fought under no modifier — and a blow under it feeds nobody; the POSITIVE arm is a
# live id read as itself, so the guard is not green for want of reading anything.
func _s1a_a_stale_id() -> void:
	var s: Node = await Gate.spawn(self, ["warden", "pyromancer", "holy", "mystic"], {"deterministic": true})
	ok(s != null, "§1a: the board spawned")
	if s == null:
		return
	Engine.time_scale = 50.0
	_run.pending_modifier = "hungering_dark"
	ok(String(s.call("_active_modifier")) == "", "§1a: a save's stale `hungering_dark` is read as the modifier in force ('%s')" % String(s.call("_active_modifier")))
	_run.pending_modifier = "wasting"
	ok(String(s.call("_active_modifier")) == "wasting", "§1a: a live id is not read as itself ('%s') — the guard reads nothing" % String(s.call("_active_modifier")))
	_run.pending_modifier = "hungering_dark"
	var h: BattleUnit = null
	for hh in s.get("heroes"):
		if not (hh as BattleUnit).is_companion:
			h = hh
			break
	var foes := _foes(s)
	if h != null and not foes.is_empty():
		var e: BattleUnit = foes[0]
		h.max_hp = 5000
		h.hp = 3000
		e.max_hp = 2000
		e.hp = 1000
		s.call("_dmg_frame", h, "probe")
		e.take_tick_damage(200, "-200", Color.WHITE)
		ok(e.hp < 1000 and h.hp == 3000, "§1a: under a stale `hungering_dark`, %s (the board's first hero) dealing %d to %s (the warband's first) was fed %d" % [
			h.unit_name, 1000 - e.hp, e.unit_name, h.hp - 3000])
		s.call("_dmg_frame", null, "")
	else:
		ok(false, "§1a: the board seats no hero or no enemy")
	await _clear(s)


# ── §1b — THE CUT ───────────────────────────────────────────────────────────

func _s1b_the_cut() -> void:
	print("\n§1b — severity 5 is the cliff, three deep; the counts the bands are built on are the table's own")
	var by := {}
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		if not by.has(sv):
			by[sv] = []
		by[sv].append(String(id))
	var counts := {}
	for sv2 in [1, 2, 3, 4, 5]:
		counts[sv2] = (by.get(sv2, []) as Array).size()
	# RE-POINTED AT IZ §3 and §5: two removed.
	# RE-POINTED AT JB §2: the four joined.
	ok((_run.MODIFIERS as Dictionary).size() == 25, "§1b: the deck holds %d modifiers, want 25" % (_run.MODIFIERS as Dictionary).size())
	ok(counts == GRADE_COUNTS, "§1b: the grades hold %s — the bands are built on %s" % [str(counts), str(GRADE_COUNTS)])
	for sv3 in [1, 2, 3, 4, 5]:
		print("    severity %d: %s" % [sv3, ", ".join(PackedStringArray((by.get(sv3, []) as Array).map(func(i): return String((_run.MODIFIERS[i] as Dictionary)["name"]))))])
	# RUIN's GAMBLES: the band holds three and is severity 5 alone; no other rung's band reaches it.
	var ruin: Dictionary = _run.DIFFICULTIES["ruin"]
	var gb := _band_members(ruin["gamble_band"])
	# RE-POINTED AT IX §3: severity 5 is the scale's top band, as deep as the costs put it — four since IX.
	ok(gb.size() == int(GRADE_COUNTS[5]) and (ruin["gamble_band"] as Array) == [5, 5], "§1b: Ruin's gamble band %s holds %s — want the %d of severity 5" % [
		str(ruin["gamble_band"]), str(gb), int(GRADE_COUNTS[5])])
	for d in ["wanderer", "warden"]:
		var reach: Array = []
		for k in ["safe_band", "gamble_band"]:
			for id4 in _band_members((_run.DIFFICULTIES[d] as Dictionary)[k]):
				if int(_run.modifier_severity(String(id4))) >= 5:
					reach.append(id4)
		ok(reach.is_empty(), "§1b: %s's bands reach a severity-5 modifier: %s" % [d, str(reach)])
	# THE FIXED ENCOUNTERS draw the eight of severity 3–4, never a 5.
	var fixed := _band_members(_run.FIXED_MODIFIER_BAND)
	# RE-POINTED AT IX §3: the fixed encounters draw whatever the scale grades 3–4 (eight until IX, five at IX, seven at IY §4,
	# six since IZ — Bloodletting reverted to a 1).
	ok(fixed.size() == int(GRADE_COUNTS[3]) + int(GRADE_COUNTS[4]) and (_run.FIXED_MODIFIER_BAND as Array) == [3, 4], "§1b: the fixed band %s holds %d — %s" % [
		str(_run.FIXED_MODIFIER_BAND), fixed.size(), str(fixed)])
	print("    Ruin's gambles: %s; the fixed encounters draw %s" % [str(gb), str(fixed)])
	# THE WORDS THAT COUNT THEM (II §0.7: a figure the text states is read off what decides it, or an instrument holds the two
	# together). `master.html`'s ladder says how many bargains Ruin alone deals, in the band's own number; the glossary's two
	# entries say it with no number, a count no constant holds being a count no text should type.
	var words := ["none", "one", "two", "three", "four", "five", "six"]
	var mh := FileAccess.get_file_as_string("res://docs/master.html")
	var said := "%s bargains no other rung deals" % words[mini(gb.size(), 6)]
	ok(mh.contains(said), "§1b: `master.html`'s ladder does not say '%s' — Ruin's gamble band holds %d" % [said, gb.size()])
	var bad_g: Array = []
	for gid in ["severity", "difficulty_ladder"]:
		var long_t := String(Glossary.entry(gid).get("long", ""))
		if not long_t.contains("bargains no other road deals"):
			bad_g.append("%s: the sentence is gone" % gid)
		for w in words:
			if long_t.contains("%s bargains no other road deals" % w):
				bad_g.append("%s: types '%s'" % [gid, w])
	ok(bad_g.is_empty(), "§1b: the glossary counts Ruin's gambles with a number no constant holds — %s" % str(bad_g))


# EP's sample — 400 offers a rung through the real `roll_offer`, seeded, past the shop gate (IO §1g's instrument). Every Ruin
# offer deals two of the three, distinct; the means read the bands' own arithmetic, and IO's reading is held beside them.
func _s1b_the_sample() -> void:
	print("\n§1b — EP's sample: 400 offers a rung through the real `roll_offer`, seeded, past the shop gate")
	var was := String(_run.difficulty)
	var was_slot := int(_run.slot_idx)
	_run.slot_idx = int(_run.SHOP_GATE_NODES) + 4
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		seed(4004)
		var sum := 0
		var n := 0
		var five := 0
		var short := 0
		var twin := 0
		for _i in 400:
			var offer: Array = _run.roll_offer()
			var gambles: Array = []
			for opt in offer:
				var sv := int(_run.modifier_severity(String(opt["modifier"])))
				sum += sv
				n += 1
				if sv == 5:
					five += 1
					gambles.append(String(opt["modifier"]))
			if offer.size() != 3:
				short += 1
			if d == "ruin" and (gambles.size() != 2 or gambles[0] == gambles[1]):
				twin += 1
		var def: Dictionary = _run.DIFFICULTIES[d]
		var want := (_mean_sev(_band_members(def["safe_band"])) + 2.0 * _mean_sev(_band_members(def["gamble_band"]))) / 3.0
		var mean := float(sum) / maxf(float(n), 1.0)
		ok(n == 1200 and short == 0, "§1b: %s dealt %d options over 400 offers (%d short), want 1,200" % [d, n, short])
		ok(absf(mean - want) < 0.05, "§1b: %s's sample reads %.3f against its bands' arithmetic %.3f" % [d, mean, want])
		ok(absf(mean - float(JB_SAMPLE[d])) < 0.05, "§1b: %s's sample reads %.3f — %+.3f from the held reading %.3f (JB's; IZ read %.3f, IY %.3f, IO %.2f)" % [
			d, mean, mean - float(JB_SAMPLE[d]), float(JB_SAMPLE[d]), float(IZ_SAMPLE[d]), float(IY_SAMPLE[d]), float(IO_SAMPLE[d])])
		if d == "ruin":
			ok(twin == 0 and five == 800, "§1b: Ruin dealt %d severity-5 options, and %d offers without two distinct gambles" % [five, twin])
		else:
			ok(five == 0, "§1b: %s dealt %d severity-5 options — Ruin's alone" % [d, five])
		print("    %-8s mean %.3f — its bands' arithmetic %.3f, IO read %.2f (drift %+.3f); severity-5 options %d" % [
			d, mean, want, float(IO_SAMPLE[d]), mean - float(IO_SAMPLE[d]), five])
	_run.difficulty = was
	_run.slot_idx = was_slot


# ── §2 — THE BOT's POTION ───────────────────────────────────────────────────

# THE REAL TURN LOOP, ON AUTOPLAY, WITH THE SIM's SWITCHES ON: every hero is set below the line, the parked turn is answered,
# and the bot plays on until a hero's turn opens with a drink. **Which hero drinks is the loop's**: the next turn the
# timeline gives, read off the combat log — the gate arranges the state the policy reads, never the drinker. The figure
# landed must be `Run.health_potion_heal` of that hero's maximum (the heal door at a multiplier of one, the wound wider than
# the potion), and the maximum is set so the player's figure and the old flat 40 cannot coincide.
func _s2_the_potion() -> void:
	print("\n§2 — the bot drinks the player's potion: `Run.health_potion_heal` of its own maximum, through the heal door")
	var s: Node = await Gate.spawn(self, ["warden", "pyromancer", "holy", "mystic"], {"deterministic": true})
	ok(s != null, "§2: the board spawned")
	if s == null:
		return
	var heroes: Array = (s.get("heroes") as Array).filter(func(x): return not (x as BattleUnit).is_companion)
	for hh in heroes:
		var h: BattleUnit = hh
		h.max_hp = 1000
		h.hp = 100
		h.healing_received_mult = 1.0
		h.refresh_bars()
	var items: Dictionary = s.get("items")
	items["health"] = [String(_run.ITEM_INFO["health"][0]), 3, String(_run.ITEM_INFO["health"][1])]
	var was_active: bool = RunSim.active
	var was_items: bool = RunSim.items_on
	RunSim.active = true
	RunSim.items_on = true
	var hist: RichTextLabel = s.get("history")
	var seen := hist.get_parsed_text().length()
	var parked: BattleUnit = s.get("current_hero")
	if parked != null:
		s.emit_signal("_ability_picked", parked.abilities[0])
		await process_frame
		s.emit_signal("_target_picked", _foes(s)[0])
	s.set("autoplay", true)
	var line := ""
	var frames := 0
	while frames < 1500 and line == "":
		Engine.time_scale = 100.0
		await process_frame
		frames += 1
		for e in _foes(s):
			if e.hp < 50000:
				e.max_hp = 100000
				e.hp = e.max_hp
		var fresh := hist.get_parsed_text().substr(seen)
		var at := fresh.find("Item: Health Potion — ")
		if at >= 0 and fresh.find("(bot)", at) > 0:
			line = fresh.substr(at, fresh.find("(bot)", at) + 5 - at)
		if bool(s.get("battle_over")):
			break
	Engine.time_scale = 1.0
	s.set("autoplay", false)
	RunSim.active = was_active
	RunSim.items_on = was_items
	ok(line != "", "§2: no bot hero drank in %d frames of autoplay with every hero below the line and three potions carried" % frames)
	if line != "":
		var drinker: BattleUnit = null
		for hh2 in heroes:
			if line.contains("— %s +" % (hh2 as BattleUnit).unit_name):
				drinker = hh2
		var amt := int(line.get_slice("+", 1).get_slice(" ", 0))
		var want := int(_run.health_potion_heal(1000))
		ok(drinker != null and want != 40 and amt == want, "§2: %s (the first hero whose turn opened below the line — the loop's pick, read off the log) drank %d — want %d, `Run.health_potion_heal` of his maximum 1,000 ('%s')" % [
			drinker.unit_name if drinker != null else "nobody", amt, want, line])
		ok(int(items["health"][1]) == 2, "§2: the drink spent %d potions, want one" % (3 - int(items["health"][1])))
		print("    %s drank %d of a 1,000 maximum after %d frames — the player's figure %d" % [
			drinker.unit_name if drinker != null else "nobody", amt, frames, want])
	# THE DRINK NAMES NO FIGURE OF ITS OWN: it reads the function the player's use path reads, and both paths call it.
	var pt := _body("scripts/battle.gd", "_player_turn")
	var dk := pt.substr(pt.find("autoplay and RunSim.active and RunSim.items_on"), 320)
	ok(dk.contains("heal_amount(Run.health_potion_heal(u.max_hp), true)"),
		"§2: the bot's drink does not heal `Run.health_potion_heal` of the drinker's maximum")
	ok(_body("scripts/battle.gd", "_use_item").contains("Run.health_potion_heal(heal_target.max_hp)"),
		"§2: the player's use path does not read `Run.health_potion_heal` (the positive arm: the two read one function)")
	await _clear(s)


# ── §0 — THE RULINGS RECORDED ───────────────────────────────────────────────

func _s0_rulings() -> void:
	print("\n§0 — the rulings recorded where they bind")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var dn := FileAccess.get_file_as_string("res://docs/design-notes.md")
	# RE-POINTED AT JB §0.2: IP's rule was replaced where it stood; the rule that replaced it is the one held once.
	ok(cm.count("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE") == 1, "§0.2: `CLAUDE.md` does not state what costs the party once")
	ok(not ir.contains("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE"), "§0.2: the rule stands in the instrument rules too")
	ok(ir.count("## STANDING RULE — A CUT INSIDE TWO STANDARD ERRORS IS NOT A MEASUREMENT, IT IS A TIE") == 1,
		"§0.4: `docs/instrument-rules.md` does not head the tie rule once")
	ok(ir.count("## STANDING RULE — AN INSTRUMENT'S OWN FIDELITY IS A PREMISE OF EVERY MEASUREMENT IT TAKES") == 1,
		"§2: `docs/instrument-rules.md` does not head the fidelity rule once")
	var sup := ir.find("## STANDING RULE — A GATE THAT SELECTS ITS SUBJECT BY A SUPERLATIVE NAMES THE SUBJECT IT PICKED")
	var sup_end := ir.find("\n## ", sup + 10)
	var block := ir.substr(sup, (sup_end if sup_end > 0 else ir.length()) - sup)
	ok(sup >= 0 and block.contains("A PICK IS A SITE WHEN THE ASSERTION's VERDICT DEPENDS ON WHICH MEMBER WAS PICKED"),
		"§0.8: the site test does not stand in the superlative block")
	# IP's own entry, found by its title: the newest until a later batch wrote above it (re-pointed at IQ — a position pick,
	# the newest entry, moved off IP's entry the day IQ's went on top; the subject is IP's entry wherever it stands).
	var top := dn.find("\n## The deck's last cut, and the instrument's own defect")
	var entry := dn.substr(top, dn.find("\n## ", top + 5) - top) if top >= 0 else ""
	ok(entry.contains("The Hungering Dark") and entry.contains("0.989") and entry.contains("5,349"),
		"§0.2: `docs/design-notes.md`'s entry on the deck's last cut (%s) does not carry the Dark's shape and IO's figures"
		% ("found" if top >= 0 else "not found"))


# ── §7 — THE ARCHIVE ────────────────────────────────────────────────────────

func _s7_the_archive() -> void:
	print("\n§7 — the archive's newest cut stands at its top")
	var arch := FileAccess.get_file_as_string("res://DoD-archive/state-archive.md")
	var codes: Array = []
	var rx := RegEx.new()
	rx.compile("(?m)^## ARCHIVED AT ([A-Z]{2})")
	for m in rx.search_all(arch):
		codes.append(m.get_string(1))
	# IP's cut went at the top, and a later batch's goes above it (re-pointed at IQ, whose own gate holds its cut at the top).
	ok(not codes.is_empty() and String(codes[0]) >= "IP", "§7: the archive's first cut is %s — IP's own or a later batch's goes at the top" % (str(codes[0]) if not codes.is_empty() else "none"))
	print("    cuts, newest first: %s" % " ".join(PackedStringArray(codes.slice(0, 4))))


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
