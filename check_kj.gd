# BATCH KJ — THE ENEMY REWORK: TIERS, KITS CUT TO THEIR TIER, NEW MOVES TO PLAY AROUND, AND A COMBO FOR EVERY RECIPE (the
# designer's ask in conversation, 27 November — *"i think all enemies should be categorized in tiers that determine their power
# and ability count"* … *"make sure the enemies within the packets share synergy across their abilities"* — the four shape
# answers, the 44 picks on the options page, and the seven figures after them; KJ's work folder, `RECORD_KJ.md`).
#
# What this gate asserts, section by section (`docs/reports/KJ.md` has the working):
#
#   §1  THE TIERS AND THE KITS, IN THE DATA: a kind's tier is its `power` (the builder's cost), 1 to 3 for every regular kind,
#       the Orc Totemist and the Rotfiend at 2; a tier-N kind carries N moves; a tier-1 kind carries no Malice spend, a tier-3
#       kind and an elite exactly one, Raise only on the Ritual Chanter and the Grave Totem beside the bosses' own; each
#       tier's health stands in its band; five tier-1 basics carry their signature effect at the ruled chance; every new move
#       carries the figures the designer ruled; the four elites carry one War Cry.
#   §2  THE MOVES, DRIVEN IN A FIGHT: a Flank move lands harder on a hero another body struck since that hero's last turn and
#       not otherwise, and a companion's span closes with its master's turn; a guard takes the first blow aimed at another body in a turn, and not the second, and a Break ends it
#       (a Broken body guards nothing); a hex move telegraphs Afflict; a Silenced hero may use
#       its basic attack and nothing else; a Branded hero pays health for an ability and none for its basic; a Doomed hero
#       takes more from the warband; a Singled Out hero draws every blow, below a taunt; a Hunkered body takes the ruled share
#       and strikes back at a melee hitter and not at a ranged one, nor at a spell, and at an area blow that strikes it beside
#       its target; Frost Fury fires once, under its share of health, and not again after its Fury is lifted; a single-target
#       wind-up lands on the hero it was raised at.
#   §3  THE TWELVE COMBOS: each recipe's fight carries its combo, and each combo's arm does what its words say (a Broken
#       tank guards no elite).
#   §4  THE RECORD: the master document names every tier's count, each new move and each combo; the state no longer marks
#       the enemy half RULED, NOT BUILT.
#   §5  `check_ht`'s FUNCTION WINDOW, REPAIRED AT KJ §1 (IT's census row on `check_ht` §2's `_bodies`, owed by the batch that
#       touched the gate): a function's window ends at its last indented line, so a top-level declaration below it is no
#       function's text, and a function whose head wraps keeps its body.
#   §6  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the warband plays as the designer wants — every figure
# is the designer's and the sim tests the code; and whether a player reads the combo's row and plays around it.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
const HT = preload("res://check_ht.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const SCRATCH_PROFILE := "user://kj_profile.json"
const SCRATCH_RELICS := "user://kj_relics.json"
const ENEMIES_JSON := "res://data/enemies.json"
const SPENDS := ["malice_rally", "malice_entrench", "malice_raise"]
# A2, the designer's: each tier's health band.
const BANDS := {1: [85, 110], 2: [110, 160], 3: [250, 300]}
# C1 and answer 7, the designer's: the five basics that bite, the status and its turns as the move it came from carried.
const BITE_CHANCE := 0.3
const BITES := {"raider": ["sunder", 2], "archer": ["poison", 3], "spore_lobber": ["poison", 3],
	"frostbitten_thrall": ["slow", 2], "hailcaster": ["dazed", 2]}
# The seven answers and the page's picks, the designer's: each new move's figures (a kind's basic named where it decides one).
const NEW_MOVES := {
	"wolfrider": {"Harrying Bite": {"basic": "Lunging Bite", "cooldown": 2}},
	"ashblade": {"Cinder Flank": {"basic": "Cinder Slash", "cooldown": 2}},
	"bristleback": {"Gang Gore": {"basic": "Tusk Gore", "cooldown": 2}},
	"carrion_pack": {"Pack Rend": {"basic": "Snapping Jaws", "cooldown": 2}},
	"hexer": {"Choking Hex": {"basic": "Hex Bolt", "cooldown": 3, "status": "silenced"}},
	"stillwrought": {"Stillness": {"basic": "Stillbolt", "cooldown": 3, "status": "silenced"}},
	"blightcap": {"Rot Brand": {"basic": "Rot Bolt", "cooldown": 3, "status": "branded"}},
	"blight_speaker": {"Carrion Mark": {"basic": "Sour Whisper", "cooldown": 3, "status": "doomed"}},
	"shieldmaster": {"Shield Guard": {"cooldown": 4, "special": "bodyguard"}},
	"heartwood_sentinel": {"Rootguard": {"cooldown": 4, "special": "bodyguard"}},
	"bog_troll": {"Bog Guard": {"cooldown": 4, "special": "bodyguard"}},
	"icebound_bulwark": {"Frozen Stance": {"cooldown": 3, "special": "brace"}},
	"mossback": {"Moss Shell": {"cooldown": 3, "special": "brace"}},
	"rimehorn": {"Frost Fury": {"cooldown": 0, "special": "enrage"}},
	"brute": {"Skullsplitter": {"cooldown": 3, "special": "windup", "damage": 84, "pressure": 50}},
}
const ELITES := ["chief", "antlered_huntmaster", "rimeclad_warlord", "drowned_thane"]
const WAR_CRY := {"damage": 34, "pressure": 56, "cooldown": 3, "status": "singled_out", "turns": 2}

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _data := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KJ — THE ENEMY REWORK: TIERS, KITS, MOVES TO PLAY AROUND, AND A COMBO FOR EVERY RECIPE")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before anything is written")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_data = JSON.parse_string(FileAccess.get_file_as_string(ENEMIES_JSON))
	_fresh_meta()
	_s1_data()
	await _s2_moves()
	await _s3_combos()
	_s4_record()
	Engine.time_scale = 1.0
	_s5_the_function_window()
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


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


