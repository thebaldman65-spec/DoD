# test_batch_bu.gd — TRANCHE 2, THE CLERIC NINE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bu.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability by hand.
#
# WHAT IT PROTECTS. §6 names eight clauses that could silently do nothing or the
# wrong thing; EVERY ONE IS BUILT SO A BROKEN IMPLEMENTATION STILL FAILS, which
# for most of them means the obvious assertion is not the one that discriminates:
#
# · RECANT restores the PRIMARY resource. "He gained resource" is trivially true
#   of a version that also refilled the spec meter, so every cast asserts the
#   SECOND meter is UNCHANGED in the same breath — driven on an Arcanist
#   (Resonance) and on Holy (Mercy), i.e. the two heroes for whom getting it
#   wrong would matter most, and on a Rage, a Mana and a Focus hero for the
#   three resource types.
# · SHARED GRIEF pays EXACTLY 3. The discriminating construction is the health
#   she is on when she casts: she starts ABOVE half so the cost carries her
#   across the Mercy window, and a version routed through `take_hit` would fire
#   the below-half generator and pay FOUR. It is then driven again at 1 health,
#   where a max-health cost must still leave her alive.
# · REPRISAL reads healing LANDED. "It did damage" is trivially true, so the
#   ledger is driven with a heal into a FULL bar (which must book NOTHING) and
#   a heal into a wounded one (which must book what closed), and the two-turn
#   window is aged out and re-read.
# · ORDINATION finds the LOWEST holder. "An ally gained Faith" is trivially true
#   of any target, so three allies are set to three DIFFERENT depths and the
#   floor is asserted by name. The negative control that matters — an Apostle
#   party producing no release loop — is asserted at the property that makes the
#   loop impossible rather than by watching for one: a release resets an ally to
#   ZERO, Apostle or no.
# · FORTIFIED SPIRIT decays and CLAMPS. "The maximum went up" is trivially true,
#   so the ally is TOPPED UP before the ticks (an ally at half never feels the
#   clamp, so a version missing it would pass) and the maximum is asserted back
#   at its true value after the last step. The victory sync is then driven with
#   ALL THREE of the fields that meet there live AT ONCE and at deliberately
#   different magnitudes, so a sign error cannot hide inside a cancellation.
# · RELIQUARY reads PEAK. The discriminating construction is an ally RELEASED
#   DOWN TO ZERO: a version reading the live count pays them nothing.
# · SUFFERING heals OUTSIDE the 40% lifesteal cap. "He healed" is trivially true,
#   so the enemy is given a deep Ruin pile first — the state in which the capped
#   door would bind — and the heal is asserted against the damage with open
#   ground between 100% and 40%.
# · TRANSFERENCE moves EVERY stack and detonates NOTHING. "The stacks moved" is
#   trivially true, so the two piles are chosen to SUM TO A MULTIPLE OF THE
#   THRESHOLD — the one arrangement in which a move routed through `_gain_ruin`
#   would arm the primer — and the primer is asserted ABSENT.
# · ANOINTING counts HITS. "It applied Ruin" is trivially true of a per-cast
#   implementation, so a three-hit ability and a single-strike ability are
#   driven in the SAME check and the counts asserted as an exact identity
#   (BR's Aimed Volley construction).
#
# HARNESS NOTE: several checks compare one blow against one blow, and the first
# line of the strike block is `randf_range(0.9, 1.1)`. `crit_bonus = -1.0` at
# spawn kills the crit roll (BQ) and `_seeded()` before a pair makes both draw
# the same variance (BS). Forced determinism, never a retry.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on.
const RUIN_LEECH_CAP_TEST := 0.40
const RUIN_THRESHOLD_TEST := 10
const RELIQUARY_PCT_TEST := 0.025

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# The machine-checkable half of "the batch shipped what it said".
const NINE := {
	"Recant":           ["holy", 25, 2.0, 4, 0],
	"Shared Grief":     ["holy", 20, 2.0, 4, 0],
	"Reprisal":         ["holy", 25, 2.5, 3, 6],
	"Ordination":       ["inquisitor", 25, 2.0, 4, 0],
	"Fortified Spirit": ["inquisitor", 25, 2.0, 4, 0],
	"Reliquary":        ["inquisitor", 30, 2.5, 5, 0],
	"Suffering":        ["occultist", 25, 2.5, 4, 8],
	"Transference":     ["occultist", 20, 2.0, 3, 0],
	"Anointing":        ["occultist", 30, 2.5, 5, 0],
}


func _initialize() -> void:
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
	Profile.save_path = "user://profile_batch_bu_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pools()
	_definitions()
	_synergy_rule()
	_names()
	_status_registry()
	_no_new_unit_fields()
	_source_rules()
	_docs()
	await _live_recant()
	await _live_shared_grief()
	await _live_reprisal()
	await _live_ordination()
	await _live_fortified_spirit()
	await _live_reliquary()
	await _live_suffering()
	await _live_transference()
	await _live_anointing()
	await _live_gates()

	if FileAccess.file_exists("user://profile_batch_bu_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bu_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BU: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- the pools ----------

func _pools() -> void:
	# THE CLERIC THREE JOIN THE MAGE AT FIVE; THE HUNTER AND WARRIOR SIX DO NOT
	# MOVE. A batch that widens three pools is exactly where a fourth gets
	# widened by accident.
	# RE-POINTED BY BATCH CB, AN INVERSION: the three MAGE pools this suite was
	# written beside went to EIGHT when tranche 3's first third landed, so the
	# CLERIC three it shipped are no longer level with them. BU's own five are
	# still the first five of each Cleric pool, because a later tranche APPENDS.
	# RE-POINTED BY BATCH CE, AND IT IS THE FIFTH INVERSION OF THIS LOOP. It has
	# asserted, in order: each earlier tranche's own asymmetry, then the FLATNESS
	# tranche 2 achieved, then CB's new asymmetry, and now that asymmetry HALVED
	# — the CLERIC three joined the Mage three at EIGHT when tranche 3's second
	# third landed, so six pools are eight deep and six are five. The question is
	# unchanged and is still what tells the two answers apart; what is owed now
	# is the HUNTER and WARRIOR thirds, and it has to stay visible in code.
	var five := ["holy", "inquisitor", "occultist"]
	for spec in five:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 8, "%s drafts EIGHT since Batch CE (got %d)" % [spec, pool.size()])
	for spec in ["pyromancer", "cryomancer", "arcanist"]:
		ok(Classes.spec_draft_pool(spec).size() == 8,
			"%s drafts EIGHT since Batch CB (got %d)"
				% [spec, Classes.spec_draft_pool(spec).size()])
	# RE-POINTED BY BATCH BV, which paid the HUNTER third: those three joined the
	# Mage and Cleric at five, so ONLY THE WARRIOR THREE are still at two. Kept
	# as an inversion rather than deleted — what matters is that the LAST unpaid
	# third stays visible in code rather than only in prose.
	for spec in ["beastmaster", "sharpshooter", "mystic"]:
		ok(Classes.spec_draft_pool(spec).size() == 8,
			"%s drafts EIGHT since Batch CH — the Hunter is the third class complete" % spec)
	# RE-POINTED BY BATCH BW, AND IT IS AN INVERSION: this asserted the WARRIOR
	# three were still at TWO because that debt was real and had to stay visible
	# in code. BW paid it, so tranche 2 is complete and what is asserted is that
	# ALL TWELVE are five. A pool quietly emptying still trips.
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
		ok(Classes.spec_draft_pool(spec).size() == 8,
			"%s joined them at FIVE in Batch BW — tranche 2 is complete" % spec)
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 96, "the spec pools hold 96 (60 + tranche 3's 36: CB, CE, CH and CI), got %d" % total)
	# TRANCHE 1's ENTRIES ARE STILL THE FIRST TWO OF EACH CLERIC POOL. A later
	# tranche APPENDS; it does not rewrite. Pinned as literals because a swap of
	# two names would keep every count and change what the draft offers.
	ok(Classes.spec_draft_pool("holy")[0] == "Second Wind"
		and Classes.spec_draft_pool("holy")[1] == "Rite of Return",
		"Holy's tranche-1 pair still leads her pool")
	ok(Classes.spec_draft_pool("inquisitor")[0] == "Vow of Suffering"
		and Classes.spec_draft_pool("inquisitor")[1] == "Aegis Reversal",
		"the Devout's tranche-1 pair still leads his pool")
	ok(Classes.spec_draft_pool("occultist")[0] == "Blight the Well"
		and Classes.spec_draft_pool("occultist")[1] == "Covenant of Ash",
		"the Occultist's tranche-1 pair still leads his pool")
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR negative control.
	for cls in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls).size() == 6,
			"%s's class pool is still SIX" % cls)
		for n in NINE:
			ok(not Classes.class_draft_pool(cls).has(n),
				"%s is a SPEC card and is not in %s's class pool" % [n, cls])
	# CLASS_POOLS FEEDS THE BOSS PICK and must not move either (BO's rule).
	ok(Classes.CLASS_POOLS["cleric"].size() > 0,
		"CLASS_POOLS['cleric'] is byte-untouched and non-empty")
	for n in NINE:
		for cls in Classes.CLASS_POOLS:
			ok(not Classes.CLASS_POOLS[cls].has(n),
				"%s did not leak into the BOSS pool %s" % [n, cls])
		for spec in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec].has(n),
				"%s did not leak into the boss SPEC pool %s" % [n, spec])


