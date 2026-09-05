# BATCH EZ — THE FIRST TWENTY-ONE RUNES, AND THE TWO CONDITIONS THEY OBEY.
#
#   §0  THE POOL — 21 authored, all at 100g, all spec-scoped, every one tagged
#       and shaped, and the 65 ET retired still retired and still unreachable
#   §1  THE ARITHMETIC — the two fractions, driven at 4, 5 and 7 drafted cards,
#       and the PRIMARY-only count proved different from the both-tags census
#   §2  THE COUNTED SET — DRAFTED and EQUIPPED, never the pool and never the
#       core, asserted where those three sets differ by construction
#   §3  THE LEVER — a bench and a carry through the LIVE door, with the
#       condition re-read after each and the payload following it
#   §4  THE PAYLOADS — every one of the twenty-one lands its field on a live
#       spawn, and the eight gated ones are REFUSED when the condition fails
#   §5  THE READ SITES — driven on a live board where the number moves
#
# **WHY §1 AND §2 ARE SEPARATE SECTIONS.** "The fraction is right" and "the
# fraction is taken over the right cards" fail in completely different ways, and
# the second is the one a static check cannot see: a threshold computed against
# the POOL rather than the loadout, or against the whole bar rather than the
# drafted half, produces a perfectly sensible number that answers the wrong
# question. §2 builds a member where the three candidate sets give three
# DIFFERENT answers and asserts which one is read.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ez.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	_s0_the_pool()
	_s1_the_arithmetic()
	_s2_the_counted_set()
	await _s3_the_lever()
	await _s4_the_payloads()
	await _s5_the_read_sites()
	_g.report(self)


func _data() -> Dictionary:
	return JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))


# Every id authored at EZ — DERIVED as "not retired", never listed, so a
# twenty-second needs no line here and a retirement applied to one of these
# turns the section red rather than shrinking its population silently.
func _ez_ids() -> Array:
	var out: Array = []
	for id in _data():
		if String((_data()[id] as Dictionary).get("retired", "")) == "":
			out.append(String(id))
	out.sort()
	return out


func _member(class_key: String, spec: String, drafted: Array = []) -> Dictionary:
	return {"key": class_key, "spec": spec, "runes": [], "abilities": [],
		"earned_abilities": [], "bm_abilities": drafted.duplicate()}


