# Batch AH verification harness. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ah.gd
# Covers all six sections of the batch: the kit trim, both pools, the
# offer composition, the mini-boss row, the Shift hotkey map, and the
# eight Perfect conversions.
extends SceneTree

var checks := 0
var fails := 0


func ok(cond: bool, label: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		print("  FAIL: %s" % label)


func _initialize() -> void:
	var RunState = load("res://scripts/run_state.gd")
	print("\n===== BATCH AH =====")
	_test_kits()
	_test_pools()
	_test_offers(RunState)
	_test_map(RunState)
	_test_hotkeys()
	_test_perfects()
	_test_doc_matches_code()
	print("\n%d checks, %d failures" % [checks, fails])
	print("====================\n")
	quit(1 if fails > 0 else 0)


# ---------- §1: every spec opens with its core attack plus exactly 3 ----------

func _test_kits() -> void:
	print("\n§1 starting kits")
	for class_key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[class_key]:
			var kit: Array = Classes.spec_abilities(spec)
			# The Summon Companion picker is ONE slot however many beasts
			# it offers — that is the batch's own counting rule, and the
			# action bar has always grouped them that way.
			var summons := 0
			var slots := 0
			for ab in kit:
				if ab.special in ["summon", "call_wild"]:
					summons += 1
				else:
					slots += 1
			if summons > 0:
				slots += 1
			# RE-POINTED IN PLACE BY BATCH AV, WITH THE REASON HERE RATHER THAN
			# IN A CHANGELOG NOBODY READS AT 3AM: the Holy Cleric opens with
			# FOUR, because Resurrection moved out of her tree and into her kit.
			# That is a DELIBERATE parity break, not an oversight — she attacks
			# at 50, so her abilities are not part of her contribution, they are
			# all of it. Every other spec is still held to three, and the
			# exception is NAMED so a second one cannot creep in beside it.
			var want: int = 4 if spec == "holy" else 3
			ok(slots == want, "%s opens with %d spec abilities (got %d)" % [
				spec, want, slots])
	# The core attack is still there and still separate from the three.
	for class_key in ["warrior", "mage", "cleric", "hunter"]:
		ok(Classes.kit(class_key).size() == 1,
			"%s core kit is one basic attack" % class_key)
	# The five trims are gone from their kits and earnable instead.
	# BATCH AK CORRECTED ONE OF THEM: Guard Change went back into the
	# Swordmaster's opening three and Shatterpoint took its place in the
	# pool. AH itself flagged the problem — Guard Change is the only stance
	# swap in the game and four of his nodes read the stance — so this is
	# the correction landing, not AH's rule weakening. The COUNT is what AH
	# was really about, and it is still five and still 3-per-kit above.
	var trims := {"Blood Price": "berserker", "War Stomp": "warden",
		"Interpose": "warden", "Sweeping Strikes": "swordmaster",
		"Shatterpoint": "swordmaster"}
	for name in trims:
		var spec: String = trims[name]
		ok(not Classes.spec_abilities(spec).any(func(a): return a.display_name == name),
			"%s left the %s kit" % [name, spec])
		ok(Classes.spec_pool(spec).has(name),
			"%s is earnable from the %s pool" % [name, spec])


# ---------- §2: both pools ----------

func _test_pools() -> void:
	print("\n§2 pools")
	ok(Classes.SPEC_POOLS.size() == 12, "SPEC_POOLS covers all 12 specs")
	# **BATCH DY §3 — `CLASS_POOLS` IS DELETED AND THIS SUITE IS ITS OLDEST
	# READER.** AH built BOTH pools and an award that drew 1 from the spec pool
	# and 2 from the class pool; AN §4 re-pointed the award at the spec pool
	# alone and deleted the roller, and DY deleted the container. The size
	# assertion is replaced by the ABSENCE assertion, in the shape
	# `test_batch_an` already uses for `roll_ability_offer` — a suite that
	# built a thing is the right place to record that it is gone.
	var csrc_dy := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(not csrc_dy.contains("const CLASS_POOLS"),
		"CLASS_POOLS is DELETED (DY §3) — AH's second pool is gone, not zeroed")
	var seen := {}
	for spec in Classes.SPEC_POOLS:
		ok(Classes.SPEC_IDS.values().any(func(v): return v.has(spec)),
			"SPEC_POOLS key %s is a real spec" % spec)
		for name in Classes.SPEC_POOLS[spec]:
			ok(Classes.spec_pool_ability(spec, name) != null,
				"spec pool %s -> %s resolves" % [spec, name])
			var key := "%s/%s" % [spec, name]
			ok(not seen.has(key), "no duplicate entry %s" % key)
			seen[key] = true
	# **THE CLASS-POOL WALK THAT STOOD HERE IS RE-POINTED, NOT DELETED (DY §3).**
	# It asserted three things of every class-pool entry — that it resolves,
	# that it resolves to its own name, and AH's CURATION RULE (no
	# spec-exclusive secondary resource). The container is gone; **the curation
	# rule is not, and it has a live subject**: `CLASS_DRAFT_POOLS`, the
	# class-wide DRAFT pool, is authored under the same rule and DY §1 just put
	# a card into it. So the walk moves one structure across rather than
	# lapsing, and the rule keeps a population to bind.
	for class_key in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.SPEC_IDS.has(class_key),
			"CLASS_DRAFT_POOLS key %s is a real class" % class_key)
		for name in Classes.CLASS_DRAFT_POOLS[class_key]:
			var ab: Ability = Classes.pool_ability(name)
			ok(ab != null, "class draft %s -> %s resolves" % [class_key, name])
			if ab == null:
				continue
			ok(ab.display_name == name, "%s resolves to its own name" % name)
			# THE CURATION RULE, asserted rather than trusted: nothing offered
			# class-wide may cost a spec-exclusive secondary resource.
			ok(ab.faith_cost == 0,
				"%s costs no Mercy/Faith (class draft %s)" % [name, class_key])
			# ...nor be one of the named signature identity pieces.
			ok(ab.special != "summon" and ab.special != "call_wild"
				and ab.special != "kill_command",
				"%s is not a Beastmaster signature (class pool)" % name)
			ok(name != "Hex of Ruin", "Hex of Ruin stays Occultist-only")
			# ...nor be gated on a resource only its own spec generates.
			ok(not ab.special in ["stabilize", "overcharge", "wildfire", "bestial",
				"spirit_bond", "primal_surge"],
				"%s is not gated on a spec passive (class pool)" % name)
	# class_of_spec is the join between the two pools.
	for class_key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[class_key]:
			ok(Classes.class_of_spec(spec) == class_key,
				"class_of_spec(%s) == %s" % [spec, class_key])
	ok(Classes.class_of_spec("") == "", "class_of_spec('') is empty, not a crash")
	# DY §3: `class_pool()` went with `CLASS_POOLS`. The tolerant-lookup claim
	# this asserted is kept, over the accessor that is still live.
	ok(Classes.class_draft_pool("nonsense").is_empty(),
		"an unknown class has no class-wide draft pool")
	# A pool copy must be the SAME ability the kit or the talent hands out.
	var pool_hs: Ability = Classes.pool_ability("Hack and Slash")
	var kit_hs: Ability = null
	for a in Classes.spec_abilities("berserker"):
		if a.display_name == "Hack and Slash":
			kit_hs = a
	ok(pool_hs != null and kit_hs != null
		and pool_hs.cost == kit_hs.cost and pool_hs.damage == kit_hs.damage
		and pool_hs.multi_hits == kit_hs.multi_hits,
		"the pool's Hack and Slash is the kit's Hack and Slash")
	# BATCH DO RE-POINTED THIS AND THE QUESTION IS UNCHANGED: is there ONE copy
	# of Battle Shout, or two that can drift? AH asserted the pool copy equals
	# the TALENT'S copy, because the definition lived in `bz_battle_shout`'s
	# payload. DO moved that definition into `Classes.draft_ability` — a talent
	# may not grant an ability — so the single source is the DRAFT card, and
	# `Talents.granted_ability` correctly returns null for it now.
	var pool_bs: Ability = Classes.pool_ability("Battle Shout")
	var draft_bs: Ability = Classes.draft_ability("Battle Shout")
	ok(pool_bs != null and draft_bs != null and pool_bs.cost == draft_bs.cost
		and pool_bs.cooldown == draft_bs.cooldown
		and pool_bs.description == draft_bs.description,
		"the pool's Battle Shout is the DRAFT card's Battle Shout — one copy")
	ok(Talents.granted_ability("Battle Shout") == null,
		"...and no talent hands out a second one (DO's charter)")


