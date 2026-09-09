# BATCH FE — THE RUNE ROWS FOLLOW THE CARDS, AND THE OTHER TWO QUEUES ARE
# DRIVEN AND REPAIRED.
#
#   §1  `RUNE_TAGS` CARRIES NO BREAK PRIMARY EITHER — the population derived
#       off the table, and the reader claim measured rather than repeated
#   §2  THE TWO UNGUARDED FROZEN QUEUES — the idiom's population, both faults
#       driven through the REAL screen, and both repairs asserted NOT to be
#       rerolls
#
# **WHY THIS BATCH EARNS A GATE.** FD reported two more queues wearing the
# roll-store-answer idiom and was explicit that their reachability was NOT
# driven. Driving them found that FD's two rows are wrong in opposite
# directions: `bm_candidates` **cannot** produce the duplicate FD implies, and
# `up_candidates` produces one that is **worse** than a duplicate, because six
# of the eight upgrade stamps are not idempotent. Neither fact is visible from
# a source read of the table FD built, and both decay silently.
#
#   §1 IS A CONSISTENCY CHANGE AND SAYS SO. Nothing reads a rune's primary as
#     a condition — the two conditions count CARD primaries over the drafted
#     half — so this gate asserts the INERTNESS as well as the values, because
#     the day a rune condition reads `RUNE_TAGS` the claim in every document
#     becomes false and nothing else would notice.
#   §2 IS DRIVEN THROUGH THE REAL SCREEN, not through a re-implementation of
#     it — FD §1e's rule. A gate that inlines `_pick_upgrade`'s body proves its
#     own copy correct and says nothing about the one the player presses.
#   §2 ASSERTS THE NO-REROLL ARM IN BOTH REPAIRS. A clean queue must come back
#     UNTOUCHED (BATCH X), and without that arm both sections pass on a
#     function that simply rerolls.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fe.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260906)
	print("BATCH FE — THE RUNE ROWS FOLLOW THE CARDS, AND THE TWO QUEUES ARE DRIVEN")
	_s1_rune_tags_follow_the_cards()
	_s1b_nothing_reads_a_rune_primary()
	_s2_the_idiom_population()
	_s2b_ability_choice()
	_s2c_upgrade_choice()
	await _s2d_the_live_screen()
	_g.report(self)


# ── §1 — NO RUNE ROW CARRIES BREAK FIRST ────────────────────────────────────
#
# **THE POPULATION IS DERIVED OFF THE TABLE, NOT TAKEN FROM THE BRIEF.** FD's
# brief named two cards that were not in its population at all; this one named
# two rune rows and said to derive the rest, and the derivation is FIVE — the
# two live rows plus three retired ones. The retired three move WITH the live
# two, because the reason for the ruling is that one vocabulary with two rules
# is the defect, and a retired entry is kept precisely so it can be read.
const MOVED := ["bared_plate", "comet", "long_watch", "seventh_bolt",
	"shattered_guard"]

