# BATCH IR — THE SEVEN THE CENSUS FOUND IN THE CODE, AND THE RENAME MAP.
#
#   §0   The rulings recorded, each pinned in the file it binds.
#   §1a  A NODE THAT ARMS A FIXED MODIFIER OFFERS NO BARGAIN (the designer's). The predicate on every rung and node, and
#        DRIVEN through the real map: Ruin's mini-boss walks straight into its fight under a modifier of the fixed band,
#        with no offer and no reward; Warden's mini-boss and Ruin's elite still meet the offer screen; a resumed Ruin
#        mini-boss goes back to its fight; the sim asks the same question; the map's hover says what the node does; and the
#        first run's framing card says it too, its one button on the 720-px screen (it stood below it).
#   §1b  A CARD WHOSE WORDS SAY *HERO* OFFERS ONLY THE HEROES. Every ally-target card in the game, sorted by the words
#        that name its pick (the census's table, which must be the population), read against `_ally_pick_pool` with a
#        companion standing — and Undying Vigil DRIVEN through the player's real turn and real picker.
#   §1c  NO CARD SAYS *EVERYONE*: every card's words and every chip, swept; Aegis Wall's heal walks the heroes and its
#        words say hero; Hunter's Mark reaches a companion's blow and its words say ally.
#   §1d  A FLOOR PAYS ONLY WHEN WHAT IT IS A SHARE OF IS THERE. Tithe DRIVEN: a blow that lands Break heals, one into a
#        Broken body, under Deadened or rounded to nothing by Constitution heals nobody. Sacred Resolve's split DRIVEN: a
#        blow parried outright bills no bound hero.
#   §1e  EVERY AFFLICTION THE GAME LISTS HAS A GLOSSARY ENTRY AT THE CHIP's DOOR — the population (`DEBUFF_IDS`) read
#        through `Glossary.status_short`, the door the chip reads, never a list of seven.
#   §1f  A BOW USER's BLOCKED SHOT PLAYS THE BOW's OWN SOUND — DRIVEN: an Orc Archer's arrow and a Hunter's, each into
#        an Interpose charge; a raider's blocked blow still rings the parry.
#   §1g  EVERY TARGETING KIND THAT ROLLS ITS MISS PER STRIKE IS NAMED IN THE SINGLE-TARGET GUARD, read off `Ability`'s
#        own fields; and a choose-three cast DRIVEN with its first target one it cannot hit: the other two are struck or
#        roll their own miss, and the first rolls once.
#   §2   THE RENAME MAP, AT THE LOAD DOOR (the designer's). DRIVEN through the real save and the real load: every card
#        name a save carries, in every place it carries one, read by today's name; a name that was never a card left
#        as it is and said out loud; a clean save untouched; no die spent; and the four reads that took an old name
#        straight now resolve it.
#   §9   The player's files are as this gate found them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ir.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ir_profile.json"
const SCRATCH_RELICS := "user://ir_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]

# §1b — THE CENSUS's TABLE: every ally-target card in the game, by the words that name its pick. HERO cards offer only
# the heroes; ALLY cards offer a companion too; OWN is Resurrection's own pool of the fallen. The phrase is the card's
# own, so a card reworded away from its row reds here. IR's report, §1b, holds the census and why each sits where it does.
const ALLY_CARDS := {
	"Rally": ["HERO", "Shout one hero forward"],
	"Covering Guard": ["HERO", "aimed at one hero"],
	"Undying Vigil": ["HERO", "Keep watch over one hero"],
	"Renewal": ["HERO", "A hero heals"],
	"Rite of Return": ["HERO", "Promise one hero"],
	"Recant": ["HERO", "one hero regains"],
	"Blessing of Zeal": ["HERO", "Kindle a hero"],
	"Vow of Suffering": ["HERO", "that hero takes"],
	"Aegis Reversal": ["HERO", "consumes a hero's Divine Shield"],
	"Fortified Spirit": ["HERO", "Lend one hero"],
	"Ministration": ["ALLY", "heal one ally"],
	"Unburden": ["ALLY", "from one ally"],
	"Heal": ["ALLY", "Mend an ally"],
	"Divine Plea": ["ALLY", "heal an ally"],
	"Dawnbreak": ["ALLY", "heal an ally"],
	"Second Wind": ["ALLY", "heal an ally"],
	"Vespers": ["ALLY", "that ally below"],
	"Divine Shield": ["ALLY", "Grant an ally"],
	"Mantle": ["ALLY", ""],
	"Resurrection": ["OWN", "a fallen hero"],
}

# §2 — the five renames since BM's v10 floor (derived from `classes.gd`'s history, IR's report §2), and what each reads as.
const RENAMES := {"Iron Will": "Ironclad", "Anathema": "Breaking Darkness", "Jubilee": "Blessing of the Faithful",
	"Matins": "Divine Presence", "Magic Barrier": "Nexus Ward"}
