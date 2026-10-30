# BATCH IO — THE BARGAIN DECK, MEASURED AND RE-CUT.
#
#   §1   THE DECK RE-CUT TO AQ's RULE: nothing binds one side. Famine and Cruel Order are REMOVED, not disabled — no row,
#        no door, no word left in the game's code or data. Wasting binds both sides, DRIVEN both ways: its tick at every
#        unit's turn's end through the tick door, a unit it fells killed by nobody. **The Hungering Dark bound both sides
#        too, and is REMOVED at IP §1a** (two-sidedness did not make it even — `CLAUDE.md`'s ladder block): §1c holds its
#        absence, as §1a holds Famine's and Cruel Order's. The Thin Veil is Feverish's door at its own figure; the Long Silence refuses a second use of any
#        ability but a unit's basic attack, at the hero's button, the bot's every pick and the enemy's re-validation. The
#        texts are read against the text standard; EP's sample deals Wanderer and Warden offer for offer as the floor's
#        split deals them, and no severity-5 modifier reaches either; no modifier zeroes a class's kit.
#   §2   THE LADDER IS GRADED BY MEASUREMENT: the grade counts the bands are built on (6 / 6 / 4 / 4 / 3 since IP §1b), every band
#        non-empty and severity 5 Ruin's gambles alone, the fixed encounters on severity 3–4 and the merchant at each rung's
#        mildest. **NO GRADE IS PINNED HERE**: the grades are IO's measurement (its report, §2), and a re-grade that keeps
#        the counts leaves this gate green — the measurement, not this file, decides a modifier's severity.
#   §4   THE PLAYER IS SHOWN THE DOOR's PRICE: the ability button and the summon picker print `_eff_cost`, so the number and
#        the lit state agree under Warded; Through and Through refunds what the cast paid; every list-price read left in
#        `battle.gd` is the door's own, a definition, or a test of whether a card has a price.
#   §5   A BARGAIN's CHIP: the fight's modifier stands in a strip of its own — BARGAIN or IMPOSED, one chip in its own
#        letters, its pips and its name, the rule on the hover — wearing none of the four glyphs, clear of the turn strip
#        and the combat log; the letters are each modifier's own.
#   §6   THE SUPERLATIVE CENSUS, RE-RUN AFTER ITS REPAIR: every site IO's census found naming its pick in no FAIL line or in
#        some builds the string that names it.
#   §7   THE STATE ARCHIVE TAKES THE NEWEST CUT FIRST.
#   §0   The rulings recorded: the class passive outranks a modifier (`CLAUDE.md`), the census note and the archive's order
#        (`docs/instrument-rules.md`).
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** What a modifier COSTS a party is the sim's (IO's report, §2: each of the
# twenty-four forced on every bargain of a Ruin run; IP's, §1b, for the twenty-three left); this gate holds the shape the measurement was cut into and the doors
# each modifier acts through. §5 drives the strip on a board this gate lays out; that a player reads it is play's.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_io.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §1 — the four of severity 5 as §1 built them, by id: [name, the constant its figure is read off ("" for none)] — less the
# Hungering Dark, removed at IP §1a (it stands in GONE below).
const RECUT := {"wasting": ["Wasting", "WASTING_PCT"],
	"thin_veil": ["The Thin Veil", "THIN_VEIL_PCT"], "long_silence": ["The Long Silence", ""]}
# §1 — the three that left the deck, and every name their doors went by (the Dark's since IP §1a).
const GONE := ["famine", "cruel_order", "hungering_dark"]
const GONE_WORDS := ["famine", "Famine", "cruel_order", "Cruel Order", "_pouch_sealed", "_turn_before", "ROUND_TICKS",
	"hungering_dark", "Hungering Dark", "HUNGERING_DARK_PCT", "_dark_feeds"]
