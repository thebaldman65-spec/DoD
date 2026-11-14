# THE GATE FOR THE PARTY's THREE ANSWERS, BUILT.
#
#   §0   JP's FOUR RULINGS answered and archived; the batch's own figures and names each owed as a ruling with its reversal; the
#        three answers stated where the game is described (H02).
#   §1   FORSAKEN: a body that dies carrying it gives the warband nothing — no kill's worth (C01) and no overkill (C02) — while the
#        damage term stands (C03); an unmarked body still feeds both (C04); a Raise stands a body up unmarked, so its second fall
#        feeds again (C05); every way a body of the warband dies reaches the condition — a strike, a tick, the debug kill (C06).
#   §2   THE CLEANSE AIMS: a single-pick cleanse takes a hex if the body carries one (C08), else the harmful status with the most
#        turns left (C09), the same every time (C07); every caller still calls it and the live ones are driven; the multi-pick
#        cleanses take everything, as they did (C10); the four hexes are a list, said to be one, and no data marks them (C11).
#   §3   THE PUNISH: Read the Tell deals more against a body whose declared move cools, by the turn, and nothing more against a
#        basic (C12); it is a card's own blow, no talent's and no rune's (C13); the plate's hover says the cooldown before the cast
#        (C14); a move's worth is not in the game (C15).
#   §4   THE COUNT's FIGHTS: one fight a warband kind with the warband's attacks on, on autoplay, through the fixture's door, the
#        three answers' cards seated, every fight's log printed and its counts beside how many fights it was taken over; and the
#        kept count taken over the fights where the warband attacks, every row saying how many (C18).
#   §5   WHAT IS DELIBERATELY NOT DONE: no drain in the strike loop and no field on `Ability` (C16); no dial pulled (C17); the deck
#        closed at twenty-five (C19).
#   §6   the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them — but for the three blocks' headings §0 reads, which are
#   named for their batches. Every new member is asked for before it is read, so HEAD's code reds here (H01) rather than throwing.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jq.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SPECS := ["berserker", "cryomancer", "holy", "mystic"]
const SCRATCH_PROFILE := "user://jq_profile.json"
const SCRATCH_RELICS := "user://jq_relics.json"
const SEED := 20261107
const TRIALS := 24
const FRAME_CAP := 30000
# BATCH JR — A KIND WHOSE FIGHT STRUCK NO BLOW IS FOUGHT AGAIN ON THE NEXT SEED, at most this many times (§4).
const MAX_RETRIES := 5
const RETRY_SEED := 1000
const DECK_CLOSED_AT := 25
# THE THREE ANSWERS' CARDS AND THE TWO SINGLE-PICK CLEANSE CARDS, EACH ON THE SEAT OF ITS CLASS (warrior, mage, cleric, hunter).
const PUNISH_CARD := "Read the Tell"
const MARK_CARD := "Forsake"
const SEATED := {0: ["Read the Tell"], 1: ["Dispel"], 2: ["Forsake"], 3: ["Field Dressing"]}
const MARK_ID := "forsaken"
const HEXES := ["gall", "sap", "mire", "fester"]
# THE SIX CALLS OF THE SINGLE-PICK CLEANSE, BY FUNCTION: Dispel and Field Dressing in the handlers, the Rune of the Medic, and the
# turn-start block's three (On the Mend, Cleansing Waters, and the talent with Fellowship's kept read).
const CLEANSE_CALLS := {"_resolve_special": 2, "_field_kit_mend": 1, "_run_battle": 3}
# WHAT `Ability` CARRIES, AS JP LANDED IT: a field added here is a field a blow could carry into the strike loop (C16).
const ABILITY_VARS_MD5 := "6c2b8438eb478db682d0e8dd4741c4df"
# THE WARBAND's DATA AND THE DECK, AS JP LANDED THEM (C17, C19): the digests `check_jp` §3 holds, taken the same way.
const WARBAND_MD5 := "f261e6345f22f42bc41a7f81276e066b"
# BATCH JR — THREE APPEARANCE TAGS MOVED AFTER THIS GATE LANDED (JR §1): the Grave Totem and the Rot Behemoth each took a
# roster, the Orc Hexer a second role. Each is named here and put back before the digest, so it goes on asking whether
# anything else in the warband's data moved.
const MOVED_SINCE := {"grave_totem": {"zones": [1.0, 3.0]}, "behemoth": {"zones": [2.0, 3.0]}, "hexer": {"roles": ["hexer"]}}
# BATCH JS — SEVEN KINDS AND TWO ROSTERS JOINED THE WARBAND AFTER THIS GATE LANDED (JS §1–§3): the Frozen Plains' six and its
# boss, and rosters 4 and 5 on the kinds tagged for all three old rosters. Each is named here and read apart, so this gate goes on
# asking its own question of the warband its batch left; `check_js` holds the seven.
# BATCH JU §1 — AND THE FOUR KINDS JU ADDED TO THE FOREST OF OLD, set aside as JS's seven are: this gate holds the warband its
# batch left, and a kind added after it is no figure of that warband moving.
const ADDED_SINCE := ["frostbitten_thrall", "icebound_bulwark", "hailcaster", "rimehorn", "hoarfrost_warden", "stillwrought", "icewrought_titan",
	"grave_husk", "mossback", "blight_speaker", "carrion_pack",
	# BATCH JW §1 — AND THE DROWNED BARROW's THREE, set aside as JS's seven and JU's four are.
	"rotfiend", "fen_lurker", "bone_shepherd"]
