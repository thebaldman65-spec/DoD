# test_batch_bp.gd — THE WARRIOR DRAFT POOLS. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bp.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §7 of the brief names FIVE clauses that could silently do
# nothing, and every one of them is driven live and asserted against the state
# it is supposed to have changed — never against the fact that a cast returned:
#   · Blood Offering taking CURRENT-health percent and never reaching 0;
#   · Gut Rip firing the REAL bleedout path (asserted through a bleedout-READING
#     talent, not through "damage happened");
#   · Precision Strike branching on stance, SWITCHING it afterward, and the
#     Defensive branch bypassing armor against a high-armor target;
#   · Feint's charges PERSISTING until spent rather than expiring, and the
#     redirect landing on an ALLY OF THE TARGET rather than on nothing;
#   · Covering Guard rolling the Warden's LIVE Block chance against attacks
#     aimed at the warded ally, a success negating the attack entirely.
#
# THREE OF THEM WOULD PASS ON BROKEN CODE IF WRITTEN THE OBVIOUS WAY, so each
# is built so a broken implementation still FAILS:
#   · "Blood Offering never kills him" is trivially true of an ability that
#     does nothing — so the RAGE and the exact 20%-of-current cost are asserted
#     beside it, and it is driven from 1 HP where a max-health percentage would
#     have killed him outright;
#   · "Covering Guard reads live Block" is trivially true of a cast-time
#     snapshot if the number never moves — so the ward is laid while the
#     Warden's Block is ZERO and his Shieldwall is raised AFTERWARD (the Null
#     Field construction);
#   · "Feint's charges persist" is trivially true if nothing ever attacks him —
#     so a charge is asserted SPENT by a real blow, with the reflect landing on
#     the attacker and nothing landing on him.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const CAP := 7
const REAL_SAVE := "user://run_save.bin"

# The six, by pool — the debt BO left open. Held here as a literal so the live
# dict and this file have to agree.
const TRANCHE_2 := {
	"berserker": ["Blood Offering", "Gut Rip"],
	"warden": ["Covering Guard", "Eye of the Storm"],
	"swordmaster": ["Precision Strike", "Feint"],
}

var checks := 0
var fails: Array = []
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()


func _initialize() -> void:
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
	Profile.save_path = "user://profile_batch_bp_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_break_damage()
	_warrior_draft_flow()
	await _live_berserker()
	await _live_swordmaster_precision()
	await _live_swordmaster_feint()
	await _live_warden()
	_docs()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	var scratch := "user://profile_batch_bp_test.json"
	if FileAccess.file_exists(scratch):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))

	print("\n=== BATCH BP ===")
	print("checks: %d   failures: %d" % [checks, fails.size()])
	for fl in fails:
		print("  FAIL: %s" % fl)
	quit()


# ---------- §1/§5 THE THREE POOLS ----------

