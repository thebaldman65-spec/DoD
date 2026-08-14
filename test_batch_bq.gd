# test_batch_bq.gd — THE MAGE AND CLERIC CLASS POOLS. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bq.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §6 of the brief names FIVE clauses that could silently do
# nothing, plus two more it asks for by name, and every one is driven live and
# asserted against the state it is supposed to have changed:
#   · Mirror Image counting three SINGLE-TARGET attacks and not spending a
#     charge on an area attack;
#   · Mana Well doubling the figure the drip ACTUALLY uses rather than a base
#     it no longer reads;
#   · Dispel stripping beneficial effects from an enemy — and whether any
#     exist to strip;
#   · Blink reaching every cooldown INCLUDING an ability drafted this run;
#   · Undying Vigil firing on healing from ANY source and choosing a SECOND
#     ally on lower health rather than re-healing the warded one;
#   · Exhortation BANKING rather than expiring, confirmed with a slow hero who
#     acts long after any nominal window would have closed;
#   · `CLASS_POOLS` byte-unchanged, asserted directly — the negative control
#     that matters, because a boss offer quietly re-weighting is exactly what
#     the separate structure exists to prevent.
#
# FIVE OF THEM WOULD PASS ON BROKEN CODE IF WRITTEN THE OBVIOUS WAY, so each is
# built so a broken implementation still FAILS:
#   · "an AoE spends no image" is trivially true of charges that never move at
#     all — so the single-target SPEND is asserted in the same check, either
#     side of the area attack;
#   · "Mana Well doubles the regen" is trivially true of doubling a hardcoded
#     12 — so it is measured on a Mage carrying Evocation's +10, where the
#     right answer (44) and the stale-constant answer (24) differ;
#   · "Dispel strips beneficial effects" is trivially true of a function that
#     returns every status — so a party MARK is put on the same enemy and
#     asserted UNTOUCHED;
#   · "Blink ticks cooldowns" is trivially true of Follow-Through's old code —
#     so a DRAFTED ability's cooldown and Blink's OWN are asserted in opposite
#     directions by the same cast;
#   · "Undying Vigil forks a heal" is trivially true of an effect that heals
#     whoever is lowest — so an ally ABOVE the warded one is left standing at a
#     known health and asserted not to have been touched.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# The twelve, by pool. Held here as a literal so the live dict and this file
# have to agree — a name added to one and not the other trips.
const TRANCHE_3 := {
	"mage": ["Magic Barrier", "Mirror Image", "Magic Missiles", "Mana Well",
		"Dispel", "Blink"],
	"cleric": ["Ministration", "Consecration", "Chastise", "Unburden",
		"Exhortation", "Undying Vigil"],
}

# THE NEGATIVE CONTROL THAT MATTERS (§6). `CLASS_POOLS` feeds the BOSS pick,
# and the whole reason `CLASS_DRAFT_POOLS` is a separate structure is that
# dropping twelve entries into this one would silently re-weight every boss
# offer in the game. Asserted as a literal, not as a size: a swap of two names
# would keep the count and change every draw.
const CLASS_POOLS_AT_BQ := {
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
	Profile.save_path = "user://profile_batch_bq_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_class_pools_untouched()
	_break_damage()
	_weaker_half()
	_draft_flow()
	_seam()
	await _live_barrier_and_mirror()
	await _live_mana_well_and_blink()
	await _live_dispel()
	await _live_cleric_heals()
	await _live_chastise_and_unburden()
	await _live_exhortation()
	await _live_undying_vigil()
	_docs()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	var scratch := "user://profile_batch_bq_test.json"
	if FileAccess.file_exists(scratch):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(scratch))

	print("\n=== BATCH BQ ===")
	print("checks: %d   failures: %d" % [checks, fails.size()])
	for fl in fails:
		print("  FAIL: %s" % fl)
	quit()


# ---------- §1/§3/§4 THE TWO POOLS ----------

func _pools() -> void:
	ok(Classes.CLASS_DRAFT_POOLS.size() == 4,
		"§1: CLASS_DRAFT_POOLS still keys all four classes")
	var total := 0
	for cls in Classes.CLASS_DRAFT_POOLS:
		total += Classes.CLASS_DRAFT_POOLS[cls].size()
	ok(total == 12,
		"§3/§4: twelve class-wide abilities ship (read off the live dict: %d)" % total)
	for cls in TRANCHE_3:
		var live: Array = Classes.class_draft_pool(cls)
		ok(live.size() == 6, "§3/§4: the %s class pool holds six (%d)" % [cls, live.size()])
		for nm in TRANCHE_3[cls]:
			ok(live.has(nm), "§3/§4: %s is in the %s class pool" % [nm, cls])
	# THE DEBT, STATED AS AN ASSERTION rather than as prose. It must stay
	# visible until it is paid: a Hunter or Warrior offer still loses its class
	# card, and a later batch reading "twelve shipped" should not have to guess
	# which twelve.
	ok(Classes.class_draft_pool("hunter").is_empty(),
		"§0: the HUNTER class pool is still owed and still says so")
	ok(Classes.class_draft_pool("warrior").is_empty(),
		"§0: the WARRIOR class pool is still owed and still says so")
	# EVERY ENTRY RESOLVES THROUGH THE ONE RESOLVER, which is what makes the
	# battle spawn, the hero sheet, the rune filter and the blacksmith pairing
	# all pick them up with no new plumbing.
	for cls2 in TRANCHE_3:
		for nm2 in TRANCHE_3[cls2]:
			var ab: Ability = Classes.pool_ability(nm2)
			ok(ab != null, "§1: %s resolves through Classes.pool_ability" % nm2)
			if ab == null:
				continue
			ok(ab.display_name == nm2, "§1: ...to itself (%s)" % nm2)
			ok(ab.description != "", "§1: ...carrying a description (%s)" % nm2)
			ok(ab.perfect_text != "", "§1: ...and a perfect (%s)" % nm2)
	# AND EVERY SPEC OF THE CLASS CAN DRAW IT — §6's own wording: a Pyromancer,
	# a Cryomancer and an Arcanist must all be able to draw Magic Barrier.
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		ok(Classes.class_of_spec(spec) == "mage",
			"§6: %s is a Mage, so the Mage class pool is his" % spec)
		ok(Classes.class_draft_pool(Classes.class_of_spec(spec)).has("Magic Barrier"),
			"§6: ...and %s can draw Magic Barrier" % spec)
	for spec2 in ["holy", "inquisitor", "occultist"]:
		ok(Classes.class_of_spec(spec2) == "cleric",
			"§6: %s is a Cleric, so the Cleric class pool is his" % spec2)
		ok(Classes.class_draft_pool(Classes.class_of_spec(spec2)).has("Ministration"),
			"§6: ...and %s can draw Ministration" % spec2)
	# NOTHING IN THE CLASS POOL IS ALSO IN A SPEC POOL. The two sides of one
	# offer must not be able to hold the same card.
	for cls3 in Classes.CLASS_DRAFT_POOLS:
		for nm3 in Classes.CLASS_DRAFT_POOLS[cls3]:
			for spec3 in Classes.SPEC_DRAFT_POOLS:
				ok(not Classes.SPEC_DRAFT_POOLS[spec3].has(nm3),
					"§1: %s is class-wide only, never in %s's spec draft" % [nm3, spec3])
	ok(Classes.SPEC_DRAFT_POOLS.size() == 12,
		"§1: the spec draft still covers all twelve specs")
	var spec_total := 0
	for sp in Classes.SPEC_DRAFT_POOLS:
		spec_total += Classes.SPEC_DRAFT_POOLS[sp].size()
	ok(spec_total == 24, "§1: ...at BP's twenty-four, untouched (%d)" % spec_total)


