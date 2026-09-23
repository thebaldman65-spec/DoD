# BATCH HC — THE RUNES LEAVE THEIR SPECS.
#
#   §1  THE SCOPE'S DOORS — `_scope_ok` passes a rune's own class and universal and
#       refuses a `spec:` entry and another class's; and a stale band reaches no
#       screen — HC's `shown_scope` read it off the data; since HE §4 no screen shows
#       a band at all, none reads one off an instance or asks for one, and a rune
#       built today carries none
#   §2  LAYERED AEGIS AT A CACHE'S ANSWER — rolled with Conviction slotted and
#       answered with it out: nothing handed over and all three kept stored; slotted
#       again, all three handed back; and it sits out without the engine
#   §3  THE EVENT VERB PREFERS AN ORDINARY RUNE — a Warrior holding no engine is
#       granted ordinary runes and no engine rune while one is eligible; a Cleric
#       holding none, with no ordinary rune eligible, is still granted a rune (since
#       HF a Cleric carrying every ordinary rune he could be offered, and one
#       carrying nothing is granted ordinary runes, HF's five)
#   §4  THE PITY METER COUNTS CASTS — an area attack on three enemies, a multi-hit
#       of three and a single shot each climb it ONE step; a crit resets it
#   §5  THE ZONE BOSS'S FIRST TIER ASKS THE PET — no companion card rolled while
#       Lethal Aim is slotted, in either order, and some with Pack Bond alone; a
#       stored triple is held back at the answer, kept, and handed back when Lethal
#       Aim leaves the slots
#   §6  PACK BOND BESIDE LETHAL AIM SITS OUT, VISIBLY — the predicate in both
#       orders and not with either out; the pairing still offered; GX's sentence,
#       word for word, on the pouch's engine row, the map card's engine line and its
#       hover, the hero sheet's state column and the battle log's roll call — and
#       none of it with Lethal Aim out
#   §7  THE PLAYER'S FILES
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM**, the brief's rule: a door that
# refuses is asked the same question where it must pass, on the same member, so a
# door wired shut reads red rather than green.
#
# **WHAT THIS GATE DOES NOT ASK, AND WHERE IT IS ASKED.** What a hero of each class
# can be offered — with no engine, each engine and every pair — is `check_gv` §3;
# the rows themselves are `check_gv` §0-§1; that no script reads `written_for` is
# `test_runes`. This gate asks what HC built beside them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hc.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://hc_profile.json"
const SCRATCH_RELICS := "user://hc_relics.json"
const AEGIS_TRIPLE := ["layered_aegis", "fourth_stack", "deep_absorb"]
const PET_TRIPLE := ["Bestial Wrath", "Spirit Bond", "Primal Surge"]
const AMBER := Color(0.85, 0.7, 0.45)

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HC — THE RUNES LEAVE THEIR SPECS")
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
	_s1_the_scope()
	_s2_layered_aegis()
	_s3_the_event_verb()
	await _s4_the_pity_meter()
	_s5_the_boss_offer()
	await _s6_pack_beside_lethal()
	_s7_the_players_files()
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
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _eng(pid: String, on := true) -> Dictionary:
	var r: Dictionary = Runes.build(Runes.engine_rune_id(pid))
	r["equipped"] = on
	return r


func _names(runes: Array) -> Array:
	return runes.map(func(c): return String((c as Dictionary).get("name", "")))


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return s.get("enemies").filter(func(e): return not e.dead)


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _labels(n: Node, out: Array) -> void:
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _labels_with(n: Node, needle: String) -> Array:
	var all: Array = []
	_labels(n, all)
	return all.filter(func(l): return String((l as Label).text).contains(needle))


