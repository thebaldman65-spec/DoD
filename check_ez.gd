# BATCH EZ — THE FIRST TWENTY-ONE RUNES, AND THE TWO CONDITIONS THEY OBEY.
#
#   §0  THE POOL — 21 authored, all at 100g, all spec-scoped, every one tagged
#       and shaped, and the 65 ET retired still retired and still unreachable
#   §1  THE TWO CONDITIONS ARE RETIRED (Batch FN) — the payloads, the labels
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
	_s1_the_conditions_are_retired()
	_s2_the_lever()
	await _s3_the_lever_driven()
	await _s4_the_payloads()
	await _s5_the_read_sites()
	_g.report(self)


func _data() -> Dictionary:
	return JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))


# Every LIVE id — DERIVED as "not retired", never listed, so a twenty-second
# needs no line here.
#
# **BATCH FC — THE NAME OUTLIVED ITS POPULATION AND IS CORRECTED RATHER THAN
# LEFT TO READ TRUE.** This was "every id authored at EZ", which was the same
# set only while nothing EZ authored had been retired and nothing later had been
# authored. FC §3 makes both false at once: Split Tongue is an EZ author and is
# retired, the Shared Ruin is live and is not an EZ author, and the
# count is still 21 — so the OLD comment would have gone on reading correct
# while describing the wrong set. The DERIVATION never moved and the section's
# question never moved; only the sentence naming the population did.
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


# Every corpus card whose PRIMARY tag is `tag`, in `CARD_TAGS` order. The
# counts are 68 DEBUFF / 56 DEFENSE / 54 BREAK / 17 RESOURCE / 16 OFFENSE /
# 8 MARK / 8 TEMPO, so every tag can supply the six an arm below needs.
func _cards_of(tag: String) -> Array:
	var out: Array = []
	for nm in Classes.CARD_TAGS:
		if Classes.card_tag_primary(String(nm)) == tag:
			out.append(String(nm))
	return out


# ── §0 — THE POOL ───────────────────────────────────────────────────────────
func _s0_the_pool() -> void:
	# **BATCH FK MOVED THREE COUNTS AND NOT ONE RULE.** The pool went 21 -> 60
	# live and 87 -> 126 entries when FK authored the eight unauthored specs, so
	# every census in this section is a count of a population that grew. Each was
	# checked for a RULE hiding inside it before it was moved, and the two that
	# hold one — SCOPE IS SPEC ONLY, and price is flat 100g — are equalities over
	# the whole live pool and did not have to move at all.
	print("\n§0 — the pool: sixty live, sixty-six retired")
	var data := _data()
	var ez := _ez_ids()
	ok(ez.size() == 60, "§0: %d entries carry no retirement, expected 60 live runes"
		% ez.size())
	ok(data.size() == 126, "§0: the authored pool is %d entries, expected 126" % data.size())

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
	ok(unscoped.is_empty(), "§0: SCOPE IS SPEC ONLY for all sixty (%s)" % [unscoped])
	ok(untagged.is_empty(), "§0: every one carries an archetype tag (%s)" % [untagged])
	ok(unshaped.is_empty(), "§0: every one carries a §0 shape (%s)" % [unshaped])

	# **ALL TWELVE SPECS ARE AUTHORED AS OF BATCH FK, AND THE SHAPE OF THE
	# ASSERTION CHANGED WITH THE POPULATION.** It used to name four specs and
	# their four counts; naming twelve would be twelve lines that move again the
	# next time a set is re-sized. **The claim that is actually load-bearing is
	# that NO spec is empty** — a spec with an authored set of zero draws nothing
	# but the generated stat family, which is the state the whole rune layer
	# exists to leave — so that is what is asserted, with the two counts that ARE
	# rulings (the Beastmaster's extra, and the Devout's owed fifth) named beside
	# it.
	var per_spec := {}
	for id2 in ez:
		var sp := String((data[id2] as Dictionary)["scope"]).trim_prefix("spec:")
		per_spec[sp] = int(per_spec.get(sp, 0)) + 1
	ok(per_spec.size() == 12, "§0: %d specs are authored, not all 12 (%s)" % [
		per_spec.size(), per_spec.keys()])
	var empty_spec: Array = []
	for sp2 in Classes.all_specs():
		if int(per_spec.get(String(sp2), 0)) <= 0:
			empty_spec.append(sp2)
	ok(empty_spec.is_empty(),
		"§0: a spec has no authored rune and draws only the stat family — %s" % [empty_spec])
	ok(int(per_spec.get("beastmaster", 0)) == 6,
		"§0: the Beastmaster has 6, not 5 — his extra is a bare PASSIVE")
	# **THE DEVOUT HAS FOUR AND THE FIFTH IS OWED, NOT MISSING.** FK authored a
	# Rune of the Standing Ground whose clause is the base kit (Consecrated
	# Ground already kindles every hero standing in it, since AW §2), so it would
	# have shipped inert and was reported instead. `check_fk` §6 holds the
	# reason; this row holds the count, so the day the fifth arrives BOTH move.
	ok(int(per_spec.get("inquisitor", 0)) == 4,
		"§0: the Devout has %d, not the 4 FK shipped — his fifth is owed" % \
			int(per_spec.get("inquisitor", 0)))

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