const NEVER_A_CARD := "IR Never A Card"

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IR — THE SEVEN THE CENSUS FOUND IN THE CODE, AND THE RENAME MAP")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a fight is spawned")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	var had_harness := FileAccess.file_exists(String(_run.save_path))
	var harness := FileAccess.get_file_as_bytes(String(_run.save_path)) if had_harness else PackedByteArray()
	_fresh_meta()
	var marks := PackedStringArray()
	var ts := Time.get_ticks_msec()
	_s0_the_rulings()
	await _s1a_fixed_modifier()
	marks.append("§1a %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s1b_hero_picks()
	marks.append("§1b %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s1c_no_everyone()
	await _s1d_floors()
	marks.append("§1d %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s1e_glossary()
	await _s1f_bow_blocked()
	await _s1g_choose_three()
	marks.append("§1fg %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s2_rename_map()
	marks.append("§2 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	# The harness save back as this gate found it.
	if had_harness:
		var fr := FileAccess.open(String(_run.save_path), FileAccess.WRITE)
		fr.store_buffer(harness)
		fr.close()
	else:
		_remove(String(_run.save_path))
	_run.active = false
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 3)
	_s9_the_players_files()
	print("\n    runtime %.1f s (%s)" % [(Time.get_ticks_msec() - t0) / 1000.0, ", ".join(marks)])
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


func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		at = src.find("\nstatic func " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _new_run(difficulty: String) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], difficulty)
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true


func _scene_base() -> String:
	if current_scene == null:
		return "<none>"
	return String(current_scene.scene_file_path).get_file().get_basename()


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


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _words(t: String) -> String:
	return t.replace("\n", " ")


# ── §0 — THE RULINGS, PINNED IN THE FILE EACH BINDS ─────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings recorded, each in the file it binds")
	var cl := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var st := FileAccess.get_file_as_string("res://docs/state.md")
	var pins := [
		[cl, "CLAUDE.md", "A RENAME THAT CROSSES THE SAVE FLOOR ADDS A ROW TO THE LOAD DOOR's RENAME MAP, IN THE BATCH THAT RENAMES"],
		[cl, "CLAUDE.md", "A NODE THAT ARMS A FIXED MODIFIER OFFERS NO BARGAIN"],
		[cl, "CLAUDE.md", "A CARD WHOSE WORDS SAY *HERO* OFFERS ONLY THE HEROES"],
		[ir, "docs/instrument-rules.md", "A CLOSE THAT IS GATED ON ITS OWN INSTRUMENT CAN DEADLOCK, AND A BATCH IS NOT DONE UNTIL ITS CLOSE HAS RUN"],
		[st, "docs/state.md", "THE INDEX PILOT IS IS's"],
	]
	for p in pins:
		ok(String(p[0]).contains(String(p[2])), "§0: %s does not hold '%s'" % [p[1], p[2]])


# ── §1a — A NODE THAT ARMS A FIXED MODIFIER OFFERS NO BARGAIN ────────────────

func _open_nodes(s: Node) -> Array:
	var out: Array = []
	var btns: Array = []
	Gate.buttons(s, btns, false)
	for b in btns:
		if (b as Button).disabled:
			continue
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_on_node_pressed" and not cb.get_bound_arguments().is_empty():
				out.append(int(cb.get_bound_arguments()[0]))
	return out


func _press_node(s: Node, j: int) -> bool:
	var btns: Array = []
	Gate.buttons(s, btns, false)
	for b in btns:
		if (b as Button).disabled:
			continue
		for c in (b as Button).pressed.get_connections():
			var cb: Callable = c["callable"]
			if cb.get_method() == "_on_node_pressed" and cb.get_bound_arguments() == [j]:
				(b as Button).emit_signal("pressed")
				return true
	return false


# The party stood one step before the first node of `want`, the map open on it. Returns that node's index, or -1.
func _stand_before(want: String) -> int:
	for s in (_run.map as Array).size():
		for j in (_run.map[s] as Array).size():
			if String(_run.map[s][j]["type"]) != want:
				continue
			if s == 0:
				_run.slot_idx = -1
				_run.node_idx = 0
			else:
				_run.slot_idx = s - 1
				_run.node_idx = -1
				for k in (_run.map[s - 1] as Array).size():
					if (_run.map[s - 1][k].get("next", []) as Array).has(j):
						_run.node_idx = k
						break
				if _run.node_idx < 0:
					continue
			change_scene_to_file("res://scenes/map.tscn")
			await Gate.frames(self, 5)
			return j
	return -1


func _s1a_fixed_modifier() -> void:
	print("\n§1a — a node that arms a fixed modifier offers no bargain")
	ok(_run.has_method("offers_bargain") and _run.has_method("arms_fixed_modifier"),
		"§1a: `Run.offers_bargain` / `Run.arms_fixed_modifier` — the one question — is not in the game")
	if not (_run.has_method("offers_bargain") and _run.has_method("arms_fixed_modifier")):
		return
	# THE PREDICATE, EVERY RUNG AND EVERY NODE THAT CAN CARRY EITHER: the two never meet.
	var kinds: Array = (_run.BARGAIN_NODES as Array) + (_run.FIXED_MODIFIER_NODES as Array) + ["fight"]
	var met := []
	var read := []
	for rung in _run.DIFFICULTY_ORDER:
		_run.difficulty = String(rung)
		for ty in kinds:
			var arms: bool = _run.arms_fixed_modifier(String(ty))
			var offers: bool = _run.offers_bargain(String(ty))
			if arms and offers:
				met.append("%s/%s" % [rung, ty])
			read.append("%s/%s:%s%s" % [rung, ty, "A" if arms else "-", "B" if offers else "-"])
	ok(met.is_empty(), "§1a: a node that arms a fixed modifier is also offered a bargain: %s" % str(met))
	_run.difficulty = "ruin"
	ok(_run.arms_fixed_modifier("miniboss") and not _run.offers_bargain("miniboss") and _run.offers_bargain("elite"),
		"§1a: on Ruin the mini-boss reads arms %s / offers %s and the elite offers %s — want true / false / true" % [
			_run.arms_fixed_modifier("miniboss"), _run.offers_bargain("miniboss"), _run.offers_bargain("elite")])
	_run.difficulty = "warden"
	ok(_run.offers_bargain("miniboss") and not _run.arms_fixed_modifier("miniboss"),
		"§1a: on Warden the mini-boss reads offers %s / arms %s — want true / false" % [
			_run.offers_bargain("miniboss"), _run.arms_fixed_modifier("miniboss")])
	print("    %s" % ", ".join(read))
	# THE SAME QUESTION AT EVERY DOOR THAT ASKS IT: the map's press, the sim's walk, the resume, the map's hover.
	ok(_body("scripts/map_screen.gd", "_on_node_pressed").contains("if Run.offers_bargain(ty):"),
		"§1a: the map's press does not ask `Run.offers_bargain` before the offer screen")
	ok(_src("scripts/run_sim.gd").contains("if run.offers_bargain(ty):\n\t\t\t_take_offer(run)"),
		"§1a: the sim takes its bargain without asking `offers_bargain`")
	ok(_body("scripts/run_state.gd", "resume_scene").contains("if offers_bargain(String(encounter.get(\"type\", \"\")))"),
		"§1a: `resume_scene` sends an encounter to the offer screen without asking `offers_bargain`")
	ok(_body("scripts/map_screen.gd", "_node_tooltip").contains("Run.offers_bargain(ty)"),
		"§1a: the map's hover says a bargain comes before the mini-boss without asking whether one does")
	# DRIVEN, THROUGH THE REAL MAP: Ruin's mini-boss, Warden's mini-boss, Ruin's elite.
	var pool: Array = _run._fixed_modifier_pool() if _run.has_method("_fixed_modifier_pool") else []
	for arm in [["ruin", "miniboss", false], ["warden", "miniboss", true], ["ruin", "elite", true]]:
		_new_run(String(arm[0]))
		var j: int = await _stand_before(String(arm[1]))
		ok(j >= 0, "§1a %s %s: no %s on the board to stand before" % [arm[0], arm[1], arm[1]])
		if j < 0:
			continue
		var opened := _open_nodes(current_scene)
		ok(opened.has(j), "§1a %s %s: the map drew no button for it (open: %s)" % [arm[0], arm[1], str(opened)])
		ok(_press_node(current_scene, j), "§1a %s %s: the node's button could not be pressed" % [arm[0], arm[1]])
		await Gate.frames(self, 8)
		var where := _scene_base()
		var want_offer: bool = arm[2]
		ok(where == ("offer" if want_offer else "bat" + "tle"),
			"§1a %s %s: the press opened '%s', not %s" % [arm[0], arm[1], where, "the offer screen" if want_offer else "its fight"])
		if not want_offer:
			var armed := String(_run.pending_modifier)
			ok(pool.has(armed), "§1a ruin miniboss: it fights under '%s', not one of the fixed band %s" % [armed, str(pool)])
			ok(not _run.encounter.has("offer") and not _run.encounter.has("bargain") and (_run.pending_reward as Dictionary).is_empty(),
				"§1a ruin miniboss: an offer, a bargain or a reward rides the fight: %s / %s" % [str(_run.encounter.keys()), str(_run.pending_reward)])
			var s: Node = current_scene
			var active := String(s.call("_active_modifier")) if s != null and s.has_method("_active_modifier") else ""
			ok(active == armed and armed != "", "§1a ruin miniboss: the fight reads its modifier as '%s', the run armed '%s'" % [active, armed])
			var hist := String(s.get("history").get_parsed_text()) if s != null and s.get("history") != null else ""
			var shown := String((_run.MODIFIERS.get(armed, {}) as Dictionary).get("name", "")).to_upper()
			ok(shown != "" and hist.contains(shown), "§1a ruin miniboss: the fight's log never names the modifier '%s'" % shown)
			# A RESUME PUTS THE PARTY BACK IN THE FIGHT, NOT IN FRONT OF AN OFFER.
			ok(String(_run.resume_scene()).ends_with("bat" + "tle.tscn"),
				"§1a ruin miniboss: a resume of the step in flight opens %s" % _run.resume_scene())
			print("    Ruin's mini-boss: no offer, it fights under %s (%s)" % [armed, shown])
		else:
			print("    %s's %s: the offer screen" % [arm[0], arm[1]])
		change_scene_to_file("res://scenes/main_menu.tscn")
		await Gate.frames(self, 4)
	# THE HOVER, BOTH WAYS.
	_new_run("ruin")
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 5)
	var tip_ruin := String(current_scene.call("_node_tooltip", {"type": "miniboss", "visited": false}, 7, true))
	_run.difficulty = "warden"
	var tip_warden := String(current_scene.call("_node_tooltip", {"type": "miniboss", "visited": false}, 7, true))
	ok(not tip_ruin.contains("A bargain is offered before it") and tip_ruin.contains("no bargain is offered"),
		"§1a: Ruin's mini-boss hover reads '%s'" % _words(tip_ruin))
	ok(tip_warden.contains("A bargain is offered before it"), "§1a: Warden's mini-boss hover reads '%s'" % _words(tip_warden))
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 4)
	# THE FRAMING CARD SAYS IT TOO, AND ITS BUTTON IS ON THE SCREEN: a fresh profile's first map.
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	_new_run("warden")
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 8)
	var card: Control = null
	for c in current_scene.get_children():
		if c is PanelContainer and (c as Control).z_index == 91:
			card = c
	var said := Gate.has_text(card, "every mini-boss but Ruin's") if card != null else false
	var bottom := card.get_global_rect().end.y if card != null else 9999.0
	ok(card != null and said, "§1a: the first map's framing card does not say Ruin's mini-boss offers no bargain")
	ok(bottom <= 720.0, "§1a: the framing card runs to y=%d on a 720-px screen — its one button is off it" % int(bottom))
	print("    the framing card: Ruin's mini-boss named, its foot at y=%d" % int(bottom))
	Profile.set_flag("run_framing_seen")
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 4)
	_run.active = false
	_run.encounter = {}
	_run.pending_modifier = ""