# ── §0 — THE POOL ───────────────────────────────────────────────────────────
func _s0_the_pool() -> void:
	print("\n§0 — the pool: twenty-one authored, sixty-five retired")
	var data := _data()
	var ez := _ez_ids()
	ok(ez.size() == 21, "§0: %d entries carry no retirement, expected the 21 EZ authors"
		% ez.size())
	ok(data.size() == 86, "§0: the authored pool is %d entries, expected 86" % data.size())

	# **PRICE IS 100g FLAT, EVERY RUNE, AND IT IS ASSERTED AS AN EQUALITY.**
	# ES §1 removed the tiers and left pricing to the designer; EZ §0 rules the
	# number. A rune priced differently is the pool re-acquiring a power signal
	# the charter deliberately removed.
	var mispriced: Array = []
	var unscoped: Array = []
	var untagged: Array = []
	var unshaped: Array = []
	for id in ez:
		var e: Dictionary = data[id]
		if int(e.get("price", 0)) != 100:
			mispriced.append("%s(%d)" % [id, int(e.get("price", 0))])
		if not String(e.get("scope", "")).begins_with("spec:"):
			unscoped.append("%s(%s)" % [id, e.get("scope", "")])
		if (Runes.rune_tags(id) as Array).is_empty():
			untagged.append(id)
		if (Runes.rune_shape(id) as Array).is_empty():
			unshaped.append(id)
	ok(mispriced.is_empty(), "§0: every rune is 100g flat (%s)" % [mispriced])
	ok(unscoped.is_empty(), "§0: SCOPE IS SPEC ONLY for all twenty-one (%s)" % [unscoped])
	ok(untagged.is_empty(), "§0: every one carries an archetype tag (%s)" % [untagged])
	ok(unshaped.is_empty(), "§0: every one carries a §0 shape (%s)" % [unshaped])

	# FOUR SPECS, AND THE COUNTS THE BRIEF NAMES. Six for the Beastmaster.
	var per_spec := {}
	for id2 in ez:
		var sp := String((data[id2] as Dictionary)["scope"]).trim_prefix("spec:")
		per_spec[sp] = int(per_spec.get(sp, 0)) + 1
	ok(per_spec.size() == 4, "§0: four specs are authored (%s)" % [per_spec.keys()])
	ok(int(per_spec.get("occultist", 0)) == 5, "§0: the Occultist has 5")
	ok(int(per_spec.get("warden", 0)) == 5, "§0: the Warden has 5")
	ok(int(per_spec.get("sharpshooter", 0)) == 5, "§0: the Sharpshooter has 5")
	ok(int(per_spec.get("beastmaster", 0)) == 6, "§0: the Beastmaster has 6, not 5")

	# **THE SHAPE AND THE CONDITION AGREE, IN BOTH DIRECTIONS.** A rune labelled
	# THRESHOLD whose payload carries no `tag_threshold` advertises a gate it
	# does not have; a payload carrying one whose label omits it is a gate the
	# player is never told about. Neither is visible from one side alone.
	var shape_wrong: Array = []
	for id3 in ez:
		var shape: Array = Runes.rune_shape(id3)
		var cond: Dictionary = (data[id3] as Dictionary).get("payload", {}).get(
			"condition", {})
		var has_thr: bool = cond.has("tag_threshold")
		var has_brd: bool = bool(cond.get("tag_breadth", false))
		if shape.has("THRESHOLD") != has_thr:
			shape_wrong.append("%s THRESHOLD label/%s payload" % [
				id3, "yes" if has_thr else "no"])
		if shape.has("BREADTH") != has_brd:
			shape_wrong.append("%s BREADTH label/%s payload" % [
				id3, "yes" if has_brd else "no"])
		if not Runes.RUNE_TYPES.has(String(shape[0])):
			shape_wrong.append("%s: primary '%s' is not a type" % [id3, shape[0]])
		for i in range(1, shape.size()):
			if not Runes.RUNE_SECONDARIES.has(String(shape[i])):
				shape_wrong.append("%s: '%s' is not a secondary" % [id3, shape[i]])
	ok(shape_wrong.is_empty(),
		"§0: every label agrees with its payload's condition (%s)" % [shape_wrong])

	# **THE TAG A THRESHOLD NAMES IS ONE OF THE SEVEN.** A typo'd tag reads as a
	# count of zero, which passes every static check and turns the rune off
	# forever — the one failure mode of a string-keyed condition.
	var bad_tag: Array = []
	for id4 in ez:
		var c2: Dictionary = (data[id4] as Dictionary).get("payload", {}).get(
			"condition", {})
		if c2.has("tag_threshold") \
				and not Classes.TAG_ORDER.has(String(c2["tag_threshold"])):
			bad_tag.append("%s:%s" % [id4, c2["tag_threshold"]])
	ok(bad_tag.is_empty(), "§0: every threshold names one of the seven tags (%s)" % [bad_tag])
	print("    per spec: %s" % [per_spec])


