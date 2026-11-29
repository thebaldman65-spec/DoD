# BATCH KL — A PASSIVE SHOWS ITSELF, BLOOD TRIBUTE A PASSIVE, A READY MOVE FIRST, AND THE PLAYTEST's FIVE FIXES (the designer's
# message in conversation, 28 November, and the six answers after it; KL's work folder, `RECORD_KL.md`).
#
# What this gate asserts, section by section (`docs/reports/KL.md` has the working):
#
#   §1  THE DATA: the Orc Slinger is gone and no kind or map names it, a saved one reads as the Orc Archer; the Bloodcaller
#       carries Ragged Cut and the Blood Tribute passive, and its old blow is gone; a tier-N kind's moves and passives number
#       N (a passive takes a move's place); Cinder Cleave strikes two and burns each for 3 turns; Entomb lays Chilled for 3,
#       no freeze.
#   §2  BLOOD TRIBUTE, DRIVEN: its chip stands from the fight's start; each fall of its warband is said in the log, floats its
#       name and moves the chip by `BLOOD_TRIBUTE_PCT`, and a Raise takes none back; its attack then lands harder by that share,
#       said again.
#   §3  THE COMBOS SHOW THEMSELVES: every recipe's chip stands on the bodies it works through and on no other; Pack Tactics'
#       reads the warband standing and moves as a body falls; a blow it raises is said and floats; Interlocked Shields is said
#       on a hero's blow it cuts.
#   §4  BLOOD IN THE WATER: every body of the warband aims at the weakest hero with no threshold, no taunt pulls it, a Singled
#       Out hero still draws it, the aim is taken again as the blow goes (the weakest fallen, the next), and the hover says the
#       designer's words.
#   §5  A READY MOVE BEFORE THE BASIC: a body with a move that cools ready uses it, and its basic once that move cools; a move
#       with no cooldown is mixed with the basic (answer 6).
#   §6  CINDER CLEAVE AND ENTOMB, DRIVEN: the Cleave strikes two heroes and burns each for 3 turns; Entomb lays one Chilled stack.
#   §7  THE ZONES ON THE FOREST's ART are tinted in battle.
#   §8  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether a player sees the chips and floats in the heat of a
# fight, and whether the fights play as the designer wants — every figure is the designer's and the sim tests the code.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://kl_profile.json"
const SCRATCH_RELICS := "user://kl_relics.json"
const ENEMIES_JSON := "res://data/enemies.json"
# Which bodies each recipe's chip stands on, by kind, in the fights §3 drives (its words and figures are the KJ page's).
const COMBO_FIGHTS := {
	"Warband": [["raider", "wolfrider", "hexer"], ["raider", "wolfrider", "hexer"]],
	"Swarm": [["raider", "raider", "whelp", "shieldmaster"], ["raider", "raider", "whelp"]],
	"Monster Den": [["brute", "raider", "hexer"], ["raider", "hexer"]],
	"Cursed Company": [["hexer", "blightcap"], ["hexer", "blightcap"]],
	"Honor Guard": [["chief", "shieldmaster"], ["chief"]],
	"Ritual": [["shaman", "grove_tender", "shieldmaster"], ["shaman", "grove_tender"]],
	"Poison Volley": [["archer", "archer", "archer"], ["archer", "archer", "archer"]],
	"Lightning Storm": [["shaman", "hexer"], ["shaman", "hexer"]],
	"Rage Company": [["wolfrider", "chief"], ["wolfrider", "chief"]],
	"Guardian Circle": [["shieldmaster", "heartwood_sentinel", "hexer"], ["shieldmaster", "heartwood_sentinel", "hexer"]],
	"Elite Patrol": [["chief", "shaman", "shieldmaster"], ["shaman"]],
	"Boss Escort": [["ash_tyrant", "raider", "raider"], ["ash_tyrant"]],
}

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _data := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KL — A PASSIVE SHOWS ITSELF, BLOOD TRIBUTE A PASSIVE, A READY MOVE FIRST, AND THE PLAYTEST's FIVE FIXES")
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
	await _s2_tribute()
	await _s3_combos()
	await _s4_blood_water()
	await _s5_ready_first()
	await _s6_cleave_entomb()
	await _s7_tint()
	Engine.time_scale = 1.0
	_s8_the_players_files()
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


func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _battle(theme: String, kinds: Array, zone := "") -> Node:
	_new_run()
	if zone != "":
		_run.zone_name = zone
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


func _end(s: Node) -> void:
	s.queue_free()
	await Gate.frames(self, 2)


