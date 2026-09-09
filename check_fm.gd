# BATCH FM — THE FILLER COMES OUT.
#
#   §1  THE GENERATED FAMILY IS OUT OF THE OFFER — the population DERIVED
#       rather than listed, the removal driven, the generator kept, and the one
#       place it is still reachable named and asserted
#   §2  EVERY OFFER SITE SAYS SO — the Peddler, the elite cache, the bargain and
#       the event verb, each driven at a FULL pool and at an EXHAUSTED one
#   §3  THE CACHE'S RE-ASK AT AN EXHAUSTED POOL — the stranded pick, and the
#       door that spends it
#   §4  A SHORT TRIPLE IS OFFERED RATHER THAN DISCARDED
#
# **WHY THIS BATCH EARNS A GATE.** It encodes a RULING — the generated stat
# family is removed from every offer path and an empty offer is ACCEPTED — and
# the ruling decays in three directions, all of them silent:
#
#   §1 DECAYS BY RE-ADDITION. The floor is two lines (`append_array` the
#     markers, `return template_rune(...)`), and every instinct a later batch
#     will have on meeting an empty offer is to put one of them back. The
#     population is DERIVED from a census of `scripts/` rather than read off a
#     list, so a fifth offer site is caught by the same assertion.
#   §2 IS THE HALF THAT MATTERS AND IT IS INVISIBLE TO EVERY STATIC CHECK.
#     A panel that renders nothing is a DRAW-time fact. FE §2 is the precedent:
#     `_pick_ability` guarded correctly and left 604 dead buttons over 240 runs,
#     and a battery of source reads saw none of it. **THESE ARMS PRESS.**
#   §3 IS THE SAME FAILURE WITH THE BUTTON REMOVED INSTEAD OF LEFT BEHIND, and
#     it is worse: an owed rune pick that can never be answered keeps the hero's
#     card purple for the rest of the run and nothing anywhere goes red.
#
# **EVERY NEGATIVE ANCHOR HERE IS PAIRED WITH A POSITIVE ARM**, per the brief.
# "No stat stick came out" is exactly what a broken driver prints, so every
# absence is measured beside a presence taken through the same door.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fm.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SPECS := ["berserker", "cryomancer", "inquisitor", "sharpshooter"]
const SCRATCH_PROFILE := "user://fm_profile.json"

var _g := Gate.new()
var _run: Node = null
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260908)
	print("BATCH FM — THE FILLER COMES OUT")
	_run = root.get_node("/root/Run")
	_take_the_save()
	Profile.save_path = SCRATCH_PROFILE
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")

	_s1_out_of_the_offer()
	await _s2_every_site_says_so()
	await _s3_the_re_ask()
	_s4_the_short_triple()

	_give_the_save_back()
	_g.report(self)


# ── THE PLAYER'S SAVE ────────────────────────────────────────────────────────
#
# BATCH FI — `Run.save_path` is redirected for the whole process, so this drive
# writes the harness file. What is here is the ASSERTION of that, taken before
# the first step and checked after the last. **BOTH ARMS RUN WHETHER OR NOT
# THERE IS A SAVE** — guarding the second behind `if _had_save` makes the check
# count depend on whether the machine happens to have a run in progress, which
# is a baseline row that reds for a reason outside the tree (measured at FH).
func _take_the_save() -> void:
	var p: String = _run.SAVE_PATH
	_had_save = FileAccess.file_exists(p)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(p)
	print("  the player's run save: %s" % (
		"present, %d B — this gate writes %s and will not open it"
			% [_save_backup.size(), _run.save_path]
		if _had_save else "none on this machine — the arms below still both run"))


func _give_the_save_back() -> void:
	var p: String = _run.SAVE_PATH
	ok(FileAccess.file_exists(p) == _had_save,
		"the player's run save is NOT as this gate found it")
	ok(not _had_save or FileAccess.get_file_as_bytes(p) == _save_backup,
		"the player's run save came back changed")


# A member with nothing: no pouch, no drafted card, no trophy.
func _member(class_key: String, spec: String) -> Dictionary:
	return {"key": class_key, "spec": spec, "runes": [], "abilities": [],
		"bm_abilities": [], "bm_equipped": []}