func _move(kind: String, name: String) -> Dictionary:
	for a in (_data[kind] as Dictionary)["abilities"]:
		if String(a["display_name"]) == name:
			return a
	return {}


# ── §1 — THE TIERS AND THE KITS ──────────────────────────────────────────────────────────────────────────────────────────

func _s1_data() -> void:
	print("\n§1 — the tiers, the kits, the bands, the bites and the new moves, as the data holds them")
	var per_tier := {1: 0, 2: 0, 3: 0}
	var bad_count: Array = []
	var bad_spend: Array = []
	var bad_band: Array = []
	for kind in _data:
		var v: Dictionary = _data[kind]
		var p := int(v["power"])
		var kit: Array = v["abilities"]
		var spends: Array = kit.filter(func(a): return SPENDS.has(String(a.get("special", ""))))
		if p <= 3:
			per_tier[p] = int(per_tier[p]) + 1
			if kit.size() != p:
				bad_count.append("%s: tier %d carries %d" % [kind, p, kit.size()])
			if p == 1 and not spends.is_empty():
				bad_spend.append("%s (tier 1) spends" % kind)
			if p == 3 and spends.size() != 1:
				bad_spend.append("%s (tier 3) carries %d spends" % [kind, spends.size()])
			if p == 2 and spends.any(func(a): return String(a["special"]) != "malice_raise"):
				bad_spend.append("%s (tier 2) carries a Rally or an Entrench" % kind)
			if p == 2 and spends.any(func(a): return String(a["special"]) == "malice_raise") and not ["chanter", "grave_totem"].has(kind):
				bad_spend.append("%s (tier 2) carries a Raise" % kind)
			var band: Array = BANDS[p]
			if int(v["max_hp"]) < int(band[0]) or int(v["max_hp"]) > int(band[1]):
				bad_band.append("%s %d outside %s" % [kind, int(v["max_hp"]), str(band)])
		elif String(v["roles"][0]) == "elite" and spends.size() != 1:
			bad_spend.append("%s (elite) carries %d spends" % [kind, spends.size()])
	print("    tier 1 %d, tier 2 %d, tier 3 %d" % [per_tier[1], per_tier[2], per_tier[3]])
	ok(int(per_tier[1]) > 0 and int(per_tier[2]) > 0 and int(per_tier[3]) > 0, "§1: a tier holds no kind: %s" % str(per_tier))
	ok(int((_data["totemist"] as Dictionary)["power"]) == 2 and int((_data["rotfiend"] as Dictionary)["power"]) == 2,
		"§1: the Orc Totemist or the Rotfiend is not at tier 2 (A1)")
	ok(bad_count.is_empty(), "§1: a kind's moves are not its tier's count: %s" % [bad_count])
	ok(bad_spend.is_empty(), "§1: a kind's spends are not its tier's (A3): %s" % [bad_spend])
	ok(bad_band.is_empty(), "§1: a kind's health is outside its tier's band (A2): %s" % [bad_band])
	var bad_bite: Array = []
	for kind in BITES:
		var b: Dictionary = (_data[kind] as Dictionary)["abilities"][0]
		var st: Dictionary = b.get("applies_status", {})
		if String(st.get("id", "")) != String(BITES[kind][0]) or int(st.get("turns", 0)) != int(BITES[kind][1]) \
				or absf(float(b.get("status_chance", 1.0)) - BITE_CHANCE) > 0.0001:
			bad_bite.append("%s: %s at %s" % [kind, str(st), str(b.get("status_chance", 1.0))])
	ok(bad_bite.is_empty(), "§1: a tier-1 basic does not bite as ruled (C1, answer 7): %s" % [bad_bite])
	var bad_move: Array = []
	for kind in NEW_MOVES:
		for mv in NEW_MOVES[kind]:
			var want: Dictionary = NEW_MOVES[kind][mv]
			var m := _move(kind, mv)
			if m.is_empty():
				bad_move.append("%s has no %s" % [kind, mv])
				continue
			if int(m.get("cooldown", 0)) != int(want["cooldown"]):
				bad_move.append("%s %s cools %d, ruled %d" % [kind, mv, int(m.get("cooldown", 0)), int(want["cooldown"])])
			if want.has("basic"):
				var bs := _move(kind, String(want["basic"]))
				if int(m.get("damage", -1)) != int(bs.get("damage", -2)) or int(m.get("pressure", -1)) != int(bs.get("pressure", -2)):
					bad_move.append("%s %s is not its basic's numbers" % [kind, mv])
			if want.has("damage") and (int(m.get("damage", 0)) != int(want["damage"]) or int(m.get("pressure", 0)) != int(want["pressure"])):
				bad_move.append("%s %s deals %s/%s, ruled %d/%d" % [kind, mv, str(m.get("damage")), str(m.get("pressure")),
					int(want["damage"]), int(want["pressure"])])
			if want.has("special") and String(m.get("special", "")) != String(want["special"]):
				bad_move.append("%s %s is not a %s" % [kind, mv, want["special"]])
			if want.has("status") and String((m.get("applies_status", {}) as Dictionary).get("id", "")) != String(want["status"]):
				bad_move.append("%s %s lays no %s" % [kind, mv, want["status"]])
	ok(bad_move.is_empty(), "§1: a new move is not as the designer ruled it: %s" % [bad_move])
	var bad_wc: Array = []
	for kind in ELITES:
		var wc := _move(kind, "War Cry")
		var st2: Dictionary = wc.get("applies_status", {})
		if wc.is_empty() or int(wc.get("damage", 0)) != int(WAR_CRY["damage"]) or int(wc.get("pressure", 0)) != int(WAR_CRY["pressure"]) \
				or int(wc.get("cooldown", 0)) != int(WAR_CRY["cooldown"]) or String(st2.get("id", "")) != String(WAR_CRY["status"]) \
				or int(st2.get("turns", 0)) != int(WAR_CRY["turns"]) or wc.has("dmg_type"):
			bad_wc.append(kind)
	ok(bad_wc.is_empty(), "§1: an elite's War Cry is not the one ruled (F1, answer 6): %s" % [bad_wc])
	# THE SELF-CAST's TAG: an enemy self-cast is tagged `"ally"`, its own side, and there is no `"self"` — `Enemies.config` maps
	# `"ally"` and nothing else, so any other value loads as an attack on a hero, silently. KJ wrote its guards, its braces and
	# Frost Fury as self-casts, so every move's target in the data is read here.
	var bad_target: Array = []
	for kind in _data:
		for mv in ((_data[kind] as Dictionary).get("abilities", []) as Array):
			var tg := String((mv as Dictionary).get("target", ""))
			if tg != "" and tg != "ally":
				bad_target.append("%s %s: %s" % [kind, String((mv as Dictionary).get("display_name", "?")), tg])
	ok(bad_target.is_empty(), "§1: an enemy move's target is neither absent nor ally, so it loads as an attack on a hero: %s" % [bad_target])