func _pools() -> void:
	# THIRTY-THREE NOW — counted off the live dict rather than from the constant
	# above, so the two have to agree. RE-POINTED 24 -> 33 (Batch BT paid the
	# first third of tranche 2, nine Mage cards), on BP's own argument for
	# pinning it in the first place: what a later batch could break is not "the
	# pools are thin", it is "a pool quietly emptied", and a total read off the
	# LIVE dict catches that in either direction. BP's own six are asserted as
	# LITERALS below and did not move.
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.SPEC_DRAFT_POOLS[spec].size()
	# RE-POINTED AGAIN BY BATCH BW, WHICH CLOSES THE SERIES: tranche 2 is
	# complete, so every spec pool holds five and the total is 60.
	# RE-POINTED BY BATCH CB: tranche 3's first third landed, so the spec side
	# is 60 plus the Mage nine. The question — is the count what the batches
	# claim they shipped — is unchanged; a pool quietly EMPTYING still trips,
	# which is what pinning a count is for.
	ok(total == 96,
		"§5+tranche 3: BO's eighteen, BP's six, tranche 2's thirty-six, CB's nine and CE's nine (got %d)" % total)
	ok(Classes.SPEC_DRAFT_POOLS.size() == 12,
		"§5: all twelve specs are named")
	for spec2 in Classes.SPEC_DRAFT_POOLS:
		ok(not Classes.spec_draft_pool(spec2).is_empty(),
			"§5: EVERY spec has a draft now — %s is not empty" % spec2)
	# BATCH BW RE-POINTED THIS FROM AN EQUALITY TO A PREFIX, on BO's own
	# precedent: A LATER TRANCHE APPENDS, IT DOES NOT REWRITE. BP's six are still
	# pinned as LITERALS and still lead their pools — which is what would catch a
	# tranche quietly reordering or replacing them — but the pools are five deep
	# now and an equality would assert the debt is still owed.
	for w in TRANCHE_2:
		var live: Array = Classes.spec_draft_pool(w)
		ok(live.size() >= TRANCHE_2[w].size(),
			"§5: %s's pool still holds BP's pair and more" % w)
		ok(live.slice(0, TRANCHE_2[w].size()) == TRANCHE_2[w],
			"§5: %s's pool still LEADS with %s (got %s)" % [w, TRANCHE_2[w], live])
	# THE REMAINING DEBT IS PAID. RE-POINTED IN PLACE TWICE AND BOTH RE-POINTS
	# ARE INVERSIONS: BP asserted all four class pools were empty because none
	# had been written; BQ wrote the Mage and Cleric six; BATCH BR wrote the
	# HUNTER AND WARRIOR six, which is the pool THIS suite's own spec is drawn
	# from. The question is still worth asking — only the correct answer moved,
	# twice — so the setup stays byte-identical.
	ok(Classes.CLASS_DRAFT_POOLS.size() == 4,
		"§5: the four class-wide pools are still named")
	for ck in ["mage", "cleric", "warrior", "hunter"]:
		ok(Classes.class_draft_pool(ck).size() == 6,
			"§5: ...the %s one is FILLED at six (BQ, then BR)" % ck)
	# EVERY NEW ENTRY RESOLVES, to itself, with the fields a card needs. A pool
	# name that does not resolve is an offer that hands out nothing.
	for spec3 in TRANCHE_2:
		for n in TRANCHE_2[spec3]:
			var ab: Ability = Classes.pool_ability(String(n))
			ok(ab != null, "§5: '%s' resolves through pool_ability" % n)
			if ab == null:
				continue
			ok(ab.display_name == String(n), "§5: ...to itself (%s)" % n)
			ok(ab.description != "", "§5: ...with a description (%s)" % n)
			# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
			# perfect. As of CN that is false by design: 113 of the 211 abilities run no
			# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
			# draft card cannot advertise a bonus nothing can fire. The durable question
			# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
			# — which is strictly stronger than what was here and cannot rot as the
			# criterion catches more cards.
			ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
				"§5: ...and states a perfect exactly when it runs a check (%s)" % n)
			ok(ab.delay > 0.0, "§5: ...and an initiative cost (%s)" % n)
			ok(ab.cooldown > 0, "§5: ...and a cooldown (%s)" % n)
			ok(Classes.draft_ability(String(n)) != null,
				"§5: ...and it is a DRAFT def, so the bot hook can see it (%s)" % n)
	# COSTS ARE IN RAGE, WHICH THE BRIEF ASKED TO BE VERIFIED RATHER THAN
	# ASSUMED. All three Warrior specs share the warrior class block, so the
	# resource is one fact read off one place — and the pool is 100, so a 30-Rage
	# card is affordable.
	var wcfg := Classes.hero_config("warrior")
	ok(String(wcfg.get("resource_name", "")) == "Rage",
		"§1: the Warrior's resource is Rage (got %s)" % wcfg.get("resource_name", ""))
	ok(int(wcfg.get("max_resource", 0)) == 100,
		"§1: ...with a pool of 100, so every cost below is payable")
	for spec4 in TRANCHE_2:
		ok(Classes.class_of_spec(spec4) == "warrior",
			"§1: %s is a Warrior, so it spends Rage" % spec4)
		for n2 in TRANCHE_2[spec4]:
			var ab2: Ability = Classes.pool_ability(String(n2))
			if ab2 != null:
				ok(ab2.cost <= int(wcfg.get("max_resource", 0)),
					"§1: '%s' costs %d Rage, inside the pool" % [n2, ab2.cost])
	# NO NAME COLLIDES WITH AN EXISTING ONE. `pool_ability` resolves by display
	# name across the WHOLE game, so a collision would silently re-point an
	# existing ability at a new def.
	for spec5 in TRANCHE_2:
		for n3 in TRANCHE_2[spec5]:
			ok(not Classes.spec_pool(spec5).has(n3),
				"§5: '%s' is not also in the BOSS pool — the two draws stay separate" % n3)
			ok(Classes.class_pool("warrior").find(n3) < 0,
				"§5: '%s' is not in the old class pool either" % n3)
			ok(not Classes.protected_names(spec5).has(n3),
				"§5: '%s' is not in the opening kit either" % n3)
	# NO ENTRY IS A STRICTLY BETTER VERSION OF ITS SIBLING (BD's Deadfall
	# lesson): within a pool, no two cards may share a special, and every card
	# must differ from its sibling on more than one number.
	for spec6 in TRANCHE_2:
		var a: Ability = Classes.pool_ability(String(TRANCHE_2[spec6][0]))
		var b: Ability = Classes.pool_ability(String(TRANCHE_2[spec6][1]))
		if a == null or b == null:
			continue
		ok(a.special != b.special,
			"§5: %s's two cards are different mechanics, not one at two prices" % spec6)
		ok(a.target != b.target or a.cost != b.cost or a.cooldown != b.cooldown,
			"§5: ...and differ on more than their damage (%s)" % spec6)
	# THE PROTECTED CORES ARE UNTOUCHED BY THIS BATCH — no new entry may become
	# an enabler, and every enabler stays out of every draft pool.
	for spec7 in Classes.all_specs():
		for en in Classes.core_enablers(spec7):
			ok(not Classes.spec_draft_pool(spec7).has(en),
				"§5: %s's enabler '%s' is still NOT draftable" % [spec7, en])
	ok(Classes.core_enablers("swordmaster") == ["Guard Change"],
		"§5: Guard Change is still the Swordmaster's protected enabler")
	ok(Classes.core_slots("berserker") == 3 and Classes.core_slots("warden") == 3
		and Classes.core_slots("swordmaster") == 3,
		"§5: the three Warrior cores still cost 3 slots, so 4 stay draftable")


# ---------- §5 BREAK DAMAGE, ASSIGNED DELIBERATELY ----------

func _break_damage() -> void:
	# BO CAUGHT THAT BP'S PREDECESSOR BRIEF SAID NOTHING ABOUT `pressure`, which
	# is the omission that turned Death Ray's absent Break into a three-batch
	# thread. Only Precision Strike's Defensive branch names a figure (15); the
	# rest were decided against their siblings and are PINNED here, so a later
	# batch that moves one has to come and say so.
	#
	# `Ability.pressure` IS Break damage. There is no `bd` field — BH corrected
	# this once already, and the assertion below is what stops it recurring.
	var probe := Ability.new()
	ok("pressure" in probe, "§1: Break damage lives on `Ability.pressure`")
	ok(not ("bd" in probe), "§1: ...and there is NO `bd` field")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("const PRECISION_DEF_BD := 15"),
		"§5: Precision Strike's Defensive branch carries the 15 the brief names")
	ok(battle_src.contains("const PRECISION_AGGRO_BD := 6"),
		"§5: ...and the Aggressive branch 6 a strike — 12 across two, DELIBERATELY below it")
	ok(battle_src.contains("const FEINT_BD := 12"),
		"§5: Feint's strike carries 12, below both and below Overpower's 20")
	# THE THREE NON-ATTACKS CARRY NONE, and that is a decision too: an ability
	# that never strikes cannot contribute Break, and giving it some would be
	# Break arriving from nowhere.
	for n in ["Blood Offering", "Covering Guard", "Eye of the Storm"]:
		var ab: Ability = Classes.pool_ability(n)
		ok(ab != null and ab.pressure == 0,
			"§5: '%s' is not an attack, so it carries no Break damage" % n)
		ok(ab != null and ab.damage == 0,
			"§5: ...and no damage percentage either (%s)" % n)
	var gr: Ability = Classes.pool_ability("Gut Rip")
	ok(gr != null and gr.pressure == 20,
		"§5: Gut Rip carries 20 BD — in line with Bloodlust's 18 and Crushing Blow's 20")
	ok(gr != null and gr.damage == 6,
		"§5: ...and its `damage` is the per-10-buildup STEP (Winter's Toll's idiom)")


# ---------- §7 THE CAP AND THE DROP FLOW, WITH A WARRIOR ----------

