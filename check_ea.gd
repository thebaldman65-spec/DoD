# BATCH EA — A ZONE-BOSS AWARD ALWAYS PAYS.
#
#   §0  the premises §1's fix stands on, re-derived rather than inherited
#   §1  every spec's depth against the award count AFTER the fallback
#   §2  the announcement, driven on a real battle in TWO arms
#   §3  no assertion in the tree pins a BATCH CODE against `CLAUDE.md`
#   §4  the protected cores against comparable draft cards — a MEASUREMENT
#
# WHY §2 DRIVES A BATTLE INSTEAD OF READING THE SOURCE. The defect EA §1 closed
# was not a bad grant, it was SILENCE: `award_ability_pick` returned false and
# `battle._award_ability_picks` skipped the hero without a word, so the victory
# card did not name them. An assertion that `battle.gd` CONTAINS an
# announcement line would pass on a line no path reaches. **§2 resolves a real
# zone boss and reads the label off the end card**, in two arms — one where the
# fallback can pay and one where it cannot — because a control that only fires
# in the passing direction cannot tell an announcement from a constant.
#
# AND §4 IS PINNED AS NUMBERS ON DK §1's RULE. A ruling of the form "measured
# and left alone" is a claim about a code path, and a claim about a code path
# rots. Pinned this way, the day somebody re-prices a protected core this gate
# says the report is stale rather than staying quietly true.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ea.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The run save this gate's battles overwrite, and the scratch Profile it writes
# instead of the player's. Both restored at the end — a gate that eats a save
# is a gate nobody runs twice.
const REAL_SAVE := "user://run_save.bin"
const SCRATCH_PROFILE := "user://profile_check_ea.json"

var _g := Gate.new()
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()

# §4's table, built once inside a `-> void` section. It is NOT returned from
# anything: `check_da` §3b's rule is that a function RETURNING a collection
# built from two or more ability-source families is a hand-rolled corpus walk,
# and this reads both the protected cores and the spec draft pools.
var _rows: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260831)
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.data = {}

	print("BATCH EA — A ZONE-BOSS AWARD ALWAYS PAYS")
	_s0_premises()
	_s1_depth()
	await _s2_announcement()
	_s3_no_batch_code_pins()
	_s4_pricing()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	_g.report(self)


