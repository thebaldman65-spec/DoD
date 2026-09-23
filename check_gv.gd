# BATCH GV — THE RUNES THAT READ AN ENGINE.
#
#   §0  THE POPULATION — every live rune a hero can be offered: the engine runes
#       (an engine each, no payload, class scope) and the ordinary runes (class
#       scope since HC §1, the lineage kept in `written_for`, a payload of fields); `Runes.ENGINE_READ` against this gate's own
#       copy of the ruled rows, and the rows and the named groups partitioning
#       the ordinary runes with nothing over and nothing missing
#   §1  EVERY ORDINARY RUNE DRIVEN BOTH WAYS — a board per arm: its engine
#       equipped or merely owned, the rune worn or not, the same dice. A row pays
#       with its engine and moves NOTHING without it; every rune outside the table
#       moves something without its engine; the one found dead moves nothing in
#       either. §1b the two rows whose PRICE is read with no engine; §1c the half
#       each HALF-WORKS rune keeps only with its engine
#   §2  THE GATE AT THE DOORS — the roll, per lineage, in both directions; OWNED
#       BUT NOT EQUIPPED does not open a row; the Peddler's screen; the elite
#       cache and the bargain, rolled equipped and answered unequipped — the rows
#       sit out, stay stored, and come back; the event verb; the empty-offer
#       sentence's causes
#   §3  WHAT A HERO CAN BE OFFERED — per class, with no engine, with each single
#       engine and with every pair: a number and a list (HC §3's table); and
#       since HD §3 the no-engine half's FLOOR per class, off that table, with
#       the Cleric's zero recorded as owed rather than asserted as correct
#   §4  A WHOLE RUN PER ARM, ON THE REAL SCREENS — the rune offers each hero was
#       shown, by name: none a row with its engine unequipped, and rows shown to
#       a hero holding two
#   §5  THE PLAYER'S FILES
#
# ── WHY §1 DRIVES AND DOES NOT READ ─────────────────────────────────────────
# **A RUNE IS A PAYLOAD OF FIELDS AND THE FIELD SAYS NOTHING ABOUT WHO PAYS.**
# The rows were derived by reading every line that reads each field, with the
# guard chain above it — that reading is `docs/reports/GV.md` §1 — and this is
# the game asked the same question: with the engine merely OWNED (the state a
# hero is in after the pouch's door takes it out), does wearing the rune change
# anything? **The arm that makes the table more than a list of runes that do
# nothing is the ENGINE-EQUIPPED one**: the same drive, the same dice, and the
# rune must pay there, or the drive never reached it.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM.** A row moves nothing unequipped,
# beside the same drive moving it equipped; a row is not rolled for an owner who
# has not equipped it, beside the same member rolling it the moment he does; a
# cache row sits out of the answer, beside the same row offered again once the
# engine is back; no row reaches a whole run's offers with the engine out, beside
# rows reaching a party holding two.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gv.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]

# **BATCH HD §3 — WHAT A HERO HOLDING NO ENGINE CAN BE OFFERED, AS A FLOOR PER
# CLASS: [at spawn, at the ceiling].** HC §3 measured these and GV/HC printed them
# and asserted nothing, on purpose — how many a class SHOULD hold is the rune
# design pass's. The designer ruled the floor at HD: the no-engine half is the one
# that goes thin, so it is asserted per class at HC's reading. **A FLOOR, NEVER AN
# EQUALITY**: the design pass adds runes, and the batch that raises a reading may
# raise its floor. **A ZERO IS NOT A FLOOR**: the Cleric's is 0 / 0 — every Cleric
# rune reads Mercy, Conviction or Ruin — and asserting zero asserts nothing, so his
# row is OWED (the design pass is authoring Cleric runes that read no engine): §3
# prints it as owed, notices the day it rises, and asserts instead what still
# means something — that SOME engine of his opens a rune at spawn, which goes red
# the day a Cleric can be offered nothing at all.
#
# **BATCH HE §1 MOVED ALL THREE FLOORED ROWS, AND SAYS WHY HERE, AS HD RULED THE
# BATCH THAT THINS A HALF MUST.** Seven runes became RULED rows of `Runes.ENGINE_READ`
# — the six that read a status or a stance no class kit lays, and Bared Plate — so
# a hero holding no engine is offered none of them: the Warrior loses Bared Plate,
# Slaughterhouse and Mirror Guard (5 / 9 → 2 / 6), the Mage Long Fuse, Killing Cold
# and Deep Cold (3 / 7 → 0 / 4), the Hunter Long Poison (5 / 7 → 4 / 6). **AND A HALF
# THAT READS ZERO IS OWED HALF BY HALF NOW**: the Mage's spawn half is 0 while his
# ceiling half is 4, so the ceiling is floored and the spawn half is owed, as the
# Cleric's whole row is.
#
# **BATCH HF MOVED ALL FOUR ROWS UP, AND NONE IS OWED NOW.** Fifteen class runes
# that read no engine (HF §1-§4, each in `GROUPS` as `KIT`) and Long Poison
# un-gated (HF §6, Snare Trap lays its Poison): the Warrior 2 / 6 -> 5 / 9
# (Goading Roar, Rending Blows, Grudge), the Mage 0 / 4 -> 5 / 9 (Unravel,
# Seeking Missiles, Detonating Ward, Clarity, Profligate), the Cleric 0 / 0 ->
# 5 / 5 (Abundance, Returned Burden, Burning Ground, Eleventh Hour, Vow of
# Silence) and the Hunter 4 / 6 -> 7 / 9 (Opportunist, Tusk and Bristle, Long
# Poison). The brief's bar was five with no engine for every class, and each
# floor sits at the reading, as HD ruled; the owed branch below binds no half
# today and is kept for the next batch that thins one to nothing.
const RUNE_FLOOR := {
	"warrior": [5, 9],
	"mage": [5, 9],
	"cleric": [5, 5],
	"hunter": [7, 9],
}
const SCRATCH_PROFILE := "user://gv_profile.json"
const SCRATCH_RELICS := "user://gv_relics.json"
const SEED := 20260919

# ── THE RULED ROWS, CARRIED HERE ON PURPOSE ─────────────────────────────────
# **WHICH RUNES ARE GATED IS A RULING'S POPULATION** (`check_gt`'s reason for
# holding `RULED`): a table that moved with no line changing here would be a
# ruling nobody took, so §0 compares, and §1 re-derives it off the drives.
const ROWS := {
	"deepening_hex": "old_gods", "standing_mark": "old_gods",
	"shared_ruin": "old_gods", "wide_rite": "old_gods", "open_wound": "old_gods",
	"vigil": "mercy", "open_hand_fk": "mercy", "long_watch_holy": "mercy",
	"grace": "mercy", "martyr_fk": "mercy",
	"deep_absorb": "conviction", "fourth_stack": "conviction",
	"bare_altar": "conviction",
	# BATCH HC §2 — THE THIRTY-SIXTH ROW, AND ITS READING DID NOT CHANGE: it
	# needs Divine Shield, the Devout's enabler, which leaves with Conviction.
	# GV sorted it CARD because `requires_ability` withholds it at the ROLL; HC
	# drove the ANSWER, which never asks the requirement, and a cache rolled
	# with Conviction slotted handed it over after Conviction was unslotted.
	"layered_aegis": "conviction",
	"ember_leap": "overburn", "pyre_debt": "overburn",
	"second_winter": "permafrost",
	"resonant_core_fk": "resonance", "half_note": "resonance",
	"overtone": "resonance", "dissonance": "resonance", "overflow": "resonance",
	"open_vein": "bloodrage",
	"standing_wall": "heavy_plating", "bracing_line": "heavy_plating",
	"whetstone": "seasoned", "naked_blade": "seasoned",
	"long_leash": "pack", "shared_scent": "pack",
	"keen_focus": "lethal_aim", "heavy_bolts": "lethal_aim", "ambush": "lethal_aim",
	"shared_mark": "lethal_aim", "long_draw_press": "lethal_aim",
	"second_barb": "trapper", "thin_blood": "trapper",
	# BATCH HE §1 — SEVEN RULED ROWS (each `ruled: "HE §1"` in the table): the six
	# that read a status or a stance no class kit lays, gated on the engine that
	# authored what they read, and Bared Plate on the one engine that gives a
	# Warrior Block to trade. Each read site asks the engine too, so §1 drives them
	# as rows — paid with the engine equipped, nothing with it merely owned.
	# **BATCH HF §6 TOOK LONG POISON BACK OUT** (the designer): Snare Trap, in
	# every Hunter's kit, lays the very Poison it reads when the snare springs, so
	# it is `STATUS` in the groups below and its read site asks no engine.
	"long_fuse": "overburn", "killing_cold_fk": "permafrost", "deep_cold": "permafrost",
	"mirror_guard": "seasoned",
	"slaughterhouse_rune": "bloodrage", "bared_plate": "heavy_plating",
}

