# BATCH HF — FIFTEEN CLASS RUNES, AND THE BOAR.
#
#   §0  THE DATA — the fifteen as authored: each class-scoped, 100g, written for
#       no lineage, its text the designer's word for word, its shape the brief's
#       label, and NOT ONE an engine row; Tusk and Bristle the pet gate's row;
#       Long Poison un-gated; Mark of the Hunt a companion row with a ruled seat
#       and no Pack Bond row; Venom Coating Trapper's (HF §7)
#   §1  THE FIFTEEN, DRIVEN ON A HERO WITH NO ENGINE — every rune worn and bare,
#       on the same board under the same dice, and what it pays read off the
#       board: the Cleric's five, the Mage's five, the Warrior's three, the
#       Hunter's two — and Long Poison on a snare's Poison (HF §6)
#   §2  APER — called only with the rune; EVERY THIRD STRIKE STUNS, the rhythm
#       fixed at any Loyalty; a boss resists until Broken; a swap and a fresh
#       summon start the count over; Pack Bond's boon raises the charge; the bot
#       calls it; the chip says which charge stuns
#   §3  THE OFFERS — HC's table re-measured by name: what a hero of each class
#       holding NO engine can be offered, at spawn and at the ceiling (every class
#       at five or more); each of the fifteen reached at the Peddler, an elite
#       cache and a bargain; Tusk and Bristle withheld from the Sharpshooter
#   §4  THE TWO PAIRINGS — Vow of Silence beside Burning Ground sits it out, on
#       the one door every surface asks, in the sentence and in the battle log,
#       and the burn pays nothing; Abundance under Consecration, the shield's
#       growth a turn, measured and printed; and (§4b) the other three of GX's
#       four surfaces drawn — the pouch, the map's rune slot and the hero sheet
#   §5  MARK OF THE HUNT AND VENOM COATING AT EVERY DOOR — the zone boss's roll
#       and its answer, the seat, and what a Hunter with a pet and no Pack Bond
#       receives from the mark, driven
#   §6  THE PLAYER'S FILES
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM**: a rune worn is read beside the
# same board with it bare, and an offer that must be withheld is read beside one
# that must be made, so a door wired shut or a rune that pays nothing reads red.
# **THE GATE NEVER WRITES A RUNE'S FIELD** — every rune reaches its hero through
# the spawn, as a bought one does (GW §2: a gate that writes the state its
# assertion is about cannot fail when the door that writes it breaks).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hf.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ROLLS := 400
const ROLL_SEED := 20260922
const DMG_SEED := 5150
const SCRATCH_PROFILE := "user://hf_profile.json"
const SCRATCH_RELICS := "user://hf_relics.json"