# BATCH JW §1 — and roster 6, the Drowned Barrow's, which the travelling core takes as it took 4 and 5.
const ROSTERS_SINCE := [4, 5, 6]
const DECK_MD5 := "1d1f37491e4611bb78f94577074ede99"
const CLERIC_CUT := 0.5
# THE RECORD's NEEDLES — the rules' own words where they stand.
const ANSWERED := "all accepted as taken"
const OWED_HEAD := "### JP's RULINGS OWED"
const STRUCK_HEAD := "### ~~JP's RULINGS OWED~~"
const NEW_OWED_HEAD := "### JQ's RULINGS OWED"
const REVERSAL := "**Reversing it**"
const RULE_MARK := "A body that dies Forsaken feeds the warband no Malice"
const RULE_CLEANSE := "takes a hex if the hero carries one, and otherwise the harmful effect with the most turns left"
const RULE_PUNISH := "for each turn of cooldown on the move the target has declared"
const LIST_SAID := "NOT A DERIVATION"
const KEPT_COUNT := "res://docs/reports/JQ-count.tsv"
const COUNT_HEAD := ["what", "name", "count", "the attacking fights it is taken over"]
const COUNTED := ["Forsaken laid", "a body died Forsaken", "a single-pick cleanse took a hex", "a single-pick cleanse took something else",
	"Read the Tell landed against a cooling move", "Read the Tell landed against no cooling move"]

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR THE PARTY's THREE ANSWERS, BUILT")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH), "§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s0_the_record()
	await _s1_forsaken()
	await _s1_every_death()
	await _s1_the_raise()
	await _s2_the_cleanse()
	await _s3_the_punish()
	await _s4_the_fights()
	_s4_the_kept_count()
	_s5_not_done()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true).strip_edges()


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


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


func _bc() -> Dictionary:
	return (load("res://scripts/battle.gd") as Script).get_script_constant_map()


func _uc() -> Dictionary:
	return (load("res://scripts/unit.gd") as Script).get_script_constant_map()


# THE BOARD EVERY DRIVE STANDS ON: the fixture's own, the warband's turns held off so only this gate moves a body, the dice's blows
# made plain (no Block, no parry, no crit), and the three answers' cards seated on their classes as a player gets them.
func _board() -> Node:
	var over := {}
	for seat in SEATED:
		over[seat] = {"bm_abilities": (SEATED[seat] as Array).duplicate()}
	var s: Node = await Gate.spawn(self, SPECS, {"deterministic": true, "party": over})
	Engine.time_scale = 1.0
	return s


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


func _card(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if String((a as Ability).display_name) == name:
			return a
	return null


func _pool(s: Node, n: int) -> void:
	s.set("malice", n)
	s.set("_malice_dealt", 0)


func _malice(s: Node) -> int:
	return int(s.get("malice"))


# A body made whole and plain: full health, an empty meter, nothing declared, nothing laid.
func _whole(u: BattleUnit) -> void:
	u.dead = false
	u.hp = u.max_hp
	u.pressure = 0
	u.broken = false
	u.intent = {}
	u.bleed_buildup = 0
	for st in u.statuses.duplicate():
		u.remove_status(String((st as Dictionary).get("id", "")))


# The mark laid through the status door — only where the tree has the status, so HEAD's code reds §1 rather than throwing.
func _mark(s: Node, u: BattleUnit, by: BattleUnit) -> void:
	if (_bc().get("STATUS_INFO", {}) as Dictionary).has(MARK_ID):
		s._apply_status(u, MARK_ID, int(_bc().get("FORSAKE_TURNS", 3)), 0, 0, by)


# ── §0 — THE RECORD ───────────────────────────────────────────────────────────

func _s0_the_record() -> void:
	print("\n§0 — JP's four rulings answered and archived; the batch's own choices owed with their reversals; the answers stated")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n" + OWED_HEAD), "§0: %s is still in the open queue — it was answered" % OWED_HEAD)
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), STRUCK_HEAD))
	ok(struck != "" and struck.contains(ANSWERED), "§0: the archive holds no struck %s answered as taken" % OWED_HEAD)
	var owed := _block(state, NEW_OWED_HEAD)
	# BATCH JR — JQ's RULINGS WERE ANSWERED (JR §0) AND STAND STRUCK IN THE ARCHIVE, so they are read there once the queue lets go.
	if owed == "":
		owed = _block(_doc("res://DoD-archive/state-archive.md"), "### ~~JQ's RULINGS OWED~~")
	var items := 0
	var bare: Array = []
	for raw in owed.split("\n"):
		var line := String(raw)
		if line.length() > 3 and line[0].is_valid_int() and line.substr(1, 2) == ". ":
			items += 1
			if not line.contains(REVERSAL):
				bare.append(line.substr(0, 60))
	print("    the rulings owed: %d items" % items)
	ok(items >= 5 and bare.is_empty(), "§0: the batch's own choices are not each owed with a reversal (%d items; without one: %s)" % [items, bare])
	var master := _flat(_doc("res://docs/master.html"))
	for rule in [RULE_MARK, RULE_CLEANSE, RULE_PUNISH]:
		ok(master.contains(_flat(rule)), "§0: the master document does not say what the game now does — `%s`" % rule)


