# test_batch_bg.gd — APOSTLE MOVES OFF THE FREQUENCY AXIS. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bg.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# ONE NODE, RE-SPECCED. The capstone used to park an ally at five Faith so
# every further gain re-triggered the release; BF measured that at −8 points
# one-hero and −2 all four AFTER the Communion repair — taking the capstone
# LOWERED the engine it sits on. It now doubles what a HELD stack is worth
# instead: 6% mitigation and +4% damage dealt per stack, against 3% and +2%.
#
# THE TWO NEGATIVE CONTROLS THIS SUITE EXISTS FOR, both of which would fail
# silently — the sim would print a plausible row either way:
#   · APOSTLE STILL PRESERVING STACKS ON RELEASE. If the old branch survives
#     anywhere, the batch has ADDED a lever to the frequency axis rather than
#     moved off it, and the row would climb for the wrong reason.
#   · THE DOUBLED VALUES READING THE DEVOUT'S OWN STACKS rather than the
#     carrier's. The obvious mis-write is `devout.faith_stacks`, and it would
#     leave allies at their undoubled 3%/+2% while every source-level check
#     below still passed.
#
# The two per-stack rates are MEASURED end to end — total damage landed at four
# stacks against total damage landed at zero — not read off the expression. A
# test that re-derives the formula it checks proves nothing. Damage carries a
# uniform ±10% roll, so every rate is a SUM over `HITS` casts (CLAUDE.md's
# standing trap: even with crit suppressed, one cast passes a wrong curve).
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# §2's design numbers, in one place.
const BASE_MITIGATION := 3      # % per stack
const BASE_DAMAGE := 2          # % per stack
const APOSTLE_MULT := 2
const STACKS := 4               # the deepest an ally can CARRY — five releases
# Casts per measured rate. Damage rolls uniform ±10% (SD 5.8% of the mean), so
# a 400-cast sum has an SE of 0.29% and a ratio of two sums 0.41%. The bands
# asserted below are ±2 points, ~5 sigma — they cannot flap.
const HITS := 400
# ±3 points, which is ~5 sigma on the 0.6-point spread the four rates actually
# showed at this n (wider than the roll alone predicts, so it is taken from the
# measurement rather than from the arithmetic). It still cannot confuse the two
# arms: they are 8 points apart, and a 3%-became-4% slip would be 4 points.
const BAND := 0.03
# Communion's rate at four stacks, the BF figure this batch must not disturb.
const RATE_AT_FOUR := 0.60
const TRIALS := 600