# ── §1 — THE ARITHMETIC ─────────────────────────────────────────────────────
#
# **DRIVEN AT 4, 5 AND 7 DRAFTED CARDS — the three loadout sizes the ladder
# actually produces** (`ABILITY_SLOTS_BY_BOSS` is 7/8/9/10 against a 3-slot
# core, so the earned half runs 4 at zone 1 to 7 at the end). The brief's whole
# argument for a fraction is that it is the SAME COMMITMENT at each, and that is
# a property of the arithmetic which can be asserted rather than described.
func _s1_the_arithmetic() -> void:
	print("\n§1 — the two fractions, at 4, 5 and 7 drafted cards")
	# A card whose PRIMARY is the named tag, and one whose primary is not.
	var deb: Array = []
	var non: Array = []
	for nm in Classes.CARD_TAGS:
		if Classes.card_tag_primary(String(nm)) == "DEBUFF":
			deb.append(String(nm))
		elif Classes.card_tag_primary(String(nm)) == "DEFENSE":
			non.append(String(nm))
	ok(deb.size() >= 7 and non.size() >= 7,
		"§1: the corpus supplies enough single-primary cards to build the arms (%d/%d)"
			% [deb.size(), non.size()])

	# **HALF, AT EACH SIZE, AND THE BOUNDARY IS ASSERTED ON BOTH SIDES.** An odd
	# count is where a fraction rule is decided: at 5 drafted cards "half" is 3,
	# and an implementation rounding the other way would pass at 4 and at 7 and
	# be wrong exactly where a player is most likely to sit.
	var want := {4: 2, 5: 3, 7: 4}
	for n in [4, 5, 7]:
		var need: int = int(want[n])
		var at: Array = []
		for i in need:
			at.append(deb[i])
		for j in (n - need):
			at.append(non[j])
		ok(Runes.threshold_met(at, "DEBUFF"),
			"§1: %d of %d DEBUFF meets the threshold" % [need, n])
		var below: Array = at.duplicate()
		below[0] = non[n]
		ok(not Runes.threshold_met(below, "DEBUFF"),
			"§1: %d of %d does NOT" % [need - 1, n])
		ok(Classes.primary_tag_count(at, "DEBUFF") == need,
			"§1: ...and the count itself reads %d" % need)

	# **A THIRD, THE SAME WAY.** "Exceeds" is strict, so a tag sitting exactly
	# ON a third passes: at 6 cards a peak of 2 is fine and 3 is not.
	var six: Array = [deb[0], deb[1], non[0], non[1]]
	var mk: Array = []
	for nm2 in Classes.CARD_TAGS:
		if Classes.card_tag_primary(String(nm2)) == "BREAK":
			mk.append(String(nm2))
	six.append(mk[0])
	six.append(mk[1])
	ok(Classes.primary_tag_peak(six) == 2, "§1: the peak of a 2/2/2 six reads 2")
	ok(Runes.breadth_met_fraction(six), "§1: a peak of exactly a third PASSES breadth")
	var tipped: Array = six.duplicate()
	tipped[4] = deb[2]
	ok(Classes.primary_tag_peak(tipped) == 3, "§1: ...and 3/2/1 reads a peak of 3")
	ok(not Runes.breadth_met_fraction(tipped), "§1: ...which EXCEEDS a third and fails")

	# **PRIMARY-ONLY IS A DIFFERENT NUMBER FROM THE CENSUS, PROVED ON A CARD
	# WHERE THEY DIFFER.** ES §4's census counts BOTH tags; §0 rules the
	# conditions count the primary alone. If the two agreed everywhere this
	# distinction would be decoration — so the section finds a card whose
	# SECONDARY is DEBUFF and shows the two readings disagreeing.
	var second_deb := ""
	for nm3 in Classes.CARD_TAGS:
		var t: Array = Classes.CARD_TAGS[nm3]
		if t.size() == 2 and String(t[1]) == "DEBUFF":
			second_deb = String(nm3)
			break
	ok(second_deb != "", "§1: the corpus carries a card whose SECOND tag is DEBUFF (%s)"
		% second_deb)
	if second_deb != "":
		var one: Array = [second_deb]
		ok(Classes.tag_count(one, "DEBUFF") == 1,
			"§1: the ES census counts it (both tags)")
		ok(Classes.primary_tag_count(one, "DEBUFF") == 0,
			"§1: ...and the EZ count does NOT (primary only) — the two are different numbers")
		ok(not Runes.threshold_met(one, "DEBUFF"),
			"§1: ...so a one-card loadout of it does not meet the threshold")

	# **AND THE PRIMARY COUNTS PARTITION THE LIST**, which is the property the
	# fractions are read against: under the both-tags census the per-tag numbers
	# can sum past the card count, and "a third of them" would then be
	# meaningless. Asserted over a real seven-card loadout.
	var seven: Array = []
	for k in 4:
		seven.append(deb[k])
	for k2 in 3:
		seven.append(non[k2])
	var total := 0
	for t2 in Classes.TAG_ORDER:
		total += Classes.primary_tag_count(seven, String(t2))
	ok(total == seven.size(),
		"§1: the primary counts sum to the card count (%d/%d) — they PARTITION"
			% [total, seven.size()])

	# THE VACUOUS READING, NAMED RATHER THAN GUARDED. An empty drafted list
	# meets BOTH conditions — 0 >= 0 and 0 <= 0 — which is the literal reading
	# of §0's two rules and is reported in `docs/reports/EZ.md` §0b.
	ok(Runes.threshold_met([], "DEBUFF") and Runes.breadth_met_fraction([]),
		"§1: an EMPTY drafted list meets both, vacuously — the literal reading, on the record")