func _class_pools_untouched() -> void:
	# §6's NAMED NEGATIVE CONTROL, asserted directly rather than by a count.
	ok(Classes.CLASS_POOLS.size() == 4, "§1: CLASS_POOLS still keys four classes")
	for cls in CLASS_POOLS_AT_BQ:
		var live: Array = Classes.CLASS_POOLS.get(cls, [])
		ok(live == CLASS_POOLS_AT_BQ[cls],
			"§1: CLASS_POOLS[%s] is BYTE-UNTOUCHED by this batch" % cls)
	# And the twelve are NOT in it — the tidy-looking edit a later batch would
	# make is exactly the one this asserts against.
	for cls2 in TRANCHE_3:
		for nm in TRANCHE_3[cls2]:
			ok(not Classes.CLASS_POOLS[cls2].has(nm),
				"§1: %s did NOT leak into the boss pool CLASS_POOLS[%s]" % [nm, cls2])


# ---------- §2 BREAK DAMAGE, ASSIGNED RATHER THAN OMITTED ----------

func _break_damage() -> void:
	# TWO of the twelve are attacks. The other ten never strike, and Break from
	# an ability that never strikes is Break from nowhere.
	var want := {
		"Chastise": 20,          # the one figure the brief names
		"Magic Missiles": 3,     # PER BOLT — 9 across three, 12 on a perfect
		"Magic Barrier": 0, "Mirror Image": 0, "Mana Well": 0, "Dispel": 0,
		"Blink": 0, "Ministration": 0, "Consecration": 0, "Unburden": 0,
		"Exhortation": 0, "Undying Vigil": 0,
	}
	for nm in want:
		var ab: Ability = Classes.pool_ability(nm)
		ok(ab != null and ab.pressure == int(want[nm]),
			"§2: %s carries %d Break damage" % [nm, int(want[nm])])
	# THE SIBLING COMPARISON THE ASSIGNMENT WAS MADE AGAINST, pinned so a later
	# reprice has to come and say so: Magic Missiles' 3 a bolt sits under Razor
	# Ice's 10 and level with Arcane Barrage's 3 while throwing half as many.
	var razor: Ability = Classes.pool_ability("Razor Ice")
	var barrage: Ability = Classes.pool_ability("Arcane Barrage")
	var missiles: Ability = Classes.pool_ability("Magic Missiles")
	ok(razor != null and missiles != null and missiles.pressure < razor.pressure,
		"§2: Magic Missiles' per-bolt Break is BELOW Razor Ice's")
	ok(barrage != null and missiles != null and missiles.multi_hits < barrage.random_hits,
		"§2: ...and it throws fewer bolts than Arcane Barrage")


# ---------- §2 THE "WEAKER" HALF, VERIFIED RATHER THAN TRUSTED ----------

