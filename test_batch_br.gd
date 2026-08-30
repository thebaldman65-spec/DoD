# test_batch_br.gd — THE HUNTER AND WARRIOR CLASS POOLS. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_br.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §6 of the brief names SIX clauses that could silently do
# nothing or do the wrong thing, and every one is driven live and asserted
# against the state it is supposed to have changed:
#   · Aimed Volley spending THREE Arcane Arrows charges and firing the splash
#     three times — §1's hits-not-casts rule, measured;
#   · Arcane Arrows' charges waiting until SPENT rather than expiring on a turn
#     count;
#   · Battle Trance healing 3% plus HALF THE DAMAGE TAKEN SINCE HIS LAST TURN,
#     with the accumulator clearing at each tick and the floor paying when he
#     took nothing;
#   · Rally moving the ally to the FRONT of the order through the existing
#     initiative hook, and not enabling unbounded consecutive turns;
#   · Camouflage and Ghillie Suit held together resolving sensibly rather than
#     one silently overwriting the other;
#   · Ironclad (BR authored it as IRON WILL; renamed at CK §2) refusing Stun,
#     Freeze and Daze, and his Break meter reaching
#     EXACTLY 99 and stopping — then breaking on the first hit after it lapses.
#   · plus `CLASS_POOLS` byte-unchanged, asserted as literals — the same
#     negative control BQ used, because a boss offer quietly re-weighting is
#     the failure the separate structure exists to prevent.
#
# SIX OF THEM WOULD PASS ON BROKEN CODE IF WRITTEN THE OBVIOUS WAY, so each is
# built so a broken implementation still FAILS:
#   · "a volley spends charges" is trivially true of an ability that spends one
#     — so the count is asserted as an EXACT identity (5 -> 2), and a
#     single-strike ability is asserted to spend exactly ONE in the same check,
#     which is what tells "three per volley" from "three per cast";
#   · "the charges persist" is trivially true if nothing ever ticks — so the
#     status list is TICKED by hand several times and the count re-read;
#   · "Battle Trance heals" is trivially true of a plain low-health heal — so
#     it is measured where the two readings DIFFER by construction: damage
#     taken and missing health are set to different numbers on purpose;
#   · "Rally moves the ally" is trivially true of any write to `next_time` — so
#     the ally is asserted to be the unit `_next_unit` actually returns;
#   · "Camouflage makes him harder to hit" is trivially true of a second roll —
#     so the combined chance is asserted to be HIGHER than either alone and
#     LOWER than their sum, which only independent combination gives;
#   · "Ironclad stops the Break" is trivially true of zeroing the meter — so
#     the meter is asserted to sit at EXACTLY 99, which "the meter cannot fill"
#     and "Broken is refused" both fail.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const REAL_SAVE := "user://run_save.bin"

# The twelve, by pool. Held here as a literal so the live dict and this file
# have to agree — a name added to one and not the other trips.
const TRANCHE_4 := {
	"hunter": ["Field Dressing", "Camouflage", "Aimed Volley", "Bola",
		"Hunter's Mark", "Arcane Arrows"],
	# RE-POINTED BY BATCH CK §2: this entry was "Iron Will". The card took the
	# name its own status has always carried; the WARDEN TALENT keeps Iron Will.
	"warrior": ["Battle Trance", "Rally", "Charge", "Cleave", "Warcry",
		"Ironclad"],
}

# THE SAME TWELVE AS BATCH BR SHIPPED THEM, FROZEN. The only difference from
# TRANCHE_4 is Ironclad, which BR called Iron Will (renamed at CK §2). This list
# is what the CHANGELOG is checked against — an old entry records what its batch
# did and is never edited forward — while TRANCHE_4, the live pool, is what
# master.html is checked against. A later rename adds a line here and changes
# TRANCHE_4; if the two ever collapse back into one, the difference between
# history and current truth has been lost.
const AS_BR_SHIPPED := ["Field Dressing", "Camouflage", "Aimed Volley", "Bola",
	"Hunter's Mark", "Arcane Arrows", "Battle Trance", "Rally", "Charge",
	"Cleave", "Warcry", "Iron Will"]

# THE NEGATIVE CONTROL THAT MATTERS (§6). `CLASS_POOLS` feeds the BOSS pick,
# and the whole reason `CLASS_DRAFT_POOLS` is a separate structure is that
# dropping twelve entries into this one would silently re-weight every boss
# offer in the game. Asserted as a literal, not as a size: a swap of two names
# would keep the count and change every draw.
const CLASS_POOLS_AT_BR := {
	"warrior": ["Bloodlust", "Wildstrikes", "Hack and Slash", "Blood Price",
		"Battle Shout", "Rampage", "Mocking Blow", "Crushing Blow", "War Stomp",
		"Shieldwall", "Interpose", "Hold the Line", "Overpower", "Pommel Strike",
		"Shatterpoint", "Sweeping Strikes", "Execute", "Rallying Shout"],
	"mage": ["Flamewave", "Firestorm", "Razor Ice", "Blizzard",
		"Ice Lance", "Rime", "Arcane Barrage", "Mana Shield", "Arcane Surge",
		"Reality Fracture", "Phoenix Rebirth", "Ashes of Al'ar"],
	"cleric": ["Heal", "Renewal", "Divine Shield", "Consecrated Ground",
		"Blessing of Zeal", "Sacred Resolve", "Bulwark of Fortitude", "Bewitch",
		"Dark Pact", "Mind Flay", "Mass Hysteria", "Dawnbreak", "Sanctuary",
		"Divine Wrath"],
	"hunter": ["Hunter's Instinct", "Mark of the Hunt", "Aimed Shot", "Powershot",
		"Hold Breath", "Quick Draw", "Triple Shot", "Pinning Shot", "Called Shot",
		"Tripwire", "Shrapnel Charge", "Snare Trap", "Explosive Shot",
		"Venom Coating", "Hamstring", "Deadfall", "Harvest"],
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
	Profile.save_path = "user://profile_batch_br_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_class_pools_untouched()
	_break_damage()
	_weaker_half()
	_names_swept()
	_draft_flow()
	_seam()
	await _live_hunter_tools()
	await _live_arcane_arrows()
	await _live_camouflage()
	await _live_warrior_tools()
	await _live_battle_trance()
	await _live_rally()
	await _live_iron_will()
	await _live_hits_not_casts()
	_docs()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	var scratch := "user://profile_batch_br_test.json"
	if FileAccess.file_exists(scratch):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))

	print("\n=== BATCH BR ===")
	print("checks: %d   failures: %d" % [checks, fails.size()])
	for fl in fails:
		print("  FAIL: %s" % fl)
	quit()


# ---------- §2/§3/§4 THE POOLS, AND THE SEAM CLOSING ----------

