# BATCH KD — A RELIC BELONGS TO ONE HERO (CX's ruling; JY's ruling 12, answered at JZ; the figures the designer's at KD).
#
# What this gate asserts, section by section (`docs/reports/KD.md` has the working):
#
#   §1  THE SPLIT: `Relics.HOLDER_HOOKS` is the eight battle-spawn stat hooks and nothing else; every hook a relic carries
#       is classified one or the other; a relic is held exactly when it carries one; no relic carries a holder hook beside an every-hero hook; the four hooks JY's ruling 12 kept
#       for every hero, and the six that set up the run, are none of them.
#   §2  THE FIGURES (the designer's balance ruling at KD, "Double them"): every held relic's figure is twice the one it
#       paid every hero before KD, the table below holding HEAD's figures as they stood.
#   §3  THE TEXTS: every held relic begins *The hero holding it*; Oxheart's states its own figure; no relic carries a
#       token, *All heroes* or *party*; an every-hero relic names no holder.
#   §4  THE DOOR: `Run.hand_relic` refuses a relic not carried, not held or already handed, and an index that is no hero's;
#       `relics_owed` is the held relics nobody holds, in the order carried; `relic_add` / `relic_dict` refuse a holder hook.
#   §5  THE SPAWN, DRIVEN: a held relic pays its holder alone, an owed one pays nobody, an every-hero one every hero.
#   §6  THE SAVE: the holders round-trip; a v16-shaped save (no holders) loads with its held relics owed; an entry for a
#       relic not carried is dropped and said.
#   §7  THE HAND-OUT, DRIVEN ON THE MAP: an owed relic opens its overlay first on arrival, a button a hero, and the press
#       hands it through the door; an every-hero relic opens nothing; a loaded save owing one opens it; the framing card's
#       dismissal starts the walk.
#   §8  THE BOT: `RunSim.hand_owed_relics` hands every owed relic to the hero holding fewest, the lowest index first.
#   §9  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether any figure is right — every one is the
# designer's — or how a player weighs which hero gambles; the sim's figures test the code only.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const SCRATCH_PROFILE := "user://kd_profile.json"
const SCRATCH_RELICS := "user://kd_relics.json"
const WANT_HOLDER_HOOKS := ["hero_attack_mult", "dmg_type_mult", "hero_max_hp_mult", "hero_armor_add",
	"hero_speed_add", "hero_crit_add", "hero_con_add", "hero_resist_add"]
# JY's ruling 12's four, and the six CX recorded as party-wide by nature: every hero's, never a holder's.
const EVERY_HERO_HOOKS := ["victory_heal_pct", "victory_mana_pct", "fallen_recover", "resource_floor_pct",
	"start_items", "start_gold", "gold_find_mult", "shop_discount", "loot_extra", "victory_gold"]
# HEAD's figures before KD, when each paid every hero (`scripts/relics.gd` at 090687d). The ruling is the relation —
# twice what it paid every hero — so the table is the before, and §2 asserts the after against it.
const BEFORE_KD := {
	"emberheart": {"dmg_type_mult": {"fire": 0.20, "holy": 0.20}},
	"frostsigil": {"dmg_type_mult": {"frost": 0.20, "arcane": 0.20}},
	"nightbloom": {"dmg_type_mult": {"shadow": 0.20, "nature": 0.20}},
	"whetstone": {"hero_crit_add": 0.05},
	"ironbark": {"hero_armor_add": 0.05},
	"fleetstep": {"hero_speed_add": 5},
	"oxheart": {"hero_max_hp_mult": 0.10},
	"drumskin": {"hero_con_add": 15},
	"dragonbone": {"hero_attack_mult": 0.10},
	"runedplate": {"hero_resist_add": {"physical": 0.10}},
	"prismveil": {"hero_resist_add": {"fire": 0.10, "frost": 0.10, "nature": 0.10, "shadow": 0.10, "holy": 0.10, "arcane": 0.10}},
	"warhorn": {"hero_attack_mult": 0.12},
}
const HOLDER_WORDS := "The hero holding it"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KD — A RELIC BELONGS TO ONE HERO")
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
	_fresh_meta(true)
	_s1_split()
	_s2_figures()
	_s3_texts()
	_s4_door()
	await _s5_spawn()
	_s6_save()
	await _s7_handout()
	_s8_bot()
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta(framing_seen: bool) -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	if framing_seen:
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


