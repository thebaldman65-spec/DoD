# BATCH JZ — THE RULINGS ANSWERED: WHAT JY's ACCEPTED RULINGS BUILT.
#
# What this gate asserts, section by section (`docs/reports/JZ.md` has the working):
#
#   §1  A RUPTURE TICKS ON THE TURN OF THE HERO WHO MADE IT (JY's ruling 2). The hero whose write
#       completed the pair is its maker: his turn's start deals the Break (`_conj_maker_tick`), the
#       bearer's own pass deals the Burn alone while he stands, and another hero's turn — the one who
#       laid the Burn included — deals none. On a HELD body the maker's turns still pay, turn after turn.
#       With no standing maker — fallen, or a sourceless write — the bearer's pass deals it, as before JZ.
#       The chip's rider says so off the constant.
#   §2  FIVE TEXTS (ruling 4): Mark of the Hunt's card is HF's proposal B, word for word; the covered
#       ally's chip is *Split Shield* and the block line's label too; the recast refusal names a
#       Cryomancer's hold *Held*; the class-selection screen carries no PROPOSED mark on GQ's lines.
#   §3  APER ANSWERS THE PACK's CARDS (ruling 5): a wearer's pack is four kinds and a bare hunter's three;
#       Kill Command orders a lone Aper to its ordinary charge, each counted, the third stunning; Ghostpack
#       sends Aper's spirit for a wearer who called it; Call of the Wild writes Aper into a wearer's
#       summoned kinds and never a bare hunter's. Kill Command's card names the order.
#   §4  THE THREE CLASS ENGINES SHOW THEIR COUNT (ruling 7): Momentum, Channel and Sanctity open at
#       `0/cap`, follow the steps to the cap and no further, keep the rule text first in the hover, and the
#       refresh books no Sanctity event; a hero without the engine has no such chip; the count is re-read
#       at the turn's start, after the step is booked.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether a held, Ruptured enemy's
# lock reads well (the designer's play, TO WATCH IN PLAY); whether Aper's order is worth a turn beside a
# Quick Shot (JZ's ruling 6); the kit cards' figures and the two names, which JZ built nothing for.
# Helpers `_rune`, `_eng`, `_hero`, `_foes`, `_sturdy` and `_clear` are `check_hf`'s shapes; the battle
# comes from `Gate.spawn`, the one fixture.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://jz_profile.json"
const SCRATCH_RELICS := "user://jz_relics.json"
const MARK_B := "Mark an enemy for 7 turns: the Hunter's\nand the companion's attacks on it deal\n+25% damage, and every strike on it\nrestores 3% of the Hunter's max Mana.\nThe companion's half needs only a\ncompanion; the Hunter's needs the Rune\nof the Beastmaster. The cooldown resets\nif the marked enemy dies."
const RIDER := "Deals %d Break damage at the start of\neach turn of the hero who made it, or\nof this body's, if no such hero stands."

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JZ — THE RULINGS ANSWERED: RUPTURE, THE TEXTS, APER, THE METERS")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a fight is spawned")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	await _s1_rupture()
	_s2_texts()
	await _s3_aper()
	await _s4_meters()
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


# A rune as the pouch holds one, worn.
func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


# An engine rune as the pouch holds one — built by the game, slotted.
func _eng(pid: String) -> Dictionary:
	var r: Dictionary = Runes.build(Runes.engine_rune_id(pid))
	r["equipped"] = true
	return r


# A fight with the heroes seated by `specs`, each seat taking what `over` gives it (`runes`,
# `engines`). The deterministic fixture: no miss, no block, no parry, no crit.
func _board(specs: Array, over: Dictionary = {}) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"party": over, "deterministic": true})
	return s


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not e.dead)


func _sturdy(s: Node) -> void:
	for e in s.get("enemies"):
		e.max_hp = 9999
		e.hp = 9999
		e.stability = 9999


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _bare(u: BattleUnit) -> void:
	u.statuses = []
	u._refresh_chips()


func _burn(s: Node, target: BattleUnit, src: BattleUnit) -> void:
	s.call("_apply_status", target, "burn", 3, 0, s.call("_dot_tick", "burn", src), src)


