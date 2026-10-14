# BATCH IE — THE RESOURCES, AND THE MAGE'S FIRE.
#
#   §1  THE CLERIC ON THE TURN HE CANNOT AFFORD HIS HEAL — the instrument IE's dry-turn figure rests on: with an
#       ally hurt and a full bar the bot reaches for a heal that costs Mana; with the bar empty it casts a card it
#       can afford. The drip a turn for each Mana hero is PRINTED, never asserted (the rate is the designer's to
#       re-rule, and a re-tune must leave this gate green).
#   §2a A CHIP IS NOT A STATUS: every engine a hero holds draws one chip (★), named for its noun, in the plate's
#       row — and none of them is in `statuses`, none is found by `has_status`, and none books a Sanctity event;
#       a status laid beside them still books one. The spawn lays them through `set_engine_chip`, never through
#       the status door; the live chips still read live.
#   §2b THE SWEEP, KEPT: every `add_status` in the game's scripts with a literal id, and how many lines read that
#       id back — PRINTED; the classification (a chip, or an effect) is the report's.
#   §3a STOKE AND CINDERFALL LAY THEIR BURN: Stoke sets an enemy not alight Burning and still multiplies a fire
#       that stands; Cinderfall sets every enemy it rakes that was not alight Burning, skims what burns, and
#       lights nothing it killed. Both through the status door — Emberkeep doubles the light, and a chilled
#       enemy lit becomes a Rupture.
#   §3b THE FIRE CENSUS AT A COLD BOARD, KEPT AS A TABLE — the longest case: every card a Mage can hold that
#       deals fire or is fire by name, cast once on a board with nothing alight. Each lays Burn, lays none for a
#       named reason, or is refused with nothing alight; a new fire card reds until it is named.
#   §4  ✦ NAMES A RUNE, EACH SURFACE APART: the hero sheet's worn row carries no ✦ beside its state column; the
#       nameplate's ✦ N is labelled with what it counts; the Empower toggle carries no glyph; the battle's rune
#       chip is ✦; the loadout panel's carried card carries none — IE's finding, built at IF §3 (its sections are
#       `check_if` §3a's).
#   §5a THE REFILL, MEASURED BEFORE THE SPEND WAS BUILT: a zone boss's offer re-asked to nothing stays nothing
#       after the engine its pool waited on is equipped; a mini-boss's stays nothing after he holds a card an
#       untaken upgrade fits.
#   §5b A SPENT PICK: the screen says it in the cache's words and offers Let it go; the Confirm waits on that;
#       pressed, the pick is gone and so is its ◆ on the card — for the zone boss's and for the upgrade.
#   §5c A HELD-BACK PICK STAYS OWED: no Let it go, its words, and its ◆.
#   §5d THE ABILITY: a zone boss's pick without the draft names itself, and the other kinds join it.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** The figures IE was asked for — the Cleric's dry turns beside the Mage's
# and the Hunter's, Sanctity's events a fight, Burn standing on a Mage's turns — are SIM measurements taken by an
# instrumented copy and reported (`docs/reports/IE.md`); this asserts the mechanisms they rest on. `Run` is fetched
# off the tree, never named in a preload.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_ie.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://ie_profile.json"
const SCRATCH_RELICS := "user://ie_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20261013
const STAR := "✦"
const DIAMOND := "◆"
const ARROW := "↑"