# A party of four seated on the map with nothing slotted, and the Hunter's seat
# holding `engines`.
func _seat_party(hunter_engines: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
		_run.party[i]["runes"] = []
	_run.party[3]["spec"] = "beastmaster"
	_run.party[3]["engines"] = hunter_engines
	_run.specs_chosen = true
	_run.active = true


# ── §1 — THE SCOPE'S DOORS ──────────────────────────────────────────────────

func _s1_the_scope() -> void:
	print("\n§1 — the scope's doors: two bands, read off the data")
	var w := {"key": "warrior", "spec": "berserker"}
	ok(Runes._scope_ok({"scope": "class:warrior"}, w),
		"§1: `_scope_ok` refuses a Warrior his own class's rune")
	ok(Runes._scope_ok({"scope": "universal"}, w),
		"§1: `_scope_ok` refuses a Warrior a universal rune")
	ok(not Runes._scope_ok({"scope": "class:mage"}, w),
		"§1: `_scope_ok` passes a Warrior a Mage rune")
	ok(not Runes._scope_ok({"scope": "spec:berserker"}, w),
		"§1: `_scope_ok` passes a `spec:` entry for its own lineage — the spec branch is back, and a scope is read as a spec after the data stopped being one")
	# AN INSTANCE CACHED BEFORE HC carries `Spec` in its own band fields, and HC's
	# door (`shown_scope`) read the band off the data so no screen showed it.
	# **BATCH HE §4 — NO SCREEN SHOWS A BAND AT ALL (ruled), SO THE QUESTION IS
	# REPAIRED TO WHAT IT WAS FOR: A STALE BAND REACHES NO SURFACE.** The door is
	# deleted with the band; what keeps an old instance's `Spec` off the screens is
	# that none reads its band fields (below), none asks a band door, and a rune
	# built today carries no band to go stale.
	var fresh: Dictionary = Runes.build("bared_plate")
	ok(not fresh.has("scope_label") and not fresh.has("scope_color"),
		"§1: a rune built today still carries a band (%s) — it would ride the save and go stale as HC's did" % str(fresh.keys()))
	# NO SCREEN READS A BAND OFF AN INSTANCE, AND NONE ASKS FOR ONE; ALL THREE DRAW
	# A RUNE IN THE ONE TINT — the positive arm, so a screen that stopped drawing
	# runes cannot pass for one that stopped drawing bands.
	var readers: Array = []
	var askers := 0
	var tinted := 0
	for f in ["scripts/shop_screen.gd", "scripts/map_screen.gd", "scripts/party_screen.gd"]:
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + String(f)))
		ok(src != "", "§1: %s read back empty" % f)
		if src.contains("[\"scope_label\"]") or src.contains("[\"scope_color\"]") \
				or src.contains(".get(\"scope_label\"") or src.contains(".get(\"scope_color\""):
			readers.append(f)
		if src.contains("shown_scope(") or src.contains("scope_band("):
			askers += 1
		if src.contains("Runes.RUNE_TINT"):
			tinted += 1
	ok(readers.is_empty(), "§1: %s read a rune's band off the instance, which rides the save" % [readers])
	ok(askers == 0, "§1: %d of the three screens ask for a rune's band — HE §4 dropped it from every surface" % askers)
	ok(tinted == 3, "§1: %d of the three screens draw a rune in `Runes.RUNE_TINT` — the band's tint went, the rune did not" % tinted)


# ── §2 — LAYERED AEGIS AT A CACHE'S ANSWER ──────────────────────────────────

