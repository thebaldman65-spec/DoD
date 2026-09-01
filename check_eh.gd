# BATCH EH — THE THIRD TIER, AND A SWEEP FOR PRECEDENT THAT WAS NEVER TRUE.
#
#   §1  the award chain's three tiers, DRIVEN LIVE on real zone bosses
#   §2  every spec's depth across all three tiers, under a FULLY-HELD loadout
#   §3  the three things EG left on the record, re-derived rather than quoted
#   §4  the `master.html` sweep — is any useful subset mechanically checkable?
#
# **WHY §1 DRIVES A BATTLE INSTEAD OF READING THE CHAIN.** EA's own gate says
# it: the defect the chain exists to close was not a weak grant, it was
# SILENCE — `award_ability_pick` returned false and `_award_ability_picks`
# skipped the hero, so a boss died and the victory card said nothing about
# them. A third tier that resolved correctly and announced nothing would pass
# every static check in this project: the roller is right, the filter is right,
# the chain order is right, and the card stays quiet. **§1 empties two pools on
# four real heroes, resolves a real zone boss, and reads the announcement off
# the end card's own Label** — and it reads the QUEUED OFFER back to prove the
# card that was paid came from the tier the arm was set up to reach, because an
# announcement alone cannot tell three tiers apart.
#
# AND IT IS THREE ARMS RATHER THAN ONE, BECAUSE THE ORDER IS THE RULING. A
# chain that reached the class-wide pool FIRST would pay a weaker card on every
# award and would satisfy any arm that only asked "did something arrive".
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_eh.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const REAL_SAVE := "user://run_save.bin"
const SCRATCH_PROFILE := "user://profile_check_eh.json"

var _g := Gate.new()
var _had_save := false
var _save_backup: PackedByteArray = PackedByteArray()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260831)
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = SCRATCH_PROFILE
	Profile.loaded = false
	Profile.data = {}

	print("BATCH EH — THE THIRD TIER, AND A SWEEP FOR PRECEDENT THAT WAS NEVER TRUE")
	_s2_depth_fully_held()
	_s3_the_record()
	_s4_sweep_instrument()
	await _s1_chain_live()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		if f != null:
			f.store_buffer(_save_backup)
			f.close()
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	_g.report(self)


# ── §1 — THE CHAIN'S THREE TIERS, ON REAL ZONE BOSSES ───────────────────────
# ARM A holds nothing: the offer must come out of the SPEC BOSS pool.
# ARM B holds the whole boss pool: the offer must come out of the SPEC DRAFT
#   pool, which is EA's tier and is asserted here so a repair to the third tier
#   cannot quietly swallow the second.
# ARM C holds both: the offer must come out of the CLASS-WIDE pool, the award
#   must be OWED, and the victory card must NAME the hero. **This is the arm
#   the batch exists for, and it is the one a static check cannot make.**
func _s1_chain_live() -> void:
	print("\n§1 — the award chain's three tiers, driven on real zone bosses")
	var run: Node = root.get_node("/root/Run")
	var party := ["swordmaster", "cryomancer", "inquisitor", "mystic"]
	await _arm(run, "A", party, false, false, "spec boss pool")
	await _arm(run, "B", party, true, false, "spec DRAFT pool")
	await _arm(run, "C", party, true, true, "CLASS-WIDE pool")


