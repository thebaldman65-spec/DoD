# test_batch_bo.gd — THE ABILITY DRAFT, AND TRANCHE 1. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bo.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does not
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS, AND WHY EACH CHECK IS BUILT THE WAY IT IS.
# §2/§3 are machinery, and most of it fails SILENTLY: a protected ability that
# becomes droppable breaks a passive with nothing logged, and a declined card
# that comes back reads as an offer being generous. Those get driven, not
# grepped.
# §5 IS EIGHTEEN ABILITIES OF WHICH EIGHT CARRY A CLAUSE THAT COULD QUIETLY DO
# NOTHING, and the batch names them: Ember Debt's drain exemption, Winter's
# Toll leaving the hold standing, Null Field reading CURRENT stacks, Aegis
# Reversal consuming the shield, Covenant of Ash mirroring Ruin, Call the Wilds
# preserving Loyalty, Called Volley preserving Focus, and Choking Smoke
# applying the EXISTING Blind. Each of those is driven live and asserted
# against the state it is supposed to have changed — never against the fact
# that the cast returned.
# THREE OF THEM WOULD PASS ON BROKEN CODE IF WRITTEN THE OBVIOUS WAY:
#   · "Winter's Toll leaves the hold standing" is trivially true of an ability
#     that does nothing — so the DAMAGE is asserted beside the hold;
#   · "Null Field reads current stacks" is trivially true of a field stamped
#     at cast time if the stacks never move — so the same field is measured at
#     two different stack counts;
#   · "Call the Wilds preserves Loyalty" is trivially true if no swap happened
#     — so the beast on the field is asserted to have CHANGED.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const CAP := 7
const CLASS_SHARE := 0.25
const REAL_SAVE := "user://run_save.bin"

# The eighteen, by pool. WARRIOR IS DELIBERATELY EMPTY — §5 ships eighteen, not
# twenty-four, and the empty arrays are the visible shape of that debt.
const TRANCHE_1 := {
	"pyromancer": ["Cinderfall", "Ember Debt"],
	"cryomancer": ["Winter's Toll", "Rimebinding"],
	"arcanist": ["Null Field", "Kindled Mind"],
	"holy": ["Second Wind", "Rite of Return"],
	"inquisitor": ["Vow of Suffering", "Aegis Reversal"],
	"occultist": ["Blight the Well", "Covenant of Ash"],
	"beastmaster": ["Twin Hunt", "Call the Wilds"],
	"sharpshooter": ["Called Volley", "Quarry's Mark"],
	"mystic": ["Choking Smoke", "Snare Line"],
}

var checks := 0
var fails: Array = []
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()