# §3b — EVERY FIRE CARD A MAGE CAN HOLD, AND WHAT IT DOES ON A BOARD WITH NOTHING ALIGHT. "lays" lays Burn at the
# cast; "refused" is refused while nothing burns; any other entry is the reason it lays none. A fire card that
# is not here reds; one here that a Mage can no longer hold reds too.
const FIRE_TABLE := {
	"Fireball": "lays",
	"Flamewave": "lays",
	"Firestorm": "lays",
	"Ember Debt": "lays",
	"Stoke": "lays",
	"Cinderfall": "lays",
	# BATCH IF §2 — the designer's card: it lays Burn on a cold enemy and consumes nothing.
	"Smoulder": "lays",
	"Immolate": "lays Burn on whoever strikes him, not at the cast",
	"Detonation": "lays Burn on a Perfect only, after it consumes the bank",
	"Pyroblast": "a payoff: half again on a target already Burning",
	"Slow Burn": "stops the clock; lays no fire",
	"Emberkeep": "doubles the Burn that arrives; lays none",
	"Phoenix Rebirth": "pays health for Mana",
	"Ashes of Al'ar": "a return from death",
	"Wildfire": "refused",
	"Funeral Pyre": "refused",
	"Pyre Wake": "refused",
	"Firedraw": "refused",
	"Backdraft": "refused",
}
# Fire by name or by text, though no fire is dealt: the population the damage school alone would miss.
const FIRE_BY_NAME := ["Backdraft", "Phoenix Rebirth", "Ashes of Al'ar", "Immolate", "Emberkeep", "Slow Burn"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IE — THE RESOURCES, AND THE MAGE'S FIRE")
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
	seed(SEED)
	await _s1_the_dry_turn()
	await _s2a_a_chip_is_not_a_status()
	_s2b_the_sweep()
	await _s3a_stoke_and_cinderfall()
	await _s3b_the_fire_census()
	await _s4_each_surface()
	_s5a_the_refill()
	await _s5b_a_spent_pick()
	await _s5c_held_back()
	await _s5d_the_ability()
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
	f.store_string(JSON.stringify([]))
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []


func _to_map() -> Node:
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	Engine.time_scale = 1.0
	return current_scene


func _board(specs: Array, over: Dictionary = {}) -> Node:
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


# A clean body: no status, health to spare, an unbroken meter — so one cast cannot hand the next a softened board.
func _wipe(u: BattleUnit) -> void:
	u.statuses = []
	u.broken = false
	u.broken_pending = false
	u.pressure = 0
	u.max_hp = maxi(u.max_hp, 100000)
	u.hp = u.max_hp
	u._refresh_chips()


func _all(n: Node, cls: String) -> Array:
	var out: Array = []
	if n == null:
		return out
	var stack: Array = [n]
	while not stack.is_empty():
		var cur: Node = stack.pop_front()
		if cur.is_class(cls) and not cur.is_queued_for_deletion():
			out.append(cur)
		for c in cur.get_children():
			stack.append(c)
	return out


func _texts(n: Node) -> Array:
	var out: Array = []
	for l in _all(n, "Label"):
		out.append(String((l as Label).text))
	for b in _all(n, "Button"):
		out.append(String((b as Button).text))
	return out


func _press(n: Node, method: String, k := 0) -> Array:
	if n == null:
		return []
	var bs: Array = Gate.bound_buttons(n, method)
	if bs.size() <= k:
		return []
	var args := Gate.bound_args(bs[k], method)
	(bs[k] as Button).emit_signal("pressed")
	return args


func _confirm(mp: Node) -> Button:
	for b in _all(Gate.hero_draft(mp), "Button"):
		for c in (b as Button).pressed.get_connections():
			if (c["callable"] as Callable).get_method() == "_confirm_hero_draft":
				return b
	return null


func _title(mp: Node) -> String:
	for l in _all(Gate.hero_draft(mp), "Label"):
		if int((l as Label).position.y) == 16:
			return String((l as Label).text)
	return ""


func _rune(id: String, worn: bool) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = worn
	return r


# An ordinary live rune the member's class can wear, by the roll's own door.
func _class_rune(m: Dictionary) -> String:
	for id in Runes.eligible_ids(m, _run.party_rune_names()):
		if not Runes.is_engine_rune(String(id)) and not Runes.is_party_rune(Runes.config(String(id))):
			return String(id)
	return ""


# ── §1 — THE CLERIC ON THE TURN HE CANNOT AFFORD HIS HEAL ────────────────────────

func _s1_the_dry_turn() -> void:
	print("\n§1 — the dry turn: a full bar reaches for a costed heal, an empty one casts what it can afford")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"])
	var cl := _hero(s, "cleric")
	var war := _hero(s, "warrior")
	if cl == null or war == null:
		ok(false, "§1: the board seats a Cleric and a Warrior")
		await _clear(s)
		return
	war.hp = int(war.max_hp * 0.45)
	cl.resource = cl.max_resource
	var full: Array = s.call("_autoplay_pick", cl)
	var full_ab: Ability = full[0] if not full.is_empty() else null
	var full_cost: int = int(s.call("_eff_cost", cl, full_ab)) if full_ab != null else 0
	cl.resource = 0
	var dry: Array = s.call("_autoplay_pick", cl)
	var dry_ab: Ability = dry[0] if not dry.is_empty() else null
	var dry_cost: int = int(s.call("_eff_cost", cl, dry_ab)) if dry_ab != null else -1
	print("    with an ally at 45%%: a full bar casts %s (%d Mana); an empty one casts %s (%d)" % [
		full_ab.display_name if full_ab != null else "nothing", full_cost,
		dry_ab.display_name if dry_ab != null else "nothing", dry_cost])
	ok(full_ab != null and full_cost > 0, "§1: with an ally hurt and a full bar the bot does not reach for a card that costs Mana")
	ok(dry_ab != null and dry_cost == 0 and dry_ab != full_ab,
		"§1: with the bar empty the bot does not fall back to a card it can afford (%s)" % [dry_ab.display_name if dry_ab != null else "none"])
	# The drip, read off the one door every Mana hero's turn passes — printed, never asserted.
	var drips := []
	for k in ["cleric", "mage", "hunter"]:
		var h := _hero(s, k)
		if h != null:
			drips.append("%s %d" % [k, int(s.call("_mana_regen", h))])
	print("    the drip a turn, off `_mana_regen`: %s" % ", ".join(drips))
	await _clear(s)


# ── §2a — A CHIP IS NOT A STATUS ─────────────────────────────────────────────────

func _s2a_a_chip_is_not_a_status() -> void:
	print("\n§2a — an engine's chip is drawn, named and live, and is not a status")
	# The Warden holds a second engine, so a second chip's id is read too.
	var two: Array = Runes.engine_pouch_for_spec("warden") + Runes.engine_pouch_for_spec("swordmaster")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {0: {"engines": two}})
	await Gate.frames(self, 2)
	var chips_seen := 0
	for h in s.get("heroes"):
		var u: BattleUnit = h
		if u.is_companion:
			continue
		ok(u.engine_chips.size() == u.engines.size() and not u.engines.is_empty(),
			"§2a (%s): %d chips for %d engines" % [u.hero_key, u.engine_chips.size(), u.engines.size()])
		for pid in u.engines:
			var chip: Dictionary = u.engine_chip(String(pid))
			var id := u.engine_chip_id(String(pid))
			ok(not chip.is_empty() and String(chip.get("id", "")) == id
					and String(chip.get("label", "")) == Classes.engine_title(String(pid)) and int(chip.get("turns", 0)) < 0,
				"§2a (%s, %s): the chip is missing or not named for its engine (%s)" % [u.hero_key, pid, chip])
			ok(not u.has_status(id) and not u.statuses.any(func(st): return String(st.id).begins_with("spec_passive")),
				"§2a (%s, %s): the engine's chip is a status — found by has_status or standing in `statuses`" % [u.hero_key, pid])
			chips_seen += 1
		u._refresh_chips()
	await Gate.frames(self, 1)
	for h2 in s.get("heroes"):
		var u2: BattleUnit = h2
		if u2.is_companion:
			continue
		var drawn := 0
		for c in (u2.get("_chips_root") as Node).get_children():
			if c is ColorRect and not c.is_queued_for_deletion():
				drawn += 1
		# BATCH IG §1 — the row draws the display chips too (a talent's or a card's), between the two.
		ok(drawn == u2.engine_chips.size() + u2.display_chips.size() + u2.statuses.size(),
			"§2a (%s): the row draws %d chips for %d engine chips, %d display chips and %d statuses" % [u2.hero_key, drawn, u2.engine_chips.size(), u2.display_chips.size(), u2.statuses.size()])
	# NONE BOOKED A SANCTITY EVENT AT THE SPAWN — the ledger's own keys, read — BESIDE a status that does.
	var booked: Array = BattleUnit._sanctity_seen.keys().filter(func(k): return String(k).contains(":spec_passive"))
	ok(booked.is_empty(), "§2a: an engine's chip booked a Sanctity event: %s" % [booked])
	var foe: BattleUnit = _foes(s)[0]
	var ev0 := int(BattleUnit.sanctity_events)
	s.call("_apply_status", foe, "sunder", 3)
	ok(int(BattleUnit.sanctity_events) == ev0 + 1,
		"§2a: the positive arm — a status landing beside the chips did not book its one event (%d → %d)" % [ev0, BattleUnit.sanctity_events])
	# LIVE, OFF THE SAME DOOR: Heavy Plating's chip reads the live Block, the Stances' the guard held.
	var war := _hero(s, "warrior")
	if war != null:
		war.refresh_bars()
		var hp_chip: Dictionary = war.engine_chip("heavy_plating")
		var st_chip: Dictionary = war.engine_chip("seasoned")
		ok(String(hp_chip.get("short", "")).begins_with("Block ") and ["AGG", "DEF"].has(String(st_chip.get("short", ""))),
			"§2a: the live chips do not read live (Heavy Plating '%s', the Stances '%s')" % [hp_chip.get("short", ""), st_chip.get("short", "")])
		ok(war.engine_chip_id("seasoned") == "spec_passive_2", "§2a: the second engine's chip id is %s" % war.engine_chip_id("seasoned"))
	print("    %d engine chips across the four, none a status, none booked" % chips_seen)
	# THE SOURCE: the spawn lays them through their own writer, and nothing lays one through the status door.
	var b := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(b.contains("u.set_engine_chip(String(pid)") and not b.contains("add_status(u.engine_chip_id"),
		"§2a: the spawn does not lay the engine chips through `set_engine_chip`, or still lays one as a status")
	await _clear(s)