func _s2_layered_aegis() -> void:
	print("\n§2 — Layered Aegis: its card leaves with Conviction, so the answer asks the engine")
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	ok(Runes.engine_read("layered_aegis") == "conviction",
		"§2: Layered Aegis is not a Conviction row (`Runes.ENGINE_READ`)")
	var c := {"key": "cleric", "spec": "", "runes": [], "bm_abilities": [],
		"engines": [_eng("conviction")], "awakened": true}
	# THE ROLL, ITS POSITIVE ARM: with Conviction slotted it is in the pool.
	ok(Runes.eligible_ids(c, []).has("layered_aegis"),
		"§2: with Conviction slotted Layered Aegis is not in the pool — the arms below prove nothing")
	c["rune_candidates"] = [AEGIS_TRIPLE.map(func(i): return Runes.build(String(i)))]
	c["rune_picks_owed"] = 1
	var want: Array = AEGIS_TRIPLE.map(func(i): return String(Runes.config(String(i)).get("name", "")))
	var slotted: Array = _names(_run.rune_choice(c))
	ok(slotted == want, "§2: answered with Conviction slotted the cache hands over %s, not %s" % [slotted, want])
	(c["engines"][0] as Dictionary)["equipped"] = false
	var out_now: Array = _names(_run.rune_choice(c))
	ok(out_now.is_empty(),
		"§2: answered with Conviction out the cache hands over %s — Layered Aegis's card left with the engine" % [out_now])
	ok(_names(_run.rune_choice_withheld(c)) == want,
		"§2: ...and the overlay's held-back list is %s, not the three" % [_names(_run.rune_choice_withheld(c))])
	ok(_names((c["rune_candidates"] as Array)[0]) == want,
		"§2: ...and the stored triple was changed (%s) — a state the player can undo is filtered, never repaired away" % [
			_names((c["rune_candidates"] as Array)[0])])
	(c["engines"][0] as Dictionary)["equipped"] = true
	ok(_names(_run.rune_choice(c)) == want,
		"§2: Conviction slotted again, the cache does not hand the three back (%s)" % [_names(_run.rune_choice(c))])
	ok(Runes.sits_out("layered_aegis", []) and not Runes.sits_out("layered_aegis", ["conviction"]),
		"§2: Layered Aegis does not sit out without Conviction, or sits out with it")
	print("    rolled with Conviction in, answered with it out: 0 handed over, 3 kept; back in: %s" % [want])


# ── §3 — THE EVENT VERB PREFERS AN ORDINARY RUNE ────────────────────────────

func _s3_the_event_verb() -> void:
	print("\n§3 — the event verb: an ordinary rune wherever one is eligible")
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	var wm := {"key": "warrior", "spec": "", "runes": [], "bm_abilities": [], "engines": [],
		"awakened": true}
	var ordinary := 0
	var engine := 0
	for _i in 60:
		var g: Dictionary = _run.grant_rune(wm)
		if g.is_empty():
			continue
		if Runes.is_engine_rune(String(g.get("id", ""))):
			engine += 1
		else:
			ordinary += 1
	ok(engine == 0 and ordinary == 60,
		"§3: a Warrior holding no engine was granted %d engine runes and %d ordinary of 60 — the verb no longer prefers an ordinary rune" % [
			engine, ordinary])
	# **BATCH HF — A CLERIC HOLDING NO ENGINE IS OFFERED ORDINARY RUNES NOW** (HF
	# §1's five, which read no engine), so he is the Warrior's case: the verb hands
	# him ordinary runes. The fall-back's premise — nothing ordinary eligible — is
	# built instead: the same Cleric already carrying every ordinary rune he could be
	# offered. The arm's question is unchanged: with nothing ordinary left, the
	# verb still pays.
	var cn := {"key": "cleric", "spec": "", "runes": [], "bm_abilities": [], "engines": [],
		"awakened": true}
	var c_ordinary := 0
	for _k in 20:
		var g3: Dictionary = _run.grant_rune(cn)
		if not g3.is_empty() and not Runes.is_engine_rune(String(g3.get("id", ""))):
			c_ordinary += 1
	ok(c_ordinary == 20,
		"§3: a Cleric holding no engine was granted %d ordinary runes of 20 — HF's five read no engine, so the verb prefers one" % c_ordinary)
	var cm := {"key": "cleric", "spec": "", "runes": [], "bm_abilities": [], "engines": [],
		"awakened": true}
	for e in Runes.eligible_ids(cm, []):
		if not Runes.is_engine_rune(String(e)):
			(cm["runes"] as Array).append(Runes.build(String(e)))
	# What he owns is passed by name, as the verb itself passes it (`grant_rune`).
	var cm_owned: Array = (cm["runes"] as Array).map(func(r): return String(r["name"]))
	ok(cm_owned.size() >= 5
			and Runes.eligible_ids(cm, cm_owned).all(func(i): return Runes.is_engine_rune(String(i))),
		"§3: the Cleric carrying every ordinary rune he could be offered (%d) is still eligible for an ordinary one (%s)" % [
			cm_owned.size(), Runes.eligible_ids(cm, cm_owned).filter(func(i): return not Runes.is_engine_rune(String(i)))])
	var c_engine := 0
	for _j in 20:
		var g2: Dictionary = _run.grant_rune(cm)
		if Runes.is_engine_rune(String(g2.get("id", ""))):
			c_engine += 1
	ok(c_engine == 20,
		"§3: a Cleric holding no engine — no ordinary rune eligible — was granted %d runes of 20; the fall-back stopped paying" % c_engine)
	print("    a no-engine Warrior: %d ordinary of 60; a no-engine Cleric: %d ordinary of 20, and carrying his %d: %d engine runes of 20" % [
		ordinary, c_ordinary, (cm["runes"] as Array).size(), c_engine])


