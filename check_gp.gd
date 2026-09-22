# BATCH GP — THE POOLS MERGE.
#
#   §0  THE POOL — one pool a class, DERIVED off the three lineage shelves and
#       the class-wide shelf; the four depths; the class-wide cards dissolved
#       into it; the shelves themselves returning what they always returned
#   §1  THE DRAW READS THE POOL — `Run.draft_pool_left` is ONE list keyed to the
#       CLASS; three lineages of a class are offered one pool; a hero who took a
#       spine draws the whole of it; the one-in-four seam is gone from the source
#   §2  THE ENGINE GATE, DRIVEN BOTH WAYS — every row of `Classes.ENGINE_READ`
#       cast on a hero holding NO engine and on one holding it with the engine's
#       own state built through the game's doors; the gate at the offer door in
#       both directions; and how much of his pool a hero with no engine can be
#       offered, per class. §2e: the two RULED rows (HD §1), whose premise is that
#       they still work in part without the engine
#   §3  THE ZONE-BOSS FALLBACK — two tiers now, not three; the second reads the
#       class pool and honours the same gate
#   §4  A WHOLE RUN, DRAFTING THROUGHOUT — one on a party holding NO engine and
#       one on a party holding TWO apiece, on the real screens, and the offers a
#       no-engine hero actually received, BY NAME
#   §5  THE PLAYER'S FILES — as this gate found them
#
# ── WHY IT DRIVES ────────────────────────────────────────────────────────────
# **THE GATE IN §2 IS THE BATCH.** A wide pool is only worth having if what it
# widens is playable, and a hero offered a card he cannot use is the failure the
# merge would otherwise introduce — three times over, because the pool is three
# times deeper. **A STATIC CHECK CANNOT SEE AN OFFER**, and a field-level test
# cannot see whether a card works: CN found 137 abilities such a test misjudges
# because they resolve inside a special handler. So every row of the table is
# CAST, on a board dressed so a no-op can only be the engine's fault, and the
# arm that proves the table is not merely a list of cards that do nothing is the
# SECOND one — the same card, the same board, with the engine held.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM.** "A no-engine hero is never
# offered these 33" beside "a holder is offered his"; "the class-wide cards have
# no tier of their own" beside "every one of them is in the pool"; "the shelves
# are no longer drawn from" beside "each still returns exactly what it held".
#
# ── THE PLAYER'S FILES ───────────────────────────────────────────────────────
# `Run` writes its harness path under `--script` (FI); `Profile` and `Relics` are
# pointed at scratch files of this gate's own before §4 takes a step, because a
# run writes both. §5 reads the player's three files byte for byte.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gp.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const NO_LINEAGE := ["", "", "", ""]
const CLASS_SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://gp_profile.json"
const SCRATCH_RELICS := "user://gp_relics.json"
const ROAD_SEED := 20260917
const MAX_STEPS := 900
const FRAME_CAP := 30000

var _g := Gate.new()
var _run: Node = null
var _player := {}

# §4's road, per arm.
var _maps_read := 0
var _battles := 0
var _dead: Array = []
var _offers: Dictionary = {}     # hero key -> every card offered, by name
# BATCH GS — §4's no-engine arm, kept one (`_unslot_engines`): whether this road
# is that arm, how many slotted engines it set aside, and any member found
# holding one where a draft is rolled.
var _keep_bare := false
var _set_aside := 0
var _engined: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GP — THE POOLS MERGE")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_s0_the_pool()
	await _s1_the_draw()
	await _s2_the_engine_gate()
	_s3_the_fallback()
	await _s4_the_road()
	_s5_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _no_lineage_board() -> Node:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": []}
	return await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})


func _clear(s: Node) -> void:
	s.queue_free()
	for _i in 4:
		await process_frame


# The whole board, as a value, so "did this cast do anything" is a comparison
# and not a judgement. Indexed rather than named: two enemies of one name would
# otherwise collapse into one key and hide a change (found while writing this).
func _snap(s: Node) -> Dictionary:
	var d := {}
	var hs: Array = s.get("heroes")
	for i in hs.size():
		var h: BattleUnit = hs[i]
		d["H%d|hp" % i] = h.hp
		d["H%d|sr" % i] = h.second_resource
		d["H%d|faith" % i] = h.faith_stacks
		d["H%d|res" % i] = h.resource
		d["H%d|st" % i] = h.statuses.map(func(x): return "%s:%s" % [x.id, x.get("power", 0)])
	var es: Array = s.get("enemies")
	for j in es.size():
		var e: BattleUnit = es[j]
		d["E%d|hp" % j] = e.hp
		d["E%d|pr" % j] = e.pressure
		d["E%d|st" % j] = e.statuses.map(func(x): return "%s:%s" % [x.id, x.get("power", 0)])
	d["#beasts"] = hs.filter(func(u): return u.is_companion).size()
	d["#holds"] = s.get("_holds").size()
	return d


func _changed(a: Dictionary, b: Dictionary) -> Array:
	var out: Array = []
	for k in b:
		if str(a.get(k, "")) != str(b[k]):
			out.append(String(k))
	return out


# ── §0 — THE POOL ───────────────────────────────────────────────────────────

