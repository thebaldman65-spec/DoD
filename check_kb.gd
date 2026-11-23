# BATCH KB — KA's FOUR RULINGS ANSWERED: HEAL, AND THE HUNTER's TWO NEW CORES.
#
# What this gate asserts, section by section (`docs/reports/KB.md` has the working):
#
#   §1  HEAL (the designer's ruling 2): the Cleric's kit card is Heal, healing one ally for HEAL_PCT of the CLERIC's
#       maximum and HEAL_PERFECT_PCT on a Perfect; Holy's card is Greater Heal; Ministration names no card, no
#       constant and no special, and is reserved. The casts pay the caster's share, Good and Perfect.
#   §2  THE BOT's TWO CLERIC PICKS follow their cards: the kit branch asks for Heal, the Holy rotation for Greater Heal.
#   §3  THE SAVE's NAMES: a save older than 16 reads Heal as Greater Heal and Ministration as Heal; a v16 save reads Heal as
#       Heal; neither row is in the rename map every load reads.
#   §4  VOLLEY (the designer's rule): each landed arrow on a target adds k x VOLLEY_STEP Bleed buildup, a clean volley pays
#       the last share again, a companion's blow is an arrow, a Blocked arrow lands nothing and breaks the clean volley,
#       the rider's floor rises once an arrow has landed, and a Hunter without the rune adds nothing.
#   §5  THE AMBUSHER's OVERDRAW: the caps per card, the copies fired at the main target (Volley counting them), the
#       initiative each costs, the turn bar's preview, the armed count spent by the cast, and the bot's finishing policy.
#   §6  THE CONVERSION: Volley and the Ambusher are the Hunter's rule engines, each with its rune; the Tracker and the
#       Skirmisher are Common Foe and Pounce, ordinary runes, their rules kept (the mark and its payout; the bonus re-armed
#       after quiet turns); the rule texts meet the text standard's measured line.
#   §7  THE v16 LOAD STEP: a saved Tracker in a core slot is rebuilt, moved to the hero's ordinary runes and said; the core
#       slot is left empty; a deal drops an id that is no core now; a clean rune is untouched; no die is drawn.
#   §8  MASTER's FIGURES: every figure `docs/master.html` states for Volley, the Ambusher, Common Foe, Pounce and the
#       Overdraw control is read against the constant that decides it, and the Ambusher's two worked prices against the
#       cast's own price (`_overdraw_price`) — the card catalogue's way (`check_iq` §2f), so a re-tune reds the page.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether any figure is right — every one is the
# designer's (KB's record) — and how a player reads the overdraw control; the sim's figures test the code only.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const NO_LINEAGE := ["", "", "", ""]
const SEED := 20261122
const SCRATCH_PROFILE := "user://kb_profile.json"
const SCRATCH_RELICS := "user://kb_relics.json"

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _prices := {}  # §5's cast prices, read again by §8


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KB — HEAL, AND THE HUNTER's TWO NEW CORES")
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
	await _s1_heal()
	_s2_bot_picks()
	_s3_save_names()
	await _s4_s5_volley_and_overdraw()
	await _s6_conversion()
	_s7_load_step()
	_s8_masters_figures()
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


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not e.dead)


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _reset_foe(e: BattleUnit) -> void:
	e.max_hp = 100000
	e.hp = e.max_hp
	e.pressure = 0
	e.broken = false
	e.broken_pending = false
	e.bleed_buildup = 0
	e.block_chance = -10.0
	for st in e.statuses.duplicate():
		e.remove_status(String(st.id))


func _ready_to_cast(u: BattleUnit) -> void:
	u.resource = u.max_resource
	u.cooldowns.clear()


func _k(s: Node, n: String) -> float:
	var m: Dictionary = (s.get_script() as Script).get_script_constant_map()
	return float(m.get(n, -1.0))


func _card(u: BattleUnit, n: String) -> Ability:
	for a in u.abilities:
		if a != null and String((a as Ability).display_name) == n:
			return a
	return null


# A battle-script function's body, read off the source (comments kept out by the caller's needles).
func _fn_body(src: String, fname: String) -> String:
	var i := src.find("\nfunc %s(" % fname)
	if i < 0:
		return ""
	var j := src.find("\nfunc ", i + 6)
	return src.substr(i, (j if j > 0 else src.length()) - i)