func _s1_rune_tags_follow_the_cards() -> void:
	print("\n§1 — RUNE_TAGS carries no BREAK primary")
	var brk_first: Array = []
	var brk_any: Array = []
	var bad_size: Array = []
	for rid in Runes.RUNE_TAGS:
		var rt: Array = Runes.RUNE_TAGS[rid]
		if rt.size() < 1 or rt.size() > 2:
			bad_size.append("%s(%d)" % [rid, rt.size()])
		if not rt.is_empty() and String(rt[0]) == "BREAK":
			brk_first.append(String(rid))
		if rt.has("BREAK"):
			brk_any.append(String(rid))
	brk_first.sort()
	brk_any.sort()
	ok(brk_first.is_empty(),
		"§1: %d rune rows still carry BREAK as their PRIMARY — %s" % [
			brk_first.size(), brk_first])
	# **THE DEMOTION IS NOT A REMOVAL, AND THIS IS THE ARM THAT SAYS SO.**
	# Every one of the five keeps BREAK in its second slot; a batch that
	# satisfied the line above by DELETING the word would break this one.
	var lost: Array = []
	for id in MOVED:
		var t: Array = Runes.rune_tags(String(id))
		if t != ["OFFENSE", "BREAK"]:
			lost.append("%s=%s" % [id, t])
	ok(lost.is_empty(),
		"§1: a moved row does not read [OFFENSE, BREAK] — %s" % [lost])
	# **BATCH FK MOVED THIS COUNT 9 -> 11 AND NOT THE RULE ABOVE IT.** Two of
	# FK's thirty-nine carry BREAK as a SECOND tag (the Cold Snap and the Long
	# Blade); NEITHER carries it first, which is the arm three lines up and is
	# the ruling. **The count is kept rather than deleted** because it is what
	# catches a batch satisfying the primary rule by scattering BREAK into every
	# second slot — a table where the word is everywhere says nothing.
	ok(brk_any.size() == 11,
		"§1: %d rune rows carry BREAK at all, not the 11 after FK — %s" % [
			brk_any.size(), brk_any])
	ok(bad_size.is_empty(),
		"§1: the two-tag ceiling is broken on a rune row — %s" % [bad_size])
	# **AND THE REST OF THE TABLE DID NOT MOVE.** The transform touched exactly
	# two columns, so every other primary count must be untouched — a gate that
	# only counted BREAK would pass on a table somebody had rewritten wholesale.
	var spread := {}
	for t2 in Classes.TAG_ORDER:
		spread[String(t2)] = 0
	for rid2 in Runes.RUNE_TAGS:
		var rt2: Array = Runes.RUNE_TAGS[rid2]
		if rt2.is_empty():
			continue
		spread[String(rt2[0])] = int(spread[String(rt2[0])]) + 1
	# **BATCH FK GREW EVERY COLUMN BUT TWO, AND THE TWO THAT DID NOT MOVE ARE
	# THE RULES.** BREAK stays at ZERO — FE §1's whole ruling — and MARK stays at
	# zero, which EK measured rather than assumed: every mark in the game is laid
	# by a CARD, and not one rune payload field reads one. The other five moved
	# because thirty-nine rows were added, and the column table is kept (rather
	# than reduced to the two zeroes) for the reason it was written: a gate that
	# only counted BREAK would pass on a table somebody had rewritten wholesale.
	var want := {"DEBUFF": 34, "DEFENSE": 35, "BREAK": 0, "RESOURCE": 27,
		"OFFENSE": 25, "TEMPO": 5, "MARK": 0}
	var moved_col: Array = []
	for k in want:
		if int(spread[String(k)]) != int(want[k]):
			moved_col.append("%s %d!=%d" % [k, int(spread[String(k)]), int(want[k])])
	ok(moved_col.is_empty(),
		"§1: a primary column the demotion does not touch has moved — %s" % [moved_col])
	ok(Runes.RUNE_TAGS.size() == 126,
		"§1: the table is %d rows, not the 126 after FK" % Runes.RUNE_TAGS.size())
	print("    RUNE_TAGS primaries: %s" % [spread])

	# **THE CARD TABLE IS THE POSITIVE ARM.** FD's ruling is what this one
	# follows, so a batch that "fixed" the runes by re-breaking the cards is
	# caught here rather than two batches later.
	var card_break := 0
	var card_offense := 0
	for key in Classes.CARD_TAGS:
		var ct: Array = Classes.CARD_TAGS[key]
		if ct.is_empty():
			continue
		if String(ct[0]) == "BREAK":
			card_break += 1
		if String(ct[0]) == "OFFENSE":
			card_offense += 1
	ok(card_break == 0, "§1: %d CARDS carry BREAK first — FD's ruling has come undone"
		% card_break)
	ok(card_offense == 70, "§1: the card OFFENSE column reads %d, not FD's 70"
		% card_offense)
	ok(Classes.CARD_TAGS.size() == 227,
		"§1: the card table is %d rows, not 227" % Classes.CARD_TAGS.size())