# THE WARBAND's DATA WITH A LATER BATCH's APPEARANCE TAGS PUT BACK (`MOVED_SINCE`).
func _warband_as_landed() -> Dictionary:
	var d: Dictionary = Enemies._load().duplicate(true)
	for kind in MOVED_SINCE:
		if d.has(kind):
			for field in MOVED_SINCE[kind]:
				(d[kind] as Dictionary)[field] = (MOVED_SINCE[kind][field] as Array).duplicate()
	# BATCH JS — and the seven kinds and two rosters added since (`ADDED_SINCE`, `ROSTERS_SINCE`) taken out.
	for js_kind in ADDED_SINCE:
		d.erase(js_kind)
	for js_k in d:
		if (d[js_k] as Dictionary).has("zones"):
			(d[js_k] as Dictionary)["zones"] = ((d[js_k] as Dictionary)["zones"] as Array).filter(func(z): return not ROSTERS_SINCE.has(int(z)))
	return d


# ── §1 — FORSAKEN ─────────────────────────────────────────────────────────────

func _s1_forsaken() -> void:
	print("\n§1 — Forsaken: the kill and the overkill denied, the damage term standing, both ways")
	var bc := _bc()
	var built: bool = bc.get("FORSAKE_TURNS") != null and (bc.get("STATUS_INFO", {}) as Dictionary).has(MARK_ID)
	ok(built, "§1: the tree holds no Forsaken — no status row, no turns")
	ok((bc.get("DISPEL_NEVER", []) as Array).has(MARK_ID) and not (_uc().get("DEBUFF_IDS", []) as Array).has(MARK_ID),
		"§1: Forsaken is not the party's mark — a Dispel could take it, or a mender's Rite")
	var def: Ability = Classes.draft_ability(MARK_CARD)
	var turns := int(bc.get("FORSAKE_TURNS", -1))
	ok(def != null and String(def.special) == "forsake" and def.description.contains("for %d turns" % turns)
		and (Classes.CLASS_DRAFT_POOLS.get("cleric", []) as Array).has(MARK_CARD),
		"§1: no card on the Cleric's shelf lays Forsaken, or its words do not state the turns its constant holds")
	var s: Node = await _board()
	var hs := _heroes(s)
	var fs := _foes(s)
	var warrior: BattleUnit = hs[0]
	var cleric: BattleUnit = hs[2]
	var a: BattleUnit = fs[0]
	var b: BattleUnit = fs[1]
	var c: BattleUnit = fs[2]
	# THE CARD LAYS IT, THROUGH THE CAST's DOOR.
	var held := _card(cleric, MARK_CARD)
	if held != null:
		await s._resolve(cleric, held, a, "good")
	var st: Dictionary = a.get_status(MARK_ID)
	print("    Forsake cast on %s: %s" % [a.unit_name, str(st.get("turns", "none"))])
	ok(held != null and not st.is_empty() and int(st.get("turns", 0)) == turns,
		"§1: the Cleric's Forsake laid no Forsaken for its %d turns on the body it was cast at" % turns)
	# THE PARTY's MARK, NOT A BOON: a Mage's Dispel on the body leaves it standing.
	var dp := _card(hs[1], "Dispel")
	if dp != null and a.has_status(MARK_ID):
		hs[1].resource = hs[1].max_resource
		await s._resolve(hs[1], dp, a, "good")
	ok(dp != null and a.has_status(MARK_ID), "§1: a Dispel on the enemy stripped Forsaken, the party's own mark, as a beneficial effect")
	# THE KILL's TERM, ALONE: the death door with no damage door before it (the debug kill's own two lines).
	for pair in [[a, true], [b, false]]:
		var u: BattleUnit = pair[0]
		if bool(pair[1]) and not u.has_status(MARK_ID):
			_mark(s, u, cleric)
		_pool(s, 0)
		u.hp = 0
		u._die()
		var got := _malice(s)
		print("    %s dies %s by the death door alone: Malice +%d" % [u.unit_name, "Forsaken" if pair[1] else "unmarked", got])
		if bool(pair[1]):
			ok(got == 0, "§1: a Forsaken body's death still fed the warband its kill's worth (+%d)" % got)
		else:
			ok(got == int(bc.get("MALICE_PER_KILL", 0)) and got > 0, "§1: an unmarked body's death did not feed the kill's worth (+%d)" % got)
	# THE OVERKILL's TERM, ALONE, AND THE DAMAGE TERM BESIDE IT: the damage door, a hero's blow.
	var step := int(bc.get("MALICE_DAMAGE_STEP", 10))
	s.call("_dmg_frame", warrior, "")
	for marked in [true, false]:
		_whole(c)
		if marked:
			_mark(s, c, cleric)
		_pool(s, 0)
		s.call("_malice_on_damage", c, 3 * step, 12)
		var got2 := _malice(s)
		print("    %s takes %d past a %s last: Malice +%d" % [c.unit_name, 12, "Forsaken" if marked else "unmarked", got2])
		if marked:
			ok(got2 <= 3, "§1: a blow's overkill on a Forsaken body still fed the warband (+%d, the damage term is 3)" % got2)
			ok(got2 >= 3, "§1: a Forsaken body's damage term was denied too — a tenth of what is dealt no longer fills (+%d of 3)" % got2)
		else:
			ok(got2 == 3 + 12, "§1: an unmarked body's overkill and damage did not both feed (+%d of %d)" % [got2, 15])
	s.call("_dmg_frame", null, "")


