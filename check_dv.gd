# BATCH DV — A LOST FEATURE, AN EMPTY AWARD, A DOOR THE BOT ALREADY HELD SHUT,
# AND THE CHANGELOG CUT.
#
#   §0  the premises §1's ruling stands on, re-derived rather than inherited
#   §1  `CLASS_POOLS` is dead, and SEVEN abilities die with it
#   §2  every spec's boss pool against the award count, derived from both ends
#   §3  the phoenix door — measured on a real cast, and the exactness controlled
#   §4  the cut — headings, disjointness, order, and the archive still reachable
#   §5  the two things reported and NOT fixed, pinned as measurements
#
# WHY THE MEASUREMENTS AND NOT THE READ SITES. DU §2 established the standard
# and this gate is held to it: an assertion that `battle.gd` CONTAINS an ashes
# refusal would pass on a refusal written into a branch nothing reaches. **§3
# drives a REAL CAST and then asks the REAL DOOR**, in four states, and two of
# the four are there to prove the refusal is not a blanket one.
#
# AND THE THINGS THIS BATCH DECLINED TO FIX ARE PINNED AS NUMBERS TOO (§5), on
# DK §1's rule: a ruling of the form "left alone BECAUSE x" is a claim about a
# code path, and a claim about a code path rots. Pinned this way, the day
# somebody repairs one of them the gate says this report is stale rather than
# staying quietly true.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dv.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The 44-character ceiling the text standard measured. Here so §5's failure
# MESSAGE can say what it wanted rather than re-deriving it silently.
const CEILING := 44

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260830)
	print("BATCH DV — A LOST FEATURE, AN EMPTY AWARD, AND A DOOR THE BOT HELD SHUT")
	_s0_premises()
	_s1_class_pools()
	_s2_boss_depth()
	await _s3_phoenix()
	_s4_the_cut()
	_s5_reported_not_fixed()
	_g.report(self)


# ── §0 — THE PREMISES §1's RULING STANDS ON ─────────────────────────────────
# §1 rules that `CLASS_POOLS` is an ORPHANED FEATURE rather than scaffolding,
# and that ruling rests entirely on three facts about the code rather than on
# anything in the structure itself. They are asserted here so that the day the
# class draw is re-opened — which `run_state.gd` says is one line — this gate
# fails and says the report is stale, instead of the report quietly describing
# a game that has moved.
func _s0_premises() -> void:
	print("\n§0 — the premises the §1 ruling rests on")
	var rs := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(rs != "", "run_state.gd is readable")
	# (1) THE READER WAS DELETED, WHICH IS WHAT MAKES THIS AN ORPHANING.
	# A structure whose reader was never written is scaffolding; one whose
	# reader was DELETED is a feature that was switched off.
	ok(not rs.contains("func roll_ability_offer"),
		"§0: `roll_ability_offer` is back — the class draw has a reader again and §1 is stale")
	# (2) THE AWARD READS THE SPEC POOL ALONE.
	ok(rs.contains("func award_ability_pick"),
		"§0: `award_ability_pick` is gone — §1 and §2 are both describing a channel that moved")
	var aw := rs.find("func award_ability_pick")
	var body := rs.substr(aw, 400)
	ok(body.contains("roll_spec_ability_offer"),
		"§0: the award no longer reads `roll_spec_ability_offer` — the channel has changed")
	ok(not body.contains("class_pool"),
		"§0: the award reads a class pool again — the class draw is BACK and §1 is stale")
	# (3) THE STRUCTURE ITSELF STILL RESOLVES, which is why deleting it was
	# ever a live proposal.
	ok(Classes.CLASS_POOLS.size() == 4, "§0: `CLASS_POOLS` still keys four classes")