func _engine_rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


# ── §1 — HEAL ───────────────────────────────────────────────────────────────

func _s1_heal() -> void:
	print("\n§1 — Heal: the kit card, at the Cleric's maximum; Greater Heal, Holy's")
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	ok(is_equal_approx(_k(s, "HEAL_PCT"), 0.20), "§1: Heal heals 20%% of the Cleric's maximum (%s)" % str(_k(s, "HEAL_PCT")))
	ok(is_equal_approx(_k(s, "HEAL_PERFECT_PCT"), 0.26), "§1: Heal's Perfect heals 26%% (%s)" % str(_k(s, "HEAL_PERFECT_PCT")))
	var cmap: Dictionary = (s.get_script() as Script).get_script_constant_map()
	ok(not cmap.has("MINISTRATION_PCT") and not cmap.has("MINISTRATION_PERFECT_PCT"),
		"§1: no constant still carries the reserved name Ministration")
	var heal: Ability = Classes.pool_ability("Heal")
	var greater: Ability = Classes.pool_ability("Greater Heal")
	ok(Classes.pool_ability("Ministration") == null, "§1: Ministration names no card — the name is reserved")
	ok(heal != null and heal.special == "kit_heal" and heal.cost == 20 and heal.cooldown == 2
			and is_equal_approx(heal.delay, 2.0),
		"§1: Heal is the kit card — its cost, cooldown and initiative held (%s)" % (
			"%s %d %d %.1f" % [heal.special, heal.cost, heal.cooldown, heal.delay] if heal != null else "no card"))
	ok(greater != null and greater.special == "holy_heal", "§1: Greater Heal is Holy's card (%s)" % (
		greater.special if greater != null else "no card"))
	ok(Classes.CLASS_KITS["cleric"].has("Heal") and not Classes.CLASS_KITS["cleric"].has("Ministration"),
		"§1: every Cleric opens with Heal (%s)" % str(Classes.CLASS_KITS["cleric"]))
	ok(Classes.spec_draft_pool("holy").has("Greater Heal") and not Classes.spec_draft_pool("holy").has("Heal"),
		"§1: Holy's shelf deals Greater Heal and never the kit card")
	ok(heal != null and String(heal.description).contains("20% of the Cleric's"),
		"§1: Heal's card says whose maximum (%s)" % (String(heal.description).replace("\n", " ") if heal != null else ""))
	ok(heal != null and String(heal.perfect_text).contains("{mhp:26}"),
		"§1: Heal's Perfect reads 26 of the owner's maximum (%s)" % (String(heal.perfect_text) if heal != null else ""))
	var C := _hero(s, "cleric")
	var W := _hero(s, "warrior")
	var mend := _card(C, "Heal") if C != null else null
	if C == null or W == null or mend == null:
		ok(false, "§1: the board seats a Cleric holding Heal and a Warrior")
	else:
		ok(C.max_hp != W.max_hp, "§1: the Cleric's and the Warrior's maximums differ, so the cast says whose it read (%d, %d)" % [
			C.max_hp, W.max_hp])
		for grade in ["good", "perfect"]:
			_ready_to_cast(C)
			W.hp = 1
			await s._resolve_special(C, mend, W, grade, 1.0)
			var pct := 0.26 if grade == "perfect" else 0.20
			ok(W.hp - 1 == int(round(C.max_hp * pct)),
				"§1: a %s Heal mends the Warrior %d — %d%% of the CLERIC's maximum (%d), not his own (%d)" % [
					grade.capitalize(), W.hp - 1, int(round(pct * 100)), int(round(C.max_hp * pct)),
					int(round(W.max_hp * pct))])
			W.hp = W.max_hp
	await _clear(s)


# ── §2 — THE BOT's TWO CLERIC PICKS ─────────────────────────────────────────

func _s2_bot_picks() -> void:
	print("\n§2 — the bot's Cleric picks follow their cards")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(_fn_body(src, "_bot_class_kit_pick").contains("_bot_kit_card(u, \"Heal\")"),
		"§2: the kit branch asks for Heal")
	ok(_fn_body(src, "_autoplay_pick_kit").contains("_find_ability(u, \"Greater Heal\")")
			and not _fn_body(src, "_autoplay_pick_kit").contains("_find_ability(u, \"Heal\")"),
		"§2: Holy's rotation asks for Greater Heal, never the kit's Heal")
	ok(not src.contains("\"Ministration\""), "§2: no string in the battle script names Ministration")