# §2 — the sizes the bands are built on: six at 1, six at 2, four at 3, four at 4, and three at 5 since IP §1b (four
# from IO's brief §2, constraint 1, until the top was cut at the cliff).
# RE-POINTED AT IX §3: a grade is a cost band on the reference party now, so the counts are the scale's arithmetic on IW's
# ladder (six modifiers carry no severity and stand in no band) — a re-measure moves them with the costs, and this line with it.
# RE-POINTED AT IY §2 and §4: the tally the grades hold — the test binds (a cost inside two standard errors has no severity),
# the grade is the highest cost measured on any population (Deadened 3, Brittle 2), and the nine turned handles graded by
# their own measurement (`docs/reports/IY-grades.tsv`).
# RE-POINTED AT IZ §1–§5: the tally the grades hold since IZ — the sharper reading of one population replaces the blunter
# (IZ §0.1), the reverts graded by their own old readings, Dull Edge removed (§3); `docs/reports/IZ-grades.tsv`.
const GRADE_COUNTS := {1: 7, 2: 4, 3: 4, 4: 2, 5: 4}
# §5 — the four glyphs, each meaning one thing (IE §0.1, II §0.4); a bargain's chip is none of them.
const GLYPHS := ["◆", "↑", "✦", "○"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IO — THE BARGAIN DECK, MEASURED AND RE-CUT")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s1a_the_deck()
	await _s1b_wasting()
	await _s1c_the_hungering_dark()
	await _s1d_the_thin_veil()
	await _s1e_the_long_silence()
	_s1f_the_words()
	_s1g_the_sample()
	await _s1h_no_kit_zeroed()
	_s2_the_ladder()
	await _s4_the_door_price()
	await _s5_the_chip()
	_s6_the_picks_named()
	_s7_the_archive()
	_s0_rulings()
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


func _board(specs: Array, over: Dictionary, opts := {}) -> Node:
	var o := {"deterministic": true, "party": over}
	for k in opts:
		o[k] = opts[k]
	var s: Node = await Gate.spawn(self, specs, o)
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
	_run.pending_modifier = ""
	_run.pending_reward = {}
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


# The floor's split — IM's roll as a REFERENCE MODEL, re-pointed off IN's fixed twenty to every modifier of severity 1 to
# 4 (the table Wanderer and Warden draw from, whatever its grades), the merchant behind the gold of the rung's mildest.
# A rung whose bands are the floor's own split is dealt this offer from the same dice, offer for offer.
func _floor_offer(floor_sev: int) -> Array:
	var low: Array = []
	var rest: Array = []
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		# RE-POINTED AT IX §3: a modifier with no severity is in no band, so the floor's split is of the graded deck.
		if sv >= 5 or sv < 1:
			continue
		if sv <= floor_sev:
			low.append(String(id))
		else:
			rest.append(String(id))
	low.shuffle()
	rest.shuffle()
	var picked: Array = []
	if not low.is_empty():
		picked.append(low.pop_front())
	while picked.size() < 3 and not rest.is_empty():
		picked.append(rest.pop_front())
	var offer: Array = []
	for id in picked:
		var sev := int(_run.modifier_severity(String(id)))
		var choices: Array = (_run.REWARDS.get(sev, _run.REWARDS[1]) as Array).duplicate()
		if sev == 1:
			choices.append({"kind": "shop"})
		if _run.shop_gated(int(_run.slot_idx) + 1):
			choices = choices.filter(func(r): return String(r.get("kind", "")) != "shop")
		offer.append({"modifier": String(id), "reward": (choices.pick_random() as Dictionary).duplicate()})
	offer.shuffle()
	return offer


# ── §1a — THE DECK, RE-CUT ──────────────────────────────────────────────────

func _s1a_the_deck() -> void:
	print("\n§1a — the deck re-cut to AQ's rule: three removed, one binds both sides, two new")
	var mods: Dictionary = _run.MODIFIERS
	# RE-POINTED AT IZ §3 and §5: Dull Edge and Tinderbox are removed, so the twenty are eighteen.
	ok(mods.size() == 21, "§1a: the deck holds %d modifiers — twenty, and three at severity 5" % mods.size())
	for id in GONE:
		ok(not mods.has(id), "§1a: `%s` is still in the deck" % id)
	for id2 in RECUT:
		var cfg: Dictionary = mods.get(id2, {})
		ok(String(cfg.get("name", "")) == String(RECUT[id2][0]) and String(cfg.get("desc", "")) != ""
				and int(cfg.get("severity", 0)) >= 1 and int(cfg.get("severity", 0)) <= 5,
			"§1a: `%s` is not in the deck as %s with a rule and a severity (%s)" % [id2, RECUT[id2][0], str(cfg)])
	# REMOVED, NOT DISABLED: no word of either left in the game's code or data, comments set aside (a record of the
	# removal may name them). The POSITIVE arm: the two that replaced them are named where they act.
	var left: Array = []
	var scripts := DirAccess.get_files_at("res://scripts")
	for f in scripts:
		if not String(f).ends_with(".gd"):
			continue
		var src := _src("scripts/" + String(f))
		for w in GONE_WORDS:
			if src.contains(String(w)):
				left.append("%s in scripts/%s" % [w, f])
	for df in DirAccess.get_files_at("res://data"):
		if not String(df).ends_with(".json"):
			continue
		var dsrc := FileAccess.get_file_as_string("res://data/" + String(df))
		for w2 in ["famine", "Famine", "cruel_order", "Cruel Order", "hungering_dark", "Hungering Dark"]:
			if dsrc.contains(String(w2)):
				left.append("%s in data/%s" % [w2, df])
	ok(left.is_empty(), "§1a: the removed three are still named: %s" % str(left))
	var b := _src("scripts/battle.gd")
	ok(b.contains("\"thin_veil\":") and b.contains("\"long_silence\":") and b.contains("\"wasting\":\n\t\t\tpass"),
		"§1a: `_stamp_modifier` has no arm for the Thin Veil, the Long Silence, or Wasting, which stamps nothing")
	print("    the deck: %d modifiers; removed %s; re-cut %s" % [mods.size(), str(GONE), str(RECUT.keys())])


# ── §1b — WASTING: EVERY UNIT's TURN, BOTH SIDES ────────────────────────────

func _s1b_wasting() -> void:
	print("\n§1b — Wasting: whoever took the turn loses its share of its maximum, hero and enemy alike; it names nobody")
	# The Warrior is SEATED holding the Reaver's engine rune, slotted, as class selection hands it — the spawn builds his
	# `engines` (no gate writes one: `check_gw` §2).
	var reaver := Runes.build(Runes.engine_rune_id("savage_assault"))
	reaver["equipped"] = true
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {0: {"engines": [reaver]}})
	var h := _hero(s, "warrior") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and foes.size() >= 2, "§1b: the board seats a Warrior and two enemies")
	if s == null or h == null or foes.size() < 2:
		await _clear(s)
		return
	var e: BattleUnit = foes[0]
	h.max_hp = 1000
	h.hp = 900
	e.max_hp = 1000
	e.hp = 900
	# THE NEGATIVE ARM: no modifier, nothing lost on either side.
	_run.pending_modifier = ""
	ok(not bool(s.call("_wasting_tick", h)) and h.hp == 900 and not bool(s.call("_wasting_tick", e)) and e.hp == 900,
		"§1b: with no modifier Wasting took %d from the hero and %d from the enemy" % [900 - h.hp, 900 - e.hp])
	# BOTH SIDES, THROUGH THE TICK DOOR: a barrier, armor and Less Damage Taken on each, and the loss the constant's.
	_run.pending_modifier = "wasting"
	var want := maxi(int(round(1000 * float(_run.WASTING_PCT))), 1)
	for u in [h, e]:
		var uu: BattleUnit = u
		s.call("_apply_status", uu, "barrier", 3, 500)
		uu.armor = 0.6
		uu.dmg_taken_bonus = 0.5
		var was_src: Variant = s.get("_dmg_src")
		var before := uu.hp
		var died: bool = s.call("_wasting_tick", uu)
		ok(not died and before - uu.hp == want,
			"§1b: under Wasting %s (1,000, a barrier, 60%% armor, Less Damage Taken) lost %d — want %d (%d%% off `WASTING_PCT`)" % [
				uu.unit_name, before - uu.hp, want, int(round(float(_run.WASTING_PCT) * 100))])
		ok(int(uu.get_status("barrier").get("power", 0)) == 500, "§1b: Wasting ate into %s's barrier — it is not a strike" % uu.unit_name)
		ok(s.get("_dmg_src") == was_src, "§1b: the tick on %s left its frame standing" % uu.unit_name)
		uu.remove_status("barrier")
	# A COMPANION TAKES NO TURN, SO IT NEVER WASTES — asked of a body on the board read as a companion (the Mage, for the
	# tick alone), so a broken guard shows as health lost and not as a throw off a body with no bars.
	var comp := _hero(s, "mage")
	if comp != null:
		var comp_hp := comp.hp
		comp.is_companion = true
		var comp_died: bool = s.call("_wasting_tick", comp)
		comp.is_companion = false
		ok(not comp_died and comp.hp == comp_hp, "§1b: %s, read as a companion, wasted %d" % [comp.unit_name, comp_hp - comp.hp])
		comp.hp = comp_hp
	else:
		ok(false, "§1b: the board seats no Mage to read as a companion")
	# A TURN THAT DECIDED THE FIGHT ENDS NOTHING, on either side: the clock stops with the other side's last body.
	var alive_now: Array = foes.filter(func(x): return not (x as BattleUnit).dead)
	for x in alive_now:
		(x as BattleUnit).dead = true
	var hp_won := h.hp
	ok(not bool(s.call("_wasting_tick", h)) and h.hp == hp_won, "§1b: Wasting took %d from a hero on the turn that won the fight" % (hp_won - h.hp))
	for x in alive_now:
		(x as BattleUnit).dead = false
	var side: Array = (s.get("heroes") as Array).filter(func(x): return not (x as BattleUnit).is_companion and not (x as BattleUnit).dead)
	for y in side:
		(y as BattleUnit).dead = true
	var e_hp := e.hp
	ok(not bool(s.call("_wasting_tick", e)) and e.hp == e_hp, "§1b: Wasting took %d from an enemy on the turn that lost the fight" % (e_hp - e.hp))
	for y in side:
		(y as BattleUnit).dead = false
	# A UNIT IT FELLS WAS KILLED BY NOBODY: a Reaver standing beside the dying enemy is credited no kill — and the same
	# Reaver, framed as the dealer of a tick that fells the other enemy, is (the positive arm: the credit door works).
	ok(h.has_engine("savage_assault"), "§1b: the premise — the Warrior was seated with the Reaver's engine (%s)" % str(h.engines))
	h.reaver_kills = 0
	e.hp = 3
	s.call("_dmg_frame", h, "probe")
	var felled: bool = s.call("_wasting_tick", e)
	ok(felled and e.dead and h.reaver_kills == 0,
		"§1b: %s (the warband's first) at 3 under Wasting fell %s and the Reaver standing in the frame before it was credited %d kill(s) — want a death credited to nobody" % [
			e.unit_name, str(felled), h.reaver_kills])
	var e2: BattleUnit = foes[1]
	e2.hp = 3
	s.call("_dmg_frame", h, "probe")
	e2.take_tick_damage(10, "-10", Color.WHITE)
	ok(e2.dead and h.reaver_kills == 1, "§1b: the Reaver's own tick felled %s and he was credited %d — the credit door is not live" % [
		e2.unit_name, h.reaver_kills])
	s.call("_dmg_frame", null, "")
	# A HERO IT FELLS FALLS, as a tick fells one.
	h.hp = 3
	ok(bool(s.call("_wasting_tick", h)) and h.dead, "§1b: a hero at 3 health under Wasting did not fall")
	# EVERY PLACE A TURN ENDS CALLS IT: the hero's, the enemy's, and the three lost-turn branches either side meets.
	var rb := _body("scripts/battle.gd", "_run_battle")
	ok(rb.count("_wasting_tick(u)") == 5, "§1b: `_run_battle` calls the tick %d times, want 5 (the hero's turn, the enemy's, stunned, frozen, Broken)" % rb.count("_wasting_tick(u)"))
	ok(rb.find("await _enemy_turn(u)") >= 0 and rb.find("_wasting_tick(u)", rb.find("await _enemy_turn(u)")) > rb.find("_declare_intent(u)", rb.find("await _enemy_turn(u)")),
		"§1b: the enemy's tick does not stand below its declaration (BL §1: the declaration is right after the turn)")
	var wt := _body("scripts/battle.gd", "_wasting_tick")
	ok(wt.contains("take_tick_damage(") and wt.contains("_dmg_frame(null, ws_name, ws_name)") and not wt.contains("not u.is_hero"),
		"§1b: Wasting does not go through the tick door under a frame naming nobody, or still reads one side")
	await _clear(s)


