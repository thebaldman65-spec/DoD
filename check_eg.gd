# BATCH EG — THE DRAFT STAYS LIVE ALL RUN.
#
#   §0  the premises §1 and §2 stand on, re-derived rather than inherited
#   §1  the slot ladder, DRIVEN LIVE through three real zone bosses
#   §2  the pool and the loadout are two sets, and a bench is not a drop
#   §3  the save is v12 and TOLERANT, driven through a real round trip
#
# **WHY §1 DRIVES A BATTLE INSTEAD OF READING THE LADDER.** DS's Heads Down
# measured correct in the code and nearly shipped inert, and a slot ladder that
# never grants its third rung would pass every static check in the project: the
# constant is right, the accessor is right, the announcement string is right,
# and nothing calls the grant. **§1 resolves three REAL zone bosses through
# `battle._resolve_boss` and reads the cap off the run after each**, in the same
# shape `check_ea` §2 reads its announcement off the end card's own Label rather
# than asserting that `battle.gd` contains a line.
#
# AND THE THIRD BOSS IS THE ONE THAT MATTERS. `zone_idx` cannot express it — BM
# §6 put the end boss on the third zone's own board, so `has_next_zone()` is
# already false when the third ZONE boss dies. A ladder indexed on the zone
# would stop at nine, and **the SIM cannot see this at all**: `run_sim` gates
# its award on `has_next_zone()` and ends the run at that boss, so the bot never
# plays a third grant. This gate is the only thing in the project that does.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_eg.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const REAL_SAVE := "user://run_save.bin"
const SCRATCH_PROFILE := "user://profile_check_eg.json"
const SCRATCH_SAVE := "user://run_save_check_eg.bin"

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

	print("BATCH EG — THE DRAFT STAYS LIVE ALL RUN")
	_s0_premises()
	_s2_pool_and_loadout()
	_s3_save_round_trip()
	await _s1_ladder_live()

	if _had_save:
		var f := FileAccess.open(REAL_SAVE, FileAccess.WRITE)
		f.store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))
	_g.report(self)