# ── §4 — THE PITY METER COUNTS CASTS ────────────────────────────────────────
#
# **THE CRIT IS FORCED THROUGH THE METER ITSELF**, which the roll reads into the
# same total it spends: nothing else on the hero is set. The deterministic fixture
# keeps every other crit off.

func _s4_the_pity_meter() -> void:
	print("\n§4 — the pity meter: one step a cast that lands without a critical")
	var step := BattleUnit.PITY_CRIT_STEP
	for card in ["Called Volley", "Triple Shot", "Quick Shot"]:
		for crit_on in [false, true]:
			var over := {3: {"bm_abilities": ["Called Volley", "Triple Shot"],
				"bm_equipped": ["Called Volley", "Triple Shot"], "engines": [_eng("lethal_aim")]}}
			var s: Node = await Gate.spawn(self, ["", "", "", "sharpshooter"],
				{"party": over, "deterministic": true})
			var u: BattleUnit = _hero(s, "hunter")
			var foes := _foes(s)
			for e in foes:
				e.max_hp = 100000
				e.hp = 50000
			u.crit_pity = 5.0 if crit_on else 0.0
			u.resource = 9999
			u.cooldowns.clear()
			var ab: Ability = s._find_ability(u, String(card))
			ok(ab != null, "§4: %s is not on the Sharpshooter's bar" % card)
			if ab == null:
				await _clear(s)
				continue
			var hp_before: Array = foes.map(func(e): return e.hp)
			Engine.time_scale = 50.0
			await s._resolve(u, ab, foes[0], "good")
			Engine.time_scale = 1.0
			var struck := 0
			for i in foes.size():
				if foes[i].hp < int(hp_before[i]):
					struck += 1
			if crit_on:
				ok(is_zero_approx(u.crit_pity),
					"§4: %s critted and the meter reads %+.0f%% — a crit resets it" % [card, u.crit_pity * 100.0])
			else:
				ok(is_equal_approx(u.crit_pity, step),
					"§4: %s (%d struck, %d hits) climbed the meter to %+.0f%% — one cast is ONE step, %+.0f%%" % [
						card, struck, maxi(ab.multi_hits, 1), u.crit_pity * 100.0, step * 100.0])
				# THE POSITIVE ARMS: the cast really was what its row says it is.
				if card == "Called Volley":
					ok(struck >= 3, "§4: Called Volley struck %d enemies — the area arm did not reach three" % struck)
				elif card == "Triple Shot":
					ok(ab.multi_hits >= 3 and struck >= 1,
						"§4: Triple Shot is %d hits on %d struck — the multi-hit arm is not one" % [ab.multi_hits, struck])
			print("    %-13s crit %-3s  struck %d, hits %d   meter %+.0f%%" % [card, "ON" if crit_on else "off",
				struck, maxi(ab.multi_hits, 1), u.crit_pity * 100.0])
			await _clear(s)


# ── §5 — THE ZONE BOSS'S FIRST TIER ASKS THE PET ────────────────────────────

