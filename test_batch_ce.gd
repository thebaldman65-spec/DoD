# test_batch_ce.gd — TRANCHE 3, THE CLERIC NINE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ce.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability or its tick by hand.
#
# WHAT IT PROTECTS, AND WHY THE OBVIOUS ASSERTION IS NEVER THE ONE THAT SHIPS.
# Every one of the nine has a clause that could silently do nothing or do
# something adjacent and wrong, and a broken implementation would pass the
# obvious check while doing it:
#
# · MATINS pays on a turn NOBODY FELL. "She gained a Mercy" is trivially true of
#   a card that simply grants one, so the office is driven THREE TIMES: unbroken
#   (must pay), immediately after a fall (must pay NOTHING — the passive paid
#   instead), and again on the turn after (must pay again, because the flag is
#   cleared as it is read). A no-flag version fails the second; a LATCHING
#   version fails the third.
# · ALMS wards only what is WASTED. "The ally got a barrier" is trivially true of
#   a version that wards on every Mercy gain, so it is driven BELOW the cap
#   (nothing must be given away — the stack landed) and AT it. It is also
#   asserted NOT to be a Divine Shield: a Mercy overflow feeding the Devout's
#   Conviction would be one spec's engine leaking through another's card.
# · OBSERVANCE keeps the perfect THROUGH an Empower. "It was Empowered" is
#   trivially true, so the discriminator is DIVINE PLEA's perfect — 10 Mana, an
#   exact integer — measured with and without the office, beside the Mercy
#   actually spent (3 against 4). Both halves have to move or the card is half
#   built.
# · ELEVATION raises a FLOOR and writes the PEAK. An ally already at 4 must be
#   UNTOUCHED (an adding version raises him to 7) and NOBODY'S COUNT may move (a
#   version that granted Faith would raise both). Those two are the whole card.
# · JUBILEE is NOT a release. "He healed" is trivially true, so what is asserted
#   is everything the release would ALSO have done and this must not: no
#   Communion, no principal growth, no Binding Oath — and his PEAK standing
#   afterwards, which is what BI's decoupling is for.
# · MANTLE passes to somebody ELSE. The holder is deliberately made the LOWEST
#   HEALTH IN THE PARTY, so a naive "lowest health" pick would bounce it in
#   place and pass every obvious check; the hop is asserted to land on a
#   different body, and the chain to STOP after its count runs out.
# · ANATHEMA amplifies. The same 20 Break damage is driven into a marked enemy
#   and an unmarked control in the same battle — 30 against 20, exact, no
#   variance — and the CAST'S OWN Break is asserted at 20, because a mark
#   applied one line too early would amplify itself.
# · REQUIEM spends the pile. "It did damage" is trivially true, so two identical
#   enemies are built at 5 and 20 stacks and the damage RATIO asserted with open
#   ground; the pile and the PRIMER are asserted gone; and the party heal is
#   asserted at Requiem's own 2% a stack rather than the detonation's 25%.
# · PENANCE reads the TARGET'S OWN Attack. Two enemies with different Attack
#   stats — a version reading the CASTER's gives the same tick twice, which is
#   the only construction that tells them apart.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on rather than
# hiding it inside a magic number.
const ALMS_WARD_PCT_TEST := 12
# BATCH CQ §3 — THREE SINCE CN §3'S FOLD (`MANTLE_HOPS + 1` at the read site).
const MANTLE_HOPS_TEST := 3
const JUBILEE_MIN_FAITH_TEST := 3
# RE-POINTED BY BATCH CG. Four of CE's magnitudes moved and one arrived; the
# figures are transcribed here rather than read off the constants they check,
# for the same reason CE transcribed them — a check that reads the number it is
# checking has stopped asking its question.
const DIVINE_PRESENCE_MERCY_TEST := 2
const DIVINE_PRESENCE_EVERY_TEST := 2
const VESPERS_PCT_TEST := 0.20
const ELEVATION_STACKS_TEST := 2
# BATCH DF: `battle.FAITH_RELEASE`, ruled at CZ §2 and re-affirmed at DA §1,
# mirrored ONCE per suite — DC's device, extended here to the second suite its
# sweep did not reach. The next threshold ruling costs this file one line.
const RELEASE := 3
const HELD_MAX := RELEASE - 1   # the deepest an ally can CARRY; at RELEASE he releases
const BREAKING_DARKNESS_BD_PCT_TEST := 25
const PENANCE_MIRROR_TEST := 0.50

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# This table is the machine-checkable half of "the batch shipped what it said".
# BATCH DF RE-POINTED THE DELAY COLUMN FOR THE PURE BUFFS IN THIS TABLE.
# CY §1 capped a pure buff at half a swing (`Ability.BUFF_DELAY_CAP` = 1.0) and
# each name changed below is in `Ability.PURE_BUFFS` with `"delay":
# Ability.BUFF_DELAY_CAP` written into its own def — so the old number was a
# pre-CY one and the code was right. The column stays a LITERAL rather than
# reading the constant: a check that reads the number it is checking has
# stopped asking its question.
# Moved here: Divine Presence, Alms, Vespers, Mantle.
const NINE := {
	"Divine Presence": ["holy", 20, 1.0, 4, 0],
	"Alms":            ["holy", 20, 1.0, 4, 0],
	"Vespers":         ["holy", 25, 1.0, 4, 0],
	"Elevation":       ["inquisitor", 35, 2.5, 5, 0],
	"Blessing of the Faithful": ["inquisitor", 20, 2.0, 4, 0],
	"Mantle":          ["inquisitor", 25, 1.0, 4, 0],
	"Breaking Darkness": ["occultist", 25, 2.0, 4, 20],
	"Requiem":         ["occultist", 30, 3.0, 5, 8],
	"Penance":         ["occultist", 25, 2.5, 4, 0],
}

# THE DEVOUT'S POOL KEY IS `inquisitor` AND NOT `devout`, and it is pinned here
# rather than left to the table above: `SPEC_INFO["inquisitor"]` carries the
# display name "Devout" and master.html's draft table prints "Devout", so the
# docs and the code disagree BY DESIGN. A `"devout"` key would raise nothing,
# resolve nothing, and ship three cards no hero could ever be offered.
const DEVOUT_KEY := "inquisitor"


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
	Profile.save_path = "user://profile_batch_ce_test.json"
	Profile.loaded = false
	Profile.data = {}

	_pool_key()
	_pools()
	_definitions()
	_synergy_rule()
	_names()
	_status_lists()
	_protected_cores()
	_empower_split()
	_docs()

	await _live_divine_presence()
	await _live_alms()
	await _live_vespers()
	await _live_elevation()
	await _live_blessing_of_the_faithful()
	await _live_mantle()
	await _live_breaking_darkness()
	await _live_requiem()
	await _live_penance()

	if FileAccess.file_exists("user://profile_batch_ce_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ce_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH CE: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- §0: the key, before anything else ----------

func _pool_key() -> void:
	ok(Classes.SPEC_DRAFT_POOLS.has(DEVOUT_KEY),
		"§0: the Devout's draft pool is keyed `inquisitor`")
	ok(not Classes.SPEC_DRAFT_POOLS.has("devout"),
		"§0: ...and NOT `devout` — a `devout` key would resolve nothing")
	ok(String(Classes.SPEC_INFO[DEVOUT_KEY]["name"]) == "Devout",
		"§0: ...while SPEC_INFO['inquisitor'] still DISPLAYS 'Devout'")
	for n in ["Elevation", "Blessing of the Faithful", "Mantle"]:
		ok(Classes.spec_draft_pool(DEVOUT_KEY).has(n),
			"§0: %s landed in the `inquisitor` pool where a hero can draw it" % n)


# ---------- §6: the pools ----------

func _pools() -> void:
	# THE DEPTH LOOP INVERTS AGAIN, AND IT IS THE FIFTH TIME. It has asserted,
	# in order: each earlier tranche's own asymmetry, then the FLATNESS tranche 2
	# achieved, then CB's new asymmetry pointing the other way, and now that
	# asymmetry HALVED — the MAGE AND CLERIC six draft from EIGHT, the HUNTER and
	# WARRIOR six from FIVE. What is owed has to stay visible in code rather than
	# only in prose, which is the whole reason this loop keeps moving.
	for spec in ["pyromancer", "cryomancer", "arcanist",
			"holy", "inquisitor", "occultist",
			"beastmaster", "sharpshooter", "mystic"]:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() >= 8, "%s drafts at least EIGHT (got %d)" % [spec, pool.size()])
		var seen := {}
		for n in pool:
			seen[String(n)] = 1
		ok(seen.size() == pool.size(),
			"%s's pool holds no duplicate — a repeat keeps the count and changes the draft" % spec)
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
			"%s drafts at least EIGHT — tranche 3 is complete" % spec)
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 125, "the spec pools hold 125 (CI's 96, DO's twenty-two, DR's net +1, DS's six), got %d"
		% total)
	ok(total > 12 * 8,
		"...which is ABOVE CI's flat ninety-six — DO's twenty-two landed here")
	var draft_total := total
	for cls in Classes.CLASS_DRAFT_POOLS:
		draft_total += Classes.class_draft_pool(cls).size()
	ok(draft_total == 149, "the draft holds 149 (got %d)"
		% draft_total)
	# INVERTED BY BATCH CI RATHER THAN DELETED. These asserted a DEBT for three
	# batches; CI paid it, so what they assert now is that there is none — which
	# is the thing a later batch could break (a pool emptying, a card removed),
	# and it is the same question with the correct answer moved.
	ok(149 - draft_total == 0,
		"NOTHING is owed — the draft is complete at 149 of 149")
	ok(125 - total == 0, "...and the spec half is full at 125")
	# CLASS_DRAFT_POOLS IS BYTE-UNTOUCHED — this batch adds no class card, and a
	# spec ability leaking into a class pool is the BQ/BR/BT/CB negative control.
	for cls in Classes.CLASS_DRAFT_POOLS:
		ok(Classes.class_draft_pool(cls).size() == 6,
			"%s's class pool is still SIX" % cls)
		for n in NINE:
			ok(not Classes.class_draft_pool(cls).has(n),
				"%s is a SPEC card and is not in %s's class pool" % [n, cls])
	# CLASS_POOLS AND SPEC_POOLS FEED THE BOSS PICK and must not move (BO's
	# rule, kept by every tranche since).
	ok(Classes.CLASS_POOLS["cleric"].size() == 14,
		"CLASS_POOLS['cleric'] is byte-untouched at 14")
	for n in NINE:
		for cls in Classes.CLASS_POOLS:
			ok(not Classes.CLASS_POOLS[cls].has(n),
				"%s did not leak into the BOSS pool %s" % [n, cls])
		for spec in Classes.SPEC_POOLS:
			ok(not Classes.SPEC_POOLS[spec].has(n),
				"%s did not leak into the boss SPEC pool %s" % [n, spec])
	# TRANCHE 1 AND 2 STILL LEAD EACH CLERIC POOL. A later tranche APPENDS; it
	# does not rewrite. Pinned as literals because a swap of two names would keep
	# every count and change what the draft offers.
	ok(Classes.spec_draft_pool("holy").slice(0, 5)
		== ["Second Wind", "Rite of Return", "Recant", "Shared Grief", "Reprisal"],
		"Holy's first five are still BO's pair and BU's three")
	ok(Classes.spec_draft_pool(DEVOUT_KEY).slice(0, 5)
		== ["Vow of Suffering", "Aegis Reversal", "Ordination",
			"Fortified Spirit", "Reliquary"],
		"the Devout's first five are unchanged")
	ok(Classes.spec_draft_pool("occultist").slice(0, 5)
		== ["Blight the Well", "Covenant of Ash", "Suffering",
			"Transference", "Anointing"],
		"the Occultist's first five are unchanged")


