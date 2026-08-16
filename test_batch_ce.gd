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

const REAL_SAVE := "user://run_save.bin"

# Mirrored from battle.gd so each check states what it depends on rather than
# hiding it inside a magic number.
const ALMS_WARD_PCT_TEST := 12
const ELEVATION_FLOOR_TEST := 3
const JUBILEE_MIN_FAITH_TEST := 3
const MANTLE_HOPS_TEST := 2
const ANATHEMA_BD_PCT_TEST := 50
const PENANCE_SHARE_TEST := 0.20

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The nine, transcribed once: name -> [spec, cost, delay, cooldown, break].
# This table is the machine-checkable half of "the batch shipped what it said".
const NINE := {
	"Matins":     ["holy", 20, 2.0, 4, 0],
	"Alms":       ["holy", 20, 2.0, 4, 0],
	"Observance": ["holy", 25, 2.0, 5, 0],
	"Elevation":  ["inquisitor", 30, 2.5, 5, 0],
	"Jubilee":    ["inquisitor", 20, 2.0, 4, 0],
	"Mantle":     ["inquisitor", 25, 2.5, 4, 0],
	"Anathema":   ["occultist", 25, 2.0, 4, 20],
	"Requiem":    ["occultist", 30, 3.0, 5, 8],
	"Penance":    ["occultist", 25, 2.5, 4, 0],
}

# THE DEVOUT'S POOL KEY IS `inquisitor` AND NOT `devout`, and it is pinned here
# rather than left to the table above: `SPEC_INFO["inquisitor"]` carries the
# display name "Devout" and master.html's draft table prints "Devout", so the
# docs and the code disagree BY DESIGN. A `"devout"` key would raise nothing,
# resolve nothing, and ship three cards no hero could ever be offered.
const DEVOUT_KEY := "inquisitor"


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

	await _live_matins()
	await _live_alms()
	await _live_observance()
	await _live_elevation()
	await _live_jubilee()
	await _live_mantle()
	await _live_anathema()
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
	for n in ["Elevation", "Jubilee", "Mantle"]:
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
			"holy", "inquisitor", "occultist"]:
		var pool: Array = Classes.spec_draft_pool(spec)
		ok(pool.size() == 8, "%s drafts EIGHT (got %d)" % [spec, pool.size()])
		var seen := {}
		for n in pool:
			seen[String(n)] = 1
		ok(seen.size() == pool.size(),
			"%s's pool holds no duplicate — a repeat keeps the count and changes the draft" % spec)
	for spec in ["beastmaster", "sharpshooter", "mystic",
			"berserker", "warden", "swordmaster"]:
		ok(Classes.spec_draft_pool(spec).size() == 5,
			"%s is still at FIVE — its third of tranche 3 is owed" % spec)
	var total := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		total += Classes.spec_draft_pool(spec).size()
	ok(total == 78, "the spec pools hold 78 (69 + this batch's nine), got %d"
		% total)
	ok(total == 6 * 8 + 6 * 5, "...which is six at eight and six at five")
	var draft_total := total
	for cls in Classes.CLASS_DRAFT_POOLS:
		draft_total += Classes.class_draft_pool(cls).size()
	ok(draft_total == 102, "the draft holds 102 of a target 120 (got %d)"
		% draft_total)
	ok(120 - draft_total == 18,
		"18 are owed — the Hunter and Warrior thirds of tranche 3")
	ok(96 - total == 18, "...and every one of them is a SPEC card")
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
		ok(ab.perfect_text != "", "...and a perfect (%s)" % n)
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
	# as a tick on the enemy's own clock, where Break has nothing to ride.
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
	for n in ["Matins", "Alms", "Observance", "Elevation", "Jubilee"]:
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
	# not an ability name and nothing resolves it, so a hit here would ship
	# FLAGGED rather than renamed — but there is nothing to flag.
	var node_names := {}
	for spec in Classes.SPEC_IDS:
		for sp in Classes.SPEC_IDS[spec]:
			for node in Talents.generate_tree(String(sp), String(spec)):
				node_names[String(node.get("name", ""))] = 1
	for n in NINE:
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
	for sid in ["anathema", "penance"]:
		ok(BattleUnit.DEBUFF_IDS.has(sid),
			"`%s` sits on an ENEMY and is listed in DEBUFF_IDS" % sid)
	# THE OTHER THREE SIT ON HOLY and are correctly absent — a hero-side buff in
	# that list would be a hero-side buff a Cleansing Rite could take.
	for sid in ["matins", "alms", "observance"]:
		ok(not BattleUnit.DEBUFF_IDS.has(sid),
			"`%s` sits on HOLY and is NOT in DEBUFF_IDS" % sid)
	# MANTLE HAS NO STATUS ID OF ITS OWN, deliberately: it rides the existing
	# `barrier`, which is what makes every hop a REAL Divine Shield for
	# Conviction rather than a private ward that builds no Faith.
	var bsrc := _src("res://scripts/battle.gd")
	ok(not bsrc.contains('"mantle": ['),
		"Mantle registers no status of its own — it rides `barrier`")
	for sid in ["matins", "alms", "observance", "anathema", "penance"]:
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
			"...with the bigger Empowered share written LAST, so Observance can never downgrade it")
	ok(src.contains("_observance_pay(attacker)"),
		"the Empower's perfect is decided at ONE site")