# ── §2b — THE SWEEP, KEPT ────────────────────────────────────────────────────────

func _s2b_the_sweep() -> void:
	print("\n§2b — every add_status with a literal id in the game's scripts, and its readers (printed)")
	var rx := RegEx.create_from_string("add_status\\(\\s*\"([a-z_0-9]+)\"")
	var srcs := {}
	var dir := DirAccess.open("res://scripts")
	for f in dir.get_files():
		if f.ends_with(".gd"):
			srcs[f] = Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f))
	var ids := {}
	for f2 in srcs:
		for m in rx.search_all(String(srcs[f2])):
			ids[m.get_string(1)] = int(ids.get(m.get_string(1), 0)) + 1
	var keys: Array = ids.keys()
	keys.sort()
	var rows: Array = []
	for id in keys:
		var reads := 0
		for f3 in srcs:
			for verb in ["has_status(\"%s\"", "get_status(\"%s\"", "status_power(\"%s\"", "status_stacks(\"%s\""]:
				reads += String(srcs[f3]).count(verb % id)
		rows.append("%s ×%d read %d" % [id, ids[id], reads])
	print("    %d ids: %s" % [keys.size(), "; ".join(rows)])
	ok(keys.size() > 0, "§2b: the sweep read no add_status at all")


# ── §3a — STOKE AND CINDERFALL LAY THEIR BURN ────────────────────────────────────