# The same member with every rune they can currently roll already worn. This is
# THE exhausted state the whole batch is about, and it is built through
# `eligible_ids` rather than from a count, so a spec whose pool grows is
# exhausted by this helper with no edit here.
func _exhausted(class_key: String, spec: String) -> Dictionary:
	var m := _member(class_key, spec)
	for id in Runes.eligible_ids(m, []):
		m["runes"].append(Runes.build(String(id)))
	return m


# ═══ §1 — THE GENERATED FAMILY IS OUT OF THE OFFER ═══════════════════════════

func _s1_out_of_the_offer() -> void:
	print("\n§1 — the generated family is out of the offer")

	# ── (a) THE POPULATION, DERIVED FROM A CENSUS AND NOT FROM A LIST ────────
	#
	# **THE BRIEF FORBADE TAKING FD'S FOUR AND THIS IS WHY THE ANSWER IS BETTER
	# THAN FOUR.** FD derived its population from the WRITE to `member["runes"]`
	# and found four sites; the population that actually matters is the set of
	# things that can PRODUCE a rune, and there is exactly one of those. Every
	# offer site reaches the pool through `run_state.generate_rune`, so the two
	# calls counted here are the entire surface — a fifth site cannot reach the
	# family without moving one of these numbers.
	var dir := DirAccess.open("res://scripts")
	var files: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd"):
				files.append(f)
	files.sort()
	ok(files.size() >= 15,
		"§1a: the census read %d files under `scripts/` — it read nothing" % files.size())
	var gen_sites: Array = []
	var tpl_sites: Array = []
	for f in files:
		var src := Gate.strip_comments(
			FileAccess.get_file_as_string("res://scripts/" + String(f)))
		for _i in src.count("Runes.generate("):
			gen_sites.append(String(f))
		for _j in src.count("Runes.template_rune("):
			tpl_sites.append(String(f))
	print("    `Runes.generate(` in scripts/: %s" % [gen_sites])
	print("    `Runes.template_rune(` in scripts/: %s" % [tpl_sites])
	ok(gen_sites == ["run_state.gd"],
		"§1a: the pool is drawn from %s — `generate_rune` is no longer the one choke point" % [gen_sites])
	ok(tpl_sites == ["run_state.gd"],
		"§1a: the generated family is built at %s — a second reach into it exists" % [tpl_sites])
	# **AND THE ONE CALL IS INSIDE THE SIM BRANCH**, which is the difference
	# between "reachable by a flag" and "reachable by a player".
	var rs := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/run_state.gd"))
	ok(rs.contains("\t\t\"stats\":\n\t\t\treturn Runes.template_rune("),
		"§1a: the surviving `template_rune` call is no longer the `\"stats\"` sim branch")

	# ── (b) THE REMOVAL, DRIVEN, AT EVERY POUCH DEPTH ────────────────────────
	#
	# **EVERY DEPTH, NOT JUST THE EMPTY ONE.** The markers used to be appended
	# beside the authored ids at every draw, so a stat stick could come out of a
	# FULL pool as easily as an empty one; asserting only the exhausted case
	# would miss a floor that had been restored halfway up.
	var stick: Array = []
	var empty_early: Array = []
	var full_late: Array = []
	var draws := 0
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			var elig: Array = Runes.eligible_ids(_member(String(ckey), String(spec)), [])
			for own in range(elig.size() + 1):
				var m := _member(String(ckey), String(spec))
				for i in range(own):
					m["runes"].append(Runes.build(String(elig[i])))
				for _t in 6:
					var got: Dictionary = Runes.generate(m, 1)
					draws += 1
					if String(got.get("id", "")).begins_with("tpl_"):
						stick.append("%s@%d" % [spec, own])
					if got.is_empty() and own < elig.size():
						empty_early.append("%s@%d of %d" % [spec, own, elig.size()])
					if not got.is_empty() and own == elig.size():
						full_late.append("%s@exhausted -> %s" % [spec, got.get("id", "")])
	ok(draws > 300, "§1b: only %d draws were taken — the drive read nothing" % draws)
	ok(stick.is_empty(),
		"§1b: a generated stat stick came out of an offer — %s" % [stick])
	# THE POSITIVE ARM. "No stick came out" is what a broken driver prints too;
	# this is what proves the draws were real.
	ok(empty_early.is_empty(),
		"§1b: an offer came back EMPTY while the hero still had runes to draw — %s" % [empty_early])
	# AND THE RULING, ASSERTED IN THE OTHER DIRECTION. An empty offer at an
	# exhausted pool is the outcome the designer accepted; a NON-empty one there
	# means a floor came back.
	ok(full_late.is_empty(),
		"§1b: an exhausted pool still produced an offer — the floor is back: %s" % [full_late])

	# ── (c) THE GENERATOR IS KEPT, AND SAID TO BE KEPT (ET's contract) ───────
	#
	# **REMOVED FROM THE OFFER, NOT FROM THE CODE.** The brief is explicit, and
	# a later batch restoring a floor must not have to re-author a family. These
	# arms fail the day someone tidies the dead code away.
	ok(Runes.TEMPLATES.size() == 6,
		"§1c: the generated family holds %d entries, not the six ET kept" % Runes.TEMPLATES.size())
	ok(int(Runes.TEMPLATE_PRICE) == 50,
		"§1c: TEMPLATE_PRICE moved to %d — ET chose no price and neither does FM" % int(Runes.TEMPLATE_PRICE))
	var kept: Dictionary = Runes.template_rune("warrior", "Vitality")
	ok(String(kept.get("id", "")) == "tpl_vitality"
			and String(kept.get("name", "")) == "Rune of Vitality"
			and int(kept.get("price", 0)) == 50
			and not (kept.get("payload", {}) as Dictionary).is_empty(),
		"§1c: the kept generator no longer builds a well-formed rune — %s" % [kept])
	var runes_src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/runes.gd"))
	ok(runes_src.contains("static func _template_markers("),
		"§1c: `_template_markers` was deleted — restoring a floor now costs a re-author")
	# **AND IT HAS NO CALLER, WHICH IS THE OTHER HALF OF THE SAME CLAIM.** One
	# `append_array` brings the floor back; a caller means it never left.
	ok(runes_src.count("_template_markers(") == 1,
		"§1c: `_template_markers` has a caller again — the floor is back in the pool")

	# ── (d) THE ONE PLACE IT IS STILL REACHABLE, TWO-ARMED ───────────────────
	#
	# **THE BRIEF ASKED WHERE IT REMAINS REACHABLE AND THE ANSWER IS ONE FLAG.**
	# `DOD_SIM_RUNES=stats` is an environment arm whose whole documented purpose
	# is to run the sim on exactly this family, so closing it would delete a
	# measurement rather than an offer. **THIS IS ALSO §1b's CONTROL**: the same
	# member through the same door yields a stat stick under the flag and never
	# without it, which is what proves §1b measured the removal and not a driver
	# that had stopped drawing.
	var probe := _member("warrior", "warden")
	var had_flag := OS.get_environment("DOD_SIM_RUNES")
	var plain: Dictionary = _run.generate_rune(probe)
	OS.set_environment("DOD_SIM_RUNES", "stats")
	var armed: Dictionary = _run.generate_rune(probe)
	OS.set_environment("DOD_SIM_RUNES", had_flag)
	ok(not String(plain.get("id", "")).begins_with("tpl_"),
		"§1d: the ordinary path handed back a stat stick — %s" % [plain.get("id", "")])
	ok(String(armed.get("id", "")).begins_with("tpl_"),
		"§1d: `DOD_SIM_RUNES=stats` no longer reaches the family — the sim arm is dead, not the offer")
	ok(String(_run.runes_mode()) == "full",
		"§1d: the flag was not put back — this gate is leaking an arm into the ones below")