# ── §3 — THE SAVE's NAMES ───────────────────────────────────────────────────

func _s3_save_names() -> void:
	print("\n§3 — a save's card names, read by the version that renamed them")
	ok(int(_run.SAVE_VERSION) == 16, "§3: the save version is 16 (%d)" % int(_run.SAVE_VERSION))
	var rmap: Dictionary = _run.RENAMED_CARDS
	ok(not rmap.has("Heal") and not rmap.has("Ministration"),
		"§3: neither rename sits in the map every load reads")
	var was: int = int(_run.get("_loaded_save_version"))
	var names := {}
	for ab in Classes.ability_corpus():
		names[String(ab.display_name)] = true
	_run.set("_card_names", names)  # the table the load builds before it sorts a name (`_rename_saved_cards`)
	_run.set("_loaded_save_version", 15)
	ok(String(_run.call("_card_now", "Heal")) == "Greater Heal" and String(_run.call("_card_now", "Ministration")) == "Heal",
		"§3: a v15 save's Heal is Greater Heal and its Ministration is Heal")
	ok(String(_run.call("_card_answer", "Ministration")) == "translate",
		"§3: a v15 Ministration is translated, inside the five answers")
	_run.set("_loaded_save_version", 16)
	ok(String(_run.call("_card_now", "Heal")) == "Heal" and String(_run.call("_card_now", "Greater Heal")) == "Greater Heal",
		"§3: a v16 save's Heal stays Heal")
	ok(String(_run.call("_card_now", "Iron Will")) == "Ironclad", "§3: the map's own rows still read (Iron Will)")
	_run.set("_loaded_save_version", was)


# ── §4 + §5 — VOLLEY AND THE AMBUSHER ───────────────────────────────────────

func _cast(s: Node, H: BattleUnit, ab: Ability, e: BattleUnit, armed: int) -> Dictionary:
	_ready_to_cast(H)
	_reset_foe(e)
	s.set("current_hero", H)
	s.set("overdraw_armed", armed)
	var t0 := H.next_time
	seed(SEED)
	await s._resolve(H, ab, e, "good")
	return {"bleed": e.bleed_buildup, "dt": H.next_time - t0, "left": int(s.get("overdraw_armed"))}