func _warrior_draft_flow() -> void:
	var run := root.get_node("/root/Run")
	# A WARRIOR GETS A REAL OFFER FOR THE FIRST TIME. Until BP this was empty
	# and `award_draft_pick` returned false — one of four heroes in every party
	# had no draft at all.
	#
	# RE-POINTED IN PLACE BY BATCH BR, AND IT IS AN INVERSION. BP measured his
	# offer at TWO — the honest record of a spec pool two deep beside an EMPTY
	# class pool. BR filled the Warrior class six, so it fills THREE like
	# everyone else's, and the cards may come from either side. The question is
	# unchanged (does a Warrior get a real offer he can take a card off) and the
	# setup is byte-identical; what moved is the count and where a card may come
	# from.
	#
	# THE ONE MECHANICAL CHANGE: the take is driven off the candidates
	# `award_draft_pick` actually STORED rather than off a separately-rolled
	# offer. With a pool of two the two rolls were always the same two cards;
	# with eight they are not, and a test that assumed they matched would fail
	# against working code.
	var m := {"key": "warrior", "spec": "swordmaster", "bm_abilities": []}
	var offer: Array = run.roll_draft_offer(m)
	ok(offer.size() == 3,
		"§5: a Warrior's offer FILLS THREE now — two spec plus six class (got %d)" % offer.size())
	# RE-POINTED BY BATCH BW: the literal held BP's PAIR, and a Swordmaster now
	# drafts from FIVE. The question — is every offered card his own spec's or
	# his class's — is unchanged, and it is asked against the LIVE pool so it
	# cannot go stale again.
	for c in offer:
		ok(Classes.spec_draft_pool("swordmaster").has(String(c))
			or Classes.class_draft_pool("warrior").has(String(c)),
			"§5: ...and every card is his own spec's or his CLASS's (%s)" % c)
	ok(run.award_draft_pick(m), "§7: a Warrior can be owed a pick")
	ok(int(m.get("draft_picks_owed", 0)) == 1, "§7: ...exactly one")
	var cands: Array = m["draft_candidates"][0]
	ok(run.take_draft_ability(m, cands[0]) == "",
		"§7: ...and can take a card off it")
	ok(run.earned_ability_names(m).has(cands[0]),
		"§7: ...which lands in `bm_abilities`, the list a boss pick already writes")
	# THE SEVEN-SLOT CAP, DRIVEN WITH A WARRIOR. His core is 3, so 4 earned
	# abilities fill him and the fifth needs a drop.
	ok(run.ability_slots_used(m) == 4,
		"§7: 3 core + 1 earned = 4 of 7 (got %d)" % run.ability_slots_used(m))
	m["bm_abilities"] = [cands[0], "Lunge", "Execute", "Sweeping Strikes"]
	ok(run.ability_slots_used(m) == CAP,
		"§7: four earned fills the cap at 7 (got %d)" % run.ability_slots_used(m))
	ok(run.ability_slots_full(m), "§7: ...and the kit reads FULL")
	# AT THE CAP A TAKE NEEDS A DROP, AND A PROTECTED ABILITY CAN NEVER BE THE
	# ONE NAMED. Guard Change is his enabler; it is not in `bm_abilities`, so
	# the refusal is the ABSENCE of the name rather than a branch.
	m["draft_picks_owed"] = 1
	m["draft_candidates"] = [[cands[1]]]
	ok(run.take_draft_ability(m, cands[1]) != "",
		"§7: at the cap, taking without dropping is refused")
	ok(not run.drop_earned_ability(m, "Guard Change"),
		"§7: his protected enabler can never be dropped")
	ok(not run.drop_earned_ability(m, "Overpower"),
		"§7: ...nor any other opening ability")
	ok(run.take_draft_ability(m, cands[1], "Execute") == "",
		"§7: naming an EARNED ability to drop works")
	ok(not run.earned_ability_names(m).has("Execute"),
		"§7: ...and the dropped one is gone")
	ok(run.earned_ability_names(m).has(cands[1]),
		"§7: ...replaced by the card taken")
	ok(run.draft_refused(m).has("Execute"),
		"§7: ...and a DROP writes the no-return ledger too")
	ok(run.ability_slots_used(m) == CAP,
		"§7: the cap still binds after the swap")
	# DECLINING REFUSES THE WHOLE OFFER, for a Warrior as for anyone else.
	var m2 := {"key": "warrior", "spec": "berserker", "bm_abilities": []}
	ok(run.award_draft_pick(m2), "§7: a Berserker is owed a pick")
	var m2_offer: Array = m2["draft_candidates"][0]
	ok(run.decline_draft(m2), "§7: ...and may decline it")
	for c2 in m2_offer:
		ok(run.draft_refused(m2).has(String(c2)),
			"§7: ...which refuses the WHOLE offer, not one card (%s)" % c2)
	# RE-POINTED BY BATCH BR: with the class six behind him a Berserker's pool
	# is eight, so one decline no longer empties it. The question the check was
	# always asking is the one kept — a declined card never returns — and it is
	# now asserted directly rather than through a pool that happened to be two
	# deep.
	var m2_left: Array = run.roll_draft_offer(m2)
	for c2b in m2_offer:
		ok(not m2_left.has(String(c2b)),
			"§7: ...so a declined card is never offered again this run (%s)" % c2b)
	# A WARDEN IS NEVER OFFERED ANOTHER WARDEN SPEC'S CARD. Nothing
	# cross-pollinates between the three Warrior specs — that is what makes them
	# SPEC pools. RE-POINTED BY BATCH BR: his CLASS six are legitimately his
	# now, so the check names what must never appear rather than what may.
	var m3 := {"key": "warrior", "spec": "warden", "bm_abilities": []}
	# RE-POINTED AGAIN BY BATCH BW: both halves read the LIVE pools now, so this
	# check cannot go stale a third time — and the negative half got STRICTER
	# rather than merely current, because it used to name only BP's two cards per
	# sibling spec and now names all five.
	for c3 in run.roll_draft_offer(m3):
		ok(not Classes.spec_draft_pool("berserker").has(String(c3))
			and not Classes.spec_draft_pool("swordmaster").has(String(c3)),
			"§5: a Warden is never offered another Warrior spec's card (%s)" % c3)
		ok(Classes.spec_draft_pool("warden").has(String(c3))
			or Classes.class_draft_pool("warrior").has(String(c3)),
			"§5: ...only his own spec's or his class's (%s)" % c3)


# ---------- §2 THE BERSERKER, LIVE ----------