func _body(s: Node, kind: String, nth := 0) -> BattleUnit:
	var seen := 0
	for e in s.get("enemies"):
		if (e as BattleUnit).enemy_kind == kind:
			if seen == nth:
				return e
			seen += 1
	return null


func _logtext(s: Node) -> String:
	return (s.get("history") as RichTextLabel).get_parsed_text()


func _floated(s: Node, u: BattleUnit, pname: String) -> bool:
	var fl: Variant = s.get("_kl_floated")
	return fl is Dictionary and (fl as Dictionary).has("%d|%s" % [u.get_instance_id(), pname])


func _chip(u: BattleUnit, id: String) -> String:
	var c: Dictionary = u.display_chip(id)
	return String(c.get("short", "")) if not c.is_empty() else ""


func _move(kind: String, name: String) -> Dictionary:
	for a in (_data[kind] as Dictionary)["abilities"]:
		if String(a.get("display_name", "")) == name:
			return a
	return {}


# ── §1 — THE DATA ─────────────────────────────────────────────────────────────────────────────────────────────────────────

func _s1_data() -> void:
	print("\n§1 — the data: the Slinger gone, Blood Tribute a passive, a passive in a move's place, the Cleave and Entomb")
	ok(not _data.has("slinger"), "§1: the Orc Slinger still stands in the data")
	var retired: Dictionary = (load("res://scripts/enemies.gd") as GDScript).get_script_constant_map().get("RETIRED", {})
	ok(String(retired.get("slinger", "")) == "archer", "§1: a saved Orc Slinger does not read as the Orc Archer")
	ok(String(Enemies.config("slinger").get("unit_name", "")) == "Orc Archer", "§1: the config of a saved slinger is not the archer's")
	ok((_data["archer"] as Dictionary)["zones"].has(2.0), "§1: the Orc Archer is not of the Scarlands' roster")
	var bc: Dictionary = _data["bloodcaller"]
	var kit: Array = (bc["abilities"] as Array).map(func(a): return String(a["display_name"]))
	ok(kit == ["Ragged Cut"], "§1: the Bloodcaller's moves are %s, not Ragged Cut alone" % [kit])
	var pv: Array = bc.get("passives", [])
	ok(pv.size() == 1 and String((pv[0] as Dictionary).get("id", "")) == "blood_tribute"
		and String((pv[0] as Dictionary).get("display_name", "")) == "Blood Tribute",
		"§1: the Bloodcaller does not carry the Blood Tribute passive: %s" % [pv])
	var specials: Array = []
	for kind in _data:
		for a in (_data[kind] as Dictionary)["abilities"]:
			if String(a.get("special", "")) == "blood_tribute":
				specials.append(kind)
	ok(specials.is_empty(), "§1: a move still carries the blood_tribute special: %s" % [specials])
	var bad_count: Array = []
	for kind in _data:
		var v: Dictionary = _data[kind]
		var p := int(v["power"])
		var n: int = (v["abilities"] as Array).size() + (v.get("passives", []) as Array).size()
		if p <= 3 and n != p:
			bad_count.append("%s: tier %d carries %d" % [kind, p, n])
	ok(bad_count.is_empty(), "§1: a kind's moves and passives are not its tier's count: %s" % [bad_count])
	var cc := _move("ash_tyrant", "Cinder Cleave")
	ok(bool(cc.get("choose_two", false)) and String((cc.get("applies_status", {}) as Dictionary).get("id", "")) == "burn"
		and int((cc.get("applies_status", {}) as Dictionary).get("turns", 0)) == 3 and float(cc.get("status_chance", 1.0)) == 1.0,
		"§1: Cinder Cleave does not strike two and burn each for 3 turns: %s" % [cc])
	var en := _move("icewrought_titan", "Entomb")
	ok(String((en.get("applies_status", {}) as Dictionary).get("id", "")) == "chilled"
		and int((en.get("applies_status", {}) as Dictionary).get("turns", 0)) == 3,
		"§1: Entomb does not lay Chilled for 3 turns: %s" % [en.get("applies_status", {})])
	var froze: Array = []
	for kind in _data:
		for a in (_data[kind] as Dictionary)["abilities"]:
			if String((a.get("applies_status", {}) as Dictionary).get("id", "")) == "frozen":
				froze.append("%s's %s" % [kind, a["display_name"]])
	ok(froze.is_empty(), "§1: a warband move still freezes: %s" % [froze])
	_new_run()
	_run.map = [[{"type": "fight", "enemies": ["slinger", "raider"]}]]
	_run.encounter = {"type": "fight", "enemies": ["slinger"]}
	_run.call("_drop_stale_save_keys")
	ok(Array(_run.map[0][0]["enemies"]) == ["archer", "raider"] and Array(_run.encounter["enemies"]) == ["archer"],
		"§1: a saved map's slinger did not load as an archer: %s / %s" % [_run.map[0][0]["enemies"], _run.encounter["enemies"]])