# ── §1 — THE DEAD POOL, AND WHAT DIES WITH IT ───────────────────────────────
# The count is DU's and is re-derived rather than quoted. What is new here is
# the second question: of the 61 names, how many are reachable through NO other
# channel? Deleting a container deletes the record of its contents, and that is
# an independent reason not to delete this one.
#
# THE POOL TABLES ARE READ FOR BUCKET MEMBERSHIP AND NOT AS AN ENUMERATION.
# The corpus question — "what are all the abilities in the game" — has exactly
# one answer and this gate asks it through `Classes.ability_corpus()` below.
# What the tables answer is a different question the corpus cannot: WHICH
# bucket a given name sits in. That is `check_dn`'s distinction and it is why
# this gate carries no walk of its own.
func _s1_class_pools() -> void:
	print("\n§1 — `CLASS_POOLS` is dead, and seven abilities are dead with it")
	var corpus_names := {}
	for ab in Classes.ability_corpus():
		corpus_names[ab.display_name] = true

	var total := 0
	var distinct := {}
	for cls in Classes.CLASS_POOLS:
		for n in Classes.CLASS_POOLS[cls]:
			total += 1
			distinct[n] = true
			ok(corpus_names.has(n),
				"§1: `%s` is in a class pool and resolves to nothing" % n)
	ok(total == 61, "§1: `CLASS_POOLS` is %d entries, not the 61 on record" % total)
	ok(distinct.size() == total,
		"§1: the 61 entries are no longer 61 DISTINCT names (%d)" % distinct.size())

	# Every channel a name can arrive by, OTHER than the dead pool.
	var elsewhere := {}
	for cls2 in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls2]:
			for ab2 in Classes.spec_abilities(spec):
				if ab2 != null:
					elsewhere[ab2.display_name] = true
			for n2 in Classes.SPEC_POOLS.get(spec, []):
				elsewhere[n2] = true
			for n3 in Classes.SPEC_DRAFT_POOLS.get(spec, []):
				elsewhere[n3] = true
	for cls3 in Classes.CLASS_DRAFT_POOLS:
		for n4 in Classes.CLASS_DRAFT_POOLS[cls3]:
			elsewhere[n4] = true

	var homeless: Array = []
	for n5 in distinct:
		if not elsewhere.has(n5):
			homeless.append(n5)
	homeless.sort()
	# DERIVED, NEVER LISTED. A hard-coded list of seven names would go stale the
	# moment one of them is given a home, and would go stale SILENTLY — which is
	# the whole failure mode §1 is about.
	ok(homeless.size() == 7,
		"§1: %d abilities are reachable ONLY through the dead class pool, not the 7 on record — %s" % [
			homeless.size(), ", ".join(PackedStringArray(homeless))])
	ok(homeless.size() > 0,
		"§1: NOTHING is reachable only through the dead pool any more — the second reason not to delete it is gone")
	print("  CLASS_POOLS: %d entries, %d distinct, %d reachable NOWHERE else" % [
		total, distinct.size(), homeless.size()])
	print("  the homeless: %s" % ", ".join(PackedStringArray(homeless)))


# ── §2 — THE AWARD COUNT AND THE POOLS THAT CANNOT FILL IT ──────────────────
# BOTH ENDS ARE DERIVED. The award count comes off `Run.SLOT_COUNT` rather than
# being typed in, and the depths come off `SPEC_POOLS`. A batch that adds a
# fourth zone gets a red here saying the shortfall table is stale, which is
# exactly what a report of this shape needs.
func _s2_boss_depth() -> void:
	print("\n§2 — every spec's boss pool against the award count")
	var rs := load("res://scripts/run_state.gd")
	var awards: int = rs.SLOT_COUNT
	ok(awards == 3, "§2: the zone-boss award count is %d, not 3 — §2's table is stale" % awards)

	var total := 0
	var distinct := {}
	var short: Array = []
	var deepest := 0
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			var pool: Array = Classes.SPEC_POOLS.get(spec, [])
			ok(not pool.is_empty(), "§2: %s has NO boss pool at all" % spec)
			total += pool.size()
			for n in pool:
				distinct[n] = true
			if pool.size() > deepest:
				deepest = pool.size()
			if pool.size() < awards:
				short.append("%s(%d)" % [spec, pool.size()])
			print("    %-13s pool=%d  shortfall=%d" % [
				spec, pool.size(), maxi(0, awards - pool.size())])
	ok(total == 42, "§2: `SPEC_POOLS` is %d entries, not the 42 on record" % total)
	ok(distinct.size() == 40,
		"§2: the 42 entries are %d distinct names, not the 40 on record" % distinct.size())

	# THE FINDING ITSELF, ASSERTED AS A PROPERTY AND PRINTED AS A LIST. If a
	# later batch deepens Holy's pool this goes red and says so, which is the
	# ruling arriving rather than the gate being wrong.
	short.sort()
	ok(short.size() == 2,
		"§2: %d specs hold a boss pool thinner than the %d awards, not the 2 on record — %s" % [
			short.size(), awards, ", ".join(PackedStringArray(short))])
	ok(Classes.SPEC_POOLS.get("holy", []).size() == 1,
		"§2: the Holy Cleric's boss pool is no longer ONE card — the sharpest case has moved")
	# AND THE HALF THAT MAKES IT BITE: his one card is also draftable, so the
	# third award can go empty too.
	var holy_pool: Array = Classes.SPEC_POOLS.get("holy", [])
	var holy_draft: Array = Classes.SPEC_DRAFT_POOLS.get("holy", [])
	ok(holy_draft.has(holy_pool[0]),
		"§2: the Holy Cleric's one boss card is no longer draftable — his third award can no longer empty")
	# The slot arithmetic that prices §2's card-shaped options.
	ok(Classes.core_slots("holy") == 4,
		"§2: Holy no longer carries four protected cores — the slot half of the pricing has moved")
	print("  awards=%d  pools=%d entries / %d distinct  deepest=%d  thin=%s" % [
		awards, total, distinct.size(), deepest, ", ".join(PackedStringArray(short))])