# ── §2 — THE COUNTED SET ────────────────────────────────────────────────────
#
# **THE ASSERTION A STATIC CHECK CANNOT MAKE.** A threshold read off the POOL
# instead of the loadout, or off the whole BAR instead of the drafted half,
# gives a perfectly sensible number for the wrong question — and every check in
# §1 would still pass. So this section builds a member where the three
# candidate sets are three DIFFERENT sizes with three DIFFERENT counts, and
# asserts which one the condition reads.
func _s2_the_counted_set() -> void:
	print("\n§2 — drafted and equipped: not the pool, not the core")
	var deb: Array = []
	var non: Array = []
	for nm in Classes.CARD_TAGS:
		if Classes.card_tag_primary(String(nm)) == "DEBUFF":
			deb.append(String(nm))
		elif Classes.card_tag_primary(String(nm)) == "DEFENSE":
			non.append(String(nm))

	# POOL: 4 DEBUFF + 2 other = 6.   EQUIPPED: 1 DEBUFF + 2 other = 3.
	# The pool reads 4 of 6 (meets); the equipped half reads 1 of 3 (does not).
	var m := _member("mage", "occultist", [deb[0], deb[1], deb[2], deb[3],
		non[0], non[1]])
	m["bm_equipped"] = [deb[0], non[0], non[1]]
	var run: Node = root.get_node("/root/Run")
	var pool: Array = run.earned_ability_names(m)
	var equipped: Array = run.equipped_ability_names(m)
	var bar: Array = run.loadout_ability_names(m)
	ok(pool.size() == 6 and equipped.size() == 3 and bar.size() > equipped.size(),
		"§2: the three candidate sets really are different sizes (%d pool / %d equipped / %d bar)"
			% [pool.size(), equipped.size(), bar.size()])
	ok(Runes.threshold_met(pool, "DEBUFF"),
		"§2: read off the POOL the threshold WOULD be met (4 of 6) — the wrong answer")
	ok(not Runes.threshold_met(equipped, "DEBUFF"),
		"§2: read off the EQUIPPED half it is NOT (1 of 3) — the right one")
	ok(Runes.drafted_names(m) == equipped,
		"§2: and `drafted_names` returns exactly the equipped earned list")
	ok(not Runes.loadout_condition_met({"tag_threshold": "DEBUFF"}, m),
		"§2: so the live condition door refuses it")

	# **THE CORE IS OUT, AND THAT IS ASSERTED WHERE IT DECIDES THE ANSWER.**
	# The Occultist's core carries Shadowrend and Hex of Ruin, both DEBUFF
	# primaries, so counting the bar would put 3 of 5 DEBUFF against the drafted
	# half's 1 of 3 — the threshold would be ON from the first fight and no
	# bench could turn it off, which is the exact failure ES §4 measured.
	ok(Runes.threshold_met(bar, "DEBUFF"),
		"§2: counting the whole BAR the threshold WOULD be met — the core alone carries it")
	ok(Classes.primary_tag_count(bar, "DEBUFF")
			> Classes.primary_tag_count(equipped, "DEBUFF"),
		"§2: ...because the protected core adds DEBUFF cards the player never chose")

	# A MEMBER THAT HAS NEVER BENCHED CARRIES NO `bm_equipped` KEY AND MUST READ
	# ITS POOL — the same fallback `Run.equipped_ability_names` takes, written
	# twice and asserted equal, because a static helper reading a different
	# default from the live one is invisible until a player benches nothing.
	var fresh := _member("mage", "occultist", [deb[0], deb[1], non[0]])
	ok(Runes.drafted_names(fresh) == run.equipped_ability_names(fresh),
		"§2: with nothing benched, the static read and the live read agree")