func _chill(s: Node, target: BattleUnit, src: BattleUnit) -> void:
	s.call("_apply_status", target, "chilled", 3, 0, 0, src)


func _log_text(s: Node) -> String:
	return String((s.get("history") as RichTextLabel).get_parsed_text())



# ── §1 — RUPTURE ON ITS MAKER's TURN ────────────────────────────────────────

func _s1_rupture() -> void:
	print("\n§1 — a Rupture ticks on the turn of the hero who made it")
	var s: Node = await _board(["", "cryomancer", "", ""])
	_sturdy(s)
	var war := _hero(s, "warrior")
	var cryo := _hero(s, "mage")
	var cl := _hero(s, "cleric")
	var foes := _foes(s)
	ok(war != null and cryo != null and cl != null and foes.size() >= 3, "§1: the premise — three heroes and three foes")
	if war == null or cryo == null or cl == null or foes.size() < 3:
		await _clear(s)
		return
	var fig := int(s.get("RUPTURE_BREAK_PER_TICK"))
	var lname := String(s.get("STATUS_INFO")["rupture"][0])
	# (a) THE MAKER IS WHOEVER COMPLETED THE PAIR: the Cleric laid the Burn, the Cryomancer's chill joined it.
	var a: BattleUnit = foes[0]
	_bare(a)
	_burn(s, a, cl)
	_chill(s, a, cryo)
	ok(a.has_status("rupture") and String(a.composition_of("burn").get("src_name", "")) == cryo.unit_name,
		"§1a: the premise — the Cleric's Burn and the Cryomancer's chill made no Rupture, or not his")
	var pr0 := a.pressure
	var hp0 := a.hp
	Engine.time_scale = 50.0
	await s.call("_dot_pass", a)
	var pr_pass := a.pressure
	var hp_pass := a.hp
	s.call("_conj_maker_tick", cl)
	var pr_other := a.pressure
	var log_mk := _log_text(s).length()
	s.call("_conj_maker_tick", cryo)
	var said := _log_text(s).substr(log_mk)
	Engine.time_scale = 1.0
	print("    the bearer's pass: -%d HP +%d Break; the Cleric's turn +%d; the Cryomancer's turn +%d" % [
		hp0 - hp_pass, pr_pass - pr0, pr_other - pr_pass, a.pressure - pr_other])
	ok(hp0 - hp_pass > 0 and pr_pass == pr0,
		"§1a: the bearer's pass dealt %d of Burn and %d Break — while its maker stands the pass is the Burn's alone" % [hp0 - hp_pass, pr_pass - pr0])
	ok(pr_other == pr_pass,
		"§1a: the Cleric's turn dealt %d Break — he laid the Burn, he did not make the Rupture" % (pr_other - pr_pass))
	ok(a.pressure - pr_other > 0 and said.count("%s's %s ticks — the Break" % [a.unit_name, lname]) == 1
			and said.contains("(on %s's turn)" % cryo.unit_name),
		"§1a: the Cryomancer's turn dealt %d Break, or its line did not name his turn" % (a.pressure - pr_other))
	# (b) A HELD BODY STILL GRINDS: the hold takes its turns, its maker's turns still pay.
	var b: BattleUnit = foes[1]
	_bare(b)
	s.call("_hold_freeze", b, cryo, true)
	_burn(s, b, cl)
	_chill(s, b, cryo)
	var held := bool(s.call("_is_held", b))
	ok(held and b.has_status("rupture"), "§1b: the premise — a held body wearing the Cryomancer's Rupture (held %s, ruptured %s)" % [held, b.has_status("rupture")])
	var prb := [b.pressure]
	for _t in 2:
		s.call("_conj_maker_tick", cryo)
		prb.append(b.pressure)
	print("    a held body under its maker's two turns: Break %s" % [prb])
	ok(held and int(prb[1]) > int(prb[0]) and int(prb[2]) > int(prb[1]),
		"§1b: a held, Ruptured body took Break %s over its maker's two turns — want a rise at each" % [prb])
	# (c) NO STANDING MAKER: the bearer's pass pays, as before JZ — a fallen maker, and an enemy's write.
	var c: BattleUnit = foes[2]
	_bare(c)
	_burn(s, c, war)
	_chill(s, c, cl)
	cl.dead = true
	var prc := c.pressure
	Engine.time_scale = 50.0
	await s.call("_dot_pass", c)
	Engine.time_scale = 1.0
	var fell := c.pressure - prc
	cl.dead = false
	var d: BattleUnit = foes[0]
	_bare(d)
	_burn(s, d, war)
	s.call("_apply_status", d, "chilled", 3, 0, 0, null)
	var prd := d.pressure
	s.call("_conj_maker_tick", war)
	var war_turn := d.pressure - prd
	Engine.time_scale = 50.0
	await s.call("_dot_pass", d)
	Engine.time_scale = 1.0
	print("    no standing maker: a fallen maker's pass +%d; a sourceless chill's pass +%d (the Burn's layer's turn +%d)" % [
		fell, d.pressure - prd - war_turn, war_turn])
	ok(fell > 0, "§1c: with its maker fallen the bearer's pass dealt %d Break — the fallback is the bearer's turn" % fell)
	ok(d.has_status("rupture") and war_turn == 0 and d.pressure - prd > 0,
		"§1c: a Rupture no hero made took %d on the Burn's layer's turn and %d on its pass — want none, then the pass's" % [war_turn, d.pressure - prd - war_turn])
	# (d) THE CHIP SAYS SO, OFF THE CONSTANT.
	var desc := String(a.get_status("rupture").get("desc", ""))
	ok(desc.contains(RIDER % fig), "§1d: the Rupture's chip does not carry the maker's-turn rider off the constant")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.count("_conj_maker_tick(u)") == 1 and src.contains("and _conj_maker(dot_comp) == null"),
		"§1d: the turn loop does not call the maker's tick once, or the pass does not stand aside for a standing maker")
	await _clear(s)