func _s0_the_pool() -> void:
	print("\n§0 — one pool a class, derived")
	var depths: Array = []
	var pool_total := 0
	var shelf_total := 0
	for cls in CLASS_SEATS:
		var pool: Array = Classes.draft_pool(cls)
		depths.append("%s %d" % [cls, pool.size()])
		pool_total += pool.size()
		# THE POOL IS THE SHELVES AND NOTHING ELSE — derived here rather than
		# compared against a number written twice.
		var want: Array = []
		for spec in Classes.SPEC_IDS[cls]:
			want.append_array(Classes.spec_draft_pool(String(spec)))
		want.append_array(Classes.class_draft_pool(cls))
		shelf_total += want.size()
		ok(pool == want,
			"§0: the %s pool is not its three lineage shelves plus its class-wide shelf, in order" % cls)
		# NO CARD IS IN IT TWICE — the merge must not deal one name from two
		# shelves, which is the one thing joining four lists can quietly do.
		var seen := {}
		var dupes: Array = []
		for n in pool:
			if seen.has(n):
				dupes.append(n)
			seen[n] = true
		ok(dupes.is_empty(), "§0: the %s pool holds a name twice — %s" % [cls, dupes])
		# THE CLASS-WIDE CARDS DISSOLVED INTO IT: the positive arm beside §1's
		# "they have no tier of their own".
		for n2 in Classes.class_draft_pool(cls):
			ok(pool.has(String(n2)),
				"§0: %s left the %s pool when the class-wide shelf dissolved" % [n2, cls])
		# A DEPTH FLOOR, NOT A PIN. The merge's point is that a hero draws from
		# far more than a shelf; the floor is well under every measured depth so
		# ordinary authoring moves it without a red, and a pool COLLAPSING trips.
		ok(pool.size() >= 30,
			"§0: the %s pool has fallen to %d, below the 30 the merge floors at" % [cls, pool.size()])
	print("    depths: %s" % ", ".join(depths))
	ok(pool_total == shelf_total,
		"§0: the four pools hold %d entries against the shelves' %d" % [pool_total, shelf_total])
	# THE SHELVES STILL HOLD WHAT THEY HELD. `spec_draft_pool` is a shelf now and
	# not a pool, and the thing that must stay true of it is that it did not
	# quietly become the pool.
	for spec in Classes.SPEC_DRAFT_POOLS:
		var shelf: Array = Classes.spec_draft_pool(String(spec))
		ok(shelf == Classes.SPEC_DRAFT_POOLS[spec],
			"§0: the %s shelf no longer returns its own dict entry" % spec)
		ok(shelf.size() < Classes.draft_pool(Classes.class_of_spec(String(spec))).size(),
			"§0: the %s shelf is as deep as its class pool — the merge did not happen" % spec)


# ── §1 — THE DRAW ───────────────────────────────────────────────────────────

