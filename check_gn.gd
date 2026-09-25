# BATCH GN — THE FOUR CLASS KITS.
#
#   §0  THE KIT, READ — every class's three through the one builder: a hero with
#       no lineage and no engine opens with his basic and the three; a lineage
#       that already opens with a kit card holds it once (none does since BATCH
#       GS: one that DEFINES a kit card holds it once, through the kit); the slots
#       each hero opens at; the five cards that left the class pools, and the pools left
#   §1  THE TWELVE, DRIVEN — every kit card cast on a hero of its class holding
#       NO engine, and what it promises read off the board
#   §2  ELEMENTAL WEAKNESS — Magic Burst lays it, a hit of every school but
#       physical lands harder on it by the ruled 15 points, a physical hit does
#       not, and the glossary entry is back
#   §3  THE SPINE-TAKER — class selection on the real screen, a spine taken, the
#       map, and the first battle: four abilities, not one
#   §4  THE BOT — the class branch names each of the twelve on a board where the
#       card has something to do, and a live autoplay stretch casts all twelve
#   §5  THE PLAYER'S FILES — as this gate found them
#
# ── WHY IT DRIVES ────────────────────────────────────────────────────────────
# **A KIT CARD THAT NEEDS AN ENGINE IS THE FAILURE THIS BATCH EXISTS TO
# PREVENT**, and GL's test was read rather than driven for most candidates. So
# every card is cast here on a hero who holds nothing, and the thing it promises
# is measured on the board it lands on.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM BESIDE IT.** "The physical hit is
# not raised" beside "every other school is"; "the moved cards are in no pool"
# beside "each still resolves and is in the corpus"; "a lineage holds its kit
# card once" beside "it holds it"; "Tripwire answers a melee blow" beside "it
# lets a ranged one pass".
#
# ── THE BOARD ────────────────────────────────────────────────────────────────
# `gate_fixture.spawn` with four heroes seated with NO lineage — the seat a hero
# who took a spine sits in, with his engine then emptied — and the fixture's
# deterministic rolls. Damage pairs are seeded. `Run` writes its harness save
# under `--script` (FI); `Profile` and `Relics` are pointed at scratch files of
# this gate's own before class selection writes the profile (§3), and §5 reads
# the player's three files byte for byte.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gn.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const NO_LINEAGE := ["", "", "", ""]
const CLASS_SEATS := ["warrior", "mage", "cleric", "hunter"]
const SPINES := {"warrior": "engine_momentum", "mage": "engine_channel",
	"cleric": "engine_sanctity"}
const GN_SEED := 20260917
const SCRATCH_PROFILE := "user://gn_profile.json"
const SCRATCH_RELICS := "user://gn_relics.json"
const FRAME_CAP := 6000
# The five that were class-wide and are guaranteed now.
const LEFT_THE_POOLS := ["Nexus Ward", "Magic Missiles", "Ministration",
	"Unburden", "Consecration"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH GN — THE FOUR CLASS KITS")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_s0_the_kit()
	await _s1_the_twelve()
	await _s2_elemental_weakness()
	await _s3_the_spine_taker()
	await _s4_the_bot()
	_s5_the_players_files()
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────
func _names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _find(u: BattleUnit, n: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == n:
			return ab
	return null


# The card a drive needs, or null with a red: a gate that throws on a missing
# card idles forever instead of reporting (FR §5a), so every drive asks here.
func _card(u: BattleUnit, n: String) -> Ability:
	var ab := _find(u, n) if u != null else null
	ok(ab != null, "§1: the %s holds %s" % [u.hero_key if u != null else "?", n])
	return ab


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 5:
		await process_frame


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return s.get("enemies").filter(func(e): return not e.dead)


# A foe made a clean slate for the next measured blow: full and very deep
# health, no meter, no statuses.
func _reset_foe(e: BattleUnit) -> void:
	e.max_hp = 100000
	e.hp = e.max_hp
	e.pressure = 0
	e.broken = false
	e.broken_pending = false
	for st in e.statuses.duplicate():
		e.remove_status(String(st.id))


func _ready_to_cast(u: BattleUnit) -> void:
	u.resource = u.max_resource
	u.cooldowns.clear()


func _no_lineage_board(drafted: Dictionary = {}) -> Node:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
		# BATCH HB — a seat may carry drafted cards (Tripwire, since it left the kit).
		if drafted.has(seat):
			over[seat]["bm_abilities"] = (drafted[seat] as Array).duplicate()
			over[seat]["bm_equipped"] = (drafted[seat] as Array).duplicate()
	return await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})