func _s1_every_death() -> void:
	print("\n§1 — every way a body of the warband dies reaches the condition: a strike, a tick, the debug kill")
	var bc := _bc()
	var per_kill := int(bc.get("MALICE_PER_KILL", 25))
	var rows: Array = []
	# A STRIKE: 25 health left, a blow of 40 — 2 points of damage term, 15 past the last. A TICK: 3 health left, a tick of 10 a
	# hero laid — no damage term, 7 past the last. Each on a board of its own, a Forsaken body and an unmarked one.
	for door in ["a strike", "a tick"]:
		var s: Node = await _board()
		var hs := _heroes(s)
		var fs := _foes(s)
		for marked in [true, false]:
			var u: BattleUnit = fs[0] if marked else fs[1]
			_whole(u)
			if marked:
				_mark(s, u, hs[2])
			u.hp = 25 if door == "a strike" else 3
			_pool(s, 0)
			s.call("_dmg_frame", hs[0], "")
			if door == "a strike":
				u.take_hit(40, 0)
			else:
				u.take_tick_damage(10, "Burn", Color(1, 0.5, 0.2))
			s.call("_dmg_frame", null, "")
			var step := int(bc.get("MALICE_DAMAGE_STEP", 10))
			var want := ((25 / step) if door == "a strike" else (3 / step)) + (0 if marked else (15 if door == "a strike" else 7) + per_kill)
			rows.append([door, marked, u.dead, _malice(s), want])
	for r in rows:
		print("    %s on a %s body: dead %s, Malice +%d (wanted %d)" % [r[0], "Forsaken" if r[1] else "unmarked", r[2], r[3], r[4]])
		ok(bool(r[2]) and int(r[3]) == int(r[4]),
			"§1: %s that felled a %s body fed %d, not %d" % [r[0], "Forsaken" if r[1] else "unmarked", r[3], r[4]])
	# THE DEBUG KILL: every body standing felled, one Forsaken — the kill's worth for the others.
	var s2: Node = await _board()
	var fs2 := _foes(s2)
	_mark(s2, fs2[0], _heroes(s2)[2])
	var standing := fs2.size()
	_pool(s2, 0)
	s2.call("_debug_kill_enemies")
	var got := _malice(s2)
	print("    the debug kill fells %d, one Forsaken: Malice +%d" % [standing, got])
	ok(got == per_kill * (standing - 1), "§1: the debug kill fed %d for %d bodies, one Forsaken — not %d" % [got, standing, per_kill * (standing - 1)])
	await Gate.frames(self, 2)


func _s1_the_raise() -> void:
	print("\n§1 — a Raise stands a body up unmarked, so its second fall feeds the warband again")
	var bc := _bc()
	var s: Node = await _board()
	var hs := _heroes(s)
	var fs := _foes(s)
	var raiser: BattleUnit = fs[0]
	var body: BattleUnit = fs[1]
	var cfg := Enemies.config("totemist")
	raiser.abilities = cfg["abilities"]
	raiser.cooldowns = {}
	var raise: Ability = null
	for a in raiser.abilities:
		if String((a as Ability).special) == "malice_raise":
			raise = a
	ok(raise != null, "§1: the premise — the Totemist holds a Raise")
	if raise == null:
		return
	_mark(s, body, hs[2])
	_pool(s, 0)
	body.hp = 0
	body._die()
	var first := _malice(s)
	_pool(s, int(bc.get("MALICE_CAP", 150)))
	await s._resolve(raiser, raise, body, "good")
	var stood := not body.dead
	var carried := body.has_status(MARK_ID)
	_pool(s, 0)
	body.hp = 0
	body._die()
	var second := _malice(s)
	print("    the Forsaken body's first fall +%d; raised (standing %s, Forsaken %s); its second fall +%d" % [first, stood, carried, second])
	ok(first == 0, "§1: the Forsaken body's first fall fed the warband (+%d)" % first)
	ok(stood, "§1: the premise — the Raise stood the body up")
	ok(not carried, "§1: a Raised body stood up still Forsaken — the mark outlived the death that should clear it")
	ok(second == int(bc.get("MALICE_PER_KILL", 25)), "§1: the Raised body's second fall fed %d, not a kill's worth" % second)


# ── §2 — THE CLEANSE AIMS ─────────────────────────────────────────────────────

func _lay(s: Node, h: BattleUnit, src: BattleUnit, laid: Array) -> void:
	_whole(h)
	for e in laid:
		if String(e[0]) == "bleed":
			h.bleed_buildup = 30
			h.log_bleed_chip()
			continue
		s._apply_status(h, String(e[0]), maxi(int(e[1]), 1), 0, 0, src)
		if int(e[1]) < 0:
			for st in h.statuses:
				if String((st as Dictionary).get("id", "")) == String(e[0]):
					(st as Dictionary)["turns"] = -1


# What a single-pick cleanse takes off a body laid with `laid`, over TRIALS casts; [] when it takes nothing.
func _picks(s: Node, h: BattleUnit, src: BattleUnit, laid: Array) -> Dictionary:
	var got := {}
	for _i in TRIALS:
		_lay(s, h, src, laid)
		var gone := ""
		h.dispel_one_debuff()
		for e in laid:
			if not h.has_status(String(e[0])):
				gone += String(e[0])
		got[gone] = int(got.get(gone, 0)) + 1
	return got


