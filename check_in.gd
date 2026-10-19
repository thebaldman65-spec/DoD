# BATCH IN — THE SEVERITY-5 BAND, AND TWO BLIND SPOTS.
#
#   §1   FOUR BARGAINS ONLY RUIN EVER SEES. Four modifiers stand at severity 5 and Ruin's gambles are dealt from 5
#        alone (RE-POINTED AT IO: two of IN's four were removed and two re-cut to bind both sides, and the grades are IO's
#        measurement — every arm below reads IO's deck, and the two removed are asserted gone where they acted); no
#        Wanderer or Warden band reaches 5, and no band is empty or falls back. Measured at EP's sample through the real
#        roll: Wanderer and Warden dealt offer for offer as IM dealt them (a reference model of IM's roll over the
#        twenty, the merchant at 1), no severity-5 option in any of their 800 offers, Ruin a full step above Warden. The
#        reward row is one step further on the table's own growing slope; the fixed encounters keep severity 3–4. Each
#        re-cut door is DRIVEN both ways — Wasting's tick at every unit's turn's end through the tick door, the Hungering
#        Dark's feed at BL's one damage door — the two removed doors are asserted gone where they acted, and the texts
#        and the rung texts are read against the band. **RE-POINTED AGAIN AT IP**: the Hungering Dark is REMOVED (IP §1a —
#        two-sidedness did not make it even), so §1g asserts it gone where it acted, as §1e and §1h assert Famine and Cruel
#        Order; and severity 5 is the cliff, three deep (IP §1b), so the counts read 6 / 6 / 4 / 4 / 3.
#   §2   THE MERCHANT IS THE REWARD OF A RUNG's MILDEST DEALT SEVERITY: no row of the table holds it; `rewards_for` puts
#        it beside the gold of the one severity `mildest_dealt_severity` names, read off the bands and never the rung's
#        name; Wanderer's and Warden's merchants dealt as IM dealt them, Ruin's at its mildest and nowhere else, and none
#        in the run's first three nodes at any rung.
#   §3   THE BOT PAYS THE PRICE THE DOOR CHARGES: no list price is compared with a resource in `battle.gd`; under Warded,
#        every pick the bot makes at every Rage or Mana from empty to full, for every lineage, is one the door would let
#        it pay; an enemy's ability is usable only at its effective price.
#   §4   THE 34 SITES NAME THEIR PICK: each of IM's census sites that named its pick in no FAIL line, or in some, holds
#        the string that names it and every FAIL line about the pick carries it.
#   §0   §0.7's note recorded with its row; the merchant's rule in `CLAUDE.md`.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 measures the offer and drives each door on a board this gate lays out;
# what a severity-5 bargain does to a run is the sim's (IN's report, §1). §3 asks the bot's whole pick at every resource
# level on one dressed board a lineage; an arm whose board condition this board never meets is read by the census, not
# the drive. §4 reads the gates' sources; that a FAIL line prints its pick is shown by IN's controls, one per site.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_in.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §1 — IN's four, by id: [name, the constant its figure is read off ("" for none)]. RE-POINTED AT IO §1: Famine and Cruel
# Order are REMOVED (AQ's rule — a modifier that binds one side is a difficulty slider), so they are asserted gone; Wasting
# and the Dark stay, bound to both sides, at whatever grade IO's measurement gave them. RE-POINTED AT IP §1a: the Dark is
# REMOVED too (two-sidedness did not make it even), so Wasting is the one of IN's four that stands.
const FOUR := {"wasting": ["Wasting", "WASTING_PCT"]}
const REMOVED := {"famine": "Famine", "cruel_order": "Cruel Order", "hungering_dark": "The Hungering Dark"}
# §1 — the grade counts the bands are built on. IN's *no existing modifier's severity moves* (its brief §6) held for IN; IO §2
# re-graded the deck by measurement, at these counts (IO's brief §2, constraint 1) — and IP §1b cut the top at the cliff the
# measurement shows, three deep, the counts below it the table's own.
const GRADE_COUNTS := {1: 6, 2: 6, 3: 4, 4: 4, 5: 3}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IN — THE SEVERITY-5 BAND, AND TWO BLIND SPOTS")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s1a_the_table()
	_s1b_the_sample()
	_s1c_the_reward_row()
	_s1d_the_fixed_band()
	await _s1e_famine()
	await _s1f_wasting()
	await _s1g_the_hungering_dark()
	await _s1h_cruel_order()
	_s1i_the_words()
	_s2_the_merchant()
	await _s3_the_bots_price()
	_s4_the_picks_named()
	_s0_rulings()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _board(specs: Array, over: Dictionary, opts := {}) -> Node:
	var o := {"deterministic": true, "party": over}
	for k in opts:
		o[k] = opts[k]
	var s: Node = await Gate.spawn(self, specs, o)
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
	_run.pending_modifier = ""
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
	Engine.time_scale = 1.0
	await Gate.frames(self, 3)