func _s5_the_boss_offer() -> void:
	print("\n§5 — the zone boss's first tier: the pet half of the gate, and not the engine half")
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for arm in [["pack"], ["pack", "lethal_aim"], ["lethal_aim", "pack"]]:
		var m := {"key": "hunter", "spec": "beastmaster", "runes": [], "bm_abilities": [],
			"engines": arm.map(func(p): return _eng(String(p))), "awakened": true}
		var draws := 0
		var comp := 0
		for _i in 200:
			for n in _run.roll_spec_ability_offer(m):
				draws += 1
				if Classes.reads_companion(String(n)):
					comp += 1
		if arm.has("lethal_aim"):
			ok(comp == 0 and draws > 0,
				"§5: with %s slotted the first tier rolled %d companion cards in %d draws" % [arm, comp, draws])
		else:
			ok(comp > 0, "§5: with Pack Bond alone the first tier rolled no companion card in %d draws — the arm above proves nothing" % draws)
		print("    engines %-24s %d draws, %d of them companion cards" % [str(arm), draws, comp])
	# THE ANSWER: a triple stored with the pet present.
	var h := {"key": "hunter", "spec": "beastmaster", "runes": [], "bm_abilities": [],
		"engines": [_eng("pack"), _eng("lethal_aim", false)], "awakened": true,
		"bm_candidates": [PET_TRIPLE.duplicate()], "bm_picks_owed": 1}
	ok(_run.ability_choice(h) == PET_TRIPLE,
		"§5: with the pet present the stored triple answers %s" % [_run.ability_choice(h)])
	(h["engines"][1] as Dictionary)["equipped"] = true
	ok((_run.ability_choice(h) as Array).is_empty() and _run.ability_choice_withheld(h) == PET_TRIPLE,
		"§5: with Lethal Aim slotted the answer hands over %s and holds back %s" % [
			_run.ability_choice(h), _run.ability_choice_withheld(h)])
	ok((h["bm_candidates"] as Array)[0] == PET_TRIPLE,
		"§5: ...and the stored triple was changed (%s)" % [(h["bm_candidates"] as Array)[0]])
	(h["engines"][1] as Dictionary)["equipped"] = false
	ok(_run.ability_choice(h) == PET_TRIPLE,
		"§5: Lethal Aim out of the slots again, the three are not handed back (%s)" % [_run.ability_choice(h)])


# ── §6 — PACK BOND BESIDE LETHAL AIM SITS OUT, VISIBLY ──────────────────────