# ── §1b — A CARD WHOSE WORDS SAY HERO OFFERS ONLY THE HEROES ────────────────

func _s1b_hero_picks() -> void:
	print("\n§1b — a card whose words say hero offers only the heroes")
	# THE TABLE IS THE POPULATION: every ally-target card the game holds is a row, and no row names a card it does not.
	var corpus := {}
	for ab in Classes.ability_corpus():
		if ab.target == Ability.Target.ALLY:
			corpus[String(ab.display_name)] = ab
	var unsorted := corpus.keys().filter(func(n): return not ALLY_CARDS.has(n))
	var gone := ALLY_CARDS.keys().filter(func(n): return not corpus.has(n))
	ok(unsorted.is_empty(), "§1b: an ally-target card no row sorts — sort it by the words that name its pick: %s" % str(unsorted))
	ok(gone.is_empty(), "§1b: a row names a card the game does not hold as ally-target: %s" % str(gone))
	var hero_specials := []
	for n in ALLY_CARDS:
		if not corpus.has(n):
			continue
		var ab: Ability = corpus[n]
		var row: Array = ALLY_CARDS[n]
		var words := _words(String(ab.description))
		ok(String(row[1]) == "" or words.contains(String(row[1])),
			"§1b: %s's words no longer read '%s' — '%s'" % [n, row[1], words])
		if String(row[0]) == "HERO":
			hero_specials.append(String(ab.special))
			ok(not words.contains(" ally") and not words.contains("Ally"),
				"§1b: %s is sorted HERO and its words say ally — '%s'" % [n, words])
	var picks: Array = []
	var s0: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	if s0.has_method("_ally_pick_pool"):
		picks = load("res://scripts/battle.gd").get_script_constant_map().get("HERO_PICKS", [])
	var extra := picks.filter(func(sp): return not hero_specials.has(sp))
	var missing := hero_specials.filter(func(sp): return not picks.has(sp))
	ok(s0.has_method("_ally_pick_pool"), "§1b: `_ally_pick_pool`, the one answer to who an ally card's pick offers, is not in the game")
	ok(missing.is_empty() and extra.is_empty(),
		"§1b: `HERO_PICKS` is not the HERO rows' specials — missing %s, extra %s" % [str(missing), str(extra)])
	# WITH A COMPANION STANDING: every HERO card's pool leaves it out, every ALLY card's pool holds it.
	var h: BattleUnit = _hero(s0, "hunter")
	var cl: BattleUnit = _hero(s0, "cleric")
	var call: Ability = s0._summon_choice(h, "canis")
	if call != null:
		await s0._resolve(h, call, h, "good")
	var beasts: Array = s0._beasts(h)
	ok(beasts.size() == 1, "§1b: the Hunter's call fielded %d companions — one wanted" % beasts.size())
	var wrong := []
	var counted := 0
	if beasts.size() == 1 and s0.has_method("_ally_pick_pool"):
		var pet: BattleUnit = beasts[0]
		for n in ALLY_CARDS:
			if not corpus.has(n) or String(ALLY_CARDS[n][0]) == "OWN":
				continue
			var pool: Array = s0._ally_pick_pool(cl, corpus[n])
			counted += 1
			var has_pet := pool.has(pet)
			var heroes_in := pool.filter(func(u): return not u.is_companion).size()
			if String(ALLY_CARDS[n][0]) == "HERO" and has_pet:
				wrong.append("%s offers the companion" % n)
			if String(ALLY_CARDS[n][0]) == "ALLY" and not has_pet:
				wrong.append("%s does not offer the companion" % n)
			if heroes_in < 3:
				wrong.append("%s offers %d heroes" % [n, heroes_in])
	ok(wrong.is_empty() and counted == ALLY_CARDS.size() - 1,
		"§1b: read %d of %d cards' pools with a companion standing — %s" % [counted, ALLY_CARDS.size() - 1, str(wrong)])
	# AND EVERY DOOR THAT ASKS IT: the picker, the recast refusal and the two buttons.
	var pt := _body("scripts/battle.gd", "_player_turn")
	ok(pt.contains("pool = _ally_pick_pool(u, ab)"), "§1b: the player's picker does not ask `_ally_pick_pool`")
	ok(_body("scripts/battle.gd", "_recast_targets").contains("return _ally_pick_pool(u, ab)"),
		"§1b: the recast refusal weighs a pool the picker does not offer")
	var au := _body("scripts/battle.gd", "_ability_usable")
	ok(au.contains("for ar_h in _ally_pick_pool(u, ab):") and au.contains("if _ally_pick_pool(u, ab).is_empty():"),
		"§1b: Aegis Reversal's or Covering Guard's button lights for a body the picker does not offer")
	await _clear(s0)
	# DRIVEN: UNDYING VIGIL ON THE CLERIC's OWN TURN, THROUGH THE REAL PICKER, A COMPANION STANDING.
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true,
		"party": {2: {"bm_abilities": ["Undying Vigil"], "bm_equipped": ["Undying Vigil"]}}})
	var hh: BattleUnit = _hero(s, "hunter")
	var cc: BattleUnit = _hero(s, "cleric")
	var c2: Ability = s._summon_choice(hh, "canis")
	if c2 != null:
		await s._resolve(hh, c2, hh, "good")
	var vigil: Ability = s._find_ability(cc, "Undying Vigil")
	ok(vigil != null, "§1b: the Cleric carries no Undying Vigil — it was seated as a drafted card")
	var offered: Array = []
	if vigil != null:
		offered = await _picker_pool(s, cc, vigil)
	var pets := offered.filter(func(u): return u.is_companion)
	ok(offered.size() >= 3 and pets.is_empty(),
		"§1b: Undying Vigil's picker offered %s — %d companion(s)" % [str(offered.map(func(u): return u.unit_name)), pets.size()])
	print("    the census's %d ally-target cards: %d HERO, %d ALLY, 1 OWN; Vigil's picker offered %s" % [
		ALLY_CARDS.size(), hero_specials.size(), ALLY_CARDS.size() - hero_specials.size() - 1,
		str(offered.map(func(u): return u.unit_name))])
	await _clear(s)