func _pools() -> void:
	ok(Classes.CLASS_DRAFT_POOLS.size() == 4,
		"§4: CLASS_DRAFT_POOLS still keys all four classes")
	var total := 0
	for cls in Classes.CLASS_DRAFT_POOLS:
		total += Classes.CLASS_DRAFT_POOLS[cls].size()
	# BATCH DX §1 — A FLOOR, NOT AN EQUALITY. The draft is a collection that
	# GROWS — DO added twenty-two, DR a net +1, DS six — and each time, this
	# line had to be hand-bumped in a dozen files at once. An equality here reds
	# on the next batch that authors a card, and that failure reads exactly like
	# a regression. THE FLOOR IS THE HALF THIS SUITE OWNS: a pool quietly
	# EMPTYING still trips it. The ONE surviving equality is `test_batch_cd`'s,
	# beside `PER_SPEC_DEPTH` — the authoritative table a new card must move.
	ok(total >= 24,
		"§0: the class-wide pool has FALLEN to %d, below the twenty-four that shipped" % total)
	# EVERY class pool holds six — the seam is closed, and this is the assertion
	# that keeps it closed. BQ's own suite recorded the debt as an assertion so
	# it stayed visible; this is the same discipline pointed the other way.
	for cls2 in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls2).size() >= 6,
			"§0: the %s class pool has FALLEN below six (%d)" % [
				cls2, Classes.class_draft_pool(cls2).size()])
	for cls3 in TRANCHE_4:
		var live: Array = Classes.class_draft_pool(cls3)
		for nm in TRANCHE_4[cls3]:
			ok(live.has(nm), "§2/§3: %s is in the %s class pool" % [nm, cls3])
	# THE DRAFT WAS 48 OF 120 AT BR, AND TRANCHES 2 AND 3 WERE STILL OWED. Recorded as
	# an assertion for the same reason BQ recorded its own debt: a later batch
	# reading "the seam is closed" must not read it as "the draft is finished".
	var spec_total := 0
	for sp in Classes.SPEC_DRAFT_POOLS:
		spec_total += Classes.SPEC_DRAFT_POOLS[sp].size()
	# RE-POINTED IN PLACE (Batch BT), AND ALL THREE ARE INVERSIONS — the honest
	# treatment when a batch pays a debt an older suite was recording. BR pinned
	# these to stop a later reader taking "the class seam is closed" for "the
	# draft is finished"; BT paid the FIRST THIRD of tranche 2 (nine Mage
	# cards), so what has to be recorded now is that the debt is PARTLY paid and
	# UNEVEN. The setups are byte-identical, because they are still what tells
	# the two answers apart.
	# RE-POINTED AGAIN BY BATCH BV, same inversion a third time: BV paid the
	# HUNTER third, so nine specs are five deep and ONLY THE WARRIOR THREE are
	# still at two. What has to be recorded now is that the debt is nearly paid
	# and still uneven — and that the last unpaid third is the Warrior's.
	# RE-POINTED AGAIN BY BATCH BW, WHICH CLOSES TRANCHE 2: the Warrior third
	# landed, so SPEC_DRAFT_POOLS is BP's 24 plus tranche 2's 36 and the whole
	# draft is 84.
	# RE-POINTED BY BATCH CB: tranche 3's first third landed, so the spec
	# pools are 60 plus the Mage nine and the whole draft is 93. The check is
	# what would catch a pool quietly EMPTYING, which is why it is a pinned
	# count rather than a range.
	# RE-POINTED BY BATCH CI and the MESSAGE CORRECTED BY BATCH DG §3: it named
	# 60 plus two nines — 78 — while asserting 96, because CH's and CI's thirds
	# landed after it was last rewritten. The count was right and the sentence
	# beside it was three tranches old.
	ok(spec_total >= 125,
		"§4+tranche 3: SPEC_DRAFT_POOLS has FALLEN to %d, below the 125 that shipped"
			% spec_total)
	ok(spec_total + total >= 149,
		"§0+DO+DR+DS: the draft has FALLEN to %d, below the 149 that shipped" % (spec_total + total))
	# THE UNEVENNESS IS GONE, AND THAT IS THE INVERSION. Every earlier version of
	# this loop asserted an asymmetry (five here, two there) because the debt was
	# real and had to stay visible in code; BW paid the last of it, so what is
	# asserted now is the FLATNESS. A pool quietly emptying still trips.
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
	for sp2 in ["pyromancer", "cryomancer", "arcanist",
			"holy", "inquisitor", "occultist",
			"beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.spec_draft_pool(sp2).size() >= 8,
			"§0+DO: %s's SPEC pool is at least EIGHT deep" % sp2)
	for sp2 in ["berserker", "warden", "swordmaster"]:
		ok(Classes.spec_draft_pool(sp2).size() >= 8,
			"§0+tranche 3: %s drafts at least EIGHT — the Warrior third is paid" % sp2)
	# EVERY ENTRY RESOLVES THROUGH THE ONE RESOLVER, which is what makes the
	# battle spawn, the hero sheet, the rune filter and the blacksmith pairing
	# all pick them up with no new plumbing.
	for cls4 in TRANCHE_4:
		for nm2 in TRANCHE_4[cls4]:
			var ab: Ability = Classes.pool_ability(nm2)
			ok(ab != null, "§2/§3: %s resolves through Classes.pool_ability" % nm2)
			if ab == null:
				continue
			ok(ab.display_name == nm2, "§2/§3: ...to itself (%s)" % nm2)
			ok(ab.description != "", "§2/§3: ...carrying a description (%s)" % nm2)
			# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
			# perfect. As of CN that is false by design: 113 of the 211 abilities run no
			# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
			# draft card cannot advertise a bonus nothing can fire. The durable question
			# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
			# — which is strictly stronger than what was here and cannot rot as the
			# criterion catches more cards.
			ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
				"§2/§3: ...and states a perfect exactly when it runs a check (%s)" % nm2)
			ok(ab.delay > 0.0, "§2/§3: ...and an initiative cost (%s)" % nm2)
			ok(ab.cooldown > 0, "§2/§3: ...and a cooldown (%s)" % nm2)
			ok(Classes.draft_ability(nm2) != null,
				"§2/§3: ...and it is a DRAFT def, so the bot hook can see it (%s)" % nm2)
	# AND EVERY SPEC OF THE CLASS CAN DRAW IT — §6's own wording: all three
	# Warriors must be able to draw Rally, all three Hunters Field Dressing.
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
		ok(Classes.class_of_spec(spec) == "warrior",
			"§6: %s is a Warrior, so the Warrior class pool is his" % spec)
		ok(Classes.class_draft_pool(Classes.class_of_spec(spec)).has("Rally"),
			"§6: ...and %s can draw Rally" % spec)
	for spec2 in ["beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.class_of_spec(spec2) == "hunter",
			"§6: %s is a Hunter, so the Hunter class pool is his" % spec2)
		ok(Classes.class_draft_pool(Classes.class_of_spec(spec2)).has("Field Dressing"),
			"§6: ...and %s can draw Field Dressing" % spec2)
	# NOTHING IN THE CLASS POOL IS ALSO IN A SPEC POOL. The two sides of one
	# offer must not be able to hold the same card.
	for cls5 in Classes.CLASS_DRAFT_POOLS:
		for nm3 in Classes.CLASS_DRAFT_POOLS[cls5]:
			for spec3 in Classes.SPEC_DRAFT_POOLS:
				ok(not Classes.SPEC_DRAFT_POOLS[spec3].has(nm3),
					"§4: %s is class-wide only, never in %s's spec draft" % [nm3, spec3])


func _class_pools_untouched() -> void:
	# §6's NAMED NEGATIVE CONTROL, asserted directly rather than by a count.
	ok(Classes.CLASS_POOLS.size() == 4, "§4: CLASS_POOLS still keys four classes")
	for cls in CLASS_POOLS_AT_BR:
		var live: Array = Classes.CLASS_POOLS.get(cls, [])
		ok(live == CLASS_POOLS_AT_BR[cls],
			"§4: CLASS_POOLS[%s] is BYTE-UNTOUCHED by this batch" % cls)
	# And the twelve are NOT in it — the tidy-looking edit a later batch would
	# make is exactly the one this asserts against.
	for cls2 in TRANCHE_4:
		for nm in TRANCHE_4[cls2]:
			ok(not Classes.CLASS_POOLS[cls2].has(nm),
				"§4: %s did NOT leak into the boss pool CLASS_POOLS[%s]" % [nm, cls2])


# ---------- §4 BREAK DAMAGE, ASSIGNED RATHER THAN OMITTED ----------

func _break_damage() -> void:
	# THREE of the twelve are attacks. The other nine never strike, and Break
	# from an ability that never strikes is Break from nowhere.
	var want := {
		"Cleave": 15,          # the brief's figure, and it says "each"
		"Aimed Volley": 8,     # §4's 25 read as a TOTAL, split three ways
		"Charge": 20,          # THE DESIGNER'S REPRICE, over the batch's 10
		"Field Dressing": 0, "Camouflage": 0, "Bola": 0, "Hunter's Mark": 0,
		"Arcane Arrows": 0, "Battle Trance": 0, "Rally": 0, "Warcry": 0,
		"Ironclad": 0,   # RE-POINTED BY CK §2, was "Iron Will"
	}
	for nm in want:
		var ab: Ability = Classes.pool_ability(nm)
		ok(ab != null and ab.pressure == int(want[nm]),
			"§4: %s carries %d Break damage (got %s)" % [
				nm, int(want[nm]), "null" if ab == null else str(ab.pressure)])
	# THE SIBLING COMPARISONS THE ASSIGNMENT WAS MADE AGAINST, pinned so a later
	# reprice has to come and say so.
	var volley: Ability = Classes.pool_ability("Aimed Volley")
	var triple: Ability = Classes.pool_ability("Triple Shot")
	ok(volley != null and triple != null
		and volley.pressure * volley.multi_hits <= triple.pressure * triple.multi_hits,
		"§4: Aimed Volley's %d across three is at or under Triple Shot's %d" % [
			volley.pressure * volley.multi_hits, triple.pressure * triple.multi_hits])
	# CHARGE AGAINST THE FREE BASIC — BQ's rule (the floor for a class card is the
	# free core attack), and this is the ONE card in the twenty-four that clears
	# it rather than sitting under it.
	#
	# INVERTED BY THE DESIGNER'S REPRICE, IMMEDIATELY AFTER BR SHIPPED. The batch
	# assigned 10 BD deliberately UNDER Strike's 18 and no `resource_gain` at all,
	# so that what the card bought was the arrival and the Daze. The reprice makes
	# it 20 BD and 30 Rage. The comparison is still exactly the one worth pinning
	# — a class card measured against the free basic — so only the answer moves.
	var charge: Ability = Classes.pool_ability("Charge")
	var strike: Ability = null
	for ab2 in Classes.kit("warrior"):
		if ab2.display_name == "Strike":
			strike = ab2
	ok(strike != null, "§4: the Warrior's free core attack is Strike")
	if strike != null and charge != null:
		ok(charge.pressure > strike.pressure,
			"REPRICE: Charge's %d BD is now OVER the free Strike's %d" % [
				charge.pressure, strike.pressure])
		ok(charge.damage > strike.damage,
			"REPRICE: ...and over it on damage too (%d%% against %d%%)" % [
				charge.damage, strike.damage])
		ok(charge.delay < strike.delay,
			"§4: ...on top of the arrival it always bought (%.1f against %.1f)" % [
				charge.delay, strike.delay])
		# THE TWO THINGS STRIKE STILL WINS ON, pinned so "Charge is strictly
		# better than the free basic" cannot become true by accident.
		ok(charge.resource_gain - charge.cost < strike.resource_gain,
			"REPRICE: Strike still wins on NET Rage (+%d against Charge's +%d)" % [
				strike.resource_gain, charge.resource_gain - charge.cost])
		ok(charge.cooldown > 0 and strike.cooldown == 0,
			"REPRICE: ...and on having no cooldown (Charge sits on %d)" % charge.cooldown)


# ---------- §4 THE "WEAKER" HALF, VERIFIED RATHER THAN TRUSTED ----------

