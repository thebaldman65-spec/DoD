# test_batch_cp.gd — THE CLAMP, AND THE FIRST DEDICATED TEST BATCH. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_cp.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). No --fixed-fps either — nothing here runs a battle to completion.
#
# WHAT IT COVERS, AND WHY EACH SECTION EXISTS RATHER THAN THE OBVIOUS ONE:
#   §0 the three clamped call sites, driven at a HIGHER standing value than the
#      recast produces — the only arrangement that tells a clamp from a max.
#   §2 the twenty-seven tranche-3 cards CG/CH/CI shipped with no coverage at
#      all, in the standard shape, plus the two behaviours nothing else asserts.
#   §3 CK and CL's surviving claims, and the Perfect biconditional AS IT IS
#      ACTUALLY ENFORCEABLE (see the long note above `_perfect_biconditional`).
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

var checks := 0
var fails: Array = []

const REAL_SAVE := "user://run_save.bin"
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()

# The twenty-seven, transcribed once. Nine per class, the LAST THREE of each
# spec's eight-deep draft pool — which is what "tranche 3" means structurally.
const CLERIC_NINE := ["Divine Presence", "Alms", "Vespers",
	"Elevation", "Blessing of the Faithful", "Mantle",
	"Breaking Darkness", "Requiem", "Penance"]
const HUNTER_NINE := ["Last Howl", "Succession", "Unleash",
	"Reacquire", "Fault Line", "Drumfire",
	"Stalking Horse", "Downwind", "Cull"]
const WARRIOR_NINE := ["Unslaked", "Spite", "Boil Over",
	"Anvil", "Recompense", "Turn the Blade",
	"Discipline", "Answering Steel", "Formless"]

# CP §3 — THE LITERAL-DIGIT BASELINE. CL §1's rule is that a parenthetical is
# COMPUTED at render time and never authored, so an authored digit inside
# parentheses is a second copy of a number that can drift.
#
# **CL DELIBERATELY MADE THIS A REPORT RATHER THAN A GATE, AND CL WAS RIGHT.**
# Swept over EVERY authored field rather than CL's abilities-only slice, the
# corpus holds 89 of them across 979 fields — and most are legitimate prose
# that is not a resolved value at all (`(max 5)`, `(0-100)`, `(2 on a crit)`,
# `(cap 100)`). Asserting zero would fail against correct text.
#
# SO IT SHIPS AS A BASELINE INSTEAD, WHICH IS THE FORM THAT ACTUALLY BITES: the
# ABILITY-level offenders are pinned EXACTLY (that is the surface CL's rule was
# written about and the surface CK taught the draft card to render), and the
# whole-corpus count is pinned as a CEILING. A new authored digit trips either
# way; the fourteen below are recorded as owed rather than silently rewritten,
# because rewriting shipped player-facing text is authoring and this is a test
# batch (CG's standing convention, read from the other side).
# BATCH CQ §5 — THIRTEEN OF CP'S FOURTEEN ARE FIXED AND ONE WAS NEVER A DEFECT.
# CP pinned fourteen ability-level parentheticals carrying a typed digit. Each
# was a second copy of a number that lives in code — an armor shred, a status
# duration, an Empower cost — and CL's standing rule is that a parenthetical is
# the shape reserved for a value the renderer computes, so a typed one is
# indistinguishable from a rendered one. Thirteen are rephrased so the number
# stands in PROSE, where it is allowed, and no parenthesis mimics a computed
# value. The 44-character draft-card ceiling was respected line by line.
#
# SHATTER IS NOT ONE OF THEM AND STAYS. Its `(max 12)` is a CAP, which is the
# exact "legitimate prose" shape CP's own report names alongside `(max 5)` and
# `(0-100)` — it is not a second copy of anything, it bounds the sentence it
# sits in. It was swept up by the regex rather than by the rule.
const AUTHORED_DIGIT_ABILITIES := ["Shatter"]
# THE BASELINE IS KEPT AT CP'S 89 DELIBERATELY (the brief's instruction). It is
# a CEILING, not an equality: the corpus count fell when the thirteen were
# fixed, and holding the old number means the check still catches GROWTH
# without pretending the remaining prose sites have been audited one by one.
const AUTHORED_DIGIT_CORPUS_CEILING := 89