# ── §0 — THE PREMISES §1's FIX STANDS ON ────────────────────────────────────
# Each one is a fact about the code the rest of this gate reasons from, so the
# day one moves this gate says the report is stale instead of measuring a game
# that has changed underneath it.
func _s0_premises() -> void:
	print("\n§0 — the premises the fallback rests on")
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(rs != "", "§0: run_state.gd is readable")
	# (1) THE BOSS POOL IS STILL THE FIRST THING THE AWARD REACHES FOR. The
	# fallback is a SECOND draw, not a replacement — if this inverts, every
	# depth figure below is measuring the wrong channel.
	# **BATCH EH §1 — THE WINDOW IS THE WHOLE FUNCTION, OUT OF THE
	# COMMENT-STRIPPED SOURCE, AND BOTH HALVES OF THAT ARE REPAIRS.** EA read
	# `rs.substr(aw, 1400)` off the raw file, and this batch broke it twice over
	# in one edit: the third tier landed at offset 2113, a thousand characters
	# past the end of the window, so a premise added here would have been
	# asserted against text the window could not reach; and the comment
	# explaining it NAMES `CLASS_POOLS`, so the third premise below — which
	# exists to catch the deleted class-boss draw coming back — would have been
	# reading prose about a deletion as the deletion being undone. Stripping the
	# comments answers the second, and bounding on the next `func` answers the
	# first for good: this window is the function, whatever length it grows to.
	var code := Gate.strip_comments(rs)
	var aw := code.find("func award_ability_pick")
	ok(aw >= 0, "§0: `award_ability_pick` is gone — the channel this gate measures has moved")
	var aw_end := code.find("\nfunc ", aw + 1)
	var body := code.substr(aw, (aw_end - aw) if aw_end > aw else 2000)
	ok(body.contains("var offer := roll_spec_ability_offer(member)"),
		"§0: the award no longer opens on the SPEC BOSS pool (AN §4's standing ruling)")
	ok(body.contains("roll_spec_fallback_offer(member)"),
		"§0: the award no longer reads the fallback — EA §1's fix is gone")
	# **BATCH EH §1 — AND THE THIRD TIER IS A PREMISE HERE, NOT A LOOSENING OF
	# THE ONE BELOW IT.** The chain is boss -> spec draft -> class-wide, and §1's
	# arithmetic reads all three; if the last one goes, §1 is measuring a depth
	# nothing draws from.
	ok(body.contains("roll_class_fallback_offer(member)"),
		"§0: the award no longer reads the CLASS-WIDE third tier — EH §1's fix is gone")
	# THE ORDER IS PART OF THE RULING AND IS ASSERTED AS ORDER. A chain that
	# reached the class-wide pool before the hero's own spec draft pool would
	# pay a weaker card first and would pass every depth assertion in §1.
	ok(body.find("roll_spec_fallback_offer(member)")
			< body.find("roll_class_fallback_offer(member)"),
		"§0: the class-wide tier is read BEFORE the spec draft tier — the chain has inverted")
	# BOTH FORMS OF THE DELETED CONTAINER, WHICH THE RAW-SOURCE WINDOW COULD
	# NOT SAFELY ASK FOR: DY §3's own lesson is that eighteen files read
	# `CLASS_POOLS` and a grep for the constant found eleven, because the
	# accessor's callers never name it. `class_draft_pool(` is NOT a match for
	# either needle and is the live, curated pool DY's next sentence names.
	ok(not body.contains("class_pool(") and not body.contains("CLASS_POOLS"),
		"§0: the award reads the DELETED class boss pool again — the class draw is BACK")
	# (2) THE SECOND TIER IS SPEC-LOCKED AND DRAWS FROM THE DRAFT POOL. A second
	# tier that reached a class-wide pool would be a different ruling wearing
	# this one's name — **and after EH that is no longer a hypothetical, it is
	# the tier BELOW it.** Read off the stripped source for the same reason (1)
	# is: `roll_class_fallback_offer`'s header names `spec_draft_pool` in prose.
	var fb := code.find("func roll_spec_fallback_offer")
	ok(fb >= 0, "§0: `roll_spec_fallback_offer` is gone")
	var fb_end := code.find("\nfunc ", fb + 1)
	var fbody := code.substr(fb, (fb_end - fb) if fb_end > fb else 400)
	ok(fbody.contains("Classes.spec_draft_pool(spec)"),
		"§0: the fallback no longer draws from the hero's own SPEC DRAFT pool")
	ok(fbody.contains("owned_ability_names(member)"),
		"§0: the fallback no longer excludes what the hero already holds")
	ok(not fbody.contains("class_draft_pool"),
		"§0: the SPEC tier now reads the class-wide pool — the two tiers have merged")
	# (2b) BATCH EH §1 — AND THE THIRD TIER, ASKED THE SAME THREE QUESTIONS.
	# It is CLASS-wide by design and spec-locked by class: `class_of_spec` is
	# what keeps AN §4's ruling — nothing arrives that a sibling CLASS can
	# reach — while deliberately dropping the SPEC lock the tier above holds.
	var cb := code.find("func roll_class_fallback_offer")
	ok(cb >= 0, "§0: `roll_class_fallback_offer` is gone — EH §1's third tier has been deleted")
	var cb_end := code.find("\nfunc ", cb + 1)
	var cbody := code.substr(cb, (cb_end - cb) if cb_end > cb else 400)
	ok(cbody.contains("Classes.class_draft_pool("),
		"§0: the third tier no longer draws from `CLASS_DRAFT_POOLS` — DY §3's exemption is what makes it legal")
	ok(cbody.contains("Classes.class_of_spec(spec)"),
		"§0: the third tier no longer keys off the hero's own class")
	ok(cbody.contains("owned_ability_names(member)"),
		"§0: the third tier no longer excludes what the hero already holds")
	# AND NEITHER FALLBACK CONSULTS THE NO-RETURN LEDGER, WHICH IS THE ONE
	# JUDGEMENT CALL BOTH HEADERS RECORD. A tier that filtered on
	# `draft_refused` would be stricter than the channel it belongs to, and a
	# run that declined enough offers could drain the floor back below three.
	ok(not fbody.contains("draft_refused") and not cbody.contains("draft_refused"),
		"§0: a fallback tier now filters on the no-return ledger — that is the defect the chain exists to close")
	# (3) THE SILENT ARM IS GONE FROM THE VICTORY CARD'S LOOP.
	var bs := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bs.contains("func _award_ability_picks() -> Array:"),
		"§0: `_award_ability_picks` is gone — §2 is driving a loop that moved")
	ok(bs.contains("boss_text += \"\\n\\nNEW ABILITY: %s may choose one of three"),
		"§0: the victory card's award announcement has moved or been reworded")
	# (4) THE ARITHMETIC §1 IS DERIVED FROM.
	var run_gd := load("res://scripts/run_state.gd")
	ok(int(run_gd.SLOT_COUNT) == 3,
		"§0: the zone-boss award count is %d, not 3 — §1's table is stale" % int(run_gd.SLOT_COUNT))
	# BATCH EG §1 — THE CAP IS A LADDER AND §1'S ARITHMETIC READS ITS TOP RUNG.
	# EA asserted a flat 7 here so §1's floor could not go stale under it; the
	# same premise, re-derived: the deepest the fallback pool can be drained is
	# set by the LARGEST loadout a run can reach, which is the last rung.
	ok(run_gd.ABILITY_SLOTS_BY_BOSS == [7, 8, 9, 10],
		"§0: the slot ladder is %s, not [7, 8, 9, 10] — §1's floor arithmetic is stale" % [
			run_gd.ABILITY_SLOTS_BY_BOSS])
	ok(int(run_gd.ABILITY_SLOTS_BY_BOSS[0]) == 7,
		"§0: the ladder no longer OPENS at 7")