# ── §1c — THE HUNGERING DARK, REMOVED AT IP §1a: NO DEALER IS FED, AND THE HEAL DOOR IS ONE DOOR AGAIN ────
#
# Re-pointed at IP in place of IO's arms that fed both sides: two-sidedness did not make the Dark even (`CLAUDE.md`'s ladder
# block), so it left the deck with its door and the heal door's `unowned` parameter, which nothing else reached. A save
# written before IP can still carry its id as the bargain in force: the fight reads the deck for it, so a blow under it
# feeds neither side. The POSITIVE arm keeps IO's: an ordinary heal still forks and re-arms (the riders are live), so the
# heal door the Dark had its own way through is the one every heal takes.
func _s1c_the_hungering_dark() -> void:
	print("\n§1c — the Hungering Dark, removed: no dealer fed, on either side; the heal door is the one door every heal takes")
	var lw := Runes.build("last_word")
	lw["equipped"] = true
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {0: {"runes": [lw]}})
	var h := _hero(s, "warrior") if s != null else null
	var m := _hero(s, "mage") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and m != null and foes.size() >= 2, "§1c: the board seats a Warrior, a Mage and two enemies")
	if s == null or h == null or m == null or foes.size() < 2:
		await _clear(s)
		return
	var e: BattleUnit = foes[0]
	e.max_hp = 2000
	h.max_hp = 5000
	h.armor = 0.0
	# BOTH WAYS, under the id a pre-IP save can carry: [dealer, victim]. Neither dealer is fed.
	for arm in [[e, h], [h, e]]:
		e.hp = 1000
		h.hp = 3000
		_run.pending_modifier = "hungering_dark"
		var dealer: BattleUnit = arm[0]
		var victim: BattleUnit = arm[1]
		s.call("_dmg_frame", dealer, "probe")
		var d_before := dealer.hp
		var v_before := victim.hp
		victim.take_tick_damage(200, "-200", Color.WHITE)
		ok(v_before > victim.hp and dealer.hp == d_before, "§1c: under a pre-IP save's `hungering_dark`, %s dealing %d to %s was fed %d — the Dark is gone" % [
			dealer.unit_name, v_before - victim.hp, victim.unit_name, dealer.hp - d_before])
	ok(String(s.call("_active_modifier")) == "", "§1c: the removed id is read as the modifier in force ('%s')" % String(s.call("_active_modifier")))
	_run.pending_modifier = ""
	# THE POSITIVE ARM (IO's): an ordinary heal of a Warrior one point under the Last Word's line, the Mage below his share,
	# forks to her and re-arms the rune — every heal takes the riders now, there being no door around them.
	var vig_hp := 100
	m.max_hp = 1000
	m.hp = vig_hp
	s.call("_apply_status", h, "vigil", 3, 0, 0, h)
	ok(h.rune_last_word > 0, "§1c: the premise — the Warrior wears the Last Word (its field %s)" % str(h.rune_last_word))
	h.hp = int(h.max_hp * BattleUnit.LAST_WORD_AT) - 1
	h.last_word_armed = false
	h.heal_amount(150)
	ok(m.hp > vig_hp and h.last_word_armed, "§1c: an ordinary heal of 150 did not fork to the Mage (%d) or re-arm the Last Word (%s) — the riders are not live" % [
		m.hp, str(h.last_word_armed)])
	h.remove_status("vigil")
	s.call("_dmg_frame", null, "")
	ok(_body("scripts/battle.gd", "_on_damage_taken").contains("_rule_engines_on_damage(victim, lost)")
			and _body("scripts/battle.gd", "_dark_feeds") == "",
		"§1c: BL's damage door was not found, or the Dark's feed still stands")
	var ha := _body("scripts/unit.gd", "heal_amount")
	ok(ha.begins_with("\nfunc heal_amount(amount: int, external := false) -> int:") and not ha.contains("unowned"),
		"§1c: `heal_amount` is not the two-parameter door, or still names the `unowned` door")
	await _clear(s)


# ── §1d — THE THIN VEIL: FEVERISH's DOOR, AT ITS OWN FIGURE ─────────────────

func _s1d_the_thin_veil() -> void:
	print("\n§1d — the Thin Veil: everyone's Attack raised by `THIN_VEIL_PCT`, both sides, a companion's already")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	ok(s != null, "§1d: the board spawned")
	if s == null:
		return
	var units: Array = (s.get("heroes") as Array) + (s.get("enemies") as Array)
	var was := {}
	for u in units:
		was[u] = (u as BattleUnit).attack
	_run.pending_modifier = "thin_veil"
	s.call("_apply_battle_modifier")
	var bad: Array = []
	for u2 in units:
		var w := int(round(int(was[u2]) * (1.0 + float(_run.THIN_VEIL_PCT))))
		if (u2 as BattleUnit).attack != w:
			bad.append("%s %d→%d (want %d)" % [(u2 as BattleUnit).unit_name, was[u2], (u2 as BattleUnit).attack, w])
	ok(bad.is_empty() and units.size() >= 6, "§1d: under the Thin Veil the Attack moved wrong on %s — over %d units" % [str(bad), units.size()])
	# A COMPANION ARRIVES WITH ITS HUNTER's ATTACK ALREADY RAISED: stamped as inherited, it is not raised twice.
	var comp := BattleUnit.new()
	comp.attack = 100
	s.call("_stamp_modifier", comp, "thin_veil", true)
	ok(comp.attack == 100, "§1d: an inherited companion's Attack was raised again (%d)" % comp.attack)
	s.call("_stamp_modifier", comp, "thin_veil", false)
	ok(comp.attack == int(round(100 * (1.0 + float(_run.THIN_VEIL_PCT)))), "§1d: a fresh unit's Attack read %d" % comp.attack)
	comp.free()
	var sm := _body("scripts/battle.gd", "_stamp_modifier")
	# BATCH IT §3b — RE-POINTED: 160 characters ran 48 into the `long_silence` arm; the slice is the Thin Veil's own arm.
	var tv_at := sm.find("\"thin_veil\":")
	var tv := Gate.block(sm, tv_at)
	ok(Gate.within(sm, tv_at, tv), "§1d: the Thin Veil slice ends inside its own arm — it does not run into the Long Silence's")
	ok(tv.contains("if not inherited:") and tv.contains("u.attack = int(round(u.attack * (1.0 + Run.THIN_VEIL_PCT)))"),
		"§1d: the Thin Veil is not Feverish's door read off its constant")
	print("    %d units' Attack raised by %d%%" % [units.size(), int(round(float(_run.THIN_VEIL_PCT) * 100))])
	await _clear(s)


# ── §1e — THE LONG SILENCE: EACH ABILITY ONCE, THE BASIC ALWAYS ─────────────

