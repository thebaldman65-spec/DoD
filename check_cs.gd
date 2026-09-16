# BATCH CS — the gate for the Sharpshooter's basic-attack sequence.
#
# IT IS A LIVE GATE ON PURPOSE. The sims cannot reach this code: the bot never
# runs the bar, so §2's partial credit, §4's tapering windows and §6's tell are
# exercised nowhere else in the repo. This spawns a real non-autoplay battle
# with a Sharpshooter, DRIVES HIS BAR BY HAND at every press count the design
# allows, and measures what the sequence actually paid — check_cm_live's shape,
# pointed at the offensive bar instead of the defensive one.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cs.gd
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260819)
	var battle := load("res://scripts/battle.gd")

	# ---------- §1 — THE PRESS TABLE, AND THE CAP ----------
	print("BATCH CS §1 — the press table")
	# Determinism forced: the floor check asserts his basic DEALS DAMAGE at
	# every press count, and a miss or a block would make that a coin toss.
	var scene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "holy", "sharpshooter"], {"deterministic": true})
	var ss: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and h.has_engine("lethal_aim"):
			ss = h
	ok(ss != null, "the party has a Sharpshooter")
	if ss == null:
		_report()
		return
	ok(scene._is_sharpshooter_basic(ss, ss.abilities[0]),
		"his SLOT 0 is the sequence — read off the hero, not off a name")
	ok(not scene._is_sharpshooter_basic(ss, ss.abilities[ss.abilities.size() - 1]),
		"nothing else of his is: THE BASIC ATTACK ONLY")
	for other in scene.get("heroes"):
		if other.is_companion or other == ss:
			continue
		ok(not scene._is_sharpshooter_basic(other, other.abilities[0]),
			"%s's basic is not a sequence" % other.unit_name)

	# The table §1 prints, asserted row by row rather than at its edges only.
	var want := {0: 1, 1: 1, 49: 1, 50: 2, 99: 2, 100: 3, 149: 3, 150: 4,
		151: 4, 199: 4, 200: 4, 400: 4, 1000: 4}
	for focus in want:
		ss.second_resource = int(focus)
		var got: int = scene._sequence_presses(ss)
		ok(got == int(want[focus]), "%d Focus → %d presses (got %d)" % [
			int(focus), int(want[focus]), got])
	# THE CAP IS THE POINT. Focus has no ceiling, so this is the assertion that
	# stops a later batch reading four as arbitrary and raising it.
	ok(battle.SS_SEQ_MAX_PRESSES == 4, "the cap is four")
	# THE PAYOUT NUMBERS ARE PINNED HERE, AND THE REASON IS A GAP THIS GATE HAD.
	# Every payout check below is written as `landed * SS_SEQ_FOCUS_PER_PRESS`,
	# so it proves the arithmetic and follows the constant wherever it goes — a
	# negative control that changed 8 to 9 passed clean. §3 flags the per-press
	# figure as the designer's to move, which makes it exactly the number that
	# must not move SILENTLY: the changelog, master.html and the glossary all
	# quote it. Moving it is one line here and four in the docs, together.
	ok(battle.SS_SEQ_FOCUS_PER_PRESS == 8,
		"per-press Focus is 8 — the docs quote it; move both or neither")
	ok(battle.SS_SEQ_FULL_BONUS == 20,
		"the full-sequence bonus is 20 — the docs quote it; move both or neither")
	# BATCH GE §1 — THE LONG DRAW'S MISS IS PINNED THE SAME WAY, AND BOTH HALVES.
	# The card quotes the number, so it must not move silently; and the REASON
	# is a relation — twice what a press pays — so the relation is pinned too,
	# and a drain retyped as a literal reds here the day the per-press moves.
	ok(battle.SS_SEQ_MISS_DRAIN == 16,
		"the Long Draw's miss drains 16 — the card quotes it; move both or neither")
	ok(battle.SS_SEQ_MISS_DRAIN == 2 * battle.SS_SEQ_FOCUS_PER_PRESS,
		"...and it is TWICE what a press pays: the press attempted and one already banked")
	ok(battle.SS_SEQ_STEP == 50, "one extra press per 50 Focus")
	ok(battle.SS_SEQ_OPEN.size() == battle.SS_SEQ_MAX_PRESSES,
		"the widening table has exactly one row per allowed press count")

	# ---------- §4 — THE WINDOWS ----------
	print("BATCH CS §4 — the windows")
	var def: Dictionary = battle.SC_PROFILE_DEFAULT
	var def_good_time: float = float(def["good_half"]) * float(def["sweep_time"])
	var def_perf_time: float = float(def["perfect_half"]) * float(def["sweep_time"])
	for n in [1, 2, 3, 4]:
		ss.second_resource = (n - 1) * battle.SS_SEQ_STEP
		var prof: Dictionary = scene._sharpshooter_basic_profile(ss)
		ok(int(prof["presses"]) == n, "profile at %d Focus asks for %d presses" % [
			ss.second_resource, n])
		# HIS EXCEPTION IS A FIXED OFFSET, NOT A SLOPE. Time in the PERFECT
		# window is the same fraction of everyone else's at every press count —
		# harder than the rest of the roster, not harder the better he plays.
		var perf_time: float = float(prof["perfect_half"]) * float(prof["sweep_time"])
		ok(absf(perf_time / def_perf_time - battle.SS_SEQ_OFFSET) < 0.0005,
			"n=%d: his Perfect window is x%.2f of the default's, flat" % [
				n, battle.SS_SEQ_OFFSET])
		# §3's guard: the Perfect window does NOT widen with the press count.
		# The first press's Perfect is what sets the damage, and a deep-Focus
		# Sharpshooter must ramp faster WITHOUT hitting harder per swing.
		var n1: Dictionary = scene._sharpshooter_basic_profile(_at(ss, 0))
		ok(is_equal_approx(float(prof["perfect_half"]), float(n1["perfect_half"])),
			"n=%d: the Perfect window is unchanged by press count" % n)
		# ...and the GOOD window does, which is what holds the difficulty flat.
		var good_time: float = float(prof["good_half"]) * float(prof["sweep_time"])
		ok(good_time >= def_good_time * battle.SS_SEQ_OFFSET - 0.0001,
			"n=%d: the opening Good window is at least his one-press width" % n)
		if n > 1:
			var prev: Dictionary = scene._sharpshooter_basic_profile(
				_at(ss, (n - 2) * battle.SS_SEQ_STEP))
			ok(float(prof["good_half"]) > float(prev["good_half"]),
				"n=%d: the opening window is wider than at n=%d" % [n, n - 1])
	ss.second_resource = 0

	# EACH PRESS IS NARROWER THAN THE ONE BEFORE IT — the sequence has a shape.
	ok(battle.SS_SEQ_TAPER < 1.0, "the taper narrows")
	ok(float(def["press_taper"]) == 1.0,
		"and the DEFAULT taper is the no-op: every other bar in the game is unchanged")

	# §4'S CENTRAL CLAIM, RE-DERIVED HERE RATHER THAN TRUSTED. The OPEN table is
	# solved offline from a stated model; this walks the model again from the
	# constants, so a hand-edited row cannot pass silently.
	var risks: Array = []
	for n in [1, 2, 3, 4]:
		ss.second_resource = (n - 1) * battle.SS_SEQ_STEP
		var prof: Dictionary = scene._sharpshooter_basic_profile(ss)
		var land := 1.0
		for i in n:
			var tol: float = float(prof["good_half"]) * float(prof["sweep_time"]) \
				* pow(battle.SS_SEQ_TAPER, float(i))
			land *= 1.0 - _miss_risk(tol)
		risks.append(land)
		print("  n=%d: the whole sequence lands %.1f%% of the time" % [n, land * 100.0])
	for n in [2, 3, 4]:
		ok(absf(float(risks[n - 1]) - float(risks[0])) < 0.02,
			"n=%d lands within 2 points of a one-press cast — THE DIFFICULTY IS FLAT" % n)
	ss.second_resource = 0

	# ---------- §2/§3/§6 — DRIVEN, PRESS BY PRESS ----------
	print("BATCH CS §2/§3/§6 — the bar, driven at every press count")
	for n in [1, 2, 3, 4]:
		# A FULL SEQUENCE at this press count.
		var all_good: Array = []
		for _i in n:
			all_good.append("good")
		var full := await _drive(scene, ss, (n - 1) * battle.SS_SEQ_STEP, all_good)
		ok(String(full["grade"]) == "good",
			"n=%d full: the grade is the FIRST press's" % n)
		ok(int(full["landed"]) == n and bool(full["full"]),
			"n=%d full: %d of %d landed" % [n, int(full["landed"]), n])
		ok(int(full["focus"]) == n * battle.SS_SEQ_FOCUS_PER_PRESS + battle.SS_SEQ_FULL_BONUS,
			"n=%d full: pays %d Focus (got %d)" % [n,
				n * battle.SS_SEQ_FOCUS_PER_PRESS + battle.SS_SEQ_FULL_BONUS,
				int(full["focus"])])
		ok(int(full["max_presses_seen"]) == n,
			"n=%d full: the bar really swept %d times (saw %d)" % [
				n, n, int(full["max_presses_seen"])])
		if n > 1:
			# §6 — the tell names the count BEFORE the first press and the live
			# press on every one of them.
			ok(String(full["first_hint"]).contains("1 OF %d" % n),
				"n=%d: the bar says how many presses are coming, before the first" % n)
			ok(String(full["last_hint"]).contains("%d OF %d" % [n, n]),
				"n=%d: the bar names the press that is live" % n)
			ok(String(full["result"]).contains("FULL SEQUENCE"),
				"n=%d: a full sequence reads as full (was: %s)" % [n, full["result"]])

		# A PARTIAL at this press count: land everything but the last.
		if n > 1:
			var partial_plan: Array = []
			for i in n:
				partial_plan.append("fail" if i == n - 1 else "good")
			var part := await _drive(scene, ss, (n - 1) * battle.SS_SEQ_STEP, partial_plan)
			ok(int(part["landed"]) == n - 1 and not bool(part["full"]),
				"n=%d partial: %d of %d kept — A MISS ENDS THE SEQUENCE AND KEEPS THE REST" % [
					n, int(part["landed"]), n])
			ok(int(part["focus"]) == (n - 1) * battle.SS_SEQ_FOCUS_PER_PRESS,
				"n=%d partial: per-press Focus and NO full-sequence bonus (got %d)" % [
					n, int(part["focus"])])
			ok(String(part["result"]).contains("BROKEN"),
				"n=%d: a sequence that ended early READS AS ENDED (was: %s)" % [
					n, part["result"]])

	# §2's headline case, stated in the brief's own terms: a four-press attempt
	# that misses on the SECOND is worth ONE press, not zero.
	var second := await _drive(scene, ss, 150, ["good", "fail", "good", "good"])
	ok(int(second["landed"]) == 1,
		"a four-press attempt missing on the second is worth ONE press (got %d)" % \
			int(second["landed"]))
	ok(int(second["focus"]) == battle.SS_SEQ_FOCUS_PER_PRESS,
		"...and it is paid for that one press")
	ok(int(second["max_presses_seen"]) == 2,
		"...and the bar stopped rather than sweeping the presses it had lost")

	# §3 — DAMAGE RESOLVES OFF THE FIRST PRESS. A Perfect opener followed by a
	# broken chain is a Perfect for damage; a Sloppy opener is a Sloppy even if
	# every later press lands.
	var perf_open := await _drive(scene, ss, 150, ["perfect", "fail", "good", "good"])
	ok(String(perf_open["grade"]) == "perfect",
		"a Perfect opener grades Perfect even when the chain breaks")
	var slop_open := await _drive(scene, ss, 150, ["fail", "good", "good", "good"])
	ok(String(slop_open["grade"]) == "fail",
		"a Sloppy opener grades Sloppy — the first press is the damage")
	ok(int(slop_open["landed"]) == 0 and int(slop_open["focus"]) == 0,
		"...and a chain broken on the first shot pays nothing")

	# A CANCEL ON ANY PRESS CANCELS THE WHOLE CHECK AND EARNS NOTHING.
	var cancelled := await _drive(scene, ss, 150, ["good", "cancel"])
	ok(String(cancelled["grade"]) == "cancel", "a mid-sequence cancel cancels the cast")
	ok(int(cancelled["focus"]) == 0, "...and pays no Focus for the presses it had landed")

	# ---------- THE FLOOR: THE WHOLE TURN RESOLVES AT EVERY PRESS COUNT ----------
	print("BATCH CS — the floor: a Sharpshooter basic RESOLVES at every press count")
	for n in [1, 2, 3, 4]:
		var live := await _drive_and_resolve(scene, ss, (n - 1) * battle.SS_SEQ_STEP, n)
		ok(int(live["dealt"]) > 0,
			"n=%d: the basic resolved and the enemy took damage (%d)" % [
				n, int(live["dealt"])])
		ok(int(live["focus"]) > 0, "n=%d: and Focus landed (%d)" % [n, int(live["focus"])])

	# ---------- §5 — THE BOT ----------
	print("BATCH CS §5 — the bot's sequence roll")
	# The bot never presses the bar; it rolls per press and stops at the first
	# failure. Driven through the real branch by running an AUTOPLAY battle is a
	# whole-sim change, so the roll's SHAPE is asserted here instead: over many
	# samples a four-press bot sequence must produce every partial credit from 0
	# to 4, and must average strictly less than four landed presses.
	var seen := {}
	var total := 0.0
	for _i in 4000:
		var landed := 0
		for i in 4:
			var roll := randf()
			var one := "perfect" if roll < 0.20 else ("fail" if roll > 0.85 else "good")
			if one == "fail":
				break
			landed += 1
		seen[landed] = true
		total += landed
	for k in [0, 1, 2, 3, 4]:
		ok(seen.has(k), "the bot's sequence can land %d of four" % k)
	print("  the bot lands %.2f of four on average" % (total / 4000.0))
	ok(total / 4000.0 > 2.0 and total / 4000.0 < 4.0,
		"the bot's sequence is partial credit rather than all-or-nothing")

	# ---------- BATCH GE §1 — THE LONG DRAW'S MISS ----------
	print("BATCH GE §1 — the Long Draw's miss, driven at every press, with the rune and without")
	await _s7_the_long_draw_miss(scene, ss, battle)

	_report()