# ═══ §2 — EVERY OFFER SITE SAYS SO ═══════════════════════════════════════════
#
# **THIS IS THE HALF THAT MATTERS AND IT IS PRESSED RATHER THAN READ.** Each
# site is driven twice: once at a FULL pool, where it must offer and must NOT
# print the empty line, and once at an EXHAUSTED one, where it must do the
# reverse. The paired arm is not decoration — an empty-state message that is
# printed unconditionally passes every "the screen says so" check ever written,
# and would replace the silent panel with a permanent lie.

func _s2_every_site_says_so() -> void:
	print("\n§2 — every offer site says so, at a full pool and at an exhausted one")
	await _s2a_the_peddler()
	await _s2b_the_elite_cache()
	_s2c_the_bargain()
	_s2d_the_event_verb()


# Put the whole party into the exhausted state, in place, on the live run.
func _drain_the_party() -> void:
	for m in _run.party:
		var worn: Array = []
		for id in Runes.eligible_ids(m, []):
			var r: Dictionary = Runes.build(String(id))
			r["equipped"] = false
			worn.append(r)
		m["runes"] = worn
	for m2 in _run.party:
		ok(Runes.pool_empty_for(m2),
			"§2: %s still has a rune to draw — the drain did not drain" % [m2.get("spec", "?")])