func _hero(scene: Node, key: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if not (h as BattleUnit).is_companion and String((h as BattleUnit).hero_key) == key:
			return h
	return null


func _foes(scene: Node) -> Array:
	return (scene.get("enemies") as Array).filter(func(e): return not e.dead)


func _band_members(band: Array) -> Array:
	var out: Array = []
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		if sv >= int(band[0]) and sv <= int(band[1]):
			out.append(String(id))
	return out


func _mean_sev(ids: Array) -> float:
	var sum := 0.0
	for id in ids:
		sum += float(_run.modifier_severity(String(id)))
	return sum / maxf(float(ids.size()), 1.0)


# IM's roll — a REFERENCE MODEL of how IM dealt Wanderer's and Warden's offers: the floor's split over the TWENTY (no
# severity-5 modifier stood in IM's table), the merchant beside severity 1's gold. It is the control §1 and §2 are read
# against: a rung whose bands are the floor's own split is dealt this offer from the same dice, offer for offer.
# RE-POINTED AT IO §2: the twenty are every modifier below severity 5, whatever its grade — the re-grade moves which
# modifiers those are, never that the floor's split deals Wanderer's and Warden's offers.
func _im_offer(floor_sev: int) -> Array:
	var low: Array = []
	var rest: Array = []
	for id in _run.MODIFIERS:
		var sv := int(_run.modifier_severity(String(id)))
		if sv >= 5:
			continue
		if sv <= floor_sev:
			low.append(String(id))
		else:
			rest.append(String(id))
	low.shuffle()
	rest.shuffle()
	var picked: Array = []
	if not low.is_empty():
		picked.append(low.pop_front())
	while picked.size() < 3 and not rest.is_empty():
		picked.append(rest.pop_front())
	var offer: Array = []
	for id in picked:
		var sev := int(_run.modifier_severity(String(id)))
		var choices: Array = (_run.REWARDS.get(sev, _run.REWARDS[1]) as Array).duplicate()
		if sev == 1:
			choices.append({"kind": "shop"})
		if _run.shop_gated(int(_run.slot_idx) + 1):
			choices = choices.filter(func(r): return String(r.get("kind", "")) != "shop")
		offer.append({"modifier": String(id), "reward": (choices.pick_random() as Dictionary).duplicate()})
	offer.shuffle()
	return offer


# ── §1a — THE TABLE AND THE BAND ────────────────────────────────────────────

func _s1a_the_table() -> void:
	print("\n§1a — the severity-5 modifiers, and Ruin's gambles dealt from 5 alone")
	for id in FOUR:
		var cfg: Dictionary = (_run.MODIFIERS as Dictionary).get(id, {})
		ok(int(cfg.get("severity", 0)) >= 1 and String(cfg.get("name", "")) == String(FOUR[id][0]) and String(cfg.get("desc", "")) != "",
			"§1a: `%s` is not a modifier named %s with a rule and a grade (%s)" % [id, FOUR[id][0], str(cfg)])
	for id1 in REMOVED:
		ok(not (_run.MODIFIERS as Dictionary).has(id1), "§1a: `%s` (%s) is still in the deck — it was removed (IO §1, IP §1a)" % [id1, REMOVED[id1]])
	var counts := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	for id2 in _run.MODIFIERS:
		var sv0 := int(_run.modifier_severity(String(id2)))
		counts[sv0] = int(counts.get(sv0, 0)) + 1
	ok(counts == GRADE_COUNTS, "§1a: the grades hold %s — the bands are built on %s" % [str(counts), str(GRADE_COUNTS)])
	var at5 := _band_members([5, 5])
	print("    severity 5: %s; the grades at %s" % [str(at5), str(counts)])
	# THE BANDS: Ruin's gambles at 5 alone; no Wanderer or Warden band reaches a severity-5 modifier — asserted
	# directly over the data, not only through the means.
	var ruin_gb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary)["gamble_band"]
	var ruin_sb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary)["safe_band"]
	ok(ruin_gb == [5, 5] and ruin_sb == [3, 4], "§1a: Ruin's bands are %s / %s — want its safe slot at 3–4 and its gambles at 5 alone" % [
		str(ruin_sb), str(ruin_gb)])
	for d in ["wanderer", "warden"]:
		var reach: Array = []
		for k in ["safe_band", "gamble_band"]:
			for id3 in _band_members((_run.DIFFICULTIES[d] as Dictionary)[k]):
				if int(_run.modifier_severity(String(id3))) >= 5:
					reach.append(id3)
		ok(reach.is_empty(), "§1a: %s's bands reach a severity-5 modifier: %s" % [d, str(reach)])
	# NO BAND FALLS BACK AND NONE CAN BE EMPTY: Ruin's gambles hold enough for two drawn without replacement.
	ok(_band_members(ruin_gb).size() >= 2 and _band_members(ruin_sb).size() >= 1,
		"§1a: Ruin's gamble band holds %d, its safe band %d — two gambles and a safe slot cannot always be dealt" % [
			_band_members(ruin_gb).size(), _band_members(ruin_sb).size()])
	ok(_band_members(ruin_gb).all(func(i): return not _band_members(ruin_sb).has(i)),
		"§1a: Ruin's bands overlap — a gamble could be the safe pick's modifier")
	var arith := (_mean_sev(_band_members(ruin_sb)) + 2.0 * _mean_sev(_band_members(ruin_gb))) / 3.0
	print("    Ruin: safe %s (%d, mean %.2f), gambles %s (%d, mean %.2f) — arithmetic %.2f" % [str(ruin_sb),
		_band_members(ruin_sb).size(), _mean_sev(_band_members(ruin_sb)), str(ruin_gb), _band_members(ruin_gb).size(),
		_mean_sev(_band_members(ruin_gb)), arith])


# ── §1b — EP's SAMPLE, THROUGH THE REAL ROLL ────────────────────────────────