# ── §1 — EVERY SPEC'S DEPTH AGAINST THE AWARD COUNT, AFTER THE FALLBACK ─────
# **THE FIGURE THIS REPLACES IS 14 OF 36.** DZ §1 derived it: eight of the
# twelve specs can empty their boss pool, because both channels write the same
# `bm_abilities` list, so a drafted card removes itself from the boss offer.
# The Devout is the sharp case — his boss pool is 2 and BOTH entries are
# draftable, so all three of his awards could pay nothing.
#
# **THE STRUCTURE DID NOT MOVE AND IS NOT SUPPOSED TO.** Eight specs can still
# empty a BOSS pool; `check_dv` §2 measures that and still reads 8. What
# changed is what an emptied pool costs, and that is what this section
# measures: the fallback pool's DEPTH against the award's own offer size.
#
# THE RUNE DRAIN IS DERIVED, NOT ASSUMED. `owned_ability_names` cannot see an
# ability a rune grants — the grant lands on the battle `cfg`, never on the
# member dict — so a rune-granted card that also sits in a spec draft pool is
# one name the fallback can offer to a hero who already casts it. That is a
# PRE-EXISTING property of every channel (`roll_spec_ability_offer` and
# `draft_pool_left` share it), and it is carried here rather than waved off,
# because it is the only term that can push the floor below the slot
# arithmetic. Read off `runes.json` so a third granting rune is covered by
# doing nothing.
func _s1_depth() -> void:
	print("\n§1 — every spec's depth against the award count, after the fallback")
	var run_gd := load("res://scripts/run_state.gd")
	var awards: int = int(run_gd.SLOT_COUNT)
	# The LAST rung, not the first: §1 asks how deep the pool can be drained, and
	# the answer is set by the biggest loadout a run can hold.
	var cap: int = int(run_gd.ABILITY_SLOTS_BY_BOSS[
		run_gd.ABILITY_SLOTS_BY_BOSS.size() - 1])

	# THE RUNE DRAIN, PER SPEC. A rune counts only against a spec that can
	# actually WEAR it, which is what `scope` decides.
	var rune_drain := {}
	# BATCH EH §1 — THE SAME DRAIN, MEASURED AGAINST THE THIRD TIER TOO. It
	# reads ZERO today across all twelve, and that is worth deriving rather
	# than asserting from the outside: `Classes.vault_ability` and the rune
	# grants have crossed pools before, and a rune that ever grants a
	# class-wide card is the one term that can push the three-tier floor
	# somewhere this gate is not looking.
	var rune_drain_cls := {}
	var granting := 0
	var parsed = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var rune_rows: Array = []
	if parsed is Dictionary:
		for k in parsed:
			var v = parsed[k]
			if v is Array:
				rune_rows.append_array(v)
			elif v is Dictionary:
				rune_rows.append(v)
	elif parsed is Array:
		rune_rows = parsed
	ok(rune_rows.size() > 50,
		"§1: the rune walk read %d rows — runes.json's shape has moved and the drain is unmeasured" % rune_rows.size())
	for e in rune_rows:
		var d := e as Dictionary
		if d == null:
			continue
		var pay: Dictionary = d.get("payload", {})
		var gname := ""
		if pay.has("new_ability"):
			gname = String((pay["new_ability"] as Dictionary).get("display_name", ""))
		elif pay.has("grant_ability"):
			gname = String(pay["grant_ability"])
		if gname == "":
			continue
		granting += 1
		var scope := String(d.get("scope", "universal"))
		for cls in Classes.SPEC_IDS:
			for spec in Classes.SPEC_IDS[cls]:
				var wearable: bool = scope == "universal" \
					or scope == "class:%s" % String(cls) \
					or scope == "spec:%s" % spec
				if not wearable:
					continue
				if Classes.spec_draft_pool(spec).has(gname):
					rune_drain[spec] = int(rune_drain.get(spec, 0)) + 1
				if Classes.class_draft_pool(String(cls)).has(gname):
					rune_drain_cls[spec] = int(rune_drain_cls.get(spec, 0)) + 1
	print("    ability-granting runes: %d; reachable spec-draft collisions: %s; class-draft collisions: %s" % [
		granting, rune_drain, rune_drain_cls])

	var lost_after := 0
	var thinnest := 999
	var thinnest_spec := ""
	var emptiable := 0
	# BATCH EG §1 — THE SPECS WHOSE FALLBACK CAN FILL SHORT, AS A NAMED SET.
	var short_specs: Array = []
	for cls2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[cls2]:
			var boss: Array = Classes.spec_pool(spec2)
			var draft: Array = Classes.spec_draft_pool(spec2)
			var safe := 0
			for n in boss:
				if not draft.has(n):
					safe += 1
			if safe < awards:
				emptiable += 1
			# THE DEEPEST THE FALLBACK POOL CAN BE DRAINED: every earnable slot
			# spent on a draft card, plus every rune-granted name the filter
			# cannot see.
			var wide: Array = Classes.class_draft_pool(
				Classes.class_of_spec(spec2))
			var earn: int = cap - Classes.core_slots(spec2)
			var floor_now: int = draft.size() - earn - int(rune_drain.get(spec2, 0))
			# **BATCH EH §1 — THE THIRD TIER'S OWN DEPTH, AND IT IS THE SAME
			# ARITHMETIC ONE POOL WIDER.** The earnable slots drain ONE budget
			# across both draft pools — a hero cannot spend the same seven
			# slots twice — so the chain's floor is the two pools summed
			# against one `earn`, not two floors added.
			var floor_all: int = draft.size() + wide.size() - earn \
				- int(rune_drain.get(spec2, 0)) - int(rune_drain_cls.get(spec2, 0))
			if floor_now < thinnest:
				thinnest = floor_now
				thinnest_spec = spec2
			if floor_all < 1:
				lost_after += awards - mini(awards, safe)
			print("    %-13s boss=%d draft=%d class=%d safe=%d earnable=%d rune=%d+%d  tier2 floor=%d  tier2+3 floor=%d" % [
				spec2, boss.size(), draft.size(), wide.size(), safe, earn,
				int(rune_drain.get(spec2, 0)), int(rune_drain_cls.get(spec2, 0)),
				floor_now, floor_all])
			# **BATCH EG §1 — THIS WAS ONE ASSERTION AND IT WAS ASKING TWO
			# QUESTIONS.** EA wrote `floor_now >= awards` and worded it "it can
			# be paid nothing", and at a flat cap of seven the floor was six
			# everywhere so both readings were true and nobody had to separate
			# them. **THE RULE IN `CLAUDE.md` IS "AN AWARD ALWAYS PAYS", WHICH
			# IS `floor >= 1`; `>= awards` IS THE STRICTER CLAIM THAT EVERY
			# AWARD OFFERS A FULL THREE.** The slot ladder moves the floor to
			# exactly 3 for seven specs and to 2 for the Occultist, so the two
			# claims come apart here — and repairing the assertion TO ITS
			# INTENT (DC's rule) means splitting it rather than loosening it.
			ok(floor_now >= 1,
				"§1: %s's fallback pool floors at %d — it can be drained EMPTY and an award can pay nothing" % [
					spec2, floor_now])
			if floor_now < awards:
				short_specs.append(spec2)
			# **BATCH EH §1 — THE THIRD TIER IS ITS OWN QUESTION AND IT IS THE
			# STRICT ONE.** EG split EA's single assertion into the RULE
			# (`floor >= 1`, an award always pays) and the stricter claim that
			# every award offers a FULL THREE — and had to give the second one
			# up as a named-set exception, because the slot ladder took the
			# Occultist to 2. **THIS IS THAT CLAIM RESTORED, ACROSS THE CHAIN
			# RATHER THAN INSIDE EITHER HALF.** Neither assertion above is
			# widened by a character: they still ask what the SPEC tier alone
			# can do, which is the question the record needs to keep answering
			# the day somebody re-prices a spec draft pool.
			ok(floor_all >= awards,
				"§1: %s's chain floors at %d against %d awards — the class-wide tier does not restore a full offer" % [
					spec2, floor_all, awards])

	# **AND THE STRICTER HALF IS A NAMED SET NOW, ON `emptiable`'s OWN SHAPE.**
	# A pinned population rather than a pinned count: a THIRTEENTH spec whose
	# fallback can fill short trips, and so does the Occultist's leaving the
	# set, which is what a repair looks like from here.
	ok(short_specs == ["occultist"],
		"§1: the specs whose fallback can fill SHORT are %s, not the [occultist] on record — the slot ladder has moved under this table" % [
			short_specs])

	# **BATCH EG §1 — AND THE BOUND ABOVE IS NO LONGER THE ONLY ONE. REPORTED,
	# NOT ASSERTED, BECAUSE CLOSING IT IS A RULING.** `earn` is the LOADOUT
	# bound — the most a hero can CARRY — and EA could use it as the drain
	# because carrying and holding were the same list. **EG §2 SPLIT THEM: a
	# benched card stays in the pool and `owned_ability_names` reads the pool,
	# so the fallback's filter is drained by everything a hero has EVER taken,
	# which the slot cap does not bound at all.** The true worst case is a hero
	# who drafts his entire spec pool, and that floors at ZERO. It is not
	# asserted because the arithmetic that would make it safe is a design
	# decision EA priced and did not take (a class-wide third tier), and a gate
	# encodes a ruling.
	# **BATCH EH §1 — AND THE THIRD TIER DID NOT CLOSE IT, WHICH IS SAID HERE
	# BECAUSE THE BRIEF'S REASON FOR TAKING IT WAS THAT IT WOULD.** The brief
	# held that the class-wide pool "cannot empty — six cards per class, shared
	# across three specs, and no hero can hold another spec's picks". **THE
	# SECOND HALF IS TRUE AND THE FIRST DOES NOT FOLLOW FROM IT.** No SIBLING
	# drains it — every hero filters this pool against his own
	# `owned_ability_names`, so three specs sharing six cards is three
	# independent sixes. But the hero himself can: roughly one draft card in
	# four is class-wide, and `draft_card_is_class` returns TRUE unconditionally
	# once the spec side is dry, so a hero who takes at every offer drains his
	# spec pool and then this one. **EA's spec-pool floor was true when written
	# and stopped being true one batch later; asserting an unemptiable class
	# pool here would be the identical mistake one tier down.**
	#
	# WHAT HOLDS THE FLOOR UP IS ARITHMETIC, NOT STRUCTURE, AND IT IS PRINTED:
	# emptying the chain means OWNING every name in both draft pools, and a
	# draft offer pays at most ONE card. That is the number below.
	var take_budget: int = 999
	var take_spec := ""
	for cls3 in Classes.SPEC_IDS:
		for spec3 in Classes.SPEC_IDS[cls3]:
			var need: int = Classes.spec_draft_pool(spec3).size() \
				+ Classes.class_draft_pool(String(cls3)).size() \
				- int(rune_drain.get(spec3, 0)) - int(rune_drain_cls.get(spec3, 0))
			if need < take_budget:
				take_budget = need
				take_spec = spec3
	print("    EH §1 REPORTED, NOT ASSERTED — under the POOL bound (a hero who keeps every card he ever took) the chain still floors at 0. Emptying it costs %d distinct taken cards at the cheapest spec (%s), one card per offer. The LOADOUT bound above is what is asserted." % [
		take_budget, take_spec])

	# THE ANSWER TO THE QUESTION §1 ASKS, STATED AS A PROPERTY.
	ok(lost_after == 0,
		"§1: %d zone-boss awards can still pay nothing — the fallback does not close the table" % lost_after)
	# AND THE PREMISE THAT MAKES THE FIX WORTH HAVING: the boss pools can still
	# empty. If this ever reads 0 the fallback is dead code, and that is worth
	# being told rather than discovering.
	ok(emptiable == 8,
		"§1: %d specs can empty a boss pool, not the 8 on record — DZ §1's population has moved" % emptiable)
	print("  awards=%d  emptiable boss pools=%d  lost awards after the fallback=%d  thinnest fallback=%s(%d)" % [
		awards, emptiable, lost_after, thinnest_spec, thinnest])