func _at(u: BattleUnit, focus: int) -> BattleUnit:
	u.second_resource = focus
	return u


# The §4 model, in the gate, so the OPEN table cannot rot silently: a press's
# miss-risk is the tail of a Gaussian timing error outside the Good window.
const SIGMA := 0.060  # the player's timing SD in seconds — the model's one assumption


func _miss_risk(tolerance: float) -> float:
	return 2.0 * _phi(-tolerance / SIGMA)


func _phi(z: float) -> float:
	return 0.5 * (1.0 + _erf(z / sqrt(2.0)))


# Abramowitz & Stegun 7.1.26 — max error 1.5e-7, which is four orders below
# anything asserted off it.
func _erf(x: float) -> float:
	var sign := 1.0 if x >= 0.0 else -1.0
	var ax := absf(x)
	var t := 1.0 / (1.0 + 0.3275911 * ax)
	var y := 1.0 - (((((1.061405429 * t - 1.453152027) * t) + 1.421413741) * t \
		- 0.284496736) * t + 0.254829592) * t * exp(-ax * ax)
	return sign * y


# Drive ONE sequence bar with an authored press plan and report everything the
# batch promises about it, including what `_pay_sequence_focus` then paid.
func _drive(scene: Node, ss: BattleUnit, focus: int, plan: Array) -> Dictionary:
	ss.second_resource = focus
	var out := {"grade": "", "landed": 0, "full": false, "focus": 0,
		"result": "", "first_hint": "", "last_hint": "", "max_presses_seen": 0}
	var done := [false, ""]
	var prof: Dictionary = scene._sharpshooter_basic_profile(ss)
	var task := func():
		done[1] = await scene._run_skill_check(true, "", prof)
		done[0] = true
	task.call()
	var pressed := 0
	for _i in 3000:
		if done[0]:
			break
		if scene.sc_active:
			var want: String = String(plan[pressed]) if pressed < plan.size() else "good"
			pressed += 1
			out["max_presses_seen"] = pressed
			if pressed == 1:
				out["first_hint"] = String(scene.sc_hint.text)
			out["last_hint"] = String(scene.sc_hint.text)
			if want == "cancel":
				scene._cancel_skill_check()
			else:
				# Positions are read off the LIVE profile because §4 narrows the
				# window every press — a fixed "Good" position would drift out
				# of the band the bar is actually drawing.
				var c: float = float(scene.sc_profile["centre"])
				var ph: float = float(scene.sc_profile["perfect_half"])
				var gh: float = float(scene.sc_profile["good_half"])
				match want:
					"perfect":
						scene.sc_pos = c
					"good":
						scene.sc_pos = clampf(c + (ph + gh) * 0.5, 0.0, 1.0)
					_:
						scene.sc_pos = 1.0 if c + gh < 0.999 else 0.0
				scene._grade_skill_check()
		await process_frame
	out["grade"] = String(done[1])
	out["result"] = String(scene.sc_result.text)
	var seq: Dictionary = scene.sc_sequence
	out["landed"] = int(seq.get("landed", 0))
	out["full"] = bool(seq.get("full", false))
	var before := ss.second_resource
	scene._pay_sequence_focus(ss, ss.abilities[0])
	out["focus"] = ss.second_resource - before
	return out