func _s1b_the_sample() -> void:
	print("\n§1b — EP's sample: 400 offers a rung through the real `roll_offer`, seeded, past the shop gate")
	var was := String(_run.difficulty)
	var was_slot := int(_run.slot_idx)
	_run.slot_idx = int(_run.SHOP_GATE_NODES) + 4
	var means := {}
	var mins := {}
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		seed(4004)
		var dealt: Array = []
		for _i in 400:
			dealt.append(_run.roll_offer())
		var dist := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
		var sum := 0
		var n := 0
		var lo := 99
		var sh := 0
		var shop_at := {}
		for offer in dealt:
			for opt in offer:
				var sev := int(_run.modifier_severity(String(opt["modifier"])))
				dist[sev] = int(dist.get(sev, 0)) + 1
				sum += sev
				n += 1
				lo = mini(lo, sev)
				if String((opt["reward"] as Dictionary).get("kind", "")) == "shop":
					sh += 1
					shop_at[sev] = true
		ok(n == 1200, "§1b: %s dealt %d options over 400 offers, want 1,200 — an offer came short" % [d, n])
		means[d] = float(sum) / maxf(float(n), 1.0)
		mins[d] = lo
		print("    %-8s mean severity %.2f — by severity 1-5 %d / %d / %d / %d / %d — the merchant on %d (at %s)" % [
			d, means[d], dist[1], dist[2], dist[3], dist[4], dist[5], sh, str(shop_at.keys())])
		if d != "ruin":
			ok(int(dist[5]) == 0, "§1b: %s dealt %d severity-5 options — Ruin's alone" % [d, dist[5]])
			# THE CONTROL: dealt offer for offer as IM dealt them — the twenty, the merchant at severity 1.
			var fl := int(((_run.DIFFICULTIES[d] as Dictionary)["safe_band"] as Array)[1])
			seed(4004)
			var same := 0
			var first_diff := -1
			for i in 400:
				if str(_im_offer(fl)) == str(dealt[i]):
					same += 1
				elif first_diff < 0:
					first_diff = i
			ok(same == 400, "§1b: %s's offers moved — %d of 400 dealt as IM dealt them (first to differ: #%d)" % [d, same, first_diff])
			print("             dealt as IM dealt it: %d of 400 offers" % same)
	_run.difficulty = was
	_run.slot_idx = was_slot
	var ruin_def: Dictionary = _run.DIFFICULTIES["ruin"]
	var want := (_mean_sev(_band_members(ruin_def["safe_band"])) + 2.0 * _mean_sev(_band_members(ruin_def["gamble_band"]))) / 3.0
	ok(float(means["ruin"]) >= float(means["warden"]) + 1.0,
		"§1b: Ruin reads %.2f against Warden's %.2f — not a full step above it" % [means["ruin"], means["warden"]])
	ok(absf(float(means["ruin"]) - want) < 0.10, "§1b: Ruin's sample reads %.2f against its bands' arithmetic %.2f" % [means["ruin"], want])
	ok(int(mins["ruin"]) >= 3, "§1b: Ruin dealt a severity-%d option — its safe slot opens at 3" % mins["ruin"])
	print("    Ruin above Warden by %.2f (the arithmetic %.2f); Warden above Wanderer by %.2f" % [
		float(means["ruin"]) - float(means["warden"]), want, float(means["warden"]) - float(means["wanderer"])])


# ── §1c — THE REWARD ROW: ONE STEP FURTHER ON THE TABLE's OWN LADDER ────────

func _s1c_the_reward_row() -> void:
	print("\n§1c — severity 5's reward: the ladder's next step on its own slope (RE-POINTED AT IO §0.7: the growing one)")
	var gold := {}
	for sv in [1, 2, 3, 4, 5]:
		for r in (_run.REWARDS.get(sv, []) as Array):
			if String((r as Dictionary).get("kind", "")) == "gold":
				gold[sv] = int((r as Dictionary).get("amount", 0))
	var steps: Array = []
	for sv2 in [2, 3, 4]:
		steps.append(int(gold.get(sv2, 0)) - int(gold.get(sv2 - 1, 0)))
	# IN took the largest existing step (80, so 300); IO §0.7 (the designer's) reads the steps' own growth — each twenty
	# more than the last — so the next is 100 and the row 320. Derived off the table, never typed.
	var growth := int(steps[2]) - int(steps[1])
	var big := int(steps[2]) + growth
	var regular: bool = steps.all(func(x): return int(x) == int(steps[0]))
	ok(gold.has(5) and int(steps[1]) - int(steps[0]) == growth and int(gold[5]) == int(gold.get(4, 0)) + big,
		"§1c: severity 5 pays %s gold — the ladder's steps are %s, growing by %d, so the next is %d and the row %d" % [
			str(gold.get(5, "none")), str(steps), growth, big, int(gold.get(4, 0)) + big])
	var k4: Array = (_run.REWARDS.get(4, []) as Array).map(func(r): return String(r.get("kind", "")))
	var k5: Array = (_run.REWARDS.get(5, []) as Array).map(func(r): return String(r.get("kind", "")))
	ok(k5 == k4, "§1c: severity 5 pays %s where severity 4 pays %s — the row is one step further, not a new kind" % [str(k5), str(k4)])
	print("    the gold reads %s, steps %s — %s; severity 5 takes the next, %d: %d gold or a rune" % [
		str([gold.get(1), gold.get(2), gold.get(3), gold.get(4)]), str(steps), "regular" if regular else "a growing slope",
		big, int(gold.get(5, 0))])


# ── §1d — THE FIXED ENCOUNTERS KEEP THE EIGHT THEY DREW ─────────────────────

func _s1d_the_fixed_band() -> void:
	print("\n§1d — Ruin's mini-boss and bosses draw their modifier from severity 3–4, as they always did")
	var was := String(_run.difficulty)
	var was_mod := String(_run.pending_modifier)
	_run.difficulty = "ruin"
	seed(51)
	var seen := {}
	for _i in 400:
		_run.pending_modifier = ""
		_run.arm_fixed_modifier("boss")
		seen[String(_run.pending_modifier)] = true
	_run.pending_modifier = was_mod
	_run.difficulty = was
	var want := _band_members([3, 4])
	var got: Array = seen.keys()
	got.sort()
	want.sort()
	ok(got == want, "§1d: 400 fixed draws at Ruin read %s — want the eight of severity 3–4, %s" % [str(got), str(want)])
	ok(not got.any(func(i): return int(_run.modifier_severity(String(i))) >= 5),
		"§1d: a fixed encounter drew a severity-5 modifier — a bargain's, priced with a reward it never pays")


# ── §1e — FAMINE: THE POUCH IS SEALED — RE-POINTED AT IO §1: FAMINE IS REMOVED, AND NO MODIFIER SEALS IT ──