func _s1e_the_long_silence() -> void:
	print("\n§1e — the Long Silence: a second use of any ability but the basic is refused at every door that chooses one")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	var h := _hero(s, "warrior") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and not foes.is_empty(), "§1e: the board seats a Warrior and a warband")
	if s == null or h == null or foes.is_empty():
		await _clear(s)
		return
	var crush: Ability = s.call("_find_ability", h, "Crushing Blow")
	ok(crush != null, "§1e: the Warrior holds Crushing Blow (his class kit)")
	if crush == null:
		await _clear(s)
		return
	# THE NEGATIVE ARM: no modifier, a cast books nothing and the card comes back off its cooldown.
	_run.pending_modifier = ""
	h.resource = h.max_resource
	await s.call("_resolve", h, crush, foes[0], "good")
	h.cooldowns.clear()
	ok(h.silence_spent.is_empty() and h.ability_ready(crush), "§1e: with no modifier a cast booked %s or left the card unready" % str(h.silence_spent))
	# THE SILENCE, STAMPED BY ITS DOOR.
	_run.pending_modifier = "long_silence"
	s.call("_apply_battle_modifier")
	var units: Array = (s.get("heroes") as Array) + (s.get("enemies") as Array)
	var unstamped: Array = units.filter(func(u): return not (u as BattleUnit).mod_silence)
	ok(unstamped.is_empty(), "§1e: the Silence did not stamp %s" % str(unstamped.map(func(u): return (u as BattleUnit).unit_name)))
	ok(h.silence_basic == h.abilities[0].display_name, "§1e: the Warrior's exempt ability reads '%s' — want his slot 0, %s" % [
		h.silence_basic, h.abilities[0].display_name])
	# A CAST BOOKS IT AT THE SPEND LINE; THE CARD IS SPENT; THE BUTTON IS DARK AND SAYS WHY.
	h.resource = h.max_resource
	await s.call("_resolve", h, crush, foes[0], "good")
	h.cooldowns.clear()
	h.resource = h.max_resource
	ok(h.silence_spent.has("Crushing Blow") and not h.ability_ready(crush) and not bool(s.call("_ability_usable", h, crush)),
		"§1e: Crushing Blow cast under the Silence: booked %s, ready %s, usable %s" % [str(h.silence_spent.keys()),
			h.ability_ready(crush), s.call("_ability_usable", h, crush)])
	var tip := String(s.call("_ability_tooltip", h, crush))
	ok(tip.contains("Used this fight") and tip.contains(String((_run.MODIFIERS["long_silence"] as Dictionary)["name"])),
		"§1e: the spent card's hover does not say why it is dark: '%s'" % tip.right(120))
	# THE BASIC IS NEVER REFUSED, however often it is used.
	var basic: Ability = h.abilities[0]
	for _i in 3:
		await s.call("_resolve", h, basic, foes[0], "good")
	ok(h.ability_ready(basic) and bool(s.call("_ability_usable", h, basic)), "§1e: the basic attack (%s, the Warrior's slot 0) was refused after three uses" % basic.display_name)
	# A COUNTER IS NOT A USE (the spend line's own `not is_counter`).
	var pommel: Ability = s.call("_find_ability", h, "Pommel Strike")
	if pommel != null:
		await s.call("_resolve", h, pommel, foes[0], "good", true)
		ok(not h.silence_spent.has("Pommel Strike"), "§1e: a counter booked Pommel Strike as a use")
	# THE BOT CHOOSES WHAT IT DRIVES (IN §0.7): each hero's own pick, cast through the real door until the hand is spent —
	# never a card the Silence refuses.
	var offered := 0
	var refused: Array = []
	for hh in s.get("heroes"):
		var hu: BattleUnit = hh
		if hu.is_companion or hu.dead:
			continue
		for _j in 12:
			hu.cooldowns.clear()
			hu.resource = hu.max_resource
			var pick: Array = s.call("_autoplay_pick", hu)
			if pick.is_empty() or pick[0] == null:
				continue
			offered += 1
			if hu.silenced(pick[0] as Ability):
				refused.append("%s → %s" % [hu.unit_name, (pick[0] as Ability).display_name])
			var tgt: Variant = pick[1] if pick.size() > 1 else null
			if tgt == null or not is_instance_valid(tgt) or (tgt as BattleUnit).dead:
				tgt = _foes(s)[0] if not _foes(s).is_empty() else hu
			await s.call("_resolve", hu, pick[0], tgt, "good")
			for f in _foes(s):
				(f as BattleUnit).hp = (f as BattleUnit).max_hp
	ok(offered >= 20 and refused.is_empty(), "§1e: over %d of the bot's own picks cast in turn, it chose spent cards: %s" % [offered, str(refused)])
	print("    the bot's picks under the Silence: %d, none spent" % offered)
	# THE ENEMY: a used ability falls back at re-validation, and the declaration a turn ahead names the basic.
	var e: BattleUnit = null
	for f2 in _foes(s):
		var fu: BattleUnit = f2
		var basic_e: Ability = s.call("_cheapest_attack", fu)
		if basic_e != null and fu.abilities.any(func(a): return a != basic_e and (a as Ability).damage > 0):
			e = fu
			break
	ok(e != null, "§1e: no enemy on the board holds an attack beside its basic")
	if e != null:
		var eb: Ability = s.call("_cheapest_attack", e)
		ok(e.silence_basic == eb.display_name, "§1e: %s's exempt ability reads '%s' — want its cheapest attack, %s" % [
			e.unit_name, e.silence_basic, eb.display_name])
		var other: Ability = null
		for a2 in e.abilities:
			if a2 != eb and (a2 as Ability).damage > 0:
				other = a2
				break
		# The use is booked by a real cast at `_resolve`'s spend line (the hero's arm above drives the same line), never by hand.
		await s._resolve(e, other, h, "good")
		ok(not bool(s.call("_intent_ability_usable", e, other)) and bool(s.call("_intent_ability_usable", e, eb)),
			"§1e: %s's spent %s is usable at re-validation, or its basic %s is not" % [e.unit_name, other.display_name, eb.display_name])
		var spent_named := 0
		for _k in 20:
			s.call("_declare_intent", e)
			var dab: Variant = e.intent.get("ability")
			if dab != null and e.silenced(dab as Ability):
				spent_named += 1
		ok(spent_named == 0, "§1e: %s declared a spent ability %d times in 20 — the telegraph showed a move it can no longer make" % [
			e.unit_name, spent_named])
		# A PSYCHOSIS TURN's SUPPORT PICK asks the Silence too (`_psychotic_support`): a mend first in the enemy's kit is the pick
		# while unspent (the positive arm), and once a real cast has booked it at `_resolve`'s spend line it is not picked again.
		var mend: Ability = Ability.make({"display_name": "IO Probe Wave", "special": "healing_wave", "cost": 0})
		e.abilities.insert(0, mend)
		var ps_before: Array = s.call("_psychotic_support", e)
		await s._resolve(e, mend, e, "good")
		var ps_after: Array = s.call("_psychotic_support", e)
		ok(not ps_before.is_empty() and ps_before[0] == mend and e.silenced(mend) and (ps_after.is_empty() or ps_after[0] != mend),
			"§1e: %s's Psychosis support pick read %s before the mend was cast and %s after (spent %s) — want the mend, then not it" % [
				e.unit_name, str(ps_before.map(func(x): return (x as Ability).display_name if x is Ability else ((x as BattleUnit).unit_name if x is BattleUnit else str(x)))),
				str(ps_after.map(func(x): return (x as Ability).display_name if x is Ability else ((x as BattleUnit).unit_name if x is BattleUnit else str(x)))), str(e.silenced(mend))])
		e.abilities.erase(mend)
	var iu := _body("scripts/battle.gd", "_intent_ability_usable")
	ok(iu.contains("if u.silenced(ab):"), "§1e: the enemy's re-validation does not ask the Silence")
	await _clear(s)


# ── §1f — THE WORDS ─────────────────────────────────────────────────────────

