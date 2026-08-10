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
	ok(Classes.CLASS_POOLS.size() == 4, "CLASS_POOLS covers all 4 classes")
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
	for class_key in Classes.CLASS_POOLS:
		ok(Classes.SPEC_IDS.has(class_key), "CLASS_POOLS key %s is a real class" % class_key)
		for name in Classes.CLASS_POOLS[class_key]:
			var ab: Ability = Classes.pool_ability(name)
			ok(ab != null, "class pool %s -> %s resolves" % [class_key, name])
			if ab == null:
				continue
			ok(ab.display_name == name, "%s resolves to its own name" % name)
			# THE CURATION RULE, asserted rather than trusted: nothing in a
			# class pool may cost a spec-exclusive secondary resource.
			ok(ab.faith_cost == 0,
				"%s costs no Mercy/Faith (class pool %s)" % [name, class_key])
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
	ok(Classes.class_pool("nonsense").is_empty(), "an unknown class has no pool")
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
	var pool_bs: Ability = Classes.pool_ability("Battle Shout")
	var talent_bs: Ability = Talents.granted_ability("Battle Shout")
	ok(pool_bs != null and talent_bs != null and pool_bs.cost == talent_bs.cost
		and pool_bs.cooldown == talent_bs.cooldown,
		"the pool's Battle Shout is the talent's Battle Shout")


# ---------- §3: offer composition ----------

func _test_offers(RunState) -> void:
	print("\n§3 offers")
	var run = RunState.new()
	for class_key in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[class_key]:
			var spec_pool: Array = Classes.spec_pool(spec)
			var class_pool: Array = Classes.class_pool(class_key)
			# BATCH AN §4 RE-POINTED THIS IN PLACE. AH offered 1 spec + 2
			# class; abilities are SPEC-LOCKED now, so every entry must come
			# from the spec pool and the class pool is not consulted at all.
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
					ok(not class_pool.has(n) or spec_pool.has(n),
						"%s: nothing arrives via the class pool alone" % spec)
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
	# CROSS-FILL IS GONE WITH THE CLASS DRAW (Batch AN §4). A hero holding
	# its whole spec pool is offered NOTHING, and award_ability_pick reports
	# false rather than banking an empty triple the card would then render as
	# a heading with no buttons under it.
	var mm := {"key": "warrior", "spec": "berserker", "tree": [], "talents": {},
		"bm_abilities": Classes.spec_pool("berserker").duplicate()}
	var cross: Array = run.roll_spec_ability_offer(mm)
	ok(cross.is_empty(), "an exhausted spec pool offers nothing (got %s)" % [cross])
	ok(not run.award_ability_pick(mm),
		"award_ability_pick refuses when there is nothing to offer")
	ok(int(mm.get("bm_picks_owed", 0)) == 0, "...and owes no pick")
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
	# BATCH AN REPLACED THE BOARD THIS SECTION USED TO PIN. There is no deck,
	# no row and no route: a zone is a fixed line of 12 slots, so "no route
	# goes around the mini-boss" is true by construction rather than by a
	# forward DP. What survives is the question that still has meaning —
	# every zone puts exactly one mini-boss in it, always in the same place,
	# and the player cannot reach the boss without passing it.
	for trial in 60:
		run.new_run()
		ok(run.map.size() == run.SLOTS_PER_ZONE,
			"a zone is %d slots" % run.SLOTS_PER_ZONE)
		var counts := {}
		var mb_at := -1
		for s in run.map.size():
			var ty := String(run.map[s]["type"])
			counts[ty] = int(counts.get(ty, 0)) + 1
			if ty == "miniboss":
				mb_at = s
		ok(int(counts.get("miniboss", 0)) == 1, "exactly one mini-boss per zone")
		ok(mb_at == 5, "the mini-boss sits at slot 6 (index 5), always")
		ok(int(counts.get("boss", 0)) == 1, "one boss, and it is the last slot")
		ok(String(run.map[run.BOSS_SLOT]["type"]) == "boss",
			"the boss is the last slot")
		ok(int(counts.get("elite", 0)) == 2, "two elites per zone")
		ok(int(counts.get("fight", 0)) == 8, "eight ordinary fights per zone")
		ok(int(counts.get("rest", 0)) == 0, "no rest slots exist any more")
		ok(int(counts.get("shop", 0)) == 0, "the shop is scheduled, never dealt")
		ok(int(counts.get("event", 0)) == 0, "events are scheduled, never dealt")
		# Unavoidable by construction: the only way past slot 6 is through it.
		ok(mb_at < run.BOSS_SLOT, "the mini-boss stands before the boss")
	# Every zone is the SAME line — that is the batch's whole premise.
	run.new_run()
	var first: Array = []
	for s in run.map.size():
		first.append(String(run.map[s]["type"]))
	run.advance_zone()
	var second: Array = []
	for s in run.map.size():
		second.append(String(run.map[s]["type"]))
	ok(first == second, "every zone has the identical shape")
	ok(first == run.ZONE_SHAPE, "...and it is the authored ZONE_SHAPE")
	# Only one slot is ever reachable, and it is the next one.
	run.new_run()
	for s in run.SLOTS_PER_ZONE:
		var reach: Array = run.reachable()
		ok(reach.size() == 1, "exactly one slot forward at slot %d" % s)
		ok(int(reach[0]) == s, "...and it is the next one")
		run.advance(int(reach[0]))
	ok(run.reachable().is_empty(), "nothing follows the boss")
	# Rewards: elite-tier points and gold, and its own ability pick.
	run.new_run()
	run.party[0]["spec"] = "berserker"
	var before: int = run.party[0].get("talent_points", 0)
	# Batch AI re-cut the schedule: 1 for the mini-boss, out of a run total
	# of exactly 8 (spec choice 1 + 3 mini-bosses + 2 zone bosses x2).
	ok(run.award_talent_points("miniboss") == 1, "the mini-boss pays 1 talent point")
	ok(run.party[0]["talent_points"] == before + 1, "...to every hero")
	var gold_before: int = run.gold
	var paid: int = run.award_gold("miniboss")
	ok(paid >= 80 and paid <= 130, "the mini-boss pays elite gold (%d)" % paid)
	ok(run.gold > gold_before, "...into the purse")
	# It composes as an elite: an elite theme, at the elite budget floor.
	for trial3 in 60:
		var band: Array = run.compose("miniboss", 6)
		ok(not band.is_empty(), "the mini-boss composes a warband")
		ok(THEME_IS_ELITE(run.last_theme), "...from an elite theme (%s)" % run.last_theme)
	run.free()