# ── §0 — THE PREMISES ───────────────────────────────────────────────────────
# Each of these is a thing §1 or §2 would otherwise ASSUME. They are asserted
# off the source and off the live run node rather than off this file's memory.
func _s0_premises() -> void:
	print("\n§0 — the premises, re-derived")
	var run: Node = root.get_node("/root/Run")
	var run_gd := load("res://scripts/run_state.gd")

	# (1) THE LADDER ITSELF, AND ITS SHAPE RATHER THAN ONLY ITS VALUES. A ladder
	# one rung short of the award count would grant twice and read fine.
	var ladder: Array = run_gd.ABILITY_SLOTS_BY_BOSS
	ok(ladder == [7, 8, 9, 10],
		"§0: the ladder is %s, not [7, 8, 9, 10]" % [ladder])
	ok(ladder.size() == int(run_gd.SLOT_COUNT) + 1,
		"§0: the ladder holds %d rungs against %d zone bosses — one rung per boss plus the opening one" % [
			ladder.size(), int(run_gd.SLOT_COUNT)])
	var rising := true
	for i in range(1, ladder.size()):
		if int(ladder[i]) != int(ladder[i - 1]) + 1:
			rising = false
	ok(rising, "§0: the ladder rises by exactly one a boss")

	# (2) THE COUNTER IS RESET WITH THE RUN. CT's scar: a second run in one
	# session sized its opening pouch off the previous run's zone. The ladder is
	# the same trap and the reset is asserted rather than read.
	run.new_run(["warrior", "mage", "cleric", "hunter"])
	ok(int(run.zone_bosses_cleared) == 0,
		"§0: a fresh run opens at zero zone bosses cleared (got %d)" % int(run.zone_bosses_cleared))
	ok(int(run.ability_slot_cap()) == int(ladder[0]),
		"§0: ...so the cap opens on the ladder's first rung")
	run.zone_bosses_cleared = 3
	ok(int(run.ability_slot_cap()) == int(ladder[ladder.size() - 1]),
		"§0: three bosses cleared reads the last rung")
	run.zone_bosses_cleared = 99
	ok(int(run.ability_slot_cap()) == int(ladder[ladder.size() - 1]),
		"§0: ...and a count past the ladder CLAMPS rather than reading off the end")
	run.new_run(["warrior", "mage", "cleric", "hunter"])
	ok(int(run.zone_bosses_cleared) == 0,
		"§0: a SECOND run in the same session resets it (the CT pouch scar)")

	# (3) NO CONSTANT CAP SURVIVES ANYWHERE. A single missed re-point is a
	# surface that keeps saying seven while the run says ten, and the player
	# reads the surface.
	var files := ["scripts/run_state.gd", "scripts/map_screen.gd",
		"scripts/party_screen.gd", "scripts/shop_screen.gd", "scripts/battle.gd",
		"scripts/run_sim.gd"]
	var stale: Array = []
	for f in files:
		var body := _strip_comments(FileAccess.get_file_as_string("res://" + f))
		if body.contains("ABILITY_SLOT_CAP"):
			stale.append(f)
	ok(stale.is_empty(),
		"§0: %s still reads a constant cap — the ladder is `ability_slot_cap()`" % [stale])

	# (4) THE GRANT IS CALLED, AND FROM THE ZONE-BOSS BRANCH ONLY. §1 drives it;
	# this is the cheap half that says WHERE, so a grant moved into the end
	# boss's branch is a red here rather than a silent fourth slot.
	var bs := _strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bs.count("Run.note_zone_boss_cleared()") == 1,
		"§0: `battle.gd` grants the slot in exactly one place")
	var head := bs.find("func _resolve_boss")
	var grant := bs.find("Run.note_zone_boss_cleared()")
	var award := bs.find("_award_ability_picks()")
	ok(head >= 0 and grant > head and award > grant,
		"§0: the grant sits inside `_resolve_boss` and BEFORE the award — a hero at cap must be able to receive both")


