# BATCH HW — FOUR DEFECTS FROM THE PLAYTEST, THE MERCHANT'S NEW PLACE, AND THE SIX CARD-VERSUS-CODE ITEMS.
#
# What this gate asserts, section by section (`docs/reports/HW.md` has the working):
#
#   §1c  A HERO'S OWN PICK OF THREE HOLDS NO CREST RUNE: the roll leaves the crest's runes out, a triple queued
#        holding one is repaired at its answer, and the bargain pays a hero who has a class rune left — while the
#        drop, the Peddler and the event verb still hand a crest rune over (the positive arms).
#   §1d  NO TWO ENEMY CLICK ZONES OVERLAP: every layout the spawn has, with the smallest and the largest bodies on
#        the field, and a real spawn of six — and every zone still covers its own body.
#   §2   THE MERCHANT IS AN EASY FIGHT'S REWARD: severity 1 can pay it and severity 4 cannot; over sampled offers
#        at every rung a merchant comes only with a severity-1 modifier, and the gate still holds it out of the
#        run's first three nodes while an option there still pays.
#   §3a  MARK OF THE HUNT RESETS WHEN ITS MARKED ENEMY DIES, through `_die()` — and not when an unmarked one does.
#   §3b  CHARGE'S DAZE IS 2 TURNS AND 3 ON A PERFECT, and after the bearer's turn starts it still covers his attack.
#   §3c  BLOOD DEBT PAYS ON THE BLEEDOUT THAT KILLS, as on one that does not — and an unmarked body pays nothing.
#   §3d  COUNTER TIME AND SNARE LINE SAY WHAT THE CODE DOES (one turn; no harder bind), and no magnitude moved.
#   §3e  THIN BLOOD'S PRICE IS CHARGED: his Poison deals nothing at the tick — laid by `_apply_poison`, by the
#        barb itself and by Explosive Shot — while without the rune, or with Trapper merely owned, it bites, and a
#        Poison laid with no tick given still deals the legacy figure.
#   §5   The record: the rite's rank confirmed in `CLAUDE.md`, the crest's roll scope there, and the process rule in
#        `docs/ways-of-working.md`.
#   §9   The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: §1a (Boil Over) and §1b (the Sharpshooter's
# core taken after class selection) change nothing — both are owed a ruling — so each is PRINTED as a record,
# never asserted. `Run` is fetched off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://hw_profile.json"
const SCRATCH_RELICS := "user://hw_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
# The live crest runes §1c asks after — any two the file holds live (HO's own pair, Dirge for Fellowship).
const CRESTS := ["tithe", "dirge"]
const OFFER_ROLLS := 400
const SEED := 7051

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HW — FOUR DEFECTS, THE MERCHANT'S PLACE, AND THE SIX CARD-VERSUS-CODE ITEMS")
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
	await _s1a_boil_over_record()
	await _s1b_sharpshooter_record()
	_s1c_the_class_draft()
	await _s1d_the_click_zones()
	_s2_the_merchant()
	await _s3a_mark_of_the_hunt()
	await _s3b_charge()
	await _s3c_blood_debt()
	await _s3d_the_words()
	await _s3e_thin_blood()
	_s5_the_record()
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


# A board with one hero seated by `spec`, wearing `runes`, his lineage's engine equipped or merely owned —
# the other three seated by nothing. (`check_gw`'s shape.)
func _board(spec: String, runes: Array = [], equip := true, extra := {}) -> Node:
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
	for rid in runes:
		var r2: Dictionary = Runes.build(String(rid))
		r2["equipped"] = true
		worn.append(r2)
	over[seat]["runes"] = worn
	for k in extra:
		over[seat][k] = extra[k]
	var s: Node = await Gate.spawn(self, specs, {"party": over, "deterministic": true})
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


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


func _card(name: String) -> Ability:
	var ab := Classes.pool_ability(name)
	if ab == null:
		ab = Classes.draft_ability(name)
	return ab


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
	_run.items = {}


func _ids(list: Array) -> Array:
	var out: Array = []
	for r in list:
		out.append(String((r as Dictionary).get("id", "")))
	out.sort()
	return out