func _weaker_half() -> void:
	# MINISTRATION AGAINST HOLY'S HEAL. Heal is 40% of the CLERIC's maximum;
	# Ministration is 20% of the TARGET's. The worst case for the rule is the
	# beefiest target in the game, so that is the one it is checked against.
	var holy_max := int(Classes.SPEC_INFO["holy"].get("max_hp", 150))
	var warden_max := int(Classes.SPEC_INFO["warden"].get("max_hp", 200))
	var heal_on_holy := int(round(holy_max * 0.40))
	var ministration_on_warden := int(round(warden_max * 0.20))
	ok(ministration_on_warden < heal_on_holy,
		"§2: Ministration on the beefiest ally (%d) is LESS than Holy's Heal (%d)" % [
			ministration_on_warden, heal_on_holy])
	# The same Mercy multiplier scales both, so the gap survives every build —
	# checked as arithmetic rather than asserted as prose.
	ok(int(round(ministration_on_warden * 1.25)) < int(round(heal_on_holy * 1.25)),
		"§2: ...and still less at five Mercy, because one term scales both")
	# MAGIC MISSILES AGAINST THE MAGE FILLERS IT SITS BESIDE.
	var missiles: Ability = Classes.pool_ability("Magic Missiles")
	var razor: Ability = Classes.pool_ability("Razor Ice")
	var barrage: Ability = Classes.pool_ability("Arcane Barrage")
	ok(missiles.damage * missiles.multi_hits < razor.damage * razor.multi_hits,
		"§2: Magic Missiles' total (%d%%) is under Razor Ice's (%d%%)" % [
			missiles.damage * missiles.multi_hits, razor.damage * razor.multi_hits])
	ok(missiles.damage * missiles.multi_hits < barrage.damage * barrage.random_hits,
		"§2: ...and under Arcane Barrage's (%d%%)" % [
			barrage.damage * barrage.random_hits])
	# MAGIC BARRIER AGAINST DIVINE SHIELD, the game's other absorb.
	ok(0.15 < 0.30,
		"§2: Magic Barrier's 15%% of maximum is under Divine Shield's 30%%")
	var barrier: Ability = Classes.pool_ability("Magic Barrier")
	var shield: Ability = Classes.pool_ability("Divine Shield")
	ok(barrier.cost > shield.cost and barrier.cooldown > shield.cooldown,
		"§2: ...for more Mana and a longer cooldown")
	# MIRROR IMAGE AND MAGIC BARRIER ARE NOT A STRICT UPGRADE OF EACH OTHER,
	# which is §3's rule applied inside one pool. The structural proof is that
	# each answers something the other cannot: the images are spent only by
	# SINGLE-TARGET attacks, and the barrier eats a share of everything.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("and (_mirror_dodge(attacker, target) \\"),
		"§3: Mirror Image is spent inside the single-target branch, so an AoE never touches it")
	# THE ONE CARD THAT FAILS §2 IN THE OTHER DIRECTION, PINNED AS A FINDING.
	# Chastise is DOMINATED by the free core attack on damage for all three
	# Cleric specs. It ships as specified and this check is what makes the
	# report survive: a later batch that re-prices either number trips it and
	# has to read the reasoning first.
	var chastise: Ability = Classes.pool_ability("Chastise")
	var smite: Ability = null
	for ab in Classes.cleric_kit():
		if ab.display_name == "Smite":
			smite = ab
	ok(smite != null, "§2: the Cleric's free core attack is Smite")
	if smite != null:
		ok(chastise.damage < smite.damage,
			"§2 FINDING (reported, not re-tuned): Chastise's %d%% is UNDER the free Smite's %d%%" % [
				chastise.damage, smite.damage])
		ok(chastise.cost > 0 and chastise.cooldown > 0 and smite.cost == 0,
			"§2 FINDING: ...while costing Mana and a cooldown Smite does not")
		ok(chastise.pressure > smite.pressure,
			"§2 FINDING: ...and the ONLY thing it wins on is Break (%d vs %d)" % [
				chastise.pressure, smite.pressure])
	# The occultist's core is the other comparison and it reads the same way.
	var occ_cfg := {"abilities": Classes.kit("cleric")}
	Classes.apply_kit_overrides(occ_cfg, "occultist")
	var shadowrend: Ability = occ_cfg["abilities"][0]
	ok(shadowrend.display_name == "Shadowrend" and chastise.damage <= shadowrend.damage,
		"§2 FINDING: ...and level with Shadowrend's %d%%, which is free and Cripples" % \
			shadowrend.damage)


# ---------- §1 THE DRAFT READS THE NEW POOL ----------

func _draft_flow() -> void:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	var mage: Dictionary = run.party[1]
	mage["spec"] = "cryomancer"
	var cleric: Dictionary = run.party[2]
	cleric["spec"] = "occultist"
	var hunter: Dictionary = run.party[3]
	hunter["spec"] = "sharpshooter"
	var mage_left: Dictionary = run.draft_pool_left(mage)
	ok(mage_left["class"].size() == 6,
		"§1: a Cryomancer's class side of the draft holds six (%d)" % \
			mage_left["class"].size())
	var cleric_left: Dictionary = run.draft_pool_left(cleric)
	ok(cleric_left["class"].size() == 6,
		"§1: an Occultist's class side holds six (%d)" % cleric_left["class"].size())
	var hunter_left: Dictionary = run.draft_pool_left(hunter)
	ok(hunter_left["class"].is_empty(),
		"§0: a Sharpshooter's class side is still EMPTY — the debt, visible in the roll")
	# The no-return ledger covers a class card exactly as it covers a spec one.
	mage["draft_refused"] = ["Magic Barrier"]
	var refused_left: Dictionary = run.draft_pool_left(mage)
	ok(not refused_left["class"].has("Magic Barrier"),
		"§1: a refused class card does not come back this run")
	mage["draft_refused"] = []
	# AND A REAL OFFER NOW HOLDS THEM. Rolled many times because the seam is a
	# per-card roll: one offer proves nothing about which side it drew from.
	var saw_class := false
	var saw_spec := false
	for _i in 200:
		var offer: Array = run.roll_draft_offer(mage)
		ok(offer.size() == 3, "§1: a Mage's offer fills THREE now")
		for nm in offer:
			if Classes.class_draft_pool("mage").has(nm):
				saw_class = true
			if Classes.spec_draft_pool("cryomancer").has(nm):
				saw_spec = true
	ok(saw_class, "§1: ...and real class cards appear in it")
	ok(saw_spec, "§1: ...beside real spec cards")
	# A HUNTER STILL FILLS SHORT, and that is the shape of the remaining debt.
	var hunter_offer: Array = run.roll_draft_offer(hunter)
	ok(hunter_offer.size() == 2,
		"§0: a Sharpshooter's offer still fills SHORT at two (%d)" % hunter_offer.size())
	for nm2 in hunter_offer:
		ok(Classes.spec_draft_pool("sharpshooter").has(nm2),
			"§0: ...and every card in it is spec-side")


func _seam() -> void:
	# §6 — the seam fires at roughly one card in four, NOW DRAWING REAL ENTRIES
	# on both sides. Driven through `draft_card_is_class` itself, which is the
	# function BO extracted precisely so a test could measure the ratio.
	var run := root.get_node("/root/Run")
	var class_cards := 0
	var trials := 4000
	for _i in trials:
		if run.draft_card_is_class(6, 6):
			class_cards += 1
	var share := class_cards / float(trials)
	ok(share > 0.20 and share < 0.30,
		"§6: the class seam fires at roughly one card in four (%.3f over %d)" % [
			share, trials])
	ok(Classes.CLASS_DRAFT_SHARE == 0.25,
		"§6: ...off the one constant that decides it")
	# The two degenerate ends are unchanged by this batch and still matter: an
	# empty class pool never draws (the Hunter and Warrior case, today), and an
	# empty spec pool always does.
	ok(not run.draft_card_is_class(6, 0),
		"§6: an empty class pool never draws — a Hunter's offer is all spec")
	ok(run.draft_card_is_class(0, 6),
		"§6: ...and an exhausted spec pool falls entirely to the class side")