# ── §0 — THE KIT, READ ──────────────────────────────────────────────────────
func _s0_the_kit() -> void:
	print("--- GN §0: the kit, read ---")
	var dedupe := {}
	# BATCH GS — the lineages whose DEFINITION table carries a kit card: the
	# positive arm beside `dedupe`, which asks what a lineage OPENS with.
	var defined := {}
	for ck in CLASS_SEATS:
		var kit: Array = Classes.class_kit_names(ck)
		var resolved: Array = _names(Classes.class_kit(ck))
		ok(kit.size() == 3 and resolved == kit,
			"§0: the %s kit is three abilities and all three resolve (%s)" % [ck, str(resolved)])
		var basic: String = Classes.kit(ck)[0].display_name
		var bare: Array = _names(Classes.opening_kit(ck, "", []))
		ok(bare == [basic] + kit,
			"§0: a %s with no lineage and no engine opens with %s and the kit (%s)"
				% [ck, basic, str(bare)])
		for pid in Classes.class_engines(ck):
			var spec := Classes.engine_spec(String(pid))
			for held in [[pid], []]:
				var got: Array = _names(Classes.opening_kit(ck, spec, held))
				var twice: Array = []
				for n in got:
					if got.count(n) > 1 and not twice.has(n):
						twice.append(n)
				# BATCH HB §4 — THE KIT A HERO OPENS WITH READS HIS ENGINES. The
				# Sharpshooter's Lethal Aim dismisses the pet, so held he opens with
				# the kit less Summon Companion AND WITHOUT IT — the negative arm —
				# while the same lineage with the engine dropped holds all three
				# again, which is the positive arm beside it on the next pass.
				var want_kit: Array = Classes.class_kit_names_for(ck, held)
				var pet_gone: bool = not Classes.dismisses_pet(held) or not got.has(Classes.PET_CARD)
				ok(twice.is_empty() and want_kit.all(func(k): return got.has(k)) and pet_gone,
					"§0: %s (%s) holds the kit, each card once (%s)"
						% [pid, "engine held" if not held.is_empty() else "engine dropped", str(twice)])
			if spec != "":
				# BATCH GS §1 — WHAT THE LINEAGE OPENS WITH, NOT WHAT IT DEFINES. The
				# two were one list until GS; `spec_abilities` is a lineage's
				# definition table now, and it opens with its engine's enablers
				# alone (`lineage_opening`), so a kit card it defines reaches the
				# hero through the class kit and costs a kit slot like anyone's.
				var shared: Array = []
				for ab in Classes.lineage_opening(spec):
					if ab != null and kit.has(ab.display_name):
						shared.append(ab.display_name)
				if not shared.is_empty():
					dedupe[spec] = shared
				var defines: Array = []
				for ab2 in Classes.spec_abilities(spec):
					if ab2 != null and kit.has(ab2.display_name):
						defines.append(ab2.display_name)
				if not defines.is_empty():
					defined[spec] = defines
			# THE SLOTS: the lineage's, plus the kit's less what the lineage counts.
			# **BATCH HH §3 — THIS ARM IS RE-POINTED AT HI, NOT RETIRED, BY RULING.** HA's
			# census answers it twice: its §1d table marks it RETIRE (it restates
			# `ability_slots_used`, a near-tautology while `lineage_slots` is zero for
			# every lineage), and its §1g calls `ability_slots_used` "the door a future
			# lineage card would have to pass through" — the door this arm pins. The
			# designer ruled §1g's specific reading over §1d's general one (HH's brief,
			# as HG had sorted it), so **HA §1d's RETIRE for this line is not live**: it
			# goes to HI with the re-points.
			# **BATCH HJ — RE-POINTED BY RULING (HH §3): THE DOOR, ASKED OF WHAT HE OPENS
			# WITH, WITH HIS ENGINE HELD.** It asked `ability_slots_used` of a member
			# holding NO engine and compared it with `lineage_slots + kit_slots` — the
			# door's own two terms, so the arm restated the door and could only fail if
			# the door disagreed with itself (HA §1d's "near-tautology"). What HA §1g
			# keeps it for is the door a future lineage card would pass through, so it
			# asks the door against something the door does not compute: the cards the
			# hero OPENS with (`Classes.opening_kit`, the one builder), less the class
			# basic and the enablers of the engines he holds — which sit outside the
			# count (the charter) — the pet card's calls one entry, as the bar groups
			# them. Seated holding the engine, as class selection hands it: since HB the
			# kit he holds reads his engines, and a Sharpshooter holding Lethal Aim
			# opens at two. The kit's own slots with the engine dropped are still asked
			# beside it, as GN wrote them.
			var eng_rune: Dictionary = Runes.build(Runes.engine_rune_id(String(pid)))
			eng_rune["equipped"] = true
			var m := {"key": ck, "spec": spec, "engines": [eng_rune], "bm_abilities": []}
			var used: int = _run.ability_slots_used(m)
			var basic_nm: String = Classes.kit(ck)[0].display_name
			var outside: Array = Classes.engine_enablers(String(pid))
			var opened := 0
			var calls := false
			for ab3 in Classes.opening_kit(ck, spec, [pid]):
				if ab3 == null or ab3.display_name == basic_nm or outside.has(ab3.display_name):
					continue
				if ab3.special == "summon":
					calls = true
				else:
					opened += 1
			if calls:
				opened += 1
			ok(used == opened
					and Classes.kit_slots(ck, spec) == 3 - (dedupe.get(spec, []) as Array).size(),
				"§0: %s, engine held, opens at %d of %d slots and the door counts %d (engine dropped, the kit takes %d)" % [
					pid, opened, _run.ability_slot_cap(), used, Classes.kit_slots(ck, spec)])
			print("    %-14s %-12s opens at %d of %d" % [pid, spec if spec != "" else "(no lineage)",
				used, _run.ability_slot_cap()])
		# the protected list names the kit
		# BATCH HB — the kit its lineage HOLDS: the Sharpshooter's protected list
		# names Powershot and Snare Trap once each, and the pet not at all.
		for spec2 in Classes.SPEC_IDS[ck]:
			var prot: Array = Classes.protected_names(String(spec2))
			var kit2: Array = Classes.class_kit_names_for(ck, [Classes.engine_of_spec(String(spec2))])
			ok(kit2.all(func(k): return prot.count(k) == 1)
					and (kit2.size() == kit.size() or not prot.has(Classes.PET_CARD)),
				"§0: %s's protected list names each kit card once" % spec2)
	# A KIT CARD IS PROTECTED AT THE ONE BENCH DOOR, and the door still benches
	# an earned card — the positive arm, on the same member.
	var benchy := {"key": "mage", "spec": "", "engines": [], "bm_abilities": ["Mirror Image"]}
	ok(not _run.unequip_earned_ability(benchy, "Magic Burst")
			and not _run.unequip_earned_ability(benchy, "Nexus Ward")
			and _run.unequip_earned_ability(benchy, "Mirror Image"),
		"§0: the bench door refuses a kit card and still benches an earned one")
	# THE DEDUPE POPULATION IS DERIVED, AND IT IS THE FOUR LINEAGES THE KITS SHARE A CORE WITH.
	# **BATCH GS §1 — AND IT IS EMPTY NOW.** It was the Berserker (Bloodlust), the
	# Warden (Mocking Blow and Crushing Blow), the Sharpshooter (Powershot) and the
	# Survivalist (Tripwire and Snare Trap): a lineage opens with its engine's
	# enablers alone since GS, and no enabler is a kit card (Bloodlust left the
	# kit, GS §2). The lineages that DEFINE a kit card are the arm below — the
	# Swordmaster among them, Pommel Strike being the kit's since GS §2.
	ok(dedupe.is_empty(),
		"§0: no lineage opens with a kit card any more — an engine brings only its enablers (GS §1) (%s)" % str(dedupe))
	# THE POSITIVE ARM BESIDE IT: the lineages that DEFINE a kit card still hold it,
	# and once — through the class kit, the dedupe following the card, not the kit.
	var held_once := not defined.is_empty()
	for sp3 in defined:
		var got3: Array = _names(Classes.opening_kit(Classes.class_of_spec(String(sp3)),
			String(sp3), [Classes.engine_of_spec(String(sp3))]))
		for k3 in defined[sp3]:
			if got3.count(k3) != 1:
				held_once = false
	ok(held_once,
		"§0: ...and a lineage that defines a kit card holds it exactly once, through the kit (%s)" % str(defined))
	# A hero with no lineage opens at three; a Warden, sharing two, at four.
	# **BATCH GS — EVERY HERO OPENS AT THREE**, the Warden with them: nothing of a
	# lineage opens inside the count any more, and its enablers sit outside it.
	var every_three: bool = _run.ability_slots_used(
		{"key": "cleric", "spec": "", "engines": [], "bm_abilities": []}) == 3
	for ck4 in CLASS_SEATS:
		for sp4 in Classes.SPEC_IDS[ck4]:
			if _run.ability_slots_used({"key": ck4, "spec": String(sp4), "engines": [],
					"bm_abilities": []}) != 3:
				every_three = false
	ok(every_three, "§0: a hero with no lineage opens at 3, and so does every lineage, a Warden too (GS)")
	# THE POOLS: the five left, and the cards they still hold are real.
	var in_a_pool: Array = []
	for ck2 in CLASS_SEATS:
		for n in Classes.class_kit_names(ck2):
			for k2 in Classes.CLASS_DRAFT_POOLS:
				if Classes.CLASS_DRAFT_POOLS[k2].has(n):
					in_a_pool.append(n)
			for sp in Classes.SPEC_DRAFT_POOLS:
				if Classes.SPEC_DRAFT_POOLS[sp].has(n):
					in_a_pool.append(n)
			for sp2 in Classes.SPEC_POOLS:
				if Classes.SPEC_POOLS[sp2].has(n):
					in_a_pool.append(n)
	ok(in_a_pool.is_empty(), "§0: no kit card is in a draft or boss pool (%s)" % str(in_a_pool))
	var corpus: Array = _names(Classes.ability_corpus())
	ok(LEFT_THE_POOLS.all(func(n): return Classes.pool_ability(n) != null and corpus.has(n)),
		"§0: ...and each of the five that left still resolves and is in the corpus")
	ok(corpus.has("Magic Burst") and Classes.pool_ability("Magic Barrier") == null
			and not corpus.has("Magic Barrier"),
		"§0: Magic Burst is in the corpus, and Magic Barrier is a name nothing resolves")
	for ck3 in CLASS_SEATS:
		var pool: Array = Classes.class_draft_pool(ck3)
		ok(not pool.is_empty() and pool.all(func(n): return Classes.pool_ability(String(n)) != null),
			"§0: the %s class pool is %d real cards" % [ck3, pool.size()])
	print("    class pools: warrior %d, mage %d, cleric %d, hunter %d" % [
		Classes.class_draft_pool("warrior").size(), Classes.class_draft_pool("mage").size(),
		Classes.class_draft_pool("cleric").size(), Classes.class_draft_pool("hunter").size()])
	for n2 in ["Magic Burst", "Nexus Ward"]:
		ok(not Classes.card_tags(n2).is_empty(), "§0: %s carries a tag" % n2)