# ONE ARM. `hold_boss` and `hold_draft` say which pools the party walks in
# holding, which is the only thing that differs between the three — a shared
# body rather than three copies, so an assertion added to one is added to all.
# It returns nothing (`-> void`): §3b's rule is about functions that RETURN a
# corpus, and this reads three ability families.
func _arm(run: Node, arm: String, party: Array, hold_boss: bool,
		hold_draft: bool, expect: String) -> void:
	var scene: Node = await Gate.spawn(self, party)
	ok(Gate.flags_are_inert(scene),
		"§1%s: the fixture's headless premise still holds" % arm)
	run.zone_bosses_cleared = 0
	for m in run.party:
		var sp := String(m["spec"])
		var held: Array = []
		if hold_boss:
			held.append_array(Classes.spec_pool(sp))
		if hold_draft:
			held.append_array(Classes.spec_draft_pool(sp))
		m["bm_abilities"] = held.duplicate()
		m.erase("bm_equipped")
		m["bm_candidates"] = []
		m["bm_picks_owed"] = 0
	# THE ARM'S PREMISE, ASSERTED BEFORE IT IS DRIVEN. An arm whose earlier
	# tiers are not actually dry proves nothing about the tier it names.
	for m2 in run.party:
		var sp2 := String(m2["spec"])
		ok((run.roll_spec_ability_offer(m2) as Array).is_empty() == hold_boss,
			"§1%s: %s's boss pool is not in the state the arm requires" % [arm, sp2])
		ok((run.roll_spec_fallback_offer(m2) as Array).is_empty() == hold_draft,
			"§1%s: %s's spec draft pool is not in the state the arm requires" % [arm, sp2])
	scene.call("_resolve_boss", 120, false)
	await process_frame

	# (1) THE ANNOUNCEMENT, OFF THE CARD'S OWN LABEL.
	var txt := _label_text(scene, "NEW ABILITY")
	ok(txt != "",
		"§1%s: the victory card does not announce the award — this is the SILENCE the chain exists to end" % arm)
	for m3 in run.party:
		ok(txt.contains(String(scene.call("_hero_label", m3))),
			"§1%s: the card does not name the %s" % [arm, m3["spec"]])
		ok(int(m3.get("bm_picks_owed", 0)) == 1,
			"§1%s: %s was not owed the pick the card just promised" % [arm, m3["spec"]])

	# (2) AND THE CARD THAT WAS PAID CAME OUT OF THE TIER THIS ARM REACHES.
	# The announcement cannot tell three tiers apart; the queued offer can.
	for m4 in run.party:
		var sp4 := String(m4["spec"])
		var q: Array = m4.get("bm_candidates", [])
		ok(q.size() == 1 and (q[0] as Array).size() > 0,
			"§1%s: %s's offer was never queued" % [arm, sp4])
		if q.size() != 1:
			continue
		var wanted: Array = Classes.spec_pool(sp4)
		if hold_draft:
			wanted = Classes.class_draft_pool(Classes.class_of_spec(sp4))
		elif hold_boss:
			wanted = Classes.spec_draft_pool(sp4)
		var stray: Array = []
		for n in q[0]:
			if not wanted.has(String(n)):
				stray.append(String(n))
		ok(stray.is_empty(),
			"§1%s: %s was paid %s, which is not in the %s the arm reaches" % [
				arm, sp4, stray, expect])
		# **THE OFFER IS THREE, OR IT IS EVERYTHING THE TIER HAD.** Written as
		# a full three first and repaired to intent: the Devout's boss pool is
		# TWO cards, so arm A's tier fills SHORT — which is AP §3's shipped rule
		# ("fill short rather than pad with repeats") doing exactly its job, not
		# a defect. Asserting a flat 3 would have made the one spec this whole
		# thread was written for the one spec the gate could not measure.
		var left := 0
		for w in wanted:
			if not (m4["bm_abilities"] as Array).has(String(w)):
				left += 1
		ok(int((q[0] as Array).size()) == mini(3, left),
			"§1%s: %s was offered %d cards out of a tier holding %d — the offer is neither full nor short-by-the-rule" % [
				arm, sp4, int((q[0] as Array).size()), left])
	print("    %s: %s → %s offered %s" % [arm, expect,
		run.party[0]["spec"], run.party[0].get("bm_candidates", [[]])[0]])
	scene.queue_free()
	await process_frame
	await process_frame


func _label_text(n: Node, needle: String) -> String:
	if n is Label and String((n as Label).text).contains(needle):
		return String((n as Label).text)
	for c in n.get_children():
		var r := _label_text(c, needle)
		if r != "":
			return r
	return ""