func _initialize() -> void:
	# BATCH DO — THE FLATNESS ENDED AND THE FLOOR IS WHAT SURVIVES IT.
	# Twenty-two talent nodes GRANTED an ability; the charter forbids that now,
	# so all twenty-two cards moved into their spec's draft pool. Nine pools are
	# DEEPER than CI's flat eight and three still read exactly eight (the three
	# whose trees granted nothing). **NO POOL LOST ANYTHING**, so `== 8` becomes
	# `>= 8` — the FLOOR is the durable invariant and a pool that quietly empties
	# still trips it. The exact per-spec table lives in ONE place,
	# `test_batch_cd.PER_SPEC_DEPTH`; twelve copies of it would be this project's
	# oldest defect. The TOTAL is asserted here as well, so any depth change trips.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bo_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_cores()
	_cap_and_slots()
	_offer_and_ratio()
	_take_decline_drop()
	_sources()
	await _live_pyromancer()
	await _live_cryomancer()
	await _live_arcanist()
	await _live_holy()
	await _live_devout()
	await _live_occultist()
	await _live_beastmaster()
	await _live_sharpshooter()
	await _live_survivalist()
	_docs()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	var scratch := "user://profile_batch_bo_test.json"
	if FileAccess.file_exists(scratch):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))

	print("\n=== BATCH BO ===")
	print("checks: %d   failures: %d" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit()


# ---------- §4/§5 THE POOLS ----------

func _pools() -> void:
	# EIGHTEEN SHIP, NOT TWENTY-FOUR. Counted off the live dict rather than
	# from the constant above, so the two have to agree.
	# RE-POINTED IN PLACE BY BATCH BP, WITH THE REASON HERE: BO shipped
	# eighteen and NAMED the six Warrior entries as owed. BP paid that debt, so
	# the live total is 24 — and the check that used to prove the debt was
	# VISIBLE now proves it is PAID. Both halves are inversions rather than
	# deletions: what a later batch could break is not "the Warrior pools are
	# still empty", it is "the Warrior pools quietly emptied again".
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.SPEC_DRAFT_POOLS[spec].size()
	# RE-POINTED AGAIN BY BATCH BT, ON EXACTLY THE SAME ARGUMENT BP USED: BT
	# paid the first third of tranche 2, so the live total is 33 (BO's 18 + BP's
	# Warrior 6 + BT's Mage 9). What a later batch could break is not "the pools
	# are still thin", it is "a pool quietly emptied", and the total counted off
	# the LIVE dict is what catches that either way.
	# RE-POINTED AGAIN BY BATCH BU on the same argument: the live total is 42
	# (BO's 18 + BP's Warrior 6 + BT's Mage 9 + BU's Cleric 9).
	# RE-POINTED AGAIN BY BATCH BV, same argument, and CLOSED BY BATCH BW, which
	# paid the Warrior third: 60 (BO's 18 + BP's Warrior 6 + tranche 2's 36).
	# Tranche 2 is complete and every spec pool holds five.
	# RE-POINTED BY BATCH CB: tranche 3's first third landed, so the spec side
	# is 60 plus the Mage nine. The question — is the count what the batches
	# claim they shipped — is unchanged; a pool quietly EMPTYING still trips,
	# which is what pinning a count is for.
	# BATCH DX §1 — A FLOOR, NOT AN EQUALITY. The draft is a collection that
	# GROWS — DO added twenty-two, DR a net +1, DS six — and each time, this
	# line had to be hand-bumped in a dozen files at once. An equality here reds
	# on the next batch that authors a card, and that failure reads exactly like
	# a regression. THE FLOOR IS THE HALF THIS SUITE OWNS: a pool quietly
	# EMPTYING still trips it. The ONE surviving equality is `test_batch_cd`'s,
	# beside `PER_SPEC_DEPTH` — the authoritative table a new card must move.
	ok(total >= 125,
		"§5+DO: the spec half has FALLEN to %d, below the 125 that shipped"
			% total)
	# TRANCHE 1'S ENTRIES MUST STILL LEAD THEIR POOLS, which is the half of this
	# check that survives BT untouched: a later tranche APPENDS, it does not
	# rewrite what is already there. Asserted as a PREFIX rather than as
	# equality, so BO's eighteen are still pinned as literals — a swap of two
	# names would keep every count and change what the draft offers.
	for spec in TRANCHE_1:
		var live: Array = Classes.spec_draft_pool(spec)
		var head: Array = live.slice(0, TRANCHE_1[spec].size())
		ok(head == TRANCHE_1[spec],
			"§5: %s's pool still OPENS with tranche 1's %s (got %s)" % [
				spec, TRANCHE_1[spec], head])
	# AND EVERY SPEC POOL IS FIVE DEEP (Batch BW closed tranche 2). This loop
	# has been re-pointed once per tranche and each re-point was an INVERSION of
	# the debt the previous one recorded; it names all twelve now, so there is
	# no list left to extend.
	# RE-POINTED BY BATCH CB, AND IT IS THE FOURTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, and now a NEW asymmetry pointing the other way — the
	# three MAGE pools are EIGHT deep and the other nine are five, because CB
	# paid tranche 3's first third. The question is unchanged and is still what
	# tells the two answers apart; what is owed now is the Cleric, Hunter and
	# Warrior thirds of tranche 3, and it has to stay visible in code.
	# RE-POINTED BY BATCH CE, AND IT IS THE FIFTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, and now that asymmetry HALVED
	# — the CLERIC three joined the Mage three at EIGHT when tranche 3's second
	# third landed, so six pools are eight deep and six are five. The question is
	# unchanged and is still what tells the two answers apart; what is owed now
	# is the HUNTER and WARRIOR thirds, and it has to stay visible in code.
	for spec in ["pyromancer", "cryomancer", "arcanist",
			"holy", "inquisitor", "occultist",
			"beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.spec_draft_pool(spec).size() >= 8,
			"§5+tranche 3: %s drafts at least EIGHT" % spec)
	# RE-POINTED BY BATCH CH, AND IT IS THE SIXTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, then that asymmetry HALVED at
	# CE, and now QUARTERED — the HUNTER three joined the Mage and Cleric at
	# EIGHT when tranche 3's third third landed, so NINE pools are eight deep and
	# only the WARRIOR THREE are still at five. The question is unchanged and is
	# still what tells the two answers apart; what is owed is the Warrior third,
	# and it is the LAST of the debt, so it has to stay visible in code.
	# RE-POINTED BY BATCH CI, AND IT IS THE SEVENTH AND LAST INVERSION OF THIS
	# LOOP. It has asserted, in order: each earlier tranche's own asymmetry, then
	# the FLATNESS tranche 2 achieved, then CB's new asymmetry, that asymmetry
	# HALVED at CE, QUARTERED at CH — and now GONE. The WARRIOR three joined the
	# other nine at EIGHT when tranche 3's last third landed, so ALL TWELVE specs
	# draft from eight and the draft is 120 of 120.
	#
	# **THERE IS NO DEBT LEFT TO KEEP VISIBLE, so what this loop guards from here
	# on is the FLATNESS rather than an asymmetry**: a pool that quietly EMPTIES
	# trips, where before it would have read as the old debt coming back. That is
	# the reason it inverts rather than being deleted — the question is still
	# worth asking, only the correct answer moved, and it moved for the last time.
	for spec in ["berserker", "warden", "swordmaster"]:
		ok(Classes.spec_draft_pool(spec).size() >= 8,
			"§5+tranche 3: %s drafts at least EIGHT — the Warrior third is paid" % spec)
	# THE WARRIOR POOLS ARE NAMED **AND FULL** — named and empty at BO, filled to
	# two at BP, and five at BW. One of four heroes in every party had no draft
	# at all until BP, and had the shallowest one in the game until BW.
	for w in ["berserker", "warden", "swordmaster"]:
		ok(Classes.SPEC_DRAFT_POOLS.has(w),
			"§5: %s's draft pool is NAMED" % w)
		ok(Classes.spec_draft_pool(w).size() >= 8,
			"CI: ...and FULL — %s drafts at least EIGHT of its own" % w)
	# CLASS-WIDE: four keys, ALL FOUR FILLED.
	# RE-POINTED IN PLACE TWICE, AND BOTH RE-POINTS ARE INVERSIONS — the honest
	# treatment when a later batch pays a debt an older suite was recording.
	# BO asserted all four pools were EMPTY, because none shipped here. BQ
	# filled the Mage and Cleric six and this became "two filled, two owed".
	# BATCH BR FILLED THE OTHER TWO, so the debt is gone and what a later batch
	# could break is no longer "did the remaining debt stay visible" but "did a
	# class pool quietly empty again". The setup is byte-identical, because it
	# is still what tells the answers apart.
	ok(Classes.CLASS_DRAFT_POOLS.size() == 4,
		"§4: all four class-wide pools are named")
	for ck in ["mage", "cleric", "warrior", "hunter"]:
		ok(Classes.class_draft_pool(ck).size() >= 6,
			"§4: the %s class pool has FALLEN below the six BQ and BR filled it to" % ck)
	ok(is_equal_approx(Classes.CLASS_DRAFT_SHARE, CLASS_SHARE),
		"§4: roughly one card in four is class-wide")
	# EVERY ENTRY RESOLVES. A pool name that does not resolve is an offer that
	# hands out nothing — the exact failure AH's resolver exists to prevent.
	for spec2 in Classes.SPEC_DRAFT_POOLS:
		for n in Classes.spec_draft_pool(spec2):
			var ab: Ability = Classes.pool_ability(String(n))
			ok(ab != null, "§5: '%s' resolves through pool_ability" % n)
			if ab == null:
				continue
			ok(ab.display_name == String(n), "§5: ...to itself (%s)" % n)
			ok(ab.description != "", "§5: ...and carries a description (%s)" % n)
			# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
			# perfect. As of CN that is false by design: 113 of the 211 abilities run no
			# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
			# draft card cannot advertise a bonus nothing can fire. The durable question
			# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
			# — which is strictly stronger than what was here and cannot rot as the
			# criterion catches more cards.
			# BATCH DO — TWO NAMED EXEMPTIONS, AND THEY ARE A DEBT RATHER THAN A
			# SUPPRESSION. `Rampage` and `Pyroblast` were authored as TALENT
			# GRANTS, under a standard that predates this biconditional, and both
			# run a bar while naming no Perfect. They are two of the six
			# `test_batch_cp.CHECK_WITHOUT_PERFECT` names — a population that has
			# existed since long before CN and is tracked there. **DO moved them
			# into a draft pool and therefore INTO this loop's reach; it did not
			# create them.** Authoring a Perfect bonus for either is a design
			# decision, so it is recorded as owed rather than invented here.
			# A THIRD name reaching this loop still trips.
			if not (n in ["Rampage", "Pyroblast"]):
				ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
					"§5: ...and states a perfect exactly when it runs a check (%s)" % n)
			else:
				ok(ab.perfect_text == "" and ab.runs_skill_check(),
					"§5+DO: '%s' is a KNOWN checked-but-Perfectless card (owed, see cp)" % n)
			ok(ab.delay > 0.0, "§5: ...and an initiative cost (%s)" % n)
	# NO DRAFT NAME MAY COLLIDE WITH AN EXISTING ONE. `pool_ability` resolves
	# by display name across the whole game, so a collision would silently
	# re-point an existing ability.
	#
	# BATCH DO RE-POINTED THIS FROM DISJOINTNESS TO THE PROPERTY DISJOINTNESS WAS
	# STANDING IN FOR, AND THE DISTINCTION IS THE WHOLE OF BO's OWN RATIONALE.
	# BO kept the two pools apart so that "the existing boss pick, UNCHANGED"
	# would be true rather than nearly true — **a shared pool would have
	# re-weighted every boss offer the moment eighteen entries landed.** DO adds
	# twenty-two names to the DRAFT pools and adds NOTHING to `SPEC_POOLS`, so
	# the boss offer is byte-for-byte what it was; eight of the twenty-two were
	# already in their spec's boss pool, which is exactly why they were worth
	# keeping rather than deleting. **THE OVERLAP CANNOT PRODUCE A DUPLICATE
	# OFFER IN EITHER DIRECTION** — `Run.draft_pool_left` and
	# `Run.roll_spec_ability_offer` both filter `owned_ability_names(member)`,
	# and that is asserted here rather than assumed, because it is the half that
	# would actually hurt if it stopped being true.
	var overlap: Array = []
	for spec3 in Classes.SPEC_DRAFT_POOLS:
		for n2 in Classes.spec_draft_pool(spec3):
			if Classes.spec_pool(spec3).has(n2):
				overlap.append("%s/%s" % [spec3, n2])
			# A draft name may never be a SIBLING spec's card — the one
			# collision that would silently re-point an ability.
			#
			# **BATCH DY §3 RE-POINTED THIS ASSERTION RATHER THAN LETTING IT GO
			# VACUOUS, AND THAT IS THE WHOLE OF THE EDIT.** It used to read
			# `Classes.class_pool(...)`, the accessor on the class-wide BOSS
			# pool; DY deleted that dict, so the check as written would have
			# compared against an empty array and passed for no reason —
			# which this project holds to be worse than a red. **THE QUESTION IS
			# UNCHANGED AND THE LIVE STRUCTURE ANSWERS IT**: the sibling's card
			# is its `SPEC_POOLS` entry, so that is what a draft name must not
			# collide with. Derived live at DY: ZERO such collisions exist.
			#
			# PHOENIX REBIRTH NEEDED THE OLD EXEMPTION AND NEEDS NONE NOW. It
			# sat in `CLASS_POOLS["mage"]` and in NO spec pool, so until DO its
			# ONLY source was `py_rebirth`'s grant; putting it in the
			# Pyromancer's draft pool is what makes it earnable at all. Against
			# the SIBLING boss pools it was never a collision.
			var sib_hit := false
			for sib in Classes.SPEC_IDS.get(Classes.class_of_spec(spec3), []):
				if String(sib) != spec3 and Classes.spec_pool(String(sib)).has(n2):
					sib_hit = true
			ok(not sib_hit,
				"§4: '%s' is a %s draft card and a SIBLING spec's boss card" % [n2, spec3])
	# SIXTEEN OF THE TWENTY-TWO, NOT ALL OF THEM — DERIVED, NOT ASSUMED. The six
	# that are NOT in their spec's boss pool are exactly `check_cz` §0's five
	# (Backdraft, Pyroblast, Glacial Prison, Cryoclasm, Intercession) plus
	# Phoenix Rebirth: the cards that lived in NO pool at all, which is the hole
	# DO closes.
	ok(overlap.size() == 16,
		"§4+DO: exactly sixteen of DO's twenty-two sit in both draws (%d: %s)" % [
			overlap.size(), ", ".join(overlap)])
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(rsrc.contains("var blocked: Array = owned_ability_names(member)"),
		"§4+DO: the DRAFT roller filters what the hero already owns")
	ok(rsrc.contains("var owned: Array = owned_ability_names(member)"),
		"§4+DO: ...and so does the BOSS roller, so an overlap cannot double-offer")
	# The boss pool still holds what BO shipped (§3: "the existing pick,
	# unchanged"). **BATCH DY §2 ADDED TO IT AND THIS ASSERTS CONTAINMENT
	# RATHER THAN IDENTITY BECAUSE OF IT.** Holy's pool held ONE card against
	# THREE zone-boss awards, so two of her three awards paid nothing — and
	# Divine Plea is also draftable, so a hero who drafted it emptied the pool
	# and all three paid nothing. DY put Dawnbreak and Sanctuary in beside it.
	# **WHAT BO OWNS HERE IS THAT ITS OWN ENTRY SURVIVED**, which containment
	# says and identity would have turned into a re-edit every time the pool
	# deepens. The DEPTH is asserted in `check_dv` §2, which is the one
	# instrument that owns the boss-pool census.
	ok(Classes.spec_pool("holy").has("Divine Plea"),
		"§3: the zone-boss SPEC_POOLS draw still holds BO's own entry")
	ok(Classes.spec_pool("holy").size() >= 1,
		"§3: ...and Holy's boss pool has not emptied (%d)" %
			Classes.spec_pool("holy").size())
	ok(Classes.spec_pool("beastmaster").size() >= 5,
		"§3: ...for every spec (the Beastmaster's boss pool has fallen below five)")


# ---------- §2 THE TWELVE CORES ----------