# ── §1 — THE TWO CONDITIONS ARE RETIRED, AND THIS IS WHERE THEY WERE DRIVEN ──
#
# **THREE SECTIONS STOOD HERE AND BATCH FN COLLAPSED THEM INTO ONE.** §1 drove
# the two fractions at 4, 5 and 7 drafted cards and asserted the boundary on
# both sides; §2 built a member whose pool, equipped half and whole bar were
# three different sizes with three different counts and asserted WHICH one the
# condition read; §3 pulled the lever — a real bench and a real carry through
# `Run.unequip_earned_ability` / `equip_earned_ability` — and re-read the
# condition after each.
#
# **FK RETIRED THRESHOLD AND BREADTH GOING FORWARD AND FN TOOK THEM OFF THE
# EIGHT RUNES THAT STILL CARRIED ONE.** `Runes.threshold_met`,
# `breadth_met_fraction`, `drafted_names`, `loadout_condition_met`,
# `threshold_line`, `breadth_line` and `Classes.primary_tag_count` /
# `primary_tag_census` / `primary_tag_peak` are all gone, so there is no
# arithmetic to drive, no door to ask and no counted set to disagree about.
#
# **WHAT SURVIVES THE RETIREMENT IS THE LEVER, AND IT IS KEPT.** EG §2 split
# pool from loadout and made only the earned half swappable; that is what the
# conditions were reading, but it is not what the conditions were. The bench and
# the carry are driven below through the same two live doors, against
# `Run.equipped_ability_names` — which is where `battle.gd`'s spawn assembles a
# hero's bar and what the slot cap counts — so the half of this gate that was
# about the RUN rather than about the CONDITION still asks its question.
#
# **AND THE RETIREMENT ITSELF IS ASSERTED OVER EZ'S OWN TWENTY-ONE**, which is
# a different population from `check_fn` §1b's census of all 126 entries and
# `check_fd` §2's walk of the live pool. Three gates, three populations, one
# ruling: a re-gated rune fails whichever of the three its id lands in.
func _s1_the_conditions_are_retired() -> void:
	print("\n§1 — the two conditions are retired")
	var data := _data()
	var gated: Array = []
	var labelled: Array = []
	for id in _ez_ids():
		var cond: Dictionary = (data[id] as Dictionary).get("payload", {}).get(
			"condition", {})
		if cond.has("tag_threshold") or bool(cond.get("tag_breadth", false)):
			gated.append(String(id))
		var shape: Array = Runes.rune_shape(String(id))
		if shape.has("THRESHOLD") or shape.has("BREADTH"):
			labelled.append(String(id))
	ok(_ez_ids().size() >= 60,
		"§1: the live walk read %d runes — the two zeroes below are the walk's, not the pool's"
			% _ez_ids().size())
	ok(gated.is_empty(),
		"§1: %d live payloads carry a retired condition (%s)" % [gated.size(), gated])
	ok(labelled.is_empty(),
		"§1: %d live shape rows carry a retired secondary (%s)" % [labelled.size(), labelled])

	# **THE PREDICATES ARE GONE FROM THE SOURCE, NOT MERELY UNUSED.** A dead
	# function left standing is the thing a later batch wires back up without
	# a ruling, and `check_fn` §2 owns the whole census; this is EZ's own two.
	var rsrc := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/runes.gd"))
	ok(rsrc.length() > 1000, "§1: runes.gd read back short — the sweep read nothing")
	ok(not rsrc.contains("func threshold_met(")
			and not rsrc.contains("func breadth_met_fraction("),
		"§1: a retired condition predicate is defined again in `runes.gd`")
	ok(rsrc.contains("func tag_threshold_met(") and rsrc.contains("func breadth_met("),
		"§1: ES §4/§5's absolute-count shapes are gone too — they are KEPT, and they are the door a future rune comes back through")
	print("    0 of %d live runes gated; 0 labelled; both fraction predicates absent"
		% _ez_ids().size())