# ── §1 — THE TWELVE, DRIVEN ─────────────────────────────────────────────────
func _s1_the_twelve() -> void:
	print("--- GN §1: the twelve, cast by heroes holding no engine ---")
	var s: Node = await _no_lineage_board()
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var H := _hero(s, "hunter")
	var all_four: Array = [W, M, C, H]
	if all_four.any(func(h): return h == null):
		ok(false, "§1: the board seats one hero of each class")
		await _clear(s)
		return
	ok(all_four.all(func(h): return h.engines.is_empty() and h.abilities.size() == 4),
		"§1: four heroes, no engines, four abilities each (%s)" % str(all_four.map(
			func(h): return h.abilities.size())))
	for h in all_four:
		ok(_names(h.abilities).slice(1) == Classes.class_kit_names(h.hero_key),
			"§1: the %s's bar is his basic and the kit (%s)" % [h.hero_key, str(_names(h.abilities))])
	var foes := _foes(s)
	var e0: BattleUnit = foes[0]
	var e1: BattleUnit = foes[1]
	var e_melee: BattleUnit = null
	for e in foes:
		if not e.is_ranged and e_melee == null:
			e_melee = e
	var striker: BattleUnit = e_melee if e_melee != null else e0
	for e in foes:
		_reset_foe(e)

	# CRUSHING BLOW — damage, Sunder for 3 turns, armour x0.65, +10 Rage.
	var crush := _card(W, "Crushing Blow")
	if crush != null:
		_ready_to_cast(W)
		W.resource = 50
		var armor_was := e0.effective_armor()
		await s._resolve(W, crush, e0, "good")
		ok(e0.hp < e0.max_hp and int(e0.get_status("sunder").get("turns", 0)) == 3
				and is_equal_approx(e0.effective_armor(), minf(armor_was * 0.65, 0.85))
				and W.resource == 50 - 20 + 10,
			"§1: Crushing Blow hits, Sunders for 3 turns (armour %.3f -> %.3f) and builds its Rage (%d)"
				% [armor_was, e0.effective_armor(), W.resource])
		print("    Crushing Blow: %d damage, Sunder %d turns, armour %.3f -> %.3f, Rage 50 -> %d" % [
			e0.max_hp - e0.hp, int(e0.get_status("sunder").get("turns", 0)), armor_was,
			e0.effective_armor(), W.resource])
		_reset_foe(e0)

	# BLOODLUST — damage, and heals 30% of missing health.
	# **BATCH GS §2 — POMMEL STRIKE TOOK ITS PLACE IN THE KIT (ruled).** Bloodlust is
	# the Berserker's enabler now and no card of a hero who holds no engine, so the
	# kit's second card is driven here instead, against what it promises: a hit,
	# 30 Break damage, a Stun for 1 turn on an enemy that is no boss, and 10 Rage
	# built back on its cost of 20.
	var pommel := _card(W, "Pommel Strike")
	if pommel != null:
		_ready_to_cast(W)
		W.resource = 50
		await s._resolve(W, pommel, e0, "good")
		var stun_turns := int(e0.get_status("stunned").get("turns", 0))
		ok(e0.hp < e0.max_hp and e0.pressure == 30 and stun_turns == 1
				and W.resource == 50 - 20 + 10,
			"§1: Pommel Strike hits, lands 30 Break damage (%d), Stuns for 1 turn (%d) and builds its Rage (%d)"
				% [e0.pressure, stun_turns, W.resource])
		print("    Pommel Strike: %d damage, %d Break damage, Stunned %d turn, Rage 50 -> %d" % [
			e0.max_hp - e0.hp, e0.pressure, stun_turns, W.resource])
		_reset_foe(e0)

	# MOCKING BLOW — free, the target and one other enemy mocked for 4 turns.
	var mock := _card(W, "Mocking Blow")
	if mock != null:
		_ready_to_cast(W)
		W.resource = 0
		var w_idx: int = s.get("heroes").find(W)
		await s._resolve(W, mock, e0, "good")
		var mocked: Array = []
		for e in foes:
			if e.has_status("mocked") and e.status_power("mocked") == w_idx \
					and int(e.get_status("mocked").get("turns", 0)) == 4:
				mocked.append(e)
		ok(mock.cost == 0 and e0.hp < e0.max_hp
				and mocked.size() == 2 and mocked.has(e0) and W.resource == 10,
			"§1: Mocking Blow is free, hits, and holds the target and one other to the Warrior for 4 turns (%d held)"
				% mocked.size())
		print("    Mocking Blow: cost %d, %d damage, %d enemies held for 4 turns, Rage 0 -> %d" % [
			mock.cost, e0.max_hp - e0.hp, mocked.size(), W.resource])
		for e in foes:
			_reset_foe(e)

	# NEXUS WARD — a barrier worth 20% of the Mage's maximum health, 3 turns,
	# and it eats a blow before his health does.
	var ward_ab := _card(M, "Nexus Ward")
	if ward_ab != null:
		_ready_to_cast(M)
		await s._resolve_special(M, ward_ab, M, "good", 1.0)
		var ward: Dictionary = M.get_status("barrier")
		var ward_power := int(ward.get("power", 0))
		ok(not ward.is_empty() and ward_power == int(round(M.max_hp * 0.20))
				and int(ward.get("turns", 0)) == 3,
			"§1: Nexus Ward raises a barrier of %d (20%% of %d) for 3 turns" % [ward_power, M.max_hp])
		var lost_warded := await _blow(s, striker, M)
		var ward_left: int = M.status_power("barrier") if M.has_status("barrier") else 0
		M.remove_status("barrier")
		var lost_bare := await _blow(s, striker, M)
		ok(lost_bare > 0 and lost_warded == maxi(lost_bare - ward_power, 0)
				and ward_left == maxi(ward_power - lost_bare, 0),
			"§1: ...and it eats a blow before the Mage's health does (%d of a %d blow reached him; %d of the ward left)"
				% [lost_warded, lost_bare, ward_left])
		print("    Nexus Ward: barrier %d (20%% of %d) for %d turns; a %d blow reached him for %d" % [
			ward_power, M.max_hp, int(ward.get("turns", 0)), lost_bare, lost_warded])

	# MAGIC MISSILES — three hits, 3 Break damage each.
	var missiles := _card(M, "Magic Missiles")
	if missiles != null:
		_ready_to_cast(M)
		var hits_before: int = e0.hp
		await s._resolve(M, missiles, e0, "good")
		ok(e0.hp < hits_before and e0.pressure == 9,
			"§1: Magic Missiles lands three bolts — 9 Break damage from three 3s (%d)" % e0.pressure)
		print("    Magic Missiles: %d damage, %d Break damage" % [hits_before - e0.hp, e0.pressure])
		_reset_foe(e0)

	# MINISTRATION — 20% of THE TARGET's maximum health.
	var mend := _card(C, "Ministration")
	if mend != null:
		_ready_to_cast(C)
		W.hp = 1
		await s._resolve_special(C, mend, W, "good", 1.0)
		ok(W.hp - 1 == int(round(W.max_hp * 0.20)) and C.max_hp != W.max_hp,
			"§1: Ministration heals the Warrior %d — 20%% of HIS maximum (%d), not the Cleric's (%d)"
				% [W.hp - 1, W.max_hp, C.max_hp])
		print("    Ministration: the Warrior regains %d of his %d" % [W.hp - 1, W.max_hp])
		W.hp = W.max_hp

	# UNBURDEN — every harmful effect off, 20% less damage for 3 turns.
	var lift := _card(C, "Unburden")
	if lift != null:
		_ready_to_cast(C)
		s._apply_status(H, "cripple", 3, 0, 0, e0)
		s._apply_status(H, "slow", 3, 0, 0, e0)
		var had_two: bool = H.has_status("cripple") and H.has_status("slow")
		await s._resolve_special(C, lift, H, "good", 1.0)
		ok(had_two and not H.has_status("cripple") and not H.has_status("slow")
				and int(H.get_status("unburdened").get("turns", 0)) == 3,
			"§1: Unburden lifts both afflictions and leaves the Hunter Unburdened for 3 turns")
		var lost := await _blow(s, striker, H)
		H.remove_status("unburdened")
		var lost_plain := await _blow(s, striker, H)
		ok(lost_plain > 0 and absf(float(lost) / float(lost_plain) - 0.80) <= 0.05,
			"§1: ...and takes 20%% less from the same blow (%d against %d)" % [lost, lost_plain])
		print("    Unburden: two afflictions lifted; the same blow %d unburdened, %d without" % [lost, lost_plain])

	# CONSECRATION — every hero, 4 turns, 5% of maximum at the turn start.
	var bless := _card(C, "Consecration")
	if bless != null:
		_ready_to_cast(C)
		await s._resolve_special(C, bless, C, "good", 1.0)
		ok(all_four.all(func(h): return int(h.get_status("consecration").get("turns", 0)) == 4),
			"§1: Consecration blesses every hero for 4 turns")
		var ticked: Array = []
		for h in all_four:
			h.hp = int(h.max_hp * 0.5)
			var before: int = h.hp
			s._consecration_tick(h)
			# 5% of his own maximum, through his own healing-received multiplier
			# (the Cleric's class passive raises what he receives).
			var want := int(round(maxi(int(round(h.max_hp * 0.05)), 1) * h.healing_received_mult))
			if h.hp - before != want:
				ticked.append("%s %d not %d" % [h.hero_key, h.hp - before, want])
			h.hp = h.max_hp
		ok(ticked.is_empty(), "§1: ...and each regains 5%% of his own maximum at his turn start (%s)" % str(ticked))
		print("    Consecration: four heroes blessed for 4 turns; each tick 5% of his own maximum")

	# POWERSHOT — +2% a point of the target's Break meter.
	var power := _card(H, "Powershot")
	if power != null:
		_ready_to_cast(H)
		var atk_was := H.attack
		H.attack = 1000
		seed(GN_SEED)
		var flat := await _hit(s, H, power, e0, 0)
		seed(GN_SEED)
		var primed := await _hit(s, H, power, e0, 50)
		H.attack = atk_was
		ok(flat > 0 and absf(float(primed) / float(flat) - 2.0) <= 0.03,
			"§1: Powershot lands twice as hard on a meter at 50 (%d against %d)" % [primed, flat])
		print("    Powershot: %d on an empty meter, %d on a meter at 50" % [flat, primed])

	# SNARE TRAP — the next time the enemy acts it is Stunned and Poisoned. The
	# spring is inside the battle's own turn loop, so the loop is let run.
	var snare := _card(H, "Snare Trap")
	if snare != null:
		_ready_to_cast(H)
		for e in foes:
			_reset_foe(e)
		await s._resolve_special(H, snare, e1, "good", 1.0)
		ok(e1.has_status("snared") and e1.status_power("snared") == s.get("heroes").find(H),
			"§1: Snare Trap rigs a snare under the enemy, the Hunter's")
		var sprung := await _run_until_snare_springs(s, H, e1)
		ok(bool(sprung["sprung"]) and bool(sprung["stunned"]) and bool(sprung["poisoned"]),
			"§1: ...and when that enemy's turn comes it is Stunned and Poisoned (%s)" % str(sprung))
		print("    Snare Trap: %s" % str(sprung))

	# SUMMON COMPANION — ONE CARD, THREE CALLS (BATCH HB §1). The Hunter on this
	# board holds no engine, so this is the drive every kit card owes: the picker
	# offers the three calls, the chosen one fields the companion it names, and
	# that companion strikes beside his basic — the strike that sat inside Pack
	# Bond's check until HB.
	var pet := _card(H, Classes.PET_CARD)
	if pet != null:
		_ready_to_cast(H)
		s._open_summon_picker(H)
		var offered: Array = _names(s.get("_summon_opts"))
		s._close_summon_picker()
		ok(offered == ["Summon Ursus", "Summon Canis", "Summon Aguila"],
			"§1: Summon Companion's picker offers its three calls (%s)" % str(offered))
		for e in foes:
			_reset_foe(e)
		await s._resolve(H, s._summon_choice(H, "canis"), H, "good")
		var fielded: Array = s._beasts(H).map(func(b): return b.companion_kind)
		ok(fielded == ["canis"], "§1: ...the call fields the companion it names (%s)" % str(fielded))
		_ready_to_cast(H)
		var hist: RichTextLabel = s.get("history")
		var was := hist.get_parsed_text().length()
		await s._resolve(H, H.abilities[0], e0, "good")
		var struck := hist.get_parsed_text().substr(was).contains("Canis: strikes")
		ok(struck, "§1: ...and it strikes beside the Hunter's basic with no engine held")
		print("    Summon Companion: %s; fielded %s; struck beside the basic: %s" % [
			str(offered), str(fielded), struck])
	await _clear(s)

	# TRIPWIRE — 6 turns; a melee blow on a hero is answered with 75% of it, a
	# ranged one is not.
	# **RE-POINTED BY BATCH HB §2: TRIPWIRE IS A DRAFTED CARD NOW**, off the
	# Survivalist's shelf — Summon Companion took its kit slot. What it promises
	# is unchanged, so the drive is: seated the way a player now gets it, as a
	# card the Hunter drafted, on the same no-engine board.
	var s2: Node = await _no_lineage_board({3: ["Tripwire"]})
	var H2 := _hero(s2, "hunter")
	var W2 := _hero(s2, "warrior")
	var mel: BattleUnit = null
	var rng: BattleUnit = null
	for e in _foes(s2):
		_reset_foe(e)
		if e.is_ranged and rng == null:
			rng = e
		elif not e.is_ranged and mel == null:
			mel = e
	var wire := _card(H2, "Tripwire")
	if wire != null and mel != null and rng != null:
		_ready_to_cast(H2)
		await s2._resolve_special(H2, wire, H2, "good", 1.0)
		ok(int(H2.get_status("tripwire").get("turns", 0)) == 6, "§1: Tripwire is rigged for 6 turns")
		W2.hp = W2.max_hp
		var w_before := W2.hp
		await s2._resolve(mel, mel.abilities[0], W2, "good")
		var dealt := w_before - W2.hp
		ok(dealt > 0 and mel.max_hp - mel.hp == maxi(int(dealt * 0.75), 1),
			"§1: ...a melee blow of %d on an ally is answered with %d (75%%)" % [dealt, mel.max_hp - mel.hp])
		print("    Tripwire: 6 turns; a melee blow of %d answered with %d" % [dealt, mel.max_hp - mel.hp])
		W2.hp = W2.max_hp
		await s2._resolve(rng, rng.abilities[0], W2, "good")
		ok(rng.hp == rng.max_hp, "§1: ...and a ranged blow is not answered")
	elif wire != null:
		ok(false, "§1: the warband seats a melee and a ranged enemy to read Tripwire against")
	await _clear(s2)