var checks := 0
var fails: Array = []
# A live check that THROWS mid-way aborts its own function while the suite
# still prints "0 failures" — the CLAUDE.md trap that fakes a clean pass. Every
# live function bumps this on its LAST line, and the count is asserted.
var _live_ran := 0
const LIVE_CHECKS := 6
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
var _report: Array = []


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bg_test.json"
	Profile.loaded = false
	Profile.data = {}

	# source-level: the shape of the re-spec
	_the_capstone_describes_the_held_half()
	_the_release_branch_no_longer_names_the_capstone()
	_one_multiplier_one_gate()
	_the_chip_and_the_passive_name_the_doubling()

	await _live_mitigation_doubles()
	await _live_damage_dealt_doubles()
	await _live_release_still_consumes()
	await _live_the_chip_states_the_doubled_numbers()
	await _live_communion_still_rolls_for_the_carrier()
	await _live_the_doubling_follows_the_carrier_not_the_devout()
	ok(_live_ran == LIVE_CHECKS,
		"all %d live checks ran to the end (%d did)" % [LIVE_CHECKS, _live_ran])

	if FileAccess.file_exists("user://profile_batch_bg_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bg_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_bg: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _src(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	return "" if f == null else f.get_as_text()


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(Talents.LANE_TREES["inquisitor"], id)


func _devout(scene: Node) -> BattleUnit:
	return scene.call("_living_devout")


# One spawn for every live check. `learned` lands on the Cleric slot, which is
# where the Devout stands. Every roll that could move a damage figure is armed
# off here: no_cover bypasses the miss roll outright, parry/block go to zero,
# and crit_bonus at −10 puts the crit chance below zero on both sides.
func _spawn(learned := {}) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 2 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.slot_idx = 0
	run.combat_wins = 0
	run.pending_modifier = ""
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
		u.healing_received_mult = 1.0
	# `_stat` only banks into sim_stats while `sim` is true.
	scene.set("sim", true)
	scene.get("sim_stats").clear()
	scene.get("_b_slice").clear()
	scene.get("_b_bd_slice").clear()
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


func _stat_of(scene: Node, key: String) -> float:
	return float(scene.get("sim_stats").get(key, 0.0))


# Everything that could differ between the two arms of a ratio, reset to the
# same value before every single cast: hit points (the Berserker's own damage
# reads his missing health), the secondary meter (Resonance compounds), and
# every status either side might have picked up. Whatever constant factor is
# left applies to BOTH arms and cancels in the ratio, which is the whole reason
# the measurement does not need to know what it is.
func _neutral(scene: Node) -> void:
	for u in scene.get("heroes") + scene.get("enemies"):
		u.hp = u.max_hp
		u.second_resource = 0
		u.faith_stacks = 0
		u.remove_status("faith")
		u.purge_debuffs()


# Total damage the carrier LANDS over HITS casts, holding `stacks` of Faith.
func _damage_dealt(scene: Node, carrier: BattleUnit, stacks: int) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 9_000_000
	var key := "dmg_hero_" + carrier.unit_name
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		foe.hp = foe.max_hp
		carrier.faith_stacks = stacks
		await scene.call("_resolve", carrier, carrier.abilities[0], foe, "good")
	return _stat_of(scene, key)


# Total damage the carrier TAKES over HITS enemy casts, holding `stacks`.
# Counted as health actually lost, because the enemy's output is not banked
# per-hero anywhere and health lost is what "takes 24% less damage" means.
func _damage_taken(scene: Node, carrier: BattleUnit, stacks: int) -> float:
	var foe: BattleUnit = scene.get("enemies")[0]
	var ab = scene.call("_cheapest_attack", foe)
	carrier.max_hp = 9_000_000
	var total := 0.0
	for _i in HITS:
		_neutral(scene)
		carrier.hp = carrier.max_hp
		carrier.faith_stacks = stacks
		await scene.call("_resolve", foe, ab, carrier, "good")
		total += float(carrier.max_hp - carrier.hp)
	return total


# ---------- source-level: the shape of the re-spec ----------

# THE NODE'S OWN TEXT IS THE SPEC. A capstone whose description still promises
# the old behaviour is a bug report from every player who takes it.
func _the_capstone_describes_the_held_half() -> void:
	var n := _node("dv_apostle")
	ok(not n.is_empty(), "§2: dv_apostle is still in the Faith lane at row 8")
	var d: String = String(n.get("desc", ""))
	ok(d.contains("%d%%" % (BASE_MITIGATION * APOSTLE_MULT)),
		"§2: the capstone states 6% mitigation per stack")
	ok(d.contains("+%d%%" % (BASE_DAMAGE * APOSTLE_MULT)),
		"§2: ...and +4% damage dealt per stack")
	ok(not d.to_lower().contains("no longer consume"),
		"§2: ...and it no longer promises releases that consume nothing")
	# The id, the lane and the payload field all survive, so no save migrates.
	ok(String(n.get("lane", "")) == "Faith" and int(n.get("row", 0)) == 8,
		"§2: id, lane and row are unchanged — no save version moves")
	ok(n.get("payload", {}).get("stat", {}).has("apostle"),
		"§2: ...and the payload still writes the same `apostle` field")


# THE NEGATIVE CONTROL THAT MATTERS, at the source. The old behaviour lived in
# ONE branch of the release, and a re-spec that left it standing anywhere would
# have added a fourth frequency lever rather than moved off the axis.
func _the_release_branch_no_longer_names_the_capstone() -> void:
	var src := _src("res://scripts/battle.gd")
	var i := src.find("func _gain_faith(")
	ok(i > 0, "§2: _gain_faith is findable")
	var body := src.substr(i, src.find("func _conviction_growth(") - i)
	var keep := body.find("var keep := 0")
	var after := body.substr(keep, body.find("u.faith_stacks = keep") - keep)
	ok(not after.contains("apostle"),
		"§2: nothing between `var keep` and its use reads `apostle` — the park is gone")
	ok(after.contains("oath_ranks"),
		"§2: ...and Binding Oath is the only thing left that keeps a remnant")
	# Belt and braces: `keep = 5` is what the old branch wrote.
	ok(not body.contains("keep = 5"),
		"§2: no branch of the release keeps all five stacks")


# ONE MULTIPLIER, ONE GATE, THREE CALLERS. A second read of `apostle` in an
# arithmetic site is how the chip and the damage drift apart — the tooltip
# would describe a number the code does not use, and nothing would crash.
func _one_multiplier_one_gate() -> void:
	var src := _src("res://scripts/battle.gd")
	ok(src.contains("func _faith_stack_mult("),
		"§2: the per-stack multiplier has one home")
	ok(src.count(".apostle") == 1,
		"§2: the `apostle` field is read in exactly ONE place (found %d)" % \
			src.count(".apostle"))
	ok(src.count("_faith_stack_mult(") == 4,
		"§2: one definition and three callers — two damage sites and the chip (found %d)" % \
			src.count("_faith_stack_mult("))
	# The base rates are constants, not literals scattered across the sites.
	ok(src.contains("const FAITH_MITIGATION_PCT := %d" % BASE_MITIGATION)
			and src.contains("const FAITH_DAMAGE_PCT := %d" % BASE_DAMAGE),
		"§2: the two base rates are named constants")
	ok(not src.contains("0.03 * strike_target.faith_stacks")
			and not src.contains("0.02 * attacker.faith_stacks"),
		"§2: ...and neither damage site still carries a hard-coded rate")


# The two places a player reads the per-stack pair OUTSIDE a live chip: the
# status glossary default and the spec screen's passive block. Both name the
# doubling for the same reason the Communion cliff had to be stated — a value
# that silently changes when a capstone is learned reads as a bug.
func _the_chip_and_the_passive_name_the_doubling() -> void:
	var bsrc := _src("res://scripts/battle.gd")
	var i := bsrc.find("\"faith\": [\"Faith\"")
	ok(i > 0, "§2: the Faith status default is findable")
	var chip := bsrc.substr(i, 260)
	ok(chip.contains("Apostle"),
		"§2: the Faith status default names Apostle as the doubler")
	var csrc := _src("res://scripts/classes.gd")
	var j := csrc.find("\"passive_desc\": \"Conviction:")
	ok(j > 0, "§2: the Devout's passive block is findable")
	ok(csrc.substr(j, 400).contains("doubled by Apostle"),
		"§2: ...and the passive block names it too")


# ---------- live: the two rates, measured end to end ----------

# 24% LESS DAMAGE AT FOUR STACKS UNDER APOSTLE, 12% WITHOUT IT. Measured as
# health actually lost against the same party holding no Faith at all, so the
# figure is the one the node's text promises rather than a re-derivation of
# the expression that produces it.
func _live_mitigation_doubles() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(_devout(scene) != null, "§2: the Devout stands (the stacks do nothing if not)")
	var bare := await _damage_taken(scene, ally, 0)
	var plain := await _damage_taken(scene, ally, STACKS)
	await _kill(scene)

	scene = await _spawn({"dv_apostle": 1})
	var dv := _devout(scene)
	ok(dv != null and dv.apostle > 0, "§2: Apostle is learned")
	ally = scene.get("heroes")[0]
	var bare_ap := await _damage_taken(scene, ally, 0)
	var doubled := await _damage_taken(scene, ally, STACKS)
	await _kill(scene)

	var want_plain := 1.0 - 0.01 * BASE_MITIGATION * STACKS
	var want_ap := 1.0 - 0.01 * BASE_MITIGATION * APOSTLE_MULT * STACKS
	var got_plain := plain / maxf(bare, 1.0)
	var got_ap := doubled / maxf(bare_ap, 1.0)
	ok(absf(got_plain - want_plain) < BAND,
		"§2: four stacks WITHOUT Apostle take %.0f%% less damage (read %.1f%%)" % [
			100.0 * (1.0 - want_plain), 100.0 * (1.0 - got_plain)])
	ok(absf(got_ap - want_ap) < BAND,
		"§2: four stacks WITH Apostle take %.0f%% less (read %.1f%%)" % [
			100.0 * (1.0 - want_ap), 100.0 * (1.0 - got_ap)])
	_report.append("mitigation at 4 stacks over %d hits: plain %.1f%% less | Apostle %.1f%% less (want 12 / 24)" % [
		HITS, 100.0 * (1.0 - got_plain), 100.0 * (1.0 - got_ap)])
	_live_ran += 1


# +16% DAMAGE DEALT AT FOUR STACKS UNDER APOSTLE, +8% WITHOUT IT. The half of
# the capstone that lands on the ALLY and counts to the ALLY — which is why the
# Devout's own share can barely move while the node becomes worth taking.
func _live_damage_dealt_doubles() -> void:
	var scene := await _spawn()
	var ally: BattleUnit = scene.get("heroes")[0]
	var bare := await _damage_dealt(scene, ally, 0)
	var plain := await _damage_dealt(scene, ally, STACKS)
	await _kill(scene)

	scene = await _spawn({"dv_apostle": 1})
	ally = scene.get("heroes")[0]
	var bare_ap := await _damage_dealt(scene, ally, 0)
	var doubled := await _damage_dealt(scene, ally, STACKS)
	await _kill(scene)

	ok(bare > 0.0 and bare_ap > 0.0, "§2: the control arms landed damage to divide by")
	var want_plain := 1.0 + 0.01 * BASE_DAMAGE * STACKS
	var want_ap := 1.0 + 0.01 * BASE_DAMAGE * APOSTLE_MULT * STACKS
	var got_plain := plain / maxf(bare, 1.0)
	var got_ap := doubled / maxf(bare_ap, 1.0)
	ok(absf(got_plain - want_plain) < BAND,
		"§2: four stacks WITHOUT Apostle deal +%.0f%% (read +%.1f%%)" % [
			100.0 * (want_plain - 1.0), 100.0 * (got_plain - 1.0)])
	ok(absf(got_ap - want_ap) < BAND,
		"§2: four stacks WITH Apostle deal +%.0f%% (read +%.1f%%)" % [
			100.0 * (want_ap - 1.0), 100.0 * (got_ap - 1.0)])
	_report.append("damage dealt at 4 stacks over %d casts: plain +%.1f%% | Apostle +%.1f%% (want 8 / 16)" % [
		HITS, 100.0 * (got_plain - 1.0), 100.0 * (got_ap - 1.0)])
	_live_ran += 1


# ---------- live: the negative controls ----------

# THE OLD BEHAVIOUR MUST BE GONE. Under the previous capstone an ally reaching
# five STAYED at five and every further gain re-triggered the release; the row
# BF measured is the row that produced. A release under Apostle now consumes
# the stacks exactly as it does without it.
func _live_release_still_consumes() -> void:
	var scene := await _spawn({"dv_apostle": 1})
	var dv := _devout(scene)
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(dv != null and dv.apostle > 0, "§2: Apostle is learned")
	ally.faith_stacks = 0
	ally.hp = maxi(ally.max_hp / 2, 1)
	scene.get("sim_stats").clear()
	scene.call("_gain_faith", ally, 5)
	ok(ally.faith_stacks == 0,
		"§2: a release under Apostle RESETS the ally (left at %d)" % ally.faith_stacks)
	ok(ally.faith_stacks != 5,
		"§2: NEGATIVE CONTROL — the ally is not parked at five")
	ok(not ally.has_status("faith"),
		"§2: ...and the chip is gone with the stacks")
	ok(_stat_of(scene, "faith_releases") == 1.0,
		"§2: one release banked, not a stream (%.0f)" % _stat_of(scene, "faith_releases"))
	# And the stream itself: under the old node, five further gains meant five
	# further releases. Now they rebuild from zero and pay once.
	scene.get("sim_stats").clear()
	for _i in 5:
		scene.call("_gain_faith", ally, 1)
	ok(_stat_of(scene, "faith_releases") == 1.0,
		"§2: five single gains from zero pay ONE release, not five (%.0f)" % \
			_stat_of(scene, "faith_releases"))
	# Binding Oath is untouched and is now the only remnant in the game.
	await _kill(scene)
	scene = await _spawn({"dv_apostle": 1, "dv_oath": 1})
	ally = scene.get("heroes")[0]
	ally.faith_stacks = 0
	scene.call("_gain_faith", ally, 5)
	ok(ally.faith_stacks == 3,
		"§2: Binding Oath still keeps its 3, capstone or no (left at %d)" % ally.faith_stacks)
	_report.append("release under Apostle leaves %d stacks (was 5); with Binding Oath, 3" % 0)
	await _kill(scene)
	_live_ran += 1


# THE CHIP MUST SAY WHAT THE ARITHMETIC DOES. A tooltip built from the base
# rates while the damage used the doubled ones would be invisible in every
# report and obvious to the first player who took the node.
func _live_the_chip_states_the_doubled_numbers() -> void:
	var scene := await _spawn({"dv_apostle": 1})
	var ally: BattleUnit = scene.get("heroes")[0]
	ally.faith_stacks = 0
	scene.call("_gain_faith", ally, STACKS)
	var s: Dictionary = ally.get_status("faith")
	var desc := String(s.get("desc", ""))
	ok(desc.contains("%d%% damage" % (BASE_MITIGATION * APOSTLE_MULT * STACKS)),
		"§2: the chip at four stacks reads 24%% mitigation (got \"%s\")" % desc)
	ok(desc.contains("+%d%% damage dealt" % (BASE_DAMAGE * APOSTLE_MULT * STACKS)),
		"§2: ...and +16%% damage dealt")
	ok(String(s.get("short", "")) == "F%d" % STACKS,
		"§2: ...and the visible text is still the stack count")
	await _kill(scene)
	# The same chip without the capstone, which is the control.
	scene = await _spawn()
	ally = scene.get("heroes")[0]
	ally.faith_stacks = 0
	scene.call("_gain_faith", ally, STACKS)
	desc = String(ally.get_status("faith").get("desc", ""))
	ok(desc.contains("%d%% damage" % (BASE_MITIGATION * STACKS)),
		"§2: without Apostle the same chip reads 12%% (got \"%s\")" % desc)
	await _kill(scene)
	_live_ran += 1


# COMMUNION STILL ROLLS FOR THE CARRIER, and this is where the two nodes stop
# cancelling. BF's condition skips an ally already at five; under the OLD
# capstone that was every ally, all the time. Now a release drops the carrier
# back into the 1-4 band that Communion pays for — both nodes want the same
# thing.
func _live_communion_still_rolls_for_the_carrier() -> void:
	var scene := await _spawn({"dv_communion": 1, "dv_apostle": 1})
	var dv := _devout(scene)
	var heroes: Array = scene.get("heroes")
	var war: BattleUnit = heroes[0]
	var ally: BattleUnit = heroes[1]
	ok(dv != null and dv.apostle > 0 and dv.communion_ranks > 0,
		"§2: both nodes are learned")
	# THE DISCRIMINATING STEP: put the ally THROUGH a release and confirm he
	# comes out eligible. Under the old capstone he would sit at five and
	# Communion would skip him forever after.
	ally.faith_stacks = 0
	scene.call("_gain_faith", ally, 5)
	ok(ally.faith_stacks < 5,
		"§2: an ally who has released is below five again (at %d)" % ally.faith_stacks)
	var fired := 0
	for _i in TRIALS:
		for h in heroes:
			h.faith_stacks = 0
			h.remove_status("faith")
			h.hp = h.max_hp
		ally.faith_stacks = STACKS
		var before := _stat_of(scene, "faith_releases")
		war.faith_stacks = 0
		scene.call("_gain_faith", war, 5)
		# The advance takes the ally to five, which RELEASES — so the release
		# counter is the only honest witness at four stacks (BF's rule).
		if _stat_of(scene, "faith_releases") - before >= 2.0:
			fired += 1
	var rate := float(fired) / float(TRIALS)
	ok(absf(rate - RATE_AT_FOUR) < 0.06,
		"§2: Communion still rolls %d%% for a carrier at four (read %.1f%%)" % [
			int(100.0 * RATE_AT_FOUR), 100.0 * rate])
	_report.append("Communion at 4 stacks WITH the new Apostle: %.1f%% over %d trials (BF read 58.8%% without it)" % [
		100.0 * rate, TRIALS])
	await _kill(scene)
	_live_ran += 1


# THE SECOND NEGATIVE CONTROL. The obvious mis-write is to read the DEVOUT's
# own stacks instead of the carrier's — the capstone is his, after all. It
# would leave every ally on the undoubled rate while `_faith_stack_mult`, the
# constants and the chip all still looked right. Both directions are asserted:
# the ally is paid on HIS OWN stacks with the Devout empty, and paid NOTHING
# when the stacks are all on the Devout.
func _live_the_doubling_follows_the_carrier_not_the_devout() -> void:
	var scene := await _spawn({"dv_apostle": 1})
	var dv := _devout(scene)
	var ally: BattleUnit = scene.get("heroes")[0]
	ok(dv != null, "§2: the Devout stands")

	var bare := await _damage_dealt(scene, ally, 0)
	# Arm 1 — the ally carries four, the Devout carries none.
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		foe.hp = foe.max_hp
		ally.faith_stacks = STACKS
		dv.faith_stacks = 0
		await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	var carried := _stat_of(scene, "dmg_hero_" + ally.unit_name)
	# Arm 2 — the stacks are all on the Devout and the ally holds none.
	scene.get("sim_stats").clear()
	for _i in HITS:
		_neutral(scene)
		foe.hp = foe.max_hp
		ally.faith_stacks = 0
		dv.faith_stacks = STACKS
		await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	var lent := _stat_of(scene, "dmg_hero_" + ally.unit_name)

	var want := 1.0 + 0.01 * BASE_DAMAGE * APOSTLE_MULT * STACKS
	ok(absf(carried / maxf(bare, 1.0) - want) < BAND,
		"§2: the ally is paid on HIS OWN stacks with the Devout empty (+%.1f%%, want +16%%)" % \
			(100.0 * (carried / maxf(bare, 1.0) - 1.0)))
	ok(absf(lent / maxf(bare, 1.0) - 1.0) < BAND,
		"§2: NEGATIVE CONTROL — stacks on the DEVOUT pay the ally nothing (%.1f%%)" % \
			(100.0 * (lent / maxf(bare, 1.0) - 1.0)))
	_report.append("carrier-keyed check: ally +%.1f%% on his own four | +%.1f%% on the Devout's four (want 16 / 0)" % [
		100.0 * (carried / maxf(bare, 1.0) - 1.0),
		100.0 * (lent / maxf(bare, 1.0) - 1.0)])
	await _kill(scene)
	_live_ran += 1