func _crest_ids(list: Array) -> Array:
	return _ids(list).filter(func(id): return Runes.is_party_scope(String(Runes.config(String(id)).get("scope", ""))))


# Every rune the four could be offered right now, less what the party holds — the drop's own union.
func _offerable_now() -> Array:
	var out: Array = []
	var held: Array = _run.party_rune_names()
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


# PARK every rune the party could be offered but `keep` on the waiting list, where `Run.party_rune_names` reads it
# as held — so what a real roll has left to hand over is `keep`. A dressing of the POOL; the roll is the game's.
func _park_all_but(keep: Array) -> void:
	for id in _offerable_now():
		if not keep.has(String(id)):
			_run.pending_rune_drops.append(Runes.build(String(id)))


# One class rune the Mage could be offered, by id: the positive half of §1c's park.
func _a_mage_rune() -> String:
	for id in _offerable_now():
		var cfg: Dictionary = Runes.config(String(id))
		if String(cfg.get("scope", "")) == "class:mage" and not Runes.is_engine_rune(String(id)):
			return String(id)
	return ""


# ── §1a — BOIL OVER, RECORDED ──────────────────────────────────────────────

func _s1a_boil_over_record() -> void:
	print("\n§1a — Boil Over: what the card says and what the code pays (a record; owed a ruling, never asserted)")
	var bo := _card("Boil Over")
	print("    the card: %s" % String(bo.description).replace("\n", " ") if bo != null else "    the card: <none>")
	for with_engine in [true, false]:
		var s: Node = await _board("berserker", [], with_engine)
		var war: BattleUnit = _hero(s, "warrior")
		var foe: BattleUnit = _foes(s)[0]
		war.hp = int(war.max_hp * 0.5)
		war.resource = war.max_resource
		var bonus: float = war.frenzy_bonus() if war.has_engine("bloodrage") else 0.0
		foe.max_hp = maxi(foe.max_hp, 100000)
		foe.hp = foe.max_hp
		var before := foe.hp
		seed(SEED)
		await s._resolve(war, bo, foe, "good")
		print("    [%s] live Blood Frenzy +%d%% before the cast; the blow took %d; Rage booked to the bar's ledger %d; recovery chip %s" % [
			"the Berserker's core slotted" if with_engine else "no Blood Frenzy (a Warrior on another core)",
			int(round(bonus * 100.0)), before - foe.hp, war.rage_spent, war.has_status("boil_over")])
		await _clear(s)


# ── §1b — THE SHARPSHOOTER'S CORE TAKEN AFTER CLASS SELECTION, RECORDED ───

func _s1b_sharpshooter_record() -> void:
	print("\n§1b — the Sharpshooter's core: class selection slots it; a later pick holds it unworn (a record; owed a ruling)")
	_new_run()
	var m: Dictionary = _run.party[3]
	print("    after class selection on Pack Bond: kit %s" % str(_run.opening_kit_names(m)))
	var r: Dictionary = Runes.build("engine_sharpshooter")
	r["equipped"] = false
	var landed: String = _run.hold_rune(m, r)
	print("    the Sharpshooter's core taken as the map's pick takes it (%s): engines worn %s, kit %s" % [
		landed, str(_run.held_engines(m)), str(_run.opening_kit_names(m))])
	var rows: Array = _run.engine_rows(m)
	for i in rows.size():
		if String((rows[i]["rune"] as Dictionary).get("engine", "")) == "lethal_aim":
			_run.toggle_engine(m, i)
	print("    slotted on the hero's panel: engines worn %s, kit %s" % [str(_run.held_engines(m)), str(_run.opening_kit_names(m))])


# ── §1c — A HERO'S OWN PICK OF THREE IS HIS CLASS'S ────────────────────────

