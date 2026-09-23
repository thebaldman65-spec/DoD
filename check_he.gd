# BATCH HE — GATES AND DOORS.
#
#   §0  THE ROWS — the seven RULED rune rows (HE §1; six since HF §6 un-gated Long
#       Poison) and the engine each names; Mark of the Hunt's two RULED card rows
#       (HE §2; undone at HF §7, a companion row now); the two zone-boss cards
#       the card gate never swept until the boss asked it (HE §3); every card that
#       sits out without its engine is withheld from the offer without it; and
#       Bared Plate's Break damage on a field of its own, the retired runes that
#       share the old one untouched
#   §1  THE SEVEN AT THE RUNE DOORS, 400 ROLLS AN ARM (SIX, AND LONG POISON
#       OFFERED TO EVERY HUNTER, SINCE HF §6) — the Peddler
#       (`generate_rune`), an elite cache (`roll_rune_candidates`) and a bargain
#       (`claim_reward`'s rune reward), for a hero of each class holding each
#       gating engine and one holding none; and a cache ANSWERED A NODE LATER,
#       after the pouch's door takes the engine out: held back, kept, returned
#   §2  THE SEVEN AT THE SEAT (SIX, AND LONG POISON SEATED EITHER WAY, SINCE HF §6)
#       — each worn rune sits out without its engine at the
#       one door every surface asks, and does not with it. *That each PAYS
#       nothing without it is `check_gv` §1's: it drives every row both ways.*
#   §3  MARK OF THE HUNT WAS PACK BOND'S (HE §2) AND IS EVERY PET-HOLDER'S (HF §7)
#       — offered at the Beastmaster's zone boss with Pack Bond slotted or not;
#       withheld and sitting out beside the dismisser; the sentence beside Lethal
#       Aim; off the bar of that fight, on the bar with no engine
#   §4  THE ZONE BOSS ASKS THE ENGINE HALF — every boss card with a card-gate
#       row, 400 rolls with its engine slotted and with it owned and unslotted; a
#       stored triple held back at the answer and handed back; the overlay's
#       words, on the real map
#   §5  THE DRAFT RE-ASKS AT THE PICK — for every engine that gates a draft card:
#       a triple rolled with it slotted and answered without — held back, refused
#       with a reason, kept stored, taken once it is back; the party draft screen
#       draws no button for a held card and says why; and a card the hero already
#       knows, in a second queued triple
#   §6  THE SCOPE BAND IS GONE — the Peddler's row and a cache's button, on the
#       real screens, carry no band, and nothing in `Runes` builds one
#   §7  THE PLAYER'S FILES
#
# **BATCH HF OVERTURNED TWO OF THESE RULINGS AND ADDED ONE, AND EVERY ARM THEY
# MOVED IS INVERTED HERE RATHER THAN DELETED** (CQ §3): Long Poison is un-gated
# (HF §6: Snare Trap lays the Poison it reads), so its arms assert it offered,
# handed over and seated with Trapper out; Mark of the Hunt is offered to every
# Hunter with a pet and sits out only beside a dismisser (HF §7, HE §2 undone),
# so §3 asserts that; and Venom Coating is Trapper's (HF §7), a boss card with a
# row that §4 drives with the rest. `check_hf` §5-§6 carries HF's own drives.
#
# **A STATIC CHECK CANNOT SEE AN OFFER** (GP's reason, and HD's): every door arm
# reads what the roll HANDED, hundreds of times, never what a table says.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM**, on a member built the same way:
# an arm that must see none of a row is read beside one that must see it, so a
# roll wired shut, or a gate that withholds from everybody, reads red.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_he.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ROLLS := 400
const ROLL_SEED := 20260922
const SCRATCH_PROFILE := "user://he_profile.json"
const SCRATCH_RELICS := "user://he_relics.json"

# THE SEVEN RULED RUNE ROWS (HE §1) AND THE ENGINE EACH IS GATED ON — the
# ruling's population, carried here so a row that moved with no line changing
# here is a ruling nobody took.
# **BATCH HF §6 TOOK LONG POISON OUT OF THEM** (the designer): Snare Trap, every
# Hunter's kit card, lays the Poison it reads. It is held apart below, keyed to
# the engine HE named, and every section drives it the other way round.
const HE_RUNE_ROWS := {
	"long_fuse": "overburn", "killing_cold_fk": "permafrost", "deep_cold": "permafrost",
	"mirror_guard": "seasoned",
	"slaughterhouse_rune": "bloodrage", "bared_plate": "heavy_plating",
}
const HF_UNGATED := {"long_poison": "trapper"}
# The three retired runes that write `rune_bd_bonus`, which Bared Plate rode
# until HE §1 moved its share to a field of its own.
const BD_RETIRED := ["shattered_guard", "duelist", "sentinel"]