func _weaker_half() -> void:
	# BOLA AGAINST THE SURVIVALIST'S OWN STATUS APPLIERS — §2's named flag,
	# checked as arithmetic rather than asserted as prose. It lands TWO
	# afflictions; Hamstring lands THREE and damage and Break for 10 more Mana,
	# and Shrapnel Charge lands two on TWO targets with damage and 25 Break.
	var bola: Ability = Classes.pool_ability("Bola")
	var ham: Ability = Classes.pool_ability("Hamstring")
	var shrap: Ability = Classes.pool_ability("Shrapnel Charge")
	var pin: Ability = Classes.pool_ability("Pinning Shot")
	ok(bola != null and ham != null and shrap != null and pin != null,
		"§4: the Survivalist's and Sharpshooter's own appliers resolve")
	if bola != null and ham != null and pin != null and shrap != null:
		ok(bola.damage == 0 and bola.pressure == 0,
			"§4: Bola deals no damage and no Break — it is ONLY the two statuses")
		ok(ham.damage > 0 and ham.pressure > 0,
			"§4: ...while Hamstring lands three statuses AND damage AND Break")
		ok(pin.damage > 0 and pin.pressure > 0,
			"§4: ...and Pinning Shot two statuses AND damage AND Break")
		ok(shrap.choose_two and shrap.damage > 0,
			"§4: ...and Shrapnel Charge two statuses on TWO targets, with damage")
		ok(bola.cost < ham.cost and bola.cost < pin.cost and bola.cost < shrap.cost,
			"§4: Bola is the CHEAPEST of the four, which is all it wins on")
	# CAMOUFLAGE AGAINST GHILLIE SUIT — the other named flag. The node is
	# PERMANENT and free; the card is two turns on a 4-turn cooldown for 20
	# Mana, so for a Survivalist already holding it the card is close to a dead
	# draw. Reported rather than re-tuned; the check pins the comparison.
	var ghillie_pct := 0
	for node in Talents.LANE_TREES.get("mystic", []):
		if String(node.get("id", "")) == "sv_ghillie":
			ghillie_pct = int(node.get("payload", {}).get("stat", {}).get("ghillie", 0))
	ok(ghillie_pct == 65, "§2: Ghillie Suit is a permanent 65%% (got %d)" % ghillie_pct)
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("const CAMOUFLAGE_PCT := 70"),
		"§2: Camouflage is 70%, ABOVE the node — bought with Mana, a turn and a clock")
	# AIMED VOLLEY AGAINST TRIPLE SHOT, the class's other multi-hit shot.
	var volley: Ability = Classes.pool_ability("Aimed Volley")
	var triple: Ability = Classes.pool_ability("Triple Shot")
	ok(volley.damage * volley.multi_hits < triple.damage * triple.multi_hits,
		"§4: Aimed Volley's total (%d%%) is under Triple Shot's (%d%%)" % [
			volley.damage * volley.multi_hits, triple.damage * triple.multi_hits])
	ok(volley.cost < triple.cost,
		"§4: ...for less Mana, which is what makes it the FILLER rather than the shot")
	# CLEAVE AGAINST WAR STOMP, the spec card it sits closest to. Same 15% and
	# the same 15 BD; the stomp costs LESS Rage and refuels the party on top, so
	# Cleave is unambiguously the lesser. What it buys is that the three targets
	# are CHOSEN rather than random.
	var cleave: Ability = Classes.pool_ability("Cleave")
	var stomp: Ability = Classes.pool_ability("War Stomp")
	ok(cleave != null and stomp != null, "§4: Cleave and War Stomp both resolve")
	if cleave != null and stomp != null:
		ok(cleave.damage == stomp.damage and cleave.pressure == stomp.pressure,
			"§4: Cleave matches War Stomp on damage and Break (%d%% / %d BD)" % [
				cleave.damage, cleave.pressure])
		ok(cleave.cost > stomp.cost,
			"§4: ...for MORE Rage (%d against %d) and with no party refuel" % [
				cleave.cost, stomp.cost])
		ok(cleave.choose_three and stomp.random_hits == 3,
			"§4: ...and the distinction is CHOSEN three against RANDOM three")
	# FIVE OF THE SIX WARRIOR CARDS BUILD NO RAGE, which was the cleanest
	# statement of "weaker than spec work" a Rage class can be given: every
	# Warrior spec ability builds 10-15 while it spends, and these spend without
	# building. **CHARGE IS THE EXCEPTION AND IT IS THE DESIGNER'S REPRICE**, not
	# an oversight — asserted BY NAME so a later batch cannot quietly add a
	# second one, and so the exception stays a decision.
	for nm in TRANCHE_4["warrior"]:
		var ab: Ability = Classes.pool_ability(nm)
		if nm == "Charge":
			ok(ab != null and ab.resource_gain == 30,
				"REPRICE: Charge builds 30 Rage — the ONE class card that generates")
			continue
		ok(ab != null and ab.resource_gain == 0,
			"§4: %s builds no Rage — the class cards spend without building" % nm)
	# AND IT IS THE ONLY ONE IN ALL TWENTY-FOUR. The Mage, Cleric and Hunter
	# pools have no resource generator at all, so this stays a Warrior-only
	# exception rather than a rule that quietly spread.
	for cls in Classes.CLASS_DRAFT_POOLS:
		for nm2 in Classes.CLASS_DRAFT_POOLS[cls]:
			if nm2 == "Charge":
				continue
			var ab3: Ability = Classes.pool_ability(nm2)
			ok(ab3 != null and ab3.resource_gain == 0,
				"REPRICE: %s (%s) still generates nothing" % [nm2, cls])
	ok(strike_gain() > 0,
		"§4: ...while the free Strike builds %d" % strike_gain())
	ok(Classes.pool_ability("Charge").resource_gain > strike_gain(),
		"REPRICE: and Charge builds MORE than the free basic (30 against %d)" % \
			strike_gain())
	# THE ONE CARD THAT FAILS §4 IN THE OTHER DIRECTION, PINNED AS A FINDING.
	# WARCRY OUT-SIZES BATTLE SHOUT, a Berserker SPEC-pool ability, on its
	# headline number. It ships as specified (§4 says confirm and REPORT, not
	# re-tune) and this check is what makes the report survive: a later batch
	# that re-prices either number trips it and has to read the reasoning first.
	ok(battle_src.contains("const WARCRY_PCT := 20"),
		"§3 FINDING (reported, not re-tuned): Warcry is +20% damage, party-wide, 3 turns")
	ok(battle_src.contains("var shout_base: int = [8, 12, 18][clampi(attacker.battle_shout_node, 0, 2)]"),
		"§3 FINDING: ...against Battle Shout's 8 base, 12 or 18 with its node")
	ok(battle_src.contains("var shout_turns: int = [2, 3, 4][clampi(attacker.battle_shout_node, 0, 2)]"),
		"§3 FINDING: ...and 2, 3 or 4 turns")
	# The bleed term is what keeps the spec card's ceiling above the class one's
	# — worth pinning, because it is the whole argument for shipping as written.
	ok(battle_src.contains("var shout_pct := shout_base + int(shout_bleed / 20.0)"),
		"§3 FINDING: ...plus 1% per 20 enemy bleed, which is the term Warcry has no answer to")


func strike_gain() -> int:
	for ab in Classes.kit("warrior"):
		if ab.display_name == "Strike":
			return ab.resource_gain
	return 0


# ---------- §1 THE NAME SWEEP, RECORDED AS ASSERTIONS ----------

func _names_swept() -> void:
	# §1's second standing rule: a name is swept against the WHOLE roster before
	# it is authored. Two of the twelve collide with a Warden talent NODE, and
	# both are shipped as specified and flagged — a node's name is not an
	# ability name and nothing resolves it. These checks are the report, kept
	# where a later batch will meet it.
	var node_names := {}
	for spec in Talents.LANE_TREES:
		for node in Talents.LANE_TREES[spec]:
			node_names[String(node.get("name", ""))] = spec
	ok(node_names.get("Rally", "") == "warden",
		"§1 COLLISION: 'Rally' is also a Warden talent node (Banner row 2)")
	# RE-POINTED AND PARTLY INVERTED BY BATCH CK §2. BR asserted that "Iron
	# Will" named a Warrior CARD, a Warden NODE and a live status LABEL all at
	# once, and that nothing broke because the ability's own status id was
	# `ironclad`. CK renamed the CARD to Ironclad — the collision is resolved,
	# not merely tolerated — so the clause about the ability's chip wearing the
	# node's word INVERTS instead of being deleted.
	#
	# ASSERTED FROM BOTH ENDS ON PURPOSE: the node must still be there and still
	# be called Iron Will (renaming the wrong half would satisfy a one-sided
	# check), and the CARD must no longer be. A one-sided version of this passes
	# if a later batch renames the talent instead.
	ok(node_names.get("Iron Will", "") == "warden",
		"§1: 'Iron Will' is the Warden talent node (Threat row 3) — and, since CK §2, only that")
	ok(not Classes.class_draft_pool("warrior").has("Iron Will")
		and Classes.class_draft_pool("warrior").has("Ironclad"),
		"§1 (CK §2): ...and no longer a Warrior card — that card is Ironclad")
	ok(Classes.pool_ability("Ironclad") != null
		and Classes.pool_ability("Iron Will") == null,
		"§1 (CK §2): the resolver answers to Ironclad and no longer to Iron Will")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains('u.add_status("iron_will", "Iron Will"'),
		"§1: the NODE's chip keeps the label and keeps the id `iron_will`")
	ok(battle_src.contains('"ironclad": ["Ironclad"'),
		"§1 (CK §2, INVERTED): the ABILITY's chip reads Ironclad, off the id it always had")
	ok(not battle_src.contains('["Iron Will", "IW"'),
		"§1 (CK §2): ...so no status row reads 'Iron Will' any more")
	ok(battle_src.contains('_apply_status(attacker, "ironclad"'),
		"§1: ...and that is the id the ability applies")
	# THE `special` MOVED WITH THE NAME (CK §2, one site beyond the batch's own
	# list): an ability called Ironclad dispatching on `iron_will` would have
	# left the collision alive in the code layer, where a later batch grepping
	# for the talent would hit it.
	ok(battle_src.contains('"battle_trance", "ironclad", "warcry",'),
		"§1 (CK §2): the self-target list names the special `ironclad`")
	ok(Classes.pool_ability("Ironclad").special == "ironclad",
		"§1 (CK §2): ...and so does the ability def, so the two cannot drift")
	# THE TEN THAT DO NOT COLLIDE, asserted so a later rename cannot make one
	# collide silently.
	for nm in ["Field Dressing", "Camouflage", "Aimed Volley", "Bola",
			"Hunter's Mark", "Arcane Arrows", "Battle Trance", "Charge",
			"Cleave", "Warcry"]:
		ok(not node_names.has(nm),
			"§1: '%s' collides with no talent node" % nm)
	# AND NO NAME COLLIDES WITH ANOTHER ABILITY, which WOULD break: the resolver
	# is keyed on display_name, so two abilities sharing one would make
	# `pool_ability` answer the wrong question. This is why the Warrior recovery
	# card is Battle Trance and not Second Wind.
	ok(Classes.pool_ability("Second Wind") != null,
		"§1: Second Wind exists — Holy's, from tranche 1")
	ok(Classes.pool_ability("Second Wind").display_name == "Second Wind",
		"§1: ...and it resolves to itself, which a duplicate would have broken")
	ok(not Classes.class_draft_pool("warrior").has("Second Wind"),
		"§1: ...so the Warrior card is BATTLE TRANCE instead")
	# `Warcry` is not `Battle Shout`, and `bz_warcry` is a node ID whose NAME is
	# Overkill (Batch AJ re-specced it in place). Recorded so the id does not
	# read as a collision to somebody grepping.
	var found_bz_warcry := false
	for node2 in Talents.LANE_TREES.get("berserker", []):
		if String(node2.get("id", "")) == "bz_warcry":
			found_bz_warcry = true
			ok(String(node2.get("name", "")) != "Warcry",
				"§1: the `bz_warcry` node ID carries the name '%s', not 'Warcry'" % \
					node2.get("name", ""))
	ok(found_bz_warcry, "§1: ...and that node id still exists to be checked")