# ── §2 — THE LEVER, WHICH IS WHAT THE CONDITIONS WERE READING ────────────────
#
# **THE COUNTED SET WAS `Run.equipped_ability_names` AND IT STILL IS THE SET
# THAT MATTERS.** A hero's POOL is everything he has drafted and nothing ever
# leaves it; his LOADOUT is what he carries, capped at 7-to-10, and he can bench
# and carry freely between fights. **The three candidate sets are genuinely
# different sizes**, which is the fact that made the old §2 worth writing and is
# the fact a future loadout-reading rune will meet again — so it is asserted
# here rather than left to be re-discovered with the next one.
func _s2_the_lever() -> void:
	print("\n§2 — the lever: the pool, the equipped half and the whole bar")
	var run: Node = root.get_node("/root/Run")
	var deb: Array = _cards_of("DEBUFF")
	var non: Array = _cards_of("DEFENSE")
	ok(deb.size() >= 4 and non.size() >= 2,
		"§2: the corpus supplies enough single-primary cards to build the arms (%d/%d)"
			% [deb.size(), non.size()])
	# POOL: 4 DEBUFF + 2 other = 6.   EQUIPPED: 1 DEBUFF + 2 other = 3.
	var m := _member("mage", "occultist", [deb[0], deb[1], deb[2], deb[3],
		non[0], non[1]])
	m["bm_equipped"] = [deb[0], non[0], non[1]]
	var pool: Array = run.earned_ability_names(m)
	var equipped: Array = run.equipped_ability_names(m)
	var bar: Array = run.loadout_ability_names(m)
	ok(pool.size() == 6 and equipped.size() == 3 and bar.size() > equipped.size(),
		"§2: the three candidate sets really are different sizes (%d pool / %d equipped / %d bar)"
			% [pool.size(), equipped.size(), bar.size()])
	# **THE BAR IS THE EQUIPPED HALF PLUS THE PROTECTED CORE, AND THE GAP IS THE
	# CORE.** ES §4's screens count the bar; EZ's conditions counted the earned
	# half; the difference is what made the Occultist's core alone carry a DEBUFF
	# threshold. The relationship is arithmetic and it outlives both.
	var prot: int = (Classes.protected_names("occultist") as Array).size()
	ok(bar.size() == equipped.size() + prot,
		"§2: the bar is %d, not the equipped %d plus the %d protected names"
			% [bar.size(), equipped.size(), prot])
	# A MEMBER THAT HAS NEVER BENCHED CARRIES NO `bm_equipped` KEY AND MUST READ
	# ITS POOL — the same fallback `Run.equipped_ability_names` takes.
	var fresh := _member("mage", "occultist", [deb[0], deb[1], non[0]])
	ok(run.equipped_ability_names(fresh).size() == 3,
		"§2: with nothing benched the loadout reads the pool, not empty")


