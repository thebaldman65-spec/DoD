# BATCH EA — A ZONE-BOSS AWARD ALWAYS PAYS.
#
#   §0  the premises §1's fix stands on, re-derived rather than inherited
#   §1  every class's depth against the award count AFTER the fallback, per engine set held
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

# The scratch Profile this gate writes instead of the player's, removed at the
# end. **THE RUN SAVE IS NO LONGER THIS FILE'S PROBLEM (Batch FI):** the path
# is redirected for the whole process by `Run._ready()`, so the backup this
# gate used to copy in and out — a `FileAccess.open(..., WRITE)` that truncates
# before it restores — is gone along with the forty others like it.
const SCRATCH_PROFILE := "user://profile_check_ea.json"

var _g := Gate.new()

# §4's table, built once inside a `-> void` section. It is NOT returned from
# anything: `check_da` §3b's rule is that a function RETURNING a collection
# built from two or more ability-source families is a hand-rolled corpus walk,
# and this reads the protected cores, the merged class pool and the boss pools.
var _rows: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260831)
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.data = {}

	print("BATCH EA — A ZONE-BOSS AWARD ALWAYS PAYS")
	_s0_premises()
	_s1_depth()
	await _s2_announcement()
	_s3_no_batch_code_pins()
	_s4_pricing()

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
	ok(body.contains("roll_draft_fallback_offer(member)"),
		"§0: the award no longer reads the fallback — EA §1's fix is gone")
	# **BATCH GP — THE CHAIN IS TWO TIERS AND IT WAS THREE.** EH §1's third tier
	# was the CLASS-WIDE pool read under the spec draft pool; the pool merge put
	# those two into one, so the tier above already offers everything the third
	# one held and `roll_class_fallback_offer` is deleted. **EH's requirement is
	# unchanged and is asserted on the tier that inherited it** — the fallback
	# must read the whole CLASS pool, or §1's arithmetic is measuring a depth
	# nothing draws from.
	#
	# THE ORDER IS STILL PART OF THE RULING AND IS STILL ASSERTED AS ORDER: a
	# chain that reached the draft pool before the hero's own boss pool would
	# pay the wrong card first and would pass every depth assertion in §1.
	ok(body.find("roll_spec_ability_offer(member)")
			< body.find("roll_draft_fallback_offer(member)"),
		"§0: the fallback is read BEFORE the boss pool — the chain has inverted")
	ok(not body.contains("roll_class_fallback_offer"),
		"§0: the award reads a third tier again — one pool has nothing left under it")
	# BOTH FORMS OF THE DELETED CONTAINER, WHICH THE RAW-SOURCE WINDOW COULD
	# NOT SAFELY ASK FOR: DY §3's own lesson is that eighteen files read
	# `CLASS_POOLS` and a grep for the constant found eleven, because the
	# accessor's callers never name it. `class_draft_pool(` is NOT a match for
	# either needle and is the live, curated SHELF DY's next sentence names.
	ok(not body.contains("class_pool(") and not body.contains("CLASS_POOLS"),
		"§0: the award reads the DELETED class boss pool again — the class draw is BACK")
	# (2) THE FALLBACK DRAWS FROM THE HERO'S CLASS POOL AND EXCLUDES WHAT HE
	# HOLDS. **It was SPEC-locked until the pool merge and is CLASS-locked now**,
	# which is the ruling: AN §4's guarantee — nothing arrives that a sibling
	# CLASS can reach — is what survives, and the SPEC lock is what the merge
	# spends. Read off the stripped source for the same reason (1) is.
	var fb := code.find("func roll_draft_fallback_offer")
	ok(fb >= 0, "§0: `roll_draft_fallback_offer` is gone")
	var fb_end := code.find("\nfunc ", fb + 1)
	var fbody := code.substr(fb, (fb_end - fb) if fb_end > fb else 600)
	ok(fbody.contains("Classes.draft_pool("),
		"§0: the fallback no longer draws from the hero's own CLASS pool")
	ok(fbody.contains("owned_ability_names(member)"),
		"§0: the fallback no longer excludes what the hero already holds")
	# BATCH GK — keyed to `member["key"]`, the hero's own class with no lineage
	# in the way, so a hero who took a spine reaches it too.
	ok(fbody.contains("String(member.get(\"key\", \"\"))"),
		"§0: the fallback no longer keys off the hero's own class")
	# **BATCH GP — AND IT ASKS THE ENGINE GATE.** A zone-boss award paying a card
	# the hero can never cast is GP §2's defect arriving through the other
	# channel, and the two channels share one answer (`Classes.offerable`).
	ok(fbody.contains("Classes.offerable("),
		"§0: the fallback does not ask the engine gate — a zone boss can award a dead card")
	# AND THE FALLBACK DOES NOT CONSULT THE NO-RETURN LEDGER, WHICH IS THE ONE
	# JUDGEMENT CALL ITS HEADER RECORDS. A tier that filtered on
	# `draft_refused` would be stricter than the channel it belongs to, and a
	# run that declined enough offers could drain the floor back below three.
	ok(not fbody.contains("draft_refused"),
		"§0: the fallback now filters on the no-return ledger — that is the defect the chain exists to close")
	# (3) THE SILENT ARM IS GONE FROM THE VICTORY CARD'S LOOP.
	var bs := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bs.contains("func _award_ability_picks() -> Array:"),
		"§0: `_award_ability_picks` is gone — §2 is driving a loop that moved")
	# BATCH GF — RE-POINTED, NOT DELETED. The card said a hero may choose one
	# of THREE, and an award can offer fewer (FM §3: a count written into a
	# sentence is a lie the day the offer can come back short), so GF took the
	# figure out of the sentence. The pin still asks what it was written to ask:
	# is the award announced on the victory card.
	ok(bs.contains("boss_text += \"\\n\\nNEW ABILITY: %s may choose one"),
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


# ── §1 — EVERY CLASS'S DEPTH AGAINST THE AWARD COUNT, PER ENGINE SET HELD ────
# **THE FIGURE THIS REPLACES IS 14 OF 36.** DZ §1 derived it: eight of the
# twelve specs can empty their boss pool, because both channels write the same
# `bm_abilities` list, so a drafted card removes itself from the boss offer.
# The Devout is the sharp case — his boss pool is 2 and BOTH entries are
# draftable, so all three of his awards could pay nothing.
#
# **THE STRUCTURE DID NOT MOVE AND IS NOT SUPPOSED TO.** Eight lineages can
# still empty a BOSS pool; `check_dv` §2 measures that and still reads 8. What
# changed is what an emptied pool costs, and that is what this section
# measures: the fallback pool's DEPTH against the award's own offer size.
#
# **BATCH HJ — RE-DERIVED OVER CLASS × ENGINES HELD, AND THIS IS WHAT MOVED.**
# From EA to HJ this walked the twelve LINEAGES, and each one's fallback depth
# was its own SHELF (EA's tier) and the class-wide SHELF (EH's third tier),
# drained by the loadout a lineage opened with and holding no engine. **GP took
# both halves of that population away.** The fallback reads the class's ONE
# pool (`roll_draft_fallback_offer` → `Classes.draft_pool`, keyed by the class
# with no lineage in the way), so a sibling's shelf is as much his as his own;
# and it asks the ENGINE GATE (`Classes.offerable`), so what he can be paid is
# the pool less every card that reads an engine he does not hold — which the
# shelf arithmetic never subtracted: a Holy Cleric's shelf alone carried seven
# cards a Cleric without Mercy is never offered. **The unit that decides the
# depth is therefore the CLASS and the ENGINES HE HOLDS**, not the lineage: an
# engine can be dropped and swapped, to nothing (GK), and the lineage outlives
# the engine it was chosen with (HE §3). So every class is walked with every
# set of engines a hero of it can hold slotted — none, one of his six, or two
# (`ENGINE_SLOTS`) — twenty-two sets a class, and each set is asked what the
# door would offer, drained by the loadout that set leaves him (Lethal Aim
# dismisses the pet, and the freed slot is one more earned card).
#
# THE RUNE DRAIN IS DERIVED, NOT ASSUMED. `owned_ability_names` cannot see an
# ability a rune grants — the grant lands on the battle `cfg`, never on the
# member dict — so a rune-granted card that also sits in the pool is one name
# the fallback can offer to a hero who already casts it. That is a PRE-EXISTING
# property of every channel (`roll_spec_ability_offer` and `draft_pool_left`
# share it), and it is carried here rather than waved off, because it is the
# only term that can push the floor below the slot arithmetic. Read off
# `runes.json` so a new granting rune is covered by doing nothing, and counted
# against what the door OFFERS for the set: a rune-granted card the gate
# withholds anyway drains nothing.
func _s1_depth() -> void:
	print("\n§1 — every class's depth against the award count, after the fallback, per engine set held")
	var run_gd := load("res://scripts/run_state.gd")
	var awards: int = int(run_gd.SLOT_COUNT)
	# The LAST rung, not the first: §1 asks how deep the pool can be drained, and
	# the answer is set by the biggest loadout a run can hold.
	var cap: int = int(run_gd.ABILITY_SLOTS_BY_BOSS[
		run_gd.ABILITY_SLOTS_BY_BOSS.size() - 1])

	# THE RUNE DRAIN, PER CLASS: every ability-granting rune a hero of the class
	# can WEAR, which is what `scope` decides (a class, or universal — HC §1).
	var granted_by_class := {}
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
			if scope == "universal" or scope == "class:%s" % String(cls):
				granted_by_class[String(cls)] = (granted_by_class.get(String(cls), []) as Array) + [gname]
	print("    ability-granting runes: %d; granted names a hero of each class can wear: %s" % [
		granting, granted_by_class])

	var lost_after := 0
	var thinnest := 999
	var thinnest_seat := ""
	var seats := 0
	# BATCH EG §1 — THE SEATS WHOSE FALLBACK CAN FILL SHORT, AS A NAMED SET.
	var short_seats: Array = []
	for cls2 in Classes.SPEC_IDS:
		var ck := String(cls2)
		var pool: Array = Classes.draft_pool(ck)
		# Every lineage a hero of the class can carry, and none: the lineage is
		# set by the engine he TOOK at class selection and outlives it (HE §3).
		var lineages: Array = [""] + Array(Classes.SPEC_IDS[cls2])
		var row_floors: Array = []
		for held in Gate.engine_sets(Classes.class_engines(ck), int(run_gd.ENGINE_SLOTS)):
			seats += 1
			var seat := "%s%s" % [ck, str(held)]
			var offered: Array = Classes.offerable(pool, held)
			# THE LOADOUT BOUND: the cap less the slots he OPENS using —
			# `ability_slots_used`'s own two terms, with the engines he holds, since
			# the kit he holds reads them (HB §4). Taken at the lineage that opens
			# using the fewest, because that one leaves the most earned cards.
			var opens := 999
			for lin in lineages:
				opens = mini(opens, Classes.lineage_slots(String(lin))
					+ Classes.kit_slots(ck, String(lin), held))
			var earn: int = cap - opens
			var drain := 0
			for g in granted_by_class.get(ck, []):
				if offered.has(g):
					drain += 1
			# THE DEEPEST THE FALLBACK CAN BE DRAINED UNDER THE LOADOUT BOUND: every
			# earnable slot spent on a card the door would offer him, plus every
			# rune-granted name the filter cannot see.
			var floor_n: int = offered.size() - earn - drain
			row_floors.append(floor_n)
			if floor_n < thinnest:
				thinnest = floor_n
				thinnest_seat = seat
			# **BATCH EG §1's SPLIT, KEPT: THE RULE AND THE STRICTER CLAIM ARE TWO
			# QUESTIONS.** `CLAUDE.md`'s rule is "an award always pays" — a floor of
			# at least ONE; that every award offers a FULL THREE is the stricter
			# claim EH restored across the chain. The chain is two tiers since GP and
			# the fallback is the last of them, so both are asked of it, per seat.
			# (Until HJ the first read the lineage's SHELF — EA's tier — and the
			# second the shelf plus the class-wide shelf — EH's; both shelves are one
			# pool, and the door filters it, so the two floors are one floor asked
			# at two thresholds.)
			ok(floor_n >= 1,
				"§1: a %s holding %s floors at %d — the fallback can be drained EMPTY and an award can pay nothing (%d offered, %d earnable, %d rune-granted)" % [
					ck, str(held), floor_n, offered.size(), earn, drain])
			if floor_n < awards:
				short_seats.append(seat)
			ok(floor_n >= awards,
				"§1: a %s holding %s floors at %d against %d awards — the fallback does not restore a full offer" % [
					ck, str(held), floor_n, awards])
			# THE LOST AWARDS, PER LINEAGE HE COULD CARRY: when the fallback cannot
			# pay, what is left is the boss tier's cards that drafting cannot take
			# (not in the pool) and the door still offers for this set.
			if floor_n < 1:
				for lin2 in lineages:
					var safe := 0
					for b in Classes.spec_pool(String(lin2)):
						if not pool.has(b) and not Classes.offerable([b], held).is_empty():
							safe += 1
					lost_after += awards - mini(awards, safe)
		row_floors.sort()
		print("    %-8s pool=%d  %d engine sets  fallback floor %d to %d  (a hero holding none: %d offered, %d earnable)" % [
			ck, pool.size(), row_floors.size(), int(row_floors[0]), int(row_floors[row_floors.size() - 1]),
			Classes.offerable(pool, []).size(),
			cap - Classes.kit_slots(ck, "", [])])

	# **AND THE STRICTER HALF IS A NAMED SET, ON `emptiable`'s OWN SHAPE.**
	# A pinned population rather than a pinned count: a seat whose fallback can
	# fill short trips, and so does one leaving the set, which is what a repair
	# looks like from here.
	# **BATCH GS read it empty on the live opening; BATCH HJ re-derived it over
	# class × engines held and it is still empty** — the thinnest seat is printed
	# below, and it floors far above three: a hero draws his class's whole pool
	# since GP, not one shelf. A seat whose fallback can fill short is a new
	# event, and this line trips on it.
	ok(short_seats.is_empty(),
		"§1: the seats whose fallback can fill SHORT are %s, not the none on record — the slot ladder, a pool or the engine gate has moved under this table" % [
			short_seats])

	# **BATCH EG §1 — AND THE BOUND ABOVE IS NO LONGER THE ONLY ONE. REPORTED,
	# NOT ASSERTED, BECAUSE CLOSING IT IS A RULING.** `earn` is the LOADOUT
	# bound — the most a hero can CARRY — and EA could use it as the drain
	# because carrying and holding were the same list. **EG §2 SPLIT THEM: a
	# benched card stays in the pool and `owned_ability_names` reads the pool,
	# so the fallback's filter is drained by everything a hero has EVER taken,
	# which the slot cap does not bound at all.** The true worst case is a hero
	# who drafts everything he can be offered, and that floors at ZERO. It is
	# not asserted because the arithmetic that would make it safe is a design
	# decision EA priced and did not take, and a gate encodes a ruling.
	# **BATCH EH §1 — AND THE THIRD TIER DID NOT CLOSE IT, WHICH IS SAID HERE
	# BECAUSE THE BRIEF'S REASON FOR TAKING IT WAS THAT IT WOULD.** No SIBLING
	# drains a pool — every hero filters it against his own
	# `owned_ability_names` — but the hero himself can: a hero who takes at every
	# offer drains what he can be shown. **EA's floor was true when written and
	# stopped being true one batch later; asserting an unemptiable pool here
	# would be the identical mistake one tier down.**
	#
	# **BATCH GP — THE TWO DRAFT POOLS ARE ONE POOL, AND THE GATE MAKES THE
	# FLOOR LOWER THAN ITS DEPTH.** Emptying the chain means owning every name
	# the hero can be OFFERED, which is his class pool less the cards that read
	# an engine he does not hold. **BATCH HJ — so the budget below is the
	# cheapest SEAT, class × engines held, off the live door.**
	#
	# WHAT HOLDS THE FLOOR UP IS ARITHMETIC, NOT STRUCTURE, AND IT IS PRINTED:
	# a draft offer pays at most ONE card. That is the number below.
	var take_budget: int = 999
	var take_seat := ""
	for cls3 in Classes.SPEC_IDS:
		var ck3 := String(cls3)
		for held3 in Gate.engine_sets(Classes.class_engines(ck3), int(run_gd.ENGINE_SLOTS)):
			var offered3: Array = Classes.offerable(Classes.draft_pool(ck3), held3)
			var need: int = offered3.size()
			for g3 in granted_by_class.get(ck3, []):
				if offered3.has(g3):
					need -= 1
			if need < take_budget:
				take_budget = need
				take_seat = "%s holding %s" % [ck3, str(held3)]
	print("    EH §1 REPORTED, NOT ASSERTED — under the POOL bound (a hero who keeps every card he ever took) the chain still floors at 0. Emptying it costs %d distinct taken cards at the cheapest seat (%s), one card per offer. The LOADOUT bound above is what is asserted." % [
		take_budget, take_seat])

	# THE ANSWER TO THE QUESTION §1 ASKS, STATED AS A PROPERTY — over every seat
	# and every lineage the seat could carry (BATCH HJ; it was per lineage shelf).
	ok(lost_after == 0,
		"§1: %d zone-boss awards can still pay nothing — the fallback does not close the table" % lost_after)
	# AND THE PREMISE THAT MAKES THE FIX WORTH HAVING: the boss pools can still
	# empty. If this ever reads 0 the fallback is dead code, and that is worth
	# being told rather than discovering.
	# **BATCH HJ — COUNTED AGAINST THE CLASS POOL.** A boss card empties out of the
	# boss offer the moment it is DRAFTED, and since GP it is drafted off any
	# shelf of the class: a boss card on a sibling's shelf is draftable too. It
	# read the lineage's own shelf until HJ (the eight happened to agree).
	var emptiable := 0
	for cls4 in Classes.SPEC_IDS:
		var pool4: Array = Classes.draft_pool(String(cls4))
		for spec4 in Classes.SPEC_IDS[cls4]:
			var safe4 := 0
			for b4 in Classes.spec_pool(String(spec4)):
				if not pool4.has(b4):
					safe4 += 1
			if safe4 < awards:
				emptiable += 1
	ok(emptiable == 8,
		"§1: %d lineages can empty a boss pool, not the 8 on record — DZ §1's population has moved" % emptiable)
	print("  awards=%d  seats=%d  emptiable boss pools=%d  lost awards after the fallback=%d  thinnest fallback=%s(%d)" % [
		awards, seats, emptiable, lost_after, thinnest_seat, thinnest])
	# **BATCH HJ — AND THE SEATS THEMSELVES, ASSERTED.** The short set and the
	# lost-award count are ABSENCES, and the two floor arms fire once per seat:
	# a walk that seated nobody passes all of them having asked nothing. So the
	# seats printed above are counted against the arithmetic of the classes'
	# engines — every set of up to ENGINE_SLOTS of them, none included — which
	# does not go through `Gate.engine_sets`.
	var want_seats := 0
	for cls5 in Classes.SPEC_IDS:
		var n5: int = Classes.class_engines(String(cls5)).size()
		for mask in range(1 << n5):
			var bits := 0
			for b5 in n5:
				if (mask & (1 << b5)) != 0:
					bits += 1
			if bits <= int(run_gd.ENGINE_SLOTS):
				want_seats += 1
	ok(seats == want_seats and seats > Classes.SPEC_IDS.size(),
		"§1: the floors above seated %d class × engine-set heroes, not the %d the classes' engines make (none, and every set of up to %d) — the floors, the short set and the lost awards read another population" % [
			seats, want_seats, int(run_gd.ENGINE_SLOTS)])


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
		ok(not (run.roll_draft_fallback_offer(m) as Array).is_empty(),
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
		# BATCH GP — the chain is the boss pool and the CLASS pool now.
		m2["bm_abilities"] = Classes.spec_pool(sp).duplicate() \
			+ Classes.draft_pool(Classes.class_of_spec(sp)).duplicate()
	# THE ARM'S OWN PREMISE, ASSERTED BEFORE IT IS DRIVEN. An arm that proves
	# an absence has to show the absence is the award's — a hero whose chain
	# still had something to offer would make the silence below a bug this gate
	# reported as a pass.
	for m_pre in run.party:
		ok((run.roll_spec_ability_offer(m_pre) as Array).is_empty()
				and (run.roll_draft_fallback_offer(m_pre) as Array).is_empty(),
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
# swept here is every identifier ASSIGNED from a rule file, then every
# call on that identifier anywhere in the file.
#
# WIDENED AT BATCH EF §2 TO BOTH HALVES. The split sent a third of the rules to
# `docs/instrument-rules.md`, and a sweep bound to `CLAUDE.md` alone would have
# reported a clean tree with the whole instrument half outside its territory —
# EC §2's rule, arriving as a hole this batch would otherwise have dug itself.
# **Neither half narrates batches, so the question is the same on both.**
# AND WIDENED AGAIN AT GR §2 TO `docs/combat-rules.md`, the rules about how a
# fight resolves, split out by subject. It narrates no batch either, and a pin
# written against it is a pin into a rule file like the other two.
func _s3_no_batch_code_pins() -> void:
	print("\n§3 — no assertion pins a batch code against any rule file")
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
		+ "res://(?:CLAUDE\\.md|docs/instrument-rules\\.md|docs/combat-rules\\.md)")
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
		"§3: no assertion pins a batch code against any rule file (%d literals across %d readers)" % [
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
# CONTROLLED THREE WAYS, BECAUSE EACH CONFOUND IS REAL. **Same class**, so the
# cost is the same currency — Rage against Mana is not a comparison. **Same
# role**, derived from the ability's own fields rather than authored. **Same
# initiative**, and `PURE_BUFFS` members excluded from both sides, because
# `Ability.make()` clamps every member to `BUFF_DELAY_CAP` and a clamped
# initiative is not a price anyone chose — DZ's central structural finding.
#
# **BATCH GU — THE POPULATION FOLLOWS THE POOLS.** It paired each lineage's
# SHELF with that lineage's cores until GU, which stopped being what a hero is
# offered at GP: he draws from his whole class pool, so the class-wide cards
# were in no pair, and a boss pick fills a slot as a drafted card does. It
# walks what `check_eb` §1 walks — every card a hero of the class can earn,
# against the class kit and every engine's enablers — because two pairings
# that disagree make the two gates' numbers incomparable. The class basic is
# left out on purpose, as the resolver always left it out: nothing is cheaper
# than a free card, so it could only swell the favouring count.
#
# THE COUNTER-ARGUMENT IS RECORDED WITH THE NUMBER SO IT TRAVELS WITH IT: a
# protected core arrives free with the spec and a draft card costs a pick, so
# a core being cheaper to CAST is not by itself a defect. That is exactly why
# this is a measurement and not a ruling.
func _s4_pricing() -> void:
	print("\n§4 — the protected cores against comparable draft cards (measurement)")
	_rows = []
	for cls in Classes.SPEC_IDS:
		var basic := String(Classes.kit(cls)[0].display_name)
		var seen := {}
		for spec in Classes.SPEC_IDS[cls]:
			for nm in Classes.protected_names(spec):
				if seen.has(nm) or String(nm) == basic:
					continue
				seen[nm] = true
				_add_row(cls, "core", nm)
		var earned := {}
		for nm2 in Classes.draft_pool(cls):
			earned[nm2] = true
		for spec2 in Classes.SPEC_IDS[cls]:
			for nm3 in Classes.spec_pool(spec2):
				earned[nm3] = true
		for nm4 in earned:
			_add_row(cls, "draft", nm4)
	var cores: int = _rows.filter(func(r): return r["chan"] == "core").size()
	var drafts: int = _rows.filter(func(r): return r["chan"] == "draft").size()
	ok(cores >= 16 and drafts >= 190,
		"§4: the walk read %d cores and %d earnable cards — the measurement is reading the wrong thing" % [
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
		for c in _rows:
			if c["group"] != cls2 or c["chan"] != "core" or c["capped"]:
				continue
			for d in _rows:
				if d["group"] != cls2 or d["chan"] != "draft" or d["capped"]:
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
						cls2, c["name"], int(c["cost"]), int(c["cd"]),
						d["name"], int(d["cost"]), int(d["cd"])])
	print("    comparable pairs (same class, same role, same initiative, cap excluded): %d" % pairs)
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


func _add_row(group: String, chan: String, nm: String) -> void:
	var a: Ability = Classes.pool_ability(nm)
	if a == null:
		return
	_rows.append({"group": group, "chan": chan, "name": nm, "delay": a.delay,
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