# ── THE OTHER TWENTY-FIVE, AND WHAT EACH READS IN PLACE OF AN ENGINE ────────
# The batch's reading, sorted by what the rune needs to pay once its engine is
# out: HALF-WORKS (GP's group — still does part of its job, the engine keeps the
# rest), a CARD, a STATUS any card lays, the STANCE every Warrior has, or
# NOTHING at all. **None is gated**; §1 asserts each moves something unequipped.
# **DEAD IS EMPTY SINCE GW §1 WIRED THE SHARED HIDE, AND THE ARM IS KEPT.** It is
# the door a rune found paying nobody comes back through, and a batch that
# deleted it would have to re-derive it; §1 prints how many rows carry it, so an
# empty group reads as a fact rather than as a branch nobody noticed.
# **BATCH HE §1 — SEVEN LEFT THE GROUPS FOR `ROWS`** (Killing Cold from HALF, Long Fuse,
# Deep Cold, Long Poison and Slaughterhouse from STATUS, Mirror Guard from STANCE,
# Bared Plate from NOTHING), by ruling: the STATUS and STANCE groups are empty
# now, and a rune authored into either shape is gated on its engine instead.
const GROUPS := {
	"glass_prison": ["HALF", "a second body frozen either way; a second PRISON only with the engine"],
	"open_line": ["HALF", "Formless opens both stance gates either way; its numbers only with the engine"],
	"blood_debt_rune": ["HALF", "the target pays and he does not either way; the Frenzy steps only with the engine"],
	"second_whistle": ["HALF", "a companion arrives holding 3 Loyalty either way; the Pack Bond boon only with the engine"],
	"ashfall": ["CARD", "Funeral Pyre"],
	"chain_fire": ["CARD", "Firedraw"],
	"cold_snap_fk": ["CARD", "Ice Lance"],
	"butchers_bill": ["CARD", "Hack and Slash"],
	"split_shield": ["CARD", "Shieldwall"],
	"long_blade": ["CARD", "Sever"],
	"full_board": ["CARD", "Cull"],
	"carrion": ["CARD", "Downwind"],
	"answering_pack": ["CARD", "a companion, which Call the Wilds fields with no engine"],
	"bared_fang": ["CARD", "a companion, which Call the Wilds fields with no engine"],
	"last_word": ["NOTHING", "his own health"],
	"long_watch": ["NOTHING", "Break damage"],
	# BATCH GW §1 — THE SHARED HIDE WAS THE `DEAD` ROW AND IT IS NOT DEAD NOW.
	# GV measured it paying nothing in all four arms, named it DEAD and said the
	# day it is wired this gate would say so. GW wired it: the field crosses onto
	# the companion at `_do_summon`, beside `crit_bonus` and `companion_power`.
	# **IT JOINS `CARD` RATHER THAN THE TABLE**, on the same reading as the two
	# Beastmaster runes beside it: the rune needs a COMPANION and nothing else,
	# and an earned Call the Wilds fields one with no Pack Bond at all — so it
	# pays with the engine merely owned exactly as it pays with it equipped,
	# which GW's own pre-pass measured before this line moved (18 against 15 on
	# BOTH arms) and which §1 below asserts.
	"shared_hide": ["CARD", "a companion, which Call the Wilds fields with no engine"],
	# BATCH HF §6 — the STATUS group's one member again: the Poison is Snare
	# Trap's, a kit card every Hunter holds, and the snare springs it with the
	# Hunter as its source (`_apply_poison`), the door the rune reads.
	"long_poison": ["STATUS", "the Poison Snare Trap lays when it springs — every Hunter's kit card"],
	# **BATCH HF §0-§4 — `KIT`: FIFTEEN RUNES WRITTEN TO READ NO ENGINE.** Each
	# reads only its class's kit cards and basic, its class resource, a status
	# its kit lays, or healing and damage in general (the designer's rule, HF §0),
	# and is written for no lineage — so there is no engine to equip or own, and
	# the four-arm drive below has no board to seat. **`check_hf` §1 IS THEIR
	# ARM**: each worn and bare on a party holding no engine, on the same board
	# under the same dice, and what it pays read off the board. §1 here asserts
	# that gate names every one, so a sixteenth sorted here with nobody driving it
	# reds rather than reading clean.
	"abundance": ["KIT", "healing: the overheal of a heal he lands"],
	"returned_burden": ["KIT", "Unburden, a Cleric kit card"],
	"burning_ground": ["KIT", "Consecration, a Cleric kit card"],
	"eleventh_hour": ["KIT", "Ministration, a Cleric kit card"],
	"vow_of_silence": ["KIT", "healing, and damage in general"],
	"unravel": ["KIT", "Magic Burst's Elemental Weakness, a Mage kit card's status"],
	"seeking_missiles": ["KIT", "Magic Missiles, and Magic Burst's Elemental Weakness"],
	"detonating_ward": ["KIT", "Nexus Ward, a Mage kit card"],
	"clarity": ["KIT", "his Mana, the class resource"],
	"profligate": ["KIT", "his Mana, the class resource"],
	"goading_roar": ["KIT", "Mocking Blow's taunt, a Warrior kit card's status"],
	"rending_blows": ["KIT", "Crushing Blow's Sunder, a Warrior kit card's status"],
	"grudge": ["KIT", "damage in general: the last enemy whose blow reached him"],
	"opportunist": ["KIT", "Powershot, a Hunter kit card, and a stun"],
	"tusk_and_bristle": ["KIT", "Summon Companion, a Hunter kit card"],
}

# The cards a drive casts beyond the one `requires_ability` names, seated drafted
# and carried in both arms so the arms differ only in the engine and the rune.
const EXTRA_CARDS := {
	"ember_leap": ["Funeral Pyre"], "pyre_debt": ["Funeral Pyre"],
	"open_line": ["Guard Change"],
}

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GV — THE RUNES THAT READ AN ENGINE")
	# UNCAPPED, OR EVERY BOARD'S NINETY SETTLING FRAMES ARRIVE AT SIXTY A SECOND
	# (`battle._ready` uncaps only a sim).
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
	_s0_the_population()
	var t1 := Time.get_ticks_msec()
	await _s1_every_rune_driven()
	var t2 := Time.get_ticks_msec()
	await _s2_the_doors()
	_s3_what_can_be_offered()
	var t3 := Time.get_ticks_msec()
	await _s4_the_road()
	var t4 := Time.get_ticks_msec()
	_s5_the_players_files()
	print("\n    §1 %.0f s, §2-§3 %.0f s, §4 %.0f s" % [(t2 - t1) / 1000.0,
		(t3 - t2) / 1000.0, (t4 - t3) / 1000.0])
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _data() -> Dictionary:
	var f := FileAccess.open("res://data/runes.json", FileAccess.READ)
	return JSON.parse_string(f.get_as_text())


# Every live ordinary rune, by id, in the file's order.
func _ordinary() -> Array:
	var out: Array = []
	var d := _data()
	for id in d:
		if Runes.is_retired(String(id)) or Runes.is_engine_rune(String(id)):
			continue
		out.append(String(id))
	return out


# **BATCH HC §1 — THE LINEAGE A RUNE WAS WRITTEN FOR IS `written_for`.** It was
# the scope until the scope became the class; the field is history the game never
# reads, and this gate reads it for the one thing history is for — which lineage's
# engine and cards a drive seats to reach the rune's read site.
func _lineage(id: String) -> String:
	return String(Runes.config(id).get("written_for", ""))


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


# A hand-built member of a lineage holding its engine rune — equipped, or OWNED
# AND NOT EQUIPPED, which is the state the pouch's door leaves a hero in.
func _member(spec: String, equipped: bool) -> Dictionary:
	var eng: Array = Runes.engine_pouch_for_spec(spec)
	for r in eng:
		(r as Dictionary)["equipped"] = equipped
	return {"key": Classes.class_of_spec(spec), "spec": spec, "runes": [],
		"bm_abilities": [], "bm_equipped": [], "engines": eng, "awakened": true}


# ONE ARM'S BOARD. The rune's lineage hero sits at his class's seat, every other
# seat with no lineage and no engine; his engine rune is his, EQUIPPED or not;
# the rune is worn or not; the card it names, and any the drive casts, are
# drafted and carried in both arms.
func _board(id: String, equip: bool, wear: bool) -> Node:
	var spec := _lineage(id)
	var seat := SEATS.find(Classes.class_of_spec(spec))
	var specs := ["", "", "", ""]
	specs[seat] = spec
	var over := {}
	for i in 4:
		over[i] = {"engines": []}
	var eng: Array = Runes.engine_pouch_for_spec(spec)
	for r in eng:
		(r as Dictionary)["equipped"] = equip
	over[seat]["engines"] = eng
	var worn: Array = []
	if wear:
		var r2: Dictionary = Runes.build(id)
		r2["equipped"] = true
		worn = [r2]
	over[seat]["runes"] = worn
	var cards: Array = (EXTRA_CARDS.get(id, []) as Array).duplicate()
	var req := String(Runes.config(id).get("requires_ability", ""))
	# BATCH HC §2 — AN ENGINE'S OWN ENABLER IS NEVER DRAFTED. It is in no pool
	# (`check_gn` §0), so no hero holds it without the engine; seated here by
	# hand it would be a state the game cannot reach, and the arm with the engine
	# merely owned would pay off it. The engine brings it, and takes it away.
	var own_enabler: bool = ROWS.has(id) and Classes.engine_enablers(String(ROWS[id])).has(req)
	if req != "" and not cards.has(req) and not own_enabler:
		cards.append(req)
	over[seat]["bm_abilities"] = cards
	over[seat]["bm_equipped"] = cards.duplicate()
	var s: Node = await Gate.spawn(self, specs, {"party": over, "deterministic": true})
	for e in _foes(s):
		e.max_hp = 100000
		e.hp = 50000
		e.pressure = 0
		for st in e.statuses.duplicate():
			e.remove_status(String(st.id))
	# THE TIME SCALE IS RAISED FOR THE DRIVE AND ONLY FOR IT (`_clear` puts it
	# back): a cast awaits its hit animation's pause (`battle._wait`) on a real
	# timer outside sim mode, and nothing in a drive's arithmetic reads the
	# clock — every arm pays the same pauses.
	Engine.time_scale = 50.0
	return s


# The card a drive casts, off the hero's own bar first and the pool second (an
# enabler lives only on the bar).
func _card(s: Node, u: BattleUnit, card: String) -> Ability:
	var ab: Ability = s._find_ability(u, card)
	if ab == null:
		ab = Classes.pool_ability(card)
	return ab


# Cast `card` if the usability door lets it, and report whether it did.
func _cast(s: Node, u: BattleUnit, card: String, target: BattleUnit) -> bool:
	var ab: Ability = _card(s, u, card)
	if ab == null:
		return false
	u.resource = 99999
	u.max_resource = 99999
	u.cooldowns.clear()
	if not bool(s._ability_usable(u, ab)):
		return false
	await s._resolve(u, ab, target, "good")
	return true


# A foe's ordinary blow on `victim`, at a size the drive chooses.
func _struck(s: Node, foe: BattleUnit, victim: BattleUnit, atk := -1) -> void:
	var was := foe.attack
	if atk >= 0:
		foe.attack = atk
	foe.resource = 99999
	foe.cooldowns.clear()
	await s._resolve(foe, foe.abilities[0], victim, "good")
	foe.attack = was


func _statuses(u: BattleUnit) -> Array:
	var out: Array = []
	for st in u.statuses:
		out.append(String(st.id))
	out.sort()
	return out


func _log_count(s: Node, needle: String) -> int:
	return String(s.get("history").get_parsed_text()).count(needle)


# ── §0 — THE POPULATION ─────────────────────────────────────────────────────