# ── §1 — THE LADDER, DRIVEN LIVE ────────────────────────────────────────────
# THREE REAL ZONE BOSSES, and the cap read off the run after each. The party is
# filled to the OPENING cap first, so every stage is measured on a hero for whom
# the cap actually binds — a ladder driven on an empty kit moves a number nobody
# is standing against.
func _s1_ladder_live() -> void:
	print("\n§1 — the slot ladder, driven on three real zone bosses")
	var run: Node = root.get_node("/root/Run")
	var scene: Node = await Gate.spawn(self,
		["berserker", "pyromancer", "inquisitor", "beastmaster"])
	ok(Gate.flags_are_inert(scene), "§1: the fixture's headless premise still holds")
	run.zone_bosses_cleared = 0

	for m in run.party:
		var spec := String(m["spec"])
		var want: int = run.ability_slot_cap() - Classes.core_slots(spec)
		m["bm_abilities"] = []
		m.erase("bm_equipped")
		for n in Classes.spec_draft_pool(spec).slice(0, want):
			run.hold_ability(m, String(n), true)
	for m2 in run.party:
		ok(run.ability_slots_full(m2),
			"§1: %s opens seated at the cap" % String(m2["spec"]))

	var caps: Array = [run.ability_slot_cap()]
	var seats: Array = [run.ability_slots_used(run.party[0])]
	for boss in 3:
		# THE REAL FUNCTION, not a counter bump. `_resolve_boss(gold, is_end)`
		# is what a zone boss calls, and everything it does — the talent bank,
		# the pouch line, the relic, the award — runs here as it does in play.
		scene.call("_resolve_boss", 120, false)
		await process_frame
		caps.append(run.ability_slot_cap())
		seats.append(run.ability_slots_used(run.party[0]))
		# EACH BOSS GRANTS EXACTLY ONE, AND THE HERO IS NO LONGER FULL.
		ok(int(caps[boss + 1]) == int(caps[boss]) + 1,
			"§1: zone boss %d grants exactly one slot (%d -> %d)" % [
				boss + 1, int(caps[boss]), int(caps[boss + 1])])
		ok(not run.ability_slots_full(run.party[0]),
			"§1: ...and the hero seated at the old cap has room again")
		# AND THE AWARD LANDS INTO IT. `_award_ability_picks` runs inside
		# `_resolve_boss`, AFTER the grant, so a hero at cap receives both.
		ok(int(run.party[0].get("bm_picks_owed", 0)) >= 1
				or run.roll_spec_ability_offer(run.party[0]).is_empty(),
			"§1: ...and the award it pays is owed on the hero, not skipped")
		# Re-seat him at the NEW cap for the next stage, so every rung is
		# measured against a hero the cap binds.
		var sp := String(run.party[0]["spec"])
		for n2 in Classes.spec_draft_pool(sp):
			if run.ability_slots_full(run.party[0]):
				break
			if not run.earned_ability_names(run.party[0]).has(String(n2)):
				run.hold_ability(run.party[0], String(n2), true)
		if run.has_next_zone():
			run.advance_zone()

	ok(caps == [7, 8, 9, 10],
		"§1: THE CAP AT EACH STAGE READS %s, not [7, 8, 9, 10]" % [caps])
	ok(int(run.zone_bosses_cleared) == 3,
		"§1: three zone bosses are recorded (got %d)" % int(run.zone_bosses_cleared))
	print("  cap by stage: %s   hero 0 slots used: %s   zone_idx ended at %d" % [
		caps, seats, int(run.zone_idx)])

	# THE END BOSS GRANTS NOTHING. Nothing follows it, and a fourth rung would
	# be a slot no draft offer could ever fill.
	var before_end: int = run.ability_slot_cap()
	scene.call("_resolve_boss", 120, true)
	await process_frame
	ok(int(run.ability_slot_cap()) == before_end,
		"§1: the END boss grants no slot (%d -> %d)" % [before_end, int(run.ability_slot_cap())])
	ok(int(run.zone_bosses_cleared) == 3,
		"§1: ...and does not count as a zone boss")
	scene.free()
	await process_frame