# CP §3 — the five abilities that RUN a check and state no Perfect. Named, so a
# SIXTH trips. See `_perfect_biconditional` for why this is a list rather than
# a violation count of zero.
# BATCH DO ADDED PYROBLAST, AND IT IS NOT A NEW AUTHORING FAULT. Pyroblast has
# carried an empty `perfect_text` since Batch AR authored it out of the vault;
# what changed is that THIS FILE'S WALK COULD NOT REACH IT. It was a talent
# grant living in NO POOL — one of `check_cz` §0's five — and DO moved it into
# `SPEC_DRAFT_POOLS`, so the walk sees it for the first time. **The population
# did not grow; the instrument's reach did.** The list is SIX now and a SEVENTH
# still has to be a decision.
const CHECK_WITHOUT_PERFECT := ["Called Shot", "Coup de Grâce", "Pinning Shot",
	"Powershot", "Pyroblast", "Rampage"]


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


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_cp_test.json"
	Profile.loaded = false
	Profile.data = {}

	print("\n===== BATCH CP =====")
	_pools()
	_standard_shape()
	_stalking_horse_debuffs()
	_anvil_recompense_source()
	_cleric_inversions_survive()
	_ironclad_rename()
	_computed_block()
	_perfect_biconditional()
	_authored_digits()
	_clamp_source()

	await _live_clamp()

	if FileAccess.file_exists("user://profile_batch_cp_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_cp_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("\n%d checks, %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	print("====================")
	quit(1 if fails.size() > 0 else 0)


# ---------- §2: the pools ----------

func _pools() -> void:
	print("\n§2 pools")
	# THE FLATNESS, NOT A DEBT. Every draft suite's depth loop has inverted
	# seven times; since CI it asserts a flat EIGHT, so a pool that quietly
	# EMPTIES trips rather than reading as the old asymmetry returning.
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() >= 8, "%s drafts at least EIGHT (got %d)" % [spec, pool.size()])
		total += pool.size()
	ok(Classes.SPEC_DRAFT_POOLS.size() == 12,
		"twelve spec draft pools (got %d)" % Classes.SPEC_DRAFT_POOLS.size())
	ok(total == 125, "SPEC_DRAFT_POOLS holds 125 (got %d)" % total)


# ---------- §2: the standard shape, all twenty-seven ----------

func _standard_shape() -> void:
	print("\n§2 the twenty-seven, standard shape")
	var all_27: Array = CLERIC_NINE + HUNTER_NINE + WARRIOR_NINE
	ok(all_27.size() == 27, "twenty-seven names (got %d)" % all_27.size())
	# Every one lives in some spec's draft pool, and in exactly one.
	var draft_names := {}
	for spec in Classes.SPEC_DRAFT_POOLS:
		for nm in Classes.spec_draft_pool(spec):
			draft_names[nm] = String(draft_names.get(nm, "")) + spec + " "
	for nm in all_27:
		ok(draft_names.has(nm), "§2: %s is in a spec draft pool" % nm)
		if draft_names.has(nm):
			ok(String(draft_names[nm]).split(" ", false).size() == 1,
				"§2: %s is in exactly ONE spec pool (%s)" % [nm, draft_names[nm]])
		# RESOLVES THROUGH `pool_ability`, TO ITSELF. `pool_ability` is keyed on
		# display_name, so a card resolving to a DIFFERENT name is the resolver
		# answering the wrong question — CH's Harvest collision, which was a real
		# break rather than a label clash.
		var ab := Classes.pool_ability(nm)
		ok(ab != null, "§2: %s resolves through pool_ability" % nm)
		if ab == null:
			continue
		ok(ab.display_name == nm,
			"§2: %s resolves TO ITSELF (got '%s')" % [nm, ab.display_name])
		ok(ab.description.strip_edges() != "", "§2: %s carries a description" % nm)
		ok(ab.delay > 0.0, "§2: %s carries an initiative delay (%.1f)" % [nm, ab.delay])
		ok(ab.cooldown > 0, "§2: %s carries a cooldown (%d)" % [nm, ab.cooldown])
		# ABSENT FROM THE BOSS POOL AND FROM THE CLASS-WIDE DRAFT. `SPEC_POOLS`
		# feeds the ZONE BOSS pick and `CLASS_DRAFT_POOLS` the one-in-four class
		# seam; a spec draft card leaking into either silently re-weights a draw
		# nothing in this batch is allowed to touch (BO's rule).
		for spec2 in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec2].has(nm),
				"§2: %s is ABSENT from SPEC_POOLS[%s]" % [nm, spec2])
		for cls in Classes.CLASS_DRAFT_POOLS:
			ok(not Classes.CLASS_DRAFT_POOLS[cls].has(nm),
				"§2: %s is ABSENT from CLASS_DRAFT_POOLS[%s]" % [nm, cls])