# ── §2 — THE ANNOUNCEMENT, ON A REAL BATTLE, IN TWO ARMS ────────────────────
# ARM A empties every hero's BOSS pool and leaves the draft pool alone: the
# award must pay AND the victory card must name them. ARM B empties EVERY tier:
# the award cannot pay, so the announcement must be ABSENT — and the end card
# must still be there, which is what proves arm B's absence is the award's
# absence rather than a probe that stopped working.
#
# **BATCH EH §1 — ARM B WENT RED AND WAS REPAIRED TO ITS INTENT, NOT LOOSENED.**
# EA wrote it as "empty BOTH pools", because both was all there were; the
# class-wide third tier then paid a real card into an arm built to prove
# silence, and the arm failed for the right reason — it is measuring an
# announcement, and the announcement was correct. **The QUESTION is unchanged
# and is the one that matters: is the announcement conditional on an award
# actually being made, or is it a line the card always prints?** Answering it
# now costs one more pool. The arm is deliberately written against the CHAIN
# rather than against two named rollers, so a FOURTH tier would fail here
# loudly instead of quietly turning arm B vacuous.
func _s2_announcement() -> void:
	print("\n§2 — the award pays and is ANNOUNCED, driven on a real zone boss")
	var run: Node = root.get_node("/root/Run")

	var scene: Node = await Gate.spawn(self,
		["berserker", "pyromancer", "inquisitor", "beastmaster"])
	ok(Gate.flags_are_inert(scene), "§2: the fixture's headless premise still holds")
	for m in run.party:
		m["bm_abilities"] = Classes.spec_pool(String(m["spec"])).duplicate()
	for m in run.party:
		ok((run.roll_spec_ability_offer(m) as Array).is_empty(),
			"§2A: %s's boss pool is exhausted, as the arm requires" % m["spec"])
		ok(not (run.roll_spec_fallback_offer(m) as Array).is_empty(),
			"§2A: ...and the fallback has something for %s" % m["spec"])
	scene._resolve_boss(120, false)
	await process_frame
	var txt := _label_text(scene, "NEW ABILITY")
	ok(txt != "",
		"§2A: the victory card does not announce the award — this is the SILENCE EA §1 exists to end")
	for m in run.party:
		# THE LABEL IS THE CARD'S OWN, NOT THE SPEC KEY. `_hero_label` reads
		# `SPEC_INFO`, so the Devout is announced as "Devout" and never as
		# "Inquisitor" — asserting the key here would have been a check that
		# fails on the one spec §1 was written for.
		var label: String = scene._hero_label(m)
		ok(txt.contains(label),
			"§2A: the card does not name the %s (label '%s')" % [m["spec"], label])
		ok(int(m.get("bm_picks_owed", 0)) == 1,
			"§2A: %s was not owed the pick the card just promised" % m["spec"])
	print("    A: %s" % txt.replace("\n", " "))
	scene.queue_free()
	await process_frame
	await process_frame

	var scene2: Node = await Gate.spawn(self,
		["berserker", "pyromancer", "inquisitor", "beastmaster"])
	for m2 in run.party:
		var sp := String(m2["spec"])
		m2["bm_abilities"] = Classes.spec_pool(sp).duplicate() \
			+ Classes.spec_draft_pool(sp).duplicate() \
			+ Classes.class_draft_pool(Classes.class_of_spec(sp)).duplicate()
	# THE ARM'S OWN PREMISE, ASSERTED BEFORE IT IS DRIVEN. An arm that proves
	# an absence has to show the absence is the award's — a hero whose chain
	# still had something to offer would make the silence below a bug this gate
	# reported as a pass.
	for m_pre in run.party:
		ok((run.roll_spec_ability_offer(m_pre) as Array).is_empty()
				and (run.roll_spec_fallback_offer(m_pre) as Array).is_empty()
				and (run.roll_class_fallback_offer(m_pre) as Array).is_empty(),
			"§2B: %s's chain still has something to offer — the arm is not set up" % m_pre["spec"])
	scene2._resolve_boss(120, false)
	await process_frame
	ok(_label_text(scene2, "NEW ABILITY") == "",
		"§2B: the card announces an award nobody was given — the announcement is unconditional")
	ok(_label_text(scene2, "THE ZONE IS CLEANSED") != "",
		"§2B: the end card is missing entirely, so arm B proves nothing about the announcement")
	for m3 in run.party:
		ok(int(m3.get("bm_picks_owed", 0)) == 0,
			"§2B: %s was owed a pick out of two empty pools" % m3["spec"])
	scene2.queue_free()
	await process_frame