func _s1e_famine() -> void:
	print("\n§1e — Famine is removed (IO §1): under every modifier the pouch opens, by the button, the picker and the use path")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {}, {"items": {"health": 2, "bomb": 1}})
	var h := _hero(s, "warrior") if s != null else null
	ok(s != null and h != null, "§1e: the board seats a Warrior")
	if s == null or h == null:
		await _clear(s)
		return
	(s.get("action_panel") as Control).visible = true
	var sealed: Array = []
	var ids: Array = [""] + (_run.MODIFIERS as Dictionary).keys()
	for mid in ids:
		_run.pending_modifier = String(mid)
		s.set("item_used", false)
		s.set("current_hero", h)
		(s.get("action_panel") as Control).visible = true
		var b0: Button = s.call("_build_items_menu")
		var lit := not b0.disabled
		b0.free()
		s.call("_open_item_picker")
		var opened: bool = s.get("_item_picker") != null
		s.call("_close_item_picker")
		if not (lit and opened):
			sealed.append("'%s' (button %s, picker %s)" % [mid, lit, opened])
	ok(sealed.is_empty() and ids.size() == (_run.MODIFIERS as Dictionary).size() + 1 and ids.size() >= 20,
		"§1e: the pouch was sealed under %s of %d fights' terms" % [str(sealed), ids.size()])
	var b := _src("scripts/battle.gd")
	ok(not b.contains("_pouch_sealed") and not b.contains("\"famine\""), "§1e: Famine's door is still in `battle.gd`")
	# THE USE PATH asks the stock and the turn's one item, nothing about the fight's terms (it awaits a target pick for a
	# potion, so it is read where it stands rather than driven headless).
	ok(_body("scripts/battle.gd", "_use_item").contains("if not items.has(item_id) or items[item_id][1] <= 0 or item_used:"),
		"§1e: `_use_item`'s guard asks something beyond the stock and the turn's one item")
	var pt := _body("scripts/battle.gd", "_player_turn")
	var drink := pt.substr(pt.find("autoplay and RunSim.active and RunSim.items_on"), 200)
	ok(drink.contains("items[\"health\"]") and not drink.contains("_pouch"), "§1e: the bot's drink still asks a sealed pouch")
	await _clear(s)


# ── §1f — WASTING: A CLOCK ON THE FIGHT ─────────────────────────────────────

func _s1f_wasting() -> void:
	print("\n§1f — Wasting: whoever took the turn loses its share of its maximum (both sides since IO §1); no ward, armor or Less Damage Taken reaches it")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	var h := _hero(s, "warrior") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and not foes.is_empty(), "§1f: the board seats a Warrior and a warband")
	if s == null or h == null or foes.is_empty():
		await _clear(s)
		return
	h.max_hp = 1000
	h.hp = 900
	# THE NEGATIVE ARM: no modifier, nothing lost.
	_run.pending_modifier = ""
	ok(not bool(s.call("_wasting_tick", h)) and h.hp == 900, "§1f: with no modifier Wasting took %d" % (900 - h.hp))
	# EVERY DEFENCE A STRIKE MEETS, ON HIM: a barrier, armor, Less Damage Taken.
	s.call("_apply_status", h, "barrier", 3, 500)
	h.armor = 0.6
	h.dmg_taken_bonus = 0.5
	_run.pending_modifier = "wasting"
	var was_src: Variant = s.get("_dmg_src")
	var want := maxi(int(round(1000 * float(_run.WASTING_PCT))), 1)
	var died: bool = s.call("_wasting_tick", h)
	ok(not died and 900 - h.hp == want,
		"§1f: under Wasting a hero of 1,000 with a barrier, 60%% armor and Less Damage Taken lost %d — want %d (%d%%)" % [
			900 - h.hp, want, int(round(float(_run.WASTING_PCT) * 100))])
	ok(h.get_status("barrier").get("power", 0) == 500, "§1f: Wasting ate into the barrier — it is not a strike")
	ok(s.get("_dmg_src") == was_src, "§1f: the tick left its frame standing")
	# BOTH SIDES SINCE IO §1 (AQ's rule): an enemy's turn's end costs it its share as a hero's does.
	var e: BattleUnit = foes[0]
	var e_hp := e.hp
	var e_want := maxi(int(round(e.max_hp * float(_run.WASTING_PCT))), 1)
	s.call("_wasting_tick", e)
	ok(e_hp - e.hp == mini(e_want, e_hp), "§1f: Wasting took %d from an enemy — want %d (both sides since IO §1)" % [e_hp - e.hp, e_want])
	# A TURN THAT WON THE FIGHT ENDS NOTHING: with the warband down the clock has stopped.
	var hp_won := h.hp
	var alive_now: Array = foes.filter(func(x): return not (x as BattleUnit).dead)
	for x in alive_now:
		(x as BattleUnit).dead = true
	ok(not bool(s.call("_wasting_tick", h)) and h.hp == hp_won, "§1f: Wasting took %d on the turn that won the fight" % (hp_won - h.hp))
	for x in alive_now:
		(x as BattleUnit).dead = false
	# IT CAN FELL A HERO, AS A TICK CAN.
	h.hp = 3
	h.remove_status("barrier")
	ok(bool(s.call("_wasting_tick", h)) and h.dead, "§1f: a hero at 3 health under Wasting did not fall")
	# EVERY PLACE A TURN ENDS CALLS IT: the hero's turn, the enemy's (since IO §1), and a turn a stun, a freeze or a Break
	# cost either side.
	var rb := _body("scripts/battle.gd", "_run_battle")
	ok(rb.count("_wasting_tick(u)") == 5, "§1f: `_run_battle` calls the tick %d times, want 5 (the hero's turn, the enemy's, stunned, frozen, Broken)" % rb.count("_wasting_tick(u)"))
	ok(_body("scripts/battle.gd", "_wasting_tick").contains("take_tick_damage("),
		"§1f: Wasting does not go through the tick door")
	await _clear(s)