func _s0_the_population() -> void:
	print("\n§0 — every live rune a hero can be offered")
	var d := _data()
	var engines := 0
	var ordinary := 0
	for id in d:
		var e: Dictionary = d[id]
		if Runes.is_retired(String(id)):
			continue
		if Runes.is_engine_rune(String(id)):
			engines += 1
			# AN ENGINE RUNE IS AN ENGINE AND READS NONE: nothing in its payload
			# for a field to be read through, and a class scope.
			ok((e.get("payload", {}) as Dictionary).is_empty(),
				"§0: the engine rune %s carries a payload — it has a field to read an engine through" % id)
			ok(String(e.get("scope", "")).begins_with("class:"),
				"§0: the engine rune %s is not class-scoped" % id)
			ok(Runes.engine_read(String(id)) == "",
				"§0: the engine rune %s is a row — an engine rune is what the gate checks FOR" % id)
		else:
			ordinary += 1
			# BATCH HC §1 — scoped to the CLASS of the lineage it was written for.
			# BATCH HF — or, written for NO lineage, to a class, and then it is one
			# of the `KIT` runes the designer wrote to read no engine (HF §0).
			if _lineage(String(id)) == "":
				ok(String(GROUPS.get(id, [""])[0]) == "KIT"
						and SEATS.has(String(e.get("scope", "")).trim_prefix("class:"))
						and String(e.get("scope", "")).begins_with("class:"),
					"§0: the ordinary rune %s is written for no lineage and is not a class-scoped KIT rune (%s)"
						% [id, e.get("scope", "")])
			else:
				ok(String(e.get("scope", "")) == "class:" + Classes.class_of_spec(_lineage(String(id))),
					"§0: the ordinary rune %s is not scoped to the class of the lineage it was written for (%s, %s)"
						% [id, e.get("scope", ""), _lineage(String(id))])
			ok(not (e.get("payload", {}) as Dictionary).is_empty(),
				"§0: the ordinary rune %s has no payload to trace" % id)
	print("    %d live: %d engine runes and %d ordinary runes" % [engines + ordinary, engines, ordinary])
	ok(engines == 24, "§0: %d engine runes, not the charter's six a class for four classes" % engines)
	# THE TABLE IS THE RULED ROWS, BOTH WAYS.
	ok(Runes.ENGINE_READ.size() == ROWS.size(),
		"§0: `Runes.ENGINE_READ` holds %d rows against the %d ruled" % [Runes.ENGINE_READ.size(), ROWS.size()])
	for id in ROWS:
		ok(Runes.engine_read(String(id)) == String(ROWS[id]),
			"§0: %s reads %s by ruling and the table says '%s'" % [id, ROWS[id], Runes.engine_read(String(id))])
		# A ROW READS THE ENGINE OF THE LINEAGE IT WAS WRITTEN FOR — the only one a
		# hero in its scope could come to it by while the scope was the lineage (GV),
		# and an authoring fact since the scope became the class (HC §1): a row is the
		# lineage's rune, and the engine is what that lineage brought.
		ok(Classes.engine_of_spec(_lineage(String(id))) == String(ROWS[id]),
			"§0: %s is a %s rune and its row names %s" % [id, _lineage(String(id)), ROWS[id]])
		ok(not GROUPS.has(id), "§0: %s is a row AND in a group" % id)
		var why := String((Runes.ENGINE_READ.get(id, {}) as Dictionary).get("why", ""))
		ok(why.length() > 20, "§0: %s's row carries no reason" % id)
	for id2 in Runes.ENGINE_READ:
		ok(ROWS.has(id2), "§0: `Runes.ENGINE_READ` gates %s, which no ruling names" % id2)
	# THE ROWS AND THE GROUPS PARTITION THE ORDINARY RUNES.
	var sorted := {}
	for id3 in _ordinary():
		var n := (1 if ROWS.has(id3) else 0) + (1 if GROUPS.has(id3) else 0)
		ok(n == 1, "§0: the live rune %s is sorted %d times, not once" % [id3, n])
		sorted[id3] = true
	for id4 in ROWS.keys() + GROUPS.keys():
		ok(sorted.has(id4), "§0: %s is sorted and is not a live ordinary rune" % id4)
	ok(sorted.size() == ROWS.size() + GROUPS.size(),
		"§0: %d live ordinary runes against %d sorted" % [sorted.size(), ROWS.size() + GROUPS.size()])
	var by_group := {}
	for id5 in GROUPS:
		var gname := String(GROUPS[id5][0])
		by_group[gname] = int(by_group.get(gname, 0)) + 1
	print("    %d rows gated; the rest %s" % [ROWS.size(), str(by_group)])


# ── §1 — EVERY ORDINARY RUNE, DRIVEN BOTH WAYS ──────────────────────────────

# The drive for one rune on one arm's board: the observable the rune's promise
# moves, as a value. **THE SAME CODE RUNS ON ALL FOUR ARMS** — anything an engine
# gives is asked of the game through its own doors, which refuse on the arm
# without it.
func _drive(id: String, s: Node) -> Dictionary:
	var spec := _lineage(id)
	var u: BattleUnit = _hero(s, Classes.class_of_spec(spec))
	var foes := _foes(s)
	var f0: BattleUnit = foes[0]
	var f1: BattleUnit = foes[1] if foes.size() > 1 else null
	var ally: BattleUnit = _hero(s, "warrior") if u.hero_key != "warrior" else _hero(s, "mage")
	match id:
		# ── OLD GODS ──
		"deepening_hex":
			s._gain_ruin(f0, 8)
			return {"primed": f0.has_status("ruin_primed"), "ruin": f0.status_stacks("ruin")}
		"standing_mark":
			s._apply_status(f0, "ruin", -1, 0, 0, u)
			f0.set_ruin_stacks(40)
			u.hp = int(u.max_hp * 0.3)
			seed(SEED)
			await s._resolve(u, u.abilities[0], f0, "good")
			return {"hp": u.hp}
		"shared_ruin":
			s._apply_status(f0, "ruin", -1, 0, 0, u)
			f0.set_ruin_stacks(12)
			s._apply_status(f1, "ruin", -1, 0, 0, u)
			f1.set_ruin_stacks(3)
			s._apply_status(f0, "ruin_primed", 1)
			seed(SEED)
			await s._detonate_ruin(f0)
			return {"f1": f1.status_stacks("ruin")}
		"wide_rite":
			s._gain_ruin(f0, s._old_gods_mark())
			return {"ruin": f0.status_stacks("ruin")}
		"open_wound":
			seed(SEED)
			await _cast(s, u, "Shadowrend", f0)
			var rest: Array = []
			for e in foes:
				if e != f0:
					rest.append(e.status_stacks("ruin"))
			return {"others": rest}
		# ── MERCY ──
		"vigil":
			ally.hp = int(ally.max_hp * 0.3)
			ally.heal_amount(int(ally.max_hp * 0.5), true)
			return {"mercy": u.second_resource}
		"open_hand_fk":
			if u.second_resource_name == "Mercy":
				u.second_resource = 3
			var other: BattleUnit = _hero(s, "mage")
			ally.hp = int(ally.max_hp * 0.3)
			other.hp = int(other.max_hp * 0.3)
			var cast := await _cast(s, u, "Divine Plea", ally)
			return {"cast": cast, "other": other.hp}
		"long_watch_holy":
			if u.second_resource_name == "Mercy":
				u.second_resource = 3
			var m: Dictionary = {}
			u.sync_victory_state(m)
			return {"carry": m.get("fk_mercy_carry", -1)}
		"grace":
			if u.second_resource_name == "Mercy":
				u.second_resource = 3
			var cast2 := await _cast(s, u, "Hymn of Hope", u)
			return {"cast": cast2, "echo": u.grace_echo_pct}
		"martyr_fk":
			seed(SEED)
			await _struck(s, f0, u, 5)
			return {"mercy": u.second_resource}
		# ── CONVICTION ──
		"deep_absorb", "bare_altar":
			s._grant_divine_shield(u, ally, 300)
			seed(SEED)
			await _struck(s, f0, ally, 20)
			return {"peak": ally.faith_peak}
		"fourth_stack":
			s._gain_faith(ally, 5, "gv")
			return {"peak": ally.faith_peak}
		"layered_aegis":
			# BATCH HC §2 — OFF THE BAR ONLY. Divine Shield is the Devout's enabler:
			# it is on the bar while Conviction is slotted and nowhere else, so with
			# the engine merely owned the drive casts nothing — the state the game is
			# in. `_card`'s fall-back to the pool would cast a card no hero without
			# the engine can hold, which is how this read as a CARD rune at GV.
			var cast3 := false
			if s._find_ability(u, "Divine Shield") != null:
				cast3 = await _cast(s, u, "Divine Shield", ally)
			var warded := 0
			for h in s.get("heroes"):
				if not h.is_companion and h.has_status("barrier"):
					warded += 1
			return {"cast": cast3, "warded": warded}
		# ── OVERBURN ──
		"long_fuse":
			s._apply_status(f0, "burn", 3, 12, 0, u)
			f0.tick_statuses()
			return {"burn": int(f0.get_status("burn").get("turns", 0))}
		"ashfall":
			s._apply_status(f0, "burn", 4, 12, 0, u)
			await _cast(s, u, "Funeral Pyre", f0)
			return {"burning": f0.has_status("burn")}
		"chain_fire":
			s._apply_status(f0, "burn", 5, 12, 0, u)
			s._apply_status(f1, "burn", 12, 12, 0, u)
			await _cast(s, u, "Firedraw", f0)
			return {"f1": int(f1.get_status("burn").get("turns", 0))}
		"ember_leap", "pyre_debt":
			s._apply_status(f0, "burn", 6, 12, 0, u)
			u.resource = 0
			var fp: Ability = _card(s, u, "Funeral Pyre")
			u.cooldowns.clear()
			seed(SEED)
			await s._resolve(u, fp, f0, "good")
			# EVERY BODY, THE STRUCK ONE INCLUDED: its fire was consumed, so it is
			# the shallowest and the leap may land on it.
			var burns: Array = []
			for e2 in foes:
				burns.append(int(e2.get_status("burn").get("turns", 0)))
			return {"burns": burns, "mana": u.resource, "hp": u.hp}
		# ── PERMAFROST ──
		"second_winter":
			for _k in 4:
				s._apply_status(f0, "chilled", 3, 0, 0, u)
			f0.hold_turns = 3
			s._hold_release(f0, "gv")
			return {"chill": f0.status_stacks("chilled")}
		"killing_cold_fk":
			f0.is_boss = true
			for _k2 in 4:
				s._apply_status(f0, "chilled", 3, 0, 0, u)
			var was := f0.hp
			seed(SEED)
			await _cast(s, u, u.abilities[0].display_name, f1)
			return {"bit": was - f0.hp}
		"glass_prison":
			await _cast(s, u, "Glacial Prison", f0)
			var frozen := 0
			for e3 in foes:
				if e3.has_status("frozen"):
					frozen += 1
			return {"frozen": frozen}
		"cold_snap_fk":
			s._apply_status(f0, "chilled", 3, 0, 0, u)
			s._apply_status(f1, "chilled", 3, 0, 0, u)
			var was1 := f1.hp
			seed(SEED)
			await _cast(s, u, "Ice Lance", f0)
			return {"f1": was1 - f1.hp}
		"deep_cold":
			f0.is_boss = true
			for _k3 in 6:
				s._apply_status(f0, "chilled", 3, 0, 0, u)
			return {"chill": f0.status_stacks("chilled")}
		# ── RESONANCE ──
		"resonant_core_fk":
			s._gain_resonance(u, 10)
			var m2: Dictionary = {}
			u.sync_victory_state(m2)
			return {"carry": m2.get("fk_resonance_carry", -1)}
		"half_note":
			s._gain_resonance(u, 8)
			var cast4 := await _cast(s, u, "Arcane Bolt", f0)
			return {"cast": cast4, "left": u.second_resource}
		"overtone":
			seed(SEED)
			for _k4 in 3:
				await _cast(s, u, u.abilities[0].display_name, f0)
			return {"res": u.second_resource}
		"dissonance":
			s._gain_resonance(u, 4)
			var was2 := f0.hp
			seed(SEED)
			await _cast(s, u, u.abilities[0].display_name, f0)
			return {"dealt": was2 - f0.hp}
		"overflow":
			u.crit_bonus = 1.0
			seed(SEED)
			await _cast(s, u, u.abilities[0].display_name, f0)
			return {"res": u.second_resource}
		# ── BLOOD FRENZY ──
		"last_word":
			u.hp = int(u.max_hp * 0.3)
			u.take_hit(int(u.max_hp * 0.1), 0)
			var first := true
			for other2 in s.get("heroes") + s.get("enemies"):
				if other2 != u and not other2.dead and other2.next_time <= u.next_time:
					first = false
			return {"first": first}
		"blood_debt_rune":
			var fwas := f0.hp
			var uwas := u.hp
			await _cast(s, u, "Blood Price", f0)
			return {"foe": fwas - f0.hp, "self": uwas - u.hp}
		"butchers_bill":
			var extra := 0
			for k5 in 8:
				seed(SEED + k5)
				await _cast(s, u, "Hack and Slash", f0)
			extra = _log_count(s, "Butcher's Bill")
			return {"swings": extra}
		"open_vein":
			u.note_resource_spent(40)
			var was3 := f0.hp
			seed(SEED)
			await s._resolve(u, u.abilities[0], f0, "good")
			return {"dealt": was3 - f0.hp}
		"slaughterhouse_rune":
			s._add_bleed_with_burst(f0, 100)
			var first2 := true
			for other3 in s.get("heroes") + s.get("enemies"):
				if other3 != u and not other3.dead and other3.next_time <= u.next_time:
					first2 = false
			return {"first": first2}
		# ── HEAVY PLATING ──
		"standing_wall":
			u.plating_bonus = 0.24
			u.block_chance = 1.0
			seed(SEED)
			await _struck(s, f0, u, 20)
			return {"plating": int(round(u.plating_bonus * 100.0))}
		"bracing_line":
			u.plating_bonus = 0.40
			var mage: BattleUnit = _hero(s, "mage")
			var was4 := mage.hp
			seed(SEED)
			await _struck(s, f0, mage, 30)
			return {"taken": was4 - mage.hp}
		"split_shield":
			var mage2: BattleUnit = _hero(s, "mage")
			await _cast(s, u, "Shieldwall", mage2)
			return {"ally": _statuses(mage2)}
		"long_watch":
			var was5 := f1.pressure
			seed(SEED)
			await _cast(s, u, "Crushing Blow", f0)
			return {"f1": f1.pressure - was5}
		"bared_plate":
			seed(SEED)
			await _cast(s, u, "Crushing Blow", f0)
			return {"bd": f0.pressure}
		# ── SEASONED FIGHTER ──
		"whetstone", "naked_blade":
			u.stance = "aggressive"
			u.whetstone_turns = 3
			var was6 := f0.hp
			seed(SEED)
			await s._resolve(u, u.abilities[0], f0, "good")
			return {"dealt": was6 - f0.hp}
		"mirror_guard":
			u.stance = "defensive"
			u.parry_chance = 1.0
			var was7 := f0.hp
			seed(SEED)
			await _struck(s, f0, u, 20)
			return {"returned": was7 - f0.hp}
		"open_line":
			await _cast(s, u, "Guard Change", u)
			return {"stance": u.stance, "formless": u.has_status("formless")}
		"long_blade":
			f1.take_hit(0, 999)
			await _cast(s, u, "Sever", f0)
			return {"cooling": u.cooldowns.has("Sever")}
		# ── PACK BOND ──
		"long_leash":
			await s._do_summon(u, "canis")
			s._gain_loyalty(u, "canis", 10)
			var cn: BattleUnit = s._beasts(u)[0]
			var was8 := f0.hp
			seed(SEED)
			await s._companion_strike(cn, f0, 1.0, false)
			return {"dealt": was8 - f0.hp}
		"shared_hide":
			await s._do_summon(u, "canis")
			var cn2: BattleUnit = s._beasts(u)[0]
			s._apply_status(cn2, "surge", 2)
			var was9 := f0.hp
			seed(SEED)
			await s._companion_strike(cn2, f0, 1.0, false)
			return {"dealt": was9 - f0.hp}
		"answering_pack":
			await s._do_summon(u, "canis")
			u.hp = 5
			seed(SEED)
			await _struck(s, f0, u, 500)
			return {"hunter_dead": u.dead}
		"second_whistle":
			await s._do_summon(u, "canis")
			return {"loyalty": int(u.loyalty.get("canis", 0))}
		"shared_scent":
			await s._do_summon(u, "canis")
			s._gain_loyalty(u, "canis", 5)
			var cn3: BattleUnit = s._beasts(u)[0]
			# THROUGH A REAL BLOW: `_on_beast_death` is reached from the strike
			# loop's kill, never from a bare `take_hit`.
			seed(SEED)
			await _struck(s, f0, cn3, 99999)
			await s._do_summon(u, "ursus")
			return {"ursus": int(u.loyalty.get("ursus", 0))}
		"bared_fang":
			await s._do_summon(u, "canis")
			var cn4: BattleUnit = s._beasts(u)[0]
			var was10 := f0.hp
			seed(SEED)
			await s._companion_strike(cn4, f0, 1.0, false)
			return {"dealt": was10 - f0.hp}
		# ── LETHAL AIM ──
		"keen_focus":
			if u.second_resource_name == "Focus":
				u.second_resource = 100
			u.last_attack_target = f0
			seed(SEED)
			await s._resolve(u, u.abilities[0], f1, "good")
			return {"focus": u.second_resource}
		"heavy_bolts":
			if u.second_resource_name == "Focus":
				u.second_resource = 90
			return {"chance": snappedf(u.focus_crit_chance(), 0.0001),
				"mult": snappedf(u.focus_crit_mult(), 0.0001)}
		"ambush":
			if u.second_resource_name == "Focus":
				u.second_resource = 50
			var was11 := f0.hp
			seed(SEED)
			await _cast(s, u, "Called Volley", f0)
			return {"dealt": was11 - f0.hp}
		"shared_mark":
			u.last_attack_target = f0
			var w: BattleUnit = _hero(s, "warrior")
			seed(SEED)
			await s._resolve(w, w.abilities[0], f0, "good")
			return {"focus": u.second_resource}
		"long_draw_press":
			if u.second_resource_name == "Focus":
				u.second_resource = 100
			return {"presses": s._sequence_presses(u)}
		# ── TRAPPER ──
		"long_poison":
			s._apply_poison(u, f0, 3)
			return {"turns": int(f0.get_status("poison").get("turns", 0))}
		"second_barb", "thin_blood":
			# EVERY AFFLICTION THE ATTACKER CARRIES AWAY, BY NAME, over two dozen
			# blows: Thin Blood makes the barb certain, and the Second Barb
			# changes WHICH affliction it is — poison first, as the plain barb,
			# then the rest of Stalking Horse's cycle — so a count alone cannot
			# see it.
			var took: Array = []
			for k6 in 24:
				seed(SEED + k6)
				for st2 in f0.statuses.duplicate():
					f0.remove_status(String(st2.id))
				u.hp = u.max_hp
				await _struck(s, f0, u, 5)
				took.append_array(_statuses(f0))
			took.sort()
			return {"afflictions": took}
		"full_board":
			s._apply_status(f0, "burn", 3, 12, 0, u)
			s._apply_status(f0, "chilled", 3, 0, 0, u)
			s._apply_poison(u, f0, 3)
			await _cast(s, u, "Cull", f0)
			return {"left": _statuses(f0)}
		"carrion":
			await _cast(s, u, "Downwind", u)
			s._apply_status(f0, "slow", 2, 0, 0, u)
			var slowed := 0
			for e4 in foes:
				if e4.has_status("slow"):
					slowed += 1
			return {"slowed": slowed}
	ok(false, "§1: %s has no drive" % id)
	return {}


