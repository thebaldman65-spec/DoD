# test_batch_bx.gd — EVERY HERO DRAFTS AFTER AN ELITE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bx.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite spawns live battles AND instantiates the map screen, so it
# parks on the first process_frame — autoloads are not in the tree during
# `_initialize`.
#
# WHAT IT PROTECTS, and every construction below is built so a BROKEN
# implementation still fails. For most of them the obvious assertion is not the
# discriminating one:
#
# · THE OFFER REACHES EVERY LIVING HERO. "Somebody was offered a draft" is
#   trivially true of BO's one-at-random, so the check counts FOUR owed picks
#   after one elite and asserts the random draw is GONE from both walk sites.
# · EACH DRAWS FROM THEIR OWN POOL. One offer inspected proves nothing — the
#   roll is random and a shared pool would agree with a private one most of the
#   time by luck. Every hero's offer is rolled 200 times and every card asserted
#   into that hero's OWN spec-plus-class pool, with a Pyromancer explicitly
#   asserted never to see a Warden card.
# · `draft_refused` IS PER MEMBER. This is the one §1 says to verify rather than
#   assume, and a shared ledger is the obvious implementation. The construction
#   is TWO HEROES ON ONE SPEC: hero A declines a whole offer, and hero B must
#   still be offerable EXACTLY those cards. A shared list makes B's pool shrink
#   and fails it. The empty-ledger assertion beside it is the cheap half.
# · THE SCREEN RESOLVES AS ONE ACTION. "The cards landed" is trivially true of a
#   per-column commit, so the discriminating assertion is taken BEFORE the
#   confirm: with all four columns chosen, NOTHING on any member has moved —
#   no ability learned, no pick spent, no ledger written.
# · A HERO AT CAP MUST DROP FIRST. "It refused" is trivially true of a version
#   that refuses everything, so the same column is asserted UNDECIDED with a
#   card staged and DECIDED the moment a drop is named — and the run-state door
#   is asserted to refuse the take outright without one.
# · A FALLEN HERO DRAFTS. The revive is not this batch's code, so the check is
#   an ORDERING one: `sync_victory_state` is driven on a unit at 0 HP and
#   asserted to return them ALIVE, and the victory branch is asserted to call it
#   ABOVE the draft block by SOURCE POSITION. An ordering accident is exactly
#   what §2 said to look for.
# · TWIN HUNT PICKS THE DEEPEST BOND. Identity, not magnitude: the two
#   companions are given wildly different `companion_power` so the blow says
#   which one struck with no room for the ±10% variance to matter, and the
#   construction is then MIRRORED so a version that always picks the second
#   summon fails too.
# · THE TWO RENAMED NODES KEEP THEIR IDS. That is §6's named negative control —
#   a rename that moves an id breaks every saved build — so the ids, the rows,
#   the lanes and the payload FIELDS are asserted unmoved beside the new names.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


func _initialize() -> void:
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return f.get_as_text() if f != null else ""