func _s4_s5_volley_and_overdraw() -> void:
	print("\n§4 — Volley: each landed arrow adds more Bleed buildup than the one before")
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	over[3] = {"engines": [_engine_rune("engine_volley"), _engine_rune("engine_ambusher")]}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	var H := _hero(s, "hunter")
	var C := _hero(s, "cleric")
	var e0: BattleUnit = _foes(s)[0]
	if H == null or C == null or not H.has_engine("volley") or not H.has_engine("ambusher"):
		ok(false, "§4: the board seats a Hunter holding Volley and the Ambusher")
		await _clear(s)
		return
	var step: int = Classes.VOLLEY_STEP
	var qs: Ability = H.abilities[0]  # the Hunter's basic, Quick Shot — a kit card no pool holds
	ok(qs != null and qs.display_name == "Quick Shot", "§4: the Hunter's basic is Quick Shot")
	var av: Ability = Classes.pool_ability("Aimed Volley")
	var df: Ability = Classes.pool_ability("Drumfire")
	var aim: Ability = Classes.pool_ability("Aimed Shot")
	var cv: Ability = Classes.pool_ability("Called Volley")
	var kc: Ability = Classes.pool_ability("Kill Command")
	var r := await _cast(s, H, av, e0, 0)
	ok(r.bleed == step * (1 + 2 + 3) + step * 3,
		"§4: a clean three-arrow volley adds %d (%d + %d + %d, the last again)" % [r.bleed, step, step * 2, step * 3])
	r = await _cast(s, H, qs, e0, 0)
	ok(r.bleed == step, "§4: a single arrow adds %d, and one arrow is no volley to make clean (%d)" % [step, r.bleed])
	e0.block_chance = 10.0
	_ready_to_cast(H)
	e0.bleed_buildup = 0
	s.set("overdraw_armed", 0)
	await s._resolve(H, av, e0, "good")
	ok(e0.bleed_buildup == 0, "§4: three Blocked arrows land nothing and add nothing (%d)" % e0.bleed_buildup)
	e0.block_chance = -10.0
	# The rider and the companion's blow, read off the cast's own state.
	s.set("_volley_state", {"caster": H, "fired": {e0: 1}, "landed": {e0: 0}, "last": {}})
	ok(is_equal_approx(float(s._volley_floor(H, e0)), 0.9), "§4: before an arrow has landed the roll keeps its floor")
	s.set("_volley_state", {"caster": H, "fired": {e0: 1}, "landed": {e0: 1}, "last": {}})
	ok(is_equal_approx(float(s._volley_floor(H, e0)), Classes.VOLLEY_RIDER_FLOOR),
		"§4: once one has landed the next rolls from %s" % str(Classes.VOLLEY_RIDER_FLOOR))
	ok(is_equal_approx(float(s._volley_floor(C, e0)), 0.9), "§4: another hero's roll is untouched")
	await s._do_summon(H, "ursus")
	var comps: Array = (s.get("companions") as Array).filter(func(c): return c.pack_master == H)
	if comps.is_empty():
		ok(false, "§4: the Hunter's summon put a companion on the field")
	else:
		_reset_foe(e0)
		s.set("_volley_state", {"caster": H, "fired": {e0: 2}, "landed": {e0: 2}, "last": {}})
		await s._companion_hit(comps[0], e0, 0.10 * comps[0].attack, 0)
		ok(e0.bleed_buildup == step * 3, "§4: the companion's blow is the third arrow on the body and adds %d (%d)" % [
			step * 3, e0.bleed_buildup])
		s.set("_volley_state", {})
		_reset_foe(e0)
		await s._companion_hit(comps[0], e0, 0.10 * comps[0].attack, 0)
		ok(e0.bleed_buildup == 0, "§4: outside a Volley cast a companion's blow adds nothing (%d)" % e0.bleed_buildup)
		# With the beast standing, every damaging cast ends in its blow: a clean Aimed Volley is four arrows.
		r = await _cast(s, H, av, e0, 0)
		ok(r.bleed == step * (1 + 2 + 3 + 4) + step * 4,
			"§4: three arrows and the beast's blow make a clean volley of four (%d)" % r.bleed)
		for c in comps:
			c.hp = 0
			c.dead = true
	var M := _hero(s, "mage")
	var mm: Ability = Classes.pool_ability("Magic Missiles")
	if M != null and mm != null:
		_ready_to_cast(M)
		_reset_foe(e0)
		await s._resolve(M, mm, e0, "good")
		ok(e0.bleed_buildup == 0, "§4: a hero without the rune lays no Volley buildup (%d)" % e0.bleed_buildup)

	print("\n§5 — the Ambusher: copies at the main target, each at the card's own pace")
	var caps := {"Quick Shot": 2, "Aimed Shot": 1, "Drumfire": 2, "Aimed Volley": 2, "Called Volley": 0, "Kill Command": 0}
	for nm in caps:
		var ab: Ability = qs if nm == "Quick Shot" else Classes.pool_ability(nm)
		ok(ab != null and int(s._overdraw_max(H, ab)) == int(caps[nm]),
			"§5: %s takes at most %d (%s)" % [nm, int(caps[nm]), str(s._overdraw_max(H, ab)) if ab != null else "no card"])
	ok(int(s._overdraw_max(C, qs)) == 0, "§5: a hero without the rune takes none")
	var per: float = 100.0 / H.effective_speed() * H.momentum_delay_mult()
	r = await _cast(s, H, qs, e0, 2)
	ok(r.bleed == step * (1 + 2 + 3) + step * 3,
		"§5: Quick Shot and two copies are three arrows at the main target — Volley counts them (%d)" % r.bleed)
	ok(absf(r.dt - (2.0 + 2.0 * 2.0) * per) < 0.01, "§5: each copy cost the card's own 2.0 initiative (%.2f)" % r.dt)
	ok(r.left == 0, "§5: the cast spent the armed count")
	r = await _cast(s, H, aim, e0, 2)
	ok(r.bleed == step * (1 + 2) + step * 2, "§5: Aimed Shot takes only one copy under the cap (%d)" % r.bleed)
	ok(absf(r.dt - (3.0 + 3.0) * per) < 0.01, "§5: the one copy cost 3.0 initiative (%.2f)" % r.dt)
	r = await _cast(s, H, df, e0, 2)
	ok(r.bleed == step * (1 + 2 + 3 + 4 + 5) + step * 5, "§5: Drumfire and two copies are five arrows (%d)" % r.bleed)
	ok(absf(r.dt - (3.0 + 2.0 * 1.0) * per) < 0.01, "§5: each Drumfire copy cost 3.0 / 3 initiative (%.2f)" % r.dt)
	r = await _cast(s, H, qs, e0, 0)
	ok(r.bleed == step and absf(r.dt - 2.0 * per) < 0.01, "§5: unasked, a cast takes no copy (%d, %.2f)" % [r.bleed, r.dt])
	s.set("overdraw_armed", 2)
	ok(is_equal_approx(float(s._overdraw_preview_delay(H, aim)), 3.0)
			and is_equal_approx(float(s._overdraw_preview_delay(H, qs)), 4.0),
		"§5: the turn bar adds what the cast will, clamped per card")
	s.set("overdraw_armed", 0)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(_fn_body(bsrc, "_rebuild_turn_bar").contains("_overdraw_preview_delay(preview_unit, preview_ability)"),
		"§5: the turn bar's preview asks the same clamp the cast pays")
	_reset_foe(e0)
	var one := float(qs.damage) * 0.01 * H.attack * (1.0 - e0.effective_armor())
	e0.hp = int(ceil(one * 1.5))
	ok(int(s._bot_overdraw(H, qs, e0)) == 1, "§5: the bot adds the one copy that finishes the body (%d)" % int(s._bot_overdraw(H, qs, e0)))
	e0.hp = maxi(int(floor(one * 0.5)), 1)
	ok(int(s._bot_overdraw(H, qs, e0)) == 0, "§5: and none when the arrow alone does")
	e0.hp = int(one * 10.0)
	ok(int(s._bot_overdraw(H, qs, e0)) == 0, "§5: and none when the cap cannot")
	ok(int(s._bot_overdraw(C, qs, e0)) == 0, "§5: a hero without the rune: none")
	_prices = {"Drumfire": float(s._overdraw_price(df)), "Aimed Shot": float(s._overdraw_price(aim))}
	await _clear(s)