# ---------- §3: offer composition ----------

func _test_offers(RunState) -> void:
	print("\n§3 offers")
	var run = RunState.new()
	for class_key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[class_key]:
			var spec_pool: Array = Classes.spec_pool(spec)
			# BATCH AN §4 RE-POINTED THIS IN PLACE. AH offered 1 spec + 2
			# class; abilities are SPEC-LOCKED now, so every entry must come
			# from the spec pool and the class pool is not consulted at all.
			# **DY §3 DELETED THE CLASS POOL OUTRIGHT**, so the unused local
			# that held it is gone too — a variable read by nothing is the dead
			# symbol `test_batch_cd`'s own sweep exists to catch.
			# The question the check asks is unchanged — "is the offer drawn
			# from the pool the design says it is" — so it rides the
			# mechanism that is load-bearing today rather than being deleted.
			# The size assertion loosened with it: spec pools are 2-5 deep,
			# and an offer of three is impossible out of a pool of two.
			for trial in 40:
				var m := {"key": class_key, "spec": spec, "bm_abilities": [],
					"tree": [], "talents": {}}
				var offer: Array = run.roll_spec_ability_offer(m)
				ok(not offer.is_empty(), "%s is offered something" % spec)
				ok(offer.size() == mini(3, spec_pool.size()),
					"%s is offered min(3, pool) = %d (got %d)" % [
						spec, mini(3, spec_pool.size()), offer.size()])
				for n in offer:
					ok(spec_pool.has(n),
						"%s draws only from its SPEC pool (got %s)" % [spec, n])
					# DY §3: this read `class_pool`, a local off the deleted
					# `CLASS_POOLS`. The claim — an offer never carries a name
					# only a SIBLING can reach — is derived off the siblings'
					# own pools now, which is what it always meant.
					var sib_only := false
					for sib in Classes.SPEC_IDS[class_key]:
						if String(sib) != spec and not spec_pool.has(n) \
								and Classes.spec_pool(String(sib)).has(n):
							sib_only = true
					ok(not sib_only,
						"%s: nothing arrives from a sibling spec alone" % spec)
				ok(offer.size() == _unique(offer).size(),
					"%s offer holds no duplicate" % spec)
			# Batch AN: TWO awards over a run, not six — the mini-boss pays
			# an upgrade now, so only the two zone bosses pay abilities.
			# Nothing is ever re-offered, and the offer SHRINKS as the pool
			# empties rather than repeating or crashing.
			var m2 := {"key": class_key, "spec": spec, "bm_abilities": [],
				"tree": [], "talents": {}}
			for award in 2:
				var offer2: Array = run.roll_spec_ability_offer(m2)
				if offer2.is_empty():
					ok(m2["bm_abilities"].size() >= spec_pool.size(),
						"%s only runs dry once its pool is spent" % spec)
					break
				ok(offer2.size() <= 3, "%s award %d offers at most 3" % [
					spec, award + 1])
				for n in offer2:
					ok(not m2["bm_abilities"].has(n),
						"%s is never re-offered to %s" % [n, spec])
				m2["bm_abilities"] = m2["bm_abilities"] + [offer2[0]]
			# award_ability_pick stores the triple it rolled.
			var m3 := {"key": class_key, "spec": spec, "bm_abilities": [],
				"tree": [], "talents": {}}
			ok(run.award_ability_pick(m3), "%s can be awarded a pick" % spec)
			ok(int(m3.get("bm_picks_owed", 0)) == 1, "%s owes one pick" % spec)
			ok((m3.get("bm_candidates", []) as Array).size() == 1,
				"%s banked the triple it was shown" % spec)
	# CROSS-FILL IS GONE WITH THE CLASS DRAW (Batch AN §4). A hero holding its
	# whole spec pool is offered NOTHING by the BOSS pool — that half is
	# unchanged and is still asserted first.
	#
	# **INVERTED IN PLACE BY BATCH EA §1, AND THE INVERSION IS THE WHOLE POINT
	# OF THAT SECTION.** The next two lines used to read "award_ability_pick
	# refuses when there is nothing to offer" and "...and owes no pick", which
	# was true and was the DEFECT: `battle._award_ability_picks` then skipped
	# that hero without a word, so a zone boss died and the victory card did
	# not name them. DZ §1 measured the cost — eight of the twelve specs can
	# empty their boss pool and **14 of the game's 36 zone-boss awards could
	# pay nothing.** The award falls back to the hero's own spec DRAFT pool
	# now, so it PAYS and the hero is named. **The refusal arm is kept rather
	# than deleted** — it moved to the one condition that still reaches it.
	var mm := {"key": "warrior", "spec": "berserker", "tree": [], "talents": {},
		"bm_abilities": Classes.spec_pool("berserker").duplicate()}
	var cross: Array = run.roll_spec_ability_offer(mm)
	ok(cross.is_empty(), "an exhausted spec pool offers nothing (got %s)" % [cross])
	var fb: Array = run.roll_spec_fallback_offer(mm)
	ok(fb.size() == 3,
		"...and the fallback still fills a full triple (got %d: %s)" % [fb.size(), fb])
	for n in fb:
		ok(Classes.spec_draft_pool("berserker").has(n),
			"the fallback draws from the SPEC DRAFT pool (got %s)" % n)
		ok(not mm["bm_abilities"].has(n),
			"...and never offers %s, which the hero already holds" % n)
	ok(run.award_ability_pick(mm),
		"award_ability_pick PAYS when the boss pool is exhausted")
	ok(int(mm.get("bm_picks_owed", 0)) == 1,
		"...and owes exactly one pick, which is what puts the hero on the victory card")
	# THE REFUSAL ARM, ON THE ONE CONDITION THAT STILL REACHES IT. Both rolls
	# return `[]` with no spec set, so this is the arm that proves the award
	# still HAS a false path — without it the assertion above could pass on an
	# award that can never refuse anything.
	var nospec := {"key": "warrior", "spec": "", "tree": [], "talents": {},
		"bm_abilities": []}
	ok(not run.award_ability_pick(nospec),
		"award_ability_pick still refuses when the member has no spec")
	ok(int(nospec.get("bm_picks_owed", 0)) == 0, "...and owes no pick")
	run.free()