func _s3a_stoke_and_cinderfall() -> void:
	print("\n§3a — Stoke lights a cold enemy and doubles a lit one; Cinderfall lights what it rakes cold")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"])
	var mage := _hero(s, "mage")
	var foes := _foes(s)
	if mage == null or foes.size() < 3:
		ok(false, "§3a: the board seats a Mage and three enemies")
		await _clear(s)
		return
	var light := int(s.get("STOKE_LIGHT_TURNS"))
	var catch := int(s.get("CINDERFALL_LIGHT_TURNS"))
	ok(light > 0 and catch > 0, "§3a: the premise — the two lights are figures (%d, %d)" % [light, catch])
	var stoke := Classes.pool_ability("Stoke")
	var cinder := Classes.pool_ability("Cinderfall")
	for f in foes:
		_wipe(f)
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, stoke, a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == light,
		"§3a: Stoke did not set a cold enemy Burning for its %d turns (got %d)" % [light, int(a.get_status("burn").get("turns", 0))])
	s.call("_apply_status", b, "burn", 4, 0, 6, mage)
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, stoke, b, "good")
	ok(int(b.get_status("burn").get("turns", 0)) == 8,
		"§3a: Stoke no longer doubles a fire that stands — 4 turns read %d" % int(b.get_status("burn").get("turns", 0)))
	# THROUGH THE STATUS DOOR: Emberkeep doubles what arrives, and a chill lit becomes a Rupture.
	for f in foes:
		_wipe(f)
	s.call("_apply_status", mage, "emberkeep", 5, 0, 0, mage)
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, stoke, a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == light * 2,
		"§3a: Emberkeep did not double Stoke's light — it is laid around the status door (read %d)" % int(a.get_status("burn").get("turns", 0)))
	mage.remove_status("emberkeep")
	s.call("_apply_status", b, "chilled", 3, 0, 0, mage)
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, stoke, b, "good")
	ok(b.has_status("rupture") or b.statuses.any(func(st): return String(st.id) == "rupture"),
		"§3a: a chilled enemy lit by Stoke did not become a Rupture")
	# CINDERFALL: a lit bank skimmed, a cold enemy caught, a dying one left alone.
	for f in foes:
		_wipe(f)
	var c: BattleUnit = foes[2]
	s.call("_apply_status", a, "burn", 6, 0, 6, mage)
	c.max_hp = 1
	c.hp = 1
	mage.resource = mage.max_resource
	await s.call("_resolve", mage, cinder, a, "good")
	ok(int(a.get_status("burn").get("turns", 0)) == 4,
		"§3a: Cinderfall did not skim two turns from the burning bank (6 → %d)" % int(a.get_status("burn").get("turns", 0)))
	ok(int(b.get_status("burn").get("turns", 0)) == catch,
		"§3a: Cinderfall did not set a cold enemy Burning for its %d turns (got %d)" % [catch, int(b.get_status("burn").get("turns", 0))])
	ok(c.dead and not c.has_status("burn"), "§3a: Cinderfall lit the enemy it killed, or did not kill it (dead %s)" % c.dead)
	await _clear(s)


# ── §3b — THE FIRE CENSUS AT A COLD BOARD ────────────────────────────────────────