# The player's own turn, driven until `u` presses `ab`, and the pool the picker opens on — then the first body picked.
func _picker_pool(s: Node, u: BattleUnit, ab: Ability) -> Array:
	var got: Array = []
	var pressed := false
	var n := 0
	while n < 6000:
		n += 1
		Engine.time_scale = 100.0
		await process_frame
		if not is_instance_valid(s):
			break
		if bool(s.get("sc_active")):
			s.call("_grade_skill_check")
			continue
		var kb: Array = s.get("_kb_pool")
		if not kb.is_empty():
			if pressed and got.is_empty():
				got = kb.duplicate()
			s.emit_signal("_target_picked", kb[0])
			if pressed:
				break
			continue
		var p: BattleUnit = s.get("current_hero")
		var panel: Control = s.get("action_panel")
		if p == null or panel == null or not panel.visible:
			continue
		if p != u:
			s.emit_signal("_ability_picked", p.abilities[0])
			continue
		u.cooldowns.clear()
		pressed = true
		s.emit_signal("_ability_picked", ab)
	Engine.time_scale = 1.0
	return got


# ── §1c — NO CARD SAYS EVERYONE ─────────────────────────────────────────────

func _s1c_no_everyone() -> void:
	print("\n§1c — no card and no chip says everyone")
	var said := []
	var n := 0
	for ab in Classes.ability_corpus():
		n += 1
		for t in [String(ab.description), String(ab.perfect_text)]:
			if t.to_lower().contains("everyone"):
				said.append(String(ab.display_name))
	var info: Dictionary = load("res://scripts/battle.gd").get_script_constant_map()["STATUS_INFO"]
	for id in info:
		var row: Array = info[id]
		if row.size() > 3 and String(row[3]).to_lower().contains("everyone"):
			said.append("chip " + String(id))
	ok(n > 200 and info.size() > 100, "§1c: swept %d cards and %d chips — the population is not the game's" % [n, info.size()])
	ok(said.is_empty(), "§1c: a card or chip says everyone, where the words are hero or ally: %s" % str(said))
	# EACH TO THE WORD ITS CODE REACHES: Aegis Wall heals the heroes, Hunter's Mark reaches a companion's blow.
	var aw: Ability = Classes.pool_ability("Aegis Wall")
	var hm: Ability = Classes.pool_ability("Hunter's Mark")
	ok(aw != null and _words(aw.description).contains("The wall answers for the heroes")
			and _words(aw.description).contains("every hero"),
		"§1c: Aegis Wall's words — '%s'" % (_words(aw.description) if aw != null else "no card"))
	ok(_src("scripts/battle.gd").contains("for aw_h in heroes:") and not _src("scripts/battle.gd").contains("for aw_h in _hero_side()"),
		"§1c: Aegis Wall's heal no longer walks the heroes alone — its words say hero")
	ok(hm != null and _words(hm.description).contains("every ally strikes the same thing") and _words(hm.description).contains("EVERY ALLY"),
		"§1c: Hunter's Mark's words — '%s'" % (_words(hm.description) if hm != null else "no card"))
	ok(_body("scripts/battle.gd", "_companion_hit").contains("raw *= _party_mark_mult(victim)"),
		"§1c: a companion's blow no longer reads Hunter's Mark — its words say ally")
	ok(_src("scripts/battle.gd").contains("_message(\"%s raises the wall for the heroes\" % attacker.unit_name)"),
		"§1c: Aegis Wall's battle message no longer says the heroes")
	print("    swept %d cards and %d chips; Aegis Wall says hero, Hunter's Mark says ally" % [n, info.size()])