# ── §2 — BLOOD TRIBUTE, DRIVEN ───────────────────────────────────────────────────────────────────────────────────────────

func _s2_tribute() -> void:
	print("\n§2 — Blood Tribute: a chip from the start, each fall said, floated and counted, and the attack harder by it")
	var s := await _battle("Warband", ["bloodcaller", "raider", "raider"])
	var b := _body(s, "bloodcaller")
	var pct_v: Variant = s.get("BLOOD_TRIBUTE_PCT")
	var pct := float(pct_v) if pct_v != null else 0.0
	ok(absf(pct - 0.25) < 0.0001, "§2: Blood Tribute's share is %s, not the designer's 25%%" % pct)
	ok(_chip(b, "kl_blood_tribute") == "+0%", "§2: the Bloodcaller's chip at the start reads '%s', not +0%%" % _chip(b, "kl_blood_tribute"))
	var h: BattleUnit = (s.get("heroes") as Array)[1]
	var rc: Ability = b.abilities[0]
	var m0: float = await _mean_blow(s, b, rc, h)
	_body(s, "raider")._die()
	await Gate.frames(self, 2)
	ok(_logtext(s).contains("Blood Tribute: Orc Raider's fall feeds the rite"), "§2: the first fall is not said in the log")
	ok(_floated(s, b, "Blood Tribute"), "§2: the first fall floated no Blood Tribute over the Bloodcaller")
	ok(_chip(b, "kl_blood_tribute") == "+25%", "§2: after one fall the chip reads '%s', not +25%%" % _chip(b, "kl_blood_tribute"))
	var m1: float = await _mean_blow(s, b, rc, h)
	ok(absf(m1 / maxf(m0, 1.0) - 1.25) < 0.08, "§2: one fall raised Ragged Cut %.2fx, not 1.25x (%.1f to %.1f)" % [m1 / maxf(m0, 1.0), m0, m1])
	ok(_logtext(s).contains("Blood Tribute: Orc Bloodcaller strikes 25% harder"), "§2: the paying blow is not said in the log")
	# A Raise takes no fall back (answer 1: "for the rest of the fight"), and a raised body that falls again feeds the rite again.
	var r0 := _body(s, "raider")
	r0.revive(0.4)
	s.call("_kl_refresh_passives")
	ok(_chip(b, "kl_blood_tribute") == "+25%", "§2: a Raise took a fall back: the chip reads '%s', not +25%%" % _chip(b, "kl_blood_tribute"))
	r0._die()
	await Gate.frames(self, 2)
	ok(_chip(b, "kl_blood_tribute") == "+50%", "§2: a raised body's second fall reads '%s', not +50%%" % _chip(b, "kl_blood_tribute"))
	_body(s, "raider", 1)._die()
	await Gate.frames(self, 2)
	ok(_chip(b, "kl_blood_tribute") == "+75%", "§2: after three falls the chip reads '%s', not +75%%" % _chip(b, "kl_blood_tribute"))
	await _end(s)


# The mean of 24 landed blows (the gate's units neither miss, crit nor block), the hero healed between.
func _mean_blow(s: Node, u: BattleUnit, ab: Ability, h: BattleUnit) -> float:
	var tot := 0.0
	for i in 24:
		h.hp = h.max_hp
		h.statuses = []
		h.pressure = 0
		h.broken = false
		h.broken_pending = false
		var hp0 := h.hp
		await s._resolve(u, ab, h, "good")
		tot += hp0 - h.hp
	return tot / 24.0


# ── §3 — THE COMBOS SHOW THEMSELVES ──────────────────────────────────────────────────────────────────────────────────────

