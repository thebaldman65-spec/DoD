# BATCH FO — TWO RUNES FN FLAGGED, RULED.
#
#   §1  DEEPENING HEX SUBTRACTS 2 — the arithmetic driven on a live board at
#       every rung, EZ §5's "never shallower" property restated against the
#       subtraction, and THE FLOOR asserted as a ruling rather than as a guard
#       against a division by zero
#   §2  THE WIDE WATCH IS RETIRED AND THE SHARED MARK REPLACES IT — the
#       retirement in both directions (kept AND unofferable), the new rune
#       driven on a live board through the HERO path and the COMPANION path,
#       and `_gain_focus` proved to be the only way in BEHAVIOURALLY
#   §3  THE `Overkill` COLLISION, ASSERTED RATHER THAN REPORTED — two nodes,
#       two specs, one word, and this batch ruled on none of it
#
# **WHY THIS BATCH EARNS A GATE.** It encodes two rulings and both decay
# silently, in opposite directions:
#
#   §1 DECAYS DOWNWARD. The `mini` it replaces was CLOSED at the bottom — no
#     composition could push it below the capstone's own 5. A subtraction is
#     OPEN at the bottom: anything else that lowers the threshold walks the
#     number toward the floor, and at the floor the rune is worth EXACTLY ZERO
#     again, which is the hole FN measured arriving by a new route. §1e is the
#     arm that reds when that happens, and it is the reason this gate exists.
#   §2 DECAYS BY DELETION. The Wide Watch is RETIRED, not removed — the Melted
#     Armor contract — and the tempting repair on the day something goes red is
#     to delete the entry, the field or the read site. A saved run holding the
#     rune reads all three. §2a asserts the entry is KEPT as hard as it asserts
#     it is unofferable.
#
# **AND §2's COMPANION ARM IS THE ONE THAT COULD NOT BE ARGUED.** *Ally* is
# heroes AND companions (CV §4 / DM §3), and DK §1's rule is that a widening is
# done when the EFFECT ARRIVES — measured on a live body, never inferred from a
# collection. A companion cannot stand beside a Sharpshooter in a legal run (one
# class each, and summoning is the Beastmaster's exclusive axis), so the arm is
# unreachable in PLAY and drivable in a FIXTURE. It is driven.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fo.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# **THE SEATING, AND IT IS NOT THE SPEC ORDER.** `gate_fixture.spawn` builds a
# warrior/mage/cleric/hunter party and stamps the specs on positionally, so the
# Sharpshooter is seat 2 (the CLERIC seat) and the Beastmaster seat 3. Written
# out because getting it wrong reads as the rune failing rather than as the
# probe pointing at the wrong hero — which is what happened first here.
const SEAT := {"occultist": 0, "warden": 1, "sharpshooter": 2, "beastmaster": 3}
const DRIVE := ["occultist", "warden", "sharpshooter", "beastmaster"]

# THE TWO NUMBERS THE FLOOR IS PRICED AGAINST. Held here so §1g asserts the
# floor's REASON is still true, not only that the floor is still 3: a floor of 3
# under a capstone of 5 and a subtraction of 2 is exactly-reaching, and if either
# of those moves the floor is answering a question nobody asked any more.
const BASE_THRESHOLD := 10
const CAPSTONE_INSTALLS := 5
const HEX_SUBTRACTS := 2
const FLOOR := 3

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260908)
	print("BATCH FO — TWO RUNES FN FLAGGED, RULED")
	_s1_data()
	await _s1_driven()
	_s2_data()
	await _s2_driven()
	_s3_the_collision()
	_g.report(self)


# ═══ §1 — DEEPENING HEX SUBTRACTS 2 ══════════════════════════════════════════