# ── §1g — THE HUNGERING DARK — RE-POINTED AT IP §1a: IT IS REMOVED, AND NO DEALER IS FED ──
#
# IN built the Dark to feed the warband; IO fed both sides; IP removed it — two-sidedness did not make it even, the heroes
# dealing about six times what a warband does. The arms are IN's, re-pointed as §1e's and §1h's were for the two IO removed:
# under the id a pre-IP save can carry, no dealer on either side is fed, a tick feeds nobody, and the door is gone where it
# acted — BL's damage door calls no feed, and the heal door takes no third parameter.
func _s1g_the_hungering_dark() -> void:
	print("\n§1g — the Hungering Dark is removed (IP §1a): under its id no dealer is fed, and its doors are gone")
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	var h := _hero(s, "warrior") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and foes.size() >= 2, "§1g: the board seats a Warrior and two enemies")
	if s == null or h == null or foes.size() < 2:
		await _clear(s)
		return
	var e: BattleUnit = foes[0]
	e.max_hp = 1000
	h.max_hp = 5000
	h.armor = 0.0
	# [the fight's terms, the dealer]: no modifier, and the removed id under an enemy dealer and a hero dealer.
	for arm in [["", e], ["hungering_dark", e], ["hungering_dark", h]]:
		e.hp = 500
		h.hp = 4000
		_run.pending_modifier = String(arm[0])
		var dealer: BattleUnit = arm[1]
		var victim: BattleUnit = h if dealer == e else e
		s.call("_dmg_frame", dealer, "probe")
		var d_before := dealer.hp
		var v_before := victim.hp
		victim.take_tick_damage(200, "-200", Color.WHITE)
		ok(v_before > victim.hp and dealer.hp == d_before, "§1g: terms '%s', %s dealing %d to %s was fed %d — want none" % [
			arm[0], dealer.unit_name, v_before - victim.hp, victim.unit_name, dealer.hp - d_before])
	ok(not (_run.MODIFIERS as Dictionary).has("hungering_dark") and _run.get("HUNGERING_DARK_PCT") == null,
		"§1g: the Dark's row or its constant still stands")
	s.call("_dmg_frame", null, "")
	ok(not _body("scripts/battle.gd", "_on_damage_taken").contains("_dark_feeds(") and _body("scripts/battle.gd", "_dark_feeds") == ""
			and _src("scripts/unit.gd").contains("func heal_amount(amount: int, external := false) -> int:"),
		"§1g: the feed is still at BL's door, or the heal door still takes the Dark's third parameter")
	_run.pending_modifier = ""
	await _clear(s)


# ── §1h — CRUEL ORDER — RE-POINTED AT IO §1: IT IS REMOVED, AND THE TURN ORDER IS `next_time` UNDER EVERY MODIFIER ──

func _s1h_cruel_order() -> void:
	print("\n§1h — Cruel Order is removed (IO §1): under every modifier the loop and the bar order turns by the timeline alone")
	var s: Node = await _board(["warden", "pyromancer", "holy", "sharpshooter"], {})
	var h := _hero(s, "warrior") if s != null else null
	var foes := _foes(s) if s != null else []
	ok(s != null and h != null and not foes.is_empty(), "§1h: the board seats a Warrior and a warband")
	if s == null or h == null or foes.is_empty():
		await _clear(s)
		return
	var e: BattleUnit = foes[0]
	for u in (s.get("heroes") as Array) + (s.get("enemies") as Array):
		(u as BattleUnit).next_time = 1000.0
	# The hero due first, the enemy a hair later: the hero acts first whatever the fight's terms.
	h.next_time = 0.3
	e.next_time = 1.5
	var out: Array = []
	for mid in [""] + (_run.MODIFIERS as Dictionary).keys():
		_run.pending_modifier = String(mid)
		if s.call("_next_unit") != h:
			out.append(String(mid))
	ok(out.is_empty(), "§1h: the hero due first did not act first under %s" % str(out))
	var b := _src("scripts/battle.gd")
	ok(not b.contains("_turn_before") and not b.contains("ROUND_TICKS") and not b.contains("\"cruel_order\""),
		"§1h: Cruel Order's door or its round is still in `battle.gd`")
	ok(_body("scripts/battle.gd", "_next_unit").contains("if u.next_time < best.next_time:")
			and _body("scripts/battle.gd", "_rebuild_turn_bar").contains("if entry.t < best.t:"),
		"§1h: the loop and the bar do not both order turns by the timeline alone")
	_run.pending_modifier = ""
	await _clear(s)


# ── §1i — THE WORDS ─────────────────────────────────────────────────────────