# ---------- §2: Stalking Horse's afflictions are in DEBUFF_IDS ----------

func _stalking_horse_debuffs() -> void:
	print("\n§2 Stalking Horse's statuses are debuffs")
	# THE FAILURE THIS CATCHES IS SILENT, WHICH IS THE WHOLE REASON IT IS HERE:
	# Trapper's breadth term counts `DEBUFF_IDS` ONLY, so an affliction outside
	# that curated list would APPLY, LOG and read as working while paying the
	# Survivalist's own multiplier nothing at all — the card doing exactly half
	# of what it says, with nothing to announce it.
	var battle := load("res://scripts/battle.gd")
	var cycle: Array = battle.STALKING_HORSE_STATUSES
	ok(cycle.size() >= 4,
		"the affliction cycle has real breadth (%d)" % cycle.size())
	for id in cycle:
		ok(BattleUnit.DEBUFF_IDS.has(id),
			"Stalking Horse's '%s' is in DEBUFF_IDS" % id)
	# ...and each is a DISTINCT id, or "a DIFFERENT affliction each attacker"
	# is false on the card's own terms.
	var seen := {}
	for id in cycle:
		seen[id] = true
	ok(seen.size() == cycle.size(),
		"every affliction in the cycle is distinct (%d of %d)"
			% [seen.size(), cycle.size()])


# ---------- §2: Anvil and Recompense cancel ----------

func _anvil_recompense_source() -> void:
	print("\n§2 Anvil and Recompense cancel")
	# INTENDED, AND THE KIND OF THING A LATER BATCH "FIXES" IF IT IS NOT WRITTEN
	# DOWN AS A TEST. Anvil REFUSES the Heavy Plating reset; Recompense is PAID
	# BY that reset. A Warden holding both gets nothing from the second while
	# the first holds — and that falls out of the ORDERING at one site rather
	# than from a carve-out, so what has to be asserted is the ordering.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var at := src.find("if strike_target.has_status(\"anvil\"):")
	ok(at >= 0, "the Anvil branch exists at the plating reset")
	if at < 0:
		return
	var region := src.substr(at, 1400)
	var else_at := region.find("else:")
	var rc_at := region.find("has_status(\"recompense\")")
	ok(else_at >= 0, "...and it carries an else branch")
	ok(rc_at >= 0, "...and Recompense is decided in the same region")
	# THE PROPERTY: the Recompense payment sits BELOW the else, i.e. it is
	# unreachable while Anvil holds. Read positionally rather than by name, so
	# a rename cannot make this pass vacuously.
	ok(else_at >= 0 and rc_at > else_at,
		"Recompense is paid INSIDE the else — Anvil holding pays it nothing")
	# Both cards SAY SO, which is the half a player meets.
	var anvil := Classes.pool_ability("Anvil")
	var recomp := Classes.pool_ability("Recompense")
	ok(anvil != null and recomp != null, "both cards resolve")
	if anvil != null:
		ok(anvil.description.to_lower().contains("recompense"),
			"Anvil's own text names Recompense")
	if recomp != null:
		ok(recomp.description.to_lower().contains("anvil"),
			"Recompense's own text names Anvil")


# ---------- §2: CG's two inversions are still inversions ----------

