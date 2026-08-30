# BATCH DV — A LOST FEATURE, AN EMPTY AWARD, A DOOR THE BOT ALREADY HELD SHUT,
# AND THE CHANGELOG CUT.
#
#   §0  the premises §1's ruling stands on, re-derived rather than inherited
#   §1  the dead pool is DELETED (DY §3) and the vault's exit is the pools
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
# §1 ruled `CLASS_POOLS` an ORPHANED FEATURE rather than scaffolding, and that
# ruling rested entirely on three facts about the code rather than on anything
# in the structure itself. **BATCH DY §3 ACTED ON IT AND DELETED THE
# CONTAINER**, so the third premise INVERTS: what would make the ruling stale
# is now the class-wide boss pool COMING BACK. The premises are still asserted
# here, so the day someone re-opens that channel this gate fails and says the
# report is stale, instead of the report quietly describing a game that moved.
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
	# (3) THE STRUCTURE IS GONE. **BATCH DY §3 RULED AND DELETED IT**, so the
	# premise inverts: what would make §1 stale now is the container COMING
	# BACK. Read off the source, because a deleted symbol cannot be sized.
	var cs := FileAccess.get_file_as_string("res://scripts/classes.gd")
	ok(not cs.contains("const CLASS_POOLS"),
		"§0: `CLASS_POOLS` is BACK — the class-wide boss pool has returned and §1 is stale")
	ok(not cs.contains("static func class_pool("),
		"§0: `class_pool()` is BACK — its accessor has returned and §1 is stale")