# One seeded enemy blow on a hero made deep for the reading, so neither arm is
# cut short by a floor of health; the hero is put back as he was.
func _blow(s: Node, foe: BattleUnit, victim: BattleUnit) -> int:
	var mhp_was := victim.max_hp
	var atk_was := foe.attack
	victim.max_hp = 100000
	victim.hp = victim.max_hp
	victim.pressure = 0
	victim.broken = false
	foe.attack = maxi(atk_was, 400)
	foe.cooldowns.clear()
	seed(GN_SEED + 7)
	var before := victim.hp
	await s._resolve(foe, foe.abilities[0], victim, "good")
	var lost := before - victim.hp
	foe.attack = atk_was
	victim.max_hp = mhp_was
	victim.hp = mhp_was
	victim.pressure = 0
	victim.broken = false
	return lost


# One measured blow with the target's Break meter set first.
func _hit(s: Node, u: BattleUnit, ab: Ability, target: BattleUnit, meter: int) -> int:
	_reset_foe(target)
	target.pressure = meter
	u.cooldowns.clear()
	u.resource = u.max_resource
	var before := target.hp
	await s._resolve(u, ab, target, "good")
	var dealt := before - target.hp
	_reset_foe(target)
	return dealt


# The parked battle is let run on autoplay: the parked hero's turn is answered
# with his own Tripwire (a self-cast, so nothing is clicked), and the loop goes
# round until the snared enemy's turn has come. Nothing dies — every foe is
# deep — and no enemy strikes (the fixture's switch).
func _run_until_snare_springs(s: Node, hunter: BattleUnit, victim: BattleUnit) -> Dictionary:
	var out := {"sprung": false, "stunned": false, "poisoned": false, "frames": 0}
	s.set("autoplay", true)
	var parked: BattleUnit = s.get("current_hero")
	if parked != null:
		var self_cast: Ability = null
		for ab in parked.abilities:
			if ab.special in ["tripwire", "magic_barrier", "consecration"]:
				self_cast = ab
		parked.cooldowns.clear()
		parked.resource = parked.max_resource
		if self_cast == null:
			self_cast = parked.abilities[0]
		s.emit_signal("_ability_picked", self_cast)
	var frames := 0
	var hist: RichTextLabel = s.get("history")
	var seen_len := hist.get_parsed_text().length()
	while frames < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		frames += 1
		var text := hist.get_parsed_text()
		if not victim.has_status("snared"):
			# The spring and the lost turn run in one stretch of the loop, so the
			# Stun is spent before this frame is read: the lost turn is read off
			# the combat log written in that stretch.
			var fresh := text.substr(seen_len)
			out["sprung"] = fresh.contains("snare springs on %s" % victim.unit_name)
			out["stunned"] = fresh.contains("%s is stunned and loses their turn" % victim.unit_name)
			out["poisoned"] = victim.has_status("poison")
			break
		seen_len = text.length()
		if bool(s.get("battle_over")):
			break
	Engine.time_scale = 1.0
	s.set("autoplay", false)
	out["frames"] = frames
	return out