# ---------- §4 THE DRAFT READS THE NEW POOLS ----------

func _draft_flow() -> void:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	var warrior: Dictionary = run.party[0]
	warrior["spec"] = "warden"
	var hunter: Dictionary = run.party[3]
	hunter["spec"] = "mystic"
	var w_left: Dictionary = run.draft_pool_left(warrior)
	ok(w_left["class"].size() == 6,
		"§4: a Warden's class side of the draft holds six (%d)" % w_left["class"].size())
	var h_left: Dictionary = run.draft_pool_left(hunter)
	ok(h_left["class"].size() == 6,
		"§4: a Survivalist's class side holds six (%d)" % h_left["class"].size())
	# The no-return ledger covers a class card exactly as it covers a spec one.
	# RE-POINTED BY BATCH CK §2, AND IT HAD TO BE. With the card renamed, a
	# ledger holding "Iron Will" refuses a name the pool never carried, so the
	# `has()` below would read false for the wrong reason and the check would
	# pass without asking its question — the exact fault CD §1 exists to close.
	warrior["draft_refused"] = ["Ironclad"]
	var refused_left: Dictionary = run.draft_pool_left(warrior)
	ok(not refused_left["class"].has("Ironclad"),
		"§4: a refused class card does not come back this run")
	warrior["draft_refused"] = []
	# AND A REAL OFFER NOW HOLDS THEM. Rolled many times because the seam is a
	# per-card roll: one offer proves nothing about which side it drew from.
	var saw_class := false
	var saw_spec := false
	for _i in 200:
		var offer: Array = run.roll_draft_offer(warrior)
		ok(offer.size() == 3, "§4: a Warrior's offer fills THREE now")
		for nm in offer:
			if Classes.class_draft_pool("warrior").has(nm):
				saw_class = true
			if Classes.spec_draft_pool("warden").has(nm):
				saw_spec = true
	ok(saw_class, "§4: ...and real class cards appear in it")
	ok(saw_spec, "§4: ...beside real spec cards")
	var saw_h_class := false
	for _j in 200:
		var h_offer: Array = run.roll_draft_offer(hunter)
		ok(h_offer.size() == 3, "§4: a Hunter's offer fills THREE now")
		for nm2 in h_offer:
			if Classes.class_draft_pool("hunter").has(nm2):
				saw_h_class = true
	ok(saw_h_class, "§4: ...and a Hunter's holds real class cards too")
	# THE FILL-SHORT RULE STILL BITES, and with every class pool full the only
	# place left is a hero worn down by the no-return ledger. It was never about
	# which pool is thin — it is about an offer never padding with repeats.
	# RE-POINTED BY BATCH BV: refusing the Hunter CLASS pool used to leave a
	# Sharpshooter on his two spec cards, and BV took that pool to FIVE. The
	# refusal now has to reach the spec pool as well — which is the rule stated
	# more honestly anyway, since it was never about which pool is thin.
	#
	# RE-POINTED AGAIN BY BATCH CH, AND THE HERO MOVED RATHER THAN THE
	# ARITHMETIC. CH took the three HUNTER pools 5 -> 8, so refusing three of the
	# Survivalist's own cards leaves FIVE standing and the offer comes up FULL —
	# the assertion would have failed loudly, but the honest repair is not to
	# widen the refusal a second time, it is to build the thin pool where one
	# still exists. **THE WARRIOR IS THE ONLY CLASS LEFT AT FIVE**, so this stands
	# on a SWORDMASTER now. It is the same forced move test_batch_bo made at BW,
	# and the same honest signal: a construction that has to relocate is how a
	# paid debt announces itself. WHEN THE WARRIOR THIRD LANDS there will be no
	# five-deep pool in the game and this moves once more, onto a hero worn down
	# by `draft_refused` alone.
	var worn_hero := {"key": "warrior", "spec": "swordmaster", "bm_abilities": [],
		"draft_refused": []}
	#
	# REBUILT BY BATCH CI, AND ITS OWN PREDICTION IS WHAT CAME TRUE. The note
	# above says "when the Warrior third lands there will be no five-deep pool in
	# the game and this moves once more, onto a hero worn down by `draft_refused`
	# alone" — CI landed it, and that is exactly what this is. There is no hero
	# left to relocate to (twelve specs at eight, four classes at six, 120 of
	# 120), so the REFUSAL is written relative to the live pool size: everything
	# but two. It cannot go stale again, because a deeper pool moves the setup
	# and not the answer.
	var wn_spec: Array = Classes.spec_draft_pool("swordmaster")
	worn_hero["draft_refused"] = Classes.class_draft_pool("warrior").duplicate()
	worn_hero["draft_refused"].append_array(wn_spec.slice(0, wn_spec.size() - 2))
	var worn: Array = run.roll_draft_offer(worn_hero)
	ok(worn.size() == 2,
		"§4: a pool worn down to two fills SHORT rather than padding (%d)" % worn.size())
	hunter["draft_refused"] = []


func _seam() -> void:
	# §6 — THE CLASS SEAM NOW DRAWS REAL ENTRIES FOR EVERY HERO IN THE GAME.
	# A few hundred offers across ALL TWELVE SPECS, asserting that no class ever
	# rolls an empty pool. `draft_card_is_class(class_left, spec_left)` is the
	# function BO extracted precisely so a test could drive it.
	var run := root.get_node("/root/Run")
	var seen_class := {}
	for spec in Classes.SPEC_DRAFT_POOLS:
		var cls: String = Classes.class_of_spec(spec)
		var m := {"key": cls, "spec": spec, "bm_abilities": []}
		for _i in 30:
			var offer: Array = run.roll_draft_offer(m)
			ok(offer.size() == 3,
				"§6: %s's offer fills three (%d)" % [spec, offer.size()])
			for nm in offer:
				if Classes.class_draft_pool(cls).has(String(nm)):
					seen_class[cls] = int(seen_class.get(cls, 0)) + 1
	for cls2 in Classes.CLASS_DRAFT_POOLS:
		ok(int(seen_class.get(cls2, 0)) > 0,
			"§6: the %s class pool is really drawn from (%d cards over 90 offers)" % [
				cls2, int(seen_class.get(cls2, 0))])
	# NO CLASS ROLLS AN EMPTY POOL — the degenerate branch BO wrote for the case
	# that no longer exists, asserted UNREACHABLE from a real class rather than
	# deleted (it is still the right answer if a pool is ever exhausted by the
	# no-return ledger).
	for cls3 in Classes.CLASS_DRAFT_POOLS:
		ok(not Classes.class_draft_pool(cls3).is_empty(),
			"§6: %s never rolls an empty class pool" % cls3)
	ok(not run.draft_card_is_class(6, 0),
		"§6: an EXHAUSTED class pool still falls entirely to the spec side")
	ok(run.draft_card_is_class(0, 6),
		"§6: ...and an exhausted spec pool entirely to the class side")
	var class_cards := 0
	for _k in 4000:
		if run.draft_card_is_class(6, 6):
			class_cards += 1
	var share := class_cards / 4000.0
	ok(share > 0.20 and share < 0.30,
		"§6: the seam still fires at roughly one card in four (%.3f)" % share)


# ---------- LIVE: THE HUNTER SIX ----------

func _live_hunter_tools() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"mystic": ["Field Dressing", "Bola", "Hunter's Mark"]},
		["raider", "chief", "archer"])
	var hunter := _hero(scene, "trapper")
	ok(hunter != null, "the Survivalist spawned")
	if hunter == null:
		await _drop(scene)
		return
	var fd: Ability = scene.call("_find_ability", hunter, "Field Dressing")
	var bola: Ability = scene.call("_find_ability", hunter, "Bola")
	var mark: Ability = scene.call("_find_ability", hunter, "Hunter's Mark")
	ok(fd != null and bola != null and mark != null,
		"§2: all three drafted cards are assembled onto the unit")
	if fd == null or bola == null or mark == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	var foe2: BattleUnit = foes[1]
	hunter.resource = hunter.max_resource
	# ---- FIELD DRESSING: 18% OF MAXIMUM, AND EXACTLY ONE EFFECT REMOVED ----
	# TWO debuffs are laid on him and only one may go. "It removes a harmful
	# effect" is trivially true of a full purge, so the SECOND one is asserted
	# to be standing afterwards — that is what tells a cleanse from a dispel.
	hunter.hp = maxi(int(hunter.max_hp * 0.4), 1)
	scene.call("_apply_status", hunter, "poison", 4, 0, 3, foe)
	scene.call("_apply_status", hunter, "cripple", 3, 0, 0, foe)
	ok(hunter.has_status("poison") and hunter.has_status("cripple"),
		"§2: he is wearing TWO harmful effects going in")
	var hp_before := hunter.hp
	await scene.call("_resolve", hunter, fd, hunter, "good")
	var want_heal := maxi(int(round(hunter.max_hp * 0.18)), 1)
	ok(hunter.hp == hp_before + want_heal,
		"§2: Field Dressing heals exactly 18%% of MAXIMUM (%d -> %d, wanted +%d)" % [
			hp_before, hunter.hp, want_heal])
	var still := int(hunter.has_status("poison")) + int(hunter.has_status("cripple"))
	ok(still == 1,
		"§2: ...and removes exactly ONE of the two, never both (%d left)" % still)
	# ---- BOLA: TWO STATUSES, NO DAMAGE, NO BREAK ----
	foe.hp = foe.max_hp
	foe.pressure = 0
	hunter.resource = hunter.max_resource
	await scene.call("_resolve", hunter, bola, foe, "good")
	ok(foe.has_status("slow") and foe.has_status("cripple"),
		"§2: Bola lands Slowed AND Crippled")
	ok(foe.hp == foe.max_hp,
		"§2: ...and deals not one point of damage (%d/%d)" % [foe.hp, foe.max_hp])
	ok(foe.pressure == 0,
		"§2: ...and not one point of Break (%d)" % foe.pressure)
	# ---- HUNTER'S MARK: THE WHOLE PARTY, NOT THE MARKER ----
	# The discriminator is that a DIFFERENT hero's blow is amplified. A mark
	# that paid only its caster would pass "the mark lands" and fail here.
	hunter.resource = hunter.max_resource
	await scene.call("_resolve", hunter, mark, foe, "good")
	ok(foe.has_status("party_mark"), "§2: Hunter's Mark lands its mark")
	ok(foe.status_power("party_mark") == 15,
		"§2: ...carrying 15%% as its power (%d)" % foe.status_power("party_mark"))
	ok(is_equal_approx(scene.call("_party_mark_mult", foe), 1.15),
		"§2: ...so the multiplier reads 1.15 for ANY attacker")
	ok(is_equal_approx(scene.call("_party_mark_mult", foe2), 1.0),
		"§2: ...and 1.0 for an unmarked enemy")
	# ONE MARK AT A TIME — marking a second enemy clears the first.
	hunter.resource = hunter.max_resource
	await scene.call("_resolve", hunter, mark, foe2, "good")
	ok(foe2.has_status("party_mark") and not foe.has_status("party_mark"),
		"§2: ...and marking a second enemy CLEARS the first — one mark at a time")
	# IT IS NOT THE BEASTMASTER'S MARK. Different status, different rule: that
	# one stamps the hunter's index and pays him and his beast 25%.
	ok(not foe2.has_status("hunt_mark"),
		"§2: Hunter's Mark is NOT `hunt_mark` — the two marks are separate objects")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("raw *= _party_mark_mult(victim)"),
		"§2: ...and the beast's own damage path reads the party mark through the same function")
	await _drop(scene)