func _s1c_the_class_draft() -> void:
	print("\n§1c — a hero's own pick of three holds no crest rune; every other roll still offers one")
	_new_run()
	var mage: Dictionary = _run.party[1]
	var cls := _a_mage_rune()
	ok(cls != "", "§1c: no class rune is left to offer the Mage — the arm would read nothing")
	_park_all_but(CRESTS + [cls])
	# THE ROLL: what is left is one class rune and two crest runes; the pick hands over the class rune alone.
	var triple: Array = _run.roll_rune_candidates(mage)
	print("    the pool parked to %s: the Mage's pick of three offered %s" % [str(CRESTS + [cls]), str(_ids(triple))])
	ok(_crest_ids(triple).is_empty(), "§1c: the Mage's own pick of three offered a crest rune: %s" % str(_ids(triple)))
	ok(_ids(triple) == [cls], "§1c: the pick did not offer the class rune left (%s) — the scope emptied it: %s" % [cls, str(_ids(triple))])
	# THE ANSWER: a triple queued before HW, holding two crest runes and the class rune, is repaired.
	var queued: Array = [Runes.build("tithe"), Runes.build(cls), Runes.build("dirge")]
	mage["rune_candidates"] = [queued]
	mage["rune_picks_owed"] = 1
	var live: Array = _run.rune_choice(mage)
	var stored: Array = (mage.get("rune_candidates", []) as Array)[0] if not (mage.get("rune_candidates", []) as Array).is_empty() else []
	print("    a queued triple %s answers as %s, stored as %s" % [str(_ids(queued)), str(_ids(live)), str(_ids(stored))])
	ok(_crest_ids(live).is_empty() and live.size() >= 1, "§1c: the queued triple's answer still holds a crest rune: %s" % str(_ids(live)))
	ok(_crest_ids(stored).is_empty(), "§1c: the repair was not written back — the stored triple holds %s" % str(_ids(stored)))
	ok(_ids(live).has(cls), "§1c: the repair threw the class rune away with the crest's: %s" % str(_ids(live)))
	mage["rune_candidates"] = []
	mage["rune_picks_owed"] = 0
	# THE DROP, THE POSITIVE ARM: the same parked pool, and the drop still hands a crest rune over.
	var dropped := {}
	for _i in 60:
		var d: Dictionary = _run.roll_fight_drop()
		if not d.is_empty():
			dropped[String(d.get("id", ""))] = int(dropped.get(String(d.get("id", "")), 0)) + 1
	print("    the drop over 60 rolls of the same pool: %s" % str(dropped))
	ok(int(dropped.get("tithe", 0)) + int(dropped.get("dirge", 0)) > 0,
		"§1c: the drop no longer offers a crest rune — the scope reached the drop: %s" % str(dropped))
	# THE PEDDLER AND THE EVENT VERB: with the class rune parked too, each hands the crest's over.
	_run.pending_rune_drops.append(Runes.build(cls))
	var sold: Dictionary = _run.peddler_rune(mage)
	var granted: Dictionary = _run.grant_rune(mage)
	print("    the class rune parked as well: the Peddler offers %s, the event verb grants %s" % [
		String(sold.get("id", "<none>")), String(granted.get("id", "<none>"))])
	ok(CRESTS.has(String(sold.get("id", ""))), "§1c: the Peddler no longer sells a crest rune (%s)" % String(sold.get("id", "<none>")))
	ok(CRESTS.has(String(granted.get("id", ""))), "§1c: the event verb no longer grants a crest rune (%s)" % String(granted.get("id", "<none>")))
	# ...and in the same pool the Mage's pick of three is empty: nothing of his class is left.
	ok(_run.roll_rune_candidates(mage).is_empty(), "§1c: with only the crest's runes left the Mage's pick still offered something")
	# THE BARGAIN: the Mage has only crest runes left and the Warrior a class rune — the bargain pays the Warrior.
	_run.pending_rune_drops = []
	var war: Dictionary = _run.party[0]
	var keep_war := ""
	for id in Runes.eligible_ids(war, Runes.owned_names(war, _run.party_rune_names())):
		if String(Runes.config(String(id)).get("scope", "")) == "class:warrior" and not Runes.is_engine_rune(String(id)):
			keep_war = String(id)
			break
	_park_all_but(CRESTS + [keep_war])
	var paid := {}
	for _j in 12:
		war["rune_candidates"] = []
		mage["rune_candidates"] = []
		_run.pending_reward = {"kind": "rune"}
		var line: String = String(_run.claim_reward().get("text", ""))
		for m2 in _run.party:
			if not (m2.get("rune_candidates", []) as Array).is_empty():
				paid[String(m2["key"])] = int(paid.get(String(m2["key"]), 0)) + 1
		if line.contains("nothing left"):
			paid["nothing"] = int(paid.get("nothing", 0)) + 1
	print("    the bargain's rune over 12 claims, the Warrior holding the one class rune left: paid %s" % str(paid))
	ok(int(paid.get("warrior", 0)) == 12, "§1c: the bargain picked a hero it could not pay: %s" % str(paid))
	war["rune_candidates"] = []
	war["rune_picks_owed"] = 0
	mage["rune_picks_owed"] = 0
	_run.pending_rune_drops = []