func _live_berserker() -> void:
	# SLAUGHTERHOUSE is learned deliberately: §2 says the interaction "should
	# hold here too", and the only way to know is to drive it.
	var scene := await _spawn(["berserker", "cryomancer", "holy", "mystic"],
		{"berserker": ["Blood Offering", "Gut Rip"]},
		["raider", "raider", "archer"],
		{"berserker": {"bz_slaughterhouse": 1}})
	var bz := _hero(scene, "bloodrage")
	ok(bz != null, "the Berserker spawned")
	if bz == null:
		await _drop(scene)
		return
	var bo: Ability = scene.call("_find_ability", bz, "Blood Offering")
	var gr: Ability = scene.call("_find_ability", bz, "Gut Rip")
	ok(bo != null, "§2: a DRAFTED ability is assembled onto the unit")
	ok(gr != null, "§2: ...both of them")
	if bo == null or gr == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 9999
		f.hp = 9999
	# ---- BLOOD OFFERING: PERCENT OF **CURRENT** HEALTH ----
	# Measured as an exact arithmetic identity, not as "he lost some health":
	# 20% of CURRENT is the whole safety argument, and 20% of MAXIMUM would
	# pass a vaguer check while being able to kill him.
	bz.hp = bz.max_hp
	bz.resource = 0
	var full_hp := bz.hp
	await scene.call("_resolve", bz, bo, bz, "good")
	ok(bz.hp == full_hp - maxi(int(round(full_hp * 0.20)), 1),
		"§2: Blood Offering costs exactly 20%% of CURRENT health (%d -> %d of %d)" % [
			full_hp, bz.hp, bz.max_hp])
	# BATCH CQ §3 — SIXTY SINCE CN §3'S FOLD: the perfect paid 60 and the base
	# 40, the bar came off the card, and 60 is what every cast pays.
	ok(bz.resource == 60, "§2: ...and pays 60 Rage (got %d)" % bz.resource)
	# THE COST SHRINKS AS HE DROPS — the property that makes it right for a spec
	# that wants to live low. A percentage of MAXIMUM would charge the same.
	var high_cost := full_hp - bz.hp
	bz.hp = int(bz.max_hp * 0.30)
	bz.resource = 0
	var low_before := bz.hp
	scene.call("_resolve_special", bz, bo, bz, "good", 1.0)
	var low_cost := low_before - bz.hp
	ok(low_cost < high_cost,
		"§2: ...so the same cast costs LESS the lower he is (%d at full, %d at 30%%)" % [
			high_cost, low_cost])
	# AS AN EXACT IDENTITY AT THE SECOND HEALTH LEVEL TOO, and this is the check
	# that actually discriminates: the FLOOR of 1 keeps him alive under a
	# maximum-health reading as well, so "it cannot kill him" is true of both
	# implementations and only the COST tells them apart.
	ok(low_cost == maxi(int(round(low_before * 0.20)), 1),
		"§2: ...and it is 20%% of THAT health, not of his maximum (%d of %d)" % [
			low_cost, low_before])
	ok(low_cost != maxi(int(round(bz.max_hp * 0.20)), 1),
		"§2: ...which is a different number from 20%% of the maximum (%d vs %d)" % [
			low_cost, maxi(int(round(bz.max_hp * 0.20)), 1)])
	# IT CAN NEVER KILL HIM, DRIVEN FROM 1 HP — where a max-health percentage
	# would have taken him straight through the floor.
	bz.hp = 1
	bz.resource = 0
	scene.call("_resolve_special", bz, bo, bz, "good", 1.0)
	ok(bz.hp >= 1 and not bz.dead,
		"§2: BLOOD OFFERING CANNOT REDUCE HIM BELOW 1 (%d HP, dead=%s)" % [
			bz.hp, bz.dead])
	ok(bz.resource == 60, "§2: ...and still pays in full at 1 HP")
	# The perfect pays more, and it is the RAGE that moves — not the toll.
	bz.hp = bz.max_hp
	bz.resource = 0
	scene.call("_resolve_special", bz, bo, bz, "perfect", 1.0)
	ok(bz.resource == 60, "§2: a perfect Blood Offering pays 60 (got %d)" % bz.resource)
	# ---- GUT RIP: THE **REAL** BLEEDOUT PATH ----
	# ASSERTED THROUGH A BLEEDOUT-READING TALENT, not through "damage happened".
	# Blood Tithe pays 45 Rage per enemy bleedout and Slaughterhouse re-seeds
	# the meter — neither can fire off a private burst written inside the
	# ability, which is exactly the failure §2 names.
	bz.hp = bz.max_hp
	bz.blood_tithe_ranks = 1
	bz.bloodcraze = 0
	bz.resource = 0
	var mark: BattleUnit = foes[0]
	mark.bleed_buildup = 40
	var bleedouts_before: int = bz.bleedouts_this_battle
	var hp_before: int = mark.hp
	await scene.call("_resolve", bz, gr, mark, "good")
	ok(bz.bleedouts_this_battle == bleedouts_before + 1,
		"§2: GUT RIP FIRES THE REAL BLEEDOUT — the battle's tally moved (%d -> %d)" % [
			bleedouts_before, bz.bleedouts_this_battle])
	ok(bz.resource >= 45,
		"§2: ...and BLOOD TITHE, which reads a bleedout EVENT, collected (%d Rage)" % bz.resource)
	ok(mark.hp < hp_before,
		"§2: ...and the target took the bleedout plus the strike (%d -> %d)" % [
			hp_before, mark.hp])
	# SLAUGHTERHOUSE HOLDS HERE TOO — the meter falls to 50, not to 0, so a
	# second Gut Rip has half a wound waiting for it.
	ok(mark.bleed_buildup == 50,
		"§2: ...and SLAUGHTERHOUSE leaves the wound open at 50 (got %d)" % \
			mark.bleed_buildup)
	# THE DAMAGE IS PAID ON WHAT WAS CONSUMED. Driven at two different buildups
	# on identical bodies: a flat hit would read the same both times.
	bz.blood_tithe_ranks = 0
	bz.slaughterhouse = 0
	var deep: BattleUnit = foes[1]
	var shallow: BattleUnit = foes[2]
	deep.armor = 0.0
	shallow.armor = 0.0
	deep.bleed_buildup = 90
	shallow.bleed_buildup = 0
	deep.max_hp = 100000
	shallow.max_hp = 100000
	deep.hp = 100000
	shallow.hp = 100000
	await scene.call("_resolve", bz, gr, deep, "good")
	var deep_lost: int = 100000 - deep.hp
	await scene.call("_resolve", bz, gr, shallow, "good")
	var shallow_lost: int = 100000 - shallow.hp
	ok(deep_lost > shallow_lost,
		"§2: Gut Rip's damage scales with the buildup CONSUMED (90 -> %d, 0 -> %d)" % [
			deep_lost, shallow_lost])
	ok(shallow_lost > 0,
		"§2: ...and an empty meter still bleeds them out (%d)" % shallow_lost)
	await _drop(scene)