func _live_arcane_arrows() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "sharpshooter"],
		{"sharpshooter": ["Arcane Arrows", "Aimed Volley"]},
		["raider", "chief", "archer"])
	var hunter := _hero(scene, "lethal_aim")
	ok(hunter != null, "the Sharpshooter spawned")
	if hunter == null:
		await _drop(scene)
		return
	var arrows: Ability = scene.call("_find_ability", hunter, "Arcane Arrows")
	var volley: Ability = scene.call("_find_ability", hunter, "Aimed Volley")
	ok(arrows != null and volley != null,
		"§2: Arcane Arrows and Aimed Volley are assembled onto the unit")
	if arrows == null or volley == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	for f in foes:
		f.max_hp = 99999
		f.hp = 99999
	hunter.resource = hunter.max_resource
	# ---- BANKED, NOT TIMED ----
	await scene.call("_resolve", hunter, arrows, hunter, "good")
	# BATCH CQ §3 — SIX SINCE CN §3'S FOLD (the perfect's sixth became the base).
	ok(hunter.status_power("arrows") == 6,
		"§6: Arcane Arrows banks six charges (%d)" % hunter.status_power("arrows"))
	var st: Dictionary = hunter.get_status("arrows")
	ok(int(st.get("turns", 0)) == -1,
		"§6: ...BATTLE-LONG (-1 turns), which is what makes 'banked' true")
	# "They persist" is trivially true if nothing ever ticks — so tick.
	for _i in 6:
		hunter.tick_statuses()
	ok(hunter.status_power("arrows") == 6,
		"§6: ...and six turns of ticking spends NONE of them (%d)" % \
			hunter.status_power("arrows"))
	# ---- §1: A THREE-SHOT ABILITY SPENDS THREE ----
	# The exact identity, not "fewer than five": three, and the other enemies
	# must have taken the forks.
	var others_hp_before: int = foes[1].hp + foes[2].hp
	hunter.resource = hunter.max_resource
	await scene.call("_resolve", hunter, volley, foe, "good")
	ok(hunter.status_power("arrows") == 3,
		"§6: a THREE-shot volley spends THREE charges, 6 -> 3 (got %d)" % \
			hunter.status_power("arrows"))
	ok(foes[1].hp + foes[2].hp < others_hp_before,
		"§6: ...and the splash reached the OTHER enemies, which is the on-hit half")
	# AND A SINGLE-STRIKE ABILITY SPENDS EXACTLY ONE. Without this the check
	# above cannot tell "three per volley" from "three per cast".
	var single: Ability = scene.call("_find_ability", hunter, "Quick Shot")
	ok(single != null and single.multi_hits == 0,
		"§6: Quick Shot is a single-strike ability")
	if single != null:
		hunter.resource = hunter.max_resource
		await scene.call("_resolve", hunter, single, foe, "good")
		ok(hunter.status_power("arrows") == 2,
			"§6: ...while a SINGLE strike spends exactly one, 3 -> 2 (got %d)" % \
				hunter.status_power("arrows"))
	# THE LAST CHARGE CLEARS THE CHIP. `status_power` returns -1 for an absent
	# status rather than 0, so absence is asserted with `has_status`.
	# BATCH CQ §3 — SPEND WHAT IS LEFT RATHER THAN A FIXED ONE. The fold banked
	# a sixth charge, so a single hard-coded shot no longer reaches the bottom;
	# the question ("the LAST charge clears the chip") is asked of whatever the
	# count happens to be.
	for _spend in maxi(hunter.status_power("arrows"), 0):
		hunter.resource = hunter.max_resource
		await scene.call("_resolve", hunter, single, foe, "good")
	ok(not hunter.has_status("arrows"),
		"§6: the last charge spends and the chip goes")
	# A HIT THAT NEVER LANDED SPENDS NOTHING — asserted through the ONE spend
	# site, which is where the rule is decidable.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("await _arcane_arrow_splash(attacker, strike_target, final)"),
		"§1: the splash is called from INSIDE the hit loop, with THIS hit's damage")
	ok(battle_src.contains("func _arcane_arrow_splash(attacker: BattleUnit, struck: BattleUnit,"),
		"§1: ...and one function spends the charge and deals the blow")
	await _drop(scene)


func _live_camouflage() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"mystic": ["Camouflage"]},
		["raider", "chief", "archer"],
		{"mystic": {"sv_ghillie": 1}})
	var hunter := _hero(scene, "trapper")
	ok(hunter != null, "the Survivalist spawned for the Camouflage check")
	if hunter == null:
		await _drop(scene)
		return
	var camo: Ability = scene.call("_find_ability", hunter, "Camouflage")
	ok(camo != null, "§2: Camouflage is assembled onto the unit")
	if camo == null:
		await _drop(scene)
		return
	ok(hunter.ghillie == 65, "§2: ...on a Survivalist who ALSO holds Ghillie Suit (%d)" % hunter.ghillie)
	# GHILLIE ALONE.
	var ghillie_only: float = scene.call("_evade_chance", hunter)
	ok(is_equal_approx(ghillie_only, 0.65),
		"§6: Ghillie Suit alone reads 65%% (%.3f)" % ghillie_only)
	# CAMOUFLAGE ALONE, on a hero with no node.
	var other := _hero(scene, "bloodrage")
	scene.call("_apply_status", other, "camouflage", 2, 70)
	var camo_only: float = scene.call("_evade_chance", other)
	ok(is_equal_approx(camo_only, 0.70),
		"§6: Camouflage alone reads 70%% (%.3f)" % camo_only)
	# BOTH — AND THE ARITHMETIC IS WHAT ANSWERS §2's QUESTION. They STACK as
	# INDEPENDENT chances: higher than either alone (so neither overwrites) and
	# lower than their sum (so neither is added blindly past 100%).
	hunter.resource = hunter.max_resource
	await scene.call("_resolve", hunter, camo, hunter, "good")
	ok(hunter.has_status("camouflage"), "§6: Camouflage lands its status")
	ok(hunter.status_power("camouflage") == 70,
		"§6: ...carrying 70 as its power (%d)" % hunter.status_power("camouflage"))
	var both: float = scene.call("_evade_chance", hunter)
	ok(is_equal_approx(both, 0.895),
		"§6: the two STACK as independent chances — 1-(0.35x0.30) = 0.895 (%.4f)" % both)
	ok(both > ghillie_only and both > camo_only,
		"§6: ...so neither silently overwrites the other")
	ok(both < ghillie_only + camo_only,
		"§6: ...and they are not summed past 100% either")
	# ONE COMBINED ROLL, not one each — the site is asserted directly, because
	# two sequential re-picks would let the second undo the first's choice.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("var ev_chance := _evade_chance(target)"),
		"§6: the target re-pick reads ONE combined chance")
	ok(not battle_src.contains("randf() < 0.01 * target.ghillie"),
		"§6: ...and the old Ghillie-only roll is GONE, not left beside it")
	# THE FINDING, PINNED: for a Survivalist already holding the node this is
	# close to a dead draw — 65% for free and permanent against 89.5% for 20
	# Mana, a turn and two turns of clock.
	ok(both - ghillie_only < 0.25,
		"§2 FINDING (reported, not re-tuned): the card adds %.1f points to a Ghillie build" % \
			((both - ghillie_only) * 100.0))
	await _drop(scene)


# ---------- LIVE: THE WARRIOR SIX ----------