func _s3b_the_fire_census() -> void:
	print("\n§3b — every fire card a Mage can hold, cast once on a board with nothing alight")
	# What a Mage can hold: his basic, his kit, what his class's engines bring, his class's one draft pool, and the
	# three lineages' zone-boss pools.
	var names: Array = [Classes.kit("mage")[0].display_name]
	names.append_array(Classes.class_kit_names("mage"))
	for pid in Classes.class_engines("mage"):
		names.append_array(Classes.engine_enablers(String(pid)))
	names.append_array(Classes.draft_pool("mage"))
	for lin in ["pyromancer", "cryomancer", "arcanist"]:
		names.append_array(Classes.spec_pool(lin))
	var fire: Array = []
	for n in names:
		var ab: Ability = Classes.pool_ability(String(n))
		if ab == null or fire.has(String(n)):
			continue
		if ab.dmg_type == "fire" or FIRE_BY_NAME.has(String(n)):
			fire.append(String(n))
	fire.sort()
	var want: Array = FIRE_TABLE.keys()
	want.sort()
	ok(fire == want, "§3b: the fire population moved — unnamed %s, no longer held %s" % [
		fire.filter(func(n): return not FIRE_TABLE.has(n)), want.filter(func(n): return not fire.has(n))])
	var s: Node = await _board(["warden", "cryomancer", "holy", "mystic"])
	var mage := _hero(s, "mage")
	if mage == null:
		ok(false, "§3b: the board seats a Mage")
		await _clear(s)
		return
	var got := {}
	for n2 in fire:
		var ab2: Ability = Classes.pool_ability(String(n2))
		for f in _foes(s):
			_wipe(f)
		mage.statuses = []
		mage.cooldowns = {}
		mage.resource = mage.max_resource
		mage.hp = mage.max_hp
		if not bool(s.call("_ability_usable", mage, ab2)):
			got[n2] = "refused"
			continue
		var tgt: BattleUnit = mage if ab2.target == Ability.Target.ALLY else _foes(s)[0]
		await s.call("_resolve", mage, ab2, tgt, "good")
		var lit := _foes(s).any(func(f): return (f as BattleUnit).has_status("burn"))
		got[n2] = "lays" if lit else "none"
	var lays: Array = fire.filter(func(n): return got.get(n, "") == "lays")
	print("    lays Burn on a cold board: %s" % [lays])
	print("    refused with nothing alight: %s" % [fire.filter(func(n): return got.get(n, "") == "refused")])
	print("    lays none: %s" % [fire.filter(func(n): return got.get(n, "") == "none")])
	var wrong: Array = []
	for n3 in fire:
		var w: String = FIRE_TABLE.get(n3, "")
		var g: String = got.get(n3, "")
		if (w == "lays" or w == "refused") and g != w:
			wrong.append("%s: %s, not %s" % [n3, g, w])
		elif w != "lays" and w != "refused" and g != "none":
			wrong.append("%s: %s, not none (%s)" % [n3, g, w])
	ok(wrong.is_empty(), "§3b: a fire card did not do on a cold board what its row says: %s" % [wrong])
	# THE LONGEST CASE, NAMED: of the cards that read Burn and lay none at HEAD, the two IE gave their Burn are
	# the ones that light the board now.
	ok(lays.has("Stoke") and lays.has("Cinderfall"), "§3b: the longest case — a Mage holding every reader and no applier still cannot light a cold board")
	await _clear(s)


# ── §4 — ✦ NAMES A RUNE, EACH SURFACE APART ──────────────────────────────────────