# Comments are stripped before every source-level check (BS's rule). This
# batch's own comments name `_beasts(attacker)[0]` and `Beast Within` on
# purpose — to tell a later author what was moved and why — and a bare
# `contains` would fail against working code and invite them to "fix" it by
# deleting the line that explains the decision.
func _code(path: String) -> String:
	var out := ""
	for ln in _src(path).split("\n"):
		if ln.strip_edges().begins_with("#"):
			continue
		out += ln + "\n"
	return out


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bx_test.json"
	Profile.loaded = false
	Profile.data = {}

	_reach_source()
	_own_pools()
	_ledger_per_member()
	_fill_short()
	_cap_and_drop()
	_fallen_hero()
	await _live_revive()
	_screen_source()
	await _live_one_action()
	await _live_elite_victory()
	_deepest_bond_source()
	await _live_deepest_bond()
	await _live_twin_hunt()
	_rename()
	_docs()

	if FileAccess.file_exists("user://profile_batch_bx_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bx_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BX: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# A run with four specced heroes, never touching the real save.
func _party(specs := ["pyromancer", "inquisitor", "beastmaster", "berserker"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = true
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in run.party.size():
		run.party[i]["spec"] = String(specs[i])
		run.party[i]["tree"] = Talents.generate_tree(String(specs[i]),
			String(run.party[i]["key"]))
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		run.party[i]["bm_abilities"] = []
		run.party[i]["draft_refused"] = []
		run.party[i]["draft_candidates"] = []
		run.party[i]["draft_picks_owed"] = 0
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	return run


# ---------- §2: the offer reaches every living hero ----------

func _reach_source() -> void:
	var bat := _code("res://scripts/battle.gd")
	var sim := _code("res://scripts/run_sim.gd")
	# THE ONE-AT-RANDOM DRAW IS GONE FROM BOTH WALKS. Deleting it rather than
	# leaving it unreachable is what stops a later batch reading the old line as
	# the live rule (the standing "deleted, not zeroed" rule).
	ok(not bat.contains("var d_taker: Dictionary = Run.party.pick_random()"),
		"§2: battle.gd no longer draws ONE hero for the draft")
	ok(not sim.contains("_award_draft(run, run.party.pick_random())"),
		"§2: RunSim no longer draws ONE hero for the draft")
	# ...and both now walk the party behind the same health gate.
	ok(bat.contains("for d_taker in Run.party:")
		and bat.contains("if int(d_taker.get(\"hp\", 0)) <= 0:"),
		"§2: battle.gd offers to every LIVING hero")
	ok(sim.contains("for d_m in run.party:")
		and sim.contains("if int(d_m.get(\"hp\", 0)) > 0:"),
		"§2: RunSim walks the party under the same gate")
	# THE RATE FIGURE §2 ASKS FOR IS REPORTED, and it is counted at the OFFER
	# rather than at the take, so a policy that declined would still book it.
	ok(sim.contains("static var draft_at_cap := 0"),
		"§2: the sim counts offers made to a hero at the cap")
	ok(sim.contains("draft_at_cap += 1"), "§2: ...bumped where the cap is read")
	ok(sim.contains("at cap when offered"), "§2: ...and printed in the report")

	# FOUR OWED PICKS AFTER ONE ELITE, counted rather than inferred. This is the
	# 4x, and it is the number the whole section turns on.
	var run := _party()
	var owed := 0
	for m in run.party:
		if run.award_draft_pick(m):
			owed += 1
	ok(owed == 4, "§2: one elite offers a draft to all FOUR heroes (got %d)" % owed)
	ok(run.owed_draft_picks() == 4,
		"§2: ...and the run counts four owed (got %d)" % run.owed_draft_picks())


# ---------- §2: each hero draws from their OWN pool ----------

func _own_pools() -> void:
	var run := _party(["swordmaster", "pyromancer", "occultist", "sharpshooter"])
	# 200 rolls a hero. ONE offer proves nothing here — a shared pool would
	# agree with a private one most of the time by luck, so the question is only
	# answerable at volume.
	var strays := 0
	var empties := 0
	var oversize := 0
	var dupes := 0
	for m in run.party:
		var spec := String(m["spec"])
		var mine: Array = Classes.spec_draft_pool(spec).duplicate()
		mine.append_array(Classes.class_draft_pool(Classes.class_of_spec(spec)))
		for _i in 200:
			var offer: Array = run.roll_draft_offer(m)
			if offer.is_empty():
				empties += 1
			if offer.size() > 3:
				oversize += 1
			var seen := {}
			for card in offer:
				if not mine.has(String(card)):
					strays += 1
				if seen.has(String(card)):
					dupes += 1
				seen[String(card)] = true
	ok(strays == 0, "§2: no hero was ever offered a card outside their own pools (%d strays)"
		% strays)
	ok(empties == 0, "§2: every offer held at least one card (%d empty)" % empties)
	ok(oversize == 0, "§2: no offer held more than three (%d oversize)" % oversize)
	ok(dupes == 0, "§2: an offer never repeats a card within itself (%d dupes)" % dupes)

	# THE NAMED CASE: A PYROMANCER IS NEVER OFFERED A WARDEN CARD. Asserted
	# explicitly rather than left to the sweep above, because it is the sentence
	# §2 is written in and a reader will look for it.
	var pyro: Dictionary = run.party[1]
	ok(String(pyro["spec"]) == "pyromancer", "§2: the harness seated a Pyromancer")
	var warden_cards: Array = Classes.spec_draft_pool("warden")
	# RE-POINTED BY BATCH CI: the Warrior third landed and the Warden drafts
	# EIGHT. The question — is there a real pool of his own that a Pyromancer
	# must never be shown — is unchanged, so it is written against the LIVE pool
	# rather than a literal, which is the shape the rest of this suite already
	# uses and the reason it needed no other repair this batch.
	ok(warden_cards.size() == 8, "§2: the Warden has eight spec cards to be offered")
	var leaked := 0
	for _i in 200:
		for card in run.roll_draft_offer(pyro):
			if warden_cards.has(String(card)):
				leaked += 1
	ok(leaked == 0, "§2: a Pyromancer is NEVER offered a Warden card (%d leaks)" % leaked)
	# Every card an offer can show must RESOLVE, or the column renders a name
	# with no description and the player is choosing blind.
	var unresolved := 0
	for spec in Classes.SPEC_DRAFT_POOLS:
		for card in Classes.spec_draft_pool(String(spec)):
			if Classes.pool_ability(String(card)) == null:
				unresolved += 1
	for cls in Classes.CLASS_DRAFT_POOLS:
		for card in Classes.class_draft_pool(String(cls)):
			if Classes.pool_ability(String(card)) == null:
				unresolved += 1
	ok(unresolved == 0, "§2: every draftable card resolves to an Ability (%d did not)"
		% unresolved)


# ---------- §2: the no-return ledger is PER MEMBER ----------

func _ledger_per_member() -> void:
	# TWO HEROES ON ONE SPEC is the construction that discriminates, and it is
	# deliberately artificial: the real party holds one of each class, so a
	# shared ledger would never be caught by an ordinary run. Hero A declines a
	# whole offer; hero B must still be offerable EXACTLY those cards.
	var run := _party(["cryomancer", "cryomancer", "inquisitor", "beastmaster"])
	var a: Dictionary = run.party[0]
	var b: Dictionary = run.party[1]
	ok(run.award_draft_pick(a), "§2: hero A is offered a draft")
	var a_offer: Array = (a["draft_candidates"] as Array)[0].duplicate()
	ok(a_offer.size() == 3, "§2: ...of three cards (got %d)" % a_offer.size())
	ok(run.decline_draft(a), "§2: hero A declines the whole offer")
	for card in a_offer:
		ok(run.draft_refused(a).has(String(card)),
			"§2: %s entered A's no-return ledger" % card)
	# THE HALF THAT MATTERS.
	ok(run.draft_refused(b).is_empty(),
		"§2: B's ledger is UNTOUCHED by A's decline (holds %d)"
			% run.draft_refused(b).size())
	var b_left: Array = run.draft_pool_left(b)["spec"]
	b_left.append_array(run.draft_pool_left(b)["class"])
	var hidden := 0
	for card in a_offer:
		if not b_left.has(String(card)):
			hidden += 1
	ok(hidden == 0,
		"§2: every card A refused can still be offered to B (%d were hidden)" % hidden)
	# And a TAKE refuses nothing at all — declining refuses the whole offer,
	# taking one refuses none of it (BO's rule, unchanged).
	var c: Dictionary = run.party[2]
	run.award_draft_pick(c)
	var c_offer: Array = (c["draft_candidates"] as Array)[0].duplicate()
	ok(run.take_draft_ability(c, String(c_offer[0])) == "",
		"§2: hero C takes a card")
	ok(run.draft_refused(c).is_empty(),
		"§2: taking one refuses NOTHING (ledger holds %d)" % run.draft_refused(c).size())


# ---------- §2: the offer fills short rather than repeating ----------

func _fill_short() -> void:
	# THERE IS NO THIN POOL LEFT IN THE GAME (BW's own finding — every spec
	# drafts five and every class six), so the construction has to WEAR ONE
	# DOWN with the no-return ledger. That is the honest way to drive this rule
	# now, and it is the same forced move test_batch_bo had to make at BW.
	var run := _party(["warden", "arcanist", "holy", "mystic"])
	var m: Dictionary = run.party[0]
	var spec_pool: Array = Classes.spec_draft_pool("warden")
	var class_pool: Array = Classes.class_draft_pool("warrior")
	var refused: Array = []
	# Leave exactly TWO cards standing across BOTH pools.
	refused.append_array(spec_pool.slice(0, spec_pool.size() - 1))
	refused.append_array(class_pool.slice(0, class_pool.size() - 1))
	m["draft_refused"] = refused
	var left: Dictionary = run.draft_pool_left(m)
	ok(int(left["spec"].size()) + int(left["class"].size()) == 2,
		"§2: the harness wore the pools down to two cards")
	var short_offers := 0
	var padded := 0
	for _i in 100:
		var offer: Array = run.roll_draft_offer(m)
		if offer.size() < 3:
			short_offers += 1
		if offer.size() != offer.duplicate().size() \
				or (offer.size() == 2 and String(offer[0]) == String(offer[1])):
			padded += 1
	ok(short_offers == 100,
		"§2: a worn pool fills SHORT every time (%d of 100)" % short_offers)
	ok(padded == 0, "§2: ...and NEVER pads with a repeat (%d padded)" % padded)
	# Worn to nothing, `award_draft_pick` REFUSES rather than queueing an empty
	# column — a hero with nothing left simply has no column on the screen.
	m["draft_refused"] = spec_pool.duplicate() + class_pool.duplicate()
	ok(not run.award_draft_pick(m),
		"§2: an exhausted pool queues NO pick at all")
	ok(int(m.get("draft_picks_owed", 0)) == 0,
		"§2: ...so that hero gets no column")


# ---------- §2: the cap, and the drop that must precede the column ----------

func _cap_and_drop() -> void:
	var run := _party(["swordmaster", "pyromancer", "inquisitor", "sharpshooter"])
	var m: Dictionary = run.party[0]
	# Fill him to the cap out of his OWN draft pool, so every earned name is
	# genuinely droppable and none of it is protected.
	var pool: Array = Classes.spec_draft_pool("swordmaster")
	var core: int = Classes.core_slots("swordmaster")
	var need: int = run.ABILITY_SLOT_CAP - core
	m["bm_abilities"] = pool.slice(0, need)
	ok(run.ability_slots_used(m) == run.ABILITY_SLOT_CAP,
		"§2: the harness filled him to the cap (%d of %d)"
			% [run.ability_slots_used(m), run.ABILITY_SLOT_CAP])
	ok(run.ability_slots_full(m), "§2: ...and the run agrees he is full")
	ok(run.award_draft_pick(m), "§2: a full hero is still OFFERED a draft")
	var offer: Array = (m["draft_candidates"] as Array)[0]
	var card := String(offer[0])
	# THE DOOR REFUSES THE TAKE WITHOUT A NAMED REPLACEMENT.
	var why: String = run.take_draft_ability(m, card)
	ok(why != "", "§2: taking at the cap without a drop is REFUSED (%s)" % why)
	ok(int(m.get("draft_picks_owed", 0)) == 1,
		"§2: ...and the pick is still owed")
	ok(not (m["bm_abilities"] as Array).has(card),
		"§2: ...and the card did not land anyway")
	# A PROTECTED ABILITY CAN NEVER BE NAMED. `Run.drop_earned_ability` refuses
	# anything not in `bm_abilities`, which is the mechanical form of the rule
	# rather than a branch that could be got wrong.
	var protected: Array = Classes.PROTECTED_CORES.get("swordmaster",
		{}).get("enablers", [])
	var guard := "Guard Change"
	ok(run.take_draft_ability(m, card, guard) != "" or protected.is_empty(),
		"§2: a protected ability cannot be named as the drop")
	# NAMED, IT RESOLVES — and the dropped one enters the ledger.
	var dropped := String((m["bm_abilities"] as Array)[0])
	ok(run.take_draft_ability(m, card, dropped) == "",
		"§2: named a real earned ability, the take resolves")
	ok((m["bm_abilities"] as Array).has(card), "§2: the card landed")
	ok(not (m["bm_abilities"] as Array).has(dropped), "§2: the named one is gone")
	ok(run.draft_refused(m).has(dropped),
		"§2: a DROP writes the no-return ledger too")
	ok(run.ability_slots_used(m) == run.ABILITY_SLOT_CAP,
		"§2: and the cap still binds at %d" % run.ABILITY_SLOT_CAP)


# ---------- §2: a hero who FELL drafts like anyone else ----------

func _fallen_hero() -> void:
	var bat := _src("res://scripts/battle.gd")
	# THE ORDERING IS THE WHOLE CHECK (§2's own instruction: confirm the revive
	# runs BEFORE the draft screen, so a fallen hero is skipped by a RULE if at
	# all and never by an accident). Both live in the victory branch, and the
	# sync is asserted ABOVE the draft block by source position.
	var sync_at := bat.find("heroes[i].sync_victory_state(Run.party[i])")
	var draft_at := bat.find("for d_taker in Run.party:")
	ok(sync_at > 0 and draft_at > 0, "§2: both sites found in the victory branch")
	ok(sync_at < draft_at,
		"§2: the post-battle revive runs BEFORE the draft is awarded")
	# ...so the health gate in the award loop lets every hero of a WON battle
	# through. A member on 0 HP is refused, which is the rule stated rather than
	# a state a victory can produce.
	var run := _party()
	run.party[2]["hp"] = 0
	var offered := 0
	for m in run.party:
		if int(m.get("hp", 0)) > 0 and run.award_draft_pick(m):
			offered += 1
	ok(offered == 3, "§2: the gate refuses a member at 0 HP (offered %d of 4)" % offered)
	ok(int(run.party[2].get("draft_picks_owed", 0)) == 0,
		"§2: ...and that member has no column")


# ---------- §2: the screen ----------

# THE REVIVE ITSELF, DRIVEN RATHER THAN READ. §2 asks which of two cases held:
# a post-battle revive ALREADY EXISTED, inside `sync_victory_state`, and it
# returns a fallen hero at 20% of maximum rather than at 1 HP. It is driven on
# a REAL spawned unit because the unwind it opens with touches the nameplate —
# a bare `BattleUnit.new()` has none and throws inside `_refresh_chips`, which
# would abort this function while the suite still printed 0 failures (the BC
# trap).
func _live_revive() -> void:
	var scene := await _spawn("beastmaster", ["raider"])
	var hero: BattleUnit = (scene.get("heroes") as Array)[0]
	hero.max_hp = 200
	hero.hp = 0
	hero.dead = true
	var member := {"hp": 0, "max_hp": 200, "resource": 0}
	hero.sync_victory_state(member)
	ok(int(member["hp"]) > 0,
		"§2: a hero who FELL is alive again on victory (%d HP)" % int(member["hp"]))
	ok(int(member["hp"]) == 40,
		"§2: ...at 20%% of maximum — the rule that ALREADY shipped, not 1 HP (got %d)"
			% int(member["hp"]))
	scene.queue_free()
	await process_frame


func _screen_source() -> void:
	var map := _code("res://scripts/map_screen.gd")
	# ONE DRAFT RENDERER, NOT TWO (§1's instruction). BO's single-hero branch is
	# DELETED rather than left unreachable, and the card's CHOOSE button routes
	# to the party screen.
	ok(map.count("func _open_party_draft(") == 1,
		"§2: exactly one party-wide draft screen")
	ok(not map.contains("\"draft\": \"THE DRAFT\""),
		"§2: BO's single-hero draft branch is DELETED from the pick overlay")
	ok(not map.contains("func _pick_draft(") and not map.contains("func _decline_draft("),
		"§2: ...and its two committing helpers went with it")
	ok(map.contains("if kind == \"draft\":\n\t\t_open_party_draft()"),
		"§2: the card's CHOOSE button opens the party screen")
	# ONE DROP STEP, TWO CONSUMERS — the party screen STAGES, the boss pick
	# COMMITS, and the difference is one Callable rather than a second answer to
	# what may be dropped.
	ok(map.count("func _open_drop_overlay(") == 1,
		"§2: still exactly one drop step")
	ok(map.contains("on_drop := Callable()"),
		"§2: ...and the party screen stages through it rather than forking it")
	ok(map.count("Run.drop_earned_ability(") == 1,
		"§2: the map screen still writes a drop through exactly one door")
	# THE RULES STAY IN run_state. The screen must not learn a second answer to
	# the cap, the ledger or the decline.
	ok(map.count("Run.take_draft_ability(") == 1
		and map.count("Run.decline_draft(") == 1,
		"§2: the screen commits through the run's two doors and no others")
	ok(map.contains("_maybe_open_party_draft()"),
		"§2: the screen opens on arriving at the map after an elite")
	# BATCH CT re-pointed this IN PLACE, on BK §6's precedent and for the same
	# reason the save-version pins were re-pointed: **this suite owns the
	# INVARIANT — the draft never opens in a sim, and never with nothing to
	# offer — not the one-line FORMULATION of it.** CT split the combined
	# condition into two guards so that "nothing owed" could chain into the
	# pouch's own owed pick (§3), which the combined form had no room for. The
	# behaviour is unchanged: a sim still returns before anything opens.
	#
	# SCOPED TO THE FUNCTION BODY, which makes it STRICTLY STRONGER than the
	# global `contains` it replaces — that one would have passed on either guard
	# appearing anywhere else in a 2,000-line file.
	var mopd_at := map.find("func _maybe_open_party_draft(")
	var mopd_end := map.find("\nfunc ", mopd_at + 1)
	var mopd := map.substr(mopd_at, mopd_end - mopd_at) if mopd_at >= 0 else ""
	ok(mopd.contains("if Run.sim_run:"),
		"§2: ...never in a sim")
	ok(mopd.contains("_draft_columns().is_empty()"),
		"§2: ...and never with nothing to offer")
	ok(mopd.contains("_open_party_draft()"),
		"§2: ...and it is still the party screen it opens when there IS something")


func _live_one_action() -> void:
	# THE DISCRIMINATING ASSERTION IS TAKEN BEFORE THE CONFIRM. A screen that
	# committed each column as it was clicked passes every "the card landed"
	# check below and fails this one: with all four columns decided, NOTHING on
	# any member may have moved yet.
	var run := _party(["berserker", "cryomancer", "occultist", "mystic"])
	for m in run.party:
		run.award_draft_pick(m)
	Profile.set_flag("run_framing_seen")
	var map: Node = (load("res://scenes/map.tscn") as PackedScene).instantiate()
	root.add_child(map)
	await process_frame
	ok((map.get("_draft_columns") != null) or true, "")   # keep the count honest
	checks -= 1
	var cols: Array = map.call("_draft_columns")
	ok(cols.size() == 4, "§2: the screen builds FOUR columns (got %d)" % cols.size())
	map.call("_open_party_draft")
	await process_frame

	var staged := {}
	for idx in cols:
		var i := int(idx)
		ok(not map.call("_draft_decided", i),
			"§2: column %d opens UNDECIDED" % i)
		var offer: Array = (run.party[i]["draft_candidates"] as Array)[0]
		staged[i] = String(offer[0])
		map.call("_stage_draft", i, String(offer[0]))
		ok(map.call("_draft_decided", i),
			"§2: ...and is decided once a card is chosen")
	# NOTHING IS COMMITTED YET.
	var moved := 0
	for i in run.party.size():
		if not (run.party[i]["bm_abilities"] as Array).is_empty():
			moved += 1
		if int(run.party[i].get("draft_picks_owed", 0)) != 1:
			moved += 1
		if not run.draft_refused(run.party[i]).is_empty():
			moved += 1
	ok(moved == 0,
		"§2: with all four chosen, NOTHING has been committed yet (%d moved)" % moved)
	# Clicking a staged card again takes the column back to undecided, so a
	# misclick never has to be paid for with a decline.
	map.call("_stage_draft", 0, staged[0])
	ok(not map.call("_draft_decided", 0),
		"§2: clicking the staged card again UNSTAGES it")
	map.call("_stage_draft", 0, staged[0])
	# ONE DECLINE AMONG FOUR TAKES: independent, per hero.
	map.call("_stage_draft_decline", 2)
	ok(map.call("_draft_decided", 2), "§2: a declined column is decided")

	map.call("_confirm_party_draft")
	await process_frame
	for i in run.party.size():
		ok(int(run.party[i].get("draft_picks_owed", 0)) == 0,
			"§2: hero %d's pick is spent by the ONE confirmation" % i)
	for i in [0, 1, 3]:
		ok((run.party[i]["bm_abilities"] as Array).has(staged[i]),
			"§2: hero %d took %s" % [i, staged[i]])
		ok(run.draft_refused(run.party[i]).is_empty(),
			"§2: ...and refused nothing by taking it")
	ok((run.party[2]["bm_abilities"] as Array).is_empty(),
		"§2: the declining hero learned nothing")
	ok(run.draft_refused(run.party[2]).size() == 3,
		"§2: ...and refused their whole offer (%d cards)"
			% run.draft_refused(run.party[2]).size())
	ok(run.draft_refused(run.party[0]).is_empty(),
		"§2: one hero's decline still did not reach another's ledger")
	map.free()
	await process_frame

	# THE CAP, DRIVEN THROUGH THE SCREEN RATHER THAN THROUGH THE DOOR. The door
	# is checked in `_cap_and_drop`; what this adds is that the COLUMN refuses
	# to count as decided until a replacement is named, and that the staged
	# replacement survives the confirm. The two are different failures: a screen
	# that let a capped column resolve would call `take_draft_ability` with no
	# drop, get a refusal string back, and silently spend the pick.
	var run2 := _party(["swordmaster", "arcanist", "holy", "sharpshooter"])
	var capped: Dictionary = run2.party[0]
	var pool: Array = Classes.spec_draft_pool("swordmaster")
	capped["bm_abilities"] = pool.slice(0,
		run2.ABILITY_SLOT_CAP - Classes.core_slots("swordmaster"))
	ok(run2.ability_slots_full(capped), "§2: hero 0 is seated at the cap")
	for m in run2.party:
		run2.award_draft_pick(m)
	var map2: Node = (load("res://scenes/map.tscn") as PackedScene).instantiate()
	root.add_child(map2)
	await process_frame
	map2.call("_open_party_draft")
	await process_frame
	var incoming := String((capped["draft_candidates"] as Array)[0][0])
	map2.call("_stage_draft", 0, incoming)
	ok(not map2.call("_draft_decided", 0),
		"§2: a capped column is NOT decided by choosing a card alone")
	var drop := String((capped["bm_abilities"] as Array)[0])
	map2.call("_stage_draft_drop", 0, drop)
	ok(map2.call("_draft_decided", 0),
		"§2: ...and IS the moment the replacement is named")
	for i in [1, 2, 3]:
		map2.call("_stage_draft_decline", i)
	map2.call("_confirm_party_draft")
	await process_frame
	ok((capped["bm_abilities"] as Array).has(incoming),
		"§2: the capped hero's card landed on confirm")
	ok(not (capped["bm_abilities"] as Array).has(drop),
		"§2: ...and the named replacement is gone")
	ok(run2.ability_slots_used(capped) == run2.ABILITY_SLOT_CAP,
		"§2: ...leaving the kit exactly at the cap (%d)"
			% run2.ability_slots_used(capped))
	ok(int(capped.get("draft_picks_owed", 0)) == 0,
		"§2: ...and the pick is spent, not left owed")
	map2.free()
	await process_frame


# ---------- §3: Twin Hunt and Savage Sweep share one rule ----------

# THE VICTORY BRANCH ITSELF, EXECUTED. Everything above asserts battle.gd's
# award loop at the SOURCE, and a sim cannot reach it — `_check_end` branches
# to RunSim in sim mode, so the run-mode victory block that actually hands out
# the four picks has never run in any measurement this project takes. It is
# driven here: a real elite encounter, the field emptied, `_check_end` called.
func _live_elite_victory() -> void:
	var scene := await _spawn("beastmaster", ["raider", "raider"])
	var run := root.get_node("/root/Run")
	run.encounter = {"type": "elite", "theme": "Warband",
		"enemies": ["raider", "raider"]}
	for m in run.party:
		m["bm_abilities"] = []
		m["draft_refused"] = []
		m["draft_candidates"] = []
		m["draft_picks_owed"] = 0
	# ONE HERO FALLS, and that is the case §2 asks about: they must be back up
	# and holding a column, by the revive that already runs above the award.
	var faller: BattleUnit = (scene.get("heroes") as Array)[1]
	faller.hp = 0
	faller.dead = true
	run.party[1]["hp"] = 0
	for e in scene.get("enemies"):
		e.hp = 0
		e.dead = true
	await scene.call("_check_end")
	await process_frame
	ok(run.owed_draft_picks() == 4,
		"§2: a REAL elite victory owes FOUR draft picks (got %d)"
			% run.owed_draft_picks())
	var withcards := 0
	for m in run.party:
		if int(m.get("draft_picks_owed", 0)) == 1 \
				and not (m.get("draft_candidates", []) as Array).is_empty():
			withcards += 1
	ok(withcards == 4, "§2: ...and every hero has cards waiting (got %d)" % withcards)
	ok(int(run.party[1].get("hp", 0)) > 0,
		"§2: the hero who FELL is up again (%d HP)" % int(run.party[1].get("hp", 0)))
	ok(int(run.party[1].get("draft_picks_owed", 0)) == 1,
		"§2: ...and holds a column like anyone else")
	# The offers are still each hero's OWN, coming out of the live branch.
	var strays := 0
	for m in run.party:
		var spec := String(m["spec"])
		var mine: Array = Classes.spec_draft_pool(spec).duplicate()
		mine.append_array(Classes.class_draft_pool(Classes.class_of_spec(spec)))
		var queue: Array = m.get("draft_candidates", [])
		if queue.is_empty():
			strays += 1        # no column at all is itself a stray result here
			continue
		for card in queue[0]:
			if not mine.has(String(card)):
				strays += 1
	ok(strays == 0, "§2: ...drawn from their own pools (%d strays)" % strays)
	scene.queue_free()
	await process_frame


func _deepest_bond_source() -> void:
	var bat := _code("res://scripts/battle.gd")
	ok(bat.count("func _deepest_bond(") == 1,
		"§3: exactly one answer to which companion an ordered action goes to")
	# RE-POINTED BY BATCH CH: a THIRD caller arrived. UNLEASH spends ONE
	# companion's Loyalty, so it asks the same question Twin Hunt and Savage
	# Sweep ask — which companion does an ORDERED action go to — and it asks it
	# through the same function rather than reaching for `beasts[0]`, which is
	# the drift BX existed to close. The COUNT is what moved; the question did
	# not, and a card added later that reads list order still trips the pins
	# below.
	ok(bat.count("_deepest_bond(attacker)") == 3,
		"§3: ...and ALL THREE cards call it — Twin Hunt, Savage Sweep, Unleash (got %d)"
			% bat.count("_deepest_bond(attacker)"))
	# THE TWO THINGS IT REPLACED ARE GONE, not left beside it. A list-order read
	# surviving anywhere on this path is the exact drift BV reported and BW
	# carried.
	ok(not bat.contains("var th_b: BattleUnit = th_beasts[0]"),
		"§3: Twin Hunt's list-order pick is DELETED")
	ok(not bat.contains("var ss_b: BattleUnit = ss_beasts[0]"),
		"§3: Savage Sweep's inline loop is gone with it")
	ok(not bat.contains("th_beasts") and not bat.contains("ss_beasts"),
		"§3: neither local survives")


func _spawn(hunter_spec: String, lineup: Array) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "arcanist", "holy", hunter_spec]
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
	# `_run_battle` opens with `await _wait(0.6)` on a REAL SceneTreeTimer;
	# `Engine.time_scale` scales those and nothing the battle computes.
	Engine.time_scale = 50.0
	for _i in 90:
		await process_frame
	Engine.time_scale = 1.0
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0
	return scene


func _hunter(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "pack":
			return h
	return null


func _live_deepest_bond() -> void:
	var scene := await _spawn("beastmaster", ["raider", "raider"])
	var bm := _hunter(scene)
	ok(bm != null, "§3: the Beastmaster spawned")
	if bm == null:
		scene.queue_free()
		return
	ok(scene.call("_deepest_bond", bm) == null,
		"§3: with no companion standing it answers null")
	bm.the_pack = 1
	await scene.call("_do_summon", bm, "ursus")
	await scene.call("_do_summon", bm, "canis")
	var pack: Array = scene.call("_beasts", bm)
	ok(pack.size() == 2, "§3: The Pack fields two (got %d)" % pack.size())
	if pack.size() < 2:
		scene.queue_free()
		return
	# The SECOND summon holds the deeper bond, so list order and Loyalty
	# DISAGREE — which is the only arrangement that can tell them apart.
	bm.loyalty["ursus"] = 1
	bm.loyalty["canis"] = 40
	ok(scene.call("_deepest_bond", bm) == pack[1],
		"§3: it answers the DEEPER bond, not the earlier summon")
	bm.loyalty["ursus"] = 40
	bm.loyalty["canis"] = 1
	ok(scene.call("_deepest_bond", bm) == pack[0],
		"§3: ...and flips when the depths do")
	# TIES BREAK ON LIST ORDER, so the answer is deterministic rather than
	# merely usually-right — which is what lets every check above be an
	# identity rather than a probability.
	bm.loyalty["ursus"] = 7
	bm.loyalty["canis"] = 7
	ok(scene.call("_deepest_bond", bm) == pack[0],
		"§3: a tie falls to list order")
	scene.queue_free()
	await process_frame


func _live_twin_hunt() -> void:
	# IDENTITY, NOT MAGNITUDE. `companion_power` is a flat term inside
	# `_companion_hit`, so seating one companion at 0 and the other at 400 makes
	# the blow say WHICH ONE struck with open ground either side — the ±10%
	# variance cannot reach across it, so this needs no seeding and no ratio.
	for deep_is_second in [true, false]:
		var scene := await _spawn("beastmaster", ["raider"])
		var bm := _hunter(scene)
		if bm == null:
			scene.queue_free()
			return
		bm.the_pack = 1
		await scene.call("_do_summon", bm, "ursus")
		await scene.call("_do_summon", bm, "canis")
		var pack: Array = scene.call("_beasts", bm)
		if pack.size() < 2:
			scene.queue_free()
			return
		var deep: BattleUnit = pack[1] if deep_is_second else pack[0]
		var shallow: BattleUnit = pack[0] if deep_is_second else pack[1]
		bm.loyalty[deep.companion_kind] = 30
		bm.loyalty[shallow.companion_kind] = 1
		# The SHALLOW one is the loud one. A list-order pick therefore reads
		# LOUD when the deep bond is the second summon and QUIET when it is the
		# first — so the pair of runs below discriminates in both directions and
		# a version that always picks `pack[1]` fails one of them.
		deep.companion_power = 0.0
		shallow.companion_power = 400.0
		var foe: BattleUnit = (scene.get("enemies") as Array)[0]
		foe.hp = 100000
		foe.max_hp = 100000
		foe.armor = 0.0
		foe.resists = {}
		var before := foe.hp
		await scene.call("_resolve", bm, Classes.draft_ability("Twin Hunt"),
			foe, "good")
		var dealt: int = before - foe.hp
		# The hunter's own blow is 40% of ~100 Attack, so a QUIET companion
		# leaves the total well under 200 and a LOUD one well over 400.
		ok(dealt < 200,
			"§3: Twin Hunt struck with the DEEPEST bond (deep=%s, dealt %d)"
				% ["second" if deep_is_second else "first", dealt])
		scene.queue_free()
		await process_frame


# ---------- §4: the word ----------

func _rename() -> void:
	# NO PLAYER-FACING STRING READS "beast" OUTSIDE BESTIAL WRATH. The sweep
	# walks STRING LITERALS ONLY — comments sit with the code, and the code
	# identifiers are deliberately untouched this batch (a missed prose rename
	# is a typo; a missed code rename is a bug).
	var files := ["res://scripts/battle.gd", "res://scripts/classes.gd",
		"res://scripts/talents.gd", "res://scripts/unit.gd",
		"res://scripts/run_state.gd", "res://scripts/map_screen.gd",
		"res://scripts/run_sim.gd", "res://scripts/party_screen.gd"]
	var strays: Array = []
	for f in files:
		for ln in _src(f).split("\n"):
			if ln.strip_edges().begins_with("#"):
				continue
			# ONLY THE ODD SEGMENTS ARE INSIDE A STRING LITERAL. Reading every
			# segment sweeps the CODE as well, which is how a check written to
			# ask about prose starts reporting `_beasts(u)` — a check that has
			# stopped asking its question, in the direction that fails LOUD
			# rather than open, but a false alarm all the same.
			var parts := ln.split("\"")
			for pi in parts.size():
				if pi % 2 == 0:
					continue
				var part := String(parts[pi])
				var low := part.to_lower()
				if not low.contains("beast"):
					continue
				# The spec name stays, and so do the identifiers — neither is
				# the common noun this section is about.
				var probe := low.replace("beastmaster", "")
				probe = probe.replace("no_beast_left_loyalty", "")
				probe = probe.replace("bm_no_beast_left", "")
				probe = probe.replace("bm_beast_within", "")
				probe = probe.replace("no_beast_left", "")
				if probe.contains("beast"):
					strays.append("%s: %s" % [f.get_file(), part.substr(0, 60)])
	ok(strays.is_empty(), "§4: no player-facing string still reads 'beast' (%d: %s)"
		% [strays.size(), ", ".join(strays.slice(0, 3))])
	# The data files and the design doc, same rule.
	for path in ["res://data/glossary.json", "res://data/runes.json"]:
		var body := _src(path).to_lower().replace("beastmaster", "")
		ok(not body.contains("beast"), "§4: %s reads companion" % path.get_file())
	# BOTH CASINGS of the spec name are stripped: the flags table quotes
	# `DOD_SIM_SPECS="...,beastmaster"`, which is an identifier in a doc rather
	# than the common noun this section is about.
	var master := _src("res://docs/master.html").replace("Beastmaster", "")
	master = master.replace("beastmaster", "")
	ok(not master.to_lower().contains("beast"),
		"§4: master.html reads companion everywhere it is prose")
	# BESTIAL WRATH KEEPS ITS NAME — it reads as a proper name rather than as
	# the common noun, and it is the one thing §4 says to leave.
	ok(Classes.pool_ability("Bestial Wrath") != null,
		"§4: Bestial Wrath is still an ability of that name")
	ok(_src("res://docs/master.html").contains("Bestial Wrath"),
		"§4: ...and master.html still calls it that")

	# THE NEGATIVE CONTROL THAT MATTERS (§6): THE TWO RENAMED NODES KEEP THEIR
	# IDS. A rename that moved an id breaks every saved build, silently — the
	# node simply stops being owned. Rows, lanes and payload FIELDS are asserted
	# unmoved beside the new names.
	var want := {
		"bm_beast_within": ["The Wild Within", "handler", 2, "companion_hp_pct"],
		"bm_no_beast_left": ["None Left Behind", "pack", 6, "no_beast_left"],
	}
	var tree: Array = Talents.generate_tree("beastmaster", "hunter")
	for id in want:
		var node: Dictionary = {}
		for n in tree:
			if String(n.get("id", "")) == id:
				node = n
		ok(not node.is_empty(), "§4: %s still exists by id" % id)
		if node.is_empty():
			continue
		var spec: Array = want[id]
		ok(String(node.get("name", "")) == String(spec[0]),
			"§4: %s is named %s (got %s)" % [id, spec[0], node.get("name", "")])
		ok(String(node.get("lane", "")) == String(spec[1])
			and int(node.get("row", 0)) == int(spec[2]),
			"§4: %s did not move row or lane" % id)
		var payload: Dictionary = node.get("payload", {}).get("stat", {})
		ok(payload.has(String(spec[3])),
			"§4: %s's payload field %s is untouched" % [id, spec[3]])
	# The two OLD names are gone from the live trees, so a saved BUILD screen
	# cannot show one and the doc cannot disagree with the tree.
	var names: Array = []
	for spec_id in Classes.all_specs():
		for n in Talents.generate_tree(String(spec_id), ""):
			names.append(String(n.get("name", "")))
	ok(not names.has("Beast Within") and not names.has("No Beast Left"),
		"§4: neither old node name survives anywhere in the twelve trees")
	# AND THE TWO NEW ONES ARE CLEAN AGAINST THE WHOLE ROSTER (BR §1's sweep).
	for new_name in ["The Wild Within", "None Left Behind"]:
		ok(names.count(new_name) == 1,
			"§4: %s names exactly one talent node (got %d)"
				% [new_name, names.count(new_name)])
		ok(Classes.pool_ability(new_name) == null,
			"§4: ...and no ABILITY answers to it")
	var rune_names: Array = []
	for rid in Runes.ids():
		rune_names.append(String(Runes.config(String(rid)).get("name", "")))
	ok(not rune_names.has("The Wild Within")
		and not rune_names.has("None Left Behind"),
		"§4: ...and no rune does either")
	ok(rune_names.size() > 40,
		"§4: ...checked against the whole rune pool (%d)" % rune_names.size())


# ---------- §5: the documentation ----------

func _docs() -> void:
	var master := _src("res://docs/master.html")
	# RE-POINTED BY BATCH CK. THIS CHECK WAS ALREADY RED WHEN CK ARRIVED AND CK
	# DID NOT BREAK IT: it asserted a HARDCODED batch stamp, which has to be
	# hand-bumped every batch to keep passing. **FIVE SUITES CARRIED THE SAME
	# CHECK (bq, br, bt, bx, ce) AND BATCH CJ'S RE-STAMP TURNED ALL FIVE RED AT
	# ONCE** — the CD §1 fault in its other direction: not a check that can only
	# pass, but one that can only pass for one batch. It asks the durable version
	# of its own question now: the document carries a stamp, and that stamp is no
	# older than the batch this suite belongs to. No bump is ever owed again.
	# (Two-letter batch codes sort lexically; a three-letter code needs one line.)
	var _stamp_at := master.find("Last updated:")
	ok(_stamp_at >= 0, "§5: master.html carries a Last-updated stamp")
	var _stamp := master.substr(_stamp_at, 60)
	var _code_at := _stamp.find("(Batch ")
	var _stamped := _stamp.substr(_code_at + 7, 2) if _code_at >= 0 else ""
	ok(_stamped >= "BX",
		"§5: ...stamped no older than this suite's own batch (reads '%s')" % _stamped)
	var low := master.to_lower()
	ok(low.contains("every living hero") or low.contains("all four heroes"),
		"§5: master.html says an elite offers a draft to every living hero")
	ok(low.contains("one screen") or low.contains("four columns"),
		"§5: ...on one screen")
	# ANCHORED ON THE `id` FIELD, NOT THE BARE NAME. `"ability_draft"` appears
	# SIX times in this file and the first FIVE are `see_also` cross-links from
	# other entries — a slice taken from the bare string reads a neighbouring
	# entry and the check quietly stops asking its question (BE's changelog
	# anchor, through a JSON door).
	var gloss := _src("res://data/glossary.json")
	var at := gloss.find("\"id\": \"ability_draft\"")
	ok(at > 0, "§5: the draft glossary entry exists")
	var draft_entry := gloss.substr(at, 3000).to_lower()
	ok(draft_entry.contains("every living hero") or draft_entry.contains("all four"),
		"§5: ...and it states the party-wide offer")
	ok(draft_entry.contains("one screen"), "§5: ...and that it is one screen")
	ok(draft_entry.contains("per hero"),
		"§5: ...and that the no-return ledger is per hero")
	var claude := _src("res://CLAUDE.md")
	ok(claude.contains("BATCH BX"), "§5: CLAUDE.md carries the batch block")
	ok(claude.contains("draft_refused"),
		"§5: ...and names the per-member ledger as load-bearing")
	var chlog := _src("res://docs/changelog.html")
	ok(chlog.contains("Batch BX"), "§5: the changelog carries an entry")