# ── §1d — NO TWO ENEMY CLICK ZONES OVERLAP ─────────────────────────────────

func _zone(u: BattleUnit) -> Rect2:
	var b: Button = u.get("_target_btn")
	return Rect2(b.position + u.position, b.size)


func _body(u: BattleUnit) -> Rect2:
	var r: Rect2 = u.idle_body_rect()
	return Rect2(r.position + u.position, r.size)


# Every pair of `units`' zones meets nowhere, and every zone covers its own body's middle. Returns the faults.
func _zone_faults(units: Array) -> Array:
	var faults: Array = []
	for i in units.size():
		var zi := _zone(units[i])
		if not zi.has_point(_body(units[i]).get_center()):
			faults.append("%s's zone %s misses its body %s" % [units[i].unit_name, str(zi), str(_body(units[i]))])
		for j in range(i + 1, units.size()):
			var ov := zi.intersection(_zone(units[j]))
			if ov.has_area():
				faults.append("%s and %s overlap %dx%d" % [units[i].unit_name, units[j].unit_name, int(ov.size.x), int(ov.size.y)])
	return faults


func _s1d_the_click_zones() -> void:
	print("\n§1d — an enemy's click zone is its own body, and no two meet")
	var s: Node = await _board("berserker")
	var lay: Dictionary = s.ENEMY_LAYOUTS
	var groups := {
		"the smallest bodies": ["whelp", "grave_totem", "raider", "archer", "whelp", "grave_totem"],
		"the largest bodies": ["hollow_crown", "withered_warden", "ash_tyrant", "behemoth", "chief", "bog_troll"],
		"mixed": ["raider", "behemoth", "archer", "chief", "whelp", "brute"],
	}
	var checked := 0
	var faults: Array = []
	for g in groups:
		for n in lay:
			if int(n) < 2:
				continue
			var units: Array = []
			for i in int(n):
				var cfg: Dictionary = s._enemy_config(String(groups[g][i]))
				cfg.erase("tint")
				units.append(s._make_unit(cfg, lay[n][i], Color.WHITE, Vector2(-2000, -2000)))
			s._fit_enemy_target_zones(units)
			var f := _zone_faults(units)
			checked += 1
			for x in f:
				faults.append("%s, %d: %s" % [g, int(n), x])
			for u in units:
				(u as BattleUnit).queue_free()
	print("    CHECKED %d warbands (layouts 2 to %d, three body sets): %d faults %s" % [checked, lay.size(), faults.size(), str(faults.slice(0, 3))])
	ok(checked == 3 * (lay.size() - 1), "§1d: the sweep read %d warbands" % checked)
	ok(faults.is_empty(), "§1d: %d zone faults, e.g. %s" % [faults.size(), str(faults.slice(0, 3))])
	# THE NEGATIVE THE FIX ANSWERS: the box every unit is built with overlaps its neighbour in the same layouts.
	var raw: Array = []
	for i in 4:
		raw.append(s._make_unit(s._enemy_config("raider"), lay[4][i], Color.WHITE, Vector2(-2000, -2000)))
	var raw_f := _zone_faults(raw)
	print("    the zones as built, before the spawn fits them, in the layout of four: %d faults" % raw_f.size())
	ok(raw_f.size() > 0, "§1d: the zones as built no longer overlap — the arm above asks nothing")
	for u in raw:
		(u as BattleUnit).queue_free()
	await _clear(s)
	# THE REAL SPAWN: six ordinary enemies through the battle's own layout and the spawn's own call, entered
	# from a run with no fixture battle standing beside it.
	_new_run()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, {"type": "fight", "theme": "Warband",
		"enemies": ["raider", "archer", "raider", "archer", "raider", "archer"]})
	Engine.time_scale = 50.0
	await Gate.frames(self, 90)
	Engine.time_scale = 1.0
	var s3: Node = current_scene
	var foes: Array = (s3.get("enemies") as Array) if s3 != null and s3.get("enemies") != null else []
	var real_f := _zone_faults(foes)
	print("    a real spawn of %d: zones %s" % [foes.size(), str(foes.map(func(u): return _zone(u)))])
	ok(foes.size() == 6, "§1d: the real spawn fielded %d enemies, not six" % foes.size())
	ok(real_f.is_empty(), "§1d: the real spawn's zones: %s" % str(real_f))
	await _clear(s3)