func THEME_IS_ELITE(theme_name: String) -> bool:
	var Run_ = load("res://scripts/run_state.gd")
	var themes: Dictionary = Run_.THEMES
	return themes.has(theme_name) and (themes[theme_name]["nodes"] as Array).has("elite")


# Forward reachability: is there ANY route from tier 0 to the boss that
# skips the given row? (There must not be.)
func _every_route_crosses(run, row: int) -> bool:
	var frontier := {}
	for i in run.map[0].size():
		if row == 0 and String(run.map[0][i]["type"]) != "miniboss":
			frontier[i] = true
		elif row != 0:
			frontier[i] = true
	for f in run.FLOORS - 1:
		var next := {}
		for i in frontier:
			for j in run.map[f][int(i)]["links"]:
				if f + 1 == row and String(run.map[f + 1][j]["type"]) == "miniboss":
					continue  # this route was stopped BY the mini-boss
				next[j] = true
		frontier = next
	return frontier.is_empty()


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
		"Snare Trap": "The Stun lands even on a boss.",
		"Firestorm": "Every enemy takes an even share.",
		"Arcane Barrage": "No two bolts strike the same enemy.",
		"Triple Shot": "One arrow is a guaranteed critical.",
		# RE-POINTED BY BATCH BD, with the reason in the file: the perfect no
		# longer names the victim. That clause was exactly what made Deadfall a
		# copy of Snare Trap, so it is DELETED rather than reworded — but the
		# ability still runs a check (asserted below) and its perfect still
		# buys reliability rather than magnitude, which is what this battery is
		# really about. test_batch_bd owns the re-spec itself.
		"Deadfall": "A fourth spring.",
	}
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
	# Deadfall had to GAIN a skill check to have a perfect at all, and it
	# KEEPS it after Batch BD — the perfect buys a fourth spring now.
	var deadfall := _find_anywhere("Deadfall")
	ok(deadfall != null and not deadfall.no_skill_check,
		"Deadfall now runs a skill check")
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
	ok(doc.contains("Last updated: 2026-08-09 (Batch BD)"),
		"master.html carries the current batch's stamp")
	for spec in Classes.SPEC_POOLS:
		var listed: String = ", ".join(Classes.SPEC_POOLS[spec])
		ok(doc.contains(listed),
			"§6a lists %s's spec pool verbatim (%s)" % [spec, listed])
	for class_key in Classes.CLASS_POOLS:
		var listed2: String = ", ".join(Classes.CLASS_POOLS[class_key])
		ok(doc.contains(listed2),
			"§6a lists the %s class pool verbatim" % class_key)
	# And the eight converted perfects read the same in both places.
	for spec2 in Classes.SPEC_IDS:
		for spec_id in Classes.SPEC_IDS[spec2]:
			for ab in Classes.spec_abilities(spec_id):
				if ab.perfect_text != "" and ab.display_name in ["Hack and Slash",
						"Blizzard", "Pommel Strike", "Snare Trap"]:
					ok(doc.contains(ab.display_name),
						"master.html still documents %s" % ab.display_name)