func _s1i_the_words() -> void:
	print("\n§1i — the text of IN's four that stands, and the rung texts read against the band")
	for id in FOUR:
		var desc := String((_run.MODIFIERS[id] as Dictionary)["desc"])
		var konst := String(FOUR[id][1])
		if konst != "":
			var fig := "%d%%" % int(round(float(_run.get(konst)) * 100))
			ok(desc.contains(fig), "§1i: `%s` does not state %s off `%s`: '%s'" % [id, fig, konst, desc])
		var low := " " + desc.to_lower() + " "
		var pron: Array = [" his ", " her ", " he ", " she ", " him ", " their ", " they "].filter(func(w): return low.contains(w))
		var retired: Array = ["party", "ally", "allies", "beast"].filter(func(w): return low.contains(" " + w))
		ok(pron.is_empty() and retired.is_empty(), "§1i: `%s` carries %s — '%s'" % [id, str(pron + retired), desc])
	var sev := String(Glossary.entry("severity").get("long", ""))
	# II §0.7: a figure the text types is asserted against the table that decides it — severity 5's gold, read off REWARDS.
	var g5 := 0
	for r in (_run.REWARDS.get(5, []) as Array):
		if String((r as Dictionary).get("kind", "")) == "gold":
			g5 = int((r as Dictionary).get("amount", 0))
	ok(sev.contains("severity of 1 to 5") and sev.contains("a 5 pays %d gold or a rune" % g5),
		"§1i: the severity entry does not state five severities and severity 5's reward (%d gold or a rune)" % g5)
	ok(sev.contains("its gambles at 5 alone") or sev.contains("gambles at {=Run.DIFFICULTIES.ruin.gamble_band.0} alone"),
		"§1i: the severity entry does not say Ruin's gambles are dealt at 5")
	ok(sev.contains("the mildest severity the road deals"), "§1i: the severity entry still pins the merchant to severity 1")
	# RE-POINTED AT IO §1: the entry goes back to AQ's rule — every modifier binds both sides, nothing binds one — and names
	# neither of the two IO removed.
	var mod_e := String(Glossary.entry("modifier").get("long", ""))
	ok(mod_e.contains("EVERY MODIFIER BINDS BOTH SIDES") and not mod_e.contains("bind one side -")
			and not mod_e.contains("Famine") and not mod_e.contains("Cruel Order"),
		"§1i: the modifier entry says something binds one side, or names a modifier IO removed")
	var lad := String(Glossary.entry("difficulty_ladder").get("long", ""))
	ok(lad.contains("severity 5"), "§1i: the ladder entry does not say Ruin's gambles are severity 5")
	# RE-POINTED AT IO §2: each of IN's two that stayed has its row at the grade the table gives it now, and the two removed
	# have none.
	var mh := FileAccess.get_file_as_string("res://docs/master.html")
	var missing: Array = []
	for id2 in FOUR:
		if not mh.contains("<td>%s</td><td>%d</td>" % [String(FOUR[id2][0]), int(_run.modifier_severity(String(id2)))]):
			missing.append(FOUR[id2][0])
	for id3 in REMOVED:
		if mh.contains("<td>%s</td>" % String(REMOVED[id3])):
			missing.append("%s (removed)" % REMOVED[id3])
	ok(missing.is_empty(), "§1i: `master.html`'s modifier table has no row at its grade for %s" % str(missing))


# ── §2 — THE MERCHANT ───────────────────────────────────────────────────────

func _s2_the_merchant() -> void:
	print("\n§2 — the merchant is the reward of a rung's mildest dealt severity")
	var held: Array = []
	for sv in _run.REWARDS:
		for r in _run.REWARDS[sv]:
			if String((r as Dictionary).get("kind", "")) == "shop":
				held.append(int(sv))
	ok(held.is_empty(), "§2: the table holds the merchant at severity %s — it is no severity's row" % str(held))
	var was := String(_run.difficulty)
	var mild := {}
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		# THE MILDEST DEALT, DERIVED HERE OFF THE BANDS: the lowest severity of any modifier in either band.
		var lo := 99
		for k in ["safe_band", "gamble_band"]:
			for id in _band_members((_run.DIFFICULTIES[d] as Dictionary)[k]):
				lo = mini(lo, int(_run.modifier_severity(String(id))))
		mild[d] = lo
		ok(int(_run.mildest_dealt_severity()) == lo, "§2: %s's mildest dealt severity reads %d — its bands say %d" % [
			d, _run.mildest_dealt_severity(), lo])
		var at: Array = []
		for sv2 in [1, 2, 3, 4, 5]:
			if (_run.rewards_for(sv2) as Array).any(func(r): return String((r as Dictionary).get("kind", "")) == "shop"):
				at.append(sv2)
		ok(at == [lo], "§2: on %s the merchant pays at severity %s — want its mildest dealt, %d, alone" % [d, str(at), lo])
		var ord: Array = (_run.rewards_for(lo) as Array).map(func(r): return String((r as Dictionary).get("kind", "")))
		ok(ord.size() >= 2 and String(ord[ord.size() - 1]) == "shop" and String(ord[0]) == "gold",
			"§2: on %s the mildest severity pays %s — the merchant stands behind the gold, where HW put it" % [d, str(ord)])
	_run.difficulty = was
	print("    the mildest dealt severity: Wanderer %d, Warden %d, Ruin %d" % [mild["wanderer"], mild["warden"], mild["ruin"]])
	# READ OFF THE BANDS, NEVER OFF THE RUNG's NAME.
	for fn in ["mildest_dealt_severity", "rewards_for"]:
		var b := _body("scripts/run_state.gd", fn)
		ok(b != "" and not b.contains("\"ruin\"") and not b.contains("\"warden\"") and not b.contains("\"wanderer\"")
				and not b.contains("difficulty_rung") and not b.contains("\"name\""),
			"§2: `%s` names a rung — the merchant is read off the bands" % fn)
	ok(_body("scripts/run_state.gd", "roll_offer").contains("var choices: Array = rewards_for(sev)"),
		"§2: `roll_offer` does not read its rewards through `rewards_for`")
	# THE SAMPLE: Ruin pays merchants now, at its mildest; none at any rung in the run's first three nodes.
	var was_slot := int(_run.slot_idx)
	var counts := {}
	for d2 in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d2
		for gated in [false, true]:
			_run.slot_idx = 0 if gated else int(_run.SHOP_GATE_NODES) + 4
			seed(4004)
			var sh := 0
			var sevs := {}
			for _i in 400:
				for opt in _run.roll_offer():
					if String((opt["reward"] as Dictionary).get("kind", "")) == "shop":
						sh += 1
						sevs[int(_run.modifier_severity(String(opt["modifier"])))] = true
			counts["%s%s" % [d2, " gated" if gated else ""]] = sh
			if gated:
				ok(sh == 0, "§2: %s paid %d merchants in the run's first three nodes" % [d2, sh])
			else:
				ok(sevs.keys().all(func(v): return int(v) == int(mild[d2])),
					"§2: %s paid the merchant at severities %s — want %d alone" % [d2, str(sevs.keys()), mild[d2]])
	_run.difficulty = was
	_run.slot_idx = was_slot
	ok(int(counts["ruin"]) > 0, "§2: Ruin paid no merchant in 1,200 options")
	print("    merchants in 1,200 options past the gate: Wanderer %d, Warden %d, Ruin %d (gated: %d / %d / %d)" % [
		counts["wanderer"], counts["warden"], counts["ruin"], counts["wanderer gated"], counts["warden gated"], counts["ruin gated"]])