# ── §2 — THE MERCHANT IS AN EASY FIGHT'S REWARD ────────────────────────────

func _s2_the_merchant() -> void:
	print("\n§2 — the merchant pays an easy fight; severity 4 pays its gold or a rune")
	var kinds := {}
	for sev in _run.REWARDS:
		kinds[int(sev)] = (_run.REWARDS[sev] as Array).map(func(r): return String(r.get("kind", "")))
	print("    the reward table: %s" % str(kinds))
	ok((kinds[1] as Array).has("shop") and (kinds[1] as Array).has("gold"),
		"§2: severity 1 does not pay its gold or the merchant: %s" % str(kinds[1]))
	ok(not (kinds[4] as Array).has("shop") and (kinds[4] as Array).has("gold") and (kinds[4] as Array).has("rune"),
		"§2: severity 4 does not pay exactly its gold or a rune: %s" % str(kinds[4]))
	for sev2 in [2, 3, 4]:
		ok(not (kinds[sev2] as Array).has("shop"), "§2: severity %d still pays a merchant" % sev2)
	_new_run()
	var counts := {}
	for rung in ["wanderer", "warden", "ruin"]:
		_run.difficulty = rung
		for col in [[0, 0], [0, 2], [0, 3], [1, 1]]:
			_run.zone_idx = int(col[0])
			_run.slot_idx = int(col[1])
			seed(SEED + int(col[1]) + 100 * int(col[0]) + rung.length())
			var key := "%s z%d c%d" % [rung, int(col[0]) + 1, int(col[1]) + 1]
			var c := {"shop": 0, "shop_not_sev1": 0, "sev1": 0, "sev1_gold": 0}
			for _k in OFFER_ROLLS:
				for opt in _run.roll_offer():
					var sev3: int = _run.modifier_severity(String(opt["modifier"]))
					var kind := String((opt["reward"] as Dictionary).get("kind", ""))
					if kind == "shop":
						c["shop"] += 1
						if sev3 != 1:
							c["shop_not_sev1"] += 1
					if sev3 == 1:
						c["sev1"] += 1
						if kind == "gold":
							c["sev1_gold"] += 1
			counts[key] = c
	_run.zone_idx = 0
	_run.slot_idx = -1
	_run.difficulty = "wanderer"
	print("    over %d offers a column: %s" % [OFFER_ROLLS, str(counts)])
	var wrong := 0
	var gated := 0
	var open := 0
	var gated_pay := 0
	for key2 in counts:
		wrong += int(counts[key2]["shop_not_sev1"])
		if String(key2).contains("z1 c1") or String(key2).contains("z1 c3"):
			gated += int(counts[key2]["shop"])
			gated_pay += int(counts[key2]["sev1_gold"])
		else:
			open += int(counts[key2]["shop"])
	ok(wrong == 0, "§2: a merchant came with a modifier above severity 1 (%d times)" % wrong)
	ok(gated == 0, "§2: the bargain offered a merchant in the run's first three nodes (%d)" % gated)
	ok(gated_pay > 0, "§2: a gated severity-1 option paid no gold — the gate emptied it")
	ok(open > 0, "§2: no merchant was offered from node 4 on or in zone 2 — the reward is gone, not moved")
	_run.pending_reward = {"kind": "shop"}
	var paid: Dictionary = _run.claim_reward()
	ok(bool(paid.get("shop", false)) and bool(_run.pending_shop),
		"§2: a merchant won is not owed: %s" % str(paid))
	_run.pending_shop = false