# ── §6 — THE CONVERSION ─────────────────────────────────────────────────────

func _s6_conversion() -> void:
	print("\n§6 — Volley and the Ambusher are cores; the Tracker and the Skirmisher are ordinary runes")
	var re: Dictionary = Classes.RULE_ENGINES
	ok(re.has("volley") and re.has("ambusher") and not re.has("quarry_hunt") and not re.has("opening_strike"),
		"§6: the Hunter's rule engines are Volley and the Ambusher")
	var hunter: Array = Classes.class_engines("hunter")
	ok(hunter.size() == 6 and hunter.has("volley") and hunter.has("ambusher"), "§6: six a class (%s)" % str(hunter))
	for pid in ["volley", "ambusher"]:
		var rid := Runes.engine_rune_id(pid)
		ok(rid == "engine_" + pid and Runes.is_engine_rune(rid), "§6: %s has its rune (%s)" % [pid, rid])
		var lines := Classes.engine_desc(pid).split("\n")
		var widest := 0
		for l in lines:
			widest = maxi(widest, l.length())
		ok(widest <= 44 and lines.size() >= 3, "§6: %s's rule is written to the 44-character line (%d)" % [pid, widest])
	for pair in [["engine_quarry_hunt", "Common Foe", "rune_common_foe"], ["engine_opening_strike", "Pounce", "rune_pounce"]]:
		var cfg: Dictionary = Runes.config(pair[0])
		ok(String(cfg.get("name", "")) == pair[1] and not Runes.is_engine_rune(pair[0])
				and is_equal_approx(float(cfg.get("payload", {}).get("stat", {}).get(pair[2], 0.0)), 1.0),
			"§6: %s is an ordinary rune paying %s" % [pair[1], pair[2]])
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	over[3] = {"engines": [], "runes": [_engine_rune("engine_quarry_hunt"), _engine_rune("engine_opening_strike")]}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	var H := _hero(s, "hunter")
	var W := _hero(s, "warrior")
	var foes := _foes(s)
	if H == null or W == null or foes.size() < 2:
		ok(false, "§6: the board seats a Hunter, a Warrior and two enemies")
		await _clear(s)
		return
	var e0: BattleUnit = foes[0]
	var e1: BattleUnit = foes[1]
	ok(is_equal_approx(H.rune_common_foe, 1.0) and is_equal_approx(H.rune_pounce, 1.0),
		"§6: the two runes, worn, pay their fields at the spawn")
	ok(H.opening_armed, "§6: Pounce opens the fight with the bonus armed")
	_reset_foe(e0)
	_reset_foe(e1)
	_ready_to_cast(W)
	await s._resolve(W, W.abilities[0], e1, "good")
	ok(not e1.has_status("tracked"), "§6: the Warrior's blow tracks nobody — the mark is the Hunter's rune")
	_ready_to_cast(H)
	await s._resolve(H, H.abilities[0], e0, "good")
	ok(e0.has_status("tracked") and is_equal_approx(float(s._quarry_mult(e0)), 1.0 + 0.01 * Classes.QUARRY_PCT),
		"§6: Common Foe tracks the first enemy the Hunter damages, and every ally deals %d%% more to it" % Classes.QUARRY_PCT)
	ok(not H.opening_armed, "§6: the Hunter's first attack spent Pounce's bonus")
	H.opening_armed = false
	H.opening_quiet = 0
	H.opening_struck = false
	for _t in Classes.OPENING_QUIET_TURNS:
		s._rule_engine_turn(H)
	ok(H.opening_armed, "§6: Pounce's bonus returns after %d quiet turns" % Classes.OPENING_QUIET_TURNS)
	await _clear(s)