func _new_run(relics: Array) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, relics, "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(ENG4[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _row(s: Node, field: String) -> Array:
	var out: Array = []
	for h in _heroes(s):
		out.append(float((h as BattleUnit).get(field)))
	return out


func _battle() -> Node:
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	Engine.time_scale = 1.0
	return current_scene


func _same(a: Variant, b: Variant) -> bool:
	if a is Dictionary and b is Dictionary:
		if (a as Dictionary).size() != (b as Dictionary).size():
			return false
		for k in a:
			if not (b as Dictionary).has(k) or not _same(a[k], b[k]):
				return false
		return true
	return is_equal_approx(float(a), float(b))


func _twice(v: Variant) -> Variant:
	if v is Dictionary:
		var out := {}
		for k in v:
			out[k] = _twice(v[k])
		return out
	return float(v) * 2.0


func _modal(mp: Node, z: int) -> Control:
	for c in mp.get_children():
		if c is Control and not c.is_queued_for_deletion() and (c as Control).z_index == z:
			return c
	return null


func _all_buttons(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Button:
			out.append(c)
		_all_buttons(c, out)


# ── §1 — THE SPLIT ──────────────────────────────────────────────────────────

func _s1_split() -> void:
	print("\n§1 — the holder hooks are the eight spawn stats; a relic is held exactly when it carries one")
	ok(_same_set(Relics.HOLDER_HOOKS, WANT_HOLDER_HOOKS), "§1: HOLDER_HOOKS reads %s" % str(Relics.HOLDER_HOOKS))
	for h in EVERY_HERO_HOOKS:
		ok(not Relics.HOLDER_HOOKS.has(h), "§1: %s, every hero's by ruling, is a holder hook" % h)
	var held := 0
	for id in Relics.POOL:
		var hooks: Dictionary = Relics.POOL[id].get("hooks", {})
		var hold_n := 0
		for k in hooks:
			if Relics.HOLDER_HOOKS.has(k):
				hold_n += 1
		for k in hooks:
			ok(Relics.HOLDER_HOOKS.has(k) or EVERY_HERO_HOOKS.has(k), "§1: %s carries %s, a hook classified neither holder nor every hero" % [id, k])
		ok(hold_n == 0 or hold_n == hooks.size(), "§1: %s mixes a holder hook with an every-hero hook (%s)" % [id, str(hooks.keys())])
		ok(Relics.is_held(String(id)) == (hold_n > 0), "§1: is_held(%s) is %s" % [id, str(Relics.is_held(String(id)))])
		if hold_n > 0:
			held += 1
	ok(held == BEFORE_KD.size(), "§1: %d relics are held — want the %d the table names" % [held, BEFORE_KD.size()])
	for id in BEFORE_KD:
		ok(Relics.POOL.has(id) and Relics.is_held(String(id)), "§1: %s is not a held relic" % id)
	print("    CHECKED %d relics: %d held, %d every hero's" % [Relics.POOL.size(), held, Relics.POOL.size() - held])


func _same_set(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for x in a:
		if not b.has(x):
			return false
	return true


# ── §2 — THE FIGURES ────────────────────────────────────────────────────────

func _s2_figures() -> void:
	print("\n§2 — every held relic pays its holder twice what it paid every hero (the designer's ruling at KD)")
	for id in BEFORE_KD:
		var hooks: Dictionary = Relics.POOL.get(id, {}).get("hooks", {})
		for hook in BEFORE_KD[id]:
			var want: Variant = _twice(BEFORE_KD[id][hook])
			ok(hooks.has(hook) and _same(hooks[hook], want), "§2: %s's %s reads %s — want %s" % [
				id, hook, str(hooks.get(hook, "none")), str(want)])
	print("    CHECKED %d held relics against HEAD's figures doubled" % BEFORE_KD.size())


# ── §3 — THE TEXTS ──────────────────────────────────────────────────────────

func _s3_texts() -> void:
	print("\n§3 — a held relic names its holder; no relic says All heroes")
	for id in Relics.POOL:
		var t := Relics.desc_of(String(id))
		ok(not t.contains("All heroes") and not t.to_lower().contains("party"), "§3: %s still reads %s" % [id, JSON.stringify(t)])
		ok(not t.contains("{"), "§3: %s carries an unresolved token: %s" % [id, t])
		if Relics.is_held(String(id)):
			ok(t.begins_with(HOLDER_WORDS), "§3: %s does not name its holder: %s" % [id, JSON.stringify(t)])
		else:
			ok(not t.contains(HOLDER_WORDS), "§3: %s pays every hero and names a holder: %s" % [id, JSON.stringify(t)])
	var ox := Relics.desc_of("oxheart")
	ok(ox.contains("+%d%%" % int(round(float(Relics.POOL["oxheart"]["hooks"]["hero_max_hp_mult"]) * 100.0))),
		"§3: Oxheart's words do not state its own figure: %s" % ox)


# ── §4 — THE DOOR ───────────────────────────────────────────────────────────

func _s4_door() -> void:
	print("\n§4 — one door writes a holder, and it refuses what it should")
	_new_run(["dragonbone", "chalice", "whetstone"])
	ok(_run.relics_owed() == ["dragonbone", "whetstone"], "§4: owed reads %s — want the two held, in order" % str(_run.relics_owed()))
	ok(not _run.hand_relic("chalice", 0), "§4: an every-hero relic was handed")
	ok(not _run.hand_relic("warhorn", 0), "§4: a relic not carried was handed")
	ok(not _run.hand_relic("dragonbone", -1) and not _run.hand_relic("dragonbone", 4), "§4: an index that is no hero's was taken")
	ok(_run.hand_relic("dragonbone", 2), "§4: the door refused a held relic to the Cleric")
	ok(not _run.hand_relic("dragonbone", 1), "§4: a handed relic was handed again")
	ok(_run.relic_holders == {"dragonbone": 2}, "§4: holders read %s" % str(_run.relic_holders))
	ok(_run.relics_owed() == ["whetstone"] and _run.hero_relics(2) == ["dragonbone"] and _run.hero_relics(0).is_empty(),
		"§4: owed %s, the Cleric's %s" % [str(_run.relics_owed()), str(_run.hero_relics(2))])
	ok(is_equal_approx(_run.hero_relic_add(2, "hero_attack_mult"), float(Relics.POOL["dragonbone"]["hooks"]["hero_attack_mult"])),
		"§4: the Cleric's own sum reads %.2f" % _run.hero_relic_add(2, "hero_attack_mult"))
	ok(is_zero_approx(_run.relic_add("hero_attack_mult")) and _run.relic_dict("dmg_type_mult").is_empty(),
		"§4: the party-wide reader paid a holder hook")
	ok(is_equal_approx(_run.relic_add("victory_heal_pct"), float(Relics.POOL["chalice"]["hooks"]["victory_heal_pct"])),
		"§4: the party-wide reader lost an every-hero hook")


# ── §5 — THE SPAWN, DRIVEN ──────────────────────────────────────────────────

func _s5_spawn() -> void:
	print("\n§5 — the spawn pays a held relic to its holder alone")
	_new_run([])
	var s0: Node = await _battle()
	var base_dmg := _row(s0, "dmg_bonus")
	var base_crit := _row(s0, "crit_bonus")
	var base_hp := _row(s0, "max_hp")
	_new_run(["dragonbone", "whetstone", "oxheart"])
	_run.hand_relic("dragonbone", 1)
	_run.hand_relic("whetstone", 1)
	var s1: Node = await _battle()
	var dmg := _row(s1, "dmg_bonus")
	var crit := _row(s1, "crit_bonus")
	var hp := _row(s1, "max_hp")
	var want_dmg := float(Relics.POOL["dragonbone"]["hooks"]["hero_attack_mult"])
	var want_crit := float(Relics.POOL["whetstone"]["hooks"]["hero_crit_add"])
	ok(dmg.size() == 4 and base_dmg.size() == 4, "§5: the fight fielded %d heroes" % dmg.size())
	if dmg.size() == 4 and base_dmg.size() == 4:
		for i in 4:
			var d_want := want_dmg if i == 1 else 0.0
			var c_want := want_crit if i == 1 else 0.0
			ok(is_equal_approx(dmg[i] - base_dmg[i], d_want), "§5: hero %d's dmg_bonus moved %.3f — want %.3f" % [i, dmg[i] - base_dmg[i], d_want])
			ok(is_equal_approx(crit[i] - base_crit[i], c_want), "§5: hero %d's crit moved %.3f — want %.3f" % [i, crit[i] - base_crit[i], c_want])
			ok(is_equal_approx(hp[i], base_hp[i]), "§5: hero %d's max health moved with Oxheart handed to nobody (%.0f, %.0f)" % [i, hp[i], base_hp[i]])
	_run.hand_relic("oxheart", 3)
	var s2: Node = await _battle()
	var hp2 := _row(s2, "max_hp")
	if hp2.size() == 4 and base_hp.size() == 4:
		ok(hp2[3] > base_hp[3] and hp2[0] == base_hp[0] and hp2[1] == base_hp[1] and hp2[2] == base_hp[2],
			"§5: Oxheart handed to the Hunter moved %s from %s" % [str(hp2), str(base_hp)])
	print("    CHECKED three spawns: the holder's two stats, nobody's health while owed, the Hunter's once handed")


# ── §6 — THE SAVE ───────────────────────────────────────────────────────────

func _s6_save() -> void:
	print("\n§6 — the holders ride the save; a save without them loads with its held relics owed")
	ok(int(_run.SAVE_VERSION) > 16, "§6: the save version did not move past 16 for the holders (%d)" % int(_run.SAVE_VERSION))
	_new_run(["dragonbone", "chalice"])
	_run.hand_relic("dragonbone", 3)
	_run.save_run()
	_run.relic_holders = {}
	ok(_run.load_run() and _run.relic_holders == {"dragonbone": 3}, "§6: the holders came back as %s" % str(_run.relic_holders))
	# A v16-shaped file: the same save with no holders and the old version.
	var f := FileAccess.open(_run.save_path, FileAccess.READ)
	var data: Dictionary = f.get_var(true)
	f.close()
	data.erase("relic_holders")
	data["version"] = 16
	var w := FileAccess.open(_run.save_path, FileAccess.WRITE)
	w.store_var(data, true)
	w.close()
	ok(_run.load_run() and _run.relic_holders.is_empty() and _run.relics_owed() == ["dragonbone"],
		"§6: a v16 save loaded holders %s and owed %s" % [str(_run.relic_holders), str(_run.relics_owed())])
	data["version"] = int(_run.SAVE_VERSION)
	data["relic_holders"] = {"warhorn": 1, "dragonbone": 0}
	w = FileAccess.open(_run.save_path, FileAccess.WRITE)
	w.store_var(data, true)
	w.close()
	ok(_run.load_run() and _run.relic_holders == {"dragonbone": 0}, "§6: a stale entry stood: %s" % str(_run.relic_holders))
	ok(_run.load_notes.any(func(n): return String(n).contains("Horn of the First War is not a relic one hero holds in this run")),
		"§6: the dropped entry was not said as dropped: %s" % str(_run.load_notes))
	_run.clear_save()


# ── §7 — THE HAND-OUT, DRIVEN ON THE MAP ────────────────────────────────────

func _to_map() -> Node:
	_run.map_reentry = false
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	return current_scene


func _s7_handout() -> void:
	print("\n§7 — the map hands an owed relic first, a button a hero")
	_new_run(["chalice", "dragonbone", "warhorn"])
	var mp: Node = await _to_map()
	var ov := _modal(mp, 66)
	ok(ov != null, "§7: the hand-out did not open on arrival")
	ok(Gate.hero_draft(mp) == null, "§7: a hero's screen opened before the relics were handed")
	if ov != null:
		var bs: Array = []
		_all_buttons(ov, bs)
		var heroes := bs.filter(func(b): return (b as Button).has_meta("relic_hero"))
		ok(heroes.size() == 4 and bs.size() == 4, "§7: the hand-out holds %d hero buttons of %d — want four and nothing else" % [heroes.size(), bs.size()])
		for b in heroes:
			if int((b as Button).get_meta("relic_hero")) == 1:
				(b as Button).pressed.emit()
		await Gate.frames(self, 4)
		Engine.time_scale = 1.0
		ok(_run.relic_holders == {"dragonbone": 1}, "§7: the press handed %s" % str(_run.relic_holders))
		var ov2 := _modal(mp, 66)
		ok(ov2 != null and ov2 != ov, "§7: the second owed relic did not open next")
		if ov2 != null:
			var bs2: Array = []
			_all_buttons(ov2, bs2)
			for b in bs2:
				if (b as Button).has_meta("relic_hero") and int((b as Button).get_meta("relic_hero")) == 1:
					ok((b as Button).text.contains("Dragonbone Idol"), "§7: the Mage's button does not name what he holds: %s" % (b as Button).text)
					(b as Button).pressed.emit()
			await Gate.frames(self, 4)
			Engine.time_scale = 1.0
		ok(_run.relic_holders == {"dragonbone": 1, "warhorn": 1} and _modal(mp, 66) == null,
			"§7: one hero holds two: %s, and the hand-out closed" % str(_run.relic_holders))
	# An every-hero relic opens nothing.
	_new_run(["chalice"])
	mp = await _to_map()
	ok(_modal(mp, 66) == null, "§7: an every-hero relic opened the hand-out")
	# A load is an arrival: a save carrying a held relic owed resumes on the map, and the map hands it.
	_new_run(["dragonbone"])
	_run.save_run()
	_run.relic_holders = {"dragonbone": 0}
	ok(_run.load_run() and _run.relics_owed() == ["dragonbone"], "§7: the loaded save owed %s" % str(_run.relics_owed()))
	var to := String(_run.resume_scene())
	ok(to.ends_with("map.tscn"), "§7: a save with nothing pending resumed at %s" % to)
	mp = await _to_map()
	ok(_modal(mp, 66) != null, "§7: a loaded save with a held relic owed did not open the hand-out")
	_run.clear_save()
	# The framing card covers the first arrival, and its dismissal starts the walk.
	_fresh_meta(false)
	_new_run(["dragonbone"])
	mp = await _to_map()
	ok(_modal(mp, 66) == null and _modal(mp, 91) != null, "§7: the hand-out opened under the framing card, or the card is not up")
	var road: Array = []
	_all_buttons(mp, road)
	var take := road.filter(func(b): return (b as Button).text == "Take the road")
	ok(take.size() == 1, "§7: the framing card's button was not found (%d)" % take.size())
	if take.size() == 1:
		(take[0] as Button).pressed.emit()
		await Gate.frames(self, 6)
		Engine.time_scale = 1.0
		ok(_modal(mp, 66) != null, "§7: dismissing the framing card did not start the hand-out")
	_fresh_meta(true)


# ── §8 — THE BOT ────────────────────────────────────────────────────────────

func _s8_bot() -> void:
	print("\n§8 — the bot hands each owed relic to the hero holding fewest, the lowest index first")
	_new_run(["dragonbone", "whetstone", "warhorn"])
	RunSim.hand_owed_relics(_run)
	ok(_run.relic_holders == {"dragonbone": 0, "whetstone": 1, "warhorn": 2}, "§8: the bot handed %s" % str(_run.relic_holders))
	_new_run(["chalice", "oxheart"])
	_run.hand_relic("oxheart", 0)
	_run.active_relics.append("ironbark")
	RunSim.hand_owed_relics(_run)
	ok(_run.relic_holders == {"oxheart": 0, "ironbark": 1}, "§8: an event's grant went to %s" % str(_run.relic_holders))
	var b_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	# The branch that arms a standalone sim's loadout, to the statement after it (the full-kit arm): the bot's hand-out is in it.
	var arm := b_src.find("Run.active_relics = OS.get_environment(\"DOD_SIM_RELICS\").split(\",\")")
	var arm_end := b_src.find("if sim and OS.get_environment(\"DOD_SIM_GRANT_ALL\")", arm)
	var arm_body := b_src.substr(arm, arm_end - arm) if arm >= 0 and arm_end > arm else ""
	ok(arm_body.contains("Run.relic_holders = {}") and arm_body.contains("RunSim.hand_owed_relics(Run)") and arm_body.length() < 400,
		"§8: a standalone sim's loadout is not handed by the bot's policy (%d chars read)" % arm_body.length())
	var s_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_sim.gd"))
	ok(s_src.count("hand_owed_relics(run)") == 2, "§8: the run sim hands relics at %d places — want the class selection and the event" % s_src.count("hand_owed_relics(run)"))


func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
