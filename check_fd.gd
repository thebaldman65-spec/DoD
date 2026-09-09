# BATCH FD — THE CACHE RE-ASKS, BREAK IS SECONDARY-ONLY, AND THE SHARED RUIN
# IS RENAMED.
#
#   §1  EVERY OFFER SITE, ENUMERATED AND DRIVEN — the roll doors were never the
#       hole; the RESOLUTION door was, and it is one door now
#   §2  NO CARD CARRIES BREAK AS ITS PRIMARY, and what that does to the two
#       conditions, derived rather than asserted from a stored number
#   §3  THE SHARED RUIN'S NAME, and the BR §1 sweep on the shortened form
#
# **WHY THIS BATCH EARNS A GATE, AND §1 IS THE WHOLE ARGUMENT.** The designer
# reported retired runes still being offered. `check_et` §2 drives five doors
# on twelve specs and reads clean — and both reports were true at once, because
# **`roll_rune_candidates` does not roll at the offer.** It rolls at the DROP,
# stores its triple on the member, and the triple rides the save until the
# player answers it. Between those two moments a rune can be retired and a rune
# can be bought, and nothing re-asked. `Runes.is_retired` had ZERO callers in
# the game.
#
#   §1 IS DRIVEN THROUGH THE REAL SCREEN, not through a re-implementation of
#     it. A gate that inlines `_pick_rune`'s body proves its own copy correct
#     and says nothing about the one the player presses — so the map screen is
#     instantiated, a poisoned triple is queued, the pick overlay is OPENED and
#     its rendered button labels are read, and the pick is taken through the
#     real handler.
#   §2 DECAYS SILENTLY IN ONE DIRECTION ONLY. Nothing gates on BREAK today, so
#     the demotion is free today; the day a rune is authored against a BREAK
#     threshold it can never be met, and the assertion that says so is here.
#   §3 IS ONE STRING and is asserted with its collision sweep beside it,
#     because BR §1's rule is that a name is swept against the whole roster.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fd.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260906)
	print("BATCH FD — THE CACHE RE-ASKS, BREAK IS SECONDARY-ONLY, THE SHARED RUIN IS RENAMED")
	_s1_the_offer_sites()
	await _s1e_the_live_screen()
	_s1f_the_merchant_sells_no_draft()
	_s2_break_is_secondary_only()
	_s3_the_rename()
	_g.report(self)


func _member(class_key: String, spec: String) -> Dictionary:
	return {"key": class_key, "spec": spec, "runes": [], "abilities": [],
		"earned_abilities": [], "bm_abilities": []}


# ── §1 — EVERY OFFER SITE, ENUMERATED AND DRIVEN ────────────────────────────
#
# **THE POPULATION IS DERIVED FROM THE WRITE, NOT FROM A LIST.** A rune reaches
# a hero exactly where something appends to `member["runes"]`, and there are
# four such sites in the shipped game. Each is pinned by the CALL it makes, so
# a fifth site — or one of these four re-pointed at a pool of its own — has to
# move a line here.
#
#   THE PEDDLER            `shop_screen._roll_offers` → `Run.generate_rune`
#   THE ELITE CACHE        `battle.gd` victory → `Run.roll_rune_candidates`
#   THE BARGAIN (a rung)   `run_state._resolve_bargain` → the same
#   THE EVENT VERB         `events.gd` → `Run.grant_rune`
#
# The spec-choice screen offers NO rune (AN deleted the opening pick), boss
# trophies award ABILITIES, and no relic grants one — all three asserted below
# as absences, because "this site is fine" and "this site does not exist" are
# different claims and only the second one stays true on its own.
const OFFER_SITES := {
	"scripts/shop_screen.gd": "Run.generate_rune(member)",
	"scripts/battle.gd": "Run.roll_rune_candidates(looter)",
	"scripts/run_state.gd": "roll_rune_candidates(looter)",
	"scripts/events.gd": "run.grant_rune(taker)",
}

# The files that must grant NO rune. `spec_choice_screen.gd` is the one that
# used to and no longer does.
const NO_RUNE_GRANT := ["scripts/spec_choice_screen.gd", "scripts/relics.gd",
	"scripts/blacksmith_screen.gd", "scripts/offer_screen.gd",
	"scripts/party_screen.gd"]

const TRIALS := 400