# ── §1b — AND NOTHING READS A RUNE'S PRIMARY AS A CONDITION ─────────────────
#
# **THE CHANGE IS PURELY FOR CONSISTENCY AND THAT IS WORTH ASSERTING RATHER
# THAN IMPLYING.** FD, CLAUDE.md and `master.html` all called the table
# "display-only". It is weaker than that: `rune_tag_line` is the only builder
# and it has ZERO CALLERS, so the table reaches no surface at all. Both facts
# are swept out of the SOURCE, because the claim is about what exists.
func _s1b_nothing_reads_a_rune_primary() -> void:
	print("\n§1b — the rune primary feeds nothing")
	var files := ["scripts/runes.gd", "scripts/classes.gd", "scripts/map_screen.gd",
		"scripts/party_screen.gd", "scripts/battle.gd", "scripts/talents.gd",
		"scripts/run_state.gd", "scripts/shop_screen.gd", "scripts/run_sim.gd",
		"scripts/events.gd", "scripts/blacksmith_screen.gd"]
	var callers: Array = []
	var read := 0
	for f in files:
		var fa := FileAccess.open("res://" + String(f), FileAccess.READ)
		if fa == null:
			continue
		read += 1
		var src: String = Gate.strip_comments(fa.get_as_text())
		# The DEFINITION is not a call. Everything else that names it is.
		var body := src.replace("static func rune_tag_line(id: String) -> String:", "")
		if body.contains("rune_tag_line"):
			callers.append(String(f))
	ok(read == files.size(),
		"§1b: only %d of %d scripts were opened — the sweep read a short tree" % [
			read, files.size()])
	ok(callers.is_empty(),
		"§1b: `rune_tag_line` has a caller now (%s) — the table reaches a SURFACE, and every document calling it unread is false" % [callers])
	# ── BATCH FN — THE TWO CONDITIONS ARE GONE, AND THE CLAIM GOT STRONGER ──
	#
	# **THIS ARM READ THE SOURCE OF `threshold_met` AND `breadth_met_fraction`
	# AND ASSERTED THAT NEITHER NAMED `rune_tags`** — FE's whole finding being
	# that a rune's own primary is merely DESCRIPTIVE, because neither condition
	# read the table it sits in. **FN retired both conditions and deleted both
	# predicates**, so the claim is no longer "the two do not read it" but "there
	# is nothing that could": asserted at the payload, which is where a
	# condition would have to appear, over EVERY entry rather than over two
	# functions.
	#
	# **THE POSITIVE ARM IS `RUNE_TAGS` ITSELF, AND IT IS THE HALF THAT KEEPS
	# THIS SECTION HONEST.** The table is still there, still populated, and
	# still reaches nothing — a gate that only asserted "no condition reads it"
	# would pass just as well on a table somebody had deleted.
	var rsrc := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/runes.gd"))
	ok(rsrc != "", "§1b: runes.gd read back empty — the sweep read nothing")
	ok(not rsrc.contains("func threshold_met(")
			and not rsrc.contains("func breadth_met_fraction("),
		"§1b: a retired rune condition predicate is defined again — FN removed both")
	var gated_now: Array = []
	for rid in Runes.ids():
		if ((Runes.config(String(rid)).get("payload", {}) as Dictionary)
				.get("condition", {}) as Dictionary).has("tag_threshold") \
				or ((Runes.config(String(rid)).get("payload", {}) as Dictionary)
					.get("condition", {}) as Dictionary).has("tag_breadth"):
			gated_now.append(String(rid))
	ok(gated_now.is_empty(),
		"§1b: a rune carries a tag CONDITION again (%s) — a rune's primary stops being descriptive the moment one does"
			% [gated_now])
	ok(Runes.RUNE_TAGS.size() >= 100,
		"§1b: `RUNE_TAGS` holds %d rows — the zero above is the table's, not the claim's"
			% Runes.RUNE_TAGS.size())
	ok(rsrc.contains("func rune_tags(") and rsrc.contains("func rune_tag_line("),
		"§1b: the table lost an accessor — it is KEPT for the rune-offer surface EK deferred")
	print("    rune_tag_line callers: 0; 0 of %d runes carry a tag condition; RUNE_TAGS %d rows"
		% [Runes.ids().size(), Runes.RUNE_TAGS.size()])


# ── §2 — THE ROLL-STORE-ANSWER IDIOM, AND ITS WHOLE POPULATION ──────────────
#
# **THE POPULATION IS FIVE AND FD HAD FOUR.** Derived off what a rolled offer
# is STORED on rather than off a list of screens, which is the derivation that
# finds `pending_item_offers` — rolled at loot, saved, and answered on the map.
# It is already guarded and says so in its own comment; it is asserted here so
# the census is the census rather than the two that were broken.
#
# **THE SHOP AND THE BLACKSMITH ARE NOT IN IT**, and that is asserted too: both
# roll into a screen-local `offers` in `_ready` and neither is saved, so
# neither can go stale. A census that quietly included them would report a
# population that never had the fault.
const QUEUES := ["rune_candidates", "draft_candidates", "bm_candidates",
	"up_candidates"]