# ── §2 — ELEMENTAL WEAKNESS ─────────────────────────────────────────────────
func _s2_elemental_weakness() -> void:
	print("--- GN §2: Elemental Weakness is filled, not created ---")
	var s: Node = await _no_lineage_board()
	var M := _hero(s, "mage")
	var foes := _foes(s)
	var e0: BattleUnit = foes[0]
	_reset_foe(e0)
	_ready_to_cast(M)
	var burst := _find(M, "Magic Burst")
	ok(burst != null, "§2: the Mage holds Magic Burst")
	if burst != null:
		await s._resolve(M, burst, e0, "good")
		var st: Dictionary = e0.get_status("elem_weak")
		ok(e0.hp < e0.max_hp and int(st.get("power", 0)) == 15 and int(st.get("turns", 0)) == 3
				and int(st.get("power", 0)) == s.ELEM_WEAK_PCT
				and int(st.get("turns", 0)) == s.ELEM_WEAK_TURNS,
			"§2: Magic Burst hits and lays Elemental Weakness at 15 for 3 turns (%s)" % str(st))
		ok(String(st.get("src_name", "")) == M.unit_name,
			"§2: ...stamped with the Mage who laid it")
		print("    Magic Burst: %d damage; Elemental Weakness %d for %d turns" % [
			e0.max_hp - e0.hp, int(st.get("power", 0)), int(st.get("turns", 0))])
		# A second burst refreshes the three turns...
		e0.get_status("elem_weak")["turns"] = 1
		_ready_to_cast(M)
		await s._resolve(M, burst, e0, "good")
		ok(int(e0.get_status("elem_weak").get("turns", 0)) == 3 and e0.status_power("elem_weak") == 15,
			"§2: a second Magic Burst refreshes the three turns")
		# ...and cannot write a stronger weakness down (CP §0's clamp).
		_reset_foe(e0)
		s._apply_elem_weak(e0, 30, 3, M)
		_ready_to_cast(M)
		await s._resolve(M, burst, e0, "good")
		ok(e0.status_power("elem_weak") == 30,
			"§2: a burst over a deeper weakness leaves it at 30 (%d)" % e0.status_power("elem_weak"))
	# THE PHYSICAL NEGATIVE, ARMED: the rider does not fire off a physical card.
	_reset_foe(e0)
	var strike: Ability = Classes.kit("warrior")[0]
	_ready_to_cast(M)
	await s._resolve(M, strike, e0, "good")
	ok(e0.hp < e0.max_hp and not e0.has_status("elem_weak"),
		"§2: a blow that is not Magic Burst lays no weakness")
	# EVERY SCHOOL BUT PHYSICAL, MEASURED ON THE SAME ENEMY WITH THE SAME DICE.
	var schools := ["arcane", "fire", "frost", "shadow", "holy", "nature", "physical"]
	var probe := {}
	for ab in Classes.ability_corpus():
		if ab == null or probe.has(ab.dmg_type) or not schools.has(ab.dmg_type):
			continue
		if ab.damage <= 0 or ab.special != "" or ab.aoe or ab.choose_two or ab.choose_three \
				or ab.multi_hits > 0 or ab.random_hits > 0 \
				or ab.gated or ab.recoil_base > 0.0 or ab.bleed_build > 0 \
				or ab.heal_missing > 0.0:
			continue
		probe[ab.dmg_type] = ab
	ok(probe.size() == schools.size(),
		"§2: a plain single strike exists for every school (%s)" % str(probe.keys()))
	M.attack = 1000
	var raised := 0
	for school in schools:
		if not probe.has(school):
			continue
		var ab2: Ability = probe[school]
		_reset_foe(e0)
		var r: float = float(e0.resists.get(school, 0.0))
		var plain := await _cast_at(s, M, ab2, e0, false)
		var weak := await _cast_at(s, M, ab2, e0, true)
		print("    %-8s %-18s plain %4d  weakened %4d  x%.3f  (resist %d%%)" % [school,
			ab2.display_name, plain, weak, float(weak) / maxf(float(plain), 1.0), int(round(r * 100))])
		if school == "physical":
			ok(plain > 0 and weak == plain,
				"§2: a physical hit (%s) is not raised (%d and %d)" % [ab2.display_name, plain, weak])
		else:
			var want: float = (1.0 - r + 0.15) / (1.0 - r)
			ok(plain > 0 and weak > plain and absf(float(weak) / float(plain) - want) <= 0.02,
				"§2: a %s hit (%s) lands %.3f as hard, as 15 points off a %d%% resistance should (%d against %d)"
					% [school, ab2.display_name, float(weak) / maxf(float(plain), 1.0),
						int(round(r * 100)), weak, plain])
			if weak > plain:
				raised += 1
	ok(raised == 6, "§2: all six schools but physical are raised (%d)" % raised)
	# FIFTEEN POINTS OF RESISTANCE, NOT A x1.15: a resisted school gains more
	# and a weakness less, and each gains 15% of the blow before resistance.
	if probe.has("arcane"):
		for r2 in [0.30, -0.20]:
			var saved: Dictionary = e0.resists.duplicate()
			e0.resists["arcane"] = r2
			var p2 := await _cast_at(s, M, probe["arcane"], e0, false)
			var w2 := await _cast_at(s, M, probe["arcane"], e0, true)
			e0.resists = saved
			var want2: float = (1.0 - r2 + 0.15) / (1.0 - r2)
			ok(p2 > 0 and absf(float(w2) / float(p2) - want2) <= 0.02,
				"§2: against %d%% arcane resistance the weakened hit is x%.3f (want x%.3f; %d against %d)"
					% [int(round(r2 * 100)), float(w2) / maxf(float(p2), 1.0), want2, w2, p2])
			print("    arcane at %+d%% resistance: plain %d, weakened %d, x%.3f (15 points: x%.3f)" % [
				int(round(r2 * 100)), p2, w2, float(w2) / maxf(float(p2), 1.0), want2])
	await _clear(s)
	# THE GLOSSARY ENTRY IS BACK, AND THE LINK TO IT.
	var entry: Dictionary = Glossary.entry("status_elem_weak")
	ok(not entry.is_empty() and not Glossary.is_retired("status_elem_weak"),
		"§2: the Elemental Weakness entry is not retired")
	var listed := false
	for e in Glossary.in_category(String(entry.get("category", ""))):
		if String(e.get("id", "")) == "status_elem_weak":
			listed = true
	ok(listed, "§2: ...the panel lists it")
	ok((Glossary.entry("resists_vulns").get("see_also", []) as Array).has("status_elem_weak"),
		"§2: ...and Resists & Vulnerabilities links it")
	ok(String(entry.get("long", "")).contains("Magic Burst")
			and Glossary.is_retired("status_decay"),
		"§2: ...it names the card that lays it, and the other GG retirement stands")