# EVERY ZONE-BOSS CARD WITH A CARD-GATE ROW, its lineage and its engine: the boss
# offers HE §3 moves. Four always had a row (the brief's four); Stabilize and
# Primal Surge became rows here; Mark of the Hunt was HE §2's ruling.
# **BATCH HF §7 UNDID MARK OF THE HUNT'S ROW AND RULED VENOM COATING TRAPPER'S**,
# on the Survivalist's zone-boss pool — the one door that offered it — so the
# seven are these seven now, and §4 drives the new one at the boss.
const BOSS_ROWS := {
	"Lunge": ["swordmaster", "seasoned"], "Shatter": ["cryomancer", "permafrost"],
	"Overcharge": ["arcanist", "resonance"], "Stabilize": ["arcanist", "resonance"],
	"Divine Plea": ["holy", "mercy"], "Primal Surge": ["beastmaster", "pack"],
	"Venom Coating": ["mystic", "trapper"],
}
const MOTH := "Mark of the Hunt"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HE — GATES AND DOORS")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a roll is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	var marks := PackedStringArray()
	var ts := Time.get_ticks_msec()
	_s0_the_rows()
	marks.append("§0 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s1_the_rune_doors()
	marks.append("§1 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	_s2_the_seat()
	marks.append("§2 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s3_mark_of_the_hunt()
	marks.append("§3 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s4_the_zone_boss()
	marks.append("§4 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s5_the_draft()
	marks.append("§5 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s6_the_band()
	marks.append("§6 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	_s7_the_players_files()
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


# Every name `roll` handed over across ROLLS rolls, counted. The seed is laid once
# per arm, so an arm reads the same dice every battery.
func _tally(member: Dictionary, roll: Callable) -> Dictionary:
	seed(ROLL_SEED)
	var seen := {}
	for _i in ROLLS:
		for c in roll.call(member):
			var n := String((c as Dictionary).get("id", "")) if c is Dictionary else String(c)
			if n != "":
				seen[n] = int(seen.get(n, 0)) + 1
	return seen


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _labels(n: Node, out: Array) -> void:
	if n == null or n.is_queued_for_deletion():
		return
	if n is Label:
		out.append(n)
	for c in n.get_children():
		_labels(c, out)


func _labels_with(n: Node, needle: String) -> Array:
	var all: Array = []
	_labels(n, all)
	return all.filter(func(l): return String((l as Label).text).contains(needle))


func _button_texts(n: Node) -> Array:
	var btns: Array = []
	Gate.buttons(n, btns, false)
	return btns.map(func(b): return String((b as Button).text))


func _close_overlays(mp: Node) -> void:
	for c in mp.get_children():
		if c is Control and (c as Control).z_index >= 60 and not c.is_queued_for_deletion():
			c.queue_free()


# A party of four on the map, every seat awakened with no lineage, nothing slotted
# and nothing worn; the seats in `over` take what they are given.
func _seat_party(over: Dictionary) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
		_run.party[i]["runes"] = []
	for seat in over:
		for k in over[seat]:
			_run.party[int(seat)][k] = over[seat][k]
	_run.specs_chosen = true
	_run.active = true


# ── §0 — THE ROWS ────────────────────────────────────────────────────────────

func _s0_the_rows() -> void:
	print("\n§0 — the rows: six ruled rune rows (HF §6 took the seventh), Mark of the Hunt's companion row (HF §7), the boss's")
	for id in HE_RUNE_ROWS:
		ok(Runes.engine_read(String(id)) == String(HE_RUNE_ROWS[id]),
			"§0: %s reads `%s` in `Runes.ENGINE_READ`, not %s" % [id, Runes.engine_read(String(id)), HE_RUNE_ROWS[id]])
		ok(Runes.engine_read_ruled(String(id)) == "HE §1",
			"§0: %s's rune row is not marked as the designer's ruling (`ruled` reads `%s`)" % [
				id, Runes.engine_read_ruled(String(id))])
		ok(not Runes.is_retired(String(id)) and String(Runes.config(String(id)).get("requires_ability", "")) == "",
			"§0: %s is retired or needs a card — the ruling was about a live rune that needs none" % id)
	var r_ruled: Array = []
	for rid in Runes.ENGINE_READ:
		if Runes.engine_read_ruled(String(rid)) != "":
			r_ruled.append(String(rid))
	r_ruled.sort()
	var want_r: Array = HE_RUNE_ROWS.keys()
	want_r.sort()
	ok(r_ruled == want_r, "§0: the ruled rune rows are %s — HE §1 ruled seven and HF §6 un-gated Long Poison" % str(r_ruled))
	for idu in HF_UNGATED:
		ok(Runes.engine_read(String(idu)) == "" and Runes.engine_read_ruled(String(idu)) == ""
				and not Runes.is_retired(String(idu)),
			"§0: %s still reads `%s` in `Runes.ENGINE_READ` (`ruled` %s) — HF §6 un-gated it" % [
				idu, Runes.engine_read(String(idu)), Runes.engine_read_ruled(String(idu))])
	print("    %d rune rows, %d of them ruled: %s" % [Runes.ENGINE_READ.size(), r_ruled.size(), ", ".join(r_ruled)])
	# MARK OF THE HUNT: HE §2 RULED IT A ROW AT THE OFFER AND AT THE SEAT, AND HF §7
	# UNDID BOTH — it is a companion row whose door opens and whose seat is ruled.
	ok(Classes.engine_read(MOTH) == "" and Classes.engine_read_ruled(MOTH) == "",
		"§0: Mark of the Hunt's card-gate row reads `%s` ruled `%s` — HF §7 undid HE §2's Pack Bond gate" % [
			Classes.engine_read(MOTH), Classes.engine_read_ruled(MOTH)])
	ok(Classes.sits_out_engine(MOTH) == "" and Classes.sits_out_ruled(MOTH) == "",
		"§0: Mark of the Hunt's seat row reads `%s` ruled `%s` — HF §7 undid it: it sits out only beside a dismisser" % [
			Classes.sits_out_engine(MOTH), Classes.sits_out_ruled(MOTH)])
	ok(Classes.COMPANION_READ.has(MOTH) and not Classes.companion_door(MOTH)
			and Classes.companion_seat(MOTH) and Classes.companion_read_ruled(MOTH) == "HF §7",
		"§0: Mark of the Hunt is not the companion row HF §7 ruled — door open, seat ruled (door %s, seat %s, `ruled` %s)" % [
			Classes.companion_door(MOTH), Classes.companion_seat(MOTH), Classes.companion_read_ruled(MOTH)])
	var c_ruled: Array = []
	for card in Classes.ENGINE_READ:
		if Classes.engine_read_ruled(String(card)) != "":
			c_ruled.append(String(card))
	c_ruled.sort()
	ok(c_ruled == ["Guard Change", "Lunge", "Venom Coating"],
		"§0: the ruled card rows are %s — HD ruled two and HF §7 one (HE §2's was undone)" % str(c_ruled))
	ok(Classes.engine_read("Venom Coating") == "trapper" and Classes.engine_read_ruled("Venom Coating") == "HF §7",
		"§0: Venom Coating reads `%s` ruled `%s` — HF §7 ruled it Trapper's" % [
			Classes.engine_read("Venom Coating"), Classes.engine_read_ruled("Venom Coating")])
	# EVERY CARD THAT SITS OUT WITHOUT ITS ENGINE IS WITHHELD FROM THE OFFER WITHOUT
	# IT, NAMING THE SAME ENGINE: the seat and the offer cannot disagree about a card.
	var split: Array = []
	for card2 in Classes.SITS_OUT:
		if Classes.engine_read(String(card2)) != Classes.sits_out_engine(String(card2)):
			split.append(String(card2))
	ok(split.is_empty(), "§0: %s sit out without an engine the offer does not withhold them for" % str(split))
	# BATCH HF §7 — THE FLOOR MOVED 18 -> 17 WITH MARK OF THE HUNT'S SEAT ROW.
	ok(Classes.SITS_OUT.size() >= 17, "§0: the seat table holds %d rows — it has stopped covering the pool" % Classes.SITS_OUT.size())
	# THE ZONE BOSS'S CARDS WITH A ROW — the boss offers HE §3 moves — derived off
	# the boss pools, never taken from this gate's list.
	var boss_rows: Array = []
	for spec in Classes.SPEC_POOLS:
		for n in Classes.SPEC_POOLS[spec]:
			if Classes.engine_read(String(n)) != "" and not boss_rows.has(String(n)):
				boss_rows.append(String(n))
	boss_rows.sort()
	var want_b: Array = BOSS_ROWS.keys()
	want_b.sort()
	ok(boss_rows == want_b,
		"§0: the boss cards with a card-gate row are %s — HE §3 moved seven and HF §7 swapped Mark of the Hunt for Venom Coating; a new one moves another boss offer, and is sorted here and in the report" % str(boss_rows))
	for bc in BOSS_ROWS:
		ok(Classes.spec_pool(String(BOSS_ROWS[bc][0])).has(String(bc)),
			"§0: %s is not on the %s's zone-boss pool" % [bc, BOSS_ROWS[bc][0]])
		ok(Classes.engine_read(String(bc)) == String(BOSS_ROWS[bc][1]),
			"§0: %s reads `%s`, not %s" % [bc, Classes.engine_read(String(bc)), BOSS_ROWS[bc][1]])
	for fresh in ["Stabilize", "Primal Surge"]:
		ok(Classes.engine_read_ruled(fresh) == "" and Classes.sits_out_engine(fresh) != "",
			"§0: %s is a derived row that sits out without its engine — ruled, or not a seat row" % fresh)
	# BARED PLATE'S BREAK DAMAGE, ON A FIELD OF ITS OWN.
	var bp_stat: Dictionary = ((Runes.config("bared_plate").get("payload", {}) as Dictionary).get("stat", {}) as Dictionary)
	ok(is_equal_approx(float(bp_stat.get("rune_bared_plate_bd", 0.0)), 0.25) and int(bp_stat.get("rune_no_block", 0)) == 1,
		"§0: Bared Plate's payload is %s — its 0.25 and its price, on the field HE §1 gave it" % str(bp_stat))
	ok(not bp_stat.has("rune_bd_bonus"),
		"§0: Bared Plate still writes `rune_bd_bonus`, the field three retired runes share — a gate on it withholds theirs")
	for rid2 in BD_RETIRED:
		var st2: Dictionary = ((Runes.config(rid2).get("payload", {}) as Dictionary).get("stat", {}) as Dictionary)
		ok(Runes.is_retired(rid2) and float(st2.get("rune_bd_bonus", 0.0)) > 0.0,
			"§0: %s no longer writes `rune_bd_bonus` retired — the field Bared Plate left is still theirs" % rid2)
	var unit_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	ok(unit_src.contains("var rune_bared_plate_bd := 0.0"),
		"§0: `BattleUnit` does not declare `rune_bared_plate_bd` as a float — 0.25 would round to nothing")


# ── §1 — THE SEVEN AT THE RUNE DOORS ─────────────────────────────────────────

func _s1_the_rune_doors() -> void:
	print("\n§1 — the six at the Peddler, an elite cache and a bargain, and Long Poison un-gated (HF §6), %d rolls an arm" % ROLLS)
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	var arms := [
		["warrior", []], ["warrior", ["bloodrage"]], ["warrior", ["heavy_plating"]], ["warrior", ["seasoned"]],
		["mage", []], ["mage", ["overburn"]], ["mage", ["permafrost"]],
		["hunter", []], ["hunter", ["trapper"]],
	]
	for arm in arms:
		var cls := String(arm[0])
		var engs: Array = arm[1]
		var m := _member(cls, "", engs.map(func(p): return _eng(String(p))))
		var peddler := _tally(m, func(mm): return [_run.generate_rune(mm)])
		var cache := _tally(m, func(mm): return _run.roll_rune_candidates(mm))
		var bargain := _bargain(cls, engs)
		var line := PackedStringArray()
		for id in HE_RUNE_ROWS:
			if String(Runes.config(String(id)).get("scope", "")) != "class:" + cls:
				continue
			var wants: bool = engs.has(String(HE_RUNE_ROWS[id]))
			var p := int(peddler.get(id, 0))
			var c := int(cache.get(id, 0))
			var b := int(bargain.get(id, 0))
			line.append("%s %d·%d·%d" % [id, p, c, b])
			if wants:
				ok(p > 0 and c > 0 and b > 0,
					"§1: a %s holding %s was never offered %s (Peddler %d, cache %d, bargain %d) — its engine's holder is" % [
						cls, engs, id, p, c, b])
			else:
				ok(p == 0 and c == 0 and b == 0,
					"§1: a %s holding %s was offered %s (Peddler %d, cache %d, bargain %d) — it is %s's holder's (HE §1)" % [
						cls, engs, id, p, c, b, HE_RUNE_ROWS[id]])
		# BATCH HF §6 — THE ROW TAKEN BACK OUT: offered to every hero of its class,
		# with its old engine and without it.
		for idu in HF_UNGATED:
			if String(Runes.config(String(idu)).get("scope", "")) != "class:" + cls:
				continue
			var pu := int(peddler.get(idu, 0))
			var cu := int(cache.get(idu, 0))
			var bu := int(bargain.get(idu, 0))
			line.append("%s %d·%d·%d" % [idu, pu, cu, bu])
			ok(pu > 0 and cu > 0 and bu > 0,
				"§1: a %s holding %s was never offered %s (Peddler %d, cache %d, bargain %d) — HF §6 un-gated it, so every %s is" % [
					cls, engs, idu, pu, cu, bu, cls])
		print("    %-8s %-18s %s" % [cls, str(engs), "  ".join(line)])
	# A CACHE ANSWERED A NODE LATER: rolled with the engine slotted, answered after
	# the pouch's door takes it out — held back and kept; slotted again, handed back.
	for id2 in HE_RUNE_ROWS:
		var cls2 := String(Runes.config(String(id2)).get("scope", "")).trim_prefix("class:")
		var eng2 := String(HE_RUNE_ROWS[id2])
		var m2 := _member(cls2, "", [_eng(eng2)])
		var trip: Array = [Runes.build(String(id2))]
		for other in Runes.eligible_ids(m2, []):
			if trip.size() >= 3:
				break
			if String(other) != String(id2) and not Runes.is_engine_rune(String(other)):
				trip.append(Runes.build(String(other)))
		m2["rune_candidates"] = [trip]
		m2["rune_picks_owed"] = 1
		var names_was: Array = trip.map(func(c): return String(c["name"]))
		var with_it: Array = (_run.rune_choice(m2) as Array).map(func(c): return String(c["id"]))
		ok(with_it.has(String(id2)), "§1: a cache holding %s answered with %s slotted does not hand it over" % [id2, eng2])
		ok(bool(_run.toggle_engine(m2, 0)), "§1: the pouch's door would not unequip %s" % eng2)
		var without: Array = (_run.rune_choice(m2) as Array).map(func(c): return String(c["id"]))
		var held: Array = (_run.rune_choice_withheld(m2) as Array).map(func(c): return String(c["id"]))
		var stored: Array = ((m2["rune_candidates"] as Array)[0] as Array).map(func(c): return String(c["name"]))
		ok(not without.has(String(id2)) and held.has(String(id2)) and stored == names_was,
			"§1: a cache holding %s answered a node later with %s out hands over %s, holds back %s, keeps %s" % [
				id2, eng2, without, held, stored])
		ok(bool(_run.toggle_engine(m2, 0)), "§1: the pouch's door would not equip %s again" % eng2)
		ok((_run.rune_choice(m2) as Array).map(func(c): return String(c["id"])).has(String(id2)),
			"§1: %s slotted again, the cache does not hand %s back" % [eng2, id2])
	# BATCH HF §6 — AND THE ROW TAKEN BACK OUT IS HANDED OVER EITHER WAY: rolled with
	# its old engine slotted, answered with it out, nothing held back.
	for idu2 in HF_UNGATED:
		var clsu := String(Runes.config(String(idu2)).get("scope", "")).trim_prefix("class:")
		var engu := String(HF_UNGATED[idu2])
		var mu := _member(clsu, "", [_eng(engu)])
		var tripu: Array = [Runes.build(String(idu2))]
		for otheru in Runes.eligible_ids(mu, []):
			if tripu.size() >= 3:
				break
			if String(otheru) != String(idu2) and not Runes.is_engine_rune(String(otheru)):
				tripu.append(Runes.build(String(otheru)))
		mu["rune_candidates"] = [tripu]
		mu["rune_picks_owed"] = 1
		ok((_run.rune_choice(mu) as Array).map(func(c): return String(c["id"])).has(String(idu2)),
			"§1: a cache holding %s answered with %s slotted does not hand it over" % [idu2, engu])
		ok(bool(_run.toggle_engine(mu, 0)), "§1: the pouch's door would not unequip %s" % engu)
		var withoutu: Array = (_run.rune_choice(mu) as Array).map(func(c): return String(c["id"]))
		var heldu: Array = (_run.rune_choice_withheld(mu) as Array).map(func(c): return String(c["id"]))
		ok(withoutu.has(String(idu2)) and not heldu.has(String(idu2)),
			"§1: a cache holding %s answered with %s out hands over %s and holds back %s — HF §6 un-gated it" % [
				idu2, engu, withoutu, heldu])


# The bargain's rune reward, claimed through its own door (`claim_reward`), ROLLS
# claims for a party whose only hero that can take a rune is a `cls` holding
# `engs`: the other three hold every rune they could be offered, so the looter
# is always the hero the arm is about. **ONE RUN AN ARM, THE REWARD RE-ARMED PER
# CLAIM**: a claim rolls a triple and stores it, and a stored triple changes
# nothing a later roll reads (the pool reads the pouch, never the queue), so the
# queue is emptied between claims rather than a run rebuilt 400 times.
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


# ── §2 — THE SEVEN AT THE SEAT ───────────────────────────────────────────────

func _s2_the_seat() -> void:
	print("\n§2 — the six worn: sitting out without the engine, and not with it; Long Poison seated either way (HF §6)")
	for id in HE_RUNE_ROWS:
		var cls := String(Runes.config(String(id)).get("scope", "")).trim_prefix("class:")
		var eng := String(HE_RUNE_ROWS[id])
		var worn: Dictionary = Runes.build(String(id))
		worn["equipped"] = true
		var nm := String(worn["name"])
		var arms := {true: [_eng(eng)], false: [_eng(eng, false)]}
		var said := PackedStringArray()
		for slotted in [true, false]:
			var m := _member(cls, "", arms[slotted])
			m["runes"] = [worn]
			var out: bool = (_run.sitting_out_rune_names(m) as Array).has(nm)
			ok(out == (not slotted), "§2: %s worn with %s %s — it %s" % [nm, eng,
				"slotted" if slotted else "unslotted", "sits out" if out else "does not sit out"])
			said.append("%s %s" % ["in" if slotted else "out", "sits out" if out else "seated"])
		# THE SENTENCE EVERY SURFACE PRINTS, naming the engine rune that brings it back.
		var note: String = _run.rune_sits_out_note(String(id), [])
		var rune_name := String(Runes.config(Runes.engine_rune_id(eng)).get("name", ""))
		ok(rune_name != "" and note.replace("\n", " ").contains("while the %s is not equipped" % rune_name),
			"§2: %s's sentence does not name the %s: %s" % [nm, rune_name, note.replace("\n", " ")])
		print("    %-15s %-14s %s" % [nm, eng, ", ".join(said)])
	# BATCH HF §6 — THE ROW TAKEN BACK OUT IS SEATED EITHER WAY (`check_hf` §1 drives
	# it paying on a hero holding no engine at all).
	for idu in HF_UNGATED:
		var clsu := String(Runes.config(String(idu)).get("scope", "")).trim_prefix("class:")
		var engu := String(HF_UNGATED[idu])
		var wornu: Dictionary = Runes.build(String(idu))
		wornu["equipped"] = true
		var nmu := String(wornu["name"])
		var saidu := PackedStringArray()
		for slottedu in [true, false]:
			var mu := _member(clsu, "", [_eng(engu, slottedu)])
			mu["runes"] = [wornu]
			var outu: bool = (_run.sitting_out_rune_names(mu) as Array).has(nmu)
			ok(not outu, "§2: %s worn with %s %s sits out — HF §6 un-gated it" % [nmu, engu,
				"slotted" if slottedu else "unslotted"])
			saidu.append("%s %s" % ["in" if slottedu else "out", "sits out" if outu else "seated"])
		print("    %-15s %-14s %s (un-gated at HF §6)" % [nmu, engu, ", ".join(saidu)])


# ── §3 — MARK OF THE HUNT: HE §2 MADE IT PACK BOND'S, AND HF §7 UNDID THAT ────
#
# **THE FOUR ARMS ARE HE's, AND TWO OF THEM READ THE OTHER WAY NOW** (the designer,
# HF §7): its companion's halves never needed Pack Bond, so it is offered to every
# Hunter with a pet — with Pack Bond owned and unslotted too — and it sits out only
# beside the engine that dismisses the pet, where HB's pet gate also withholds it
# from the offer (which closes HE's own finding: offered beside Lethal Aim, then
# sitting out). What each half pays is `check_hf` §5's drive.

func _s3_mark_of_the_hunt() -> void:
	print("\n§3 — Mark of the Hunt: offered and seated for every Hunter with a pet (HF §7)")
	# THE OFFER: the Beastmaster's zone boss is the one pool that holds it.
	var arms := [
		["Pack Bond slotted", [_eng("pack")], true, false],
		["Pack Bond owned and unslotted", [_eng("pack", false)], true, false],
		["Lethal Aim slotted alone", [_eng("lethal_aim")], false, true],
		["Pack Bond beside Lethal Aim", [_eng("pack"), _eng("lethal_aim")], false, true],
	]
	for arm in arms:
		var m := _member("hunter", "beastmaster", arm[1])
		var seen := _tally(m, func(mm): return _run.roll_spec_ability_offer(mm))
		var n := int(seen.get(MOTH, 0))
		if bool(arm[2]):
			ok(n > 0, "§3: with %s the Beastmaster's zone boss never offered Mark of the Hunt — a Hunter with a pet is offered it (HF §7)" % arm[0])
		else:
			ok(n == 0, "§3: with %s the zone boss offered Mark of the Hunt %d times — the pet gate withholds it beside a dismisser (HF §7)" % [arm[0], n])
		# THE SEAT: carried, and seated only with Pack Bond in effect.
		var c := _member("hunter", "beastmaster", arm[1])
		c["bm_abilities"] = [MOTH]
		c["bm_equipped"] = [MOTH]
		var seated: bool = (_run.seated_ability_names(c) as Array).has(MOTH)
		var benched: bool = (_run.sitting_out_names(c) as Array).has(MOTH)
		ok(seated == (not bool(arm[3])) and benched == bool(arm[3]),
			"§3: with %s, carried Mark of the Hunt is %s and %s" % [arm[0],
				"seated" if seated else "not seated", "sits out" if benched else "does not sit out"])
		print("    %-30s offered %3d · %s" % [arm[0], n, "sits out" if benched else "seated"])
	# THE SENTENCE BESIDE LETHAL AIM: the pet's own (HB), not Pack Bond's — the card
	# sits out because the pet is dismissed, whatever else is slotted.
	var beside: String = String(_run.sits_out_note(MOTH, ["pack", "lethal_aim"])).replace("\n", " ")
	ok(beside.begins_with("Sits out of every fight while the Rune of the Sharpshooter is equipped, which dismisses the companion it needs."),
		"§3: beside Lethal Aim the card says: %s" % beside)
	ok(beside.ends_with("Still carried: the slot stays counted. Benching the card frees the slot."),
		"§3: beside Lethal Aim the card's sentence is not GT's: %s" % beside)
	# AND WITH PACK BOND OUT IT DOES NOT SIT OUT AT ALL (HF §7) — asked of the one
	# answer, beside the arm where it does.
	ok(not Classes.sits_out(MOTH, []) and not Classes.sits_out(MOTH, ["pack"])
			and Classes.sits_out(MOTH, ["lethal_aim"]),
		"§3: Mark of the Hunt sits out with Pack Bond out (%s) or in (%s), or not beside Lethal Aim (%s)" % [
			Classes.sits_out(MOTH, []), Classes.sits_out(MOTH, ["pack"]), Classes.sits_out(MOTH, ["lethal_aim"])])
	# THE FIGHT: the bar the battle seats — the card is gone from the fight beside
	# Lethal Aim, and on the bar with Pack Bond slotted and with no engine at all.
	for pair in [[[_eng("pack"), _eng("lethal_aim")], false], [[_eng("pack")], true], [[], true]]:
		var over := {3: {"engines": pair[0], "bm_abilities": [MOTH], "bm_equipped": [MOTH]}}
		var s: Node = await Gate.spawn(self, ["", "", "", "beastmaster"], {"party": over, "deterministic": true})
		var h: BattleUnit = _hero(s, "hunter")
		var on_bar := false
		if h != null:
			for ab in h.abilities:
				if ab.display_name == MOTH:
					on_bar = true
		ok(h != null and on_bar == bool(pair[1]),
			"§3: the Hunter with %s %s Mark of the Hunt on his bar" % [
				(pair[0] as Array).map(func(r): return String(r["engine"])), "carries" if on_bar else "has no"])
		await _clear(s)


# ── §4 — THE ZONE BOSS ASKS THE ENGINE HALF ──────────────────────────────────

func _s4_the_zone_boss() -> void:
	print("\n§4 — the zone boss's first tier, %d rolls an arm: its engine slotted, and owned but not" % ROLLS)
	for card in BOSS_ROWS:
		var lin := String(BOSS_ROWS[card][0])
		var eng := String(BOSS_ROWS[card][1])
		var cls := Classes.engine_class(eng)
		var on := _tally(_member(cls, lin, [_eng(eng)]), func(mm): return _run.roll_spec_ability_offer(mm))
		var off := _tally(_member(cls, lin, [_eng(eng, false)]), func(mm): return _run.roll_spec_ability_offer(mm))
		ok(int(on.get(card, 0)) > 0,
			"§4: a %s-lineage hero holding %s was never offered %s by his zone boss — the holder is" % [lin, eng, card])
		ok(int(off.get(card, 0)) == 0,
			"§4: a %s-lineage hero whose %s is unslotted was offered %s %d times by his zone boss — it asks the engine half (HE §3)" % [
				lin, eng, card, int(off.get(card, 0))])
		print("    %-17s %-12s slotted %3d · unslotted %3d" % [card, lin, int(on.get(card, 0)), int(off.get(card, 0))])
		# THE ANSWER: stored with the engine slotted, answered with it out — held
		# back and kept; slotted again, handed back. Not a reroll.
		var trip: Array = [card]
		for other in Classes.spec_pool(lin):
			if trip.size() < 3 and String(other) != card:
				trip.append(String(other))
		var m := _member(cls, lin, [_eng(eng)])
		m["bm_candidates"] = [trip.duplicate()]
		m["bm_picks_owed"] = 1
		ok((_run.ability_choice(m) as Array).has(card), "§4: the stored triple answered with %s slotted does not hand over %s" % [eng, card])
		(m["engines"][0] as Dictionary)["equipped"] = false
		var live: Array = _run.ability_choice(m)
		var held: Array = _run.ability_choice_withheld(m)
		ok(not live.has(card) and held.has(card) and (m["bm_candidates"] as Array)[0] == trip,
			"§4: answered with %s out the boss hands over %s, holds back %s, keeps %s" % [
				eng, live, held, (m["bm_candidates"] as Array)[0]])
		(m["engines"][0] as Dictionary)["equipped"] = true
		ok((_run.ability_choice(m) as Array).has(card), "§4: %s slotted again, the boss does not hand %s back" % [eng, card])
	# THE OVERLAY'S WORDS, ON THE REAL MAP: the Swordmaster's Lunge, stored.
	for slotted in [false, true]:
		var tag := "the Stances in" if slotted else "the Stances out"
		_seat_party({0: {"spec": "swordmaster", "engines": [_eng("seasoned", slotted)],
			"bm_candidates": [["Lunge", "Execute", "Shatterpoint"]], "bm_picks_owed": 1}})
		change_scene_to_file("res://scenes/map.tscn")
		await Gate.frames(self, 6)
		var mp: Node = current_scene
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_pick_overlay(0)
		await Gate.frames(self, 3)
		var ov: Node = Gate.overlay(mp, 60)
		ok(ov != null, "§4 (%s): the zone boss's pick overlay did not open" % tag)
		if ov == null:
			continue
		var has_btn: bool = _button_texts(ov).has("Lunge")
		var says: Array = _labels_with(ov, "wait%s on the Rune of the Swordmaster being equipped" % "s")
		ok(has_btn == slotted and (not says.is_empty()) == (not slotted),
			"§4 (%s): the overlay %s Lunge button and %s the engine — %s" % [tag,
				"draws a" if has_btn else "draws no", "names" if not says.is_empty() else "does not name",
				"slotted, the card is offered and nothing is held back" if slotted
				else "unslotted, the card is held back and the sentence names the rune that brings it back"])
		ok(_button_texts(ov).has("Execute"), "§4 (%s): the overlay drew no button for Execute — the positive arm" % tag)
		print("    the boss overlay, %s: Lunge button %s, the sentence %s" % [tag, has_btn, not says.is_empty()])
		_close_overlays(mp)
		await Gate.frames(self, 2)
	_run.active = false


# ── §5 — THE DRAFT RE-ASKS AT THE PICK ───────────────────────────────────────

func _s5_the_draft() -> void:
	print("\n§5 — a draft's answer re-asks the gate: every engine that gates a draft card")
	var engines_seen := 0
	for cls in SEATS:
		var pool: Array = Classes.draft_pool(String(cls))
		for eng in Classes.class_engines(String(cls)):
			var rows: Array = pool.filter(func(n): return Classes.engine_read(String(n)) == String(eng))
			if rows.is_empty():
				continue
			engines_seen += 1
			var m := _member(String(cls), "", [_eng(String(eng))])
			seed(ROLL_SEED)
			var card := ""
			for _k in ROLLS:
				m["draft_candidates"] = []
				m["draft_picks_owed"] = 0
				_run.award_draft_pick(m)
				var q: Array = m["draft_candidates"]
				if q.is_empty():
					continue
				for c in q[0]:
					if rows.has(String(c)):
						card = String(c)
				if card != "":
					break
			ok(card != "", "§5: %d draft rolls to a %s holding %s stored none of its %d rows" % [ROLLS, cls, eng, rows.size()])
			if card == "":
				continue
			var stored: Array = (m["draft_candidates"] as Array)[0].duplicate()
			(m["engines"][0] as Dictionary)["equipped"] = false
			var why: String = _run.take_draft_ability(m, card)
			ok(not (_run.draft_choice(m) as Array).has(card) and (_run.draft_choice_withheld(m) as Array).has(card),
				"§5: %s rolled with %s slotted is still in the answer with it out" % [card, eng])
			ok(why.contains("being equipped") and not (m["bm_abilities"] as Array).has(card)
				and (m["draft_candidates"] as Array)[0] == stored and int(m["draft_picks_owed"]) == 1,
				"§5: %s answered with %s out — the pick said '%s', and the hero owns %s" % [card, eng, why, m["bm_abilities"]])
			(m["engines"][0] as Dictionary)["equipped"] = true
			var took: String = _run.take_draft_ability(m, card)
			ok(took == "" and (m["bm_abilities"] as Array).has(card),
				"§5: %s slotted again, %s is not taken ('%s')" % [eng, card, took])
			print("    %-8s %-14s %-24s out: \"%s\"  in: taken" % [cls, eng, card, why])
	ok(engines_seen >= 10, "§5: only %d engines gate a draft card — the arm has stopped covering the pool" % engines_seen)
	# THE PARTY DRAFT SCREEN: no button for a held card, and the column says why.
	for slotted in [false, true]:
		var tag := "the Stances in" if slotted else "the Stances out"
		_seat_party({0: {"engines": [_eng("seasoned", slotted)],
			"draft_candidates": [["Guard Change", "Cleave", "Warcry"]], "draft_picks_owed": 1}})
		change_scene_to_file("res://scenes/map.tscn")
		await Gate.frames(self, 6)
		var mp: Node = current_scene
		_close_overlays(mp)
		await Gate.frames(self, 2)
		mp._open_party_draft()
		await Gate.frames(self, 3)
		var ov: Node = Gate.overlay(mp, 62)
		ok(ov != null, "§5 (%s): the party draft screen did not open" % tag)
		if ov == null:
			continue
		var texts: Array = _button_texts(ov)
		var has_gc: bool = texts.has("Guard Change")
		var says: Array = _labels_with(ov, "on the Rune of the Swordmaster being equipped")
		ok(has_gc == slotted and (not says.is_empty()) == (not slotted),
			"§5 (%s): the column %s Guard Change button and %s the engine — %s" % [tag,
				"draws a" if has_gc else "draws no", "names" if not says.is_empty() else "does not name",
				"slotted, the card is offered and nothing is held back" if slotted
				else "unslotted, the card is held back and the sentence names the rune that brings it back"])
		ok(texts.has("Cleave") and texts.has("Warcry"),
			"§5 (%s): the column drew no button for Cleave or Warcry — the positive arm (%s)" % [tag, texts])
		ok(_labels_with(ov, "no more to offer").is_empty(),
			"§5 (%s): a held card is read as a pool run dry" % tag)
		print("    the draft column, %s: Guard Change button %s, the sentence %s" % [tag, has_gc, not says.is_empty()])
		_close_overlays(mp)
		await Gate.frames(self, 2)
	# A CARD HE ALREADY KNOWS, IN THE SECOND OF TWO QUEUED TRIPLES — constructed:
	# two triples rolled before either is answered share a card.
	var two := _member("warrior", "", [])
	two["draft_candidates"] = [["Cleave", "Warcry", "Charge"], ["Cleave", "Rally", "Battle Trance"]]
	two["draft_picks_owed"] = 2
	ok(String(_run.take_draft_ability(two, "Cleave")) == "", "§5: the first triple would not hand over Cleave")
	ok(not (_run.draft_choice(two) as Array).has("Cleave") and (_run.draft_choice(two) as Array).has("Rally"),
		"§5: the second triple still offers Cleave after it was taken (%s)" % [_run.draft_choice(two)])
	ok(String(_run.take_draft_ability(two, "Cleave")) == "already known",
		"§5: the second triple's Cleave is not refused as already known")
	_seat_party({0: {"draft_candidates": two["draft_candidates"], "draft_picks_owed": 1,
		"bm_abilities": two["bm_abilities"], "bm_equipped": two["bm_equipped"]}})
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	var mp2: Node = current_scene
	_close_overlays(mp2)
	await Gate.frames(self, 2)
	mp2._open_party_draft()
	await Gate.frames(self, 3)
	var ov2: Node = Gate.overlay(mp2, 62)
	var texts2: Array = _button_texts(ov2) if ov2 != null else []
	ok(ov2 != null and not texts2.has("Cleave") and texts2.has("Rally")
		and not _labels_with(ov2, "already knows").is_empty(),
		"§5: the second triple's column draws %s and does not say one card is known" % [texts2])
	print("    a known card in a second queued triple: buttons %s" % [texts2.filter(func(t): return t in ["Cleave", "Rally", "Battle Trance"])])
	_close_overlays(mp2)
	await Gate.frames(self, 2)
	_run.active = false


# ── §6 — THE SCOPE BAND IS GONE ──────────────────────────────────────────────

func _s6_the_band() -> void:
	print("\n§6 — no scope band: the Peddler's row and a cache's button, on the real screens")
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/runes.gd"))
	ok(not src.contains("SCOPE_INFO") and not src.contains("func shown_scope"),
		"§6: `Runes` still carries the band's table or its door")
	var built: Dictionary = Runes.build("long_watch")
	ok(not built.has("scope_label") and not built.has("scope_color"),
		"§6: `Runes.build` still writes a band onto the instance (%s)" % str(built.keys()))
	# THE PEDDLER.
	_seat_party({})
	_run.gold = 999
	change_scene_to_file("res://scenes/shop.tscn")
	await Gate.frames(self, 8)
	var shop: Node = current_scene
	ok(Gate.scene_name(self) == "Shop", "§6: the Peddler is not on screen (%s)" % Gate.scene_name(self))
	var r: Dictionary = Runes.build("long_watch")
	shop.offers = [{"member_idx": 0, "rune": r}]
	shop._draw_screen()
	await Gate.frames(self, 3)
	# FOUND BY THE RUNE'S NAME AT THE ROW'S START, NOT BY THE BAND-FREE SHAPE THE
	# ARM BELOW ASSERTS — a locator that asked for the row's band-free shape would
	# find nothing when a band came back, and say "no row" where the defect is the band.
	var rows: Array = _labels_with(shop, String(r["name"])).filter(func(l):
		return String((l as Label).text).begins_with(String(r["name"])))
	ok(rows.size() == 1, "§6: the Peddler drew %d rows for %s — the positive arm" % [rows.size(), r["name"]])
	if rows.size() == 1:
		var t := String((rows[0] as Label).text)
		ok(not t.contains("[Class]") and not t.contains("[Universal]") and not t.contains("  ["),
			"§6: the Peddler's row still carries a band: %s" % t.get_slice("\n", 0))
		ok((rows[0] as Label).get_theme_color("font_color").is_equal_approx(Runes.RUNE_TINT),
			"§6: the Peddler's row is not drawn in the one tint")
		print("    the Peddler's row: \"%s\"" % t.get_slice("\n", 0))
	# A CACHE'S BUTTON.
	_seat_party({0: {"rune_candidates": [[Runes.build("long_watch"), Runes.build("last_word")]],
		"rune_picks_owed": 1}})
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 6)
	var mp: Node = current_scene
	_close_overlays(mp)
	await Gate.frames(self, 2)
	mp._open_pick_overlay(0)
	await Gate.frames(self, 3)
	var ov: Node = Gate.overlay(mp, 60)
	var texts: Array = _button_texts(ov) if ov != null else []
	ok(ov != null and texts.has("Long Watch") and texts.has("Last Word"),
		"§6: a cache's buttons read %s — each should be the rune's name and nothing else" % [texts])
	ok(texts.filter(func(t): return String(t).contains("[")).is_empty(),
		"§6: a cache's button still carries a band: %s" % [texts])
	print("    a cache's buttons: %s" % [texts.filter(func(t): return String(t) in ["Long Watch", "Last Word"])])
	_close_overlays(mp)
	await Gate.frames(self, 2)
	_run.active = false


# ── §7 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	print("\n§7 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§7: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§7: %s is byte for byte as this gate found it" % p)