func _s1f_the_words() -> void:
	print("\n§1f — the re-cut texts, the glossary's entries and master.html's rows")
	for id in RECUT:
		var desc := String((_run.MODIFIERS[id] as Dictionary)["desc"])
		var konst := String(RECUT[id][1])
		if konst != "":
			var fig := "%d%%" % int(round(float(_run.get(konst)) * 100))
			ok(desc.contains(fig), "§1f: `%s` does not state %s off `%s`: '%s'" % [id, fig, konst, desc])
		var low := " " + desc.to_lower() + " "
		var pron: Array = [" his ", " her ", " he ", " she ", " him ", " their ", " they ", " you ", " your "].filter(func(w): return low.contains(w))
		var retired: Array = ["party", "ally", "allies", "beast"].filter(func(w): return low.contains(" " + w))
		ok(pron.is_empty() and retired.is_empty(), "§1f: `%s` carries %s — '%s'" % [id, str(pron + retired), desc])
	# BOTH SIDES SAID ON EACH TWO-SIDED RULE THAT HAD ONE SIDE (Wasting; the Dark's text went with it at IP §1a).
	for id2 in ["wasting"]:
		ok(String((_run.MODIFIERS[id2] as Dictionary)["desc"]).contains("heroes and enemies alike"),
			"§1f: `%s` does not say it binds both sides" % id2)
	var mod_e := String(Glossary.entry("modifier").get("long", ""))
	ok(mod_e.contains("EVERY MODIFIER BINDS BOTH SIDES") and mod_e.contains("nothing in the deck binds one side")
			and not mod_e.contains("RUIN'S FOUR bind one side") and not mod_e.contains("bind one side —"),
		"§1f: the modifier entry does not say every modifier binds both sides, or still says Ruin's four bind one")
	var sev := String(Glossary.entry("severity").get("long", ""))
	ok(sev.contains("severity of 1 to 5") and sev.contains("A SEVERITY IS A RANK BY WHAT A MODIFIER COSTS"),
		"§1f: the severity entry does not say a severity is a rank by what the modifier costs")
	var mh := FileAccess.get_file_as_string("res://docs/master.html")
	var rows_bad: Array = []
	for id3 in _run.MODIFIERS:
		var cfg: Dictionary = _run.MODIFIERS[id3]
		# RE-POINTED AT IX §3: a modifier with no severity is written with a dash where its grade would stand.
		var sev_cell := "—" if int(cfg["severity"]) == 0 else str(int(cfg["severity"]))
		if not mh.contains("<td>%s</td><td>%s</td>" % [String(cfg["name"]), sev_cell]):
			rows_bad.append("%s %d" % [cfg["name"], cfg["severity"]])
	ok(rows_bad.is_empty(), "§1f: `master.html`'s modifier table has no row at its grade for %s" % str(rows_bad))
	for gone in ["Famine", "Cruel Order", "The Hungering Dark"]:
		ok(not mh.contains("<td>%s</td>" % gone), "§1f: `master.html` still has a row for %s" % gone)


# ── §1g — EP's SAMPLE, THROUGH THE REAL ROLL ────────────────────────────────

func _s1g_the_sample() -> void:
	print("\n§1g — EP's sample: 400 offers a rung through the real `roll_offer`, seeded, past the shop gate")
	var was := String(_run.difficulty)
	var was_slot := int(_run.slot_idx)
	_run.slot_idx = int(_run.SHOP_GATE_NODES) + 4
	var means := {}
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		seed(4004)
		var dealt: Array = []
		for _i in 400:
			dealt.append(_run.roll_offer())
		var dist := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
		var sum := 0
		var n := 0
		var sh := 0
		for offer in dealt:
			for opt in offer:
				var sv := int(_run.modifier_severity(String(opt["modifier"])))
				dist[sv] = int(dist.get(sv, 0)) + 1
				sum += sv
				n += 1
				if String((opt["reward"] as Dictionary).get("kind", "")) == "shop":
					sh += 1
		ok(n == 1200, "§1g: %s dealt %d options over 400 offers, want 1,200" % [d, n])
		means[d] = float(sum) / maxf(float(n), 1.0)
		print("    %-8s mean severity %.2f — by severity 1-5 %d / %d / %d / %d / %d — the merchant on %d" % [
			d, means[d], dist[1], dist[2], dist[3], dist[4], dist[5], sh])
		if d != "ruin":
			ok(int(dist[5]) == 0, "§1g: %s dealt %d severity-5 options — Ruin's alone" % [d, dist[5]])
			var fl := int(((_run.DIFFICULTIES[d] as Dictionary)["safe_band"] as Array)[1])
			seed(4004)
			var same := 0
			var first_diff := -1
			for i in 400:
				if str(_floor_offer(fl)) == str(dealt[i]):
					same += 1
				elif first_diff < 0:
					first_diff = i
			ok(same == 400, "§1g: %s's offers are not the floor's split — %d of 400 (first to differ: #%d)" % [d, same, first_diff])
	_run.difficulty = was
	_run.slot_idx = was_slot
	var ruin_def: Dictionary = _run.DIFFICULTIES["ruin"]
	var want := (_mean_sev(_band_members(ruin_def["safe_band"])) + 2.0 * _mean_sev(_band_members(ruin_def["gamble_band"]))) / 3.0
	ok(float(means["ruin"]) >= float(means["warden"]) + 1.0, "§1g: Ruin reads %.2f against Warden's %.2f — not a full step above it" % [
		means["ruin"], means["warden"]])
	ok(absf(float(means["ruin"]) - want) < 0.10, "§1g: Ruin's sample reads %.2f against its bands' arithmetic %.2f" % [means["ruin"], want])


# ── §1h — NONE OF THE FOUR ZEROES A CLASS's KIT ─────────────────────────────

func _s1h_no_kit_zeroed() -> void:
	print("\n§1h — no severity-5 modifier zeroes a class's kit: under the Silence every hero's basic stands after every card is spent")
	var stood := 0
	var fell: Array = []
	for party in [["berserker", "pyromancer", "holy", "beastmaster"], ["warden", "cryomancer", "inquisitor", "mystic"],
			["swordmaster", "arcanist", "occultist", "sharpshooter"]]:
		var s: Node = await _board(party, {}, {"lineage_cards": true})
		if s == null:
			ok(false, "§1h: a board for %s did not spawn" % str(party))
			continue
		_run.pending_modifier = "long_silence"
		s.call("_apply_battle_modifier")
		for hh in s.get("heroes"):
			var hu: BattleUnit = hh
			if hu.is_companion:
				continue
			for a in hu.abilities:
				hu.silence_spent[(a as Ability).display_name] = true
			hu.cooldowns.clear()
			hu.resource = hu.max_resource
			if hu.ability_ready(hu.abilities[0]) and bool(s.call("_ability_usable", hu, hu.abilities[0])):
				stood += 1
			else:
				fell.append("%s (%s)" % [hu.unit_name, hu.abilities[0].display_name])
		await _clear(s)
	ok(stood == 12 and fell.is_empty(), "§1h: with every card spent under the Silence, %d of 12 heroes kept their basic: %s" % [stood, str(fell)])
	# The other two act through doors no kit reads: no class, lineage or engine test in either. Wasting's door is read here;
	# the Dark's went with it at IP §1a, and a door that is not found is not a door that reads nothing (IP's census found the
	# arm passing on the deleted body's empty string).
	for fn in ["_wasting_tick"]:
		var bd := _body("scripts/battle.gd", fn)
		ok(bd != "" and not bd.contains("has_engine(") and not bd.contains("hero_key") and not bd.contains("hero_spec"),
			"§1h: `%s` was not found, or reads a class, a lineage or an engine" % fn)


# ── §2 — THE LADDER, GRADED BY MEASUREMENT ──────────────────────────────────