func _live_warrior_tools() -> void:
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		{"swordmaster": ["Charge", "Cleave", "Warcry"]},
		["raider", "chief", "archer"])
	var war := _hero(scene, "seasoned")
	ok(war != null, "the Swordmaster spawned")
	if war == null:
		await _drop(scene)
		return
	var charge: Ability = scene.call("_find_ability", war, "Charge")
	var cleave: Ability = scene.call("_find_ability", war, "Cleave")
	var warcry: Ability = scene.call("_find_ability", war, "Warcry")
	ok(charge != null and cleave != null and warcry != null,
		"§3: all three drafted cards are assembled onto the unit")
	if charge == null or cleave == null or warcry == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 99999
		f.hp = 99999
		f.pressure = 0
	war.resource = war.max_resource
	# ---- CHARGE: A DAZE AND THE FASTEST ARRIVAL IN THE KIT ----
	await scene.call("_resolve", war, charge, foes[0], "good")
	ok(foes[0].has_status("dazed"), "§3: Charge Dazes its target")
	ok(foes[0].hp < 99999, "§3: ...and lands its damage")
	ok(foes[0].pressure > 0, "§3: ...and its Break")
	var basic: Ability = war.abilities[0]
	ok(charge.delay < basic.delay,
		"§3: ...arriving faster than his own basic (%.1f against %.1f)" % [
			charge.delay, basic.delay])
	# ---- CLEAVE: THREE CHOSEN ENEMIES, EACH TAKING DAMAGE AND BREAK ----
	for f2 in foes:
		f2.hp = 99999
		f2.pressure = 0
	war.resource = war.max_resource
	scene.set("second_target", foes[1])
	scene.set("third_target", foes[2])
	await scene.call("_resolve", war, cleave, foes[0], "good")
	var struck := 0
	var broken_meters := 0
	for f3 in foes:
		if f3.hp < 99999:
			struck += 1
		if f3.pressure > 0:
			broken_meters += 1
	ok(struck == 3, "§3: Cleave strikes THREE enemies (%d)" % struck)
	ok(broken_meters == 3, "§3: ...and lands Break on each of them (%d)" % broken_meters)
	# ---- WARCRY: THE WHOLE PARTY, INCLUDING HEROES WHO DID NOT CAST IT ----
	# The discriminator is a NON-CASTER's damage, because a buff that only
	# reached its caster would pass "the status lands" and fail here.
	war.resource = war.max_resource
	await scene.call("_resolve", war, warcry, war, "good")
	var lit := 0
	for h in scene.get("heroes"):
		if not h.dead and h.has_status("warcry"):
			lit += 1
	ok(lit == 4, "§3: Warcry reaches every living hero (%d)" % lit)
	var mage := _hero(scene, "permafrost")
	ok(mage != null and mage.has_status("warcry"),
		"§3: ...including one who did not cast it")
	if mage != null:
		ok(mage.status_power("warcry") == 20,
			"§3: ...carrying 20%% as its power (%d)" % mage.status_power("warcry"))
	# IT RIDES BATTLE SHOUT'S OWN READ SITE, so the two compose rather than one
	# winning — asserted at the site, because that is where it is decidable.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains('if attacker.has_status("warcry"):\n\t\t\t\traw *= 1.0 + attacker.status_power("warcry") / 100.0'),
		"§3: Warcry is read one line below Battle Shout, off the status's power")
	await _drop(scene)


func _live_battle_trance() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"berserker": ["Battle Trance"]},
		["raider", "chief", "archer"])
	var bz := _hero(scene, "bloodrage")
	ok(bz != null, "the Berserker spawned")
	if bz == null:
		await _drop(scene)
		return
	var bt: Ability = scene.call("_find_ability", bz, "Battle Trance")
	ok(bt != null, "§3: Battle Trance is assembled onto the unit")
	if bt == null:
		await _drop(scene)
		return
	bz.armor = 0.0
	bz.resists = {}
	bz.max_hp = 200
	bz.resource = bz.max_resource
	# THE TWO READINGS ARE SET UP TO DIFFER BY CONSTRUCTION. He casts at 60 of
	# 200 — 140 MISSING — and then takes exactly 20. The correct answer is
	# 3% of 200 plus half of 20 = 6 + 10 = 16. The "share of missing health"
	# reading would be 6 + 70 = 76, and a plain low-health heal would be
	# something else again. Only one number can be right.
	bz.hp = 60
	await scene.call("_resolve", bz, bt, bz, "good")
	ok(bz.has_status("battle_trance"), "§6: Battle Trance lands its status")
	ok(bz.trance_taken == 0,
		"§6: ...and ZEROES the accumulator at the cast, so the first tick pays for what follows")
	bz.take_hit(20, 0)
	ok(bz.trance_taken == 20,
		"§6: damage taken accumulates on the ONE door (%d)" % bz.trance_taken)
	var hp_before := bz.hp
	scene.call("_battle_trance_tick", bz)
	var want := maxi(int(round(bz.max_hp * 0.03)), 1) + 10
	ok(bz.hp == hp_before + want,
		"§6: the tick heals 3%% of MAXIMUM plus HALF the damage taken — %d, not a share of the %d missing (%d -> %d)" % [
			want, bz.max_hp - hp_before, hp_before, bz.hp])
	ok(bz.trance_taken == 0,
		"§6: ...and the accumulator CLEARS at the tick (%d)" % bz.trance_taken)
	# THE FLOOR PAYS WHEN HE TOOK NOTHING. Without this the card is dead in the
	# fight where nobody hits him.
	var hp_mid := bz.hp
	scene.call("_battle_trance_tick", bz)
	ok(bz.hp == hp_mid + maxi(int(round(bz.max_hp * 0.03)), 1),
		"§6: a tick with NO damage taken still pays the 3%% floor (%d -> %d)" % [
			hp_mid, bz.hp])
	# AND IT PAYS NOTHING AT ALL WITHOUT THE STATUS — the tick is not a passive.
	bz.remove_status("battle_trance")
	var hp_off := bz.hp
	bz.take_hit(20, 0)
	scene.call("_battle_trance_tick", bz)
	ok(bz.hp < hp_off,
		"§6: with the trance gone the tick pays nothing — the wound just stands")
	# THE RECOVERY IS DELAYED, WHICH IS WHAT KEEPS IT HONEST: it cannot save him
	# from a killing blow, because it arrives at his NEXT turn rather than at
	# the moment of the hit.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("func _battle_trance_tick(u: BattleUnit) -> void:"),
		"§6: the tick is its own function, so its negative control can fail")
	ok(battle_src.contains("_battle_trance_tick(u)"),
		"§6: ...called from the turn-start block, never from a damage site")
	var unit_src := _src("res://scripts/unit.gd")
	ok(unit_src.contains("trance_taken += lost"),
		"§6: and the accumulator rides `_report_taken` — the one door, below every death refusal")
	await _drop(scene)


func _live_rally() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"berserker": ["Rally"]},
		["raider", "chief", "archer"])
	var bz := _hero(scene, "bloodrage")
	ok(bz != null, "the Berserker spawned for the Rally check")
	if bz == null:
		await _drop(scene)
		return
	var rally: Ability = scene.call("_find_ability", bz, "Rally")
	ok(rally != null, "§3: Rally is assembled onto the unit")
	if rally == null:
		await _drop(scene)
		return
	var heroes: Array = scene.get("heroes")
	var ally: BattleUnit = null
	for h in heroes:
		if h != bz and not h.is_companion and not h.dead:
			ally = h
	ok(ally != null, "§6: there is an ally to hand the turn to")
	if ally == null:
		await _drop(scene)
		return
	# PUT HIM LAST ON THE CLOCK BY A LARGE MARGIN, so "he acts next" is a real
	# claim rather than something the ordering gave for free.
	for u in heroes + scene.get("enemies"):
		u.next_time = 50.0
	ally.next_time = 400.0
	bz.resource = bz.max_resource
	await scene.call("_resolve", bz, rally, ally, "good")
	ok(ally.next_time < 50.0,
		"§6: Rally pulls the ally AHEAD of the whole field (%.2f)" % ally.next_time)
	# THE DISCRIMINATOR: he is the unit the timeline actually returns next. Any
	# write to `next_time` would pass "it got smaller"; only the right one makes
	# him the next actor.
	ok(scene.call("_next_unit") == ally,
		"§6: ...and he is the unit `_next_unit` returns — he really does act NEXT")
	# NO UNBOUNDED CONSECUTIVE TURNS. Three separate guards, each asserted:
	# the caster is excluded from the pool at all three sites, and handing away
	# a turn costs him his own.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains('if ab.special == "rally_ally":\n\t\t\t\t\tpool = pool.filter(func(a): return a != u and not a.is_companion)'),
		"§6: the player's picker excludes the caster")
	ok(battle_src.contains('if ab.special == "rally_ally":\n\t\tif not heroes.any(func(a): return a != u and not a.dead):\n\t\t\treturn false'),
		"§6: `_ability_usable` refuses the cast when he is the last one standing")
	ok(battle_src.contains('\t\t\tif ab.special == "rally_ally":\n\t\t\t\tvar rl_pool := allies.filter(func(h): return h != u)'),
		"§6: the bot's pool excludes him too — three sites, one rule")
	ok(battle_src.contains("func _rally_forward(caster: BattleUnit, ally: BattleUnit) -> void:"),
		"§6: and ONE function moves the turn — no second turn-order manipulator")
	# A SELF-RALLY IS REFUSED AT THE RESOLVE SITE AS WELL, which is the belt to
	# the picker's braces: the special's own guard reads `target != attacker`.
	for u2 in heroes + scene.get("enemies"):
		u2.next_time = 50.0
	bz.resource = bz.max_resource
	await scene.call("_resolve", bz, rally, bz, "good")
	ok(bz.next_time >= 50.0,
		"§6: a Rally aimed at himself does NOT pull him to the front (%.2f)" % bz.next_time)
	# IT USES THE EXISTING INITIATIVE MACHINERY — the same `next_time` write
	# Shattered Tempo and `Ability.delay_push` already make.
	ok(battle_src.contains("strike_target.next_time += ab.delay_push * 100.0 / strike_target.effective_speed()"),
		"§6: ...the hook Ability.delay_push already writes, aimed the other way")
	await _drop(scene)