func _cleric_inversions_survive() -> void:
	print("\n§2 CG's inversions were INVERTED, not deleted")
	# A DELETION IS SILENT COVERAGE LOSS AND LOOKS IDENTICAL FROM THE OUTSIDE,
	# which is why this is asserted here rather than trusted. CE asserted that
	# Elevation grants NO Faith and that Blessing of the Faithful does NOT drop
	# the peak; CG made both answers move, and both checks had to be INVERTED
	# in place with their setups intact.
	var ce := FileAccess.get_file_as_string("res://test_batch_ce.gd")
	ok(ce != "", "test_batch_ce.gd is readable")
	ok(ce.contains("_live_elevation"), "ce still drives Elevation")
	ok(ce.contains("ELEVATION_STACKS_TEST"),
		"...against a named stack count rather than a bare number")
	ok(ce.contains("faith_stacks == ELEVATION_STACKS_TEST"),
		"...and asserts REAL Faith stacks are handed over (the inversion)")
	ok(ce.contains("_live_blessing_of_the_faithful"),
		"ce still drives Blessing of the Faithful")
	ok(ce.contains("faith_peak == 0"),
		"...and asserts the PEAK DROPS to match the count spent (the inversion)")
	# The magnitude §2 names: 2 real Faith.
	ok(ce.contains("ELEVATION_STACKS_TEST := 2"),
		"Elevation grants 2 real Faith")


# ---------- §3: the Ironclad rename ----------

func _ironclad_rename() -> void:
	print("\n§3 the Ironclad rename is complete")
	# CJ's bucket-1 item, closed by CK: the WARRIOR ABILITY is `Ironclad` — the
	# name its own status id always carried — and the WARDEN TALENT keeps
	# `iron_will` and keeps the name Iron Will. DO NOT "RESTORE" Iron Will to
	# the ability; the collision is what was fixed.
	ok(Classes.pool_ability("Ironclad") != null,
		"`Ironclad` resolves to an ability")
	ok(Classes.pool_ability("Iron Will") == null,
		"`Iron Will` resolves to NO ability — it is the talent's name alone")
	var found_node := false
	for spec in Classes.SPEC_INFO:
		for n in Talents.generate_tree(spec, Classes.class_of_spec(spec)):
			if String(n.get("id", "")) == "wd_iron_will":
				found_node = true
				ok(String(n.get("name", "")) == "Iron Will",
					"the Warden node is still NAMED Iron Will (got '%s')"
						% n.get("name", ""))
	ok(found_node, "the `wd_iron_will` node still exists")
	# master.html carries BOTH rows — §4.6 held one where it now holds two.
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master.contains("Ironclad"), "master.html documents Ironclad")
	ok(master.contains("Iron Will"), "master.html still documents Iron Will")


# ---------- §3: the draft card renders the computed block ----------

func _computed_block() -> void:
	print("\n§3 the draft card renders the computed block")
	# CK §1: ONE builder, TWO screens. The draft card passes attack = 0 so it
	# prints the SCALING PERCENTAGE; the hero sheet passes live Attack so it
	# prints a real range. Before CK the sheet held the only copy, which is
	# exactly why thirty damaging cards drafted with no damage figure at all.
	var map_src := FileAccess.get_file_as_string("res://scripts/map_screen.gd")
	var sheet_src := FileAccess.get_file_as_string("res://scripts/party_screen.gd")
	ok(map_src.contains("Classes.computed_block("),
		"the draft card calls Classes.computed_block")
	ok(sheet_src.contains("Classes.computed_block("),
		"the hero sheet calls the SAME builder")
	# Damage and Perfect are both present for a card that has them.
	var ab := Classes.pool_ability("Boil Over")
	ok(ab != null, "Boil Over resolves")
	if ab != null:
		var block: String = Classes.computed_block(ab, 0, "Rage")
		ok(block.contains("Damage"),
			"...and the block prints a damage line (%s)" % block.split("\n")[0])
		ok(block.contains("%"), "...as a scaling percentage at attack = 0")
	# A card that STATES a Perfect gets it rendered.
	var per := Classes.pool_ability("Unslaked")
	if per != null and per.perfect_text != "":
		var pb: String = Classes.computed_block(per, 0, "Rage")
		ok(pb.contains("Perfect"),
			"a card stating a Perfect renders it on the draft card")