func _definitions() -> void:
	for n in NINE:
		var spec: String = NINE[n][0]
		ok(Classes.spec_draft_pool(spec).has(n),
			"%s is in the %s draft pool" % [n, spec])
		var ab: Ability = Classes.pool_ability(n)
		ok(ab != null, "%s resolves through pool_ability" % n)
		if ab == null:
			continue
		ok(ab.display_name == n, "...to itself (%s)" % n)
		ok(ab.description != "", "...with a description (%s)" % n)
		ok(ab.delay > 0.0, "...and an initiative cost (%s)" % n)
		ok(ab.cooldown > 0, "...and a cooldown (%s)" % n)
		# RE-POINTED BY BATCH CN §2. This asserted that EVERY draft entry states a
		# perfect. As of CN that is false by design: 113 of the 211 abilities run no
		# skill check at all, and §3 CLEARED their `perfect_text` precisely so the
		# draft card cannot advertise a bonus nothing can fire. The durable question
		# is the BICONDITIONAL — a card states a perfect exactly when it runs a check
		# — which is strictly stronger than what was here and cannot rot as the
		# criterion catches more cards.
		ok(ab.perfect_text != "" if ab.runs_skill_check() else ab.perfect_text == "",
			"...and states a perfect exactly when it runs a check (%s)" % n)
		ok(Classes.draft_ability(n) != null,
			"...and it is a DRAFT def, so the bot hook can see it (%s)" % n)
		ok(ab.cost == int(NINE[n][1]),
			"%s costs %d (got %d)" % [n, int(NINE[n][1]), ab.cost])
		ok(is_equal_approx(ab.delay, float(NINE[n][2])),
			"%s arrives at %.1f (got %.1f)" % [n, float(NINE[n][2]), ab.delay])
		ok(ab.cooldown == int(NINE[n][3]),
			"%s cools for %d (got %d)" % [n, int(NINE[n][3]), ab.cooldown])
		ok(ab.pressure == int(NINE[n][4]),
			"%s carries %d Break damage (got %d)" % [n, int(NINE[n][4]), ab.pressure])
	# BREAK DAMAGE ASSIGNED DELIBERATELY (the BO rule): TWO of the nine carry it
	# and SEVEN do not, and each of the seven is a decision rather than an
	# oversight — six of them land no blow at all, and PENANCE's damage arrives
	# as a MIRROR off the enemy's own blows (Batch CG §3), where Break has
	# nothing to ride.
	var with_bd := 0
	for n in NINE:
		if int(NINE[n][4]) > 0:
			with_bd += 1
	ok(with_bd == 2, "exactly two of the nine carry Break damage (got %d)" % with_bd)
	# REQUIEM'S BREAK IS FLAT AND MUST STAY FLAT — Ruin has no ceiling, and a
	# per-stack Break term on an uncapped count is the squaring trap (Arcane
	# Bolt's rule). The per-stack half is DAMAGE and lives in the special.
	ok(Classes.pool_ability("Requiem").pressure == 8,
		"Requiem's Break is a flat 8, never per stack")
	# The two ally-facing cards are the only ones that name a target.
	ok(Classes.pool_ability("Mantle").target == Ability.Target.ALLY,
		"Mantle is ally-facing")
	# BATCH CG — VESPERS IS THE POOL'S SECOND ALLY-FACING CARD (it took
	# Observance's slot, and Observance was a self-cast), so it moves up beside
	# Mantle and leaves four names here.
	ok(Classes.pool_ability("Vespers").target == Ability.Target.ALLY,
		"Vespers is ally-facing")
	for n in ["Divine Presence", "Alms", "Elevation",
			"Blessing of the Faithful"]:
		ok(Classes.pool_ability(n).target == Ability.Target.ENEMY,
			"%s takes no ally click — it is a self/party effect" % n)


func _synergy_rule() -> void:
	# BT §1's ACCEPTANCE TEST: an ability that cannot name its combo has not been
	# designed yet. ANCHORED PER ABILITY rather than per block, so a shared
	# header cannot satisfy all nine at once.
	var src := _src("res://scripts/classes.gd")
	var start := src.find("BATCH CE: TRANCHE 3, THE CLERIC NINE")
	ok(start > 0, "the CE block is findable in classes.gd")
	if start <= 0:
		return
	var block := src.substr(start, src.find("the vault, unsealed", start) - start)
	ok(block.length() > 2000, "the CE block is a real region (%d chars)"
		% block.length())
	for n in NINE:
		var at := block.find('"%s":' % n)
		ok(at > 0, "%s's definition is inside the CE block" % n)
		if at <= 0:
			continue
		var prev := 0
		for m in NINE:
			if m == n:
				continue
			var pat := block.find('"%s":' % m)
			if pat >= 0 and pat < at and pat > prev:
				prev = pat
		var comment := block.substr(prev, at - prev)
		ok(comment.contains("AXIS"), "%s carries an AXIS line" % n)
		ok(comment.contains("SYNERGY"), "%s carries a SYNERGY line" % n)


func _names() -> void:
	# BR §1'S SWEEP, SHIPPED AS A TEST. An ABILITY-vs-ABILITY duplicate is a REAL
	# BREAK because `pool_ability` is keyed on `display_name`; everything else is
	# a label collision that ships flagged. ALL NINE CAME BACK CLEAN against
	# every ability, talent node, status and rune — the first tranche since BO
	# with nothing to report, which is what the register narrowing buys.
	var seen := {}
	for spec in Classes.SPEC_DRAFT_POOLS:
		for n in Classes.spec_draft_pool(spec):
			ok(not seen.has(n), "%s appears in exactly one spec draft pool" % n)
			seen[String(n)] = spec
	for cls in Classes.CLASS_DRAFT_POOLS:
		for n in Classes.class_draft_pool(cls):
			ok(not seen.has(n), "%s is not also a spec draft card" % n)
			seen[String(n)] = cls
	# No talent node GRANTS an ability of the same name (that would be the
	# Backdraft break CB found — one display_name, two definitions).
	for n in NINE:
		ok(Talents.granted_ability(n) == null,
			"no talent grants an ability called %s" % n)
	# And no talent NODE, status or rune wears the name either. A node's name is
	# not an ability name and nothing resolves it, so a hit here ships FLAGGED
	# rather than renamed (BR §1).
	#
	# BATCH CG SHIPPED EXACTLY ONE, AND THE PIN IS INVERTED FOR IT RATHER THAN
	# LOOSENED. `hl_presence` is a HOLY TALENT NODE already named DIVINE
	# PRESENCE (Vigil row 2), so the collision is same-spec and an exact match —
	# closer than BP's Precision Strike / Precision Strikes. It is NAMED here so
	# the sweep still reports it every run instead of falling silent, and the
	# other eight are asserted clean, so a NEW collision cannot hide behind it.
	const FLAGGED_NODE_COLLISIONS := {"Divine Presence": "hl_presence"}
	var node_names := {}
	for spec in Classes.SPEC_IDS:
		for sp in Classes.SPEC_IDS[spec]:
			for node in Talents.generate_tree(String(sp), String(spec)):
				node_names[String(node.get("name", ""))] = 1
	for n in NINE:
		if FLAGGED_NODE_COLLISIONS.has(n):
			ok(node_names.has(n),
				"%s collides with the talent node %s — FLAGGED, shipped as specified"
					% [n, String(FLAGGED_NODE_COLLISIONS[n])])
			continue
		ok(not node_names.has(n), "no talent NODE is called %s" % n)
	var runes_src := _src("res://data/runes.json")
	for n in NINE:
		ok(not runes_src.contains('"%s"' % n), "no rune is called %s" % n)