# ---------- §3 PRECISION STRIKE, LIVE ----------

func _live_swordmaster_precision() -> void:
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		{"swordmaster": ["Precision Strike", "Feint"]},
		["raider", "raider", "archer"])
	var sm := _hero(scene, "seasoned")
	ok(sm != null, "the Swordmaster spawned")
	if sm == null:
		await _drop(scene)
		return
	var ps: Ability = scene.call("_find_ability", sm, "Precision Strike")
	ok(ps != null, "§3: Precision Strike is assembled onto the unit")
	if ps == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 100000
		f.hp = 100000
	# THE STANCE IS FRESH EACH BATTLE AND OPENS AGGRESSIVE — the premise both
	# branches are written against.
	ok(sm.stance == "aggressive", "§3: he opens Aggressive (got %s)" % sm.stance)
	# ---- FROM AGGRESSIVE: two cuts, +25% parry, and he ARRIVES Defensive ----
	sm.remove_status("parry_up")
	sm.remove_status("open_guard")
	foes[0].armor = 0.0
	await scene.call("_resolve", sm, ps, foes[0], "good")
	ok(sm.stance == "defensive",
		"§3: PRECISION STRIKE SWITCHES THE STANCE — Aggressive -> %s" % sm.stance)
	ok(sm.has_status("parry_up"),
		"§3: ...and the Aggressive branch grants parry, which is what the DEFENSIVE guard he arrives in wants")
	ok(sm.status_power("parry_up") == 25,
		"§3: ...+25%% of it (got %d)" % sm.status_power("parry_up"))
	ok(not sm.has_status("open_guard"),
		"§3: ...and NOT the armor bypass — that is the other branch")
	# ---- FROM DEFENSIVE: one cut, the bypass, and he ARRIVES Aggressive ----
	sm.remove_status("parry_up")
	await scene.call("_resolve", sm, ps, foes[1], "good")
	ok(sm.stance == "aggressive",
		"§3: ...and it switches back (Defensive -> %s)" % sm.stance)
	ok(sm.has_status("open_guard"),
		"§3: THE ARRIVING-STANCE PRINCIPLE — from Defensive it grants offence (the bypass)")
	ok(not sm.has_status("parry_up"),
		"§3: ...and NOT the parry")
	# ---- THE BYPASS AGAINST A HIGH-ARMOR TARGET, WHICH IS THE CLAUSE THAT
	# COULD SILENTLY DO NOTHING. Driven on the SAME body at the SAME armor with
	# the status up and down, so what is measured is the clause and not the
	# roll. Armor is 0.85 (the clamp), so a working bypass is ~6.7x the damage.
	var wall: BattleUnit = foes[2]
	wall.armor = 0.85
	wall.max_hp = 1000000
	wall.hp = 1000000
	wall.resists = {}
	# A BROKEN unit's armor is x0.7, and the casts above had already Broken this
	# one — which quietly turned an 85% wall into a 60% one and halved the margin
	# the check is measuring. Held un-Breakable for the duration so what is
	# measured is the bypass and not the Break meter.
	wall.broken = false
	wall.pressure = 0
	wall.constitution = 1000000
	var basic: Ability = sm.abilities[0]
	sm.crit_bonus = -1.0    # kill the crit roll: this is about armor, not luck
	var with_bypass := 0
	for _i in 12:
		var h0: int = wall.hp
		await scene.call("_resolve", sm, basic, wall, "good")
		with_bypass += h0 - wall.hp
	sm.remove_status("open_guard")
	var without := 0
	for _i in 12:
		var h1: int = wall.hp
		await scene.call("_resolve", sm, basic, wall, "good")
		without += h1 - wall.hp
	ok(with_bypass > without * 3,
		"§3: OPEN GUARD BYPASSES ARMOR OUTRIGHT against an 85%%-armored target (%d vs %d over 12 hits)" % [
			with_bypass, without])
	# AND IT IS A BYPASS RATHER THAN A PERCENTAGE — the reason it was written
	# that way is "+50% of zero", so prove the clause is not a multiplier ON
	# armor by checking it changes nothing against an UNARMOURED target.
	var soft: BattleUnit = foes[0]
	soft.armor = 0.0
	soft.max_hp = 1000000
	soft.hp = 1000000
	scene.call("_apply_status", sm, "open_guard", 4)
	var soft_with := 0
	for _i in 12:
		var h2: int = soft.hp
		await scene.call("_resolve", sm, basic, soft, "good")
		soft_with += h2 - soft.hp
	sm.remove_status("open_guard")
	var soft_without := 0
	for _i in 12:
		var h3: int = soft.hp
		await scene.call("_resolve", sm, basic, soft, "good")
		soft_without += h3 - soft.hp
	ok(absf(float(soft_with - soft_without)) < soft_without * 0.35,
		"§3: ...and buys NOTHING against an unarmoured target, which a percentage would too — but a bypass says so honestly (%d vs %d)" % [
			soft_with, soft_without])
	sm.crit_bonus = 0.0
	await _drop(scene)


# ---------- §3 FEINT, LIVE ----------