func _s1_the_offer_sites() -> void:
	print("\n§1 — every offer site, enumerated and driven")
	var run: Node = root.get_node("/root/Run")
	var had_sim: bool = run.sim_run
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")

	# ── (a) THE POPULATION ──────────────────────────────────────────────────
	var missing: Array = []
	for path in OFFER_SITES:
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
		if not src.contains(String(OFFER_SITES[path])):
			missing.append(path)
	ok(missing.is_empty(),
		"§1a: an offer site stopped calling the door it is pinned on — %s" % [missing])
	var granting: Array = []
	for path2 in NO_RUNE_GRANT:
		var src2 := Gate.strip_comments(FileAccess.get_file_as_string("res://" + path2))
		if src2.contains("[\"runes\"] =") or src2.contains("generate_rune") \
				or src2.contains("grant_rune"):
			granting.append(path2)
	ok(granting.is_empty(),
		"§1a: a file that must grant no rune now grants one — %s" % [granting])

	# ── (b) EVERY ROLL DOOR, DRIVEN, ON THE DESIGNER'S OWN FOUR SPECS AND ON
	#        ALL TWELVE. This is ET §2's property and it was never the hole —
	#        it is re-driven because a gate that only tests the repair cannot
	#        tell a fixed leak from a leak that moved.
	var leaked: Array = []
	var drawn := 0
	var live_seen := {}
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			var m := _member(String(ckey), String(spec))
			# **THIRTY DRAWS A SPEC, NOT ONE, AND THE REASON IS THE FLOOR
			# BELOW.** Eight of the twelve specs have no live rune at all, and
			# the four that do draw against six template markers as well — so
			# one draw a spec reached TWO distinct live runes and twelve reached
			# ten, and the floor read as a broken walk when it was a thin
			# sample. Thirty is chosen off the arithmetic rather than by
			# raising it until it passed: eleven entries in the richest pool,
			# so 30 draws leave a (10/11)^30 = 5.7% chance of missing any one.
			for _d in 30:
				var one: Dictionary = run.generate_rune(m)
				drawn += 1
				if Runes.is_retired(String(one.get("id", ""))):
					leaked.append("%s/shop -> %s" % [spec, one.get("id", "")])
				elif not String(one.get("id", "")).begins_with("tpl_"):
					live_seen[String(one["id"])] = true
			var granted: Dictionary = run.grant_rune(_member(String(ckey), String(spec)))
			drawn += 1
			if Runes.is_retired(String(granted.get("id", ""))):
				leaked.append("%s/grant -> %s" % [spec, granted.get("id", "")])
			for _t in 8:
				var trip: Array = run.roll_rune_candidates(_member(String(ckey), String(spec)))
				drawn += 1
				for c in trip:
					if Runes.is_retired(String((c as Dictionary).get("id", ""))):
						leaked.append("%s/cache -> %s" % [spec, c.get("id", "")])
	ok(drawn > 100, "§1b: only %d draws were taken — the drive read nothing" % drawn)
	ok(leaked.is_empty(), "§1b: a RETIRED entry reached a rolled offer — %s" % [leaked])
	# **THE FLOOR IS ON THE LIVE HALF BECAUSE THE RETIRED HALF IS UNREACHABLE BY
	# CONSTRUCTION** (ET §1's own reasoning): "nothing retired came out" is
	# exactly what a walk that read nothing would print, so the live count is
	# the only thing that can prove the drive ran. A FLOOR rather than an
	# equality — which specs get authored next is content.
	ok(live_seen.size() >= 15,
		"§1b: the shop drive reached %d distinct LIVE runes — it lost its population"
			% live_seen.size())
	print("    %d draws through three roll doors; 0 retired, %d live runes reached"
		% [drawn, live_seen.size()])

	# ── (c) `Run.rune_choice` — THE RESOLUTION DOOR, WHICH IS WHERE THE HOLE
	#        WAS. Four properties, each armed on a triple that carries the
	#        fault: a retired entry, a rune the hero wears, a duplicate inside
	#        the triple, and a triple with nothing wrong with it.
	var poisoned := _member("hunter", "sharpshooter")
	poisoned["rune_candidates"] = [[Runes.build("keen_focus"),
		Runes.build("deep_sight"), Runes.build("narrow_gap")]]
	poisoned["rune_picks_owed"] = 1
	var fixed: Array = run.rune_choice(poisoned)
	var still: Array = []
	for c in fixed:
		if Runes.is_retired(String((c as Dictionary).get("id", ""))):
			still.append(c["name"])
	ok(still.is_empty(),
		"§1c: a queued triple still offers a RETIRED rune after the re-ask — %s" % [still])
	ok(fixed.size() == 3,
		"§1c: the repaired triple is %d long — the top-up did not refill it" % fixed.size())
	# **AND THE REPAIR IS WRITTEN BACK.** A repair that is recomputed on every
	# open is a REROLL, which is the thing BATCH X ruled against; a repair that
	# is not stored means the screen and the handler can disagree about which
	# rune index 1 is.
	var head: Array = (poisoned["rune_candidates"] as Array)[0]
	ok(str(head.map(func(r): return r["name"]))
			== str(fixed.map(func(r): return r["name"])),
		"§1c: the repair was not written back onto the member")

	var worn := _member("hunter", "sharpshooter")
	worn["runes"] = [Runes.build("heavy_bolts")]
	worn["rune_candidates"] = [[Runes.build("heavy_bolts"),
		Runes.build("keen_focus"), Runes.build("keen_focus")]]
	worn["rune_picks_owed"] = 1
	var fixed2: Array = run.rune_choice(worn)
	var names := {}
	var bad: Array = []
	for c in fixed2:
		var nm := String((c as Dictionary)["name"])
		if nm == "Heavy Bolts" or names.has(nm):
			bad.append(nm)
		names[nm] = true
	ok(bad.is_empty(),
		"§1c: the re-ask left a rune the hero WEARS, or a repeat, in the triple — %s" % [bad])
	ok(fixed2.size() == 3, "§1c: ...and refilled it to three (%d)" % fixed2.size())
	# IDEMPOTENT — the render calls it and then the handler calls it, and the
	# second call must not move the array the buttons were built from.
	var again: Array = run.rune_choice(worn)
	ok(str(again.map(func(r): return r["name"]))
			== str(fixed2.map(func(r): return r["name"])),
		"§1c: a second call moved the triple — the buttons and the handler can disagree")
	# A CLEAN TRIPLE IS RETURNED UNTOUCHED. Without this the section passes on a
	# function that simply rerolls, which would satisfy every arm above and
	# break the rule the cache is built on.
	var clean_m := _member("hunter", "sharpshooter")
	var rolled: Array = run.roll_rune_candidates(clean_m)
	clean_m["rune_candidates"] = [rolled]
	clean_m["rune_picks_owed"] = 1
	var same: Array = run.rune_choice(clean_m)
	ok(str(same.map(func(r): return r["name"]))
			== str(rolled.map(func(r): return r["name"])),
		"§1c: a triple with nothing wrong with it was rerolled — that is not the repair")
	ok((run.rune_choice(_member("hunter", "sharpshooter")) as Array).is_empty(),
		"§1c: a member with no queue must get an empty choice, not a fresh roll")

	# ── (d) THE MEASUREMENT THE REPAIR IS FOR, RE-DRIVEN. Two caches queued
	#        before either is answered roll against the same pouch; the raw
	#        collision rate is the finding and the post-repair rate is the fix.
	var raw := 0
	var after := 0
	for _t2 in TRIALS:
		var mm := _member("hunter", "sharpshooter")
		var t1: Array = run.roll_rune_candidates(mm)
		var t2: Array = run.roll_rune_candidates(mm)
		var n1 := {}
		for c in t1:
			n1[String(c["name"])] = true
		for c in t2:
			if n1.has(String(c["name"])):
				raw += 1
				break
		mm["rune_candidates"] = [t1, t2]
		mm["rune_picks_owed"] = 2
		var a: Array = run.rune_choice(mm)
		mm["runes"] = [a[0]]
		(mm["rune_candidates"] as Array).pop_front()
		var b: Array = run.rune_choice(mm)
		for c2 in b:
			if String((c2 as Dictionary)["name"]) == String(a[0]["name"]):
				after += 1
				break
	ok(raw > TRIALS / 4,
		"§1d: only %d of %d raw triple pairs collided — the arm is not armed" % [raw, TRIALS])
	ok(after == 0,
		"§1d: the second pick still offered the first pick's rune %d times of %d"
			% [after, TRIALS])
	print("    two queued caches, %d trials: raw collisions %d, after the re-ask %d"
		% [TRIALS, raw, after])
	run.sim_run = had_sim