# ── §2 — THE POOL AND THE LOADOUT ───────────────────────────────────────────
# **THE PROPERTY, NOT THE FIELDS.** A gate asserting `bm_equipped` exists would
# pass on a split that lost a card; what is asserted here is that a benched card
# is KEPT, is never re-offered, is never ledgered, and can be carried again.
func _s2_pool_and_loadout() -> void:
	print("\n§2 — the pool and the loadout are two sets")
	var run: Node = root.get_node("/root/Run")
	var m := {"key": "warrior", "spec": "swordmaster", "bm_abilities": [],
		"talents": {}, "tree": []}

	# A MEMBER THAT HAS NEVER BENCHED CARRIES EVERYTHING IT HOLDS. This is the
	# default every pre-EG member dict and every v11 save depends on.
	m["bm_abilities"] = ["Sweeping Strikes", "Shatterpoint"]
	ok(run.equipped_ability_names(m) == ["Sweeping Strikes", "Shatterpoint"],
		"§2: a member with no `bm_equipped` carries its whole pool")
	ok(run.benched_ability_names(m).is_empty(),
		"§2: ...and has nothing benched")
	ok(int(run.ability_slots_used(m)) == Classes.core_slots("swordmaster") + 2,
		"§2: ...and the cap counts the core plus the loadout")

	# A BENCH KEEPS THE CARD, WRITES NO LEDGER, AND IS REVERSIBLE.
	ok(run.unequip_earned_ability(m, "Shatterpoint"), "§2: an earned card benches")
	ok(run.earned_ability_names(m).has("Shatterpoint"),
		"§2: ...and is KEPT in the pool")
	ok(not run.equipped_ability_names(m).has("Shatterpoint"),
		"§2: ...and out of the loadout")
	ok(run.benched_ability_names(m) == ["Shatterpoint"],
		"§2: ...and the bench names it")
	ok(run.draft_refused(m).is_empty(),
		"§2: a BENCH does not write the no-return ledger")
	ok(int(run.ability_slots_used(m)) == Classes.core_slots("swordmaster") + 1,
		"§2: ...and it frees its slot")
	ok(run.equip_earned_ability(m, "Shatterpoint"), "§2: and it carries again")
	ok(run.equipped_ability_names(m).has("Shatterpoint"), "§2: ...for nothing")
	ok(run.unequip_earned_ability(m, "Shatterpoint"), "§2: benched again")

	# **A BENCHED CARD IS STILL OWNED, AND THAT IS WHAT KEEPS IT OFF THE OFFER.**
	# This is the reader question the split could have got backwards: it is
	# blocked by OWNERSHIP, not by the ledger, so the guarantee is reached
	# through the set that is true of it.
	ok(run.owned_ability_names(m).has("Shatterpoint"),
		"§2: a benched card is still OWNED")
	ok(not run.draft_pool_left(m)["spec"].has("Shatterpoint"),
		"§2: ...so the draft cannot re-present it")
	ok(not run.roll_spec_fallback_offer(m).has("Shatterpoint"),
		"§2: ...and neither can the zone-boss fallback")

	# A PROTECTED NAME CAN NEVER BE BENCHED, AND THE MECHANISM IS ITS ABSENCE
	# FROM THE POOL rather than a branch.
	ok(not run.unequip_earned_ability(m, "Guard Change"),
		"§2: a protected ability can never be benched")
	ok(not run.equip_earned_ability(m, "Guard Change"),
		"§2: ...nor carried through this door, which would double it")

	# **THE LEDGER STILL BITES, AND `decline_draft` IS ITS ONLY WRITER.**
	var m2 := {"key": "warrior", "spec": "berserker", "bm_abilities": [],
		"talents": {}, "tree": []}
	ok(run.award_draft_pick(m2), "§2: an offer is queued")
	var offered: Array = (m2["draft_candidates"][0] as Array).duplicate()
	ok(run.decline_draft(m2), "§2: ...and declined")
	for d in offered:
		ok(run.draft_refused(m2).has(String(d)),
			"§2: a DECLINED card is refused for the run (%s)" % d)
	var rs := _strip_comments(FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(rs.count("_refuse_draft(") == 2,
		"§2: `_refuse_draft` has exactly one caller besides its own definition")
	var decl := rs.find("func decline_draft")
	var refuse := rs.find("_refuse_draft(member, String(card))")
	ok(decl >= 0 and refuse > decl,
		"§2: ...and that caller is `decline_draft`")

	# THE POOL HAS ONE WRITER AND THE TWO CHANNELS SHARE IT.
	ok(rs.count("member[\"bm_abilities\"] = ") == 1,
		"§2: the pool is written in exactly one place")


# ── §3 — THE SAVE ───────────────────────────────────────────────────────────
# **DRIVEN THROUGH A REAL ROUND TRIP, NOT READ OFF THE VERSION LITERAL.** The
# claim EG makes is that the two new pieces of state survive a save and that a
# v11 save still loads; a gate that asserted `"version": 12` would pass on a
# build that wrote the number and dropped the field.
func _s3_save_round_trip() -> void:
	print("\n§3 — the save is v12 and TOLERANT")
	var run: Node = root.get_node("/root/Run")
	var real := String(run.SAVE_PATH)
	var sim_was: bool = run.sim_run
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"])
	for i in run.party.size():
		run.party[i]["spec"] = ["swordmaster", "pyromancer", "holy",
			"sharpshooter"][i]
	run.zone_bosses_cleared = 2
	var hero: Dictionary = run.party[0]
	run.hold_ability(hero, "Sweeping Strikes", true)
	run.hold_ability(hero, "Shatterpoint", true)
	ok(run.unequip_earned_ability(hero, "Shatterpoint"), "§3: one card benched")
	run.save_run()

	# **`>= 12`, NOT `== 12`, ON CT'S OWN STANDING RULE — A SUITE MUST NOT PIN
	# THE SAVE VERSION LITERAL.** This gate was written with `== 12` and the
	# sweep that found `check_ct` pinning `== 11` found this one too: the
	# population was TWO and one of them was the gate this batch was writing.
	# **A NAMED LIST CANNOT AUDIT ITSELF.** What §3 actually claims is that the
	# two new fields survive a round trip and that a v11 save still loads; the
	# number is incidental to both, and a later tolerant bump must not red this.
	var raw = FileAccess.open(real, FileAccess.READ).get_var(true)
	ok(raw is Dictionary and int(raw["version"]) >= 12,
		"§3: the run save writes v12 or later (found %d)" % int((raw as Dictionary).get("version", 0)))
	ok(raw is Dictionary and int(raw.get("zone_bosses_cleared", -1)) == 2,
		"§3: ...carrying the zone-boss count")

	run.zone_bosses_cleared = 0
	run.party = []
	ok(run.load_run(), "§3: it loads back")
	ok(int(run.zone_bosses_cleared) == 2, "§3: ...with the ladder where it was")
	ok(int(run.ability_slot_cap()) == 9, "§3: ...so the cap is 9, not 7")
	var back: Dictionary = run.party[0]
	ok(run.earned_ability_names(back).has("Shatterpoint"),
		"§3: ...the benched card is still held")
	ok(not run.equipped_ability_names(back).has("Shatterpoint"),
		"§3: ...and still benched")

	# **THE v11 ARM, AND IT IS THE HALF THAT MATTERS.** A save written before EG
	# carries neither key. The counter must default to `zone_idx` (not zero, or
	# a resumed zone-3 run loses two slots) and the loadout must default to the
	# whole pool (or a resumed hero loses every card he had).
	var old: Dictionary = raw.duplicate(true)
	old["version"] = 11
	old.erase("zone_bosses_cleared")
	old["zone_idx"] = 2
	for mem in old["party"]:
		(mem as Dictionary).erase("bm_equipped")
	var f2 := FileAccess.open(real, FileAccess.WRITE)
	f2.store_var(old, true)
	f2 = null
	run.zone_bosses_cleared = 0
	run.party = []
	ok(run.load_run(), "§3: a v11 save still LOADS — the threshold did not move")
	ok(int(run.zone_bosses_cleared) == 2,
		"§3: ...and its ladder defaults to `zone_idx`, not to zero")
	var v11: Dictionary = run.party[0]
	ok(run.equipped_ability_names(v11).size() == run.earned_ability_names(v11).size(),
		"§3: ...and a v11 hero carries everything he holds")
	ok(run.benched_ability_names(v11).is_empty(),
		"§3: ...with nothing benched")

	# AND THE REFUSAL PATH IS UNTOUCHED, which is what "follow the existing
	# refusal rather than inventing one" means: pre-v10 is still cleared.
	old["version"] = 9
	var f3 := FileAccess.open(real, FileAccess.WRITE)
	f3.store_var(old, true)
	f3 = null
	ok(not run.load_run(), "§3: a pre-v10 save is still REFUSED")
	ok(not run.has_save(), "§3: ...and cleared")
	run.sim_run = sim_was


# Comments are stripped before every source read above, because a comment naming
# a retired identifier reads exactly like the identifier still being live —
# `check_dr` §4's rule, and the reason its own control puts the name back in a
# comment and confirms the gate stays quiet.
func _strip_comments(src: String) -> String:
	var out := PackedStringArray()
	for line in src.split("\n"):
		var l := String(line)
		var i := l.find("#")
		if i >= 0 and not l.substr(0, i).contains("\""):
			l = l.substr(0, i)
		out.append(l)
	return "\n".join(out)