func _s1_data() -> void:
	print("\n§1 — Deepening Hex: the payload, the field and the floor")
	var raw: String = FileAccess.get_file_as_string("res://data/runes.json")
	var data: Dictionary = JSON.parse_string(raw) as Dictionary
	ok(data != null and data.has("deepening_hex"),
		"§1a: `deepening_hex` is not in the rune file — every arm below is vacuous")
	if data == null or not data.has("deepening_hex"):
		return
	var e: Dictionary = data["deepening_hex"]
	var stat: Dictionary = (e.get("payload", {}) as Dictionary).get("stat", {})

	# ── (a) THE PAYLOAD IS THE SUBTRACTION, AND THE OLD FIELD IS GONE ────────
	#
	# **BOTH DIRECTIONS, BECAUSE A RENAME THAT LEFT THE OLD FIELD STANDING IS
	# THE SILENT HALF.** `rune_hex_threshold` still declared on `BattleUnit`
	# would accept a stale payload from a saved run and be read by nothing — the
	# rune would install, log nothing and change nothing, which is the Standing
	# Ground failure arriving through a rename instead of through an author.
	ok(stat.has("rune_hex_deepen"),
		"§1a: the payload does not write `rune_hex_deepen` (%s)" % [stat.keys()])
	ok(int(stat.get("rune_hex_deepen", 0)) == HEX_SUBTRACTS,
		"§1a: the payload subtracts %s, not %d" % [stat.get("rune_hex_deepen", "<absent>"),
			HEX_SUBTRACTS])
	ok(not stat.has("rune_hex_threshold"),
		"§1a: the payload still writes the RETIRED `rune_hex_threshold`")
	var usrc: String = Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	ok(usrc.contains("var rune_hex_deepen"),
		"§1a: `rune_hex_deepen` is not declared on BattleUnit — the payload lands nowhere")
	ok(not usrc.contains("var rune_hex_threshold"),
		"§1a: `rune_hex_threshold` is STILL declared — a stale payload would land and be read by nothing")
	# AND THE COERCION LIST, WHICH IS THE AA TRAP. A `rune_` int whose name does
	# not end `_ranks` and is not listed reaches a typed int var as a FLOAT and
	# the hero fails to spawn — a runtime error, not a rounding.
	ok(Runes.STAT_INT_KEYS.has("rune_hex_deepen"),
		"§1a: `rune_hex_deepen` is not in `STAT_INT_KEYS` — JSON's float would throw at spawn")
	ok(not Runes.STAT_INT_KEYS.has("rune_hex_threshold"),
		"§1a: the retired field is still in `STAT_INT_KEYS`")

	# ── (b) THE CARD SAYS WHAT THE CODE DOES, INCLUDING THE FLOOR ────────────
	#
	# **THE FLOOR IS ON THE CARD BECAUSE IT IS A RULE THE PLAYER MEETS.** A
	# value left off a line is a stat nobody knows they have (`text-standard`
	# §1), and a subtraction with an invisible bottom is exactly that: an
	# Occultist holding the capstone reads 5 and gets 3, and reads nothing
	# telling him why it stops there.
	var d := String(e.get("desc", ""))
	ok(d.contains("TWO stacks sooner"),
		"§1b: the card no longer states the SUBTRACTION — reads `%s`" % d)
	ok(d.contains("every 3rd"),
		"§1b: the card no longer states the FLOOR — reads `%s`" % d)
	ok(int(e.get("price", 0)) == 100,
		"§1b: Deepening Hex left the flat 100g (%s)" % e.get("price", "<absent>"))
	ok(not e.has("retired"),
		"§1b: Deepening Hex was RETIRED rather than re-pointed")

	# ── (c) THE FLOOR AND THE TWO NUMBERS IT IS PRICED AGAINST ──────────────
	#
	# **A FLOOR IS A RULING AND ITS REASON IS AN ARITHMETIC RELATION.** Three is
	# chosen because `5 - 2` reaches it exactly: it is the deepest the live tree
	# can go, so it changes nothing today and refuses everything below. If the
	# capstone or the subtraction moves, that relation is broken and the floor is
	# answering a question nobody asked — so all three are asserted together.
	var bsrc: String = Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bsrc.contains("const RUIN_FLOOR := %d" % FLOOR),
		"§1c: `RUIN_FLOOR` is not %d in the source" % FLOOR)
	ok(bsrc.contains("const RUIN_THRESHOLD := %d" % BASE_THRESHOLD),
		"§1c: `RUIN_THRESHOLD` is not %d — the floor's pricing has moved under it"
			% BASE_THRESHOLD)
	ok(bsrc.contains("maxi(step - occ.rune_hex_deepen, RUIN_FLOOR)"),
		"§1c: `_ruin_threshold` no longer reads as a floored subtraction")
	ok(not bsrc.contains("mini(step, occ.rune_hex_threshold)"),
		"§1c: the retired `mini` is still in the fight")
	# The capstone's own installed value, off the TREE rather than written in.
	var cap := 0
	for nd in Talents.LANE_TREES.get("occultist", []):
		if String((nd as Dictionary).get("id", "")) == "oc_avatar_ruin":
			cap = int((((nd as Dictionary).get("payload", {}) as Dictionary)
				.get("stat", {}) as Dictionary).get("avatar_ruin", 0))
	ok(cap == CAPSTONE_INSTALLS,
		"§1c: Avatar of Ruin installs %d, not %d — `%d - %d` no longer reaches the floor exactly"
			% [cap, CAPSTONE_INSTALLS, CAPSTONE_INSTALLS, HEX_SUBTRACTS])
	ok(CAPSTONE_INSTALLS - HEX_SUBTRACTS == FLOOR,
		"§1c: the floor is no longer the exact bottom of the live tree (%d - %d != %d)"
			% [CAPSTONE_INSTALLS, HEX_SUBTRACTS, FLOOR])