func _s2_the_cleanse() -> void:
	print("\n§2 — the single-pick cleanse aims: a hex first, else the most turns left, every time")
	var uc := _uc()
	var hex: Variant = uc.get("HEX_IDS")
	ok(hex is Array and (hex as Array) == HEXES and HEXES.all(func(x): return (uc.get("DEBUFF_IDS", []) as Array).has(x)),
		"§2: the four hexes are not the list the cleanse reads, or one is no affliction")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var said := Gate.comment_above(usrc, usrc.find("\nconst HEX_IDS") + 1) if usrc.contains("\nconst HEX_IDS") else ""
	var said_flat := _flat(said.replace("#", " "))
	ok(said_flat.contains(LIST_SAID) and not said_flat.to_lower().contains("derived"),
		"§2: the four ids are written down and not said to be — or said to be derived")
	var marked: Array = []
	for kind in Enemies._load():
		for mv in (Enemies._load()[kind] as Dictionary).get("abilities", []):
			var ap: Dictionary = (mv as Dictionary).get("applies_status", {})
			for k in ap:
				if not ["id", "turns"].has(String(k)):
					marked.append("%s %s" % [kind, k])
	ok(marked.is_empty(), "§2: the warband's data marks something on a status it lays — derive the hexes off it: %s" % [marked])
	var s: Node = await _board()
	var hs := _heroes(s)
	var src: BattleUnit = _foes(s)[0]
	var h: BattleUnit = hs[2]
	var cases := [
		["a hex beside a longer affliction", [["sunder", 5], ["gall", 2]], "gall"],
		["two hexes beside a longer affliction", [["gall", 2], ["fester", 3], ["sunder", 6]], "fester"],
		["no hex: the most turns left", [["sunder", 2], ["exposed", 4], ["dazed", 3]], "exposed"],
		["no hex: a battle-long one outlasts", [["exposed", 4], ["slow", -1]], "slow"],
		["no hex: a tie goes to the first laid", [["sunder", 3], ["dazed", 3]], "sunder"],
		["the Bleed chip ranks last, a meter's warning", [["bleed", -1], ["sunder", 2]], "sunder"]]
	for cs in cases:
		var got := _picks(s, h, src, cs[1])
		print("    %s: %s" % [cs[0], str(got)])
		ok(got.size() == 1 and got.has(String(cs[2])) and int(got[String(cs[2])]) == TRIALS,
			"§2: %s — the cleanse took %s over %d casts, not %s every time" % [cs[0], str(got), TRIALS, cs[2]])
	# EVERY CALL STANDS.
	var calls := {}
	for fn in CLEANSE_CALLS:
		calls[fn] = Gate.fn_body("scripts/battle.gd", String(fn), _cache).count("dispel_one_debuff()")
	var total := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")).count("dispel_one_debuff()")
	print("    the calls: %s, %d in all" % [str(calls), total])
	ok(calls == CLEANSE_CALLS and total == 6, "§2: the single-pick cleanse's six calls moved: %s, %d in all" % [str(calls), total])
	# THE LIVE ONES, DRIVEN: Field Dressing on its caster, Dispel on a hero (three picks), the Rune of the Medic on the lowest hero.
	var hunter: BattleUnit = hs[3]
	var fd := _card(hunter, "Field Dressing")
	_lay(s, hunter, src, [["sunder", 5], ["gall", 2]])
	if fd != null:
		hunter.resource = hunter.max_resource
		await s._resolve(hunter, fd, hunter, "good")
	ok(fd != null and not hunter.has_status("gall") and hunter.has_status("sunder"), "§2: Field Dressing shook off the affliction, not the hex")
	var mage: BattleUnit = hs[1]
	var dp := _card(mage, "Dispel")
	var n := int(_bc().get("DISPEL_COUNT", 3))
	var dlaid := [["gall", 2], ["sunder", 5], ["dazed", 4], ["exposed", 3], ["cripple", 1]]
	# THE SURVIVORS THE AIM LEAVES, derived: the hex first, then the most turns left, n of them taken.
	var order := dlaid.duplicate()
	order.sort_custom(func(x, y): return (HEXES.has(String(x[0])) and not HEXES.has(String(y[0]))) \
		or (HEXES.has(String(x[0])) == HEXES.has(String(y[0])) and int(x[1]) > int(y[1])))
	var want_left: Array = []
	for e in dlaid:
		if order.slice(0, n).all(func(t): return String(t[0]) != String(e[0])):
			want_left.append(String(e[0]))
	_lay(s, h, src, dlaid)
	if dp != null:
		mage.resource = mage.max_resource
		await s._resolve(mage, dp, h, "good")
	var left: Array = []
	for e in ["gall", "sunder", "dazed", "exposed", "cripple"]:
		if h.has_status(e):
			left.append(e)
	print("    Dispel (%d) on gall 2, sunder 5, dazed 4, exposed 3, cripple 1 leaves %s" % [n, str(left)])
	ok(dp != null and n > 0 and left == want_left, "§2: a Dispel on a hero took the wrong %d — %s left, not %s" % [n, str(left), str(want_left)])
	var warrior: BattleUnit = hs[0]
	for hh in hs:
		(hh as BattleUnit).hp = (hh as BattleUnit).max_hp
	_lay(s, warrior, src, [["sunder", 5], ["mire", 1]])
	warrior.hp = 1
	if s.has_method("_field_kit_mend"):
		s.call("_field_kit_mend", hunter, "snared")
	ok(not warrior.has_status("mire") and warrior.has_status("sunder"), "§2: the Rune of the Medic shed the affliction, not the hex")
	# THE MULTI-PICK CLEANSES TAKE EVERYTHING, AS THEY DID.
	_lay(s, h, src, [["gall", 2], ["sunder", 5], ["dazed", 4]])
	var cleanable: int = (s.call("_cleansable_debuffs", h) as Array).size()
	var taken: int = h.purge_debuffs_taken().size()
	ok(cleanable == 3 and taken == 3 and not (h.has_status("gall") or h.has_status("sunder") or h.has_status("dazed")),
		"§2: a multi-pick cleanse no longer takes every affliction (offered %d, took %d)" % [cleanable, taken])


# ── §3 — THE PUNISH ───────────────────────────────────────────────────────────