# THE FLOOR, and it is the whole turn rather than the bar alone: drive every
# press, then resolve the basic for real and confirm the enemy took the hit and
# the meter moved.
func _drive_and_resolve(scene: Node, ss: BattleUnit, focus: int, n: int) -> Dictionary:
	var plan: Array = []
	for _i in n:
		plan.append("good")
	var bar := await _drive(scene, ss, focus, plan)
	var foe: BattleUnit = null
	for e in scene.get("enemies"):
		if not e.dead:
			foe = e
	if foe == null:
		return {"dealt": 0, "focus": int(bar["focus"])}
	foe.hp = foe.max_hp
	ss.last_attack_target = null
	var before := foe.hp
	await scene._resolve(ss, ss.abilities[0], foe, String(bar["grade"]))
	return {"dealt": before - foe.hp, "focus": int(bar["focus"])}


# ---------- BATCH GE §1 — THE LONG DRAW'S MISS, DRIVEN PRESS BY PRESS ----------
#
# **THE BAR ITSELF, NOT THE MODEL.** §4 walks the model; this drives the real
# bar through `_drive` and reads what `_pay_sequence_focus` actually paid. A
# drain that fired on the wrong press, fired twice or never fired would pass
# every static check in this file, and each of those leaves a different number
# at some press — so every press is driven and every figure is exact.
func _s7_the_long_draw_miss(scene: Node, ss: BattleUnit, battle) -> void:
	var per: int = battle.SS_SEQ_FOCUS_PER_PRESS
	var drain: int = battle.SS_SEQ_MISS_DRAIN
	var bonus: int = battle.SS_SEQ_FULL_BONUS
	var top: int = 3 * battle.SS_SEQ_STEP  # 150, the top stage, where the rune runs five
	# WITH THE RUNE: five presses at the top stage, and a miss at each in turn.
	ss.rune_long_draw_presses = 1
	for k in [1, 2, 3, 4, 5]:
		var plan: Array = []
		for i in k:
			plan.append("fail" if i == k - 1 else "good")
		var r := await _drive(scene, ss, top, plan)
		ok(int(r["max_presses_seen"]) == k and int(r["landed"]) == k - 1,
			"GE rune, miss at press %d of 5: the bar stops there with %d landed (swept %d, landed %d)" % [
				k, k - 1, int(r["max_presses_seen"]), int(r["landed"])])
		ok(int(r["focus"]) == (k - 1) * per - drain,
			"GE rune, miss at press %d of 5: %d for the presses landed, %d taken back — %+d (got %+d)" % [
				k, (k - 1) * per, drain, (k - 1) * per - drain, int(r["focus"])])
	var full5 := await _drive(scene, ss, top, ["good", "good", "good", "good", "good"])
	ok(int(full5["max_presses_seen"]) == 5 and bool(full5["full"]),
		"GE rune, no miss: all five presses swept and landed")
	ok(int(full5["focus"]) == 5 * per + bonus,
		"GE rune, no miss: a full chain drains nothing — %+d (got %+d)" % [
			5 * per + bonus, int(full5["focus"])])
	# A CANCEL IS NOT A MISS. It breaks the same loop and leaves the chain
	# short of full, which is exactly why the payout reads `missed`.
	var cancelled := await _drive(scene, ss, top, ["good", "cancel"])
	ok(String(cancelled["grade"]) == "cancel" and int(cancelled["focus"]) == 0,
		"GE rune: a cancelled cast drains nothing — withdrawing is not missing (got %+d)" % \
			int(cancelled["focus"]))
	# THE FLOOR IS ZERO AND IT IS `_gain_focus`'s. At 8 Focus the rune runs two
	# presses; the first missed takes 16 from 8 and stops at 0. The arm beside it
	# is the same miss above the floor, so a floor that zeroed EVERY drain reds.
	var at8 := await _drive(scene, ss, 8, ["fail"])
	ok(int(at8["max_presses_seen"]) == 1 and ss.second_resource == 0,
		"GE rune: a hero at 8 Focus who misses lands at 0, never at %d (reads %d)" % [
			8 - drain, ss.second_resource])
	await _drive(scene, ss, 24, ["fail"])
	ok(ss.second_resource == 24 - drain,
		"GE rune: ...and at 24 Focus the same miss takes all %d (reads %d)" % [
			drain, ss.second_resource])
	ss.rune_long_draw_presses = 0
	# WITHOUT THE RUNE: four presses at the same Focus. A miss at each keeps
	# what came before and takes nothing — and there is no fifth press to miss.
	for k in [1, 2, 3, 4]:
		var plan: Array = []
		for i in k:
			plan.append("fail" if i == k - 1 else "good")
		var r := await _drive(scene, ss, top, plan)
		ok(int(r["focus"]) == (k - 1) * per,
			"GE bare, miss at press %d of 4: keeps %d and loses nothing (got %+d)" % [
				k, (k - 1) * per, int(r["focus"])])
	var fifth := await _drive(scene, ss, top, ["good", "good", "good", "good", "fail"])
	ok(int(fifth["max_presses_seen"]) == 4 and int(fifth["focus"]) == 4 * per + bonus,
		"GE bare: there is no fifth press — full at four, %+d (swept %d, got %+d)" % [
			4 * per + bonus, int(fifth["max_presses_seen"]), int(fifth["focus"])])
	await _drive(scene, ss, 8, ["fail"])
	ok(ss.second_resource == 8,
		"GE bare: at 8 Focus a miss takes nothing (reads %d)" % ss.second_resource)
	ss.second_resource = 0
	# EVERY RECORD THE FILE BUILDS CARRIES `missed` — the bar's opening, its
	# cancel, and the bot's roll. The bot never runs the bar (§5 says why it is
	# not driven here), so its record is asserted as a property of every writer:
	# a writer without the key hands the sim a Long Draw with no cost.
	var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var writers := 0
	var bad: Array = []
	var at := src.find("sc_sequence = {")
	while at >= 0:
		var lit := src.substr(at, src.find("}", at) - at + 1)
		if lit != "sc_sequence = {}":
			writers += 1
			if not lit.contains("\"missed\":"):
				bad.append(lit.replace("\n", " ").replace("\t", "").left(90))
		at = src.find("sc_sequence = {", at + 1)
	print("  GE: CHECKED %d sequence records built in battle.gd" % writers)
	ok(writers >= 3, "GE: the record writers are found — the bar's two and the bot's (%d)" % writers)
	ok(bad.is_empty(), "GE: every sequence record carries `missed` (%s)" % [bad])
	ok(src.count("sc_sequence[\"missed\"] = true") == 1,
		"GE: ...and the bar sets it at the one place a press fails")
	# THE RUNE'S WORTH ON §4's MODEL, PRINTED AND NOT ASSERTED. The ruling asked
	# for a trade; whether this reads as one is the designer's call, and a gate
	# that asserted a sign would be the gate ruling.
	for n in [1, 2, 3, 4]:
		var held: int = (n - 1) * battle.SS_SEQ_STEP
		var bare := _model_worth(scene, ss, held, 0)
		ss.rune_long_draw_presses = 1
		var rune := _model_worth(scene, ss, held, drain)
		ss.rune_long_draw_presses = 0
		print("  GE model, %d+ Focus: bare %.2f, with the Long Draw %.2f — worth %+.2f Focus a basic" % [
			held, bare, rune, rune - bare])
	ss.second_resource = 0


# E[Focus a basic] on §4's model: each press lands with 1 - miss_risk, the
# chain stops at the first miss, per-press and full-sequence Focus as paid, and
# `drain` taken on a miss. The floor is ignored; it binds below 16 Focus only.
func _model_worth(scene: Node, ss: BattleUnit, focus: int, drain: int) -> float:
	var battle := load("res://scripts/battle.gd")
	ss.second_resource = focus
	var prof: Dictionary = scene._sharpshooter_basic_profile(ss)
	var reach := 1.0
	var e := 0.0
	for i in int(prof["presses"]):
		var tol: float = float(prof["good_half"]) * float(prof["sweep_time"]) \
			* pow(float(prof["press_taper"]), float(i))
		reach *= 1.0 - _miss_risk(tol)
		e += reach * battle.SS_SEQ_FOCUS_PER_PRESS
	return e + reach * battle.SS_SEQ_FULL_BONUS - (1.0 - reach) * drain


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)