# ── §1e — THE LIVE SCREEN ───────────────────────────────────────────────────
#
# **THE ONLY ARM THAT COVERS WHAT THE PLAYER PRESSES.** Everything above drives
# `Run.rune_choice`; this drives `map_screen`, which is where the defect was
# reported. The overlay's own buttons are read for their labels — a repair that
# fixed the handler and not the render would show a retired rune and hand over
# a different one, which is worse than the fault it replaces.
func _s1e_the_live_screen() -> void:
	print("\n§1e — the pick overlay, driven on the real map screen")
	var run: Node = root.get_node("/root/Run")
	run.sim_run = true            # never touch the player's save
	run.new_run()
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "cryomancer", "inquisitor",
			"beastmaster"][i]
	run.specs_chosen = true
	# `sim_run` is what skips the orientation card (`_maybe_show_framing`
	# refuses under it), so this gate sets NO Profile flag — `gate_fixture`'s
	# header is explicit that a gate writing `user://profile.json` is the
	# opposite of what `check_ct` promises.
	# The Sharpshooter is the spec with live runes to collide with; the hunter
	# slot is index 3.
	run.party[3]["spec"] = "sharpshooter"
	var member: Dictionary = run.party[3]
	member["runes"] = [Runes.build("heavy_bolts")]
	member["rune_candidates"] = [[Runes.build("heavy_bolts"),
		Runes.build("deep_sight"), Runes.build("keen_focus")]]
	member["rune_picks_owed"] = 1

	var screen: Node = load("res://scenes/map.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	await process_frame
	screen.call("_open_pick_overlay", 3)
	await process_frame
	var labels: Array = []
	_button_labels(screen, labels)
	var offered: Array = []
	for l in labels:
		var s := String(l)
		if s.contains("  ["):
			offered.append(s.split("  [")[0])
	ok(not offered.is_empty(),
		"§1e: the rune overlay drew NO pick buttons — the drive read nothing")
	ok(not offered.has("Heavy Bolts"),
		"§1e: the overlay OFFERED a rune the hero is wearing — %s" % [offered])
	ok(not offered.has("Rune of the Deep Sight"),
		"§1e: the overlay OFFERED a retired rune — %s" % [offered])
	print("    the overlay drew: %s" % [offered])

	# AND THE PICK ITSELF, THROUGH THE REAL HANDLER.
	screen.call("_pick_rune", 3, 0)
	await process_frame
	var pouch: Array = []
	for r in member.get("runes", []):
		pouch.append(String(r["name"]))
	ok(pouch.size() == 2, "§1e: the pick did not land (pouch %s)" % [pouch])
	ok(pouch[0] != pouch[1],
		"§1e: the pick put a SECOND copy of a rune in the pouch — %s" % [pouch])
	ok(not pouch.has("Rune of the Deep Sight"),
		"§1e: the pick handed over a RETIRED rune — %s" % [pouch])
	ok(int(member.get("rune_picks_owed", 0)) == 0,
		"§1e: the owed pick was not spent (%d)" % int(member.get("rune_picks_owed", 0)))
	print("    after the pick the pouch reads: %s" % [pouch])
	screen.queue_free()
	await process_frame


func _button_labels(node: Node, out: Array) -> void:
	if node is Button:
		out.append(String((node as Button).text))
	for c in node.get_children():
		_button_labels(c, out)


# ── §1f — THE MERCHANT SELLS NO DRAFT ───────────────────────────────────────
#
# **RE-POINTED, NOT DELETED, AND IN THE OPPOSITE DIRECTION.** `test_batch_bo`
# §3 pinned three needles proving the Peddler sold a draft pick; the designer
# has ruled it does not, so those three become their own negatives here and
# there. **The other three sources are asserted STILL PRESENT in the same
# breath**, because "the merchant stopped selling one" and "the draft still
# arrives" are different claims and a batch can satisfy the first by breaking
# the second.
func _s1f_the_merchant_sells_no_draft() -> void:
	print("\n§1f — the merchant sells no draft pick")
	var shop := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/shop_screen.gd"))
	ok(not shop.contains("Run.draft_price()"),
		"§1f: the merchant still prices a draft")
	ok(not shop.contains("Run.award_draft_pick("),
		"§1f: the merchant still sells the offer")
	ok(not shop.contains("draft_pool_left"),
		"§1f: the merchant still reads what is left of the pool")
	# THE PRICE IS KEPT AND IS REACHED BY NOTHING — the Melted Armor contract.
	var run: Node = root.get_node("/root/Run")
	run.zone_idx = 0
	ok(int(run.draft_price()) == 120,
		"§1f: `draft_price` was deleted with its caller (reads %d)" % int(run.draft_price()))
	var callers: Array = []
	for path in ["scripts/shop_screen.gd", "scripts/map_screen.gd",
			"scripts/events.gd", "scripts/battle.gd", "scripts/run_sim.gd",
			"scripts/run_state.gd"]:
		var s := Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
		if s.contains("draft_price()") and not s.contains("func draft_price()"):
			callers.append(path)
	ok(callers.is_empty(),
		"§1f: `draft_price` has a game-side caller again — %s" % [callers])
	# THE THREE SOURCES THAT REMAIN.
	var bat := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var ev := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/events.gd"))
	ok(bat.contains("Run.award_draft_pick(d_taker)"),
		"§1f: an elite no longer offers a draft — the ruling took a source it did not name")
	ok(ev.contains("\"ability_draft\""), "§1f: the event verb is gone too")
	ok(Events.VERBS.has("ability_draft"), "§1f: ...and out of the vocabulary")
	ok(bat.contains("func _award_ability_picks() -> Array:"),
		"§1f: the zone-boss pick is gone too")


# ── §2 — NO CARD CARRIES BREAK AS ITS PRIMARY ───────────────────────────────
func _s2_break_is_secondary_only() -> void:
	print("\n§2 — BREAK is a secondary tag only")
	var primary := {}
	for t in Classes.TAG_ORDER:
		primary[String(t)] = 0
	var break_first: Array = []
	var lost_break: Array = []
	var only_break: Array = []
	for name in Classes.CARD_TAGS:
		var tags: Array = Classes.CARD_TAGS[name]
		var p := String(tags[0])
		primary[p] = int(primary[p]) + 1
		if p == "BREAK":
			break_first.append(String(name))
			if tags.size() == 1:
				only_break.append(String(name))
	ok(break_first.is_empty(),
		"§2: %d cards still carry BREAK as their PRIMARY — %s" % [
			break_first.size(), break_first.slice(0, 6)])
	ok(only_break.is_empty(),
		"§2: %s carry BREAK as their ONLY tag" % [only_break])
	ok(Classes.CARD_TAGS.size() == 227,
		"§2: the corpus is %d rows, not 227 — the transform moved a row"
			% Classes.CARD_TAGS.size())
	# **THE COUNT IS A FLOOR, NOT AN EQUALITY.** 54 rows moved to
	# `["OFFENSE", "BREAK"]`; a card authored later may join them, and OFFENSE
	# is where a BREAK card now lives. A floor says "the demotion happened"
	# without pinning a number content will move.
	ok(int(primary["OFFENSE"]) >= 54,
		"§2: OFFENSE carries %d primaries — the 54 that moved are not there"
			% int(primary["OFFENSE"]))
	var secondary := 0
	for name2 in Classes.CARD_TAGS:
		var t2: Array = Classes.CARD_TAGS[name2]
		if t2.size() > 1 and String(t2[1]) == "BREAK":
			secondary += 1
	ok(secondary >= 53,
		"§2: only %d cards carry BREAK at all — a straight REMOVAL is what was rejected"
			% secondary)
	var line := ""
	for t3 in Classes.TAG_ORDER:
		line += "%s %d   " % [t3, int(primary[String(t3)])]
	print("    primary spread over %d cards: %s" % [Classes.CARD_TAGS.size(), line])
	print("    cards carrying BREAK as a SECONDARY: %d" % secondary)

	# ── WHAT IT DOES TO THE TWO CONDITIONS, DERIVED ─────────────────────────
	#
	# **THRESHOLD IS UNTOUCHED AND THAT IS PROVABLE WITHOUT A STORED "BEFORE".**
	# The transform moved cards from BREAK to OFFENSE and touched no other
	# column, so a threshold's count can only move if it names one of those two
	# words. No live rune names either — asserted here, both ways, so the day a
	# rune is authored against a BREAK threshold this section says the condition
	# can never be met rather than shipping a dead rune.
	# ── BATCH FN — THE CENSUS INVERTED, AND THE REASON IS NOT THAT IT PASSES ─
	# It read "at least eight live runes carry a condition" as its population
	# assertion — the walk's own EA §5 guard — and then asserted none of them
	# names BREAK or OFFENSE. **FN retired THRESHOLD and BREADTH and ungated the
	# eight**, so the population is ZERO by ruling and the two negatives below
	# are true for a stronger reason than the one they were written for. The
	# population arm is inverted rather than dropped: a rune re-gated on
	# anything at all turns it red here as well as in `check_fn` §1b.
	var gated: Array = []
	var on_break: Array = []
	var on_offense: Array = []
	for id in Runes.ids():
		if Runes.is_retired(String(id)):
			continue
		var cond: Dictionary = (Runes.config(String(id)).get("payload", {}) as Dictionary) \
			.get("condition", {})
		if cond.is_empty():
			continue
		gated.append(String(id))
		var tag := String(cond.get("tag_threshold", ""))
		if tag == "BREAK":
			on_break.append(String(id))
		elif tag == "OFFENSE":
			on_offense.append(String(id))
	ok(gated.is_empty(),
		"§2: %d live runes carry a condition — FN retired both gated secondaries (%s)"
			% [gated.size(), gated])
	ok(on_break.is_empty(),
		"§2: %s gate on a BREAK threshold, which NO CARD can now contribute to" % [on_break])
	ok(on_offense.is_empty(),
		"§2: %s gate on an OFFENSE threshold — the 54 that moved changed its count" % [on_offense])
	print("    %d live runes are gated; %d name BREAK, %d name OFFENSE"
		% [gated.size(), on_break.size(), on_offense.size()])
	# **AND THE WALK ITSELF STILL READS A REAL POOL**, which is what stops the
	# three zeroes above being what an empty `Runes.ids()` prints.
	var live_seen := 0
	for id_l in Runes.ids():
		if not Runes.is_retired(String(id_l)):
			live_seen += 1
	ok(live_seen >= 55,
		"§2: the condition walk read %d live runes — the zeroes above are the walk's, not the pool's"
			% live_seen)

	# **THE TRANSFORM IS STILL RECONSTRUCTED EXACTLY, AND THAT IS WHAT SURVIVES
	# BATCH FN.** Before FD **no row read `["OFFENSE", "BREAK"]`** — the three
	# cards that carried both had them the other way round — so every row
	# reading exactly that pair today is one of the 53 that moved. The count is
	# the reconstruction's own population check: a table somebody rewrote
	# wholesale reads a different number here before any claim below is made.
	#
	# **WHAT WENT AT FN IS THE CONSUMER, NOT THE RECONSTRUCTION.** The drive
	# under this used it to show that the fold can only ever make BREADTH
	# harder; BREADTH is retired and its predicate is deleted, so there is
	# nothing left to be harder. See the block below.
	var moved := 0
	for nm3 in Classes.CARD_TAGS:
		var t4: Array = Classes.CARD_TAGS[nm3]
		if t4.size() == 2 and String(t4[0]) == "OFFENSE" and String(t4[1]) == "BREAK":
			moved += 1
	ok(moved == 53,
		"§2: %d rows read `[OFFENSE, BREAK]`, not the 53 that moved into that shape — the reconstruction is not exact"
			% moved)
	# **AND THE FIFTY-FOURTH IS FEINT, WHICH IS THE ONE PER-CARD JUDGEMENT IN
	# §2 AND IS ASSERTED RATHER THAN LEFT IN PROSE.** EL §2 ruled that Feint
	# carries MARK second (it marks on one of its two stance branches), so the
	# second slot was already owned by a ruling. FD §2's binding half is that
	# no card carries BREAK FIRST; the retained-secondary half loses to EL
	# here, and **Feint is the one card of the 54 where the demotion became a
	# removal.** `check_el` asserts the MARK half from its own side.
	ok(str(Classes.card_tags("Feint")) == str(["OFFENSE", "MARK"] as Array),
		"§2: Feint reads %s — it is the one card where EL §2 owns the second slot"
			% [Classes.card_tags("Feint")])
	# ── BATCH FN — THE BREADTH DRIVE STOOD HERE AND ITS SUBJECT IS GONE ─────
	#
	# **IT DROVE `breadth_met_fraction` OVER EVERY SPEC'S REAL LOADOUT AT 4, 5
	# AND 7 DRAFTED CARDS** and asserted that the fold never LOWERS the primary
	# peak, so BREADTH could only ever get harder — FD's own asymmetry, measured
	# rather than argued. **FN retired BREADTH and removed both
	# `Runes.breadth_met_fraction` and `Classes.primary_tag_peak`**, so the arm
	# has no predicate left to drive and its claim has no consumer.
	#
	# **IT IS REMOVED RATHER THAN RE-IMPLEMENTED IN THE GATE.** A gate carrying
	# its own copy of a retired predicate, asserting a property of a fold that
	# now moves nothing but a screen, is a check that can only pass — and the
	# measurement itself is kept where measurements belong, in
	# `docs/reports/FD.md` §2. The half of §2 that is about the CARDS is
	# untouched above, and it is the half FD's ruling actually binds.

	# **`RUNE_TAGS` WAS PINNED AT FIVE SO THE DAY IT WAS RULED ON THIS LINE WOULD
	# MOVE, AND AT BATCH FE IT DID.** The designer ruled that no RUNE carries
	# BREAK as its primary either, and all five rows FD reported now read
	# `["OFFENSE", "BREAK"]`. **RE-POINTED IN PLACE, WITH ITS REASON, RATHER
	# THAN DELETED** — FD's ruling named CARDS and this line is what recorded
	# that the runes had not followed; it records that they have now, and it is
	# still the thing that goes red if a sixth row is ever authored BREAK-first.
	# **`check_fe` §1 owns the population and the retention** (that all five
	# kept BREAK second); this arm stays deliberately narrow, on the one claim
	# FD's own section made.
	var rune_break: Array = []
	for rid in Runes.RUNE_TAGS:
		var rt: Array = Runes.RUNE_TAGS[rid]
		if not rt.is_empty() and String(rt[0]) == "BREAK":
			rune_break.append(String(rid))
	rune_break.sort()
	ok(rune_break.is_empty(),
		"§2: %d rune rows carry BREAK first — FE §1 ruled that none may (%s)" % [
			rune_break.size(), rune_break])
	print("    RUNE_TAGS rows primary-BREAK: %d (ruled to zero at FE §1)" % rune_break.size())


# ── §3 — THE SHARED RUIN'S NAME ─────────────────────────────────────────────
func _s3_the_rename() -> void:
	print("\n§3 — the Shared Ruin's name")
	var cfg: Dictionary = Runes.config("shared_ruin")
	ok(not cfg.is_empty(), "§3: `shared_ruin` is not in the pool")
	ok(String(Runes.display_name(cfg)) == "Shared Ruin",
		"§3: the rune reads `%s`" % Runes.display_name(cfg))
	ok(String(cfg.get("retired", "")) == "",
		"§3: the rename retired it")
	# BR §1 — SWEPT AGAINST THE WHOLE ROSTER. Abilities, the whole rune pool
	# (live AND retired), and the generated template family.
	var collide: Array = []
	for k in Classes.CARD_TAGS:
		if String(k) == "Shared Ruin":
			collide.append("ability:" + String(k))
	var seen := 0
	for id in Runes.ids():
		var nm := String(Runes.display_name(Runes.config(String(id))))
		seen += 1
		if nm == "Shared Ruin" and String(id) != "shared_ruin":
			collide.append("rune:" + String(id))
	for t in Runes.TEMPLATES:
		if "Rune of %s" % t["noun"] == "Shared Ruin":
			collide.append("template:" + String(t["noun"]))
	ok(seen == Runes.ids().size() and seen > 80,
		"§3: the name sweep read %d of %d entries" % [seen, Runes.ids().size()])
	ok(collide.is_empty(), "§3: `Shared Ruin` collides with %s" % [collide])
	# **AND NO LIVE RUNE WEARS THE RETIRED POOL'S SHAPE**, which is the reason
	# the rename was taken at all. A floor on the retired side proves the shape
	# is really the retired pool's rather than a coincidence of five names.
	var live_long: Array = []
	var retired_long := 0
	for id2 in Runes.ids():
		var nm2 := String(Runes.display_name(Runes.config(String(id2))))
		if not nm2.begins_with("Rune of "):
			continue
		if Runes.is_retired(String(id2)):
			retired_long += 1
		else:
			live_long.append(nm2)
	ok(live_long.is_empty(),
		"§3: a LIVE rune still wears the retired pool's `Rune of…` shape — %s" % [live_long])
	ok(retired_long >= 60,
		"§3: only %d retired runes wear that shape — the premise is not what it was"
			% retired_long)
	print("    live runes named `Rune of…`: 0; retired: %d of %d"
		% [retired_long, Runes.ids().size()])