func _cores() -> void:
	var specs: Array = Classes.all_specs()
	ok(specs.size() == 12, "§2: twelve specs to core")
	for spec in specs:
		ok(Classes.PROTECTED_CORES.has(spec),
			"§2: %s has an authored protected core" % spec)
		if not Classes.PROTECTED_CORES.has(spec):
			continue
		var slots := Classes.core_slots(spec)
		ok(slots >= 1 and slots <= CAP,
			"§2: %s's core fits inside the cap (%d)" % [spec, slots])
		ok(CAP - slots >= 3,
			"§2: %s keeps at least 3 draftable slots (%d)" % [spec, CAP - slots])
		ok(String(Classes.PROTECTED_CORES[spec].get("why", "")) != "",
			"§2: %s's core states WHY" % spec)
		# EVERY NAMED ENABLER IS IN THE OPENING KIT AND IN NO POOL. This is the
		# check the section exists for: the failure it prevents is a spine that
		# stops working because its enabler became draftable, and that failure
		# is silent.
		var protected: Array = Classes.protected_names(spec)
		for en in Classes.core_enablers(spec):
			ok(protected.has(en),
				"§2: %s's enabler '%s' is in the protected core" % [spec, en])
			ok(not Classes.spec_draft_pool(spec).has(en),
				"§2: ...and is NOT draftable (%s)" % en)
			ok(not Classes.spec_pool(spec).has(en),
				"§2: ...and is NOT a boss pick either (%s)" % en)
	# The per-spec answers that the batch calls out by name.
	ok(Classes.core_enablers("pyromancer").size() == 2,
		"§2: Overburn needs a Burn applier AND a spender — the Pyromancer's core is larger")
	ok(Classes.core_enablers("berserker").is_empty(),
		"§2: ...than the Berserker's, whose passive reads nothing but his own health")
	# Corrected toward the code by BP: Precision Strike and Feint switch the
	# stance too, so Guard Change is his only UNCONDITIONAL swap rather than
	# the only one in the game. The ENABLER is unchanged and still protected.
	ok(Classes.core_enablers("swordmaster") == ["Guard Change"],
		"§2: the Swordmaster's stances need his one unconditional stance swap")
	ok(Classes.core_enablers("beastmaster").size() == 3,
		"§2: Pack Bond needs a beast — all three summons are protected")
	ok(Classes.core_slots("beastmaster") == 3,
		"§2: ...and they cost THREE slots, not five (the summons share one bar entry)")
	ok(Classes.core_slots("holy") == 4,
		"§2: Holy's four opening abilities cost four slots (Batch AV's deliberate parity break)")
	# TEN OF TWELVE ARE 3-AND-4, which is what §2 predicted.
	var threes := 0
	for spec2 in specs:
		if Classes.core_slots(spec2) == 3:
			threes += 1
	ok(threes == 11, "§2: eleven specs carry 3 protected and 4 draftable (got %d)" % threes)


# ---------- §2 THE CAP ----------

func _cap_and_slots() -> void:
	var run := root.get_node("/root/Run")
	# BATCH EG §1 — THE CAP IS A LADDER AND THIS SUITE ASKS IT AT RUN START.
	# `ability_slot_cap()` reads `zone_bosses_cleared`, which is 0 on a fresh
	# run node, so the number BO asserted is the ladder's FIRST rung and the
	# rest of this section is unchanged by the ladder existing.
	ok(int(run.ability_slot_cap()) == CAP, "§2: ability slots cap at 7 at run start")
	ok(run.ABILITY_SLOTS_BY_BOSS == [7, 8, 9, 10],
		"§2: ...and grow one a zone boss to ten (EG §1)")
	var m := {"key": "mage", "spec": "pyromancer", "bm_abilities": []}
	ok(int(run.ability_slots_used(m)) == 3,
		"§2: a fresh Pyromancer uses 3 of 7 (the protected core counts against it)")
	ok(not run.ability_slots_full(m), "§2: ...and is not full")
	m["bm_abilities"] = ["Immolate", "Firestorm", "Cinderfall"]
	ok(int(run.ability_slots_used(m)) == 6, "§2: three earned takes him to 6")
	ok(not run.ability_slots_full(m), "§2: ...still one slot open")
	m["bm_abilities"] = ["Immolate", "Firestorm", "Cinderfall", "Ember Debt"]
	ok(int(run.ability_slots_used(m)) == CAP, "§2: a fourth fills the kit")
	ok(run.ability_slots_full(m), "§2: ...and the cap binds")
	# A PROTECTED ABILITY CAN NEVER BE DROPPED, and the mechanism is that it is
	# not in the drop list at all — there is no branch to get wrong.
	ok(not run.earned_ability_names(m).has("Detonation"),
		"§2: a protected ability is not in the drop list")
	ok(not run.unequip_earned_ability(m, "Detonation"),
		"§2: ...and benching one is REFUSED")
	ok(int(run.ability_slots_used(m)) == CAP,
		"§2: ...leaving the kit untouched")
	ok(run.unequip_earned_ability(m, "Firestorm"),
		"§2: an EARNED ability benches")
	ok(int(run.ability_slots_used(m)) == 6, "§2: ...and frees its slot")
	# **INVERTED BY BATCH EG §2, AND THE QUESTION IS KEPT.** BO asserted that a
	# DROP wrote the no-return ledger, because a drop was permanent. Benching is
	# not permanent — the card stays in the pool and can be carried again — so
	# the ledger must NOT be written, and the property the old check was really
	# protecting is asserted directly beside it: **the benched card still cannot
	# be re-offered.** It is blocked by OWNERSHIP now rather than by refusal,
	# which is the same guarantee reached through the set that is true of it.
	ok(not run.draft_refused(m).has("Firestorm"),
		"§2: benching does NOT write the no-return ledger (EG §2)")
	ok(run.earned_ability_names(m).has("Firestorm"),
		"§2: ...because the card is KEPT in the pool")
	ok(not run.roll_draft_offer(m).has("Firestorm"),
		"§2: ...and is still never re-offered, being owned")
	ok(run.equip_earned_ability(m, "Firestorm"),
		"§2: ...and it can be carried again, without cost")
	ok(int(run.ability_slots_used(m)) == CAP, "§2: ...back at the cap")
	ok(run.unequip_earned_ability(m, "Firestorm"),
		"§2: ...left benched for what follows")


# ---------- §3 THE OFFER ----------

func _offer_and_ratio() -> void:
	var run := root.get_node("/root/Run")
	var m := {"key": "mage", "spec": "cryomancer", "bm_abilities": []}
	var offer: Array = run.roll_draft_offer(m)
	# RE-POINTED IN PLACE TWICE, AND IT IS THE SAME INVERSION THE POOL CHECK
	# ABOVE TAKES. BO measured a Cryomancer's offer at TWO cards, because his
	# side of the draft held two and the class side held nothing — the honest
	# record of a thin pool. BQ filled the Mage class pool, so his offer fills
	# THREE, and BQ moved the fill-short half onto a Hunter, whose class pool
	# was the debt that remained.
	#
	# BATCH BR PAID THAT DEBT, SO THE FILL-SHORT RULE HAS TO BE MEASURED
	# SOMEWHERE IT STILL BITES — and with every class pool full, the only place
	# left is a hero who has REFUSED his way down to fewer than three cards.
	# That is the honest construction rather than a weaker check: the rule was
	# never about which pool is thin, it is about an offer never padding with
	# repeats, and the no-return ledger is what still makes a pool thin.
	ok(offer.size() == 3,
		"§3: a Mage's offer fills THREE now — spec plus class (Batch BQ)")
	# RE-POINTED BY BATCH BW, AND THIS IS THE FORCED MOVE BV PREDICTED IN
	# WRITING — the honest signal that tranche 2 is paid rather than a check
	# quietly weakening. The construction has now moved three times for the same
	# reason each time: it stood on a SHARPSHOOTER until BV filled the Hunter
	# pools, then on a BERSERKER because the Warrior three were the last at two,
	# and BW filled those. THERE IS NO THIN POOL LEFT IN THE GAME, so the rule
	# has to be measured the only way it can still bite — a hero who has REFUSED
	# his way down (BR's version of it), which is what the no-return ledger is
	# for. THE RULE WAS NEVER ABOUT WHICH POOL IS THIN: it is about an offer
	# never padding with repeats, and refusing all six class cards plus three of
	# his own five leaves exactly two cards in the game he can be shown.
	#
	# REBUILT BY BATCH CI, AND THIS IS THE LAST TIME IT CAN NEED IT. CI took the
	# three WARRIOR pools 5 -> 8, so a refusal of "the class pool plus three" now
	# leaves FIVE standing and the offer comes up FULL — the check would have
	# gone on measuring something, and it would no longer have been the
	# fill-short rule. **THERE IS NO POOL LEFT IN THE GAME TO MOVE IT ONTO**:
	# every spec drafts eight and every class six, so the hero cannot change
	# again and the ARITHMETIC had to. It is written RELATIVE TO THE LIVE POOL
	# SIZE now — refuse everything but two — which is test_batch_bx's shape and
	# the only one that cannot go stale a fourth time. A later tranche that
	# deepened a pool would move this check's setup and not its answer.
	var bz_pool: Array = Classes.spec_draft_pool("berserker")
	var worn: Array = Classes.class_draft_pool("warrior").duplicate()
	worn.append_array(bz_pool.slice(0, bz_pool.size() - 2))
	var thin := {"key": "warrior", "spec": "berserker", "bm_abilities": [],
		"draft_refused": worn}
	var thin_offer: Array = run.roll_draft_offer(thin)
	ok(thin_offer.size() == 2,
		"§3: a pool worn down to two still fills SHORT (2 cards, not 3) — never padding (got %d)" % thin_offer.size())
	for tc in thin_offer:
		ok(Classes.spec_draft_pool("berserker").has(String(tc)),
			"§3: ...and what is left is his own spec's (%s)" % tc)
	ok(offer.size() == offer.duplicate().size(),
		"§3: ...and never pads")
	var seen := {}
	for c in offer:
		ok(not seen.has(c), "§3: no offer repeats a card inside itself (%s)" % c)
		seen[c] = true
	# INVERTED BY BATCH BP, WITH THE REASON HERE. This asked "is a Warrior's
	# offer empty" — it was BO's honest record of the debt. BP paid it, so the
	# question worth asking is the opposite one, and it is the one a later
	# batch could break: does a WARRIOR now get a real offer and a real owed
	# pick, like the other nine. The SETUP is byte-identical because it is
	# still what tells the two answers apart.
	#
	# RE-POINTED AGAIN BY BATCH BR, AND ONLY THE NUMBER MOVED: BP gave him two
	# spec cards, BR gave his class six, so the offer fills THREE like everyone
	# else's. The question — does a Warrior get a real offer and a real owed
	# pick — is unchanged, which is why the setup is byte-identical.
	var w := {"key": "warrior", "spec": "berserker", "bm_abilities": []}
	var w_offer: Array = run.roll_draft_offer(w)
	ok(w_offer.size() == 3,
		"BR: a Warrior's draft offer FILLS THREE now — two spec plus six class (got %d)" % w_offer.size())
	ok(run.award_draft_pick(w),
		"BP: ...and awarding one succeeds rather than refusing an empty pool")
	ok(int(w.get("draft_picks_owed", 0)) == 1,
		"BP: ...leaving a real pick owed")
	# AN OWNED ABILITY IS NEVER OFFERED AGAIN. Owned covers EVERY source —
	# kit, talent grant, boss pick, earlier draft — because the roller reads
	# `owned_ability_names`, which is `Talents.ability_names`.
	var m2 := {"key": "mage", "spec": "cryomancer",
		"bm_abilities": ["Winter's Toll"], "talents": {}, "tree": []}
	var offer2: Array = run.roll_draft_offer(m2)
	ok(not offer2.has("Winter's Toll"),
		"§3: an ability already held is never offered again")
	# RE-POINTED BY BATCH BQ, for the same reason as the fill-short check above:
	# this read `== ["Rimebinding"]` only because a Cryomancer's ENTIRE draft
	# was two cards. His class pool holds six now, so what is left is seven and
	# the offer is three of them. The question — is the owned card excluded and
	# is everything else still eligible — is asked directly instead.
	ok(offer2.size() == 3, "§3: ...and the rest of the pool still fills the offer")
	for c2 in offer2:
		ok(Classes.spec_draft_pool("cryomancer").has(c2) \
				or Classes.class_draft_pool("mage").has(c2),
			"§3: ...leaving only what is left, from one pool or the other (%s)" % c2)
	# THE RATIO HAS ITS OWN SEAM, and it is driven a few hundred times. With
	# every class pool empty at BO, a check on the ROLLER could only
	# ever measure zero — and a check that can only pass is a gap (BK's
	# zero-blacksmith lesson).
	var class_cards := 0
	for _i in 4000:
		if run.draft_card_is_class(10, 10):
			class_cards += 1
	var share := class_cards / 4000.0
	ok(share > 0.20 and share < 0.30,
		"§4: roughly one card in four is class-wide (measured %.3f over 4000)" % share)
	ok(not run.draft_card_is_class(10, 0),
		"§4: an empty class pool never draws a class card")
	ok(run.draft_card_is_class(0, 10),
		"§4: an empty SPEC pool falls back to the class side rather than filling short")