func _s3_combos() -> void:
	print("\n§3 — every combo's chip on the bodies it works through; Pack Tactics' reading and its firing; Interlocked Shields'")
	var wrong: Array = []
	for theme in COMBO_FIGHTS:
		var s := await _battle(theme, COMBO_FIGHTS[theme][0])
		var want: Array = COMBO_FIGHTS[theme][1]
		var got: Array = []
		for e in s.get("enemies"):
			if (e as BattleUnit).has_display_chip("kl_combo"):
				got.append((e as BattleUnit).enemy_kind)
		var want_s: Array = want.duplicate()
		want_s.sort()
		got.sort()
		if got != want_s:
			wrong.append("%s: %s, want %s" % [theme, got, want_s])
		await _end(s)
	ok(wrong.is_empty(), "§3: a combo's chip stands on the wrong bodies: %s" % [wrong])
	var s := await _battle("Swarm", ["raider", "raider", "raider", "whelp"])
	var r := _body(s, "raider")
	ok(_chip(r, "kl_combo") == "+24%", "§3: Pack Tactics' chip reads '%s' with four standing, not +24%%" % _chip(r, "kl_combo"))
	var h: BattleUnit = (s.get("heroes") as Array)[1]
	await s._resolve(r, r.abilities[0], h, "good")
	ok(_logtext(s).contains("Pack Tactics: Orc Raider strikes 24% harder, 3 of its warband beside it"), "§3: a Pack Tactics blow is not said")
	ok(_floated(s, r, "Pack Tactics"), "§3: a Pack Tactics blow floated nothing over the raider")
	_body(s, "raider", 1)._die()
	_body(s, "whelp")._die()
	await Gate.frames(self, 2)
	ok(_chip(r, "kl_combo") == "+8%", "§3: Pack Tactics' chip reads '%s' with two standing, not +8%%" % _chip(r, "kl_combo"))
	await _end(s)
	s = await _battle("Guardian Circle", ["shieldmaster", "heartwood_sentinel", "hexer"])
	var hx := _body(s, "hexer")
	var w: BattleUnit = (s.get("heroes") as Array)[0]
	await s._resolve(w, w.abilities[0], hx, "good")
	ok(_logtext(s).contains("Interlocked Shields: Orc Hexer takes"), "§3: a hero's blow Interlocked Shields cut is not said")
	ok(_floated(s, hx, "Interlocked Shields"), "§3: Interlocked Shields floated nothing over the struck body")
	await _end(s)


# ── §4 — BLOOD IN THE WATER ──────────────────────────────────────────────────────────────────────────────────────────────

func _s4_blood_water() -> void:
	print("\n§4 — Blood in the Water: the whole warband at the weakest hero, no threshold, no taunt; Singled Out first")
	var s := await _battle("Rage Company", ["wolfrider", "chief"])
	var words := String((s.get("KJ_COMBOS") as Dictionary)["Rage Company"][1]).replace("\n", " ")
	ok(words.contains("All enemies attack the target with the weakest health, regardless of taunts"),
		"§4: the hover does not say the designer's words: %s" % words)
	var hs: Array = s.get("heroes")
	var shares := [0.9, 0.8, 0.7, 0.6]
	for i in hs.size():
		hs[i].hp = int(hs[i].max_hp * shares[i])
	var wolf := _body(s, "wolfrider")
	var chief := _body(s, "chief")
	var drawn := 0
	for i in 12:
		for u in [wolf, chief]:
			if (s.call("_choose_enemy_action", u, 1) as Dictionary).get("target") == hs[3]:
				drawn += 1
	ok(drawn == 24, "§4: Blood in the Water drew %d of 24 picks to the weakest hero, none under half" % drawn)
	# The aim is taken again as the blow goes: the weakest fallen since the declaration, the blow goes at the next.
	hs[3].hp = 0
	hs[3].dead = true
	var again: Variant = s.call("_kl_blood_water_aim", wolf, wolf.abilities[0], hs[3], false)
	ok(again == hs[2] and _logtext(s).contains("Blood in the Water: Wolfrider goes for the weakest, Cleric"),
		"§4: a blow declared at a hero who has fallen did not go at the next weakest, said: %s" % [again.unit_name if again is BattleUnit else str(again)])
	hs[3].dead = false
	hs[3].hp = int(hs[3].max_hp * shares[3])
	ok(Gate.fn_body("scripts/battle.gd", "_enemy_turn", {}).contains("d_target = _kl_blood_water_aim(u, d_ab, d_target,"),
		"§4: the warband's turn does not take Blood in the Water's aim again as the blow goes")
	s.call("_apply_status", wolf, "mocked", 2, 0, 0, hs[0])
	var taunted := 0
	for i in 12:
		if (s.call("_choose_enemy_action", wolf, 1) as Dictionary).get("target") == hs[3]:
			taunted += 1
	ok(taunted == 12, "§4: a taunt pulled %d of 12 picks from the weakest hero" % (12 - taunted))
	s.call("_apply_status", hs[1], "singled_out", 2, 0, 0, chief)
	var singled := 0
	for i in 12:
		if (s.call("_choose_enemy_action", wolf, 1) as Dictionary).get("target") == hs[1]:
			singled += 1
	ok(singled == 12, "§4: a Singled Out hero drew %d of 12 picks, not every one (answer 3)" % singled)
	await _end(s)


# ── §5 — A READY MOVE BEFORE THE BASIC ───────────────────────────────────────────────────────────────────────────────────