# ── §3 — THE LEVER ──────────────────────────────────────────────────────────
#
# **THE DESIGN IS THE SWAP, SO THE SWAP IS DRIVEN.** §0 says a condition that
# only recomputed at battle start would be a different feature; this drives
# `Run.unequip_earned_ability` and `Run.equip_earned_ability` — the two doors
# the loadout panel actually calls — and re-reads the condition after each.
func _s3_the_lever() -> void:
	print("\n§3 — the lever: a bench tips it, immediately")
	var run: Node = root.get_node("/root/Run")
	var deb: Array = []
	var non: Array = []
	for nm in Classes.CARD_TAGS:
		if Classes.card_tag_primary(String(nm)) == "DEBUFF":
			deb.append(String(nm))
		elif Classes.card_tag_primary(String(nm)) == "DEFENSE":
			non.append(String(nm))
	# 2 DEBUFF + 2 other = 2 of 4: met, on the boundary.
	var m := _member("mage", "occultist", [deb[0], deb[1], non[0], non[1]])
	m["bm_equipped"] = [deb[0], deb[1], non[0], non[1]]
	ok(Runes.threshold_met(Runes.drafted_names(m), "DEBUFF"),
		"§3: 2 of 4 DEBUFF meets the threshold")
	# BENCH ONE DEBUFF -> 1 of 3. The lever, pulled.
	ok(run.unequip_earned_ability(m, deb[0]), "§3: the bench door accepts the card")
	ok(Runes.drafted_names(m).size() == 3, "§3: the drafted count falls to 3")
	ok(not Runes.threshold_met(Runes.drafted_names(m), "DEBUFF"),
		"§3: ...and the threshold is OFF — one card tipped it, with no reload")
	# CARRY IT BACK -> 2 of 4 again. Reversible, which is EG §2's whole point.
	ok(run.equip_earned_ability(m, deb[0]), "§3: the carry door accepts it back")
	ok(Runes.threshold_met(Runes.drafted_names(m), "DEBUFF"),
		"§3: ...and the threshold is ON again — benching is free and reversible")

	# **BENCHING THE OTHER SIDE TIPS IT THE OTHER WAY**, which is the half that
	# proves the fraction is a fraction: removing a NON-debuff card raises the
	# ratio without adding anything.
	ok(run.unequip_earned_ability(m, non[0]), "§3: bench a card that is NOT the tag")
	ok(Classes.primary_tag_count(Runes.drafted_names(m), "DEBUFF") == 2
			and Runes.drafted_names(m).size() == 3,
		"§3: 2 of 3 now — the numerator did not move and the denominator did")
	ok(Runes.threshold_met(Runes.drafted_names(m), "DEBUFF"),
		"§3: ...and it still holds, which a fixed COUNT could never express")

	# THE SURFACE THE PLAYER READS, off the same numbers. ES requires the state
	# be visible; the two screens build their line through these.
	ok(Runes.threshold_line(Runes.drafted_names(m), "DEBUFF") == "2 of 3 — DEBUFF",
		"§3: the hero sheet's line reads '%s'"
			% Runes.threshold_line(Runes.drafted_names(m), "DEBUFF"))
	ok(Runes.breadth_line(Runes.drafted_names(m)).begins_with("peak "),
		"§3: ...and the breadth half has its own")
	await process_frame