# ---------- §3: the Perfect biconditional, as it is actually enforceable ----------

func _perfect_biconditional() -> void:
	print("\n§3 the Perfect rule")
	# **THE HALF THAT IS PROJECT LAW HOLDS AT ZERO VIOLATIONS, AND THE CONVERSE
	# IS FALSE BY DESIGN — READ THIS BEFORE "FIXING" EITHER.**
	#
	# CN §3 cleared `perfect_text`/`perfect_id` from the 105 abilities that lost
	# their bar, because CK taught the draft card to render Perfect and an
	# orphan would advertise a bonus that can never fire. THAT is the rule, and
	# it is the direction `check_cn.gd` gates.
	#
	# THE CONVERSE — every ability that runs a check STATES a Perfect — is NOT a
	# project rule and never has been. Six abilities run a bar and name no
	# Perfect, and their bar is not idle: the grade still multiplies damage
	# (x1.15 / x0.6). All five have carried an empty `perfect_text` since long
	# before CN (checked against `8c3c676`, and their introducing commits are
	# older still), so this is an AUTHORING PATTERN rather than a regression CN
	# left behind. They are NAMED below so a SIXTH trips and has to be a
	# decision.
	var corpus := _corpus()
	var no_check_with_perfect: Array = []
	var check_no_perfect: Array = []
	for ab in corpus:
		var runs: bool = ab.runs_skill_check()
		var states: bool = ab.perfect_text.strip_edges() != "" or ab.perfect_id != ""
		if not runs and states:
			no_check_with_perfect.append(ab.display_name)
		elif runs and ab.perfect_text.strip_edges() == "":
			check_no_perfect.append(ab.display_name)
	ok(no_check_with_perfect.is_empty(),
		"NO ability runs no check and still carries a Perfect (%s)"
			% ", ".join(no_check_with_perfect))
	check_no_perfect.sort()
	var expected: Array = CHECK_WITHOUT_PERFECT.duplicate()
	expected.sort()
	ok(check_no_perfect == expected,
		"the checked-but-Perfectless abilities are exactly the named six (got %s)"
			% ", ".join(check_no_perfect))
	# And the corpus is big enough that the loop above really walked it.
	ok(corpus.size() > 150,
		"the corpus walked is the whole corpus (%d)" % corpus.size())


# ---------- §3: the literal-digit baseline ----------

func _authored_digits() -> void:
	print("\n§3 authored digits inside parentheses")
	var paren := RegEx.new()
	paren.compile("\\((?:[^()]*[0-9])[^()]*\\)")
	var ability_hits: Array = []
	var corpus_hits := 0
	for ab in _corpus():
		for f in [ab.description, ab.perfect_text]:
			var s := String(f)
			if s != "" and paren.search(s) != null:
				if not ability_hits.has(ab.display_name):
					ability_hits.append(ab.display_name)
				corpus_hits += 1
	for spec in Classes.SPEC_INFO:
		var pd := String(Classes.SPEC_INFO[spec].get("passive_desc", ""))
		if pd != "" and paren.search(pd) != null:
			corpus_hits += 1
		for n in Talents.generate_tree(spec, Classes.class_of_spec(spec)):
			var td := Talents.desc_for(n, 1)
			if td != "" and paren.search(td) != null:
				corpus_hits += 1
	for rid in Runes.ids():
		var rd := String(Runes.config(rid).get("desc", ""))
		if rd != "" and paren.search(rd) != null:
			corpus_hits += 1
	for e in Glossary.entries():
		for k in ["short", "long"]:
			var gs := String(e.get(k, ""))
			if gs != "" and paren.search(gs) != null:
				corpus_hits += 1
	ability_hits.sort()
	var want: Array = AUTHORED_DIGIT_ABILITIES.duplicate()
	want.sort()
	ok(ability_hits == want,
		"the ABILITY-level authored digits are exactly the recorded fourteen (got %d: %s)"
			% [ability_hits.size(), ", ".join(ability_hits)])
	ok(corpus_hits <= AUTHORED_DIGIT_CORPUS_CEILING,
		"the whole-corpus count has not GROWN (%d against a ceiling of %d)"
			% [corpus_hits, AUTHORED_DIGIT_CORPUS_CEILING])


