# BATCH GM — HOLD BREATH, AND CARDS THAT OUTLIVE THEIR ENGINE.
#
#   §1  THE HELD BREATH IS SPENT WHERE IT PAYS — six Quick Shots after one cast,
#       with Lethal Aim and with no engine at all, and the three casts the
#       engine's own block used to leave out
#   §2  AN ENGINE'S BOUND CARDS LEAVE WITH IT — every lineage's opening kit both
#       ways, the table checked in both directions on a live board, the one
#       earned exception, the slot count that did not move, and a drop written
#       in the middle of a fight moving nothing in that fight
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
# what opens it"; "no ally is covered" with "the rune covers exactly one";
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
		var s: Node = await Gate.spawn(self, LINEAGE_SEATS[0],
			{"deterministic": true, "party": over})
		var ss: BattleUnit = s.get("heroes")[SEAT_SS]
		var tag := "with Lethal Aim" if held else "with no engine"
		ok(ss.has_engine("lethal_aim") == held and (held or ss.engines.is_empty()),
			"§1 %s: the seat holds what the arm says (%s)" % [tag, str(ss.engines)])
		var qs: Ability = ss.abilities[0]
		var hb := _find(ss, "Hold Breath")
		ok(qs.display_name == "Quick Shot" and hb != null,
			"§1 %s: the kit holds Quick Shot and Hold Breath (%s)" % [tag, str(_names(ss))])
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
	# (a) the one builder, both ways, every lineage
	var bound_seen := 0
	for spec in Classes.SPEC_INFO:
		var ck := Classes.class_of_spec(String(spec))
		var own := Classes.engine_of_spec(String(spec))
		var held: Array = _kit_names(Classes.opening_kit(ck, String(spec), [own]))
		var dropped: Array = _kit_names(Classes.opening_kit(ck, String(spec), []))
		var bound: Array = Classes.engine_bound(String(spec))
		var enablers: Array = Classes.core_enablers(String(spec))
		for b in bound:
			bound_seen += 1
			ok(held.has(b) and not dropped.has(b),
				"§2: %s's %s is in the kit with the engine and gone without it" % [spec, b])
		# NOTHING ELSE LEAVES: what the drop takes is the enablers and the bound
		# cards, and every other card of the held kit is still there.
		var extra: Array = held.filter(func(n): return not dropped.has(n) \
			and not enablers.has(n) and not bound.has(n))
		ok(extra.is_empty(), "§2: dropping %s's engine takes nothing else (%s)" % [spec, str(extra)])
	ok(bound_seen >= 1, "§2: the bound table names a real population (%d)" % bound_seen)
	print("    %d bound cards across %d lineages" % [bound_seen,
		Classes.ENGINE_BOUND.size()])

	# (b) the table, both directions, on a live board
	for with_engine in [false, true]:
		var checked := 0
		for seats in LINEAGE_SEATS:
			var over := {}
			if not with_engine:
				for seat in 4:
					over[seat] = {"engines": []}
			var s: Node = await Gate.spawn(self, seats,
				{"deterministic": true, "party": over})
			await _open_board(s, with_engine)
			var H: Array = s.get("heroes")
			for i in 4:
				var u: BattleUnit = H[i]
				var spec := String(seats[i])
				var bound: Array = Classes.engine_bound(spec)
				var enablers: Array = Classes.core_enablers(spec)
				for ab in Classes.spec_abilities(spec):
					if ab == null or enablers.has(ab.display_name):
						continue
					var is_bound := bound.has(ab.display_name)
					if with_engine and not is_bound:
						continue
					checked += 1
					var usable := await _usable_on_open_board(s, u, ab)
					if with_engine:
						ok(usable and _names(u).has(ab.display_name),
							"§2: with the engine held, %s's %s is on the bar and castable on this board"
								% [spec, ab.display_name])
					elif is_bound:
						ok(not usable and not _names(u).has(ab.display_name),
							"§2: with no engine, %s's %s is refused on the board its kit can build, and off the bar"
								% [spec, ab.display_name])
					else:
						ok(usable and _names(u).has(ab.display_name),
							"§2: with no engine, %s's %s stays on the bar and castable — a fourth bound card cannot hide"
								% [spec, ab.display_name])
			await _clear(s)
		ok(checked >= 3, "§2: the %s arm read a real population (%d cards)"
			% ["engine-held" if with_engine else "engine-less", checked])

	# (c) THE ONE EARNED EXCEPTION, pinned so the day it stops being true this
	# says so: Call the Wilds summons with no engine, so an engine-less
	# Beastmaster who earned it fields a companion and Kill Command's door would
	# open. The card left anyway — the ruling names it (`docs/reports/GM.md` §2).
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
	ok(_find(bm, "Kill Command") == null,
		"§2: ...and Kill Command is off his bar all the same — the exception is reported, not built")
	await _clear(s2)

	# (d) THE SLOT A BOUND CARD LEFT STAYS COUNTED — no magnitude moved.
	var run: Node = root.get_node("/root/Run")
	for spec2 in Classes.ENGINE_BOUND:
		var ck2 := Classes.class_of_spec(String(spec2))
		var m_held := {"key": ck2, "spec": spec2,
			"engines": Runes.engine_pouch_for_spec(String(spec2)), "bm_abilities": []}
		var m_drop := {"key": ck2, "spec": spec2, "engines": [], "bm_abilities": []}
		ok(run.ability_slots_used(m_held) == run.ability_slots_used(m_drop)
				and run.ability_slots_used(m_drop) == Classes.lineage_slots(String(spec2)),
			"§2: %s's slot count is %d with the engine and without (the ruling freed no slot)"
				% [spec2, run.ability_slots_used(m_drop)])

	# (e) A DROP WRITTEN IN THE MIDDLE OF A FIGHT MOVES NOTHING IN THAT FIGHT.
	# Only the map's rune pouch drops an engine, and the fight reads the member
	# once, at the spawn: the unit's engines, its bar and its cooldowns are what
	# they were, and the member's next fight is what changes.
	var s3: Node = await Gate.spawn(self, LINEAGE_SEATS[0], {"deterministic": true})
	var arc: BattleUnit = s3.get("heroes")[1]
	var arc_member: Dictionary = run.party[1]
	var kit_was: Array = _names(arc)
	var eng_was: Array = arc.engines.duplicate()
	arc.cooldowns["Death Ray"] = 2
	ok(run.toggle_engine(arc_member, 0) and run.engines_worn(arc_member) == 0,
		"§2: the member's engine is dropped through the pouch's own door")
	ok(arc.engines == eng_was and _names(arc) == kit_was
			and int(arc.cooldowns.get("Death Ray", 0)) == 2,
		"§2: ...and the fight in progress keeps its engine, its bar and Death Ray's cooldown")
	ok(not run.opening_kit_names(arc_member).has("Death Ray")
			and kit_was.has("Death Ray"),
		"§2: ...while the member's next fight opens without Death Ray")
	run.toggle_engine(arc_member, 0)
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
func _open_board(s: Node, with_engine: bool) -> void:
	var H: Array = s.get("heroes")
	for u in H:
		u.resource = u.max_resource
		u.cooldowns.clear()
		if with_engine and u.second_resource_name != "":
			u.second_resource = 100
	s._apply_status(_foe(s), "burn", 3, 0, 0, H[0])
	if with_engine:
		for u2 in H:
			for ab in u2.abilities:
				if ab.special == "summon" and s._beasts(u2).is_empty():
					await s._resolve_special(u2, ab, u2, "good", 1.0)


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
	return await Gate.spawn(self, LINEAGE_SEATS[0], {"deterministic": true, "party": over})


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