func _s6_pack_beside_lethal() -> void:
	print("\n§6 — the Rune of the Beastmaster beside the Rune of the Sharpshooter")
	var bm_name := String(Runes.config("engine_beastmaster").get("name", ""))
	ok(bm_name != "", "§6: the Rune of the Beastmaster did not resolve")
	# THE PREDICATE: both orders sit out; Lethal Aim held but out, or absent, does not.
	var arms := [[[["pack", true], ["lethal_aim", true]], true], [[["lethal_aim", true], ["pack", true]], true],
		[[["pack", true], ["lethal_aim", false]], false], [[["pack", true]], false]]
	for a in arms:
		var engs: Array = (a[0] as Array).map(func(x): return _eng(String(x[0]), bool(x[1])))
		var m := {"key": "hunter", "spec": "beastmaster", "runes": [], "engines": engs}
		var out: bool = (_run.sitting_out_rune_names(m) as Array).has(bm_name)
		ok(out == bool(a[1]), "§6: engines %s — the Rune of the Beastmaster %s" % [
			str(a[0]), "does not sit out" if bool(a[1]) else "sits out"])
	# RULED LEGAL: still offered, and not a row of the offer's pet table.
	ok(Runes.offerable("engine_beastmaster", ["lethal_aim"]),
		"§6: the Rune of the Beastmaster is withheld from a Lethal Aim holder — the pairing was ruled legal")
	ok(not Runes.reads_companion("engine_beastmaster"),
		"§6: the Rune of the Beastmaster is a `COMPANION_READ` row — that table is the OFFER's")
	var held := ["pack", "lethal_aim"]
	var note: String = _run.rune_sits_out_note("engine_beastmaster", held)
	# GX's sentence is hand-broken at 44 characters for the tooltips that do not
	# wrap, so it is read flattened.
	var flat := note.replace("\n", " ")
	ok(flat.begins_with("Sits out of every fight while the Rune of the Sharpshooter is equipped"),
		"§6: the note does not open with GX's clause naming the dismisser: %s" % flat)
	ok(flat.contains("Still worn: the slot stays filled.") and flat.contains("Unequipping the rune frees the slot."),
		"§6: the note is not GX's rune sentence: %s" % flat)
	# THE SURFACES, ON THE REAL SCREENS, BOTH WAYS.
	for lethal_in in [true, false]:
		var tag := "Lethal Aim in" if lethal_in else "Lethal Aim out"
		_seat_party([_eng("pack"), _eng("lethal_aim", lethal_in)])
		change_scene_to_file("res://scenes/map.tscn")
		await Gate.frames(self, 6)
		var mp: Node = current_scene
		# THE MAP CARD'S ENGINE LINE.
		var seen := {"card": "none", "row": "none"}
		var line: Label = null
		for l in _labels_with(mp, "engines:"):
			if String((l as Label).text).contains("Beastmaster"):
				line = l
		ok(line != null, "§6 (%s): the Hunter's card drew no engine line" % tag)
		if line != null:
			var marked: bool = String(line.text).contains("○")
			var amber: bool = line.get_theme_color("font_color").is_equal_approx(AMBER)
			ok(marked == lethal_in and amber == lethal_in,
				"§6 (%s): the card's engine line reads '%s' (marked %s, amber %s)" % [tag, line.text, marked, amber])
			seen["card"] = "marked, amber" if marked and amber else ("plain" if not marked and not amber else "mixed")
		# ITS HOVER.
		var hover := 0
		var btns: Array = []
		Gate.buttons(mp, btns, false)
		for b in btns:
			if String((b as Button).tooltip_text).ends_with(note):
				hover += 1
		ok(hover == (1 if lethal_in else 0), "§6 (%s): %d card hovers carry the sentence" % [tag, hover])
		# THE POUCH'S ENGINE ROW.
		mp._open_rune_panel(3)
		await Gate.frames(self, 2)
		var ov: Node = Gate.overlay(mp, 60)
		var row: Label = null
		if ov != null:
			for l2 in _labels_with(ov, bm_name + " — "):
				row = l2
		ok(row != null, "§6 (%s): the pouch drew no row for the Rune of the Beastmaster" % tag)
		if row != null:
			var says: bool = String(row.text).ends_with(" — " + note.replace("\n", " "))
			var amber2: bool = row.get_theme_color("font_color").is_equal_approx(AMBER)
			ok(says == lethal_in and amber2 == lethal_in,
				"§6 (%s): the pouch row reads '%s' (the sentence %s, amber %s)" % [tag, row.text, says, amber2])
			seen["row"] = "the sentence, amber" if says and amber2 else ("the rule" if not says and not amber2 else "mixed")
		if ov != null:
			ov.queue_free()
		await Gate.frames(self, 2)
		# THE HERO SHEET'S STATE COLUMN.
		_run.hero_screen_idx = 3
		change_scene_to_file("res://scenes/party.tscn")
		await Gate.frames(self, 6)
		var sheet: Node = current_scene
		var state_n := 0
		for l3 in _labels_with(sheet, "sits out"):
			if String((l3 as Label).text) == "sits out" and String((l3 as Label).tooltip_text) == note:
				state_n += 1
		ok(state_n == (1 if lethal_in else 0), "§6 (%s): the sheet's state column says `sits out` with the sentence %d times" % [tag, state_n])
		_run.active = false
		# THE BATTLE LOG'S ROLL CALL.
		var over := {3: {"engines": [_eng("pack"), _eng("lethal_aim", lethal_in)]}}
		var s: Node = await Gate.spawn(self, ["", "", "", "beastmaster"], {"party": over, "deterministic": true})
		var lines := note.split("\n")
		var want_tail := "%s — %s %s" % [bm_name, lines[0], lines[1]]
		var called := 0
		for rc in s.get("_rune_roll_call"):
			if String(rc).ends_with(want_tail):
				called += 1
		ok(called == (1 if lethal_in else 0), "§6 (%s): the roll call said it %d times" % [tag, called])
		print("    %s: card line %s, hover %d, pouch row %s, sheet %d, roll call %d" % [tag,
			seen["card"], hover, seen["row"], state_n, called])
		await _clear(s)


# ── §7 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	print("\n§7 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§7: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§7: %s is byte for byte as this gate found it" % p)