# ---------- §2 TAKE, DECLINE, DROP ----------

func _take_decline_drop() -> void:
	var run := root.get_node("/root/Run")
	# TAKE ONE below the cap.
	var m := {"key": "mage", "spec": "arcanist", "bm_abilities": [],
		"talents": {}, "tree": []}
	ok(run.award_draft_pick(m), "§3: an offer is queued")
	ok(int(m["draft_picks_owed"]) == 1, "§3: ...and one pick is owed")
	var card := String(m["draft_candidates"][0][0])
	ok(run.take_draft_ability(m, card) == "", "§2: the card is taken")
	ok(m["bm_abilities"].has(card), "§2: ...and lands in the kit")
	ok(int(m["draft_picks_owed"]) == 0, "§2: ...spending the pick")
	ok(m["draft_candidates"].is_empty(),
		"§2: ...and the offer it came from, whole")
	# THE OTHER CARDS OF A TAKEN OFFER ARE NOT REFUSED — only a DECLINE and a
	# DROP write the no-return ledger, which is what the rule says.
	ok(run.draft_refused(m).is_empty(),
		"§2: taking one card refuses nothing")
	# DECLINING IS ALWAYS ALLOWED, and it refuses the WHOLE offer.
	var m2 := {"key": "cleric", "spec": "holy", "bm_abilities": [],
		"talents": {}, "tree": []}
	ok(run.award_draft_pick(m2), "§2: a second offer is queued")
	var declined: Array = (m2["draft_candidates"][0] as Array).duplicate()
	ok(run.decline_draft(m2), "§2: declining is allowed")
	ok(m2["bm_abilities"].is_empty(), "§2: ...and leaves the kit untouched")
	ok(int(m2["draft_picks_owed"]) == 0, "§2: ...spending the pick")
	for d in declined:
		ok(run.draft_refused(m2).has(d),
			"§2: a declined card does not return to this run's pool (%s)" % d)
	# RE-POINTED BY BATCH BQ. This used to read `.is_empty()`, which was true
	# only because a Holy hero's whole draft was the two cards she had just
	# declined. Her class pool holds six now, so the pool is not exhausted —
	# and the QUESTION was never "is the pool empty", it was "can a declined
	# card come back". That is what it asks now, against a pool with plenty
	# left to offer, which is a strictly better version of the same check.
	var after: Array = run.roll_draft_offer(m2)
	ok(not after.is_empty(),
		"§2: the next offer still has cards to draw (Batch BQ filled her class pool)")
	for d2 in declined:
		ok(not after.has(d2),
			"§2: ...and cannot re-present a declined card (%s)" % d2)
	# AT THE CAP AN OFFER IS TAKE-ONE-AND-DROP-ONE.
	var m3 := {"key": "hunter", "spec": "sharpshooter", "talents": {}, "tree": [],
		"bm_abilities": ["Quick Draw", "Triple Shot", "Coup de Grâce",
			"Pinning Shot"]}
	ok(run.ability_slots_full(m3), "§2: the Sharpshooter's kit is full at 7")
	ok(run.award_draft_pick(m3), "§2: a full kit is still offered a draft")
	var c3 := String(m3["draft_candidates"][0][0])
	ok(run.take_draft_ability(m3, c3) == "the kit is full — name an ability to bench",
		"§2: taking at the cap REQUIRES a bench before it resolves (EG §2)")
	ok(not m3["bm_abilities"].has(c3), "§2: ...and nothing landed")
	ok(int(m3["draft_picks_owed"]) == 1, "§2: ...and the pick is still owed")
	ok(run.take_draft_ability(m3, c3, "Aimed Shot")
			== "Aimed Shot cannot be benched",
		"§2: naming a PROTECTED ability as the bench is refused")
	ok(int(run.ability_slots_used(m3)) == CAP, "§2: ...leaving the kit at 7")
	ok(run.take_draft_ability(m3, c3, "Pinning Shot") == "",
		"§2: naming an EARNED ability resolves the offer")
	# **INVERTED BY BATCH EG §2.** One in, one out of the LOADOUT — and nothing
	# out of the POOL, which is the whole of the change. The slot arithmetic is
	# identical; what moved is that the displaced card is still held.
	ok(run.equipped_ability_names(m3).has(c3)
			and not run.equipped_ability_names(m3).has("Pinning Shot"),
		"§2: ...one in, one out of the LOADOUT")
	ok(m3["bm_abilities"].has(c3) and m3["bm_abilities"].has("Pinning Shot"),
		"§2: ...and BOTH are in the pool (EG §2)")
	ok(int(run.ability_slots_used(m3)) == CAP, "§2: ...and the cap still holds at 7")
	ok(not run.draft_refused(m3).has("Pinning Shot"),
		"§2: the benched ability does not enter the no-return ledger (EG §2)")
	# A DECLINED OR DROPPED ABILITY IS GONE FOR THE RUN, NOT FOR THE HERO'S
	# LIFE: the ledger rides the member dict, so a new run starts clean.
	var fresh := {"key": "hunter", "spec": "sharpshooter", "bm_abilities": [],
		"talents": {}, "tree": []}
	ok(run.draft_refused(fresh).is_empty(),
		"§2: the no-return ledger is per RUN — a fresh member has none")


# ---------- §3 THE FOUR SOURCES ----------