func _unique(arr: Array) -> Array:
	var out: Array = []
	for v in arr:
		if not out.has(v):
			out.append(v)
	return out


# ---------- §4: the mini-boss row ----------

func _test_map(RunState) -> void:
	print("\n§4 the mini-boss")
	var run = RunState.new()
	# BATCH AN REPLACED THE BOARD THIS SECTION PINNED, AND BATCH BK REPLACED
	# AN'S. A zone is a generated 16-slot lattice again, so "a zone is 12
	# slots" and "it is the authored ZONE_SHAPE" are false by design and the
	# checks that asserted them are DELETED rather than re-pointed at whatever
	# the code now does. test_batch_bk owns the generation invariants.
	# WHAT SURVIVES IS THE QUESTION THAT STILL HAS MEANING, and it is the one
	# this section was written to ask: every zone puts exactly ONE mini-boss in
	# it, and the player cannot reach the boss without passing it. On a
	# lattice that is a REACHABILITY claim again rather than a fact about an
	# authored array, so it is walked rather than counted.
	for trial in 60:
		run.new_run()
		ok(run.map.size() == run.SLOTS_PER_ZONE,
			"a zone is %d slots" % run.SLOTS_PER_ZONE)
		var counts := {}
		var mb_at := -1
		for s in run.map.size():
			for node in run.map[s]:
				var ty := String(node["type"])
				counts[ty] = int(counts.get(ty, 0)) + 1
				if ty == "miniboss":
					mb_at = s
		ok(int(counts.get("miniboss", 0)) == 1, "exactly one mini-boss per zone")
		ok(mb_at == run.MINI_SLOT, "the mini-boss sits at slot 8 (index 7), always")
		ok(int(counts.get("boss", 0)) == 1, "one boss, and it is the last slot")
		ok(String(run.map[run.BOSS_SLOT][0]["type"]) == "boss",
			"the boss is the last slot")
		ok(int(counts.get("rest", 0)) == 0, "no rest slots exist any more")
		# UNAVOIDABLE, WALKED. Every route from every entry node passes through
		# slot 7 — on a lattice this is the mini-boss converge, and it is worth
		# asserting rather than assuming because the whole entry guarantee in
		# test_batch_bk rests on it.
		for j in run.map[0].size():
			var reach: Dictionary = run.reachable_from(0, j)
			ok(reach.has("%d,0" % run.MINI_SLOT),
				"entry node %d cannot reach the boss without the mini-boss" % j)
			ok(reach.has("%d,0" % run.BOSS_SLOT),
				"...and it does reach the boss")
	# Every zone is a DIFFERENT map now, which is the batch's whole premise —
	# the old check asserted the opposite and had to go with the line.
	run.new_run()
	var first: Array = []
	for s in run.map.size():
		for node2 in run.map[s]:
			first.append(String(node2["type"]))
	run.advance_zone()
	var second: Array = []
	for s in run.map.size():
		for node3 in run.map[s]:
			second.append(String(node3["type"]))
	ok(first.size() > 0 and second.size() > 0, "both zones generated something")
	# A walk always terminates on the boss and never before it.
	run.new_run()
	var steps := 0
	while true:
		var reach2: Array = run.reachable()
		if reach2.is_empty():
			break
		run.advance(int(reach2[0]))
		steps += 1
	ok(steps == run.SLOTS_PER_ZONE, "a walk is exactly %d steps (%d)" % [
		run.SLOTS_PER_ZONE, steps])
	ok(run.slot_idx == run.BOSS_SLOT, "...and it ends on the boss")
	ok(run.reachable().is_empty(), "nothing follows the boss")
	# Rewards: elite-tier gold, and its own ability pick.
	run.new_run()
	run.party[0]["spec"] = "berserker"
	# RE-POINTED IN PLACE BY BATCH CD, AND IT IS AN INVERSION. This asserted
	# that a mini-boss paid 1 in-run talent point into `member["talent_points"]`
	# — Batch AI's schedule. BATCH BM §6 DELETED BOTH the award and the member
	# purse, so the call has been throwing `Invalid call ... award_talent_points`
	# ever since, ABORTING THE REST OF `_test_map` while the suite printed a
	# clean count. That is the BC trap, and it is what Batch CD exists to close:
	# the gold checks and the 120-check compose loop below this line had not run
	# since BM. THE QUESTION IS STILL WORTH ASKING — what does a mini-boss pay?
	# — and only the answer moved: gold and an upgrade pick, and NO talent point
	# from any node, because a RUN awards none at all. Points are META now and a
	# ZONE BOSS banks them to Profile through one door; that door is gated,
	# driven and negative-controlled in test_run_harness's gate 2, which is why
	# it is asserted PRESENT here rather than driven a second time.
	ok(not run.has_method("award_talent_points"),
		"BM deleted the in-run award — a mini-boss pays no talent point")
	ok(not run.party[0].has("talent_points"),
		"...and no member carries an in-run purse for it to pay into")
	ok(run.has_method("bank_zone_boss_points"),
		"...the live door is the ZONE BOSS's, and it banks to Profile")
	var gold_before: int = run.gold
	var paid: int = run.award_gold("miniboss")
	ok(paid >= 80 and paid <= 130, "the mini-boss pays elite gold (%d)" % paid)
	ok(run.gold > gold_before, "...into the purse")
	# It composes as an elite: an elite theme, at the elite budget floor.
	for trial3 in 60:
		var band: Array = run.compose("miniboss", 8)
		ok(not band.is_empty(), "the mini-boss composes a warband")
		ok(THEME_IS_ELITE(run.last_theme), "...from an elite theme (%s)" % run.last_theme)
	run.free()