func _s1_the_draw() -> void:
	print("\n§1 — the draw reads the pool")
	_run.sim_run = false
	_run.new_run(CLASS_SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["engines"] = []
	_run.specs_chosen = true
	# ONE LIST, NOT TWO SIDES. The type is the assertion: a caller reading
	# `["spec"]` is reading a structure that no longer describes the draft.
	var left: Variant = _run.draft_pool_left(_run.party[0])
	ok(left is Array, "§1: `draft_pool_left` no longer returns one list (got %s)" % type_string(typeof(left)))
	# THREE LINEAGES OF A CLASS SEE ONE POOL — the merge, stated as the thing a
	# player would notice. Every hero's engines are emptied so the §2 gate takes
	# the same 33 out of each, which is what makes the three comparable.
	for cls in CLASS_SEATS:
		var idx := CLASS_SEATS.find(cls)
		var seen: Array = []
		for spec in Classes.SPEC_IDS[cls]:
			_run.party[idx]["spec"] = String(spec)
			_run.party[idx]["bm_abilities"] = []
			_run.party[idx]["bm_equipped"] = []
			_run.party[idx]["draft_refused"] = []
			var l: Array = _run.draft_pool_left(_run.party[idx])
			l.sort()
			seen.append(l)
		ok(seen[0] == seen[1] and seen[1] == seen[2],
			"§1: the three %s lineages are offered different pools — the merge is keyed to the lineage" % cls)
		# AND A SPINE-TAKER DRAWS THE SAME ONE. Before the merge he drew his
		# class-wide shelf alone — three cards, for the Cleric.
		_run.party[idx]["spec"] = ""
		var spine: Array = _run.draft_pool_left(_run.party[idx])
		spine.sort()
		ok(spine == seen[0],
			"§1: a %s who took a spine draws %d cards against a lineage hero's %d" % [
				cls, spine.size(), seen[0].size()])
		ok(spine.size() > Classes.class_draft_pool(cls).size(),
			"§1: a %s spine-taker draws %d — no more than the class-wide shelf he drew before" % [
				cls, spine.size()])
	# A MEMBER NOT YET AWAKENED DRAFTS NOTHING (the negative arm of the above).
	_run.party[0]["spec"] = ""
	_run.party[0]["awakened"] = false
	ok((_run.draft_pool_left(_run.party[0]) as Array).is_empty(),
		"§1: a member who has not been through class selection is offered cards")
	_run.party[0]["awakened"] = true
	# THE ONE-IN-FOUR SEAM IS GONE FROM THE SOURCE, not merely unused.
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	var cs := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var rs_code := Gate.strip_comments(rs)
	var cs_code := Gate.strip_comments(cs)
	ok(not rs_code.contains("draft_card_is_class"),
		"§1: `draft_card_is_class` still has code in `run_state.gd` — the class-wide seam survived the merge")
	ok(not cs_code.contains("CLASS_DRAFT_SHARE"),
		"§1: `CLASS_DRAFT_SHARE` still has code in `classes.gd`")
	ok(not rs_code.contains("roll_class_fallback_offer"),
		"§1: `roll_class_fallback_offer` still has code — the third tier survived the merge")
	# AND THE DRAW READS THE POOL AND NOT A SHELF. The positive arm: it names
	# `Classes.draft_pool`; the negative: neither shelf accessor is in it.
	var bodies: Dictionary = Gate.returning_bodies(rs)
	var dpl := String(bodies.get("draft_pool_left", ""))
	ok(dpl.contains("Classes.draft_pool("),
		"§1: `draft_pool_left` no longer reads `Classes.draft_pool`")
	ok(not dpl.contains("spec_draft_pool") and not dpl.contains("class_draft_pool"),
		"§1: `draft_pool_left` still reads a SHELF — a hero's lineage decides part of his draw again")
	ok(dpl.contains("Classes.offerable("),
		"§1: `draft_pool_left` no longer asks the engine gate")


# ── §2 — THE ENGINE GATE ────────────────────────────────────────────────────

# The state an engine itself makes, built through the game's own doors so the
# HELD arm is the engine working rather than a field this gate wrote.
# BATCH GS — `card` is the row being driven, for the one engine whose state a
# card needs more of than the others do (Death Ray, below).
func _arm_engine(s: Node, u: BattleUnit, eng: String, card := "") -> void:
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	match eng:
		"resonance":
			# BATCH GS — THE METER AS `_spawn_units` INSTALLS IT FOR A HOLDER, THEN
			# THE STACKS THROUGH `_gain_resonance`, THE DOOR EVERY SOURCE COMES
			# THROUGH. Runaway Resonance has no ceiling (`second_max` 99, Batch AT);
			# the 5 written here held the new DEATH RAY row — refused below
			# `DEATH_RAY_STACKS` — dark on the held arm as well, so the pair read
			# identical. Death Ray's arm is built to its line; every other row
			# reads any stack at all and keeps the three it always had.
			u.second_resource_name = "Resonance"
			u.second_max = 99
			u.second_resource = 0
			s._gain_resonance(u, int(s.DEATH_RAY_STACKS) if card == "Death Ray" else 3)
		"mercy":
			u.second_resource_name = "Mercy"
			u.second_max = 5
			u.second_resource = 3
		"lethal_aim":
			u.second_resource_name = "Focus"
			u.second_max = -1
			u.second_resource = 120
		"permafrost":
			s._hold_freeze(foes[0], u)
		"old_gods":
			s._gain_ruin(foes[0], 3)
			if foes.size() > 1:
				s._gain_ruin(foes[1], 3)
		"conviction":
			for h in s.get("heroes"):
				if not h.is_companion:
					s._gain_faith(h, 5, "gp")
			s._grant_divine_shield(u, u, 40)
		"pack":
			var cw: Ability = Classes.pool_ability("Call the Wilds")
			if cw != null:
				u.resource = 99999
				await s._resolve(u, cw, foes[0], "good")
			for b in s._beasts(u):
				s._gain_loyalty(u, String(b.companion_kind), 4)
		"heavy_plating":
			u.block_chance = 0.0
			u.plating_bonus = 0.24


# A board dressed so that a cast doing nothing can only be the engine's fault.
func _dress(s: Node, caster: BattleUnit) -> void:
	for e in s.get("enemies"):
		if e.dead:
			continue
		e.max_hp = 100000
		e.hp = int(e.max_hp * 0.5)
		e.pressure = 30
		for st in e.statuses.duplicate():
			e.remove_status(String(st.id))
		s._apply_status(e, "burn", 5, 12, 0, caster)
		s._apply_status(e, "chilled", 5, 0, 0, caster)
		s._apply_status(e, "poison", 5, 12, 0, caster)
	for h in s.get("heroes"):
		if h.is_companion:
			continue
		h.hp = maxi(int(h.max_hp * 0.5), 1)
		h.resource = 99999
		h.max_resource = 99999
		h.cooldowns.clear()


# THE THREE ROWS A BOARD TEST CANNOT SEE, and naming them here is the point:
# each lands its status in BOTH arms and changes nothing else, because what it
# buys is arithmetic on a LATER strike. They are driven in §2c as damage pairs
# instead, and they are excluded from §2's delta test rather than quietly
# passing it.
const LATER_STRIKE := ["Anvil", "Recompense", "Unslaked"]

# AND THREE WHOSE PAYOUT WAITS ON AN EVENT THAT MAY NEVER COME — a lethal blow,
# a companion falling, a companion swapped out. Each lands its status and says
# the same words on both arms, because what the engine decides is whether the
# event PAYS when it arrives. §2d drives the event instead of the cast.
const LATER_EVENT := ["Intercession", "Last Howl", "Succession"]


# A card cast on one arm's board: what the door said, what moved, what was said.
func _cast(s: Node, u: BattleUnit, card: String) -> Dictionary:
	var ab: Ability = Classes.pool_ability(card)
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	if ab == null or foes.is_empty():
		return {}
	u.resource = 99999
	u.max_resource = 99999
	u.cooldowns.clear()
	var target: BattleUnit = u if ab.target == Ability.Target.ALLY else foes[0]
	# BATCH GS — RESURRECTION TARGETS THE FALLEN, as the battle's own targeting does
	# for it (`ab.special == "resurrection"` picks among the dead): cast at its
	# caster it would spend its Mercy and raise nobody. `_stage` fells one.
	if ab.special == "resurrection":
		for h in s.get("heroes"):
			if h.dead and not h.is_companion:
				target = h
				break
	var before := _snap(s)
	var log_was := String(s.get("history").get_parsed_text())
	var usable := bool(s._ability_usable(u, ab))
	if usable:
		await s._resolve(u, ab, target, "good")
	var said := String(s.get("history").get_parsed_text()).substr(log_was.length())
	return {"usable": usable, "moved": _changed(before, _snap(s)),
		"said": said.strip_edges()}


# One arm: the board built, the engine armed or not, and every card of the group
# cast on it. THE SEED IS RE-LAID PER CARD so the two arms roll the same dice.
func _arm(eng: String, cards: Array, hold: bool) -> Dictionary:
	var out := {}
	var cls := Classes.engine_class(eng)
	for card in cards:
		var s: Node = await _no_lineage_board()
		var u: BattleUnit = _hero(s, cls)
		if u == null:
			await _clear(s)
			continue
		for h in s.get("heroes"):
			h.engines = []
		# **DRESSED FIRST, ARMED SECOND, AND THE ORDER IS LOAD-BEARING.**
		# `_dress` strips every status off the enemies, so dressing AFTER arming
		# wiped the hold Permafrost had just laid and the Ruin the Old Gods had
		# just marked — and three rows read "does nothing with the engine" for
		# no reason but this.
		_dress(s, u)
		# BATCH GS — THE BOARD A CARD NEEDS, ON BOTH ARMS, BEFORE THE ENGINE IS.
		await _stage(s, u, String(card))
		if hold:
			u.engines = [eng]
			await _arm_engine(s, u, eng, String(card))
		seed(20260917)
		out[card] = await _cast(s, u, String(card))
		await _clear(s)
	return out


# **BATCH GS — THE BOARD A ROW NEEDS ON BOTH ARMS.** Resurrection is refused while
# no hero is down, with its engine or without it, so a board with nobody fallen
# reads the pair identical whatever Mercy does. Both arms therefore stand the
# same fallen hero before the cast — the Warrior, felled by a real enemy blow
# (§2d's idiom), never the caster — and what separates them is then the Mercy
# the card is priced in, which is the row's claim. Every other row: untouched.
func _stage(s: Node, u: BattleUnit, card: String) -> void:
	if card != "Resurrection":
		return
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	var w: BattleUnit = _hero(s, "warrior")
	if w == null or w == u or foes.is_empty():
		ok(false, "§2: the Resurrection board has no Warrior to fell — the pair cannot be read")
		return
	w.hp = 1
	var foe: BattleUnit = foes[0]
	var atk_was := foe.attack
	foe.attack = 9999
	foe.resource = 99999
	foe.cooldowns.clear()
	await s._resolve(foe, foe.abilities[0], w, "good")
	foe.attack = atk_was
	if not w.dead:
		ok(false, "§2: the Resurrection board stands no fallen hero — the pair cannot be read")


func _same(a: Dictionary, b: Dictionary) -> bool:
	return bool(a.get("usable", false)) == bool(b.get("usable", false)) \
		and str(a.get("moved", [])) == str(b.get("moved", [])) \
		and String(a.get("said", "")) == String(b.get("said", ""))


func _s2_the_engine_gate() -> void:
	print("\n§2 — the engine gate, driven both ways")
	var by_engine := {}
	# **BATCH HD §1 — TWO ROWS ARE RULINGS, AND THIS PAIR TEST IS NOT THEIRS.**
	# Guard Change and Lunge carry `ruled` (the designer's, HD §1): each HALF-WORKS
	# without the Stances, so the claim this test makes of a row — the card reads
	# its engine and moves nothing without it — is not their claim, and reading
	# them here would call the ruling a mistake. They are driven as rulings in
	# §2e instead, and §2b below asks their offer both ways like every other row.
	var ruled_rows: Array = []
	for card in Classes.ENGINE_READ:
		if LATER_STRIKE.has(String(card)) or LATER_EVENT.has(String(card)):
			continue
		if Classes.engine_read_ruled(String(card)) != "":
			ruled_rows.append(String(card))
			continue
		var eng := String(Classes.ENGINE_READ[card]["engine"])
		by_engine[eng] = by_engine.get(eng, []) + [String(card)]
	ok(by_engine.size() >= 6,
		"§2: the table names %d engines — a table this narrow has stopped covering the pool" % by_engine.size())

	# **THE CLAIM IS "THIS CARD READS THAT ENGINE", AND THE TEST IS THE PAIR.**
	# One board, one seed, the card cast twice — once on a hero holding the
	# engine and once on a hero holding nothing. If the two arms are identical
	# the card does not read it and the row is wrong. Reading the arms apart
	# rather than asking "did the board move" is what catches the cards that
	# LAND something and PAY nothing: Null Field stamps its status either way
	# and says *-0%* on one arm and *-25%* on the other.
	var driven := 0
	var refused := 0
	for eng in by_engine:
		var bare: Dictionary = await _arm(String(eng), by_engine[eng], false)
		var held: Dictionary = await _arm(String(eng), by_engine[eng], true)
		for card in by_engine[eng]:
			var b: Dictionary = bare.get(card, {})
			var h: Dictionary = held.get(card, {})
			if b.is_empty() or h.is_empty():
				ok(false, "§2: %s could not be cast on either arm" % card)
				continue
			driven += 1
			ok(not _same(b, h),
				"§2: %s does exactly the same thing with %s and without it — the row is wrong" % [card, eng])
			if not bool(b.get("usable", false)):
				refused += 1
			# THE EVIDENCE, PRINTED: what the card said to a hero who holds
			# nothing. The report quotes these rather than asserting on the
			# wording, which is the batch's own text and would pin it.
			var said := String(b.get("said", "")).replace("\n", " / ")
			print("      %-26s %s" % [card,
				"REFUSED at the door" if not bool(b.get("usable", false)) \
					else said.substr(0, 96)])
	print("    %d rows driven on both arms; %d are refused outright without the engine" % [driven, refused])
	ok(driven >= 25, "§2: only %d rows were driven" % driven)

	# ── THE CONTROL, AND IT IS THE ARM THAT MAKES §2 MEAN ANYTHING ─────────
	# The pair test would pass a table that listed every card in the game if
	# holding an engine changed every cast. It does not: these read no engine,
	# they are cast on the same two arms, and each must come back IDENTICAL.
	# **A CONTROL CARD MAY NOT BE ONE THE ENGINE BUFFS IN PASSING**, which is the
	# trap this arm walked into first: Chastise came back DIFFERENT under
	# Conviction, and rightly — Faith stacks raise the damage of every cast, so
	# a damage card under a damage engine separates without reading anything.
	# That is the engine reading the CARD, which §2's whole point is to tell
	# apart from the card reading the engine. So each control is a card the
	# engine beside it cannot touch.
	var control := {"Cleave": "heavy_plating", "Mirror Image": "resonance",
		"Undying Vigil": "conviction", "Exhortation": "mercy",
		"Camouflage": "pack", "Blink": "permafrost"}
	var flat := 0
	for card in control:
		var eng2 := String(control[card])
		var cb: Dictionary = await _arm(eng2, [String(card)], false)
		var ch: Dictionary = await _arm(eng2, [String(card)], true)
		ok(Classes.engine_read(String(card)) == "",
			"§2 control: %s is in the table — it is no longer a control" % card)
		if _same(cb.get(card, {}), ch.get(card, {})):
			flat += 1
		else:
			ok(false, "§2 control: %s reads %s after all — the table is missing a row" % [card, eng2])
	print("    control: %d of %d engine-free cards cast identically on both arms" % [flat, control.size()])

	await _s2c_the_later_strike()
	await _s2d_the_later_event()
	await _s2e_the_ruled_rows(ruled_rows)

	# ── §2b — THE GATE AT THE OFFER DOOR, IN BOTH DIRECTIONS ───────────────
	_run.sim_run = false
	_run.new_run(CLASS_SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
	_run.specs_chosen = true
	var reach: Array = []
	for cls in CLASS_SEATS:
		var idx := CLASS_SEATS.find(cls)
		var m: Dictionary = _run.party[idx]
		var bare: Array = _run.draft_pool_left(m)
		var pool: Array = Classes.draft_pool(cls)
		reach.append("%s %d of %d" % [cls, bare.size(), pool.size()])
		for card in pool:
			var eng := Classes.engine_read(String(card))
			if eng == "":
				ok(bare.has(String(card)),
					"§2b: %s reads no engine and is not offered to a %s holding none" % [card, cls])
			else:
				ok(not bare.has(String(card)),
					"§2b: %s reads %s and is offered to a %s holding no engine" % [card, eng, cls])
		# THE POSITIVE ARM: hold the engine and its cards come back.
		for eng2 in Classes.class_engines(cls):
			var rows: Array = pool.filter(func(n): return Classes.engine_read(String(n)) == String(eng2))
			if rows.is_empty():
				continue
			m["engines"] = [{"engine": String(eng2), "equipped": true}]
			var held: Array = _run.draft_pool_left(m)
			for r in rows:
				ok(held.has(String(r)),
					"§2b: a %s holding %s is still not offered %s" % [cls, eng2, r])
			m["engines"] = []
	print("    a hero holding no engine can be offered: %s" % ", ".join(reach))



# ── §2e — THE RULED ROWS (BATCH HD §1) ──────────────────────────────────────
#
# **A RULED ROW IS GATED BY THE DESIGNER, NOT BY WHAT A CAST SHOWS**, and what
# this section asserts is the premise that makes it a ruling rather than a
# finding: without its engine the card is still usable and still does something.
# The day one of them is refused, or does nothing, without the engine, the cast
# test would have found it and `ruled` is no longer the reason it is gated — this
# goes red saying so. What each keeps without the engine is PRINTED, as the
# record of why the ruling was needed. The offer is §2b's, both ways.
func _s2e_the_ruled_rows(ruled_rows: Array) -> void:
	print("\n§2e — the ruled rows: gated by ruling, and each still works in part without its engine")
	ok(not ruled_rows.is_empty(), "§2e: no row of the card gate carries `ruled` — HD §1's two are gone")
	for card in ruled_rows:
		var eng := String(Classes.ENGINE_READ[card]["engine"])
		var bare: Dictionary = await _arm(eng, [String(card)], false)
		var b: Dictionary = bare.get(card, {})
		ok(bool(b.get("usable", false)) and not (b.get("moved", []) as Array).is_empty(),
			"§2e: %s is refused, or moves nothing, without %s — the cast test finds it now, and `ruled` is not why it is gated" % [card, eng])
		print("      %-14s ruled `%s`; without %s it still moves %s" % [card,
			Classes.engine_read_ruled(String(card)), eng, str(b.get("moved", []))])


# ── §2c — THE THREE WHOSE PAYOUT IS A LATER STRIKE ──────────────────────────
#
# **A TWO-ARMED CONTROL, IN THE DIRECTION THE CARD CHANGES.** Each of these
# three lands a status and moves nothing else, with the engine and without, so
# "did the board change" reads the same on both arms and would pass a card that
# does nothing. What it buys is the arithmetic of a blow that has not happened
# yet, so each is driven as a PAIR of blows — with the card and without it —
# once on a hero holding the engine and once on a hero holding none. The row is
# right only if the pair separates WITH the engine and does not separate
# without it, which is both arms of the claim.

# The damage one seeded Strike deals, with `card` standing or not.
func _strike_with(s: Node, u: BattleUnit, foe: BattleUnit, card: String) -> int:
	u.remove_status("unslaked")
	u.frenzy_floor = 0.0
	u.resource = 99999
	u.cooldowns.clear()
	if card != "":
		var ab: Ability = Classes.pool_ability(card)
		if ab != null:
			await s._resolve(u, ab, u, "good")
	# THE DIVE, THEN BACK TO FULL: the floor is what the card changes, and the
	# floor only pays once the live bonus has fallen below it.
	u.hp = maxi(int(u.max_hp * 0.2), 1)
	u.frenzy_bonus()
	u.hp = u.max_hp
	u.remove_status("unslaked")
	foe.max_hp = 100000
	foe.hp = foe.max_hp
	# **RAGE IS ZEROED BEFORE THE MEASURED BLOW, AND THIS LINE IS THE ARM.**
	# `frenzy_bonus()` sums a HEALTH term and a RAGE term and clamps the sum, so
	# a Warrior left holding 99999 Rage stands at the cap in both arms and the
	# floor — the only thing the card moves — is invisible under it. The first
	# draft of this drive read 24 against 24 for exactly that reason.
	u.resource = 0
	u.cooldowns.clear()
	seed(4242)
	var was := foe.hp
	await s._resolve(u, u.abilities[0], foe, "good")
	return was - foe.hp


func _unslaked_arm(hold: bool) -> void:
	var s: Node = await _no_lineage_board()
	var u: BattleUnit = _hero(s, "warrior")
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	if u == null or foes.is_empty():
		ok(false, "§2c: no Warrior and a foe for the Unslaked pair")
		await _clear(s)
		return
	for h in s.get("heroes"):
		h.engines = []
	if hold:
		u.engines = ["bloodrage"]
	var without: int = await _strike_with(s, u, foes[0], "")
	var with_it: int = await _strike_with(s, u, foes[0], "Unslaked")
	print("    [Unslaked, %s] a Strike after a dive: %d without the card, %d with it"
		% ["bloodrage held" if hold else "no engine", without, with_it])
	if hold:
		ok(with_it > without,
			"§2c: Unslaked bought nothing for a Warrior holding Blood Frenzy (%d against %d)" % [with_it, without])
	else:
		ok(with_it == without,
			"§2c: Unslaked moved a Strike for a Warrior holding NO engine (%d against %d) — it does not belong in the table" % [with_it, without])
	await _clear(s)


# A blow that LANDS on the Warrior, so the plating block is entered. Returns
# what his Rage and his plating climb did.
func _plating_arm(hold: bool, card: String) -> Dictionary:
	var s: Node = await _no_lineage_board()
	var u: BattleUnit = _hero(s, "warrior")
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	if u == null or foes.is_empty():
		ok(false, "§2c: no Warrior and a foe for the %s pair" % card)
		await _clear(s)
		return {}
	for h in s.get("heroes"):
		h.engines = []
	if hold:
		u.engines = ["heavy_plating"]
	u.resource = 0
	u.max_resource = 100
	u.cooldowns.clear()
	if card != "":
		var ab: Ability = Classes.pool_ability(card)
		if ab != null:
			u.resource = 99999
			await s._resolve(u, ab, u, "good")
	u.resource = 0
	# A CLIMB TO RESET AND A BLOCK TO RESET IT. The block is forced rather than
	# rolled: what is under test is the branch a block enters, not the odds.
	u.plating_bonus = 0.24
	u.block_chance = 1.0
	u.hp = u.max_hp
	var foe: BattleUnit = foes[0]
	foe.resource = 99999
	foe.cooldowns.clear()
	seed(99)
	await s._resolve(foe, foe.abilities[0], u, "good")
	var out := {"rage": u.resource, "plating": int(round(u.plating_bonus * 100.0))}
	await _clear(s)
	return out


func _s2c_the_later_strike() -> void:
	print("\n§2c — the three whose payout is a later strike")
	await _unslaked_arm(false)
	await _unslaked_arm(true)
	# RECOMPENSE pays Rage for the plating reset a block causes.
	var rc_none: Dictionary = await _plating_arm(false, "Recompense")
	var rc_held: Dictionary = await _plating_arm(true, "Recompense")
	var rc_held_bare: Dictionary = await _plating_arm(true, "")
	print("    [Recompense] Rage after a blocked blow: %s without the engine, %s with it, %s with the engine and no card"
		% [rc_none.get("rage", "?"), rc_held.get("rage", "?"), rc_held_bare.get("rage", "?")])
	ok(int(rc_none.get("rage", -1)) == 0,
		"§2c: Recompense paid a Warrior holding NO Heavy Plating %s Rage — it does not belong in the table" % rc_none.get("rage", "?"))
	ok(int(rc_held.get("rage", 0)) > int(rc_held_bare.get("rage", 0)),
		"§2c: Recompense paid a Heavy Plating Warrior no more than no card at all (%s against %s)"
			% [rc_held.get("rage", "?"), rc_held_bare.get("rage", "?")])
	# ANVIL holds the climb through the block that would reset it.
	var an_none: Dictionary = await _plating_arm(false, "Anvil")
	var an_held: Dictionary = await _plating_arm(true, "Anvil")
	var an_held_bare: Dictionary = await _plating_arm(true, "")
	print("    [Anvil] the climb after a blocked blow: %s%% without the engine, %s%% with it, %s%% with the engine and no card"
		% [an_none.get("plating", "?"), an_held.get("plating", "?"), an_held_bare.get("plating", "?")])
	ok(int(an_none.get("plating", -1)) == 24,
		"§2c: the climb moved for a Warrior holding NO Heavy Plating — the block branch is not the engine's")
	ok(int(an_held.get("plating", 0)) > int(an_held_bare.get("plating", 99)),
		"§2c: Anvil held nothing for a Heavy Plating Warrior (%s%% against %s%% with no card)"
			% [an_held.get("plating", "?"), an_held_bare.get("plating", "?")])


# ── §2d — THE THREE WHOSE PAYOUT WAITS ON AN EVENT ──────────────────────────
#
# Intercession's refusal is paid when a hero would die; Last Howl's and
# Succession's shares are paid when a companion falls or is swapped. The CAST is
# identical on both arms and so are its words, so §2's pair test reads them as
# engine-free and would strike three true rows out of the table. **THE ARM IS
# THE EVENT, NOT THE CAST.**

# Intercession's hook is stamped at `_spawn_units` — `if heroes.any(... == "Mercy")`
# — so the engine has to be held BEFORE the board is built. It is handed to the
# party through the fixture's own override, which is what class selection does.
func _intercession_arm(hold: bool) -> bool:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": Runes.engine_pouch_for_spec("holy") if (hold and seat == 2) else []}
	var s: Node = await Gate.spawn(self, NO_LINEAGE, {"deterministic": true, "party": over})
	var c: BattleUnit = _hero(s, "cleric")
	var w: BattleUnit = _hero(s, "warrior")
	var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
	if c == null or w == null or foes.is_empty():
		ok(false, "§2d: the Intercession board is short a unit")
		await _clear(s)
		return false
	if hold:
		c.second_resource = 3
	var ab: Ability = Classes.pool_ability("Intercession")
	c.resource = 99999
	c.cooldowns.clear()
	await s._resolve(c, ab, c, "good")
	# A BLOW THAT WOULD KILL HIM. The refusal is the only thing that can leave
	# him standing.
	w.hp = 1
	var foe: BattleUnit = foes[0]
	foe.attack = 9999
	foe.resource = 99999
	foe.cooldowns.clear()
	await s._resolve(foe, foe.abilities[0], w, "good")
	var stood := not w.dead
	await _clear(s)
	return stood


func _s2d_the_later_event() -> void:
	print("\n§2d — the three whose payout waits on an event")
	var ic_none: bool = await _intercession_arm(false)
	var ic_held: bool = await _intercession_arm(true)
	print("    [Intercession] the hero the blow would have killed: %s without Mercy, %s with it"
		% ["FELL" if not ic_none else "stood", "FELL" if not ic_held else "stood"])
	ok(not ic_none,
		"§2d: Intercession refused a death for a party holding NO Mercy — it does not belong in the table")
	ok(ic_held,
		"§2d: Intercession refused nothing for a Cleric holding Mercy — the row may be wrong")
	# LAST HOWL AND SUCCESSION BOTH READ ONE NUMBER: a companion's Loyalty. The
	# arm is that number, because `_gain_loyalty` is its one writer and it
	# returns at once without the engine — so both cards read a meter that stays
	# at zero for a Hunter's whole run. One drive settles both.
	for hold in [false, true]:
		var s: Node = await _no_lineage_board()
		var h: BattleUnit = _hero(s, "hunter")
		var foes: Array = s.get("enemies").filter(func(e): return not e.dead)
		if h == null or foes.is_empty():
			ok(false, "§2d: no Hunter and a foe for the Loyalty arm")
			await _clear(s)
			continue
		for u in s.get("heroes"):
			u.engines = []
		if hold:
			h.engines = ["pack"]
		var cw: Ability = Classes.pool_ability("Call the Wilds")
		h.resource = 99999
		h.cooldowns.clear()
		await s._resolve(h, cw, foes[0], "good")
		var beasts: Array = s._beasts(h)
		ok(not beasts.is_empty(),
			"§2d: Call the Wilds summoned nothing%s — the arm cannot be read" % (" with Pack Bond" if hold else " without Pack Bond"))
		var kind := String(beasts[0].companion_kind) if not beasts.is_empty() else ""
		if kind != "":
			s._gain_loyalty(h, kind, 4)
		var loy := int(h.loyalty.get(kind, 0))
		print("    [Loyalty] a companion stands at %d Loyalty %s Pack Bond" % [
			loy, "with" if hold else "without"])
		if hold:
			ok(loy > 0,
				"§2d: a bonded companion gained no Loyalty with Pack Bond held — Last Howl's and Succession's row cannot be read")
		else:
			ok(loy == 0,
				"§2d: a companion gained %d Loyalty with NO Pack Bond — Last Howl and Succession do not belong in the table" % loy)
		await _clear(s)

# ── §3 — THE ZONE-BOSS FALLBACK ─────────────────────────────────────────────

func _s3_the_fallback() -> void:
	print("\n§3 — the zone-boss fallback: two tiers, not three")
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	var bodies: Dictionary = Gate.returning_bodies(rs)
	var fb := String(bodies.get("roll_draft_fallback_offer", ""))
	ok(fb != "", "§3: `roll_draft_fallback_offer` is gone")
	ok(fb.contains("Classes.draft_pool("),
		"§3: the fallback no longer reads the class pool")
	ok(fb.contains("Classes.offerable("),
		"§3: the fallback does not ask the engine gate — a zone boss can award a card the hero cannot cast")
	var aw := String(bodies.get("award_ability_pick", ""))
	ok(aw.contains("roll_spec_ability_offer(member)") and aw.contains("roll_draft_fallback_offer(member)"),
		"§3: the award's chain is not boss pool then the class pool")
	ok(aw.find("roll_spec_ability_offer(member)") < aw.find("roll_draft_fallback_offer(member)"),
		"§3: the fallback is read BEFORE the boss pool — the existing pick is no longer unchanged")
	# DRIVEN: a hero who owns his whole boss pool still gets a real card, and it
	# is one he can cast.
	_run.sim_run = false
	_run.new_run(CLASS_SEATS, [], "standard")
	for i in _run.party.size():
		_run.party[i]["awakened"] = true
		_run.party[i]["spec"] = ""
		_run.party[i]["engines"] = []
	_run.specs_chosen = true
	for cls in CLASS_SEATS:
		var m: Dictionary = _run.party[CLASS_SEATS.find(cls)]
		var offer: Array = _run.roll_draft_fallback_offer(m)
		ok(offer.size() == 3,
			"§3: the %s fallback offered %d cards, not three" % [cls, offer.size()])
		for n in offer:
			ok(Classes.engine_read(String(n)) == "",
				"§3: the %s fallback offered %s, which reads %s, to a hero holding no engine" % [
					cls, n, Classes.engine_read(String(n))])
	# A MEMBER NOT YET AWAKENED GETS NOTHING (the negative arm).
	_run.party[0]["awakened"] = false
	ok((_run.roll_draft_fallback_offer(_run.party[0]) as Array).is_empty(),
		"§3: the fallback pays a member who has not been through class selection")
	_run.party[0]["awakened"] = true


# ── §4 — A WHOLE RUN, DRAFTING THROUGHOUT ───────────────────────────────────

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


func _where() -> String:
	return "zone %d slot %d" % [int(_run.zone_idx) + 1, int(_run.slot_idx) + 1]


# Every offer this hero is holding, recorded before it is answered. THE OFFER IS
# THE MEASUREMENT (the brief's §5), so it is read off the member rather than off
# the screen: `award_draft_pick` rolls it and stores it, and what the overlay
# draws is that same list (§4b).
func _record(m: Dictionary) -> void:
	var key := String(m.get("key", ""))
	for offer in m.get("draft_candidates", []):
		for card in offer:
			var seen: Array = _offers.get(key, [])
			if not seen.has(String(card)):
				seen.append(String(card))
			_offers[key] = seen


# The draft, answered through the run's OWN doors — the two the screen's
# `_confirm_party_draft` calls, so the cap, the bench and the no-return ledger
# are the run's rules. TAKING, not declining: the brief asks for a run drafting
# throughout, and a declined offer does not move what is left the same way.
func _answer_the_draft(s: Node) -> void:
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		_record(m)
		var guard := 0
		while int(m.get("draft_picks_owed", 0)) > 0 and guard < 8:
			guard += 1
			var queue: Array = m.get("draft_candidates", [])
			var offer: Array = queue[0] if not queue.is_empty() else []
			var took := false
			for card in offer:
				var bench := ""
				if _run.ability_slots_full(m):
					var earned: Array = _run.earned_ability_names(m)
					var carried: Array = _run.equipped_ability_names(m)
					for e in earned:
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
	if s != null and s.has_method("_close_party_draft"):
		s.call("_close_party_draft")
	await Gate.frames(self, 2)


func _answer_a_pick(s: Node, idx: int) -> void:
	var m: Dictionary = _run.party[idx]
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
		_dead.append("hero %d owed a pick at %s and no live choice could be pressed" % [idx, _where()])
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
		await _answer_the_draft(s)
		return "draft"
	for idx in _run.party.size():
		var m: Dictionary = _run.party[idx]
		if int(m.get("bm_picks_owed", 0)) > 0 or int(m.get("up_picks_owed", 0)) > 0 \
				or int(m.get("rune_picks_owed", 0)) > 0:
			await _answer_a_pick(s, idx)
			return "pick"
	_maps_read += 1
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
	if guard >= FRAME_CAP:
		return "a battle never ended in %d frames" % FRAME_CAP
	# BATCH GS — THE NO-ENGINE ARM'S PREMISE, READ WHERE ITS DRAFTS ARE ROLLED: the
	# victory's `award_draft_pick` reads each member's slotted engines, and no
	# rune reaches a member during a fight, so what is slotted now is what the
	# roll read.
	if _keep_bare:
		for m in _run.party:
			if not Runes.held_engines(m).is_empty():
				_engined.append("%s %s at %s" % [m.get("key", "?"),
					str(Runes.held_engines(m)), _where()])
	await Gate.frames(self, 6)
	_battles += 1
	if Gate.press(s, ["Continue", "Descend into", "Walk on", "Onward"]) != "":
		return "on"
	if Gate.has_text(s, "New Run"):
		return "the run ENDED"
	return "the battle's card drew nothing to press"


func _leave(s: Node, nm: String) -> String:
	match nm:
		"Offer":
			var btns: Array = []
			Gate.buttons(s, btns)
			for b in btns:
				if String((b as Button).text) == "Take this bargain" and not (b as Button).disabled:
					(b as Button).emit_signal("pressed")
					return "bargain"
			return Gate.press(s, ["Walk on", "Leave", "Onward"])
		"Event":
			var choice := Gate.press(s, [""])
			if choice == "":
				return ""
			await Gate.frames(self, 3)
			var on := Gate.press(s, ["Continue"])
			return choice if on == "" else on
		"Shop":
			return Gate.press(s, ["Leave the Shop"])
		"Blacksmith":
			return Gate.press(s, ["Leave the forge", "Walk on"])
	return Gate.press(s, ["Leave", "Walk on", "Onward", "Continue", "Depart"])


# **BATCH GS — THE NO-ENGINE ARM HOLDS NO ENGINE FOR THE WHOLE ROAD.** It is the
# arm the offer measurement is about, and after GS it stopped being one: the road
# answers every rune pick with its first live button, and on the seeded road GS's
# kits walk the party took ten ENGINE runes and slotted seven — the Arcanist's,
# the Devout's and the Beastmaster's among them — because `hold_rune` slots an
# engine while a slot is free. Every Inner Arcane, Ordination or Unleash it was
# then shown was rolled for a hero holding that engine: `award_draft_pick` read
# the slotted engines at each roll (probed), and the gate offered what it should.
# §4 was reading the game working as a leak. So every engine the road hands this
# party is unslotted through the player's own door, `Run.toggle_engine` (zero
# engines is a legal state, and the rune is kept), at the top of every step, and
# `_fight` asserts that none was slotted when a draft was rolled. Returns how
# many it set aside.
func _unslot_engines() -> int:
	var n := 0
	for m in _run.party:
		var held: Array = m.get("engines", [])
		for i in held.size():
			if bool((held[i] as Dictionary).get("equipped", false)) and _run.toggle_engine(m, i):
				n += 1
	return n


# One arm of §4: a whole run with every hero holding `engines`, drafting at
# every offer, and the cards each of them was SHOWN recorded by name.
func _road(label: String, per_hero: int) -> void:
	_maps_read = 0
	_battles = 0
	_dead = []
	_offers = {}
	# BATCH GS — the no-engine arm is kept one (`_unslot_engines`).
	_keep_bare = per_hero == 0
	_set_aside = 0
	_engined = []
	_fresh_meta()
	seed(ROAD_SEED)
	_run.sim_run = false
	_run.new_run(CLASS_SEATS, [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = ""
		_run.party[i]["awakened"] = true
		_run.party[i]["tree"] = Talents.generate_tree("", CLASS_SEATS[i])
		var held: Array = []
		for pid in Classes.class_engines(CLASS_SEATS[i]).slice(0, per_hero):
			var rid := Runes.engine_rune_id(String(pid))
			if rid == "":
				continue
			var r: Dictionary = Runes.build(rid)
			r["equipped"] = true
			held.append(r)
		_run.party[i]["engines"] = held
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	change_scene_to_file("res://scenes/map.tscn")
	await Gate.frames(self, 4)
	var stalled := ""
	for _step in MAX_STEPS:
		await Gate.frames(self, 2)
		# BATCH GS — before anything is pressed: see `_unslot_engines`.
		if _keep_bare:
			_set_aside += _unslot_engines()
		var s: Node = current_scene
		if s == null or s.is_queued_for_deletion():
			continue
		var nm := Gate.scene_name(self)
		if nm == "Map":
			if not bool(_run.active):
				break
			if await _step_map(s) == "":
				stalled = "nothing pressable on the map at %s" % _where()
				break
		elif nm == "Battle":
			var out := await _fight(s)
			if out != "on":
				if out == "the run ENDED":
					break
				stalled = "%s, at %s" % [out, _where()]
				break
		elif nm == "MainMenu":
			break
		elif await _leave(s, nm) == "":
			stalled = "no way off the %s screen at %s" % [nm, _where()]
			break
	print("    [%s] %d battles, %d maps, stopped at %s" % [label, _battles, _maps_read, _where()])
	ok(stalled == "", "§4 [%s]: the road stopped — %s" % [label, stalled])
	ok(_dead.is_empty(), "§4 [%s]: a screen could not be answered — %s" % [label, _dead])
	ok(_maps_read >= 12,
		"§4 [%s]: the road read only %d maps — the run stopped too early to draft" % [label, _maps_read])
	# BATCH GS — THE ARM'S PREMISE, ASSERTED: no draft this road rolled was rolled
	# for a hero holding a slotted engine. The count set aside is printed, not
	# asserted: how many engine runes a seeded road deals is the road's business.
	if _keep_bare:
		print("    [%s] the road dealt the party %d slotted engine runes; each was unslotted through `Run.toggle_engine` before the next step" % [
			label, _set_aside])
		ok(_engined.is_empty(),
			"§4 [%s]: a hero held a slotted engine when a battle's draft was rolled — the arm stopped measuring a hero with no engine (%s)" % [
				label, _engined])
	_keep_bare = false


func _s4_the_road() -> void:
	print("\n§4 — a whole run, drafting throughout")
	OS.set_environment("DOD_AUTOPLAY", "1")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Engine.max_fps = 0

	await _road("no engine", 0)
	var bare: Dictionary = _offers.duplicate(true)
	var bare_total := 0
	for key in bare:
		var names: Array = bare[key]
		bare_total += names.size()
		names.sort()
		print("      %-8s was offered %d: %s" % [key, names.size(), ", ".join(names)])
		# THE MEASUREMENT THAT SAYS WHETHER THE MERGE WORKED: not one card he
		# cannot use, across a whole run.
		for n in names:
			ok(Classes.engine_read(String(n)) == "",
				"§4: the engine-less %s was OFFERED %s, which reads %s" % [
					key, n, Classes.engine_read(String(n))])
		# AND THE MERGE'S OWN CLAIM: what he is shown is not one lineage's shelf.
		var shelves := 0
		for spec in Classes.SPEC_IDS[key]:
			if names.any(func(n): return Classes.spec_draft_pool(String(spec)).has(String(n))):
				shelves += 1
		ok(shelves >= 2,
			"§4: every card the %s was offered came from %d lineage shelf — the pool did not merge" % [
				key, shelves])
	ok(bare_total >= 12,
		"§4: a whole run showed the party only %d cards in all — too few to read anything off" % bare_total)

	await _road("two engines", 2)
	var two_total := 0
	for key in _offers:
		two_total += (_offers[key] as Array).size()
	var gated := 0
	for key in _offers:
		for n in _offers[key]:
			if Classes.engine_read(String(n)) != "":
				gated += 1
	print("      a party holding two engines apiece was shown %d cards, %d of them engine-readers"
		% [two_total, gated])
	# THE POSITIVE ARM FOR THE WHOLE GATE: holding engines a hero IS shown the
	# cards that read them, or the gate is simply refusing everything.
	ok(gated > 0,
		"§4: a party holding two engines apiece was offered NO engine-reading card in a whole run — the gate refuses everyone")

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
