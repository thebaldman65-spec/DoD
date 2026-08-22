# BATCH CM — the LIVE-PATH gate for §2, and it exists because the sims cannot
# reach this code. Every headless battle takes `_defensive_brace`'s bot branch,
# so the bar itself — the one thing a player actually touches — is exercised
# nowhere else. This spawns a real non-autoplay battle with a Warden, drives an
# enemy attack into him, presses the bar by hand, and measures.
#
# It runs a SCENE-less --script SceneTree, so it parks on the first
# process_frame the way test_batch_ce does (autoloads are not in the tree during
# _initialize).
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cm_live.gd
extends SceneTree

# BATCH DB — the battle fixture and the tally are authored ONCE, in
# `gate_fixture.gd`. This gate had its own copy of both until this batch.
const Gate = preload("res://gate_fixture.gd")

const SAMPLES := 40

var _g := Gate.new()


# BATCH DB — the tally is the fixture's. This delegates rather than
# re-implements: FOUR gates' copies of this never counted a check at all.
func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260817)
	# Determinism forced (the AK/AL/AR discipline) and NO Profile flags —
	# CQ §1 removed them from this copy first, and DB removed the other five.
	var scene: Node = await Gate.spawn(self,
		["warden", "pyromancer", "holy", "beastmaster"], {"deterministic": true})
	var warden: BattleUnit = null
	var other: BattleUnit = null
	for h in scene.get("heroes"):
		if h.is_companion:
			continue
		if String(h.passive_id) == "heavy_plating":
			warden = h
		elif other == null:
			other = h
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(warden != null, "the party has a Warden")
	ok(other != null, "the party has a hero who is not the Warden")
	if warden == null or other == null:
		_report()
		return

	# Who qualifies, decided by the one function that decides it.
	ok(scene._has_defensive_check(warden), "the Warden qualifies")
	ok(not scene._has_defensive_check(other), "a non-defensive hero does not")
	ok(not scene._has_defensive_check(foe), "an enemy does not")

	# The bar appears, says the right thing, and carries NO Cancel button.
	var seen := await _attack(scene, foe, warden, true)
	ok(bool(seen["bar"]), "the bar appeared on the enemy's attack")
	ok(String(seen["hint"]).contains("INCOMING"),
		"the bar's top line names the incoming blow (was: %s)" % seen["hint"])
	ok(bool(seen["no_cancel"]), "no Cancel button — a hero cannot decline to be attacked")

	# ...and it does NOT appear for anybody else.
	var none := await _attack(scene, foe, other, true)
	ok(not bool(none["bar"]), "no bar when the blow is aimed at another hero")

	# The measurement: the same attack, N times each, INTERLEAVED. Heavy
	# Plating's block climbs +8% per unblocked hit and a block throws the whole
	# climb away, so two blocks of forty hits are not comparable samples — the
	# second inherits the first's ramp. Alternating cancels it, and the roll is
	# neutralised outright below besides.
	var braced := 0.0
	var plain := 0.0
	var braced_bd := 0.0
	var plain_bd := 0.0
	for _i in SAMPLES:
		var b: Dictionary = await _attack(scene, foe, warden, true)
		var p: Dictionary = await _attack(scene, foe, warden, false)
		braced += float(b["lost"])
		plain += float(p["lost"])
		braced_bd += float(b["bd"])
		plain_bd += float(p["bd"])
	var ratio: float = braced / maxf(plain, 1.0)
	print("  damage taken: braced %.0f | unbraced %.0f | ratio %.3f (want ~%.2f)" % [
		braced, plain, ratio, scene.DEF_PERFECT_DMG])
	ok(braced < plain, "a Perfect brace takes less damage than no brace")
	ok(absf(ratio - scene.DEF_PERFECT_DMG) < 0.06,
		"the brace lands near x%.2f" % scene.DEF_PERFECT_DMG)
	# The Break half. It carries no variance band at all, so it is asserted
	# tightly — an integer round is the only thing between it and exact.
	var bd_ratio: float = braced_bd / maxf(plain_bd, 1.0)
	print("  Break taken:  braced %.0f | unbraced %.0f | ratio %.3f (want ~%.2f)" % [
		braced_bd, plain_bd, bd_ratio, scene.DEF_PERFECT_BD])
	ok(absf(bd_ratio - scene.DEF_PERFECT_BD) < 0.02,
		"the brace's Break half lands near x%.2f" % scene.DEF_PERFECT_BD)

	# §2's central promise, driven rather than asserted: SLOPPY IS IDENTICAL TO
	# GOOD. The "unbraced" sample above is a Sloppy press; this repeats it at a
	# GOOD press and the two must be statistically the same blow.
	var good := 0.0
	for _i in SAMPLES:
		good += float((await _attack(scene, foe, warden, false, 0.6))["lost"])
	print("  Sloppy %.0f vs Good %.0f over %d each" % [plain, good, SAMPLES])
	ok(absf(good / maxf(plain, 1.0) - 1.0) < 0.06,
		"Sloppy and Good take the same blow — the check can only ever help")
	_report()


# BATCH DB — one shape for every gate: `NAME: N checks / M failures`.
func _report() -> void:
	_g.report(self)


func _attack(scene: Node, foe: BattleUnit, victim: BattleUnit,
		perfect: bool, press := -1.0) -> Dictionary:
	var ab: Ability = foe.abilities[0]
	victim.hp = victim.max_hp
	victim.pressure = 0
	victim.broken = false
	victim.broken_pending = false
	victim.refresh_bars()
	var before := victim.hp
	var out := {"bar": false, "hint": "", "no_cancel": true, "lost": 0, "bd": 0}
	var done := [false]
	var task := func():
		await scene._resolve(foe, ab, victim, "good")
		done[0] = true
	task.call()
	for _i in 400:
		if done[0]:
			break
		if scene.sc_active:
			out["bar"] = true
			out["hint"] = String(scene.sc_hint.text)
			out["no_cancel"] = scene.sc_cancel == null
			# `press` overrides the cursor position when a caller wants a
			# specific grade that is neither dead centre nor the far end — the
			# GOOD press at 0.6 (inside GOOD_HALF 0.16, outside PERFECT_HALF).
			scene.sc_pos = press if press >= 0.0 else (0.5 if perfect else 0.99)
			scene._grade_skill_check()
		await process_frame
	out["lost"] = before - victim.hp
	out["bd"] = victim.pressure
	return out