func _s2_the_ladder() -> void:
	print("\n§2 — the grades are IO's measurement; the shape they are cut into is held here")
	var by := {}
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		if not by.has(sv):
			by[sv] = []
		by[sv].append(String(id))
	var counts := {}
	for sv2 in [1, 2, 3, 4, 5]:
		counts[sv2] = (by.get(sv2, []) as Array).size()
	ok(counts == GRADE_COUNTS, "§2: the grades hold %s — the bands are built on %s" % [str(counts), str(GRADE_COUNTS)])
	for sv3 in [1, 2, 3, 4, 5]:
		print("    severity %d: %s" % [sv3, ", ".join(PackedStringArray((by.get(sv3, []) as Array).map(func(i): return String((_run.MODIFIERS[i] as Dictionary)["name"]))))])
	# THE BANDS: severity 5 is Ruin's gambles alone; no Wanderer or Warden band reaches it; none empty, none overlapping at Ruin.
	var ruin_gb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary)["gamble_band"]
	var ruin_sb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary)["safe_band"]
	ok(ruin_gb == [5, 5] and ruin_sb == [3, 4], "§2: Ruin's bands are %s / %s — want 3–4 and 5 alone" % [str(ruin_sb), str(ruin_gb)])
	for d in ["wanderer", "warden"]:
		var reach: Array = []
		for k in ["safe_band", "gamble_band"]:
			for id3 in _band_members((_run.DIFFICULTIES[d] as Dictionary)[k]):
				if int(_run.modifier_severity(String(id3))) >= 5:
					reach.append(id3)
		ok(reach.is_empty(), "§2: %s's bands reach a severity-5 modifier: %s" % [d, str(reach)])
	for d2 in ["wanderer", "warden", "ruin"]:
		for k2 in ["safe_band", "gamble_band"]:
			var mem := _band_members((_run.DIFFICULTIES[d2] as Dictionary)[k2])
			ok(mem.size() >= (2 if k2 == "gamble_band" else 1), "§2: %s's %s holds %d" % [d2, k2, mem.size()])
	# §0.7 — SEVERITY 5's GOLD IS THE GROWING SLOPE's NEXT STEP: the steps grow by a constant amount, so the next is the
	# last step plus that growth (40, 60, 80 → 100), derived off the table and never typed.
	var gold := {}
	for sv4 in [1, 2, 3, 4, 5]:
		for r in (_run.REWARDS.get(sv4, []) as Array):
			if String((r as Dictionary).get("kind", "")) == "gold":
				gold[sv4] = int((r as Dictionary).get("amount", 0))
	var steps: Array = []
	for sv5 in [2, 3, 4]:
		steps.append(int(gold.get(sv5, 0)) - int(gold.get(sv5 - 1, 0)))
	var growth := int(steps[2]) - int(steps[1])
	var even: bool = int(steps[1]) - int(steps[0]) == growth
	var want5 := int(gold.get(4, 0)) + int(steps[2]) + growth
	ok(even and int(gold.get(5, 0)) == want5, "§0.7: severity 5 pays %s gold — the steps are %s, growing by %d, so the next is %d and the row %d" % [
		str(gold.get(5, "none")), str(steps), growth, int(steps[2]) + growth, want5])
	var k4: Array = (_run.REWARDS.get(4, []) as Array).map(func(r): return String(r.get("kind", "")))
	var k5: Array = (_run.REWARDS.get(5, []) as Array).map(func(r): return String(r.get("kind", "")))
	ok(k5 == k4, "§0.7: severity 5 pays %s where severity 4 pays %s" % [str(k5), str(k4)])
	print("    the gold reads %s — steps %s, growing by %d: severity 5 pays %d or a rune" % [
		str([gold.get(1), gold.get(2), gold.get(3), gold.get(4), gold.get(5)]), str(steps), growth, int(gold.get(5, 0))])
	# THE FIXED ENCOUNTERS DRAW FROM SEVERITY 3–4, WHATEVER THE GRADES PUT THERE.
	var was := String(_run.difficulty)
	var was_mod := String(_run.pending_modifier)
	_run.difficulty = "ruin"
	seed(51)
	var seen := {}
	for _i in 400:
		_run.pending_modifier = ""
		_run.arm_fixed_modifier("boss")
		seen[String(_run.pending_modifier)] = true
	_run.pending_modifier = was_mod
	_run.difficulty = was
	var got: Array = seen.keys()
	got.sort()
	var want := _band_members([3, 4])
	want.sort()
	ok(got == want, "§2: 400 fixed draws at Ruin read %s — want severity 3–4, %s" % [str(got), str(want)])
	print("    Ruin's fixed encounters draw: %s" % ", ".join(PackedStringArray(got.map(func(i): return String((_run.MODIFIERS[i] as Dictionary)["name"])))))
	# THE MERCHANT AT EACH RUNG's MILDEST DEALT.
	for d3 in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d3
		var lo := 99
		for k3 in ["safe_band", "gamble_band"]:
			for id4 in _band_members((_run.DIFFICULTIES[d3] as Dictionary)[k3]):
				lo = mini(lo, int(_run.modifier_severity(String(id4))))
		ok(int(_run.mildest_dealt_severity()) == lo, "§2: %s's mildest dealt reads %d — its bands say %d" % [d3, _run.mildest_dealt_severity(), lo])
	_run.difficulty = was


# ── §4 — THE DOOR's PRICE, SHOWN ────────────────────────────────────────────

func _s4_the_door_price() -> void:
	print("\n§4 — the ability button and the summon picker print the door's price; the refund gives back what was paid")
	var s: Node = await _board(["warden", "pyromancer", "holy", "beastmaster"], {})
	var h := _hero(s, "warrior") if s != null else null
	var hu := _hero(s, "hunter") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and hu != null and not foes.is_empty(), "§4: the board seats a Warrior, a Hunter and a warband")
	if s == null or h == null or hu == null or foes.is_empty():
		await _clear(s)
		return
	var crush: Ability = s.call("_find_ability", h, "Crushing Blow")
	h.mod_cost_mult = 1.25
	var door := int(s.call("_eff_cost", h, crush))
	var popup := PopupPanel.new()
	root.add_child(popup)
	# Between the list price and the door's: dark, and the label says the door's price.
	h.resource = crush.cost
	var b1: Button = s.call("_ability_popup_button", h, crush, popup)
	ok(door > crush.cost and b1.text.contains("%d %s" % [door, h.resource_name]) and not b1.text.contains("%d %s" % [crush.cost, h.resource_name])
			and b1.disabled,
		"§4: under Warded, with %d %s, Crushing Blow's button reads '%s' (disabled %s) — want the door's %d, dark" % [
			h.resource, h.resource_name, b1.text, b1.disabled, door])
	h.resource = door
	var b2: Button = s.call("_ability_popup_button", h, crush, popup)
	ok(b2.text.contains("%d %s" % [door, h.resource_name]) and not b2.disabled,
		"§4: at the door's price the button reads '%s' (disabled %s)" % [b2.text, b2.disabled])
	popup.queue_free()
	h.mod_cost_mult = 1.0
	# THE SUMMON PICKER, the same.
	hu.mod_cost_mult = 1.25
	hu.resource = hu.max_resource
	s.call("_open_summon_picker", hu)
	var opts: Array = s.get("_summon_opts")
	var btns: Array = s.get("_summon_btns")
	var bad: Array = []
	for i in mini(opts.size(), btns.size()):
		var ab: Ability = opts[i]
		var want := int(s.call("_eff_cost", hu, ab))
		if not (btns[i] as Button).text.contains("%d %s" % [want, hu.resource_name]):
			bad.append("%s '%s' (want %d)" % [ab.display_name, (btns[i] as Button).text, want])
	ok(not opts.is_empty() and bad.is_empty(), "§4: under Warded the summon picker prints %s" % str(bad))
	s.call("_close_summon_picker")
	hu.mod_cost_mult = 1.0
	# THROUGH AND THROUGH, set by hand (DORMANT in play: nothing writes the field since FX). The refund is isolated as the
	# difference between the same cast on the same dice with the field off and on: under Warded it is the door's dearer
	# price, and a free cast (Twin Hunt's waiver) pays back nothing — the list price would have been a free lunch.
	h.crit_bonus = 5.0
	var refunds := {}
	for arm in [["warded", 1.25, 0], ["free", 1.0, 1]]:
		var ends := []
		var paid := 0
		for tt in [0, 1]:
			h.through_and_through = tt
			h.mod_cost_mult = float(arm[1])
			h.free_ability = int(arm[2])
			h.cooldowns.clear()
			h.resource = 50
			for f in _foes(s):
				(f as BattleUnit).hp = (f as BattleUnit).max_hp
			paid = int(s.call("_eff_cost", h, crush, foes[0]))
			seed(909)
			await s.call("_resolve", h, crush, foes[0], "good")
			ends.append(h.resource)
		refunds[arm[0]] = [int(ends[1]) - int(ends[0]), paid]
	ok(int(refunds["warded"][0]) == int(refunds["warded"][1]) and int(refunds["warded"][1]) > crush.cost
			and int(refunds["free"][0]) == 0 and int(refunds["free"][1]) == 0,
		"§4: Through and Through refunded %s (refund, paid) — want the door's price under Warded (list %d) and nothing on a free cast" % [
			str(refunds), crush.cost])
	h.through_and_through = 0
	h.mod_cost_mult = 1.0
	h.free_ability = 0
	h.cooldowns.clear()
	# THE SWEEP: every `.cost` read in `battle.gd` is the door's own (inside `_eff_cost`), the call priced off its card, or
	# a test of whether a card has a price at all — none prints one or pays one back.
	var lines := _src("scripts/battle.gd").split("\n")
	var fn := ""
	var kinds := {"door": 0, "definition": 0, "kind test": 0}
	var other: Array = []
	var rx := RegEx.new()
	rx.compile("\\b\\w+\\.cost\\b")
	for ln in lines:
		var l := String(ln)
		if l.begins_with("func "):
			fn = l.substr(5, l.find("(") - 5)
		for m in rx.search_all(l):
			var at := m.get_start()
			var tail := l.substr(m.get_end(), 6)
			if fn == "_eff_cost":
				kinds["door"] += 1
			elif l.contains("call.cost = card.cost"):
				kinds["definition"] += 1
			elif tail.begins_with(" > 0") or tail.begins_with(" == 0"):
				kinds["kind test"] += 1
			else:
				other.append("%s: %s" % [fn, l.strip_edges().left(90)])
	ok(other.is_empty(), "§4: `battle.gd` reads a list price outside the door, a definition and a price test: %s" % str(other))
	print("    `.cost` reads in battle.gd: %s — and nothing else" % str(kinds))
	var pb := _body("scripts/battle.gd", "_ability_popup_button")
	ok(pb.contains("label += \"   %d %s\" % [_eff_cost(u, ab), u.resource_name]"), "§4: the ability button does not print `_eff_cost`")
	ok(_body("scripts/battle.gd", "_open_summon_picker").contains("[ab.display_name, _eff_cost(u, ab), u.resource_name]"),
		"§4: the summon picker does not print `_eff_cost`")
	var rs := _body("scripts/battle.gd", "_resolve")
	ok(rs.contains("var io_paid := _eff_cost(attacker, ab, target)") and rs.contains("attacker.resource + io_paid,"),
		"§4: Through and Through does not refund the price the cast paid")
	await _clear(s)