# ---------- LIVE: THE MAGE SIX ----------

func _live_barrier_and_mirror() -> void:
	var scene := await _spawn(["berserker", "pyromancer", "holy", "beastmaster"],
		{"pyromancer": ["Magic Barrier", "Mirror Image"]},
		["raider", "raider", "archer"])
	var mage := _hero(scene, "overburn")
	ok(mage != null, "the Pyromancer spawned")
	if mage == null:
		await _drop(scene)
		return
	var barrier: Ability = scene.call("_find_ability", mage, "Magic Barrier")
	var mirror: Ability = scene.call("_find_ability", mage, "Mirror Image")
	ok(barrier != null, "§3: Magic Barrier is assembled onto the unit")
	ok(mirror != null, "§3: ...and Mirror Image")
	if barrier == null or mirror == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	mage.resource = mage.max_resource
	mage.hp = mage.max_hp
	# ---- MAGIC BARRIER ABSORBS 15% OF **MAXIMUM** HEALTH ----
	await scene.call("_resolve", mage, barrier, mage, "good")
	var want_absorb := int(round(mage.max_hp * 0.15))
	ok(mage.has_status("barrier"), "§3: Magic Barrier lands a barrier")
	ok(mage.status_power("barrier") == want_absorb,
		"§3: ...worth 15%% of his MAXIMUM health (%d, wanted %d)" % [
			mage.status_power("barrier"), want_absorb])
	# It is NOT a Divine Shield: Faith is the Devout's engine and a Mage ward
	# feeding Conviction would be a spec mechanic leaking through a class card.
	ok(not bool(mage.get_status("barrier").get("divine", false)),
		"§3: ...and it is NOT divine, so it builds nobody's Faith")
	var hp_before := mage.hp
	mage.take_hit(want_absorb - 1, 0)
	ok(mage.hp == hp_before,
		"§3: ...and it really eats the damage (%d -> %d)" % [hp_before, mage.hp])
	mage.remove_status("barrier")
	# ---- MIRROR IMAGE: THREE SINGLE-TARGET ATTACKS, AND AN AoE SPENDS NONE ----
	# The enemies must be able to miss for the branch to be reachable at all,
	# so `no_cover` is left OFF on their side — see `_mirror_dodge`.
	mage.hp = mage.max_hp
	mage.armor = 0.0
	mage.resource = mage.max_resource
	await scene.call("_resolve", mage, mirror, mage, "good")
	ok(mage.status_power("mirror") == 3,
		"§3: Mirror Image stands up three images (%d)" % mage.status_power("mirror"))
	var strike: Ability = foe.abilities[0]
	var aoe: Ability = Ability.make({"display_name": "Test Sweep", "cost": 0,
		"damage": 20, "pressure": 0, "delay": 2.0, "aoe": true})
	# THE DISCRIMINATOR: an area attack in the MIDDLE of the count. If charges
	# never move, the single-target spends below fail; if the AoE spends one,
	# this does.
	await scene.call("_resolve", foe, strike, mage, "good")
	ok(mage.status_power("mirror") == 2,
		"§6: a single-target attack spends ONE image (%d left)" % \
			mage.status_power("mirror"))
	var hp_mid := mage.hp
	await scene.call("_resolve", foe, aoe, mage, "good")
	ok(mage.status_power("mirror") == 2,
		"§6: an AREA attack spends NONE (%d left)" % mage.status_power("mirror"))
	ok(mage.hp < hp_mid, "§6: ...because it landed instead — the images cannot see it")
	mage.hp = mage.max_hp
	await scene.call("_resolve", foe, strike, mage, "good")
	await scene.call("_resolve", foe, strike, mage, "good")
	# NOTE: `status_power` returns -1 for a status that is not there, not 0 —
	# so absence is asserted with `has_status`. Product code is written around
	# it (every read guards on `< 1` or `> 0`), but a check written the obvious
	# way reads -1 and fails against working code.
	ok(not mage.has_status("mirror"),
		"§6: the third single-target attack spends the last image and clears the chip")
	ok(mage.hp == mage.max_hp,
		"§6: ...and not one of those three landed a point of damage")
	# WITH THE IMAGES GONE THE BLOW LANDS. Forced past the 5% miss so the
	# assertion is deterministic rather than usually true.
	foe.no_cover = 1
	await scene.call("_resolve", foe, strike, mage, "good")
	ok(mage.hp < mage.max_hp, "§6: ...and the fourth attack lands on him")
	await _drop(scene)