# ── §2 — FIVE TEXTS ─────────────────────────────────────────────────────────

func _s2_texts() -> void:
	print("\n§2 — the five texts")
	var mark: Ability = Classes.pool_ability("Mark of the Hunt")
	ok(mark != null and String(mark.description) == MARK_B,
		"§2: Mark of the Hunt's card is not HF's proposal B, word for word")
	var info: Dictionary = load("res://scripts/battle.gd").STATUS_INFO
	ok(String(info["bulwark_line"][0]) == "Split Shield", "§2: the covered ally's chip is called %s, not Split Shield" % info["bulwark_line"][0])
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("plate_label = \"Split Shield\"") and not src.contains("plate_label = \"Bulwark Line\""),
		"§2: the block line still labels the Split Shield's block with the deleted talent's name")
	var at := src.find("func _recast_refusal_note(")
	var body := src.substr(at, src.find("\nfunc ", at + 10) - at) if at >= 0 else ""
	ok(body.contains("if sid == \"frozen\" and _is_held(t):") and body.contains("nm = \"Held\""),
		"§2: the recast refusal does not name a Cryomancer's hold Held")
	var sc := FileAccess.get_file_as_string("res://scripts/spec_choice_screen.gd")
	ok(not sc.contains("PROPOSED WORDS (GQ)") and sc.count("GQ's words, accepted as they read") == 3,
		"§2: the class-selection screen still marks GQ's three lines PROPOSED")
	var kc: Ability = Classes.pool_ability("Kill Command")
	var kd := String(kc.description) if kc != null else ""
	var longest := 0
	for ln in kd.split("\n"):
		longest = maxi(longest, String(ln).length())
	ok(kd.contains("Aper: one charge, as beside the Hunter,\ncounted toward the every-third STUN.")
			and not kd.to_lower().contains("your") and longest <= 44,
		"§2: Kill Command's card does not name Aper's order, keeps a pronoun, or runs past 44 (%d)" % longest)


# ── §3 — APER ANSWERS THE PACK's CARDS ──────────────────────────────────────