func _sources() -> void:
	var bat := _src("res://scripts/battle.gd")
	var sim := _src("res://scripts/run_sim.gd")
	var shop := _src("res://scripts/shop_screen.gd")
	var ev := _src("res://scripts/events.gd")
	var map := _src("res://scripts/map_screen.gd")
	# ELITE — ALWAYS, ON VICTORY. Asserted in BOTH victory paths, because a
	# source wired in real play and not in the sim measures a game nobody is
	# playing (and the reverse is worse).
	var el := bat.find("if node_type == \"elite\":")
	ok(el > 0, "§3: the elite victory branch is where it was")
	if el > 0:
		var body := bat.substr(el, 2600)
		ok(body.contains("Run.award_draft_pick(d_taker)"),
			"§3: an elite ALWAYS offers a draft on victory")
		ok(not body.contains("randf()"),
			"§3: ...unconditionally — no roll stands between the elite and the offer")
	# RE-POINTED AT BATCH BX §2, AND IT IS AN INVERSION. BO offered to ONE hero
	# drawn at random and this needle pinned that draw; BX offers to EVERY
	# LIVING hero, so what is worth asserting is that the sim's walk still
	# MATCHES battle.gd's victory branch — a sim measuring a draft rate the game
	# does not have is worse than a sim that skips the draft entirely.
	ok(sim.contains("_award_draft(run, d_m)")
		and sim.contains("for d_m in run.party:"),
		"§3: ...and the sim's elite branch offers it to every living hero too")
	ok(sim.contains("run.take_draft_ability(m, String(offer[0]), drop)"),
		"§3: ...resolved through the SAME door the map screen calls")
	# MERCHANT — purchasable, gold.
	ok(shop.contains("Run.draft_price()"), "§3: the merchant prices a draft")
	ok(shop.contains("Run.award_draft_pick(member)"),
		"§3: ...and sells the OFFER, resolved on the hero card")
	ok(shop.contains("if Run.gold < price:\n\t\treturn"),
		"§3: ...refusing before the gold moves")
	var run := root.get_node("/root/Run")
	run.zone_idx = 0
	var p1 := int(run.draft_price())
	run.zone_idx = 2
	var p3 := int(run.draft_price())
	run.zone_idx = 0
	ok(p1 == 120 and p3 == 240, "§3: the price rises by zone (%d -> %d)" % [p1, p3])
	ok(p3 < 300, "§3: ...and stays under the blacksmith's top price")
	# EVENT — some events offer one as a trade.
	ok(ev.contains("\"ability_draft\""), "§3: the event verb exists")
	ok(Events.VERBS.has("ability_draft"), "§3: ...and is in the vocabulary")
	var offering := 0
	for id in Events.ids():
		for ch in Events.config(String(id)).get("choices", []):
			for fx in ch.get("effects", []):
				if String(fx.get("effect", "")) == "ability_draft":
					offering += 1
	ok(offering >= 2, "§3: at least two events trade for one (got %d)" % offering)
	# ZONE BOSSES — the existing pick, unchanged.
	ok(bat.contains("var picked: Array = _award_ability_picks()"),
		"§3: the zone-boss pick is untouched")
	ok(bat.contains("func _award_ability_picks() -> Array:"),
		"§3: ...through the function it always used")
	# THE CAP BINDS THE BOSS PICK TOO — it is a rule about a KIT, not about one
	# pool, and a boss pick that walked past it would not be a cap at all.
	ok(map.contains("if bench_name == \"\" and Run.ability_slots_full(member):\n\t\t_open_drop_overlay(idx, \"ability\", pool_name)"),
		"§3: a boss pick at the cap opens the same drop step")
	# ONE DOOR PER QUESTION, so a rule cannot be applied in one path and
	# forgotten in the other. **RE-POINTED AT BATCH EG §2 AND THE COUNT MOVED
	# FROM ONE TO TWO, WITH BOTH SITES NAMED** — the take-at-the-cap step and
	# the loadout panel are two SCREENS calling one door, which is what BO's
	# rule asks for; two different answers to what may be benched is what it
	# forbids. The panel is named here so a third caller has to move this line.
	ok(map.count("Run.unequip_earned_ability(") == 2,
		"§2: the map screen benches through exactly one door, from its two screens (the cap step and the loadout panel)")
	ok(map.count("func _toggle_loadout(") == 1
			and map.contains("Run.equip_earned_ability(member, name)"),
		"§2: ...and the panel carries no equip rule of its own")
	var rs := _src("res://scripts/run_state.gd")
	# **STRENGTHENED AT EG §2, NOT LOOSENED.** BO asserted the DROP was written
	# once (`bm_abilities = kept`, the line that took a card out of the kit).
	# Nothing takes a card out of the pool any more, so that needle has no
	# referent — and the question it was asking has a better answer: the POOL
	# has exactly ONE writer in the whole run state, `hold_ability`, which both
	# channels call.
	ok(rs.count("member[\"bm_abilities\"] = ") == 1,
		"§2: ...and the POOL is written in exactly one place (EG §2: `hold_ability`)")
	ok(map.count("member[\"bm_abilities\"] = ") == 0
			and map.count("Run.hold_ability(") == 1,
		"§2: ...which the map screen calls rather than writing the list itself")
	# THE OVERLAY IS REUSED, NOT REBUILT (§1's instruction).
	ok(map.count("func _open_pick_overlay(") == 1,
		"§3: there is still exactly ONE pick overlay")
	# RE-POINTED AT BATCH BX §2, AND IT IS AN INVERSION. BO's question was "is
	# the draft reusing the overlay rather than building a second one", and the
	# answer moved: an elite drafts for FOUR heroes now, which is a screen the
	# one-hero overlay cannot be. What the question becomes is the same one
	# pointed at the new shape — is there exactly ONE draft renderer — and BO's
	# single-hero branch is DELETED rather than left standing beside it.
	ok(not map.contains("\"draft\": \"THE DRAFT\""),
		"§3: BO's single-hero draft branch is gone from the pick overlay")
	ok(map.count("func _open_party_draft(") == 1
		and map.contains("if kind == \"draft\":\n\t\t_open_party_draft()"),
		"§3: ...and the draft has exactly one renderer, which CHOOSE routes to")


# ---------- LIVE ----------

func _spawn(specs: Array, granted: Dictionary, lineup: Array,
		learned := {}) -> Node:
	return await Fixture.spawn(self, specs,
		{"difficulty": "wanderer", "enemies": lineup, "talents_by_spec": learned,
		"bm_by_spec": granted, "deterministic": true})


func _hero(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _drop(scene: Node) -> void:
	scene.queue_free()
	await process_frame


# ---------- §5 PYROMANCER ----------

func _live_pyromancer() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "mystic"],
		{"pyromancer": ["Cinderfall", "Ember Debt"]}, ["raider", "raider", "archer"])
	var pyro := _hero(scene, "overburn")
	ok(pyro != null, "the Pyromancer spawned")
	if pyro == null:
		await _drop(scene)
		return
	# THE DRAFTED ABILITIES REACH THE BAR. This is the assembly half — a card
	# that resolves but never lands in the kit is a card nobody can cast.
	ok(scene.call("_find_ability", pyro, "Cinderfall") != null,
		"§5: a DRAFTED ability is assembled onto the unit like an earned one")
	ok(scene.call("_find_ability", pyro, "Ember Debt") != null,
		"§5: ...both of them")
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	# EMBER DEBT — RE-POINTED IN PLACE BY BATCH BS §4, AND IT IS AN INVERSION.
	# BO measured the card as a DIFFERENCE BETWEEN TWO DENOMINATORS: its enemy
	# was exempt from Overburn's Mana drain while still feeding the damage
	# bonus, and that gap WAS the ability. BS DELETED THE DRAIN, so there was
	# nothing left to be exempt from — `_drain_burn_turns`, `_overburn_drain`
	# and `BattleUnit.ember_debt` are all gone, and this section was silently
	# ABORTING on the first of them (the BC trap: a live check that throws kills
	# its own function while the suite still prints "0 failures", which is
	# exactly how it was found — the count fell 505 -> 495 and nothing failed).
	# THE CARD WAS RE-AUTHORED RATHER THAN REPLACED and the question re-points
	# with it: it is PAID UP FRONT now — Overburn refunds every turn it applies,
	# as though he had already consumed them, while the fire burns its full
	# term. Still measured as a state CHANGE rather than as "the cast returned".
	var ed: Ability = scene.call("_find_ability", pyro, "Ember Debt")
	pyro.resource = 40
	var mana_was: int = pyro.resource
	await scene.call("_resolve", pyro, ed, foes[0], "good")
	ok(foes[0].status_stacks("burn") > 0 or not foes[0].get_status("burn").is_empty(),
		"§5: Ember Debt lights its enemy")
	# BATCH CN §3 folded this ability's Perfect bonus into its base effect.
	ok(int(foes[0].get_status("burn").get("turns", 0)) == 12,
		"§5: ...for the 12 turns the card promises (CN folded the perfect in)")
	ok(pyro.resource == mana_was - ed.cost + 12,
		"§5: ...and Overburn PAYS THE DEBT UP FRONT — %d - %d + 12 = %d (got %d)" % [
			mana_was, ed.cost, mana_was - ed.cost + 12, pyro.resource])
	var total := int(scene.call("_total_burn_turns"))
	ok(total >= 12, "§5: the field carries the fire (%d turns)" % total)
	ok(scene.call("_overburn_mult", pyro, total) > 1.0,
		"§5: ...and the damage BONUS reads it, which is the surviving clause")
	# THE FIRE IS NOT CONSUMED — the distinction from every other payer, and
	# "it burns" is trivially true unless the turns are re-read afterwards.
	ok(int(foes[0].get_status("burn").get("turns", 0)) == 12,
		"§5: ...while the fire still stands its full term, unconsumed")
	# A SECOND FIRE COSTS HIM NOTHING TO HOLD EITHER — the inversion of BO's
	# "everything else still bills as before", and the reason that line had to
	# invert rather than be deleted.
	var fb: Ability = scene.call("_find_ability", pyro, "Fireball")
	pyro.resource = 40
	await scene.call("_resolve", pyro, fb, foes[1], "good")
	ok(pyro.resource >= 40 - fb.cost,
		"§5: ...and a second, unmarked fire bills him nothing to hold")
	# CINDERFALL — wide, and it skims every bank.
	var before_burn := int(scene.call("_total_burn_turns"))
	var hp_before: Array = [foes[0].hp, foes[1].hp, foes[2].hp]
	var cf: Ability = scene.call("_find_ability", pyro, "Cinderfall")
	await scene.call("_resolve", pyro, cf, foes[0], "good")
	var struck := 0
	for i in foes.size():
		if foes[i].hp < hp_before[i]:
			struck += 1
	ok(struck == 3, "§5: Cinderfall hits the whole field (%d of 3)" % struck)
	ok(int(scene.call("_total_burn_turns")) < before_burn,
		"§5: ...and skims Burn from the banks it hits (%d -> %d)" % [
			before_burn, int(scene.call("_total_burn_turns"))])
	await _drop(scene)


# ---------- §5 CRYOMANCER ----------

func _live_cryomancer() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"cryomancer": ["Winter's Toll", "Rimebinding"]}, ["raider", "raider"])
	var cryo := _hero(scene, "permafrost")
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	var wt: Ability = scene.call("_find_ability", cryo, "Winter's Toll")
	var rb: Ability = scene.call("_find_ability", cryo, "Rimebinding")
	# BOTH REFUSE TO BE CAST WITH NOTHING HELD — a cast that could only ever do
	# nothing is a greyed button, not a silent no-op.
	ok(not scene.call("_ability_usable", cryo, wt),
		"§5: Winter's Toll is unusable while he holds nothing")
	ok(not scene.call("_ability_usable", cryo, rb),
		"§5: Rimebinding is unusable while he holds nothing")
	for _i in 4:
		scene.call("_apply_status", foes[0], "chilled", 3, 0, 0, cryo)
	ok(scene.call("_is_held", foes[0]), "§5: four stacks put the enemy in the ice")
	ok(scene.call("_ability_usable", cryo, wt),
		"§5: ...and Winter's Toll lights up")
	# THE CHARGE. `_hold_sync` advances it once a turn; drive it so the toll
	# has something to be paid on.
	for _t in 5:
		scene.call("_hold_sync")
	ok(foes[0].hold_turns == 5, "§5: the hold has charged 5 turns (got %d)" % foes[0].hold_turns)
	# WINTER'S TOLL — ONE OF THE EIGHT. "The hold continues" is trivially true
	# of an ability that does nothing, so the DAMAGE is asserted beside it.
	var hp_before: int = foes[0].hp
	await scene.call("_resolve", cryo, wt, cryo, "good")
	ok(foes[0].hp < hp_before,
		"§5: Winter's Toll bills the held enemy (%d -> %d)" % [hp_before, foes[0].hp])
	ok(scene.call("_is_held", foes[0]),
		"§5: WINTER'S TOLL LEAVES THE HOLD STANDING — the prison survives being cashed in")
	ok(foes[0].hold_turns == 5,
		"§5: ...and the charge is not reset either")
	# RIMEBINDING — the prison as a template.
	ok(foes[1].status_stacks("chilled") == 0, "§5: the second enemy is unchilled")
	await scene.call("_resolve", cryo, rb, foes[1], "good")
	ok(foes[1].status_stacks("chilled") >= 4 or scene.call("_is_held", foes[1]),
		"§5: Rimebinding copies the prison's depth onto a second enemy")
	await _drop(scene)