# ── (a) THE PEDDLER, ON THE REAL SHOP SCREEN ────────────────────────────────
func _s2a_the_peddler() -> void:
	var _s: Node = await _fresh_map()
	_run.gold = 2000
	_run.save_run()
	# ARM 1 — A FULL POOL. The column is populated and says nothing about
	# emptiness. This is the arm that proves the arm below measures something.
	change_scene_to_file("res://scenes/shop.tscn")
	for _i in 4:
		await process_frame
	var shop: Node = current_scene
	var offers: Array = shop.get("offers")
	print("    full pool: the Peddler offers %d runes" % offers.size())
	ok(not offers.is_empty(), "§2a: the Peddler offered NO rune to a party that has none")
	ok(not _has_text(shop, "has nothing for"),
		"§2a: the Peddler announced an empty column while it was offering %d runes" % offers.size())
	ok(_buttons_named(shop, "Buy — ") > 0,
		"§2a: the Peddler drew no Buy button at a full pool")

	# ARM 2 — AN EXHAUSTED POOL. The column is empty and SAYS SO, by hero.
	_drain_the_party()
	_run.save_run()
	change_scene_to_file("res://scenes/shop.tscn")
	for _i in 4:
		await process_frame
	var shop2: Node = current_scene
	var offers2: Array = shop2.get("offers")
	print("    exhausted: the Peddler offers %d runes" % offers2.size())
	ok(offers2.is_empty(),
		"§2a: the Peddler still offered %d runes to a party holding every one" % offers2.size())
	ok(_has_text(shop2, "The Peddler has nothing for"),
		"§2a: THE COLUMN IS A HEADER OVER WHITE SPACE — no line says why it is empty")
	# **IT NAMES THE HERO AND THE REASON**, which is CO §3's rule rather than a
	# nicety: a refusal that does not name the thing reads as a bug.
	var named := 0
	for i in _run.party.size():
		if _has_text(shop2, String(Classes.SPEC_INFO[String(_run.party[i]["spec"])]["name"])):
			named += 1
	ok(named == _run.party.size(),
		"§2a: the empty column names %d of %d heroes" % [named, _run.party.size()])
	ok(_has_text(shop2, "already carry every rune written for that awakening")
			or _has_text(shop2, "wait on cards they have not drafted"),
		"§2a: the empty column gives no reason — a refusal with no reason reads as a bug (CO §3)")
	ok(_buttons_named(shop2, "Buy — ") == 0,
		"§2a: a Buy button survived an empty rune column — FE's dead button, on the shop")
	# AND THE SCREEN IS STILL USABLE. An empty column that swallowed the exit
	# would be a worse failure than the one being repaired.
	ok(_buttons_named(shop2, "Leave the Shop") == 1,
		"§2a: the shop lost its exit")