func _definitions() -> void:
	for n in NINE:
		var spec: String = NINE[n][0]
		ok(Classes.spec_draft_pool(spec).has(n),
			"%s is in the %s draft pool" % [n, spec])
		var ab: Ability = Classes.draft_ability(n)
		ok(ab != null, "%s has a definition" % n)
		if ab == null:
			continue
		ok(ab.cost == NINE[n][1], "%s costs %d (got %d)" % [n, NINE[n][1], ab.cost])
		ok(is_equal_approx(ab.delay, NINE[n][2]),
			"%s arrives at %s (got %s)" % [n, NINE[n][2], ab.delay])
		ok(ab.cooldown == NINE[n][3],
			"%s cools %d (got %d)" % [n, NINE[n][3], ab.cooldown])
		# BREAK DAMAGE ASSIGNED DELIBERATELY, NOT BY OMISSION — the BO/BP/BQ/BR
		# rule. The two that strike carry it; the seven that land no blow carry
		# none, because Break from an ability that never hits is Break from
		# nowhere.
		ok(ab.pressure == NINE[n][4],
			"%s carries %d Break (got %d)" % [n, NINE[n][4], ab.pressure])
		ok(ab.description != "", "%s has a description" % n)
		# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
		# perfect. As of CN that is false by design: 113 of the 211 abilities run no
		# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
		# draft card cannot advertise a bonus nothing can fire. The durable question
		# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
		# — which is strictly stronger than what was here and cannot rot as the
		# criterion catches more cards.
		ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
			"...and states a perfect exactly when it runs a check (%s)" % n)
		ok(ab.special != "", "%s resolves through a special" % n)
		# And it RESOLVES through the one door every earned ability uses, or a
		# drafted card would land in `bm_abilities` and never spawn.
		ok(Classes.pool_ability(n) != null,
			"%s resolves through pool_ability" % n)
	# THE TWO ALLY-FACING CARDS SAY SO IN THE DEFINITION, which is what puts
	# them in the ALLY branch of both the player's picker and the bot's pool.
	for n in ["Recant", "Fortified Spirit"]:
		ok(Classes.draft_ability(n).target == Ability.Target.ALLY,
			"%s targets an ALLY" % n)
	for n in ["Reprisal", "Suffering", "Transference"]:
		ok(Classes.draft_ability(n).target == Ability.Target.ENEMY,
			"%s names an enemy" % n)
	# REPRISAL'S DAMAGE IS NOT A PERCENT OF ATTACK and must not be given one:
	# the whole card is that its size comes off her healing.
	ok(Classes.draft_ability("Reprisal").damage == 0,
		"Reprisal carries no Attack-percentage damage — its size is her healing")
	ok(Classes.draft_ability("Suffering").damage == 20,
		"Suffering strikes for 20% of Attack")
	# THE CARD SAYS THE HIT RULE OUTRIGHT, because a player will assume per cast.
	ok(Classes.draft_ability("Anointing").description.to_lower().contains("hit"),
		"Anointing's own text states that it counts HITS")
	ok(Classes.draft_ability("Recant").description.contains("Resonance"),
		"Recant's text names a spec meter it does NOT reach")
	ok(Classes.draft_ability("Reliquary").description.contains("PEAK"),
		"Reliquary's text says it reads the PEAK")


func _synergy_rule() -> void:
	# BT §1's STANDING RULE, MADE MECHANICAL AND CARRIED FORWARD: from tranche 2
	# on, every ability NAMES what it builds with. A card nobody plans around is
	# a card that fills a slot, and the cheapest way for that to creep back is
	# for the next author to skip the line.
	var src := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var at_block := src.find("BATCH BU: TRANCHE 2, THE CLERIC NINE")
	ok(at_block > 0, "the BU block is anchored in classes.gd")
	if at_block <= 0:
		return
	var block := src.substr(at_block)
	for n in NINE:
		var at := block.find('"%s":' % n)
		ok(at > 0, "%s sits inside the BU block" % n)
		if at <= 0:
			continue
		# The 2600 characters above the entry are its comment.
		var lead := block.substr(maxi(at - 2600, 0), mini(at, 2600))
		ok(lead.contains("SYNERGY:"), "%s names what it combos with" % n)
		ok(lead.contains("AXIS:"), "%s names its axis" % n)