# ── §1d — A FLOOR PAYS ONLY WHEN WHAT IT IS A SHARE OF IS THERE ─────────────

# One blow by the Warrior into `e`, Tithe worn in the crest; returns what the lowest hero was healed.
func _tithe_blow(s: Node, e: BattleUnit) -> int:
	var w: BattleUnit = _hero(s, "warrior")
	var low: BattleUnit = _hero(s, "mage")
	for hh in s.get("heroes"):
		if not hh.is_companion and hh != low:
			hh.hp = hh.max_hp
	low.hp = maxi(int(low.max_hp * 0.3), 1)
	var before: int = low.hp
	await s._resolve(w, w.abilities[0], e, "good")
	return low.hp - before


func _s1d_floors() -> void:
	print("\n§1d — Tithe pays only for Break that landed; a split of nothing bills nobody")
	var crest: Array = [Runes.build("tithe")]
	crest[0]["equipped"] = true
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true, "party_runes": crest})
	_sturdy(s)
	var w: BattleUnit = _hero(s, "warrior")
	ok(w != null and w.rune_blood_communion > 0, "§1d: the Warrior wears no Tithe share (%s)" % (str(w.rune_blood_communion) if w != null else "none"))
	var arms := {}
	var foes := _foes(s)
	# Break lands: the positive arm.
	foes[0].pressure = 0
	foes[0].broken = false
	arms["lands"] = await _tithe_blow(s, foes[0])
	# A Broken body.
	foes[1].broken = true
	foes[1].pressure = foes[1].stability
	arms["broken"] = await _tithe_blow(s, foes[1])
	# Deadened, stamped through the battle's own modifier door.
	foes[2].broken = false
	foes[2].pressure = 0
	s._stamp_modifier(foes[2], "deadened")
	arms["deadened"] = await _tithe_blow(s, foes[2])
	foes[2].mod_no_break = false
	# A blow its Constitution rounds to nothing.
	foes[0].pressure = 0
	foes[0].constitution = 100000
	arms["rounded"] = await _tithe_blow(s, foes[0])
	ok(int(arms["lands"]) > 0, "§1d: a blow that landed Break healed %d — Tithe pays nothing at all" % int(arms["lands"]))
	for k in ["broken", "deadened", "rounded"]:
		ok(int(arms[k]) == 0, "§1d: a blow that landed no Break (%s) healed %d" % [k, int(arms[k])])
	print("    Tithe healed: lands %d, broken %d, deadened %d, rounded %d" % [arms["lands"], arms["broken"], arms["deadened"], arms["rounded"]])
	await _clear(s)
	# SACRED RESOLVE's SPLIT: a raider's blow parried outright by a Defensive, Untouchable hero bound by Unity.
	var su: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	var tank: BattleUnit = _hero(su, "warrior")
	var raider: BattleUnit = _foes(su)[0]
	for hh in su.get("heroes"):
		hh.hp = hh.max_hp
	tank.untouchable = 1
	tank.stance = "defensive"
	tank.parry_chance = 10.0
	su._apply_status(tank, "unity", 3)
	var hp0 := {}
	for hh in su.get("heroes"):
		hp0[hh] = hh.hp
	await su._resolve(raider, raider.abilities[0], tank, "good")
	var billed := []
	for hh in su.get("heroes"):
		if not hh.is_companion and hh.hp != int(hp0[hh]):
			billed.append("%s %d" % [hh.unit_name, hh.hp - int(hp0[hh])])
	var hist := String(su.get("history").get_parsed_text())
	ok(hist.contains("UNTOUCHABLE") or hist.to_lower().contains("parr"), "§1d: the raider's blow was not parried outright — the arm drove nothing")
	ok(billed.is_empty(), "§1d: a blow parried outright billed the bound heroes: %s" % str(billed))
	print("    Unity on a parried blow billed %s" % (str(billed) if not billed.is_empty() else "nobody"))
	await _clear(su)