# ── §3 — THE BOT PAYS THE PRICE THE DOOR CHARGES ────────────────────────────

func _s3_the_bots_price() -> void:
	print("\n§3 — the bot's rotation and the enemy's choice read the effective price")
	# THE CENSUS: no list price compared with a resource in `battle.gd` (IM §3a's sweep, the same expression).
	var rx := RegEx.new()
	rx.compile("\\w+\\.cost\\s*[<>]=?\\s*\\w+\\.resource|\\w+\\.resource\\s*[<>]=?\\s*\\w+\\.cost\\b|\\w+\\.resource\\s*>=\\s*\\w+\\.cost\\s*\\+")
	var by_fn := {}
	var fn := ""
	var lines := _src("scripts/battle.gd").split("\n")
	for line in lines:
		if String(line).begins_with("func "):
			fn = String(line).substr(5, String(line).find("(") - 5)
		if rx.search(String(line)) != null:
			by_fn[fn] = int(by_fn.get(fn, 0)) + 1
	ok(by_fn.is_empty(), "§3: list prices compared with a resource are left in `battle.gd`: %s" % str(by_fn))
	var kit := _body("scripts/battle.gd", "_autoplay_pick_kit")
	ok(kit.count("u.resource >= _eff_cost(u, ") >= 55 and kit.contains("u.resource >= _eff_cost(u, prison) + _eff_cost(u, lance)"),
		"§3: the rotation reads %d effective prices, want the 55 IM counted (the Cryomancer's two together among them)" % kit.count("u.resource >= _eff_cost(u, "))
	for pair in [["_intent_ability_usable", "if _eff_cost(u, ab) > u.resource:"], ["_choose_enemy_action", "_eff_cost(u, a) <= u.resource"],
			["_psychotic_support", "if _eff_cost(u, a) > u.resource:"]]:
		ok(_body("scripts/battle.gd", String(pair[0])).contains(String(pair[1])), "§3: `%s` does not test the effective price" % pair[0])
	print("    list-price reads left: %d; the rotation's effective reads: %d" % [by_fn.size(), kit.count("u.resource >= _eff_cost(u, ")])
	# THE DRIVE: under Warded, every lineage's whole pick at every resource level is one the door would let it pay.
	var payable := 0
	var asked := 0
	var bad: Array = []
	for party in [["berserker", "pyromancer", "holy", "beastmaster"], ["warden", "cryomancer", "inquisitor", "mystic"],
			["swordmaster", "arcanist", "occultist", "sharpshooter"]]:
		var s: Node = await _board(party, {}, {"lineage_cards": true})
		if s == null:
			ok(false, "§3: a board for %s did not spawn" % str(party))
			continue
		var foes := _foes(s)
		for k in foes.size():
			(foes[k] as BattleUnit).hp = int((foes[k] as BattleUnit).max_hp * (0.9 - 0.25 * k))
		for h in s.get("heroes"):
			var hu: BattleUnit = h
			if hu.is_companion or hu.resource_name == "":
				continue
			hu.mod_cost_mult = 1.25
			hu.cooldowns.clear()
			seed(77)
			for res in range(0, hu.max_resource + 1, 2):
				hu.resource = res
				var pick: Array = s.call("_autoplay_pick", hu)
				asked += 1
				if pick.is_empty() or pick[0] == null:
					payable += 1
					continue
				var ab: Ability = pick[0]
				var eff := int(s.call("_eff_cost", hu, ab, pick[1] if pick.size() > 1 else null))
				if eff <= hu.resource:
					payable += 1
				elif bad.size() < 6:
					bad.append("%s (%s) at %d: %s, list %d, the ward's %d" % [hu.unit_name, hu.hero_spec if "hero_spec" in hu else "",
						res, ab.display_name, ab.cost, eff])
			hu.mod_cost_mult = 1.0
		await _clear(s)
	ok(asked > 300 and payable == asked, "§3: under Warded %d of %d bot picks were cards the door would not let him pay: %s" % [
		asked - payable, asked, str(bad)])
	print("    under Warded: %d bot picks over twelve lineages, every resource level in steps of two — %d payable" % [asked, payable])
	# THE ENEMY's SIDE: an enemy pays through the same spend line, and the ward stamps the warband too.
	var s2: Node = await _board(["warden", "pyromancer", "holy", "mystic"], {})
	var e: BattleUnit = _foes(s2)[0] if s2 != null and not _foes(s2).is_empty() else null
	if e != null:
		var a: Ability = e.abilities[0]
		var was_cost := a.cost
		a.cost = 30
		e.resource = 30
		e.mod_cost_mult = 1.25
		var warded_ok: bool = s2.call("_intent_ability_usable", e, a)
		e.mod_cost_mult = 1.0
		var plain_ok: bool = s2.call("_intent_ability_usable", e, a)
		ok(not warded_ok and plain_ok, "§3: an enemy holding 30 for a 30-cost ability: warded usable %s (the ward's price %d), unwarded %s" % [
			warded_ok, maxi(int(round(30 * 1.25)), 1), plain_ok])
		a.cost = was_cost
	else:
		ok(false, "§3: the enemy board did not spawn")
	await _clear(s2)
	# WHICH ENEMIES PAY A PRICE AT ALL: read off the data.
	var foes_d: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var costed: Array = []
	for kind in foes_d:
		for fa in (foes_d[kind] as Dictionary).get("abilities", []):
			if int((fa as Dictionary).get("cost", 0)) > 0 and not costed.has(kind):
				costed.append(kind)
	print("    enemies whose abilities carry a price: %s" % str(costed))