func THEME_IS_ELITE(theme_name: String) -> bool:
	var Run_ = load("res://scripts/run_state.gd")
	var themes: Dictionary = Run_.THEMES
	return themes.has(theme_name) and (themes[theme_name]["nodes"] as Array).has("elite")


# _every_route_crosses() is DELETED. It walked `run.map[f][i]["links"]` over
# `run.FLOORS` — a board Batch AN removed and Batch BK did not bring back (the
# lattice's edges are `next`, indices rather than links, and there is no
# FLOORS). The question it asked is answered above by reachable_from, at the
# site, against the map the game actually generates.


# ---------- §5: hotkeys ----------

func _test_hotkeys() -> void:
	print("\n§5 hotkeys")
	var battle = load("res://scripts/battle.gd").new()
	ok(battle.ABILITY_KEYS.size() == 9, "nine plain ability hotkeys")
	ok(battle.ABILITY_KEY_NAMES.size() == battle.ABILITY_KEYS.size(),
		"a name for every key")
	ok(battle._hotkey_name(0) == "Q", "slot 1 is Q")
	ok(battle._hotkey_name(8) == "G", "slot 9 is G")
	# The batch's worked example: ability 10 = Shift+Q, 11 = Shift+W.
	ok(battle._hotkey_name(9) == "⇧Q", "slot 10 is Shift+Q")
	ok(battle._hotkey_name(10) == "⇧W", "slot 11 is Shift+W")
	ok(battle._hotkey_name(17) == "⇧G", "slot 18 is Shift+G")
	ok(battle._hotkey_name(18) == "", "slot 19 has no key, and says so")
	ok(battle._hotkey_name(-1) == "", "a slotless entry has no key")
	battle.free()