# ── (b) THE ELITE CACHE, ON A REAL ELITE VICTORY ────────────────────────────
#
# **THE SPOILS ARE A DRAW-TIME STRING AND THIS GOES AND GETS THEM.** The cache's
# line is assembled inside `battle._check_end()` and rendered by `_show_end`, so
# the only way to read what the PLAYER reads is to reach a real elite victory
# and look at the card.
#
# **THE BATTLE COMES FROM `gate_fixture.spawn` AND NOT FROM A HAND-ROLLED
# `change_scene_to_file`, WHICH IS DB §1's RULE AND `check_da` CAUGHT THE FIRST
# DRAFT BREAKING IT.** That version named the battle scene by path and drove the
# autoplay bot through a whelp — which worked, and which was still a second
# battle fixture, the exact thing DB consolidated seven copies of.
#
# **AND THE PATH MAY NOT APPEAR IN THIS COMMENT EITHER.** `check_da` §3 reads
# the RAW source, not a comment-stripped one, so prose describing the removed
# call reads to that gate exactly like the call still being there — which is
# CLAUDE.md's EV §5 rule, and it caught this file twice in one batch.
#
# **THE FIGHT IS SHORT-CIRCUITED AT ITS OWN VICTORY CONDITION AND NOTHING ELSE
# IS.** `_check_end` opens `victory := enemies.all(func(e): return e.dead)`, so
# marking the warband dead and calling it takes the REAL victory path: the real
# `Run.claim_reward`, the real `Run.roll_rune_candidates`, the real spoils
# assembly and the real `_show_end`. **What is skipped is the combat, which is
# not an offer site** — and skipping it makes this arm deterministic rather than
# dependent on a bot winning, which is what the first draft's 20,000-frame cap
# was really guarding against.
func _s2b_the_elite_cache() -> void:
	var full_text := await _elite_victory(false)
	print("    full pool, the elite card says: %s" % _spoils_lines(full_text))
	ok(full_text.contains("RUNE CACHE: the "),
		"§2b: an elite at a FULL pool printed no rune-cache line at all")
	ok(not full_text.contains("nothing in it for"),
		"§2b: an elite at a FULL pool announced an empty cache")
	var empty_text := await _elite_victory(true)
	print("    exhausted, the elite card says: %s" % _spoils_lines(empty_text))
	ok(empty_text.contains("RUNE CACHE: nothing in it for"),
		"§2b: AN ELITE AT AN EXHAUSTED POOL SAID NOTHING — the cache simply vanishes")
	ok(empty_text.contains("ELITE SPOILS"),
		"§2b: the elite paid no spoils at all — the empty cache took the whole drop with it")


# One elite victory, with the card's text returned.
func _elite_victory(drain: bool) -> String:
	var b: Node = await Gate.spawn(self, SPECS, {"run": _run})
	# **THE POUCH IS DRAINED AFTER THE SPAWN, ON PURPOSE.** The spoils path reads
	# `Run.party` (`party.pick_random()` for the looter, then
	# `Run.roll_rune_candidates` on it), never the spawned BattleUnits — so what
	# the heroes are wearing in the fight is irrelevant to this arm, and draining
	# before the spawn would only change their stats.
	if drain:
		_drain_the_party()
	# The fixture fights a `"fight"`; the cache is the ELITE branch's.
	_run.encounter["type"] = "elite"
	_run.encounter["theme"] = "A lone whelp"
	var foes: Array = b.get("enemies")
	ok(not foes.is_empty(), "§2b: the fixture spawned no enemies to beat")
	for e in foes:
		e.dead = true
	b.call("_check_end")
	for _j in 8:
		await process_frame
	ok(bool(b.get("battle_over")), "§2b: `_check_end` did not resolve the battle")
	var texts: Array = []
	_texts(b, texts)
	var card := "\n".join(PackedStringArray(texts))
	b.queue_free()
	await process_frame
	return card


# ── (c) THE BARGAIN, THROUGH ITS OWN PAYOUT DOOR ────────────────────────────
#
# `claim_reward` is where the rung's price is paid off, and it is an ordinary
# function — so this arm drives the real thing rather than a screen holding it.
func _s2c_the_bargain() -> void:
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
	# ARM 1 — A FULL POOL.
	_run.accept_offer({"modifier": "", "reward": {"kind": "rune"}})
	var paid: Dictionary = _run.claim_reward()
	print("    full pool, the bargain says: %s" % String(paid.get("text", "")))
	ok(String(paid.get("text", "")).contains("may choose one of"),
		"§2c: the bargain paid nothing at a full pool — `%s`" % String(paid.get("text", "")))
	var owed := 0
	for m in _run.party:
		owed += int(m.get("rune_picks_owed", 0))
	ok(owed == 1, "§2c: the bargain owed %d rune picks, not one" % owed)
	# ARM 2 — AN EXHAUSTED POOL. **THE MODIFIER IS THE PRICE**, so a blank line
	# here is a reward the player already fought for, vanishing.
	_drain_the_party()
	for m2 in _run.party:
		m2["rune_picks_owed"] = 0
		m2["rune_candidates"] = []
	_run.accept_offer({"modifier": "", "reward": {"kind": "rune"}})
	var unpaid: Dictionary = _run.claim_reward()
	print("    exhausted, the bargain says: %s" % String(unpaid.get("text", "")))
	ok(String(unpaid.get("text", "")) != "",
		"§2c: THE BARGAIN PAID A BLANK LINE — the player fought the modifier for nothing and was not told")
	ok(String(unpaid.get("text", "")).contains("nothing left to hand over"),
		"§2c: the bargain's empty payout does not say what happened — `%s`"
			% String(unpaid.get("text", "")))