# ── §4 — THE PAYLOADS ───────────────────────────────────────────────────────
#
# **EVERY ONE OF THE TWENTY-ONE IS APPLIED TO A REAL CFG AND ITS FIELD READ
# BACK.** `Talents.apply_payload` matches an ability payload on `display_name`,
# so a rune naming an ability the hero does not own applies SILENTLY and does
# NOTHING — which is why this is driven rather than read off the JSON.
func _s4_the_payloads() -> void:
	print("\n§4 — every payload lands, and the eight gated ones are refused")
	var data := _data()
	var gated := 0
	var landed := 0
	var missed: Array = []
	var not_refused: Array = []
	for id in _ez_ids():
		var e: Dictionary = data[id]
		var payload: Dictionary = Runes.build(id).get("payload", {})
		var stats: Dictionary = payload.get("stat", {})
		for extra in payload.get("also", []):
			for f in (extra as Dictionary).get("stat", {}):
				stats[f] = (extra as Dictionary)["stat"][f]
		if stats.is_empty():
			missed.append("%s: no stat field at all" % id)
			continue
		var cond: Dictionary = payload.get("condition", {})
		# THE ARM THAT MEETS THE CONDITION. An empty drafted list meets both
		# vacuously (§1), which is exactly what makes it the right MET arm here.
		var met := _member("mage", "occultist", [])
		var cfg_on := {"abilities": []}
		Talents.apply_payload(cfg_on, payload, 1, {"learned": {}, "member": met})
		var all_on := true
		for f2 in stats:
			if not cfg_on.has(f2):
				all_on = false
				missed.append("%s: %s did not land" % [id, f2])
		if all_on:
			landed += 1
		if cond.is_empty():
			continue
		gated += 1
		# THE ARM THAT FAILS IT. Built to fail BOTH shapes at once: seven cards
		# whose primary is all one tag is 7 of 7 — a peak far past a third — and
		# carries none of DEBUFF, DEFENSE or MARK unless that IS the tag, so the
		# arm is chosen against the rune's own tag.
		var fail_tag := "OFFENSE"
		if String(cond.get("tag_threshold", "")) == "OFFENSE":
			fail_tag = "BREAK"
		var stack: Array = []
		for nm in Classes.CARD_TAGS:
			if Classes.card_tag_primary(String(nm)) == fail_tag:
				stack.append(String(nm))
			if stack.size() >= 7:
				break
		var off := _member("mage", "occultist", stack)
		off["bm_equipped"] = stack
		var cfg_off := {"abilities": []}
		Talents.apply_payload(cfg_off, payload, 1, {"learned": {}, "member": off})
		for f3 in stats:
			if cfg_off.has(f3):
				not_refused.append("%s: %s landed with the condition FAILING" % [id, f3])
	ok(missed.is_empty(), "§4: every payload lands its field (%s)" % [missed])
	ok(landed == 21, "§4: %d of 21 landed" % landed)
	ok(gated == 8, "§4: %d runes carry a condition, expected 8" % gated)
	ok(not_refused.is_empty(),
		"§4: a gated payload landed anyway (%s)" % [not_refused])
	print("    21 payloads, %d of them gated, all refused when the condition fails" % gated)

	# **AND THE FIELDS ARE RUNE-OWNED**, which is EM's charter asserted rather
	# than claimed: every `rune_` field these twenty-one write has
	# `data/runes.json` as its ONLY writer anywhere in the project. Derived by
	# sweeping the comment-stripped source of every game script for a WRITE.
	var writers: Array = []
	for id2 in _ez_ids():
		for f4 in (Runes.build(id2).get("payload", {}).get("stat", {}) as Dictionary):
			var field := String(f4)
			if not field.begins_with("rune_"):
				continue
			for path in ["scripts/battle.gd", "scripts/unit.gd", "scripts/talents.gd",
					"scripts/classes.gd", "scripts/run_state.gd"]:
				var src := Gate.strip_comments(
					FileAccess.get_file_as_string("res://" + path))
				if src.contains("%s = " % field) or src.contains("%s += " % field):
					writers.append("%s writes %s" % [path, field])
	ok(writers.is_empty(),
		"§4: no script writes a rune-owned field — runes.json is the only writer (%s)"
			% [writers])
	await process_frame