func _docs() -> void:
	var doc := _src("res://docs/master.html")
	ok(doc != "", "master.html is readable")
	ok(doc.contains("Last updated: 2026-08-16 (Batch CE)"),
		"master.html carries this batch's stamp")
	ok(doc.contains("102 of 120") or doc.contains("102 of a target 120"),
		"master.html states the LIVE draft count against the REAL target")
	for n in NINE:
		ok(doc.contains(n), "master.html's draft table lists %s" % n)
	ok(doc.contains("Devout"),
		"...and the table still PRINTS 'Devout' for the `inquisitor` pool")
	var cm := _src("res://CLAUDE.md")
	ok(cm.contains("BATCH CE"), "CLAUDE.md carries the batch block")
	ok(cm.contains("SECOND CLASS COMPLETE") or cm.contains("second complete class")
		or cm.contains("SECOND COMPLETE CLASS"),
		"...and records that the Cleric is the second class complete")
	var notes := _src("res://docs/design-notes.md")
	ok(notes.contains("Batch CE"), "design-notes.md carries a why entry")
	var gl := _src("res://data/glossary.json")
	ok(gl.contains("mercy_window"),
		"the glossary teaches the Mercy window a player meets in Matins and Alms")
	ok(gl.contains("GUARDIAN ANGEL WIDENS THAT WINDOW"),
		"...including that the line moves")
	# THE ENTRY IS THE ONLY ONE ADDED. CB added one for the same reason: the
	# glossary teaches what a player has nowhere else to learn, not every status.
	var gj: Array = JSON.parse_string(gl)
	ok(gj != null and gj.size() == 91,
		"the glossary holds 91 entries (90 + this batch's one)")
	var log_live := _src("res://docs/changelog.html")
	ok(log_live.contains("Batch CE"), "the changelog carries a Batch CE entry")
	ok(log_live.contains("102"), "...and states the new draft count")


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
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", spec, "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	# BU'S HARNESS FAULT, AND IT BIT THIS SUITE'S FIRST DRAFT EXACTLY AS BU
	# PREDICTED IT WOULD. `_run_battle` OPENS WITH `await _wait(0.6)` ON A REAL
	# SceneTreeTimer, and its opening block runs `_reset_faith_meters()` — which
	# zeroes every Faith count AND peak. Setting Faith after twenty frames and
	# then awaiting a cast has the values wiped out from under it, and it reads
	# as a magnitude bug: Elevation's untouched-peak check came back 3 instead
	# of 4 and Jubilee's ratio read 61 instead of 1.67.
	# `Engine.time_scale` scales those timers and NOTHING the battle computes.
	Engine.time_scale = 50.0
	for _i in 90:
		await process_frame
	Engine.time_scale = 1.0
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline).
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0
	return scene


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