# ── §1 — THE DEAD POOL IS DELETED, AND THE SEVEN HAVE HOMES ────────────────
# **DV RULED `CLASS_POOLS` A LOST FEATURE AND DELETED NOTHING; DX PRICED THE
# OPTIONS AND AUTHORED NOTHING; DY §3 TOOK OPTION B.** So this section stops
# measuring a container and starts asserting the two things that make its
# deletion safe — and would say so if either stopped being true.
#
# THE SEVEN ARE DERIVED, NEVER LISTED, EXACTLY AS THEY WERE BEFORE. A
# hard-coded list would go stale the moment one lost its home, and it would go
# stale SILENTLY, which is the whole failure mode this gate is about. What is
# walked now is the VAULT — `vault_ability()` is the single-source definition
# table those seven live in — and the question asked of every entry is the one
# that mattered: **does a live pool name it?** A vault definition in no pool is
# reachable by nothing, which is the state that cost this project eighteen
# batches of silent audit and three batches of measured engineering.
func _s1_class_pools() -> void:
	print("\n§1 — the dead pool is deleted, and the vault's exit is the pools")
	var corpus_names := {}
	for ab in Classes.ability_corpus():
		corpus_names[ab.display_name] = true

	# Every channel a name can arrive by. THE CLASS-WIDE BOSS POOL IS NOT ONE
	# OF THEM ANY MORE — that is the change, and this dict is what proves the
	# seven did not need it.
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

	# THE VAULT, WALKED OFF ITS OWN SOURCE rather than off a name list. Every
	# `match` arm in `vault_ability()` is a definition; every definition is
	# owed a pool.
	var cs := FileAccess.get_file_as_string("res://scripts/classes.gd")
	var vi := cs.find("static func vault_ability(display_name: String) -> Ability:")
	ok(vi >= 0, "§1: `vault_ability()` is gone — the definitions the seven live in have moved")
	var vend := cs.find("\nstatic func ", vi + 20)
	var vbody := cs.substr(vi, vend - vi) if (vi >= 0 and vend > vi) else ""
	var vault_names: Array = []
	for line in vbody.split("\n"):
		var t := line.strip_edges()
		if t.begins_with("\"") and t.ends_with("\":") and not t.contains(" := "):
			var nm := t.substr(1, t.length() - 3)
			if nm != "" and not vault_names.has(nm):
				vault_names.append(nm)
	ok(vault_names.size() == 10,
		"§1: the vault holds %d definitions, not the 10 on record — re-derive before quoting it" % vault_names.size())

	var homeless: Array = []
	for nm2 in vault_names:
		ok(corpus_names.has(nm2),
			"§1: vault entry `%s` resolves to nothing" % nm2)
		if not elsewhere.has(nm2):
			homeless.append(String(nm2))
	homeless.sort()
	# THE ASSERTION DY EARNED. It read `homeless.size() == 7` before this batch,
	# against a container that gave those seven no exit at all.
	ok(homeless.size() == 0,
		"§1: %d vault definitions are named by NO live pool — a card reachable by nothing is back (%s)" % [
			homeless.size(), ", ".join(PackedStringArray(homeless))])
	# AND WHERE THE SEVEN LANDED, ASSERTED BY SHAPE RATHER THAN BY NAME: five
	# entered draft pools and two a boss pool, so both channels are used and
	# neither absorbed the whole vault.
	var in_draft := 0
	var in_boss := 0
	for nm3 in vault_names:
		var d := false
		var b := false
		for spec2 in Classes.SPEC_DRAFT_POOLS:
			if Classes.SPEC_DRAFT_POOLS[spec2].has(nm3):
				d = true
		for cls4 in Classes.CLASS_DRAFT_POOLS:
			if Classes.CLASS_DRAFT_POOLS[cls4].has(nm3):
				d = true
		for spec3 in Classes.SPEC_POOLS:
			if Classes.SPEC_POOLS[spec3].has(nm3):
				b = true
		if d:
			in_draft += 1
		if b:
			in_boss += 1
	ok(in_draft >= 5,
		"§1: only %d vault definitions are DRAFTABLE — DY re-homed five that way" % in_draft)
	ok(in_boss >= 5,
		"§1: only %d vault definitions sit in a BOSS pool — DY re-homed two that way beside the three already there" % in_boss)
	print("  vault: %d definitions, %d draftable, %d in a boss pool, %d homeless" % [
		vault_names.size(), in_draft, in_boss, homeless.size()])


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
	# BATCH DY §2 moved both: Dawnbreak and Sanctuary joined Holy's pool, so
	# 42 -> 44 entries and 40 -> 42 distinct.
	ok(total == 44, "§2: `SPEC_POOLS` is %d entries, not the 44 on record" % total)
	ok(distinct.size() == 42,
		"§2: the 44 entries are %d distinct names, not the 42 on record" % distinct.size())

	# THE FINDING ITSELF, ASSERTED AS A PROPERTY AND PRINTED AS A LIST.
	# **BATCH DY §2 CLOSED HOLY'S HALF AND THE GATE SAID SO BY GOING RED, WHICH
	# IS EXACTLY WHAT THIS TRIPWIRE IS FOR** — DX examined it and left it
	# standing on that reasoning. It reads ONE now, not two: **the Devout is the
	# only spec left with a structural shortfall**, and he is the sharpest case
	# in the game on the other measure too (both of his two boss cards are
	# draftable, so all three of his awards can pay nothing).
	short.sort()
	ok(short.size() == 1,
		"§2: %d specs hold a boss pool thinner than the %d awards, not the 1 on record — %s" % [
			short.size(), awards, ", ".join(PackedStringArray(short))])
	ok(Classes.SPEC_POOLS.get("holy", []).size() == 3,
		"§2: the Holy Cleric's boss pool is no longer THREE cards — DY §2's fix has moved")
	ok(Classes.SPEC_POOLS.get("inquisitor", []).size() == 2,
		"§2: the Devout's boss pool is no longer TWO — the remaining shortfall has moved")
	# **AND THE GENERAL PROBLEM SURVIVES HOLY'S FIX, WHICH IS THE HALF A READER
	# WOULD OTHERWISE ASSUME WAS CLOSED.** A boss card that is ALSO draftable
	# removes itself from the offer, so a pool can empty below its own depth.
	# Derived, never listed: this counts the specs whose whole boss pool is
	# draftable, and the Devout is one of them.
	var emptiable: Array = []
	for cls2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[cls2]:
			var bp: Array = Classes.SPEC_POOLS.get(spec2, [])
			var dp: Array = Classes.SPEC_DRAFT_POOLS.get(spec2, [])
			var left := 0
			for n2 in bp:
				if not dp.has(n2):
					left += 1
			if left < awards:
				emptiable.append("%s(%d of %d safe)" % [spec2, left, bp.size()])
	emptiable.sort()
	ok(emptiable.size() == 8,
		"§2: %d specs can be short of a full award set once drafting is accounted for, not the 8 on record — %s" % [
			emptiable.size(), ", ".join(PackedStringArray(emptiable))])
	var holy_pool: Array = Classes.SPEC_POOLS.get("holy", [])
	var holy_draft: Array = Classes.SPEC_DRAFT_POOLS.get("holy", [])
	var holy_safe := 0
	for n3 in holy_pool:
		if not holy_draft.has(n3):
			holy_safe += 1
	ok(holy_safe == 2,
		"§2: the Holy Cleric's un-draftable boss cards are %d, not the 2 DY §2 left her" % holy_safe)
	print("    emptiable by drafting: %s" % ", ".join(PackedStringArray(emptiable)))
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
	# thing being complained about, so what is asserted is the CONSEQUENCE: how
	# many abilities the corpus reaches that live in no POOL and in no CLASS
	# KIT. The day that population is empty, a short walk and the real one agree
	# and this report is stale.
	#
	# **BATCH DY §3 MOVED THIS FIGURE 16 -> 43 WITHOUT MOVING ANYTHING ABOUT THE
	# GAME, AND THAT IS WORTH MORE THAN THE NUMBER.** `CLASS_POOLS` was the ONE
	# structure in the project that named the SIBLING SPECS' KIT ABILITIES as
	# pool entries — Bloodlust, Mocking Blow, Hex of Ruin and twenty-four more
	# were "in a pool" only because the class-wide boss pool listed them. It is
	# deleted, so those twenty-seven now sit outside every pool by this walk's
	# definition, exactly as they always did by the game's. **NOT ONE ABILITY
	# BECAME LESS REACHABLE**: every one of them is in its own spec's opening
	# kit, which `Classes.spec_abilities()` returns and this deliberately narrow
	# walk does not read.
	#
	# THE CONSEQUENCE FOR THE OLD SENTENCE, CORRECTED RATHER THAN LEFT TO ROT:
	# this population is no longer "invisible to a walk built the old way". The
	# CL walk reads `spec_abilities()` too, so it reaches 223 of 227 and misses
	# exactly the FOUR kit overrides — which is `check_cz` §0's set identity and
	# is asserted there, once, rather than a second time here.
	var pooled := {}
	for cls in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[cls]:
			for n in Classes.SPEC_POOLS.get(spec, []):
				pooled[n] = true
			for n2 in Classes.SPEC_DRAFT_POOLS.get(spec, []):
				pooled[n2] = true
	# DY §3: the `CLASS_POOLS` arm of this walk is gone with the dict. The
	# figure below did not move — every name it contributed is in a spec pool,
	# a draft pool or a class kit as well.
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
	ok(unseen.size() == 43,
		"§5: %d abilities sit outside every pool and every class kit, not the 43 on record — re-derive it (%s)" % [
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