func _s1_driven() -> void:
	print("\n§1 — Deepening Hex, driven on a live board")
	var scene: Node = await Gate.spawn(self, DRIVE)
	var heroes: Array = scene.get("heroes")
	ok(heroes.size() >= 4, "§1d: the spawn returned %d heroes" % heroes.size())
	if heroes.size() < 4:
		return
	var occ: BattleUnit = heroes[int(SEAT["occultist"])]

	# ── (d) THE ARITHMETIC AT EVERY RUNG ────────────────────────────────────
	occ.rune_hex_deepen = 0
	occ.avatar_ruin = 0
	var base: int = scene._ruin_threshold()
	ok(base == BASE_THRESHOLD,
		"§1d: Ruin detonates every %dth by default, not every %dth" % [base, BASE_THRESHOLD])
	occ.rune_hex_deepen = HEX_SUBTRACTS
	var runed: int = scene._ruin_threshold()
	ok(runed == BASE_THRESHOLD - HEX_SUBTRACTS,
		"§1d: the rune alone reads %d, not %d" % [runed, BASE_THRESHOLD - HEX_SUBTRACTS])
	occ.avatar_ruin = CAPSTONE_INSTALLS
	var both: int = scene._ruin_threshold()
	ok(both == CAPSTONE_INSTALLS - HEX_SUBTRACTS,
		"§1d: rune AND capstone reads %d, not %d" % [both,
			CAPSTONE_INSTALLS - HEX_SUBTRACTS])
	occ.rune_hex_deepen = 0
	var cap_only: int = scene._ruin_threshold()
	ok(cap_only == CAPSTONE_INSTALLS,
		"§1d: the capstone alone reads %d, not %d" % [cap_only, CAPSTONE_INSTALLS])

	# ── (e) EZ §5's PROPERTY, RESTATED AGAINST THE SUBTRACTION ──────────────
	#
	# **THE ASSERTION IS NOT DELETED FOR HAVING HAD ITS SUBJECT CHANGED.** EZ §5
	# asserted the rune can never make a capstone holder's detonation SHALLOWER;
	# that is the property, and it is asserted here as an INEQUALITY over both
	# builds rather than as the two values above — a value arm passes on the two
	# numbers this batch happens to ship, and the property is what survives the
	# next re-tune. **A gate that stops asking is the failure forty batches have
	# been removing.**
	ok(runed <= base,
		"§1e: holding the rune made an UNTALENTED hex SHALLOWER (%d > %d)" % [runed, base])
	ok(both <= cap_only,
		"§1e: holding the rune made a CAPSTONE hex SHALLOWER (%d > %d) — the fault the `mini` existed to stop"
			% [both, cap_only])

	# **AND THE HALF THE `mini` COULD NOT GIVE: IT IS WORTH SOMETHING.** FN
	# measured the rune at EXACTLY ZERO for a capstone holder and that is what
	# this batch took. A property arm alone would pass on `mini` again, which
	# satisfies "never shallower" perfectly and pays nothing — so the STRICT
	# inequality is asserted on both builds, and it is the arm that reds the day
	# anything else lowers the threshold onto the floor.
	ok(runed < base,
		"§1e: the rune is worth ZERO to an untalented Occultist (%d == %d)" % [runed, base])
	ok(both < cap_only,
		"§1e: the rune is worth ZERO to a capstone holder (%d == %d) — FN's hole is OPEN again"
			% [both, cap_only])
	ok(cap_only - both == HEX_SUBTRACTS and base - runed == HEX_SUBTRACTS,
		"§1e: the rune pays %d to a capstone holder and %d without — it is not the same %d to every build"
			% [cap_only - both, base - runed, HEX_SUBTRACTS])

	# ── (f) THE FLOOR BITES, AND IT IS DRIVEN AT BOTH EDGES ─────────────────
	#
	# Unreachable in the live tree — nothing installs a threshold of 4 or 3 — so
	# the state is CONSTRUCTED rather than waited for. That is the whole point:
	# the floor guards a composition that does not exist YET.
	occ.rune_hex_deepen = HEX_SUBTRACTS
	occ.avatar_ruin = FLOOR + 1
	var edge: int = scene._ruin_threshold()
	ok(edge == FLOOR,
		"§1f: at a threshold of %d the subtraction reached %d — the floor did not bite"
			% [FLOOR + 1, edge])
	occ.avatar_ruin = FLOOR
	var atfloor: int = scene._ruin_threshold()
	ok(atfloor == FLOOR,
		"§1f: at the floor itself the subtraction read %d" % atfloor)
	occ.avatar_ruin = 1
	ok(scene._ruin_threshold() == FLOOR,
		"§1f: a threshold BELOW the floor was not raised to it (%d) — `st %% step` is a division"
			% scene._ruin_threshold())
	ok(scene._ruin_threshold() > 0,
		"§1f: the threshold reached ZERO — `_gain_ruin`'s modulo would throw")
	occ.avatar_ruin = 0

	# ── (g) THE DETONATION ITSELF, NOT ONLY THE FUNCTION ────────────────────
	#
	# **A THRESHOLD FUNCTION RETURNING 8 IS NOT A HEX DETONATING AT 8.**
	# `_gain_ruin` arms on `st % step == 0`, so this walks real stacks onto a
	# real enemy and reads the primer. The control is the stack BEFORE it: at
	# seven the bomb must NOT be armed, or "primed at eight" is satisfied by a
	# mark that primes at every stack.
	var foes: Array = scene.get("enemies")
	ok(foes.size() >= 2, "§1g: the spawn returned %d enemies" % foes.size())
	if foes.size() < 2:
		return
	var foe: BattleUnit = foes[0]
	occ.rune_hex_deepen = HEX_SUBTRACTS
	for i in 7:
		scene._gain_ruin(foe, 1)
	ok(not foe.has_status("ruin_primed"),
		"§1g: SEVEN stacks primed the mark — the arm below proves nothing")
	scene._gain_ruin(foe, 1)
	ok(foe.has_status("ruin_primed"),
		"§1g: EIGHT stacks did not prime the mark — the subtraction never reached the fight")
	# AND THE CONTROL WITHOUT THE RUNE: ten, not eight.
	var foe2: BattleUnit = foes[1]
	occ.rune_hex_deepen = 0
	for _i in 8:
		scene._gain_ruin(foe2, 1)
	ok(not foe2.has_status("ruin_primed"),
		"§1g: eight stacks primed a mark with NO rune held — the arm above is not measuring the rune")
	for _i in 2:
		scene._gain_ruin(foe2, 1)
	ok(foe2.has_status("ruin_primed"),
		"§1g: ten stacks did not prime an unruned mark — the base threshold is not %d"
			% BASE_THRESHOLD)