# ── (d) THE EVENT VERB, THROUGH `Events.apply` ──────────────────────────────
func _s2d_the_event_verb() -> void:
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
	var got := String(Events.apply(_run, {"effect": "rune_grant", "amount": 1}))
	print("    full pool, the event says: %s" % got)
	ok(got.begins_with("RUNE: ") and not got.contains("nothing answers"),
		"§2d: the event verb granted nothing at a full pool — `%s`" % got)
	_drain_the_party()
	var none := String(Events.apply(_run, {"effect": "rune_grant", "amount": 1}))
	print("    exhausted, the event says: %s" % none)
	ok(none != "",
		"§2d: THE EVENT PAID A BLANK LINE — an event is a trade and the player has already paid")
	ok(none.contains("nothing answers"),
		"§2d: the event's empty grant does not say what happened — `%s`" % none)


# ═══ §3 — THE CACHE'S RE-ASK AT AN EXHAUSTED POOL ════════════════════════════
#
# **FD'S HOLE WAS IN THE ANSWER, NOT THE OFFER, AND SO IS FM'S.** The cache
# rolls at the DROP, stores its triple on the member and rides the save until
# the player answers it. `Run.rune_choice` re-asks at resolution and repairs in
# place — and with the family gone its top-up can come back empty, which turns
# a repaired triple into NO triple.
#
# **THE DRIVE IS THE BRIEF'S: roll a cache, exhaust the hero's pool, answer
# it.** Every step is the real one — the real overlay, the real button.
func _s3_the_re_ask() -> void:
	print("\n§3 — the elite cache, re-asked at an exhausted pool")
	var s: Node = await _fresh_map()
	var idx := 1
	var hero: Dictionary = _run.party[idx]

	# (1) ROLL THE CACHE, at a pool that has something in it.
	var cands: Array = _run.roll_rune_candidates(hero)
	ok(cands.size() == 3, "§3: the cache rolled %d candidates, not three" % cands.size())
	hero["rune_candidates"] = hero.get("rune_candidates", []) + [cands]
	hero["rune_picks_owed"] = int(hero.get("rune_picks_owed", 0)) + 1

	# (2) EXHAUST THE HERO'S POOL BETWEEN THE DROP AND THE ANSWER. This is the
	# window FD named: the triple is frozen on the member while the pouch moves
	# underneath it. Buying the queued runes from the Peddler is exactly this.
	var worn: Array = []
	for id in Runes.eligible_ids(hero, []):
		worn.append(Runes.build(String(id)))
	hero["runes"] = worn
	ok(Runes.pool_empty_for(hero), "§3: the hero's pool is not exhausted — the drive is not testing this")

	# (3) THE RE-ASK ITSELF.
	var live: Array = _run.rune_choice(hero)
	print("    the re-ask returns %d candidates at an exhausted pool" % live.size())
	ok(live.is_empty(),
		"§3: the re-ask handed back %d runes the hero already wears" % live.size())
	# **AND IT IS IDEMPOTENT**, which is what lets the overlay and the handler
	# read the same array. FD's own property, re-driven because a repair that
	# now returns empty is a repair that could have stopped writing back.
	ok((_run.rune_choice(hero) as Array).is_empty(),
		"§3: the re-ask is no longer idempotent at an exhausted pool")

	# (4) THE OVERLAY, DRAWN. **SCOPED TO THE OVERLAY AND NOT TO THE SCREEN** —
	# a walk over the whole map reads map-node buttons as pick offers, which is
	# a gate bug that looks exactly like a code bug.
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 5:
		await process_frame
	var map: Node = current_scene
	ok(int(hero.get("rune_picks_owed", 0)) == 1,
		"§3: the owed pick did not survive the step onto the map")
	var before := _live_children(map)
	map.call("_open_pick_overlay", idx)
	await process_frame
	ok(_live_children(map) > before, "§3: the pick overlay opened nothing")
	var overlay: Node = map.get_child(map.get_child_count() - 1)
	ok(_has_text(overlay, "RUNE"), "§3: the overlay that opened is not the rune pick")
	# **THE HEADING OVER NOTHING IS THE DEFECT.** Before FM §3 this overlay drew
	# `"… — RUNE, choose one"` and a single `Not yet` button, and the pick could
	# never be answered.
	ok(_has_text(overlay, "The cache holds nothing this hero can take"),
		"§3: THE OVERLAY IS A HEADING OVER NOTHING — no line says why there is no choice")
	ok(_buttons_named(overlay, "Let it go") == 1,
		"§3: the overlay offers no way to spend a pick that cannot be answered — the run carries it forever")

	# (5) PRESS IT. The pick is spent, the queue is emptied, and the card stops
	# offering a choice it cannot honour.
	ok(_press(overlay, "Let it go"), "§3: the `Let it go` button did not fire")
	for _j in 3:
		await process_frame
	ok(int(hero.get("rune_picks_owed", 0)) == 0,
		"§3: the pick is still owed after being let go — %d" % int(hero.get("rune_picks_owed", 0)))
	ok((hero.get("rune_candidates", []) as Array).is_empty(),
		"§3: the empty triple is still queued on the member")
	# **AND THE RUN IS NOT BLOCKED**, which is the whole question §3 asks. The
	# card's own CHOOSE door is asked again: `_open_pick_overlay` returns before
	# it builds anything when nothing is owed, so a screen that grew is a pick
	# that survived being spent.
	var after_open := _live_children(map)
	map.call("_open_pick_overlay", idx)
	await process_frame
	ok(_live_children(map) == after_open,
		"§3: the card still opens a rune pick after the pick was spent")

	# (6) THE CONTROL, IN THE OTHER DIRECTION. A hero whose pool still has
	# something must get BUTTONS and no `Let it go` — otherwise this section
	# would pass on a build that had simply stopped offering runes at all.
	var other := 2
	var m2: Dictionary = _run.party[other]
	m2["runes"] = []
	var c2: Array = _run.roll_rune_candidates(m2)
	ok(not c2.is_empty(), "§3: the control hero rolled no candidates")
	m2["rune_candidates"] = m2.get("rune_candidates", []) + [c2]
	m2["rune_picks_owed"] = 1
	var b3 := _live_children(map)
	map.call("_open_pick_overlay", other)
	await process_frame
	ok(_live_children(map) > b3, "§3: the control overlay opened nothing")
	var ov2: Node = map.get_child(map.get_child_count() - 1)
	ok(_buttons_named(ov2, "Let it go") == 0,
		"§3: a hero with runes left was offered the `Let it go` door — it is not scoped to the empty case")
	ok(not _has_text(ov2, "The cache holds nothing this hero can take"),
		"§3: a hero with runes left was told the cache holds nothing")
	# **THE PICKS PLUS `Not yet`, EXACTLY.** A floor would pass on an overlay
	# that had grown a second empty-state button beside the real ones.
	ok(_count_buttons(ov2) == c2.size() + 1,
		"§3: the control overlay drew %d buttons against %d runes on offer plus `Not yet`"
			% [_count_buttons(ov2), c2.size()])