# ---------- §6: the Perfect conversions ----------

func _test_perfects() -> void:
	print("\n§6 reliability perfects")
	var expected := {
		"Hack and Slash": "Bleed lands on every strike.",
		"Blizzard": "Two stacks of Chilled on every enemy.",
		"Pommel Strike": "The Stun lands even on a boss.",
		"Firestorm": "Every enemy takes an even share.",
		"Arcane Barrage": "No two bolts strike the same enemy.",
		"Triple Shot": "One arrow is a guaranteed critical.",
	}
	# INVERTED BY BATCH CP §1, NOT DELETED — SNARE TRAP AND DEADFALL LOST THEIR
	# BARS AT CN §2, so CN §3 correctly CLEARED both Perfects and FOLDED each
	# bonus into the base effect. Asserting the old strings was asserting
	# pre-CN behaviour, and it had been red since CN because CG-CO shipped
	# implement-only and nobody ran the battery.
	#
	# THE FOLD IS WHAT IS ASSERTED NOW, because that is the property worth
	# keeping: Deadfall's "fourth spring" is not gone, it is UNCONDITIONAL
	# (`DEADFALL_CHARGES + 1` at the cast site), so a later batch that quietly
	# took the fourth spring away would trip here rather than looking like CN.
	var folded := ["Snare Trap", "Deadfall"]
	for name in folded:
		var fab := _find_anywhere(name)
		ok(fab != null, "%s still exists" % name)
		if fab == null:
			continue
		ok(not fab.runs_skill_check(),
			"%s runs NO check after CN §2" % name)
		ok(fab.perfect_text == "" and fab.perfect_id == "",
			"...so its Perfect is CLEARED rather than advertising a dead bonus (%s)"
				% name)
	for name in expected:
		var ab := _find_anywhere(name)
		ok(ab != null, "%s still exists" % name)
		if ab == null:
			continue
		ok(ab.perfect_text == expected[name],
			"%s reads '%s' (got '%s')" % [name, expected[name], ab.perfect_text])
		# The old magnitude bonus is GONE, not merely re-worded.
		ok(ab.perfect_id == "", "%s carries no magnitude perfect_id" % name)
		if ab.multi_hits > 0 or ab.random_hits > 0:
			ok(not ab.perfect_extra_hit, "%s gains no extra hit on a perfect" % name)
	# BATCH CP §1 — THIS CHECK HAD STOPPED ASKING ITS QUESTION AND WAS PASSING
	# FOR THE WRONG REASON, which is the harder of the two faults to see. It
	# read `not deadfall.no_skill_check` — the EXPLICIT OPT-OUT FLAG — and that
	# flag is still false, so it went on printing a pass while CN's parameteric
	# criterion had already taken Deadfall's bar away.
	#
	# BATCH CQ §5 — AND NOW THERE IS NOTHING LEFT TO READ WRONGLY. The flag is
	# DELETED; `runs_skill_check()` is the only answer in the codebase, so the
	# second oracle that made this check passable-while-wrong cannot be
	# consulted by anybody again. CP's flag-pin went with the flag.
	var deadfall := _find_anywhere("Deadfall")
	ok(deadfall != null and not deadfall.runs_skill_check(),
		"the PARAMETERIC criterion is what removed Deadfall's bar (CN §2)")
	# Triple Shot fires the three arrows its name and text always promised.
	var triple := _find_anywhere("Triple Shot")
	ok(triple != null and triple.multi_hits == 3, "Triple Shot fires three arrows")
	# Wildstrikes was converted in Batch AG and is left alone.
	var wild := _find_anywhere("Wildstrikes")
	ok(wild != null and wild.perfect_text == "Bleed lands on every target",
		"Wildstrikes keeps its Batch AG wording")
	# The boss-immunity escape exists and is opt-in.
	var src := FileAccess.open("res://scripts/battle.gd", FileAccess.READ).get_as_text()
	ok(src.contains("src: BattleUnit = null, force := false"),
		"_apply_status takes an explicit force flag")
	ok(src.contains("if not force and id in [\"stunned\""),
		"...and the boss immunity honours it")