# ── §3a — MARK OF THE HUNT ─────────────────────────────────────────────────

func _s3a_mark_of_the_hunt() -> void:
	print("\n§3a — Mark of the Hunt resets when its marked enemy dies")
	var s: Node = await _board("beastmaster")
	var hunter: BattleUnit = _hero(s, "hunter")
	var mk := _card("Mark of the Hunt")
	ok(mk != null, "§3a: no Mark of the Hunt to cast")
	if mk == null:
		await _clear(s)
		return
	var foes := _foes(s)
	var marked: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	hunter.resource = 99999
	await s._resolve(hunter, mk, marked, "good")
	hunter.cooldowns["Mark of the Hunt"] = maxi(int(hunter.cooldowns.get("Mark of the Hunt", 0)), 3)
	ok(marked.has_status("hunt_mark"), "§3a: the cast did not mark %s" % marked.unit_name)
	# An UNMARKED death first: the cooldown stands.
	other.take_hit(other.hp + 9999, 0)
	ok(other.dead and int(hunter.cooldowns.get("Mark of the Hunt", 0)) > 0,
		"§3a: an unmarked enemy's death reset the card (dead %s, cooldown %d)" % [other.dead, int(hunter.cooldowns.get("Mark of the Hunt", 0))])
	var lw := _log_text(s).length()
	marked.take_hit(marked.hp + 9999, 0)
	print("    marked %s killed through the damage door: dead %s, cooldown left %d" % [
		marked.unit_name, marked.dead, int(hunter.cooldowns.get("Mark of the Hunt", 0))])
	ok(marked.dead and not hunter.cooldowns.has("Mark of the Hunt"),
		"§3a: the marked enemy died and Mark of the Hunt did not reset (%d left)" % int(hunter.cooldowns.get("Mark of the Hunt", 0)))
	ok(_log_text(s).substr(lw).contains("Mark of the Hunt resets"), "§3a: the reset is not in the log")
	await _clear(s)


# ── §3b — CHARGE'S DAZE ────────────────────────────────────────────────────

func _s3b_charge() -> void:
	print("\n§3b — Charge Dazes for 2 turns, 3 on a Perfect")
	var ch := _card("Charge")
	ok(ch != null and int(ch.applies_status.get("turns", 0)) == 2 and ch.perfect_id == "status_one_more",
		"§3b: Charge's card lays %s with Perfect '%s'" % [str(ch.applies_status) if ch != null else "<none>", ch.perfect_id if ch != null else ""])
	ok(ch != null and String(ch.description).contains("DAZED for 2\nturns") and ch.perfect_text == "Dazed for 3 turns",
		"§3b: Charge's words do not say 2 turns, 3 on a Perfect")
	var s: Node = await _board("berserker")
	var war: BattleUnit = _hero(s, "warrior")
	var foes := _foes(s)
	for arm in [["good", foes[0], 2], ["perfect", foes[1], 3]]:
		var foe: BattleUnit = arm[1]
		foe.max_hp = maxi(foe.max_hp, 100000)
		foe.hp = foe.max_hp
		war.resource = 99999
		war.cooldowns.clear()
		await s._resolve(war, ch, foe, String(arm[0]))
		var laid := int(foe.get_status("dazed").get("turns", 0))
		ok(laid == int(arm[2]), "§3b: a %s Charge laid a Daze of %d turns, want %d" % [arm[0], laid, int(arm[2])])
		# The bearer's own turn starts (the tick), and the Daze still stands on the attack that follows it.
		foe.tick_statuses()
		foe.no_cover = 0
		var miss: float = s._miss_chance(foe)
		print("    a %s Charge: Dazed %d turns; after the bearer's turn starts it is Dazed %s, missing %.2f" % [
			arm[0], laid, foe.has_status("dazed"), miss])
		ok(foe.has_status("dazed") and miss > s.MISS_CHANCE,
			"§3b: after the bearer's turn started the %s Charge's Daze covered nothing (miss %.2f)" % [arm[0], miss])
	await _clear(s)


# ── §3c — BLOOD DEBT ───────────────────────────────────────────────────────