func _live_matins() -> void:
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
	# A TICK WITH NO OFFICE PAYS NOTHING — the control that stops every check
	# below passing off a card that simply grants Mercy every turn.
	scene.call("_matins_tick", holy)
	ok(holy.second_resource == 0, "no office, no Mercy (%d)" % holy.second_resource)
	scene.call("_apply_status", holy, "matins", 9)
	# 1) AN UNBROKEN WATCH PAYS.
	scene.call("_matins_tick", holy)
	ok(holy.second_resource == 1,
		"an unbroken office pays 1 Mercy (%d)" % holy.second_resource)
	# 2) A FALL BREAKS THAT TURN'S WATCH — and the passive pays instead, which
	# is the property that makes the two sources mutually exclusive.
	ally.hp = int(ally.max_hp * 0.4)
	scene.call("_on_hero_below_half", ally)
	ok(holy.second_resource == 2, "the PASSIVE paid for the fall (%d)"
		% holy.second_resource)
	var after_fall: int = holy.second_resource
	scene.call("_matins_tick", holy)
	ok(holy.second_resource == after_fall,
		"...and the broken watch pays NOTHING that turn (%d)" % holy.second_resource)
	# 3) AND ONLY THAT TURN. A latching implementation fails here and passes
	# everything above it.
	scene.call("_matins_tick", holy)
	ok(holy.second_resource == after_fall + 1,
		"the office is kept again the next turn (%d)" % holy.second_resource)
	# At the cap it pays nothing and says so — ALMS is the card that answers
	# that, and this must not become a second spill site.
	holy.second_resource = holy.second_max
	scene.call("_matins_tick", holy)
	ok(holy.second_resource == holy.second_max,
		"at the cap the office earns exactly what the passive would: nothing")
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


func _live_observance() -> void:
	var scene := await _spawn("holy")
	var holy := _cleric(scene, "mercy")
	if holy == null:
		scene.queue_free()
		return
	var ally: BattleUnit = _allies(scene, holy)[0]
	var plea: Ability = Classes.pool_ability("Divine Plea")
	ok(plea != null and plea.faith_cost == 2, "Divine Plea costs 2 Mercy")
	# WITHOUT THE OFFICE: an Empowered PERFECT cast forfeits its perfect, so the
	# 10 Mana never arrives — and exactly 3 Mercy leave her hand (2 + 1).
	holy.second_resource = holy.second_max
	holy.resource = 0
	ally.hp = 1
	var mercy0: int = holy.second_resource
	scene.set("empower_armed", true)
	await scene.call("_resolve", holy, plea, ally, "perfect")
	ok(holy.resource == 0,
		"without Observance the Empowered cast forfeits its perfect (%d Mana)"
			% holy.resource)
	ok(mercy0 - holy.second_resource == 3,
		"...and costs 2 Mercy plus the Empower's 1 (spent %d)"
			% (mercy0 - holy.second_resource))
	# WITH THE OFFICE: both halves move. Either alone would be a half-built card.
	scene.call("_apply_status", holy, "observance", 9)
	holy.second_resource = holy.second_max
	holy.resource = 0
	ally.hp = 1
	var mercy1: int = holy.second_resource
	scene.set("empower_armed", true)
	await scene.call("_resolve", holy, plea, ally, "perfect")
	ok(holy.resource == 10,
		"under Observance the perfect SURVIVES the Empower (+%d Mana)"
			% holy.resource)
	ok(mercy1 - holy.second_resource == 4,
		"...and the second stack is what pays for it (spent %d)"
			% (mercy1 - holy.second_resource))
	# UNPAYABLE IS NOT REFUSED: with no second stack in hand the cast resolves as
	# an ordinary Empower rather than costing her a turn.
	holy.second_resource = 3
	holy.resource = 0
	ally.hp = 1
	scene.set("empower_armed", true)
	await scene.call("_resolve", holy, plea, ally, "perfect")
	ok(holy.second_resource == 0,
		"with exactly the ordinary price in hand the cast still goes off (%d left)"
			% holy.second_resource)
	ok(holy.resource == 0,
		"...as an ordinary Empower, perfect forfeited (%d Mana)" % holy.resource)
	scene.queue_free()
	await process_frame


# ---------- DEVOUT ----------