# THE FIFTEEN AS THE DESIGNER AUTHORED THEM (HF §1-§4): id -> [class, name,
# shape, text]. The ruling's population, carried here so a rune that moved with
# no line changing here is a change nobody ruled.
const HF_RUNES := {
	"abundance": ["cleric", "Abundance", ["PASSIVE"],
		"Healing beyond an ally's missing health becomes a shield on them."],
	"returned_burden": ["cleric", "Returned Burden", ["ABILITY"],
		"Every harmful effect Unburden removes is cast onto an enemy."],
	"burning_ground": ["cleric", "Burning Ground", ["ABILITY"],
		"Consecration also deals holy damage to every enemy each turn it lasts."],
	"eleventh_hour": ["cleric", "Eleventh Hour", ["ABILITY"],
		"Ministration heals twice as much on an ally below 25% health."],
	"vow_of_silence": ["cleric", "Vow of Silence", ["PASSIVE", "TRADEOFF"],
		"His heals are 50% stronger, and he deals no damage."],
	"unravel": ["mage", "Unravel", ["ABILITY"],
		"Elemental Weakness spreads to every enemy, not just the target."],
	"seeking_missiles": ["mage", "Seeking Missiles", ["ABILITY"],
		"One extra missile for each enemy under Elemental Weakness."],
	"detonating_ward": ["mage", "Detonating Ward", ["ABILITY"],
		"When it breaks or ends, it deals the damage it absorbed to every enemy."],
	"clarity": ["mage", "Clarity", ["PASSIVE"],
		"A spell cast at full Mana deals 50% more damage."],
	"profligate": ["mage", "Profligate", ["PASSIVE", "TRADEOFF"],
		"His spells deal 40% more damage and cost twice the Mana."],
	"goading_roar": ["warrior", "Goading Roar", ["ABILITY"],
		"Taunted enemies deal 25% less damage while they must attack him."],
	"rending_blows": ["warrior", "Rending Blows", ["ABILITY"],
		"Sunder stacks — each Crushing Blow on an already-Sundered enemy deepens it, up to three times."],
	"grudge": ["warrior", "Grudge", ["PASSIVE", "TRADEOFF"],
		"He deals 40% more damage to the last enemy that struck him, and 20% less to every other."],
	"opportunist": ["hunter", "Opportunist", ["ABILITY"],
		"Powershot deals double damage to a stunned enemy."],
	"tusk_and_bristle": ["hunter", "Tusk and Bristle", ["ABILITY"],
		"Adds a fourth choice to Summon Companion: Aper, the boar."],
}
# HC's no-engine reading after HE gated the six status runes (HE §1c): the
# floor each class stood at before these fifteen, at spawn.
const HE_SPAWN := {"warrior": 2, "mage": 0, "cleric": 0, "hunter": 4}
const MOTH := "Mark of the Hunt"
const VENOM := "Venom Coating"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HF — FIFTEEN CLASS RUNES, AND THE BOAR")
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
	var marks := PackedStringArray()
	var ts := Time.get_ticks_msec()
	_s0_the_data()
	marks.append("§0 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s1_the_fifteen()
	marks.append("§1 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s2_aper()
	marks.append("§2 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s3_the_offers()
	marks.append("§3 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s4_the_pairings()
	await _s4b_the_screens()
	marks.append("§4 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s5_mark_and_venom()
	marks.append("§5 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	_s6_the_players_files()
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


# A rune as the pouch holds one, worn.
func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


# An engine rune as the pouch holds one — built by the game, slotted or not.
func _eng(pid: String, on := true) -> Dictionary:
	var r: Dictionary = Runes.build(Runes.engine_rune_id(pid))
	r["equipped"] = on
	return r


# A hero as a run holds one after class selection: awakened, of `lineage` (or
# none), holding the engine runes given, with nothing earned and nothing worn.
func _member(cls: String, lineage: String, engines: Array) -> Dictionary:
	return {"key": cls, "spec": lineage, "awakened": true, "bm_abilities": [],
		"bm_equipped": [], "talents": {}, "tree": [], "engines": engines, "runes": [],
		"draft_candidates": [], "draft_picks_owed": 0, "draft_refused": [],
		"rune_candidates": [], "rune_picks_owed": 0,
		"bm_candidates": [], "bm_picks_owed": 0}


# Every name `roll` handed over across ROLLS rolls, counted, off one laid seed.
func _tally(member: Dictionary, roll: Callable) -> Dictionary:
	seed(ROLL_SEED)
	var seen := {}
	for _i in ROLLS:
		for c in roll.call(member):
			var n := String((c as Dictionary).get("id", "")) if c is Dictionary else String(c)
			if n != "":
				seen[n] = int(seen.get(n, 0)) + 1
	return seen


# A fight with the four heroes seated by `specs` (no lineage by default, and so
# no engine), each seat wearing the runes named in `runes` and taking what `over`
# gives it. The deterministic fixture: no miss, no block, no parry, no crit.
# It builds the PARTY and nothing else: the battle comes from `Gate.spawn`, the
# one fixture (DB §1), which is why this is not named `_spawn`.
func _fight(runes: Dictionary, over: Dictionary = {}, specs: Array = ["", "", "", ""]) -> Node:
	var party := {}
	for seat in 4:
		var row := {"runes": []}
		for id in runes.get(seat, []):
			(row["runes"] as Array).append(_rune(String(id)))
		for k in over.get(seat, {}):
			row[k] = over[seat][k]
		party[seat] = row
	var s: Node = await Gate.spawn(self, specs, {"party": party, "deterministic": true})
	return s


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _ab(s: Node, u: BattleUnit, n: String) -> Ability:
	return s._find_ability(u, n)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not e.dead)


# Every enemy made too sturdy to fall to what an arm drives, so a board read after
# several blows is still a board of three.
func _sturdy(s: Node) -> void:
	for e in s.get("enemies"):
		e.max_hp = 9999
		e.hp = 9999


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


# What `u`'s cast of `ab` on `target` took off `target`'s health, under a laid
# seed — so the same cast on the same board, worn and bare, draws the same dice.
func _cast_dmg(s: Node, u: BattleUnit, ab: Ability, target: BattleUnit, sd: int) -> int:
	var before := target.hp
	seed(sd)
	await s._resolve(u, ab, target, "good")
	return before - target.hp


func _hps(s: Node) -> Array:
	return (s.get("enemies") as Array).map(func(e): return int(e.hp))


func _labels(n: Node, out: Array) -> void:
	if n == null or n.is_queued_for_deletion():
		return
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _buttons(n: Node, out: Array) -> void:
	if n == null or n.is_queued_for_deletion():
		return
	if n is Button:
		out.append(n)
	for c in n.get_children():
		_buttons(c, out)


# A party of four on the map, every seat awakened with no lineage, nothing slotted
# and nothing worn.
func _seat_party() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
		_run.party[i]["runes"] = []
	_run.specs_chosen = true
	_run.active = true


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and (c as Control).z_index >= 60 and not c.is_queued_for_deletion():
			c.queue_free()


# ── §0 — THE DATA ────────────────────────────────────────────────────────────

func _s0_the_data() -> void:
	print("\n§0 — the fifteen as authored, and the rows HF moves")
	var shapes_ok := 0
	for id in HF_RUNES:
		var want: Array = HF_RUNES[id]
		var e: Dictionary = Runes.config(String(id))
		ok(not e.is_empty() and not Runes.is_retired(String(id)) and not Runes.is_engine_rune(String(id)),
			"§0: %s is not a live ordinary rune in `data/runes.json`" % id)
		ok(String(e.get("name", "")) == String(want[1]) and String(e.get("desc", "")) == String(want[3]),
			"§0: %s reads '%s' — '%s', not the designer's words" % [id, e.get("name", ""), e.get("desc", "")])
		ok(String(e.get("scope", "")) == "class:" + String(want[0]) and int(e.get("price", 0)) == 100,
			"§0: %s is scoped %s at %dg — it is the %s's, at the flat 100g" % [
				id, e.get("scope", ""), int(e.get("price", 0)), want[0]])
		ok(not e.has("written_for") and String(e.get("requires_ability", "")) == "",
			"§0: %s claims a lineage or a card (%s / %s) — it was written for the class and reads its kit" % [
				id, e.get("written_for", ""), e.get("requires_ability", "")])
		if Runes.rune_shape(String(id)) == want[2]:
			shapes_ok += 1
		ok(Runes.rune_shape(String(id)) == want[2],
			"§0: %s is shaped %s — the brief labels it %s" % [id, Runes.rune_shape(String(id)), want[2]])
		ok(not Runes.rune_tags(String(id)).is_empty(), "§0: %s carries no archetype tag (EK §1)" % id)
		# THE RUNE THIS BATCH EXISTS TO AVOID: one that reads an engine it did not name.
		ok(Runes.engine_read(String(id)) == "",
			"§0: %s is an engine row (`%s`) — the fifteen read no engine" % [id, Runes.engine_read(String(id))])
	print("    %d of %d shaped as labelled; none an engine row" % [shapes_ok, HF_RUNES.size()])
	# THE PET GATE: Tusk and Bristle needs a companion, and nothing else of the fifteen does.
	for id2 in HF_RUNES:
		ok(Runes.reads_companion(String(id2)) == (String(id2) == "tusk_and_bristle"),
			"§0: %s %s a `COMPANION_READ` row" % [id2, "is" if Runes.reads_companion(String(id2)) else "is not"])
	# THE CANCELLING PAIR (HF §5), one row.
	ok(Runes.CANCELLED_BY == {"burning_ground": "vow_of_silence"},
		"§0: the cancelling pairs are %s — HF §5 names one" % str(Runes.CANCELLED_BY))
	# LONG POISON, UN-GATED (HF §6): no row, and its read site asks no engine.
	ok(Runes.engine_read("long_poison") == "" and not Runes.ENGINE_READ.has("long_poison"),
		"§0: Long Poison is still an engine row (`%s`) — Snare Trap lays its Poison in every Hunter's kit" % Runes.engine_read("long_poison"))
	var battle_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(battle_src.contains("elif src.rune_long_poison > 0:")
		and not battle_src.contains("src.rune_long_poison > 0 and src.has_engine"),
		"§0: `_apply_poison` still asks an engine before Long Poison stops the clock")
	ok(battle_src.contains("_apply_poison(heroes[sn_idx], u, 4)"),
		"§0: the snare's spring no longer lays its Poison through `_apply_poison` with the Hunter as its source — Long Poison's premise")
	var ruled_r: Array = []
	for rid in Runes.ENGINE_READ:
		if Runes.engine_read_ruled(String(rid)) != "":
			ruled_r.append(String(rid))
	ruled_r.sort()
	ok(ruled_r == ["bared_plate", "deep_cold", "killing_cold_fk", "long_fuse", "mirror_guard", "slaughterhouse_rune"],
		"§0: the ruled rune rows are %s — HE's seven less Long Poison" % str(ruled_r))
	# MARK OF THE HUNT (HF §7): no Pack Bond row at the offer or the seat; the pet
	# gate's row, whose door opens, with a ruled seat beside a dismisser.
	ok(Classes.engine_read(MOTH) == "" and not Classes.ENGINE_READ.has(MOTH),
		"§0: Mark of the Hunt is still a card-gate row (`%s`) — HF §7 undid HE's gate" % Classes.engine_read(MOTH))
	ok(not Classes.SITS_OUT.has(MOTH),
		"§0: Mark of the Hunt still sits out without Pack Bond (`%s`)" % Classes.sits_out_engine(MOTH))
	ok(Classes.reads_companion(MOTH) and not Classes.companion_door(MOTH) and Classes.companion_seat(MOTH)
		and Classes.companion_read_ruled(MOTH) == "HF §7",
		"§0: Mark of the Hunt's companion row reads door %s, seat %s, ruled '%s' — its door opens, and it sits out beside a dismisser by ruling" % [
			Classes.companion_door(MOTH), Classes.companion_seat(MOTH), Classes.companion_read_ruled(MOTH)])
	var seats: Array = Classes.COMPANION_READ.keys().filter(
		func(c): return Classes.companion_seat(String(c)) and not Classes.companion_door(String(c)))
	ok(seats == [MOTH], "§0: the rows that sit out though their door opens are %s — HF §7 rules one" % str(seats))
	# VENOM COATING (HF §7): Trapper's, by ruling.
	ok(Classes.engine_read(VENOM) == "trapper" and Classes.engine_read_ruled(VENOM) == "HF §7",
		"§0: Venom Coating reads `%s` ruled '%s' — HF §7 rules it Trapper's" % [
			Classes.engine_read(VENOM), Classes.engine_read_ruled(VENOM)])
	var ruled_c: Array = []
	for card in Classes.ENGINE_READ:
		if Classes.engine_read_ruled(String(card)) != "":
			ruled_c.append(String(card))
	ruled_c.sort()
	ok(ruled_c == ["Guard Change", "Lunge", VENOM],
		"§0: the ruled card rows are %s — HD's two and HF's one" % str(ruled_c))
	# APER: a call defined beside the three, a fourth kind the rune adds, and the
	# three every Hunter's card offers untouched.
	ok(Classes.COMPANION_KINDS == ["ursus", "canis", "aguila"] and Classes.RUNE_COMPANION_KINDS == ["aper"],
		"§0: the companion kinds are %s and %s — the three, and the one Tusk and Bristle adds" % [
			Classes.COMPANION_KINDS, Classes.RUNE_COMPANION_KINDS])
	var call: Ability = Classes.companion_call("aper")
	ok(call != null and call.special == "summon" and call.display_name == "Summon Aper",
		"§0: Aper has no call of its own beside the three (`companion_call`)")
	ok(Classes.card_tags("Summon Aper") != [], "§0: Summon Aper carries no archetype tag")
	var in_pools := false
	for key in SEATS:
		if Classes.draft_pool(String(key)).has("Summon Aper") or Classes.class_kit_names(String(key)).has("Summon Aper"):
			in_pools = true
	for spec in Classes.SPEC_POOLS:
		if (Classes.SPEC_POOLS[spec] as Array).has("Summon Aper"):
			in_pools = true
	ok(not in_pools, "§0: Summon Aper is in a kit or a pool — the rune is its only door")
	# THE FIELDS ARE FLOATS, OFF THE INT LIST.
	var unit_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var fields := ["rune_abundance", "rune_returned_burden", "rune_burning_ground", "rune_eleventh_hour",
		"rune_vow_of_silence", "rune_unravel", "rune_seeking_missiles", "rune_detonating_ward",
		"rune_clarity", "rune_profligate", "rune_goading_roar", "rune_rending_blows",
		"rune_grudge_struck", "rune_grudge_rest", "rune_opportunist_shot", "rune_tusk_and_bristle"]
	for f in fields:
		ok(unit_src.contains("var %s := 0.0" % f) and not Runes.STAT_INT_KEYS.has(f),
			"§0: `BattleUnit.%s` is not a float off `STAT_INT_KEYS`" % f)
	# GRUDGE'S COST IS A REAL TERM: `is_cost` reads it.
	var gr_stat: Dictionary = ((Runes.config("grudge").get("payload", {}) as Dictionary).get("stat", {}) as Dictionary)
	ok(Runes.is_cost("rune_grudge_rest", float(gr_stat.get("rune_grudge_rest", 0.0)))
		and not Runes.is_cost("rune_grudge_struck", float(gr_stat.get("rune_grudge_struck", 0.0))),
		"§0: Grudge's payload is %s — its -20%% is the cost term and its +40%% is not" % str(gr_stat))


# ── §1 — THE FIFTEEN, DRIVEN ON A HERO WITH NO ENGINE ───────────────────────

func _s1_the_fifteen() -> void:
	print("\n§1 — every rune worn and bare, on a party holding no engine")
	await _cleric_five()
	await _mage_five()
	await _warrior_three()
	await _hunter_two()


func _cleric_five() -> void:
	# ── ELEVENTH HOUR: twice the heal below a quarter health, the same above it.
	# **THE PROBE ABOVE THE LINE SITS JUST ABOVE IT** (27%): a probe at half health
	# passed a threshold moved to half (the control that found it), because 50% is
	# not below 50%; just above a quarter pins the line from the side it can drift.
	var heals := {}
	for arm in [["worn", ["eleventh_hour"]], ["bare", []]]:
		var s: Node = await _fight({2: arm[1]})
		var c := _hero(s, "cleric")
		var w := _hero(s, "warrior")
		var got := []
		for frac in [0.20, 0.27]:
			w.hp = int(w.max_hp * frac)
			var was := w.hp
			seed(DMG_SEED)
			await s._resolve(c, _ab(s, c, "Ministration"), w, "good")
			got.append(w.hp - was)
		heals[arm[0]] = got
		await _clear(s)
	ok(int(heals["worn"][0]) >= 2 * int(heals["bare"][0]) - 1 and int(heals["worn"][0]) <= 2 * int(heals["bare"][0]) + 1,
		"§1 Eleventh Hour: below a quarter health Ministration healed %d worn against %d bare — twice" % [heals["worn"][0], heals["bare"][0]])
	ok(int(heals["worn"][1]) == int(heals["bare"][1]) and int(heals["bare"][1]) > 0,
		"§1 Eleventh Hour: at 27%% health, just above a quarter, Ministration healed %d worn against %d bare — the same" % [heals["worn"][1], heals["bare"][1]])
	print("    Eleventh Hour: Ministration at 20%% health %d worn / %d bare; at 27%% %d / %d" % [
		heals["worn"][0], heals["bare"][0], heals["worn"][1], heals["bare"][1]])
	# ── VOW OF SILENCE: Smite deals nothing and still Breaks; heals 50% stronger,
	# the Consecration drip included; a tick booked to him deals nothing.
	var v := {}
	for arm2 in [["worn", ["vow_of_silence"]], ["bare", []]]:
		var s2: Node = await _fight({2: arm2[1]})
		_sturdy(s2)
		var c2 := _hero(s2, "cleric")
		var e0: BattleUnit = _foes(s2)[0]
		var p_was := e0.pressure
		var dmg: int = await _cast_dmg(s2, c2, c2.abilities[0], e0, DMG_SEED)
		var bd := e0.pressure - p_was
		var w2 := _hero(s2, "warrior")
		w2.hp = int(w2.max_hp * 0.5)
		var w_was := w2.hp
		seed(DMG_SEED)
		await s2._resolve(c2, _ab(s2, c2, "Ministration"), w2, "good")
		var mn := w2.hp - w_was
		await s2._resolve(c2, _ab(s2, c2, "Consecration"), c2, "good")
		var h2 := _hero(s2, "hunter")
		h2.hp = int(h2.max_hp * 0.5)
		var h_was := h2.hp
		s2._consecration_tick(h2)
		var drip := h2.hp - h_was
		var e1: BattleUnit = _foes(s2)[1]
		var e1_was := e1.hp
		s2._dmg_frame(null, "Poison", c2.unit_name)
		e1.take_tick_damage(12, "-12 Poison", Color.WHITE)
		v[arm2[0]] = {"smite": dmg, "bd": bd, "mn": mn, "drip": drip, "tick": e1_was - e1.hp,
			"mn_want": maxi(int(round(w2.max_hp * 0.20 * (1.5 if arm2[0] == "worn" else 1.0))), 1),
			"drip_want": maxi(int(round(h2.max_hp * 0.05 * (1.5 if arm2[0] == "worn" else 1.0))), 1)}
		await _clear(s2)
	ok(int(v["worn"]["smite"]) == 0 and int(v["bare"]["smite"]) > 0,
		"§1 Vow of Silence: Smite dealt %d worn against %d bare — he deals no damage" % [v["worn"]["smite"], v["bare"]["smite"]])
	ok(int(v["worn"]["bd"]) > 0 and int(v["worn"]["bd"]) == int(v["bare"]["bd"]),
		"§1 Vow of Silence: Smite's Break damage read %d worn against %d bare — Break damage is its own word and still lands" % [v["worn"]["bd"], v["bare"]["bd"]])
	ok(int(v["worn"]["mn"]) == int(v["worn"]["mn_want"]) and int(v["bare"]["mn"]) == int(v["bare"]["mn_want"]),
		"§1 Vow of Silence: Ministration healed %d worn (want %d) and %d bare (want %d) — 50%% stronger" % [
			v["worn"]["mn"], v["worn"]["mn_want"], v["bare"]["mn"], v["bare"]["mn_want"]])
	ok(int(v["worn"]["drip"]) == int(v["worn"]["drip_want"]) and int(v["bare"]["drip"]) == int(v["bare"]["drip_want"]),
		"§1 Vow of Silence: the Consecration drip healed %d worn (want %d) and %d bare (want %d)" % [
			v["worn"]["drip"], v["worn"]["drip_want"], v["bare"]["drip"], v["bare"]["drip_want"]])
	ok(int(v["worn"]["tick"]) == 0 and int(v["bare"]["tick"]) == 12,
		"§1 Vow of Silence: a tick booked to him took %d worn against %d bare — nothing he deals lands" % [v["worn"]["tick"], v["bare"]["tick"]])
	print("    Vow of Silence: Smite %d / %d (BD %d / %d); Ministration %d / %d; drip %d / %d; his tick %d / %d" % [
		v["worn"]["smite"], v["bare"]["smite"], v["worn"]["bd"], v["bare"]["bd"], v["worn"]["mn"], v["bare"]["mn"],
		v["worn"]["drip"], v["bare"]["drip"], v["worn"]["tick"], v["bare"]["tick"]])
	# ── ABUNDANCE: the overheal becomes a shield, and the shield ADDS.
	var ab := {}
	for arm3 in [["worn", ["abundance"]], ["bare", []]]:
		var s3: Node = await _fight({2: arm3[1]})
		var c3 := _hero(s3, "cleric")
		var w3 := _hero(s3, "warrior")
		w3.hp = w3.max_hp
		seed(DMG_SEED)
		await s3._resolve(c3, _ab(s3, c3, "Ministration"), w3, "good")
		var after_mn := maxi(w3.status_power("barrier"), 0)
		var mn_spill := int(w3.last_overheal)
		await s3._resolve(c3, _ab(s3, c3, "Consecration"), c3, "good")
		var h3 := _hero(s3, "hunter")
		h3.hp = h3.max_hp
		# The spill each drip leaves, read off the heal itself (`last_overheal`).
		var drip := 0
		var steps := []
		for _t in 3:
			s3._consecration_tick(h3)
			drip = int(h3.last_overheal)
			steps.append(maxi(h3.status_power("barrier"), 0))
		# A damaged ally is healed, not shielded: nothing spilled, nothing added.
		var m3 := _hero(s3, "mage")
		m3.hp = int(m3.max_hp * 0.5)
		s3._consecration_tick(m3)
		ab[arm3[0]] = {"mn": after_mn, "spill": mn_spill, "steps": steps, "drip": drip,
			"hurt": maxi(m3.status_power("barrier"), 0)}
		await _clear(s3)
	ok(int(ab["worn"]["mn"]) == int(ab["worn"]["spill"]) and int(ab["worn"]["spill"]) > 0 and int(ab["bare"]["mn"]) == 0,
		"§1 Abundance: Ministration on a full ally left a shield of %d worn (spill %d) and %d bare" % [
			ab["worn"]["mn"], ab["worn"]["spill"], ab["bare"]["mn"]])
	var d := int(ab["worn"]["drip"])
	ok(d > 0 and ab["worn"]["steps"] == [d, 2 * d, 3 * d] and ab["bare"]["steps"] == [0, 0, 0],
		"§1 Abundance: three drips on a full hero left shields %s worn and %s bare — each spill ADDS %d" % [
			ab["worn"]["steps"], ab["bare"]["steps"], d])
	ok(int(ab["worn"]["hurt"]) == 0, "§1 Abundance: a drip on a hurt ally shielded %d — nothing spilled" % ab["worn"]["hurt"])
	print("    Abundance: Ministration's spill %d -> shield %d; three drips %s (bare %s)" % [
		ab["worn"]["spill"], ab["worn"]["mn"], ab["worn"]["steps"], ab["bare"]["steps"]])
	# ── RETURNED BURDEN: what Unburden lifts goes back to whoever laid it.
	var rb := {}
	for arm4 in [["worn", ["returned_burden"]], ["bare", []]]:
		var s4: Node = await _fight({2: arm4[1]})
		var c4 := _hero(s4, "cleric")
		var h4 := _hero(s4, "hunter")
		var fs: Array = s4.get("enemies")
		var archer: BattleUnit = null
		for e in fs:
			if String(e.unit_name).contains("Archer"):
				archer = e
		var raider: BattleUnit = fs[0]
		s4._apply_status(h4, "blind", 3, 0, 0, archer)
		s4._apply_status(h4, "cripple", 3, 0, 0, raider)
		s4._apply_status(h4, "hexed", -1)
		seed(DMG_SEED)
		await s4._resolve(c4, _ab(s4, c4, "Unburden"), h4, "good")
		var hexed_n := fs.filter(func(e): return e.has_status("hexed")).size()
		rb[arm4[0]] = {"clean": h4.count_debuffs(), "archer_blind": archer.has_status("blind"),
			"raider_cripple": raider.has_status("cripple"), "hexed": hexed_n,
			"archer_blind_src": String(archer.get_status("blind").get("src_name", "")),
			"cleric": c4.unit_name}
		await _clear(s4)
	ok(int(rb["worn"]["clean"]) == 0 and int(rb["bare"]["clean"]) == 0,
		"§1 Returned Burden: the ally still carries %d / %d harmful effects — the cleanse is unchanged" % [rb["worn"]["clean"], rb["bare"]["clean"]])
	ok(bool(rb["worn"]["archer_blind"]) and bool(rb["worn"]["raider_cripple"]),
		"§1 Returned Burden: the Blind the archer laid went back to it (%s) and the Cripple the raider laid to it (%s)" % [
			rb["worn"]["archer_blind"], rb["worn"]["raider_cripple"]])
	ok(int(rb["worn"]["hexed"]) == 1, "§1 Returned Burden: an effect with no applier landed on %d enemies — on one, at random" % rb["worn"]["hexed"])
	ok(not bool(rb["bare"]["archer_blind"]) and not bool(rb["bare"]["raider_cripple"]) and int(rb["bare"]["hexed"]) == 0,
		"§1 Returned Burden: bare, the lifted effects landed on an enemy anyway")
	ok(String(rb["worn"]["archer_blind_src"]) == String(rb["worn"]["cleric"]),
		"§1 Returned Burden: the returned Blind is booked to '%s' — it is the Cleric's cast now" % rb["worn"]["archer_blind_src"])
	print("    Returned Burden: worn — archer Blind %s, raider Cripple %s, no-applier Hex on %d; bare — none" % [
		rb["worn"]["archer_blind"], rb["worn"]["raider_cripple"], rb["worn"]["hexed"]])
	# ── BURNING GROUND: the ground burns every enemy on the caster's turns.
	var bg := {}
	for arm5 in [["worn", ["burning_ground"]], ["bare", []]]:
		var s5: Node = await _fight({2: arm5[1]})
		var c5 := _hero(s5, "cleric")
		await s5._resolve(c5, _ab(s5, c5, "Consecration"), c5, "good")
		var was5 := _hps(s5)
		s5._burning_ground_tick(_hero(s5, "warrior"))
		var after_other := _hps(s5)
		s5._burning_ground_tick(c5)
		var after_own := _hps(s5)
		var want := []
		for e5 in s5.get("enemies"):
			want.append(maxi(int(round(c5.max_hp * 0.05 * (1.0 - float(e5.resists.get("holy", 0.0))))), 1))
		var took := []
		for i in was5.size():
			took.append(int(was5[i]) - int(after_own[i]))
		bg[arm5[0]] = {"other": after_other == was5, "took": took, "want": want}
		await _clear(s5)
	ok(bg["worn"]["took"] == bg["worn"]["want"],
		"§1 Burning Ground: the caster's turn burned %s — 5%% of his maximum health, less holy resistance, to every enemy (%s)" % [
			bg["worn"]["took"], bg["worn"]["want"]])
	ok(bool(bg["worn"]["other"]), "§1 Burning Ground: another hero's turn burned the enemies — it is the caster's turn that burns")
	ok(bg["bare"]["took"] == [0, 0, 0], "§1 Burning Ground: bare, Consecration burned %s" % [bg["bare"]["took"]])
	print("    Burning Ground: one caster turn burns %s (bare %s)" % [bg["worn"]["took"], bg["bare"]["took"]])


func _mage_five() -> void:
	# ── UNRAVEL: Magic Burst's weakness on every enemy.
	var ur := {}
	for arm in [["worn", ["unravel"]], ["bare", []]]:
		var s: Node = await _fight({1: arm[1]})
		_sturdy(s)
		var m := _hero(s, "mage")
		var fs: Array = s.get("enemies")
		seed(DMG_SEED)
		await s._resolve(m, _ab(s, m, "Magic Burst"), fs[0], "good")
		ur[arm[0]] = fs.map(func(e): return e.has_status("elem_weak"))
		await _clear(s)
	ok(ur["worn"] == [true, true, true] and ur["bare"] == [true, false, false],
		"§1 Unravel: Magic Burst left Elemental Weakness on %s worn and %s bare" % [ur["worn"], ur["bare"]])
	print("    Unravel: weakened %s worn, %s bare" % [ur["worn"], ur["bare"]])
	# ── SEEKING MISSILES: one more missile a weakened enemy, each to its own.
	var sm := {}
	for arm2 in [["worn", ["seeking_missiles"]], ["bare", []]]:
		var s2: Node = await _fight({1: arm2[1]})
		_sturdy(s2)
		var m2 := _hero(s2, "mage")
		var fs2: Array = s2.get("enemies")
		for e in fs2:
			s2._apply_elem_weak(e, 15, 3, m2)
		var was := _hps(s2)
		seed(DMG_SEED)
		await s2._resolve(m2, _ab(s2, m2, "Magic Missiles"), fs2[0], "good")
		var now := _hps(s2)
		sm[arm2[0]] = [int(was[0]) - int(now[0]), int(was[1]) - int(now[1]), int(was[2]) - int(now[2])]
		await _clear(s2)
	ok(int(sm["worn"][1]) > 0 and int(sm["worn"][2]) > 0 and int(sm["bare"][1]) == 0 and int(sm["bare"][2]) == 0,
		"§1 Seeking Missiles: the two other weakened enemies took %s worn and %s bare — a missile each, spread" % [
			sm["worn"].slice(1), sm["bare"].slice(1)])
	ok(int(sm["worn"][0]) > int(sm["bare"][0]),
		"§1 Seeking Missiles: the weakened target took %d worn against %d bare — its own seeker on top of the three" % [sm["worn"][0], sm["bare"][0]])
	print("    Seeking Missiles: damage %s worn, %s bare (target, then the other two)" % [sm["worn"], sm["bare"]])
	# ── DETONATING WARD: what the ward absorbed, to every enemy, when it breaks — and when it ends.
	var dw := {}
	for arm3 in [["worn", ["detonating_ward"]], ["bare", []]]:
		var s3: Node = await _fight({1: arm3[1]})
		_sturdy(s3)
		var m3 := _hero(s3, "mage")
		m3.max_hp = 999
		m3.hp = 999
		var fs3: Array = s3.get("enemies")
		await s3._resolve(m3, _ab(s3, m3, "Nexus Ward"), m3, "good")
		var power := maxi(m3.status_power("barrier"), 0)
		var armed := m3.ward_det_armed
		var was3 := _hps(s3)
		# BREAKS: an enemy blow bigger than the ward.
		s3._dmg_frame(fs3[1], "Slash")
		m3.take_hit(power + 50, 0)
		var broke := _hps(s3)
		var took_break := []
		for i in was3.size():
			took_break.append(int(was3[i]) - int(broke[i]))
		# ENDS: a fresh ward eats a little, then its clock runs out.
		await s3._resolve(m3, _ab(s3, m3, "Nexus Ward"), m3, "good")
		s3._dmg_frame(fs3[1], "Slash")
		m3.take_hit(7, 0)
		for st in m3.statuses:
			if st.id == "barrier":
				st.turns = 1
		var was_end := _hps(s3)
		m3.tick_statuses()
		var ended := _hps(s3)
		var took_end := []
		for j in was_end.size():
			took_end.append(int(was_end[j]) - int(ended[j]))
		dw[arm3[0]] = {"armed": armed, "power": power, "break": took_break, "end": took_end,
			"gone": not m3.has_status("barrier")}
		await _clear(s3)
	var pw := int(dw["worn"]["power"])
	ok(bool(dw["worn"]["armed"]) and not bool(dw["bare"]["armed"]),
		"§1 Detonating Ward: Nexus Ward armed the ward %s worn, %s bare" % [dw["worn"]["armed"], dw["bare"]["armed"]])
	ok(dw["worn"]["break"] == [pw, pw, pw] and dw["bare"]["break"] == [0, 0, 0],
		"§1 Detonating Ward: the ward BROKE having absorbed %d and dealt %s worn, %s bare" % [pw, dw["worn"]["break"], dw["bare"]["break"]])
	ok(dw["worn"]["end"] == [7, 7, 7] and dw["bare"]["end"] == [0, 0, 0] and bool(dw["worn"]["gone"]),
		"§1 Detonating Ward: the ward ENDED having absorbed 7 and dealt %s worn, %s bare" % [dw["worn"]["end"], dw["bare"]["end"]])
	print("    Detonating Ward: breaks at %d -> %s; ends at 7 -> %s (bare %s / %s)" % [
		pw, dw["worn"]["break"], dw["worn"]["end"], dw["bare"]["break"], dw["bare"]["end"]])
	# ── CLARITY AND PROFLIGATE: a spell is a cast with a Mana price; Clarity reads
	# the bar before the price comes off; Profligate doubles the price.
	var sp := {}
	for arm4 in [["bare", []], ["clarity", ["clarity"]], ["profligate", ["profligate"]]]:
		for full in [true, false]:
			var s4: Node = await _fight({1: arm4[1]})
			_sturdy(s4)
			var m4 := _hero(s4, "mage")
			m4.resource = m4.max_resource if full else m4.max_resource - 1
			var res_was := m4.resource
			var dmg: int = await _cast_dmg(s4, m4, _ab(s4, m4, "Magic Burst"), _foes(s4)[0], DMG_SEED)
			var spent := res_was - m4.resource
			m4.resource = m4.max_resource
			var bolt: int = await _cast_dmg(s4, m4, m4.abilities[0], _foes(s4)[1], DMG_SEED)
			sp["%s/%s" % [arm4[0], "full" if full else "short"]] = [dmg, spent, bolt]
			await _clear(s4)
	var b0 := int(sp["bare/full"][0])
	ok(absi(int(sp["clarity/full"][0]) - int(round(b0 * 1.5))) <= 1,
		"§1 Clarity: a spell cast at full Mana dealt %d against %d bare — 50%% more" % [sp["clarity/full"][0], b0])
	ok(int(sp["clarity/short"][0]) == int(sp["bare/short"][0]),
		"§1 Clarity: a spell cast one short of full dealt %d against %d bare — the bar must be full" % [sp["clarity/short"][0], sp["bare/short"][0]])
	ok(int(sp["clarity/full"][2]) == int(sp["bare/full"][2]),
		"§1 Clarity: Magic Bolt at full Mana dealt %d against %d bare — a free cast is not a spell" % [sp["clarity/full"][2], sp["bare/full"][2]])
	ok(absi(int(sp["profligate/full"][0]) - int(round(b0 * 1.4))) <= 1 and int(sp["profligate/full"][1]) == 2 * int(sp["bare/full"][1]),
		"§1 Profligate: Magic Burst dealt %d for %d Mana against %d for %d bare — 40%% more for twice the Mana" % [
			sp["profligate/full"][0], sp["profligate/full"][1], b0, sp["bare/full"][1]])
	ok(int(sp["profligate/full"][2]) == int(sp["bare/full"][2]),
		"§1 Profligate: Magic Bolt dealt %d against %d bare — the free basic is not one of his spells" % [sp["profligate/full"][2], sp["bare/full"][2]])
	print("    Clarity / Profligate: Magic Burst full %d / %d / %d (bare / Clarity / Profligate), short %d / %d; Mana %d / %d; Magic Bolt %d / %d / %d" % [
		b0, sp["clarity/full"][0], sp["profligate/full"][0], sp["bare/short"][0], sp["clarity/short"][0],
		sp["bare/full"][1], sp["profligate/full"][1], sp["bare/full"][2], sp["clarity/full"][2], sp["profligate/full"][2]])


func _warrior_three() -> void:
	# ── GOADING ROAR: an enemy his taunt binds deals 25% less.
	var gr := {}
	for arm in [["worn", ["goading_roar"]], ["bare", []]]:
		var s: Node = await _fight({0: arm[1]})
		_sturdy(s)
		var w := _hero(s, "warrior")
		w.max_hp = 9999
		w.hp = 9999
		var fs: Array = s.get("enemies")
		var free_hit: int = await _cast_dmg(s, fs[2], (fs[2] as BattleUnit).abilities[0], w, DMG_SEED)
		seed(DMG_SEED)
		await s._resolve(w, _ab(s, w, "Mocking Blow"), fs[2], "good")
		var bound := int((fs[2] as BattleUnit).status_power("mocked")) == (s.get("heroes") as Array).find(w)
		var taunted_hit: int = await _cast_dmg(s, fs[2], (fs[2] as BattleUnit).abilities[0], w, DMG_SEED)
		gr[arm[0]] = {"free": free_hit, "taunted": taunted_hit, "bound": bound}
		await _clear(s)
	ok(bool(gr["worn"]["bound"]) and bool(gr["bare"]["bound"]), "§1 Goading Roar: Mocking Blow did not bind the enemy to him")
	ok(absi(int(gr["worn"]["taunted"]) - int(round(int(gr["bare"]["taunted"]) * 0.75))) <= 1 and int(gr["bare"]["taunted"]) > 0,
		"§1 Goading Roar: the taunted enemy's blow dealt %d worn against %d bare — 25%% less" % [gr["worn"]["taunted"], gr["bare"]["taunted"]])
	ok(int(gr["worn"]["free"]) == int(gr["bare"]["free"]),
		"§1 Goading Roar: before the taunt the blow dealt %d worn against %d bare — it is the bind that cuts" % [gr["worn"]["free"], gr["bare"]["free"]])
	print("    Goading Roar: a taunted blow %d worn / %d bare; untaunted %d / %d" % [
		gr["worn"]["taunted"], gr["bare"]["taunted"], gr["worn"]["free"], gr["bare"]["free"]])
	# ── RENDING BLOWS: Sunder deepens to three, and three is no armor at all.
	var rd := {}
	for arm2 in [["worn", ["rending_blows"]], ["bare", []]]:
		var s2: Node = await _fight({0: arm2[1]})
		_sturdy(s2)
		var w2 := _hero(s2, "warrior")
		var e: BattleUnit = _foes(s2)[0]
		var clean := e.effective_armor()
		var depths := []
		var armors := []
		for _k in 4:
			seed(DMG_SEED)
			await s2._resolve(w2, _ab(s2, w2, "Crushing Blow"), e, "good")
			depths.append(e.sunder_depth())
			armors.append(snappedf(e.effective_armor(), 0.0001))
		rd[arm2[0]] = {"clean": clean, "depths": depths, "armors": armors}
		await _clear(s2)
	var a0 := float(rd["worn"]["clean"])
	ok(rd["worn"]["depths"] == [1, 2, 3, 3] and rd["bare"]["depths"] == [1, 1, 1, 1],
		"§1 Rending Blows: four Crushing Blows left Sunder %s deep worn and %s bare — up to three times" % [rd["worn"]["depths"], rd["bare"]["depths"]])
	ok(a0 > 0.0 and is_equal_approx(float(rd["worn"]["armors"][0]), snappedf(a0 * 0.65, 0.0001))
		and is_equal_approx(float(rd["worn"]["armors"][1]), snappedf(a0 * 0.30, 0.0001))
		and is_equal_approx(float(rd["worn"]["armors"][2]), 0.0),
		"§1 Rending Blows: armor %.4f read %s at one, two and three deep — 35%% a depth, FLOORED AT ZERO at three" % [a0, rd["worn"]["armors"].slice(0, 3)])
	ok(is_equal_approx(float(rd["bare"]["armors"][3]), snappedf(a0 * 0.65, 0.0001)),
		"§1 Rending Blows: bare, Sunder stayed one deep at %.4f" % float(rd["bare"]["armors"][3]))
	print("    Rending Blows: armor %.4f -> %s worn (depth %s), %s bare" % [a0, rd["worn"]["armors"], rd["worn"]["depths"], rd["bare"]["armors"]])
	# ── GRUDGE: +40% on the last enemy that struck him, -20% on every other, and
	# NOTHING before anything has struck him or once that enemy falls.
	var gd := {}
	for arm3 in [["worn", ["grudge"]], ["bare", []]]:
		var s3: Node = await _fight({0: arm3[1]})
		_sturdy(s3)
		var w3 := _hero(s3, "warrior")
		w3.max_hp = 9999
		w3.hp = 9999
		var fs3: Array = s3.get("enemies")
		var strike: Ability = w3.abilities[0]
		var before: int = await _cast_dmg(s3, w3, strike, fs3[0], DMG_SEED)
		seed(DMG_SEED + 1)
		await s3._resolve(fs3[1], (fs3[1] as BattleUnit).abilities[0], w3, "good")
		var foe_set: bool = w3.grudge_foe == fs3[1]
		var on_foe: int = await _cast_dmg(s3, w3, strike, fs3[1], DMG_SEED)
		var on_other: int = await _cast_dmg(s3, w3, strike, fs3[0], DMG_SEED)
		s3._dmg_frame(w3, "gate")
		(fs3[1] as BattleUnit).take_hit(999999, 0)
		var after_fall: int = await _cast_dmg(s3, w3, strike, fs3[0], DMG_SEED)
		gd[arm3[0]] = {"before": before, "foe_set": foe_set, "foe": on_foe, "other": on_other, "fallen": after_fall}
		await _clear(s3)
	ok(int(gd["worn"]["before"]) == int(gd["bare"]["before"]) and int(gd["bare"]["before"]) > 0,
		"§1 Grudge: before any enemy struck him his Strike dealt %d worn against %d bare — NO grudge, NO penalty" % [gd["worn"]["before"], gd["bare"]["before"]])
	ok(bool(gd["worn"]["foe_set"]), "§1 Grudge: the enemy whose blow reached him is not his grudge")
	ok(absi(int(gd["worn"]["foe"]) - int(round(int(gd["bare"]["foe"]) * 1.4))) <= 1,
		"§1 Grudge: on the enemy that struck him he dealt %d worn against %d bare — 40%% more" % [gd["worn"]["foe"], gd["bare"]["foe"]])
	ok(absi(int(gd["worn"]["other"]) - int(round(int(gd["bare"]["other"]) * 0.8))) <= 1,
		"§1 Grudge: on another enemy he dealt %d worn against %d bare — 20%% less" % [gd["worn"]["other"], gd["bare"]["other"]])
	ok(int(gd["worn"]["fallen"]) == int(gd["bare"]["fallen"]),
		"§1 Grudge: once that enemy fell he dealt %d worn against %d bare — the grudge went with it" % [gd["worn"]["fallen"], gd["bare"]["fallen"]])
	print("    Grudge: before %d / %d; on his foe %d / %d; on another %d / %d; foe fallen %d / %d" % [
		gd["worn"]["before"], gd["bare"]["before"], gd["worn"]["foe"], gd["bare"]["foe"],
		gd["worn"]["other"], gd["bare"]["other"], gd["worn"]["fallen"], gd["bare"]["fallen"]])


func _hunter_two() -> void:
	# ── OPPORTUNIST: Powershot doubles on a stunned enemy, whoever stunned it.
	var op := {}
	for arm in [["worn", ["opportunist"]], ["bare", []]]:
		var s: Node = await _fight({3: arm[1]})
		_sturdy(s)
		var h := _hero(s, "hunter")
		var fs: Array = s.get("enemies")
		var plain: int = await _cast_dmg(s, h, _ab(s, h, "Powershot"), fs[0], DMG_SEED)
		s._apply_status(fs[1], "stunned", 2, 0, 0, _hero(s, "warrior"))
		h.resource = h.max_resource
		var stunned: int = await _cast_dmg(s, h, _ab(s, h, "Powershot"), fs[1], DMG_SEED)
		op[arm[0]] = [plain, stunned]
		await _clear(s)
	ok(absi(int(op["worn"][1]) - 2 * int(op["bare"][1])) <= 1 and int(op["bare"][1]) > 0,
		"§1 Opportunist: Powershot on a stunned enemy dealt %d worn against %d bare — double" % [op["worn"][1], op["bare"][1]])
	ok(int(op["worn"][0]) == int(op["bare"][0]),
		"§1 Opportunist: on an enemy standing free it dealt %d worn against %d bare — the stun is what it reads" % [op["worn"][0], op["bare"][0]])
	print("    Opportunist: Powershot on the stunned %d / %d; on the free %d / %d" % [op["worn"][1], op["bare"][1], op["worn"][0], op["bare"][0]])
	# ── TUSK AND BRISTLE: the fourth call, and only for its wearer (the rest is §2).
	var calls := {}
	for arm2 in [["worn", ["tusk_and_bristle"]], ["bare", []]]:
		var s2: Node = await _fight({3: arm2[1]})
		var h2 := _hero(s2, "hunter")
		s2._open_summon_picker(h2)
		calls[arm2[0]] = (s2.get("_summon_opts") as Array).map(func(a): return String(a.display_name))
		s2._close_summon_picker()
		await _clear(s2)
	ok((calls["worn"] as Array).has("Summon Aper") and (calls["worn"] as Array).size() == 4,
		"§1 Tusk and Bristle: the summon picker offers %s worn — the three and Aper" % [calls["worn"]])
	ok(not (calls["bare"] as Array).has("Summon Aper") and (calls["bare"] as Array).size() == 3,
		"§1 Tusk and Bristle: bare, the picker offers %s — the three" % [calls["bare"]])
	print("    Tusk and Bristle: the picker %s worn, %s bare" % [calls["worn"], calls["bare"]])
	# ── LONG POISON (HF §6): the snare's Poison, on a Hunter holding no engine.
	var lp := {}
	for arm3 in [["worn", ["long_poison"]], ["bare", []]]:
		var s3: Node = await _fight({3: arm3[1]})
		var h3 := _hero(s3, "hunter")
		var e3: BattleUnit = _foes(s3)[0]
		s3._apply_poison(h3, e3, 4)
		lp[arm3[0]] = int(e3.get_status("poison").get("turns", 0))
		await _clear(s3)
	ok(int(lp["worn"]) < 0 and int(lp["bare"]) > 0,
		"§1 Long Poison: the snare's Poison stood at %d turns worn and %d bare on a Hunter holding no engine — it never expires" % [lp["worn"], lp["bare"]])
	print("    Long Poison: the snare's Poison %d turns worn, %d bare (no engine)" % [lp["worn"], lp["bare"]])


# ── §2 — APER ────────────────────────────────────────────────────────────────

func _s2_aper() -> void:
	print("\n§2 — Aper: every third strike stuns, and a boss resists until Broken")
	# THE RHYTHM, AND IT NEVER SHORTENS: with Pack Bond and a deep bond it is still every third.
	for arm in [["no engine", []], ["Pack Bond, 10 Loyalty", [_eng("pack")]]]:
		var s: Node = await _fight({3: ["tusk_and_bristle"]}, {3: {"engines": arm[1]}})
		_sturdy(s)
		var h := _hero(s, "hunter")
		var call: Ability = s._summon_choice(h, "aper")
		ok(call != null, "§2 (%s): the wearer has no call for Aper" % arm[0])
		if call == null:
			await _clear(s)
			continue
		await s._resolve(h, call, h, "good")
		var beasts: Array = s._beasts(h)
		ok(beasts.size() == 1 and String(beasts[0].companion_kind) == "aper",
			"§2 (%s): the call fielded %s — Aper" % [arm[0], beasts.map(func(b): return b.companion_kind)])
		if beasts.size() != 1:
			await _clear(s)
			continue
		var aper: BattleUnit = beasts[0]
		ok(String(aper.get_status("aper_rhythm").get("short", "")) == "0/3",
			"§2 (%s): Aper arrives showing %s — its rhythm at 0 of 3" % [arm[0], aper.get_status("aper_rhythm").get("short", "none")])
		if (arm[1] as Array).size() > 0:
			s._gain_loyalty(h, "aper", 9)
		var prey: BattleUnit = _foes(s)[0]
		var stuns := []
		var chips := []
		for _k in 6:
			prey.remove_status("stunned")
			await s._companion_strike(aper, prey, 1.0, false)
			stuns.append(prey.has_status("stunned"))
			chips.append(String(aper.get_status("aper_rhythm").get("short", "")))
		ok(stuns == [false, false, true, false, false, true],
			"§2 (%s): six charges stunned %s — every third, never sooner" % [arm[0], stuns])
		ok(chips == ["1/3", "2/3", "0/3", "1/3", "2/3", "0/3"],
			"§2 (%s): the chip read %s — it says which charge stuns" % [arm[0], chips])
		print("    %s: six charges stun %s, the chip %s" % [arm[0], stuns, chips])
		await _clear(s)
	# A BOSS RESISTS UNTIL BROKEN — Pommel Strike's rule; the charge still counts.
	var sb: Node = await _fight({3: ["tusk_and_bristle"]})
	_sturdy(sb)
	var hb := _hero(sb, "hunter")
	await sb._resolve(hb, sb._summon_choice(hb, "aper"), hb, "good")
	var aperb: BattleUnit = sb._beasts(hb)[0]
	var boss: BattleUnit = _foes(sb)[0]
	boss.is_boss = true
	boss.broken = false
	var boss_stuns := []
	for _k2 in 6:
		if _k2 == 3:
			boss.broken = true
		boss.remove_status("stunned")
		await sb._companion_strike(aperb, boss, 1.0, false)
		boss_stuns.append(boss.has_status("stunned"))
	ok(boss_stuns == [false, false, false, false, false, true],
		"§2: charges on a boss stunned %s — resisted unbroken at the third, stunned Broken at the sixth" % [boss_stuns])
	print("    a boss: %s (unbroken for three, Broken for three)" % [boss_stuns])
	# WHAT STARTS THE COUNT OVER: a swap and a fresh summon — a new body.
	var at_swap := aperb.aper_strikes
	await sb._resolve(hb, sb._summon_choice(hb, "canis"), hb, "good")
	await sb._resolve(hb, sb._summon_choice(hb, "aper"), hb, "good")
	var aper2: BattleUnit = sb._beasts(hb)[0]
	ok(String(aper2.companion_kind) == "aper" and aper2 != aperb and aper2.aper_strikes == 0 and at_swap == 6,
		"§2: swapped out at %d and back, Aper returns at %d — a swap is a fresh body" % [at_swap, aper2.aper_strikes])
	await sb._companion_strike(aper2, boss, 1.0, false)
	aper2.take_hit(99999, 0)
	await sb._resolve(hb, sb._summon_choice(hb, "aper"), hb, "good")
	var aper3: BattleUnit = sb._beasts(hb)[0]
	ok(aper3 != aper2 and aper3.aper_strikes == 0,
		"§2: fallen at 1 and called again, Aper returns at %d — a fresh summon starts over" % aper3.aper_strikes)
	await _clear(sb)
	# PACK BOND'S BOON RAISES THE CHARGE; LOYALTY'S STRIKE STEP TOO.
	var charge := {}
	for arm2 in [["Pack Bond", [_eng("pack")]], ["no engine", []]]:
		var s2: Node = await _fight({3: ["tusk_and_bristle"]}, {3: {"engines": arm2[1]}})
		_sturdy(s2)
		var h2 := _hero(s2, "hunter")
		await s2._resolve(h2, s2._summon_choice(h2, "aper"), h2, "good")
		var a2: BattleUnit = s2._beasts(h2)[0]
		var p2: BattleUnit = _foes(s2)[0]
		var was := p2.hp
		seed(DMG_SEED)
		await s2._companion_strike(a2, p2, 1.0, false)
		charge[arm2[0]] = [was - p2.hp, float(s2._bond_mult(h2, "aper"))]
		await _clear(s2)
	ok(float(charge["Pack Bond"][1]) >= 1.0 and float(charge["no engine"][1]) == 0.0
		and int(charge["Pack Bond"][0]) > int(charge["no engine"][0]),
		"§2: Aper's charge dealt %d under Pack Bond (boon x%.2f) against %d with no engine — the bond raises it" % [
			charge["Pack Bond"][0], charge["Pack Bond"][1], charge["no engine"][0]])
	print("    the charge: %d under Pack Bond (boon x%.2f), %d with no engine" % [charge["Pack Bond"][0], charge["Pack Bond"][1], charge["no engine"][0]])
	# THE BOT CALLS APER — and a Hunter without the rune calls what he always did.
	var picks := {}
	for arm3 in [["worn", ["tusk_and_bristle"]], ["bare", []]]:
		var s3: Node = await _fight({3: arm3[1]})
		var h3 := _hero(s3, "hunter")
		var pick: Array = s3._autoplay_pick(h3)
		var kit: Array = s3._bot_class_kit_pick(h3)
		picks[arm3[0]] = [String((pick[0] as Ability).display_name) if not pick.is_empty() else "",
			String((kit[0] as Ability).display_name) if not kit.is_empty() else ""]
		await _clear(s3)
	ok(picks["worn"] == ["Summon Aper", "Summon Aper"],
		"§2: the bot's rotation and its class-kit case called %s with the rune — Aper" % [picks["worn"]])
	ok(picks["bare"] == ["Summon Canis", "Summon Canis"],
		"§2: without the rune the bot called %s — Canis, as it always did" % [picks["bare"]])
	print("    the bot calls %s with the rune, %s without" % [picks["worn"], picks["bare"]])
	# THE SHARPSHOOTER CANNOT CALL IT: his engine dismisses the pet.
	var ss: Node = await _fight({3: ["tusk_and_bristle"]}, {3: {"engines": [_eng("lethal_aim")]}})
	var hs := _hero(ss, "hunter")
	ok(ss._summon_choice(hs, "aper") == null and ss._find_ability(hs, "Summon Companion") == null,
		"§2: a Sharpshooter wearing Tusk and Bristle can call Aper — his engine dismisses the pet")
	await _clear(ss)


# ── §3 — THE OFFERS ──────────────────────────────────────────────────────────

func _s3_the_offers() -> void:
	print("\n§3 — what a hero holding no engine can be offered, by name (HC's table, re-measured)")
	for cls in SEATS:
		var m := _member(String(cls), "", [])
		var spawn_ids: Array = Runes.eligible_ids(m, []).filter(func(id): return not Runes.is_engine_rune(String(id)))
		# THE CEILING, AS HC's TABLE READS IT (`check_gv` §3's `_offer`): every card
		# his class's one draft pool holds, drafted. A hero with no lineage has no
		# zone-boss pool, so a rune whose card only a lineage's boss offers — Blood
		# Debt's Blood Price, the Berserker's — is past his ceiling, as it is there.
		var mc := _member(String(cls), "", [])
		mc["bm_abilities"] = Classes.draft_pool(String(cls)).duplicate()
		var ceil_ids: Array = Runes.eligible_ids(mc, []).filter(func(id): return not Runes.is_engine_rune(String(id)))
		var names: Array = spawn_ids.map(func(id): return String(Runes.config(String(id)).get("name", id)))
		names.sort()
		var hf_mine: Array = HF_RUNES.keys().filter(func(id): return String(HF_RUNES[id][0]) == String(cls))
		var missing: Array = hf_mine.filter(func(id): return not spawn_ids.has(String(id)))
		ok(missing.is_empty(), "§3: a %s holding no engine is not offered %s at spawn" % [cls, missing])
		ok(spawn_ids.size() >= 5, "§3: a %s holding no engine is offered %d ordinary runes at spawn — every class reaches five" % [cls, spawn_ids.size()])
		ok(spawn_ids.size() >= int(HE_SPAWN[cls]) + hf_mine.size(),
			"§3: a %s holding no engine is offered %d at spawn — HE's %d and HF's %d" % [cls, spawn_ids.size(), HE_SPAWN[cls], hf_mine.size()])
		print("    %-8s spawn %2d / ceiling %2d — %s" % [cls, spawn_ids.size(), ceil_ids.size(), ", ".join(names)])
	# EACH OF THE FIFTEEN AT THE THREE DOORS, for a hero of its class holding none.
	for cls2 in SEATS:
		var m2 := _member(String(cls2), "", [])
		var peddler := _tally(m2, func(mm): return [_run.generate_rune(mm)])
		var cache := _tally(m2, func(mm): return _run.roll_rune_candidates(mm))
		var bargain := _bargain(String(cls2), [])
		var line := PackedStringArray()
		for id2 in HF_RUNES:
			if String(HF_RUNES[id2][0]) != String(cls2):
				continue
			var p := int(peddler.get(id2, 0))
			var c := int(cache.get(id2, 0))
			var b := int(bargain.get(id2, 0))
			ok(p > 0 and c > 0 and b > 0,
				"§3: a %s holding no engine was never offered %s at one of the doors (Peddler %d, cache %d, bargain %d)" % [cls2, id2, p, c, b])
			line.append("%s %d·%d·%d" % [id2, p, c, b])
		print("    %-8s %s" % [cls2, "  ".join(line)])
	# TUSK AND BRISTLE AND THE PET GATE: withheld from a Sharpshooter; Opportunist
	# and Long Poison are not.
	var arms := [["no engine", [], true], ["Pack Bond", [_eng("pack")], true], ["Lethal Aim", [_eng("lethal_aim")], false]]
	for arm in arms:
		var m3 := _member("hunter", "", arm[1])
		var seen := _tally(m3, func(mm): return _run.roll_rune_candidates(mm))
		var tb := int(seen.get("tusk_and_bristle", 0))
		if bool(arm[2]):
			ok(tb > 0, "§3: a Hunter with %s was never offered Tusk and Bristle — he fields a companion" % arm[0])
		else:
			ok(tb == 0, "§3: a Hunter with %s was offered Tusk and Bristle %d times — HB's pet gate withholds it" % [arm[0], tb])
		ok(int(seen.get("opportunist", 0)) > 0 and int(seen.get("long_poison", 0)) > 0,
			"§3: a Hunter with %s was never offered Opportunist (%d) or Long Poison (%d)" % [
				arm[0], int(seen.get("opportunist", 0)), int(seen.get("long_poison", 0))])
		print("    Hunter, %-10s cache: Tusk and Bristle %3d · Opportunist %3d · Long Poison %3d" % [
			arm[0], tb, int(seen.get("opportunist", 0)), int(seen.get("long_poison", 0))])


# The bargain's rune reward through its own door (`claim_reward`), for a party
# whose only hero who can take a rune is a `cls` holding `engs` — HE's method.
func _bargain(cls: String, engs: Array) -> Dictionary:
	seed(ROLL_SEED)
	var seen := {}
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(SEATS[i])
		var mm := _member(key, "", engs.map(func(p): return _eng(String(p))) if key == cls else [])
		if key != cls:
			for e in Runes.eligible_ids(mm, []):
				(mm["runes"] as Array).append(Runes.build(String(e)))
		for k in mm:
			_run.party[i][k] = mm[k]
	var who: Dictionary = _run.party[SEATS.find(cls)]
	for _i in ROLLS:
		_run.pending_reward = {"kind": "rune"}
		_run.claim_reward()
		for trip in who.get("rune_candidates", []):
			for c in trip:
				var n := String((c as Dictionary).get("id", ""))
				seen[n] = int(seen.get(n, 0)) + 1
		who["rune_candidates"] = []
		who["rune_picks_owed"] = 0
	return seen


# ── §4 — THE TWO PAIRINGS ────────────────────────────────────────────────────

func _s4_the_pairings() -> void:
	print("\n§4 — Vow of Silence beside Burning Ground; Abundance under Consecration")
	# THE DOOR EVERY SURFACE ASKS (the pouch row, the map's rune slot, the hero
	# sheet) — worn together, Burning Ground sits out; the vow in the pouch alone
	# forbids nothing; the vow is never the one that sits out.
	var both := _member("cleric", "", [])
	both["runes"] = [_rune("burning_ground"), _rune("vow_of_silence")]
	var pouch := _member("cleric", "", [])
	pouch["runes"] = [_rune("burning_ground"), Runes.build("vow_of_silence")]
	var alone := _member("cleric", "", [])
	alone["runes"] = [_rune("burning_ground")]
	ok((_run.sitting_out_rune_names(both) as Array) == ["Burning Ground"],
		"§4: worn together, the runes sitting out are %s — Burning Ground, and not the vow" % [_run.sitting_out_rune_names(both)])
	ok((_run.sitting_out_rune_names(pouch) as Array).is_empty() and (_run.sitting_out_rune_names(alone) as Array).is_empty(),
		"§4: with the vow off his slots (%s) or not held (%s), Burning Ground sits out" % [
			_run.sitting_out_rune_names(pouch), _run.sitting_out_rune_names(alone)])
	var note := String(_run.rune_sits_out_note("burning_ground", [], _run.worn_rune_ids(both)))
	var flat := note.replace("\n", " ")
	ok(flat == "Sits out of every fight while the Vow of Silence is worn, which forbids the damage it deals. Still worn: the slot stays filled. Unequipping the rune frees the slot.",
		"§4: the sentence reads: %s" % flat)
	var widest := 0
	for ln in note.split("\n"):
		widest = maxi(widest, ln.length())
	ok(widest <= 44, "§4: the sentence's widest line is %d characters — a tooltip does not wrap" % widest)
	print("    the sentence (widest %d): %s" % [widest, flat])
	# THE BATTLE LOG'S ROLL CALL, AND THE READ SITE: the burn pays nothing beside the vow.
	for arm in [["both", ["burning_ground", "vow_of_silence"]], ["burn alone", ["burning_ground"]]]:
		var s: Node = await _fight({2: arm[1]})
		var roll: Array = s.get("_rune_roll_call")
		var says := roll.filter(func(l): return String(l).contains("Burning Ground — Sits out of every fight while the Vow of Silence is worn,"))
		var c := _hero(s, "cleric")
		await s._resolve(c, _ab(s, c, "Consecration"), c, "good")
		var was := _hps(s)
		s._burning_ground_tick(c)
		var burned: bool = _hps(s) != was
		# **AND THE READ SITE DOES NOT EVEN TRY** (its own comment's promise): the
		# vow's frame gate would silence the damage anyway, so health alone cannot
		# tell a refused tick from a silenced one — the log can. A silenced tick
		# still logs its burn and books it to the recap, which is two false records.
		var logged: int = String(s.get("history").get_parsed_text()).count("Burning Ground: the consecrated ground burns")
		if arm[0] == "both":
			ok(says.size() == 1 and not burned and logged == 0,
				"§4 (both worn): the roll call says it sits out %d times, the ground %s, and the log carries %d burns" % [
					says.size(), "burned" if burned else "did not burn", logged])
		else:
			ok(says.is_empty() and burned and logged == 1,
				"§4 (burn alone): the roll call says it sits out %d times, the ground %s, and the log carries %d burns — the positive arm" % [
					says.size(), "burned" if burned else "did not burn", logged])
		print("    %s: roll call %s, burned %s" % [arm[0], "says it sits out" if not says.is_empty() else "silent", burned])
		await _clear(s)
	# ABUNDANCE UNDER CONSECRATION — HOW FAST THE SHIELDS STACK, a whole party at
	# full health through four turns of the ground, every hero's own drip. Printed
	# for the report and asserted as the rule: every tick adds that hero's spill.
	var s2: Node = await _fight({2: ["abundance"]})
	var c2 := _hero(s2, "cleric")
	await s2._resolve(c2, _ab(s2, c2, "Consecration"), c2, "good")
	var rows := PackedStringArray()
	var adds_ok := true
	for key in SEATS:
		var h := _hero(s2, String(key))
		h.hp = h.max_hp
		# THE SPILL IS WHAT THE HEAL WAS WORTH ON ARRIVAL, the recipient's own
		# healing multipliers included — `last_overheal`, read off each tick,
		# never re-derived here from 5% of his maximum.
		var steps := []
		var spilled := 0
		for _t in 4:
			s2._consecration_tick(h)
			spilled += int(h.last_overheal)
			steps.append(maxi(h.status_power("barrier"), 0))
			if int(steps[-1]) != spilled or int(h.last_overheal) <= 0:
				adds_ok = false
		rows.append("%s %s (max %d, a spill of %d a turn)" % [key, steps, h.max_hp, int(h.last_overheal)])
	ok(adds_ok, "§4: four drips on a full party did not add a spill a turn — %s" % ", ".join(rows))
	print("    four turns of the ground on a full party: %s" % ", ".join(rows))
	await _clear(s2)


# ── §4b — THE OTHER THREE SURFACES, DRAWN ────────────────────────────────────
#
# **THE BRIEF'S WORD WAS *VISIBLE*, AND §4 READ THE DOOR, NOT THE SCREEN.** Each of
# these three surfaces asks `Run.sitting_out_rune_names` and builds its sentence
# through `Run.rune_sits_out_note` with the worn ids it must pass itself — a
# surface that forgot them would print the engine sentence for a rune whose cause
# is a rune. So each is drawn on the real screen: worn with the vow, Burning Ground
# is marked (`○` on the map's slot, the sentence in its tooltip, in the pouch row
# and on the sheet's row and state column) and the vow beside it is not; worn
# alone, it is drawn bare — the positive arm on the same frame.

func _s4b_the_screens() -> void:
	print("\n§4b — the pouch, the map's rune slot and the hero sheet, worn with the vow and alone")
	var seat := SEATS.find("cleric")
	var bg := String(Runes.config("burning_ground").get("name", ""))
	var vw := String(Runes.config("vow_of_silence").get("name", ""))
	for arm in [["with the vow", ["burning_ground", "vow_of_silence"], true], ["alone", ["burning_ground"], false]]:
		_seat_party()
		_run.party[seat]["runes"] = (arm[1] as Array).map(func(i): return _rune(String(i)))
		var cut: bool = bool(arm[2])
		var note := String(_run.rune_sits_out_note("burning_ground", [], _run.worn_rune_ids(_run.party[seat])))
		ok(not cut or note.replace("\n", " ").begins_with("Sits out of every fight while the %s is worn" % vw),
			"§4b (%s): the note the surfaces hang is not the rune's: %s" % [arm[0], note.replace("\n", " ")])
		# THE MAP'S RUNE SLOT, before anything is opened.
		change_scene_to_file("res://scenes/map.tscn")
		await Gate.frames(self, 10)
		var mp: Node = current_scene
		ok(Gate.scene_name(self) == "Map", "§4b (%s): the map is not on screen (%s)" % [arm[0], Gate.scene_name(self)])
		if Gate.scene_name(self) != "Map":
			continue
		_close_overlays(mp)
		await Gate.frames(self, 2)
		var all_b: Array = []
		_buttons(mp, all_b)
		var slots: Array = all_b.filter(func(b):
			for c in (b as Button).pressed.get_connections():
				var cb: Callable = c["callable"]
				if cb.get_method() == "_open_rune_panel" and cb.get_bound_arguments() == [seat]:
					return true
			return false)
		var bg_face: Button = null
		var vw_face: Button = null
		for b in slots:
			if String((b as Button).text).ends_with(bg):
				bg_face = b
			elif String((b as Button).text).ends_with(vw):
				vw_face = b
		var face_text := String(bg_face.text) if bg_face != null else "no slot"
		ok(bg_face != null and face_text == ("○ " + bg if cut else bg),
			"§4b (%s): the map's slot for Burning Ground reads `%s`" % [arm[0], face_text])
		ok(not cut or (bg_face != null and String(bg_face.tooltip_text).contains(note)),
			"§4b (%s): the map's slot for Burning Ground does not carry the sentence in its tooltip" % arm[0])
		ok(not cut or (vw_face != null and String(vw_face.text) == vw),
			"§4b (%s): the vow's own slot reads `%s` — the vow pays, and is never the one that sits out" % [
				arm[0], String(vw_face.text) if vw_face != null else "no slot"])
		# THE POUCH.
		mp._open_rune_panel(seat)
		await Gate.frames(self, 3)
		var ov: Node = Gate.overlay(mp, 60)
		ok(ov != null, "§4b (%s): the pouch did not open" % arm[0])
		if ov != null:
			var pl: Array = []
			_labels(ov, pl)
			var told: Array = pl.filter(func(l): return String((l as Label).text) == "✦ %s — %s" % [bg, note.replace("\n", " ")])
			var own: Array = pl.filter(func(l): return String((l as Label).text) == "✦ %s — %s" % [bg, Runes.shown_desc(Runes.build("burning_ground"))])
			ok((told.size() == 1 and own.is_empty()) if cut else (told.is_empty() and own.size() == 1),
				"§4b (%s): the pouch row %s — it should %s" % [arm[0],
					"says it sits out" if not told.is_empty() else "shows the rune's own rule" if not own.is_empty() else "is missing",
					"say it sits out, in the one sentence" if cut else "show the rune's own rule"])
			var vw_row: Array = pl.filter(func(l): return String((l as Label).text) == "✦ %s — %s" % [vw, Runes.shown_desc(Runes.build("vow_of_silence"))])
			ok(not cut or vw_row.size() == 1, "§4b (%s): the vow's pouch row does not show its own rule" % arm[0])
		_close_overlays(mp)
		await Gate.frames(self, 2)
		# THE HERO SHEET.
		_run.hero_screen_idx = seat
		change_scene_to_file("res://scenes/party.tscn")
		await Gate.frames(self, 6)
		var sheet: Node = current_scene
		var sl: Array = []
		_labels(sheet, sl)
		var bg_row: Array = sl.filter(func(l): return String((l as Label).text).contains("%s — " % bg))
		var states: Array = sl.filter(func(l): return String((l as Label).text) == "sits out")
		ok(bg_row.size() == 1, "§4b (%s): the hero sheet draws %d rows for Burning Ground" % [arm[0], bg_row.size()])
		if bg_row.size() == 1:
			ok(String((bg_row[0] as Label).tooltip_text) == (note if cut else ""),
				"§4b (%s): the sheet's Burning Ground row %s the sentence" % [arm[0],
					"does not hang" if cut else "hangs"])
			ok(String((bg_row[0] as Label).text).contains(Runes.shown_desc(Runes.build("burning_ground"))),
				"§4b (%s): the sheet dropped Burning Ground's own rule" % arm[0])
		ok(states.size() == (1 if cut else 0) and (not cut or String((states[0] as Label).tooltip_text) == note),
			"§4b (%s): the sheet's state column reads `sits out` %d times — %s" % [arm[0], states.size(),
				"once, for Burning Ground, with the sentence" if cut else "never"])
		print("    %s: slot `%s`, pouch %s, sheet `sits out` x%d" % [arm[0],
			face_text, "says it" if cut else "its rule", states.size()])
		change_scene_to_file("res://scenes/map.tscn")
		await Gate.frames(self, 4)
	_run.active = false


# ── §5 — MARK OF THE HUNT AND VENOM COATING AT EVERY DOOR ────────────────────

func _s5_mark_and_venom() -> void:
	print("\n§5 — Mark of the Hunt (HF §7: offered with a pet) and Venom Coating (Trapper's)")
	# THE ZONE BOSS'S ROLL: the Beastmaster's pool is the one that holds the mark.
	var marks := [
		["no engine", [], true, false],
		["Pack Bond slotted", [_eng("pack")], true, false],
		["Pack Bond owned and unslotted", [_eng("pack", false)], true, false],
		["Lethal Aim slotted", [_eng("lethal_aim")], false, true],
		["Pack Bond beside Lethal Aim", [_eng("pack"), _eng("lethal_aim")], false, true],
	]
	for arm in marks:
		var m := _member("hunter", "beastmaster", arm[1])
		var seen := _tally(m, func(mm): return _run.roll_spec_ability_offer(mm))
		var n := int(seen.get(MOTH, 0))
		if bool(arm[2]):
			ok(n > 0, "§5: with %s the Beastmaster's zone boss never offered Mark of the Hunt — a Hunter with a pet is offered it" % arm[0])
		else:
			ok(n == 0, "§5: with %s the zone boss offered Mark of the Hunt %d times — HB's pet gate withholds it" % [arm[0], n])
		var c := _member("hunter", "beastmaster", arm[1])
		c["bm_abilities"] = [MOTH]
		c["bm_equipped"] = [MOTH]
		var benched: bool = (_run.sitting_out_names(c) as Array).has(MOTH)
		ok(benched == bool(arm[3]), "§5: with %s, carried Mark of the Hunt %s" % [arm[0], "sits out" if benched else "is seated"])
		print("    %-30s offered %3d · %s" % [arm[0], n, "sits out" if benched else "seated"])
	var beside := String(_run.sits_out_note(MOTH, ["lethal_aim"])).replace("\n", " ")
	ok(beside.begins_with("Sits out of every fight while the Rune of the Sharpshooter is equipped, which dismisses the companion it needs."),
		"§5: beside Lethal Aim the card says: %s" % beside)
	# THE BOSS'S ANSWER: stored with a pet, answered beside Lethal Aim — held back; and
	# stored without Pack Bond, answered without it — handed over.
	var trip: Array = [MOTH, "Spirit Bond", "Call of the Wild"]
	var ma := _member("hunter", "beastmaster", [_eng("lethal_aim", false)])
	ma["bm_candidates"] = [trip.duplicate()]
	ma["bm_picks_owed"] = 1
	var with_pet: Array = _run.ability_choice(ma)
	(ma["engines"][0] as Dictionary)["equipped"] = true
	var held: Array = _run.ability_choice_withheld(ma)
	ok(with_pet.has(MOTH) and held.has(MOTH) and not (_run.ability_choice(ma) as Array).has(MOTH),
		"§5: a stored Mark of the Hunt answered with no engine %s handed over, beside Lethal Aim %s held back" % [
			"is" if with_pet.has(MOTH) else "is not", "is" if held.has(MOTH) else "is not"])
	# WHAT A HUNTER WITH A PET AND NO PACK BOND RECEIVES FROM THE MARK, DRIVEN: the
	# companion's +25% on the prey and the 3% Mana its blows feed; not the hunter's.
	var mk := {}
	for arm2 in [["no engine", []], ["Pack Bond", [_eng("pack")]]]:
		var s: Node = await _fight({}, {3: {"engines": arm2[1], "bm_abilities": [MOTH], "bm_equipped": [MOTH]}})
		_sturdy(s)
		var h := _hero(s, "hunter")
		await s._resolve(h, s._summon_choice(h, "canis"), h, "good")
		var wolf: BattleUnit = s._beasts(h)[0]
		var fs: Array = s.get("enemies")
		await s._resolve(h, _ab(s, h, MOTH), fs[0], "good")
		var marked: bool = fs[0].has_status("hunt_mark")
		var comp_on := 0
		var comp_off := 0
		var was0: int = fs[0].hp
		h.resource = 0
		seed(DMG_SEED)
		await s._companion_hit(wolf, fs[0], 20.0, 0)
		comp_on = was0 - fs[0].hp
		var fed := h.resource
		var was1: int = fs[1].hp
		seed(DMG_SEED)
		await s._companion_hit(wolf, fs[1], 20.0, 0)
		comp_off = was1 - fs[1].hp
		# His own shot, read with the wolf off the field: a shot draws the
		# companion's strike alongside it, and the mark pays that blow too.
		s._free_beast(h, wolf)
		var qs: Ability = h.abilities[0]
		var hunter_on: int = await _cast_dmg(s, h, qs, fs[0], DMG_SEED)
		var hunter_off: int = await _cast_dmg(s, h, qs, fs[1], DMG_SEED)
		mk[arm2[0]] = {"marked": marked, "comp": [comp_on, comp_off], "fed": fed, "hunter": [hunter_on, hunter_off],
			"on_bar": _ab(s, h, MOTH) != null}
		await _clear(s)
	var ne: Dictionary = mk["no engine"]
	var pb: Dictionary = mk["Pack Bond"]
	ok(bool(ne["on_bar"]) and bool(ne["marked"]), "§5: with a pet and no Pack Bond the mark is not on his bar, or does not land")
	ok(absi(int(ne["comp"][0]) - int(round(int(ne["comp"][1]) * 1.25))) <= 1 and int(ne["fed"]) > 0,
		"§5: with no Pack Bond the wolf's blow on the prey dealt %d against %d off it and fed %d Mana — the companion's half" % [
			ne["comp"][0], ne["comp"][1], ne["fed"]])
	ok(int(ne["hunter"][0]) == int(ne["hunter"][1]),
		"§5: with no Pack Bond his own shot on the prey dealt %d against %d off it — the hunter's half is Pack Bond's" % [ne["hunter"][0], ne["hunter"][1]])
	ok(absi(int(pb["hunter"][0]) - int(round(int(pb["hunter"][1]) * 1.25))) <= 1,
		"§5: under Pack Bond his own shot on the prey dealt %d against %d off it — the Pack Bond half pays" % [pb["hunter"][0], pb["hunter"][1]])
	print("    with a pet, no Pack Bond: wolf %s (prey / off), %d Mana fed, his shot %s; under Pack Bond his shot %s" % [
		ne["comp"], ne["fed"], ne["hunter"], pb["hunter"]])
	# VENOM COATING: the Survivalist's zone boss, and the answer.
	for arm3 in [["Trapper slotted", [_eng("trapper")], true], ["no engine", [], false], ["Trapper owned and unslotted", [_eng("trapper", false)], false]]:
		var mv := _member("hunter", "mystic", arm3[1])
		var seen2 := _tally(mv, func(mm): return _run.roll_spec_ability_offer(mm))
		var nv := int(seen2.get(VENOM, 0))
		if bool(arm3[2]):
			ok(nv > 0, "§5: with %s the Survivalist's zone boss never offered Venom Coating — Trapper's holder is offered it" % arm3[0])
		else:
			ok(nv == 0, "§5: with %s the zone boss offered Venom Coating %d times — it is Trapper's (HF §7)" % [arm3[0], nv])
		print("    Venom Coating, %-28s offered %3d" % [arm3[0], nv])
	var vt: Array = [VENOM, "Explosive Shot", "Hamstring"]
	var mv2 := _member("hunter", "mystic", [_eng("trapper")])
	mv2["bm_candidates"] = [vt.duplicate()]
	mv2["bm_picks_owed"] = 1
	var v_in: bool = (_run.ability_choice(mv2) as Array).has(VENOM)
	(mv2["engines"][0] as Dictionary)["equipped"] = false
	var v_out: bool = (_run.ability_choice(mv2) as Array).has(VENOM)
	var v_held: bool = (_run.ability_choice_withheld(mv2) as Array).has(VENOM)
	ok(v_in and not v_out and v_held and (mv2["bm_candidates"] as Array)[0] == vt,
		"§5: a stored Venom Coating answered with Trapper %s, without it %s and %s held back, the triple kept" % [
			"handed over" if v_in else "withheld", "handed over" if v_out else "withheld", "is" if v_held else "is not"])
	# BOTH CARDS' DOORS ARE THE BOSS'S: neither is on a draft pool (so neither the
	# elite's draft nor the boss's fall-back tier can offer it), and each is on its
	# lineage's zone-boss pool — whose roll and answer §5 drives above.
	var in_draft: Array = []
	for key in SEATS:
		for card in [VENOM, MOTH]:
			if Classes.draft_pool(String(key)).has(card) and not in_draft.has(card):
				in_draft.append(card)
	ok(in_draft.is_empty() and Classes.spec_pool("mystic").has(VENOM) and Classes.spec_pool("beastmaster").has(MOTH),
		"§5: %s on a draft pool, or a card off its zone-boss pool — both doors are the boss's" % [in_draft])
	_run.active = false


# ── §6 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s6_the_players_files() -> void:
	print("\n§6 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§6: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§6: %s is byte for byte as this gate found it" % p)