func _find_anywhere(name: String) -> Ability:
	for class_key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[class_key]:
			for ab in Classes.spec_abilities(spec):
				if ab.display_name == name:
					return ab
	return Classes.pool_ability(name)


# ---------- master.html §6a must match the code ----------
#
# The project's rule is that master.html is current truth. A pool table
# hand-written beside a pool constant is exactly the pair that drifts, so
# the doc is checked against the code rather than trusted.
func _test_doc_matches_code() -> void:
	print("\ndocs vs code")
	var f := FileAccess.open("res://docs/master.html", FileAccess.READ)
	if f == null:
		ok(false, "docs/master.html is readable")
		return
	var doc := f.get_as_text()
	# The stamp moves with every batch that touches the doc; what this line
	# is really guarding is that the doc was touched AT ALL when the code
	# below it changed. Bump it, do not delete it.
	# BATCH CP §1 — RE-POINTED, AND THE PATTERN IS THE FINDING RATHER THAN THE
	# BUMP. This was a LITERAL stamp, so it passed for exactly one batch and had
	# to be hand-bumped forever; CJ's re-stamp turned five such checks red at
	# once and CK repaired those five while leaving these three. It asks the
	# question the comment above always said it was asking — was the doc touched
	# AT ALL — as a comparison against this suite's OWN batch code, so no bump is
	# ever owed again. (Two-letter batch codes sort lexically; a three-letter
	# code needs one more line.)
	var _stamp_at := doc.find("Last updated:")
	ok(_stamp_at >= 0, "master.html carries a Last-updated stamp")
	var _stamp := doc.substr(_stamp_at, 60)
	var _code_at := _stamp.find("(Batch ")
	var _stamped := _stamp.substr(_code_at + 7, 2) if _code_at >= 0 else ""
	ok(_stamped >= "AH",
		"...stamped no older than this suite's own batch (reads '%s')" % _stamped)
	for spec in Classes.SPEC_POOLS:
		var listed: String = ", ".join(Classes.SPEC_POOLS[spec])
		ok(doc.contains(listed),
			"§6a lists %s's spec pool verbatim (%s)" % [spec, listed])
	# **DY §3: §6a's CLASS-POOL TABLE IS GONE WITH THE DICT.** What replaces the
	# verbatim check is the assertion that the document does not still describe
	# a structure the code no longer has — the Flash Freeze trap DR recorded,
	# applied to a table instead of a comment.
	ok(not doc.contains("Class pool (earnable by all three specs)"),
		"§6a no longer prints a class-pool table for a deleted dict (DY §3)")
	# And the eight converted perfects read the same in both places.
	for spec2 in Classes.SPEC_IDS:
		for spec_id in Classes.SPEC_IDS[spec2]:
			for ab in Classes.spec_abilities(spec_id):
				if ab.perfect_text != "" and ab.display_name in ["Hack and Slash",
						"Blizzard", "Pommel Strike", "Snare Trap"]:
					ok(doc.contains(ab.display_name),
						"master.html still documents %s" % ab.display_name)