# ── §7 — THE v16 LOAD STEP ──────────────────────────────────────────────────

func _s7_load_step() -> void:
	print("\n§7 — a saved Tracker leaves the core slot as Common Foe")
	var keep_party: Array = _run.party
	var old_tracker: Dictionary = Runes.build("engine_quarry_hunt")
	old_tracker["engine"] = "quarry_hunt"
	old_tracker["payload"] = {}
	old_tracker["equipped"] = true
	var clean: Dictionary = Runes.build("grudge")
	clean["equipped"] = true
	var member := {"key": "hunter", "spec": "", "engines": [old_tracker], "runes": [],
		"engine_offer": ["engine_quarry_hunt", "engine_volley", "engine_field_kit"]}
	var warrior := {"key": "warrior", "spec": "", "engines": [], "runes": [clean], "engine_offer": []}
	_run.party = [member, warrior]
	_run.load_notes = []
	ok(String(_run.call("_rune_answer", old_tracker)) == "rebuild", "§7: a rune whose engine today's definition does not carry is rebuilt")
	seed(SEED)
	var die_before := randi()
	seed(SEED)
	_run.call("_rebuild_stale_payloads")
	_run.call("_reseat_former_cores")
	ok(randi() == die_before, "§7: the load step drew no die")
	var m: Dictionary = _run.party[0]
	ok((m["engines"] as Array).is_empty(), "§7: the core slot is empty")
	var moved: Array = (m["runes"] as Array).filter(func(x): return String(x.get("id", "")) == "engine_quarry_hunt")
	ok(moved.size() == 1 and String(moved[0].get("engine", "")) == ""
			and is_equal_approx(float(moved[0].get("payload", {}).get("stat", {}).get("rune_common_foe", 0.0)), 1.0)
			and bool(moved[0].get("equipped", false)),
		"§7: it is worn among his ordinary runes as Common Foe, paying")
	ok(not (m["engine_offer"] as Array).has("engine_quarry_hunt") and (m["engine_offer"] as Array).size() == 2,
		"§7: the deal drops the id that is no core now and keeps the two that are (%s)" % str(m["engine_offer"]))
	ok((_run.load_notes as Array).any(func(n): return String(n).contains("ordinary rune now")),
		"§7: the move is said where the player reads")
	var w: Dictionary = _run.party[1]
	ok((w["runes"] as Array).size() == 1 and bool(w["runes"][0].get("equipped", false))
			and String(w["runes"][0].get("id", "")) == "grudge", "§7: a clean rune is untouched")
	_run.party = keep_party
	_run.load_notes = []