func _live_elevation() -> void:
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
	high.faith_peak = 4
	# THE ALLY AT TWO IS THE ONLY CONSTRUCTION THAT DISCRIMINATES, AND IT WAS
	# ADDED BECAUSE A NEGATIVE CONTROL PASSED WITHOUT IT — the whole reason to
	# run them. An ADDING version of the write is invisible at both ends: the
	# ally on 4 is skipped by the loop's own `>= floor` guard before the write
	# is ever reached, and the ally on 0 lands on 3 either way. Only a peak
	# BETWEEN the two tells "raised TO the floor" (3) from "raised BY it" (5).
	mid.faith_peak = 2
	await scene.call("_resolve", dv, _card("Elevation"), dv, "good")
	# IT RAISES A FLOOR, NOT A TOTAL.
	ok(high.faith_peak == 4,
		"a peak already ABOVE the floor is untouched (%d)" % high.faith_peak)
	ok(low.faith_peak == ELEVATION_FLOOR_TEST,
		"a peak below it is raised TO the floor (%d)" % low.faith_peak)
	ok(mid.faith_peak == ELEVATION_FLOOR_TEST,
		"a peak of 2 is raised TO %d, not BY it (%d)" % [
			ELEVATION_FLOOR_TEST, mid.faith_peak])
	# AND IT WRITES THE PEAK, NOT THE COUNT. A version that granted Faith would
	# move both, walk allies toward a release and change the whole card.
	for h in scene.get("heroes"):
		if h.is_companion:
			continue
		ok(h.faith_stacks == 0,
			"%s holds no extra stack — Elevation writes the PEAK alone (%d)"
				% [h.unit_name, h.faith_stacks])
	# THE GATE: with every peak at or above the floor there is nothing to raise,
	# so the button is refused rather than spending a turn to print a no-op.
	#
	# THE COOLDOWN IS CLEARED FIRST AND THAT IS BV'S NC1 LESSON, NOT TIDINESS:
	# the cast above started a 5-turn cooldown, so `_ability_usable` would go on
	# refusing for a reason that has nothing to do with the peaks and the check
	# would pass while testing nothing. A check only discriminates once the thing
	# under test is the ONLY thing that can produce the answer.
	dv.cooldowns.clear()
	ok(not scene.call("_ability_usable", dv, _card("Elevation")),
		"the card is refused once every peak stands at the floor")
	low.faith_peak = 0
	dv.cooldowns.clear()
	ok(scene.call("_ability_usable", dv, _card("Elevation")),
		"...and allowed again the moment one falls below it")
	# The perfect raises the floor by one, and never past five.
	for h in scene.get("heroes"):
		h.faith_peak = 0
	await scene.call("_resolve", dv, _card("Elevation"), dv, "perfect")
	ok(low.faith_peak == ELEVATION_FLOOR_TEST + 1,
		"a perfect raises every peak to %d (%d)"
			% [ELEVATION_FLOOR_TEST + 1, low.faith_peak])
	scene.queue_free()
	await process_frame


func _live_jubilee() -> void:
	var scene := await _spawn(DEVOUT_KEY)
	var dv := _cleric(scene, "conviction")
	if dv == null:
		scene.queue_free()
		return
	var jub := _card("Jubilee")
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
	# THE PEAK STANDS. BI's whole repair was that spending must not cost held
	# value; a version that reset the peak passes a bare heal check and deletes
	# the mitigation the Devout had already earned.
	ok(dv.faith_peak == 5, "his PEAK is untouched (%d)" % dv.faith_peak)
	dv.faith_stacks = 5
	dv.hp = 1
	await scene.call("_resolve", dv, jub, dv, "good")
	var healed5: int = dv.hp - 1
	ok(healed5 > healed3,
		"five stacks pay more than three (%d against %d)" % [healed5, healed3])
	var ratio := float(healed5) / maxf(float(healed3), 1.0)
	ok(ratio > 1.4 and ratio < 1.9,
		"...and pay PER STACK rather than flat (ratio %.2f, want ~1.67)" % ratio)
	# IT IS NOT A RELEASE, AND THIS IS THE LOAD-BEARING HALF. A release would
	# grow the principal, roll Communion and swear Binding Oath — the frequency
	# loop BH §2 took the Devout off.
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
		"an ally holding five Faith cannot call the year (%d)" % holy_like.hp)
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
	# SECOND HOP, then the chain STOPS. The hop count is what bounds it, which is
	# why there is no re-entrancy lock.
	second.take_hit(second.status_power("barrier"), 0)
	var third: BattleUnit = null
	for h in scene.get("heroes"):
		if h.has_status("barrier"):
			third = h
	ok(third != null and third != second, "it passes a second time")
	if third == null:
		scene.queue_free()
		return
	ok(int(third.get_status("barrier").get("mantle", 0)) == 0,
		"...and arrives with no passes left (%d)"
			% int(third.get_status("barrier").get("mantle", 0)))
	third.take_hit(third.status_power("barrier"), 0)
	var fourth := 0
	for h in scene.get("heroes"):
		if h.has_status("barrier"):
			fourth += 1
	ok(fourth == 0, "the chain STOPS when its count runs out (%d shields left)"
		% fourth)
	scene.queue_free()
	await process_frame


# ---------- OCCULTIST ----------