# One arm, on a fresh board.
func _arm(id: String, equip: bool, wear: bool) -> Dictionary:
	var s: Node = await _board(id, equip, wear)
	var out: Dictionary = await _drive(id, s)
	await _clear(s)
	return out


func _s1_every_rune_driven() -> void:
	print("\n§1 — every ordinary rune, its engine equipped and merely owned, worn and not")
	var rows_ok := 0
	var others_ok := 0
	var kit := 0
	var hf_src := FileAccess.get_file_as_string("res://check_hf.gd")
	for id in _ordinary():
		# BATCH HF — A `KIT` RUNE HAS NO ENGINE TO EQUIP OR OWN, AND `check_hf` §1
		# DRIVES IT WORN AND BARE ON A HERO HOLDING NONE (the group's comment). The
		# arm here is that the drive exists: the gate names the rune in its table
		# and drives its section.
		if String(GROUPS.get(id, [""])[0]) == "KIT":
			ok(hf_src.contains('\t"%s": [' % id) and hf_src.contains("_s1_the_fifteen"),
				"§1: %s reads no engine and `check_hf` §1 does not drive it — a KIT rune nobody drives" % id)
			kit += 1
			continue
		var ew: Dictionary = await _arm(id, true, true)
		var en: Dictionary = await _arm(id, true, false)
		var bw: Dictionary = await _arm(id, false, true)
		var bn: Dictionary = await _arm(id, false, false)
		var paid_equipped := str(ew) != str(en)
		var paid_bare := str(bw) != str(bn)
		var group := "ROW %s" % ROWS[id] if ROWS.has(id) else String(GROUPS.get(id, ["?"])[0])
		print("    %-20s %-22s equipped %s / %s   owned %s / %s" % [id, group, ew, en, bw, bn])
		if ROWS.has(id):
			ok(paid_equipped,
				"§1: %s pays nothing even with %s equipped — the drive does not reach it, or the row is wrong" % [id, ROWS[id]])
			ok(not paid_bare,
				"§1: %s moved something with %s merely OWNED (%s against %s) — it does not belong in the table" % [id, ROWS[id], bw, bn])
			if paid_equipped and not paid_bare:
				rows_ok += 1
		elif String(GROUPS.get(id, [""])[0]) == "DEAD":
			ok(not paid_equipped and not paid_bare,
				"§1: %s paid something (%s / %s, %s / %s) — it is no longer dead; sort it again" % [id, ew, en, bw, bn])
		else:
			ok(paid_bare,
				"§1: %s moved nothing with its engine merely owned and is not in the table — the table is missing a row" % id)
			ok(paid_equipped,
				"§1: %s moved nothing with its engine equipped either — the drive does not reach it" % id)
			if paid_bare and paid_equipped:
				others_ok += 1
	# BATCH GW — THE DENOMINATOR IS DERIVED, NEVER `GROUPS.size() - 1`. That
	# literal meant "every group but the one DEAD row", and GW emptied DEAD — a
	# count written against a population that has since moved is the defect this
	# project keeps paying for.
	var dead := 0
	for id6 in GROUPS:
		if String(GROUPS[id6][0]) == "DEAD":
			dead += 1
	print("    %d of %d rows pay equipped and move nothing unequipped; %d of %d others pay unequipped (%d named DEAD); %d KIT runes driven by `check_hf` §1" % [
		rows_ok, ROWS.size(), others_ok, GROUPS.size() - dead - kit, dead, kit])
	ok(rows_ok == ROWS.size(), "§1: only %d of %d rows read clean on both arms" % [rows_ok, ROWS.size()])
	await _s1b_the_price()
	await _s1c_the_half()