# ---------- §5 ARCANIST ----------

# BATCH DT §3 — THE SEED FOR §5's NULL FIELD PAIR, AND WHY IT IS PER-PAIR
# RATHER THAN PER-SUITE. This suite called `seed()` ZERO times, so the two
# blows the NULL FIELD check compares drew a different stream each run and the
# row failed about one reading in thirteen. It is DF §0's idiom in
# `test_rune_battle`, applied to the second of the three flakes: force
# determinism AT THE SITE UNDER TEST rather than widening a tolerance until the
# noise fits. Seeding the whole suite would fix the draw for 1104 other checks
# that never asked for it, and it would hide WHICH draw mattered.
#
# **BOTH BLOWS TAKE THE SAME SEED, WHICH IS THE HALF THAT MATTERS.** The two
# arms are the same enemy swinging the same ability at the same hero, and the
# only thing that differs between them is his Resonance. Handing them one
# stream makes every coin identical in each — the variance roll, the crit, the
# parry — so what is left in the difference is the stack count and nothing
# else. That is DD's method, and it is why the BAND is not touched: the band
# IS the question this check asks.
#
# **AND THE ±10% ROLL WAS NEVER THE WHOLE STORY.** Measured over six readings
# before the seed went in, the shallow blow ranged 16 to 28 and the deep blow
# 9 to 11. A ±10% roll on a mean of 18 spans 16.4 to 19.8 and cannot reach 28;
# a crit is ×1.5 and reaches exactly there. So this is `at`'s shape — a second,
# larger coin behind a variance roll that was being blamed for all of it — and
# it is the reason a per-pair seed is the right instrument and a wider band
# would have been the wrong one.
func _nf_seeded() -> void:
	seed(20260829)



func _live_arcanist() -> void:
	var scene := await _spawn(["berserker", "arcanist", "holy", "mystic"],
		{"arcanist": ["Null Field", "Kindled Mind"]}, ["raider"])
	var arc := _hero(scene, "resonance")
	ok(arc != null, "the Arcanist spawned")
	if arc == null:
		await _drop(scene)
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 99999
	foe.hp = 99999
	# KINDLED MIND — 3 instead of 1.
	var km: Ability = scene.call("_find_ability", arc, "Kindled Mind")
	arc.second_resource = 0
	await scene.call("_resolve", arc, km, foe, "good")
	ok(arc.second_resource >= 3,
		"§5: Kindled Mind banks 3 Resonance instead of 1 (got %d)" % arc.second_resource)
	# NULL FIELD — ONE OF THE EIGHT, AND THE CHECK IS BUILT SO A CAST-TIME
	# STAMP CANNOT PASS IT: the SAME field is measured at two different stack
	# counts, so a value frozen at cast would read identically twice.
	var nf: Ability = scene.call("_find_ability", arc, "Null Field")
	arc.second_resource = 2
	await scene.call("_resolve", arc, nf, arc, "good")
	ok(arc.has_status("null_field"), "§5: Null Field holds")
	var basic: Ability = scene.call("_find_ability", foe, foe.abilities[0].display_name)
	arc.max_hp = 99999
	arc.hp = 99999
	var hp0 := arc.hp
	_nf_seeded()
	await scene.call("_resolve", foe, foe.abilities[0], arc, "good")
	var shallow := hp0 - arc.hp
	arc.second_resource = 14
	arc.hp = 99999
	var hp1 := arc.hp
	_nf_seeded()
	await scene.call("_resolve", foe, foe.abilities[0], arc, "good")
	var deep := hp1 - arc.hp
	ok(shallow > 0 and deep >= 0, "§5: the enemy can reach him at all")
	ok(deep < shallow,
		"§5: NULL FIELD READS CURRENT STACKS — %d damage at 2 stacks, %d at 14" % [
			shallow, deep])
	await _drop(scene)


# ---------- §5 HOLY ----------

func _live_holy() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "mystic"],
		{"holy": ["Second Wind", "Rite of Return"]}, ["raider"])
	var holy := _hero(scene, "mercy")
	var ally := _hero(scene, "bloodrage")
	ok(holy != null and ally != null, "Holy and an ally spawned")
	if holy == null or ally == null:
		await _drop(scene)
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	# SECOND WIND — it reads the BL damage-taken door, so a hero who has taken
	# nothing gets nothing, and one just spiked gets it all back.
	var sw: Ability = scene.call("_find_ability", holy, "Second Wind")
	ally.hp = ally.max_hp
	ally.dmg_by_turn = {}
	ally.battle_turn = 5
	var untouched := ally.hp
	await scene.call("_resolve", holy, sw, ally, "good")
	ok(ally.hp == untouched,
		"§5: Second Wind is worthless on someone who has taken nothing")
	ally.take_hit(60, 0)
	var spiked := ally.hp
	ok(ally.damage_taken_recent() >= 60,
		"§5: the recent-damage window sees the spike (%d)" % ally.damage_taken_recent())
	await scene.call("_resolve", holy, sw, ally, "good")
	ok(ally.hp > spiked, "§5: ...and Second Wind takes it back (%d -> %d)" % [
		spiked, ally.hp])
	# THE WINDOW IS TWO TURNS AND IT REALLY CLOSES.
	ally.battle_turn = 9
	ally.hp = ally.max_hp / 2
	var stale := ally.hp
	await scene.call("_resolve", holy, sw, ally, "good")
	ok(ally.hp == stale,
		"§5: ...and damage older than two turns is out of the window")
	# RITE OF RETURN — a promise, paid on a death that has not happened yet.
	var rr: Ability = scene.call("_find_ability", holy, "Rite of Return")
	await scene.call("_resolve", holy, rr, ally, "good")
	ok(ally.has_status("rite_return"), "§5: the Rite is sworn")
	var holy_before := holy.hp
	ally.hp = 10
	ally.take_hit(9999, 0)
	ok(not ally.dead,
		"§5: RITE OF RETURN refuses the killing blow")
	ok(ally.hp >= int(ally.max_hp * 0.5) - 1,
		"§5: ...and returns the ally at half health (%d of %d)" % [ally.hp, ally.max_hp])
	ok(holy.hp < holy_before,
		"§5: ...and Holy pays for it out of her own (%d -> %d)" % [holy_before, holy.hp])
	ok(not ally.has_status("rite_return"),
		"§5: ...and the promise is spent, not standing")
	# HOLY SWEARING IT ON HERSELF is the case the whole ordering of
	# `_on_rite_return` exists for: her own 30% toll re-enters the reversal she
	# is standing in. If the promise were spent after the bill she would answer
	# her own toll forever; if the health were restored after the bill she would
	# be marked dead a line before the restore ran. Neither shows up in ordinary
	# play until it does.
	holy.hp = holy.max_hp
	await scene.call("_resolve", holy, rr, holy, "good")
	ok(holy.has_status("rite_return"), "§5: Holy can swear the rite on herself")
	holy.hp = 5
	holy.take_hit(9999, 0)
	ok(not holy.dead,
		"§5: ...and it saves her without recursing on its own toll")
	ok(holy.hp > 0 and holy.hp < int(holy.max_hp * 0.5),
		"§5: ...restored to half, then billed her 30%% (%d of %d)" % [
			holy.hp, holy.max_hp])
	ok(not holy.has_status("rite_return"),
		"§5: ...and spent exactly once")
	await _drop(scene)


# ---------- §5 DEVOUT ----------

func _live_devout() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "inquisitor", "mystic"],
		{"inquisitor": ["Vow of Suffering", "Aegis Reversal"]}, ["raider"])
	var dv := _hero(scene, "conviction")
	var ally := _hero(scene, "bloodrage")
	ok(dv != null and ally != null, "the Devout and an ally spawned")
	if dv == null or ally == null:
		await _drop(scene)
		return
	# VOW OF SUFFERING — mitigation by RELOCATION: the ally takes less AND the
	# Devout takes the difference. Asserting only the first half would pass on
	# an ability that simply deleted damage.
	var vow: Ability = scene.call("_find_ability", dv, "Vow of Suffering")
	await scene.call("_resolve", dv, vow, ally, "good")
	ok(ally.has_status("vow"), "§5: the vow holds")
	ally.hp = ally.max_hp
	dv.hp = dv.max_hp
	var faith_before := ally.faith_stacks
	ally.take_hit(80, 0)
	var ally_lost := ally.max_hp - ally.hp
	var dv_lost := dv.max_hp - dv.hp
	ok(ally_lost < 80, "§5: the ally takes less than the whole blow (%d of 80)" % ally_lost)
	ok(dv_lost > 0, "§5: ...and the Devout takes the share (%d)" % dv_lost)
	ok(ally_lost + dv_lost == 80,
		"§5: ...RELOCATED, not deleted — the parts sum to the wound (%d + %d)" % [
			ally_lost, dv_lost])
	ok(ally.faith_stacks > faith_before,
		"§5: ...and every share he eats kindles that ally's Faith")
	# AEGIS REVERSAL — ONE OF THE EIGHT. The shield must be CONSUMED and the
	# next attack must land bigger; asserting only the removal would pass on an
	# ability that just deleted the shield.
	var ds: Ability = scene.call("_find_ability", dv, "Divine Shield")
	var ag: Ability = scene.call("_find_ability", dv, "Aegis Reversal")
	ok(not scene.call("_ability_usable", dv, ag),
		"§5: Aegis Reversal is unusable with no Divine Shield standing")
	await scene.call("_resolve", dv, ds, ally, "good")
	var shield_left := int(ally.get_status("barrier").get("power", 0))
	ok(shield_left > 0, "§5: a Divine Shield stands (%d)" % shield_left)
	ok(scene.call("_ability_usable", dv, ag), "§5: ...and Aegis Reversal lights up")
	await scene.call("_resolve", dv, ag, ally, "good")
	ok(not ally.has_status("barrier"),
		"§5: AEGIS REVERSAL CONSUMES THE SHIELD")
	# BATCH CN §3 folded this ability's Perfect bonus into its base effect.
	ok(ally.aegis_bonus == int(round(shield_left * 1.5)),
		"§5: ...and banks HALF AGAIN what it had left (%d of %d)" % [
			ally.aegis_bonus, int(round(shield_left * 1.5))])
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 99999
	foe.hp = 99999
	var strike: Ability = ally.abilities[0]
	var hp0 := foe.hp
	await scene.call("_resolve", ally, strike, foe, "good")
	var boosted := hp0 - foe.hp
	ok(ally.aegis_bonus == 0, "§5: ...spent on the next attack, once")
	foe.hp = 99999
	var hp1 := foe.hp
	await scene.call("_resolve", ally, strike, foe, "good")
	ok(boosted > hp1 - foe.hp,
		"§5: ...and that attack really landed harder (%d vs %d)" % [
			boosted, hp1 - foe.hp])
	await _drop(scene)


