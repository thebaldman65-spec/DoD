# BATCH GM — HOLD BREATH, AND CARDS THAT OUTLIVE THEIR ENGINE.
#
#   §1  THE HELD BREATH IS SPENT WHERE IT PAYS — six Quick Shots after one cast,
#       with Lethal Aim and with no engine at all, and the three casts the
#       engine's own block used to leave out
#   §2  AN ENGINE'S BOUND CARDS LEAVE WITH IT — every lineage's opening kit both
#       ways, the table checked in both directions on a live board, the one
#       earned exception, the slot count that did not move, and a drop written
#       in the middle of a fight moving nothing in that fight
#       (BATCH GS §1 — the bound table is DELETED and the ruling holds by
#       construction: a lineage opens with its enablers alone, so a hero who
#       drops his engine holds his class basic and class kit, and the three
#       bound cards are draft cards. §2 asserts the table gone, the builder both
#       ways, the gate at the OFFER — `Classes.ENGINE_READ` — driven both ways on
#       a live board with the lineage cards drafted, Kill Command's exception
#       built, and the drop mid-fight on the one thing that still leaves: an
#       enabler)
#   §3  THE SPLIT SHIELD'S CAST IS ITS TABLE — with the rune and without, a
#       Warden standing alone, and a whole bot turn
#   §4  DISPEL LEAVES THE PARTY'S WORK — the three statuses GL found, with an
#       enemy's own ward as the arm that must still be stripped
#
# ── WHY IT DRIVES ────────────────────────────────────────────────────────────
# **A STATIC CHECK CANNOT SEE A STATUS THAT NEVER EXPIRES.** Hold Breath's
# countdown sat inside the Lethal Aim block, so every source read of the card,
# the status and the payout looked right, and only a hero with no engine firing
# shot after shot showed the chip standing. GL found all four of GM's defects by
# driving them in a scratch probe; this is that drive, kept, so a regression
# reads red in the battery instead of waiting to be played into.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM BESIDE IT.** "It stands after
# none of the six" is paired with "the first shot carried it" and "that shot hit
# harder"; "the bound card is refused with the engine gone" with "the engine is
# what opens it" (since GS: the `ENGINE_READ` row, drafted, refused with the
# engine gone and opened by it); "no ally is covered" with "the rune covers exactly one";
# "Dispel leaves the mark" with "Dispel still takes an enemy's own ward". A
# negative anchor alone passes on a gate that stopped driving anything.
#
# ── THE BOARD ────────────────────────────────────────────────────────────────
# Every battle is `gate_fixture.spawn` with the fixture's deterministic rolls
# (no crit, parry, block or cover of its own), and the damage roll is seeded
# before each measured run of shots, so a reading is the same every battery.
# The fixture points `Run` at its harness save under `--script`, and nothing
# here names a player file.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gm.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# One seat per class, in the fixture's order, so the twelve lineages are three
# battles; `SEAT_SS` is the Sharpshooter's seat in the first.
const LINEAGE_SEATS := [
	["warden", "arcanist", "holy", "sharpshooter"],
	["berserker", "pyromancer", "inquisitor", "beastmaster"],
	["swordmaster", "cryomancer", "occultist", "mystic"],
]
const SEAT_SS := 3
const SHOTS := 6
const GM_SEED := 20260916

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	await _s1_held_breath()
	await _s2_bound_cards()
	await _s3_split_shield()
	await _s4_dispel()
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────
func _find(u: BattleUnit, n: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == n:
			return ab
	return null


func _names(u: BattleUnit) -> Array:
	return u.abilities.map(func(a): return a.display_name)


func _kit_names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _foe(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if not e.dead:
			return e
	return null


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 5:
		await process_frame


func _shots(s: Node, u: BattleUnit, ab: Ability, n: int) -> Array:
	var out: Array = []
	for _i in n:
		var foe := _foe(s)
		foe.hp = foe.max_hp
		var had := u.has_status("held_breath")
		await s._resolve(u, ab, foe, "good")
		out.append({"had": had, "after": u.has_status("held_breath"),
			"dmg": foe.max_hp - foe.hp})
	return out


func _mean(rows: Array) -> float:
	var m := 0.0
	for r in rows:
		m += float(r["dmg"])
	return m / maxf(float(rows.size()), 1.0)


# ── §1 — THE HELD BREATH ────────────────────────────────────────────────────
func _s1_held_breath() -> void:
	print("--- GM §1: the held breath is spent where it pays ---")
	for held in [false, true]:
		var over := {} if held else {SEAT_SS: {"engines": []}}
		# BATCH GS — Hold Breath left the Sharpshooter's opening kit for his shelf,
		# so it is seated DRAFTED (`lineage_cards`), as a player now gets it; the
		# engine-less arm keeps it, because a drafted card never leaves with an
		# engine. The breath's mechanics are what this section drives, unchanged.
		var s: Node = await Gate.spawn(self, LINEAGE_SEATS[0],
			{"deterministic": true, "party": over, "lineage_cards": true})
		var ss: BattleUnit = s.get("heroes")[SEAT_SS]
		var tag := "with Lethal Aim" if held else "with no engine"
		ok(ss.has_engine("lethal_aim") == held and (held or ss.engines.is_empty()),
			"§1 %s: the seat holds what the arm says (%s)" % [tag, str(ss.engines)])
		var qs: Ability = ss.abilities[0]
		var hb := _find(ss, "Hold Breath")
		ok(qs.display_name == "Quick Shot" and hb != null,
			"§1 %s: the bar holds Quick Shot and a drafted Hold Breath (%s)" % [tag, str(_names(ss))])
		if hb == null:
			await _clear(s)
			continue
		seed(GM_SEED)
		var before: Array = await _shots(s, ss, qs, 3)
		await s._resolve_special(ss, hb, ss, "good", 1.0)
		ok(ss.has_status("held_breath"), "§1 %s: Hold Breath lays the status" % tag)
		seed(GM_SEED + 1)
		var after: Array = await _shots(s, ss, qs, SHOTS)
		var standing := after.filter(func(r): return bool(r["after"])).size()
		ok(bool(after[0]["had"]) and not bool(after[0]["after"]),
			"§1 %s: the first shot after the cast carries it and spends it" % tag)
		ok(standing == 0,
			"§1 %s: it stands after none of the %d shots (%d)" % [tag, SHOTS, standing])
		var rest := _mean(after.slice(1))
		ok(float(after[0]["dmg"]) > rest * 1.3,
			"§1 %s: ...and the shot that spent it was the promised one (%d against %.1f)"
				% [tag, int(after[0]["dmg"]), rest])
		print("    %s: three shots before the cast mean %.1f; the %d after it mean %.1f (the first %d, the rest %.1f)"
			% [tag, _mean(before), SHOTS, _mean(after), int(after[0]["dmg"]), rest])
		# A COUNTER IS NOT PAID THE PROMISED CRITICAL, SO IT SPENDS NOTHING — the
		# payout's gate and the spend's gate are one gate.
		await s._resolve_special(ss, hb, ss, "good", 1.0)
		var had_c := ss.has_status("held_breath")
		var foe_c := _foe(s)
		foe_c.hp = foe_c.max_hp
		await s._resolve(ss, qs, foe_c, "good", true)
		ok(had_c and ss.has_status("held_breath"),
			"§1 %s: a counter swing, which the promised critical is not paid to, spends nothing" % tag)
		ss.remove_status("held_breath")
		# THE THREE CASTS THE ENGINE BLOCK LEFT OUT — a Lethal Aim holder's
		# Drumfire, Called Volley and area casts were paid the promised shot on
		# every target and kept the breath.
		if held:
			var area: Ability = null
			for a in Classes.ability_corpus():
				if a != null and a.aoe and a.damage > 0 and a.special == "" \
						and a.display_name != "Called Volley":
					area = a
					break
			var casts: Array = [Classes.pool_ability("Drumfire"),
				Classes.pool_ability("Called Volley"), area]
			ok(casts.all(func(c): return c != null),
				"§1: Drumfire, Called Volley and an area card all resolve")
			for c in casts:
				if c == null:
					continue
				await s._resolve_special(ss, hb, ss, "good", 1.0)
				ss.cooldowns.clear()
				var stood := ss.has_status("held_breath")
				await s._resolve(ss, c, _foe(s), "good")
				ok(stood and not ss.has_status("held_breath"),
					"§1: a Lethal Aim holder's %s stood in the breath and spent it" % c.display_name)
				ss.remove_status("held_breath")
		await _clear(s)


# ── §2 — THE BOUND CARDS ────────────────────────────────────────────────────
func _s2_bound_cards() -> void:
	print("--- GM §2: an engine's bound cards leave with it ---")
	var run: Node = root.get_node("/root/Run")
	# (a) the one builder, both ways, every lineage
	# BATCH GS §1 — THE BOUND TABLE IS DELETED, NOT ZEROED, AND THE RULING HOLDS
	# BY CONSTRUCTION. A lineage opens with its engine's enablers and nothing
	# else, so a hero who drops his engine holds only his class basic and his
	# class kit — the negative, every lineage — and with the engine held he holds
	# its enablers too and nothing more: the positive arm, which is the old
	# "nothing else leaves" asked of the new kit. The loop over the table had
	# nothing left to walk, so its population is replaced rather than left empty
	# (the lineages whose engine brings a card), and the table's absence is read
	# off the source with its name split, so this file never spells it whole.
	var brings := 0
	for spec in Classes.SPEC_INFO:
		var ck := Classes.class_of_spec(String(spec))
		var own := Classes.engine_of_spec(String(spec))
		var held: Array = _kit_names(Classes.opening_kit(ck, String(spec), [own]))
		var dropped: Array = _kit_names(Classes.opening_kit(ck, String(spec), []))
		var enablers: Array = Classes.core_enablers(String(spec))
		var every: Array = _kit_names(Classes.kit(ck)) + Classes.class_kit_names(ck)
		var got_d: Array = dropped.duplicate()
		got_d.sort()
		var want_d: Array = every.duplicate()
		want_d.sort()
		ok(got_d == want_d,
			"§2: %s's hero who drops his engine holds only his class basic and class kit (%s)" % [spec, str(dropped)])
		# NOTHING ELSE LEAVES: what the drop takes is the enablers, and every
		# other card of the held kit is still there.
		var brought: Array = held.filter(func(n): return not dropped.has(n))
		var want_b: Array = enablers.filter(func(n): return not every.has(n))
		brought.sort()
		want_b.sort()
		ok(brought == want_b,
			"§2: with the engine held, %s's hero holds its enablers too and nothing else (%s, want %s)" % [
				spec, str(brought), str(want_b)])
		if not brought.is_empty():
			brings += 1
	ok(brings >= 1, "§2: an engine brings a card to a real population of lineages (%d)" % brings)
	var csrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/classes.gd"))
	for dead in ["ENGINE_" + "BOUND", "engine_" + "bound("]:
		ok(not csrc.contains(dead), "§2: `%s` has code in `classes.gd` again — the bound table is back" % dead)
	# THE CARDS IT NAMED, WHERE THEY ARE NOW. Death Ray and Resurrection are
	# refused at the door without their engine, so they are rows of
	# `Classes.ENGINE_READ` — gated at the OFFER, on the engine their own lineage
	# carries. The third, Kill Command, is not a row: (c).
	for row_card in ["Death Ray", "Resurrection"]:
		var home := ""
		for spec3 in Classes.SPEC_INFO:
			if Gate.lineage_cards(String(spec3)).has(row_card):
				home = String(spec3)
		ok(home != "" and Classes.engine_read(row_card) == Classes.engine_of_spec(home),
			"§2: %s is a row of `ENGINE_READ` on its own lineage's engine (%s's; it reads `%s`)" % [
				row_card, home, Classes.engine_read(row_card)])
	print("    the bound table is gone; %d lineages' engines bring a card, and nothing else leaves with one" % brings)

	# (b) the table, both directions, on a live board
	# BATCH GS — THE TABLE IS `ENGINE_READ` NOW, AND ITS GATE IS THE OFFER, so the
	# cards a lineage opened with until GS are seated as a player now gets them —
	# DRAFTED (`lineage_cards`) — and asked both ways at the door. With no engine
	# every one stays the hero's (a drafted card never leaves with an engine), the
	# rows are refused, and every other card casts on a board holding what no
	# engine is needed for — Kill Command's companion among it, which an earned
	# Call the Wilds calls with no engine ((c)). With the engine held, the rows
	# open. And each hero's live bar is the one builder's kit and his drafted
	# cards: nothing of the lineage without its engine, its enablers with it.
	#
	# **BATCH GT §3 — A ROW THE DOOR REFUSES ON EVERY BOARD NOW SITS OUT (ruled).**
	# GS left the three on the bar, dark; GT's ruling takes a card that cannot be
	# cast without its engine out of the fight while the engine is gone and keeps
	# it the hero's. So the bar is the kit and the drafted cards LESS what sits out
	# for the engines he holds (`Classes.sits_out`), and each of the three is
	# asserted kept, off the bar, and still refused by the door — the reason it
	# sits out — rather than on the bar and refused.
	for with_engine in [false, true]:
		var checked := 0
		for seats in LINEAGE_SEATS:
			var over := {}
			if not with_engine:
				for seat in 4:
					over[seat] = {"engines": []}
					if Classes.class_of_spec(String(seats[seat])) == "hunter":
						over[seat]["bm_abilities"] = Gate.lineage_cards(String(seats[seat])) \
							+ ["Call the Wilds"]
			var s: Node = await Gate.spawn(self, seats,
				{"deterministic": true, "party": over, "lineage_cards": true})
			var H: Array = s.get("heroes")
			for i0 in 4:
				var spec0 := String(seats[i0])
				var held0: Array = [Classes.engine_of_spec(spec0)] if with_engine else []
				var want0: Array = _kit_names(Classes.opening_kit(Classes.class_of_spec(spec0), spec0,
					held0)) + Array(run.party[i0]["bm_abilities"]).filter(
						func(nm): return not Classes.sits_out(String(nm), held0))
				ok(_names(H[i0]) == want0,
					"§2: %s %s: the bar is the builder's kit and the drafted cards, no more (%s)" % [
						spec0, "with the engine" if with_engine else "with no engine", str(_names(H[i0]))])
			await _open_board(s, with_engine)
			for i in 4:
				var u: BattleUnit = H[i]
				var spec := String(seats[i])
				for n in Gate.lineage_cards(spec):
					var ab := _find(u, String(n))
					var reads := Classes.engine_read(String(n))
					if with_engine and reads == "":
						continue
					checked += 1
					var usable := false
					if ab != null:
						usable = await _usable_on_open_board(s, u, ab)
					if with_engine:
						ok(usable and _names(u).has(String(n)),
							"§2: with the engine held, %s's %s is on the bar and castable on this board"
								% [spec, n])
					elif Classes.sits_out(String(n), []):
						var fresh: Ability = Classes.pool_ability(String(n))
						var refused := false
						if fresh != null:
							refused = not (await _usable_on_open_board(s, u, fresh))
						ok(ab == null and Array(run.party[i]["bm_abilities"]).has(String(n)) and refused,
							"§2: with no engine, %s's %s sits out — kept, off the bar, and refused by the door (GT §3): it reads %s"
								% [spec, n, reads])
					elif reads != "" and Classes.engine_read_ruled(String(n)) != "":
						# **BATCH HD §1 — A RULED ROW IS GATED AT THE OFFER, NOT AT THE
						# DOOR.** Guard Change is the Swordmaster's lineage card and, since
						# HD, a row of the card gate by the designer's ruling — and it still
						# casts without the Stances (it lands its Break damage and flips a
						# guard only a card reads), which is WHY it is a ruling and not a
						# row the cast test found. So the arm below, whose premise is that
						# a row is refused at the door, is not its arm: drafted, it stays
						# on the bar and castable. The offer is `check_hd`'s and `check_gp`'s.
						ok(ab != null and usable and _names(u).has(String(n)),
							"§2: with no engine, %s's %s — a RULED row (%s), gated at the offer — stays on the bar and castable"
								% [spec, n, Classes.engine_read_ruled(String(n))])
					elif reads != "":
						ok(ab != null and not usable,
							"§2: with no engine, %s's %s stays on the bar — drafted — and the door refuses it: it reads %s"
								% [spec, n, reads])
					else:
						ok(usable and _names(u).has(String(n)),
							"§2: with no engine, %s's %s stays on the bar and castable — an engine read the table misses cannot hide"
								% [spec, n])
			await _clear(s)
		ok(checked >= 3, "§2: the %s arm read a real population (%d cards)"
			% ["engine-held" if with_engine else "engine-less", checked])

	# (c) THE ONE EARNED EXCEPTION, pinned so the day it stops being true this
	# says so: Call the Wilds summons with no engine, so an engine-less
	# Beastmaster who earned it fields a companion and Kill Command's door would
	# open. The card left anyway — the ruling names it (`docs/reports/GM.md` §2).
	# (BATCH GS §1 — it no longer leaves: Kill Command is a Beastmaster draft
	# card, and this door is why it is not a row of `ENGINE_READ`.)
	var s2: Node = await Gate.spawn(self, LINEAGE_SEATS[1],
		{"deterministic": true,
		 "party": {3: {"engines": [], "bm_abilities": ["Call the Wilds"]}}})
	var bm: BattleUnit = s2.get("heroes")[3]
	var cw := _find(bm, "Call the Wilds")
	ok(cw != null and bm.engines.is_empty(),
		"§2: an engine-less Beastmaster carries an earned Call the Wilds")
	if cw != null:
		bm.resource = bm.max_resource
		await s2._resolve_special(bm, cw, _foe(s2), "good", 1.0)
	var kc: Ability = null
	for ab2 in Classes.spec_abilities("beastmaster"):
		if ab2 != null and ab2.display_name == "Kill Command":
			kc = ab2
	ok(not s2._beasts(bm).is_empty() and kc != null and s2._ability_usable(bm, kc),
		"§2: ...which fields a companion with no engine, so Kill Command's door would open for him")
	# BATCH GS — THIS READ "Kill Command is off his bar all the same — the
	# exception is reported, not built", and GS §1 built it: the card is drafted
	# now, the offer gates it on no engine because the door above opens without
	# one, and (b) casts it drafted beside an earned Call the Wilds.
	ok(Classes.engine_read("Kill Command") == ""
			and Classes.offerable(["Kill Command"], []) == ["Kill Command"],
		"§2: ...and Kill Command is not a row of `ENGINE_READ`: a Hunter holding no engine is offered it — the exception is built, not reported")
	await _clear(s2)

	# (d) THE SLOT A BOUND CARD LEFT STAYS COUNTED — no magnitude moved.
	# BATCH GS — the table this walked is deleted, and the ruling it priced holds
	# for every lineage now: only an enabler leaves with an engine, and an enabler
	# sits outside the count, so a drop frees no slot anywhere. All twelve.
	# BATCH HB — AND ONE ENGINE TAKES A KIT CARD AWAY WHILE HELD. The
	# Sharpshooter's Lethal Aim dismisses the pet, so HOLDING it frees the pet's
	# slot and dropping it takes the slot back: a drop still frees no slot
	# anywhere, and the held count is the dropped one less the card the engine
	# dismisses — one lineage, by one, read off the same door the kit reads.
	for spec2 in Classes.SPEC_INFO:
		var ck2 := Classes.class_of_spec(String(spec2))
		var m_held := {"key": ck2, "spec": spec2,
			"engines": Runes.engine_pouch_for_spec(String(spec2)), "bm_abilities": []}
		var m_drop := {"key": ck2, "spec": spec2, "engines": [], "bm_abilities": []}
		var freed := 1 if Classes.dismisses_pet(Runes.held_engines(m_held)) else 0
		# BATCH GN — the opening is the lineage's count and the class kit's.
		ok(run.ability_slots_used(m_held) == run.ability_slots_used(m_drop) - freed
				and run.ability_slots_used(m_drop) == Classes.lineage_slots(String(spec2))
					+ Classes.kit_slots(ck2, String(spec2)),
			"§2: %s's slot count is %d with the engine and %d without (a drop frees no slot)"
				% [spec2, run.ability_slots_used(m_held), run.ability_slots_used(m_drop)])

	# (e) A DROP WRITTEN IN THE MIDDLE OF A FIGHT MOVES NOTHING IN THAT FIGHT.
	# Only the map's rune pouch drops an engine, and the fight reads the member
	# once, at the spawn: the unit's engines, its bar and its cooldowns are what
	# they were, and the member's next fight is what changes.
	# BATCH GS — this was driven on the Arcanist's Death Ray, and Death Ray no
	# longer leaves with his engine (it is drafted now, and a drafted card stays).
	# The one thing that still leaves with an engine is its ENABLER, so the drop
	# is driven on the Pyromancer's, read off `core_enablers` rather than named.
	var s3: Node = await Gate.spawn(self, LINEAGE_SEATS[1], {"deterministic": true})
	var mg_spec := String(LINEAGE_SEATS[1][1])
	var mg: BattleUnit = s3.get("heroes")[1]
	var mg_member: Dictionary = run.party[1]
	var mg_en: Array = Classes.core_enablers(mg_spec)
	var enab := String(mg_en[0]) if not mg_en.is_empty() else "(no enabler)"
	var kit_was: Array = _names(mg)
	var eng_was: Array = mg.engines.duplicate()
	mg.cooldowns[enab] = 2
	ok(run.toggle_engine(mg_member, 0) and run.engines_worn(mg_member) == 0,
		"§2: the member's engine is dropped through the pouch's own door")
	ok(mg.engines == eng_was and _names(mg) == kit_was
			and int(mg.cooldowns.get(enab, 0)) == 2,
		"§2: ...and the fight in progress keeps its engine, its bar and %s's cooldown" % enab)
	ok(not run.opening_kit_names(mg_member).has(enab)
			and kit_was.has(enab),
		"§2: ...while the member's next fight opens without %s, which left with its engine (%s)" % [enab, mg_spec])
	run.toggle_engine(mg_member, 0)
	await _clear(s3)
	var bsrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var rsrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(not bsrc.contains('["equipped"] =') and not bsrc.contains(".equipped ="),
		"§2: the battle writes no engine's slot state")
	ok(rsrc.contains('r["equipped"] = false'),
		"§2: ...where the pouch's door does, so the sweep can see a write when there is one")


# Everything the board can hold that no engine gives: a full bar, no cooldowns,
# a burning enemy, and — for the engine-held arm only — the meter and the
# companion that engine's own machinery would bring.
# BATCH GS — and, for the engine-less arm, the companion an EARNED Call the Wilds
# calls, which needs no engine ((c)): Kill Command is a draft card since GS §1,
# and its door is a card's, not an engine's. Cast before the bar is refilled.
func _open_board(s: Node, with_engine: bool) -> void:
	var H: Array = s.get("heroes")
	if not with_engine:
		for u0 in H:
			var cw0 := _find(u0, "Call the Wilds")
			if cw0 != null and s._beasts(u0).is_empty():
				u0.resource = u0.max_resource
				await s._resolve_special(u0, cw0, _foe(s), "good", 1.0)
	for u in H:
		u.resource = u.max_resource
		u.cooldowns.clear()
		if with_engine and u.second_resource_name != "":
			u.second_resource = 100
	s._apply_status(_foe(s), "burn", 3, 0, 0, H[0])
	# BATCH HB — THE SUMMON ON THE BAR IS ONE CARD NOW, whose picker casts one of
	# three calls; the card itself names no companion. The board fields the wolf
	# through the call the picker and the bot build (`_summon_choice`), which is
	# the companion every Hunter but the Sharpshooter brings since HB.
	if with_engine:
		for u2 in H:
			for ab in u2.abilities:
				if ab.special == "summon" and s._beasts(u2).is_empty():
					var call: Ability = s._summon_choice(u2, "canis") \
						if ab.display_name == Classes.PET_CARD else ab
					if call != null:
						await s._resolve_special(u2, call, u2, "good", 1.0)


func _usable_on_open_board(s: Node, u: BattleUnit, ab: Ability) -> bool:
	var fallen: BattleUnit = null
	if ab.special == "resurrection":
		for h in s.get("heroes"):
			if h != u:
				fallen = h
				break
		fallen.dead = true
	u.cooldowns.clear()
	var usable: bool = s._ability_usable(u, ab)
	if fallen != null:
		fallen.dead = false
	return usable


# ── §3 — THE SPLIT SHIELD ───────────────────────────────────────────────────
func _s3_split_shield() -> void:
	print("--- GM §3: the Split Shield's cast is its table ---")
	var half: int = 0
	for with_rune in [false, true]:
		var s: Node = await _warden_board(with_rune)
		var H: Array = s.get("heroes")
		var wd: BattleUnit = H[0]
		var ally: BattleUnit = H[2]
		var sw := _find(wd, "Shieldwall")
		var tag := "with the Split Shield" if with_rune else "without the rune"
		ok(sw != null and (wd.rune_split_shield > 0) == with_rune,
			"§3 %s: the Warden holds Shieldwall and the rune as the arm says" % tag)
		var own: Array = s._recast_writes(wd, sw, wd)
		var at_ally: Array = s._recast_writes(wd, sw, ally)
		await s._resolve_special(wd, sw, ally, "good", 1.0)
		var covered: Array = H.filter(func(h): return h != wd and h.has_status("bulwark_line"))
		ok(not own.is_empty() and wd.status_power("shieldwall") == int(own[0]["power"])
				and int(wd.get_status("shieldwall").get("turns", 0)) == int(own[0]["turns"]),
			"§3 %s: the Warden's wall is the table's entry for him (%d)"
				% [tag, wd.status_power("shieldwall")])
		if with_rune:
			half = int(own[0]["power"])
			ok(half == s.SHIELDWALL_BLOCK / 2,
				"§3: the rune halves his wall (%d of %d)" % [half, s.SHIELDWALL_BLOCK])
			ok(not at_ally.is_empty() and ally.status_power("bulwark_line") == int(at_ally[0]["power"])
					and int(ally.get_status("bulwark_line").get("turns", 0)) == int(at_ally[0]["turns"]),
				"§3: ...and the ally's half is the table's entry for the ally (%d)"
					% ally.status_power("bulwark_line"))
			ok(covered == [ally],
				"§3: ...on exactly the hero he set it in front of (%d covered)" % covered.size())
			ok(is_equal_approx(s._plating_slice(ally), 0.01 * float(at_ally[0]["power"])),
				"§3: ...and it reaches the Block roll's own slice (%.2f)" % s._plating_slice(ally))
		else:
			ok(wd.status_power("shieldwall") == s.SHIELDWALL_BLOCK,
				"§3: without the rune the wall is whole (%d)" % wd.status_power("shieldwall"))
			ok(at_ally.is_empty() and covered.is_empty(),
				"§3: ...and it covers no ally, in the table or in the cast")
		# the bot names whom it sets the wall in front of
		wd.resource = wd.max_resource
		wd.cooldowns.clear()
		var pick: Array = s._autoplay_pick_kit(wd)
		var picked: BattleUnit = pick[1] if pick.size() > 1 else null
		ok(not pick.is_empty() and pick[0] == sw
				and ((picked != wd and picked != null and not picked.dead) if with_rune else picked == wd),
			"§3 %s: the bot sets the wall %s" % [tag,
				"in front of an ally" if with_rune else "for himself"])
		await _clear(s)
	# ALONE, the rune sets it in front of nobody: his half, no one covered.
	var s2: Node = await _warden_board(true)
	var H2: Array = s2.get("heroes")
	var wd2: BattleUnit = H2[0]
	for h in H2:
		if h != wd2:
			h.dead = true
	ok(s2._split_shield_allies(wd2).is_empty(),
		"§3: a Warden standing alone has nobody to set the wall in front of")
	await s2._resolve_special(wd2, _find(wd2, "Shieldwall"), wd2, "good", 1.0)
	ok(wd2.status_power("shieldwall") == half and half > 0
			and not H2.any(func(h): return h != wd2 and h.has_status("bulwark_line")),
		"§3: ...so he keeps his half (%d) and nothing is split off" % wd2.status_power("shieldwall"))
	await _clear(s2)
	# A WHOLE BOT TURN — the door a real turn goes through, not the handler alone.
	for with_rune2 in [false, true]:
		var s3: Node = await _warden_board(with_rune2)
		var H3: Array = s3.get("heroes")
		var wd3: BattleUnit = H3[0]
		wd3.resource = wd3.max_resource
		wd3.cooldowns.clear()
		s3.set("autoplay", true)
		await s3._player_turn(wd3)
		s3.set("autoplay", false)
		var cov3: Array = H3.filter(func(h): return h != wd3 and h.has_status("bulwark_line"))
		if with_rune2:
			ok(wd3.status_power("shieldwall") == half and cov3.size() == 1
					and cov3[0].status_power("bulwark_line") == half,
				"§3: a whole bot turn with the rune lays his half and one ally's (%d, %d covered)"
					% [wd3.status_power("shieldwall"), cov3.size()])
		else:
			ok(wd3.status_power("shieldwall") == s3.SHIELDWALL_BLOCK and cov3.is_empty(),
				"§3: a whole bot turn without it lays the whole wall and covers nobody (%d)"
					% wd3.status_power("shieldwall"))
		await _clear(s3)


func _warden_board(with_rune: bool) -> Node:
	var over := {}
	if with_rune:
		var r: Dictionary = Runes.build("split_shield")
		r["equipped"] = true
		over = {0: {"runes": [r]}}
	# BATCH GS — Shieldwall left the Warden's opening kit for his shelf, so it is
	# seated DRAFTED (`lineage_cards`), the way the Split Shield now finds it; the
	# wall and the rune's split are what §3 drives, unchanged.
	return await Gate.spawn(self, LINEAGE_SEATS[0],
		{"deterministic": true, "party": over, "lineage_cards": true})


# ── §4 — DISPEL ─────────────────────────────────────────────────────────────
func _s4_dispel() -> void:
	print("--- GM §4: Dispel leaves the party's work ---")
	var s: Node = await Gate.spawn(self, LINEAGE_SEATS[2], {"deterministic": true})
	var H: Array = s.get("heroes")
	var mage: BattleUnit = H[1]
	var hunter: BattleUnit = H[3]
	var foe := _foe(s)
	var laid: Array = []
	for row in [["Hunter's Mark", hunter, "party_mark"],
			["Arcane Echo", mage, "arcane_echo"], ["Rime", mage, "rime"]]:
		var ab: Ability = Classes.pool_ability(String(row[0]))
		ok(ab != null, "§4: %s resolves" % row[0])
		if ab == null:
			continue
		row[1].resource = row[1].max_resource
		await s._resolve_special(row[1], ab, foe, "good", 1.0)
		if not foe.has_status(String(row[2])):
			await s._resolve(row[1], ab, foe, "good")
		if foe.has_status(String(row[2])):
			laid.append(String(row[2]))
	ok(laid.size() == 3, "§4: the three party statuses stand on one enemy (%s)" % str(laid))
	var takeable: Array = s._dispellable_buffs(foe).map(func(x): return String(x.id))
	ok(not laid.any(func(id): return takeable.has(id)),
		"§4: Dispel may take none of them (%s)" % str(takeable))
	var dispel: Ability = Classes.pool_ability("Dispel")
	mage.resource = mage.max_resource
	await s._resolve_special(mage, dispel, foe, "good", 1.0)
	ok(laid.all(func(id): return foe.has_status(id)),
		"§4: ...and a Dispel cast on that enemy leaves all three standing")
	# THE OTHER ARM — an enemy's own ward is still a beneficial effect on it.
	var foe2: BattleUnit = s.get("enemies")[1]
	s._apply_status(foe2, "shielded", 3)
	var had := foe2.has_status("shielded")
	var in_set: bool = s._dispellable_buffs(foe2).any(func(x): return String(x.id) == "shielded")
	mage.cooldowns.clear()
	mage.resource = mage.max_resource
	await s._resolve_special(mage, dispel, foe2, "good", 1.0)
	ok(had and in_set and not foe2.has_status("shielded"),
		"§4: ...while an enemy's own ward is still Dispel's to take, and is taken")
	await _clear(s)