# ── §5 — A BARGAIN's CHIP ───────────────────────────────────────────────────

func _s5_the_chip() -> void:
	print("\n§5 — the fight's modifier stands in a strip of its own: its letters, its pips, its name, its rule on the hover")
	# THE LETTERS ARE EACH MODIFIER's OWN: two modifiers never share them, case set aside (HU §4); `check_hu` §4a walks
	# them beside every status's.
	var seen := {}
	var shared: Array = []
	for id in _run.MODIFIERS:
		var tg := String((_run.MODIFIERS[id] as Dictionary).get("tag", ""))
		if tg == "" or seen.has(tg.to_lower()):
			shared.append("%s '%s'" % [id, tg])
		seen[tg.to_lower()] = id
	ok(shared.is_empty(), "§5: modifiers with no letters or shared letters: %s" % str(shared))
	ok(FileAccess.get_file_as_string("res://check_hu.gd").contains("letters[\"modifier:\" + String(mid)] = [mst]"),
		"§5: `check_hu` §4a does not walk the modifiers' letters")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	ok(s != null, "§5: the board spawned")
	if s == null:
		return
	# NO MODIFIER, NO STRIP.
	_run.pending_modifier = ""
	s.call("_draw_bargain_strip")
	ok(s.get("_bargain_strip") == null, "§5: a fight with no modifier drew a strip")
	var bar: Control = null
	for c in (s.get("ui") as Node).get_children():
		if c is PanelContainer and (c as PanelContainer).get_child_count() > 0 and (c as PanelContainer).get_child(0) == s.get("turn_bar"):
			bar = c
	var log_r: Rect2 = (s.get("history_panel") as Control).get_global_rect()
	var bad: Array = []
	var drawn := 0
	for id2 in _run.MODIFIERS:
		var cfg: Dictionary = _run.MODIFIERS[id2]
		for bought in [true, false]:
			_run.pending_modifier = String(id2)
			_run.pending_reward = {"kind": "gold", "amount": 40} if bought else {}
			s.call("_draw_bargain_strip")
			await Gate.frames(self, 1)
			var st: Node2D = s.get("_bargain_strip")
			if st == null:
				bad.append("%s: no strip" % id2)
				continue
			drawn += 1
			var chip: Panel = null
			var texts := PackedStringArray()
			var rects: Array = []
			for k in st.get_children():
				if k is Panel and (k as Panel).has_meta("bargain_chip"):
					chip = k
				if k is Label:
					texts.append((k as Label).text)
				if k is Control:
					rects.append([(k as Control).name, (k as Control).get_global_rect()])
			var tagt := ""
			if chip != null and chip.get_child_count() > 0:
				tagt = (chip.get_child(0) as Label).text
			var tip := String(chip.tooltip_text) if chip != null else ""
			var flat := tip.replace("\n", " ")
			if chip == null or tagt != String(cfg.get("tag", "")):
				bad.append("%s: chip letters '%s'" % [id2, tagt])
			if not flat.contains(String(cfg["name"])) or not flat.contains("severity %d of 5" % int(cfg["severity"])) \
					or not flat.contains(String(cfg["desc"]).split(" ")[0]):
				bad.append("%s: hover '%s'" % [id2, flat.left(80)])
			if not texts.has("BARGAIN" if bought else "IMPOSED") or not texts.has(String(cfg["name"])):
				bad.append("%s: words %s" % [id2, str(texts)])
			for gl in GLYPHS:
				if (" ".join(texts) + tip + tagt).contains(String(gl)):
					bad.append("%s: wears %s" % [id2, gl])
			# THE LAYOUT RULE (IH §0): nothing in the strip over anything else in it, over the turn strip or the log, or off the screen.
			for i in rects.size():
				var ri: Rect2 = rects[i][1]
				if ri.position.x < 0 or ri.end.x > 1280 or ri.position.y < 0 or ri.end.y > 720:
					bad.append("%s: %s off the screen %s" % [id2, rects[i][0], str(ri)])
				if log_r.intersects(ri) or (bar != null and bar.get_global_rect().intersects(ri)):
					bad.append("%s: %s over the turn strip or the log %s" % [id2, rects[i][0], str(ri)])
				for j in range(i + 1, rects.size()):
					var rj: Rect2 = rects[j][1]
					if ri.intersects(rj):
						bad.append("%s: %s over %s" % [id2, rects[i][0], rects[j][0]])
	ok(drawn == 2 * (_run.MODIFIERS as Dictionary).size() and bad.is_empty(), "§5: %d strips drawn over the %d modifiers bought and imposed — %s" % [
		drawn, (_run.MODIFIERS as Dictionary).size(), str(bad.slice(0, 8))])
	print("    %d strips drawn, each clear of the turn strip and the log" % drawn)
	await _clear(s)


# ── §6 — THE PICKS NAMED ────────────────────────────────────────────────────