# ── §8 — MASTER's FIGURES ───────────────────────────────────────────────────
# One passage of the page, from `head` to the first `tail` after it, its line breaks read as spaces.
func _passage(src: String, head: String, tail: String) -> String:
	var i := src.find(head)
	if i < 0:
		return ""
	var j := src.find(tail, i + head.length())
	return src.substr(i, (j if j > 0 else src.length()) - i).replace("\n", " ")


func _s8_masters_figures() -> void:
	print("\n§8 — master.html's figures for the two new cores and the two new runes, read against their constants")
	const WORDS := ["no", "one", "two", "three", "four", "five", "six"]
	var page := FileAccess.get_file_as_string("res://docs/master.html")
	var vo := _passage(page, "<li><b>Volley</b> (Hunter):", "</li>")
	var am := _passage(page, "<li><b>Ambusher</b> (Hunter):", "</li>")
	var cf := _passage(page, "<b>Common Foe</b> &mdash;", "<b>Pounce</b>")
	var po := _passage(page, "<b>Pounce</b> &mdash;", "<b>Burning Ground")
	var vk := _passage(page, "<li><b>V — Overdraw", "</li>")
	var found := [vo, am, cf, po, vk].filter(func(x): return x != "").size()
	print("    CHECKED %d of 5 passages found" % found)
	ok(found == 5, "§8: every passage this section reads is on the page (%d of 5)" % found)
	var st: int = Classes.VOLLEY_STEP
	ok(vo.contains("%d for the first to land, %d for the second, %d for the third" % [st, st * 2, st * 3]),
		"§8: Volley's steps read VOLLEY_STEP (%d, %d, %d)" % [st, st * 2, st * 3])
	var clean := "twice" if Classes.VOLLEY_CLEAN_MULT == 2 else "%d times" % Classes.VOLLEY_CLEAN_MULT
	ok(vo.contains("the last one's buildup counts %s" % clean), "§8: the clean volley reads VOLLEY_CLEAN_MULT (%s)" % clean)
	var fl := int(round(Classes.VOLLEY_RIDER_FLOOR * 100.0))
	ok(vo.contains("rolls at least %d%% of its damage" % fl), "§8: the rider reads VOLLEY_RIDER_FLOOR (%d%%)" % fl)
	ok(am.contains("add up to %d copies" % Classes.OVERDRAW_MAX_ARROWS),
		"§8: the Ambusher's copies read OVERDRAW_MAX_ARROWS (%d)" % Classes.OVERDRAW_MAX_ARROWS)
	ok(am.contains("never more than %.1f initiative in all" % Classes.OVERDRAW_MAX_DELAY),
		"§8: the Ambusher's cap reads OVERDRAW_MAX_DELAY (%.1f)" % Classes.OVERDRAW_MAX_DELAY)
	var pr := "%.1f for Drumfire, %.1f for Aimed Shot" % [float(_prices.get("Drumfire", -1.0)), float(_prices.get("Aimed Shot", -1.0))]
	ok(_prices.size() == 2 and am.contains(pr), "§8: the two worked prices are the cast's own (%s)" % pr)
	ok(cf.contains("deal %d%% more damage" % Classes.QUARRY_PCT), "§8: Common Foe reads QUARRY_PCT (%d%%)" % Classes.QUARRY_PCT)
	ok(po.contains("deals %d%% more damage" % Classes.OPENING_BONUS_PCT),
		"§8: Pounce's bonus reads OPENING_BONUS_PCT (%d%%)" % Classes.OPENING_BONUS_PCT)
	var qt: int = Classes.OPENING_QUIET_TURNS
	ok(qt < WORDS.size() and po.contains("returns once %s of his turns pass" % WORDS[qt]),
		"§8: Pounce's quiet turns read OPENING_QUIET_TURNS (%d)" % qt)
	ok(vk.contains("arrow, up to %d, and then none" % Classes.OVERDRAW_MAX_ARROWS),
		"§8: the V control's count reads OVERDRAW_MAX_ARROWS (%d)" % Classes.OVERDRAW_MAX_ARROWS)


func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