# ── §1b — THE TWO ROWS WHOSE PRICE IS GATED WITH ITS PAYOUT ──────────────────
#
# **THEY WERE WORSE THAN NOTHING WITHOUT THEIR ENGINE, AND GW §3 RULED THAT
# CLOSED.** GV measured the price landing on the arm with the engine merely
# OWNED, where §1 had found the promise paying nothing — an ally's heal of 40
# landing 0 against 46, and a poison ticking 0 against 3. Each price now reads
# its payout's own predicate (`has_engine("mercy")`, `has_engine("trapper")`).
#
# **THE ARMS ARE REPAIRED TO INTENT RATHER THAN DELETED (CQ §3), AND THE
# EQUIPPED BOARD IS WHY THERE ARE THREE OF THEM.** With the price gated, *engine
# owned + rune worn* and *engine owned + no rune* read the SAME — so a section
# holding only those two would assert a pair that cannot disagree, which passes
# just as well on a price that was simply deleted. The EQUIPPED arm is what
# still discriminates: the refusal has to land there, or this section is
# measuring nothing. `check_gw` §3 carries the payouts beside the prices.
#
# **BATCH HE §1 — AND A THIRD: BARED PLATE, WHOSE PRICE ASKS HEAVY PLATING BY
# RULING.** Its price refuses his Block roll and zeroes the chance a Covering
# Guard reads (`_live_block_chance`), and both sites ask the engine since HE, as
# its payout does (§1 drives the payout; nothing drove the price until this arm,
# so a price site that stopped asking would have read green). The same three
# boards: the refusal lands only with the engine EQUIPPED.
func _s1b_the_price() -> void:
	print("\n§1b — the three rows whose price is gated with its payout (GW §3, and Bared Plate at HE §1)")
	for arm in [[true, true], [false, true], [false, false]]:
		var equip: bool = arm[0]
		var wear: bool = arm[1]
		var s: Node = await _board("martyr_fk", equip, wear)
		var u: BattleUnit = _hero(s, "cleric")
		u.hp = int(u.max_hp * 0.5)
		var got: int = u.heal_amount(40, true)
		print("    [Martyr, engine %s, rune %s] an ally's heal of 40 lands %d" % [
			"equipped" if equip else "owned", "worn" if wear else "not worn", got])
		if equip and wear:
			ok(got == 0, "§1b: the Martyr's price did not refuse an ally's heal with its engine EQUIPPED (%d)" % got)
		else:
			ok(got > 0, "§1b: an ally's heal was refused with the engine %s and the rune %s (%d)" % [
				"equipped" if equip else "merely owned", "worn" if wear else "not worn", got])
		await _clear(s)
	for arm2 in [[true, true], [false, true], [false, false]]:
		var equip2: bool = arm2[0]
		var wear2: bool = arm2[1]
		var s2: Node = await _board("thin_blood", equip2, wear2)
		var u2: BattleUnit = _hero(s2, "hunter")
		var f0: BattleUnit = _foes(s2)[0]
		s2._apply_poison(u2, f0, 3)
		var tick := int(f0.get_status("poison").get("tick", -1))
		print("    [Thin Blood, engine %s, rune %s] a poison he lays ticks for %d" % [
			"equipped" if equip2 else "owned", "worn" if wear2 else "not worn", tick])
		if equip2 and wear2:
			ok(tick == 0, "§1b: Thin Blood's price did not stop his poison biting with the engine EQUIPPED (%d)" % tick)
		else:
			ok(tick > 0, "§1b: his poison does not bite with the engine %s and the rune %s (%d)" % [
				"equipped" if equip2 else "merely owned", "worn" if wear2 else "not worn", tick])
		await _clear(s2)
	# BARED PLATE: his Block chance set to a certainty, so a blow whose roll is
	# not refused is a block — and the chance a Covering Guard would read, beside.
	for arm3 in [[true, true], [false, true], [false, false]]:
		var equip3: bool = arm3[0]
		var wear3: bool = arm3[1]
		var s3: Node = await _board("bared_plate", equip3, wear3)
		var u3: BattleUnit = _hero(s3, "warrior")
		var f3: BattleUnit = _foes(s3)[0]
		u3.block_chance = 1.0
		var live: float = s3._live_block_chance(u3)
		seed(SEED)
		for _b in 4:
			u3.hp = u3.max_hp
			await _struck(s3, f3, u3, 20)
		var blocked := _log_count(s3, " BLOCKS ")
		print("    [Bared Plate, engine %s, rune %s] Block chance read %.2f; %d of 4 blows blocked" % [
			"equipped" if equip3 else "owned", "worn" if wear3 else "not worn", live, blocked])
		if equip3 and wear3:
			ok(live == 0.0 and blocked == 0,
				"§1b: Bared Plate's price did not refuse his Block with the engine EQUIPPED (chance %.2f, %d blocked)" % [live, blocked])
		else:
			ok(live > 0.0 and blocked > 0,
				"§1b: his Block was refused with the engine %s and the rune %s (chance %.2f, %d blocked)" % [
					"equipped" if equip3 else "merely owned", "worn" if wear3 else "not worn", live, blocked])
		await _clear(s3)


# ── §1c — WHAT EACH HALF-WORKS RUNE KEEPS ONLY WITH ITS ENGINE ───────────────
func _s1c_the_half() -> void:
	print("\n§1c — the half each HALF-WORKS rune keeps only with its engine")
	# KILLING COLD on a body that can be HELD: the held pile stays at four with
	# the engine; without it the freeze is ordinary ice and the pile drops to one.
	# **BATCH HE §1 — IT IS A RULED ROW NOW, AND ITS BILL ASKS PERMAFROST**, so the
	# half it kept without the engine (a boss already sitting on four Chilled) is
	# gone and §1 drives it as a row. This arm is kept as the record of the half:
	# it still separates with the engine and not without, which a row does too.
	var kc := {}
	for equip in [true, false]:
		for wear in [true, false]:
			var s: Node = await _board("killing_cold_fk", equip, wear)
			var u: BattleUnit = _hero(s, "mage")
			var foes := _foes(s)
			for _k in 4:
				s._apply_status(foes[0], "chilled", 3, 0, 0, u)
			var was: int = foes[0].hp
			seed(SEED)
			await _cast(s, u, u.abilities[0].display_name, foes[1])
			kc["%s|%s" % [equip, wear]] = was - foes[0].hp
			await _clear(s)
	print("    [Killing Cold on a trash body] equipped %s / %s, owned %s / %s" % [
		kc["true|true"], kc["true|false"], kc["false|true"], kc["false|false"]])
	ok(kc["true|true"] != kc["true|false"],
		"§1c: Killing Cold bit nothing on a held body with the engine equipped")
	ok(kc["false|true"] == kc["false|false"],
		"§1c: Killing Cold bit a trash body with the engine merely owned — it is not half, it is whole")
	# GLASS PRISON: the second body is a PRISON only with the engine.
	var held := {}
	for equip2 in [true, false]:
		var s2: Node = await _board("glass_prison", equip2, true)
		var u2: BattleUnit = _hero(s2, "mage")
		await _cast(s2, u2, "Glacial Prison", _foes(s2)[0])
		var n := 0
		for e in _foes(s2):
			if s2._is_held(e):
				n += 1
		held[equip2] = n
		await _clear(s2)
	print("    [Glass Prison] bodies HELD: %d equipped, %d owned" % [held[true], held[false]])
	ok(int(held[true]) == 2 and int(held[false]) == 0,
		"§1c: Glass Prison's prisons are not the engine's (%d / %d)" % [held[true], held[false]])
	# SECOND WHISTLE: the Loyalty it hands over buys the Pack Bond boon only with
	# the engine; the companion's strike step reads it either way.
	var boon := {}
	for equip3 in [true, false]:
		var s3: Node = await _board("second_whistle", equip3, true)
		var u3: BattleUnit = _hero(s3, "hunter")
		await s3._do_summon(u3, "canis")
		boon[equip3] = snappedf(float(s3._bond_mult(u3, "canis")), 0.001)
		await _clear(s3)
	print("    [Second Whistle] the Pack Bond boon on canis: %s equipped, %s owned" % [boon[true], boon[false]])
	ok(float(boon[true]) > 0.0 and float(boon[false]) == 0.0,
		"§1c: the boon Second Whistle's Loyalty buys is not the engine's (%s / %s)" % [boon[true], boon[false]])
	# OPEN LINE: Formless's numbers are the engine's. Without the rune Guard
	# Change lands him in Defensive, which trims the blow he deals; with it he
	# holds both guards, which keeps Aggressive's edge — but only the engine
	# reads either guard's numbers, so the blow he deals next separates only
	# with it equipped.
	var dealt := {}
	for equip4 in [true, false]:
		for wear4 in [true, false]:
			var s4: Node = await _board("open_line", equip4, wear4)
			var u4: BattleUnit = _hero(s4, "warrior")
			await _cast(s4, u4, "Guard Change", u4)
			var f4: BattleUnit = _foes(s4)[0]
			var was4 := f4.hp
			seed(SEED)
			await s4._resolve(u4, u4.abilities[0], f4, "good")
			dealt["%s|%s" % [equip4, wear4]] = was4 - f4.hp
			await _clear(s4)
	print("    [Open Line] the blow he deals after Guard Change: equipped %s / %s, owned %s / %s" % [
		dealt["true|true"], dealt["true|false"], dealt["false|true"], dealt["false|false"]])
	ok(dealt["true|true"] != dealt["true|false"],
		"§1c: Open Line's Formless moved no blow with the engine equipped")
	ok(dealt["false|true"] == dealt["false|false"],
		"§1c: Open Line's Formless moved a blow with the engine merely owned — its numbers are not the engine's")
	# BLOOD DEBT: the steps it books are read only under the engine.
	var steps := {}
	for equip5 in [true, false]:
		var s5: Node = await _board("blood_debt_rune", equip5, true)
		var u5: BattleUnit = _hero(s5, "warrior")
		await _cast(s5, u5, "Blood Price", _foes(s5)[0])
		steps[equip5] = int(round(u5.frenzy_bonus() * 100.0)) if u5.has_engine("bloodrage") else 0
		await _clear(s5)
	print("    [Blood Debt] Blood Frenzy after the bill: +%d%% equipped, +%d%% owned" % [steps[true], steps[false]])
	ok(int(steps[true]) > 0, "§1c: Blood Debt's steps bought no Blood Frenzy with the engine equipped")


# ── §2 — THE GATE AT THE DOORS ──────────────────────────────────────────────