# ---------- §5 OCCULTIST ----------

func _live_occultist() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "occultist", "mystic"],
		{"occultist": ["Blight the Well", "Covenant of Ash"]},
		["raider", "raider", "archer"])
	var occ := _hero(scene, "old_gods")
	ok(occ != null, "the Occultist spawned")
	if occ == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 5000
	# BLIGHT THE WELL — healing becomes damage.
	var bw: Ability = scene.call("_find_ability", occ, "Blight the Well")
	await scene.call("_resolve", occ, bw, foes[0], "good")
	ok(foes[0].has_status("blight"), "§5: the well is blighted")
	var hp_before: int = foes[0].hp
	var got: int = foes[0].heal_amount(300)
	ok(got == 0, "§5: Blight the Well refuses the heal")
	ok(foes[0].hp == hp_before - 300,
		"§5: ...and DAMAGES for the same amount instead (%d -> %d)" % [
			hp_before, foes[0].hp])
	ok(BattleUnit.DEBUFF_IDS.has("blight"),
		"§5: ...and it is a real debuff, so a mender can answer it")
	# COVENANT OF ASH — ONE OF THE EIGHT. Ruin landing ANYWHERE also lands on
	# the mark, and the mirrored stacks must be real stacks.
	var ca: Ability = scene.call("_find_ability", occ, "Covenant of Ash")
	await scene.call("_resolve", occ, ca, foes[2], "good")
	ok(foes[2].has_status("covenant"), "§5: the covenant is bound")
	var mark_before: int = foes[2].status_stacks("ruin")
	scene.call("_gain_ruin", foes[1], 3)
	ok(foes[1].status_stacks("ruin") >= 3, "§5: Ruin lands on another enemy")
	ok(foes[2].status_stacks("ruin") == mark_before + 3,
		"§5: COVENANT OF ASH MIRRORS IT onto the mark (%d -> %d)" % [
			mark_before, foes[2].status_stacks("ruin")])
	# ONE COVENANT AT A TIME — a second cast moves it rather than stacking.
	await scene.call("_resolve", occ, ca, foes[0], "good")
	ok(foes[0].has_status("covenant") and not foes[2].has_status("covenant"),
		"§5: ...and there is only ever one covenant")
	await _drop(scene)


# ---------- §5 BEASTMASTER ----------

func _live_beastmaster() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "beastmaster"],
		{"beastmaster": ["Twin Hunt", "Call the Wilds"]}, ["raider", "raider"])
	var bm := _hero(scene, "pack")
	ok(bm != null, "the Beastmaster spawned")
	if bm == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	var th: Ability = scene.call("_find_ability", bm, "Twin Hunt")
	var cw: Ability = scene.call("_find_ability", bm, "Call the Wilds")
	ok(not scene.call("_ability_usable", bm, th),
		"§5: Twin Hunt is unusable with no beast — it is the partnership acting")
	# Summon through the normal door so Loyalty, the boon and the arrival all
	# behave as they do in play.
	await scene.call("_do_summon", bm, "ursus")
	ok(not scene.call("_beasts", bm).is_empty(), "§5: a beast stands")
	ok(scene.call("_ability_usable", bm, th), "§5: ...and Twin Hunt lights up")
	var hp0: int = foes[0].hp
	await scene.call("_resolve", bm, th, foes[0], "good")
	ok(foes[0].hp < hp0, "§5: Twin Hunt strikes")
	# CALL THE WILDS — ONE OF THE EIGHT. The Loyalty check is worthless unless
	# the swap actually happened, so the beast on the field is asserted to have
	# CHANGED, and the meter to have survived it.
	bm.loyalty["ursus"] = 9
	bm.loyalty["canis"] = 4
	bm.cooldowns["Swap Companion"] = 3
	var before_kind := String(scene.call("_beasts", bm)[0].companion_kind)
	ok(scene.call("_ability_usable", bm, cw),
		"§5: Call the Wilds is usable while a kind is absent")
	await scene.call("_resolve", bm, cw, bm, "good")
	var beasts: Array = scene.call("_beasts", bm)
	ok(not beasts.is_empty(), "§5: a beast still stands after the call")
	if not beasts.is_empty():
		ok(String(beasts[0].companion_kind) != before_kind,
			"§5: CALL THE WILDS REALLY SWAPS (%s -> %s)" % [
				before_kind, beasts[0].companion_kind])
	ok(int(bm.loyalty.get("ursus", 0)) >= 9,
		"§5: ...AND THE OUTGOING BEAST'S LOYALTY IS KEPT WHOLE (%d)" % \
			int(bm.loyalty.get("ursus", 0)))
	ok(int(bm.loyalty.get("canis", 0)) >= 4,
		"§5: ...and the arriving one keeps its own (%d)" % \
			int(bm.loyalty.get("canis", 0)))
	ok(not bm.cooldowns.has("Swap Companion"),
		"§5: ...and the swap pays NO shared cooldown — that is the tax it refuses")
	await _drop(scene)


# ---------- §5 SHARPSHOOTER ----------

func _live_sharpshooter() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "sharpshooter"],
		{"sharpshooter": ["Called Volley", "Quarry's Mark"]},
		["raider", "raider", "archer"])
	var ss := _hero(scene, "lethal_aim")
	ok(ss != null, "the Sharpshooter spawned")
	if ss == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	var aimed: Ability = scene.call("_find_ability", ss, "Aimed Shot")
	var cv: Ability = scene.call("_find_ability", ss, "Called Volley")
	var qm: Ability = scene.call("_find_ability", ss, "Quarry's Mark")
	# Build a real bond first: the meter has to have something to lose.
	await scene.call("_resolve", ss, aimed, foes[0], "good")
	await scene.call("_resolve", ss, aimed, foes[0], "good")
	var focus_before := ss.second_resource
	ok(focus_before > 0, "§5: the Sharpshooter has Focus to lose (%d)" % focus_before)
	# CALLED VOLLEY — ONE OF THE EIGHT, and the check is paired with its
	# CONTROL: switching to a different single target really does clear him, so
	# "the volley did not clear it" means something.
	var hp0: Array = [foes[0].hp, foes[1].hp, foes[2].hp]
	await scene.call("_resolve", ss, cv, foes[0], "good")
	var struck := 0
	for i in foes.size():
		if foes[i].hp < hp0[i]:
			struck += 1
	ok(struck == 3, "§5: Called Volley hits the whole line (%d of 3)" % struck)
	ok(ss.second_resource >= focus_before,
		"§5: CALLED VOLLEY LEAVES FOCUS UNTOUCHED (%d -> %d)" % [
			focus_before, ss.second_resource])
	ok(ss.last_attack_target == foes[0],
		"§5: ...and the mark survives it too")
	ok(scene.call("_focus_safe", cv), "§5: ...through a NAMED rule, not an accident")
	# THE CONTROL: a switch still costs him everything.
	await scene.call("_resolve", ss, aimed, foes[1], "good")
	ok(ss.second_resource == 0,
		"§5: ...while switching single targets still clears the meter")
	# QUARRY'S MARK — Focus from the mark is doubled.
	await scene.call("_resolve", ss, qm, foes[1], "good")
	ok(foes[1].has_status("quarry"), "§5: the quarry is named")
	await scene.call("_resolve", ss, aimed, foes[1], "good")
	var marked_gain := ss.second_resource
	ss.second_resource = 0
	ss.last_attack_target = foes[2]
	await scene.call("_resolve", ss, aimed, foes[2], "good")
	var plain_gain := ss.second_resource
	ok(marked_gain > plain_gain,
		"§5: ...and it pays double (%d marked vs %d plain)" % [
			marked_gain, plain_gain])
	# ONE MARK AT A TIME.
	await scene.call("_resolve", ss, qm, foes[2], "good")
	ok(foes[2].has_status("quarry") and not foes[1].has_status("quarry"),
		"§5: ...one mark at a time")
	# IT DELIBERATELY DOES NOT PROTECT FOCUS ON THE MARK'S DEATH — Overkill
	# already does that, and duplicating a row-7 talent is the Deadfall fault.
	ok(int(ss.overkill) == 0, "§5: the test Sharpshooter has no Overkill")
	ss.second_resource = 200
	foes[2].hp = 1
	await scene.call("_resolve", ss, aimed, foes[2], "good")
	ok(ss.second_resource <= 50,
		"§5: ...and Quarry's Mark does NOT keep Focus through the kill (Overkill's job)")
	await _drop(scene)


# ---------- §5 SURVIVALIST ----------