# ── the fight ────────────────────────────────────────────────────────────────────────────────────────────────────────────

func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(ENG4[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _battle(theme: String, kinds: Array) -> Node:
	_new_run()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, {"type": "fight", "theme": theme, "enemies": kinds.duplicate()})
	await Gate.frames(self, 8)
	Engine.time_scale = 1.0
	var s: Node = current_scene
	for u in s.get("heroes") + s.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = -10.0
		u.crit_bonus = -1.0
	return s


func _body(s: Node, kind: String, nth := 0) -> BattleUnit:
	var seen := 0
	for e in s.get("enemies"):
		if (e as BattleUnit).enemy_kind == kind:
			if seen == nth:
				return e
			seen += 1
	return null


func _fresh(u: BattleUnit) -> void:
	u.hp = u.max_hp
	u.dead = false
	u.pressure = 0
	u.broken = false
	u.broken_pending = false


# ── §2 — THE MOVES, DRIVEN ───────────────────────────────────────────────────────────────────────────────────────────────

func _s2_moves() -> void:
	print("\n§2 — the new moves in a fight")
	var s := await _battle("Warband", ["wolfrider", "shieldmaster", "hexer", "blight_speaker", "blightcap"])
	var heroes: Array = s.get("heroes")
	var h: BattleUnit = heroes[0]
	var wolf := _body(s, "wolfrider")
	var hexer := _body(s, "hexer")
	var flank := s.call("_find_ability", wolf, "Harrying Bite") as Ability
	var bite := s.call("_find_ability", wolf, "Lunging Bite") as Ability
	# The telegraph: a hex move hits as hard as its basic, so the status is its point and its body's plate shows Afflict;
	# its basic, the harder-or-equal blow with no status, shows Strike (test_batch_bl §1 holds the roster produces Afflict).
	var hex_cats: Array = []
	for pair in [["hexer", "Choking Hex"], ["blight_speaker", "Carrion Mark"], ["blightcap", "Rot Brand"]]:
		var hb := _body(s, String(pair[0]))
		hex_cats.append(String(s.call("_intent_category", hb, s.call("_find_ability", hb, String(pair[1])))))
	var basic_cat := String(s.call("_intent_category", hexer, hexer.abilities[0]))
	ok(hex_cats == ["afflict", "afflict", "afflict"] and basic_cat == "strike",
		"§2: a hex move does not telegraph Afflict beside its basic's Strike (%s, the basic %s)" % [hex_cats, basic_cat])
	# Flank: the record clears at the hero's turn, a strike by another body books it, and only the Flank move reads it.
	(s.get("_kj_struck") as Dictionary).erase(h)
	var alone := float(s.call("_kj_out_mult", wolf, h, flank))
	(s.get("_kj_struck") as Dictionary)[h] = [hexer]
	var flanked := float(s.call("_kj_out_mult", wolf, h, flank))
	var plain := float(s.call("_kj_out_mult", wolf, h, bite))
	(s.get("_kj_struck") as Dictionary)[h] = [wolf]
	var own := float(s.call("_kj_out_mult", wolf, h, flank))
	var pct: float = s.get("FLANK_PCT")
	print("    Flank: alone %.3f, flanked %.3f, the basic %.3f, struck by itself %.3f" % [alone, flanked, plain, own])
	ok(absf(flanked / alone - (1.0 + pct)) < 0.0001 and absf(plain - alone) < 0.0001 and absf(own - alone) < 0.0001,
		"§2: a Flank move does not land harder only where another body struck since the hero's last turn")
	# Flank's record, live: a body's blow books it on the hero it reaches.
	(s.get("_kj_struck") as Dictionary).erase(h)
	_fresh(h)
	await s._resolve(hexer, hexer.abilities[0], h, "good")
	ok(((s.get("_kj_struck") as Dictionary).get(h, []) as Array).has(hexer), "§2: a body's blow on a hero is not booked for Flank")
	# A companion takes no turn of its own: its span closes with its master's (`_kj_close_span`, which the turn loop calls for the
	# unit chosen to act), so a Flank on a beast is not harder for the rest of the fight. A hero stands in for the beast.
	var pal: BattleUnit = heroes[1]
	(s.get("_kj_struck") as Dictionary)[pal] = [hexer]
	h.beasts.append(pal)
	var has_close := s.has_method("_kj_close_span")  # a tree without the helper reds here, at its words, rather than throwing
	if has_close:
		s.call("_kj_close_span", h)
	h.beasts.erase(pal)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var rb_at := bsrc.find("func _run_battle(")
	var rb_end := bsrc.find("\nfunc ", rb_at + 1)
	var rb_calls := rb_at >= 0 and bsrc.substr(rb_at, rb_end - rb_at).contains("_kj_close_span(u)")
	ok(has_close and not (s.get("_kj_struck") as Dictionary).has(pal) and rb_calls,
		"§2: a companion's Flank span does not close with its master's turn (closed %s, the turn loop calls it %s)" % [
		str(not (s.get("_kj_struck") as Dictionary).has(pal)), str(rb_calls)])
	# The guard: Shield Guard cast; a hero's blow at the Hexer lands on the guard; a second blow in the same turn does not.
	var guard := _body(s, "shieldmaster")
	await s._resolve_special(guard, s.call("_find_ability", guard, "Shield Guard"), guard, "good", 1.0)
	ok(guard.has_status("guarding"), "§2: Shield Guard laid no Guarding")
	(s.get("_kj_guard_used") as Dictionary).clear()
	_fresh(guard)
	_fresh(hexer)
	var hp_g := guard.hp
	var hp_x := hexer.hp
	await s._resolve(h, h.abilities[0], hexer, "good")
	ok(guard.hp < hp_g and hexer.hp == hp_x, "§2: the first blow aimed at another body did not land on the guard (guard %d → %d, Hexer %d → %d)" % [
		hp_g, guard.hp, hp_x, hexer.hp])
	hp_x = hexer.hp
	await s._resolve(heroes[1], heroes[1].abilities[0], hexer, "good")
	ok(hexer.hp < hp_x, "§2: a second blow in the same turn was taken by the guard too")
	# A Break ends the guard (the designer's pick): Breaking the guard takes its Guarding off; and a Broken body guards nothing,
	# even one Guarding again, so a blow aimed at the Hexer lands on the Hexer.
	(s.get("_kj_guard_used") as Dictionary).clear()
	_fresh(guard)
	guard.take_hit(0, guard.stability * 10)   # its Constitution scales what reaches the meter, so the blow is made heavy
	ok(guard.broken and not guard.has_status("guarding"), "§2: a Break did not end the guard (broken %s, Guarding %s)" % [
		guard.broken, guard.has_status("guarding")])
	s.call("_apply_status", guard, "guarding", 2, 0, 0, guard)
	_fresh(hexer)
	hp_g = guard.hp
	hp_x = hexer.hp
	await s._resolve(h, h.abilities[0], hexer, "good")
	ok(guard.broken and guard.hp == hp_g and hexer.hp < hp_x, "§2: a Broken guard took a blow aimed at another body (guard %d → %d, Hexer %d → %d)" % [
		hp_g, guard.hp, hp_x, hexer.hp])
	_fresh(guard)
	guard.remove_status("guarding")
	# Silenced: the basic and nothing else; and a cleanse lifts it, as a debuff.
	var hero_ab: Ability = null
	for a in h.abilities:
		if a != h.abilities[0] and bool(s.call("_ability_usable", h, a)):
			hero_ab = a
			break
	ok(hero_ab != null, "§2: the hero holds no second usable ability to silence — nothing to drive")
	s.call("_apply_status", h, "silenced", 2, 0, 0, hexer)
	ok(bool(s.call("_ability_usable", h, h.abilities[0])) and (hero_ab == null or not bool(s.call("_ability_usable", h, hero_ab))),
		"§2: a Silenced hero may use something besides its basic attack, or not its basic")
	ok(BattleUnit.DEBUFF_IDS.has("silenced") and BattleUnit.DEBUFF_IDS.has("branded") and BattleUnit.DEBUFF_IDS.has("doomed")
		and BattleUnit.DEBUFF_IDS.has("singled_out"), "§2: a hex the warband lays on a hero is not a debuff a cleanse reaches")
	h.remove_status("silenced")
	# Branded: an ability costs the ruled share of maximum health; the basic costs none.
	var b_pct: float = s.get("BRAND_PCT")
	s.call("_apply_status", h, "branded", 3, 0, 0, hexer)
	h.hp = h.max_hp
	await s._resolve(h, h.abilities[0], hexer, "good")
	var after_basic := h.hp
	if hero_ab != null:
		h.hp = h.max_hp
		h.resource = h.max_resource
		var log0 := String((s.get("history") as RichTextLabel).get_parsed_text()).length()
		await s._resolve(h, hero_ab, _body(s, "blightcap") if hero_ab.target == Ability.Target.ENEMY else h, "good")
		# what the brand took, read off its own line — the ability's own heal or cost may move the bar beside it
		var said := String((s.get("history") as RichTextLabel).get_parsed_text()).substr(log0)
		var want := "pays %d health for %s" % [maxi(int(round(h.max_hp * b_pct)), 1), hero_ab.display_name]
		print("    Branded: the basic left %d of %d; %s: %s" % [after_basic, h.max_hp, hero_ab.display_name, str(said.contains(want))])
		ok(after_basic == h.max_hp and said.contains(want), "§2: a Branded hero did not pay its share for an ability (%s), or paid for the basic" % want)
	h.remove_status("branded")
	# Doomed: the warband's blows land harder on the hero.
	var undoomed := float(s.call("_kj_out_mult", hexer, h, hexer.abilities[0]))
	s.call("_apply_status", h, "doomed", 2, 0, 0, hexer)
	var doomed := float(s.call("_kj_out_mult", hexer, h, hexer.abilities[0]))
	ok(absf(doomed / undoomed - (1.0 + float(s.get("MARK_PCT")))) < 0.0001, "§2: a Doomed hero takes no more from the warband")
	h.remove_status("doomed")
	# Singled Out: every body aims at the hero; a taunt still draws it.
	var target_h: BattleUnit = heroes[2]
	s.call("_apply_status", target_h, "singled_out", 2, 0, 0, wolf)
	var aimed := 0
	for i in 20:
		var d: Dictionary = s.call("_choose_enemy_action", wolf, 1)
		if d.get("target") == target_h:
			aimed += 1
	ok(aimed == 20, "§2: a Singled Out hero drew %d of 20 picks, not every one" % aimed)
	s.call("_apply_status", wolf, "mocked", 2, heroes.find(heroes[1]), 0, heroes[1])
	var d2: Dictionary = s.call("_choose_enemy_action", wolf, 1)
	ok(d2.get("target") == heroes[1], "§2: a taunt no longer draws a body past a Singled Out hero")
	wolf.remove_status("mocked")
	target_h.remove_status("singled_out")
	s.queue_free()
	await Gate.frames(self, 2)
	# The brace, Frost Fury and the single-target wind-up.
	var s2 := await _battle("Warband", ["mossback", "rimehorn", "brute"])
	var heroes2: Array = s2.get("heroes")
	var moss := _body(s2, "mossback")
	var horn := _body(s2, "rimehorn")
	var brute := _body(s2, "brute")
	var bare := float(s2.call("_kj_in_mult", moss))
	await s2._resolve_special(moss, s2.call("_find_ability", moss, "Moss Shell"), moss, "good", 1.0)
	var braced := float(s2.call("_kj_in_mult", moss))
	ok(moss.has_status("hunkered") and absf(braced / bare - float(s2.get("BRACE_TAKEN"))) < 0.0001,
		"§2: a Hunkered body does not take the ruled share")
	var melee: BattleUnit = null
	var ranged: BattleUnit = null
	for hh in heroes2:
		if (hh as BattleUnit).is_ranged and ranged == null:
			ranged = hh
		elif not (hh as BattleUnit).is_ranged and melee == null:
			melee = hh
	ok(melee != null and ranged != null, "§2: no melee and ranged hero to drive the strike back")
	if melee != null and ranged != null:
		_fresh(melee)
		_fresh(moss)
		await s2._resolve(melee, melee.abilities[0], moss, "good")
		var melee_hit := melee.hp < melee.max_hp
		_fresh(ranged)
		_fresh(moss)
		await s2._resolve(ranged, ranged.abilities[0], moss, "good")
		ok(melee_hit and ranged.hp == ranged.max_hp, "§2: the brace did not strike back at the melee hitter alone (melee %s, ranged %d/%d)" % [
			str(melee_hit), ranged.hp, ranged.max_hp])
	# The page's play words, *"Hit something else that turn, or use spells"*: a melee hero's spell — a blow that is not physical,
	# the project's one reading of a spell (`CHANNEL_SPARES_PHYSICAL`) — is not struck back.
	var caster: BattleUnit = null
	var spell: Ability = null
	for hh in heroes2:
		var hu: BattleUnit = hh
		if hu.is_ranged or spell != null:
			continue
		for a in hu.abilities:
			var ab: Ability = a
			if ab.damage > 0 and ab.special == "" and ab.dmg_type != "physical":
				caster = hu
				spell = ab
				break
	ok(spell != null and moss.has_status("hunkered"), "§2: no melee hero holds a spell to drive the brace with, or the brace stood down")
	if spell != null:
		_fresh(caster)
		_fresh(moss)
		await s2._resolve(caster, spell, moss, "good")
		ok(caster.hp == caster.max_hp and moss.hp < moss.max_hp,
			"§2: a melee hero's spell (%s's %s) was struck back by the brace" % [caster.unit_name, spell.display_name])
	# The page's *"strikes back at each hero who hits it in melee"*: an area blow aimed at another body that strikes the braced
	# body beside it draws the strike back too (the melee hero's basic, made an area blow for the one swing).
	if melee != null:
		_fresh(melee)
		_fresh(moss)
		_fresh(brute)
		var area_ab: Ability = melee.abilities[0]
		var was_aoe := area_ab.aoe
		area_ab.aoe = true
		await s2._resolve(melee, area_ab, brute, "good")
		area_ab.aoe = was_aoe
		ok(moss.has_status("hunkered") and moss.hp < moss.max_hp and melee.hp < melee.max_hp,
			"§2: an area blow aimed at another body struck the braced body and drew no strike back (braced %d/%d, %s %d/%d)" % [
			moss.hp, moss.max_hp, melee.unit_name, melee.hp, melee.max_hp])
	# Frost Fury: once, at the door, when a blow takes it under its share.
	_fresh(horn)
	var at := float(s2.get("ENRAGE_AT"))
	horn.hp = int(horn.max_hp * at) + 1  # one point above its share: any blow that lands takes it under
	await s2._resolve(heroes2[0], heroes2[0].abilities[0], horn, "good")
	ok(horn.has_status("fury") == (horn.hp <= horn.max_hp * at), "§2: Frost Fury did not fire as its body fell under its share")
	var fury_mult := float(s2.call("_kj_out_mult", horn, heroes2[1], horn.abilities[0]))
	var had_fury := horn.has_status("fury")
	horn.remove_status("fury")
	var calm_mult := float(s2.call("_kj_out_mult", horn, heroes2[1], horn.abilities[0]))
	ok(had_fury and absf(fury_mult / calm_mult - (1.0 + float(s2.get("ENRAGE_PCT")))) < 0.0001,
		"§2: a body in its Fury does not land the ruled share harder (fury %s)" % str(had_fury))
	# The page's *"The first time"*: a Fury lifted (as a Dispel lifts it) does not come back — healed above its share and struck
	# under it again, the body does not roar a second time (`_kj_roared`).
	_fresh(horn)
	horn.hp = int(horn.max_hp * at) + 1
	await s2._resolve(heroes2[0], heroes2[0].abilities[0], horn, "good")
	ok(had_fury and horn.hp <= horn.max_hp * at and not horn.has_status("fury"),
		"§2: a body whose Fury was lifted roared again as it fell under its share a second time (%d/%d, fury %s)" % [
		horn.hp, horn.max_hp, str(horn.has_status("fury"))])
	# Skullsplitter: raised at one hero, it lands on that hero.
	var skull := s2.call("_find_ability", brute, "Skullsplitter") as Ability
	var aim: BattleUnit = heroes2[3]
	await s2._resolve_special(brute, skull, aim, "good", 1.0)
	ok(brute.has_status("charging") and brute.intent.get("target") == aim, "§2: Skullsplitter was not raised at the hero it was aimed at")
	for hh2 in heroes2:
		_fresh(hh2)
	s2.set("debug_enemies_off", false)
	await s2._enemy_turn(brute)
	s2.set("debug_enemies_off", true)
	ok(aim.hp < aim.max_hp and heroes2.filter(func(x): return x != aim and x.hp < x.max_hp).is_empty(),
		"§2: the raised Skullsplitter did not land on the hero it was raised at, and on no other")
	s2.queue_free()
	await Gate.frames(self, 2)


# ── §3 — THE TWELVE COMBOS ───────────────────────────────────────────────────────────────────────────────────────────────

func _s3_combos() -> void:
	print("\n§3 — each recipe's fight carries its combo, and each does what its words say")
	var s := await _battle("Warband", ["raider", "wolfrider", "hexer"])
	ok(String(s.get("_kj_combo")) == "Warband", "§3: a Warband fight carries no combo")
	var h: BattleUnit = (s.get("heroes") as Array)[0]
	var r := _body(s, "raider")
	var m3 := float(s.call("_kj_out_mult", r, h, r.abilities[0]))
	_body(s, "hexer").dead = true
	var m2 := float(s.call("_kj_out_mult", r, h, r.abilities[0]))
	ok(absf(m3 / m2 - (1.0 + float(s.get("COMBINED_ARMS_PCT")))) < 0.0001, "§3: Combined Arms does not need its kinds standing")
	s.queue_free()
	await Gate.frames(self, 2)
	# Swarm: each skirmisher deals more for every other body standing.
	s = await _battle("Swarm", ["raider", "raider", "raider", "whelp"])
	h = (s.get("heroes") as Array)[0]
	r = _body(s, "raider")
	var sw := float(s.call("_kj_out_mult", r, h, r.abilities[0]))
	ok(absf(sw - (1.0 + float(s.get("PACK_TACTICS_PCT")) * 3)) < 0.0001, "§3: Pack Tactics does not count the other bodies standing")
	s.queue_free()
	await Gate.frames(self, 2)
	# Monster Den: the rest deal more while a brute stands; Dazed when the last falls.
	s = await _battle("Monster Den", ["brute", "raider", "hexer"])
	h = (s.get("heroes") as Array)[0]
	r = _body(s, "raider")
	var den := float(s.call("_kj_out_mult", r, h, r.abilities[0]))
	ok(absf(den - (1.0 + float(s.get("ALPHA_PCT")))) < 0.0001, "§3: Alpha does not raise the rest while a brute stands")
	var b := _body(s, "brute")
	b.hp = 1
	b.take_hit(50, 0)
	await Gate.frames(self, 2)
	ok(b.dead and r.has_status("dazed") and _body(s, "hexer").has_status("dazed"), "§3: the last brute fell and the rest were not Dazed")
	s.queue_free()
	await Gate.frames(self, 2)
	# Cursed Company: a hero with two debuffs takes more.
	s = await _battle("Cursed Company", ["hexer", "blightcap"])
	h = (s.get("heroes") as Array)[0]
	var hx := _body(s, "hexer")
	var c0 := float(s.call("_kj_out_mult", hx, h, hx.abilities[0]))
	s.call("_apply_status", h, "sunder", 2, 0, 0, hx)
	s.call("_apply_status", h, "slow", 2, 0, 0, hx)
	var c2 := float(s.call("_kj_out_mult", hx, h, hx.abilities[0]))
	ok(absf(c2 / c0 - (1.0 + float(s.get("CURSE_PCT")))) < 0.0001, "§3: Compounding Curse does not read a hero's debuffs")
	# *"Two or more debuffs from this warband"*: a hero's debuffs no body of the warband laid do not count.
	var h2: BattleUnit = (s.get("heroes") as Array)[1]
	s.call("_apply_status", h2, "sunder", 2, 0, 0, h)
	s.call("_apply_status", h2, "slow", 2, 0, 0, h)
	var c3 := float(s.call("_kj_out_mult", hx, h2, hx.abilities[0]))
	ok(absf(c3 - c0) < 0.0001, "§3: Compounding Curse counts debuffs no body of the warband laid (x%.3f against x%.3f)" % [c3 / c0, 1.0])
	s.queue_free()
	await Gate.frames(self, 2)
	# Honor Guard: the elite takes less while a tank stands.
	s = await _battle("Honor Guard", ["chief", "shieldmaster"])
	var chief := _body(s, "chief")
	var hg := float(s.call("_kj_in_mult", chief))
	# The designer's pick: "Kill the guards first, or Break them" — a Broken tank guards the elite no more.
	_body(s, "shieldmaster").broken = true
	var hg_broken := float(s.call("_kj_in_mult", chief))
	_body(s, "shieldmaster").broken = false
	ok(absf(hg_broken - 1.0) < 0.0001, "§3: a Broken tank still cuts the elite's blows under Bodyguards (x%.3f)" % hg_broken)
	_body(s, "shieldmaster").dead = true
	ok(absf(hg - (1.0 - float(s.get("HONOR_GUARD_CUT")))) < 0.0001 and absf(float(s.call("_kj_in_mult", chief)) - 1.0) < 0.0001,
		"§3: Bodyguards does not cut the elite's blows while a tank stands, and only then")
	s.queue_free()
	await Gate.frames(self, 2)
	# Ritual: the count falls on a healer's turn, rises on a lost one, and at zero the warband rises whole.
	s = await _battle("Ritual", ["shaman", "grove_tender", "shieldmaster"])
	var sh := _body(s, "shaman")
	var start := int(s.get("_kj_rite_left"))
	s.call("_kj_rite_turn", sh)
	var after_one := int(s.get("_kj_rite_left"))
	s.call("_apply_status", sh, "stunned", 1, 0, 0, null, true)
	s.call("_kj_rite_turn", sh)
	var after_lost := int(s.get("_kj_rite_left"))
	sh.remove_status("stunned")
	var sm := _body(s, "shieldmaster")
	sm.hp = 10
	for i in after_lost:
		s.call("_kj_rite_turn", sh)
	ok(start == int(s.get("RITE_TURNS")) and after_one == start - 1 and after_lost == start and sm.hp == sm.max_hp
		and int(s.get("_kj_rite_left")) == start, "§3: The Rite does not count, falter and restore as its words say (%d, %d, %d, %d/%d)" % [
		start, after_one, after_lost, sm.hp, sm.max_hp])
	s.queue_free()
	await Gate.frames(self, 2)
	# Poison Volley: the archers aim at the most-poisoned hero and it takes more from them.
	s = await _battle("Poison Volley", ["archer", "archer", "archer"])
	var hs: Array = s.get("heroes")
	var ar := _body(s, "archer")
	s.call("_apply_status", hs[2], "poison", 3, 0, 0, ar)
	var aimed := 0
	for i in 12:
		if (s.call("_choose_enemy_action", ar, 1) as Dictionary).get("target") == hs[2]:
			aimed += 1
	var ff := float(s.call("_kj_out_mult", ar, hs[2], ar.abilities[0]))
	ok(aimed == 12 and absf(ff - (1.0 + float(s.get("FOCUS_FIRE_PCT")))) < 0.0001, "§3: Focus Fire did not aim at and harden on the poisoned hero (%d of 12)" % aimed)
	s.queue_free()
	await Gate.frames(self, 2)
	# Lightning Storm: three heals charge the next blow to strike every hero.
	s = await _battle("Lightning Storm", ["shaman", "hexer"])
	var shm := _body(s, "shaman")
	var wave := s.call("_find_ability", shm, "Healing Wave") as Ability
	for i in int(s.get("STATIC_CHARGES")):
		s.call("_kj_add_charge", shm, wave)
	ok(int(s.get("_kj_charges")) == int(s.get("STATIC_CHARGES")), "§3: Static Charge did not count the heals")
	var hs2: Array = s.get("heroes")
	for hh in hs2:
		_fresh(hh)
	var hx2 := _body(s, "hexer")
	hx2.intent = {"ability": hx2.abilities[0], "target": hs2[0], "turns": 1, "support": false, "message": "", "logs": []}
	s.set("debug_enemies_off", false)
	await s._enemy_turn(hx2)
	s.set("debug_enemies_off", true)
	ok(hs2.filter(func(x): return x.hp < x.max_hp).size() == hs2.size() and int(s.get("_kj_charges")) == 0,
		"§3: the charged blow did not strike every hero and clear the charges")
	s.queue_free()
	await Gate.frames(self, 2)
	# Rage Company: skirmishers aim at a hero under half.
	s = await _battle("Rage Company", ["wolfrider", "chief"])
	var hs3: Array = s.get("heroes")
	hs3[1].hp = int(hs3[1].max_hp * float(s.get("BLOOD_WATER_AT"))) - 1
	var wr := _body(s, "wolfrider")
	var drawn := 0
	for i in 12:
		if (s.call("_choose_enemy_action", wr, 1) as Dictionary).get("target") == hs3[1]:
			drawn += 1
	ok(drawn == 12, "§3: Blood in the Water drew %d of 12 picks to the hero under half" % drawn)
	s.queue_free()
	await Gate.frames(self, 2)
	# Guardian Circle: the warband takes less for each tank standing.
	s = await _battle("Guardian Circle", ["shieldmaster", "heartwood_sentinel", "icebound_bulwark", "hexer"])
	var gc := float(s.call("_kj_in_mult", _body(s, "hexer")))
	ok(absf(gc - (1.0 - 3 * float(s.get("INTERLOCK_CUT")))) < 0.0001, "§3: Interlocked Shields does not count the tanks standing")
	s.queue_free()
	await Gate.frames(self, 2)
	# Elite Patrol: the healer heals the elite first, and larger.
	s = await _battle("Elite Patrol", ["chief", "shaman", "shieldmaster"])
	var ch := _body(s, "chief")
	var sm2 := _body(s, "shieldmaster")
	var base := maxi(int(round(sm2.max_hp * 0.25)), 1)
	var on_elite := int(s.call("_warband_heal_figure", "healing_wave", ch))
	ok(on_elite == maxi(int(round(maxi(int(round(ch.max_hp * 0.25)), 1) * (1.0 + float(s.get("FIELD_MEDIC_PCT"))))), 1)
		and int(s.call("_warband_heal_figure", "healing_wave", sm2)) == base, "§3: Field Medic's heal on the elite is not the larger one")
	s.queue_free()
	await Gate.frames(self, 2)
	# Boss Escort: the boss takes less while its escort stands.
	s = await _battle("Boss Escort", ["ash_tyrant", "raider", "raider"])
	var boss := _body(s, "ash_tyrant")
	var lr := float(s.call("_kj_in_mult", boss))
	_body(s, "raider").dead = true
	ok(absf(lr - (1.0 - float(s.get("RETINUE_CUT")))) < 0.0001 and absf(float(s.call("_kj_in_mult", boss)) - 1.0) < 0.0001,
		"§3: Loyal Retinue does not cut the boss's blows while its escort stands, and only then")
	s.queue_free()
	await Gate.frames(self, 2)


# ── §4 — THE RECORD ─────────────────────────────────────────────────────────────────────────────────────────────────────

func _s4_record() -> void:
	print("\n§4 — the master document names the tiers, the new moves and the combos; the state says built")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	var missing: Array = []
	for kind in NEW_MOVES:
		for mv in NEW_MOVES[kind]:
			if not master.contains(String(mv)):
				missing.append(mv)
	for elite_move in ["War Cry"]:
		if not master.contains(String(elite_move)):
			missing.append(elite_move)
	var battle_src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var combo_names: Array = []
	var at := battle_src.find("const KJ_COMBOS")
	var block := battle_src.substr(at, battle_src.find("\n}", at) - at)
	for line in block.split("\n"):
		var q := String(line).find("\": [\"")
		if q >= 0:
			var nm := String(line).substr(q + 5)
			combo_names.append(nm.substr(0, nm.find("\"")))
	print("    CHECKED %d moves and %d combos in the master document" % [NEW_MOVES.size() + 1, combo_names.size()])
	for c in combo_names:
		if not master.to_lower().contains(String(c).to_lower()):
			missing.append(c)
	ok(combo_names.size() == 12 and missing.is_empty(), "§4: the master document does not name: %s (%d combos read)" % [missing, combo_names.size()])
	var state := FileAccess.get_file_as_string("res://docs/state.md")
	ok(not state.contains("THE ENEMY TIERS AND THE RECIPES' COMBOS — RULED, NOT BUILT") and state.contains("BUILT AT KJ FROM THE DESIGNER"),
		"§4: the state still marks the enemy half RULED, NOT BUILT, or does not say it is built")


# ── §5 — `check_ht`'s FUNCTION WINDOW, REPAIRED AT KJ §1 ──────────────────────────────────────────────────────────────
# IT's census row on `check_ht` §2's `_bodies` (STANDING since IU; owed by KJ's touch, which gave §1 a rite of its own): a
# function's window ends at its last indented line, so a top-level declaration below it is no function's text, and a
# function whose head wraps keeps its body.
func _s5_the_function_window() -> void:
	print("\n§5 — `check_ht`'s function window: a function ends at its last indented line")
	var src := "func a() -> int:\n\tvar s := \"own\"\n\n\treturn 1\n\n\nconst CARRIED := [\"carried\"]\nvar later := {\n\t\"also\": 1,\n}\n\n\nstatic func b(n: int,\n\t\tm: int) -> Array:\n\treturn [n, m]\n\nsignal done\n\n\nfunc c() -> void:\n\tpass\n"
	var wins: Array = HT._windows(src)
	var names: Array = []
	var by := {}
	for w in wins:
		names.append(String(w[0]))
		by[String(w[0])] = String(w[1])
	print("    the windows read off a func, two top-level declarations, a wrapped static func, a signal and a func: %s" % str(names))
	ok(not String(by.get("a", "")).contains("CARRIED") and not String(by.get("b", "")).contains("signal done"),
		"§5: a function's window runs on into the top-level declaration below it")
	ok(String(by.get("a", "")).contains("return 1") and String(by.get("b", "")).contains("return [n, m]"),
		"§5: a function's window stops short of its own last line")
	ok(names == ["a", "b", "c"], "§5: the windows are not one a function, each its own: %s" % str(names))


func _s6_the_players_files() -> void:
	print("\n§6 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§6: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§6: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