func _live_anathema() -> void:
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
	await scene.call("_resolve", occ, _card("Anathema"), marked, "good")
	# THE CAST'S OWN BREAK IS NOT AMPLIFIED BY ITS OWN MARK. A mark applied one
	# line earlier would read 30 here and the card's headline number would depend
	# on the order of two lines.
	ok(marked.pressure == 20,
		"the cast's own 20 Break lands BEFORE the mark (%d)" % marked.pressure)
	ok(marked.has_status("anathema"), "...and the mark is on")
	ok(marked.status_power("anathema") == ANATHEMA_BD_PCT_TEST,
		"...carrying %d%% (%d)" % [ANATHEMA_BD_PCT_TEST,
			marked.status_power("anathema")])
	# THE SAME BLOW INTO BOTH. This is the whole card and it is exact.
	marked.pressure = 0
	control.pressure = 0
	marked.take_hit(0, 20)
	control.take_hit(0, 20)
	ok(control.pressure == 20, "the unmarked control takes 20 (%d)"
		% control.pressure)
	ok(marked.pressure == 30, "the marked one takes 30 — 50%% harder (%d)"
		% marked.pressure)
	# IT AMPLIFIES EVERY SOURCE, not just an attack: a Decay tick through the
	# same door reads the same multiplier.
	marked.pressure = 0
	control.pressure = 0
	marked.take_hit(0, 10)
	control.take_hit(0, 10)
	ok(marked.pressure == 15 and control.pressure == 10,
		"a 10-point source lands 15 against 10 (%d / %d)"
			% [marked.pressure, control.pressure])
	# AND IT IS AN AFFLICTION, so a Mage's Dispel cannot strip the party's work.
	ok(not scene.call("_dispellable_buffs", marked).has("anathema"),
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
	var scene := await _spawn("occultist")
	var occ := _cleric(scene, "old_gods")
	if occ == null:
		scene.queue_free()
		return
	var foes := _live_foes(scene)
	var strong: BattleUnit = foes[0]
	var weak: BattleUnit = foes[1]
	# THE CONSTRUCTION THAT DISCRIMINATES: two Attack stats. A version reading
	# the CASTER's Attack returns the same tick for both and passes every other
	# check in this function.
	strong.attack = 100
	weak.attack = 50
	for e in [strong, weak]:
		e.resists = {}
		e.max_hp = 2000
		e.hp = 2000
	await scene.call("_resolve", occ, _card("Penance"), strong, "good")
	await scene.call("_resolve", occ, _card("Penance"), weak, "good")
	var t_strong := int(strong.get_status("penance").get("tick", 0))
	var t_weak := int(weak.get_status("penance").get("tick", 0))
	ok(t_strong == int(round(100 * PENANCE_SHARE_TEST)),
		"the mighty enemy is set to 20%% of ITS OWN Attack — %d (got %d)"
			% [int(round(100 * PENANCE_SHARE_TEST)), t_strong])
	ok(t_weak == int(round(50 * PENANCE_SHARE_TEST)),
		"...and the weak one to 20%% of ITS OWN — %d (got %d)"
			% [int(round(50 * PENANCE_SHARE_TEST)), t_weak])
	ok(t_strong == 2 * t_weak,
		"...so the tick tracks the TARGET rather than the caster (%d / %d)"
			% [t_strong, t_weak])
	# AND IT BILLS AT THE START OF THE ENEMY'S OWN TURN.
	var hp0: int = strong.hp
	scene.call("_penance_tick", strong)
	ok(hp0 - strong.hp == t_strong,
		"the penance is paid at its own turn start (%d)" % (hp0 - strong.hp))
	# A HERO NEVER PAYS ONE — the tick is enemy-side by its own gate.
	var ally: BattleUnit = _allies(scene, occ)[0]
	scene.call("_apply_status", ally, "penance", 3, 0, 40, occ)
	var ahp: int = ally.hp
	scene.call("_penance_tick", ally)
	ok(ally.hp == ahp, "a hero carrying the status pays nothing (%d)" % ally.hp)
	# The tick is SNAPSHOTTED: weakening the enemy afterwards does not change it.
	strong.attack = 10
	var hp1: int = strong.hp
	scene.call("_penance_tick", strong)
	ok(hp1 - strong.hp == t_strong,
		"the tick was snapshotted at application (%d)" % (hp1 - strong.hp))
	scene.queue_free()
	await process_frame