# ── §1e — EVERY AFFLICTION HAS ITS GLOSSARY ENTRY AT THE CHIP's DOOR ────────

func _s1e_glossary() -> void:
	print("\n§1e — every affliction the game lists has a glossary entry at the chip's door")
	var info: Dictionary = load("res://scripts/battle.gd").get_script_constant_map()["STATUS_INFO"]
	var missing := []
	var unnamed := []
	var raw := []
	for id in BattleUnit.DEBUFF_IDS:
		var sid := String(id)
		if Glossary.status_short(sid) == "":
			missing.append(sid)
			continue
		var e: Dictionary = Glossary.entry("status_" + sid)
		var label := String((info[sid] as Array)[0]) if info.has(sid) else ""
		if sid != "broken" and label != "" and not String(e.get("term", "")).contains(label):
			unnamed.append("%s: '%s' / '%s'" % [sid, label, e.get("term", "")])
		for f in ["short", "long"]:
			if String(e.get(f, "")).contains("{=") or String(e.get(f, "")).contains("@@"):
				raw.append("%s.%s" % [sid, f])
	ok(BattleUnit.DEBUFF_IDS.size() >= 35, "§1e: `DEBUFF_IDS` reads %d — the population is not the game's" % BattleUnit.DEBUFF_IDS.size())
	ok(missing.is_empty(), "§1e: an affliction the game lists has no glossary line at the chip's door: %s" % str(missing))
	ok(unnamed.is_empty(), "§1e: an entry is not named for the chip it explains: %s" % str(unnamed))
	ok(raw.is_empty(), "§1e: an entry prints a token raw: %s" % str(raw))
	# THE SEVEN, READ AGAINST THE VOCABULARY AND THEIR FIGURES' DOORS.
	var seven := ["slow_burn", "heads_down", "unmade", "breaking_darkness", "penance", "suffering", "blight"]
	var bad := []
	for id in seven:
		var e: Dictionary = Glossary.entry("status_" + id)
		var t := (String(e.get("short", "")) + " " + String(e.get("long", ""))).to_lower()
		for w in ["everyone", "party", "beast", " you ", "your "]:
			if t.contains(w):
				bad.append("%s says '%s'" % [id, w.strip_edges()])
		if String(e.get("category", "")) != "statuses" or Glossary.is_retired("status_" + id):
			bad.append("%s is not a live status entry" % id)
	var src := FileAccess.get_file_as_string("res://data/glossary.json")
	for tok in ["{=Battle.BREAKING_DARKNESS_BD_PCT}", "{=Battle.PENANCE_MIRROR*100}", "{=Battle.UNMAKING_LOCK_TURNS}"]:
		if not src.contains(tok):
			bad.append("no %s" % tok)
	var bd := String(Glossary.entry("status_breaking_darkness").get("short", ""))
	if not bd.contains("%d%%" % int(load("res://scripts/battle.gd").get_script_constant_map()["BREAKING_DARKNESS_BD_PCT"])):
		bad.append("Breaking Darkness's short reads '%s'" % bd)
	ok(bad.is_empty(), "§1e: the seven entries — %s" % str(bad))
	ok(Glossary.entry("status_bound").is_empty() and not Glossary.entry("status_frostbind").is_empty(),
		"§1e: Frostbind's entry is not at the id its chip reads (`status_frostbind`)")
	print("    %d afflictions, every one with its line at the chip's door; the seven read clean" % BattleUnit.DEBUFF_IDS.size())


# ── §1f — A BOW USER's BLOCKED SHOT ─────────────────────────────────────────

func _played(s: Node, sound: String) -> bool:
	var want: AudioStream = (s.get("SFX") as Dictionary)[sound]
	for p in s.get("_sfx_players"):
		if (p as AudioStreamPlayer).stream == want:
			return true
	return false


func _quiet(s: Node) -> void:
	for p in s.get("_sfx_players"):
		(p as AudioStreamPlayer).stream = null


