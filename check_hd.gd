# BATCH HD — THE TWENTY HOLES, AND THE STANCE PIECES RULED THE STANCES HOLDER'S.
#
#   §1  THE STANCE PIECES AT EVERY DOOR THE GATE STANDS AT — Guard Change and Lunge
#       are offered only to a hero holding the Stances engine (ruled at HD §1, two
#       RULED rows of GP's card gate). Driven, at volume, through the rolls a
#       Warrior's card offers come from: the elite draft (`roll_draft_offer`, and
#       `award_draft_pick` storing what the overlay will show) and the zone boss's
#       fallback (`roll_draft_fallback_offer`). A Warrior holding no engine — of no
#       lineage, or of the Swordmaster's with the Stances merely owned — or holding
#       another engine is offered NEITHER; one holding the Stances, first or second,
#       is offered BOTH.
#   §2  THE TWO DOORS THE GATE DID NOT STAND AT UNTIL HE §3, DRIVEN AND ASSERTED —
#       the zone boss's first tier asked the pet half of `offerable` and not the
#       engine half (HC §5), so a Swordmaster-lineage Warrior who unslotted the
#       Stances was still offered Lunge there; and a draft's ANSWER re-asked no
#       engine (HC's finding), so a stance piece rolled with the Stances slotted was
#       still taken after they left. **HD printed both as findings owed a ruling;
#       HE §3 ruled both, and they are asserted now** — the boss asks the whole of
#       `offerable` (0 in 400 unslotted), and the answer refuses a piece whose
#       engine is out and hands it over once the engine is back, on one member.
#       Each negative keeps the positive arm beside it.
#   §3  THE PLAYER'S FILES
#
# **A STATIC CHECK CANNOT SEE AN OFFER** (the brief's words, and GP's reason for
# driving its gate): `Classes.offerable` answering right is not the same as the
# roll handing the right cards over, so every arm here reads what the roll HANDED,
# hundreds of times, never what the table says. `check_gp` §2b asks the same gate
# at `draft_pool_left`, and `test_batch_ak` asks it of the stance pieces by name.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM**, on a member built the same way:
# the arms that must see nothing are read beside arms that must see both cards, so
# a roll wired shut, or a gate that withheld from everybody, reads red.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hd.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const STANCE_PIECES := ["Guard Change", "Lunge"]
const STANCES := "seasoned"
const ROLLS := 400
const ROLL_SEED := 20260921

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HD — THE STANCE PIECES ARE THE STANCES HOLDER'S")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a roll is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_s0_the_rows()
	_s1_every_door()
	_s2_the_doors_it_does_not_stand_at()
	_s3_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

# An engine rune as the pouch holds one — built by the game, slotted or not.
func _eng(pid: String, on := true) -> Dictionary:
	var r: Dictionary = Runes.build(Runes.engine_rune_id(pid))
	r["equipped"] = on
	return r


# A Warrior as a run holds one after class selection: awakened, drafting nothing
# yet, holding the engine runes given.
func _warrior(lineage: String, engines: Array) -> Dictionary:
	return {"key": "warrior", "spec": lineage, "awakened": true, "bm_abilities": [],
		"bm_equipped": [], "talents": {}, "tree": [], "engines": engines,
		"draft_candidates": [], "draft_picks_owed": 0, "draft_refused": []}


# Every card `roll` handed over across ROLLS rolls, counted by name. The seed is
# laid once per arm, so an arm reads the same dice every battery.
func _tally(member: Dictionary, roll: Callable) -> Dictionary:
	seed(ROLL_SEED)
	var seen := {}
	for _i in ROLLS:
		for c in roll.call(member):
			seen[String(c)] = int(seen.get(String(c), 0)) + 1
	return seen


func _pieces(seen: Dictionary) -> Dictionary:
	var out := {}
	for p in STANCE_PIECES:
		out[p] = int(seen.get(p, 0))
	return out


# ── §0 — THE TWO ROWS ────────────────────────────────────────────────────────