func _s2_the_doors() -> void:
	print("\n§2 — the gate at every door")
	# (a) THE ROLL, PER LINEAGE, BOTH DIRECTIONS — and the kit made whole so the
	# only thing between a row and the roll is the engine.
	var every_card := {}
	for id in _ordinary():
		var req := String(Runes.config(id).get("requires_ability", ""))
		if req != "":
			every_card[_lineage(id)] = (every_card.get(_lineage(id), []) as Array) + [req]
	var opened := 0
	for spec in Classes.SPEC_INFO:
		var on := _member(String(spec), true)
		var off := _member(String(spec), false)
		on["bm_abilities"] = every_card.get(spec, [])
		off["bm_abilities"] = every_card.get(spec, [])
		var rolled_on: Array = Runes.eligible_ids(on, [])
		var rolled_off: Array = Runes.eligible_ids(off, [])
		for id2 in _ordinary():
			if _lineage(id2) != String(spec):
				continue
			if ROWS.has(id2):
				ok(not rolled_off.has(id2),
					"§2a: the row %s is rolled for a %s who OWNS %s and has not equipped it" % [id2, spec, ROWS[id2]])
				ok(rolled_on.has(id2),
					"§2a: the row %s is not rolled for a %s with %s equipped" % [id2, spec, ROWS[id2]])
				if rolled_on.has(id2):
					opened += 1
			else:
				ok(rolled_off.has(id2) and rolled_on.has(id2),
					"§2a: %s reads no engine and is not rolled for a %s either way" % [id2, spec])
	ok(opened == ROWS.size(), "§2a: equipping the engine opened %d rows, not %d" % [opened, ROWS.size()])
	print("    the roll: every row withheld from its owner unequipped and rolled once equipped (%d)" % opened)
	# (b) **BATCH HC §1 — A SECOND ENGINE OPENS ITS RUNES, AND THE READING THIS ARM
	# HELD IS INVERTED, NOT DROPPED.** GV's *"a second engine widens nothing"* was
	# the spec scope's consequence — scope was the lineage, so another lineage's
	# rows were out of reach whatever he slotted. The scope is the class now, and
	# the engine gate is exactly the door into a row: a Holy Cleric with the Old
	# Gods slotted beside Mercy is rolled the Occultist rows, and with the Old Gods
	# merely OWNED he is rolled none of them. Both arms, and his own Mercy rows in
	# both, so neither reading can pass on an empty roll.
	var holy := _member("holy", true)
	var og: Dictionary = Runes.build(Runes.engine_rune_id("old_gods"))
	og["equipped"] = true
	holy["engines"] = (holy["engines"] as Array) + [og]
	var two: Array = Runes.eligible_ids(holy, [])
	var occ_rows: Array = []
	for rid in ROWS:
		if String(ROWS[rid]) == "old_gods" and String(Runes.config(String(rid)).get("requires_ability", "")) == "":
			occ_rows.append(String(rid))
	var occ_rolled := two.filter(func(i): return occ_rows.has(String(i)))
	ok(occ_rolled.size() == occ_rows.size() and not occ_rows.is_empty(),
		"§2b: a Holy Cleric holding the Old Gods second is rolled %d of the %d Old Gods rows that need no card — %s" % [
			occ_rolled.size(), occ_rows.size(), occ_rolled])
	var holy_off := _member("holy", true)
	var og_off: Dictionary = Runes.build(Runes.engine_rune_id("old_gods"))
	og_off["equipped"] = false
	holy_off["engines"] = (holy_off["engines"] as Array) + [og_off]
	var two_off: Array = Runes.eligible_ids(holy_off, [])
	ok(not two_off.any(func(i): return occ_rows.has(String(i))),
		"§2b: a Holy Cleric who OWNS the Old Gods and has not slotted it is rolled its rows")
	ok(two.any(func(i): return ROWS.get(String(i), "") == "mercy")
			and two_off.any(func(i): return ROWS.get(String(i), "") == "mercy"),
		"§2b: ...and he is rolled none of his own Mercy rows either — the arm cannot be read")
	# (c) THE ELITE CACHE AND THE BARGAIN — ROLLED EQUIPPED, ANSWERED UNEQUIPPED.
	await _s2c_the_cache()
	# (d) THE PEDDLER'S OWN SCREEN.
	await _s2d_the_peddler()
	# (e) THE EVENT VERB.
	var ev := _member("sharpshooter", false)
	for _t in 20:
		var got: Dictionary = _run.grant_rune(ev)
		ok(not ROWS.has(String(got.get("id", ""))),
			"§2e: the event verb granted the row %s to a Sharpshooter who has not equipped Lethal Aim" % got.get("id", ""))
	# (f) THE EMPTY OFFER'S SENTENCE — the engine named when it is the cause.
	var bare := _member("occultist", false)
	var why := Runes.empty_offer_reason(bare)
	print("    an Occultist with the Old Gods unequipped, drafting nothing: \"%s\"" % why)
	ok(why.contains("Rune of the Occultist") and why.contains("equipped"),
		"§2f: the empty offer does not name the engine rune that brings the runes back")
	var full := _member("occultist", true)
	for id3 in Runes.eligible_ids(full, []):
		if not Runes.is_engine_rune(String(id3)):
			(full["runes"] as Array).append(Runes.build(String(id3)))
	# **BATCH HC §1 — "EQUIPPED" CAN BE TRUE OF HIS CLASS AND NOT OF HIM.** At the
	# spec scope everything left for him was his lineage's, so the word alone said
	# the sentence blamed his own engine. At the class scope the Holy's and the
	# Devout's rows are left too, and they DO wait on engines he has not slotted —
	# so the sentence says so, and what it must not do is name the one he has.
	var why_full := Runes.empty_offer_reason(full)
	print("    the same Occultist with the Old Gods equipped and his runes taken: \"%s\"" % why_full)
	ok(not why_full.contains("Rune of the Occultist"),
		"§2f: an Occultist with the Old Gods equipped is told his runes wait on it")


func _s2c_the_cache() -> void:
	# THE ELITE CACHE ROLLS AT THE DROP; THE BARGAIN ROLLS AT THE OFFER. BOTH
	# STORE THE TRIPLE AND BOTH ARE ANSWERED THROUGH `Run.rune_choice`.
	var had := bool(_run.sim_run)
	_run.sim_run = true
	var m := _member("occultist", true)
	var rolled: Array = []
	for _t in 40:
		var trip: Array = _run.roll_rune_candidates(m)
		if trip.all(func(c): return ROWS.has(String((c as Dictionary).get("id", "")))) and trip.size() == 3:
			rolled = trip
			break
	ok(not rolled.is_empty(), "§2c: forty rolls with the Old Gods equipped gave no triple of three rows")
	if rolled.is_empty():
		_run.sim_run = had
		return
	m["rune_candidates"] = [rolled.duplicate()]
	m["rune_picks_owed"] = 1
	var names := rolled.map(func(c): return String(c["name"]))
	# ANSWERED WITH IT EQUIPPED: the whole triple.
	var live_on: Array = _run.rune_choice(m)
	ok(live_on.size() == 3, "§2c: the triple answered with the engine equipped holds %d" % live_on.size())
	# THE POUCH'S DOOR TAKES THE ENGINE OUT — then the answer.
	ok(_run.toggle_engine(m, 0), "§2c: the pouch's door would not unequip the Old Gods")
	var live_off: Array = _run.rune_choice(m)
	ok(live_off.is_empty(), "§2c: a row was handed over with its engine unequipped — %s" % [live_off.map(func(c): return c["name"])])
	var withheld: Array = _run.rune_choice_withheld(m)
	ok(withheld.size() == 3, "§2c: the withheld list names %d, not the three that sit out" % withheld.size())
	# STORED, NOT REPAIRED AWAY.
	var stored: Array = (m["rune_candidates"] as Array)[0]
	ok(str(stored.map(func(c): return String(c["name"]))) == str(names),
		"§2c: the answer rewrote the stored triple — the rows were repaired away, not sat out")
	print("    a cache rolled with the Old Gods equipped %s; answered unequipped it offers %d and keeps %d stored" % [
		names, live_off.size(), stored.size()])
	# AND THE ENGINE BACK: THE SAME THREE, IN THE SAME ORDER — NOT A REROLL.
	ok(_run.toggle_engine(m, 0), "§2c: the pouch's door would not equip the Old Gods again")
	var back: Array = _run.rune_choice(m)
	ok(str(back.map(func(c): return String(c["name"]))) == str(names),
		"§2c: with the engine back the cache offers %s, not the three it rolled" % [back.map(func(c): return c["name"])])
	# THE LIVE SCREEN: the overlay's words, its buttons, and the pick.
	await _s2c_the_screen(rolled)
	# THE BARGAIN, THROUGH ITS OWN DOOR: a rune reward claimed on victory rolls
	# for a hero it can pay, and a party whose lineage engines are all unequipped
	# is paid no row — and the same party equipped is.
	var bargain_rows := {true: 0, false: 0}
	for equip in [false, true]:
		for _t2 in 12:
			_run.new_run(SEATS, [], "standard")
			for i in _run.party.size():
				var sp: String = ["berserker", "arcanist", "occultist", "sharpshooter"][i]
				var mm := _member(sp, equip)
				for k in mm:
					_run.party[i][k] = mm[k]
			_run.pending_reward = {"kind": "rune"}
			_run.claim_reward()
			for m2 in _run.party:
				for trip3 in m2.get("rune_candidates", []):
					for c3 in trip3:
						if ROWS.has(String((c3 as Dictionary).get("id", ""))):
							bargain_rows[equip] = int(bargain_rows[equip]) + 1
	print("    the bargain's rune reward, twelve claims an arm: %d rows unequipped, %d equipped" % [
		bargain_rows[false], bargain_rows[true]])
	ok(int(bargain_rows[false]) == 0, "§2c: a bargain paid a row to a hero whose engine is unequipped")
	ok(int(bargain_rows[true]) > 0, "§2c: twelve bargains with every engine equipped paid no row — the gate refuses everyone")
	_run.sim_run = had


# The pick overlay on the real map, with a cache of three rows queued for the
# Occultist: unequipped — no rune button, the engine named, the pick not spent by
# opening it; equipped — three buttons, and the one pressed is the one handed over.
func _s2c_the_screen(rolled: Array) -> void:
	_fresh_meta()
	_run.sim_run = true
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ["berserker", "arcanist", "occultist", "sharpshooter"][i]
		_run.party[i]["engines"] = Runes.engine_pouch_for_spec(String(_run.party[i]["spec"]))
	_run.specs_chosen = true
	_run.active = true
	var m: Dictionary = _run.party[2]
	var dup: Array = []
	for c in rolled:
		dup.append((c as Dictionary).duplicate(true))
	m["rune_candidates"] = [dup]
	m["rune_picks_owed"] = 1
	(m["engines"][0] as Dictionary)["equipped"] = false
	var screen: Node = load("res://scenes/map.tscn").instantiate()
	root.add_child(screen)
	await Gate.frames(self, 3)
	screen.call("_open_pick_overlay", 2)
	await Gate.frames(self, 2)
	var ov: Node = Gate.overlay(screen, 60)
	ok(ov != null, "§2c: the pick overlay did not open")
	if ov != null:
		var btn_texts: Array = []
		var btns: Array = []
		Gate.buttons(ov, btns)
		for b in btns:
			btn_texts.append(String((b as Button).text))
		for c2 in rolled:
			ok(not btn_texts.any(func(t): return String(t).begins_with(String(c2["name"]))),
				"§2c: the overlay drew %s as a button with the Old Gods unequipped" % c2["name"])
		ok(Gate.has_text(ov, "Rune of the Occultist is not equipped"),
			"§2c: the overlay does not say the runes wait on the Rune of the Occultist")
		ok(not Gate.has_text(ov, "nothing can arrive to fill it"),
			"§2c: the overlay says nothing can arrive, and equipping the engine would fill it")
		ok(btn_texts.has("Let it go") and btn_texts.has("Not yet"),
			"§2c: the overlay offers %s — the pick can be neither spent nor kept" % [btn_texts])
		print("    the overlay, unequipped: %s" % [btn_texts])
		Gate.press(ov, ["Not yet"])
		await Gate.frames(self, 2)
	ok(int(m.get("rune_picks_owed", 0)) == 1, "§2c: closing the overlay spent the pick")
	# EQUIPPED AGAIN: the three are buttons, and the pressed one is handed over.
	(m["engines"][0] as Dictionary)["equipped"] = true
	screen.call("_open_pick_overlay", 2)
	await Gate.frames(self, 2)
	var ov2: Node = Gate.overlay(screen, 60)
	if ov2 != null:
		var btn2: Button = null
		var btns2: Array = []
		Gate.buttons(ov2, btns2)
		for b2 in btns2:
			if String((b2 as Button).text).begins_with(String(rolled[1]["name"])):
				btn2 = b2
		ok(btn2 != null, "§2c: with the Old Gods equipped the overlay has no button for %s" % rolled[1]["name"])
		if btn2 != null:
			btn2.emit_signal("pressed")
			await Gate.frames(self, 2)
	var got_names: Array = (m.get("runes", []) as Array).map(func(r): return String(r["name"]))
	ok(got_names.has(String(rolled[1]["name"])),
		"§2c: pressing %s handed over %s" % [rolled[1]["name"], got_names])
	ok(int(m.get("rune_picks_owed", 0)) == 0, "§2c: the pick taken did not spend the pick")
	# A CACHE THAT IS PART ROW: the Berserker's Open Vein beside two runes that
	# read no engine, answered with Blood Frenzy unequipped. The row sits out and
	# the line says one more waits; and THE BUTTON PRESSED IS THE RUNE HANDED
	# OVER — the second button shows the THIRD stored rune, so a pick that
	# indexed the stored triple would hand over the wrong one.
	# **BATCH HE §1 — THE THIRD WAS SLAUGHTERHOUSE, AND IT IS BLOOD FRENZY'S NOW**
	# (a ruled row), so the cache held two rows and drew one button. Long Watch
	# reads no engine and takes its place: the arm's shape is unchanged.
	var bz: Dictionary = _run.party[0]
	bz["rune_candidates"] = [[Runes.build("open_vein"), Runes.build("last_word"),
		Runes.build("long_watch")]]
	bz["rune_picks_owed"] = 1
	(bz["engines"][0] as Dictionary)["equipped"] = false
	screen.call("_open_pick_overlay", 0)
	await Gate.frames(self, 2)
	var ov3: Node = Gate.overlay(screen, 60)
	var pressed_name := ""
	if ov3 != null:
		ok(Gate.has_text(ov3, "1 more that waits on the Rune of the Berserker being equipped"),
			"§2c: a part-row cache does not say what else it holds")
		var rune_btns: Array = []
		var btns3: Array = []
		Gate.buttons(ov3, btns3)
		for b3 in btns3:
			var t3 := String((b3 as Button).text)
			if t3.begins_with("Open Vein"):
				ok(false, "§2c: Open Vein was drawn as a button with Blood Frenzy unequipped")
			if t3.begins_with("Last Word") or t3.begins_with("Long Watch"):
				rune_btns.append(b3)
		ok(rune_btns.size() == 2, "§2c: the part-row cache drew %d rune buttons, not two" % rune_btns.size())
		if rune_btns.size() == 2:
			pressed_name = String((rune_btns[1] as Button).text).get_slice("  [", 0)
			(rune_btns[1] as Button).emit_signal("pressed")
			await Gate.frames(self, 2)
	var bz_names: Array = (bz.get("runes", []) as Array).map(func(r): return String(r["name"]))
	print("    a part-row cache, Blood Frenzy unequipped: pressed %s, handed over %s" % [pressed_name, bz_names])
	ok(pressed_name != "" and bz_names == [pressed_name],
		"§2c: pressing %s handed over %s — the pick read the stored triple, not the offer" % [pressed_name, bz_names])
	screen.queue_free()
	await Gate.frames(self, 3)
	_run.active = false