# One helper, and it returns a String rather than a collection, so it is
# outside `check_da` §3b's rule by shape rather than by exemption.
func _label_text(n: Node, needle: String) -> String:
	if n is Label and String((n as Label).text).contains(needle):
		return String((n as Label).text)
	for c in n.get_children():
		var r := _label_text(c, needle)
		if r != "":
			return r
	return ""


# ── §3 — NO ASSERTION PINS A BATCH CODE AGAINST `CLAUDE.md` ─────────────────
# **THIS IS EA §2's REPAIR MADE PERMANENT.** CW's split ended batch narratives
# in that file and DZ's prune removed the last of them, so a check reading
# `CLAUDE.md.contains("BATCH XX")` is asserting that a structure which no
# longer exists is present — and each of the six EA re-pointed passed anyway,
# off a STANDING RULE that names the batch in passing. **A check that passes
# for a reason other than the one it states has stopped asking its question.**
#
# THE SWEEP MATCHES THE VARIABLE HOLDING THE FILE, NOT THE LITERAL. That is
# DZ §3's own lesson arriving as an instrument: a literal-presence pass cannot
# see `to_lower().contains(...)`, and a pass that greps for `CLAUDE.md` on the
# same line cannot see a needle three hundred lines below the read. What is
# swept here is every identifier ASSIGNED from either rule file, then every
# call on that identifier anywhere in the file.
#
# WIDENED AT BATCH EF §2 TO BOTH HALVES. The split sent a third of the rules to
# `docs/instrument-rules.md`, and a sweep bound to `CLAUDE.md` alone would have
# reported a clean tree with the whole instrument half outside its territory —
# EC §2's rule, arriving as a hole this batch would otherwise have dug itself.
# **Neither half narrates batches, so the question is the same on both.**
func _s3_no_batch_code_pins() -> void:
	print("\n§3 — no assertion pins a batch code against either rule file")
	var dir := DirAccess.open("res://")
	var files: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd") and (f.begins_with("check_") or f.begins_with("test_")):
				files.append(f)
	files.sort()
	ok(files.size() > 60, "§3: the sweep read %d suites and gates — the population has moved" % files.size())

	var assign := RegEx.new()
	assign.compile("var\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*:?=[^\\n]*" \
		+ "res://(?:CLAUDE\\.md|docs/instrument-rules\\.md)")
	var code := RegEx.new()
	code.compile("\\b(?:BATCH|Batch|batch)\\s+[A-Z]{1,3}\\b")
	var accused: Array = []
	var scanned := 0
	var readers := 0
	for f2 in files:
		var src := Gate.strip_comments(
			FileAccess.get_file_as_string("res://" + f2))
		var names: Array = []
		for m in assign.search_all(src):
			var nm := m.get_string(1)
			if not names.has(nm):
				names.append(nm)
		if names.is_empty():
			continue
		readers += 1
		for nm2 in names:
			var call := RegEx.new()
			call.compile("\\b" + nm2 + "\\s*\\.[A-Za-z_]+\\s*\\(\\s*\"([^\"]*)\"")
			for m2 in call.search_all(src):
				scanned += 1
				var lit := m2.get_string(1)
				if code.search(lit) != null:
					accused.append("%s: %s.contains(%s)" % [f2, nm2, lit])
	for a in accused:
		ok(false, "§3: %s pins a BATCH CODE in a document that no longer narrates batches" % a)
	ok(accused.is_empty(),
		"§3: no assertion pins a batch code against either rule file (%d literals across %d readers)" % [
			scanned, readers])
	# THE SWEEP IS PROVED NON-VACUOUS BY ITS OWN NUMBERS. A regex that matched
	# no reader, or no literal, would report "no violations" just as loudly.
	ok(readers >= 20,
		"§3: only %d files were found reading a rule file — the sweep is matching nothing" % readers)
	ok(scanned >= 40,
		"§3: only %d literals were swept — the call regex has stopped matching" % scanned)
	print("  %d readers, %d asserted literals, %d batch-code pins" % [
		readers, scanned, accused.size()])