func _s0_the_rows() -> void:
	print("\n§0 — the stance pieces are two RULED rows of GP's card gate")
	for p in STANCE_PIECES:
		ok(Classes.engine_read(p) == STANCES,
			"§0: %s reads `%s` in `Classes.ENGINE_READ`, not the Stances engine" % [p, Classes.engine_read(p)])
		ok(Classes.engine_read_ruled(p) == "HD §1",
			"§0: %s's row is not marked as the designer's ruling (`ruled` reads `%s`)" % [
				p, Classes.engine_read_ruled(p)])
		ok(Classes.draft_pool("warrior").has(p),
			"§0: %s is not in the Warrior's one pool — the gate has nothing to withhold" % p)
	# THE REST OF THE TABLE IS UNTOUCHED BY THE RULING: no other row names THIS
	# ruling, so the two cannot be mistaken for the derivation's rows.
	# **BATCH HE §2 RULED A THIRD ROW, MARK OF THE HUNT, UNDER ITS OWN RULING** —
	# so this arm asks which rows carry HD §1, the ruling it is about, and prints
	# the whole ruled set beside it (`check_he` §0 asserts that set).
	var ruled: Array = []
	var ruled_hd: Array = []
	for card in Classes.ENGINE_READ:
		var why := Classes.engine_read_ruled(String(card))
		if why != "":
			ruled.append(String(card))
		if why == "HD §1":
			ruled_hd.append(String(card))
	ruled.sort()
	ruled_hd.sort()
	ok(ruled_hd == ["Guard Change", "Lunge"],
		"§0: the rows ruled at HD §1 are %s — the ruling named two" % str(ruled_hd))
	print("    %d rows in the card gate, %d of them ruled: %s" % [
		Classes.ENGINE_READ.size(), ruled.size(), ", ".join(ruled)])


# ── §1 — EVERY DOOR THE GATE STANDS AT ──────────────────────────────────────

func _s1_every_door() -> void:
	print("\n§1 — the stance pieces at the elite draft and the zone boss's fallback, %d rolls an arm" % ROLLS)
	var arms := [
		["no lineage, no engine", "", [], false],
		["the Swordmaster's lineage, the Stances OWNED and unslotted", "swordmaster",
			[_eng(STANCES, false)], false],
		["no lineage, Heavy Plating slotted", "", [_eng("heavy_plating")], false],
		["the Berserker's lineage, Bloodrage slotted", "berserker", [_eng("bloodrage")], false],
		["no lineage, the Stances slotted", "", [_eng(STANCES)], true],
		["the Berserker's lineage, Bloodrage and the Stances slotted", "berserker",
			[_eng("bloodrage"), _eng(STANCES)], true],
	]
	for arm in arms:
		var label := String(arm[0])
		var wants := bool(arm[3])
		var m := _warrior(String(arm[1]), arm[2])
		var draft := _pieces(_tally(m, func(mm): return _run.roll_draft_offer(mm)))
		var fall := _pieces(_tally(m, func(mm): return _run.roll_draft_fallback_offer(mm)))
		# AND WHAT THE OVERLAY WILL SHOW: the triple `award_draft_pick` STORES.
		var stored := {}
		seed(ROLL_SEED)
		var m2 := _warrior(String(arm[1]), arm[2])
		for _j in int(ROLLS / 4.0):
			_run.award_draft_pick(m2)
		for trip in m2["draft_candidates"]:
			for c in trip:
				if STANCE_PIECES.has(String(c)):
					stored[String(c)] = int(stored.get(String(c), 0)) + 1
		print("    %-58s draft %s · fallback %s · stored %s" % [label, str(draft), str(fall), str(stored)])
		for p in STANCE_PIECES:
			if wants:
				ok(int(draft[p]) > 0 and int(fall[p]) > 0 and int(stored.get(p, 0)) > 0,
					"§1: a Warrior with %s was never offered %s (draft %d, fallback %d, stored %d) — the Stances holder is offered both" % [
						label, p, int(draft[p]), int(fall[p]), int(stored.get(p, 0))])
			else:
				ok(int(draft[p]) == 0 and int(fall[p]) == 0 and int(stored.get(p, 0)) == 0,
					"§1: a Warrior with %s was offered %s (draft %d, fallback %d, stored %d) — the stance pieces are the Stances holder's (HD §1)" % [
						label, p, int(draft[p]), int(fall[p]), int(stored.get(p, 0))])