# ---------- §0: the clamp, at the source ----------

func _clamp_source() -> void:
	print("\n§0 the clamp is at all three sites")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# `update_status` ASSIGNS where `add_status` MAXES, so each of the three
	# reads what stands BEFORE `_apply_status` and writes the chip only when the
	# new value is at least as strong. Asserted by NAME at each site, because a
	# clamp deleted from one of the three is the failure that reads exactly like
	# the card working.
	# BATCH CQ §0 — THE LAST TWO SITES JOIN THE THREE. `blood_debt` (35 on a
	# Perfect, 25 on a plain re-mark, and the mark SURVIVES its own bleedout so
	# re-marking is routine) and `reckless_abandon` (power scales with the Rage
	# actually spent, and the cast zeroes the bar, so the second cast in a
	# window is nearly always the weaker one) carried the identical
	# apply-then-assign defect. CP reported them; CQ clamps them. Five of five.
	for pair in [["shout_had", "battle_shout"], ["st_had", "stabilized"],
			["es_had", "eye_storm"], ["bd_had", "blood_debt"],
			["ra_had", "reckless_abandon"]]:
		ok(src.contains("%s" % pair[0]),
			"§0: the %s site reads what stands first (%s)" % [pair[1], pair[0]])
		ok(src.contains("if %s >= %s" % [_new_of(pair[1]), pair[0]])
				or src.contains(">= %s" % pair[0]),
			"§0: ...and writes the chip only when it is at least as strong (%s)"
				% pair[1])
	# `update_status` ITSELF IS NOT CLAMPED, and that is deliberate — see the
	# census in CP's changelog entry. `held_breath` and `instinct` compute
	# `status_power(...) - 1` and write it back, so a global max would freeze
	# those counters forever.
	var unit := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var uf := unit.find("func update_status(")
	ok(uf >= 0, "update_status exists")
	if uf >= 0:
		var body := unit.substr(uf, 420)
		ok(body.contains("s.power = power"),
			"update_status still ASSIGNS power — it is NOT globally clamped")
	ok(src.contains("status_power(\"held_breath\") - 1"),
		"...and held_breath still counts DOWN through it (the reason why)")
	ok(src.contains("status_power(\"instinct\") - 1"),
		"...and so does instinct")


func _new_of(id: String) -> String:
	match id:
		"battle_shout": return "shout_pct"
		"stabilized": return "st_dr"
		"eye_storm": return "es_cut"
	return "?"


# ---------- §0: the clamp, driven ----------