func _s4_each_surface() -> void:
	print("\n§4 — ✦: no mark beside the sheet's state column; the count labelled; no glyph on Empower; the rune chip ✦")
	# THE HERO SHEET: a worn rune's row is its name, the state column says WORN, and no label carries ✦.
	_new_run()
	var m: Dictionary = _run.party[2]
	var rid := _class_rune(m)
	ok(rid != "", "§4: the premise — a Cleric rune to wear")
	m["runes"] = [_rune(rid, true)]
	_run.hero_screen_idx = 2
	change_scene_to_file("res://scenes/party.tscn")
	await Gate.frames(self, 6)
	var sheet_tx: Array = _texts(current_scene)
	var rname := String(Runes.config(rid).get("name", ""))
	var row: Array = sheet_tx.filter(func(t): return String(t).begins_with(rname + " — "))
	ok(row.size() == 1 and sheet_tx.has("WORN") and not sheet_tx.any(func(t): return String(t).contains(STAR)),
		"§4: the sheet's worn row is not its name beside WORN, or a label on the sheet carries ✦ (%s)" % [row])
	ok(not sheet_tx.any(func(t): return int(String(t).contains(STAR)) + int(String(t).contains(DIAMOND)) + int(String(t).contains(ARROW)) > 1),
		"§4: a label on the sheet carries two of ✦, ◆ and ↑")
	# THE NAMEPLATE: ✦ N, and its tooltip says what the count counts.
	_new_run()
	var m2: Dictionary = _run.party[2]
	var rid2 := _class_rune(m2)
	m2["runes"] = [_rune(rid2, false)]
	var mp := await _to_map()
	var marks: Array = _all(mp, "Button").filter(func(b): return (b as Button).has_meta("held_marker"))
	ok(marks.size() == 1 and String((marks[0] as Button).text) == "%s 1" % STAR
			and String((marks[0] as Button).tooltip_text).contains("held, not worn"),
		"§4: the nameplate's count is not ✦ 1 labelled 'held, not worn' (%s)" % [marks.map(func(b): return [(b as Button).text, (b as Button).tooltip_text])])
	# THE LOADOUT PANEL — IE's finding, built at IF §3: the panel is sectioned (CORE, ENABLERS, CARRIED, BENCHED,
	# `check_if` §3a), so a carried card's row is its name under CARRIED and carries no ✦.
	var m3: Dictionary = _run.party[0]
	var card := ""
	for n in Classes.offerable(Classes.draft_pool("warrior"), _run.held_engines(m3)):
		if not _run.owned_ability_names(m3).has(String(n)):
			card = String(n)
			break
	_run.hold_ability(m3, card, true)
	mp.call("_open_loadout_panel", 0)
	await Gate.frames(self, 3)
	var kit_tx: Array = _texts(Gate.overlay(mp, 60))
	ok(kit_tx.any(func(t): return String(t).begins_with("%s — " % card)) and not kit_tx.any(func(t): return String(t).contains(STAR)),
		"§4: the loadout panel's carried card is not its name, or a label on the panel carries ✦ — ✦ names a rune")
	# THE BATTLE: the Empower toggle carries no glyph; the rune chip's mark is ✦.
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"])
	var cl := _hero(s, "cleric")
	if cl != null:
		cl.second_resource = maxi(cl.second_resource, 2)
		s.call("_show_actions", cl)
		await Gate.frames(self, 2)
		var emp: Array = _all(s.get("action_box"), "Button").filter(func(bt): return String((bt as Button).text).contains("Empower"))
		ok(emp.size() == 1 and String((emp[0] as Button).text) == "Empower (C)",
			"§4: the Empower toggle reads %s" % [emp.map(func(bt): return (bt as Button).text)])
	ok(String(s.get("RUNE_CHIP_TAG")) == STAR, "§4: the rune chip's mark is %s" % s.get("RUNE_CHIP_TAG"))
	await _clear(s)


# ── §5a — THE REFILL, MEASURED ───────────────────────────────────────────────────