# ═══ §2 — THE WIDE WATCH IS RETIRED, THE SHARED MARK REPLACES IT ══════════════

func _s2_data() -> void:
	print("\n§2 — the Wide Watch retired, the Shared Mark authored")
	var raw: String = FileAccess.get_file_as_string("res://data/runes.json")
	var data: Dictionary = JSON.parse_string(raw) as Dictionary
	ok(data != null and data.has("wide_watch") and data.has("shared_mark"),
		"§2a: one of the two entries is missing from the rune file")
	if data == null or not data.has("wide_watch") or not data.has("shared_mark"):
		return

	# ── (a) RETIRED, AND KEPT — THE MELTED ARMOR CONTRACT, BOTH HALVES ──────
	#
	# **THE KEPT HALF IS ASSERTED AS HARD AS THE RETIRED HALF, AND IT IS THE ONE
	# A REPAIR WILL REACH FOR.** Retirement means it stops being OFFERED. A
	# saved run can be holding this rune right now, so `config`, `build` and the
	# read site all have to keep working — and the tempting green on the day
	# something reds is to delete the entry, the field or the arm in
	# `_sharpshooter_focus`. All three are pinned PRESENT here.
	var ww: Dictionary = data["wide_watch"]
	var r := String(ww.get("retired", ""))
	ok(r != "", "§2a: the Wide Watch carries no retirement string")
	ok(r.contains("BATCH FO"),
		"§2a: the retirement string names no batch — a retirement must be DECLARATIVE")
	ok(r.contains("LOST:"),
		"§2a: the retirement string names no LOSS — that is the record a future author needs")
	ok(r.contains("Overkill"),
		"§2a: the retirement string does not name the NODE the rune duplicated — `it was weak` is not the reason")
	ok(String(ww.get("name", "")) == "Wide Watch"
			and String(ww.get("scope", "")) == "spec:sharpshooter"
			and int(ww.get("price", 0)) == 100,
		"§2a: the retired entry lost its name, scope or price — a saved run holding it breaks")
	ok(((ww.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary)
			.has("rune_wide_watch"),
		"§2a: the retired entry lost its payload — a saved run holding it installs nothing")
	ok(String(Runes.config("wide_watch").get("name", "")) == "Wide Watch",
		"§2a: `Runes.config` no longer resolves the retired id")
	ok(not (Runes.build("wide_watch").get("payload", {}) as Dictionary).is_empty(),
		"§2a: `Runes.build` no longer resolves the retired id")
	ok(Runes.is_retired("wide_watch"),
		"§2a: `Runes.is_retired` does not agree with the file")
	ok(not (Runes.rune_shape("wide_watch") as Array).is_empty(),
		"§2a: the retired entry lost its `RUNE_SHAPES` row — it reads as a lane-rule entry (check_et §1)")
	# THE READ SITE, WHICH NO DATA SWEEP CAN SEE.
	var bsrc: String = Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bsrc.contains("attacker.rune_wide_watch > 0"),
		"§2a: the Wide Watch's read site came out with its offer — a saved run holding it now pays NOTHING")
	var usrc: String = Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/unit.gd"))
	ok(usrc.contains("var rune_wide_watch"),
		"§2a: `rune_wide_watch` is no longer declared — the retired payload lands nowhere")

	# ── (b) AND IT IS UNOFFERABLE, THROUGH THE ONE DOOR ─────────────────────
	#
	# **`eligible_ids` IS THE ONLY DOOR** — `generate` and `run_state.grant_rune`
	# both reach the authored pool through it. Asserted with its POSITIVE arm
	# beside it: a gate that only checked absence reads green on the day the
	# whole pool stops rolling.
	var member := {"key": "hunter", "spec": "sharpshooter", "runes": [],
		"abilities": [], "earned_abilities": [], "bm_abilities": []}
	var offer: Array = Runes.eligible_ids(member, [])
	ok(not offer.has("wide_watch"),
		"§2b: the RETIRED Wide Watch is still offerable to a Sharpshooter")
	ok(offer.has("shared_mark"),
		"§2b: the Shared Mark is NOT offerable to a Sharpshooter — the whole pool may have stopped rolling (%d offered)"
			% offer.size())

	# ── (c) THE NEW ENTRY, AND EVERY TABLE IT OWES A ROW ────────────────────
	var sm: Dictionary = data["shared_mark"]
	ok(String(sm.get("name", "")) == "Shared Mark",
		"§2c: the rune is named `%s`" % sm.get("name", ""))
	# **BARE, NOT `Rune of the ...`.** All sixty live entries are bare and every
	# `Rune of the ...` in the file is retired; the brief's display heading is
	# not the authored name. Asserted as a POPULATION so the convention is what
	# is pinned, not this one string.
	var of_live := 0
	var live := 0
	for id in data:
		if (data[id] as Dictionary).has("retired"):
			continue
		live += 1
		if String((data[id] as Dictionary).get("name", "")).to_lower().begins_with("rune of"):
			of_live += 1
	ok(of_live == 0,
		"§2c: %d LIVE entries are named `Rune of the ...` — the bare convention is broken" % of_live)
	ok(live == 60,
		"§2c: the live pool is %d, not 60 — one out and one in was not the trade" % live)
	ok(String(sm.get("scope", "")) == "spec:sharpshooter",
		"§2c: the Shared Mark is scoped `%s`" % sm.get("scope", ""))
	ok(int(sm.get("price", 0)) == 100, "§2c: the Shared Mark is not the flat 100g")
	ok(not sm.has("condition")
			and not (sm.get("payload", {}) as Dictionary).has("condition"),
		"§2c: the Shared Mark carries a CONDITION — THRESHOLD and BREADTH are retired (FN)")
	ok(not sm.has("requires_ability"),
		"§2c: the Shared Mark requires an ability — it is a PASSIVE and reads the meter, not a card")
	ok((Runes.rune_shape("shared_mark") as Array) == ["PASSIVE"],
		"§2c: `RUNE_SHAPES` reads %s, not [PASSIVE]" % [Runes.rune_shape("shared_mark")])
	ok(Runes.RUNE_TAGS.has("shared_mark"),
		"§2c: the Shared Mark has no `RUNE_TAGS` row — `check_fe` §1 counts the table against the pool")
	ok(Runes.STAT_INT_KEYS.has("rune_shared_mark"),
		"§2c: `rune_shared_mark` is not in `STAT_INT_KEYS` — JSON's float would throw at spawn")
	ok(usrc.contains("var rune_shared_mark"),
		"§2c: `rune_shared_mark` is not declared on BattleUnit")
	var d := String(sm.get("desc", ""))
	ok(d.contains("5 Focus"),
		"§2c: the card does not state what an ally's blow is worth — reads `%s`" % d)
	ok(d.contains("ally"),
		"§2c: the card does not say ALLY, which is the word the code implements — reads `%s`" % d)
	ok(bsrc.contains("const SHARED_MARK_FOCUS := 5"),
		"§2c: the card's 5 and the code's magnitude have parted")


