# BATCH HO — THE SUPPLY ROUTE, THE TRAP, AND THE FIRST CREST RUNES.
#
#   §0  THE GROUND — this process writes the harness save, and scratch meta files
#   §1  THE SUPPLY ROUTE — how a crest rune reaches the player, driven with the two
#       that are authored: the scope at every roll; the DROP after a real normal
#       fight; the PEDDLER's real counter; a CACHE's real overlay; the EVENT verb;
#       the bag's real crest button; and the sim's mirror of the counter. Each
#       surface says whom the rune is for
#   §2  WHY THREE OF THE BRIEF'S FIVE ARE NOT AUTHORED, HELD AS FACTS RATHER THAN
#       AS PROSE (FK §7's rule): the draft seats one of each class; a won fight
#       raises the fallen; so each of the three conditions holds in no fight a run
#       played forward opens — and holds in a fight resumed after a quit
#   §3  `heroes_all_standing: false` INVERTS — both values against both parties
#   §4  THE REPLACE-NOT-ADD TRAP IS CLOSED — the population derived off the unit,
#       every one carried before any payload, a payload ADDING on each, Holy
#       Conduit adding its share, and a saved run's Vampiric paying what it says
#   §5  TITHE AND FELLOWSHIP, WORN THROUGH A REAL BATTLE — what each pays, that the
#       read site sums the pair (EM's charter), and the BR §1 sweep of five names
#   §6  THE BLACKSMITH ARM `test_batch_bk` §3 BUYS — the counter that used to fail
#       and the one that never did, read by the one helper both share
#   §7  ELEVATION'S CARD names the cap and never a figure a constant holds
#   §8  THE COPIES' POLICY is in the reference a batch opens when it verifies
#   §9  THE PLAYER'S FILES, as this gate found them
#
# **EVERY FIXTURE IS PUT INTO THE LOADED TABLE AND TAKEN OUT AGAIN, AND NONE IS
# WRITTEN TO THE FILE** (HL §6's shape). The two crest runes this batch authors are
# read off the file and driven as the file holds them; the three it holds back are
# driven as fixtures, so what each WOULD pay is measured without shipping it.
# **EVERY FIELD A DRIVE MEASURES ARRIVES THROUGH THE REAL DOOR** — a payload
# stamped at the spawn — and this gate assigns none of them on a unit by hand
# (GW §2). **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM**, and a population prints
# how many it checked, so a walk over nothing reads red.
#
# **NO MAGNITUDE IS COPIED HERE** (the rule this batch records): Tithe's share is
# read off the entry, the cap off `FAITH_RELEASE`, the defaults off the unit.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ho.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
const SuiteFx = preload("res://suite_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const SCRATCH_PROFILE := "user://ho_profile.json"
const SCRATCH_RELICS := "user://ho_relics.json"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const FRAME_CAP := 60000
# §5c's live stretch. A stretch that works is over in well under a hundred frames;
# one that does not must END and say so, never sit out the watchdog (a target cut
# off reads like a hang, FS §1) — so it is bounded at many times the need, and it
# stops if the fight itself ends.
const STRETCH_CAP := 1200

# The two the file holds, and the fixture every condition and trap drive wears.
# BATCH HP §3 — FELLOWSHIP IS RETIRED, AND DIRGE TAKES ITS PLACE IN THE PAIR. The
# route arms (§1) ask their question of two crest runes at once — one row each on a
# counter, one pick worn and the next bagged — so the pair is any two the file holds
# live; Dirge is one of the three HP authored. Tithe keeps its own sections (§5b).
const CRESTS := ["tithe", "dirge"]
# HO's own two entries, by id: §5a and §5e ask of them whether they are live or not —
# a retired entry is kept and still resolves (ET), so what HO authored is still asked.
const HO_TWO := ["tithe", "fellowship"]
const CREST_FX := "ho_fixture_crest"
const CREST_HP := 9

# §2 — the three the brief specified and this batch did not author, by the
# condition each would carry. Driven as fixtures.
# BATCH HP §2 — AUTHORED AT HP, UNDER THE NAMES THE DESIGNER RULED (HP §0: *Cold
# Hearth* is Dead Air and *Gravesong* is Dirge), each on the condition HO specified,
# read as the fight runs. Keyed by the ruled names; the two HO proposed are
# `HO_NAMES`, which §2d holds out of the file.
const HELD_BACK := {
	"Empty Pulpit": {"heroes_lack_class": "cleric"},
	"Dead Air": {"heroes_lack_class": "mage"},
	"Dirge": {"heroes_all_standing": false},
}
const HO_NAMES := ["Cold Hearth", "Gravesong"]
# The hero whose fall makes each hold, by seat.
const FALLS := {"Empty Pulpit": 2, "Dead Air": 1, "Dirge": 1}

# §5 — BR §1: the five names, and the shared-word near-misses each is known to
# have (compared as an EQUALITY, EK's `CLASH_EXEMPT` shape, so a new one reds).
const FIVE_NAMES := ["Tithe", "Fellowship", "Gravesong", "Empty Pulpit", "Cold Hearth"]
const NEAR_MISSES := {
	# A relic, *Tithing Scales*, whose id is the rune's own in another table.
	"Tithe": ["relic id:tithe", "relic:Tithing Scales"],
	"Fellowship": [],
	"Gravesong": ["enemy:Grave Totem", "relic:Gravelight Lantern", "relic:Gravewrought Coin"],
	"Empty Pulpit": [],
	"Cold Hearth": ["ability:Cold Iron", "rune:Cold Snap", "rune:Deep Cold", "rune:Killing Cold",
		"rune:Rune of the Killing Cold"],
}

# ...and the strings in the game's own scripts that spell one of the two that ship
# (§5e): a log line of a field nothing writes since the twelve trees went (FX).
const LITERAL_MISSES := {
	"Tithe": ["battle.gd:    → Blood Tithe: %s collects %d Rage"],
	"Fellowship": [],
}

# §7 — the card's words, ruled at HO §0, as the screen breaks them.
const ELEVATION_WORDS := "Raise them up: every ally gains 2\nstacks of Faith.\nAn ally who reaches the cap with it\nRELEASES on the spot — and their peak\ndoes not fall for it."

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HO — THE SUPPLY ROUTE, THE TRAP, AND THE FIRST CREST RUNES")
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
	_s1a_the_scope()
	await _s1b_the_drop()
	await _s1c_the_peddler()
	await _s1d_the_cache()
	_s1e_the_event()
	await _s1f_the_crest_button()
	_s1g_the_sims_counter()
	await _s2a_the_draft()
	await _s2b_the_fallen_rise()
	await _s2c_what_the_three_would_pay()
	_s2d_the_three_are_authored()
	await _s3_all_standing()
	await _s4_the_trap()
	await _s4d_a_saved_run()
	_s4e_the_sources()
	_s5a_the_entries()
	await _s5b_tithe()
	await _s5c_fellowship()
	_s5d_the_sheet()
	_s5e_the_names()
	_s6_the_blacksmith_arm()
	_s7_elevation()
	_s8_the_policy()
	Runes._load().erase(CREST_FX)
	ok(not Runes.ids().has(CREST_FX) and Runes.ids().has("tithe"),
		"§9: the fixture was left in the loaded table, or took a real entry with it")
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
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


# A fresh run of `keys`, each awakened on the engine rune `engines` names for his
# seat ("" seats him with none).
func _new_run(keys: Array, engines: Array) -> void:
	_run.sim_run = false
	_run.new_run(keys, [], "standard")
	for i in _run.party.size():
		if String(engines[i]) != "":
			_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
		else:
			_run.party[i]["awakened"] = true
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.items = {}


func _names(list: Array) -> Array:
	var out: Array = []
	for r in list:
		out.append(String((r as Dictionary).get("name", "")))
	return out


# Every rune the four could be offered right now, less what the party holds —
# the drop's own union, read here the long way.
func _offerable_now() -> Array:
	var out: Array = []
	var held: Array = _run.party_rune_names()
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


# PARK every rune the party could be offered but `keep` on the waiting list, where
# `Run.party_rune_names` reads it as held — so the one thing a real roll has left
# to hand over is `keep`. A fixture's dressing of the POOL; the roll is the game's.
func _park_all_but(keep: Array) -> int:
	var n := 0
	for id in _offerable_now():
		if not keep.has(String(id)):
			_run.pending_rune_drops.append(Runes.build(String(id)))
			n += 1
	return n


func _unpark() -> void:
	_run.pending_rune_drops = []


# Every crest rune the file holds, built — parked so a roll has only class runes
# left to hand over. Read off the file, so the positive arms that use it go on
# asking about class runes the day a third crest rune is authored.
func _all_crest_runes() -> Array:
	var out: Array = []
	for id in Runes.ids():
		if String(id) != CREST_FX and Runes.is_party_scope(String(Runes.config(String(id)).get("scope", ""))):
			out.append(Runes.build(String(id)))
	return out


# The crest worn through the run's own door — the bag, then the function the bag
# panel's Equip button is bound to (§1f presses that button itself).
func _wear_crest(id: String) -> bool:
	_run.bag_rune(Runes.build(id))
	var rows: Array = _run.party_rune_rows()
	for i in rows.size():
		if String(rows[i]["src"]) == "bag" and String((rows[i]["rune"] as Dictionary).get("id", "")) == id:
			return bool(_run.toggle_party_rune(i))
	return false


# THE ONE DOOR EVERY FIXTURE DRIVE ENTERS BY (check_hn's): a party of `keys` on
# `engines`; the fixture crest worn with `payload` when `crest` is true; the
# authored crest rune `real` worn instead when it names one; hero `fallen` at 0
# health; `members` stamped onto the party before the scene is built. The real
# battle scene for the run in hand (`Gate.enter_battle`).
func _battle(keys: Array, engines: Array, payload: Dictionary, crest: bool,
		fallen := -1, real := "", members := {}) -> Node:
	var table: Dictionary = Runes._load()
	table[CREST_FX] = {"name": "HO Fixture Crest", "scope": "party", "price": 150,
		"desc": "A fixture of check_ho, never in the file.", "payload": payload}
	_new_run(keys, engines)
	if crest:
		_wear_crest(CREST_FX)
	if real != "":
		_wear_crest(real)
	for seat in members:
		for k in (members[seat] as Dictionary):
			_run.party[int(seat)][k] = members[seat][k]
	if fallen >= 0:
		_run.party[fallen]["hp"] = 0
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _foe(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			return e
	return null


func _approx(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if not is_equal_approx(float(a[i]), float(b[i])):
			return false
	return true


# The fixture crest's +CREST_HP maximum health against the same party without it:
# how many of the four it was paid on, and whether the roll call told why not.
#
# BATCH HP §1 — A KEY READ AS THE FIGHT RUNS IS PAID BY THE LIVE DOOR, WHICH REFUSES A
# CONSUMED FIELD (maximum health builds the bar at the spawn). So a condition carrying
# one of `Talents.LIVE_KEYS` writes damage dealt, read afresh on every blow, and the
# arm reads that field once the opening read has run; a condition the spawn reads
# once keeps the stamp this gate was written on. check_hn's shape, the same question.
const CREST_DMG := 0.09


func _paid(keys: Array, engines: Array, cond: Dictionary, fallen := -1) -> Dictionary:
	var live := Talents.is_live({"condition": cond})
	var field := "dmg_bonus" if live else "max_hp"
	var fig: float = CREST_DMG if live else float(CREST_HP)
	var w: Node = await _battle(keys, engines, {"stat": {field: fig if live else CREST_HP}, "condition": cond}, true, fallen)
	var hp_w: Array = []
	for u in _heroes(w):
		hp_w.append(float((u as BattleUnit).get(field)))
	var roll: Array = (w.get("_rune_roll_call") as Array).duplicate()
	var o: Node = await _battle(keys, engines, {"stat": {field: fig if live else CREST_HP}, "condition": cond}, false, fallen)
	var paid := 0
	var oh: Array = _heroes(o)
	for i in mini(hp_w.size(), oh.size()):
		if is_equal_approx(float(hp_w[i]) - float((oh[i] as BattleUnit).get(field)), fig):
			paid += 1
	var told := false
	for line in roll:
		if String(line).begins_with("the crest: HO Fixture Crest") \
				and String(line).contains("its condition does not hold"):
			told = true
	return {"paid": paid, "heroes": hp_w.size(), "told": told}


func _to(scene_path: String) -> Node:
	change_scene_to_file(scene_path)
	await Gate.frames(self, 6)
	return current_scene


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


# One encounter on the real battle scene, WON on autoplay with the enemy's attacks
# off (`check_hk`'s switches); returns the scene on its victory card.
func _win(encounter: Dictionary) -> Node:
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, encounter)
	await Gate.frames(self, 4)
	return await _run_out(current_scene)


func _run_out(s: Node) -> Node:
	var guard := 0
	while _is_battle(s) and not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	await Gate.frames(self, 6)
	OS.set_environment("DOD_AUTOPLAY", "")
	return current_scene


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


# ── §1a — THE SCOPE, AT EVERY ROLL ──────────────────────────────────────────

func _s1a_the_scope() -> void:
	print("\n§1a — the supply route: what every roll does with the crest's scope")
	_new_run(SEATS, ENG4)
	var asked := 0
	for id in CRESTS:
		var cfg: Dictionary = Runes.config(id)
		ok(String(cfg.get("scope", "")) == "party" and String(cfg.get("retired", "")) == "",
			"§1a: `%s` is not a live crest rune (scope '%s')" % [id, cfg.get("scope", "")])
		var inst := Runes.build(id)
		ok(Runes.is_party_rune(inst) and Runes.rune_class(inst) == "" and _run.rune_for_label(inst) == "the crest",
			"§1a: `%s` does not read as the crest's (%s)" % [id, _run.rune_for_label(inst)])
		for m in _run.party:
			asked += 1
			ok(Runes.eligible_ids(m, []).has(id), "§1a: the roll does not offer `%s` to a %s" % [id, m["key"]])
			ok(not Runes.wearable_by(inst, m), "§1a: a %s could wear `%s` in a slot of his own" % [m["key"], id])
		# NO GATE WITHHOLDS ONE: a hero holding no core rune is offered it too.
		var bare: Dictionary = (_run.party[0] as Dictionary).duplicate(true)
		bare["engines"] = []
		ok(Runes.eligible_ids(bare, []).has(id) and Runes.offerable(id, []),
			"§1a: `%s` is withheld from a hero holding no core rune" % id)
	print("    CHECKED %d crest runes against %d heroes" % [CRESTS.size(), asked])
	ok(asked == CRESTS.size() * 4, "§1a: the scope walk asked %d of %d" % [asked, CRESTS.size() * 4])
	# THE DOORS, NAMED OFF THE SOURCE: every roll reaches the pool through
	# `eligible_ids`, which asks `_scope_ok`, which passes the crest's scope.
	var rs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/runes.gd"))
	var st := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(rs.contains("if is_party_scope(scope):\n\t\treturn true"), "§1a: `_scope_ok` no longer passes the crest's scope")
	ok(st.contains("Runes.eligible_ids(m, Runes.owned_names(m, held))"),
		"§1a: the drop no longer asks every hero's `eligible_ids`")
	# THE COUNTER'S ONE EXCLUSION IS THE CORE RUNES: it names engines, never a scope.
	var pr := st.substr(st.find("func peddler_rune("), 420)
	ok(pr.contains("is_engine_rune") and not pr.contains("is_party"),
		"§1a: the Peddler's roll excludes something besides core runes")


# ── §1b — THE DROP, AFTER A REAL NORMAL FIGHT ───────────────────────────────

func _s1b_the_drop() -> void:
	print("\n§1b — the drop: a real normal fight won, and what it leaves in the bag")
	_new_run(SEATS, ENG4)
	var parked := _park_all_but(CRESTS)
	var left := _offerable_now()
	left.sort()
	ok(parked > 20 and left == ["dirge", "tithe"],
		"§1b: with %d runes parked, the drop's pool is %s — the narrowing did not narrow" % [parked, left])
	var s := await _win({"type": "fight", "enemies": _run.compose("fight")})
	ok(_is_battle(s) and bool(s.get("battle_over")), "§1b: the normal fight did not end")
	var got: Array = _run.rune_bag.duplicate()
	var nm := String((got[0] as Dictionary).get("name", "")) if got.size() == 1 else ""
	ok(got.size() == 1 and Runes.is_party_rune(got[0]),
		"§1b: a normal fight won left %s in the bag — want one crest rune" % [_names(got)])
	ok(nm != "" and Gate.has_text(s, "RUNE DROP: %s, for the crest" % nm),
		"§1b: the victory card does not say the drop (%s) is for the crest" % nm)
	# FLAT OVER RUNES, ONE ENTRY AND NOT ONE A HERO: the pool narrowed to a crest
	# rune and ONE class rune splits about evenly. Four copies of the crest rune —
	# one for every hero it rolls for — would take four drops in five.
	_unpark()
	_run.rune_bag = []
	var one_class := ""
	for id in _offerable_now():
		if not Runes.is_party_rune(Runes.build(String(id))) and not Runes.is_engine_rune(String(id)):
			one_class = String(id)
			break
	_park_all_but(["tithe", one_class])
	var crest_n := 0
	var rolls := 400
	for i in rolls:
		if String(_run.roll_fight_drop().get("id", "")) == "tithe":
			crest_n += 1
	_unpark()
	print("    a pool of one crest rune and one class rune: the crest rune in %d of %d drops" % [crest_n, rolls])
	ok(one_class != "" and crest_n > rolls * 0.35 and crest_n < rolls * 0.65,
		"§1b: the crest rune took %d of %d drops against one class rune — it is not one entry in the pool" % [crest_n, rolls])


# ── §1c — THE PEDDLER'S REAL COUNTER ────────────────────────────────────────

func _s1c_the_peddler() -> void:
	print("\n§1c — the Peddler: a crest rune on the real counter, and whom its row is for")
	_new_run(SEATS, ENG4)
	_park_all_but(CRESTS)
	_run.gold = 1000
	var shop := await _to("res://scenes/shop.tscn")
	var offers: Array = shop.get("offers")
	var on_counter: Array = []
	for o in offers:
		on_counter.append(String(((o as Dictionary)["rune"] as Dictionary).get("id", "")))
	on_counter.sort()
	ok(on_counter == ["dirge", "tithe"], "§1c: the counter holds %s — each crest rune once, in one hero's row" % [on_counter])
	var said := 0
	for o2 in offers:
		var r: Dictionary = (o2 as Dictionary)["rune"]
		if Gate.has_text(shop, "%s  (for the crest)" % String(r["name"])):
			said += 1
	ok(offers.size() == 2 and said == 2, "§1c: %d of the %d crest rows say the rune is for the crest" % [said, offers.size()])
	# THE NEGATIVE, AND ITS POSITIVE BELOW: no crest row names the hero it was
	# rolled against.
	var named_a_hero := false
	for k in SEATS:
		for n in [1, 2, 3, 4]:
			if Gate.has_text(shop, "(for %s %d)" % [String(k).capitalize(), n]):
				named_a_hero = true
	ok(not named_a_hero, "§1c: a crest rune's row names a hero — the row says it is his")
	var first := String(((offers[0] as Dictionary)["rune"] as Dictionary).get("name", "")) if not offers.is_empty() else ""
	var bought := Gate.press(shop, ["Buy — "])
	await Gate.frames(self, 2)
	ok(bought != "" and _names(_run.rune_bag) == [first] and _run.party_runes.is_empty(),
		"§1c: the crest rune bought is not in the bag (bag %s, crest %s)" % [_names(_run.rune_bag), _names(_run.party_runes)])
	_unpark()
	# THE POSITIVE ARM: a class rune's row still names its hero.
	_new_run(SEATS, ENG4)
	_run.pending_rune_drops = _all_crest_runes()
	var shop2 := await _to("res://scenes/shop.tscn")
	var rows := 0
	var rows_named := 0
	for o3 in shop2.get("offers"):
		rows += 1
		var mi := int((o3 as Dictionary)["member_idx"])
		if Gate.has_text(shop2, "%s  (for %s %d)" % [String(((o3 as Dictionary)["rune"] as Dictionary)["name"]),
				String(_run.party[mi]["key"]).capitalize(), mi + 1]):
			rows_named += 1
	ok(rows > 0 and rows_named == rows, "§1c: %d of %d class-rune rows name their hero — the crest's word replaced the hero's" % [rows_named, rows])
	_unpark()


# ── §1d — A CACHE'S REAL OVERLAY ────────────────────────────────────────────

func _open_cache(seat: int) -> Node:
	var mp := await _to("res://scenes/map.tscn")
	var choose: Button = Gate.bound_button(mp, "_open_pick_overlay", [seat])
	if choose != null:
		choose.emit_signal("pressed")
		await process_frame
	return Gate.overlay(current_scene, 60)


func _s1d_the_cache() -> void:
	print("\n§1d — a cache: a crest rune in one hero's triple, on the real overlay")
	_new_run(SEATS, ENG4)
	_park_all_but(CRESTS)
	var mage: Dictionary = _run.party[1]
	# THE ROLL IS THE GAME'S: the elite's cache and the bargain both call it.
	var triple: Array = _run.roll_rune_candidates(mage)
	_unpark()
	var ids: Array = []
	for c in triple:
		ids.append(String((c as Dictionary).get("id", "")))
	ids.sort()
	ok(ids == ["dirge", "tithe"], "§1d: the cache's roll offered the Mage %s" % [ids])
	mage["rune_candidates"] = [triple.duplicate(true), triple.duplicate(true)]
	mage["rune_picks_owed"] = 2
	var ov := await _open_cache(1)
	ok(ov != null and Gate.has_text(ov, "Tithe  (for the crest)") and Gate.has_text(ov, "Dirge  (for the crest)"),
		"§1d: the Mage's cache does not say its crest runes are the crest's")
	var took := Gate.press(ov, ["Tithe"]) if ov != null else ""
	# The toast is read in the frame the press lands: it fades on a timer, and a
	# headless frame is long enough to take it.
	var said_worn := Gate.has_text(current_scene, "Tithe fills the crest — every hero wears it.")
	await Gate.frames(self, 3)
	# TAKEN WITH THE CREST EMPTY: worn at the pick, by every hero, and said.
	ok(took != "" and _names(_run.party_runes) == ["Tithe"] and _names(mage.get("runes", [])).is_empty(),
		"§1d: the crest rune taken from the Mage's cache went to %s (the Mage's own: %s)" % [
			_names(_run.party_runes), _names(mage.get("runes", []))])
	ok(said_worn, "§1d: a pick every hero now wears was not announced")
	ok(Gate.has_text(current_scene, "Crest: Tithe"), "§1d: the map's crest button does not name the rune taken")
	# TAKEN WITH THE CREST FILLED: the second goes to the bag (FD's repair took the
	# one the party now holds out of the second triple), and the toast says why.
	var ov2 := await _open_cache(1)
	var took2 := Gate.press(ov2, ["Dirge"]) if ov2 != null else ""
	var said_bag := Gate.has_text(current_scene, "Dirge goes into the bag — every slot it fits is filled.")
	await Gate.frames(self, 3)
	ok(took2 != "" and _names(_run.party_runes) == ["Tithe"] and _names(_run.rune_bag) == ["Dirge"],
		"§1d: a second crest rune taken went to %s / bag %s — the crest holds one" % [
			_names(_run.party_runes), _names(_run.rune_bag)])
	ok(said_bag, "§1d: the second crest rune's trip to the bag was not said")


# ── §1e — THE EVENT VERB ────────────────────────────────────────────────────

func _s1e_the_event() -> void:
	print("\n§1e — the event verb: a crest rune handed over names the crest")
	_new_run(SEATS, ENG4)
	_park_all_but(["tithe"])
	var line: String = Events.apply(_run, {"effect": "rune_grant", "amount": 1})
	_unpark()
	ok(_names(_run.party_runes) == ["Tithe"] or _names(_run.rune_bag) == ["Tithe"],
		"§1e: the event's rune is nowhere (crest %s, bag %s)" % [_names(_run.party_runes), _names(_run.rune_bag)])
	ok(line.contains("Tithe (the crest)"), "§1e: the event's line reads '%s' — it names a hero for a rune all four wear" % line)
	# THE POSITIVE ARM: a class rune's line still names the hero who took it.
	_new_run(SEATS, ENG4)
	_run.pending_rune_drops = _all_crest_runes()
	var line2: String = Events.apply(_run, {"effect": "rune_grant", "amount": 1})
	ok(line2.begins_with("RUNE: ") and not line2.contains("(the crest)"),
		"§1e: a class rune's line reads '%s'" % line2)
	_unpark()


# ── §1f — THE BAG'S REAL CREST BUTTON ───────────────────────────────────────

func _s1f_the_crest_button() -> void:
	print("\n§1f — taken: from the bag into the crest, through the bag panel's own button")
	_new_run(SEATS, ENG4)
	_run.bag_rune(Runes.build("tithe"))
	_run.bag_rune(Runes.build("dirge"))
	var mp := await _to("res://scenes/map.tscn")
	ok(Gate.has_text(mp, "Crest: "), "§1f: the map draws no crest button")
	Gate.press(mp, ["Crest:"])
	await process_frame
	var bp: Node = Gate.overlay(current_scene, 60)
	ok(bp != null and Gate.has_text(bp, "THE CREST — 0 of 1 filled") and Gate.has_text(bp, "Tithe") and Gate.has_text(bp, "Dirge"),
		"§1f: the bag panel's crest section does not list the two crest runes in the bag")
	var rows: Array = _run.party_rune_rows()
	var ti := -1
	for i in rows.size():
		if String((rows[i]["rune"] as Dictionary).get("id", "")) == "tithe":
			ti = i
	var eq: Button = Gate.bound_button(bp, "_toggle_party_rune", [ti, bp]) if bp != null else null
	ok(eq != null and String(eq.text) == "Equip", "§1f: the crest section drew no Equip for Tithe")
	if eq != null:
		eq.emit_signal("pressed")
		await Gate.frames(self, 3)
	ok(_names(_run.party_runes) == ["Tithe"] and bool((_run.party_runes[0] as Dictionary).get("equipped", false))
			and _names(_run.rune_bag) == ["Dirge"],
		"§1f: the Equip left the crest at %s and the bag at %s" % [_names(_run.party_runes), _names(_run.rune_bag)])
	# THE HELPER THE BATTLE DRIVES USE IS THAT BUTTON'S OWN FUNCTION, and it leaves
	# the run exactly as the press did.
	var pressed_state: Array = _names(_run.party_runes)
	_new_run(SEATS, ENG4)
	ok(_wear_crest("tithe") and _names(_run.party_runes) == pressed_state and _run.rune_bag.is_empty(),
		"§1f: `_wear_crest` does not leave the run as the panel's button does")
	# THE SAVE CARRIES IT: worn, saved, loaded — still worn, under today's name.
	_run.save_run()
	_run.party_runes = []
	ok(_run.load_run() and _names(_run.party_runes) == ["Tithe"],
		"§1f: the crest did not round-trip the save (%s)" % [_names(_run.party_runes)])


# ── §1g — THE SIM'S MIRROR OF THE COUNTER ───────────────────────────────────

func _s1g_the_sims_counter() -> void:
	print("\n§1g — the sim's counter offers a crest rune once, as the real one does")
	_new_run(SEATS, ENG4)
	_park_all_but(["tithe"])
	var offers: Array = RunSim._roll_rune_offers(_run)
	_unpark()
	var crest_rows := 0
	for o in offers:
		if String(((o as Dictionary)["rune"] as Dictionary).get("id", "")) == "tithe":
			crest_rows += 1
	# The pool holds one rune and four heroes roll against it: the real counter puts
	# it in one row (§1c), and a mirror that put it in four lets the bot buy four.
	ok(offers.size() == 1 and crest_rows == 1,
		"§1g: with one crest rune left, the sim's counter holds it %d times in %d rows" % [crest_rows, offers.size()])
	# THE POSITIVE ARM: class runes are still rolled one a hero.
	_new_run(SEATS, ENG4)
	_run.pending_rune_drops = _all_crest_runes()
	var plain: Array = RunSim._roll_rune_offers(_run)
	_unpark()
	ok(plain.size() == 4, "§1g: with the crest runes held, the sim's counter holds %d rows, not one a hero" % plain.size())


# ── §2a — THE DRAFT SEATS ONE OF EACH CLASS ─────────────────────────────────

func _draft_press(d: Node, key: String) -> bool:
	var b: Button = Gate.bound_button(d, "_toggle_hero", [key])
	if b == null:
		return false
	b.emit_signal("pressed")
	await Gate.frames(self, 2)
	return true


func _begin_button(d: Node) -> Button:
	var all: Array = []
	Gate.buttons(d, all)
	for b in all:
		if String((b as Button).text) == "Begin the Run":
			return b
	return null


func _s2a_the_draft() -> void:
	print("\n§2a — the draft: four heroes picked from a roster of four, one of each")
	var d := await _to("res://scenes/draft.tscn")
	var consts: Dictionary = (d.get_script() as Script).get_script_constant_map()
	var roster: Array = consts.get("ROSTER", [])
	# THE PREMISE, AS A FACT THE GATE HOLDS: the roster is the four classes. The day
	# a fifth stands here a party CAN lack one, and the two crest runes that read a
	# missing class are authorable (§2c) — this arm reds and says so.
	var sorted_roster: Array = roster.duplicate()
	sorted_roster.sort()
	ok(sorted_roster == ["cleric", "hunter", "mage", "warrior"],
		"§2a: the draft's roster is %s — a party can now be seated without one of the four classes, so the crest runes that read a missing class are authorable" % [roster])
	# A HERO PICKED TWICE IS UNPICKED, NEVER SEATED TWICE.
	await _draft_press(d, "warrior")
	await _draft_press(d, "warrior")
	ok((d.get("picks") as Array).is_empty(), "§2a: pressing the Warrior twice left %s picked" % [d.get("picks")])
	# THREE PICKED: the run cannot begin.
	for k in ["warrior", "mage", "hunter"]:
		await _draft_press(d, k)
	var begin := _begin_button(d)
	ok((d.get("picks") as Array).size() == 3 and begin != null and begin.disabled,
		"§2a: with three heroes picked the run can begin (%s)" % [d.get("picks")])
	# THE POSITIVE ARM: the fourth can only be the class left, and then it begins.
	await _draft_press(d, "cleric")
	begin = _begin_button(d)
	ok(begin != null and not begin.disabled, "§2a: with four heroes picked the run cannot begin")
	if begin != null:
		begin.emit_signal("pressed")
		await Gate.frames(self, 6)
	var seated: Array = []
	for m in _run.party:
		seated.append(String((m as Dictionary)["key"]))
	var seated_sorted: Array = seated.duplicate()
	seated_sorted.sort()
	print("    the run the draft began seats %s" % [seated])
	ok(seated_sorted == ["cleric", "hunter", "mage", "warrior"],
		"§2a: the draft seated %s — not one of each class" % [seated])
	for cond_class in ["cleric", "mage"]:
		ok(not Talents.party_condition_met({"heroes_lack_class": cond_class}, _run.party),
			"§2a: a drafted party lacks a %s" % cond_class)


# ── §2b — A WON FIGHT RAISES THE FALLEN ─────────────────────────────────────

func _s2b_the_fallen_rise() -> void:
	print("\n§2b — a hero who falls in a fight that is won stands again when it ends")
	_new_run(SEATS, ENG4)
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, {"type": "fight", "enemies": _run.compose("fight")})
	await Gate.frames(self, 4)
	var s: Node = current_scene
	var mage: BattleUnit = _heroes(s)[1]
	mage.take_hit(999999, 0)
	await process_frame
	# THE POSITIVE ARM: he fell, through the damage door, and the fall reached the
	# run as it landed (GH) — so the read below is of a hero who was down.
	ok(mage.dead and int(_run.party[1]["hp"]) == 0,
		"§2b: the Mage did not fall (dead %s, the member at %d)" % [mage.dead, int(_run.party[1]["hp"])])
	s = await _run_out(s)
	var won: bool = _is_battle(s) and bool(s.get("battle_over")) and (s.get("enemies") as Array).all(func(e): return e.dead)
	ok(won, "§2b: the fight was not won by the three left")
	var hp_after := int(_run.party[1]["hp"])
	print("    the Mage fell in the fight; at its end the member stands at %d of %d" % [hp_after, int(_run.party[1]["max_hp"])])
	ok(hp_after > 0, "§2b: a hero who fell in a WON fight is still down after it — a fight can now open with a hero fallen in a run played forward, so a fallen-hero condition is reachable at the opening")
	var standing := 0
	for m in _run.party:
		if int((m as Dictionary)["hp"]) > 0:
			standing += 1
	ok(standing == 4 and Talents.party_condition_met({"heroes_all_standing": true}, _run.party)
			and not Talents.party_condition_met({"heroes_all_standing": false}, _run.party),
		"§2b: the next fight opens with %d of four standing" % standing)


# ── §2c — WHAT EACH OF THE THREE WOULD PAY, AND WHEN ────────────────────────

func _s2c_what_the_three_would_pay() -> void:
	print("\n§2c — the three held back, as fixtures: a run played forward, and a quit fight resumed")
	for nm in HELD_BACK:
		var cond: Dictionary = HELD_BACK[nm]
		var forward := await _paid(SEATS, ENG4, cond)
		var down := await _paid(SEATS, ENG4, cond, int(FALLS[nm]))
		print("    %s: a drafted party, all standing — paid on %d; its hero down at the opening — paid on %d" % [
			nm, forward["paid"], down["paid"]])
		# IN A RUN PLAYED FORWARD (§2a, §2b) the condition holds in no fight, and the
		# roll call says the crest pays nothing.
		ok(int(forward["paid"]) == 0 and bool(forward["told"]),
			"§2c: %s's condition held for a drafted party with all four standing (paid on %d) — it is reachable, and authorable" % [nm, forward["paid"]])
		# THE POSITIVE ARM: the key is live — it holds the moment that hero is down
		# as the fight opens, which is the one state a run reaches only by a quit.
		ok(int(down["paid"]) == 4, "§2c: %s's condition paid on %d with its hero down at the opening — the key reads nothing" % [nm, down["paid"]])
	# AND THAT STATE, REACHED THE ONLY WAY A RUN REACHES IT: a hero falls, the
	# process goes, and Continue restarts the fight with him down (GH).
	# BATCH HP §1 — on `dmg_bonus`, a field the live door carries (`_paid`'s reason).
	var pay := {"stat": {"dmg_bonus": CREST_DMG}, "condition": {"heroes_all_standing": false}}
	var s: Node = await _battle(SEATS, ENG4, pay, true)
	var hp_first: Array = []
	for u in _heroes(s):
		hp_first.append(float((u as BattleUnit).dmg_bonus))
	var mage: BattleUnit = _heroes(s)[1]
	mage.take_hit(999999, 0)
	await process_frame
	ok(mage.dead and int(_run.party[1]["hp"]) == 0, "§2c: the Mage's fall did not reach the run")
	ok(_run.load_run(), "§2c: the save the fall wrote did not load")
	var back := String(_run.resume_scene())
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var s2 := await _to(back)
	await Gate.frames(self, 8)
	# THE FIGHT IS KNOWN BY WHAT IT IS, NEVER BY ITS FILE. DB §1's sweep (`check_da`)
	# reads a gate that names the fight scene's path as one that builds the fight by
	# hand; this one is opened by the run's own resume, and the arm asks what opened.
	ok(_is_battle(s2), "§2c: the resume opened %s, not the fight" % back)
	var hp_back: Array = []
	var down_n := 0
	var back_heroes: Array = _heroes(s2) if _is_battle(s2) else []
	for u2 in back_heroes:
		hp_back.append(float((u2 as BattleUnit).dmg_bonus))
		if (u2 as BattleUnit).dead:
			down_n += 1
	var gained := 0
	for i in mini(hp_first.size(), hp_back.size()):
		if is_equal_approx(float(hp_back[i]) - float(hp_first[i]), CREST_DMG):
			gained += 1
	print("    the fight as first opened: %s; the same fight resumed after the quit: %s (%d down)" % [hp_first, hp_back, down_n])
	ok(down_n == 1 and gained == 4,
		"§2c: the fight resumed after a quit opened with %d down and the fixture paid on %d — the state GH's ruling makes costly is the one a fallen-hero condition pays in" % [down_n, gained])


# ── §2d — THE THREE ARE IN THE FILE, UNDER THE RULED NAMES ─────────────────
# BATCH HP §2 — HO held the three back because, read at the spawn, none could pay in
# a run played forward (§2a–§2c), and this arm held them out of the file for that
# reason. HP reads the four's standing as the fight runs and authored them, so the
# arm's question — is a crest rune in the file that can never pay? — is asked of
# what HP built: each of the three carries the condition HO specified, under the name
# the designer ruled, every live crest rune that carries one is read through the
# live door, and the two names HO proposed are in no entry.

func _s2d_the_three_are_authored() -> void:
	print("\n§2d — the file holds the three under their ruled names, each on the condition HO specified")
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var crest_ids: Array = []
	var live_ids: Array = []
	var conditioned := {}
	var not_live: Array = []
	var old_named: Array = []
	for id in (data as Dictionary):
		var e: Dictionary = (data as Dictionary)[id]
		if String(e.get("scope", "")) == "party":
			crest_ids.append(String(id))
			var c0: Dictionary = (e.get("payload", {}) as Dictionary).get("condition", {})
			if not e.has("retired"):
				live_ids.append(String(id))
				if not c0.is_empty():
					conditioned[String(e.get("name", ""))] = c0
					if not Talents.is_live(e.get("payload", {})):
						not_live.append(String(id))
		for old in HO_NAMES:
			if String(e.get("name", "")).to_lower() == String(old).to_lower():
				old_named.append(String(id))
	crest_ids.sort()
	live_ids.sort()
	ok((data as Dictionary).size() > 100, "§2d: data/runes.json read back %d entries" % (data as Dictionary).size())
	ok(crest_ids == ["dead_air", "dirge", "empty_pulpit", "fellowship", "tithe"]
			and live_ids == ["dead_air", "dirge", "empty_pulpit", "tithe"],
		"§2d: the file's crest runes are %s, %s of them live" % [crest_ids, live_ids])
	var wrong: Array = []
	for nm in HELD_BACK:
		if str(conditioned.get(nm, {})) != str(HELD_BACK[nm]):
			wrong.append("%s: %s" % [nm, conditioned.get(nm, "<not authored>")])
	ok(wrong.is_empty() and conditioned.size() == HELD_BACK.size(),
		"§2d: the crest's conditions are not the three HO specified under the ruled names — %s (every conditioned crest rune: %s)"
			% [wrong, conditioned.keys()])
	ok(not_live.is_empty(),
		"§2d: a live crest rune's condition is read only at the spawn — %s; §2a–§2c say it can never pay" % [not_live])
	ok(old_named.is_empty(), "§2d: a name HO proposed and the designer ruled out is authored — %s" % [old_named])
	# §2 — A RUNE THAT READS WHO STANDS SAYS WHEN IT READS IT (ruled at HO §2; re-pointed
	# at HP §1): a condition read as the fight runs says *while*, and one read once says
	# *as the fight opens* or *enter a fight*. The arm is the population, both kinds.
	var standing_runes := 0
	var unsaid: Array = []
	for id2 in (data as Dictionary):
		var e2: Dictionary = (data as Dictionary)[id2]
		var c: Dictionary = (e2.get("payload", {}) as Dictionary).get("condition", {})
		var reads_who := false
		for k in c:
			if String(k).begins_with("heroes_"):
				reads_who = true
		if reads_who:
			standing_runes += 1
			var words := String(e2.get("desc", "")).to_lower()
			var said: bool = words.contains("while") if Talents.is_live(e2.get("payload", {})) \
				else (words.contains("as the fight opens") or words.contains("enter a fight"))
			if not said:
				unsaid.append(String(id2))
	print("    CHECKED %d runes that read who stands" % standing_runes)
	ok(standing_runes >= 3 and unsaid.is_empty(),
		"§2d: %d runes read who stands, and these do not say when they read it: %s" % [standing_runes, unsaid])


# ── §3 — `heroes_all_standing`, BOTH VALUES, BOTH PARTIES ───────────────────

func _s3_all_standing() -> void:
	print("\n§3 — heroes_all_standing: both values against both parties")
	var f_up := await _paid(SEATS, ENG4, {"heroes_all_standing": false})
	var f_down := await _paid(SEATS, ENG4, {"heroes_all_standing": false}, 1)
	var t_up := await _paid(SEATS, ENG4, {"heroes_all_standing": true})
	var t_down := await _paid(SEATS, ENG4, {"heroes_all_standing": true}, 1)
	var none_up := await _paid(SEATS, ENG4, {})
	var none_down := await _paid(SEATS, ENG4, {}, 1)
	print("    false: all standing %d, the Mage fallen %d; true: all standing %d, the Mage fallen %d; not asked: %d and %d" % [
		f_up["paid"], f_down["paid"], t_up["paid"], t_down["paid"], none_up["paid"], none_down["paid"]])
	ok(int(f_up["paid"]) == 0 and bool(f_up["told"]),
		"§3: `false` with all four standing paid on %d — the value is read as not asked" % f_up["paid"])
	ok(int(f_down["paid"]) == 4, "§3: `false` with the Mage fallen paid on %d" % f_down["paid"])
	ok(int(t_up["paid"]) == 4, "§3: `true` with all four standing paid on %d" % t_up["paid"])
	ok(int(t_down["paid"]) == 0 and bool(t_down["told"]), "§3: `true` with the Mage fallen paid on %d" % t_down["paid"])
	# THE KEY'S PRESENCE IS WHAT ASKS: a condition without it holds for either party.
	ok(int(none_up["paid"]) == 4 and int(none_down["paid"]) == 4,
		"§3: a condition that does not carry the key paid on %d and %d" % [none_up["paid"], none_down["paid"]])
	# The door itself, with no party handed: a hero key reads false (HL §6's safe
	# direction), whichever value it carries.
	ok(not Talents.party_condition_met({"heroes_all_standing": false}, [])
			and not Talents.party_condition_met({"heroes_all_standing": true}, []),
		"§3: a standing key with no party in the ctx holds")


# ── §4 — THE REPLACE-NOT-ADD TRAP ───────────────────────────────────────────

func _unit_defaults() -> Dictionary:
	var probe := BattleUnit.new()
	var out := {}
	for p in probe.get_property_list():
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var v: Variant = probe.get(String(p["name"]))
			if (v is int or v is float) and float(v) != 0.0:
				out[String(p["name"])] = v
	probe.free()
	return out


func _s4_the_trap() -> void:
	print("\n§4 — the replace-not-add trap: every numeric default that is not zero is carried")
	# (1) THE POPULATION, DERIVED OFF THE UNIT'S DECLARATIONS AND NOT OFF A LIST.
	var defaults := _unit_defaults()
	var names: Array = defaults.keys()
	names.sort()
	print("    CHECKED %d numeric unit fields whose default is not zero: %s" % [names.size(), names])
	ok(names.size() >= 9 and names.has("healing_received_mult") and names.has("parry_chance")
			and names.has("mercy_threshold") and names.has("second_max"),
		"§4: the population lost the fields the census named: %s" % [names])
	var uncarried: Array = []
	var wrong: Array = []
	for k in SEATS:
		var cfg: Dictionary = Classes.hero_config(String(k))
		for f in names:
			if not cfg.has(f):
				uncarried.append("%s/%s" % [k, f])
	# CARRIED AT THE DEFAULT, EXCEPT THE ONE SENTINEL, which is carried as the
	# baseline the roll reads for a hero — and what a class or a lineage sets wins.
	var mage_cfg: Dictionary = Classes.hero_config("mage")
	for f2 in ["healing_received_mult", "mercy_threshold", "overcharge_mult", "second_max",
			"mod_bd_mult", "mod_cost_mult", "mod_speed_mult"]:
		if not is_equal_approx(float(mage_cfg.get(f2, -99.0)), float(defaults[f2])):
			wrong.append("%s carried as %s, declared %s" % [f2, mage_cfg.get(f2), defaults[f2]])
	ok(uncarried.is_empty(), "§4: a hero's config does not carry %s before any payload" % [uncarried])
	ok(wrong.is_empty(), "§4: a carried default is not the unit's own: %s" % [wrong])
	ok(is_equal_approx(float(defaults["parry_chance"]), -1.0)
			and is_equal_approx(float(mage_cfg.get("parry_chance", -99.0)), BattleUnit.HERO_PARRY_CHANCE),
		"§4: the parry sentinel is carried as %s, not the hero's baseline" % mage_cfg.get("parry_chance"))
	# THE POSITIVE ARM OF "A CLASS'S OWN FIGURE WINS": the Warrior's armor is his.
	ok(is_equal_approx(float(Classes.hero_config("warrior")["armor"]), 0.25),
		"§4: the defaults overwrote a class's own figure")
	# THE DOOR: a payload adds into the config, from what the config carries.
	var cfg2: Dictionary = Classes.hero_config("warrior")
	Talents.apply_payload(cfg2, {"stat": {"healing_received_mult": 0.2}}, 1, {})
	ok(is_equal_approx(float(cfg2["healing_received_mult"]), 1.2),
		"§4: +0.20 healing received on the Warrior's config reads %s" % cfg2["healing_received_mult"])

	# (2) THE TWO A CREST WOULD REACH FOR, ON A REAL BATTLE, BOTH WAYS.
	var t_w: Node = await _battle(SEATS, ENG4, {"stat": {"healing_received_mult": 0.2, "parry_chance": 0.1}}, true)
	var mult_w: Array = []
	var parry_w: Array = []
	for u in _heroes(t_w):
		mult_w.append(snappedf(float((u as BattleUnit).healing_received_mult), 0.01))
		parry_w.append(snappedf(float((u as BattleUnit).parry_chance), 0.01))
	var war_w: BattleUnit = _heroes(t_w)[0]
	war_w.hp = 1
	var healed_w := war_w.heal_amount(100)
	var t_o: Node = await _battle(SEATS, ENG4, {}, false)
	var mult_o: Array = []
	var parry_o: Array = []
	for u2 in _heroes(t_o):
		mult_o.append(snappedf(float((u2 as BattleUnit).healing_received_mult), 0.01))
		parry_o.append(snappedf(float((u2 as BattleUnit).parry_chance), 0.01))
	var war_o: BattleUnit = _heroes(t_o)[0]
	war_o.hp = 1
	var healed_o := war_o.heal_amount(100)
	print("    healing received, with the crest's +0.20: %s (without: %s)" % [mult_w, mult_o])
	print("    a heal of 100 on the Warrior lands %d with the crest, %d without" % [healed_w, healed_o])
	print("    parry chance, with the crest's +0.10: %s (without: %s)" % [parry_w, parry_o])
	ok(_approx(mult_o, [1.0, 1.0, 1.15, 1.0]), "§4: healing received without the crest reads %s — Holy Conduit's share moved" % [mult_o])
	ok(_approx(mult_w, [1.2, 1.2, 1.35, 1.2]),
		"§4: +0.20 healing received read %s — it REPLACED the default on a hero" % [mult_w])
	ok(healed_o == 100 and healed_w == 120, "§4: a heal of 100 on the Warrior landed %d with the crest and %d without" % [healed_w, healed_o])
	ok(_approx(parry_o, [0.05, 0.05, 0.05, 0.05]) and _approx(parry_w, [0.15, 0.15, 0.15, 0.15]),
		"§4: +0.10 parry chance read %s against %s — it did not add to the role's baseline" % [parry_w, parry_o])
	# A LINEAGE'S OWN PARRY BASE IS ADDED TO AS WELL, never replaced by the baseline.
	var sm: Node = await _battle(SEATS, ["seasoned", "overburn", "mercy", "pack"], {"stat": {"parry_chance": 0.1}}, true)
	var sm_with := float((_heroes(sm)[0] as BattleUnit).parry_chance)
	var sm0: Node = await _battle(SEATS, ["seasoned", "overburn", "mercy", "pack"], {}, false)
	var sm_bare := float((_heroes(sm0)[0] as BattleUnit).parry_chance)
	print("    the Swordmaster's own parry base: %.2f, and %.2f with the crest's +0.10" % [sm_bare, sm_with])
	ok(sm_bare > BattleUnit.HERO_PARRY_CHANCE and is_equal_approx(sm_with, sm_bare + 0.1),
		"§4: the Swordmaster's parry read %.2f bare and %.2f with +0.10" % [sm_bare, sm_with])

	# (3) EVERY OTHER FIELD OF THE POPULATION A PAYLOAD CAN LAND ON: +delta reads
	# default + delta on each hero the spawn does not re-derive the field for.
	var delta := {"mercy_threshold": 0.1, "overcharge_mult": 0.25, "second_max": 7,
		"mod_bd_mult": 10, "mod_cost_mult": 0.5, "mod_speed_mult": 0.5}
	var d_w: Node = await _battle(SEATS, ENG4, {"stat": delta}, true)
	var added := 0
	var asked := 0
	var missed: Array = []
	var hs: Array = _heroes(d_w)
	for hi in hs.size():
		var h: BattleUnit = hs[hi]
		for f3 in delta:
			# The spawn derives a second resource's ceiling LAST for the hero whose
			# core rune installs one (the Cleric on Mercy here), so a payload there
			# is overwritten — the census's row for it, not the trap.
			if f3 == "second_max" and h.second_resource_name != "":
				continue
			asked += 1
			if is_equal_approx(float(h.get(f3)), float(defaults[f3]) + float(delta[f3])):
				added += 1
			else:
				missed.append("%s on hero %d: %s" % [f3, hi, h.get(f3)])
	print("    CHECKED %d fields on %d heroes: %d read default + delta" % [delta.size(), hs.size(), added])
	ok(hs.size() == 4 and asked >= 20 and added == asked, "§4: a payload did not ADD on %s" % [missed.slice(0, 6)])


# ── §4d — A SAVED RUN HOLDING A RETIRED RUNE THAT PRICES HEALING ────────────

const HEAL_PROBE := 40   # small enough that no hero's missing health caps it


func _healing_on(seat: int, rune_id: String) -> Array:
	_new_run(SEATS, ENG4)
	var r := Runes.build(rune_id)
	r["equipped"] = true
	_run.party[seat]["runes"] = [r]
	# THE SAVE IS THE ROUTE: nothing offers a retired rune, so a hero wears one only
	# because a saved run holds it.
	_run.save_run()
	_run.party[seat]["runes"] = []
	if not _run.load_run():
		return [-1.0, -1]
	var worn: Array = _names(_run.party[seat].get("runes", []))
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	var u: BattleUnit = _heroes(current_scene)[seat]
	u.hp = 1
	var landed := u.heal_amount(HEAL_PROBE)
	return [snappedf(float(u.healing_received_mult), 0.01), landed, worn]


func _s4d_a_saved_run() -> void:
	print("\n§4d — a saved run holding a retired rune that prices healing")
	# [seat, rune, what its text promises]
	var rows := [[0, "vampiric", 0.70], [1, "killing_cold", 0.75], [2, "hollow_chalice", 0.85], [2, "martyr", 1.30]]
	var read := 0
	for row in rows:
		var got: Array = await _healing_on(int(row[0]), String(row[1]))
		read += 1
		var cfg: Dictionary = Runes.config(String(row[1]))
		print("    %s on the %s: healing received x%.2f, a heal of %d lands %d" % [
			cfg.get("name", row[1]), SEATS[int(row[0])], got[0], HEAL_PROBE, got[1]])
		ok(String(cfg.get("retired", "")) != "" and got.size() == 3 and (got[2] as Array).size() == 1,
			"§4d: %s is not a retired rune the save brought back worn" % row[1])
		ok(is_equal_approx(float(got[0]), float(row[2])) and int(got[1]) == int(round(HEAL_PROBE * float(row[2]))),
			"§4d: %s on the %s heals at x%.2f (a heal of %d lands %d), not the x%.2f its words say" % [
				cfg.get("name", row[1]), SEATS[int(row[0])], got[0], HEAL_PROBE, got[1], row[2]])
	ok(read == 4, "§4d: %d of the four rows were driven" % read)


# ── §4e — THE SOURCES ───────────────────────────────────────────────────────

func _s4e_the_sources() -> void:
	print("\n§4e — Holy Conduit adds, and the clamp's comment says what is true")
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(not bs.contains("cfg[\"healing_received_mult\"] = 1.15"),
		"§4e: Holy Conduit SETS the Cleric's healing again — a payload before it is thrown away")
	ok(bs.contains("cfg[\"healing_received_mult\"] = float(cfg.get(\"healing_received_mult\", 1.0))"),
		"§4e: Holy Conduit does not add its share to what the config carries")
	var raw := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var at := raw.find("mult = maxf(mult, 0.0)")
	var win := raw.substr(maxi(at - 1400, 0), 1400) if at > 0 else ""
	# THE POSITIVE ARM FIRST: this is the clamp's own comment.
	ok(at > 0 and win.contains("Batch AA guard") and win.contains("hero_spawn_defaults"),
		"§4e: the heal clamp's comment is not where it was, or does not name the defaults the sum now starts from")
	ok(win != "" and not win.contains("No reachable loadout gets there"),
		"§4e: the clamp's comment still says no loadout reaches it, as a fact about every save")


# ── §5a — THE TWO ENTRIES ───────────────────────────────────────────────────

func _node_fields() -> Dictionary:
	var out := {}
	for n in Talents.tree():
		for f in (((n as Dictionary).get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			out[String(f)] = String((n as Dictionary)["id"])
	return out


func _s5a_the_entries() -> void:
	print("\n§5a — Tithe and Fellowship: the entries")
	var nodes := _node_fields()
	var want := {"tithe": ["rune_blood_communion", "blood_communion"], "fellowship": ["rune_field_medic", "field_medic"]}
	# BATCH HP §3 — HO's two by id, not the route's pair: Fellowship is retired and its
	# entry is KEPT with its payload (ET's contract), so every arm below still holds of it.
	for id in HO_TWO:
		var cfg: Dictionary = Runes.config(id)
		var stat: Dictionary = (cfg.get("payload", {}) as Dictionary).get("stat", {})
		var pair: Array = want[id]
		ok(int(cfg.get("price", 0)) == 150 and not String(cfg.get("name", "")).begins_with("Rune of ")
				and not String(cfg.get("name", "")).contains("("),
			"§5a: `%s` is not bare-named at the flat price (%s, %s)" % [id, cfg.get("name", ""), cfg.get("price", 0)])
		ok(stat.size() == 1 and stat.has(pair[0]) and int(stat[pair[0]]) > 0,
			"§5a: `%s` writes %s" % [id, stat])
		# EM's CHARTER, WHICH BINDS A CREST RUNE AS IT BINDS ANY: the rune writes the
		# `rune_` half, never the counter a node of the one tree writes.
		ok(nodes.has(pair[1]) and not stat.has(pair[1]),
			"§5a: `%s` writes the node's own counter, or no node writes `%s` any more" % [id, pair[1]])
		ok(not (cfg.get("payload", {}) as Dictionary).has("condition"), "§5a: `%s` carries a condition" % id)
		ok(not Runes.rune_tags(id).is_empty() and Runes.rune_shape(id) == ["PASSIVE"],
			"§5a: `%s` has no tag row, or its shape is %s" % [id, Runes.rune_shape(id)])
		# The built instance carries the payload as the unit's typed field wants it.
		var built: Dictionary = Runes.build(id)
		var figure: Variant = ((built.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get(pair[0])
		ok(figure is int, "§5a: `%s`'s figure reaches the unit as %s, not an int" % [id, typeof(figure)])
	ok(String(Runes.config("fellowship").get("desc", "")).contains("each hero's turn"),
		"§5a: Fellowship's words no longer say whose turn pays")


# ── §5b — TITHE, WORN THROUGH A REAL BATTLE ─────────────────────────────────

# One seeded blow of `atk`'s basic on the foe; returns [the Break it dealt, the
# health `low` gained]. `low` is set to a tenth of his health first and is the
# lowest of the four by share.
func _tithe_blow(s: Node, atk: BattleUnit, low: BattleUnit, sd: int) -> Array:
	for h in _heroes(s):
		(h as BattleUnit).hp = (h as BattleUnit).max_hp
	low.hp = maxi(int(low.max_hp / 10), 1)
	var was := low.hp
	var foe := _foe(s)
	foe.hp = foe.max_hp
	foe.stability = 1000000
	foe.pressure = 0
	foe.broken = false
	atk.cooldowns.clear()
	atk.no_cover = 1
	seed(sd)
	await s._resolve(atk, atk.abilities[0], foe, "good")
	return [int(foe.pressure), low.hp - was]


func _s5b_tithe() -> void:
	print("\n§5b — Tithe, worn through a real battle")
	var share := int(((Runes.config("tithe").get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get("rune_blood_communion", 0))
	ok(share > 0, "§5b: Tithe's entry carries no share to drive")
	var with_s: Node = await _battle(SEATS, ENG4, {}, false, -1, "tithe")
	var hs: Array = _heroes(with_s)
	var roll: Array = with_s.get("_rune_roll_call")
	ok(roll.count("the crest: Tithe") == 1, "§5b: the roll call names the crest %d times, not once (%s)" % [roll.count("the crest: Tithe"), roll])
	var on_all := 0
	for h in hs:
		if int((h as BattleUnit).rune_blood_communion) == share and int((h as BattleUnit).blood_communion) == 0:
			on_all += 1
	ok(hs.size() == 4 and on_all == 4, "§5b: the crest's share reached %d of the four heroes" % on_all)
	# EVERY HERO'S BREAK PAYS, and the one paid is the lowest of the four. The lowest
	# is the Warrior but for the Warrior's own blow, when it is the Mage — neither
	# carries a healing multiplier. Each blow is seeded.
	var with_rows: Array = []
	for ai in hs.size():
		var low: BattleUnit = hs[1] if ai == 0 else hs[0]
		with_rows.append(await _tithe_blow(with_s, hs[ai], low, 5100 + ai))
	# THE LOWEST IS BY SHARE OF HEALTH, NOT BY POINTS: the Warrior at a third of a
	# large bar is lower than the Mage at two fifths of a small one.
	for h2 in hs:
		(h2 as BattleUnit).hp = (h2 as BattleUnit).max_hp
	var war: BattleUnit = hs[0]
	var mag: BattleUnit = hs[1]
	war.hp = int(war.max_hp * 0.33)
	mag.hp = int(mag.max_hp * 0.40)
	var war0 := war.hp
	var mag0 := mag.hp
	var foe := _foe(with_s)
	foe.pressure = 0
	(hs[3] as BattleUnit).cooldowns.clear()
	seed(5110)
	await with_s._resolve(hs[3], (hs[3] as BattleUnit).abilities[0], foe, "good")
	ok(war0 > mag0 and war.hp > war0 and mag.hp == mag0,
		"§5b: the Warrior at %d (a third) and the Mage at %d (two fifths): the heal went to the Warrior %d and the Mage %d" % [
			war0, mag0, war.hp - war0, mag.hp - mag0])
	# THE CONTROL ARM: the same seeded blows with the crest empty. What Tithe pays is
	# the difference, so a heal a hero's own kit lands on the lowest is not read as it.
	var bare: Node = await _battle(SEATS, ENG4, {}, false)
	var bh: Array = _heroes(bare)
	var bare_rows: Array = []
	for bi in bh.size():
		var low2: BattleUnit = bh[1] if bi == 0 else bh[0]
		bare_rows.append(await _tithe_blow(bare, bh[bi], low2, 5100 + bi))
	var rows: Array = []
	var paid_rows := 0
	var bare_bd := 0
	for ri in mini(with_rows.size(), bare_rows.size()):
		var bd := int(with_rows[ri][0])
		bare_bd += int(bare_rows[ri][0])
		var tithe := int(with_rows[ri][1]) - int(bare_rows[ri][1])
		var want := maxi(int(round(bd * share / 100.0)), 1) if bd > 0 else 0
		rows.append("%s: %d Break, +%d healed (want %d; %d with the crest empty)" % [
			SEATS[ri], bd, tithe, want, bare_rows[ri][1]])
		if bd > 0 and bd == int(bare_rows[ri][0]) and tithe == want:
			paid_rows += 1
	print("    Tithe at %d%%: %s" % [share, rows])
	ok(bare_bd > 0 and paid_rows == 4, "§5b: Tithe paid the rule's share on %d of the four heroes' blows: %s" % [paid_rows, rows])
	# A PAYOUT SUMS (EM): a Warrior who wears the tree's node as well pays both shares
	# from the one site — never the node's alone, and never twice.
	var node_pct := 0
	for n in Talents.tree():
		if String((n as Dictionary)["id"]) == "tn_break_heal":
			node_pct = int((n as Dictionary)["payload"]["stat"]["blood_communion"])
	var both: Node = await _battle(SEATS, ENG4, {}, false, -1, "tithe",
		{0: {"tree": Talents.tree(), "talents": {"tn_break_heal": 1}}})
	var bo: Array = _heroes(both)
	var got3: Array = await _tithe_blow(both, bo[0], bo[1], 5100)
	var paid3 := int(got3[1]) - int(bare_rows[0][1])
	var want3 := maxi(int(round(int(got3[0]) * (share + node_pct) / 100.0)), 1)
	print("    the node (%d%%) and the crest (%d%%) on the Warrior: %d Break healed %d (want %d)" % [node_pct, share, got3[0], paid3, want3])
	ok(node_pct > 0 and int((bo[0] as BattleUnit).blood_communion) == node_pct and int(got3[0]) > 0 and paid3 == want3,
		"§5b: the node's %d%% and the crest's %d%% on one hero healed %d of %d Break, not their sum's %d" % [node_pct, share, paid3, got3[0], want3])


# ── §5c — FELLOWSHIP, WORN THROUGH A REAL BATTLE ────────────────────────────

const AFFLICTIONS := ["slow", "cripple", "exposed"]


# A live stretch of the real battle on autoplay, the warband's health out of reach
# and its attacks off, with three debuffs laid on every hero through the status
# door before a turn is taken. Runs until `want_lines` of the crest's cleanses are
# logged, or `frames` have passed when it is 0. Returns what was washed and left.
func _stretch(crest_id: String, want_lines: int, frames: int, members := {}) -> Dictionary:
	_new_run(SEATS, ENG4)
	if crest_id != "":
		_wear_crest(crest_id)
	for seat in members:
		for k in (members[seat] as Dictionary):
			_run.party[int(seat)][k] = members[seat][k]
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 4)
	var s: Node = current_scene
	for e in s.get("enemies"):
		(e as BattleUnit).max_hp = 90000000
		(e as BattleUnit).hp = 90000000
	var hs: Array = _heroes(s)
	for h in hs:
		# The Cleric's own cleanse is a kit card the bot may cast; it is held on
		# cooldown so the only thing washing here is the rune under test.
		(h as BattleUnit).cooldowns["Unburden"] = 9999
		for a in AFFLICTIONS:
			s._apply_status(h, String(a), 500, 0, 0, _foe(s))
	var laid := 0
	for h2 in hs:
		laid += int(s._status_count(h2))
	var name := String(Runes.config(crest_id).get("name", "")) if crest_id != "" else ""
	var used := 0
	var lines := 0
	while used < frames and not bool(s.get("battle_over")):
		Engine.time_scale = 100.0
		await process_frame
		used += 1
		if want_lines > 0 and used % 20 == 0:
			lines = _log_text(s).count("→ %s: " % name) if name != "" else 0
			if lines >= want_lines:
				break
	Engine.time_scale = 1.0
	OS.set_environment("DOD_AUTOPLAY", "")
	var text := _log_text(s)
	var left := 0
	for h3 in hs:
		left += int(s._status_count(h3))
	var washers := {}
	var crest_lines := 0
	var node_lines := text.count("→ Cleanse Debuffs Each Turn: ")
	if name != "":
		for ln in text.split("\n"):
			var at := String(ln).find("→ %s: " % name)
			if at >= 0:
				crest_lines += 1
				var rest := String(ln).substr(at + ("→ %s: " % name).length())
				washers[rest.substr(0, rest.find(" washes "))] = true
	return {"laid": laid, "left": left, "crest_lines": crest_lines, "node_lines": node_lines,
		"washers": washers.size(), "frames": used, "heroes": hs.size()}


func _s5c_fellowship() -> void:
	print("\n§5c — Fellowship, worn through a real battle")
	var w := await _stretch("fellowship", 8, STRETCH_CAP)
	print("    with Fellowship: %d debuffs laid, %d of its cleanses logged from %d heroes, %d left (%d frames)" % [
		w["laid"], w["crest_lines"], w["washers"], w["left"], w["frames"]])
	ok(int(w["laid"]) == 12 and int(w["crest_lines"]) >= 8,
		"§5c: over the stretch Fellowship logged %d cleanses of the %d debuffs laid" % [w["crest_lines"], w["laid"]])
	# ONE DEBUFF A CLEANSE, AND EVERY ONE SAID: what left the heroes is what the log names.
	ok(int(w["laid"]) - int(w["left"]) == int(w["crest_lines"]) and int(w["node_lines"]) == 0,
		"§5c: %d debuffs left the heroes and the log names %d cleanses of the crest's (and %d of the node's)" % [
			int(w["laid"]) - int(w["left"]), w["crest_lines"], w["node_lines"]])
	# EACH HERO'S TURN PAYS: all four are named as the one who cleansed.
	ok(int(w["washers"]) == 4, "§5c: %d of the four heroes cleansed on their turn" % w["washers"])
	# THE CONTROL ARM, over a longer stretch than the crest's: nothing is washed.
	var o := await _stretch("", 0, int(w["frames"]) * 2 + 400)
	print("    with the crest empty: %d laid, %d left after %d frames" % [o["laid"], o["left"], o["frames"]])
	ok(int(o["laid"]) == 12 and int(o["left"]) == 12 and int(o["node_lines"]) == 0,
		"§5c: with the crest empty %d of %d debuffs were left — something else washes them, and the arm above measured it too" % [o["left"], o["laid"]])
	# ONE LOOP, NO SECOND TICK (EM): the Warrior wearing the tree's node beside the
	# crest washes both figures at his turn — the node's are logged under its name.
	var b := await _stretch("fellowship", 8, STRETCH_CAP, {0: {"tree": Talents.tree(), "talents": {"tn_cleanse": 1}}})
	print("    the node on the Warrior beside the crest: %d of the crest's cleanses and %d of the node's, %d left" % [
		b["crest_lines"], b["node_lines"], b["left"]])
	ok(int(b["node_lines"]) >= 2 and int(b["laid"]) - int(b["left"]) == int(b["crest_lines"]) + int(b["node_lines"]),
		"§5c: with the node beside the crest, %d left the heroes against %d + %d logged" % [
			int(b["laid"]) - int(b["left"]), b["crest_lines"], b["node_lines"]])


# ── §5d — THE HERO SHEET ────────────────────────────────────────────────────

func _s5d_the_sheet() -> void:
	print("\n§5d — the hero sheet applies the crest as the spawn does")
	var ps := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/party_screen.gd"))
	ok(ps.contains("for pr in Run.party_runes:") and ps.contains("Talents.apply_payload(cfg, (pr as Dictionary).get(\"payload\", {}), 1, pay_ctx)"),
		"§5d: the hero sheet no longer stamps the crest's payload on the hero it shows")
	# And the sheet's config is the spawn's: both come through `Classes.hero_config`.
	ok(ps.contains("Classes.hero_config(key)"), "§5d: the hero sheet builds its config somewhere else")


# ── §5e — BR §1: THE FIVE NAMES ─────────────────────────────────────────────

func _s5e_the_names() -> void:
	print("\n§5e — the five names, swept against every name the game holds")
	# THE POPULATIONS ARE GB's TEN, AND FK's AND FO's TWO MORE (BR §1): abilities,
	# enemies and their abilities, glossary terms, items, talent nodes, relics, runes
	# (retired and generated alike), statuses by label — and the lanes and the ids a
	# sweep of labels cannot see. An id is another namespace, so an id equal to a
	# name is a NEAR-miss, never an exact one.
	var pop: Array = []   # [kind, name]
	for id in Runes.ids():
		if String(id) == CREST_FX:
			continue   # this gate's own fixture, still in the loaded table
		pop.append(["rune", Runes.display_name(Runes.config(String(id)))])
		var lane := String(Runes.config(String(id)).get("lane", ""))
		if lane != "" and not pop.has(["lane", lane]):
			pop.append(["lane", lane])
	for t in Runes.TEMPLATES:
		pop.append(["template", "Rune of %s" % String(t["noun"])])
	for ab in Classes.ability_corpus():
		pop.append(["ability", (ab as Ability).display_name])
	for n in Talents.tree():
		pop.append(["node", String((n as Dictionary).get("name", ""))])
	var foes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	for kind in foes:
		pop.append(["enemy", String((foes[kind] as Dictionary).get("unit_name", ""))])
		for fa in (foes[kind] as Dictionary).get("abilities", []):
			var fan := String((fa as Dictionary).get("display_name", ""))
			if not pop.has(["enemy ability", fan]):
				pop.append(["enemy ability", fan])
	for ge in JSON.parse_string(FileAccess.get_file_as_string("res://data/glossary.json")):
		pop.append(["glossary", String((ge as Dictionary).get("term", ""))])
	for item_id in _run.ITEM_INFO:
		pop.append(["item", String((_run.ITEM_INFO[item_id] as Array)[0])])
	for relic_id in Relics.POOL:
		pop.append(["relic", String((Relics.POOL[relic_id] as Dictionary).get("name", ""))])
		pop.append(["relic id", String(relic_id)])
	var statuses: Dictionary = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("STATUS_INFO", {})
	for sid in statuses:
		pop.append(["status", String((statuses[sid] as Array)[0])])
		pop.append(["status id", String(sid)])
	for tag in Classes.TAG_ORDER:
		pop.append(["tag", String(tag)])
	var kinds := {}
	for row0 in pop:
		kinds[String(row0[0])] = int(kinds.get(String(row0[0]), 0)) + 1
	print("    CHECKED %d names in %d populations: %s" % [pop.size(), kinds.size(), kinds])
	ok(pop.size() > 900 and kinds.size() == 14 and kinds.values().all(func(c): return int(c) > 0),
		"§5e: the sweep read %d names in %d populations (%s) — not the game's" % [pop.size(), kinds.size(), kinds])
	for want in FIVE_NAMES:
		var low := String(want).to_lower()
		var exact: Array = []
		var near: Array = []
		for row in pop:
			var nm := String(row[1])
			var nl := nm.to_lower()
			var is_id := String(row[0]).ends_with(" id")
			var tag_row := "%s:%s" % [row[0], nm]
			if nl == low and not is_id:
				# The two the file holds are themselves in the population, once.
				exact.append(tag_row)
			elif nl == low or _near_name(low, nl.replace("_", " ")):
				if not near.has(tag_row):
					near.append(tag_row)
		near.sort()
		# BATCH HP §2 — A NAME THE FILE HOLDS AS A CREST RUNE IS ITS OWN EXACT HIT: HO's
		# two (Fellowship retired and kept) and Empty Pulpit, authored at HP under the
		# name HO proposed. The two HO names the designer ruled out are in no entry.
		var own: Array = ["rune:%s" % want] if (HO_TWO.has(low) or HELD_BACK.has(want)) else []
		print("    %s: exact %s; near %s" % [want, exact, near])
		ok(exact == own, "§5e: '%s' is the name of %s" % [want, exact])
		var known: Array = (NEAR_MISSES[want] as Array).duplicate()
		known.sort()
		ok(near == known, "§5e: '%s' near-misses %s — the named set is %s" % [want, near, known])
	# AND THE WORDS A PLAYER CAN READ THAT ARE IN NO POPULATION: a string the game's
	# scripts hold. Asked of the two that ship, whose names reach a log line and a
	# screen: every literal naming one, as a whole word, is the named set.
	var scripts: Array = []
	for f in DirAccess.get_files_at("res://scripts"):
		if String(f).ends_with(".gd"):
			scripts.append(String(f))
	scripts.sort()
	ok(scripts.size() >= 20, "§5e: the literal sweep read %d scripts" % scripts.size())
	# BATCH HP §2 — EVERY CREST ENTRY THE FILE HOLDS, not the route's pair: HO's two and
	# HP's three, each name swept; a name with no row in `LITERAL_MISSES` is owed none.
	var crest_all: Array = []
	for cr in _all_crest_runes():
		crest_all.append(String((cr as Dictionary).get("id", "")))
	ok(crest_all.size() == 5, "§5e: the literal sweep asks %d crest entries, not the five" % crest_all.size())
	for id2 in crest_all:
		var shipped := Runes.display_name(Runes.config(String(id2)))
		var found: Array = []
		for f2 in scripts:
			for lit in _literals(Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + f2))):
				if _has_word(String(lit), shipped) and not found.has("%s: %s" % [f2, lit]):
					found.append("%s: %s" % [f2, lit])
		found.sort()
		print("    `%s` in a script's own strings: %s" % [shipped, found])
		var named: Array = (LITERAL_MISSES.get(shipped, []) as Array).duplicate()
		named.sort()
		ok(found == named, "§5e: the game's scripts spell '%s' in %s — the named set is %s" % [shipped, found, named])


# Every double-quoted literal of a comment-stripped source, escapes left as written.
func _literals(src: String) -> Array:
	var out: Array = []
	var rx := RegEx.new()
	rx.compile("\"((?:[^\"\\\\\\n]|\\\\.)*)\"")
	for m in rx.search_all(src):
		out.append(m.get_string(1))
	return out


func _has_word(hay: String, word: String) -> bool:
	var at := hay.find(word)
	while at >= 0:
		var before := at == 0 or not _is_letter(hay[at - 1])
		var end := at + word.length()
		var after := end >= hay.length() or not _is_letter(hay[end])
		if before and after:
			return true
		at = hay.find(word, at + 1)
	return false


func _is_letter(ch: String) -> bool:
	return (ch >= "a" and ch <= "z") or (ch >= "A" and ch <= "Z") or ch == "_"


# A NEAR-MISS, WORD BY WORD (BR §1, read as the brief reads it: a near-miss is a
# hit). Two names are near when a word of four letters or more in one is a word of
# the other, sits inside one, or shares its stem — the common opening within one
# letter of the shorter word, or five letters of it — so *Tithe* meets *Tithing*,
# and *Gravesong* meets *Grave* and *Gravelight*. Short words (of, the) are never
# the collision.
func _near_name(a: String, b: String) -> bool:
	for wa in _words(a):
		for wb in _words(b):
			if wa == wb or wa.contains(wb) or wb.contains(wa):
				return true
			var n := 0
			while n < mini(wa.length(), wb.length()) and wa[n] == wb[n]:
				n += 1
			if n >= maxi(4, mini(wa.length(), wb.length()) - 1) or n >= 5:
				return true
	return false


func _words(text: String) -> Array:
	var out: Array = []
	var cur := ""
	for ch in text + " ":
		if (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9"):
			cur += ch
		else:
			if cur.length() >= 4:
				out.append(cur)
			cur = ""
	return out


# ── §6 — THE BLACKSMITH ARM ─────────────────────────────────────────────────

func _s6_the_blacksmith_arm() -> void:
	print("\n§6 — the pairing `test_batch_bk` §3 buys")
	# THE SUITE'S OWN PARTY: four lineages set, nothing earned.
	_run.new_run()
	var specs: Array = ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in _run.party.size():
		_run.party[i]["spec"] = String(specs[i])
	# THE STATE THAT FAILED, DERIVED AND THEN BUILT: a type with exactly one home.
	var lone: Array = []
	var many := ""
	for id in _run.ABILITY_UPGRADES:
		var homes: Array = SuiteFx.upgrade_homes(_run, String(id))
		if homes.size() == 1:
			lone.append([String(id), String(homes[0])])
		elif homes.size() > 1 and many == "":
			many = String(id)
	print("    CHECKED %d upgrade types; with one home in this party: %s" % [(_run.ABILITY_UPGRADES as Dictionary).size(), lone])
	ok(not lone.is_empty() and many != "",
		"§6: no upgrade type fits exactly one card in this party any more — the flake's state is gone, and this arm has nothing to build")
	if lone.is_empty() or many == "":
		return
	var many_homes: Array = SuiteFx.upgrade_homes(_run, many)
	var bad := {"member_idx": 1, "id": lone[0][0], "ability": lone[0][1]}
	var good := {"member_idx": 0, "id": many, "ability": String(many_homes[0])}
	# THE COUNTER THAT USED TO FAIL: the lone pairing first. HEAD's arm bought
	# `offer[0]`; the repaired arm buys the first with another home.
	ok(SuiteFx.pairing_with_another_home(_run, [bad, good]) == 1,
		"§6: with %s on %s first on the counter, the arm would buy pairing %d — the one whose type has no other card" % [
			bad["id"], bad["ability"], SuiteFx.pairing_with_another_home(_run, [bad, good])])
	# THE COUNTER THAT NEVER DID: nothing moves.
	ok(SuiteFx.pairing_with_another_home(_run, [good, bad]) == 0,
		"§6: with a many-homed pairing first, the arm no longer buys the first")
	# AND A COUNTER OF LONE PAIRINGS ONLY HAS NOTHING TO ASK, AND SAYS SO.
	ok(SuiteFx.pairing_with_another_home(_run, [bad]) == -1, "§6: a counter holding only the lone pairing was given a pairing to buy")
	# The suite itself calls the helper where it bought the first pairing.
	var bk := Gate.strip_comments(FileAccess.get_file_as_string("res://test_batch_bk.gd"))
	ok(bk.contains("var buy_at: int = SuiteFx.pairing_with_another_home(run, offer)")
			and bk.contains("var bought: Dictionary = offer[maxi(buy_at, 0)]") and bk.contains("run.buy_blacksmith(bought)")
			and not bk.contains("var buyer: Dictionary = run.party[int(offer[0][\"member_idx\"])]\n\tvar before"),
		"§6: `test_batch_bk` §3 does not buy the pairing the helper names")


# ── §7 — ELEVATION ──────────────────────────────────────────────────────────

func _s7_elevation() -> void:
	print("\n§7 — Elevation's card names the cap, and no figure a constant holds but its own grant")
	var ab: Ability = Classes.pool_ability("Elevation")
	ok(ab != null and String(ab.description) == ELEVATION_WORDS,
		"§7: Elevation reads '%s'" % (String(ab.description) if ab != null else "<missing>"))
	var longest := 0
	for ln in ELEVATION_WORDS.split("\n"):
		longest = maxi(longest, String(ln).length())
	ok(longest <= 44, "§7: a line of the card is %d characters, over the 44 it is broken to" % longest)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# THE ONE FIGURE IT KEEPS IS THE CARD'S OWN, and the constant still holds it.
	var bs := Gate.strip_comments(bsrc)
	var rx := RegEx.new()
	rx.compile("const ELEVATION_STACKS := (\\d+)")
	var m := rx.search(bs)
	ok(m != null and ELEVATION_WORDS.contains("gains %s\nstacks" % m.get_string(1)),
		"§7: the card's grant and `ELEVATION_STACKS` disagree")
	var digits := RegEx.new()
	digits.compile("\\d+")
	var found: Array = []
	for d in digits.search_all(ELEVATION_WORDS):
		found.append((d as RegExMatch).get_string())
	ok(m != null and found == [m.get_string(1)], "§7: the card names the figures %s — only its own grant may stand" % [found])
	# THE HANDLER'S COMMENT, in its own window (the positive arm first).
	var anchor := "\n\t\t\"elevation\":\n"
	var at := bsrc.find(anchor)
	var end := bsrc.find("if _living_devout() == null:", at)
	var win := bsrc.substr(at, end - at) if at >= 0 and end > at else ""
	ok(bsrc.count(anchor) == 1 and win.contains("THE RELEASE IS THE POINT") and end - at < 1600,
		"§7: the window is not Elevation's handler comment (%d chars)" % (end - at))
	var stale := RegEx.new()
	stale.compile("(?i)holding 3|reaches 5|at three")
	ok(win != "" and stale.search(win) == null and win.contains("FAITH_RELEASE"),
		"§7: Elevation's handler comment still speaks the threshold as a number")
	var csrc := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var c_at := csrc.find("\t\t\"Elevation\":\n\t\t\treturn Ability.make")
	var c_win := csrc.substr(maxi(c_at - 1500, 0), 1500) if c_at > 0 else ""
	ok(c_at > 0 and c_win.contains("BINDING OATH swears him a stack") and stale.search(c_win) == null,
		"§7: the comment above Elevation's definition still speaks the threshold as a number")
	# THE RULE, WHERE A FUTURE SESSION READS IT.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.length() > 100000 and cm.contains("CARD TEXT AND COMMENTS DO NOT NAME A MAGNITUDE A CONSTANT HOLDS"),
		"§7: CLAUDE.md does not carry the standing rule the ruling set")


# ── §8 — THE COPIES' POLICY ─────────────────────────────────────────────────

func _s8_the_policy() -> void:
	print("\n§8 — the isolated copies' policy, in the file the rule lives in")
	# PINNED AGAINST THE REFERENCE, NEVER AGAINST THE INDEX ROW THAT NAMES IT (EF §2:
	# a row is heading text, and a pin it satisfies has stopped asking).
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var head := ir.find("## STANDING RULE — A BATCH CLEARS THE PREVIOUS BATCH'S ISOLATED COPIES WHEN IT FINISHES")
	var block := ir.substr(head, 2400) if head >= 0 else ""
	ok(ir.length() > 50000 and head >= 0, "§8: docs/instrument-rules.md does not carry the copies' policy")
	ok(block.contains("One batch's worth stays for") and block.contains("`config/name`")
			and block.contains("`../save-backups/` IS NEVER TOUCHED"),
		"§8: the policy no longer says what stays, why a copy leaves a folder, or that the backups are never touched")


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§9: %s changed under this gate" % p)