# ── §4 — THE PICKS NAMED ────────────────────────────────────────────────────

# IM's census rows that named their pick in no FAIL line (N) or in some (P): [site, gate, the function whose FAIL lines
# are about the pick, the string that names it, the function that builds it]. Each builds the string and its FAIL lines
# carry it; that a FAIL line PRINTS its pick is shown by IN's controls, one a site (the report, §4).
const NAMED := [
	["A2", "check_ia.gd", "_s3_the_panel", "cap_pick", ""],
	["A3", "check_ia.gd", "_s6_the_card_line", "widest", ""],
	["A5", "check_gt.gd", "_s1_the_pouch", "label", ""],
	["A6", "check_gt.gd", "_s1_a_bag_of_twenty", "label", ""],
	["A7", "check_gt.gd", "_s2_the_peddler", "dl", ""],
	["A8", "check_ib.gd", "_s4_the_scroll", "longest_pick", ""],
	["A10", "check_ih.gd", "_s6_nothing_over_anything", "_longest_intents", "_walk_field"],
	["A11", "check_hu.gd", "_s1_the_bar_pages", "widest_pick", ""],
	["A16", "check_fn.gd", "_s4_on_a_failing_loadout", "bar_pick", ""],
	["B2", "check_ds.gd", "_fallback", "better_pick", ""],
	["B4", "check_eh.gd", "_s3_the_record", "pick_s", ""],
	["B7", "check_ew.gd", "_s3_not_focus", "pick_s", ""],
	["B8", "check_fe.gd", "_s2c_upgrade_choice", "pick_s", ""],
	["B9", "check_fh.gd", "_s4_bench_a_condition", "pick_s", ""],
	["B10", "check_fh.gd", "_s5_the_pouch", "pick_s", ""],
	["B11", "check_fh.gd", "_s7_the_skill_check", "gated_pick", ""],
	["B12", "check_ft.gd", "_s2_momentum", "pick_s", ""],
	["B14", "check_gf.gd", "_s1_to_s4_the_elite", "pick_s", ""],
	["B16", "check_gx.gd", "_s3_the_three_surfaces", "unworn_s", ""],
	["B18", "check_gx.gd", "_s4_the_pouch_with_six_held", "pick_s", ""],
	["B19", "check_gx.gd", "_s6_nothing_was_retuned", "pick_s", ""],
	["B23", "check_hk.gd", "_s3_the_peddler", "live_s", ""],
	["B24", "check_hk.gd", "_s3_the_peddler", "o0_s", ""],
	["B26", "check_hl.gd", "_s1c_the_purchase", "buy_pick", ""],
	["B27", "check_ho.gd", "_s1b_the_drop", "class_pick", ""],
	["B29", "check_ho.gd", "_s6_the_blacksmith_arm", "up_pick", ""],
	["B31", "check_hz.gd", "_s0_the_carried_half", "rider_pick", ""],
	["B32", "check_ie.gd", "_s4_each_surface", "rune_pick", ""],
	["B33", "check_ie.gd", "_s5a_the_refill", "spare_pick", ""],
	["B36", "check_id.gd", "_s3c_the_passive_and_the_relics", "relic_pick", ""],
	["B37", "check_ib.gd", "_s2d_the_crest", "crest_pick", ""],
	["B38", "test_batch_bk.gd", "_section_blacksmith", "bought_pick", ""],
	["B39", "test_batch_bs.gd", "_live_ash_lung", "det_pick", ""],
	["B40", "test_batch_ai.gd", "_hooks", "kit_piece_pick", ""],
]


func _s4_the_picks_named() -> void:
	print("\n§4 — the census's sites that did not name their pick in every FAIL line build the string that names it")
	var checked := 0
	var missing: Array = []
	for row in NAMED:
		var b := _body(String(row[1]), String(row[2]))
		var v := String(row[3])
		var builder := _body(String(row[1]), String(row[4])) if String(row[4]) != "" else b
		var built := builder.contains("var %s := " % v) or builder.contains("var %s: String = " % v) \
			or builder.contains("%s.append(" % v) or builder.contains("%s = " % v)
		# Built once and read again: the string reaches at least one line past where it is made.
		var read := b.count(v) >= (1 if String(row[4]) != "" else 2)
		if b == "" or not built or not read:
			missing.append("%s (%s %s: built %s, read %s)" % [row[0], row[1], row[2], built, read])
		checked += 1
	ok(missing.is_empty(), "§4: sites whose pick is not named: %s" % str(missing))
	ok(NAMED.size() == 34, "§4: the census names %d sites — IM's 23 none and 11 some are 34" % NAMED.size())
	print("    CHECKED %d of %d named sites" % [checked, NAMED.size()])


# ── §0 — THE RULINGS RECORDED ───────────────────────────────────────────────

func _s0_rulings() -> void:
	print("\n§0 — §0.7's note and the merchant's rule, recorded")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var note := "## STANDING RULE — A DRIVE IS A PROOF OF THE PREDICATE ONLY WHEN THE PREDICATE CHOOSES WHAT IT DRIVES (Batch IN §0.7"
	ok(ir.count(note) == 1, "§0.7: `docs/instrument-rules.md` heads the note %d times, want once" % ir.count(note))
	# Its index row in `CLAUDE.md` is `check_hx` §1a's to hold: a needle on an index row is satisfied by the index alone
	# (`check_ff` §4), so this gate pins the rule where it lives.
	ok(cm.count("THE MERCHANT IS THE REWARD OF A RUNG's MILDEST DEALT SEVERITY") >= 1,
		"§2: `CLAUDE.md` does not state the merchant's rule")


# ── §9 — THE PLAYER's FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