func _s2_driven() -> void:
	print("\n§2 — the Shared Mark, driven on a live board")
	var built: Dictionary = Runes.build("shared_mark")
	built["equipped"] = true
	var scene: Node = await Gate.spawn(self, DRIVE,
		{"party": {int(SEAT["sharpshooter"]): {"runes": [built]}}})
	var heroes: Array = scene.get("heroes")
	var foes: Array = scene.get("enemies")
	ok(heroes.size() >= 4 and foes.size() >= 2,
		"§2d: the spawn returned %d heroes and %d enemies" % [heroes.size(), foes.size()])
	if heroes.size() < 4 or foes.size() < 2:
		return
	var ss: BattleUnit = heroes[int(SEAT["sharpshooter"])]
	var ally: BattleUnit = heroes[int(SEAT["occultist"])]
	var bm: BattleUnit = heroes[int(SEAT["beastmaster"])]
	var mark: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	# **THE MARK IS TOPPED UP BEFORE EVERY ARM, AND THAT IS NOT COSMETIC.** Eight
	# blows land on one raider below; a mark that DIES mid-section reads exactly
	# like the rune paying nothing — `_sharpshooter_focus` takes the
	# `victim.dead` branch and `last_attack_target` is nulled — and every arm
	# after it would fail for a reason that has nothing to do with the rune.

	# **THE SEATING IS ASSERTED, NOT ASSUMED.** A probe pointed at the wrong
	# seat reads exactly like the rune paying nothing, and that is how this arm
	# failed first.
	ok(ss.passive_id == "lethal_aim",
		"§2d: seat %d is not the Sharpshooter (passive `%s`)" % [int(SEAT["sharpshooter"]),
			ss.passive_id])
	ok(ss.second_resource_name == "Focus",
		"§2d: the holder's meter is `%s`, not Focus" % ss.second_resource_name)
	ok(ss.rune_shared_mark == 1,
		"§2d: the rune did not reach the spawned hero (`rune_shared_mark` = %d)"
			% ss.rune_shared_mark)
	var pay: int = scene.get("SHARED_MARK_FOCUS")

	# ── (d) AN ALLY WORKS THE MARK ──────────────────────────────────────────
	_revive(mark, other)
	ss.last_attack_target = mark
	ss.second_resource = 0
	await scene._resolve(ally, ally.abilities[0], mark, "good")
	var on_mark: int = ss.second_resource
	ok(on_mark == pay,
		"§2d: an ally striking the mark paid %d Focus, not %d" % [on_mark, pay])

	# ── THE CONTROL, AND IT IS THE SAME BLOW AT A DIFFERENT BODY ────────────
	#
	# **WITHOUT THIS THE ARM ABOVE PASSES ON A RUNE THAT PAYS ON EVERY ATTACK.**
	# The clause is not "an ally attacks"; it is "an ally attacks THE ENEMY HE
	# LAST ATTACKED", and only the pair separates the two.
	_revive(mark, other)
	ss.last_attack_target = mark
	ss.second_resource = 0
	await scene._resolve(ally, ally.abilities[0], other, "good")
	ok(ss.second_resource == 0,
		"§2d: an ally striking a DIFFERENT enemy paid %d Focus — the rune is not reading the mark"
			% ss.second_resource)

	# ── AND THE HOLDER'S OWN BLOW IS PAID ONCE ──────────────────────────────
	#
	# `_sharpshooter_focus` already pays him for working his own mark. A hook
	# that did not exclude the holder would pay that PLUS the rune and would read
	# as the rune working — a second write site for one event, wearing a rune's
	# name. **THE COMPARISON IS THE SAME BLOW WITH THE RUNE OFF, NOT A NUMBER**:
	# the engine's own magnitude is `20 + muscle_memory_ranks`, and pinning it
	# here would put a second copy of a talent's value in a rune's gate.
	_revive(mark, other)
	ss.last_attack_target = mark
	ss.second_resource = 0
	await scene._resolve(ss, ss.abilities[0], mark, "good")
	var own_with: int = ss.second_resource
	ss.rune_shared_mark = 0
	_revive(mark, other)
	ss.last_attack_target = mark
	ss.second_resource = 0
	await scene._resolve(ss, ss.abilities[0], mark, "good")
	var own_without: int = ss.second_resource
	ss.rune_shared_mark = 1
	ok(own_without > 0,
		"§2d: the holder's own blow on his own mark paid NOTHING even with the rune off — the engine is not being reached and the arm below is vacuous")
	ok(own_with == own_without,
		"§2d: the holder's own blow paid %d holding the rune against %d without it — one event, paid twice"
			% [own_with, own_without])

	# ── (e) AND WITHOUT THE RUNE, NOTHING ───────────────────────────────────
	ss.rune_shared_mark = 0
	_revive(mark, other)
	ss.last_attack_target = mark
	ss.second_resource = 0
	await scene._resolve(ally, ally.abilities[0], mark, "good")
	ok(ss.second_resource == 0,
		"§2e: an ally's blow paid %d Focus with the rune NOT held — the arms above are not measuring the rune"
			% ss.second_resource)
	ss.rune_shared_mark = 1

	# ── (f) `_gain_focus` IS THE ONLY WAY IN, PROVED BEHAVIOURALLY ──────────
	#
	# **A SOURCE READ WOULD ONLY SAY THE CALL IS SPELLED THERE.** Spray of
	# Arrows caps the meter at 50 inside `_gain_focus` and nowhere else, so a
	# rune writing `second_resource` directly would sail past it. The meter is
	# parked ON the cap and an ally then works the mark: through the engine it
	# cannot move, and around it, it would.
	ss.spray = 1
	ok(scene._focus_cap(ss) == 50,
		"§2f: the Spray ceiling read %d, not 50 — the control below cannot bind"
			% scene._focus_cap(ss))
	_revive(mark, other)
	ss.second_resource = 50
	ss.last_attack_target = mark
	await scene._resolve(ally, ally.abilities[0], mark, "good")
	ok(ss.second_resource == 50,
		"§2f: an ally's blow pushed the meter to %d THROUGH the Spray ceiling — the rune has its own write site"
			% ss.second_resource)
	# THE POSITIVE ARM: with the ceiling gone the same blow pays. Without it the
	# arm above passes on a rune that pays nothing at all.
	ss.spray = 0
	_revive(mark, other)
	ss.second_resource = 50
	ss.last_attack_target = mark
	await scene._resolve(ally, ally.abilities[0], mark, "good")
	ok(ss.second_resource == 50 + pay,
		"§2f: with the ceiling lifted the same blow read %d, not %d" % [
			ss.second_resource, 50 + pay])

	# ── (g) THE COMPANION ARM, MEASURED ON A LIVE BODY ──────────────────────
	#
	# **DK §1's RULE MET WITH A MEASUREMENT RATHER THAN WITH AN ARGUMENT.**
	# *Ally* is heroes AND companions, a beast's blows go through
	# `_companion_hit` and never enter the hero strike loop, and a widening that
	# changes no measurement is worse than the narrow word. This party is
	# ILLEGAL — two Hunter specs — and that is stated rather than hidden: no run
	# reaches it, and the fixture is what makes the arm drivable at all.
	ok(Classes.SPEC_IDS.get("hunter", []).has("sharpshooter")
			and Classes.SPEC_IDS.get("hunter", []).has("beastmaster"),
		"§2g: the two specs are no longer both Hunter — the unreachability this arm records has changed")
	ok(bm.passive_id == "pack",
		"§2g: seat %d is not the Beastmaster (passive `%s`)" % [int(SEAT["beastmaster"]),
			bm.passive_id])
	await scene._do_summon(bm, "canis")
	var comps: Array = scene.get("companions")
	ok(comps.size() >= 1, "§2g: no companion was summoned (%d)" % comps.size())
	if comps.size() < 1:
		return
	var beast: BattleUnit = comps[0]
	ok(beast.is_companion,
		"§2g: the summoned body is not flagged as a companion — the arm is driving a hero")
	_revive(mark, other)
	ss.second_resource = 0
	ss.last_attack_target = mark
	await scene._companion_hit(beast, mark, 5.0, 0)
	ok(ss.second_resource == pay,
		"§2g: a COMPANION striking the mark paid %d Focus, not %d — the card says ALLY and the code implements HERO"
			% [ss.second_resource, pay])
	_revive(mark, other)
	ss.second_resource = 0
	ss.last_attack_target = mark
	await scene._companion_hit(beast, other, 5.0, 0)
	ok(ss.second_resource == 0,
		"§2g: a companion striking a DIFFERENT enemy paid %d Focus" % ss.second_resource)