# The Peddler's own screen, rolled in `_ready`: a party whose four lineage heroes
# have their engines unequipped is shown no row, and equipped, is shown rows.
func _s2d_the_peddler() -> void:
	var specs := ["berserker", "arcanist", "occultist", "sharpshooter"]
	var seen_rows := {true: 0, false: 0}
	for equip in [false, true]:
		for _visit in 12:
			_fresh_meta()
			_run.sim_run = true
			_run.new_run(SEATS, [], "standard")
			for i in _run.party.size():
				_run.party[i]["awakened"] = true
				_run.party[i]["spec"] = specs[i]
				var eng: Array = Runes.engine_pouch_for_spec(specs[i])
				(eng[0] as Dictionary)["equipped"] = equip
				_run.party[i]["engines"] = eng
			_run.specs_chosen = true
			_run.active = true
			_run.gold = 0
			var shop: Node = load("res://scenes/shop.tscn").instantiate()
			root.add_child(shop)
			await Gate.frames(self, 2)
			for o in shop.get("offers"):
				var rid := String(((o as Dictionary)["rune"] as Dictionary).get("id", ""))
				if ROWS.has(rid):
					seen_rows[equip] = int(seen_rows[equip]) + 1
					if not equip:
						ok(false, "§2d: the Peddler offered the row %s to a hero whose engine is unequipped" % rid)
			shop.queue_free()
			await Gate.frames(self, 2)
			_run.active = false
	print("    the Peddler, twelve visits an arm: %d rows offered unequipped, %d equipped" % [
		seen_rows[false], seen_rows[true]])
	ok(int(seen_rows[true]) > 0, "§2d: twelve Peddler visits with every engine equipped offered no row — the gate refuses everyone")


# ── §3 — WHAT A HERO CAN BE OFFERED ─────────────────────────────────────────
#
# **BATCH HC §3 — PER CLASS, AND THE NUMBER THE DESIGN PASS STARTS FROM.** GV's
# form asked what a LINEAGE could be offered, because the scope was the lineage.
# The scope is the class since HC §1, so the question is the brief's: a hero of
# each class with NO engine, with EACH single engine, and with EVERY pair — AT
# SPAWN (his opening kit and his slotted engines) and at the CEILING (every card
# his class draft pool and his lineage's boss pool hold, drafted). **The counts
# and the names are PRINTED** — how many a class should hold is the design
# pass's. **The one count asserted is the no-engine half's FLOOR (HD §3, ruled)**,
# which IS a second copy of HC §3's table on purpose: it is `RUNE_FLOOR`, a floor
# and never an equality, with the Cleric's zero owed rather than asserted.
# **What is asserted is how the gates compose**: with no engine he is offered
# exactly the class's runes that no gate withholds; a single engine opens its
# own rows and no other engine's; a pair's offer is its two singles' union, less
# every rune that needs a companion when either dismisses the pet.

# One hero of `cls`, lineage `lineage`, holding `engines` slotted; at the
# ceiling his whole draftable set is drafted. His ordinary offer, sorted.
func _offer(cls: String, lineage: String, engines: Array, ceiling: bool) -> Array:
	var eng: Array = []
	for pid in engines:
		var r: Dictionary = Runes.build(Runes.engine_rune_id(String(pid)))
		r["equipped"] = true
		eng.append(r)
	var cards: Array = []
	if ceiling:
		cards = Classes.draft_pool(cls).duplicate()
		for n in Classes.spec_pool(lineage):
			if not cards.has(n):
				cards.append(n)
	var m := {"key": cls, "spec": lineage, "runes": [], "bm_abilities": cards,
		"bm_equipped": cards.duplicate(), "engines": eng, "awakened": true}
	var out: Array = Runes.eligible_ids(m, []).filter(
		func(i): return not Runes.is_engine_rune(String(i)))
	out.sort()
	return out


func _names(ids: Array) -> Array:
	var out: Array = []
	for id in ids:
		out.append(String(Runes.config(String(id)).get("name", id)))
	return out


func _s3_what_can_be_offered() -> void:
	print("\n§3 — what a hero can be offered: per class, no engine, each engine and every pair")
	for cls in SEATS:
		var mine: Array = _ordinary().filter(
			func(i): return String(Runes.config(String(i)).get("scope", "")) == "class:" + cls)
		# THE SET NO GATE WITHHOLDS FROM A HERO HOLDING NOTHING: not a row, no card
		# to name, and — with no dismisser slotted — any rune needing a companion.
		var free: Array = mine.filter(func(i): return (not ROWS.has(String(i))
			and String(Runes.config(String(i)).get("requires_ability", "")) == ""))
		free.sort()
		var bare_sp := _offer(cls, "", [], false)
		var bare_ce := _offer(cls, "", [], true)
		print("    %s — %d ordinary runes. NO ENGINE: %d at spawn, %d at the ceiling" % [
			cls.to_upper(), mine.size(), bare_sp.size(), bare_ce.size()])
		print("      at spawn: %s" % (", ".join(_names(bare_sp)) if not bare_sp.is_empty() else "(none)"))
		ok(bare_sp == free,
			"§3: a %s holding no engine is offered %s at spawn, not the %d runes no gate withholds (%s)" % [
				cls, _names(bare_sp), free.size(), _names(free)])
		ok(not bare_ce.any(func(i): return ROWS.has(String(i))),
			"§3: a %s holding no engine can be offered a row at the ceiling — %s" % [
				cls, _names(bare_ce.filter(func(i): return ROWS.has(String(i))))])
		# HD §3 — THE NO-ENGINE FLOOR, OFF HC's TABLE (the const above says why).
		var fl: Array = RUNE_FLOOR[cls]
		# BATCH HE §1 — EACH HALF IS FLOORED OR OWED ON ITS OWN: a zero asserts
		# nothing, and since HE a class can read zero at spawn and not at the
		# ceiling (the Mage). A half at zero prints OWED and notices the day it rises.
		var halves := [["at spawn", bare_sp.size(), int(fl[0])], ["at the ceiling", bare_ce.size(), int(fl[1])]]
		for hf in halves:
			if int(hf[2]) > 0:
				ok(int(hf[1]) >= int(hf[2]),
					"§3 floor: a %s holding no engine is offered %d %s, below its floor of %d — the no-engine half thinned (HD §3; the floor moved at HE §1)" % [
						cls, int(hf[1]), hf[0], int(hf[2])])
			else:
				print("      OWED (HD §3): a %s holding no engine is offered %d %s — a floor of zero asserts nothing, and the rune design pass owes this class runes that read no engine" % [
					cls, int(hf[1]), hf[0]])
				if int(hf[1]) > 0:
					print("      NOTICE (HD §3): the owed floor has arrived — %s's no-engine offer %s is %d; RUNE_FLOOR is owed its reading" % [
						cls, hf[0], int(hf[1])])
		var engs: Array = Classes.class_engines(cls)
		# AND THE ARM THAT STILL MEANS SOMETHING FOR AN OWED ROW: some engine of his
		# class opens a rune at spawn. It goes red the day a hero of the class can
		# be offered nothing by any engine he can slot.
		var best_single := 0
		for pid0 in engs:
			best_single = maxi(best_single,
				_offer(cls, Classes.engine_spec(String(pid0)), [pid0], false).size())
		ok(best_single >= 1,
			"§3 floor: no engine a %s can slot opens a single rune at spawn — a hero of the class can be offered nothing (HD §3)" % cls)
		for pid in engs:
			var lin := Classes.engine_spec(String(pid))
			var one_sp := _offer(cls, lin, [pid], false)
			var one_ce := _offer(cls, lin, [pid], true)
			var leak: Array = one_ce.filter(
				func(i): return ROWS.has(String(i)) and String(ROWS[String(i)]) != String(pid))
			ok(leak.is_empty(), "§3: a %s holding %s alone is offered another engine's row — %s" % [
				cls, pid, _names(leak)])
			var dis: bool = Classes.dismisses_pet([String(pid)])
			var missing: Array = mine.filter(func(i): return (String(ROWS.get(String(i), "")) == String(pid)
				and not one_ce.has(String(i)) and not (dis and Runes.reads_companion(String(i)))))
			ok(missing.is_empty(), "§3: a %s holding %s is never offered its own rows %s" % [
				cls, pid, _names(missing)])
			print("      %-22s %2d at spawn, %2d at the ceiling — spawn: %s" % [
				Classes.engine_title(String(pid)), one_sp.size(), one_ce.size(),
				", ".join(_names(one_sp)) if not one_sp.is_empty() else "(none)"])
		var best := -1
		var best_label := ""
		var best_names: Array = []
		for x in engs.size():
			for y in range(x + 1, engs.size()):
				var pa := String(engs[x])
				var pb := String(engs[y])
				var la := Classes.engine_spec(pa)
				var pair_ce := _offer(cls, la, [pa, pb], true)
				var dis2: bool = Classes.dismisses_pet([pa, pb])
				var want: Array = []
				for i in _offer(cls, la, [pa], true) + _offer(cls, la, [pb], true):
					if not want.has(i) and not (dis2 and Runes.reads_companion(String(i))):
						want.append(i)
				want.sort()
				ok(pair_ce == want,
					"§3: a %s holding %s and %s is offered %d, not the %d its two engines open — the gates are not an AND" % [
						cls, pa, pb, pair_ce.size(), want.size()])
				if pair_ce.size() > best:
					best = pair_ce.size()
					best_label = "%s + %s" % [Classes.engine_title(pa), Classes.engine_title(pb)]
					best_names = _names(pair_ce)
		print("      the best pair on %s's lineage: %s — %d at the ceiling: %s" % [
			best_label.get_slice(" + ", 0), best_label, best, ", ".join(best_names)])