func _live_iron_will() -> void:
	var scene := await _spawn(["warden", "cryomancer", "holy", "mystic"],
		{"warden": ["Ironclad"]},
		["raider", "chief", "archer"])
	var wd := _hero(scene, "heavy_plating")
	ok(wd != null, "the Warden spawned")
	if wd == null:
		await _drop(scene)
		return
	var iw: Ability = scene.call("_find_ability", wd, "Ironclad")
	ok(iw != null, "§3: Ironclad is assembled onto the unit")
	if iw == null:
		await _drop(scene)
		return
	# CONSTITUTION TO 100 so the Break arithmetic is 1:1 and the 99 is exact
	# rather than approximately exact. `pressure_add * 100 / con` is the
	# conversion, and it is not what this check is about.
	wd.constitution = 100
	wd.pressure = 0
	wd.broken = false
	wd.armor = 0.0
	wd.resists = {}
	wd.max_hp = 400
	wd.hp = 400
	wd.resource = wd.max_resource
	await scene.call("_resolve", wd, iw, wd, "good")
	ok(wd.has_status("ironclad"), "§6: Ironclad lands `ironclad`")
	# ---- IT REFUSES THE THREE STATUSES THAT COST HIM A TURN ----
	for id in ["stunned", "frozen", "dazed"]:
		scene.call("_apply_status", wd, id, 3)
		ok(not wd.has_status(id), "§6: ...and refuses %s outright" % id)
	# AND ONLY THOSE THREE — it is not a blanket debuff immunity, which would be
	# a much bigger card than the one the tooltip describes.
	scene.call("_apply_status", wd, "cripple", 3)
	ok(wd.has_status("cripple"),
		"§6: ...while an ordinary debuff still lands — it is not blanket immunity")
	# ---- THE BREAK METER FILLS TO EXACTLY 99 AND STOPS ----
	# ASSERT THE 99, NOT MERELY THE ABSENCE OF BROKEN. "The meter cannot fill"
	# would leave it near zero and "Broken is refused" would leave it at 100;
	# both would pass a weaker check and both are wrong.
	for _i in 12:
		wd.take_hit(0, 25)
	ok(wd.pressure == 99,
		"§6: 300 points of Break fill the meter to EXACTLY 99 (%d)" % wd.pressure)
	ok(not wd.broken, "§6: ...and he is not Broken")
	ok(not wd.has_status("broken"), "§6: ...and wears no Broken chip")
	# ---- AND THE MOMENT IT LAPSES HE IS ONE HIT FROM BROKEN ----
	# That is the whole design: the enemy's Break work is DEFERRED, not erased.
	wd.remove_status("ironclad")
	wd.take_hit(0, 1)
	ok(wd.broken,
		"§6: the first hit after it expires BREAKS him — the work was deferred, not erased")
	ok(wd.pressure == 100, "§6: ...at a full meter (%d)" % wd.pressure)
	# ---- AND THE DAMAGE HALF ----
	wd.broken = false
	wd.pressure = 0
	wd.remove_status("broken")
	wd.hp = wd.max_hp
	scene.call("_apply_status", wd, "ironclad", 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	foe.no_cover = 1
	foe.attack = 100
	# HIS BLOCK IS A FULL NEGATION, so it has to come off or a blocked swing
	# reads as flawless mitigation and the comparison measures nothing. Heavy
	# Plating's slice is `0.15 + plating_bonus`, so -0.15 cancels it exactly
	# (test_batch_bp's own construction).
	wd.block_chance = 0.0
	wd.plating_bonus = -0.15
	wd.parry_chance = 0.0
	# AND THE CRIT ROLL COMES OFF TOO — the same fault this batch closed in
	# test_batch_bq's Unburden and Exhortation checks, found here by the Charge
	# reprice re-running the suite. This compares ONE blow against ONE blow, and
	# a 15% cut cannot survive the WARDED swing landing a x1.5 crit. Forced, not
	# retried (the AK/AL/AR discipline).
	foe.crit_bonus = -1.0
	var strike: Ability = foe.abilities[0]
	# BATCH CQ §1 — SAMPLED RATHER THAN SINGLE-SHOT, AND THE LAST FORCED
	# VARIABLE IS THE ONE THAT HAS NO FIELD. This compared ONE blow against ONE
	# blow with the block, the parry, the plating ramp and the crit all driven
	# off by hand — and then rolled `randf_range(0.9, 1.1)` twice anyway,
	# because the damage variance is a literal inside `_resolve` with no handle
	# to zero. **A 15% cut cannot clear a 22% spread on one swing**: a warded
	# high roll is 1.1 x 0.85 = 0.935 of base against an unwarded low roll of
	# 0.90, so the comparison INVERTS outright a few runs in a hundred. It read
	# `29 taken against 28` on the first battery that ever got this far.
	#
	# It has effectively never been exercised: `br` is one of the four suites
	# that deadlocked from CM until §1 of this batch, so this line has not run
	# in a battery since. Averaging the variance out is the same answer
	# `check_cm_live` already uses for the brace ratio, and it keeps the AK/AL/AR
	# rule the block above states — FORCED, NOT RETRIED. The plating cancel is
	# re-applied before every swing for the reason the old comment gives.
	const IRONCLAD_SAMPLES := 20
	var with_iw := 0
	var without_iw := 0
	for _i in IRONCLAD_SAMPLES:
		wd.hp = wd.max_hp
		wd.plating_bonus = -0.15
		var hp_a := wd.hp
		await scene.call("_resolve", foe, strike, wd, "good")
		with_iw += hp_a - wd.hp
	wd.remove_status("ironclad")
	for _i in IRONCLAD_SAMPLES:
		wd.hp = wd.max_hp
		wd.plating_bonus = -0.15
		var hp_b := wd.hp
		await scene.call("_resolve", foe, strike, wd, "good")
		without_iw += hp_b - wd.hp
	ok(with_iw < without_iw,
		"§3: Ironclad really cuts the damage (%d taken against %d over %d swings each)"
			% [with_iw, without_iw, IRONCLAD_SAMPLES])
	var battle_src := _src("res://scripts/battle.gd")
	# RE-POINTED BY BATCH CK §2: was IRON_WILL_CUT_PCT.
	ok(battle_src.contains("const IRONCLAD_CUT_PCT := 15"),
		"§3: ...by 15%, off one constant")
	# THE CAP IS WRITTEN WHERE IT IS DECIDABLE — below the meter write and above
	# the threshold. Anywhere else and it is one of the two wrong readings.
	var unit_src := _src("res://scripts/unit.gd")
	ok(unit_src.contains('if has_status("ironclad") and pressure >= stability:'),
		"§6: the clamp reads the meter AFTER it has been written")
	ok(unit_src.contains("pressure = stability - 1"),
		"§6: ...and parks it one under the threshold rather than zeroing it")
	# BROKEN IS NOT IN THE STATUS REFUSAL LIST, and that is deliberate: adding
	# it there would look like the same rule and would quietly replace the
	# delay with a negation.
	ok(battle_src.contains('if target.has_status("ironclad") and id in ["stunned", "frozen", "dazed"]:'),
		"§6: the refusal names exactly three ids — Broken is a METER state, not a status")
	await _drop(scene)


func _live_hits_not_casts() -> void:
	# §1's rule applied RETROACTIVELY to Batch BQ's Mirror Image: a multi-hit
	# attack spends one image PER HIT. Unreachable in ordinary play today — no
	# enemy carries a multi-hit ability — so it is driven with one built here,
	# which is the only way to check a rule made true ahead of its use.
	var scene := await _spawn(["berserker", "pyromancer", "holy", "mystic"],
		{"pyromancer": ["Mirror Image"]},
		["raider", "chief", "archer"])
	var mage := _hero(scene, "overburn")
	ok(mage != null, "the Pyromancer spawned for the hits-not-casts check")
	if mage == null:
		await _drop(scene)
		return
	var mirror: Ability = scene.call("_find_ability", mage, "Mirror Image")
	ok(mirror != null, "§1: Mirror Image is assembled onto the unit")
	if mirror == null:
		await _drop(scene)
		return
	# The Mage must be able to MISS for the branch to be reachable at all, so
	# `no_cover` is cleared on him — the harness arms it on the heroes.
	mage.no_cover = 0
	mage.hp = mage.max_hp
	mage.armor = 0.0
	mage.resource = mage.max_resource
	var foe: BattleUnit = (scene.get("enemies") as Array)[0]
	await scene.call("_resolve", mage, mirror, mage, "good")
	# BATCH CQ §3 — FOUR IMAGES SINCE CN §3'S FOLD.
	ok(mage.status_power("mirror") == 4,
		"§1: four images standing (%d)" % mage.status_power("mirror"))
	var triple: Ability = Ability.make({"display_name": "Test Flurry", "cost": 0,
		"damage": 20, "pressure": 0, "delay": 2.0, "multi_hits": 3,
		"perfect_extra_hit": false})
	var hp_before := mage.hp
	await scene.call("_resolve", foe, triple, mage, "good")
	# BATCH CQ §3 — THREE OF FOUR, so one image is left standing and the chip
	# stays up. The question is "one image per STRIKE, not per cast", and the
	# count it leaves behind is what answers it.
	ok(mage.status_power("mirror") == 1,
		"§1: a THREE-strike blow spends THREE images, not one (%d left)" % \
			mage.status_power("mirror"))
	ok(mage.hp == hp_before,
		"§1: ...and not one of the three landed a point of damage")
	# AND AN AREA ATTACK STILL SPENDS NONE — BQ's rule, unchanged. The gate is
	# `multi_hits` alone, because a multi-hit blow is repeated strikes on ONE
	# target, i.e. single-target, and an area attack is not.
	mage.resource = mage.max_resource
	await scene.call("_resolve", mage, mirror, mage, "good")
	ok(mage.status_power("mirror") == 4, "§1: four images again")
	var aoe: Ability = Ability.make({"display_name": "Test Sweep", "cost": 0,
		"damage": 20, "pressure": 0, "delay": 2.0, "aoe": true})
	var hp_aoe := mage.hp
	await scene.call("_resolve", foe, aoe, mage, "good")
	ok(mage.status_power("mirror") == 4,
		"§1: an AREA attack spends NONE (%d left)" % mage.status_power("mirror"))
	ok(mage.hp < hp_aoe, "§1: ...because it landed instead")
	# THE REACHABILITY CLAIM, ASSERTED RATHER THAN STATED: no enemy in the
	# roster carries a multi-hit or random-hit ability, so this rule changes
	# nothing in play today and is the rule made TRUE ahead of its use.
	var enemies_json := _src("res://data/enemies.json")
	ok(not enemies_json.contains("multi_hits"),
		"§1: no enemy kit carries `multi_hits` — the branch is unreachable in play")
	ok(not enemies_json.contains("random_hits"),
		"§1: ...nor `random_hits`")
	# THE OTHER CHARGE BANKS ALREADY COUNTED HITS — verified at their sites
	# rather than assumed, and reported as needing no change.
	var battle_src := _src("res://scripts/battle.gd")
	var loop_start := battle_src.find("for hit_i in total_hits:")
	var loop_end := battle_src.find('if ab.display_name == "Ice Lance" and attacker.is_hero')
	ok(loop_start > 0 and loop_end > loop_start, "§1: the hit loop is locatable")
	var loop := battle_src.substr(loop_start, loop_end - loop_start)
	ok(loop.contains('var charges := strike_target.get_status("shield_charges")'),
		"§1: Interpose's charges are spent INSIDE the hit loop — already per hit")
	ok(battle_src.contains("if defender.banked_guards > 0:")
		and loop.contains("_roll_parry(strike_target)"),
		"§1: Waiting Guard's and Feint's charges ride the parry roll, which is per hit")
	# THE ONE PLACE THE RULE WAS DELIBERATELY NOT APPLIED, PINNED AS A FINDING:
	# Spray of Arrows is gated OFF for multi-hit abilities by Batch AZ's own
	# design (it is extra ENEMIES a single shot finds), and firing it per hit
	# would triple a shipped talent's magnitude — a balance change this batch's
	# testing scope forbids measuring.
	ok(battle_src.contains("if attacker.spray > 0 and ab.multi_hits == 0 and ab.random_hits == 0:"),
		"§1 FINDING (reported, not changed): Spray of Arrows stays gated OFF for multi-hit abilities")
	await _drop(scene)


# ---------- §5 THE DOCUMENTATION ----------

func _docs() -> void:
	var master := _src("res://docs/master.html")
	# RE-POINTED BY BATCH CK §2, AND IT WAS ALREADY RED WHEN CK ARRIVED — NOT BY
	# CK'S HAND. The check read `master.contains("Batch CI")` under a message
	# saying "Batch CH", which is a stamp assertion that has to be hand-bumped
	# every batch: CH bumped the string and not the message, CI bumped neither,
	# and CJ re-stamped the document to CJ and left this looking for CI. **A
	# CHECK THAT MUST BE EDITED EVERY BATCH TO KEEP PASSING IS A CHECK THAT WILL
	# BE RED MOST BATCHES**, which is the same class of fault as one that can
	# only pass — it stops carrying information either way.
	#
	# IT ASKS THE DURABLE VERSION OF ITS OWN QUESTION NOW: the document carries a
	# stamp, and that stamp is not older than the batch this suite belongs to. No
	# bump is ever owed again. (Two-letter batch codes sort lexically, which is
	# what the comparison leans on; a three-letter code will need one more line.)
	var stamp_at := master.find("Last updated:")
	ok(stamp_at >= 0, "§5: master.html carries a Last-updated stamp")
	var stamp := master.substr(stamp_at, 60)
	var code_at := stamp.find("(Batch ")
	var stamped := stamp.substr(code_at + 7, 2) if code_at >= 0 else ""
	ok(stamped >= "BR",
		"§5: ...and it is stamped no older than this suite's own batch (reads '%s')" % stamped)
	for cls in TRANCHE_4:
		for nm in TRANCHE_4[cls]:
			ok(master.contains(nm), "§5: master.html lists %s" % nm)
	ok(not master.to_lower().contains("half-filled")
		and not master.to_lower().contains("half filled"),
		"§5: master.html no longer records the class seam as HALF filled")
	# RE-POINTED BY BATCH CD. BR asserted master.html carried the string "48",
	# which four tranches later is a check that CAN ONLY PASS — "48" turns up in
	# any document with enough numbers in it — and BQ's rule is that a check
	# which can only pass is a gap. It asks BR's real question instead: does
	# master.html state the draft's LIVE pool count against the REAL target?
	ok(master.contains("149 of 149"),
		"§5: ...and master.html states the live pool count against the real target")
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch BR — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch BR")` would have gone on PASSING against the live file,
	# because later entries name the batch in their own prose — A CHECK THAT PASSES
	# WITHOUT ITS SUBJECT BEING IN THE FILE AT ALL. That is BZ's failure in
	# test_batch_bb and CD's in test_batch_bo, repaired here before it could bite.
	#
	# CD's pattern: anchor on the `<h2>` HEADING, and read the archive's path out of
	# the LIVE changelog's own header rather than hardcoding it, so the NEXT cut
	# moves this with it. See test_batch_bn for the full reasoning and the one
	# consequence — this suite now depends on a file that is NOT IN VERSION CONTROL
	# and FAILS LOUDLY without it, which is correct.
	var live_log := _src("res://docs/changelog.html")
	var arch_mark := live_log.find("/changelog-archive.html</code>")
	ok(arch_mark > 0, "§5: the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var changelog := _src(arch_path)
	ok(changelog.length() > 100000,
		"§5: the archive opens at %s (%d chars)" % [arch_path, changelog.length()])
	ok(not live_log.contains("<h2>2026-08-14 &mdash; Batch BR"),
		"§5: CX moved this batch's entry OUT of the live changelog")
	ok(changelog.contains("<h2>2026-08-14 &mdash; Batch BR"),
		"§5: ...and the archive carries the Batch BR entry")
	# SLICE ON THE HEADING, NOT ON THE PHRASE — the BE lesson, and it is a real
	# one: a later entry saying "every suite at its Batch BR count" in its own
	# regression line would otherwise steal the slice and every assertion below
	# would silently stop asking its question.
	var head_idx := changelog.find("&mdash; Batch BR:")
	ok(head_idx >= 0, "§5: ...under its own <h2> heading")
	if head_idx >= 0:
		var next_idx := changelog.find("<h2>", head_idx + 4)
		var entry := changelog.substr(head_idx,
			(next_idx - head_idx) if next_idx > head_idx else -1)
		# RE-POINTED BY BATCH CK §2 AND IT READS A DIFFERENT LITERAL FROM THE
		# master.html LOOP ABOVE, WHICH IS THE POINT. master.html is CURRENT
		# TRUTH and must name Ironclad; the changelog is HISTORY and BR shipped
		# the card as Iron Will. Pointing both loops at the live pool would have
		# demanded the BR entry be rewritten to say something BR did not do —
		# and CLAUDE.md's rule is the opposite: renames live in the changelog's
		# own later entry, never by editing an older one.
		for nm2 in AS_BR_SHIPPED:
			ok(entry.contains(nm2), "§5: the BR entry names %s" % nm2)
		ok(entry.contains("Ghillie"), "§5: ...and carries the Camouflage finding")
		ok(entry.contains("Battle Shout"), "§5: ...and the Warcry finding")
	var glossary := _src("res://data/glossary.json")
	ok(glossary.contains("hits_not_casts"),
		"§5: glossary.json carries §1's hits-not-casts rule")
	ok(glossary.contains("ALL FOUR CLASS POOLS ARE WRITTEN"),
		"§5: ...and the class-draft entry no longer says two are owed")
	var claude := _src("res://CLAUDE.md")
	# RE-POINTED AT BATCH DF. THE OLD CHECK CANNOT PASS AND MUST NOT: CW §1 split
	# this file into standing rules only and dropped every batch narrative with
	# the rest, so "CLAUDE.md carries the batch block" now asserts the opposite
	# of the architecture. WHAT REPLACED IT IS A RULE, and that is what is
	# asserted here — the one line CW wrote to stop the blocks coming back. The
	# batch's own narrative is asserted against the changelog above, on CD's `<h2>` pattern.
	# (INVERTING to `not contains("BATCH BR")` was refused: a batch code is
	# legitimately named in passing inside surviving rules — CLAUDE.md names
	# BATCH BN twice and BATCH CE once that way — so the inverse would fail on
	# an ordinary citation. Anchor on the rule, not on the absence.)
	ok(claude.contains("DO NOT ADD A BATCH BLOCK TO THIS FILE"),
		"§5: CLAUDE.md states the rule that replaced the batch block (CW §1)")
	# RE-POINTED AT BATCH DF, AND THE SECOND OF THE PAIR WAS PASSING BY ACCIDENT.
	# CW §1 ruled that CLAUDE.md holds RULES and not content, so an enumeration of
	# twelve card names does not belong in it — master.html is current truth and
	# the loop above already asserts all twelve there, `classes.gd` authors them.
	# Of the twelve, exactly FOUR survived in CLAUDE.md as incidental mentions
	# inside other rules (Rally, Ironclad, Bola, Arcane Arrows), which is why
	# `contains("Battle Trance")` failed while `contains("Arcane Arrows")` went on
	# passing WITHOUT ITS SUBJECT BEING ENUMERATED AT ALL — the same fault BE
	# found in test_batch_bb and CD in test_batch_bo, arriving through a document.
	# WHAT CLAUDE.md SHOULD CARRY IS THE RULE THE TWELVE PAID FOR, and it does.
	ok(claude.contains("THE ONE-IN-FOUR CLASS SEAM DRAWS A REAL ENTRY FOR"),
		"§5: ...and CLAUDE.md carries the class-seam rule the twelve paid for")
	ok(claude.contains("is 24 of a target 24"),
		"§5: ...recording both halves of them as paid")


# ---------- harness ----------

func _spawn(specs: Array, granted: Dictionary, lineup: Array,
		learned := {}) -> Node:
	# `no_cover` is armed on the HEROES only (`enemies_keep_cover`) —
	# test_batch_bq's own asymmetry, and for its reason: it is an absolute miss
	# BYPASS, and one check here needs the Mage to be missable, so it clears it
	# on that unit.
	return await Fixture.spawn(self, specs,
		{"difficulty": "wanderer", "enemies": lineup, "talents_by_spec": learned,
		"bm_by_spec": granted, "deterministic": true, "enemies_keep_cover": true})


func _hero(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _drop(scene: Node) -> void:
	scene.queue_free()
	await process_frame