func _names() -> void:
	# BR §1's SWEEP, RUN AS A TEST. An ABILITY-vs-ABILITY duplicate is a REAL
	# BREAK — `pool_ability` is keyed on `display_name`, so two abilities sharing
	# one make the resolver answer the wrong question.
	var seen: Dictionary = {}
	var pools: Array = []
	for spec in Classes.SPEC_DRAFT_POOLS:
		pools.append_array(Classes.spec_draft_pool(spec))
	for cls in Classes.CLASS_DRAFT_POOLS:
		pools.append_array(Classes.class_draft_pool(cls))
	for spec in Classes.SPEC_POOLS:
		pools.append_array(Classes.SPEC_POOLS[spec])
	for cls in Classes.CLASS_POOLS:
		pools.append_array(Classes.CLASS_POOLS[cls])
	for n in pools:
		seen[n] = int(seen.get(n, 0)) + 1
	for n in NINE:
		# It may appear in exactly one pool — its own.
		ok(int(seen.get(n, 0)) == 1,
			"%s appears in exactly ONE pool (got %d)" % [n, int(seen.get(n, 0))])
	# AND THE SWEEP THAT MATTERS: no OTHER ability in the game already carries
	# one of these names. Every kit, pool, vault and talent grant is walked.
	for spec in Classes.SPEC_IDS:
		for ab in Classes.spec_abilities(spec):
			ok(not (ab.display_name in NINE)
				or Classes.spec_draft_pool(spec).has(ab.display_name),
				"%s is not also an opening-kit ability" % ab.display_name)
	# SUFFERING vs VOW OF SUFFERING — REPORTED, NOT RESOLVED, and the closest
	# adjacency the draft has. One name is a strict SUBSTRING of the other, both
	# are draft cards, and both belong to the CLERIC class (the Occultist's and
	# the Devout's). NOTHING BREAKS: `pool_ability` is keyed on the whole
	# `display_name` and the two strings differ, so both resolve to themselves —
	# which is exactly what this pair of checks pins. Renaming either is the
	# designer's call and one string.
	ok(Classes.pool_ability("Suffering") != null
		and Classes.pool_ability("Suffering").display_name == "Suffering",
		"Suffering resolves to ITSELF, not to Vow of Suffering")
	ok(Classes.pool_ability("Vow of Suffering") != null
		and Classes.pool_ability("Vow of Suffering").special == "vow_suffering",
		"Vow of Suffering still resolves to itself")
	ok(Classes.draft_ability("Suffering").special == "suffering"
		and Classes.draft_ability("Vow of Suffering").special != "suffering",
		"the two Sufferings share no `special`")


func _status_registry() -> void:
	# SUFFERING IS A GENUINE DEBUFF AND IS LISTED AS ONE. Leaving it out would
	# have been the worse error rather than the safer one: `_dispellable_buffs`
	# is DERIVED (anything not a debuff is a candidate), so an unlisted
	# affliction on an enemy is something a Mage's Dispel would strip FOR the
	# enemy — `ruin_primed`'s trap through a new door.
	ok(BattleUnit.DEBUFF_IDS.has("suffering"),
		"`suffering` is a debuff, so a mender can cleanse it and a Dispel cannot"
			+ " mistake it for a boon")
	# THE TWO BUFFS ARE NOT, AND MUST NOT BE. Both are laid on his own party;
	# listing either would let an ally's own Dispel strip it.
	ok(not BattleUnit.DEBUFF_IDS.has("anointed"),
		"`anointed` is a BUFF and is not in DEBUFF_IDS")
	ok(not BattleUnit.DEBUFF_IDS.has("fortified"),
		"`fortified` is a BUFF and is not in DEBUFF_IDS")


func _no_new_unit_fields() -> void:
	# BQ's STANDARD, HELD: everything with a duration is a STATUS, which expires
	# by itself and cannot leak past a battle. THE ONE EXCEPTION IS THE LEDGER —
	# `heal_by_turn` is a bounded dictionary, not a duration, and it is the
	# mirror of the `dmg_by_turn` Second Wind already rides.
	var u := BattleUnit.new()
	ok(u.get("heal_by_turn") != null, "the healing ledger exists")
	ok(u.heal_by_turn.is_empty(), "a fresh unit has healed nothing")
	ok(u.healing_done_recent() == 0, "and reads zero")
	ok(u.has_method("set_ruin_stacks"), "the Ruin pile has a MOVE door")
	ok(u.has_method("expire_fortified_spirit"), "the loan has a forced expiry")
	u.free()


func _source_rules() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var unit_src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	# COMMENTS ARE STRIPPED FIRST (BS's rule): this batch's own comments name
	# the things it forbids on purpose, and a bare `contains` would fail against
	# working code and invite a later author to "fix" it by deleting the line
	# that explains the decision.
	var code := _strip_comments(src)
	var unit_code := _strip_comments(unit_src)
	# THE VICTORY SYNC UNWINDS THE LOAN AND DOES NOT GAIN A FOURTH FIELD. The
	# three signs are counted rather than described, so a fourth would trip.
	var at_sync := unit_code.find("func sync_victory_state")
	ok(at_sync > 0, "the victory sync is one implementation")
	var sync_body := unit_code.substr(at_sync, 700)
	ok(sync_body.contains("expire_fortified_spirit()"),
		"the sync forces the loan to expire before it reads max_hp")
	ok(sync_body.contains("tenacity_hp_gained")
		and sync_body.contains("conviction_hp_gained")
		and sync_body.contains("rot_hp_lost"),
		"the three existing sync fields are untouched")
	ok(not sync_body.contains("fortified_hp_gained"),
		"NO FOURTH FIELD was added at the sync — the loan is unwound instead")
	# SUFFERING'S HEAL IS NOT THE RUIN LEECH. The cap constant must appear
	# exactly once as a clamp, and never inside the Suffering branch.
	var at_su := code.find('\t\t"suffering":')
	ok(at_su > 0, "the Suffering branch is anchored at its own match case")
	var su_body := code.substr(at_su, 2000)
	ok(su_body.begins_with('\t\t"suffering":'),
		"the slice starts AT the match case, not at the STATUS_INFO entry")
	ok(not su_body.contains("RUIN_LEECH_CAP"),
		"Suffering's heal does NOT go through the 40% lifesteal door")
	ok(su_body.contains("heal_amount(su_final)"),
		"Suffering heals off the damage THIS cast dealt")
	# TRANSFERENCE MOVES, IT DOES NOT GAIN.
	var at_tf := code.find('\t\t"transference":')
	ok(at_tf > 0, "the Transference branch is anchored at its own match case")
	var tf_body := code.substr(at_tf, 2000)
	ok(tf_body.contains("set_ruin_stacks"),
		"Transference relocates through the MOVE door")
	ok(not tf_body.contains("_gain_ruin("),
		"Transference never calls _gain_ruin — a move must not arm the threshold")
	# SUFFERING'S DRIP DOES, WHICH IS THE OPPOSITE RULE AND THE OPPOSITE DOOR.
	var at_tick := code.find("func _suffering_tick")
	ok(at_tick > 0, "the drip is its own function (the _run_battle rule)")
	ok(code.substr(at_tick, 500).contains("_gain_ruin("),
		"the drip GAINS stacks, so they arm the threshold like any other")
	# RECANT NEVER TOUCHES THE SECOND METER.
	var at_rc := code.find('\t\t"recant":')
	ok(at_rc > 0, "the Recant branch is anchored at its own match case")
	# BATCH CQ §3 — THE COMMENT WAS TRIPPING THE CHECK ON ITS OWN CARD. This
	# read the raw branch text for `second_resource`, and the branch OPENS with
	# a comment explaining that it deliberately never touches `second_resource`
	# — so the check failed on the very sentence promising what it asserts.
	# Not a fold consequence: BU shipped both, and the battery has not been
	# green here since. It asks the question of CODE now, with comments dropped.
	# The window is the BRANCH, found by walking to the next case label, rather
	# than a byte count that can overrun into a neighbour that legitimately
	# does touch the spec meter. Comment lines are dropped so the branch's own
	# explanation of the rule cannot be mistaken for a breach of it.
	var rc_code := ""
	var rc_started := false
	for rc_line in code.split("\n"):
		if rc_line == "\t\t\"recant\":":
			rc_started = true
			continue
		if not rc_started:
			continue
		if rc_line.begins_with("\t\t\"") and rc_line.ends_with("\":"):
			break
		if not rc_line.strip_edges().begins_with("#"):
			rc_code += rc_line + "\n"
	ok(rc_code != "" and not rc_code.contains("second_resource"),
		"Recant never writes a spec meter")
	# ANOINTING'S HOOK IS INSIDE THE HIT LOOP, beside Arcane Arrows'.
	var at_hook := code.find('has_status("anointed")')
	ok(at_hook > 0, "the anointing hook exists")
	var at_arrows := code.find("_arcane_arrow_splash(attacker")
	ok(at_arrows > 0 and at_hook > at_arrows and at_hook - at_arrows < 600,
		"it sits beside the splash, i.e. INSIDE the per-hit loop (BR §1)")