func _live_swordmaster_feint() -> void:
	var scene := await _spawn(["swordmaster", "cryomancer", "holy", "mystic"],
		{"swordmaster": ["Precision Strike", "Feint"]},
		["raider", "raider", "archer"])
	var sm := _hero(scene, "seasoned")
	if sm == null:
		ok(false, "the Swordmaster spawned (Feint)")
		await _drop(scene)
		return
	var ft: Ability = scene.call("_find_ability", sm, "Feint")
	ok(ft != null, "§3: Feint is assembled onto the unit")
	if ft == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 100000
		f.hp = 100000
		f.armor = 0.0
	# ---- FROM AGGRESSIVE: the strike, the mark, and the switch ----
	ok(sm.stance == "aggressive", "§3: he opens Aggressive")
	var mark: BattleUnit = foes[0]
	var hp0: int = mark.hp
	await scene.call("_resolve", sm, ft, mark, "good")
	ok(mark.hp < hp0, "§3: the Aggressive branch strikes (%d -> %d)" % [hp0, mark.hp])
	ok(mark.has_status("feinted"),
		"§3: ...and marks the enemy's NEXT attack for redirection")
	ok(sm.stance == "defensive", "§3: ...then switches the stance")
	# THE MARK WAITS UNTIL SPENT — a CHARGE, not a clock. Ticking a full battle
	# of turns off it must not remove it, which is what "cannot be dodged by an
	# enemy simply not attacking that turn" means mechanically.
	for _t in 12:
		mark.tick_statuses()
	ok(mark.has_status("feinted"),
		"§3: FEINT'S MARK PERSISTS UNTIL SPENT — twelve turns did not expire it")
	# ---- THE REDIRECT LANDS ON AN ALLY OF THE TARGET, NOT ON NOTHING ----
	# Driven through the real resolution site: the enemy's declared attack is
	# re-pointed, resolves, and its damage lands on a FELLOW ENEMY while every
	# hero is untouched.
	var hero_hp := {}
	for h in scene.get("heroes"):
		hero_hp[h] = h.hp
	var fellow_hp := {}
	for f2 in foes:
		fellow_hp[f2] = f2.hp
	scene.set("debug_enemies_off", false)
	scene.call("_declare_intent", mark)
	await scene.call("_enemy_turn", mark)
	ok(not mark.has_status("feinted"),
		"§3: the redirect SPENDS the mark")
	var fellow_hurt := false
	for f3 in foes:
		if f3 != mark and f3.hp < fellow_hp[f3]:
			fellow_hurt = true
	var hero_hurt := false
	for h2 in scene.get("heroes"):
		if h2.hp < hero_hp[h2]:
			hero_hurt = true
	ok(fellow_hurt,
		"§3: THE REDIRECTED BLOW LANDS ON ONE OF THE TARGET'S OWN ALLIES")
	ok(not hero_hurt,
		"§3: ...and on NO hero — it went somewhere they did not intend")
	# ---- FROM DEFENSIVE: charges, no strike, and the reflect ----
	ok(sm.stance == "defensive", "§3: he is Defensive after the first cast")
	var untouched: BattleUnit = foes[1]
	var before: int = untouched.hp
	await scene.call("_resolve", sm, ft, untouched, "good")
	ok(untouched.hp == before,
		"§3: the DEFENSIVE branch makes NO strike at all (%d -> %d)" % [
			before, untouched.hp])
	ok(sm.feint_guards == 2,
		"§3: ...it banks 2 charges (got %d)" % sm.feint_guards)
	ok(sm.has_status("feint_guard"),
		"§3: ...with a chip that says so")
	ok(sm.stance == "aggressive", "§3: ...and it switches the stance too")
	# THE CHARGES WAIT UNTIL SPENT, not for a number of turns.
	for _t2 in 12:
		sm.tick_statuses()
	ok(sm.feint_guards == 2,
		"§3: FEINT'S CHARGES PERSIST — twelve turns did not spend one (got %d)" % \
			sm.feint_guards)
	# SPENT BY A REAL BLOW: he takes NOTHING and the attacker takes the damage.
	# "The charges persist" is trivially true if nothing ever attacks him, so
	# the spend is what proves the mechanism.
	sm.hp = sm.max_hp
	var sm_hp: int = sm.hp
	# PARRY IS MELEE-ONLY (bows and spells sail past the blade), so the striker
	# has to be a raider rather than the archer — an archer would prove nothing
	# about a parry that never rolls.
	var striker: BattleUnit = foes[1]
	striker.is_ranged = false
	striker.hp = 100000
	var striker_hp: int = striker.hp
	var enemy_basic: Ability = scene.call("_cheapest_attack", striker)
	await scene.call("_resolve", striker, enemy_basic, sm, "good")
	ok(sm.feint_guards == 1,
		"§3: a real blow SPENDS one charge (got %d)" % sm.feint_guards)
	ok(sm.hp == sm_hp,
		"§3: ...and he takes NOTHING from it (%d -> %d)" % [sm_hp, sm.hp])
	ok(striker.hp < striker_hp,
		"§3: ...while ITS OWN DAMAGE lands on the attacker (%d -> %d)" % [
			striker_hp, striker.hp])
	# THE SECOND CHARGE ANSWERS TOO, AND THEN THEY ARE GONE.
	await scene.call("_resolve", striker, enemy_basic, sm, "good")
	ok(sm.feint_guards == 0,
		"§3: the second charge answers as well (got %d)" % sm.feint_guards)
	ok(not sm.has_status("feint_guard"),
		"§3: ...and the chip goes with the last of them")
	var sm_hp2: int = sm.hp
	await scene.call("_resolve", striker, enemy_basic, sm, "good")
	ok(sm.hp < sm_hp2,
		"§3: ...after which blows land on him again (%d -> %d)" % [sm_hp2, sm.hp])
	# ---- FEINT AND WAITING GUARD RESOLVE CLEANLY TOGETHER AND DO NOT
	# DOUBLE-COUNT. §3 flags Riposte; Waiting Guard is the closer neighbour, and
	# the ORDER is the decision: the RENEWABLE bank spends first, so a paid
	# Feint charge is never eaten by a parry he would have made anyway.
	sm.feint_guards = 1
	scene.call("_stamp_feint_chip", sm)
	sm.banked_guards = 1
	sm.update_status("waiting_guard", "1", "Banked Guards: 1")
	await scene.call("_resolve", striker, enemy_basic, sm, "good")
	ok(sm.banked_guards == 0 and sm.feint_guards == 1,
		"§3: WAITING GUARD SPENDS FIRST — the free bank goes before the paid charge (wg=%d, feint=%d)" % [
			sm.banked_guards, sm.feint_guards])
	# ...and ONE parry is consumed per blow, not two.
	await scene.call("_resolve", striker, enemy_basic, sm, "good")
	ok(sm.feint_guards == 0,
		"§3: ...and each blow spends exactly ONE charge, never both sources")
	await _drop(scene)


# ---------- §4 THE WARDEN, LIVE ----------