# ── §2 — EVERY SPEC'S DEPTH ACROSS ALL THREE TIERS, FULLY HELD ──────────────
# **DERIVED THROUGH THE LIVE ROLLERS RATHER THAN OFF A TABLE.** `check_ea` §1
# measures the depth arithmetically and asserts the LOADOUT bound; this asks
# the same question of the functions themselves, on a member dict built to the
# worst case the brief names — a hero who holds his entire boss pool AND his
# entire spec draft pool. A table can be right about a pool the code no longer
# reads; a roller cannot.
#
# **AND IT STATES THE ANSWER PLAINLY, WHICH IS THE HALF THE BRIEF ASKED FOR.**
# Under a fully-held loadout the class-wide tier pays a full three to every one
# of the twelve. Under a fully-held POOL — the same hero having also taken every
# class-wide card — the chain pays nothing, and that state is REACHABLE rather
# than impossible. It is asserted in both directions, because "the third tier
# closes the table" is exactly the shape of claim EA made about the second one
# and had to give back a batch later.
func _s2_depth_fully_held() -> void:
	print("\n§2 — every spec's depth across all three tiers, under a fully-held loadout")
	var run: Node = root.get_node("/root/Run")
	var paid_all := 0
	var starved := 0
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			var wide: Array = Classes.class_draft_pool(String(cls))
			# FULLY-HELD LOADOUT: boss pool + spec draft pool, nothing else.
			# `key` IS THE CLASS AND IT IS NOT OPTIONAL: `owned_ability_names`
			# reaches `Runes.kit_names`, which builds the hero's config from it.
			# A member without one throws rather than measuring a shallower
			# pool, which is the failure mode worth having.
			var m := {"key": String(cls), "spec": spec, "bm_abilities":
				Classes.spec_pool(spec).duplicate()
				+ Classes.spec_draft_pool(spec).duplicate()}
			var t1: Array = run.roll_spec_ability_offer(m)
			var t2: Array = run.roll_spec_fallback_offer(m)
			var t3: Array = run.roll_class_fallback_offer(m)
			ok(t1.is_empty(), "§2: %s's boss tier is not dry under a fully-held loadout" % spec)
			ok(t2.is_empty(), "§2: %s's spec draft tier is not dry under a fully-held loadout" % spec)
			ok(t3.size() == 3,
				"§2: %s's class-wide tier pays %d cards, not three, to a fully-held hero" % [
					spec, t3.size()])
			if t3.size() == 3:
				paid_all += 1
			# AND THE STATE THE THIRD TIER DOES *NOT* CLOSE.
			var m2 := {"key": String(cls), "spec": spec, "bm_abilities":
				(m["bm_abilities"] as Array).duplicate() + wide.duplicate()}
			var t3b: Array = run.roll_class_fallback_offer(m2)
			ok(t3b.is_empty(),
				"§2: %s's class-wide tier still pays a hero who holds every card in it — the filter is not reading the pool" % spec)
			if t3b.is_empty():
				starved += 1
			print("    %-13s fully-held loadout → tier3 offers %d of %d class-wide; +class held → %d" % [
				spec, t3.size(), wide.size(), t3b.size()])
	ok(paid_all == 12,
		"§2: only %d of the twelve specs are paid a full three under a fully-held loadout" % paid_all)
	ok(starved == 12,
		"§2: only %d of the twelve go quiet when the class pool is held too — the worst case is not what this gate thinks it is" % starved)
	print("  PLAINLY: under a fully-held LOADOUT no hero can be paid nothing — all twelve are offered a full three off the class-wide tier.")
	print("  PLAINLY: under a fully-held POOL every hero CAN still be paid nothing. The third tier deepens the floor; it does not remove it.")