func _s1f_bow_blocked() -> void:
	print("\n§1f — a bow user's blocked shot plays the bow's own sound")
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	_sturdy(s)
	var arms := []
	var hunter: BattleUnit = _hero(s, "hunter")
	var warrior: BattleUnit = _hero(s, "warrior")
	var archer: BattleUnit = null
	var raider: BattleUnit = null
	for e in _foes(s):
		if String(e.unit_name).begins_with("Orc Archer") and archer == null:
			archer = e
		elif raider == null and not String(e.unit_name).begins_with("Orc Archer"):
			raider = e
	ok(archer != null and raider != null, "§1f: the fixture's warband has no Orc Archer or no raider")
	if archer == null or raider == null:
		await _clear(s)
		return
	# [attacker, target, the bow's sound wanted]
	for arm in [[archer, warrior, true], [hunter, raider, true], [raider, warrior, false]]:
		var att: BattleUnit = arm[0]
		var tgt: BattleUnit = arm[1]
		tgt.add_status("shield_charges", "Interpose", "IP1", Color(0.7, 0.8, 0.95), -1, "")
		tgt.update_status("shield_charges", "IP1", "", 1)
		_quiet(s)
		await s._resolve(att, att.abilities[0], tgt, "good")
		var bow := _played(s, "bow_blocked")
		var parry := _played(s, "parry")
		arms.append("%s->%s bow %s parry %s" % [att.unit_name, tgt.unit_name, bow, parry])
		var want_bow: bool = arm[2]
		ok(bow == want_bow and (want_bow or parry),
			"§1f: %s's blocked blow played bow_blocked %s and parry %s — want the %s" % [att.unit_name, bow, parry, "bow's" if want_bow else "parry's"])
	print("    %s" % "; ".join(arms))
	await _clear(s)


# ── §1g — EVERY TARGETING KIND THAT ROLLS PER STRIKE, NAMED IN THE SINGLE-TARGET GUARD ──

func _s1g_choose_three() -> void:
	print("\n§1g — a choose-three cast rolls its miss per strike, once")
	# THE POPULATION: `Ability`'s own targeting fields — `aoe`, the two hit counts and every `choose_*`.
	var kinds := ["aoe", "multi_hits", "random_hits"]
	var rx := RegEx.new()
	rx.compile("(?m)^var (choose_[a-z_]+)")
	for m in rx.search_all(FileAccess.get_file_as_string("res://scripts/ability.gd")):
		kinds.append(m.get_string(1))
	var res := _body("scripts/battle.gd", "_resolve")
	var at := res.find("elif not is_counter and not ab.aoe")
	var guard := res.substr(at, res.find("_miss_chance(attacker, target)", at) - at) if at >= 0 else ""
	var unnamed := kinds.filter(func(k): return not guard.contains("ab." + String(k)))
	ok(kinds.size() >= 5 and at >= 0, "§1g: read %d targeting kinds and %s the single-target guard" % [kinds.size(), "found" if at >= 0 else "did NOT find"])
	ok(unnamed.is_empty(), "§1g: a targeting kind the single-target miss guard does not name, so it rolls a whole-cast miss first: %s" % str(unnamed))
	print("    the kinds: %s — every one named in the guard" % str(kinds))
	# DRIVEN: Cleave on three chosen raiders, its first target one it cannot fail to miss.
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true,
		"party": {0: {"bm_abilities": ["Cleave"], "bm_equipped": ["Cleave"]}}})
	_sturdy(s)
	var w: BattleUnit = _hero(s, "warrior")
	var cleave: Ability = s._find_ability(w, "Cleave")
	ok(cleave != null and cleave.choose_three, "§1g: the Warrior holds no Cleave, or it is no choose-three card")
	var foes := _foes(s)
	if cleave == null or foes.size() < 3:
		await _clear(s)
		return
	w.no_cover = 0
	# Each target named for itself: the warband holds two Orc Raiders, and a miss line names its body by `unit_name`.
	for i in 3:
		foes[i].unit_name = "IR Mark %d" % i
	s._apply_status(w, "burn", 3, 1, 1, foes[0])
	foes[0].heat_haze = 1000
	s.set("second_target", foes[1])
	s.set("third_target", foes[2])
	var hp0 := [foes[0].hp, foes[1].hp, foes[2].hp]
	s.get("history").clear()
	await s._resolve(w, cleave, foes[0], "good")
	var hist := String(s.get("history").get_parsed_text())
	var misses := []
	var reached := []
	for i in 3:
		var miss_n := hist.count("on %s — MISS" % foes[i].unit_name)
		misses.append(miss_n)
		reached.append(foes[i].hp < int(hp0[i]) or miss_n > 0)
	ok(int(misses[0]) == 1, "§1g: the first target, which cannot be hit, logged %d misses — one roll wanted" % int(misses[0]))
	ok(bool(reached[1]) and bool(reached[2]),
		"§1g: a whole-cast miss on the first target stopped the cast — the other two were struck or rolled: %s" % str(reached))
	print("    Cleave, first target unhittable: misses %s, each of the other two struck or rolled its own" % str(misses))
	await _clear(s)


# ── §2 — THE RENAME MAP, AT THE LOAD DOOR ───────────────────────────────────

func _roundtrip() -> bool:
	_run.save_run()
	return _run.load_run()