func _s2_the_idiom_population() -> void:
	print("\n§2 — the roll-store-answer idiom: the population, and every one re-asked")
	# **THE HOLDER IS BOUND ON THE SAME LINE AS ITS `res://` LITERAL, WHICH IS
	# NOT A STYLE CHOICE.** `build_pin_manifest.py` binds a holder off
	# `var NAME ... "res://…"`, so a two-step read (open, then strip into a
	# second variable) hides every needle below it from the manifest AND from
	# `check_ed` §2 — which reads GREEN, exactly like a gate with no pins at
	# all. **AND THE LITERAL MUST BE ON THE `var` LINE ITSELF**: the generator's
	# holder pattern is `var NAME ... "res://…"` with `[^\n]*` in the middle, so
	# WRAPPING the call hides the holder just as completely. Both were measured
	# on this file rather than assumed — it read 18 / 0 green through two
	# separate armings before the pins became visible.
	var r := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	var m := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	ok(r != "" and m != "", "§2: a script read back empty — the sweep read nothing")

	# THE FOUR MEMBER QUEUES ARE STILL FOUR. A fifth appearing is a queue
	# somebody added without a resolution door, which is the whole fault.
	var found: Array = []
	for q in QUEUES:
		if r.contains('"%s"' % String(q)) or m.contains('"%s"' % String(q)):
			found.append(String(q))
	ok(found.size() == QUEUES.size(),
		"§2: a member queue has been renamed or removed — found %s" % [found])
	# **AND THE SAVE CARRIES `pending_item_offers`, THE FIFTH.** It is the one
	# FD's table did not have; it re-asks the POUCH at resolution rather than
	# trusting the id it stored.
	ok(r.contains('"pending_item_offers": pending_item_offers'),
		"§2: `pending_item_offers` no longer rides the save — the fifth queue has moved")
	ok(m.contains("if not Run.needs_slot(id):"),
		"§2: the item offer stopped re-asking the pouch at resolution")

	# **EVERY RESOLUTION DOOR RE-ASKS, AND THE THREE READ DIFFERENTLY.**
	ok(r.contains("if owned_ability_names(member).has(name):"),
		"§2: `take_draft_ability` stopped refusing a card the hero already knows")
	ok(m.contains("var live: Array = Run.rune_choice(member)"),
		"§2: `_pick_rune` no longer comes through `rune_choice` (FD §1)")
	ok(m.contains("var live: Array = Run.ability_choice(member)"),
		"§2: `_pick_ability` no longer comes through `ability_choice`")
	ok(m.contains("var live: Array = Run.upgrade_choice(member)"),
		"§2: `_pick_upgrade` no longer comes through `upgrade_choice`")
	# THE RENDER AND THE HANDLER MUST READ THE SAME DOOR. `_pick_upgrade` takes
	# an INDEX, so a render that read the raw member while the handler repaired
	# would hand the player the button beside the one they pressed.
	ok(m.contains("var offer: Array = Run.upgrade_choice(member)"),
		"§2: the upgrade OVERLAY no longer renders through `upgrade_choice` — its index and the handler's have come apart")
	ok(m.contains("for pool_name in Run.ability_choice(member):"),
		"§2: the ability OVERLAY no longer renders through `ability_choice`")
	# AND THE OLD GUARD IS GONE RATHER THAN SITTING BESIDE THE NEW ONE.
	ok(not m.contains('or pool_name in member.get("bm_abilities", []):'),
		"§2: `_pick_ability`'s old refuse-and-return guard is still there — the dead button it drew is still drawn")

	# **THE SHOP AND THE BLACKSMITH ROLL AT THE OFFER.** Named so the census
	# cannot quietly grow to include a screen that never had the fault.
	var ss := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/shop_screen.gd"))
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/blacksmith_screen.gd"))
	ok(ss != "" and bs != "", "§2: a shop script read back empty")
	ok(ss.contains("_roll_offers()") and not ss.contains('"shop_offers"'),
		"§2: the Peddler's offers are STORED now — it has joined the idiom")
	ok(bs.contains("Run.roll_blacksmith_offer()"),
		"§2: the blacksmith no longer rolls its own stock at the screen")