func _status_lists() -> void:
	# BU'S SUFFERING TRAP, WRITTEN DOWN RATHER THAN INFERRED. Two of the five new
	# statuses sit on an ENEMY and are genuine AFFLICTIONS, so both are LISTED —
	# which makes them cleansable by a mender's Cleansing Rite (real counterplay,
	# and neither is battle-long so neither is taken first every time) and, the
	# half that actually matters, keeps them OUT of the derived
	# `_dispellable_buffs` set, so a Mage's Dispel can never strip the party's
	# work off the enemy carrying it.
	for sid in ["breaking_darkness", "penance"]:
		ok(BattleUnit.DEBUFF_IDS.has(sid),
			"`%s` sits on an ENEMY and is listed in DEBUFF_IDS" % sid)
	# THE OTHER THREE SIT ON HOLY and are correctly absent — a hero-side buff in
	# that list would be a hero-side buff a Cleansing Rite could take.
	# BATCH CG — `vespers` REPLACES `observance` HERE AND THE RULE IS THE SAME
	# ONE ASKED OF A NEW SHAPE: it is a BUFF, and it is the first of the three
	# that sits on an ALLY rather than on Holy herself, so a listing would have
	# made a ward a Cleansing Rite could take off the party.
	for sid in ["divine_presence", "alms", "vespers"]:
		ok(not BattleUnit.DEBUFF_IDS.has(sid),
			"`%s` is the party's and is NOT in DEBUFF_IDS" % sid)
	# MANTLE HAS NO STATUS ID OF ITS OWN, deliberately: it rides the existing
	# `barrier`, which is what makes every hop a REAL Divine Shield for
	# Conviction rather than a private ward that builds no Faith.
	var bsrc := _src("res://scripts/battle.gd")
	ok(not bsrc.contains('"mantle": ['),
		"Mantle registers no status of its own — it rides `barrier`")
	for sid in ["divine_presence", "alms", "vespers", "breaking_darkness",
			"penance"]:
		ok(bsrc.contains('"%s": [' % sid), "`%s` has a STATUS_INFO row" % sid)


func _protected_cores() -> void:
	# §6: NO NAMED ENABLER HAS ENTERED A POOL. The failure this prevents is
	# SILENT — a spine that stops working because its enabler became draftable —
	# so it is asserted against every pool the game can offer from, not just the
	# draft this batch touched.
	for spec in Classes.PROTECTED_CORES:
		for enabler in Classes.core_enablers(String(spec)):
			var name := String(enabler)
			for sp2 in Classes.SPEC_DRAFT_POOLS:
				ok(not Classes.spec_draft_pool(String(sp2)).has(name),
					"%s's enabler %s is in NO spec draft pool (%s)" % [spec, name, sp2])
			for cls in Classes.CLASS_DRAFT_POOLS:
				ok(not Classes.class_draft_pool(String(cls)).has(name),
					"%s's enabler %s is in NO class draft pool (%s)" % [spec, name, cls])
			for sp3 in Classes.SPEC_POOLS:
				ok(not Classes.SPEC_POOLS[sp3].has(name),
					"%s's enabler %s is in NO boss spec pool (%s)" % [spec, name, sp3])
	# The three Cleric cores are what this batch could most easily have broken,
	# so they are named rather than only swept.
	ok(Classes.core_enablers("holy") == ["Heal", "Hymn of Hope"],
		"Holy's enablers are unchanged")
	ok(Classes.core_enablers(DEVOUT_KEY) == ["Divine Shield", "Consecrated Ground"],
		"the Devout's enablers are unchanged")
	ok(Classes.core_enablers("occultist") == ["Shadowrend", "Hex of Ruin"],
		"the Occultist's enablers are unchanged")
	ok(Classes.core_slots("holy") == 4,
		"HOLY STILL OPENS WITH FOUR, so her eight cards compete for THREE slots")


func _empower_split() -> void:
	# OBSERVANCE ONLY FIRES BECAUSE THE PERFECT BRANCH IS NOW REACHABLE BESIDE
	# THE EMPOWERED ONE, and that split is a BEHAVIOURAL NO-OP TODAY: an
	# Empowered cast has always zeroed `is_perfect`, so the two could never both
	# be true and the `elif` was an accident of that impossibility.
	#
	# THE HYMN'S ORDER IS THE ONE THAT MATTERS AND IT IS PINNED. Empowered is 35%
	# and perfect 25%, so the Empowered share must be written LAST or the card
	# would quietly DOWNGRADE the cast it just charged a second Mercy for.
	var src := _src("res://scripts/battle.gd")
	var hymn_at := src.find("\t\t\"hymn\":")
	ok(hymn_at > 0, "the hymn special is findable")
	if hymn_at > 0:
		var hymn := src.substr(hymn_at, 700)
		var perfect_at := hymn.find("if is_perfect:\n\t\t\t\tpct = 0.25")
		var emp_at := hymn.find("if empowered:\n\t\t\t\tpct = 0.35")
		ok(perfect_at > 0 and emp_at > 0,
			"the Hymn sets both shares independently")
		ok(perfect_at < emp_at,
			"...with the bigger Empowered share written LAST, so a paid Empower can never be downgraded")
	# BATCH CG §1 — OBSERVANCE IS DELETED AND THE PIN IS INVERTED RATHER THAN
	# REMOVED. CE's check asked that the Empower's perfect be decided at ONE
	# site (`_observance_pay`); what is worth asking now is that NOTHING can
	# buy the perfect back, so the tax is unconditional again. The Hymn's
	# ordering above stays pinned regardless — it costs nothing and it is the
	# half of CE's reasoning that was about the Hymn rather than the card.
	# THE CALL FORM, NOT THE NAME. This batch's own tombstone comment names the
	# deleted function on purpose — a bare `contains` would fail against correct
	# code and invite the next author to delete the line telling them not to
	# bring it back (BS's rule, CD's `_code_only` for the same reason).
	ok(not src.contains("_observance_pay("),
		"the Empower buy-back is GONE from battle.gd, not left dormant")
	ok(src.contains("var empowered := _consume_empower(attacker, ab)\n\tif empowered:\n\t\tis_perfect = false"),
		"...so an Empowered cast forfeits its perfect unconditionally again")