# ═══ §3 — THE `Overkill` COLLISION ═══════════════════════════════════════════
#
# **THIS BATCH RULED ON NOTHING HERE AND THE GATE IS WHY THE FINDING SURVIVES.**
# A collision reported in a batch report is a collision nobody reads again —
# `docs/reports/` is the one file class no instrument covers. These arms assert
# the FACT, so the day either node is renamed the gate says so and the record is
# corrected rather than quietly becoming false.
#
# **AND IT IS A LABEL COLLISION, NOT A BREAK (BR §1).** `Classes.pool_ability`
# is keyed on an ABILITY `display_name`; nothing resolves a talent node by name,
# and these are two nodes in two trees with two ids. The arm below asserts the
# ids are distinct, which is the property that makes it safe — not an opinion
# that it is safe.

func _s3_the_collision() -> void:
	print("\n§3 — the `Overkill` collision, asserted and ruled on by nothing")
	var found: Array = []
	for ckey in Talents.LANE_TREES:
		for nd in Talents.LANE_TREES[ckey]:
			if String((nd as Dictionary).get("name", "")) == "Overkill":
				found.append({"key": String(ckey),
					"id": String((nd as Dictionary).get("id", "")),
					"lane": String((nd as Dictionary).get("lane", "")),
					"row": int((nd as Dictionary).get("row", 0))})
	ok(found.size() == 2,
		"§3: %d talent nodes are named `Overkill`, not the two FO confirmed — %s"
			% [found.size(), found])
	if found.size() != 2:
		return
	var ids: Array = []
	var trees: Array = []
	for f in found:
		ids.append(String((f as Dictionary)["id"]))
		trees.append(String((f as Dictionary)["key"]))
	ids.sort()
	trees.sort()
	ok(ids == ["bz_warcry", "ss_overkill"],
		"§3: the two `Overkill` ids are %s — FO's report names `bz_warcry` and `ss_overkill`" % [ids])
	ok(trees == ["berserker", "sharpshooter"],
		"§3: the two sit in %s — FO's report names the Berserker's and the Sharpshooter's" % [trees])
	ok(ids[0] != ids[1],
		"§3: the two nodes share an ID as well as a name — that IS a break, not a label collision")
	# **AND THE SHARPSHOOTER'S IS THE ONE THE RETIRED RUNE DUPLICATED**, which is
	# what ties §3 to §2: if that node's own text stops carrying the Focus clause,
	# the Wide Watch's retirement string stops being true.
	var ss_desc := ""
	for nd2 in Talents.LANE_TREES.get("sharpshooter", []):
		if String((nd2 as Dictionary).get("id", "")) == "ss_overkill":
			ss_desc = String((nd2 as Dictionary).get("desc", ""))
	ok(ss_desc.contains("Focus in FULL"),
		"§3: the Sharpshooter's Overkill no longer carries the Focus clause — the Wide Watch's retirement string is now false")
	# THE LANE THE SOURCE COMMENT NAMES. `talents.gd`'s own note beside
	# `bz_warcry` says the Sharpshooter's Overkill is in his **Precision** lane
	# and it is in **Penetration** — one word wrong in the one place a designer
	# reading the Berserker tree would meet it. FO corrected the comment; this is
	# what stops it drifting back.
	var lane := ""
	for f2 in found:
		if String((f2 as Dictionary)["id"]) == "ss_overkill":
			lane = String((f2 as Dictionary)["lane"])
	ok(lane == "Penetration",
		"§3: the Sharpshooter's Overkill sits in the `%s` lane" % lane)
	var tsrc: String = FileAccess.get_file_as_string("res://scripts/talents.gd")
	# **THE NEEDLE IS THE SENTENCE, NOT THE WORD, AND THE REASON IS THAT
	# `Precision` IS A REAL LANE — the SHARPSHOOTER's OWN Lane A** (Focus, crit
	# chance, crit damage), which is exactly why the wrong word was a natural
	# thing to write. A bare `"Precision lane"` needle would red the day anybody
	# writes a true sentence about that lane. The false CLAIM is the pairing, so
	# the pairing is what is pinned, in both directions.
	ok(not tsrc.contains("Precision lane already has"),
		"§3: `talents.gd` says the Sharpshooter's `Precision lane already has` a talent called Overkill again — it is his PENETRATION lane")
	ok(tsrc.contains("Penetration lane already has"),
		"§3: the note beside `bz_warcry` no longer names the lane at all — the correction was deleted rather than made")
	var precision_lane := false
	for nd3 in Talents.LANE_TREES.get("sharpshooter", []):
		if String((nd3 as Dictionary).get("lane", "")) == "Precision":
			precision_lane = true
	ok(precision_lane,
		"§3: the Sharpshooter has no `Precision` lane at all — the needle above is guarding the wrong thing")
	print("    Overkill x2: bz_warcry (berserker/Warpath/7), ss_overkill (sharpshooter/Penetration/7)")


# Both bodies back to full and alive before an arm. `check_dj` §1's idiom.
func _revive(a: BattleUnit, b: BattleUnit) -> void:
	for u in [a, b]:
		if u == null:
			continue
		u.dead = false
		u.hp = u.max_hp