# ── §3 — A BENCH AND A CARRY, THROUGH THE TWO LIVE DOORS ─────────────────────
#
# **THE SWAP IS THE DESIGN, SO THE SWAP IS DRIVEN.** These are the two doors the
# loadout panel actually calls, and the property is EG §2's rather than EZ's: a
# bench takes a card out of the carried half and leaves it in the pool, and a
# carry puts it back. **It survives the retirement of the conditions because it
# was never about them** — `check_fh` §4 drives the same lever through the real
# screen and reads the tag census following it.
func _s3_the_lever_driven() -> void:
	print("\n§3 — the lever: a bench and a carry, immediately")
	var run: Node = root.get_node("/root/Run")
	var deb: Array = _cards_of("DEBUFF")
	var non: Array = _cards_of("DEFENSE")
	var m := _member("mage", "occultist", [deb[0], deb[1], non[0], non[1]])
	m["bm_equipped"] = [deb[0], deb[1], non[0], non[1]]
	ok(run.equipped_ability_names(m).size() == 4, "§3: the hero opens carrying four")
	ok(run.unequip_earned_ability(m, deb[0]), "§3: the bench door accepts the card")
	ok(run.equipped_ability_names(m).size() == 3, "§3: the carried count falls to 3")
	ok((run.earned_ability_names(m) as Array).has(deb[0]),
		"§3: ...and the benched card LEFT the pool — a bench is not a drop")
	ok(run.equip_earned_ability(m, deb[0]), "§3: the carry door accepts it back")
	ok(run.equipped_ability_names(m).size() == 4,
		"§3: ...and the carried count is 4 again — benching is free and reversible")
	await process_frame


# ── §4 — THE PAYLOADS ───────────────────────────────────────────────────────
#
# **EVERY ONE OF THE TWENTY-ONE IS APPLIED TO A REAL CFG AND ITS FIELD READ
# BACK.** `Talents.apply_payload` matches an ability payload on `display_name`,
# so a rune naming an ability the hero does not own applies SILENTLY and does
# NOTHING — which is why this is driven rather than read off the JSON.
func _s4_the_payloads() -> void:
	print("\n§4 — every payload lands, and none is refused")
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
		# **BATCH FN — THE MET ARM AND THE FAILING ARM ARE BOTH GONE, AND THE
		# REASON IS THAT THERE IS NOTHING LEFT TO MEET.** FA §1 made the MET arm
		# a real loadout per shape (an empty list used to satisfy both
		# vacuously); FN retired both shapes, so every payload is applied to a
		# member with NOTHING drafted and every one of them must land.
		# **`check_fn` §4 is where the failing arm went**: it drives each of the
		# eight on a loadout that WOULD have failed its old condition, with EZ's
		# retired predicate re-implemented in that gate as the arm's own control.
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
		if not cond.is_empty():
			gated += 1
			not_refused.append("%s carries %s" % [id, cond])
	ok(missed.is_empty(), "§4: every payload lands its field (%s)" % [missed])
	ok(landed == 60, "§4: %d of 60 landed" % landed)
	ok(gated == 0, "§4: %d runes carry a condition, and FN retired the last of them" % gated)
	ok(not_refused.is_empty(),
		"§4: a live payload is conditional again (%s)" % [not_refused])
	print("    60 payloads, %d of them gated, all landing on a hero with nothing drafted" % gated)

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