# The data's own moves: a declared basic, a move with the shortest cooldown and one with the longest.
func _moves() -> Array:
	var basic: Ability = null
	var short: Ability = null
	var long: Ability = null
	for kind in Enemies._load():
		for ab in Enemies.config(String(kind))["abilities"]:
			var a := ab as Ability
			if a.damage <= 0:
				continue
			if a.cooldown <= 0 and basic == null:
				basic = a
			elif a.cooldown > 0 and (short == null or a.cooldown < short.cooldown):
				short = a
			if a.cooldown > 0 and (long == null or a.cooldown > long.cooldown):
				long = a
	return [basic, short, long]


func _s3_the_punish() -> void:
	print("\n§3 — Read the Tell: more by the turn of the declared move's cooldown, nothing more against a basic")
	var bc := _bc()
	var pct := int(bc.get("READ_THE_TELL_PCT", -1))
	var def: Ability = Classes.draft_ability(PUNISH_CARD)
	ok(def != null and pct > 0 and String(def.special) == "" and def.damage > 0
		and (Classes.CLASS_DRAFT_POOLS.get("warrior", []) as Array).has(PUNISH_CARD)
		and def.description.contains("%d%% more" % pct) and _flat(def.description).contains(_flat(RULE_PUNISH)),
		"§3: no card on the Warrior's shelf is the punish — an ordinary blow whose words state its figure and its condition")
	# NOT A TALENT's AND NOT A RUNE's: no node, no rune, no condition reads a declaration (premise 2).
	var tal := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/talents.gd"))
	var runes := FileAccess.get_file_as_string("res://data/runes.json") + Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/runes.gd"))
	var cond := Gate.fn_body("scripts/talents.gd", "condition_met", _cache)
	ok(not tal.contains(PUNISH_CARD) and not runes.contains(PUNISH_CARD) and not tal.contains("intent") and not runes.contains("intent")
		and not cond.contains("intent") and not cond.contains("cooldown"),
		"§3: the punish is a talent's or a rune's, or a condition reads a declaration")
	var mv := _moves()
	var s: Node = await _board()
	# THE CONDITION SHOWS BEFORE THE CAST: the plate's hover names the cooldown of a cooling move and of no basic — read before
	# anything asks for the card, so HEAD's tree reds here too.
	if mv[0] != null and mv[1] != null:
		var hf: BattleUnit = _foes(s)[0]
		var hw: BattleUnit = _heroes(s)[0]
		hf.intent = {"ability": mv[1], "target": hw, "turns": 1, "support": false, "malice": 0, "category": "strike"}
		var hover_cool := String(s.call("_intent_hover_text", hf))
		hf.intent = {"ability": mv[0], "target": hw, "turns": 1, "support": false, "malice": 0, "category": "strike"}
		var hover_basic := String(s.call("_intent_hover_text", hf))
		hf.intent = {}
		ok(hover_cool.contains("Cooldown: %d turn" % (mv[1] as Ability).cooldown) and not hover_basic.contains("Cooldown:"),
			"§3: the plate's hover does not say the declared move's cooldown before the cast, or says one for a basic")
	else:
		ok(false, "§3: the plate's hover does not say the declared move's cooldown before the cast — the warband holds no basic and cooling move to declare")
	var card := _card(_heroes(s)[0], PUNISH_CARD)
	ok(card != null and mv[0] != null and mv[1] != null and mv[2] != null and (mv[2] as Ability).cooldown > (mv[1] as Ability).cooldown,
		"§3: the premise — the Warrior holds the card, and the warband holds a basic and two cooling moves of different lengths")
	if card == null or mv.has(null):
		return
	# A SEED WHOSE BARE BLOW LANDS, then every arm on a board of its own with that seed: the four blows draw the same dice and
	# differ by the declaration alone — nothing an earlier cast left behind (the Berserker's Rage spent, a frenzy) carries over.
	var sd := SEED
	for k in 24:
		var w0: BattleUnit = _heroes(s)[0]
		var f0: BattleUnit = _foes(s)[0]
		_whole(f0)
		w0.resource = w0.max_resource
		w0.cooldowns = {}
		seed(SEED + k)
		var hp_t := f0.hp
		await s._resolve(w0, card, f0, "good")
		if hp_t - f0.hp > 0:
			sd = SEED + k
			break
	var dealt := {}
	var foe: BattleUnit = null
	var warrior: BattleUnit = null
	for arm in ["none", "basic", "short", "long"]:
		s = await _board()
		warrior = _heroes(s)[0]
		foe = _foes(s)[0]
		card = _card(warrior, PUNISH_CARD)
		_whole(foe)
		warrior.resource = warrior.max_resource
		warrior.cooldowns = {}
		var ab: Ability = null
		match arm:
			"basic":
				ab = mv[0]
			"short":
				ab = mv[1]
			"long":
				ab = mv[2]
		if ab != null:
			foe.intent = {"ability": ab, "target": warrior, "turns": 1, "support": false, "malice": 0, "category": "strike"}
		seed(sd)
		var hp0 := foe.hp
		await s._resolve(warrior, card, foe, "good")
		dealt[arm] = hp0 - foe.hp
	var cs := (mv[1] as Ability).cooldown
	var cl := (mv[2] as Ability).cooldown
	var want_s := int(round(float(dealt["none"]) * (1.0 + pct * 0.01 * cs)))
	var want_l := int(round(float(dealt["none"]) * (1.0 + pct * 0.01 * cl)))
	print("    dealt: none %d, a declared basic %d, cooling %d %d (about %d), cooling %d %d (about %d)" % [
		dealt["none"], dealt["basic"], cs, dealt["short"], want_s, cl, dealt["long"], want_l])
	ok(int(dealt["none"]) > 0 and dealt["basic"] == dealt["none"], "§3: the punish paid against a declared basic (%d against %d)" % [dealt["basic"], dealt["none"]])
	ok(absi(int(dealt["short"]) - want_s) <= 2 and absi(int(dealt["long"]) - want_l) <= 2 and int(dealt["long"]) > int(dealt["short"]),
		"§3: the punish does not scale with the declared move's cooldown — %d at %d, %d at %d, %d at none" % [dealt["short"], cs, dealt["long"], cl, dealt["none"]])
	# A MOVE's WORTH IS NOT IN THE GAME: the line stays a gate's.
	var in_game: Array = []
	for f in DirAccess.get_files_at("res://scripts"):
		if String(f).ends_with(".gd") and Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f))).contains("line_blow"):
			in_game.append(String(f))
	ok(in_game.is_empty() and FileAccess.get_file_as_string("res://check_ji.gd").contains("func line_blow"),
		"§3: a move's worth moved into the game, or left its gate: %s" % [in_game])