func _docs() -> void:
	var doc := _src("res://docs/master.html")
	ok(doc != "", "master.html is readable")
	# RE-POINTED BY BATCH CK. THIS CHECK WAS ALREADY RED WHEN CK ARRIVED AND CK
	# DID NOT BREAK IT: it asserted a HARDCODED batch stamp, which has to be
	# hand-bumped every batch to keep passing. **FIVE SUITES CARRIED THE SAME
	# CHECK (bq, br, bt, bx, ce) AND BATCH CJ'S RE-STAMP TURNED ALL FIVE RED AT
	# ONCE** — the CD §1 fault in its other direction: not a check that can only
	# pass, but one that can only pass for one batch. It asks the durable version
	# of its own question now: the document carries a stamp, and that stamp is no
	# older than the batch this suite belongs to. No bump is ever owed again.
	# (Two-letter batch codes sort lexically; a three-letter code needs one line.)
	var _stamp_at := doc.find("Last updated:")
	ok(_stamp_at >= 0, "§5: master.html carries a Last-updated stamp")
	var _stamp := doc.substr(_stamp_at, 60)
	var _code_at := _stamp.find("(Batch ")
	var _stamped := _stamp.substr(_code_at + 7, 2) if _code_at >= 0 else ""
	ok(_stamped >= "CE",
		"§5: ...stamped no older than this suite's own batch (reads '%s')" % _stamped)
	ok(doc.contains("149 of 149") or doc.contains("149 of a target 149"),
		"master.html states the LIVE draft count against the REAL target")
	for n in NINE:
		ok(doc.contains(n), "master.html's draft table lists %s" % n)
	ok(doc.contains("Devout"),
		"...and the table still PRINTS 'Devout' for the `inquisitor` pool")
	var cm := _src("res://CLAUDE.md")
	ok(cm.contains("BATCH CE"), "CLAUDE.md carries the batch block")
	ok(cm.contains("BATCH CG"), "...and CG's, which revised it")
	# INVERTED BY BATCH DG §3, on the same idiom as test_batch_bo §6. This
	# asserted that CLAUDE.md recorded the Cleric as the SECOND CLASS COMPLETE —
	# a progress milestone in a draft that was still in progress. All four
	# classes are complete now, so the milestone is not the thing a later batch
	# could break; the ORDER they completed in is, and the Cleric's place in it
	# is what this suite's own batch bought. The phrase had also left the file
	# with CW's split, so this had been red rather than merely stale.
	ok(cm.contains("THE CLERIC SECOND") and cm.contains("ALL FOUR ARE COMPLETE"),
		"...and records the completion ORDER, the Cleric second of four")
	var notes := _src("res://docs/design-notes.md")
	ok(notes.contains("Batch CE"), "design-notes.md carries a why entry")
	var gl := _src("res://data/glossary.json")
	ok(gl.contains("mercy_window"),
		"the glossary teaches the Mercy window a player meets in these cards")
	# BATCH CG — THE ENTRY NAMED MATINS BY NAME AND MATINS NO LONGER EXISTS. A
	# glossary that teaches a card nobody can draw is worse than one that omits
	# it, so the pin follows the rename rather than being dropped.
	ok(not gl.contains("Matins") and not gl.contains("Observance"),
		"...and names no card CG deleted or renamed")
	ok(gl.contains("DIVINE PRESENCE"),
		"...naming the live card instead")
	ok(gl.contains("GUARDIAN ANGEL WIDENS THAT WINDOW"),
		"...including that the line moves")
	# THE ENTRY IS THE ONLY ONE ADDED. CB added one for the same reason: the
	# glossary teaches what a player has nowhere else to learn, not every status.
	var gj: Array = JSON.parse_string(gl)
	# RE-POINTED BY BATCH CI: it added `frenzy_floor` and `plating_climb`,
	# because two of its nine read Blood Frenzy's floor and three read Heavy
	# Plating's climb and the glossary taught neither. The question this check
	# asks is unchanged — the glossary grows deliberately, one entry per thing a
	# player has nowhere else to learn, rather than one per status.
	# BATCH CQ §3 — NINETY-FOUR SINCE BATCH CO, which added "Recasting a
	# Standing Effect". Not a fold consequence; the battery has not been green
	# here since CO shipped. The count stays PINNED deliberately — the glossary
	# grows one entry per thing a player cannot learn anywhere else, so growth
	# should have to be stated rather than absorbed.
	# BATCH CT §5/§8 — NINETY-SIX. **THE PIN IS BUMPED, NOT LOOSENED**, because
	# the paragraph above is right that growth should have to be STATED. CT added
	# exactly two, and the discipline is in what it did NOT add:
	#   * `status_hexed` — a new status with a chip on the board. §5 required it,
	#     and a player meeting "Hx" has nowhere else to learn that it is
	#     permanent, or that it is a different thing from Cripple's "C".
	#   * `pouch_slots` — the slot cap is a SYSTEM, which is what this category
	#     holds (zones, merchant, bargain, severity), and its two load-bearing
	#     rules are invisible in play: an emptied stack KEEPS its slot, and a
	#     drop with no room is an offer rather than a refusal.
	# **Three per-item entries were written and then DELETED** — Cleansing
	# Draught, Cursed Visage, Resonating Hourglass. Every one of them is fully
	# described by its own shop and pouch tooltip, this category has never held a
	# per-item entry (there is no `item_health`), and three of eight items is a
	# worse state than none. What they taught that a tooltip cannot — the
	# shop-only rule and the stack caps — is folded into `pouch_slots` instead.
	# BATCH CV §4 — NINETY-SEVEN. **THE PIN IS BUMPED, NOT LOOSENED**, and the
	# one entry is `hero_vs_ally`. CV established HERO (the four party members)
	# and ALLY (heroes and companions) as distinct words and moved thirty-two
	# node texts onto them; a player meeting "every hero" on one talent and
	# "every ally" on the next has nowhere else to learn that the difference is
	# a Beastmaster's beast. That is this category's own test — one entry per
	# thing a player cannot learn anywhere else — and it is the reason the
	# vocabulary is worth having rather than a second word for the same set.
	ok(gj != null and gj.size() == 97,
		"the glossary holds 97 entries (96 + CV's hero/ally)")
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch CE — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch CE")` would have gone on PASSING against the live file,
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
	ok(arch_mark > 0, "the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var log_doc := _src(arch_path)
	ok(log_doc.length() > 100000,
		"the archive opens at %s (%d chars)" % [arch_path, log_doc.length()])
	ok(not live_log.contains("<h2>2026-08-16 &mdash; Batch CE"),
		"CX moved this batch's entry OUT of the live changelog")
	ok(log_doc.contains("<h2>2026-08-16 &mdash; Batch CE"),
		"...and the archive carries the Batch CE entry")
	# AND THE DRAFT COUNT IS READ INSIDE THE ENTRY, NOT ACROSS THE FILE. It used
	# to be `contains("102")` against the whole changelog; against a 1 MB archive
	# that is a check that CAN ONLY PASS — three digits turn up in any document
	# with enough numbers in it. BR's rule, applied where the move exposed it.
	var ce_at := log_doc.find("&mdash; Batch CE:")
	ok(ce_at >= 0, "...under its own <h2> heading")
	if ce_at >= 0:
		var ce_end := log_doc.find("<h2>", ce_at + 4)
		var ce_entry := log_doc.substr(ce_at,
			(ce_end - ce_at) if ce_end > ce_at else -1)
		ok(ce_entry.contains("102"), "...and the CE entry states the new draft count")


# ---------- the live harness ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _card(n: String) -> Ability:
	return Classes.draft_ability(n)


func _seeded() -> void:
	seed(20260816)


# The varying spec sits in the CLERIC slot (index 2). A Holy or Occultist
# battle therefore has NO living Devout, which is correct rather than awkward:
# Faith is inert in those fights and every Faith read site says so.
func _spawn(spec: String, lineup := ["raider", "raider", "archer"]) -> Node:
	# BU'S HARNESS FAULT, AND IT BIT THIS SUITE'S FIRST DRAFT EXACTLY AS BU
	# PREDICTED IT WOULD. `_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL
	# SceneTreeTimer, and its opening block runs `_reset_faith_meters()` — which
	# zeroes every Faith count AND peak. Setting Faith after twenty frames and
	# then awaiting a cast has the values wiped out from under it, and it reads
	# as a magnitude bug: Elevation's peak check came back 3 instead of 4 and
	# Blessing of the Faithful's ratio read 61 instead of 1.67. `fast` scales
	# those timers and NOTHING the battle computes.
	return await Fixture.spawn(self, ["berserker", "pyromancer", spec, "beastmaster"],
		{"enemies": lineup, "frames": 90, "fast": true, "deterministic": true, "crit": -1.0})


func _cleric(scene: Node, passive: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == passive:
			return h
	return null


func _live_foes(scene: Node) -> Array:
	return scene.get("enemies").filter(func(e): return not e.dead)


func _allies(scene: Node, except: BattleUnit) -> Array:
	return scene.get("heroes").filter(func(h): \
		return not h.is_companion and not h.dead and h != except)


# ---------- HOLY ----------

func _live_divine_presence() -> void:
	# RE-POINTED BY BATCH CG §1 — Matins is DIVINE PRESENCE, it pays TWO Mercy on
	# every SECOND turn of hers, and it holds four turns. THE WATCH CONDITION IS
	# UNCHANGED and is still driven three ways (unbroken, straight after a fall,
	# again the turn after), because a no-flag version fails the second and a
	# LATCHING one fails the third.
	var scene := await _spawn("holy")
	var holy := _cleric(scene, "mercy")
	ok(holy != null, "Holy spawned")
	if holy == null:
		scene.queue_free()
		return
	ok(String(holy.second_resource_name) == "Mercy", "...holding Mercy")
	var ally: BattleUnit = _allies(scene, holy)[0]
	holy.grace_pct = 0
	holy.second_resource = 0
	holy.remove_status("alms")
	# A TICK WITH NO WATCH PAYS NOTHING — the control that stops every check
	# below passing off a card that simply grants Mercy every turn.
	scene.call("_divine_presence_tick", holy)
	ok(holy.second_resource == 0, "no watch, no Mercy (%d)" % holy.second_resource)
	scene.call("_apply_status", holy, "divine_presence", 9)
	# 1) THE CADENCE, AND IT IS THE DISCRIMINATING CHECK. Her FIRST turn under
	# the watch pays nothing; her SECOND pays two. A per-turn implementation
	# passes every other check in this function and fails this one twice.
	scene.call("_divine_presence_tick", holy)
	ok(holy.second_resource == 0,
		"the first turn of the watch pays NOTHING (%d)" % holy.second_resource)
	scene.call("_divine_presence_tick", holy)
	ok(holy.second_resource == DIVINE_PRESENCE_MERCY_TEST,
		"the second turn pays %d Mercy at once (%d)"
			% [DIVINE_PRESENCE_MERCY_TEST, holy.second_resource])
	# 2) A FALL BREAKS THAT TURN'S WATCH — and the passive pays instead, which
	# is the property that makes the two sources mutually exclusive. The fall is
	# staged so the broken turn is a PAYOUT turn; a fall on an idle turn could
	# never discriminate.
	holy.second_resource = 0
	scene.call("_divine_presence_tick", holy)  # idle turn (3rd)
	ally.hp = int(ally.max_hp * 0.4)
	scene.call("_on_hero_below_half", ally)
	ok(holy.second_resource == 1, "the PASSIVE paid for the fall (%d)"
		% holy.second_resource)
	var after_fall: int = holy.second_resource
	scene.call("_divine_presence_tick", holy)  # payout turn (4th), broken
	ok(holy.second_resource == after_fall,
		"...and the broken watch pays NOTHING that turn (%d)" % holy.second_resource)
	# 3) AND ONLY THAT TURN. A latching implementation fails here and passes
	# everything above it. Two ticks, because the next payout is two turns on.
	scene.call("_divine_presence_tick", holy)
	scene.call("_divine_presence_tick", holy)
	ok(holy.second_resource == after_fall + DIVINE_PRESENCE_MERCY_TEST,
		"the watch is kept again at the next payout (%d)" % holy.second_resource)
	# 4) THE OVERFLOW, WHICH IS WHY IT PAYS IN TWOS. Two stacks arriving at once
	# can cross the ceiling FROM BELOW, and Alms catches what will not fit —
	# the first time two of her own draft cards feed each other. Driven from one
	# short of the cap, so exactly one stack lands and exactly one spills.
	holy.second_resource = holy.second_max - 1
	scene.call("_apply_status", holy, "alms", 9, ALMS_WARD_PCT_TEST)
	ally.remove_status("barrier")
	ally.hp = ally.max_hp
	scene.call("_divine_presence_tick", holy)
	scene.call("_divine_presence_tick", holy)
	ok(holy.second_resource == holy.second_max,
		"the watch fills the meter to the cap (%d/%d)"
			% [holy.second_resource, holy.second_max])
	ok(holy.has_status("barrier"),
		"...and the stack that would not fit spills into ALMS, warding her")
	var ward: int = holy.status_power("barrier")
	ok(ward == maxi(int(round(holy.max_hp * 0.01 * ALMS_WARD_PCT_TEST)), 1),
		"...for %d%% of her maximum (%d)" % [ALMS_WARD_PCT_TEST, ward])
	# WITHOUT ALMS THE SPILL IS SIMPLY LOST, which is the control that proves the
	# check above measures Alms rather than measuring any barrier at all.
	holy.remove_status("alms")
	holy.remove_status("barrier")
	holy.second_resource = holy.second_max
	scene.call("_divine_presence_tick", holy)
	scene.call("_divine_presence_tick", holy)
	ok(not holy.has_status("barrier"),
		"with no Alms up the overflow is thrown away as it always was")
	scene.queue_free()
	await process_frame


func _live_alms() -> void:
	var scene := await _spawn("holy")
	var holy := _cleric(scene, "mercy")
	if holy == null:
		scene.queue_free()
		return
	var pool := _allies(scene, holy)
	var ally: BattleUnit = pool[0]
	var ally2: BattleUnit = pool[1]
	holy.grace_pct = 0
	ally.remove_status("barrier")
	ally2.remove_status("barrier")
	scene.call("_apply_status", holy, "alms", 9, ALMS_WARD_PCT_TEST)
	# BELOW THE CAP THE STACK SIMPLY LANDS AND NOTHING IS GIVEN AWAY. A version
	# that warded on every Mercy gain passes every check below and fails this one.
	holy.second_resource = 0
	ally.hp = int(ally.max_hp * 0.4)
	scene.call("_on_hero_below_half", ally)
	ok(holy.second_resource == 1, "below the cap the stack lands (%d)"
		% holy.second_resource)
	ok(not ally.has_status("barrier"),
		"...and nothing is given away")
	# AT THE CAP the wasted stack becomes a ward on the ally who earned it.
	holy.second_resource = holy.second_max
	ally2.hp = int(ally2.max_hp * 0.4)
	scene.call("_on_hero_below_half", ally2)
	ok(holy.second_resource == holy.second_max, "the meter is still capped")
	ok(ally2.has_status("barrier"), "...and the wasted stack WARDS the ally who earned it")
	var want := maxi(int(round(holy.max_hp * 0.01 * ALMS_WARD_PCT_TEST)), 1)
	ok(ally2.status_power("barrier") == want,
		"...worth %d%% of her maximum — %d (got %d)" % [
			ALMS_WARD_PCT_TEST, want, ally2.status_power("barrier")])
	# IT IS NOT A DIVINE SHIELD. A Mercy overflow feeding the DEVOUT's Conviction
	# would be one spec's engine leaking out through another spec's card.
	ok(not bool(ally2.get_status("barrier").get("divine", false)),
		"...and it is NOT a Divine Shield, so it builds nobody's Faith")
	# GRACE AND ALMS STACK. One pays health a full bar discards, the other a
	# barrier a full bar keeps — which is what stops this being a better Grace.
	holy.grace_pct = 20
	var ally3: BattleUnit = pool[2]
	ally3.remove_status("barrier")
	ally3.hp = maxi(int(ally3.max_hp * 0.3), 1)
	var hp_before: int = ally3.hp
	scene.call("_on_hero_below_half", ally3)
	ok(ally3.hp > hp_before, "Grace still mends the ally who earned it (%d -> %d)"
		% [hp_before, ally3.hp])
	ok(ally3.has_status("barrier"), "...AND Alms wards them in the same spill")
	scene.queue_free()
	await process_frame


func _live_vespers() -> void:
	# BATCH CG §1 — VESPERS REPLACES OBSERVANCE IN THIS SLOT, so the section is
	# REPLACED rather than deleted: the old one drove the Empower buy-back, which
	# no longer exists, and this drives the card that took its place.
	#
	# THE LAST CLAUSE IS THE WHOLE CARD AND IT IS WHAT THIS SECTION IS BUILT
	# AROUND: an ally who does not cross earns her NO MERCY. The obvious
	# assertion (the blow got smaller) is not the discriminating one — an absorb
	# written below the subtraction would pass it and still hand her the stack.
	var scene := await _spawn("holy")
	var holy := _cleric(scene, "mercy")
	ok(holy != null, "Holy spawned")
	if holy == null:
		scene.queue_free()
		return
	var ally: BattleUnit = _allies(scene, holy)[0]
	holy.grace_pct = 0
	holy.remove_status("alms")
	ally.remove_status("barrier")
	ally.armor = 0.0
	ally.block_chance = 0.0
	ally.parry_chance = 0.0
	var absorb := maxi(int(round(holy.max_hp * VESPERS_PCT_TEST)), 1)
	# THE NUMBERS ARE BUILT FROM THE ABSORB RATHER THAN CHOSEN, so the pair below
	# discriminates whatever Holy's maximum is: the ally stands EXACTLY `absorb`
	# above the window and the blow is `absorb + 5`. Unwarded he lands 5 under
	# the line; warded, the ward eats the whole absorb and he lands 5 above it.
	ally.max_hp = 400
	ally.mercy_threshold = 0.5
	var line := int(ally.max_hp * 0.5)
	var blow := absorb + 5
	# THE CONTROL FIRST: with no ward, that blow crosses AND pays her the Mercy.
	# Everything below is read against this.
	holy.second_resource = 0
	ally.hp = line + absorb
	ally.take_hit(blow, 0)
	ok(ally.hp == line - 5, "the unwarded blow lands whole (%d)" % ally.hp)
	ok(holy.second_resource == 1,
		"...and the crossing pays her 1 Mercy (%d)" % holy.second_resource)
	# 1) THE WARD CATCHES THE BLOW THAT WOULD CROSS, AND SHE IS PAID NOTHING.
	holy.second_resource = 0
	ally.hp = line + absorb
	await scene.call("_resolve", holy, _card("Vespers"), ally, "good")
	ok(ally.has_status("vespers"), "the office is said over the ally")
	ok(ally.status_power("vespers") == absorb,
		"...carrying %d, 20%% of HER maximum rather than his (%d)"
			% [absorb, ally.status_power("vespers")])
	ally.take_hit(blow, 0)
	ok(ally.hp == line + absorb - 5,
		"the blow is absorbed for %d (%d left)" % [absorb, ally.hp])
	ok(ally.hp > line,
		"...leaving him ABOVE the window (%d of %d)" % [ally.hp, ally.max_hp])
	ok(holy.second_resource == 0,
		"...AND SHE EARNS NO MERCY FOR A CROSSING THAT NEVER HAPPENED (%d)"
			% holy.second_resource)
	# 2) IT FIRES ONCE. "Or until it fires" — the next blow is unwarded.
	ok(not ally.has_status("vespers"), "the ward is spent as it fires")
	# 3) A PARTIAL CATCH IS A REAL OUTCOME, not a failure state: a blow bigger
	# than the absorb still crosses, still costs the health it did not catch,
	# and still pays her. This is the check a "refuse the crossing outright"
	# implementation fails.
	holy.second_resource = 0
	ally.hp = line + absorb
	scene.call("_apply_status", ally, "vespers", 9, absorb, 0, holy)
	ally.take_hit(absorb + 100, 0)
	ok(ally.hp < line, "a blow bigger than the ward still crosses (%d)" % ally.hp)
	ok(holy.second_resource == 1,
		"...and a real crossing still pays her (%d)" % holy.second_resource)
	# 4) IT WATCHES THE MERCY LINE, NOT A LITERAL HALF, AND THIS IS THE
	# CONSTRUCTION THAT TELLS THE TWO APART. Guardian Angel moves the window to
	# 65%; the ally stands `absorb` above THAT line and takes exactly `absorb`,
	# so the blow crosses the 65% line and does not come anywhere near the 50%
	# one. A ward reading a literal half never fires here at all.
	holy.second_resource = 0
	ally.mercy_threshold = 0.65
	var wide := int(ally.max_hp * 0.65)
	ally.hp = wide + absorb
	scene.call("_apply_status", ally, "vespers", 9, absorb, 0, holy)
	ally.take_hit(absorb, 0)
	ok(not ally.has_status("vespers"),
		"under Guardian Angel the ward fires at the WIDER window")
	ok(ally.hp == wide + absorb,
		"...catching the whole blow (%d)" % ally.hp)
	ok(holy.second_resource == 0,
		"...and still earns her nothing (%d)" % holy.second_resource)
	ally.mercy_threshold = 0.5
	# 5) A BLOW THAT DOES NOT REACH THE WINDOW LEAVES IT STANDING. Without this
	# a version that fired on the first hit of any size would pass every check
	# above and quietly be a different card.
	ally.hp = ally.max_hp
	scene.call("_apply_status", ally, "vespers", 9, absorb, 0, holy)
	ally.take_hit(10, 0)
	ok(ally.has_status("vespers"),
		"a blow nowhere near the window does not spend the ward")
	scene.queue_free()
	await process_frame

func _live_elevation() -> void:
	# INVERTED BY BATCH CG §2, NOT DELETED. CE's section asserted that Elevation
	# grants NO Faith — that it wrote the peak alone — and that assertion is now
	# wrong: the card hands over REAL STACKS. The setups below are deliberately
	# the same ones CE built, because they are still what tells the two readings
	# apart; only the correct answer moved.
	var scene := await _spawn(DEVOUT_KEY)
	var dv := _cleric(scene, "conviction")
	ok(dv != null, "the Devout spawned")
	if dv == null:
		scene.queue_free()
		return
	var pool := _allies(scene, dv)
	var high: BattleUnit = pool[0]
	var low: BattleUnit = pool[1]
	var mid: BattleUnit = pool[2]
	for h in scene.get("heroes"):
		h.faith_stacks = 0
		h.faith_peak = 0
	# RE-POINTED AT BATCH DF, AND THE THRESHOLD RULING TURNED THE PROOF INSIDE
	# OUT WITHOUT CHANGING THE QUESTION. Three allies at 0, 1 and 2 still, but at
	# RELEASE = 3 only the one at 0 can take ELEVATION_STACKS_TEST and come to
	# rest; the other two cross the cap and release. THAT IS A BETTER
	# DISCRIMINATOR THAN THE OLD ONE, not a worse one: a version that wrote a
	# FLOOR of 2 rather than ADDING 2 would leave all three sitting at 2 with a
	# peak of 2 and NOBODY WOULD RELEASE. So the release itself is now the thing
	# a floor-write cannot fake, and the peak carries the rest.
	low.faith_stacks = 0
	mid.faith_stacks = 1
	high.faith_stacks = 2
	await scene.call("_resolve", dv, _card("Elevation"), dv, "good")
	# IT GRANTS REAL FAITH — the inversion, driven three ways so a version that
	# wrote a floor rather than adding a count fails at every depth.
	ok(low.faith_stacks == ELEVATION_STACKS_TEST,
		"an ally at 0 is handed %d stacks (%d)"
			% [ELEVATION_STACKS_TEST, low.faith_stacks])
	ok(mid.faith_stacks == 0 and mid.faith_peak == RELEASE,
		"an ally at 1 is handed %d MORE — he crosses the cap and RELEASES, which a floor could not do (count %d, peak %d)"
			% [ELEVATION_STACKS_TEST, mid.faith_stacks, mid.faith_peak])
	ok(high.faith_stacks == 0 and high.faith_peak == RELEASE,
		"an ally at 2 likewise (count %d, peak %d)" % [high.faith_stacks, high.faith_peak])
	# AND THE PEAK FOLLOWS THE COUNT rather than being written on its own. This
	# is BI §1's one ratchet doing the work: no second writer exists any more.
	# For the two who released, the count it just gained IS the threshold.
	ok(low.faith_peak == low.faith_stacks
			and mid.faith_peak == RELEASE
			and high.faith_peak == RELEASE,
		"every peak follows the count it just gained (%d/%d/%d)"
			% [low.faith_peak, mid.faith_peak, high.faith_peak])
	# THE CONSEQUENCE TO IMPLEMENT RATHER THAN GUARD AGAINST: an ally already
	# holding HELD_MAX crosses the cap and RELEASES — healed, count reset, the Devout
	# paid. Driven with the ally on 1 HP so the heal is unmistakable.
	dv.cooldowns.clear()
	for h in scene.get("heroes"):
		h.faith_stacks = 0
		h.faith_peak = 0
	# BATCH DF: the deepest an ally can CARRY, so the grant below crosses the cap.
	# It was 3 against a threshold of 5; both moved together.
	low.faith_stacks = HELD_MAX
	low.faith_peak = HELD_MAX
	low.hp = 1
	var dv_mana: int = dv.resource
	dv.resource = 0
	await scene.call("_resolve", dv, _card("Elevation"), dv, "good")
	ok(low.faith_stacks == 0,
		"an ally at %d crosses the cap and RELEASES — the count resets (%d)"
			% [HELD_MAX, low.faith_stacks])
	ok(low.hp > 1, "...he is healed for it (%d)" % low.hp)
	ok(dv.resource > 0,
		"...and the Devout is paid his share of Mana (%d)" % dv.resource)
	# THE PEAK IS UNTOUCHED BY THE RELEASE, so the release is pure upside — the
	# property BI §1 shipped and the reason this card can be a plain grant.
	ok(low.faith_peak == RELEASE,
		"...while his PEAK stands at the %d he reached (%d)" % [RELEASE, low.faith_peak])
	dv.resource = dv_mana
	# BATCH CQ §2 — THERE IS NO PERFECT TO HAND ONE MORE. CN §2 took Elevation's
	# timing bar off (it resolves nothing a grade could multiply), and CN §3
	# folded the orphaned +1 into the base — which overwrote the designer's
	# explicit CG choice of TWO with a raised cost, picked over three when both
	# were on the table. CQ §2 restored the 2. What is asserted now is that the
	# GRADE CHANGES NOTHING, which is the durable form of the question and the
	# thing that would catch the fold coming back.
	dv.cooldowns.clear()
	for h in scene.get("heroes"):
		h.faith_stacks = 0
		h.faith_peak = 0
	await scene.call("_resolve", dv, _card("Elevation"), dv, "perfect")
	ok(low.faith_stacks == ELEVATION_STACKS_TEST,
		"a 'perfect' hands over the same %d stacks — the card runs no check (%d)"
			% [ELEVATION_STACKS_TEST, low.faith_stacks])
	ok(not _card("Elevation").runs_skill_check(),
		"...because Elevation runs no timing bar at all (CN §2)")
	# AND THE GATE IS GONE. CE refused the cast once every peak stood at the
	# floor, which was the right question about a card that raised a FLOOR and
	# is meaningless about one that hands over stacks — it would have darkened
	# the button in exactly the late-fight state the card is now worth most in.
	dv.cooldowns.clear()
	dv.resource = dv.max_resource
	for h in scene.get("heroes"):
		h.faith_peak = 5
	ok(scene.call("_ability_usable", dv, _card("Elevation")),
		"the card is NOT refused for a peak it no longer reads")
	scene.queue_free()
	await process_frame


func _live_blessing_of_the_faithful() -> void:
	var scene := await _spawn(DEVOUT_KEY)
	var dv := _cleric(scene, "conviction")
	if dv == null:
		scene.queue_free()
		return
	var jub := _card("Blessing of the Faithful")
	# THE GATE IS WHAT STOPS IT BEING A HEAL HE PRESSES EVERY TURN. Cooldowns
	# cleared either side of the pair for BV's NC1 reason, so the ONLY thing
	# that can produce the two answers is the Faith he holds.
	dv.cooldowns.clear()
	dv.faith_stacks = JUBILEE_MIN_FAITH_TEST - 1
	ok(not scene.call("_ability_usable", dv, jub),
		"refused below %d Faith held" % JUBILEE_MIN_FAITH_TEST)
	dv.cooldowns.clear()
	dv.faith_stacks = JUBILEE_MIN_FAITH_TEST
	ok(scene.call("_ability_usable", dv, jub),
		"...and allowed at %d" % JUBILEE_MIN_FAITH_TEST)
	# IT SCALES WITH THE STACKS SPENT. Driven at three and at five, with room to
	# heal into both times so the cap cannot flatten the pair.
	dv.faith_peak = 5
	var growth_before: int = dv.conviction_hp_gained
	var max_before: int = dv.max_hp
	for h in scene.get("heroes"):
		if h != dv and not h.is_companion:
			h.faith_stacks = 0
			h.faith_peak = 0
	dv.faith_stacks = 3
	dv.hp = 1
	await scene.call("_resolve", dv, jub, dv, "good")
	var healed3: int = dv.hp - 1
	ok(dv.faith_stacks == 0, "the count is emptied (%d)" % dv.faith_stacks)
	# INVERTED BY BATCH CG §2 — THE PEAK DROPS TO MATCH, AND THIS WAS CE'S
	# NEGATIVE CONTROL. CE asserted the high-water mark STANDS through the spend,
	# on BI §1's rule that spending must not cost held value; CG makes the
	# surrender the card's price and names it on the card, so the check is
	# INVERTED rather than deleted and the setup is byte-identical because it is
	# still what tells the two readings apart.
	ok(dv.faith_peak == 0,
		"his PEAK drops to match the count he spent (%d)" % dv.faith_peak)
	dv.faith_stacks = 5
	dv.faith_peak = 5
	dv.hp = 1
	await scene.call("_resolve", dv, jub, dv, "good")
	var healed5: int = dv.hp - 1
	ok(healed5 > healed3,
		"five stacks pay more than three (%d against %d)" % [healed5, healed3])
	var ratio := float(healed5) / maxf(float(healed3), 1.0)
	ok(ratio > 1.4 and ratio < 1.9,
		"...and pay PER STACK rather than flat (ratio %.2f, want ~1.67)" % ratio)
	ok(dv.faith_peak == 0, "...and the peak falls again (%d)" % dv.faith_peak)
	# IT IS NOT A RELEASE, AND THIS IS THE LOAD-BEARING HALF. A release would
	# grow the principal, roll Communion and swear Binding Oath — the frequency
	# loop BH §2 took the Devout off. UNCHANGED BY CG: the peak drop is a price
	# paid at this site, not a release arriving through the back door.
	ok(dv.conviction_hp_gained == growth_before,
		"the principal did NOT grow — this is not a release (%d)"
			% dv.conviction_hp_gained)
	ok(dv.max_hp == max_before,
		"...so his maximum is unmoved (%d)" % dv.max_hp)
	for h in scene.get("heroes"):
		if h != dv and not h.is_companion:
			ok(h.faith_stacks == 0,
				"...and Communion spread nothing to %s (%d)"
					% [h.unit_name, h.faith_stacks])
	# It is HIS card: nobody else carries Faith that never releases.
	var holy_like: BattleUnit = _allies(scene, dv)[0]
	holy_like.faith_stacks = 5
	var hp_was: int = holy_like.hp
	await scene.call("_resolve", holy_like, jub, holy_like, "good")
	ok(holy_like.hp == hp_was,
		"an ally holding five Faith cannot call the blessing (%d)" % holy_like.hp)
	scene.queue_free()
	await process_frame


func _live_mantle() -> void:
	var scene := await _spawn(DEVOUT_KEY)
	var dv := _cleric(scene, "conviction")
	if dv == null:
		scene.queue_free()
		return
	var pool := _allies(scene, dv)
	var holder: BattleUnit = pool[0]
	for h in scene.get("heroes"):
		h.remove_status("barrier")
	# THE HOLDER IS THE LOWEST HEALTH IN THE PARTY. That is the construction
	# that matters: a naive "lowest health" pass would hand the mantle straight
	# back to the body it just left and pass every other check here.
	holder.hp = maxi(int(holder.max_hp * 0.10), 1)
	for h in pool:
		if h != holder:
			h.hp = h.max_hp
	dv.hp = dv.max_hp
	await scene.call("_resolve", dv, _card("Mantle"), holder, "good")
	ok(holder.has_status("barrier"), "the mantle lands as a shield")
	ok(bool(holder.get_status("barrier").get("divine", false)),
		"...and it is a REAL Divine Shield, so its absorbs build Faith")
	ok(int(holder.get_status("barrier").get("mantle", 0)) == MANTLE_HOPS_TEST,
		"...carrying %d passes (%d)" % [MANTLE_HOPS_TEST,
			int(holder.get_status("barrier").get("mantle", 0))])
	var power: int = holder.status_power("barrier")
	ok(power == maxi(int(round(dv.max_hp * 0.25)), 1),
		"...worth 25%% of the Devout's maximum (%d)" % power)
	# BREAK IT. Exactly the shield's worth, so no health is lost and the only
	# thing under test is the pass.
	holder.take_hit(power, 0)
	ok(not holder.has_status("barrier"),
		"the exhausted shield is gone from the body it left")
	var second: BattleUnit = null
	for h in scene.get("heroes"):
		if h.has_status("barrier"):
			second = h
	ok(second != null, "...and it PASSED rather than simply ending")
	if second == null:
		scene.queue_free()
		return
	ok(second != holder,
		"...to somebody ELSE, even though the body it left is the lowest health")
	ok(int(second.get_status("barrier").get("mantle", 0)) == MANTLE_HOPS_TEST - 1,
		"...with one pass fewer (%d)"
			% int(second.get_status("barrier").get("mantle", 0)))
	ok(bool(second.get_status("barrier").get("divine", false)),
		"...and the hop is a Divine Shield too")
	# THE REMAINING HOPS, then the chain STOPS. The hop count is what bounds it,
	# which is why there is no re-entrancy lock.
	#
	# BATCH CQ §3 — WALKED RATHER THAN UNROLLED. This was written out hop by
	# hop for a two-pass Mantle; CN §3 folded the perfect's third pass into the
	# base, and an unrolled chain needs a new stanza every time that number
	# moves. Driven off MANTLE_HOPS_TEST it asks the same question at any
	# count: each hop arrives carrying one fewer, and the shield dies with the
	# last of them.
	var carrier: BattleUnit = second
	var hops_left: int = MANTLE_HOPS_TEST - 1
	while hops_left > 0:
		carrier.take_hit(carrier.status_power("barrier"), 0)
		var nxt: BattleUnit = null
		for h in scene.get("heroes"):
			if h.has_status("barrier"):
				nxt = h
		hops_left -= 1
		ok(nxt != null and nxt != carrier,
			"it passes again (%d pass(es) still owed)" % hops_left)
		if nxt == null:
			scene.queue_free()
			return
		ok(int(nxt.get_status("barrier").get("mantle", 0)) == hops_left,
			"...and arrives carrying %d pass(es) (%d)" % [
				hops_left, int(nxt.get_status("barrier").get("mantle", 0))])
		carrier = nxt
	carrier.take_hit(carrier.status_power("barrier"), 0)
	var fourth := 0
	for h in scene.get("heroes"):
		if h.has_status("barrier"):
			fourth += 1
	ok(fourth == 0, "the chain STOPS when its count runs out (%d shields left)"
		% fourth)
	scene.queue_free()
	await process_frame


# ---------- OCCULTIST ----------

func _live_breaking_darkness() -> void:
	var scene := await _spawn("occultist")
	var occ := _cleric(scene, "old_gods")
	ok(occ != null, "the Occultist spawned")
	if occ == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	ok(foes.size() >= 2, "two enemies stand")
	var marked: BattleUnit = foes[0]
	var control: BattleUnit = foes[1]
	# Constitution decides the divisor, so both sides are pinned at 100 and the
	# arithmetic below is exact rather than approximate.
	marked.constitution = 100
	control.constitution = 100
	marked.pressure = 0
	control.pressure = 0
	await scene.call("_resolve", occ, _card("Breaking Darkness"), marked, "good")
	# THE CAST'S OWN BREAK IS NOT AMPLIFIED BY ITS OWN MARK. A mark applied one
	# line earlier would read 25 here and the card's headline number would depend
	# on the order of two lines.
	ok(marked.pressure == 20,
		"the cast's own 20 Break lands BEFORE the mark (%d)" % marked.pressure)
	ok(marked.has_status("breaking_darkness"), "...and the mark is on")
	ok(marked.status_power("breaking_darkness") == BREAKING_DARKNESS_BD_PCT_TEST,
		"...carrying %d%% (%d)" % [BREAKING_DARKNESS_BD_PCT_TEST,
			marked.status_power("breaking_darkness")])
	# THE ABBREVIATION MUST NOT BE `BD`. That is this game's shorthand for BREAK
	# DAMAGE in every log line and tooltip it has, so the one abbreviation the
	# name fits best is the one it may not use.
	var bsrc := _src("res://scripts/battle.gd")
	var row_at := bsrc.find('"breaking_darkness": [')
	ok(row_at > 0, "the status has a STATUS_INFO row")
	var row := bsrc.substr(row_at, 90)
	ok(not row.contains('"BD"'),
		"the chip is not `BD` — that is Break damage everywhere else")
	ok(row.contains('"Dk!"'), "...it is `Dk!` (%s)" % row.substr(0, 60))
	# THE SAME BLOW INTO BOTH. This is the whole card and it is exact.
	marked.pressure = 0
	control.pressure = 0
	marked.take_hit(0, 20)
	control.take_hit(0, 20)
	ok(control.pressure == 20, "the unmarked control takes 20 (%d)"
		% control.pressure)
	ok(marked.pressure == 25, "the marked one takes 25 — 25%% harder (%d)"
		% marked.pressure)
	# IT AMPLIFIES EVERY SOURCE, not just an attack: a Decay tick through the
	# same door reads the same multiplier.
	marked.pressure = 0
	control.pressure = 0
	marked.take_hit(0, 40)
	control.take_hit(0, 40)
	ok(marked.pressure == 50 and control.pressure == 40,
		"a 40-point source lands 50 against 40 (%d / %d)"
			% [marked.pressure, control.pressure])
	# AND IT IS AN AFFLICTION, so a Mage's Dispel cannot strip the party's work.
	ok(not scene.call("_dispellable_buffs", marked).has("breaking_darkness"),
		"Dispel cannot take the mark off the enemy wearing it")
	scene.queue_free()
	await process_frame


func _live_requiem() -> void:
	var scene := await _spawn("occultist", ["raider", "raider", "archer"])
	var occ := _cleric(scene, "old_gods")
	if occ == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var small: BattleUnit = foes[0]
	var big: BattleUnit = foes[1]
	# Identical bodies, no armor and no shadow resist: the only thing that
	# differs between the two casts is the depth of the pile.
	for e in [small, big]:
		e.armor = 0.0
		e.resists = {}
		e.max_hp = 4000
		e.hp = 4000
		e.constitution = 100
	scene.call("_gain_ruin", small, 5)
	scene.call("_gain_ruin", big, 20)
	ok(small.status_stacks("ruin") == 5, "a five-deep mark (%d)"
		% small.status_stacks("ruin"))
	ok(big.status_stacks("ruin") == 20, "and a twenty-deep one (%d)"
		% big.status_stacks("ruin"))
	# A TWENTY-DEEP PILE IS PRIMED, which is exactly the case the primer clause
	# exists for: a mark left primed would detonate for a full 90% of Attack at
	# its next turn off a pile that no longer exists.
	ok(big.has_status("ruin_primed"), "...and the deep one is PRIMED")
	# A damaged ally, so the party heal is measurable rather than overhealed.
	var ally: BattleUnit = _allies(scene, occ)[0]
	ally.hp = 1
	_seeded()
	var hp0: int = small.hp
	await scene.call("_resolve", occ, _card("Requiem"), small, "good")
	var dmg5: int = hp0 - small.hp
	ok(small.status_stacks("ruin") == 0, "the pile is SPENT (%d)"
		% small.status_stacks("ruin"))
	_seeded()
	var hp1: int = big.hp
	ally.hp = 1
	await scene.call("_resolve", occ, _card("Requiem"), big, "good")
	var dmg20: int = hp1 - big.hp
	ok(big.status_stacks("ruin") == 0, "...and so is the deep one")
	ok(not big.has_status("ruin_primed"),
		"...and the PRIMER goes with it, so nothing detonates off an empty mark")
	ok(dmg20 > dmg5, "twenty stacks hit harder than five (%d against %d)"
		% [dmg20, dmg5])
	var ratio := float(dmg20) / maxf(float(dmg5), 1.0)
	ok(ratio > 3.5 and ratio < 4.5,
		"...and the damage is LINEAR in the stacks (ratio %.2f, want 4.0)" % ratio)
	# THE PARTY HEAL IS REQUIEM'S OWN 2% A STACK, NOT THE DETONATION'S 25% EACH.
	# That is the number that tells a spend from a detonation.
	var want := maxi(int(round(occ.max_hp * 0.02 * 20)), 1)
	ok(ally.hp - 1 == want,
		"the party is mended 2%% of his maximum per stack — %d (got %d)"
			% [want, ally.hp - 1])
	# THE GATE: with no mark on the field there is nothing to sing out. The
	# cooldown is cleared first for BV's NC1 reason — otherwise the refusal would
	# come from the two casts above and the check would measure nothing.
	var clean: BattleUnit = foes[2]
	clean.remove_status("ruin")
	occ.cooldowns.clear()
	ok(not scene.call("_ability_usable", occ, _card("Requiem")),
		"the card is refused once no Ruin stands anywhere")
	scene.call("_gain_ruin", clean, 3)
	occ.cooldowns.clear()
	ok(scene.call("_ability_usable", occ, _card("Requiem")),
		"...and allowed again the moment a mark exists")
	scene.queue_free()
	await process_frame


func _live_penance() -> void:
	# REPLACED BY BATCH CG §3 — PENANCE IS A MIRROR, NOT A TICK. CE's section
	# drove a snapshot off the target's own Attack and asserted the snapshot rule
	# held; both the stat and the rule are gone, so what is driven here is the
	# damage the enemy DEALS coming back to it.
	var scene := await _spawn("occultist")
	var occ := _cleric(scene, "old_gods")
	if occ == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var biter: BattleUnit = foes[0]
	var bystander: BattleUnit = foes[1]
	var ally: BattleUnit = _allies(scene, occ)[0]
	for e in [biter, bystander]:
		e.resists = {}
		e.max_hp = 2000
		e.hp = 2000
	ally.max_hp = 2000
	ally.hp = 2000
	ally.armor = 0.0
	ally.remove_status("barrier")
	await scene.call("_resolve", occ, _card("Penance"), biter, "good")
	ok(biter.has_status("penance"), "the penance is set on the biter")
	ok(biter.status_power("penance") == int(round(PENANCE_MIRROR_TEST * 100.0)),
		"...carrying the SHARE (%d%%) rather than a snapshotted tick (%d)"
			% [int(round(PENANCE_MIRROR_TEST * 100.0)),
				biter.status_power("penance")])
	# NOTHING IS SNAPSHOTTED AND NOTHING READS THE ENEMY'S SHEET. `tick` is the
	# field the old snapshot rode; a version that kept it would pass the mirror
	# checks below and quietly still be reading a stat.
	ok(int(biter.get_status("penance").get("tick", 0)) == 0,
		"...and no snapshot rides the status at all (%d)"
			% int(biter.get_status("penance").get("tick", 0)))
	# 1) THE MIRROR. The frame names the biter as the dealer, exactly as
	# `_resolve` sets it for a real swing, and the blow is driven through the ONE
	# damage door so what is measured is the mechanism rather than a copy of it.
	var biter_hp: int = biter.hp
	scene.call("_dmg_frame", biter, "Strike")
	ally.take_hit(100, 0)
	ok(biter_hp - biter.hp == int(round(100 * PENANCE_MIRROR_TEST)),
		"the biter pays %d for a 100-point blow (%d)"
			% [int(round(100 * PENANCE_MIRROR_TEST)), biter_hp - biter.hp])
	# 2) WHOEVER IT HITS. A blow landing on one of its OWN — a Feint redirect, a
	# Bewitch, a Psychosis — bills it just the same, and this is the check a
	# mirror written below the hero gate fails while passing everything else.
	bystander.hp = 2000
	biter_hp = biter.hp
	scene.call("_dmg_frame", biter, "Strike")
	bystander.take_hit(100, 0)
	ok(biter_hp - biter.hp == int(round(100 * PENANCE_MIRROR_TEST)),
		"...and pays the same when it hits one of its own (%d)"
			% (biter_hp - biter.hp))
	# 3) IT SCALES WITH WHAT WAS ACTUALLY DEALT, not with a stored figure. A
	# snapshot returns the same number twice and fails here.
	biter_hp = biter.hp
	scene.call("_dmg_frame", biter, "Strike")
	ally.take_hit(200, 0)
	ok(biter_hp - biter.hp == int(round(200 * PENANCE_MIRROR_TEST)),
		"twice the blow is twice the penance (%d)" % (biter_hp - biter.hp))
	# 4) AN UNMARKED ENEMY PAYS NOTHING — the control that stops every check
	# above passing off a mirror that bills whoever swung.
	bystander.remove_status("penance")
	var by_hp: int = bystander.hp
	scene.call("_dmg_frame", bystander, "Strike")
	ally.take_hit(100, 0)
	ok(bystander.hp == by_hp,
		"an unmarked enemy pays nothing for the same blow (%d)" % bystander.hp)
	# 5) AN ENEMY THAT DOES NOT ATTACK PAYS NOTHING AT ALL. The guaranteed floor
	# the snapshot bought is gone, knowingly — a hero striking THROUGH the mark
	# is not the mark dealing damage.
	biter_hp = biter.hp
	scene.call("_dmg_frame", occ, "Shadowrend")
	biter.take_hit(100, 0)
	ok(biter_hp - biter.hp == 100,
		"a blow INTO the mark is not a blow BY it — no mirror (%d)"
			% (biter_hp - biter.hp))
	# 6) THE MIRROR DOES NOT MIRROR. Its own payment is damage the marked enemy
	# takes, and without the re-entrancy lock it would bill itself forever.
	biter_hp = biter.hp
	scene.call("_dmg_frame", biter, "Strike")
	ally.take_hit(100, 0)
	ok(biter_hp - biter.hp == int(round(100 * PENANCE_MIRROR_TEST)),
		"the mirror pays exactly once (%d)" % (biter_hp - biter.hp))
	# 7) SELF-INFLICTED IS EXCLUDED BY IDENTITY: recoil and Blood Price are
	# damage a unit deals to ITSELF, and "whoever it hits" means somebody else.
	biter_hp = biter.hp
	scene.call("_dmg_frame", biter, "Recoil")
	biter.take_hit(100, 0)
	ok(biter_hp - biter.hp == 100,
		"a self-inflicted wound is not billed twice (%d)" % (biter_hp - biter.hp))
	scene.queue_free()
	await process_frame