# ── §3 — THE THREE THINGS EG LEFT ON THE RECORD ─────────────────────────────
# Confirmed, not reopened — and re-derived here rather than quoted, which is
# the difference between a record and a rumour.
func _s3_the_record() -> void:
	print("\n§3 — the three things EG left on the record")
	var run: Node = root.get_node("/root/Run")

	# (1) THE TWO NUMBERS DISAGREE ON ALL TWELVE, AND THE LADDER READS
	# `core_slots`. EG established the disagreement; what was owed is WHICH one
	# the ladder reads and that nothing else reads the other.
	var disagree := 0
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			if Classes.core_slots(spec) != Classes.protected_names(spec).size():
				disagree += 1
	ok(disagree == 12,
		"§3: %d of the twelve specs disagree between `core_slots` and `protected_names`, not all twelve" % disagree)
	var rs := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	var used := rs.find("func ability_slots_used")
	ok(used >= 0, "§3: `ability_slots_used` is gone — the cap has moved")
	var ubody := rs.substr(used, 220)
	ok(ubody.contains("Classes.core_slots(spec)"),
		"§3: the CAP no longer reads `core_slots` — EG's finding has inverted")
	ok(not ubody.contains("protected_names"),
		"§3: the CAP reads `protected_names` now — it is a NAME count and the cap is a SLOT count")
	var capf := rs.find("func ability_slot_cap")
	var cbody := rs.substr(capf, 200)
	ok(not cbody.contains("core_slots") and not cbody.contains("protected_names"),
		"§3: the LADDER reads a core count — it is indexed by zone bosses cleared and nothing else")
	# AND NOTHING ELSE IN `scripts/` READS THE OTHER. One live reader, and it is
	# the loadout panel's CORE rows — the list that cannot be benched, which is
	# what a NAME count is for.
	var readers: Array = []
	var dir := DirAccess.open("res://scripts")
	if dir != null:
		for f in dir.get_files():
			if not f.ends_with(".gd"):
				continue
			var src := Gate.strip_comments(
				FileAccess.get_file_as_string("res://scripts/" + f))
			if src.contains("protected_names("):
				readers.append(f)
	readers.sort()
	ok(readers == ["classes.gd", "map_screen.gd"],
		"§3: `protected_names` is read by %s, not by its definition and the loadout panel alone" % [readers])

	# (2) ALL SEVEN ENABLERS ARE PROTECTED — AND THE TWO CORRECTED REASONS ARE
	# ASSERTED AS FACTS, NOT LEFT IN PROSE. A right conclusion resting on a
	# wrong reason is the next brief's false precedent, so the reasons are
	# pinned where they can go red.
	var enablers := 0
	for cls2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[cls2]:
			var prot: Array = Classes.protected_names(spec2)
			for e in Classes.core_enablers(spec2):
				enablers += 1
				ok(prot.has(String(e)),
					"§3: %s's enabler %s is NOT in `protected_names` — it is a live brick" % [
						spec2, e])
	# **AND THE POPULATION IS 16, NOT THE SEVEN ON RECORD — WHICH IS THE THIRD
	# TIME THIS SHAPE HAS FIRED.** EG's record reads "all seven named enablers
	# are in `protected_names` for their spec", and every word of that is true:
	# it audited Quick Shot, Consecrated Ground, Heal, the three summons and
	# Guard Change, the seven the brief named. **`PROTECTED_CORES` names SIXTEEN
	# across NINE specs** — Fireball, Detonation, Frostbolt, Ice Lance, Arcane
	# Explosion, Hymn of Hope, Divine Shield, Shadowrend and Hex of Ruin were
	# outside the list and so outside the audit. All sixteen are protected, so
	# the CONCLUSION held; what did not is the sweep. `CLAUDE.md`'s own rule
	# names the shape: **a named list cannot audit itself — run the sweep over
	# the whole population, not over the names the brief supplies.** Pinned as
	# the derived count so a seventeenth enabler joins the audit by being
	# authored.
	ok(enablers == 16,
		"§3: %d named enablers across the twelve, not the 16 the table actually holds" % enablers)
	# REASON ONE: Heal is one of FIVE Mercy outlets, not Mercy's only outlet.
	var bs := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var emp := bs.find("func _consume_empower")
	ok(emp >= 0, "§3: `_consume_empower` is gone — the Mercy-outlet count is unmeasured")
	var ebody := bs.substr(emp, 900)
	var outlets := 0
	for sid in ["holy_heal", "renewal", "hymn", "resurrection", "divine_plea"]:
		if ebody.contains("\"%s\"" % sid):
			outlets += 1
	ok(outlets == 5,
		"§3: `_consume_empower` accepts %d Mercy outlets, not the 5 EG corrected the brief to" % outlets)
	# REASON TWO: every single-target attack the Sharpshooter makes generates
	# Focus — the generator is the RESOURCE NAME and the safe-list, never the
	# card. Quick Shot is his only FREE every-turn one, which is a different
	# claim and is the one `PROTECTED_CORES` already makes.
	var sf := bs.find("func _sharpshooter_focus")
	ok(sf >= 0, "§3: `_sharpshooter_focus` is gone — the Focus reason is unmeasured")
	var sbody := bs.substr(sf, 700)
	ok(not sbody.contains("Quick Shot"),
		"§3: the Focus generator names Quick Shot — the brief's wrong reason has become the code")

	# (3) `decline_draft` IS THE LEDGER'S ONLY WRITER, AND BENCHING WRITES NO
	# LEDGER. Driven on a real member rather than read off the source: a bench
	# that wrote the ledger would keep the card off every future offer, which is
	# the exact behaviour EG §2 removed.
	ok(rs.count("_refuse_draft(") == 2,
		"§3: `_refuse_draft` has %d mentions in the stripped source — one definition and one caller is the rule" % rs.count("_refuse_draft("))
	var dec := rs.find("func decline_draft")
	var dbody := rs.substr(dec, 500)
	ok(dbody.contains("_refuse_draft("),
		"§3: `decline_draft` no longer writes the ledger")
	var m3 := {"key": "warrior", "spec": "berserker",
		"bm_abilities": [], "bm_equipped": []}
	var card := String(Classes.spec_draft_pool("berserker")[0])
	run.hold_ability(m3, card, true)
	ok(run.equipped_ability_names(m3).has(card), "§3: the card was not taken")
	ok(run.unequip_earned_ability(m3, card), "§3: the card could not be benched")
	ok(run.draft_refused(m3).is_empty(),
		"§3: BENCHING wrote the no-return ledger — a benched card is being refused, not kept")
	ok((m3["bm_abilities"] as Array).has(card),
		"§3: benching removed the card from the POOL — a bench is a drop again")
	ok(run.owned_ability_names(m3).has(card),
		"§3: a benched card is no longer OWNED — it can be offered back as new")