# ── §3 — THE PHOENIX DOOR, MEASURED ─────────────────────────────────────────
# FOUR STATES, AND TWO OF THEM EXIST TO PROVE THE REFUSAL IS NOT A BLANKET ONE.
# A gate that only checked "armed ⇒ refused" would pass on a condition that
# refused the card outright, which is a strictly worse bug than the waste being
# fixed (CO §1). So the unarmed state and the BELOW-VALUE state are asserted
# usable, and the below-value state is the one that separates the exact test
# from the cheap `> 0` one.
func _s3_phoenix() -> void:
	print("\n§3 — the phoenix door")
	var bg := load("res://scripts/battle.gd")
	var perfect: int = bg.ASHES_RETURN_PERFECT
	var base: int = bg.ASHES_RETURN
	ok(base < perfect,
		"§3: `ASHES_RETURN` (%d) is no longer below `ASHES_RETURN_PERFECT` (%d) — the exactness control below measures nothing" % [
			base, perfect])

	var scene: Node = await Gate.spawn(self, ["warden", "pyromancer", "holy", "beastmaster"])
	ok(Gate.flags_are_inert(scene), "§3: the fixture's headless premise still holds")
	var mage: BattleUnit = null
	for h in scene.get("heroes"):
		if h.hero_key == "mage" and not h.is_companion:
			mage = h
	ok(mage != null, "§3: no Mage in the fixture — §3 measured nothing")
	if mage == null:
		scene.queue_free()
		return
	var ashes = null
	for a in Classes.ability_corpus():
		if a.display_name == "Ashes of Al'ar":
			ashes = a
	ok(ashes != null, "§3: Ashes of Al'ar is not in the corpus")
	if ashes == null:
		scene.queue_free()
		return
	mage.abilities.append(ashes)
	mage.resource = mage.max_resource
	mage.cooldowns.clear()

	# (A) UNARMED — the door must be OPEN, or the fix deleted the card.
	ok(scene._ability_usable(mage, ashes),
		"§3: an UNARMED phoenix is refused — the refusal is a blanket one, which is worse than the waste")
	# (B) ARMED BY A REAL CAST — this is the defect, and it is closed.
	await scene._resolve_special(mage, ashes, mage, "good", 1.0)
	mage.resource = mage.max_resource
	mage.cooldowns.clear()
	ok(mage.ashes_return == perfect,
		"§3: the cast wrote %d rather than ASHES_RETURN_PERFECT — the door's test compares against the wrong value" % mage.ashes_return)
	ok(not scene._ability_usable(mage, ashes),
		"§3: an ARMED phoenix can still be recast — 30 Mana and a turn writing the same constant")
	# (C) BELOW WHAT THE CAST WOULD WRITE — the door must be OPEN. This is the
	# assertion that fails if the test is ever written as `ashes_return > 0`,
	# and it is the whole of CO §1's rule in one line.
	mage.ashes_return = base
	ok(scene._ability_usable(mage, ashes),
		"§3: a phoenix armed BELOW what the cast writes (%d of %d) is refused — that cast would have improved something" % [
			base, perfect])
	# (D) SPENT — the guard can never fire again, so arming is inert.
	mage.ashes_return = 0
	mage.ashes_used = true
	ok(not scene._ability_usable(mage, ashes),
		"§3: a SPENT phoenix can be re-armed — `_ashes_guard` refuses forever once used, so the cast is inert")

	# AND THE PROOF THAT `RECAST_GATED` MEMBERSHIP WOULD HAVE BEEN INERT.
	# This is why the refusal is a bespoke condition rather than a table entry,
	# and it is asserted rather than argued: that system reasons about status
	# writes and this ability writes a field, so it proposes nothing at all.
	mage.ashes_used = false
	mage.ashes_return = perfect
	ok(scene._recast_targets(mage, ashes).is_empty(),
		"§3: the recast system now proposes targets for `ashes` — membership would no longer be inert, and this ruling is stale")
	ok(not scene._recast_refused(mage, ashes),
		"§3: `_recast_refused` now refuses an armed phoenix — the bespoke condition is redundant and this ruling is stale")
	print("  ashes: unarmed OPEN / armed REFUSED / below-value OPEN / spent REFUSED; recast system proposes nothing")
	scene.queue_free()