# ── §2b — `ability_choice`: THE DEAD BUTTON, AND THE STRANDED PICK ──────────
#
# **THE FAULT WAS NOT THE ONE FD RECORDED, AND BOTH HALVES ARE ASSERTED.**
# `_pick_ability` already refused a name in `bm_abilities` — and `bm_abilities`
# is the only term of `owned_ability_names` that moves during a run — so a
# DUPLICATE was never reachable. It refused by RETURNING, which pops nothing:
# the stale name stayed on screen as a button that did nothing, and where the
# boss pool is smaller than the number of deferred picks EVERY button was dead
# and `bm_picks_owed` could never come down. The Inquisitor's pool is TWO.
func _s2b_ability_choice() -> void:
	print("\n§2b — ability_choice: the stale triple is repaired, a clean one is not")
	var RunState = load("res://scripts/run_state.gd")
	var run = RunState.new()

	# (1) THE NO-REROLL ARM, FIRST, BECAUSE WITHOUT IT EVERY OTHER ARM PASSES
	# ON A FUNCTION THAT SIMPLY REROLLS.
	var clean := _member("warrior", "berserker")
	ok(run.award_ability_pick(clean), "§2b: the award did not queue")
	var before: Array = (clean["bm_candidates"][0] as Array).duplicate()
	var got: Array = run.ability_choice(clean)
	ok(got == before,
		"§2b: a triple with nothing wrong with it came back CHANGED — %s against %s (BATCH X: a cache does not reroll when a screen opens)" % [got, before])
	ok((clean["bm_candidates"][0] as Array) == before,
		"§2b: a clean triple was rewritten on the member")

	# (2) A STALE TRIPLE IS REPAIRED, AND THE REPAIR IS WRITTEN BACK.
	var stale := _member("warrior", "berserker")
	ok(run.award_ability_pick(stale), "§2b: the award did not queue (stale arm)")
	var triple: Array = (stale["bm_candidates"][0] as Array).duplicate()
	ok(triple.size() >= 2, "§2b: the boss pool handed back %d names — the arm needs two" % triple.size())
	var taken := String(triple[0])
	run.hold_ability(stale, taken, true)
	var repaired: Array = run.ability_choice(stale)
	ok(not repaired.has(taken),
		"§2b: the repaired triple STILL offers %s, which the hero now holds — %s" % [taken, repaired])
	ok((stale["bm_candidates"][0] as Array) == repaired,
		"§2b: the repair was not WRITTEN BACK — the buttons and the handler read different arrays")
	ok(run.ability_choice(stale) == repaired,
		"§2b: a second call repaired again — it is a reroll, not a repair")
	for n in repaired:
		ok(not (run.owned_ability_names(stale) as Array).has(String(n)),
			"§2b: the repaired triple offers %s, which the hero already owns" % n)

	# (3) THE INQUISITOR — THE SPEC THE STRANDED PICK WAS MEASURED ON.
	# Three picks queued and answered in order used to leave the third with
	# every button dead in 20 of 20 driven runs.
	var inq := _member("cleric", "inquisitor")
	ok((Classes.spec_pool("inquisitor") as Array).size() == 2,
		"§2b: the Inquisitor's boss pool is %d, not the 2 this arm was measured on"
			% (Classes.spec_pool("inquisitor") as Array).size())
	var queued := 0
	for b in 3:
		if run.award_ability_pick(inq):
			queued += 1
	ok(queued == 3, "§2b: only %d of 3 zone-boss picks queued" % queued)
	var answered := 0
	for pick in 3:
		var live: Array = run.ability_choice(inq)
		if live.is_empty():
			break
		var q: Array = inq["bm_candidates"]
		q.pop_front()
		inq["bm_candidates"] = q
		run.hold_ability(inq, String(live[0]), true)
		inq["bm_picks_owed"] = int(inq["bm_picks_owed"]) - 1
		answered += 1
	ok(answered == 3,
		"§2b: only %d of 3 Inquisitor picks could be answered — the third is STRANDED, which is the fault this section exists for" % answered)
	var held: Array = inq["bm_abilities"]
	var dup: Array = []
	for n2 in held:
		if held.count(n2) > 1 and not dup.has(n2):
			dup.append(n2)
	ok(dup.is_empty(), "§2b: the Inquisitor holds a duplicate ability — %s" % [held])
	print("    Inquisitor (boss pool 2) answered %d of 3 deferred picks, holding %s"
		% [answered, held])


func _member(class_key: String, spec: String) -> Dictionary:
	return {"key": class_key, "spec": spec, "bm_abilities": [], "bm_equipped": [],
		"tree": [], "talents": {}, "upgrades": [], "runes": []}