# ── §4 — THE PROTECTED CORES AGAINST COMPARABLE DRAFT CARDS ─────────────────
# **MEASURED. RULED ON NOWHERE.** DZ §2 found Blessing of Zeal — a protected
# core — sitting ON its family's line on initiative and UNDER it on both cost
# and cooldown, and concluded that if either of that pair is mispriced it is
# the CORE, priced LOW. This section asks whether that is one card or the shape
# of the whole layer.
#
# CONTROLLED THREE WAYS, BECAUSE EACH CONFOUND IS REAL. **Same spec**, so the
# cost is the same currency — Rage against Mana is not a comparison. **Same
# role**, derived from the ability's own fields rather than authored. **Same
# initiative**, and `PURE_BUFFS` members excluded from both sides, because
# `Ability.make()` clamps every member to `BUFF_DELAY_CAP` and a clamped
# initiative is not a price anyone chose — DZ's central structural finding.
#
# THE COUNTER-ARGUMENT IS RECORDED WITH THE NUMBER SO IT TRAVELS WITH IT: a
# protected core arrives free with the spec and a draft card costs a pick, so
# a core being cheaper to CAST is not by itself a defect. That is exactly why
# this is a measurement and not a ruling.
func _s4_pricing() -> void:
	print("\n§4 — the protected cores against comparable draft cards (measurement)")
	_rows = []
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			var seen := {}
			for nm in Classes.protected_names(spec):
				if seen.has(nm):
					continue
				seen[nm] = true
				_add_row(spec, "core", nm)
			for nm2 in Classes.spec_draft_pool(spec):
				_add_row(spec, "draft", nm2)
	var cores: int = _rows.filter(func(r): return r["chan"] == "core").size()
	var drafts: int = _rows.filter(func(r): return r["chan"] == "draft").size()
	ok(cores > 30 and drafts > 100,
		"§4: the walk read %d cores and %d draft cards — the measurement is reading the wrong thing" % [
			cores, drafts])

	# THE CAP BINDS THE TWO LAYERS AT DIFFERENT RATES, WHICH EXTENDS DZ's
	# STRUCTURAL FINDING RATHER THAN REPEATING IT: the one instrument in the
	# project that prices an initiative reaches the DRAFT layer more than twice
	# as often as it reaches the cores.
	var core_capped: int = _rows.filter(func(r): return r["chan"] == "core" and r["capped"]).size()
	var draft_capped: int = _rows.filter(func(r): return r["chan"] == "draft" and r["capped"]).size()
	print("    under BUFF_DELAY_CAP:  cores %d of %d (%.1f%%)   draft %d of %d (%.1f%%)" % [
		core_capped, cores, 100.0 * core_capped / maxf(1, cores),
		draft_capped, drafts, 100.0 * draft_capped / maxf(1, drafts)])
	ok(draft_capped * cores > core_capped * drafts,
		"§4: the cap no longer binds the draft layer more often than the cores — DZ's structural finding has moved")

	var pairs := 0
	var core_cheaper := 0
	var core_dearer := 0
	var core_shorter := 0
	var core_longer := 0
	var favours_core := 0
	var against: Array = []
	for cls2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[cls2]:
			for c in _rows:
				if c["spec"] != spec2 or c["chan"] != "core" or c["capped"]:
					continue
				for d in _rows:
					if d["spec"] != spec2 or d["chan"] != "draft" or d["capped"]:
						continue
					if c["role"] != d["role"] \
							or absf(float(c["delay"]) - float(d["delay"])) > 0.001:
						continue
					pairs += 1
					var dc: int = int(c["cost"]) - int(d["cost"])
					var dd: int = int(c["cd"]) - int(d["cd"])
					if dc < 0: core_cheaper += 1
					elif dc > 0: core_dearer += 1
					if dd < 0: core_shorter += 1
					elif dd > 0: core_longer += 1
					if dc <= 0 and dd <= 0 and (dc < 0 or dd < 0):
						favours_core += 1
					if dc > 0 or dd > 0:
						against.append("%s: %s (%d, cd%d) vs %s (%d, cd%d)" % [
							spec2, c["name"], int(c["cost"]), int(c["cd"]),
							d["name"], int(d["cost"]), int(d["cd"])])
	print("    comparable pairs (same spec, same role, same initiative, cap excluded): %d" % pairs)
	print("    core cheaper on resource %d / dearer %d;  shorter on cooldown %d / longer %d" % [
		core_cheaper, core_dearer, core_shorter, core_longer])
	print("    pairs where the core is cheaper on an axis and dearer on neither: %d" % favours_core)
	for a2 in against:
		print("    counter-case: %s" % a2)
	ok(pairs >= 12,
		"§4: only %d comparable pairs — the measurement's population has collapsed" % pairs)
	# THE FINDING, PINNED AS A PROPERTY RATHER THAN AS A NUMBER. A hard count
	# would red on any pool growth; what is asserted is the DIRECTION, which is
	# the thing the designer is being asked to rule on.
	ok(favours_core * 2 > pairs,
		"§4: the protected cores are no longer systematically cheaper than comparable draft cards (%d of %d) — EA §3's finding is stale" % [
			favours_core, pairs])
	ok(core_dearer * 3 < core_cheaper,
		"§4: the cores' resource advantage has closed (%d cheaper against %d dearer) — EA §3's finding is stale" % [
			core_cheaper, core_dearer])


func _add_row(spec: String, chan: String, nm: String) -> void:
	var a: Ability = Classes.spec_pool_ability(spec, nm)
	if a == null:
		a = Classes.pool_ability(nm)
	if a == null:
		return
	_rows.append({"spec": spec, "chan": chan, "name": nm, "delay": a.delay,
		"cost": a.cost, "cd": a.cooldown, "role": _role_of(a),
		"capped": Ability.takes_delay_cap(a.special)})


# THE ROLE, DERIVED FROM THE ABILITY'S OWN FIELDS AND ORDERED SO THE STRONGEST
# SIGNAL WINS: a card that heals is a heal card even when it also chips.
func _role_of(a: Ability) -> String:
	if a.heal > 0 or Ability.HEAL_SPECIALS.has(a.special):
		return "heal"
	if Ability.SHIELD_SPECIALS.has(a.special):
		return "shield"
	if a.damage > 0 or Ability.DAMAGE_SPECIALS.has(a.special):
		return "aoe-damage" if (a.aoe or a.random_hits > 0) else "damage"
	if not a.applies_status.is_empty():
		return "debuff" if a.target == Ability.Target.ENEMY else "buff"
	return "buff"