# ── §4 — THE CUT ────────────────────────────────────────────────────────────
# NO FILE SIZE IS ASSERTED ANYWHERE IN THIS SECTION and that is the rule rather
# than an omission: sizes agreeing is entirely consistent with a duplicated
# entry and a dropped one. What is asserted is the heading structure, the
# disjointness of the two halves, and that the live file's own header still
# leads to the archive — which is the anchor fourteen suites follow.
func _s4_the_cut() -> void:
	print("\n§4 — the changelog cut")
	var live := FileAccess.get_file_as_string("res://docs/changelog.html")
	ok(live != "", "§4: the live changelog is readable")

	# THE ARCHIVE IS REACHED THROUGH THE LIVE FILE'S OWN HEADER, NEVER
	# HARDCODED — CD's pattern, and the reason CX's cut cost this batch nothing.
	var mark := live.find("/changelog-archive.html</code>")
	ok(mark > 0, "§4: the live changelog no longer names the archive's full path")
	if mark <= 0:
		return
	var open_at := live.rfind("<code>", mark) + 6
	var arch_path := live.substr(open_at,
		mark + "/changelog-archive.html".length() - open_at)
	var arch := FileAccess.get_file_as_string(arch_path)
	ok(arch.length() > 100000,
		"§4: the archive at %s reads %d characters" % [arch_path, arch.length()])

	# COUNTED TWO INDEPENDENT WAYS, because a heading does not always fit on one
	# line and a line-anchored extractor misses one silently (CX found exactly
	# that at Batch BF).
	var live_line := _count_line_h2(live)
	var live_span := _count_span_h2(live)
	ok(live_line == live_span,
		"§4: the live file's two heading counts disagree (%d line-anchored / %d cross-line)" % [
			live_line, live_span])
	var arch_line := _count_line_h2(arch)
	var arch_span := _count_span_h2(arch)
	ok(arch_line == arch_span,
		"§4: the archive's two heading counts disagree (%d line-anchored / %d cross-line)" % [
			arch_line, arch_span])
	# BATCH DW — THIS WAS `live_span == 16` AND IT COULD ONLY PASS FOR ONE BATCH.
	# The live file gains an entry every batch, so DV's own acceptance was the
	# only run that could ever satisfy an equality here: **DW is the batch it
	# broke on, and it broke on DW's own changelog entry.** That is CD §1's
	# fault exactly — the shape that turned FIVE suites red at once at CJ when a
	# hardcoded stamp was re-bumped — and `test_batch_bx` §5 already carries the
	# repaired version of the same lesson.
	#
	# THE FLOOR IS THE DURABLE HALF AND IT IS THE HALF THE CUT WAS ABOUT: the
	# cut left 16 and entries are only ever ADDED, so an entry VANISHING from
	# the live file still fails here, which is what this check is for. The
	# ceiling is not asserted because it is not a claim — it is the batch
	# number. THE ARCHIVE KEEPS ITS EQUALITY, because that file only moves when
	# a cut moves it, so 149 is a real invariant rather than a growing count.
	ok(live_span >= 16,
		"§4: the live file holds %d entries, FEWER than the 16 the cut left — an entry has been dropped" % live_span)
	ok(arch_span == 149, "§4: the archive holds %d entries, not the 149 the cut made" % arch_span)
	print("  live %d entries (floor 16, +1 a batch since the cut), archive %d" % [
		live_span, arch_span])

	# THE BOUNDARY IS A BATCH BOUNDARY AND IT IS THE ONE INTENDED.
	ok(live.contains("<h2>2026-08-22 &mdash; Batch DG"),
		"§4: the live file's oldest entry, Batch DG, is missing")
	ok(not live.contains("<h2>2026-08-22 &mdash; Batch DF"),
		"§4: Batch DF is still in the live file — the cut did not move it")
	ok(arch.contains("<h2>2026-08-22 &mdash; Batch DF"),
		"§4: Batch DF is not in the archive — an entry was DROPPED by the cut")
	ok(not arch.contains("<h2>2026-08-22 &mdash; Batch DG"),
		"§4: Batch DG is in BOTH halves — the cut duplicated an entry")
	ok(live.contains("<h2>2026-08-29 &mdash; Batch DV"),
		"§4: this batch's own entry is not in the live changelog")

	# ZERO OVERLAP, ASSERTED OVER THE WHOLE OF BOTH HALVES rather than at the
	# boundary alone. A duplicated entry anywhere fails here.
	var dupes: Array = []
	for h in _headings(live):
		if arch.contains(h):
			dupes.append(h)
	ok(dupes.is_empty(),
		"§4: %d headings are in BOTH halves: %s" % [dupes.size(),
			", ".join(PackedStringArray(dupes))])

	# BOTH HALVES NAME THE OTHER, with the counterpart's full path.
	ok(arch.contains("docs/changelog.html"),
		"§4: the archive header no longer names the live file")
	ok(live.contains("Batch DV</b> at DF/DG") or live.contains("Batch DV") ,
		"§4: the live header does not record which batch made this cut")
	print("  live %d entries (DV..DG), archive %d entries (DF..Batch 1), 0 overlapping headings" % [
		live_span, arch_span])