# ── §2c — `upgrade_choice`: AP'S ONCE-PER-RUN RULE, ENFORCED AT THE ANSWER ──
#
# **THIS ONE HAD NO GUARD AT ALL AND IT IS A BALANCE FAULT RATHER THAN A UI
# ONE.** `_pick_upgrade` indexed the stored offer and appended it, and AP's
# once-per-run rule is enforced ONLY by the roll's `has_upgrade` filter — so
# two triples queued before either is answered can both offer the same upgrade
# on the same ability, and `_stamp_upgrade` is not idempotent for six of the
# eight: Honed is `damage * 1.5` twice, Weighted is `pressure *= 2` twice,
# Quickened is `-2` twice, Widened is `+1` twice, Piercing saturates to a full
# 1.0, and Swift compounds. **THE STACK IS ASSERTED HERE AS WELL AS THE
# REPAIR**, because the day `_stamp_upgrade` becomes idempotent this section is
# guarding something that no longer costs anything and should say so.
func _s2c_upgrade_choice() -> void:
	print("\n§2c — upgrade_choice: a duplicate id is dropped, a clean offer is not")
	var RunState = load("res://scripts/run_state.gd")
	var run = RunState.new()

	# (1) THE NO-REROLL ARM.
	var clean := _member("warrior", "berserker")
	ok(run.award_upgrade_pick(clean), "§2c: the award did not queue")
	var before: Array = (clean["up_candidates"][0] as Array).duplicate()
	var got: Array = run.upgrade_choice(clean)
	ok(got.size() == before.size(),
		"§2c: a clean offer came back a different size (%d against %d)" % [
			got.size(), before.size()])
	var same := true
	for i in mini(got.size(), before.size()):
		if String((got[i] as Dictionary)["id"]) != String((before[i] as Dictionary)["id"]) \
				or String((got[i] as Dictionary)["ability"]) != String((before[i] as Dictionary)["ability"]):
			same = false
	ok(same, "§2c: a clean offer was REROLLED — %s against %s" % [got, before])

	# (2) AN OFFER NAMING AN UPGRADE THE HERO HAS TAKEN IS DROPPED.
	var stale := _member("warrior", "berserker")
	ok(run.award_upgrade_pick(stale), "§2c: the award did not queue (stale arm)")
	var offer: Array = (stale["up_candidates"][0] as Array).duplicate()
	ok(offer.size() >= 1, "§2c: the offer came back empty")
	var head: Dictionary = offer[0]
	var uid := String(head["id"])
	stale["upgrades"] = [{"id": uid, "ability": String(head["ability"])}]
	ok(run.has_upgrade(stale, uid),
		"§2c: the arm's premise is not set up — the hero does not hold %s" % uid)
	var repaired: Array = run.upgrade_choice(stale)
	var still: Array = []
	for c in repaired:
		if String((c as Dictionary)["id"]) == uid:
			still.append(c)
	ok(still.is_empty(),
		"§2c: the repaired offer STILL carries %s, which the hero has taken — AP's once-per-run rule is broken at the ANSWER" % uid)
	ok((stale["up_candidates"][0] as Array) == repaired,
		"§2c: the repair was not WRITTEN BACK — `_pick_upgrade` takes an INDEX and would hand over the wrong entry")
	ok(run.upgrade_choice(stale) == repaired,
		"§2c: a second call repaired again — it is a reroll, not a repair")
	var ids := {}
	var dup: Array = []
	for c2 in repaired:
		var i2 := String((c2 as Dictionary)["id"])
		if ids.has(i2):
			dup.append(i2)
		ids[i2] = true
	ok(dup.is_empty(), "§2c: the repaired offer names the same upgrade twice — %s" % [dup])

	# (3) TWO QUEUED PICKS, ANSWERED IN SEQUENCE, NEVER WRITE ONE ID TWICE.
	# This is the fault as the player meets it, rather than as a function call.
	#
	# **THE COLLISION IS CONSTRUCTED RATHER THAN WAITED FOR, AND THAT IS THE
	# DIFFERENCE BETWEEN AN ASSERTION AND A COIN FLIP.** Two real queued offers
	# share an (ability, upgrade) PAIR in 247 of 400 trials — so on a fixed seed
	# they may or may not, and an arm that only bites when they happen to
	# collide reads GREEN against a neutered repair. It did: the first arming of
	# this section caught one failure of the three it aims at. The second offer
	# is therefore made a COPY of the first, which is a state the game reaches
	# in roughly five runs in eight.
	var both := _member("hunter", "mystic")
	ok(run.award_upgrade_pick(both) and run.award_upgrade_pick(both),
		"§2c: two mini-boss picks did not queue")
	var q0: Array = both["up_candidates"]
	ok(q0.size() == 2, "§2c: %d offers queued, not 2" % q0.size())
	if q0.size() == 2:
		q0[1] = (q0[0] as Array).duplicate(true)
		both["up_candidates"] = q0
	for pick in 2:
		var live: Array = run.upgrade_choice(both)
		if live.is_empty():
			continue
		var q: Array = both["up_candidates"]
		q.pop_front()
		both["up_candidates"] = q
		both["upgrades"] = (both["upgrades"] as Array) + [(live[0] as Dictionary).duplicate()]
	var seen := {}
	var twice: Array = []
	for u in both["upgrades"]:
		var k := String((u as Dictionary)["id"])
		if seen.has(k):
			twice.append(k)
		seen[k] = true
	ok(twice.is_empty(),
		"§2c: two mini-boss picks handed the hero %s TWICE — %s" % [twice, both["upgrades"]])
	print("    two queued picks answered in sequence -> %s" % [both["upgrades"]])

	# (4) AND THE STACK IS REAL, SO THE GUARD IS WORTH ITS LINES.
	# Six of eight stamps compound. Asserted on `up_break`, whose doubling is
	# the least ambiguous of them: pressure x2 once and x4 twice.
	var target := ""
	for ab in Classes.ability_corpus():
		var nm := String(ab.display_name)
		var t: Ability = Classes.pool_ability(nm)
		if t != null and run.upgrade_fits("up_break", t) and t.pressure > 0:
			target = nm
			break
	ok(target != "", "§2c: no ability fits `up_break` — the stack arm has nothing to measure")
	if target != "":
		var a0: Ability = Classes.pool_ability(target)
		var a1: Ability = Classes.pool_ability(target)
		var a2: Ability = Classes.pool_ability(target)
		run.apply_upgrades({"upgrades": [{"id": "up_break", "ability": target}]}, [a1])
		run.apply_upgrades({"upgrades": [{"id": "up_break", "ability": target},
			{"id": "up_break", "ability": target}]}, [a2])
		ok(a1.pressure == a0.pressure * 2,
			"§2c: Weighted no longer doubles (%d from %d)" % [a1.pressure, a0.pressure])
		ok(a2.pressure == a0.pressure * 4,
			"§2c: `_stamp_upgrade` has become IDEMPOTENT for up_break (%d twice, %d once) — the guard above is now belt-and-braces and this section should say so" % [a2.pressure, a1.pressure])
		print("    %s pressure: raw %d, once %d, twice %d — the stack the guard prevents"
			% [target, a0.pressure, a1.pressure, a2.pressure])