func _s2_rename_map() -> void:
	print("\n§2 — the rename map: a card a save names by its old name is read by today's")
	var rows: Dictionary = (_run.get_script() as Script).get_script_constant_map().get("RENAMED_CARDS", {})
	ok(rows == RENAMES, "§2: the load door's rename map is %s, not the five renames since the floor %s" % [str(rows), str(RENAMES)])
	var corpus := {}
	for ab in Classes.ability_corpus():
		corpus[String(ab.display_name)] = true
	for old in RENAMES:
		ok(not corpus.has(old) and corpus.has(String(RENAMES[old])),
			"§2: '%s' -> '%s': the old name is a card %s, the new one is a card %s" % [old, RENAMES[old], corpus.has(old), corpus.has(String(RENAMES[old]))])
	ok(_body("scripts/run_state.gd", "load_run").contains("_rename_saved_cards()"),
		"§2: the rename map is not read at the load door")
	# EVERY PLACE A SAVE CARRIES A CARD's NAME, EACH AN OLD ONE.
	_new_run("warden")
	var m: Dictionary = _run.party[0]
	m["bm_abilities"] = ["Iron Will", "Matins", "Ironclad"]
	m["bm_equipped"] = ["Iron Will"]
	m["draft_candidates"] = [["Anathema", "Heal", "Jubilee"]]
	m["bm_candidates"] = [["Magic Barrier", "Matins", "Renewal"]]
	m["up_candidates"] = [[{"id": "up_damage", "ability": "Iron Will"}]]
	m["upgrades"] = [{"id": "up_speed", "ability": "Matins"}, {"id": "up_speed", "ability": "Divine Presence"}]
	m["draft_refused"] = ["Jubilee"]
	# RE-POINTED AT IS §2b: a payload rides the save as built only where today's definition names every field it names, so
	# the fixture is two real runes as built with an old card name in a field their definitions carry — a hand-built payload
	# Tithe's definition does not describe is rebuilt from it now. No definition carries an `owns_ability` condition today,
	# so that branch has nothing a save can carry for it to translate.
	var rune: Dictionary = Runes.build("split_tongue")
	rune["payload"]["ability"] = "Iron Will"
	var grant: Dictionary = Runes.build("binding_souls")
	grant["payload"]["grant_ability"] = "Anathema"
	m["runes"] = [rune, grant]
	seed(2026102201)
	var before := randi()
	seed(2026102201)
	ok(_roundtrip(), "§2: the save did not load")
	var after := randi()
	ok(before == after, "§2: loading the save spent a die")
	var p: Dictionary = _run.party[0]
	var want := {
		"bm_abilities": ["Ironclad", "Divine Presence"],
		"bm_equipped": ["Ironclad"],
		"draft_candidates": [["Breaking Darkness", "Heal", "Blessing of the Faithful"]],
		"bm_candidates": [["Nexus Ward", "Divine Presence", "Renewal"]],
		"draft_refused": ["Blessing of the Faithful"],
	}
	for k in want:
		ok(p.get(k) == want[k], "§2: %s loaded as %s, not %s" % [k, str(p.get(k)), str(want[k])])
	var up: Array = p.get("up_candidates", [])
	ok(up.size() == 1 and String(((up[0] as Array)[0] as Dictionary).get("ability", "")) == "Ironclad",
		"§2: a queued upgrade loaded on %s, not Ironclad" % str(up))
	var ups: Array = p.get("upgrades", [])
	ok(ups.size() == 1 and String((ups[0] as Dictionary).get("ability", "")) == "Divine Presence",
		"§2: the held upgrades loaded as %s — one Swift on Divine Presence wanted (the old name's copy read into the new one's)" % str(ups))
	var pay: Dictionary = (p.get("runes", [{}, {}]) as Array)[0].get("payload", {})
	var pay2: Dictionary = (p.get("runes", [{}, {}]) as Array)[1].get("payload", {})
	ok(String(pay.get("ability", "")) == "Ironclad" and String(pay2.get("grant_ability", "")) == "Breaking Darkness",
		"§2: a saved rune's payload names %s / %s" % [str(pay), str(pay2)])
	var unknown: Array = _run.get("load_unknown_cards") if _run.get("load_unknown_cards") is Array else ["<no ledger>"]
	ok(unknown.is_empty(), "§2: a renamed save reported unknown cards %s" % str(unknown))
	# THE FOUR READS THAT TOOK AN OLD NAME STRAIGHT: each resolves today's card.
	var unresolved := []
	for n in (p.get("bm_abilities", []) as Array) + ((p.get("draft_candidates", [[]]) as Array)[0] as Array):
		if Classes.pool_ability(String(n)) == null:
			unresolved.append(String(n))
	ok(unresolved.is_empty(), "§2: a saved card the offer's card and the spawn read resolves to nothing: %s" % str(unresolved))
	var built: Array = []
	for n in p.get("bm_abilities", []):
		var ab: Ability = Classes.pool_ability(String(n))
		if ab != null:
			built.append(ab)
	var landed: Dictionary = _run.apply_upgrades(p, built)
	ok(landed.has("Divine Presence"), "§2: the saved upgrade no longer lands — `apply_upgrades` landed %s" % str(landed))
	var choice: Array = _run.upgrade_choice(p)
	ok(choice.size() >= 1 and String((choice[0] as Dictionary).get("ability", "")) == "Ironclad",
		"§2: the queued upgrade's answer is %s" % str(choice))
	print("    every old name read by today's: %s" % str(p.get("bm_abilities")))
	# A NAME THAT WAS NEVER A CARD: kept as it is, said out loud — never guessed, never dropped.
	_new_run("warden")
	_run.party[1]["bm_abilities"] = [NEVER_A_CARD, "Heal"]
	_run.party[1]["bm_equipped"] = [NEVER_A_CARD]
	ok(_roundtrip(), "§2 never: the save did not load")
	var kept: Array = _run.party[1].get("bm_abilities", [])
	var loud: Array = _run.get("load_unknown_cards") if _run.get("load_unknown_cards") is Array else []
	ok(kept.has(NEVER_A_CARD) and (_run.party[1].get("bm_equipped", []) as Array).has(NEVER_A_CARD),
		"§2 never: a name that was never a card was dropped or rewritten — %s" % str(kept))
	ok(loud == [NEVER_A_CARD], "§2 never: the load did not say '%s' out loud — it reported %s" % [NEVER_A_CARD, str(loud)])
	# A CLEAN SAVE LOADS UNTOUCHED.
	_new_run("warden")
	_run.party[2]["bm_abilities"] = ["Heal", "Renewal"]
	_run.party[2]["draft_candidates"] = [["Divine Plea", "Dawnbreak", "Heal"]]
	var clean: Dictionary = (_run.party[2] as Dictionary).duplicate(true)
	ok(_roundtrip(), "§2 clean: the save did not load")
	var loud2: Array = _run.get("load_unknown_cards") if _run.get("load_unknown_cards") is Array else ["<no ledger>"]
	ok(_run.party[2] == clean and loud2.is_empty(), "§2 clean: a save naming today's cards loaded changed, or reported %s" % str(loud2))
	_run.active = false


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
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