# IO's census rows that named their pick in no FAIL line (N) or in some (P): [site, gate, the function whose FAIL lines are
# about the pick, the string that names it, the function that builds it]. The 53 sites of IO's census (`docs/reports/IO-census.tsv`,
# its id the gate and HEAD's line), and IN's I5 and I6, which IN named and the census graded weak (IO's report, §6).
const NAMED := [
	["IO-check_el-138", "check_el.gd", "_s1_mark_population", "owners_s", ""],
	["IO-check_fe-380", "check_fe.gd", "_s2b_ability_choice", "taken_s", ""],
	["IO-check_fe-470", "check_fe.gd", "_s2c_upgrade_choice", "head_s", ""],
	["IO-check_fh-921", "check_fh.gd", "_s2_the_draft", "in_pick", ""],
	["IO-check_fh-943", "check_fh.gd", "_s2_the_draft", "bench_pick", ""],
	["IO-check_fh-1004", "check_fh.gd", "_s3_the_rune_offer", "buy_pick", ""],
	["IO-check_fh-1167", "check_fh.gd", "_s3_the_rune_offer", "cache_pick", ""],
	["IO-check_fh-1280", "check_fh.gd", "_s4_bench_a_condition", "hand_s", ""],
	["IO-check_fh-1436", "check_fh.gd", "_s5_the_pouch", "health_pick", ""],
	["IO-check_fh-1473", "check_fh.gd", "_s5_the_pouch", "sell_pick", ""],
	["IO-check_fh-1616", "check_fh.gd", "_s6_the_exhausted_pool", "fb_pick", ""],
	["IO-check_fh-1659", "check_fh.gd", "_s7_the_skill_check", "ss_pick", ""],
	["IO-check_fh-1659b", "check_fh.gd", "_s7_the_skill_check", "warden_pick", ""],
	["IO-check_ft-426", "check_ft.gd", "_s1_channel", "ab_pick", ""],
	["IO-check_ft-1244", "check_ft.gd", "_s5_the_floor", "free_pick", ""],
	["IO-check_ft-1246", "check_ft.gd", "_s5_the_floor", "paid_pick", ""],
	["IO-check_hk-284", "check_hk.gd", "_s1_the_drop", "drop_pick", ""],
	["IO-check_hk-385", "check_hk.gd", "_s1_the_drop", "eng_pick", ""],
	["IO-check_hk-427", "check_hk.gd", "_s2_the_bag", "wait_pick", ""],
	["IO-check_hk-471", "check_hk.gd", "_s2_the_bag", "second_pick", ""],
	["IO-check_hk-542", "check_hk.gd", "_s2_the_bag", "worn0_pick", ""],
	["IO-check_hk-739", "check_hk.gd", "_s3_the_peddler", "pid_pick", ""],
	["IO-check_hy-285", "check_hy.gd", "_s1_the_vow_share", "slash_pick", ""],
	["IO-check_hy-511", "check_hy.gd", "_s4_the_other_callbacks", "swing_pick", ""],
	["IO-check_hy-551", "check_hy.gd", "_s4_the_other_callbacks", "swing3_pick", ""],
	["IO-check_hf-455", "check_hf.gd", "_cleric_five", "smite_pick", ""],
	["IO-check_hf-686", "check_hf.gd", "_mage_five", "bolt_pick", ""],
	["IO-check_hr-689", "check_hr.gd", "_s2_the_nameplate", "drop_pick", ""],
	["IO-check_hr-772", "check_hr.gd", "_s2_the_nameplate", "crest_pick", ""],
	["IO-check_es-647", "check_es.gd", "_s4_tags_are_read", "two_pick", ""],
	["IO-check_es-685", "check_es.gd", "_s4_tags_are_read", "card_pick", ""],
	["IO-check_es-946", "check_es.gd", "_s5_breadth", "probe_pick", ""],
	["IO-check_gn-729", "check_gn.gd", "_s2_elemental_weakness", "probe_s", ""],
	["IO-check_gt-434", "check_gt.gd", "_s1_the_pouch", "ord_pick", ""],
	["IO-check_gt-711", "check_gt.gd", "_s1_a_bag_of_twenty", "last_pick", ""],
	["IO-check_gx-577", "check_gx.gd", "_s3b_the_kit_preview", "per_s", ""],
	["IO-check_gx-637", "check_gx.gd", "_s3c_the_battle_log", "pick_s", ""],
	["IO-check_gx-910", "check_gx.gd", "_s5_the_sentence", "note_s", ""],
	["IO-check_hz-458", "check_hz.gd", "_s1a_the_telegraph", "ws_pick", ""],
	["IO-check_hz-460", "check_hz.gd", "_s1a_the_telegraph", "plain_pick", ""],
	["IO-test_batch_bo-710", "test_batch_bo.gd", "_take_decline_drop", "card_pick", ""],
	["IO-test_batch_bo-763", "test_batch_bo.gd", "_take_decline_drop", "c3_pick", ""],
	["IO-check_go-1109", "check_go.gd", "_oath_arm", "low_pick", ""],
	["IO-check_gq-528", "check_gq.gd", "_read_screen", "intro_pick", ""],
	["IO-check_hl-873", "check_hl.gd", "_s2_core_runes", "sheet_s", ""],
	["IO-check_ho-545", "check_ho.gd", "_s1d_the_cache", "cls_pick", ""],
	["IO-check_hu-511", "check_hu.gd", "_s1_the_bar_pages", "key_pick", ""],
	["IO-check_hx-832", "check_hx.gd", "_s1d_names_resolve", "decl_pick", ""],
	["IO-check_ia-479", "check_ia.gd", "_s2c_the_swap_mid_run", "awake_pick", ""],
	["IO-check_ic-355", "check_ic.gd", "_s1c_a_the_strike", "strike_pick", ""],
	["IO-check_id-398", "check_id.gd", "_s1a_the_sections", "card_pick", ""],
	["IO-check_if-692", "check_if.gd", "_s3a_the_loadout_panel", "card_pick", ""],
	["IO-check_ih-777", "check_ih.gd", "_s5_the_hover", "extra_pick", ""],
	["IO-check_ik-290", "check_ik.gd", "_s1_blood_debt", "fullest_pick", ""],
	["IO-test_run_harness-353", "test_run_harness.gd", "_gate_talent_conservation", "route_pick", ""],
	["IN-I6-owned3", "check_ie.gd", "_s5a_the_refill", "owned3_pick", ""],
	["IN-I6-taken", "check_ie.gd", "_s5a_the_refill", "taken_pick", ""]
]


func _s6_the_picks_named() -> void:
	print("\n§6 — the re-census's sites that did not name their pick in every FAIL line build the string that names it")
	var checked := 0
	var missing: Array = []
	for row in NAMED:
		var b := _body(String(row[1]), String(row[2]))
		var v := String(row[3])
		var builder := _body(String(row[1]), String(row[4])) if String(row[4]) != "" else b
		var built := builder.contains("var %s := " % v) or builder.contains("var %s: String = " % v) \
			or builder.contains("%s.append(" % v) or builder.contains("%s = " % v)
		var read := b.count(v) >= (1 if String(row[4]) != "" else 2)
		if b == "" or not built or not read:
			missing.append("%s (%s %s: built %s, read %s)" % [row[0], row[1], row[2], built, read])
		checked += 1
	ok(missing.is_empty(), "§6: sites whose pick is not named: %s" % str(missing))
	ok(NAMED.size() == 57, "§6: the table names %d sites — the census's 53 sites, I5's two strings and I6's two are 57" % NAMED.size())
	print("    CHECKED %d of %d named sites" % [checked, NAMED.size()])


# ── §7 — THE ARCHIVE TAKES THE NEWEST CUT FIRST ─────────────────────────────

func _s7_the_archive() -> void:
	print("\n§7 — `DoD-archive/state-archive.md` takes the newest cut first")
	var arch := FileAccess.get_file_as_string("res://DoD-archive/state-archive.md")
	var codes: Array = []
	var rx := RegEx.new()
	rx.compile("(?m)^## ARCHIVED AT ([A-Z]{2})")
	for m in rx.search_all(arch):
		codes.append(m.get_string(1))
	var out_of_order: Array = []
	for i in range(1, codes.size()):
		if String(codes[i]) >= String(codes[i - 1]):
			out_of_order.append("%s after %s" % [codes[i], codes[i - 1]])
	ok(codes.size() >= 10 and out_of_order.is_empty(), "§7: the archive's %d cuts are not newest first: %s" % [codes.size(), str(out_of_order)])
	# IO's cut went at the top, and a later batch's goes above it (re-pointed at IP, whose own gate holds its cut at the top).
	ok(not codes.is_empty() and String(codes[0]) >= "IO", "§7: the archive's first cut is %s — IO's own or a later batch's goes at the top" % (str(codes[0]) if not codes.is_empty() else "none"))
	print("    cuts, newest first: %s" % " ".join(PackedStringArray(codes.slice(0, 6))))


# ── §0 — THE RULINGS RECORDED ───────────────────────────────────────────────

func _s0_rulings() -> void:
	print("\n§0 — the class passive outranks a modifier; the census is re-run after its repair; the archive's order")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(cm.count("A CLASS PASSIVE OUTRANKS A MODIFIER WHERE THEY CONTRADICT") >= 1, "§0.5: `CLAUDE.md` does not state the class passive's rule")
	ok(ir.count("## STANDING RULE — A CENSUS BUILT FROM A SWEEP IS BOUNDED BY THE SWEEP's PATTERNS") == 1,
		"§0.10: `docs/instrument-rules.md` does not head the census note once")
	ok(ir.count("## STANDING RULE — THE STATE ARCHIVE TAKES THE NEWEST CUT FIRST") == 1,
		"§7: `docs/instrument-rules.md` does not head the archive's order once")


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