func _live_warden() -> void:
	var scene := await _spawn(["warden", "cryomancer", "holy", "mystic"],
		{"warden": ["Covering Guard", "Eye of the Storm"]},
		["raider", "raider", "archer"])
	var wd := _hero(scene, "heavy_plating")
	ok(wd != null, "the Warden spawned")
	if wd == null:
		await _drop(scene)
		return
	var cg: Ability = scene.call("_find_ability", wd, "Covering Guard")
	var es: Ability = scene.call("_find_ability", wd, "Eye of the Storm")
	ok(cg != null, "§4: Covering Guard is assembled onto the unit")
	ok(es != null, "§4: ...and Eye of the Storm")
	if cg == null or es == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 100000
		f.hp = 100000
	var ally: BattleUnit = null
	for h in scene.get("heroes"):
		if h != wd and not h.is_companion:
			ally = h
			break
	ok(ally != null, "§4: there is an ally to cover")
	if ally == null:
		await _drop(scene)
		return
	# A Warrior opens on 0 Rage, so the usable gate below is about the CAST
	# being payable rather than about the ward. And the covered ally has to
	# survive twenty-odd driven blows — a death would clear the very status the
	# section is measuring and read as the ward expiring.
	wd.resource = wd.max_resource
	ally.max_hp = 100000
	ally.hp = 100000
	ally.armor = 0.0
	# ---- IT IS FOR SOMEONE ELSE, AND THAT IS STRUCTURAL ----
	# The picker's pool and the bot's pool are both narrowed, and the usable
	# gate refuses the cast outright when he stands alone. Three sites, one rule.
	ok(scene.call("_ability_usable", wd, cg),
		"§4: Covering Guard is usable while an ally stands")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("if ab.special == \"covering_guard\":\n\t\t\t\t\tpool = pool.filter(func(a): return a != u)"),
		"§4: ...and the player's ally picker excludes him")
	# AND THE ROLL ITSELF REFUSES A SELF-WARD, which is the behavioural half:
	# even if a ward somehow landed on him, `_covering_warden` will not hand his
	# own Block back as a second slice of his own roll.
	scene.call("_apply_status", wd, "covering_guard", 4, 0, 0, wd)
	ok(scene.call("_covering_warden", wd) == null,
		"§4: ...and a ward on HIMSELF is never a second slice of his own roll")
	wd.remove_status("covering_guard")
	# ---- IT READS HIS **LIVE** BLOCK CHANCE ----
	# The Null Field construction: the ward is laid while his Block is ZERO and
	# the Shieldwall goes up AFTERWARD. A number snapshotted at cast time would
	# have stored nothing and blocked nothing.
	wd.block_chance = 0.0
	wd.plating_bonus = 0.0
	wd.remove_status("shieldwall")
	ally.block_chance = 0.0
	ally.parry_chance = 0.0
	ok(is_equal_approx(scene.call("_live_block_chance", wd), 0.15),
		"§4: his live Block is the passive's 15%% alone right now (%.2f)" % \
			scene.call("_live_block_chance", wd))
	await scene.call("_resolve", wd, cg, ally, "good")
	ok(ally.has_status("covering_guard"),
		"§4: the ward lands on the ally")
	ok(String(ally.get_status("covering_guard").get("src_name", "")) == wd.unit_name,
		"§4: ...stamped with the Warden who laid it")
	ok(scene.call("_covering_warden", ally) == wd,
		"§4: ...and it resolves back to him live")
	# NOW RAISE HIS BLOCK — AFTER the cast. Heavy Plating's climb and Shieldwall
	# are both in the slice, so both must feed a ward already standing.
	wd.plating_bonus = 0.40
	scene.call("_apply_status", wd, "shieldwall", 9, 45)
	var live: float = scene.call("_live_block_chance", wd)
	ok(live > 0.99,
		"§4: ...and his live Block has since climbed to %.2f (plating + Shieldwall)" % live)
	# DRIVE REAL ATTACKS AT THE WARDED ALLY. At ~100% cover every one must be
	# negated ENTIRELY — not reduced.
	var striker: BattleUnit = foes[0]
	striker.is_ranged = false
	var enemy_basic: Ability = scene.call("_cheapest_attack", striker)
	ally.hp = ally.max_hp
	var ally_hp: int = ally.hp
	for _i in 8:
		await scene.call("_resolve", striker, enemy_basic, ally, "good")
	ok(ally.hp == ally_hp,
		"§4: COVERING GUARD NEGATES THE ATTACK ENTIRELY — 8 blows, %d -> %d" % [
			ally_hp, ally.hp])
	ok(_log_has(scene, "Covering Guard"),
		"§4: ...and the log names what stopped them")
	# NOTHING MOVED TO HIM. This is not redirection — the blow simply stops.
	var wd_hp: int = wd.hp
	for _i in 6:
		await scene.call("_resolve", striker, enemy_basic, ally, "good")
	ok(wd.hp == wd_hp,
		"§4: ...and NOTHING MOVES TO HIM (%d -> %d)" % [wd_hp, wd.hp])
	# AND IT IS LIVE, NOT A SNAPSHOT: drop his Block back to nothing and the
	# same ward stops covering. A cast-time stamp would keep blocking.
	wd.plating_bonus = 0.0
	wd.remove_status("shieldwall")
	wd.block_chance = 0.0
	wd.passive_id = "none"   # strip the plating slice entirely
	ok(scene.call("_live_block_chance", wd) < 0.01,
		"§4: his live Block is zero again")
	ally.hp = ally.max_hp
	var ally_hp2: int = ally.hp
	for _i in 8:
		await scene.call("_resolve", striker, enemy_basic, ally, "good")
	ok(ally.hp < ally_hp2,
		"§4: ...SO THE SAME WARD STOPS COVERING (%d -> %d) — it was never a snapshot" % [
			ally_hp2, ally.hp])
	wd.passive_id = "heavy_plating"
	# THE DEAD WARDEN STOPS COVERING TOO — his body is the ward.
	ok(ally.has_status("covering_guard"),
		"§4: the ward is still standing on the ally")
	wd.dead = true
	ok(scene.call("_covering_warden", ally) == null,
		"§4: ...but a fallen Warden covers nobody")
	wd.dead = false
	# ---- EYE OF THE STORM ----
	for f2 in foes:
		f2.remove_status("mocked")
	ally.remove_status("covering_guard")
	wd.remove_status("eye_storm")
	var living := 0
	for f3 in foes:
		if not f3.dead:
			living += 1
	await scene.call("_resolve", wd, es, wd, "good")
	var taunted := 0
	var wd_idx: int = scene.get("heroes").find(wd)
	for f4 in foes:
		if f4.has_status("mocked") and f4.status_power("mocked") == wd_idx:
			taunted += 1
	ok(taunted == living,
		"§4: Eye of the Storm taunts EVERY enemy (%d of %d)" % [taunted, living])
	ok(wd.has_status("eye_storm"), "§4: ...and he holds the storm")
	ok(wd.status_power("eye_storm") == living * 8,
		"§4: EYE OF THE STORM SCALES WITH THE NUMBER ACTUALLY TAUNTED — %d%% for %d enemies (got %d)" % [
			living * 8, living, wd.status_power("eye_storm")])
	# THE MITIGATION IS REAL, not just a chip. Measured over 30 hits with and
	# without: a 24% cut against a +/-10% roll separates cleanly at that n.
	wd.hp = 100000
	wd.max_hp = 100000
	wd.armor = 0.0
	wd.block_chance = 0.0
	wd.plating_bonus = 0.0
	wd.crit_bonus = 0.0
	striker.crit_bonus = -1.0
	var with_storm := 0
	for _i in 30:
		var h0: int = wd.hp
		await scene.call("_resolve", striker, enemy_basic, wd, "good")
		with_storm += h0 - wd.hp
	wd.remove_status("eye_storm")
	var without_storm := 0
	for _i in 30:
		var h1: int = wd.hp
		await scene.call("_resolve", striker, enemy_basic, wd, "good")
		without_storm += h1 - wd.hp
	ok(with_storm < without_storm,
		"§4: ...and it really cuts the damage (%d vs %d over 30 hits each)" % [
			with_storm, without_storm])
	ok(float(with_storm) < float(without_storm) * 0.90,
		"§4: ...by roughly the %d%% it advertises" % (living * 8))
	# A SMALLER FIELD PAYS LESS. The scaling is the ability's whole
	# self-balancing argument, so it is measured rather than asserted once.
	striker.crit_bonus = 0.0
	for f5 in foes:
		f5.remove_status("mocked")
	wd.remove_status("eye_storm")
	foes[2].dead = true
	scene.call("_resolve_special", wd, es, wd, "good", 1.0)
	ok(wd.status_power("eye_storm") == (living - 1) * 8,
		"§4: ...and one fewer body is %d%% rather than %d%% (got %d)" % [
			(living - 1) * 8, living * 8, wd.status_power("eye_storm")])
	foes[2].dead = false
	await _drop(scene)