func _s5a_the_refill() -> void:
	print("\n§5a — an offer re-asked to nothing cannot refill")
	# THE ZONE BOSS's: the Cleric owns every card he can be offered but one his engines leave out; the stored triple
	# is three he owns. Re-asked, it is nothing — and equipping the engine that card waits on brings it into the
	# draw without bringing it into the offer.
	_new_run()
	var m: Dictionary = _run.party[2]
	var slots: Array = _run.held_engines(m)
	var gated := ""
	var gate_engine := ""
	var pool: Array = Classes.draft_pool("cleric") + Classes.spec_pool(String(m.get("spec", "")))
	for n in pool:
		var e := Classes.engine_read(String(n))
		if e != "" and not slots.has(e) and Classes.engine_class(e) == "cleric":
			gated = String(n)
			gate_engine = e
			break
	ok(gated != "", "§5a: the premise — a card of his pool gated on an engine he has not slotted")
	for n2 in pool:
		if String(n2) != gated and not _run.owned_ability_names(m).has(String(n2)):
			_run.hold_ability(m, String(n2), false)
	var owned3: Array = _run.owned_ability_names(m).filter(func(n): return pool.has(n)).slice(0, 3)
	m["bm_candidates"] = [owned3]
	m["bm_picks_owed"] = 1
	var before: Array = _run.ability_choice(m)
	var withheld_before: Array = _run.ability_choice_withheld(m)
	m["engines"] = (m.get("engines", []) as Array) + [_rune(Runes.engine_rune_id(gate_engine), true)]
	var drawable: Array = _run.roll_draft_fallback_offer(m) + _run.roll_spec_ability_offer(m)
	var after: Array = _run.ability_choice(m)
	print("    the boss's: re-asked %s (held back %s); with %s equipped the draw holds %s, the offer %s" % [
		before, withheld_before, gate_engine, drawable, after])
	ok(before.is_empty() and withheld_before.is_empty(), "§5a: the premise — the boss's offer re-asked to nothing (%s, held back %s)" % [before, withheld_before])
	ok(drawable.has(gated) and after.is_empty(),
		"§5a: the boss's offer refilled, or the engine did not open the card to the draw (draw %s, offer %s)" % [drawable, after])
	# THE MINI-BOSS's: every upgrade taken but one that fits nothing he holds; then he holds a card it fits.
	_new_run()
	var w: Dictionary = _run.party[0]
	var owned_abs: Array = []
	for n3 in _run.owned_ability_names(w):
		var ab: Ability = Classes.pool_ability(String(n3))
		if ab != null and String(n3) != "Strike":
			owned_abs.append(ab)
	var spare := ""
	var spare_card := ""
	for uid in _run.ABILITY_UPGRADES:
		if owned_abs.any(func(a): return _run.upgrade_fits(String(uid), a)):
			continue
		for n4 in Classes.offerable(Classes.draft_pool("warrior"), _run.held_engines(w)):
			var c4: Ability = Classes.pool_ability(String(n4))
			if c4 != null and not _run.owned_ability_names(w).has(String(n4)) and _run.upgrade_fits(String(uid), c4):
				spare = String(uid)
				spare_card = String(n4)
				break
		if spare != "":
			break
	ok(spare != "", "§5a: the premise — an upgrade that fits nothing he holds and fits a card he could hold")
	var taken: Array = []
	for uid2 in _run.ABILITY_UPGRADES:
		if String(uid2) != spare:
			taken.append({"id": String(uid2), "ability": "Strike"})
	w["upgrades"] = taken
	w["up_candidates"] = [[{"id": String(taken[0]["id"]), "ability": "Strike"}]]
	w["up_picks_owed"] = 1
	var u_before: Array = _run.upgrade_choice(w)
	_run.hold_ability(w, spare_card, true)
	var u_draw: Array = _run.roll_upgrade_offer(w)
	var u_after: Array = _run.upgrade_choice(w)
	print("    the mini-boss's: re-asked %s; holding %s, the draw holds %s, the offer %s" % [u_before, spare_card, u_draw, u_after])
	ok(u_before.is_empty(), "§5a: the premise — the upgrade offer re-asked to nothing (%s)" % [u_before])
	ok(u_draw.any(func(c): return String((c as Dictionary).get("id", "")) == spare) and u_after.is_empty(),
		"§5a: the upgrade offer refilled, or the new card did not open the upgrade to the draw (draw %s, offer %s)" % [u_draw, u_after])


# ── §5b — A SPENT PICK ───────────────────────────────────────────────────────────

# The Cleric owed a zone boss's pick with nothing left in it (§5a's construction, without the engine).
func _spent_boss() -> Dictionary:
	_new_run()
	var m: Dictionary = _run.party[2]
	var pool: Array = Classes.draft_pool("cleric") + Classes.spec_pool(String(m.get("spec", "")))
	for n in pool:
		if not _run.owned_ability_names(m).has(String(n)):
			_run.hold_ability(m, String(n), false)
	m["bm_candidates"] = [_run.owned_ability_names(m).filter(func(n): return pool.has(n)).slice(0, 3)]
	m["bm_picks_owed"] = 1
	_run.note_pick_earned(m, "ability")
	return m