func _count_line_h2(s: String) -> int:
	var n := 0
	for line in s.split("\n"):
		if line.begins_with("<h2"):
			n += 1
	return n


func _count_span_h2(s: String) -> int:
	var n := 0
	var i := s.find("<h2")
	while i >= 0:
		n += 1
		i = s.find("<h2", i + 3)
	return n


# The `<h2 ...>` opening tag through to the end of its heading text, which is
# what makes a heading unique enough to test membership with.
func _headings(s: String) -> Array:
	var out: Array = []
	var i := s.find("<h2")
	while i >= 0:
		var close := s.find("</h2>", i)
		if close < 0:
			break
		out.append(s.substr(i, close - i + 5))
		i = s.find("<h2", close)
	return out


# ── §5 — THE TWO THINGS REPORTED AND NOT FIXED ──────────────────────────────
# Both are pinned as MEASUREMENTS rather than described in prose, on DK §1's
# rule. A sentence saying "this was left alone because x" rots; a number that
# re-derives every battery run says so out loud the day x stops being true.
func _s5_reported_not_fixed() -> void:
	print("\n§5 — the two reported and not fixed")

	# (1) SHADOWREND'S RENDERED PERFECT — **REPAIRED AT DW §3, AND THE POLARITY
	# OF THIS CHECK IS INVERTED RATHER THAN DELETED.** DV pinned it OVER at 49
	# (the RENDERED figure; the earlier record's 45 was the authored-plus-label
	# one and understated it by four). It fits now, so the assertion is that it
	# FITS — a deleted check would let the overrun come back silently.
	#
	# **AND DV's FRAMING OF IT WAS WRONG, WHICH IS THE HALF WORTH KEEPING.**
	# It was recorded as the one thing DU §4's corpus fix made visible. It was
	# not: `"Cleric recovers {mhp:5}"` was authored TWICE — on Shadowrend and on
	# **SMITE**, the Cleric class basic — and `ability_corpus()` has read
	# `kit("cleric")` since long before DU, so **the identical 49-character
	# overrun was already in the corpus under Smite's name.** DU added a second
	# instance of a breach that was always visible. Both sites are repaired and
	# BOTH are asserted below, because fixing one of two copies is how the two
	# copies started.
	var sr = null
	var sm = null
	for ab in Classes.ability_corpus():
		if ab.display_name == "Shadowrend":
			sr = ab
		elif ab.display_name == "Smite":
			sm = ab
	ok(sr != null, "§5: Shadowrend is not in the corpus — DU's fix has been reverted")
	ok(sm != null, "§5: Smite is not in the corpus — the class-kit walk has been reverted")
	var cc := Classes.hero_config("cleric")
	var ctx := Classes.value_ctx_from_config(cc, {"hp": int(cc["max_hp"] * 0.7)})
	for pair in [[sr, "Shadowrend"], [sm, "Smite"]]:
		var ab2 = pair[0]
		if ab2 == null:
			continue
		var rendered := "Perfect: " + Classes.resolve_values(ab2.perfect_text, ctx)
		ok(rendered.length() <= CEILING,
			"§5: %s's rendered Perfect is %d against a ceiling of %d — the DW §3 repair has been reverted" % [
				pair[1], rendered.length(), CEILING])
		print("  %s rendered Perfect: %d characters against %d" % [
			pair[1], rendered.length(), CEILING])

	# (2) THE LAST HAND-ROLLED WALK, PINNED BY ITS BLIND SPOT RATHER THAN BY ITS
	# SOURCE. Reproducing the walk here would be writing a second copy of the
	# thing being complained about, so what is asserted is the CONSEQUENCE: the
	# corpus reaches abilities that live in no pool and in no class kit, and
	# every one of them is invisible to any walk built the old way. The day that
	# population is empty, a short walk and the real one agree and this report
	# is stale.
	var pooled := {}
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			for n in Classes.SPEC_POOLS.get(spec, []):
				pooled[n] = true
			for n2 in Classes.SPEC_DRAFT_POOLS.get(spec, []):
				pooled[n2] = true
	for cls2 in Classes.CLASS_POOLS:
		for n3 in Classes.CLASS_POOLS[cls2]:
			pooled[n3] = true
	for cls3 in Classes.CLASS_DRAFT_POOLS:
		for n4 in Classes.CLASS_DRAFT_POOLS[cls3]:
			pooled[n4] = true
	for key in ["warrior", "mage", "cleric", "hunter"]:
		for kab in Classes.kit(key):
			pooled[kab.display_name] = true
	var unseen: Array = []
	for ab2 in Classes.ability_corpus():
		if not pooled.has(ab2.display_name):
			unseen.append(ab2.display_name)
	unseen.sort()
	ok(unseen.size() == 16,
		"§5: %d abilities sit outside every pool and every class kit, not the 16 on record — the blind-spot figure is stale (%s)" % [
			unseen.size(), ", ".join(PackedStringArray(unseen))])
	ok(unseen.size() > 0,
		"§5: every ability is now in a pool or a class kit — a walk built the old way would agree with the corpus, and §5's finding is stale")
	print("  outside every pool and class kit: %d — %s" % [
		unseen.size(), ", ".join(PackedStringArray(unseen))])

	# (3) THE FOUR OVERRIDES, AND WHICH CLASS KIT EACH ACTUALLY CAME OUT OF.
	# DU recorded all four as Mage; one is the Occultist's, which is a Cleric
	# spec. Derived off `apply_kit_overrides` itself so a fifth is covered by
	# doing nothing, and asserted so the correction cannot go stale in prose.
	var by_class := {}
	for cls4 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[cls4]:
			var cfg := {"abilities": Classes.kit(cls4)}
			var was: String = cfg["abilities"][0].display_name
			Classes.apply_kit_overrides(cfg, spec2)
			var now: String = cfg["abilities"][0].display_name
			if now != was:
				by_class[now] = cls4
	ok(by_class.size() == 4,
		"§5: `apply_kit_overrides` overrides %d basics, not the 4 on record" % by_class.size())
	ok(by_class.get("Shadowrend", "") == "cleric",
		"§5: Shadowrend is not the CLERIC kit's override — DU's 'four Mage specs' correction is stale")
	var mage_n := 0
	for k in by_class:
		if by_class[k] == "mage":
			mage_n += 1
	ok(mage_n == 3,
		"§5: %d of the overrides are Mage, not 3 — the corrected figure has moved" % mage_n)
	print("  overrides by class: %s" % by_class)

# ── §6 — THE RULINGS ARE WRITTEN WHERE A LATER BATCH WILL READ THEM ─────────
	print("\n§6 — the rulings are recorded")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm != "", "§6: CLAUDE.md is readable")
	ok(cm.contains("ADDING A NAME TO A TABLE IS NOT A CHANGE UNTIL THE MACHINERY REACHES ITS SHAPE"),
		"§6: CLAUDE.md does not carry DV §3's ruling about inert membership")
	ok(cm.contains("THE AUTOPLAY HEURISTIC'S REFUSAL LIST IS AN ORACLE FOR PLAYER-DOOR GAPS"),
		"§6: CLAUDE.md does not carry DV §3's oracle rule")
	ok(cm.contains("ESTABLISH WHY A STRUCTURE IS DEAD BEFORE DELETING IT"),
		"§6: CLAUDE.md does not carry DV §1's provenance rule")
	ok(cm.contains("The bot tells you where to look; only the handler tells you what the condition is")
		or cm.contains("the bot only tells you where to look"),
		"§6: the oracle rule is recorded without the half that stops it being over-applied")