# ── §5 — THE READ SITES ─────────────────────────────────────────────────────
#
# **A FIELD THAT LANDS AND IS NEVER READ IS A RUNE THAT READS AS WORKING.**
# That is DK's Empower measurement — attached perfectly, chip and tooltip
# included, paying exactly 1.0000 — and it is the failure this section exists
# for. Every assertion below drives the live board and reads the number the
# rune is supposed to have moved.
func _s5_the_read_sites() -> void:
	print("\n§5 — the read sites, driven on a live board")
	var scene: Node = await Gate.spawn(self, ["occultist", "warden",
		"sharpshooter", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var occ: BattleUnit = heroes[0]
	var wd: BattleUnit = heroes[1]
	var ss: BattleUnit = heroes[2]
	var bm: BattleUnit = heroes[3]

	# ---- Occultist: the threshold IS the function, both ways ----
	ok(scene._ruin_threshold() == 10, "§5: Ruin detonates every 10th by default")
	occ.rune_hex_threshold = 8
	ok(scene._ruin_threshold() == 8, "§5: Deepening Hex moves it to 8")
	# **AND IT CANNOT UNDO THE CAPSTONE.** Avatar of Ruin installs 5; a rune
	# that ASSIGNED would push detonation back to 8 and read as working.
	occ.avatar_ruin = 5
	ok(scene._ruin_threshold() == 5,
		"§5: ...and with Avatar of Ruin held it stays 5 — the rune never makes it SHALLOWER")
	occ.avatar_ruin = 0
	occ.rune_hex_threshold = 0

	# ---- Occultist: the Wide Rite adds to the ONE function five sites call ----
	var mark_base: int = scene._old_gods_mark()
	occ.rune_wide_rite = 1
	ok(scene._old_gods_mark() == mark_base + 1,
		"§5: the Wide Rite marks one more (%d -> %d)" % [mark_base, scene._old_gods_mark()])
	occ.rune_wide_rite = 0

	# ---- Warden: he can no longer Block ----
	wd.block_chance = 0.5
	var bc_before: float = scene._live_block_chance(wd)
	wd.rune_no_block = 1
	ok(bc_before > 0.0 and scene._live_block_chance(wd) == 0.0,
		"§5: Bared Plate takes his live Block chance to zero (%.2f -> %.2f)"
			% [bc_before, scene._live_block_chance(wd)])
	wd.rune_no_block = 0

	# ---- Warden: the Split Shield halves the wall and reaches an ally ----
	# `_recast_writes` is the ONE function that says what a cast would lay, and
	# it is what the recast-refusal check reads — so driving it is driving the
	# same answer the cast itself uses rather than a second copy of it.
	var sw_ab: Ability = scene._find_ability(wd, "Shieldwall")
	ok(sw_ab != null, "§5: the Warden holds Shieldwall")
	var solo: Array = scene._recast_writes(wd, sw_ab, wd)
	ok(not solo.is_empty()
			and int((solo[0] as Dictionary)["power"]) == scene.SHIELDWALL_BLOCK,
		"§5: Shieldwall alone is worth %d" % scene.SHIELDWALL_BLOCK)
	ok(scene._recast_writes(wd, sw_ab, occ).is_empty(),
		"§5: ...and covers NO ally — the brief's premise, checked")
	wd.rune_split_shield = 1
	var split_self: Array = scene._recast_writes(wd, sw_ab, wd)
	var split_ally: Array = scene._recast_writes(wd, sw_ab, occ)
	ok(int((split_self[0] as Dictionary)["power"]) == scene.SHIELDWALL_BLOCK / 2,
		"§5: with the rune his own half is %d" % int((split_self[0] as Dictionary)["power"]))
	ok(not split_ally.is_empty()
			and int((split_ally[0] as Dictionary)["power"]) == scene.SHIELDWALL_BLOCK / 2,
		"§5: ...and the ally gets the same half")
	wd.rune_split_shield = 0

	# ---- Sharpshooter: the split point, and the RATE untouched ----
	ok(ss.focus_convert() == 100, "§5: Focus converts at 100 by default")
	ss.rune_heavy_bolts = 20
	ok(ss.focus_convert() == 80, "§5: Heavy Bolts moves it to 80")
	ss.second_resource_name = "Focus"
	ss.second_resource = 80
	# THE RATE IS THE THING ER'S RULE PROTECTS: 80 points of chance at
	# FOCUS_STEP is what "the point moved, the rate did not" has to mean.
	ok(abs(ss.focus_crit_chance() - 80 * BattleUnit.FOCUS_STEP) < 0.0001,
		"§5: ...and a point still buys exactly FOCUS_STEP — the rate never moved")
	ok(ss.focus_crit_mult() == 0.0, "§5: ...with nothing yet converted at exactly the point")
	ss.second_resource = 100
	ok(abs(ss.focus_crit_mult() - 20 * BattleUnit.FOCUS_STEP) < 0.0001,
		"§5: ...and 20 points past the new point convert")
	ss.rune_heavy_bolts = 0

	# ---- Sharpshooter: one more press at every stage, and the cost ----
	for f in [0, 50, 100, 150, 300]:
		ss.second_resource = f
		var base: int = scene._sequence_presses(ss)
		ss.rune_long_draw_presses = 1
		var withr: int = scene._sequence_presses(ss)
		ss.rune_long_draw_presses = 0
		ok(withr == base + 1,
			"§5: Long Draw adds a press at %d Focus (%d -> %d)" % [f, base, withr])
	# **THE COST, WHICH IS THE HALF THAT COULD SILENTLY NOT EXIST.** The fifth
	# press opens at the FOUR-press widening and then takes another taper step,
	# so its Good window is strictly narrower than the four-press sequence's
	# last press. A `SS_SEQ_OPEN` quietly extended to five entries would make
	# the rune a pure upside and nothing else would notice.
	ss.second_resource = 300
	var p4: Dictionary = scene._sharpshooter_basic_profile(ss)
	ss.rune_long_draw_presses = 1
	var p5: Dictionary = scene._sharpshooter_basic_profile(ss)
	ss.rune_long_draw_presses = 0
	ok(int(p4["presses"]) == 4 and int(p5["presses"]) == 5,
		"§5: four presses become five")
	ok(abs(float(p4["good_half"]) - float(p5["good_half"])) < 0.000001,
		"§5: ...the FIRST press's window is unchanged (the widening is not extended)")
	var last4: float = float(p4["good_half"]) * pow(float(p4["press_taper"]), 3)
	var last5: float = float(p5["good_half"]) * pow(float(p5["press_taper"]), 4)
	ok(last5 < last4,
		"§5: ...and the fifth press is NARROWER than the fourth was (%.4f < %.4f) — the cost is real"
			% [last5, last4])

	# ---- Beastmaster: the split point moves, through EU's own slot ----
	ok(scene._bond_convert(bm) == 8, "§5: Loyalty converts at 8 by default")
	bm.rune_long_leash = 3
	ok(scene._bond_convert(bm) == 11, "§5: the Long Leash moves it to 11")
	# AND THE HALVES STILL SUM TO THE METER, which is EU's invariant and the one
	# a moved point could break.
	for l in [5, 9, 11, 14, 20]:
		var paid: int = scene._bond_paid(bm, "ursus", l)
		var conv: int = scene._bond_converted(bm, "ursus", l)
		ok(paid + conv == l,
			"§5: ...and at %d Loyalty the halves still sum to the meter (%d + %d)"
				% [l, paid, conv])
	bm.rune_long_leash = 0

	# ---- Beastmaster: the Shared Hide reads what the beast already wears ----
	await scene._do_summon(bm, "ursus")
	var beast: BattleUnit = scene._beasts(bm)[0]
	ok(beast != null, "§5: a companion is on the field")
	ok(scene._shared_hide_mult(beast) == 1.0,
		"§5: without the rune the hide multiplier is exactly 1.0")
	# DK'S MEASUREMENT, REPRODUCED: Empower attaches to the beast and pays
	# nothing. It is the reason this rune exists and it is asserted, not quoted.
	scene._apply_status(beast, "empower", 3)
	ok(beast.has_status("empower"), "§5: Empower ATTACHES to the beast (DK's finding)")
	ok(scene._shared_hide_mult(beast) == 1.0,
		"§5: ...and pays exactly 1.0000 without the rune — DK's 1.0000, reproduced")
	beast.rune_shared_hide = 1
	ok(abs(scene._shared_hide_mult(beast) - 1.25) < 0.0001,
		"§5: ...and 1.25 with it — the buff it was already wearing finally pays")
	beast.rune_shared_hide = 0
	beast.remove_status("empower")

	# ---- Beastmaster: the Second Whistle, and it RAISES ----
	bm.loyalty["canis"] = 0
	bm.rune_second_whistle = 3
	await scene._do_summon(bm, "canis")
	ok(int(bm.loyalty.get("canis", 0)) >= 3,
		"§5: the Second Whistle fields Canis holding %d Loyalty"
			% int(bm.loyalty.get("canis", 0)))
	# **IT RAISES RATHER THAN ASSIGNS**, which is the failure mode a rune sold
	# on arriving devoted would have: a re-call into a deeper bond LOWERING it.
	bm.loyalty["aguila"] = 9
	await scene._do_summon(bm, "aguila")
	ok(int(bm.loyalty.get("aguila", 0)) >= 9,
		"§5: ...and a beast already at 9 arrives at %d — the rune RAISES, it never assigns"
			% int(bm.loyalty.get("aguila", 0)))
	bm.rune_second_whistle = 0

	# ---- Beastmaster: the Bared Fang's cost is a RULE, not an amount ----
	bm.rune_bared_fang = 0.30
	bm.loyalty["ursus"] = 0
	await scene._do_summon(bm, "ursus")
	var fanged: BattleUnit = null
	for b in scene._beasts(bm):
		if b.companion_kind == "ursus":
			fanged = b
	ok(fanged != null and fanged.no_heals,
		"§5: the Bared Fang's companion refuses all mending")
	if fanged != null:
		fanged.hp = maxi(fanged.max_hp / 2, 1)
		ok(fanged.heal_amount(50) == 0,
			"§5: ...and a 50-point heal into it lands exactly 0")
	bm.rune_bared_fang = 0.0
	scene.queue_free()
	await process_frame