# ── §4 — THE COUNT's FIGHTS ───────────────────────────────────────────────────

func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i]))[0])))
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["engines"] = Runes.engine_pouch_for_spec(String(SPECS[i]))
		_run.party[i]["bm_abilities"] = (SEATED[i] as Array).duplicate()
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _s4_the_fights() -> void:
	print("\n§4 — one fight a warband kind, the warband attacking, the three answers' cards seated")
	var kinds: Array = Enemies._load().keys()
	kinds.sort()
	var totals := {"fights": 0, "ended": 0, "skips": 0, "struck": 0, "attacking": 0, "laid": 0, "died": 0, "punish_met": 0, "punish_not": 0}
	var unfielded: Array = []
	var quiet: Array = []
	var retried: Array = []
	var work: Array = kinds.map(func(k): return [k, 0])
	while not work.is_empty():
		var it: Array = work.pop_front()
		var kind: String = String(it[0])
		var tries: int = int(it[1])
		var kd: Dictionary = Enemies._load()[kind]
		var boss := bool(kd.get("is_boss", kd.get("boss", false)))
		var enc := {"type": "fight", "theme": "Warband", "enemies": [kind] if boss else [kind, kind, kind]}
		_fresh_meta()
		seed(SEED + kinds.find(kind) + RETRY_SEED * tries)
		_new_run()
		OS.set_environment("DOD_READOUT", "")
		OS.set_environment("DOD_AUTOPLAY", "1")
		OS.set_environment("DOD_ENEMIES_OFF", "")
		Gate.enter_battle(self, enc)
		await Gate.frames(self, 2)
		var s: Node = current_scene
		var guard := 0
		while s != null and is_instance_valid(s) and not bool(s.get("battle_over")) and guard < FRAME_CAP:
			Engine.time_scale = 100.0
			await process_frame
			guard += 1
		Engine.time_scale = 1.0
		OS.set_environment("DOD_AUTOPLAY", "")
		totals["fights"] += 1
		var ended: bool = s != null and is_instance_valid(s) and bool(s.get("battle_over")) and guard < FRAME_CAP
		if not ended:
			print("    %-16s did not end inside %d frames" % [kind, FRAME_CAP])
			continue
		totals["ended"] += 1
		await Gate.frames(self, 2)
		var log := String((s.get("history") as RichTextLabel).get_parsed_text())
		var names: Array = []
		for e in (s.get("enemies") as Array):
			names.append(String((e as BattleUnit).unit_name))
		var cfg_name := String(kd.get("unit_name", ""))
		if not log.contains("Enemy warband:") or cfg_name == "" or not names.any(func(nm): return String(nm).begins_with(cfg_name)):
			unfielded.append(kind)
		var skips := log.count("skips its turn (enemy attacks off)")
		var struck := 0
		for raw in log.split("\n"):
			var line := String(raw)
			for nm in names:
				if line.begins_with(String(nm) + ": ") and line.contains(" on "):
					struck += 1
					break
		var laid := log.count("is Forsaken: its death feeds the warband no Malice")
		var died := log.count("→ Forsaken: ")
		var met := log.count("→ Read the Tell: ") - log.count("has declared no cooling move")
		var unmet := log.count("has declared no cooling move")
		totals["skips"] += skips
		totals["struck"] += struck
		totals["attacking"] += 1 if (skips == 0 and struck > 0) else 0
		if not (skips == 0 and struck > 0):
			if skips == 0 and tries < MAX_RETRIES:
				retried.append(kind)
				work.push_front([kind, tries + 1])
			else:
				quiet.append(kind)
		totals["laid"] += laid
		totals["died"] += died
		totals["punish_met"] += met
		totals["punish_not"] += unmet
		print("    %-16s ended in %5d frames; warband strikes %3d; attacks-off skips %d; Forsaken laid %d, died %d; Read the Tell met %d, unmet %d" % [
			kind, guard, struck, skips, laid, died, met, unmet])
	print("    over %d fights, %d ended, %d where the warband attacks: %s" % [totals["fights"], totals["ended"], totals["attacking"], str(totals)])
	print("    fought again on the next seed, its first fight quiet: %s" % str(retried))
	ok(totals["fights"] == kinds.size() + retried.size() and kinds.size() > 0, "§4: one fight a kind — %d fights for %d kinds (%d fought again)" % [totals["fights"], kinds.size(), retried.size()])
	ok(totals["ended"] == totals["fights"], "§4: %d of %d fights did not end inside their frame cap" % [totals["fights"] - totals["ended"], totals["fights"]])
	ok(unfielded.is_empty(), "§4: a kind was not fielded in its own fight, or its fight printed no opener: %s" % [unfielded])
	ok(totals["skips"] == 0 and totals["struck"] > 0, "§4: the warband's attacks were not on — %d skipped turns, %d strikes" % [totals["skips"], totals["struck"]])
	ok(quiet.is_empty(), "§4: a kind's fight is no fight where the warband attacks — it struck no blow, so the count cannot see it: %s" % [quiet])