func _s5_ready_first() -> void:
	print("\n§5 — a ready move before the basic (answer 4)")
	var s := await _battle("Warband", ["wolfrider", "raider"])
	var wolf := _body(s, "wolfrider")
	wolf.cooldowns = {}
	var moved := 0
	for i in 12:
		var ab: Ability = (s.call("_choose_enemy_action", wolf, 1) as Dictionary).get("ability")
		if ab != null and ab.display_name == "Harrying Bite":
			moved += 1
	ok(moved == 12, "§5: a ready Harrying Bite was taken %d of 12 times, not every time" % moved)
	wolf.cooldowns = {"Harrying Bite": 3}
	var basic := 0
	for i in 12:
		var ab: Ability = (s.call("_choose_enemy_action", wolf, 1) as Dictionary).get("ability")
		if ab != null and ab.display_name == "Lunging Bite":
			basic += 1
	ok(basic == 12, "§5: with Harrying Bite cooling the basic was taken %d of 12 times" % basic)
	# Answer 6: a move with no cooldown is mixed with the basic, not taken before it.
	var r := _body(s, "raider")
	r.abilities = [r.abilities[0], Ability.make({"display_name": "Test Blow", "damage": 20, "pressure": 10, "delay": 2.0, "anim": "attack01"})]
	r.cooldowns = {}
	var mixed := {}
	for i in 40:
		var ab: Ability = (s.call("_choose_enemy_action", r, 1) as Dictionary).get("ability")
		if ab != null:
			mixed[ab.display_name] = int(mixed.get(ab.display_name, 0)) + 1
	ok(mixed.size() == 2, "§5: a move with no cooldown was not mixed with the basic over 40 picks: %s" % [mixed])
	await _end(s)


# ── §6 — CINDER CLEAVE AND ENTOMB, DRIVEN ────────────────────────────────────────────────────────────────────────────────

func _s6_cleave_entomb() -> void:
	print("\n§6 — Cinder Cleave strikes two and burns each for 3 turns; Entomb lays one Chilled stack")
	var s := await _battle("Warband", ["ash_tyrant"])
	var t := _body(s, "ash_tyrant")
	var hs: Array = s.get("heroes")
	var cc: Ability = s.call("_find_ability", t, "Cinder Cleave")
	await s._resolve(t, cc, hs[0], "good")
	var struck: Array = (s.call("_hero_side") as Array).filter(func(h): return h.hp < h.max_hp)
	var burned: Array = struck.filter(func(h): return h.has_status("burn") and int(h.get_status("burn").get("turns", 0)) == 3)
	ok(struck.size() == 2 and struck.has(hs[0]), "§6: Cinder Cleave struck %d heroes, not its target and one more" % struck.size())
	ok(burned.size() == struck.size(), "§6: Cinder Cleave burned %d of the %d it struck for 3 turns" % [burned.size(), struck.size()])
	await _end(s)
	s = await _battle("Warband", ["icewrought_titan"])
	t = _body(s, "icewrought_titan")
	var h: BattleUnit = (s.get("heroes") as Array)[1]
	await s._resolve(t, s.call("_find_ability", t, "Entomb"), h, "good")
	ok(h.has_status("chilled") and h.status_stacks("chilled") == 1 and not h.has_status("frozen"),
		"§6: Entomb left chilled x%d, frozen %s, not one Chilled stack" % [h.status_stacks("chilled"), h.has_status("frozen")])
	await _end(s)


# ── §7 — THE ZONES ON THE FOREST's ART ───────────────────────────────────────────────────────────────────────────────────

func _s7_tint() -> void:
	print("\n§7 — the zones that wear the Forest's art wear their own colour")
	var tints_v: Variant = _run.get("PLACEHOLDER_TINT")
	var tints: Dictionary = tints_v if tints_v is Dictionary else {}
	ok(tints.has("The Frozen Plains") and tints.has("The Drowned Barrow") and not tints.has("Forest of Old"),
		"§7: the placeholder tints are %s" % [tints.keys()])
	var s := await _battle("Warband", ["hailcaster"], "The Frozen Plains")
	var art_tint := Color.WHITE
	for c in s.get_children():
		if c is Sprite2D and (c as Sprite2D).texture != null and (c as Sprite2D).texture.resource_path.contains("battle_background"):
			art_tint = (c as Sprite2D).modulate
	ok(art_tint == tints.get("The Frozen Plains", Color.WHITE) and art_tint != Color.WHITE, "§7: a Frozen Plains fight's art is tinted %s" % art_tint)
	await _end(s)


func _s8_the_players_files() -> void:
	print("\n§8 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§8: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§8: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