func _cast_at(s: Node, u: BattleUnit, ab: Ability, target: BattleUnit, weak: bool) -> int:
	_reset_foe(target)
	if weak:
		s._apply_elem_weak(target, s.ELEM_WEAK_PCT, s.ELEM_WEAK_TURNS, u)
	u.cooldowns.clear()
	u.resource = u.max_resource
	# THE SEED GOES AFTER THE WEAKNESS IS LAID: laying a status can draw from the
	# global dice, and a seed taken before it hands the two arms different rolls.
	seed(GN_SEED + 11)
	var before := target.hp
	await s._resolve(u, ab, target, "good")
	var dealt := before - target.hp
	_reset_foe(target)
	return dealt


# ── §3 — THE SPINE-TAKER ────────────────────────────────────────────────────
func _s3_the_spine_taker() -> void:
	print("--- GN §3: a spine taken at class selection, into the first battle ---")
	Profile.save_path = SCRATCH_PROFILE
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Relics.save_path = SCRATCH_RELICS
	var rf := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	rf.store_string("[]")
	rf.close()
	Relics.loaded = false
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	_run.specs_chosen = false
	_run.active = true
	var taken := {}
	for i in _run.party.size():
		var m: Dictionary = _run.party[i]
		var ck := String(m["key"])
		var offer: Array = []
		if SPINES.has(ck):
			offer.append(SPINES[ck])
		for pid in Classes.class_engines(ck):
			var rid := Runes.engine_rune_id(String(pid))
			if offer.size() < 3 and not offer.has(rid):
				offer.append(rid)
		m["engine_offer"] = offer
		taken[i] = SPINES.get(ck, offer[0])
	change_scene_to_file("res://scenes/spec_choice.tscn")
	await Gate.frames(self, 6)
	for i in _run.party.size():
		ok(Gate.scene_name(self) == "SpecChoice",
			"§3: class selection is on screen for hero %d (%s)" % [i, Gate.scene_name(self)])
		var btn: Button = Gate.bound_button(current_scene, "_choose", [i, taken[i]])
		ok(btn != null, "§3: hero %d's card for %s has a button to press" % [i, taken[i]])
		if btn == null:
			return
		btn.emit_signal("pressed")
		await Gate.frames(self, 4)
	var guard := 0
	while Gate.scene_name(self) != "Map" and guard < 600:
		await Gate.frames(self, 1)
		guard += 1
	ok(Gate.scene_name(self) == "Map", "§3: the map follows class selection (%s)" % Gate.scene_name(self))
	for i2 in _run.party.size():
		var m2: Dictionary = _run.party[i2]
		if SPINES.has(String(m2["key"])):
			ok(String(m2.get("spec", "?")) == "" and _run.engines_worn(m2) == 1,
				"§3: the %s took the spine and has no lineage" % m2["key"])
	# The first step onto a fight, through the node's own button.
	var entered := false
	for _step in 12:
		if Gate.scene_name(self) == "Battle":
			entered = true
			break
		if Gate.scene_name(self) != "Map":
			# A forge, a peddler or an event on the way: walk past it by its own
			# leave button (check_gj's list).
			Gate.press(current_scene, ["Leave the Shop", "Leave the forge", "Walk on",
				"Leave", "Onward", "Continue", "Depart"])
			await Gate.frames(self, 10)
			continue
		var open: Array = Gate.open_nodes(current_scene)
		var nxt: int = int(_run.slot_idx) + 1
		var fight_j := -1
		for j in open:
			if nxt < _run.map.size() and String(_run.map[nxt][j].get("type", "")) == "fight":
				fight_j = int(j)
				break
		if fight_j < 0 and not open.is_empty():
			fight_j = int(open[0])
		if fight_j < 0:
			break
		var nb: Button = Gate.bound_button(current_scene, "_on_node_pressed", [fight_j])
		if nb == null:
			break
		nb.emit_signal("pressed")
		await Gate.frames(self, 10)
	ok(entered, "§3: a fight is entered from the map (%s)" % Gate.scene_name(self))
	if entered:
		await Gate.frames(self, 30)
		var bs: Node = current_scene
		for h in bs.get("heroes"):
			if h.is_companion:
				continue
			var ck2: String = h.hero_key
			if not SPINES.has(ck2):
				continue
			var want: Array = [Classes.kit(ck2)[0].display_name] + Classes.class_kit_names(ck2)
			ok(_names(h.abilities) == want and h.abilities.size() == 4,
				"§3: the %s who took %s opens his first battle with four abilities, not one (%s)"
					% [ck2, SPINES[ck2], str(_names(h.abilities))])
			print("    first battle: the %s (%s) holds %s" % [ck2, SPINES[ck2], str(_names(h.abilities))])
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 4)
	_run.active = false