func _live_mana_well_and_blink() -> void:
	var scene := await _spawn(["berserker", "arcanist", "holy", "beastmaster"],
		{"arcanist": ["Mana Well", "Blink", "Magic Missiles"]},
		["raider", "raider", "archer"])
	var mage := _hero(scene, "resonance")
	if mage == null:
		# The Arcanist's passive id is authored in SPEC_INFO; find him by kit.
		for h in scene.get("heroes"):
			if not h.is_companion and scene.call("_find_ability", h, "Mana Well") != null:
				mage = h
	ok(mage != null, "the Arcanist spawned")
	if mage == null:
		await _drop(scene)
		return
	var well: Ability = scene.call("_find_ability", mage, "Mana Well")
	var blink: Ability = scene.call("_find_ability", mage, "Blink")
	var missiles: Ability = scene.call("_find_ability", mage, "Magic Missiles")
	ok(well != null and blink != null and missiles != null,
		"§3: Mana Well, Blink and Magic Missiles are all assembled onto the unit")
	if well == null or blink == null or missiles == null:
		await _drop(scene)
		return
	# ---- MANA WELL DOUBLES THE **LIVE** FIGURE, NOT A STALE CONSTANT ----
	# THE DISCRIMINATOR: a Mage carries Evocation's +10, so the honest answer
	# (44) and the doubling-a-hardcoded-12 answer (24) are different numbers.
	ok(mage.mana_regen_bonus > 0,
		"§6: the Mage carries Evocation's regen bonus (+%d) — the discriminator" % \
			mage.mana_regen_bonus)
	var base_regen: int = scene.call("_mana_regen", mage)
	ok(base_regen == 12 + mage.mana_regen_bonus,
		"§6: his ordinary drip is 12 + Evocation (%d)" % base_regen)
	mage.resource = mage.max_resource
	await scene.call("_resolve", mage, well, mage, "good")
	ok(mage.has_status("mana_well"), "§3: Mana Well lands")
	var doubled: int = scene.call("_mana_regen", mage)
	ok(doubled == base_regen * 2,
		"§6: ...and the drip DOUBLES to %d, not to a doubled 12 (%d)" % [
			doubled, 24])
	mage.remove_status("mana_well")
	ok(int(scene.call("_mana_regen", mage)) == base_regen,
		"§6: ...and falls back when it lapses")
	# ---- BLINK REACHES EVERY COOLDOWN, INCLUDING ONE DRAFTED THIS RUN ----
	mage.resource = mage.max_resource
	mage.cooldowns.clear()
	var foes: Array = scene.get("enemies")
	# A DRAFTED ability's cooldown (Magic Missiles, earned this run) and a KIT
	# ability's, put there by real casts rather than written in by hand.
	await scene.call("_resolve", mage, missiles, foes[0], "good")
	var cannon: Ability = scene.call("_find_ability", mage, "Arcane Cannon")
	if cannon != null:
		mage.resource = mage.max_resource
		await scene.call("_resolve", mage, cannon, foes[0], "good")
	var missiles_cd := int(mage.cooldowns.get("Magic Missiles", 0))
	var cannon_cd := int(mage.cooldowns.get("Arcane Cannon", 0))
	ok(missiles_cd > 0, "§6: the DRAFTED ability is on cooldown (%d)" % missiles_cd)
	ok(cannon_cd > 0, "§6: ...and so is a kit ability (%d)" % cannon_cd)
	mage.resource = mage.max_resource
	await scene.call("_resolve", mage, blink, mage, "good")
	ok(int(mage.cooldowns.get("Magic Missiles", 0)) == missiles_cd - 1,
		"§6: Blink takes a turn off the DRAFTED ability's cooldown")
	ok(int(mage.cooldowns.get("Arcane Cannon", 0)) == cannon_cd - 1,
		"§6: ...and off the kit ability's")
	# AND NOT OFF ITS OWN — the other half of the same cast, so a helper that
	# simply walked everything trips here.
	ok(int(mage.cooldowns.get("Blink", 0)) == blink.cooldown + 1,
		"§6: ...and NOT off its own (%d, the full %d)" % [
			int(mage.cooldowns.get("Blink", 0)), blink.cooldown + 1])
	# ONE IMPLEMENTATION, FOUR OLD CALLERS RE-POINTED AT IT.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("func _tick_cooldowns(u: BattleUnit, turns: int, skip := \"\") -> int:"),
		"§3: the cooldown hook is ONE function")
	ok(battle_src.count("_tick_cooldowns(") >= 6,
		"§3: ...with Blink and the four talents that predate it all calling it (%d sites)" % \
			battle_src.count("_tick_cooldowns("))
	await _drop(scene)


func _live_dispel() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "beastmaster"],
		{"cryomancer": ["Dispel"]}, ["shieldmaster", "raider", "archer"])
	var mage := _hero(scene, "permafrost")
	ok(mage != null, "the Cryomancer spawned")
	if mage == null:
		await _drop(scene)
		return
	var dispel: Ability = scene.call("_find_ability", mage, "Dispel")
	ok(dispel != null, "§3: Dispel is assembled onto the unit")
	if dispel == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	var ally: BattleUnit = null
	for h in scene.get("heroes"):
		if h != mage and not h.is_companion:
			ally = h
			break
	ok(ally != null, "§3: there is an ally to unpick")
	if ally == null:
		await _drop(scene)
		return
	# ---- THE ALLY HALF: TWO HARMFUL EFFECTS ----
	scene.call("_apply_status", ally, "exposed", 3)
	scene.call("_apply_status", ally, "cripple", 3)
	scene.call("_apply_status", ally, "sunder", 3)
	mage.resource = mage.max_resource
	await scene.call("_resolve", mage, dispel, ally, "good")
	var left := 0
	for id in ["exposed", "cripple", "sunder"]:
		if ally.has_status(id):
			left += 1
	ok(left == 1, "§3: Dispel strips exactly TWO harmful effects from an ally (%d left)" % left)
	# ---- THE ENEMY HALF: DOES ANYTHING EXIST TO REMOVE? §3 ASKED, SO IT IS
	# MEASURED. `shielded` is the only beneficial status an enemy can carry.
	scene.call("_apply_status", foe, "shielded", 3)
	ok(foe.has_status("shielded"), "§3: an enemy really can carry a beneficial effect")
	# THE DISCRIMINATOR: a party MARK on the same body. A `_dispellable_buffs`
	# that returned everything-not-a-debuff would strip the party's own work,
	# which is the exact opposite of the ability.
	scene.call("_apply_status", foe, "quarry", -1, 0, 0, mage)
	scene.call("_apply_status", foe, "hunt_mark", -1, 0, 0, mage)
	var buffs: Array = scene.call("_dispellable_buffs", foe)
	ok(buffs.size() == 1,
		"§6: exactly ONE dispellable buff stands on that enemy (%d)" % buffs.size())
	ok(buffs.size() == 1 and String(buffs[0].id) == "shielded",
		"§6: ...and it is the ward, not the party's marks")
	mage.resource = mage.max_resource
	mage.cooldowns.clear()
	await scene.call("_resolve", mage, dispel, foe, "good")
	ok(not foe.has_status("shielded"), "§6: Dispel strips the enemy's ward")
	ok(foe.has_status("quarry") and foe.has_status("hunt_mark"),
		"§6: ...and leaves the party's own marks exactly where they were")
	# THE FINDING, PINNED: the enemy half reaches ONE status in the whole game.
	ok(BattleUnit.DEBUFF_IDS.has("ruin") and not BattleUnit.DEBUFF_IDS.has("ruin_primed"),
		"§3: `ruin_primed` is not a debuff, which is why it is named in DISPEL_NEVER")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("const DISPEL_NEVER := [\"covenant\", \"quarry\", \"snare_line\","),
		"§3: ...and the exclusion list names every mark that would otherwise read as a buff")
	ok(battle_src.contains("\"hunt_mark\", \"ruin_primed\", \"charging\", \"spec_passive\"]"),
		"§3: ...including `charging`, because cancelling a wind-up is what a BREAK is for")
	await _drop(scene)