func _s3_aper() -> void:
	print("\n§3 — Aper answers Kill Command, Ghostpack and Call of the Wild")
	var worn: Node = await _board(["", "", "", ""], {3: {"runes": [_rune("tusk_and_bristle")], "engines": [_eng("pack")]}})
	_sturdy(worn)
	var h := _hero(worn, "hunter")
	var bare: Node = null
	ok(h != null, "§3: the premise — a hunter")
	if h == null:
		await _clear(worn)
		return
	var kinds: Array = worn.call("_pack_kinds", h)
	ok(kinds == ["ursus", "canis", "aguila", "aper"], "§3: a wearer's pack is %s — want the three and Aper" % [kinds])
	var call: Ability = worn._summon_choice(h, "aper")
	ok(call != null, "§3: the premise — a wearer's call does not offer Aper")
	if call == null:
		await _clear(worn)
		return
	await worn._resolve(h, call, h, "good")
	var beasts: Array = worn._beasts(h)
	ok(beasts.size() == 1 and String(beasts[0].companion_kind) == "aper", "§3: the premise — the wearer's Aper alone stands")
	if beasts.size() != 1:
		await _clear(worn)
		return
	var aper: BattleUnit = beasts[0]
	var foe: BattleUnit = _foes(worn)[0]
	var kc: Ability = Classes.pool_ability("Kill Command")
	var counts := []
	var stuns := []
	var hits := []
	for _k in 3:
		foe.remove_status("stunned")
		var was := foe.hp
		h.cooldowns.clear()
		h.resource = h.max_resource
		await worn._resolve(h, kc, foe, "good")
		counts.append(aper.aper_strikes)
		stuns.append(foe.has_status("stunned"))
		hits.append(was - foe.hp)
	print("    three orders: Aper's count %s, stunned %s, dealt %s" % [counts, stuns, hits])
	ok(counts == [1, 2, 3], "§3: three Kill Commands moved Aper's count %s — want each an ordinary charge, counted" % [counts])
	ok(stuns == [false, false, true], "§3: three orders stunned %s — want the third" % [stuns])
	ok(int(hits[0]) > 0 and int(hits[1]) > 0, "§3: Aper's ordered charge dealt %s — want damage each order" % [hits])
	# GHOSTPACK: the wearer has called Aper this battle, so its spirit runs with his attacks.
	worn._apply_status(h, "ghostpack", 4, 0, 0, h)
	var from := _log_text(worn).length()
	h.cooldowns.clear()
	await worn._resolve(h, h.abilities[0], foe, "good")
	var gp_said := _log_text(worn).substr(from)
	ok(h.kinds_summoned.has("aper") and gp_said.contains("The spirit of Aper strikes"),
		"§3: under Ghostpack the wearer's attack sent no spirit of Aper, though he called it this battle")
	await _clear(worn)
	# CALL OF THE WILD: a wearer who never called Aper hears it answer the call — its spirit strikes and it joins the
	# summoned kinds; a bare hunter's never does. (A board of its own: the one above had called Aper already, so its
	# summoned kinds held the boar before any call — JZ's control C13 found that arm read nothing.)
	var cw: Ability = Classes.pool_ability("Call of the Wild")
	var fresh: Node = await _board(["", "", "", ""], {3: {"runes": [_rune("tusk_and_bristle")], "engines": [_eng("pack")]}})
	_sturdy(fresh)
	var hf := _hero(fresh, "hunter")
	hf.resource = hf.max_resource
	var cw_from := _log_text(fresh).length()
	await fresh._resolve(hf, cw, _foes(fresh)[0], "good")
	var worn_kinds: Array = hf.kinds_summoned.keys()
	var cw_said := _log_text(fresh).substr(cw_from)
	await _clear(fresh)
	bare = await _board(["", "", "", ""], {3: {"engines": [_eng("pack")]}})
	_sturdy(bare)
	var hb := _hero(bare, "hunter")
	var bare_pack: Array = bare.call("_pack_kinds", hb)
	hb.resource = hb.max_resource
	await bare._resolve(hb, cw, _foes(bare)[0], "good")
	var bare_kinds: Array = hb.kinds_summoned.keys()
	print("    Call of the Wild: worn %s, bare %s" % [worn_kinds, bare_kinds])
	ok(worn_kinds.has("aper") and worn_kinds.size() == 4 and cw_said.contains("The spirit of Aper strikes")
			and not bare_kinds.has("aper") and bare_kinds.size() == 3 and bare_pack == ["ursus", "canis", "aguila"],
		"§3: Call of the Wild summoned %s for a wearer and %s for a bare hunter (bare pack %s) — want Aper the wearer's alone" % [worn_kinds, bare_kinds, bare_pack])
	await _clear(bare)