# ---------- DOCS ----------

func _docs() -> void:
	var master := _src("res://docs/master.html")
	var claude := _src("res://CLAUDE.md")
	var glossary := _src("res://data/glossary.json")
	# THE MASTER.HTML STAMP GATE IS DUPLICATED **SEVEN** TIMES — BP's own note
	# said four and then added this fifth copy without counting it; BQ was the
	# sixth and test_batch_br is the seventh. test_batch_ah, test_batch_bb,
	# test_batch_bn, test_batch_bo, HERE, test_batch_bq and test_batch_br. ALL
	# SEVEN MUST MOVE TOGETHER or a batch that bumps the timestamp trips suites
	# it never touched. (BATCH BV moved NINE: the seven named here plus
	# test_batch_bs and test_batch_bu. The count grows by one each time a new
	# suite checks the stamp, and every one of them is a suite this batch did
	# not otherwise touch — which is the cost the duplication keeps charging.)
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
	ok(stamped >= "BP",
		"...and master.html is stamped no older than this suite's own batch (reads '%s')" % stamped)
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch BP — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch BP")` would have gone on PASSING against the live file,
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
	ok(arch_mark > 0, "§6: the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var changelog := _src(arch_path)
	ok(changelog.length() > 100000,
		"§6: the archive opens at %s (%d chars)" % [arch_path, changelog.length()])
	ok(not live_log.contains("<h2>2026-08-13 &mdash; Batch BP"),
		"§6: CX moved this batch's entry OUT of the live changelog")
	ok(changelog.contains("<h2>2026-08-13 &mdash; Batch BP"),
		"§6: ...and the archive carries the Batch BP entry")
	for spec in TRANCHE_2:
		for n in TRANCHE_2[spec]:
			ok(master.contains(String(n)),
				"§6: master.html's draft table names '%s'" % n)
			ok(changelog.contains(String(n)),
				"§6: ...and so does the changelog (%s)" % n)
			ok(claude.contains(String(n)),
				"§6: ...and CLAUDE.md (%s)" % n)
	# THE STANCE BRANCHES ARE WRITTEN OUT PER BRANCH, NOT SUMMARISED — a player
	# reading one line must learn that the ability flips him.
	ok(master.contains("From Aggressive") and master.contains("From Defensive"),
		"§6: master.html writes the stance branches out per branch")
	ok(master.count("From Aggressive") >= 2,
		"§6: ...for BOTH stance abilities")
	# THE ARRIVING-STANCE PRINCIPLE IS A STANDING DESIGN RULE, because it is the
	# thing a later stance ability would most easily get backwards.
	ok(claude.contains("ARRIVING"),
		"§6: CLAUDE.md states the arriving-stance principle as a standing rule")
	ok(claude.contains("stance-GATED") or claude.contains("stance-gated"),
		"§6: ...and records stance-GATED abilities as a noted future direction")
	# THE GLOSSARY KNOWS ABOUT THE STANCE, and now that abilities read AND
	# change it, the entry has to say so.
	ok(glossary.contains("stance"),
		"§6: the glossary carries a stance entry")
	var parsed = JSON.parse_string(glossary)
	var found := false
	if parsed is Array:
		for e in parsed:
			if String(e.get("id", "")) == "stance":
				found = true
				ok(String(e.get("long", "")).contains("Precision Strike"),
					"§6: ...naming the abilities that read and change it")
				ok(String(e.get("category", "")) != "",
					"§6: ...filed under a category")
	ok(found, "§6: ...as a real entry with an id of its own")


# The combat log is a RichTextLabel (`history`), not a line list — read the
# text it actually rendered, which is what a player would see.
func _log_has(scene: Node, needle: String) -> bool:
	var hist = scene.get("history")
	return hist != null and String(hist.get_parsed_text()).contains(needle)


# ---------- the live harness (the BO shape) ----------

func _spawn(specs: Array, granted: Dictionary, lineup: Array,
		learned := {}) -> Node:
	# Block is zeroed too — every block in this suite has to be one Covering
	# Guard bought.
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