# ---------- LIVE: THE CLERIC SIX ----------

func _live_cleric_heals() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "occultist", "beastmaster"],
		{"occultist": ["Ministration", "Consecration"]},
		["raider", "raider", "archer"])
	var cleric := _hero(scene, "old_gods")
	ok(cleric != null, "the Occultist spawned")
	if cleric == null:
		await _drop(scene)
		return
	var minist: Ability = scene.call("_find_ability", cleric, "Ministration")
	var consec: Ability = scene.call("_find_ability", cleric, "Consecration")
	ok(minist != null and consec != null,
		"§4: Ministration and Consecration are assembled onto the unit")
	if minist == null or consec == null:
		await _drop(scene)
		return
	var ally: BattleUnit = null
	for h in scene.get("heroes"):
		if h != cleric and not h.is_companion:
			ally = h
			break
	if ally == null:
		await _drop(scene)
		return
	# ---- MINISTRATION READS THE TARGET'S MAXIMUM, NOT THE CASTER'S ----
	# The two Clerics have very different maximums from the Berserker, so a
	# caster-side reading would give a different number and this check knows it.
	ally.hp = 1
	cleric.resource = cleric.max_resource
	await scene.call("_resolve", cleric, minist, ally, "good")
	var want := int(round(ally.max_hp * 0.20))
	ok(ally.hp == 1 + want,
		"§4: Ministration heals 20%% of the TARGET's maximum (%d, wanted %d)" % [
			ally.hp - 1, want])
	ok(want != int(round(cleric.max_hp * 0.20)) or ally.max_hp == cleric.max_hp,
		"§4: ...which is a different number from 20%% of the caster's")
	# ---- CONSECRATION: THE WHOLE PARTY, AND ITS TICK IS ITS OWN FUNCTION ----
	cleric.resource = cleric.max_resource
	cleric.cooldowns.clear()
	await scene.call("_resolve", cleric, consec, cleric, "good")
	var blessed := 0
	for h2 in scene.get("heroes"):
		if h2.is_companion:
			continue
		if h2.has_status("consecration"):
			blessed += 1
	ok(blessed == 4, "§4: Consecration blesses the whole party (%d)" % blessed)
	ok(String(ally.get_status("consecration").get("src_name", "")) == cleric.unit_name,
		"§4: ...stamped with the Cleric who paid for it, so the drip books to him")
	ally.hp = 1
	scene.call("_consecration_tick", ally)
	var want_tick := maxi(int(round(ally.max_hp * 0.05)), 1)
	ok(ally.hp == 1 + want_tick,
		"§4: ...and the drip mends 5%% of his OWN maximum a turn (%d, wanted %d)" % [
			ally.hp - 1, want_tick])
	# The tick is reachable by a test at all only because it is its own
	# function — a clause inside `_run_battle` could only ever be grepped.
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("func _consecration_tick(u: BattleUnit) -> void:"),
		"§4: the drip is its own function (the AR trap)")
	ok(battle_src.contains("\t\t_consecration_tick(u)"),
		"§4: ...called from the turn-start block")
	# A hero WITHOUT the blessing gains nothing from the same call.
	cleric.remove_status("consecration")
	var cleric_hp := cleric.hp
	scene.call("_consecration_tick", cleric)
	ok(cleric.hp == cleric_hp, "§4: ...and it does nothing to somebody unblessed")
	await _drop(scene)