func _s3c_blood_debt() -> void:
	print("\n§3c — Blood Debt pays on every bleedout, the killing one included")
	var bd := _card("Blood Debt")
	ok(bd != null, "§3c: no Blood Debt to cast")
	if bd == null:
		return
	for arm in [["kills", true, true], ["does not kill", false, true], ["kills, unmarked", true, false]]:
		var s: Node = await _board("berserker")
		var war: BattleUnit = _hero(s, "warrior")
		var foe: BattleUnit = _foes(s)[0]
		if bool(arm[2]):
			war.resource = 99999
			foe.max_hp = maxi(foe.max_hp, 100000)
			foe.hp = foe.max_hp
			await s._resolve(war, bd, foe, "good")
			ok(foe.has_status("blood_debt"), "§3c [%s]: the cast did not mark the enemy" % arm[0])
		foe.bleed_buildup = 0
		foe.hp = 1 if bool(arm[1]) else foe.max_hp
		war.hp = int(war.max_hp * 0.4)
		var before := war.hp
		var lw := _log_text(s).length()
		await s._add_bleed_with_burst(foe, 100)
		var rose := war.hp - before
		var said := _log_text(s).substr(lw).contains("Blood Debt: %s collects" % war.unit_name)
		print("    a bleedout that %s: the bearer dead %s; the Berserker rose %d; the log says so %s" % [arm[0], foe.dead, rose, said])
		ok(foe.dead == bool(arm[1]), "§3c [%s]: the bleedout's outcome is not the arm's (dead %s)" % [arm[0], foe.dead])
		if bool(arm[2]):
			ok(rose > 0 and said, "§3c [%s]: the bleedout paid the debt nothing (+%d, logged %s)" % [arm[0], rose, said])
		else:
			ok(rose == 0 and not said, "§3c [%s]: an unmarked bleedout paid a debt (+%d)" % [arm[0], rose])
		await _clear(s)


# ── §3d — COUNTER TIME AND SNARE LINE: THE WORDS MOVE, THE CODE DOES NOT ──

func _s3d_the_words() -> void:
	print("\n§3d — Counter Time and Snare Line say what the code does; no magnitude moved")
	var ct := _card("Counter Time")
	var sl := _card("Snare Line")
	ok(ct != null and String(ct.description).contains("loses its next turn.") and not String(ct.description).contains("TWO"),
		"§3d: Counter Time's card does not say one turn")
	ok(sl != null and not String(sl.description).contains("CHILLED") and not String(sl.description).contains("not 1"),
		"§3d: Snare Line's card still promises a chilled two-turn hold")
	ok(sl != null and String(sl.description).contains("teeth, Break and all"), "§3d: Snare Line's card lost its own clause with the cut")
	var s: Node = await _board("swordmaster")
	ok(int(s.COUNTER_TIME_TURNS) == 2 and int(s.SNARE_LINE_COLD_STUN) == 2,
		"§3d: a magnitude moved with the words (Counter Time %d, Snare Line's chill %d)" % [int(s.COUNTER_TIME_TURNS), int(s.SNARE_LINE_COLD_STUN)])
	var sm: BattleUnit = _hero(s, "warrior")
	var foe: BattleUnit = _foes(s)[0]
	foe.broken = true
	sm.stance = "defensive"
	sm.resource = 99999
	var lw := _log_text(s).length()
	await s._resolve(sm, ct, foe, "good")
	var ct_line := ""
	for l in _log_text(s).substr(lw).split("\n"):
		if String(l).contains("Counter Time —"):
			ct_line = String(l)
	print("    Counter Time cast: the stun laid %d; its line reads '%s'" % [
		int(foe.get_status("stunned").get("turns", 0)), ct_line])
	ok(foe.has_status("stunned") and int(foe.get_status("stunned").get("turns", 0)) == 2,
		"§3d: Counter Time's stun is not laid as before (%s)" % str(foe.get_status("stunned")))
	ok(ct_line.ends_with("loses its next turn") and not ct_line.contains("turns"),
		"§3d: Counter Time's line does not say one turn: '%s'" % ct_line)
	await _clear(s)


# ── §3e — THIN BLOOD'S PRICE ───────────────────────────────────────────────