# ── §2d — BOTH PICKS, THROUGH THE REAL SCREEN ───────────────────────────────
#
# **FD §1e's RULE: A GATE THAT RE-IMPLEMENTS THE HANDLER PROVES ITS OWN COPY
# CORRECT.** The map screen is instantiated, two picks of each kind are queued
# without either being answered, the overlay is OPENED and its rendered button
# labels are read, and the picks are taken through the real handlers.
func _s2d_the_live_screen() -> void:
	print("\n§2d — both picks, driven on the real map screen")
	var run: Node = root.get_node("/root/Run")
	run.sim_run = true            # never touch the player's save
	run.new_run()
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "cryomancer", "inquisitor",
			"beastmaster"][i]
	run.specs_chosen = true

	# THE INQUISITOR, WHOSE BOSS POOL IS TWO — index 2.
	var inq: Dictionary = run.party[2]
	inq["bm_abilities"] = []
	inq["bm_equipped"] = []
	inq["bm_candidates"] = []
	inq["bm_picks_owed"] = 0
	for b in 3:
		run.award_ability_pick(inq)
	ok(int(inq.get("bm_picks_owed", 0)) == 3,
		"§2d: the Inquisitor is owed %d picks, not 3" % int(inq.get("bm_picks_owed", 0)))

	var screen: Node = load("res://scenes/map.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	await process_frame

	var answered := 0
	var empty_overlay := 0
	for pick in 3:
		screen.call("_open_pick_overlay", 2)
		await process_frame
		# **THE BUTTONS MUST BE READ OFF THE OVERLAY, NOT OFF THE SCREEN.** The
		# map screen is covered in buttons of its own — map nodes, hero cards —
		# and a walk of the whole tree picks those up and reads them as offers.
		# The overlay is the `z_index = 60` Control `_open_pick_overlay` adds,
		# and a queue_free'd one is still IN the tree for a frame, so the
		# doomed ones are skipped rather than counted.
		var overlay: Node = null
		for c in screen.get_children():
			if c is Control and (c as Control).z_index == 60 \
					and not c.is_queued_for_deletion():
				overlay = c
		ok(overlay != null,
			"§2d: the pick overlay was not opened on pick %d — the drive read nothing" % (pick + 1))
		if overlay == null:
			break
		var labels: Array = []
		_button_labels(overlay, labels)
		var offered: Array = []
		for l in labels:
			var s := String(l)
			if s == "Not yet":
				continue
			offered.append(s)
		if offered.is_empty():
			empty_overlay += 1
			overlay.queue_free()
			await process_frame
			break
		# Every drawn button must be LIVE — the fault was a button that did
		# nothing when pressed, which no assertion on the pouch can see.
		var owned: Array = run.owned_ability_names(inq)
		var dead: Array = []
		for o in offered:
			if owned.has(String(o)):
				dead.append(String(o))
		ok(dead.is_empty(),
			"§2d: the overlay drew %s, which the hero already holds — a button that does NOTHING when pressed" % [dead])
		screen.call("_pick_ability", 2, String(offered[0]))
		overlay.queue_free()
		await process_frame
		await process_frame
		answered += 1
	ok(empty_overlay == 0,
		"§2d: the overlay drew no pick buttons at all on pick %d — the pick is STRANDED" % (answered + 1))
	ok(answered == 3,
		"§2d: only %d of 3 deferred zone-boss picks could be answered through the real screen" % answered)
	var held: Array = inq["bm_abilities"]
	var dupes: Array = []
	for n in held:
		if held.count(n) > 1 and not dupes.has(n):
			dupes.append(n)
	ok(dupes.is_empty(), "§2d: the Inquisitor holds a duplicate ability — %s" % [held])
	ok(int(inq.get("bm_picks_owed", 0)) == 0,
		"§2d: %d picks are still owed after three were answered" % int(inq.get("bm_picks_owed", 0)))
	print("    Inquisitor answered %d picks through the screen, holding %s" % [answered, held])

	# AND THE UPGRADE PICK, THE SAME WAY, ON THE BERSERKER — index 0.
	var m0: Dictionary = run.party[0]
	m0["upgrades"] = []
	m0["up_candidates"] = []
	m0["up_picks_owed"] = 0
	run.award_upgrade_pick(m0)
	run.award_upgrade_pick(m0)
	ok(int(m0.get("up_picks_owed", 0)) == 2,
		"§2d: the Berserker is owed %d upgrade picks, not 2" % int(m0.get("up_picks_owed", 0)))
	# The collision, constructed for §2c's reason — an arm that waits for it is
	# a coin flip on the seed.
	var uq: Array = m0["up_candidates"]
	ok(uq.size() == 2, "§2d: %d upgrade offers queued, not 2" % uq.size())
	if uq.size() == 2:
		uq[1] = (uq[0] as Array).duplicate(true)
		m0["up_candidates"] = uq
	for pick2 in 2:
		screen.call("_open_pick_overlay", 0)
		await process_frame
		var ov2: Node = null
		for c2 in screen.get_children():
			if c2 is Control and (c2 as Control).z_index == 60 \
					and not c2.is_queued_for_deletion():
				ov2 = c2
		ok(ov2 != null, "§2d: the upgrade overlay was not opened on pick %d" % (pick2 + 1))
		screen.call("_pick_upgrade", 0, 0)
		if ov2 != null:
			ov2.queue_free()
		await process_frame
		await process_frame
	var ups: Array = m0["upgrades"]
	var seen2 := {}
	var twice2: Array = []
	for u in ups:
		var k := String((u as Dictionary)["id"])
		if seen2.has(k):
			twice2.append(k)
		seen2[k] = true
	ok(ups.size() == 2, "§2d: %d upgrades landed, not 2 — %s" % [ups.size(), ups])
	ok(twice2.is_empty(),
		"§2d: the screen handed the Berserker %s TWICE — %s" % [twice2, ups])
	ok(int(m0.get("up_picks_owed", 0)) == 0,
		"§2d: %d upgrade picks are still owed" % int(m0.get("up_picks_owed", 0)))
	print("    Berserker took %s through the screen" % [ups])
	screen.queue_free()
	await process_frame


func _button_labels(node: Node, out: Array) -> void:
	if node is Button:
		out.append(String((node as Button).text))
	for c in node.get_children():
		_button_labels(c, out)