# ── §4 — THE THREE CLASS ENGINES' COUNT ─────────────────────────────────────

func _s4_meters() -> void:
	print("\n§4 — Momentum, Channel and Sanctity show their count")
	var s: Node = await _board(["", "", "", ""], {0: {"engines": [_eng("momentum")]}, 1: {"engines": [_eng("channel")]},
		2: {"engines": [_eng("sanctity")]}})
	var war := _hero(s, "warrior")
	var mage := _hero(s, "mage")
	var cl := _hero(s, "cleric")
	var hunt := _hero(s, "hunter")
	ok(war != null and mage != null and cl != null and hunt != null, "§4: the premise — four heroes")
	if war == null or mage == null or cl == null or hunt == null:
		await _clear(s)
		return
	var open := [String(war.engine_chip("momentum").get("short", "")), String(mage.engine_chip("channel").get("short", "")),
		String(cl.engine_chip("sanctity").get("short", ""))]
	var want_open := ["0/%d" % BattleUnit.MOMENTUM_MAX_STEPS, "0/%d" % BattleUnit.CHANNEL_MAX_STEPS,
		"0/%d" % BattleUnit.SANCTITY_MAX_STEPS]
	print("    at the spawn: %s" % [open])
	ok(open == want_open, "§4: the three chips opened at %s — want %s" % [open, want_open])
	war.momentum = 3
	war.refresh_meter_chips()
	var m3 := String(war.engine_chip("momentum").short)
	war.momentum = BattleUnit.MOMENTUM_MAX_STEPS + 5
	war.refresh_meter_chips()
	var m_cap := String(war.engine_chip("momentum").short)
	mage.mana_spent = 2 * BattleUnit.CHANNEL_MANA_PER_STEP
	mage.refresh_meter_chips()
	var ch := mage.engine_chip("channel")
	var ev0: int = BattleUnit.sanctity_events
	BattleUnit.sanctity_events = BattleUnit.SANCTITY_PER_STEP
	s.call("_update_talent_chips")
	var sa := cl.engine_chip("sanctity")
	var ev1: int = BattleUnit.sanctity_events
	BattleUnit.sanctity_events = ev0
	print("    driven: Momentum %s, at the cap %s; Channel %s; Sanctity %s" % [m3, m_cap, ch.short, sa.short])
	ok(m3 == "3/%d" % BattleUnit.MOMENTUM_MAX_STEPS and m_cap == "%d/%d" % [BattleUnit.MOMENTUM_MAX_STEPS, BattleUnit.MOMENTUM_MAX_STEPS],
		"§4: Momentum's chip read %s at three steps and %s past the cap" % [m3, m_cap])
	ok(String(ch.short) == "2/%d" % BattleUnit.CHANNEL_MAX_STEPS
			and String(ch.desc).contains("the next step at %d" % (3 * BattleUnit.CHANNEL_MANA_PER_STEP)),
		"§4: Channel's chip read %s, or its hover does not say what the next step needs" % ch.short)
	ok(String(sa.short) == "1/%d" % BattleUnit.SANCTITY_MAX_STEPS and ev1 == BattleUnit.SANCTITY_PER_STEP,
		"§4: Sanctity's chip read %s after one step's events, or the refresh booked an event (%d)" % [sa.short, ev1])
	var rule := Classes.resolve_values(Classes.engine_desc("momentum"), Classes.value_ctx_from_unit(war))
	ok(String(war.engine_chip("momentum").desc).begins_with(rule)
			and String(war.engine_chip("momentum").desc).contains("Steps built this battle: %d of %d." % [BattleUnit.MOMENTUM_MAX_STEPS, BattleUnit.MOMENTUM_MAX_STEPS]),
		"§4: Momentum's hover does not keep the rule text first, or does not say the steps built")
	ok(hunt.engine_chip("momentum").is_empty() and hunt.engine_chip("channel").is_empty() and hunt.engine_chip("sanctity").is_empty(),
		"§4: a hero holding none of the three engines carries one of their chips")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("u.note_momentum_turn()\n\t\tu.refresh_meter_chips()"),
		"§4: the count is not re-read at the turn's start, after the step is booked")
	await _clear(s)


func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