func _s4_the_kept_count() -> void:
	print("\n§4 — the kept count: taken over the fights where the warband attacks, every row saying how many")
	var text := _doc(KEPT_COUNT)
	var lines := text.split("\n", false)
	ok(lines.size() > 1 and Array(String(lines[0]).split("\t")) == COUNT_HEAD, "§4: the kept count's columns are not the count's — %s" % (String(lines[0]) if lines.size() > 0 else "no table"))
	if lines.size() <= 1:
		return
	var attacking := -1
	var denoms := {}
	var bad: Array = []
	var named := {}
	var by_target := 0
	for r in lines.slice(1):
		var c := String(r).split("\t")
		if c.size() != COUNT_HEAD.size():
			bad.append(String(r))
			continue
		if String(c[0]) == "the fights":
			denoms[String(c[1])] = int(c[2])
			if String(c[1]) == "where the warband attacks":
				attacking = int(c[2])
			continue
		if String(c[0]) == "a target's fights":
			by_target += int(c[2])
			continue
		named[String(c[0])] = true
		if not String(c[3]).is_valid_int():
			bad.append(String(r))
	for r2 in lines.slice(1):
		var c2 := String(r2).split("\t")
		if c2.size() == COUNT_HEAD.size() and not ["the fights", "a target's fights"].has(String(c2[0])) \
				and String(c2[3]).is_valid_int() and int(c2[3]) != attacking:
			bad.append(String(r2))
	print("    the denominators: %s; the targets' attacking fights sum to %d; rows counted: %s" % [str(denoms), by_target, str(named.keys())])
	ok(attacking > 0 and bad.is_empty(), "§4: a row of the kept count does not carry the %d fights the warband attacked in: %s" % [attacking, bad])
	ok(by_target == attacking, "§4: the targets' attacking fights sum to %d, not the %d the count was taken over" % [by_target, attacking])
	var over: Array = []
	for r3 in lines.slice(1):
		var c3 := String(r3).split("\t")
		if c3.size() == COUNT_HEAD.size() and ["the attacking fights it happened in", "a warband kind fielded"].has(String(c3[0])) \
				and int(c3[2]) > attacking:
			over.append(String(r3))
	ok(over.is_empty(), "§4: a count was taken over more fights than the warband attacked in: %s" % [over])
	ok(denoms.has("the logs hold") and denoms.has("with enemy attacks off") and int(denoms.get("the logs hold", 0)) > attacking,
		"§4: the kept count names no fights it was not taken over — it reads as taken over all of them")
	ok(COUNTED.all(func(k): return named.has(k)), "§4: the kept count does not count what the brief asked: %s" % [COUNTED.filter(func(k): return not named.has(k))])


# ── §5 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s5_not_done() -> void:
	print("\n§5 — no drain in the strike loop, no dial pulled, the deck at twenty-five")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var pays := src.count("_malice_pay(") - 1
	var heal := Gate.fn_body("scripts/battle.gd", "_warband_heal", _cache).count("_malice_pay(")
	var spends := Gate.fn_body("scripts/battle.gd", "_resolve_special", _cache).count("_malice_pay(")
	var strike := Gate.fn_body("scripts/battle.gd", "_resolve", _cache)
	print("    Malice goes out at %d calls: %d in the warband's heal, %d in the spends' arms" % [pays, heal, spends])
	ok(pays == 4 and heal == 1 and spends == 3 and not strike.contains("_malice_pay(") and not strike.contains("malice -="),
		"§5: Malice goes out somewhere the warband did not buy it — a drain entered the strike loop (%d calls)" % pays)
	var vars: Array = []
	for p in (load("res://scripts/ability.gd") as Script).get_script_property_list():
		vars.append(String((p as Dictionary).get("name", "")))
	vars.sort()
	var vmd5 := "|".join(vars).md5_text()
	print("    Ability's fields: %d (%s)" % [vars.size(), vmd5])
	ok(vmd5 == ABILITY_VARS_MD5, "§5: a field was added to Ability — what a blow carries into the strike loop")
	var cut: Variant = _uc().get("CLERIC_MANA_CUT")
	ok(cut != null and absf(float(cut) - CLERIC_CUT) < 0.0001, "§5: the Cleric's cut was pulled (%s)" % str(cut))
	ok(JSON.stringify(_warband_as_landed(), "", true).md5_text() == WARBAND_MD5, "§5: the warband's data moved — a dial was pulled, or a basic, a hex or a spend changed")
	var deck: Array = (_run.MODIFIERS as Dictionary).keys()
	deck.sort()
	ok(deck.size() == DECK_CLOSED_AT and ("%d|" % deck.size() + "|".join(deck)).md5_text() == DECK_MD5,
		"§5: the deck holds %d, not the twenty-five it closed at, or a card was swapped in it" % deck.size())


# ── §6 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s6_the_players_files() -> void:
	print("\n§6 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§6: %s changed under this gate" % p)