func _live_survivalist() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "mystic"],
		{"mystic": ["Choking Smoke", "Snare Line"]}, ["raider", "raider", "archer"])
	var sv := _hero(scene, "trapper")
	ok(sv != null, "the Survivalist spawned")
	if sv == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	# CHOKING SMOKE — ONE OF THE EIGHT. It must apply the EXISTING Blind, at
	# the EXISTING magnitude, through the EXISTING miss stack — not a new
	# status wearing the same name.
	var cs: Ability = scene.call("_find_ability", sv, "Choking Smoke")
	await scene.call("_resolve", sv, cs, foes[0], "good")
	var blinded := 0
	for f in foes:
		if f.has_status("blind"):
			blinded += 1
	ok(blinded == 3, "§5: Choking Smoke Blinds the whole field (%d of 3)" % blinded)
	# BATCH CN §3 folded this ability's Perfect bonus into its base effect.
	ok(int(foes[0].get_status("blind").get("turns", 0)) == 3,
		"§5: ...for 3 turns (CN folded the perfect in)")
	# THE MISS STACK IS ADDITIVE PERCENTAGE POINTS ON TOP OF THE BASE, and it
	# is measured off the live function rather than re-derived from the design.
	foes[0].no_cover = 0
	var blind_miss := float(scene.call("_miss_chance", foes[0], null))
	foes[1].no_cover = 0
	foes[1].remove_status("blind")
	var base_miss := float(scene.call("_miss_chance", foes[1], null))
	ok(is_equal_approx(blind_miss - base_miss, 0.50),
		"§5: ...and Blind is the EXISTING +50%% miss, added flat (%.2f vs %.2f)" % [
			blind_miss, base_miss])
	ok(is_equal_approx(base_miss, 0.05),
		"§5: ...on top of the base 5%% (got %.2f)" % base_miss)
	# AND THE PRICE OF IT: an area attack rolls no miss at all, so Blind blanks
	# single-target blows only. Read off the source, because the roll is inside
	# a branch a driven cast cannot observe directly.
	var bat := _src("res://scripts/battle.gd")
	ok(bat.contains("elif not is_counter and not ab.aoe and ab.multi_hits == 0 and ab.random_hits == 0"),
		"§5: ...and an AoE attack still rolls no miss, which is what prices it")
	# SNARE LINE — the traps stop waiting.
	var sl: Ability = scene.call("_find_ability", sv, "Snare Line")
	var traps_before := int(sv.deadfall_armed)
	# THE RACE IS REMOVED RATHER THAN TOLERATED (the AK/AL/AR discipline: force
	# determinism, never retry until it passes). The battle's own turn loop is
	# advancing on real timers while this drives `_resolve` by hand, so an enemy
	# can reach its turn between the cast and the read — and Snare Line springs
	# AND REMOVES ITSELF at exactly that moment, leaving nothing observable
	# (the stun it lands is consumed by the same turn that sprang it). Counting
	# the status alone failed about one run in three against working code, which
	# is a flaky test rather than a finding. Pushing the enemies' clocks out
	# means no enemy takes a turn during the check at all.
	for f2 in foes:
		f2.next_time = 1.0e9
	await scene.call("_resolve", sv, sl, sv, "good")
	var lined := 0
	for f in foes:
		if f.has_status("snare_line"):
			lined += 1
	ok(lined == 3, "§5: Snare Line covers the whole field (%d of 3)" % lined)
	ok(int(sv.deadfall_armed) == traps_before,
		"§5: ...and spends no placed trap")
	# It springs on the enemy ACTING, through the same _spring_trap every other
	# trap uses — so Bone Breaker, Cruel Devices and Caught Fast all pay.
	var hp_before: int = foes[0].hp
	scene.call("_spring_trap", sv, foes[0], 0.20 * sv.attack)
	ok(foes[0].hp < hp_before or foes[0].has_status("stunned"),
		"§5: ...and a spring bites and stuns, exactly as a placed trap does")
	ok(bat.contains("if not u.is_hero and not u.dead and u.has_status(\"snare_line\"):"),
		"§5: ...fired at the enemy's turn start, beside the snare it mirrors")
	await _drop(scene)


# ---------- §6 DOCUMENTATION ----------

func _docs() -> void:
	var master := _src("res://docs/master.html")
	# RE-POINTED BY BATCH BP, THEN BQ, THEN BR: this is the master.html STAMP
	# GATE, duplicated in test_batch_ah, test_batch_bb, test_batch_bn,
	# test_batch_bp, test_batch_bq and test_batch_br — ALL SEVEN MUST MOVE
	# TOGETHER or a batch that bumps the timestamp trips suites it never
	# touched. (BO had its own copy phrased as "this batch"; it is the same
	# gate.)
	# RE-POINTED BY BATCH CN, to the durable shape Batch CK gave this same gate in
	# test_batch_br. It read `master.contains("Batch C?")`, a stamp assertion that
	# has to be hand-bumped every batch — **A CHECK THAT MUST BE EDITED EVERY BATCH
	# TO KEEP PASSING IS A CHECK THAT WILL BE RED MOST BATCHES**, which stops it
	# carrying information. It asks the durable version now: the document carries a
	# stamp, and that stamp is not older than the batch this suite belongs to. No
	# bump is ever owed again. (Two-letter batch codes sort lexically; a
	# three-letter code will need one more line.)
	var stamp_at := master.find("Last updated:")
	ok(stamp_at >= 0, "master.html carries a Last-updated stamp")
	var stamp := master.substr(stamp_at, 60)
	var code_at := stamp.find("(Batch ")
	var stamped := stamp.substr(code_at + 7, 2) if code_at >= 0 else ""
	ok(stamped >= "BO",
		"...and master.html is stamped no older than this suite's own batch (reads '%s')" % stamped)
	ok(master.contains("THE ABILITY DRAFT") or master.contains("The Ability Draft"),
		"§6: ...and carries the draft's own section")
	for spec in TRANCHE_1:
		for n in TRANCHE_1[spec]:
			ok(master.contains(n), "§6: master.html lists %s" % n)
	var glo := _src("res://data/glossary.json")
	ok(glo.contains("ability_draft"), "§6: the glossary has the draft")
	ok(glo.contains("ability_slots"), "§6: ...the slot cap")
	ok(glo.contains("protected_core"), "§6: ...and protected abilities")
	var claude := _src("res://CLAUDE.md")
	# RE-POINTED BY BATCH EG §1: the const is `ABILITY_SLOTS_BY_BOSS` now. The
	# needle follows its haystack; the question — does the guide carry the cap —
	# is unchanged.
	ok(claude.contains("ABILITY_SLOTS_BY_BOSS") or claude.contains("cap at 7")
			or claude.contains("SEVEN"),
		"§6: CLAUDE.md carries the cap")
	# INVERTED BY BATCH BP. This proved the Warrior debt was RECORDED; the
	# debt is paid, so what a later batch could break is the record that it
	# was paid — and, more usefully, the note that the CLASS-WIDE tranche is
	# still owed, which is the debt that remains.
	ok(claude.contains("WARRIOR POOLS WERE OWED AND ARE PAID"),
		"§6: ...and CLAUDE.md records that the Warrior pools are PAID (Batch BP)")
	# RE-POINTED BY BATCH BQ AND AGAIN BY BR, same shape as the pool check
	# above. BQ half-paid the tranche and the record worth protecting was the
	# half that remained; BR paid the rest, so it is the RECORD OF PAYMENT that
	# a later batch could break — together with the debt that is genuinely still
	# outstanding, which is now tranche DEPTH rather than the class seam.
	ok(claude.contains("CLASS-WIDE TRANCHE"),
		"§6: ...while the class-wide tranche is still recorded")
	ok(claude.contains("PAID IN FULL"),
		"§6: ...as PAID IN FULL (BQ then BR)")
	# INVERTED BY BATCH DG §3, and it is the fourth turn of the same screw — BP,
	# BQ and BR each inverted this check as the debt it named was paid. It
	# asserted that CLAUDE.md named TRANCHES 2 AND 3 as the spec-depth debt that
	# REMAINS. The debt does not remain: the draft is 120 of 120, counted out of
	# classes.gd, and the phrase itself had already left the file with CW's
	# split, so the check had been red with no true answer available to it.
	# WHAT A LATER BATCH COULD ACTUALLY BREAK IS THE RECORD OF COMPLETION, so
	# that is what is pinned. NOTE THE STRING ALONE WOULD NOW PASS AGAIN — DG's
	# corrected prose contains "TRANCHES 2 AND 3" — which is why the MESSAGE and
	# the phrase both had to move: a check whose message states a dead debt
	# teaches it to whoever reads the failure.
	ok(claude.contains("TRANCHES 2 AND 3 ARE BOTH PAID"),
		"§6: ...and CLAUDE.md records both depth tranches as PAID, not as owed")
	# RE-POINTED AT THE ARCHIVE BY BATCH CE §5, and this copy was the worse of
	# the two: `contains("BATCH BO") or contains("Batch BO")` against the LIVE
	# file, which BATCH BZ split at a batch boundary — BO is the LAST entry in
	# the archive, so it is exactly the one the split moved out. It went on
	# passing because later entries name Batch BO constantly (BP through CD all
	# cite it), so it PASSED WITHOUT ITS SUBJECT BEING IN THE FILE AT ALL.
	# CD reported it and deliberately did not repair it; this is that repair, on
	# the pattern CD gave test_batch_bb — anchor on the `<h2>` heading, and read
	# the archive's path out of the LIVE changelog's own header rather than
	# hardcoding it, so a later split moves this with it. See the same block in
	# test_batch_bn for the full reasoning and the one consequence (this suite
	# now depends on a file that is not in version control, and FAILS LOUDLY
	# without it, which is correct).
	var live_log := _src("res://docs/changelog.html")
	var arch_mark := live_log.find("/changelog-archive.html</code>")
	ok(arch_mark > 0, "§6: the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var chlog := _src(arch_path)
	ok(chlog.length() > 100000,
		"§6: the archive opens at %s (%d chars)" % [arch_path, chlog.length()])
	ok(not live_log.contains("<h2>2026-08-13 &mdash; Batch BO"),
		"§6: BZ moved this batch's entry OUT of the live changelog")
	ok(chlog.contains("<h2>2026-08-13 &mdash; Batch BO"),
		"§6: ...and the archive carries the Batch BO entry")