# ═══ §4 — A SHORT TRIPLE IS OFFERED, NOT DISCARDED ═══════════════════════════
#
# **`roll_rune_candidates` USED TO `return []` ON THE FIRST EMPTY DRAW** and
# that line was unreachable while the generated family floored every draw. It is
# the ordinary case now, and it fires on pools that are NOT empty: a Pyromancer
# reaches three of his five at spawn, so one rune bought from the first Peddler
# left two — and the cache threw both away, printed nothing and owed nothing.
func _s4_the_short_triple() -> void:
	print("\n§4 — a short triple is offered rather than discarded")
	var sizes: Array = []
	var wrong: Array = []
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			var elig: Array = Runes.eligible_ids(_member(String(ckey), String(spec)), [])
			for own in range(elig.size() + 1):
				var m := _member(String(ckey), String(spec))
				for i in range(own):
					m["runes"].append(Runes.build(String(elig[i])))
				var trip: Array = _run.roll_rune_candidates(m)
				var want: int = mini(elig.size() - own, 3)
				sizes.append(trip.size())
				if trip.size() != want:
					wrong.append("%s@%d of %d -> %d, wanted %d"
						% [spec, own, elig.size(), trip.size(), want])
	ok(not sizes.is_empty(), "§4: the walk rolled nothing")
	ok(wrong.is_empty(),
		"§4: a cache offered the wrong number of candidates — %s" % [wrong])
	# THE TWO ARMS, NAMED. A triple of 3 at a deep pool proves the roller still
	# fills; a triple of 0 at an exhausted one proves the empty case survives.
	ok(sizes.has(3), "§4: no cache ever rolled a full three — the roller is broken, not short")
	ok(sizes.has(0), "§4: no cache ever came back empty — the exhausted case is unreachable in this walk")
	ok(sizes.has(1) or sizes.has(2),
		"§4: no SHORT triple was ever rolled — `return []` is still throwing them away")
	print("    triple sizes seen across every spec at every pouch depth: %s"
		% [_histogram(sizes)])