# ── §2 — THE TWO DOORS THE GATE DOES NOT STAND AT ───────────────────────────

func _s2_the_doors_it_does_not_stand_at() -> void:
	print("\n§2 — the zone boss's first tier and a draft's answer: driven, and asserted since HE §3")
	# THE ZONE BOSS'S FIRST TIER. Lunge is on the Swordmaster's boss pool. The tier
	# asked the PET half of `offerable` alone (HC §5) until HE §3 overturned HC's
	# reason — the lineage outlives the engine it was chosen with — and it asks
	# the whole of `offerable` now: Lunge with the Stances slotted, never without.
	var held_m := _warrior("swordmaster", [_eng(STANCES)])
	var held_boss := _tally(held_m, func(mm): return _run.roll_spec_ability_offer(mm))
	ok(int(held_boss.get("Lunge", 0)) > 0,
		"§2: a Swordmaster-lineage Warrior holding the Stances is never offered Lunge by his zone boss (%s)" % str(held_boss))
	var bare_m := _warrior("swordmaster", [_eng(STANCES, false)])
	var bare_boss := _tally(bare_m, func(mm): return _run.roll_spec_ability_offer(mm))
	ok(int(bare_boss.get("Lunge", 0)) == 0,
		"§2: the zone boss's first tier offered Lunge %d times in %d rolls to a Swordmaster-lineage Warrior whose Stances are UNSLOTTED — it asks the engine half since HE §3" % [
			int(bare_boss.get("Lunge", 0)), ROLLS])
	print("      with the Stances slotted: %s · unslotted: %s" % [str(held_boss), str(bare_boss)])
	# A DRAFT'S ANSWER. A triple stored with the Stances slotted, answered after
	# they leave: `take_draft_ability` refused only a card the hero owns until
	# HE §3, and re-asks `Classes.offerable` now (`Run.draft_choice`).
	var ans := _warrior("", [_eng(STANCES)])
	seed(ROLL_SEED)
	var piece := ""
	for _k in ROLLS:
		ans["draft_candidates"] = []
		ans["draft_picks_owed"] = 0
		_run.award_draft_pick(ans)
		for c in ans["draft_candidates"][0]:
			if STANCE_PIECES.has(String(c)):
				piece = String(c)
		if piece != "":
			break
	ok(piece != "",
		"§2: %d draft rolls to a Warrior holding the Stances stored no stance piece — the positive arm cannot be read" % ROLLS)
	if piece != "":
		# THE NEGATIVE: unslotted, the answer refuses and hands nothing over.
		ans["engines"] = [_eng(STANCES, false)]
		var why: String = _run.take_draft_ability(ans, piece)
		ok(why != "" and not (ans["bm_abilities"] as Array).has(piece),
			"§2: %s, rolled with the Stances slotted and answered with them unslotted, was handed over (%s) — the answer re-asks the engine since HE §3" % [
				piece, "no refusal" if why == "" else why])
		# THE POSITIVE, ON THE SAME MEMBER: slotted again, the same stored card is
		# taken — the refusal filtered it and wrote nothing back (GV's rule).
		ans["engines"] = [_eng(STANCES)]
		var why2: String = _run.take_draft_ability(ans, piece)
		ok(why2 == "" and (ans["bm_abilities"] as Array).has(piece),
			"§2: %s, with the Stances slotted again, was not handed over (%s) — a held card waits stored" % [
				piece, why2])
		print("    %s answered unslotted: %s · slotted again: %s" % [
			piece, "refused (%s)" % why if why != "" else "handed over",
			"handed over" if why2 == "" else "refused (%s)" % why2])


# ── §3 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s3_the_players_files() -> void:
	print("\n§3 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§3: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§3: %s is byte for byte as this gate found it" % p)