func _strip_comments(src: String) -> String:
	var out: Array = []
	for line in src.split("\n"):
		var t := String(line).strip_edges()
		if t.begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


func _docs() -> void:
	var master := FileAccess.get_file_as_string("res://docs/master.html")
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
	ok(stamped >= "BU",
		"...and master.html is stamped no older than this suite's own batch (reads '%s')" % stamped)
	for n in NINE:
		ok(master.contains(n), "master.html lists %s" % n)
	ok(master.contains("120 of"), "master.html states the current draft count")
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch BU — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch BU")` would have gone on PASSING against the live file,
	# because later entries name the batch in their own prose — A CHECK THAT PASSES
	# WITHOUT ITS SUBJECT BEING IN THE FILE AT ALL. That is BZ's failure in
	# test_batch_bb and CD's in test_batch_bo, repaired here before it could bite.
	#
	# CD's pattern: anchor on the `<h2>` HEADING, and read the archive's path out of
	# the LIVE changelog's own header rather than hardcoding it, so the NEXT cut
	# moves this with it. See test_batch_bn for the full reasoning and the one
	# consequence — this suite now depends on a file that is NOT IN VERSION CONTROL
	# and FAILS LOUDLY without it, which is correct.
	var live_log := FileAccess.get_file_as_string("res://docs/changelog.html")
	var arch_mark := live_log.find("/changelog-archive.html</code>")
	ok(arch_mark > 0, "the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var chlog := FileAccess.get_file_as_string(arch_path)
	ok(chlog.length() > 100000,
		"the archive opens at %s (%d chars)" % [arch_path, chlog.length()])
	ok(not live_log.contains("<h2>2026-08-14 &mdash; Batch BU"),
		"CX moved this batch's entry OUT of the live changelog")
	ok(chlog.contains("<h2>2026-08-14 &mdash; Batch BU"),
		"...and the archive carries the Batch BU entry")


# ---------- live harness ----------

func _spawn(spec: String, lineup: Array, learned := {}) -> Node:
	# `_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL SceneTreeTimer, and
	# its opening block runs `_reset_faith_meters()` — which zeroes every Faith
	# count AND peak. A check that set Faith after twenty frames and then awaited
	# a cast would have its values wiped out from under it and read as a
	# magnitude bug (BA's negative-control lesson, arriving through a new door).
	# `fast` scales those timers and NOTHING the battle computes.
	return await Fixture.spawn(self, ["berserker", "arcanist", spec, "sharpshooter"],
		{"enemies": lineup, "talents": {2: learned.duplicate()}, "frames": 90, "fast": true,
		"deterministic": true, "crit": -1.0})


func _cleric(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _hero_named(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.hero_key) == key:
			return h
	return null


func _live_foes(scene: Node) -> Array:
	return scene.get("enemies").filter(func(e): return not e.dead)


func _seeded() -> void:
	seed(20260814)


func _card(name: String) -> Ability:
	return Classes.draft_ability(name)


# ---------- §2 live: the Holy three ----------

func _live_recant() -> void:
	# §6's FIRST CLAUSE. THREE RESOURCE TYPES AND TWO SPEC METERS IN ONE CHECK:
	# "he gained resource" is trivially true of an implementation that also
	# refilled the meter, so every cast reads BOTH numbers.
	var scene := await _spawn("holy", ["raider", "raider"])
	var holy := _cleric(scene, "mercy")
	ok(holy != null, "Holy spawned")
	if holy == null:
		scene.queue_free()
		return
	var rage := _hero_named(scene, "warrior")
	var mana := _hero_named(scene, "mage")
	var focus := _hero_named(scene, "hunter")
	ok(rage != null and mana != null and focus != null, "one hero of each resource")
	# THERE ARE ONLY TWO PRIMARY RESOURCES IN THE GAME, and the brief's premise
	# that Recant "reads Rage, Mana and Focus alike" is corrected toward the
	# code here rather than glossed: `resource_name` is Rage for the Warrior and
	# Mana for the other three classes, and FOCUS IS A SECOND RESOURCE (Batch
	# AZ) — a spec meter, which is exactly what this card must not restore.
	ok(rage.resource_name == "Rage" and mana.resource_name == "Mana"
		and focus.resource_name == "Mana",
		"the primary resources are Rage and Mana only (%s/%s/%s)" % [
			rage.resource_name, mana.resource_name, focus.resource_name])
	ok(focus.second_resource_name == "Focus",
		"and the Sharpshooter's Focus is a SECOND resource, i.e. a spec meter")
	for who in [rage, mana, focus]:
		var u: BattleUnit = who
		u.resource = 0
		var meter_was: int = u.second_resource
		await scene.call("_resolve", holy, _card("Recant"), u, "good")
		# BATCH CQ §3 — FORTY PER CENT SINCE CN §3'S FOLD (was 30, perfect 40).
		var want := maxi(int(round(u.max_resource * 0.40)), 1)
		ok(u.resource == want,
			"Recant gives %s exactly 40%% of maximum %s (%d, got %d)" % [
				u.unit_name, u.resource_name, want, u.resource])
		ok(u.second_resource == meter_was,
			"and %s's spec meter is UNTOUCHED (%d -> %d)" % [
				u.unit_name, meter_was, u.second_resource])
	# THE TWO HEROES FOR WHOM GETTING IT WRONG WOULD MATTER MOST. The Arcanist's
	# Resonance is a compounding curve and Holy's Mercy is her whole economy;
	# handing either back for 25 Mana would make one card worth more than the
	# passive it feeds.
	mana.second_resource = 3
	mana.resource = 0
	await scene.call("_resolve", holy, _card("Recant"), mana, "good")
	ok(mana.second_resource == 3,
		"an Arcanist's Resonance is NOT restored (still 3, got %d)"
			% mana.second_resource)
	holy.second_resource = 2
	holy.resource = 0
	await scene.call("_resolve", holy, _card("Recant"), holy, "good")
	ok(holy.second_resource == 2,
		"and Holy cannot refill her own Mercy with it (still 2, got %d)"
			% holy.second_resource)
	ok(holy.resource > 0, "she does get her Mana back")
	# THE PERFECT IS DEEPER, NOT A DIFFERENT KIND OF THING.
	rage.resource = 0
	await scene.call("_resolve", holy, _card("Recant"), rage, "perfect")
	ok(rage.resource == maxi(int(round(rage.max_resource * 0.40)), 1),
		"a perfect Recant gives 40%% instead (got %d)" % rage.resource)
	scene.queue_free()
	await process_frame


func _live_shared_grief() -> void:
	# §6's SECOND CLAUSE, AND THE CONSTRUCTION IS THE HEALTH SHE STARTS ON.
	# Mercy is generated by a hero crossing BELOW HALF, so she is placed just
	# above the line and the cost carries her across it: a version that removed
	# the health through `take_hit` would fire that generator and pay FOUR.
	# Exactly 3 is the assertion, and it is what tells the two apart.
	var scene := await _spawn("holy", ["raider"])
	var holy := _cleric(scene, "mercy")
	if holy == null:
		scene.queue_free()
		return
	holy.second_resource = 0
	holy.hp = int(holy.max_hp * 0.60)
	var cost := maxi(int(round(holy.max_hp * 0.25)), 1)
	var hp_was: int = holy.hp
	await scene.call("_resolve", holy, _card("Shared Grief"), holy, "good")
	ok(holy.hp == hp_was - cost,
		"Shared Grief costs 25%% of MAXIMUM (%d, got %d)" % [cost, hp_was - holy.hp])
	ok(holy.hp < holy.max_hp * 0.5,
		"and the cast really did carry her across the Mercy window (%d of %d)" % [
			holy.hp, holy.max_hp])
	# BATCH CQ §3 — FOUR SINCE CN §3'S FOLD. The point of the check is that the
	# grant is EXACT and comes from the card rather than from a `take_hit`
	# refund, so the number moves and the question does not.
	ok(holy.second_resource == 4,
		"she gains EXACTLY 4 Mercy — the card's own grant, not a `take_hit` cost"
			+ " (got %d)" % holy.second_resource)
	# THE FLOOR. Driven at 1 health, where a 25%-of-maximum cost is far more
	# than she has: it must leave her alive rather than kill its own caster.
	holy.hp = 1
	holy.second_resource = 0
	await scene.call("_resolve", holy, _card("Shared Grief"), holy, "good")
	ok(holy.hp == 1, "it can never take her below 1 (got %d)" % holy.hp)
	ok(not holy.dead, "and she is not dead")
	ok(holy.second_resource == 4, "and she is still paid her 4 Mercy")
	# THE CAP IS THE METER'S, NOT THE CARD'S.
	holy.second_resource = holy.second_max
	await scene.call("_resolve", holy, _card("Shared Grief"), holy, "good")
	ok(holy.second_resource == holy.second_max,
		"a full meter is not overfilled")
	holy.second_resource = 0
	await scene.call("_resolve", holy, _card("Shared Grief"), holy, "perfect")
	ok(holy.second_resource == 4, "a perfect pays 4 (got %d)" % holy.second_resource)
	scene.queue_free()
	await process_frame


func _live_reprisal() -> void:
	# §6's THIRD CLAUSE. THE LEDGER IS DRIVEN BEFORE THE ABILITY IS, because
	# "it did damage" is trivially true and what has to be right is WHAT WENT IN.
	var scene := await _spawn("holy", ["raider", "chief"])
	var holy := _cleric(scene, "mercy")
	if holy == null:
		scene.queue_free()
		return
	var ally := _hero_named(scene, "warrior")
	holy.battle_turn = 5
	ally.battle_turn = 5
	holy.heal_by_turn.clear()
	# (a) A HEAL INTO A FULL BAR BOOKS NOTHING. This is the overheal rule, and
	# it is the half a version reading `heal_amount`'s return gets wrong: that
	# number is the heal's WORTH after multipliers, not the health it restored.
	# The heal is DRIVEN rather than the booking faked: `last_overheal` is
	# stamped by `heal_amount`, so a check that called the credit door without a
	# real heal would read a stale zero and pass against a broken implementation.
	ally.hp = ally.max_hp
	var spilled: int = ally.heal_amount(60, true)
	ok(spilled > 0 and ally.last_overheal == spilled,
		"the heal into a full bar was ALL overheal (%d of %d)"
			% [ally.last_overheal, spilled])
	scene.call("_stat_heal", holy, float(spilled), ally)
	ok(holy.healing_done_recent() == 0,
		"healing into a full bar books NOTHING (got %d)"
			% holy.healing_done_recent())
	# (b) A HEAL INTO A WOUNDED ALLY BOOKS WHAT CLOSED.
	ally.hp = ally.max_hp - 40
	var hp_before: int = ally.hp
	var worth: int = ally.heal_amount(40, true)
	var landed: int = ally.hp - hp_before
	scene.call("_stat_heal", holy, float(worth), ally)
	ok(holy.healing_done_recent() == landed and landed > 0,
		"a heal that closed %d books %d" % [landed, holy.healing_done_recent()])
	# (c) THE WINDOW IS TWO TURNS. Age the clock and the ledger empties.
	holy.battle_turn = 6
	ok(holy.healing_done_recent() == landed,
		"one turn later it still counts")
	holy.battle_turn = 7
	ok(holy.healing_done_recent() == 0,
		"two turns later it does not (got %d)" % holy.healing_done_recent())
	# (d) THE ABILITY READS IT. Seeded so the variance roll is the same one the
	# arithmetic below expects.
	holy.battle_turn = 9
	holy.heal_by_turn.clear()
	holy.heal_by_turn[9] = 200
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.hp = foe.max_hp
	var foe_was: int = foe.hp
	var pressure_was: int = foe.pressure
	_seeded()
	await scene.call("_resolve", holy, _card("Reprisal"), foe, "good")
	var dealt := foe_was - foe.hp
	ok(dealt > 0, "Reprisal struck for something (got %d)" % dealt)
	# 50% of 200 is 100, before variance, resists and armor — so it must be
	# large. A version reading the ATTEMPTED heal or a bare Attack percentage
	# could not land in this band off a 200-point ledger.
	ok(dealt >= 40, "and its size came off the 200 she healed (got %d)" % dealt)
	ok(foe.pressure > pressure_was,
		"and it carries its 6 Break (%d -> %d)" % [pressure_was, foe.pressure])
	# (e) HALF THE HEALING, DOUBLED LEDGER, DOUBLED BLOW — the identity that
	# tells a live read from a constant. Same seed, same board, twice the input.
	foe.hp = foe.max_hp
	holy.heal_by_turn.clear()
	holy.heal_by_turn[9] = 400
	foe_was = foe.hp
	_seeded()
	await scene.call("_resolve", holy, _card("Reprisal"), foe, "good")
	var dealt2 := foe_was - foe.hp
	ok(dealt2 > dealt * 1.6,
		"doubling the healing roughly doubles the blow (%d -> %d)" % [dealt, dealt2])
	scene.queue_free()
	await process_frame


# ---------- §3 live: the Devout three ----------

func _live_ordination() -> void:
	# §6's FOURTH CLAUSE. THREE DIFFERENT DEPTHS, so "an ally gained Faith" is
	# not enough to pass: the FLOOR has to be the one that moved.
	var scene := await _spawn("inquisitor", ["raider"])
	var dv := _cleric(scene, "conviction")
	ok(dv != null, "the Devout spawned")
	if dv == null:
		scene.queue_free()
		return
	var w := _hero_named(scene, "warrior")
	var m := _hero_named(scene, "mage")
	var hn := _hero_named(scene, "hunter")
	w.faith_stacks = 3
	m.faith_stacks = 1
	hn.faith_stacks = 2
	for u in [w, m, hn]:
		u.faith_peak = u.faith_stacks
	await scene.call("_resolve", dv, _card("Ordination"), dv, "good")
	# BATCH CQ §3 — AND THE FOLD CHANGED THE OUTCOME IN KIND, NOT ONLY IN
	# DEGREE. Ordination granted 3 and now grants 4, so the mage standing on 1
	# reaches FIVE — the cap — and RELEASES on the spot: the count resets to
	# zero and the PEAK keeps the five (BI §1). The floor is still what the
	# card found; the peak is what proves it, because the count no longer can.
	ok(m.faith_stacks == 0 and m.faith_peak >= 5,
		"Ordination found the FLOOR — the mage on 1 took 4, hit the cap and RELEASED (count %d, peak %d)"
			% [m.faith_stacks, m.faith_peak])
	ok(w.faith_stacks == 3 and hn.faith_stacks == 2,
		"and nobody else moved (%d/%d)" % [w.faith_stacks, hn.faith_stacks])
	# IT IS NOT PLAYER-CHOSEN: the same cast aimed at a different body still
	# finds the floor, which is what makes the rule a rule.
	m.faith_stacks = 0
	m.faith_peak = 0
	await scene.call("_resolve", dv, _card("Ordination"), w, "good")
	ok(m.faith_stacks == 4,
		"aiming it elsewhere changes nothing — it still finds the floor (got %d)"
			% m.faith_stacks)
	# THE CASTER IS EXCLUDED. His own Faith holds at five and never releases, so
	# a stack spent on him buys none of the engine this card exists to start.
	dv.faith_stacks = 0
	dv.faith_peak = 0
	w.faith_stacks = 5
	m.faith_stacks = 5
	hn.faith_stacks = 5
	await scene.call("_resolve", dv, _card("Ordination"), dv, "good")
	ok(dv.faith_stacks == 0,
		"the Devout never ordains himself (got %d)" % dv.faith_stacks)
	# THE NEGATIVE CONTROL THAT MATTERS — AN APOSTLE PARTY PRODUCES NO RELEASE
	# LOOP. It is asserted at the PROPERTY that makes the loop impossible rather
	# than by watching for one: a release resets an ALLY to ZERO, Apostle or no.
	# (The brief justified the lowest-Faith rule with an Apostle loop in which a
	# release consumed no stacks. That has not been true since BG §2 moved
	# Apostle onto the HELD half and BH §2 deleted Binding Oath's remnant —
	# corrected toward the code, and pinned here so it cannot come back.)
	dv.apostle = 1
	w.faith_stacks = 4
	w.faith_peak = 4
	scene.call("_gain_faith", w, 3, "ordination")
	ok(w.faith_stacks == 0,
		"under APOSTLE a release still resets an ally to ZERO (got %d)"
			% w.faith_stacks)
	ok(w.faith_peak == 5, "and the peak stands at 5 (got %d)" % w.faith_peak)
	scene.call("_gain_faith", w, 3, "ordination")
	ok(w.faith_stacks == 3,
		"so the next grant builds from zero rather than re-releasing (got %d)"
			% w.faith_stacks)
	scene.queue_free()
	await process_frame


func _live_fortified_spirit() -> void:
	# §6's FIFTH CLAUSE. THE ALLY IS TOPPED UP FIRST, WHICH IS THE WHOLE
	# CONSTRUCTION: an ally sitting at half never feels the clamp, so a version
	# that shrank the maximum without clamping current health would pass a
	# careless check and fail a player.
	var scene := await _spawn("inquisitor", ["raider"])
	var dv := _cleric(scene, "conviction")
	if dv == null:
		scene.queue_free()
		return
	var ally := _hero_named(scene, "warrior")
	var base_max: int = ally.max_hp
	var step := maxi(int(round(dv.max_hp * 0.10)), 1)
	ally.hp = ally.max_hp
	await scene.call("_resolve", dv, _card("Fortified Spirit"), ally, "good")
	ok(ally.max_hp == base_max + step * 3,
		"the loan is THREE steps of a tenth of his maximum (%d, got %d)" % [
			base_max + step * 3, ally.max_hp])
	ok(ally.hp > base_max,
		"and the heal fills the new room (%d over a base maximum of %d)" % [
			ally.hp, base_max])
	ok(ally.has_status("fortified"), "the chip is up")
	# THE DECAY, STEP BY STEP, WITH THE CLAMP READ EVERY TIME.
	for i in 3:
		ally.hp = ally.max_hp   # topped up, so the clamp has something to take
		var hp_was: int = ally.hp
		scene.call("_fortified_tick", ally)
		ok(ally.max_hp == base_max + step * (2 - i),
			"tick %d sheds one step (%d, got %d)" % [
				i + 1, base_max + step * (2 - i), ally.max_hp])
		ok(ally.hp == ally.max_hp and ally.hp < hp_was,
			"and current health CLAMPS under it (%d -> %d)" % [hp_was, ally.hp])
	ok(ally.max_hp == base_max,
		"after three ticks the maximum is back where it started (%d, got %d)" % [
			base_max, ally.max_hp])
	ok(not ally.has_status("fortified"), "and the chip is gone")
	# A RE-CAST UNWINDS THE STANDING LOAN FIRST. Two loans on one body would
	# each believe they owned a share of `max_hp`.
	await scene.call("_resolve", dv, _card("Fortified Spirit"), ally, "good")
	await scene.call("_resolve", dv, _card("Fortified Spirit"), ally, "good")
	ok(ally.max_hp == base_max + step * 3,
		"a second cast REPLACES the loan rather than stacking it (%d, got %d)" % [
			base_max + step * 3, ally.max_hp])
	# THE PERFECT IS A FOURTH STEP, not a bigger one.
	ally.expire_fortified_spirit()
	await scene.call("_resolve", dv, _card("Fortified Spirit"), ally, "perfect")
	ok(ally.max_hp == base_max + step * 4,
		"a perfect opens at FOUR steps (%d, got %d)" % [
			base_max + step * 4, ally.max_hp])
	# AND THE FORCED EXPIRY PUTS IT BACK WHATEVER STATE IT IS IN.
	ally.expire_fortified_spirit()
	ok(ally.max_hp == base_max,
		"the forced expiry returns the true maximum (%d, got %d)" % [
			base_max, ally.max_hp])
	ok(ally.max_hp == base_max, "and it is idempotent")
	ally.expire_fortified_spirit()
	ok(ally.max_hp == base_max, "twice over")
	_victory_sync(scene)
	scene.queue_free()
	await process_frame


func _victory_sync(scene: Node) -> void:
	# §6's FIFTH CLAUSE, SECOND HALF: THE ALLY'S max_hp RETURNS TO ITS TRUE
	# VALUE ON THE PARTY MEMBER AFTER A VICTORY, while the Devout's Conviction
	# growth and a Warden's Tenacity resolve correctly at the SAME sync.
	#
	# ALL THREE ARE DRIVEN AT ONCE AND AT DELIBERATELY DIFFERENT MAGNITUDES, so
	# a sign error cannot hide inside a cancellation — which is exactly how two
	# of these fields happen to cancel in a fight that carries both.
	#
	# IT USES A REAL SPAWNED HERO. A bare `BattleUnit.new()` has no nameplate,
	# so `add_status`/`remove_status` crash inside `_refresh_chips` (BA's gotcha)
	# — and this check has to exercise the status, because the loan lives on it.
	var u := _hero_named(scene, "warrior")
	u.expire_fortified_spirit()
	u.max_hp = 200
	u.hp = 150
	u.tenacity_hp_gained = 30
	u.conviction_hp_gained = 12
	u.rot_hp_lost = 7
	u.add_status("fortified", "Fortified Spirit", "FS3",
		Color(0.95, 0.88, 0.60), -1, "")
	var st := u.get_status("fortified")
	st["lent"] = 45
	st["step"] = 15
	var member := {}
	u.sync_victory_state(member)
	# 200 - 45 (the loan, unwound first) = 155; then -30 -12 +7 = 120.
	ok(int(member["max_hp"]) == 120,
		"the sync unwinds the loan AND all three signs (120, got %d)"
			% int(member["max_hp"]))
	ok(u.max_hp == 155,
		"the unit's own maximum is true again before the arithmetic (155, got %d)"
			% u.max_hp)
	ok(not u.has_status("fortified"), "and the loan's chip is gone")
	ok(int(member["hp"]) <= int(member["max_hp"]),
		"and health is clamped under the restored maximum")
	# THE CONTROL: with no loan standing the sync is byte-for-byte what it was.
	u.max_hp = 200
	u.hp = 150
	u.tenacity_hp_gained = 30
	u.conviction_hp_gained = 12
	u.rot_hp_lost = 7
	var member2 := {}
	u.sync_victory_state(member2)
	ok(int(member2["max_hp"]) == 165,
		"CONTROL: no loan, and the three fields alone give 165 (got %d)"
			% int(member2["max_hp"]))
	u.tenacity_hp_gained = 0
	u.conviction_hp_gained = 0
	u.rot_hp_lost = 0


func _live_reliquary() -> void:
	# §6's SIXTH CLAUSE, AND THE CONSTRUCTION IS AN ALLY RELEASED DOWN TO ZERO.
	# "Somebody was healed" is trivially true; a version reading the LIVE count
	# pays that ally nothing at all, which is what this separates.
	var scene := await _spawn("inquisitor", ["raider"])
	var dv := _cleric(scene, "conviction")
	if dv == null:
		scene.queue_free()
		return
	var released := _hero_named(scene, "warrior")
	var holding := _hero_named(scene, "mage")
	var empty := _hero_named(scene, "hunter")
	released.faith_stacks = 0
	released.faith_peak = 4      # carried four, cashed them in
	holding.faith_stacks = 2
	holding.faith_peak = 2
	empty.faith_stacks = 0
	empty.faith_peak = 0
	for u in [released, holding, empty]:
		u.hp = maxi(int(u.max_hp * 0.30), 1)
	var was := {}
	for u in [released, holding, empty]:
		was[u] = u.hp
	await scene.call("_resolve", dv, _card("Reliquary"), dv, "good")
	ok(released.hp > was[released],
		"an ally who RELEASED DOWN TO ZERO is still paid for a peak of 4")
	ok(holding.hp > was[holding], "an ally still holding 2 is paid too")
	ok(empty.hp == was[empty],
		"an ally who never carried any is paid nothing (%d -> %d)" % [
			was[empty], empty.hp])
	# AND IT PAYS BY DEPTH: the peak-4 ally takes twice the peak-2 ally's share.
	# Read as a RATIO with open ground, never as a bare `>`.
	var gained_4: int = released.hp - was[released]
	var gained_2: int = holding.hp - was[holding]
	ok(gained_4 > gained_2 * 1.5,
		"twice the peak is roughly twice the heal (%d against %d)" % [
			gained_4, gained_2])
	# THE SIZE IS A SHARE OF THE DEVOUT'S MAXIMUM, not of the recipient's.
	var want := int(round(dv.max_hp * RELIQUARY_PCT_TEST * 4))
	ok(gained_4 >= want, "and it is 2.5%% of HIS maximum per point (>=%d, got %d)"
		% [want, gained_4])
	scene.queue_free()
	await process_frame


# ---------- §4 live: the Occultist three ----------

func _live_suffering() -> void:
	# §6's SEVENTH CLAUSE. THE ENEMY IS GIVEN A DEEP RUIN PILE FIRST, which is
	# the state in which the capped lifesteal door WOULD bind — so if the heal
	# went through it the number would land near 40% instead of at 100%, and the
	# two bands do not overlap.
	var scene := await _spawn("occultist", ["chief", "raider"])
	var occ := _cleric(scene, "old_gods")
	ok(occ != null, "the Occultist spawned")
	if occ == null:
		scene.queue_free()
		return
	var foe: BattleUnit = _live_foes(scene)[0]
	scene.call("_gain_ruin", foe, 12)
	ok(foe.status_stacks("ruin") >= 12, "the mark is deep enough to bind the cap")
	occ.hp = maxi(int(occ.max_hp * 0.40), 1)
	var hp_was: int = occ.hp
	var foe_was: int = foe.hp
	var pressure_was: int = foe.pressure
	_seeded()
	await scene.call("_resolve", occ, _card("Suffering"), foe, "good")
	var dealt := foe_was - foe.hp
	var healed := occ.hp - hp_was
	ok(dealt > 0, "Suffering struck (got %d)" % dealt)
	ok(foe.pressure > pressure_was,
		"and it carries its 8 Break (%d -> %d)" % [pressure_was, foe.pressure])
	# THE RATIO, WITH OPEN GROUND BETWEEN SIGNAL AND NOISE (BS's rule). 100% of
	# the damage, then the Cleric passive's own +15% on healing RECEIVED, is
	# ~1.15; the 40% cap would read ~0.46. Anything at or above 0.9 can only be
	# the uncapped door.
	var ratio := float(healed) / float(maxi(dealt, 1))
	ok(ratio >= 0.9,
		"the heal is the WHOLE of the damage, outside the 40%% cap (ratio %.2f)"
			% ratio)
	# THE DRIP. It is on the ENEMY and it pays on the ENEMY'S clock.
	ok(foe.has_status("suffering"), "the wound is on the enemy")
	ok(int(foe.get_status("suffering").get("turns", 0)) == 4,
		"and it runs 4 turns (got %d)"
			% int(foe.get_status("suffering").get("turns", 0)))
	ok(foe.status_power("suffering") == 2,
		"granting 2 a turn (got %d)" % foe.status_power("suffering"))
	var stacks_was := foe.status_stacks("ruin")
	scene.call("_suffering_tick", foe)
	ok(foe.status_stacks("ruin") == stacks_was + 2,
		"a tick grants exactly 2 (%d -> %d)" % [stacks_was, foe.status_stacks("ruin")])
	# FOUR TICKS IS EIGHT STACKS — the number the card's whole axis rests on.
	for _i in 3:
		scene.call("_suffering_tick", foe)
	ok(foe.status_stacks("ruin") == stacks_was + 8,
		"four of the enemy's turns buy EIGHT stacks (%d, got %d)" % [
			stacks_was + 8, foe.status_stacks("ruin")])
	# A PERFECT DRIPS 3.
	var other: BattleUnit = _live_foes(scene)[1]
	await scene.call("_resolve", occ, _card("Suffering"), other, "perfect")
	ok(other.status_power("suffering") == 3,
		"a perfect drips 3 a turn (got %d)" % other.status_power("suffering"))
	scene.queue_free()
	await process_frame


func _live_transference() -> void:
	# §6's EIGHTH CLAUSE, AND THE PILES ARE CHOSEN TO SUM TO A MULTIPLE OF THE
	# THRESHOLD. That is the one arrangement in which a relocation routed
	# through `_gain_ruin` would arm the primer — so "nothing detonates in
	# transit" becomes a real assertion rather than a lucky one.
	var scene := await _spawn("occultist", ["chief", "raider", "archer"])
	var occ := _cleric(scene, "old_gods")
	if occ == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var dest: BattleUnit = foes[0]
	var src: BattleUnit = foes[1]
	var bystander: BattleUnit = foes[2]
	scene.call("_gain_ruin", src, 7)
	scene.call("_gain_ruin", dest, 3)
	dest.remove_status("ruin_primed")
	src.remove_status("ruin_primed")
	ok(src.status_stacks("ruin") == 7 and dest.status_stacks("ruin") == 3,
		"the two piles are 7 and 3 — they sum to the threshold of %d"
			% RUIN_THRESHOLD_TEST)
	await scene.call("_resolve", occ, _card("Transference"), dest, "good")
	# BATCH CQ §3 — TEN MOVED PLUS THE TWO CN §3 FOLDED IN ON ARRIVAL.
	ok(dest.status_stacks("ruin") == 12,
		"EVERY stack moved, plus the folded 2 on arrival (12, got %d)" % \
			dest.status_stacks("ruin"))
	ok(src.status_stacks("ruin") == 0,
		"and the source is empty (got %d)" % src.status_stacks("ruin"))
	ok(not dest.has_status("ruin_primed"),
		"NOTHING DETONATED IN TRANSIT — the pile sits on a multiple of the"
			+ " threshold and is not primed")
	ok(bystander.status_stacks("ruin") == 0,
		"and no third body was touched")
	# THE DEEPEST OTHER MARK IS THE ONE THAT MOVES, not the nearest.
	scene.call("_gain_ruin", src, 2)
	scene.call("_gain_ruin", bystander, 6)
	src.remove_status("ruin_primed")
	bystander.remove_status("ruin_primed")
	dest.remove_status("ruin_primed")
	var dest_was := dest.status_stacks("ruin")
	await scene.call("_resolve", occ, _card("Transference"), dest, "good")
	ok(bystander.status_stacks("ruin") == 0 and src.status_stacks("ruin") == 2,
		"the DEEPEST other pile (6) moved, not the shallower one (2)")
	ok(dest.status_stacks("ruin") == dest_was + 6 + 2,
		"and it all arrived, plus the folded 2 (%d, got %d)" % [
			dest_was + 6 + 2, dest.status_stacks("ruin")])
	# A PERFECT ADDS TWO ON ARRIVAL, and those two are the only stacks the card
	# ever CREATES.
	scene.call("_gain_ruin", src, 3)
	src.remove_status("ruin_primed")
	dest.remove_status("ruin_primed")
	dest_was = dest.status_stacks("ruin")
	var src_had := src.status_stacks("ruin")
	await scene.call("_resolve", occ, _card("Transference"), dest, "perfect")
	ok(dest.status_stacks("ruin") == dest_was + src_had + 2,
		"a perfect brings the pile plus 2 (%d, got %d)" % [
			dest_was + src_had + 2, dest.status_stacks("ruin")])
	scene.queue_free()
	await process_frame


func _live_anointing() -> void:
	# ANOINTING COUNTS HITS, NOT CASTS, and the check is an exact IDENTITY
	# between a three-hit ability and a single-strike one driven in the same
	# battle — which is what tells three per VOLLEY from three per CAST (BR's
	# Aimed Volley construction).
	var scene := await _spawn("occultist", ["chief", "raider"])
	var occ := _cleric(scene, "old_gods")
	if occ == null:
		scene.queue_free()
		return
	var ally := _hero_named(scene, "hunter")
	var foe: BattleUnit = _live_foes(scene)[0]
	foe.max_hp = 100000
	foe.hp = 100000
	await scene.call("_resolve", occ, _card("Anointing"), occ, "good")
	for h in scene.get("heroes"):
		if not h.is_companion:
			ok(h.has_status("anointed"), "%s is anointed" % h.unit_name)
	# BATCH CQ §3 — FOUR SINCE CN §3'S FOLD. Anointing's cooldown is 5, so the
	# buff still expires before it can be recast: this fold did NOT make it
	# permanent, which is the class of fold §2 flags separately.
	ok(int(occ.get_status("anointed").get("turns", 0)) == 4,
		"the anointing runs 4 turns")
	# (a) A SINGLE-STRIKE ABILITY APPLIES EXACTLY ONE.
	var single: Ability = Ability.make({"display_name": "BU Probe", "damage": 10,
		"cost": 0, "pressure": 0, "delay": 2.0, "anim": "attack01"})
	foe.remove_status("ruin")
	var before := foe.status_stacks("ruin")
	await scene.call("_resolve", ally, single, foe, "good")
	var one := foe.status_stacks("ruin") - before
	ok(one == 1, "a single-strike ability applies exactly 1 Ruin (got %d)" % one)
	# (b) A THREE-HIT ABILITY APPLIES EXACTLY THREE. The identity `three == 3 *
	# one` is the whole point: a per-CAST implementation gives 1 here too.
	var volley: Ability = Ability.make({"display_name": "BU Volley Probe", "damage": 10,
		"cost": 0, "pressure": 0, "delay": 2.0, "anim": "attack01",
		"multi_hits": 3})
	before = foe.status_stacks("ruin")
	await scene.call("_resolve", ally, volley, foe, "good")
	var three := foe.status_stacks("ruin") - before
	ok(three == 3,
		"a three-hit ability applies exactly 3 (got %d)" % three)
	ok(three == one * 3,
		"which is the identity that tells per-HIT from per-CAST (%d vs %d)"
			% [three, one])
	# (c) FROM ALLIES ONLY. An ENEMY striking a hero marks nothing — the hook
	# reads the ATTACKER, and `_gain_ruin` refuses a hero target anyway.
	var hero_stacks_before := ally.status_stacks("ruin")
	var enemy: BattleUnit = _live_foes(scene)[1]
	await scene.call("_resolve", enemy, single, ally, "good")
	ok(ally.status_stacks("ruin") == hero_stacks_before,
		"an enemy's blow anoints nothing onto a hero")
	# (d) IT EXPIRES CLEANLY, and once it has, the marking stops.
	for _i in 4:
		ally.tick_statuses()
	ok(not ally.has_status("anointed"), "the anointing expires")
	before = foe.status_stacks("ruin")
	await scene.call("_resolve", ally, single, foe, "good")
	ok(foe.status_stacks("ruin") == before,
		"and an unanointed ally marks nothing (got +%d)"
			% (foe.status_stacks("ruin") - before))
	scene.queue_free()
	await process_frame


func _live_gates() -> void:
	# TWO CARDS READ AN ACCUMULATION AND DO NOTHING AT ZERO, so both are gated
	# out rather than left as buttons that spend a turn to print a refusal.
	var scene := await _spawn("holy", ["raider", "chief"])
	var holy := _cleric(scene, "mercy")
	if holy == null:
		scene.queue_free()
		return
	holy.heal_by_turn.clear()
	holy.abilities.append(_card("Reprisal"))
	ok(not scene.call("_ability_usable", holy, _card("Reprisal")),
		"Reprisal is refused with nothing healed")
	holy.battle_turn = 2
	holy.heal_by_turn[2] = 30
	ok(scene.call("_ability_usable", holy, _card("Reprisal")),
		"and offered once she has healed")
	# TRANSFERENCE needs a mark to move.
	for e in _live_foes(scene):
		e.remove_status("ruin")
	ok(not scene.call("_ability_usable", holy, _card("Transference")),
		"Transference is refused with no Ruin on the field")
	scene.queue_free()
	await process_frame