# ── §4 — A WHOLE RUN PER ARM ────────────────────────────────────────────────

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


const ROAD_SEED := 20260919
const MAX_STEPS := 900
const FRAME_CAP := 30000
# THREE ROADS FOR THE ARM WITH EVERY ENGINE UNEQUIPPED, SO EVERY LINEAGE WALKS
# ONE: a party is one hero of each class, and "no row reaches him" is a claim
# about all twelve lineages' engines. *(Since HC §1 a rune reaches every hero of
# its class, so each road already puts every row of a class in front of its hero;
# the three still walk every lineage, which is what the arm was built to cover.)*
# ONE ROAD FOR THE ARM HOLDING TWO ENGINES — its claim is that rows DO reach a
# holder, and since HC the second engine's rows reach him as well as his own.
const ROADS := [
	["berserker", "arcanist", "occultist", "sharpshooter"],
	["warden", "pyromancer", "holy", "beastmaster"],
	["swordmaster", "cryomancer", "inquisitor", "mystic"],
]

var _bare := false
var _shown := {}        # lineage -> {rune name: the doors that showed it}
var _doors := {}        # door -> offers read there
var _leaks: Array = []
var _stall := ""
var _battles := 0
var _set_aside := 0


func _where() -> String:
	return "zone %d slot %d" % [int(_run.zone_idx) + 1, int(_run.slot_idx) + 1]


# ONE OFFER, READ AS THE PLAYER IS SHOWN IT: a row offered to a hero whose
# engine is not equipped is the leak this batch closes.
func _record(idx: int, rune: Dictionary, door: String) -> void:
	var m: Dictionary = _run.party[idx]
	var spec := String(m.get("spec", ""))
	var id := String(rune.get("id", ""))
	var seen: Dictionary = _shown.get(spec, {})
	var nm := String(rune.get("name", id))
	var at: Array = seen.get(nm, [])
	if not at.has(door):
		at.append(door)
	seen[nm] = at
	_shown[spec] = seen
	_doors[door] = int(_doors.get(door, 0)) + 1
	var eng := Runes.engine_read(id)
	if eng != "" and not Runes.held_engines(m).has(eng):
		_leaks.append("%s shown %s at the %s with %s unequipped, %s" % [spec, nm, door, eng, _where()])


func _unequip_all() -> int:
	var n := 0
	for m in _run.party:
		var held: Array = m.get("engines", [])
		for i in held.size():
			if bool((held[i] as Dictionary).get("equipped", false)) and _run.toggle_engine(m, i):
				n += 1
	return n


func _answer_draft(s: Node) -> void:
	for m in _run.party:
		var guard := 0
		while int(m.get("draft_picks_owed", 0)) > 0 and guard < 8:
			guard += 1
			var queue: Array = m.get("draft_candidates", [])
			var took := false
			for card in (queue[0] if not queue.is_empty() else []):
				var bench := ""
				if _run.ability_slots_full(m):
					var carried: Array = _run.equipped_ability_names(m)
					for e in _run.earned_ability_names(m):
						if carried.has(e):
							bench = String(e)
							break
					if bench == "":
						break
				if _run.take_draft_ability(m, String(card), bench) == "":
					took = true
					break
			if not took:
				_run.decline_draft(m)
	if s.has_method("_close_party_draft"):
		s.call("_close_party_draft")
	await Gate.frames(self, 2)


func _answer_pick(s: Node, idx: int) -> void:
	var m: Dictionary = _run.party[idx]
	if int(m.get("rune_picks_owed", 0)) > 0:
		for c in _run.rune_choice(m):
			_record(idx, c, "cache or bargain")
	var choose: Button = Gate.bound_button(s, "_open_pick_overlay", [idx])
	var ov: Node = null
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
		ov = Gate.overlay(s, 60)
	var live: Array = []
	if ov != null:
		var btns: Array = []
		Gate.buttons(ov, btns)
		for b in btns:
			if String((b as Button).text) != "Not yet" and not (b as Button).disabled:
				live.append(b)
	if live.is_empty():
		_stall = "hero %d owed a pick at %s and nothing could be pressed" % [idx, _where()]
		for k in ["bm_picks_owed", "up_picks_owed", "rune_picks_owed"]:
			m[k] = 0
		if ov != null:
			ov.queue_free()
		await process_frame
		return
	(live[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 2)
	var still: Node = Gate.overlay(s, 60)
	if still != null:
		still.queue_free()
		await process_frame


func _step_map(s: Node) -> String:
	if Gate.overlay(s, 62) != null:
		await _answer_draft(s)
		return "draft"
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		if int(m.get("bm_picks_owed", 0)) > 0 or int(m.get("up_picks_owed", 0)) > 0 \
				or int(m.get("rune_picks_owed", 0)) > 0:
			await _answer_pick(s, idx)
			return "pick"
	var live: Array = Gate.lattice_buttons(s)
	if live.is_empty():
		return ""
	(live[0] as Button).emit_signal("pressed")
	await Gate.frames(self, 3)
	return "step"


func _fight(s: Node) -> String:
	var guard := 0
	while not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	if guard >= FRAME_CAP:
		return "a battle never ended in %d frames" % FRAME_CAP
	await Gate.frames(self, 6)
	_battles += 1
	if Gate.press(s, ["Continue", "Descend into", "Walk on", "Onward"]) != "":
		return "on"
	if Gate.has_text(s, "New Run"):
		return "the run ENDED"
	return "the battle's card drew nothing to press"


func _leave(s: Node, nm: String) -> String:
	match nm:
		"Shop":
			for o in s.get("offers"):
				_record(int((o as Dictionary)["member_idx"]), (o as Dictionary)["rune"], "Peddler")
			return Gate.press(s, ["Leave the Shop"])
		"Offer":
			var btns: Array = []
			Gate.buttons(s, btns)
			for b in btns:
				if String((b as Button).text) == "Take this bargain" and not (b as Button).disabled:
					(b as Button).emit_signal("pressed")
					return "bargain"
			return Gate.press(s, ["Walk on", "Leave", "Onward"])
		"Event":
			var before: Array = []
			for m in _run.party:
				before.append((m.get("runes", []) as Array).size())
			var choice := Gate.press(s, [""])
			if choice == "":
				return ""
			await Gate.frames(self, 3)
			for i in _run.party.size():
				var now: Array = _run.party[i].get("runes", [])
				for j in range(int(before[i]), now.size()):
					_record(i, now[j], "event")
			var on := Gate.press(s, ["Continue"])
			return choice if on == "" else on
		"Blacksmith":
			return Gate.press(s, ["Leave the forge", "Walk on"])
	return Gate.press(s, ["Leave", "Walk on", "Onward", "Continue", "Depart"])


func _road(lineup: Array, bare: bool) -> void:
	_bare = bare
	_stall = ""
	_battles = 0
	_fresh_meta()
	seed(ROAD_SEED)
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var spec := String(lineup[i])
		_run.party[i]["spec"] = spec
		_run.party[i]["awakened"] = true
		_run.party[i]["tree"] = Talents.generate_tree(spec, SEATS[i])
		var held: Array = Runes.engine_pouch_for_spec(spec)
		(held[0] as Dictionary)["equipped"] = not bare
		if not bare:
			for pid in Classes.class_engines(SEATS[i]):
				if String(pid) != Classes.engine_of_spec(spec):
					var r: Dictionary = Runes.build(Runes.engine_rune_id(String(pid)))
					r["equipped"] = true
					held.append(r)
					break
		_run.party[i]["engines"] = held
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)
	for _step in MAX_STEPS:
		await Gate.frames(self, 2)
		if _bare:
			_set_aside += _unequip_all()
		var sc: Node = current_scene
		if sc == null or sc.is_queued_for_deletion():
			continue
		var nm := Gate.scene_name(self)
		if nm == "Map":
			if not bool(_run.active):
				break
			if await _step_map(sc) == "":
				_stall = "nothing pressable on the map at %s" % _where()
				break
		elif nm == "Battle":
			var out := await _fight(sc)
			if out != "on":
				if out != "the run ENDED":
					_stall = "%s, at %s" % [out, _where()]
				break
		elif nm == "MainMenu":
			break
		elif await _leave(sc, nm) == "":
			_stall = "no way off the %s screen at %s" % [nm, _where()]
			break
	print("    [%s, %s] %d battles, stopped at %s" % [
		"no engine" if bare else "two engines", "/".join(lineup), _battles, _where()])
	ok(_stall == "", "§4 [%s]: the road stopped — %s" % [lineup, _stall])
	_run.active = false


func _s4_the_road() -> void:
	print("\n§4 — a whole run per arm, on the real screens")
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	for bare in [true, false]:
		_shown = {}
		_doors = {}
		_leaks = []
		_set_aside = 0
		for lineup in (ROADS if bare else [ROADS[0]]):
			await _road(lineup, bare)
		var arm := "no engine" if bare else "two engines"
		var rows_shown := 0
		for spec in _shown:
			var names: Array = (_shown[spec] as Dictionary).keys()
			names.sort()
			# BATCH HC §1 — ANY ROW, WHOSEVER LINEAGE IT WAS WRITTEN FOR: at the
			# class scope a hero holding two engines is shown the second's rows too,
			# so counting only his own lineage's would under-read the arm this
			# count is the positive of. A row shown with its engine OUT is still
			# `_leaks`' to catch, per offer.
			for nm in names:
				for id in ROWS:
					if String(Runes.config(String(id)).get("name", "")) == String(nm):
						rows_shown += 1
			print("      [%s] %-12s was shown %d: %s" % [arm, Classes.SPEC_INFO[spec]["name"],
				names.size(), ", ".join(names)])
		print("      [%s] offers read by door: %s; rows among them: %d; engines set aside: %d" % [
			arm, str(_doors), rows_shown, _set_aside])
		ok(_leaks.is_empty(), "§4 [%s]: a row was shown with its engine unequipped — %s" % [arm, _leaks])
		ok(int(_doors.get("Peddler", 0)) > 0, "§4 [%s]: the whole runs visited no Peddler — the door was not driven" % arm)
		ok(int(_doors.get("cache or bargain", 0)) > 0, "§4 [%s]: the whole runs answered no cache — the door was not driven" % arm)
		if bare:
			ok(rows_shown == 0, "§4 [no engine]: %d rows were shown" % rows_shown)
		else:
			ok(rows_shown > 0, "§4 [two engines]: a whole run showed a party holding two engines apiece no row — the gate refuses everyone")
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0


# ── §5 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s5_the_players_files() -> void:
	print("\n§5 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§5: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§5: %s is byte for byte as this gate found it" % p)