# ── §4 — THE `master.html` SWEEP: COULD IT BE AN INSTRUMENT? ────────────────
# **A REPORT. IT ASSERTS NOTHING ABOUT THE DOCUMENT AND RULES ON NOTHING.**
# §2 of the brief asks whether any useful SUBSET of "claims of fact about how
# the game works" is mechanically checkable, and the honest answer is a
# measurement rather than an opinion: how many of the document's uniqueness
# claims name something the code can be asked about, and how many are prose a
# machine cannot settle.
#
# THE TWO NUMBERS PRINTED HERE ARE THE WHOLE ANSWER. EB declined to gate the
# header sweep at 118 rows for 16 defects; the ratio below is this sweep's
# equivalent, and it is measured on the repaired document so it is a floor for
# what a gate would have to wade through rather than a count of today's bugs.
func _s4_sweep_instrument() -> void:
	print("\n§4 — the `master.html` sweep as a candidate instrument (REPORT ONLY)")
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	ok(doc != "", "§4: `master.html` is readable")
	# Every ability display name in the game, so "does this claim name something
	# the code knows about" can be asked at all.
	var known := {}
	for ab in Classes.ability_corpus():
		known[String(ab.display_name)] = true
	var claim := RegEx.new()
	claim.compile("(?i)(the only|no other|nothing else|the sole|the first and only)")
	var tag := RegEx.new()
	tag.compile("<[^>]*>")
	var total := 0
	var named := 0
	for raw in doc.split("\n"):
		var line := tag.sub(String(raw), " ", true)
		for m in claim.search_all(line):
			total += 1
			var a: int = maxi(0, m.get_start() - 120)
			var window := line.substr(a, 320)
			for nm in known:
				if window.contains(nm):
					named += 1
					break
	print("  %d uniqueness claims in the document; %d name a live ability the code can be asked about" % [
		total, named])
	print("  RULED ON NOTHING. A claim naming an identifier is checkable; a claim about a DESIGN")
	print("  relation ('the only Break lever the class has') names one too and is not, which is why")
	print("  the ratio above is an upper bound on a gate's signal and not its yield.")