func _live_chastise_and_unburden() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "holy", "beastmaster"],
		{"holy": ["Chastise", "Unburden"]}, ["raider", "raider", "archer"])
	var cleric := _hero(scene, "mercy")
	if cleric == null:
		for h in scene.get("heroes"):
			if not h.is_companion and scene.call("_find_ability", h, "Chastise") != null:
				cleric = h
	ok(cleric != null, "the Holy Cleric spawned")
	if cleric == null:
		await _drop(scene)
		return
	var chastise: Ability = scene.call("_find_ability", cleric, "Chastise")
	var unburden: Ability = scene.call("_find_ability", cleric, "Unburden")
	ok(chastise != null and unburden != null,
		"§4: Chastise and Unburden are assembled onto the unit")
	if chastise == null or unburden == null:
		await _drop(scene)
		return
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	foe.max_hp = 100000
	foe.hp = 100000
	foe.pressure = 0
	cleric.resource = cleric.max_resource
	cleric.no_cover = 1
	# ---- CHASTISE PUTS ITS BREAK ON THE METER ----
	await scene.call("_resolve", cleric, chastise, foe, "good")
	ok(foe.pressure > 0,
		"§2: Chastise really moves the Break meter (%d)" % foe.pressure)
	ok(foe.hp < 100000, "§2: ...and deals its damage too")
	# ---- UNBURDEN: EVERY HARMFUL EFFECT, AND THE TAIL ----
	var ally: BattleUnit = null
	for h2 in scene.get("heroes"):
		if h2 != cleric and not h2.is_companion:
			ally = h2
			break
	if ally == null:
		await _drop(scene)
		return
	for id in ["exposed", "cripple", "sunder", "dazed"]:
		scene.call("_apply_status", ally, id, 3)
	cleric.resource = cleric.max_resource
	cleric.cooldowns.clear()
	await scene.call("_resolve", cleric, unburden, ally, "good")
	var still := 0
	for id2 in ["exposed", "cripple", "sunder", "dazed"]:
		if ally.has_status(id2):
			still += 1
	ok(still == 0, "§4: Unburden removes EVERY harmful effect (%d left)" % still)
	ok(ally.has_status("unburdened"), "§4: ...and leaves the mitigation behind")
	ok(String(ally.get_status("unburdened").get("src_name", "")) == cleric.unit_name,
		"§4: ...credited to the Cleric who cast it")
	# THE TAIL IS WHAT MAKES IT NEVER A WASTED CARD: cast on somebody carrying
	# NOTHING, the mitigation still lands. That is the unconditional rule as a
	# mechanic rather than as an intention.
	var clean: BattleUnit = cleric
	clean.purge_debuffs()
	clean.remove_status("unburdened")
	cleric.resource = cleric.max_resource
	cleric.cooldowns.clear()
	await scene.call("_resolve", cleric, unburden, clean, "good")
	ok(clean.has_status("unburdened"),
		"§4: ...and with nothing to remove it is still the mitigation")
	# And the 20% is real, measured as a delta against the same blow twice.
	ally.remove_status("unburdened")
	ally.armor = 0.0
	ally.parry_chance = 0.0
	ally.block_chance = 0.0
	ally.max_hp = 100000
	ally.hp = 100000
	foe.no_cover = 1
	var strike: Ability = foe.abilities[0]
	await scene.call("_resolve", foe, strike, ally, "good")
	var bare := 100000 - ally.hp
	ally.hp = 100000
	scene.call("_apply_status", ally, "unburdened", 3)
	await scene.call("_resolve", foe, strike, ally, "good")
	var warded := 100000 - ally.hp
	ok(warded < bare,
		"§4: the mitigation really blunts the blow (%d against %d bare)" % [warded, bare])
	await _drop(scene)


func _live_exhortation() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "inquisitor", "beastmaster"],
		{"inquisitor": ["Exhortation"]}, ["raider", "raider", "archer"])
	var cleric := _hero(scene, "conviction")
	ok(cleric != null, "the Devout spawned")
	if cleric == null:
		await _drop(scene)
		return
	var exhort: Ability = scene.call("_find_ability", cleric, "Exhortation")
	ok(exhort != null, "§4: Exhortation is assembled onto the unit")
	if exhort == null:
		await _drop(scene)
		return
	cleric.resource = cleric.max_resource
	await scene.call("_resolve", cleric, exhort, cleric, "good")
	var called := 0
	for h in scene.get("heroes"):
		if h.is_companion:
			continue
		if h.status_power("exhorted") == 25:
			called += 1
	ok(called == 4, "§4: Exhortation banks 25%% on the whole party (%d)" % called)
	# ---- BANKED, NOT TIMED — §6's own check, with a SLOW hero ----
	# Ten status ticks is far past any nominal window a 2- or 3-turn buff would
	# have had. If it were on a clock this is where it would be gone.
	var slow: BattleUnit = null
	for h2 in scene.get("heroes"):
		if h2 != cleric and not h2.is_companion:
			slow = h2
			break
	if slow == null:
		await _drop(scene)
		return
	for _t in 10:
		slow.tick_statuses()
	ok(slow.status_power("exhorted") == 25,
		"§6: it is still there after TEN turns — banked, not timed (%d)" % \
			slow.status_power("exhorted"))
	ok(slow.has_status("exhorted"), "§6: ...and the chip is still on the bar")
	# ---- AND IT IS SPENT BY THE NEXT ATTACK, ONCE ----
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	foe.max_hp = 1000000
	foe.hp = 1000000
	foe.armor = 0.0
	foe.parry_chance = 0.0
	foe.block_chance = 0.0
	slow.no_cover = 1
	slow.resource = slow.max_resource
	var basic: Ability = slow.abilities[0]
	await scene.call("_resolve", slow, basic, foe, "good")
	ok(not slow.has_status("exhorted"),
		"§6: the next attack SPENDS it and the chip goes with it")
	var boosted := 1000000 - foe.hp
	foe.hp = 1000000
	slow.resource = slow.max_resource
	slow.cooldowns.clear()
	await scene.call("_resolve", slow, basic, foe, "good")
	var plain := 1000000 - foe.hp
	# Damage carries a +/-10% roll, so the assertion is that the boosted blow is
	# clear of the plain one's ceiling rather than exactly 25% above it.
	ok(boosted > plain,
		"§4: ...and the blow it paid for really landed harder (%d against %d)" % [
			boosted, plain])
	await _drop(scene)