# The poison standing on `foe` ticked through the battle's own pass, twice (a fresh one skips its first): the health
# it cost.
func _ticked(s: Node, foe: BattleUnit) -> int:
	foe.max_hp = maxi(foe.max_hp, 100000)
	foe.hp = foe.max_hp
	var before := foe.hp
	await s._dot_pass(foe)
	await s._dot_pass(foe)
	return before - foe.hp


func _s3e_thin_blood() -> void:
	print("\n§3e — Thin Blood: his Poison deals nothing at the tick, by every route it is laid")
	for arm in [["the rune worn, Trapper equipped", ["thin_blood"], true, true],
			["no Thin Blood", [], true, false], ["the rune worn, Trapper merely owned", ["thin_blood"], false, false]]:
		var s: Node = await _board("mystic", arm[1], arm[2])
		var sv: BattleUnit = _hero(s, "hunter")
		var foes := _foes(s)
		var priced: bool = arm[3]
		# By `_apply_poison`.
		s._apply_poison(sv, foes[0], 3)
		var t1: int = await _ticked(s, foes[0])
		# By the barb: an enemy strikes him (certain with the rune; one in four without, so it is laid by hand there).
		if priced:
			for _i in 6:
				if foes[1].has_status("poison") or foes[1].dead or sv.dead:
					break
				sv.hp = sv.max_hp
				foes[1].resource = 99999
				foes[1].cooldowns.clear()
				await s._resolve(foes[1], foes[1].abilities[0], sv, "good")
		else:
			s._apply_status(foes[1], "poison", 5, 0, s._dot_tick("poison", sv), sv)
		var barbed: bool = foes[1].has_status("poison")
		var t2: int = await _ticked(s, foes[1]) if barbed else -1
		# By Explosive Shot.
		var ex := _card("Explosive Shot")
		sv.resource = 99999
		sv.cooldowns.clear()
		for f in foes:
			f.remove_status("poison")
		await s._resolve(sv, ex, foes[2], "good")
		var t3: int = await _ticked(s, foes[2]) if foes[2].has_status("poison") else -1
		print("    [%s] a tick of his Poison cost: by _apply_poison %d, by the barb %d, by Explosive Shot %d" % [arm[0], t1, t2, t3])
		if priced:
			ok(t1 == 0, "§3e [%s]: a Poison laid by `_apply_poison` still bites (%d)" % [arm[0], t1])
			ok(barbed and t2 == 0, "§3e [%s]: the barb's Poison still bites (%d; laid %s)" % [arm[0], t2, barbed])
			ok(t3 == 0, "§3e [%s]: Explosive Shot's Poison still bites (%d)" % [arm[0], t3])
		else:
			ok(t1 > 0 and t2 > 0 and t3 > 0, "§3e [%s]: his Poison does not bite with the price off (%d, %d, %d)" % [arm[0], t1, t2, t3])
		await _clear(s)
	# A Poison laid with no tick given still deals the legacy figure: the fallback is for a tick never set.
	var s2: Node = await _board("mystic", ["thin_blood"], true)
	var f2: BattleUnit = _foes(s2)[0]
	s2._apply_status(f2, "poison", 5)
	var legacy: int = await _ticked(s2, f2)
	print("    a Poison laid with no tick and no source: a tick cost %d (the legacy figure is %d a stack)" % [legacy, int(s2.DOT_STATUSES["poison"])])
	ok(legacy > 0, "§3e: a Poison laid with no tick given deals nothing — the fallback for a tick never set is gone")
	await _clear(s2)


# ── §5 — THE RECORD ────────────────────────────────────────────────────────

func _s5_the_record() -> void:
	print("\n§5 — the rulings recorded where they are read")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("RANKED BY ITS CHILL, CONFIRMED"), "§5: CLAUDE.md does not record the rite's rank as confirmed")
	ok(cm.contains("NEVER IN A HERO'S OWN PICK OF THREE"), "§5: CLAUDE.md does not record that a hero's own pick holds no crest rune")
	var ww := FileAccess.get_file_as_string("res://docs/ways-of-working.md")
	ok(ww.contains("EVERY RULING LANDS IN THE NEXT BRIEF"), "§5: docs/ways-of-working.md does not hold the rule that every ruling reaches a brief")


# ── §9 — THE PLAYER'S FILES ────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