# BATCH FC §2 — SEED A MARK AT AN EXACT DEPTH, PRIMER OFF. `_gain_ruin` arms on
# every multiple, so a seeded board would arrive already primed and the arms
# below would be reading a detonation nobody drove. The primer is stripped
# after, never instead: the stacks must go through the real door so the chip,
# the depth stat and Covenant of Ash all see them exactly as the game does.
func _sr_seed(scene: Node, e: BattleUnit, n: int) -> void:
	e.remove_status("ruin")
	e.remove_status("ruin_primed")
	e.ruin_shared_in = false
	if n > 0:
		scene._gain_ruin(e, n)
	e.remove_status("ruin_primed")


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

	# ---- Occultist: SPLIT TONGUE WIDENS AND SAYS NOTHING ABOUT DAMAGE ----
	# **BATCH FB §1 — FA's 12% IS REVERTED AND THE CLAUSE IS REMOVED, NOT SET
	# BACK TO 20.** The payload is `{"aoe": true}` and nothing else. Writing
	# `{"aoe": true, "damage": 20}` would read identically TODAY and is the
	# thing this block refuses: a payload restating the card's own authored
	# value is a second copy of a magnitude, and it goes stale silently the day
	# Hex of Ruin is re-tuned.
	#
	# **SO THE SHAPE IS ASSERTED AS WELL AS THE VALUE, AND THE THIRD ARM IS THE
	# ONE THAT MATTERS.** "The rune-applied Ability reads 20" passes either way.
	# Moving the AUTHORED number and re-applying the payload is what separates
	# "the rune is silent about damage" from "the rune happens to assign the
	# same number" — and only the first survives a re-tune.
	var hex: Ability = scene._find_ability(occ, "Hex of Ruin")
	ok(hex != null, "§5: the Occultist holds Hex of Ruin")
	ok(hex != null and hex.damage == 20 and not hex.aoe and hex.choose_three,
		"§5: ...authored at 20%% of Attack against three chosen enemies — the BASE, untouched")
	# THE SHAPE: no `damage` key anywhere in the payload, in either half.
	var st_payload: Dictionary = Runes.build("split_tongue")["payload"]
	var st_set: Dictionary = st_payload.get("set", {})
	var st_add: Dictionary = st_payload.get("add", {})
	ok(not st_set.has("damage") and not st_add.has("damage"),
		"§5: ...and Split Tongue's payload names no damage at all (set: %s)" % [st_set])
	var st_cfg := {"abilities": [hex]}
	Talents.apply_payload(st_cfg, st_payload, 1, {"learned": {}, "member": {}})
	ok(hex != null and hex.damage == 20,
		"§5: ...so a rune-holding Occultist reads the SAME 20%% as one without it (reads %d)"
			% (hex.damage if hex != null else -1))
	ok(hex != null and hex.aoe,
		"§5: ...and the curse is spoken to the whole line")
	# THE RE-TUNE ARM. Move the authored number and apply the payload again:
	# the rune must carry the new value, not restore the old one.
	if hex != null:
		hex.damage = 33
		hex.aoe = false
		Talents.apply_payload({"abilities": [hex]}, st_payload, 1,
			{"learned": {}, "member": {}})
	ok(hex != null and hex.damage == 33 and hex.aoe,
		"§5: ...and a RE-TUNED Hex of Ruin keeps its new number through the rune (reads %d)"
			% (hex.damage if hex != null else -1))
	# **AND THE WIDENING IS WHAT DECIDES THE TARGETS, NOT THE FLAG BESIDE IT.**
	# `_resolve`'s branch is `if ab.aoe: ... elif ab.choose_two or ab.choose_three`,
	# so `choose_three` is still TRUE on the rune's version and is dead — which
	# is worth pinning, because a later batch reading the field would conclude
	# the card still picks three.
	ok(hex != null and hex.choose_three,
		"§5: ...while `choose_three` survives on the Ability and is DEAD — `aoe` wins the branch")
	# Restore, so the sections below read the board they were written against.
	if hex != null:
		hex.damage = 20
		hex.aoe = false

	# ---- Occultist: the Wide Rite adds to the ONE function five sites call ----
	var mark_base: int = scene._old_gods_mark()
	occ.rune_wide_rite = 1
	ok(scene._old_gods_mark() == mark_base + 1,
		"§5: the Wide Rite marks one more (%d -> %d)" % [mark_base, scene._old_gods_mark()])
	occ.rune_wide_rite = 0

	# ---- Occultist: THE RUNE OF THE SHARED RUIN (Batch FC §2) ----
	#
	# **A RUNE THAT COMPUTES A SURVIVOR COUNT AND NEVER MOVES A STACK WOULD PASS
	# EVERY STATIC CHECK.** So every arm below drives `_detonate_ruin` on a live
	# board and reads the stacks on BOTH bodies afterwards.
	var foes: Array = scene.get("enemies")
	ok(foes.size() == 3, "§5: the fixture board is three enemies (%d)" % foes.size())
	var sr_a: BattleUnit = foes[0]
	var sr_b: BattleUnit = foes[1]
	var sr_c: BattleUnit = foes[2]
	for sr_u in foes:
		sr_u.max_hp = 9999999
		sr_u.hp = 9999999

	# THE CONTROL ARM FIRST, AND IT IS NOT OPTIONAL: without the rune a
	# detonation must move nothing at all, or every reading below is measuring
	# the detonation rather than the rune.
	_sr_seed(scene, sr_a, 20)
	_sr_seed(scene, sr_b, 6)
	_sr_seed(scene, sr_c, 3)
	occ.rune_shared_ruin = 0
	scene._detonate_ruin(sr_a)
	ok(sr_a.status_stacks("ruin") == 20 and sr_b.status_stacks("ruin") == 6
			and sr_c.status_stacks("ruin") == 3,
		"§5: WITHOUT the rune a detonation moves no stack anywhere (%d/%d/%d)" % [
			sr_a.status_stacks("ruin"), sr_b.status_stacks("ruin"),
			sr_c.status_stacks("ruin")])

	# HALF, TO THE DEEPEST OTHER, AND THE THIRD BODY UNTOUCHED. The last clause
	# is what separates "the most Ruin" from "the board": a rune that spread the
	# share evenly would pass an assertion naming only the receiver.
	occ.rune_shared_ruin = 1
	_sr_seed(scene, sr_a, 20)
	_sr_seed(scene, sr_b, 6)
	_sr_seed(scene, sr_c, 3)
	scene._detonate_ruin(sr_a)
	ok(sr_a.status_stacks("ruin") == 10,
		"§5: the Shared Ruin takes HALF off the bearer (20 -> %d)"
			% sr_a.status_stacks("ruin"))
	ok(sr_b.status_stacks("ruin") == 16,
		"§5: ...and the enemy carrying the MOST Ruin receives them (6 -> %d)"
			% sr_b.status_stacks("ruin"))
	ok(sr_c.status_stacks("ruin") == 3,
		"§5: ...and the shallower body gets NOTHING — it is the deepest, not the board (%d)"
			% sr_c.status_stacks("ruin"))

	# **ROUNDING IS DOWN, AND IT IS ASSERTED ON AN ODD PILE**, which is the only
	# place the two roundings differ: 21 gives 10 away and keeps 11.
	_sr_seed(scene, sr_a, 21)
	_sr_seed(scene, sr_b, 4)
	_sr_seed(scene, sr_c, 0)
	scene._detonate_ruin(sr_a)
	ok(sr_a.status_stacks("ruin") == 11 and sr_b.status_stacks("ruin") == 14,
		"§5: ...half ROUNDS DOWN — 21 keeps 11 and sends 10 (%d / %d)" % [
			sr_a.status_stacks("ruin"), sr_b.status_stacks("ruin")])

	# **AND IT COSTS THE BEARER NO CADENCE**, which is a property of the
	# threshold rather than a coincidence: detonation arms on a MULTIPLE, so a
	# pile halved from a multiple is still exactly one threshold from its next.
	var sr_step: int = scene._ruin_threshold()
	_sr_seed(scene, sr_a, 2 * sr_step)
	_sr_seed(scene, sr_b, 0)
	_sr_seed(scene, sr_c, 0)
	scene._detonate_ruin(sr_a)
	var sr_climb := 0
	while not sr_a.has_status("ruin_primed") and sr_climb < 4 * sr_step:
		scene._gain_ruin(sr_a, 1)
		sr_climb += 1
	ok(sr_climb == sr_step,
		"§5: ...and the bearer is still exactly one threshold from its next blast (%d of %d)"
			% [sr_climb, sr_step])

	# **THE JUMP ARMS THE RECEIVER — THAT IS THE CASCADE THE RUNE IS FOR.**
	_sr_seed(scene, sr_a, 2 * sr_step)
	_sr_seed(scene, sr_b, 0)
	_sr_seed(scene, sr_c, 0)
	scene._detonate_ruin(sr_a)
	ok(sr_b.has_status("ruin_primed"),
		"§5: ...and the stacks it lands ARM the receiver — a fed mark detonates sooner")

	# **THE CHAIN IS BOUNDED AT TWO, BY CONSTRUCTION.** A fed detonation does
	# not feed onward. Unbounded, this rune was measured at **80 detonations
	# over 40 rounds from two marks and no further input** — the stacks slosh
	# between two bodies and every crossing re-arms the one they left. THE ARM
	# IS DRIVEN IN BOTH DIRECTIONS: the fed mark refuses, and the flag CLEARS,
	# so the very next detonation that body earns for itself jumps normally.
	ok(sr_b.ruin_shared_in,
		"§5: ...and the receiver is flagged as fed — the bound is armed")
	var sr_b_was: int = sr_b.status_stacks("ruin")
	scene._detonate_ruin(sr_b)
	ok(sr_b.status_stacks("ruin") == sr_b_was and not sr_b.ruin_shared_in,
		"§5: ...a FED detonation moves nothing onward and consumes the flag (%d -> %d)"
			% [sr_b_was, sr_b.status_stacks("ruin")])
	_sr_seed(scene, sr_b, 2 * sr_step)
	_sr_seed(scene, sr_a, 0)
	_sr_seed(scene, sr_c, 0)
	scene._detonate_ruin(sr_b)
	ok(sr_b.status_stacks("ruin") == sr_step and sr_a.status_stacks("ruin") == sr_step,
		"§5: ...and the SAME body jumps again the moment it primes itself (%d -> %d)"
			% [sr_b.status_stacks("ruin"), sr_a.status_stacks("ruin")])

	# **WITH NO OTHER BODY THE STACKS STAY.** A rune that DELETED Ruin on a
	# single-enemy board would read as working everywhere else.
	_sr_seed(scene, sr_a, 21)
	sr_b.dead = true
	sr_c.dead = true
	scene._detonate_ruin(sr_a)
	sr_b.dead = false
	sr_c.dead = false
	ok(sr_a.status_stacks("ruin") == 21,
		"§5: ...and with no other body alive the stacks STAY, never lost (%d)"
			% sr_a.status_stacks("ruin"))
	occ.rune_shared_ruin = 0
	for sr_u2 in foes:
		sr_u2.remove_status("ruin")
		sr_u2.remove_status("ruin_primed")
		sr_u2.ruin_shared_in = false

	# **AND IT DOES NOT FIRE ON REQUIEM, CONFIRMED RATHER THAN ASSUMED.**
	# Requiem consumes the whole pile and the primer with it and fires NO
	# detonation, so there is nothing to jump — but "there is nothing to jump"
	# is only true while the jump has ONE home. Both halves are asserted: the
	# rune's field is read at exactly one site in the comment-stripped source,
	# and Requiem's own handler does not reach that site.
	# **THE `res://` PATH IS ON THIS LINE ON PURPOSE, AND THE REASON IS ALREADY
	# A STANDING RULE.** `instrument-rules.md`'s ED §2 block names it as that
	# bug's SECOND FORM — *bind holders from STATEMENTS, which join
	# continuations, never from lines* — and `check_ed` §2 has not been repaired
	# to it: its holder regex is still `[^\n]*`, so a haystack whose path wraps
	# to a continuation line binds nothing and every pin read off it is invisible
	# to the completeness scan. Verified on this batch's own pins: written
	# wrapped, `check_ed` read **18 / 0 against a manifest missing five
	# entries**; written flat, it named all five. **The gate is not widened here**
	# — that is a change to its population — and the finding is in FC's report.
	var b_src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(b_src.count("rune_shared_ruin") == 1,
		"§5: the Shared Ruin has exactly ONE read site in battle.gd (%d)"
			% b_src.count("rune_shared_ruin"))
	# **THE ANCHOR CARRIES ITS INDENT AND ITS UNIQUENESS IS ASSERTED, BECAUSE
	# THE FIRST FORM OF THIS CHECK ANCHORED ON THE WRONG SITE.** Bare
	# `"requiem":` occurs TWICE — the bot's `ab.special == "requiem"` fifteen
	# thousand lines earlier, and the handler — so `find` landed on the targeting
	# code and the "no detonation" arm read a body that was never the handler:
	# green, and about nothing. **The paired POSITIVE arm is what exposed it**,
	# which is the only reason it is not still passing.
	var rq_key := "\n\t\t\"requiem\":"
	ok(b_src.count(rq_key) == 1,
		"§5: ...the handler's anchor names exactly one site (%d)" % b_src.count(rq_key))
	var rq_at := b_src.find(rq_key)
	var rq_end := b_src.find("\n\t\t\"penance\":", rq_at + 1)
	ok(rq_at > 0 and rq_end > rq_at, "§5: ...Requiem's handler is findable and bounded")
	var rq_body := b_src.substr(rq_at, rq_end - rq_at) if rq_end > rq_at else ""
	ok(rq_body.contains("remove_status(\"ruin\")"),
		"§5: ...it SPENDS the pile, which is the whole card — and is the arm that says the body is REALLY the handler")
	ok(not rq_body.contains("_detonate_ruin"),
		"§5: ...and Requiem fires no detonation, so the pile it spends never jumps")

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