# ── §4 — THE BOT ────────────────────────────────────────────────────────────
func _s4_the_bot() -> void:
	print("--- GN §4: the bot casts the kit ---")
	var s: Node = await _no_lineage_board()
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var H := _hero(s, "hunter")
	var foes := _foes(s)
	for e in foes:
		_reset_foe(e)
	var picks := {}
	# WARRIOR: hurt -> Bloodlust; whole and nobody held -> Mocking Blow; a
	# held enemy and no Sunder -> Crushing Blow.
	# **BATCH GS §2 — MOCKING BLOW, THEN POMMEL STRIKE, THEN CRUSHING BLOW, AND
	# BLOODLUST HAS NO CASE** (it left the kit, and the Berserker's rotation casts
	# it). Nobody held -> the taunt, hurt or whole; every enemy held -> Pommel
	# Strike; every enemy held and the mark a boss not yet Broken, which would
	# resist the Stun -> Crushing Blow, at a mark with no Sunder. The hurt board
	# that named Bloodlust is kept, and asks the question its case left behind.
	_ready_to_cast(W)
	W.hp = int(W.max_hp * 0.4)
	var hurt_pick := _pick_name(s, W)
	ok(hurt_pick == "Mocking Blow",
		"§4: a hurt Warrior with nobody held is named the taunt — Bloodlust has no case in the class branch (named %s)" % hurt_pick)
	W.hp = W.max_hp
	picks["Mocking Blow"] = _pick_name(s, W)
	var w_idx: int = s.get("heroes").find(W)
	for e in foes:
		s._apply_status(e, "mocked", 4, w_idx, 0, W)
	picks["Pommel Strike"] = _pick_name(s, W)
	for e in foes:
		e.is_boss = true
	picks["Crushing Blow"] = _pick_name(s, W)
	for e in foes:
		e.is_boss = false
		_reset_foe(e)
	# MAGE: hurt and unwarded -> Nexus Ward; then Magic Burst at a fresh enemy;
	# every enemy weakened -> Magic Missiles.
	_ready_to_cast(M)
	M.hp = int(M.max_hp * 0.5)
	picks["Nexus Ward"] = _pick_name(s, M)
	M.hp = M.max_hp
	s._apply_status(M, "barrier", 3, 10)
	var burst_pick: Array = s._bot_class_kit_pick(M)
	picks["Magic Burst"] = burst_pick[0].display_name if not burst_pick.is_empty() else ""
	var hp_top: BattleUnit = foes[0]
	for e in foes:
		if e.hp > hp_top.hp:
			hp_top = e
	ok(burst_pick.size() == 2 and not (burst_pick[1] as BattleUnit).has_status("elem_weak"),
		"§4: Magic Burst is aimed at an enemy not already weakened")
	for e in foes:
		s._apply_elem_weak(e, 15, 3, M)
	picks["Magic Missiles"] = _pick_name(s, M)
	M.remove_status("barrier")
	for e in foes:
		_reset_foe(e)
	# CLERIC: a hero under half -> Ministration; an afflicted hero -> Unburden;
	# two hurt and no blessing -> Consecration.
	_ready_to_cast(C)
	W.hp = int(W.max_hp * 0.3)
	picks["Ministration"] = _pick_name(s, C)
	W.hp = W.max_hp
	s._apply_status(H, "cripple", 3, 0, 0, foes[0])
	picks["Unburden"] = _pick_name(s, C)
	H.remove_status("cripple")
	W.hp = int(W.max_hp * 0.7)
	M.hp = int(M.max_hp * 0.7)
	picks["Consecration"] = _pick_name(s, C)
	W.hp = W.max_hp
	M.hp = M.max_hp
	# HUNTER: no companion standing -> Summon Companion (named by the call it
	# casts); a companion standing -> Snare Trap; a snared mark -> Powershot.
	# **RE-POINTED BY BATCH HB**: Summon Companion took Tripwire's kit slot and
	# its case took Tripwire's place at the head of the class branch. Tripwire is
	# a drafted card; the drafted hook's arm for it is below.
	_ready_to_cast(H)
	var pet_pick: String = _pick_name(s, H)
	picks[Classes.PET_CARD] = Classes.PET_CARD if pet_pick.begins_with("Summon ") \
		and Classes.COMPANION_KINDS.has(pet_pick.get_slice(" ", 1).to_lower()) else pet_pick
	await s._do_summon(H, "canis", H)
	picks["Snare Trap"] = _pick_name(s, H)
	var mark: BattleUnit = s._lowest_hp(foes)
	s._apply_status(mark, "snared", -1, s.get("heroes").find(H), 0, H)
	picks["Powershot"] = _pick_name(s, H)
	print("    class branch picks: %s" % str(picks))
	for card in picks:
		ok(String(picks[card]) == String(card),
			"§4: on a board it has work on, the class branch names %s (named %s)" % [card, picks[card]])
	# TRIPWIRE, DRAFTED (BATCH HB §2): the drafted hook names it for a Hunter who
	# carries it, with a melee enemy standing and no wire rigged — and not with
	# the wire already rigged, the negative arm beside it.
	var wire_ab: Ability = Classes.pool_ability("Tripwire")
	H.abilities.append(wire_ab)
	_ready_to_cast(H)
	H.remove_status("tripwire")
	var dp: Array = s._bot_drafted_pick(H)
	var wire_named: bool = not dp.is_empty() and (dp[0] as Ability).display_name == "Tripwire"
	s._apply_status(H, "tripwire", 6)
	var dp2: Array = s._bot_drafted_pick(H)
	var wire_again: bool = not dp2.is_empty() and (dp2[0] as Ability).display_name == "Tripwire"
	H.abilities.erase(wire_ab)
	ok(wire_named and not wire_again,
		"§4: the drafted hook names a drafted Tripwire with a melee enemy standing, and not with the wire rigged (%s, %s)"
			% [wire_named, wire_again])
	# A NEGATIVE ARM: a card with nothing to do is not named.
	for e in foes:
		_reset_foe(e)
	H.remove_status("tripwire")
	_ready_to_cast(C)
	var idle: String = _pick_name(s, C)
	ok(idle == "", "§4: a Cleric with nobody hurt or afflicted casts no kit card (named %s)" % idle)
	# THE DRAFTED HOOK LEAVES THE KIT TO THE CLASS BRANCH.
	ok(s._bot_drafted_pick(M).is_empty() or not Classes.class_kit_holds("mage",
			(s._bot_drafted_pick(M)[0] as Ability).display_name),
		"§4: the drafted hook never names a kit card")
	await _clear(s)
	# A LIVE STRETCH: the real loop on autoplay, every hero on half health and
	# afflicted now and then, and every kit card seen cast (its cooldown starts).
	var s2: Node = await _no_lineage_board()
	var heroes: Array = s2.get("heroes").filter(func(h): return not h.is_companion)
	for e in _foes(s2):
		_reset_foe(e)
	var seen := {}
	# The fixture parks the first hero's turn awaiting a pick. It is answered by
	# hand BEFORE the bot takes over, so the turn resumes with its target in
	# hand; answered after, the resumed turn reads the bot's target, which was
	# never set, and falls back with a warning.
	var parked: BattleUnit = s2.get("current_hero")
	if parked != null:
		s2.emit_signal("_ability_picked", parked.abilities[0])
		await process_frame
		var foe0: BattleUnit = _foes(s2)[0]
		s2.emit_signal("_target_picked", foe0)
	s2.set("autoplay", true)
	var frames := 0
	while frames < FRAME_CAP * 2 and seen.size() < 12:
		Engine.time_scale = 100.0
		await process_frame
		frames += 1
		for h in heroes:
			if h.hp > int(h.max_hp * 0.45):
				h.hp = int(h.max_hp * 0.45)
			if frames % 40 == 0 and not h.has_status("cripple"):
				s2._apply_status(h, "cripple", 2, 0, 0, _foes(s2)[0])
			for n in Classes.class_kit_names(h.hero_key):
				if int(h.cooldowns.get(n, 0)) > 0:
					seen[n] = true
				# BATCH HB — Summon Companion is cast as one of its three calls,
				# and the cooldown is kept under the call's name.
				if String(n) == Classes.PET_CARD:
					for k in Classes.COMPANION_KINDS:
						if int(h.cooldowns.get("Summon " + String(k).capitalize(), 0)) > 0:
							seen[n] = true
		for e in _foes(s2):
			if e.hp < 50000:
				e.hp = e.max_hp
		if bool(s2.get("battle_over")):
			break
	Engine.time_scale = 1.0
	s2.set("autoplay", false)
	var missing: Array = []
	for ck in CLASS_SEATS:
		for n in Classes.class_kit_names(ck):
			if not seen.has(n):
				missing.append(n)
	ok(missing.is_empty(), "§4: a live autoplay stretch casts all twelve (%d frames; never cast: %s)"
		% [frames, str(missing)])
	print("    live stretch: %d of 12 kit cards cast in %d frames" % [seen.size(), frames])
	await _clear(s2)


func _pick_name(s: Node, u: BattleUnit) -> String:
	u.cooldowns.clear()
	var p: Array = s._bot_class_kit_pick(u)
	return "" if p.is_empty() else String((p[0] as Ability).display_name)


# ── §5 — THE PLAYER'S FILES ─────────────────────────────────────────────────
func _s5_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§5: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§5: %s is byte for byte what it was" % p)