func _s5b_a_spent_pick() -> void:
	print("\n§5b — a spent pick: its words, Let it go, the Confirm, and the ◆ gone from the card")
	var m := _spent_boss()
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var tx: Array = _texts(hd)
	var cf: Button = _confirm(mp)
	ok(hd != null and tx.has(String(mp.get("BOSS_SPENT_NOTE"))) and not tx.has("nothing to take now — the pick stays owed"),
		"§5b (boss): the screen does not say the pick is spent, in the cache's words (%s)" % [tx])
	ok(Gate.bound_buttons(hd, "_stage_spend").size() == 1 and cf != null and cf.disabled and cf.text == "One choice still to make",
		"§5b (boss): no Let it go, or the Confirm does not wait on it (%s)" % [cf.text if cf != null else "no Confirm"])
	_press(hd, "_stage_spend")
	await Gate.frames(self, 2)
	cf = _confirm(mp)
	ok(cf != null and not cf.disabled and cf.text == "Confirm the ability",
		"§5b (boss): let go, the Confirm reads '%s'" % (cf.text if cf != null else ""))
	ok(Gate.has_text(mp, "%s 1 ability" % DIAMOND), "§5b (boss): the positive arm — the card carried ◆ 1 ability while the pick was owed")
	if cf != null:
		cf.emit_signal("pressed")
	await Gate.frames(self, 4)
	ok(_run.pick_owed(m, "ability") == 0 and (m.get("bm_candidates", []) as Array).is_empty()
			and not Gate.has_text(mp, "%s 1 ability" % DIAMOND),
		"§5b (boss): the spent pick is still owed, still stored, or still marked ◆ on the card")
	# THE MINI-BOSS's, the same way.
	_new_run()
	var w: Dictionary = _run.party[0]
	var all_ups: Array = []
	for id in _run.ABILITY_UPGRADES:
		all_ups.append({"id": String(id), "ability": "Strike"})
	w["upgrades"] = all_ups
	w["up_candidates"] = [[{"id": "up_damage", "ability": "Strike"}]]
	w["up_picks_owed"] = 1
	_run.note_pick_earned(w, "upgrade")
	var mp2 := await _to_map()
	var hd2: Node = Gate.hero_draft(mp2)
	ok(hd2 != null and _texts(hd2).has(String(mp2.get("UPGRADE_SPENT_NOTE"))) and Gate.bound_buttons(hd2, "_stage_spend").size() == 1,
		"§5b (upgrade): the screen does not say the pick is spent and offer Let it go (%s)" % [_texts(hd2)])
	ok(Gate.has_text(mp2, "%s 1 upgrade" % DIAMOND), "§5b (upgrade): the positive arm — ◆ 1 upgrade while owed")
	_press(hd2, "_stage_spend")
	await Gate.frames(self, 2)
	var cf2: Button = _confirm(mp2)
	ok(cf2 != null and not cf2.disabled and cf2.text == "Confirm the upgrade", "§5b (upgrade): let go, the Confirm reads '%s'" % (cf2.text if cf2 != null else ""))
	if cf2 != null:
		cf2.emit_signal("pressed")
	await Gate.frames(self, 4)
	ok(_run.pick_owed(w, "upgrade") == 0 and not Gate.has_text(mp2, "%s 1 upgrade" % DIAMOND),
		"§5b (upgrade): the spent pick is still owed or still marked ◆")
	# THE WALKERS' HELPER lets a spent pick go through the same button.
	_spent_boss()
	var mp3 := await _to_map()
	var a: Dictionary = await Gate.answer_hero_draft(self, mp3, true)
	ok(bool(a.get("confirmed", false)) and bool(a.get("boss_let_go", false)) and _run.pick_owed(_run.party[2], "ability") == 0,
		"§5b: the walkers' helper did not let a spent boss pick go: %s" % [a])


# ── §5c — A HELD-BACK PICK STAYS OWED ────────────────────────────────────────────

func _s5c_held_back() -> void:
	print("\n§5c — a boss offer held back for an engine stays owed: no Let it go, its words, its ◆")
	_new_run()
	var h: Dictionary = _run.party[2]
	h["bm_candidates"] = [Classes.draft_pool("cleric").filter(func(n): return Classes.engine_read(String(n)) != "").slice(0, 3)]
	h["bm_picks_owed"] = 1
	for e in h.get("engines", []):
		(e as Dictionary)["equipped"] = false
	_run.note_pick_earned(h, "ability")
	var mp := await _to_map()
	var hd: Node = Gate.hero_draft(mp)
	var tx: Array = _texts(hd)
	ok(hd != null and tx.has("nothing to take now — the pick stays owed") and Gate.bound_buttons(hd, "_stage_spend").is_empty()
			and not _run.ability_choice_withheld(h).is_empty(),
		"§5c: a held-back offer was offered Let it go, or does not say it stays owed (%s)" % [tx])
	mp.call("_close_hero_draft")
	await Gate.frames(self, 2)
	ok(_run.pick_owed(h, "ability") == 1 and Gate.has_text(mp, "%s 1 ability" % DIAMOND),
		"§5c: the held-back pick is not still owed and marked ◆")


# ── §5d — THE ABILITY ────────────────────────────────────────────────────────────

func _s5d_the_ability() -> void:
	print("\n§5d — a zone boss's pick without the draft is THE ABILITY, and the other kinds join it")
	var cases := [[["boss"], "THE ABILITY"], [["boss", "rune"], "THE ABILITY AND THE CACHE"],
		[["boss", "upgrade", "rune"], "THE ABILITY, THE UPGRADE AND THE CACHE"], [["draft", "boss"], "THE DRAFT"]]
	for c in cases:
		_new_run()
		var m: Dictionary = _run.party[2]
		for k in c[0]:
			match String(k):
				"draft":
					_run.award_draft_pick(m)
				"boss":
					_run.award_ability_pick(m)
				"upgrade":
					_run.award_upgrade_pick(m)
				"rune":
					_run.queue_rune_pick(m, _run.roll_rune_candidates(m))
		var mp := await _to_map()
		var t := _title(mp)
		ok(t == "%s — %s" % [c[1], _run.nameplate(m)], "§5d %s: the title reads '%s'" % [c[0], t])
		mp.call("_shut_hero_draft")
		await Gate.frames(self, 1)


# ── §9 — THE PLAYER's FILES ──────────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