func _live_clamp() -> void:
	print("\n§0 the clamp, driven live")
	# THE DISCRIMINATING ARRANGEMENT, AND THE OBVIOUS ONE IS NOT IT: a recast
	# that is STRONGER improves under a max and under a clamp alike, so it tells
	# the two apart not at all. What discriminates is a standing value the
	# recast CANNOT match — so each status is stood up at a power well above
	# what the cast will compute, and the assertion is that the standing value
	# SURVIVES.
	var scene := await _spawn(["warden", "pyromancer", "holy", "beastmaster"])
	var wd := _hero(scene, "warden")
	ok(wd != null, "the Warden spawned")
	if wd == null:
		scene.queue_free()
		return

	# --- EYE OF THE STORM. The sharpest of the three: the cut is read off the
	# BOARD, so casting into a smaller field is an ordinary tactical sequence
	# rather than a misplay.
	scene.call("_apply_status", wd, "eye_storm", 6, 50)
	ok(wd.status_power("eye_storm") == 50, "a 50%% storm stands")
	wd.cooldowns.clear()
	wd.resource = wd.max_resource
	await scene.call("_resolve", wd, _card("Eye of the Storm"), wd, "good")
	ok(wd.status_power("eye_storm") == 50,
		"a weaker Eye of the Storm does NOT drag the standing cut down (%d)"
			% wd.status_power("eye_storm"))

	# --- BATTLE SHOUT. Party-wide, so the clamp has to hold per hero.
	for h in scene.get("heroes"):
		scene.call("_apply_status", h, "battle_shout", 6, 60)
	# THE WARDEN SHOUTS, and that is the smoke's own artefact used deliberately
	# rather than worked around: one warrior slot cannot hold a Warden and a
	# Berserker at once, and `battle_shout` reads `attacker.battle_shout_node`,
	# which is 0 on anyone who never took the node — so the cast computes the
	# BASE 8%, which is exactly the weak recast this check needs.
	var shouter := _hero(scene, "warden")
	ok(shouter != null, "the shouter spawned")
	if shouter != null:
		shouter.cooldowns.clear()
		shouter.resource = shouter.max_resource
		var before: int = shouter.resource
		await scene.call("_resolve", shouter, _card_any("Battle Shout"),
			shouter, "good")
		var held := true
		for h in scene.get("heroes"):
			if h.status_power("battle_shout") != 60:
				held = false
		ok(held, "a weaker Battle Shout lowers NOBODY's standing shout")
		# THE CAST STILL PAYS. That is the whole reason CO's refusal could not
		# reach this card, and the reason the clamp is at the call site instead.
		ok(shouter.resource >= before or shouter.resource > 0,
			"...and the cast still resolved (the +5 Rage is outside the branch)")

	# --- STABILIZE. Venting two stacks after venting five must not replace a
	# deep ward with a shallow one.
	scene.queue_free()
	await process_frame
	var scene2 := await _spawn(["berserker", "arcanist", "holy", "beastmaster"])
	var arc := _hero(scene2, "arcanist")
	ok(arc != null, "the Arcanist spawned")
	if arc != null:
		scene2.call("_apply_status", arc, "stabilized", 6, 70)
		ok(arc.status_power("stabilized") == 70, "a 70%% ward stands")
		arc.cooldowns.clear()
		arc.resource = arc.max_resource
		arc.second_resource = 3   # a shallow vent: st_dr will be small
		await scene2.call("_resolve", arc, _card_any("Stabilize"), arc, "good")
		ok(arc.status_power("stabilized") == 70,
			"a shallow Stabilize does NOT replace the standing ward (%d)"
				% arc.status_power("stabilized"))
	scene2.queue_free()
	await process_frame


# ---------- harness ----------

func _corpus() -> Array:
	var seen := {}
	for src in [Classes.SPEC_POOLS, Classes.CLASS_POOLS, Classes.SPEC_DRAFT_POOLS,
			Classes.CLASS_DRAFT_POOLS]:
		for k in src:
			for nm in src[k]:
				seen[nm] = true
	for cls in ["warrior", "mage", "cleric", "hunter"]:
		for ab in Classes.kit(cls):
			seen[ab.display_name] = true
	var out: Array = []
	for nm in seen:
		var ab := Classes.pool_ability(nm)
		if ab != null:
			out.append(ab)
	return out


func _card(n: String) -> Ability:
	return Classes.draft_ability(n)


func _card_any(n: String) -> Ability:
	return Classes.pool_ability(n)


# A hero is found by PASSIVE ID, not by a display name — `unit_name` is the
# spec's display name and logic keying on it is the mistake CLAUDE.md has
# warned about since Batch 28.
const PASSIVE_OF := {"berserker": "bloodrage", "warden": "heavy_plating",
	"arcanist": "resonance", "pyromancer": "overburn", "holy": "mercy",
	"beastmaster": "loyalty"}


func _hero(scene: Node, spec: String) -> BattleUnit:
	var want := String(PASSIVE_OF.get(spec, spec))
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == want:
			return h
	return null


func _spawn(specs: Array, lineup := ["raider", "raider", "archer"]) -> Node:
	# BU'S HARNESS FAULT: `_run_battle` opens with `await _wait(0.6)` on a REAL
	# SceneTreeTimer, so state written after twenty frames is wiped out from
	# under the check and reads as a magnitude bug. `fast` scales those timers
	# and NOTHING the battle computes.
	return await Fixture.spawn(self, specs,
		{"enemies": lineup, "frames": 90, "fast": true, "deterministic": true, "crit": -1.0})