# ── THE DRIVE'S PRIMITIVES ───────────────────────────────────────────────────

func _fresh_map() -> Node:
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	for i in _run.party.size():
		_run.party[i]["spec"] = SPECS[i]
		_run.party[i]["tree"] = Talents.generate_tree(SPECS[i], _run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 4:
		await process_frame
	return current_scene


# **A `queue_free`d NODE IS STILL IN THE TREE FOR A FRAME**, so the walks below
# skip anything already doomed — a panel compared against itself is the shape
# that made a before/after UI drive read clean.
func _texts(n: Node, out: Array) -> void:
	if n.is_queued_for_deletion():
		return
	if n is Label:
		out.append(String((n as Label).text))
	if n is RichTextLabel:
		out.append(String((n as RichTextLabel).text))
	if n is Button:
		out.append(String((n as Button).text))
	for c in n.get_children():
		_texts(c, out)


func _has_text(n: Node, needle: String) -> bool:
	var t: Array = []
	_texts(n, t)
	for x in t:
		if String(x).contains(needle):
			return true
	return false


func _buttons(n: Node, out: Array) -> void:
	if n.is_queued_for_deletion():
		return
	if n is Button:
		out.append(n)
	for c in n.get_children():
		_buttons(c, out)


func _buttons_named(n: Node, prefix: String) -> int:
	var b: Array = []
	_buttons(n, b)
	var hits := 0
	for x in b:
		if String((x as Button).text).begins_with(prefix):
			hits += 1
	return hits


func _count_buttons(n: Node) -> int:
	var b: Array = []
	_buttons(n, b)
	return b.size()


# Children that are really there. A `queue_free`d node stays in the tree for a
# frame, so a raw `get_child_count()` compares a screen against its own ghosts.
func _live_children(n: Node) -> int:
	var live := 0
	for c in n.get_children():
		if not c.is_queued_for_deletion():
			live += 1
	return live


# A press is `emit_signal("pressed")` — the same signal the mouse emits —
# rather than a call to the handler, because a button whose signal was never
# connected is exactly the defect a live drive is looking for.
func _press(n: Node, prefix: String) -> bool:
	var b: Array = []
	_buttons(n, b)
	for x in b:
		if String((x as Button).text).begins_with(prefix) and not (x as Button).disabled:
			(x as Button).emit_signal("pressed")
			return true
	return false


# The card's own spoils, out of a walk that necessarily reads the whole battle
# screen: the end card is a CHILD of the battle scene, so every ability button
# and every nameplate comes back with it. Printing all of it buries the two
# lines this section is about.
func _spoils_lines(all_text: String) -> String:
	var keep := PackedStringArray()
	for line in all_text.split("\n"):
		var t := String(line).strip_edges()
		if t.begins_with("RUNE CACHE") or t.begins_with("ELITE SPOILS") \
				or t.begins_with("THE DRAFT") or t.begins_with("VICTORY"):
			keep.append(t)
		elif not keep.is_empty() and String(keep[keep.size() - 1]).begins_with("RUNE CACHE") \
				and t != "":
			keep.append(t)
	return " / ".join(keep) if not keep.is_empty() else "(no spoils line on the card)"


func _histogram(vals: Array) -> Dictionary:
	var out := {}
	for v in vals:
		out[v] = int(out.get(v, 0)) + 1
	return out