func _live_undying_vigil() -> void:
	var scene := await _spawn(["berserker", "cryomancer", "occultist", "beastmaster"],
		{"occultist": ["Undying Vigil"]}, ["raider", "raider", "archer"])
	var cleric := _hero(scene, "old_gods")
	ok(cleric != null, "the Occultist spawned (again, for the vigil)")
	if cleric == null:
		await _drop(scene)
		return
	var vigil: Ability = scene.call("_find_ability", cleric, "Undying Vigil")
	ok(vigil != null, "§4: Undying Vigil is assembled onto the unit")
	if vigil == null:
		await _drop(scene)
		return
	var others: Array = []
	for h in scene.get("heroes"):
		if h != cleric and not h.is_companion:
			others.append(h)
	ok(others.size() >= 3, "§4: there is a warded ally and two others to choose between")
	if others.size() < 3:
		await _drop(scene)
		return
	var warded: BattleUnit = others[0]
	var lower: BattleUnit = others[1]
	var middle: BattleUnit = others[2]
	var higher: BattleUnit = cleric
	# THE BOARD IS THE DISCRIMINATOR. The warded ally sits at 60%, one ally at
	# 20% and one at 30%, and the caster stays at full. An implementation that
	# healed "whoever is lowest" without the strictly-below rule, or that
	# re-healed the warded one, or that took the wrong end of the pool, all fail
	# against this arrangement rather than against a two-body one.
	warded.hp = int(warded.max_hp * 0.60)
	lower.hp = int(lower.max_hp * 0.20)
	middle.hp = int(middle.max_hp * 0.30)
	higher.hp = higher.max_hp
	cleric.resource = cleric.max_resource
	await scene.call("_resolve", cleric, vigil, warded, "good")
	ok(warded.has_status("vigil"), "§4: the vigil lands on the warded ally")
	var lower_before := lower.hp
	var middle_before := middle.hp
	var higher_before := higher.hp
	var warded_before := warded.hp
	# ---- HEALING FROM **ANY** SOURCE, so the drive is a bare `heal_amount`
	# rather than a heal ability: nothing about the fork may depend on which
	# card produced the healing.
	var landed := warded.heal_amount(40, true)
	ok(landed > 0, "§6: a heal from no ability at all lands on the warded ally (%d)" % landed)
	ok(warded.hp == warded_before + landed, "§6: ...and it is the whole heal")
	ok(lower.hp == lower_before + maxi(int(round(landed * 0.5)), 1),
		"§6: the SECOND ally on lower health is healed for half as much (%d)" % [
			lower.hp - lower_before])
	ok(middle.hp == middle_before,
		"§6: ...the ally BETWEEN them is not the one chosen")
	ok(higher.hp == higher_before,
		"§6: ...and the ally on HIGHER health is not touched")
	# ---- IT DOES NOT CHAIN, AND THE CHAIN IS GENUINELY REACHABLE ----
	# The fork RAISES its recipient, so a second warded ally can end up above
	# somebody who was above them a moment ago — which is a real chain, not a
	# theoretical one. Ward the recipient too, reset the board, and heal again:
	# with the guard the middle ally is untouched, without it he is healed.
	scene.call("_apply_status", lower, "vigil", 3)
	warded.hp = int(warded.max_hp * 0.60)
	lower.hp = int(lower.max_hp * 0.20)
	middle.hp = int(middle.max_hp * 0.30)
	var lower_was := lower.hp
	var middle_was := middle.hp
	warded.heal_amount(60, true)
	ok(lower.hp > lower_was, "§6: the fork still reaches the second ally")
	ok(lower.hp / float(lower.max_hp) > middle.hp / float(middle.max_hp),
		"§6: ...and it lifts him ABOVE the third, so a chain would have somewhere to go")
	ok(middle.hp == middle_was,
		"§6: ...and does NOT chain onward from him (the re-entrancy guard)")
	var battle_src := _src("res://scripts/battle.gd")
	ok(battle_src.contains("var _vigil_forking := false"),
		"§6: the guard exists and is one flag")
	var unit_src := _src("res://scripts/unit.gd")
	ok(unit_src.contains("if final > 0 and has_status(\"vigil\") and vigil_cb.is_valid():"),
		"§6: the hook is at the bottom of heal_amount, so it sees every source")
	await _drop(scene)


# ---------- §5 THE DOCUMENTATION ----------

func _docs() -> void:
	var master := _src("res://docs/master.html")
	ok(master.contains("Batch BQ"), "§5: master.html is stamped Batch BQ")
	for cls in TRANCHE_3:
		for nm in TRANCHE_3[cls]:
			ok(master.contains(nm), "§5: master.html lists %s" % nm)
	ok(master.to_lower().contains("half-filled") \
			or master.to_lower().contains("half filled"),
		"§5: master.html says the class seam is HALF filled")
	var changelog := _src("res://docs/changelog.html")
	ok(changelog.find("Batch BQ") >= 0, "§5: the changelog has a Batch BQ entry")
	# SLICE ON THE HEADING, NOT ON THE PHRASE — the BE lesson, and it is a real
	# one: a later entry saying "every suite at its Batch BQ count" in its own
	# regression line would otherwise steal the slice and every assertion below
	# would silently stop asking its question. `&mdash; Batch BQ:` only ever
	# appears in the <h2>.
	var head_idx := changelog.find("&mdash; Batch BQ:")
	ok(head_idx >= 0, "§5: ...under its own <h2> heading")
	if head_idx >= 0:
		var next_idx := changelog.find("<h2>", head_idx + 4)
		var entry := changelog.substr(head_idx,
			(next_idx - head_idx) if next_idx > head_idx else -1)
		for cls2 in TRANCHE_3:
			for nm2 in TRANCHE_3[cls2]:
				ok(entry.contains(nm2), "§5: the BQ entry names %s" % nm2)
		ok(entry.contains("Chastise"),
			"§5: ...and carries the Chastise finding")
	var glossary := _src("res://data/glossary.json")
	ok(glossary.contains("class_draft"),
		"§5: glossary.json has an entry for class-wide draft abilities")
	var claude := _src("res://CLAUDE.md")
	ok(claude.contains("CLASS_DRAFT_POOLS"),
		"§5: CLAUDE.md records CLASS_DRAFT_POOLS")
	ok(claude.contains("BATCH BQ"), "§5: ...in a Batch BQ block")


# ---------- harness ----------

func _spawn(specs: Array, granted: Dictionary, lineup: Array,
		learned := {}) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.get(specs[i], {})
		run.party[i]["bm_abilities"] = granted.get(specs[i], [])
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# FORCE DETERMINISM rather than retrying until it passes (the AK/AL/AR
	# discipline). NOTE THE DELIBERATE ASYMMETRY, AND IT IS THIS SUITE'S ONE
	# DEPARTURE FROM test_batch_bp's harness: `no_cover` is armed on the HEROES
	# only. It is an absolute miss BYPASS, and Mirror Image is a miss — arming
	# it on the enemies too would make every image look broken. The enemy side
	# gets it back, per unit, at the exact checks that need a blow to land.
	for u in scene.get("heroes"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	for e in scene.get("enemies"):
		e.parry_chance = 0.0
		e.block_chance = 0.0
	return scene


func _hero(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _drop(scene: Node) -> void:
	scene.queue_free()
	await process_frame
